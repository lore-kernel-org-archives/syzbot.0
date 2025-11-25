Received: from mail-ot1-f47.google.com (mail-ot1-f47.google.com [209.85.210.47])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 99B8E2DC769
	for <syzbot@lists.linux.dev>; Tue, 25 Nov 2025 08:44:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.47
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764060293; cv=none; b=OQuW+TZXCdJYQWQ1LDV37SS6u1gmddndOe2A+f3UJ0cyFQs3/vJ/TgCWjF5RM7Nr04PrfRbpO2QT7av6/R01YVsUdMeRVZ8R4utcglu8QGGkf2H2yOj96lsriO4TDzXcDIcCVs3pwU7nzajMxE6xABq/EiKxTDOEtMjmaf47+ig=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764060293; c=relaxed/simple;
	bh=onon+PvA5KstoROETBpPEzFpe2nKpUTpUpCrKx7p3ss=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=A0137oNCud1dyVLOTMtHyJ/BMcFnzMfm8JI7ab7pK+yz4a42XgDAVzpCmW1xx+efzM7bMgI4sv8xRHublapGo2U+UCMIsgPA/lloqh7ncA08QojgmW12qsc4nYkZq5obXc6z/JQXpiuFhWBgv6eDfihsEhNbcqu91GkfMa+duy0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=UxtVCr3K; arc=none smtp.client-ip=209.85.210.47
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="UxtVCr3K"
Received: by mail-ot1-f47.google.com with SMTP id 46e09a7af769-7c701097a75so2329205a34.3
        for <syzbot@lists.linux.dev>; Tue, 25 Nov 2025 00:44:51 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1764060290; x=1764665090; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=fGBQW2dHiHVOdew2Gz8OReYXLZPW9X/+kk4LBuJV9Y4=;
        b=UxtVCr3KK65JJBiR+9/jKSNJmto23DwenFIE9U8gfHkxPnMF0tyOlQainZgkVUl8bO
         ineTqhebwXRmttB9edqyCyF50yxRYtd3Ubc3NAmh0wIjosKm4z9rMU/n9m7+jp0GlLhy
         AhcXUltjPB2x1WIOvlgdJnd1c14fGHDohAmPwwKN6efLcsvmwXMLYxVx8EIwHiyh85Tp
         +wqLBPM3Tyf/i6iG8mYYK9aGw0UiQaJm6TYdrYA1Rvu+YgLAP9UOIS8NCv48kIltkXcP
         BPDzdmIX+tFFPJnTUTcKUfE48NILMWgooeCThYZBg6celimbPnPTcWbL8cP1RxKxmd5Q
         txVA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1764060290; x=1764665090;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=fGBQW2dHiHVOdew2Gz8OReYXLZPW9X/+kk4LBuJV9Y4=;
        b=d2IkJAhXvKd9I+K2GVTsnbUevM2z058xLfGPoZuF4eesotQDtVrLyM6yvh56s3+y7C
         Q1F1YepMrB9AYqiMKi509pxa0z30iL5mldMmnq72a9+qEd0nMiciPMSwQWduddtqN17t
         5RaYhQ0Q3wnGJBEQrirQw8YmIpXe2NR1pEoRp6nxOQHbRceOOy01uJzBs/FcL3951LFt
         zho0VGBWv2kcUok/fQJenCUJKlEdmJwR8Lo1xbmGJ/Z7Rl3RETQ5zfz5EW1lCIMJcdTl
         fUcnHC0QGXZxkkkKsAkj29s/0LNDKh73Lo3/RCbNFQTQn7+sh395pNGlOA14ua50Vgm4
         UrMQ==
X-Forwarded-Encrypted: i=1; AJvYcCU1Kj6pW8DcWTmxIV9QxILlLLMn4L5REtBx3IJ3hnzNhv5zM7gtieHgLkUvw0JhtOL0XVpq5bc=@lists.linux.dev
X-Gm-Message-State: AOJu0YykdKTTBlS7hatlD1qwDacB3TpfSQyYekbBx7TrxOXrPXH++Zef
	vztXku6Ka45vtuJep6XdiYrxwhJXeT7dnu8mYnoZASJQhZor+8kqd/ewlhw1IUTOa+2UCYkQ+Nn
	Tqs+vS10ruxKYbXrs5tG3swBPJ/7wOOYrkhG2W/G6
