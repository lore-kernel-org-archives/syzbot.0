Received: from mail-oo1-f50.google.com (mail-oo1-f50.google.com [209.85.161.50])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 95A0B227599
	for <syzbot@lists.linux.dev>; Sat, 27 Sep 2025 05:58:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.161.50
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758952726; cv=none; b=YxS2ptMUN4sZjFk26Ch052BLx6hrMUpTXqZePj8vNPjIjByu4qrG6r75E/Gi2WyD4ZgH89JEkgXNOGASWqgeOd0giQF/M5yujcJs6P+/XJL4jeDc9qJqAg23nZqfpkdpRydyKFFm4bEziBXhbeyuI2qAfdBLQkf+R9rhHXNarK0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758952726; c=relaxed/simple;
	bh=e2D7W90Jy+Ub2kA0x6Di6GEJNxfg6nEJHi0ybUOTeDw=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=CYQX43LyCYpAPl+9pwPZT4eYhOIGDgDio+6qStD1ZtIAIYIxKyselHOI1eOYqe1R9+VGPGWVydwYhVHxvEfgGPFhWUWHbtCZ5yGgLBaYsNG1Ddy6qFbcp8K87SscDbYLU/OxXGUaUd1OGefGLhN5HFAQHGQ28gn9ZRBxlDfJlZw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=a0wgMtVL; arc=none smtp.client-ip=209.85.161.50
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="a0wgMtVL"
Received: by mail-oo1-f50.google.com with SMTP id 006d021491bc7-6234b7bdf3dso1130866eaf.0
        for <syzbot@lists.linux.dev>; Fri, 26 Sep 2025 22:58:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1758952723; x=1759557523; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=iapa/6GilvW3zXv3EHoOKU54AXwulw2J/WfWBxyoeRE=;
        b=a0wgMtVLII/H+P4QV1EumPfvvEJ0AwOXCUBg8mZcVmqG1cptRmGzDua2nrKwh3iqxI
         Bf2OvScGyipQFXzYbXJJDOl07BmF7+5py9aD/lviazME6ueuetLF7Vc+W3AsHYaMgWlQ
         xrKGRnEphcgTi0eWlH1gPOiwccpZy8UyKoQW0Lnd73iV2d3HcjT7A44bF2nQgrY8ZqHE
         RXspeAFfWmrTQjUvXq77sCLcWkl3bgVwzDgyy55rqfJbut20Si4Q2/MCQ8FDGRhyBKg2
         fYlEQAKfx8tQVvTIcvwewlwNJqA+A2DCDTt6gOJbjvca7EHnMQj4ZjSizw/aM/lh4poL
         R9hw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1758952723; x=1759557523;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=iapa/6GilvW3zXv3EHoOKU54AXwulw2J/WfWBxyoeRE=;
        b=JwD2bUc6VCS4YdZ3xfEq7QuRDyw60PAOD4L1f6RKmwNWuEP42LJ9dXR6LKb4swDleQ
         GqMKR5Ub/1hfBBjz1ojZCVCQuU5CrgM/LiRvInJ9hhcdQZv1K14Yh6fBP+PXGc0RYF4Z
         yBs4aL6H8OvsxcJza3m+VQcV87N+jIuJDN+ffK5zcw5c2LwxOa9Mat3xvE2ioU5IcEGw
         KJn+4XUvgXb3ZqQJMhTxWZ6FxPszC0CxEb9DzluRYGi5pKZHmfGq6l77MqtfKlACQBwg
         VzTT3BWKdZWxD8ulAK44eKEac5ynuz/XRoT9+XK+9jsnfGtY0DMI7uCHMyMjWsydknOY
         y0Kg==
X-Forwarded-Encrypted: i=1; AJvYcCX+FAOwHHYS9BOxutHYgaQRG2Tnef2gQ8pZGi57QELCut0rqXNpNH8B6+IK1pbiKujPUJZ/QB0=@lists.linux.dev
X-Gm-Message-State: AOJu0YzV5VH2Uw5Iz0dDMEIVPQpO+iVk4rkabUWAhPoZ1lK1YQw8EKGf
	6EU8WRNlhuWAGqsWKQX2X5iqovEoJ5WPrhlAqSpC4kHDa1OqJ8Dj96w2E++vDhK6Dfa2V3AfrSk
	nsYUk3KcwqcVCRuaPoaw5B/4L61vqktQ4rkgdzstGMcE57n+k8yY679ap
X-Gm-Gg: ASbGncs8FNkCGXcJDZP6ZlUsjfzHx9sOg5xkKWCE2mAWrONYVtjztF8rhMTmBvnzpd5
	wSmtdyekMgf+Aef1W9U+UWVe8q5/yDFv8h6hzYz3Nd7ufxmbQbCXY4JRMh3Rp1DGqcZpCFgxCy1
	1d6/AQm+Dnrj7MYcLHdmDWbvznGXtzZ1gPWjyTMW/2nwduUP63h7LXgj+tPXRXfZpKusZigDbAR
	l7K0VmneSncKQ==
