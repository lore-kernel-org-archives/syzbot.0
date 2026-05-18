Received: from mail-oa1-f53.google.com (mail-oa1-f53.google.com [209.85.160.53])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 153D145BD7C
	for <syzbot@lists.linux.dev>; Mon, 18 May 2026 16:36:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.160.53
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779122180; cv=pass; b=gQDbz4ofGo5qnumHCAu5Gaugd16e0ztQygf0yXn+rls+A0SULdw0RQl39jBY+nifvZkvhKYKQxgpn1mMsPZ4OB+NAFTxJGIpsuXmKhn1sVV/n95fdFCxBQyzfYZ+lDSTBDsvkWY+XyQ7aGSpCpM+kVnGCrWoD6X8IrFWEc69Vss=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779122180; c=relaxed/simple;
	bh=+Yt9ejyBkLiVYCVfD9PY2xFkRDxoGJ7cv8J0/nCg7xc=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=GsKR6XhBYJIIj+DTSs60xuVIWrOSgUOpwhp9etNzLdr4kODDPZM9pes/JwdwiQp/Uy6hzorgmOrdCQvxK9aFwFhvNeOuvnMybcJ9B3ym0TG1JdayBL56tfVzgw7gwfgOmItfTNYiIsEfcMyQwBZo0AWolpQAeOYIyW6iuW3y3l4=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=ApbtNYDq; arc=pass smtp.client-ip=209.85.160.53
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="ApbtNYDq"
Received: by mail-oa1-f53.google.com with SMTP id 586e51a60fabf-43a6faf8d1eso704229fac.2
        for <syzbot@lists.linux.dev>; Mon, 18 May 2026 09:36:18 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1779122178; cv=none;
        d=google.com; s=arc-20240605;
        b=PPb8G+OuMNemlWZX/6Ny3/9pncv2Wwn6id5Rs8BRmrZO3nBlGRCyjreurwxH5To76s
         0PhrkJ9MtH6S8xzg3mftC4NxtSveT6vJDWO3ij1c1SUb9x0ufoWMIA5/mkT9iMUrf03c
         M1V08EijEhwAsI/TcZA+Q0ZrlXg2PD1j5VMJA2cccWzvXiy1mnHKyYrnzaELIRgQWEhk
         UfI4gVspkuWl4qNR99cWqzOO7+xz9NZQt1F4YeU8OUxxVkgR7tRe5I9hOV4Q0VC7brRq
         rugarNrANiOVzmz24ThmrF1EWMRBT4rl9BgZfnPNrszLrPXwA7kGLtW7yPFgo/j8/wNa
         ElKg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=5rr/TfPaVnTBLegwsS/RF4l77U7N3W+Xz+L6/sL17wk=;
        fh=yTLRC1O2x8CR/xl2H7IcDnQuKnPXBQn7lcDQQ/Fwsz0=;
        b=f7TpkL2tO/iGGagwVnrSRsRIvBdN0/mYXFzE8uO+Xz6wO2DxWiE8491ay1m/9zewEk
         Iy/8MS1FkrDIUGGya55MfoRzp7I4hY+pbGUjubd5MN3yBQcY+7MXRNtHbVooPYUlp0Xt
         i4PrnQLVehVALEVENpF8ikr88QvmaUJyBnXVe7OqIfCBfQc1pqXv/KVfZWQkypKuYL0r
         hBq+Bl2C2h/0P5Ygxc+QDU+VhXaUNG37jiJj6qeTvcSjyDwGej0JHQ8cH+jRMWyrD0L0
         PXQ4ag0s9EqaCp/ykufzQLlbT1iTNZT16cEIaUYZEwh59iVYxEJy7HDHS5eivUUt0hOk
         5slg==;
        darn=lists.linux.dev
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1779122178; x=1779726978; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=5rr/TfPaVnTBLegwsS/RF4l77U7N3W+Xz+L6/sL17wk=;
        b=ApbtNYDq2cK7Kz94miLYx3hpV0lqtapxhWUAIJon4PsyCQuz5IGqtZU5yaqafdbPcA
         fuVN67nH0FaCgkKX6n8QlRUX2oXJfIjD26L/prFuSYKf9gpUTHaRwSD9NoCvh9MBla3P
         N2duUY7evJuIe+Ge3HyZUZcLYbFk8SFsbV8R0o5yYnwAumtWeVnCIkXHIHVuGt0cmTwh
         o8VDRP+tMnXfsfqmnZl9e+77xanM0uNCfUX5ljwB90/ID2WZAaZJhJS+Pw9ZdpERuYFq
         E0xORiXc7l6LcuieVzL6xjYu5Im/pIRPmoBfX2+fZBcR+6wQwoThuzk87eaAJnyxdkFt
         NQkw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1779122178; x=1779726978;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=5rr/TfPaVnTBLegwsS/RF4l77U7N3W+Xz+L6/sL17wk=;
        b=jJEUi5Y681iy80vKeDRAzEck1ZC+dWA6NGJ05bpNmBC0Gb/JT5QVshp3bgb/GUrr0W
         YgGdJOTWcV2OPhlELZB0BYZeVB8J/hMHtSYIwD2/OLSK8jUVpBC8RoYqyxH5Rw4zDv9u
         s8aXomYqeuHp+r8ZPN3T7FZeBmeCWUcMPAQHtuZsTcYc4sRZM7PUydabcyFlGCpgsGvN
         Xk1RHw62vMlLeR7XJcjsIhOA2LLbasCY0opqCFavYcf5Vl9b7wp099+RSHiEBhFnuKM1
         VAMKB5yIyaOONvxPr4LCLvZmEEfBSpG6tsXCDhovqx3LzeYAKXH1tlt2ROdjhyVYCW0V
         dX4Q==
