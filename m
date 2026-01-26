Received: from mail-oi1-f200.google.com (mail-oi1-f200.google.com [209.85.167.200])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A40EC334C23
	for <syzbot@lists.linux.dev>; Mon, 26 Jan 2026 12:09:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.167.200
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769429355; cv=none; b=GY1Tj9J4xEgZtVoCn7QeCf1EKlaNW35agR1ev9ZRS0kplaiFjl+Eu2wdgrOTkBkG+TNNtMZ8SpI9CUYBmRmP5kG/+8YjjrLztkt+B1880sJlKystC+gASVKc4BqsOWjkBYPN9it0t2j5fkTFnePbQb5qaxJN5PSYthP+FWel+P4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769429355; c=relaxed/simple;
	bh=8sVhi95iusNpdq7SuHzJH30Rj0RohTmyUdc7BKv9ehM=;
	h=MIME-Version:Date:In-Reply-To:Message-ID:Subject:From:To:Cc:
	 Content-Type; b=ZSngE1BufNUma3/FDJg5LIKcazJHOYJRvGU/mjGID51qjJ3F3yRLN3Gpz5KRLygjp4h36CPerf4w3WBNseorYUIuvW93ZctlobQGSr6fq1eZhe6r/O0av/YUoIUx82v4T93OC1FhbF3t8J27hh0NO6vQWuxkZwR3y0LiJtL7qQ8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com; arc=none smtp.client-ip=209.85.167.200
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com
Received: by mail-oi1-f200.google.com with SMTP id 5614622812f47-45c84574b41so4818896b6e.3
        for <syzbot@lists.linux.dev>; Mon, 26 Jan 2026 04:09:13 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1769429352; x=1770034152;
        h=cc:to:from:subject:message-id:in-reply-to:date:mime-version
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=fN3mzOANncLakW4602fzvUe0cqvv/BA4EDPzO+qp9G0=;
        b=UdXSoRg8DuYSNhKdoN/1EJwiI7DMoYpdgiNCBcSFEXKkma9KZ97v4d9q+4icMlkEkC
         KA3sS72yrk5WcTNyTx7BlQHaPQShwvzq290O9lzYndolJdHtAfjtI//1OpFAYgD5YBUy
         pytS0V8bPLAgAW/BBsPKY1hJxlWCkUvXo6MQnyahEOe9+qrxG73Tpakb54wKrRjEBxc7
         8IaNjGnwWsc6MGVlwt4rxwFhIbiiellUuoP59ZDWhxls2D+EOQnLzO+dgrAOp2KaOod7
         TnjKWvs63oueqbV08kCq3Ai5YauDT9zJ4wucaUY8f7zVmbSDEOq7VI1BK59HcAS+FHcw
         Jq7w==
X-Gm-Message-State: AOJu0YylqHGEq22iJWqBnIzQHtsKkT+aVFP1lwY3OkoShtvtr2zSid9r
	CZBShbMq+Qi2hwqt9+wuYKav1XfoGowq5xpdtacYnySlZGVESDP2U2j7VJHA8OVMkgj4S6QTWaZ
	V0mQdENm6zHdvuwnmbmEz0/JmW4S4RVm3SSX06T+utXoEraCLadUHFTlfP1w=
Precedence: bulk
X-Mailing-List: syzbot@lists.linux.dev
List-Id: <syzbot.lists.linux.dev>
List-Subscribe: <mailto:syzbot+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:syzbot+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Received: by 2002:a05:6820:448e:b0:662:c6ea:ceb0 with SMTP id
 006d021491bc7-662e03dcc93mr1438813eaf.26.1769429352208; Mon, 26 Jan 2026
 04:09:12 -0800 (PST)
Date: Mon, 26 Jan 2026 04:09:12 -0800
In-Reply-To: <20260126071359.2693214-1-kuniyu@google.com>
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <69775968.050a0220.226181.001c.GAE@google.com>
Subject: [syzbot ci] Re: nfc: nci: Fix race between rfkill and nci_unregister_device().
From: syzbot ci <syzbot+ci823f35d4b6c8165c@syzkaller.appspotmail.com>
To: davem@davemloft.net, edumazet@google.com, horms@kernel.org, ilane@ti.com, 
	kuba@kernel.org, kuni1840@gmail.com, kuniyu@google.com, 
	netdev@vger.kernel.org, pabeni@redhat.com, syzbot@syzkaller.appspotmail.com
Cc: syzbot@lists.linux.dev, syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"

