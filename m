Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793638407;
	b=xz4aPM+qSojo0XFOy0QODdCPztI5XOQ3tnmzrVwH/7BFlwwQRFK/IuppvkVY2vGim9eO
	 BZwsZBee+k9AkfarH0FrvFH59gG/XcRBMwEZHkq8BDenw/0gCA0M2kQfG3absTGHDJuXl
	 jYcMNDVH3zktmf1uSRxBFARbPNKCnJJv0sDINXb3JyoujK7QiWVJ6hBrgaJonFSdOW6pS
	 jKLPSUJgqBDwOIOKc6sGxxwSsi+w17Jwi0upQATa6T7fwQhMfrJxi46EzEGrvNr7JkZjz
	 a4mbmy+ptWN1fYejbdPp44WXLj+vKnzokrtEGmTDIi7THX58I4MOjvZAQQVgYeOWk4w==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793638407;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Message-ID:MIME-Version:
	 Content-Type:Content-Transfer-Encoding:Date;
	bh=QwFuzIOOajP+VUB/0//X5m/ehVoPWeH6NhblDzcNzMI=;
	b=mkue8FaqjFhVGcuhLUf/7E0d3xfC0VtguAzuXj35EC57kelRYMiNVpJm9yJgKEf4CVWa
	 tccvyq+CBdfkiiOJsZezvFhXStMcgtNUBtaw6DAKtNANE1lRvfCjoNEOrMGdv6kiJGKX9
	 DYV23e4TS6sCp9Eepfbm7MGvn8djUzuEk7J27SAIlV8uI2mA8fAJDqWnUsrhM+Zi40tF4
	 ScIQ9jCdPYKOBPgxgweJ/SEPYBAo0cplSTqhmf31pxSCgS/mEwBqelOY3Q/LOwkj99IZs
	 oZLdjB+/yNGHv/8OsDHAthhhaRSKmExIqDzwr4Ktn7cIOdMGMWQxHnz4Ie/WSPtFr2g==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=oLwn4xRv;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with UTF8SMTPS id C1A946079046
	for <syzbot@lists.linux.dev>; Mon,  2 Nov 2026 16:53:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=oLwn4xRv
Received: by smtp.kernel.org (Postfix) with UTF8SMTPSA id 3DADD1F00A16;
	Mon,  2 Nov 2026 16:53:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793638406;
	bh=QwFuzIOOajP+VUB/0//X5m/ehVoPWeH6NhblDzcNzMI=;
	h=From:To:Cc:Subject:Date;
	b=oLwn4xRvDrLEFPi7U1mCZD4CfqF/H+Ea8b0eun+Hu20tvMpYdmpOXA+4ZkYd75QvB
	 50zLWujspIvlPEvJaofDcDejYmiCrIayWNtH+HcJ/uzm45f9MbHi3pqLdA6EmarkhF
	 AK+6WAQ0/sr2nXPJL1AwR7Gbe2BcTjPiVuAw5jcO6+3D3AibS9IzqsxUle2L66dQdv
	 EQv1Ux2by6/9RyDEP50gjMftgAyMEJyHt644ASDztuqMhaFu+7/JU4Sw3474hnAbfT
	 lbQ/DTywRTQIPnFXFg43pi27Vq8s0MPf2eSFTgBPy0p8WoRNjpKDD9wXaUJ4cWFhjt
	 RDy9M6Ik1khaw==
From: "syzbot" <syzbot@kernel.org>
To: syzkaller-upstream-moderation@googlegroups.com
Cc: syzbot@lists.linux.dev, uladzislau.zhauniarovich@gmail.com
Subject: [PATCH RFC v2] media: em28xx: clear dev->v4l2 when v4l2 init fails
Message-ID: <46d5ee1f-d8ae-4555-9edd-6afa90861d4e@mail.kernel.org>
X-Mailing-List: syzbot@lists.linux.dev
List-Id: <syzbot.lists.linux.dev>
List-Post: <mailto:syzbot@lists.linux.dev>
List-Help: <mailto:syzbot+help@lists.linux.dev>
List-Subscribe: <mailto:syzbot+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:syzbot+unsubscribe@lists.linux.dev>
List-Owner: <mailto:syzbot+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Date: Mon,  2 Nov 2026 16:53:26 +0000 (UTC)