X-Forwarded-Encrypted: i=1; AFNElJ80rgiGEZjKnq94vplXC9hfNXV/v+MCeKidTjGqqUcHbtGqmFFLZ42WqvrKM6CcuV860VWdFSY=@lists.linux.dev
X-Gm-Message-State: AOJu0YyI2FStk1VNheGVk2LlFGfztn2bs8neUHo6Iyx2zLTGIzaBmJW4
	Qye75MbjquJjaI565nxEDzpiz0+MKGR374ZShr/l7isvhhnVNOK0thdLPK0k4jjyzKsLpQbZogR
	Lso57kauxxxeRXKBnS0rIJCB4tMwwZjPGSrCn5k5q
X-Gm-Gg: Acq92OHdJzZSV/f27vZ2Llw0bOCXP3qlb7I32a9/bEua+9nnVthiVKP7lhIylAaJsOf
	v4/c34AjDtJZvxgTTEnklvkgRNtzUp2BqzEcupYiA8ibqXLGDO/Z7r9JdC+zJlnOrU9MIDd0EkK
	kWur8HOKCSfpJroHhuuM36A8L05SBYFTmn9jMTfBrQX2vitSOS2/RH5MVMDSPDWG8AR5Rpjv2JM
	RtvvYarp3srINr751RMw3rme/Zj88b2OhIsi8EqWk7ajsVd9Vqu3l0iiLC8rmIBbB7wSdwrYzkv
	2oqbDRHObNthl0pq6aQiTOW5kNMkGzFx1fOsmok3FDnqxmeGiJSdU50jIhahZiFZOYDri2k7tCU
	DIyEH1e/3E43Q1Qxb
X-Received: by 2002:a05:6870:239e:b0:439:fc23:5797 with SMTP id
 586e51a60fabf-43a2dd33cf4mr9168251fac.25.1779122177514; Mon, 18 May 2026
 09:36:17 -0700 (PDT)
