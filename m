Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 69AED24B28;
	Fri, 19 Jun 2026 10:10:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781863810; cv=none; b=A/muMzw6AlDUXTTKX9qHRL+nc5Te2bWx4l/NZWw5gEjpnu5VVyfwomQdmEuC67GqNokX/Q8dny83hIf8GRxf9qFzORwkGvsq+h9js0N9NcaRm0sk1RlSmOARxTEVD3azgOguDPwLcdwFzb9munDbmeA0Qu/ZZMUqzmxWqUsJ03E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781863810; c=relaxed/simple;
	bh=DeKb9k+YwMzQYXksmO5K+lCiCXIJ1Pt7EPCRkO2eoRU=;
	h=From:To:Cc:Subject:Message-ID:MIME-Version:Content-Type:Date; b=FqvsHtzcHY8vIirOb/nUpLragiJR58sS2jycljEffFO9V6Qx1BPpFc9uGg2s1ST05JwtuVoaxhH65r9f63lBWafmWl2hBER7rXVXUI1Qf0ro/DNhzCilr85QrFS+HL6lpxPcxP1hhmKxwm+Yc7FKVHPcwdWU3iWD3G+U7kYHiBI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=DwHUMTNd; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="DwHUMTNd"
Received: by smtp.kernel.org (Postfix) with UTF8SMTPSA id C5E421F000E9;
	Fri, 19 Jun 2026 10:10:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1781863808;
	bh=9v+x284HzWTVD22QzUQFTpgH5dNuK+8mSRbq51VCG7g=;
	h=From:To:Cc:Subject:Date;
	b=DwHUMTNdflkPEYm0KJPiUghzlPyC3R2YaWe2GqdX8DaeKoAqoHWLCKGTHtL1uzanv
	 KRawE1a9EO/tzZtyzE2cTYGb3Wfip9KXMPEEfHS3o5zfcLPPSaW21zI/38W8BsiIu4
	 DUQ+dWwdpeIqOyCBvlBLCcHLdwak/2u+9HMPiwXhQt9V/G1ZWUoAvFl0pVPUPB7RWv
	 gXD4s0xfFtTeSQpdOA55fnETbLIRuaJOATvrvQP6wsQXynWG9ypH4BQz00JbPBYeUR
	 ZR4awoWT3tzqZaNsfcYwLuKmexlRe9K2e0mZxRou9ACgJGulqv21if7TrBo8/iRpzU
	 gLT1P6nB6QHsQ==
From: "syzbot" <syzbot@kernel.org>
To: syzkaller-bugs@googlegroups.com, "David Airlie" <airlied@gmail.com>, <dri-devel@lists.freedesktop.org>, "Maarten Lankhorst" <maarten.lankhorst@linux.intel.com>, "Maxime Ripard" <mripard@kernel.org>, "Simona Vetter" <simona@ffwll.ch>, "Thomas Zimmermann" <tzimmermann@suse.de>
Cc: linux-kernel@vger.kernel.org, syzbot@lists.linux.dev
Subject: [PATCH] drm/lease: use kvmalloc for temporary ioctl arrays
Message-ID: <c718300f-9eec-4292-95c9-1b35e1c697e7@mail.kernel.org>
Precedence: bulk
X-Mailing-List: syzbot@lists.linux.dev
List-Id: <syzbot.lists.linux.dev>
List-Subscribe: <mailto:syzbot+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:syzbot+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Date: Fri, 19 Jun 2026 10:10:07 +0000 (UTC)

From: Aleksandr Nogikh <nogikh@google.com>

In drm_mode_create_lease_ioctl(), a user-controlled object_count is used to
allocate memory for object_ids and objects. If a user provides a very large
object_count, the kernel attempts to allocate a contiguous memory chunk
that exceeds the maximum allowed size by the slab allocator
(KMALLOC_MAX_SIZE).

For the objects array, kzalloc_objs() is used, which expands to a standard
kzalloc() call. When the requested size exceeds KMALLOC_MAX_SIZE, the SLUB
allocator passes the request to the page allocator, which triggers a
warning because the required page order is greater than MAX_PAGE_ORDER:

WARNING: mm/page_alloc.c:5197 at __alloc_frozen_pages_noprof+0x2ce/0x380
mm/page_alloc.c:5197
Call Trace:
 <TASK>
 alloc_pages_mpol+0x212/0x380 mm/mempolicy.c:2490
 ___kmalloc_large_node+0x4c/0x120 mm/slub.c:5237
 __kmalloc_large_node_noprof+0x18/0x90 mm/slub.c:5268
 __do_kmalloc_node mm/slub.c:5284 [inline]
 __kmalloc_noprof+0x3e4/0x750 mm/slub.c:5308
 kmalloc_noprof include/linux/slab.h:954 [inline]
 kzalloc_noprof include/linux/slab.h:1188 [inline]
 fill_object_idr drivers/gpu/drm/drm_lease.c:389 [inline]
 drm_mode_create_lease_ioctl+0x533/0x1ab0 drivers/gpu/drm/drm_lease.c:521

The object_ids and objects arrays are temporary buffers used within the
ioctl to store object IDs and pointers during the lease creation process.
Since these arrays are not used for DMA or hardware access, they do not
require physically contiguous memory.

To fix this, replace memdup_array_user() with vmemdup_array_user() and
kzalloc_objs() with kvcalloc(), along with changing their respective
kfree() calls to kvfree(). The kvmalloc family of functions attempts a
kmalloc() first and gracefully falls back to vmalloc() for large
allocations. This prevents the kernel warning and makes the allocations
more robust against memory fragmentation, gracefully returning -ENOMEM if
the system cannot satisfy the request.

Fixes: 62884cd386b8 ("drm: Add four ioctls for managing drm mode object leases [v7]")
Assisted-by: Gemini:gemini-3.1-pro-preview Gemini:gemini-3-flash-preview syzbot
Reported-by: syzbot+03fb58296859d8dbab4d@syzkaller.appspotmail.com
Closes: https://syzkaller.appspot.com/bug?extid=03fb58296859d8dbab4d
Link: https://syzkaller.appspot.com/ai_job?id=22f7a1b3-b0e0-4e5d-abf2-e7119094823a
Signed-off-by: Aleksandr Nogikh <nogikh@google.com>

---
diff --git a/drivers/gpu/drm/drm_lease.c b/drivers/gpu/drm/drm_lease.c
index 5d2cf724c..240e0ea6c 100644
--- a/drivers/gpu/drm/drm_lease.c
+++ b/drivers/gpu/drm/drm_lease.c
@@ -386,7 +386,8 @@ static int fill_object_idr(struct drm_device *dev,
 	int ret;
 	bool universal_planes = READ_ONCE(lessor_priv->universal_planes);
 
-	objects = kzalloc_objs(struct drm_mode_object *, object_count);
+	objects = kvcalloc(object_count, sizeof(struct drm_mode_object *),
+			   GFP_KERNEL);
 	if (!objects)
 		return -ENOMEM;
 
@@ -462,7 +463,7 @@ static int fill_object_idr(struct drm_device *dev,
 		if (objects[o])
 			drm_mode_object_put(objects[o]);
 	}
-	kfree(objects);
+	kvfree(objects);
 	return ret;
 }
 
@@ -509,8 +510,8 @@ int drm_mode_create_lease_ioctl(struct drm_device *dev,
 	/* Handle leased objects, if any */
 	idr_init(&leases);
 	if (object_count != 0) {
-		object_ids = memdup_array_user(u64_to_user_ptr(cl->object_ids),
-					       object_count, sizeof(__u32));
+		object_ids = vmemdup_array_user(u64_to_user_ptr(cl->object_ids),
+						object_count, sizeof(__u32));
 		if (IS_ERR(object_ids)) {
 			ret = PTR_ERR(object_ids);
 			idr_destroy(&leases);
@@ -520,7 +521,7 @@ int drm_mode_create_lease_ioctl(struct drm_device *dev,
 		/* fill and validate the object idr */
 		ret = fill_object_idr(dev, lessor_priv, &leases,
 				      object_count, object_ids);
-		kfree(object_ids);
+		kvfree(object_ids);
 		if (ret) {
 			drm_dbg_lease(dev, "lease object lookup failed: %i\n", ret);
 			idr_destroy(&leases);


base-commit: 8cd9520d35a6c38db6567e97dd93b1f11f185dc6
-- 
See https://goo.gle/syzbot-ai-patches for information about AI-generated patches.
You can comment on the patch as usual, syzbot will try to address
the comments and send a new version of the patch if necessary.
syzbot engineers can be reached at syzkaller@googlegroups.com.
