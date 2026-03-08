Received: from mail-ot1-f53.google.com (mail-ot1-f53.google.com [209.85.210.53])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DC7D96FC3
	for <syzbot@lists.linux.dev>; Sun,  8 Mar 2026 13:18:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.210.53
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772975895; cv=pass; b=YvVG/CEpXCWLvvukgOM+SZdU1199qsLiwpvdUm8xp+FYMU27QpV2118VpyUwr/5oTlTSZ8NZkH1jaJFUKhiHk3uc8eC3vmMGv5Lx3V0cut+dIj6ClclpSYd3r8KBb+Yypexghri9FkiNi49ffY4bN0rWAuf7hj/PVqfVn0c+9Xg=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772975895; c=relaxed/simple;
	bh=H7cgT9KvxHBDpgXYs4xkWGS3yKVSZrp3tv/TaWi+ewo=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=V63+oSHoD1o9KjVyDm8OqO++AL0+oUSKWOaqmtMRdUxOlJPnyORrOE7rkzK4p5tpDH+GNI7zWoPaLPIOZTCqSF0gG36NccV/SxLPw/PzhFys9Wb9FnlNlhcfG+e6Slx6sjY82RhlJI6ybWPl+TqgBO0TEqT9t7kICcrUZu/C/yM=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=kcGrbNor; arc=pass smtp.client-ip=209.85.210.53
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="kcGrbNor"
Received: by mail-ot1-f53.google.com with SMTP id 46e09a7af769-7d598f60eeaso8345181a34.2
        for <syzbot@lists.linux.dev>; Sun, 08 Mar 2026 06:18:13 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1772975893; cv=none;
        d=google.com; s=arc-20240605;
        b=LH7niLGu8DZHCVBm39I847XutTIWdVn+L0KWlpq/zXAwqFKxBD/k0MYlYkO3qU8lT0
         HD7Z2XyD5Ca3Oqw5xFerjnYg1WpPHqh0xU0/08LilqVZ4dsmgNdhVTB72UJdzNJW3eo+
         uG+Z5ly/7s38pH8SY638h7s6A3yVITw0VimcLZR6/V/kFP9CNbUr2zd2XeMZImql0Kwu
         VlFrBu/+B3SqTh5NBE4CooLtOgrFqZ2B481ChaFWuCSIDWL/po/rV2I+Hi/5iKe1dkMt
         W6GyckGwN36jcz38dDJdLznu9Xb5KVqgWnO808pJT7h3030pB7WP65ny/URZi+3C2uHG
         SCxA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=+DzDbFqM6k3nwrNAwLfLKhtcDMl2kqDQU9U2u4hvN44=;
        fh=QPd/nWrWzw0R6WxCpOJYyjCv6xKkKicB1G3bXZn61io=;
        b=LMRt3GvjfIccmiRI/yNmIYFU/V5jGSuMWW8ljVg8yYERWGuRBfLR+zPnFkLBiJi15F
         NmCw/YwJSudLmzFivFVZ/haaMQcC9wqUfSCj0Cc0D+7iDPOxluoi0YISRlGuuw67TV3a
         XSrQy85Wfb1VbuUYatNGGJYfew1gxDHgwlhWoe46/kiGAH6jX9KQcB7k0NCu9gplMZ4n
         89EwW+knManrGQjoNUkjqKOVopPfJ6f+1sVvUBXXMUNspYIvj3DkI1KzumQN91dq1so2
         vGvxjuXQRiFIoW2YUWlYR/zerc67Cux1rgyoOeV0kLdTgSBwWBkCqiheieCMDDa9HCv1
         0YwA==;
        darn=lists.linux.dev
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1772975893; x=1773580693; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=+DzDbFqM6k3nwrNAwLfLKhtcDMl2kqDQU9U2u4hvN44=;
        b=kcGrbNor3fS4Ng8WYIR3xdfCpCR1EG1S0YDH0WjmQasySf5jZYonkC2uQoYKVS/o2o
         bX34U9HmzNxmlEPFiJbJEvSiMcOXrYtOw+QOlGwe6p/v4AdWRAm7FJ4HGsubIf4Kr8Qx
         Pl4lt0fdMc0WWpMcbaBw+gPySqaRybf5PkSQdk9XBmNGMDD7fcxPR+WHjSXaLrVrAnkn
         JQYz7NnOWiiUs7odej6aK6mV7kFwExhSE1k7xCqfOTCV4NH5blBYf8e8mwUFJxF5gp0k
         +gkqGYyBER8uE+Gb5DpG2E2LGAJ9nznDfPrwt95PeTqf7KiLyU2VAcJ0yWU8bUxh9bcZ
         uHVQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1772975893; x=1773580693;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=+DzDbFqM6k3nwrNAwLfLKhtcDMl2kqDQU9U2u4hvN44=;
        b=EdJc+NItMu47d6TDBd5CM26reL67tGJpnSnd4C1i4X45gosoCHbBf7WC7SpeoCqCXJ
         /euUyd5t2ML8gLAdm7TwrFuQGRksxsTFflA25afexd4mpIWXvvfQdSgDorzoloL69EaJ
         m3NrNLiG/pDfKsaPaK4+W4FLEA26y36ukXQQIopj+GptDTKU4hgItgXlr5sgULXLVBMO
         KFkbtS/dgw2MlrcH06fmgwtroB/4KNMlBtb+9NaW1QwPxOI/HcUs1PFI1Slvs5+uw/GV
         qE7BaKTHgObctHpHO88Xt2NlM/8M8Rt239aQnv4qk00K+hUXOhXJa1Q96RTSFtHUWcsV
         xMsw==
