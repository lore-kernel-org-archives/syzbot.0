Received: from mail-ot1-f52.google.com (mail-ot1-f52.google.com [209.85.210.52])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 45B5D3A4520
	for <syzbot@lists.linux.dev>; Fri, 29 May 2026 07:39:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.210.52
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780040351; cv=pass; b=fmikzc3+BK+/KT4oojvypNrjeyY+3IjC+LD4epesb1ciukKpSQgnx7vOLKm2Rp0s7eTBgDBwX9RuVkmMm0s4uax7LRC8h6S2VqzapHiQyP8KIClgfbON6ZAQ9Hw9qY3vPv3Oy7CMxc902muqQQ3bP9fKcJnIjd3FrBR4/K53XaE=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780040351; c=relaxed/simple;
	bh=sS5C8fxy7WajOkmMrEm4TpW//ES07tum8dpmDdOiqAU=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=D3A064xwgNOZbc5G/CNPeW5iK+Vx5ILJ+R7bn54+zrZoPRvUih1PDBW631bfyyM5mIoh1IY3hJP3QPsVYxv7KNMYqukvndO542+tS43DVvDInFbi4BKKanSOIbTdhCk1QiyJpRm2+Khr3aVTFA0GIOYglzfdtC5i2qgiiP7Tvkg=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=hXifBz+y; arc=pass smtp.client-ip=209.85.210.52
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="hXifBz+y"
Received: by mail-ot1-f52.google.com with SMTP id 46e09a7af769-7e568ab0bc5so14097292a34.0
        for <syzbot@lists.linux.dev>; Fri, 29 May 2026 00:39:09 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1780040348; cv=none;
        d=google.com; s=arc-20240605;
        b=SpiTU/zzwgJ/9g+MUfIIdKCawQiy9Gz7uhyaNJWFzvNlKSjag0lOAFSqMSkRRbY8SA
         g1ygXlPrGqvxR8IUQuS1M0SPqqrZiJkzNhOimNdDjqj4QwuqIOnE7ApmJsqL80THaa28
         MQOUOYpNfS/FEpcnjLguDIjxgWLr79WcA2rooYBcKT4TH+FBzWl+FOgPdDFGQr/vhzXw
         72EAQsPNvbbQP+2QKIVaQJAM4uCmpyG0c2+cRnTyYmNrqA6uX4ncaa6T8tbJZ4V4YyhB
         nM3jg3ojK30DIdQs/6uVKECjSkXIhdXnIG2+qM0ti8b1X2sH8v3e+FNi2pzsigCZiyY3
         6/uA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=h55yeodV8rgJ9pVUdLYNyq6gmAu9Q8NvL0HeeymPQfk=;
        fh=QoCFeq3CmAcH02HeCyW4Yhd5AgAt14Op1m34GmBVs8Y=;
        b=dSRV59PSNy453zxrb6laardTyIHRK6uuw9Jcbu6zeshKEUznnvftz+w7/7SPr6TJJs
         UP3zPNBgogXpAQ78dbtlZHAaihF0zqfCJLog483NWhJMnKkGUBwO8JKgQ4gNXVPJGT82
         qdHCZ4YnHXZU1unWBvw28BiCzYqbXzNsurMTLkcAOhn/uH0ZgfQem7At4mrVTJmLjvx0
         nI44yzAVGT6pOWksW6dhDtjewN6E84buKqhkackPOSMcAOVgJP/9qSIIBe+hDjUNQ6aR
         3HD4qkZibJOuzJFGMYJq094GtK3zAYGamksFZLjGenHTvs7KpFBRabV9j43LTiFsW3eJ
         b0ww==;
        darn=lists.linux.dev
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1780040348; x=1780645148; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=h55yeodV8rgJ9pVUdLYNyq6gmAu9Q8NvL0HeeymPQfk=;
        b=hXifBz+yI+Og2y8GEgd5Ov4IxHxnK/AR20mhAp6h7xPdLnPkZZUG4XmefK83GyItFh
         pKaDXDSbnmQWOMw4I3GtSxp/YXyNzntNqQd3a2KvtqbuUCClua+6vHDsF7YxO7sZDYvA
         x9qnz+k+C6iBvoUvTXHSMKSDnhpdSgEBA8Jghg1jIWZpIOoHnKo5jwtyzZp7Xxd5te/+
         aSAymuSy7BBKa0gj9brDbvkNFAGLASWw6+ZdZKyEdafAHP6IOM7w89AOWZYb1a+hBsj1
         kGFRs2926sV9e9n5PlGrwM9oQB14bIk+DPvx2wrbjuQV4Bnal2QuzEpxoRcZTEhfZWPz
         k/Gw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1780040348; x=1780645148;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=h55yeodV8rgJ9pVUdLYNyq6gmAu9Q8NvL0HeeymPQfk=;
        b=nNJe/OyKYYKRZZdm13l9XzbGVjuTSa9emnQJJIHmZ2VPqKWdiYZXNF0I91y7EhToDw
         TJhKwtB63ZFT5Iy5NYynwoFfRtGa0Mmu8GdqXEeoFHu9/gEybmgKrHLJrK9HB9e1VTkw
         qpdju/2S5u7J7wl8guYh72jUpXIu6O6qBmHHlwKBRYBOt/ZMvRKr/GwNSUsVs6z4bTN4
         5jw7KijzzK6HR3O/mleXQ0+xzxZj02EbRbN63Y2vF2eeZKbczMp2jCr1Gp5icVZM4YuB
         iqNOfZOX7cmtwNY3YUg2oXySyDnRqEY956StiW12EjmFs7i/vdzNP74B/tPBxWfeLgFr
         vv9Q==
