Received: from mail-qv1-f50.google.com (mail-qv1-f50.google.com [209.85.219.50])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 67E38449985
	for <syzbot@lists.linux.dev>; Fri, 10 Jul 2026 07:46:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.219.50
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783669604; cv=pass; b=isaHskivBjAIACfDUOaESP63WN9XlwvG9SHtMmLKSRJVNams/BE2OJ8lU7rbuwuHgSiW8iVRiJL7FExjhta3J+1OtZ+x4hyjqqTXxeSKWxPP/bNl7YbMn6u4S//T6LwLgfh7jUL5n448NxvjHfi4bcAP/HHeFU/WsnIrtBiJN9M=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783669604; c=relaxed/simple;
	bh=XpVqaNjwjABYhWUOZvhRC4a9gBKg7h9shN/2xzK+kGs=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=iCU1Yz3d08ufrtBEG/+9/w24BnZF3NCWeSdbhxzyTt7SnndAcptYeogFfvPLNiPl86lI1pMt7IXK+HyXv77I49uS8sJA77s5mlJsKOttI8tRUqsjTqVVgZSiVLczZUwE+jdDcBZV7xl0VY1oEot6RswqBQcchXa53spKnJvugtg=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=FKbwRmXr; arc=pass smtp.client-ip=209.85.219.50
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="FKbwRmXr"
Received: by mail-qv1-f50.google.com with SMTP id 6a1803df08f44-8f1e274ccb9so3928406d6.2
        for <syzbot@lists.linux.dev>; Fri, 10 Jul 2026 00:46:42 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1783669601; cv=none;
        d=google.com; s=arc-20260327;
        b=T3AB2Ka/cQsuu9g7ficAruMdVaO9gUFdcu1QpMypFEs5UjAxSPwKlIhaQK+tLL72xg
         1/76mbUvRRLx03nKp/jJM/NTP2Z1tZXvVew8Oi/MQGh5XsVdl/2Y2K10MCQcjZwCs1r7
         ujLyicNEV1kNunhw+QCToOAFjVLwszOKh90L5qzv9wfNhRfxRnvM+kZz5+II1BKu2Nth
         M5Z4JLYLRteuWNn0RjTs1KTgQ0X8VLCAQRxFGvyDvVX+c7JhDp+/5kzX6ONfKjBsUZpk
         pPdd+5Nx2Zj4kcfn6GTQQQaJTi3GXvydz0Hp3Oo7v9am2NYtXC+8xIiUQno8OHHCjrGJ
         0+JQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=yyzhTup5yUL596oP1YL0wcNtjrVmT4CMCbx6tFXVSTc=;
        fh=ghlO7SHEfIHtG3YrBWMz7Y5dxHrJhbPWlmm30i39zdA=;
        b=ASYlYvk0Dsqbm/pstBF7H57RqjoCihr5qyP6uXIdyRwFJH/fyK/h/3dDtP8VKWurQ/
         dUy1LR5spelSMNwWPru3i22f/n4w3WifQOCrN+KvGo+V/AfnwaAq4ieJgvN6hVaW9qV1
         V7FQ1gf3rVB1LHNm6yxJf2c1Yq53pZdRtaSGElMz+8X/aASUB573hyrDRKvMy1Oan8XS
         xia3HTAxTKsLh32+30m5TwjE5ReY7tugEK00j8eeiiEIFSyVm2qILtj2kl5NRdbVk7Fv
         Qh8t2vrMeyodeM3vrFIfNf22+GOWQM07u4Cz9Wp9NvfaXp2NWwNrUy8GwVT3/V/7hb6j
         u20Q==;
        darn=lists.linux.dev
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1783669601; x=1784274401; darn=lists.linux.dev;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=yyzhTup5yUL596oP1YL0wcNtjrVmT4CMCbx6tFXVSTc=;
        b=FKbwRmXrT2r91ygk0c5j+AL7lu2PCARZlkbZYSY9hddrBhbsJAGSFz8JvpPzL0zEbP
         jRTNlmNajFZGbLxYgXKzdcY0UqeRx7GS+pOT3cIGvSiG/ZGuo2+JrA0pzpnRUVEISFWt
         JVH4CRGOc1JDxZpGuh/coyCoNx9FFxq0VN7vJHj5cJN2AlhvQbMSi9W9Vv96GJP2kqGO
         ak5exCFrtix4lqo83Lrlr4suN8Ap4LhjFGexf3HdupjcNKMcbDkt0jzrg0a6BuRtVLYJ
         zwTMdPrT/mSLChr7mzYioUSo8Ejl7vtCqg47EAoqrbufpvGXt7v26GGs3tnIfaAAM1iq
         u19A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1783669601; x=1784274401;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=yyzhTup5yUL596oP1YL0wcNtjrVmT4CMCbx6tFXVSTc=;
        b=hkKNfRTZdIT2HlZ7FQv33nvajdj17sGG5bqr+zEhtwl8F3KgCUjWfN92pPh8CZOmSD
         /tEIDYtS97L1p3E80jGez5STcU/X9QNIagryOpsgsGfcSy/iKDMpgla54wNSmbLPhI6F
         pvZuYnvnxGJRa5M/zW6CEp1Zd3DeaLx1ND7S0YBz/cNd/d8GwWTdcCZzp9goI1qslAOg
         Z6v/v50dFB3vUqloKiOwXqNPf8V7sp2h6YJifkBecS6J+j7lLnnsZhygEZ3pNQC+Ek6f
         TH8rhMIojxEHtEr+jTAIYXWWwuvoC5MyrQVtG62oyHmysLWdJaFHCGI/FIWvoA6T6PbU
         QFtg==
