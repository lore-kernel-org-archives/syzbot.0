Received: from mail-ot1-f53.google.com (mail-ot1-f53.google.com [209.85.210.53])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 781F533D4F3
	for <syzbot@lists.linux.dev>; Tue, 16 Dec 2025 13:22:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.53
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765891347; cv=none; b=YnmXnyQutmBNaHldnOmW5pIgQipA5DFmxbR3NNIhdfczL+lXu9BaaIMihBkRWeWZAdsquW2nwgyteuFaTGDNLWy87m3ZMCNGSMe/d+cw++7mXsb1VBTqvRoFl/F2Fz/EsznNrrlKE/JP929JwXiaed1UfS1WDhpFxOhBkqvCm5c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765891347; c=relaxed/simple;
	bh=xnN5YjvuUHLCI3XQMDTsfWcnPuPiNaFhA8dZdqsBMFw=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=VA/THJxZIsw6z1LRVLquRiOZhSqgZUPbO71qirwsnbncsm8FdTj+O5djryysLkEAhIfiukCJozzqQVIaKHpcAuv0e0YQApYiQMYo6LrUMAtKKTPLWOrtFwM25T/TRylUsYjJOqPV6gJQR9Gyhkz/3y6PloMH8lvVaBYoWiM+vVk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=12iejtXA; arc=none smtp.client-ip=209.85.210.53
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="12iejtXA"
Received: by mail-ot1-f53.google.com with SMTP id 46e09a7af769-7c75dd36b1bso3731787a34.2
        for <syzbot@lists.linux.dev>; Tue, 16 Dec 2025 05:22:25 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1765891344; x=1766496144; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=QN1RtnJTVqCZaPh8R9Vh9pW/Idk61E26AxwDHrZPl6I=;
        b=12iejtXAJSeY+cQsHO6qnOz4Vy0S/o/xt3A3yX1WGiKVRwBMl0ZLHMqM3suiyzWIz6
         rcByDAk7VysQqgsFxdJ6NfS8/WyVEqNHAHg/Jk+FMN9JPwZZCBVT+Ss5FCOWdNsbT91g
         iSU9H/kg0yS+tS36ibuwFNsltOfGqo5Vood9tZZlm3gKRZeV4Hk6C4StmQk4aK+l0HOA
         SWEgBgaYHAg2TBpby+Rjze0MNoNgd3E0Or3u9X6LKKC9GhxQ73TvYZ3z6SVHUHVgT7y5
         tRJHb/z+zfS+Jr0MCa+8No3wQ8FJnqtZTguOwQM0hNhxwDgumTmpv4uUQ4YEKry2fp5X
         UZIg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1765891344; x=1766496144;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=QN1RtnJTVqCZaPh8R9Vh9pW/Idk61E26AxwDHrZPl6I=;
        b=wIsnNIH7S6TS2zzBWO3t5HN76OEFwL5RC/Lp1KmTEQq7ImptpR2Pvs4/wkSt8EXsdf
         XsDz3rlpl8yy6uum2xbT5KYMMTMz7xzdrkbCrxmxabm+dzTsIAmKEXuXk1jVRuJ88cP/
         2Nwgbi2WQP2LqT8XaYw1N6XI3Qf5FsI9G/gZ9dE6G3D2t/NDU1ECrfMXODuyjHTXOWha
         XDlfb25TiLltd3TGJiHyPbxnFesoPMjJKhFIX85OZH3qqmxzqx/Mn8smUBdpiBMZP4FQ
         iurEBwGO5tJp8u8Fd1q9HS3m/qZBHwGqNZeYD7jXpzdBIB6A8Z62x3QY8e1ub3qhJ+oH
         o46g==
X-Forwarded-Encrypted: i=1; AJvYcCUCMkPX2z0GttUAltgNi4BMlpTVpv6fiGgIUzPV18rXdG/3qJaNSICHTpzZtttjOCg5xaH2ANw=@lists.linux.dev
X-Gm-Message-State: AOJu0YzMkYC52kAIg1wu1uG1jZkdXrwkcYcLyeWUNM6jkuAvCYX6Gydw
	OCdUK2E4nfzJaEglAtWxeEcKKk2zsbCuTxLsaQ+VZrs0xCMhw9FbiqvMKlf2wkm7RxnXbQsnCLT
	deY2G+DSAM6absVgdqjKxZxTuWvP104iy9aJQjb+Q
