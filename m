Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C833531D730
	for <syzbot@lists.linux.dev>; Mon, 17 Aug 2026 07:29:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=100.103.45.18
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786951773; cv=pass; b=RU0KMn4yRcnCXw3CLFZD/5CRcXpB0t0viKraTEgiA1OF53cKsnj9hZq+DqqBmc3K8kb6vjcy7g8AcFcejr0PW3AInJV+EBU9OKpqFKfj5WnXMoavc5iTI2EYwTwHFEqE8I5mpLKCQ9N2qRER88t6kh4ymzpQYYU+g4EaYAZszl4=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786951773; c=relaxed/simple;
	bh=NHCImg+W4Nd7TlPQwatno/U/yPDtY3s/jVUrQSSILPQ=;
	h=Message-ID:Date:MIME-Version:Subject:To:CC:References:From:
	 In-Reply-To:Content-Type; b=N9+uSCWjncT9xbuKDRF/jxaRJ1Q6YutyztQWx8szCtEIj4knmKT6Esg+McpesQqR/gXF1n/0L5yA4hhZdjbwYDxZjTEe29BgixA55uhutdXkyttybuLtd+/qJHgzv/XsRxNKZXn5+W/P4XwGaDyxbd0OjSNpNgSt3w6a+H+6rcE=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=huawei.com header.i=@huawei.com header.b=0RY4EZ4q; arc=pass smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=huawei.com header.i=@huawei.com header.b="0RY4EZ4q"
Received: by smtp.kernel.org (Postfix)
	id 89F961F00A3A; Mon, 17 Aug 2026 07:29:31 +0000 (UTC)
Authentication-Results: smtp.kernel.org; arc=none smtp.remote-ip=113.46.200.218
ARC-Seal: i=1; d=kernel.org; s=arc20260519; a=rsa-sha256; cv=none;
	t=1786951771;
	b=if0vjTvTrSMbwWzaOHGugyKyKjj3V+WvBOswY1EYMZ4sbZ6lg7S5Jz8u2hWP+AaVdGDb
	 nxoUSR0ZUW6CBDyLWh3Mn0qhUVrztKIpCjY5RWTMCOjny06Nc5Kuxt9/oLvhd6iOutoHT
	 J5VjcrW19JVW/J7FfgiDpGtxucy8C2rdtnkj+yWuF8Q6JHCUImPC096zIzzlYDYh25PYs
	 3b+TTq2CyBlKH0Xj1QoN8G7FD5+8SQY/90hz0bQ1MhrNSrDWJGblVRLzhfOmijOTWnJv2
	 vZjlW69/KFKRFmkgWh+KCCDM1DheDDQB+Pm/joldpLIyAp+U4m4yg1AcWN5ju0mONZw==
ARC-Message-Signature: i=1; d=kernel.org; s=arc20260519; a=rsa-sha256;
	c=relaxed/relaxed; t=1786951771;
	h=DMARC-Filter:dkim-signature:Received:Received:Received:Message-ID:
	 Date:MIME-Version:User-Agent:Subject:To:CC:References:
	 Content-Language:From:In-Reply-To:Content-Type:
	 Content-Transfer-Encoding:X-Originating-IP:X-ClientProxiedBy;
	bh=+RfG1H7RaUlmyWyQ+7T/2vNJQx4JOfVf5PR0Ty0edAE=;
	b=MY16mMcZYZCfL4cg0BQRcA5NEXP/VNdX0fLyrZLHemDmhho8vgfhECkvVquKy4A7jyU8
	 B0zBhEdp4ETPJGh2KiDwxM5nnb/ZHWdp2I7qcHQS/N+yNneV4cq1EDetGCpLgJzSWdWW1
	 ovLr8NWYJ+mdmIKd8kokW7ac8iW1zqGGw7noj75EIg51nzNbw6H7f49WXIdFt7EVu93Od
	 /RsOmh+e29pcTMZI555tFdhdxvQ8m+GEqnV2rt0ef8/XM0+atM1t4ud7C6XJDD9reMWIC
	 RXOFfnG2NpcdRQOiuOJdxla1/PCpnVx81kNoTOJTH5lO7n7d1hd08hM7RORL5jxhuOA==
ARC-Authentication-Results: i=1; smtp.kernel.org; dkim=pass header.d=huawei.com header.i=@huawei.com header.a=rsa-sha256 header.s=dkim header.b=0RY4EZ4q;
	dmarc=pass header.from=huawei.com;
	spf=pass smtp.mailfrom=huawei.com;
	arc=none smtp.remote-ip=113.46.200.218
Received: from canpmsgout03.his.huawei.com (canpmsgout03.his.huawei.com [113.46.200.218])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.kernel.org (Postfix) with ESMTPS id 060891F000E9;
	Mon, 17 Aug 2026 07:29:29 +0000 (UTC)
