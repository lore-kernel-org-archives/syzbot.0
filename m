Received: from mail-ot1-f72.google.com (mail-ot1-f72.google.com [209.85.210.72])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 072134189C8
	for <syzbot@lists.linux.dev>; Mon,  6 Jul 2026 11:33:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.72
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783337582; cv=none; b=MpLt57CRt1jwsnMDUHTemMg3hxjhKQWJxNSUv6xxz5D+lc23Ab1m7zIWTft0uRZrYn1uwpYOqph9ZZ1w5K58mooknOY1ztBmz9Jjrh79E8LOefFJrV4yIg+mR7ethMf2ZX1aMLxZqwFsOYUnQ8nr3uUB9HXrsKRcm6953BuvzH4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783337582; c=relaxed/simple;
	bh=wtRVTag9XVFztyRV8FtuOZs4AKkrs7W2S6pjaW4Ik6o=;
	h=MIME-Version:Date:In-Reply-To:Message-ID:Subject:From:To:Cc:
	 Content-Type; b=IV9eI/xfq9/yTbq6DOaDxF3N2PQDdK/PlUEJFnBO31f8WNangUnsS3g/I4gcMZ4hItbbh2HobhHWMTcTi52weu1gCUwIXMCllnL6TO+1pkyO8iODVFtRIEK+60vCskyAbV+8NvX0sSm5xEOpF8FAufEDTwdDaXTbIHanuEdzi8Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com; arc=none smtp.client-ip=209.85.210.72
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com
Received: by mail-ot1-f72.google.com with SMTP id 46e09a7af769-7eb58b8b31aso3849064a34.3
        for <syzbot@lists.linux.dev>; Mon, 06 Jul 2026 04:33:00 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1783337580; x=1783942380;
        h=content-type:cc:to:from:subject:message-id:in-reply-to:date
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to:content-type;
        bh=51dmfBwSHWFCd9hU5eJF4GJJoeLzk8fO8LRXc1p1N3g=;
        b=PBzFoxgAuqtG/bYwqmXMMAR5aFGhtSDoRQyMYOTSE5smzm2WF5zLQ/n0ldC9B7NBp6
         wb0i9WlIKOjXMGezktnexP5pNgPobbbLzhdTnYRI2VMfibg/k4WuF8W8RFyHRjW+Scxz
         oVPlv5Bn6Z7E2DKzjHKpOZl3ozbtNPjxN0GO1Rb+tcg+pIDi/liuDTCjGVSXV2CmWC46
         y8AL2/u6gQRHXtMHhnyAnelsFRnkv3UmbEFSV45zXfoC156jW9BUt/seHMD8X3MmXaE7
         S6MlKxkiw1uTABk8kyrgAP8ZmQtPcjEAOk9JJkyXKfKBAy9rPP9InKf0uY0zI1LWGDrb
         IOHQ==
X-Gm-Message-State: AOJu0Yzx+7H66Eb3hbr9By1oyjTi8Ni1ImcCNeDWpgulOqyJ0aWY7Hae
	DI+4jp87TDeL6Aso6MheLQVLYQ+OpKMV5qvMWfBMTWluHRO50mCQ/gL7zxhI1OPgvmnyVoNafBY
	57i95UhhF+qyxp7T142avj19HVVP0iQZwBob1WaGy69ps/NjndBJRn5KPCLo=
Precedence: bulk
X-Mailing-List: syzbot@lists.linux.dev
List-Id: <syzbot.lists.linux.dev>
List-Subscribe: <mailto:syzbot+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:syzbot+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Received: by 2002:a05:6820:2d03:b0:6a1:871b:fffa with SMTP id
 006d021491bc7-6a3555b0798mr8878eaf.51.1783337579971; Mon, 06 Jul 2026
 04:32:59 -0700 (PDT)
