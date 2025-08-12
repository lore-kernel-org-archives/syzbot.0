Received: from mail-pl1-f170.google.com (mail-pl1-f170.google.com [209.85.214.170])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6170C2D6E62
	for <syzbot@lists.linux.dev>; Tue, 12 Aug 2025 07:42:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.170
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1754984554; cv=none; b=tAEW7HE2mL3PIALW1SDzQ5edhSMUAn9oYMzRotU+CSExFlkrZ7tnvZqe0ytbQ9XwIYU+CqXp3nyaNCivxaBUhzTcFRwPiGbu10yeg7tb3R3vPAMriitrtI7aeAxTZZfbV7vEpypXBoDL39qY/UAEKXDTi6Aly/hXNEc/bqDnyxo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1754984554; c=relaxed/simple;
	bh=W0+P9Iy4nxqQT8tc20E1yrQw4b3DVd78cZJtmcyz9GY=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=YyFyBSBtD058ofb4bvV0hcfEAA5Kx2+xKfFVhEg81EDGASMNXBjZYJQeSjCnHKHUWiT44O5LZxZMZOP6DAojde8ZB6vhvBRo6UjB/vdKc090D1dsLJlASHABFIo/u57RrdBiTZ/LoDmTfDNmgXMokndAB6dzD0rI5EHU997//8g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=S+sR42aC; arc=none smtp.client-ip=209.85.214.170
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="S+sR42aC"
Received: by mail-pl1-f170.google.com with SMTP id d9443c01a7336-2401b855980so37779985ad.1
        for <syzbot@lists.linux.dev>; Tue, 12 Aug 2025 00:42:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1754984552; x=1755589352; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=5hg5DDixi59JNxLUoIAvRxX3Ph3TLCnZsbFJVByhvs0=;
        b=S+sR42aCpSWekI/1hD/XumZIY/N4MMoWU6ZNwixpak2OS6cu1SnaRIFSY2pmeoXQsF
         C6M27jTxKnAUGOZTZICMLrSn3FMzAUg1OuagbbQP7XBjS/b5saIY8oZ8yO8S0sLDgMKQ
         9ys6F6irv2xQ/osobwQWIH/bpn0utE4wTDYwNjvzrvxbW7eLImwHdf/5x31juxvc95BW
         2Cwk3eHhRItg9fU63fuf0VjMZDKFDtmurgFzabrtf9xBa8BImUUBVyR+ZhPW2wVaZTNO
         q53R+gGJn07EkK7v/ZE+tZ9phdDXKHJXWofe0W6rPuYZ8zXh4nZZftbdQ/EFm4SO2tWj
         Q2XA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1754984552; x=1755589352;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=5hg5DDixi59JNxLUoIAvRxX3Ph3TLCnZsbFJVByhvs0=;
        b=K5c3pJgPoNllvCQwU0dEfDQ9g5eql9SKoWLoL7u0DT4wZ0rtpY3+1oCBpfOWIcVGue
         +X8JtavoGuPxISmu+vvBvNN82qj9Z0ByY6y2NtKY3ezKEJIJR+sHFKMO8cdEynPyQo88
         jvLZ45iki5YqUY1OnYPI02YsQ97qpS+seU2fTEMFiYj54HcHgNuN/vnHclUevsDa2kjJ
         rLAADY3mE8XXWEZ16BXXRBBOiXHZpoXKbtYwu1uGifXUsdMZOjxLEBlAxkkvFk2FWQGx
         fuT2JvjwoukCXTyCEq6INN2secw8RbUIHPdcTFleo0CBEd8uc6Djpq9P7CsGrzp9rFXE
         f0/Q==
