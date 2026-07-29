Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 949EC233949
	for <syzbot@lists.linux.dev>; Wed, 29 Jul 2026 08:26:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785313622; cv=none; b=q9lN+uUkvLG9PzGnthRIdOPDelwWcuQKWrDS62lgEVnlIk7nGG+hrfoWfbS3dGDEVH1i5eiXjFuDSpbuG1trfUDz0yO87VU46X8cq2XYbWgqJbKvk0j0IlZn1pmzMKIAkTknfRW8Mwhsvtj7X7p0aEXmA6DK+Uvcfjw+HwhdGE8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785313622; c=relaxed/simple;
	bh=7Ee5gySrBteNPXG0pNT80wHTSjlJ6baWBUs3io2buIc=;
	h=From:To:Cc:Subject:Message-ID:MIME-Version:Content-Type:Date; b=atIFUb1Ynq+yZVR1Rf/GW+Ue1m2TKDTILdpxJwFE/4ksxSNVYMaCIRelMjIUTCklpA6z2Tdj0KGU1yYigwaRBvSY6IxTbfMoTVgppLlXSKX7vD+IEv+V7ed20+TvWf+Rf+/fP7os3KTedpAs2IwrbqC2304NIuVLTWvBrOf5X+o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=VGTpDHN1; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="VGTpDHN1"
Received: by smtp.kernel.org (Postfix) with UTF8SMTPSA id 774331F00A3E;
	Wed, 29 Jul 2026 08:26:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1785313614;
	bh=wQs7fFOJt5ksPrb2wrs2+xhLo2w4maUyASlgKKtxH7w=;
	h=From:To:Cc:Subject:Date;
	b=VGTpDHN1tniU4CrroQ7Z/2qpN1jywWwg+0oqzQ8vpp8BsYwusKLAq+l4CvTLh4efg
	 UmoFjeCQiuoRexJ/xiX7ACb2P1V+V9+CjhP5VOz91GW+LDZ8VY0DJCVYEDwDTAsDsP
	 /mwUJ/9gsY3Qx5LJvUQk8IyP7NrXYy2tJLQuwG2FuQO0dc/gxsUGe4Mx+yx8bsurGh
	 IzzFrFY1cqK8tijo6p+kk6mKgcq1iaBN4bvyIkYjN4mWBL/aO1jjx1tw78VKjXNKGH
	 W2/dHIdxBe4Kg6Gb3HDmr3VLNf51x98FfF2lm4DmjTS0rpi+qpJCMG38GzDRj0YCXB
	 +i45UmnxyKzzA==
From: "syzbot" <syzbot@kernel.org>
To: syzkaller-upstream-moderation@googlegroups.com
Cc: syzbot@lists.linux.dev
Subject: [PATCH RFC] usb: usbtest: fix NULL pointer dereference in usbtest_probe
Message-ID: <a265f64a-bbf1-4c1c-b1d6-d1d79f78e228@mail.kernel.org>
Precedence: bulk
X-Mailing-List: syzbot@lists.linux.dev
List-Id: <syzbot.lists.linux.dev>
List-Subscribe: <mailto:syzbot+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:syzbot+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Date: Wed, 29 Jul 2026 08:26:54 +0000 (UTC)

The usbtest driver relies on the driver_info field of the usb_device_id
structure to hold a pointer to a struct usbtest_info, which contains
necessary configuration for the device. When a new device ID is dynamically
added via the sysfs new_id interface without specifying a reference device,
the driver_info field defaults to 0. When the USB core binds the device
using this dynamic ID, usbtest_probe() unconditionally casts the 0 to a
pointer, resulting in a NULL pointer dereference when attempting to access
the autoconf bitfield (at offset 0xa) of the struct usbtest_info.

This leads to the following crash:

Oops: general protection fault, probably for non-canonical address
0xdffffc0000000001: 0000 [#1] SMP KASAN NOPTI
KASAN: null-ptr-deref in range [0x0000000000000008-0x000000000000000f]
RIP: 0010:usbtest_probe+0x522/0xcc0 drivers/usb/misc/usbtest.c:2822
Call Trace:
 <TASK>
 usb_probe_interface+0x653/0xc60 drivers/usb/core/driver.c:396
 call_driver_probe drivers/base/dd.c:-1 [inline]
 really_probe+0x254/0xae0 drivers/base/dd.c:706
 __driver_probe_device+0x1e8/0x360 drivers/base/dd.c:868
 driver_probe_device+0x4f/0x240 drivers/base/dd.c:898
 __device_attach_driver+0x270/0x410 drivers/base/dd.c:1026
 bus_for_each_drv+0x258/0x2f0 drivers/base/bus.c:500
 __device_attach+0x2c4/0x450 drivers/base/dd.c:1098
 device_initial_probe+0xa1/0xd0 drivers/base/dd.c:1153
 bus_probe_device+0x12a/0x220 drivers/base/bus.c:620
 device_add+0x7d7/0xb80 drivers/base/core.c:3772
 usb_set_configuration+0x1ad8/0x2180 drivers/usb/core/message.c:2268
 usb_generic_driver_probe+0x8d/0x150 drivers/usb/core/generic.c:250
 usb_probe_device+0x1c3/0x3b0 drivers/usb/core/driver.c:291

To fix this, validate that id->driver_info is not NULL before proceeding
with the probe. If it is NULL, gracefully return -ENODEV. The check is
placed before any memory allocation to avoid unnecessary work and simplify
error handling.

Fixes: 733260ff9c45 ("[PATCH] USB: add dynamic id functionality to USB core")
Assisted-by: Gemini:gemini-3.5-flash Gemini:gemini-3.1-pro-preview syzbot
Reported-by: syzbot+7e1e5911f9eac50bedc7@syzkaller.appspotmail.com
Closes: https://syzkaller.appspot.com/bug?extid=7e1e5911f9eac50bedc7
Link: https://syzkaller.appspot.com/ai_job?id=9e476ca5-99d1-47d2-b9d1-f3b501897179
To: "Greg Kroah-Hartman" <gregkh@linuxfoundation.org>
To: <linux-usb@vger.kernel.org>
To: "Greg Kroah-Hartman" <gregkh@suse.de>
Cc: "Kees Cook" <kees@kernel.org>
Cc: <linux-kernel@vger.kernel.org>

---
diff --git a/drivers/usb/misc/usbtest.c b/drivers/usb/misc/usbtest.c
index 98071b25a..6410b3e26 100644
--- a/drivers/usb/misc/usbtest.c
+++ b/drivers/usb/misc/usbtest.c
@@ -2786,10 +2786,13 @@ usbtest_probe(struct usb_interface *intf, const struct usb_device_id *id)
 	}
 #endif
 
+	info = (struct usbtest_info *) id->driver_info;
+	if (!info)
+		return -ENODEV;
+
 	dev = kzalloc_obj(*dev);
 	if (!dev)
 		return -ENOMEM;
-	info = (struct usbtest_info *) id->driver_info;
 	dev->info = info;
 	mutex_init(&dev->lock);
 


base-commit: f5098b6bae761e346ebcd9da7f95622c04733cff
-- 
This is an AI-generated patch subject to moderation.
Reply with '#syz upstream' to Sign-off the patch as a human author
and send it to the upstream kernel mailing lists.
Reply with '#syz reject' to reject it ('#syz unreject' to undo).

See https://goo.gle/syzbot-ai-patches for information about AI-generated patches.
You can comment on the patch as usual, syzbot will try to address
the comments and send a new version of the patch if necessary.
syzbot engineers can be reached at syzkaller@googlegroups.com.
