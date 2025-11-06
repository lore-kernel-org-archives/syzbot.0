Received: from mail-oo1-f54.google.com (mail-oo1-f54.google.com [209.85.161.54])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 351B026E709
	for <syzbot@lists.linux.dev>; Thu,  6 Nov 2025 09:00:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.161.54
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762419615; cv=none; b=dI/73H2mt95KjLvnu6NzY+TF5j0zz8bxw41vwMANYMr5yoGuKUUmb642zXg4wHFxInXIWiQX6ZWo5x7SXXfS9B65ZiALOKqVD653N84hcU1RJCmFdW98/k72PMfFkmFA7GblVOMYbjggOc1kZOVpoZ8Q4GRIxfeRUWPPA1NXacs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762419615; c=relaxed/simple;
	bh=RrjVp5k7lrJeZH7IwkPPaqzmWrhrAtVb1M4d0o1rZMY=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=FCs6R45Z/RPdJh3UFMjLIlMeoXr7gy+brAX439KYrjUXek3Dk7VKiYYTnb5MDFf732sxtBLglupJWgqEFT4DVLPpimAye0DswGoP+BGYgFH8y1KOazXb0FhFg8/G+6MXr3vW/rhoI2TpKWR7CnxGK643Qh3wUbl4jM4GlNeBUAM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=IFkaiu4a; arc=none smtp.client-ip=209.85.161.54
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="IFkaiu4a"
Received: by mail-oo1-f54.google.com with SMTP id 006d021491bc7-656c665749bso152525eaf.3
        for <syzbot@lists.linux.dev>; Thu, 06 Nov 2025 01:00:13 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1762419612; x=1763024412; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=4VGVF/JJXNHf4EC5rALSwE+pzrWCcuxaIV7+MGOw1xo=;
        b=IFkaiu4aOX7l0mFn6FW1wxK/HMk3x5sAckm9sBocNkiqqW8VOeflEGU4F7WUctDiuv
         YU0L5KevIQi03w3RNd+mf7LN8E0VZyxv8/WV9RdJl7DsgM/AVaxgthufAEVNFs+t3c2I
         9F4QMfuzys9+OgKa7PPtrlI/fmRQajTSZ4+J6fP0YgiWbk1Jx6KnEle9pbIZhq1y6l6j
         7nueddPZ+2Mvt5S+qp1Xedyf68i4mMZYAgqvdFv2n0BsKycAcegZq8+/TZmyvofv08im
         HXjuiQhR7iRTJsMACjvN4IitzEYKZl3OmnmGHy2W7HALrIIGzBMBWYVNSzgkQbIw0YH0
         F65w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1762419612; x=1763024412;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=4VGVF/JJXNHf4EC5rALSwE+pzrWCcuxaIV7+MGOw1xo=;
        b=xLkmdB/9dGpLsiFJOBTfRWr0ibcJD+3zHBoVy71o7SpEH/2aFaE4FtpMu9YKju1GOY
         OhiqocGHpJ5rqIb04LV++9YHgNr9hperWG37xI2XyP3q/hqYax1luYyUTboC1uXnfgTr
         HRxkY3dCLTbU2ayGsIRTM3R3cyG8ZCmozs+Q/M1Q6ZcpGBCHDJQmU9lx6+K9DvlVuZoC
         McGqlwDwIdZRYLBRJJSHCmmQTsvRtL8PArZa4w4hr36+ULywwk6Hy9lSyBiWaHwSpdLc
         vtHZt06vKt1prfXnGpjf/np6aYS2O8oMZPEey3SloKC63ufyBkD4Y7rzmVggOe192P78
         7v4w==
X-Forwarded-Encrypted: i=1; AJvYcCV0BrBV40ausJLAJnnqC96IobEF5AfKR/9p10eh6qqY4FX9UbMmA0YbP42tZ2jNLAgJN/6xbtA=@lists.linux.dev
X-Gm-Message-State: AOJu0YwZXbFtFOL3dEk6s5dr4oxHgmOha5STCLiP8es4Berj2eHEjRV4
	+ywXiJl5iiHx4IgVivbi5lc0XZxNGkr+4wXKJkCmtnEnJ3ygLaF/+UPpg+eUGBYIyy4gN1MdDHZ
	DCk8Xd+z5ZTyAMelDfxChBs2IMqYJUThnnVTUSejI
