Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0124C399D02
	for <syzbot@lists.linux.dev>; Mon, 31 Aug 2026 22:22:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788214966; cv=none; b=etezma5n9DMHd3V29xev3QrBqdLKJs6N+pekaUeGoLhT15TFTjMUWjW4FvPCXucuRcKWerQ2EKycT3D718uzPDVQACPBFg62IBDpHS3TQIm+dkN/dUKo6EyzPt8ItsmUp9Mi6Bfgtzith+5f2ZN6iSY1XuEWKpySi73vNjyp9LI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788214966; c=relaxed/simple;
	bh=fyjj8CwwmFeQt+dWOPSA0iI5PcFBRuWfJThMjYGRooY=;
	h=From:To:Cc:Subject:Message-ID:MIME-Version:Content-Type:Date; b=R9zLw/7Q5NRKnUIAyUT1MnFKJazy4EKRJTIxaexDIeFYJ2QTLoMm30hFJKlJg2eXLCe905XS33CDnFwdb6t/RKZnSGEaZn1m1oAP8fjo8rQAGCcDFRmnJ9GkrDvxHIiE+N4uPrInOrfWSNK1KD2lW/iAwONlROcNpO7JeI1VIok=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=SoJj4AgO; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="SoJj4AgO"
Received: by smtp.kernel.org (Postfix) with UTF8SMTPSA id B60A71F000E9;
	Mon, 31 Aug 2026 22:22:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788214964;
	bh=NpcOrQ7D1KRMFyd2DfjDpFAYj+4+B/wAWCU/QtuZKB0=;
	h=From:To:Cc:Subject:Date;
	b=SoJj4AgOeFGsh9W2TqKtHobGOn7vF+FRid+qPY18zt4KXYrJZ77Bs3IMpDVb8eCyv
	 hdzHUOx8ssioFLXIN4phuMQK8Wu6P64nMg8ag1hPn7grYd35dFrxomZ7KAhzs48vBE
	 1py9PG8laoI4UTpeqBnV+xeqN6rczGoI1/y0alp/3U4Si5cpLrhh8iZA3Gnrm7a6X2
	 3g+CSCNFpqyJ2Ghm829A8u3JyL5dvFCkuAcpHsXU9cUs02zDj+zsLSzIPXWlzW8ELp
	 MJTa4W7Jrw2CZ+bg/gr/eAkPBIJiCgH3K+MQvzul05ceWcvYcZN0+DHXnb/nikJvYH
	 01QvNlYK0uT7g==
From: "syzbot" <syzbot@kernel.org>
To: syzkaller-upstream-moderation@googlegroups.com
Cc: syzbot@lists.linux.dev
Subject: [PATCH RFC] Input: sur40 - fix use-after-free on disconnect
Message-ID: <c305426b-d890-42d1-8202-c0e48512c8a3@mail.kernel.org>
Precedence: bulk
X-Mailing-List: syzbot@lists.linux.dev
List-Id: <syzbot.lists.linux.dev>
List-Subscribe: <mailto:syzbot+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:syzbot+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Date: Mon, 31 Aug 2026 22:22:44 +0000 (UTC)

In sur40_probe(), struct sur40_state is allocated and embeds struct
video_device and struct v4l2_device. When the USB device is disconnected,
sur40_disconnect() directly frees the sur40_state structure via kfree().
However, if a user space process has an open file descriptor on the video
device at the time of disconnection, the file descriptor retains a
reference to the video device. When the process subsequently closes the
file descriptor, v4l2_release() is called and attempts to access
vdev->v4l2_dev inside the already freed sur40_state structure, triggering a
slab-use-after-free.

BUG: KASAN: slab-use-after-free in v4l2_release+0xb5/0x350
drivers/media/v4l2-core/v4l2-dev.c:466
Read of size 8 at addr ffff8881fb29c658 by task v4l_id/9888

Call Trace:
 <TASK>
 dump_stack_lvl+0xe8/0x150 lib/dump_stack.c:120
 print_report+0x58/0x70 mm/kasan/report.c:482
 kasan_report+0x117/0x150 mm/kasan/report.c:595
 v4l2_release+0xb5/0x350 drivers/media/v4l2-core/v4l2-dev.c:466
 __fput+0x418/0xa50 fs/file_table.c:512
 fput_close_sync+0x11f/0x240 fs/file_table.c:617
 __x64_sys_close+0x7e/0x110 fs/open.c:1545
 do_syscall_64+0x166/0x520 arch/x86/entry/syscall_64.c:84
 entry_SYSCALL_64_after_hwframe+0x77/0x7f
 </TASK>

Allocated by task 53:
 kasan_save_stack mm/kasan/common.c:57 [inline]
 kasan_save_track+0x3e/0x80 mm/kasan/common.c:78
 __kasan_kmalloc+0x93/0xb0 mm/kasan/common.c:415
 _kzalloc_noprof include/linux/slab.h:1312 [inline]
 sur40_probe+0x16c/0xfa0 drivers/input/touchscreen/sur40.c:675
 usb_probe_interface+0x788/0xe50 drivers/usb/core/driver.c:399
 really_probe+0x254/0xae0 drivers/base/dd.c:706
 driver_probe_device+0x4f/0x240 drivers/base/dd.c:898

