Received: from mail-ot1-f69.google.com (mail-ot1-f69.google.com [209.85.210.69])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BCAA733F8B4
	for <syzbot@lists.linux.dev>; Sat, 30 May 2026 16:07:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.69
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780157246; cv=none; b=rdp8v6LdXTvr0k/gTeM9ViiAd6hh+hDW3cyYQXyJJAp5MqlSlLdrYBFp7gqp0BN8C7Mq4o2L9f4rf5TYdzYKseVA+1ddxslV/+ipxzaeDDsAuftJlOAK+FfQ7BTzHy0PwNCp2Y0s53vEjCu6BvSLbTXs7OCAS/1PfNz0SSd1760=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780157246; c=relaxed/simple;
	bh=0YslOxx2EJ8kDNS7tu6gRk5TYiWYoLoqolWy8Ho4ugY=;
	h=MIME-Version:Date:Message-ID:Subject:From:To:Cc:Content-Type; b=NfYpvG81udyGcHh9lu+wUuWkCW28YoDr14KxUcExiAZhbFOMqjZAx0ZnCZgJ6R3PjD8+cxIZt+9gSBk9G3vbyeRqY4Qrx8vkW4KXQjWg2WNoeAIyxxmYiDE+Pvz5MBcq8ajTEUQzI41bt9SZkpC8JXf1Vjq0dJSxAop4fOI5IiM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com; arc=none smtp.client-ip=209.85.210.69
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com
Received: by mail-ot1-f69.google.com with SMTP id 46e09a7af769-7e63575a87cso9194984a34.2
        for <syzbot@lists.linux.dev>; Sat, 30 May 2026 09:07:23 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1780157243; x=1780762043;
        h=cc:to:from:subject:message-id:date:mime-version:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=y+LB4Rl+wqUFx00CDfGXNgglmK0rFOaF4AQ0CPueiwo=;
        b=NHYiNutSz0ZKoldnvzNJd4lP8I2Od2OTIMWN/IWJjOMB42uILVJ01XI09r6IV8nq1n
         znZxQYy274VYcf3Tg/zCFE3u/z1o+NiAm1b6x1d5sStEnJJ0dpombeXNl+HXt5Xufqrt
         0t2vAY+DzHQP351W7+JX35wp7jRyHAvSRHejSdhAH8DVoYc40tyU4GqqhpklT9ad0zlz
         69OquAVk+87fIx+45Y+VvYHM8QYK3x6O7NQFHPWHwz3YMWmcc7IirQiT983GNXp3YNI5
         61Xrd4XTyh3wdqXirptZ1sIyN/6UG1VPaOb/XfLRIIh99td+gXYjNeUlvZnkk+Gk0pqg
         4MdA==
X-Gm-Message-State: AOJu0Yz5Q+tiv9NXoAVgOvD46YYSZ4luGC0vro8RiIomKKTTUZYYzdhL
	6GkSXqDGR8+pWkTi8FfiAwSe0KPbkPKBDk8jRIzdkNNCUOfd5MRIJKOVArRiAj3wHUVUS6aVvJ0
	5VZl6/OyO8bRPECiyuuxe/znv9YPh46c5kk35DqvqWKe9YSPittXlzqNBpOc=
Precedence: bulk
X-Mailing-List: syzbot@lists.linux.dev
List-Id: <syzbot.lists.linux.dev>
List-Subscribe: <mailto:syzbot+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:syzbot+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Received: by 2002:a05:6820:81c2:b0:69d:8d74:d7d1 with SMTP id
 006d021491bc7-69e103e474cmr1798590eaf.55.1780157242728; Sat, 30 May 2026
 09:07:22 -0700 (PDT)
Date: Sat, 30 May 2026 09:07:22 -0700
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <6a1b0b3a.fd5edf16.2e7427.0006.GAE@google.com>
Subject: [moderation/CI] Re: net/sched: act_api: use RCU with deferred freeing
 for action lifecycle
