Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 925CD37A821;
	Tue, 29 Sep 2026 07:39:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790667599; cv=none; b=O8s+NoTuL/ClzgQfult4fpTFCpJ9P5eCjNC4MGbkXmw5wS8LqdXkVUxG0Oq8OHqgPV9lYHibv9cl1pAfIMkkamIfOZYByUSfahh5xfKUzhnS1ipC8HY9FnRxBnLfUlLagaPYy+kB51rOzNHUWixBqOo+APxAqXtnVKpvBcyw88I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790667599; c=relaxed/simple;
	bh=y0dzu7ob3UmPk/H1zTfNyDfnolxfGhUWR2dqtm3KL1g=;
	h=From:To:Cc:Subject:Message-ID:MIME-Version:Content-Type:Date; b=Vfb7RWCPwGzj7nlHyeh6FyseWlMiy068f6VzLAeQKFI6cbuv63CMztRc/FMm8cbTicm3jawl+YojyWagYnVqqthdVNUD7Ddg/wWIadMPeqtMJHUAdHQZZ1KpMD98xBz+bMHdI04GExSyBeLqXiBXnNMR/ZVPxi7yIAjwM1XX/EQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=oEJ7zX5b; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="oEJ7zX5b"
Received: by smtp.kernel.org (Postfix) with UTF8SMTPSA id D039B1F00898;
	Tue, 29 Sep 2026 07:39:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1790667598;
	bh=vDL0qwhi/Q8PBC/n1Ot2vI5BEahLy6mimceHsqZsJiM=;
	h=From:To:Cc:Subject:Date;
	b=oEJ7zX5bpahzWjFnsSca/uOGkdgYKDhQd7dQcuuDE8kGLBJJ7u7cugyIhChJ72KqP
	 smiWlSdQhhTHsY1m1ZeW9ODCuhvjfblrOH1i2R7sqkVbWxfvSAUH900TK8kcPaVs2u
	 lEE0BvtvpHmoF3uCVUh5JvgCsETGT/tdjmoMeczyfKXHESVs2IQs3WLwTtdaPaSjEj
	 8ZrCgHkdR4nVOl1P9fuVzg7Q6+JFcJAWcEZhjpYR3ZtNNd8aSsIPJWeinKv+zpQous
	 eBAon51s1RlyDIGiV/yxcllw91O0wbwOsweuZifV7iHhNQzrrCdiLvDXQ7BMzrJGLv
	 K+MDccY6zVGcQ==
From: "syzbot" <syzbot@kernel.org>
To: syzkaller-bugs@googlegroups.com, Slawomir Stepien <sst@poczta.fm>, "Henk Vergonet" <Henk.Vergonet@gmail.com>, "Dmitry Torokhov" <dmitry.torokhov@gmail.com>, <linux-input@vger.kernel.org>
Cc: linux-kernel@vger.kernel.org, syzbot@lists.linux.dev
Subject: [PATCH] Input: yealink - abort URB submission on fatal errors
Message-ID: <fcf3ed99-54ce-4049-9f7d-611827e7adad@mail.kernel.org>
Precedence: bulk
X-Mailing-List: syzbot@lists.linux.dev
List-Id: <syzbot.lists.linux.dev>
List-Subscribe: <mailto:syzbot+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:syzbot+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Date: Tue, 29 Sep 2026 07:39:57 +0000 (UTC)

From: Slawomir Stepien <sst@poczta.fm>

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
Signed-off-by: Slawomir Stepien <sst@poczta.fm>

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
See https://goo.gle/syzbot-ai-patches for information about AI-generated patches.
The person who has signed off on the patch is responsible for
addressing comments.
syzbot engineers can be reached at syzkaller@googlegroups.com.
