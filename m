Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 26F4C37D124
	for <syzbot@lists.linux.dev>; Sat,  8 Aug 2026 23:23:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786231413; cv=none; b=aw44b+m2eQ4YMKjPzIiao1Fbpjx45o4VN+oAw9bFTFW/d2Cvyli6amw2HyklkSyAhjjLCRTynMuxCK/Stnz0NzraG19gZWW61eOn+zbU//ppMiwMyDMNUyjYuDw0/F4j8925V866kudG36I7c0OyPwSLX7N/QEPYdpyQ2JcCtSM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786231413; c=relaxed/simple;
	bh=lQH5OSn/4wK/snqkjjjTykq3pEkEdTyYKkWg0Lmo8e8=;
	h=From:To:Cc:Subject:Message-ID:MIME-Version:Content-Type:Date; b=fjeBHW5hATdqzidpdKduitKI8BZJIwWr5Y4g3AK2v7E7758g/dWj2pnGJB3NrJbObJNEEhjV0F5RLVlIsCxrpxrknk9KTHwbYqu5EqY+KC/V0eOMKHNC06TtQeuUEEDLsXWHxGnvXyAADLEBDyh124qeagfSAhcCsXnRT9JyXu8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=JPoC5Yy9; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="JPoC5Yy9"
Received: by smtp.kernel.org (Postfix) with UTF8SMTPSA id B1F431F000E9;
	Sat,  8 Aug 2026 23:23:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1786231411;
	bh=gJlp86jG5SdpQ/s1urJumHF0qQJF9GRrgNGgZWzSJrM=;
	h=From:To:Cc:Subject:Date;
	b=JPoC5Yy9aWJi9fjlTdOSQlaztmnITgoK7Bb2sSfzcG8a9JGIO6P/75fhzEL1Bpe2Y
	 3XkRbxPP3L5lKhgWY55QdtXy1Pf865ReJkrMu7SgflD6W6ChnmRPBoqAFUYhGTSMnG
	 Cgx6DCox6FAaiycFgk06zzP/Up98owU4uYX1nNtvMrwAWd/mMasxs1DqoInkTYxk/L
	 2Q/X3Mm1PlrwrFSJ9sIuY9oNTC9Dt+TwUMKMiAz+Dv4dA1pW4PsGoVp1Vu/9XYvQ1L
	 hWj9WMKuQJ1R9dQUF0oBWmdXQsunfiyEbCHUiIm21qGNg1rjv42kLe9YWAdLJIBzFA
	 E9B3F2PJcVxRg==
From: "syzbot" <syzbot@kernel.org>
To: syzkaller-upstream-moderation@googlegroups.com
Cc: syzbot@lists.linux.dev
Subject: [PATCH RFC] media: radio-usb-si4713: fix use-after-free on disconnect
Message-ID: <985bf6f5-bab6-41fc-adb4-b92eb42389a9@mail.kernel.org>
Precedence: bulk
X-Mailing-List: syzbot@lists.linux.dev
List-Id: <syzbot.lists.linux.dev>
List-Subscribe: <mailto:syzbot+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:syzbot+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Date: Sat,  8 Aug 2026 23:23:31 +0000 (UTC)

A use-after-free bug occurs in i2c_adapter_depth() when the USB device is
disconnected while a user-space process holds a file descriptor open for
the video device. The radio-usb-si4713 driver defers i2c_del_adapter() to
the v4l2_device release callback. If the release is delayed, the I2C
adapter remains registered after the USB device is deleted. When the I2C
core is accessed later, it traverses the device tree using the dangling
parent pointer, leading to a use-after-free.

BUG: KASAN: slab-use-after-free in i2c_adapter_depth
drivers/i2c/i2c-core-base.c:1243 [inline]
BUG: KASAN: slab-use-after-free in i2c_adapter_lock_bus+0x5e/0xf0
drivers/i2c/i2c-core-base.c:849
Read of size 8 at addr ffff88818f703108 by task syz-executor235/5896