X-Google-Smtp-Source: AGHT+IHBYiurOMbq8bE8ia931uC5xR3R/iyKyK5ismsTYkGTRS3WY9GSnMD9O+iTcUz9e+oyFfKxt5i4qkodntHsYtU=
X-Received: by 2002:a05:6820:2406:b0:642:52d6:7ca8 with SMTP id
 006d021491bc7-64252d68010mr426364eaf.1.1758952723406; Fri, 26 Sep 2025
 22:58:43 -0700 (PDT)
Precedence: bulk
X-Mailing-List: syzbot@lists.linux.dev
List-Id: <syzbot.lists.linux.dev>
List-Subscribe: <mailto:syzbot+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:syzbot+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <68d702b2.050a0220.25d7ab.01c0.GAE@google.com>
In-Reply-To: <68d702b2.050a0220.25d7ab.01c0.GAE@google.com>
From: Aleksandr Nogikh <nogikh@google.com>
Date: Sat, 27 Sep 2025 07:58:32 +0200
X-Gm-Features: AS18NWD-IKksS1OT1CeUHvHlXeuOaia_Zy6aaRS6oYiCFxLulG7V6Zt_VD0c3YE
Message-ID: <CANp29Y6Oi0ZbbniZZxipRq3QkGQN+F3N5JP0pNXPyGwddk7sfg@mail.gmail.com>
Subject: Re: [moderation/CI] Re: net: devmem: improve cpu cost of RX token management
To: syzbot ci <syzbot+ci91aff55081e4f959@syzkaller.appspotmail.com>
Cc: syzkaller-upstream-moderation@googlegroups.com, syzbot@lists.linux.dev
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

#syz upstream

On Fri, Sep 26, 2025 at 11:16=E2=80=AFPM syzbot ci
<syzbot+ci91aff55081e4f959@syzkaller.appspotmail.com> wrote:
>
> syzbot ci has tested the following series
>
> [v4] net: devmem: improve cpu cost of RX token management
> https://lore.kernel.org/all/20250926-scratch-bobbyeshleman-devmem-tcp-tok=
en-upstream-v4-0-39156563c3ea@meta.com
> * [PATCH net-next v4 1/2] net: devmem: rename tx_vec to vec in dmabuf bin=
ding
> * [PATCH net-next v4 2/2] net: devmem: use niov array for token managemen=
t
>
> and found the following issue:
> general protection fault in sock_devmem_dontneed
>
> Full report is available here:
> https://ci.syzbot.org/series/b8209bd4-e9f0-4c54-bad3-613e8431151b
>
> ***
>
> general protection fault in sock_devmem_dontneed
>
> tree:      net-next
> URL:       https://kernel.googlesource.com/pub/scm/linux/kernel/git/netde=
v/net-next.git
> base:      dc1dea796b197aba2c3cae25bfef45f4b3ad46fe
> arch:      amd64
> compiler:  Debian clang version 20.1.8 (++20250708063551+0c9f909b7976-1~e=
xp1~20250708183702.136), Debian LLD 20.1.8
> config:    https://ci.syzbot.org/builds/b4d90fd9-9fbe-4e17-8fc0-3d6603df0=
9da/config
> C repro:   https://ci.syzbot.org/findings/ce81b3c3-3db8-4643-9731-cbe331c=
65fdb/c_repro
> syz repro: https://ci.syzbot.org/findings/ce81b3c3-3db8-4643-9731-cbe331c=
65fdb/syz_repro
>
> Oops: general protection fault, probably for non-canonical address 0xdfff=
fc0000000000: 0000 [#1] SMP KASAN PTI
> KASAN: null-ptr-deref in range [0x0000000000000000-0x0000000000000007]
> CPU: 1 UID: 0 PID: 5996 Comm: syz.0.17 Not tainted syzkaller #0 PREEMPT(f=
ull)
> Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS 1.16.2-debian-1.=
16.2-1 04/01/2014
> RIP: 0010:sock_devmem_dontneed+0x372/0x920 net/core/sock.c:1113
> Code: 48 44 8b 20 44 89 74 24 54 45 01 f4 48 8b 44 24 60 42 80 3c 28 00 7=
4 08 48 89 df e8 e8 5a c9 f8 4c 8b 33 4c 89 f0 48 c1 e8 03 <42> 80 3c 28 00=
 74 08 4c 89 f7 e8 cf 5a c9 f8 4d 8b 3e 4c 89 f8 48