X-Gm-Gg: ASbGncuhN/+DzR1Wqwp94N3l/NmFPk/SeyO7JvZ2NAkFu0+de5rJN6+D7NushoqJ/Zf
	5zcyHNWDQOwBLqBESdElrKeD8e+UpRaVtvCjedGpPhd90Nca/ySc2W6m7FOBDkwyS8a8SJ6jEka
	smdcDs9Iyl8ULtnAnNS7Zudbmgnbx2FSt5vpRPraJluuOMeHAcgc6p5r84z+yLLovvuV/larLIt
	9s31bPPM5ohAyej8f4FFT+s2kurPa3XUBCWJR1AI22KsQxMaXEvdqH8NSAreJgihHu2n27Sktqe
	4ljTLmro2HCPdIUW773k8e6KqVTV57ZWyjB7rcDFV54q59eTanWuiDUDyjV3yFR9qOa6
X-Google-Smtp-Source: AGHT+IH+EAMxCvkcjLyJmo402tyTQAdj5kfICNyNOjanh3ydbhbsRrNKw/bTellKaCuma9OZ6lgcOjfElZD9f0V39FA=
X-Received: by 2002:a05:6820:4b8b:b0:651:d75a:cd6b with SMTP id
 006d021491bc7-656bb63662emr2672022eaf.8.1762419612178; Thu, 06 Nov 2025
 01:00:12 -0800 (PST)
Precedence: bulk
X-Mailing-List: syzbot@lists.linux.dev
List-Id: <syzbot.lists.linux.dev>
List-Subscribe: <mailto:syzbot+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:syzbot+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <690bc22f.050a0220.baf87.0072.GAE@google.com>
In-Reply-To: <690bc22f.050a0220.baf87.0072.GAE@google.com>
From: Aleksandr Nogikh <nogikh@google.com>
Date: Thu, 6 Nov 2025 10:00:00 +0100
X-Gm-Features: AWmQ_bnUet6kkMN-WsycWiwvsPbOECMeveY3kXtn5Sx3skvdNy1eNDfpDPnmac4
Message-ID: <CANp29Y7F=tTCQEn6M0CSkdHGkQqp2bF0DEbWOZGLWTgXSwtzxQ@mail.gmail.com>
Subject: Re: [moderation/CI] Re: ipvlan: support mac-nat mode
To: syzbot ci <syzbot+cid64ea3db584eba82@syzkaller.appspotmail.com>
Cc: syzkaller-upstream-moderation@googlegroups.com, syzbot@lists.linux.dev
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

#syz upstream

