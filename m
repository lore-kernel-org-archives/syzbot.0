Received: from mail-oo1-f53.google.com (mail-oo1-f53.google.com [209.85.161.53])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1BDEC2AE77
	for <syzbot@lists.linux.dev>; Wed,  3 Sep 2025 21:51:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.161.53
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756936317; cv=none; b=p5sSCwh3MsJsR2CSVAYbN2UEzCcSeJCJNYwhf+Xt0bihpZnXbABgXLOH0p6n0H5W9laVAmQ46O+0dESU90xBfPfHOgKkx47tALtP1D21jTgL3mAuXAhlBM9fpWuV/d4oJqc3Bli+kqlDgZhap4OtHUbnZTkivECNzjentpwkNrc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756936317; c=relaxed/simple;
	bh=j7wgnoOd83sqH7p0G/Xk2pKf85z+Td5Tg2g038jz8xY=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=qti5wq1U4EF5UrQEpdJXFHhOBobCsorJZtmZIZ7NOfLY3ulXglEK/uvzDvNvoNRv1IoQq0TbdXlju1bRIc6yyBixX2505RrOAeTHX6/yZqxLwP3dgFoqaLoUYs44ioeHkjm6MUx3jk9BBSl7pfwHRYTrlVfOZrUuOh/GBjCuVrQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=wFkCWVfg; arc=none smtp.client-ip=209.85.161.53
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="wFkCWVfg"
Received: by mail-oo1-f53.google.com with SMTP id 006d021491bc7-61bd4a3f39cso108693eaf.0
        for <syzbot@lists.linux.dev>; Wed, 03 Sep 2025 14:51:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1756936313; x=1757541113; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=49NVM/idX+llj3c9XkfWsmuNCJo8m0ML4+QOT0e0Bhk=;
        b=wFkCWVfgKwUXckCHDLkIzgvH3ip+Qoqgh3IJPjStpUova2o0ntZakhfsfDx0r3vBjl
         dHFGVHLrEXwY0MGi72MWGzGc/fQyTiounMt8SSKLuM6UMlKfiYqfZhxXziSqReMUkWag
         d37xIHOU3Iz2z2Ce9BwA2pu+iDght/ZJBLPsfjoSwA1Sh64EX2DudF4FF7aRJU5ywVjT
         eTMLQ7kq22gci3fQpexImGffcYpb4yLinOpo7RaqPXa0H2+NFwe3/pgFdyQOvU4aNKOc
         /YzgX5liLvyqZEnEslfdDzw8DzKuYcd64QOi3KZVrviRPcHy3QBMUTT9nqDT2519Ng0e
         9niw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1756936313; x=1757541113;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=49NVM/idX+llj3c9XkfWsmuNCJo8m0ML4+QOT0e0Bhk=;
        b=lNj7bHJWohpp8qMrcI/TDB0HBFQTo7wQWeO5cOorl9tKmrE9umUbtnRE7ghnLr7DE6
         L7vuA10lkZ/IBjgZ0rf4gx1csXaZ9Hc1yBtQ2LyjA2AGUZ5+O2wzQ+Xj4rAJnuR8PvZO
         5wVkDRjXC8HKFtrd7DH9WRL1Cp2+bvo1dkJPDzAQ+jPGsJDjlO4lODkA86MhnO0c8hwf
         9UHbjlOnz7EPct6ueIyriT44Kpos3qxB0h1pt/XB9RvofZ8nRSCk7BnPAdyT2QNLm3fv
         pbdSAIfT81dQGhevm6hfwGaKrC3sXmDXZIhzX+EpSoRdLL9uGePoLR3jd4nZlbWhWV+f
         VkTA==
X-Forwarded-Encrypted: i=1; AJvYcCVajfl9pTuCEilGzjaA45ZyW9vAtFSGvho/VxsPV4sWDWfsabkZg6nvCzYMSw+KptfeeIUyvPA=@lists.linux.dev
X-Gm-Message-State: AOJu0YwTaPAQcqnuoprKtrFJH0vAbxGPgMyAcs+OlqACKzetXOORWXlh
	kiYT9ZJ9J6iqMRDrS6OjUshrYDl3FCc9W6+v4sgOu4j+Py6vgErXDAeiYSjzGJ9FE6Q7Bivm0eJ
	4e6LKaASJYFqfkgZaBJUXmuYhK1Y7fBHRBDnWCvnP
