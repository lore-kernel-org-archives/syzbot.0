Received: from mail-ot1-f70.google.com (mail-ot1-f70.google.com [209.85.210.70])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 64CBF19E819
	for <syzbot@lists.linux.dev>; Sat, 28 Mar 2026 11:55:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.70
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774698957; cv=none; b=QU9crDRv3TCXEAu/aErDfXGSbkkALTdvkQuoTG+yLqmPFDOFC6haGQTwLW9KBROkBM5ySQ3drdC9HwqYldW9WsqJJyF+rMBcADPvhrje9WRxr0sDBCVDeA4UTL0pWq3DpwpAPxTnCkHihIyH7oItgAJkpRfIUaRqWSmUqxcQSmQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774698957; c=relaxed/simple;
	bh=zqNGyRDp1omBy6AlKSj5PzI60mHsQoleg5OpVukxA+Y=;
	h=MIME-Version:Date:Message-ID:Subject:From:To:Cc:Content-Type; b=UWh1/fZ/jGoTGEOJ4xtqJ24mOet1AUvIb11CwdbS6bSOoimC5VcAre5kPa4aJ7aP2R1YkZlTn2tSvtG0wBRsOGaaaLmOiWfFueUfff8HBNaRDUjjLwH3SfPZz6mRNM0h/2PVi2RolzuswnXdbjtmv4t5kGxwVIo5f9uEh/MUsMU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com; arc=none smtp.client-ip=209.85.210.70
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com
Received: by mail-ot1-f70.google.com with SMTP id 46e09a7af769-7d9e1498d4dso9787500a34.0
        for <syzbot@lists.linux.dev>; Sat, 28 Mar 2026 04:55:54 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1774698953; x=1775303753;
        h=cc:to:from:subject:message-id:date:mime-version:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=1QLnc1cdEzqhl3z3Omqg5eyDwqTm2RTqwln6z1+3m8E=;
        b=EXZHP0VefhqiilN1RoLeizUW+jW5Fr1RBCQ+szJ8PkYKuL4xYnUj0dG671PH4CvyPK
         ExAauMq40zjFurQpSOafNfMO1vBBGBG9LSorEtn6WXcDXHcV0XMeULV4dL9+u/mytb4k
         BVirubZaS10Vy+GwIhh/5syf0+pxjEtyrm7EVzw8QDZZ+ckFOxj2h0kC4otk36eCm+0l
         o2zLp1K6nVg3IFOYiRJ0pEIMwXl0UeH4tr6DyO50z+x0uP4iQKISuuMPOXW1QalPd0PT
         Cu8ZO6Jx0uhiplpqvRdz99PkLG5cPwegc0VKO5rJHZH6VtLN1j/q6BaHB/7z2A6TrEAB
         Qnig==
X-Gm-Message-State: AOJu0YwDlABPOiXReRR3BQAZB9pesBkSAqmLskjZyUxHLo2lEbG1abvD
	agQTHhcO4iJlzX29mfJAE2Lz5HOfDDwq0JXHnEUXGYrIGBgOT8ijPN99GmFoaK+Bx67/rpeirwM
	iNr8L0lscKop8ZNufZassOOv0QCOYgk/UFl58qA/FEhqbUIj7zNK/xpVTzQg=
Precedence: bulk
X-Mailing-List: syzbot@lists.linux.dev
List-Id: <syzbot.lists.linux.dev>
List-Subscribe: <mailto:syzbot+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:syzbot+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Received: by 2002:a05:6820:1526:b0:67b:b40e:fc8c with SMTP id
 006d021491bc7-67e1873257dmr2758720eaf.55.1774698953091; Sat, 28 Mar 2026
 04:55:53 -0700 (PDT)
Date: Sat, 28 Mar 2026 04:55:53 -0700
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <69c7c1c9.a70a0220.128fd0.0024.GAE@google.com>
Subject: [moderation/CI] Re: mm/page_owner: warn when stack trace depth hits
 PAGE_OWNER_STACK_DEPTH limit
From: syzbot ci <syzbot+ci8f15c38cf3e2cdab@syzkaller.appspotmail.com>
To: syzkaller-upstream-moderation@googlegroups.com
Cc: syzbot@lists.linux.dev
Content-Type: text/plain; charset="UTF-8"

syzbot ci has tested the following series