Date: Mon, 06 Jul 2026 04:32:59 -0700
In-Reply-To: <20260706061928.66713-1-byungchul@sk.com>
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <6a4b926b.b42ede87.8bd1.0024.GAE@google.com>
Subject: [syzbot ci] Re: DEPT(DEPendency Tracker)
From: syzbot ci <syzbot+ci3d302dfdee3ed7e8@syzkaller.appspotmail.com>
To: 2407018371@qq.com, a.hindborg@kernel.org, ada.coupriediaz@arm.com, 
	adilger.kernel@dilger.ca, akpm@linux-foundation.org, alex.gaynor@gmail.com, 
	alexander.shishkin@linux.intel.com, aliceryhl@google.com, amir73il@gmail.com, 
	andi.shyti@kernel.org, andrii@kernel.org, anna@kernel.org, arnd@arndb.de, 
	ast@kernel.org, bagasdotme@gmail.com, baolin.wang@linux.alibaba.com, 
	bigeasy@linutronix.de, bjorn3_gh@protonmail.com, boqun.feng@gmail.com, 
	bp@alien8.de, brauner@kernel.org, broonie@kernel.org, bsegall@google.com, 
	byungchul@sk.com, catalin.marinas@arm.com, chenhuacai@kernel.org, 
	chris.p.wilson@intel.com, christian.koenig@amd.com, chuck.lever@oracle.com, 
	cl@linux.com, clrkwllms@kernel.org, corbet@lwn.net, da.gomez@kernel.org, 
	dai.ngo@oracle.com, dakr@kernel.org, damien.lemoal@opensource.wdc.com, 
	dan.j.williams@intel.com, daniel.vetter@ffwll.ch, dave.hansen@intel.com, 
	david@fromorbit.com, dennis@kernel.org, dietmar.eggemann@arm.com, 
	djwong@kernel.org, dri-devel@lists.freedesktop.org, duyuyang@gmail.com, 
	dwmw@amazon.co.uk, francesco@valla.it, frederic@kernel.org, gary@garyguo.net, 
	geert@glider.be
Cc: syzbot@lists.linux.dev, syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"

syzbot ci has tested the following series

