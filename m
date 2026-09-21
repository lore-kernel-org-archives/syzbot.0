Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9664A457E42
	for <syzbot@lists.linux.dev>; Mon, 21 Sep 2026 08:46:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789980401; cv=none; b=tFd8BNtYHVrtuzh3eJUkw6K5C208K9gAcF5gYSrHAttUES8sjohBHHTJk5LKZXjgHKIrR/4gpdaVWypXE8pkU4e4xNXnMqkNFp14Cgao3EZjKktEH0ab1sR/Pb+493/DR2yIHhT2K8Nn9cEPa0090k1XPhGKtsgfiIcg+Ycylbk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789980401; c=relaxed/simple;
	bh=MXLfhaKNtKnD80AuSWsUndy/Vh6VARWVFFZUly4P0Dc=;
	h=From:To:Cc:Subject:Message-ID:MIME-Version:Content-Type:Date; b=jH8KCLwnxqUhCtkqNe0uB6NKEQGqseyQxEhu/E3PEqScD0LESx88+gfS5YjAOxtSZr9EQL07FxYr4C75WPgA7r3Y+XagSwHZwTTcvhQBeLdMReHZBPGHxQHbqspN/viEpnX4Pv1yxAcqF1+HfqPrZhEqBXfQEZKAtfedFB3Q7iQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Mz3YqCE5; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Mz3YqCE5"
Received: by smtp.kernel.org (Postfix) with UTF8SMTPSA id 0C6A01F000FF;
	Mon, 21 Sep 2026 08:46:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789980399;
	bh=PtE4kzFOwjcrgf2zOjSG1DKZKF359224qUuT8lw8Mik=;
	h=From:To:Cc:Subject:Date;
	b=Mz3YqCE5TPcOTJ42MEFYoccFeMT2XKoBvpcwXdC+bRFhM7glSfP00PAJ5AD/U4m/M
	 XTxyo4idUVwFLA9VJeSW4BDdLmcuCdO02EAsdCbWDhBNKvmq3KoN0a8AEzg6w3iHoz
	 kWbeWLF7KSbq35btOTezSLdHJgAA2hCBNdoNTz6DQWTKGrLiMqpDaLA480BSE43+IY
	 638Nft9q85T+foFFIVKjNq8YlURk3uoco6ZXHXSlfF7kyTyrA0JxUm2LG1E7u5w2C4
	 MH9HwNCDmNUHJeKzXVH7mVwYfZkVBajF3n6hcT3J2auIrtGu/kzvcc5O5ur9lCUvG+
	 1X6FBqFv+aYzQ==
From: "syzbot" <syzbot@kernel.org>
To: syzkaller-upstream-moderation@googlegroups.com
Cc: sst@poczta.fm, syzbot@lists.linux.dev
Subject: [PATCH RFC v4] Input: yealink - abort URB submission on fatal errors
Message-ID: <ec4cb3d1-f22e-4bd4-94d8-1563a62cfeb5@mail.kernel.org>
Precedence: bulk
X-Mailing-List: syzbot@lists.linux.dev
List-Id: <syzbot.lists.linux.dev>
List-Subscribe: <mailto:syzbot+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:syzbot+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Date: Mon, 21 Sep 2026 08:46:39 +0000 (UTC)

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

Fix this by checking the URB status for fatal errors (-ECONNRESET, -ENOENT,
-ESHUTDOWN, -ENODEV) in both urb_irq_callback() and urb_ctl_callback(). If
a fatal error is detected, the callback now returns early, breaking the
resubmission loop. For other non-zero statuses, skip processing the
response data and jump directly to resubmission. Additionally, use
dev_err_ratelimited() instead of dev_err() to prevent flooding the console
and triggering an RCU stall.

Fixes: aca951a22a1d ("[PATCH] input-driver-yealink-P1K-usb-phone")
Assisted-by: Gemini:gemini-3.8-flash syzbot
Reported-by: syzbot+78e2288f58b881ed3c45@syzkaller.appspotmail.com
Closes: https://syzkaller.appspot.com/bug?extid=78e2288f58b881ed3c45
Link: https://syzkaller.appspot.com/ai_job?id=89a6c0c7-a0c4-4f05-b1b1-e36a92e373e0
To: "Henk Vergonet" <Henk.Vergonet@gmail.com>
To: "Dmitry Torokhov" <dmitry.torokhov@gmail.com>
To: <linux-input@vger.kernel.org>
Cc: <linux-kernel@vger.kernel.org>