> RSP: 0018:ffffc90002a1fac0 EFLAGS: 00010246
> RAX: 0000000000000000 RBX: ffff88810a8ab710 RCX: 1ffff11023002f45
> RDX: ffff88801b339cc0 RSI: 0000000000002000 RDI: 0000000000000000
> RBP: ffffc90002a1fc50 R08: ffffc90002a1fbdf R09: 0000000000000000
> R10: ffffc90002a1fb60 R11: fffff52000543f7c R12: 0000000000f07000
> R13: dffffc0000000000 R14: 0000000000000000 R15: ffff88810a8ab710
> FS:  000055556f85a500(0000) GS:ffff8881a3c3d000(0000) knlGS:0000000000000=
000
> CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> CR2: 00002000000a2000 CR3: 0000000024516000 CR4: 00000000000006f0
> Call Trace:
>  <TASK>
>  sk_setsockopt+0x682/0x2dc0 net/core/sock.c:1304
>  do_sock_setsockopt+0x11b/0x1b0 net/socket.c:2340
>  __sys_setsockopt net/socket.c:2369 [inline]
>  __do_sys_setsockopt net/socket.c:2375 [inline]
>  __se_sys_setsockopt net/socket.c:2372 [inline]
>  __x64_sys_setsockopt+0x13f/0x1b0 net/socket.c:2372
>  do_syscall_x64 arch/x86/entry/syscall_64.c:63 [inline]
>  do_syscall_64+0xfa/0x3b0 arch/x86/entry/syscall_64.c:94
>  entry_SYSCALL_64_after_hwframe+0x77/0x7f
> RIP: 0033:0x7fea0438ec29
> Code: ff ff c3 66 2e 0f 1f 84 00 00 00 00 00 0f 1f 40 00 48 89 f8 48 89 f=
7 48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 ff=
 ff 73 01 c3 48 c7 c1 a8 ff ff ff f7 d8 64 89 01 48
> RSP: 002b:00007ffd04a8f368 EFLAGS: 00000246 ORIG_RAX: 0000000000000036
> RAX: ffffffffffffffda RBX: 00007fea045d5fa0 RCX: 00007fea0438ec29
> RDX: 0000000000000050 RSI: 0000000000000001 RDI: 0000000000000003
> RBP: 00007fea04411e41 R08: 0000000000000010 R09: 0000000000000000
> R10: 00002000000a2000 R11: 0000000000000246 R12: 0000000000000000
> R13: 00007fea045d5fa0 R14: 00007fea045d5fa0 R15: 0000000000000005
>  </TASK>
> Modules linked in:
> ---[ end trace 0000000000000000 ]---
> RIP: 0010:sock_devmem_dontneed+0x372/0x920 net/core/sock.c:1113
> Code: 48 44 8b 20 44 89 74 24 54 45 01 f4 48 8b 44 24 60 42 80 3c 28 00 7=
4 08 48 89 df e8 e8 5a c9 f8 4c 8b 33 4c 89 f0 48 c1 e8 03 <42> 80 3c 28 00=
 74 08 4c 89 f7 e8 cf 5a c9 f8 4d 8b 3e 4c 89 f8 48
> RSP: 0018:ffffc90002a1fac0 EFLAGS: 00010246
> RAX: 0000000000000000 RBX: ffff88810a8ab710 RCX: 1ffff11023002f45
> RDX: ffff88801b339cc0 RSI: 0000000000002000 RDI: 0000000000000000
> RBP: ffffc90002a1fc50 R08: ffffc90002a1fbdf R09: 0000000000000000
> R10: ffffc90002a1fb60 R11: fffff52000543f7c R12: 0000000000f07000
> R13: dffffc0000000000 R14: 0000000000000000 R15: ffff88810a8ab710
> FS:  000055556f85a500(0000) GS:ffff8881a3c3d000(0000) knlGS:0000000000000=
000
> CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> CR2: 00002000000a2000 CR3: 0000000024516000 CR4: 00000000000006f0
> ----------------
> Code disassembly (best guess):
>    0:   48                      rex.W
>    1:   44 8b 20                mov    (%rax),%r12d
>    4:   44 89 74 24 54          mov    %r14d,0x54(%rsp)
>    9:   45 01 f4                add    %r14d,%r12d
>    c:   48 8b 44 24 60          mov    0x60(%rsp),%rax
>   11:   42 80 3c 28 00          cmpb   $0x0,(%rax,%r13,1)
>   16:   74 08                   je     0x20
>   18:   48 89 df                mov    %rbx,%rdi
>   1b:   e8 e8 5a c9 f8          call   0xf8c95b08
>   20:   4c 8b 33                mov    (%rbx),%r14
>   23:   4c 89 f0                mov    %r14,%rax
>   26:   48 c1 e8 03             shr    $0x3,%rax
> * 2a:   42 80 3c 28 00          cmpb   $0x0,(%rax,%r13,1) <-- trapping in=
struction
>   2f:   74 08                   je     0x39
>   31:   4c 89 f7                mov    %r14,%rdi
>   34:   e8 cf 5a c9 f8          call   0xf8c95b08
>   39:   4d 8b 3e                mov    (%r14),%r15
>   3c:   4c 89 f8                mov    %r15,%rax
>   3f:   48                      rex.W
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
-upstream-moderation/68d702b2.050a0220.25d7ab.01c0.GAE%40google.com.