syzbot ci has tested the following series

[v1] nfc: nci: Fix race between rfkill and nci_unregister_device().
https://lore.kernel.org/all/20260126071359.2693214-1-kuniyu@google.com
* [PATCH v1 net] nfc: nci: Fix race between rfkill and nci_unregister_device().

and found the following issue:
KASAN: slab-use-after-free Read in nci_unregister_device

Full report is available here:
https://ci.syzbot.org/series/1b1f8783-f1b1-4eaf-8140-aeb610bb4b90

***

KASAN: slab-use-after-free Read in nci_unregister_device

tree:      net
URL:       https://kernel.googlesource.com/pub/scm/linux/kernel/git/netdev/net.git
base:      1742272bd3fae6362301d0f11eb9db9030348afc
arch:      amd64
compiler:  Debian clang version 21.1.8 (++20251221033036+2078da43e25a-1~exp1~20251221153213.50), Debian LLD 21.1.8
config:    https://ci.syzbot.org/builds/f8117535-23ea-4dd0-8208-c2a71b5d6f69/config
C repro:   https://ci.syzbot.org/findings/0d078d52-d526-410a-b2a3-55b7b314bf59/c_repro
syz repro: https://ci.syzbot.org/findings/0d078d52-d526-410a-b2a3-55b7b314bf59/syz_repro

==================================================================
BUG: KASAN: slab-use-after-free in nci_unregister_device+0x123/0x230 net/nfc/nci/core.c:1320
Read of size 8 at addr ffff888113d56628 by task syz.0.17/5980

CPU: 1 UID: 0 PID: 5980 Comm: syz.0.17 Not tainted syzkaller #0 PREEMPT(full) 
Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS 1.16.2-debian-1.16.2-1 04/01/2014
Call Trace:
 <TASK>
 dump_stack_lvl+0xe8/0x150 lib/dump_stack.c:120
 print_address_description mm/kasan/report.c:378 [inline]
 print_report+0xba/0x230 mm/kasan/report.c:482
 kasan_report+0x117/0x150 mm/kasan/report.c:595
 nci_unregister_device+0x123/0x230 net/nfc/nci/core.c:1320
 virtual_ncidev_close+0x56/0x90 drivers/nfc/virtual_ncidev.c:168
 __fput+0x44f/0xa70 fs/file_table.c:468
 task_work_run+0x1d9/0x270 kernel/task_work.c:233
 resume_user_mode_work include/linux/resume_user_mode.h:50 [inline]
 __exit_to_user_mode_loop kernel/entry/common.c:44 [inline]
 exit_to_user_mode_loop+0xed/0x480 kernel/entry/common.c:75
 __exit_to_user_mode_prepare include/linux/irq-entry-common.h:226 [inline]
 syscall_exit_to_user_mode_prepare include/linux/irq-entry-common.h:256 [inline]
 syscall_exit_to_user_mode_work include/linux/entry-common.h:159 [inline]
 syscall_exit_to_user_mode include/linux/entry-common.h:194 [inline]
 do_syscall_64+0x2b7/0xf80 arch/x86/entry/syscall_64.c:100
 entry_SYSCALL_64_after_hwframe+0x77/0x7f
RIP: 0033:0x7f148199acb9
Code: ff c3 66 2e 0f 1f 84 00 00 00 00 00 0f 1f 44 00 00 48 89 f8 48 89 f7 48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 ff ff 73 01 c3 48 c7 c1 e8 ff ff ff f7 d8 64 89 01 48
RSP: 002b:00007fff4e2266c8 EFLAGS: 00000246 ORIG_RAX: 00000000000001b4
RAX: 0000000000000000 RBX: 00007f1481c17da0 RCX: 00007f148199acb9
RDX: 0000000000000000 RSI: 000000000000001e RDI: 0000000000000003
RBP: 00007f1481c17da0 R08: 0000000000000006 R09: 0000000000000000
R10: 00007f1481c17cb0 R11: 0000000000000246 R12: 0000000000012770
R13: 00007f1481c1609c R14: 00000000000124bb R15: 00007f1481c16090
 </TASK>

