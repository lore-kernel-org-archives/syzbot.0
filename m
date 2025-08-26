Received: from mail-oo1-f52.google.com (mail-oo1-f52.google.com [209.85.161.52])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C35CC220F4F
	for <syzbot@lists.linux.dev>; Tue, 26 Aug 2025 08:49:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.161.52
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756198189; cv=none; b=k4YpEp4IknsLLguKuIfxIDwMxprlAChGl4BTRoPOwEBK6Aa/1+DIp5Udk9Nv4/eUXQ9/7Vnhi2IMf0fNi65vlZ/RKcqf/51gVVwdksbQryRyf4+LGLzNzOQsa6dmeNvWJdH7G6KQvOxInxHquuGxkUzJOGRQzQuMdrOpWD6xTFI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756198189; c=relaxed/simple;
	bh=CZ3YjGQgXMbBbzErY6fW471WJaSTzjfCacECDZSPuC0=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=jbRBTjoA6+hm6iDXitqiUiTKlcO/0bXT5p4yI9JphDSF+6QBV9znuPeOcXQ06mq2l0Oobt/Hk+M7gZ0M2ikwf7gpVGUum0oTZ4jxNdic1qhjqfIk9mP+g3pqlb7Oa+SP4/0wtW7EYa6kvvytAzzZ2j2AJcvcQ5iRHvot73cyRZE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=2/P2Ntww; arc=none smtp.client-ip=209.85.161.52
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="2/P2Ntww"
Received: by mail-oo1-f52.google.com with SMTP id 006d021491bc7-61da74ac09fso1092226eaf.2
        for <syzbot@lists.linux.dev>; Tue, 26 Aug 2025 01:49:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1756198187; x=1756802987; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=fg/fKz0DooKXemZgbcrD4FO5DniNQxRPpLlZFrC6AkY=;
        b=2/P2NtwwX39LZv9fldrSOt+pU4saihSHPO41TOOO1Bj/kcY4V3YTSDjbDtWvHvyZnI
         1/M11pNcmiQsjR4hQQGAU9oPJjXkdNFDXAl3loh2opAqOf/zFiOt5dBbGA/8IGzgGefs
         30FxfVRaetpWGkXqMsSN4bf/NFl567J5U0mNenL2wjGCkySqkhVkqVgA5KzBa2Lv56kg
         NRMmiX1G5wlmYAZ1VXDf/YC58Oy/7/t/ejIdoXo++QRCYwDq8TiqnSfjgXdaWIWXo9Mt
         gYqBlbdb+bfOJOvfnDDuIoAXrFDpR43xauAn/+wYOMYiYZjQPd3fR00FLSsAgyp5H787
         hong==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1756198187; x=1756802987;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=fg/fKz0DooKXemZgbcrD4FO5DniNQxRPpLlZFrC6AkY=;
        b=jBKJIV06XDPSwPjWEFarrHh+L9DadNnY325WrNY48JYZWIk5L3cVLKouv5RU2PTYZi
         W8qJqUtPV4Warf631Qn/K8Coz614Tq9vostI2gmVnzE2jkK500BAjJ2BZdFmcsap/Lc/
         lXzEIffZhsk5Tp5Q0lQCTIhIXSPi+iXJYDeiRA0Y2U5DKbRgtI9hI1YI2kdIe96jjmNe
         UMYQDiZM5lMmiVh0GF54uYAiyos2I6Fajf4FRyOO8A1s9CuTPGmJAO3gU8YDA79S5jHo
         vbYFZyoHOzL1Ka+k3hHbmq2XAQ8EhMkLfLLZt6ecZMry5aaeaPh59d4LREkoAMYj/GJY
         zB1w==
X-Forwarded-Encrypted: i=1; AJvYcCWVFcfR4gfR8Xk0SbSnM+HMBpKJyqCuxEZBdV4nc2eJSygVCO0aAZj2r5MpBYf7NDEupe16clc=@lists.linux.dev
X-Gm-Message-State: AOJu0Yxa3Cdlm/4e7iMTLJhHd40yLCuSLQfc+5RyP/lln2xqpb3D5udW
	hOjWUPOWV2DkHgy70eVmEghTFPWg9BoTLmIp/FgGlKzaAcfWdbgS3aS9GMWkOBT89JiiOrP/hD1
	gb+nR3/VrFkhE3NQAbdk2SwFar0pGoUNQEsUOoEgj
