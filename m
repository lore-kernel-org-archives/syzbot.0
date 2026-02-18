Received: from mail-oo1-f69.google.com (mail-oo1-f69.google.com [209.85.161.69])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2BF9E283FC5
	for <syzbot@lists.linux.dev>; Wed, 18 Feb 2026 03:13:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.161.69
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771384435; cv=none; b=Ely1DO2wQAaXnRSNmlGXj5Veaag45g80nEvVCFwHveLPqqmeyndoITU9Krtdmo/2Fod/iPjkrG7R93cLYmC1Mlan5MByn0u4tAz0Q22Nxp7yUF08llWyMAW2B3ZqSGcF8iQUFxwpPPK02iYXR+SLlQ3P3yLm/bcPfX6INlMfDZ0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771384435; c=relaxed/simple;
	bh=Bw4UJgpiQj8JQ2PHAbUn2XC2ma7geflydAIi3WHQCXk=;
	h=MIME-Version:Date:Message-ID:Subject:From:To:Cc:Content-Type; b=gtyU2W08hkyjJCKbcNv8AvTi9qLr0kvxbvda83n16b2AmgeRysFO1VQ1aC9JBJqRf9M05x6NlzHv3rqGj7I+9Q4G7B7PkuLNXk+YhKuBRnYnHurQjQaSDoM2mgCWgAcrDqKDDhHIetCBDXaVEylo3spvAf4lmDZNY1nFcZZw97A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com; arc=none smtp.client-ip=209.85.161.69
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com
Received: by mail-oo1-f69.google.com with SMTP id 006d021491bc7-66b47c7a795so33911522eaf.2
        for <syzbot@lists.linux.dev>; Tue, 17 Feb 2026 19:13:53 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1771384433; x=1771989233;
        h=cc:to:from:subject:message-id:date:mime-version:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=2PRTg8wygND5S/yPyz/fU4VclfYyVtjNFS6xJwwtcWE=;
        b=buEL9mnR88iBO74UqofgfLq5OhJYq8LfVB1NwqoOS9v61IZsw6o23Y0IwcDZatGsSG
         5eK5P9IPX/H8gexB9bCdcw8Iq5gEJ0VgMwMbOBmT0XjYG8l3BbfIW/hXpzlqMe5KR0Xy
         T+eB6FaXksXG6e1mrCqrvqXZ3Z3mRmHwU9yD+AiDp6mM7MIineza2OIPXSQPjugxM030
         S80H9m99sYvqKV/LowKbhs6RX3vS3Vj3qe7pRUPWZ6bYCuzINmawPR5/hwDJExo1pMus
         M1vQoIy3859qbDhuNo3LW/vz+hq9vDev6N7KBWMJtSXGBHN+hXoP0QYkM79uzbahZszU
         dxKQ==
X-Gm-Message-State: AOJu0YyQWiDU8/zecIYa+0n075talEe6QRZK531DHbtFkVuCD8LlaRxO
	hNHsW5HmiIJOdh/NvwGrWHkAsMq203FOHgCtEhyQTAPgTKeP8k7LZz4ChYH2yLaImdxjvlGzVNy
	yythy574CPfV2IfkU3xP2+ZfcLogI6EvRb1cK+nuXshcSWdFTcNrSen0si/s=
Precedence: bulk
X-Mailing-List: syzbot@lists.linux.dev
List-Id: <syzbot.lists.linux.dev>
List-Subscribe: <mailto:syzbot+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:syzbot+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Received: by 2002:a4a:b341:0:b0:659:9a49:9026 with SMTP id
 006d021491bc7-6772370b43cmr5709881eaf.83.1771384433162; Tue, 17 Feb 2026
 19:13:53 -0800 (PST)
Date: Tue, 17 Feb 2026 19:13:53 -0800
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <69952e71.a70a0220.2c38d7.0110.GAE@google.com>
Subject: [moderation/CI] Re: fat: Add FS_IOC_GETFSLABEL / FS_IOC_SETFSLABEL ioctls
From: syzbot ci <syzbot+ci43a7f1c751c4d308@syzkaller.appspotmail.com>
To: syzkaller-upstream-moderation@googlegroups.com
Cc: syzbot@lists.linux.dev
Content-Type: text/plain; charset="UTF-8"

syzbot ci has tested the following series

[v2] fat: Add FS_IOC_GETFSLABEL / FS_IOC_SETFSLABEL ioctls
https://lore.kernel.org/all/20260217230628.719475-1-ethan.ferguson@zetier.com
* [PATCH v2 1/2] fat: Add FS_IOC_GETFSLABEL ioctl
* [PATCH v2 2/2] fat: Add FS_IOC_SETFSLABEL ioctl

and found the following issue:
KASAN: stack-out-of-bounds Write in msdos_format_name

Full report is available here:
https://ci.syzbot.org/series/da73a18c-15c6-438b-8ee3-f34978d4930c

***

KASAN: stack-out-of-bounds Write in msdos_format_name