X-Forwarded-Encrypted: i=1; AFNElJ8dMmbhqLs4TlrYkXB4idDpqENYtuv/ATaOM9QHV0Sz/DVCIAujSSUGNbsgDMB4iKIxOCJlb1A=@lists.linux.dev
X-Gm-Message-State: AOJu0YwNG85t/sJN2MsVZj+SZg66yeqpqiFwi4NJpOwqHBC9XCEGtDgZ
	7yaj0AJtYlPigruIq+NIpC/Yg6+SzI94Q1hdbcOHMV0ohuSCzo5/Vx9Jq3nXBF3bgvqQ7eoBSBs
	Zt4puHkrkSTaS971pARYQ+wQmEUAMAadmXOeQYpRL
X-Gm-Gg: Acq92OFn617HxwAD2Au0ru3ZqmNeOa71xKqzqTbuTKwF3m5+yGz24q+cx1IV1j43m4C
	+Zc5AfvVmtSBXhzIQRZaCE0pcsaPWco5n9zp0Al2OFEfpMBLiC1OR+/5MrYMtF2v/vw0sPmDcE5
	Oe0iE9V0koHll7hZWnG8PKrbsvCopx1aNSGd90IehvBipYzNWTTimSovHimn/N+w+n4clCP+FvP
	SSZDOxw7Ig871U5jHE0HGtfBLWj7fyMLUkmhIzqGIYQtbHwspcouagsO3fwc5JOL8m0BpJHQYUC
	YgZ2FtMTMGzgggPBSI4JjOUnYe+BX5MB72SPL9qdhnm2GQ1CfY7weZ9pqXL2+H5JS+UG5BA54J6
	MBBSk
X-Received: by 2002:a05:6830:82b6:b0:7d7:fd71:f2d4 with SMTP id
 46e09a7af769-7e695461b69mr805688a34.3.1780040347657; Fri, 29 May 2026
 00:39:07 -0700 (PDT)
