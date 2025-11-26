Received: from mail-ot1-f51.google.com (mail-ot1-f51.google.com [209.85.210.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 27CBA285071
	for <syzbot@lists.linux.dev>; Wed, 26 Nov 2025 08:13:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.51
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764144804; cv=none; b=AT10TphD4+VwTfQUcPDaZYKLxd+CNrkOIH1Wknt1kFuB7h8Op2HgwifBmNso12fGAhIHU/36DP7QProDPFs4NejOKTDja+SOYBEeR84gr/R948qQzV0RsSxN7NuzkUwY11u5+fjnGoQnyIqN0/CjaGTO13FNEyw9ppon0e07yQw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764144804; c=relaxed/simple;
	bh=eSIdUr7EPRZjezWgfIb/uh9XWEveB7c/IzGLutQFuXs=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=fuUDvPGpNOULGWO2m7wV/jc2WSPf3HHDwTkev8qw+iuLU4zopCTUiu5A1wxa5YDpBBhz4vZSWGAMpcWXptxdOiSpS8UCWN3jH3DCte1gU8J/KXywojytrvxNiLtSzQ41kyklYav+WtmuXjnG5ET3dYZyVgLU77epQW//M/Lf+D0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=3VoPmf3e; arc=none smtp.client-ip=209.85.210.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="3VoPmf3e"
Received: by mail-ot1-f51.google.com with SMTP id 46e09a7af769-7c7533dbd87so4472957a34.2
        for <syzbot@lists.linux.dev>; Wed, 26 Nov 2025 00:13:21 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1764144801; x=1764749601; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=PlcBV8zSULgfwMFJyMyaz/TGU93Napb7ToFhrDmYEDw=;
        b=3VoPmf3eLR9fqH2UYNLfw90Np8EORxl9nKank4rkQXsAVpOLS6LbYeIX/p3vQTiL+r
         IbUZXWj3BmlaFDDb2+HTSTjdggmVm9mplC473cBxBhaezKZzy8SP3/TePKXHMH/K8kgO
         Z8PgdGTlT8+qu2Izpc+WeX7eefxyioJgoNBpjTZcVAuJfzaVYCsoiH470jME30jzjUn1
         DDBCK5ky4iu1lkrXsel142kJLbhv/vpn3qFDBnDmyknw2D4Qu49QTNoBeJ6jFMMAJ+fZ
         E3hEH6uvRJ09Cwjic3dsHagySGiONhc+kstxWdiSJvQJUHXG6I5nDR93ih0yOLn+xp44
         QpMQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1764144801; x=1764749601;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=PlcBV8zSULgfwMFJyMyaz/TGU93Napb7ToFhrDmYEDw=;
        b=GjvwaBGmXKzJ0CuInVsgqbEYRmE6b+Z2t5OM64m99dfgiw1jmdb/u/lg3xd9RwvcMc
         Yvvvxl3aA1S1fMgfOGZKcgVtz3T4hbW5KKOHKiOHgOkPFYt8bk2d1Wwk5cK//cROdiNS
         Vyzul7dvivuQJjjwWtBzVIW8lnYKCqwTtFTcFQ0p4tVO/tbV2vmzcijshAGmv7j2YQAr
         7tlhD3ADx7sPGtHfFMoNWRg5O23SKrjIA/vXS6kZh++AN7AY4A/E7amEUftIqVJR2qVG
         DnsLGsEvMfhsaEnlloRX2w/w0dwkKUhbcRr+U0KvBZqHEvkTj6yW7OUcTudVuOajuvJT
         c7Rg==
X-Forwarded-Encrypted: i=1; AJvYcCUhvBWFx6XeRlhKe0k0LA5NFyj46u/nhw1QKDLZ+bkofZip2pA8B8yXSGnba8BW48RY2HN6OBY=@lists.linux.dev
X-Gm-Message-State: AOJu0YzReznnTMUrt+TTCQDiyDVju6kLJkpvEcftsJlsZxkoYA+Bkm9Q
	K16t6A9Syrxs/UixyB5SFVVNa0D5IV5bOdYxSs216CZqSdh3zTitUYIB4rNjkgilVkMymp61ZdI
	4DLfGnFx6qZXgBeRLn3vomJFlsTTDE21niFTvpVXF
X-Gm-Gg: ASbGncv5NUMvhZww6BbBar0P/3ABb3FOUMixbvFZl9s/V2sZ6WPnBxLMDcjMnAni6Bk
	WhWfHHVeTsth3XU5R4AlWbBXJz23ntFbPFsUs1/Ll9DX90qKxGMWwcsg1NMP3BS21d3pmLHKugo
	lxLSwiao6aUHP7AqFWjjjK4TN80DwT9Ylsawk/6R2PBFAV18uW5gF3J2lcTfQPnEiGmAR+YlmCa
	Gej5RQl7M84CBT7RzyT56PF0Ln13NvLGM9oBXYImfU3h3odGlhiYkTpn6Qh/L7SwVKBnnmqlGE/
	jE7dbjOsUZ9Z8f1uyKnEa+wr2lPcPtljE9I2p65BMSXv77ybQ1Lg8kcj09SUpnNR68gl
X-Google-Smtp-Source: AGHT+IGmLNRYH7O7IZVOKZV2E8c5mRZDegHTmvmS3YViSka5Ejrh8vH6cZHeoolTit+ahUg/dQ8ZnGGrZ5t4GjOd424=
X-Received: by 2002:a05:6830:a92:b0:7a0:239:809f with SMTP id
 46e09a7af769-7c7c412cb8fmr3144307a34.11.1764144800860; Wed, 26 Nov 2025
 00:13:20 -0800 (PST)
Precedence: bulk
X-Mailing-List: syzbot@lists.linux.dev
List-Id: <syzbot.lists.linux.dev>
List-Subscribe: <mailto:syzbot+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:syzbot+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <692686c2.a70a0220.d98e3.00ca.GAE@google.com>
In-Reply-To: <692686c2.a70a0220.d98e3.00ca.GAE@google.com>
From: Aleksandr Nogikh <nogikh@google.com>
Date: Wed, 26 Nov 2025 09:13:09 +0100
X-Gm-Features: AWmQ_blGOIhaSK8jxKniRu1nBaBeNdc5j2BhCXBmQv3zy7sAwUlfVNpwwvxfPAg
Message-ID: <CANp29Y7pSxnU8QO0WfTS2A+hX4KOK=R8kzjBnuhcLfQDvmbOVA@mail.gmail.com>
Subject: Re: [moderation/CI] Re: io_uring: avoid uring_lock for IORING_SETUP_SINGLE_ISSUER
To: syzbot ci <syzbot+ci1daaf56d0d213e2a@syzkaller.appspotmail.com>
Cc: syzkaller-upstream-moderation@googlegroups.com, syzbot@lists.linux.dev
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

#syz upstream


On Wed, Nov 26, 2025 at 5:49=E2=80=AFAM syzbot ci
<syzbot+ci1daaf56d0d213e2a@syzkaller.appspotmail.com> wrote:
>
> syzbot ci has tested the following series
>
> [v3] io_uring: avoid uring_lock for IORING_SETUP_SINGLE_ISSUER
> https://lore.kernel.org/all/20251125233928.3962947-1-csander@purestorage.=
com
> * [PATCH v3 1/4] io_uring: clear IORING_SETUP_SINGLE_ISSUER for IORING_SE=
TUP_SQPOLL
> * [PATCH v3 2/4] io_uring: use io_ring_submit_lock() in io_iopoll_req_iss=
ued()
> * [PATCH v3 3/4] io_uring: factor out uring_lock helpers
> * [PATCH v3 4/4] io_uring: avoid uring_lock for IORING_SETUP_SINGLE_ISSUE=
R
>
> and found the following issues:
> * SYZFAIL: failed to recv rpc
> * WARNING in io_ring_ctx_wait_and_kill
> * WARNING in io_uring_alloc_task_context
> * WARNING: suspicious RCU usage in io_eventfd_unregister
>
> Full report is available here:
> https://ci.syzbot.org/series/dde98852-0135-44b2-bbef-9ff9d772f924
>
> ***
>
> SYZFAIL: failed to recv rpc
>
> tree:      linux-next
> URL:       https://kernel.googlesource.com/pub/scm/linux/kernel/git/next/=
linux-next
> base:      92fd6e84175befa1775e5c0ab682938eca27c0b2
> arch:      amd64
> compiler:  Debian clang version 20.1.8 (++20250708063551+0c9f909b7976-1~e=
xp1~20250708183702.136), Debian LLD 20.1.8
> config:    https://ci.syzbot.org/builds/9d67ded7-d9a8-41e3-8b58-51340991c=
f96/config
> C repro:   https://ci.syzbot.org/findings/19ae4090-3486-4e2a-973e-dcb6ec3=
ba0d1/c_repro
> syz repro: https://ci.syzbot.org/findings/19ae4090-3486-4e2a-973e-dcb6ec3=
ba0d1/syz_repro
>
> SYZFAIL: failed to recv rpc
> fd=3D3 want=3D4 recv=3D0 n=3D0 (errno 9: Bad file descriptor)
>
>
> ***
>
> WARNING in io_ring_ctx_wait_and_kill
>
> tree:      linux-next
> URL:       https://kernel.googlesource.com/pub/scm/linux/kernel/git/next/=
linux-next
> base:      92fd6e84175befa1775e5c0ab682938eca27c0b2
> arch:      amd64
> compiler:  Debian clang version 20.1.8 (++20250708063551+0c9f909b7976-1~e=
xp1~20250708183702.136), Debian LLD 20.1.8
> config:    https://ci.syzbot.org/builds/9d67ded7-d9a8-41e3-8b58-51340991c=
f96/config
> C repro:   https://ci.syzbot.org/findings/f5ff9320-bf6f-40b4-a6b3-eee18fa=
83053/c_repro
> syz repro: https://ci.syzbot.org/findings/f5ff9320-bf6f-40b4-a6b3-eee18fa=
83053/syz_repro
>
> ------------[ cut here ]------------
> WARNING: io_uring/io_uring.h:266 at io_ring_ctx_lock io_uring/io_uring.h:=
266 [inline], CPU#0: syz.0.17/5967
> WARNING: io_uring/io_uring.h:266 at io_ring_ctx_wait_and_kill+0x35f/0x490=
 io_uring/io_uring.c:3119, CPU#0: syz.0.17/5967
> Modules linked in:
> CPU: 0 UID: 0 PID: 5967 Comm: syz.0.17 Not tainted syzkaller #0 PREEMPT(f=
ull)
> Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS 1.16.2-debian-1.=
16.2-1 04/01/2014
> RIP: 0010:io_ring_ctx_lock io_uring/io_uring.h:266 [inline]
> RIP: 0010:io_ring_ctx_wait_and_kill+0x35f/0x490 io_uring/io_uring.c:3119
> Code: 4e 11 48 3b 84 24 20 01 00 00 0f 85 1e 01 00 00 48 8d 65 d8 5b 41 5=
c 41 5d 41 5e 41 5f 5d c3 cc cc cc cc cc e8 92 fa 96 00 90 <0f> 0b 90 e9 be=
 fd ff ff 48 8d 7c 24 40 ba 70 00 00 00 31 f6 e8 08
> RSP: 0018:ffffc90004117b80 EFLAGS: 00010293
> RAX: ffffffff812ac5ee RBX: ffff88810d784000 RCX: ffff888104363a80
> RDX: 0000000000000000 RSI: 0000000000001000 RDI: 0000000000000000
> RBP: ffffc90004117d00 R08: ffffc90004117c7f R09: 0000000000000000
> R10: ffffc90004117c40 R11: fffff52000822f90 R12: 1ffff92000822f74
> R13: dffffc0000000000 R14: ffffc90004117c70 R15: 0000000000000000
> FS:  000055558ddb3500(0000) GS:ffff88818e88a000(0000) knlGS:0000000000000=
000
> CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> CR2: 00007f07135e7dac CR3: 00000001728f4000 CR4: 00000000000006f0
> Call Trace:
>  <TASK>
>  io_uring_create+0x6b6/0x940 io_uring/io_uring.c:3738
>  io_uring_setup io_uring/io_uring.c:3764 [inline]
>  __do_sys_io_uring_setup io_uring/io_uring.c:3798 [inline]
>  __se_sys_io_uring_setup+0x235/0x240 io_uring/io_uring.c:3789
>  do_syscall_x64 arch/x86/entry/syscall_64.c:63 [inline]
>  do_syscall_64+0xfa/0xf80 arch/x86/entry/syscall_64.c:94
>  entry_SYSCALL_64_after_hwframe+0x77/0x7f
> RIP: 0033:0x7f071338f749
> Code: ff ff c3 66 2e 0f 1f 84 00 00 00 00 00 0f 1f 40 00 48 89 f8 48 89 f=
7 48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 ff=
 ff 73 01 c3 48 c7 c1 a8 ff ff ff f7 d8 64 89 01 48
> RSP: 002b:00007fff80b05b58 EFLAGS: 00000246 ORIG_RAX: 00000000000001a9
> RAX: ffffffffffffffda RBX: 00007f07135e5fa0 RCX: 00007f071338f749
> RDX: 0000000000000000 RSI: 0000200000000040 RDI: 0000000000000024
> RBP: 00007f0713413f91 R08: 0000000000000000 R09: 0000000000000000
> R10: 0000000000000000 R11: 0000000000000246 R12: 0000000000000000
> R13: 00007f07135e5fa0 R14: 00007f07135e5fa0 R15: 0000000000000002
>  </TASK>
>
>
> ***
>
> WARNING in io_uring_alloc_task_context
>
> tree:      linux-next
> URL:       https://kernel.googlesource.com/pub/scm/linux/kernel/git/next/=
linux-next
> base:      92fd6e84175befa1775e5c0ab682938eca27c0b2
> arch:      amd64
> compiler:  Debian clang version 20.1.8 (++20250708063551+0c9f909b7976-1~e=
xp1~20250708183702.136), Debian LLD 20.1.8
> config:    https://ci.syzbot.org/builds/9d67ded7-d9a8-41e3-8b58-51340991c=
f96/config
> C repro:   https://ci.syzbot.org/findings/7aa56677-dbe1-4fdc-bbc4-cc701c1=
0fa7e/c_repro
> syz repro: https://ci.syzbot.org/findings/7aa56677-dbe1-4fdc-bbc4-cc701c1=
0fa7e/syz_repro
>
> ------------[ cut here ]------------
> WARNING: io_uring/io_uring.h:266 at io_ring_ctx_lock io_uring/io_uring.h:=
266 [inline], CPU#0: syz.0.17/5982
> WARNING: io_uring/io_uring.h:266 at io_init_wq_offload io_uring/tctx.c:23=
 [inline], CPU#0: syz.0.17/5982
> WARNING: io_uring/io_uring.h:266 at io_uring_alloc_task_context+0x677/0x8=
c0 io_uring/tctx.c:86, CPU#0: syz.0.17/5982
> Modules linked in:
> CPU: 0 UID: 0 PID: 5982 Comm: syz.0.17 Not tainted syzkaller #0 PREEMPT(f=
ull)
> Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS 1.16.2-debian-1.=
16.2-1 04/01/2014
> RIP: 0010:io_ring_ctx_lock io_uring/io_uring.h:266 [inline]
> RIP: 0010:io_init_wq_offload io_uring/tctx.c:23 [inline]
> RIP: 0010:io_uring_alloc_task_context+0x677/0x8c0 io_uring/tctx.c:86
> Code: d8 5b 41 5c 41 5d 41 5e 41 5f 5d c3 cc cc cc cc cc e8 3d ad 96 00 b=
b f4 ff ff ff eb ab e8 31 ad 96 00 eb 9c e8 2a ad 96 00 90 <0f> 0b 90 e9 12=
 fb ff ff 4c 8d 64 24 60 4c 8d b4 24 f0 00 00 00 ba
