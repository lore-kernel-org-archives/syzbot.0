Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8B62738C2A5
	for <syzbot@lists.linux.dev>; Fri, 22 May 2026 16:49:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779468574; cv=none; b=SEI/HZo+fvdyc6UTUB5VSJOhyljPMmjhh0LsIuZ2FnHyLmZT0PGSh7AFW00C9chMS6QY2vov9V18Udc4OMxcBdy11og9xOUY5x2jyhaiIoNnFuKtZfam6aSVVqkVL58oLfm9laJPNrO00rLbpFU/NKQdzAq9UGbix/mZd5ULnmM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779468574; c=relaxed/simple;
	bh=ehveq2SpDMYFqT8LIQF0FEFoVY8QG6ASkAt3k5I2NFo=;
	h=From:To:Cc:Subject:Message-ID:MIME-Version:Content-Type:Date; b=Gd7q4iHqme1ACaboZY/Z5vAcc3GYq4p3C1kINEE+lr4BSkg2gKcCDPETQFl4F8hFV8c1HyMdHUowOiUzxDOcpIce7IdpVFHoAaIERqnB5ocKKD9Yz8TlbgHX/m1ZpbyiKk1grqY8J1Yk+5tE4ZIlvpOB4SHU7iaAEC3gCWu+7DI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=c6Afa1tM; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="c6Afa1tM"
Received: by smtp.kernel.org (Postfix) with UTF8SMTPSA id 32F6D1F000E9;
	Fri, 22 May 2026 16:49:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1779468572;
	bh=PqA0hIh7u5zorA4ucISCaNVitxM8yQO5ZL6AlE2Zujo=;
	h=From:To:Cc:Subject:Date;
	b=c6Afa1tMFhiCekY9svGaO/fNx38QLg61DVemMcmRQXTKBbuCkGaCA/yt1EFjWt7pD
	 KCZp+CSbb7yVXTXfVtoS8HD/Uisr8TCKOP4GTp7sWZqEfY06x21Xm9SA2NqRnp2TK+
	 mjwoxkvi8XgiYA1bmZtVtjPRY/se7egvQW3J0aHmOv9a9HpY7ZIJy2BpBB/fcY1Fc/
	 y3v6P0aoCkp/HDfy8u2R5xhxylKyVNIOMlpL6GfPBXrwXOur6Ii15OiIQ5JpBkECC4
	 trAg71NZnWLSr6ZxYEQNcN0QMk78nl4nv70GpfPHvE305PsQWmuQyYlPGJb4OL1Vnb
	 5Osi9gOR0V82Q==
From: "syzbot" <syzbot@kernel.org>
To: syzkaller-upstream-moderation@googlegroups.com
Cc: syzbot@lists.linux.dev
Subject: [PATCH RFC v2] bpf: Convert bpf_lru_list locks to rqspinlock
Message-ID: <fb104cfc-a3b3-4cc6-819a-a5f09aa97ecd@mail.kernel.org>
Precedence: bulk
X-Mailing-List: syzbot@lists.linux.dev
List-Id: <syzbot.lists.linux.dev>
List-Subscribe: <mailto:syzbot+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:syzbot+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Date: Fri, 22 May 2026 16:49:32 +0000 (UTC)

Lockdep reports an inconsistent lock state ({INITIAL USE} -> {IN-NMI})
for the loc_l->lock in the BPF LRU list implementation. This occurs
because the lock is first acquired in a normal syscall context (e.g.,
during BPF_MAP_UPDATE_BATCH) and later attempted to be acquired in an
NMI context (e.g., when a hardware breakpoint triggers a perf event that
executes a BPF program).

While lockdep correctly identifies that raw_spinlock_t is not NMI-safe,
this specific deadlock is prevented in practice by the bpf_prog_active
counter. If an NMI interrupts a map operation, the NMI handler checks
bpf_prog_active and skips executing the BPF program, preventing it from
acquiring the already-held lock. However, lockdep is unaware of this
protection mechanism, leading to a false positive.

