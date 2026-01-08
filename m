Received: from mail-oi1-f179.google.com (mail-oi1-f179.google.com [209.85.167.179])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F3E62314A86
	for <syzbot@lists.linux.dev>; Thu,  8 Jan 2026 06:36:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.167.179
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767854198; cv=none; b=PE3wF2TnoQ+YfBWYgaYt3GcVVPPJQKvO9Qy54H9iFqPkcWlXTfe0yPeXC8R3vSlSmnBEJxnGkcxZwSlvCB5px+K50V7O4gkVhwVcZEDKH4RUDamlIy7vsQjPw+Wwart+v6u/2L0kZF07ttlTuSDlcsgbeV+Nw+DyJrPhfS/uxv8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767854198; c=relaxed/simple;
	bh=trw33nEwSKeDEmlITE8+BgFqOKTRLccNpSxZfxWPyfE=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=r711fqkdrTqrEURVmw9TgzKztHn0oSp6Da+5i8q/YzSgL1TACeuT5U+7O1e4vnc8gy76d5eogjLOEtHJE2AcKN1MNTcfg8m5+2ZfhkhVnu4mQ5dZULq1qQhXtrxU9H5ZpQhvH61tIrr3bSWzSlQvj+eoLFHOGAFtmyaeCaeJX5E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=f3tg04lP; arc=none smtp.client-ip=209.85.167.179
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="f3tg04lP"
Received: by mail-oi1-f179.google.com with SMTP id 5614622812f47-4510974a6bbso1163889b6e.3
        for <syzbot@lists.linux.dev>; Wed, 07 Jan 2026 22:36:10 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1767854167; x=1768458967; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=wEW7PXCyPhYeT8fme84sJQwgRmWazMyxUXKpEmChqdg=;
        b=f3tg04lPiP5k/yHz6ZqGB7HcFjzF9VoqYngzxlAhspIUzoCoFa1nd7N+mtak5uxpON
         1FU8BU5ea+JvWHbSoDqUgqqcfvi5vbcueULZdOYTC1+b8CmrSw5esQ4x1lHPDmHT4nLg
         VtfitYHzkfSvMrWwspX6Jxu+sdrUbONt6nfHXwu8eHFl0cDRKGPIEbDBhT9Ys276mvsg
         hesHyd0ky8xLOuv1NOh/DRnP7SqSAQGSF3BCRr0rUgQdiayHKqCxR9KPST4uwBUuf2LJ
         ZFRF18ugblpzxPh6eep2Rt6d/+ICd6QVFjUxuqOWRfc+Fc7vjgZEf2HIEsS2UtHaANxl
         kGfA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1767854167; x=1768458967;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=wEW7PXCyPhYeT8fme84sJQwgRmWazMyxUXKpEmChqdg=;
        b=cmzDDsSrjReHtEgE4NkXQjIhGSe217MwyYrfITMeesoYaZ/pB75bE2zlY1VvnhUeTX
         toIs+cvJIbtodBTCzr2/oqJIyy7aw/kPylthdSBlbJmeaZ8tqitUqZI95tlBsO10a9Z6
         Fve2a7Hq0pfU2HaIwWrOmbQ6BQ49rwLoxE92hM7NDNwZZyu9zQCqWWf7TpU1VXYERDiO
         BUIgzGlrg1rlwghoTegSCZsOC1p9eO8+DxD2oYrLCzjoYywPAwGls86aTmhxBdtupvNv
         3wf/coUw8C3CL+dxlUD5qSRrSTx+ckNWWG0E8Chczyvormn7RD9yqLtj0l5SlRLEVGFq
         CsFA==
X-Forwarded-Encrypted: i=1; AJvYcCVRPRMnuZOrYSWbo5K7SgTgLMcxFVPWeFUbCatLoJlltVfphVA4z8btUwiZARG+U/rZloMdhhg=@lists.linux.dev
X-Gm-Message-State: AOJu0Ywa3EjOFmb+wPxgp6sj5ZredT6+LULjZl7VcflJf0zM0A4p8FLI
	YiJY2cn+J8qollf6im0/xLnR/p8tFwnE4OYKUTkI2Jc6BSp7RfhmAtaRr+VahOBalDvf+BhbGIK
	+P9Kzzu473wwECmblXbcYjaMXDmN1R53XyzajLkw8
X-Gm-Gg: AY/fxX7mV1opp3IxekOpYpXn1gS+FtI8Hk0bC5dxpA+DDDYkdpHjPNWsNf9M8rXPpku
	ThL8hOvAXkImU9KPr4K5CGw9BAKi0KBJhvIXrPnN3u/f54qKM2J2WehHT35VeZa5pTiTszoXSqC
	KMa6FLClyGwFVMpZZfxFTmiTJGApua8xcHmr3c0G0TGd8A6hOgS9GB4gguo+6SC0iNTqkAHTSFP
	wKkVrwU7GpeCRjJvDCUG0Wl8VdCVQ+Q5FbjvsBuBcRlnbGSTEGJBmXqHz+zxFFtDUyjASXHdrPz
	BhE6moJYPl9BUFUEMJxjB6FIa1GUjTXVrM1jpDPIRCYJpuP1lfebW5aqzcs=
