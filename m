Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9ADF73CD8AC
	for <syzbot@lists.linux.dev>; Mon, 15 Jun 2026 16:39:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781541589; cv=none; b=EXOzWazBqvJnCUb9vWr0VcMdglWX5SKkQ+UjxteJS62D0xXhAJkoEu9lvdKP5RJJw9dbF0F8F/1+ECLbK3EZp4muloq78wNKf8+jWhf8AGxqhPFS9ysgOwY5dMAe/K7FeeY7Cv/Qkuk31v/OxuS/FUJyTW+Ar9XVzUE8CFORIHk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781541589; c=relaxed/simple;
	bh=CR6hal2iD4vf/Ttiy2FuOT0DCkaM2XbbjFUl7FWbOpM=;
	h=From:To:Cc:Subject:Message-ID:MIME-Version:Content-Type:Date; b=FxImPnWMWJwKZQN1t3cB8oh7O3hbDGXRjnzBpUd/GkHvDhDoRXIPVXek+kedEGbkBtwDi7T/e8krLcG4zivTLRNn7+C01zIu0e6J5jVXMW+f1TuxEpo2rNVsXPojR4RTgMlNmY9/QpiKR0vPxOD3bXIKOkD4aBaBXegh5nQ1RNI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Uz3sAhW7; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Uz3sAhW7"
Received: by smtp.kernel.org (Postfix) with UTF8SMTPSA id 626D01F000E9;
	Mon, 15 Jun 2026 16:39:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1781541588;
	bh=4y9jMZvObHm3KCzOxc0PgkYVDcUXx4tPpfk9AR0GbuE=;
	h=From:To:Cc:Subject:Date;
	b=Uz3sAhW717xgQ9xZ6x7Zk9oHtkxHGb97KJ9yJSnGSC8qd6artzal62an5Tg3QQEFz
	 zW9SYUxQp6qjySjfGoBUkeSdnnMZmrdKYZeTmgAmbUs9flJfJ+TGP0nOEL4fVDyO4s
	 rSQy/ImJ/A+IYuet6aAMzq4jcucbeKeK1BIrsH82Q70R9dUMzzdbVFmhyMvFqriv6b
	 mwc70rUxuLnVckh95ytKCVKRCdNHtN4+TBkj/oN7xwvQRtClZu3rVU5z+HplKGO+W/
	 xeSJ+igOXVlAKNntOFVnp3nZXC1usXTqdFIC4GVbkom2xFGTHHZ2eQrpqldpJ1H9XX
	 ZXuQ7ecv21zUg==
From: "syzbot" <syzbot@kernel.org>
To: syzkaller-upstream-moderation@googlegroups.com
Cc: syzbot@lists.linux.dev
Subject: [PATCH RFC] drm/lease: use kvmalloc for user-controlled allocations
Message-ID: <46506931-ba8f-4048-ab27-9777411db2fe@mail.kernel.org>
Precedence: bulk
X-Mailing-List: syzbot@lists.linux.dev
List-Id: <syzbot.lists.linux.dev>
List-Subscribe: <mailto:syzbot+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:syzbot+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Date: Mon, 15 Jun 2026 16:39:48 +0000 (UTC)

In drm_mode_create_lease_ioctl(), a user-controlled object_count is used to
allocate memory for object_ids and objects. If a user provides a very large
object_count (e.g., 1,000,000), the kernel attempts to allocate a
contiguous memory chunk that exceeds the maximum allowed size by the slab
allocator (KMALLOC_MAX_SIZE).

For the objects array, kzalloc_objs() is used, which expands to a standard
kzalloc() call without the __GFP_NOWARN flag. When the requested size
exceeds KMALLOC_MAX_SIZE, the SLUB allocator passes the request to the page
allocator, which triggers a WARN_ON_ONCE_GFP because the required page
order is greater than MAX_PAGE_ORDER:

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

To fix this, replace memdup_array_user() with vmemdup_array_user() and
kzalloc_objs() with kvcalloc(), along with changing their respective
kfree() calls to kvfree(). The kvmalloc family of functions attempts a
kmalloc() first with __GFP_NOWARN applied internally, and gracefully falls
back to vmalloc() for large allocations. This prevents the kernel warning
and makes the allocations more robust against memory fragmentation,
gracefully returning -ENOMEM if the system cannot satisfy the request.

Fixes: 62884cd386b8 ("drm: Add four ioctls for managing drm mode object leases [v7]")
Assisted-by: Gemini:gemini-3.1-pro-preview syzbot
Reported-by: syzbot+03fb58296859d8dbab4d@syzkaller.appspotmail.com
Closes: https://syzkaller.appspot.com/bug?extid=03fb58296859d8dbab4d
Link: https://syzkaller.appspot.com/ai_job?id=73f2715e-0f0e-4924-ad92-d4ef4f06a14f
To: "David Airlie" <airlied@gmail.com>
To: <dri-devel@lists.freedesktop.org>
To: "Maarten Lankhorst" <maarten.lankhorst@linux.intel.com>
To: "Maxime Ripard" <mripard@kernel.org>
To: "Simona Vetter" <simona@ffwll.ch>
To: "Thomas Zimmermann" <tzimmermann@suse.de>
Cc: <linux-kernel@vger.kernel.org>

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
This is an AI-generated patch subject to moderation.
Reply with '#syz upstream' to Sign-off the patch as a human author
and send it to the upstream kernel mailing lists.
Reply with '#syz reject' to reject it ('#syz unreject' to undo).

See https://goo.gle/syzbot-ai-patches for information about AI-generated patches.
You can comment on the patch as usual, syzbot will try to address
the comments and send a new version of the patch if necessary.
syzbot engineers can be reached at syzkaller@googlegroups.com.