To resolve this false positive and provide robust deadlock prevention,
convert the raw_spinlock_t locks in bpf_lru_list to rqspinlock_t
(resilient queued spinlock), similar to the conversion previously done
for hashtab.c. The rqspinlock infrastructure is designed to return an
error instead of deadlocking and is invisible to lockdep.

With this conversion, raw_spin_lock_irqsave() is replaced with
raw_res_spin_lock_irqsave(). If the lock cannot be acquired during pop
operations, the functions gracefully return NULL, which propagates as
-ENOMEM to the BPF program. In push operations, the functions simply
return, effectively dropping the node, as leaking the preallocated
element is an acceptable trade-off to avoid a hard deadlock in NMI
context.

Fixes: 4fa8d68aa53e ("bpf: Convert hashtab.c to rqspinlock")
Assisted-by: Gemini:gemini-3.1-pro-preview Gemini:gemini-3-flash-preview syzbot
Reported-by: syzbot+c69a0a2c816716f1e0d5@syzkaller.appspotmail.com
Closes: https://syzkaller.appspot.com/bug?extid=c69a0a2c816716f1e0d5
Link: https://syzkaller.appspot.com/ai_job?id=9f9ed48b-dcf3-4a02-bdec-27f50787f4e2
To: "Andrii Nakryiko" <andrii@kernel.org>
To: "Alexei Starovoitov" <ast@kernel.org>
To: <bpf@vger.kernel.org>
To: "Daniel Borkmann" <daniel@iogearbox.net>
To: "Eduard Zingerman" <eddyz87@gmail.com>
To: "Martin KaFai Lau" <martin.lau@linux.dev>
To: "Kumar Kartikeya Dwivedi" <memxor@gmail.com>
Cc: "Jiri Olsa" <jolsa@kernel.org>
Cc: <linux-kernel@vger.kernel.org>
Cc: "Song Liu" <song@kernel.org>
Cc: "Yonghong Song" <yonghong.song@linux.dev>

---
v2:
- Added comments explaining the failure paths when rqspinlock acquisition fails.
- Added <asm/rqspinlock.h> include to bpf_lru_list.c.

v1:
https://lore.kernel.org/all/4c0d4f36-c99b-4235-801d-e9a27dfa6c8e@mail.kernel.org/T/
---
diff --git a/kernel/bpf/bpf_lru_list.c b/kernel/bpf/bpf_lru_list.c
index e7a2fc605..49f4639db 100644
--- a/kernel/bpf/bpf_lru_list.c
+++ b/kernel/bpf/bpf_lru_list.c
@@ -4,6 +4,7 @@
 #include <linux/cpumask.h>
 #include <linux/spinlock.h>
 #include <linux/percpu.h>
+#include <asm/rqspinlock.h>
 
 #include "bpf_lru_list.h"
 
