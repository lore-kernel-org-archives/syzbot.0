Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5625C46E00D
	for <syzbot@lists.linux.dev>; Tue, 18 Aug 2026 12:24:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=100.103.45.18
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787055861; cv=pass; b=vDksD2dDQvcqESmNeoD5+D/4hRemfa2nBeNwykusksOwLpsxVj8JqoDYUe8qZPTthm0DuAplCvA9kN1lmzmOilKfTDLZXp34qWk+umqNPueXOLW10erR0EwacIe4ah+oQSDySyi4bls11a5d/LjGBZ6GqGJC7iQKC7yemhhGZ54=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787055861; c=relaxed/simple;
	bh=vneH6I8Tdz+Hl0k+Dm1puVgWwzgk+IPBVN6xlFL33fQ=;
	h=Message-ID:Date:MIME-Version:Subject:To:CC:References:From:
	 In-Reply-To:Content-Type; b=rJbux0o8+ktJf0bjrOcK7rIUnDPJAtk9DSON271A+i9XO7lFB6gTIH5rqiuaWwo7t+jwfn4D+bYsZbZGiVGK9Eh27gqBKxhWR8wWuGCOewaa6bAUkzCsI6eMD6IhMSfyDI4twHua079x9LReb4BqY87BXX70/sFmv6gzlerR/eA=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=huawei.com header.i=@huawei.com header.b=QLbHEuMy; arc=pass smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=huawei.com header.i=@huawei.com header.b="QLbHEuMy"
Received: by smtp.kernel.org (Postfix)
	id DBB521F00A3D; Tue, 18 Aug 2026 12:24:17 +0000 (UTC)
Authentication-Results: smtp.kernel.org; arc=none smtp.remote-ip=113.46.200.227
ARC-Seal: i=1; d=kernel.org; s=arc20260519; a=rsa-sha256; cv=none;
	t=1787055857;
	b=QtiTygzWDpu9AMMDxrkHbvYcCE7EzvoyELRrPlhsGtcQ3132ui2b2iNJ7j6ieZhl4KyS
	 asn4FDqm3P67GCMsJLYfUJiLTILQii7pPpxTjdqsOOBWdaV0nPFcnE0AFbzeIxPJdzziU
	 /1ANYP2O8BwtDZWdr88btj2mLdvJRCR2kqqN6XMqyhAVS5vm0bsJJnqLaDwAE0rttxyP7
	 y9yNw2vXNzCTQoWa+XEBheZ4AHj+awlxWaih9+CUvwPPc/FGQYjcNaRglpr6W/2MNOFiC
	 NC7oGXy9ITkhV1CADJhi8+nhgJAFPceO0kzjzex2oolcfUbbLQyItDjJtAxgois4cZg==
ARC-Message-Signature: i=1; d=kernel.org; s=arc20260519; a=rsa-sha256;
	c=relaxed/relaxed; t=1787055857;
	h=DMARC-Filter:dkim-signature:Received:Received:Received:Message-ID:
	 Date:MIME-Version:User-Agent:Subject:To:CC:References:
	 Content-Language:From:In-Reply-To:Content-Type:
	 Content-Transfer-Encoding:X-Originating-IP:X-ClientProxiedBy;
	bh=sS1IoZvF0J2JIXhpRruF/wlVg/3fREEnPwFQV/KR5WY=;
	b=CGhS0ttpNMwM+TY/ZDgQGkjJLnJ6vwL7vozvjKY9RA7C0dxRL3uM2ZTKnUGi/jYM7f3V
	 u+0oaHtpjdY+mb9mP3jS6rpHJymUimgECXo1qNdIQiHsr30XGm6vNuYey1vS0bO9Jr/UQ
	 cPSaHPZomLII9jPsBctj7OinMZ7nylrSE/ajHQg5lUl9h1A2vd57pUVLstZIsgnOUBUcY
	 tQ5VueQgQwi84fDMTdwiUnwsIDyzIp6VdTZI/+87CiWAShFOgQ5axpsTclZ9ZsgAwtFJm
	 2zAAnx2M/c3FV4a3MSOnpDIBKfpq3u3eCRtC5XKr756sfyis4jfqS9qBbdI5TgRUXNQ==
