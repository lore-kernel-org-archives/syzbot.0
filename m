Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 682E8381AE5;
	Thu, 13 Aug 2026 06:50:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786603851; cv=none; b=tCeJBMB+oYC7MzkvRHKsmOjRtpy4bOyAETQCZ6gklP5hol/5AVV/jAFpOMrGC5o+UODdOsev7ebcZgzxHcTalcvMHIvUoSZuEuVjK7l67NEkUAkeR6v0zZymTjyfin7EpOgNI8ZG9Ej4GWpTnC6/dYaegIcihOgzuU0bDAf011c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786603851; c=relaxed/simple;
	bh=4mfV42A2Jdvdsx5n1L1Eagc/dmO6Z64DBPAb1QBVJ/0=;
	h=From:To:Cc:Subject:Message-ID:MIME-Version:Content-Type:Date; b=ev6u/e4fPR/GVtPGMlg9IEOCHehi2HYftwqfTKY+T1TOODYR99Y1uPJ/vR5BXDkyXxnre8dEUzcyU7rCLve8I4+fs4cjeyUoUYXzxOE/LuJFr/kCrmKyugbnIQo3HkBeab1LsbvDUnan70MC8r3nXVN5gr6/J5s4TY4MdD9S04A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=QzfQP5ka; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="QzfQP5ka"
Received: by smtp.kernel.org (Postfix) with UTF8SMTPSA id AC0B31F000E9;
	Thu, 13 Aug 2026 06:50:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1786603850;
	bh=TbtiBWs+YmzYZ4kr0LHvhU68kDKAJrNZCvljYLVI6Zg=;
	h=From:To:Cc:Subject:Date;
	b=QzfQP5ka3Xhr8tv8RXI9pEd5ckKXuBseUpPvJi9DLo8Au5gtTSJXdEN9AU2e2y+hA
	 Hlzt8nNhQyUUj1nfYnE3t1v+2viWVbhLxl5mr7Vpz/ixch94fX10IXs6iMAfF1OaZd
	 KL0CPM0EiVJwEVuo9AmYOphXxIwY6xR0bS/GhktXpQ8umaxCbDKuUS3BA8fQZ4XWXs
	 ke9xuG1Ng4fGCAzTLuG/bQOh3HdV3KJozl9EG/5tiWShCF+mjrZhkIP6g2anuBzp59
	 sg/8RzO1tGeZiFHSOLuKyFFlNl8yWVKkOipeSoUvyJRbsPyrHVYMWFnAfnWejuileG
	 WX1CWzDXC19Hg==
From: "syzbot" <syzbot@kernel.org>
To: syzkaller-bugs@googlegroups.com, Yao Kai <yaokai34@huawei.com>, <linux-kernel@vger.kernel.org>, "Ingo Molnar" <mingo@redhat.com>, "Thomas Gleixner" <tglx@kernel.org>
Cc: andrealmeid@igalia.com, dave@stgolabs.net, dvhart@infradead.org, liuyongqiang13@huawei.com, peterz@infradead.org, syzbot@lists.linux.dev
Subject: [PATCH] futex: Fix might_sleep() warning in futex_pivot_pending()
Message-ID: <515ea00f-a081-4b9a-bcb3-f5517fd4e565@mail.kernel.org>
Precedence: bulk
X-Mailing-List: syzbot@lists.linux.dev
List-Id: <syzbot.lists.linux.dev>
List-Subscribe: <mailto:syzbot+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:syzbot+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Date: Thu, 13 Aug 2026 06:50:49 +0000 (UTC)

From: Yao Kai <yaokai34@huawei.com>

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

Fixes: 8e7ff730dd96 ("futex: Fix race in futex_pivot_pending() during private hash resize")
Assisted-by: Gemini:gemini-3.6-flash Gemini:gemini-3.1-pro-preview syzbot
Reported-by: syzbot+350a93852ac854927f45@syzkaller.appspotmail.com
Closes: https://syzkaller.appspot.com/bug?extid=350a93852ac854927f45
Link: https://syzkaller.appspot.com/ai_job?id=29771462-e030-4501-832d-adbf8cb167c2
Signed-off-by: Yao Kai <yaokai34@huawei.com>

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
See https://goo.gle/syzbot-ai-patches for information about AI-generated patches.
The person who has signed off on the patch is responsible for
addressing comments.
syzbot engineers can be reached at syzkaller@googlegroups.com.