Precedence: bulk
X-Mailing-List: syzbot@lists.linux.dev
List-Id: <syzbot.lists.linux.dev>
List-Subscribe: <mailto:syzbot+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:syzbot+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <6a19424c.c16d89a8.217f2c.0000.GAE@google.com>
In-Reply-To: <6a19424c.c16d89a8.217f2c.0000.GAE@google.com>
From: Aleksandr Nogikh <nogikh@google.com>
Date: Fri, 29 May 2026 09:38:55 +0200
X-Gm-Features: AVHnY4IXi59M2DAHO4xqikOQuYpwS0erC_22mPffpriGHGZAtsrxbz74orKStAY
Message-ID: <CANp29Y7hMX4ViUsaym2k=_NzaKv4n8pn2b4fiZgKCNqAe3+tmA@mail.gmail.com>
Subject: Re: [moderation/CI] Re: net: ethtool: let ops locked drivers run
 without rtnl_lock
To: syzbot ci <syzbot+ci25217633374424a6@syzkaller.appspotmail.com>
Cc: syzkaller-upstream-moderation@googlegroups.com, syzbot@lists.linux.dev
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

#syz upstream

On Fri, May 29, 2026 at 9:37=E2=80=AFAM syzbot ci
<syzbot+ci25217633374424a6@syzkaller.appspotmail.com> wrote:
>
> syzbot ci has tested the following series
>
> [v1] net: ethtool: let ops locked drivers run without rtnl_lock
> https://lore.kernel.org/all/20260528231637.251822-1-kuba@kernel.org
> * [PATCH net-next 01/14] net: ethtool: cmis_cdb: hold instance lock for o=
ps locked devices
> * [PATCH net-next 02/14] net: ethtool: make sure __ethtool_get_link_ksett=
ings() is ops-locked
> * [PATCH net-next 03/14] net: ethtool: serialize broadcast notification s=
equence allocation
> * [PATCH net-next 04/14] net: ethtool: relax ethnl_req_get_phydev() locki=
ng assertion
> * [PATCH net-next 05/14] net: ethtool: make dev->hwprov ops-protected
> * [PATCH net-next 06/14] net: ethtool: optionally skip rtnl_lock on Netli=
nk path for GET ops
> * [PATCH net-next 07/14] net: ethtool: optionally skip rtnl_lock on Netli=
nk path for SET ops
> * [PATCH net-next 08/14] net: ethtool: optionally skip rtnl_lock in cable=
 test handlers
> * [PATCH net-next 09/14] net: ethtool: optionally skip rtnl_lock in ethnl=
_tsinfo_dumpit()
> * [PATCH net-next 10/14] net: ethtool: optionally skip rtnl_lock in ethnl=
_act_module_fw_flash()
> * [PATCH net-next 11/14] net: ethtool: optionally skip rtnl_lock in RSS c=
ontext handlers
> * [PATCH net-next 12/14] net: ethtool: ioctl: concentrate the locking
> * [PATCH net-next 13/14] net: ethtool: optionally skip rtnl_lock on IOCTL=
 path