X-Gm-Gg: AY/fxX5H8fGmsEjYAQx0wo8BAw5fuOPBP6HkXAWklBAf35/wUGUeO5CNGM1nXXIpEva
	dORjDiIx1xw6mWpdYbSizPq1S/xYPql6KWJCDo9HVfdne+S3YbN/AdH9Zl2O0+vVxEDnQW5Viwh
	JBQKxhutTfSoAJ7t6W/EH4TpnJ12xrgwpMpRbzqntwgQ2ZtoQ4qfPylBeKseXEOUvoJyBVv4jfh
	qNQ+lWrofLpeaGnxjoju0y7CxDG+Mya8cKjA8ZdSiwGutSJCgEuaEbQqy50mv8ouXG9kkP4fjod
	KtIcXyetTiOQqcgNLXTLBnsYz34=
X-Google-Smtp-Source: AGHT+IF5kaPtW9I8pf1N8I4prcZSAqemo5u5sNIXBGZh8DXQ0w5AN+lLZIk9rGrNZ98d6dAthgRRv0OrC8A4jQAjGEQ=
X-Received: by 2002:a05:6820:4dc8:b0:657:717a:8c8 with SMTP id
 006d021491bc7-65b451681e9mr6087962eaf.3.1765891343987; Tue, 16 Dec 2025
 05:22:23 -0800 (PST)
Precedence: bulk
X-Mailing-List: syzbot@lists.linux.dev
List-Id: <syzbot.lists.linux.dev>
List-Subscribe: <mailto:syzbot+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:syzbot+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <694111a5.a70a0220.33cd7b.0135.GAE@google.com>
In-Reply-To: <694111a5.a70a0220.33cd7b.0135.GAE@google.com>
From: Aleksandr Nogikh <nogikh@google.com>
Date: Tue, 16 Dec 2025 22:22:12 +0900
X-Gm-Features: AQt7F2qgoxUgTWQFd4Leqv2Yu0ozS1dEOoF4HSfajtQDtCcjnf7KhfiCygInV58
Message-ID: <CANp29Y76e2RUWs1kqTs=GGG5Ko68yTCnLX238_wBkYgsnHwE4g@mail.gmail.com>
Subject: Re: [moderation/CI] Re: jfs: Extend the done of the window period
To: syzbot ci <syzbot+ci2c7b5ff8f50f22d0@syzkaller.appspotmail.com>
Cc: syzkaller-upstream-moderation@googlegroups.com, syzbot@lists.linux.dev
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

#syz upstream

On Tue, Dec 16, 2025 at 5:00=E2=80=AFPM syzbot ci
<syzbot+ci2c7b5ff8f50f22d0@syzkaller.appspotmail.com> wrote:
>
> syzbot ci has tested the following series
>
> [v1] jfs: Extend the done of the window period
> https://lore.kernel.org/all/tencent_2AC2ECAACC587B4E6C342D096F909424E90A@=
qq.com
> * [PATCH] jfs: Extend the done of the window period
>
> and found the following issue:
> possible deadlock in lbmIODone
>
> Full report is available here:
> https://ci.syzbot.org/series/49387e77-608d-493c-9978-8d1e9ab79507
>
> ***
>
> possible deadlock in lbmIODone
>
> tree:      torvalds
> URL:       https://kernel.googlesource.com/pub/scm/linux/kernel/git/torva=
lds/linux
> base:      d358e5254674b70f34c847715ca509e46eb81e6f
> arch:      amd64
> compiler:  Debian clang version 20.1.8 (++20250708063551+0c9f909b7976-1~e=
xp1~20250708183702.136), Debian LLD 20.1.8
> config:    https://ci.syzbot.org/builds/802e00bf-1926-4ea9-a853-4f01d10a4=
a6e/config
> C repro:   https://ci.syzbot.org/findings/784b824b-3582-4c98-a807-ff28792=
ecaac/c_repro
> syz repro: https://ci.syzbot.org/findings/784b824b-3582-4c98-a807-ff28792=
ecaac/syz_repro
>
> =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D
> WARNING: possible circular locking dependency detected
> syzkaller #0 Not tainted
> ------------------------------------------------------
> ksoftirqd/0/15 is trying to acquire lock:
> ffff888112c1f9e8 (&(log)->gclock){..-.}-{3:3}, at: lmPostGC fs/jfs/jfs_lo=
gmgr.c:810 [inline]
> ffff888112c1f9e8 (&(log)->gclock){..-.}-{3:3}, at: lbmIODone+0x681/0x17b0=
 fs/jfs/jfs_logmgr.c:2284
