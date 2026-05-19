Received: from mail-ot1-f70.google.com (mail-ot1-f70.google.com [209.85.210.70])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 81C1039B4BB
	for <syzbot@lists.linux.dev>; Tue, 19 May 2026 06:59:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.70
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779173950; cv=none; b=j8rtLfJwxkVo7DcZa12qiXDAn4eRa/s9vDyPHrOOAUqOQUKOIDtllAdUrILCQLT7pO2p4ls1Lra1cjg3juokVUbGDvdvO6fRS8FslPOdJLQI+cEd4NTQY9STC0wOoZHX06F8qr+nSt7O2k3bEhmiMs9qxD7b+HPLsx+JmtA38No=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779173950; c=relaxed/simple;
	bh=anN+Af2Qdv6XQQJeUO41bBobEDhLGw54jRcbaiv74Sg=;
	h=MIME-Version:Date:In-Reply-To:Message-ID:Subject:From:To:Cc:
	 Content-Type; b=uFumoY3YF4sDx8h7lb8g/ZExJqhRqgW4FywnD4oY56KiiXEoEnGAo7vD0Tq7nspbmOzbU2STEBl8wqrp52KF3bWsfSmsKO55wjmFk0wOkztoNp9gZCx9YKRRQADI4juZZUaAbQTaC/Tz2JfRp3F6wQ1T4Y4gaNi7Jh3dJyFMRxE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com; arc=none smtp.client-ip=209.85.210.70
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com
Received: by mail-ot1-f70.google.com with SMTP id 46e09a7af769-7e1f3a293aeso8959880a34.2
        for <syzbot@lists.linux.dev>; Mon, 18 May 2026 23:59:08 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1779173947; x=1779778747;
        h=cc:to:from:subject:message-id:in-reply-to:date:mime-version
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=XqbuYkXz1wPVC1VzsEsUFTd9IuGpg5JroJLLsJDPXQs=;
        b=W0tBW/BCn0jG1ojH+V6TLSYI9HThEVOOuske7+/Gf3UQGAg+MTbNObw0mK84vO7O2i
         nAUBtFOx8mjrdNkjS4T6VcKz1jG09xhHE3XdWSn12iEHxEi8mjQqA6uL1eAnCjeMLlIr
         sv7O1BhvKC8/Dercrc218LIwrKD8Jwp3pP4l/oQqNTBaXlBVj9UrcsOdZVMWyxDM/cyW
         b40uS0+pULkLjDlv4n808diSDxcfzawVmONGz5jqORXe69flwXN4v6qBHaRHQwMSfwNS
         oyZ2Ck0c5dMkdtiwZJ9vsKFFcEFGwmvqe6rzQcqJ4bHhCEXakFQamHFNo7UIvmcxuQBw
         JU6Q==
X-Gm-Message-State: AOJu0Yy9Ox6eo727+DvuEB5yHdZ9sIjskwz1eUEn3GmAEN3HNPZiohkL
	XBigfTlePk6Q3lwrXMvQhNjxmRs3tkwvSu5oKcSfzP/pu54tBPJirWPOnFsOaidRXVDemUJ76Np
	WbgdEN/h+e4hCUHfjpQAaEMh1yO0WvaKZ3gxmkShaWYYPR/uKnvLmqbaxObg=
Precedence: bulk
X-Mailing-List: syzbot@lists.linux.dev
List-Id: <syzbot.lists.linux.dev>
List-Subscribe: <mailto:syzbot+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:syzbot+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Received: by 2002:a05:6820:a04:b0:69b:922f:cad0 with SMTP id
 006d021491bc7-69c9c00d56bmr11071999eaf.57.1779173947517; Mon, 18 May 2026
 23:59:07 -0700 (PDT)
Date: Mon, 18 May 2026 23:59:07 -0700
In-Reply-To: <20260518165237.2084042-1-jkoolstra@xs4all.nl>
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <6a0c0a3b.050a0220.188d2a.0003.GAE@google.com>
Subject: [syzbot ci] Re: vfs: add O_CREAT|O_DIRECTORY to open*(2)
From: syzbot ci <syzbot+ci8ee793bb5ffded2a@syzkaller.appspotmail.com>
To: brauner@kernel.org, cmirabil@redhat.com, cyphar@cyphar.com, jack@suse.cz, 
	jkoolstra@xs4all.nl, jori.koolstra@gmail.com, linux-fsdevel@vger.kernel.org, 
	linux-kernel@vger.kernel.org, viro@zeniv.linux.org.uk