From: syzbot ci <syzbot+ci8d851368760f8ee6@syzkaller.appspotmail.com>
To: syzkaller-upstream-moderation@googlegroups.com
Cc: syzbot@lists.linux.dev
Content-Type: text/plain; charset="UTF-8"

syzbot ci has tested the following series

[v1] net/sched: act_api: use RCU with deferred freeing for action lifecycle
https://lore.kernel.org/all/20260530115511.1352487-1-jhs@mojatatu.com
* [PATCH net 1/1] net/sched: act_api: use RCU with deferred freeing for action lifecycle

and found the following issues:
* BUG: sleeping function called from invalid context in __tcf_chain_put
* inconsistent lock state in tcf_mirred_release

Full report is available here:
https://ci.syzbot.org/series/526aa788-9a02-4038-b101-5daf4d3436a2

***

BUG: sleeping function called from invalid context in __tcf_chain_put

tree:      net
URL:       https://kernel.googlesource.com/pub/scm/linux/kernel/git/netdev/net.git
base:      78ef59e7a6459b16f8102e0ee1c718443323d1af
arch:      amd64
compiler:  Debian clang version 21.1.8 (++20251221033036+2078da43e25a-1~exp1~20251221153213.50), Debian LLD 21.1.8
config:    https://ci.syzbot.org/builds/46884a04-6831-455e-8868-d463d6e018db/config
syz repro: https://ci.syzbot.org/findings/3fb6310c-78f8-44da-bd19-4acd582420fa/syz_repro

BUG: sleeping function called from invalid context at kernel/locking/mutex.c:623
in_atomic(): 1, irqs_disabled(): 0, non_block: 0, pid: 23, name: ksoftirqd/1
preempt_count: 100, expected: 0
RCU nest depth: 0, expected: 0
1 lock held by ksoftirqd/1/23:
 #0: ffffffff8e95ce00 (rcu_callback){....}-{0:0}, at: rcu_lock_acquire include/linux/rcupdate.h:300 [inline]
 #0: ffffffff8e95ce00 (rcu_callback){....}-{0:0}, at: rcu_do_batch kernel/rcu/tree.c:2611 [inline]
 #0: ffffffff8e95ce00 (rcu_callback){....}-{0:0}, at: rcu_core+0x751/0x1070 kernel/rcu/tree.c:2869
Preemption disabled at:
[<ffffffff8187d090>] softirq_handle_begin kernel/softirq.c:463 [inline]
[<ffffffff8187d090>] handle_softirqs+0xb0/0x840 kernel/softirq.c:598
CPU: 1 UID: 0 PID: 23 Comm: ksoftirqd/1 Not tainted syzkaller #0 PREEMPT(full) 
Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS 1.16.2-debian-1.16.2-1 04/01/2014
Call Trace:
 <TASK>
 dump_stack_lvl+0xe8/0x150 lib/dump_stack.c:120
 __might_resched+0x378/0x4d0 kernel/sched/core.c:9163
 __mutex_lock_common kernel/locking/mutex.c:623 [inline]
 __mutex_lock+0x11c/0x1550 kernel/locking/mutex.c:820
 __tcf_chain_put+0x60/0x820 net/sched/cls_api.c:694
 free_tcf net/sched/act_api.c:130 [inline]
 tcf_action_cleanup net/sched/act_api.c:370 [inline]
 tcf_action_rcu_free+0x39d/0x440 net/sched/act_api.c:378
 rcu_do_batch kernel/rcu/tree.c:2617 [inline]
 rcu_core+0x7cd/0x1070 kernel/rcu/tree.c:2869
 handle_softirqs+0x22a/0x840 kernel/softirq.c:622
 run_ksoftirqd+0x36/0x60 kernel/softirq.c:1076
 smpboot_thread_fn+0x541/0xa50 kernel/smpboot.c:160
 kthread+0x389/0x470 kernel/kthread.c:436
 ret_from_fork+0x514/0xb70 arch/x86/kernel/process.c:158
 ret_from_fork_asm+0x1a/0x30 arch/x86/entry/entry_64.S:245
 </TASK>

