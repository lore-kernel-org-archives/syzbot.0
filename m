Received: from mta0.migadu.com (out-29.mta0.migadu.com [91.218.175.29])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7F9E73D8107
	for <syzbot@lists.linux.dev>; Mon, 31 Aug 2026 08:35:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.29
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788165340; cv=none; b=LHeolf3zZot6HHa/IYSokJSOlabkHCeXMt+a0PMC1ZgB385jQzg4EnTXPnYfHp5mfS28GpOuRbjKYzf0fJ941IqRJsnCvdW9H5q9tYe4jUpOYfcBvln668R/R5xi/su/T5iNBjXR+KcPN5N/BKe31K9NK23zri28lp5uZR+mMWo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788165340; c=relaxed/simple;
	bh=VJN4rFaD8Ew5PT9JS1wnJsOOiI3/U4jd5AyVRSJ82OM=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=LZVc42E02iJVUeIKsUPTPPRvymsKiDnVUMbXcMJ0SS1/n45pCf7pZuWD/IMr2kby8tJybHySxA9UF0tqiFKpoZLGqsWQj59dJKmqmxqz382rp7giIw38NeLzcL5BmkX27t3WRp7IxdP4YOFWbx9JZWGf+F9ew8TnLYtvka72dl0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=K5HJAEFt; arc=none smtp.client-ip=91.218.175.29
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="K5HJAEFt"
X-Envelope-To: syzbot@lists.linux.dev
DKIM-Signature: a=rsa-sha256; bh=VJN4rFaD8Ew5PT9JS1wnJsOOiI3/U4jd5AyVRSJ82OM=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1788165330; v=1; x=1788770130;
 b=K5HJAEFt1ay7r7HecT2T4pcAW7t9XRDBMRpjRWTBtS95m4mXc5DNjqDlX1gYh4dAO7+Y9uzy
 5a9F0BEMSJmhGdBRAp89iiyZZ/dquakxWR0PaxR1lHAzhjfedcBFIft+Zaq9jIuNWNzdnMOfeOE
 w7npcqZP9NIFEqGcNED+jnkw=
X-Envelope-To: syzbot@lists.linux.dev
Received: by mta11.migadu.com with ESMTPS id 228ab3adc18c6c25;
	Mon, 31 Aug 2026 08:35:30 +0000
X-Mizu-Trace-ID: 228ab3adc18c6c25
X-Migadu-Flow: FLOW_OUT
Date: Mon, 31 Aug 2026 16:35:22 +0800
From: Baoquan He <baoquan.he@linux.dev>
To: syzbot ci <syzbot+cibdf28e878344e870@syzkaller.appspotmail.com>
Cc: akpm@linux-foundation.org, baohua@kernel.org, chengming.zhou@linux.dev,
	chrisl@kernel.org, david@kernel.org, hannes@cmpxchg.org,
	hebaoquan@kylinos.cn, kasong@tencent.com,
	linux-kernel@vger.kernel.org, linux-mm@kvack.org, nphamcs@gmail.com,
	shikemeng@huaweicloud.com, yosry@kernel.org, youngjun.park@lge.com,
	syzbot@lists.linux.dev, syzkaller-bugs@googlegroups.com
Subject: Re: [syzbot ci] Re: xswap: extendable swap device backed by zswap
Message-ID: <apU8yhxWhvB2IxLm@fedora>
References: <20260827094509.1016740-1-hebaoquan@kylinos.cn>
 <6a9042cd.50659fcc.60cd.0014.GAE@google.com>
Precedence: bulk
X-Mailing-List: syzbot@lists.linux.dev
List-Id: <syzbot.lists.linux.dev>
List-Subscribe: <mailto:syzbot+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:syzbot+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <6a9042cd.50659fcc.60cd.0014.GAE@google.com>

