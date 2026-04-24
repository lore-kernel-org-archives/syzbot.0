Received: from mail-ot1-f69.google.com (mail-ot1-f69.google.com [209.85.210.69])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 766666FBF
	for <syzbot@lists.linux.dev>; Fri, 24 Apr 2026 02:01:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.69
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776996103; cv=none; b=oEbk22HWOaE7ksngoqD/kCXH8AL0SfWHU5sR+k7ToEXaONf/IMESq72g0gT8sy0b8FN2T7mrOFqtvHyDEbr8TKcNpzFXXkTIkEEQKwEv7ve0OfHvRLAtGOmVmE0tgmq3u70Ojoh/GDrUdzv5n+MQ0R09FkYXdPA2dOAjc3mpXGc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776996103; c=relaxed/simple;
	bh=29Lb0fvRUayNqoASEkwFdXuBdkjlr5MvcwNKFJfzEf0=;
	h=MIME-Version:Date:Message-ID:Subject:From:To:Cc:Content-Type; b=WU9yEOc98f/1QY811x+G3IKASqT5iqtY6cSJInGPwlZIlg7kTRkVlLg7uoUE7XAjLC6PnC0X1xicZ3kEWxVBSc4cjAg/fRuxioMEyUXS3Dx5G+f4rWn0qpEGYnvE6X6sFMMP0UedhVh6tpfPWQ6xAKlfDTPhr9MimQ/nxpBaaUc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com; arc=none smtp.client-ip=209.85.210.69
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com
Received: by mail-ot1-f69.google.com with SMTP id 46e09a7af769-7dcc8f071b3so9506362a34.2
        for <syzbot@lists.linux.dev>; Thu, 23 Apr 2026 19:01:40 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1776996099; x=1777600899;
        h=cc:to:from:subject:message-id:date:mime-version:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=avyUj90kcRyht8PgbTkjh5oZrpbfSnAiXSlRiyEDryM=;
        b=YGrROWNwQE4zVHLnBrYp+KZYwcdWk43zw9ylht19eQXhErIuQxNYIFzNZNg8SIJTxU
         T+6MuLrTiVSn4CfjJAF6VUnIRQQ1ZxDrNFrC1buJhqcsXyx9ds3dW74sDU/aZiJAebMW
         mnZ7WCD9uul84KxjCCTL8fFDxVt3M7AbNIEvRK3OtankEK3d+WSqfydwhRWtEu/w0x/4
         a3MZFdkDRWnxZ0ry/gFqya2AnjGHWQMQbSa+o2E441gj455u4zb6XChWGQxnHpcGqMvh
         JOWt+RvuaRh4u/bqVYNEQG/1OfWCPuV9moavxHkGV1OCcxp2F0zD6KzklkZAOvEbngKp
         oLMA==
X-Gm-Message-State: AOJu0Yz0bHiZH1rRBSPQvpumOAKX9PvEmsiUnpIACCMIXci0IxGSUzZB
	f6SqF4xvO3z6IWuIXl/LYl0Jo6cqG/JwqdsFcXKJuBy1IF9Cm60XvfJfMcGlZMRJrftE9U3fan/
	pThndgcoyf1K5mSiJf75Ec6qhRqioiLXBnlglxhGUtOZBPjefybaFg4ATnLQ=
Precedence: bulk
X-Mailing-List: syzbot@lists.linux.dev
List-Id: <syzbot.lists.linux.dev>
List-Subscribe: <mailto:syzbot+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:syzbot+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Received: by 2002:a05:6820:1905:b0:694:8f3a:3f36 with SMTP id
 006d021491bc7-6948f3a46c5mr10545840eaf.27.1776996099168; Thu, 23 Apr 2026
 19:01:39 -0700 (PDT)
Date: Thu, 23 Apr 2026 19:01:39 -0700
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <69eacf03.a00a0220.17a17.004c.GAE@google.com>
Subject: [moderation/CI] Re: netlink: clean up failed initial dump-start state
From: syzbot ci <syzbot+ci8e383eae6e0116dc@syzkaller.appspotmail.com>
To: syzkaller-upstream-moderation@googlegroups.com
Cc: syzbot@lists.linux.dev
Content-Type: text/plain; charset="UTF-8"

syzbot ci has tested the following series

[v2] netlink: clean up failed initial dump-start state
https://lore.kernel.org/all/20260423212827.1177552-1-michael.bommarito@gmail.com
* [PATCH net-next v2] netlink: clean up failed initial dump-start state

and found the following issues:
* KASAN: slab-use-after-free Read in inet_diag_dump_done
* KASAN: slab-use-after-free Read in netlink_dump_done
* KASAN: slab-use-after-free Read in netlink_rcv_skb
* KASAN: slab-use-after-free Read in rdma_nl_rcv
* KASAN: slab-use-after-free Write in genl_done

Full report is available here:
https://ci.syzbot.org/series/d76773fc-9b84-4669-b27e-791385b0b902

***

KASAN: slab-use-after-free Read in inet_diag_dump_done

tree:      torvalds
URL:       https://kernel.googlesource.com/pub/scm/linux/kernel/git/torvalds/linux
base:      0b5e8d7999076ac3c490fc18376a404e2626abff
arch:      amd64
compiler:  Debian clang version 21.1.8 (++20251221033036+2078da43e25a-1~exp1~20251221153213.50), Debian LLD 21.1.8
config:    https://ci.syzbot.org/builds/cb46a152-33c1-4b5e-bb75-bab2ecb45113/config
syz repro: https://ci.syzbot.org/findings/546e718b-5aa2-4705-85d2-51b88eb73b34/syz_repro

==================================================================
BUG: KASAN: slab-use-after-free in inet_diag_dump_done+0x54/0x90 net/ipv4/inet_diag.c:893
Read of size 8 at addr ffff888110c9a1a0 by task syz.1.18/6001

CPU: 0 UID: 0 PID: 6001 Comm: syz.1.18 Not tainted syzkaller #0 PREEMPT(full) 
Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS 1.16.2-debian-1.16.2-1 04/01/2014
Call Trace:
 <TASK>
 dump_stack_lvl+0xe8/0x150 lib/dump_stack.c:120
 print_address_description+0x55/0x1e0 mm/kasan/report.c:378
 print_report+0x58/0x70 mm/kasan/report.c:482
 kasan_report+0x117/0x150 mm/kasan/report.c:595
 inet_diag_dump_done+0x54/0x90 net/ipv4/inet_diag.c:893
 netlink_dump_cleanup+0x99/0x120 net/netlink/af_netlink.c:2259
 netlink_dump+0xbe9/0xf40 net/netlink/af_netlink.c:2385
 __netlink_dump_start+0x5cb/0x7e0 net/netlink/af_netlink.c:2455
 netlink_dump_start include/linux/netlink.h:341 [inline]
 inet_diag_handler_cmd+0x1e0/0x2c0 net/ipv4/inet_diag.c:978
 sock_diag_rcv_msg+0x4cc/0x600 net/core/sock_diag.c:-1
 netlink_rcv_skb+0x232/0x4b0 net/netlink/af_netlink.c:2565
 netlink_unicast_kernel net/netlink/af_netlink.c:1314 [inline]
 netlink_unicast+0x80f/0x9b0 net/netlink/af_netlink.c:1340
 netlink_sendmsg+0x813/0xb40 net/netlink/af_netlink.c:1890
 sock_sendmsg_nosec net/socket.c:727 [inline]
 __sock_sendmsg net/socket.c:742 [inline]
 ____sys_sendmsg+0x972/0x9f0 net/socket.c:2592
 ___sys_sendmsg+0x2a5/0x360 net/socket.c:2646
 __sys_sendmsg net/socket.c:2678 [inline]
 __do_sys_sendmsg net/socket.c:2683 [inline]
 __se_sys_sendmsg net/socket.c:2681 [inline]
 __x64_sys_sendmsg+0x1bd/0x2a0 net/socket.c:2681
 do_syscall_x64 arch/x86/entry/syscall_64.c:63 [inline]
 do_syscall_64+0x14d/0xf80 arch/x86/entry/syscall_64.c:94
 entry_SYSCALL_64_after_hwframe+0x77/0x7f
RIP: 0033:0x7fe80d39c819
Code: ff c3 66 2e 0f 1f 84 00 00 00 00 00 0f 1f 44 00 00 48 89 f8 48 89 f7 48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 ff ff 73 01 c3 48 c7 c1 e8 ff ff ff f7 d8 64 89 01 48
RSP: 002b:00007fe80e220028 EFLAGS: 00000246 ORIG_RAX: 000000000000002e
RAX: ffffffffffffffda RBX: 00007fe80d616090 RCX: 00007fe80d39c819
RDX: 0000000000000000 RSI: 0000200000000200 RDI: 0000000000000003
RBP: 00007fe80d432c91 R08: 0000000000000000 R09: 0000000000000000
R10: 0000000000000000 R11: 0000000000000246 R12: 0000000000000000
R13: 00007fe80d616128 R14: 00007fe80d616090 R15: 00007ffc5edf12b8
 </TASK>

