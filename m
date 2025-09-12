Received: from mail-ot1-f44.google.com (mail-ot1-f44.google.com [209.85.210.44])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B93272DC796
	for <syzbot@lists.linux.dev>; Fri, 12 Sep 2025 09:37:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.44
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757669842; cv=none; b=kIXyJgGnys6VsgEv28xFcmYE94/2MGxIGy+l6+HBFRLxgqybpWUxtMIRl7BF2UKKjdcYSzYZZ0kEZaUZn+NLThvvUeTIm36C4EztkIDODfJXGZZCKvUvF2AjLX479NyzekXGEqUxdnX3xmwldwrx93wdTQ6zUYSuKnxVX4NebFE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757669842; c=relaxed/simple;
	bh=kaIyGuFOWEUue8pN4CmZfpxdGnmml0p1VkDOE33UqfM=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=NNt/fNxfq4Dvm9aKisD3tcRX1tkG31/mnb6grPiT1lXvDvZ1sqSjTnvXdSSR1xMqNvNQkXPlhOaGw3N8i/DxR2dsm2eNqCBJ68h0LbjTP7QVkkqJEUagcgiT7EvbxH4EhAWBC2Rm7jBTXtuyW9mM1C9vG7Bq1OdI203iHUL7a1U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=nSOsMNzt; arc=none smtp.client-ip=209.85.210.44
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="nSOsMNzt"
Received: by mail-ot1-f44.google.com with SMTP id 46e09a7af769-750c5378b96so779623a34.0
        for <syzbot@lists.linux.dev>; Fri, 12 Sep 2025 02:37:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1757669840; x=1758274640; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=r1o54kfk6FVNd9u6x6P1dV5AfvZKGPjTkJbHG9kcLIw=;
        b=nSOsMNztFWBRgoi52oFlXPOHLi9h+Ehoc8wUb2Eixwk//FFzfIKSUQZYlj8P96kFGI
         uS/UlhVdxs3RDUj303o8E8v1U8GrD5ROJmpSHSHm43Ky5XHsLONC32iCOcBcvPziXCrK
         ZIxbsr5WN/elvlnJNri43HGRlhBckAitkGa/H4pPa1fe2BrnnYEBk9rbfXON7oT3fBeP
         XeE74C+uCdADt+QZS7b/RO88mJXseaK8yN9YJJz5WeDXEK5RhibBe50Umq9aY3uBPqje
         gLG4VtCU0tUhvvWzNeR1dIu3MePLO1pzy/QOwfqBJ7kD/HVsiPfNbDqoFEzv6XRTblC/
         Q+Qw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1757669840; x=1758274640;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=r1o54kfk6FVNd9u6x6P1dV5AfvZKGPjTkJbHG9kcLIw=;
        b=cwDhjDaeNcm/17Ng+Xs7FzmYGp0JZeM/Cdf4JMih/kzBPTltyTjSUaddMBYm2ST9BN
         y4jBFLofBsvEoboEUD3z6pYorxsIePCrmnPZ1zcvbkBK5PzLh2hPDqKXS9PClrOZMzpW
         QHyl7++TOAKrIDst9UkGKApuveKAEiATy5oYzxh6vftwAss/aORRmrwHCm3BDm+2FZ23
         xVvx0uwlz1Ojgvy1XkGaCVKtnRDa+CERjO/Q+bfSiViTFwCeVzvFpKcQyQ1dqCjz9CNE
         2yjlSBw4lH3VXWmie4Vc/ExWlhPwz1fs6S8hkyonIiGT1AUVuH5/9i8bj+TFWZ7q7I6k
         /SeA==
X-Forwarded-Encrypted: i=1; AJvYcCWxBe8EA7qZ5pKCAOqnzYrfK198fpscIPwLGgL7cGRQ0lMparbdhulFY4PJLbZ+GMaiETupfrE=@lists.linux.dev
X-Gm-Message-State: AOJu0Yx8Zn2+G1UeATZV1mPJIGawiyThqgtqxvbN4CKQXQvvksSnSGpb
	gKqRjE8rY6e7+ucLmsjIUaG+yeg4llhrooD10OsCrqz0+BvkrVkZNAqlOwdMhimK+lJX1wEkAdr
	N2pUJhv3k7++5JTQSDf4Nj9SjK8vmOoulytQcWlty
X-Gm-Gg: ASbGncvsEz9Iw80r206goq1W6zMe3JeIxYCfE/8juxJ4StJgXinug56BdCRqsf3ewyW
	ZkSojfVJjPN7MhiadyOetsZxwoqUqX4P3lIePUkLKux1BCf1XApas5OkZ/0NeKg5LZwE+AMKCpJ
	CIa/+SICJEMM2P0fcvm0NwaJ7m+vzbc4E40wQwXw1df6duy4LsmrmiT6dmDmobMoeHrE1OKpp/O
	T+F5N+2oBP7d5ZYZ3lEChePyFPPXwljeAxz8lZKZ7E/qZTd6Zo5