>
> but task is already holding lock:
> ffffffff8e396158 (jfsLCacheLock){..-.}-{3:3}, at: lbmIODone+0x92/0x17b0 f=
s/jfs/jfs_logmgr.c:2181
>
> which lock already depends on the new lock.
>
>
> the existing dependency chain (in reverse order) is:
>
> -> #1 (jfsLCacheLock){..-.}-{3:3}:
>        __raw_spin_lock_irqsave include/linux/spinlock_api_smp.h:110 [inli=
ne]
>        _raw_spin_lock_irqsave+0xa7/0xf0 kernel/locking/spinlock.c:162
>        lbmWrite+0x115/0x490 fs/jfs/jfs_logmgr.c:2022
>        lmGCwrite fs/jfs/jfs_logmgr.c:-1 [inline]
>        lmGroupCommit+0x570/0xb30 fs/jfs/jfs_logmgr.c:687
>        txCommit+0x4940/0x5430 fs/jfs/jfs_txnmgr.c:1305
>        diNewIAG fs/jfs/jfs_imap.c:2592 [inline]
>        diAllocExt fs/jfs/jfs_imap.c:1905 [inline]
>        diAllocAG+0x1770/0x1df0 fs/jfs/jfs_imap.c:1669
>        diAlloc+0x1d5/0x1680 fs/jfs/jfs_imap.c:1590
>        ialloc+0x8c/0x8f0 fs/jfs/jfs_inode.c:56
>        jfs_mkdir+0x193/0xa70 fs/jfs/namei.c:225
>        vfs_mkdir+0x512/0x5b0 fs/namei.c:5130
>        do_mkdirat+0x276/0x4b0 fs/namei.c:5164
>        __do_sys_mkdirat fs/namei.c:5186 [inline]
>        __se_sys_mkdirat fs/namei.c:5184 [inline]
>        __x64_sys_mkdirat+0x87/0xa0 fs/namei.c:5184
>        do_syscall_x64 arch/x86/entry/syscall_64.c:63 [inline]
>        do_syscall_64+0xfa/0xf80 arch/x86/entry/syscall_64.c:94
>        entry_SYSCALL_64_after_hwframe+0x77/0x7f
>
> -> #0 (&(log)->gclock){..-.}-{3:3}:
>        check_prev_add kernel/locking/lockdep.c:3165 [inline]
>        check_prevs_add kernel/locking/lockdep.c:3284 [inline]
>        validate_chain kernel/locking/lockdep.c:3908 [inline]
>        __lock_acquire+0x15a6/0x2cf0 kernel/locking/lockdep.c:5237
>        lock_acquire+0x117/0x340 kernel/locking/lockdep.c:5868
>        __raw_spin_lock_irqsave include/linux/spinlock_api_smp.h:110 [inli=
ne]
>        _raw_spin_lock_irqsave+0xa7/0xf0 kernel/locking/spinlock.c:162
>        lmPostGC fs/jfs/jfs_logmgr.c:810 [inline]
>        lbmIODone+0x681/0x17b0 fs/jfs/jfs_logmgr.c:2284
>        blk_update_request+0x57e/0xe60 block/blk-mq.c:1007
>        blk_mq_end_request+0x3e/0x70 block/blk-mq.c:1169
>        blk_complete_reqs block/blk-mq.c:1244 [inline]
>        blk_done_softirq+0x10a/0x160 block/blk-mq.c:1249
>        handle_softirqs+0x27d/0x850 kernel/softirq.c:622
>        run_ksoftirqd+0x9b/0x100 kernel/softirq.c:1063
>        smpboot_thread_fn+0x542/0xa60 kernel/smpboot.c:160
>        kthread+0x711/0x8a0 kernel/kthread.c:463
>        ret_from_fork+0x599/0xb30 arch/x86/kernel/process.c:158
>        ret_from_fork_asm+0x1a/0x30 arch/x86/entry/entry_64.S:246
>
> other info that might help us debug this:
>
>  Possible unsafe locking scenario:
>
>        CPU0                    CPU1
>        ----                    ----
>   lock(jfsLCacheLock);
>                                lock(&(log)->gclock);
>                                lock(jfsLCacheLock);
>   lock(&(log)->gclock);
>
>  *** DEADLOCK ***
>
> 1 lock held by ksoftirqd/0/15:
>  #0: ffffffff8e396158 (jfsLCacheLock){..-.}-{3:3}, at: lbmIODone+0x92/0x1=
7b0 fs/jfs/jfs_logmgr.c:2181
>
> stack backtrace:
> CPU: 0 UID: 0 PID: 15 Comm: ksoftirqd/0 Not tainted syzkaller #0 PREEMPT(=
full)
> Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS 1.16.2-debian-1.=
16.2-1 04/01/2014
> Call Trace:
>  <TASK>
>  dump_stack_lvl+0x189/0x250 lib/dump_stack.c:120
>  print_circular_bug+0x2e2/0x300 kernel/locking/lockdep.c:2043
>  check_noncircular+0x12e/0x150 kernel/locking/lockdep.c:2175
>  check_prev_add kernel/locking/lockdep.c:3165 [inline]
>  check_prevs_add kernel/locking/lockdep.c:3284 [inline]
>  validate_chain kernel/locking/lockdep.c:3908 [inline]
>  __lock_acquire+0x15a6/0x2cf0 kernel/locking/lockdep.c:5237
>  lock_acquire+0x117/0x340 kernel/locking/lockdep.c:5868
>  __raw_spin_lock_irqsave include/linux/spinlock_api_smp.h:110 [inline]
>  _raw_spin_lock_irqsave+0xa7/0xf0 kernel/locking/spinlock.c:162
>  lmPostGC fs/jfs/jfs_logmgr.c:810 [inline]
>  lbmIODone+0x681/0x17b0 fs/jfs/jfs_logmgr.c:2284
>  blk_update_request+0x57e/0xe60 block/blk-mq.c:1007
>  blk_mq_end_request+0x3e/0x70 block/blk-mq.c:1169
>  blk_complete_reqs block/blk-mq.c:1244 [inline]
>  blk_done_softirq+0x10a/0x160 block/blk-mq.c:1249
>  handle_softirqs+0x27d/0x850 kernel/softirq.c:622
>  run_ksoftirqd+0x9b/0x100 kernel/softirq.c:1063
>  smpboot_thread_fn+0x542/0xa60 kernel/smpboot.c:160
>  kthread+0x711/0x8a0 kernel/kthread.c:463
>  ret_from_fork+0x599/0xb30 arch/x86/kernel/process.c:158
>  ret_from_fork_asm+0x1a/0x30 arch/x86/entry/entry_64.S:246
>  </TASK>
>
>
> ***
>
> If these findings have caused you to resend the series or submit a
> separate fix, please add the following tag to your commit message:
>   Tested-by: syzbot@syzkaller.appspotmail.com
>
> ---
> This report is generated by a bot. It may contain errors.
> syzbot ci engineers can be reached at syzkaller@googlegroups.com.
>
> The email will later be sent to:
> [axboe@kernel.dk eadavis@qq.com jfs-discussion@lists.sourceforge.net linu=
x-block@vger.kernel.org linux-kernel@vger.kernel.org shaggy@kernel.org syzb=
ot@syzkaller.appspotmail.com syzkaller-bugs@googlegroups.com]
>
> If the report looks fine to you, reply with:
> #syz upstream
>
> --
> You received this message because you are subscribed to the Google Groups=
 "syzkaller-upstream-moderation" group.
> To unsubscribe from this group and stop receiving emails from it, send an=
 email to syzkaller-upstream-moderation+unsubscribe@googlegroups.com.
> To view this discussion visit https://groups.google.com/d/msgid/syzkaller=
-upstream-moderation/694111a5.a70a0220.33cd7b.0135.GAE%40google.com.
