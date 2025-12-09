Received: from mail-ot1-f52.google.com (mail-ot1-f52.google.com [209.85.210.52])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D4DEA320386
	for <syzbot@lists.linux.dev>; Tue,  9 Dec 2025 12:12:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.52
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765282361; cv=none; b=Ze3XU5DJxJtqtrQYWsV6t/Ds3tRHQ6r9vCRx1a0QCBcsWBl0i5WUBeIA15qvKOjWaHUGJ423ZUPDjzUGsABAp6tiCPwJqxgMDJZMo36U7xp4+paFqi7mEI6vSa/eQ9FQy6jRtYbxdt4cJHLm36UuOo0Kmm9bRLsX2cV5sWe6M60=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765282361; c=relaxed/simple;
	bh=VuxjPLI/UAw5tJKbiinNZ84Om6ZqnyBXEnyuPGh7his=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=lzR5nU8NeW14zNyEdYVWsgDvbrs95qhvPLpLD0DX1icJpP7i8qwC50VvkjR+vo1F4/iJuaTan8dAFH5EREUiUkS4Owdff9gNYSCYPJ2T6YSIyst6AS+Mq3+pRVpGYyhVEwOOV9zigeH/SG0/IcqmrtqbBDYGsJYs4Hd2zycPUaI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=TlnItjAZ; arc=none smtp.client-ip=209.85.210.52
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="TlnItjAZ"
Received: by mail-ot1-f52.google.com with SMTP id 46e09a7af769-7c6cc44ff62so4622517a34.3
        for <syzbot@lists.linux.dev>; Tue, 09 Dec 2025 04:12:39 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1765282359; x=1765887159; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=xPO/BvKGg7sBkLwEUPIfmAVXeNPbTgtzjvUBKwIinZM=;
        b=TlnItjAZqhQE+VZBC2iWtqmbBm/Bl89u2QWCq3SZNy0aPnpTd2HKbJ4lrl7sQtDFK9
         y/SwIDDUNbnWC7/mkLw8ZByvhf54FMtwQWeqr89QcBvyafLH1FUwFKl/gs26e1WTt1D2
         /OEB1pixgwAc7/IFe12B/c3EPHwhNqjuy0Gs+ghzyYEPe/hlGbwRCP39NaanCnAZHIie
         uXWuTI1YA+osowwTY8Qspq3MhswnOGK3JbgkS+CKDaVZpCAmzT2I9fc8kJOg3x8cAW5e
         32PdMlM1SZtCBMt2cBhFmC2Zggi3lH3xpEiqNrmslKNfknN2Ty6YM5D2pmY9OAuM2MtN
         4rkQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1765282359; x=1765887159;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=xPO/BvKGg7sBkLwEUPIfmAVXeNPbTgtzjvUBKwIinZM=;
        b=wzuFeYWlAN+X7ZpJ+W5qbOgmDkbhC498Wr4GWSjRzDnhLDziE50fkfC2s0i+b9Ogt6
         m4P+ul5kwKiqCT2MOlV+gOEWn2cvD+4L4+UvvEkG7EqV2qcrDyYFNsfX90Eg6eBsYBN4
         o7O7bi48xr8vgEEJsljkg+fhcepGubuOKCMcNSaBv3beZvzuYdRAwJAUG3ujDIfW5uiM
         5+igWQnI8SAI6nH9WYQ/2gMSkyezI+OdrnRrfFgS8sN6l42NB0j4Ri+p6Joohpb48IU5
         450UVzTeSYCb5R6kRtQzDzYOXuTtuA/rGcFSrCH8vvhMjDvH3hqJd8IJSEkpPw1/DCOb
         3RPg==
X-Forwarded-Encrypted: i=1; AJvYcCVQTh+8klKfIYTS15C9eAUEdU+IZmjcUUFcxBnkvMzfbPCuy5Z47LdC6w+RbB6iFgVwOQL4Qvk=@lists.linux.dev
X-Gm-Message-State: AOJu0YzbQN5uYRclVmf63yuoTrjuoPZb8iJ41FsKyQ37WXoUflq2pYiI
	vw59Vf2jgZVme4EpBnVUEKo9almaG78h5/6e7pDcUvd14nENaWEl8m8BwIVDBrGT/fVWCDbhA3d
	6klKRirmKFlyMUu/sPGFGxoplU4LYR+g=