tree:      bpf-next
URL:       https://kernel.googlesource.com/pub/scm/linux/kernel/git/bpf/bpf-next.git
base:      9f2693489ef8558240d9e80bfad103650daed0af
arch:      amd64
compiler:  Debian clang version 21.1.8 (++20251221033036+2078da43e25a-1~exp1~20251221153213.50), Debian LLD 21.1.8
config:    https://ci.syzbot.org/builds/972e08c3-3f0c-4dc8-b311-d7aec3efb56b/config
C repro:   https://ci.syzbot.org/findings/f100bebc-8929-4992-996b-73c5de2585ba/c_repro
syz repro: https://ci.syzbot.org/findings/f100bebc-8929-4992-996b-73c5de2585ba/syz_repro

loop0: rw=8912896, sector=1192, nr_sectors = 4 limit=256
syz.0.17: attempt to access beyond end of device
loop0: rw=8388608, sector=1192, nr_sectors = 4 limit=256
==================================================================
BUG: KASAN: stack-out-of-bounds in msdos_format_name+0x5fe/0xd90 fs/fat/namei_msdos.c:69
Write of size 1 at addr ffffc90003a27dcb by task syz.0.17/5956

CPU: 0 UID: 0 PID: 5956 Comm: syz.0.17 Not tainted syzkaller #0 PREEMPT(full) 
Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS 1.16.2-debian-1.16.2-1 04/01/2014
Call Trace:
 <TASK>
 dump_stack_lvl+0xe8/0x150 lib/dump_stack.c:120
 print_address_description mm/kasan/report.c:378 [inline]
 print_report+0xba/0x230 mm/kasan/report.c:482
 kasan_report+0x117/0x150 mm/kasan/report.c:595
 msdos_format_name+0x5fe/0xd90 fs/fat/namei_msdos.c:69
 fat_convert_volume_label_str fs/fat/file.c:193 [inline]
 fat_ioctl_set_volume_label fs/fat/file.c:215 [inline]
 fat_generic_ioctl+0xebd/0x12a0 fs/fat/file.c:246
 vfs_ioctl fs/ioctl.c:51 [inline]
 __do_sys_ioctl fs/ioctl.c:597 [inline]
 __se_sys_ioctl+0xfc/0x170 fs/ioctl.c:583
 do_syscall_x64 arch/x86/entry/syscall_64.c:63 [inline]
 do_syscall_64+0xe2/0xf80 arch/x86/entry/syscall_64.c:94
 entry_SYSCALL_64_after_hwframe+0x77/0x7f
RIP: 0033:0x7fa55ed9bf79
Code: ff c3 66 2e 0f 1f 84 00 00 00 00 00 0f 1f 44 00 00 48 89 f8 48 89 f7 48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 ff ff 73 01 c3 48 c7 c1 e8 ff ff ff f7 d8 64 89 01 48
RSP: 002b:00007ffe3b0c1748 EFLAGS: 00000246 ORIG_RAX: 0000000000000010
RAX: ffffffffffffffda RBX: 00007fa55f015fa0 RCX: 00007fa55ed9bf79
RDX: 0000200000000240 RSI: 0000000041009432 RDI: 0000000000000004
RBP: 00007fa55ee327e0 R08: 0000000000000000 R09: 0000000000000000
R10: 0000000000000000 R11: 0000000000000246 R12: 0000000000000000
R13: 00007fa55f015fac R14: 00007fa55f015fa0 R15: 00007fa55f015fa0
 </TASK>

The buggy address belongs to stack of task syz.0.17/5956
 and is located at offset 427 in frame:
 fat_generic_ioctl+0x0/0x12a0

This frame has 4 objects:
 [32, 56) 'range.i'
 [96, 352) 'from_user.i'
 [416, 427) 'new_vol_label.i'
 [448, 528) 'ia.i'

