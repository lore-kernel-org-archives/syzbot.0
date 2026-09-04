Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3860D4EA394
	for <syzbot@lists.linux.dev>; Fri,  4 Sep 2026 20:32:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788553953; cv=none; b=g5fgCwZyJoELRt56b5Yds24i+pGThcD1QKCHD+xBYlRF7n66YzUfJAdLwrPkh3pQ4bBNPLEoDqewr8xeVO91aK+u+bG3gnpOwDmyvyqVJqEy6EtfpWPIjXbj/QrEiTtoh2wImJiJWMu3WZ/l7LeGDtROuI+EgSuF01Q8lB47iN0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788553953; c=relaxed/simple;
	bh=HcElqqC3tva/YvvKgD3N3Bg9tsyBXESQxnO3Z3nxNsc=;
	h=From:To:Cc:Subject:Message-ID:MIME-Version:Content-Type:Date; b=MbaGSHmtFzs42/9uA1HOnoKtTeEj4S/OY4FI/FAxGcXShcqG6EE4o/oSdFvEByovdhEzfb/M+NdC5zrDyUg3AGcsGTbptNvv+gdOxwhgdwU5qR0UaH3IOZl5SyayM29m1JXUN1GVqp173XZFEGDywSg/0baPaLFQDsGIJewWJTo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=VMBnKIUy; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="VMBnKIUy"
Received: by smtp.kernel.org (Postfix) with UTF8SMTPSA id DFF2C1F00A3E;
	Fri,  4 Sep 2026 20:32:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788553943;
	bh=sW+xj17SDeVE1DNlOF6izo4vMzo4DOxUwyGAzqUCe38=;
	h=From:To:Cc:Subject:Date;
	b=VMBnKIUyIRlfsZQfAM3JHyPwYKzRSVudJEqUl5O3IIEbrbnUmS+r/PsGm+Uh7tyPy
	 e0O+AZskBRNqKkunbw+ntJx9JweBWBiWRVF05Lf5JTIBpIqbHlQ6KGdQtj+/DKn82l
	 bcq6SwV+SMnSUcnOuKIhpUt7zkl41zw3EqDujf6TgOJ2eXiXBQrhdy/k6Sex1HsxjO
	 aGg2AIZT+dwInXvwWMvbC9oR8oq+8ELn/5RMKtMVppGnNJ51Im+3VequYhfCAmvrB0
	 ySa5gb3LCf4IT6atrOTk3RkiUuGT5ta7l95bjofhlLMYsnWNo6qbmaiRSeSuX7OEbW
	 sgDCrlPdq6+oA==
From: "syzbot" <syzbot@kernel.org>
To: syzkaller-upstream-moderation@googlegroups.com
Cc: syzbot@lists.linux.dev
Subject: [PATCH RFC] usb: image: mdc800: fix deadlock between io_lock and minor_rwsem
Message-ID: <607b1e62-28f5-49f8-a74a-2e7d8d3c263a@mail.kernel.org>
Precedence: bulk
X-Mailing-List: syzbot@lists.linux.dev
List-Id: <syzbot.lists.linux.dev>
List-Subscribe: <mailto:syzbot+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:syzbot+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Date: Fri,  4 Sep 2026 20:32:22 +0000 (UTC)

A circular locking dependency warning is detected between the driver's
internal mutex mdc800->io_lock and the USB core's minor_rwsem:

WARNING: possible circular locking dependency detected
is trying to acquire lock:
ffff88810c4c6218 (&mdc800->io_lock){+.+.}-{4:4}, at:
mdc800_device_open+0x2e/0x470 drivers/usb/image/mdc800.c:611