X-Gm-Gg: ASbGncvEF9Xsb218p+yG5nZiX1MoE7KzQ/vzEHfvN2Un0j6F1bcPPhRZWLTMl505vXN
	gJPhyvq3z/qMqj6IvPqxk0mdnrWCyBlJr4qORfMWqk6uzDXKjN0q0WCYrdNZyXDLaLbc4WHxEso
	g9BCEPTRNKaLcmlvS3sRVtgkVc7kVlzg69MtxJRjPMSIB8+U0Jt+Knfq6MOiA/ass7KLkgpRBFB
	J98D+N1ASoPfn2M5zDXacMOqFSim/i5tLknER2gLBTX7NKh3MRp6g0=
X-Google-Smtp-Source: AGHT+IGe69ZUF1p0+O8DRabdnb/Dx+kH3eQNsaWpZHs1mSZXlEiRjJkIgqPZmR7lk+anJCZjW7Jnplv/5NkLEkf4Mwg=
X-Received: by 2002:a05:6820:22a7:b0:61d:f834:e0d with SMTP id
 006d021491bc7-61df8341241mr235885eaf.3.1756198186483; Tue, 26 Aug 2025
 01:49:46 -0700 (PDT)
Precedence: bulk
X-Mailing-List: syzbot@lists.linux.dev
List-Id: <syzbot.lists.linux.dev>
List-Subscribe: <mailto:syzbot+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:syzbot+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <68ad72a8.050a0220.37038e.00b5.GAE@google.com>
In-Reply-To: <68ad72a8.050a0220.37038e.00b5.GAE@google.com>
From: Aleksandr Nogikh <nogikh@google.com>
Date: Tue, 26 Aug 2025 10:49:35 +0200
X-Gm-Features: Ac12FXz4KR4XqpYgkPzd7Xvqw90afKHwPKD7wmkW047IOwl_JoXhqxzw9gDy7Q4
Message-ID: <CANp29Y4mJ5=e4YPa0mGtNJgnJ1uSBqTn3sp8kgdw4M-9BiiMnA@mail.gmail.com>
Subject: Re: [moderation/CI] Re: hsr: add rcu lock for all hsr_for_each_port caller
To: syzbot ci <syzbot+ci9cb1724b6d94f7cb@syzkaller.appspotmail.com>
Cc: syzkaller-upstream-moderation@googlegroups.com, syzbot@lists.linux.dev
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

#syz upstream

