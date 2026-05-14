Received: from mail-oi1-f174.google.com (mail-oi1-f174.google.com [209.85.167.174])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 20D5633D4EE
	for <syzbot@lists.linux.dev>; Thu, 14 May 2026 16:32:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.167.174
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778776377; cv=pass; b=c7fHN4jySiJWtjhBUmx8rCf3oZnttyWNhRw4acxDwCAlXGPbaLfJ9QzTe70Q+RS/HcSNPokSehKJpSPaJto2uqUp2n/k4iZEBgeFk0mkalsLCyABOyebCBCfnkQePYFN6TzGVvtFpBkw+LnQ65Jy6LjHR38V+imgenNzn+eXmdg=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778776377; c=relaxed/simple;
	bh=i1ZIERnT34fB20mhtCcrcLf642GaLRmrAXI7i0v46Fw=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=dr2hsiUHZnbZx/L4+ezHDvv/qZzwV0UI4rP2M3O63GTR9dBSx+QuUlOshzfJIVsxRbBJDyNBaTwxUwGIuAeZwjpH4Fzlos3ds/fhIKp76rqVFkXhLJ0xvuNzkj73pmU7+3Q7s4NP+E/2fYnD+ZNcNcQxlr8pqRl+2fg3pBpKd8Y=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=l6+MKLFR; arc=pass smtp.client-ip=209.85.167.174
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="l6+MKLFR"
Received: by mail-oi1-f174.google.com with SMTP id 5614622812f47-47c7b282e21so3303988b6e.1
        for <syzbot@lists.linux.dev>; Thu, 14 May 2026 09:32:55 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1778776375; cv=none;
        d=google.com; s=arc-20240605;
        b=L2vhGEHp9xZevQXFl9Ihar/PoUgcQeImQsPZy2tNNcyw7oVcTkR0qgv4u3fm5OLS9u
         h6vNpg0WwwBFff6uPQhbaoXb8zsIpPqATtNiinS9Q+ApQHsDI5pR2ZCIH1CVkhIWQugc
         piy2wtFFUMnNT8D78kLm2turKEFCeAF0csk+CMnmIBMgJTQRV3NKfzrtRQB7knCc/ipE
         SbHfL9a9jl+aJ6i47dSoapDrPo5Ptl+dH+dd4K8QLqoL75ZjQ6EHzIXVNIMZ3GIxd9LD
         HZFUoaJ7uQQ/cHHpg1mB6tMrkP0zn4wEa7VD34PU6t32WfeZGcXr6x0MoVoDwvuQA1eX
         pY0Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=ySkSpozFB+ohDA0oT8trgFar0SsVk7qSmEnslsf/QLM=;
        fh=8LVpSP++ERNVUE65Wf0DzJt80SJBZrz6QT8jnXF65NQ=;
        b=Akv4vvUpN1GszFEDYHKkg7YU7EQeAHdpj86u6q5b6r+QiNoLTLFUzsslMl6ysyBJKC
         z5kTQ6jFzndMjfhaTZIalzCauF9x0lraeHSlZ22IiJE7zsJNmLVs4E0Z+huM+goKCOog
         4MJYBZe5XsMUVEJMn2HTI/H0KU+M9rThQShmRa8dFTesRnebpDv1ODbmaDfnGSWWqPGV
         3rny2XjQBgYD1M6DBZbSoS+5da+XQyvlRHs5kwzJawMyQRtsPgIe6/ZdU7A+TgWJUkOg
         Zkit7/6JY7ZMW6w8D14AJHwgvsdVJvCjqaYz3k1NM8NNWfJcqQUGt/OSBqiExCAkf3GG
         NvEg==;
        darn=lists.linux.dev
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1778776375; x=1779381175; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=ySkSpozFB+ohDA0oT8trgFar0SsVk7qSmEnslsf/QLM=;
        b=l6+MKLFR43LsVN1iUiJnxOJLhVdplECzjLa01jzre4ev+QBqa2GA0bddMc9DYLcJFX
         4Do5gHZNJMcI8p9b7aHIwzmx/0SV5cwWVdykbz1Kwj/tBGQ2NLz4RmecfFrtAuMQVfaC
         hM/n2MiU3bQ1Gu4QEboZ2ywoZPqXgAEmQaE0ZQsKEEEPbr+00etWaxCHgAk+nouH/PMB
         mBwgwa4sEtyzVWyegrT2kUPcLLnAN+2hCFGqaUJBXJEZoLsYGDzBI/WvgqlwD6rS5tm8
         7u9VwTPBfC8ukpnoJhwBmu1i7IqZqnf96XetGgT+zSdb6duxj4srTw+3vnfEXJLxh0C3
         bkhA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1778776375; x=1779381175;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=ySkSpozFB+ohDA0oT8trgFar0SsVk7qSmEnslsf/QLM=;
        b=bhab9cAOO925v7rfftDFdTCT2eb6yMewnBow4M+RO3MPfwPH8CDmVb1lw9VJC8AozN
         7XggumXXqkpC21QDbOUDZnfhXYXKa7ciPtWmNzsKn7/4ImRB1BFOs6daYXIOYhskvzdz
         cZF6zk7moF3BurOen88ekWcaAaHWa8YO58SFLUTtT7yir7KJliqYNm12EU6+cZ4dPJnR
         SdWO3e5tlHpArSkrSQTYoT7MPPkIypmF09geenLmPpyJ6Yne5b7bWSEfnrQES94wyHwv
         TqSgRUchTT4lYurkMVmBE4VkKuhEaH12rZc8pOvtSd5m4zm3OIm/AioeEKUUH00nBiOW
         t56w==
