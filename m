Received: from mail-oi1-f198.google.com (mail-oi1-f198.google.com [209.85.167.198])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2EC0A17B50F
	for <syzbot@lists.linux.dev>; Sat, 10 Oct 2026 21:16:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.167.198
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791666979; cv=none; b=m8zMIdwjW/X2h1hEVCHwurp1EJ68wEQYf1fQSNW8X8gcKd8qFgAdP0fKQscEwGngAlY86YvU9baAk0ReFUayirUGUNxIyiqUFaX28Y0u0tYWdTdnjE2dk5HXR7CBXIdrdyyqlriXAnDzdMU5h0GhTihihluJhAHs2GWeZ8HL8MA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791666979; c=relaxed/simple;
	bh=PNV3yxdcl5fzhZwP7QTzKAy4SAOtmkKbNl7K5T5rjRI=;
	h=MIME-Version:Date:In-Reply-To:Message-ID:Subject:From:To:Cc:
	 Content-Type; b=GBpr+nn8JlGi8anrixbB23PrHVIG6ubVNQW2AiPXAV2KTFaZts8B9BB+Uq+oiXMf/oaunMsK+o5voa4TmMBMPSOuiZhox6wgw8/EI/boAb7puGNe+/GvMVvhnEwqxbFaSvTlFZAnTPL5Q9AGKOcZ8DfSwY4r2sa/rcmKNAgv0M8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com; arc=none smtp.client-ip=209.85.167.198
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com
Received: by mail-oi1-f198.google.com with SMTP id 5614622812f47-4d2f0f77124so1224497b6e.3
        for <syzbot@lists.linux.dev>; Sat, 10 Oct 2026 14:16:16 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1791666976; x=1792271776;
        h=content-type:cc:to:from:subject:message-id:in-reply-to:date
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to:content-type;
        bh=lzpBC4xDvBapyDEYX7/rVcQdhlOCUcJz9tk+ma73fSA=;
        b=Ztpt6DjRK4THSroSvreOZP7ICCyDkqUxGFPsgwoXwxJHGms4xwpPDymLWThZKGOQS+
         92ptTjmgJXvNYwcrRO5qkOmQ/vF/4wS/gOrqzYgXbSbYpXZv55u/8O5kQ9KksDnjNJOM
         gy4Zm6e4iH2SdvQUad3LKQG/XpSAGtF4SYu+4I+HZjhPbKRwq1yVl30wy94riRC6uRcS
         yIZakjtMZfw3uxbdtjcz3m2yOFft4E1O12vmGtpP9fv8RjjzFsTULXEmQMh8ac+sAKAV
         HX5+523+MdnKqPHTntHK8nG7tlX9TpcCDWsRaV5/v9ckwb696yEl2f1bLagoO2wMdQ6O
         dTLA==
X-Gm-Message-State: AFq9FYLyiYSIMhbRHfGN8GOwq05AcXI3dlaUjZiiZg03UFJAInKKHcp1
	uEXPNGUHkfKahyIWBq0hFIGUefaon0XgI43BiXK84kg1a5spzJZnqdIYWSDoU2I9KlkyPeXXE/U
	fnJe4T7h+TLFJgdVd0ajfXtBAoZeFJnQCYcGw6zXv/Q+vdQSuSORrH4Kraxw=
Precedence: bulk
X-Mailing-List: syzbot@lists.linux.dev
List-Id: <syzbot.lists.linux.dev>
List-Subscribe: <mailto:syzbot+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:syzbot+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Received: by 2002:a05:6808:5093:b0:4f6:cda3:ec05 with SMTP id
 5614622812f47-50c56bf99damr5350416b6e.55.1791666976012; Sat, 10 Oct 2026
 14:16:16 -0700 (PDT)
