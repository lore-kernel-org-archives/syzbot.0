Received: from mail-ot1-f71.google.com (mail-ot1-f71.google.com [209.85.210.71])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C64FF38237C
	for <syzbot@lists.linux.dev>; Fri, 20 Mar 2026 09:41:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.71
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773999683; cv=none; b=jLkF8tPxZMoLb4GQjqbF/jz+6leg4YuP9tsaxcH1w8e9WE2UMYYQOa6bEtIgSecJTsECpC8t2rXFbMLWGJmVcYQaLDSrxq3X5Sp+tJRZrp07Rl4Gz5c+X2RNwPlseBHi8W1MkFSrZIu668ru/kVj9BWS8Nj96kJrL9NrBUG8DqU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773999683; c=relaxed/simple;
	bh=NaAO+SWXdFjAWrRY4ufVg+xefVo5MsXJbvHx0OqgQ1Y=;
	h=MIME-Version:Date:Message-ID:Subject:From:To:Cc:Content-Type; b=JQKqjYHk13FiS16WRn4UWCcV4jDvq1kmnQdIfZF/tKO0evo7foUqug0u91eYR2n81kCJjUhQc/X3g+viOgfaKCIvc+Lm0x6+HCLBtGOFGpAtIENkTFfnIHA/z5uxLJesPDMb3wG7124VtJQpGeXKl9MF8miisRjs0o4ddwpzAWs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com; arc=none smtp.client-ip=209.85.210.71
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com
Received: by mail-ot1-f71.google.com with SMTP id 46e09a7af769-7d7e8781148so10954413a34.1
        for <syzbot@lists.linux.dev>; Fri, 20 Mar 2026 02:41:21 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1773999681; x=1774604481;
        h=cc:to:from:subject:message-id:date:mime-version:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=PEg1d5U+p59n5i1l2edNZSSYO9TnYztUYlCaiV3rurk=;
        b=lYybASVeCnWY8RRY7Hbs9J/ydKKf9cOuTvowuTRTnebT1znKruXRxjOR51ff5N+hI1
         Oeq3uB8/Lo5o9o+d5NmSyq+Q5VOdEB9xJTDpzXG5NCTEC3+IfHSta2An+Tj5oQwpz2nO
         cUckHTpVpLBFbh/5i7CYLj2S8QkNCc7LBVqllOIztPRskSdLbqHV6eQaX/CRG/ceq0l2
         UxhQY54Q9Oajzs9jfXy/xGBMAqRtYsoMb3Om4y+gbbju1W8aK0lde8jtnHYhlh2RBB2T
         ZUSi3M3qKhnS3bYi5Ie3htoWAsmOYufX2EOANHu4Z6bE2HtgoEWpsvh8wZHLv3AVuQX8
         RqGw==
X-Gm-Message-State: AOJu0YxV6NC2x71F4wxYRD6PD2nR/mXlZU4WH21FHRumtt4tkURDtDhx
	0RfDpiXK8zUMFx6plsxZJggYM8SdNu8yODyPS956bpWUsPNblOUOtYwGutKxdE9sAhCc4h9hLU0
	z0JSuTsCILqlid5osDpBEUyXIgipMT8jZempqnxLTOtSgUth52caN4kqSOS4=
Precedence: bulk
X-Mailing-List: syzbot@lists.linux.dev
List-Id: <syzbot.lists.linux.dev>
List-Subscribe: <mailto:syzbot+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:syzbot+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Received: by 2002:a05:6820:626:b0:67b:ba3d:56ba with SMTP id
 006d021491bc7-67c18432529mr5317621eaf.29.1773999680770; Fri, 20 Mar 2026
 02:41:20 -0700 (PDT)
Date: Fri, 20 Mar 2026 02:41:20 -0700
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <69bd1640.050a0220.3bf4de.0013.GAE@google.com>
Subject: [moderation/CI] Re: mm/vmalloc: use dedicated unbound workqueue for
 vmap area draining
From: syzbot ci <syzbot+cidca86df34f28fc7e@syzkaller.appspotmail.com>
To: syzkaller-upstream-moderation@googlegroups.com
Cc: syzbot@lists.linux.dev
Content-Type: text/plain; charset="UTF-8"

syzbot ci has tested the following series

[v2] mm/vmalloc: use dedicated unbound workqueue for vmap area draining
https://lore.kernel.org/all/20260319074307.2325-1-lirongqing@baidu.com
* [PATCH v2] mm/vmalloc: use dedicated unbound workqueue for vmap area draining

