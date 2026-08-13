Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 003E03B05A9
	for <syzbot@lists.linux.dev>; Thu, 13 Aug 2026 05:36:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786599411; cv=none; b=pRGhSYFyPUvI0w/bPyijs3gtFXXapVGqzSICZASaEnz0TLoOQJgb4Q/6GflL1wAB114oILq/4oxZf+EZUqkFvkanRg/UxM6fTg+LLy7CXFr+94eZY6q6kOkxNTgUSc9Qgtc5jED2pIGVg7GrkCLir7vFI+YPOoRv0qqhAEPTlTM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786599411; c=relaxed/simple;
	bh=Pi88CT1kCC6MgguL4FDwv5mop/JAcMLUWSi/v6jl3tc=;
	h=From:To:Cc:Subject:Message-ID:MIME-Version:Content-Type:Date; b=WS0eXH4RNfzHRPydcDpnrK7OyWFSv+otiUQ91f4DmdcjVX3L/gL0d8dMtVm+L9Htuc913boxVvwuwWHK0SoxRy2zb0A/jTQzpBLd8NDMRfFs+TGisvriSesp/5ETMSKvWH8riCzgfIKuMEBvm7FScF/G3jt/T9S33Jda08kGpDk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=ky4LWMQi; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="ky4LWMQi"
Received: by smtp.kernel.org (Postfix) with UTF8SMTPSA id 823D11F000E9;
	Thu, 13 Aug 2026 05:36:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1786599409;
	bh=TLtd+4akl6BsV5mJ5upwfPqmk6r5l/j6MUaFiqpOE7U=;
	h=From:To:Cc:Subject:Date;
	b=ky4LWMQiU2GY1tXO6LwABIfdt8Y4l7JT6sT5fB26n0mwgF8bUuyJ81gmX3Yu0QvUw
	 cKWbXOYuszR1rXxS2WfWPxKinaBxjHMdXyLQqHovssB8GfbMgvziHmn2YNV0Drs9KT
	 SBP6BUkGy8MFUHmLSmUTJ8AMJ3rMA2CYAL0cyf1kaQ/t1zg1s59A4PTxujQ5/tvdYq
	 kT1GDaFKzN5Pcc4vInSjkGVGalN/Xwz/E7A3PGo4Bc+Bg0MVPxdzCHPWsXa2HOqBWt
	 FLliu6qQX4v+5VbdR2sUMBesaU9Qq4LvfDUW6Pv3h6zLYBbpFD45zHjFG++Vv171Fb
	 TaDFNPRsSHzzA==
From: "syzbot" <syzbot@kernel.org>
To: syzkaller-upstream-moderation@googlegroups.com
Cc: liuyongqiang13@huawei.com, syzbot@lists.linux.dev, yaokai34@huawei.com
Subject: [PATCH RFC v4] futex: Fix might_sleep() warning in futex_pivot_pending()
Message-ID: <a8633f4a-42d5-4f87-93a2-9f866cf0a727@mail.kernel.org>
Precedence: bulk
X-Mailing-List: syzbot@lists.linux.dev
List-Id: <syzbot.lists.linux.dev>
List-Subscribe: <mailto:syzbot+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:syzbot+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Date: Thu, 13 Aug 2026 05:36:49 +0000 (UTC)

A recent change modified futex_pivot_pending() to acquire a mutex to fix a
race condition. However, futex_pivot_pending() is evaluated as a condition
inside wait_var_event() in futex_hash_allocate(). Since wait_var_event()
sets the task state to TASK_UNINTERRUPTIBLE before evaluating the
condition, calling a blocking operation like mutex_lock() is invalid and
triggers a might_sleep() warning:

do not call blocking ops when !TASK_RUNNING; state=2 set at
[<ffffffff819e8c8d>] prepare_to_wait_event+0x3dd/0x480
kernel/sched/wait.c:317
WARNING: kernel/sched/core.c:9124 at __might_sleep+0x92/0xf0
kernel/sched/core.c:9120
Call Trace:
 <TASK>
 __mutex_lock_common kernel/locking/mutex.c:623 [inline]
 __mutex_lock+0x118/0x1550 kernel/locking/mutex.c:821
 class_mutex_constructor include/linux/mutex.h:253 [inline]
 futex_pivot_pending kernel/futex/core.c:1789 [inline]
 futex_hash_allocate+0x7fb/0xf00 kernel/futex/core.c:1872
 __do_sys_prctl kernel/sys.c:2885 [inline]
 __se_sys_prctl+0x78c/0x1910 kernel/sys.c:2534

Fix this by reverting futex_pivot_pending() to a lockless implementation
using RCU and memory barriers, which is the idiomatic way to handle
conditions in wait_event loops. By reading the hash pointer first,
executing an smp_rmb() memory barrier, and then reading hash_new, we
leverage the Message Passing (MP) pattern to guarantee correctness without
blocking. This pairs with the rcu_assign_pointer() release barrier in
__futex_pivot_hash(). If the reader sees the new hash, it is guaranteed to
see the cleared hash_new and correctly return true. If the reader sees the
old hash, it will check futex_ref_is_dead(old), which will return true if
the writer has already completed the pivot. The old hash memory is
guaranteed to remain valid for the duration of the check in
futex_ref_is_dead() because futex_pivot_pending() executes within an RCU
read-side critical section and the old hash is freed using kvfree_rcu().
Cc: stable@vger.kernel.org

