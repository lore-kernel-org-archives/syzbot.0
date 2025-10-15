Received: from mail-oi1-f180.google.com (mail-oi1-f180.google.com [209.85.167.180])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9A21927E05F
	for <syzbot@lists.linux.dev>; Wed, 15 Oct 2025 18:44:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.167.180
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760553897; cv=none; b=IDXA4CKxX61XFvZo6ivVUdrbEGduO3RKMdxy2h6OzqhQRtsfhn+JrDj8x9ztNABqnmJ767jEq8ybZFxsAzAcpNjKQ8vaQPUkbrDQJas3qHq6zQJW2OXOBD8vL+lWNSlpTM1v7gqBav80147avq5fkSZyKUdVhqZ4Zd34H7ugN3M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760553897; c=relaxed/simple;
	bh=7ujY8xXJEq3PuyzX9xj/F9sFuzp9qmjzc4Z+VXyZGXs=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=uWGFTlOEFyryODQXCo5ThxsyAhG8Ojy9i6VgGUwmEzGG137kqtzxNfTMHQDMAH8C26DTSNlUFo23hnclkZiw5Et0DaXxPKSrdtyFXW2gCXSx9fuDTlGwVKOn4t4oN8qIKVklyUl8a5yB4KV/rpNq8Jev7acIhHsdFgZzJ8mCwxI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=IrWfxSIc; arc=none smtp.client-ip=209.85.167.180
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="IrWfxSIc"
Received: by mail-oi1-f180.google.com with SMTP id 5614622812f47-43f5ec025d3so3396061b6e.1
        for <syzbot@lists.linux.dev>; Wed, 15 Oct 2025 11:44:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1760553894; x=1761158694; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=nrK+UHPdUx3AESncQtH2YzgLRTRGDSRHZvKUzYmnwzg=;
        b=IrWfxSIcr7/tLrtxfrHUyW2voZ5Wm24h5tjo3hFctgz/PSCcw71SbXFh+KsBf7waME
         Luy/JVz8cjQz5AzjpOLlM2FLZcL/owTugl89Ybuvsb5upVIvr78g6iIDazj9EBt87ZHh
         Vp8IMgLpqaxoCslE5K3MgvIPpV2at4DUfGssV+qcyozoIS30uUTd4CtgE27z/L/sfC3E
         ahQvj8a8K1/SDnRG9fQeR/SJ0hoUDTxHs1WV6fftvaAWHRSco+QHTJ8t039A2dYUbNTS
         3noa8Gp+BW4K7T9K51t+6M4phTIwpb3ATQFecLqure5gTo4U4DMSjFSBVMuVzJUXDBtS
         FvEQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1760553894; x=1761158694;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=nrK+UHPdUx3AESncQtH2YzgLRTRGDSRHZvKUzYmnwzg=;
        b=wrHJRR51bxSApX3zaBrl2XW+6q+d51a9Xe6jTPEqrMAzM+ywgO9br/auwEQ3LIGSRq
         d7SnZTGAXOQW4S88yTs+QFtPEmCV3d7xAWAHDlKUOfBKVmVKSjteqxkJ6W/OOleQYQlf
         Zt8ImmB6o0sAvBpA6hKlqZL/22Iew4B/yWkm3T7HvGHvPAcpeeA+SRTRvK4QvUIMZ5xA
         H7o8+kITMGieA2CLvMUv3SXx4dOl1kmTVyOyaA8zMsRZ/eFQ4ioUlNd1G19qx4g3IoNK
         KupreJL5oU1w8DckzkhA6O+vbOjN2C4H+0Nf3kUxvkMwq7D3GEHoGrT9AbZ+C1jCiN3C
         PYQQ==
X-Forwarded-Encrypted: i=1; AJvYcCW8ZJygW6iFchhh81zTZ2hWAMNqQYhJ7gckFFab7Hbbws2ymvNyMc35v/lb69S6KS4DQmIA1Ok=@lists.linux.dev
X-Gm-Message-State: AOJu0YznlDKSpLaJiAy4EPF90toM5fNJ2nYpk3cfDF044m2ymYsiCnAw
	gsTjxjx38P07GHlDL49399vxOGiRJHjL7uC7BnlOvMDVQp6MS9V6tE3Tj5L4FDlGaWpwJdNJwRp
	yzb4leAYOM7mYndofRvBu7evgsp79lqtdIZnq9fT7
X-Gm-Gg: ASbGncsrUuNR6c2VQMEvGInIXpgpONsfrx7+K0fFOHNDbhXpNcjtwpsv14//Nx5tRFC
	N59FGKMJgXynletD6vGK91+ALojsYaXJwdle2EKwyT+EdJJYIs/Xc6K+jimJl8jy0uJz8JS4RBA
	mrilFDTvTX46UAMOga7v8maDdM34AFvc2WmE2x/QqHDf0ylQnawNh7dRAFmMEQtMgyb1qUeWDv7
	8/2zaUDp3zNyHSTmvSFb3X0jyyWO+pIv5yY5npqYbUjvgEWgIXlNXb/Fjg2aOum0LS2vMUvmcHx
	8OjnRvH3Le97g4oRthQcAw==