On Tue, Aug 26, 2025 at 10:39=E2=80=AFAM syzbot ci
<syzbot+ci9cb1724b6d94f7cb@syzkaller.appspotmail.com> wrote:
>
> syzbot ci has tested the following series
>
> [v1] hsr: add rcu lock for all hsr_for_each_port caller
> https://lore.kernel.org/all/20250826041148.426598-1-liuhangbin@gmail.com
> * [PATCH net] hsr: add rcu lock for all hsr_for_each_port caller
>
> and found the following issue:
> BUG: sleeping function called from invalid context in dev_set_allmulti
>
> Full report is available here:
> https://ci.syzbot.org/series/3992f7f8-7052-4440-bc88-86be6f350cec
>
> ***
>
> BUG: sleeping function called from invalid context in dev_set_allmulti
>
> tree:      net
> URL:       https://kernel.googlesource.com/pub/scm/linux/kernel/git/netde=
v/net.git
> base:      51f27beeb79f9f92682158999bab489ff4fa16f6
> arch:      amd64
> compiler:  Debian clang version 20.1.7 (++20250616065708+6146a88f6049-1~e=
xp1~20250616065826.132), Debian LLD 20.1.7
> config:    https://ci.syzbot.org/builds/1a20cfb3-c3a6-4ba9-9bda-2f49b971b=
39c/config
> C repro:   https://ci.syzbot.org/findings/9de559bc-f498-4b86-ab2e-34f1510=
e4fe4/c_repro
> syz repro: https://ci.syzbot.org/findings/9de559bc-f498-4b86-ab2e-34f1510=
e4fe4/syz_repro
>
> hsr1: entered promiscuous mode
> hsr1: entered allmulticast mode
> bond0: entered allmulticast mode
> bond_slave_0: entered allmulticast mode
> bond_slave_1: entered allmulticast mode
> BUG: sleeping function called from invalid context at kernel/locking/mute=
x.c:575
> in_atomic(): 0, irqs_disabled(): 0, non_block: 0, pid: 5996, name: syz.0.=
17
> preempt_count: 0, expected: 0
> RCU nest depth: 1, expected: 0
> 3 locks held by syz.0.17/5996:
>  #0: ffffffff8fa59670 (&ops->srcu#2){.+.+}-{0:0}, at: rcu_lock_acquire in=
clude/linux/rcupdate.h:331 [inline]
>  #0: ffffffff8fa59670 (&ops->srcu#2){.+.+}-{0:0}, at: rcu_read_lock inclu=
de/linux/rcupdate.h:841 [inline]
>  #0: ffffffff8fa59670 (&ops->srcu#2){.+.+}-{0:0}, at: rtnl_link_ops_get+0=
x23/0x250 net/core/rtnetlink.c:570
>  #1: ffffffff8f537c08 (rtnl_mutex){+.+.}-{4:4}, at: rtnl_lock net/core/rt=
netlink.c:80 [inline]
>  #1: ffffffff8f537c08 (rtnl_mutex){+.+.}-{4:4}, at: rtnl_nets_lock net/co=
re/rtnetlink.c:341 [inline]
>  #1: ffffffff8f537c08 (rtnl_mutex){+.+.}-{4:4}, at: rtnl_newlink+0x8db/0x=
1c70 net/core/rtnetlink.c:4056
>  #2: ffffffff8e139ea0 (rcu_read_lock){....}-{1:3}, at: rcu_lock_acquire i=
nclude/linux/rcupdate.h:331 [inline]
>  #2: ffffffff8e139ea0 (rcu_read_lock){....}-{1:3}, at: rcu_read_lock incl=
ude/linux/rcupdate.h:841 [inline]
>  #2: ffffffff8e139ea0 (rcu_read_lock){....}-{1:3}, at: hsr_change_rx_flag=
s+0x28/0x2d0 net/hsr/hsr_device.c:522
> CPU: 0 UID: 0 PID: 5996 Comm: syz.0.17 Not tainted syzkaller #0 PREEMPT(f=
ull)
> Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS 1.16.2-debian-1.=
16.2-1 04/01/2014
> Call Trace:
>  <TASK>
>  dump_stack_lvl+0x189/0x250 lib/dump_stack.c:120
>  __might_resched+0x495/0x610 kernel/sched/core.c:8957
>  __mutex_lock_common kernel/locking/mutex.c:575 [inline]
>  __mutex_lock+0x109/0x1360 kernel/locking/mutex.c:760
>  netdev_lock include/linux/netdevice.h:2761 [inline]
>  netdev_lock_ops include/net/netdev_lock.h:42 [inline]
>  dev_set_allmulti+0x10e/0x260 net/core/dev_api.c:312
>  hsr_change_rx_flags+0x1b2/0x2d0 net/hsr/hsr_device.c:530
>  dev_change_rx_flags net/core/dev.c:9332 [inline]
>  netif_set_allmulti+0x212/0x380 net/core/dev.c:9430
>  __dev_change_flags+0x52e/0x6d0 net/core/dev.c:9571
>  rtnl_configure_link net/core/rtnetlink.c:3579 [inline]
>  rtnl_newlink_create+0x555/0xb00 net/core/rtnetlink.c:3835
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
> RIP: 0033:0x7ff4b418ebe9
> Code: ff ff c3 66 2e 0f 1f 84 00 00 00 00 00 0f 1f 40 00 48 89 f8 48 89 f=
7 48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 ff=
 ff 73 01 c3 48 c7 c1 a8 ff ff ff f7 d8 64 89 01 48
