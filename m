Received: from mail-oo1-f70.google.com (mail-oo1-f70.google.com [209.85.161.70])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D22D036C0AF
	for <syzbot@lists.linux.dev>; Sun,  8 Mar 2026 09:56:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.161.70
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772963777; cv=none; b=kEFOdsvppqLqXdwd76aMjbx+DvEXEmdPlZ72vtMuNmzS5y4AbnFhTEWYXXBu4IfzIE3UjNr2wpMjYugmjpE/gewzrnqjf43rvTrs7hmhXNwep7yH6B4yvo4hPmussjbIckgw2inujfWrd/Y84OMD68LuZC7fP1DWgUxAR5cbMC0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772963777; c=relaxed/simple;
	bh=DmAfmK6nhojp6J9PLYCxUIiMPOs1I1IsyiUfMPmtusM=;
	h=MIME-Version:Date:Message-ID:Subject:From:To:Cc:Content-Type; b=fABb6+t6+bcGZbiTGyD6dX0U3QjANVw5MDTGAnkVQb8RIzyqtENJm/KRRX3bKXCJPUcWEEoKapJ8CCVpHSDlCKH+crdK/fuO4J8Y6DS8kQJGgsxaMLTskhFx3JubhZAqJfqb6Ab3jrbkuXbe/Tx2rTnOu2/5ZrIF3bT2lJj/AxM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com; arc=none smtp.client-ip=209.85.161.70
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com
Received: by mail-oo1-f70.google.com with SMTP id 006d021491bc7-67ba8d8546cso13357401eaf.1
        for <syzbot@lists.linux.dev>; Sun, 08 Mar 2026 01:56:15 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1772963775; x=1773568575;
        h=cc:to:from:subject:message-id:date:mime-version:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=JcF3HdCT436E3CdQ6+isEppGdrvre/fkV1JyvG1N080=;
        b=LqhN7G1SOd4hS/pdxMsxdRy3fSySTLmS85l9japAYYf0jK3c5mrynl4QGBp08Q/5bf
         0yyvV+XVZTwWEuu6AYwJ7rDIbFl3/MQ9OZWdQzpnh9mslJQ9Zaf9ZWSKWj53sMAPTFAg
         gXz82HAN5T0IkNvoIggPZyeawzT2ZhBDHy/S+4DufUMQXkDIJRYBLnk+ZcCIlbgSQ2Zz
         KHacJtO4feVJ22R36M6LUUjNmjdSDqlfef0TMOtTNYQeig0SIN6fiPdSgVtXR4UgzS3W
         9zuVYD5gzvDhO9t66gra9NHz4evWmDsD0gVkp1gb/NVnQr95vRsrbgvl67vFeHn7tMV1
         66jA==
X-Gm-Message-State: AOJu0YzUaqO7qECWPb+Zpfba32xIG2fs6EpB/AKSy2J6KiYAWRfFX7u1
	xzz9ALJTbpgyMayGuIydo4JWxOfJP9/XspE1FuHCIL6jKp6l2X/KIDL835DJQM0LbO4+w81ILWT
	2veBWH0f2Ww3BPIQ8vGYxNKMYmXzBnXuyxdMBLcg4IQreztK7oa3UpOs2nS8=
Precedence: bulk
X-Mailing-List: syzbot@lists.linux.dev
List-Id: <syzbot.lists.linux.dev>
List-Subscribe: <mailto:syzbot+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:syzbot+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Received: by 2002:a05:6820:810b:b0:679:88ee:e3f8 with SMTP id
 006d021491bc7-67b9bd686a2mr5268872eaf.68.1772963774794; Sun, 08 Mar 2026
 01:56:14 -0800 (PST)
Date: Sun, 08 Mar 2026 01:56:14 -0800
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <69ad47be.050a0220.310d8.000a.GAE@google.com>
Subject: [moderation/CI] Re: genetlink: apply reject policy for split ops on
 the dispatch path
From: syzbot ci <syzbot+ci1386686723ca79d9@syzkaller.appspotmail.com>
To: syzkaller-upstream-moderation@googlegroups.com
Cc: syzbot@lists.linux.dev
Content-Type: text/plain; charset="UTF-8"