On 08/27/26 at 06:59am, syzbot ci wrote:
> syzbot ci has tested the following series
> 
> [v1] xswap: extendable swap device backed by zswap
> https://lore.kernel.org/all/20260827094509.1016740-1-hebaoquan@kylinos.cn
> * [PATCH 01/16] mm: zswap: return -ENOENT when the swap device is gone
> * [PATCH 02/16] mm: xswap support for zswap
> * [PATCH 03/16] mm, swap: add CONFIG_XSWAP and xswap fields to swap_info_struct
> * [PATCH 04/16] mm, swap: refactor free_swap_cluster_info to take swap_info_struct
> * [PATCH 05/16] mm, swap: add xswap cluster grow via VM_SPARSE vmalloc
> * [PATCH 06/16] mm, swap: add sysfs create interface for xswap
> * [PATCH 07/16] mm, swap: add xswap grow trigger on cluster allocation
> * [PATCH 08/16] mm, swap: add xswap_try_shrink and shrink trigger on cluster free
> * [PATCH 09/16] mm, swap: free backing pages in xswap_unmap_clusters
> * [PATCH 10/16] mm, swap: add nr_free_tail for O(1) xswap shrink detection
> * [PATCH 11/16] mm, swap: add adjustable runtime ceiling (nr_clusters) for xswap
> * [PATCH 12/16] mm, swap: add debugfs knob for xswap per-device cluster limit
> * [PATCH 13/16] mm, swap: defer xswap shrink to workqueue to avoid lock recursion
> * [PATCH 14/16] mm, swap: refactor swapoff + add xswap_destroy
> * [PATCH 15/16] mm, swap: require zswap for xswap devices
> * [PATCH 16/16] mm, swap: allow setting xswap device priority at creation
> 
> and found the following issue:
> possible deadlock in console_flush_all
> 
> Full report is available here:
> https://ci.syzbot.org/series/6e23a918-7d02-47ba-a61f-bcad82aebf14
> 
> ***
> 
> possible deadlock in console_flush_all
> 
> tree:      linux-next
> URL:       https://kernel.googlesource.com/pub/scm/linux/kernel/git/next/linux-next
> base:      169393fff5d1ec2690934067eeb95544ff5ebdd7
> arch:      amd64
> compiler:  Debian clang version 22.1.8 (++20260613092233+e80beda6e255-1~exp1~20260613092250.77), Debian LLD 22.1.8
> config:    https://ci.syzbot.org/builds/633d2731-0a5e-45d2-96bf-bd29305475b9/config
> syz repro: https://ci.syzbot.org/findings/b9106c23-79f3-457d-bb14-c0cf63e4bed2/syz_repro
> 
> ------------[ cut here ]------------
> ======================================================
> WARNING: possible circular locking dependency detected
> syzkaller #0 Not tainted
> ------------------------------------------------------
> syz.1.20/5854 is trying to acquire lock:
> ffffffff8eb4bf40 (console_owner){..-.}-{0:0}, at: rcu_try_lock_acquire include/linux/rcupdate.h:305 [inline]
> ffffffff8eb4bf40 (console_owner){..-.}-{0:0}, at: srcu_read_lock_nmisafe include/linux/srcu.h:428 [inline]
> ffffffff8eb4bf40 (console_owner){..-.}-{0:0}, at: console_srcu_read_lock kernel/printk/printk.c:291 [inline]
> ffffffff8eb4bf40 (console_owner){..-.}-{0:0}, at: console_flush_one_record kernel/printk/printk.c:3246 [inline]
> ffffffff8eb4bf40 (console_owner){..-.}-{0:0}, at: console_flush_all+0x123/0xaf0 kernel/printk/printk.c:3343
> 
> but task is already holding lock:
> ffff88823c63a898 (&pool->lock){-.-.}-{2:2}, at: __queue_work+0x7fe/0x10a0 kernel/workqueue.c:2358
> 
> which lock already depends on the new lock.
> 
> 
> the existing dependency chain (in reverse order) is:

Thanks for testing the series.

Sashiko also reported this issue. The root cuase is the
!list_empty(&work->entry) WARN at __queue_work is triggered by
schedule_work(&si->xswap_shrink_work) being called for a non-xswap
swap device in __free_cluster(), where the work_struct is never
initialized (zeroed by kvzalloc). The "possible deadlock in
console_flush_all" report is a secondary lockdep artifact: the WARN
handler prints while holding the workqueue pool lock.

