Received: from canpmsgout05.his.huawei.com (canpmsgout05.his.huawei.com [113.46.200.220])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F0F6B2DF3F2
	for <syzbot@lists.linux.dev>; Thu, 20 Aug 2026 07:32:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=113.46.200.220
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787211154; cv=none; b=F+5kV0Fey3pyBxh+lqZKWvdis/urrkw7K6JzVIsNxVyMAcHXU5Arr/3qD6PRmbKkJ+sDDm7AaOZFwhjzJesxphqa1k7DiB3R9FPsWuU+BmJjSELYfptnM2reYDcOvTF5oJh+sl3n1ztkSJJp11NWumObd/e9FeFcuTE/Ltll2lU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787211154; c=relaxed/simple;
	bh=AA07V00d+OpVy6HKQecOi9Hn0c6xpVeHsaAQH9NUQbw=;
	h=Message-ID:Date:MIME-Version:Subject:From:To:CC:References:
	 In-Reply-To:Content-Type; b=i9BBMjI91SHSY6lGpI4Lhyvj1MubCeyUoMbFuQGERzB/mLbc3FzJjNsKemNCIcyjeA8qjRnAc7cysCwXcn+ONw2UmeAw8M+y5vZUG6p8VbVKto5vARmP6EKXD6dxbZdWPMdpY/a7x+2o4sP1Zv08aRUeiLwN7y6Bp+xWZbGVzRA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com; spf=pass smtp.mailfrom=huawei.com; dkim=pass (1024-bit key) header.d=huawei.com header.i=@huawei.com header.b=ztFe7968; arc=none smtp.client-ip=113.46.200.220
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huawei.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=huawei.com header.i=@huawei.com header.b="ztFe7968"
dkim-signature: v=1; a=rsa-sha256; d=huawei.com; s=dkim;
	c=relaxed/relaxed; q=dns/txt;
	h=From;
	bh=fg9m5JpfD11fdiPa6MZn06FUIaZEFArNFmAug1elXwU=;
	b=ztFe7968A+hUT5uLvQvl3yD5E/6zAQtqw4jn2pIK9TfmX2Vl6+pZt2/t3+wQfDJNWbbn0sDka
	rpvVRHYNsMrbQQeF0ny1MYLRXgiRZm/KeGO30a8Z49ILVFKhfOBU8hzeJCMbN59Pjzn2Z67nRlh
	yo3we6yzTeOhrcepYQUUj2o=
Received: from mail.maildlp.com (unknown [172.19.163.0])
	by canpmsgout05.his.huawei.com (SkyGuard) with ESMTPS id 4hQZd243VVz12LDl;
	Thu, 20 Aug 2026 15:21:58 +0800 (CST)
Received: from dggpemr500006.china.huawei.com (unknown [7.185.36.185])
	by mail.maildlp.com (Postfix) with ESMTPS id 2C77940561;
	Thu, 20 Aug 2026 15:32:19 +0800 (CST)
Received: from [100.103.109.15] (100.103.109.15) by
 dggpemr500006.china.huawei.com (7.185.36.185) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.45; Thu, 20 Aug 2026 15:32:18 +0800
Message-ID: <2247c7e0-1466-4228-900c-c5b0677fba41@huawei.com>
Date: Thu, 20 Aug 2026 15:32:17 +0800
Precedence: bulk
X-Mailing-List: syzbot@lists.linux.dev
List-Id: <syzbot.lists.linux.dev>
List-Subscribe: <mailto:syzbot+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:syzbot+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] futex: Fix might_sleep() warning in futex_pivot_pending()
From: Yao Kai <yaokai34@huawei.com>
To: Peter Zijlstra <peterz@infradead.org>
CC: syzbot <syzbot@kernel.org>, <syzkaller-bugs@googlegroups.com>,
	<linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@redhat.com>, Thomas
 Gleixner <tglx@kernel.org>, <andrealmeid@igalia.com>, <dave@stgolabs.net>,
	<dvhart@infradead.org>, <liuyongqiang13@huawei.com>, <syzbot@lists.linux.dev>
