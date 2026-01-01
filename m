Received: from mail-oo1-f44.google.com (mail-oo1-f44.google.com [209.85.161.44])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2AA9CA59
	for <syzbot@lists.linux.dev>; Thu,  1 Jan 2026 09:45:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.161.44
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767260717; cv=none; b=eOsffrgEBKllagY28OjTUKaHjn3zg+g+aMl1YbNu+zMUaTpbzAm/8uuqVvkVgl9pCBC172nGvVs3n9U1gal4fbu9A2Oqn7FKRa21OsjepipICGY5fA3tPxYDwXKGFXtw4IdSWy93RNg5JT3G79jkjkfY2jmqD0lb5HFuwm1fZUs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767260717; c=relaxed/simple;
	bh=HdzMcBO1XQ08Kld3UuRhd5/NdG18BdCv/Tbe1mpR01I=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=fyk3zdkW1wEw/VIs9t+r+S1un5ZzgDRvBRBiDxDCIaH5BYuWX19ZPiZk+atK5nNcsw4y54B5TeKVtdBSy3qEMUvL8aBnq06yslA7H4Zf7+og48n0huQ8lEvDyVAkyL48t/vhepKR4dbwdaL7oWERbUZP42G8/88NsC/78zQ/rgM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=EVROvKeN; arc=none smtp.client-ip=209.85.161.44
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="EVROvKeN"
Received: by mail-oo1-f44.google.com with SMTP id 006d021491bc7-65d0441b6feso6266331eaf.1
        for <syzbot@lists.linux.dev>; Thu, 01 Jan 2026 01:45:14 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1767260714; x=1767865514; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=B0gg3/nXb9/4+Eye1C86I58fprmByPo6g5tIKye67zY=;
        b=EVROvKeN7nQRuV+r/R0RCjWbazxQCI1aKe0OEVVPHdsEVXmNIej1rBZVqci9Gxryaq
         h+5fOKq2QlwvbzEG0jwV5hWl86hWD/++udoQ2QuoJ24hrmO/VcEAii0eQohfK+Pewrs0
         loGTXc+Lto7bXWUfRg7Tj9bIlNWJ6/aagQIajQIPSMt1Ucb9yL8wk4yTdVbsb/KBBnrw
         a0IgmBYwDH2cfzWi2c2/hO3zlWjBquZz994nD8NQktgNgOfcFsC8r26o0muEcZpaoUTS
         66LVuUr7GVrTrrG81wRyVd4JjHKOTdYA6n9AF258rMfhJpOqFYHcGPbSiJ+p1ALSKrlK
         O2GQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1767260714; x=1767865514;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=B0gg3/nXb9/4+Eye1C86I58fprmByPo6g5tIKye67zY=;
        b=aHeZzr9QsSaybD5kRqVrYQbSFl90JzOBublI67GIjckOejZH4U8Ze9dzuXel+ZXLB3
         NNUtENJvrFKik9yVOwkUtHV1bORs8v4sk7dE8n5xf5wa9pGYSnmnB1bbEVlS/2b+6En0
         7fVkEMcI6/5OD9/iACnhpFQmVTFGaV6QD8XWpH1AKCrmllim4+2Lxn2EOualXeTR0ls8
         TeDFh99fjFnsAtUdHautcwkDGXdK2kM8YX7BGCNzhy12r51thcoE54T60Y4Eh+ugxdMf
         3bAdTIU1HFv/uobRDnrtb36HpxP7bSK9tcSRPdSdPSaw2TR2AETI8WWCcRGTBRAJUZ5v
         qt9Q==
X-Forwarded-Encrypted: i=1; AJvYcCX1F6FoB9sJcDww5LJEEttUIJkSf5pOurmYc9J77MRHqI6/ks/WoeZukRDO8jFLwWzK46EvBp4=@lists.linux.dev
X-Gm-Message-State: AOJu0Yz3zauGLQaGmbKwKszwmVrYK/NR2alMlQWwgegz4GYMEkAUnWcK
	k4tmZ/jNcWiODYpxazEnAuJwr5OhUZIuPgoldSARTjAAoespi8/z8I50UyMzfUPsUYS2mP1GDom
	bp7G1AF7YPqa9HAqRcXDl/10c7fjp2D3XQ9ufZRrn
