Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B4AF1385D97
	for <syzbot@lists.linux.dev>; Tue, 18 Aug 2026 10:47:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=100.103.45.18
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787050029; cv=pass; b=bFFY6rTcdOUOLZggJ6dsAnSPdyNEoXRyKZbWx1B39SlwZqZCB0hUrG+UEgTRxO6/uX5HvEiAW7lVpwhB/pkuAiiKEAFnW21A5U+IRPJ2YM1H16q/o4UMl8I3aJYczM1xMcp/wMo9lXxLo4OzeaHPdK6tfw5PC/hsplO6kG3BwMY=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787050029; c=relaxed/simple;
	bh=6MsFbhKcH9QAeiYu0dpBrpLzmfyAkOPfNFgpUEpZOjs=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=WI5tE++uArincFYIxEtjxzxP+LcZZpTJ9NlER9F/PmUFcfTHd44pcA0+WrUTpRiTkGjc3BwH5ElXAIx80fjvvaBRyTptfNevAP5I5hVdjNA/A2G8nHquq2NUWGO8kTTavOWTnb4a1mX/gNEn6nxUiSiIumqzo183RsXWiD2pXUk=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=mOE2WN4L; arc=pass smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="mOE2WN4L"
Received: by smtp.kernel.org (Postfix)
	id 6759B1F00A3A; Tue, 18 Aug 2026 10:47:06 +0000 (UTC)
Authentication-Results: smtp.kernel.org; arc=none smtp.remote-ip=90.155.50.34
ARC-Seal: i=1; d=kernel.org; s=arc20260519; a=rsa-sha256; cv=none;
	t=1787050026;
	b=y+vBIFvREUqdJnQRzLZXwFlGEWqqUCspnGQ74uXosbvqpT/d4LUREXLB4KGfj6qyemfE
	 DtDpkH6BQVcubU8hy4fN8+UzWKZwBfpnnLspd3k9FP8vwPqtxGOq1BqJt1nC+Ow6N/mAw
	 KIEP7QLhIr+jjiHATq0AfWLIjE8uBk6YJinVVf8lCrYZGXHJR7SliqyvzYoWUf4Pf+9Kp
	 8uL7aXkQiVjR8l+ZaraKSytsISA85mKMhVXH7rL//pfQBeOm1U9sZ6296e525IoDeBmok
	 6sNYxp3lSaegoBxYZytDyfC9woWJnBtjwnzyyBaYzz9SlHjr9s6O2NUW0TxIJBQxqcw==
ARC-Message-Signature: i=1; d=kernel.org; s=arc20260519; a=rsa-sha256;
	c=relaxed/relaxed; t=1787050026;
	h=DMARC-Filter:DKIM-Signature:Received:Received:Date:From:To:Cc:
	 Subject:Message-ID:References:MIME-Version:Content-Type:
	 Content-Disposition:In-Reply-To;
	bh=JNAsElfwryduquti2VexKKz89P5skCcekcGs3NCJUQE=;
	b=nQSy9RkEIXjQ6z9MMU5C/KVTBl81w4bVh62oNYAkFTDtF+MpMo6NH82IssUxRRGq61dW
	 qjQP82Hz2AFCFfFgcC0WbrIPg14wHmDsCN1Vme4BQb42xpYZ2rhRJK2oEZ06PqxkroOdz
	 MdsZ6D1+BjHrsrsjoPK2KOuHr/gQ/EZy/IVftUVnqm4WMyHpqwctY63jKJPcWCrPw7qxw
	 f3nTm4HP4yKzJ5Vg53c4VvsE/uZjHyCaDyzEnroHhQn1nMr4DxQajtl/mgY/NDwH8idrN
	 vgUuyMOTjYfv0/GnsbTJyhAmRpwFKJKdz2CnnQ6o16xu8MCaIzpXIP1ycc+Kv0b6FAg==
ARC-Authentication-Results: i=1; smtp.kernel.org; dkim=pass header.d=infradead.org header.i=@infradead.org header.a=rsa-sha256 header.s=casper.20170209 header.b=mOE2WN4L;
	dmarc=pass header.from=infradead.org;
	spf=pass smtp.mailfrom=infradead.org;
	arc=none smtp.remote-ip=90.155.50.34
Received: from casper.infradead.org (casper.infradead.org [90.155.50.34])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.kernel.org (Postfix) with ESMTPS id B97391F000E9;
	Tue, 18 Aug 2026 10:47:04 +0000 (UTC)
Authentication-Results: smtp.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=infradead.org header.i=@infradead.org header.a=rsa-sha256 header.s=casper.20170209 header.b=mOE2WN4L
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.kernel.org B97391F000E9
Authentication-Results: smtp.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.kernel.org; spf=pass smtp.mailfrom=infradead.org
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=JNAsElfwryduquti2VexKKz89P5skCcekcGs3NCJUQE=; b=mOE2WN4L1bxbLwWeGiUtYKcLVT
	5DyQSFzjzBK7L6spQUF9m7DpZeB2rbANREZaVV7EauOTP/YiSxWXglSNw3YBJangJYS28UGASuzp5
	dC52u0zYTn+MjYQ6deFP9ZPgm/IcF99qpC7Oo5YZIw7YlAHfUrspC/OrVL0CCugnbFQzAEQjgLnde
	b7zKKLuZYQpLKA7QOK4Ueirb5I8LRKLr/cuqlbxccF15E7Xxe/orEZjRNQ/XD5NAR9IP5FONrZkLv
	eKtfUshbBUpJ2l953vgtEIrwTAjoLTZQq8mS0eTy2fKf6fWZfVflPjNIS2SKRohRJarpvv3IzNMC3
	fCq7Bgkg==;