X-Gm-Gg: ASbGncuQJTnrjWQGnNkw+PoE6DSzUAHf/YYimC1WwykpG3M5q9IUZWNDSEdXhylCEeg
	QsOX4EVZ+w+0v0TEM2PNfLIVMjXmafsUhOiR5+6l+fVRylbnM5nGv0rip0p45zBt2OruLPeH+zm
	Fd8WZ3sOU4S1DpSgj1zg4GdphmU6WSQ9Fs/wyrADyUwDSDAriM404doD1O8lSh89gRH+nmG2HtY
	cGTgO6YInYZYPWOKI2Pnkkdl1mdttBwzffkgtAOo8DyRM5xGm7FoMoiCtasv0zIpLYvq6U=
X-Google-Smtp-Source: AGHT+IEjEeVeN7jrrz6hBysMK/wp7Dao0ahhwFRlvs+E2NHCTRzvpL64IBfuIJom0oyae7nuV2pfZHPgKzBo5ZkBYdU=
X-Received: by 2002:a05:6820:1b19:b0:656:b1fb:a8fd with SMTP id
 006d021491bc7-6599a8a097fmr4639005eaf.1.1765282358807; Tue, 09 Dec 2025
 04:12:38 -0800 (PST)
Precedence: bulk
X-Mailing-List: syzbot@lists.linux.dev
List-Id: <syzbot.lists.linux.dev>
List-Subscribe: <mailto:syzbot+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:syzbot+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20251209031628.28429-1-kerneljasonxing@gmail.com> <6937d508.a70a0220.38f243.00c9.GAE@google.com>
In-Reply-To: <6937d508.a70a0220.38f243.00c9.GAE@google.com>
From: Jason Xing <kerneljasonxing@gmail.com>
Date: Tue, 9 Dec 2025 20:12:02 +0800
X-Gm-Features: AQt7F2oj04V18heapGTuW-sH7huLMZrlgW5Il7HJbcoA1PpdckVwNgFNVsARJoM
Message-ID: <CAL+tcoDfvz9fR4XK6FPH8Ng+OfF67UX86=fZL2xxZGnuA2Rs5g@mail.gmail.com>
Subject: Re: [syzbot ci] Re: xsk: move cq_cached_prod_lock to avoid touching a
 cacheline in sending path
To: syzbot ci <syzbot+ci28a5ab4f329a6a88@syzkaller.appspotmail.com>
Cc: ast@kernel.org, bjorn@kernel.org, bpf@vger.kernel.org, 
	daniel@iogearbox.net, davem@davemloft.net, edumazet@google.com, 
	hawk@kernel.org, john.fastabend@gmail.com, jonathan.lemon@gmail.com, 
	kernelxing@tencent.com, kuba@kernel.org, maciej.fijalkowski@intel.com, 
	magnus.karlsson@intel.com, netdev@vger.kernel.org, pabeni@redhat.com, 
	sdf@fomichev.me, syzbot@lists.linux.dev, syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Tue, Dec 9, 2025 at 3:52=E2=80=AFPM syzbot ci
<syzbot+ci28a5ab4f329a6a88@syzkaller.appspotmail.com> wrote:
>
> syzbot ci has tested the following series
>
> [v4] xsk: move cq_cached_prod_lock to avoid touching a cacheline in sendi=
ng path
> https://lore.kernel.org/all/20251209031628.28429-1-kerneljasonxing@gmail.=
com
> * [PATCH RFC net-next v4] xsk: move cq_cached_prod_lock to avoid touching=
 a cacheline in sending path