X-Forwarded-Encrypted: i=1; AJvYcCWSr9JypuRsAlGnRu92iMA3qhnyDojAGcdvyc4QfuZPHKaXUAE2rVU3UxJ1vRFAbPjPYek48VA=@lists.linux.dev
X-Gm-Message-State: AOJu0YzxfyaXThYrgU5d1JwO/lHyISOHKsQQwp0uSm98K2BbIgFLQOtW
	l8OqaYMi4ilHf2LWWmAmg7oW5oNA2kxyXFsspTzbO7AL60xMOsjYTUHFCDNgikSny5vdFg1DtAt
	YfBUL2Lbjb5e73cyrTcZnArqjajNJR0Rj28h7DOAv
X-Gm-Gg: ATEYQzzyE3+u3KPRJ62znLdyTu5R36aOhHm39f0qOQ9b+3o3zoxhhKnDCWvI9HKsZnZ
	9IXjEMj2/lnOJLEjHOd7uPiCzTzpEq83rZ611KsuG46FNpQo6tS9EyvRHO2gyl+WrUvLTOllfkc
	56kuGW3GLeycNjomt9SVJMvLFcA7SYpiEssXplqaW4/YNLKlMJsfeQmu9OrG6FIDIAobuHlWU9m
	5TNcTeSyNr4K0Q5uRZhGKVjqPNE3oBnprX+DG5EcfvgW1MLhPEgWdrMeLCv6kqC2rMwQt5isUe7
	il26wCwZ/mf+UAXrwvUwkaeWOquO0xRt9tP2KwQI
X-Received: by 2002:a05:6820:201b:b0:662:f0cb:84bf with SMTP id
 006d021491bc7-67b9bd15fedmr5284335eaf.36.1772975892314; Sun, 08 Mar 2026
 06:18:12 -0700 (PDT)
Precedence: bulk
X-Mailing-List: syzbot@lists.linux.dev
List-Id: <syzbot.lists.linux.dev>
List-Subscribe: <mailto:syzbot+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:syzbot+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <69ad47be.050a0220.310d8.000a.GAE@google.com>
In-Reply-To: <69ad47be.050a0220.310d8.000a.GAE@google.com>
From: Aleksandr Nogikh <nogikh@google.com>
Date: Sun, 8 Mar 2026 13:18:01 +0000
X-Gm-Features: AaiRm53yGZqbyRsy8pbEXqIU5gxwxZdSeVcPRETovm8IcU-S3-RxzNQS-hL4svo
Message-ID: <CANp29Y7J-sGpKuqBQww7ynnTQkr-JebjLutnJEvhMxSSzpLL6Q@mail.gmail.com>
Subject: Re: [moderation/CI] Re: genetlink: apply reject policy for split ops
 on the dispatch path
To: syzbot ci <syzbot+ci1386686723ca79d9@syzkaller.appspotmail.com>
Cc: syzkaller-upstream-moderation@googlegroups.com, syzbot@lists.linux.dev
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

#syz upstream