On Wed, Nov 5, 2025 at 10:31=E2=80=AFPM syzbot ci
<syzbot+cid64ea3db584eba82@syzkaller.appspotmail.com> wrote:
>
> syzbot ci has tested the following series
>
> [v3] ipvlan: support mac-nat mode
> https://lore.kernel.org/all/20251105161450.1730216-1-skorodumov.dmitry@hu=
awei.com
> * [PATCH net-next 01/14] ipvlan: Preparation to support mac-nat
> * [PATCH net-next 02/14] ipvlan: Send mcasts out directly in ipvlan_xmit_=
mode_l2()
> * [PATCH net-next 03/14] ipvlan: Handle rx mcast-ip and unicast eth
> * [PATCH net-next 04/14] ipvlan: Added some kind of MAC NAT
> * [PATCH net-next 05/14] ipvlan: Forget all IP when device goes down
> * [PATCH net-next 06/14] ipvlan: Support GSO for port -> ipvlan
> * [PATCH net-next 07/14] ipvlan: Support IPv6 for learnable l2-bridge
> * [PATCH net-next 08/14] ipvlan: Make the addrs_lock be per port
> * [PATCH net-next 09/14] ipvlan: Take addr_lock in ipvlan_open()
> * [PATCH net-next 10/14] ipvlan: Don't allow children to use IPs of main
> * [PATCH net-next 11/14] ipvlan: const-specifier for functions that use i=
addr
> * [PATCH net-next 12/14] ipvlan: Common code from v6/v4 validator_event
> * [PATCH net-next 13/14] ipvlan: common code to handle ipv6/ipv4 address =
events
> * [PATCH net-next 14/14] ipvlan: Ignore PACKET_LOOPBACK in handle_mode_l2=
()
>
> and found the following issue:
> WARNING: suspicious RCU usage in ipvlan_init
>
> Full report is available here:
> https://ci.syzbot.org/series/349ca33e-4ae2-4720-9a69-17a2a9e17107
>
> ***
>
> WARNING: suspicious RCU usage in ipvlan_init
>
> tree:      net-next
> URL:       https://kernel.googlesource.com/pub/scm/linux/kernel/git/netde=
v/net-next.git
> base:      01cc760632b875c4ad0d8fec0b0c01896b8a36d4
> arch:      amd64
> compiler:  Debian clang version 20.1.8 (++20250708063551+0c9f909b7976-1~e=
xp1~20250708183702.136), Debian LLD 20.1.8
> config:    https://ci.syzbot.org/builds/d6598a0d-2fcb-499d-95fc-30c509655=
5dc/config
>
> batman_adv: batadv0: Not using interface batadv_slave_1 (retrying later):=
 interface not active
> hsr_slave_0: entered promiscuous mode
> hsr_slave_1: entered promiscuous mode
> =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D
> WARNING: suspicious RCU usage
> syzkaller #0 Not tainted
> -----------------------------
> ./include/linux/inetdevice.h:239 suspicious rcu_dereference_check() usage=
!
>
> other info that might help us debug this:
>
>
> rcu_scheduler_active =3D 2, debug_locks =3D 1
> 2 locks held by syz-executor/6496:
>  #0: ffffffff8ea2f980 (&ops->srcu#2){.+.+}-{0:0}, at: rtnl_link_ops_get+0=
x23/0x250
>  #1: ffffffff8f2cb3c8 (rtnl_mutex){+.+.}-{4:4}, at: rtnl_newlink+0x8e9/0x=
1c80
>
> stack backtrace:
> CPU: 1 UID: 0 PID: 6496 Comm: syz-executor Not tainted syzkaller #0 PREEM=
PT(full)
> Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS 1.16.2-debian-1.=
16.2-1 04/01/2014
> Call Trace:
>  <TASK>
>  dump_stack_lvl+0x189/0x250
>  lockdep_rcu_suspicious+0x140/0x1d0
>  ipvlan_init+0xff2/0x1260
>  register_netdevice+0x6bf/0x1ae0
>  ipvlan_link_new+0x57a/0xc70
>  rtnl_newlink_create+0x310/0xb00
>  rtnl_newlink+0x16e4/0x1c80
>  rtnetlink_rcv_msg+0x7cf/0xb70
>  netlink_rcv_skb+0x208/0x470
>  netlink_unicast+0x82f/0x9e0
>  netlink_sendmsg+0x805/0xb30
>  __sock_sendmsg+0x21c/0x270
>  __sys_sendto+0x3bd/0x520
>  __x64_sys_sendto+0xde/0x100
>  do_syscall_64+0xfa/0xfa0
>  entry_SYSCALL_64_after_hwframe+0x77/0x7f
> RIP: 0033:0x7f114c590e03
> Code: 64 89 02 48 c7 c0 ff ff ff ff eb b7 66 2e 0f 1f 84 00 00 00 00 00 9=
0 80 3d 61 77 22 00 00 41 89 ca 74 14 b8 2c 00 00 00 0f 05 <48> 3d 00 f0 ff=
 ff 77 75 c3 0f 1f 40 00 55 48 83 ec 30 44 89 4c 24