Cc: syzbot@lists.linux.dev, syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"

syzbot ci has tested the following series

[v4] vfs: add O_CREAT|O_DIRECTORY to open*(2)
https://lore.kernel.org/all/20260518165237.2084042-1-jkoolstra@xs4all.nl
* [RFC PATCH v4 1/2] vfs: add O_CREAT|O_DIRECTORY to open*(2)
* [RFC PATCH v4 2/2] selftest: add tests for open*(O_CREAT|O_DIRECTORY)

and found the following issues:
* KASAN: slab-out-of-bounds Read in ovl_dir_release
* general protection fault in path_openat

Full report is available here:
https://ci.syzbot.org/series/0d511b6b-6434-45cd-bbf3-51fe9d916e99

***

KASAN: slab-out-of-bounds Read in ovl_dir_release

tree:      torvalds
URL:       https://kernel.googlesource.com/pub/scm/linux/kernel/git/torvalds/linux
base:      5200f5f493f79f14bbdc349e402a40dfb32f23c8
arch:      amd64
compiler:  Debian clang version 21.1.8 (++20251221033036+2078da43e25a-1~exp1~20251221153213.50), Debian LLD 21.1.8
config:    https://ci.syzbot.org/builds/024b677f-50e7-4ef9-ae98-2652f5098bfd/config
syz repro: https://ci.syzbot.org/findings/a7087360-137c-41f5-ae13-db4d551fe142/syz_repro

==================================================================
BUG: KASAN: slab-out-of-bounds in ovl_dir_release+0x228/0x2a0 fs/overlayfs/readdir.c:1033
Read of size 8 at addr ffff88816cd2c818 by task syz.0.17/5813

CPU: 0 UID: 0 PID: 5813 Comm: syz.0.17 Not tainted syzkaller #0 PREEMPT(full) 
Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS 1.16.2-debian-1.16.2-1 04/01/2014
Call Trace:
 <TASK>
 dump_stack_lvl+0xe8/0x150 lib/dump_stack.c:120
 print_address_description+0x55/0x1e0 mm/kasan/report.c:378
 print_report+0x58/0x70 mm/kasan/report.c:482
 kasan_report+0x117/0x150 mm/kasan/report.c:595
 ovl_dir_release+0x228/0x2a0 fs/overlayfs/readdir.c:1033
 __fput+0x44f/0xa60 fs/file_table.c:510
 task_work_run+0x1d9/0x270 kernel/task_work.c:233
 resume_user_mode_work include/linux/resume_user_mode.h:50 [inline]
 __exit_to_user_mode_loop kernel/entry/common.c:67 [inline]
 exit_to_user_mode_loop+0xf3/0x4d0 kernel/entry/common.c:98
 __exit_to_user_mode_prepare include/linux/irq-entry-common.h:207 [inline]
 syscall_exit_to_user_mode_prepare include/linux/irq-entry-common.h:230 [inline]
 syscall_exit_to_user_mode include/linux/entry-common.h:318 [inline]
 do_syscall_64+0x33e/0xf80 arch/x86/entry/syscall_64.c:100
 entry_SYSCALL_64_after_hwframe+0x77/0x7f
RIP: 0033:0x7fe1a159ce59
Code: ff c3 66 2e 0f 1f 84 00 00 00 00 00 0f 1f 44 00 00 48 89 f8 48 89 f7 48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 ff ff 73 01 c3 48 c7 c1 e8 ff ff ff f7 d8 64 89 01 48
RSP: 002b:00007ffe25af07f8 EFLAGS: 00000246 ORIG_RAX: 00000000000001b4
RAX: 0000000000000000 RBX: 00007ffe25af08e0 RCX: 00007fe1a159ce59
RDX: 0000000000000000 RSI: 000000000000001e RDI: 0000000000000003
RBP: 0000000000012e15 R08: 0000000000000001 R09: 0000000000000000
R10: 0000001b32a20000 R11: 0000000000000246 R12: 00007ffe25af0920
R13: 00007fe1a1815fac R14: 0000000000012e53 R15: 00007fe1a1815fa0
 </TASK>