X-Google-Smtp-Source: AGHT+IHVdOG9nLC5R/5uPXKLRUIpyJieSvuPpJZFmM/B3vCBM8sVCDIj4+DeHE+R1P65/hCI1riU4wSTh7RPYBdtpC0=
X-Received: by 2002:a4a:d090:0:b0:65d:286f:a476 with SMTP id
 006d021491bc7-65f5509c1a2mr1442324eaf.84.1767854166795; Wed, 07 Jan 2026
 22:36:06 -0800 (PST)
Precedence: bulk
X-Mailing-List: syzbot@lists.linux.dev
List-Id: <syzbot.lists.linux.dev>
List-Subscribe: <mailto:syzbot+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:syzbot+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <695ece24.050a0220.1c677c.037e.GAE@google.com>
In-Reply-To: <695ece24.050a0220.1c677c.037e.GAE@google.com>
From: Aleksandr Nogikh <nogikh@google.com>
Date: Thu, 8 Jan 2026 07:35:55 +0100
X-Gm-Features: AQt7F2qUTyL5focJeHsx6nBCkdUDF8V30L6WkdNkIwJg4KmAIatEvcco4Pq4ym0
Message-ID: <CANp29Y5YsRWCsWwjtWJ7x8=_qupBnUcvrK-hzgyjLPB6+ODf8w@mail.gmail.com>
Subject: Re: [moderation/CI] Re: net: update netdev_lock_{type,name}
To: syzbot ci <syzbot+ci56a5bef79a4c8127@syzkaller.appspotmail.com>
Cc: syzkaller-upstream-moderation@googlegroups.com, syzbot@lists.linux.dev
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

#syz upstream

On Wed, Jan 7, 2026 at 10:20=E2=80=AFPM syzbot ci
<syzbot+ci56a5bef79a4c8127@syzkaller.appspotmail.com> wrote:
>
> syzbot ci has tested the following series
>
> [v2] net: update netdev_lock_{type,name}
> https://lore.kernel.org/all/20260107125423.4031241-1-edumazet@google.com
> * [PATCH v2 net] net: update netdev_lock_{type,name}
>
> and found the following issue:
> WARNING in register_netdevice
>
> Full report is available here:
> https://ci.syzbot.org/series/07a2abd3-8dbc-43d0-a5d9-cdbb1a35d769
>
> ***
>
> WARNING in register_netdevice
>
> tree:      net
> URL:       https://kernel.googlesource.com/pub/scm/linux/kernel/git/netde=
v/net.git
> base:      1806d210e5a8f431ad4711766ae4a333d407d972
> arch:      amd64
> compiler:  Debian clang version 21.1.8 (++20251202083448+f68f64eb8130-1~e=
xp1~20251202083504.46), Debian LLD 21.1.8
> config:    https://ci.syzbot.org/builds/f4fb7576-ea1f-485d-9ef1-c3270f156=
0d9/config
> C repro:   https://ci.syzbot.org/findings/e4767ea9-6be5-4bce-9523-40ab12d=
29b67/c_repro
> syz repro: https://ci.syzbot.org/findings/e4767ea9-6be5-4bce-9523-40ab12d=
29b67/syz_repro
>
> ------------[ cut here ]------------
> netdev_lock_pos() could not find dev_type=3D805
> WARNING: net/core/dev.c:529 at netdev_lock_pos net/core/dev.c:529 [inline=
], CPU#0: syz.0.17/5972
> WARNING: net/core/dev.c:529 at netdev_set_addr_lockdep_class net/core/dev=
.c:547 [inline], CPU#0: syz.0.17/5972
> WARNING: net/core/dev.c:529 at register_netdevice+0x7f9/0x1ba0 net/core/d=
ev.c:11318, CPU#0: syz.0.17/5972
> Modules linked in:
> CPU: 0 UID: 0 PID: 5972 Comm: syz.0.17 Not tainted syzkaller #0 PREEMPT(f=
ull)
> Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS 1.16.2-debian-1.=
16.2-1 04/01/2014
> RIP: 0010:netdev_lock_pos net/core/dev.c:529 [inline]
> RIP: 0010:netdev_set_addr_lockdep_class net/core/dev.c:547 [inline]
> RIP: 0010:register_netdevice+0x7fc/0x1ba0 net/core/dev.c:11318
> Code: ca 56 db f8 48 c7 03 00 00 00 00 41 bd f4 ff ff ff 4c 8b 64 24 28 e=
9 8f f9 ff ff e8 4e 59 74 f8 48 8d 3d 27 79 82 06 44 89 e6 <67> 48 0f b9 3a=
 41 bc 40 00 00 00 49 bf 00 00 00 00 00 fc ff df 4c