References: <515ea00f-a081-4b9a-bcb3-f5517fd4e565@mail.kernel.org>
 <20260814133803.GA687043@noisy.programming.kicks-ass.net>
 <f3ed739d-fa18-43b8-a7d7-c5f1db0e22b0@huawei.com>
 <20260818104658.GE1246887@noisy.programming.kicks-ass.net>
 <681d9e21-d408-4acb-8c51-b8a86d599e0f@huawei.com>
Content-Language: en-US
In-Reply-To: <681d9e21-d408-4acb-8c51-b8a86d599e0f@huawei.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: kwepems100002.china.huawei.com (7.221.188.206) To
 dggpemr500006.china.huawei.com (7.185.36.185)



On 8/18/2026 8:24 PM, Yao Kai wrote:
> 
> 
> On 8/18/2026 6:46 PM, Peter Zijlstra wrote:
>> On Mon, Aug 17, 2026 at 03:29:14PM +0800, Yao Kai wrote:
>>> Thanks! I think there is still a lost-wakeup window:
>>>
>>>          T1                              T2
>>>
>>>          add_wait_queue()
>>>            /* not visible to T2 */
>>>          futex_pivot_pending()
>>>            futex_ref_is_dead() = false
>>>                                          futex_ref_put() = true
>>>                                          wake_up_var()
>>>                                            waitqueue_active() = false
>>>                                              /* observes empty */
>>>                                            return
>>>          wait_woken()
>>>          schedule()
>>>
>>> Since wake_up_var() uses a lockless waitqueue_active() check, I think
>>> we need to order the waitqueue insertion before the first condition
>>> check:
>>>
>>>    add_wait_queue(__wq_head, &__wbq_entry.wq_entry);
>>>
>>>    /*
>>>     * Pairs with the fully ordered refcount operation before wake_up_var().
>>>     * Ensures either the waker sees this waiter or we see the dead refcount.
>>>     */
>>>    smp_mb();
>>
>> Well, add_wait_queue() has UNLOCK(&wq_head->lock) and
>> futex_pivot_pending() has LOCK(&mmph->lock), giving an UNLOCK+LOCK
>> consistency, which IIRC is RCtso if you're on PowerPC and RCsc
>> everywhere else.
>>
>> So yeah, this needs more. But I would instead suggest we use:
>>
>>     smp_mb__after_spinlock().
>>
>> Anyway, for this to matter one way or the other, the other side of this
>> also needs a barrier. But it looks like futex_ref_put() already implies
>> enough. When in atomic mode it implies a full smp_mb().
>>
>>>    while (!futex_pivot_pending(mm))
>>>            wait_woken(&__wbq_entry.wq_entry, TASK_UNINTERRUPTIBLE,
>>>                       MAX_SCHEDULE_TIMEOUT);
>>>
>>> The rc check can be dropped because MAX_SCHEDULE_TIMEOUT does not expire.
>>
>> Indeed, I had realized this after sending :-)
>>
>> Something like so then?
>>
>> ---
>> diff --git a/include/linux/wait.h b/include/linux/wait.h
>> index dce055e6add3..7e215330199c 100644
>> --- a/include/linux/wait.h
>> +++ b/include/linux/wait.h
>> @@ -1228,6 +1228,7 @@ long prepare_to_wait_event(struct wait_queue_head *wq_head, struct wait_queue_en
>>   void finish_wait(struct wait_queue_head *wq_head, struct wait_queue_entry *wq_entry);
>>   long wait_woken(struct wait_queue_entry *wq_entry, unsigned mode, long timeout);
>>   int woken_wake_function(struct wait_queue_entry *wq_entry, unsigned mode, int sync, void *key);
>> +int woken_wake_bit_function(struct wait_queue_entry *wq_entry, unsigned mode, int sync, void *key);
>>   int autoremove_wake_function(struct wait_queue_entry *wq_entry, unsigned mode, int sync, void *key);
>>   #define DEFINE_WAIT_FUNC(name, function)                    \
>> diff --git a/include/linux/wait_bit.h b/include/linux/wait_bit.h
>> index ace7379d627d..553d7b23e3ad 100644
>> --- a/include/linux/wait_bit.h
>> +++ b/include/linux/wait_bit.h
>> @@ -32,6 +32,7 @@ int out_of_line_wait_on_bit_timeout(unsigned long *word, int, wait_bit_action_f
>>   int out_of_line_wait_on_bit_lock(unsigned long *word, int, wait_bit_action_f *action, unsigned int mode);
>>   struct wait_queue_head *bit_waitqueue(unsigned long *word, int bit);
>>   extern void __init wait_bit_init(void);
>> +extern struct wait_bit_key *__var_wake_key(struct wait_queue_entry *wq_entry, void *arg);
>>   int wake_bit_function(struct wait_queue_entry *wq_entry, unsigned mode, int sync, void *key);
>> diff --git a/kernel/futex/core.c b/kernel/futex/core.c
>> index a7c2a6242718..bd9fb0b17ee6 100644
>> --- a/kernel/futex/core.c
>> +++ b/kernel/futex/core.c
>> @@ -46,6 +46,7 @@
>>   #include <linux/slab.h>
>>   #include <linux/vmalloc.h>
>>   #include <linux/kmemleak.h>
>> +#include <linux/wait_bit.h>
>>   #include <vdso/futex.h>
>> @@ -1886,11 +1887,34 @@ static int futex_hash_allocate(unsigned int hash_slots, unsigned int flags)
>>           futex_hash_bucket_init(&fph->queues[i]);
>>       if (custom) {
>> +        struct wait_bit_queue_entry __wbq_entry;
>> +        struct wait_queue_head *__wq_head;
>> +
>>           /*
>>            * Only let prctl() wait / retry; don't unduly delay clone().
>>            */
>>   again:
>> -        wait_var_event(mm, futex_pivot_pending(mm));
>> +        __wq_head = __var_waitqueue(mm);
>> +        init_wait_var_entry(&__wbq_entry, mm, 0);
>> +        __wbq_entry.wq_entry.func = woken_wake_bit_function;
>> +        add_wait_queue(__wq_head, &__wbq_entry.wq_entry);
>> +
>> +        /*
>> +         * add_wait_queue()        futex_ref_put()
>> +         * MB (this)            MB (implied)
>> +         * futex_pivot_pending()    wake_up_var()
>> +         *                                waitqueue_active()
>> +         *
>> +         * Notably, it must not be possible to see
>> +         * !futex_pivot_pending() && !waitqueue_active().
>> +         */
>> +        smp_mb__after_spinlock();
> 
> I still think we should use smp_mb() here, smp_mb__after_spinlock() only
> orders accesses preceding the lock acquisition against later accesses. The
> waitqueue insertion happens after that acquisition, so I don't think
> smp_mb__after_spinlock() covers it here.
> 

On further thought, please disregard my previous objection to
smp_mb__after_spinlock().

I was considering the documented semantics of
smp_mb__after_spinlock() in isolation and overlooked that the full
waiter-side sequence also includes the subsequent mutex acquisition in
futex_pivot_pending():

         STORE waitqueue entry
         UNLOCK wq_head->lock
         smp_mb__after_spinlock()
         LOCK mmph->lock
         LOAD refcount

On architectures where the UNLOCK+LOCK sequence needs strengthening,
smp_mb__after_spinlock() provides the required full barrier. On
architectures where it is a no-op, the lock acquisition is already
strong enough to provide the required ordering.

So your version looks sufficient. Sorry for the noise.

>> +
>> +        while (!futex_pivot_pending(mm) &&
>> +               wait_woken(&__wbq_entry.wq_entry, TASK_UNINTERRUPTIBLE,
>> +                  MAX_SCHEDULE_TIMEOUT))
>> +            /* empty */;
> 
> Since MAX_SCHEDULE_TIMEOUT never returns zero, so I think this can be:
> 
>          while (!futex_pivot_pending(mm))
>                 wait_woken(&__wbq_entry.wq_entry, TASK_UNINTERRUPTIBLE,
>                    MAX_SCHEDULE_TIMEOUT));
> 
>> +        remove_wait_queue(__wq_head, &__wbq_entry.wq_entry);
>>       }
>>       scoped_guard(mutex, &mm->futex.phash.lock) {
>> diff --git a/kernel/sched/wait.c b/kernel/sched/wait.c
>> index 20f27e2cf7ae..d033f600f48c 100644
>> --- a/kernel/sched/wait.c
>> +++ b/kernel/sched/wait.c
>> @@ -5,6 +5,7 @@
>>    * (C) 2004 Nadia Yvette Chambers, Oracle
>>    */
>>   #include "sched.h"
>> +#include <linux/wait_bit.h>
>>   void __init_waitqueue_head(struct wait_queue_head *wq_head, const char *name, struct lock_class_key *key)
>>   {
>> @@ -463,3 +464,17 @@ int woken_wake_function(struct wait_queue_entry *wq_entry, unsigned mode, int sy
>>       return default_wake_function(wq_entry, mode, sync, key);
>>   }
>>   EXPORT_SYMBOL(woken_wake_function);
>> +
>> +int woken_wake_bit_function(struct wait_queue_entry *wq_entry, unsigned mode, int sync, void *arg)
>> +{
>> +    struct wait_bit_key *key = __var_wake_key(wq_entry, arg);
>> +    if (!key)
>> +        return 0;
>> +
>> +    /* Pairs with the smp_store_mb() in wait_woken(). */
>> +    smp_mb(); /* C */
>> +    wq_entry->flags |= WQ_FLAG_WOKEN;
>> +
>> +    return default_wake_function(wq_entry, mode, sync, key);
>> +}
>> +EXPORT_SYMBOL(woken_wake_bit_function);
>> diff --git a/kernel/sched/wait_bit.c b/kernel/sched/wait_bit.c
>> index 1088d3b7012c..e8127e83a48f 100644
>> --- a/kernel/sched/wait_bit.c
>> +++ b/kernel/sched/wait_bit.c
>> @@ -167,9 +167,7 @@ wait_queue_head_t *__var_waitqueue(void *p)
>>   }
>>   EXPORT_SYMBOL(__var_waitqueue);
>> -static int
>> -var_wake_function(struct wait_queue_entry *wq_entry, unsigned int mode,
>> -          int sync, void *arg)
>> +struct wait_bit_key *__var_wake_key(struct wait_queue_entry *wq_entry, void *arg)
>>   {
>>       struct wait_bit_key *key = arg;
>>       struct wait_bit_queue_entry *wbq_entry =
>> @@ -177,6 +175,17 @@ var_wake_function(struct wait_queue_entry *wq_entry, unsigned int mode,
>>       if (wbq_entry->key.flags != key->flags ||
>>           wbq_entry->key.bit_nr != key->bit_nr)
>> +        return NULL;
>> +
>> +    return key;
>> +}
>> +
>> +static int
>> +var_wake_function(struct wait_queue_entry *wq_entry, unsigned int mode,
>> +          int sync, void *arg)
>> +{
>> +    struct wait_bit_key *key = __var_wake_key(wq_entry, arg);
>> +    if (!key)
>>           return 0;
>>       return autoremove_wake_function(wq_entry, mode, sync, key);
> 
> Thanks,
> Yao Kai
> 

