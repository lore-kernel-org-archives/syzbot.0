Received: from mail-oo1-f46.google.com (mail-oo1-f46.google.com [209.85.161.46])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0A7752D23B8
	for <syzbot@lists.linux.dev>; Wed, 26 Nov 2025 08:13:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.161.46
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764144811; cv=none; b=ApKl2WZp4OqlOkhaBGjuJxHymkH1rKejGuYqmrshs0y/XUsJITXvzlYvH44qh3c/pox4syZnbQUrzlpDzchZw+dsqmmPueoA+p9ZlTiS8VJu7cV+gacB+Tko9O7AC1F5OSmc3L3qgtqSxX3jIqXxZ+gdqRTmcfDItnjNU0pOM3o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764144811; c=relaxed/simple;
	bh=pf/DLEIc+pwRijNVdOGAOk/xaH1//VpDh5QNv7G8Cg8=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=Bt7n9WQgJtzSCk1cSgN2gf5/tydeqcoMtsLYxTl734hG2Tn6wUFE2JBh/XUM7W9uKJg/WvIi1eoOan9a2UznIgZJqVBasMoC5HWi6kNVLvsOnL6077xxjc2rh1NF5NyRk48BRo+WtacJMQlRE3WiCergf0hcH+ZZfn8G3Fvw8ok=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=iFxI5t+B; arc=none smtp.client-ip=209.85.161.46
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="iFxI5t+B"
Received: by mail-oo1-f46.google.com with SMTP id 006d021491bc7-656b52c0f88so2526765eaf.0
        for <syzbot@lists.linux.dev>; Wed, 26 Nov 2025 00:13:29 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1764144809; x=1764749609; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=uQv7+hAzkr/eMcB2vNXRFXE9iNJnWZsKWLNMbPm1F0I=;
        b=iFxI5t+BcrXdf1u2AfQDsquA7uugR9cVLIEt+BboBI3VJ2g7ORH+wGxCppSVN/SKhO
         m/806LGKkVi0ID3z5rZMQa4MFeC3aNk/xfM38wHUZmeI2sz5rU2fKeaiVAN82y+U55/y
         BWvhkL/qs4BZz6bU3f9FkmP1/yoP+0sINDBbapClLF93j9D2G+TkIzs81bX6lJdRgzRG
         TnhHtJjrKjSpSY3OtBojTZnzLWFpoW+mUM+885z44kIsCO7DYUCu1RZCk5hpYPErfywb
         5btGfNC7NnfHzR95d6Oh+aDCKAdgT21DsnHx51x52nDNOyPGzx9z8CWSRxcOgnNOOTbM
         aMMA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1764144809; x=1764749609;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=uQv7+hAzkr/eMcB2vNXRFXE9iNJnWZsKWLNMbPm1F0I=;
        b=YYuAu2VvVHZiqk3m6k8Unxmw2FNoV4b+wztDgEoq8w6hk9dl9t4aRiIps0lMydL2Z4
         oDh1wH4g13BcBcqMBrpE3CqtgNZjpEVXDKLqczEabc17VeiecRLXmwAI2JEcndbHYXgD
         DsYYkw3+Q/I9TP8ytA4gEU9fSL/EtTGt72SthhdBVUbGjrl/ue59iFg5rE2bDwREZS17
         cItan6LfO7ynpX7Q45A09moGuQbO7ASadMKOFumfUIm3c+1SByJsY7B+mtPSuEAxbn7R
         g5Popo8WsEfv+G0H5LDDD+FT2ml8mWaE0l90UJN4KxEdznxhWUDkPEA4zhueS9SacDdx
         oVEQ==
X-Forwarded-Encrypted: i=1; AJvYcCW8ko/h5Ap8+APlN94ByzLFTTyLjy0EgbI5tb0V8OQluj4mFEb3+XF6udX643WCBixRjOcnvqg=@lists.linux.dev
X-Gm-Message-State: AOJu0Yx4SstOTjeo0mSKI2k8emzyJagzni7n/d943oE2bepe2JexG/Ws
	mUeqo099wGMXdyy+24gRrHfJ02PvpbqChEbXrYB+oLQpS1qiYo1aKCt9a8swDRBkyGc/NfAGYXL
	XTcANKqFQA1lyQUkjkqTlZzRiOVUhROt230/NBFrS
X-Gm-Gg: ASbGncvSFibm5uvDwwKz02KZq46MGyUqVeSxs6jYSecWyogO13T5sb1YSh44q20WcOK
	jE9JV+EOv22C5zt1nacJgc9t/TcKyNQ4epDz6oIPK80Z/3dNZhi+DY9rmAhmv4ISBOMvY3Yj348
	Ho06Nbjpaf63c5fvp1YvIVRvkO91f/7fiAcL92KGNtOL6Wba1FB+WhHLMBVZilNtXG7rWUJEpht
	SfJka1I0uc8FW+Dqr8WDuYc5y7Hq5KK68YHFNdNV7eGRyD0EYS4Z6bWP/8gPwcfWLiB/2nBgrdv
	g9wGIVFhWSLueTYbpHeRpWkNigkavOFNQ6p3Gf5nHVBDJxkITXv74dOkyg==