Allocated by task 6001:
 kasan_save_stack mm/kasan/common.c:57 [inline]
 kasan_save_track+0x3e/0x80 mm/kasan/common.c:78
 poison_kmalloc_redzone mm/kasan/common.c:398 [inline]
 __kasan_kmalloc+0x93/0xb0 mm/kasan/common.c:415
 kasan_kmalloc include/linux/kasan.h:263 [inline]
 __kmalloc_cache_noprof+0x31c/0x660 mm/slub.c:5380
 kmalloc_noprof include/linux/slab.h:950 [inline]
 kzalloc_noprof include/linux/slab.h:1188 [inline]
 __inet_diag_dump_start+0x8b/0xbf0 net/ipv4/inet_diag.c:848
 __netlink_dump_start+0x469/0x7e0 net/netlink/af_netlink.c:2446
 netlink_dump_start include/linux/netlink.h:341 [inline]
 inet_diag_handler_cmd+0x1e0/0x2c0 net/ipv4/inet_diag.c:978
 sock_diag_rcv_msg+0x4cc/0x600 net/core/sock_diag.c:-1
 netlink_rcv_skb+0x232/0x4b0 net/netlink/af_netlink.c:2565
 netlink_unicast_kernel net/netlink/af_netlink.c:1314 [inline]
 netlink_unicast+0x80f/0x9b0 net/netlink/af_netlink.c:1340
 netlink_sendmsg+0x813/0xb40 net/netlink/af_netlink.c:1890
 sock_sendmsg_nosec net/socket.c:727 [inline]
 __sock_sendmsg net/socket.c:742 [inline]
 ____sys_sendmsg+0x972/0x9f0 net/socket.c:2592
 ___sys_sendmsg+0x2a5/0x360 net/socket.c:2646
 __sys_sendmsg net/socket.c:2678 [inline]
 __do_sys_sendmsg net/socket.c:2683 [inline]
 __se_sys_sendmsg net/socket.c:2681 [inline]
 __x64_sys_sendmsg+0x1bd/0x2a0 net/socket.c:2681
 do_syscall_x64 arch/x86/entry/syscall_64.c:63 [inline]
 do_syscall_64+0x14d/0xf80 arch/x86/entry/syscall_64.c:94
 entry_SYSCALL_64_after_hwframe+0x77/0x7f

Freed by task 5995:
 kasan_save_stack mm/kasan/common.c:57 [inline]
 kasan_save_track+0x3e/0x80 mm/kasan/common.c:78
 kasan_save_free_info+0x46/0x50 mm/kasan/generic.c:584
 poison_slab_object mm/kasan/common.c:253 [inline]
 __kasan_slab_free+0x5c/0x80 mm/kasan/common.c:285
 kasan_slab_free include/linux/kasan.h:235 [inline]
 slab_free_hook mm/slub.c:2685 [inline]
 slab_free mm/slub.c:6165 [inline]
 kfree+0x1c5/0x640 mm/slub.c:6483
 inet_diag_dump_done+0x73/0x90 net/ipv4/inet_diag.c:894
 netlink_dump_cleanup+0x99/0x120 net/netlink/af_netlink.c:2259
 netlink_dump+0xbe9/0xf40 net/netlink/af_netlink.c:2385
 netlink_recvmsg+0x690/0xa50 net/netlink/af_netlink.c:1972
 sock_recvmsg_nosec net/socket.c:1078 [inline]
 sock_recvmsg+0x172/0x1b0 net/socket.c:1100
 ____sys_recvmsg+0x1e6/0x4a0 net/socket.c:2812
 ___sys_recvmsg+0x215/0x590 net/socket.c:2854
 __sys_recvmsg net/socket.c:2887 [inline]
 __do_sys_recvmsg net/socket.c:2893 [inline]
 __se_sys_recvmsg net/socket.c:2890 [inline]
 __x64_sys_recvmsg+0x1ba/0x2a0 net/socket.c:2890
 do_syscall_x64 arch/x86/entry/syscall_64.c:63 [inline]
 do_syscall_64+0x14d/0xf80 arch/x86/entry/syscall_64.c:94
 entry_SYSCALL_64_after_hwframe+0x77/0x7f

The buggy address belongs to the object at ffff888110c9a180
 which belongs to the cache kmalloc-64 of size 64
The buggy address is located 32 bytes inside of
 freed 64-byte region [ffff888110c9a180, ffff888110c9a1c0)

The buggy address belongs to the physical page:
page: refcount:0 mapcount:0 mapping:0000000000000000 index:0x0 pfn:0x110c9a
flags: 0x17ff00000000000(node=0|zone=2|lastcpupid=0x7ff)
page_type: f5(slab)
raw: 017ff00000000000 ffff8881000418c0 dead000000000100 dead000000000122
raw: 0000000000000000 0000000800200020 00000000f5000000 0000000000000000
page dumped because: kasan: bad access detected
page_owner tracks the page as allocated
page last allocated via order 0, migratetype Unmovable, gfp_mask 0xd2cc0(GFP_KERNEL|__GFP_NOWARN|__GFP_NORETRY|__GFP_COMP|__GFP_NOMEMALLOC), pid 26, tgid 26 (kworker/u9:0), ts 20518825132, free_ts 20518815181
 set_page_owner include/linux/page_owner.h:32 [inline]
 post_alloc_hook+0x231/0x280 mm/page_alloc.c:1868
 prep_new_page mm/page_alloc.c:1876 [inline]
 get_page_from_freelist+0x24ba/0x2540 mm/page_alloc.c:3956
 __alloc_frozen_pages_noprof+0x18d/0x380 mm/page_alloc.c:5236
 alloc_slab_page mm/slub.c:3292 [inline]
 allocate_slab+0x77/0x660 mm/slub.c:3481
 new_slab mm/slub.c:3539 [inline]
 refill_objects+0x331/0x3c0 mm/slub.c:7175
 refill_sheaf mm/slub.c:2812 [inline]
 __pcs_replace_empty_main+0x2e6/0x730 mm/slub.c:4615
 alloc_from_pcs mm/slub.c:4717 [inline]
 slab_alloc_node mm/slub.c:4851 [inline]
 __do_kmalloc_node mm/slub.c:5259 [inline]
 __kmalloc_node_noprof+0x577/0x7c0 mm/slub.c:5266
 kmalloc_node_noprof include/linux/slab.h:1081 [inline]
 __vmalloc_area_node mm/vmalloc.c:3857 [inline]
 __vmalloc_node_range_noprof+0x5ef/0x1750 mm/vmalloc.c:4064
 __vmalloc_node_noprof+0xc2/0x100 mm/vmalloc.c:4124
 alloc_thread_stack_node kernel/fork.c:355 [inline]
 dup_task_struct+0x27b/0x800 kernel/fork.c:924
 copy_process+0x508/0x3cd0 kernel/fork.c:2050
 kernel_clone+0x248/0x8e0 kernel/fork.c:2653
 user_mode_thread+0x110/0x180 kernel/fork.c:2729
 call_usermodehelper_exec_work+0x5c/0x230 kernel/umh.c:171
 process_one_work kernel/workqueue.c:3276 [inline]
 process_scheduled_works+0xb6e/0x18c0 kernel/workqueue.c:3359
 worker_thread+0xa53/0xfc0 kernel/workqueue.c:3440
page last free pid 26 tgid 26 stack trace:
 reset_page_owner include/linux/page_owner.h:25 [inline]
 __free_pages_prepare mm/page_alloc.c:1412 [inline]
 __free_frozen_pages+0xbc7/0xd30 mm/page_alloc.c:2953
 __kasan_populate_vmalloc_do mm/kasan/shadow.c:393 [inline]
 __kasan_populate_vmalloc+0x1b2/0x1d0 mm/kasan/shadow.c:424
 kasan_populate_vmalloc include/linux/kasan.h:580 [inline]
 alloc_vmap_area+0xd73/0x14b0 mm/vmalloc.c:2123
 __get_vm_area_node+0x1f8/0x300 mm/vmalloc.c:3226
 __vmalloc_node_range_noprof+0x36a/0x1750 mm/vmalloc.c:4024
 __vmalloc_node_noprof+0xc2/0x100 mm/vmalloc.c:4124
 alloc_thread_stack_node kernel/fork.c:355 [inline]
 dup_task_struct+0x27b/0x800 kernel/fork.c:924
 copy_process+0x508/0x3cd0 kernel/fork.c:2050
 kernel_clone+0x248/0x8e0 kernel/fork.c:2653
 user_mode_thread+0x110/0x180 kernel/fork.c:2729
 call_usermodehelper_exec_work+0x5c/0x230 kernel/umh.c:171
 process_one_work kernel/workqueue.c:3276 [inline]
 process_scheduled_works+0xb6e/0x18c0 kernel/workqueue.c:3359
 worker_thread+0xa53/0xfc0 kernel/workqueue.c:3440
 kthread+0x388/0x470 kernel/kthread.c:436
 ret_from_fork+0x51e/0xb90 arch/x86/kernel/process.c:158
 ret_from_fork_asm+0x1a/0x30 arch/x86/entry/entry_64.S:245

Memory state around the buggy address:
 ffff888110c9a080: fa fb fb fb fb fb fb fb fc fc fc fc fc fc fc fc
 ffff888110c9a100: 00 00 00 00 00 00 00 00 fc fc fc fc fc fc fc fc