Authentication-Results: smtp.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=huawei.com header.i=@huawei.com header.a=rsa-sha256 header.s=dkim header.b=0RY4EZ4q
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.kernel.org 060891F000E9
Authentication-Results: smtp.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com
Authentication-Results: smtp.kernel.org; spf=pass smtp.mailfrom=huawei.com
dkim-signature: v=1; a=rsa-sha256; d=huawei.com; s=dkim;
	c=relaxed/relaxed; q=dns/txt;
	h=From;
	bh=+RfG1H7RaUlmyWyQ+7T/2vNJQx4JOfVf5PR0Ty0edAE=;
	b=0RY4EZ4q9a3um9wcUwSV0ELeUuX5TWY3rGWcgvLU+1SiKbo9BnsbEiCR8ER/xXy8FcRNiphcj
	z9JmSEQGv0BOIptKHYg0nsRathkZZ9LC79sTBF365dVcb3uWy/5Gys4z0c85gmtqZI2UvY6gxnd
	hM+iKFXKmqDmHq8jtzekF2U=
Received: from mail.maildlp.com (unknown [172.19.163.0])
	by canpmsgout03.his.huawei.com (SkyGuard) with ESMTPS id 4hNkhH3XW4zpSvB;
	Mon, 17 Aug 2026 15:18:23 +0800 (CST)
Received: from dggpemr500006.china.huawei.com (unknown [7.185.36.185])
	by mail.maildlp.com (Postfix) with ESMTPS id CE5D540537;
	Mon, 17 Aug 2026 15:29:15 +0800 (CST)
Received: from [100.103.109.15] (100.103.109.15) by
 dggpemr500006.china.huawei.com (7.185.36.185) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.45; Mon, 17 Aug 2026 15:29:14 +0800
Message-ID: <f3ed739d-fa18-43b8-a7d7-c5f1db0e22b0@huawei.com>
Date: Mon, 17 Aug 2026 15:29:14 +0800
Precedence: bulk
X-Mailing-List: syzbot@lists.linux.dev
List-Id: <syzbot.lists.linux.dev>
List-Subscribe: <mailto:syzbot+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:syzbot+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] futex: Fix might_sleep() warning in futex_pivot_pending()
To: Peter Zijlstra <peterz@infradead.org>, syzbot <syzbot@kernel.org>
CC: <syzkaller-bugs@googlegroups.com>, <linux-kernel@vger.kernel.org>, Ingo
 Molnar <mingo@redhat.com>, Thomas Gleixner <tglx@kernel.org>,
	<andrealmeid@igalia.com>, <dave@stgolabs.net>, <dvhart@infradead.org>,
	<liuyongqiang13@huawei.com>, <syzbot@lists.linux.dev>
References: <515ea00f-a081-4b9a-bcb3-f5517fd4e565@mail.kernel.org>
 <20260814133803.GA687043@noisy.programming.kicks-ass.net>
Content-Language: en-US
From: Yao Kai <yaokai34@huawei.com>
In-Reply-To: <20260814133803.GA687043@noisy.programming.kicks-ass.net>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: kwepems200002.china.huawei.com (7.221.188.68) To
 dggpemr500006.china.huawei.com (7.185.36.185)