X-Google-Smtp-Source: AGHT+IGfdXZYezC4R1wPPXcRSnS9NltPVKS94xEQtAoPDIFqR7xqfZ57BAD4lS2S801WmtSojcfbChDacFkf3e9fWc4=
X-Received: by 2002:a05:6820:2982:b0:657:60b8:b07c with SMTP id
 006d021491bc7-657bdae7b8bmr1830988eaf.2.1764144808867; Wed, 26 Nov 2025
 00:13:28 -0800 (PST)
Precedence: bulk
X-Mailing-List: syzbot@lists.linux.dev
List-Id: <syzbot.lists.linux.dev>
List-Subscribe: <mailto:syzbot+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:syzbot+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <69268031.a70a0220.d98e3.00c9.GAE@google.com>
In-Reply-To: <69268031.a70a0220.d98e3.00c9.GAE@google.com>
From: Aleksandr Nogikh <nogikh@google.com>
Date: Wed, 26 Nov 2025 09:13:17 +0100
X-Gm-Features: AWmQ_bmVcxKGNexzolmyPU9ndvAahBYE6p4ZeeUja5_9tjR5HhShnq4JKiiDFRI
Message-ID: <CANp29Y57JW-XeYOOo0r=pa_dOoSRCieHf6Va0T44zEah7W4H2Q@mail.gmail.com>
Subject: Re: [moderation/CI] Re: net/sched: Introduce qdisc quirk_chk op
To: syzbot ci <syzbot+cie1cc744dda2cfc97@syzkaller.appspotmail.com>
Cc: syzkaller-upstream-moderation@googlegroups.com, syzbot@lists.linux.dev
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

#syz upstream

