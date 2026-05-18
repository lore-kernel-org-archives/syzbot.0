Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 52C4E379979
	for <syzbot@lists.linux.dev>; Mon, 18 May 2026 20:25:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779135957; cv=none; b=UbnZyZ67jAH+2i9UrVjnQLI0hnCOzeqb7CFiOnWlF52TepqxDTMHia4+2LE0DroUDqMcpSyNauIffQ1JcDmrIs2JIJ4fXHLXTJOPpKBJpdMQiu/gB09DUw3qhjLkIMcRKCnuDWVpBRJQI1nqHR7NlaVwvto61Zgx1vajGPytH4I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779135957; c=relaxed/simple;
	bh=syFpXqC+2VlTnOtb635bBhFmzGs3X5gZmRpUAVEQcBI=;
	h=From:To:Cc:Subject:Message-ID:MIME-Version:Content-Type:Date; b=ohEEl1gLBRJXPGGU65R4GZ6HTP4Xr5kehlvC7aC0baLxIPNYMxdonMOSQmIX89LQq052RCfw/CyS8ZNPDv+Ir8DtrzlV5qiwhkuLw8zwrhsWXGAtzHvCXsSVZ5IercnBaJS7xi5waDUr6qBxOKiBCimRxOBAqb58JIRjbOJsv5w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Zn9UCZj+; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Zn9UCZj+"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 299C4C2BCB7;
	Mon, 18 May 2026 20:25:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1779135957;
	bh=syFpXqC+2VlTnOtb635bBhFmzGs3X5gZmRpUAVEQcBI=;
	h=From:To:Cc:Subject:Date:From;
	b=Zn9UCZj+ywlTKT2RQDyR59FT5FW7eUK3NCN79s1kTeJqH/Jh5HGJ0irlz0CNxYBgG
	 0tnCKIkJ6JvAVpBju61CuePknLzh7Cs81nXVj0Dm2yk90TXsxKvDrb8zCI+EX53dIj
	 CbB4h7psMnEY5X789vN45ScMz34XsmNzDiOwFaW5FEXeHjiHs4o+Mw0Tzbupv/AZGJ
	 xcbvnEVL4fP57Xe9NbySBw0HnU5eHdTQ41b5+siqvZ13IvKs2RmkCg4cW+2u+VsXK9
	 qYdBu8Jgj1k2r4HEIMHauW4UWP3ll6Fj1FxV/gZlezIQL8SAlCZtB6+w/BVToFpgAA
	 e5d/1VhmhrFhA==
From: "syzbot" <syzbot@kernel.org>
To: syzkaller-upstream-moderation@googlegroups.com
Cc: syzbot@lists.linux.dev
Subject: [PATCH RFC] media: em28xx: fix use-after-free in v4l2_open()
Message-ID: <2c3bed16-1557-4b32-91d1-71a686ac7c6b@mail.kernel.org>
Precedence: bulk
X-Mailing-List: syzbot@lists.linux.dev
List-Id: <syzbot.lists.linux.dev>
List-Subscribe: <mailto:syzbot+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:syzbot+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Date: Mon, 18 May 2026 20:25:57 +0000 (UTC)

The em28xx driver dynamically allocates struct em28xx_v4l2 (which embeds
multiple struct video_device instances) but fails to properly tie its
lifetime to the video_device refcounts. During initialization, if an
error occurs after registering video devices, the error path calls
video_unregister_device() and immediately frees struct em28xx_v4l2.
However, if userspace has already opened the device node, v4l2_open()
might be executing concurrently. It acquires a reference to the
video_device, but since the driver uses video_device_release_empty as
the .release callback, the V4L2 core does not notify the driver when the
last reference is dropped. The driver frees the memory independently,
leading to a KASAN use-after-free when v4l2_open() accesses the freed
video_device.

Fix this by tying the lifetime of struct em28xx_v4l2 to the video_device
refcounts. Add a custom .release callback (em28xx_vdev_release) that
drops the kref reference to struct em28xx_v4l2, and replace
video_device_release_empty with this new callback in the video and radio
templates. Additionally, increment the kref before each
video_register_device() call to account for the reference that will
eventually be dropped by the .release callback, and manually drop the
reference if registration fails, since the V4L2 core does not call the
.release callback on registration failure.