X-Gm-Gg: ASbGncs5m5AdNgF/jU6YTJ75tKknb2hOBOmSvYOn5RlcWrDW/718gwqWyJbHcn0F6aM
	Tjs5o3WLhSPvAHnAhz7czAUc88i2qr66z7nIS5ZMThVV7DIl+GW/b3jxecwN4pnE/CHn6NX4yK7
	My8W1FJiwVB3RP+tli8glIjCMbSOoyca0ac18PqibVNr04Kp+WfxqAwVFv3P/WfhudOC3PKZyW5
	K9sImSpQjJWGSQ74dtlvjiglhjBpqDa9u2BpO3/qFcmt85MCp8iFRhkUaJVpvZsrQGypS5Vd3qe
	KT3V61GVQoop6hqmAFdSR7L8qYjWLksriVgnsAdCodnu6n3C4Bw3+UQpsg==
X-Google-Smtp-Source: AGHT+IHSaRFz7H3Cs1lw0EcO95+lrZo8xRkJNniaJ2XlLaBqzrMl0/9DKHIgiTyeTY9Akl1kXjo9DPDAqzGXi+NeS9I=
X-Received: by 2002:a05:6830:440d:b0:7b2:aba7:f4e with SMTP id
 46e09a7af769-7c798be2dbfmr8068966a34.10.1764060290376; Tue, 25 Nov 2025
 00:44:50 -0800 (PST)
Precedence: bulk
X-Mailing-List: syzbot@lists.linux.dev
List-Id: <syzbot.lists.linux.dev>
List-Subscribe: <mailto:syzbot+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:syzbot+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <692518b2.a70a0220.d98e3.009a.GAE@google.com>
In-Reply-To: <692518b2.a70a0220.d98e3.009a.GAE@google.com>
From: Aleksandr Nogikh <nogikh@google.com>
Date: Tue, 25 Nov 2025 09:44:35 +0100
X-Gm-Features: AWmQ_bmy7Al-Flx6A71rt3kBmrFRYGLPp1xBDmTje5Ctta2z4fpZ-qJMty1RyDI
Message-ID: <CANp29Y4A21DUOowQ2mAyaz9PYmvaPEav7UmGtxdR4HYJhr1ooQ@mail.gmail.com>
Subject: Re: [moderation/CI] Re: net/sched: Introduce qdisc quirk_chk op
To: syzbot ci <syzbot+ci798f5b5691de2127@syzkaller.appspotmail.com>
Cc: syzkaller-upstream-moderation@googlegroups.com, syzbot@lists.linux.dev
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

#syz upstream

