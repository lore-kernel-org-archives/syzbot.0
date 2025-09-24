Received: from mail-ot1-f41.google.com (mail-ot1-f41.google.com [209.85.210.41])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 891822417C2
	for <syzbot@lists.linux.dev>; Wed, 24 Sep 2025 12:38:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.41
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758717511; cv=none; b=fnC2GC8anuA1Z2BNSmFiDI5wS+yUC0/2T8pfgCCaP3bYLGXCU9VvUs4OsjfxBqV5l+XCFmmXD3P+lkyQjr1h5WiXmmGEUDg7YasaXTXHMZRlsM9Za7R7FpYKH2UNh8tpD8IYSeWf6gbNscln+0cieL0uV9KmkwPxHB/+SFyYeCU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758717511; c=relaxed/simple;
	bh=w95FJKYRRhqy0ogLo4eLX78DB4IkuJkq/JZd7vNOvMM=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=mhVVbuSHHEisDUF9KkR6INBxWctjceEZx7AWH/BLDfRUTTES5W0ghdMEpzz52EiwuyAwdgNpDbEZGFs5Ul5YxlIKb1CTViEvR7cl0OLKHbY3VliDdgj8DPyQ18Iega6gCrtUiB51XQJLtM/553X1GUu8JttcevOe3XK8zjSOPoY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=T+QqDgqe; arc=none smtp.client-ip=209.85.210.41
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="T+QqDgqe"
Received: by mail-ot1-f41.google.com with SMTP id 46e09a7af769-797130a6df1so815742a34.2
        for <syzbot@lists.linux.dev>; Wed, 24 Sep 2025 05:38:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1758717508; x=1759322308; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=eBnUDoxMiUx7rbXh21j6AcW1YZGtNXya2floyIuB6QA=;
        b=T+QqDgqe2qksJ3UGjUeuupybw9RWxKbqN4v0IfPHj71vDGXQPp3Uv1+7D3MZuRxo2X
         F/7PmXI+7Vulq6FLLW2WIDrxJqrVh0Sh8tM2VnCHYxPfrvks95rruZLyaVHl/VsSFfKx
         w3hpdKAzWijKYFvfIZMtUOPywNkKsw6e5aFIg74wY4Y85bJIDABojPXfXT8c2Zzpw4F8
         AtJaEwKpA1Q7+8dzRIfTFpYJAOj4VizFoMpfkCgJCS5TnZXn0nOmGgmuanxfhDyLF/jD
         kiWC/b8808BoV9pEAB4K9Y2mlqXaAZtwm4iHPxrQHiW+ioJAub7lLSdZlQwR/n6Zf6En
         VUyA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1758717508; x=1759322308;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=eBnUDoxMiUx7rbXh21j6AcW1YZGtNXya2floyIuB6QA=;
        b=XWfde2IY2jZkgE0oTJnywEsqCtfixxxnlxKay1QUZ9CzTLFwg1yAKklJ8JmOQ0j9kW
         azEeK2Iwyckx56yKRrtA3b2hi9L61KPscJuylsAzHot5Hzxc0jfAU6Fuxgxdp3G3KPY1
         e9Sg+qnRAWsrFPlxsuftr2HJFF+W8KWfXPs+ubELavgX5TuOSsNZFoWtnUl7DMlOoN+g
         vmuYq8lTUaDnMI3fwJ8BOiOAGh5p9JR3fJIILLDKsPBAI7IhDmdbPT/D6+7xd/B+NJVv
         NJhUswNT9SRBx51aRDkKOW/LEkqEHEH8L27qm1EoY/7MbLZ25bjmAPU95i1plFHFoTHf
         8wyQ==
