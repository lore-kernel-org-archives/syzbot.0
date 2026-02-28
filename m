Received: from mail-ed1-f48.google.com (mail-ed1-f48.google.com [209.85.208.48])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0425D2D8DD0
	for <syzbot@lists.linux.dev>; Sat, 28 Feb 2026 22:10:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.208.48
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772316636; cv=pass; b=UvFS4XfPpD0Hs7C98cGa0ipRrQC5x2oI3Av+vgHRpNM3OGCRQICr/IFC0QDZ2YBaacNWaI5zQRRr6l1bmQx4KzyPu1H6cs6byDFxTeEtkb8nGGrkAZcZl0Ke7WZWpcrADtMenX0FjvZ1Sy0yt8FBlH44k3lg2kU62ylwPly5vek=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772316636; c=relaxed/simple;
	bh=TtOQWg2x/fiE7QmARNh/JMzpGT9T00CJdr5Iy0Vd+g4=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=lECEiO6j4edEVRZmxFfKJ2aqDpFOFB2J2U6Y3FfbKE2KNxdWlZhHg+Rz04uGD7L6Qu5Z4Rqn3sR47uRMtaZiDF9OjjO4LdqidGO9vFISLmYNloFoNsU/QnggbSGAXGZmVy99hwBq+fLzxelVq/ahBiGMcP0RqtGf502z1/OW6YQ=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=2N4Koicf; arc=pass smtp.client-ip=209.85.208.48
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="2N4Koicf"
Received: by mail-ed1-f48.google.com with SMTP id 4fb4d7f45d1cf-65faaa8b807so5948962a12.3
        for <syzbot@lists.linux.dev>; Sat, 28 Feb 2026 14:10:34 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1772316633; cv=none;
        d=google.com; s=arc-20240605;
        b=grwIideaGe6gKW9cxv7HcSmWaPS/CWDjJ5hO+fk/rLEyJdkouYwHfU6rBtO4ulNquc
         ETOqBGwQe28EfmJQWF9QU5hFe4tfkuL458bWsw6OG5RYlbiDa0B++s72maNizIlfGTFp
         OhfS3ZXFrFWYevqj5YpTBn2wPc0MGGWRgKSiNlZYkgGQ3lhWuRhlAHlH64+etNJmfdJ2
         1lZkoRmhoZDrXl6gVdi/ZnMklTvZG35owSaoD6fAVOXSlxBaYAsemgMhSIyAkGEhzzf6
         2R52eY0jB+p0bsHlNdRp7OECGztz5udPixgDuPj3j2IaSj5E555P1BU0bqPfazpSlOV2
         lDdw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=UoszPRPEX9At8aWZONNgM0yY3uQPtrK1r7ntE2XX5o4=;
        fh=e4aMfxlJDLAJ3linThOfCy4TuP5MNk1MPLbWwxuXPQM=;
        b=XhiXvQ4G+O7KxefTvXz0fEXBxAYZNofg8kuCFlqTCW9du/UwjKc3FjCsucaQ0i6A6Q
         IAaSf84z0RVUkQE0MZmyYVDu64F4Qv/2BHHbbZd9MGEafupEAs70oyfgZLRB1U9dLFbB
         7iVrN7Q7JrVqPcgl0NNKG6upN6BKh46gp/iJF4MpGqNzvGn+e9BcF30C/8MdqyMCtAQM
         R0EXK367sGfhvqm7rxcrCvXv8ep5eE6j7uxU5vDh8TeNbm3Ng0oKd3aq3yNDZFyhPpHG
         MBPNNnEuPqtkaJeXC8faZW6bx3syG/GLkp3xfrOMDCiwQzTnqT9j0CMqEUV2P/J9cbMX
         ea3Q==;
        darn=lists.linux.dev
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1772316633; x=1772921433; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=UoszPRPEX9At8aWZONNgM0yY3uQPtrK1r7ntE2XX5o4=;
        b=2N4Koicf+IqSvdRelSsyoB0AKelgMcPfAxxWwKIBWj752aU08mwZwVU53nJioVxqpo
         xzW3MYCZz9p3JKmvAzWHlYkS9ywoowuF5RO4adJyn1icuFOLoAMz8Hq+/kXZvYkZfzzk
         IjQ6kXv8d42kGQO8Y+oIDd8YQB4XlxySiiYgCsWKOJXZPPzPlw5OREVYzCjSeD1+BJ3x
         /hhGXINW/9DeOLNx1BcxWE9gC8fIr3R1u0imWoY6JbMrc+E4fbGyNq+7/BiDZiq1McJm
         DKqtJg4K2iSQq1/hvZ+pzHPyt/W3kBEFg9iE1z3Zz/pIRhilJJCBcUYxWo8VBpUPr8mt
         t/Pg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1772316633; x=1772921433;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=UoszPRPEX9At8aWZONNgM0yY3uQPtrK1r7ntE2XX5o4=;
        b=qHjYqRkVxRGDarUNfooDjTBpS94QTsPMDt4pk8zBCnjaTVriFJ54ILq7ulIACycfWz
         CXp6K3m1FdsAWimaJ5fpHZuV8jH8tfrG+4PTGWRQRvlK/HVo4Ed8sfSRVkfok4eKItIK
         iom2WJjPcXfiSl5hSs50picuSaxsBYJScLnNB9DsBvBixEIUyumbJ1vCv2ECcNact6Fu
         6HvT8Y+iFNxIvQZWfcBuNRW6kjRHmcptqiK8kwSINAIfUA9ECFLPyTEXF3N7OeUKleaD
         pwGmQS1KtxwXqHC/7Fy9hpGEDIR0BLGnhn9I7+Pe2PzN4YmNMD7feIL4nR3tMbfKgwMD
         zJjQ==
