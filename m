Received: from canpmsgout06.his.huawei.com (canpmsgout06.his.huawei.com [113.46.200.221])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6CC5B341068
	for <syzbot@lists.linux.dev>; Thu, 13 Aug 2026 04:34:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=113.46.200.221
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786595662; cv=none; b=bbl8VCj3qYMW6ENQA2T+5x8LbEV0512TFmHabg0SXZbo/LwmZPlIMCiCzsi0eCWGycElaER7Viikyul+YmuQIUv/o8Gp+mQ17EtWxtJDpkPpOmUtN6XyFJxK7ykgnvrPGIm7oaEURfG10PQPHpdoMhWZdBZWbJ28A1J3ih6dtJg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786595662; c=relaxed/simple;
	bh=F3qw5TSd9h8Wb+vDE2+aA5xGLXdGkG+16dZlNT9xiSQ=;
	h=Message-ID:Date:MIME-Version:Subject:To:CC:References:From:
	 In-Reply-To:Content-Type; b=HiiqFEyGDnrLqpnSeTJ455ygXBLwii73RSMzUCt0SdGWLlvpo98h74K4qmdjcFjGbbALQnTeSlOshfTmzvF2vcFHtSiz5HahbsEuAJ6nEG+St5LBk0WD4II9iRDFKODpbjZZF3H7hI9MKRmNg27odFqdFXhZaZNax4aHpd/n5jc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com; spf=pass smtp.mailfrom=huawei.com; dkim=pass (1024-bit key) header.d=huawei.com header.i=@huawei.com header.b=37XyP6ds; arc=none smtp.client-ip=113.46.200.221
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huawei.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=huawei.com header.i=@huawei.com header.b="37XyP6ds"
dkim-signature: v=1; a=rsa-sha256; d=huawei.com; s=dkim;
	c=relaxed/relaxed; q=dns/txt;
	h=From;
	bh=ZLvysJogFwKmPl/sdrovo6dFs/ZvSuSu7sp4ZNinopY=;
	b=37XyP6dsg6LQyTaOnIToeavkgW/ep+5dpqDjeGZ3w9Qvla2CLtEo2y7M2jFUADtWFdQSdF778
	aX6OPPm961820Lu9GSaLTdDjtFd6cBG38ICEs5/83IlZx7OXvAfTZi+k9MtDABD+vM3uKwyy5Nv
	ZpeaynLQMv2LjdvXGcq7ZLE=
Received: from mail.maildlp.com (unknown [172.19.163.0])
	by canpmsgout06.his.huawei.com (SkyGuard) with ESMTPS id 4hLC0T0y0nzRhRG;
	Thu, 13 Aug 2026 12:23:37 +0800 (CST)
Received: from dggpemr500006.china.huawei.com (unknown [7.185.36.185])
	by mail.maildlp.com (Postfix) with ESMTPS id DCB4F40537;
	Thu, 13 Aug 2026 12:34:12 +0800 (CST)
Received: from [100.103.109.15] (100.103.109.15) by
 dggpemr500006.china.huawei.com (7.185.36.185) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.45; Thu, 13 Aug 2026 12:34:12 +0800
Message-ID: <b40c74a6-b466-4032-b185-953a31f13943@huawei.com>
Date: Thu, 13 Aug 2026 12:34:11 +0800
Precedence: bulk
X-Mailing-List: syzbot@lists.linux.dev
List-Id: <syzbot.lists.linux.dev>
List-Subscribe: <mailto:syzbot+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:syzbot+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH RFC v3] futex: Fix might_sleep() warning in
 futex_pivot_pending()
To: syzbot <syzbot@kernel.org>,
	<syzkaller-upstream-moderation@googlegroups.com>
CC: <liuyongqiang13@huawei.com>, <syzbot@lists.linux.dev>
References: <6530235e-e9af-4c00-903a-bcbeb2a87efa@mail.kernel.org>
Content-Language: en-US
From: Yao Kai <yaokai34@huawei.com>
In-Reply-To: <6530235e-e9af-4c00-903a-bcbeb2a87efa@mail.kernel.org>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: kwepems100002.china.huawei.com (7.221.188.206) To
 dggpemr500006.china.huawei.com (7.185.36.185)