and found the following issue:
possible deadlock in console_flush_all

Full report is available here:
https://ci.syzbot.org/series/1703e204-a8b3-43ef-8979-a596c0ada77b

***

possible deadlock in console_flush_all

tree:      mm-new
URL:       https://kernel.googlesource.com/pub/scm/linux/kernel/git/akpm/mm.git
base:      8616acb9dc887e0e271229bf520b5279fbd22f94
arch:      amd64
compiler:  Debian clang version 21.1.8 (++20251221033036+2078da43e25a-1~exp1~20251221153213.50), Debian LLD 21.1.8
config:    https://ci.syzbot.org/builds/b3a95cb5-d858-4555-a40b-1b611b74214b/config
syz repro: https://ci.syzbot.org/findings/d4780575-25c4-4403-a24b-e1c9a6237f30/syz_repro

------------[ cut here ]------------
======================================================
WARNING: possible circular locking dependency detected
syzkaller #0 Not tainted
------------------------------------------------------
kworker/u9:4/94 is trying to acquire lock:
ffffffff8e750900 (console_owner){....}-{0:0}, at: rcu_try_lock_acquire include/linux/rcupdate.h:317 [inline]
ffffffff8e750900 (console_owner){....}-{0:0}, at: srcu_read_lock_nmisafe include/linux/srcu.h:428 [inline]
ffffffff8e750900 (console_owner){....}-{0:0}, at: console_srcu_read_lock kernel/printk/printk.c:291 [inline]
ffffffff8e750900 (console_owner){....}-{0:0}, at: console_flush_one_record kernel/printk/printk.c:3246 [inline]
ffffffff8e750900 (console_owner){....}-{0:0}, at: console_flush_all+0x123/0xb20 kernel/printk/printk.c:3343

but task is already holding lock:
ffff88812103a498 (&pool->lock){-.-.}-{2:2}, at: start_flush_work kernel/workqueue.c:4241 [inline]
ffff88812103a498 (&pool->lock){-.-.}-{2:2}, at: __flush_work+0x1ef/0xc50 kernel/workqueue.c:4292

which lock already depends on the new lock.


the existing dependency chain (in reverse order) is:

-> #3 (&pool->lock){-.-.}-{2:2}:
       __raw_spin_lock include/linux/spinlock_api_smp.h:158 [inline]
       _raw_spin_lock+0x2e/0x40 kernel/locking/spinlock.c:154
       __queue_work+0x80b/0x1020 kernel/workqueue.c:-1
       queue_work_on+0x106/0x1d0 kernel/workqueue.c:2405
       queue_work include/linux/workqueue.h:669 [inline]
       rpm_suspend+0xe85/0x1750 drivers/base/power/runtime.c:688
       __pm_runtime_idle+0x12f/0x1a0 drivers/base/power/runtime.c:1129
       pm_runtime_put include/linux/pm_runtime.h:551 [inline]
       __device_attach+0x34f/0x450 drivers/base/dd.c:1051
       device_initial_probe+0xa1/0xd0 drivers/base/dd.c:1088
       bus_probe_device+0x12a/0x220 drivers/base/bus.c:574
       device_add+0x7b6/0xb70 drivers/base/core.c:3689
       serial_base_port_add+0x18f/0x260 drivers/tty/serial/serial_base_bus.c:186
       serial_core_port_device_add drivers/tty/serial/serial_core.c:3257 [inline]
       serial_core_register_port+0x375/0x28a0 drivers/tty/serial/serial_core.c:3296
       serial8250_register_8250_port+0x1658/0x1fd0 drivers/tty/serial/8250/8250_core.c:822
       serial_pnp_probe+0x568/0x7f0 drivers/tty/serial/8250/8250_pnp.c:480
       pnp_device_probe+0x30b/0x4c0 drivers/pnp/driver.c:111
       call_driver_probe drivers/base/dd.c:-1 [inline]
       really_probe+0x267/0xaf0 drivers/base/dd.c:661
       __driver_probe_device+0x18c/0x320 drivers/base/dd.c:803
       driver_probe_device+0x4f/0x240 drivers/base/dd.c:833
       __driver_attach+0x349/0x640 drivers/base/dd.c:1227
       bus_for_each_dev+0x23b/0x2c0 drivers/base/bus.c:383
       bus_add_driver+0x345/0x670 drivers/base/bus.c:715
       driver_register+0x23a/0x320 drivers/base/driver.c:249
       serial8250_init+0x8f/0x160 drivers/tty/serial/8250/8250_platform.c:317
       do_one_initcall+0x250/0x8d0 init/main.c:1383
       do_initcall_level+0x104/0x190 init/main.c:1445
       do_initcalls+0x59/0xa0 init/main.c:1461
       kernel_init_freeable+0x2a6/0x3e0 init/main.c:1693
       kernel_init+0x1d/0x1d0 init/main.c:1583
       ret_from_fork+0x51e/0xb90 arch/x86/kernel/process.c:158
       ret_from_fork_asm+0x1a/0x30 arch/x86/entry/entry_64.S:245

