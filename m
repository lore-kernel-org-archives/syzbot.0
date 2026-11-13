Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794577357;
	b=JrTxF6jnFYs7CxmZiDm9DEA4RHkqjLC2S71VjLpIVLM+900Vv1NiBbIVGo+fY2ezEpZQ
	 ignTOnkNDC7SZFhoVkdHAztIJPRoYcriqxxNHrtYMFnkUNRLBU9e8b+Rcwk7GwRD3HWzK
	 IovjiozFpNAG9zgrxjda/kZXVSqqMT4vJkxtMBM2wUKo98QcJvDL2PwmfPBhsioa2Vn+c
	 qwsFWng06gWkQIFfOMdDNt22ok78kbNoNCN4txgjjJvZvC/ZXVnjuGcDRGYPLvuY7J+WF
	 98oudkjccch8zAxdsD4pVxTFYW/W933dBPt0rKmjkwcP2zk/RlGJRj/5TOt7B2lXp3w==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794577357;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Message-ID:MIME-Version:
	 Content-Type:Content-Transfer-Encoding:Date;
	bh=j8XolcGAe48AuPVPUWec7QnIU2IT/GguvVqRdXm/Nkk=;
	b=u2gNmk/x8/CesLJQfuz48AxIJ11lfkgFPW+yDr3Vwp5hzVIuAfaPPy78uaDYdM0zWJaW
	 tLqX0q+6Y8Yz0WwT/iFuo7nWXi82jHsp0GIjLc5+0yDApzg3cKfjBrR6mQcJ14sq7NSXn
	 d3d40Qfj2eyXOs4rMRAEVZW33eMOTxTh3r3ILhdNQt2F96yPke9uJWIQkrl792YeMGIKP
	 fuE19xhxIj9siv9iCY0U2rLHHN8iRPMiU2E02m2lURraUDowj7NsL1vGzislorqOKqc0n
	 eAgBVWM7B9hvsw81BWMh25oMhm/VogOcH+OKuHWZT+SssPydVZXk/IySuavGxt+uRjg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b="mZ2/rQP7";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with UTF8SMTPS id 9FF37606A327
	for <syzbot@lists.linux.dev>; Fri, 13 Nov 2026 13:42:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=mZ2/rQP7
Received: by smtp.kernel.org (Postfix) with UTF8SMTPSA id 187C11F000C4;
	Fri, 13 Nov 2026 13:42:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794577357;
	bh=j8XolcGAe48AuPVPUWec7QnIU2IT/GguvVqRdXm/Nkk=;
	h=From:To:Cc:Subject:Date;
	b=mZ2/rQP7sgPYpeSLuUcJFtfX+FK9osL/4IZW4p/p2dOKW3NULwE5iZEw4vxu/UZo8
	 JtpA3xMbIVCUnD7+0g06NlR1RMsUydKDsR9v1YUwNH5ur2KNwkYLMZVqdIcSxeMinX
	 BUdKnM+Kgm7VK+bwSQgT74BsR+Zivd/L3FUElgs6HiJ7c4I2IDcC9QjT05UGDWsvZW
	 sHvEk4GVx+PKudfxU61Fv3TYt0tF6Okvii4Cw1wQlhngWO247Au96Myb754i97qrzm
	 geJPZYS4JDufD9ZFwkVatOnOVdVzOXhbyhp32oHWfIRL9NutiDs2XwByQ95RXm5x/3
	 1xxeZDGVxjjnQ==
From: "syzbot" <syzbot@kernel.org>
To: syzkaller-upstream-moderation@googlegroups.com
Cc: immersa.bartosz.chronowski@gmail.com, syzbot@lists.linux.dev
Subject: [PATCH RFC v3] drm/lease: Use kvmalloc and bound object_count in create lease ioctl
Message-ID: <35ebff09-f171-48d9-8f54-8184e1a9756b@mail.kernel.org>
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
Date: Fri, 13 Nov 2026 13:42:37 +0000 (UTC)

In drm_mode_create_lease_ioctl(), user space supplies an object_count and
an array of object_ids to be leased. The kernel copies the IDs from user
space using memdup_array_user(), and then fill_object_idr() allocates a
temporary array of pointers using kcalloc() (at
drivers/gpu/drm/drm_lease.c:389 in the reported tree).

Because kcalloc() performs a kmalloc-family allocation with GFP_KERNEL
(which lacks __GFP_NOWARN), if user space requests a sufficiently large
object_count (for example, 1,000,000 mode objects), the allocation for the
pointer array (1,000,000 * 8 = 8,000,000 bytes on 64-bit systems) requires
order 11 pages. This exceeds MAX_PAGE_ORDER and triggers a warning in the
page allocator (stack trace from a later source revision):

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

Furthermore, cl->object_count is an unbounded __u32, whereas helper
functions such as fill_object_idr() take object_count as a signed integer.
A value of cl->object_count greater than INT_MAX is converted to a signed
parameter (becoming negative) rather than causing signed arithmetic
overflow. In addition, an allocation size exceeding INT_MAX would trigger a
WARN_ON_ONCE inside __kvmalloc_node_noprof().

