Received: from mail-oo2-f21.google.com (mail-oo2-f21.google.com [74.125.231.149])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 81F9B4A3F36
	for <syzbot@lists.linux.dev>; Tue, 15 Sep 2026 14:48:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=74.125.231.149
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789483717; cv=pass; b=ddVSir6ElaX4pu2bIcXNKbhJEsBOmqYi11ksrmyvT8TSHEJ4uDtq8kCQcQ/1IvwanqUsRvEcwcYNlSuWivmFw4oSSqgLsi6DwXX3dB9KuREhgZAe7cZBlCBNVpgscamd7234a30NfWevriUog4VD/spDcdWNuCcBQU/axPNHdCc=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789483717; c=relaxed/simple;
	bh=SfCdSA/GMXCJJxv6VHX2Ue0xzDDa0tE1H0E2UtLN4Ao=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=J/iq6a3FHpwrzDg7S/txC01/Obyo1SUyaOkh4DBpcP1fNksJAX+IxOzhUUXEP9fpkKxUl0QciJnAbUC480VWmrTYw4beCilTTEljk0UXxx3la1pj+8NybMdLQU4kJmE5LW6Da8fULTAdqsF04mQP+8Mo9e76cWgdGKDImABKaqA=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=BhDyGQMc; arc=pass smtp.client-ip=74.125.231.149
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="BhDyGQMc"
Received: by mail-oo2-f21.google.com with SMTP id 46e09a7af769-7f4f0d1779dso438148a34.2
        for <syzbot@lists.linux.dev>; Tue, 15 Sep 2026 07:48:35 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1789483714; cv=none;
        d=google.com; s=arc-20260327;
        b=oDAGRx7uzP6oQTIjEbJ7M4TwqWPCQnFfgtXNihX+Dp7N5lHKeEeTuvmm+boyBwhx2s
         D/bDvQMOW4HRT5sW9W8jtdXJDGmOM7iTd5yM/3qFS9RDbAP1KoHtiRnzJ9ggpeDOmSJN
         /v263cCThGcsmzbjEDTeBTsVzvyEw9aRQNHsul9aKpaXTexqQt0Bk64x82V7+tCYNNYP
         efBW7MsvJQkD1xCv9TNuyPs1SzuN1hLEs/d1mW8aGTaQmZwDtkkJbgnzO2XAJm4PLXK/
         ZaPhqLipknU9315K6uHU5cXbAf0UmU1aBvm2wJ644GL3p/MNNR8T+yBk0Le/eK5amLyH
         4i/w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=vZjcyfHMARyhlokRS5kSpOKEA8KomU8p70Ia7nddr2c=;
        fh=c9K+dcrpc+1CZusvvItBYAVZEEL8j6HhpiEmYDN9xJc=;
        b=rSWD2pVYspuoMprjcffleHwnRakjAdSaRHKoFFz+3RYD0IA1JGB7+VhbYcYeWdfDHi
         /rHHl7sTOHx1D2u0OUs2CcaqRWhAX1IHyqPur75oijc2IMDfs2JARWYFOk160e0nq6G1
         u5w5QS9hIlSfpYYGc4zvbB1icbA+KNVcZOZwK8R4Z8+VMqvP4VqgU3+gGJi+6zAFX17R
         aQAADtEm674Hnt7h2VljFGpFI64XAYUjsiKYmMwNhG8QDysXQSxDiDJb2YQMxVo5USgr
         YpmvkgLKG/5kpLPkmzefaccpDYgQyI+8Z5+iAhMjbYeqQTpF2G5j/bXsxyiPnZZBmKqX
         X8yQ==;
        darn=lists.linux.dev
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1789483714; x=1790088514; darn=lists.linux.dev;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=vZjcyfHMARyhlokRS5kSpOKEA8KomU8p70Ia7nddr2c=;
        b=BhDyGQMccX0hAUvs5bJbAfmImGk7y+Irss95CyzAVnKtUw9El2OQBh5ycfUXcjcT4q
         qhiQGJQzHeCpWY5LLtHiejozn2Om3/W47XqrV4b+XCSfoOzkPxkpVuOER7lLDljt5dC9
         BxG70aK1+xyNbXKSulisT/cK0MtavFRsPExOn5TGBiIW1JZ9Rok5shfb184xXXFfvsue
         UUSRjUHClOxMMUMn11pFxvrMFY9X1CNkR6tllNkAsy4AN74wQReyOtUrWmj19T3Ptzmp
         ByJLVdX+GVsgj8aEgU9mxuyFFQapsfzUnhKx79cdZCJhMJi9iGmtOObZ504TbqE9VdYR
         WkfA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1789483714; x=1790088514;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=vZjcyfHMARyhlokRS5kSpOKEA8KomU8p70Ia7nddr2c=;
        b=uUmoGr2LuB1zyCtqHFoxtCLH8iIg1SGb8XiQb/w8pEGCvnzLAHKe8p2etR6Cdq0Cb5
         HQTwzK2Z7R48B+1LgqfbE6mXbsAQRvQdb3xkhkbx27sp3e+xMxGQjwePAsYeLCG/AS3e
         FnbVo3GbxhFZrBP5v7F/bo+oGtbUvcWE8YXZ9/p2f6SOAxO/dXZuA5eOtrg4PVaZVojI
         Qg3u/lLhfhWAfrauBnGQmHy+farZljiYqIvicu+aSUhG2APxbTk0WhLAuUgmb/lVUk1r
         SxERC2SvXx+fkuPXRcQ1xG8NPPkvhzzuD9j/yC17Knz1BXU8c2jv7psPtoEmk+MNwL+Y
         RDUw==