-> #2 (&dev->power.lock){-...}-{3:3}:
       __raw_spin_lock_irqsave include/linux/spinlock_api_smp.h:132 [inline]
       _raw_spin_lock_irqsave+0x40/0x60 kernel/locking/spinlock.c:162
       __pm_runtime_resume+0x10f/0x180 drivers/base/power/runtime.c:1196
       pm_runtime_get include/linux/pm_runtime.h:494 [inline]
       __uart_start+0x171/0x460 drivers/tty/serial/serial_core.c:149
       uart_write+0x265/0xa10 drivers/tty/serial/serial_core.c:633
       process_output_block drivers/tty/n_tty.c:557 [inline]
       n_tty_write+0xd84/0x12a0 drivers/tty/n_tty.c:2366
       iterate_tty_write drivers/tty/tty_io.c:1006 [inline]
       file_tty_write+0x559/0xa20 drivers/tty/tty_io.c:1081
       new_sync_write fs/read_write.c:595 [inline]
       vfs_write+0x61d/0xb90 fs/read_write.c:688
       ksys_write+0x150/0x270 fs/read_write.c:740
       do_syscall_x64 arch/x86/entry/syscall_64.c:63 [inline]
       do_syscall_64+0x14d/0xf80 arch/x86/entry/syscall_64.c:94
       entry_SYSCALL_64_after_hwframe+0x77/0x7f

-> #1 (&port_lock_key){-...}-{3:3}:
       __raw_spin_lock_irqsave include/linux/spinlock_api_smp.h:132 [inline]
       _raw_spin_lock_irqsave+0x40/0x60 kernel/locking/spinlock.c:162
       uart_port_lock_irqsave include/linux/serial_core.h:717 [inline]
       serial8250_console_write+0x150/0x1ba0 drivers/tty/serial/8250/8250_port.c:3301
       console_emit_next_record kernel/printk/printk.c:3183 [inline]
       console_flush_one_record kernel/printk/printk.c:3269 [inline]
       console_flush_all+0x718/0xb20 kernel/printk/printk.c:3343
       __console_flush_and_unlock kernel/printk/printk.c:3373 [inline]
       console_unlock+0xd1/0x1c0 kernel/printk/printk.c:3413
       vprintk_emit+0x485/0x560 kernel/printk/printk.c:2479
       _printk+0xdd/0x130 kernel/printk/printk.c:2504
       register_console+0xbc2/0xfa0 kernel/printk/printk.c:4208
       univ8250_console_init+0x3a/0x70 drivers/tty/serial/8250/8250_core.c:515
       console_init+0x10b/0x4d0 kernel/printk/printk.c:4407
       start_kernel+0x230/0x3e0 init/main.c:1148
       x86_64_start_reservations+0x24/0x30 arch/x86/kernel/head64.c:310
       x86_64_start_kernel+0x143/0x1c0 arch/x86/kernel/head64.c:291
       common_startup_64+0x13e/0x147

