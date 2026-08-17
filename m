Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 85D0B3033E7;
	Mon, 17 Aug 2026 14:09:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786975791; cv=none; b=E2/dJUnADlJu5RCWpP+nJFeIE0lJkP+EZRLrKWRjAN6BJxtfp8TUGOKnpgkTVF0mUwIp6dOYqjNNB+2TiHrSMpc8K3eGaeMuT7ZW74aqvlgXdctFF/lV4MRfUJooLUhtKs27IklSDOk1+EgsO8FUKutnia1mJ2GbOC/BzMAOhVg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786975791; c=relaxed/simple;
	bh=ikrN+WOvyP/q7nZDyj0/RmCJO4FSqpU5YZZG++6JWrA=;
	h=From:To:Cc:Subject:Message-ID:MIME-Version:Content-Type:Date; b=qmxIDaG56c4mSN19wD45OtaJ+beOMaHgV1HQ/cuIh3Vi0KPYt79qcWpkZupfTFusgGWNY68otbvkKUinFi1J+EC2rc2DLrt6xt2ODO7ghYEAlZ8ZJHzCVXZhizA77IH2m2bTuVyf3XR9cdlLhW0701SaqnCfYEK2/s7FbY61NXQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=FfgdM2vR; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="FfgdM2vR"
Received: by smtp.kernel.org (Postfix) with UTF8SMTPSA id CBECD1F000E9;
	Mon, 17 Aug 2026 14:09:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1786975790;
	bh=JiAxXXFG28McNCClUPtlPyvc899bEhfijY5AIAjgWcs=;
	h=From:To:Cc:Subject:Date;
	b=FfgdM2vRej4a4S810ZLyOoFABhp7ps8xdWtEBz8FB87YwrviIle1E0d75DeEOs4X8
	 4bIdcPFJ+C5R54pqv9Z27LZuUrrY6ha+n2bWOERLLLI18c2M9OgK0PAwz/wNyaVsL5
	 MHVEu8EUroHtnTlY5q4dgFwKmlCbesef0Q4euoTfRJge0jcjottfwHvtodlw9eba3x
	 UZfqR6PUB7Jn6Cm1xRii4VTGCnTuPiAokA+0TROmjQ6yxZZViftGR+j14qef2d8Y5M
	 qPdayqQWA9SC4V5PY3+rF0GJ772CTVnnBFd+t3C/gNcdQsT7/qhYfUA7bgIJTfX0da
	 HOW9JHodVGh0g==
From: "syzbot" <syzbot@kernel.org>
To: syzkaller-bugs@googlegroups.com, Aleksandr Nogikh <nogikh@google.com>, <linux-media@vger.kernel.org>, "Mauro Carvalho Chehab" <mchehab@kernel.org>, "Benjamin Gaignard" <benjamin.gaignard@collabora.com>
Cc: hverkuil+cisco@kernel.org, johan@kernel.org, kees@kernel.org, linux-kernel@vger.kernel.org, syzbot@lists.linux.dev
Subject: [PATCH] media: usbtv: fix null-pointer dereference on disconnect
Message-ID: <df73ba45-4d7a-4cf9-bff4-821124045c55@mail.kernel.org>
Precedence: bulk
X-Mailing-List: syzbot@lists.linux.dev
List-Id: <syzbot.lists.linux.dev>
List-Subscribe: <mailto:syzbot+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:syzbot+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Date: Mon, 17 Aug 2026 14:09:49 +0000 (UTC)

From: Aleksandr Nogikh <nogikh@google.com>

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
Signed-off-by: Aleksandr Nogikh <nogikh@google.com>

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
See https://goo.gle/syzbot-ai-patches for information about AI-generated patches.
The person who has signed off on the patch is responsible for
addressing comments.
syzbot engineers can be reached at syzkaller@googlegroups.com.
