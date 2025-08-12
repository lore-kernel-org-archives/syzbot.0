Received: from mail-io1-f69.google.com (mail-io1-f69.google.com [209.85.166.69])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D7BFF1FBE87
	for <syzbot@lists.linux.dev>; Tue, 12 Aug 2025 07:44:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.69
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1754984685; cv=none; b=pT3jHoou4dzotkwNWv7jMUl0DUMbB7yAGkGVITPIXD/HM5dOw3NLEC6pZ+eojlpYs0xLWcJEnxVLLi3LVE2clRcdfZQ1E/WCtezzMWmuGTbfOG1QPF/vQDGjG08FIRAKOzO+JUK+EwjZq6uyRTQIHQLaS6kzHEb9WA8c2GiFQk8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1754984685; c=relaxed/simple;
	bh=s4mjNlWbK1r6Ac315Tp6nKm5hbzyj0uBRAsyEB6HdtU=;
	h=MIME-Version:Date:In-Reply-To:Message-ID:Subject:From:To:Cc:
	 Content-Type; b=ommnfJdzMGtY8x7DzRNwkgwiBKXdlMJMjqCz34Fub0RfYf2tayLYBhmW/kdnoWmlWr3G65xx/WecQkIoS57Gf4PrPYQKbqUcyryCG8oObg7gyPJ13EAiJa1G+D+ydcMOkLQnfFjIczjHCX7fTyDBwEnDccvkcofA6BqFBPvMwg0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com; arc=none smtp.client-ip=209.85.166.69
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com
Received: by mail-io1-f69.google.com with SMTP id ca18e2360f4ac-87b2a58a4c0so564675539f.0
        for <syzbot@lists.linux.dev>; Tue, 12 Aug 2025 00:44:43 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1754984683; x=1755589483;
        h=cc:to:from:subject:message-id:in-reply-to:date:mime-version
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=GVW8/FprpngxHAsDVO917+K4auDY2a4ckQMFxfJ0vDU=;
        b=c+yoxdKXDZtgv3uDgGYjF55zXhe4rt6y90km4sPLquN28lu3B2Nn+RbInKLk9pypkp
         dsKcSegf8bEWGnfXtG6A/QK8zw7+8FTFfZYE8mfOfov1ebtXR5WXL996PTZybKmi6vG2
         us4w23jtjTAmftmDWuw+D5UDjaEMwfaDdVqtcGcpM/ydpMzL310VsqKg1rB0nDRmLtMZ
         WJ82P+zGX1t+ex3VVFj3rWvJrUaQFXardDluAd3e8ogZaMGdIuHz2AoZiqWt8lRvyVpL
         Qb+vuTk1Iw07g479bVIJwxSaEabxYVsDUGzF1aI6ndjQ6k4WlQRXhVhwvB7xMYGW+xpH
         ZBPg==
X-Gm-Message-State: AOJu0YyGiCidd0ztgzN6k4sUbiqXflgBVx0L8r2HZsct8rqGrqwl4U/2
	NMZRcjcsAFJwEfmq75+YvN6pkPdboVa79EXEceNzvza3fpee5N0KmLwqTE4c1QOgzH6oj8XoRCI
	oJ5rOQaiSVGaYcfs4OOiRWaImYz3xq1FNHCD8N2R84/RCokbE+BkK4Np+FG4=
X-Google-Smtp-Source: AGHT+IGcBD4vEQAWkUCuWduU1D+NMw2pcR4tX8fMeeKYnWXElt89iKPP0YTIXhKzAY/Fw1TBoOlTo2M0i4tRf0jpdAp/UnxLZzCY
Precedence: bulk
X-Mailing-List: syzbot@lists.linux.dev
List-Id: <syzbot.lists.linux.dev>
List-Subscribe: <mailto:syzbot+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:syzbot+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Received: by 2002:a05:6602:720e:b0:881:8a24:55c3 with SMTP id
 ca18e2360f4ac-883f11b134cmr2412341539f.1.1754984683043; Tue, 12 Aug 2025
 00:44:43 -0700 (PDT)