syzbot ci has tested the following series

[v1] genetlink: apply reject policy for split ops on the dispatch path
https://lore.kernel.org/all/20260307204425.1900467-1-kuba@kernel.org
* [PATCH net-next 1/2] genetlink: apply reject policy for split ops on the dispatch path
* [PATCH net-next 2/2] selftests: net: make sure that Netlink rejects unknown attrs in dump

and found the following issue:
KASAN: slab-out-of-bounds Read in devlink_nl_dumpit

Full report is available here:
https://ci.syzbot.org/series/cced225b-516e-4f54-b4f2-57afc46c5c2a

***

KASAN: slab-out-of-bounds Read in devlink_nl_dumpit

tree:      net-next
URL:       https://kernel.googlesource.com/pub/scm/linux/kernel/git/netdev/net-next.git
base:      0bcac7b11262557c990da1ac564d45777eb6b005
arch:      amd64
compiler:  Debian clang version 21.1.8 (++20251221033036+2078da43e25a-1~exp1~20251221153213.50), Debian LLD 21.1.8
config:    https://ci.syzbot.org/builds/4ea10ec3-e985-401a-a2b5-87b89ca3a776/config
C repro:   https://ci.syzbot.org/findings/c23aee43-2180-46d5-93cb-e8c1cbcb1c39/c_repro
syz repro: https://ci.syzbot.org/findings/c23aee43-2180-46d5-93cb-e8c1cbcb1c39/syz_repro

==================================================================
BUG: KASAN: slab-out-of-bounds in devlink_nl_dumpit+0x2a4/0x410 net/devlink/netlink.c:355
Read of size 8 at addr ffff88810a48eab0 by task syz.0.17/5954

CPU: 0 UID: 0 PID: 5954 Comm: syz.0.17 Not tainted syzkaller #0 PREEMPT(full) 
Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS 1.16.2-debian-1.16.2-1 04/01/2014
Call Trace:
 <TASK>
 dump_stack_lvl+0xe8/0x150 lib/dump_stack.c:120
 print_address_description mm/kasan/report.c:378 [inline]
 print_report+0xba/0x230 mm/kasan/report.c:482
 kasan_report+0x117/0x150 mm/kasan/report.c:595
 devlink_nl_dumpit+0x2a4/0x410 net/devlink/netlink.c:355
 genl_dumpit+0x10b/0x1b0 net/netlink/genetlink.c:1027
 netlink_dump+0x722/0xe80 net/netlink/af_netlink.c:2325
 __netlink_dump_start+0x5cb/0x7e0 net/netlink/af_netlink.c:2440
 genl_family_rcv_msg_dumpit+0x213/0x310 net/netlink/genetlink.c:1076
 genl_family_rcv_msg net/netlink/genetlink.c:1192 [inline]
 genl_rcv_msg+0x5e8/0x7a0 net/netlink/genetlink.c:1210
 netlink_rcv_skb+0x232/0x4b0 net/netlink/af_netlink.c:2550
 genl_rcv+0x28/0x40 net/netlink/genetlink.c:1219
 netlink_unicast_kernel net/netlink/af_netlink.c:1318 [inline]
 netlink_unicast+0x80f/0x9b0 net/netlink/af_netlink.c:1344
 netlink_sendmsg+0x813/0xb40 net/netlink/af_netlink.c:1894
 sock_sendmsg_nosec net/socket.c:727 [inline]
 __sock_sendmsg net/socket.c:742 [inline]
 ____sys_sendmsg+0x972/0x9f0 net/socket.c:2591
 ___sys_sendmsg+0x2a5/0x360 net/socket.c:2645
 __sys_sendmsg net/socket.c:2677 [inline]
 __do_sys_sendmsg net/socket.c:2682 [inline]
 __se_sys_sendmsg net/socket.c:2680 [inline]
 __x64_sys_sendmsg+0x1bd/0x2a0 net/socket.c:2680
 do_syscall_x64 arch/x86/entry/syscall_64.c:63 [inline]
 do_syscall_64+0x14d/0xf80 arch/x86/entry/syscall_64.c:94
 entry_SYSCALL_64_after_hwframe+0x77/0x7f
