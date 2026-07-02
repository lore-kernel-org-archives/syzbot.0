Received: from mail-wm1-f50.google.com (mail-wm1-f50.google.com [209.85.128.50])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 27B863AF675
	for <syzbot@lists.linux.dev>; Thu,  2 Jul 2026 07:42:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.128.50
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782978184; cv=pass; b=m4mvCxLKxL5xIGt97ueyAdCGg7ia2Di+0/w4Cw3rMk9240NEUrmPNYJLUTqgTp/87WGuW9M1NjguUL7bF5E6x7lhBXKLK/WtJfGIY6Ti2Smrr8jh//ZOKD8cTaxi9HZiscSvfoWnOgEbd7+F7TxbqIV9mxrms25PP9knlwk01CU=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782978184; c=relaxed/simple;
	bh=kVn6w+WTby4UUOU1/Sw24R9b7gABGg37b7Nc/7aQaoc=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=AmqFA/T6KTS1P9VFNtKai0HU+NU3yprK0YlhFajm02+IHX1VEIyr+zamWpSFQEVU0RFhOx8a96OjR24KQvqWyI+JwXvAqU90MXhZAFwcPAoAcwpuLhVaq5Dg/Ckt76J8+18/qF86M5l9e8rXekotUzTFJVPIehLgawY0XZf9ePQ=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=GYd9GjLy; arc=pass smtp.client-ip=209.85.128.50
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="GYd9GjLy"
Received: by mail-wm1-f50.google.com with SMTP id 5b1f17b1804b1-493bf73ec2aso8292945e9.2
        for <syzbot@lists.linux.dev>; Thu, 02 Jul 2026 00:42:59 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1782978178; cv=none;
        d=google.com; s=arc-20260327;
        b=BLz/JibmzpA5dIfDGTNcNsr7OyC6KMRMc/smG0z7lnB3xPoVfXati6TyfewE/bHvnR
         4e74WIC7O3yxz1ziAD+nMTH4tKzxdnoAb3AhI/kkHrrGipbzp69iY5UW87pRAEjl8dqg
         nk3EiJHFT91faT3oqSm6ItdslEGyl8YTdKsO0dA8ELw1ac+D+doSvVa5CDr36UUU6mVH
         XxpxYqLLslhlQPbVCQsN2pbunv2jrA7JYvIpQsXhPS545oq0iYv/p9sbE7JdHGsEcBv8
         gxUQZN8g76/XC66LpOvtdWnWKMIA3k19G7Rj5EU5CTu4AXAVmDND+UAGtxrVJPv6hkNA
         59ng==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=s1uzD5A23HnYs3UqdrJZXTMzfAidP6tkT6PxYqN21sA=;
        fh=m8GpMSvWHyp1CqiKXbK16DFpauAF5Cx1M6f0VvExqTQ=;
        b=DX+I0lC6XnfHKqzioiKPO0NLJLtVYEXqarKk3xT3K9pwqUcxqQIzUoqImrUCVIDU/l
         nDi1CWpBDd2yWXYJM2dX9uKOubBAn9qE83FentuOeOcFarL6Ee4DKAd7EzPI5rFVzhLv
         oCE9zjWjfJCCGjlrx1fm8SPWbPTew+3Byf+Us4RzG4Hh1VBk+/00Y1YEGfa6col12M6j
         UQhIIxb/gQ6hnP/1CA4TRlTJemgzbV4CKq84Em8ySHr2OWEJfhqrQ/YiNAok37ToMuRP
         uiQQhbNfgxBmntfyLjo2ZRd0DQrk3s83bSsDSpMAuqHiRTbvNAFFf/1dSg9WHeKenUBt
         nqwA==;
        darn=lists.linux.dev
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1782978178; x=1783582978; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=s1uzD5A23HnYs3UqdrJZXTMzfAidP6tkT6PxYqN21sA=;
        b=GYd9GjLyJDpqNodL/3Rsy9M+ZolqD0Et5WOOr1O+44/JxK5DdRitbvfIObE2wNP0YL
         WKcDtUJwJXfH7211iPfGyNg/cCkaeG9t0mvUU4VaPzu+egdx+V0NpIcL+QxuFcUzPEbA
         9OQPuPlrAO90RJsXgdHePiHKWTMQSkN0Tgo8y6JMQD1iO51XHlr0I1Kch0x7HtHoK9ex
         dtkj8YkGQ/In7A04CCW9lG8ERti23rdHf4KTmfyEx3MqNaa3z7+oKowktEvYFO8ueyNs
         iGjoBNSTBZGmTOtFoUk3VVejKfoOphCHgy/4g5WzggkKLWm7I4uiLB4hS0BUG03TkMkZ
         +tFw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1782978178; x=1783582978;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=s1uzD5A23HnYs3UqdrJZXTMzfAidP6tkT6PxYqN21sA=;
        b=Di6ga08Bf6RlPBIsZ6dtYjIN7emGvGUaf7rF4eXOVuaHL+hD+AehG24amcGkH4qq1I
         RMLgnBdHOx0cxX/0KDL3/ta1xfnoINRELnSO6YTSZOzPVZtAkWLvDFrV6oGUt1N4kUgE
         GhvG3/GltbbddDyaZ4F/0jbJ8z6+9ki5rLRiHgxOVZZMfhYav7YCsJoKLU+j1tDHTYSZ
         SHoAk09by5AhxlQkKrqBrCVulnl7TPUVMFcDqIam+BdsS/nKA/uZ4szMh4LDEMP29SfX
         lB43I6npBgoL2JgquUN75SZ8BpBxe+/D0Wj+0buip1CCcSnmkqo/WEKltgSoRrBfgyf0
         cQhg==
