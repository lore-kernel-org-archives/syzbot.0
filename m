Received: from mail-pg1-f176.google.com (mail-pg1-f176.google.com [209.85.215.176])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B57D276410
	for <syzbot@lists.linux.dev>; Fri,  8 Aug 2025 19:31:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.176
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1754681494; cv=none; b=TO1XXsqi3OX9wBJJ8Bsdx09zATwg6KUJwPVBpL1LYAjfFyEzjgxmBb4t5p95xFKmyVyga9/61DOhaJhYrjKCfNWxT3MT99PI9uypIgsXisx25nV0udmlovuMRK84t/BJimZguG9iNKIHwkGUYXuKlI9PY41ma1mp31/2OHled7w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1754681494; c=relaxed/simple;
	bh=m2KXpYDyCQJqLqYAPFy07E/qd/AlLs1aVaKl7M2tNpA=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=P2qVeQ9Kn2RMPr6g2CCwnA+AqNtYNdE+KOqpSEmsvGoFaPT1cnpB+cx7M682OLE2p5xxoytfiw6L/DDTSeh0Y7/siomYqVJvzJ7fBI5BB07eYtuB0VRhetoewnm0XABCw2lNgVCDTvH0+0dJzM0MnXNxDIlfzMW2Bf9IlTGGoNs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=iP47wh9w; arc=none smtp.client-ip=209.85.215.176
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="iP47wh9w"
Received: by mail-pg1-f176.google.com with SMTP id 41be03b00d2f7-b428dd79d46so1674397a12.0
        for <syzbot@lists.linux.dev>; Fri, 08 Aug 2025 12:31:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1754681492; x=1755286292; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=ro4+FtT36P0uTgVG3WfajWkOinLpx+b5TG+Ar8AlCog=;
        b=iP47wh9wtxYrdkjGIgAJDbes/ox5uOW4dtoiAup8lGXA7GtsXDeJWmPbDAaAiQLdg9
         nTZ9m7jT1TaC8N1TOZ25XYhjf9CwlSSqGrV0dmgYeh8b3DFw955B4bbpJKHPXltIzJcm
         Aq43DjiSUTpwbBPYc9RydWFfvdYvqPcmKNQXGDajxbSyMtEqJavPk9Czg0A07APmPzdg
         TPY7XLgpdPpZZIY4QJSAgZ0oe3ikFykkmZk7euMdzg0Yb0JIJanhkdDSfEvXPhOTNO8v
         F4v1uQ01kTB7HdLbarBUqpGkEHdNV2HYlPX9mNsEnUOh8dtOTQ22wfKLc76cy9mdBv8z
         sS/g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1754681492; x=1755286292;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=ro4+FtT36P0uTgVG3WfajWkOinLpx+b5TG+Ar8AlCog=;
        b=Wzym6ypnGWwZ4WIDOZSUtnNGSFVhJrXij1eXQdGlQNmuARJiBdJS1NycPcCjD/F5D+
         aPj2ZBGA/1FoHoxIzPexmarbnvIH5yxrTZEeJ2dYLDIJPUsxilzYhGy/bAI5Kh3AqSJU
         6X0UHIE/VWxBc2bNw1gX4d+V05EFojI07ruMv5Y8TChRH3/RcjWPw3UmD09n49TZEMm8
         9EAcLg/VnAqomnY9AAxL3vDGL9JA2IgGfpBJqVx8Zxpu1Izp2WRPSaAdMmZhPaEw3R08
         qpJiS4buI8PPJPE0lDW6cjihp4ejlaHPzxAAbSOWVzqWlP9k5NTtN9EF4t40/Hr5MjEl
         lMow==
