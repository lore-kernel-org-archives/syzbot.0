Received: from mail-oo1-f69.google.com (mail-oo1-f69.google.com [209.85.161.69])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E9A9C3126CD
	for <syzbot@lists.linux.dev>; Thu, 26 Feb 2026 09:31:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.161.69
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772098316; cv=none; b=IhlHs5DmTeCvsbaWxLtgjoOUGd0lOLvoAOdxGYECCF6EvL3agcWVSAbnijPSoo6Ic33QlnapGnT28ZAYsuyz8axKjIzHm8PZ/md5gBQtTxTgbw6R2d9ADx20SrwQkY92QJ1WBxXD//JMCT2QNcxer25CwzM8rQJf8qrqF3tOys8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772098316; c=relaxed/simple;
	bh=LWwGOkUvPIVQ3+1oaUt/kkoJNlvXF8UpyEu9qb8fYgg=;
	h=MIME-Version:Date:In-Reply-To:Message-ID:Subject:From:To:Cc:
	 Content-Type; b=gqnGEMQy8HuOVdtSPqLyTZWEzQoSzMOCMSoqZ51XzHh07xMw0FvhTZ2yyx/LHzOm8atcYVRWzDtEBAly/IrjHOACGM8Y7wKWu7ISfRyCkq9DfNGR+jsR7Rsi8+oMBClT4KbgSM9xPdoiHFi71axet/Sgc+XnA+Q/ACV18aN5FnE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com; arc=none smtp.client-ip=209.85.161.69
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com
Received: by mail-oo1-f69.google.com with SMTP id 006d021491bc7-679c5ed0942so10937818eaf.1
        for <syzbot@lists.linux.dev>; Thu, 26 Feb 2026 01:31:53 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1772098313; x=1772703113;
        h=cc:to:from:subject:message-id:in-reply-to:date:mime-version
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=ryb83rdKR7cP09Vv+tw2tMg5DgRRAMoUCWddc3/c9WU=;
        b=SfXoMQ3GtFjZORA9LHcai64dAg3bLMG+BNkaaamhnVtdJZ6f05JNMIHouq5WkXY6PC
         qhD2xUWtC/BCL3yBHNs8X0Fy88/8YSgTP2d8YxR7T3+R/x+h6fzZFkz5vOo1SIN3I3oB
         3OlTzzi9xUlcFOd7z2MgBA7NTbPo/GHux2EofFNSTscgDI/7zgNliQdOh5wzm3Ok84aT
         UDtTOCTRGhGqRxGKp2f8nr8mjpxYqauhEOBVa2fxLKQYYhqi7xOIc6sYEZouMfcrmtiB
         On+/qUlzL7M5RmzM6K7TOWeXz5wBXcJUm7s0cJ1nuXH7x4K+DWIlR/VMs4QI+c+N4KW6
         lLHA==
X-Gm-Message-State: AOJu0YyCa/xx5y37RrkAX0LaFu4v3moxVMETNncSm9H3Y5b+fPuWNljM
	81DYPmwZ/8g/iOSBmLKnYptBwBhWKNo0ODESazgOfIWX5WKaRY4CkGCqfZtB/n3r75MWpVgjlbf
	rmam9w/EztajRAuk5l3UMYkQlNVUz6KvxNggJHhqmUfNuTZrM4P1AlC0IWGU=
Precedence: bulk
X-Mailing-List: syzbot@lists.linux.dev
List-Id: <syzbot.lists.linux.dev>
List-Subscribe: <mailto:syzbot+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:syzbot+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Received: by 2002:a4a:e84a:0:b0:679:92c7:2c11 with SMTP id
 006d021491bc7-679f3ce0562mr730648eaf.10.1772098313046; Thu, 26 Feb 2026
 01:31:53 -0800 (PST)
