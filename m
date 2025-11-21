Received: from mail-oi1-f174.google.com (mail-oi1-f174.google.com [209.85.167.174])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A9E0B2F8BD0
	for <syzbot@lists.linux.dev>; Fri, 21 Nov 2025 09:15:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.167.174
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763716524; cv=none; b=A/3jNz9OcpkXDz12WRMf9/IUkLk4YF60rQ0miIXK56YHMwUknYFXfrLURqUpDE+4dLcQuyxtvnnCIz9vUlgJvS8TwMc4gL3VEk8iFLv3HB+qL2m/UVZ6ex5XbsjnB/EYERiHERCzhZ+SBRRTyQriuPTghG0Qq3LwL2l5nVyKhwQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763716524; c=relaxed/simple;
	bh=G0MlOo2NjvGsK/p0ub24ndsrPieT1yip1G0oOZTgu30=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=mr1vSUwWPoPCOC0aKUcejIJ7Uk/Rf9QmxMgm75LOq/Tpe4D+FmnjBWAfTV9TMLP0xQYtT42webCUQhqIgvFw1UrchVwTR3c1b6ou5dxR+vFJzNeITVU3GAkKXtrS79G6raZxdlfOtA/WJhCLFpyh5ncc5edYyRMsIeiW8AXR8ek=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=ulNdnW96; arc=none smtp.client-ip=209.85.167.174
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="ulNdnW96"
Received: by mail-oi1-f174.google.com with SMTP id 5614622812f47-450ccefe6ffso732456b6e.1
        for <syzbot@lists.linux.dev>; Fri, 21 Nov 2025 01:15:21 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1763716520; x=1764321320; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=IY5l0Ko1OoGG8n6mfrWx/kEWUpZ46Y2nNxaxyAP/XU8=;
        b=ulNdnW96K5nGbZt49w+W2pRgzrl7PjWnU2g2mICkKdLufzW2NPn3MiC6zQ9FtePB0/
         7NZcfE9r9/TDScaZUH3sbGxFKYD/8d0j60FLkG0V9qV2AAHXA12tjoPH3WKXRRYaveCK
         FHGCmsJ/rOHjP1ttBu5HWnxCkjrav5vjXAPE4VrFnDXD+YqwDmKyAjRkaHLsa7Xnhlhd
         KEV58Gp1yFEL6lHonuNrenoEyfMKL5kolOZ1GaxMNyVzpOLA/jQR6yGrm3YcIQJKsZ7i
         tOp2IvcQ9uQ+pO9byYuz94MB+ADDm+IQJWDzV9G7ymg3NK0P5K672BkpHybFZM/RecXR
         UVQg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1763716520; x=1764321320;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=IY5l0Ko1OoGG8n6mfrWx/kEWUpZ46Y2nNxaxyAP/XU8=;
        b=mkN6MscIN1rsI1Jmb0/W5npUkB5m5rBR922nQkWTGWVCVXBApyUPvNDmCn6l/YDvML
         2sl/P1ryem6E1TaJBCzArxfjzwSI+1npLK/1noA+ka03OuPBMHI+H0+ZZ5lQO3HzbG7y
         biLiGGiAzf323ouoE7c1hVsC0yOoxsLtzzKtdzuG8X9S3FVZ8wspGdK9JgYtKQGCUgwO
         xbZHwxshG9STeGHHwkhfRlV6wr6sqWwA4MaHQ+0XkaLR8rkQiA2kLhlwgmA+S+gHG2uU
         Hy+U3A2cqttIh8eVoXiTiHxIKFJr/C54HCe9biEoHhxGap27Qg0KXCqnp9qxurNuCX5v
         3LvA==
X-Forwarded-Encrypted: i=1; AJvYcCW0g7oiAQXdPZclo3ZfQAIZwawM0TLsxlyzcrlNfOVcIjixo6tphjv3C/kNMOaJwXv93xYxWE4=@lists.linux.dev
X-Gm-Message-State: AOJu0Yxk/rIHsmVykps1DzPYpnHRMAIjwTDjSPq+SKnVVHauhPsN8cGR
	uv1sf3gh/Vt275XcQ4b5lHYDE3WTUTDVy57eyYcAe//tH27Tmv9GnWfYufaD7cStPDIf2QTuTp0
	RwGb6IhpYSBQ2gCITSh/1tsa2G7nqZhqvcC7cgOeH
