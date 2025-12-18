Received: from mail-pl1-f176.google.com (mail-pl1-f176.google.com [209.85.214.176])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AAF771D90DF
	for <syzbot@lists.linux.dev>; Thu, 18 Dec 2025 01:24:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.176
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1766021095; cv=none; b=tWDT5Tsj05bzaLI5evnsHmGU3NNG5wciDvIDxd7oVW7miVcuDfM13kFaollU006Cre+3JNtdLexAC95+LofyqZRUayYNLustNXNWsVk7ypgKKOYX+2vTMr4oIORfGXa5s6zl72Sx3vzQYCbwprDCzmn0aNZ6jT0LmZ1nODxtgp8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1766021095; c=relaxed/simple;
	bh=DWooMH5C1QDB5vQy0GKXpx3583jw/ecEO7bU5boe5a8=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=p5s5zYZYJ4I1c1SOQqBK7klxNgwQmS1qOWispWIpP4+3/UDQIui3acViH2r5wnMMDC0mRk2RxvR7rXjBxDHvK8SJvVzgA27znZZSyyUXi8u+Poac32MC/1uGERl8gdNIVedr/nF7JkgA0vrevVr5t8gxzmmjG7ISR5iPajAfFPI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=purestorage.com; spf=fail smtp.mailfrom=purestorage.com; dkim=pass (2048-bit key) header.d=purestorage.com header.i=@purestorage.com header.b=YlJu63mc; arc=none smtp.client-ip=209.85.214.176
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=purestorage.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=purestorage.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=purestorage.com header.i=@purestorage.com header.b="YlJu63mc"
Received: by mail-pl1-f176.google.com with SMTP id d9443c01a7336-29e346af955so172065ad.0
        for <syzbot@lists.linux.dev>; Wed, 17 Dec 2025 17:24:52 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=purestorage.com; s=google2022; t=1766021092; x=1766625892; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=7Sd9BeJ5hbUGRVg31mFOBPsK2RhgFXD696VkWVSI5rU=;
        b=YlJu63mcHU7QsMJqK/lLRuS23EDB4lQqeDAereWNpu62ipyRh7Ywwfq+D9MDI9dz0K
         bWyHJfbf4mumnpB2dGI/TIQbu+Bkqhio53slE3u+A0RDZrqLYFa/Ddp8dZwEs7dJMjQY
         AWrvwuKU+jpsSZZMj/s03ytqKWYeGDEecP0KJPc/a7SCwSfv+XSwlP0i9s3ailuh+xF9
         6aGZZjG82U77qMR3Av4PPN4dcQaEG4iWBiB7D4BPgIyWYn0aWbgChGulZx8f08kvtN8l
         bp2AvtEAz0b+NOmWOXqZis7JJRs+n19M32QpPrOMMXN9QB1a9HBrvgnp4gZJ2y9KKII2
         v7jQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1766021092; x=1766625892;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=7Sd9BeJ5hbUGRVg31mFOBPsK2RhgFXD696VkWVSI5rU=;
        b=xUs48P1Eve39TBgPIRg0mCRTdjktCNTOMuD8rslj5FcW4Ni/Mf07WCCWoKRWqyIpXR
         usRYLTpySTXcS43LblOOknWPXlkwZwlpvdJEFupm4qZl0EhNmy7VOZ+OSTd0xtSiCjeH
         MCxbkHHYfTyXVQJMCMd1gKGJXkk6JYniK7va3SQPpwgz73Y7rM0Cc0wwy0Ak288+Lhka
         gY+9FlITjB7RJLI+ndasx7jRD8JTYgFcY2XaZZqYaIccfJ57UdaV4qpzn1daCmbTgJQ0
         y3m7ql96RmkiQpMhMXgyZnjBXZNqGN3D+EqGaO2VH7jzEkh0vlS2+bA4wkAAzt3KunrN
         k9KA==
X-Forwarded-Encrypted: i=1; AJvYcCUQ384R90n49vYLGyZvvRhiJ6NerdmcGjzSJRT8PdK/5W5TUHHWEBz9SP2OLPg3lLzS0UpsZXE=@lists.linux.dev
X-Gm-Message-State: AOJu0Yxsuj1goX3gLvrjEFiRbR9iCDsD6D5YMdWgYhqvmMNHES8QTRbd
	PB0OYQvexXJX+zrqIf9yOfqhHYZ2U/8mHyS2xM8LVBN+1a6ZKbifRuh2aA+fF1Pessu1rDfIJWx
	kvwD6aVasbEeKZVYVKSqxYAMB41Fo32oXOFQaYAtZLQ==
