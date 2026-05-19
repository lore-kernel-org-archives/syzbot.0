Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9780F3B5839
	for <syzbot@lists.linux.dev>; Tue, 19 May 2026 07:10:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779174609; cv=none; b=mRlXouVk9d9bpqhLl7q7awSFg/UaD2CTNiQ+Hz+MH5Yc+aads3Jwf9cb9e517eQHspQNJrRVh4xAVaU+whrMI28EiTkCopHuMZ9Jy6X/lBO1i2Ag4MQDY0rsOt9hQqnv1IIvCdfobHzrN3SBSJ5Wu3P74krqcFIKuijNqtbwXAA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779174609; c=relaxed/simple;
	bh=PNyzdZ7D7dAVWwdJFQSv28ZbIH1uxEbvpEBER/MNiZI=;
	h=From:To:Cc:Subject:Message-ID:MIME-Version:Content-Type:Date; b=ovAHrcpWOpaVjFvNI7zYY9g0TEinVEShBHQVLHTxNMYZherZGZfEm/wSo8cyIRpWighV4Ju4rHOxE2U+qe1mx6JumTML6w5VnCt8gyGJGWD/8UkiwUeywfborMI6hmUJ0BzD4ChnbogRprP5nB+pC4sXrhrJs3UbrhiZxL/YogM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Nco+i52f; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Nco+i52f"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A6070C2BCB3;
	Tue, 19 May 2026 07:10:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1779174608;
	bh=PNyzdZ7D7dAVWwdJFQSv28ZbIH1uxEbvpEBER/MNiZI=;
	h=From:To:Cc:Subject:Date:From;
	b=Nco+i52fRC6vYcuURZ5D1sZGqzDLbD0SjQ3xC/SP6K8TZ6nKsOE9uU3CV4p/nD4hO
	 E3cUvhKWgAewIVAV+1XuIHudsEKkuJJwhbTczVc+J1Y++94K1j04X5PxBgP3wpQ24b
	 ovw7CtbWC/G/9o7ZcyN/tDyhiOSg7zFq9wHUUWp8qSFP17zkri961wsKiGO2sPYkQG
	 wL5i6CqFvPJw9IK9h3aWDNCvdCzhQpP88SqxJo9hpdI89NajJREhCfzqdNRZFssf1S
	 DRRZWjcMoY8PB76Ij4fLhWhFg8PS4a4me1PkgdnPmmngOKyoSLRfPRZVUh11TZ59Op
	 Ltv3ddjB+RX5g==
From: "syzbot" <syzbot@kernel.org>
To: syzkaller-upstream-moderation+final@googlegroups.com
Cc: syzbot@lists.linux.dev
Subject: [PATCH] bpf: lru: Use resilient spinlocks to prevent NMI deadlocks
Message-ID: <13d16b15-8e25-40f2-afbd-eb9b486bf1d2@mail.kernel.org>
Precedence: bulk
X-Mailing-List: syzbot@lists.linux.dev
List-Id: <syzbot.lists.linux.dev>
List-Subscribe: <mailto:syzbot+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:syzbot+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Date: Tue, 19 May 2026 07:10:08 +0000 (UTC)

BPF LRU maps currently use standard `raw_spinlock_t` for their local and
global list locks, which are not NMI-safe. If an NMI (such as a perf
event hardware breakpoint) interrupts a normal context that is holding
an LRU list lock, and a BPF program executed in the NMI context attempts
to acquire the exact same lock (e.g., via `bpf_map_delete_elem`), it
will spin forever waiting for the lock to be released. This results in a
hard deadlock because the context holding the lock has been preempted by
the NMI itself. Lockdep correctly detects this unsafe `{INITIAL USE} ->
{IN-NMI}` transition and emits an inconsistent lock state warning.

To resolve this, update the LRU list implementation to use resilient
queued spinlocks (`rqspinlock_t`), similar to how bucket locks in
standard BPF hash maps were previously converted. Resilient spinlocks
are NMI-safe because they detect deadlocks (such as re-entrancy on the
same CPU) and return an error instead of hanging. Replace all standard
spinlock operations with their resilient counterparts in
`bpf_lru_list.c`. Since resilient spinlock acquisitions can fail, update
the LRU functions to handle these failures gracefully. For pop
functions, return `NULL` when the lock cannot be acquired, which callers
already handle by propagating an `-ENOMEM` error. When stealing nodes
from remote CPUs, safely skip the CPU if its lock cannot be acquired.
For push and flush functions, abort and return early if the lock fails,
effectively leaking the LRU node, which is an acceptable trade-off to
prevent a hard system deadlock in NMI context.

