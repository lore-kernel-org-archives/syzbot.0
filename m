Received: from mail-il1-f197.google.com (mail-il1-f197.google.com [209.85.166.197])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9113C30AAC9
	for <syzbot@lists.linux.dev>; Sat, 20 Sep 2025 18:33:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.197
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758393231; cv=none; b=hFqwKyfdcAnLSaZWmu18ocQU85SPYA5nE2b8JgHhGPWJGlH5wd6BKJz3ZyJXlSTPjOPmIQKSqkN0MBqAvzmyXaSWU3a4Pnscx82rypDzRBuI355hW9MtU50KXoZ3O3h0AFRxjNAy8dRB5J0snZh2vmx0dmXe/YeDfYCDymlslhc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758393231; c=relaxed/simple;
	bh=fRqo0Ad97biwsVOt3L34I3sIHUirLgURRLf78YbAQyo=;
	h=MIME-Version:Date:In-Reply-To:Message-ID:Subject:From:To:Cc:
	 Content-Type; b=GMSiuS+LiizB+q8IslMuVApVwLNoUa7PPQ3CTTbI1GlTANZhTf1t/Cxy8baIp/KQANPhrecLuDX/gZzhgd6hm1OBvrdxyO8OXNEqsF9EGUolHvb4kgcltn3t2g4DKDKa2pNJoTfkxkEpv9foQpVN6FnJspAxhN5kR6Fg5d+uEYY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com; arc=none smtp.client-ip=209.85.166.197
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com
Received: by mail-il1-f197.google.com with SMTP id e9e14a558f8ab-42571449766so2915325ab.2
        for <syzbot@lists.linux.dev>; Sat, 20 Sep 2025 11:33:49 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1758393229; x=1758998029;
        h=cc:to:from:subject:message-id:in-reply-to:date:mime-version
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=jeK6KUfhr9ku65Anq01eTgQhq/gY/dgWuho/Gm0Ys1M=;
        b=OZwPuQRW+MOrFYPNzXoYg44JdMYGKXhTAK31cyCRY99uz+iKMq3daNxPYkIibMgAYb
         EYySdupg2EBAmGnyznML1dhKgph+essCQCoCMoeulQfi/EsGcSkUCFAOb77dvInjFOQ0
         7HxcDb85JK5OBq3BhUjkwdmRtDJDQsAyOaT/aId8pKe/7ZB3O5dnd5r261wR/fmydgS8
         bxXZIenFowWuLQYFdqGVOIsqYKMG6tIQtAwRS3N3p2jznmzMZN8n0JRNVjW3fsuZHClg
         Mjx6ncxxAZfiu4YjN8AvYSykDDZv7P0L+6qZQdDcHvjQ5vYzLor657OWhwPHe6ad2jeg
         o7gw==
X-Gm-Message-State: AOJu0YzKmOzH3GGo0Ja6DRoVfRJsoHXu8CDtXxgNlTq+Fu8BdDSfxpxH
	Nx4F3gIPzBY8rr9fecbQmoDScNPCkLylvvVN6UYk0JWcVdrNU/LCcsv9UedYJtx8lz8QIat+FzG
	4OgWCPmkispLO+/r8RC174i1AV8PTZ8PD0YWRXDk8xjuc/epp32aIe9mCPGE=
X-Google-Smtp-Source: AGHT+IHhiRdefNwdCFwbXVvknNPHD73QNRaAAaPA5TQUazL9bhLyDu6R2lQK9bMPUvlVJMkbd0w1xTPmTaIP7GAQOJ9WQH4GSXyM
Precedence: bulk
X-Mailing-List: syzbot@lists.linux.dev
List-Id: <syzbot.lists.linux.dev>
List-Subscribe: <mailto:syzbot+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:syzbot+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Received: by 2002:a05:6e02:2509:b0:410:f09a:28a6 with SMTP id
 e9e14a558f8ab-42481925dd8mr135346165ab.13.1758393228806; Sat, 20 Sep 2025
 11:33:48 -0700 (PDT)