X-Forwarded-Encrypted: i=1; AJvYcCXFTww9Uh6I+Vpd1z7aDn/58wnXKdwQHihlHjxyc+IenEHb25kb4hLSpgvONy2zPbU8W/dkwuA=@lists.linux.dev
X-Gm-Message-State: AOJu0YzMeW/MJwCLGkEzOV8cjjfoO3W3nS1IA+AXS7lg3fEwjMhCANga
	M2LV0xYMOVDFfRpbJIsijJqmYpb3NNpEP87/bPdV0Wf4/XLRroMG/8/pQK4PwYSmWsnp8Q86U/W
	S/+2f6kIaD9pnw44ueSL1qXPC04WmFrCI7stLUZqj
X-Gm-Gg: ASbGncsEYFw100LLzSjhC2UOUqm7tNBCDLxCtUn4/4jk7xjs3+8wPGNGUYPb8XYJjcV
	icWZwZWssCs3nkhQk01jDOJEhUfUBWfrrsPjfQGvxVZJIgFgXOXeeHEzQS4p7/eqrxeZP85RSSr
	29zVMuBV2t3+5Vx60fzog3z2nlekAraBsccaoJnq1ilCZ6m49GbbKcQNX5SsLgeZlVnue0vJkLF
	WPMFiDKr5N9oac=
X-Google-Smtp-Source: AGHT+IFS90j9ap/pwsMdOyBJk361aj1DQ4ZsZaeGKxnHI5SpWE0jh04JnyFyEQZtuky/IPs5PnupclRm0okM1pDHiUk=
X-Received: by 2002:a05:6830:440c:b0:79f:19f:809 with SMTP id
 46e09a7af769-79f019f0908mr197463a34.0.1758717508156; Wed, 24 Sep 2025
 05:38:28 -0700 (PDT)
Precedence: bulk
X-Mailing-List: syzbot@lists.linux.dev
List-Id: <syzbot.lists.linux.dev>
List-Subscribe: <mailto:syzbot+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:syzbot+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <68d3e41b.a70a0220.4f78.001e.GAE@google.com>
In-Reply-To: <68d3e41b.a70a0220.4f78.001e.GAE@google.com>
From: Aleksandr Nogikh <nogikh@google.com>
Date: Wed, 24 Sep 2025 14:38:16 +0200
X-Gm-Features: AS18NWDpQm79Af4vk-K-zFT2w8LqjwEyZP_K36DrZ_ZgNmLCqs7c3nMYmNcP4Ds
Message-ID: <CANp29Y58gbdD5MP=Dx3b4KDJ-VqrYcdegAe-oax6yYGFnwd9cw@mail.gmail.com>
Subject: Re: [moderation/CI] Re: pull-request: can-next 2025-09-24
To: syzbot ci <syzbot+ci1083cb565a806f40@syzkaller.appspotmail.com>
Cc: syzkaller-upstream-moderation@googlegroups.com, syzbot@lists.linux.dev
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

#syz upstream

On Wed, Sep 24, 2025 at 2:29=E2=80=AFPM syzbot ci
<syzbot+ci1083cb565a806f40@syzkaller.appspotmail.com> wrote:
>
> syzbot ci has tested the following series
>
> [v1] pull-request: can-next 2025-09-24
> https://lore.kernel.org/all/20250924082104.595459-1-mkl@pengutronix.de
> * [PATCH net-next 01/48] can: m_can: use us_to_ktime() where appropriate
> * [PATCH net-next 02/48] MAINTAINERS: update Vincent Mailhol's email addr=
ess
> * [PATCH net-next 03/48] can: dev: sort includes by alphabetical order
> * [PATCH net-next 04/48] can: peak: Modification of references to email a=
ccounts being deleted
> * [PATCH net-next 05/48] can: rcar_canfd: Update bit rate constants for R=
Z/G3E and R-Car Gen4
> * [PATCH net-next 06/48] can: rcar_canfd: Update RCANFD_CFG_* macros
> * [PATCH net-next 07/48] can: rcar_canfd: Simplify nominal bit rate confi=
g
> * [PATCH net-next 08/48] can: rcar_canfd: Simplify data bit rate config
> * [PATCH net-next 09/48] can: rcar_can: Consistently use ndev for net_dev=
ice pointers
> * [PATCH net-next 10/48] can: rcar_can: Add helper variable dev to rcar_c=
an_probe()
> * [PATCH net-next 11/48] can: rcar_can: Convert to Runtime PM
> * [PATCH net-next 12/48] can: rcar_can: Convert to BIT()
> * [PATCH net-next 13/48] can: rcar_can: Convert to GENMASK()
> * [PATCH net-next 14/48] can: rcar_can: CTLR bitfield conversion
> * [PATCH net-next 15/48] can: rcar_can: TFCR bitfield conversion
> * [PATCH net-next 16/48] can: rcar_can: BCR bitfield conversion
> * [PATCH net-next 17/48] can: rcar_can: Mailbox bitfield conversion
> * [PATCH net-next 18/48] can: rcar_can: Do not print alloc_candev() failu=
res
> * [PATCH net-next 19/48] can: rcar_can: Convert to %pe
> * [PATCH net-next 20/48] can: esd_usb: Rework display of error messages
> * [PATCH net-next 21/48] can: esd_usb: Avoid errors triggered from USB di=
sconnect
> * [PATCH net-next 22/48] can: raw: reorder struct uniqframe's members to =
optimise packing
> * [PATCH net-next 23/48] can: raw: use bitfields to store flags in struct=
 raw_sock