Date: Tue, 12 Aug 2025 00:44:43 -0700
In-Reply-To: <20250811231909.1827080-1-wilder@us.ibm.com>
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <689af0eb.050a0220.7f033.0111.GAE@google.com>
Subject: [syzbot ci] Re: bonding: Extend arp_ip_target format to allow for a
 list of vlan tags.
From: syzbot ci <syzbot+ci3091aec9f1bc4506@syzkaller.appspotmail.com>
To: amorenoz@redhat.com, haliu@redhat.com, horms@kernel.org, 
	i.maximets@ovn.org, jv@jvosburgh.net, netdev@vger.kernel.org, 
	pradeep@us.ibm.com, pradeeps@linux.vnet.ibm.com, stephen@networkplumber.org, 
	wilder@us.ibm.com
Cc: syzbot@lists.linux.dev, syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"

syzbot ci has tested the following series

[v7] bonding: Extend arp_ip_target format to allow for a list of vlan tags.
https://lore.kernel.org/all/20250811231909.1827080-1-wilder@us.ibm.com
* [PATCH net-next v7 1/7] bonding: Adding struct bond_arp_target
* [PATCH net-next v7 2/7] bonding: Adding extra_len field to struct bond_opt_value.
* [PATCH net-next v7 3/7] bonding: arp_ip_target helpers.
* [PATCH net-next v7 4/7] bonding: Processing extended arp_ip_target from user space.
* [PATCH net-next v7 5/7] bonding: Update to bond_arp_send_all() to use supplied vlan tags
* [PATCH net-next v7 6/7] bonding: Update for extended arp_ip_target format.
* [PATCH net-next v7 7/7] bonding: Selftest and documentation for the arp_ip_target parameter.

and found the following issue:
KASAN: slab-out-of-bounds Read in bond_fill_info

Full report is available here:
https://ci.syzbot.org/series/e2badd49-adb7-4d2f-a61e-c1bb6f9c5b7d

***

KASAN: slab-out-of-bounds Read in bond_fill_info

tree:      net-next
URL:       https://kernel.googlesource.com/pub/scm/linux/kernel/git/netdev/net-next.git
base:      37816488247ddddbc3de113c78c83572274b1e2e
arch:      amd64
compiler:  Debian clang version 20.1.7 (++20250616065708+6146a88f6049-1~exp1~20250616065826.132), Debian LLD 20.1.7
config:    https://ci.syzbot.org/builds/ad5cc865-ec29-4575-99b3-58d480848dce/config
C repro:   https://ci.syzbot.org/findings/fe0c0cc1-ce24-4a52-8132-577d6e4068f1/c_repro
syz repro: https://ci.syzbot.org/findings/fe0c0cc1-ce24-4a52-8132-577d6e4068f1/syz_repro