=============================
[ BUG: Invalid wait context ]
syzkaller #0 Tainted: G        W          
-----------------------------
ksoftirqd/1/23 is trying to lock:
ffff888171e3b0b0 (&block->lock){+.+.}-{4:4}, at: __tcf_chain_put+0x60/0x820 net/sched/cls_api.c:694
other info that might help us debug this:
context-{3:3}
1 lock held by ksoftirqd/1/23:
 #0: ffffffff8e95ce00 (rcu_callback){....}-{0:0}, at: rcu_lock_acquire include/linux/rcupdate.h:300 [inline]
 #0: ffffffff8e95ce00 (rcu_callback){....}-{0:0}, at: rcu_do_batch kernel/rcu/tree.c:2611 [inline]
 #0: ffffffff8e95ce00 (rcu_callback){....}-{0:0}, at: rcu_core+0x751/0x1070 kernel/rcu/tree.c:2869
stack backtrace:
CPU: 1 UID: 0 PID: 23 Comm: ksoftirqd/1 Tainted: G        W           syzkaller #0 PREEMPT(full) 
Tainted: [W]=WARN
Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS 1.16.2-debian-1.16.2-1 04/01/2014
Call Trace:
 <TASK>
 dump_stack_lvl+0xe8/0x150 lib/dump_stack.c:120
 print_lock_invalid_wait_context kernel/locking/lockdep.c:4830 [inline]
 check_wait_context kernel/locking/lockdep.c:4902 [inline]
 __lock_acquire+0xec1/0x2cf0 kernel/locking/lockdep.c:5187
 lock_acquire+0x106/0x350 kernel/locking/lockdep.c:5868
 __mutex_lock_common kernel/locking/mutex.c:646 [inline]
 __mutex_lock+0x1a3/0x1550 kernel/locking/mutex.c:820
 __tcf_chain_put+0x60/0x820 net/sched/cls_api.c:694
 free_tcf net/sched/act_api.c:130 [inline]
 tcf_action_cleanup net/sched/act_api.c:370 [inline]
 tcf_action_rcu_free+0x39d/0x440 net/sched/act_api.c:378
 rcu_do_batch kernel/rcu/tree.c:2617 [inline]
 rcu_core+0x7cd/0x1070 kernel/rcu/tree.c:2869
 handle_softirqs+0x22a/0x840 kernel/softirq.c:622
 run_ksoftirqd+0x36/0x60 kernel/softirq.c:1076
 smpboot_thread_fn+0x541/0xa50 kernel/smpboot.c:160
 kthread+0x389/0x470 kernel/kthread.c:436
 ret_from_fork+0x514/0xb70 arch/x86/kernel/process.c:158
 ret_from_fork_asm+0x1a/0x30 arch/x86/entry/entry_64.S:245
 </TASK>
BUG: sleeping function called from invalid context at kernel/locking/mutex.c:623
in_atomic(): 1, irqs_disabled(): 0, non_block: 0, pid: 0, name: swapper/1
preempt_count: 101, expected: 0
RCU nest depth: 0, expected: 0
INFO: lockdep is turned off.
Preemption disabled at:
[<0000000000000000>] 0x0
CPU: 1 UID: 0 PID: 0 Comm: swapper/1 Tainted: G        W           syzkaller #0 PREEMPT(full) 
Tainted: [W]=WARN
Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS 1.16.2-debian-1.16.2-1 04/01/2014
Call Trace:
 <IRQ>
 dump_stack_lvl+0xe8/0x150 lib/dump_stack.c:120
 __might_resched+0x378/0x4d0 kernel/sched/core.c:9163
 __mutex_lock_common kernel/locking/mutex.c:623 [inline]
 __mutex_lock+0x11c/0x1550 kernel/locking/mutex.c:820
 __tcf_chain_put+0x60/0x820 net/sched/cls_api.c:694
 free_tcf net/sched/act_api.c:130 [inline]
 tcf_action_cleanup net/sched/act_api.c:370 [inline]
 tcf_action_rcu_free+0x39d/0x440 net/sched/act_api.c:378
 rcu_do_batch kernel/rcu/tree.c:2617 [inline]
 rcu_core+0x7cd/0x1070 kernel/rcu/tree.c:2869
 handle_softirqs+0x22a/0x840 kernel/softirq.c:622
 __do_softirq kernel/softirq.c:656 [inline]
 invoke_softirq kernel/softirq.c:496 [inline]
 __irq_exit_rcu+0xca/0x220 kernel/softirq.c:735
 irq_exit_rcu+0x9/0x30 kernel/softirq.c:752
 instr_sysvec_apic_timer_interrupt arch/x86/kernel/apic/apic.c:1061 [inline]
 sysvec_apic_timer_interrupt+0xa6/0xc0 arch/x86/kernel/apic/apic.c:1061
 </IRQ>
 <TASK>
 asm_sysvec_apic_timer_interrupt+0x1a/0x20 arch/x86/include/asm/idtentry.h:697
