Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E0745125AA
	for <syzbot@lists.linux.dev>; Sun, 16 Aug 2026 23:09:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786921747; cv=none; b=Yyjx3A6G0nmUwUaXxrp/A3DfIXviQ40s11B/q1XxOOBxrdJOxhyZ3PrJEcD0YspqheLLIZERxOM6I0sZS7B3S+5P5xixsIZ88Jmw2HIHl1IrG37g/VQXpiD96eqqV9oLUCrWENqf/1a4ljqn0zE3KGGTPg4/9fZPwUia9Zx0FSA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786921747; c=relaxed/simple;
	bh=mm4tRGRPmfBqn+KfjgFZdCC+eRSV71zy5TNZ+Fw7ZSY=;
	h=From:To:Cc:Subject:Message-ID:MIME-Version:Content-Type:Date; b=m7D8geJ6JqrRSBJCtvvS0QWUvFaBG2cQirfBorKcYj5XBOnn5rfXx6n/7KXXavmZ6OhjUjHFc152sHNr1nBefxuBDsQ0IVLqX31R5YBM2VmxCvNjd+PV5wCs9Zyig27DB3E8+A+1SAEMK5swFbyh9v9Q74y+D86JsKxeE6UQ/ew=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=S3sbvcv0; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="S3sbvcv0"
Received: by smtp.kernel.org (Postfix) with UTF8SMTPSA id 7FE001F000E9;
	Sun, 16 Aug 2026 23:09:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1786921745;
	bh=3XiIJkGlp8MrYCaUiZrPYhgsxNiDGjj+SkWfjx96wzA=;
	h=From:To:Cc:Subject:Date;
	b=S3sbvcv0j3gdpvWEC/4BAASWKYySjVq7vKpO0Jqy5rvh0Y+cPap9FWAGl6YDGy+QZ
	 UFrSQfWZuH4+cujhn4rv3/Z/KYZyF2UAQ7vY63UKKjXRffMdqhvNsuNF+taYGAHhST
	 SSe3KiU6KesDgx1ZXLGIeUpgbgfRFixum/aARmzGBHCxEVmt/G4y2XZ8agb0L4inOS
	 5i529fVNyn44poBC7y69sB6tmXa6H8dmHgYzEl7RzAK0mEQRENXXQLAAj+uZKOnP73
	 tHyJb5hkb0hbzIoZgcrmTMeJLZNG6wTmsmLD7I8ZvoNbj+qp9GZnTDAnhuIF9hF645
	 8UTYxQJcR7oUw==
From: "syzbot" <syzbot@kernel.org>
To: syzkaller-upstream-moderation@googlegroups.com
Cc: syzbot@lists.linux.dev
Subject: [PATCH RFC] media: usbtv: fix null-pointer dereference on disconnect
Message-ID: <20d7b17b-9c29-4c28-95a4-e4377e35f440@mail.kernel.org>
Precedence: bulk
X-Mailing-List: syzbot@lists.linux.dev
List-Id: <syzbot.lists.linux.dev>
List-Subscribe: <mailto:syzbot+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:syzbot+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Date: Sun, 16 Aug 2026 23:09:05 +0000 (UTC)

A null-pointer dereference can occur in usb_make_path() when called from
usbtv_querycap() (and other ioctl handlers) during device disconnection.

