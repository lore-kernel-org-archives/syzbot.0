Received: from mail-oo1-f46.google.com (mail-oo1-f46.google.com [209.85.161.46])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C48E13C17
	for <syzbot@lists.linux.dev>; Mon,  1 Dec 2025 08:09:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.161.46
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764576587; cv=none; b=UKvg5HjoCHaYyvoGUyYwQEDgsgbsu0rcWoB9wFjWYDogSQBbCOMy+yWD8KGCXon3ASk3+uB+eH+zx70+bQynMWaY/Y0MEsbwsSu4BC4zDl0h1gd8q5OR+/FFNx0Y1SUQfPMVSX4xPingyxvif3gTH0V31licoCxlS50osdisCeA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764576587; c=relaxed/simple;
	bh=74Znf3vkHmXMa1dUbkmqFSF+BFROwN8rtaAl8RUVFUI=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=pVh6xnooxhxGZF+MhkeWlzxlEjPjVj2VlAPWd0VyZJ0P7R2B6yAQ9Il15PFcXUQXmtAF136fz1gXhtATfgwPIgonheLikhhYI7LR9M4Fz0hBzlwTkrVlmD10T1PL9TdUfhu1A2KuOqiAqhjkdF+CLfF9u4YACVsZE4di+poOj9A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=hvLGaQXL; arc=none smtp.client-ip=209.85.161.46
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="hvLGaQXL"
Received: by mail-oo1-f46.google.com with SMTP id 006d021491bc7-657523b5db0so565835eaf.2
        for <syzbot@lists.linux.dev>; Mon, 01 Dec 2025 00:09:44 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1764576584; x=1765181384; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=DEOphBnKWoAuTnvk2Ixow5DCA2EyUDD1ZbXz5t3gK7k=;
        b=hvLGaQXLe2rb/TKmCSMzt3HK9K24VFJajKAYTZSrq0B1LsrDo8Aio9vGwbOXaE4/v8
         ykRR5kRUSz+tRY7RgoghW9lNsc7cZfZra9/taUqf1nH5aXrPNN+vKXfFxrx5xqZXMXQz
         XZGJYvJBwhBN3zSNUV1RP5TZxBnHIQsoHHKFhNwAef+SiIvEaJxEdj9Tg0EssNgffoS1
         unvfngtjzc17dTZdKucpAdDSbwksVjIRaP0eh8+80P35n3Lg9Dhp4yHFj68NVIB+x1/U
         3a3BBo7W28YR2C262AjCoHM3XlZkWOsq6s2T7249w33YjcljpYeRs1MAYS7wsyeWTG1v
         0Pgg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1764576584; x=1765181384;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=DEOphBnKWoAuTnvk2Ixow5DCA2EyUDD1ZbXz5t3gK7k=;
        b=DcOJURuiv8OsrOuhZ6I+TiB3Jp9E22hohd+tvnwaMjecfeFVwTaPhS8Fz/EgmkvINg
         x6auDOljNkz502TS8j1VLkw2Vz4xd9JislQ+USIiaDfVV0NW2J8xkCb2THMzIkUHtWOr
         yGbY+z0KjeQMOZfmL1yObDWMOynStJ60bchesdZcy0G9Rq910j2KhSsNo7GcdoBn2ve5
         e7OWMK60ty0O3UPgKKtLGiKShYGxhxw0fj77VZUF2dwWcWHEMkPGo4Bv0sPkZXBlBVbI
         f3lZ440OaQz2RDyvyi/0mzw6Ks7RmkwzgSXCttbbZmN6JmEDthu75g/Z8cvyQIG7CuyE
         gh9A==