Freed by task 53:
 kasan_save_stack mm/kasan/common.c:57 [inline]
 kasan_save_track+0x3e/0x80 mm/kasan/common.c:78
 kasan_save_free_info+0x40/0x50 mm/kasan/generic.c:584
 __kasan_slab_free+0x5c/0x80 mm/kasan/common.c:285
 kfree+0x1c5/0x650 mm/slub.c:6792
 sur40_disconnect+0xaf/0x140 drivers/input/touchscreen/sur40.c:835
 usb_unbind_interface+0x295/0x9f0 drivers/usb/core/driver.c:461
 device_release_driver_internal+0x4f5/0x880 drivers/base/dd.c:1372

To fix this, tie the lifetime of the sur40_state structure to the refcount
of struct v4l2_device by implementing a sur40_video_release() callback and
assigning it to sur40->v4l2.release. In sur40_disconnect(), call
v4l2_device_disconnect() and v4l2_device_put() so that the memory is freed
only when the last reference to the v4l2_device is released. Also update
the error cleanup path in sur40_probe() to use v4l2_device_put() after
v4l2_device_register() succeeds.

Fixes: e831cd251fb9 ("[media] add raw video stream support for Samsung SUR40")
Assisted-by: Gemini:gemini-3.7-flash Gemini:gemini-3.1-pro-preview syzbot
Reported-by: syzbot+2a123f6269da57ffefaa@syzkaller.appspotmail.com
Closes: https://syzkaller.appspot.com/bug?extid=2a123f6269da57ffefaa
Link: https://syzkaller.appspot.com/ai_job?id=23a1aec1-d3a0-425c-995e-9788f0e98e07
To: "Dmitry Torokhov" <dmitry.torokhov@gmail.com>
To: <linux-input@vger.kernel.org>
To: "Florian Echtler" <floe@butterbrot.org>
Cc: "Kees Cook" <kees@kernel.org>
Cc: <linux-kernel@vger.kernel.org>
Cc: "Oliver" <oliverburns.kernel@gmail.com>

---
diff --git a/drivers/input/touchscreen/sur40.c b/drivers/input/touchscreen/sur40.c
index 09d8c5f8d..a525011a1 100644
--- a/drivers/input/touchscreen/sur40.c
+++ b/drivers/input/touchscreen/sur40.c
@@ -647,6 +647,17 @@ static int sur40_input_setup_events(struct input_dev *input_dev)
 	return 0;
 }
 
+static void sur40_video_release(struct v4l2_device *v)
+{
+	struct sur40_state *sur40 =
+		container_of(v, struct sur40_state, v4l2);
+
+	v4l2_ctrl_handler_free(&sur40->hdl);
+	v4l2_device_unregister(&sur40->v4l2);
+	kfree(sur40->bulk_in_buffer);
+	kfree(sur40);
+}
+
 /* Check candidate USB interface. */
 static int sur40_probe(struct usb_interface *interface,
 		       const struct usb_device_id *id)
@@ -726,6 +737,7 @@ static int sur40_probe(struct usb_interface *interface,
 	}
 
 	/* register the video master device */
+	sur40->v4l2.release = sur40_video_release;
 	snprintf(sur40->v4l2.name, sizeof(sur40->v4l2.name), "%s", DRIVER_LONG);
 	error = v4l2_device_register(sur40->dev, &sur40->v4l2);
 	if (error) {
@@ -743,7 +755,7 @@ static int sur40_probe(struct usb_interface *interface,
 	/* initialize the queue */
 	error = vb2_queue_init(&sur40->queue);
 	if (error)
-		goto err_unreg_v4l2;
+		goto err_v4l2_put;
 
 	sur40->pix_fmt = sur40_pix_format[0];
 	sur40->vdev = sur40_video_device;
@@ -778,16 +790,15 @@ static int sur40_probe(struct usb_interface *interface,
 	if (sur40->hdl.error) {
 		dev_err(&interface->dev,
 			"Unable to register video controls.");
-		v4l2_ctrl_handler_free(&sur40->hdl);
 		error = sur40->hdl.error;
-		goto err_unreg_v4l2;
+		goto err_v4l2_put;
 	}
 
 	error = video_register_device(&sur40->vdev, VFL_TYPE_TOUCH, -1);
 	if (error) {
 		dev_err(&interface->dev,
 			"Unable to register video subdevice.");
-		goto err_free_ctrl;
+		goto err_v4l2_put;
 	}
 
 	/* register the polled input device */
@@ -806,10 +817,10 @@ static int sur40_probe(struct usb_interface *interface,
 
 err_unreg_video:
 	video_unregister_device(&sur40->vdev);
-err_free_ctrl:
-	v4l2_ctrl_handler_free(&sur40->hdl);
-err_unreg_v4l2:
-	v4l2_device_unregister(&sur40->v4l2);
+err_v4l2_put:
+	input_free_device(input);
+	v4l2_device_put(&sur40->v4l2);
+	return error;
 err_free_buffer:
 	kfree(sur40->bulk_in_buffer);
 err_free_input:
@@ -827,12 +838,9 @@ static void sur40_disconnect(struct usb_interface *interface)
 
 	input_unregister_device(sur40->input);
 
-	v4l2_ctrl_handler_free(&sur40->hdl);
+	v4l2_device_disconnect(&sur40->v4l2);
 	video_unregister_device(&sur40->vdev);
-	v4l2_device_unregister(&sur40->v4l2);
-
-	kfree(sur40->bulk_in_buffer);
-	kfree(sur40);
+	v4l2_device_put(&sur40->v4l2);
 
 	usb_set_intfdata(interface, NULL);
 	dev_dbg(&interface->dev, "%s is now disconnected\n", DRIVER_DESC);


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
