Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BF65C21A453
	for <syzbot@lists.linux.dev>; Wed, 14 Oct 2026 00:40:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791938402; cv=none; b=CsKfKozL2ymw9pDqzMKCaoYr/ANXL7kUifZjciE0h4FeGfNZEr8Lg4vk6q1MuDuOJ3isxoRF0b2I/D+6+D6aN52TR27ajlq2IxJjT4qT6zRBvB/kwrhdllbh99dYhm9S3URXf5KvnObbi146RUwumMQ3CH72q4NAxKHYgPTs0PA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791938402; c=relaxed/simple;
	bh=rjTBJ5PePNukycFOw9CzSjBFN0zwuE3bH45hHureH4g=;
	h=From:To:Cc:Subject:Message-ID:MIME-Version:Content-Type:Date; b=Da/bAX61xUPmqwkcg/34dZaO8IVpCVqLCL97EkF5+oc00u7TqNBz0J64sBfzb01H1NuC/2WDUVeoe8ytpXH+F5h/vp43Skxm4KNF4KnI+djN8gvxrMHY2chZpbVr0DiLumrxqOH3BxCwX1AjEIySJOgNOcuCkOw2sKBN9ZQ4t98=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=OOoR9HCc; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="OOoR9HCc"
Received: by smtp.kernel.org (Postfix) with UTF8SMTPSA id 3D5EF1F000FF;
	Wed, 14 Oct 2026 00:40:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1791938400;
	bh=MOFB7/9lWv/yO+9+tye3gse33g9vf1waF5sTKfR7PVM=;
	h=From:To:Cc:Subject:Date;
	b=OOoR9HCc7/wsy7orTu+AtRCI1+4KJkAiHesd7257JeWCxBBNMOcfb0QkyTKx7HIfO
	 FfKjOM8k0jbNxL4THlID96wykE1OPkEj/rJoKms5uupjvKZDgCnz4IrGyoIrHmAVPo
	 8sqePHZjEGDt5MoZvA5Vf6CXCcYz9LRjMOGYGJ28c4Q/ffXGiZFGbbLFYJK5B0KBuS
	 IXTgE2zqWW+KZUOM8IAHrTqE8eRM+qvtFgqaQSa67+kb4wl0L3ABhPUhDQcsBxEF8/
	 OZ4IaBpPmewT+PcdP8cTQa721KlT73YcLPUwOYPyKJ6mdFrAphDZkrjnuEOBPKdOOs
	 0XGg5vJdbEVeQ==
From: "syzbot" <syzbot@kernel.org>
To: syzkaller-upstream-moderation@googlegroups.com
Cc: syzbot@lists.linux.dev
Subject: [PATCH RFC] drm/lease: Use kvmalloc and bound object_count in create lease ioctl
Message-ID: <4c497e30-fff3-4ef0-81f9-b9b47ca9e22f@mail.kernel.org>
Precedence: bulk
X-Mailing-List: syzbot@lists.linux.dev
List-Id: <syzbot.lists.linux.dev>
List-Subscribe: <mailto:syzbot+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:syzbot+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Date: Wed, 14 Oct 2026 00:40:00 +0000 (UTC)

In drm_mode_create_lease_ioctl(), user space supplies an object_count and
an array of object_ids to be leased. The kernel copies the IDs from user
space using memdup_array_user(), and then fill_object_idr() allocates a
temporary array of pointers using kzalloc_objs(struct drm_mode_object *,
object_count).

Because kzalloc_objs() performs a kmalloc-family allocation with GFP_KERNEL
(which lacks __GFP_NOWARN), if user space requests a sufficiently large
object_count (for example, 1,000,000 mode objects), the allocation for the
pointer array (1,000,000 * 8 = 8,000,000 bytes on 64-bit systems) requires
order 11 pages. This exceeds MAX_PAGE_ORDER and triggers a warning in the
page allocator:

WARNING: mm/page_alloc.c:5340 at alloc_order_allowed mm/page_alloc.c:5340
[inline]
WARNING: mm/page_alloc.c:5340 at __alloc_frozen_pages_noprof+0xe4/0x640
mm/page_alloc.c:5397
Call trace:
 alloc_order_allowed mm/page_alloc.c:5340 [inline]
 __alloc_frozen_pages_noprof+0xe4/0x640 mm/page_alloc.c:5397
 alloc_pages_mpol+0x1fc/0x3d0 mm/mempolicy.c:2486
 alloc_frozen_pages_noprof+0xe0/0x214 mm/mempolicy.c:2557
 ___kmalloc_large_node+0xf0/0x160 mm/slub.c:5353
 __kmalloc_large_node_noprof+0x2c/0x8c mm/slub.c:5385
 fill_object_idr drivers/gpu/drm/drm_lease.c:389 [inline]
 drm_mode_create_lease_ioctl+0x45c/0x15c8 drivers/gpu/drm/drm_lease.c:521
 drm_ioctl_kernel+0x250/0x328 drivers/gpu/drm/drm_ioctl.c:817
 drm_ioctl+0x65c/0xa58 drivers/gpu/drm/drm_ioctl.c:914
 vfs_ioctl fs/ioctl.c:51 [inline]
 __do_sys_ioctl fs/ioctl.c:597 [inline]