>ffff888110c9a180: fa fb fb fb fb fb fb fb fc fc fc fc fc fc fc fc
                               ^
 ffff888110c9a200: 00 00 00 00 00 fc fc fc fc fc fc fc fc fc fc fc
 ffff888110c9a280: 00 00 00 00 00 00 00 00 fc fc fc fc fc fc fc fc
==================================================================


***

KASAN: slab-use-after-free Read in netlink_dump_done

tree:      torvalds
URL:       https://kernel.googlesource.com/pub/scm/linux/kernel/git/torvalds/linux
base:      0b5e8d7999076ac3c490fc18376a404e2626abff
arch:      amd64
compiler:  Debian clang version 21.1.8 (++20251221033036+2078da43e25a-1~exp1~20251221153213.50), Debian LLD 21.1.8
config:    https://ci.syzbot.org/builds/cb46a152-33c1-4b5e-bb75-bab2ecb45113/config
syz repro: https://ci.syzbot.org/findings/86101c1f-0d2b-420f-a6bb-cd0260a6b2f5/syz_repro

==================================================================
BUG: KASAN: slab-use-after-free in nlmsg_put_answer include/net/netlink.h:1041 [inline]
BUG: KASAN: slab-use-after-free in netlink_dump_done+0x54d/0x890 net/netlink/af_netlink.c:2228
Read of size 4 at addr ffff8881bb35b9b4 by task syz.0.279/6738

CPU: 0 UID: 0 PID: 6738 Comm: syz.0.279 Not tainted syzkaller #0 PREEMPT(full) 
Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS 1.16.2-debian-1.16.2-1 04/01/2014
Call Trace:
 <TASK>
 dump_stack_lvl+0xe8/0x150 lib/dump_stack.c:120
 print_address_description+0x55/0x1e0 mm/kasan/report.c:378
 print_report+0x58/0x70 mm/kasan/report.c:482
 kasan_report+0x117/0x150 mm/kasan/report.c:595
 nlmsg_put_answer include/net/netlink.h:1041 [inline]
 netlink_dump_done+0x54d/0x890 net/netlink/af_netlink.c:2228
 netlink_dump+0xacb/0xf40 net/netlink/af_netlink.c:2365
 netlink_recvmsg+0x690/0xa50 net/netlink/af_netlink.c:1972
 sock_recvmsg_nosec net/socket.c:1078 [inline]
 sock_recvmsg+0x172/0x1b0 net/socket.c:1100
 sock_read_iter+0x251/0x320 net/socket.c:1170
 new_sync_read fs/read_write.c:493 [inline]
 vfs_read+0x582/0xa70 fs/read_write.c:574
 ksys_read+0x150/0x270 fs/read_write.c:717
 do_syscall_x64 arch/x86/entry/syscall_64.c:63 [inline]
 do_syscall_64+0x14d/0xf80 arch/x86/entry/syscall_64.c:94
 entry_SYSCALL_64_after_hwframe+0x77/0x7f
RIP: 0033:0x7fb5eaf9c819
Code: ff c3 66 2e 0f 1f 84 00 00 00 00 00 0f 1f 44 00 00 48 89 f8 48 89 f7 48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 ff ff 73 01 c3 48 c7 c1 e8 ff ff ff f7 d8 64 89 01 48
RSP: 002b:00007fb5ebe08028 EFLAGS: 00000246 ORIG_RAX: 0000000000000000
RAX: ffffffffffffffda RBX: 00007fb5eb215fa0 RCX: 00007fb5eaf9c819
RDX: 000000000000009b RSI: 00002000000003c0 RDI: 0000000000000004
RBP: 00007fb5eb032c91 R08: 0000000000000000 R09: 0000000000000000
R10: 0000000000000000 R11: 0000000000000246 R12: 0000000000000000
R13: 00007fb5eb216038 R14: 00007fb5eb215fa0 R15: 00007ffc181c9c68
 </TASK>

Allocated by task 6739:
 kasan_save_stack mm/kasan/common.c:57 [inline]
 kasan_save_track+0x3e/0x80 mm/kasan/common.c:78
 unpoison_slab_object mm/kasan/common.c:340 [inline]
 __kasan_slab_alloc+0x6c/0x80 mm/kasan/common.c:366
 kasan_slab_alloc include/linux/kasan.h:253 [inline]
 slab_post_alloc_hook mm/slub.c:4538 [inline]
 slab_alloc_node mm/slub.c:4866 [inline]
 kmem_cache_alloc_node_noprof+0x384/0x690 mm/slub.c:4918
 __alloc_skb+0x1d0/0x7d0 net/core/skbuff.c:702
 netlink_sendmsg+0x5d4/0xb40 net/netlink/af_netlink.c:1865
 sock_sendmsg_nosec net/socket.c:727 [inline]
 __sock_sendmsg net/socket.c:742 [inline]
 ____sys_sendmsg+0x972/0x9f0 net/socket.c:2592
 ___sys_sendmsg+0x2a5/0x360 net/socket.c:2646
 __sys_sendmsg net/socket.c:2678 [inline]
 __do_sys_sendmsg net/socket.c:2683 [inline]
 __se_sys_sendmsg net/socket.c:2681 [inline]
 __x64_sys_sendmsg+0x1bd/0x2a0 net/socket.c:2681
 do_syscall_x64 arch/x86/entry/syscall_64.c:63 [inline]
 do_syscall_64+0x14d/0xf80 arch/x86/entry/syscall_64.c:94
 entry_SYSCALL_64_after_hwframe+0x77/0x7f

Freed by task 6739:
 kasan_save_stack mm/kasan/common.c:57 [inline]
 kasan_save_track+0x3e/0x80 mm/kasan/common.c:78
 kasan_save_free_info+0x46/0x50 mm/kasan/generic.c:584
 poison_slab_object mm/kasan/common.c:253 [inline]
 __kasan_slab_free+0x5c/0x80 mm/kasan/common.c:285
 kasan_slab_free include/linux/kasan.h:235 [inline]
 slab_free_hook mm/slub.c:2685 [inline]
 slab_free mm/slub.c:6165 [inline]
 kmem_cache_free+0x189/0x630 mm/slub.c:6295
 netlink_unicast_kernel net/netlink/af_netlink.c:1315 [inline]
 netlink_unicast+0x817/0x9b0 net/netlink/af_netlink.c:1340
 netlink_sendmsg+0x813/0xb40 net/netlink/af_netlink.c:1890
 sock_sendmsg_nosec net/socket.c:727 [inline]
 __sock_sendmsg net/socket.c:742 [inline]
 ____sys_sendmsg+0x972/0x9f0 net/socket.c:2592
 ___sys_sendmsg+0x2a5/0x360 net/socket.c:2646
 __sys_sendmsg net/socket.c:2678 [inline]
 __do_sys_sendmsg net/socket.c:2683 [inline]
 __se_sys_sendmsg net/socket.c:2681 [inline]
 __x64_sys_sendmsg+0x1bd/0x2a0 net/socket.c:2681
 do_syscall_x64 arch/x86/entry/syscall_64.c:63 [inline]
 do_syscall_64+0x14d/0xf80 arch/x86/entry/syscall_64.c:94
 entry_SYSCALL_64_after_hwframe+0x77/0x7f

The buggy address belongs to the object at ffff8881bb35b980
 which belongs to the cache skbuff_head_cache of size 240
The buggy address is located 52 bytes inside of
 freed 240-byte region [ffff8881bb35b980, ffff8881bb35ba70)

The buggy address belongs to the physical page:
page: refcount:0 mapcount:0 mapping:0000000000000000 index:0xffff8881bb35b200 pfn:0x1bb35a
head: order:1 mapcount:0 entire_mapcount:0 nr_pages_mapped:0 pincount:0
flags: 0x57ff00000000240(workingset|head|node=1|zone=2|lastcpupid=0x7ff)
page_type: f5(slab)
raw: 057ff00000000240 ffff888160417a00 ffff88816041db88 ffffea0005cae210
raw: ffff8881bb35b200 000000080015000f 00000000f5000000 0000000000000000
head: 057ff00000000240 ffff888160417a00 ffff88816041db88 ffffea0005cae210
head: ffff8881bb35b200 000000080015000f 00000000f5000000 0000000000000000
head: 057ff00000000001 ffffffffffffff81 00000000ffffffff 00000000ffffffff
head: ffffffffffffffff 0000000000000000 00000000ffffffff 0000000000000002
page dumped because: kasan: bad access detected
page_owner tracks the page as allocated
page last allocated via order 1, migratetype Unmovable, gfp_mask 0xd20c0(__GFP_IO|__GFP_FS|__GFP_NOWARN|__GFP_NORETRY|__GFP_COMP|__GFP_NOMEMALLOC), pid 5552, tgid 5552 (dhcpcd), ts 37959428622, free_ts 37819349212
 set_page_owner include/linux/page_owner.h:32 [inline]
 post_alloc_hook+0x231/0x280 mm/page_alloc.c:1868
 prep_new_page mm/page_alloc.c:1876 [inline]
 get_page_from_freelist+0x24ba/0x2540 mm/page_alloc.c:3956
 __alloc_frozen_pages_noprof+0x18d/0x380 mm/page_alloc.c:5236
 alloc_slab_page mm/slub.c:3292 [inline]
 allocate_slab+0x77/0x660 mm/slub.c:3481
 new_slab mm/slub.c:3539 [inline]
 refill_objects+0x331/0x3c0 mm/slub.c:7175
 refill_sheaf mm/slub.c:2812 [inline]
 __pcs_replace_empty_main+0x2e6/0x730 mm/slub.c:4615
 alloc_from_pcs mm/slub.c:4717 [inline]
 slab_alloc_node mm/slub.c:4851 [inline]
 kmem_cache_alloc_node_noprof+0x441/0x690 mm/slub.c:4918
 __alloc_skb+0x1d0/0x7d0 net/core/skbuff.c:702
 alloc_skb include/linux/skbuff.h:1383 [inline]
 alloc_skb_with_frags+0xc8/0x760 net/core/skbuff.c:6763
 sock_alloc_send_pskb+0x878/0x990 net/core/sock.c:2995
 unix_dgram_sendmsg+0x460/0x18e0 net/unix/af_unix.c:2127
 sock_sendmsg_nosec net/socket.c:727 [inline]
 __sock_sendmsg net/socket.c:742 [inline]
 sock_write_iter+0x49b/0x4f0 net/socket.c:1195
 do_iter_readv_writev+0x619/0x8c0 fs/read_write.c:-1
 vfs_writev+0x33c/0x990 fs/read_write.c:1059
 do_writev+0x154/0x2e0 fs/read_write.c:1105
 do_syscall_x64 arch/x86/entry/syscall_64.c:63 [inline]
 do_syscall_64+0x14d/0xf80 arch/x86/entry/syscall_64.c:94