X-Forwarded-Encrypted: i=1; AJvYcCVkUuJK8xpW0rkHRK120VsmJPAJGKTIA31AclZ5IrKtjaFVT8Jgv6loJQARCw0g6E9EC4a8ydY=@lists.linux.dev
X-Gm-Message-State: AOJu0Yxn2YkDiLA3QM8+mxjo326EuaPIRtho5lHSmzPhR6rT/oCs+4b1
	bWiDOrj4m6mmBu5dZZs9z1qXy1Jqno8e+Q1uESfn9Mjdayuh8SP0h9Sxmc0hV9hbXA6J5CeUzAE
	jyQkDYbUQ9V5vuISrZFBp5kWT8lxYyTE2zeYK7CaA
X-Gm-Gg: ATEYQzxvcKm8KXzMQpc25VkweMFFO2/EaB6FfmPwt+ilkLUpaWHPzOfP1IrSOdMX95m
	g5iag5aT/ui7yFLjgg7NTkl+H6AmDGJ7EKP6Yhgkiu6NT0Y7FaY1BOqllSRi35zju8ZqmNTcGhP
	8XizlSfmVhOkmF3lytXauPpCj5srNP1tPF+O7uoFMfidXfoMkLCjbze1jdgnt7LUriqX+8khJw+
	0U9/MF0sF8JPyYh19WgCONuv3Xz0rSErBY/WJmKniyfX9olIIwvSAZYnSaBX5f161EvjHDkeR3b
	aEOyom1cv+A2af42XIjFhd7N+lGnjF9Y+UfYe7aFsH7k1GkDkIeWGHFaDCxouPWwcK7XZTJc
X-Received: by 2002:a05:6402:2355:b0:65c:2af1:b7c1 with SMTP id
 4fb4d7f45d1cf-65fde2cfe05mr4762353a12.28.1772316632932; Sat, 28 Feb 2026
 14:10:32 -0800 (PST)
Precedence: bulk
X-Mailing-List: syzbot@lists.linux.dev
List-Id: <syzbot.lists.linux.dev>
List-Subscribe: <mailto:syzbot+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:syzbot+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <69a364cc.050a0220.16a3f7.0001.GAE@google.com>
In-Reply-To: <69a364cc.050a0220.16a3f7.0001.GAE@google.com>
From: Aleksandr Nogikh <nogikh@google.com>
Date: Sat, 28 Feb 2026 23:10:22 +0100
X-Gm-Features: AaiRm50D9zFlt1YQYX0lbNoopNIpsbIodMieorIyFx9KsJkMvFPRUlkCIQtIVWo
Message-ID: <CANp29Y5ysaM2xw=t9-n+dLEuEmSfZXR8eKtgNPd0WHDKj10qow@mail.gmail.com>
Subject: Re: [moderation/CI] Re: l2tp: account for IP version in SKB headroom
To: syzbot ci <syzbot+cia4ddb31e96fbf841@syzkaller.appspotmail.com>
Cc: syzkaller-upstream-moderation@googlegroups.com, syzbot@lists.linux.dev
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

#syz upstream