Date: Thu, 26 Feb 2026 01:31:53 -0800
In-Reply-To: <20260225185121.2057388-1-memxor@gmail.com>
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <69a01309.050a0220.2fcbed.0007.GAE@google.com>
Subject: [syzbot ci] Re: Close race in freeing special fields and map value
From: syzbot ci <syzbot+ci3826af8b4f91bf97@syzkaller.appspotmail.com>
To: andrii@kernel.org, ast@kernel.org, bpf@vger.kernel.org, 
	daniel@iogearbox.net, eddyz87@gmail.com, kernel-team@meta.com, kkd@meta.com, 
	martin.lau@kernel.org, memxor@gmail.com, paulmck@kernel.org, 
	yatsenko@meta.com
Cc: syzbot@lists.linux.dev, syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"

syzbot ci has tested the following series

[v1] Close race in freeing special fields and map value
https://lore.kernel.org/all/20260225185121.2057388-1-memxor@gmail.com
* [PATCH bpf-next v1 1/4] bpf: Register dtor for freeing special fields
* [PATCH bpf-next v1 2/4] bpf: Delay freeing fields in local storage
* [PATCH bpf-next v1 3/4] bpf: Retire rcu_trace_implies_rcu_gp() from local storage
* [PATCH bpf-next v1 4/4] selftests/bpf: Add tests for special fields races

and found the following issue:
KASAN: slab-use-after-free Read in free_all

Full report is available here:
https://ci.syzbot.org/series/ad9c7ce6-d861-4afe-821a-e8fae6120b12

***

KASAN: slab-use-after-free Read in free_all

tree:      bpf-next
URL:       https://kernel.googlesource.com/pub/scm/linux/kernel/git/bpf/bpf-next.git
base:      f620af11c27b8ec9994a39fe968aa778112d1566
arch:      amd64
compiler:  Debian clang version 21.1.8 (++20251221033036+2078da43e25a-1~exp1~20251221153213.50), Debian LLD 21.1.8
config:    https://ci.syzbot.org/builds/b2735b0b-963d-41a7-bb33-db10494a24e1/config
syz repro: https://ci.syzbot.org/findings/3ee61f99-7d80-4986-a0b1-492ffb6b1c46/syz_repro

==================================================================
BUG: KASAN: slab-use-after-free in free_all+0x84/0x140 kernel/bpf/memalloc.c:271
Read of size 8 at addr ffff888112ee9260 by task swapper/0/0

CPU: 0 UID: 0 PID: 0 Comm: swapper/0 Not tainted syzkaller #0 PREEMPT(full) 
Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS 1.16.2-debian-1.16.2-1 04/01/2014
Call Trace:
 <IRQ>
 dump_stack_lvl+0xe8/0x150 lib/dump_stack.c:120
 print_address_description mm/kasan/report.c:378 [inline]
 print_report+0xba/0x230 mm/kasan/report.c:482
 kasan_report+0x117/0x150 mm/kasan/report.c:595
 free_all+0x84/0x140 kernel/bpf/memalloc.c:271
 do_call_rcu_ttrace+0x385/0x400 kernel/bpf/memalloc.c:315
 __free_by_rcu+0x23b/0x3f0 kernel/bpf/memalloc.c:381
 rcu_do_batch kernel/rcu/tree.c:2617 [inline]
 rcu_core+0x7cd/0x1070 kernel/rcu/tree.c:2869
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
RIP: 0010:pv_native_safe_halt+0xf/0x20 arch/x86/kernel/paravirt.c:63
Code: 8e 6d 02 c3 cc cc cc cc cc cc cc 90 90 90 90 90 90 90 90 90 90 90 90 90 90 90 90 f3 0f 1e fa eb 07 0f 00 2d 43 3d 1c 00 fb f4 <e9> 7c ea 02 00 cc cc cc cc cc cc cc cc cc cc cc cc 90 90 90 90 90
RSP: 0018:ffffffff8e407dc0 EFLAGS: 00000202
RAX: 00000000000d2297 RBX: ffffffff819a80ad RCX: 0000000080000001
RDX: 0000000000000001 RSI: ffffffff8def22fa RDI: ffffffff8c27a800
RBP: ffffffff8e407eb0 R08: ffff88812103395b R09: 1ffff1102420672b
R10: dffffc0000000000 R11: ffffed102420672c R12: ffffffff90117db0
R13: 1ffffffff1c929d8 R14: 0000000000000000 R15: 0000000000000000
 arch_safe_halt arch/x86/kernel/process.c:766 [inline]
 default_idle+0x9/0x20 arch/x86/kernel/process.c:767
 default_idle_call+0x72/0xb0 kernel/sched/idle.c:122
 cpuidle_idle_call kernel/sched/idle.c:191 [inline]
 do_idle+0x1bd/0x500 kernel/sched/idle.c:332
 cpu_startup_entry+0x43/0x60 kernel/sched/idle.c:430
 rest_init+0x2de/0x300 init/main.c:760
 start_kernel+0x385/0x3d0 init/main.c:1210
 x86_64_start_reservations+0x24/0x30 arch/x86/kernel/head64.c:310
 x86_64_start_kernel+0x143/0x1c0 arch/x86/kernel/head64.c:291
 common_startup_64+0x13e/0x147
 </TASK>