Allocated by task 5814:
 kasan_save_stack mm/kasan/common.c:57 [inline]
 kasan_save_track+0x3e/0x80 mm/kasan/common.c:78
 poison_kmalloc_redzone mm/kasan/common.c:398 [inline]
 __kasan_kmalloc+0x93/0xb0 mm/kasan/common.c:415
 kasan_kmalloc include/linux/kasan.h:263 [inline]
 __kmalloc_cache_noprof+0x31c/0x660 mm/slub.c:5419
 kmalloc_noprof include/linux/slab.h:950 [inline]
 kzalloc_noprof include/linux/slab.h:1188 [inline]
 ovl_file_alloc+0x4f/0x90 fs/overlayfs/file.c:99
 ovl_create_tmpfile fs/overlayfs/dir.c:1399 [inline]
 ovl_tmpfile+0x3fc/0x7d0 fs/overlayfs/dir.c:1448
 vfs_tmpfile+0x3ff/0x890 fs/namei.c:4794
 do_tmpfile+0xd3/0x240 fs/namei.c:4859
 path_openat+0x33c7/0x3b40 fs/namei.c:4893
 do_file_open+0x23e/0x4a0 fs/namei.c:4931
 do_sys_openat2+0x113/0x200 fs/open.c:1367
 do_sys_open fs/open.c:1373 [inline]
 __do_sys_open fs/open.c:1381 [inline]
 __se_sys_open fs/open.c:1377 [inline]
 __x64_sys_open+0x11e/0x150 fs/open.c:1377
 do_syscall_x64 arch/x86/entry/syscall_64.c:63 [inline]
 do_syscall_64+0x15f/0xf80 arch/x86/entry/syscall_64.c:94
 entry_SYSCALL_64_after_hwframe+0x77/0x7f

The buggy address belongs to the object at ffff88816cd2c800
 which belongs to the cache kmalloc-16 of size 16
The buggy address is located 8 bytes to the right of
 allocated 16-byte region [ffff88816cd2c800, ffff88816cd2c810)

The buggy address belongs to the physical page:
page: refcount:0 mapcount:0 mapping:0000000000000000 index:0xffff88816cd2c840 pfn:0x16cd2c
flags: 0x57ff00000000200(workingset|node=1|zone=2|lastcpupid=0x7ff)
page_type: f5(slab)
raw: 057ff00000000200 ffff888100041640 ffff888160400408 ffff888160400408
raw: ffff88816cd2c840 0000000800800042 00000000f5000000 0000000000000000
page dumped because: kasan: bad access detected
page_owner tracks the page as allocated
page last allocated via order 0, migratetype Unmovable, gfp_mask 0x252800(GFP_NOWAIT|__GFP_NORETRY|__GFP_COMP|__GFP_THISNODE), pid 5741, tgid 5741 (syz-executor), ts 77437404410, free_ts 77431264562
 set_page_owner include/linux/page_owner.h:32 [inline]
 post_alloc_hook+0x231/0x280 mm/page_alloc.c:1858
 prep_new_page mm/page_alloc.c:1866 [inline]
 get_page_from_freelist+0x24ba/0x2540 mm/page_alloc.c:3946
 __alloc_frozen_pages_noprof+0x18d/0x380 mm/page_alloc.c:5226
 alloc_slab_page mm/slub.c:3278 [inline]
 allocate_slab+0x77/0x660 mm/slub.c:3467
 new_slab mm/slub.c:3525 [inline]
 ___slab_alloc+0x154/0x6c0 mm/slub.c:4444
 __slab_alloc_node mm/slub.c:4510 [inline]
 slab_alloc_node mm/slub.c:4886 [inline]
 __do_kmalloc_node mm/slub.c:5294 [inline]
 __kvmalloc_node_noprof+0x34d/0x8a0 mm/slub.c:6832
 xt_jumpstack_alloc net/netfilter/x_tables.c:1449 [inline]
 do_replace_table+0x191/0x620 net/netfilter/x_tables.c:1486
 xt_register_table+0x269/0x960 net/netfilter/x_tables.c:1596
 ip6t_register_table+0x16b/0x330 net/ipv6/netfilter/ip6_tables.c:1754
 ip6table_raw_table_init+0x54/0x80 net/ipv6/netfilter/ip6table_raw.c:48
 xt_find_table_lock+0x30c/0x3f0 net/netfilter/x_tables.c:1353
 xt_request_find_table_lock+0x26/0x100 net/netfilter/x_tables.c:1378
 get_info net/ipv6/netfilter/ip6_tables.c:979 [inline]
 do_ip6t_get_ctl+0x716/0x1230 net/ipv6/netfilter/ip6_tables.c:1668
 nf_getsockopt+0x26e/0x290 net/netfilter/nf_sockopt.c:116
 ipv6_getsockopt+0x1fd/0x2b0 net/ipv6/ipv6_sockglue.c:1464
 do_sock_getsockopt+0x51d/0x7e0 net/socket.c:2487