X-Gm-Gg: ASbGnct/JdG6BsPFL8x0wdhof6QiRBs0LUTLKSbopZQmq6jVkcpgoYT9ljyiGCl4GU1
	T986XHVa0ydadgBhnuRHpU4gyUfsSRdBvLo5TVcnHAzCJss1Ywp52i775Cf4WKxjq7c/7VG9J8z
	djvsGQXxFsrtaZ5AOkIlLEDSXB2eGBscNpGlV6+SIFnfnvVBnmIemANwP+lTJpS7vXPMOk/P2HZ
	nWGOkJzpec8uReLVng7oapvKZEo/88AIM9gnWwmsQIIumtAjncnJNZEb6gZHgGvssEnBURK/pKt
	AZi6aiuGrl1Tr2ppPmDWq1xfBrr4qrIbI2bTeys18hD0txQ2HakNa6uMhg==
X-Google-Smtp-Source: AGHT+IEUYkY/7hl7XVbtVDApV8eRQDTC9Q73tSDCKGVzOcdB8i8XaIE3HHmC3YEye/OZTkZzYRht7Z9RWjtNESj2uiI=
X-Received: by 2002:a05:6808:17a5:b0:450:1eae:96e9 with SMTP id
 5614622812f47-45101c95238mr2470368b6e.7.1763716520067; Fri, 21 Nov 2025
 01:15:20 -0800 (PST)
Precedence: bulk
X-Mailing-List: syzbot@lists.linux.dev
List-Id: <syzbot.lists.linux.dev>
List-Subscribe: <mailto:syzbot+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:syzbot+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <691f6e38.a70a0220.2ea503.0036.GAE@google.com>
In-Reply-To: <691f6e38.a70a0220.2ea503.0036.GAE@google.com>
From: Aleksandr Nogikh <nogikh@google.com>
Date: Fri, 21 Nov 2025 10:15:08 +0100
X-Gm-Features: AWmQ_bnmnC9Ve5t7GTfi35uEuDoT1zeG0Cp0jXiCgz3cBbMGwoeP2MqcHjyYvH0
Message-ID: <CANp29Y5m7uBWu5f5ZYVxj52QhO-MXo3tUc8W7RggDngHnXGmkw@mail.gmail.com>
Subject: Re: [moderation/CI] Re: tun/tap & vhost-net: netdev queue flow
 control to avoid ptr_ring tail drop
To: syzbot ci <syzbot+ciba1a7e42af782cc8@syzkaller.appspotmail.com>
Cc: syzkaller-upstream-moderation@googlegroups.com, syzbot@lists.linux.dev
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

#syz upstream

On Thu, Nov 20, 2025 at 8:38=E2=80=AFPM syzbot ci
<syzbot+ciba1a7e42af782cc8@syzkaller.appspotmail.com> wrote:
>
> syzbot ci has tested the following series
>
> [v6] tun/tap & vhost-net: netdev queue flow control to avoid ptr_ring tai=
l drop
> https://lore.kernel.org/all/20251120152914.1127975-1-simon.schippers@tu-d=
ortmund.de
> * [PATCH net-next v6 1/8] ptr_ring: add __ptr_ring_full_next() to predict=
 imminent fullness