X-Gm-Gg: AY/fxX4WeNPhdLHV1cJzJbPa64r99lAP5b1xDYZ5dq5wumxQ951i/I+tyx0mygbvXZo
	zvyesD27GMHJHrAqx4x/seYTuU4BZ2AeW1GYHx/jLYfg8ACvaOHgHmElaRCYqdaJCnIcV/l4IO0
	yDfYTSbu7SLe7IZx53Q+j9o/6UvKYeqAJ/rQgebZCmdsGZSKTQW9EQZbtiqCutFsprgEbrBd6vv
	6OTFQLjUOmmXX8gAozpoVG8V+kwMY7BpzUsH2KXlSO33YvTnDvTJ8rUxVhxUJG6RYSkiJFh
X-Google-Smtp-Source: AGHT+IEldu5a8bLUUL/puyRgVgme/7sqkOv5mdPu2AP3HZ3baRe2cSd+p4yT5nxhPfFsBAVv3y5itQx8+Aw57x5IhrQ=
X-Received: by 2002:a05:7022:f406:b0:119:e56b:46b6 with SMTP id
 a92af1059eb24-120627a03femr326089c88.0.1766021091662; Wed, 17 Dec 2025
 17:24:51 -0800 (PST)
Precedence: bulk
X-Mailing-List: syzbot@lists.linux.dev
List-Id: <syzbot.lists.linux.dev>
List-Subscribe: <mailto:syzbot+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:syzbot+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20251215200909.3505001-1-csander@purestorage.com> <6940ec5c.a70a0220.104cf0.0346.GAE@google.com>
In-Reply-To: <6940ec5c.a70a0220.104cf0.0346.GAE@google.com>
From: Caleb Sander Mateos <csander@purestorage.com>
Date: Wed, 17 Dec 2025 17:24:40 -0800
X-Gm-Features: AQt7F2qLIdTS0N46_a0qJKru-s2JGrOMAQCIoqtDoWm7qEPjWvjTtqyEnFqhjjE
Message-ID: <CADUfDZpmBzNF-+EW3vDmiz4ur7X93WJ5PoK86pveEjgqzK5pcw@mail.gmail.com>
Subject: Re: [syzbot ci] Re: io_uring: avoid uring_lock for IORING_SETUP_SINGLE_ISSUER
To: syzbot ci <syzbot+ci3ff889516a0b26a2@syzkaller.appspotmail.com>
Cc: axboe@kernel.dk, io-uring@vger.kernel.org, joannelkoong@gmail.com, 
	linux-kernel@vger.kernel.org, oliver.sang@intel.com, 
	syzbot@syzkaller.appspotmail.com, syzbot@lists.linux.dev, 
	syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Mon, Dec 15, 2025 at 9:21=E2=80=AFPM syzbot ci
