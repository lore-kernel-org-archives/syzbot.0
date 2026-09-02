Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6120B443E4D
	for <syzbot@lists.linux.dev>; Wed,  2 Sep 2026 23:34:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788392079; cv=none; b=DOy9NLzA88I21bwW/q+93wzDKhLz/EAseW5GtFjtGuOEUvTc0YdCFtrkEjmk013TQ1v+WcwOS7JzSDpy8nyXiiORWE7v+E80ewJRbQH1nfeoNrGDK2/FbbdtW3CpfggRtCx1yTaRtE0IFe5EWac9EhYav8nFFWiY+5cbw7fpb8c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788392079; c=relaxed/simple;
	bh=G2esCXcc0JQL8iwmUEEeYSZfwxW9dcRc011QMjo2/7o=;
	h=From:To:Cc:Subject:Message-ID:MIME-Version:Content-Type:Date; b=dnOh/+sAMtIedWx3G8ZsTaIVrB0BAfZlA4tldzxvzWm0bWWnU1ozGmn2Q3Kcx/iX+xzDy5H0FL+XsnmEvEfSBv5bZm5HN8bus1KLAzNz32gcSyLU06TcaEAuU2yTxK1ghIoE9hBxPCeeQQ6qGtKS3DPWZyLKagdHLXmZUN0DccA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=NzCkMGSJ; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="NzCkMGSJ"
Received: by smtp.kernel.org (Postfix) with UTF8SMTPSA id 3D2111F000E9;
	Wed,  2 Sep 2026 23:34:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788392074;
	bh=Gwd1ydndNyGi1shSLDAUjXr7+7tVy9d7vxobkn60nvU=;
	h=From:To:Cc:Subject:Date;
	b=NzCkMGSJMPF7JFjbNwPpcFnr1szGlV/SI5qQCC0x27Jg9BcpWMN4Q6eUbwpLae85u
	 RXwSBsnRNk1w6pe7D0nLKVn50DrAaVzxu3mZE/0h6KOV0kArh/Tdp+9zVLxZC12AUI
	 r6YdVOYqecNB9lYB64p6zVQT/IbJ++5DB2p0Qm8a9MsEG2ip/v3PxI0vKQ96F7J6T0
	 Ppm3ZPbC4ZWXzb9G42yRbkPQdN57AbAdWj0Ngq8Qx6o2GgAzhI9kWvYOTavcQLuf9Y
	 yvtsm+A4TQ8RWmK/X8q7W3v+wv7T1QiglluS0cJ7TLYp02JDMQowcpJHXU7A/uTxkN
	 YWFJrcgTE/wBQ==
From: "syzbot" <syzbot@kernel.org>
To: syzkaller-upstream-moderation@googlegroups.com
Cc: syzbot@lists.linux.dev
Subject: [PATCH RFC] locking/lockdep: Avoid redundant BFS checks in check_prev_add()
Message-ID: <78c47b3e-4fb2-4dcc-9d9a-3d255f900b44@mail.kernel.org>
Precedence: bulk
X-Mailing-List: syzbot@lists.linux.dev
List-Id: <syzbot.lists.linux.dev>
List-Subscribe: <mailto:syzbot+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:syzbot+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Date: Wed,  2 Sep 2026 23:34:34 +0000 (UTC)

When a new lock chain is encountered (such as when a timer interrupt occurs
while holding a dynamically allocated workqueue lockdep map during
workqueue destruction), validate_chain() calls check_prevs_add() and
check_prev_add() to validate the locks held in the chain.

In check_prev_add(), lockdep previously performed expensive BFS graph
traversals (check_noncircular() and check_irq_usage()) before checking
whether the <prev> -> <next> dependency already existed in
hlock_class(prev)->locks_after. For heavily used core locks such as
cpu_base->lock (the hrtimer base lock), which have thousands of backward
dependencies across the kernel, traversing the backward dependency graph
during check_irq_usage() can exceed MAX_CIRCULAR_QUEUE_SIZE (1UL <<
CONFIG_LOCKDEP_CIRCULAR_QUEUE_BITS), triggering a BFS queue overflow
warning:

lockdep bfs error:-1
WARNING: kernel/locking/lockdep.c:2075 at print_bfs_bug+0x20/0x40
Call Trace:
 <TASK>
 check_irq_usage kernel/locking/lockdep.c:-1 [inline]
 check_prev_add kernel/locking/lockdep.c:3185 [inline]
 check_prevs_add kernel/locking/lockdep.c:3300 [inline]
 validate_chain kernel/locking/lockdep.c:3924 [inline]
 __lock_acquire+0x262d/0x2e50 kernel/locking/lockdep.c:5254
 lock_acquire+0x115/0x350 kernel/locking/lockdep.c:5908
 seqcount_lockdep_reader_access+0x55/0x100 include/linux/seqlock.h:73
 ktime_expiry_to_cycles+0x4e/0x1e0 kernel/time/timekeeping.c:941
 clockevents_program_event+0x199/0x630 kernel/time/clockevents.c:360
 __hrtimer_rearm_deferred+0x36c/0x4b0 kernel/time/hrtimer.c:2189
 irqentry_exit+0x8d3/0x910 kernel/entry/common.c:167
 asm_sysvec_apic_timer_interrupt+0x1a/0x20
 arch/x86/include/asm/idtentry.h:674
 touch_wq_lockdep_map+0xcb/0x180 kernel/workqueue.c:4102
 __flush_workqueue+0x148/0x1470 kernel/workqueue.c:4144
 destroy_workqueue+0xbb/0xc60 kernel/workqueue.c:6146
 </TASK>

Because an existing <prev> -> <next> dependency was already validated for
circular deadlocks and IRQ usage conflicts when it was originally inserted
into the graph (and subsequent IRQ state changes dynamically trigger
validations in mark_lock_irq()), repeating full BFS traversals for every
new lock chain containing that dependency is redundant and can cause
spurious BFS queue overflows.

Fix this by inspecting hlock_class(prev)->locks_after before executing BFS
graph traversals in check_prev_add():

1. If the <prev> -> <next> dependency is already present and covers the
requested dependency bits (entry->dep & calc_dep(prev, next)), update the
distance and the reverse dependency entry in locks_before and return
immediately, skipping redundant BFS traversals.
2. If the dependency is present but introduces new dependency bits, record
the target entry, run check_noncircular() and check_irq_usage() for the new
dependency bits, and update the existing entries in place.
3. If the dependency is not present in locks_after, proceed with full BFS
validation and dependency insertion as before.

Fixes: fbb9ce9530fd ("[PATCH] lockdep: core")
Assisted-by: Gemini:gemini-3.7-flash Gemini:gemini-3.1-pro-preview syzbot
Reported-by: syzbot+085adc3f91549d11066a@syzkaller.appspotmail.com
Closes: https://syzkaller.appspot.com/bug?extid=085adc3f91549d11066a
Link: https://syzkaller.appspot.com/ai_job?id=17926c9a-f772-43b3-ae90-c5fa5b0275a0
To: "Boqun Feng" <boqun@kernel.org>
To: <linux-kernel@vger.kernel.org>
To: "Ingo Molnar" <mingo@redhat.com>
To: "Peter Zijlstra" <peterz@infradead.org>
To: "Will Deacon" <will@kernel.org>
To: "Ingo Molnar" <mingo@elte.hu>
Cc: "Waiman Long" <longman@redhat.com>