-> #0 (console_owner){....}-{0:0}:
       check_prev_add kernel/locking/lockdep.c:3165 [inline]
       check_prevs_add kernel/locking/lockdep.c:3284 [inline]
       validate_chain kernel/locking/lockdep.c:3908 [inline]
       __lock_acquire+0x15a5/0x2cf0 kernel/locking/lockdep.c:5237
       lock_acquire+0xf0/0x2e0 kernel/locking/lockdep.c:5868
       console_lock_spinning_enable kernel/printk/printk.c:1902 [inline]
       console_emit_next_record kernel/printk/printk.c:3177 [inline]
       console_flush_one_record kernel/printk/printk.c:3269 [inline]
       console_flush_all+0x6c1/0xb20 kernel/printk/printk.c:3343
       __console_flush_and_unlock kernel/printk/printk.c:3373 [inline]
       console_unlock+0xd1/0x1c0 kernel/printk/printk.c:3413
       vprintk_emit+0x485/0x560 kernel/printk/printk.c:2479
       _printk+0xdd/0x130 kernel/printk/printk.c:2504
       __report_bug+0x317/0x540 lib/bug.c:243
       report_bug_entry+0x19a/0x290 lib/bug.c:269
       handle_bug+0xce/0x200 arch/x86/kernel/traps.c:430
       exc_invalid_op+0x1a/0x50 arch/x86/kernel/traps.c:489
       asm_exc_invalid_op+0x1a/0x20 arch/x86/include/asm/idtentry.h:616
       check_flush_dependency+0x312/0x3c0 kernel/workqueue.c:3801
       start_flush_work kernel/workqueue.c:4255 [inline]
       __flush_work+0x411/0xc50 kernel/workqueue.c:4292
       __purge_vmap_area_lazy+0x876/0xb70 mm/vmalloc.c:2412
       drain_vmap_area_work+0x27/0x40 mm/vmalloc.c:2437
       process_one_work kernel/workqueue.c:3276 [inline]
       process_scheduled_works+0xb6e/0x18c0 kernel/workqueue.c:3359
       worker_thread+0xa53/0xfc0 kernel/workqueue.c:3440
       kthread+0x388/0x470 kernel/kthread.c:436
       ret_from_fork+0x51e/0xb90 arch/x86/kernel/process.c:158
       ret_from_fork_asm+0x1a/0x30 arch/x86/entry/entry_64.S:245

other info that might help us debug this:

Chain exists of:
  console_owner --> &dev->power.lock --> &pool->lock

 Possible unsafe locking scenario:

       CPU0                    CPU1
       ----                    ----
  lock(&pool->lock);
                               lock(&dev->power.lock);
                               lock(&pool->lock);
  lock(console_owner);

 *** DEADLOCK ***

7 locks held by kworker/u9:4/94:
 #0: ffff8881000ab948 ((wq_completion)vmap_drain){+.+.}-{0:0}, at: process_one_work kernel/workqueue.c:3251 [inline]
 #0: ffff8881000ab948 ((wq_completion)vmap_drain){+.+.}-{0:0}, at: process_scheduled_works+0xa52/0x18c0 kernel/workqueue.c:3359
 #1: ffffc9000289fc40 (drain_vmap_work){+.+.}-{0:0}, at: process_one_work kernel/workqueue.c:3252 [inline]
 #1: ffffc9000289fc40 (drain_vmap_work){+.+.}-{0:0}, at: process_scheduled_works+0xa8d/0x18c0 kernel/workqueue.c:3359
 #2: ffffffff8e87ec08 (vmap_purge_lock){+.+.}-{4:4}, at: drain_vmap_area_work+0x17/0x40 mm/vmalloc.c:2436
 #3: ffffffff8e75e520 (rcu_read_lock){....}-{1:3}, at: rcu_lock_acquire include/linux/rcupdate.h:312 [inline]
 #3: ffffffff8e75e520 (rcu_read_lock){....}-{1:3}, at: rcu_read_lock include/linux/rcupdate.h:850 [inline]
 #3: ffffffff8e75e520 (rcu_read_lock){....}-{1:3}, at: start_flush_work kernel/workqueue.c:4234 [inline]
 #3: ffffffff8e75e520 (rcu_read_lock){....}-{1:3}, at: __flush_work+0x100/0xc50 kernel/workqueue.c:4292
 #4: ffff88812103a498 (&pool->lock){-.-.}-{2:2}, at: start_flush_work kernel/workqueue.c:4241 [inline]
 #4: ffff88812103a498 (&pool->lock){-.-.}-{2:2}, at: __flush_work+0x1ef/0xc50 kernel/workqueue.c:4292
 #5: ffffffff8e750960 (console_lock){+.+.}-{0:0}, at: _printk+0xdd/0x130 kernel/printk/printk.c:2504
 #6: ffffffff8e638218 (console_srcu){....}-{0:0}, at: rcu_try_lock_acquire include/linux/rcupdate.h:317 [inline]
 #6: ffffffff8e638218 (console_srcu){....}-{0:0}, at: srcu_read_lock_nmisafe include/linux/srcu.h:428 [inline]
 #6: ffffffff8e638218 (console_srcu){....}-{0:0}, at: console_srcu_read_lock kernel/printk/printk.c:291 [inline]
 #6: ffffffff8e638218 (console_srcu){....}-{0:0}, at: console_flush_one_record kernel/printk/printk.c:3246 [inline]
 #6: ffffffff8e638218 (console_srcu){....}-{0:0}, at: console_flush_all+0x123/0xb20 kernel/printk/printk.c:3343