X-Forwarded-Encrypted: i=1; AFNElJ8nrRkIEod99hr6Mu7EBqS+qE1eXnpeIWd2uu3cs1NIGTA1G5q5K11r51MAr4pWHRTL/p/WGfQ=@lists.linux.dev
X-Gm-Message-State: AOJu0YwtrcdNsHU26WPs3QxIr9rnAwL6CuZL/MLraF0L+ZciI1USeNVK
	dnEgewXpe/wzLl0bUq1chJf2iU05uRfIYF1jizawNtZPjTbIeUZ5tYsuTfCBSRorpyJVRigGW9c
	/x92QqPUUSePXpGc8w0DVv8MXM8ru4NjiDbqCvUQWuPMJOhlVmzq5i9Vr
X-Gm-Gg: Acq92OFbWctCEBzYNC1jqz2NRMU9kPimxl9usaqYS327dNWDCxogFU2u3JhYiVypW+U
	IeJsZ8LCsgNrwGlxYiyCfe+ndiZm/NCOrPFPFfV1N9cbBYdIydn/OpTsXWdUuhyARe6f2WSjybh
	lhCs2mNYRTk9oJxG4jcL0Vw3iTcmwuzNJ+jVTpjSDd/iz7uI/gsMo3eNegQ797Gu6J6UqhDp/Gi
	3TmjF4oCmniniqy0cxVLRkRRoECz8oBGx3XSf/+1R+IVGWiBPlA+IxMb1xJ1y5BKRZv1nxblrua
	EBv5W5ds0jvd0ol3vMGRP/54QYHyNzWJUSL3TjTCk1AF7wDm2nPTLOsS6GCmeZddESxI0ap/sxX
	OIndLdXk=
X-Received: by 2002:a05:6808:124e:b0:479:d2d3:a386 with SMTP id
 5614622812f47-482e569b7a8mr92415b6e.12.1778776374562; Thu, 14 May 2026
 09:32:54 -0700 (PDT)
Precedence: bulk
X-Mailing-List: syzbot@lists.linux.dev
List-Id: <syzbot.lists.linux.dev>
List-Subscribe: <mailto:syzbot+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:syzbot+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <6a05f867.170a0220.290639.01cd.GAE@google.com>
In-Reply-To: <6a05f867.170a0220.290639.01cd.GAE@google.com>
From: Aleksandr Nogikh <nogikh@google.com>
Date: Thu, 14 May 2026 18:32:42 +0200
X-Gm-Features: AVHnY4JQdTNf5DOoyDzpQvt3r5KeVwoL89C7iNk79gOd4mGVOy5wGAdTUN5rGjg
Message-ID: <CANp29Y5UmqNaV2TyRDwzZ=Z0hXeQeVYjYJ8Zp5B+iPUZGFVA7g@mail.gmail.com>
Subject: Re: [moderation/CI] Re: netfilter: ipset fixes
To: syzbot ci <syzbot+ci61c2ab2f25f83aed@syzkaller.appspotmail.com>
Cc: syzkaller-upstream-moderation@googlegroups.com, syzbot@lists.linux.dev
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