On Sun, Mar 8, 2026 at 9:56=E2=80=AFAM syzbot ci
<syzbot+ci1386686723ca79d9@syzkaller.appspotmail.com> wrote:
>
> syzbot ci has tested the following series
>
> [v1] genetlink: apply reject policy for split ops on the dispatch path
> https://lore.kernel.org/all/20260307204425.1900467-1-kuba@kernel.org
> * [PATCH net-next 1/2] genetlink: apply reject policy for split ops on th=
e dispatch path
> * [PATCH net-next 2/2] selftests: net: make sure that Netlink rejects unk=
nown attrs in dump
>
> and found the following issue:
> KASAN: slab-out-of-bounds Read in devlink_nl_dumpit
>
> Full report is available here:
> https://ci.syzbot.org/series/cced225b-516e-4f54-b4f2-57afc46c5c2a
>
> ***
>
> KASAN: slab-out-of-bounds Read in devlink_nl_dumpit
>
> tree:      net-next
> URL:       https://kernel.googlesource.com/pub/scm/linux/kernel/git/netde=
v/net-next.git
> base:      0bcac7b11262557c990da1ac564d45777eb6b005
> arch:      amd64
> compiler:  Debian clang version 21.1.8 (++20251221033036+2078da43e25a-1~e=
xp1~20251221153213.50), Debian LLD 21.1.8
> config:    https://ci.syzbot.org/builds/4ea10ec3-e985-401a-a2b5-87b89ca3a=
776/config
> C repro:   https://ci.syzbot.org/findings/c23aee43-2180-46d5-93cb-e8c1cbc=
b1c39/c_repro
> syz repro: https://ci.syzbot.org/findings/c23aee43-2180-46d5-93cb-e8c1cbc=
b1c39/syz_repro
>
> =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
> BUG: KASAN: slab-out-of-bounds in devlink_nl_dumpit+0x2a4/0x410 net/devli=
nk/netlink.c:355
> Read of size 8 at addr ffff88810a48eab0 by task syz.0.17/5954
>
> CPU: 0 UID: 0 PID: 5954 Comm: syz.0.17 Not tainted syzkaller #0 PREEMPT(f=
ull)
> Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS 1.16.2-debian-1.=
16.2-1 04/01/2014
> Call Trace:
>  <TASK>
>  dump_stack_lvl+0xe8/0x150 lib/dump_stack.c:120
>  print_address_description mm/kasan/report.c:378 [inline]
>  print_report+0xba/0x230 mm/kasan/report.c:482
>  kasan_report+0x117/0x150 mm/kasan/report.c:595
>  devlink_nl_dumpit+0x2a4/0x410 net/devlink/netlink.c:355
>  genl_dumpit+0x10b/0x1b0 net/netlink/genetlink.c:1027
>  netlink_dump+0x722/0xe80 net/netlink/af_netlink.c:2325
>  __netlink_dump_start+0x5cb/0x7e0 net/netlink/af_netlink.c:2440
>  genl_family_rcv_msg_dumpit+0x213/0x310 net/netlink/genetlink.c:1076
>  genl_family_rcv_msg net/netlink/genetlink.c:1192 [inline]
>  genl_rcv_msg+0x5e8/0x7a0 net/netlink/genetlink.c:1210
>  netlink_rcv_skb+0x232/0x4b0 net/netlink/af_netlink.c:2550
>  genl_rcv+0x28/0x40 net/netlink/genetlink.c:1219
>  netlink_unicast_kernel net/netlink/af_netlink.c:1318 [inline]
>  netlink_unicast+0x80f/0x9b0 net/netlink/af_netlink.c:1344
>  netlink_sendmsg+0x813/0xb40 net/netlink/af_netlink.c:1894
>  sock_sendmsg_nosec net/socket.c:727 [inline]
>  __sock_sendmsg net/socket.c:742 [inline]
>  ____sys_sendmsg+0x972/0x9f0 net/socket.c:2591
>  ___sys_sendmsg+0x2a5/0x360 net/socket.c:2645
>  __sys_sendmsg net/socket.c:2677 [inline]
>  __do_sys_sendmsg net/socket.c:2682 [inline]
>  __se_sys_sendmsg net/socket.c:2680 [inline]
>  __x64_sys_sendmsg+0x1bd/0x2a0 net/socket.c:2680
>  do_syscall_x64 arch/x86/entry/syscall_64.c:63 [inline]
>  do_syscall_64+0x14d/0xf80 arch/x86/entry/syscall_64.c:94
>  entry_SYSCALL_64_after_hwframe+0x77/0x7f
> RIP: 0033:0x7f6bf799c799
> Code: ff c3 66 2e 0f 1f 84 00 00 00 00 00 0f 1f 44 00 00 48 89 f8 48 89 f=
7 48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 ff=
 ff 73 01 c3 48 c7 c1 e8 ff ff ff f7 d8 64 89 01 48