>
> and found the following issue:
> BUG: unable to handle kernel NULL pointer dereference in xp_create_and_as=
sign_umem
>
> Full report is available here:
> https://ci.syzbot.org/series/d7e166a7-a880-4ea1-9707-8889afd4ebe8
>
> ***
>
> BUG: unable to handle kernel NULL pointer dereference in xp_create_and_as=
sign_umem
>
> tree:      net-next
> URL:       https://kernel.googlesource.com/pub/scm/linux/kernel/git/netde=
v/net-next.git
> base:      0177f0f07886e54e12c6f18fa58f63e63ddd3c58
> arch:      amd64
> compiler:  Debian clang version 20.1.8 (++20250708063551+0c9f909b7976-1~e=
xp1~20250708183702.136), Debian LLD 20.1.8
> config:    https://ci.syzbot.org/builds/d327cc4b-7471-413b-b244-519c6d16d=
43b/config
> C repro:   https://ci.syzbot.org/findings/c8f7aeaf-0e2e-43dd-ae9c-ea2dd8d=
b8d34/c_repro
> syz repro: https://ci.syzbot.org/findings/c8f7aeaf-0e2e-43dd-ae9c-ea2dd8d=
b8d34/syz_repro

Interesting. Only rx logic is initialized while tx not. That causes
the cq_tmp to be uninitialized.

>
> UDPLite6: UDP-Lite is deprecated and scheduled to be removed in 2025, ple=
ase contact the netdev mailing list
> BUG: kernel NULL pointer dereference, address: 0000000000000058
> #PF: supervisor write access in kernel mode
> #PF: error_code(0x0002) - not-present page
> PGD 80000001b2496067 P4D 80000001b2496067 PUD 0
> Oops: Oops: 0002 [#1] SMP KASAN PTI
> CPU: 1 UID: 0 PID: 5973 Comm: syz.0.17 Not tainted syzkaller #0 PREEMPT(f=
ull)
> Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS 1.16.2-debian-1.=
16.2-1 04/01/2014
> RIP: 0010:lockdep_init_map_type+0x1e/0x380 kernel/locking/lockdep.c:4944
> Code: 90 90 90 90 90 90 90 90 90 90 90 90 f3 0f 1e fa 55 41 56 53 48 83 e=
c 10 89 cd 48 89 fb 65 48 8b 05 67 af d1 10 48 89 44 24 08 <48> c7 47 10 00=
 00 00 00 48 c7 47 08 00 00 00 00 8b 05 8c f2 dc 17
> RSP: 0018:ffffc90003c07bb8 EFLAGS: 00010286
> RAX: ec490cf5c114aa00 RBX: 0000000000000048 RCX: 0000000000000000
> RDX: ffffffff99d16120 RSI: ffffffff8c92a180 RDI: 0000000000000048
> RBP: 0000000000000000 R08: 0000000000000003 R09: 0000000000000000
> R10: ffffed102e5d7800 R11: fffffbfff1efa3cf R12: dffffc0000000000
> R13: ffff8881bdeb3000 R14: ffffffff99d16120 R15: ffffffff8c92a180
> FS:  00005555729bd500(0000) GS:ffff8882a9f31000(0000) knlGS:0000000000000=
000
> CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> CR2: 0000000000000058 CR3: 0000000172faa000 CR4: 00000000000006f0
> Call Trace:
>  <TASK>
>  lockdep_init_map_waits include/linux/lockdep.h:135 [inline]
>  lockdep_init_map_wait include/linux/lockdep.h:142 [inline]
>  __raw_spin_lock_init+0x45/0x100 kernel/locking/spinlock_debug.c:25

Using if-condition to check if cq_tmp is NULL would avoid the corruption.

Will add it in the next version.

Thanks,
Jason


