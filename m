Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CD3A744CF34
	for <syzbot@lists.linux.dev>; Wed, 12 Aug 2026 13:28:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786541337; cv=none; b=jsXL3+a+rqfCcdt+5a9aQ3KoHDXxmp+pdOl8RrT18osD12BTKtZXVsEJpxohY8KBiLZokXIqRSM5adRFrCe4kAGdjzIs15An/7XJYsJhlh+T23DgXPV1HnP0mLaQycuIGDIXuRGb+8EKFry1AmBaNPFuBOEln5AETpj+lnWcjrQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786541337; c=relaxed/simple;
	bh=Ygd98qbJ9/1sedRkWkIhsVxVqTLnT0koUzJHikRmvaM=;
	h=From:To:Cc:Subject:Message-ID:MIME-Version:Content-Type:Date; b=s3gqLRPUKTGMeRhUATgTk8oh0NWVJFU0A9ggpj1ZzFzfa80lC2+oebMN0vKWF55zN3IJMILD5Xcg8tOIvXX1yP7CdBpQ8ox69f7ul4eu1Ivr2/AfM/TVo9CFa44BLCuR02xC1D3NnjovKauSf7zfps7wmhzYnCdjuXWl10BQrYc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=gmkkmd8G; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="gmkkmd8G"
Received: by smtp.kernel.org (Postfix) with UTF8SMTPSA id 8E80E1F000E9;
	Wed, 12 Aug 2026 13:28:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1786541329;
	bh=yddvG1kOrhq90KEb1z2CrCkm0A9eS5aGW5Ff6NPm+pU=;
	h=From:To:Cc:Subject:Date;
	b=gmkkmd8GuWqOKkP07fmizWKiil1Gpro3ThUQ8j31bBhS1kDka7lbocQuh0WueeCIo
	 mbcDWn3913NEA6Y1xUX9yOiadRTA+wssf5UDWNI4TgdJ+bQQG1+QL0io75AhKbTmb9
	 aqbSQbah/gv5abhrGdQPtB0VWKIEupa+AIkEyU0RqlChilNCMMk4bs1XCqr6zjZAaL
	 rNWqYBdCcW/+akdB3g6iGJp9PowONedtX6G4BAK1IoGk+eu3CbIoMb6NGp7MXtE0Bm
	 /Q9E3OpZ/wkPQrTYef9MKcEu0olm33tGMcbkV4oPAlBagJOfpaU3Aif0d9MyyoM+Wz
	 5xc8QLOtR4V8w==
From: "syzbot" <syzbot@kernel.org>
To: syzkaller-upstream-moderation@googlegroups.com
Cc: nogikh@google.com, syzbot@lists.linux.dev
Subject: [PATCH RFC v2] usb: gadget: uvc: check endpoint enabled state in uvcg_video_enable()
Message-ID: <0062e956-a8d4-4c8e-a25e-4deb5ff85b4b@mail.kernel.org>
Precedence: bulk
X-Mailing-List: syzbot@lists.linux.dev
List-Id: <syzbot.lists.linux.dev>
List-Subscribe: <mailto:syzbot+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:syzbot+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Date: Wed, 12 Aug 2026 13:28:49 +0000 (UTC)

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
Assisted-by: Gemini:gemini-3.5-flash Gemini:gemini-3.1-pro-preview syzbot
Reported-by: syzbot+44835f0858f11e3e923c@syzkaller.appspotmail.com
Closes: https://syzkaller.appspot.com/bug?extid=44835f0858f11e3e923c
Link: https://syzkaller.appspot.com/ai_job?id=e3902952-fe28-4ca4-a910-c485a9927925
To: "Greg Kroah-Hartman" <gregkh@linuxfoundation.org>
To: <linux-usb@vger.kernel.org>
To: "Michael Grzeschik" <m.grzeschik@pengutronix.de>
Cc: "Frank Li" <Frank.Li@nxp.com>
Cc: "Jimmy Hu" <hhhuuu@google.com>
Cc: "Hans Verkuil" <hverkuil+cisco@kernel.org>
Cc: "Kees Cook" <kees@kernel.org>
Cc: "Laurent Pinchart" <laurent.pinchart+renesas@ideasonboard.com>
Cc: <linux-kernel@vger.kernel.org>
Cc: "Muhammad Bilal" <meatuni001@gmail.com>
Cc: "Junzhong Pan" <panjunzhong@linux.spacemit.com>
Cc: "Xu Yang" <xu.yang_2@nxp.com>

---
v2:
- Check that uvc->state is UVC_STATE_CONNECTED in uvc_v4l2_streamon() before allowing streaming.
- Update uvc->state to UVC_STATE_STREAMING before calling uvcg_video_enable(), and revert it on failure.
- Check video->ep->desc in addition to video->ep->enabled in uvcg_video_enable().
- Add safety checks for video->ep, video->ep->enabled, and video->ep->desc in uvc_video_alloc_requests().

v1:
https://lore.kernel.org/all/f345b3ad-4dff-4a90-8a9e-672979e4a8ba@mail.kernel.org/T/
---
diff --git a/drivers/usb/gadget/function/uvc_v4l2.c b/drivers/usb/gadget/function/uvc_v4l2.c
index dfa0521a2..a80663c9a 100644
--- a/drivers/usb/gadget/function/uvc_v4l2.c
+++ b/drivers/usb/gadget/function/uvc_v4l2.c
@@ -527,17 +527,24 @@ uvc_v4l2_streamon(struct file *file, void *fh, enum v4l2_buf_type type)
 	if (type != video->queue.queue.type)
 		return -EINVAL;
 
+	if (uvc->state != UVC_STATE_CONNECTED)
+		return -ENODEV;
+
+	uvc->state = UVC_STATE_STREAMING;
+
 	/* Enable UVC video. */
 	ret = uvcg_video_enable(video);
-	if (ret < 0)
+	if (ret < 0) {
+		if (uvc->state == UVC_STATE_STREAMING)
+			uvc->state = UVC_STATE_CONNECTED;
 		return ret;
+	}
 
 	/*
 	 * Complete the alternate setting selection setup phase now that
 	 * userspace is ready to provide video frames.
 	 */
 	uvc_function_setup_continue(uvc, 0);
-	uvc->state = UVC_STATE_STREAMING;
 
 	return 0;
 }
diff --git a/drivers/usb/gadget/function/uvc_video.c b/drivers/usb/gadget/function/uvc_video.c
index 2f9700b3f..bd67a9d80 100644
--- a/drivers/usb/gadget/function/uvc_video.c
+++ b/drivers/usb/gadget/function/uvc_video.c
@@ -551,6 +551,9 @@ uvc_video_alloc_requests(struct uvc_video *video)
 	unsigned int i;
 	int ret = -ENOMEM;
 
+	if (video->ep == NULL || !video->ep->enabled || !video->ep->desc)
+		return -ENODEV;
+
 	/*
 	 * calculate in uvc_video_prep_requests
 	 * - video->uvc_num_requests
@@ -764,7 +767,7 @@ int uvcg_video_enable(struct uvc_video *video)
 {
 	int ret;
 
-	if (video->ep == NULL) {
+	if (video->ep == NULL || !video->ep->enabled || !video->ep->desc) {
 		uvcg_info(&video->uvc->func,
 			  "Video enable failed, device is uninitialized.\n");
 		return -ENODEV;


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