> RSP: 002b:00007fff4b3c0b38 EFLAGS: 00000246 ORIG_RAX: 000000000000002e
> RAX: ffffffffffffffda RBX: 00007f6bf7c15fa0 RCX: 00007f6bf799c799
> RDX: 0000000000000000 RSI: 0000200000001780 RDI: 0000000000000003
> RBP: 00007f6bf7a32bd9 R08: 0000000000000000 R09: 0000000000000000
> R10: 0000000000000000 R11: 0000000000000246 R12: 0000000000000000
> R13: 00007f6bf7c15fac R14: 00007f6bf7c15fa0 R15: 00007f6bf7c15fa0
>  </TASK>
>
> Allocated by task 5954:
>  kasan_save_stack mm/kasan/common.c:57 [inline]
>  kasan_save_track+0x3e/0x80 mm/kasan/common.c:78
>  poison_kmalloc_redzone mm/kasan/common.c:398 [inline]
>  __kasan_kmalloc+0x93/0xb0 mm/kasan/common.c:415
>  kasan_kmalloc include/linux/kasan.h:263 [inline]
>  __do_kmalloc_node mm/slub.c:5238 [inline]
>  __kmalloc_noprof+0x35c/0x760 mm/slub.c:5250
>  kmalloc_noprof include/linux/slab.h:954 [inline]
>  genl_family_rcv_msg_attrs_parse+0xa3/0x2a0 net/netlink/genetlink.c:941
>  genl_start+0x180/0x6c0 net/netlink/genetlink.c:980
>  __netlink_dump_start+0x469/0x7e0 net/netlink/af_netlink.c:2431
>  genl_family_rcv_msg_dumpit+0x213/0x310 net/netlink/genetlink.c:1076
>  genl_family_rcv_msg net/netlink/genetlink.c:1192 [inline]
>  genl_rcv_msg+0x5e8/0x7a0 net/netlink/genetlink.c:1210
>  netlink_rcv_skb+0x232/0x4b0 net/netlink/af_netlink.c:2550
>  genl_rcv+0x28/0x40 net/netlink/genetlink.c:1219
>  netlink_unicast_kernel net/netlink/af_netlink.c:1318 [inline]
>  netlink_unicast+0x80f/0x9b0 net/netlink/af_netlink.c:1344
>  netlink_sendmsg+0x813/0xb40 net/netlink/af_netlink.c:1894
>  sock_sendmsg_nosec net/socket.c:727 [inline]
>  __sock_sendmsg net/socket.c:742 [inline]
>  ____sys_sendmsg+0x972/0x9f0 net/socket.c:2591
>  ___sys_sendmsg+0x2a5/0x360 net/socket.c:2645
>  __sys_sendmsg net/socket.c:2677 [inline]
>  __do_sys_sendmsg net/socket.c:2682 [inline]
>  __se_sys_sendmsg net/socket.c:2680 [inline]
>  __x64_sys_sendmsg+0x1bd/0x2a0 net/socket.c:2680
>  do_syscall_x64 arch/x86/entry/syscall_64.c:63 [inline]
>  do_syscall_64+0x14d/0xf80 arch/x86/entry/syscall_64.c:94
>  entry_SYSCALL_64_after_hwframe+0x77/0x7f
>
> The buggy address belongs to the object at ffff88810a48eaa0
>  which belongs to the cache kmalloc-16 of size 16
> The buggy address is located 0 bytes to the right of
>  allocated 16-byte region [ffff88810a48eaa0, ffff88810a48eab0)
>
> The buggy address belongs to the physical page:
> page: refcount:0 mapcount:0 mapping:0000000000000000 index:0x0 pfn:0x10a4=
8e
> flags: 0x17ff00000000000(node=3D0|zone=3D2|lastcpupid=3D0x7ff)
> page_type: f5(slab)
> raw: 017ff00000000000 ffff888100041640 dead000000000100 dead000000000122
> raw: 0000000000000000 0000000800800080 00000000f5000000 0000000000000000
> page dumped because: kasan: bad access detected
> page_owner tracks the page as allocated
> page last allocated via order 0, migratetype Unmovable, gfp_mask 0xd2cc0(=
GFP_KERNEL|__GFP_NOWARN|__GFP_NORETRY|__GFP_COMP|__GFP_NOMEMALLOC), pid 1, =
tgid 1 (swapper/0), ts 11308983860, free_ts 11289885463
>  create_dummy_stack mm/page_owner.c:103 [inline]
>  register_dummy_stack+0x98/0x100 mm/page_owner.c:109
>  init_page_owner+0x2e/0x600 mm/page_owner.c:127
>  invoke_init_callbacks mm/page_ext.c:152 [inline]
>  page_ext_init+0x500/0x540 mm/page_ext.c:490
>  mm_core_init+0x51/0x70 mm/mm_init.c:2735
> page last free pid 1 tgid 1 stack trace:
>  reset_page_owner include/linux/page_owner.h:25 [inline]
>  __free_pages_prepare mm/page_alloc.c:1433 [inline]
>  __free_frozen_pages+0xc2b/0xdb0 mm/page_alloc.c:2978
>  ___free_pages_bulk mm/kasan/shadow.c:333 [inline]
>  __kasan_populate_vmalloc_do mm/kasan/shadow.c:385 [inline]
>  __kasan_populate_vmalloc+0x137/0x1d0 mm/kasan/shadow.c:424
>  kasan_populate_vmalloc include/linux/kasan.h:580 [inline]
>  alloc_vmap_area+0xd73/0x14b0 mm/vmalloc.c:2129
>  __get_vm_area_node+0x1f8/0x300 mm/vmalloc.c:3232
>  get_vm_area_caller+0x82/0xb0 mm/vmalloc.c:3283
>  __ioremap_caller+0x3d7/0x620 arch/x86/mm/ioremap.c:292
>  pcim_iomap+0xde/0x2b0 drivers/pci/devres.c:548
>  ahci_init_one+0x99e/0x34b0 drivers/ata/ahci.c:1973
>  local_pci_probe drivers/pci/pci-driver.c:323 [inline]
>  pci_call_probe drivers/pci/pci-driver.c:385 [inline]
>  __pci_device_probe drivers/pci/pci-driver.c:446 [inline]
>  pci_device_probe+0x41a/0xc70 drivers/pci/pci-driver.c:480
>  call_driver_probe drivers/base/dd.c:-1 [inline]
>  really_probe+0x267/0xaf0 drivers/base/dd.c:661
>  __driver_probe_device+0x18c/0x320 drivers/base/dd.c:803
>  driver_probe_device+0x4f/0x240 drivers/base/dd.c:833
>  __driver_attach+0x3e7/0x710 drivers/base/dd.c:1227
>  bus_for_each_dev+0x23b/0x2c0 drivers/base/bus.c:383
>  bus_add_driver+0x345/0x670 drivers/base/bus.c:715
>  driver_register+0x23a/0x320 drivers/base/driver.c:249
>
> Memory state around the buggy address:
>  ffff88810a48e980: fa fb fc fc 00 00 fc fc fa fb fc fc fa fb fc fc
>  ffff88810a48ea00: fa fb fc fc fa fb fc fc fa fb fc fc fa fb fc fc
> >ffff88810a48ea80: fa fb fc fc 00 00 fc fc 00 06 fc fc 00 00 fc fc
>                                      ^
>  ffff88810a48eb00: fa fb fc fc 00 00 fc fc 00 00 fc fc fa fb fc fc
>  ffff88810a48eb80: 00 00 fc fc 00 00 fc fc fa fb fc fc 00 00 fc fc
> =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
>
>
> ***
>
> If these findings have caused you to resend the series or submit a
> separate fix, please add the following tag to your commit message:
>   Tested-by: syzbot@syzkaller.appspotmail.com
>
> ---
> This report is generated by a bot. It may contain errors.
> syzbot ci engineers can be reached at syzkaller@googlegroups.com.
>
> The email will later be sent to:
> [alok.a.tiwari@oracle.com andrew@lunn.ch davem@davemloft.net edumazet@goo=
gle.com horms@kernel.org kees@kernel.org kuba@kernel.org linux-kselftest@vg=
er.kernel.org netdev@vger.kernel.org pabeni@redhat.com shuah@kernel.org]
>
> If the report looks fine to you, reply with:
> #syz upstream
>
> If the report is a false positive, reply with
> #syz invalid
>
> --
> You received this message because you are subscribed to the Google Groups=
 "syzkaller-upstream-moderation" group.
> To unsubscribe from this group and stop receiving emails from it, send an=
 email to syzkaller-upstream-moderation+unsubscribe@googlegroups.com.
> To view this discussion visit https://groups.google.com/d/msgid/syzkaller=
-upstream-moderation/69ad47be.050a0220.310d8.000a.GAE%40google.com.