RIP: 0010:pv_native_safe_halt+0xf/0x20 arch/x86/kernel/paravirt.c:63
Code: 2b 7d 02 c3 cc cc cc cc cc cc cc 90 90 90 90 90 90 90 90 90 90 90 90 90 90 90 90 f3 0f 1e fa eb 07 0f 00 2d 03 c2 1f 00 fb f4 <e9> 7c f7 02 00 cc cc cc cc cc cc cc cc cc cc cc cc 90 90 90 90 90
RSP: 0018:ffffc90000197e20 EFLAGS: 00000246
RAX: ffff8882a9286000 RBX: ffffffff819a857a RCX: 0000000080000001
RDX: 0000000000000001 RSI: ffffffff8c28b7c0 RDI: ffffffff819a857a
RBP: ffffc90000197f10 R08: ffff88823c6339db R09: 1ffff110478c673b
R10: dffffc0000000000 R11: ffffed10478c673c R12: 0000000000000001
R13: 1ffff1102c09e000 R14: 0000000000000001 R15: 1ffff1102c09e000
 arch_safe_halt arch/x86/kernel/process.c:766 [inline]
 default_idle+0x9/0x20 arch/x86/kernel/process.c:767
 default_idle_call+0x72/0xb0 kernel/sched/idle.c:122
 cpuidle_idle_call kernel/sched/idle.c:199 [inline]
 do_idle+0x36a/0x5f0 kernel/sched/idle.c:352
 cpu_startup_entry+0x43/0x60 kernel/sched/idle.c:451
 start_secondary+0x101/0x110 arch/x86/kernel/smpboot.c:312
 common_startup_64+0x13e/0x147
 </TASK>
BUG: sleeping function called from invalid context at kernel/locking/mutex.c:623
in_atomic(): 1, irqs_disabled(): 0, non_block: 0, pid: 5742, name: syz-executor
preempt_count: 100, expected: 0
RCU nest depth: 0, expected: 0
INFO: lockdep is turned off.
Preemption disabled at:
[<ffffffff8187d090>] softirq_handle_begin kernel/softirq.c:463 [inline]
[<ffffffff8187d090>] handle_softirqs+0xb0/0x840 kernel/softirq.c:598
CPU: 1 UID: 0 PID: 5742 Comm: syz-executor Tainted: G        W           syzkaller #0 PREEMPT(full) 
Tainted: [W]=WARN
Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS 1.16.2-debian-1.16.2-1 04/01/2014
Call Trace:
 <IRQ>
 dump_stack_lvl+0xe8/0x150 lib/dump_stack.c:120
 __might_resched+0x378/0x4d0 kernel/sched/core.c:9163
 __mutex_lock_common kernel/locking/mutex.c:623 [inline]
 __mutex_lock+0x11c/0x1550 kernel/locking/mutex.c:820
 __tcf_chain_put+0x60/0x820 net/sched/cls_api.c:694
 free_tcf net/sched/act_api.c:130 [inline]
 tcf_action_cleanup net/sched/act_api.c:370 [inline]
 tcf_action_rcu_free+0x39d/0x440 net/sched/act_api.c:378
 rcu_do_batch kernel/rcu/tree.c:2617 [inline]
 rcu_core+0x7cd/0x1070 kernel/rcu/tree.c:2869
 handle_softirqs+0x22a/0x840 kernel/softirq.c:622
 __do_softirq kernel/softirq.c:656 [inline]
 invoke_softirq kernel/softirq.c:496 [inline]
 __irq_exit_rcu+0xca/0x220 kernel/softirq.c:735
 irq_exit_rcu+0x9/0x30 kernel/softirq.c:752
 instr_sysvec_apic_timer_interrupt arch/x86/kernel/apic/apic.c:1061 [inline]
 sysvec_apic_timer_interrupt+0xa6/0xc0 arch/x86/kernel/apic/apic.c:1061
 </IRQ>
 <TASK>
 asm_sysvec_apic_timer_interrupt+0x1a/0x20 arch/x86/include/asm/idtentry.h:697