>  xp_create_and_assign_umem+0x648/0xd40 net/xdp/xsk_buff_pool.c:94
>  xsk_bind+0x95a/0xf90 net/xdp/xsk.c:1355
>  __sys_bind_socket net/socket.c:1874 [inline]
>  __sys_bind+0x2c6/0x3e0 net/socket.c:1905
>  __do_sys_bind net/socket.c:1910 [inline]
>  __se_sys_bind net/socket.c:1908 [inline]
>  __x64_sys_bind+0x7a/0x90 net/socket.c:1908
>  do_syscall_x64 arch/x86/entry/syscall_64.c:63 [inline]
>  do_syscall_64+0xfa/0xfa0 arch/x86/entry/syscall_64.c:94
>  entry_SYSCALL_64_after_hwframe+0x77/0x7f
> RIP: 0033:0x7f591eb8f7c9
> Code: ff ff c3 66 2e 0f 1f 84 00 00 00 00 00 0f 1f 40 00 48 89 f8 48 89 f=
7 48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 ff=
 ff 73 01 c3 48 c7 c1 a8 ff ff ff f7 d8 64 89 01 48
> RSP: 002b:00007ffce6fcef48 EFLAGS: 00000246 ORIG_RAX: 0000000000000031
> RAX: ffffffffffffffda RBX: 00007f591ede5fa0 RCX: 00007f591eb8f7c9
> RDX: 0000000000000010 RSI: 0000200000000240 RDI: 0000000000000003
> RBP: 00007f591ebf297f R08: 0000000000000000 R09: 0000000000000000
> R10: 0000000000000000 R11: 0000000000000246 R12: 0000000000000000
> R13: 00007f591ede5fa0 R14: 00007f591ede5fa0 R15: 0000000000000003
>  </TASK>
> Modules linked in:
> CR2: 0000000000000058
> ---[ end trace 0000000000000000 ]---
> RIP: 0010:lockdep_init_map_type+0x1e/0x380 kernel/locking/lockdep.c:4944
> Code: 90 90 90 90 90 90 90 90 90 90 90 90 f3 0f 1e fa 55 41 56 53 48 83 e=
c 10 89 cd 48 89 fb 65 48 8b 05 67 af d1 10 48 89 44 24 08 <48> c7 47 10 00=
 00 00 00 48 c7 47 08 00 00 00 00 8b 05 8c f2 dc 17
> RSP: 0018:ffffc90003c07bb8 EFLAGS: 00010286
> RAX: ec490cf5c114aa00 RBX: 0000000000000048 RCX: 0000000000000000
> RDX: ffffffff99d16120 RSI: ffffffff8c92a180 RDI: 0000000000000048
> RBP: 0000000000000000 R08: 0000000000000003 R09: 0000000000000000
> R10: ffffed102e5d7800 R11: fffffbfff1efa3cf R12: dffffc0000000000
> R13: ffff8881bdeb3000 R14: ffffffff99d16120 R15: ffffffff8c92a180
> FS:  00005555729bd500(0000) GS:ffff8882a9f31000(0000) knlGS:0000000000000=
000
> CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> CR2: 0000000000000058 CR3: 0000000172faa000 CR4: 00000000000006f0
> ----------------
> Code disassembly (best guess):
>    0:   90                      nop
>    1:   90                      nop
>    2:   90                      nop
>    3:   90                      nop
>    4:   90                      nop
>    5:   90                      nop
>    6:   90                      nop
>    7:   90                      nop
>    8:   90                      nop
>    9:   90                      nop
>    a:   90                      nop
>    b:   90                      nop
>    c:   f3 0f 1e fa             endbr64
>   10:   55                      push   %rbp
>   11:   41 56                   push   %r14
>   13:   53                      push   %rbx
>   14:   48 83 ec 10             sub    $0x10,%rsp
>   18:   89 cd                   mov    %ecx,%ebp
>   1a:   48 89 fb                mov    %rdi,%rbx
>   1d:   65 48 8b 05 67 af d1    mov    %gs:0x10d1af67(%rip),%rax        #=
 0x10d1af8c
>   24:   10
>   25:   48 89 44 24 08          mov    %rax,0x8(%rsp)
> * 2a:   48 c7 47 10 00 00 00    movq   $0x0,0x10(%rdi) <-- trapping instr=
uction
>   31:   00
>   32:   48 c7 47 08 00 00 00    movq   $0x0,0x8(%rdi)
>   39:   00
>   3a:   8b 05 8c f2 dc 17       mov    0x17dcf28c(%rip),%eax        # 0x1=
7dcf2cc
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
