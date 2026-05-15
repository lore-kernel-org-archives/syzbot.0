Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DD23A43637A
	for <syzbot@lists.linux.dev>; Fri, 15 May 2026 09:45:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778838335; cv=none; b=NJ7OTGylGIbkIQ7Wy+vkRanM6LJ1bxbihgUogGU1Yhq8k3tBj7TzDco9DSCw07q8Gr65/fWehSskB9a+MK8vB9L7K9taZpV9UqV/NciK/eU+hTSAw7AuZcwnHZ2sFpT7rrv7XKl5pC7CyQNQzzNmLxPgO44wvuZUtGsrPYwJz2Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778838335; c=relaxed/simple;
	bh=X3glECiVyxWUr/+Etnh918ITt5XWWssYN5qXKgggU4w=;
	h=From:To:Cc:Subject:Message-ID:MIME-Version:Content-Type:Date; b=SyGswc+dCK9wDiGFG29ZHLLxvneXz9jRJvm6de8pCywHGH14Gm8cCDMxsnRfr8pB1aQcVQIAYvHRGvnZZJqTxcPLLtFert/fM5/rnn3xSiVVYX1sJ0VGbIKlgaPVQkjxfEMjqpGvqzjzANYuwjIyl289jaqCanU/Sqp1KtxfkjY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=dIHuDpmo; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="dIHuDpmo"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7C384C2BCB3;
	Fri, 15 May 2026 09:45:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1778838335;
	bh=X3glECiVyxWUr/+Etnh918ITt5XWWssYN5qXKgggU4w=;
	h=From:To:Cc:Subject:Date:From;
	b=dIHuDpmoFE672AMQXPhKvh2nsUSTEfHF7xrR8LjPhEQLPrYbEVcwaKvNYu9xjDoP9
	 d5zEnu/aycjdayRU9XHWZa+QNZHI8/0Ez/Ylh7dNGCf1+h5AC9WvbQPo2nKUL01Bbw
	 1JMUt7585t5WtotGjJkdNSS6NtfQ0IonqWlvFaYXAEM2N9QFcIlqrxUi4OIQXnwoqm
	 F3o7VpI0okI3/nAuGbTWVYZcnjIBm0t1S+ovb3E0iPy2HiTgzyDBTtHM+0mz28MJoa
	 zMF36YTM2o3mRetqfTIyecFUh9pMdpXGkdYchh4pcvwJcamxYu6x7T62U1uK0imu1h
	 tUZ+ubENq8MFw==
From: "syzbot" <syzbot@kernel.org>
To: syzkaller-upstream-moderation+final@googlegroups.com
Cc: syzbot@lists.linux.dev
Subject: [PATCH] drm/lease: Fix warning on large user-controlled allocations
Message-ID: <57ec3848-0d56-47b8-8075-bb2ca9c8a1cd@mail.kernel.org>
Precedence: bulk
X-Mailing-List: syzbot@lists.linux.dev
List-Id: <syzbot.lists.linux.dev>
List-Subscribe: <mailto:syzbot+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:syzbot+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Date: Fri, 15 May 2026 09:45:35 +0000 (UTC)

In drm_mode_create_lease_ioctl(), a user-provided object_count is used
to allocate memory for object_ids and objects. When a user requests a
massive number of objects, the allocation size can exceed the maximum
contiguous physical memory limit (MAX_PAGE_ORDER). Since kzalloc_objs()
defaults to GFP_KERNEL without __GFP_NOWARN, this triggers a
WARN_ON_ONCE_GFP in the page allocator.

To fix this, replace kzalloc_objs() with kvzalloc_objs() in
fill_object_idr() and memdup_array_user() with vmemdup_array_user() in
drm_mode_create_lease_ioctl(). This allows the allocations to gracefully
fall back to virtually contiguous memory (vmalloc) if the requested size
is too large or physical memory is fragmented, preventing the warning
and allowing large lease requests to succeed or fail gracefully with
-ENOMEM. Update the corresponding kfree() calls to kvfree() accordingly.

Fixes: 62884cd386b876638720ef88374b31a84ca7ee5f ("drm: Add four ioctls for managing drm mode object leases [v7]")
Assisted-by: Gemini:gemini-3.1-pro-preview Gemini:gemini-3-flash-preview
Reported-by: syzbot+03fb58296859d8dbab4d@syzkaller.appspotmail.com
Link: https://syzkaller.appspot.com/bug?extid=03fb58296859d8dbab4d
Link: https://syzkaller.appspot.com/ai_job?id=d9152b5a-380f-4c4e-af5b-1890078e5d46
Signed-off-by: Aleksandr Nogikh <nogikh@google.com>

---
diff --git a/drivers/gpu/drm/drm_lease.c b/drivers/gpu/drm/drm_lease.c
index 5d2cf724c..9ccfa4712 100644
--- a/drivers/gpu/drm/drm_lease.c
+++ b/drivers/gpu/drm/drm_lease.c
@@ -386,7 +386,7 @@ static int fill_object_idr(struct drm_device *dev,
 	int ret;
 	bool universal_planes = READ_ONCE(lessor_priv->universal_planes);
 
-	objects = kzalloc_objs(struct drm_mode_object *, object_count);
+	objects = kvzalloc_objs(struct drm_mode_object *, object_count);
 	if (!objects)
 		return -ENOMEM;
 
@@ -462,7 +462,7 @@ static int fill_object_idr(struct drm_device *dev,
 		if (objects[o])
 			drm_mode_object_put(objects[o]);
 	}
-	kfree(objects);
+	kvfree(objects);
 	return ret;
 }
 
@@ -509,8 +509,8 @@ int drm_mode_create_lease_ioctl(struct drm_device *dev,
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
@@ -520,7 +520,7 @@ int drm_mode_create_lease_ioctl(struct drm_device *dev,
 		/* fill and validate the object idr */
 		ret = fill_object_idr(dev, lessor_priv, &leases,
 				      object_count, object_ids);
-		kfree(object_ids);
+		kvfree(object_ids);
 		if (ret) {
 			drm_dbg_lease(dev, "lease object lookup failed: %i\n", ret);
 			idr_destroy(&leases);


base-commit: 5d6919055dec134de3c40167a490f33c74c12581
-- 
See  for more information.