<syzbot+ci3ff889516a0b26a2@syzkaller.appspotmail.com> wrote:
>
> syzbot ci has tested the following series
>
> [v5] io_uring: avoid uring_lock for IORING_SETUP_SINGLE_ISSUER
> https://lore.kernel.org/all/20251215200909.3505001-1-csander@purestorage.=
com
> * [PATCH v5 1/6] io_uring: use release-acquire ordering for IORING_SETUP_=
R_DISABLED
> * [PATCH v5 2/6] io_uring: clear IORING_SETUP_SINGLE_ISSUER for IORING_SE=
TUP_SQPOLL
> * [PATCH v5 3/6] io_uring: ensure io_uring_create() initializes submitter=
_task
> * [PATCH v5 4/6] io_uring: use io_ring_submit_lock() in io_iopoll_req_iss=
ued()
> * [PATCH v5 5/6] io_uring: factor out uring_lock helpers
> * [PATCH v5 6/6] io_uring: avoid uring_lock for IORING_SETUP_SINGLE_ISSUE=
R
>
> and found the following issue:
> KASAN: slab-use-after-free Read in task_work_add
>
> Full report is available here:
> https://ci.syzbot.org/series/bce89909-ebf2-45f6-be49-bbd46e33e966
>
> ***
>
> KASAN: slab-use-after-free Read in task_work_add
>
> tree:      torvalds
> URL:       https://kernel.googlesource.com/pub/scm/linux/kernel/git/torva=
lds/linux
> base:      d358e5254674b70f34c847715ca509e46eb81e6f
> arch:      amd64
> compiler:  Debian clang version 20.1.8 (++20250708063551+0c9f909b7976-1~e=
xp1~20250708183702.136), Debian LLD 20.1.8
> config:    https://ci.syzbot.org/builds/db5ac991-f49c-460f-80e4-2a33be76f=
e7c/config
> syz repro: https://ci.syzbot.org/findings/ddbf1feb-6618-4c0f-9a16-15b856f=
20d71/syz_repro
>
> =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
> BUG: KASAN: slab-use-after-free in task_work_add+0xd7/0x440 kernel/task_w=
ork.c:73
> Read of size 8 at addr ffff88816a8826f8 by task kworker/u9:2/54
>
> CPU: 0 UID: 0 PID: 54 Comm: kworker/u9:2 Not tainted syzkaller #0 PREEMPT=
(full)
> Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS 1.16.2-debian-1.=
16.2-1 04/01/2014
> Workqueue: iou_exit io_ring_exit_work
> Call Trace:
>  <TASK>
>  dump_stack_lvl+0x189/0x250 lib/dump_stack.c:120
>  print_address_description mm/kasan/report.c:378 [inline]
>  print_report+0xca/0x240 mm/kasan/report.c:482
>  kasan_report+0x118/0x150 mm/kasan/report.c:595
>  task_work_add+0xd7/0x440 kernel/task_work.c:73
>  io_ring_ctx_lock_nested io_uring/io_uring.h:271 [inline]
>  io_ring_ctx_lock io_uring/io_uring.h:282 [inline]
>  io_req_caches_free+0x342/0x3e0 io_uring/io_uring.c:2869
>  io_ring_ctx_free+0x56a/0x8e0 io_uring/io_uring.c:2908

The call to io_req_caches_free() comes after the
put_task_struct(ctx->submitter_task) call in io_ring_ctx_free(), so I
guess the task_struct may have already been freed when
io_ring_ctx_lock() is called. Should be simple enough to fix by just
moving the put_task_struct() call to the end of io_ring_ctx_free().

Looking at this made me realize one other small bug, it's incorrect to
assume that if task_work_add() fails because the submitter_task has
exited, the uring lock has been acquired successfully. Even though
submitter_task will no longer be using the uring lock, other tasks
could. So this path needs to acquire the uring_lock mutex, similar to
the IORING_SETUP_SINGLE_ISSUER && IORING_SETUP_R_DISABLED case.

Thanks,
Caleb

