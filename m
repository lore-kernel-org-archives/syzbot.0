Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E759C463B66;
	Fri, 14 Aug 2026 12:00:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786708846; cv=none; b=Mg1M4bW/k4xojzM6BqyxgRLjN8EYBj04+/TY5rsmkYZ3swpOo8cewhqEuoNtSbjoDtblQK/uxI7DeUMtu6Cx1OrbxT5Y8x0rAkMaWnIeznAPpeuarMU7hmIGaeoDMG7t+gJbPdxBbQPvJ1tV2J/eRz6F73M5ttd/vnGDxxdQMmo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786708846; c=relaxed/simple;
	bh=rFk09Bb53+K74sovTi6N2QPwmW4Ff1AbnPCrP54XhZw=;
	h=From:To:Cc:Subject:Message-ID:MIME-Version:Content-Type:Date; b=Fbr17pLOorcCC6E40PetAbCa18jkuYB2oP2YZ0qxSttnYI537Pf70E8LH6ZWZgvcBnYLK02Uef1nBa+2FDy+zPnu9FGNikqgYR42PeQKfhKMFxSwgGsQqv9GvsG6E4OII/mwNHek3jQaJxMyndc01o6DT42ZrX62X4XIozsWxkk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Ko2TV0SK; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Ko2TV0SK"
Received: by smtp.kernel.org (Postfix) with UTF8SMTPSA id 1C6B21F000E9;
	Fri, 14 Aug 2026 12:00:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1786708844;
	bh=qZ+vwQsKOZyf98JxhPjZ+yNNOmKTKmOjpcXZsYWCH2k=;
	h=From:To:Cc:Subject:Date;
	b=Ko2TV0SKBmQsYOYWLf0ildLi/sM15I4xh+j21JS0l33T6svZ25PP5wXo28JnTP5mK
	 Vst0sfr6dYX2iqTEpG+cuXx1kYIAdQiWxA4ajeSl11M/AP1CoIO98HJh4xoOGR7Jn+
	 r+UGhtDm2WpzDHNVKoVMUMcG1KDvFB3HtzoNzarbkZeaELXdURuXP92ynbbD08nVpG
	 5/bjg50xU6Vbm9w4xiSgXTZd+Nu58fBUjFV4sU4MMncM4zEI+M4hYGzoLUKK8KQv1Z
	 gukqv/yhmfcRPO7bDaf3bMiphG54Ejsux890wmsWKHY7vupbIxvC51X1jwyMMPW48f
	 HjinW2Ba+IbCQ==
From: "syzbot" <syzbot@kernel.org>
To: syzkaller-bugs@googlegroups.com, Aleksandr Nogikh <nogikh@google.com>, "Greg Kroah-Hartman" <gregkh@linuxfoundation.org>, <linux-usb@vger.kernel.org>, "Michael Grzeschik" <m.grzeschik@pengutronix.de>
Cc: Frank.Li@nxp.com, hhhuuu@google.com, kees@kernel.org, linux-kernel@vger.kernel.org, meatuni001@gmail.com, panjunzhong@linux.spacemit.com, syzbot@lists.linux.dev, xu.yang_2@nxp.com
Subject: [PATCH] usb: gadget: uvc: check endpoint enabled state in uvcg_video_enable()
Message-ID: <8fff0312-bd04-44e4-8df3-b60d3bc849bf@mail.kernel.org>
Precedence: bulk
X-Mailing-List: syzbot@lists.linux.dev
List-Id: <syzbot.lists.linux.dev>
List-Subscribe: <mailto:syzbot+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:syzbot+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Date: Fri, 14 Aug 2026 12:00:44 +0000 (UTC)

From: Aleksandr Nogikh <nogikh@google.com>

A NULL pointer dereference can occur in uvc_video_prep_requests() if
userspace issues a VIDIOC_STREAMON ioctl before the USB host has fully
configured the streaming endpoint.

When userspace calls VIDIOC_STREAMON, the driver handles it in
uvc_v4l2_streamon(), which in turn calls uvcg_video_enable(). Currently,
uvcg_video_enable() only checks if the endpoint pointer is allocated
(video->ep == NULL), but it fails to check if the endpoint is actually
enabled (video->ep->enabled).

The endpoint descriptor (video->ep->desc) is only assigned when the USB
host explicitly selects the streaming alternate setting via a SET_INTERFACE
control request. If userspace prematurely calls VIDIOC_STREAMON before the
host has selected the streaming alternate setting, video->ep->desc will
still be NULL.