X-Gm-Gg: ASbGncvIf82EA9Bp7woQYnVK2Y88PwY4ZlT5kAu6nr6LfwMj1tJ+IKXS5AVruBJWRD9
	vXqMdXlNYF8GcXEsWyvOZyz4KoRBHWEOL3z5QCkCYLjHS5vG+9GR2vVb4JGWJiSbOM/+QgnNE4Z
	VNFFh6s5f4EEy2i7WGLbernDp1fq0ZmO79CD1jRy6VAIXNN+l2GaCisnHj2Kb50eZ2J6bMSK9fN
	d3QkX/vQr7nTl56Sq8g/fMRvNVBTPZJ9HKbpO98YGJELQ8=
X-Google-Smtp-Source: AGHT+IF+MfXSwLa+UKtOrPTQ7jZJMCA4HIdsW5mJ9dJY9psPlcn4qB6/7Ye9onq/hJ3dF5IU7O/YxXbbKaRLSZLcprQ=
X-Received: by 2002:a05:6820:1c9f:b0:61e:7925:d16d with SMTP id
 006d021491bc7-61e7925e387mr593582eaf.3.1756936312823; Wed, 03 Sep 2025
 14:51:52 -0700 (PDT)
Precedence: bulk
X-Mailing-List: syzbot@lists.linux.dev
List-Id: <syzbot.lists.linux.dev>
List-Subscribe: <mailto:syzbot+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:syzbot+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <68b89342.050a0220.3db4df.01fe.GAE@google.com>
In-Reply-To: <68b89342.050a0220.3db4df.01fe.GAE@google.com>
From: Aleksandr Nogikh <nogikh@google.com>
Date: Wed, 3 Sep 2025 23:51:41 +0200
X-Gm-Features: Ac12FXyiHo33Roafwsq4L0xi7e6cjR0PhWPSs0oFbSF34m1BGdLQ5iOurKP-e7Y
Message-ID: <CANp29Y4RL4_w2VEnpnOjRpcgq26_E6+TS3-yS+2pwzDerGahMw@mail.gmail.com>
Subject: Re: [moderation/CI] Re: inet: Avoid established lookup missing active sk
To: syzbot ci <syzbot+ci5cfb5e22bbd89274@syzkaller.appspotmail.com>
Cc: syzkaller-upstream-moderation@googlegroups.com, syzbot@lists.linux.dev
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

#syz upstream