X-Forwarded-Encrypted: i=1; AJvYcCUlx8EuIkXmkluHO5OWCsKRp+xwT8BhxnuStOtW5VpVzh8AmLRMRbZQk1hwJN3XLCQCkJnxLHY=@lists.linux.dev
X-Gm-Message-State: AOJu0YxLGqLam0PXghg/5aoVjtBgz+DBFM7AsrkXy1BtfliYbCgaN7XW
	pAviUfeEzJRfliexOAlmOciiOocWD36a2hAiYQNMAPuanPX7gVWiZsniZuV8u45WLYP5pwpnMOS
	gLC2320PW3qlEKc6AL8WMWCtnumxZTL2uOpZFGoCd
X-Gm-Gg: ASbGncsL7JvV6gHtKyCkhkYHQqq80B3g3NAr1gpXXDWSOLfQn07Mj9h5+wJWRQ5Yykv
	Bem66cVesPfoE9NzcSps/JKmqqa2bUuFIiBvlcnmDx8M2j4GYAXmJiTRJSOF1u/iiMkG9Kr8xOC
	rTlyCp1CRyCKKHJVd7ci9TtlBiw0rHKw0IFLOZNY2wvhPj0NF/Pxo+E2x4IV1TFSTFTQ8oIEO92
	kiZKoCPXx3JZfwpB+OvhOlLKvYASgRyYvENKJdQ/JI5TfY=
X-Google-Smtp-Source: AGHT+IEG1Sz+AweOuzkHVWJaifC/Pa+3++9JX+BOph0PVfyACmPqKlESepOst+evF8TGaAba2dCH1yo9oY4clKDa3Qk=
X-Received: by 2002:a17:903:2408:b0:234:914b:3841 with SMTP id
 d9443c01a7336-242fc340444mr37800985ad.39.1754984551250; Tue, 12 Aug 2025
 00:42:31 -0700 (PDT)
Precedence: bulk
X-Mailing-List: syzbot@lists.linux.dev
List-Id: <syzbot.lists.linux.dev>
List-Subscribe: <mailto:syzbot+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:syzbot+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <689ae314.050a0220.51d73.00a8.GAE@google.com>
In-Reply-To: <689ae314.050a0220.51d73.00a8.GAE@google.com>
From: Aleksandr Nogikh <nogikh@google.com>
Date: Tue, 12 Aug 2025 09:42:19 +0200
X-Gm-Features: Ac12FXzOH2bdQBtR9kNWkHKEeS0fN7XFg8lYJHYr8qMrk2GjA1rvHQeDgRGLtGU
Message-ID: <CANp29Y7T=O=WrUuNrHcD0JP8tPL80bJr12NyAtXs7K+yxU5yDw@mail.gmail.com>
Subject: Re: [moderation/CI] Re: bonding: Extend arp_ip_target format to allow
 for a list of vlan tags.
To: syzbot ci <syzbot+ci551aec978050b0d2@syzkaller.appspotmail.com>
Cc: syzkaller-upstream-moderation@googlegroups.com, syzbot@lists.linux.dev
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

#syz upstream

On Tue, Aug 12, 2025 at 8:45=E2=80=AFAM syzbot ci
<syzbot+ci551aec978050b0d2@syzkaller.appspotmail.com> wrote:
>
> syzbot ci has tested the following series
>
> [v7] bonding: Extend arp_ip_target format to allow for a list of vlan tag=
s.
> https://lore.kernel.org/all/20250811231909.1827080-1-wilder@us.ibm.com
> * [PATCH net-next v7 1/7] bonding: Adding struct bond_arp_target
> * [PATCH net-next v7 2/7] bonding: Adding extra_len field to struct bond_=
opt_value.
> * [PATCH net-next v7 3/7] bonding: arp_ip_target helpers.
> * [PATCH net-next v7 4/7] bonding: Processing extended arp_ip_target from=
 user space.