X-Google-Smtp-Source: AGHT+IFRAGsglPndW19yGTpQOWkN73SBsxUBPyk5PXfHBjY9DpxGHp0HJe2VLI0WmUyjHOISZrY3EsJPCMHOLTtLR0s=
X-Received: by 2002:a05:6808:4f1e:b0:43f:7287:a5e3 with SMTP id
 5614622812f47-4417b416836mr14420151b6e.28.1760553894348; Wed, 15 Oct 2025
 11:44:54 -0700 (PDT)
Precedence: bulk
X-Mailing-List: syzbot@lists.linux.dev
List-Id: <syzbot.lists.linux.dev>
List-Subscribe: <mailto:syzbot+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:syzbot+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <68efddc8.050a0220.1186a4.00e8.GAE@google.com>
In-Reply-To: <68efddc8.050a0220.1186a4.00e8.GAE@google.com>
From: Aleksandr Nogikh <nogikh@google.com>
Date: Wed, 15 Oct 2025 20:44:43 +0200
X-Gm-Features: AS18NWAIJ_gsx0-eV1MKvh1mSQNiEekETRnxlxkXfDfd527aHU8F1x0HUmh1CQo
Message-ID: <CANp29Y7AumspD6g05kiA8qR+cqFHpywRZ1T5VbQkR4t0jXN=NA@mail.gmail.com>
Subject: Re: [moderation/CI] Re: netkit: Support for io_uring zero-copy and AF_XDP
To: syzbot ci <syzbot+ci9295004d7677133b@syzkaller.appspotmail.com>
Cc: syzkaller-upstream-moderation@googlegroups.com, syzbot@lists.linux.dev
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

#syz upstream

On Wed, Oct 15, 2025 at 7:45=E2=80=AFPM syzbot ci
<syzbot+ci9295004d7677133b@syzkaller.appspotmail.com> wrote:
>
> syzbot ci has tested the following series
>
> [v2] netkit: Support for io_uring zero-copy and AF_XDP
> https://lore.kernel.org/all/20251015140140.62273-1-daniel@iogearbox.net
> * [PATCH net-next v2 01/15] net: Add bind-queue operation
> * [PATCH net-next v2 02/15] net: Implement netdev_nl_bind_queue_doit
> * [PATCH net-next v2 03/15] net: Add peer info to queue-get response
> * [PATCH net-next v2 04/15] net, ethtool: Disallow peered real rxqs to be=
 resized
> * [PATCH net-next v2 05/15] net: Proxy net_mp_{open,close}_rxq for mapped=
 queues
> * [PATCH net-next v2 06/15] xsk: Move NETDEV_XDP_ACT_ZC into generic head=
er
> * [PATCH net-next v2 07/15] xsk: Move pool registration into single funct=
ion
> * [PATCH net-next v2 08/15] xsk: Add small helper xp_pool_bindable
> * [PATCH net-next v2 09/15] xsk: Change xsk_rcv_check to check netdev/que=
ue_id from pool
> * [PATCH net-next v2 10/15] xsk: Proxy pool management for mapped queues
> * [PATCH net-next v2 11/15] netkit: Add single device mode for netkit
> * [PATCH net-next v2 12/15] netkit: Document fast vs slowpath members via=
 macros