[v19] DEPT(DEPendency Tracker)
https://lore.kernel.org/all/20260706061928.66713-1-byungchul@sk.com
* [PATCH v19 01/40] dept: implement DEPT(DEPendency Tracker)
* [PATCH v19 02/40] dept: add single event dependency tracker APIs
* [PATCH v19 03/40] dept: add lock dependency tracker APIs
* [PATCH v19 04/40] dept: tie to lockdep and IRQ tracing
* [PATCH v19 05/40] dept: add proc knobs to show stats and dependency graph
* [PATCH v19 06/40] dept: distinguish each kernel context from another
* [PATCH v19 07/40] dept: distinguish each work from another
* [PATCH v19 08/40] dept: add a mechanism to refill the internal memory pools on running out
* [PATCH v19 09/40] dept: record the latest one out of consecutive waits of the same class
* [PATCH v19 10/40] dept: apply sdt_might_sleep_{start,end}() to wait_for_completion()/complete()
* [PATCH v19 11/40] dept: apply sdt_might_sleep_{start,end}() to swait
* [PATCH v19 12/40] dept: apply sdt_might_sleep_{start,end}() to waitqueue wait
* [PATCH v19 13/40] dept: apply sdt_might_sleep_{start,end}() to hashed-waitqueue wait
* [PATCH v19 14/40] dept: apply sdt_might_sleep_{start,end}() to dma fence
* [PATCH v19 15/40] dept: track timeout waits separately with a new Kconfig
* [PATCH v19 16/40] dept: apply timeout consideration to wait_for_completion()/complete()
* [PATCH v19 17/40] dept: apply timeout consideration to swait
* [PATCH v19 18/40] dept: apply timeout consideration to waitqueue wait
* [PATCH v19 19/40] dept: apply timeout consideration to hashed-waitqueue wait
* [PATCH v19 20/40] dept: apply timeout consideration to dma fence wait
* [PATCH v19 21/40] dept: make dept able to work with an external wgen
* [PATCH v19 22/40] dept: track PG_locked with dept
* [PATCH v19 23/40] dept: print staged wait's stacktrace on report
* [PATCH v19 24/40] locking/lockdep: prevent various lockdep assertions when lockdep_off()'ed
* [PATCH v19 25/40] dept: add documents for dept
* [PATCH v19 26/40] cpu/hotplug: use a weaker annotation in AP thread
* [PATCH v19 27/40] dept: assign dept map to mmu notifier invalidation synchronization
* [PATCH v19 28/40] dept: assign unique dept_key to each distinct dma fence caller
* [PATCH v19 29/40] dept: make dept aware of lockdep_set_lock_cmp_fn() annotation
* [PATCH v19 30/40] dept: make dept stop from working on debug_locks_off()
* [PATCH v19 31/40] dept: assign unique dept_key to each distinct wait_for_completion() caller
* [PATCH v19 32/40] completion, dept: introduce init_completion_dmap() API
* [PATCH v19 33/40] dept: call dept_hardirqs_off() in local_irq_*() regardless of irq state
* [PATCH v19 34/40] rcu/update: fix same dept key collision between various types of RCU
* [PATCH v19 35/40] dept: introduce APIs to set page usage and use subclasses_evt for the usage
* [PATCH v19 36/40] dept: track PG_writeback with dept
* [PATCH v19 37/40] SUNRPC: relocate struct rcu_head to the first field of struct rpc_xprt
* [PATCH v19 38/40] mm: percpu: increase PERCPU_DYNAMIC_SIZE_SHIFT on DEPT and large PAGE_SIZE
* [PATCH v19 39/40] rust: completion: Add __rust_helper to rust_helper_wait_for_completion()
* [PATCH v19 40/40] dept: implement a basic unit test for dept

and found the following issue:
KASAN: slab-use-after-free Read in __dept_wait

Full report is available here:
https://ci.syzbot.org/series/bad70fd4-71dd-485d-92ef-f266796152e3

***

KASAN: slab-use-after-free Read in __dept_wait

tree:      bpf-next
URL:       https://kernel.googlesource.com/pub/scm/linux/kernel/git/bpf/bpf-next.git
base:      028ef9c96e96197026887c0f092424679298aae8
arch:      amd64
compiler:  Debian clang version 22.1.6 (++20260514074242+fc4aad7b5db3-1~exp1~20260514074407.73), Debian LLD 22.1.6
config:    https://ci.syzbot.org/builds/e0007242-bbfe-42b9-ad3e-e15fe3f29261/config
syz repro: https://ci.syzbot.org/findings/1c2fe55b-5fa6-4b20-a73c-b9bbc70528f7/syz_repro

==================================================================
BUG: KASAN: slab-use-after-free in lockdep_cmp_fn kernel/dependency/dept.c:1647 [inline]
BUG: KASAN: slab-use-after-free in add_wait kernel/dependency/dept.c:1710 [inline]
BUG: KASAN: slab-use-after-free in __dept_wait+0xe66/0x1b70 kernel/dependency/dept.c:2422
Read of size 8 at addr ffff8881a7a30190 by task syz.1.18/5874

