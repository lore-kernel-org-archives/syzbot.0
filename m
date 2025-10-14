Received: from mail-il1-f197.google.com (mail-il1-f197.google.com [209.85.166.197])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 20DC12E3B03
	for <syzbot@lists.linux.dev>; Tue, 14 Oct 2025 11:40:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.197
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760442056; cv=none; b=Aj/sdv5G53hqmorzvdox3RypQp4kXyTZwtX3roR8R0tTwRAqZDKfDTixDN1rT8ZY+t9h9vDwH4FKWGeEnlxDdZYM8Mr6NlypzajRsEwC5KcK108+CVsfJF6u0VfjTtPHBmq/hlQjba0xnkevCPavmt/Kc+ZODmyfCxvjEj3CL+g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760442056; c=relaxed/simple;
	bh=M1dNORoRc4hxj1UiEqJRU3U2uAcO+FoN8xkcRDjDRvM=;
	h=MIME-Version:Date:In-Reply-To:Message-ID:Subject:From:To:Cc:
	 Content-Type; b=t4daQZ9WJ4hY5bAKEdijleeaEXoYbBLPCyI0b2hK+2hM9Gd2wnEPEUwDaXoZGyqpIFGPIQcGPwfLcWzhKmm3mnejSGj1ClHxq8m+rBI4I0zyJ/4epOsFn7eAuYLe8TLRwalG73LNDvmocGKm49UIYs9+39pRVstsp/yy2QQ+3s0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com; arc=none smtp.client-ip=209.85.166.197
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com
Received: by mail-il1-f197.google.com with SMTP id e9e14a558f8ab-42486b1d287so304045405ab.0
        for <syzbot@lists.linux.dev>; Tue, 14 Oct 2025 04:40:53 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1760442053; x=1761046853;
        h=cc:to:from:subject:message-id:in-reply-to:date:mime-version
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=/PAUKKVkRXBheGduKaeWvWTn/477z7dsqbwkt84tc7M=;
        b=f4uRwUIwoz0GpNZOUTqhLDTFl05CJ1ums0Ejc9XQFGbDuY5eMjZVb62FMMU195CAkU
         upEd7ATz+9ak673fGXSH0U4fIsrDqTWfSTXDSWZJQ/9Caz3cCcKmtGqCJwuGozQC0BeU
         mMDS6H/4y3Fkml0fdUZCAqur3DRUUT3CVWag04cBwadU21Mhdrq1AhjM54U02xLcQ9QC
         yLBLaFhTjsybQJ4uktniUBbUOkCwDQ6fnNJfTv2+sBP/Vms/4d4jhRtBnLETfNrBM4fZ
         UdmADx81f1ZGKuReMHi24G0G9GXdmuLcZFcZ0BGsc3649Ntcly4x5e+/axSPw/x0GJaB
         cI2A==
X-Gm-Message-State: AOJu0YxjUyQsfOKXmPM0+ZWLCjiipt2Jy5grqTu80P83E7rPkEDRrWq4
	Fd6kynvoQ6OmHe2yjyOi6FUQl6pLFaDRtEAFKkUH5T1ENsp+F+gvA3hrLLtTXf4skNCjGQ66pv1
	mE/+OfaatyMP64QRUNuRTIE4EY0APoqT3tShB1TH9iOR6KUVid/h+pcZxdd8=
X-Google-Smtp-Source: AGHT+IHDQOw0MGkhHMkqt81V1i7DK6QslMKoqOhfaUmigwCRgPhS97A7fo8C/0QFK+K1SSvMpG4XPLcD6tLx+1Y2+wXT2DxMF+7G
Precedence: bulk
X-Mailing-List: syzbot@lists.linux.dev
List-Id: <syzbot.lists.linux.dev>
List-Subscribe: <mailto:syzbot+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:syzbot+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Received: by 2002:a05:6e02:12ed:b0:42f:680c:9cc7 with SMTP id
 e9e14a558f8ab-42f873de65dmr271168475ab.16.1760442053342; Tue, 14 Oct 2025
 04:40:53 -0700 (PDT)
Date: Tue, 14 Oct 2025 04:40:53 -0700
In-Reply-To: <20251014055828.124522-1-pedrodemargomes@gmail.com>
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <68ee36c5.050a0220.ac43.00fc.GAE@google.com>
Subject: [syzbot ci] Re: ksm: use range-walk function to jump over holes in scan_get_next_rmap_item
From: syzbot ci <syzbot+ci6c8e6d88efa889f1@syzkaller.appspotmail.com>
To: akpm@linux-foundation.org, chengming.zhou@linux.dev, craftfever@murena.io, 
	david@redhat.com, linux-kernel@vger.kernel.org, linux-mm@kvack.org, 
	pedrodemargomes@gmail.com, xu.xin16@zte.com.cn
Cc: syzbot@lists.linux.dev, syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"

syzbot ci has tested the following series

[v1] ksm: use range-walk function to jump over holes in scan_get_next_rmap_item
https://lore.kernel.org/all/20251014055828.124522-1-pedrodemargomes@gmail.com
* [PATCH] ksm: use range-walk function to jump over holes in scan_get_next_rmap_item

and found the following issue:
possible deadlock in __pte_offset_map_lock

