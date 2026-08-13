Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2667E2472A2
	for <syzbot@lists.linux.dev>; Thu, 13 Aug 2026 03:33:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=100.103.45.18
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786591988; cv=pass; b=ctHnO757bwGdPTD0rcw8n3j5ZO/vG0hkqfUQqD6kIRn+gzvYjJP9nwPVdIAvxdffkiss4vtvRB3LWeB9MKUWal1kWflT2pAsu/tbks1sjoX4ZwHYxR5sOB7oF+ufuuOub8+q0lk6lAEDFOuonlV1xJArzN3G2u+XTilpZ7hS0MQ=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786591988; c=relaxed/simple;
	bh=KSp3xTK25WCcVRwD0ugScD9miVUUd7yHkc24kT1P6hk=;
	h=Message-ID:Date:MIME-Version:Subject:To:CC:References:From:
	 In-Reply-To:Content-Type; b=bxM9RQykMoL1LptnbuWHVggMSyo1GM/+XG5d+bIPkP8DpMQPr5H1mzYlB/9wnaY7Tcx8IFF/kZlqAUeku66egpo1NbTSqqr2d4UcUFpIeWn8uMa4TZzFp8CaQVbYnEapefjmOO9ONs0GgQOqDMI5U/pIANDzih0NFnss4TPAC98=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=huawei.com header.i=@huawei.com header.b=mn75jPQx; arc=pass smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=huawei.com header.i=@huawei.com header.b="mn75jPQx"
Received: by smtp.kernel.org (Postfix)
	id C35DD1F00A3A; Thu, 13 Aug 2026 03:33:06 +0000 (UTC)
Authentication-Results: smtp.kernel.org; arc=none smtp.remote-ip=113.46.200.224
ARC-Seal: i=1; d=kernel.org; s=arc20260519; a=rsa-sha256; cv=none;
	t=1786591986;
	b=umCXc9H+uA+SWAN7CQ7tUYmIN9XluylilmL6I37wzMg+3S3WYwv4ZXRDvcwqS0cDvFBM
	 FQ4owAUxuLtct/VzCarft1WxoM6R8HPteb6rvfXLTmUK2EgKsJ1JDRa72tLVJsfQK+AfL
	 rAqBp9nr4WlTItUjd9sSTMbmcer16aEeUbMIBQKLXgkCsYqlyk4bqk3HQ3qFY2W1//2oi
	 vc/XOdZr07qVocSYsEI4SJ1lUxe5s3ybHLS+CiQ/RbYWF2X1eAqXurRgRrO1WhVv//jgd
	 yxC0xDAfYaojpOz8eKvD+wGwbfN0/Cv4qhwFMwh0JIsczcbcibyO4r0rAVzFu/UuuOQ==
ARC-Message-Signature: i=1; d=kernel.org; s=arc20260519; a=rsa-sha256;
	c=relaxed/relaxed; t=1786591986;
	h=DMARC-Filter:dkim-signature:Received:Received:Received:Message-ID:
	 Date:MIME-Version:User-Agent:Subject:To:CC:References:
	 Content-Language:From:In-Reply-To:Content-Type:
	 Content-Transfer-Encoding:X-Originating-IP:X-ClientProxiedBy;
	bh=bHim0U+LOJkqBpFH+rPO97YdeNWHCdkxrxZxcMpqCoY=;
	b=aCxnLDf5p6MVJP1bQ+gff04I9X50aVo/IYx50gPl7XH39bXA4zBHj8EYDOiwwuX3QXuV
	 QhnumXh6TVN2mLCP4V1ANcsUabwGd1rFfjVwHu4ZHZmqB7rI5NvSvggNHSdh7rbIGnGB4
	 2Ym6n2SWVDTEsMpX9dKlCt2rSDWUKU9ZjLhiPP38IUxnseWc8vVvUuIBUdcgw7RUlWhrh
	 Z4fs+TUFZr/9+jQ79s3nBXaxNIrnesjToC08KegMF9DdGMukLWrNtexop9oj6c+KnY8mx
	 5QPJSMtJ9TgtLslcRrMe90Jd3uPYGLo0GBQeIy1ymlcJySAQbPdIWZEhjJabUH+AJbg==
ARC-Authentication-Results: i=1; smtp.kernel.org; dkim=pass header.d=huawei.com header.i=@huawei.com header.a=rsa-sha256 header.s=dkim header.b=mn75jPQx;
	dmarc=pass header.from=huawei.com;
	spf=pass smtp.mailfrom=huawei.com;
	arc=none smtp.remote-ip=113.46.200.224