X-Gm-Gg: AY/fxX5rBMV191oXyVThU3BYoGqVuM+LkNF8qkp4GyrVi8qNJIjC4PIvKzPYM/+eGWl
	9Vl7XI/h42bG5PMJ/SQBqwJaCTGzLe7xrRXKPUesxX1+n2hBo1icvYHUF7anAqF38lelICkkKqg
	lLCBssppdYtzWVd7XwlYjji/El+lGpr8MFaI0wEGuzm0wzOmLGvXFL6X+KEZyjiQlFLUUoP3P6J
	Kx0j90c0xu1zvl7jSrMyclYdS6ILN0Nx2nHgVjzxQFYvpIIroZL+04ziqPRddolctZX+vRr5NA1
	2hZeST1R0iC5VcWcdrC+P14zmqcGiDFvFR005g+O9Rl5o2ADxb+WbzO0l78r
X-Google-Smtp-Source: AGHT+IFmb24sh+QUSJ7ZeQYibJTakYChI5RniF9PwECUfW+pGQoUhtrOYnzt1qrRjFdBQRFNHtYBvkTPVko39Y/NsDM=
X-Received: by 2002:a05:6820:1626:b0:65c:f583:d3cd with SMTP id
 006d021491bc7-65d0eab7e3fmr18283555eaf.55.1767260713704; Thu, 01 Jan 2026
 01:45:13 -0800 (PST)
Precedence: bulk
X-Mailing-List: syzbot@lists.linux.dev
List-Id: <syzbot.lists.linux.dev>
List-Subscribe: <mailto:syzbot+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:syzbot+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <69557e08.050a0220.a1b6.0325.GAE@google.com>
In-Reply-To: <69557e08.050a0220.a1b6.0325.GAE@google.com>
From: Aleksandr Nogikh <nogikh@google.com>
Date: Thu, 1 Jan 2026 10:45:02 +0100
X-Gm-Features: AQt7F2r9iQJ3vvYjOXWqNCTMwNj2XCXcqx5kLqZQVh7DPSvYkbe2CX-MvRvpe0I
Message-ID: <CANp29Y7OUOZ+UDhkuWnmQik_A1EyKuzc=0UmP4YnDmDcx=QE4A@mail.gmail.com>
Subject: Re: [moderation/CI] Re: io_uring/tctx: add separate lock for list of
 tctx's in ctx
To: syzbot ci <syzbot+cib7d927ffb96bcac0@syzkaller.appspotmail.com>
Cc: syzkaller-upstream-moderation@googlegroups.com, syzbot@lists.linux.dev
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

#syz upstream

On Wed, Dec 31, 2025 at 8:48=E2=80=AFPM syzbot ci
<syzbot+cib7d927ffb96bcac0@syzkaller.appspotmail.com> wrote:
>
> syzbot ci has tested the following series
>
> [v1] io_uring/tctx: add separate lock for list of tctx's in ctx
> https://lore.kernel.org/all/4cffd2b8-e7c9-48df-9207-0df6e3d5c6ce@kernel.d=
k
> * [PATCH] io_uring/tctx: add separate lock for list of tctx's in ctx
>
> and found the following issue:
> WARNING in __io_async_cancel
>
> Full report is available here:
> https://ci.syzbot.org/series/98951813-facd-4de5-8d20-609c804dc446
>
> ***
>
> WARNING in __io_async_cancel
>
> tree:      torvalds
> URL:       https://kernel.googlesource.com/pub/scm/linux/kernel/git/torva=
lds/linux
> base:      f8f9c1f4d0c7a64600e2ca312dec824a0bc2f1da
> arch:      amd64
> compiler:  Debian clang version 21.1.8 (++20251202083448+f68f64eb8130-1~e=
xp1~20251202083504.46), Debian LLD 21.1.8
> config:    https://ci.syzbot.org/builds/9e0d952e-d592-4cca-9208-4b87430b4=
e6f/config
> C repro:   https://ci.syzbot.org/findings/103d3164-79b9-4a03-bdf3-9bb0579=
61994/c_repro
> syz repro: https://ci.syzbot.org/findings/103d3164-79b9-4a03-bdf3-9bb0579=
61994/syz_repro
>
> ------------[ cut here ]------------
> do not call blocking ops when !TASK_RUNNING; state=3D1 set at [<ffffffff8=
19c3a04>] prepare_to_wait+0x174/0x210 kernel/sched/wait.c:256
> WARNING: kernel/sched/core.c:8754 at __might_sleep+0x92/0xf0 kernel/sched=
/core.c:8750, CPU#1: syz.0.17/5989
> Modules linked in:
> CPU: 1 UID: 0 PID: 5989 Comm: syz.0.17 Not tainted syzkaller #0 PREEMPT(f=
ull)
> Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS 1.16.2-debian-1.=
16.2-1 04/01/2014
> RIP: 0010:__might_sleep+0xac/0xf0 kernel/sched/core.c:8750
> Code: 00 00 48 89 3c 24 41 89 f5 4c 8d 35 6e 25 32 0e 43 80 3c 3c 00 74 0=
8 48 89 df e8 0f 31 96 00 48 8b 0b 4c 89 f7 89 ee 48 89 ca <67> 48 0f b9 3a=
 44 89 ee 48 8b 3c 24 eb b5 44 89 f1 80 e1 07 80 c1
