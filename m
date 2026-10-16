Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6BF9E55931E
	for <syzbot@lists.linux.dev>; Fri, 16 Oct 2026 18:57:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792177028; cv=none; b=jo7zQctLw+STmXYt44jLYCLACB9Q2YhWXKDdiH4OqCpgRnToDs9wWTHGHZmhOVKOTeqGkVDIDPppdRfAgWYHFuCL9MAchZr1T7MEkre2+9ganlYwYJI7D2REdZVpmUCDTd+yM9rFZuDmCO8ZfDAs2doXzSkdUm9EMEtPSBoa9ic=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792177028; c=relaxed/simple;
	bh=SWU5wNk4jVjZFiG+kUdFb67gZCbmy8MX1FtQ3pDr0dM=;
	h=From:To:Cc:Subject:Message-ID:MIME-Version:Content-Type:Date; b=QFBDc6GA+ZI+f+9l+wL7I28yPdUFp71wZOKojdJeD1zOIj2Rl4EfD0oKWLYlU6Z2AYgm3If1BclWBuBRloli5FwlE6BkTOLdQ/V33d63NKaKQzx6QnAzmRNSy4UFovZEaxlz9qxQuKg2zbLDQcu2siNyNeuSqM3mYVPt092L/Y8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=ar+0oAw7; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="ar+0oAw7"
Received: by smtp.kernel.org (Postfix) with UTF8SMTPSA id ED4921F000C4;
	Fri, 16 Oct 2026 18:57:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1792177027;
	bh=SR3YjUGxNP0utvimey+7WtOcXpqgizk7QDdt2paMNBk=;
	h=From:To:Cc:Subject:Date;
	b=ar+0oAw7ESGNvqiC7/qBXv13J519lvuw7cJhMFxxWC5I4nxoF3q8H+SsLSCssQaZL
	 ZUw7Sy3ROWTQ33/LpCtU1fZo6Q3xyC57AfUsKhKtS7WvvQXx+7mVMNejaMb+D5oslU
	 8xR+J3rEsZy8KxqhXTwuOz36VFgR79sqP/e+uIGUXYwG0KdtIP5XhKpc1vogz1dN0L
	 J3rgHVddHy0TWdwhYJQnqJqKG3oEOXIcDY5tbkGiamu3xsIxYbLmCzugwHYOc6++7q
	 hzmjtx1+OHbaYUD1A0i3trphKQVhsFQ10H276f9f0VQpkZah6lf6q8Dy4aVt4Yo/Ew
	 5VJD55gzVEgpw==
From: "syzbot" <syzbot@kernel.org>
To: syzkaller-upstream-moderation@googlegroups.com
Cc: syzbot@lists.linux.dev
Subject: [PATCH RFC] media: em28xx: initialize videobuf2 queues before device registration
Message-ID: <2fdb5af1-fad9-47fe-93dc-d1400f44b60b@mail.kernel.org>
Precedence: bulk
X-Mailing-List: syzbot@lists.linux.dev
List-Id: <syzbot.lists.linux.dev>
List-Subscribe: <mailto:syzbot+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:syzbot+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Date: Fri, 16 Oct 2026 18:57:06 +0000 (UTC)

In em28xx_v4l2_init(), the videobuf2 queues (v4l2->vb_vidq and
v4l2->vb_vbiq) are assigned to v4l2->vdev.queue and v4l2->vbi_dev.queue,
and the video devices are registered with video_register_device() before
em28xx_vb2_setup() is called to initialize the queues via vb2_queue_init().

When an error occurs after video_register_device() succeeds but before
em28xx_vb2_setup() is reached (such as v4l2_mc_create_media_graph() failing
when no decoder is present), the error cleanup path at unregister_dev calls
vb2_video_unregister_device() on the registered devices. Because
vdev->queue is set, vb2_video_unregister_device() calls
vb2_queue_release(), which invokes __vb2_queue_cancel(). However, because
vb2_queue_init() was never called on the queue, its internal locks and
waitqueue heads remain zero-filled. This triggers a lockdep warning when
acquiring q->done_wq.lock, followed by a NULL pointer dereference in
__wake_up_common() when dereferencing the uninitialized waitqueue head:

