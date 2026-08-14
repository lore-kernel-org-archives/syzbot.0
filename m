Received: from desiato.infradead.org (desiato.infradead.org [90.155.92.199])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0E76845FFB6;
	Fri, 14 Aug 2026 13:38:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=90.155.92.199
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786714694; cv=none; b=lLRllrDnf5aU4Q0DKPTIAwD9Ch4h+apktqP8MqIKvWQlMGGlmkyRb53T48y47JaDXr51VeRwWxMd6bhAS6nDJJ/+h8gdjek7nZSRUtBgGzOsEAG9Vdpi5OF1c8C4tZuHXQA+HDcejLm0y73C8UVsdvAjjUP5hpxhZ1wRsiYw170=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786714694; c=relaxed/simple;
	bh=yT9N4kXHlHT4ZDM9zDRGXnGHoFLLH4bIPxDioxZ8bKw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=DI9Hio9FcIBgGkxRgTWRoyHuAF3C2LoOS9HVs0qjSUfjxLKqVaKLhpdr+XcKDbbGt4J5GlIbG38WnH/QvCU+LgAA82oKR8qCeznORxICyloo1jiy2fs+L2XgMKefyQ53L+rUXj3QesyO00Xi8tNEKgmKzv9jC2tDuDIxOvzKYms=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org; spf=pass smtp.mailfrom=infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=XVU1uF3X; arc=none smtp.client-ip=90.155.92.199
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="XVU1uF3X"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=desiato.20200630; h=In-Reply-To:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=bwl2I5N5VmSOPwbZsc1ZPlRQ+yjTEMN7SiezAHXNeH0=; b=XVU1uF3XjlhwF00BC3oa4TK5LK
	35CP88ZLIaSL5KogP3iAH70vl7a/yw6WFXS2qpEw+9Kcr40h5NCHDSTJDbvP2ltlq0aZXFMhjkDXz
	EWWHWRF28Sl7KhftqmB+szE3ZrosdJBBv//425lV70h4zsIxnM7dqRcqj3+b/XRqqonhnxI5w2eEA
	1Vj/+n9olSglcleNar+4gA7PHdrV7NlJJbKKGlYqPjsAaccdA323dql7ZLoYYUUvuscE6uu7X8+wV
	6E9G7xUM1G3QQSyMeZtK8gilgq0uZwh5A2CcOmnF9ojcb0xHkVr+8hQfVvbKglxjzGBsAL49RAqHS
	Nj73b4aA==;