stack backtrace:
CPU: 0 UID: 0 PID: 94 Comm: kworker/u9:4 Not tainted syzkaller #0 PREEMPT(full) 
Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS 1.16.2-debian-1.16.2-1 04/01/2014
Workqueue: vmap_drain drain_vmap_area_work
Call Trace:
 <TASK>
 dump_stack_lvl+0xe8/0x150 lib/dump_stack.c:120
 print_circular_bug+0x2e1/0x300 kernel/locking/lockdep.c:2043
 check_noncircular+0x12e/0x150 kernel/locking/lockdep.c:2175
 check_prev_add kernel/locking/lockdep.c:3165 [inline]
 check_prevs_add kernel/locking/lockdep.c:3284 [inline]
 validate_chain kernel/locking/lockdep.c:3908 [inline]
 __lock_acquire+0x15a5/0x2cf0 kernel/locking/lockdep.c:5237
 lock_acquire+0xf0/0x2e0 kernel/locking/lockdep.c:5868
 console_lock_spinning_enable kernel/printk/printk.c:1902 [inline]
 console_emit_next_record kernel/printk/printk.c:3177 [inline]
 console_flush_one_record kernel/printk/printk.c:3269 [inline]
 console_flush_all+0x6c1/0xb20 kernel/printk/printk.c:3343
 __console_flush_and_unlock kernel/printk/printk.c:3373 [inline]
 console_unlock+0xd1/0x1c0 kernel/printk/printk.c:3413
 vprintk_emit+0x485/0x560 kernel/printk/printk.c:2479
 _printk+0xdd/0x130 kernel/printk/printk.c:2504
 __report_bug+0x317/0x540 lib/bug.c:243
 report_bug_entry+0x19a/0x290 lib/bug.c:269
 handle_bug+0xce/0x200 arch/x86/kernel/traps.c:430
 exc_invalid_op+0x1a/0x50 arch/x86/kernel/traps.c:489
 asm_exc_invalid_op+0x1a/0x20 arch/x86/include/asm/idtentry.h:616
RIP: 0010:check_flush_dependency+0x312/0x3c0 kernel/workqueue.c:3801
Code: 00 00 fc ff df 80 3c 08 00 74 08 4c 89 f7 e8 f5 33 a2 00 49 8b 16 48 81 c3 78 01 00 00 4c 89 ef 4c 89 e6 48 89 d9 4c 8b 04 24 <67> 48 0f b9 3a e9 53 ff ff ff 44 89 f1 80 e1 07 80 c1 03 38 c1 0f
RSP: 0018:ffffc9000289f860 EFLAGS: 00010086
RAX: 1ffff110202e9103 RBX: ffff88810006b178 RCX: ffff88810006b178
RDX: ffffffff821ed1f0 RSI: ffff8881000ab978 RDI: ffffffff9014a330
RBP: ffff888100687008 R08: ffffffff821ee110 R09: 1ffff1102000fb21
R10: dffffc0000000000 R11: ffffed102000fb22 R12: ffff8881000ab978
R13: ffffffff9014a330 R14: ffff888101748818 R15: ffff888101748820
 start_flush_work kernel/workqueue.c:4255 [inline]
 __flush_work+0x411/0xc50 kernel/workqueue.c:4292
 __purge_vmap_area_lazy+0x876/0xb70 mm/vmalloc.c:2412
 drain_vmap_area_work+0x27/0x40 mm/vmalloc.c:2437
 process_one_work kernel/workqueue.c:3276 [inline]
 process_scheduled_works+0xb6e/0x18c0 kernel/workqueue.c:3359
 worker_thread+0xa53/0xfc0 kernel/workqueue.c:3440
 kthread+0x388/0x470 kernel/kthread.c:436
 ret_from_fork+0x51e/0xb90 arch/x86/kernel/process.c:158
 ret_from_fork_asm+0x1a/0x30 arch/x86/entry/entry_64.S:245
 </TASK>