RIP: 0010:qlink_to_object mm/kasan/quarantine.c:140 [inline]
RIP: 0010:qlink_free mm/kasan/quarantine.c:145 [inline]
RIP: 0010:qlist_free_all+0x6f/0x100 mm/kasan/quarantine.c:179
Code: 49 8b 44 04 08 89 c2 83 e2 01 48 ff ca 48 09 c2 48 21 ca 0f b6 42 33 c1 e0 18 3d 00 00 00 f5 49 0f 45 d5 4c 8b 62 08 49 8b 2f <49> 63 84 24 b8 00 00 00 49 29 c7 4c 89 e7 4c 89 fe e8 4b e4 ff ff
RSP: 0018:ffffc90003e9f440 EFLAGS: 00000246
RAX: 00000000f5000000 RBX: ffffc90003e9f478 RCX: ffffea0005c84b40
RDX: ffffea0005c84b40 RSI: ffffea00044f5600 RDI: ffff88817212d150
RBP: ffff88817263e598 R08: 0000000000000000 R09: ffffffff82310b6e
R10: dffffc0000000000 R11: fffffbfff2061c3f R12: ffff888160417b40
R13: 0000000000000000 R14: 0000000000000000 R15: ffff88817212d150
 kasan_quarantine_reduce+0x148/0x160 mm/kasan/quarantine.c:286
 __kasan_slab_alloc+0x22/0x80 mm/kasan/common.c:350
 kasan_slab_alloc include/linux/kasan.h:253 [inline]
 slab_post_alloc_hook mm/slub.c:4570 [inline]
 slab_alloc_node mm/slub.c:4899 [inline]
 __do_kmalloc_node mm/slub.c:5295 [inline]
 __kmalloc_node_noprof+0x498/0x7c0 mm/slub.c:5302
 kmalloc_node_noprof include/linux/slab.h:1081 [inline]
 __vmalloc_area_node mm/vmalloc.c:3857 [inline]
 __vmalloc_node_range_noprof+0x5ef/0x1750 mm/vmalloc.c:4064
 __vmalloc_node_noprof mm/vmalloc.c:4124 [inline]
 vzalloc_noprof+0xb2/0xe0 mm/vmalloc.c:4202
 alloc_counters+0x64/0x5d0 net/ipv4/netfilter/ip_tables.c:799
 copy_entries_to_user net/ipv4/netfilter/ip_tables.c:821 [inline]
 get_entries net/ipv4/netfilter/ip_tables.c:1022 [inline]
 do_ipt_get_ctl+0xada/0x1240 net/ipv4/netfilter/ip_tables.c:1668
 nf_getsockopt+0x26e/0x290 net/netfilter/nf_sockopt.c:116
 ip_getsockopt+0x19e/0x230 net/ipv4/ip_sockglue.c:1777
 do_sock_getsockopt+0x51d/0x7e0 net/socket.c:2487
 __sys_getsockopt net/socket.c:2518 [inline]
 __do_sys_getsockopt net/socket.c:2525 [inline]
 __se_sys_getsockopt net/socket.c:2522 [inline]
 __x64_sys_getsockopt+0x1a4/0x240 net/socket.c:2522
 do_syscall_x64 arch/x86/entry/syscall_64.c:63 [inline]
 do_syscall_64+0x15f/0x560 arch/x86/entry/syscall_64.c:94
 entry_SYSCALL_64_after_hwframe+0x77/0x7f