[v2] mm/page_owner: warn when stack trace depth hits PAGE_OWNER_STACK_DEPTH limit
https://lore.kernel.org/all/20260328214408.2990597-1-ljykernel@163.com
* [PATCH v2] mm/page_owner: warn when stack trace depth hits PAGE_OWNER_STACK_DEPTH limit

and found the following issue:
possible deadlock in hrtimer_start_range_ns

Full report is available here:
https://ci.syzbot.org/series/aa38ba8f-44db-4d01-8965-ed5a27174f71

***

possible deadlock in hrtimer_start_range_ns

tree:      mm-new
URL:       https://kernel.googlesource.com/pub/scm/linux/kernel/git/akpm/mm.git
base:      f46991f1780ef97efff3b668627b763581032067
arch:      amd64
compiler:  Debian clang version 21.1.8 (++20251221033036+2078da43e25a-1~exp1~20251221153213.50), Debian LLD 21.1.8
config:    https://ci.syzbot.org/builds/2808cd4a-ad2f-49d0-8b68-eb99aeb06ed6/config
syz repro: https://ci.syzbot.org/findings/6c04900a-b825-4465-90f4-694fc3a9d29b/syz_repro

page_owner: stack depth 16 exceeds limit 16
======================================================
WARNING: possible circular locking dependency detected
syzkaller #0 Not tainted
------------------------------------------------------
klogd/5246 is trying to acquire lock:
ffffffff8e750a00 (console_owner){-.-.}-{0:0}, at: console_trylock_spinning kernel/printk/printk.c:2026 [inline]
ffffffff8e750a00 (console_owner){-.-.}-{0:0}, at: vprintk_emit+0x2cf/0x560 kernel/printk/printk.c:2478

but task is already holding lock:
ffff888121028298 (hrtimer_bases.lock){-.-.}-{2:2}, at: lock_hrtimer_base kernel/time/hrtimer.c:172 [inline]
ffff888121028298 (hrtimer_bases.lock){-.-.}-{2:2}, at: hrtimer_start_range_ns+0xc8/0x1ff0 kernel/time/hrtimer.c:1328

which lock already depends on the new lock.


the existing dependency chain (in reverse order) is:

-> #3 (hrtimer_bases.lock){-.-.}-{2:2}:
       __raw_spin_lock_irqsave include/linux/spinlock_api_smp.h:132 [inline]
       _raw_spin_lock_irqsave+0x40/0x60 kernel/locking/spinlock.c:162
       lock_hrtimer_base kernel/time/hrtimer.c:172 [inline]
       hrtimer_start_range_ns+0xc8/0x1ff0 kernel/time/hrtimer.c:1328
       rpm_suspend+0x12d4/0x1750 drivers/base/power/runtime.c:632
       __pm_runtime_idle+0x12f/0x1a0 drivers/base/power/runtime.c:1129
       pm_runtime_put include/linux/pm_runtime.h:551 [inline]
       __device_attach+0x34f/0x450 drivers/base/dd.c:1111
       device_initial_probe+0xa1/0xd0 drivers/base/dd.c:1148
       bus_probe_device+0x12a/0x220 drivers/base/bus.c:613
       device_add+0x7b6/0xb70 drivers/base/core.c:3691
       serdev_controller_add+0x85/0x640 drivers/tty/serdev/core.c:775
       serdev_tty_port_register+0x159/0x260 drivers/tty/serdev/serdev-ttyport.c:291
       tty_port_register_device_attr_serdev+0xe7/0x170 drivers/tty/tty_port.c:187
       serial_core_add_one_port drivers/tty/serial/serial_core.c:3109 [inline]
       serial_core_register_port+0x1123/0x28a0 drivers/tty/serial/serial_core.c:3307
       serial8250_register_8250_port+0x1658/0x1fd0 drivers/tty/serial/8250/8250_core.c:822
       serial_pnp_probe+0x568/0x7f0 drivers/tty/serial/8250/8250_pnp.c:480
       pnp_device_probe+0x30b/0x4c0 drivers/pnp/driver.c:111
       call_driver_probe drivers/base/dd.c:-1 [inline]
       really_probe+0x267/0xaf0 drivers/base/dd.c:721
       __driver_probe_device+0x18c/0x320 drivers/base/dd.c:863
       driver_probe_device+0x4f/0x240 drivers/base/dd.c:893
       __driver_attach+0x34c/0x640 drivers/base/dd.c:1287
       bus_for_each_dev+0x23b/0x2c0 drivers/base/bus.c:383
       bus_add_driver+0x345/0x670 drivers/base/bus.c:756
       driver_register+0x23a/0x320 drivers/base/driver.c:249
       serial8250_init+0x8f/0x160 drivers/tty/serial/8250/8250_platform.c:317
       do_one_initcall+0x250/0x8d0 init/main.c:1382
       do_initcall_level+0x104/0x190 init/main.c:1444
       do_initcalls+0x59/0xa0 init/main.c:1460
       kernel_init_freeable+0x2a6/0x3e0 init/main.c:1692
       kernel_init+0x1d/0x1d0 init/main.c:1582
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