CPU: 1 UID: 0 PID: 5874 Comm: syz.1.18 Not tainted syzkaller #0 PREEMPT(full) 
Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS 1.16.2-debian-1.16.2-1 04/01/2014
Call Trace:
 <IRQ>
 dump_stack_lvl+0xed/0x160 lib/dump_stack.c:120
 print_address_description mm/kasan/report.c:378 [inline]
 print_report+0xbe/0x230 mm/kasan/report.c:482
 kasan_report+0x117/0x150 mm/kasan/report.c:595
 lockdep_cmp_fn kernel/dependency/dept.c:1647 [inline]
 add_wait kernel/dependency/dept.c:1710 [inline]
 __dept_wait+0xe66/0x1b70 kernel/dependency/dept.c:2422
 dept_wait+0x135/0x1a0 kernel/dependency/dept.c:2483
 __raw_spin_lock_irqsave include/linux/spinlock_api_smp.h:132 [inline]
 _raw_spin_lock_irqsave+0x5b/0xc0 kernel/locking/spinlock.c:162
 debug_object_active_state+0x77/0x390 lib/debugobjects.c:1063
 debug_rcu_head_unqueue kernel/rcu/rcu.h:246 [inline]
 rcu_do_batch kernel/rcu/tree.c:2609 [inline]
 rcu_core+0x6f9/0xff0 kernel/rcu/tree.c:2869
 handle_softirqs+0x231/0x890 kernel/softirq.c:622
 __do_softirq kernel/softirq.c:656 [inline]
 invoke_softirq kernel/softirq.c:496 [inline]
 __irq_exit_rcu+0x66/0x150 kernel/softirq.c:723
 irq_exit_rcu+0x9/0x30 kernel/softirq.c:739
 instr_sysvec_apic_timer_interrupt arch/x86/kernel/apic/apic.c:1056 [inline]
 sysvec_apic_timer_interrupt+0xa6/0xc0 arch/x86/kernel/apic/apic.c:1056
 </IRQ>
 <TASK>
 asm_sysvec_apic_timer_interrupt+0x1a/0x20 arch/x86/include/asm/idtentry.h:697
RIP: 0010:lock_acquire+0x20b/0x2e0 kernel/locking/lockdep.c:5893
Code: e9 30 ff ff ff e8 c5 62 fd 09 f7 c3 00 02 00 00 0f 84 38 ff ff ff 65 48 8b 05 d1 2e 84 11 48 3b 44 24 30 75 33 fb 48 83 c4 38 <5b> 41 5c 41 5d 41 5e 41 5f 5d c3 cc cc cc cc cc 48 8d 3d 6e 8d 82
RSP: 0018:ffffc900041e74a8 EFLAGS: 00000282
RAX: e0efb026e1546b00 RBX: 0000000000000246 RCX: 0000000000000046
RDX: 00000000279c9488 RSI: ffffffff8e150025 RDI: ffffffff8c281c40
RBP: 0000000000000000 R08: ffffffff81764955 R09: 0000000000000000
R10: 0000000000000000 R11: ffffffff8e7da2a0 R12: 0000000000000002
R13: ffffffff8e7da2a0 R14: 0000000000000000 R15: 0000000000000000
 rcu_lock_acquire include/linux/rcupdate.h:312 [inline]
 rcu_read_lock include/linux/rcupdate.h:850 [inline]
 class_rcu_constructor include/linux/rcupdate.h:1193 [inline]
 unwind_next_frame+0xb2/0x2380 arch/x86/kernel/unwind_orc.c:495
 __unwind_start+0x4f2/0x640 arch/x86/kernel/unwind_orc.c:773
 unwind_start arch/x86/include/asm/unwind.h:64 [inline]
 arch_stack_walk+0xe3/0x150 arch/x86/kernel/stacktrace.c:24
 stack_trace_save+0xa9/0x100 kernel/stacktrace.c:122
 kasan_save_stack mm/kasan/common.c:57 [inline]
 kasan_save_track+0x3e/0x80 mm/kasan/common.c:78
 kasan_save_free_info+0x40/0x50 mm/kasan/generic.c:584
 poison_slab_object mm/kasan/common.c:253 [inline]
 __kasan_slab_free+0x5c/0x80 mm/kasan/common.c:285
 kasan_slab_free include/linux/kasan.h:235 [inline]
 slab_free_hook mm/slub.c:2685 [inline]
 slab_free mm/slub.c:6165 [inline]
 kfree+0x1c5/0x640 mm/slub.c:6483
 xfs_mountfs+0x1458/0x2350 fs/xfs/xfs_mount.c:1280
 xfs_fs_fill_super+0x11a2/0x15f0 fs/xfs/xfs_super.c:1938
 get_tree_bdev_flags+0x430/0x4f0 fs/super.c:1694
 vfs_get_tree+0x92/0x2a0 fs/super.c:1754
 fc_mount fs/namespace.c:1193 [inline]
 do_new_mount_fc fs/namespace.c:3763 [inline]
 do_new_mount+0x319/0xdd0 fs/namespace.c:3839
 do_mount fs/namespace.c:4172 [inline]
 __do_sys_mount fs/namespace.c:4361 [inline]
 __se_sys_mount+0x31d/0x420 fs/namespace.c:4338
 do_syscall_x64 arch/x86/entry/syscall_64.c:63 [inline]
 do_syscall_64+0x175/0xf80 arch/x86/entry/syscall_64.c:94
 entry_SYSCALL_64_after_hwframe+0x77/0x7f