RIP: 0033:0x7f326419e62a
Code: 48 83 ec 10 89 d2 48 63 ff 45 31 c9 6a 2a 45 31 c0 31 c9 e8 d8 99 fb ff 48 83 c4 18 c3 0f 1f 00 49 89 ca b8 37 00 00 00 0f 05 <48> 3d 00 f0 ff ff 77 06 c3 0f 1f 44 00 00 48 c7 c2 e8 ff ff ff f7
RSP: 002b:00007ffd38f686c8 EFLAGS: 00000216 ORIG_RAX: 0000000000000037
RAX: ffffffffffffffda RBX: 00007ffd38f68750 RCX: 00007f326419e62a
RDX: 0000000000000041 RSI: 0000000000000000 RDI: 0000000000000003
RBP: 0000000000000003 R08: 00007ffd38f686ec R09: ff78736871746264
R10: 00007ffd38f68750 R11: 0000000000000216 R12: 00007f32643ecac0
R13: 00007ffd38f686ec R14: 0000000000000000 R15: 00007f32643ed180
 </TASK>
BUG: sleeping function called from invalid context at kernel/locking/mutex.c:623
in_atomic(): 1, irqs_disabled(): 0, non_block: 0, pid: 23, name: ksoftirqd/1
preempt_count: 100, expected: 0
RCU nest depth: 0, expected: 0
INFO: lockdep is turned off.
Preemption disabled at:
[<ffffffff8187d090>] softirq_handle_begin kernel/softirq.c:463 [inline]
[<ffffffff8187d090>] handle_softirqs+0xb0/0x840 kernel/softirq.c:598
CPU: 1 UID: 0 PID: 23 Comm: ksoftirqd/1 Tainted: G        W           syzkaller #0 PREEMPT(full) 
Tainted: [W]=WARN
Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS 1.16.2-debian-1.16.2-1 04/01/2014
Call Trace:
 <TASK>
 dump_stack_lvl+0xe8/0x150 lib/dump_stack.c:120
 __might_resched+0x378/0x4d0 kernel/sched/core.c:9163
 __mutex_lock_common kernel/locking/mutex.c:623 [inline]
 __mutex_lock+0x11c/0x1550 kernel/locking/mutex.c:820
 __tcf_chain_put+0x60/0x820 net/sched/cls_api.c:694
 free_tcf net/sched/act_api.c:130 [inline]
 tcf_action_cleanup net/sched/act_api.c:370 [inline]
 tcf_action_rcu_free+0x39d/0x440 net/sched/act_api.c:378
 rcu_do_batch kernel/rcu/tree.c:2617 [inline]
 rcu_core+0x7cd/0x1070 kernel/rcu/tree.c:2869
 handle_softirqs+0x22a/0x840 kernel/softirq.c:622
 run_ksoftirqd+0x36/0x60 kernel/softirq.c:1076
 smpboot_thread_fn+0x541/0xa50 kernel/smpboot.c:160
 kthread+0x389/0x470 kernel/kthread.c:436
 ret_from_fork+0x514/0xb70 arch/x86/kernel/process.c:158
 ret_from_fork_asm+0x1a/0x30 arch/x86/entry/entry_64.S:245
 </TASK>
----------------
Code disassembly (best guess):
   0:	2b 7d 02             	sub    0x2(%rbp),%edi
   3:	c3                   	ret
   4:	cc                   	int3
   5:	cc                   	int3
   6:	cc                   	int3
   7:	cc                   	int3
   8:	cc                   	int3
   9:	cc                   	int3
   a:	cc                   	int3
   b:	90                   	nop
   c:	90                   	nop
   d:	90                   	nop
   e:	90                   	nop
   f:	90                   	nop
  10:	90                   	nop
  11:	90                   	nop
  12:	90                   	nop
  13:	90                   	nop
  14:	90                   	nop
  15:	90                   	nop
  16:	90                   	nop
  17:	90                   	nop
  18:	90                   	nop
  19:	90                   	nop
  1a:	90                   	nop
  1b:	f3 0f 1e fa          	endbr64
  1f:	eb 07                	jmp    0x28
  21:	0f 00 2d 03 c2 1f 00 	verw   0x1fc203(%rip)        # 0x1fc22b
  28:	fb                   	sti
  29:	f4                   	hlt