>  io_ring_exit_work+0xff9/0x1220 io_uring/io_uring.c:3113
>  process_one_work kernel/workqueue.c:3257 [inline]
>  process_scheduled_works+0xad1/0x1770 kernel/workqueue.c:3340
>  worker_thread+0x8a0/0xda0 kernel/workqueue.c:3421
>  kthread+0x711/0x8a0 kernel/kthread.c:463
>  ret_from_fork+0x599/0xb30 arch/x86/kernel/process.c:158
>  ret_from_fork_asm+0x1a/0x30 arch/x86/entry/entry_64.S:246
>  </TASK>
>
> Allocated by task 7671:
>  kasan_save_stack mm/kasan/common.c:56 [inline]
>  kasan_save_track+0x3e/0x80 mm/kasan/common.c:77
>  unpoison_slab_object mm/kasan/common.c:339 [inline]
>  __kasan_slab_alloc+0x6c/0x80 mm/kasan/common.c:365
>  kasan_slab_alloc include/linux/kasan.h:252 [inline]
>  slab_post_alloc_hook mm/slub.c:4953 [inline]
>  slab_alloc_node mm/slub.c:5263 [inline]
>  kmem_cache_alloc_node_noprof+0x43c/0x720 mm/slub.c:5315
>  alloc_task_struct_node kernel/fork.c:184 [inline]
>  dup_task_struct+0x57/0x9a0 kernel/fork.c:915
>  copy_process+0x4ea/0x3950 kernel/fork.c:2052
>  kernel_clone+0x21e/0x820 kernel/fork.c:2651
>  __do_sys_clone3 kernel/fork.c:2953 [inline]
>  __se_sys_clone3+0x256/0x2d0 kernel/fork.c:2932
>  do_syscall_x64 arch/x86/entry/syscall_64.c:63 [inline]
>  do_syscall_64+0xfa/0xf80 arch/x86/entry/syscall_64.c:94
>  entry_SYSCALL_64_after_hwframe+0x77/0x7f
>
> Freed by task 6024:
>  kasan_save_stack mm/kasan/common.c:56 [inline]
>  kasan_save_track+0x3e/0x80 mm/kasan/common.c:77
>  kasan_save_free_info+0x46/0x50 mm/kasan/generic.c:584
>  poison_slab_object mm/kasan/common.c:252 [inline]
>  __kasan_slab_free+0x5c/0x80 mm/kasan/common.c:284
>  kasan_slab_free include/linux/kasan.h:234 [inline]
>  slab_free_hook mm/slub.c:2540 [inline]
>  slab_free mm/slub.c:6668 [inline]
>  kmem_cache_free+0x197/0x620 mm/slub.c:6779
>  rcu_do_batch kernel/rcu/tree.c:2605 [inline]
>  rcu_core+0xd70/0x1870 kernel/rcu/tree.c:2857
>  handle_softirqs+0x27d/0x850 kernel/softirq.c:622
>  __do_softirq kernel/softirq.c:656 [inline]
>  invoke_softirq kernel/softirq.c:496 [inline]
>  __irq_exit_rcu+0xca/0x1f0 kernel/softirq.c:723
>  irq_exit_rcu+0x9/0x30 kernel/softirq.c:739
>  instr_sysvec_call_function_single arch/x86/kernel/smp.c:266 [inline]
>  sysvec_call_function_single+0xa3/0xc0 arch/x86/kernel/smp.c:266
>  asm_sysvec_call_function_single+0x1a/0x20 arch/x86/include/asm/idtentry.=
h:704
>
> Last potentially related work creation:
>  kasan_save_stack+0x3e/0x60 mm/kasan/common.c:56
>  kasan_record_aux_stack+0xbd/0xd0 mm/kasan/generic.c:556
>  __call_rcu_common kernel/rcu/tree.c:3119 [inline]
>  call_rcu+0x157/0x9c0 kernel/rcu/tree.c:3239
>  rcu_do_batch kernel/rcu/tree.c:2605 [inline]
>  rcu_core+0xd70/0x1870 kernel/rcu/tree.c:2857
>  handle_softirqs+0x27d/0x850 kernel/softirq.c:622
>  run_ksoftirqd+0x9b/0x100 kernel/softirq.c:1063
>  smpboot_thread_fn+0x542/0xa60 kernel/smpboot.c:160
>  kthread+0x711/0x8a0 kernel/kthread.c:463
>  ret_from_fork+0x599/0xb30 arch/x86/kernel/process.c:158
>  ret_from_fork_asm+0x1a/0x30 arch/x86/entry/entry_64.S:246
>
> Second to last potentially related work creation:
>  kasan_save_stack+0x3e/0x60 mm/kasan/common.c:56
>  kasan_record_aux_stack+0xbd/0xd0 mm/kasan/generic.c:556
>  __call_rcu_common kernel/rcu/tree.c:3119 [inline]
>  call_rcu+0x157/0x9c0 kernel/rcu/tree.c:3239
>  context_switch kernel/sched/core.c:5259 [inline]
>  __schedule+0x14c4/0x5000 kernel/sched/core.c:6863
>  preempt_schedule_irq+0xb5/0x150 kernel/sched/core.c:7190
>  irqentry_exit+0x5d8/0x660 kernel/entry/common.c:216
>  asm_sysvec_apic_timer_interrupt+0x1a/0x20 arch/x86/include/asm/idtentry.=
h:697
>
> The buggy address belongs to the object at ffff88816a881d40
>  which belongs to the cache task_struct of size 7232
> The buggy address is located 2488 bytes inside of
>  freed 7232-byte region [ffff88816a881d40, ffff88816a883980)
>
> The buggy address belongs to the physical page:
> page: refcount:0 mapcount:0 mapping:0000000000000000 index:0x0 pfn:0x16a8=
80
> head: order:3 mapcount:0 entire_mapcount:0 nr_pages_mapped:0 pincount:0
> memcg:ffff8881726b0441
> anon flags: 0x57ff00000000040(head|node=3D1|zone=3D2|lastcpupid=3D0x7ff)
> page_type: f5(slab)
> raw: 057ff00000000040 ffff88816040a500 0000000000000000 0000000000000001
> raw: 0000000000000000 0000000080040004 00000000f5000000 ffff8881726b0441
> head: 057ff00000000040 ffff88816040a500 0000000000000000 0000000000000001
> head: 0000000000000000 0000000080040004 00000000f5000000 ffff8881726b0441
> head: 057ff00000000003 ffffea0005aa2001 00000000ffffffff 00000000ffffffff
> head: ffffffffffffffff 0000000000000000 00000000ffffffff 0000000000000008
> page dumped because: kasan: bad access detected
> page_owner tracks the page as allocated
> page last allocated via order 3, migratetype Unmovable, gfp_mask 0xd20c0(=
__GFP_IO|__GFP_FS|__GFP_NOWARN|__GFP_NORETRY|__GFP_COMP|__GFP_NOMEMALLOC), =
pid 7291, tgid 7291 (syz.2.649), ts 88142964676, free_ts 88127352940
>  set_page_owner include/linux/page_owner.h:32 [inline]
>  post_alloc_hook+0x234/0x290 mm/page_alloc.c:1846
>  prep_new_page mm/page_alloc.c:1854 [inline]
>  get_page_from_freelist+0x2365/0x2440 mm/page_alloc.c:3915
>  __alloc_frozen_pages_noprof+0x181/0x370 mm/page_alloc.c:5210
>  alloc_pages_mpol+0x232/0x4a0 mm/mempolicy.c:2486
>  alloc_slab_page mm/slub.c:3075 [inline]
>  allocate_slab+0x86/0x3b0 mm/slub.c:3248
>  new_slab mm/slub.c:3302 [inline]
>  ___slab_alloc+0xf2b/0x1960 mm/slub.c:4656
>  __slab_alloc+0x65/0x100 mm/slub.c:4779
>  __slab_alloc_node mm/slub.c:4855 [inline]
>  slab_alloc_node mm/slub.c:5251 [inline]
>  kmem_cache_alloc_node_noprof+0x4ce/0x720 mm/slub.c:5315
>  alloc_task_struct_node kernel/fork.c:184 [inline]
>  dup_task_struct+0x57/0x9a0 kernel/fork.c:915
>  copy_process+0x4ea/0x3950 kernel/fork.c:2052
>  kernel_clone+0x21e/0x820 kernel/fork.c:2651
>  __do_sys_clone3 kernel/fork.c:2953 [inline]
>  __se_sys_clone3+0x256/0x2d0 kernel/fork.c:2932
>  do_syscall_x64 arch/x86/entry/syscall_64.c:63 [inline]
>  do_syscall_64+0xfa/0xf80 arch/x86/entry/syscall_64.c:94
>  entry_SYSCALL_64_after_hwframe+0x77/0x7f
> page last free pid 5275 tgid 5275 stack trace:
>  reset_page_owner include/linux/page_owner.h:25 [inline]
>  free_pages_prepare mm/page_alloc.c:1395 [inline]
>  __free_frozen_pages+0xbc8/0xd30 mm/page_alloc.c:2943
>  __slab_free+0x21b/0x2a0 mm/slub.c:6004
>  qlink_free mm/kasan/quarantine.c:163 [inline]
>  qlist_free_all+0x97/0x100 mm/kasan/quarantine.c:179
>  kasan_quarantine_reduce+0x148/0x160 mm/kasan/quarantine.c:286
>  __kasan_slab_alloc+0x22/0x80 mm/kasan/common.c:349
>  kasan_slab_alloc include/linux/kasan.h:252 [inline]
>  slab_post_alloc_hook mm/slub.c:4953 [inline]
>  slab_alloc_node mm/slub.c:5263 [inline]
>  kmem_cache_alloc_noprof+0x37d/0x710 mm/slub.c:5270
>  getname_flags+0xb8/0x540 fs/namei.c:146
>  getname include/linux/fs.h:2498 [inline]
>  do_sys_openat2+0xbc/0x200 fs/open.c:1426
>  do_sys_open fs/open.c:1436 [inline]
>  __do_sys_openat fs/open.c:1452 [inline]
>  __se_sys_openat fs/open.c:1447 [inline]
>  __x64_sys_openat+0x138/0x170 fs/open.c:1447
>  do_syscall_x64 arch/x86/entry/syscall_64.c:63 [inline]
>  do_syscall_64+0xfa/0xf80 arch/x86/entry/syscall_64.c:94
>  entry_SYSCALL_64_after_hwframe+0x77/0x7f
>
> Memory state around the buggy address:
>  ffff88816a882580: fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb
>  ffff88816a882600: fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb
> >ffff88816a882680: fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb
>                                                                 ^
>  ffff88816a882700: fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb
>  ffff88816a882780: fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb
> =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
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