In em28xx_v4l2_init(), if an error occurs after video_register_device()
succeeds, the cleanup path at unregister_dev unregisters the devices and
puts the v4l2_dev reference, but leaves dev->v4l2 set. Because dev->v4l2
remains non-NULL, subsequent calls to v4l2_open() (such as from v4l_id when
opening the device node) succeed instead of returning -ENODEV. When the
device is later disconnected, em28xx_close_extension() invokes
em28xx_v4l2_fini(), which sees dev->v4l2 is still set and calls
v4l2_device_put() a second time. This prematurely drops the reference count
to zero while v4l_id still holds the device, leading to a
slab-use-after-free:

BUG: KASAN: slab-use-after-free in v4l2_release+0xcd/0xe0
Read of size 8 at addr ffff888114efc000 by task v4l_id/1234
CPU: 1 UID: 0 PID: 1234 Comm: v4l_id Not tainted 6.14.0-rc1 #1
Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS
1.16.3-debian-1.16.3-2 04/01/2014
Call Trace:
 <TASK>
 dump_stack_lvl+0x68/0x90
 print_report+0xd3/0x620
 kasan_report+0xb9/0xf0
 v4l2_release+0xcd/0xe0
 __fput+0x3f6/0xb30
 task_work_run+0x14d/0x240
 do_exit+0xa38/0x2c00
 do_group_exit+0xd4/0x2a0
 __x64_sys_exit_group+0x3e/0x50
 do_syscall_64+0xcb/0x250
 entry_SYSCALL_64_after_hwframe+0x77/0x7f
 </TASK>

Allocated by task 6297:
 kasan_save_stack+0x33/0x60
 kasan_save_track+0x14/0x30
 __kasan_kmalloc+0xaa/0xb0
 em28xx_v4l2_init+0x9e/0x2df0 drivers/media/usb/em28xx/em28xx-video.c:2860
 em28xx_init_extension+0x120/0x1d0
 drivers/media/usb/em28xx/em28xx-core.c:1248
 process_scheduled_works+0xc3d/0x1630 kernel/workqueue.c:3479
 worker_thread+0x92d/0xe10 kernel/workqueue.c:3560
 kthread+0x38b/0x480 kernel/kthread.c:436
 ret_from_fork+0x514/0xb70 arch/x86/kernel/process.c:158
 ret_from_fork_asm+0x1a/0x30 arch/x86/entry/entry_64.S:245

Freed by task 6297:
 kasan_save_stack+0x33/0x60
 kasan_save_track+0x14/0x30
 kasan_save_free_info+0x2b/0x50
 __kasan_slab_free+0x106/0x1a0
 kfree+0xd4/0x340
 v4l2_device_put+0xbc/0xf0 drivers/media/v4l2-core/v4l2-dev.c:1052
 em28xx_v4l2_fini+0x120/0x180 drivers/media/usb/em28xx/em28xx-video.c:2445
 em28xx_close_extension+0x120/0x1d0
 drivers/media/usb/em28xx/em28xx-core.c:1270
 em28xx_usb_disconnect+0x10a/0x230
 drivers/media/usb/em28xx/em28xx-cards.c:4254
 usb_unbind_interface+0x1eb/0x8e0 drivers/usb/core/driver.c:461
 device_release_driver_internal+0x43b/0x610 drivers/base/dd.c:1297
 bus_remove_device+0x2cc/0x3e0 drivers/base/bus.c:575
 device_del+0x49f/0x910 drivers/base/core.c:3851
 usb_disable_device+0x35b/0x7b0 drivers/usb/core/message.c:1418
 usb_disconnect+0x2c6/0x8d0 drivers/usb/core/hub.c:2303