page last free pid 15 tgid 15 stack trace:
 reset_page_owner include/linux/page_owner.h:25 [inline]
 __free_pages_prepare mm/page_alloc.c:1402 [inline]
 __free_frozen_pages+0xbc7/0xd30 mm/page_alloc.c:2943
 rcu_do_batch kernel/rcu/tree.c:2617 [inline]
 rcu_core+0x7cd/0x1070 kernel/rcu/tree.c:2869
 handle_softirqs+0x22a/0x840 kernel/softirq.c:622
 run_ksoftirqd+0x36/0x60 kernel/softirq.c:1076
 smpboot_thread_fn+0x541/0xa50 kernel/smpboot.c:160
 kthread+0x389/0x470 kernel/kthread.c:436
 ret_from_fork+0x514/0xb70 arch/x86/kernel/process.c:158
 ret_from_fork_asm+0x1a/0x30 arch/x86/entry/entry_64.S:245

Memory state around the buggy address:
 ffff88816cd2c700: fc fc fc fc fc fc fc fc fc fc fc fc fc fc fc fc
 ffff88816cd2c780: fc fc fc fc fc fc fc fc fc fc fc fc fc fc fc fc
>ffff88816cd2c800: 00 00 fc fc 00 00 fc fc fc fc fc fc fc fc fc fc
                            ^
 ffff88816cd2c880: fc fc fc fc fc fc fc fc fc fc fc fc fc fc fc fc
 ffff88816cd2c900: fc fc fc fc fc fc fc fc fc fc fc fc fc fc fc fc
==================================================================


***

general protection fault in path_openat

tree:      torvalds
URL:       https://kernel.googlesource.com/pub/scm/linux/kernel/git/torvalds/linux
base:      5200f5f493f79f14bbdc349e402a40dfb32f23c8
arch:      amd64
compiler:  Debian clang version 21.1.8 (++20251221033036+2078da43e25a-1~exp1~20251221153213.50), Debian LLD 21.1.8
config:    https://ci.syzbot.org/builds/024b677f-50e7-4ef9-ae98-2652f5098bfd/config
syz repro: https://ci.syzbot.org/findings/4b3b0fe3-064c-43e2-b887-b3a52d87a16a/syz_repro