> RSP: 0018:ffffc9000768ef20 EFLAGS: 00010293
> RAX: ffffffff894e19b2 RBX: fffffffffffffff8 RCX: ffff8881063c57c0
> RDX: 0000000000000000 RSI: 0000000000000325 RDI: ffffffff8fd092e0
> RBP: ffffc9000768f090 R08: 0000000000000003 R09: 0000000000000000
> R10: dffffc0000000000 R11: ffffed10218fd9d4 R12: 0000000000000325
> R13: ffffffff8c902318 R14: 000000000000fffe R15: 0000000000000040
> FS:  000055556284f500(0000) GS:ffff88818e40f000(0000) knlGS:0000000000000=
000
> CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> CR2: 00007f4739c706c0 CR3: 00000001bdb86000 CR4: 00000000000006f0
> Call Trace:
>  <TASK>
>  ieee802154_if_add+0xb39/0x1050 net/mac802154/iface.c:667
>  ieee802154_add_iface_deprecated+0x43/0x70 net/mac802154/cfg.c:26
>  rdev_add_virtual_intf_deprecated net/ieee802154/rdev-ops.h:16 [inline]
>  ieee802154_add_iface+0x472/0x860 net/ieee802154/nl-phy.c:218
>  genl_family_rcv_msg_doit+0x22a/0x330 net/netlink/genetlink.c:1115
>  genl_family_rcv_msg net/netlink/genetlink.c:1195 [inline]
>  genl_rcv_msg+0x61c/0x7a0 net/netlink/genetlink.c:1210
>  netlink_rcv_skb+0x232/0x4b0 net/netlink/af_netlink.c:2550
>  genl_rcv+0x28/0x40 net/netlink/genetlink.c:1219
>  netlink_unicast_kernel net/netlink/af_netlink.c:1318 [inline]
>  netlink_unicast+0x80f/0x9b0 net/netlink/af_netlink.c:1344
>  netlink_sendmsg+0x813/0xb40 net/netlink/af_netlink.c:1894
>  sock_sendmsg_nosec net/socket.c:727 [inline]
>  __sock_sendmsg+0x21c/0x270 net/socket.c:742
>  ____sys_sendmsg+0x4d7/0x810 net/socket.c:2592
>  ___sys_sendmsg+0x2a5/0x360 net/socket.c:2646
>  __sys_sendmsg net/socket.c:2678 [inline]
>  __do_sys_sendmsg net/socket.c:2683 [inline]
>  __se_sys_sendmsg net/socket.c:2681 [inline]
>  __x64_sys_sendmsg+0x1bd/0x2a0 net/socket.c:2681
>  do_syscall_x64 arch/x86/entry/syscall_64.c:63 [inline]
>  do_syscall_64+0xe2/0xf80 arch/x86/entry/syscall_64.c:94
>  entry_SYSCALL_64_after_hwframe+0x77/0x7f
> RIP: 0033:0x7f4739d9acb9
> Code: ff c3 66 2e 0f 1f 84 00 00 00 00 00 0f 1f 44 00 00 48 89 f8 48 89 f=
7 48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 ff=
 ff 73 01 c3 48 c7 c1 e8 ff ff ff f7 d8 64 89 01 48
> RSP: 002b:00007ffd43a0e968 EFLAGS: 00000246 ORIG_RAX: 000000000000002e
> RAX: ffffffffffffffda RBX: 00007f473a005fa0 RCX: 00007f4739d9acb9
> RDX: 0000000020048000 RSI: 00002000000009c0 RDI: 0000000000000004
> RBP: 00007f4739e08bf7 R08: 0000000000000000 R09: 0000000000000000
> R10: 0000000000000000 R11: 0000000000000246 R12: 0000000000000000
> R13: 00007f473a005fac R14: 00007f473a005fa0 R15: 00007f473a005fa0
>  </TASK>
> ----------------
> Code disassembly (best guess):
>    0:   ca 56 db                lret   $0xdb56
>    3:   f8                      clc
>    4:   48 c7 03 00 00 00 00    movq   $0x0,(%rbx)
>    b:   41 bd f4 ff ff ff       mov    $0xfffffff4,%r13d
>   11:   4c 8b 64 24 28          mov    0x28(%rsp),%r12
>   16:   e9 8f f9 ff ff          jmp    0xfffff9aa
>   1b:   e8 4e 59 74 f8          call   0xf874596e
>   20:   48 8d 3d 27 79 82 06    lea    0x6827927(%rip),%rdi        # 0x68=
2794e
>   27:   44 89 e6                mov    %r12d,%esi
> * 2a:   67 48 0f b9 3a          ud1    (%edx),%rdi <-- trapping instructi=
on
>   2f:   41 bc 40 00 00 00       mov    $0x40,%r12d
>   35:   49 bf 00 00 00 00 00    movabs $0xdffffc0000000000,%r15
>   3c:   fc ff df
>   3f:   4c                      rex.WR
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
> [davem@davemloft.net edumazet@google.com eric.dumazet@gmail.com horms@ker=
nel.org kuba@kernel.org netdev@vger.kernel.org pabeni@redhat.com]
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
-upstream-moderation/695ece24.050a0220.1c677c.037e.GAE%40google.com.