X-Forwarded-Encrypted: i=1; AFNElJ/SdGazttoZIFzxBFr8qCyu8K2Y/tJPSYxTKOej32NaOJbTzUq6/1jj3DM5FdZiNwzF8yIlBOY=@lists.linux.dev
X-Gm-Message-State: AOJu0YxFbRzVoeYC0U+HpAYmTYmvZnq7yGrxEAC2+EJZvfncknsc4lNM
	VKybjhuMwwQq7UjWibRFKcvr3mRfQYfRQT62gWtnqARZfGGliJk3kWZBIrRnZf36bzGU5NKZfay
	oRMc1xFfbzspClU1fUUKvwh7/bbv1tUt/GROLVeu1Sa5YWgaCAgyd2Uy2
X-Gm-Gg: AfdE7cnKW1+eV6r5yfiDxolV5p53UX7BgGBlqn2OcLrI5sT02PHx//YE3TebjECcYGk
	YLwsOhE5veqQj9EN7cRI/6cUPtztYzp7jwKfPvV/9JqLY2/2/qpa8PEu9D400R9CZ4krijVPq07
	v2lZ93SftlW5sZuPoS8j780CuTxeSWijKdg9zT1MBmqUVFszRj9iF1r2oFmiRWyETQars+qdt/y
	TmCFg2M5q057WdLA2FBxqU1ua4YmBg8cQmATrcf+9j7qooTny/spGnDB8+2/EneeHRHKjjtfmDR
	q+Qv7Wm+YTPChHI5e6LWE8xYi2jkB4AEbYWx7QFZJLvBFz/X8l1R7mcaNV51
X-Received: by 2002:a05:600c:c171:b0:493:b6e2:1b0f with SMTP id
 5b1f17b1804b1-493c2b99a63mr69380895e9.33.1782978177493; Thu, 02 Jul 2026
 00:42:57 -0700 (PDT)