RIP: 0033:0x7f6bf799c799
Code: ff c3 66 2e 0f 1f 84 00 00 00 00 00 0f 1f 44 00 00 48 89 f8 48 89 f7 48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 ff ff 73 01 c3 48 c7 c1 e8 ff ff ff f7 d8 64 89 01 48
RSP: 002b:00007fff4b3c0b38 EFLAGS: 00000246 ORIG_RAX: 000000000000002e
RAX: ffffffffffffffda RBX: 00007f6bf7c15fa0 RCX: 00007f6bf799c799
RDX: 0000000000000000 RSI: 0000200000001780 RDI: 0000000000000003
RBP: 00007f6bf7a32bd9 R08: 0000000000000000 R09: 0000000000000000
R10: 0000000000000000 R11: 0000000000000246 R12: 0000000000000000
R13: 00007f6bf7c15fac R14: 00007f6bf7c15fa0 R15: 00007f6bf7c15fa0
 </TASK>

Allocated by task 5954:
 kasan_save_stack mm/kasan/common.c:57 [inline]
 kasan_save_track+0x3e/0x80 mm/kasan/common.c:78
 poison_kmalloc_redzone mm/kasan/common.c:398 [inline]
 __kasan_kmalloc+0x93/0xb0 mm/kasan/common.c:415
 kasan_kmalloc include/linux/kasan.h:263 [inline]
 __do_kmalloc_node mm/slub.c:5238 [inline]
 __kmalloc_noprof+0x35c/0x760 mm/slub.c:5250
 kmalloc_noprof include/linux/slab.h:954 [inline]
 genl_family_rcv_msg_attrs_parse+0xa3/0x2a0 net/netlink/genetlink.c:941
 genl_start+0x180/0x6c0 net/netlink/genetlink.c:980
 __netlink_dump_start+0x469/0x7e0 net/netlink/af_netlink.c:2431
 genl_family_rcv_msg_dumpit+0x213/0x310 net/netlink/genetlink.c:1076
 genl_family_rcv_msg net/netlink/genetlink.c:1192 [inline]
 genl_rcv_msg+0x5e8/0x7a0 net/netlink/genetlink.c:1210
 netlink_rcv_skb+0x232/0x4b0 net/netlink/af_netlink.c:2550
 genl_rcv+0x28/0x40 net/netlink/genetlink.c:1219
 netlink_unicast_kernel net/netlink/af_netlink.c:1318 [inline]
 netlink_unicast+0x80f/0x9b0 net/netlink/af_netlink.c:1344
 netlink_sendmsg+0x813/0xb40 net/netlink/af_netlink.c:1894
 sock_sendmsg_nosec net/socket.c:727 [inline]
 __sock_sendmsg net/socket.c:742 [inline]
 ____sys_sendmsg+0x972/0x9f0 net/socket.c:2591
 ___sys_sendmsg+0x2a5/0x360 net/socket.c:2645
 __sys_sendmsg net/socket.c:2677 [inline]
 __do_sys_sendmsg net/socket.c:2682 [inline]
 __se_sys_sendmsg net/socket.c:2680 [inline]
 __x64_sys_sendmsg+0x1bd/0x2a0 net/socket.c:2680
 do_syscall_x64 arch/x86/entry/syscall_64.c:63 [inline]
 do_syscall_64+0x14d/0xf80 arch/x86/entry/syscall_64.c:94
 entry_SYSCALL_64_after_hwframe+0x77/0x7f

The buggy address belongs to the object at ffff88810a48eaa0
 which belongs to the cache kmalloc-16 of size 16
The buggy address is located 0 bytes to the right of
 allocated 16-byte region [ffff88810a48eaa0, ffff88810a48eab0)