page last free pid 5552 tgid 5552 stack trace:
 reset_page_owner include/linux/page_owner.h:25 [inline]
 __free_pages_prepare mm/page_alloc.c:1412 [inline]
 __free_frozen_pages+0xbc7/0xd30 mm/page_alloc.c:2953
 mm_free_pgd kernel/fork.c:585 [inline]
 __mmdrop+0xb5/0x750 kernel/fork.c:727
 mmdrop include/linux/sched/mm.h:55 [inline]
 mmdrop_sched include/linux/sched/mm.h:83 [inline]
 mmdrop_lazy_tlb_sched include/linux/sched/mm.h:110 [inline]
 finish_task_switch+0x449/0x920 kernel/sched/core.c:5180
 context_switch kernel/sched/core.c:5301 [inline]
 __schedule+0x15e5/0x52d0 kernel/sched/core.c:6911
 __schedule_loop kernel/sched/core.c:6993 [inline]
 schedule+0x164/0x360 kernel/sched/core.c:7008
 schedule_hrtimeout_range_clock+0x1e7/0x320 kernel/time/sleep_timeout.c:207
 poll_schedule_timeout+0xd0/0x1a0 fs/select.c:241
 do_poll fs/select.c:954 [inline]
 do_sys_poll+0x7e8/0x1120 fs/select.c:1004
 __do_sys_ppoll fs/select.c:1106 [inline]
 __se_sys_ppoll+0x209/0x2b0 fs/select.c:1086
 do_syscall_x64 arch/x86/entry/syscall_64.c:63 [inline]
 do_syscall_64+0x14d/0xf80 arch/x86/entry/syscall_64.c:94
 entry_SYSCALL_64_after_hwframe+0x77/0x7f

Memory state around the buggy address:
 ffff8881bb35b880: fb fb fb fb fb fb fb fb fb fb fb fb fb fb fc fc
 ffff8881bb35b900: fc fc fc fc fc fc fc fc fc fc fc fc fc fc fc fc
>ffff8881bb35b980: fa fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb
                                     ^
 ffff8881bb35ba00: fb fb fb fb fb fb fb fb fb fb fb fb fb fb fc fc
 ffff8881bb35ba80: fc fc fc fc fc fc fc fc fc fc fc fc fc fc fc fc
==================================================================


***

KASAN: slab-use-after-free Read in netlink_rcv_skb

tree:      torvalds
URL:       https://kernel.googlesource.com/pub/scm/linux/kernel/git/torvalds/linux
base:      0b5e8d7999076ac3c490fc18376a404e2626abff
arch:      amd64
compiler:  Debian clang version 21.1.8 (++20251221033036+2078da43e25a-1~exp1~20251221153213.50), Debian LLD 21.1.8
config:    https://ci.syzbot.org/builds/cb46a152-33c1-4b5e-bb75-bab2ecb45113/config
syz repro: https://ci.syzbot.org/findings/584da8f1-c227-495f-aa8f-564d0bcc212f/syz_repro

==================================================================
BUG: KASAN: slab-use-after-free in netlink_rcv_skb+0x395/0x4b0 net/netlink/af_netlink.c:2574
Read of size 4 at addr ffff8881753dc700 by task syz.2.60/6106

CPU: 1 UID: 0 PID: 6106 Comm: syz.2.60 Not tainted syzkaller #0 PREEMPT(full) 
Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS 1.16.2-debian-1.16.2-1 04/01/2014
Call Trace:
 <TASK>
 dump_stack_lvl+0xe8/0x150 lib/dump_stack.c:120
 print_address_description+0x55/0x1e0 mm/kasan/report.c:378
 print_report+0x58/0x70 mm/kasan/report.c:482
 kasan_report+0x117/0x150 mm/kasan/report.c:595
 netlink_rcv_skb+0x395/0x4b0 net/netlink/af_netlink.c:2574
 nfnetlink_rcv+0x2c0/0x27b0 net/netfilter/nfnetlink.c:669
 netlink_unicast_kernel net/netlink/af_netlink.c:1314 [inline]
 netlink_unicast+0x80f/0x9b0 net/netlink/af_netlink.c:1340
 netlink_sendmsg+0x813/0xb40 net/netlink/af_netlink.c:1890
 sock_sendmsg_nosec net/socket.c:727 [inline]
 __sock_sendmsg net/socket.c:742 [inline]
 ____sys_sendmsg+0x972/0x9f0 net/socket.c:2592
 ___sys_sendmsg+0x2a5/0x360 net/socket.c:2646
 __sys_sendmsg net/socket.c:2678 [inline]
 __do_sys_sendmsg net/socket.c:2683 [inline]
 __se_sys_sendmsg net/socket.c:2681 [inline]
 __x64_sys_sendmsg+0x1bd/0x2a0 net/socket.c:2681
 do_syscall_x64 arch/x86/entry/syscall_64.c:63 [inline]
 do_syscall_64+0x14d/0xf80 arch/x86/entry/syscall_64.c:94
 entry_SYSCALL_64_after_hwframe+0x77/0x7f
RIP: 0033:0x7f4d3a59c819
Code: ff c3 66 2e 0f 1f 84 00 00 00 00 00 0f 1f 44 00 00 48 89 f8 48 89 f7 48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 ff ff 73 01 c3 48 c7 c1 e8 ff ff ff f7 d8 64 89 01 48
RSP: 002b:00007f4d3b3b8028 EFLAGS: 00000246 ORIG_RAX: 000000000000002e
RAX: ffffffffffffffda RBX: 00007f4d3a816090 RCX: 00007f4d3a59c819
RDX: 0000000000000080 RSI: 0000200000000100 RDI: 0000000000000003
RBP: 00007f4d3a632c91 R08: 0000000000000000 R09: 0000000000000000
R10: 0000000000000000 R11: 0000000000000246 R12: 0000000000000000
R13: 00007f4d3a816128 R14: 00007f4d3a816090 R15: 00007ffd69453fe8
 </TASK>

Allocated by task 6106:
 kasan_save_stack mm/kasan/common.c:57 [inline]
 kasan_save_track+0x3e/0x80 mm/kasan/common.c:78
 unpoison_slab_object mm/kasan/common.c:340 [inline]
 __kasan_slab_alloc+0x6c/0x80 mm/kasan/common.c:366
 kasan_slab_alloc include/linux/kasan.h:253 [inline]
 slab_post_alloc_hook mm/slub.c:4538 [inline]
 slab_alloc_node mm/slub.c:4866 [inline]
 kmem_cache_alloc_node_noprof+0x384/0x690 mm/slub.c:4918
 kmalloc_reserve net/core/skbuff.c:613 [inline]
 __alloc_skb+0x27d/0x7d0 net/core/skbuff.c:713
 netlink_sendmsg+0x5d4/0xb40 net/netlink/af_netlink.c:1865
 sock_sendmsg_nosec net/socket.c:727 [inline]
 __sock_sendmsg net/socket.c:742 [inline]
 ____sys_sendmsg+0x972/0x9f0 net/socket.c:2592
 ___sys_sendmsg+0x2a5/0x360 net/socket.c:2646
 __sys_sendmsg net/socket.c:2678 [inline]
 __do_sys_sendmsg net/socket.c:2683 [inline]
 __se_sys_sendmsg net/socket.c:2681 [inline]
 __x64_sys_sendmsg+0x1bd/0x2a0 net/socket.c:2681
 do_syscall_x64 arch/x86/entry/syscall_64.c:63 [inline]
 do_syscall_64+0x14d/0xf80 arch/x86/entry/syscall_64.c:94
 entry_SYSCALL_64_after_hwframe+0x77/0x7f