Precedence: bulk
X-Mailing-List: syzbot@lists.linux.dev
List-Id: <syzbot.lists.linux.dev>
List-Subscribe: <mailto:syzbot+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:syzbot+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <6a0b30c4.a70a0220.202581.0004.GAE@google.com>
In-Reply-To: <6a0b30c4.a70a0220.202581.0004.GAE@google.com>
From: Aleksandr Nogikh <nogikh@google.com>
Date: Mon, 18 May 2026 18:36:05 +0200
X-Gm-Features: AVHnY4IZktfTILcGvTRXIs50nv3wziFKdZioID2OyvKE0sTzKn-ypKbISxYF4co
Message-ID: <CANp29Y62RXEirtq8iQHXinHaDZAv72kye3xT1+vaahNhdYaTAg@mail.gmail.com>
Subject: Re: [moderation/CI] Re: rtnetlink: RTNL avoidance in rtnl_getlink()
To: syzbot ci <syzbot+ci99ea617af90e9814@syzkaller.appspotmail.com>
Cc: syzkaller-upstream-moderation@googlegroups.com, syzbot@lists.linux.dev
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

#syz upstream

On Mon, May 18, 2026 at 5:31=E2=80=AFPM syzbot ci
<syzbot+ci99ea617af90e9814@syzkaller.appspotmail.com> wrote:
>
> syzbot ci has tested the following series
>
> [v1] rtnetlink: RTNL avoidance in rtnl_getlink()
> https://lore.kernel.org/all/20260518100134.809042-1-edumazet@google.com
> * [PATCH net-next 1/2] rtnetlink: use nla_nest_end_safe() in rtnl_fill_pr=
op_list()
> * [PATCH net-next 2/2] rtnetlink: do not acquire RTNL for RTM_GETLINK wit=
h RTEXT_FILTER_NAME_ONLY
>
> and found the following issue:
> WARNING in rtnl_fill_ifinfo
>
> Full report is available here:
> https://ci.syzbot.org/series/c0efec5e-90ce-4ba2-8383-16d7bc172521
>
> ***
>
> WARNING in rtnl_fill_ifinfo
>
> tree:      net-next
> URL:       https://kernel.googlesource.com/pub/scm/linux/kernel/git/netde=
v/net-next.git
> base:      627ac78f2741e2ebd2225e2e953b6964a8a9182f
> arch:      amd64
> compiler:  Debian clang version 21.1.8 (++20251221033036+2078da43e25a-1~e=
xp1~20251221153213.50), Debian LLD 21.1.8
> config:    https://ci.syzbot.org/builds/9507e45e-17a8-457b-a47d-5229f306e=
1f1/config
> syz repro: https://ci.syzbot.org/findings/e56b032e-6444-4682-b577-34e2239=
9b7cc/syz_repro
>
> ------------[ cut here ]------------
> RTNL: assertion failed at net/core/rtnetlink.c (2071)
> WARNING: net/core/rtnetlink.c:2071 at rtnl_fill_ifinfo+0xc73/0x2770 net/c=
ore/rtnetlink.c:2071, CPU#1: syz.1.18/5818
> Modules linked in:
> CPU: 1 UID: 0 PID: 5818 Comm: syz.1.18 Not tainted syzkaller #0 PREEMPT(f=
ull)
> Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS 1.16.2-debian-1.=
16.2-1 04/01/2014
> RIP: 0010:rtnl_fill_ifinfo+0xc7f/0x2770 net/core/rtnetlink.c:2071
> Code: 5a 41 f8 45 85 f6 74 2c e8 be 55 41 f8 e9 91 fc ff ff e8 b4 55 41 f=
8 48 8d 3d 9d af bb 06 48 c7 c6 40 1c de 8c ba 17 08 00 00 <67> 48 0f b9 3a=
 e9 5d f4 ff ff 48 8d 8c 24 00 02 00 00 48 8b 44 24