Allocated by task 5961:
 kasan_save_stack mm/kasan/common.c:57 [inline]
 kasan_save_track+0x3e/0x80 mm/kasan/common.c:78
 poison_kmalloc_redzone mm/kasan/common.c:398 [inline]
 __kasan_kmalloc+0x93/0xb0 mm/kasan/common.c:415
 kasan_kmalloc include/linux/kasan.h:263 [inline]
 __do_kmalloc_node mm/slub.c:5219 [inline]
 __kmalloc_node_noprof+0x4e0/0x7c0 mm/slub.c:5225
 kmalloc_node_noprof include/linux/slab.h:1093 [inline]
 __bpf_map_area_alloc kernel/bpf/syscall.c:398 [inline]
 bpf_map_area_alloc+0x64/0x170 kernel/bpf/syscall.c:411
 trie_alloc+0x14f/0x340 kernel/bpf/lpm_trie.c:588
 map_create+0xafd/0x16a0 kernel/bpf/syscall.c:1507
 __sys_bpf+0x6e1/0x950 kernel/bpf/syscall.c:6210
 __do_sys_bpf kernel/bpf/syscall.c:6341 [inline]
 __se_sys_bpf kernel/bpf/syscall.c:6339 [inline]
 __x64_sys_bpf+0x7c/0x90 kernel/bpf/syscall.c:6339
 do_syscall_x64 arch/x86/entry/syscall_64.c:63 [inline]
 do_syscall_64+0x14d/0xf80 arch/x86/entry/syscall_64.c:94
 entry_SYSCALL_64_after_hwframe+0x77/0x7f

Freed by task 83:
 kasan_save_stack mm/kasan/common.c:57 [inline]
 kasan_save_track+0x3e/0x80 mm/kasan/common.c:78
 kasan_save_free_info+0x46/0x50 mm/kasan/generic.c:584
 poison_slab_object mm/kasan/common.c:253 [inline]
 __kasan_slab_free+0x5c/0x80 mm/kasan/common.c:285
 kasan_slab_free include/linux/kasan.h:235 [inline]
 slab_free_hook mm/slub.c:2687 [inline]
 slab_free mm/slub.c:6124 [inline]
 kfree+0x1c1/0x630 mm/slub.c:6442
 bpf_map_free kernel/bpf/syscall.c:892 [inline]
 bpf_map_free_deferred+0x217/0x460 kernel/bpf/syscall.c:919
 process_one_work kernel/workqueue.c:3275 [inline]
 process_scheduled_works+0xb02/0x1830 kernel/workqueue.c:3358
 worker_thread+0xa50/0xfc0 kernel/workqueue.c:3439
 kthread+0x388/0x470 kernel/kthread.c:467
 ret_from_fork+0x51e/0xb90 arch/x86/kernel/process.c:158
 ret_from_fork_asm+0x1a/0x30 arch/x86/entry/entry_64.S:245