Allocated by task 13:
 kasan_save_stack mm/kasan/common.c:57 [inline]
 kasan_save_track+0x3e/0x80 mm/kasan/common.c:78
 poison_kmalloc_redzone mm/kasan/common.c:398 [inline]
 __kasan_kmalloc+0x93/0xb0 mm/kasan/common.c:415
 kasan_kmalloc include/linux/kasan.h:263 [inline]
 __do_kmalloc_node mm/slub.c:5657 [inline]
 __kmalloc_node_track_caller_noprof+0x558/0x7f0 mm/slub.c:5768
 alloc_dr drivers/base/devres.c:119 [inline]
 devm_kmalloc+0x7f/0x300 drivers/base/devres.c:864
 devm_kzalloc include/linux/device/devres.h:54 [inline]
 nci_core_conn_create_rsp_packet net/nfc/nci/rsp.c:282 [inline]
 nci_rsp_packet+0x894/0x3200 net/nfc/nci/rsp.c:384
 nci_rx_work+0x1f8/0x3f0 net/nfc/nci/core.c:1551
 process_one_work kernel/workqueue.c:3257 [inline]
 process_scheduled_works+0xaec/0x17a0 kernel/workqueue.c:3340
 worker_thread+0x89f/0xd90 kernel/workqueue.c:3421
 kthread+0x726/0x8b0 kernel/kthread.c:463
 ret_from_fork+0x51b/0xa40 arch/x86/kernel/process.c:158
 ret_from_fork_asm+0x1a/0x30 arch/x86/entry/entry_64.S:246

Freed by task 5980:
 kasan_save_stack mm/kasan/common.c:57 [inline]
 kasan_save_track+0x3e/0x80 mm/kasan/common.c:78
 kasan_save_free_info+0x46/0x50 mm/kasan/generic.c:584
 poison_slab_object mm/kasan/common.c:253 [inline]
 __kasan_slab_free+0x5c/0x80 mm/kasan/common.c:285
 kasan_slab_free include/linux/kasan.h:235 [inline]
 slab_free_hook mm/slub.c:2540 [inline]
 slab_free mm/slub.c:6674 [inline]
 kfree+0x1be/0x650 mm/slub.c:6882
 release_nodes drivers/base/devres.c:506 [inline]
 devres_release_all+0x1b2/0x240 drivers/base/devres.c:535
 device_del+0x736/0x8f0 drivers/base/core.c:3893
 nfc_unregister_device+0x19c/0x330 net/nfc/core.c:1188
 nci_unregister_device+0x42/0x230 net/nfc/nci/core.c:1306
 virtual_ncidev_close+0x56/0x90 drivers/nfc/virtual_ncidev.c:168
 __fput+0x44f/0xa70 fs/file_table.c:468
 task_work_run+0x1d9/0x270 kernel/task_work.c:233
 resume_user_mode_work include/linux/resume_user_mode.h:50 [inline]
 __exit_to_user_mode_loop kernel/entry/common.c:44 [inline]
 exit_to_user_mode_loop+0xed/0x480 kernel/entry/common.c:75
 __exit_to_user_mode_prepare include/linux/irq-entry-common.h:226 [inline]
 syscall_exit_to_user_mode_prepare include/linux/irq-entry-common.h:256 [inline]
 syscall_exit_to_user_mode_work include/linux/entry-common.h:159 [inline]
 syscall_exit_to_user_mode include/linux/entry-common.h:194 [inline]
 do_syscall_64+0x2b7/0xf80 arch/x86/entry/syscall_64.c:100
 entry_SYSCALL_64_after_hwframe+0x77/0x7f

The buggy address belongs to the object at ffff888113d56600
 which belongs to the cache kmalloc-128 of size 128
The buggy address is located 40 bytes inside of
 freed 128-byte region [ffff888113d56600, ffff888113d56680)