Fixes: d4352f3639d780f1727c26708cb511a3e3702226 ("[media] em28xx: embed video_device")
Assisted-by: Gemini:gemini-3.1-pro-preview Gemini:gemini-3-flash-preview
Reported-by: syzbot+b2391895514ed9ef4a8e@syzkaller.appspotmail.com
Link: https://syzkaller.appspot.com/bug?extid=b2391895514ed9ef4a8e
Link: https://syzkaller.appspot.com/ai_job?id=810055cd-6dee-4575-b8f1-77b005670c45
To: <linux-media@vger.kernel.org>
To: <mchehab@kernel.org>
Cc: <linux-kernel@vger.kernel.org>

---
diff --git a/drivers/media/usb/em28xx/em28xx-video.c b/drivers/media/usb/em28xx/em28xx-video.c
index 4a0ce9c5e..3cf00f12a 100644
--- a/drivers/media/usb/em28xx/em28xx-video.c
+++ b/drivers/media/usb/em28xx/em28xx-video.c
@@ -2549,11 +2549,19 @@ static const struct v4l2_ioctl_ops video_ioctl_ops = {
 #endif
 };
 
+static void em28xx_vdev_release(struct video_device *vdev)
+{
+	struct em28xx_v4l2 *v4l2 =
+		container_of(vdev->v4l2_dev, struct em28xx_v4l2, v4l2_dev);
+
+	kref_put(&v4l2->ref, em28xx_free_v4l2);
+}
+
 static const struct video_device em28xx_video_template = {
-	.fops		= &em28xx_v4l_fops,
-	.ioctl_ops	= &video_ioctl_ops,
-	.release	= video_device_release_empty,
-	.tvnorms	= V4L2_STD_ALL,
+	.fops = &em28xx_v4l_fops,
+	.ioctl_ops = &video_ioctl_ops,
+	.release = em28xx_vdev_release,
+	.tvnorms = V4L2_STD_ALL,
 };
 
 static const struct v4l2_file_operations radio_fops = {
@@ -2579,9 +2587,9 @@ static const struct v4l2_ioctl_ops radio_ioctl_ops = {
 };
 
 static struct video_device em28xx_radio_template = {
-	.fops		= &radio_fops,
-	.ioctl_ops	= &radio_ioctl_ops,
-	.release	= video_device_release_empty,
+	.fops = &radio_fops,
+	.ioctl_ops = &radio_ioctl_ops,
+	.release = em28xx_vdev_release,
 };
 
 /* I2C possible address to saa7115, tvp5150, msp3400, tvaudio */
@@ -2956,11 +2964,13 @@ static int em28xx_v4l2_init(struct em28xx *dev)
 		v4l2_disable_ioctl(&v4l2->vdev, VIDIOC_ENUM_FRAMESIZES);
 
 	/* register v4l2 video video_device */
+	kref_get(&v4l2->ref);
 	ret = video_register_device(&v4l2->vdev, VFL_TYPE_VIDEO,
 				    video_nr[dev->devno]);
 	if (ret) {
 		dev_err(&dev->intf->dev,
 			"unable to register video device (error=%i).\n", ret);
+		kref_put(&v4l2->ref, em28xx_free_v4l2);
 		goto unregister_dev;
 	}
 
@@ -2990,11 +3000,13 @@ static int em28xx_v4l2_init(struct em28xx *dev)
 		}
 
 		/* register v4l2 vbi video_device */
+		kref_get(&v4l2->ref);
 		ret = video_register_device(&v4l2->vbi_dev, VFL_TYPE_VBI,
 					    vbi_nr[dev->devno]);
 		if (ret < 0) {
 			dev_err(&dev->intf->dev,
 				"unable to register vbi device\n");
+			kref_put(&v4l2->ref, em28xx_free_v4l2);
 			goto unregister_dev;
 		}
 	}
@@ -3003,11 +3015,13 @@ static int em28xx_v4l2_init(struct em28xx *dev)
 		em28xx_vdev_init(dev, &v4l2->radio_dev, &em28xx_radio_template,
 				 "radio");
 		v4l2->radio_dev.device_caps = V4L2_CAP_RADIO | V4L2_CAP_TUNER;
+		kref_get(&v4l2->ref);
 		ret = video_register_device(&v4l2->radio_dev, VFL_TYPE_RADIO,
 					    radio_nr[dev->devno]);
 		if (ret < 0) {
 			dev_err(&dev->intf->dev,
 				"can't register radio device\n");
+			kref_put(&v4l2->ref, em28xx_free_v4l2);
 			goto unregister_dev;
 		}
 		dev_info(&dev->intf->dev,


base-commit: 5200f5f493f79f14bbdc349e402a40dfb32f23c8
-- 
This is an AI-generated patch subject to moderation.
Reply with '#syz upstream' to send it to the mailing list.
Reply with '#syz reject' to reject it.

See  for more information.