On Sat, Feb 28, 2026 at 10:57=E2=80=AFPM syzbot ci
<syzbot+cia4ddb31e96fbf841@syzkaller.appspotmail.com> wrote:
>
> syzbot ci has tested the following series
>
> [v1] l2tp: account for IP version in SKB headroom
> https://lore.kernel.org/all/20260227220740.11928-1-mail@david-bauer.net
> * [PATCH net-next 1/2] l2tp: account for IP version in SKB headroom
> * [PATCH net-next 2/2] l2tp: unify headroom calculation
>
> and found the following issue:
> general protection fault in l2tp_eth_create
>
> Full report is available here:
> https://ci.syzbot.org/series/10f6234e-88a0-41c8-b9d2-a3e54f289fbd
>
> ***
>
> general protection fault in l2tp_eth_create
>
> tree:      net-next
> URL:       https://kernel.googlesource.com/pub/scm/linux/kernel/git/netde=
v/net-next.git
> base:      58e443b773ef054ae069cf777ba19adb99d73829
> arch:      amd64
> compiler:  Debian clang version 21.1.8 (++20251221033036+2078da43e25a-1~e=
xp1~20251221153213.50), Debian LLD 21.1.8
> config:    https://ci.syzbot.org/builds/66fb3a44-8edb-4c92-9149-328653e46=
ccd/config
> C repro:   https://ci.syzbot.org/findings/9b3d30fe-b87f-4b00-99a6-464f0a2=
71312/c_repro
> syz repro: https://ci.syzbot.org/findings/9b3d30fe-b87f-4b00-99a6-464f0a2=
71312/syz_repro
>
> netlink: 8 bytes leftover after parsing attributes in process `syz.0.17'.
> Oops: general protection fault, probably for non-canonical address 0xdfff=
fc0000000012: 0000 [#1] SMP KASAN PTI
> KASAN: null-ptr-deref in range [0x0000000000000090-0x0000000000000097]
> CPU: 1 UID: 0 PID: 5971 Comm: syz.0.17 Not tainted syzkaller #0 PREEMPT(f=
ull)
> Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS 1.16.2-debian-1.=
16.2-1 04/01/2014
> RIP: 0010:l2tp_session_udp_hdrlen net/l2tp/l2tp_core.h:340 [inline]
> RIP: 0010:l2tp_session_overhead net/l2tp/l2tp_core.h:346 [inline]
> RIP: 0010:l2tp_eth_adjust_mtu net/l2tp/l2tp_eth.c:202 [inline]
> RIP: 0010:l2tp_eth_create+0x2cd/0xca0 net/l2tp/l2tp_eth.c:250
> Code: 48 89 44 24 58 42 80 3c 28 00 74 08 48 89 df e8 b9 68 54 f7 48 89 5=
c 24 60 4c 8b 33 4d 8d a6 94 00 00 00 4c 89 e0 48 c1 e8 03 <42> 0f b6 04 28=
 84 c0 0f 85 35 08 00 00 45 8b 24 24 31 ff 44 89 e6
> RSP: 0018:ffffc900040c7160 EFLAGS: 00010207
> RAX: 0000000000000012 RBX: ffff888114d00020 RCX: 0000000000000000
> RDX: ffff888104f90000 RSI: 0000000000000028 RDI: 0000000000000000
> RBP: ffffc900040c7270 R08: 0000000000400dc0 R09: 00000000ffffffff
> R10: dffffc0000000000 R11: fffffbfff2022f77 R12: 0000000000000094
> R13: dffffc0000000000 R14: 0000000000000000 R15: ffff888114d00000
> FS:  0000555574b08500(0000) GS:ffff8882a9467000(0000) knlGS:0000000000000=
000
> CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> CR2: 000055a269259270 CR3: 0000000105770000 CR4: 00000000000006f0
> Call Trace:
>  <TASK>
>  l2tp_nl_cmd_session_create+0x766/0xc60 net/l2tp/l2tp_netlink.c:639
>  genl_family_rcv_msg_doit+0x22a/0x330 net/netlink/genetlink.c:1114
>  genl_family_rcv_msg net/netlink/genetlink.c:1194 [inline]
>  genl_rcv_msg+0x61c/0x7a0 net/netlink/genetlink.c:1209
>  netlink_rcv_skb+0x232/0x4b0 net/netlink/af_netlink.c:2550
>  genl_rcv+0x28/0x40 net/netlink/genetlink.c:1218
>  netlink_unicast_kernel net/netlink/af_netlink.c:1318 [inline]
>  netlink_unicast+0x80f/0x9b0 net/netlink/af_netlink.c:1344
>  netlink_sendmsg+0x813/0xb40 net/netlink/af_netlink.c:1894
>  sock_sendmsg_nosec net/socket.c:727 [inline]
>  __sock_sendmsg net/socket.c:742 [inline]
>  ____sys_sendmsg+0xa68/0xad0 net/socket.c:2592
>  ___sys_sendmsg+0x2a5/0x360 net/socket.c:2646
>  __sys_sendmsg net/socket.c:2678 [inline]
>  __do_sys_sendmsg net/socket.c:2683 [inline]
>  __se_sys_sendmsg net/socket.c:2681 [inline]
>  __x64_sys_sendmsg+0x1bd/0x2a0 net/socket.c:2681
>  do_syscall_x64 arch/x86/entry/syscall_64.c:63 [inline]
>  do_syscall_64+0x14d/0xf80 arch/x86/entry/syscall_64.c:94
>  entry_SYSCALL_64_after_hwframe+0x77/0x7f
> RIP: 0033:0x7f371079c799
> Code: ff c3 66 2e 0f 1f 84 00 00 00 00 00 0f 1f 44 00 00 48 89 f8 48 89 f=
7 48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 ff=
 ff 73 01 c3 48 c7 c1 e8 ff ff ff f7 d8 64 89 01 48
> RSP: 002b:00007fff7e0100f8 EFLAGS: 00000246 ORIG_RAX: 000000000000002e
> RAX: ffffffffffffffda RBX: 00007f3710a15fa0 RCX: 00007f371079c799
> RDX: 0000000020000034 RSI: 0000200000000140 RDI: 0000000000000005
> RBP: 00007f3710832bd9 R08: 0000000000000000 R09: 0000000000000000
> R10: 0000000000000000 R11: 0000000000000246 R12: 0000000000000000
> R13: 00007f3710a15fac R14: 00007f3710a15fa0 R15: 00007f3710a15fa0
>  </TASK>
> Modules linked in:
> ---[ end trace 0000000000000000 ]---
> RIP: 0010:l2tp_session_udp_hdrlen net/l2tp/l2tp_core.h:340 [inline]
> RIP: 0010:l2tp_session_overhead net/l2tp/l2tp_core.h:346 [inline]
> RIP: 0010:l2tp_eth_adjust_mtu net/l2tp/l2tp_eth.c:202 [inline]
> RIP: 0010:l2tp_eth_create+0x2cd/0xca0 net/l2tp/l2tp_eth.c:250
> Code: 48 89 44 24 58 42 80 3c 28 00 74 08 48 89 df e8 b9 68 54 f7 48 89 5=
c 24 60 4c 8b 33 4d 8d a6 94 00 00 00 4c 89 e0 48 c1 e8 03 <42> 0f b6 04 28=
 84 c0 0f 85 35 08 00 00 45 8b 24 24 31 ff 44 89 e6
> RSP: 0018:ffffc900040c7160 EFLAGS: 00010207
> RAX: 0000000000000012 RBX: ffff888114d00020 RCX: 0000000000000000
> RDX: ffff888104f90000 RSI: 0000000000000028 RDI: 0000000000000000
> RBP: ffffc900040c7270 R08: 0000000000400dc0 R09: 00000000ffffffff
> R10: dffffc0000000000 R11: fffffbfff2022f77 R12: 0000000000000094
> R13: dffffc0000000000 R14: 0000000000000000 R15: ffff888114d00000
> FS:  0000555574b08500(0000) GS:ffff8882a9467000(0000) knlGS:0000000000000=
000
> CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> CR2: 000055a269259270 CR3: 0000000105770000 CR4: 00000000000006f0
> ----------------
> Code disassembly (best guess):
>    0:   48 89 44 24 58          mov    %rax,0x58(%rsp)
>    5:   42 80 3c 28 00          cmpb   $0x0,(%rax,%r13,1)
>    a:   74 08                   je     0x14
>    c:   48 89 df                mov    %rbx,%rdi
>    f:   e8 b9 68 54 f7          call   0xf75468cd
>   14:   48 89 5c 24 60          mov    %rbx,0x60(%rsp)
>   19:   4c 8b 33                mov    (%rbx),%r14
>   1c:   4d 8d a6 94 00 00 00    lea    0x94(%r14),%r12
>   23:   4c 89 e0                mov    %r12,%rax
>   26:   48 c1 e8 03             shr    $0x3,%rax
> * 2a:   42 0f b6 04 28          movzbl (%rax,%r13,1),%eax <-- trapping in=
struction
>   2f:   84 c0                   test   %al,%al
>   31:   0f 85 35 08 00 00       jne    0x86c
>   37:   45 8b 24 24             mov    (%r12),%r12d
>   3b:   31 ff                   xor    %edi,%edi
>   3d:   44 89 e6                mov    %r12d,%esi
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
> [davem@davemloft.net edumazet@google.com horms@kernel.org kuba@kernel.org=
 linux-kernel@vger.kernel.org mail@david-bauer.net netdev@vger.kernel.org p=
abeni@redhat.com]
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
-upstream-moderation/69a364cc.050a0220.16a3f7.0001.GAE%40google.com.