> * [PATCH net-next v7 5/7] bonding: Update to bond_arp_send_all() to use s=
upplied vlan tags
> * [PATCH net-next v7 6/7] bonding: Update for extended arp_ip_target form=
at.
> * [PATCH net-next v7 7/7] bonding: Selftest and documentation for the arp=
_ip_target parameter.
>
> and found the following issue:
> KASAN: slab-out-of-bounds Read in bond_fill_info
>
> Full report is available here:
> https://ci.syzbot.org/series/e2badd49-adb7-4d2f-a61e-c1bb6f9c5b7d
>
> ***
>
> KASAN: slab-out-of-bounds Read in bond_fill_info
>
> tree:      net-next
> URL:       https://kernel.googlesource.com/pub/scm/linux/kernel/git/netde=
v/net-next.git
> base:      37816488247ddddbc3de113c78c83572274b1e2e
> arch:      amd64
> compiler:  Debian clang version 20.1.7 (++20250616065708+6146a88f6049-1~e=
xp1~20250616065826.132), Debian LLD 20.1.7
> config:    https://ci.syzbot.org/builds/ad5cc865-ec29-4575-99b3-58d480848=
dce/config
> C repro:   https://ci.syzbot.org/findings/fe0c0cc1-ce24-4a52-8132-577d6e4=
068f1/c_repro
> syz repro: https://ci.syzbot.org/findings/fe0c0cc1-ce24-4a52-8132-577d6e4=
068f1/syz_repro
>
> netlink: 24 bytes leftover after parsing attributes in process `syz.0.17'=
.
> =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
> BUG: KASAN: slab-out-of-bounds in bond_fill_info+0xc72/0x2280 drivers/net=
/bonding/bond_netlink.c:720
> Read of size 2 at addr ffff88810d4e36c6 by task syz.0.17/6010
>
> CPU: 1 UID: 0 PID: 6010 Comm: syz.0.17 Not tainted 6.16.0-syzkaller-12063=
-g37816488247d-dirty #0 PREEMPT(full)
> Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS 1.16.2-debian-1.=
16.2-1 04/01/2014
> Call Trace:
>  <TASK>
>  dump_stack_lvl+0x189/0x250 lib/dump_stack.c:120
>  print_address_description mm/kasan/report.c:378 [inline]
>  print_report+0xca/0x240 mm/kasan/report.c:482
>  kasan_report+0x118/0x150 mm/kasan/report.c:595
>  bond_fill_info+0xc72/0x2280 drivers/net/bonding/bond_netlink.c:720
>  rtnl_link_info_fill net/core/rtnetlink.c:900 [inline]
>  rtnl_link_fill+0x288/0x800 net/core/rtnetlink.c:921
>  rtnl_fill_ifinfo+0x17ca/0x1e70 net/core/rtnetlink.c:2133
>  rtmsg_ifinfo_build_skb+0x17d/0x260 net/core/rtnetlink.c:4401
>  rtmsg_ifinfo_event net/core/rtnetlink.c:4434 [inline]
>  rtmsg_ifinfo+0x8c/0x1a0 net/core/rtnetlink.c:4443
>  netif_state_change+0x29e/0x3a0 net/core/dev.c:1585
>  do_setlink+0x35de/0x41c0 net/core/rtnetlink.c:3390
>  rtnl_changelink net/core/rtnetlink.c:3761 [inline]
>  __rtnl_newlink net/core/rtnetlink.c:3920 [inline]
>  rtnl_newlink+0x160b/0x1c70 net/core/rtnetlink.c:4057
>  rtnetlink_rcv_msg+0x7cf/0xb70 net/core/rtnetlink.c:6946
>  netlink_rcv_skb+0x208/0x470 net/netlink/af_netlink.c:2552
>  netlink_unicast_kernel net/netlink/af_netlink.c:1320 [inline]
>  netlink_unicast+0x82f/0x9e0 net/netlink/af_netlink.c:1346
>  netlink_sendmsg+0x805/0xb30 net/netlink/af_netlink.c:1896
>  sock_sendmsg_nosec net/socket.c:714 [inline]
>  __sock_sendmsg+0x21c/0x270 net/socket.c:729
>  ____sys_sendmsg+0x505/0x830 net/socket.c:2614
>  ___sys_sendmsg+0x21f/0x2a0 net/socket.c:2668
>  __sys_sendmsg net/socket.c:2700 [inline]
>  __do_sys_sendmsg net/socket.c:2705 [inline]
>  __se_sys_sendmsg net/socket.c:2703 [inline]
>  __x64_sys_sendmsg+0x19b/0x260 net/socket.c:2703
>  do_syscall_x64 arch/x86/entry/syscall_64.c:63 [inline]
>  do_syscall_64+0xfa/0x3b0 arch/x86/entry/syscall_64.c:94
>  entry_SYSCALL_64_after_hwframe+0x77/0x7f
> RIP: 0033:0x7f536498ebe9
> Code: ff ff c3 66 2e 0f 1f 84 00 00 00 00 00 0f 1f 40 00 48 89 f8 48 89 f=
7 48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 ff=
 ff 73 01 c3 48 c7 c1 a8 ff ff ff f7 d8 64 89 01 48
> RSP: 002b:00007ffe69efd978 EFLAGS: 00000246 ORIG_RAX: 000000000000002e
> RAX: ffffffffffffffda RBX: 00007f5364bb5fa0 RCX: 00007f536498ebe9
> RDX: 0000000000000000 RSI: 0000200000000340 RDI: 0000000000000004
> RBP: 00007f5364a11e19 R08: 0000000000000000 R09: 0000000000000000
> R10: 0000000000000000 R11: 0000000000000246 R12: 0000000000000000
> R13: 00007f5364bb5fa0 R14: 00007f5364bb5fa0 R15: 0000000000000003
>  </TASK>
>
> Allocated by task 6010:
>  kasan_save_stack mm/kasan/common.c:47 [inline]
>  kasan_save_track+0x3e/0x80 mm/kasan/common.c:68
>  poison_kmalloc_redzone mm/kasan/common.c:388 [inline]
>  __kasan_kmalloc+0x93/0xb0 mm/kasan/common.c:405
>  kasan_kmalloc include/linux/kasan.h:260 [inline]
>  __do_kmalloc_node mm/slub.c:4365 [inline]
>  __kmalloc_noprof+0x27a/0x4f0 mm/slub.c:4377
>  kmalloc_noprof include/linux/slab.h:909 [inline]
>  bond_option_arp_ip_targets_set+0x227/0xbc0 drivers/net/bonding/bond_opti=
ons.c:1284
>  __bond_opt_set+0x27b/0xee0 drivers/net/bonding/bond_options.c:800
>  bond_changelink+0xa66/0x26d0 drivers/net/bonding/bond_netlink.c:300
>  rtnl_changelink net/core/rtnetlink.c:3721 [inline]
>  __rtnl_newlink net/core/rtnetlink.c:3920 [inline]
>  rtnl_newlink+0x1669/0x1c70 net/core/rtnetlink.c:4057
>  rtnetlink_rcv_msg+0x7cf/0xb70 net/core/rtnetlink.c:6946
>  netlink_rcv_skb+0x208/0x470 net/netlink/af_netlink.c:2552
>  netlink_unicast_kernel net/netlink/af_netlink.c:1320 [inline]
>  netlink_unicast+0x82f/0x9e0 net/netlink/af_netlink.c:1346
>  netlink_sendmsg+0x805/0xb30 net/netlink/af_netlink.c:1896
>  sock_sendmsg_nosec net/socket.c:714 [inline]
>  __sock_sendmsg+0x21c/0x270 net/socket.c:729
>  ____sys_sendmsg+0x505/0x830 net/socket.c:2614
>  ___sys_sendmsg+0x21f/0x2a0 net/socket.c:2668
>  __sys_sendmsg net/socket.c:2700 [inline]
>  __do_sys_sendmsg net/socket.c:2705 [inline]
>  __se_sys_sendmsg net/socket.c:2703 [inline]
>  __x64_sys_sendmsg+0x19b/0x260 net/socket.c:2703
>  do_syscall_x64 arch/x86/entry/syscall_64.c:63 [inline]
>  do_syscall_64+0xfa/0x3b0 arch/x86/entry/syscall_64.c:94
>  entry_SYSCALL_64_after_hwframe+0x77/0x7f
>
> The buggy address belongs to the object at ffff88810d4e36c0
>  which belongs to the cache kmalloc-8 of size 8
> The buggy address is located 6 bytes inside of
>  allocated 7-byte region [ffff88810d4e36c0, ffff88810d4e36c7)
>
> The buggy address belongs to the physical page:
> page: refcount:0 mapcount:0 mapping:0000000000000000 index:0xffff88810d4e=
31c0 pfn:0x10d4e3
> flags: 0x57ff00000000000(node=3D1|zone=3D2|lastcpupid=3D0x7ff)
> page_type: f5(slab)
> raw: 057ff00000000000 ffff88801a441500 dead000000000122 0000000000000000
> raw: ffff88810d4e31c0 000000008080006d 00000000f5000000 0000000000000000
> page dumped because: kasan: bad access detected
> page_owner tracks the page as allocated
> page last allocated via order 0, migratetype Unmovable, gfp_mask 0x52cc0(=
GFP_KERNEL|__GFP_NOWARN|__GFP_NORETRY|__GFP_COMP), pid 5954, tgid 5954 (syz=
-executor), ts 95720202696, free_ts 95706797594
>  set_page_owner include/linux/page_owner.h:32 [inline]
>  post_alloc_hook+0x240/0x2a0 mm/page_alloc.c:1851
>  prep_new_page mm/page_alloc.c:1859 [inline]
>  get_page_from_freelist+0x21e4/0x22c0 mm/page_alloc.c:3858
>  __alloc_frozen_pages_noprof+0x181/0x370 mm/page_alloc.c:5148
>  alloc_pages_mpol+0x232/0x4a0 mm/mempolicy.c:2416
>  alloc_slab_page mm/slub.c:2487 [inline]
>  allocate_slab+0x8a/0x370 mm/slub.c:2655
>  new_slab mm/slub.c:2709 [inline]
>  ___slab_alloc+0xbeb/0x1410 mm/slub.c:3891
>  __slab_alloc mm/slub.c:3981 [inline]
>  __slab_alloc_node mm/slub.c:4056 [inline]
>  slab_alloc_node mm/slub.c:4217 [inline]
>  __do_kmalloc_node mm/slub.c:4364 [inline]
>  __kmalloc_node_track_caller_noprof+0x2f8/0x4e0 mm/slub.c:4384
>  __kmemdup_nul mm/util.c:64 [inline]
>  kstrdup+0x42/0x100 mm/util.c:84
>  __kernfs_new_node+0x9c/0x7e0 fs/kernfs/dir.c:633
>  kernfs_new_node+0x102/0x210 fs/kernfs/dir.c:713
>  kernfs_create_dir_ns+0x44/0x130 fs/kernfs/dir.c:1083
>  sysfs_create_dir_ns+0x123/0x280 fs/sysfs/dir.c:59
>  create_dir lib/kobject.c:73 [inline]
>  kobject_add_internal+0x59f/0xb40 lib/kobject.c:240
>  kobject_add_varg lib/kobject.c:374 [inline]
>  kobject_add+0x155/0x220 lib/kobject.c:426
>  device_add+0x408/0xb50 drivers/base/core.c:3627
>  netdev_register_kobject+0x178/0x310 net/core/net-sysfs.c:2356
> page last free pid 5954 tgid 5954 stack trace:
>  reset_page_owner include/linux/page_owner.h:25 [inline]
>  free_pages_prepare mm/page_alloc.c:1395 [inline]
>  __free_frozen_pages+0xbc4/0xd30 mm/page_alloc.c:2895
>  __slab_free+0x303/0x3c0 mm/slub.c:4591
>  qlink_free mm/kasan/quarantine.c:163 [inline]
>  qlist_free_all+0x97/0x140 mm/kasan/quarantine.c:179
>  kasan_quarantine_reduce+0x148/0x160 mm/kasan/quarantine.c:286
>  __kasan_slab_alloc+0x22/0x80 mm/kasan/common.c:340
>  kasan_slab_alloc include/linux/kasan.h:250 [inline]
>  slab_post_alloc_hook mm/slub.c:4180 [inline]
>  slab_alloc_node mm/slub.c:4229 [inline]
>  __do_kmalloc_node mm/slub.c:4364 [inline]
>  __kmalloc_noprof+0x224/0x4f0 mm/slub.c:4377
>  kmalloc_noprof include/linux/slab.h:909 [inline]
>  kzalloc_noprof include/linux/slab.h:1039 [inline]
>  ops_init+0x7b/0x5c0 net/core/net_namespace.c:126
>  setup_net+0x10c/0x320 net/core/net_namespace.c:438
>  copy_net_ns+0x31b/0x4d0 net/core/net_namespace.c:570
>  create_new_namespaces+0x3f3/0x720 kernel/nsproxy.c:110
>  unshare_nsproxy_namespaces+0x11c/0x170 kernel/nsproxy.c:218
>  ksys_unshare+0x4c8/0x8c0 kernel/fork.c:3127
>  __do_sys_unshare kernel/fork.c:3198 [inline]
>  __se_sys_unshare kernel/fork.c:3196 [inline]
>  __x64_sys_unshare+0x38/0x50 kernel/fork.c:3196
>  do_syscall_x64 arch/x86/entry/syscall_64.c:63 [inline]
>  do_syscall_64+0xfa/0x3b0 arch/x86/entry/syscall_64.c:94
>  entry_SYSCALL_64_after_hwframe+0x77/0x7f
>
> Memory state around the buggy address:
>  ffff88810d4e3580: fa fc fc fc fa fc fc fc fa fc fc fc fa fc fc fc
>  ffff88810d4e3600: fa fc fc fc fa fc fc fc fa fc fc fc fa fc fc fc
> >ffff88810d4e3680: fa fc fc fc fa fc fc fc 07 fc fc fc fa fc fc fc
>                                            ^
>  ffff88810d4e3700: fa fc fc fc fa fc fc fc fa fc fc fc fa fc fc fc
>  ffff88810d4e3780: fa fc fc fc fa fc fc fc fa fc fc fc fa fc fc fc
> =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
>
>
> ***
>
> If these findings have caused you to resend the series or submit a
> separate fix, please add the following tag to your commit message:
> Tested-by: syzbot@syzkaller.appspotmail.com
>
> ---
> This report is generated by a bot. It may contain errors.
> syzbot ci engineers can be reached at syzkaller@googlegroups.com.
>
> The email will later be sent to:
> [amorenoz@redhat.com haliu@redhat.com horms@kernel.org i.maximets@ovn.org=
 jv@jvosburgh.net netdev@vger.kernel.org pradeep@us.ibm.com pradeeps@linux.=
vnet.ibm.com stephen@networkplumber.org wilder@us.ibm.com]
>
> If the report looks fine to you, reply with:
> #syz upstream
>
> --
> You received this message because you are subscribed to the Google Groups=
 "syzkaller-upstream-moderation" group.
> To unsubscribe from this group and stop receiving emails from it, send an=
 email to syzkaller-upstream-moderation+unsubscribe@googlegroups.com.
> To view this discussion visit https://groups.google.com/d/msgid/syzkaller=
-upstream-moderation/689ae314.050a0220.51d73.00a8.GAE%40google.com.
