Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AE9FD3C769F
	for <syzbot@lists.linux.dev>; Fri, 22 May 2026 10:08:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779444484; cv=none; b=udnl8TGdiUzw8sL0xjbTQgMbom9MUZkJasv1v4ki9c8kKHy+qw2GulRYGJzscq0or9ioEgCkXvhiauVKHxr8QnQxIaR62vTTuylfb9SS8mRsqbi8x948/mamQsX2HnR/9GBN/Si+C1odTKRNDtsCFVRz7UuemWepcYA1ZO18jGw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779444484; c=relaxed/simple;
	bh=JDnITGFCJxx5vFqzBdGYju80O/aXSjD0o3ghNLILrZo=;
	h=From:To:Cc:Subject:Message-ID:MIME-Version:Content-Type:Date; b=X/HPWg/M7o77cNwLuSCsLjjDF6M+BfIJxWzKItM4QePpfn6/Ko86GB1SQGzqv8zqnWKYq6F/TNWFZVmovi/2vTL2INXB4Q0K8sybnCbwk/ebFteRLhoJhA8804MTH++cPLVfPhrPEJAHvlhxVyN7fKjDmDHxt10DyjBE/N05tcw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=iOrmXq/m; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="iOrmXq/m"
Received: by smtp.kernel.org (Postfix) with UTF8SMTPSA id 3E9F41F000E9;
	Fri, 22 May 2026 10:08:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1779444482;
	bh=o0pSaiKnSJl/1tuRgP5d+qg5azQY01ZC+aR7R6TLf8Q=;
	h=From:To:Cc:Subject:Date;
	b=iOrmXq/mCy1uiNTlyurkXWYWkOkKnN8QVyxXNCvCRItAXADPV9dkoKuF7RvgIDv62
	 94G5M4GWta6O5UCpcxJrlqNki8XaamWfZ0Eoo9j14MYAQaZ/9FGd+fUrdIoGty89HC
	 enOyiuQbeG70vp/MvLFuoEBdZk2RseAdf8G6qZvCzevxdtSbN1E8TGMovSDUoZp4vq
	 JfiJfHTsnBP7gvjprToKQ87yXTQFul6VqLE8HMRys2YG6oJfYFepgTUxozuC7THVfv
	 if/bsAxEZ8+Xkbr3jbFeS/L1usmbUZwMgfukMf422USJpqCEtA747ti3fi0MtFBZOs
	 vOP7MfcM8Ig9A==
From: "syzbot" <syzbot@kernel.org>
To: syzkaller-upstream-moderation@googlegroups.com
Cc: syzbot@lists.linux.dev
Subject: [PATCH RFC] bpf: Convert bpf_lru_list locks to rqspinlock
Message-ID: <4c0d4f36-c99b-4235-801d-e9a27dfa6c8e@mail.kernel.org>
Precedence: bulk
X-Mailing-List: syzbot@lists.linux.dev
List-Id: <syzbot.lists.linux.dev>
List-Subscribe: <mailto:syzbot+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:syzbot+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Date: Fri, 22 May 2026 10:08:02 +0000 (UTC)

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
Assisted-by: Gemini:gemini-3.1-pro-preview syzbot
Reported-by: syzbot+c69a0a2c816716f1e0d5@syzkaller.appspotmail.com
Closes: https://syzkaller.appspot.com/bug?extid=c69a0a2c816716f1e0d5
Link: https://syzkaller.appspot.com/ai_job?id=5c92fef7-50da-4f0f-9ce0-5870752f09b4
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
diff --git a/kernel/bpf/bpf_lru_list.c b/kernel/bpf/bpf_lru_list.c
index e7a2fc605..722b4a009 100644
--- a/kernel/bpf/bpf_lru_list.c
+++ b/kernel/bpf/bpf_lru_list.c
@@ -307,9 +307,10 @@ static void bpf_lru_list_push_free(struct bpf_lru_list *l,
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
@@ -319,7 +320,8 @@ static void bpf_lru_list_pop_free_to_local(struct bpf_lru *lru,
 	struct bpf_lru_node *node, *tmp_node;
 	unsigned int nfree = 0;
 
-	raw_spin_lock(&l->lock);
+	if (raw_res_spin_lock(&l->lock))
+		return;
 
 	__local_list_flush(l, loc_l);
 
@@ -338,7 +340,7 @@ static void bpf_lru_list_pop_free_to_local(struct bpf_lru *lru,
 				      local_free_list(loc_l),
 				      BPF_LRU_LOCAL_LIST_T_FREE);
 
-	raw_spin_unlock(&l->lock);
+	raw_res_spin_unlock(&l->lock);
 }
 
 static void __local_list_add_pending(struct bpf_lru *lru,
@@ -404,7 +406,8 @@ static struct bpf_lru_node *bpf_percpu_lru_pop_free(struct bpf_lru *lru,
 
 	l = per_cpu_ptr(lru->percpu_lru, cpu);
 
-	raw_spin_lock_irqsave(&l->lock, flags);
+	if (raw_res_spin_lock_irqsave(&l->lock, flags))
+		return NULL;
 
 	__bpf_lru_list_rotate(lru, l);
 
@@ -420,7 +423,7 @@ static struct bpf_lru_node *bpf_percpu_lru_pop_free(struct bpf_lru *lru,
 		__bpf_lru_node_move(l, node, BPF_LRU_LIST_T_INACTIVE);
 	}
 
-	raw_spin_unlock_irqrestore(&l->lock, flags);
+	raw_res_spin_unlock_irqrestore(&l->lock, flags);
 
 	return node;
 }
@@ -437,7 +440,8 @@ static struct bpf_lru_node *bpf_common_lru_pop_free(struct bpf_lru *lru,
 
 	loc_l = per_cpu_ptr(clru->local_list, cpu);
 
-	raw_spin_lock_irqsave(&loc_l->lock, flags);
+	if (raw_res_spin_lock_irqsave(&loc_l->lock, flags))
+		return NULL;
 
 	node = __local_list_pop_free(loc_l);
 	if (!node) {
@@ -448,7 +452,7 @@ static struct bpf_lru_node *bpf_common_lru_pop_free(struct bpf_lru *lru,
 	if (node)
 		__local_list_add_pending(lru, loc_l, cpu, node, hash);
 
-	raw_spin_unlock_irqrestore(&loc_l->lock, flags);
+	raw_res_spin_unlock_irqrestore(&loc_l->lock, flags);
 
 	if (node)
 		return node;
@@ -466,13 +470,16 @@ static struct bpf_lru_node *bpf_common_lru_pop_free(struct bpf_lru *lru,
 	do {
 		steal_loc_l = per_cpu_ptr(clru->local_list, steal);
 
-		raw_spin_lock_irqsave(&steal_loc_l->lock, flags);
+		if (raw_res_spin_lock_irqsave(&steal_loc_l->lock, flags)) {
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
@@ -480,9 +487,10 @@ static struct bpf_lru_node *bpf_common_lru_pop_free(struct bpf_lru *lru,
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