RIP: 0033:0x7f6977f9e0ca
Code: 48 c7 c2 e8 ff ff ff f7 d8 64 89 02 b8 ff ff ff ff c3 66 2e 0f 1f 84 00 00 00 00 00 0f 1f 40 00 49 89 ca b8 a5 00 00 00 0f 05 <48> 3d 01 f0 ff ff 73 01 c3 48 c7 c1 e8 ff ff ff f7 d8 64 89 01 48
RSP: 002b:00007f6978ec5e58 EFLAGS: 00000246 ORIG_RAX: 00000000000000a5
RAX: ffffffffffffffda RBX: 00007f6978ec5ee0 RCX: 00007f6977f9e0ca
RDX: 0000200000000040 RSI: 00002000000000c0 RDI: 00007f6978ec5ea0
RBP: 0000200000000040 R08: 00007f6978ec5ee0 R09: 0000000000000001
R10: 0000000000000001 R11: 0000000000000246 R12: 00002000000000c0
R13: 00007f6978ec5ea0 R14: 0000000000009888 R15: 0000200000000080
 </TASK>

Allocated by task 5874:
 kasan_save_stack mm/kasan/common.c:57 [inline]
 kasan_save_track+0x3e/0x80 mm/kasan/common.c:78
 unpoison_slab_object mm/kasan/common.c:340 [inline]
 __kasan_slab_alloc+0x6c/0x80 mm/kasan/common.c:366
 kasan_slab_alloc include/linux/kasan.h:253 [inline]
 slab_post_alloc_hook mm/slub.c:4538 [inline]
 slab_alloc_node mm/slub.c:4866 [inline]
 kmem_cache_alloc_lru_noprof+0x2b4/0x640 mm/slub.c:4885
 xfs_inode_alloc+0x7e/0x710 fs/xfs/xfs_icache.c:97
 xfs_iget_cache_miss fs/xfs/xfs_icache.c:637 [inline]
 xfs_iget+0xa6b/0x2ef0 fs/xfs/xfs_icache.c:808
 xfs_mountfs+0x1165/0x2350 fs/xfs/xfs_mount.c:1073
 xfs_fs_fill_super+0x11a2/0x15f0 fs/xfs/xfs_super.c:1938
 get_tree_bdev_flags+0x430/0x4f0 fs/super.c:1694
 vfs_get_tree+0x92/0x2a0 fs/super.c:1754
 fc_mount fs/namespace.c:1193 [inline]
 do_new_mount_fc fs/namespace.c:3763 [inline]
 do_new_mount+0x319/0xdd0 fs/namespace.c:3839
 do_mount fs/namespace.c:4172 [inline]
 __do_sys_mount fs/namespace.c:4361 [inline]
 __se_sys_mount+0x31d/0x420 fs/namespace.c:4338
 do_syscall_x64 arch/x86/entry/syscall_64.c:63 [inline]
 do_syscall_64+0x175/0xf80 arch/x86/entry/syscall_64.c:94
 entry_SYSCALL_64_after_hwframe+0x77/0x7f

