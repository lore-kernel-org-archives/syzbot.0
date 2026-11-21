Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795247458;
	b=qGu6FuGa8iMzEFtMyn+Cba41P1I8P9Ik9CsxQX1B1X6F4HTh1z/JhoqzLH6gpc+mbySS
	 51C6NR48dYoLXX2i87MKUTs8GyX0+qt4DJRRxxpKvisDOluOghQDevMauRV60Xu6EmU9/
	 ln2x9pVssG6/UW8P80wDL7ZHUZd03JK6r7O4B8XjI5Bj624QtY49tEvM09/tEZ9VGDJpG
	 ifzWL7/ezdUyWg8jTF+n3pSyF3pS4ka8ulrsTPK2nohqSUpJXv47pJFGoLexbWzsPcnLn
	 zjwfH3ah/yXYi5UmCZJMhNUFEE9lJC66VSLt7WJVRbcwjNX6YJZ+ZAABdFNfU70CBZA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795247458;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Message-ID:MIME-Version:
	 Content-Type:Content-Transfer-Encoding:Date;
	bh=ZcMcVV87rd6B5bOmQcHD3jmmS80LZEHEbzCXS1Ntx38=;
	b=asRRvdAI6p6qb69Jn1yA9V96bEkM1iX7H2pokNXAvJHwuO1sdf+Byv1tFt52RkpmGLhZ
	 0K0b+I5/nVli/p/lirv0zWgWkic3JUOA1E0/V9a9Rbgis9Z7YfSlyWmEDuTSx2XaWuU6B
	 VfaRMNN8bAQeucfuH6e+1umOR7k7brm1ndRdh7ZxYhnQcLqbOy9VnCU22PNqulO/qBXru
	 kdrGYAHYn5FMIGt60xUOvX+2NS/iQxDZOzhCNWg6TWI79XxVxd+F3h0ew+/1V/V6ymOjO
	 ftsBeBx70ldB6KqnuD0CWJizrZ+2zHmrMtV1TKaY+bPpagp1IHWyN9FCKW9/Q/S7bHA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b="gGseb/vC";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with UTF8SMTPS id B55EF606A325
	for <syzbot@lists.linux.dev>; Sat, 21 Nov 2026 07:50:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=gGseb/vC
Received: by smtp.kernel.org (Postfix) with UTF8SMTPSA id 3607D1F000C0;
	Sat, 21 Nov 2026 07:50:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795247458;
	bh=ZcMcVV87rd6B5bOmQcHD3jmmS80LZEHEbzCXS1Ntx38=;
	h=From:To:Cc:Subject:Date;
	b=gGseb/vCq4MQeNBwP3ncpokC3X5ORJn7HVLyHxSEZKv9zCoWW8QjpMNrPMIl+paBw
	 Z1CJrSi+Nh/D3p3kUHXcGyMJxOop7nQf7BMtKpogmICtx5AbntyhzOK6rZCPFOMWNm
	 fVf9fypSs7L7FY/WWY2apcn+2mL81ndpE/vv6MwLj4aCspKRXRpjVlTnB0WuvIp2Lp
	 l9D169EccFfOpfmNIPU4TwGBDxWkeKIZWWgLSmfNqnTMdXsVuDRAXY+e8wY5F4tL8u
	 /b4OLFf88SK7hmomlMFQgX3DhGgtQwPcCgPnXHV6+0jP+WppCgVm31JE0ejKKJ15OX
	 AYMA8XrQFBLWg==
From: "syzbot" <syzbot@kernel.org>
To: syzkaller-upstream-moderation@googlegroups.com
Cc: syzbot@lists.linux.dev, uladzislau.zhauniarovich@gmail.com
Subject: [PATCH RFC v3] media: em28xx: clear dev->v4l2 when v4l2 init fails
Message-ID: <453e21d0-d552-498a-83f9-4da71f807096@mail.kernel.org>
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
Date: Sat, 21 Nov 2026 07:50:58 +0000 (UTC)

In em28xx_v4l2_init(), if an error occurs after video_register_device()
succeeds, the cleanup path at unregister_dev unregisters the devices and
puts the v4l2_dev reference, but leaves dev->v4l2 set. While new opens
after node unregistration already fail in v4l2_open(), an open already in
progress (such as v4l_id inside em28xx_v4l2_open(), blocked on dev->lock
while em28xx_v4l2_init() holds it) sees dev->v4l2 still set after init
fails and releases dev->lock, succeeding on the unregistered node. When the
device is later disconnected, em28xx_close_extension() invokes
em28xx_v4l2_fini(), which sees dev->v4l2 is still set and calls
v4l2_device_put() a second time. This prematurely drops the reference count
to zero while v4l_id still holds the device, leading to a
slab-use-after-free in v4l2_open().