Date: Sat, 20 Sep 2025 11:33:48 -0700
In-Reply-To: <20250920080227.3674860-1-edumazet@google.com>
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <68cef38c.a00a0220.37dadf.0031.GAE@google.com>
Subject: [syzbot ci] Re: udp: remove busylock and add per NUMA queues
From: syzbot ci <syzbot+ci5837ea0bfa8e361b@syzkaller.appspotmail.com>
To: davem@davemloft.net, edumazet@google.com, eric.dumazet@gmail.com, 
	horms@kernel.org, kuba@kernel.org, kuniyu@google.com, netdev@vger.kernel.org, 
	pabeni@redhat.com, willemb@google.com
Cc: syzbot@lists.linux.dev, syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"

syzbot ci has tested the following series

[v2] udp: remove busylock and add per NUMA queues
https://lore.kernel.org/all/20250920080227.3674860-1-edumazet@google.com
* [PATCH v2 net-next] udp: remove busylock and add per NUMA queues

and found the following issue:
KASAN: slab-use-after-free Read in __udp_enqueue_schedule_skb

Full report is available here:
https://ci.syzbot.org/series/9921e6c6-67ac-435d-a76a-a9cfb67b2f12

***

KASAN: slab-use-after-free Read in __udp_enqueue_schedule_skb

tree:      net-next
URL:       https://kernel.googlesource.com/pub/scm/linux/kernel/git/netdev/net-next.git
base:      315f423be0d1ebe720d8fd4fa6bed68586b13d34
arch:      amd64
compiler:  Debian clang version 20.1.8 (++20250708063551+0c9f909b7976-1~exp1~20250708183702.136), Debian LLD 20.1.8
config:    https://ci.syzbot.org/builds/987bf81f-fa72-4f8b-a27a-db2b99aed02b/config
syz repro: https://ci.syzbot.org/findings/d36fc1b8-fea8-4e40-af0d-515be973a67a/syz_repro

==================================================================
BUG: KASAN: slab-use-after-free in instrument_atomic_read include/linux/instrumented.h:68 [inline]
BUG: KASAN: slab-use-after-free in atomic_read include/linux/atomic/atomic-instrumented.h:32 [inline]
BUG: KASAN: slab-use-after-free in __udp_enqueue_schedule_skb+0x15c/0xfe0 net/ipv4/udp.c:1717
Read of size 4 at addr ffff88810d802d08 by task syz.0.120/6361