The buggy address belongs to the physical page:
page: refcount:0 mapcount:0 mapping:0000000000000000 index:0xffff888113d56900 pfn:0x113d56
flags: 0x17ff00000000200(workingset|node=0|zone=2|lastcpupid=0x7ff)
page_type: f5(slab)
raw: 017ff00000000200 ffff888100041a00 ffff888100040648 ffffea00044fbf90
raw: ffff888113d56900 000000000010000c 00000000f5000000 0000000000000000
page dumped because: kasan: bad access detected
page_owner tracks the page as allocated
page last allocated via order 0, migratetype Unmovable, gfp_mask 0x52cc0(GFP_KERNEL|__GFP_NOWARN|__GFP_NORETRY|__GFP_COMP), pid 5277, tgid 5277 (udevadm), ts 29935854573, free_ts 29929951093
 set_page_owner include/linux/page_owner.h:32 [inline]
 post_alloc_hook+0x228/0x280 mm/page_alloc.c:1884
 prep_new_page mm/page_alloc.c:1892 [inline]
 get_page_from_freelist+0x24dc/0x2580 mm/page_alloc.c:3945
 __alloc_frozen_pages_noprof+0x18d/0x380 mm/page_alloc.c:5240
 alloc_pages_mpol+0x232/0x4a0 mm/mempolicy.c:2486
 alloc_slab_page mm/slub.c:3075 [inline]
 allocate_slab+0x86/0x3a0 mm/slub.c:3248
 new_slab mm/slub.c:3302 [inline]
 ___slab_alloc+0xd82/0x1760 mm/slub.c:4656
 __slab_alloc+0x65/0x100 mm/slub.c:4779
 __slab_alloc_node mm/slub.c:4855 [inline]
 slab_alloc_node mm/slub.c:5251 [inline]
 __kmalloc_cache_noprof+0x40d/0x6e0 mm/slub.c:5775
 kmalloc_noprof include/linux/slab.h:957 [inline]
 kzalloc_noprof include/linux/slab.h:1094 [inline]
 kernfs_get_open_node fs/kernfs/file.c:543 [inline]
 kernfs_fop_open+0x7b5/0xca0 fs/kernfs/file.c:718
 do_dentry_open+0x7ce/0x1420 fs/open.c:962
 vfs_open+0x3b/0x340 fs/open.c:1094
 do_open fs/namei.c:4637 [inline]
 path_openat+0x3486/0x3e20 fs/namei.c:4796
 do_filp_open+0x22d/0x490 fs/namei.c:4823
 do_sys_openat2+0x12f/0x220 fs/open.c:1430
 do_sys_open fs/open.c:1436 [inline]
 __do_sys_openat fs/open.c:1452 [inline]
 __se_sys_openat fs/open.c:1447 [inline]
 __x64_sys_openat+0x138/0x170 fs/open.c:1447
 do_syscall_x64 arch/x86/entry/syscall_64.c:63 [inline]
 do_syscall_64+0xe2/0xf80 arch/x86/entry/syscall_64.c:94
page last free pid 5277 tgid 5277 stack trace:
 reset_page_owner include/linux/page_owner.h:25 [inline]
 free_pages_prepare mm/page_alloc.c:1433 [inline]
 __free_frozen_pages+0xbb0/0xd10 mm/page_alloc.c:2973
 __slab_free+0x2ce/0x320 mm/slub.c:6008
 qlink_free mm/kasan/quarantine.c:163 [inline]
 qlist_free_all+0x97/0x100 mm/kasan/quarantine.c:179
 kasan_quarantine_reduce+0x148/0x160 mm/kasan/quarantine.c:286
 __kasan_slab_alloc+0x22/0x80 mm/kasan/common.c:350
 kasan_slab_alloc include/linux/kasan.h:253 [inline]
 slab_post_alloc_hook mm/slub.c:4953 [inline]
 slab_alloc_node mm/slub.c:5263 [inline]
 __do_kmalloc_node mm/slub.c:5656 [inline]
 __kmalloc_noprof+0x3c2/0x7e0 mm/slub.c:5669
 kmalloc_noprof include/linux/slab.h:961 [inline]
 kernfs_fop_write_iter+0x158/0x540 fs/kernfs/file.c:329
 new_sync_write fs/read_write.c:593 [inline]
 vfs_write+0x61d/0xb90 fs/read_write.c:686
 ksys_write+0x150/0x270 fs/read_write.c:738
 do_syscall_x64 arch/x86/entry/syscall_64.c:63 [inline]
 do_syscall_64+0xe2/0xf80 arch/x86/entry/syscall_64.c:94
 entry_SYSCALL_64_after_hwframe+0x77/0x7f

Memory state around the buggy address:
 ffff888113d56500: fa fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb
 ffff888113d56580: fc fc fc fc fc fc fc fc fc fc fc fc fc fc fc fc
>ffff888113d56600: fa fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb
                                  ^
 ffff888113d56680: fc fc fc fc fc fc fc fc fc fc fc fc fc fc fc fc
 ffff888113d56700: 00 00 00 00 00 00 00 00 00 00 00 00 00 fc fc fc
==================================================================


***

If these findings have caused you to resend the series or submit a
separate fix, please add the following tag to your commit message:
  Tested-by: syzbot@syzkaller.appspotmail.com

---
This report is generated by a bot. It may contain errors.
syzbot ci engineers can be reached at syzkaller@googlegroups.com.