#syz upstream

On Thu, May 14, 2026 at 6:32=E2=80=AFPM syzbot ci
<syzbot+ci61c2ab2f25f83aed@syzkaller.appspotmail.com> wrote:
>
> syzbot ci has tested the following series
>
> [v7] netfilter: ipset fixes
> https://lore.kernel.org/all/20260514085519.12729-1-kadlec@netfilter.org
> * [PATCH v7 01/10] netfilter: ipset: fix a potential dump-destroy race
> * [PATCH v7 02/10] netfilter: ipset: Fix data race between add and list h=
eader in all hash types
> * [PATCH v7 03/10] netfilter: ipset: Fix data race between add and dump i=
n all hash types
> * [PATCH v7 04/10] netfilter: ipset: annotate "pos" for concurrent reader=
s/writers
> * [PATCH v7 05/10] netfilter: ipset: Don't use test_bit() in lockless RCU=
 readers in hash types
> * [PATCH v7 06/10] netfilter: ipset: Don't use test_bit() in lockless RCU=
 readers in bitmap types
> * [PATCH v7 07/10] netfilter: ipset: fix order of kfree_rcu() and rcu_ass=
ign_pointer()
> * [PATCH v7 08/10] netfilter: ipset: skip gc when resize is in progress
> * [PATCH v7 09/10] netfilter: ipset: fix potential torn read in reuse/for=
ceadd cases
> * [PATCH v7 10/10] netfilter: ipset: add comment how cidr bookkeeping is =
working
>
> and found the following issues:
> * WARNING: suspicious RCU usage in hash_ipmac4_gc
> * WARNING: suspicious RCU usage in hash_mac4_gc
> * WARNING: suspicious RCU usage in hash_netport4_gc
>
> Full report is available here:
> https://ci.syzbot.org/series/4eaa3601-8f4b-4397-8346-80b76fdcbbe3
>
> ***
>
> WARNING: suspicious RCU usage in hash_ipmac4_gc
>
> tree:      nf-next
> URL:       https://kernel.googlesource.com/pub/scm/linux/kernel/git/netfi=
lter/nf-next.git
> base:      8b2feced65cd3aa0597d596ed5733a1abd4c4d78
> arch:      amd64
> compiler:  Debian clang version 21.1.8 (++20251221033036+2078da43e25a-1~e=
xp1~20251221153213.50), Debian LLD 21.1.8
> config:    https://ci.syzbot.org/builds/0cf592b8-68f8-4eb4-a6f6-8cd4105f1=
26e/config
> syz repro: https://ci.syzbot.org/findings/3b9878ac-3e49-41d8-9981-f2c8119=
c9a04/syz_repro
>
> =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D
> WARNING: suspicious RCU usage
> syzkaller #0 Not tainted
> -----------------------------
> net/netfilter/ipset/ip_set_hash_gen.h:585 suspicious rcu_dereference_prot=
ected() usage!
>
> other info that might help us debug this:
>
>
> rcu_scheduler_active =3D 2, debug_locks =3D 1
> 2 locks held by kworker/0:0/9:
>  #0: ffff888100069d40 ((wq_completion)events_power_efficient){+.+.}-{0:0}=
, at: process_one_work kernel/workqueue.c:3277 [inline]
>  #0: ffff888100069d40 ((wq_completion)events_power_efficient){+.+.}-{0:0}=
, at: process_scheduled_works+0xa35/0x1860 kernel/workqueue.c:3385
>  #1: ffffc900000e7c40 ((work_completion)(&(&gc->dwork)->work)){+.+.}-{0:0=
}, at: process_one_work kernel/workqueue.c:3278 [inline]
>  #1: ffffc900000e7c40 ((work_completion)(&(&gc->dwork)->work)){+.+.}-{0:0=
}, at: process_scheduled_works+0xa70/0x1860 kernel/workqueue.c:3385
>
> stack backtrace:
> CPU: 0 UID: 0 PID: 9 Comm: kworker/0:0 Not tainted syzkaller #0 PREEMPT(f=
ull)
> Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS 1.16.2-debian-1.=
16.2-1 04/01/2014
> Workqueue: events_power_efficient hash_ipmac4_gc
> Call Trace:
>  <TASK>
>  dump_stack_lvl+0xe8/0x150 lib/dump_stack.c:120
>  lockdep_rcu_suspicious+0x13f/0x1d0 kernel/locking/lockdep.c:6876
>  hash_ipmac4_gc+0x324/0x3e0 net/netfilter/ipset/ip_set_hash_gen.h:585
>  process_one_work kernel/workqueue.c:3302 [inline]
>  process_scheduled_works+0xb5d/0x1860 kernel/workqueue.c:3385
>  worker_thread+0xa53/0xfc0 kernel/workqueue.c:3466
>  kthread+0x388/0x470 kernel/kthread.c:436
>  ret_from_fork+0x514/0xb70 arch/x86/kernel/process.c:158
>  ret_from_fork_asm+0x1a/0x30 arch/x86/entry/entry_64.S:245
>  </TASK>
>
>
> ***
>
> WARNING: suspicious RCU usage in hash_mac4_gc
>
> tree:      nf-next
> URL:       https://kernel.googlesource.com/pub/scm/linux/kernel/git/netfi=
lter/nf-next.git
> base:      8b2feced65cd3aa0597d596ed5733a1abd4c4d78
> arch:      amd64
> compiler:  Debian clang version 21.1.8 (++20251221033036+2078da43e25a-1~e=
xp1~20251221153213.50), Debian LLD 21.1.8
> config:    https://ci.syzbot.org/builds/0cf592b8-68f8-4eb4-a6f6-8cd4105f1=
26e/config
> syz repro: https://ci.syzbot.org/findings/446cefef-5142-4649-a8dc-3c24716=
5e5b7/syz_repro
>
> =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D
> WARNING: suspicious RCU usage
> syzkaller #0 Not tainted
> -----------------------------
> net/netfilter/ipset/ip_set_hash_gen.h:585 suspicious rcu_dereference_prot=
ected() usage!
>
> other info that might help us debug this:
>
>
> rcu_scheduler_active =3D 2, debug_locks =3D 1
> 2 locks held by kworker/0:1/10:
>  #0: ffff888100069d40 ((wq_completion)events_power_efficient){+.+.}-{0:0}=
, at: process_one_work kernel/workqueue.c:3277 [inline]
>  #0: ffff888100069d40 ((wq_completion)events_power_efficient){+.+.}-{0:0}=
, at: process_scheduled_works+0xa35/0x1860 kernel/workqueue.c:3385
>  #1: ffffc900000f7c40 ((work_completion)(&(&gc->dwork)->work)){+.+.}-{0:0=
}, at: process_one_work kernel/workqueue.c:3278 [inline]
>  #1: ffffc900000f7c40 ((work_completion)(&(&gc->dwork)->work)){+.+.}-{0:0=
}, at: process_scheduled_works+0xa70/0x1860 kernel/workqueue.c:3385
>
> stack backtrace:
> CPU: 0 UID: 0 PID: 10 Comm: kworker/0:1 Not tainted syzkaller #0 PREEMPT(=
full)
> Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS 1.16.2-debian-1.=
16.2-1 04/01/2014
> Workqueue: events_power_efficient hash_mac4_gc
> Call Trace:
>  <TASK>
>  dump_stack_lvl+0xe8/0x150 lib/dump_stack.c:120
>  lockdep_rcu_suspicious+0x13f/0x1d0 kernel/locking/lockdep.c:6876
>  hash_mac4_gc+0x324/0x3e0 net/netfilter/ipset/ip_set_hash_gen.h:585
>  process_one_work kernel/workqueue.c:3302 [inline]
>  process_scheduled_works+0xb5d/0x1860 kernel/workqueue.c:3385
>  worker_thread+0xa53/0xfc0 kernel/workqueue.c:3466
>  kthread+0x388/0x470 kernel/kthread.c:436
>  ret_from_fork+0x514/0xb70 arch/x86/kernel/process.c:158
>  ret_from_fork_asm+0x1a/0x30 arch/x86/entry/entry_64.S:245
>  </TASK>
>
>
> ***
>
> WARNING: suspicious RCU usage in hash_netport4_gc
>
> tree:      nf-next
> URL:       https://kernel.googlesource.com/pub/scm/linux/kernel/git/netfi=
lter/nf-next.git
> base:      8b2feced65cd3aa0597d596ed5733a1abd4c4d78
> arch:      amd64
> compiler:  Debian clang version 21.1.8 (++20251221033036+2078da43e25a-1~e=
xp1~20251221153213.50), Debian LLD 21.1.8
> config:    https://ci.syzbot.org/builds/0cf592b8-68f8-4eb4-a6f6-8cd4105f1=
26e/config
> syz repro: https://ci.syzbot.org/findings/7493a52e-0299-4492-9a63-c84a895=
9d94f/syz_repro
>
> =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D
> WARNING: suspicious RCU usage
> syzkaller #0 Not tainted
> -----------------------------
> net/netfilter/ipset/ip_set_hash_gen.h:585 suspicious rcu_dereference_prot=
ected() usage!
>
> other info that might help us debug this:
>
>
> rcu_scheduler_active =3D 2, debug_locks =3D 1
> 2 locks held by kworker/0:4/5744:
>  #0: ffff888100069d40 ((wq_completion)events_power_efficient){+.+.}-{0:0}=
, at: process_one_work kernel/workqueue.c:3277 [inline]
>  #0: ffff888100069d40 ((wq_completion)events_power_efficient){+.+.}-{0:0}=
, at: process_scheduled_works+0xa35/0x1860 kernel/workqueue.c:3385
>  #1: ffffc900038bfc40 ((work_completion)(&(&gc->dwork)->work)){+.+.}-{0:0=
}, at: process_one_work kernel/workqueue.c:3278 [inline]
>  #1: ffffc900038bfc40 ((work_completion)(&(&gc->dwork)->work)){+.+.}-{0:0=
}, at: process_scheduled_works+0xa70/0x1860 kernel/workqueue.c:3385
>
> stack backtrace:
> CPU: 0 UID: 0 PID: 5744 Comm: kworker/0:4 Not tainted syzkaller #0 PREEMP=
T(full)
> Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS 1.16.2-debian-1.=
16.2-1 04/01/2014
> Workqueue: events_power_efficient hash_netport4_gc
> Call Trace:
>  <TASK>
>  dump_stack_lvl+0xe8/0x150 lib/dump_stack.c:120
>  lockdep_rcu_suspicious+0x13f/0x1d0 kernel/locking/lockdep.c:6876
>  hash_netport4_gc+0x32e/0x3f0 net/netfilter/ipset/ip_set_hash_gen.h:585
>  process_one_work kernel/workqueue.c:3302 [inline]
>  process_scheduled_works+0xb5d/0x1860 kernel/workqueue.c:3385
>  worker_thread+0xa53/0xfc0 kernel/workqueue.c:3466
>  kthread+0x388/0x470 kernel/kthread.c:436
>  ret_from_fork+0x514/0xb70 arch/x86/kernel/process.c:158
>  ret_from_fork_asm+0x1a/0x30 arch/x86/entry/entry_64.S:245
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
> To test a patch for this bug, please reply with `#syz test`
> (should be on a separate line).
>
> The patch should be attached to the email.
> Note: arguments like custom git repos and branches are not supported.
>
> The email will later be sent to:
> [kadlec@netfilter.org netfilter-devel@vger.kernel.org pablo@netfilter.org=
]
>
> If the report looks fine to you, reply with:
> #syz upstream
>
> If the report is a false positive, reply with
> #syz invalid
>
> --
> You received this message because you are subscribed to the Google Groups=
 "syzkaller-upstream-moderation" group.
> To unsubscribe from this group and stop receiving emails from it, send an=
 email to syzkaller-upstream-moderation+unsubscribe@googlegroups.com.
> To view this discussion visit https://groups.google.com/d/msgid/syzkaller=
-upstream-moderation/6a05f867.170a0220.290639.01cd.GAE%40google.com.
