Received: from mail-oo1-f51.google.com (mail-oo1-f51.google.com [209.85.161.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0BC8815442C
	for <syzbot@lists.linux.dev>; Thu,  6 Nov 2025 09:37:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.161.51
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762421873; cv=none; b=U7TpaAznEI+Pa3y5RRI3zM4AU4ETFK8CnBEiKl55eMB3B9/VQCiMXwbR9EzDDmW89GiPUWaXrbaVhTI31bwSOSgMgBRcYkyMZF2F+7KPDpbz7VkCYllJsbeckN+7R3gKLRxNIVWVaf4PKzWqfeJ+ZB41aEEBNC2gOrfcg1KJmSU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762421873; c=relaxed/simple;
	bh=By0eDV2eUsKzmKB9a87cT1gjC9JL2uds2JO6QKXYPuQ=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=Nwvk0CDvGQXp/4M+pKYE5ZfwrVaDsVj3WNL1sb7ErWfuUvEbqIM7iVLOw11IFgBekFmM8ibbnMJyfEaPC4wilurFPhZ5i6OtZiKnA5dELNfAsjoQJQcYkwiWpo5jXdBwpbY7ih4ZDmP+C8yTtBUjxBqj+HqhmUn9a+lIkeZqEkA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=NqrWKL0V; arc=none smtp.client-ip=209.85.161.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="NqrWKL0V"
Received: by mail-oo1-f51.google.com with SMTP id 006d021491bc7-656b9095869so239393eaf.3
        for <syzbot@lists.linux.dev>; Thu, 06 Nov 2025 01:37:51 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1762421871; x=1763026671; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=iANhqRQKoZPjWXfPqvmXDdzkn6LEcOlXb53iT4wT1Y4=;
        b=NqrWKL0VRhHLRPzBzP7p+/iaTDBqC6BGl/73pxQ+eP8gDHZMnKBapqnS+/G27/njpN
         BOAtYHSy2VdX6LZ3VeCVax6Vxu8xiLK9BKDlcBgL703fNk6kuYoQPkdSepHeeSDRoVC0
         61bd9KY9v7FVCvfy6iVXRYFm7ZHbLn27azYXnWnqKM96/0gi2m9i8EMq7azcgpVx0MkS
         dZ0Yx/I5rz6ECc5Z4WzBe0Gltmof8aIZCrqjU5cKkBCwwKBmS+mr0kbmYQVJdUQfXuZw
         E14UPOADhcqQtZM6MFZwHhLjHViQ0vQoZbSg3TqkU6ifrp8EczMtPhO5s9QYGRBQZOEv
         EzDw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1762421871; x=1763026671;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=iANhqRQKoZPjWXfPqvmXDdzkn6LEcOlXb53iT4wT1Y4=;
        b=Ln0VBLveq8JRmBf9ZGR2jNNtL4tV33k11PaPzgjHVKVRb817/znVPhRGmRpl2sZZpc
         XhioTg4VSzVwB/7QiFMdG0GJAUi2TFjwpwtpkUy0RinCOis23K97Tclp6Q33LIp4tula
         lE2aVX/8hf2EVoxWI1GeJW2CMCvweg5wRrykv+Ce5GhtVouepfMfF3dSYKiD2jIRoDU+
         /nbc9WVhzyzw1XNerl6fGjf9oXewWObpVRksJ02LhYcjtFXqlvxdRImo/ggAPB8FIgAv
         C56FF16I8VI5NNfsbE3SnX487DBTvsNSMamdKTILWuumggFVgf3PKQE6+8FaKsXDsiML
         ckpw==
X-Forwarded-Encrypted: i=1; AJvYcCUOCtBbbpFV8oNZOQEoN9ydWetXa3mYOkNPN8twj+2ZeK7udusiEfWqn0ZeLXfiQ8G4ebrIvZ0=@lists.linux.dev
X-Gm-Message-State: AOJu0YzHvLxp+Ri8jh3q2iv78w3kEbyjajSnePY7Q9kQNd5yPHKmtUHb
	LHYfDas08J9FG+tmlmZR728CFje5D0+nLxBid5dwpfFo44QA2cJuomRID1Q46B3a5TewuzuMIiu
	w3LkTybcIKmW/Xn5iWT8GKLefrMRJEvcZcJKZ/iS3smL7/7Q5CQEDK0j/Lvo=
X-Gm-Gg: ASbGnctE5YoZiWMEGxZIz/nAYz+ZqLfURrrsiGQdtc4rgPPxU6E0+t7Nj5ly6JhSWc6
	Cxpbppyapd+KhN1MUzYqZGNkpbZ+kdFQ5nK6CBJAvqzY2yoR4K5MvQoIY4ddFdLnj4kX+AQC0eW
	/dzFGh+I0Xm5dnjtu6UnWL0GcMtN0MEcmoh3yUvA2MDg7/G2Vutvud9iAlYGNFCjRAK+xVO+KWN
	ppTFg9egKE5+6ngM3t5rYtJEWZnKYa8QslaLmtmzxJ/2lqecuvsuWuBIyLv9qNcZLIoUgRhSNAO
	C3hE6V/5qctX6uoJazxy0+ysuOWnHfajb7rnnAaICd5XhYs=
X-Google-Smtp-Source: AGHT+IFJxu2CpMO+84Iq622OEWhowpB/hZdGhZN8LiELK0LbZV+OQcacA5CjXnIlCS04VYXgovTX+R8T9FOAT01KyYM=
X-Received: by 2002:a05:6820:621:b0:651:c86b:528e with SMTP id
 006d021491bc7-656bb5a4bd2mr3147667eaf.1.1762421870856; Thu, 06 Nov 2025
 01:37:50 -0800 (PST)
Precedence: bulk
X-Mailing-List: syzbot@lists.linux.dev
List-Id: <syzbot.lists.linux.dev>
List-Subscribe: <mailto:syzbot+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:syzbot+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <690c6a14.050a0220.1e8caa.00cf.GAE@google.com>
In-Reply-To: <690c6a14.050a0220.1e8caa.00cf.GAE@google.com>
From: Aleksandr Nogikh <nogikh@google.com>
Date: Thu, 6 Nov 2025 10:37:39 +0100
X-Gm-Features: AWmQ_bnIV88YWj0kHHbiY1Bez2vFJjan0DtUZW-ZBkuwQz8jhnjqYIAlMemerzk
Message-ID: <CANp29Y6bFNFQ0J-MnOLS9=bPe0SXc5wTEJmuSgE62bGC4acbRg@mail.gmail.com>
Subject: Re: [moderation/CI] Re: tipc: Fix use-after-free in tipc_mon_reinit_self().
To: syzbot ci <syzbot+ci5eddf783202c98fd@syzkaller.appspotmail.com>
Cc: syzkaller-upstream-moderation@googlegroups.com, syzbot@lists.linux.dev
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

#syz upstream

On Thu, Nov 6, 2025 at 10:27=E2=80=AFAM syzbot ci
<syzbot+ci5eddf783202c98fd@syzkaller.appspotmail.com> wrote:
>
> syzbot ci has tested the following series
>
> [v1] tipc: Fix use-after-free in tipc_mon_reinit_self().
> https://lore.kernel.org/all/20251106053309.401275-1-kuniyu@google.com
> * [PATCH v1 net] tipc: Fix use-after-free in tipc_mon_reinit_self().
>
> and found the following issue:
> possible deadlock in tipc_mon_reinit_self
>
> Full report is available here:
> https://ci.syzbot.org/series/bfabf013-65e3-4ca9-8f54-0c7eef8be01a
>
> ***
>
> possible deadlock in tipc_mon_reinit_self
>
> tree:      net
> URL:       https://kernel.googlesource.com/pub/scm/linux/kernel/git/netde=
v/net.git
> base:      3d18a84eddde169d6dbf3c72cc5358b988c347d0
> arch:      amd64
> compiler:  Debian clang version 20.1.8 (++20250708063551+0c9f909b7976-1~e=
xp1~20250708183702.136), Debian LLD 20.1.8
> config:    https://ci.syzbot.org/builds/b2774856-e331-420e-a340-5107ec4b0=
6f9/config
> C repro:   https://ci.syzbot.org/findings/1f0a4298-b797-4217-8d6d-15f98c0=
ffd38/c_repro
> syz repro: https://ci.syzbot.org/findings/1f0a4298-b797-4217-8d6d-15f98c0=
ffd38/syz_repro
>
> tipc: Started in network mode
> tipc: Node identity 4, cluster identity 4711
> tipc: Node number set to 4
> =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
> WARNING: possible recursive locking detected
> syzkaller #0 Not tainted
> --------------------------------------------
> syz.0.17/5963 is trying to acquire lock:
> ffffffff8f2cb1c8 (rtnl_mutex){+.+.}-{4:4}, at: tipc_mon_reinit_self+0x25/=
0x360 net/tipc/monitor.c:714
>
> but task is already holding lock:
> ffffffff8f2cb1c8 (rtnl_mutex){+.+.}-{4:4}, at: __tipc_nl_compat_doit net/=
tipc/netlink_compat.c:358 [inline]
> ffffffff8f2cb1c8 (rtnl_mutex){+.+.}-{4:4}, at: tipc_nl_compat_doit+0x1fd/=
0x5f0 net/tipc/netlink_compat.c:393
>
> other info that might help us debug this:
>  Possible unsafe locking scenario:
>
>        CPU0
>        ----
>   lock(rtnl_mutex);
>   lock(rtnl_mutex);
>
>  *** DEADLOCK ***
>
>  May be due to missing lock nesting notation
>
> 3 locks held by syz.0.17/5963:
>  #0: ffffffff8f331050 (cb_lock){++++}-{4:4}, at: genl_rcv+0x19/0x40 net/n=
etlink/genetlink.c:1218
>  #1: ffffffff8f330e68 (genl_mutex){+.+.}-{4:4}, at: genl_lock net/netlink=
/genetlink.c:35 [inline]
>  #1: ffffffff8f330e68 (genl_mutex){+.+.}-{4:4}, at: genl_op_lock net/netl=
ink/genetlink.c:60 [inline]
>  #1: ffffffff8f330e68 (genl_mutex){+.+.}-{4:4}, at: genl_rcv_msg+0x10d/0x=
790 net/netlink/genetlink.c:1209
>  #2: ffffffff8f2cb1c8 (rtnl_mutex){+.+.}-{4:4}, at: __tipc_nl_compat_doit=
 net/tipc/netlink_compat.c:358 [inline]
>  #2: ffffffff8f2cb1c8 (rtnl_mutex){+.+.}-{4:4}, at: tipc_nl_compat_doit+0=
x1fd/0x5f0 net/tipc/netlink_compat.c:393
>
> stack backtrace:
> CPU: 1 UID: 0 PID: 5963 Comm: syz.0.17 Not tainted syzkaller #0 PREEMPT(f=
ull)
> Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS 1.16.2-debian-1.=
16.2-1 04/01/2014
> Call Trace:
>  <TASK>
>  dump_stack_lvl+0x189/0x250 lib/dump_stack.c:120
>  print_deadlock_bug+0x28b/0x2a0 kernel/locking/lockdep.c:3041
>  check_deadlock kernel/locking/lockdep.c:3093 [inline]
>  validate_chain+0x1a3f/0x2140 kernel/locking/lockdep.c:3895
>  __lock_acquire+0xab9/0xd20 kernel/locking/lockdep.c:5237
>  lock_acquire+0x120/0x360 kernel/locking/lockdep.c:5868
>  __mutex_lock_common kernel/locking/mutex.c:598 [inline]
>  __mutex_lock+0x187/0x1350 kernel/locking/mutex.c:760
>  tipc_mon_reinit_self+0x25/0x360 net/tipc/monitor.c:714
>  tipc_net_finalize+0x115/0x190 net/tipc/net.c:140
>  tipc_net_init+0x104/0x190 net/tipc/net.c:122
>  __tipc_nl_net_set+0x3b9/0x5a0 net/tipc/net.c:263
>  __tipc_nl_compat_doit net/tipc/netlink_compat.c:371 [inline]
>  tipc_nl_compat_doit+0x3bc/0x5f0 net/tipc/netlink_compat.c:393
>  tipc_nl_compat_handle net/tipc/netlink_compat.c:-1 [inline]
>  tipc_nl_compat_recv+0x83c/0xbe0 net/tipc/netlink_compat.c:1321
>  genl_family_rcv_msg_doit+0x215/0x300 net/netlink/genetlink.c:1115
>  genl_family_rcv_msg net/netlink/genetlink.c:1195 [inline]
>  genl_rcv_msg+0x60e/0x790 net/netlink/genetlink.c:1210
>  netlink_rcv_skb+0x208/0x470 net/netlink/af_netlink.c:2552
>  genl_rcv+0x28/0x40 net/netlink/genetlink.c:1219
>  netlink_unicast_kernel net/netlink/af_netlink.c:1320 [inline]
>  netlink_unicast+0x82f/0x9e0 net/netlink/af_netlink.c:1346
>  netlink_sendmsg+0x805/0xb30 net/netlink/af_netlink.c:1896
>  sock_sendmsg_nosec net/socket.c:727 [inline]
>  __sock_sendmsg+0x21c/0x270 net/socket.c:742
>  ____sys_sendmsg+0x505/0x830 net/socket.c:2630
>  ___sys_sendmsg+0x21f/0x2a0 net/socket.c:2684
>  __sys_sendmsg net/socket.c:2716 [inline]
>  __do_sys_sendmsg net/socket.c:2721 [inline]
>  __se_sys_sendmsg net/socket.c:2719 [inline]
>  __x64_sys_sendmsg+0x19b/0x260 net/socket.c:2719
>  do_syscall_x64 arch/x86/entry/syscall_64.c:63 [inline]
>  do_syscall_64+0xfa/0xfa0 arch/x86/entry/syscall_64.c:94
>  entry_SYSCALL_64_after_hwframe+0x77/0x7f
> RIP: 0033:0x7f13d8b8efc9
> Code: ff ff c3 66 2e 0f 1f 84 00 00 00 00 00 0f 1f 40 00 48 89 f8 48 89 f=
7 48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 ff=
 ff 73 01 c3 48 c7 c1 a8 ff ff ff f7 d8 64 89 01 48
> RSP: 002b:00007fff77cccbf8 EFLAGS: 00000246 ORIG_RAX: 000000000000002e
> RAX: ffffffffffffffda RBX: 00007f13d8de5fa0 RCX: 00007f13d8b8efc9
> RDX: 0000000000000000 RSI: 00002000000001c0 RDI: 0000000000000003
> RBP: 00007f13d8c11f91 R08: 0000000000000000 R09: 0000000000000000
> R10: 0000000000000000 R11: 0000000000000246 R12: 0000000000000000
> R13: 00007f13d8de5fa0 R14: 00007f13d8de5fa0 R15: 0000000000000003
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
> [davem@davemloft.net edumazet@google.com hoang.h.le@dektech.com.au horms@=
kernel.org jmaloy@redhat.com kuba@kernel.org kuni1840@gmail.com kuniyu@goog=
le.com netdev@vger.kernel.org pabeni@redhat.com syzbot@syzkaller.appspotmai=
l.com tipc-discussion@lists.sourceforge.net]
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
-upstream-moderation/690c6a14.050a0220.1e8caa.00cf.GAE%40google.com.
