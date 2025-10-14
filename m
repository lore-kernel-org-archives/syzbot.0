Received: from mail-ot1-f51.google.com (mail-ot1-f51.google.com [209.85.210.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 76EBD220686
	for <syzbot@lists.linux.dev>; Tue, 14 Oct 2025 10:01:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.51
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760436089; cv=none; b=HRcDlCb6YlnZLQjSLKO6A4v5ZP5yEXHY+ogIfnp7zBy5YemZpj0gqdCnDvq1hH8WBU38gFwspTJmllJv+/AGralDxzIdykoYPru7BlU7Vts/i6mAO6N/j4mhGgmijIYiALJ3ckxCh5+UNYE6oVhB4QpLxzC6/8ccnqPGAWLpbk0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760436089; c=relaxed/simple;
	bh=kOMFoJQDloUZxkQt7GAul1FhNxSjbI/U1l/r+Qo9F7M=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=cFWlbUWCJBKrw9ZK1mMTlAu6n8GHEIaoFRL70G71fvPf5hQv02R90E2fEE81BZifcfnmVpW813f25v6zCtY6a+gXo8Ksccuk941VQk1cyYdiwTW8tuEgZlt9B9uQiX12MX4AnlvwEdRQHKJuNdymKJPUxZcVMBB/2OXpkV9psAA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=x7j2zIuf; arc=none smtp.client-ip=209.85.210.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="x7j2zIuf"
Received: by mail-ot1-f51.google.com with SMTP id 46e09a7af769-79f79e37c04so4004168a34.3
        for <syzbot@lists.linux.dev>; Tue, 14 Oct 2025 03:01:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1760436085; x=1761040885; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=vaF4n8ttbjSbvmMohnm6chf7NJitZ4JJ/Zcc+P1zFac=;
        b=x7j2zIuf0P0d6KC8hN6rT7yjLHmDoMtv1ieRDJrK0G43QEmxGC7fBQEkdNOEFBTpMr
         pECoZGhyd3VBnTaRDdrcp5NnUl5KS1MX8ltLS+J7I+OeaDTrQF3wcjHd2jaURSwE3SFE
         AmFfp28HSgNhWrc177YcO9zDLwKM93HxNs0ZnTV0lAq9D7kuy81SvvI47yOjVgJId2DL
         bQsJaLITMKfx+xVT5bQRUi9K682P/1++P4HCDuiV5Qk80fSnRAKPOpFgPm1r11QGKKE/
         PmJaWb7LxSgZaaWLEIz0sYQ/GyhshVrbRdMd6PkhhobEIShmNK4w2fwBXak127i5J3c1
         a6zA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1760436085; x=1761040885;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=vaF4n8ttbjSbvmMohnm6chf7NJitZ4JJ/Zcc+P1zFac=;
        b=Ux5Sx7Yf/LnxOMWOoD+1ijH4dvXTXyUqJKtITLV9XR9lLuGGBVVKUKMGAtWpRN1r+d
         nW8aSexYd/CAzlaocdsiz2kVzRddCt0tQVwdx7Orjhf1pbfMhk0azoc0i5uq8pkcCDbg
         JuC+H45icJqukRVK2M507/uU+fY5G1yJ60b5TiH+i7oHB6IQoEmn/ANxUXR1leSQB4JX
         AaiKUpUXJQLEaPlzkXmF5a8pOuOeNDO4zwSZ27YwIYv+G6qvEKs8ks6M5cPP/Hx5nhmi
         PWCOpXIEzdNzYoyk35Ve3t4jSpIEaxG2xizKGNr2IsXlIhXuqiJ4hoIGD/NX1v0KiurY
         WqDg==
X-Forwarded-Encrypted: i=1; AJvYcCU7vx6Zg7eVH4K8Pex92/4j9SoUjJAasI/Qa01eOGkEQvCJmlpcfh2SI4uRomyXdlg+/NmzA+s=@lists.linux.dev
X-Gm-Message-State: AOJu0YwiI6r7kP1IBDOhioX8LwIaUGP9f5DAvU57SrRRSRU1q5OoKzPT
	koYbYfd93pWsrxNILGPWbq+XSzs0yYVWPX8B1Yl7dHbBAbyjL6yxTF0rp16aWHNaXRI72vLBuiV
	77yyDuzJk+ezAMXTNO7wL7D/0hz3UoExOw8d6Lx4e
X-Gm-Gg: ASbGncuomMmZ707EZYVzj+1l1gI0UJuE/JW2ULxF4YKDtGY8bNyOH3V99FMGwVsIC55
	vh5GwTwkCgKkvgiHzPAR+ZD3TpsoXnkbV5V1dimJRBRWiUxDq/whzrC8gJVjSq/bTicpmNp/Hiz
	hkw1VgGdSVoWk9zDyWYXMBUYyjq7JGJaNSZsXbPfqwuhDKRcir5yKHORV94ZFZLrQ9H257YvhUa
	yYpW+eHG/PgafxtBt/h6f20c4A2Jqqhd+HXBK0N+lwdO09GXSoU2eqfFkr0em1/pBdt3uDWVw==
X-Google-Smtp-Source: AGHT+IGnEaHJz402JUKOnWEtD7t4MONy842uctcdwoEleN30kdzeRd3noXj4Ds+dxHTwwHf2SCC3148ikRoWlKTa7/4=
X-Received: by 2002:a05:6808:3087:b0:43f:1a5f:2823 with SMTP id
 5614622812f47-4417b3b41femr11207518b6e.26.1760436083582; Tue, 14 Oct 2025
 03:01:23 -0700 (PDT)
Precedence: bulk
X-Mailing-List: syzbot@lists.linux.dev
List-Id: <syzbot.lists.linux.dev>
List-Subscribe: <mailto:syzbot+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:syzbot+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <68ee137a.050a0220.91a22.0202.GAE@google.com>
In-Reply-To: <68ee137a.050a0220.91a22.0202.GAE@google.com>
From: Aleksandr Nogikh <nogikh@google.com>
Date: Tue, 14 Oct 2025 12:01:11 +0200
X-Gm-Features: AS18NWBGTLpLBTohK_XAf1jKyuu_BFnDOEVt-rGajiRZeAtuMehE8wGXEHdVUso
Message-ID: <CANp29Y6k28FxBiAK1guah-61Fq-N50Nps=NRdGfUeXLS3ov_9A@mail.gmail.com>
Subject: Re: [moderation/CI] Re: net/tls: support setting the maximum payload size
To: syzbot ci <syzbot+cie109a12f1eafee2c@syzkaller.appspotmail.com>
Cc: syzkaller-upstream-moderation@googlegroups.com, syzbot@lists.linux.dev
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

#syz upstream

On Tue, Oct 14, 2025 at 11:10=E2=80=AFAM syzbot ci
<syzbot+cie109a12f1eafee2c@syzkaller.appspotmail.com> wrote:
>
> syzbot ci has tested the following series
>
> [v5] net/tls: support setting the maximum payload size
> https://lore.kernel.org/all/20251014051825.1084403-2-wilfred.opensource@g=
mail.com
> * [PATCH net-next v5 1/2] net/tls: support setting the maximum payload si=
ze
> * [PATCH net-next v5 2/2] selftests: tls: add tls record_size_limit test
>
> and found the following issue:
> general protection fault in tls_setsockopt
>
> Full report is available here:
> https://ci.syzbot.org/series/210c88bf-945a-460c-9fe3-c55bd1958b5d
>
> ***
>
> general protection fault in tls_setsockopt
>
> tree:      net-next
> URL:       https://kernel.googlesource.com/pub/scm/linux/kernel/git/netde=
v/net-next.git
> base:      18a7e218cfcdca6666e1f7356533e4c988780b57
> arch:      amd64
> compiler:  Debian clang version 20.1.8 (++20250708063551+0c9f909b7976-1~e=
xp1~20250708183702.136), Debian LLD 20.1.8
> config:    https://ci.syzbot.org/builds/ae03b3d4-e809-4b0e-bd4a-76b4ae8e9=
d74/config
> C repro:   https://ci.syzbot.org/findings/d0b97737-6ea7-4c05-b10b-71dc834=
c9393/c_repro
> syz repro: https://ci.syzbot.org/findings/d0b97737-6ea7-4c05-b10b-71dc834=
c9393/syz_repro
>
> Oops: general protection fault, probably for non-canonical address 0xdfff=
fc0000000023: 0000 [#1] SMP KASAN PTI
> KASAN: null-ptr-deref in range [0x0000000000000118-0x000000000000011f]
> CPU: 1 UID: 0 PID: 5970 Comm: syz.0.17 Not tainted syzkaller #0 PREEMPT(f=
ull)
> Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS 1.16.2-debian-1.=
16.2-1 04/01/2014
> RIP: 0010:do_tls_setsockopt_tx_payload_len net/tls/tls_main.c:847 [inline=
]
> RIP: 0010:do_tls_setsockopt net/tls/tls_main.c:887 [inline]
> RIP: 0010:tls_setsockopt+0x189/0x1590 net/tls/tls_main.c:906
> Code: ff df 80 3c 08 00 74 08 4c 89 ff e8 51 67 3c f8 41 bc 18 01 00 00 4=
d 03 27 4c 89 e0 48 c1 e8 03 49 bf 00 00 00 00 00 fc ff df <42> 80 3c 38 00=
 74 08 4c 89 e7 e8 28 67 3c f8 49 83 3c 24 00 0f 84
> RSP: 0018:ffffc90003e57cc0 EFLAGS: 00010202
> RAX: 0000000000000023 RBX: ffff88816adfcc00 RCX: dffffc0000000000
> RDX: 0000000000000006 RSI: ffffffff8d7e872a RDI: ffffffff8bc074e0
> RBP: ffffc90003e57e38 R08: ffffffff8f9e0f77 R09: 1ffffffff1f3c1ee
> R10: dffffc0000000000 R11: fffffbfff1f3c1ef R12: 0000000000000118
> R13: 1ffff920007cafa4 R14: ffff88816b33bde8 R15: dffffc0000000000
> FS:  00005555585b2500(0000) GS:ffff8882a9d0f000(0000) knlGS:0000000000000=
000
> CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> CR2: 0000200000000180 CR3: 000000010739e000 CR4: 00000000000006f0
> Call Trace:
>  <TASK>
>  do_sock_setsockopt+0x17c/0x1b0 net/socket.c:2360
>  __sys_setsockopt net/socket.c:2385 [inline]
>  __do_sys_setsockopt net/socket.c:2391 [inline]
>  __se_sys_setsockopt net/socket.c:2388 [inline]
>  __x64_sys_setsockopt+0x13f/0x1b0 net/socket.c:2388
>  do_syscall_x64 arch/x86/entry/syscall_64.c:63 [inline]
>  do_syscall_64+0xfa/0xfa0 arch/x86/entry/syscall_64.c:94
>  entry_SYSCALL_64_after_hwframe+0x77/0x7f
> RIP: 0033:0x7f499fb8eec9
> Code: ff ff c3 66 2e 0f 1f 84 00 00 00 00 00 0f 1f 40 00 48 89 f8 48 89 f=
7 48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 ff=
 ff 73 01 c3 48 c7 c1 a8 ff ff ff f7 d8 64 89 01 48
> RSP: 002b:00007ffecf309e88 EFLAGS: 00000246 ORIG_RAX: 0000000000000036
> RAX: ffffffffffffffda RBX: 00007f499fde5fa0 RCX: 00007f499fb8eec9
> RDX: 0000000000000005 RSI: 000000000000011a RDI: 0000000000000003
> RBP: 00007f499fc11f91 R08: 0000000000000000 R09: 0000000000000000
> R10: 0000000000000000 R11: 0000000000000246 R12: 0000000000000000
> R13: 00007f499fde5fa0 R14: 00007f499fde5fa0 R15: 0000000000000005
>  </TASK>
> Modules linked in:
> ---[ end trace 0000000000000000 ]---
> RIP: 0010:do_tls_setsockopt_tx_payload_len net/tls/tls_main.c:847 [inline=
]
> RIP: 0010:do_tls_setsockopt net/tls/tls_main.c:887 [inline]
> RIP: 0010:tls_setsockopt+0x189/0x1590 net/tls/tls_main.c:906
> Code: ff df 80 3c 08 00 74 08 4c 89 ff e8 51 67 3c f8 41 bc 18 01 00 00 4=
d 03 27 4c 89 e0 48 c1 e8 03 49 bf 00 00 00 00 00 fc ff df <42> 80 3c 38 00=
 74 08 4c 89 e7 e8 28 67 3c f8 49 83 3c 24 00 0f 84
> RSP: 0018:ffffc90003e57cc0 EFLAGS: 00010202
> RAX: 0000000000000023 RBX: ffff88816adfcc00 RCX: dffffc0000000000
> RDX: 0000000000000006 RSI: ffffffff8d7e872a RDI: ffffffff8bc074e0
> RBP: ffffc90003e57e38 R08: ffffffff8f9e0f77 R09: 1ffffffff1f3c1ee
> R10: dffffc0000000000 R11: fffffbfff1f3c1ef R12: 0000000000000118
> R13: 1ffff920007cafa4 R14: ffff88816b33bde8 R15: dffffc0000000000
> FS:  00005555585b2500(0000) GS:ffff8882a9d0f000(0000) knlGS:0000000000000=
000
> CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> CR2: 0000200000000180 CR3: 000000010739e000 CR4: 00000000000006f0
> ----------------
> Code disassembly (best guess), 1 bytes skipped:
>    0:   df 80 3c 08 00 74       filds  0x7400083c(%rax)
>    6:   08 4c 89 ff             or     %cl,-0x1(%rcx,%rcx,4)
>    a:   e8 51 67 3c f8          call   0xf83c6760
>    f:   41 bc 18 01 00 00       mov    $0x118,%r12d
>   15:   4d 03 27                add    (%r15),%r12
>   18:   4c 89 e0                mov    %r12,%rax
>   1b:   48 c1 e8 03             shr    $0x3,%rax
>   1f:   49 bf 00 00 00 00 00    movabs $0xdffffc0000000000,%r15
>   26:   fc ff df
> * 29:   42 80 3c 38 00          cmpb   $0x0,(%rax,%r15,1) <-- trapping in=
struction
>   2e:   74 08                   je     0x38
>   30:   4c 89 e7                mov    %r12,%rdi
>   33:   e8 28 67 3c f8          call   0xf83c6760
>   38:   49 83 3c 24 00          cmpq   $0x0,(%r12)
>   3d:   0f                      .byte 0xf
>   3e:   84                      .byte 0x84
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
> [corbet@lwn.net davem@davemloft.net edumazet@google.com horms@kernel.org =
john.fastabend@gmail.com kuba@kernel.org linux-doc@vger.kernel.org linux-ke=
rnel@vger.kernel.org linux-kselftest@vger.kernel.org netdev@vger.kernel.org=
 pabeni@redhat.com sd@queasysnail.net shuah@kernel.org wilfred.mallawa@wdc.=
com wilfred.opensource@gmail.com]
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
-upstream-moderation/68ee137a.050a0220.91a22.0202.GAE%40google.com.