Oops: general protection fault, probably for non-canonical address
0xdffffc000000000a: 0000 [#1] SMP KASAN NOPTI
KASAN: null-ptr-deref in range [0x0000000000000050-0x0000000000000057]
RIP: 0010:usb_make_path include/linux/usb.h:985 [inline]
RIP: 0010:usbtv_querycap+0x9c/0x100
drivers/media/usb/usbtv/usbtv-video.c:612
...
Call Trace:
 <TASK>
 v4l_querycap+0x236/0x470 drivers/media/v4l2-core/v4l2-ioctl.c:1106
 __video_do_ioctl+0x8af/0xc70 drivers/media/v4l2-core/v4l2-ioctl.c:3133
 video_usercopy+0x860/0x1430 drivers/media/v4l2-core/v4l2-ioctl.c:3475
 v4l2_ioctl+0x18d/0x1e0 drivers/media/v4l2-core/v4l2-dev.c:366
 vfs_ioctl fs/ioctl.c:51 [inline]
 __do_sys_ioctl fs/ioctl.c:597 [inline]
 __se_sys_ioctl+0xfc/0x170 fs/ioctl.c:583
 do_syscall_x64 arch/x86/entry/syscall_64.c:63 [inline]
 do_syscall_64+0x174/0x580 arch/x86/entry/syscall_64.c:94

This happens due to a race condition between the USB device disconnect
routine (usbtv_disconnect()) and V4L2 ioctls. When the device is
disconnected, usbtv_disconnect() sets usbtv->udev = NULL without holding
the usbtv->v4l2_lock mutex. Concurrently, an ioctl handler like
usbtv_querycap() can be executing under the v4l2_lock and attempt to use
usbtv->udev, leading to a crash.

To fix this, move the usbtv->udev = NULL assignment into usbtv_video_free()
and protect it with mutex_lock(&usbtv->v4l2_lock). This ensures that no
non-queue ioctl handler can run concurrently with the pointer being
nullified. If an ioctl is already running, the mutex will block the
disconnect path until the ioctl finishes. If an ioctl is blocked waiting
for the lock, it will acquire it after the disconnect routine releases it,
but will then check video_is_registered() (which was cleared by
vb2_video_unregister_device()) and safely return -ENODEV.

Acquiring v4l2_lock after vb2_video_unregister_device() avoids
reintroducing a historical deadlock issue, and usbtv_audio_free() remains
safe as it is called before usbtv_video_free().

Fixes: 65e6a2773d65 ("media: usbtv: Remove useless locks in usbtv_video_free()")
Assisted-by: Gemini:gemini-3.6-flash Gemini:gemini-3.1-pro-preview syzbot
Reported-by: syzbot+37a57a84893052ab6071@syzkaller.appspotmail.com
Closes: https://syzkaller.appspot.com/bug?extid=37a57a84893052ab6071
Link: https://syzkaller.appspot.com/ai_job?id=5abbe65a-5853-4bc2-9135-5c75f88d51ed
To: <linux-media@vger.kernel.org>
To: "Mauro Carvalho Chehab" <mchehab@kernel.org>
To: "Benjamin Gaignard" <benjamin.gaignard@collabora.com>
Cc: "Hans Verkuil" <hverkuil+cisco@kernel.org>
Cc: "Johan Hovold" <johan@kernel.org>
Cc: "Kees Cook" <kees@kernel.org>
Cc: <linux-kernel@vger.kernel.org>

---
diff --git a/drivers/media/usb/usbtv/usbtv-core.c b/drivers/media/usb/usbtv/usbtv-core.c
index 6c4facf4f..b33b54fdb 100644
--- a/drivers/media/usb/usbtv/usbtv-core.c
+++ b/drivers/media/usb/usbtv/usbtv-core.c
@@ -136,8 +136,6 @@ static void usbtv_disconnect(struct usb_interface *intf)
 	usbtv_audio_free(usbtv);
 	usbtv_video_free(usbtv);
 
-	usbtv->udev = NULL;
-
 	/* the usbtv structure will be deallocated when v4l2 will be
 	   done using it */
 	v4l2_device_put(&usbtv->v4l2_dev);
diff --git a/drivers/media/usb/usbtv/usbtv-video.c b/drivers/media/usb/usbtv/usbtv-video.c
index de0328100..ef066df71 100644
--- a/drivers/media/usb/usbtv/usbtv-video.c
+++ b/drivers/media/usb/usbtv/usbtv-video.c
@@ -968,5 +968,9 @@ void usbtv_video_free(struct usbtv *usbtv)
 	vb2_video_unregister_device(&usbtv->vdev);
 	v4l2_device_disconnect(&usbtv->v4l2_dev);
 
+	mutex_lock(&usbtv->v4l2_lock);
+	usbtv->udev = NULL;
+	mutex_unlock(&usbtv->v4l2_lock);
+
 	v4l2_device_put(&usbtv->v4l2_dev);
 }


base-commit: db2ddb87143519e20a95aa36c60b36107b736a58
-- 
This is an AI-generated patch subject to moderation.
Reply with '#syz upstream' to Sign-off the patch as a human author
and send it to the upstream kernel mailing lists.
Reply with '#syz reject' to reject it ('#syz unreject' to undo).

See https://goo.gle/syzbot-ai-patches for information about AI-generated patches.
You can comment on the patch as usual, syzbot will try to address
the comments and send a new version of the patch if necessary.
syzbot engineers can be reached at syzkaller@googlegroups.com.