Fix this by clearing dev->v4l2 under dev->lock in the unregister_dev error
path of em28xx_v4l2_init(). This ensures em28xx_v4l2_open() fails with
-ENODEV and prevents em28xx_v4l2_fini() from tearing down the instance a
second time upon disconnect.

Cc: stable@vger.kernel.org

Fixes: 288254383674 ("media: em28xx: use v4l2_device release callback")
Assisted-by: Gemini:gemini-4-hydrogen Gemini:gemini-4-carbon Gemini:gemini-3.8-flash syzbot
Reported-by: syzbot+1a7507a194fff09e5c44@syzkaller.appspotmail.com
Closes: https://syzkaller.appspot.com/bug?extid=1a7507a194fff09e5c44
Link: https://syzkaller.appspot.com/ai_job?id=3d27fc97-4d17-42f0-a8c9-6f94ce0335b2
To: <linux-media@vger.kernel.org>
To: "Mauro Carvalho Chehab" <mchehab@kernel.org>
To: "Hans Verkuil" <hverkuil+cisco@kernel.org>
Cc: <linux-kernel@vger.kernel.org>

---
v3:
- Moved em28xx_vb2_setup() to just before video_register_device() with a dev_err() message on failure, keeping queue mutex initialization and q->lock assignment in em28xx_v4l2_init().
- Reworded the commit description to clarify that the race affects an open already in progress in em28xx_v4l2_open(), removed the synthesized KASAN report, and dropped the em28xx_vb2_setup() paragraph.

v2:
- Update patch subject to reflect clearing dev->v4l2 on init failure
- Rewrite commit description to explain the slab-use-after-free and replace the lockdep/GPF report with the KASAN report
- Drop setting dev->v4l2 to NULL in em28xx_v4l2_fini()
- Add comment explaining why dev->v4l2 is cleared in em28xx_v4l2_init()
- Add Cc: stable@vger.kernel.org tag
https://lore.kernel.org/all/46d5ee1f-d8ae-4555-9edd-6afa90861d4e@mail.kernel.org/T/

v1:
https://lore.kernel.org/all/2fdb5af1-fad9-47fe-93dc-d1400f44b60b@mail.kernel.org/T/
---
diff --git a/drivers/media/usb/em28xx/em28xx-video.c b/drivers/media/usb/em28xx/em28xx-video.c
index 79af15476..200826a01 100644
--- a/drivers/media/usb/em28xx/em28xx-video.c
+++ b/drivers/media/usb/em28xx/em28xx-video.c
@@ -1410,6 +1410,9 @@ static int em28xx_vb2_setup(struct em28xx *dev)
 	if (rc < 0)
 		return rc;
 
+	if (!em28xx_vbi_supported(dev))
+		return 0;
+
 	/* Setup Videobuf2 for VBI capture */
 	q = &v4l2->vb_vbiq;
 	q->type = V4L2_BUF_TYPE_VBI_CAPTURE;
@@ -2983,6 +2986,14 @@ static int em28xx_v4l2_init(struct em28xx *dev)
 	if (dev->chip_id == CHIP_ID_EM2828X || dev->board.decoder == EM28XX_BUILTIN)
 		v4l2_disable_ioctl(&v4l2->vdev, VIDIOC_ENUM_FRAMESIZES);
 
+	/* initialize videobuf2 stuff */
+	ret = em28xx_vb2_setup(dev);
+	if (ret) {
+		dev_err(&dev->intf->dev,
+			"unable to setup videobuf queues (error=%i).\n", ret);
+		goto unregister_dev;
+	}
+
 	/* register v4l2 video video_device */
 	ret = video_register_device(&v4l2->vdev, VFL_TYPE_VIDEO,
 				    video_nr[dev->devno]);
@@ -3068,9 +3079,6 @@ static int em28xx_v4l2_init(struct em28xx *dev)
 	/* Save some power by putting tuner to sleep */
 	v4l2_device_call_all(&v4l2->v4l2_dev, 0, tuner, standby);
 
-	/* initialize videobuf2 stuff */
-	em28xx_vb2_setup(dev);
-
 	dev_info(&dev->intf->dev,
 		 "V4L2 extension successfully initialized\n");
 
@@ -3097,6 +3105,12 @@ static int em28xx_v4l2_init(struct em28xx *dev)
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