but task is already holding lock:
ffffffff8fd638a8 (minor_rwsem#2){++++}-{4:4}, at: usb_open+0x30/0x1e0
drivers/usb/core/file.c:38

which lock already depends on the new lock.

the existing dependency chain (in reverse order) is:

-> #1 (minor_rwsem#2){++++}-{4:4}:
       down_write+0x96/0x200 kernel/locking/rwsem.c:1631
       usb_register_dev+0x142/0x5e0 drivers/usb/core/file.c:134
       mdc800_usb_probe+0xf96/0x18c0 drivers/usb/image/mdc800.c:485
       usb_probe_interface+0x788/0xe50 drivers/usb/core/driver.c:399
       really_probe+0x254/0xae0 drivers/base/dd.c:706

-> #0 (&mdc800->io_lock){+.+.}-{4:4}:
       __mutex_lock+0x19d/0x1550 kernel/locking/mutex.c:821
       mdc800_device_open+0x2e/0x470 drivers/usb/image/mdc800.c:611
       usb_open+0x156/0x1e0 drivers/usb/core/file.c:47
       chrdev_open+0x4d9/0x600 fs/char_dev.c:411
       do_dentry_open+0x816/0x1380 fs/open.c:996

 Possible unsafe locking scenario:

       CPU0                    CPU1
       ----                    ----
  rlock(minor_rwsem#2);
                               lock(&mdc800->io_lock);
                               lock(minor_rwsem#2);
  lock(&mdc800->io_lock);

 *** DEADLOCK ***

In mdc800_usb_probe(), usb_register_dev() is called while holding
mdc800->io_lock. usb_register_dev() acquires minor_rwsem via down_write(),
establishing the lock order mdc800->io_lock -> minor_rwsem. Meanwhile, when
opening the character device, usb_open() acquires minor_rwsem via
down_read() and then calls the driver's open callback mdc800_device_open(),
which acquires mdc800->io_lock, establishing the reverse lock order
minor_rwsem -> mdc800->io_lock. If probe and open run concurrently, this
leads to an AB-BA deadlock.

Fix this by moving usb_register_dev() outside the mdc800->io_lock critical
section in mdc800_usb_probe(). Complete device initialization under
io_lock, release the lock, and then call usb_register_dev(). Userspace
cannot open the device before usb_register_dev() succeeds, so exposing the
initialized state is safe. If usb_register_dev() fails, re-acquire io_lock
to reset mdc800->dev to NULL and mdc800->state to NOT_CONNECTED before
returning the error.

Fixes: d4ead16f50f9 ("USB: prevent char device open/deregister race")
Assisted-by: Gemini:gemini-3.7-flash Gemini:gemini-3.1-pro-preview syzbot
Reported-by: syzbot+023b30ebfe0dc4bcfafe@syzkaller.appspotmail.com
Closes: https://syzkaller.appspot.com/bug?extid=023b30ebfe0dc4bcfafe
Link: https://syzkaller.appspot.com/ai_job?id=4d021e48-ac69-45de-9f8b-153d5f28a42a
To: "Greg Kroah-Hartman" <gregkh@linuxfoundation.org>
To: <linux-usb@vger.kernel.org>
To: "Alan Stern" <stern@rowland.harvard.edu>
Cc: "Kees Cook" <kees@kernel.org>
Cc: <linux-kernel@vger.kernel.org>
Cc: "Ziyi Guo" <n7l8m4@u.northwestern.edu>
Cc: "Oliver Neukum" <oneukum@suse.com>

---
diff --git a/drivers/usb/image/mdc800.c b/drivers/usb/image/mdc800.c
index ca287b770..019314702 100644
--- a/drivers/usb/image/mdc800.c
+++ b/drivers/usb/image/mdc800.c
@@ -482,13 +482,6 @@ static int mdc800_usb_probe (struct usb_interface *intf,
 
 	mutex_lock(&mdc800->io_lock);
 
-	retval = usb_register_dev(intf, &mdc800_class);
-	if (retval) {
-		dev_err(&intf->dev, "Not able to get a minor for this device.\n");
-		mutex_unlock(&mdc800->io_lock);
-		return -ENODEV;
-	}
-
 	mdc800->dev=dev;
 	mdc800->open=0;
 
@@ -527,6 +520,16 @@ static int mdc800_usb_probe (struct usb_interface *intf,
 	mdc800->state=READY;
 
 	mutex_unlock(&mdc800->io_lock);
+
+	retval = usb_register_dev(intf, &mdc800_class);
+	if (retval) {
+		dev_err(&intf->dev, "Not able to get a minor for this device.\n");
+		mutex_lock(&mdc800->io_lock);
+		mdc800->dev = NULL;
+		mdc800->state = NOT_CONNECTED;
+		mutex_unlock(&mdc800->io_lock);
+		return -ENODEV;
+	}
 	
 	usb_set_intfdata(intf, mdc800);
 	return 0;


base-commit: cee9395acd8043be0644b25c34bfa86623f2b935
-- 
This is an AI-generated patch subject to moderation.
Reply with '#syz upstream' to Sign-off the patch as a human author
and send it to the upstream kernel mailing lists.
Reply with '#syz reject' to reject it ('#syz unreject' to undo).

See https://goo.gle/syzbot-ai-patches for information about AI-generated patches.
You can comment on the patch as usual, syzbot will try to address
the comments and send a new version of the patch if necessary.
syzbot engineers can be reached at syzkaller@googlegroups.com.