Freed by task 5874:
 kasan_save_stack mm/kasan/common.c:57 [inline]
 kasan_save_track+0x3e/0x80 mm/kasan/common.c:78
 kasan_save_free_info+0x40/0x50 mm/kasan/generic.c:584
 poison_slab_object mm/kasan/common.c:253 [inline]
 __kasan_slab_free+0x5c/0x80 mm/kasan/common.c:285
 kasan_slab_free include/linux/kasan.h:235 [inline]
 slab_free_hook mm/slub.c:2685 [inline]
 slab_free mm/slub.c:6165 [inline]
 kmem_cache_free+0x18c/0x630 mm/slub.c:6295
 rcu_do_batch kernel/rcu/tree.c:2617 [inline]
 rcu_core+0x794/0xff0 kernel/rcu/tree.c:2869
 handle_softirqs+0x231/0x890 kernel/softirq.c:622
 __do_softirq kernel/softirq.c:656 [inline]
 invoke_softirq kernel/softirq.c:496 [inline]
 __irq_exit_rcu+0x66/0x150 kernel/softirq.c:723
 irq_exit_rcu+0x9/0x30 kernel/softirq.c:739
 instr_sysvec_apic_timer_interrupt arch/x86/kernel/apic/apic.c:1056 [inline]
 sysvec_apic_timer_interrupt+0xa6/0xc0 arch/x86/kernel/apic/apic.c:1056
 asm_sysvec_apic_timer_interrupt+0x1a/0x20 arch/x86/include/asm/idtentry.h:697

Last potentially related work creation:
 kasan_save_stack+0x3e/0x60 mm/kasan/common.c:57
 kasan_record_aux_stack+0xcb/0xe0 mm/kasan/generic.c:556
 __call_rcu_common kernel/rcu/tree.c:3131 [inline]
 call_rcu+0xf7/0x890 kernel/rcu/tree.c:3251
 xfs_reclaim_inode fs/xfs/xfs_icache.c:1049 [inline]
 xfs_icwalk_process_inode fs/xfs/xfs_icache.c:1736 [inline]
 xfs_icwalk_ag+0x1204/0x18c0 fs/xfs/xfs_icache.c:1818
 xfs_icwalk fs/xfs/xfs_icache.c:1866 [inline]
 xfs_reclaim_inodes+0x1b6/0x2b0 fs/xfs/xfs_icache.c:1082
 xfs_unmount_flush_inodes+0xb1/0xd0 fs/xfs/xfs_mount.c:628
 xfs_mountfs+0x1325/0x2350 fs/xfs/xfs_mount.c:1267
 xfs_fs_fill_super+0x11a2/0x15f0 fs/xfs/xfs_super.c:1938
 get_tree_bdev_flags+0x430/0x4f0 fs/super.c:1694
 vfs_get_tree+0x92/0x2a0 fs/super.c:1754
 fc_mount fs/namespace.c:1193 [inline]
 do_new_mount_fc fs/namespace.c:3763 [inline]
 do_new_mount+0x319/0xdd0 fs/namespace.c:3839
 do_mount fs/namespace.c:4172 [inline]
 __do_sys_mount fs/namespace.c:4361 [inline]
 __se_sys_mount+0x31d/0x420 fs/namespace.c:4338
 do_syscall_x64 arch/x86/entry/syscall_64.c:63 [inline]
 do_syscall_64+0x175/0xf80 arch/x86/entry/syscall_64.c:94
 entry_SYSCALL_64_after_hwframe+0x77/0x7f

The buggy address belongs to the object at ffff8881a7a30000
 which belongs to the cache xfs_inode of size 2672
The buggy address is located 400 bytes inside of
 freed 2672-byte region [ffff8881a7a30000, ffff8881a7a30a70)