> * [PATCH net-next 14/14] docs: net: ethtool: document ops-locked drivers =
and op_needs_rtnl
>
> and found the following issue:
> possible deadlock in __ethtool_get_link_ksettings
>
> Full report is available here:
> https://ci.syzbot.org/series/ada8852f-9efd-4b85-87aa-2f5d8fe16040
>
> ***
>
> possible deadlock in __ethtool_get_link_ksettings
>
> tree:      net-next
> URL:       https://kernel.googlesource.com/pub/scm/linux/kernel/git/netde=
v/net-next.git
> base:      9a82e387e27a4422a0d2d9d644180b7bd913e85a
> arch:      amd64
> compiler:  Debian clang version 21.1.8 (++20251221033036+2078da43e25a-1~e=
xp1~20251221153213.50), Debian LLD 21.1.8
> config:    https://ci.syzbot.org/builds/2968208d-6483-4d38-be45-de68d3b94=
775/config
> syz repro: https://ci.syzbot.org/findings/d8670aa1-9241-49be-8108-cdbed56=
dd4a5/syz_repro
>
> dummy0: entered promiscuous mode
> bridge0: port 3(dummy0) entered blocking state
> bridge0: port 3(dummy0) entered forwarding state
> =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
> WARNING: possible recursive locking detected
> syzkaller #0 Not tainted
> --------------------------------------------
> syz.1.28/5852 is trying to acquire lock:
> ffff888115f78dc8 (&dev_instance_lock_key#3){+.+.}-{4:4}, at: netdev_lock =
include/linux/netdevice.h:2833 [inline]
> ffff888115f78dc8 (&dev_instance_lock_key#3){+.+.}-{4:4}, at: netdev_lock_=
ops include/net/netdev_lock.h:42 [inline]
> ffff888115f78dc8 (&dev_instance_lock_key#3){+.+.}-{4:4}, at: __ethtool_ge=
t_link_ksettings+0x12b/0x290 net/ethtool/ioctl.c:462
>
> but task is already holding lock:
> ffff888115f78dc8 (&dev_instance_lock_key#3){+.+.}-{4:4}, at: netdev_lock =
include/linux/netdevice.h:2833 [inline]
> ffff888115f78dc8 (&dev_instance_lock_key#3){+.+.}-{4:4}, at: netdev_lock_=
ops include/net/netdev_lock.h:42 [inline]
> ffff888115f78dc8 (&dev_instance_lock_key#3){+.+.}-{4:4}, at: do_setlink+0=
x3d2/0x45a0 net/core/rtnetlink.c:3117
> and the lock comparison function returns 0:
>
> other info that might help us debug this:
>  Possible unsafe locking scenario:
>
>        CPU0
>        ----
>   lock(&dev_instance_lock_key#3);
>   lock(&dev_instance_lock_key#3);
>
>  *** DEADLOCK ***
>
>  May be due to missing lock nesting notation
>
> 2 locks held by syz.1.28/5852:
>  #0: ffffffff8fdd2d80 (rtnl_mutex){+.+.}-{4:4}, at: rtnl_lock net/core/rt=
netlink.c:80 [inline]
>  #0: ffffffff8fdd2d80 (rtnl_mutex){+.+.}-{4:4}, at: rtnl_nets_lock net/co=
re/rtnetlink.c:341 [inline]
>  #0: ffffffff8fdd2d80 (rtnl_mutex){+.+.}-{4:4}, at: rtnl_setlink+0x6bb/0x=
b40 net/core/rtnetlink.c:3527
>  #1: ffff888115f78dc8 (&dev_instance_lock_key#3){+.+.}-{4:4}, at: netdev_=
lock include/linux/netdevice.h:2833 [inline]
>  #1: ffff888115f78dc8 (&dev_instance_lock_key#3){+.+.}-{4:4}, at: netdev_=
lock_ops include/net/netdev_lock.h:42 [inline]
>  #1: ffff888115f78dc8 (&dev_instance_lock_key#3){+.+.}-{4:4}, at: do_setl=
ink+0x3d2/0x45a0 net/core/rtnetlink.c:3117
>
> stack backtrace:
> CPU: 0 UID: 0 PID: 5852 Comm: syz.1.28 Not tainted syzkaller #0 PREEMPT(f=
ull)
> Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS 1.16.2-debian-1.=
16.2-1 04/01/2014
> Call Trace:
>  <TASK>
>  dump_stack_lvl+0xe8/0x150 lib/dump_stack.c:120
>  print_deadlock_bug+0x279/0x290 kernel/locking/lockdep.c:3041
>  check_deadlock kernel/locking/lockdep.c:3093 [inline]
>  validate_chain kernel/locking/lockdep.c:3895 [inline]
>  __lock_acquire+0x253f/0x2cf0 kernel/locking/lockdep.c:5237
>  lock_acquire+0x106/0x350 kernel/locking/lockdep.c:5868
>  __mutex_lock_common kernel/locking/mutex.c:646 [inline]
>  __mutex_lock+0x1a3/0x1550 kernel/locking/mutex.c:820
>  netdev_lock include/linux/netdevice.h:2833 [inline]
>  netdev_lock_ops include/net/netdev_lock.h:42 [inline]
>  __ethtool_get_link_ksettings+0x12b/0x290 net/ethtool/ioctl.c:462
>  port_cost+0xc0/0x3a0 net/bridge/br_if.c:39
>  br_port_carrier_check+0x12d/0x3f0 net/bridge/br_if.c:80
>  br_device_event+0x65c/0x970 net/bridge/br.c:101
>  notifier_call_chain+0x1ad/0x3d0 kernel/notifier.c:85
>  __dev_notify_flags+0x248/0x310 net/core/dev.c:9804
>  netif_change_flags+0xe8/0x1a0 net/core/dev.c:9819
>  do_setlink+0xfa5/0x45a0 net/core/rtnetlink.c:3207
>  rtnl_setlink+0x792/0xb40 net/core/rtnetlink.c:3537
>  rtnetlink_rcv_msg+0x7d5/0xbe0 net/core/rtnetlink.c:7062
>  netlink_rcv_skb+0x232/0x4b0 net/netlink/af_netlink.c:2556
>  netlink_unicast_kernel net/netlink/af_netlink.c:1319 [inline]
>  netlink_unicast+0x75c/0x8e0 net/netlink/af_netlink.c:1345
>  netlink_sendmsg+0x813/0xb40 net/netlink/af_netlink.c:1900
>  sock_sendmsg_nosec net/socket.c:787 [inline]
>  __sock_sendmsg net/socket.c:802 [inline]
>  ____sys_sendmsg+0x972/0x9f0 net/socket.c:2698
>  ___sys_sendmsg+0x2a5/0x360 net/socket.c:2752
>  __sys_sendmsg net/socket.c:2784 [inline]
>  __do_sys_sendmsg net/socket.c:2789 [inline]
>  __se_sys_sendmsg net/socket.c:2787 [inline]
>  __x64_sys_sendmsg+0x1bd/0x2a0 net/socket.c:2787
>  do_syscall_x64 arch/x86/entry/syscall_64.c:63 [inline]
>  do_syscall_64+0x15f/0x560 arch/x86/entry/syscall_64.c:94
>  entry_SYSCALL_64_after_hwframe+0x77/0x7f
> RIP: 0033:0x7f087ad9ce59
> Code: ff c3 66 2e 0f 1f 84 00 00 00 00 00 0f 1f 44 00 00 48 89 f8 48 89 f=
7 48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 ff=
 ff 73 01 c3 48 c7 c1 e8 ff ff ff f7 d8 64 89 01 48
> RSP: 002b:00007f087bc25028 EFLAGS: 00000246 ORIG_RAX: 000000000000002e
> RAX: ffffffffffffffda RBX: 00007f087b015fa0 RCX: 00007f087ad9ce59
> RDX: 0000000000000000 RSI: 0000200000000040 RDI: 0000000000000004
> RBP: 00007f087ae32d6f R08: 0000000000000000 R09: 0000000000000000
> R10: 0000000000000000 R11: 0000000000000246 R12: 0000000000000000
> R13: 00007f087b016038 R14: 00007f087b015fa0 R15: 00007ffcefdf0348
>  </TASK>
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
> To test a patch for this bug, please reply with `#syz test`
> (should be on a separate line).
>
> The patch should be attached to the email.
> Note: arguments like custom git repos and branches are not supported.
>
> The email will later be sent to:
> [andrew@lunn.ch danieller@nvidia.com davem@davemloft.net edumazet@google.=
com ernis@linux.microsoft.com haiyangz@microsoft.com horms@kernel.org idosc=
h@nvidia.com joshwash@google.com kory.maincent@bootlin.com kuba@kernel.org =
linux@armlinux.org.uk maxime.chevallier@bootlin.com michael.chan@broadcom.c=
om netdev@vger.kernel.org pabeni@redhat.com sdf.kernel@gmail.com tariqt@nvi=
dia.com willemb@google.com]
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
-upstream-moderation/6a19424c.c16d89a8.217f2c.0000.GAE%40google.com.