X-Forwarded-Encrypted: i=1; AJvYcCX7300b/3/fYbKlIUCtRF2tYXbcqgiXWz/7vvsXOOKMWEdjUZxyv5M521xzfYc2e+N929Bf12Y=@lists.linux.dev
X-Gm-Message-State: AOJu0Yx5FUsz3/1QTnrDjHEaauOuQSmazRY3egDoGie4fSHFMrud00UK
	evSi51jUYvbyN/NXv818q0FmGVVwWXHLfyRVqMDdxyj5f3akqXh4JVlAI37IIaNxfI4hyD8pT+K
	lNWqV5KeIweVuQBhJCdtuy8x3z6cqtr1mI9bHG9dP
X-Gm-Gg: ASbGncsv4wsO8lonEn484aTcgBSV1Yy2M5aCS+XKxYdgYxd49hYdewkfWoxaNdtOViG
	XY2jMBQ0zmNWI/i2po9GtWz2eawyn8+UhBvnx57GnrL5afo/6I2YsCsS+4JTLVwlnv+o6dhQmTG
	Ik2sANYHq9bRat0vkF83Wa3jcWMYUjV6qet/isTHBCBP9ciJdFIk7a7BA3GuhHeQ9sxxvIPUe7/
	QzTcuDDuFnfm6sobzga/8t6pfHWQfSamsj5SmFeBbI45gpq19Hl8g5RUy5S7LosnzT86QXbIv5t
	F/AhXqUwT4TL1IYGxznuP3zBCZHy6xXHBi569RuJMn1o5cEwoU7tdaZ0pfZ2
X-Google-Smtp-Source: AGHT+IEApmXqdJPM08EcDN1cp0ZeOKdu1AAkLPXOOeZEi175sJeznNIfmJcSHZeWQbuxYqt6kt6+/rt96wC5sMp5xvY=
X-Received: by 2002:a05:6820:4d0a:b0:657:56ba:7455 with SMTP id
 006d021491bc7-657923c3191mr13392293eaf.1.1764576583606; Mon, 01 Dec 2025
 00:09:43 -0800 (PST)
Precedence: bulk
X-Mailing-List: syzbot@lists.linux.dev
List-Id: <syzbot.lists.linux.dev>
List-Subscribe: <mailto:syzbot+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:syzbot+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <692ce49c.a70a0220.2ea503.00aa.GAE@google.com>
In-Reply-To: <692ce49c.a70a0220.2ea503.00aa.GAE@google.com>
From: Aleksandr Nogikh <nogikh@google.com>
Date: Mon, 1 Dec 2025 09:09:31 +0100
X-Gm-Features: AWmQ_bl-l1s7zEfuIjliWhEHC4GE_IWvVO8jtRnuWp_zS-bzaXxNR-aFIyEQyuo
Message-ID: <CANp29Y4zVs+72heQprJ2MeSzQX0jskjtX55Bt7f5ygYFVibEGA@mail.gmail.com>
Subject: Re: [moderation/CI] Re: Multi-queue aware sch_cake
To: syzbot ci <syzbot+ci17459ab283a71134@syzkaller.appspotmail.com>
Cc: syzkaller-upstream-moderation@googlegroups.com, syzbot@lists.linux.dev
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

#syz upstream