netlink: 24 bytes leftover after parsing attributes in process `syz.0.17'.
==================================================================
BUG: KASAN: slab-out-of-bounds in bond_fill_info+0xc72/0x2280 drivers/net/bonding/bond_netlink.c:720
Read of size 2 at addr ffff88810d4e36c6 by task syz.0.17/6010

CPU: 1 UID: 0 PID: 6010 Comm: syz.0.17 Not tainted 6.16.0-syzkaller-12063-g37816488247d-dirty #0 PREEMPT(full) 
Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS 1.16.2-debian-1.16.2-1 04/01/2014
Call Trace:
 <TASK>
 dump_stack_lvl+0x189/0x250 lib/dump_stack.c:120
 print_address_description mm/kasan/report.c:378 [inline]
 print_report+0xca/0x240 mm/kasan/report.c:482
 kasan_report+0x118/0x150 mm/kasan/report.c:595
 bond_fill_info+0xc72/0x2280 drivers/net/bonding/bond_netlink.c:720
 rtnl_link_info_fill net/core/rtnetlink.c:900 [inline]
 rtnl_link_fill+0x288/0x800 net/core/rtnetlink.c:921
 rtnl_fill_ifinfo+0x17ca/0x1e70 net/core/rtnetlink.c:2133
 rtmsg_ifinfo_build_skb+0x17d/0x260 net/core/rtnetlink.c:4401
 rtmsg_ifinfo_event net/core/rtnetlink.c:4434 [inline]
 rtmsg_ifinfo+0x8c/0x1a0 net/core/rtnetlink.c:4443
 netif_state_change+0x29e/0x3a0 net/core/dev.c:1585
 do_setlink+0x35de/0x41c0 net/core/rtnetlink.c:3390
 rtnl_changelink net/core/rtnetlink.c:3761 [inline]
 __rtnl_newlink net/core/rtnetlink.c:3920 [inline]
 rtnl_newlink+0x160b/0x1c70 net/core/rtnetlink.c:4057
 rtnetlink_rcv_msg+0x7cf/0xb70 net/core/rtnetlink.c:6946
 netlink_rcv_skb+0x208/0x470 net/netlink/af_netlink.c:2552
 netlink_unicast_kernel net/netlink/af_netlink.c:1320 [inline]
 netlink_unicast+0x82f/0x9e0 net/netlink/af_netlink.c:1346
 netlink_sendmsg+0x805/0xb30 net/netlink/af_netlink.c:1896
 sock_sendmsg_nosec net/socket.c:714 [inline]
 __sock_sendmsg+0x21c/0x270 net/socket.c:729
 ____sys_sendmsg+0x505/0x830 net/socket.c:2614
 ___sys_sendmsg+0x21f/0x2a0 net/socket.c:2668
 __sys_sendmsg net/socket.c:2700 [inline]
 __do_sys_sendmsg net/socket.c:2705 [inline]
 __se_sys_sendmsg net/socket.c:2703 [inline]
 __x64_sys_sendmsg+0x19b/0x260 net/socket.c:2703
 do_syscall_x64 arch/x86/entry/syscall_64.c:63 [inline]
 do_syscall_64+0xfa/0x3b0 arch/x86/entry/syscall_64.c:94
 entry_SYSCALL_64_after_hwframe+0x77/0x7f
RIP: 0033:0x7f536498ebe9
Code: ff ff c3 66 2e 0f 1f 84 00 00 00 00 00 0f 1f 40 00 48 89 f8 48 89 f7 48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 ff ff 73 01 c3 48 c7 c1 a8 ff ff ff f7 d8 64 89 01 48
RSP: 002b:00007ffe69efd978 EFLAGS: 00000246 ORIG_RAX: 000000000000002e
RAX: ffffffffffffffda RBX: 00007f5364bb5fa0 RCX: 00007f536498ebe9
RDX: 0000000000000000 RSI: 0000200000000340 RDI: 0000000000000004
RBP: 00007f5364a11e19 R08: 0000000000000000 R09: 0000000000000000
R10: 0000000000000000 R11: 0000000000000246 R12: 0000000000000000
R13: 00007f5364bb5fa0 R14: 00007f5364bb5fa0 R15: 0000000000000003
 </TASK>

Allocated by task 6010:
 kasan_save_stack mm/kasan/common.c:47 [inline]
 kasan_save_track+0x3e/0x80 mm/kasan/common.c:68
 poison_kmalloc_redzone mm/kasan/common.c:388 [inline]
 __kasan_kmalloc+0x93/0xb0 mm/kasan/common.c:405
 kasan_kmalloc include/linux/kasan.h:260 [inline]
 __do_kmalloc_node mm/slub.c:4365 [inline]
 __kmalloc_noprof+0x27a/0x4f0 mm/slub.c:4377
 kmalloc_noprof include/linux/slab.h:909 [inline]
 bond_option_arp_ip_targets_set+0x227/0xbc0 drivers/net/bonding/bond_options.c:1284
 __bond_opt_set+0x27b/0xee0 drivers/net/bonding/bond_options.c:800
 bond_changelink+0xa66/0x26d0 drivers/net/bonding/bond_netlink.c:300
 rtnl_changelink net/core/rtnetlink.c:3721 [inline]
 __rtnl_newlink net/core/rtnetlink.c:3920 [inline]
 rtnl_newlink+0x1669/0x1c70 net/core/rtnetlink.c:4057
 rtnetlink_rcv_msg+0x7cf/0xb70 net/core/rtnetlink.c:6946
 netlink_rcv_skb+0x208/0x470 net/netlink/af_netlink.c:2552
 netlink_unicast_kernel net/netlink/af_netlink.c:1320 [inline]
 netlink_unicast+0x82f/0x9e0 net/netlink/af_netlink.c:1346
 netlink_sendmsg+0x805/0xb30 net/netlink/af_netlink.c:1896
 sock_sendmsg_nosec net/socket.c:714 [inline]
 __sock_sendmsg+0x21c/0x270 net/socket.c:729
 ____sys_sendmsg+0x505/0x830 net/socket.c:2614
 ___sys_sendmsg+0x21f/0x2a0 net/socket.c:2668
 __sys_sendmsg net/socket.c:2700 [inline]
 __do_sys_sendmsg net/socket.c:2705 [inline]
 __se_sys_sendmsg net/socket.c:2703 [inline]
 __x64_sys_sendmsg+0x19b/0x260 net/socket.c:2703
 do_syscall_x64 arch/x86/entry/syscall_64.c:63 [inline]
 do_syscall_64+0xfa/0x3b0 arch/x86/entry/syscall_64.c:94
 entry_SYSCALL_64_after_hwframe+0x77/0x7f

The buggy address belongs to the object at ffff88810d4e36c0
 which belongs to the cache kmalloc-8 of size 8
The buggy address is located 6 bytes inside of
 allocated 7-byte region [ffff88810d4e36c0, ffff88810d4e36c7)

The buggy address belongs to the physical page:
page: refcount:0 mapcount:0 mapping:0000000000000000 index:0xffff88810d4e31c0 pfn:0x10d4e3
flags: 0x57ff00000000000(node=1|zone=2|lastcpupid=0x7ff)
page_type: f5(slab)
raw: 057ff00000000000 ffff88801a441500 dead000000000122 0000000000000000
raw: ffff88810d4e31c0 000000008080006d 00000000f5000000 0000000000000000
page dumped because: kasan: bad access detected
page_owner tracks the page as allocated
page last allocated via order 0, migratetype Unmovable, gfp_mask 0x52cc0(GFP_KERNEL|__GFP_NOWARN|__GFP_NORETRY|__GFP_COMP), pid 5954, tgid 5954 (syz-executor), ts 95720202696, free_ts 95706797594
 set_page_owner include/linux/page_owner.h:32 [inline]
 post_alloc_hook+0x240/0x2a0 mm/page_alloc.c:1851
 prep_new_page mm/page_alloc.c:1859 [inline]
 get_page_from_freelist+0x21e4/0x22c0 mm/page_alloc.c:3858
 __alloc_frozen_pages_noprof+0x181/0x370 mm/page_alloc.c:5148
 alloc_pages_mpol+0x232/0x4a0 mm/mempolicy.c:2416
 alloc_slab_page mm/slub.c:2487 [inline]
 allocate_slab+0x8a/0x370 mm/slub.c:2655
 new_slab mm/slub.c:2709 [inline]
 ___slab_alloc+0xbeb/0x1410 mm/slub.c:3891
 __slab_alloc mm/slub.c:3981 [inline]
 __slab_alloc_node mm/slub.c:4056 [inline]
 slab_alloc_node mm/slub.c:4217 [inline]
 __do_kmalloc_node mm/slub.c:4364 [inline]
 __kmalloc_node_track_caller_noprof+0x2f8/0x4e0 mm/slub.c:4384
 __kmemdup_nul mm/util.c:64 [inline]
 kstrdup+0x42/0x100 mm/util.c:84
 __kernfs_new_node+0x9c/0x7e0 fs/kernfs/dir.c:633
 kernfs_new_node+0x102/0x210 fs/kernfs/dir.c:713
 kernfs_create_dir_ns+0x44/0x130 fs/kernfs/dir.c:1083
 sysfs_create_dir_ns+0x123/0x280 fs/sysfs/dir.c:59
 create_dir lib/kobject.c:73 [inline]
 kobject_add_internal+0x59f/0xb40 lib/kobject.c:240
 kobject_add_varg lib/kobject.c:374 [inline]
 kobject_add+0x155/0x220 lib/kobject.c:426
 device_add+0x408/0xb50 drivers/base/core.c:3627
 netdev_register_kobject+0x178/0x310 net/core/net-sysfs.c:2356
page last free pid 5954 tgid 5954 stack trace:
 reset_page_owner include/linux/page_owner.h:25 [inline]
 free_pages_prepare mm/page_alloc.c:1395 [inline]
 __free_frozen_pages+0xbc4/0xd30 mm/page_alloc.c:2895
 __slab_free+0x303/0x3c0 mm/slub.c:4591
 qlink_free mm/kasan/quarantine.c:163 [inline]
 qlist_free_all+0x97/0x140 mm/kasan/quarantine.c:179
 kasan_quarantine_reduce+0x148/0x160 mm/kasan/quarantine.c:286
 __kasan_slab_alloc+0x22/0x80 mm/kasan/common.c:340
 kasan_slab_alloc include/linux/kasan.h:250 [inline]
 slab_post_alloc_hook mm/slub.c:4180 [inline]
 slab_alloc_node mm/slub.c:4229 [inline]
 __do_kmalloc_node mm/slub.c:4364 [inline]
 __kmalloc_noprof+0x224/0x4f0 mm/slub.c:4377
 kmalloc_noprof include/linux/slab.h:909 [inline]
 kzalloc_noprof include/linux/slab.h:1039 [inline]
 ops_init+0x7b/0x5c0 net/core/net_namespace.c:126
 setup_net+0x10c/0x320 net/core/net_namespace.c:438
 copy_net_ns+0x31b/0x4d0 net/core/net_namespace.c:570
 create_new_namespaces+0x3f3/0x720 kernel/nsproxy.c:110
 unshare_nsproxy_namespaces+0x11c/0x170 kernel/nsproxy.c:218
 ksys_unshare+0x4c8/0x8c0 kernel/fork.c:3127
 __do_sys_unshare kernel/fork.c:3198 [inline]
 __se_sys_unshare kernel/fork.c:3196 [inline]
 __x64_sys_unshare+0x38/0x50 kernel/fork.c:3196
 do_syscall_x64 arch/x86/entry/syscall_64.c:63 [inline]
 do_syscall_64+0xfa/0x3b0 arch/x86/entry/syscall_64.c:94
 entry_SYSCALL_64_after_hwframe+0x77/0x7f

Memory state around the buggy address:
 ffff88810d4e3580: fa fc fc fc fa fc fc fc fa fc fc fc fa fc fc fc
 ffff88810d4e3600: fa fc fc fc fa fc fc fc fa fc fc fc fa fc fc fc
>ffff88810d4e3680: fa fc fc fc fa fc fc fc 07 fc fc fc fa fc fc fc
                                           ^
 ffff88810d4e3700: fa fc fc fc fa fc fc fc fa fc fc fc fa fc fc fc
 ffff88810d4e3780: fa fc fc fc fa fc fc fc fa fc fc fc fa fc fc fc
==================================================================


***

If these findings have caused you to resend the series or submit a
separate fix, please add the following tag to your commit message:
Tested-by: syzbot@syzkaller.appspotmail.com

---
This report is generated by a bot. It may contain errors.
syzbot ci engineers can be reached at syzkaller@googlegroups.com.