workqueue: WQ_MEM_RECLAIM vmap_drain:drain_vmap_area_work is flushing !WQ_MEM_RECLAIM events:purge_vmap_node
WARNING: kernel/workqueue.c:3805 at check_flush_dependency+0x28f/0x3c0 kernel/workqueue.c:3801, CPU#0: kworker/u9:4/94
Modules linked in:
CPU: 0 UID: 0 PID: 94 Comm: kworker/u9:4 Not tainted syzkaller #0 PREEMPT(full) 
Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS 1.16.2-debian-1.16.2-1 04/01/2014
Workqueue: vmap_drain drain_vmap_area_work
RIP: 0010:check_flush_dependency+0x312/0x3c0 kernel/workqueue.c:3801
Code: 00 00 fc ff df 80 3c 08 00 74 08 4c 89 f7 e8 f5 33 a2 00 49 8b 16 48 81 c3 78 01 00 00 4c 89 ef 4c 89 e6 48 89 d9 4c 8b 04 24 <67> 48 0f b9 3a e9 53 ff ff ff 44 89 f1 80 e1 07 80 c1 03 38 c1 0f
RSP: 0018:ffffc9000289f860 EFLAGS: 00010086
RAX: 1ffff110202e9103 RBX: ffff88810006b178 RCX: ffff88810006b178
RDX: ffffffff821ed1f0 RSI: ffff8881000ab978 RDI: ffffffff9014a330
RBP: ffff888100687008 R08: ffffffff821ee110 R09: 1ffff1102000fb21
R10: dffffc0000000000 R11: ffffed102000fb22 R12: ffff8881000ab978
R13: ffffffff9014a330 R14: ffff888101748818 R15: ffff888101748820
FS:  0000000000000000(0000) GS:ffff88818de5e000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 0000200000386000 CR3: 0000000114a6a000 CR4: 00000000000006f0
Call Trace:
 <TASK>
 start_flush_work kernel/workqueue.c:4255 [inline]
 __flush_work+0x411/0xc50 kernel/workqueue.c:4292
 __purge_vmap_area_lazy+0x876/0xb70 mm/vmalloc.c:2412
 drain_vmap_area_work+0x27/0x40 mm/vmalloc.c:2437
 process_one_work kernel/workqueue.c:3276 [inline]
 process_scheduled_works+0xb6e/0x18c0 kernel/workqueue.c:3359
 worker_thread+0xa53/0xfc0 kernel/workqueue.c:3440
 kthread+0x388/0x470 kernel/kthread.c:436
 ret_from_fork+0x51e/0xb90 arch/x86/kernel/process.c:158
 ret_from_fork_asm+0x1a/0x30 arch/x86/entry/entry_64.S:245
 </TASK>
----------------
Code disassembly (best guess), 4 bytes skipped:
   0:	df 80 3c 08 00 74    	filds  0x7400083c(%rax)
   6:	08 4c 89 f7          	or     %cl,-0x9(%rcx,%rcx,4)
   a:	e8 f5 33 a2 00       	call   0xa23404
   f:	49 8b 16             	mov    (%r14),%rdx
  12:	48 81 c3 78 01 00 00 	add    $0x178,%rbx
  19:	4c 89 ef             	mov    %r13,%rdi
  1c:	4c 89 e6             	mov    %r12,%rsi
  1f:	48 89 d9             	mov    %rbx,%rcx
  22:	4c 8b 04 24          	mov    (%rsp),%r8
* 26:	67 48 0f b9 3a       	ud1    (%edx),%rdi <-- trapping instruction
  2b:	e9 53 ff ff ff       	jmp    0xffffff83
  30:	44 89 f1             	mov    %r14d,%ecx
  33:	80 e1 07             	and    $0x7,%cl
  36:	80 c1 03             	add    $0x3,%cl
  39:	38 c1                	cmp    %al,%cl
  3b:	0f                   	.byte 0xf


***

If these findings have caused you to resend the series or submit a
separate fix, please add the following tag to your commit message:
  Tested-by: syzbot@syzkaller.appspotmail.com

---
This report is generated by a bot. It may contain errors.
syzbot ci engineers can be reached at syzkaller@googlegroups.com.

The email will later be sent to:
[akpm@linux-foundation.org linux-kernel@vger.kernel.org linux-mm@kvack.org lirongqing@baidu.com urezki@gmail.com]

If the report looks fine to you, reply with:
#syz upstream

If the report is a false positive, reply with
#syz invalid