Received: from 77-249-17-252.cable.dynamic.v4.ziggo.nl ([77.249.17.252] helo=noisy.programming.kicks-ass.net)
	by casper.infradead.org with esmtpsa (Exim 4.99.1 #2 (Red Hat Linux))
	id 1wwHLP-0000000BhlW-2quO;
	Tue, 18 Aug 2026 10:46:59 +0000
Received: by noisy.programming.kicks-ass.net (Postfix, from userid 1000)
	id 6DC92300242; Tue, 18 Aug 2026 12:46:58 +0200 (CEST)
Date: Tue, 18 Aug 2026 12:46:58 +0200
From: Peter Zijlstra <peterz@infradead.org>
To: Yao Kai <yaokai34@huawei.com>
Cc: syzbot <syzbot@kernel.org>, syzkaller-bugs@googlegroups.com,
	linux-kernel@vger.kernel.org, Ingo Molnar <mingo@redhat.com>,
	Thomas Gleixner <tglx@kernel.org>, andrealmeid@igalia.com,
	dave@stgolabs.net, dvhart@infradead.org, liuyongqiang13@huawei.com,
	syzbot@lists.linux.dev
Subject: Re: [PATCH] futex: Fix might_sleep() warning in futex_pivot_pending()
Message-ID: <20260818104658.GE1246887@noisy.programming.kicks-ass.net>
References: <515ea00f-a081-4b9a-bcb3-f5517fd4e565@mail.kernel.org>
 <20260814133803.GA687043@noisy.programming.kicks-ass.net>
 <f3ed739d-fa18-43b8-a7d7-c5f1db0e22b0@huawei.com>
Precedence: bulk
X-Mailing-List: syzbot@lists.linux.dev
List-Id: <syzbot.lists.linux.dev>
List-Subscribe: <mailto:syzbot+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:syzbot+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <f3ed739d-fa18-43b8-a7d7-c5f1db0e22b0@huawei.com>

On Mon, Aug 17, 2026 at 03:29:14PM +0800, Yao Kai wrote:
> Thanks! I think there is still a lost-wakeup window:
> 
>         T1                              T2
> 
>         add_wait_queue()
>           /* not visible to T2 */
>         futex_pivot_pending()
>           futex_ref_is_dead() = false
>                                         futex_ref_put() = true
>                                         wake_up_var()
>                                           waitqueue_active() = false
>                                             /* observes empty */
>                                           return
>         wait_woken()
>         schedule()
> 
> Since wake_up_var() uses a lockless waitqueue_active() check, I think
> we need to order the waitqueue insertion before the first condition
> check:
> 
>   add_wait_queue(__wq_head, &__wbq_entry.wq_entry);
> 
>   /*
>    * Pairs with the fully ordered refcount operation before wake_up_var().
>    * Ensures either the waker sees this waiter or we see the dead refcount.
>    */
>   smp_mb();

Well, add_wait_queue() has UNLOCK(&wq_head->lock) and
futex_pivot_pending() has LOCK(&mmph->lock), giving an UNLOCK+LOCK
consistency, which IIRC is RCtso if you're on PowerPC and RCsc
everywhere else.

So yeah, this needs more. But I would instead suggest we use:

	smp_mb__after_spinlock().

Anyway, for this to matter one way or the other, the other side of this
also needs a barrier. But it looks like futex_ref_put() already implies
enough. When in atomic mode it implies a full smp_mb().

>   while (!futex_pivot_pending(mm))
>           wait_woken(&__wbq_entry.wq_entry, TASK_UNINTERRUPTIBLE,
>                      MAX_SCHEDULE_TIMEOUT);
> 
> The rc check can be dropped because MAX_SCHEDULE_TIMEOUT does not expire.

Indeed, I had realized this after sending :-)

Something like so then?

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
index a7c2a6242718..bd9fb0b17ee6 100644
--- a/kernel/futex/core.c
+++ b/kernel/futex/core.c
@@ -46,6 +46,7 @@
 #include <linux/slab.h>
 #include <linux/vmalloc.h>
 #include <linux/kmemleak.h>
+#include <linux/wait_bit.h>
 
 #include <vdso/futex.h>
 
@@ -1886,11 +1887,34 @@ static int futex_hash_allocate(unsigned int hash_slots, unsigned int flags)
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
+
+		/*
+		 * add_wait_queue()		futex_ref_put()
+		 * MB (this)			MB (implied)
+		 * futex_pivot_pending()	wake_up_var()
+		 *                                waitqueue_active()
+		 *
+		 * Notably, it must not be possible to see
+		 * !futex_pivot_pending() && !waitqueue_active().
+		 */
+		smp_mb__after_spinlock();
+
+		while (!futex_pivot_pending(mm) &&
+		       wait_woken(&__wbq_entry.wq_entry, TASK_UNINTERRUPTIBLE,
+				  MAX_SCHEDULE_TIMEOUT))
+			/* empty */;
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