> * [PATCH net-next 24/48] can: raw: reorder struct raw_sock's members to o=
ptimise packing
> * [PATCH net-next 25/48] can: annotate mtu accesses with READ_ONCE()
> * [PATCH net-next 26/48] can: dev: turn can_set_static_ctrlmode() into a =
non-inline function
> * [PATCH net-next 27/48] can: populate the minimum and maximum MTU values
> * [PATCH net-next 28/48] can: enable CAN XL for virtual CAN devices by de=
fault
> * [PATCH net-next 29/48] can: dev: move struct data_bittiming_params to l=
inux/can/bittiming.h
> * [PATCH net-next 30/48] can: dev: make can_get_relative_tdco() FD agnost=
ic and move it to bittiming.h
> * [PATCH net-next 31/48] can: netlink: document which symbols are FD spec=
ific
> * [PATCH net-next 32/48] can: netlink: refactor can_validate_bittiming()
> * [PATCH net-next 33/48] can: netlink: add can_validate_tdc()
> * [PATCH net-next 34/48] can: netlink: add can_validate_databittiming()
> * [PATCH net-next 35/48] can: netlink: refactor CAN_CTRLMODE_TDC_{AUTO,MA=
NUAL} flag reset logic
> * [PATCH net-next 36/48] can: netlink: remove useless check in can_tdc_ch=
angelink()
> * [PATCH net-next 37/48] can: netlink: make can_tdc_changelink() FD agnos=
tic
> * [PATCH net-next 38/48] can: netlink: add can_dtb_changelink()
> * [PATCH net-next 39/48] can: netlink: add can_ctrlmode_changelink()
> * [PATCH net-next 40/48] can: netlink: make can_tdc_get_size() FD agnosti=
c
> * [PATCH net-next 41/48] can: netlink: add can_data_bittiming_get_size()
> * [PATCH net-next 42/48] can: netlink: add can_bittiming_fill_info()
> * [PATCH net-next 43/48] can: netlink: add can_bittiming_const_fill_info(=
)
> * [PATCH net-next 44/48] can: netlink: add can_bitrate_const_fill_info()
> * [PATCH net-next 45/48] can: netlink: make can_tdc_fill_info() FD agnost=
ic
> * [PATCH net-next 46/48] can: calc_bittiming: make can_calc_tdco() FD agn=
ostic
> * [PATCH net-next 47/48] can: dev: add can_get_ctrlmode_str()
> * [PATCH net-next 48/48] can: netlink: add userland error messages
>
> and found the following issue:
> KASAN: slab-out-of-bounds Read in can_setup
>
> Full report is available here:
> https://ci.syzbot.org/series/7feff13b-7247-438c-9d92-b8e9fda977c7
>
> ***
>
> KASAN: slab-out-of-bounds Read in can_setup
>
> tree:      net-next
> URL:       https://kernel.googlesource.com/pub/scm/linux/kernel/git/netde=
v/net-next.git
> base:      315f423be0d1ebe720d8fd4fa6bed68586b13d34
> arch:      amd64
> compiler:  Debian clang version 20.1.8 (++20250708063551+0c9f909b7976-1~e=
xp1~20250708183702.136), Debian LLD 20.1.8
> config:    https://ci.syzbot.org/builds/08331a39-4a31-4f96-a377-3125df2af=
883/config
> C repro:   https://ci.syzbot.org/findings/46cae752-cb54-4ceb-87cb-bb9d2fd=
b1d79/c_repro
> syz repro: https://ci.syzbot.org/findings/46cae752-cb54-4ceb-87cb-bb9d2fd=
b1d79/syz_repro
>
> netlink: 24 bytes leftover after parsing attributes in process `syz.0.17'=
.
> =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
> BUG: KASAN: slab-out-of-bounds in can_set_default_mtu drivers/net/can/dev=
/dev.c:350 [inline]
> BUG: KASAN: slab-out-of-bounds in can_setup+0x209/0x280 drivers/net/can/d=
ev/dev.c:279
> Read of size 4 at addr ffff888106a6ee74 by task syz.0.17/5999
>
> CPU: 1 UID: 0 PID: 5999 Comm: syz.0.17 Not tainted syzkaller #0 PREEMPT(f=
ull)
> Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS 1.16.2-debian-1.=
16.2-1 04/01/2014
> Call Trace:
>  <TASK>
>  dump_stack_lvl+0x189/0x250 lib/dump_stack.c:120
>  print_address_description mm/kasan/report.c:378 [inline]
>  print_report+0xca/0x240 mm/kasan/report.c:482
>  kasan_report+0x118/0x150 mm/kasan/report.c:595
>  can_set_default_mtu drivers/net/can/dev/dev.c:350 [inline]
>  can_setup+0x209/0x280 drivers/net/can/dev/dev.c:279
>  alloc_netdev_mqs+0x795/0x11b0 net/core/dev.c:11949
>  rtnl_create_link+0x31f/0xd10 net/core/rtnetlink.c:3633
>  rtnl_newlink_create+0x25c/0xb00 net/core/rtnetlink.c:3815
>  __rtnl_newlink net/core/rtnetlink.c:3942 [inline]
>  rtnl_newlink+0x16d6/0x1c70 net/core/rtnetlink.c:4057
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
> RIP: 0033:0x7f0b7658ec29
> Code: ff ff c3 66 2e 0f 1f 84 00 00 00 00 00 0f 1f 40 00 48 89 f8 48 89 f=
7 48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 ff=
 ff 73 01 c3 48 c7 c1 a8 ff ff ff f7 d8 64 89 01 48
> RSP: 002b:00007fff71a7bdf8 EFLAGS: 00000246 ORIG_RAX: 000000000000002e
> RAX: ffffffffffffffda RBX: 00007f0b767d5fa0 RCX: 00007f0b7658ec29
> RDX: 0000000000000000 RSI: 0000200000000280 RDI: 0000000000000003
> RBP: 00007f0b76611e41 R08: 0000000000000000 R09: 0000000000000000
> R10: 0000000000000000 R11: 0000000000000246 R12: 0000000000000000
> R13: 00007f0b767d5fa0 R14: 00007f0b767d5fa0 R15: 0000000000000003
>  </TASK>
>
> Allocated by task 5999:
>  kasan_save_stack mm/kasan/common.c:47 [inline]
>  kasan_save_track+0x3e/0x80 mm/kasan/common.c:68
>  poison_kmalloc_redzone mm/kasan/common.c:388 [inline]
>  __kasan_kmalloc+0x93/0xb0 mm/kasan/common.c:405
>  kasan_kmalloc include/linux/kasan.h:260 [inline]
>  __do_kmalloc_node mm/slub.c:4376 [inline]
>  __kvmalloc_node_noprof+0x30d/0x5f0 mm/slub.c:5067
>  alloc_netdev_mqs+0xa3/0x11b0 net/core/dev.c:11893
>  rtnl_create_link+0x31f/0xd10 net/core/rtnetlink.c:3633
>  rtnl_newlink_create+0x25c/0xb00 net/core/rtnetlink.c:3815
>  __rtnl_newlink net/core/rtnetlink.c:3942 [inline]
>  rtnl_newlink+0x16d6/0x1c70 net/core/rtnetlink.c:4057
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
> The buggy address belongs to the object at ffff888106a6e000
>  which belongs to the cache kmalloc-cg-4k of size 4096
> The buggy address is located 244 bytes to the right of
>  allocated 3456-byte region [ffff888106a6e000, ffff888106a6ed80)
>
> The buggy address belongs to the physical page:
> page: refcount:0 mapcount:0 mapping:0000000000000000 index:0x0 pfn:0x106a=
68
> head: order:3 mapcount:0 entire_mapcount:0 nr_pages_mapped:0 pincount:0
> memcg:ffff88810e6ebb41
> flags: 0x57ff00000000040(head|node=3D1|zone=3D2|lastcpupid=3D0x7ff)
> page_type: f5(slab)
> raw: 057ff00000000040 ffff88801a44b500 ffffea00043e4000 dead000000000002
> raw: 0000000000000000 0000000080040004 00000000f5000000 ffff88810e6ebb41
> head: 057ff00000000040 ffff88801a44b500 ffffea00043e4000 dead000000000002
> head: 0000000000000000 0000000080040004 00000000f5000000 ffff88810e6ebb41
> head: 057ff00000000003 ffffea00041a9a01 00000000ffffffff 00000000ffffffff
> head: ffffffffffffffff 0000000000000000 00000000ffffffff 0000000000000008
> page dumped because: kasan: bad access detected
> page_owner tracks the page as allocated
> page last allocated via order 3, migratetype Unmovable, gfp_mask 0xd60c0(=
__GFP_IO|__GFP_FS|__GFP_NOWARN|__GFP_RETRY_MAYFAIL|__GFP_NORETRY|__GFP_COMP=
|__GFP_NOMEMALLOC), pid 5901, tgid 5901 (syz-executor), ts 69629116017, fre=
e_ts 69616324772
>  set_page_owner include/linux/page_owner.h:32 [inline]
>  post_alloc_hook+0x240/0x2a0 mm/page_alloc.c:1851
>  prep_new_page mm/page_alloc.c:1859 [inline]
>  get_page_from_freelist+0x21e4/0x22c0 mm/page_alloc.c:3858
>  __alloc_frozen_pages_noprof+0x181/0x370 mm/page_alloc.c:5148
>  alloc_pages_mpol+0x232/0x4a0 mm/mempolicy.c:2416
>  alloc_slab_page mm/slub.c:2492 [inline]
>  allocate_slab+0x8a/0x370 mm/slub.c:2660
>  new_slab mm/slub.c:2714 [inline]
>  ___slab_alloc+0xbeb/0x1420 mm/slub.c:3901
>  __slab_alloc mm/slub.c:3992 [inline]
>  __slab_alloc_node mm/slub.c:4067 [inline]
>  slab_alloc_node mm/slub.c:4228 [inline]
>  __do_kmalloc_node mm/slub.c:4375 [inline]
>  __kvmalloc_node_noprof+0x429/0x5f0 mm/slub.c:5067
>  alloc_netdev_mqs+0xa3/0x11b0 net/core/dev.c:11893
>  vti6_init_net+0x104/0x370 net/ipv6/ip6_vti.c:1146
>  ops_init+0x35c/0x5c0 net/core/net_namespace.c:136
>  setup_net+0x10c/0x320 net/core/net_namespace.c:438
>  copy_net_ns+0x31b/0x4d0 net/core/net_namespace.c:570
>  create_new_namespaces+0x3f3/0x720 kernel/nsproxy.c:110
>  unshare_nsproxy_namespaces+0x11c/0x170 kernel/nsproxy.c:218
>  ksys_unshare+0x4c8/0x8c0 kernel/fork.c:3127
>  __do_sys_unshare kernel/fork.c:3198 [inline]
>  __se_sys_unshare kernel/fork.c:3196 [inline]
>  __x64_sys_unshare+0x38/0x50 kernel/fork.c:3196
> page last free pid 5901 tgid 5901 stack trace:
>  reset_page_owner include/linux/page_owner.h:25 [inline]
>  free_pages_prepare mm/page_alloc.c:1395 [inline]
>  __free_frozen_pages+0xbc4/0xd30 mm/page_alloc.c:2895
>  __slab_free+0x303/0x3c0 mm/slub.c:4606
>  qlink_free mm/kasan/quarantine.c:163 [inline]
>  qlist_free_all+0x97/0x140 mm/kasan/quarantine.c:179
>  kasan_quarantine_reduce+0x148/0x160 mm/kasan/quarantine.c:286
>  __kasan_slab_alloc+0x22/0x80 mm/kasan/common.c:340
>  kasan_slab_alloc include/linux/kasan.h:250 [inline]
>  slab_post_alloc_hook mm/slub.c:4191 [inline]
>  slab_alloc_node mm/slub.c:4240 [inline]
>  __kmalloc_cache_noprof+0x1be/0x3d0 mm/slub.c:4402
>  kmalloc_noprof include/linux/slab.h:905 [inline]
>  kzalloc_noprof include/linux/slab.h:1039 [inline]
>  ref_tracker_alloc+0x133/0x460 lib/ref_tracker.c:271
>  __netdev_tracker_alloc include/linux/netdevice.h:4379 [inline]
>  netdev_hold include/linux/netdevice.h:4408 [inline]
>  netdev_queue_add_kobject net/core/net-sysfs.c:1994 [inline]
>  netdev_queue_update_kobjects+0x1d1/0x6c0 net/core/net-sysfs.c:2056
>  register_queue_kobjects net/core/net-sysfs.c:2119 [inline]
>  netdev_register_kobject+0x258/0x310 net/core/net-sysfs.c:2362
>  register_netdevice+0x126c/0x1ae0 net/core/dev.c:11287
>  __ip_tunnel_create+0x3e7/0x560 net/ipv4/ip_tunnel.c:268
>  ip_tunnel_init_net+0x2ba/0x800 net/ipv4/ip_tunnel.c:1161
>  ops_init+0x35c/0x5c0 net/core/net_namespace.c:136
>  setup_net+0x10c/0x320 net/core/net_namespace.c:438
>  copy_net_ns+0x31b/0x4d0 net/core/net_namespace.c:570
>  create_new_namespaces+0x3f3/0x720 kernel/nsproxy.c:110
>
> Memory state around the buggy address:
>  ffff888106a6ed00: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
>  ffff888106a6ed80: fc fc fc fc fc fc fc fc fc fc fc fc fc fc fc fc
> >ffff888106a6ee00: fc fc fc fc fc fc fc fc fc fc fc fc fc fc fc fc
>                                                              ^
>  ffff888106a6ee80: fc fc fc fc fc fc fc fc fc fc fc fc fc fc fc fc
>  ffff888106a6ef00: fc fc fc fc fc fc fc fc fc fc fc fc fc fc fc fc
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
> [biju.das.jz@bp.renesas.com davem@davemloft.net geert@glider.be kernel@pe=
ngutronix.de kuba@kernel.org linux-can@vger.kernel.org mailhol@kernel.org m=
kl@pengutronix.de netdev@vger.kernel.org socketcan@hartkopp.net stefan.maet=
je@esd.eu stephane.grosjean@hms-networks.com zhao.xichao@vivo.com]
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
-upstream-moderation/68d3e41b.a70a0220.4f78.001e.GAE%40google.com.