---
diff --git a/kernel/locking/lockdep.c b/kernel/locking/lockdep.c
index c56a7f91d..4307410d9 100644
--- a/kernel/locking/lockdep.c
+++ b/kernel/locking/lockdep.c
@@ -3140,6 +3140,7 @@ check_prev_add(struct task_struct *curr, struct held_lock *prev,
 	       struct lock_trace **const trace)
 {
 	struct lock_list *entry;
+	struct lock_list *target_entry = NULL;
 	enum bfs_result ret;
 
 	if (!hlock_class(prev)->key || !hlock_class(next)->key) {
@@ -3168,6 +3169,40 @@ check_prev_add(struct task_struct *curr, struct held_lock *prev,
 			return 2;
 	}
 
+	/*
+	 * Is the <prev> -> <next> dependency already present?
+	 *
+	 * (this may occur even though this is a new chain: consider
+	 *  e.g. the L1 -> L2 -> L3 -> L4 and the L5 -> L1 -> L2 -> L3
+	 *  chains - the second one will be new, but L1 already has
+	 *  L2 added to its dependency list, due to the first chain.)
+	 */
+	list_for_each_entry(entry, &hlock_class(prev)->locks_after, entry) {
+		if (entry->class == hlock_class(next)) {
+			if (distance == 1)
+				entry->distance = 1;
+			if (entry->dep & calc_dep(prev, next)) {
+				/*
+				 * Also, update the reverse dependency in @next's
+				 * ->locks_before list.
+				 */
+				list_for_each_entry(entry, &hlock_class(next)->locks_before,
+						    entry) {
+					if (entry->class == hlock_class(prev)) {
+						if (distance == 1)
+							entry->distance = 1;
+						return 1;
+					}
+				}
+
+				/* <prev> is not found in <next>::locks_before */
+				return 0;
+			}
+			target_entry = entry;
+			break;
+		}
+	}
+
 	/*
 	 * Prove that the new <prev> -> <next> dependency would not
 	 * create a circular dependency in the graph. (We do this by
@@ -3185,48 +3220,19 @@ check_prev_add(struct task_struct *curr, struct held_lock *prev,
 	if (!check_irq_usage(curr, prev, next))
 		return 0;
 
-	/*
-	 * Is the <prev> -> <next> dependency already present?
-	 *
-	 * (this may occur even though this is a new chain: consider
-	 *  e.g. the L1 -> L2 -> L3 -> L4 and the L5 -> L1 -> L2 -> L3
-	 *  chains - the second one will be new, but L1 already has
-	 *  L2 added to its dependency list, due to the first chain.)
-	 */
-	list_for_each_entry(entry, &hlock_class(prev)->locks_after, entry) {
-		if (entry->class == hlock_class(next)) {
-			if (distance == 1)
-				entry->distance = 1;
-			entry->dep |= calc_dep(prev, next);
-
-			/*
-			 * Also, update the reverse dependency in @next's
-			 * ->locks_before list.
-			 *
-			 *  Here we reuse @entry as the cursor, which is fine
-			 *  because we won't go to the next iteration of the
-			 *  outer loop:
-			 *
-			 *  For normal cases, we return in the inner loop.
-			 *
-			 *  If we fail to return, we have inconsistency, i.e.
-			 *  <prev>::locks_after contains <next> while
-			 *  <next>::locks_before doesn't contain <prev>. In
-			 *  that case, we return after the inner and indicate
-			 *  something is wrong.
-			 */
-			list_for_each_entry(entry, &hlock_class(next)->locks_before, entry) {
-				if (entry->class == hlock_class(prev)) {
-					if (distance == 1)
-						entry->distance = 1;
-					entry->dep |= calc_depb(prev, next);
-					return 1;
-				}
+	if (target_entry) {
+		target_entry->dep |= calc_dep(prev, next);
+		list_for_each_entry(entry, &hlock_class(next)->locks_before, entry) {
+			if (entry->class == hlock_class(prev)) {
+				if (distance == 1)
+					entry->distance = 1;
+				entry->dep |= calc_depb(prev, next);
+				return 1;
 			}
-
-			/* <prev> is not found in <next>::locks_before */
-			return 0;
 		}
+
+		/* <prev> is not found in <next>::locks_before */
+		return 0;
 	}
 
 	/*


base-commit: cee9395acd8043be0644b25c34bfa86623f2b935
-- 
This is an AI-generated patch subject to moderation.
Reply with '#syz upstream' to Sign-off the patch as a human author
and send it to the upstream kernel mailing lists.
Reply with '#syz reject' to reject it ('#syz unreject' to undo).

See https://goo.gle/syzbot-ai-patches for information about AI-generated patches.
You can comment on the patch as usual, syzbot will try to address
the comments and send a new version of the patch if necessary.
syzbot engineers can be reached at syzkaller@googlegroups.com.