ARC-Authentication-Results: i=1; smtp.kernel.org; dkim=pass header.d=huawei.com header.i=@huawei.com header.a=rsa-sha256 header.s=dkim header.b=QLbHEuMy;
	dmarc=pass header.from=huawei.com;
	spf=pass smtp.mailfrom=huawei.com;
	arc=none smtp.remote-ip=113.46.200.227
Received: from canpmsgout12.his.huawei.com (canpmsgout12.his.huawei.com [113.46.200.227])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.kernel.org (Postfix) with ESMTPS id 553E81F00A3A;
	Tue, 18 Aug 2026 12:24:16 +0000 (UTC)
Authentication-Results: smtp.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=huawei.com header.i=@huawei.com header.a=rsa-sha256 header.s=dkim header.b=QLbHEuMy
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.kernel.org 553E81F00A3A
Authentication-Results: smtp.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com
Authentication-Results: smtp.kernel.org; spf=pass smtp.mailfrom=huawei.com
dkim-signature: v=1; a=rsa-sha256; d=huawei.com; s=dkim;
	c=relaxed/relaxed; q=dns/txt;
	h=From;
	bh=sS1IoZvF0J2JIXhpRruF/wlVg/3fREEnPwFQV/KR5WY=;
	b=QLbHEuMyTaTq7sqB6EmbDtVcC8TNQL7r4w5SuzOdsheI9i5yq9om+ZwvXunK4XANv+IlWf+tx
	W3Ux/dDwi5HqbQtHTKPCDP79susNDY/vK5ZN2shdD48Za0ZImcfFz3VKF+MyhYNTT7RBFU01U0R
	4GsEgwPepkFr6oKimGbRBTg=
Received: from mail.maildlp.com (unknown [172.19.163.163])
	by canpmsgout12.his.huawei.com (SkyGuard) with ESMTPS id 4hPTBk1sK9znTVd;
	Tue, 18 Aug 2026 20:13:50 +0800 (CST)
Received: from dggpemr500006.china.huawei.com (unknown [7.185.36.185])
	by mail.maildlp.com (Postfix) with ESMTPS id 42AC94048B;
	Tue, 18 Aug 2026 20:24:09 +0800 (CST)
Received: from [100.103.109.15] (100.103.109.15) by
 dggpemr500006.china.huawei.com (7.185.36.185) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.45; Tue, 18 Aug 2026 20:24:08 +0800
Message-ID: <681d9e21-d408-4acb-8c51-b8a86d599e0f@huawei.com>
Date: Tue, 18 Aug 2026 20:24:07 +0800
Precedence: bulk
X-Mailing-List: syzbot@lists.linux.dev
List-Id: <syzbot.lists.linux.dev>
List-Subscribe: <mailto:syzbot+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:syzbot+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] futex: Fix might_sleep() warning in futex_pivot_pending()
To: Peter Zijlstra <peterz@infradead.org>
CC: syzbot <syzbot@kernel.org>, <syzkaller-bugs@googlegroups.com>,
	<linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@redhat.com>, Thomas
 Gleixner <tglx@kernel.org>, <andrealmeid@igalia.com>, <dave@stgolabs.net>,
	<dvhart@infradead.org>, <liuyongqiang13@huawei.com>, <syzbot@lists.linux.dev>
References: <515ea00f-a081-4b9a-bcb3-f5517fd4e565@mail.kernel.org>
 <20260814133803.GA687043@noisy.programming.kicks-ass.net>
 <f3ed739d-fa18-43b8-a7d7-c5f1db0e22b0@huawei.com>
 <20260818104658.GE1246887@noisy.programming.kicks-ass.net>