-> #1 (&port_lock_key){-.-.}-{3:3}:
       __raw_spin_lock_irqsave include/linux/spinlock_api_smp.h:132 [inline]
       _raw_spin_lock_irqsave+0x40/0x60 kernel/locking/spinlock.c:162
       uart_port_lock_irqsave include/linux/serial_core.h:717 [inline]
       serial8250_console_write+0x150/0x1ba0 drivers/tty/serial/8250/8250_port.c:3316
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
       start_kernel+0x22b/0x3d0 init/main.c:1147
       x86_64_start_reservations+0x24/0x30 arch/x86/kernel/head64.c:310
       x86_64_start_kernel+0x143/0x1c0 arch/x86/kernel/head64.c:291
       common_startup_64+0x13e/0x147

-> #0 (console_owner){-.-.}-{0:0}:
       check_prev_add kernel/locking/lockdep.c:3165 [inline]
       check_prevs_add kernel/locking/lockdep.c:3284 [inline]
       validate_chain kernel/locking/lockdep.c:3908 [inline]
       __lock_acquire+0x15a5/0x2cf0 kernel/locking/lockdep.c:5237
       lock_acquire+0xf0/0x2e0 kernel/locking/lockdep.c:5868
       console_trylock_spinning kernel/printk/printk.c:2026 [inline]
       vprintk_emit+0x2eb/0x560 kernel/printk/printk.c:2478
       _printk+0xdd/0x130 kernel/printk/printk.c:2504
       save_stack+0x238/0x2a0 mm/page_owner.c:167
       __set_page_owner+0x8d/0x4c0 mm/page_owner.c:344
       set_page_owner include/linux/page_owner.h:32 [inline]
       post_alloc_hook+0x231/0x280 mm/page_alloc.c:1860
       prep_new_page mm/page_alloc.c:1868 [inline]
       get_page_from_freelist+0x24ba/0x2540 mm/page_alloc.c:3948
       alloc_frozen_pages_nolock_noprof+0xac/0x140 mm/page_alloc.c:7795
       alloc_slab_page mm/slub.c:3287 [inline]
       allocate_slab+0xf2/0x660 mm/slub.c:3481
       new_slab mm/slub.c:3539 [inline]
       ___slab_alloc+0x150/0x6b0 mm/slub.c:4413
       __slab_alloc_node mm/slub.c:4479 [inline]
       slab_alloc_node mm/slub.c:4854 [inline]
       kmem_cache_alloc_noprof+0x12d/0x650 mm/slub.c:4873
       kmem_alloc_batch lib/debugobjects.c:371 [inline]
       fill_pool+0x156/0x590 lib/debugobjects.c:420
       debug_objects_fill_pool lib/debugobjects.c:742 [inline]
       debug_object_activate+0x4a3/0x580 lib/debugobjects.c:831
       debug_hrtimer_activate kernel/time/hrtimer.c:446 [inline]
       debug_activate kernel/time/hrtimer.c:485 [inline]
       enqueue_hrtimer+0x30/0x3c0 kernel/time/hrtimer.c:1089
       __hrtimer_start_range_ns kernel/time/hrtimer.c:1271 [inline]
       hrtimer_start_range_ns+0x15ea/0x1ff0 kernel/time/hrtimer.c:1330
       hrtimer_start include/linux/hrtimer.h:244 [inline]
       dummy_timer+0x4436/0x45d0 drivers/usb/gadget/udc/dummy_hcd.c:2008
       __run_hrtimer kernel/time/hrtimer.c:1785 [inline]
       __hrtimer_run_queues+0x53a/0xcc0 kernel/time/hrtimer.c:1849
       hrtimer_run_softirq+0x182/0x5a0 kernel/time/hrtimer.c:1866
       handle_softirqs+0x22a/0x870 kernel/softirq.c:622
       __do_softirq kernel/softirq.c:656 [inline]
       invoke_softirq kernel/softirq.c:496 [inline]
       __irq_exit_rcu+0x5f/0x150 kernel/softirq.c:723
       irq_exit_rcu+0x9/0x30 kernel/softirq.c:739
       instr_sysvec_apic_timer_interrupt arch/x86/kernel/apic/apic.c:1056 [inline]
       sysvec_apic_timer_interrupt+0xa6/0xc0 arch/x86/kernel/apic/apic.c:1056
       asm_sysvec_apic_timer_interrupt+0x1a/0x20 arch/x86/include/asm/idtentry.h:697
       check_kcov_mode kernel/kcov.c:183 [inline]
       __sanitizer_cov_trace_pc+0x30/0x70 kernel/kcov.c:217
       number+0xc0f/0xf80 lib/vsprintf.c:571
       vsnprintf+0x8e5/0xee0 lib/vsprintf.c:2912
       sprintf+0xe7/0x140 lib/vsprintf.c:3111
       print_time kernel/printk/printk.c:1359 [inline]
       info_print_prefix+0x16b/0x360 kernel/printk/printk.c:1385
       record_print_text+0x176/0x450 kernel/printk/printk.c:1434
       syslog_print+0x3b0/0x610 kernel/printk/printk.c:1645
       do_syslog+0x583/0x7d0 kernel/printk/printk.c:1763
       __do_sys_syslog kernel/printk/printk.c:1855 [inline]
       __se_sys_syslog kernel/printk/printk.c:1853 [inline]
       __x64_sys_syslog+0x7c/0x90 kernel/printk/printk.c:1853
       do_syscall_x64 arch/x86/entry/syscall_64.c:63 [inline]
       do_syscall_64+0x14d/0xf80 arch/x86/entry/syscall_64.c:94
       entry_SYSCALL_64_after_hwframe+0x77/0x7f

