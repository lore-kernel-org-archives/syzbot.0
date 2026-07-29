Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8F3B2449B22
	for <syzbot@lists.linux.dev>; Wed, 29 Jul 2026 09:50:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785318626; cv=none; b=NLTaFpQ+ySxlA87ihmDN6C6mFe4YxHsVt4/RhvTthxK7Du3+ME3r6UPN/YS+/1gkIh1bzLOqTs8Y4kqaPo+MZneCO5j3B9ojCnpuNlUgxvDtTv87/oo7+bSQwrTvRW7Un0CbOYgtTLtxuu2103TMtfAV8NlqLVfETQ2ajA9UTkk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785318626; c=relaxed/simple;
	bh=XtW94cVtP5SuRmeKofNvnHVwPvVIWDas+5O1NWimlqg=;
	h=From:To:Cc:Subject:Message-ID:MIME-Version:Content-Type:Date; b=RVC0+NLG6w3X83o+hbOMU/S5G7PwxiIhxWHy5/DAqkEwYB8aWlbcdJwf2fvDvmeR1CVMpVECHzGUS5Hs0ZUKMNtgxHfaujCWTRGiDzq3fLKIqdCg23nirzTT+l/V9ahB4RDde7mWlt4Ie9GTmzmCmYuANmw1zU2a4CYn9ZgXAEc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=jqCcZnNU; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="jqCcZnNU"
Received: by smtp.kernel.org (Postfix) with UTF8SMTPSA id 5CCAE1F000E9;
	Wed, 29 Jul 2026 09:50:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1785318624;
	bh=K7EoTWvUQ6ftUiGJljGvUIxexvo3U/h6WW45MdN/KiA=;
	h=From:To:Cc:Subject:Date;
	b=jqCcZnNU7KN0TwY4uVoEDp5Q/M/LP1IqfOCsbuwxxwaFSUlOP/9FtD1Oz/Rl+Mtj6
	 ypS1kUwpCkzglfmuFMqqxfbNQqSpuT4Obkq7s8TAIWLU2WayccbJYa+JfZZfS+laY3
	 IyUKi578iLexldc1ZtuZx8fgvYnyb7J/mbftk7r7CumxzxuycKVlpbNseAVAlHX83Y
	 epfwVey4OeDumiS+eaBaqaqEO7LObi70C69H+01NWZ/DGrifOuTPW6PEH4BobwLZ/+
	 lPzNi8N9Iyu+Ixxfg2o6ZeHdybiuOr2ZMug1uYjA+Eg301rg5IRw3ip2BveF0XvAGk
	 bcD+QNw3+qKLQ==
From: "syzbot" <syzbot@kernel.org>
To: syzkaller-upstream-moderation@googlegroups.com
Cc: syzbot@lists.linux.dev
Subject: [PATCH RFC] irqchip/gic-v3-its: Make LPI free path infallible
Message-ID: <564b7035-7d20-4f5b-ac7d-a48e58e4a0a0@mail.kernel.org>
Precedence: bulk
X-Mailing-List: syzbot@lists.linux.dev
List-Id: <syzbot.lists.linux.dev>
List-Subscribe: <mailto:syzbot+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:syzbot+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Date: Wed, 29 Jul 2026 09:50:24 +0000 (UTC)

The ITS driver manages available LPI ranges using a linked list. When LPIs
are freed via free_lpi_range(), the driver allocates a new lpi_range node
to add the freed range back to this list. If this allocation fails (e.g.,
under memory pressure), free_lpi_range() returns -ENOMEM.

The caller, its_lpi_free(), has a void return type and cannot propagate the
error. It wraps the call in a WARN_ON(). When the allocation fails, the
warning is triggered, and the LPI range is permanently leaked because it is
never added back to the free list.

WARNING: drivers/irqchip/irq-gic-v3-its.c:2251 at its_lpi_free
drivers/irqchip/irq-gic-v3-its.c:2251 [inline]
WARNING: drivers/irqchip/irq-gic-v3-its.c:2251 at
its_msi_teardown+0x3a4/0x424 drivers/irqchip/irq-gic-v3-its.c:3644
Call trace:
 its_lpi_free drivers/irqchip/irq-gic-v3-its.c:2251 [inline]
 its_msi_teardown+0x3a4/0x424 drivers/irqchip/irq-gic-v3-its.c:3644
 its_msi_teardown+0xa0/0xb8 drivers/irqchip/irq-gic-its-msi-parent.c:249
 msi_remove_device_irq_domain+0x16c/0x27c kernel/irq/msi.c:1127
 msi_device_data_release+0x38/0x9c kernel/irq/msi.c:293

Free paths must generally be infallible because the caller usually cannot
handle a failure. WARN_ON must not be used for conditions that can
legitimately happen, and pr_err should be used instead if necessary.

Fix this by decoupling the memory allocation from the free path and
shifting it to the allocation path (alloc_lpi_range()), which is allowed to
fail. Introduce a global cache (lpi_free_cache) for lpi_range nodes.
Pre-allocate a node in alloc_lpi_range() and add it to the cache. In
free_lpi_range(), simply pop a node from the cache. Since every successful
allocation adds a node to the cache, free_lpi_range() is guaranteed to find
at least one node.

Additionally, fix two existing memory leaks in the allocation error paths
to keep the cache perfectly balanced. First, in its_lpi_alloc(), if
bitmap_zalloc() fails, free the successfully allocated LPI range before
returning. Second, in its_create_device(), if col_map allocation fails but
lpi_map was successfully allocated, call its_lpi_free() instead of
bitmap_free() to correctly free both the bitmap and the underlying LPI
range.