On Tue, Nov 25, 2025 at 3:47=E2=80=AFAM syzbot ci
<syzbot+ci798f5b5691de2127@syzkaller.appspotmail.com> wrote:
>
> syzbot ci has tested the following series
>
> [v1] net/sched: Introduce qdisc quirk_chk op
> https://lore.kernel.org/all/20251124223749.503979-1-victor@mojatatu.com
> * [RFC PATCH net-next] net/sched: Introduce qdisc quirk_chk op
>
> and found the following issue:
> general protection fault in netem_quirk_chk
>
> Full report is available here:
> https://ci.syzbot.org/series/0ba1b5b2-32e5-45b5-9ede-1290a7852d5e
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
> config:    https://ci.syzbot.org/builds/0064d8bc-3c48-4267-9b5e-0f43a8514=
002/config
> C repro:   https://ci.syzbot.org/findings/17d4a158-13d5-439e-8a4d-10e6e40=
a2ab1/c_repro
> syz repro: https://ci.syzbot.org/findings/17d4a158-13d5-439e-8a4d-10e6e40=
a2ab1/syz_repro
>
> netlink: 28 bytes leftover after parsing attributes in process `syz.0.17'=
.
> Oops: general protection fault, probably for non-canonical address 0xdfff=
fc0000000002: 0000 [#1] SMP KASAN PTI
> KASAN: null-ptr-deref in range [0x0000000000000010-0x0000000000000017]
> CPU: 1 UID: 0 PID: 5959 Comm: syz.0.17 Not tainted syzkaller #0 PREEMPT(f=
ull)
> Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS 1.16.2-debian-1.=
16.2-1 04/01/2014
> RIP: 0010:netem_quirk_chk+0x37/0x660 net/sched/sch_netem.c:999
> Code: 53 48 83 ec 30 48 89 54 24 08 49 89 f7 48 89 fd 49 be 00 00 00 00 0=
0 fc ff df e8 e4 68 67 f8 49 83 c7 14 4c 89 f8 48 c1 e8 03 <42> 0f b6 04 30=
 84 c0 0f 85 a0 05 00 00 41 8b 37 31 ff 89 74 24 04
> RSP: 0018:ffffc90003737260 EFLAGS: 00010203
> RAX: 0000000000000002 RBX: dffffc0000000000 RCX: ffff888113168000
> RDX: 0000000000000000 RSI: 0000000000000000 RDI: ffff8881139f3000
> RBP: ffff8881139f3000 R08: ffff888113168000 R09: 0000000000000002
> R10: 00000000fffffff1 R11: ffffffff89589ab0 R12: ffff8881166a0000
> R13: ffffffff89589ab0 R14: dffffc0000000000 R15: 0000000000000014
> FS:  0000555559c83500(0000) GS:ffff8882a9f35000(0000) knlGS:0000000000000=
000
> CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> CR2: 0000200000000100 CR3: 000000010a1b0000 CR4: 00000000000006f0
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
> RIP: 0033:0x7fe6bff8f749
> Code: ff ff c3 66 2e 0f 1f 84 00 00 00 00 00 0f 1f 40 00 48 89 f8 48 89 f=
7 48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 ff=
 ff 73 01 c3 48 c7 c1 a8 ff ff ff f7 d8 64 89 01 48
> RSP: 002b:00007fff10f91288 EFLAGS: 00000246 ORIG_RAX: 000000000000002e
> RAX: ffffffffffffffda RBX: 00007fe6c01e5fa0 RCX: 00007fe6bff8f749
> RDX: 0000000000000000 RSI: 0000200000000000 RDI: 0000000000000003
> RBP: 00007fe6c0013f91 R08: 0000000000000000 R09: 0000000000000000
> R10: 0000000000000000 R11: 0000000000000246 R12: 0000000000000000
> R13: 00007fe6c01e5fa0 R14: 00007fe6c01e5fa0 R15: 0000000000000003
>  </TASK>
> Modules linked in:
> ---[ end trace 0000000000000000 ]---
> RIP: 0010:netem_quirk_chk+0x37/0x660 net/sched/sch_netem.c:999
> Code: 53 48 83 ec 30 48 89 54 24 08 49 89 f7 48 89 fd 49 be 00 00 00 00 0=
0 fc ff df e8 e4 68 67 f8 49 83 c7 14 4c 89 f8 48 c1 e8 03 <42> 0f b6 04 30=
 84 c0 0f 85 a0 05 00 00 41 8b 37 31 ff 89 74 24 04
> RSP: 0018:ffffc90003737260 EFLAGS: 00010203
> RAX: 0000000000000002 RBX: dffffc0000000000 RCX: ffff888113168000
> RDX: 0000000000000000 RSI: 0000000000000000 RDI: ffff8881139f3000
> RBP: ffff8881139f3000 R08: ffff888113168000 R09: 0000000000000002
> R10: 00000000fffffff1 R11: ffffffff89589ab0 R12: ffff8881166a0000
> R13: ffffffff89589ab0 R14: dffffc0000000000 R15: 0000000000000014
> FS:  0000555559c83500(0000) GS:ffff8882a9f35000(0000) knlGS:0000000000000=
000
> CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> CR2: 0000200000000100 CR3: 000000010a1b0000 CR4: 00000000000006f0
> ----------------
> Code disassembly (best guess):
>    0:   53                      push   %rbx
>    1:   48 83 ec 30             sub    $0x30,%rsp
>    5:   48 89 54 24 08          mov    %rdx,0x8(%rsp)
>    a:   49 89 f7                mov    %rsi,%r15
>    d:   48 89 fd                mov    %rdi,%rbp
>   10:   49 be 00 00 00 00 00    movabs $0xdffffc0000000000,%r14
>   17:   fc ff df
>   1a:   e8 e4 68 67 f8          call   0xf8676903
>   1f:   49 83 c7 14             add    $0x14,%r15
>   23:   4c 89 f8                mov    %r15,%rax
>   26:   48 c1 e8 03             shr    $0x3,%rax
> * 2a:   42 0f b6 04 30          movzbl (%rax,%r14,1),%eax <-- trapping in=
struction
>   2f:   84 c0                   test   %al,%al
>   31:   0f 85 a0 05 00 00       jne    0x5d7
>   37:   41 8b 37                mov    (%r15),%esi
>   3a:   31 ff                   xor    %edi,%edi
>   3c:   89 74 24 04             mov    %esi,0x4(%rsp)
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
> [davem@davemloft.net edumazet@google.com jhs@mojatatu.com jiri@resnulli.u=
s kuba@kernel.org netdev@vger.kernel.org pabeni@redhat.com victor@mojatatu.=
com xiyou.wangcong@gmail.com]
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
-upstream-moderation/692518b2.a70a0220.d98e3.009a.GAE%40google.com.