other info that might help us debug this:

Chain exists of:
  console_owner --> &dev->power.lock --> hrtimer_bases.lock

 Possible unsafe locking scenario:

       CPU0                    CPU1
       ----                    ----
  lock(hrtimer_bases.lock);
                               lock(&dev->power.lock);
                               lock(hrtimer_bases.lock);
  lock(console_owner);

 *** DEADLOCK ***

4 locks held by klogd/5246:
 #0: ffffffff8e750948 (syslog_lock){+.+.}-{4:4}, at: syslog_print+0x4ad/0x610 kernel/printk/printk.c:1663
 #1: ffff88816eebc018 (&dum_hcd->dum->lock){..-.}-{3:3}, at: dummy_timer+0x151/0x45d0 drivers/usb/gadget/udc/dummy_hcd.c:1821
 #2: ffff888121028298 (hrtimer_bases.lock){-.-.}-{2:2}, at: lock_hrtimer_base kernel/time/hrtimer.c:172 [inline]
 #2: ffff888121028298 (hrtimer_bases.lock){-.-.}-{2:2}, at: hrtimer_start_range_ns+0xc8/0x1ff0 kernel/time/hrtimer.c:1328
 #3: ffffffff8ef08700 (fill_pool_map-wait-type-override){+.+.}-{3:3}, at: debug_objects_fill_pool lib/debugobjects.c:741 [inline]
 #3: ffffffff8ef08700 (fill_pool_map-wait-type-override){+.+.}-{3:3}, at: debug_object_activate+0x47a/0x580 lib/debugobjects.c:831