X-Forwarded-Encrypted: i=1; AKwUvByz8PNV7L9whnR9wJyvOw5LqMuRUVAjpkNgH12mCiHonNvglJY5KNOAysTwnKLb2RHLF4OXlwM=@lists.linux.dev
X-Gm-Message-State: AFuF++kM/FYnyhkG5IMA6yBANnO/WkdSIPOKh0N3Bmr8wVLCVWK3MXUC
	kTVpmqNHMbEQ9VsUuIhoYqcVYivKfbbjLNYyBnTtKCK1GjJAMz1gchzkUjXhKUVmixDfz2d3fjK
	DFuhNYIhs/k0Ert3UZsjHd7y5Z9SnxgaTmUONmQ8a
X-Gm-Gg: AYBFou0yGMWCD8e8Y5YwlOSuiu3He84pOuWiW7XmETrkdDgJLS3tdYC8DXJLWllPQo5
	0rHTdNok/4stQEDuJpNZMuaY1M9y4g4iht6bcl/w/Ut2KgbvJOMoJ7JvafPR38KiFQUCNvKfg7X
	kPNLwZIIOTynS/1SKPSKhBXgPtB+Ps2ZUfottWteow5V9iRchJP+n+vJdFL/FU/jZcwfnT3i49c
	4lLvB/ei0L8rEu7j5pYOSoxnCYK7kLhcBJThOSxonqUdlgATWernKnNw+ilRirBw7+K3rEXvvvC
	+THvg2sR2OvEGJ8yjauarCbSejsrpG4/L58DM8uBcHjs2qRFWz+cnBYJxNOM4/647jJUH7ZC74J
	rwMgZMqH6tW8ST+NB0ERBBIuCIPvl+LgrmvTefeskGZytP5wHCKxSa1rD/V7URH/YlRKQ2M0mxD
	DOAIOu80ZowfO3Ab96dyS+3j8=
X-Received: by 2002:a05:6830:6d49:b0:804:8750:c827 with SMTP id
 46e09a7af769-80a74d7b19fmr1511306a34.6.1789483713472; Tue, 15 Sep 2026
 07:48:33 -0700 (PDT)
Precedence: bulk
X-Mailing-List: syzbot@lists.linux.dev
List-Id: <syzbot.lists.linux.dev>
List-Subscribe: <mailto:syzbot+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:syzbot+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <6aa95355.f81106d8.2ab401.0069.GAE@google.com>
In-Reply-To: <6aa95355.f81106d8.2ab401.0069.GAE@google.com>
From: Aleksandr Nogikh <nogikh@google.com>
Date: Tue, 15 Sep 2026 16:48:20 +0200
X-Gm-Features: AcwNN1WXJDsyETKaKqSUzWGWWkFpXF_Jc3gtN875SyFuk_vz5rXE5ihnAHkDaow
Message-ID: <CANp29Y5ow_V6HVKOa=y_vbZYTFLHePQ1FutZfH+x5XvyyLBRzA@mail.gmail.com>
Subject: Re: [moderation/CI] Re: xsk: Fix circular locking dependency between
 &net->xdp.lock, &xs->mutex, and netdev_lock_ops
