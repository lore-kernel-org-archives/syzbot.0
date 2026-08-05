Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 78CDC483827
	for <syzbot@lists.linux.dev>; Wed,  5 Aug 2026 17:06:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785949612; cv=none; b=XkgBVtCcQpqEoTACsyOUfPbdWqzQR6Bf5HLmyv1rwiDrX9NUpDfwmBJGRzSx744W/YaXAem1p8Mf1/sPn93nPw20KaeBk4isyp8eqiRYhRLUtYblSTaKi1it/nA2Jsw+nmU1jOu1D2z2IUHSZxc5IikW5E8K64s21/NbLba69W8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785949612; c=relaxed/simple;
	bh=V4Od7m37zi1yqHOzGeg6qivZKYvZ+e4xleDxPtoS3HI=;
	h=From:To:Cc:Subject:Message-ID:MIME-Version:Content-Type:Date; b=U5iQsQr+FAo8v8oIXXdYtodt/+1uw34B9EfZpL6+LPZew67Paxu5XWneKpGZZJx9ElbodlN7mX09H7e3PY/wyv0bztUdzaA5zOIIuqQ9I6yFa5DxD3ZRlpVMjBoqxyekt9Tw0rx1agJ3dKamKJ8SldYaszbX4hvE0XLiL6ZZw68=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Qa81oe8p; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Qa81oe8p"
Received: by smtp.kernel.org (Postfix) with UTF8SMTPSA id 7FAC41F000E9;
	Wed,  5 Aug 2026 17:06:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1785949608;
	bh=/5Azvy4o2V5krn9KCdJ9CdIWTpihRdzyz8CNQNRYnJU=;
	h=From:To:Cc:Subject:Date;
	b=Qa81oe8p1R21FPQ+ZS+xyclgMAlZ1uEQePVShgqkpZ3pgHadIafdiSReLQX9IEhcs
	 C+kpU8Y7qNbSTqnZ2wGfXFIMAWC81l/Ry0oM7E/1BxHaiUArBgkKhaAqmScckDGO6r
	 iZ70aI+DhsoFntev4UFzD/1TSFEAEhmb1h/xgTXp8dF5lPTsz9g4XTma1CsiInibwX
	 5cRmgDbUUw8CVLbIsAp5XVV0VPHavdvgTSRc9lJcOOw4zpcqrTmWa5FWpIFPmAIvbk
	 XBEcQS3aYoRfjz0xFnqj2AJQGObNLCJKtWl4uia4EhHRZiGZIawnnEwoWhVllyBU8t
	 gWCPM1cNxSw7A==
From: "syzbot" <syzbot@kernel.org>
To: syzkaller-upstream-moderation@googlegroups.com
Cc: syzbot@lists.linux.dev
Subject: [PATCH RFC] KVM: pfncache: Fix use-after-free for non-memslot HVAs
Message-ID: <fc4d47e2-2a04-45f6-bd1f-be7e46900f59@mail.kernel.org>
Precedence: bulk
X-Mailing-List: syzbot@lists.linux.dev
List-Id: <syzbot.lists.linux.dev>
List-Subscribe: <mailto:syzbot+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:syzbot+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Date: Wed,  5 Aug 2026 17:06:48 +0000 (UTC)

A use-after-free can occur in kvm_xen_shared_info_init() when caching user
virtual addresses (HVAs) that are not backed by a KVM memslot:

BUG: KASAN: use-after-free in kvm_xen_shared_info_init+0x35b/0x590
Read of size 4 at addr ffff8881f1b77900 by task syz-executor675/5843

Call Trace:
 <TASK>
 kasan_report+0x117/0x150 mm/kasan/report.c:595
 kvm_xen_shared_info_init+0x35b/0x590 arch/x86/kvm/xen.c:90
 kvm_xen_hvm_set_attr+0x81a/0x1750 arch/x86/kvm/xen.c:806
 kvm_arch_vm_ioctl+0xdc7/0x1a00 arch/x86/kvm/x86.c:7514
 kvm_vm_ioctl+0x8f7/0xd30 virt/kvm/kvm_main.c:5381
 ...
 </TASK>

page last free pid 5843 tgid 5842 stack trace:
 __free_frozen_pages+0xbdb/0xcb0 mm/page_alloc.c:2950
 __folio_put+0x2b5/0x350 mm/swap.c:112
 hva_to_pfn_retry virt/kvm/pfncache.c:246 [inline]
 __kvm_gpc_refresh+0x1274/0x1710 virt/kvm/pfncache.c:330
 __kvm_gpc_activate+0x286/0x3b0 virt/kvm/pfncache.c:424
 kvm_xen_hvm_set_attr+0x76f/0x1750 arch/x86/kvm/xen.c:798
 ...