The buggy address belongs to the physical page:
page: refcount:0 mapcount:0 mapping:0000000000000000 index:0xffff8881a7a30b00 pfn:0x1a7a30
head: order:3 mapcount:0 entire_mapcount:0 nr_pages_mapped:0 pincount:0
memcg:ffff8881a7a37901
flags: 0x57ff00000000240(workingset|head|node=1|zone=2|lastcpupid=0x7ff)
page_type: f5(slab)
raw: 057ff00000000240 ffff8881604168c0 ffff888163eabc88 ffff888163eabc88
raw: ffff8881a7a30b00 00000008000b0001 00000000f5000000 ffff8881a7a37901
raw: 0000000000000000 0000000000000000
head: 057ff00000000240 ffff8881604168c0 ffff888163eabc88 ffff888163eabc88
head: ffff8881a7a30b00 00000008000b0001 00000000f5000000 ffff8881a7a37901
head: 0000000000000000 0000000000000000 057ff00000000003 ffffea0008462f01
head: 00000000ffffffff 00000000ffffffff ffffffffffffffff 0000000000000000
head: 00000000ffffffff 0000000000000008 0000000000000000 0000000000000000
page dumped because: kasan: bad access detected
page_owner tracks the page as allocated
page last allocated via order 3, migratetype Reclaimable, gfp_mask 0xd20d0(__GFP_RECLAIMABLE|__GFP_IO|__GFP_FS|__GFP_NOWARN|__GFP_NORETRY|__GFP_COMP|__GFP_NOMEMALLOC), pid 5874, tgid 5873 (syz.1.18), ts 154889839111, free_ts 140490269358
 set_page_owner include/linux/page_owner.h:32 [inline]
 post_alloc_hook+0x239/0x290 mm/page_alloc.c:1889
 prep_new_page mm/page_alloc.c:1897 [inline]
 get_page_from_freelist+0x2541/0x25e0 mm/page_alloc.c:3962
 __alloc_frozen_pages_noprof+0x18d/0x380 mm/page_alloc.c:5250
 alloc_slab_page mm/slub.c:3292 [inline]
 allocate_slab+0x77/0x6a0 mm/slub.c:3481
 new_slab mm/slub.c:3539 [inline]
 refill_objects+0x331/0x3c0 mm/slub.c:7175
 refill_sheaf mm/slub.c:2812 [inline]
 alloc_full_sheaf mm/slub.c:2834 [inline]
 __pcs_replace_empty_main+0x428/0x760 mm/slub.c:4626
 alloc_from_pcs mm/slub.c:4717 [inline]
 slab_alloc_node mm/slub.c:4851 [inline]
 kmem_cache_alloc_lru_noprof+0x372/0x640 mm/slub.c:4885
 xfs_inode_alloc+0x7e/0x710 fs/xfs/xfs_icache.c:97
 xfs_iget_cache_miss fs/xfs/xfs_icache.c:637 [inline]
 xfs_iget+0xa6b/0x2ef0 fs/xfs/xfs_icache.c:808
 xfs_mountfs+0x1165/0x2350 fs/xfs/xfs_mount.c:1073
 xfs_fs_fill_super+0x11a2/0x15f0 fs/xfs/xfs_super.c:1938
 get_tree_bdev_flags+0x430/0x4f0 fs/super.c:1694
 vfs_get_tree+0x92/0x2a0 fs/super.c:1754
 fc_mount fs/namespace.c:1193 [inline]
 do_new_mount_fc fs/namespace.c:3763 [inline]
 do_new_mount+0x319/0xdd0 fs/namespace.c:3839
 do_mount fs/namespace.c:4172 [inline]
 __do_sys_mount fs/namespace.c:4361 [inline]
 __se_sys_mount+0x31d/0x420 fs/namespace.c:4338
 do_syscall_x64 arch/x86/entry/syscall_64.c:63 [inline]
 do_syscall_64+0x175/0xf80 arch/x86/entry/syscall_64.c:94