To: syzbot ci <syzbot+ci06f7dfaa8255f9ac@syzkaller.appspotmail.com>
Cc: syzkaller-upstream-moderation@googlegroups.com, syzbot@lists.linux.dev
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

#syz upstream


On Tue, Sep 15, 2026 at 4:16=E2=80=AFPM syzbot ci
<syzbot+ci06f7dfaa8255f9ac@syzkaller.appspotmail.com> wrote:
>
> syzbot ci has tested the following series
>
> [v6] xsk: Fix circular locking dependency between &net->xdp.lock, &xs->mu=
tex, and netdev_lock_ops
> https://lore.kernel.org/all/20260915081023.7433-1-ahemadkhawar123@gmail.c=
om
> * [PATCH bpf-next v6] xsk: Fix circular locking dependency between &net->=
xdp.lock, &xs->mutex, and netdev_lock_ops
>
> and found the following issue:
> possible deadlock in xp_clear_dev
>
> Full report is available here:
> https://ci.syzbot.org/series/fd897794-4f0d-45f4-8e63-bcb526e0b175
>
> ***
>
> possible deadlock in xp_clear_dev
>
> tree:      bpf-next
> URL:       https://kernel.googlesource.com/pub/scm/linux/kernel/git/bpf/b=
pf-next.git
> base:      b0ca562e0d05cf7afedcfa71c9aed180b72bcc97
> arch:      amd64
> compiler:  Debian clang version 22.1.8 (++20260613092233+e80beda6e255-1~e=
xp1~20260613092250.77), Debian LLD 22.1.8
> config:    https://ci.syzbot.org/builds/d5521b86-a0b8-4ffc-ada4-91f534b02=
8bc/config
> syz repro: https://ci.syzbot.org/findings/6aa094b3-5f39-460c-b0f7-709bbf7=
2644c/syz_repro
>
> netlink: 14 bytes leftover after parsing attributes in process `syz.1.18'=
.
> =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D
> WARNING: possible circular locking dependency detected
> syzkaller #0 Not tainted
> ------------------------------------------------------
> syz.1.18/5842 is trying to acquire lock:
> ffff8881793b4e70 (&dev_instance_lock_key#3){+.+.}-{4:4}, at: netdev_lock =
include/linux/netdevice.h:2861 [inline]
> ffff8881793b4e70 (&dev_instance_lock_key#3){+.+.}-{4:4}, at: netdev_lock_=
ops include/net/netdev_lock.h:42 [inline]
> ffff8881793b4e70 (&dev_instance_lock_key#3){+.+.}-{4:4}, at: xp_clear_dev=
+0x13b/0x340 net/xdp/xsk_buff_pool.c:297
>
> but task is already holding lock:
> ffff8881bd5ca6b8 (&xs->mutex){+.+.}-{4:4}, at: xsk_notifier+0xcd/0x230 ne=
t/xdp/xsk.c:2114
>
> which lock already depends on the new lock.
>
>
> the existing dependency chain (in reverse order) is:
>
> -> #1 (&xs->mutex){+.+.}-{4:4}:
>        __mutex_lock_common kernel/locking/mutex.c:646 [inline]
>        __mutex_lock+0x19d/0x1550 kernel/locking/mutex.c:821
>        xsk_bind+0x297/0x13f0 net/xdp/xsk.c:1620
>        __sys_bind_socket net/socket.c:1945 [inline]
>        __sys_bind+0x2e3/0x410 net/socket.c:1976
>        __do_sys_bind net/socket.c:1981 [inline]
>        __se_sys_bind net/socket.c:1979 [inline]
>        __x64_sys_bind+0x7a/0x90 net/socket.c:1979
>        do_syscall_x64 arch/x86/entry/syscall_64.c:61 [inline]
>        do_syscall_64+0x166/0x520 arch/x86/entry/syscall_64.c:84
>        entry_SYSCALL_64_after_hwframe+0x77/0x7f
>
> -> #0 (&dev_instance_lock_key#3){+.+.}-{4:4}:
>        check_prev_add kernel/locking/lockdep.c:3181 [inline]
>        check_prevs_add kernel/locking/lockdep.c:3300 [inline]
>        validate_chain kernel/locking/lockdep.c:3924 [inline]
>        __lock_acquire+0x1520/0x2cf0 kernel/locking/lockdep.c:5253
>        lock_acquire+0x106/0x350 kernel/locking/lockdep.c:5886
>        __mutex_lock_common kernel/locking/mutex.c:646 [inline]
>        __mutex_lock+0x19d/0x1550 kernel/locking/mutex.c:821
>        netdev_lock include/linux/netdevice.h:2861 [inline]
>        netdev_lock_ops include/net/netdev_lock.h:42 [inline]
>        xp_clear_dev+0x13b/0x340 net/xdp/xsk_buff_pool.c:297
>        xsk_notifier+0x1a1/0x230 net/xdp/xsk.c:2123
>        notifier_call_chain+0x1a5/0x3d0 kernel/notifier.c:85
>        call_netdevice_notifiers_extack net/core/dev.c:2313 [inline]
>        call_netdevice_notifiers net/core/dev.c:2327 [inline]
>        unregister_netdevice_many_notify+0x17f9/0x2140 net/core/dev.c:1251=
8
>        rtnl_delete_link net/core/rtnetlink.c:3652 [inline]
>        rtnl_dellink+0x5be/0x810 net/core/rtnetlink.c:3694
>        rtnetlink_rcv_msg+0x802/0xc00 net/core/rtnetlink.c:7132
>        netlink_rcv_skb+0x226/0x4a0 net/netlink/af_netlink.c:2556
>        netlink_unicast_kernel net/netlink/af_netlink.c:1319 [inline]
>        netlink_unicast+0x7bd/0x940 net/netlink/af_netlink.c:1345
>        netlink_sendmsg+0x813/0xb40 net/netlink/af_netlink.c:1900
>        sock_sendmsg_nosec+0x13a/0x180 net/socket.c:800
>        __sock_sendmsg net/socket.c:815 [inline]
>        ____sys_sendmsg+0x54e/0x850 net/socket.c:2713
>        ___sys_sendmsg+0x2a5/0x360 net/socket.c:2767
>        __sys_sendmsg net/socket.c:2799 [inline]
>        __do_sys_sendmsg net/socket.c:2804 [inline]
>        __se_sys_sendmsg net/socket.c:2802 [inline]
>        __x64_sys_sendmsg+0x1b1/0x290 net/socket.c:2802
>        do_syscall_x64 arch/x86/entry/syscall_64.c:61 [inline]
>        do_syscall_64+0x166/0x520 arch/x86/entry/syscall_64.c:84
>        entry_SYSCALL_64_after_hwframe+0x77/0x7f
>
> other info that might help us debug this:
>
>  Possible unsafe locking scenario:
>
>        CPU0                    CPU1
>        ----                    ----
>   lock(&xs->mutex);
>                                lock(&dev_instance_lock_key#3);
>                                lock(&xs->mutex);
>   lock(&dev_instance_lock_key#3);
>
>  *** DEADLOCK ***
>
> locks held by syz.1.18/5842: 3, last CPU#0:
>  #0: ffffffff90036ac0 (rtnl_mutex){+.+.}-{4:4}, at: rtnl_lock net/core/rt=
netlink.c:80 [inline]
>  #0: ffffffff90036ac0 (rtnl_mutex){+.+.}-{4:4}, at: rtnl_net_lock include=
/linux/rtnetlink.h:134 [inline]
>  #0: ffffffff90036ac0 (rtnl_mutex){+.+.}-{4:4}, at: rtnl_dellink+0x41b/0x=
810 net/core/rtnetlink.c:3686
>  #1: ffff88810e3ac750 (&net->xdp.lock){+.+.}-{4:4}, at: xsk_notifier+0x89=
/0x230 net/xdp/xsk.c:2110
>  #2: ffff8881bd5ca6b8 (&xs->mutex){+.+.}-{4:4}, at: xsk_notifier+0xcd/0x2=
30 net/xdp/xsk.c:2114
>
> stack backtrace:
> CPU: 0 UID: 0 PID: 5842 Comm: syz.1.18 Not tainted syzkaller #0 PREEMPT(f=
ull)
> Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS 1.16.2-debian-1.=
16.2-1 04/01/2014
> Call Trace:
>  <TASK>
>  dump_stack_lvl+0xe8/0x150 lib/dump_stack.c:120
>  print_circular_bug+0x2e1/0x300 kernel/locking/lockdep.c:2059
>  check_noncircular+0x12e/0x150 kernel/locking/lockdep.c:2191
>  check_prev_add kernel/locking/lockdep.c:3181 [inline]
>  check_prevs_add kernel/locking/lockdep.c:3300 [inline]
>  validate_chain kernel/locking/lockdep.c:3924 [inline]
>  __lock_acquire+0x1520/0x2cf0 kernel/locking/lockdep.c:5253
>  lock_acquire+0x106/0x350 kernel/locking/lockdep.c:5886
>  __mutex_lock_common kernel/locking/mutex.c:646 [inline]
>  __mutex_lock+0x19d/0x1550 kernel/locking/mutex.c:821
>  netdev_lock include/linux/netdevice.h:2861 [inline]
>  netdev_lock_ops include/net/netdev_lock.h:42 [inline]
>  xp_clear_dev+0x13b/0x340 net/xdp/xsk_buff_pool.c:297
>  xsk_notifier+0x1a1/0x230 net/xdp/xsk.c:2123
>  notifier_call_chain+0x1a5/0x3d0 kernel/notifier.c:85
>  call_netdevice_notifiers_extack net/core/dev.c:2313 [inline]
>  call_netdevice_notifiers net/core/dev.c:2327 [inline]
>  unregister_netdevice_many_notify+0x17f9/0x2140 net/core/dev.c:12518
>  rtnl_delete_link net/core/rtnetlink.c:3652 [inline]
>  rtnl_dellink+0x5be/0x810 net/core/rtnetlink.c:3694
>  rtnetlink_rcv_msg+0x802/0xc00 net/core/rtnetlink.c:7132
>  netlink_rcv_skb+0x226/0x4a0 net/netlink/af_netlink.c:2556
>  netlink_unicast_kernel net/netlink/af_netlink.c:1319 [inline]
>  netlink_unicast+0x7bd/0x940 net/netlink/af_netlink.c:1345
>  netlink_sendmsg+0x813/0xb40 net/netlink/af_netlink.c:1900
>  sock_sendmsg_nosec+0x13a/0x180 net/socket.c:800
>  __sock_sendmsg net/socket.c:815 [inline]
>  ____sys_sendmsg+0x54e/0x850 net/socket.c:2713
>  ___sys_sendmsg+0x2a5/0x360 net/socket.c:2767
>  __sys_sendmsg net/socket.c:2799 [inline]
>  __do_sys_sendmsg net/socket.c:2804 [inline]
>  __se_sys_sendmsg net/socket.c:2802 [inline]
>  __x64_sys_sendmsg+0x1b1/0x290 net/socket.c:2802
>  do_syscall_x64 arch/x86/entry/syscall_64.c:61 [inline]
>  do_syscall_64+0x166/0x520 arch/x86/entry/syscall_64.c:84
>  entry_SYSCALL_64_after_hwframe+0x77/0x7f
> RIP: 0033:0x7f47db99e159
> Code: ff c3 66 2e 0f 1f 84 00 00 00 00 00 0f 1f 44 00 00 48 89 f8 48 89 f=
7 48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 ff=
 ff 73 01 c3 48 c7 c1 e8 ff ff ff f7 d8 64 89 01 48
> RSP: 002b:00007f47dc90c028 EFLAGS: 00000246 ORIG_RAX: 000000000000002e
> RAX: ffffffffffffffda RBX: 00007f47dbc25fa0 RCX: 00007f47db99e159
> RDX: 0000000004048004 RSI: 00002000000001c0 RDI: 0000000000000005
> RBP: 00007f47dba3503b R08: 0000000000000000 R09: 0000000000000000
> R10: 0000000000000000 R11: 0000000000000246 R12: 0000000000000000
> R13: 00007f47dbc26038 R14: 00007f47dbc25fa0 R15: 00007ffc72db97b8
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
> To test a fix for this bug, please reply with `#syz test`
> (on a separate line) and attach the patch to the email.
>
> Notes:
> - The patch will be applied on top of the tested series (as an
>   incremental fix).
> - To test a new version of the whole series, please send it directly
>   to syzbot@lists.linux.dev.
> - Arguments like custom git repos and branches are not supported.
>
> The email will later be sent to:
> [ahemadkhawar123@gmail.com ast@kernel.org bpf@vger.kernel.org daniel@ioge=
arbox.net edumazet@google.com hawk@kernel.org horms@kernel.org john.fastabe=
nd@gmail.com kuba@kernel.org linux-kernel@vger.kernel.org maciej.fijalkowsk=
i@intel.com magnus.karlsson@intel.com netdev@vger.kernel.org pabeni@redhat.=
com sdf@fomichev.me syzbot@syzkaller.appspotmail.com]
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
-upstream-moderation/6aa95355.f81106d8.2ab401.0069.GAE%40google.com.
