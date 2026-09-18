Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3A6974D598C
	for <syzbot@lists.linux.dev>; Fri, 18 Sep 2026 16:55:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789750557; cv=none; b=U/8k8LqTDNZg7GE3rdXWJiafm/Of1l7P/R75zO0dcVjmtdbcFQ5yIc738rngo4XXSY/UHq0JNzW/Gink0gVIL1Y/Oxv0sDBhi/cgReHEYP43I2uA9WYX2Rik8msNDv4KGcReIqw9HQLzOWzT4ec8Gzg5XlQ8tnkbjluQ8xVbuxA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789750557; c=relaxed/simple;
	bh=z9lOrQX5S+DA8Kg0kD8Q5ULG5fpkanQtOdYE8vhSQBg=;
	h=From:To:Cc:Subject:Message-ID:MIME-Version:Content-Type:Date; b=RTdV31hXX+wnD0FdkLLfoIYvA0bjIA/aPv3p+inxk9QQCjsGqMdnReKQQfug6OQCM227cZ2l1VPB3Rkzb/7oJWvxnOD/bpJ1lMx684rXzzxhaXzo1uDbgrgvUA7U3D5u5MCh0AyI9hTVOwYFE7gqMTxfF329d14RI3j3TsonSUE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=REW4RS+b; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="REW4RS+b"
Received: by smtp.kernel.org (Postfix) with UTF8SMTPSA id F3CF61F000FF;
	Fri, 18 Sep 2026 16:55:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789750556;
	bh=AiVXX47sVlNJxNiaStDJAlHyOzf96oQwUS4xa5tVrhU=;
	h=From:To:Cc:Subject:Date;
	b=REW4RS+bGODdNOynCvm2fgnSSttnsx9WW8zFFpBu1rurCd7VpiqK52sCUr9j9EfDg
	 taDHY1AbSqSaobIPwjFOnx9L0y3b2bOGRg2BZ2L2YWu2TyKyxWJ2do4Nu5MSy1Jqts
	 zB1hR2usUetfF4TLMRxn6D52vCefrsCMNN/kCDfP7bNdDV3x9RLBO5iWFEXkt+fqNn
	 kQJoHTzT1GZqPF2c5hBMkqDuDUnzt5vyqfSDHPXRO0x4GCZKYf939UaZ61HNh18LLE
	 R287/ZYSuXoSHHUcSUjifboHgrGWAuVHmCZfXNtvCFlPayNFuC7jGVf6U7oLc804Jg
	 j1tCW66B05Dnw==
From: "syzbot" <syzbot@kernel.org>
To: syzkaller-upstream-moderation@googlegroups.com
Cc: sst@poczta.fm, syzbot@lists.linux.dev
Subject: [PATCH RFC v3] Input: yealink - abort URB submission on fatal errors
Message-ID: <2b0508e9-fe78-40dd-a290-7156817e394c@mail.kernel.org>
Precedence: bulk
X-Mailing-List: syzbot@lists.linux.dev
List-Id: <syzbot.lists.linux.dev>
List-Subscribe: <mailto:syzbot+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:syzbot+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Date: Fri, 18 Sep 2026 16:55:55 +0000 (UTC)

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
Link: https://syzkaller.appspot.com/ai_job?id=24a48a3f-a005-45ce-9020-4a27b38d9683
To: "Henk Vergonet" <Henk.Vergonet@gmail.com>
To: "Dmitry Torokhov" <dmitry.torokhov@gmail.com>
To: <linux-input@vger.kernel.org>
Cc: <linux-kernel@vger.kernel.org>

---
v3:
- Only abort URB submission on fatal errors (-ECONNRESET, -ENOENT, -ESHUTDOWN, -ENODEV).
- Skip processing packet data and jump directly to resubmission on non-fatal errors.
- Use dev_err_ratelimited() instead of dev_err() to prevent console flooding.
- Drop is_fatal_error() helper in favor of switch statements.

v2:
- Factored out fatal error checks into is_fatal_error() helper
https://lore.kernel.org/all/2a0b5e96-dd8a-4ce9-ba3f-dd9efa26275d@mail.kernel.org/T/

v1:
https://lore.kernel.org/all/57cf484d-3235-473f-a61d-570585626176@mail.kernel.org/T/
---
diff --git a/drivers/input/misc/yealink.c b/drivers/input/misc/yealink.c
index 560f895a0..c67c619db 100644
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
 
@@ -443,9 +454,19 @@ static void urb_ctl_callback(struct urb *urb)
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
+		goto resubmit;
+	}
 
 	switch (yld->ctl_data->cmd) {
 	case CMD_KEYPRESS:
@@ -457,14 +478,16 @@ static void urb_ctl_callback(struct urb *urb)
 	default:
 		/* send new command */
 		yealink_do_idle_tasks(yld);
+resubmit:
 		if (!yld->shutdown)
 			ret = usb_submit_urb(yld->urb_ctl, GFP_ATOMIC);
 		break;
 	}
 
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