Date: Sat, 10 Oct 2026 14:16:15 -0700
In-Reply-To: <20261010160459.229064-11-johannes@sipsolutions.net>
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <6acaab1f.8cdf6287.1eb53.00a4.GAE@google.com>
Subject: [syzbot ci] Re: wifi: further RTNL redux
From: syzbot ci <syzbot+cibe5825e3e896a456@syzkaller.appspotmail.com>
To: johannes.berg@intel.com, johannes@sipsolutions.net, 
	linux-wireless@vger.kernel.org
Cc: syzbot@lists.linux.dev, syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"

syzbot ci has tested the following series

[v1] wifi: further RTNL redux
https://lore.kernel.org/all/20261010160459.229064-11-johannes@sipsolutions.net
* [PATCH RESEND wireless-next 1/9] wifi: nl80211: avoid RTNL in nl80211_get_reg_do()
* [PATCH RESEND wireless-next 2/9] wifi: cfg80211: drop RTNL from disconnect_work
* [PATCH RESEND wireless-next 3/9] wifi: nl80211: don't hold RTNL for SET_SAR_SPECS
* [PATCH RESEND wireless-next 4/9] wifi: cfg80211: switch wiphy netns under cfg80211_mutex
* [PATCH RESEND wireless-next 5/9] wifi: nl80211: avoid RTNL for wiphy/interface netlink dumps
* [PATCH RESEND wireless-next 6/9] wifi: cfg80211: protect wiphy names with cfg80211_mutex
* [PATCH RESEND wireless-next 7/9] wifi: cfg80211: check wiphy name in wiphy_register()
* [PATCH RESEND wireless-next 8/9] wifi: mac80211: don't hold RTNL for rate control algo
* [PATCH RESEND wireless-next 9/9] wifi: mac80211: fix interface registration error path order

and found the following issues:
* KASAN: slab-use-after-free Read in NUM
* KASAN: slab-use-after-free Read in append_radio_msg

Full report is available here:
https://ci.syzbot.org/series/51e15aa3-1f1c-404d-b5c8-c1065c90bcb0

***

KASAN: slab-use-after-free Read in NUM

tree:      wireless-next
URL:       https://kernel.googlesource.com/pub/scm/linux/kernel/git/wireless/wireless-next.git
base:      fbfa27d9b06f025c5f2cfa79d0e01e6400eeff2a
arch:      amd64
compiler:  Debian clang version 22.1.8 (++20260613092233+e80beda6e255-1~exp1~20260613092250.77), Debian LLD 22.1.8
config:    https://ci.syzbot.org/builds/2d1bce7d-9b9b-4d15-9fb8-ca75e747b223/config