stack backtrace:
CPU: 0 UID: 0 PID: 5246 Comm: klogd Not tainted syzkaller #0 PREEMPT(full) 
Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS 1.16.2-debian-1.16.2-1 04/01/2014
Call Trace:
 <IRQ>
 dump_stack_lvl+0xe8/0x150 lib/dump_stack.c:120
 print_circular_bug+0x2e1/0x300 kernel/locking/lockdep.c:2043
 check_noncircular+0x12e/0x150 kernel/locking/lockdep.c:2175
 check_prev_add kernel/locking/lockdep.c:3165 [inline]
 check_prevs_add kernel/locking/lockdep.c:3284 [inline]
 validate_chain kernel/locking/lockdep.c:3908 [inline]
 __lock_acquire+0x15a5/0x2cf0 kernel/locking/lockdep.c:5237
 lock_acquire+0xf0/0x2e0 kernel/locking/lockdep.c:5868
 console_trylock_spinning kernel/printk/printk.c:2026 [inline]
 vprintk_emit+0x2eb/0x560 kernel/printk/printk.c:2478
 _printk+0xdd/0x130 kernel/printk/printk.c:2504
 save_stack+0x238/0x2a0 mm/page_owner.c:167
 __set_page_owner+0x8d/0x4c0 mm/page_owner.c:344
 set_page_owner include/linux/page_owner.h:32 [inline]
 post_alloc_hook+0x231/0x280 mm/page_alloc.c:1860
 prep_new_page mm/page_alloc.c:1868 [inline]
 get_page_from_freelist+0x24ba/0x2540 mm/page_alloc.c:3948
 alloc_frozen_pages_nolock_noprof+0xac/0x140 mm/page_alloc.c:7795
 alloc_slab_page mm/slub.c:3287 [inline]
 allocate_slab+0xf2/0x660 mm/slub.c:3481
 new_slab mm/slub.c:3539 [inline]
 ___slab_alloc+0x150/0x6b0 mm/slub.c:4413
 __slab_alloc_node mm/slub.c:4479 [inline]
 slab_alloc_node mm/slub.c:4854 [inline]
 kmem_cache_alloc_noprof+0x12d/0x650 mm/slub.c:4873
 kmem_alloc_batch lib/debugobjects.c:371 [inline]
 fill_pool+0x156/0x590 lib/debugobjects.c:420
 debug_objects_fill_pool lib/debugobjects.c:742 [inline]
 debug_object_activate+0x4a3/0x580 lib/debugobjects.c:831
 debug_hrtimer_activate kernel/time/hrtimer.c:446 [inline]
 debug_activate kernel/time/hrtimer.c:485 [inline]
 enqueue_hrtimer+0x30/0x3c0 kernel/time/hrtimer.c:1089
 __hrtimer_start_range_ns kernel/time/hrtimer.c:1271 [inline]
 hrtimer_start_range_ns+0x15ea/0x1ff0 kernel/time/hrtimer.c:1330
 hrtimer_start include/linux/hrtimer.h:244 [inline]
 dummy_timer+0x4436/0x45d0 drivers/usb/gadget/udc/dummy_hcd.c:2008
 __run_hrtimer kernel/time/hrtimer.c:1785 [inline]
 __hrtimer_run_queues+0x53a/0xcc0 kernel/time/hrtimer.c:1849
 hrtimer_run_softirq+0x182/0x5a0 kernel/time/hrtimer.c:1866
 handle_softirqs+0x22a/0x870 kernel/softirq.c:622
 __do_softirq kernel/softirq.c:656 [inline]
 invoke_softirq kernel/softirq.c:496 [inline]
 __irq_exit_rcu+0x5f/0x150 kernel/softirq.c:723
 irq_exit_rcu+0x9/0x30 kernel/softirq.c:739
 instr_sysvec_apic_timer_interrupt arch/x86/kernel/apic/apic.c:1056 [inline]
 sysvec_apic_timer_interrupt+0xa6/0xc0 arch/x86/kernel/apic/apic.c:1056
 </IRQ>
 <TASK>
 asm_sysvec_apic_timer_interrupt+0x1a/0x20 arch/x86/include/asm/idtentry.h:697