Full report is available here:
https://ci.syzbot.org/series/15a341dd-23e3-4627-9fb9-00b92b7bae3f

***

possible deadlock in __pte_offset_map_lock

tree:      torvalds
URL:       https://kernel.googlesource.com/pub/scm/linux/kernel/git/torvalds/linux
base:      0d97f2067c166eb495771fede9f7b73999c67f66
arch:      amd64
compiler:  Debian clang version 20.1.8 (++20250708063551+0c9f909b7976-1~exp1~20250708183702.136), Debian LLD 20.1.8
config:    https://ci.syzbot.org/builds/31dfd455-a2ef-4c41-8f8d-172612e161d9/config
C repro:   https://ci.syzbot.org/findings/5bddd702-c879-4aa6-b86d-5be2b4b3d0e2/c_repro
syz repro: https://ci.syzbot.org/findings/5bddd702-c879-4aa6-b86d-5be2b4b3d0e2/syz_repro

======================================================
WARNING: possible circular locking dependency detected
syzkaller #0 Not tainted
------------------------------------------------------
ksmd/41 is trying to acquire lock:
ffffffff8e245b20 (fs_reclaim){+.+.}-{0:0}, at: might_alloc include/linux/sched/mm.h:318 [inline]
ffffffff8e245b20 (fs_reclaim){+.+.}-{0:0}, at: slab_pre_alloc_hook mm/slub.c:4897 [inline]
ffffffff8e245b20 (fs_reclaim){+.+.}-{0:0}, at: slab_alloc_node mm/slub.c:5221 [inline]
ffffffff8e245b20 (fs_reclaim){+.+.}-{0:0}, at: kmem_cache_alloc_noprof+0x45/0x6e0 mm/slub.c:5252