On 8/13/2026 12:08 PM, syzbot wrote:
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
>   <TASK>
>   __mutex_lock_common kernel/locking/mutex.c:623 [inline]
>   __mutex_lock+0x118/0x1550 kernel/locking/mutex.c:821
>   class_mutex_constructor include/linux/mutex.h:253 [inline]
>   futex_pivot_pending kernel/futex/core.c:1789 [inline]
>   futex_hash_allocate+0x7fb/0xf00 kernel/futex/core.c:1872
>   __do_sys_prctl kernel/sys.c:2885 [inline]
>   __se_sys_prctl+0x78c/0x1910 kernel/sys.c:2534
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
> Cc: stable@vger.kernel.org
> 
> Fixes: 8e7ff730dd96 ("futex: Fix race in futex_pivot_pending() during private hash resize")
> Assisted-by: Gemini:gemini-3.6-flash Gemini:gemini-3.1-pro-preview syzbot
> Reported-by: syzbot+350a93852ac854927f45@syzkaller.appspotmail.com
> Closes: https://syzkaller.appspot.com/bug?extid=350a93852ac854927f45
> Link: https://syzkaller.appspot.com/ai_job?id=89be9910-7060-43cd-8969-b14a2e87a76a
> To: <linux-kernel@vger.kernel.org>
> To: "Ingo Molnar" <mingo@redhat.com>
> To: "Thomas Gleixner" <tglx@kernel.org>
> To: "Yao Kai" <yaokai34@huawei.com>
> Cc: =?utf-8?q?Andr=C3=A9_Almeida?= <andrealmeid@igalia.com>
> Cc: "Davidlohr Bueso" <dave@stgolabs.net>
> Cc: "Darren Hart" <dvhart@infradead.org>
> Cc: "Peter Zijlstra" <peterz@infradead.org>
> 
> ---
> v3:
> - Dropped paragraph discussing busy-loop behavior when mutex is contended.
> - Added Cc: stable@vger.kernel.org tag.
> 
> v2:
> - Use WRITE_ONCE() for stores to hash_new to complement READ_ONCE() in futex_pivot_pending().
> https://lore.kernel.org/all/8adeeded-1ded-4780-aed1-739d54729566@mail.kernel.org/T/
> 
> v1:
> https://lore.kernel.org/all/1f966921-7789-4c70-92cd-ae6c4f8d5be4@mail.kernel.org/T/
> ---
> diff --git a/kernel/futex/core.c b/kernel/futex/core.c
> index 128c5752f..e84be5410 100644
> --- a/kernel/futex/core.c
> +++ b/kernel/futex/core.c
> @@ -202,7 +202,7 @@ static bool __futex_pivot_hash(struct mm_struct *mm, struct futex_private_hash *
>   	fph = rcu_dereference_protected(mmph->hash, lockdep_is_held(&mmph->lock));
>   	if (fph) {
>   		if (!futex_ref_is_dead(fph)) {
> -			mmph->hash_new = new;
> +			WRITE_ONCE(mmph->hash_new, new);
>   			return false;
>   		}
>   
> @@ -224,7 +224,7 @@ static void futex_pivot_hash(struct mm_struct *mm)
>   
>   		fph = mm->futex.phash.hash_new;
>   		if (fph) {
> -			mm->futex.phash.hash_new = NULL;
> +			WRITE_ONCE(mm->futex.phash.hash_new, NULL);
>   			__futex_pivot_hash(mm, fph);
>   		}
>   	}
> @@ -1786,12 +1786,18 @@ static bool futex_pivot_pending(struct mm_struct *mm)
>   	struct futex_mm_phash *mmph = &mm->futex.phash;
>   	struct futex_private_hash *fph;
>   
> -	guard(mutex)(&mmph->lock);
> +	guard(rcu)();
>   
> -	if (!mmph->hash_new)
> +	fph = rcu_dereference(mmph->hash);
> +	/*
> +	 * Ensure that if we see the new hash, we will also see the cleared
> +	 * hash_new pointer. Pairs with rcu_assign_pointer() in
> +	 * __futex_pivot_hash().
> +	 */
> +	smp_rmb();
> +	if (!READ_ONCE(mmph->hash_new))
>   		return true;
>   
> -	fph = rcu_dereference_raw(mmph->hash);
>   	return futex_ref_is_dead(fph);
>   }
>   
> @@ -1879,7 +1885,7 @@ static int futex_hash_allocate(unsigned int hash_slots, unsigned int flags)
>   		cur = rcu_dereference_protected(mm->futex.phash.hash,
>   						lockdep_is_held(&mm->futex.phash.lock));
>   		new = mm->futex.phash.hash_new;
> -		mm->futex.phash.hash_new = NULL;
> +		WRITE_ONCE(mm->futex.phash.hash_new, NULL);
>   
>   		if (fph) {
>   			if (cur && !cur->hash_mask) {
> @@ -1889,7 +1895,7 @@ static int futex_hash_allocate(unsigned int hash_slots, unsigned int flags)
>   				 * the second one returns here.
>   				 */
>   				free = fph;
> -				mm->futex.phash.hash_new = new;
> +				WRITE_ONCE(mm->futex.phash.hash_new, new);
>   				return -EBUSY;
>   			}
>   			if (cur && !new) {
> 
> 
> base-commit: db2ddb87143519e20a95aa36c60b36107b736a58

Thanks. The code and commit message now look good.

One formatting issue remains: Cc: stable@vger.kernel.org is separated
from the rest of the trailer block by a blank line, so it is not
recognized by git interpret-trailers.

Please move it into the contiguous trailer block, for example:

Fixes: 8e7ff730dd96 ("futex: Fix race in futex_pivot_pending() during private hash resize")
Cc: stable@vger.kernel.org
Assisted-by: ...

Please send a v4 with this fixed.