Freed by task 6106:
 kasan_save_stack mm/kasan/common.c:57 [inline]
 kasan_save_track+0x3e/0x80 mm/kasan/common.c:78
 kasan_save_free_info+0x46/0x50 mm/kasan/generic.c:584
 poison_slab_object mm/kasan/common.c:253 [inline]
 __kasan_slab_free+0x5c/0x80 mm/kasan/common.c:285
 kasan_slab_free include/linux/kasan.h:235 [inline]
 slab_free_hook mm/slub.c:2685 [inline]
 slab_free mm/slub.c:6165 [inline]
 kmem_cache_free+0x189/0x630 mm/slub.c:6295
 skb_kfree_head net/core/skbuff.c:1087 [inline]
 skb_free_head net/core/skbuff.c:1101 [inline]
 skb_release_data+0x81c/0xa80 net/core/skbuff.c:1128
 skb_release_all net/core/skbuff.c:1203 [inline]
 __kfree_skb+0x5d/0x210 net/core/skbuff.c:1217
 netlink_dump+0xbe9/0xf40 net/netlink/af_netlink.c:2385
 __netlink_dump_start+0x5cb/0x7e0 net/netlink/af_netlink.c:2455
 netlink_dump_start include/linux/netlink.h:341 [inline]
 ip_set_dump+0x15b/0x1f0 net/netfilter/ipset/ip_set_core.c:1717
 nfnetlink_rcv_msg+0xc00/0x12c0 net/netfilter/nfnetlink.c:302
 netlink_rcv_skb+0x232/0x4b0 net/netlink/af_netlink.c:2565
 nfnetlink_rcv+0x2c0/0x27b0 net/netfilter/nfnetlink.c:669
 netlink_unicast_kernel net/netlink/af_netlink.c:1314 [inline]
 netlink_unicast+0x80f/0x9b0 net/netlink/af_netlink.c:1340
 netlink_sendmsg+0x813/0xb40 net/netlink/af_netlink.c:1890
 sock_sendmsg_nosec net/socket.c:727 [inline]
 __sock_sendmsg net/socket.c:742 [inline]
 ____sys_sendmsg+0x972/0x9f0 net/socket.c:2592
 ___sys_sendmsg+0x2a5/0x360 net/socket.c:2646
 __sys_sendmsg net/socket.c:2678 [inline]
 __do_sys_sendmsg net/socket.c:2683 [inline]
 __se_sys_sendmsg net/socket.c:2681 [inline]
 __x64_sys_sendmsg+0x1bd/0x2a0 net/socket.c:2681
 do_syscall_x64 arch/x86/entry/syscall_64.c:63 [inline]
 do_syscall_64+0x14d/0xf80 arch/x86/entry/syscall_64.c:94
 entry_SYSCALL_64_after_hwframe+0x77/0x7f

The buggy address belongs to the object at ffff8881753dc700
 which belongs to the cache skbuff_small_head of size 704
The buggy address is located 0 bytes inside of
 freed 704-byte region [ffff8881753dc700, ffff8881753dc9c0)

The buggy address belongs to the physical page:
page: refcount:0 mapcount:0 mapping:0000000000000000 index:0xffff8881753dfb80 pfn:0x1753dc
head: order:2 mapcount:0 entire_mapcount:0 nr_pages_mapped:0 pincount:0
flags: 0x57ff00000000240(workingset|head|node=1|zone=2|lastcpupid=0x7ff)
page_type: f5(slab)
raw: 057ff00000000240 ffff888160419140 ffffea0005d40010 ffffea0006e4bb10
raw: ffff8881753dfb80 000000080012000f 00000000f5000000 0000000000000000
head: 057ff00000000240 ffff888160419140 ffffea0005d40010 ffffea0006e4bb10
head: ffff8881753dfb80 000000080012000f 00000000f5000000 0000000000000000
head: 057ff00000000002 ffffffffffffff01 00000000ffffffff 00000000ffffffff
head: ffffffffffffffff 0000000000000000 00000000ffffffff 0000000000000004
page dumped because: kasan: bad access detected
page_owner tracks the page as allocated
page last allocated via order 2, migratetype Unmovable, gfp_mask 0xd20c0(__GFP_IO|__GFP_FS|__GFP_NOWARN|__GFP_NORETRY|__GFP_COMP|__GFP_NOMEMALLOC), pid 5839, tgid 5839 (syz-executor), ts 58323168360, free_ts 35463810625
 set_page_owner include/linux/page_owner.h:32 [inline]
 post_alloc_hook+0x231/0x280 mm/page_alloc.c:1868
 prep_new_page mm/page_alloc.c:1876 [inline]
 get_page_from_freelist+0x24ba/0x2540 mm/page_alloc.c:3956
 __alloc_frozen_pages_noprof+0x18d/0x380 mm/page_alloc.c:5236
 alloc_slab_page mm/slub.c:3292 [inline]
 allocate_slab+0x77/0x660 mm/slub.c:3481
 new_slab mm/slub.c:3539 [inline]
 refill_objects+0x331/0x3c0 mm/slub.c:7175
 refill_sheaf mm/slub.c:2812 [inline]
 __pcs_replace_empty_main+0x2e6/0x730 mm/slub.c:4615
 alloc_from_pcs mm/slub.c:4717 [inline]
 slab_alloc_node mm/slub.c:4851 [inline]
 kmem_cache_alloc_node_noprof+0x441/0x690 mm/slub.c:4918
 kmalloc_reserve net/core/skbuff.c:613 [inline]
 __alloc_skb+0x27d/0x7d0 net/core/skbuff.c:713
 alloc_skb include/linux/skbuff.h:1383 [inline]
 nlmsg_new include/net/netlink.h:1055 [inline]
 inet6_netconf_notify_devconf+0x10f/0x1d0 net/ipv6/addrconf.c:592
 __addrconf_sysctl_register+0x45a/0x4d0 net/ipv6/addrconf.c:7338
 addrconf_sysctl_register+0x168/0x1c0 net/ipv6/addrconf.c:7375
 ipv6_add_dev+0xd26/0x13a0 net/ipv6/addrconf.c:459
 addrconf_notify+0x771/0x1050 net/ipv6/addrconf.c:3654
 notifier_call_chain+0x1be/0x400 kernel/notifier.c:85
 call_netdevice_notifiers_extack net/core/dev.c:2287 [inline]
 call_netdevice_notifiers net/core/dev.c:2301 [inline]
 register_netdevice+0x173a/0x1cf0 net/core/dev.c:11462
 register_netdev+0x40/0x60 net/core/dev.c:11540
page last free pid 5256 tgid 5256 stack trace:
 reset_page_owner include/linux/page_owner.h:25 [inline]
 __free_pages_prepare mm/page_alloc.c:1412 [inline]
 __free_frozen_pages+0xbc7/0xd30 mm/page_alloc.c:2953
 __slab_free+0x263/0x2b0 mm/slub.c:5573
 qlink_free mm/kasan/quarantine.c:163 [inline]
 qlist_free_all+0x99/0x100 mm/kasan/quarantine.c:179
 kasan_quarantine_reduce+0x148/0x160 mm/kasan/quarantine.c:286
 __kasan_slab_alloc+0x22/0x80 mm/kasan/common.c:350
 kasan_slab_alloc include/linux/kasan.h:253 [inline]
 slab_post_alloc_hook mm/slub.c:4538 [inline]
 slab_alloc_node mm/slub.c:4866 [inline]
 kmem_cache_alloc_node_noprof+0x384/0x690 mm/slub.c:4918
 __alloc_skb+0x1d0/0x7d0 net/core/skbuff.c:702
 netlink_sendmsg+0x5d4/0xb40 net/netlink/af_netlink.c:1865
 sock_sendmsg_nosec net/socket.c:727 [inline]
 __sock_sendmsg net/socket.c:742 [inline]
 ____sys_sendmsg+0x972/0x9f0 net/socket.c:2592
 ___sys_sendmsg+0x2a5/0x360 net/socket.c:2646
 __sys_sendmsg net/socket.c:2678 [inline]
 __do_sys_sendmsg net/socket.c:2683 [inline]
 __se_sys_sendmsg net/socket.c:2681 [inline]
 __x64_sys_sendmsg+0x1bd/0x2a0 net/socket.c:2681
 do_syscall_x64 arch/x86/entry/syscall_64.c:63 [inline]
 do_syscall_64+0x14d/0xf80 arch/x86/entry/syscall_64.c:94
 entry_SYSCALL_64_after_hwframe+0x77/0x7f

Memory state around the buggy address:
 ffff8881753dc600: fb fb fb fb fb fb fb fb fc fc fc fc fc fc fc fc
 ffff8881753dc680: fc fc fc fc fc fc fc fc fc fc fc fc fc fc fc fc
>ffff8881753dc700: fa fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb
                   ^
 ffff8881753dc780: fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb
 ffff8881753dc800: fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb
==================================================================


***

KASAN: slab-use-after-free Read in rdma_nl_rcv

tree:      torvalds
URL:       https://kernel.googlesource.com/pub/scm/linux/kernel/git/torvalds/linux
base:      0b5e8d7999076ac3c490fc18376a404e2626abff
arch:      amd64
compiler:  Debian clang version 21.1.8 (++20251221033036+2078da43e25a-1~exp1~20251221153213.50), Debian LLD 21.1.8
config:    https://ci.syzbot.org/builds/cb46a152-33c1-4b5e-bb75-bab2ecb45113/config
syz repro: https://ci.syzbot.org/findings/5022ea7e-727a-4c37-8ae5-0c7f5d43822c/syz_repro