CPU: 0 UID: 0 PID: 6361 Comm: syz.0.120 Not tainted syzkaller #0 PREEMPT(full) 
Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS 1.16.2-debian-1.16.2-1 04/01/2014
Call Trace:
 <TASK>
 dump_stack_lvl+0x189/0x250 lib/dump_stack.c:120
 print_address_description mm/kasan/report.c:378 [inline]
 print_report+0xca/0x240 mm/kasan/report.c:482
 kasan_report+0x118/0x150 mm/kasan/report.c:595
 check_region_inline mm/kasan/generic.c:-1 [inline]
 kasan_check_range+0x2b0/0x2c0 mm/kasan/generic.c:189
 instrument_atomic_read include/linux/instrumented.h:68 [inline]
 atomic_read include/linux/atomic/atomic-instrumented.h:32 [inline]
 __udp_enqueue_schedule_skb+0x15c/0xfe0 net/ipv4/udp.c:1717
 __udp_queue_rcv_skb net/ipv4/udp.c:2326 [inline]
 udp_queue_rcv_one_skb+0xab9/0x19e0 net/ipv4/udp.c:2455
 __udp4_lib_mcast_deliver+0xc06/0xcf0 net/ipv4/udp.c:2565
 __udp4_lib_rcv+0x10e2/0x2600 net/ipv4/udp.c:2704
 ip_protocol_deliver_rcu+0x282/0x440 net/ipv4/ip_input.c:205
 ip_local_deliver_finish+0x3bb/0x6f0 net/ipv4/ip_input.c:239
 NF_HOOK+0x30c/0x3a0 include/linux/netfilter.h:318
 dst_input include/net/dst.h:474 [inline]
 ip_sublist_rcv_finish+0x221/0x2a0 net/ipv4/ip_input.c:585
 ip_list_rcv_finish net/ipv4/ip_input.c:629 [inline]
 ip_sublist_rcv+0x5b1/0xa10 net/ipv4/ip_input.c:645
 ip_list_rcv+0x3e2/0x430 net/ipv4/ip_input.c:679
 __netif_receive_skb_list_ptype net/core/dev.c:6115 [inline]
 __netif_receive_skb_list_core+0x7d2/0x800 net/core/dev.c:6162
 __netif_receive_skb_list net/core/dev.c:6214 [inline]
 netif_receive_skb_list_internal+0x96f/0xcb0 net/core/dev.c:6305
 netif_receive_skb_list+0x54/0x450 net/core/dev.c:6357
 xdp_recv_frames net/bpf/test_run.c:280 [inline]
 xdp_test_run_batch net/bpf/test_run.c:361 [inline]
 bpf_test_run_xdp_live+0x1786/0x1b10 net/bpf/test_run.c:390
 bpf_prog_test_run_xdp+0x713/0x1000 net/bpf/test_run.c:1322
 bpf_prog_test_run+0x2c7/0x340 kernel/bpf/syscall.c:4590
 __sys_bpf+0x581/0x870 kernel/bpf/syscall.c:6047
 __do_sys_bpf kernel/bpf/syscall.c:6139 [inline]
 __se_sys_bpf kernel/bpf/syscall.c:6137 [inline]
 __x64_sys_bpf+0x7c/0x90 kernel/bpf/syscall.c:6137
 do_syscall_x64 arch/x86/entry/syscall_64.c:63 [inline]
 do_syscall_64+0xfa/0x3b0 arch/x86/entry/syscall_64.c:94
 entry_SYSCALL_64_after_hwframe+0x77/0x7f
RIP: 0033:0x7f10d458eba9
Code: ff ff c3 66 2e 0f 1f 84 00 00 00 00 00 0f 1f 40 00 48 89 f8 48 89 f7 48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 ff ff 73 01 c3 48 c7 c1 a8 ff ff ff f7 d8 64 89 01 48
RSP: 002b:00007f10d54e4038 EFLAGS: 00000246 ORIG_RAX: 0000000000000141
RAX: ffffffffffffffda RBX: 00007f10d47d5fa0 RCX: 00007f10d458eba9
RDX: 0000000000000048 RSI: 0000200000000600 RDI: 000000000000000a
RBP: 00007f10d4611e19 R08: 0000000000000000 R09: 0000000000000000
R10: 0000000000000000 R11: 0000000000000246 R12: 0000000000000000
R13: 00007f10d47d6038 R14: 00007f10d47d5fa0 R15: 00007ffd5c7da268
 </TASK>

Allocated by task 6361:
 kasan_save_stack mm/kasan/common.c:47 [inline]
 kasan_save_track+0x3e/0x80 mm/kasan/common.c:68
 poison_kmalloc_redzone mm/kasan/common.c:388 [inline]
 __kasan_kmalloc+0x93/0xb0 mm/kasan/common.c:405
 kasan_kmalloc include/linux/kasan.h:260 [inline]
 __do_kmalloc_node mm/slub.c:4376 [inline]
 __kmalloc_noprof+0x27a/0x4f0 mm/slub.c:4388
 kmalloc_noprof include/linux/slab.h:909 [inline]
 kmalloc_array_noprof include/linux/slab.h:948 [inline]
 udp_lib_init_sock include/net/udp.h:297 [inline]
 udpv6_init_sock+0x198/0x3b0 net/ipv6/udp.c:70
 inet6_create+0xef4/0x1260 net/ipv6/af_inet6.c:259
 __sock_create+0x4b3/0x9f0 net/socket.c:1589
 sock_create net/socket.c:1647 [inline]
 __sys_socket_create net/socket.c:1684 [inline]
 __sys_socket+0xd7/0x1b0 net/socket.c:1731
 __do_sys_socket net/socket.c:1745 [inline]
 __se_sys_socket net/socket.c:1743 [inline]
 __x64_sys_socket+0x7a/0x90 net/socket.c:1743
 do_syscall_x64 arch/x86/entry/syscall_64.c:63 [inline]
 do_syscall_64+0xfa/0x3b0 arch/x86/entry/syscall_64.c:94
 entry_SYSCALL_64_after_hwframe+0x77/0x7f