> * [PATCH net-next v2 13/15] netkit: Implement rtnl_link_ops->alloc and nd=
o_queue_create
> * [PATCH net-next v2 14/15] netkit: Add io_uring zero-copy support for TC=
P
> * [PATCH net-next v2 15/15] netkit: Add xsk support for af_xdp applicatio=
ns
>
> and found the following issue:
> WARNING in netif_get_rx_queue_peer_locked
>
> Full report is available here:
> https://ci.syzbot.org/series/19b5990a-1eef-44da-a6f0-ffb03bd8adff
>
> ***
>
> WARNING in netif_get_rx_queue_peer_locked
>
> tree:      net-next
> URL:       https://kernel.googlesource.com/pub/scm/linux/kernel/git/netde=
v/net-next.git
> base:      18a7e218cfcdca6666e1f7356533e4c988780b57
> arch:      amd64
> compiler:  Debian clang version 20.1.8 (++20250708063551+0c9f909b7976-1~e=
xp1~20250708183702.136), Debian LLD 20.1.8
> config:    https://ci.syzbot.org/builds/7583f7f3-9e92-4fe2-85f2-761655062=
852/config
> C repro:   https://ci.syzbot.org/findings/75520448-5da8-4fc1-817b-a6c9e4d=
487e1/c_repro
> syz repro: https://ci.syzbot.org/findings/75520448-5da8-4fc1-817b-a6c9e4d=
487e1/syz_repro
>
> UDPLite6: UDP-Lite is deprecated and scheduled to be removed in 2025, ple=
ase contact the netdev mailing list
> ------------[ cut here ]------------
> WARNING: CPU: 1 PID: 5959 at ./include/net/netdev_lock.h:17 netdev_assert=
_locked include/net/netdev_lock.h:17 [inline]
> WARNING: CPU: 1 PID: 5959 at ./include/net/netdev_lock.h:17 netif_get_rx_=
queue_peer_locked+0x2f1/0x3a0 net/core/netdev_rx_queue.c:71
> Modules linked in:
> CPU: 1 UID: 0 PID: 5959 Comm: syz.0.17 Not tainted syzkaller #0 PREEMPT(f=
ull)
> Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS 1.16.2-debian-1.=
16.2-1 04/01/2014
> RIP: 0010:netdev_assert_locked include/net/netdev_lock.h:17 [inline]
> RIP: 0010:netif_get_rx_queue_peer_locked+0x2f1/0x3a0 net/core/netdev_rx_q=
ueue.c:71
> Code: 6c 7e f8 eb 08 e8 3f 6c 7e f8 45 31 f6 4c 89 f0 48 83 c4 38 5b 41 5=
c 41 5d 41 5e 41 5f 5d e9 c6 1c 0d 02 cc e8 20 6c 7e f8 90 <0f> 0b 90 e9 a9=
 fd ff ff 48 c7 c1 90 44 9e 8f 80 e1 07 80 c1 03 38
> RSP: 0018:ffffc90003f17ab0 EFLAGS: 00010293
> RAX: ffffffff894127e0 RBX: ffffc90003f17b60 RCX: ffff8881709cba00
> RDX: 0000000000000000 RSI: 0000000000000000 RDI: 0000000000000000
> RBP: 0000000000000000 R08: ffffffff8f4df8a7 R09: 1ffffffff1e9bf14
> R10: dffffc0000000000 R11: fffffbfff1e9bf15 R12: dffffc0000000000
> R13: 0000000000000001 R14: 1ffff920007e2f6c R15: ffff8881b1832000
> FS:  0000555580884500(0000) GS:ffff8882a9d0f000(0000) knlGS:0000000000000=
000
> CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> CR2: 0000555580884808 CR3: 00000001ba58c000 CR4: 00000000000006f0
> Call Trace:
>  <TASK>
>  xsk_reg_pool_at_qid+0x20b/0x630 net/xdp/xsk.c:159
>  xp_assign_dev+0x115/0x760 net/xdp/xsk_buff_pool.c:181
>  xsk_bind+0x473/0xf90 net/xdp/xsk.c:1407
>  __sys_bind_socket net/socket.c:1874 [inline]
>  __sys_bind+0x2c6/0x3e0 net/socket.c:1905
>  __do_sys_bind net/socket.c:1910 [inline]
>  __se_sys_bind net/socket.c:1908 [inline]
>  __x64_sys_bind+0x7a/0x90 net/socket.c:1908
>  do_syscall_x64 arch/x86/entry/syscall_64.c:63 [inline]
>  do_syscall_64+0xfa/0xfa0 arch/x86/entry/syscall_64.c:94
>  entry_SYSCALL_64_after_hwframe+0x77/0x7f
> RIP: 0033:0x7fb19bd8eec9
> Code: ff ff c3 66 2e 0f 1f 84 00 00 00 00 00 0f 1f 40 00 48 89 f8 48 89 f=
7 48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 ff=
 ff 73 01 c3 48 c7 c1 a8 ff ff ff f7 d8 64 89 01 48
> RSP: 002b:00007ffd789e00a8 EFLAGS: 00000246 ORIG_RAX: 0000000000000031
> RAX: ffffffffffffffda RBX: 00007fb19bfe5fa0 RCX: 00007fb19bd8eec9
> RDX: 0000000000000010 RSI: 0000200000000180 RDI: 0000000000000003
> RBP: 00007fb19be11f91 R08: 0000000000000000 R09: 0000000000000000
> R10: 0000000000000000 R11: 0000000000000246 R12: 0000000000000000
> R13: 00007fb19bfe5fa0 R14: 00007fb19bfe5fa0 R15: 0000000000000003
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
> [bpf@vger.kernel.org daniel@iogearbox.net davem@davemloft.net dw@davidwei=
.uk john.fastabend@gmail.com jordan@jrife.io kuba@kernel.org maciej.fijalko=
wski@intel.com magnus.karlsson@intel.com martin.lau@kernel.org netdev@vger.=
kernel.org pabeni@redhat.com razor@blackwall.org sdf@fomichev.me toke@redha=
t.com wangdongdong.6@bytedance.com willemb@google.com yangzhenze@bytedance.=
com]
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
-upstream-moderation/68efddc8.050a0220.1186a4.00e8.GAE%40google.com.