==================================================================
BUG: KASAN: slab-use-after-free in rdma_nl_rcv_skb drivers/infiniband/core/netlink.c:248 [inline]
BUG: KASAN: slab-use-after-free in rdma_nl_rcv+0x867/0xa10 drivers/infiniband/core/netlink.c:259
Read of size 4 at addr ffff8881a4036a00 by task syz.1.18/5983

CPU: 1 UID: 0 PID: 5983 Comm: syz.1.18 Not tainted syzkaller #0 PREEMPT(full) 
Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS 1.16.2-debian-1.16.2-1 04/01/2014
Call Trace:
 <TASK>
 dump_stack_lvl+0xe8/0x150 lib/dump_stack.c:120
 print_address_description+0x55/0x1e0 mm/kasan/report.c:378
 print_report+0x58/0x70 mm/kasan/report.c:482
 kasan_report+0x117/0x150 mm/kasan/report.c:595
 rdma_nl_rcv_skb drivers/infiniband/core/netlink.c:248 [inline]
 rdma_nl_rcv+0x867/0xa10 drivers/infiniband/core/netlink.c:259
 netlink_unicast_kernel net/netlink/af_netlink.c:1314 [inline]
 netlink_unicast+0x80f/0x9b0 net/netlink/af_netlink.c:1340
 netlink_sendmsg+0x813/0xb40 net/netlink/af_netlink.c:1890
 sock_sendmsg_nosec net/socket.c:727 [inline]
 __sock_sendmsg net/socket.c:742 [inline]
 ____sys_sendmsg+0x972/0x9f0 net/socket.c:2592
 ___sys_sendmsg+0x2a5/0x360 net/socket.c:2646
 __sys_sendmsg net/socket.c:2678 [inline]
 __do_sys_sendmsg net/socket.c:2683 [inline]
 __se_sys_sendmsg net/socket.c:2681 [inline]
 __x64_sys_sendmsg+0x1bd/0x2a0 net/socket.c:2681
 do_syscall_x64 arch/x86/entry/syscall_64.c:63 [inline]
 do_syscall_64+0x14d/0xf80 arch/x86/entry/syscall_64.c:94
 entry_SYSCALL_64_after_hwframe+0x77/0x7f
RIP: 0033:0x7f737179c819
Code: ff c3 66 2e 0f 1f 84 00 00 00 00 00 0f 1f 44 00 00 48 89 f8 48 89 f7 48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 ff ff 73 01 c3 48 c7 c1 e8 ff ff ff f7 d8 64 89 01 48
RSP: 002b:00007f73725f1028 EFLAGS: 00000246 ORIG_RAX: 000000000000002e
RAX: ffffffffffffffda RBX: 00007f7371a16090 RCX: 00007f737179c819
RDX: 0000000020008000 RSI: 0000200000000000 RDI: 0000000000000003
RBP: 00007f7371832c91 R08: 0000000000000000 R09: 0000000000000000
R10: 0000000000000000 R11: 0000000000000246 R12: 0000000000000000
R13: 00007f7371a16128 R14: 00007f7371a16090 R15: 00007ffeff477318
 </TASK>

Allocated by task 5983:
 kasan_save_stack mm/kasan/common.c:57 [inline]
 kasan_save_track+0x3e/0x80 mm/kasan/common.c:78
 unpoison_slab_object mm/kasan/common.c:340 [inline]
 __kasan_slab_alloc+0x6c/0x80 mm/kasan/common.c:366
 kasan_slab_alloc include/linux/kasan.h:253 [inline]
 slab_post_alloc_hook mm/slub.c:4538 [inline]
 slab_alloc_node mm/slub.c:4866 [inline]
 kmem_cache_alloc_node_noprof+0x384/0x690 mm/slub.c:4918
 kmalloc_reserve net/core/skbuff.c:613 [inline]
 __alloc_skb+0x27d/0x7d0 net/core/skbuff.c:713
 netlink_sendmsg+0x5d4/0xb40 net/netlink/af_netlink.c:1865
 sock_sendmsg_nosec net/socket.c:727 [inline]
 __sock_sendmsg net/socket.c:742 [inline]
 ____sys_sendmsg+0x972/0x9f0 net/socket.c:2592
 ___sys_sendmsg+0x2a5/0x360 net/socket.c:2646
 __sys_sendmsg net/socket.c:2678 [inline]
 __do_sys_sendmsg net/socket.c:2683 [inline]
 __se_sys_sendmsg net/socket.c:2681 [inline]
 __x64_sys_sendmsg+0x1bd/0x2a0 net/socket.c:2681
 do_syscall_x64 arch/x86/entry/syscall_64.c:63 [inline]
 do_syscall_64+0x14d/0xf80 arch/x86/entry/syscall_64.c:94
 entry_SYSCALL_64_after_hwframe+0x77/0x7f

Freed by task 5983:
 kasan_save_stack mm/kasan/common.c:57 [inline]
 kasan_save_track+0x3e/0x80 mm/kasan/common.c:78
 kasan_save_free_info+0x46/0x50 mm/kasan/generic.c:584
 poison_slab_object mm/kasan/common.c:253 [inline]
 __kasan_slab_free+0x5c/0x80 mm/kasan/common.c:285
 kasan_slab_free include/linux/kasan.h:235 [inline]
 slab_free_hook mm/slub.c:2685 [inline]
 slab_free mm/slub.c:6165 [inline]
 kmem_cache_free+0x189/0x630 mm/slub.c:6295
 skb_kfree_head net/core/skbuff.c:1087 [inline]
 skb_free_head net/core/skbuff.c:1101 [inline]
 skb_release_data+0x81c/0xa80 net/core/skbuff.c:1128
 skb_release_all net/core/skbuff.c:1203 [inline]
 __kfree_skb+0x5d/0x210 net/core/skbuff.c:1217
 netlink_dump+0xbe9/0xf40 net/netlink/af_netlink.c:2385
 __netlink_dump_start+0x5cb/0x7e0 net/netlink/af_netlink.c:2455
 netlink_dump_start include/linux/netlink.h:341 [inline]
 rdma_nl_rcv_msg drivers/infiniband/core/netlink.c:190 [inline]
 rdma_nl_rcv_skb drivers/infiniband/core/netlink.c:239 [inline]
 rdma_nl_rcv+0x78b/0xa10 drivers/infiniband/core/netlink.c:259
 netlink_unicast_kernel net/netlink/af_netlink.c:1314 [inline]
 netlink_unicast+0x80f/0x9b0 net/netlink/af_netlink.c:1340
 netlink_sendmsg+0x813/0xb40 net/netlink/af_netlink.c:1890
 sock_sendmsg_nosec net/socket.c:727 [inline]
 __sock_sendmsg net/socket.c:742 [inline]
 ____sys_sendmsg+0x972/0x9f0 net/socket.c:2592
 ___sys_sendmsg+0x2a5/0x360 net/socket.c:2646
 __sys_sendmsg net/socket.c:2678 [inline]
 __do_sys_sendmsg net/socket.c:2683 [inline]
 __se_sys_sendmsg net/socket.c:2681 [inline]
 __x64_sys_sendmsg+0x1bd/0x2a0 net/socket.c:2681
 do_syscall_x64 arch/x86/entry/syscall_64.c:63 [inline]
 do_syscall_64+0x14d/0xf80 arch/x86/entry/syscall_64.c:94
 entry_SYSCALL_64_after_hwframe+0x77/0x7f

The buggy address belongs to the object at ffff8881a4036a00
 which belongs to the cache skbuff_small_head of size 704
The buggy address is located 0 bytes inside of
 freed 704-byte region [ffff8881a4036a00, ffff8881a4036cc0)