X-Forwarded-Encrypted: i=1; AHgh+RpCbs9SPlkj1bhULFyABI/sfTZT7a40H9FEE1stMiGmpyuGqqr+eszEuZsFdnfP99JNFheEokw=@lists.linux.dev
X-Gm-Message-State: AOJu0Yx+b6EvyMYrpYYG0bIdrczuMpFA4a4QdEtOrcznlJ0NKyZa13gG
	lGmYuq97ystW7wNotufKp6iJPFMb8Agsfldm2iQcTWQJwM4oqyWvye5kwMU56QTg+HD4cSPl0OD
	otOFt4EuGkx7KgtiEgPHgi5iS94a4JChP23fwNW/ljF1tSDe75E8SDaiMmHA=
X-Gm-Gg: AfdE7cnBp/4jnJ/Nt/9/ouYxrREGB4hVly+HW9or555rY2a6i5dx/L3N+fgq7P70aMz
	5aCT0NdtUMKRpbP3F8AdpMFV+L1NwNEZgFNp3x024ra7+7thEq5xFvzckEc6Vvkmxv7dwh5vMmi
	b+CBz0qhc3I9BZHzHDYfy/g83kNFVlv/2/kWirBP495mp1moL1BH8ne/jskuQQavX2A45gs78P3
	TyX7DkyD/qW7zdr/lW59UJ+8m5bkps3CP3nKdNJd51SBopvqp5hfBO4yAjD4jzppvozLKNIu7Bl
	qQS0jpGmxu4jO8VMQwUB+NW1BY9y2tyaoPJ4/1uxvH0SDLeFn/MIk6qzhoKKJA==
X-Received: by 2002:a05:6214:c2e:b0:8e1:694a:73d7 with SMTP id
 6a1803df08f44-8fec0eb74dbmr113795416d6.24.1783669600894; Fri, 10 Jul 2026
 00:46:40 -0700 (PDT)
Precedence: bulk
X-Mailing-List: syzbot@lists.linux.dev
List-Id: <syzbot.lists.linux.dev>
List-Subscribe: <mailto:syzbot+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:syzbot+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <6a509570.c76b52dc.2a15e.0009.GAE@google.com>
In-Reply-To: <6a509570.c76b52dc.2a15e.0009.GAE@google.com>
From: Pimyn Girgis <pimyn@google.com>
Date: Fri, 10 Jul 2026 09:46:29 +0200
X-Gm-Features: AUfX_myQ5Rp7vEMIhtujPpUylN5M5Acirjb_V0PnthN5M4i9GvnJquES4VIdqU0
Message-ID: <CAJWNTGwQxRMnLHoaWNVexz43osWUidwTojzc02YRasUGp3L0rA@mail.gmail.com>
Subject: Re: [moderation/CI] Re: macvlan: allow source mode devices along with passthru
To: syzbot ci <syzbot+cid152941003025f4b@syzkaller.appspotmail.com>
Cc: syzkaller-upstream-moderation@googlegroups.com, syzbot@lists.linux.dev
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