Freed by task 6358:
 kasan_save_stack mm/kasan/common.c:47 [inline]
 kasan_save_track+0x3e/0x80 mm/kasan/common.c:68
 kasan_save_free_info+0x46/0x50 mm/kasan/generic.c:576
 poison_slab_object mm/kasan/common.c:243 [inline]
 __kasan_slab_free+0x5b/0x80 mm/kasan/common.c:275
 kasan_slab_free include/linux/kasan.h:233 [inline]
 slab_free_hook mm/slub.c:2422 [inline]
 slab_free mm/slub.c:4695 [inline]
 kfree+0x18e/0x440 mm/slub.c:4894
 sk_common_release+0x75/0x310 net/core/sock.c:3919
 inet_release+0x144/0x190 net/ipv4/af_inet.c:437
 __sock_release net/socket.c:649 [inline]
 sock_close+0xc3/0x240 net/socket.c:1439
 __fput+0x44c/0xa70 fs/file_table.c:468
 task_work_run+0x1d4/0x260 kernel/task_work.c:227
 resume_user_mode_work include/linux/resume_user_mode.h:50 [inline]
 exit_to_user_mode_loop+0xec/0x110 kernel/entry/common.c:43
 exit_to_user_mode_prepare include/linux/irq-entry-common.h:225 [inline]
 syscall_exit_to_user_mode_work include/linux/entry-common.h:175 [inline]
 syscall_exit_to_user_mode include/linux/entry-common.h:210 [inline]
 do_syscall_64+0x2bd/0x3b0 arch/x86/entry/syscall_64.c:100
 entry_SYSCALL_64_after_hwframe+0x77/0x7f

The buggy address belongs to the object at ffff88810d802d00
 which belongs to the cache kmalloc-128 of size 128
The buggy address is located 8 bytes inside of
 freed 128-byte region [ffff88810d802d00, ffff88810d802d80)

The buggy address belongs to the physical page:
page: refcount:0 mapcount:0 mapping:0000000000000000 index:0x0 pfn:0x10d802
anon flags: 0x57ff00000000000(node=1|zone=2|lastcpupid=0x7ff)
page_type: f5(slab)
raw: 057ff00000000000 ffff88801a441a00 ffffea0004451300 0000000000000005
raw: 0000000000000000 0000000000100010 00000000f5000000 0000000000000000
page dumped because: kasan: bad access detected
page_owner tracks the page as allocated
page last allocated via order 0, migratetype Unmovable, gfp_mask 0x252800(GFP_NOWAIT|__GFP_NORETRY|__GFP_COMP|__GFP_THISNODE), pid 5962, tgid 5962 (syz-executor), ts 86250634562, free_ts 86224202724
 set_page_owner include/linux/page_owner.h:32 [inline]
 post_alloc_hook+0x240/0x2a0 mm/page_alloc.c:1851
 prep_new_page mm/page_alloc.c:1859 [inline]
 get_page_from_freelist+0x21e4/0x22c0 mm/page_alloc.c:3858
 __alloc_frozen_pages_noprof+0x181/0x370 mm/page_alloc.c:5148
 alloc_slab_page mm/slub.c:2494 [inline]
 allocate_slab+0x65/0x370 mm/slub.c:2660
 new_slab mm/slub.c:2714 [inline]
 ___slab_alloc+0xbeb/0x1420 mm/slub.c:3901
 __slab_alloc mm/slub.c:3992 [inline]
 __slab_alloc_node mm/slub.c:4067 [inline]
 slab_alloc_node mm/slub.c:4228 [inline]
 __do_kmalloc_node mm/slub.c:4375 [inline]
 __kmalloc_node_noprof+0x2fd/0x4e0 mm/slub.c:4382
 kmalloc_array_node_noprof include/linux/slab.h:1020 [inline]
 alloc_slab_obj_exts+0x39/0xa0 mm/slub.c:2033
 __memcg_slab_post_alloc_hook+0x31e/0x7f0 mm/memcontrol.c:3174
 memcg_slab_post_alloc_hook mm/slub.c:2221 [inline]
 slab_post_alloc_hook mm/slub.c:4201 [inline]
 slab_alloc_node mm/slub.c:4240 [inline]
 kmem_cache_alloc_noprof+0x2bf/0x3c0 mm/slub.c:4247
 alloc_empty_file+0x55/0x1d0 fs/file_table.c:237
 alloc_file fs/file_table.c:354 [inline]
 alloc_file_pseudo+0x13d/0x210 fs/file_table.c:383
 sock_alloc_file+0xb8/0x2e0 net/socket.c:470
 sock_map_fd net/socket.c:500 [inline]
 __sys_socket+0x13d/0x1b0 net/socket.c:1740
 __do_sys_socket net/socket.c:1745 [inline]
 __se_sys_socket net/socket.c:1743 [inline]
 __x64_sys_socket+0x7a/0x90 net/socket.c:1743
 do_syscall_x64 arch/x86/entry/syscall_64.c:63 [inline]
 do_syscall_64+0xfa/0x3b0 arch/x86/entry/syscall_64.c:94
 entry_SYSCALL_64_after_hwframe+0x77/0x7f