RIP: 0010:check_kcov_mode kernel/kcov.c:185 [inline]
RIP: 0010:__sanitizer_cov_trace_pc+0x30/0x70 kernel/kcov.c:217
Code: 04 24 65 48 8b 0d 08 4b 56 11 65 8b 15 29 4b 56 11 81 e2 00 01 ff 00 74 11 81 fa 00 01 00 00 75 35 83 b9 a4 16 00 00 00 74 2c <8b> 91 80 16 00 00 83 fa 02 75 21 48 8b 91 88 16 00 00 48 8b 32 48
RSP: 0018:ffffc900036676b8 EFLAGS: 00000246
RAX: ffffffff8ba85ecf RBX: 0000000000000031 RCX: ffff888111ff0000
RDX: 0000000000000000 RSI: 0000000000000002 RDI: ffffc90003667742
RBP: ffffc900036677e0 R08: ffffc90003667757 R09: 0000000000000000
R10: ffffc90003667740 R11: fffff520006cceeb R12: ffffc90003667acd
R13: dffffc0000000000 R14: ffffc90003667ace R15: 0000000000000002
 number+0xc0f/0xf80 lib/vsprintf.c:571
 vsnprintf+0x8e5/0xee0 lib/vsprintf.c:2912
 sprintf+0xe7/0x140 lib/vsprintf.c:3111
 print_time kernel/printk/printk.c:1359 [inline]
 info_print_prefix+0x16b/0x360 kernel/printk/printk.c:1385
 record_print_text+0x176/0x450 kernel/printk/printk.c:1434
 syslog_print+0x3b0/0x610 kernel/printk/printk.c:1645
 do_syslog+0x583/0x7d0 kernel/printk/printk.c:1763
 __do_sys_syslog kernel/printk/printk.c:1855 [inline]
 __se_sys_syslog kernel/printk/printk.c:1853 [inline]
 __x64_sys_syslog+0x7c/0x90 kernel/printk/printk.c:1853
 do_syscall_x64 arch/x86/entry/syscall_64.c:63 [inline]
 do_syscall_64+0x14d/0xf80 arch/x86/entry/syscall_64.c:94
 entry_SYSCALL_64_after_hwframe+0x77/0x7f
RIP: 0033:0x7f1089379fa7
Code: 73 01 c3 48 8b 0d 81 ce 0c 00 f7 d8 64 89 01 48 83 c8 ff c3 66 2e 0f 1f 84 00 00 00 00 00 0f 1f 44 00 00 b8 67 00 00 00 0f 05 <48> 3d 01 f0 ff ff 73 01 c3 48 8b 0d 51 ce 0c 00 f7 d8 64 89 01 48
RSP: 002b:00007ffed757a078 EFLAGS: 00000206 ORIG_RAX: 0000000000000067
RAX: ffffffffffffffda RBX: 00007f10895184a0 RCX: 00007f1089379fa7
RDX: 00000000000003ff RSI: 00007f10895184a0 RDI: 0000000000000002
RBP: 0000000000000000 R08: 0000000000000007 R09: 7e78de0d48eb7984
R10: 0000000000004000 R11: 0000000000000206 R12: 00007f10895184a0
R13: 00007f1089508212 R14: 00007f108951855a R15: 00007f108951855a
 </TASK>
----------------
Code disassembly (best guess):
   0:	04 24                	add    $0x24,%al
   2:	65 48 8b 0d 08 4b 56 	mov    %gs:0x11564b08(%rip),%rcx        # 0x11564b12
   9:	11
   a:	65 8b 15 29 4b 56 11 	mov    %gs:0x11564b29(%rip),%edx        # 0x11564b3a
  11:	81 e2 00 01 ff 00    	and    $0xff0100,%edx
  17:	74 11                	je     0x2a
  19:	81 fa 00 01 00 00    	cmp    $0x100,%edx
  1f:	75 35                	jne    0x56
  21:	83 b9 a4 16 00 00 00 	cmpl   $0x0,0x16a4(%rcx)
  28:	74 2c                	je     0x56
* 2a:	8b 91 80 16 00 00    	mov    0x1680(%rcx),%edx <-- trapping instruction
  30:	83 fa 02             	cmp    $0x2,%edx
  33:	75 21                	jne    0x56
  35:	48 8b 91 88 16 00 00 	mov    0x1688(%rcx),%rdx
  3c:	48 8b 32             	mov    (%rdx),%rsi
  3f:	48                   	rex.W


***

If these findings have caused you to resend the series or submit a
separate fix, please add the following tag to your commit message:
  Tested-by: syzbot@syzkaller.appspotmail.com

---
This report is generated by a bot. It may contain errors.
syzbot ci engineers can be reached at syzkaller@googlegroups.com.

The email will later be sent to:
[akpm@linux-foundation.org linux-mm@kvack.org ljykernel@163.com]

If the report looks fine to you, reply with:
#syz upstream

If the report is a false positive, reply with
#syz invalid