Furthermore, cl->object_count is an unbounded __u32, whereas
fill_object_idr() and validate_lease() treat object_count as a signed
integer. A value of cl->object_count greater than or equal to 2^31 results
in signed integer overflow. In addition, an allocation size exceeding
INT_MAX would trigger a WARN_ON_ONCE inside __kvmalloc_node_noprof().

Fix these issues by validating cl->object_count early in
drm_mode_create_lease_ioctl() so that requests with cl->object_count >
INT_MAX / sizeof(struct drm_mode_object *) are rejected with -EINVAL.
Additionally, switch the object_ids allocation to vmemdup_array_user() and
the objects pointer array allocation to kvzalloc_objs(), freeing both with
kvfree(), so that large allocations can fall back to vmalloc without
triggering allocator warnings or failing under memory fragmentation.

Fixes: 62884cd386b8 ("drm: Add four ioctls for managing drm mode object leases [v7]")
Assisted-by: Gemini:gemini-3.8-flash Gemini:gemini-3.1-pro-preview syzbot
Reported-by: syzbot+6754751ad05524dae739@syzkaller.appspotmail.com
Closes: https://syzkaller.appspot.com/bug?extid=6754751ad05524dae739
Link: https://syzkaller.appspot.com/ai_job?id=9d9e7ba8-2ca5-4a5b-a7be-8e951e80e2f7
To: "David Airlie" <airlied@gmail.com>
To: <dri-devel@lists.freedesktop.org>
To: "Maarten Lankhorst" <maarten.lankhorst@linux.intel.com>
To: "Maxime Ripard" <mripard@kernel.org>
To: "Simona Vetter" <simona@ffwll.ch>
To: "Thomas Zimmermann" <tzimmermann@suse.de>
To: "Keith Packard" <keithp@keithp.com>
Cc: <linux-kernel@vger.kernel.org>

---
diff --git a/drivers/gpu/drm/drm_lease.c b/drivers/gpu/drm/drm_lease.c
index 5d2cf724c..6d31bc95d 100644
--- a/drivers/gpu/drm/drm_lease.c
+++ b/drivers/gpu/drm/drm_lease.c
@@ -3,6 +3,9 @@
  * Copyright © 2017 Keith Packard <keithp@keithp.com>
  */
 #include <linux/file.h>
+#include <linux/limits.h>
+#include <linux/slab.h>
+#include <linux/string.h>
 #include <linux/uaccess.h>
 
 #include <drm/drm_auth.h>
@@ -386,7 +389,7 @@ static int fill_object_idr(struct drm_device *dev,
 	int ret;
 	bool universal_planes = READ_ONCE(lessor_priv->universal_planes);
 
-	objects = kzalloc_objs(struct drm_mode_object *, object_count);
+	objects = kvzalloc_objs(struct drm_mode_object *, object_count);
 	if (!objects)
 		return -ENOMEM;
 
@@ -462,7 +465,7 @@ static int fill_object_idr(struct drm_device *dev,
 		if (objects[o])
 			drm_mode_object_put(objects[o]);
 	}
-	kfree(objects);
+	kvfree(objects);
 	return ret;
 }
 
@@ -496,6 +499,11 @@ int drm_mode_create_lease_ioctl(struct drm_device *dev,
 		return -EINVAL;
 	}
 
+	if (cl->object_count > INT_MAX / sizeof(struct drm_mode_object *)) {
+		drm_dbg_lease(dev, "too many objects: %u\n", cl->object_count);
+		return -EINVAL;
+	}
+
 	lessor = drm_file_get_master(lessor_priv);
 	/* Do not allow sub-leases */
 	if (lessor->lessor) {
@@ -509,8 +517,8 @@ int drm_mode_create_lease_ioctl(struct drm_device *dev,
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
@@ -520,7 +528,7 @@ int drm_mode_create_lease_ioctl(struct drm_device *dev,
 		/* fill and validate the object idr */
 		ret = fill_object_idr(dev, lessor_priv, &leases,
 				      object_count, object_ids);
-		kfree(object_ids);
+		kvfree(object_ids);
 		if (ret) {
 			drm_dbg_lease(dev, "lease object lookup failed: %i\n", ret);
 			idr_destroy(&leases);


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