> RSP: 002b:00007ffecaf08958 EFLAGS: 00000202 ORIG_RAX: 000000000000002c
> RAX: ffffffffffffffda RBX: 00007f114d314620 RCX: 00007f114c590e03
> RDX: 0000000000000058 RSI: 00007f114d314670 RDI: 0000000000000003
> RBP: 0000000000000001 R08: 00007ffecaf08974 R09: 000000000000000c
> R10: 0000000000000000 R11: 0000000000000202 R12: 0000000000000003
> R13: 0000000000000000 R14: 00007f114d314670 R15: 0000000000000000
>  </TASK>
>
> =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D
> WARNING: suspicious RCU usage
> syzkaller #0 Not tainted
> -----------------------------
> drivers/net/ipvlan/ipvlan_main.c:238 suspicious rcu_dereference_check() u=
sage!
>
> other info that might help us debug this:
>
>
> rcu_scheduler_active =3D 2, debug_locks =3D 1
> 2 locks held by syz-executor/6496:
>  #0: ffffffff8ea2f980 (&ops->srcu#2){.+.+}-{0:0}, at: rtnl_link_ops_get+0=
x23/0x250
>  #1: ffffffff8f2cb3c8 (rtnl_mutex){+.+.}-{4:4}, at: rtnl_newlink+0x8e9/0x=
1c80
>
> stack backtrace:
> CPU: 0 UID: 0 PID: 6496 Comm: syz-executor Not tainted syzkaller #0 PREEM=
PT(full)
> Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS 1.16.2-debian-1.=
16.2-1 04/01/2014
> Call Trace:
>  <TASK>
>  dump_stack_lvl+0x189/0x250
>  lockdep_rcu_suspicious+0x140/0x1d0
>  ipvlan_init+0x1025/0x1260
>  register_netdevice+0x6bf/0x1ae0
>  ipvlan_link_new+0x57a/0xc70
>  rtnl_newlink_create+0x310/0xb00
>  rtnl_newlink+0x16e4/0x1c80
>  rtnetlink_rcv_msg+0x7cf/0xb70
>  netlink_rcv_skb+0x208/0x470
>  netlink_unicast+0x82f/0x9e0
>  netlink_sendmsg+0x805/0xb30
>  __sock_sendmsg+0x21c/0x270
>  __sys_sendto+0x3bd/0x520
>  __x64_sys_sendto+0xde/0x100
>  do_syscall_64+0xfa/0xfa0
>  entry_SYSCALL_64_after_hwframe+0x77/0x7f
> RIP: 0033:0x7f114c590e03
> Code: 64 89 02 48 c7 c0 ff ff ff ff eb b7 66 2e 0f 1f 84 00 00 00 00 00 9=
0 80 3d 61 77 22 00 00 41 89 ca 74 14 b8 2c 00 00 00 0f 05 <48> 3d 00 f0 ff=
 ff 77 75 c3 0f 1f 40 00 55 48 83 ec 30 44 89 4c 24
> RSP: 002b:00007ffecaf08958 EFLAGS: 00000202 ORIG_RAX: 000000000000002c
> RAX: ffffffffffffffda RBX: 00007f114d314620 RCX: 00007f114c590e03
> RDX: 0000000000000058 RSI: 00007f114d314670 RDI: 0000000000000003
> RBP: 0000000000000001 R08: 00007ffecaf08974 R09: 000000000000000c
> R10: 0000000000000000 R11: 0000000000000202 R12: 0000000000000003
> R13: 0000000000000000 R14: 00007f114d314670 R15: 0000000000000000
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
> [andrew@lunn.ch andrey.bokhanko@huawei.com corbet@lwn.net davem@davemloft=
.net edumazet@google.com horms@kernel.org kuba@kernel.org linux-doc@vger.ke=
rnel.org linux-kernel@vger.kernel.org netdev@vger.kernel.org pabeni@redhat.=
com skorodumov.dmitry@huawei.com]
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
-upstream-moderation/690bc22f.050a0220.baf87.0072.GAE%40google.com.