The root cause is a flaw in how KVM's MMU notifiers interact with the
gfn_to_pfn_cache (gpc). When a user virtual address is not backed by a
memslot (e.g., when KVM_XEN_HVM_SET_ATTR maps a Xen shared info page using
an anonymous mmap region), the MMU notifier invalidation logic skips
calling kvm_mmu_invalidate_end() because it finds no intersecting memslots.
Consequently, kvm->mmu_invalidate_seq is never incremented for this
invalidation.

Concurrently, if hva_to_pfn_retry() is refreshing the gpc, it drops the
gpc->lock to call hva_to_pfn(). If a concurrent MADV_DONTNEED unmaps the
page and finishes invalidate_range_end() while the lock is dropped,
hva_to_pfn_retry() will fail to detect the invalidation because
mmu_invalidate_seq was not incremented. It will then incorrectly cache and
use a freed page, leading to a use-after-free.

To fix this without introducing unconditional mmu_lock contention for
gpc-only invalidations, introduce a dedicated sequence counter,
gpc_invalidate_seq, for the gfn_to_pfn_cache.

Increment this counter in gfn_to_pfn_cache_invalidate_start() whenever an
invalidated HVA range overlaps with any gpc->uhva, even if the gpc is
currently marked as invalid. This ensures that hva_to_pfn_retry() can
detect concurrent invalidations by snapshotting and checking
gpc_invalidate_seq alongside mmu_invalidate_seq. Because hva_to_pfn_retry()
also checks kvm->mn_active_invalidate_count (which is correctly incremented
and decremented unconditionally by the MMU notifier hooks), incrementing
the sequence counter at the start of the invalidation is perfectly safe. If
the invalidation is still in progress when hva_to_pfn_retry() re-acquires
the lock, mn_active_invalidate_count > 0 will force a retry anyway. If the
invalidation has finished, the changed gpc_invalidate_seq will force the
retry.

Fixes: 721f5b0dda78 ("KVM: pfncache: allow a cache to be activated with a fixed (userspace) HVA")
Assisted-by: Gemini:gemini-3.5-flash Gemini:gemini-3.1-pro-preview syzbot
Reported-by: syzbot+0948c82180d475ad24e2@syzkaller.appspotmail.com
Closes: https://syzkaller.appspot.com/bug?extid=0948c82180d475ad24e2
Link: https://syzkaller.appspot.com/ai_job?id=f8623867-bd64-456f-b512-82c9a04c8460
To: <kvm@vger.kernel.org>
To: "Paolo Bonzini" <pbonzini@redhat.com>
To: "Paul Durrant" <pdurrant@amazon.com>
Cc: <linux-kernel@vger.kernel.org>