The buggy address belongs to a 8-page vmalloc region starting at 0xffffc90003a20000 allocated at copy_process+0x508/0x3980 kernel/fork.c:2052
The buggy address belongs to the physical page:
page: refcount:1 mapcount:0 mapping:0000000000000000 index:0x0 pfn:0x1750f7
memcg:ffff888111b31502
flags: 0x57ff00000000000(node=1|zone=2|lastcpupid=0x7ff)
raw: 057ff00000000000 0000000000000000 dead000000000122 0000000000000000
raw: 0000000000000000 0000000000000000 00000001ffffffff ffff888111b31502
page dumped because: kasan: bad access detected
page_owner tracks the page as allocated
page last allocated via order 0, migratetype Unmovable, gfp_mask 0x29c2(GFP_NOWAIT|__GFP_HIGHMEM|__GFP_IO|__GFP_FS|__GFP_ZERO), pid 41, tgid 41 (kworker/u10:2), ts 69338575178, free_ts 66424269276
 set_page_owner include/linux/page_owner.h:32 [inline]
 post_alloc_hook+0x228/0x280 mm/page_alloc.c:1884
 prep_new_page mm/page_alloc.c:1892 [inline]
 get_page_from_freelist+0x24dc/0x2580 mm/page_alloc.c:3945
 __alloc_frozen_pages_noprof+0x18d/0x380 mm/page_alloc.c:5240
 alloc_pages_mpol+0x232/0x4a0 mm/mempolicy.c:2486
 alloc_frozen_pages_noprof mm/mempolicy.c:2557 [inline]
 alloc_pages_noprof+0xa8/0x190 mm/mempolicy.c:2577
 vm_area_alloc_pages mm/vmalloc.c:3649 [inline]
 __vmalloc_area_node mm/vmalloc.c:3863 [inline]
 __vmalloc_node_range_noprof+0x79b/0x1730 mm/vmalloc.c:4051
 __vmalloc_node_noprof+0xc2/0x100 mm/vmalloc.c:4111
 alloc_thread_stack_node kernel/fork.c:354 [inline]
 dup_task_struct+0x228/0x9a0 kernel/fork.c:923
 copy_process+0x508/0x3980 kernel/fork.c:2052
 kernel_clone+0x248/0x870 kernel/fork.c:2651
 user_mode_thread+0x110/0x180 kernel/fork.c:2727
 call_usermodehelper_exec_sync kernel/umh.c:132 [inline]
 call_usermodehelper_exec_work+0x9c/0x230 kernel/umh.c:163
 process_one_work kernel/workqueue.c:3257 [inline]
 process_scheduled_works+0xaec/0x17a0 kernel/workqueue.c:3340
 worker_thread+0xda6/0x1360 kernel/workqueue.c:3421
 kthread+0x726/0x8b0 kernel/kthread.c:463
 ret_from_fork+0x51b/0xa40 arch/x86/kernel/process.c:158
page last free pid 5918 tgid 5918 stack trace:
 reset_page_owner include/linux/page_owner.h:25 [inline]
 free_pages_prepare mm/page_alloc.c:1433 [inline]
 __free_frozen_pages+0xbf8/0xd70 mm/page_alloc.c:2973
 discard_slab mm/slub.c:3346 [inline]
 __put_partials+0x146/0x170 mm/slub.c:3886
 __slab_free+0x294/0x320 mm/slub.c:5956
 qlink_free mm/kasan/quarantine.c:163 [inline]
 qlist_free_all+0x97/0x100 mm/kasan/quarantine.c:179
 kasan_quarantine_reduce+0x148/0x160 mm/kasan/quarantine.c:286
 __kasan_slab_alloc+0x22/0x80 mm/kasan/common.c:350
 kasan_slab_alloc include/linux/kasan.h:253 [inline]
 slab_post_alloc_hook mm/slub.c:4953 [inline]
 slab_alloc_node mm/slub.c:5263 [inline]
 __kmalloc_cache_noprof+0x36f/0x6e0 mm/slub.c:5775
 kmalloc_noprof include/linux/slab.h:957 [inline]
 kzalloc_noprof include/linux/slab.h:1094 [inline]
 ref_tracker_alloc+0x161/0x4d0 lib/ref_tracker.c:271
 __netdev_tracker_alloc include/linux/netdevice.h:4400 [inline]
 netdev_hold include/linux/netdevice.h:4429 [inline]
 netdev_queue_add_kobject net/core/net-sysfs.c:1994 [inline]
 netdev_queue_update_kobjects+0x1d1/0x6c0 net/core/net-sysfs.c:2056
 register_queue_kobjects net/core/net-sysfs.c:2119 [inline]
 netdev_register_kobject+0x258/0x310 net/core/net-sysfs.c:2362
 register_netdevice+0x12a0/0x1cd0 net/core/dev.c:11406
 register_netdev+0x40/0x60 net/core/dev.c:11522
 loopback_net_init+0x75/0x150 drivers/net/loopback.c:218
 ops_init+0x35c/0x5c0 net/core/net_namespace.c:137
 setup_net+0x118/0x340 net/core/net_namespace.c:446
 copy_net_ns+0x50e/0x730 net/core/net_namespace.c:581

Memory state around the buggy address:
 ffffc90003a27c80: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
 ffffc90003a27d00: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
>ffffc90003a27d80: f2 f2 f2 f2 f2 f2 f2 f2 00 03 f2 f2 f8 f8 f8 f8
                                              ^
 ffffc90003a27e00: f8 f8 f8 f8 f8 f8 f3 f3 f3 f3 f3 f3 00 00 00 00
 ffffc90003a27e80: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
==================================================================


***

If these findings have caused you to resend the series or submit a
separate fix, please add the following tag to your commit message:
  Tested-by: syzbot@syzkaller.appspotmail.com

---
This report is generated by a bot. It may contain errors.
syzbot ci engineers can be reached at syzkaller@googlegroups.com.

The email will later be sent to:
[ethan.ferguson@zetier.com hirofumi@mail.parknet.co.jp linux-fsdevel@vger.kernel.org linux-kernel@vger.kernel.org]

If the report looks fine to you, reply with:
#syz upstream

If the report is a false positive, reply with
#syz invalid