* 2a:	e9 7c f7 02 00       	jmp    0x2f7ab <-- trapping instruction
  2f:	cc                   	int3
  30:	cc                   	int3
  31:	cc                   	int3
  32:	cc                   	int3
  33:	cc                   	int3
  34:	cc                   	int3
  35:	cc                   	int3
  36:	cc                   	int3
  37:	cc                   	int3
  38:	cc                   	int3
  39:	cc                   	int3
  3a:	cc                   	int3
  3b:	90                   	nop
  3c:	90                   	nop
  3d:	90                   	nop
  3e:	90                   	nop
  3f:	90                   	nop


***

inconsistent lock state in tcf_mirred_release

tree:      net
URL:       https://kernel.googlesource.com/pub/scm/linux/kernel/git/netdev/net.git
base:      78ef59e7a6459b16f8102e0ee1c718443323d1af
arch:      amd64
compiler:  Debian clang version 21.1.8 (++20251221033036+2078da43e25a-1~exp1~20251221153213.50), Debian LLD 21.1.8
config:    https://ci.syzbot.org/builds/46884a04-6831-455e-8868-d463d6e018db/config
syz repro: https://ci.syzbot.org/findings/339567f1-aefa-440b-b74d-8584664a549d/syz_repro

================================
WARNING: inconsistent lock state
syzkaller #0 Not tainted
--------------------------------
inconsistent {SOFTIRQ-ON-W} -> {IN-SOFTIRQ-W} usage.
ksoftirqd/1/23 [HC0[0]:SC1[1]:HE1:SE0] takes:
ffffffff8fe24698 (mirred_list_lock){+.?.}-{3:3}, at: spin_lock include/linux/spinlock.h:342 [inline]
ffffffff8fe24698 (mirred_list_lock){+.?.}-{3:3}, at: tcf_mirred_release+0x2c/0x1c0 net/sched/act_mirred.c:78
{SOFTIRQ-ON-W} state was registered at:
  lock_acquire+0x106/0x350 kernel/locking/lockdep.c:5868
  __raw_spin_lock include/linux/spinlock_api_smp.h:158 [inline]
  _raw_spin_lock+0x2e/0x40 kernel/locking/spinlock.c:158
  spin_lock include/linux/spinlock.h:342 [inline]
  mirred_device_event+0x80/0x2c0 net/sched/act_mirred.c:561
  notifier_call_chain+0x1ad/0x3d0 kernel/notifier.c:85
  call_netdevice_notifiers_extack net/core/dev.c:2287 [inline]
  call_netdevice_notifiers net/core/dev.c:2301 [inline]
  unregister_netdevice_many_notify+0x17a5/0x22c0 net/core/dev.c:12421
  ops_exit_rtnl_list net/core/net_namespace.c:187 [inline]
  ops_undo_list+0x3d3/0x940 net/core/net_namespace.c:248
  cleanup_net+0x56b/0x800 net/core/net_namespace.c:702
  process_one_work kernel/workqueue.c:3314 [inline]
  process_scheduled_works+0xb5d/0x1860 kernel/workqueue.c:3397
  worker_thread+0xa53/0xfc0 kernel/workqueue.c:3478
  kthread+0x389/0x470 kernel/kthread.c:436
  ret_from_fork+0x514/0xb70 arch/x86/kernel/process.c:158
  ret_from_fork_asm+0x1a/0x30 arch/x86/entry/entry_64.S:245