INFO: trying to register non-static key.
The code is fine but needs lockdep annotation, or maybe
you didn't initialize this object before use?
turning off the locking correctness validator.
Call Trace:
 <TASK>
 dump_stack_lvl+0xe8/0x150 lib/dump_stack.c:120
 register_lock_class+0xcc/0x2e0 kernel/locking/lockdep.c:1343
 __lock_acquire+0x10c/0x2de0 kernel/locking/lockdep.c:5162
 lock_acquire+0x115/0x350 kernel/locking/lockdep.c:5942
 _raw_spin_lock_irqsave+0x40/0x60 kernel/locking/spinlock.c:181
 __wake_up_common_lock+0x30/0x1f0 kernel/sched/wait.c:125
 __vb2_queue_cancel+0x2de/0xde0
 drivers/media/common/videobuf2/videobuf2-core.c:2244
 vb2_core_queue_release+0x2f/0x150
 drivers/media/common/videobuf2/videobuf2-core.c:2677
 vb2_queue_release drivers/media/common/videobuf2/videobuf2-v4l2.c:943
 [inline]
 vb2_video_unregister_device+0x15b/0x200
 drivers/media/common/videobuf2/videobuf2-v4l2.c:1279
 em28xx_v4l2_init+0x1a12/0x2df0
 drivers/media/usb/em28xx/em28xx-video.c:3097
 </TASK>
Oops: general protection fault, probably for non-canonical address
0xdffffc0000000000: 0000 [#1] SMP KASAN NOPTI
KASAN: null-ptr-deref in range [0x0000000000000000-0x0000000000000007]
RIP: 0010:__wake_up_common kernel/sched/wait.c:105 [inline]
RIP: 0010:__wake_up_common_lock+0xd6/0x1f0 kernel/sched/wait.c:126
Call Trace:
 <TASK>
 __vb2_queue_cancel+0x2de/0xde0
 drivers/media/common/videobuf2/videobuf2-core.c:2244
 vb2_core_queue_release+0x2f/0x150
 drivers/media/common/videobuf2/videobuf2-core.c:2677
 vb2_queue_release drivers/media/common/videobuf2/videobuf2-v4l2.c:943
 [inline]
 vb2_video_unregister_device+0x15b/0x200
 drivers/media/common/videobuf2/videobuf2-v4l2.c:1279
 em28xx_v4l2_init+0x1a12/0x2df0
 drivers/media/usb/em28xx/em28xx-video.c:3097
 </TASK>

Additionally, if em28xx_v4l2_init() fails, dev->v4l2 is left set. When the
device is later disconnected, em28xx_close_extension() invokes
em28xx_v4l2_fini(), which calls v4l2_device_put() a second time and leads
to a use-after-free.

Fix this by moving em28xx_vb2_setup() before video_register_device() and
checking its return value so that queues are initialized prior to device
registration and any subsequent cleanup. In em28xx_vb2_setup(), initialize
vb_queue_lock and vb_vbi_queue_lock and assign q->lock before calling
vb2_queue_init(), and make VBI queue initialization conditional on
em28xx_vbi_supported(). Finally, set dev->v4l2 to NULL under dev->lock in
both the unregister_dev error path and in em28xx_v4l2_fini() to prevent
em28xx_v4l2_fini() from performing a duplicate teardown upon disconnect.

Fixes: 7c8bf63b7937 ("media: em28xx: use vb2_video_unregister_device")
Assisted-by: Gemini:gemini-4-argon Gemini:gemini-3.8-flash syzbot
Reported-by: syzbot+1a7507a194fff09e5c44@syzkaller.appspotmail.com
Closes: https://syzkaller.appspot.com/bug?extid=1a7507a194fff09e5c44
Link: https://syzkaller.appspot.com/ai_job?id=9fb455aa-6431-4fd2-9460-4bb223f71e03
To: <linux-media@vger.kernel.org>
To: "Mauro Carvalho Chehab" <mchehab@kernel.org>
To: "Hans Verkuil" <hverkuil+cisco@kernel.org>
Cc: <linux-kernel@vger.kernel.org>

---
diff --git a/drivers/media/usb/em28xx/em28xx-video.c b/drivers/media/usb/em28xx/em28xx-video.c
index 79af15476..edcd884ec 100644
--- a/drivers/media/usb/em28xx/em28xx-video.c
+++ b/drivers/media/usb/em28xx/em28xx-video.c
@@ -1396,6 +1396,9 @@ static int em28xx_vb2_setup(struct em28xx *dev)
 	struct vb2_queue *q;
 	struct em28xx_v4l2 *v4l2 = dev->v4l2;
 
+	mutex_init(&v4l2->vb_queue_lock);
+	mutex_init(&v4l2->vb_vbi_queue_lock);
+
 	/* Setup Videobuf2 for Video capture */
 	q = &v4l2->vb_vidq;
 	q->type = V4L2_BUF_TYPE_VIDEO_CAPTURE;
@@ -1405,11 +1408,15 @@ static int em28xx_vb2_setup(struct em28xx *dev)
 	q->buf_struct_size = sizeof(struct em28xx_buffer);
 	q->ops = &em28xx_video_qops;
 	q->mem_ops = &vb2_vmalloc_memops;
+	q->lock = &v4l2->vb_queue_lock;
 
 	rc = vb2_queue_init(q);
 	if (rc < 0)
 		return rc;
 
+	if (!em28xx_vbi_supported(dev))
+		return 0;
+
 	/* Setup Videobuf2 for VBI capture */
 	q = &v4l2->vb_vbiq;
 	q->type = V4L2_BUF_TYPE_VBI_CAPTURE;
@@ -1419,6 +1426,7 @@ static int em28xx_vb2_setup(struct em28xx *dev)
 	q->buf_struct_size = sizeof(struct em28xx_buffer);
 	q->ops = &em28xx_vbi_qops;
 	q->mem_ops = &vb2_vmalloc_memops;
+	q->lock = &v4l2->vb_vbi_queue_lock;
 
 	rc = vb2_queue_init(q);
 	if (rc < 0)
@@ -2429,6 +2437,7 @@ static int em28xx_v4l2_fini(struct em28xx *dev)
 		vb2_video_unregister_device(&v4l2->vdev);
 	}
 