Fixes: 8e7ff730dd96 ("futex: Fix race in futex_pivot_pending() during private hash resize")
Assisted-by: Gemini:gemini-3.6-flash Gemini:gemini-3.1-pro-preview syzbot
Reported-by: syzbot+350a93852ac854927f45@syzkaller.appspotmail.com
Closes: https://syzkaller.appspot.com/bug?extid=350a93852ac854927f45
Link: https://syzkaller.appspot.com/ai_job?id=095e447b-214a-45ce-8877-7aa877f5d7ff
To: <linux-kernel@vger.kernel.org>
To: "Ingo Molnar" <mingo@redhat.com>
To: "Thomas Gleixner" <tglx@kernel.org>
To: "Yao Kai" <yaokai34@huawei.com>
Cc: =?utf-8?q?Andr=C3=A9_Almeida?= <andrealmeid@igalia.com>
Cc: "Davidlohr Bueso" <dave@stgolabs.net>
Cc: "Darren Hart" <dvhart@infradead.org>
Cc: "Peter Zijlstra" <peterz@infradead.org>

---
v4:
- Removed the blank line before the Cc trailer tag to maintain a contiguous trailer block.

v3:
- Dropped paragraph discussing busy-loop behavior when mutex is contended.
- Added Cc: stable@vger.kernel.org tag.
https://lore.kernel.org/all/6530235e-e9af-4c00-903a-bcbeb2a87efa@mail.kernel.org/T/

v2:
- Use WRITE_ONCE() for stores to hash_new to complement READ_ONCE() in futex_pivot_pending().
https://lore.kernel.org/all/8adeeded-1ded-4780-aed1-739d54729566@mail.kernel.org/T/

v1:
https://lore.kernel.org/all/1f966921-7789-4c70-92cd-ae6c4f8d5be4@mail.kernel.org/T/
---
diff --git a/kernel/futex/core.c b/kernel/futex/core.c
index 128c5752f..e84be5410 100644
--- a/kernel/futex/core.c
+++ b/kernel/futex/core.c
@@ -202,7 +202,7 @@ static bool __futex_pivot_hash(struct mm_struct *mm, struct futex_private_hash *
 	fph = rcu_dereference_protected(mmph->hash, lockdep_is_held(&mmph->lock));
 	if (fph) {
 		if (!futex_ref_is_dead(fph)) {
-			mmph->hash_new = new;
+			WRITE_ONCE(mmph->hash_new, new);
 			return false;
 		}
 
@@ -224,7 +224,7 @@ static void futex_pivot_hash(struct mm_struct *mm)
 
 		fph = mm->futex.phash.hash_new;
 		if (fph) {
-			mm->futex.phash.hash_new = NULL;
+			WRITE_ONCE(mm->futex.phash.hash_new, NULL);
 			__futex_pivot_hash(mm, fph);
 		}
 	}
@@ -1786,12 +1786,18 @@ static bool futex_pivot_pending(struct mm_struct *mm)
 	struct futex_mm_phash *mmph = &mm->futex.phash;
 	struct futex_private_hash *fph;
 
-	guard(mutex)(&mmph->lock);
+	guard(rcu)();
 
-	if (!mmph->hash_new)
+	fph = rcu_dereference(mmph->hash);
+	/*
+	 * Ensure that if we see the new hash, we will also see the cleared
+	 * hash_new pointer. Pairs with rcu_assign_pointer() in
+	 * __futex_pivot_hash().
+	 */
+	smp_rmb();
+	if (!READ_ONCE(mmph->hash_new))
 		return true;
 
-	fph = rcu_dereference_raw(mmph->hash);
 	return futex_ref_is_dead(fph);
 }
 
@@ -1879,7 +1885,7 @@ static int futex_hash_allocate(unsigned int hash_slots, unsigned int flags)
 		cur = rcu_dereference_protected(mm->futex.phash.hash,
 						lockdep_is_held(&mm->futex.phash.lock));
 		new = mm->futex.phash.hash_new;
-		mm->futex.phash.hash_new = NULL;
+		WRITE_ONCE(mm->futex.phash.hash_new, NULL);
 
 		if (fph) {
 			if (cur && !cur->hash_mask) {
@@ -1889,7 +1895,7 @@ static int futex_hash_allocate(unsigned int hash_slots, unsigned int flags)
 				 * the second one returns here.
 				 */
 				free = fph;
-				mm->futex.phash.hash_new = new;
+				WRITE_ONCE(mm->futex.phash.hash_new, new);
 				return -EBUSY;
 			}
 			if (cur && !new) {


base-commit: db2ddb87143519e20a95aa36c60b36107b736a58
-- 
This is an AI-generated patch subject to moderation.
Reply with '#syz upstream' to Sign-off the patch as a human author
and send it to the upstream kernel mailing lists.
Reply with '#syz reject' to reject it ('#syz unreject' to undo).

See https://goo.gle/syzbot-ai-patches for information about AI-generated patches.
You can comment on the patch as usual, syzbot will try to address
the comments and send a new version of the patch if necessary.
syzbot engineers can be reached at syzkaller@googlegroups.com.