The fix is already included in v2. Now __free_cluster() schedules the
shrink work only for xswap devices while the device is active, guarded
by si->flags & SWP_XSWAP and SWP_WRITEOK, so the uninitialized work is
never queued for normal swap devices.

Thanks
Baoquan

> 
> -> #3 (&pool->lock){-.-.}-{2:2}:
>        __raw_spin_lock include/linux/spinlock_api_smp.h:158 [inline]
>        _raw_spin_lock+0x2e/0x40 kernel/locking/spinlock.c:158
>        __queue_work+0x72f/0x10a0 kernel/workqueue.c:2361
>        queue_work_on+0x106/0x1d0 kernel/workqueue.c:2452
>        queue_work include/linux/workqueue.h:699 [inline]
>        rpm_suspend+0xeca/0x17b0 drivers/base/power/runtime.c:688
>        __pm_runtime_idle+0x12f/0x1a0 drivers/base/power/runtime.c:1129
>        pm_runtime_put include/linux/pm_runtime.h:551 [inline]
>        __device_attach+0x355/0x450 drivers/base/dd.c:1116
>        device_initial_probe+0xa1/0xd0 drivers/base/dd.c:1153
>        bus_probe_device+0x12a/0x220 drivers/base/bus.c:620
>        device_add+0x7d7/0xb80 drivers/base/core.c:3772
>        serial_base_port_add+0x18f/0x270 drivers/tty/serial/serial_base_bus.c:186
>        serial_core_port_device_add drivers/tty/serial/serial_core.c:3275 [inline]
>        serial_core_register_port+0x37f/0x2840 drivers/tty/serial/serial_core.c:3314
>        serial8250_register_8250_port+0x16b4/0x2090 drivers/tty/serial/8250/8250_core.c:828
>        serial_pnp_probe+0x56a/0x7f0 drivers/tty/serial/8250/8250_pnp.c:480
>        pnp_device_probe+0x30b/0x4c0 drivers/pnp/driver.c:111
>        call_driver_probe drivers/base/dd.c:-1 [inline]
>        really_probe+0x254/0xae0 drivers/base/dd.c:706
>        __driver_probe_device+0x1e8/0x360 drivers/base/dd.c:868
>        driver_probe_device+0x4f/0x240 drivers/base/dd.c:898
>        __driver_attach+0x339/0x600 drivers/base/dd.c:1292
>        bus_for_each_dev+0x23b/0x2c0 drivers/base/bus.c:383
>        bus_add_driver+0x345/0x670 drivers/base/bus.c:763
>        driver_register+0x23a/0x320 drivers/base/driver.c:174
>        serial8250_init+0x8f/0x160 drivers/tty/serial/8250/8250_platform.c:317
>        do_one_initcall+0x250/0x870 init/main.c:1347
>        do_initcall_level+0x10a/0x1a0 init/main.c:1409
>        do_initcalls+0x59/0xa0 init/main.c:1425
>        kernel_init_freeable+0x29d/0x3e0 init/main.c:1658
>        kernel_init+0x1d/0x1d0 init/main.c:1548
>        ret_from_fork+0x514/0xb70 arch/x86/kernel/process.c:158
>        ret_from_fork_asm+0x1a/0x30 arch/x86/entry/entry_64.S:245
> 
> -> #2 (&dev->power.lock){-...}-{3:3}:
>        __raw_spin_lock_irqsave include/linux/spinlock_api_smp.h:132 [inline]
>        _raw_spin_lock_irqsave+0x40/0x60 kernel/locking/spinlock.c:166
>        __pm_runtime_resume+0x10f/0x180 drivers/base/power/runtime.c:1196
>        pm_runtime_get include/linux/pm_runtime.h:494 [inline]
>        __uart_start+0x171/0x460 drivers/tty/serial/serial_core.c:149
>        uart_write+0x251/0x9f0 drivers/tty/serial/serial_core.c:629
>        process_output_block drivers/tty/n_tty.c:557 [inline]
>        n_tty_write+0xd49/0x11e0 drivers/tty/n_tty.c:2366
>        iterate_tty_write drivers/tty/tty_io.c:1006 [inline]
>        file_tty_write+0x509/0x9c0 drivers/tty/tty_io.c:1081
>        new_sync_write fs/read_write.c:595 [inline]
>        vfs_write+0x612/0xba0 fs/read_write.c:687
>        ksys_write+0x150/0x270 fs/read_write.c:739
>        do_syscall_x64 arch/x86/entry/syscall_64.c:63 [inline]
>        do_syscall_64+0x174/0x580 arch/x86/entry/syscall_64.c:94
>        entry_SYSCALL_64_after_hwframe+0x77/0x7f
> 
> -> #1 (&port_lock_key){-.-.}-{3:3}:
>        __raw_spin_lock_irqsave include/linux/spinlock_api_smp.h:132 [inline]
>        _raw_spin_lock_irqsave+0x40/0x60 kernel/locking/spinlock.c:166
>        uart_port_lock_irqsave include/linux/serial_core.h:719 [inline]
>        serial8250_console_write+0x153/0x1ba0 drivers/tty/serial/8250/8250_port.c:3344
>        console_emit_next_record kernel/printk/printk.c:3183 [inline]
>        console_flush_one_record kernel/printk/printk.c:3269 [inline]
>        console_flush_all+0x6ea/0xaf0 kernel/printk/printk.c:3343
>        __console_flush_and_unlock kernel/printk/printk.c:3373 [inline]
>        console_unlock+0xd1/0x1c0 kernel/printk/printk.c:3413
>        vprintk_emit+0x485/0x560 kernel/printk/printk.c:2479
>        _printk+0xdd/0x130 kernel/printk/printk.c:2504
>        register_console+0xbc3/0xfc0 kernel/printk/printk.c:4208
>        univ8250_console_init+0x3a/0x70 drivers/tty/serial/8250/8250_core.c:515
>        console_init+0x10b/0x4a0 kernel/printk/printk.c:4407
>        start_kernel+0x238/0x3e0 init/main.c:1112
>        x86_64_start_reservations+0x24/0x30 arch/x86/kernel/head64.c:310
>        x86_64_start_kernel+0x137/0x1b0 arch/x86/kernel/head64.c:291
>        common_startup_64+0x13e/0x157
> 
> -> #0 (console_owner){..-.}-{0:0}:
>        check_prev_add kernel/locking/lockdep.c:3165 [inline]
>        check_prevs_add kernel/locking/lockdep.c:3284 [inline]
>        validate_chain kernel/locking/lockdep.c:3908 [inline]
>        __lock_acquire+0x15ff/0x2e50 kernel/locking/lockdep.c:5238
>        lock_acquire+0x115/0x350 kernel/locking/lockdep.c:5890
>        console_lock_spinning_enable kernel/printk/printk.c:1902 [inline]
>        console_emit_next_record kernel/printk/printk.c:3177 [inline]
>        console_flush_one_record kernel/printk/printk.c:3269 [inline]
>        console_flush_all+0x693/0xaf0 kernel/printk/printk.c:3343
>        __console_flush_and_unlock kernel/printk/printk.c:3373 [inline]
>        console_unlock+0xd1/0x1c0 kernel/printk/printk.c:3413
>        vprintk_emit+0x485/0x560 kernel/printk/printk.c:2479
>        _printk+0xdd/0x130 kernel/printk/printk.c:2504
>        __report_bug+0x349/0x570 lib/bug.c:248
>        report_bug+0x16a/0x220 lib/bug.c:286
>        handle_bug+0x9c/0x200 arch/x86/kernel/traps.c:436
>        exc_invalid_op+0x1a/0x50 arch/x86/kernel/traps.c:490
>        asm_exc_invalid_op+0x1a/0x20 arch/x86/include/asm/idtentry.h:593
>        __queue_work+0xd18/0x10a0 kernel/workqueue.c:2385
>        queue_work_on+0x106/0x1d0 kernel/workqueue.c:2452
>        swap_put_entries_cluster+0x3b1/0x4b0 mm/swapfile.c:1893
>        swap_put_entries_direct+0x94/0x100 mm/swapfile.c:2403
>        zap_nonpresent_ptes mm/memory.c:1900 [inline]
>        do_zap_pte_range mm/memory.c:1967 [inline]
>        zap_pte_range mm/memory.c:2065 [inline]
>        zap_pmd_range mm/memory.c:2151 [inline]
>        zap_pud_range mm/memory.c:2179 [inline]
>        zap_p4d_range mm/memory.c:2200 [inline]
>        __zap_vma_range+0x1da0/0x4f70 mm/memory.c:2240
>        unmap_vmas+0x390/0x550 mm/memory.c:2309
>        exit_mmap+0x293/0x9f0 mm/mmap.c:1315
>        __mmput+0x118/0x420 kernel/fork.c:1187
>        exit_mm+0x221/0x2d0 kernel/exit.c:615
>        do_exit+0x6cd/0x2360 kernel/exit.c:997
>        do_group_exit+0x22d/0x2f0 kernel/exit.c:1152
>        get_signal+0x121b/0x12c0 kernel/signal.c:3046
>        arch_do_signal_or_restart+0xbb/0x860 arch/x86/kernel/signal.c:337
>        __exit_to_user_mode_loop kernel/entry/common.c:66 [inline]
>        exit_to_user_mode_loop+0x104/0x730 kernel/entry/common.c:101
>        __exit_to_user_mode_prepare include/linux/irq-entry-common.h:207 [inline]
>        syscall_exit_to_user_mode_prepare include/linux/irq-entry-common.h:230 [inline]
>        syscall_exit_to_user_mode include/linux/entry-common.h:318 [inline]
>        do_syscall_64+0x353/0x580 arch/x86/entry/syscall_64.c:100
>        entry_SYSCALL_64_after_hwframe+0x77/0x7f
> 
> other info that might help us debug this:
> 
> Chain exists of:
>   console_owner --> &dev->power.lock --> &pool->lock
> 
>  Possible unsafe locking scenario:
> 
>        CPU0                    CPU1
>        ----                    ----
>   lock(&pool->lock);
>                                lock(&dev->power.lock);
>                                lock(&pool->lock);
>   lock(console_owner);
> 
>  *** DEADLOCK ***
> 
> 8 locks held by syz.1.20/5854:
>  #0: ffff8881bb3703b8 (&mm->mmap_lock){++++}-{4:4}, at: mmap_read_lock include/linux/mmap_lock.h:600 [inline]
>  #0: ffff8881bb3703b8 (&mm->mmap_lock){++++}-{4:4}, at: exit_mmap+0x1a4/0x9f0 mm/mmap.c:1299
>  #1: ffffffff8eb59c60 (rcu_read_lock){....}-{1:3}, at: rcu_lock_acquire include/linux/rcupdate.h:300 [inline]
>  #1: ffffffff8eb59c60 (rcu_read_lock){....}-{1:3}, at: rcu_read_lock include/linux/rcupdate.h:840 [inline]
>  #1: ffffffff8eb59c60 (rcu_read_lock){....}-{1:3}, at: __pte_offset_map+0x29/0x240 mm/pgtable-generic.c:290
>  #2: ffff88816d267f18 (ptlock_ptr(ptdesc)#2){+.+.}-{3:3}, at: spin_lock include/linux/spinlock.h:342 [inline]
>  #2: ffff88816d267f18 (ptlock_ptr(ptdesc)#2){+.+.}-{3:3}, at: pte_offset_map_lock+0x13d/0x210 mm/pgtable-generic.c:404
>  #3: ffff8881102a40f8 (&cluster_info[i].lock){+.+.}-{3:3}, at: spin_lock include/linux/spinlock.h:342 [inline]
>  #3: ffff8881102a40f8 (&cluster_info[i].lock){+.+.}-{3:3}, at: __swap_cluster_lock mm/swap.h:155 [inline]
>  #3: ffff8881102a40f8 (&cluster_info[i].lock){+.+.}-{3:3}, at: swap_cluster_lock mm/swap.h:170 [inline]
>  #3: ffff8881102a40f8 (&cluster_info[i].lock){+.+.}-{3:3}, at: swap_put_entries_cluster+0x109/0x4b0 mm/swapfile.c:1864
>  #4: ffffffff8eb59c60 (rcu_read_lock){....}-{1:3}, at: rcu_lock_acquire include/linux/rcupdate.h:300 [inline]
>  #4: ffffffff8eb59c60 (rcu_read_lock){....}-{1:3}, at: rcu_read_lock include/linux/rcupdate.h:840 [inline]
>  #4: ffffffff8eb59c60 (rcu_read_lock){....}-{1:3}, at: __queue_work+0x1ea/0x10a0 kernel/workqueue.c:2321
>  #5: ffff88823c63a898 (&pool->lock){-.-.}-{2:2}, at: __queue_work+0x7fe/0x10a0 kernel/workqueue.c:2358
>  #6: ffffffff8eb4bfa0 (console_lock){+.+.}-{0:0}, at: _printk+0xdd/0x130 kernel/printk/printk.c:2504
>  #7: ffffffff8ea33838 (console_srcu){....}-{0:0}, at: rcu_try_lock_acquire include/linux/rcupdate.h:305 [inline]
>  #7: ffffffff8ea33838 (console_srcu){....}-{0:0}, at: srcu_read_lock_nmisafe include/linux/srcu.h:428 [inline]
>  #7: ffffffff8ea33838 (console_srcu){....}-{0:0}, at: console_srcu_read_lock kernel/printk/printk.c:291 [inline]
>  #7: ffffffff8ea33838 (console_srcu){....}-{0:0}, at: console_flush_one_record kernel/printk/printk.c:3246 [inline]
>  #7: ffffffff8ea33838 (console_srcu){....}-{0:0}, at: console_flush_all+0x123/0xaf0 kernel/printk/printk.c:3343
> 
> stack backtrace:
> CPU: 1 UID: 0 PID: 5854 Comm: syz.1.20 Not tainted syzkaller #0 PREEMPT(full) 
> Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS 1.16.2-debian-1.16.2-1 04/01/2014
> Call Trace:
>  <TASK>
>  dump_stack_lvl+0xe8/0x150 lib/dump_stack.c:120
>  print_circular_bug+0x2e2/0x300 kernel/locking/lockdep.c:2043
>  check_noncircular+0x12f/0x150 kernel/locking/lockdep.c:2175
>  check_prev_add kernel/locking/lockdep.c:3165 [inline]
>  check_prevs_add kernel/locking/lockdep.c:3284 [inline]
>  validate_chain kernel/locking/lockdep.c:3908 [inline]
>  __lock_acquire+0x15ff/0x2e50 kernel/locking/lockdep.c:5238
>  lock_acquire+0x115/0x350 kernel/locking/lockdep.c:5890
>  console_lock_spinning_enable kernel/printk/printk.c:1902 [inline]
>  console_emit_next_record kernel/printk/printk.c:3177 [inline]
>  console_flush_one_record kernel/printk/printk.c:3269 [inline]
>  console_flush_all+0x693/0xaf0 kernel/printk/printk.c:3343
>  __console_flush_and_unlock kernel/printk/printk.c:3373 [inline]
>  console_unlock+0xd1/0x1c0 kernel/printk/printk.c:3413
>  vprintk_emit+0x485/0x560 kernel/printk/printk.c:2479
>  _printk+0xdd/0x130 kernel/printk/printk.c:2504
>  __report_bug+0x349/0x570 lib/bug.c:248
>  report_bug+0x16a/0x220 lib/bug.c:286
>  handle_bug+0x9c/0x200 arch/x86/kernel/traps.c:436
>  exc_invalid_op+0x1a/0x50 arch/x86/kernel/traps.c:490
>  asm_exc_invalid_op+0x1a/0x20 arch/x86/include/asm/idtentry.h:593
> RIP: 0010:__queue_work+0xd18/0x10a0 kernel/workqueue.c:2385
> Code: 3d 7e ec b2 0e 01 0f 85 35 02 00 00 e8 a1 28 39 00 e9 82 f3 ff ff e8 97 28 39 00 90 0f 0b 90 e9 21 fd ff ff e8 89 28 39 00 90 <0f> 0b 90 e9 80 fe ff ff e8 7b 28 39 00 eb 11 e8 74 28 39 00 4c 8b
> RSP: 0018:ffffc90003cdf1d8 EFLAGS: 00010093
> RAX: ffffffff818dc2d7 RBX: dffffc0000000000 RCX: ffff888113955a00
> RDX: 0000000000000000 RSI: ffffffff8c4bca60 RDI: ffffffff8c4bca20
> RBP: 0000000000000001 R08: ffffffff90572d37 R09: 1ffffffff20ae5a6
> R10: dffffc0000000000 R11: fffffbfff20ae5a7 R12: ffff888160408400
> R13: ffff88810fdd7088 R14: 0000000000000001 R15: ffff88810fdd7090
>  queue_work_on+0x106/0x1d0 kernel/workqueue.c:2452
>  swap_put_entries_cluster+0x3b1/0x4b0 mm/swapfile.c:1893
>  swap_put_entries_direct+0x94/0x100 mm/swapfile.c:2403
>  zap_nonpresent_ptes mm/memory.c:1900 [inline]
>  do_zap_pte_range mm/memory.c:1967 [inline]
>  zap_pte_range mm/memory.c:2065 [inline]
>  zap_pmd_range mm/memory.c:2151 [inline]
>  zap_pud_range mm/memory.c:2179 [inline]
>  zap_p4d_range mm/memory.c:2200 [inline]
>  __zap_vma_range+0x1da0/0x4f70 mm/memory.c:2240
>  unmap_vmas+0x390/0x550 mm/memory.c:2309
>  exit_mmap+0x293/0x9f0 mm/mmap.c:1315
>  __mmput+0x118/0x420 kernel/fork.c:1187
>  exit_mm+0x221/0x2d0 kernel/exit.c:615
>  do_exit+0x6cd/0x2360 kernel/exit.c:997
>  do_group_exit+0x22d/0x2f0 kernel/exit.c:1152
>  get_signal+0x121b/0x12c0 kernel/signal.c:3046
>  arch_do_signal_or_restart+0xbb/0x860 arch/x86/kernel/signal.c:337
>  __exit_to_user_mode_loop kernel/entry/common.c:66 [inline]
>  exit_to_user_mode_loop+0x104/0x730 kernel/entry/common.c:101
>  __exit_to_user_mode_prepare include/linux/irq-entry-common.h:207 [inline]
>  syscall_exit_to_user_mode_prepare include/linux/irq-entry-common.h:230 [inline]
>  syscall_exit_to_user_mode include/linux/entry-common.h:318 [inline]
>  do_syscall_64+0x353/0x580 arch/x86/entry/syscall_64.c:100
>  entry_SYSCALL_64_after_hwframe+0x77/0x7f
> RIP: 0033:0x7f46ce79e0d9
> Code: Unable to access opcode bytes at 0x7f46ce79e0af.
> RSP: 002b:00007f46cf6fc028 EFLAGS: 00000246 ORIG_RAX: 000000000000001c
> RAX: 0000000000000000 RBX: 00007f46cea26090 RCX: 00007f46ce79e0d9
> RDX: 0000000000000015 RSI: 0000000000600003 RDI: 0000200000000000
> RBP: 00007f46ce835024 R08: 0000000000000000 R09: 0000000000000000
> R10: 0000000000000000 R11: 0000000000000246 R12: 0000000000000000
> R13: 00007f46cea26128 R14: 00007f46cea26090 R15: 00007ffefd86c578
>  </TASK>
> !list_empty(&work->entry)
> WARNING: kernel/workqueue.c:2385 at __queue_work+0xd18/0x10a0 kernel/workqueue.c:2385, CPU#1: syz.1.20/5854
> Modules linked in:
> CPU: 1 UID: 0 PID: 5854 Comm: syz.1.20 Not tainted syzkaller #0 PREEMPT(full) 
> Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS 1.16.2-debian-1.16.2-1 04/01/2014
> RIP: 0010:__queue_work+0xd18/0x10a0 kernel/workqueue.c:2385
> Code: 3d 7e ec b2 0e 01 0f 85 35 02 00 00 e8 a1 28 39 00 e9 82 f3 ff ff e8 97 28 39 00 90 0f 0b 90 e9 21 fd ff ff e8 89 28 39 00 90 <0f> 0b 90 e9 80 fe ff ff e8 7b 28 39 00 eb 11 e8 74 28 39 00 4c 8b
> RSP: 0018:ffffc90003cdf1d8 EFLAGS: 00010093
> RAX: ffffffff818dc2d7 RBX: dffffc0000000000 RCX: ffff888113955a00
> RDX: 0000000000000000 RSI: ffffffff8c4bca60 RDI: ffffffff8c4bca20
> RBP: 0000000000000001 R08: ffffffff90572d37 R09: 1ffffffff20ae5a6
> R10: dffffc0000000000 R11: fffffbfff20ae5a7 R12: ffff888160408400
> R13: ffff88810fdd7088 R14: 0000000000000001 R15: ffff88810fdd7090
> FS:  00007f46cf6fc6c0(0000) GS:ffff8882a8f5a000(0000) knlGS:0000000000000000
> CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> CR2: 0000200000e6c000 CR3: 000000010a5a2000 CR4: 00000000000006f0
> Call Trace:
>  <TASK>
>  queue_work_on+0x106/0x1d0 kernel/workqueue.c:2452
>  swap_put_entries_cluster+0x3b1/0x4b0 mm/swapfile.c:1893
>  swap_put_entries_direct+0x94/0x100 mm/swapfile.c:2403
>  zap_nonpresent_ptes mm/memory.c:1900 [inline]
>  do_zap_pte_range mm/memory.c:1967 [inline]
>  zap_pte_range mm/memory.c:2065 [inline]
>  zap_pmd_range mm/memory.c:2151 [inline]
>  zap_pud_range mm/memory.c:2179 [inline]
>  zap_p4d_range mm/memory.c:2200 [inline]
>  __zap_vma_range+0x1da0/0x4f70 mm/memory.c:2240
>  unmap_vmas+0x390/0x550 mm/memory.c:2309
>  exit_mmap+0x293/0x9f0 mm/mmap.c:1315
>  __mmput+0x118/0x420 kernel/fork.c:1187
>  exit_mm+0x221/0x2d0 kernel/exit.c:615
>  do_exit+0x6cd/0x2360 kernel/exit.c:997
>  do_group_exit+0x22d/0x2f0 kernel/exit.c:1152
>  get_signal+0x121b/0x12c0 kernel/signal.c:3046
>  arch_do_signal_or_restart+0xbb/0x860 arch/x86/kernel/signal.c:337
>  __exit_to_user_mode_loop kernel/entry/common.c:66 [inline]
>  exit_to_user_mode_loop+0x104/0x730 kernel/entry/common.c:101
>  __exit_to_user_mode_prepare include/linux/irq-entry-common.h:207 [inline]
>  syscall_exit_to_user_mode_prepare include/linux/irq-entry-common.h:230 [inline]
>  syscall_exit_to_user_mode include/linux/entry-common.h:318 [inline]
>  do_syscall_64+0x353/0x580 arch/x86/entry/syscall_64.c:100
>  entry_SYSCALL_64_after_hwframe+0x77/0x7f
> RIP: 0033:0x7f46ce79e0d9
> Code: Unable to access opcode bytes at 0x7f46ce79e0af.
> RSP: 002b:00007f46cf6fc028 EFLAGS: 00000246 ORIG_RAX: 000000000000001c
> RAX: 0000000000000000 RBX: 00007f46cea26090 RCX: 00007f46ce79e0d9
> RDX: 0000000000000015 RSI: 0000000000600003 RDI: 0000200000000000
> RBP: 00007f46ce835024 R08: 0000000000000000 R09: 0000000000000000
> R10: 0000000000000000 R11: 0000000000000246 R12: 0000000000000000
> R13: 00007f46cea26128 R14: 00007f46cea26090 R15: 00007ffefd86c578
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
> To test a fix for this bug, please reply with `#syz test`
> (on a separate line) and attach the patch to the email.
> 
> Notes:
> - The patch will be applied on top of the tested series (as an
>   incremental fix).
> - To test a new version of the whole series, please send it directly
>   to syzbot@lists.linux.dev.
> - Arguments like custom git repos and branches are not supported.