> RSP: 0018:ffffc90003dcf9c0 EFLAGS: 00010293
> RAX: ffffffff812b1356 RBX: 0000000000000000 RCX: ffff8881777957c0
> RDX: 0000000000000000 RSI: 0000000000001000 RDI: 0000000000000000
> RBP: ffffc90003dcfb50 R08: ffffffff8f7de377 R09: 1ffffffff1efbc6e
> R10: dffffc0000000000 R11: fffffbfff1efbc6f R12: ffff8881052bf000
> R13: ffff888104bf2000 R14: 0000000000001000 R15: 1ffff1102097e400
> FS:  00005555613bd500(0000) GS:ffff88818e88a000(0000) knlGS:0000000000000=
000
> CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> CR2: 00007f7773fe7dac CR3: 000000016cd1c000 CR4: 00000000000006f0
> Call Trace:
>  <TASK>
>  __io_uring_add_tctx_node+0x455/0x710 io_uring/tctx.c:112
>  io_uring_create+0x559/0x940 io_uring/io_uring.c:3719
>  io_uring_setup io_uring/io_uring.c:3764 [inline]
>  __do_sys_io_uring_setup io_uring/io_uring.c:3798 [inline]
>  __se_sys_io_uring_setup+0x235/0x240 io_uring/io_uring.c:3789
>  do_syscall_x64 arch/x86/entry/syscall_64.c:63 [inline]
>  do_syscall_64+0xfa/0xf80 arch/x86/entry/syscall_64.c:94
>  entry_SYSCALL_64_after_hwframe+0x77/0x7f
> RIP: 0033:0x7f7773d8f749
> Code: ff ff c3 66 2e 0f 1f 84 00 00 00 00 00 0f 1f 40 00 48 89 f8 48 89 f=
7 48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 ff=
 ff 73 01 c3 48 c7 c1 a8 ff ff ff f7 d8 64 89 01 48