---
v4:
- In urb_ctl_callback(), resubmit urb_ctl directly instead of jumping into the switch statement.

v3:
- Only abort URB submission on fatal errors (-ECONNRESET, -ENOENT, -ESHUTDOWN, -ENODEV).
- Skip processing packet data and jump directly to resubmission on non-fatal errors.
- Use dev_err_ratelimited() instead of dev_err() to prevent console flooding.
- Drop is_fatal_error() helper in favor of switch statements.
https://lore.kernel.org/all/2b0508e9-fe78-40dd-a290-7156817e394c@mail.kernel.org/T/

v2:
- Factored out fatal error checks into is_fatal_error() helper
https://lore.kernel.org/all/2a0b5e96-dd8a-4ce9-ba3f-dd9efa26275d@mail.kernel.org/T/

v1:
https://lore.kernel.org/all/57cf484d-3235-473f-a61d-570585626176@mail.kernel.org/T/
---
diff --git a/drivers/input/misc/yealink.c b/drivers/input/misc/yealink.c
index 560f895a0..f0ec4c5ea 100644
--- a/drivers/input/misc/yealink.c
+++ b/drivers/input/misc/yealink.c
@@ -405,9 +405,19 @@ static void urb_irq_callback(struct urb *urb)
 	struct yealink_dev *yld = urb->context;
 	int ret, status = urb->status;
 
-	if (status)
-		dev_err(&yld->intf->dev, "%s - urb status %d\n",
-			__func__, status);
+	switch (status) {
+	case 0:
+		break;
+	case -ECONNRESET:
+	case -ENOENT:
+	case -ESHUTDOWN:
+	case -ENODEV:
+		return;
+	default:
+		dev_err_ratelimited(&yld->intf->dev, "%s - urb status %d\n",
+				    __func__, status);
+		goto resubmit;
+	}
 
 	switch (yld->irq_data->cmd) {
 	case CMD_KEYPRESS:
@@ -429,12 +439,13 @@ static void urb_irq_callback(struct urb *urb)
 
 	yealink_do_idle_tasks(yld);
 
+resubmit:
 	if (!yld->shutdown) {
 		ret = usb_submit_urb(yld->urb_ctl, GFP_ATOMIC);
 		if (ret && ret != -EPERM)
-			dev_err(&yld->intf->dev,
-				"%s - usb_submit_urb failed %d\n",
-				__func__, ret);
+			dev_err_ratelimited(&yld->intf->dev,
+					    "%s - usb_submit_urb failed %d\n",
+					    __func__, ret);
 	}
 }
 
@@ -443,9 +454,21 @@ static void urb_ctl_callback(struct urb *urb)
 	struct yealink_dev *yld = urb->context;
 	int ret = 0, status = urb->status;
 
-	if (status)
-		dev_err(&yld->intf->dev, "%s - urb status %d\n",
-			__func__, status);
+	switch (status) {
+	case 0:
+		break;
+	case -ECONNRESET:
+	case -ENOENT:
+	case -ESHUTDOWN:
+	case -ENODEV:
+		return;
+	default:
+		dev_err_ratelimited(&yld->intf->dev, "%s - urb status %d\n",
+				    __func__, status);
+		if (!yld->shutdown)
+			ret = usb_submit_urb(yld->urb_ctl, GFP_ATOMIC);
+		goto out;
+	}
 
 	switch (yld->ctl_data->cmd) {
 	case CMD_KEYPRESS:
@@ -462,9 +485,11 @@ static void urb_ctl_callback(struct urb *urb)
 		break;
 	}
 
+out:
 	if (ret && ret != -EPERM)
-		dev_err(&yld->intf->dev, "%s - usb_submit_urb failed %d\n",
-			__func__, ret);
+		dev_err_ratelimited(&yld->intf->dev,
+				    "%s - usb_submit_urb failed %d\n",
+				    __func__, ret);
 }
 
 /*******************************************************************************


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
