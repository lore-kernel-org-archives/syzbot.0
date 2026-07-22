Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4773833FE05
	for <syzbot@lists.linux.dev>; Wed, 22 Jul 2026 17:46:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784742371; cv=none; b=pMe3JhYlgmkdyTB2CZBSp4fkr6tiWYz8aM0VxVPAG7RG3EeRtVFy4hbQp9OHg/mBxFfsm/tn72LEF1vaMRs+fYFUf7H52GLNFsNk1VcrZymXOdOTNwK4vzb6TVKSez4yGi8fmsY6UrGwhBTp5rB+M9Na3PjTCJWK6KL1udp60Jw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784742371; c=relaxed/simple;
	bh=Vx6oAz5XSNODFwg3syopa7OSe7ghVs/nX8iPVhr11zw=;
	h=From:To:Cc:Subject:Message-ID:MIME-Version:Content-Type:Date; b=if+LT80/v3cPxXUiS5bgrDlx99WCg0xKBvHLQmWaijsh5w3ZeBqqIwr1dp9uidb4AZzod5LF7KkoCw52hzwXzFM8CR4H/DXz69t1CxCcgN/84qsPeyUw1ulwrKR366i7kMbPAkhrohiSqaXcMQgVFD8keYFErzCQFLAXneyt0aQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=e59KlRiJ; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="e59KlRiJ"
Received: by smtp.kernel.org (Postfix) with UTF8SMTPSA id 178C61F000E9;
	Wed, 22 Jul 2026 17:46:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1784742368;
	bh=mxBtKiQL+MnPwi40v3afdrl95BXTGiK5Yd2i8B/vkTs=;
	h=From:To:Cc:Subject:Date;
	b=e59KlRiJCCjy/j5CqBhT1Yhxj7LY7eKRinLL/NLVYiQnzpMsmxMasxI++kmH+YxzB
	 r04tey8fuIB5o6DnWJ6rwOvDnIJUOnAS4HqwUtux3d+irkHnoraXFrTSUS/L6RtFuE
	 auXaiPPiXkYCvnu2KrMinfnuFTOmdjLknjsFRg5Mi83fmh0pxut2uC6LjzmnNMiHG7
	 l15bvNcXDfIr0POC2bF1d1iUYj0PzoUDrxAcUJYcxHwkRuyip3y4ZUH6L4E5Ac1SGk
	 IZlYv+UEg8c5YlGeiRaflJsHt0MJchC7182jVdO70jm4V7Pfu52TEoNazsCd7VUGH3
	 D39LTBEHxLlvQ==
From: "syzbot" <syzbot@kernel.org>
To: syzkaller-upstream-moderation@googlegroups.com
Cc: syzbot@lists.linux.dev
Subject: [PATCH RFC] Input: yealink - abort URB submission on fatal errors
Message-ID: <57cf484d-3235-473f-a61d-570585626176@mail.kernel.org>
Precedence: bulk
X-Mailing-List: syzbot@lists.linux.dev
List-Id: <syzbot.lists.linux.dev>
List-Subscribe: <mailto:syzbot+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:syzbot+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Date: Wed, 22 Jul 2026 17:46:08 +0000 (UTC)

The yealink driver uses two URBs (interrupt and control) to communicate
with the device. When an URB completes with an error status (such as
-EPROTO), the completion handlers (urb_irq_callback and urb_ctl_callback)
log the error but do not abort. Instead, they proceed to process the
potentially invalid data and unconditionally resubmit the URB.

Because control URBs are not rate-limited by the USB core, resubmitting a
failing control URB in a tight loop floods the console with error messages
and keeps the CPU completely busy in the softirq context. This eventually
triggers an RCU preempt stall:

yealink 3-1:36.0: unexpected response 0
yealink 3-1:36.0: urb_ctl_callback - urb status -71
rcu: INFO: rcu_preempt self-detected stall on CPU
Call Trace:
 __console_flush_and_unlock kernel/printk/printk.c:3373 [inline]
 console_unlock+0xd1/0x1c0 kernel/printk/printk.c:3413
 dev_vprintk_emit+0x338/0x400 drivers/base/core.c:4996
 dev_printk_emit+0xee/0x140 drivers/base/core.c:5007
 usb_generic_driver_probe+0x10b/0x150 drivers/usb/core/generic.c:252
 ...
 hub_event+0x28e8/0x4d30 drivers/usb/core/hub.c:5953
 worker_thread+0x92d/0xe10 kernel/workqueue.c:3486
 kthread+0x388/0x470 kernel/kthread.c:436

Fix this by explicitly checking the URB status for fatal errors (-ENOENT,
-ECONNRESET, -ESHUTDOWN, -EPROTO, -EPIPE, -EILSEQ) in both
urb_irq_callback() and urb_ctl_callback(). If a fatal error is detected,
the callback now returns early, breaking the infinite resubmission loop and
preventing the RCU stall.

Fixes: aca951a22a1d ("[PATCH] input-driver-yealink-P1K-usb-phone")
Assisted-by: Gemini:gemini-3.5-flash Gemini:gemini-3.1-pro-preview syzbot
Reported-by: syzbot+78e2288f58b881ed3c45@syzkaller.appspotmail.com
Closes: https://syzkaller.appspot.com/bug?extid=78e2288f58b881ed3c45
Link: https://syzkaller.appspot.com/ai_job?id=6ef5721d-1286-4deb-85e1-d7201e028127
To: "Henk Vergonet" <Henk.Vergonet@gmail.com>
To: "Dmitry Torokhov" <dmitry.torokhov@gmail.com>
To: <linux-input@vger.kernel.org>
Cc: <linux-kernel@vger.kernel.org>

---
diff --git a/drivers/input/misc/yealink.c b/drivers/input/misc/yealink.c
index 560f895a0..232d8e71b 100644
--- a/drivers/input/misc/yealink.c
+++ b/drivers/input/misc/yealink.c
@@ -405,9 +405,21 @@ static void urb_irq_callback(struct urb *urb)
 	struct yealink_dev *yld = urb->context;
 	int ret, status = urb->status;
 
-	if (status)
+	if (status) {
 		dev_err(&yld->intf->dev, "%s - urb status %d\n",
 			__func__, status);
+		switch (status) {
+		case -ENOENT:
+		case -ECONNRESET:
+		case -ESHUTDOWN:
+		case -EPROTO:
+		case -EPIPE:
+		case -EILSEQ:
+			return;
+		default:
+			break;
+		}
+	}
 
 	switch (yld->irq_data->cmd) {
 	case CMD_KEYPRESS:
@@ -443,9 +455,21 @@ static void urb_ctl_callback(struct urb *urb)
 	struct yealink_dev *yld = urb->context;
 	int ret = 0, status = urb->status;
 
-	if (status)
+	if (status) {
 		dev_err(&yld->intf->dev, "%s - urb status %d\n",
 			__func__, status);
+		switch (status) {
+		case -ENOENT:
+		case -ECONNRESET:
+		case -ESHUTDOWN:
+		case -EPROTO:
+		case -EPIPE:
+		case -EILSEQ:
+			return;
+		default:
+			break;
+		}
+	}
 
 	switch (yld->ctl_data->cmd) {
 	case CMD_KEYPRESS:


base-commit: 1590cf0329716306e948a8fc29f1d3ee87d3989f
-- 
This is an AI-generated patch subject to moderation.
Reply with '#syz upstream' to Sign-off the patch as a human author
and send it to the upstream kernel mailing lists.
Reply with '#syz reject' to reject it ('#syz unreject' to undo).

See https://goo.gle/syzbot-ai-patches for information about AI-generated patches.
You can comment on the patch as usual, syzbot will try to address
the comments and send a new version of the patch if necessary.
syzbot engineers can be reached at syzkaller@googlegroups.com.