Because uvcg_video_enable() does not verify the endpoint's enabled state,
it proceeds to call uvc_video_alloc_requests() and then
uvc_video_prep_requests(). Inside uvc_video_prep_requests(), the code
unconditionally dereferences video->ep->desc, resulting in a KASAN
null-ptr-deref / general protection fault:

Oops: general protection fault, probably for non-canonical address
0xdffffc0000000000: 0000 [#1] SMP KASAN NOPTI
KASAN: null-ptr-deref in range [0x0000000000000000-0x0000000000000007]
RIP: 0010:usb_endpoint_xfer_isoc include/uapi/linux/usb/ch9.h:571 [inline]
RIP: 0010:uvc_video_prep_requests
drivers/usb/gadget/function/uvc_video.c:508 [inline]
RIP: 0010:uvc_video_alloc_requests
drivers/usb/gadget/function/uvc_video.c:559 [inline]
RIP: 0010:uvcg_video_enable+0x142/0xe70
drivers/usb/gadget/function/uvc_video.c:784
Call Trace:
 <TASK>
 uvc_v4l2_streamon+0x7e/0x110 drivers/usb/gadget/function/uvc_v4l2.c:531
 __video_do_ioctl+0x8af/0xc70 drivers/media/v4l2-core/v4l2-ioctl.c:3133
 video_usercopy+0x860/0x1430 drivers/media/v4l2-core/v4l2-ioctl.c:3475
 v4l2_ioctl+0x18d/0x1e0 drivers/media/v4l2-core/v4l2-dev.c:366
 vfs_ioctl fs/ioctl.c:51 [inline]
 __do_sys_ioctl fs/ioctl.c:597 [inline]
 __se_sys_ioctl+0xfc/0x170 fs/ioctl.c:583

To fix this, update uvcg_video_enable() to also verify that the endpoint is
enabled (!video->ep->enabled). This ensures that if userspace prematurely
calls VIDIOC_STREAMON, the driver will safely reject the request with
-ENODEV instead of crashing the kernel.

Fixes: 48dbe731171e ("usb: gadget: uvc: set req_size and n_requests based on the frame interval")
Assisted-by: Gemini:gemini-3.6-flash Gemini:gemini-3.1-pro-preview syzbot
Reported-by: syzbot+44835f0858f11e3e923c@syzkaller.appspotmail.com
Closes: https://syzkaller.appspot.com/bug?extid=44835f0858f11e3e923c
Link: https://syzkaller.appspot.com/ai_job?id=6bcd0cc3-0532-4cbc-81bd-e487719ff9a3
Signed-off-by: Aleksandr Nogikh <nogikh@google.com>

---
diff --git a/drivers/usb/gadget/function/uvc_v4l2.c b/drivers/usb/gadget/function/uvc_v4l2.c
index dfa0521a2..da857c2c5 100644
--- a/drivers/usb/gadget/function/uvc_v4l2.c
+++ b/drivers/usb/gadget/function/uvc_v4l2.c
@@ -527,6 +527,12 @@ uvc_v4l2_streamon(struct file *file, void *fh, enum v4l2_buf_type type)
 	if (type != video->queue.queue.type)
 		return -EINVAL;
 
+	if (uvc->state == UVC_STATE_STREAMING)
+		return 0;
+
+	if (uvc->state != UVC_STATE_CONNECTED)
+		return -ENODEV;
+
 	/* Enable UVC video. */
 	ret = uvcg_video_enable(video);
 	if (ret < 0)
diff --git a/drivers/usb/gadget/function/uvc_video.c b/drivers/usb/gadget/function/uvc_video.c
index 2f9700b3f..d4aeedacc 100644
--- a/drivers/usb/gadget/function/uvc_video.c
+++ b/drivers/usb/gadget/function/uvc_video.c
@@ -764,7 +764,7 @@ int uvcg_video_enable(struct uvc_video *video)
 {
 	int ret;
 
-	if (video->ep == NULL) {
+	if (video->ep == NULL || !video->ep->enabled) {
 		uvcg_info(&video->uvc->func,
 			  "Video enable failed, device is uninitialized.\n");
 		return -ENODEV;


base-commit: db2ddb87143519e20a95aa36c60b36107b736a58
-- 
See https://goo.gle/syzbot-ai-patches for information about AI-generated patches.
The person who has signed off on the patch is responsible for
addressing comments.
syzbot engineers can be reached at syzkaller@googlegroups.com.