X-Google-Smtp-Source: AGHT+IHkNkVD41UHzuZXFFcgWDlKcf6nuSHqkZXXoV6QubKrAttDY7BOte3dyDG1clDdMdQWzo4jBH9wrAzE1HZcUco=
X-Received: by 2002:a05:6830:6c0b:b0:745:9907:3fb5 with SMTP id
 46e09a7af769-751df0bee5amr4306016a34.7.1757669839502; Fri, 12 Sep 2025
 02:37:19 -0700 (PDT)
Precedence: bulk
X-Mailing-List: syzbot@lists.linux.dev
List-Id: <syzbot.lists.linux.dev>
List-Subscribe: <mailto:syzbot+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:syzbot+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <68c3e457.050a0220.3c6139.049e.GAE@google.com>
In-Reply-To: <68c3e457.050a0220.3c6139.049e.GAE@google.com>
From: Aleksandr Nogikh <nogikh@google.com>
Date: Fri, 12 Sep 2025 11:37:08 +0200
X-Gm-Features: Ac12FXzmLRVp4fJySfN8NSlPUPQifOuKhG7OA23xLLxvR4xfwGgCwDYa3qpr8BA
Message-ID: <CANp29Y4wRb1Yooi_03v=SxkohiBHtAAwCRTKGjW0KQhmN8qt3g@mail.gmail.com>
Subject: Re: [moderation/CI] Re: net: devmem: improve cpu cost of RX token management
To: syzbot ci <syzbot+ci6b3b9a0c3f217c63@syzkaller.appspotmail.com>
Cc: syzkaller-upstream-moderation@googlegroups.com, syzbot@lists.linux.dev
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

#syz upstream

On Fri, Sep 12, 2025 at 11:14=E2=80=AFAM syzbot ci
<syzbot+ci6b3b9a0c3f217c63@syzkaller.appspotmail.com> wrote:
>
> syzbot ci has tested the following series
>
> [v2] net: devmem: improve cpu cost of RX token management
> https://lore.kernel.org/all/20250911-scratch-bobbyeshleman-devmem-tcp-tok=
en-upstream-v2-0-c80d735bd453@meta.com
> * [PATCH net-next v2 1/3] net: devmem: rename tx_vec to vec in dmabuf bin=
ding
> * [PATCH net-next v2 2/3] net: devmem: use niov array for token managemen=
t
> * [PATCH net-next v2 3/3] net: ethtool: prevent user from breaking devmem=
 single-binding rule
>
> and found the following issue:
> general protection fault in sock_devmem_dontneed
>
> Full report is available here:
> https://ci.syzbot.org/series/40b2252a-f8bb-4cec-bfc1-2ff8a3c55336
>
> ***
>
> general protection fault in sock_devmem_dontneed
>
> tree:      net-next
> URL:       https://kernel.googlesource.com/pub/scm/linux/kernel/git/netde=
v/net-next.git
> base:      5adf6f2b9972dbb69f4dd11bae52ba251c64ecb7
> arch:      amd64
> compiler:  Debian clang version 20.1.8 (++20250708063551+0c9f909b7976-1~e=
xp1~20250708183702.136), Debian LLD 20.1.8
> config:    https://ci.syzbot.org/builds/2c30c608-f14f-4e6d-9772-cc5e12993=
9fc/config
> C repro:   https://ci.syzbot.org/findings/c89c36f8-4666-47d0-bc39-35662a2=
68e4d/c_repro
> syz repro: https://ci.syzbot.org/findings/c89c36f8-4666-47d0-bc39-35662a2=
68e4d/syz_repro
>
> Oops: general protection fault, probably for non-canonical address 0xdfff=
fc0000000000: 0000 [#1] SMP KASAN PTI
> KASAN: null-ptr-deref in range [0x0000000000000000-0x0000000000000007]
> CPU: 1 UID: 0 PID: 6028 Comm: syz.0.17 Not tainted syzkaller #0 PREEMPT(f=
ull)
> Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS 1.16.2-debian-1.=
16.2-1 04/01/2014
> RIP: 0010:sock_devmem_dontneed+0x40b/0x910 net/core/sock.c:1112
> Code: 8b 44 24 18 44 8b 20 44 03 64 24 14 48 8b 44 24 68 80 3c 18 00 74 0=
8 4c 89 ef e8 f0 bb c9 f8 4d 8b 7d 00 4c 89 f8 48 c1 e8 03 <80> 3c 18 00 74=
 08 4c 89 ff e8 d7 bb c9 f8 4d 8b 2f 4c 89 e8 48 c1
