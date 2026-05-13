Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 190AB221DB6
	for <syzbot@lists.linux.dev>; Wed, 13 May 2026 22:38:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778711890; cv=none; b=KQGC441Kiw9w1ePoo5o8Cm/Pk3GrvS92Nb4HnvyW2AyzHIYscOQGcDuo2lJHPoTHITxrG4zqu8RAVxAsIsBdeoFF54M97lhLQoUFY2CilFg8tgVaTKkVKOSzPM+B9qOHvOwmCo6apgECpjhJETxsnLnjy/1StEJXCwDgn86BFk8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778711890; c=relaxed/simple;
	bh=JLgGwkX8Wve3SB4NXSsv7YDKs/IhJZcrN1jRqJMESCo=;
	h=From:To:Cc:Subject:Message-ID:MIME-Version:Content-Type:Date; b=sZ89fNzStpSRbx7BxzQH74RmNwkU2JaSzthuLFpXZ3j+3h/QDovudf3ioA8B/QvAgwDNb+JOC2OTIoXYzOtBZXipns1ECKr33XaZ7xH6UK4ONLAtxR4Ig4j/+CxCe6MQZfA5jfavbdcTgGpiAL3nt2FUzY/mwMziRdHxzvSyHdg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=AmHovzIU; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="AmHovzIU"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CE13AC19425;
	Wed, 13 May 2026 22:38:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1778711889;
	bh=JLgGwkX8Wve3SB4NXSsv7YDKs/IhJZcrN1jRqJMESCo=;
	h=From:To:Cc:Subject:Date:From;
	b=AmHovzIUHu4hZGqtB6tkX3Z9o9jlsQTChiyeAwqKbHhIknt1Fcez+B0fXpoliIe7w
	 DWT0UvGVBzWMhtEsSRp8e5aqWo/5AOWP/oFISPPRw6LiKIea50fCNU6ZmPN88wuy84
	 T4ekPfhdiX744jACHDY38YAGZzoKF6T/U1fFLlTgL4XnQFr16kw0+1tWLembfT8Z/J
	 hNcqh+XLbYJbRpfpk2tlwFI99hfit5F5GCo7br2ypDrKkjJpmTDv38f0kokZsoXvPx
	 UFVrmtLV4KNr3e9paNw1nDrnWgG62+RaUcCQaG9IzDqt8uKEIriu/hAMzUpnJysECd
	 fe4jRGwkZurMA==
From: "syzbot" <syzbot@kernel.org>
To: syzkaller-upstream-moderation@googlegroups.com
Cc: syzbot@lists.linux.dev
Subject: [PATCH RFC] bpf: lru: Use resilient spinlocks to prevent NMI deadlocks
Message-ID: <dcebc4bd-5cc1-4dc9-b82b-6cca0fad128b@mail.kernel.org>
Precedence: bulk
X-Mailing-List: syzbot@lists.linux.dev
List-Id: <syzbot.lists.linux.dev>
List-Subscribe: <mailto:syzbot+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:syzbot+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Date: Wed, 13 May 2026 22:38:09 +0000 (UTC)

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
Link: https://syzkaller.appspot.com/ai_job?id=10f0c342-88ea-4f57-a31f-48eff83eae85
To: <bpf@vger.kernel.org>
To: <martin.lau@linux.dev>
Cc: <andrii@kernel.org>
Cc: <ast@kernel.org>
Cc: <daniel@iogearbox.net>
Cc: <eddyz87@gmail.com>
Cc: <jolsa@kernel.org>
Cc: <linux-kernel@vger.kernel.org>
Cc: <memxor@gmail.com>
Cc: <song@kernel.org>
Cc: <yonghong.song@linux.dev>

---
diff --git a/kernel/bpf/bpf_lru_list.c b/kernel/bpf/bpf_lru_list.c
index e7a2fc605..d02c37ca9 100644
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
@@ -466,23 +470,26 @@ static struct bpf_lru_node *bpf_common_lru_pop_free(struct bpf_lru *lru,
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
@@ -511,10 +518,11 @@ static void bpf_common_lru_push_free(struct bpf_lru *lru,
 
 		loc_l = per_cpu_ptr(lru->common_lru.local_list, node->cpu);
 
-		raw_spin_lock_irqsave(&loc_l->lock, flags);
+		if (raw_res_spin_lock_irqsave(&loc_l->lock, flags))
+			return;
 
 		if (unlikely(node->type != BPF_LRU_LOCAL_LIST_T_PENDING)) {
-			raw_spin_unlock_irqrestore(&loc_l->lock, flags);
+			raw_res_spin_unlock_irqrestore(&loc_l->lock, flags);
 			goto check_lru_list;
 		}
 
@@ -522,7 +530,7 @@ static void bpf_common_lru_push_free(struct bpf_lru *lru,
 		bpf_lru_node_clear_ref(node);
 		list_move(&node->list, local_free_list(loc_l));
 
-		raw_spin_unlock_irqrestore(&loc_l->lock, flags);
+		raw_res_spin_unlock_irqrestore(&loc_l->lock, flags);
 		return;
 	}
 
@@ -538,11 +546,12 @@ static void bpf_percpu_lru_push_free(struct bpf_lru *lru,
 
 	l = per_cpu_ptr(lru->percpu_lru, node->cpu);
 
-	raw_spin_lock_irqsave(&l->lock, flags);
+	if (raw_res_spin_lock_irqsave(&l->lock, flags))
+		return;
 
 	__bpf_lru_node_move(l, node, BPF_LRU_LIST_T_FREE);
 
-	raw_spin_unlock_irqrestore(&l->lock, flags);
+	raw_res_spin_unlock_irqrestore(&l->lock, flags);
 }
 
 void bpf_lru_push_free(struct bpf_lru *lru, struct bpf_lru_node *node)
@@ -625,7 +634,7 @@ static void bpf_lru_locallist_init(struct bpf_lru_locallist *loc_l, int cpu)
 
 	loc_l->next_steal = cpu;
 
-	raw_spin_lock_init(&loc_l->lock);
+	raw_res_spin_lock_init(&loc_l->lock);
 }
 
 static void bpf_lru_list_init(struct bpf_lru_list *l)
@@ -640,7 +649,7 @@ static void bpf_lru_list_init(struct bpf_lru_list *l)
 
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
This is an AI-generated patch subject to moderation.
Reply with '#syz upstream' to send it to the mailing list.
Reply with '#syz reject' to reject it.

See  for more information.