> RSP: 002b:00007ffe094f0b68 EFLAGS: 00000246 ORIG_RAX: 00000000000001a9
> RAX: ffffffffffffffda RBX: 00007f7773fe5fa0 RCX: 00007f7773d8f749
> RDX: 0000000000000000 RSI: 0000200000000780 RDI: 0000000000000f08
> RBP: 00007f7773e13f91 R08: 0000000000000000 R09: 0000000000000000
> R10: 0000000000000000 R11: 0000000000000246 R12: 0000000000000000
> R13: 00007f7773fe5fa0 R14: 00007f7773fe5fa0 R15: 0000000000000002
>  </TASK>
>
>
> ***
>
> WARNING: suspicious RCU usage in io_eventfd_unregister
>
> tree:      linux-next
> URL:       https://kernel.googlesource.com/pub/scm/linux/kernel/git/next/=
linux-next
> base:      92fd6e84175befa1775e5c0ab682938eca27c0b2
> arch:      amd64
> compiler:  Debian clang version 20.1.8 (++20250708063551+0c9f909b7976-1~e=
xp1~20250708183702.136), Debian LLD 20.1.8
> config:    https://ci.syzbot.org/builds/9d67ded7-d9a8-41e3-8b58-51340991c=
f96/config
> C repro:   https://ci.syzbot.org/findings/84c08f15-f4f9-4123-b889-1d8d19f=
3e0b1/c_repro
> syz repro: https://ci.syzbot.org/findings/84c08f15-f4f9-4123-b889-1d8d19f=
3e0b1/syz_repro
>
> =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D
> WARNING: suspicious RCU usage
> syzkaller #0 Not tainted
> -----------------------------
> io_uring/eventfd.c:160 suspicious rcu_dereference_protected() usage!
>
> other info that might help us debug this:
>
>
> rcu_scheduler_active =3D 2, debug_locks =3D 1
> 2 locks held by kworker/u10:12/3941:
>  #0: ffff888168f41148 ((wq_completion)iou_exit){+.+.}-{0:0}, at: process_=
one_work+0x841/0x15a0 kernel/workqueue.c:3236
>  #1: ffffc90021f3fb80 ((work_completion)(&ctx->exit_work)){+.+.}-{0:0}, a=
t: process_one_work+0x868/0x15a0 kernel/workqueue.c:3237
>
> stack backtrace:
> CPU: 1 UID: 0 PID: 3941 Comm: kworker/u10:12 Not tainted syzkaller #0 PRE=
EMPT(full)
> Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS 1.16.2-debian-1.=
16.2-1 04/01/2014
> Workqueue: iou_exit io_ring_exit_work
> Call Trace:
>  <TASK>
>  dump_stack_lvl+0x189/0x250 lib/dump_stack.c:120
>  lockdep_rcu_suspicious+0x140/0x1d0 kernel/locking/lockdep.c:6876
>  io_eventfd_unregister+0x18b/0x1c0 io_uring/eventfd.c:159
>  io_ring_ctx_free+0x18a/0x820 io_uring/io_uring.c:2882
>  io_ring_exit_work+0xe71/0x1030 io_uring/io_uring.c:3110
>  process_one_work+0x93a/0x15a0 kernel/workqueue.c:3261
>  process_scheduled_works kernel/workqueue.c:3344 [inline]
>  worker_thread+0x9b0/0xee0 kernel/workqueue.c:3425
>  kthread+0x711/0x8a0 kernel/kthread.c:463
>  ret_from_fork+0x599/0xb30 arch/x86/kernel/process.c:158
>  ret_from_fork_asm+0x1a/0x30 arch/x86/entry/entry_64.S:246
>  </TASK>
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
> [axboe@kernel.dk csander@purestorage.com io-uring@vger.kernel.org linux-k=
ernel@vger.kernel.org]
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
-upstream-moderation/692686c2.a70a0220.d98e3.00ca.GAE%40google.com.