page last free pid 5668 tgid 5668 stack trace:
 reset_page_owner include/linux/page_owner.h:25 [inline]
 __free_pages_prepare mm/page_alloc.c:1433 [inline]
 __free_frozen_pages+0xc81/0xe10 mm/page_alloc.c:2978
 vfree+0x25b/0x400 mm/vmalloc.c:3479
 kcov_put kernel/kcov.c:444 [inline]
 kcov_close+0x2e/0x60 kernel/kcov.c:543
 __fput+0x440/0xa80 fs/file_table.c:469
 task_work_run+0x1d9/0x270 kernel/task_work.c:233
 exit_task_work include/linux/task_work.h:40 [inline]
 do_exit+0x73a/0x2470 kernel/exit.c:976
 do_group_exit+0x22d/0x2f0 kernel/exit.c:1119
 get_signal+0x121b/0x12c0 kernel/signal.c:3034
 arch_do_signal_or_restart+0xbb/0x810 arch/x86/kernel/signal.c:337
 __exit_to_user_mode_loop kernel/entry/common.c:64 [inline]
 exit_to_user_mode_loop+0xa8/0x5f0 kernel/entry/common.c:98
 __exit_to_user_mode_prepare include/linux/irq-entry-common.h:230 [inline]
 syscall_exit_to_user_mode_prepare include/linux/irq-entry-common.h:260 [inline]
 syscall_exit_to_user_mode include/linux/entry-common.h:325 [inline]
 do_syscall_64+0x37e/0xf80 arch/x86/entry/syscall_64.c:100
 entry_SYSCALL_64_after_hwframe+0x77/0x7f

Memory state around the buggy address:
 ffff8881a7a30080: fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb
 ffff8881a7a30100: fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb
>ffff8881a7a30180: fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb
                         ^
 ffff8881a7a30200: fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb
 ffff8881a7a30280: fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb
==================================================================
----------------
Code disassembly (best guess):
   0:	e9 30 ff ff ff       	jmp    0xffffff35
   5:	e8 c5 62 fd 09       	call   0x9fd62cf
   a:	f7 c3 00 02 00 00    	test   $0x200,%ebx
  10:	0f 84 38 ff ff ff    	je     0xffffff4e
  16:	65 48 8b 05 d1 2e 84 	mov    %gs:0x11842ed1(%rip),%rax        # 0x11842eef
  1d:	11
  1e:	48 3b 44 24 30       	cmp    0x30(%rsp),%rax
  23:	75 33                	jne    0x58
  25:	fb                   	sti
  26:	48 83 c4 38          	add    $0x38,%rsp
* 2a:	5b                   	pop    %rbx <-- trapping instruction
  2b:	41 5c                	pop    %r12
  2d:	41 5d                	pop    %r13
  2f:	41 5e                	pop    %r14
  31:	41 5f                	pop    %r15
  33:	5d                   	pop    %rbp
  34:	c3                   	ret
  35:	cc                   	int3
  36:	cc                   	int3
  37:	cc                   	int3
  38:	cc                   	int3
  39:	cc                   	int3
  3a:	48                   	rex.W
  3b:	8d                   	.byte 0x8d
  3c:	3d                   	.byte 0x3d
  3d:	6e                   	outsb  %ds:(%rsi),(%dx)
  3e:	8d                   	.byte 0x8d
  3f:	82                   	.byte 0x82


***

If these findings have caused you to resend the series or submit a
separate fix, please add the following tag to your commit message:
  Tested-by: syzbot@syzkaller.appspotmail.com

---
This report is generated by a bot. It may contain errors.
syzbot ci engineers can be reached at syzkaller@googlegroups.com.

To test a patch for this bug, please reply with `#syz test`
(should be on a separate line).

The patch should be attached to the email.
Note: arguments like custom git repos and branches are not supported.