Precedence: bulk
X-Mailing-List: syzbot@lists.linux.dev
List-Id: <syzbot.lists.linux.dev>
List-Subscribe: <mailto:syzbot+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:syzbot+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <6a460e76.6912059f.e0473.0001.GAE@google.com>
In-Reply-To: <6a460e76.6912059f.e0473.0001.GAE@google.com>
From: Pimyn Girgis <pimyn@google.com>
Date: Thu, 2 Jul 2026 09:42:45 +0200
X-Gm-Features: AVVi8CeEe2rqhtg2ptR2G6hXCyZPV60V0IloObjtODBU36hWT9ufNQ24_kbD_AM
Message-ID: <CAJWNTGwnL24Hr48qyxoUT2Omdttmx17i-gm6K=H05RN3JLzXRQ@mail.gmail.com>
Subject: Re: [moderation/CI] Re: net: Support per-netns device unregistration
To: syzbot ci <syzbot+cib504dd1139a0b3a4@syzkaller.appspotmail.com>
Cc: syzkaller-upstream-moderation@googlegroups.com, syzbot@lists.linux.dev
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

#syz upstream


On Thu, Jul 2, 2026 at 9:08=E2=80=AFAM syzbot ci
<syzbot+cib504dd1139a0b3a4@syzkaller.appspotmail.com> wrote:
>
> syzbot ci has tested the following series
>
> [v1] net: Support per-netns device unregistration
> https://lore.kernel.org/all/20260701214334.266991-1-kuniyu@google.com
> * [PATCH v1 net-next 01/14] rtnetlink: Lock sock_net(skb->sk) in rtnl_new=
link().
> * [PATCH v1 net-next 02/14] rtnetlink: Call unregister_netdevice_many() o=
nly once in rtnl_link_unregister().
> * [PATCH v1 net-next 03/14] rtnetlink: Add per-netns rtnl_work.
> * [PATCH v1 net-next 04/14] net: Wrap default_device_exit_net() with __rt=
nl_net_lock().
> * [PATCH v1 net-next 05/14] net: Hold __rtnl_net_lock() in netdev_wait_al=
lrefs_any().
> * [PATCH v1 net-next 06/14] net: Add per-netns netdev unregistration infr=
a.
> * [PATCH v1 net-next 07/14] net: Call unregister_netdevice_many() per net=
ns.
> * [PATCH v1 net-next 08/14] veth: Support per-netns device unregistration=
.
> * [PATCH v1 net-next 09/14] bareudp: Protect bareudp_list with mutex.
> * [PATCH v1 net-next 10/14] bareudp: Support per-netns netdev unregistrat=
ion.
> * [PATCH v1 net-next 11/14] ipvlan: Convert ipvl_port.count to refcount_t=
.
> * [PATCH v1 net-next 12/14] ipvlan: Synchronise ipvlan_init() and ipvlan_=
uninit() for the same lower dev.
> * [PATCH v1 net-next 13/14] ipvlan: Protect ipvl_port.ipvlans with mutex.
> * [PATCH v1 net-next 14/14] ipvlan: Support per-netns netdev unregistrati=
on.
>
> and found the following issue:
> possible deadlock in __dev_change_net_namespace
>
> Full report is available here:
> https://ci.syzbot.org/series/a744b257-d741-4780-8a53-f156b2a7afc9
>
> ***
>
> possible deadlock in __dev_change_net_namespace
>
> tree:      net-next
> URL:       https://kernel.googlesource.com/pub/scm/linux/kernel/git/netde=
v/net-next.git
> base:      d6e81529749190123aa0040626c7e5dbc20fdc9a
> arch:      amd64
> compiler:  Debian clang version 22.1.6 (++20260514074242+fc4aad7b5db3-1~e=
xp1~20260514074407.73), Debian LLD 22.1.6
> config:    https://ci.syzbot.org/builds/243cd0ec-28f9-4d21-8f16-3d2fbad83=
88d/config
> syz repro: https://ci.syzbot.org/findings/a8a0740d-fdec-4a20-9aa5-7cb9557=
07913/syz_repro
>
> veth0_macvtap: left promiscuous mode
> =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
> WARNING: possible recursive locking detected
> syzkaller #0 Not tainted
> --------------------------------------------
> syz.1.18/5814 is trying to acquire lock:
> ffffffff9a9b0418 (&net->dev_unreg_lock){+.+.}-{3:3}, at: spin_lock includ=
e/linux/spinlock.h:342 [inline]
> ffffffff9a9b0418 (&net->dev_unreg_lock){+.+.}-{3:3}, at: unregister_netde=
vice_move_net net/core/dev.c:-1 [inline]
> ffffffff9a9b0418 (&net->dev_unreg_lock){+.+.}-{3:3}, at: __dev_change_net=
_namespace+0x1479/0x2200 net/core/dev.c:12768
>
> but task is already holding lock:
> ffff88810b6cf8d8 (&net->dev_unreg_lock){+.+.}-{3:3}, at: spin_lock includ=
e/linux/spinlock.h:342 [inline]
> ffff88810b6cf8d8 (&net->dev_unreg_lock){+.+.}-{3:3}, at: unregister_netde=
vice_move_net net/core/dev.c:-1 [inline]
> ffff88810b6cf8d8 (&net->dev_unreg_lock){+.+.}-{3:3}, at: __dev_change_net=
_namespace+0x146a/0x2200 net/core/dev.c:12768
>
> other info that might help us debug this:
>  Possible unsafe locking scenario:
>
>        CPU0
>        ----
>   lock(&net->dev_unreg_lock);
>   lock(&net->dev_unreg_lock);
>
>  *** DEADLOCK ***
>
>  May be due to missing lock nesting notation
>
> 4 locks held by syz.1.18/5814:
>  #0: ffffffff8fdeb0c0 (rtnl_mutex){+.+.}-{4:4}, at: rtnl_lock net/core/rt=
netlink.c:80 [inline]
>  #0: ffffffff8fdeb0c0 (rtnl_mutex){+.+.}-{4:4}, at: rtnl_nets_lock+0x2a/0=
x2b0 net/core/rtnetlink.c:366
>  #1: ffffffff9a9b0380 (&net->rtnl_mutex){+.+.}-{4:4}, at: rtnl_nets_lock+=
0x76/0x2b0 net/core/rtnetlink.c:369
>  #2: ffff88810b6cf840 (&net->rtnl_mutex){+.+.}-{4:4}, at: rtnl_nets_lock+=
0xbf/0x2b0 net/core/rtnetlink.c:369
>  #3: ffff88810b6cf8d8 (&net->dev_unreg_lock){+.+.}-{3:3}, at: spin_lock i=
nclude/linux/spinlock.h:342 [inline]
>  #3: ffff88810b6cf8d8 (&net->dev_unreg_lock){+.+.}-{3:3}, at: unregister_=
netdevice_move_net net/core/dev.c:-1 [inline]
>  #3: ffff88810b6cf8d8 (&net->dev_unreg_lock){+.+.}-{3:3}, at: __dev_chang=
e_net_namespace+0x146a/0x2200 net/core/dev.c:12768
>
> stack backtrace:
> CPU: 0 UID: 0 PID: 5814 Comm: syz.1.18 Not tainted syzkaller #0 PREEMPT(f=
ull)
> Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS 1.16.2-debian-1.=
16.2-1 04/01/2014
> Call Trace:
>  <TASK>
>  dump_stack_lvl+0xe8/0x150 lib/dump_stack.c:120
>  print_deadlock_bug+0x279/0x290 kernel/locking/lockdep.c:3041
>  check_deadlock kernel/locking/lockdep.c:3093 [inline]
>  validate_chain kernel/locking/lockdep.c:3895 [inline]
>  __lock_acquire+0x24df/0x2cf0 kernel/locking/lockdep.c:5237
>  lock_acquire+0x106/0x350 kernel/locking/lockdep.c:5868
>  __raw_spin_lock include/linux/spinlock_api_smp.h:158 [inline]
>  _raw_spin_lock+0x2e/0x40 kernel/locking/spinlock.c:158
>  spin_lock include/linux/spinlock.h:342 [inline]
>  unregister_netdevice_move_net net/core/dev.c:-1 [inline]
>  __dev_change_net_namespace+0x1479/0x2200 net/core/dev.c:12768
>  do_setlink+0x2d1/0x4670 net/core/rtnetlink.c:3148
>  rtnl_changelink net/core/rtnetlink.c:3880 [inline]
>  __rtnl_newlink net/core/rtnetlink.c:4053 [inline]
>  rtnl_newlink+0x1612/0x1b50 net/core/rtnetlink.c:4192
>  rtnetlink_rcv_msg+0x802/0xc00 net/core/rtnetlink.c:7109
>  netlink_rcv_skb+0x226/0x4a0 net/netlink/af_netlink.c:2556
>  netlink_unicast_kernel net/netlink/af_netlink.c:1319 [inline]
>  netlink_unicast+0x7bb/0x940 net/netlink/af_netlink.c:1345
>  netlink_sendmsg+0x813/0xb40 net/netlink/af_netlink.c:1900
>  sock_sendmsg_nosec+0x13a/0x180 net/socket.c:775
>  __sock_sendmsg net/socket.c:790 [inline]
>  ____sys_sendmsg+0x54e/0x850 net/socket.c:2684
>  ___sys_sendmsg+0x2a5/0x360 net/socket.c:2738
>  __sys_sendmsg net/socket.c:2770 [inline]
>  __do_sys_sendmsg net/socket.c:2775 [inline]
>  __se_sys_sendmsg net/socket.c:2773 [inline]
>  __x64_sys_sendmsg+0x1b1/0x290 net/socket.c:2773
>  do_syscall_x64 arch/x86/entry/syscall_64.c:63 [inline]
>  do_syscall_64+0x174/0x580 arch/x86/entry/syscall_64.c:94
>  entry_SYSCALL_64_after_hwframe+0x77/0x7f
> RIP: 0033:0x7fbdc639ce59
> Code: ff c3 66 2e 0f 1f 84 00 00 00 00 00 0f 1f 44 00 00 48 89 f8 48 89 f=
7 48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 ff=
 ff 73 01 c3 48 c7 c1 e8 ff ff ff f7 d8 64 89 01 48