but task is already holding lock:
ffff888112eeb8b8 (ptlock_ptr(ptdesc)#2){+.+.}-{3:3}, at: spin_lock include/linux/spinlock.h:351 [inline]
ffff888112eeb8b8 (ptlock_ptr(ptdesc)#2){+.+.}-{3:3}, at: __pte_offset_map_lock+0x13e/0x210 mm/pgtable-generic.c:401

which lock already depends on the new lock.


the existing dependency chain (in reverse order) is:

-> #3 (ptlock_ptr(ptdesc)#2){+.+.}-{3:3}:
       lock_acquire+0x120/0x360 kernel/locking/lockdep.c:5868
       __raw_spin_lock include/linux/spinlock_api_smp.h:133 [inline]
       _raw_spin_lock+0x2e/0x40 kernel/locking/spinlock.c:154
       spin_lock include/linux/spinlock.h:351 [inline]
       map_pte mm/page_vma_mapped.c:72 [inline]
       page_vma_mapped_walk+0xeea/0x20f0 mm/page_vma_mapped.c:291
       try_to_migrate_one+0x5d8/0x34d0 mm/rmap.c:2339
       rmap_walk_anon+0x553/0x730 mm/rmap.c:2855
       try_to_migrate+0x319/0x3d0 mm/rmap.c:-1
       migrate_folio_unmap mm/migrate.c:1319 [inline]
       migrate_pages_batch+0x1432/0x35e0 mm/migrate.c:1882
       migrate_pages+0x1d5a/0x2930 mm/migrate.c:2103
       migrate_misplaced_folio+0x28c/0x840 mm/migrate.c:2724
       do_numa_page mm/memory.c:6004 [inline]
       handle_pte_fault mm/memory.c:6183 [inline]
       __handle_mm_fault+0x3bab/0x5400 mm/memory.c:6318
       handle_mm_fault+0x40a/0x8e0 mm/memory.c:6487
       do_user_addr_fault+0x764/0x1380 arch/x86/mm/fault.c:1387
       handle_page_fault arch/x86/mm/fault.c:1476 [inline]
       exc_page_fault+0x82/0x100 arch/x86/mm/fault.c:1532
       asm_exc_page_fault+0x26/0x30 arch/x86/include/asm/idtentry.h:623
       __get_user_8+0x14/0x30 arch/x86/lib/getuser.S:100
       rseq_get_rseq_cs_ptr_val kernel/rseq.c:248 [inline]
       rseq_get_rseq_cs kernel/rseq.c:270 [inline]
       rseq_ip_fixup kernel/rseq.c:390 [inline]
       __rseq_handle_notify_resume+0x13d/0x1220 kernel/rseq.c:438
       rseq_handle_notify_resume include/linux/rseq.h:44 [inline]
       resume_user_mode_work include/linux/resume_user_mode.h:62 [inline]
       exit_to_user_mode_loop+0xbf/0x130 kernel/entry/common.c:43
       exit_to_user_mode_prepare include/linux/irq-entry-common.h:225 [inline]
       syscall_exit_to_user_mode_work include/linux/entry-common.h:175 [inline]
       syscall_exit_to_user_mode include/linux/entry-common.h:210 [inline]
       do_syscall_64+0x2bd/0xfa0 arch/x86/entry/syscall_64.c:100
       entry_SYSCALL_64_after_hwframe+0x77/0x7f

-> #2 (&anon_vma->rwsem){++++}-{4:4}:
       lock_acquire+0x120/0x360 kernel/locking/lockdep.c:5868
       down_write+0x96/0x1f0 kernel/locking/rwsem.c:1590
       anon_vma_lock_write include/linux/rmap.h:122 [inline]
       vma_prepare+0x25c/0x4b0 mm/vma.c:309
       __split_vma+0x76e/0xa00 mm/vma.c:550
       split_vma mm/vma.c:598 [inline]
       vma_modify+0x13b3/0x1970 mm/vma.c:1631
       vma_modify_flags+0x1e8/0x230 mm/vma.c:1649
       mprotect_fixup+0x407/0x9c0 mm/mprotect.c:816
       do_mprotect_pkey+0x8c5/0xcd0 mm/mprotect.c:990
       __do_sys_mprotect mm/mprotect.c:1011 [inline]
       __se_sys_mprotect mm/mprotect.c:1008 [inline]
       __x64_sys_mprotect+0x80/0x90 mm/mprotect.c:1008
       do_syscall_x64 arch/x86/entry/syscall_64.c:63 [inline]
       do_syscall_64+0xfa/0xfa0 arch/x86/entry/syscall_64.c:94
       entry_SYSCALL_64_after_hwframe+0x77/0x7f

-> #1 (&mapping->i_mmap_rwsem){++++}-{4:4}:
       lock_acquire+0x120/0x360 kernel/locking/lockdep.c:5868
       down_write+0x96/0x1f0 kernel/locking/rwsem.c:1590
       i_mmap_lock_write include/linux/fs.h:548 [inline]
       dma_resv_lockdep+0x2f6/0x5b0 drivers/dma-buf/dma-resv.c:797
       do_one_initcall+0x236/0x820 init/main.c:1283
       do_initcall_level+0x104/0x190 init/main.c:1345
       do_initcalls+0x59/0xa0 init/main.c:1361
       kernel_init_freeable+0x334/0x4b0 init/main.c:1593
       kernel_init+0x1d/0x1d0 init/main.c:1483
       ret_from_fork+0x4bc/0x870 arch/x86/kernel/process.c:158
       ret_from_fork_asm+0x1a/0x30 arch/x86/entry/entry_64.S:245

-> #0 (fs_reclaim){+.+.}-{0:0}:
       check_prev_add kernel/locking/lockdep.c:3165 [inline]
       check_prevs_add kernel/locking/lockdep.c:3284 [inline]
       validate_chain+0xb9b/0x2140 kernel/locking/lockdep.c:3908
       __lock_acquire+0xab9/0xd20 kernel/locking/lockdep.c:5237
       lock_acquire+0x120/0x360 kernel/locking/lockdep.c:5868
       __fs_reclaim_acquire mm/page_alloc.c:4269 [inline]
       fs_reclaim_acquire+0x72/0x100 mm/page_alloc.c:4283
       might_alloc include/linux/sched/mm.h:318 [inline]
       slab_pre_alloc_hook mm/slub.c:4897 [inline]
       slab_alloc_node mm/slub.c:5221 [inline]
       kmem_cache_alloc_noprof+0x45/0x6e0 mm/slub.c:5252
       alloc_rmap_item mm/ksm.c:565 [inline]
       get_next_rmap_item mm/ksm.c:2378 [inline]
       ksm_pte_entry+0x414/0xa60 mm/ksm.c:2501
       walk_pte_range_inner+0x1ba/0x380 mm/pagewalk.c:50
       walk_pte_range mm/pagewalk.c:88 [inline]
       walk_pmd_range mm/pagewalk.c:155 [inline]
       walk_pud_range mm/pagewalk.c:224 [inline]
       walk_p4d_range mm/pagewalk.c:262 [inline]
       walk_pgd_range+0x12bf/0x1d40 mm/pagewalk.c:303
       __walk_page_range+0x14c/0x710 mm/pagewalk.c:410
       walk_page_range_mm+0x454/0x660 mm/pagewalk.c:506
       scan_get_next_rmap_item mm/ksm.c:2605 [inline]
       ksm_do_scan+0x60c/0x5c10 mm/ksm.c:2681
       ksm_scan_thread+0x10b/0x4b0 mm/ksm.c:2706
       kthread+0x711/0x8a0 kernel/kthread.c:463
       ret_from_fork+0x4bc/0x870 arch/x86/kernel/process.c:158
       ret_from_fork_asm+0x1a/0x30 arch/x86/entry/entry_64.S:245

other info that might help us debug this:

Chain exists of:
  fs_reclaim --> &anon_vma->rwsem --> ptlock_ptr(ptdesc)#2

 Possible unsafe locking scenario:

       CPU0                    CPU1
       ----                    ----
  lock(ptlock_ptr(ptdesc)#2);
                               lock(&anon_vma->rwsem);
                               lock(ptlock_ptr(ptdesc)#2);
  lock(fs_reclaim);

 *** DEADLOCK ***

4 locks held by ksmd/41:
 #0: ffffffff8e259b88 (ksm_thread_mutex){+.+.}-{4:4}, at: ksm_scan_thread+0xc8/0x4b0 mm/ksm.c:2703
 #1: ffff8881703b9760 (&mm->mmap_lock){++++}-{4:4}, at: mmap_read_lock include/linux/mmap_lock.h:368 [inline]
 #1: ffff8881703b9760 (&mm->mmap_lock){++++}-{4:4}, at: scan_get_next_rmap_item mm/ksm.c:2596 [inline]
 #1: ffff8881703b9760 (&mm->mmap_lock){++++}-{4:4}, at: ksm_do_scan+0x578/0x5c10 mm/ksm.c:2681
 #2: ffffffff8e13d320 (rcu_read_lock){....}-{1:3}, at: rcu_lock_acquire include/linux/rcupdate.h:331 [inline]
 #2: ffffffff8e13d320 (rcu_read_lock){....}-{1:3}, at: rcu_read_lock include/linux/rcupdate.h:867 [inline]
 #2: ffffffff8e13d320 (rcu_read_lock){....}-{1:3}, at: ___pte_offset_map+0x29/0x250 mm/pgtable-generic.c:286
 #3: ffff888112eeb8b8 (ptlock_ptr(ptdesc)#2){+.+.}-{3:3}, at: spin_lock include/linux/spinlock.h:351 [inline]
 #3: ffff888112eeb8b8 (ptlock_ptr(ptdesc)#2){+.+.}-{3:3}, at: __pte_offset_map_lock+0x13e/0x210 mm/pgtable-generic.c:401

stack backtrace:
CPU: 1 UID: 0 PID: 41 Comm: ksmd Not tainted syzkaller #0 PREEMPT(full) 
Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS 1.16.2-debian-1.16.2-1 04/01/2014
Call Trace:
 <TASK>
 dump_stack_lvl+0x189/0x250 lib/dump_stack.c:120
 print_circular_bug+0x2ee/0x310 kernel/locking/lockdep.c:2043
 check_noncircular+0x134/0x160 kernel/locking/lockdep.c:2175
 check_prev_add kernel/locking/lockdep.c:3165 [inline]
 check_prevs_add kernel/locking/lockdep.c:3284 [inline]
 validate_chain+0xb9b/0x2140 kernel/locking/lockdep.c:3908
 __lock_acquire+0xab9/0xd20 kernel/locking/lockdep.c:5237
 lock_acquire+0x120/0x360 kernel/locking/lockdep.c:5868
 __fs_reclaim_acquire mm/page_alloc.c:4269 [inline]
 fs_reclaim_acquire+0x72/0x100 mm/page_alloc.c:4283
 might_alloc include/linux/sched/mm.h:318 [inline]
 slab_pre_alloc_hook mm/slub.c:4897 [inline]
 slab_alloc_node mm/slub.c:5221 [inline]
 kmem_cache_alloc_noprof+0x45/0x6e0 mm/slub.c:5252
 alloc_rmap_item mm/ksm.c:565 [inline]
 get_next_rmap_item mm/ksm.c:2378 [inline]
 ksm_pte_entry+0x414/0xa60 mm/ksm.c:2501
 walk_pte_range_inner+0x1ba/0x380 mm/pagewalk.c:50
 walk_pte_range mm/pagewalk.c:88 [inline]
 walk_pmd_range mm/pagewalk.c:155 [inline]
 walk_pud_range mm/pagewalk.c:224 [inline]
 walk_p4d_range mm/pagewalk.c:262 [inline]
 walk_pgd_range+0x12bf/0x1d40 mm/pagewalk.c:303
 __walk_page_range+0x14c/0x710 mm/pagewalk.c:410
 walk_page_range_mm+0x454/0x660 mm/pagewalk.c:506
 scan_get_next_rmap_item mm/ksm.c:2605 [inline]
 ksm_do_scan+0x60c/0x5c10 mm/ksm.c:2681
 ksm_scan_thread+0x10b/0x4b0 mm/ksm.c:2706
 kthread+0x711/0x8a0 kernel/kthread.c:463
 ret_from_fork+0x4bc/0x870 arch/x86/kernel/process.c:158
 ret_from_fork_asm+0x1a/0x30 arch/x86/entry/entry_64.S:245
 </TASK>
BUG: sleeping function called from invalid context at ./include/linux/sched/mm.h:321
in_atomic(): 1, irqs_disabled(): 0, non_block: 0, pid: 41, name: ksmd
preempt_count: 1, expected: 0
RCU nest depth: 1, expected: 0
INFO: lockdep is turned off.
Preemption disabled at:
[<0000000000000000>] 0x0
CPU: 1 UID: 0 PID: 41 Comm: ksmd Not tainted syzkaller #0 PREEMPT(full) 
Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS 1.16.2-debian-1.16.2-1 04/01/2014
Call Trace:
 <TASK>
 dump_stack_lvl+0x189/0x250 lib/dump_stack.c:120
 __might_resched+0x495/0x610 kernel/sched/core.c:8925
 might_alloc include/linux/sched/mm.h:321 [inline]
 slab_pre_alloc_hook mm/slub.c:4897 [inline]
 slab_alloc_node mm/slub.c:5221 [inline]
 kmem_cache_alloc_noprof+0x65/0x6e0 mm/slub.c:5252
 alloc_rmap_item mm/ksm.c:565 [inline]
 get_next_rmap_item mm/ksm.c:2378 [inline]
 ksm_pte_entry+0x414/0xa60 mm/ksm.c:2501
 walk_pte_range_inner+0x1ba/0x380 mm/pagewalk.c:50
 walk_pte_range mm/pagewalk.c:88 [inline]
 walk_pmd_range mm/pagewalk.c:155 [inline]
 walk_pud_range mm/pagewalk.c:224 [inline]
 walk_p4d_range mm/pagewalk.c:262 [inline]
 walk_pgd_range+0x12bf/0x1d40 mm/pagewalk.c:303
 __walk_page_range+0x14c/0x710 mm/pagewalk.c:410
 walk_page_range_mm+0x454/0x660 mm/pagewalk.c:506
 scan_get_next_rmap_item mm/ksm.c:2605 [inline]
 ksm_do_scan+0x60c/0x5c10 mm/ksm.c:2681
 ksm_scan_thread+0x10b/0x4b0 mm/ksm.c:2706
 kthread+0x711/0x8a0 kernel/kthread.c:463
 ret_from_fork+0x4bc/0x870 arch/x86/kernel/process.c:158
 ret_from_fork_asm+0x1a/0x30 arch/x86/entry/entry_64.S:245
 </TASK>
BUG: sleeping function called from invalid context at ./include/linux/sched/mm.h:321
in_atomic(): 1, irqs_disabled(): 0, non_block: 0, pid: 41, name: ksmd
preempt_count: 1, expected: 0
RCU nest depth: 1, expected: 0
INFO: lockdep is turned off.
Preemption disabled at:
[<0000000000000000>] 0x0
CPU: 1 UID: 0 PID: 41 Comm: ksmd Tainted: G        W           syzkaller #0 PREEMPT(full) 
Tainted: [W]=WARN
Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS 1.16.2-debian-1.16.2-1 04/01/2014
Call Trace:
 <TASK>
 dump_stack_lvl+0x189/0x250 lib/dump_stack.c:120
 __might_resched+0x495/0x610 kernel/sched/core.c:8925
 might_alloc include/linux/sched/mm.h:321 [inline]
 slab_pre_alloc_hook mm/slub.c:4897 [inline]
 slab_alloc_node mm/slub.c:5221 [inline]
 kmem_cache_alloc_noprof+0x65/0x6e0 mm/slub.c:5252
 alloc_rmap_item mm/ksm.c:565 [inline]
 get_next_rmap_item mm/ksm.c:2378 [inline]
 ksm_pte_entry+0x414/0xa60 mm/ksm.c:2501
 walk_pte_range_inner+0x1ba/0x380 mm/pagewalk.c:50
 walk_pte_range mm/pagewalk.c:88 [inline]
 walk_pmd_range mm/pagewalk.c:155 [inline]
 walk_pud_range mm/pagewalk.c:224 [inline]
 walk_p4d_range mm/pagewalk.c:262 [inline]
 walk_pgd_range+0x12bf/0x1d40 mm/pagewalk.c:303
 __walk_page_range+0x14c/0x710 mm/pagewalk.c:410
 walk_page_range_mm+0x454/0x660 mm/pagewalk.c:506
 scan_get_next_rmap_item mm/ksm.c:2605 [inline]
 ksm_do_scan+0x60c/0x5c10 mm/ksm.c:2681
 ksm_scan_thread+0x10b/0x4b0 mm/ksm.c:2706
 kthread+0x711/0x8a0 kernel/kthread.c:463
 ret_from_fork+0x4bc/0x870 arch/x86/kernel/process.c:158
 ret_from_fork_asm+0x1a/0x30 arch/x86/entry/entry_64.S:245
 </TASK>
BUG: sleeping function called from invalid context at ./include/linux/sched/mm.h:321
in_atomic(): 1, irqs_disabled(): 0, non_block: 0, pid: 41, name: ksmd
preempt_count: 1, expected: 0
RCU nest depth: 1, expected: 0
INFO: lockdep is turned off.
Preemption disabled at:
[<0000000000000000>] 0x0
CPU: 0 UID: 0 PID: 41 Comm: ksmd Tainted: G        W           syzkaller #0 PREEMPT(full) 
Tainted: [W]=WARN
Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS 1.16.2-debian-1.16.2-1 04/01/2014
Call Trace:
 <TASK>
 dump_stack_lvl+0x189/0x250 lib/dump_stack.c:120
 __might_resched+0x495/0x610 kernel/sched/core.c:8925
 might_alloc include/linux/sched/mm.h:321 [inline]
 slab_pre_alloc_hook mm/slub.c:4897 [inline]
 slab_alloc_node mm/slub.c:5221 [inline]
 kmem_cache_alloc_noprof+0x65/0x6e0 mm/slub.c:5252
 alloc_rmap_item mm/ksm.c:565 [inline]
 get_next_rmap_item mm/ksm.c:2378 [inline]
 ksm_pte_entry+0x414/0xa60 mm/ksm.c:2501
 walk_pte_range_inner+0x1ba/0x380 mm/pagewalk.c:50
 walk_pte_range mm/pagewalk.c:88 [inline]
 walk_pmd_range mm/pagewalk.c:155 [inline]
 walk_pud_range mm/pagewalk.c:224 [inline]
 walk_p4d_range mm/pagewalk.c:262 [inline]
 walk_pgd_range+0x12bf/0x1d40 mm/pagewalk.c:303
 __walk_page_range+0x14c/0x710 mm/pagewalk.c:410
 walk_page_range_mm+0x454/0x660 mm/pagewalk.c:506
 scan_get_next_rmap_item mm/ksm.c:2605 [inline]
 ksm_do_scan+0x60c/0x5c10 mm/ksm.c:2681
 ksm_scan_thread+0x10b/0x4b0 mm/ksm.c:2706
 kthread+0x711/0x8a0 kernel/kthread.c:463
 ret_from_fork+0x4bc/0x870 arch/x86/kernel/process.c:158
 ret_from_fork_asm+0x1a/0x30 arch/x86/entry/entry_64.S:245
 </TASK>
BUG: sleeping function called from invalid context at ./include/linux/sched/mm.h:321
in_atomic(): 1, irqs_disabled(): 0, non_block: 0, pid: 41, name: ksmd
preempt_count: 1, expected: 0
RCU nest depth: 1, expected: 0
INFO: lockdep is turned off.
Preemption disabled at:
[<0000000000000000>] 0x0
CPU: 0 UID: 0 PID: 41 Comm: ksmd Tainted: G        W           syzkaller #0 PREEMPT(full) 
Tainted: [W]=WARN
Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS 1.16.2-debian-1.16.2-1 04/01/2014
Call Trace:
 <TASK>
 dump_stack_lvl+0x189/0x250 lib/dump_stack.c:120
 __might_resched+0x495/0x610 kernel/sched/core.c:8925
 might_alloc include/linux/sched/mm.h:321 [inline]
 slab_pre_alloc_hook mm/slub.c:4897 [inline]
 slab_alloc_node mm/slub.c:5221 [inline]
 kmem_cache_alloc_noprof+0x65/0x6e0 mm/slub.c:5252
 alloc_rmap_item mm/ksm.c:565 [inline]
 get_next_rmap_item mm/ksm.c:2378 [inline]
 ksm_pte_entry+0x414/0xa60 mm/ksm.c:2501
 walk_pte_range_inner+0x1ba/0x380 mm/pagewalk.c:50
 walk_pte_range mm/pagewalk.c:88 [inline]
 walk_pmd_range mm/pagewalk.c:155 [inline]
 walk_pud_range mm/pagewalk.c:224 [inline]
 walk_p4d_range mm/pagewalk.c:262 [inline]
 walk_pgd_range+0x12bf/0x1d40 mm/pagewalk.c:303
 __walk_page_range+0x14c/0x710 mm/pagewalk.c:410
 walk_page_range_mm+0x454/0x660 mm/pagewalk.c:506
 scan_get_next_rmap_item mm/ksm.c:2605 [inline]
 ksm_do_scan+0x60c/0x5c10 mm/ksm.c:2681
 ksm_scan_thread+0x10b/0x4b0 mm/ksm.c:2706
 kthread+0x711/0x8a0 kernel/kthread.c:463
 ret_from_fork+0x4bc/0x870 arch/x86/kernel/process.c:158
 ret_from_fork_asm+0x1a/0x30 arch/x86/entry/entry_64.S:245
 </TASK>
BUG: sleeping function called from invalid context at ./include/linux/sched/mm.h:321
in_atomic(): 1, irqs_disabled(): 0, non_block: 0, pid: 41, name: ksmd
preempt_count: 1, expected: 0
RCU nest depth: 1, expected: 0
INFO: lockdep is turned off.
Preemption disabled at:
[<0000000000000000>] 0x0
CPU: 1 UID: 0 PID: 41 Comm: ksmd Tainted: G        W           syzkaller #0 PREEMPT(full) 
Tainted: [W]=WARN
Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS 1.16.2-debian-1.16.2-1 04/01/2014
Call Trace:
 <TASK>
 dump_stack_lvl+0x189/0x250 lib/dump_stack.c:120
 __might_resched+0x495/0x610 kernel/sched/core.c:8925
 might_alloc include/linux/sched/mm.h:321 [inline]
 slab_pre_alloc_hook mm/slub.c:4897 [inline]
 slab_alloc_node mm/slub.c:5221 [inline]
 kmem_cache_alloc_noprof+0x65/0x6e0 mm/slub.c:5252
 alloc_rmap_item mm/ksm.c:565 [inline]
 get_next_rmap_item mm/ksm.c:2378 [inline]
 ksm_pte_entry+0x414/0xa60 mm/ksm.c:2501
 walk_pte_range_inner+0x1ba/0x380 mm/pagewalk.c:50
 walk_pte_range mm/pagewalk.c:88 [inline]
 walk_pmd_range mm/pagewalk.c:155 [inline]
 walk_pud_range mm/pagewalk.c:224 [inline]
 walk_p4d_range mm/pagewalk.c:262 [inline]
 walk_pgd_range+0x12bf/0x1d40 mm/pagewalk.c:303
 __walk_page_range+0x14c/0x710 mm/pagewalk.c:410
 walk_page_range_mm+0x454/0x660 mm/pagewalk.c:506
 scan_get_next_rmap_item mm/ksm.c:2605 [inline]
 ksm_do_scan+0x60c/0x5c10 mm/ksm.c:2681
 ksm_scan_thread+0x10b/0x4b0 mm/ksm.c:2706
 kthread+0x711/0x8a0 kernel/kthread.c:463
 ret_from_fork+0x4bc/0x870 arch/x86/kernel/process.c:158
 ret_from_fork_asm+0x1a/0x30 arch/x86/entry/entry_64.S:245
 </TASK>
BUG: sleeping function called from invalid context at ./include/linux/sched/mm.h:321
in_atomic(): 1, irqs_disabled(): 0, non_block: 0, pid: 41, name: ksmd
preempt_count: 1, expected: 0
RCU nest depth: 1, expected: 0
INFO: lockdep is turned off.
Preemption disabled at:
[<0000000000000000>] 0x0
CPU: 0 UID: 0 PID: 41 Comm: ksmd Tainted: G        W           syzkaller #0 PREEMPT(full) 
Tainted: [W]=WARN
Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS 1.16.2-debian-1.16.2-1 04/01/2014
Call Trace:
 <TASK>
 dump_stack_lvl+0x189/0x250 lib/dump_stack.c:120
 __might_resched+0x495/0x610 kernel/sched/core.c:8925
 might_alloc include/linux/sched/mm.h:321 [inline]
 slab_pre_alloc_hook mm/slub.c:4897 [inline]
 slab_alloc_node mm/slub.c:5221 [inline]
 kmem_cache_alloc_noprof+0x65/0x6e0 mm/slub.c:5252
 alloc_rmap_item mm/ksm.c:565 [inline]
 get_next_rmap_item mm/ksm.c:2378 [inline]
 ksm_pte_entry+0x414/0xa60 mm/ksm.c:2501
 walk_pte_range_inner+0x1ba/0x380 mm/pagewalk.c:50
 walk_pte_range mm/pagewalk.c:88 [inline]
 walk_pmd_range mm/pagewalk.c:155 [inline]
 walk_pud_range mm/pagewalk.c:224 [inline]
 walk_p4d_range mm/pagewalk.c:262 [inline]
 walk_pgd_range+0x12bf/0x1d40 mm/pagewalk.c:303
 __walk_page_range+0x14c/0x710 mm/pagewalk.c:410
 walk_page_range_mm+0x454/0x660 mm/pagewalk.c:506
 scan_get_next_rmap_item mm/ksm.c:2605 [inline]
 ksm_do_scan+0x60c/0x5c10 mm/ksm.c:2681
 ksm_scan_thread+0x10b/0x4b0 mm/ksm.c:2706
 kthread+0x711/0x8a0 kernel/kthread.c:463
 ret_from_fork+0x4bc/0x870 arch/x86/kernel/process.c:158
 ret_from_fork_asm+0x1a/0x30 arch/x86/entry/entry_64.S:245
 </TASK>
BUG: sleeping function called from invalid context at ./include/linux/sched/mm.h:321
in_atomic(): 1, irqs_disabled(): 0, non_block: 0, pid: 41, name: ksmd
preempt_count: 1, expected: 0
RCU nest depth: 1, expected: 0
INFO: lockdep is turned off.
Preemption disabled at:
[<0000000000000000>] 0x0
CPU: 1 UID: 0 PID: 41 Comm: ksmd Tainted: G        W           syzkaller #0 PREEMPT(full) 
Tainted: [W]=WARN
Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS 1.16.2-debian-1.16.2-1 04/01/2014
Call Trace:
 <TASK>
 dump_stack_lvl+0x189/0x250 lib/dump_stack.c:120
 __might_resched+0x495/0x610 kernel/sched/core.c:8925
 might_alloc include/linux/sched/mm.h:321 [inline]
 slab_pre_alloc_hook mm/slub.c:4897 [inline]
 slab_alloc_node mm/slub.c:5221 [inline]
 kmem_cache_alloc_noprof+0x65/0x6e0 mm/slub.c:5252
 alloc_rmap_item mm/ksm.c:565 [inline]
 get_next_rmap_item mm/ksm.c:2378 [inline]
 ksm_pte_entry+0x414/0xa60 mm/ksm.c:2501
 walk_pte_range_inner+0x1ba/0x380 mm/pagewalk.c:50
 walk_pte_range mm/pagewalk.c:88 [inline]
 walk_pmd_range mm/pagewalk.c:155 [inline]
 walk_pud_range mm/pagewalk.c:224 [inline]
 walk_p4d_range mm/pagewalk.c:262 [inline]
 walk_pgd_range+0x12bf/0x1d40 mm/pagewalk.c:303
 __walk_page_range+0x14c/0x710 mm/pagewalk.c:410
 walk_page_range_mm+0x454/0x660 mm/pagewalk.c:506
 scan_get_next_rmap_item mm/ksm.c:2605 [inline]
 ksm_do_scan+0x60c/0x5c10 mm/ksm.c:2681
 ksm_scan_thread+0x10b/0x4b0 mm/ksm.c:2706
 kthread+0x711/0x8a0 kernel/kthread.c:463
 ret_from_fork+0x4bc/0x870 arch/x86/kernel/process.c:158
 ret_from_fork_asm+0x1a/0x30 arch/x86/entry/entry_64.S:245
 </TASK>
BUG: sleeping function called from invalid context at ./include/linux/sched/mm.h:321
in_atomic(): 1, irqs_disabled(): 0, non_block: 0, pid: 41, name: ksmd
preempt_count: 1, expected: 0
RCU nest depth: 1, expected: 0
INFO: lockdep is turned off.
Preemption disabled at:
[<0000000000000000>] 0x0
CPU: 0 UID: 0 PID: 41 Comm: ksmd Tainted: G        W           syzkaller #0 PREEMPT(full) 
Tainted: [W]=WARN
Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS 1.16.2-debian-1.16.2-1 04/01/2014
Call Trace:
 <TASK>
 dump_stack_lvl+0x189/0x250 lib/dump_stack.c:120
 __might_resched+0x495/0x610 kernel/sched/core.c:8925
 might_alloc include/linux/sched/mm.h:321 [inline]
 slab_pre_alloc_hook mm/slub.c:4897 [inline]
 slab_alloc_node mm/slub.c:5221 [inline]
 kmem_cache_alloc_noprof+0x65/0x6e0 mm/slub.c:5252
 alloc_rmap_item mm/ksm.c:565 [inline]
 get_next_rmap_item mm/ksm.c:2378 [inline]
 ksm_pte_entry+0x414/0xa60 mm/ksm.c:2501
 walk_pte_range_inner+0x1ba/0x380 mm/pagewalk.c:50
 walk_pte_range mm/pagewalk.c:88 [inline]
 walk_pmd_range mm/pagewalk.c:155 [inline]
 walk_pud_range mm/pagewalk.c:224 [inline]
 walk_p4d_range mm/pagewalk.c:262 [inline]
 walk_pgd_range+0x12bf/0x1d40 mm/pagewalk.c:303
 __walk_page_range+0x14c/0x710 mm/pagewalk.c:410
 walk_page_range_mm+0x454/0x660 mm/pagewalk.c:506
 scan_get_next_rmap_item mm/ksm.c:2605 [inline]
 ksm_do_scan+0x60c/0x5c10 mm/ksm.c:2681
 ksm_scan_thread+0x10b/0x4b0 mm/ksm.c:2706
 kthread+0x711/0x8a0 kernel/kthread.c:463
 ret_from_fork+0x4bc/0x870 arch/x86/kernel/process.c:158
 ret_from_fork_asm+0x1a/0x30 arch/x86/entry/entry_64.S:245
 </TASK>
BUG: sleeping function called from invalid context at ./include/linux/sched/mm.h:321
in_atomic(): 1, irqs_disabled(): 0, non_block: 0, pid: 41, name: ksmd
preempt_count: 1, expected: 0
RCU nest depth: 1, expected: 0
INFO: lockdep is turned off.
Preemption disabled at:
[<0000000000000000>] 0x0
CPU: 1 UID: 0 PID: 41 Comm: ksmd Tainted: G        W           syzkaller #0 PREEMPT(full) 
Tainted: [W]=WARN
Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS 1.16.2-debian-1.16.2-1 04/01/2014
Call Trace:
 <TASK>
 dump_stack_lvl+0x189/0x250 lib/dump_stack.c:120
 __might_resched+0x495/0x610 kernel/sched/core.c:8925
 might_alloc include/linux/sched/mm.h:321 [inline]
 slab_pre_alloc_hook mm/slub.c:4897 [inline]
 slab_alloc_node mm/slub.c:5221 [inline]
 kmem_cache_alloc_noprof+0x65/0x6e0 mm/slub.c:5252
 alloc_rmap_item mm/ksm.c:565 [inline]
 get_next_rmap_item mm/ksm.c:2378 [inline]
 ksm_pte_entry+0x414/0xa60 mm/ksm.c:2501
 walk_pte_range_inner+0x1ba/0x380 mm/pagewalk.c:50
 walk_pte_range mm/pagewalk.c:88 [inline]
 walk_pmd_range mm/pagewalk.c:155 [inline]
 walk_pud_range mm/pagewalk.c:224 [inline]
 walk_p4d_range mm/pagewalk.c:262 [inline]
 walk_pgd_range+0x12bf/0x1d40 mm/pagewalk.c:303
 __walk_page_range+0x14c/0x710 mm/pagewalk.c:410
 walk_page_range_mm+0x454/0x660 mm/pagewalk.c:506
 scan_get_next_rmap_item mm/ksm.c:2605 [inline]
 ksm_do_scan+0x60c/0x5c10 mm/ksm.c:2681
 ksm_scan_thread+0x10b/0x4b0 mm/ksm.c:2706
 kthread+0x711/0x8a0 kernel/kthread.c:463
 ret_from_fork+0x4bc/0x870 arch/x86/kernel/process.c:158
 ret_from_fork_asm+0x1a/0x30 arch/x86/entry/entry_64.S:245
 </TASK>


***

If these findings have caused you to resend the series or submit a
separate fix, please add the following tag to your commit message:
  Tested-by: syzbot@syzkaller.appspotmail.com

---
This report is generated by a bot. It may contain errors.
syzbot ci engineers can be reached at syzkaller@googlegroups.com.