Content-Language: en-US
From: Yao Kai <yaokai34@huawei.com>
In-Reply-To: <20260818104658.GE1246887@noisy.programming.kicks-ass.net>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: kwepems200001.china.huawei.com (7.221.188.67) To
 dggpemr500006.china.huawei.com (7.185.36.185)



On 8/18/2026 6:46 PM, Peter Zijlstra wrote:
> On Mon, Aug 17, 2026 at 03:29:14PM +0800, Yao Kai wrote:
>> Thanks! I think there is still a lost-wakeup window:
>>
>>          T1                              T2
>>
>>          add_wait_queue()
>>            /* not visible to T2 */
>>          futex_pivot_pending()
>>            futex_ref_is_dead() = false
>>                                          futex_ref_put() = true
>>                                          wake_up_var()
>>                                            waitqueue_active() = false
>>                                              /* observes empty */
>>                                            return
>>          wait_woken()
>>          schedule()
>>
>> Since wake_up_var() uses a lockless waitqueue_active() check, I think
>> we need to order the waitqueue insertion before the first condition
>> check:
>>
>>    add_wait_queue(__wq_head, &__wbq_entry.wq_entry);
>>
>>    /*
>>     * Pairs with the fully ordered refcount operation before wake_up_var().
>>     * Ensures either the waker sees this waiter or we see the dead refcount.
>>     */
>>    smp_mb();
> 
> Well, add_wait_queue() has UNLOCK(&wq_head->lock) and
> futex_pivot_pending() has LOCK(&mmph->lock), giving an UNLOCK+LOCK
> consistency, which IIRC is RCtso if you're on PowerPC and RCsc
> everywhere else.
> 
> So yeah, this needs more. But I would instead suggest we use:
> 
> 	smp_mb__after_spinlock().
> 
> Anyway, for this to matter one way or the other, the other side of this
> also needs a barrier. But it looks like futex_ref_put() already implies
> enough. When in atomic mode it implies a full smp_mb().
> 
>>    while (!futex_pivot_pending(mm))
>>            wait_woken(&__wbq_entry.wq_entry, TASK_UNINTERRUPTIBLE,
>>                       MAX_SCHEDULE_TIMEOUT);
>>
>> The rc check can be dropped because MAX_SCHEDULE_TIMEOUT does not expire.
> 
> Indeed, I had realized this after sending :-)
> 
> Something like so then?
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
> index a7c2a6242718..bd9fb0b17ee6 100644
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
> @@ -1886,11 +1887,34 @@ static int futex_hash_allocate(unsigned int hash_slots, unsigned int flags)
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
> +
> +		/*
> +		 * add_wait_queue()		futex_ref_put()
> +		 * MB (this)			MB (implied)
> +		 * futex_pivot_pending()	wake_up_var()
> +		 *                                waitqueue_active()
> +		 *
> +		 * Notably, it must not be possible to see
> +		 * !futex_pivot_pending() && !waitqueue_active().
> +		 */
> +		smp_mb__after_spinlock();

I still think we should use smp_mb() here, smp_mb__after_spinlock() only
orders accesses preceding the lock acquisition against later accesses. The
waitqueue insertion happens after that acquisition, so I don't think
smp_mb__after_spinlock() covers it here.

> +
> +		while (!futex_pivot_pending(mm) &&
> +		       wait_woken(&__wbq_entry.wq_entry, TASK_UNINTERRUPTIBLE,
> +				  MAX_SCHEDULE_TIMEOUT))
> +			/* empty */;

Since MAX_SCHEDULE_TIMEOUT never returns zero, so I think this can be:

		while (!futex_pivot_pending(mm))
		       wait_woken(&__wbq_entry.wq_entry, TASK_UNINTERRUPTIBLE,
				  MAX_SCHEDULE_TIMEOUT));

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

Thanks,
Yao Kai

