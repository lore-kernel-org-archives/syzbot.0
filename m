Received: from mail-oi1-f172.google.com (mail-oi1-f172.google.com [209.85.167.172])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9BB893054C2
	for <syzbot@lists.linux.dev>; Tue, 14 Oct 2025 11:39:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.167.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760441963; cv=none; b=XdKs0qrHONLypIirvtlMEdB3rFQRSwgJRiG/FiVn26mNaHZ8+LMUk8F53TJyvdGLyBkVEPtp2dIV7DiVecMlm7dIaHCJgvn9zP+WW5rgBmruOeiILia+ldH4ItsP2iiXkE/zJP0tP56nQhk7HH6bdxamoQi917ov+TaaOTsgJBo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760441963; c=relaxed/simple;
	bh=OjgN/EgFRDdZgClan/heO3azu69WSCF4lsJPGSsdazQ=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=HMNKZ1VPvJT2UDmgXHXJYRVF4dc+QAoG9veWgdb3sTf7v/g6G5oNk0SzHKBnuE4LxuvXfAhmw3woeuMTonRhapnHQi4dct/WmN8tStY8K+V8j9DIWiHLtIM0OU7axA1CUt4umz0NKHl1mW0sY2REO/TZw6iTxk/zXXRZDiPpoVk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=vMw6yVl3; arc=none smtp.client-ip=209.85.167.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="vMw6yVl3"
Received: by mail-oi1-f172.google.com with SMTP id 5614622812f47-43f86ddb4b3so1352417b6e.3
        for <syzbot@lists.linux.dev>; Tue, 14 Oct 2025 04:39:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1760441959; x=1761046759; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=9PdO/sAYqcqTHf1RwoHeloN95t3ZHPenzwhy1shux/4=;
        b=vMw6yVl36/1GB+xfZBtdaLuM5R7orLeaSOoBlMlSd7y3XyBoYcuOTEQtPFDXJ0V7e8
         pIOG9eYgebZgToFoyBXaMMT3L5WO4RdYTCYS9qYtK4FgFPUWRmWC8yrUfNfCOGaPFXyl
         V3Y32TP4riDyz2c44O7sM15U2K+j5fJ2ZyDxvx6zyMsmbFI5KeaZAxg5F2izhgnnaco5
         MMGu08cgHPqWp1QhpyJ7N7hrSTuE+e47JDXEQRHiTeemUs57Cs5ptgW06/KQPNpAOule
         rZFTr22Ch4TMXOJpdJpQCXqUps89cIL9YR3cFt+lx0gvoh7Uuo4mXPo2E77DoE3uikT7
         ZfaA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1760441959; x=1761046759;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=9PdO/sAYqcqTHf1RwoHeloN95t3ZHPenzwhy1shux/4=;
        b=igbVpH560rlgz/p9H4iimWB5tuW1l7A9Uuo3soIjv+sWwfHsEN2VGUSbYGeWI0WggV
         kT/MrASdb9dMdQpZLTUGI5S5O6c0Tqm7XhAZDNp3f19K8w9Rp9cSlFBqPJIra0xrRk3r
         Ny4DULDpUXJJmy1GjHO5OxxKJxwRQFGj/DAF+zGXQ8laH+n6gUYzrmNMfwF8brl8hF34
         0v+luFz3mZh3iKMnb96lU795q+yyq8YFUa9rbRIutxgJitBPf+QmBruxQsO2/hEN4aYC
         aY2jYnwQBUZInZ1dUGgvoOjp4N+McwXKry0aPvayZDsY8THegwmUAVM/jcP7BJymJB8l
         PK2A==
X-Forwarded-Encrypted: i=1; AJvYcCVVAkZUml3zKxJtM0a/SiyvQMHhD9PSU8f/dexpOVYn1OvW55Re9TywsV9VaWFkDCafVUTRQSU=@lists.linux.dev
X-Gm-Message-State: AOJu0Yz6d/u9SsKx8QqjpGcvMHeOtDJ00Wvm50iuVtX1XhRrZtpq3L7d
	kVgBGIogrDJFWzTEyDrmXnzZ+6GbYLje0GQLWM3yEOhwQhaPPtl/59eDgSn9YbPiK4xlCMKZIut
	VgpefAy3pua91hJlHdQDPFc6+l4j4SsvS4uk9Zmt6
X-Gm-Gg: ASbGncvv/47Mzk74qchcCMtxWvDwLLeF7GL1So83tVFt3sOwXudLaRoDkdxuWwWjfKb
	CK91UwXTd09mMkTywojq90/plg2gNaEaWIqvUBI2KzXMlfgu7/g292I92nVVkT1IuWcMaxl7wJt
	DIczHTdHGerBW4eJNC4t8hQ8m8a8mioDF5ybdnkPoJ5rCZvtnxBXtpXpC2OGXQC7g6+4phjWXzQ
	SRqNiMcCmrgcGGi233lThoxa8XnAPurw/fPCLlXQDRinlGY0oy3FwczGu7CMdMdLxz4wsMenw==
X-Google-Smtp-Source: AGHT+IFCOXWL46ovFTJr0TbpUGbNHLdCIFgIwmxOI4ACsXgd9So8eTVppUetyNUm28txcNJpRXL73oE6/HUM3vv4UDg=
X-Received: by 2002:a05:6808:120a:b0:43f:20c2:5c35 with SMTP id
 5614622812f47-4417b340fedmr11894009b6e.10.1760441959204; Tue, 14 Oct 2025
 04:39:19 -0700 (PDT)