BTRFS info (device loop1): enabling ssd optimizations
BTRFS info (device loop1): turning on async discard
BTRFS info (device loop1): enabling free space tree
BTRFS info (device loop1): use zstd compression, level 3
Oops: general protection fault, probably for non-canonical address 0xdffffc0000000000: 0000 [#1] SMP KASAN PTI
KASAN: null-ptr-deref in range [0x0000000000000000-0x0000000000000007]
CPU: 1 UID: 0 PID: 5849 Comm: syz.1.18 Not tainted syzkaller #0 PREEMPT(full) 
Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS 1.16.2-debian-1.16.2-1 04/01/2014
RIP: 0010:__d_entry_type include/linux/dcache.h:429 [inline]
RIP: 0010:d_can_lookup include/linux/dcache.h:444 [inline]
RIP: 0010:do_open fs/namei.c:4726 [inline]
RIP: 0010:path_openat+0x2e66/0x3b40 fs/namei.c:4902
Code: e8 8f 49 7f ff eb 62 48 8b 44 24 78 42 80 3c 20 00 48 8b 5c 24 68 74 08 48 89 df e8 44 87 ea ff 4c 8b 3b 4c 89 f8 48 c1 e8 03 <42> 0f b6 04 20 84 c0 0f 85 cb 09 00 00 41 bc 00 00 38 00 45 23 27
RSP: 0018:ffffc9000405f960 EFLAGS: 00010246
RAX: 0000000000000000 RBX: ffffc9000405fc28 RCX: 0000000000000000
RDX: ffff88810fe50000 RSI: 0000000000000002 RDI: 0000000000000000
RBP: ffffc9000405fbb0 R08: ffff8881b949469b R09: 1ffff110372928d3
R10: dffffc0000000000 R11: ffffed10372928d4 R12: dffffc0000000000
R13: 1ffff1102eb65c88 R14: 000000000015d0c0 R15: 0000000000000001
FS:  00007f074937f6c0(0000) GS:ffff8882a928a000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 00000c2113360000 CR3: 0000000103f3a000 CR4: 00000000000006f0
Call Trace:
 <TASK>
 do_file_open+0x23e/0x4a0 fs/namei.c:4931
 do_sys_openat2+0x113/0x200 fs/open.c:1367
 do_sys_open fs/open.c:1373 [inline]
 __do_sys_openat fs/open.c:1389 [inline]
 __se_sys_openat fs/open.c:1384 [inline]
 __x64_sys_openat+0x138/0x170 fs/open.c:1384
 do_syscall_x64 arch/x86/entry/syscall_64.c:63 [inline]
 do_syscall_64+0x15f/0xf80 arch/x86/entry/syscall_64.c:94
 entry_SYSCALL_64_after_hwframe+0x77/0x7f
RIP: 0033:0x7f074859ce59
Code: ff c3 66 2e 0f 1f 84 00 00 00 00 00 0f 1f 44 00 00 48 89 f8 48 89 f7 48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 ff ff 73 01 c3 48 c7 c1 e8 ff ff ff f7 d8 64 89 01 48
RSP: 002b:00007f074937f028 EFLAGS: 00000246 ORIG_RAX: 0000000000000101
RAX: ffffffffffffffda RBX: 00007f0748815fa0 RCX: 00007f074859ce59
RDX: 00000000001dd0c0 RSI: 0000200000000240 RDI: ffffffffffffff9c
RBP: 00007f0748632d6f R08: 0000000000000000 R09: 0000000000000000
R10: 0000000000000000 R11: 0000000000000246 R12: 0000000000000000
R13: 00007f0748816038 R14: 00007f0748815fa0 R15: 00007fff34fee548
 </TASK>
Modules linked in:
---[ end trace 0000000000000000 ]---
RIP: 0010:__d_entry_type include/linux/dcache.h:429 [inline]
RIP: 0010:d_can_lookup include/linux/dcache.h:444 [inline]
RIP: 0010:do_open fs/namei.c:4726 [inline]
RIP: 0010:path_openat+0x2e66/0x3b40 fs/namei.c:4902
Code: e8 8f 49 7f ff eb 62 48 8b 44 24 78 42 80 3c 20 00 48 8b 5c 24 68 74 08 48 89 df e8 44 87 ea ff 4c 8b 3b 4c 89 f8 48 c1 e8 03 <42> 0f b6 04 20 84 c0 0f 85 cb 09 00 00 41 bc 00 00 38 00 45 23 27
RSP: 0018:ffffc9000405f960 EFLAGS: 00010246
RAX: 0000000000000000 RBX: ffffc9000405fc28 RCX: 0000000000000000
RDX: ffff88810fe50000 RSI: 0000000000000002 RDI: 0000000000000000
RBP: ffffc9000405fbb0 R08: ffff8881b949469b R09: 1ffff110372928d3
R10: dffffc0000000000 R11: ffffed10372928d4 R12: dffffc0000000000
R13: 1ffff1102eb65c88 R14: 000000000015d0c0 R15: 0000000000000001
FS:  00007f074937f6c0(0000) GS:ffff8882a928a000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 00007f1c7a2f73b0 CR3: 0000000103f3a000 CR4: 00000000000006f0
----------------
Code disassembly (best guess):
   0:	e8 8f 49 7f ff       	call   0xff7f4994
   5:	eb 62                	jmp    0x69
   7:	48 8b 44 24 78       	mov    0x78(%rsp),%rax
   c:	42 80 3c 20 00       	cmpb   $0x0,(%rax,%r12,1)
  11:	48 8b 5c 24 68       	mov    0x68(%rsp),%rbx
  16:	74 08                	je     0x20
  18:	48 89 df             	mov    %rbx,%rdi
  1b:	e8 44 87 ea ff       	call   0xffea8764
  20:	4c 8b 3b             	mov    (%rbx),%r15
  23:	4c 89 f8             	mov    %r15,%rax
  26:	48 c1 e8 03          	shr    $0x3,%rax
* 2a:	42 0f b6 04 20       	movzbl (%rax,%r12,1),%eax <-- trapping instruction
  2f:	84 c0                	test   %al,%al
  31:	0f 85 cb 09 00 00    	jne    0xa02
  37:	41 bc 00 00 38 00    	mov    $0x380000,%r12d
  3d:	45 23 27             	and    (%r15),%r12d


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