On Wed, Sep 3, 2025 at 9:13=E2=80=AFPM syzbot ci
<syzbot+ci5cfb5e22bbd89274@syzkaller.appspotmail.com> wrote:
>
> syzbot ci has tested the following series
>
> [v1] inet: Avoid established lookup missing active sk
> https://lore.kernel.org/all/20250903024406.2418362-1-xuanqiang.luo@linux.=
dev
> * [PATCH net] inet: Avoid established lookup missing active sk
>
> and found the following issue:
> inconsistent lock state in valid_state
>
> Full report is available here:
> https://ci.syzbot.org/series/e3eb0778-d6ff-4b0c-ae24-a5451a3472cb
>
> ***
>
> inconsistent lock state in valid_state
>
> tree:      net
> URL:       https://kernel.googlesource.com/pub/scm/linux/kernel/git/netde=
v/net.git
> base:      788bc43d8330511af433bf282021a8fecb6b9009
> arch:      amd64
> compiler:  Debian clang version 20.1.8 (++20250708063551+0c9f909b7976-1~e=
xp1~20250708183702.136), Debian LLD 20.1.8
> config:    https://ci.syzbot.org/builds/4fba502f-1812-45fd-881c-e58899960=
74b/config
> C repro:   https://ci.syzbot.org/findings/1fde3273-fc6e-4ca1-9a99-a8f866c=
822cd/c_repro
> syz repro: https://ci.syzbot.org/findings/1fde3273-fc6e-4ca1-9a99-a8f866c=
822cd/syz_repro
>
> =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D
> WARNING: inconsistent lock state
> syzkaller #0 Not tainted
> --------------------------------
> inconsistent {IN-SOFTIRQ-W} -> {SOFTIRQ-ON-W} usage.
> syz.0.17/5984 [HC0[0]:SC0[0]:HE1:SE1] takes:
> ffffc90000069958 (&ptr[i]){+.?.}-{3:3}, at: spin_lock include/linux/spinl=
ock.h:351 [inline]
> ffffc90000069958 (&ptr[i]){+.?.}-{3:3}, at: __inet_lookup_established+0x7=
1d/0x8d0 net/ipv4/inet_hashtables.c:537
> {IN-SOFTIRQ-W} state was registered at:
>   lock_acquire+0x120/0x360 kernel/locking/lockdep.c:5868
>   __raw_spin_lock include/linux/spinlock_api_smp.h:133 [inline]
>   _raw_spin_lock+0x2e/0x40 kernel/locking/spinlock.c:154
>   spin_lock include/linux/spinlock.h:351 [inline]
>   __inet_lookup_established+0x71d/0x8d0 net/ipv4/inet_hashtables.c:537
>   tcp_v4_early_demux+0x4e1/0x9d0 net/ipv4/tcp_ipv4.c:1995
>   ip_rcv_finish_core+0x108e/0x1c00 net/ipv4/ip_input.c:346
>   ip_list_rcv_finish net/ipv4/ip_input.c:616 [inline]
>   ip_sublist_rcv+0x397/0x9b0 net/ipv4/ip_input.c:642
>   ip_list_rcv+0x3e2/0x430 net/ipv4/ip_input.c:676
>   __netif_receive_skb_list_ptype net/core/dev.c:6034 [inline]
>   __netif_receive_skb_list_core+0x7d2/0x800 net/core/dev.c:6081
>   __netif_receive_skb_list net/core/dev.c:6133 [inline]
>   netif_receive_skb_list_internal+0x975/0xcc0 net/core/dev.c:6224
>   gro_normal_list include/net/gro.h:532 [inline]
>   gro_flush_normal include/net/gro.h:540 [inline]
>   napi_complete_done+0x2f2/0x7c0 net/core/dev.c:6593
>   e1000_clean+0xd0b/0x2b00 drivers/net/ethernet/intel/e1000/e1000_main.c:=
3815
>   __napi_poll+0xc7/0x360 net/core/dev.c:7506
>   napi_poll net/core/dev.c:7569 [inline]
>   net_rx_action+0x707/0xe30 net/core/dev.c:7696
>   handle_softirqs+0x286/0x870 kernel/softirq.c:579
>   __do_softirq kernel/softirq.c:613 [inline]
>   invoke_softirq kernel/softirq.c:453 [inline]
>   __irq_exit_rcu+0xca/0x1f0 kernel/softirq.c:680
>   irq_exit_rcu+0x9/0x30 kernel/softirq.c:696
>   common_interrupt+0xbb/0xe0 arch/x86/kernel/irq.c:318
>   asm_common_interrupt+0x26/0x40 arch/x86/include/asm/idtentry.h:693
>   native_safe_halt arch/x86/include/asm/irqflags.h:48 [inline]
>   pv_native_safe_halt+0x13/0x20 arch/x86/kernel/paravirt.c:81
>   arch_safe_halt arch/x86/include/asm/paravirt.h:107 [inline]
>   default_idle+0x13/0x20 arch/x86/kernel/process.c:757
>   default_idle_call+0x74/0xb0 kernel/sched/idle.c:122
>   cpuidle_idle_call kernel/sched/idle.c:190 [inline]
>   do_idle+0x1e8/0x510 kernel/sched/idle.c:330
>   cpu_startup_entry+0x44/0x60 kernel/sched/idle.c:428
>   start_secondary+0x101/0x110 arch/x86/kernel/smpboot.c:315
>   common_startup_64+0x13e/0x147
> irq event stamp: 807
> hardirqs last  enabled at (807): [<ffffffff8184e7fd>] __local_bh_enable_i=
p+0x12d/0x1c0 kernel/softirq.c:412
> hardirqs last disabled at (805): [<ffffffff8184e79e>] __local_bh_enable_i=
p+0xce/0x1c0 kernel/softirq.c:389
> softirqs last  enabled at (806): [<ffffffff8962777b>] local_bh_disable in=
clude/linux/bottom_half.h:20 [inline]
> softirqs last  enabled at (806): [<ffffffff8962777b>] rcu_read_lock_bh in=
clude/linux/rcupdate.h:892 [inline]
> softirqs last  enabled at (806): [<ffffffff8962777b>] __dev_queue_xmit+0x=
27b/0x3b50 net/core/dev.c:4650
> softirqs last disabled at (798): [<ffffffff8962777b>] local_bh_disable in=
clude/linux/bottom_half.h:20 [inline]
> softirqs last disabled at (798): [<ffffffff8962777b>] rcu_read_lock_bh in=
clude/linux/rcupdate.h:892 [inline]
> softirqs last disabled at (798): [<ffffffff8962777b>] __dev_queue_xmit+0x=
27b/0x3b50 net/core/dev.c:4650
>
> other info that might help us debug this:
>  Possible unsafe locking scenario:
>
>        CPU0
>        ----
>   lock(&ptr[i]);
>   <Interrupt>
>     lock(&ptr[i]);
>
>  *** DEADLOCK ***
>
> 1 lock held by syz.0.17/5984:
>  #0: ffffffff8e139ee0 (rcu_read_lock){....}-{1:3}, at: rcu_lock_acquire i=
nclude/linux/rcupdate.h:331 [inline]
>  #0: ffffffff8e139ee0 (rcu_read_lock){....}-{1:3}, at: rcu_read_lock incl=
ude/linux/rcupdate.h:841 [inline]
>  #0: ffffffff8e139ee0 (rcu_read_lock){....}-{1:3}, at: inet_diag_find_one=
_icsk+0x2e/0x790 net/ipv4/inet_diag.c:527
>
> stack backtrace:
> CPU: 0 UID: 0 PID: 5984 Comm: syz.0.17 Not tainted syzkaller #0 PREEMPT(f=
ull)
> Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS 1.16.2-debian-1.=
16.2-1 04/01/2014
> Call Trace:
>  <TASK>
>  dump_stack_lvl+0x189/0x250 lib/dump_stack.c:120
>  print_usage_bug+0x297/0x2e0 kernel/locking/lockdep.c:4042
>  valid_state+0xc3/0xf0 kernel/locking/lockdep.c:4056
>  mark_lock_irq+0x36/0x390 kernel/locking/lockdep.c:4267
>  mark_lock+0x11b/0x190 kernel/locking/lockdep.c:4753
>  mark_usage kernel/locking/lockdep.c:-1 [inline]
>  __lock_acquire+0x9e2/0xd20 kernel/locking/lockdep.c:5191
>  lock_acquire+0x120/0x360 kernel/locking/lockdep.c:5868
>  __raw_spin_lock include/linux/spinlock_api_smp.h:133 [inline]
>  _raw_spin_lock+0x2e/0x40 kernel/locking/spinlock.c:154
>  spin_lock include/linux/spinlock.h:351 [inline]
>  __inet_lookup_established+0x71d/0x8d0 net/ipv4/inet_hashtables.c:537
>  __inet_lookup include/net/inet_hashtables.h:408 [inline]
>  inet_lookup+0xc4/0x290 include/net/inet_hashtables.h:428
>  inet_diag_find_one_icsk+0x1c1/0x790 net/ipv4/inet_diag.c:529
>  inet_diag_dump_one_icsk+0xa4/0x520 net/ipv4/inet_diag.c:576
>  inet_diag_cmd_exact+0x3d5/0x4e0 net/ipv4/inet_diag.c:628
>  inet_diag_get_exact_compat net/ipv4/inet_diag.c:1406 [inline]
>  inet_diag_rcv_msg_compat+0x2b5/0x3b0 net/ipv4/inet_diag.c:1428
>  sock_diag_rcv_msg+0x4cc/0x600 net/core/sock_diag.c:-1
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
> RIP: 0033:0x7f0e1a18ebe9
> Code: ff ff c3 66 2e 0f 1f 84 00 00 00 00 00 0f 1f 40 00 48 89 f8 48 89 f=
7 48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 ff=
 ff 73 01 c3 48 c7 c1 a8 ff ff ff f7 d8 64 89 01 48
> RSP: 002b:00007ffd085aadc8 EFLAGS: 00000246 ORIG_RAX: 000000000000002e
> RAX: ffffffffffffffda RBX: 00007f0e1a3c5fa0 RCX: 00007f0e1a18ebe9
> RDX: 0000000000000000 RSI: 0000200000000200 RDI: 0000000000000003
> RBP: 00007f0e1a211e19 R08: 0000000000000000 R09: 0000000000000000
> R10: 0000000000000000 R11: 0000000000000246 R12: 0000000000000000
> R13: 00007f0e1a3c5fa0 R14: 00007f0e1a3c5fa0 R15: 0000000000000003
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
> The email will later be sent to:
> [davem@davemloft.net edumazet@google.com kernelxing@tencent.com kuba@kern=
el.org kuniyu@google.com luoxuanqiang@kylinos.cn netdev@vger.kernel.org xua=
nqiang.luo@linux.dev]
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
-upstream-moderation/68b89342.050a0220.3db4df.01fe.GAE%40google.com.