On Mon, Dec 1, 2025 at 1:43=E2=80=AFAM syzbot ci
<syzbot+ci17459ab283a71134@syzkaller.appspotmail.com> wrote:
>
> syzbot ci has tested the following series
>
> [v3] Multi-queue aware sch_cake
> https://lore.kernel.org/all/20251130-mq-cake-sub-qdisc-v3-0-5f66c548ecdc@=
redhat.com
> * [PATCH net-next v3 1/5] net/sched: Export mq functions for reuse
> * [PATCH net-next v3 2/5] net/sched: sch_cake: Factor out config variable=
s into separate struct
> * [PATCH net-next v3 3/5] net/sched: sch_cake: Add cake_mq qdisc for usin=
g cake on mq devices
> * [PATCH net-next v3 4/5] net/sched: sch_cake: Share config across cake_m=
q sub-qdiscs
> * [PATCH net-next v3 5/5] net/sched: sch_cake: share shaper state across =
sub-instances of cake_mq
>
> and found the following issue:
> general protection fault in cake_destroy
>
> Full report is available here:
> https://ci.syzbot.org/series/469dbe1a-fdda-4481-ae02-4a1ec685d27e
>
> ***
>
> general protection fault in cake_destroy
>
> tree:      net-next
> URL:       https://kernel.googlesource.com/pub/scm/linux/kernel/git/netde=
v/net-next.git
> base:      db4029859d6fd03f0622d394f4cdb1be86d7ec62
> arch:      amd64
> compiler:  Debian clang version 20.1.8 (++20250708063551+0c9f909b7976-1~e=
xp1~20250708183702.136), Debian LLD 20.1.8
> config:    https://ci.syzbot.org/builds/e4777953-23df-407f-8d5c-6b069ad52=
321/config
> C repro:   https://ci.syzbot.org/findings/c250604b-a027-4732-9850-8849950=
3b6a4/c_repro
> syz repro: https://ci.syzbot.org/findings/c250604b-a027-4732-9850-8849950=
3b6a4/syz_repro
>
> netlink: 'syz.0.17': attribute type 9 has an invalid length.
> Oops: general protection fault, probably for non-canonical address 0xdfff=
fc0000000006: 0000 [#1] SMP KASAN PTI
> KASAN: null-ptr-deref in range [0x0000000000000030-0x0000000000000037]
> CPU: 1 UID: 0 PID: 5958 Comm: syz.0.17 Not tainted syzkaller #0 PREEMPT(f=
ull)
> Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS 1.16.2-debian-1.=
16.2-1 04/01/2014
> RIP: 0010:cake_destroy+0x9f/0x100 net/sched/sch_cake.c:2790
> Code: 81 c3 98 02 00 00 48 89 d8 48 c1 e8 03 42 80 3c 38 00 74 08 48 89 d=
f e8 bf 0f c8 f8 48 8b 1b 4c 8d 73 34 4c 89 f0 48 c1 e8 03 <42> 0f b6 04 38=
 84 c0 75 35 41 0f b6 2e 31 ff 89 ee e8 eb 4e 62 f8
> RSP: 0018:ffffc90003247298 EFLAGS: 00010207
> RAX: 0000000000000006 RBX: 0000000000000000 RCX: 13d577b5b867bd00
> RDX: 0000000000000000 RSI: ffffffff8bbf08c0 RDI: ffffffff8bbf0880
> RBP: ffffc90003247410 R08: ffffc9000324727f R09: 0000000000000000
> R10: ffffc90003247260 R11: fffff52000648e50 R12: ffffffff895db710
> R13: 00000000ffffffde R14: 0000000000000034 R15: dffffc0000000000
> FS:  000055555e5bf500(0000) GS:ffff8882a9f31000(0000) knlGS:0000000000000=
000
> CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> CR2: 000055555e5bf808 CR3: 00000001bb50a000 CR4: 00000000000006f0
> Call Trace:
>  <TASK>
>  qdisc_create+0xaa3/0xea0 net/sched/sch_api.c:1353
>  __tc_modify_qdisc net/sched/sch_api.c:1753 [inline]
>  tc_modify_qdisc+0x1547/0x2020 net/sched/sch_api.c:1817
>  rtnetlink_rcv_msg+0x77c/0xb70 net/core/rtnetlink.c:6967
>  netlink_rcv_skb+0x208/0x470 net/netlink/af_netlink.c:2550
>  netlink_unicast_kernel net/netlink/af_netlink.c:1318 [inline]
>  netlink_unicast+0x82f/0x9e0 net/netlink/af_netlink.c:1344
>  netlink_sendmsg+0x805/0xb30 net/netlink/af_netlink.c:1894
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
> RIP: 0033:0x7ff769b8f7c9
> Code: ff ff c3 66 2e 0f 1f 84 00 00 00 00 00 0f 1f 40 00 48 89 f8 48 89 f=
7 48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 ff=
 ff 73 01 c3 48 c7 c1 a8 ff ff ff f7 d8 64 89 01 48