+	dev->v4l2 = NULL;
 	mutex_unlock(&dev->lock);
 
 	/*
@@ -2948,12 +2957,14 @@ static int em28xx_v4l2_init(struct em28xx *dev)
 	if (ret)
 		goto unregister_dev;
 
+	/* initialize videobuf2 stuff */
+	ret = em28xx_vb2_setup(dev);
+	if (ret)
+		goto unregister_dev;
+
 	/* allocate and fill video video_device struct */
 	em28xx_vdev_init(dev, &v4l2->vdev, &em28xx_video_template, "video");
-	mutex_init(&v4l2->vb_queue_lock);
-	mutex_init(&v4l2->vb_vbi_queue_lock);
 	v4l2->vdev.queue = &v4l2->vb_vidq;
-	v4l2->vdev.queue->lock = &v4l2->vb_queue_lock;
 	v4l2->vdev.device_caps = V4L2_CAP_READWRITE | V4L2_CAP_VIDEO_CAPTURE |
 				 V4L2_CAP_STREAMING;
 	if (dev->int_audio_type != EM28XX_INT_AUDIO_NONE)
@@ -2998,7 +3009,6 @@ static int em28xx_v4l2_init(struct em28xx *dev)
 				 "vbi");
 
 		v4l2->vbi_dev.queue = &v4l2->vb_vbiq;
-		v4l2->vbi_dev.queue->lock = &v4l2->vb_vbi_queue_lock;
 		v4l2->vbi_dev.device_caps = V4L2_CAP_STREAMING |
 			V4L2_CAP_READWRITE | V4L2_CAP_VBI_CAPTURE;
 		if ((v4l2->vdev.device_caps & V4L2_CAP_TUNER) == 0)
@@ -3068,9 +3078,6 @@ static int em28xx_v4l2_init(struct em28xx *dev)
 	/* Save some power by putting tuner to sleep */
 	v4l2_device_call_all(&v4l2->v4l2_dev, 0, tuner, standby);
 
-	/* initialize videobuf2 stuff */
-	em28xx_vb2_setup(dev);
-
 	dev_info(&dev->intf->dev,
 		 "V4L2 extension successfully initialized\n");
 
@@ -3097,6 +3104,7 @@ static int em28xx_v4l2_init(struct em28xx *dev)
 		vb2_video_unregister_device(&v4l2->vdev);
 	}
 
+	dev->v4l2 = NULL;
 	mutex_unlock(&dev->lock);
 
 	/*


base-commit: 24a19b953e2a3d0ea5a8c4951a0ab8f32720c907
-- 
This is an AI-generated patch subject to moderation.
Reply with '#syz upstream' to Sign-off the patch as a human author
and send it to the upstream kernel mailing lists.
Reply with '#syz reject' to reject it ('#syz unreject' to undo).

See https://goo.gle/syzbot-ai-patches for information about AI-generated patches.
You can comment on the patch as usual, syzbot will try to address
the comments and send a new version of the patch if necessary.
syzbot engineers can be reached at syzkaller@googlegroups.com.