Last potentially related work creation:
 kasan_save_stack+0x3e/0x60 mm/kasan/common.c:57
 kasan_record_aux_stack+0xbd/0xd0 mm/kasan/generic.c:556
 insert_work+0x3d/0x330 kernel/workqueue.c:2199
 __queue_work+0xd03/0x1020 kernel/workqueue.c:2354
 queue_work_on+0x106/0x1d0 kernel/workqueue.c:2405
 bpf_map_put_with_uref kernel/bpf/syscall.c:975 [inline]
 bpf_map_release+0x127/0x140 kernel/bpf/syscall.c:985
 __fput+0x44f/0xa70 fs/file_table.c:469
 task_work_run+0x1d9/0x270 kernel/task_work.c:233
 resume_user_mode_work include/linux/resume_user_mode.h:50 [inline]
 __exit_to_user_mode_loop kernel/entry/common.c:67 [inline]
 exit_to_user_mode_loop+0xed/0x480 kernel/entry/common.c:98
 __exit_to_user_mode_prepare include/linux/irq-entry-common.h:226 [inline]
 syscall_exit_to_user_mode_prepare include/linux/irq-entry-common.h:256 [inline]
 syscall_exit_to_user_mode include/linux/entry-common.h:325 [inline]
 do_syscall_64+0x32d/0xf80 arch/x86/entry/syscall_64.c:100
 entry_SYSCALL_64_after_hwframe+0x77/0x7f

The buggy address belongs to the object at ffff888112ee9000
 which belongs to the cache kmalloc-cg-1k of size 1024
The buggy address is located 608 bytes inside of
 freed 1024-byte region [ffff888112ee9000, ffff888112ee9400)

The buggy address belongs to the physical page:
page: refcount:0 mapcount:0 mapping:0000000000000000 index:0x0 pfn:0x112ee8
head: order:3 mapcount:0 entire_mapcount:0 nr_pages_mapped:0 pincount:0
memcg:ffff888106b17c01
flags: 0x17ff00000000040(head|node=0|zone=2|lastcpupid=0x7ff)
page_type: f5(slab)
raw: 017ff00000000040 ffff88810005d280 dead000000000100 dead000000000122
raw: 0000000000000000 0000000800100010 00000000f5000000 ffff888106b17c01
head: 017ff00000000040 ffff88810005d280 dead000000000100 dead000000000122
head: 0000000000000000 0000000800100010 00000000f5000000 ffff888106b17c01
head: 017ff00000000003 ffffea00044bba01 00000000ffffffff 00000000ffffffff
head: ffffffffffffffff 0000000000000000 00000000ffffffff 0000000000000008
page dumped because: kasan: bad access detected
page_owner tracks the page as allocated
page last allocated via order 3, migratetype Unmovable, gfp_mask 0xd20c0(__GFP_IO|__GFP_FS|__GFP_NOWARN|__GFP_NORETRY|__GFP_COMP|__GFP_NOMEMALLOC), pid 5550, tgid 5550 (dhcpcd), ts 37867090520, free_ts 37834172120
 set_page_owner include/linux/page_owner.h:32 [inline]
 post_alloc_hook+0x231/0x280 mm/page_alloc.c:1889
 prep_new_page mm/page_alloc.c:1897 [inline]
 get_page_from_freelist+0x24dc/0x2580 mm/page_alloc.c:3962
 __alloc_frozen_pages_noprof+0x18d/0x380 mm/page_alloc.c:5250
 alloc_slab_page mm/slub.c:3255 [inline]
 allocate_slab+0x77/0x660 mm/slub.c:3444
 new_slab mm/slub.c:3502 [inline]
 refill_objects+0x331/0x3c0 mm/slub.c:7134
 refill_sheaf mm/slub.c:2804 [inline]
 __pcs_replace_empty_main+0x2b9/0x620 mm/slub.c:4578
 alloc_from_pcs mm/slub.c:4681 [inline]
 slab_alloc_node mm/slub.c:4815 [inline]
 __do_kmalloc_node mm/slub.c:5218 [inline]
 __kmalloc_node_track_caller_noprof+0x572/0x7b0 mm/slub.c:5327
 kmalloc_reserve net/core/skbuff.c:635 [inline]
 __alloc_skb+0x2c1/0x7d0 net/core/skbuff.c:713
 alloc_skb include/linux/skbuff.h:1383 [inline]
 alloc_skb_with_frags+0xca/0x890 net/core/skbuff.c:6750
 sock_alloc_send_pskb+0x878/0x990 net/core/sock.c:2995
 unix_dgram_sendmsg+0x460/0x18e0 net/unix/af_unix.c:2125
 sock_sendmsg_nosec net/socket.c:727 [inline]
 __sock_sendmsg net/socket.c:742 [inline]
 sock_write_iter+0x503/0x550 net/socket.c:1195
 do_iter_readv_writev+0x619/0x8c0 fs/read_write.c:-1
 vfs_writev+0x33c/0x990 fs/read_write.c:1059
 do_writev+0x154/0x2e0 fs/read_write.c:1105
 do_syscall_x64 arch/x86/entry/syscall_64.c:63 [inline]
 do_syscall_64+0x14d/0xf80 arch/x86/entry/syscall_64.c:94