The buggy address belongs to the physical page:
page: refcount:0 mapcount:0 mapping:0000000000000000 index:0x0 pfn:0x1a4034
head: order:2 mapcount:0 entire_mapcount:0 nr_pages_mapped:0 pincount:0
flags: 0x57ff00000000040(head|node=1|zone=2|lastcpupid=0x7ff)
page_type: f5(slab)
raw: 057ff00000000040 ffff888160416c80 dead000000000100 dead000000000122
raw: 0000000000000000 0000000800120012 00000000f5000000 0000000000000000
head: 057ff00000000040 ffff888160416c80 dead000000000100 dead000000000122
head: 0000000000000000 0000000800120012 00000000f5000000 0000000000000000
head: 057ff00000000002 ffffffffffffff01 00000000ffffffff 00000000ffffffff
head: ffffffffffffffff 0000000000000000 00000000ffffffff 0000000000000004
page dumped because: kasan: bad access detected
page_owner tracks the page as allocated
page last allocated via order 2, migratetype Unmovable, gfp_mask 0xd20c0(__GFP_IO|__GFP_FS|__GFP_NOWARN|__GFP_NORETRY|__GFP_COMP|__GFP_NOMEMALLOC), pid 5931, tgid 5931 (syz-executor), ts 61730251789, free_ts 58082311635
 set_page_owner include/linux/page_owner.h:32 [inline]
 post_alloc_hook+0x231/0x280 mm/page_alloc.c:1868
 prep_new_page mm/page_alloc.c:1876 [inline]
 get_page_from_freelist+0x24ba/0x2540 mm/page_alloc.c:3956
 __alloc_frozen_pages_noprof+0x18d/0x380 mm/page_alloc.c:5236
 alloc_slab_page mm/slub.c:3292 [inline]
 allocate_slab+0x77/0x660 mm/slub.c:3481
 new_slab mm/slub.c:3539 [inline]
 refill_objects+0x331/0x3c0 mm/slub.c:7175
 refill_sheaf mm/slub.c:2812 [inline]
 __pcs_replace_empty_main+0x2e6/0x730 mm/slub.c:4615
 alloc_from_pcs mm/slub.c:4717 [inline]
 slab_alloc_node mm/slub.c:4851 [inline]
 kmem_cache_alloc_node_noprof+0x441/0x690 mm/slub.c:4918
 kmalloc_reserve net/core/skbuff.c:613 [inline]
 __alloc_skb+0x27d/0x7d0 net/core/skbuff.c:713
 alloc_skb include/linux/skbuff.h:1383 [inline]
 nlmsg_new include/net/netlink.h:1055 [inline]
 netlink_ack+0x146/0xa50 net/netlink/af_netlink.c:2502
 netlink_rcv_skb+0x2b6/0x4b0 net/netlink/af_netlink.c:2571
 netlink_unicast_kernel net/netlink/af_netlink.c:1314 [inline]
 netlink_unicast+0x80f/0x9b0 net/netlink/af_netlink.c:1340
 netlink_sendmsg+0x813/0xb40 net/netlink/af_netlink.c:1890
 sock_sendmsg_nosec net/socket.c:727 [inline]
 __sock_sendmsg net/socket.c:742 [inline]
 __sys_sendto+0x672/0x710 net/socket.c:2206
 __do_sys_sendto net/socket.c:2213 [inline]
 __se_sys_sendto net/socket.c:2209 [inline]
 __x64_sys_sendto+0xde/0x100 net/socket.c:2209
 do_syscall_x64 arch/x86/entry/syscall_64.c:63 [inline]
 do_syscall_64+0x14d/0xf80 arch/x86/entry/syscall_64.c:94
 entry_SYSCALL_64_after_hwframe+0x77/0x7f
page last free pid 5865 tgid 5865 stack trace:
 reset_page_owner include/linux/page_owner.h:25 [inline]
 __free_pages_prepare mm/page_alloc.c:1412 [inline]
 __free_frozen_pages+0xbc7/0xd30 mm/page_alloc.c:2953
 vfree+0x1d1/0x2f0 mm/vmalloc.c:3472
 kcov_put kernel/kcov.c:442 [inline]
 kcov_close+0x28/0x50 kernel/kcov.c:543
 __fput+0x44f/0xa70 fs/file_table.c:469
 task_work_run+0x1d9/0x270 kernel/task_work.c:233
 exit_task_work include/linux/task_work.h:40 [inline]
 do_exit+0x70f/0x22c0 kernel/exit.c:976
 do_group_exit+0x21b/0x2d0 kernel/exit.c:1118
 get_signal+0x1284/0x1330 kernel/signal.c:3034
 arch_do_signal_or_restart+0xbc/0x830 arch/x86/kernel/signal.c:337
 __exit_to_user_mode_loop kernel/entry/common.c:64 [inline]
 exit_to_user_mode_loop+0x86/0x480 kernel/entry/common.c:98
 __exit_to_user_mode_prepare include/linux/irq-entry-common.h:226 [inline]
 syscall_exit_to_user_mode_prepare include/linux/irq-entry-common.h:256 [inline]
 syscall_exit_to_user_mode include/linux/entry-common.h:325 [inline]
 do_syscall_64+0x32d/0xf80 arch/x86/entry/syscall_64.c:100
 entry_SYSCALL_64_after_hwframe+0x77/0x7f

Memory state around the buggy address:
 ffff8881a4036900: fc fc fc fc fc fc fc fc fc fc fc fc fc fc fc fc
 ffff8881a4036980: fc fc fc fc fc fc fc fc fc fc fc fc fc fc fc fc
>ffff8881a4036a00: fa fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb
                   ^
 ffff8881a4036a80: fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb
 ffff8881a4036b00: fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb
==================================================================


***

KASAN: slab-use-after-free Write in genl_done

tree:      torvalds
URL:       https://kernel.googlesource.com/pub/scm/linux/kernel/git/torvalds/linux
base:      0b5e8d7999076ac3c490fc18376a404e2626abff
arch:      amd64
compiler:  Debian clang version 21.1.8 (++20251221033036+2078da43e25a-1~exp1~20251221153213.50), Debian LLD 21.1.8
config:    https://ci.syzbot.org/builds/cb46a152-33c1-4b5e-bb75-bab2ecb45113/config
syz repro: https://ci.syzbot.org/findings/5600aed0-e730-40d2-943c-84f525e427c6/syz_repro

==================================================================
BUG: KASAN: slab-use-after-free in genl_done+0x76/0x220 net/netlink/genetlink.c:1038
Write of size 8 at addr ffff88811b796788 by task syz.0.34/6007

CPU: 0 UID: 0 PID: 6007 Comm: syz.0.34 Not tainted syzkaller #0 PREEMPT(full) 
Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS 1.16.2-debian-1.16.2-1 04/01/2014
Call Trace:
 <TASK>
 dump_stack_lvl+0xe8/0x150 lib/dump_stack.c:120
 print_address_description+0x55/0x1e0 mm/kasan/report.c:378
 print_report+0x58/0x70 mm/kasan/report.c:482
 kasan_report+0x117/0x150 mm/kasan/report.c:595
 genl_done+0x76/0x220 net/netlink/genetlink.c:1038
 netlink_dump_cleanup+0x99/0x120 net/netlink/af_netlink.c:2259
 netlink_dump+0xbe9/0xf40 net/netlink/af_netlink.c:2385
 __netlink_dump_start+0x5cb/0x7e0 net/netlink/af_netlink.c:2455
 genl_family_rcv_msg_dumpit+0x213/0x310 net/netlink/genetlink.c:1075
 genl_family_rcv_msg net/netlink/genetlink.c:1191 [inline]
 genl_rcv_msg+0x5e8/0x7a0 net/netlink/genetlink.c:1209
 netlink_rcv_skb+0x232/0x4b0 net/netlink/af_netlink.c:2565
 genl_rcv+0x28/0x40 net/netlink/genetlink.c:1218
 netlink_unicast_kernel net/netlink/af_netlink.c:1314 [inline]
 netlink_unicast+0x80f/0x9b0 net/netlink/af_netlink.c:1340
 netlink_sendmsg+0x813/0xb40 net/netlink/af_netlink.c:1890
 sock_sendmsg_nosec net/socket.c:727 [inline]
 __sock_sendmsg net/socket.c:742 [inline]
 ____sys_sendmsg+0x972/0x9f0 net/socket.c:2592
 ___sys_sendmsg+0x2a5/0x360 net/socket.c:2646
 __sys_sendmsg net/socket.c:2678 [inline]
 __do_sys_sendmsg net/socket.c:2683 [inline]
 __se_sys_sendmsg net/socket.c:2681 [inline]
 __x64_sys_sendmsg+0x1bd/0x2a0 net/socket.c:2681
 do_syscall_x64 arch/x86/entry/syscall_64.c:63 [inline]
 do_syscall_64+0x14d/0xf80 arch/x86/entry/syscall_64.c:94
 entry_SYSCALL_64_after_hwframe+0x77/0x7f
RIP: 0033:0x7fe33999c819
Code: ff c3 66 2e 0f 1f 84 00 00 00 00 00 0f 1f 44 00 00 48 89 f8 48 89 f7 48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 ff ff 73 01 c3 48 c7 c1 e8 ff ff ff f7 d8 64 89 01 48
RSP: 002b:00007fe33a8da028 EFLAGS: 00000246 ORIG_RAX: 000000000000002e
RAX: ffffffffffffffda RBX: 00007fe339c16090 RCX: 00007fe33999c819
RDX: 0000000000000000 RSI: 0000200000000040 RDI: 0000000000000004
RBP: 00007fe339a32c91 R08: 0000000000000000 R09: 0000000000000000
R10: 0000000000000000 R11: 0000000000000246 R12: 0000000000000000
R13: 00007fe339c16128 R14: 00007fe339c16090 R15: 00007ffe15e728b8
 </TASK>

