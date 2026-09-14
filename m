Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CF2DA41CB5E
	for <syzbot@lists.linux.dev>; Mon, 14 Sep 2026 09:09:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789376977; cv=none; b=DvjsaFhgvKsZuxzTrX3jYNi2jm4AvT3JGRzq8Bly+GtO4Z/vv5gfZ2/hR0X6VnQefU90JGW2KGkdISKSQIsO43lGjrV/YHnp0Xa/EYbO7GTBrYu/F+qy2pFxOaSMq/SbHXhvTOgeZN71aQVgiSFCFHO72lpeganVRZWWRLtG/H4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789376977; c=relaxed/simple;
	bh=X9Yx+aNWN2Ex0UBsWVWlr1hEnAZjxDha7PRccPJi9u8=;
	h=From:To:Cc:Subject:Message-ID:MIME-Version:Content-Type:Date; b=nH+5kdsSVWXFnBy+gC930e0/qGrRrTOSmEE5B6si4Ca7We7qUZ5NFOGngooG8QF1eCjUWoWEAvBCAMY3VpvZmGC4C0a53u7DvYyQy8E594pkfH0CmBAtgJdPBv9kl71M2lbVbYyI+8rF/1hjVypn1gxy8xpjOuEKjPoUv2uE/oU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=iwc+JBda; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="iwc+JBda"
Received: by smtp.kernel.org (Postfix) with UTF8SMTPSA id 6D26A1F000FF;
	Mon, 14 Sep 2026 09:09:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789376975;
	bh=wkUybl/odTOx2gFNSHv75sZhHhUg6Fdlrgnlbd3DLSI=;
	h=From:To:Cc:Subject:Date;
	b=iwc+JBdaMpR9P8+msrjTo0xBpbf1U+rQxYzOPkqIPQyZthXvw9onqdcFBGgE/djAz
	 rXrqkfb6e10atn2DIl2w0JvAgwL6/BT5bIhyHnB7nuy+7CzM1a4oaxkLS2Ie039b6x
	 yGqOqU2lL6JkI4E3Lj8KKarhiHkeZDvEFVvHUkHCwQUQFiAvBNiRoSmwLFsjM625AD
	 DEDBuBil9zZE5IFq0ZyaaRS2u1YiFJk6JXiuGF7be+vx6iY79EozQVEfDtlP2xUVd9
	 KDXvQbqAB4wm6JTNpBnjL0SGC4tayzo11r/fiio1fOiOlUaRA0Q1hMRPP2TJDNWfuo
	 EtvXJ7lr0HASw==
From: "syzbot" <syzbot@kernel.org>
To: syzkaller-upstream-moderation@googlegroups.com
Cc: sst@poczta.fm, syzbot@lists.linux.dev
Subject: [PATCH RFC v2] Input: yealink - abort URB submission on fatal errors
Message-ID: <2a0b5e96-dd8a-4ce9-ba3f-dd9efa26275d@mail.kernel.org>
Precedence: bulk
X-Mailing-List: syzbot@lists.linux.dev
List-Id: <syzbot.lists.linux.dev>
List-Subscribe: <mailto:syzbot+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:syzbot+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Date: Mon, 14 Sep 2026 09:09:35 +0000 (UTC)

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
Assisted-by: Gemini:gemini-3.8-flash syzbot
Reported-by: syzbot+78e2288f58b881ed3c45@syzkaller.appspotmail.com
Closes: https://syzkaller.appspot.com/bug?extid=78e2288f58b881ed3c45
Link: https://syzkaller.appspot.com/ai_job?id=479730c2-f271-451c-a31b-837d89cb018e
To: "Henk Vergonet" <Henk.Vergonet@gmail.com>
To: "Dmitry Torokhov" <dmitry.torokhov@gmail.com>
To: <linux-input@vger.kernel.org>
Cc: <linux-kernel@vger.kernel.org>

---
v2:
- Factored out fatal error checks into is_fatal_error() helper

v1:
https://lore.kernel.org/all/57cf484d-3235-473f-a61d-570585626176@mail.kernel.org/T/
---
diff --git a/drivers/input/misc/yealink.c b/drivers/input/misc/yealink.c
index 560f895a0..bf91f40cd 100644
--- a/drivers/input/misc/yealink.c
+++ b/drivers/input/misc/yealink.c
@@ -400,14 +400,32 @@ static int yealink_do_idle_tasks(struct yealink_dev *yld)
  * error,start
  *
  */
+static bool is_fatal_error(int status)
+{
+	switch (status) {
+	case -ENOENT:
+	case -ECONNRESET:
+	case -ESHUTDOWN:
+	case -EPROTO:
+	case -EPIPE:
+	case -EILSEQ:
+		return true;
+	default:
+		return false;
+	}
+}
+
 static void urb_irq_callback(struct urb *urb)
 {
 	struct yealink_dev *yld = urb->context;
 	int ret, status = urb->status;
 
-	if (status)
+	if (status) {
 		dev_err(&yld->intf->dev, "%s - urb status %d\n",
 			__func__, status);
+		if (is_fatal_error(status))
+			return;
+	}
 
 	switch (yld->irq_data->cmd) {
 	case CMD_KEYPRESS:
@@ -443,9 +461,12 @@ static void urb_ctl_callback(struct urb *urb)
 	struct yealink_dev *yld = urb->context;
 	int ret = 0, status = urb->status;
 
-	if (status)
+	if (status) {
 		dev_err(&yld->intf->dev, "%s - urb status %d\n",
 			__func__, status);
+		if (is_fatal_error(status))
+			return;
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