> * [PATCH net-next v6 2/8] ptr_ring: add helper to check if consume create=
d space
> * [PATCH net-next v6 3/8] tun/tap: add synchronized ring produce/consume =
with queue management
> * [PATCH net-next v6 4/8] tun/tap: add batched ring consume function
> * [PATCH net-next v6 5/8] tun/tap: add uncomsume function for returning e=
ntries to ring
> * [PATCH net-next v6 6/8] tun/tap: add helper functions to check file typ=
e
> * [PATCH net-next v6 7/8] tun/tap/vhost: use {tun|tap}_ring_{consume|prod=
uce} to avoid tail drops
> * [PATCH net-next v6 8/8] tun/tap: drop get ring exports
>
> and found the following issue:
> general protection fault in tun_net_xmit
>
> Full report is available here:
> https://ci.syzbot.org/series/63c35694-3fa6-48b6-ba11-f893f55bcc1a
>
> ***
>
> general protection fault in tun_net_xmit
>
> tree:      net-next
> URL:       https://kernel.googlesource.com/pub/scm/linux/kernel/git/netde=
v/net-next.git
> base:      45a1cd8346ca245a1ca475b26eb6ceb9d8b7c6f0
> arch:      amd64
> compiler:  Debian clang version 20.1.8 (++20250708063551+0c9f909b7976-1~e=
xp1~20250708183702.136), Debian LLD 20.1.8
> config:    https://ci.syzbot.org/builds/e1084fb4-2e0a-4c87-8e42-bc8fa70e1=
c77/config
> syz repro: https://ci.syzbot.org/findings/cf1c9121-7e31-4bc8-a254-f9e6c8e=
e2d26/syz_repro
>
> Oops: general protection fault, probably for non-canonical address 0xdfff=
fc0000000002: 0000 [#1] SMP KASAN NOPTI
> KASAN: null-ptr-deref in range [0x0000000000000010-0x0000000000000017]
> CPU: 1 UID: 0 PID: 13 Comm: kworker/u8:1 Not tainted syzkaller #0 PREEMPT=
(full)
> Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS 1.16.2-debian-1.=
16.2-1 04/01/2014
> Workqueue: ipv6_addrconf addrconf_dad_work
> RIP: 0010:__ptr_ring_full include/linux/ptr_ring.h:51 [inline]
> RIP: 0010:tun_ring_produce drivers/net/tun.c:1023 [inline]
> RIP: 0010:tun_net_xmit+0xdf0/0x1840 drivers/net/tun.c:1164
> Code: 00 00 00 fc ff df 48 89 44 24 50 0f b6 04 18 84 c0 0f 85 1f 07 00 0=
0 4c 89 7c 24 30 4d 63 37 4f 8d 3c f4 4c 89 f8 48 c1 e8 03 <80> 3c 18 00 74=
 08 4c 89 ff e8 92 ba e3 fb 49 83 3f 00 74 0a e8 17
> RSP: 0018:ffffc90000126f80 EFLAGS: 00010202
> RAX: 0000000000000002 RBX: dffffc0000000000 RCX: dffffc0000000000
> RDX: 0000000000000001 RSI: 0000000000000004 RDI: ffffc90000126f00
> RBP: ffffc900001270b0 R08: 0000000000000003 R09: 0000000000000004
> R10: dffffc0000000000 R11: fffff52000024de0 R12: 0000000000000010
> R13: ffff8881730b6a48 R14: 0000000000000000 R15: 0000000000000010
> FS:  0000000000000000(0000) GS:ffff8882a9f38000(0000) knlGS:0000000000000=
000
> CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> CR2: 0000200000002280 CR3: 00000001bb189000 CR4: 0000000000352ef0
> Call Trace:
>  <TASK>
>  __netdev_start_xmit include/linux/netdevice.h:5259 [inline]
>  netdev_start_xmit include/linux/netdevice.h:5268 [inline]
>  xmit_one net/core/dev.c:3853 [inline]
>  dev_hard_start_xmit+0x2d7/0x830 net/core/dev.c:3869
>  __dev_queue_xmit+0x172a/0x3740 net/core/dev.c:4811
>  neigh_output include/net/neighbour.h:556 [inline]
>  ip6_finish_output2+0xfb3/0x1480 net/ipv6/ip6_output.c:136
>  NF_HOOK_COND include/linux/netfilter.h:307 [inline]
>  ip6_output+0x340/0x550 net/ipv6/ip6_output.c:247
>  NF_HOOK include/linux/netfilter.h:318 [inline]
>  ndisc_send_skb+0xbce/0x1510 net/ipv6/ndisc.c:512
>  addrconf_dad_completed+0x7ae/0xd60 net/ipv6/addrconf.c:4360
>  addrconf_dad_work+0xc36/0x14b0 net/ipv6/addrconf.c:-1
>  process_one_work kernel/workqueue.c:3263 [inline]
>  process_scheduled_works+0xae1/0x17b0 kernel/workqueue.c:3346
>  worker_thread+0x8a0/0xda0 kernel/workqueue.c:3427
>  kthread+0x711/0x8a0 kernel/kthread.c:463
>  ret_from_fork+0x4bc/0x870 arch/x86/kernel/process.c:158
>  ret_from_fork_asm+0x1a/0x30 arch/x86/entry/entry_64.S:245
>  </TASK>
> Modules linked in:
> ---[ end trace 0000000000000000 ]---
> RIP: 0010:__ptr_ring_full include/linux/ptr_ring.h:51 [inline]
> RIP: 0010:tun_ring_produce drivers/net/tun.c:1023 [inline]
> RIP: 0010:tun_net_xmit+0xdf0/0x1840 drivers/net/tun.c:1164
> Code: 00 00 00 fc ff df 48 89 44 24 50 0f b6 04 18 84 c0 0f 85 1f 07 00 0=
0 4c 89 7c 24 30 4d 63 37 4f 8d 3c f4 4c 89 f8 48 c1 e8 03 <80> 3c 18 00 74=
 08 4c 89 ff e8 92 ba e3 fb 49 83 3f 00 74 0a e8 17
> RSP: 0018:ffffc90000126f80 EFLAGS: 00010202
> RAX: 0000000000000002 RBX: dffffc0000000000 RCX: dffffc0000000000
> RDX: 0000000000000001 RSI: 0000000000000004 RDI: ffffc90000126f00
> RBP: ffffc900001270b0 R08: 0000000000000003 R09: 0000000000000004
> R10: dffffc0000000000 R11: fffff52000024de0 R12: 0000000000000010
> R13: ffff8881730b6a48 R14: 0000000000000000 R15: 0000000000000010
> FS:  0000000000000000(0000) GS:ffff8882a9f38000(0000) knlGS:0000000000000=
000
> CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> CR2: 0000200000002280 CR3: 00000001bb189000 CR4: 0000000000352ef0
> ----------------
> Code disassembly (best guess), 5 bytes skipped:
>    0:   df 48 89                fisttps -0x77(%rax)
>    3:   44 24 50                rex.R and $0x50,%al
>    6:   0f b6 04 18             movzbl (%rax,%rbx,1),%eax
>    a:   84 c0                   test   %al,%al
>    c:   0f 85 1f 07 00 00       jne    0x731
>   12:   4c 89 7c 24 30          mov    %r15,0x30(%rsp)
>   17:   4d 63 37                movslq (%r15),%r14
>   1a:   4f 8d 3c f4             lea    (%r12,%r14,8),%r15
>   1e:   4c 89 f8                mov    %r15,%rax
>   21:   48 c1 e8 03             shr    $0x3,%rax
> * 25:   80 3c 18 00             cmpb   $0x0,(%rax,%rbx,1) <-- trapping in=
struction
>   29:   74 08                   je     0x33
>   2b:   4c 89 ff                mov    %r15,%rdi
>   2e:   e8 92 ba e3 fb          call   0xfbe3bac5
>   33:   49 83 3f 00             cmpq   $0x0,(%r15)
>   37:   74 0a                   je     0x43
>   39:   e8                      .byte 0xe8
>   3a:   17                      (bad)
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
> [andrew@lunn.ch davem@davemloft.net edumazet@google.com eperezma@redhat.c=
om jasowang@redhat.com jon@nutanix.com kuba@kernel.org kvm@vger.kernel.org =
linux-kernel@vger.kernel.org mst@redhat.com netdev@vger.kernel.org pabeni@r=
edhat.com simon.schippers@tu-dortmund.de tim.gebauer@tu-dortmund.de virtual=
ization@lists.linux.dev willemdebruijn.kernel@gmail.com]
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
-upstream-moderation/691f6e38.a70a0220.2ea503.0036.GAE%40google.com.