Call Trace:
 <TASK>
 i2c_adapter_depth drivers/i2c/i2c-core-base.c:1243 [inline]
 i2c_adapter_lock_bus+0x5e/0xf0 drivers/i2c/i2c-core-base.c:849
 i2c_lock_bus include/linux/i2c.h:809 [inline]
 __i2c_lock_bus_helper drivers/i2c/i2c-core.h:47 [inline]
 i2c_transfer+0xc8/0x2d0 drivers/i2c/i2c-core-base.c:2339
 i2cdev_ioctl_rdwr+0x460/0x740 drivers/i2c/i2c-dev.c:306
 i2cdev_ioctl+0x6a5/0x880 drivers/i2c/i2c-dev.c:467
 vfs_ioctl fs/ioctl.c:51 [inline]
 __do_sys_ioctl fs/ioctl.c:597 [inline]
 __se_sys_ioctl+0xfc/0x170 fs/ioctl.c:583
 do_syscall_x64 arch/x86/entry/syscall_64.c:63 [inline]
 do_syscall_64+0x174/0x580 arch/x86/entry/syscall_64.c:94
 entry_SYSCALL_64_after_hwframe+0x77/0x7f
 </TASK>

To fix this, unregister the I2C adapter and V4L2 device synchronously in
the disconnect callback. Additionally, call v4l2_device_unregister() before
i2c_del_adapter() to prevent a double-free of the I2C client device, which
would occur if the I2C adapter unregisters its clients before V4L2 does.
The same ordering is applied to the error path in usb_si4713_probe().
Finally, i2c_del_adapter() is called outside of radio->lock to avoid
deadlocks with concurrent ioctl calls.

Fixes: b874b39fcd2f ("[media] si4713: Added the USB driver for Si4713")
Assisted-by: Gemini:gemini-3.5-flash Gemini:gemini-3.1-pro-preview syzbot
Reported-by: syzbot+450abcfc7906fe1a1e16@syzkaller.appspotmail.com
Closes: https://syzkaller.appspot.com/bug?extid=450abcfc7906fe1a1e16
Link: https://syzkaller.appspot.com/ai_job?id=4960f118-574d-47b1-a640-160d51f8ec71
To: "Hans Verkuil" <hverkuil@kernel.org>
To: <linux-media@vger.kernel.org>
To: "Mauro Carvalho Chehab" <mchehab@kernel.org>
To: "Dinesh Ram" <Dinesh.Ram@cern.ch>
Cc: <linux-kernel@vger.kernel.org>

---
diff --git a/drivers/media/radio/si4713/radio-usb-si4713.c b/drivers/media/radio/si4713/radio-usb-si4713.c
index 6e6764143..d5d97e336 100644
--- a/drivers/media/radio/si4713/radio-usb-si4713.c
+++ b/drivers/media/radio/si4713/radio-usb-si4713.c
@@ -128,10 +128,7 @@ static const struct v4l2_file_operations usb_si4713_fops = {
 static void usb_si4713_video_device_release(struct v4l2_device *v4l2_dev)
 {
 	struct si4713_usb_device *radio = to_si4713_dev(v4l2_dev);
-	struct i2c_adapter *adapter = &radio->i2c_adapter;
 
-	i2c_del_adapter(adapter);
-	v4l2_device_unregister(&radio->v4l2_dev);
 	kfree(radio->buffer);
 	kfree(radio);
 }
@@ -488,7 +485,9 @@ static int usb_si4713_probe(struct usb_interface *intf,
 	return 0;
 
 del_adapter:
+	v4l2_device_unregister(&radio->v4l2_dev);
 	i2c_del_adapter(adapter);
+	goto err_v4l2;
 err_i2cdev:
 	v4l2_device_unregister(&radio->v4l2_dev);
 err_v4l2:
@@ -506,8 +505,11 @@ static void usb_si4713_disconnect(struct usb_interface *intf)
 	mutex_lock(&radio->lock);
 	usb_set_intfdata(intf, NULL);
 	video_unregister_device(&radio->vdev);
-	v4l2_device_disconnect(&radio->v4l2_dev);
 	mutex_unlock(&radio->lock);
+
+	v4l2_device_unregister(&radio->v4l2_dev);
+	i2c_del_adapter(&radio->i2c_adapter);
+
 	v4l2_device_put(&radio->v4l2_dev);
 }
 


base-commit: 075b74841bd0065a3bda3440873c747938e69b68
-- 
This is an AI-generated patch subject to moderation.
Reply with '#syz upstream' to Sign-off the patch as a human author
and send it to the upstream kernel mailing lists.
Reply with '#syz reject' to reject it ('#syz unreject' to undo).

See https://goo.gle/syzbot-ai-patches for information about AI-generated patches.
The person who has signed off on the patch is responsible for
addressing comments.
syzbot engineers can be reached at syzkaller@googlegroups.com.