On 8/14/2026 9:38 PM, Peter Zijlstra wrote:
> On Thu, Aug 13, 2026 at 06:50:49AM +0000, syzbot wrote:
>> From: Yao Kai <yaokai34@huawei.com>
>>
>> A recent change modified futex_pivot_pending() to acquire a mutex to fix a
>> race condition. However, futex_pivot_pending() is evaluated as a condition
>> inside wait_var_event() in futex_hash_allocate(). Since wait_var_event()
>> sets the task state to TASK_UNINTERRUPTIBLE before evaluating the
>> condition, calling a blocking operation like mutex_lock() is invalid and
>> triggers a might_sleep() warning:
>>
>> do not call blocking ops when !TASK_RUNNING; state=2 set at
>> [<ffffffff819e8c8d>] prepare_to_wait_event+0x3dd/0x480
>> kernel/sched/wait.c:317
>> WARNING: kernel/sched/core.c:9124 at __might_sleep+0x92/0xf0
>> kernel/sched/core.c:9120
>> Call Trace:
>>   <TASK>
>>   __mutex_lock_common kernel/locking/mutex.c:623 [inline]
>>   __mutex_lock+0x118/0x1550 kernel/locking/mutex.c:821
>>   class_mutex_constructor include/linux/mutex.h:253 [inline]
>>   futex_pivot_pending kernel/futex/core.c:1789 [inline]
>>   futex_hash_allocate+0x7fb/0xf00 kernel/futex/core.c:1872
>>   __do_sys_prctl kernel/sys.c:2885 [inline]
>>   __se_sys_prctl+0x78c/0x1910 kernel/sys.c:2534
>>
>> Fix this by reverting futex_pivot_pending() to a lockless implementation
>> using RCU and memory barriers, which is the idiomatic way to handle
>> conditions in wait_event loops. By reading the hash pointer first,
>> executing an smp_rmb() memory barrier, and then reading hash_new, we
>> leverage the Message Passing (MP) pattern to guarantee correctness without
>> blocking. This pairs with the rcu_assign_pointer() release barrier in
>> __futex_pivot_hash(). If the reader sees the new hash, it is guaranteed to
>> see the cleared hash_new and correctly return true. If the reader sees the
>> old hash, it will check futex_ref_is_dead(old), which will return true if
>> the writer has already completed the pivot. The old hash memory is
>> guaranteed to remain valid for the duration of the check in
>> futex_ref_is_dead() because futex_pivot_pending() executes within an RCU
>> read-side critical section and the old hash is freed using kvfree_rcu().
>>
>> Fixes: 8e7ff730dd96 ("futex: Fix race in futex_pivot_pending() during private hash resize")
>> Assisted-by: Gemini:gemini-3.6-flash Gemini:gemini-3.1-pro-preview syzbot
>> Reported-by: syzbot+350a93852ac854927f45@syzkaller.appspotmail.com
>> Closes: https://syzkaller.appspot.com/bug?extid=350a93852ac854927f45
>> Link: https://syzkaller.appspot.com/ai_job?id=29771462-e030-4501-832d-adbf8cb167c2
>> Signed-off-by: Yao Kai <yaokai34@huawei.com>
> 
> Bah. So a younger me added that might_sleep() test, because yes,
> sleeping from a wait loop is dodgy. It mostly works in this case, but
> bah.
> 
> I also build an alternative wait look scheme it seems, but we don't have
> nice helpers for that, and its never been applied to bit/var waits.
> 
> I've hacked up the below. Its not exactly what I call nice, but it
> compiles, so it must be perfect... right?
> 
> ---
> diff --git a/include/linux/wait.h b/include/linux/wait.h
> index dce055e6add3..7e215330199c 100644
> --- a/include/linux/wait.h
> +++ b/include/linux/wait.h
> @@ -1228,6 +1228,7 @@ long prepare_to_wait_event(struct wait_queue_head *wq_head, struct wait_queue_en
>   void finish_wait(struct wait_queue_head *wq_head, struct wait_queue_entry *wq_entry);
>   long wait_woken(struct wait_queue_entry *wq_entry, unsigned mode, long timeout);
>   int woken_wake_function(struct wait_queue_entry *wq_entry, unsigned mode, int sync, void *key);
> +int woken_wake_bit_function(struct wait_queue_entry *wq_entry, unsigned mode, int sync, void *key);
>   int autoremove_wake_function(struct wait_queue_entry *wq_entry, unsigned mode, int sync, void *key);
>   
>   #define DEFINE_WAIT_FUNC(name, function)					\
> diff --git a/include/linux/wait_bit.h b/include/linux/wait_bit.h
> index ace7379d627d..553d7b23e3ad 100644
> --- a/include/linux/wait_bit.h
> +++ b/include/linux/wait_bit.h
> @@ -32,6 +32,7 @@ int out_of_line_wait_on_bit_timeout(unsigned long *word, int, wait_bit_action_f
>   int out_of_line_wait_on_bit_lock(unsigned long *word, int, wait_bit_action_f *action, unsigned int mode);
>   struct wait_queue_head *bit_waitqueue(unsigned long *word, int bit);
>   extern void __init wait_bit_init(void);
> +extern struct wait_bit_key *__var_wake_key(struct wait_queue_entry *wq_entry, void *arg);
>   
>   int wake_bit_function(struct wait_queue_entry *wq_entry, unsigned mode, int sync, void *key);
>   
> diff --git a/kernel/futex/core.c b/kernel/futex/core.c
> index a7c2a6242718..d3311047d259 100644
> --- a/kernel/futex/core.c
> +++ b/kernel/futex/core.c
> @@ -46,6 +46,7 @@
>   #include <linux/slab.h>
>   #include <linux/vmalloc.h>
>   #include <linux/kmemleak.h>
> +#include <linux/wait_bit.h>
>   
>   #include <vdso/futex.h>
>   
> @@ -1886,11 +1887,24 @@ static int futex_hash_allocate(unsigned int hash_slots, unsigned int flags)
>   		futex_hash_bucket_init(&fph->queues[i]);
>   
>   	if (custom) {
> +		struct wait_bit_queue_entry __wbq_entry;
> +		struct wait_queue_head *__wq_head;
> +
>   		/*
>   		 * Only let prctl() wait / retry; don't unduly delay clone().
>   		 */
>   again:
> -		wait_var_event(mm, futex_pivot_pending(mm));
> +		__wq_head = __var_waitqueue(mm);
> +		init_wait_var_entry(&__wbq_entry, mm, 0);
> +		__wbq_entry.wq_entry.func = woken_wake_bit_function;
> +		add_wait_queue(__wq_head, &__wbq_entry.wq_entry);
> +		while (!futex_pivot_pending(mm)) {
> +			int rc = wait_woken(&__wbq_entry.wq_entry, TASK_UNINTERRUPTIBLE,
> +					    MAX_SCHEDULE_TIMEOUT);
> +			if (!rc)
> +				break;
> +		}
> +		remove_wait_queue(__wq_head, &__wbq_entry.wq_entry);
>   	}
>   
>   	scoped_guard(mutex, &mm->futex.phash.lock) {
> diff --git a/kernel/sched/wait.c b/kernel/sched/wait.c
> index 20f27e2cf7ae..d033f600f48c 100644
> --- a/kernel/sched/wait.c
> +++ b/kernel/sched/wait.c
> @@ -5,6 +5,7 @@
>    * (C) 2004 Nadia Yvette Chambers, Oracle
>    */
>   #include "sched.h"
> +#include <linux/wait_bit.h>
>   
>   void __init_waitqueue_head(struct wait_queue_head *wq_head, const char *name, struct lock_class_key *key)
>   {
> @@ -463,3 +464,17 @@ int woken_wake_function(struct wait_queue_entry *wq_entry, unsigned mode, int sy
>   	return default_wake_function(wq_entry, mode, sync, key);
>   }
>   EXPORT_SYMBOL(woken_wake_function);
> +
> +int woken_wake_bit_function(struct wait_queue_entry *wq_entry, unsigned mode, int sync, void *arg)
> +{
> +	struct wait_bit_key *key = __var_wake_key(wq_entry, arg);
> +	if (!key)
> +		return 0;
> +
> +	/* Pairs with the smp_store_mb() in wait_woken(). */
> +	smp_mb(); /* C */
> +	wq_entry->flags |= WQ_FLAG_WOKEN;
> +
> +	return default_wake_function(wq_entry, mode, sync, key);
> +}
> +EXPORT_SYMBOL(woken_wake_bit_function);
> diff --git a/kernel/sched/wait_bit.c b/kernel/sched/wait_bit.c
> index 1088d3b7012c..e8127e83a48f 100644
> --- a/kernel/sched/wait_bit.c
> +++ b/kernel/sched/wait_bit.c
> @@ -167,9 +167,7 @@ wait_queue_head_t *__var_waitqueue(void *p)
>   }
>   EXPORT_SYMBOL(__var_waitqueue);
>   
> -static int
> -var_wake_function(struct wait_queue_entry *wq_entry, unsigned int mode,
> -		  int sync, void *arg)
> +struct wait_bit_key *__var_wake_key(struct wait_queue_entry *wq_entry, void *arg)
>   {
>   	struct wait_bit_key *key = arg;
>   	struct wait_bit_queue_entry *wbq_entry =
> @@ -177,6 +175,17 @@ var_wake_function(struct wait_queue_entry *wq_entry, unsigned int mode,
>   
>   	if (wbq_entry->key.flags != key->flags ||
>   	    wbq_entry->key.bit_nr != key->bit_nr)
> +		return NULL;
> +
> +	return key;
> +}
> +
> +static int
> +var_wake_function(struct wait_queue_entry *wq_entry, unsigned int mode,
> +		  int sync, void *arg)
> +{
> +	struct wait_bit_key *key = __var_wake_key(wq_entry, arg);
> +	if (!key)
>   		return 0;
>   
>   	return autoremove_wake_function(wq_entry, mode, sync, key);


Thanks! I think there is still a lost-wakeup window:

         T1                              T2

         add_wait_queue()
           /* not visible to T2 */
         futex_pivot_pending()
           futex_ref_is_dead() = false
                                         futex_ref_put() = true
                                         wake_up_var()
                                           waitqueue_active() = false
                                             /* observes empty */
                                           return
         wait_woken()
         schedule()

Since wake_up_var() uses a lockless waitqueue_active() check, I think
we need to order the waitqueue insertion before the first condition
check:

   add_wait_queue(__wq_head, &__wbq_entry.wq_entry);

   /*
    * Pairs with the fully ordered refcount operation before wake_up_var().
    * Ensures either the waker sees this waiter or we see the dead refcount.
    */
   smp_mb();

   while (!futex_pivot_pending(mm))
           wait_woken(&__wbq_entry.wq_entry, TASK_UNINTERRUPTIBLE,
                      MAX_SCHEDULE_TIMEOUT);

The rc check can be dropped because MAX_SCHEDULE_TIMEOUT does not expire.

Thanks,
Yao Kai