> RSP: 002b:00007ffd59035098 EFLAGS: 00000246 ORIG_RAX: 000000000000002e
> RAX: ffffffffffffffda RBX: 00007ff769de5fa0 RCX: 00007ff769b8f7c9
> RDX: 0000000000000000 RSI: 0000200000000000 RDI: 0000000000000003
> RBP: 00007ff769bf297f R08: 0000000000000000 R09: 0000000000000000
> R10: 0000000000000000 R11: 0000000000000246 R12: 0000000000000000
> R13: 00007ff769de5fa0 R14: 00007ff769de5fa0 R15: 0000000000000003
>  </TASK>
> Modules linked in:
> ---[ end trace 0000000000000000 ]---
> RIP: 0010:cake_destroy+0x9f/0x100 net/sched/sch_cake.c:2790
> Code: 81 c3 98 02 00 00 48 89 d8 48 c1 e8 03 42 80 3c 38 00 74 08 48 89 d=
f e8 bf 0f c8 f8 48 8b 1b 4c 8d 73 34 4c 89 f0 48 c1 e8 03 <42> 0f b6 04 38=
 84 c0 75 35 41 0f b6 2e 31 ff 89 ee e8 eb 4e 62 f8
> RSP: 0018:ffffc90003247298 EFLAGS: 00010207
> RAX: 0000000000000006 RBX: 0000000000000000 RCX: 13d577b5b867bd00
> RDX: 0000000000000000 RSI: ffffffff8bbf08c0 RDI: ffffffff8bbf0880
> RBP: ffffc90003247410 R08: ffffc9000324727f R09: 0000000000000000
> R10: ffffc90003247260 R11: fffff52000648e50 R12: ffffffff895db710
> R13: 00000000ffffffde R14: 0000000000000034 R15: dffffc0000000000
> FS:  000055555e5bf500(0000) GS:ffff8882a9f31000(0000) knlGS:0000000000000=
000
> CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> CR2: 000055555e5bf808 CR3: 00000001bb50a000 CR4: 00000000000006f0
> ----------------
> Code disassembly (best guess):
>    0:   81 c3 98 02 00 00       add    $0x298,%ebx
>    6:   48 89 d8                mov    %rbx,%rax
>    9:   48 c1 e8 03             shr    $0x3,%rax
>    d:   42 80 3c 38 00          cmpb   $0x0,(%rax,%r15,1)
>   12:   74 08                   je     0x1c
>   14:   48 89 df                mov    %rbx,%rdi
>   17:   e8 bf 0f c8 f8          call   0xf8c80fdb
>   1c:   48 8b 1b                mov    (%rbx),%rbx
>   1f:   4c 8d 73 34             lea    0x34(%rbx),%r14
>   23:   4c 89 f0                mov    %r14,%rax
>   26:   48 c1 e8 03             shr    $0x3,%rax
> * 2a:   42 0f b6 04 38          movzbl (%rax,%r15,1),%eax <-- trapping in=
struction
>   2f:   84 c0                   test   %al,%al
>   31:   75 35                   jne    0x68
>   33:   41 0f b6 2e             movzbl (%r14),%ebp
>   37:   31 ff                   xor    %edi,%edi
>   39:   89 ee                   mov    %ebp,%esi
>   3b:   e8 eb 4e 62 f8          call   0xf8624f2b
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
> [cake@lists.bufferbloat.net davem@davemloft.net edumazet@google.com horms=
@kernel.org j.koeppeler@tu-berlin.de jhs@mojatatu.com jiri@resnulli.us kuba=
@kernel.org netdev@vger.kernel.org pabeni@redhat.com toke@redhat.com toke@t=
oke.dk xiyou.wangcong@gmail.com]
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
-upstream-moderation/692ce49c.a70a0220.2ea503.00aa.GAE%40google.com.