Precedence: bulk
X-Mailing-List: syzbot@lists.linux.dev
List-Id: <syzbot.lists.linux.dev>
List-Subscribe: <mailto:syzbot+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:syzbot+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <68ee2e90.050a0220.91a22.0208.GAE@google.com>
In-Reply-To: <68ee2e90.050a0220.91a22.0208.GAE@google.com>
From: Aleksandr Nogikh <nogikh@google.com>
Date: Tue, 14 Oct 2025 13:39:06 +0200
X-Gm-Features: AS18NWCmrd_B2_L4xfTr0nSsUw6UnuZkBHzydNcBkAMYmD0IynKsOa8m0x9bdVA
Message-ID: <CANp29Y7cgFdpnr-c8f6JbcZQq++RQVux8S0+7EoFYhpcahW=jg@mail.gmail.com>
Subject: Re: [moderation/CI] Re: ksm: use range-walk function to jump over
 holes in scan_get_next_rmap_item
To: syzbot ci <syzbot+ci6b368b0c129bbe12@syzkaller.appspotmail.com>
Cc: syzkaller-upstream-moderation@googlegroups.com, syzbot@lists.linux.dev
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

#syz upstream

On Tue, Oct 14, 2025 at 1:05=E2=80=AFPM syzbot ci
<syzbot+ci6b368b0c129bbe12@syzkaller.appspotmail.com> wrote:
>
> syzbot ci has tested the following series
>
> [v1] ksm: use range-walk function to jump over holes in scan_get_next_rma=
p_item
> https://lore.kernel.org/all/20251014055828.124522-1-pedrodemargomes@gmail=
.com
> * [PATCH] ksm: use range-walk function to jump over holes in scan_get_nex=
t_rmap_item
>
> and found the following issue:
> possible deadlock in __pte_offset_map_lock
>
> Full report is available here:
> https://ci.syzbot.org/series/15a341dd-23e3-4627-9fb9-00b92b7bae3f
>
> ***
>
> possible deadlock in __pte_offset_map_lock
>
> tree:      torvalds
> URL:       https://kernel.googlesource.com/pub/scm/linux/kernel/git/torva=
lds/linux
> base:      0d97f2067c166eb495771fede9f7b73999c67f66
> arch:      amd64
> compiler:  Debian clang version 20.1.8 (++20250708063551+0c9f909b7976-1~e=
xp1~20250708183702.136), Debian LLD 20.1.8
> config:    https://ci.syzbot.org/builds/31dfd455-a2ef-4c41-8f8d-172612e16=
1d9/config
> C repro:   https://ci.syzbot.org/findings/5bddd702-c879-4aa6-b86d-5be2b4b=
3d0e2/c_repro
> syz repro: https://ci.syzbot.org/findings/5bddd702-c879-4aa6-b86d-5be2b4b=
3d0e2/syz_repro
>
> =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D
> WARNING: possible circular locking dependency detected
> syzkaller #0 Not tainted
> ------------------------------------------------------
> ksmd/41 is trying to acquire lock:
> ffffffff8e245b20 (fs_reclaim){+.+.}-{0:0}, at: might_alloc include/linux/=
sched/mm.h:318 [inline]
> ffffffff8e245b20 (fs_reclaim){+.+.}-{0:0}, at: slab_pre_alloc_hook mm/slu=
b.c:4897 [inline]
> ffffffff8e245b20 (fs_reclaim){+.+.}-{0:0}, at: slab_alloc_node mm/slub.c:=
5221 [inline]
> ffffffff8e245b20 (fs_reclaim){+.+.}-{0:0}, at: kmem_cache_alloc_noprof+0x=
45/0x6e0 mm/slub.c:5252
>
> but task is already holding lock:
> ffff888112eeb8b8 (ptlock_ptr(ptdesc)#2){+.+.}-{3:3}, at: spin_lock includ=
e/linux/spinlock.h:351 [inline]
> ffff888112eeb8b8 (ptlock_ptr(ptdesc)#2){+.+.}-{3:3}, at: __pte_offset_map=
_lock+0x13e/0x210 mm/pgtable-generic.c:401
>
> which lock already depends on the new lock.
>
>
> the existing dependency chain (in reverse order) is:
>
> -> #3 (ptlock_ptr(ptdesc)#2){+.+.}-{3:3}:
>        lock_acquire+0x120/0x360 kernel/locking/lockdep.c:5868
>        __raw_spin_lock include/linux/spinlock_api_smp.h:133 [inline]
>        _raw_spin_lock+0x2e/0x40 kernel/locking/spinlock.c:154
>        spin_lock include/linux/spinlock.h:351 [inline]
>        map_pte mm/page_vma_mapped.c:72 [inline]
>        page_vma_mapped_walk+0xeea/0x20f0 mm/page_vma_mapped.c:291
>        try_to_migrate_one+0x5d8/0x34d0 mm/rmap.c:2339
>        rmap_walk_anon+0x553/0x730 mm/rmap.c:2855
>        try_to_migrate+0x319/0x3d0 mm/rmap.c:-1
>        migrate_folio_unmap mm/migrate.c:1319 [inline]
>        migrate_pages_batch+0x1432/0x35e0 mm/migrate.c:1882
>        migrate_pages+0x1d5a/0x2930 mm/migrate.c:2103
>        migrate_misplaced_folio+0x28c/0x840 mm/migrate.c:2724
>        do_numa_page mm/memory.c:6004 [inline]
>        handle_pte_fault mm/memory.c:6183 [inline]
>        __handle_mm_fault+0x3bab/0x5400 mm/memory.c:6318
>        handle_mm_fault+0x40a/0x8e0 mm/memory.c:6487
>        do_user_addr_fault+0x764/0x1380 arch/x86/mm/fault.c:1387
>        handle_page_fault arch/x86/mm/fault.c:1476 [inline]
>        exc_page_fault+0x82/0x100 arch/x86/mm/fault.c:1532
>        asm_exc_page_fault+0x26/0x30 arch/x86/include/asm/idtentry.h:623
>        __get_user_8+0x14/0x30 arch/x86/lib/getuser.S:100
>        rseq_get_rseq_cs_ptr_val kernel/rseq.c:248 [inline]
>        rseq_get_rseq_cs kernel/rseq.c:270 [inline]
>        rseq_ip_fixup kernel/rseq.c:390 [inline]
>        __rseq_handle_notify_resume+0x13d/0x1220 kernel/rseq.c:438
>        rseq_handle_notify_resume include/linux/rseq.h:44 [inline]
>        resume_user_mode_work include/linux/resume_user_mode.h:62 [inline]
>        exit_to_user_mode_loop+0xbf/0x130 kernel/entry/common.c:43
>        exit_to_user_mode_prepare include/linux/irq-entry-common.h:225 [in=
line]
>        syscall_exit_to_user_mode_work include/linux/entry-common.h:175 [i=
nline]
>        syscall_exit_to_user_mode include/linux/entry-common.h:210 [inline=
]
>        do_syscall_64+0x2bd/0xfa0 arch/x86/entry/syscall_64.c:100
>        entry_SYSCALL_64_after_hwframe+0x77/0x7f
>
> -> #2 (&anon_vma->rwsem){++++}-{4:4}:
>        lock_acquire+0x120/0x360 kernel/locking/lockdep.c:5868
>        down_write+0x96/0x1f0 kernel/locking/rwsem.c:1590
>        anon_vma_lock_write include/linux/rmap.h:122 [inline]
>        vma_prepare+0x25c/0x4b0 mm/vma.c:309
>        __split_vma+0x76e/0xa00 mm/vma.c:550
>        split_vma mm/vma.c:598 [inline]
>        vma_modify+0x13b3/0x1970 mm/vma.c:1631
>        vma_modify_flags+0x1e8/0x230 mm/vma.c:1649
>        mprotect_fixup+0x407/0x9c0 mm/mprotect.c:816
>        do_mprotect_pkey+0x8c5/0xcd0 mm/mprotect.c:990
>        __do_sys_mprotect mm/mprotect.c:1011 [inline]
>        __se_sys_mprotect mm/mprotect.c:1008 [inline]
>        __x64_sys_mprotect+0x80/0x90 mm/mprotect.c:1008
>        do_syscall_x64 arch/x86/entry/syscall_64.c:63 [inline]
>        do_syscall_64+0xfa/0xfa0 arch/x86/entry/syscall_64.c:94
>        entry_SYSCALL_64_after_hwframe+0x77/0x7f
>
> -> #1 (&mapping->i_mmap_rwsem){++++}-{4:4}:
>        lock_acquire+0x120/0x360 kernel/locking/lockdep.c:5868
>        down_write+0x96/0x1f0 kernel/locking/rwsem.c:1590
>        i_mmap_lock_write include/linux/fs.h:548 [inline]
>        dma_resv_lockdep+0x2f6/0x5b0 drivers/dma-buf/dma-resv.c:797
>        do_one_initcall+0x236/0x820 init/main.c:1283
>        do_initcall_level+0x104/0x190 init/main.c:1345
>        do_initcalls+0x59/0xa0 init/main.c:1361
>        kernel_init_freeable+0x334/0x4b0 init/main.c:1593
>        kernel_init+0x1d/0x1d0 init/main.c:1483
>        ret_from_fork+0x4bc/0x870 arch/x86/kernel/process.c:158
>        ret_from_fork_asm+0x1a/0x30 arch/x86/entry/entry_64.S:245
>
> -> #0 (fs_reclaim){+.+.}-{0:0}:
>        check_prev_add kernel/locking/lockdep.c:3165 [inline]
>        check_prevs_add kernel/locking/lockdep.c:3284 [inline]
>        validate_chain+0xb9b/0x2140 kernel/locking/lockdep.c:3908
>        __lock_acquire+0xab9/0xd20 kernel/locking/lockdep.c:5237
>        lock_acquire+0x120/0x360 kernel/locking/lockdep.c:5868
>        __fs_reclaim_acquire mm/page_alloc.c:4269 [inline]
>        fs_reclaim_acquire+0x72/0x100 mm/page_alloc.c:4283
>        might_alloc include/linux/sched/mm.h:318 [inline]
>        slab_pre_alloc_hook mm/slub.c:4897 [inline]
>        slab_alloc_node mm/slub.c:5221 [inline]
>        kmem_cache_alloc_noprof+0x45/0x6e0 mm/slub.c:5252
>        alloc_rmap_item mm/ksm.c:565 [inline]
>        get_next_rmap_item mm/ksm.c:2378 [inline]
>        ksm_pte_entry+0x414/0xa60 mm/ksm.c:2501
>        walk_pte_range_inner+0x1ba/0x380 mm/pagewalk.c:50
>        walk_pte_range mm/pagewalk.c:88 [inline]
>        walk_pmd_range mm/pagewalk.c:155 [inline]
>        walk_pud_range mm/pagewalk.c:224 [inline]
>        walk_p4d_range mm/pagewalk.c:262 [inline]
>        walk_pgd_range+0x12bf/0x1d40 mm/pagewalk.c:303
>        __walk_page_range+0x14c/0x710 mm/pagewalk.c:410
>        walk_page_range_mm+0x454/0x660 mm/pagewalk.c:506
>        scan_get_next_rmap_item mm/ksm.c:2605 [inline]
>        ksm_do_scan+0x60c/0x5c10 mm/ksm.c:2681
>        ksm_scan_thread+0x10b/0x4b0 mm/ksm.c:2706
>        kthread+0x711/0x8a0 kernel/kthread.c:463
>        ret_from_fork+0x4bc/0x870 arch/x86/kernel/process.c:158
>        ret_from_fork_asm+0x1a/0x30 arch/x86/entry/entry_64.S:245
>
> other info that might help us debug this:
>
> Chain exists of:
>   fs_reclaim --> &anon_vma->rwsem --> ptlock_ptr(ptdesc)#2
>
>  Possible unsafe locking scenario:
>
>        CPU0                    CPU1
>        ----                    ----
>   lock(ptlock_ptr(ptdesc)#2);
>                                lock(&anon_vma->rwsem);
>                                lock(ptlock_ptr(ptdesc)#2);
>   lock(fs_reclaim);
>
>  *** DEADLOCK ***
>
> 4 locks held by ksmd/41:
>  #0: ffffffff8e259b88 (ksm_thread_mutex){+.+.}-{4:4}, at: ksm_scan_thread=
+0xc8/0x4b0 mm/ksm.c:2703
>  #1: ffff8881703b9760 (&mm->mmap_lock){++++}-{4:4}, at: mmap_read_lock in=
clude/linux/mmap_lock.h:368 [inline]
>  #1: ffff8881703b9760 (&mm->mmap_lock){++++}-{4:4}, at: scan_get_next_rma=
p_item mm/ksm.c:2596 [inline]
>  #1: ffff8881703b9760 (&mm->mmap_lock){++++}-{4:4}, at: ksm_do_scan+0x578=
/0x5c10 mm/ksm.c:2681
>  #2: ffffffff8e13d320 (rcu_read_lock){....}-{1:3}, at: rcu_lock_acquire i=
nclude/linux/rcupdate.h:331 [inline]
>  #2: ffffffff8e13d320 (rcu_read_lock){....}-{1:3}, at: rcu_read_lock incl=
ude/linux/rcupdate.h:867 [inline]
>  #2: ffffffff8e13d320 (rcu_read_lock){....}-{1:3}, at: ___pte_offset_map+=
0x29/0x250 mm/pgtable-generic.c:286
>  #3: ffff888112eeb8b8 (ptlock_ptr(ptdesc)#2){+.+.}-{3:3}, at: spin_lock i=
nclude/linux/spinlock.h:351 [inline]
>  #3: ffff888112eeb8b8 (ptlock_ptr(ptdesc)#2){+.+.}-{3:3}, at: __pte_offse=
t_map_lock+0x13e/0x210 mm/pgtable-generic.c:401
>
> stack backtrace:
> CPU: 1 UID: 0 PID: 41 Comm: ksmd Not tainted syzkaller #0 PREEMPT(full)
> Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS 1.16.2-debian-1.=
16.2-1 04/01/2014
> Call Trace:
>  <TASK>
>  dump_stack_lvl+0x189/0x250 lib/dump_stack.c:120
>  print_circular_bug+0x2ee/0x310 kernel/locking/lockdep.c:2043
>  check_noncircular+0x134/0x160 kernel/locking/lockdep.c:2175
>  check_prev_add kernel/locking/lockdep.c:3165 [inline]
>  check_prevs_add kernel/locking/lockdep.c:3284 [inline]
>  validate_chain+0xb9b/0x2140 kernel/locking/lockdep.c:3908
>  __lock_acquire+0xab9/0xd20 kernel/locking/lockdep.c:5237
>  lock_acquire+0x120/0x360 kernel/locking/lockdep.c:5868
>  __fs_reclaim_acquire mm/page_alloc.c:4269 [inline]
>  fs_reclaim_acquire+0x72/0x100 mm/page_alloc.c:4283
>  might_alloc include/linux/sched/mm.h:318 [inline]
>  slab_pre_alloc_hook mm/slub.c:4897 [inline]
>  slab_alloc_node mm/slub.c:5221 [inline]
>  kmem_cache_alloc_noprof+0x45/0x6e0 mm/slub.c:5252
>  alloc_rmap_item mm/ksm.c:565 [inline]
>  get_next_rmap_item mm/ksm.c:2378 [inline]
>  ksm_pte_entry+0x414/0xa60 mm/ksm.c:2501
>  walk_pte_range_inner+0x1ba/0x380 mm/pagewalk.c:50
>  walk_pte_range mm/pagewalk.c:88 [inline]
>  walk_pmd_range mm/pagewalk.c:155 [inline]
>  walk_pud_range mm/pagewalk.c:224 [inline]
>  walk_p4d_range mm/pagewalk.c:262 [inline]
>  walk_pgd_range+0x12bf/0x1d40 mm/pagewalk.c:303
>  __walk_page_range+0x14c/0x710 mm/pagewalk.c:410
>  walk_page_range_mm+0x454/0x660 mm/pagewalk.c:506
>  scan_get_next_rmap_item mm/ksm.c:2605 [inline]
>  ksm_do_scan+0x60c/0x5c10 mm/ksm.c:2681
>  ksm_scan_thread+0x10b/0x4b0 mm/ksm.c:2706
>  kthread+0x711/0x8a0 kernel/kthread.c:463
>  ret_from_fork+0x4bc/0x870 arch/x86/kernel/process.c:158
>  ret_from_fork_asm+0x1a/0x30 arch/x86/entry/entry_64.S:245
>  </TASK>
> BUG: sleeping function called from invalid context at ./include/linux/sch=
ed/mm.h:321
> in_atomic(): 1, irqs_disabled(): 0, non_block: 0, pid: 41, name: ksmd
> preempt_count: 1, expected: 0
> RCU nest depth: 1, expected: 0
> INFO: lockdep is turned off.
> Preemption disabled at:
> [<0000000000000000>] 0x0
> CPU: 1 UID: 0 PID: 41 Comm: ksmd Not tainted syzkaller #0 PREEMPT(full)
> Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS 1.16.2-debian-1.=
16.2-1 04/01/2014
> Call Trace:
>  <TASK>
>  dump_stack_lvl+0x189/0x250 lib/dump_stack.c:120
>  __might_resched+0x495/0x610 kernel/sched/core.c:8925
>  might_alloc include/linux/sched/mm.h:321 [inline]
>  slab_pre_alloc_hook mm/slub.c:4897 [inline]
>  slab_alloc_node mm/slub.c:5221 [inline]
>  kmem_cache_alloc_noprof+0x65/0x6e0 mm/slub.c:5252
>  alloc_rmap_item mm/ksm.c:565 [inline]
>  get_next_rmap_item mm/ksm.c:2378 [inline]
>  ksm_pte_entry+0x414/0xa60 mm/ksm.c:2501
>  walk_pte_range_inner+0x1ba/0x380 mm/pagewalk.c:50
>  walk_pte_range mm/pagewalk.c:88 [inline]
>  walk_pmd_range mm/pagewalk.c:155 [inline]
>  walk_pud_range mm/pagewalk.c:224 [inline]
>  walk_p4d_range mm/pagewalk.c:262 [inline]
>  walk_pgd_range+0x12bf/0x1d40 mm/pagewalk.c:303
>  __walk_page_range+0x14c/0x710 mm/pagewalk.c:410
>  walk_page_range_mm+0x454/0x660 mm/pagewalk.c:506
>  scan_get_next_rmap_item mm/ksm.c:2605 [inline]
>  ksm_do_scan+0x60c/0x5c10 mm/ksm.c:2681
>  ksm_scan_thread+0x10b/0x4b0 mm/ksm.c:2706
>  kthread+0x711/0x8a0 kernel/kthread.c:463
>  ret_from_fork+0x4bc/0x870 arch/x86/kernel/process.c:158
>  ret_from_fork_asm+0x1a/0x30 arch/x86/entry/entry_64.S:245
>  </TASK>
> BUG: sleeping function called from invalid context at ./include/linux/sch=
ed/mm.h:321
> in_atomic(): 1, irqs_disabled(): 0, non_block: 0, pid: 41, name: ksmd
> preempt_count: 1, expected: 0
> RCU nest depth: 1, expected: 0
> INFO: lockdep is turned off.
> Preemption disabled at:
> [<0000000000000000>] 0x0
> CPU: 1 UID: 0 PID: 41 Comm: ksmd Tainted: G        W           syzkaller =
#0 PREEMPT(full)
> Tainted: [W]=3DWARN
> Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS 1.16.2-debian-1.=
16.2-1 04/01/2014
> Call Trace:
>  <TASK>
>  dump_stack_lvl+0x189/0x250 lib/dump_stack.c:120
>  __might_resched+0x495/0x610 kernel/sched/core.c:8925
>  might_alloc include/linux/sched/mm.h:321 [inline]
>  slab_pre_alloc_hook mm/slub.c:4897 [inline]
>  slab_alloc_node mm/slub.c:5221 [inline]
>  kmem_cache_alloc_noprof+0x65/0x6e0 mm/slub.c:5252
>  alloc_rmap_item mm/ksm.c:565 [inline]
>  get_next_rmap_item mm/ksm.c:2378 [inline]
>  ksm_pte_entry+0x414/0xa60 mm/ksm.c:2501
>  walk_pte_range_inner+0x1ba/0x380 mm/pagewalk.c:50
>  walk_pte_range mm/pagewalk.c:88 [inline]
>  walk_pmd_range mm/pagewalk.c:155 [inline]
>  walk_pud_range mm/pagewalk.c:224 [inline]
>  walk_p4d_range mm/pagewalk.c:262 [inline]
>  walk_pgd_range+0x12bf/0x1d40 mm/pagewalk.c:303
>  __walk_page_range+0x14c/0x710 mm/pagewalk.c:410
>  walk_page_range_mm+0x454/0x660 mm/pagewalk.c:506
>  scan_get_next_rmap_item mm/ksm.c:2605 [inline]
>  ksm_do_scan+0x60c/0x5c10 mm/ksm.c:2681
>  ksm_scan_thread+0x10b/0x4b0 mm/ksm.c:2706
>  kthread+0x711/0x8a0 kernel/kthread.c:463
>  ret_from_fork+0x4bc/0x870 arch/x86/kernel/process.c:158
>  ret_from_fork_asm+0x1a/0x30 arch/x86/entry/entry_64.S:245
>  </TASK>
> BUG: sleeping function called from invalid context at ./include/linux/sch=
ed/mm.h:321
> in_atomic(): 1, irqs_disabled(): 0, non_block: 0, pid: 41, name: ksmd
> preempt_count: 1, expected: 0
> RCU nest depth: 1, expected: 0
> INFO: lockdep is turned off.
> Preemption disabled at:
> [<0000000000000000>] 0x0
> CPU: 0 UID: 0 PID: 41 Comm: ksmd Tainted: G        W           syzkaller =
#0 PREEMPT(full)
> Tainted: [W]=3DWARN
> Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS 1.16.2-debian-1.=
16.2-1 04/01/2014
> Call Trace:
>  <TASK>
>  dump_stack_lvl+0x189/0x250 lib/dump_stack.c:120
>  __might_resched+0x495/0x610 kernel/sched/core.c:8925
>  might_alloc include/linux/sched/mm.h:321 [inline]
>  slab_pre_alloc_hook mm/slub.c:4897 [inline]
>  slab_alloc_node mm/slub.c:5221 [inline]
>  kmem_cache_alloc_noprof+0x65/0x6e0 mm/slub.c:5252
>  alloc_rmap_item mm/ksm.c:565 [inline]
>  get_next_rmap_item mm/ksm.c:2378 [inline]
>  ksm_pte_entry+0x414/0xa60 mm/ksm.c:2501
>  walk_pte_range_inner+0x1ba/0x380 mm/pagewalk.c:50
>  walk_pte_range mm/pagewalk.c:88 [inline]
>  walk_pmd_range mm/pagewalk.c:155 [inline]
>  walk_pud_range mm/pagewalk.c:224 [inline]
>  walk_p4d_range mm/pagewalk.c:262 [inline]
>  walk_pgd_range+0x12bf/0x1d40 mm/pagewalk.c:303
>  __walk_page_range+0x14c/0x710 mm/pagewalk.c:410
>  walk_page_range_mm+0x454/0x660 mm/pagewalk.c:506
>  scan_get_next_rmap_item mm/ksm.c:2605 [inline]
>  ksm_do_scan+0x60c/0x5c10 mm/ksm.c:2681
>  ksm_scan_thread+0x10b/0x4b0 mm/ksm.c:2706
>  kthread+0x711/0x8a0 kernel/kthread.c:463
>  ret_from_fork+0x4bc/0x870 arch/x86/kernel/process.c:158
>  ret_from_fork_asm+0x1a/0x30 arch/x86/entry/entry_64.S:245
>  </TASK>
> BUG: sleeping function called from invalid context at ./include/linux/sch=
ed/mm.h:321
> in_atomic(): 1, irqs_disabled(): 0, non_block: 0, pid: 41, name: ksmd
> preempt_count: 1, expected: 0
> RCU nest depth: 1, expected: 0
> INFO: lockdep is turned off.
> Preemption disabled at:
> [<0000000000000000>] 0x0
> CPU: 0 UID: 0 PID: 41 Comm: ksmd Tainted: G        W           syzkaller =
#0 PREEMPT(full)
> Tainted: [W]=3DWARN
> Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS 1.16.2-debian-1.=
16.2-1 04/01/2014
> Call Trace:
>  <TASK>
>  dump_stack_lvl+0x189/0x250 lib/dump_stack.c:120
>  __might_resched+0x495/0x610 kernel/sched/core.c:8925
>  might_alloc include/linux/sched/mm.h:321 [inline]
>  slab_pre_alloc_hook mm/slub.c:4897 [inline]
>  slab_alloc_node mm/slub.c:5221 [inline]
>  kmem_cache_alloc_noprof+0x65/0x6e0 mm/slub.c:5252
>  alloc_rmap_item mm/ksm.c:565 [inline]
>  get_next_rmap_item mm/ksm.c:2378 [inline]
>  ksm_pte_entry+0x414/0xa60 mm/ksm.c:2501
>  walk_pte_range_inner+0x1ba/0x380 mm/pagewalk.c:50
>  walk_pte_range mm/pagewalk.c:88 [inline]
>  walk_pmd_range mm/pagewalk.c:155 [inline]
>  walk_pud_range mm/pagewalk.c:224 [inline]
>  walk_p4d_range mm/pagewalk.c:262 [inline]
>  walk_pgd_range+0x12bf/0x1d40 mm/pagewalk.c:303
>  __walk_page_range+0x14c/0x710 mm/pagewalk.c:410
>  walk_page_range_mm+0x454/0x660 mm/pagewalk.c:506
>  scan_get_next_rmap_item mm/ksm.c:2605 [inline]
>  ksm_do_scan+0x60c/0x5c10 mm/ksm.c:2681
>  ksm_scan_thread+0x10b/0x4b0 mm/ksm.c:2706
>  kthread+0x711/0x8a0 kernel/kthread.c:463
>  ret_from_fork+0x4bc/0x870 arch/x86/kernel/process.c:158
>  ret_from_fork_asm+0x1a/0x30 arch/x86/entry/entry_64.S:245
>  </TASK>
> BUG: sleeping function called from invalid context at ./include/linux/sch=
ed/mm.h:321
> in_atomic(): 1, irqs_disabled(): 0, non_block: 0, pid: 41, name: ksmd
> preempt_count: 1, expected: 0
> RCU nest depth: 1, expected: 0
> INFO: lockdep is turned off.
> Preemption disabled at:
> [<0000000000000000>] 0x0
> CPU: 1 UID: 0 PID: 41 Comm: ksmd Tainted: G        W           syzkaller =
#0 PREEMPT(full)
> Tainted: [W]=3DWARN
> Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS 1.16.2-debian-1.=
16.2-1 04/01/2014
> Call Trace:
>  <TASK>
>  dump_stack_lvl+0x189/0x250 lib/dump_stack.c:120
>  __might_resched+0x495/0x610 kernel/sched/core.c:8925
>  might_alloc include/linux/sched/mm.h:321 [inline]
>  slab_pre_alloc_hook mm/slub.c:4897 [inline]
>  slab_alloc_node mm/slub.c:5221 [inline]
>  kmem_cache_alloc_noprof+0x65/0x6e0 mm/slub.c:5252
>  alloc_rmap_item mm/ksm.c:565 [inline]
>  get_next_rmap_item mm/ksm.c:2378 [inline]
>  ksm_pte_entry+0x414/0xa60 mm/ksm.c:2501
>  walk_pte_range_inner+0x1ba/0x380 mm/pagewalk.c:50
>  walk_pte_range mm/pagewalk.c:88 [inline]
>  walk_pmd_range mm/pagewalk.c:155 [inline]
>  walk_pud_range mm/pagewalk.c:224 [inline]
>  walk_p4d_range mm/pagewalk.c:262 [inline]
>  walk_pgd_range+0x12bf/0x1d40 mm/pagewalk.c:303
>  __walk_page_range+0x14c/0x710 mm/pagewalk.c:410
>  walk_page_range_mm+0x454/0x660 mm/pagewalk.c:506
>  scan_get_next_rmap_item mm/ksm.c:2605 [inline]
>  ksm_do_scan+0x60c/0x5c10 mm/ksm.c:2681
>  ksm_scan_thread+0x10b/0x4b0 mm/ksm.c:2706
>  kthread+0x711/0x8a0 kernel/kthread.c:463
>  ret_from_fork+0x4bc/0x870 arch/x86/kernel/process.c:158
>  ret_from_fork_asm+0x1a/0x30 arch/x86/entry/entry_64.S:245
>  </TASK>
> BUG: sleeping function called from invalid context at ./include/linux/sch=
ed/mm.h:321
> in_atomic(): 1, irqs_disabled(): 0, non_block: 0, pid: 41, name: ksmd
> preempt_count: 1, expected: 0
> RCU nest depth: 1, expected: 0
> INFO: lockdep is turned off.
> Preemption disabled at:
> [<0000000000000000>] 0x0
> CPU: 0 UID: 0 PID: 41 Comm: ksmd Tainted: G        W           syzkaller =
#0 PREEMPT(full)
> Tainted: [W]=3DWARN
> Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS 1.16.2-debian-1.=
16.2-1 04/01/2014
> Call Trace:
>  <TASK>
>  dump_stack_lvl+0x189/0x250 lib/dump_stack.c:120
>  __might_resched+0x495/0x610 kernel/sched/core.c:8925
>  might_alloc include/linux/sched/mm.h:321 [inline]
>  slab_pre_alloc_hook mm/slub.c:4897 [inline]
>  slab_alloc_node mm/slub.c:5221 [inline]
>  kmem_cache_alloc_noprof+0x65/0x6e0 mm/slub.c:5252
>  alloc_rmap_item mm/ksm.c:565 [inline]
>  get_next_rmap_item mm/ksm.c:2378 [inline]
>  ksm_pte_entry+0x414/0xa60 mm/ksm.c:2501
>  walk_pte_range_inner+0x1ba/0x380 mm/pagewalk.c:50
>  walk_pte_range mm/pagewalk.c:88 [inline]
>  walk_pmd_range mm/pagewalk.c:155 [inline]
>  walk_pud_range mm/pagewalk.c:224 [inline]
>  walk_p4d_range mm/pagewalk.c:262 [inline]
>  walk_pgd_range+0x12bf/0x1d40 mm/pagewalk.c:303
>  __walk_page_range+0x14c/0x710 mm/pagewalk.c:410
>  walk_page_range_mm+0x454/0x660 mm/pagewalk.c:506
>  scan_get_next_rmap_item mm/ksm.c:2605 [inline]
>  ksm_do_scan+0x60c/0x5c10 mm/ksm.c:2681
>  ksm_scan_thread+0x10b/0x4b0 mm/ksm.c:2706
>  kthread+0x711/0x8a0 kernel/kthread.c:463
>  ret_from_fork+0x4bc/0x870 arch/x86/kernel/process.c:158
>  ret_from_fork_asm+0x1a/0x30 arch/x86/entry/entry_64.S:245
>  </TASK>
> BUG: sleeping function called from invalid context at ./include/linux/sch=
ed/mm.h:321
> in_atomic(): 1, irqs_disabled(): 0, non_block: 0, pid: 41, name: ksmd
> preempt_count: 1, expected: 0
> RCU nest depth: 1, expected: 0
> INFO: lockdep is turned off.
> Preemption disabled at:
> [<0000000000000000>] 0x0
> CPU: 1 UID: 0 PID: 41 Comm: ksmd Tainted: G        W           syzkaller =
#0 PREEMPT(full)
> Tainted: [W]=3DWARN
> Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS 1.16.2-debian-1.=
16.2-1 04/01/2014
> Call Trace:
>  <TASK>
>  dump_stack_lvl+0x189/0x250 lib/dump_stack.c:120
>  __might_resched+0x495/0x610 kernel/sched/core.c:8925
>  might_alloc include/linux/sched/mm.h:321 [inline]
>  slab_pre_alloc_hook mm/slub.c:4897 [inline]
>  slab_alloc_node mm/slub.c:5221 [inline]
>  kmem_cache_alloc_noprof+0x65/0x6e0 mm/slub.c:5252
>  alloc_rmap_item mm/ksm.c:565 [inline]
>  get_next_rmap_item mm/ksm.c:2378 [inline]
>  ksm_pte_entry+0x414/0xa60 mm/ksm.c:2501
>  walk_pte_range_inner+0x1ba/0x380 mm/pagewalk.c:50
>  walk_pte_range mm/pagewalk.c:88 [inline]
>  walk_pmd_range mm/pagewalk.c:155 [inline]
>  walk_pud_range mm/pagewalk.c:224 [inline]
>  walk_p4d_range mm/pagewalk.c:262 [inline]
>  walk_pgd_range+0x12bf/0x1d40 mm/pagewalk.c:303
>  __walk_page_range+0x14c/0x710 mm/pagewalk.c:410
>  walk_page_range_mm+0x454/0x660 mm/pagewalk.c:506
>  scan_get_next_rmap_item mm/ksm.c:2605 [inline]
>  ksm_do_scan+0x60c/0x5c10 mm/ksm.c:2681
>  ksm_scan_thread+0x10b/0x4b0 mm/ksm.c:2706
>  kthread+0x711/0x8a0 kernel/kthread.c:463
>  ret_from_fork+0x4bc/0x870 arch/x86/kernel/process.c:158
>  ret_from_fork_asm+0x1a/0x30 arch/x86/entry/entry_64.S:245
>  </TASK>
> BUG: sleeping function called from invalid context at ./include/linux/sch=
ed/mm.h:321
> in_atomic(): 1, irqs_disabled(): 0, non_block: 0, pid: 41, name: ksmd
> preempt_count: 1, expected: 0
> RCU nest depth: 1, expected: 0
> INFO: lockdep is turned off.
> Preemption disabled at:
> [<0000000000000000>] 0x0
> CPU: 0 UID: 0 PID: 41 Comm: ksmd Tainted: G        W           syzkaller =
#0 PREEMPT(full)
> Tainted: [W]=3DWARN
> Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS 1.16.2-debian-1.=
16.2-1 04/01/2014
> Call Trace:
>  <TASK>
>  dump_stack_lvl+0x189/0x250 lib/dump_stack.c:120
>  __might_resched+0x495/0x610 kernel/sched/core.c:8925
>  might_alloc include/linux/sched/mm.h:321 [inline]
>  slab_pre_alloc_hook mm/slub.c:4897 [inline]
>  slab_alloc_node mm/slub.c:5221 [inline]
>  kmem_cache_alloc_noprof+0x65/0x6e0 mm/slub.c:5252
>  alloc_rmap_item mm/ksm.c:565 [inline]
>  get_next_rmap_item mm/ksm.c:2378 [inline]
>  ksm_pte_entry+0x414/0xa60 mm/ksm.c:2501
>  walk_pte_range_inner+0x1ba/0x380 mm/pagewalk.c:50
>  walk_pte_range mm/pagewalk.c:88 [inline]
>  walk_pmd_range mm/pagewalk.c:155 [inline]
>  walk_pud_range mm/pagewalk.c:224 [inline]
>  walk_p4d_range mm/pagewalk.c:262 [inline]
>  walk_pgd_range+0x12bf/0x1d40 mm/pagewalk.c:303
>  __walk_page_range+0x14c/0x710 mm/pagewalk.c:410
>  walk_page_range_mm+0x454/0x660 mm/pagewalk.c:506
>  scan_get_next_rmap_item mm/ksm.c:2605 [inline]
>  ksm_do_scan+0x60c/0x5c10 mm/ksm.c:2681
>  ksm_scan_thread+0x10b/0x4b0 mm/ksm.c:2706
>  kthread+0x711/0x8a0 kernel/kthread.c:463
>  ret_from_fork+0x4bc/0x870 arch/x86/kernel/process.c:158
>  ret_from_fork_asm+0x1a/0x30 arch/x86/entry/entry_64.S:245
>  </TASK>
> BUG: sleeping function called from invalid context at ./include/linux/sch=
ed/mm.h:321
> in_atomic(): 1, irqs_disabled(): 0, non_block: 0, pid: 41, name: ksmd
> preempt_count: 1, expected: 0
> RCU nest depth: 1, expected: 0
> INFO: lockdep is turned off.
> Preemption disabled at:
> [<0000000000000000>] 0x0
> CPU: 1 UID: 0 PID: 41 Comm: ksmd Tainted: G        W           syzkaller =
#0 PREEMPT(full)
> Tainted: [W]=3DWARN
> Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS 1.16.2-debian-1.=
16.2-1 04/01/2014
> Call Trace:
>  <TASK>
>  dump_stack_lvl+0x189/0x250 lib/dump_stack.c:120
>  __might_resched+0x495/0x610 kernel/sched/core.c:8925
>  might_alloc include/linux/sched/mm.h:321 [inline]
>  slab_pre_alloc_hook mm/slub.c:4897 [inline]
>  slab_alloc_node mm/slub.c:5221 [inline]
>  kmem_cache_alloc_noprof+0x65/0x6e0 mm/slub.c:5252
>  alloc_rmap_item mm/ksm.c:565 [inline]
>  get_next_rmap_item mm/ksm.c:2378 [inline]
>  ksm_pte_entry+0x414/0xa60 mm/ksm.c:2501
>  walk_pte_range_inner+0x1ba/0x380 mm/pagewalk.c:50
>  walk_pte_range mm/pagewalk.c:88 [inline]
>  walk_pmd_range mm/pagewalk.c:155 [inline]
>  walk_pud_range mm/pagewalk.c:224 [inline]
>  walk_p4d_range mm/pagewalk.c:262 [inline]
>  walk_pgd_range+0x12bf/0x1d40 mm/pagewalk.c:303
>  __walk_page_range+0x14c/0x710 mm/pagewalk.c:410
>  walk_page_range_mm+0x454/0x660 mm/pagewalk.c:506
>  scan_get_next_rmap_item mm/ksm.c:2605 [inline]
>  ksm_do_scan+0x60c/0x5c10 mm/ksm.c:2681
>  ksm_scan_thread+0x10b/0x4b0 mm/ksm.c:2706
>  kthread+0x711/0x8a0 kernel/kthread.c:463
>  ret_from_fork+0x4bc/0x870 arch/x86/kernel/process.c:158
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
> The email will later be sent to:
> [akpm@linux-foundation.org chengming.zhou@linux.dev craftfever@murena.io =
david@redhat.com linux-kernel@vger.kernel.org linux-mm@kvack.org pedrodemar=
gomes@gmail.com xu.xin16@zte.com.cn]
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
-upstream-moderation/68ee2e90.050a0220.91a22.0208.GAE%40google.com.