page last free pid 27 tgid 27 stack trace:
 reset_page_owner include/linux/page_owner.h:25 [inline]
 free_pages_prepare mm/page_alloc.c:1395 [inline]
 __free_frozen_pages+0xbc4/0xd30 mm/page_alloc.c:2895
 pagetable_free include/linux/mm.h:2898 [inline]
 pagetable_dtor_free include/linux/mm.h:2996 [inline]
 __tlb_remove_table+0x2d2/0x3b0 include/asm-generic/tlb.h:220
 __tlb_remove_table_free mm/mmu_gather.c:227 [inline]
 tlb_remove_table_rcu+0x85/0x100 mm/mmu_gather.c:290
 rcu_do_batch kernel/rcu/tree.c:2605 [inline]
 rcu_core+0xcab/0x1770 kernel/rcu/tree.c:2861
 handle_softirqs+0x286/0x870 kernel/softirq.c:579
 do_softirq+0xec/0x180 kernel/softirq.c:480
 __local_bh_enable_ip+0x17d/0x1c0 kernel/softirq.c:407
 spin_unlock_bh include/linux/spinlock.h:396 [inline]
 nsim_dev_trap_report drivers/net/netdevsim/dev.c:835 [inline]
 nsim_dev_trap_report_work+0x7c7/0xb80 drivers/net/netdevsim/dev.c:866
 process_one_work kernel/workqueue.c:3236 [inline]
 process_scheduled_works+0xae1/0x17b0 kernel/workqueue.c:3319
 worker_thread+0x8a0/0xda0 kernel/workqueue.c:3400
 kthread+0x711/0x8a0 kernel/kthread.c:463
 ret_from_fork+0x439/0x7d0 arch/x86/kernel/process.c:148
 ret_from_fork_asm+0x1a/0x30 arch/x86/entry/entry_64.S:245

Memory state around the buggy address:
 ffff88810d802c00: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
 ffff88810d802c80: fc fc fc fc fc fc fc fc fc fc fc fc fc fc fc fc
>ffff88810d802d00: fa fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb
                      ^
 ffff88810d802d80: fc fc fc fc fc fc fc fc fc fc fc fc fc fc fc fc
 ffff88810d802e00: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
==================================================================


***

If these findings have caused you to resend the series or submit a
separate fix, please add the following tag to your commit message:
  Tested-by: syzbot@syzkaller.appspotmail.com

---
This report is generated by a bot. It may contain errors.
syzbot ci engineers can be reached at syzkaller@googlegroups.com.