On Wed, Nov 26, 2025 at 5:21=E2=80=AFAM syzbot ci
<syzbot+cie1cc744dda2cfc97@syzkaller.appspotmail.com> wrote:
>
> syzbot ci has tested the following series
>
> [v2] net/sched: Introduce qdisc quirk_chk op
> https://lore.kernel.org/all/20251125224604.872351-1-victor@mojatatu.com
> * [RFC PATCH net-next v2] net/sched: Introduce qdisc quirk_chk op
>
> and found the following issue:
> general protection fault in netem_quirk_chk
>
> Full report is available here:
> https://ci.syzbot.org/series/aa7207e5-00c6-4c9d-b330-9b2041104daf
>
> ***
>
> general protection fault in netem_quirk_chk
>
> tree:      net-next
> URL:       https://kernel.googlesource.com/pub/scm/linux/kernel/git/netde=
v/net-next.git
> base:      e2c20036a8879476c88002730d8a27f4e3c32d4b
> arch:      amd64
> compiler:  Debian clang version 20.1.8 (++20250708063551+0c9f909b7976-1~e=
xp1~20250708183702.136), Debian LLD 20.1.8
> config:    https://ci.syzbot.org/builds/bbda2e20-2099-41bd-a7d4-c298c61ed=
2f5/config
> C repro:   https://ci.syzbot.org/findings/21f8d5f6-c5af-4e81-a8d5-56f5feb=
d6f03/c_repro
> syz repro: https://ci.syzbot.org/findings/21f8d5f6-c5af-4e81-a8d5-56f5feb=
d6f03/syz_repro
>
> netlink: 28 bytes leftover after parsing attributes in process `syz.0.17'=
.
> Oops: general protection fault, probably for non-canonical address 0xdfff=
fc0000000000: 0000 [#1] SMP KASAN PTI
> KASAN: null-ptr-deref in range [0x0000000000000000-0x0000000000000007]
> CPU: 1 UID: 0 PID: 5961 Comm: syz.0.17 Not tainted syzkaller #0 PREEMPT(f=
ull)
> Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS 1.16.2-debian-1.=
16.2-1 04/01/2014
> RIP: 0010:nla_len include/net/netlink.h:1296 [inline]
> RIP: 0010:parse_attr net/sched/sch_netem.c:960 [inline]
> RIP: 0010:netem_quirk_chk+0x8a/0x740 net/sched/sch_netem.c:990
> Code: 7c 24 60 49 c1 ef 03 43 c7 04 27 f1 f1 f1 f1 43 c7 44 27 13 f3 f3 f=
3 f3 43 c6 44 27 17 f3 e8 8d 68 67 f8 48 89 d8 48 c1 e8 03 <42> 0f b6 04 20=
 84 c0 0f 85 32 06 00 00 0f b7 03 83 c0 fc 44 0f b7
> RSP: 0018:ffffc900032c7140 EFLAGS: 00010246
> RAX: 0000000000000000 RBX: 0000000000000000 RCX: ffff88810ff73a00
> RDX: 0000000000000000 RSI: 0000000000000000 RDI: ffff8881b82ce000
> RBP: ffffc900032c72b8 R08: ffff88810ff73a00 R09: 0000000000000002
> R10: 00000000fffffff1 R11: ffffffff89589ab0 R12: dffffc0000000000
> R13: ffffffff89589ab0 R14: ffffffff8f7d9580 R15: 1ffff92000658e34
> FS:  000055558efa7500(0000) GS:ffff8882a9f35000(0000) knlGS:0000000000000=
000
> CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> CR2: 0000200000000100 CR3: 0000000114760000 CR4: 00000000000006f0
> Call Trace:
>  <TASK>
>  qdisc_create+0x73f/0xf10 net/sched/sch_api.c:1319
>  __tc_modify_qdisc net/sched/sch_api.c:1765 [inline]
>  tc_modify_qdisc+0x1582/0x2140 net/sched/sch_api.c:1829
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
> RIP: 0033:0x7f1beb98f749
> Code: ff ff c3 66 2e 0f 1f 84 00 00 00 00 00 0f 1f 40 00 48 89 f8 48 89 f=
7 48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 ff=
 ff 73 01 c3 48 c7 c1 a8 ff ff ff f7 d8 64 89 01 48
> RSP: 002b:00007ffd1afcc778 EFLAGS: 00000246 ORIG_RAX: 000000000000002e
> RAX: ffffffffffffffda RBX: 00007f1bebbe5fa0 RCX: 00007f1beb98f749
> RDX: 0000000000000000 RSI: 0000200000000000 RDI: 0000000000000003
> RBP: 00007f1beba13f91 R08: 0000000000000000 R09: 0000000000000000
> R10: 0000000000000000 R11: 0000000000000246 R12: 0000000000000000
> R13: 00007f1bebbe5fa0 R14: 00007f1bebbe5fa0 R15: 0000000000000003
>  </TASK>
> Modules linked in:
> ---[ end trace 0000000000000000 ]---
> RIP: 0010:nla_len include/net/netlink.h:1296 [inline]
> RIP: 0010:parse_attr net/sched/sch_netem.c:960 [inline]
> RIP: 0010:netem_quirk_chk+0x8a/0x740 net/sched/sch_netem.c:990
> Code: 7c 24 60 49 c1 ef 03 43 c7 04 27 f1 f1 f1 f1 43 c7 44 27 13 f3 f3 f=
3 f3 43 c6 44 27 17 f3 e8 8d 68 67 f8 48 89 d8 48 c1 e8 03 <42> 0f b6 04 20=
 84 c0 0f 85 32 06 00 00 0f b7 03 83 c0 fc 44 0f b7
> RSP: 0018:ffffc900032c7140 EFLAGS: 00010246
> RAX: 0000000000000000 RBX: 0000000000000000 RCX: ffff88810ff73a00
> RDX: 0000000000000000 RSI: 0000000000000000 RDI: ffff8881b82ce000
> RBP: ffffc900032c72b8 R08: ffff88810ff73a00 R09: 0000000000000002
> R10: 00000000fffffff1 R11: ffffffff89589ab0 R12: dffffc0000000000
> R13: ffffffff89589ab0 R14: ffffffff8f7d9580 R15: 1ffff92000658e34
> FS:  000055558efa7500(0000) GS:ffff8882a9f35000(0000) knlGS:0000000000000=
000
> CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> CR2: 0000200000000100 CR3: 0000000114760000 CR4: 00000000000006f0
> ----------------
> Code disassembly (best guess), 1 bytes skipped:
>    0:   24 60                   and    $0x60,%al
>    2:   49 c1 ef 03             shr    $0x3,%r15
>    6:   43 c7 04 27 f1 f1 f1    movl   $0xf1f1f1f1,(%r15,%r12,1)
>    d:   f1
>    e:   43 c7 44 27 13 f3 f3    movl   $0xf3f3f3f3,0x13(%r15,%r12,1)
>   15:   f3 f3
>   17:   43 c6 44 27 17 f3       movb   $0xf3,0x17(%r15,%r12,1)
>   1d:   e8 8d 68 67 f8          call   0xf86768af
>   22:   48 89 d8                mov    %rbx,%rax
>   25:   48 c1 e8 03             shr    $0x3,%rax
> * 29:   42 0f b6 04 20          movzbl (%rax,%r12,1),%eax <-- trapping in=
struction
>   2e:   84 c0                   test   %al,%al
>   30:   0f 85 32 06 00 00       jne    0x668
>   36:   0f b7 03                movzwl (%rbx),%eax
>   39:   83 c0 fc                add    $0xfffffffc,%eax
>   3c:   44                      rex.R
>   3d:   0f                      .byte 0xf
>   3e:   b7                      .byte 0xb7
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
> [davem@davemloft.net edumazet@google.com horms@kernel.org jhs@mojatatu.co=
m jiri@resnulli.us kuba@kernel.org netdev@vger.kernel.org pabeni@redhat.com=
 stephen@networkplumber.org victor@mojatatu.com xiyou.wangcong@gmail.com]
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
-upstream-moderation/69268031.a70a0220.d98e3.00c9.GAE%40google.com.