The buggy address belongs to the physical page:
page: refcount:0 mapcount:0 mapping:0000000000000000 index:0x0 pfn:0x10a48e
flags: 0x17ff00000000000(node=0|zone=2|lastcpupid=0x7ff)
page_type: f5(slab)
raw: 017ff00000000000 ffff888100041640 dead000000000100 dead000000000122
raw: 0000000000000000 0000000800800080 00000000f5000000 0000000000000000
page dumped because: kasan: bad access detected
page_owner tracks the page as allocated
page last allocated via order 0, migratetype Unmovable, gfp_mask 0xd2cc0(GFP_KERNEL|__GFP_NOWARN|__GFP_NORETRY|__GFP_COMP|__GFP_NOMEMALLOC), pid 1, tgid 1 (swapper/0), ts 11308983860, free_ts 11289885463
 create_dummy_stack mm/page_owner.c:103 [inline]
 register_dummy_stack+0x98/0x100 mm/page_owner.c:109
 init_page_owner+0x2e/0x600 mm/page_owner.c:127
 invoke_init_callbacks mm/page_ext.c:152 [inline]
 page_ext_init+0x500/0x540 mm/page_ext.c:490
 mm_core_init+0x51/0x70 mm/mm_init.c:2735
page last free pid 1 tgid 1 stack trace:
 reset_page_owner include/linux/page_owner.h:25 [inline]
 __free_pages_prepare mm/page_alloc.c:1433 [inline]
 __free_frozen_pages+0xc2b/0xdb0 mm/page_alloc.c:2978
 ___free_pages_bulk mm/kasan/shadow.c:333 [inline]
 __kasan_populate_vmalloc_do mm/kasan/shadow.c:385 [inline]
 __kasan_populate_vmalloc+0x137/0x1d0 mm/kasan/shadow.c:424
 kasan_populate_vmalloc include/linux/kasan.h:580 [inline]
 alloc_vmap_area+0xd73/0x14b0 mm/vmalloc.c:2129
 __get_vm_area_node+0x1f8/0x300 mm/vmalloc.c:3232
 get_vm_area_caller+0x82/0xb0 mm/vmalloc.c:3283
 __ioremap_caller+0x3d7/0x620 arch/x86/mm/ioremap.c:292
 pcim_iomap+0xde/0x2b0 drivers/pci/devres.c:548
 ahci_init_one+0x99e/0x34b0 drivers/ata/ahci.c:1973
 local_pci_probe drivers/pci/pci-driver.c:323 [inline]
 pci_call_probe drivers/pci/pci-driver.c:385 [inline]
 __pci_device_probe drivers/pci/pci-driver.c:446 [inline]
 pci_device_probe+0x41a/0xc70 drivers/pci/pci-driver.c:480
 call_driver_probe drivers/base/dd.c:-1 [inline]
 really_probe+0x267/0xaf0 drivers/base/dd.c:661
 __driver_probe_device+0x18c/0x320 drivers/base/dd.c:803
 driver_probe_device+0x4f/0x240 drivers/base/dd.c:833
 __driver_attach+0x3e7/0x710 drivers/base/dd.c:1227
 bus_for_each_dev+0x23b/0x2c0 drivers/base/bus.c:383
 bus_add_driver+0x345/0x670 drivers/base/bus.c:715
 driver_register+0x23a/0x320 drivers/base/driver.c:249

Memory state around the buggy address:
 ffff88810a48e980: fa fb fc fc 00 00 fc fc fa fb fc fc fa fb fc fc
 ffff88810a48ea00: fa fb fc fc fa fb fc fc fa fb fc fc fa fb fc fc
>ffff88810a48ea80: fa fb fc fc 00 00 fc fc 00 06 fc fc 00 00 fc fc
                                     ^
 ffff88810a48eb00: fa fb fc fc 00 00 fc fc 00 00 fc fc fa fb fc fc
 ffff88810a48eb80: 00 00 fc fc 00 00 fc fc fa fb fc fc 00 00 fc fc
==================================================================


***

If these findings have caused you to resend the series or submit a
separate fix, please add the following tag to your commit message:
  Tested-by: syzbot@syzkaller.appspotmail.com

---
This report is generated by a bot. It may contain errors.
syzbot ci engineers can be reached at syzkaller@googlegroups.com.

The email will later be sent to:
[alok.a.tiwari@oracle.com andrew@lunn.ch davem@davemloft.net edumazet@google.com horms@kernel.org kees@kernel.org kuba@kernel.org linux-kselftest@vger.kernel.org netdev@vger.kernel.org pabeni@redhat.com shuah@kernel.org]

If the report looks fine to you, reply with:
#syz upstream

If the report is a false positive, reply with
#syz invalid