> RSP: 0018:ffffc90002987ac0 EFLAGS: 00010246
> RAX: 0000000000000000 RBX: dffffc0000000000 RCX: 1ffff11020d27e78
> RDX: ffff88810a039cc0 RSI: 0000000000000003 RDI: 0000000000000000
> RBP: ffffc90002987c50 R08: ffffc90002987bdf R09: 0000000000000000
> R10: ffffc90002987b60 R11: fffff52000530f7c R12: 0000000000000006
> R13: ffff8881235cb710 R14: 0000000000000000 R15: 0000000000000000
> FS:  000055555e866500(0000) GS:ffff8881a3c14000(0000) knlGS:0000000000000=
000
> CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> CR2: 0000001b31b63fff CR3: 0000000027a20000 CR4: 00000000000006f0
> Call Trace:
>  <TASK>
>  sk_setsockopt+0x682/0x2dc0 net/core/sock.c:1301
>  do_sock_setsockopt+0x11b/0x1b0 net/socket.c:2340
>  __sys_setsockopt net/socket.c:2369 [inline]
>  __do_sys_setsockopt net/socket.c:2375 [inline]
>  __se_sys_setsockopt net/socket.c:2372 [inline]
>  __x64_sys_setsockopt+0x13f/0x1b0 net/socket.c:2372
>  do_syscall_x64 arch/x86/entry/syscall_64.c:63 [inline]
>  do_syscall_64+0xfa/0x3b0 arch/x86/entry/syscall_64.c:94
>  entry_SYSCALL_64_after_hwframe+0x77/0x7f
> RIP: 0033:0x7faf24f8eba9
> Code: ff ff c3 66 2e 0f 1f 84 00 00 00 00 00 0f 1f 40 00 48 89 f8 48 89 f=
7 48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 ff=
 ff 73 01 c3 48 c7 c1 a8 ff ff ff f7 d8 64 89 01 48
> RSP: 002b:00007ffc3eb96018 EFLAGS: 00000246 ORIG_RAX: 0000000000000036
> RAX: ffffffffffffffda RBX: 00007faf251d5fa0 RCX: 00007faf24f8eba9
> RDX: 0000000000000050 RSI: 0000000000000001 RDI: 0000000000000003
> RBP: 00007faf25011e19 R08: 0000000000000048 R09: 0000000000000000
> R10: 0000200000000100 R11: 0000000000000246 R12: 0000000000000000
> R13: 00007faf251d5fa0 R14: 00007faf251d5fa0 R15: 0000000000000005
>  </TASK>
> Modules linked in:
> ---[ end trace 0000000000000000 ]---
> RIP: 0010:sock_devmem_dontneed+0x40b/0x910 net/core/sock.c:1112
> Code: 8b 44 24 18 44 8b 20 44 03 64 24 14 48 8b 44 24 68 80 3c 18 00 74 0=
8 4c 89 ef e8 f0 bb c9 f8 4d 8b 7d 00 4c 89 f8 48 c1 e8 03 <80> 3c 18 00 74=
 08 4c 89 ff e8 d7 bb c9 f8 4d 8b 2f 4c 89 e8 48 c1
> RSP: 0018:ffffc90002987ac0 EFLAGS: 00010246
> RAX: 0000000000000000 RBX: dffffc0000000000 RCX: 1ffff11020d27e78
> RDX: ffff88810a039cc0 RSI: 0000000000000003 RDI: 0000000000000000
> RBP: ffffc90002987c50 R08: ffffc90002987bdf R09: 0000000000000000
> R10: ffffc90002987b60 R11: fffff52000530f7c R12: 0000000000000006
> R13: ffff8881235cb710 R14: 0000000000000000 R15: 0000000000000000
> FS:  000055555e866500(0000) GS:ffff8881a3c14000(0000) knlGS:0000000000000=
000
> CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> CR2: 0000001b31b63fff CR3: 0000000027a20000 CR4: 00000000000006f0
> ----------------
> Code disassembly (best guess):
>    0:   8b 44 24 18             mov    0x18(%rsp),%eax
>    4:   44 8b 20                mov    (%rax),%r12d
>    7:   44 03 64 24 14          add    0x14(%rsp),%r12d
>    c:   48 8b 44 24 68          mov    0x68(%rsp),%rax
>   11:   80 3c 18 00             cmpb   $0x0,(%rax,%rbx,1)
>   15:   74 08                   je     0x1f
>   17:   4c 89 ef                mov    %r13,%rdi
>   1a:   e8 f0 bb c9 f8          call   0xf8c9bc0f
>   1f:   4d 8b 7d 00             mov    0x0(%r13),%r15
>   23:   4c 89 f8                mov    %r15,%rax
>   26:   48 c1 e8 03             shr    $0x3,%rax
> * 2a:   80 3c 18 00             cmpb   $0x0,(%rax,%rbx,1) <-- trapping in=
struction
>   2e:   74 08                   je     0x38
>   30:   4c 89 ff                mov    %r15,%rdi
>   33:   e8 d7 bb c9 f8          call   0xf8c9bc0f
>   38:   4d 8b 2f                mov    (%r15),%r13
>   3b:   4c 89 e8                mov    %r13,%rax
>   3e:   48                      rex.W
>   3f:   c1                      .byte 0xc1
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
> [almasrymina@google.com bobbyeshleman@gmail.com bobbyeshleman@meta.com da=
vem@davemloft.net dsahern@kernel.org edumazet@google.com horms@kernel.org k=
uba@kernel.org kuniyu@google.com linux-kernel@vger.kernel.org ncardwell@goo=
gle.com netdev@vger.kernel.org pabeni@redhat.com sdf@fomichev.me willemb@go=
ogle.com]
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
-upstream-moderation/68c3e457.050a0220.3c6139.049e.GAE%40google.com.