@@ -307,9 +308,18 @@ static void bpf_lru_list_push_free(struct bpf_lru_list *l,
 	if (WARN_ON_ONCE(IS_LOCAL_LIST_TYPE(node->type)))
 		return;
 
-	raw_spin_lock_irqsave(&l->lock, flags);
+	if (raw_res_spin_lock_irqsave(&l->lock, flags)) {
+		/*
+		 * If the lock is contended, it means we are in an NMI context
+		 * and the lock is already held by the interrupted context.
+		 * In this case, we prefer to leak the node rather than
+		 * deadlocking the system. The node will be lost from the LRU
+		 * list, but the memory is still in the map's preallocated array.
+		 */
+		return;
+	}
 	__bpf_lru_node_move(l, node, BPF_LRU_LIST_T_FREE);
-	raw_spin_unlock_irqrestore(&l->lock, flags);
+	raw_res_spin_unlock_irqrestore(&l->lock, flags);
 }
 
 static void bpf_lru_list_pop_free_to_local(struct bpf_lru *lru,
@@ -319,7 +329,16 @@ static void bpf_lru_list_pop_free_to_local(struct bpf_lru *lru,
 	struct bpf_lru_node *node, *tmp_node;
 	unsigned int nfree = 0;
 
-	raw_spin_lock(&l->lock);
+	if (raw_res_spin_lock(&l->lock)) {
+		/*
+		 * If the lock is contended, it means we are in an NMI context
+		 * and the lock is already held by the interrupted context.
+		 * We prefer to fail the flush/pop operation rather than
+		 * deadlocking. The caller will try to steal from other CPUs
+		 * or return NULL, which will fail the map update.
+		 */
+		return;
+	}
 
 	__local_list_flush(l, loc_l);
 
@@ -338,7 +357,7 @@ static void bpf_lru_list_pop_free_to_local(struct bpf_lru *lru,
 				      local_free_list(loc_l),
 				      BPF_LRU_LOCAL_LIST_T_FREE);
 
-	raw_spin_unlock(&l->lock);
+	raw_res_spin_unlock(&l->lock);
 }
 
 static void __local_list_add_pending(struct bpf_lru *lru,
@@ -404,7 +423,15 @@ static struct bpf_lru_node *bpf_percpu_lru_pop_free(struct bpf_lru *lru,
 
 	l = per_cpu_ptr(lru->percpu_lru, cpu);
 
-	raw_spin_lock_irqsave(&l->lock, flags);
+	if (raw_res_spin_lock_irqsave(&l->lock, flags)) {
+		/*
+		 * If the lock is contended, it means we are in an NMI context
+		 * and the lock is already held by the interrupted context.
+		 * We prefer to fail the pop operation rather than deadlocking.
+		 * Returning NULL will fail the map update.
+		 */
+		return NULL;
+	}
 
 	__bpf_lru_list_rotate(lru, l);
 
@@ -420,7 +447,7 @@ static struct bpf_lru_node *bpf_percpu_lru_pop_free(struct bpf_lru *lru,
 		__bpf_lru_node_move(l, node, BPF_LRU_LIST_T_INACTIVE);
 	}
 
-	raw_spin_unlock_irqrestore(&l->lock, flags);
+	raw_res_spin_unlock_irqrestore(&l->lock, flags);
 
 	return node;
 }
@@ -437,7 +464,15 @@ static struct bpf_lru_node *bpf_common_lru_pop_free(struct bpf_lru *lru,
 
 	loc_l = per_cpu_ptr(clru->local_list, cpu);
 
-	raw_spin_lock_irqsave(&loc_l->lock, flags);
+	if (raw_res_spin_lock_irqsave(&loc_l->lock, flags)) {
+		/*
+		 * If the lock is contended, it means we are in an NMI context
+		 * and the lock is already held by the interrupted context.
+		 * We prefer to fail the pop operation rather than deadlocking.
+		 * Returning NULL will fail the map update.
+		 */
+		return NULL;
+	}
 
 	node = __local_list_pop_free(loc_l);
 	if (!node) {
@@ -448,7 +483,7 @@ static struct bpf_lru_node *bpf_common_lru_pop_free(struct bpf_lru *lru,
 	if (node)
 		__local_list_add_pending(lru, loc_l, cpu, node, hash);
 
-	raw_spin_unlock_irqrestore(&loc_l->lock, flags);
+	raw_res_spin_unlock_irqrestore(&loc_l->lock, flags);
 
 	if (node)
 		return node;
@@ -466,13 +501,22 @@ static struct bpf_lru_node *bpf_common_lru_pop_free(struct bpf_lru *lru,
 	do {
 		steal_loc_l = per_cpu_ptr(clru->local_list, steal);
 
-		raw_spin_lock_irqsave(&steal_loc_l->lock, flags);
+		if (raw_res_spin_lock_irqsave(&steal_loc_l->lock, flags)) {
+			/*
+			 * If the lock is contended, it means we are in an NMI
+			 * context and the lock is already held by the
+			 * interrupted context. We prefer to skip this CPU
+			 * and try the next one rather than deadlocking.
+			 */
+			steal = cpumask_next_wrap(steal, cpu_possible_mask);
+			continue;
+		}
 
 		node = __local_list_pop_free(steal_loc_l);
 		if (!node)
 			node = __local_list_pop_pending(lru, steal_loc_l);
 
-		raw_spin_unlock_irqrestore(&steal_loc_l->lock, flags);
+		raw_res_spin_unlock_irqrestore(&steal_loc_l->lock, flags);
 
 		steal = cpumask_next_wrap(steal, cpu_possible_mask);
 	} while (!node && steal != first_steal);
@@ -480,9 +524,17 @@ static struct bpf_lru_node *bpf_common_lru_pop_free(struct bpf_lru *lru,
 	loc_l->next_steal = steal;
 
 	if (node) {
-		raw_spin_lock_irqsave(&loc_l->lock, flags);
+		if (raw_res_spin_lock_irqsave(&loc_l->lock, flags)) {
+			/*
+			 * If the lock is contended, we prefer to leak the node
+			 * rather than deadlocking. The node will be lost from
+			 * the LRU list, but the memory is still in the map's
+			 * preallocated array.
+			 */
+			return NULL;
+		}
 		__local_list_add_pending(lru, loc_l, cpu, node, hash);
-		raw_spin_unlock_irqrestore(&loc_l->lock, flags);
+		raw_res_spin_unlock_irqrestore(&loc_l->lock, flags);
 	}
 
 	return node;
@@ -511,10 +563,20 @@ static void bpf_common_lru_push_free(struct bpf_lru *lru,
 
 		loc_l = per_cpu_ptr(lru->common_lru.local_list, node->cpu);
 
-		raw_spin_lock_irqsave(&loc_l->lock, flags);
+		if (raw_res_spin_lock_irqsave(&loc_l->lock, flags)) {
+			/*
+			 * If the lock is contended, it means we are in an NMI
+			 * context and the lock is already held by the
+			 * interrupted context. We prefer to leak the node
+			 * rather than deadlocking. The node will be lost from
+			 * the LRU list, but the memory is still in the map's
+			 * preallocated array.
+			 */
+			return;
+		}
 
 		if (unlikely(node->type != BPF_LRU_LOCAL_LIST_T_PENDING)) {
-			raw_spin_unlock_irqrestore(&loc_l->lock, flags);
+			raw_res_spin_unlock_irqrestore(&loc_l->lock, flags);
 			goto check_lru_list;
 		}
 
@@ -522,7 +584,7 @@ static void bpf_common_lru_push_free(struct bpf_lru *lru,
 		bpf_lru_node_clear_ref(node);
 		list_move(&node->list, local_free_list(loc_l));
 
-		raw_spin_unlock_irqrestore(&loc_l->lock, flags);
+		raw_res_spin_unlock_irqrestore(&loc_l->lock, flags);
 		return;
 	}
 
@@ -538,11 +600,20 @@ static void bpf_percpu_lru_push_free(struct bpf_lru *lru,
 
 	l = per_cpu_ptr(lru->percpu_lru, node->cpu);
 
-	raw_spin_lock_irqsave(&l->lock, flags);
+	if (raw_res_spin_lock_irqsave(&l->lock, flags)) {
+		/*
+		 * If the lock is contended, it means we are in an NMI context
+		 * and the lock is already held by the interrupted context.
+		 * We prefer to leak the node rather than deadlocking. The node
+		 * will be lost from the LRU list, but the memory is still in
+		 * the map's preallocated array.
+		 */
+		return;
+	}
 
 	__bpf_lru_node_move(l, node, BPF_LRU_LIST_T_FREE);
 
-	raw_spin_unlock_irqrestore(&l->lock, flags);
+	raw_res_spin_unlock_irqrestore(&l->lock, flags);
 }
 
 void bpf_lru_push_free(struct bpf_lru *lru, struct bpf_lru_node *node)
@@ -625,7 +696,7 @@ static void bpf_lru_locallist_init(struct bpf_lru_locallist *loc_l, int cpu)
 
 	loc_l->next_steal = cpu;
 
-	raw_spin_lock_init(&loc_l->lock);
+	raw_res_spin_lock_init(&loc_l->lock);
 }
 
 static void bpf_lru_list_init(struct bpf_lru_list *l)
@@ -640,7 +711,7 @@ static void bpf_lru_list_init(struct bpf_lru_list *l)
 
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
