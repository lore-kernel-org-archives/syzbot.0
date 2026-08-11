Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6EDA3418340
	for <syzbot@lists.linux.dev>; Tue, 11 Aug 2026 21:16:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786483017; cv=none; b=jTEQyTpOPs4ObdAnWVqf6xju/egrmdaA/W2Zc/FpNz5ma0mnX7NH+U2DmYI9nl+ESYqd2F4UM2Z8J5u70ytBxsCH0r5O0IhTdjb3U7ikWZ4Z9So6VJrmsTmjR9W+QajSW+4uZ7jGtuUFMA+nfleBxUCpQSheiIm0+USdxfw/ECc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786483017; c=relaxed/simple;
	bh=ppRPobPS74JdkGWvukYj6+HEkvlWp/SJnqnLCKAbQc8=;
	h=From:To:Cc:Subject:Message-ID:MIME-Version:Content-Type:Date; b=QCPjalM1DG927GXVl4TOXM3y3HXgpc4il8gvMUH/gmP5UcUW1INKA2QYXFZCoxzy2oCm6eTX0IfywJY+0/KsX5u9ZloxTJeVfIYTNz5uBmYohWr/301qawkYS5cW0JxFBwNfdZXrOMq/KNF6cyxX6oIBzX7icn0ceFqse2XQNX8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=KbySESao; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="KbySESao"
Received: by smtp.kernel.org (Postfix) with UTF8SMTPSA id 468E11F000E9;
	Tue, 11 Aug 2026 21:16:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1786483009;
	bh=TaJHvEPKW09t3BHNvD0nv2g5DhY2hmMM1Q4Y2eah5JA=;
	h=From:To:Cc:Subject:Date;
	b=KbySESaodtucnIl1FpvNAQg6kg6l+jHtWKqKB7oAuZSXzmqGIX5sygJIOJB/1ojlM
	 ThWGaWzaInsIA/PAH9Nod2cyNMv8OWGo/t/IqvqwTv3esj/cFLWkYV6dnv2d9WSvqI
	 qXpLoNKnU9HqAg3FNhXvumCb5P+NfoMfV9ntoDzfKeh/6ZyTK7yEULolE3PvUqKkBk
	 9bDQffjjWvAKEztNL/rv4syBk8R0/KhyDAoOLRB2JikbmY8PDYhQHKvXSgPg0mltt1
	 qrKY5MKBq0vz2kzacw4lFnVbGHTkzSg7NuZudWwpeJgVhfabiueLvWKbBvMIAWyD1e
	 z1dv5z0Pp2npg==
From: "syzbot" <syzbot@kernel.org>
To: syzkaller-upstream-moderation@googlegroups.com
Cc: syzbot@lists.linux.dev
Subject: [PATCH RFC] usb: gadget: uvc: check endpoint enabled state in uvcg_video_enable()
Message-ID: <f345b3ad-4dff-4a90-8a9e-672979e4a8ba@mail.kernel.org>
Precedence: bulk
X-Mailing-List: syzbot@lists.linux.dev
List-Id: <syzbot.lists.linux.dev>
List-Subscribe: <mailto:syzbot+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:syzbot+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Date: Tue, 11 Aug 2026 21:16:49 +0000 (UTC)

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
Link: https://syzkaller.appspot.com/ai_job?id=7c0e5e06-0c49-4143-aeab-5a4c53b4bdaa
To: "Greg Kroah-Hartman" <gregkh@linuxfoundation.org>
To: <linux-usb@vger.kernel.org>
To: "Michael Grzeschik" <m.grzeschik@pengutronix.de>
Cc: "Frank Li" <Frank.Li@nxp.com>
Cc: "Kees Cook" <kees@kernel.org>
Cc: <linux-kernel@vger.kernel.org>
Cc: "Junzhong Pan" <panjunzhong@linux.spacemit.com>
Cc: "Xu Yang" <xu.yang_2@nxp.com>

---
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
This is an AI-generated patch subject to moderation.
Reply with '#syz upstream' to Sign-off the patch as a human author
and send it to the upstream kernel mailing lists.
Reply with '#syz reject' to reject it ('#syz unreject' to undo).

See https://goo.gle/syzbot-ai-patches for information about AI-generated patches.
You can comment on the patch as usual, syzbot will try to address
the comments and send a new version of the patch if necessary.
syzbot engineers can be reached at syzkaller@googlegroups.com.