> RSP: 002b:00007ffef8386cc8 EFLAGS: 00000246 ORIG_RAX: 000000000000002e
> RAX: ffffffffffffffda RBX: 00007ff4b43b5fa0 RCX: 00007ff4b418ebe9
> RDX: 00000000000080c0 RSI: 00002000000002c0 RDI: 0000000000000003
> RBP: 00007ff4b4211e19 R08: 0000000000000000 R09: 0000000000000000
> R10: 0000000000000000 R11: 0000000000000246 R12: 0000000000000000
> R13: 00007ff4b43b5fa0 R14: 00007ff4b43b5fa0 R15: 0000000000000003
>  </TASK>
>
> =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D
> [ BUG: Invalid wait context ]
> syzkaller #0 Tainted: G        W
> -----------------------------
> syz.0.17/5996 is trying to lock:
> ffff888110848d30 (&dev_instance_lock_key#3){+.+.}-{4:4}, at: netdev_lock =
include/linux/netdevice.h:2761 [inline]
> ffff888110848d30 (&dev_instance_lock_key#3){+.+.}-{4:4}, at: netdev_lock_=
ops include/net/netdev_lock.h:42 [inline]
> ffff888110848d30 (&dev_instance_lock_key#3){+.+.}-{4:4}, at: dev_set_allm=
ulti+0x10e/0x260 net/core/dev_api.c:312
> other info that might help us debug this:
> context-{5:5}
> 3 locks held by syz.0.17/5996:
>  #0: ffffffff8fa59670 (&ops->srcu#2){.+.+}-{0:0}, at: rcu_lock_acquire in=
clude/linux/rcupdate.h:331 [inline]
>  #0: ffffffff8fa59670 (&ops->srcu#2){.+.+}-{0:0}, at: rcu_read_lock inclu=
de/linux/rcupdate.h:841 [inline]
>  #0: ffffffff8fa59670 (&ops->srcu#2){.+.+}-{0:0}, at: rtnl_link_ops_get+0=
x23/0x250 net/core/rtnetlink.c:570
>  #1: ffffffff8f537c08 (rtnl_mutex){+.+.}-{4:4}, at: rtnl_lock net/core/rt=
netlink.c:80 [inline]
>  #1: ffffffff8f537c08 (rtnl_mutex){+.+.}-{4:4}, at: rtnl_nets_lock net/co=
re/rtnetlink.c:341 [inline]
>  #1: ffffffff8f537c08 (rtnl_mutex){+.+.}-{4:4}, at: rtnl_newlink+0x8db/0x=
1c70 net/core/rtnetlink.c:4056
>  #2: ffffffff8e139ea0 (rcu_read_lock){....}-{1:3}, at: rcu_lock_acquire i=
nclude/linux/rcupdate.h:331 [inline]
>  #2: ffffffff8e139ea0 (rcu_read_lock){....}-{1:3}, at: rcu_read_lock incl=
ude/linux/rcupdate.h:841 [inline]
>  #2: ffffffff8e139ea0 (rcu_read_lock){....}-{1:3}, at: hsr_change_rx_flag=
s+0x28/0x2d0 net/hsr/hsr_device.c:522
> stack backtrace:
> CPU: 0 UID: 0 PID: 5996 Comm: syz.0.17 Tainted: G        W           syzk=
aller #0 PREEMPT(full)
> Tainted: [W]=3DWARN
> Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS 1.16.2-debian-1.=
16.2-1 04/01/2014
> Call Trace:
>  <TASK>
>  dump_stack_lvl+0x189/0x250 lib/dump_stack.c:120
>  print_lock_invalid_wait_context kernel/locking/lockdep.c:4830 [inline]
>  check_wait_context kernel/locking/lockdep.c:4902 [inline]
>  __lock_acquire+0xbcb/0xd20 kernel/locking/lockdep.c:5187
>  lock_acquire+0x120/0x360 kernel/locking/lockdep.c:5868
>  __mutex_lock_common kernel/locking/mutex.c:598 [inline]
>  __mutex_lock+0x187/0x1360 kernel/locking/mutex.c:760
>  netdev_lock include/linux/netdevice.h:2761 [inline]
>  netdev_lock_ops include/net/netdev_lock.h:42 [inline]
>  dev_set_allmulti+0x10e/0x260 net/core/dev_api.c:312
>  hsr_change_rx_flags+0x1b2/0x2d0 net/hsr/hsr_device.c:530
>  dev_change_rx_flags net/core/dev.c:9332 [inline]
>  netif_set_allmulti+0x212/0x380 net/core/dev.c:9430
>  __dev_change_flags+0x52e/0x6d0 net/core/dev.c:9571
>  rtnl_configure_link net/core/rtnetlink.c:3579 [inline]
>  rtnl_newlink_create+0x555/0xb00 net/core/rtnetlink.c:3835
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
> RIP: 0033:0x7ff4b418ebe9
> Code: ff ff c3 66 2e 0f 1f 84 00 00 00 00 00 0f 1f 40 00 48 89 f8 48 89 f=
7 48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 ff=
 ff 73 01 c3 48 c7 c1 a8 ff ff ff f7 d8 64 89 01 48
> RSP: 002b:00007ffef8386cc8 EFLAGS: 00000246 ORIG_RAX: 000000000000002e
> RAX: ffffffffffffffda RBX: 00007ff4b43b5fa0 RCX: 00007ff4b418ebe9
> RDX: 00000000000080c0 RSI: 00002000000002c0 RDI: 0000000000000003
> RBP: 00007ff4b4211e19 R08: 0000000000000000 R09: 0000000000000000
> R10: 0000000000000000 R11: 0000000000000246 R12: 0000000000000000
> R13: 00007ff4b43b5fa0 R14: 00007ff4b43b5fa0 R15: 0000000000000003
>  </TASK>
> dummy0: entered allmulticast mode
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
> [aleksander.lobakin@intel.com arvid.brodin@alten.se danishanwar@ti.com da=
vem@davemloft.net edumazet@google.com ffmancera@riseup.net horms@kernel.org=
 jkarrenpalo@gmail.com johannes.berg@intel.com kuba@kernel.org kuniyu@googl=
e.com liaoyu15@huawei.com liuhangbin@gmail.com m-karicheri2@ti.com netdev@v=
ger.kernel.org pabeni@redhat.com sdf@fomichev.me shaw.leon@gmail.com w-kwok=
2@ti.com]
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
-upstream-moderation/68ad72a8.050a0220.37038e.00b5.GAE%40google.com.