netlink: 76 bytes leftover after parsing attributes in process `syz.1.35'.
==================================================================
BUG: KASAN: slab-use-after-free in strlen+0x57/0x70
Read of size 1 at addr ffff888116dae800 by task syz.1.35/5916

CPU: 0 UID: 0 PID: 5916 Comm: syz.1.35 Not tainted syzkaller #0 PREEMPT(full) 
Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS 1.16.2-debian-1.16.2-1 04/01/2014
Call Trace:
   53.418828][ T5916]
 <TASK>
 dump_stack_lvl+0xe8/0x150
 print_address_description+0x55/0x1e0
 print_report+0x58/0x70
 kasan_report+0x117/0x150
 strlen+0x57/0x70
 append_radio_msg+0x3cc/0x5f0
 mac80211_hwsim_new_radio+0x41cd/0x5750
 hwsim_new_radio_nl+0xd8b/0xf90
 genl_family_rcv_msg_doit+0x233/0x340
 genl_rcv_msg+0x614/0x7a0
 netlink_rcv_skb+0x226/0x4a0
 genl_rcv+0x28/0x40
 netlink_unicast+0x7bd/0x940
 netlink_sendmsg+0x813/0xb40
 sock_sendmsg_nosec+0x14e/0x190
 ____sys_sendmsg+0x54e/0x850
 ___sys_sendmsg+0x2a5/0x360
 __x64_sys_sendmsg+0x1b1/0x290
 do_syscall_64+0x166/0x520
 entry_SYSCALL_64_after_hwframe+0x77/0x7f
RIP: 0033:0x7f4941d9e1d9
Code: ff c3 66 2e 0f 1f 84 00 00 00 00 00 0f 1f 44 00 00 48 89 f8 48 89 f7 48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 ff ff 73 01 c3 48 c7 c1 e8 ff ff ff f7 d8 64 89 01 48
RSP: 002b:00007f493ffd5028 EFLAGS: 00000246 ORIG_RAX: 000000000000002e
RAX: ffffffffffffffda RBX: 00007f4942026090 RCX: 00007f4941d9e1d9
RDX: 0000000000000000 RSI: 0000200000000040 RDI: 0000000000000005
RBP: 00007f4941e35888 R08: 0000000000000000 R09: 0000000000000000
R10: 0000000000000000 R11: 0000000000000246 R12: 0000000000000000
R13: 00007f4942026128 R14: 00007f4942026090 R15: 00007ffdf55e71e8
 </TASK>

Allocated by task 5916:
 kasan_save_track+0x3e/0x80
 __kasan_kmalloc+0x93/0xb0
 __kmalloc_node_track_caller_noprof+0x4b4/0x720
 kstrdup+0x42/0x100
 kobject_set_name_vargs+0x61/0x110
 dev_set_name+0xe2/0x140
 wiphy_new_nm+0x710/0x1ae0
 ieee80211_alloc_hw_nm+0x3f3/0x1f00
 mac80211_hwsim_new_radio+0x1ea/0x5750
 hwsim_new_radio_nl+0xd8b/0xf90
 genl_family_rcv_msg_doit+0x233/0x340
 genl_rcv_msg+0x614/0x7a0
 netlink_rcv_skb+0x226/0x4a0
 genl_rcv+0x28/0x40
 netlink_unicast+0x7bd/0x940
 netlink_sendmsg+0x813/0xb40
 sock_sendmsg_nosec+0x14e/0x190
 ____sys_sendmsg+0x54e/0x850
 ___sys_sendmsg+0x2a5/0x360
 __x64_sys_sendmsg+0x1b1/0x290
 do_syscall_64+0x166/0x520
 entry_SYSCALL_64_after_hwframe+0x77/0x7f

Freed by task 5916:
 kasan_save_track+0x3e/0x80
 kasan_save_free_info+0x40/0x50
 __kasan_slab_free+0x5c/0x80
 kfree+0x1c5/0x650
 kobject_set_name_vargs+0xca/0x110
 dev_set_name+0xe2/0x140
 wiphy_register+0x214e/0x3290
 ieee80211_register_hw+0x3d72/0x4b30
 mac80211_hwsim_new_radio+0x3284/0x5750
 hwsim_new_radio_nl+0xd8b/0xf90
 genl_family_rcv_msg_doit+0x233/0x340
 genl_rcv_msg+0x614/0x7a0
 netlink_rcv_skb+0x226/0x4a0
 genl_rcv+0x28/0x40
 netlink_unicast+0x7bd/0x940
 netlink_sendmsg+0x813/0xb40
 sock_sendmsg_nosec+0x14e/0x190
 ____sys_sendmsg+0x54e/0x850
 ___sys_sendmsg+0x2a5/0x360
 __x64_sys_sendmsg+0x1b1/0x290
 do_syscall_64+0x166/0x520
 entry_SYSCALL_64_after_hwframe+0x77/0x7f

The buggy address belongs to the object at ffff888116dae800
 which belongs to the cache kmalloc-64 of size 64
The buggy address is located 0 bytes inside of
 freed 64-byte region [ffff888116dae800, ffff888116dae840)

The buggy address belongs to the physical page:
page: refcount:0 mapcount:0 mapping:0000000000000000 index:0x0 pfn:0x116dae
flags: 0x17ff00000000000(node=0|zone=2|lastcpupid=0x7ff)
page_type: f5(slab)
raw: 017ff00000000000 ffff8881000418c0 dead000000000100 dead000000000122
raw: 0000000000000000 0000000000200020 00000000f5000000 0000000000000000
page dumped because: kasan: bad access detected
page_owner tracks the page as allocated
page last allocated via order 0, migratetype Unmovable, gfp_mask 0xd2cc0(GFP_KERNEL|__GFP_NOWARN|__GFP_NORETRY|__GFP_COMP|__GFP_NOMEMALLOC), pid 1, tgid 1 (swapper/0), ts 10987624482
 post_alloc_hook+0x1f9/0x250
 get_page_from_freelist+0x2209/0x2280
 __alloc_frozen_pages_noprof+0x217/0x5a0
 allocate_slab+0x7d/0x620
 refill_objects+0x2d5/0x350
 __pcs_replace_empty_main+0x2c8/0x6c0
 __kmalloc_node_track_caller_noprof+0x548/0x720
 krealloc_node_align_noprof+0x19a/0x390
 add_sysfs_param+0x15f/0xb80
 kernel_add_sysfs_param+0x7f/0xe0
 param_sysfs_builtin+0x199/0x250
 param_sysfs_builtin_init+0x23/0x30
 do_one_initcall+0x250/0x870
 do_initcall_level+0x10a/0x1a0
 do_initcalls+0x59/0xa0
 kernel_init_freeable+0x29d/0x3e0
page last free pid 9 tgid 9 ts 10970419393 stack trace:
 __free_frozen_pages+0xc93/0xd90
 kasan_depopulate_vmalloc_pte+0x6d/0x90
 __apply_to_page_range+0xbd8/0x1420
 __kasan_release_vmalloc+0xa2/0xd0
 purge_vmap_node+0x220/0x960
 __purge_vmap_area_lazy+0x783/0xb40
 drain_vmap_area_work+0x27/0x40
 process_scheduled_works+0xc3d/0x1630
 worker_thread+0xa47/0xfb0
 kthread+0x38b/0x480
 ret_from_fork+0x514/0xb70
 ret_from_fork_asm+0x1a/0x30

Memory state around the buggy address:
 ffff888116dae700: fa fb fb fb fb fb fb fb fc fc fc fc fc fc fc fc
 ffff888116dae780: fa fb fb fb fb fb fb fb fc fc fc fc fc fc fc fc
>ffff888116dae800: fa fb fb fb fb fb fb fb fc fc fc fc fc fc fc fc
                   ^
 ffff888116dae880: fa fb fb fb fb fb fb fb fc fc fc fc fc fc fc fc
 ffff888116dae900: 00 00 00 00 00 00 fc fc fc fc fc fc fc fc fc fc
==================================================================


***

KASAN: slab-use-after-free Read in append_radio_msg

tree:      wireless-next
URL:       https://kernel.googlesource.com/pub/scm/linux/kernel/git/wireless/wireless-next.git
base:      fbfa27d9b06f025c5f2cfa79d0e01e6400eeff2a
arch:      amd64
compiler:  Debian clang version 22.1.8 (++20260613092233+e80beda6e255-1~exp1~20260613092250.77), Debian LLD 22.1.8
config:    https://ci.syzbot.org/builds/2d1bce7d-9b9b-4d15-9fb8-ca75e747b223/config
syz repro: https://ci.syzbot.org/findings/32e84c9a-2451-4ee9-8f84-a781e0011961/syz_repro

==================================================================
BUG: KASAN: slab-use-after-free in strlen+0x57/0x70 lib/string.c:402
Read of size 1 at addr ffff8881157eac40 by task syz.1.20/5852

CPU: 0 UID: 0 PID: 5852 Comm: syz.1.20 Not tainted syzkaller #0 PREEMPT(full) 
Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS 1.16.2-debian-1.16.2-1 04/01/2014
Call Trace:
 <TASK>
 dump_stack_lvl+0xe8/0x150 lib/dump_stack.c:120
 print_address_description+0x55/0x1e0 mm/kasan/report.c:378
 print_report+0x58/0x70 mm/kasan/report.c:482
 kasan_report+0x117/0x150 mm/kasan/report.c:595
 strlen+0x57/0x70 lib/string.c:402
 __fortify_strlen include/linux/fortify-string.h:218 [inline]
 append_radio_msg+0x3cc/0x5f0 drivers/net/wireless/virtual/mac80211_hwsim_main.c:4484
 hwsim_mcast_new_radio drivers/net/wireless/virtual/mac80211_hwsim_main.c:4519 [inline]
 mac80211_hwsim_new_radio+0x41cd/0x5750 drivers/net/wireless/virtual/mac80211_hwsim_main.c:6243
 hwsim_new_radio_nl+0xd8b/0xf90 drivers/net/wireless/virtual/mac80211_hwsim_main.c:7061
 genl_family_rcv_msg_doit+0x233/0x340 net/netlink/genetlink.c:1114
 genl_family_rcv_msg net/netlink/genetlink.c:1194 [inline]
 genl_rcv_msg+0x614/0x7a0 net/netlink/genetlink.c:1209
 netlink_rcv_skb+0x226/0x4a0 net/netlink/af_netlink.c:2572
 genl_rcv+0x28/0x40 net/netlink/genetlink.c:1218
 netlink_unicast_kernel net/netlink/af_netlink.c:1335 [inline]
 netlink_unicast+0x7bd/0x940 net/netlink/af_netlink.c:1361
 netlink_sendmsg+0x813/0xb40 net/netlink/af_netlink.c:1916
 sock_sendmsg_nosec+0x14e/0x190 net/socket.c:800
 __sock_sendmsg net/socket.c:818 [inline]
 ____sys_sendmsg+0x54e/0x850 net/socket.c:2715
 ___sys_sendmsg+0x2a5/0x360 net/socket.c:2769
 __sys_sendmsg net/socket.c:2801 [inline]
 __do_sys_sendmsg net/socket.c:2806 [inline]
 __se_sys_sendmsg net/socket.c:2804 [inline]
 __x64_sys_sendmsg+0x1b1/0x290 net/socket.c:2804
 do_syscall_x64 arch/x86/entry/syscall_64.c:61 [inline]
 do_syscall_64+0x166/0x520 arch/x86/entry/syscall_64.c:84
 entry_SYSCALL_64_after_hwframe+0x77/0x7f
RIP: 0033:0x7fd7e8f9e1d9
Code: ff c3 66 2e 0f 1f 84 00 00 00 00 00 0f 1f 44 00 00 48 89 f8 48 89 f7 48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 ff ff 73 01 c3 48 c7 c1 e8 ff ff ff f7 d8 64 89 01 48
RSP: 002b:00007fd7e9e0b028 EFLAGS: 00000246 ORIG_RAX: 000000000000002e
RAX: ffffffffffffffda RBX: 00007fd7e9225fa0 RCX: 00007fd7e8f9e1d9
RDX: 0000000000000000 RSI: 0000200000000040 RDI: 0000000000000004
RBP: 00007fd7e9035888 R08: 0000000000000000 R09: 0000000000000000
R10: 0000000000000000 R11: 0000000000000246 R12: 0000000000000000
R13: 00007fd7e9226038 R14: 00007fd7e9225fa0 R15: 00007ffc32258e48
 </TASK>

Allocated by task 5852:
 kasan_save_stack mm/kasan/common.c:57 [inline]
 kasan_save_track+0x3e/0x80 mm/kasan/common.c:78
 poison_kmalloc_redzone mm/kasan/common.c:409 [inline]
 __kasan_kmalloc+0x93/0xb0 mm/kasan/common.c:426
 kasan_kmalloc include/linux/kasan.h:263 [inline]
 __do_kmalloc_node mm/slub.c:5414 [inline]
 __kmalloc_node_track_caller_noprof+0x4b4/0x720 mm/slub.c:5545
 __kmemdup_nul mm/util.c:64 [inline]
 kstrdup+0x42/0x100 mm/util.c:84
 kobject_set_name_vargs+0x61/0x110 lib/kobject.c:274
 dev_set_name+0xe2/0x140 drivers/base/core.c:3564
 wiphy_new_nm+0x710/0x1ae0 net/wireless/core.c:665
 ieee80211_alloc_hw_nm+0x3f3/0x1f00 net/mac80211/main.c:858
 mac80211_hwsim_new_radio+0x1ea/0x5750 drivers/net/wireless/virtual/mac80211_hwsim_main.c:5747
 hwsim_new_radio_nl+0xd8b/0xf90 drivers/net/wireless/virtual/mac80211_hwsim_main.c:7061
 genl_family_rcv_msg_doit+0x233/0x340 net/netlink/genetlink.c:1114
 genl_family_rcv_msg net/netlink/genetlink.c:1194 [inline]
 genl_rcv_msg+0x614/0x7a0 net/netlink/genetlink.c:1209
 netlink_rcv_skb+0x226/0x4a0 net/netlink/af_netlink.c:2572
 genl_rcv+0x28/0x40 net/netlink/genetlink.c:1218
 netlink_unicast_kernel net/netlink/af_netlink.c:1335 [inline]
 netlink_unicast+0x7bd/0x940 net/netlink/af_netlink.c:1361
 netlink_sendmsg+0x813/0xb40 net/netlink/af_netlink.c:1916
 sock_sendmsg_nosec+0x14e/0x190 net/socket.c:800
 __sock_sendmsg net/socket.c:818 [inline]
 ____sys_sendmsg+0x54e/0x850 net/socket.c:2715
 ___sys_sendmsg+0x2a5/0x360 net/socket.c:2769
 __sys_sendmsg net/socket.c:2801 [inline]
 __do_sys_sendmsg net/socket.c:2806 [inline]
 __se_sys_sendmsg net/socket.c:2804 [inline]
 __x64_sys_sendmsg+0x1b1/0x290 net/socket.c:2804
 do_syscall_x64 arch/x86/entry/syscall_64.c:61 [inline]
 do_syscall_64+0x166/0x520 arch/x86/entry/syscall_64.c:84
 entry_SYSCALL_64_after_hwframe+0x77/0x7f

Freed by task 5852:
 kasan_save_stack mm/kasan/common.c:57 [inline]
 kasan_save_track+0x3e/0x80 mm/kasan/common.c:78
 kasan_save_free_info+0x40/0x50 mm/kasan/generic.c:584
 poison_slab_object mm/kasan/common.c:264 [inline]
 __kasan_slab_free+0x5c/0x80 mm/kasan/common.c:296
 kasan_slab_free include/linux/kasan.h:235 [inline]
 slab_free_hook mm/slub.c:2748 [inline]
 slab_free mm/slub.c:6509 [inline]
 kfree+0x1c5/0x650 mm/slub.c:6802
 kobject_set_name_vargs+0xca/0x110 lib/kobject.c:293
 dev_set_name+0xe2/0x140 drivers/base/core.c:3564
 wiphy_register+0x214e/0x3290 net/wireless/core.c:1227
 ieee80211_register_hw+0x3d72/0x4b30 net/mac80211/main.c:1634
 mac80211_hwsim_new_radio+0x3284/0x5750 drivers/net/wireless/virtual/mac80211_hwsim_main.c:6188
 hwsim_new_radio_nl+0xd8b/0xf90 drivers/net/wireless/virtual/mac80211_hwsim_main.c:7061
 genl_family_rcv_msg_doit+0x233/0x340 net/netlink/genetlink.c:1114
 genl_family_rcv_msg net/netlink/genetlink.c:1194 [inline]
 genl_rcv_msg+0x614/0x7a0 net/netlink/genetlink.c:1209
 netlink_rcv_skb+0x226/0x4a0 net/netlink/af_netlink.c:2572
 genl_rcv+0x28/0x40 net/netlink/genetlink.c:1218
 netlink_unicast_kernel net/netlink/af_netlink.c:1335 [inline]
 netlink_unicast+0x7bd/0x940 net/netlink/af_netlink.c:1361
 netlink_sendmsg+0x813/0xb40 net/netlink/af_netlink.c:1916
 sock_sendmsg_nosec+0x14e/0x190 net/socket.c:800
 __sock_sendmsg net/socket.c:818 [inline]
 ____sys_sendmsg+0x54e/0x850 net/socket.c:2715
 ___sys_sendmsg+0x2a5/0x360 net/socket.c:2769
 __sys_sendmsg net/socket.c:2801 [inline]
 __do_sys_sendmsg net/socket.c:2806 [inline]
 __se_sys_sendmsg net/socket.c:2804 [inline]
 __x64_sys_sendmsg+0x1b1/0x290 net/socket.c:2804
 do_syscall_x64 arch/x86/entry/syscall_64.c:61 [inline]
 do_syscall_64+0x166/0x520 arch/x86/entry/syscall_64.c:84
 entry_SYSCALL_64_after_hwframe+0x77/0x7f

The buggy address belongs to the object at ffff8881157eac40
 which belongs to the cache kmalloc-16 of size 16
The buggy address is located 0 bytes inside of
 freed 16-byte region [ffff8881157eac40, ffff8881157eac50)

The buggy address belongs to the physical page:
page: refcount:0 mapcount:0 mapping:0000000000000000 index:0xffff8881157ea2c0 pfn:0x1157ea
flags: 0x17ff00000000200(workingset|node=0|zone=2|lastcpupid=0x7ff)
page_type: f5(slab)
raw: 017ff00000000200 ffff888100041640 ffffea00045d6b10 ffffea000415b550
raw: ffff8881157ea2c0 000000000080007f 00000000f5000000 0000000000000000
page dumped because: kasan: bad access detected
page_owner tracks the page as allocated
page last allocated via order 0, migratetype Unmovable, gfp_mask 0xd2cc0(GFP_KERNEL|__GFP_NOWARN|__GFP_NORETRY|__GFP_COMP|__GFP_NOMEMALLOC), pid 1, tgid 1 (swapper/0), ts 9509757778
 create_dummy_stack mm/page_owner.c:121 [inline]
 register_dummy_stack+0x98/0x100 mm/page_owner.c:127
 init_page_owner+0x2e/0x600 mm/page_owner.c:145
 invoke_init_callbacks mm/page_ext.c:152 [inline]
 page_ext_init+0x511/0x550 mm/page_ext.c:485
 mm_core_init+0x97/0xb0 mm/mm_init.c:2685
page_owner free stack trace missing

Memory state around the buggy address:
 ffff8881157eab00: 00 01 fc fc 00 00 fc fc 00 01 fc fc 00 01 fc fc
 ffff8881157eab80: 00 00 fc fc 00 00 fc fc fa fb fc fc fa fb fc fc
>ffff8881157eac00: fa fb fc fc 00 01 fc fc fa fb fc fc fa fb fc fc
                                           ^
 ffff8881157eac80: 00 02 fc fc 00 02 fc fc 00 00 fc fc 00 00 fc fc
 ffff8881157ead00: 00 00 fc fc 00 00 fc fc 00 00 fc fc 00 02 fc fc
==================================================================


***

If these findings have caused you to resend the series or submit a
separate fix, please add the following tag to your commit message:
  Tested-by: syzbot@syzkaller.appspotmail.com

---
This report is generated by a bot. It may contain errors.
syzbot ci engineers can be reached at syzkaller@googlegroups.com.

To test a fix for this bug, please reply with `#syz test`
(on a separate line) and attach the patch to the email.

Notes:
- The patch will be applied on top of the tested series (as an
  incremental fix).
- To test a new version of the whole series, please send it directly
  to syzbot@lists.linux.dev.
- Arguments like custom git repos and branches are not supported.
