Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E6B203546F9
	for <syzbot@lists.linux.dev>; Wed, 12 Aug 2026 13:25:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786541151; cv=none; b=HDRNwypklcbvsJ2kohIvdIRPof0N0doyO6OThRQh6jEfg7FEHC9grVyYeBajFaU/PQO+1H+QtSeup4U7AXhdcfZNvrWe7yx7FJvCNrNy6tWGgD7NlZ1h19kziCiPAmnflhMZ0IRB2Jdo0B1dX6902WAVTbkGFVYHWfrLr2om32A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786541151; c=relaxed/simple;
	bh=TD5TYz+z9A+x9iTXPkc/S1K0sx7Z8jGcZw9hYNrlSOI=;
	h=From:To:Cc:Subject:Message-ID:MIME-Version:Content-Type:Date; b=GZUXQItZwuFLdyxIomiI8K4ZvQMj4hDyHVlhNcOEVlI4OtM6fOcEN6wK7ymWtPc1IB0Q8vyayYJ81PD/cyBaUCl+yd0Z8GGNuyZ0kCWjUZVPsJnPwqhtppKG/3cAuFpsMnVFBEfAaG6pHzz4eHa2M+eCjS4xFLh5bxQYHnqWmvQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=oj26bqN0; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="oj26bqN0"
Received: by smtp.kernel.org (Postfix) with UTF8SMTPSA id 8D5CA1F000E9;
	Wed, 12 Aug 2026 13:25:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1786541149;
	bh=P1OI0/E6W4s3siykuZtsT3X+CLuNku4LfnEYL1hZhoo=;
	h=From:To:Cc:Subject:Date;
	b=oj26bqN0h/QUHLUePJUO6AzEyw6KE9SlctsX/ajEf93w2DtEsnhFixDZLZSlLGLFD
	 gvOtxOIhhnFy+z1VWhZMdnkn1Xfor46K7lhqu9/z18b3Q2E8aDHfzTq7jwjhnI3/Rq
	 mOf+VdB5rUQiJv9yOvxot2uOQXLyZEUi08mgsGNi+vcusToIOTdyEzCyTgTr72C2l2
	 3lUFAEMmcWw+PUS+EbTVpPa4V+rtwKcKgfYSHC4bPMELcqHSRAP8Sl4spP3UzWjzmu
	 /Odua1EHdSgdtQC9keHH3ap9TYDIqYqT+upY88gWkisIkNXYlYv82neghl2k3ZZ8h7
	 2lXF9Xrnpc2HQ==
From: "syzbot" <syzbot@kernel.org>
To: syzkaller-upstream-moderation@googlegroups.com
Cc: syzbot@lists.linux.dev
Subject: [PATCH RFC] futex: Fix might_sleep() warning in futex_pivot_pending()
Message-ID: <1f966921-7789-4c70-92cd-ae6c4f8d5be4@mail.kernel.org>
Precedence: bulk
X-Mailing-List: syzbot@lists.linux.dev
List-Id: <syzbot.lists.linux.dev>
List-Subscribe: <mailto:syzbot+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:syzbot+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Date: Wed, 12 Aug 2026 13:25:49 +0000 (UTC)

A recent change in commit 8e7ff730dd96 ("futex: Fix race in
futex_pivot_pending() during private hash resize") modified
futex_pivot_pending() to acquire a mutex to fix a race condition. However,
futex_pivot_pending() is evaluated as a condition inside wait_var_event()
in futex_hash_allocate(). Since wait_var_event() sets the task state to
TASK_UNINTERRUPTIBLE before evaluating the condition, calling a blocking
operation like mutex_lock() is invalid and triggers a might_sleep()
warning:

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

Furthermore, if the mutex is contended, mutex_lock() will block. When it
acquires the lock and returns, the task state will be reset to
TASK_RUNNING. This causes the subsequent schedule() in the wait loop to
return immediately, leading to a busy loop that consumes 100% CPU until the
condition is met.

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
Assisted-by: Gemini:gemini-3.5-flash Gemini:gemini-3.1-pro-preview syzbot
Reported-by: syzbot+350a93852ac854927f45@syzkaller.appspotmail.com
Closes: https://syzkaller.appspot.com/bug?extid=350a93852ac854927f45
Link: https://syzkaller.appspot.com/ai_job?id=78f30cbc-93e5-4bed-a5bc-32f4877252b1
To: <linux-kernel@vger.kernel.org>
To: "Ingo Molnar" <mingo@redhat.com>
To: "Thomas Gleixner" <tglx@kernel.org>
To: "Yao Kai" <yaokai34@huawei.com>
Cc: =?utf-8?q?Andr=C3=A9_Almeida?= <andrealmeid@igalia.com>
Cc: "Davidlohr Bueso" <dave@stgolabs.net>
Cc: "Darren Hart" <dvhart@infradead.org>
Cc: "Peter Zijlstra" <peterz@infradead.org>

---
diff --git a/kernel/futex/core.c b/kernel/futex/core.c
index 128c5752f..b1eab5843 100644
--- a/kernel/futex/core.c
+++ b/kernel/futex/core.c
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