X-Forwarded-Encrypted: i=1; AJvYcCXqs5JU9nKlv09v5z+EdZ1rKJ0eGmn+YQafi9DLydniURtj+7XXUqJI2KBlu+cR1zGlI7x/eWk=@lists.linux.dev
X-Gm-Message-State: AOJu0Yw2oyacy619efFvdBmBte99z57vq2ZiTD6yOgZ4lMWaq6hO3G6T
	LuFpnE3BENGgkL5XTRNMI6hZx66aN1QpoWYSmWK2Y1AtccWe76HmSBIuk1jBlSDMYRP53CfvgsA
	po8O2LtYBCTr5eKKDLIY00WzFM5hn87qeatROJgXVQoMfW+97ospoDhvA
X-Gm-Gg: ASbGncseXjJ001h3wuSBSTBYxTEVMcHpjjeCTue8GOerztz+VGg7kNiArLaztgKupSv
	wOJPJw9ABc4Ql/5LS50dS21E53EAPfNBm7sS6zt1uA8oKIgbR+cZD7AxHRwgsFuMELM3oK234E4
	ywn6O4i2WDEjXDfsBoCZFfYhbnH877ikmN4T9/rU6+Y3lGvChF/7t5RfSTZ7OwmBRyTtSehiHDn
	1Q8TcX4kmRCJrryuF2y3XzYmB4gDnf+CrUvqnpX
X-Google-Smtp-Source: AGHT+IFdNh8DxW6rabgQoQThyzn8c6Z72bCqnho8pLmHxdOkHsIXSM9B821wRptwcs8VazRwJK4YbvUdGcBE+gSVn8E=
X-Received: by 2002:a17:903:120a:b0:240:41a4:96c0 with SMTP id
 d9443c01a7336-242c2208e85mr62541685ad.29.1754681491512; Fri, 08 Aug 2025
 12:31:31 -0700 (PDT)
Precedence: bulk
X-Mailing-List: syzbot@lists.linux.dev
List-Id: <syzbot.lists.linux.dev>
List-Subscribe: <mailto:syzbot+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:syzbot+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <68964f3d.050a0220.7f033.0087.GAE@google.com>
In-Reply-To: <68964f3d.050a0220.7f033.0087.GAE@google.com>
From: Aleksandr Nogikh <nogikh@google.com>
Date: Fri, 8 Aug 2025 21:31:19 +0200
X-Gm-Features: Ac12FXw9nuBreSh9O9hNoRcJfG8dcVYTInzLAPSzQS7sogyzl3Hhg2aq0jrBDvI
Message-ID: <CANp29Y6eepRy-sSA-P9VcQgugivqtb4ognV9n=mytMW9UTgQmQ@mail.gmail.com>
Subject: Re: [moderation/CI] Re: TUN/TAP: Improving throughput and latency by
 avoiding SKB drops
To: syzbot ci <syzbot+cidfe78bc1bc79cb69@syzkaller.appspotmail.com>
Cc: syzkaller-upstream-moderation@googlegroups.com, syzbot@lists.linux.dev
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

#syz upstream