> RSP: 0018:ffffc90003bcee40 EFLAGS: 00010293
> RAX: ffffffff89846eac RBX: 1ffff92000779dd4 RCX: ffff88816b500000
> RDX: 0000000000000817 RSI: ffffffff8cde1c40 RDI: ffffffff90401e50
> RBP: ffffc90003bcf118 R08: ffffffff8fdd1227 R09: 1ffffffff1fba244
> R10: dffffc0000000000 R11: fffffbfff1fba245 R12: 0000000000000010
> R13: 0000000000000003 R14: 1ffff92000779dd4 R15: ffff88816b898000
> FS:  00007f293800b6c0(0000) GS:ffff8882a927a000(0000) knlGS:0000000000000=
000
> CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> CR2: 00007f2937072780 CR3: 000000016a7d4000 CR4: 00000000000006f0
> Call Trace:
>  <TASK>
>  rtnl_getlink+0xce4/0x10d0 net/core/rtnetlink.c:4267
>  rtnetlink_rcv_msg+0x7d5/0xbe0 net/core/rtnetlink.c:7042
>  netlink_rcv_skb+0x232/0x4b0 net/netlink/af_netlink.c:2551
>  netlink_unicast_kernel net/netlink/af_netlink.c:1319 [inline]
>  netlink_unicast+0x75c/0x8e0 net/netlink/af_netlink.c:1345
>  netlink_sendmsg+0x813/0xb40 net/netlink/af_netlink.c:1895
>  sock_sendmsg_nosec net/socket.c:787 [inline]
>  __sock_sendmsg net/socket.c:802 [inline]
>  ____sys_sendmsg+0x972/0x9f0 net/socket.c:2698
>  ___sys_sendmsg+0x2a5/0x360 net/socket.c:2752
>  __sys_sendmsg net/socket.c:2784 [inline]
>  __do_sys_sendmsg net/socket.c:2789 [inline]
>  __se_sys_sendmsg net/socket.c:2787 [inline]
>  __x64_sys_sendmsg+0x1bd/0x2a0 net/socket.c:2787
>  do_syscall_x64 arch/x86/entry/syscall_64.c:63 [inline]
>  do_syscall_64+0x15f/0xf80 arch/x86/entry/syscall_64.c:94
>  entry_SYSCALL_64_after_hwframe+0x77/0x7f
> RIP: 0033:0x7f293719ce59
> Code: ff c3 66 2e 0f 1f 84 00 00 00 00 00 0f 1f 44 00 00 48 89 f8 48 89 f=
7 48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 ff=
 ff 73 01 c3 48 c7 c1 e8 ff ff ff f7 d8 64 89 01 48
> RSP: 002b:00007f293800b028 EFLAGS: 00000246 ORIG_RAX: 000000000000002e
> RAX: ffffffffffffffda RBX: 00007f2937415fa0 RCX: 00007f293719ce59
> RDX: 0000000000000004 RSI: 0000200000000ac0 RDI: 0000000000000003
> RBP: 00007f2937232d6f R08: 0000000000000000 R09: 0000000000000000
> R10: 0000000000000000 R11: 0000000000000246 R12: 0000000000000000
> R13: 00007f2937416038 R14: 00007f2937415fa0 R15: 00007ffffb498538
>  </TASK>
> ----------------
> Code disassembly (best guess):
>    0:   5a                      pop    %rdx
>    1:   41 f8                   rex.B clc
>    3:   45 85 f6                test   %r14d,%r14d
>    6:   74 2c                   je     0x34
>    8:   e8 be 55 41 f8          call   0xf84155cb
>    d:   e9 91 fc ff ff          jmp    0xfffffca3
>   12:   e8 b4 55 41 f8          call   0xf84155cb
>   17:   48 8d 3d 9d af bb 06    lea    0x6bbaf9d(%rip),%rdi        # 0x6b=
bafbb
>   1e:   48 c7 c6 40 1c de 8c    mov    $0xffffffff8cde1c40,%rsi
>   25:   ba 17 08 00 00          mov    $0x817,%edx
> * 2a:   67 48 0f b9 3a          ud1    (%edx),%rdi <-- trapping instructi=
on
>   2f:   e9 5d f4 ff ff          jmp    0xfffff491
>   34:   48 8d 8c 24 00 02 00    lea    0x200(%rsp),%rcx
>   3b:   00
>   3c:   48                      rex.W
>   3d:   8b                      .byte 0x8b
>   3e:   44                      rex.R
>   3f:   24                      .byte 0x24
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
> [davem@davemloft.net edumazet@google.com eric.dumazet@gmail.com horms@ker=
nel.org kuba@kernel.org kuniyu@google.com netdev@vger.kernel.org pabeni@red=
hat.com]
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
-upstream-moderation/6a0b30c4.a70a0220.202581.0004.GAE%40google.com.