page last free pid 5678 tgid 5678 stack trace:
 reset_page_owner include/linux/page_owner.h:25 [inline]
 __free_pages_prepare mm/page_alloc.c:1433 [inline]
 __free_frozen_pages+0xc2b/0xdb0 mm/page_alloc.c:2978
 __slab_free+0x263/0x2b0 mm/slub.c:5532
 qlink_free mm/kasan/quarantine.c:163 [inline]
 qlist_free_all+0x97/0x100 mm/kasan/quarantine.c:179
 kasan_quarantine_reduce+0x148/0x160 mm/kasan/quarantine.c:286
 __kasan_slab_alloc+0x22/0x80 mm/kasan/common.c:350
 kasan_slab_alloc include/linux/kasan.h:253 [inline]
 slab_post_alloc_hook mm/slub.c:4501 [inline]
 slab_alloc_node mm/slub.c:4830 [inline]
 __do_kmalloc_node mm/slub.c:5218 [inline]
 __kmalloc_noprof+0x316/0x760 mm/slub.c:5231
 kmalloc_noprof include/linux/slab.h:966 [inline]
 tomoyo_realpath_from_path+0xe3/0x5d0 security/tomoyo/realpath.c:251
 tomoyo_realpath_nofollow+0xc3/0x110 security/tomoyo/realpath.c:304
 tomoyo_find_next_domain+0x259/0x1aa0 security/tomoyo/domain.c:731
 tomoyo_bprm_check_security+0x11b/0x180 security/tomoyo/tomoyo.c:102
 security_bprm_check+0x85/0x240 security/security.c:794
 search_binary_handler fs/exec.c:1654 [inline]
 exec_binprm fs/exec.c:1696 [inline]
 bprm_execve+0x896/0x1460 fs/exec.c:1748
 do_execveat_common+0x50d/0x690 fs/exec.c:1846
 __do_sys_execve fs/exec.c:1930 [inline]
 __se_sys_execve fs/exec.c:1924 [inline]
 __x64_sys_execve+0x97/0xc0 fs/exec.c:1924
 do_syscall_x64 arch/x86/entry/syscall_64.c:63 [inline]
 do_syscall_64+0x14d/0xf80 arch/x86/entry/syscall_64.c:94
 entry_SYSCALL_64_after_hwframe+0x77/0x7f

Memory state around the buggy address:
 ffff888112ee9100: fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb
 ffff888112ee9180: fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb
>ffff888112ee9200: fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb
                                                       ^
 ffff888112ee9280: fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb
 ffff888112ee9300: fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb
==================================================================
----------------
Code disassembly (best guess):
   0:	8e 6d 02             	mov    0x2(%rbp),%gs
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
  21:	0f 00 2d 43 3d 1c 00 	verw   0x1c3d43(%rip)        # 0x1c3d6b
  28:	fb                   	sti
  29:	f4                   	hlt
* 2a:	e9 7c ea 02 00       	jmp    0x2eaab <-- trapping instruction
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

If these findings have caused you to resend the series or submit a
separate fix, please add the following tag to your commit message:
  Tested-by: syzbot@syzkaller.appspotmail.com

---
This report is generated by a bot. It may contain errors.
syzbot ci engineers can be reached at syzkaller@googlegroups.com.