Received: from 77-249-17-252.cable.dynamic.v4.ziggo.nl ([77.249.17.252] helo=noisy.programming.kicks-ass.net)
	by desiato.infradead.org with esmtpsa (Exim 4.99.2 #2 (Red Hat Linux))
	id 1wus6m-0000000GxAi-0Ya1;
	Fri, 14 Aug 2026 13:38:04 +0000
Received: by noisy.programming.kicks-ass.net (Postfix, from userid 1000)
	id 24C7B302D6E; Fri, 14 Aug 2026 15:38:03 +0200 (CEST)
Date: Fri, 14 Aug 2026 15:38:03 +0200
From: Peter Zijlstra <peterz@infradead.org>
To: syzbot <syzbot@kernel.org>
Cc: syzkaller-bugs@googlegroups.com, Yao Kai <yaokai34@huawei.com>,
	linux-kernel@vger.kernel.org, Ingo Molnar <mingo@redhat.com>,
	Thomas Gleixner <tglx@kernel.org>, andrealmeid@igalia.com,
	dave@stgolabs.net, dvhart@infradead.org, liuyongqiang13@huawei.com,
	syzbot@lists.linux.dev
Subject: Re: [PATCH] futex: Fix might_sleep() warning in futex_pivot_pending()
Message-ID: <20260814133803.GA687043@noisy.programming.kicks-ass.net>
References: <515ea00f-a081-4b9a-bcb3-f5517fd4e565@mail.kernel.org>
Precedence: bulk
X-Mailing-List: syzbot@lists.linux.dev
List-Id: <syzbot.lists.linux.dev>
List-Subscribe: <mailto:syzbot+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:syzbot+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <515ea00f-a081-4b9a-bcb3-f5517fd4e565@mail.kernel.org>

On Thu, Aug 13, 2026 at 06:50:49AM +0000, syzbot wrote:
> From: Yao Kai <yaokai34@huawei.com>
> 
> A recent change modified futex_pivot_pending() to acquire a mutex to fix a
> race condition. However, futex_pivot_pending() is evaluated as a condition
> inside wait_var_event() in futex_hash_allocate(). Since wait_var_event()
> sets the task state to TASK_UNINTERRUPTIBLE before evaluating the
> condition, calling a blocking operation like mutex_lock() is invalid and
> triggers a might_sleep() warning:
> 
> do not call blocking ops when !TASK_RUNNING; state=2 set at
> [<ffffffff819e8c8d>] prepare_to_wait_event+0x3dd/0x480
> kernel/sched/wait.c:317
> WARNING: kernel/sched/core.c:9124 at __might_sleep+0x92/0xf0
> kernel/sched/core.c:9120
> Call Trace:
>  <TASK>
>  __mutex_lock_common kernel/locking/mutex.c:623 [inline]
>  __mutex_lock+0x118/0x1550 kernel/locking/mutex.c:821
>  class_mutex_constructor include/linux/mutex.h:253 [inline]
>  futex_pivot_pending kernel/futex/core.c:1789 [inline]
>  futex_hash_allocate+0x7fb/0xf00 kernel/futex/core.c:1872
>  __do_sys_prctl kernel/sys.c:2885 [inline]
>  __se_sys_prctl+0x78c/0x1910 kernel/sys.c:2534
> 
> Fix this by reverting futex_pivot_pending() to a lockless implementation
> using RCU and memory barriers, which is the idiomatic way to handle
> conditions in wait_event loops. By reading the hash pointer first,
> executing an smp_rmb() memory barrier, and then reading hash_new, we
> leverage the Message Passing (MP) pattern to guarantee correctness without
> blocking. This pairs with the rcu_assign_pointer() release barrier in
> __futex_pivot_hash(). If the reader sees the new hash, it is guaranteed to
> see the cleared hash_new and correctly return true. If the reader sees the
> old hash, it will check futex_ref_is_dead(old), which will return true if
> the writer has already completed the pivot. The old hash memory is
> guaranteed to remain valid for the duration of the check in
> futex_ref_is_dead() because futex_pivot_pending() executes within an RCU
> read-side critical section and the old hash is freed using kvfree_rcu().
> 
> Fixes: 8e7ff730dd96 ("futex: Fix race in futex_pivot_pending() during private hash resize")
> Assisted-by: Gemini:gemini-3.6-flash Gemini:gemini-3.1-pro-preview syzbot
> Reported-by: syzbot+350a93852ac854927f45@syzkaller.appspotmail.com
> Closes: https://syzkaller.appspot.com/bug?extid=350a93852ac854927f45
> Link: https://syzkaller.appspot.com/ai_job?id=29771462-e030-4501-832d-adbf8cb167c2
> Signed-off-by: Yao Kai <yaokai34@huawei.com>

Bah. So a younger me added that might_sleep() test, because yes,
sleeping from a wait loop is dodgy. It mostly works in this case, but
bah.

I also build an alternative wait look scheme it seems, but we don't have
nice helpers for that, and its never been applied to bit/var waits.

I've hacked up the below. Its not exactly what I call nice, but it
compiles, so it must be perfect... right?

---
diff --git a/include/linux/wait.h b/include/linux/wait.h
index dce055e6add3..7e215330199c 100644
--- a/include/linux/wait.h
+++ b/include/linux/wait.h
@@ -1228,6 +1228,7 @@ long prepare_to_wait_event(struct wait_queue_head *wq_head, struct wait_queue_en
 void finish_wait(struct wait_queue_head *wq_head, struct wait_queue_entry *wq_entry);
 long wait_woken(struct wait_queue_entry *wq_entry, unsigned mode, long timeout);
 int woken_wake_function(struct wait_queue_entry *wq_entry, unsigned mode, int sync, void *key);
+int woken_wake_bit_function(struct wait_queue_entry *wq_entry, unsigned mode, int sync, void *key);
 int autoremove_wake_function(struct wait_queue_entry *wq_entry, unsigned mode, int sync, void *key);
 
 #define DEFINE_WAIT_FUNC(name, function)					\
diff --git a/include/linux/wait_bit.h b/include/linux/wait_bit.h
index ace7379d627d..553d7b23e3ad 100644
--- a/include/linux/wait_bit.h
+++ b/include/linux/wait_bit.h
@@ -32,6 +32,7 @@ int out_of_line_wait_on_bit_timeout(unsigned long *word, int, wait_bit_action_f
 int out_of_line_wait_on_bit_lock(unsigned long *word, int, wait_bit_action_f *action, unsigned int mode);
 struct wait_queue_head *bit_waitqueue(unsigned long *word, int bit);
 extern void __init wait_bit_init(void);
+extern struct wait_bit_key *__var_wake_key(struct wait_queue_entry *wq_entry, void *arg);
 
 int wake_bit_function(struct wait_queue_entry *wq_entry, unsigned mode, int sync, void *key);
 
diff --git a/kernel/futex/core.c b/kernel/futex/core.c
index a7c2a6242718..d3311047d259 100644
--- a/kernel/futex/core.c
+++ b/kernel/futex/core.c
@@ -46,6 +46,7 @@
 #include <linux/slab.h>
 #include <linux/vmalloc.h>
 #include <linux/kmemleak.h>
+#include <linux/wait_bit.h>
 
 #include <vdso/futex.h>
 
@@ -1886,11 +1887,24 @@ static int futex_hash_allocate(unsigned int hash_slots, unsigned int flags)
 		futex_hash_bucket_init(&fph->queues[i]);
 
 	if (custom) {
+		struct wait_bit_queue_entry __wbq_entry;
+		struct wait_queue_head *__wq_head;
+
 		/*
 		 * Only let prctl() wait / retry; don't unduly delay clone().
 		 */
 again:
-		wait_var_event(mm, futex_pivot_pending(mm));
+		__wq_head = __var_waitqueue(mm);
+		init_wait_var_entry(&__wbq_entry, mm, 0);
+		__wbq_entry.wq_entry.func = woken_wake_bit_function;
+		add_wait_queue(__wq_head, &__wbq_entry.wq_entry);
+		while (!futex_pivot_pending(mm)) {
+			int rc = wait_woken(&__wbq_entry.wq_entry, TASK_UNINTERRUPTIBLE,
+					    MAX_SCHEDULE_TIMEOUT);
+			if (!rc)
+				break;
+		}
+		remove_wait_queue(__wq_head, &__wbq_entry.wq_entry);
 	}
 
 	scoped_guard(mutex, &mm->futex.phash.lock) {
diff --git a/kernel/sched/wait.c b/kernel/sched/wait.c
index 20f27e2cf7ae..d033f600f48c 100644
--- a/kernel/sched/wait.c
+++ b/kernel/sched/wait.c
@@ -5,6 +5,7 @@
  * (C) 2004 Nadia Yvette Chambers, Oracle
  */
 #include "sched.h"
+#include <linux/wait_bit.h>
 
 void __init_waitqueue_head(struct wait_queue_head *wq_head, const char *name, struct lock_class_key *key)
 {
@@ -463,3 +464,17 @@ int woken_wake_function(struct wait_queue_entry *wq_entry, unsigned mode, int sy
 	return default_wake_function(wq_entry, mode, sync, key);
 }
 EXPORT_SYMBOL(woken_wake_function);
+
+int woken_wake_bit_function(struct wait_queue_entry *wq_entry, unsigned mode, int sync, void *arg)
+{
+	struct wait_bit_key *key = __var_wake_key(wq_entry, arg);
+	if (!key)
+		return 0;
+
+	/* Pairs with the smp_store_mb() in wait_woken(). */
+	smp_mb(); /* C */
+	wq_entry->flags |= WQ_FLAG_WOKEN;
+
+	return default_wake_function(wq_entry, mode, sync, key);
+}
+EXPORT_SYMBOL(woken_wake_bit_function);
diff --git a/kernel/sched/wait_bit.c b/kernel/sched/wait_bit.c
index 1088d3b7012c..e8127e83a48f 100644
--- a/kernel/sched/wait_bit.c
+++ b/kernel/sched/wait_bit.c
@@ -167,9 +167,7 @@ wait_queue_head_t *__var_waitqueue(void *p)
 }
 EXPORT_SYMBOL(__var_waitqueue);
 
-static int
-var_wake_function(struct wait_queue_entry *wq_entry, unsigned int mode,
-		  int sync, void *arg)
+struct wait_bit_key *__var_wake_key(struct wait_queue_entry *wq_entry, void *arg)
 {
 	struct wait_bit_key *key = arg;
 	struct wait_bit_queue_entry *wbq_entry =
@@ -177,6 +175,17 @@ var_wake_function(struct wait_queue_entry *wq_entry, unsigned int mode,
 
 	if (wbq_entry->key.flags != key->flags ||
 	    wbq_entry->key.bit_nr != key->bit_nr)
+		return NULL;
+
+	return key;
+}
+
+static int
+var_wake_function(struct wait_queue_entry *wq_entry, unsigned int mode,
+		  int sync, void *arg)
+{
+	struct wait_bit_key *key = __var_wake_key(wq_entry, arg);
+	if (!key)
 		return 0;
 
 	return autoremove_wake_function(wq_entry, mode, sync, key);
