Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D6AAF38D414
	for <syzbot@lists.linux.dev>; Fri, 22 May 2026 07:29:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779435001; cv=none; b=nYeoDguwchbJWW/hJCy97CkBQAXVOWxZhPBDX1nhKNYboX6nQYu4iTTLoDg/A9lYssuK/VhBH/oIDeHZ+UlRlswMAge895HBBBCoSjkTqJkhB8AjoQOtiHM8Fq6h0d4CBPNiZWeH42YIh/E3lpEphltms3nfvT95+S+TzR1S+q0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779435001; c=relaxed/simple;
	bh=LhK6thYbjpRVCoMfS9+73pA2OEZrMDEepfjmd/awoiQ=;
	h=From:To:Cc:Subject:Message-ID:MIME-Version:Content-Type:Date; b=IveDkZdNigq7EYQn9xgLXYm/xV6yatpDZdnBEp4G4Cq5RFX/NOddeh5XuKzuIy5paXR9jYSyDxtW5pC5Ps4sDR64RtWmpi9EU3J9uoKiywHhCIuzEIL7RWZsJ3hAxysKCXPVj9dyGjJ6P4x9esV6VEevgHJwqtTu5Uu75y0VjVM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=kuK2bEuW; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="kuK2bEuW"
Received: by smtp.kernel.org (Postfix) with UTF8SMTPSA id 776361F00A3D;
	Fri, 22 May 2026 07:29:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1779434999;
	bh=S/z3WlUAwC+Ob0qTIQuw4rSJp0sJPnYTA+F2bE50Vb4=;
	h=From:To:Cc:Subject:Date;
	b=kuK2bEuWci6OZ+Slcpzg6fnxpxsjufp52yNUyXfXf/8scJn/JeqzmjDXbihID+W3S
	 1LNgvKCSET0VaKefzei9dn1lZNSPlh3qi9pJv8slpLRMj9/t2vRaGUBegf36QPDEgT
	 MiEMLo9NcybWAHPYGt3tQ2WURvz84lN/OSf6y9Wp5z3d9pV3X6SAb6OfBxliqE46K1
	 QS38xHGatGq2dpH2vpX4WiKqaVy0amARuGk78V6UGFx1beka1y9+r70mbxy2rkatcW
	 NKfVytPYB4H378wy4o/UIp3Q9yzHxov3S6qMZz5x6BvIXHtSYD9K3S1axOdjtyhazq
	 zy1NKYiKZ7Q5w==
From: "syzbot" <syzbot@kernel.org>
To: syzkaller-upstream-moderation@googlegroups.com
Cc: syzbot@lists.linux.dev
Subject: [PATCH RFC] media: as102: fix uninitialized mutex and memory leak in probe
Message-ID: <5b50e134-2304-45db-9a63-aeb6c38f27e6@mail.kernel.org>
Precedence: bulk
X-Mailing-List: syzbot@lists.linux.dev
List-Id: <syzbot.lists.linux.dev>
List-Subscribe: <mailto:syzbot+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:syzbot+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Date: Fri, 22 May 2026 07:29:59 +0000 (UTC)

During the initialization of the as102 driver, it registers its DVB
demux and frontend device nodes and exposes them to userspace before
initializing the mutexes (`as102_dev->sem` and
`as102_dev->bus_adap.lock`) that are meant to protect them. If userspace
quickly opens the device and issues an ioctl, the kernel attempts to
lock an uninitialized mutex, triggering a warning.

To fix this race condition, move the mutex initialization to the very
beginning of `as102_dvb_register()` to ensure the locks are ready before
userspace can access the device.

Additionally, fix a memory leak in the error handling path of
`as102_usb_probe()`. If `as102_alloc_usb_stream_buffer()` or
`as102_dvb_register()` fail, the driver jumps to the `failed_stream`
label, which deregisters the USB device but does not free the allocated
`as102_dev` structure or drop the `usb_dev` reference. Add a
`kref_put(&as102_dev->kref, as102_usb_release)` call to the
`failed_stream` error path to ensure the device structure is properly
freed and the USB device reference is released.

Fixes: 41b44e041811 ("[media] staging: as102: Initial import from Abilis")
Assisted-by: Gemini:gemini-3.1-pro-preview syzbot
Reported-by: syzbot+3825a6102073c418fe41@syzkaller.appspotmail.com
Closes: https://syzkaller.appspot.com/bug?extid=3825a6102073c418fe41
Link: https://syzkaller.appspot.com/ai_job?id=5b12fff8-5443-4a77-9f17-ace968bd4f15
To: <linux-media@vger.kernel.org>
To: "Mauro Carvalho Chehab" <mchehab@kernel.org>
Cc: "Jeongjun Park" <aha310510@gmail.com>
Cc: "Hans Verkuil" <hverkuil+cisco@kernel.org>
Cc: "Kees Cook" <kees@kernel.org>
Cc: <linux-kernel@vger.kernel.org>

---
diff --git a/drivers/media/usb/as102/as102_drv.c b/drivers/media/usb/as102/as102_drv.c
index 6b1d3528a..a6dd67568 100644
--- a/drivers/media/usb/as102/as102_drv.c
+++ b/drivers/media/usb/as102/as102_drv.c
@@ -287,6 +287,12 @@ int as102_dvb_register(struct as102_dev_t *as102_dev)
 	struct device *dev = &as102_dev->bus_adap.usb_dev->dev;
 	int ret;
 
+	/* init bus mutex for token locking */
+	mutex_init(&as102_dev->bus_adap.lock);
+
+	/* init start / stop stream mutex */
+	mutex_init(&as102_dev->sem);
+
 	ret = dvb_register_adapter(&as102_dev->dvb_adap,
 			   as102_dev->name, THIS_MODULE,
 			   dev, adapter_nr);
@@ -341,12 +347,6 @@ int as102_dvb_register(struct as102_dev_t *as102_dev)
 		goto efereg;
 	}
 
-	/* init bus mutex for token locking */
-	mutex_init(&as102_dev->bus_adap.lock);
-
-	/* init start / stop stream mutex */
-	mutex_init(&as102_dev->sem);
-
 	/*
 	 * try to load as102 firmware. If firmware upload failed, we'll be
 	 * able to upload it later.
diff --git a/drivers/media/usb/as102/as102_usb_drv.c b/drivers/media/usb/as102/as102_usb_drv.c
index a11024451..ad6c5837f 100644
--- a/drivers/media/usb/as102/as102_usb_drv.c
+++ b/drivers/media/usb/as102/as102_usb_drv.c
@@ -405,6 +405,7 @@ static int as102_usb_probe(struct usb_interface *intf,
 failed_stream:
 	usb_set_intfdata(intf, NULL);
 	usb_deregister_dev(intf, &as102_usb_class_driver);
+	kref_put(&as102_dev->kref, as102_usb_release);
 	return ret;
 failed:
 	usb_put_dev(as102_dev->bus_adap.usb_dev);


base-commit: 5200f5f493f79f14bbdc349e402a40dfb32f23c8
-- 
This is an AI-generated patch subject to moderation.
Reply with '#syz upstream' to Sign-off the patch as a human author
and send it to the upstream kernel mailing lists.
Reply with '#syz reject' to reject it ('#syz unreject' to undo).

See https://github.com/google/syzkaller/blob/master/docs/syzbot_ai_patches.md for information about AI-generated patches.
You can comment on the patch as usual, syzbot will try to address
the comments and send a new version of the patch if necessary.
syzbot engineers can be reached at syzkaller@googlegroups.com.