Fix these issues by validating cl->object_count early in
drm_mode_create_lease_ioctl() so that values exceeding INT_MAX are rejected
with -EINVAL. In addition, cap object_count to DRM_MAX_LEASE_OBJECTS
(1024). In DRM, only CRTCs, connectors, and planes are leaseable, and DRM
core bounds each to 32 objects via 32-bit index bitmasks (totaling at most
96 leaseable objects). A limit of 1024 covers all supported leaseable
objects while staying within a reasonable allocation budget. Additionally,
switch the object_ids allocation to vmemdup_array_user() and the objects
pointer array allocation to kvzalloc_objs(), freeing both with kvfree().
The vmalloc fallback eliminates the high-order allocation warning, while
the count limit controls resource usage.

Fixes: 62884cd386b8 ("drm: Add four ioctls for managing drm mode object leases [v7]")
Assisted-by: Gemini:gemini-3.8-flash syzbot
Reported-by: syzbot+6754751ad05524dae739@syzkaller.appspotmail.com
Closes: https://syzkaller.appspot.com/bug?extid=6754751ad05524dae739
Link: https://syzkaller.appspot.com/ai_job?id=0997bcbd-3b20-4d02-8e3b-6b65df7f4a0e
To: "David Airlie" <airlied@gmail.com>
To: <dri-devel@lists.freedesktop.org>
To: "Maarten Lankhorst" <maarten.lankhorst@linux.intel.com>
To: "Maxime Ripard" <mripard@kernel.org>
To: "Simona Vetter" <simona@ffwll.ch>
To: "Thomas Zimmermann" <tzimmermann@suse.de>
To: "Keith Packard" <keithp@keithp.com>
Cc: <linux-kernel@vger.kernel.org>

---
v3:
- Correct the description of the reported-tree allocation to kcalloc() instead of kzalloc_objs().
- Label the quoted warning stack trace as coming from a later source revision.

v2:
- Define DRM_MAX_LEASE_OBJECTS (1024) and cap object_count to it to bound per-request resource usage based on supported leaseable DRM objects.
- Validate cl->object_count > INT_MAX directly in early checks.
- Update commit description to clarify conversion to signed parameter, allocation budget rationale, and historical warning site line in reported tree.
https://lore.kernel.org/all/c18e659d-1e93-4309-8c28-d9fa96827675@mail.kernel.org/T/

v1:
https://lore.kernel.org/all/4c497e30-fff3-4ef0-81f9-b9b47ca9e22f@mail.kernel.org/T/
---
diff --git a/drivers/gpu/drm/drm_lease.c b/drivers/gpu/drm/drm_lease.c
index 5d2cf724c..6f05dde38 100644
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
@@ -69,6 +72,14 @@
 #define drm_for_each_lessee(lessee, lessor) \
 	list_for_each_entry((lessee), &(lessor)->lessees, lessee_list)
 
+/*
+ * Only CRTCs, connectors, and planes are leaseable, and DRM core bounds
+ * each to 32 objects (32-bit index bitmasks). Cap per-request object_count
+ * to a small finite limit that covers all supported leaseable objects
+ * within a reasonable allocation budget.
+ */
+#define DRM_MAX_LEASE_OBJECTS 1024
+
 static uint64_t drm_lease_idr_object;
 
 struct drm_master *drm_lease_owner(struct drm_master *master)
@@ -386,7 +397,7 @@ static int fill_object_idr(struct drm_device *dev,
 	int ret;
 	bool universal_planes = READ_ONCE(lessor_priv->universal_planes);
 
-	objects = kzalloc_objs(struct drm_mode_object *, object_count);
+	objects = kvzalloc_objs(struct drm_mode_object *, object_count);
 	if (!objects)
 		return -ENOMEM;
 
@@ -462,7 +473,7 @@ static int fill_object_idr(struct drm_device *dev,
 		if (objects[o])
 			drm_mode_object_put(objects[o]);
 	}
-	kfree(objects);
+	kvfree(objects);
 	return ret;
 }
 
@@ -496,6 +507,11 @@ int drm_mode_create_lease_ioctl(struct drm_device *dev,
 		return -EINVAL;
 	}
 
+	if (cl->object_count > INT_MAX) {
+		drm_dbg_lease(dev, "too many objects: %u\n", cl->object_count);
+		return -EINVAL;
+	}
+
 	lessor = drm_file_get_master(lessor_priv);
 	/* Do not allow sub-leases */
 	if (lessor->lessor) {
@@ -509,8 +525,15 @@ int drm_mode_create_lease_ioctl(struct drm_device *dev,
 	/* Handle leased objects, if any */
 	idr_init(&leases);
 	if (object_count != 0) {
-		object_ids = memdup_array_user(u64_to_user_ptr(cl->object_ids),
-					       object_count, sizeof(__u32));
+		if (object_count > DRM_MAX_LEASE_OBJECTS) {
+			drm_dbg_lease(dev, "too many objects: %zu\n", object_count);
+			ret = -EINVAL;
+			idr_destroy(&leases);
+			goto out_lessor;
+		}
+
+		object_ids = vmemdup_array_user(u64_to_user_ptr(cl->object_ids),
+						object_count, sizeof(__u32));
 		if (IS_ERR(object_ids)) {
 			ret = PTR_ERR(object_ids);
 			idr_destroy(&leases);
@@ -520,7 +543,7 @@ int drm_mode_create_lease_ioctl(struct drm_device *dev,
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