---
diff --git a/include/linux/kvm_host.h b/include/linux/kvm_host.h
index ab8cfaec8..4c0970855 100644
--- a/include/linux/kvm_host.h
+++ b/include/linux/kvm_host.h
@@ -805,6 +805,7 @@ struct kvm {
 	/* For management / invalidation of gfn_to_pfn_caches */
 	spinlock_t gpc_lock;
 	struct list_head gpc_list;
+	unsigned long gpc_invalidate_seq;
 
 	/*
 	 * created_vcpus is protected by kvm->lock, and is incremented
diff --git a/virt/kvm/pfncache.c b/virt/kvm/pfncache.c
index 728d2c1b4..877d6d1d8 100644
--- a/virt/kvm/pfncache.c
+++ b/virt/kvm/pfncache.c
@@ -26,34 +26,40 @@ void gfn_to_pfn_cache_invalidate_start(struct kvm *kvm, unsigned long start,
 				       unsigned long end)
 {
 	struct gfn_to_pfn_cache *gpc;
+	bool wake = false;
 
 	spin_lock(&kvm->gpc_lock);
 	list_for_each_entry(gpc, &kvm->gpc_list, list) {
 		read_lock_irq(&gpc->lock);
 
 		/* Only a single page so no need to care about length */
-		if (gpc->valid && !is_error_noslot_pfn(gpc->pfn) &&
-		    gpc->uhva >= start && gpc->uhva < end) {
-			read_unlock_irq(&gpc->lock);
-
-			/*
-			 * There is a small window here where the cache could
-			 * be modified, and invalidation would no longer be
-			 * necessary. Hence check again whether invalidation
-			 * is still necessary once the write lock has been
-			 * acquired.
-			 */
-
-			write_lock_irq(&gpc->lock);
-			if (gpc->valid && !is_error_noslot_pfn(gpc->pfn) &&
-			    gpc->uhva >= start && gpc->uhva < end)
-				gpc->valid = false;
-			write_unlock_irq(&gpc->lock);
-			continue;
+		if (gpc->uhva >= start && gpc->uhva < end) {
+			wake = true;
+
+			if (gpc->valid && !is_error_noslot_pfn(gpc->pfn)) {
+				read_unlock_irq(&gpc->lock);
+
+				/*
+				 * There is a small window here where the cache could
+				 * be modified, and invalidation would no longer be
+				 * necessary. Hence check again whether invalidation
+				 * is still necessary once the write lock has been
+				 * acquired.
+				 */
+
+				write_lock_irq(&gpc->lock);
+				if (gpc->valid && !is_error_noslot_pfn(gpc->pfn) &&
+				    gpc->uhva >= start && gpc->uhva < end)
+					gpc->valid = false;
+				write_unlock_irq(&gpc->lock);
+				continue;
+			}
 		}
 
 		read_unlock_irq(&gpc->lock);
 	}
+	if (wake)
+		kvm->gpc_invalidate_seq++;
 	spin_unlock(&kvm->gpc_lock);
 }
 
@@ -124,7 +130,8 @@ static void gpc_unmap(kvm_pfn_t pfn, void *khva)
 #endif
 }
 
-static inline bool mmu_notifier_retry_cache(struct kvm *kvm, unsigned long mmu_seq)
+static inline bool mmu_notifier_retry_cache(struct kvm *kvm, unsigned long mmu_seq,
+					    unsigned long gpc_seq)
 {
 	/*
 	 * mn_active_invalidate_count acts for all intents and purposes
@@ -149,7 +156,7 @@ static inline bool mmu_notifier_retry_cache(struct kvm *kvm, unsigned long mmu_s
 	 * new (incremented) value of mmu_invalidate_seq is observed.
 	 */
 	smp_rmb();
-	return kvm->mmu_invalidate_seq != mmu_seq;
+	return kvm->mmu_invalidate_seq != mmu_seq || kvm->gpc_invalidate_seq != gpc_seq;
 }
 
 static kvm_pfn_t hva_to_pfn_retry(struct gfn_to_pfn_cache *gpc)
@@ -159,6 +166,7 @@ static kvm_pfn_t hva_to_pfn_retry(struct gfn_to_pfn_cache *gpc)
 	kvm_pfn_t new_pfn = KVM_PFN_ERR_FAULT;
 	void *new_khva = NULL;
 	unsigned long mmu_seq;
+	unsigned long gpc_seq;
 	struct page *page;
 
 	struct kvm_follow_pfn kfp = {
@@ -182,6 +190,7 @@ static kvm_pfn_t hva_to_pfn_retry(struct gfn_to_pfn_cache *gpc)
 
 	do {
 		mmu_seq = gpc->kvm->mmu_invalidate_seq;
+		gpc_seq = gpc->kvm->gpc_invalidate_seq;
 		smp_rmb();
 
 		write_unlock_irq(&gpc->lock);
@@ -232,7 +241,7 @@ static kvm_pfn_t hva_to_pfn_retry(struct gfn_to_pfn_cache *gpc)
 		 * attempting to refresh.
 		 */
 		WARN_ON_ONCE(gpc->valid);
-	} while (mmu_notifier_retry_cache(gpc->kvm, mmu_seq));
+	} while (mmu_notifier_retry_cache(gpc->kvm, mmu_seq, gpc_seq));
 
 	gpc->valid = true;
 	gpc->pfn = new_pfn;


base-commit: 075b74841bd0065a3bda3440873c747938e69b68
-- 
This is an AI-generated patch subject to moderation.
Reply with '#syz upstream' to Sign-off the patch as a human author
and send it to the upstream kernel mailing lists.
Reply with '#syz reject' to reject it ('#syz unreject' to undo).

See https://goo.gle/syzbot-ai-patches for information about AI-generated patches.
You can comment on the patch as usual, syzbot will try to address
the comments and send a new version of the patch if necessary.
syzbot engineers can be reached at syzkaller@googlegroups.com.