On Fri, Aug 8, 2025 at 9:25=E2=80=AFPM syzbot ci
<syzbot+cidfe78bc1bc79cb69@syzkaller.appspotmail.com> wrote:
>
> syzbot ci has tested the following series
>
> [v1] TUN/TAP: Improving throughput and latency by avoiding SKB drops
> https://lore.kernel.org/all/20250808153721.261334-1-simon.schippers@tu-do=
rtmund.de
> * [PATCH net] TUN/TAP: Improving throughput and latency by avoiding SKB d=
rops
>
> and found the following issue:
> general protection fault in tun_net_xmit
>
> Full report is available here:
> https://ci.syzbot.org/series/4a9dd6ad-3c81-4957-b447-4d1e8e9ee7a2
>
> ***
>
> general protection fault in tun_net_xmit
>
> tree:      net
> URL:       https://kernel.googlesource.com/pub/scm/linux/kernel/git/netde=
v/net.git
> base:      ae633388cae349886f1a3cfb27aa092854b24c1b
> arch:      amd64
> compiler:  Debian clang version 20.1.7 (++20250616065708+6146a88f6049-1~e=
xp1~20250616065826.132), Debian LLD 20.1.7
> config:    https://ci.syzbot.org/builds/f35af9e4-44af-4a13-8842-d9d36ecb0=
6e7/config
> C repro:   https://ci.syzbot.org/findings/e400bf02-40dc-43bb-8c15-d21b7ec=
b7304/c_repro
> syz repro: https://ci.syzbot.org/findings/e400bf02-40dc-43bb-8c15-d21b7ec=
b7304/syz_repro
>
> Oops: general protection fault, probably for non-canonical address 0xdfff=
fc0000000002: 0000 [#1] SMP KASAN PTI
> KASAN: null-ptr-deref in range [0x0000000000000010-0x0000000000000017]
> CPU: 1 UID: 0 PID: 12 Comm: kworker/u8:0 Not tainted 6.16.0-syzkaller-066=
20-gae633388cae3-dirty #0 PREEMPT(full)
> Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS 1.16.2-debian-1.=
16.2-1 04/01/2014
> Workqueue: ipv6_addrconf addrconf_dad_work
> RIP: 0010:__ptr_ring_full include/linux/ptr_ring.h:51 [inline]
> RIP: 0010:ptr_ring_full include/linux/ptr_ring.h:59 [inline]
> RIP: 0010:tun_net_xmit+0x3ee/0x19c0 drivers/net/tun.c:1026
> Code: 54 24 18 48 89 d0 48 c1 e8 03 48 89 44 24 58 42 0f b6 04 28 84 c0 0=
f 85 f9 11 00 00 48 63 02 48 8d 1c c3 48 89 d8 48 c1 e8 03 <42> 80 3c 28 00=
 74 08 48 89 df e8 d3 0f ac fb 48 8b 1b 48 8b 7c 24
> RSP: 0018:ffffc900000f6f00 EFLAGS: 00010202
> RAX: 0000000000000002 RBX: 0000000000000010 RCX: dffffc0000000000
> RDX: ffff88811bf90940 RSI: 0000000000000004 RDI: ffffc900000f6e80
> RBP: ffffc900000f7050 R08: 0000000000000003 R09: 0000000000000004
> R10: dffffc0000000000 R11: fffff5200001edd0 R12: 0000000000000000
> R13: dffffc0000000000 R14: ffff8881054c8000 R15: 0000000000000000
> FS:  0000000000000000(0000) GS:ffff8881a3c80000(0000) knlGS:0000000000000=
000
> CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> CR2: 0000200000002280 CR3: 0000000110b70000 CR4: 00000000000006f0
> Call Trace:
>  <TASK>
>  __netdev_start_xmit include/linux/netdevice.h:5219 [inline]
>  netdev_start_xmit include/linux/netdevice.h:5228 [inline]
>  xmit_one net/core/dev.c:3827 [inline]
>  dev_hard_start_xmit+0x2d7/0x830 net/core/dev.c:3843
>  sch_direct_xmit+0x241/0x4b0 net/sched/sch_generic.c:344
>  __dev_xmit_skb net/core/dev.c:4102 [inline]
>  __dev_queue_xmit+0x1857/0x3b50 net/core/dev.c:4679
>  neigh_output include/net/neighbour.h:547 [inline]
>  ip6_finish_output2+0x11fe/0x16a0 net/ipv6/ip6_output.c:141
>  NF_HOOK include/linux/netfilter.h:318 [inline]
>  ndisc_send_skb+0xb54/0x1440 net/ipv6/ndisc.c:512
>  addrconf_dad_completed+0x7ae/0xd60 net/ipv6/addrconf.c:4360
>  addrconf_dad_work+0xc36/0x14b0 net/ipv6/addrconf.c:-1
>  process_one_work kernel/workqueue.c:3238 [inline]
>  process_scheduled_works+0xae1/0x17b0 kernel/workqueue.c:3321
>  worker_thread+0x8a0/0xda0 kernel/workqueue.c:3402
>  kthread+0x711/0x8a0 kernel/kthread.c:464
>  ret_from_fork+0x3fc/0x770 arch/x86/kernel/process.c:148
>  ret_from_fork_asm+0x1a/0x30 arch/x86/entry/entry_64.S:245
>  </TASK>
> Modules linked in:
> ---[ end trace 0000000000000000 ]---
> RIP: 0010:__ptr_ring_full include/linux/ptr_ring.h:51 [inline]
> RIP: 0010:ptr_ring_full include/linux/ptr_ring.h:59 [inline]
> RIP: 0010:tun_net_xmit+0x3ee/0x19c0 drivers/net/tun.c:1026
> Code: 54 24 18 48 89 d0 48 c1 e8 03 48 89 44 24 58 42 0f b6 04 28 84 c0 0=
f 85 f9 11 00 00 48 63 02 48 8d 1c c3 48 89 d8 48 c1 e8 03 <42> 80 3c 28 00=
 74 08 48 89 df e8 d3 0f ac fb 48 8b 1b 48 8b 7c 24
> RSP: 0018:ffffc900000f6f00 EFLAGS: 00010202
> RAX: 0000000000000002 RBX: 0000000000000010 RCX: dffffc0000000000
> RDX: ffff88811bf90940 RSI: 0000000000000004 RDI: ffffc900000f6e80
> RBP: ffffc900000f7050 R08: 0000000000000003 R09: 0000000000000004
> R10: dffffc0000000000 R11: fffff5200001edd0 R12: 0000000000000000
> R13: dffffc0000000000 R14: ffff8881054c8000 R15: 0000000000000000
> FS:  0000000000000000(0000) GS:ffff8881a3c80000(0000) knlGS:0000000000000=
000
> CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> CR2: 0000200000002280 CR3: 0000000110b70000 CR4: 00000000000006f0
> ----------------
> Code disassembly (best guess):
>    0:   54                      push   %rsp
>    1:   24 18                   and    $0x18,%al
>    3:   48 89 d0                mov    %rdx,%rax
>    6:   48 c1 e8 03             shr    $0x3,%rax
>    a:   48 89 44 24 58          mov    %rax,0x58(%rsp)
>    f:   42 0f b6 04 28          movzbl (%rax,%r13,1),%eax
>   14:   84 c0                   test   %al,%al
>   16:   0f 85 f9 11 00 00       jne    0x1215
>   1c:   48 63 02                movslq (%rdx),%rax
>   1f:   48 8d 1c c3             lea    (%rbx,%rax,8),%rbx
>   23:   48 89 d8                mov    %rbx,%rax
>   26:   48 c1 e8 03             shr    $0x3,%rax
> * 2a:   42 80 3c 28 00          cmpb   $0x0,(%rax,%r13,1) <-- trapping in=
struction
>   2f:   74 08                   je     0x39
>   31:   48 89 df                mov    %rbx,%rdi
>   34:   e8 d3 0f ac fb          call   0xfbac100c
>   39:   48 8b 1b                mov    (%rbx),%rbx
>   3c:   48                      rex.W
>   3d:   8b                      .byte 0x8b
>   3e:   7c 24                   jl     0x64
>
>
> ***
>
> If these findings have caused you to resend the series or submit a
> separate fix, please add the following tag to your commit message:
> Tested-by: syzbot@syzkaller.appspotmail.com
>
> ---
> This report is generated by a bot. It may contain errors.
> syzbot ci engineers can be reached at syzkaller@googlegroups.com.
>
> The email will later be sent to:
> [jasowang@redhat.com linux-kernel@vger.kernel.org netdev@vger.kernel.org =
simon.schippers@tu-dortmund.de tim.gebauer@tu-dortmund.de willemdebruijn.ke=
rnel@gmail.com]
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
-upstream-moderation/68964f3d.050a0220.7f033.0087.GAE%40google.com.