Received: from canpmsgout09.his.huawei.com (canpmsgout09.his.huawei.com [113.46.200.224])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.kernel.org (Postfix) with ESMTPS id 4D5C81F000E9
	for <syzbot@kernel.org>; Thu, 13 Aug 2026 03:33:05 +0000 (UTC)
Authentication-Results: smtp.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=huawei.com header.i=@huawei.com header.a=rsa-sha256 header.s=dkim header.b=mn75jPQx
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.kernel.org 4D5C81F000E9
Authentication-Results: smtp.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com
Authentication-Results: smtp.kernel.org; spf=pass smtp.mailfrom=huawei.com
dkim-signature: v=1; a=rsa-sha256; d=huawei.com; s=dkim;
	c=relaxed/relaxed; q=dns/txt;
	h=From;
	bh=bHim0U+LOJkqBpFH+rPO97YdeNWHCdkxrxZxcMpqCoY=;
	b=mn75jPQxuhMb/9C4AQg2+BNQL7JZCjeMOv//NVfvzUfBfan28Er8CoWzQlYTCb2NXAcbUcBDU
	PGGTNmRSnfAiCXIxugJmAfE9PGjv4TKjZtY45/xZSYl5pXlssl8duMeVLHC3Z4rnFSNXuL2fFUm
	C1RddUMrbvTNWxlmEt8/gCU=
Received: from mail.maildlp.com (unknown [172.19.162.92])
	by canpmsgout09.his.huawei.com (SkyGuard) with ESMTPS id 4hL9df32sPz1cyPY;
	Thu, 13 Aug 2026 11:22:14 +0800 (CST)
Received: from dggpemr500006.china.huawei.com (unknown [7.185.36.185])
	by mail.maildlp.com (Postfix) with ESMTPS id 29A8B40586;
	Thu, 13 Aug 2026 11:32:51 +0800 (CST)
Received: from [100.103.109.15] (100.103.109.15) by
 dggpemr500006.china.huawei.com (7.185.36.185) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.45; Thu, 13 Aug 2026 11:32:50 +0800
Message-ID: <d573e389-31b8-4808-a51b-2affccd7fde1@huawei.com>
Date: Thu, 13 Aug 2026 11:32:49 +0800
Precedence: bulk
X-Mailing-List: syzbot@lists.linux.dev
List-Id: <syzbot.lists.linux.dev>
List-Subscribe: <mailto:syzbot+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:syzbot+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH RFC v2] futex: Fix might_sleep() warning in
 futex_pivot_pending()
To: syzbot <syzbot@kernel.org>,
	<syzkaller-upstream-moderation@googlegroups.com>
CC: <liuyongqiang13@huawei.com>, <syzbot@lists.linux.dev>
References: <8adeeded-1ded-4780-aed1-739d54729566@mail.kernel.org>
Content-Language: en-US
From: Yao Kai <yaokai34@huawei.com>
In-Reply-To: <8adeeded-1ded-4780-aed1-739d54729566@mail.kernel.org>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: kwepems200002.china.huawei.com (7.221.188.68) To
 dggpemr500006.china.huawei.com (7.185.36.185)



On 8/13/2026 11:15 AM, syzbot wrote:
> A recent change in commit 8e7ff730dd96 ("futex: Fix race in
> futex_pivot_pending() during private hash resize") modified
> futex_pivot_pending() to acquire a mutex to fix a race condition. However,
> futex_pivot_pending() is evaluated as a condition inside wait_var_event()
> in futex_hash_allocate(). Since wait_var_event() sets the task state to
> TASK_UNINTERRUPTIBLE before evaluating the condition, calling a blocking
> operation like mutex_lock() is invalid and triggers a might_sleep()
> warning:
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
> Furthermore, if the mutex is contended, mutex_lock() will block. When it
> acquires the lock and returns, the task state will be reset to
> TASK_RUNNING. This causes the subsequent schedule() in the wait loop to
> return immediately, leading to a busy loop that consumes 100% CPU until the
> condition is met.
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
> Link: https://syzkaller.appspot.com/ai_job?id=d25bd376-be2e-491a-a0a7-ef39dc13a9a5
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
> v2:
> - Use WRITE_ONCE() for stores to hash_new to complement READ_ONCE() in futex_pivot_pending().
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

Thanks, the WRITE_ONCE() changes address my comment and the code looks
correct.

One commit-message correction remains: mutex_lock() may restore
TASK_RUNNING when it takes the slow path, causing the immediately
following schedule() not to sleep. However, the next wait-loop iteration
sets TASK_UNINTERRUPTIBLE again, so this does not necessarily result in a
100% CPU busy loop until the condition is met. Please drop or reword that
paragraph.

Please also add:

Cc: stable@vger.kernel.org

since the commit being fixed is marked for stable.

Please send a v3 with these changes.