Fixes: 3a08c2fd763450a927d1130de078d6f9e74944fb ("bpf: LRU List")
Assisted-by: Gemini:gemini-3.1-pro-preview Gemini:gemini-3-flash-preview
Reported-by: syzbot+c69a0a2c816716f1e0d5@syzkaller.appspotmail.com
Link: https://syzkaller.appspot.com/bug?extid=c69a0a2c816716f1e0d5
Link: https://syzkaller.appspot.com/ai_job?id=5256e80f-91f9-40da-865e-578a2aee46ad
Signed-off-by: Dmitry Vyukov <dvyukov@google.com>

---
diff --git a/kernel/bpf/bpf_lru_list.c b/kernel/bpf/bpf_lru_list.c
index e7a2fc605..3d6613378 100644
--- a/kernel/bpf/bpf_lru_list.c
+++ b/kernel/bpf/bpf_lru_list.c
@@ -4,6 +4,7 @@
 #include <linux/cpumask.h>
 #include <linux/spinlock.h>
 #include <linux/percpu.h>
+#include <asm/rqspinlock.h>
 
 #include "bpf_lru_list.h"
 
@@ -307,9 +308,10 @@ static void bpf_lru_list_push_free(struct bpf_lru_list *l,
 	if (WARN_ON_ONCE(IS_LOCAL_LIST_TYPE(node->type)))
 		return;
 
-	raw_spin_lock_irqsave(&l->lock, flags);
+	if (raw_res_spin_lock_irqsave(&l->lock, flags))
+		return;
 	__bpf_lru_node_move(l, node, BPF_LRU_LIST_T_FREE);
-	raw_spin_unlock_irqrestore(&l->lock, flags);
+	raw_res_spin_unlock_irqrestore(&l->lock, flags);
 }
 
 static void bpf_lru_list_pop_free_to_local(struct bpf_lru *lru,
@@ -319,7 +321,8 @@ static void bpf_lru_list_pop_free_to_local(struct bpf_lru *lru,
 	struct bpf_lru_node *node, *tmp_node;
 	unsigned int nfree = 0;
 
-	raw_spin_lock(&l->lock);
+	if (raw_res_spin_lock(&l->lock))
+		return;
 
 	__local_list_flush(l, loc_l);
 
@@ -338,7 +341,7 @@ static void bpf_lru_list_pop_free_to_local(struct bpf_lru *lru,
 				      local_free_list(loc_l),
 				      BPF_LRU_LOCAL_LIST_T_FREE);
 
-	raw_spin_unlock(&l->lock);
+	raw_res_spin_unlock(&l->lock);
 }
 
 static void __local_list_add_pending(struct bpf_lru *lru,
@@ -404,7 +407,8 @@ static struct bpf_lru_node *bpf_percpu_lru_pop_free(struct bpf_lru *lru,
 
 	l = per_cpu_ptr(lru->percpu_lru, cpu);
 
-	raw_spin_lock_irqsave(&l->lock, flags);
+	if (raw_res_spin_lock_irqsave(&l->lock, flags))
+		return NULL;
 
 	__bpf_lru_list_rotate(lru, l);
 
@@ -420,7 +424,7 @@ static struct bpf_lru_node *bpf_percpu_lru_pop_free(struct bpf_lru *lru,
 		__bpf_lru_node_move(l, node, BPF_LRU_LIST_T_INACTIVE);
 	}
 
-	raw_spin_unlock_irqrestore(&l->lock, flags);
+	raw_res_spin_unlock_irqrestore(&l->lock, flags);
 
 	return node;
 }
@@ -437,7 +441,8 @@ static struct bpf_lru_node *bpf_common_lru_pop_free(struct bpf_lru *lru,
 
 	loc_l = per_cpu_ptr(clru->local_list, cpu);
 
-	raw_spin_lock_irqsave(&loc_l->lock, flags);
+	if (raw_res_spin_lock_irqsave(&loc_l->lock, flags))
+		return NULL;
 
 	node = __local_list_pop_free(loc_l);
 	if (!node) {
@@ -448,7 +453,7 @@ static struct bpf_lru_node *bpf_common_lru_pop_free(struct bpf_lru *lru,
 	if (node)
 		__local_list_add_pending(lru, loc_l, cpu, node, hash);
 
-	raw_spin_unlock_irqrestore(&loc_l->lock, flags);
+	raw_res_spin_unlock_irqrestore(&loc_l->lock, flags);
 
 	if (node)
 		return node;
@@ -466,23 +471,26 @@ static struct bpf_lru_node *bpf_common_lru_pop_free(struct bpf_lru *lru,
 	do {
 		steal_loc_l = per_cpu_ptr(clru->local_list, steal);
 
-		raw_spin_lock_irqsave(&steal_loc_l->lock, flags);
+		if (raw_res_spin_lock_irqsave(&steal_loc_l->lock, flags))
+			goto next_steal;
 
 		node = __local_list_pop_free(steal_loc_l);
 		if (!node)
 			node = __local_list_pop_pending(lru, steal_loc_l);
 
-		raw_spin_unlock_irqrestore(&steal_loc_l->lock, flags);
+		raw_res_spin_unlock_irqrestore(&steal_loc_l->lock, flags);
 
+next_steal:
 		steal = cpumask_next_wrap(steal, cpu_possible_mask);
 	} while (!node && steal != first_steal);
 
 	loc_l->next_steal = steal;
 
 	if (node) {
-		raw_spin_lock_irqsave(&loc_l->lock, flags);
+		if (raw_res_spin_lock_irqsave(&loc_l->lock, flags))
+			return NULL;
 		__local_list_add_pending(lru, loc_l, cpu, node, hash);
-		raw_spin_unlock_irqrestore(&loc_l->lock, flags);
+		raw_res_spin_unlock_irqrestore(&loc_l->lock, flags);
 	}
 
 	return node;
@@ -511,10 +519,11 @@ static void bpf_common_lru_push_free(struct bpf_lru *lru,
 
 		loc_l = per_cpu_ptr(lru->common_lru.local_list, node->cpu);
 
-		raw_spin_lock_irqsave(&loc_l->lock, flags);
+		if (raw_res_spin_lock_irqsave(&loc_l->lock, flags))
+			return;
 
 		if (unlikely(node->type != BPF_LRU_LOCAL_LIST_T_PENDING)) {
-			raw_spin_unlock_irqrestore(&loc_l->lock, flags);
+			raw_res_spin_unlock_irqrestore(&loc_l->lock, flags);
 			goto check_lru_list;
 		}
 
@@ -522,7 +531,7 @@ static void bpf_common_lru_push_free(struct bpf_lru *lru,
 		bpf_lru_node_clear_ref(node);
 		list_move(&node->list, local_free_list(loc_l));
 
-		raw_spin_unlock_irqrestore(&loc_l->lock, flags);
+		raw_res_spin_unlock_irqrestore(&loc_l->lock, flags);
 		return;
 	}
 
@@ -538,11 +547,12 @@ static void bpf_percpu_lru_push_free(struct bpf_lru *lru,
 
 	l = per_cpu_ptr(lru->percpu_lru, node->cpu);
 
-	raw_spin_lock_irqsave(&l->lock, flags);
+	if (raw_res_spin_lock_irqsave(&l->lock, flags))
+		return;
 
 	__bpf_lru_node_move(l, node, BPF_LRU_LIST_T_FREE);
 
-	raw_spin_unlock_irqrestore(&l->lock, flags);
+	raw_res_spin_unlock_irqrestore(&l->lock, flags);
 }
 
 void bpf_lru_push_free(struct bpf_lru *lru, struct bpf_lru_node *node)
@@ -625,7 +635,7 @@ static void bpf_lru_locallist_init(struct bpf_lru_locallist *loc_l, int cpu)
 
 	loc_l->next_steal = cpu;
 
-	raw_spin_lock_init(&loc_l->lock);
+	raw_res_spin_lock_init(&loc_l->lock);
 }
 
 static void bpf_lru_list_init(struct bpf_lru_list *l)
@@ -640,7 +650,7 @@ static void bpf_lru_list_init(struct bpf_lru_list *l)
 
 	l->next_inactive_rotation = &l->lists[BPF_LRU_LIST_T_INACTIVE];
 
-	raw_spin_lock_init(&l->lock);
+	raw_res_spin_lock_init(&l->lock);
 }
 
 int bpf_lru_init(struct bpf_lru *lru, bool percpu, u32 hash_offset,
diff --git a/kernel/bpf/bpf_lru_list.h b/kernel/bpf/bpf_lru_list.h
index fe2661a58..ecd93c77a 100644
--- a/kernel/bpf/bpf_lru_list.h
+++ b/kernel/bpf/bpf_lru_list.h
@@ -7,6 +7,7 @@
 #include <linux/cache.h>
 #include <linux/list.h>
 #include <linux/spinlock_types.h>
+#include <asm/rqspinlock.h>
 
 #define NR_BPF_LRU_LIST_T	(3)
 #define NR_BPF_LRU_LIST_COUNT	(2)
@@ -34,13 +35,13 @@ struct bpf_lru_list {
 	/* The next inactive list rotation starts from here */
 	struct list_head *next_inactive_rotation;
 
-	raw_spinlock_t lock ____cacheline_aligned_in_smp;
+	rqspinlock_t lock ____cacheline_aligned_in_smp;
 };
 
 struct bpf_lru_locallist {
 	struct list_head lists[NR_BPF_LRU_LOCAL_LIST_T];
 	u16 next_steal;
-	raw_spinlock_t lock;
+	rqspinlock_t lock;
 };
 
 struct bpf_common_lru {


base-commit: 5d6919055dec134de3c40167a490f33c74c12581
-- 
See  for more information.