Allocated by task 6007:
 kasan_save_stack mm/kasan/common.c:57 [inline]
 kasan_save_track+0x3e/0x80 mm/kasan/common.c:78
 poison_kmalloc_redzone mm/kasan/common.c:398 [inline]
 __kasan_kmalloc+0x93/0xb0 mm/kasan/common.c:415
 kasan_kmalloc include/linux/kasan.h:263 [inline]
 __kmalloc_cache_noprof+0x31c/0x660 mm/slub.c:5380
 kmalloc_noprof include/linux/slab.h:950 [inline]
 genl_dumpit_info_alloc net/netlink/genetlink.c:915 [inline]
 genl_start+0x1c9/0x6c0 net/netlink/genetlink.c:985
 __netlink_dump_start+0x469/0x7e0 net/netlink/af_netlink.c:2446
 genl_family_rcv_msg_dumpit+0x213/0x310 net/netlink/genetlink.c:1075
 genl_family_rcv_msg net/netlink/genetlink.c:1191 [inline]
 genl_rcv_msg+0x5e8/0x7a0 net/netlink/genetlink.c:1209
 netlink_rcv_skb+0x232/0x4b0 net/netlink/af_netlink.c:2565
 genl_rcv+0x28/0x40 net/netlink/genetlink.c:1218
 netlink_unicast_kernel net/netlink/af_netlink.c:1314 [inline]
 netlink_unicast+0x80f/0x9b0 net/netlink/af_netlink.c:1340
 netlink_sendmsg+0x813/0xb40 net/netlink/af_netlink.c:1890
 sock_sendmsg_nosec net/socket.c:727 [inline]
 __sock_sendmsg net/socket.c:742 [inline]
 ____sys_sendmsg+0x972/0x9f0 net/socket.c:2592
 ___sys_sendmsg+0x2a5/0x360 net/socket.c:2646
 __sys_sendmsg net/socket.c:2678 [inline]
 __do_sys_sendmsg net/socket.c:2683 [inline]
 __se_sys_sendmsg net/socket.c:2681 [inline]
 __x64_sys_sendmsg+0x1bd/0x2a0 net/socket.c:2681
 do_syscall_x64 arch/x86/entry/syscall_64.c:63 [inline]
 do_syscall_64+0x14d/0xf80 arch/x86/entry/syscall_64.c:94
 entry_SYSCALL_64_after_hwframe+0x77/0x7f

Freed by task 6006:
 kasan_save_stack mm/kasan/common.c:57 [inline]
 kasan_save_track+0x3e/0x80 mm/kasan/common.c:78
 kasan_save_free_info+0x46/0x50 mm/kasan/generic.c:584
 poison_slab_object mm/kasan/common.c:253 [inline]
 __kasan_slab_free+0x5c/0x80 mm/kasan/common.c:285
 kasan_slab_free include/linux/kasan.h:235 [inline]
 slab_free_hook mm/slub.c:2685 [inline]
 slab_free mm/slub.c:6165 [inline]
 kfree+0x1c5/0x640 mm/slub.c:6483
 genl_dumpit_info_free net/netlink/genetlink.c:920 [inline]
 genl_done+0x1c8/0x220 net/netlink/genetlink.c:1046
 netlink_dump_cleanup+0x99/0x120 net/netlink/af_netlink.c:2259
 netlink_dump+0xbe9/0xf40 net/netlink/af_netlink.c:2385
 netlink_recvmsg+0x690/0xa50 net/netlink/af_netlink.c:1972
 sock_recvmsg_nosec net/socket.c:1078 [inline]
 sock_recvmsg+0x172/0x1b0 net/socket.c:1100
 sock_read_iter+0x251/0x320 net/socket.c:1170
 new_sync_read fs/read_write.c:493 [inline]
 vfs_read+0x582/0xa70 fs/read_write.c:574
 ksys_read+0x150/0x270 fs/read_write.c:717
 do_syscall_x64 arch/x86/entry/syscall_64.c:63 [inline]
 do_syscall_64+0x14d/0xf80 arch/x86/entry/syscall_64.c:94
 entry_SYSCALL_64_after_hwframe+0x77/0x7f

The buggy address belongs to the object at ffff88811b796700
 which belongs to the cache kmalloc-192 of size 192
The buggy address is located 136 bytes inside of
 freed 192-byte region [ffff88811b796700, ffff88811b7967c0)

The buggy address belongs to the physical page:
page: refcount:0 mapcount:0 mapping:0000000000000000 index:0x0 pfn:0x11b796
flags: 0x17ff00000000000(node=0|zone=2|lastcpupid=0x7ff)
page_type: f5(slab)
raw: 017ff00000000000 ffff8881000413c0 dead000000000100 dead000000000122
raw: 0000000000000000 0000000800100010 00000000f5000000 0000000000000000
page dumped because: kasan: bad access detected
page_owner tracks the page as allocated
page last allocated via order 0, migratetype Unmovable, gfp_mask 0xd2cc0(GFP_KERNEL|__GFP_NOWARN|__GFP_NORETRY|__GFP_COMP|__GFP_NOMEMALLOC), pid 5922, tgid 5922 (syz-executor), ts 64892204905, free_ts 61400269257
 set_page_owner include/linux/page_owner.h:32 [inline]
 post_alloc_hook+0x231/0x280 mm/page_alloc.c:1868
 prep_new_page mm/page_alloc.c:1876 [inline]
 get_page_from_freelist+0x24ba/0x2540 mm/page_alloc.c:3956
 __alloc_frozen_pages_noprof+0x18d/0x380 mm/page_alloc.c:5236
 alloc_slab_page mm/slub.c:3292 [inline]
 allocate_slab+0x77/0x660 mm/slub.c:3481
 new_slab mm/slub.c:3539 [inline]
 refill_objects+0x331/0x3c0 mm/slub.c:7175
 refill_sheaf mm/slub.c:2812 [inline]
 __pcs_replace_empty_main+0x2e6/0x730 mm/slub.c:4615
 alloc_from_pcs mm/slub.c:4717 [inline]
 slab_alloc_node mm/slub.c:4851 [inline]
 __do_kmalloc_node mm/slub.c:5259 [inline]
 __kmalloc_node_noprof+0x577/0x7c0 mm/slub.c:5266
 kmalloc_node_noprof include/linux/slab.h:1081 [inline]
 alloc_slab_obj_exts+0xbf/0x250 mm/slub.c:2167
 __memcg_slab_post_alloc_hook+0x5c4/0xe80 mm/memcontrol.c:3466
 memcg_slab_post_alloc_hook mm/slub.c:2457 [inline]
 slab_post_alloc_hook mm/slub.c:4549 [inline]
 slab_alloc_node mm/slub.c:4866 [inline]
 kmem_cache_alloc_noprof+0x347/0x650 mm/slub.c:4873
 vm_area_dup+0x2b/0x680 mm/vma_init.c:123
 dup_mmap+0x8b1/0x1d90 mm/mmap.c:1786
 dup_mm kernel/fork.c:1531 [inline]
 copy_mm+0x13b/0x4a0 kernel/fork.c:1583
 copy_process+0x18b6/0x3cd0 kernel/fork.c:2223
 kernel_clone+0x248/0x8e0 kernel/fork.c:2653
 __do_sys_clone kernel/fork.c:2794 [inline]
 __se_sys_clone kernel/fork.c:2778 [inline]
 __x64_sys_clone+0x1b6/0x230 kernel/fork.c:2778
page last free pid 10 tgid 10 stack trace:
 reset_page_owner include/linux/page_owner.h:25 [inline]
 __free_pages_prepare mm/page_alloc.c:1412 [inline]
 __free_frozen_pages+0xbc7/0xd30 mm/page_alloc.c:2953
 kasan_depopulate_vmalloc_pte+0x6d/0x90 mm/kasan/shadow.c:484
 apply_to_pte_range mm/memory.c:3322 [inline]
 apply_to_pmd_range mm/memory.c:3366 [inline]
 apply_to_pud_range mm/memory.c:3402 [inline]
 apply_to_p4d_range mm/memory.c:3438 [inline]
 __apply_to_page_range+0xbdc/0x1420 mm/memory.c:3474
 __kasan_release_vmalloc+0xa2/0xd0 mm/kasan/shadow.c:602
 kasan_release_vmalloc include/linux/kasan.h:593 [inline]
 kasan_release_vmalloc_node mm/vmalloc.c:2284 [inline]
 purge_vmap_node+0x220/0x960 mm/vmalloc.c:2306
 __purge_vmap_area_lazy+0x779/0xb70 mm/vmalloc.c:2396
 drain_vmap_area_work+0x27/0x40 mm/vmalloc.c:2430
 process_one_work kernel/workqueue.c:3276 [inline]
 process_scheduled_works+0xb6e/0x18c0 kernel/workqueue.c:3359
 worker_thread+0xa53/0xfc0 kernel/workqueue.c:3440
 kthread+0x388/0x470 kernel/kthread.c:436
 ret_from_fork+0x51e/0xb90 arch/x86/kernel/process.c:158
 ret_from_fork_asm+0x1a/0x30 arch/x86/entry/entry_64.S:245

Memory state around the buggy address:
 ffff88811b796680: fc fc fc fc fc fc fc fc fc fc fc fc fc fc fc fc
 ffff88811b796700: fa fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb
>ffff88811b796780: fb fb fb fb fb fb fb fb fc fc fc fc fc fc fc fc
                      ^
 ffff88811b796800: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
 ffff88811b796880: 00 00 00 00 00 fc fc fc fc fc fc fc fc fc fc fc
==================================================================


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
[davem@davemloft.net edumazet@google.com horms@kernel.org kees@kernel.org kuba@kernel.org kuniyu@google.com linux-kernel@vger.kernel.org michael.bommarito@gmail.com netdev@vger.kernel.org pabeni@redhat.com yangfeng@kylinos.cn]

If the report looks fine to you, reply with:
#syz upstream

If the report is a false positive, reply with
#syz invalid