#syz upstream


On Fri, Jul 10, 2026 at 8:47=E2=80=AFAM syzbot ci
<syzbot+cid152941003025f4b@syzkaller.appspotmail.com> wrote:
>
> syzbot ci has tested the following series
>
> [v2] macvlan: allow source mode devices along with passthru
> https://lore.kernel.org/all/20260709091138.170348-1-t.martitz@fritz.com
> * [PATCH v2 1/1] macvlan: allow source mode devices along with passthru
>
> and found the following issue:
> general protection fault in macvlan_port_release_mac
>
> Full report is available here:
> https://ci.syzbot.org/series/72476997-558e-41ae-b146-c05346cdd7f6
>
> ***
>
> general protection fault in macvlan_port_release_mac
>
> tree:      net-next
> URL:       https://kernel.googlesource.com/pub/scm/linux/kernel/git/netde=
v/net-next.git
> base:      fe3e786ef4eb6e47d2901f568a27bd920477bbe9
> arch:      amd64
> compiler:  Debian clang version 22.1.6 (++20260514074242+fc4aad7b5db3-1~e=
xp1~20260514074407.73), Debian LLD 22.1.6
> config:    https://ci.syzbot.org/builds/0c5e2f82-62bd-40bf-a873-66f277607=
c07/config
> syz repro: https://ci.syzbot.org/findings/d5d14725-5a48-484c-876d-026175d=
0b21a/syz_repro
>
> batman_adv: batadv0: Removing interface: batadv_slave_1
> veth1_macvtap: left promiscuous mode
> veth0_macvtap: left promiscuous mode
> veth1_vlan: left promiscuous mode
> veth0_vlan: left promiscuous mode
> Oops: general protection fault, probably for non-canonical address 0xdfff=
fc0000000118: 0000 [#1] SMP KASAN PTI
> KASAN: null-ptr-deref in range [0x00000000000008c0-0x00000000000008c7]
> CPU: 1 UID: 0 PID: 13 Comm: kworker/u8:1 Not tainted syzkaller #0 PREEMPT=
(full)
> Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS 1.16.2-debian-1.=
16.2-1 04/01/2014
> Workqueue: netns cleanup_net
> RIP: 0010:macvlan_passthru drivers/net/macvlan.c:78 [inline]
> RIP: 0010:macvlan_port_release_mac+0x138/0x490 drivers/net/macvlan.c:807
> Code: 01 00 00 48 89 d8 48 c1 e8 03 42 80 3c 20 00 74 08 48 89 df e8 b9 3=
0 ae fb 48 8b 1b 4c 8d b3 c0 08 00 00 4c 89 f0 48 c1 e8 03 <42> 0f b6 04 20=
 84 c0 0f 85 44 02 00 00 45 8b 36 44 89 f6 83 e6 01
> RSP: 0018:ffffc90000127500 EFLAGS: 00010206
> RAX: 0000000000000118 RBX: 0000000000000000 RCX: ffff888102ec5940
> RDX: 0000000000000000 RSI: 0000000000000001 RDI: 0000000000000000
> RBP: ffffc90000127630 R08: ffffffff9032faf7 R09: 1ffffffff2065f5e
> R10: dffffc0000000000 R11: fffffbfff2065f5f R12: dffffc0000000000
> R13: 1ffff92000024ea4 R14: 00000000000008c0 R15: ffff888109b28818
> FS:  0000000000000000(0000) GS:ffff8882a9223000(0000) knlGS:0000000000000=
000
> CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> CR2: 00007ffefe7250d8 CR3: 000000000e746000 CR4: 00000000000006f0
> Call Trace:
>  <TASK>
>  macvlan_port_destroy+0x2eb/0x310 drivers/net/macvlan.c:1343
>  unregister_netdevice_many_notify+0x1ad2/0x2150 net/core/dev.c:12464
>  unregister_netdevice_many net/core/dev.c:12506 [inline]
>  default_device_exit_batch+0x961/0x9e0 net/core/dev.c:13098
>  ops_exit_list net/core/net_namespace.c:205 [inline]
>  ops_undo_list+0x4b4/0x8d0 net/core/net_namespace.c:252
>  cleanup_net+0x572/0x810 net/core/net_namespace.c:702
>  process_one_work kernel/workqueue.c:3322 [inline]
>  process_scheduled_works+0xa8e/0x14e0 kernel/workqueue.c:3405
>  worker_thread+0xa47/0xfb0 kernel/workqueue.c:3486
>  kthread+0x388/0x470 kernel/kthread.c:436
>  ret_from_fork+0x514/0xb70 arch/x86/kernel/process.c:158
>  ret_from_fork_asm+0x1a/0x30 arch/x86/entry/entry_64.S:245
>  </TASK>
> Modules linked in:
> ---[ end trace 0000000000000000 ]---
> RIP: 0010:macvlan_passthru drivers/net/macvlan.c:78 [inline]
> RIP: 0010:macvlan_port_release_mac+0x138/0x490 drivers/net/macvlan.c:807
> Code: 01 00 00 48 89 d8 48 c1 e8 03 42 80 3c 20 00 74 08 48 89 df e8 b9 3=
0 ae fb 48 8b 1b 4c 8d b3 c0 08 00 00 4c 89 f0 48 c1 e8 03 <42> 0f b6 04 20=
 84 c0 0f 85 44 02 00 00 45 8b 36 44 89 f6 83 e6 01
> RSP: 0018:ffffc90000127500 EFLAGS: 00010206
> RAX: 0000000000000118 RBX: 0000000000000000 RCX: ffff888102ec5940
> RDX: 0000000000000000 RSI: 0000000000000001 RDI: 0000000000000000
> RBP: ffffc90000127630 R08: ffffffff9032faf7 R09: 1ffffffff2065f5e
> R10: dffffc0000000000 R11: fffffbfff2065f5f R12: dffffc0000000000
> R13: 1ffff92000024ea4 R14: 00000000000008c0 R15: ffff888109b28818
> FS:  0000000000000000(0000) GS:ffff8882a9223000(0000) knlGS:0000000000000=
000
> CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> CR2: 00007ffefe7250d8 CR3: 000000000e746000 CR4: 00000000000006f0
> ----------------
> Code disassembly (best guess):
>    0:   01 00                   add    %eax,(%rax)
>    2:   00 48 89                add    %cl,-0x77(%rax)
>    5:   d8 48 c1                fmuls  -0x3f(%rax)
>    8:   e8 03 42 80 3c          call   0x3c804210
>    d:   20 00                   and    %al,(%rax)
>    f:   74 08                   je     0x19
>   11:   48 89 df                mov    %rbx,%rdi
>   14:   e8 b9 30 ae fb          call   0xfbae30d2
>   19:   48 8b 1b                mov    (%rbx),%rbx
>   1c:   4c 8d b3 c0 08 00 00    lea    0x8c0(%rbx),%r14
>   23:   4c 89 f0                mov    %r14,%rax
>   26:   48 c1 e8 03             shr    $0x3,%rax
> * 2a:   42 0f b6 04 20          movzbl (%rax,%r12,1),%eax <-- trapping in=
struction
>   2f:   84 c0                   test   %al,%al
>   31:   0f 85 44 02 00 00       jne    0x27b
>   37:   45 8b 36                mov    (%r14),%r14d
>   3a:   44 89 f6                mov    %r14d,%esi
>   3d:   83 e6 01                and    $0x1,%esi
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
> [andrew@lunn.ch davem@davemloft.net edumazet@google.com horms@kernel.org =
kuba@kernel.org linux-kernel@vger.kernel.org netdev@vger.kernel.org pabeni@=
redhat.com t.martitz@fritz.com]
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
-upstream-moderation/6a509570.c76b52dc.2a15e.0009.GAE%40google.com.



--=20
=E2=B2=A0=E2=B2=9F=E2=B2=93=E2=B2=99=E2=B2=8F=E2=B2=9B =E2=B2=84=E2=B2=89=
=E2=B2=B1=E2=B2=A3=E2=B2=85=E2=B2=93=E2=B2=9F=E2=B2=A5 - Pimyn Girgis
Software Engineer
Kernel Dynamic Analysis
pimyn@google.com