Fixes: 880cb3cddd16 ("irqchip/gic-v3-its: Refactor LPI allocator")
Assisted-by: Gemini:gemini-3.5-flash Gemini:gemini-3.1-pro-preview syzbot
Reported-by: syzbot+229d761b8a110e6de517@syzkaller.appspotmail.com
Closes: https://syzkaller.appspot.com/bug?extid=229d761b8a110e6de517
Link: https://syzkaller.appspot.com/ai_job?id=09d24d0b-29ec-4b31-b433-6367b7670bfc
To: <linux-arm-kernel@lists.infradead.org>
To: "Marc Zyngier" <maz@kernel.org>
To: "Thomas Gleixner" <tglx@kernel.org>
To: "Marc Zyngier" <marc.zyngier@arm.com>
Cc: <linux-kernel@vger.kernel.org>

---
diff --git a/drivers/irqchip/irq-gic-v3-its.c b/drivers/irqchip/irq-gic-v3-its.c
index 6f5811aae..634b0e154 100644
--- a/drivers/irqchip/irq-gic-v3-its.c
+++ b/drivers/irqchip/irq-gic-v3-its.c
@@ -2097,6 +2097,7 @@ static struct irq_chip its_irq_chip = {
 
 static DEFINE_MUTEX(lpi_range_lock);
 static LIST_HEAD(lpi_range_list);
+static LIST_HEAD(lpi_free_cache);
 
 struct lpi_range {
 	struct list_head	entry;
@@ -2120,8 +2121,13 @@ static struct lpi_range *mk_lpi_range(u32 base, u32 span)
 static int alloc_lpi_range(u32 nr_lpis, u32 *base)
 {
 	struct lpi_range *range, *tmp;
+	struct lpi_range *new_node;
 	int err = -ENOSPC;
 
+	new_node = mk_lpi_range(0, 0);
+	if (!new_node)
+		return -ENOMEM;
+
 	mutex_lock(&lpi_range_lock);
 
 	list_for_each_entry_safe(range, tmp, &lpi_range_list, entry) {
@@ -2140,6 +2146,11 @@ static int alloc_lpi_range(u32 nr_lpis, u32 *base)
 		}
 	}
 
+	if (!err)
+		list_add(&new_node->entry, &lpi_free_cache);
+	else
+		kfree(new_node);
+
 	mutex_unlock(&lpi_range_lock);
 
 	pr_debug("ITS: alloc %u:%u\n", *base, nr_lpis);
@@ -2162,11 +2173,18 @@ static int free_lpi_range(u32 base, u32 nr_lpis)
 {
 	struct lpi_range *new, *old;
 
-	new = mk_lpi_range(base, nr_lpis);
-	if (!new)
+	mutex_lock(&lpi_range_lock);
+
+	if (WARN_ON(list_empty(&lpi_free_cache))) {
+		mutex_unlock(&lpi_range_lock);
 		return -ENOMEM;
+	}
 
-	mutex_lock(&lpi_range_lock);
+	new = list_first_entry(&lpi_free_cache, struct lpi_range, entry);
+	list_del(&new->entry);
+
+	new->base_id = base;
+	new->span = nr_lpis;
 
 	list_for_each_entry_reverse(old, &lpi_range_list, entry) {
 		if (old->base_id < base)
@@ -2195,6 +2213,7 @@ static int __init its_lpi_init(u32 id_bits)
 {
 	u32 lpis = (1UL << id_bits) - 8192;
 	u32 numlpis;
+	struct lpi_range *range;
 	int err;
 
 	numlpis = 1UL << GICD_TYPER_NUM_LPIS(gic_rdists->gicd_typer);
@@ -2205,6 +2224,12 @@ static int __init its_lpi_init(u32 id_bits)
 			lpis);
 	}
 
+	range = mk_lpi_range(0, 0);
+	if (!range)
+		return -ENOMEM;
+
+	list_add(&range->entry, &lpi_free_cache);
+
 	/*
 	 * Initializing the allocator is just the same as freeing the
 	 * full range of LPIs.
@@ -2234,8 +2259,10 @@ static unsigned long *its_lpi_alloc(int nr_irqs, u32 *base, int *nr_ids)
 		goto out;
 
 	bitmap = bitmap_zalloc(nr_irqs, GFP_ATOMIC);
-	if (!bitmap)
+	if (!bitmap) {
+		free_lpi_range(*base, nr_irqs);
 		goto out;
+	}
 
 	*nr_ids = nr_irqs;
 
@@ -2248,7 +2275,7 @@ static unsigned long *its_lpi_alloc(int nr_irqs, u32 *base, int *nr_ids)
 
 static void its_lpi_free(unsigned long *bitmap, u32 base, u32 nr_ids)
 {
-	WARN_ON(free_lpi_range(base, nr_ids));
+	free_lpi_range(base, nr_ids);
 	bitmap_free(bitmap);
 }
 
@@ -3510,7 +3537,8 @@ static struct its_device *its_create_device(struct its_node *its, u32 dev_id,
 	if (!dev || !itt || !col_map || (!lpi_map && alloc_lpis)) {
 		kfree(dev);
 		itt_free_pool(itt, sz);
-		bitmap_free(lpi_map);
+		if (lpi_map)
+			its_lpi_free(lpi_map, lpi_base, nr_lpis);
 		kfree(col_map);
 		return NULL;
 	}


base-commit: f5098b6bae761e346ebcd9da7f95622c04733cff
-- 
This is an AI-generated patch subject to moderation.
Reply with '#syz upstream' to Sign-off the patch as a human author
and send it to the upstream kernel mailing lists.
Reply with '#syz reject' to reject it ('#syz unreject' to undo).

See https://goo.gle/syzbot-ai-patches for information about AI-generated patches.
You can comment on the patch as usual, syzbot will try to address
the comments and send a new version of the patch if necessary.
syzbot engineers can be reached at syzkaller@googlegroups.com.