> RSP: 002b:00007fbdc59fe028 EFLAGS: 00000246 ORIG_RAX: 000000000000002e
> RAX: ffffffffffffffda RBX: 00007fbdc6615fa0 RCX: 00007fbdc639ce59
> RDX: 0000000000000000 RSI: 0000200000000740 RDI: 0000000000000003
> RBP: 00007fbdc6432e6f R08: 0000000000000000 R09: 0000000000000000
> R10: 0000000000000000 R11: 0000000000000246 R12: 0000000000000000
> R13: 00007fbdc6616038 R14: 00007fbdc6615fa0 R15: 00007ffd94dcb1f8
>  </TASK>
> syz.1.18 (5814) used greatest stack depth: 19864 bytes left
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
> [andrew@lunn.ch davem@davemloft.net edumazet@google.com horms@kernel.org =
kuba@kernel.org kuni1840@gmail.com kuniyu@google.com netdev@vger.kernel.org=
 pabeni@redhat.com]
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
-upstream-moderation/6a460e76.6912059f.e0473.0001.GAE%40google.com.



--=20
=E2=B2=A0=E2=B2=9F=E2=B2=93=E2=B2=99=E2=B2=8F=E2=B2=9B =E2=B2=84=E2=B2=89=
=E2=B2=B1=E2=B2=A3=E2=B2=85=E2=B2=93=E2=B2=9F=E2=B2=A5 - Pimyn Girgis
Software Engineer
Kernel Dynamic Analysis
pimyn@google.com