irq event stamp: 953728
hardirqs last  enabled at (953728): [<ffffffff8bac5040>] __raw_spin_unlock_irqrestore include/linux/spinlock_api_smp.h:178 [inline]
hardirqs last  enabled at (953728): [<ffffffff8bac5040>] _raw_spin_unlock_irqrestore+0x30/0x80 kernel/locking/spinlock.c:198
hardirqs last disabled at (953727): [<ffffffff8bac4e9a>] __raw_spin_lock_irqsave include/linux/spinlock_api_smp.h:130 [inline]
hardirqs last disabled at (953727): [<ffffffff8bac4e9a>] _raw_spin_lock_irqsave+0x1a/0x60 kernel/locking/spinlock.c:166
softirqs last  enabled at (953336): [<ffffffff8187fb46>] run_ksoftirqd+0x36/0x60 kernel/softirq.c:1076
softirqs last disabled at (953341): [<ffffffff8187fb46>] run_ksoftirqd+0x36/0x60 kernel/softirq.c:1076

other info that might help us debug this:
 Possible unsafe locking scenario:

       CPU0
       ----
  lock(mirred_list_lock);
  <Interrupt>
    lock(mirred_list_lock);

 *** DEADLOCK ***

1 lock held by ksoftirqd/1/23:
 #0: ffffffff8e95ce00 (rcu_callback){....}-{0:0}, at: rcu_lock_acquire include/linux/rcupdate.h:300 [inline]
 #0: ffffffff8e95ce00 (rcu_callback){....}-{0:0}, at: rcu_do_batch kernel/rcu/tree.c:2611 [inline]
 #0: ffffffff8e95ce00 (rcu_callback){....}-{0:0}, at: rcu_core+0x751/0x1070 kernel/rcu/tree.c:2869

stack backtrace:
CPU: 1 UID: 0 PID: 23 Comm: ksoftirqd/1 Not tainted syzkaller #0 PREEMPT(full) 
Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS 1.16.2-debian-1.16.2-1 04/01/2014
Call Trace:
 <TASK>
 dump_stack_lvl+0xe8/0x150 lib/dump_stack.c:120
 print_usage_bug+0x28b/0x2e0 kernel/locking/lockdep.c:4042
 valid_state kernel/locking/lockdep.c:4056 [inline]
 mark_lock_irq+0x410/0x420 kernel/locking/lockdep.c:-1
 mark_lock+0x115/0x190 kernel/locking/lockdep.c:4753
 mark_usage kernel/locking/lockdep.c:-1 [inline]
 __lock_acquire+0x689/0x2cf0 kernel/locking/lockdep.c:5191
 lock_acquire+0x106/0x350 kernel/locking/lockdep.c:5868
 __raw_spin_lock include/linux/spinlock_api_smp.h:158 [inline]
 _raw_spin_lock+0x2e/0x40 kernel/locking/spinlock.c:158
 spin_lock include/linux/spinlock.h:342 [inline]
 tcf_mirred_release+0x2c/0x1c0 net/sched/act_mirred.c:78
 tcf_action_cleanup net/sched/act_api.c:367 [inline]
 tcf_action_rcu_free+0x2bd/0x440 net/sched/act_api.c:378
 rcu_do_batch kernel/rcu/tree.c:2617 [inline]
 rcu_core+0x7cd/0x1070 kernel/rcu/tree.c:2869
 handle_softirqs+0x22a/0x840 kernel/softirq.c:622
 run_ksoftirqd+0x36/0x60 kernel/softirq.c:1076
 smpboot_thread_fn+0x541/0xa50 kernel/smpboot.c:160
 kthread+0x389/0x470 kernel/kthread.c:436
 ret_from_fork+0x514/0xb70 arch/x86/kernel/process.c:158
 ret_from_fork_asm+0x1a/0x30 arch/x86/entry/entry_64.S:245
 </TASK>


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

The email will later be sent to:
[davem@davemloft.net edumazet@google.com horms@kernel.org jhs@mojatatu.com jiri@resnulli.us kuba@kernel.org kylebot@openai.com linux-kernel@vger.kernel.org netdev@vger.kernel.org pabeni@redhat.com security@kernel.org victor@mojatatu.com vladbu@nvidia.com]

If the report looks fine to you, reply with:
#syz upstream

If the report is a false positive, reply with
#syz invalid