> RSP: 0018:ffffc90003c57960 EFLAGS: 00010246
> RAX: 0000000000000000 RBX: ffff888112e4ef78 RCX: ffffffff819c3a04
> RDX: ffffffff819c3a04 RSI: 0000000000000001 RDI: ffffffff8fc561c0
> RBP: 0000000000000001 R08: ffffc90003c57ac7 R09: 0000000000000000
> R10: ffffc90003c57aa0 R11: fffff5200078af59 R12: 1ffff110225c9def
> R13: 000000000000024f R14: ffffffff8fc561c0 R15: dffffc0000000000
> FS:  0000555558120500(0000) GS:ffff8882a9a0f000(0000) knlGS:0000000000000=
000
> CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> CR2: 00002000000001c0 CR3: 00000001165c4000 CR4: 00000000000006f0
> Call Trace:
>  <TASK>
>  __mutex_lock_common kernel/locking/mutex.c:591 [inline]
>  __mutex_lock+0x119/0x1340 kernel/locking/mutex.c:776
>  __io_async_cancel+0x183/0x490 io_uring/cancel.c:188
>  __io_sync_cancel io_uring/cancel.c:258 [inline]
>  io_sync_cancel+0x7d2/0x940 io_uring/cancel.c:322
>  __io_uring_register io_uring/register.c:761 [inline]
>  __do_sys_io_uring_register io_uring/register.c:921 [inline]
>  __se_sys_io_uring_register+0xe1b/0x12a0 io_uring/register.c:898
>  do_syscall_x64 arch/x86/entry/syscall_64.c:63 [inline]
>  do_syscall_64+0xe2/0xf80 arch/x86/entry/syscall_64.c:94
>  entry_SYSCALL_64_after_hwframe+0x77/0x7f
> RIP: 0033:0x7fc802f9acb9
> Code: ff c3 66 2e 0f 1f 84 00 00 00 00 00 0f 1f 44 00 00 48 89 f8 48 89 f=
7 48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 ff=
 ff 73 01 c3 48 c7 c1 e8 ff ff ff f7 d8 64 89 01 48
> RSP: 002b:00007ffe5ca81768 EFLAGS: 00000246 ORIG_RAX: 00000000000001ab
> RAX: ffffffffffffffda RBX: 00007fc803205fa0 RCX: 00007fc802f9acb9
> RDX: 00002000000001c0 RSI: 0000000000000018 RDI: 0000000000000003
> RBP: 00007fc803008bf7 R08: 0000000000000000 R09: 0000000000000000
> R10: 0000000000000001 R11: 0000000000000246 R12: 0000000000000000
> R13: 00007fc803205fac R14: 00007fc803205fa0 R15: 00007fc803205fa0
>  </TASK>
> ----------------
> Code disassembly (best guess):
>    0:   00 00                   add    %al,(%rax)
>    2:   48 89 3c 24             mov    %rdi,(%rsp)
>    6:   41 89 f5                mov    %esi,%r13d
>    9:   4c 8d 35 6e 25 32 0e    lea    0xe32256e(%rip),%r14        # 0xe3=
2257e
>   10:   43 80 3c 3c 00          cmpb   $0x0,(%r12,%r15,1)
>   15:   74 08                   je     0x1f
>   17:   48 89 df                mov    %rbx,%rdi
>   1a:   e8 0f 31 96 00          call   0x96312e
>   1f:   48 8b 0b                mov    (%rbx),%rcx
>   22:   4c 89 f7                mov    %r14,%rdi
>   25:   89 ee                   mov    %ebp,%esi
>   27:   48 89 ca                mov    %rcx,%rdx
> * 2a:   67 48 0f b9 3a          ud1    (%edx),%rdi <-- trapping instructi=
on
>   2f:   44 89 ee                mov    %r13d,%esi
>   32:   48 8b 3c 24             mov    (%rsp),%rdi
>   36:   eb b5                   jmp    0xffffffed
>   38:   44 89 f1                mov    %r14d,%ecx
>   3b:   80 e1 07                and    $0x7,%cl
>   3e:   80                      .byte 0x80
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
> [axboe@kernel.dk io-uring@vger.kernel.org]
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
-upstream-moderation/69557e08.050a0220.a1b6.0325.GAE%40google.com.