Fix this by clearing dev->v4l2 under dev->lock in the unregister_dev error
path of em28xx_v4l2_init(). This ensures em28xx_v4l2_open() fails with
-ENODEV and prevents em28xx_v4l2_fini() from tearing down the instance a
second time upon disconnect.

In addition, move em28xx_vb2_setup() before video_register_device() and
check its return value so that videobuf2 queues are initialized prior to
device registration and can be safely cleaned up if an error occurs. In
em28xx_vb2_setup(), initialize vb_queue_lock and vb_vbi_queue_lock and
assign q->lock before calling vb2_queue_init(), and make VBI queue
initialization conditional on em28xx_vbi_supported().

Cc: stable@vger.kernel.org

Fixes: 288254383674 ("media: em28xx: use v4l2_device release callback")
Assisted-by: Gemini:gemini-4-argon Gemini:gemini-3.8-flash syzbot
Reported-by: syzbot+1a7507a194fff09e5c44@syzkaller.appspotmail.com
Closes: https://syzkaller.appspot.com/bug?extid=1a7507a194fff09e5c44
Link: https://syzkaller.appspot.com/ai_job?id=4d612d4a-3dfa-43bd-9919-40019986527f
To: <linux-media@vger.kernel.org>
To: "Mauro Carvalho Chehab" <mchehab@kernel.org>
To: "Hans Verkuil" <hverkuil+cisco@kernel.org>
Cc: <linux-kernel@vger.kernel.org>

---
v2:
- Update patch subject to reflect clearing dev->v4l2 on init failure
- Rewrite commit description to explain the slab-use-after-free and replace the lockdep/GPF report with the KASAN report
- Drop setting dev->v4l2 to NULL in em28xx_v4l2_fini()
- Add comment explaining why dev->v4l2 is cleared in em28xx_v4l2_init()
- Add Cc: stable@vger.kernel.org tag

v1:
https://lore.kernel.org/all/2fdb5af1-fad9-47fe-93dc-d1400f44b60b@mail.kernel.org/T/
---
diff --git a/drivers/media/usb/em28xx/em28xx-video.c b/drivers/media/usb/em28xx/em28xx-video.c
index 79af15476..a48815840 100644
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
@@ -2948,12 +2956,14 @@ static int em28xx_v4l2_init(struct em28xx *dev)
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
@@ -2998,7 +3008,6 @@ static int em28xx_v4l2_init(struct em28xx *dev)
 				 "vbi");
 
 		v4l2->vbi_dev.queue = &v4l2->vb_vbiq;
-		v4l2->vbi_dev.queue->lock = &v4l2->vb_vbi_queue_lock;
 		v4l2->vbi_dev.device_caps = V4L2_CAP_STREAMING |
 			V4L2_CAP_READWRITE | V4L2_CAP_VBI_CAPTURE;
 		if ((v4l2->vdev.device_caps & V4L2_CAP_TUNER) == 0)
@@ -3068,9 +3077,6 @@ static int em28xx_v4l2_init(struct em28xx *dev)
 	/* Save some power by putting tuner to sleep */
 	v4l2_device_call_all(&v4l2->v4l2_dev, 0, tuner, standby);
 
-	/* initialize videobuf2 stuff */
-	em28xx_vb2_setup(dev);
-
 	dev_info(&dev->intf->dev,
 		 "V4L2 extension successfully initialized\n");
 
@@ -3097,6 +3103,12 @@ static int em28xx_v4l2_init(struct em28xx *dev)
 		vb2_video_unregister_device(&v4l2->vdev);
 	}
 
+	/*
+	 * Clear dev->v4l2 to prevent em28xx_v4l2_open() from opening an
+	 * unregistered node (failing with -ENODEV instead) and to prevent
+	 * em28xx_v4l2_fini() from tearing down the instance a second time.
+	 */
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
