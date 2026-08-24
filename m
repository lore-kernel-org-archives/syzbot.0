Received: from mail-qt1-f172.google.com (mail-qt1-f172.google.com [209.85.160.172])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DD1252F6565
	for <syzbot@lists.linux.dev>; Mon, 24 Aug 2026 07:52:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.160.172
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787557961; cv=pass; b=VTkVEy/8PCoGn81arfHSMjEm/QPY1ZDHT/24b9U1XplnR0qo73u0XvbcWdNnQfUWkbyxNq3Z2Y6o4JYW2+NyVspTvxYSfQYVKclXOlllts35+adEYS/ExTbC+Qe1vtXv/uKrevJTZOnE2mrdgMLn/m516N8YHKjEFUxg/r06R+g=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787557961; c=relaxed/simple;
	bh=d6UrKcVKejLC6LGSHEemXexU9qKiqXn+jlJWjAiwHgQ=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=fSMdE4SAJgBWx9kn0kiAAFkH50hv/ppZmZk3n3pp0a9lrnztsNHVTkAblYGH8fK4Xmw8+P2ysEMA+dElP/8OYSxNpwykI3v18GWALLxfYrbCwsoe5eOTOMhCLwDmhe10bfTUcz+9KWSUNRXweAOdBY8pW6x637GUXnB2Oot7ndo=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=Ht8AYfrz; arc=pass smtp.client-ip=209.85.160.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="Ht8AYfrz"
Received: by mail-qt1-f172.google.com with SMTP id d75a77b69052e-529a1ee0e62so20353511cf.2
        for <syzbot@lists.linux.dev>; Mon, 24 Aug 2026 00:52:38 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1787557958; cv=none;
        d=google.com; s=arc-20260327;
        b=r+w4zzJo4t6+uD18VvSyR1EzLz7vqOFjS5c8jZ5iDJ1SJk5hi53ne8UF1koPORNiVc
         SofpVoz7dyWtOl/4yE1tyezO8Np9Xoct/F18pjDEwNzlxBb4tGWsURZTIKw79OxvI/M0
         aR5g63kdbUZM9PrUHaC+hxz6iyPJb2dcbo9nArTs6O4JWgTM7ZM4GRBIFOIVRJX+o0DK
         xQJnK+FLeRU683Sg7rKhSAmH+DLjUOMgHCi15XgokTbB/9ebJMIlDFPP3lXFlAYjKH98
         PAKZBatEyWPabqyrsTYDAyWGZUze6B7O2+1KKnPcSwkl9Efb3WU301Npd9i1hAAEPV88
         zTYQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=2j3IFuUsBIqcFrA5THuP2NELNq+SzqFE1Y7Lk6AVdAM=;
        fh=aDVQ7jBDKjbP4axONLLsMgi13Ilm7BWf7lzI7bMngvQ=;
        b=WF0MOSCYjSF7eRXe+KuU3G8vqiQEqDc7SGF9FO6rBQn0e/qlQ6KO12GEY8CXuLNM3t
         EbR/RpWog1aM8H3Xhr3wr+6pqKt8HTH3bWizwF5/TJ36h8DX6CqbzVL58J9FVPNN/n6D
         RN/ln5gfeVYtp5/IkXWx2CWhT2qoV8Ac090RWt7IPHlwPuaZLNAWM0NScoITFtKj+1Gg
         4cWVjnohkZBHPpU9TisNDvqWQdHL0Rvnu6FJFoKhJ3JdTjkm1tjJk+PIN/RdGwgJA80d
         igwyi1jmhNSW0f4c/9iz42gIXTgzJp9z7f/n1SQSjQ8JYWKMUwWPnqSaBtRY5ja1vCRz
         ia8Q==;
        darn=lists.linux.dev
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1787557958; x=1788162758; darn=lists.linux.dev;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=2j3IFuUsBIqcFrA5THuP2NELNq+SzqFE1Y7Lk6AVdAM=;
        b=Ht8AYfrz21vGqk7hXUBUDfUoy4vWAEW9ym9MEs99gdFLsvRwysT4nsFxYU+HiBv+J4
         hD4AD7ZqqUsXWf6dYfETG4d3t93YlbKLXjDJS8ROf2+o2SNGdasJ+mAPnLg0sdfKSFRv
         8nVFYkVHedEsFED2uOBRgg+SPpTeiHspfEXb4YvxZj3kKc2mg+u54anAd7PSM5rZtnQz
         q5KLOz90Peuh5thye/XANNzdJWo9hpok8pyJA/r2+FETT3L+O+5S0vYRw1G/mV8fTxlc
         Wt8Q7eXiuVc33WHnebfsLoVZ9mn02gdQ1cp3reDkbUQwXu0X9guOOWi2PeWFztyoNKRg
         X1xQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1787557958; x=1788162758;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=2j3IFuUsBIqcFrA5THuP2NELNq+SzqFE1Y7Lk6AVdAM=;
        b=LjKs2aMzFpB0QHRDZrr24/7jqsq6jnyhckpUvDO8EF862t53mqsAjCGPZrp0CaFUEg
         T3DQngMPslqZiXkA7AiSI+PHZ5lXEoK9M/gQDBkvSaq4jL0YtKWq3B9aJIR1DjSyqEvf
         6JxdzTFfnYoaAdisgEXn/pdK26RP42OL5Ml9XvH/6IR8fCPN4YPhVwm0BaN10QBvn6a2
         lz8maOpT4qjEzoch+LH1/NYCc5EPaLmXnCqIzNntz7mZfVqDGntBbVB9XB85uz2+3S7u
         z3shuoky1zCb+jvydnRakm/H+JaAcfjLeu89DIQ0+5eM3L/iaE8Iy4IH+uzAkYXP14jV
         Z3Dg==
X-Forwarded-Encrypted: i=1; AHgh+RqQWu3pu0BAZrdCX1lpwpOogXl/VYnVxqnmGeZInm38m9nfRov8zk7HEwTYrjvIVSwycZn8YtA=@lists.linux.dev
X-Gm-Message-State: AFuF++kjRIfPMMEo5AXLuBEEJ7jupoR/m+bpsdfXBImLethY0zvkVCbn
	jJkQEBuumj+6p4k8xd12SB62uUQtxC7vRsCWXBi3WIQyodyUixGUbq2mBk0L8KIUNOHWfDTny7h
	oRBhWMc0lNDxDggTDxCJl25y/d1n18na20699miy5t4eWJ9x8MnwlDUbx
X-Gm-Gg: AR+sD13uQ7LY3EWpFoGV0Mu+WoIuQYmtQVDTarilzWTWm3O3uVucWwAe2bSWsK3NSVP
	ILR6jYPiAIEszOv9WfgHVeBW3ekwNuk2eKj8P7EsVBXF0XtkXEazcegpmJVirl3P/SJfyPTInou
	ECmuRBizBMvauw3Q5q0eHYBA5I2lLCAHX6oBHBWbcNlz3UaNUFyosqEaL0RWar8+QSlsiXlgvI8
	Eknc6G+F/J4OG87S2XGF35eDr2d95xQvOpGJIEa/F0AvFmABruf4A7LrvAmvveNEiLds7/6VQl8
	MWsadVWlF5gPVJVxrnLzlZmMiSXLkX67TvSenYxsGtlFXoilnhSm9aEtj5rOBnCUA7SFU6P1rWg
	MRNEIMSRkVEPWPQvllcv0CffAE3AoLHCNUKo=
X-Received: by 2002:ac8:58c2:0:b0:51a:89c1:1eef with SMTP id
 d75a77b69052e-52df574088bmr243963021cf.14.1787557956907; Mon, 24 Aug 2026
 00:52:36 -0700 (PDT)
Precedence: bulk
X-Mailing-List: syzbot@lists.linux.dev
List-Id: <syzbot.lists.linux.dev>
List-Subscribe: <mailto:syzbot+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:syzbot+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <6a89625a.91706f20.16b6e3.02b2.GAE@google.com>
In-Reply-To: <6a89625a.91706f20.16b6e3.02b2.GAE@google.com>
From: Pimyn Girgis <pimyn@google.com>
Date: Mon, 24 Aug 2026 09:52:25 +0200
X-Gm-Features: AcwNN1XPqD94hgnnQzzWERAQzZz2gylqnoSH2qGAfAjSDS4anF3VRguR0HJa818
Message-ID: <CAJWNTGwE6uc0+JkQm2y6GZsxZpDt+=f01TVjHo8azqFOKdwDzA@mail.gmail.com>
Subject: Re: [moderation/CI] Re: fs: fix s_fs_info leak when
 setup_bdev_super() fails
To: syzbot ci <syzbot+ci17d6596a3653cfb2@syzkaller.appspotmail.com>
Cc: syzkaller-upstream-moderation@googlegroups.com, syzbot@lists.linux.dev
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

#syz upstream


On Sat, Aug 22, 2026 at 10:48=E2=80=AFAM syzbot ci
<syzbot+ci17d6596a3653cfb2@syzkaller.appspotmail.com> wrote:
>
> syzbot ci has tested the following series
>
> [v1] fs: fix s_fs_info leak when setup_bdev_super() fails
> https://lore.kernel.org/all/20260822023918.2498361-1-hanzhijian1991@gmail=
.com
> * [PATCH] fs: fix s_fs_info leak when setup_bdev_super() fails
>
> and found the following issues:
> * general protection fault in call_rcu
> * general protection fault in erofs_kill_sb
> * general protection fault in fuse_kill_sb_blk
> * general protection fault in xfs_kill_sb
>
> Full report is available here:
> https://ci.syzbot.org/series/1ef55243-f163-4d98-bbd1-41b579082704
>
> ***
>
> general protection fault in call_rcu
>
> tree:      torvalds
> URL:       https://kernel.googlesource.com/pub/scm/linux/kernel/git/torva=
lds/linux
> base:      26260251022fbc2f248a3d747a9b2b961b18d2d8
> arch:      amd64
> compiler:  Debian clang version 22.1.8 (++20260613092233+e80beda6e255-1~e=
xp1~20260613092250.77), Debian LLD 22.1.8
> config:    https://ci.syzbot.org/builds/41c2a7e2-d41f-466f-8380-e05ef414b=
f62/config
> syz repro: https://ci.syzbot.org/findings/f6ebcbaf-d8f4-4c25-9e68-98f4674=
0729d/syz_repro
>
> /dev/sr0: Can't open blockdev
> Oops: general protection fault, probably for non-canonical address 0xdfff=
fc000000005a: 0000 [#1] SMP KASAN PTI
> KASAN: null-ptr-deref in range [0x00000000000002d0-0x00000000000002d7]
> CPU: 0 UID: 0 PID: 5792 Comm: syz.0.17 Not tainted syzkaller #0 PREEMPT(f=
ull)
> Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS 1.16.2-debian-1.=
16.2-1 04/01/2014
> RIP: 0010:__call_rcu_common kernel/rcu/tree.c:3157 [inline]
> RIP: 0010:call_rcu+0xb9/0x8b0 kernel/rcu/tree.c:3279
> Code: 48 c1 e8 03 42 80 3c 28 00 74 08 48 89 df e8 0e eb 8a 00 48 c7 03 c=
0 9a ac 81 e9 b3 05 00 00 48 8d 7b 08 48 89 f8 48 c1 e8 03 <42> 80 3c 28 00=
 74 05 e8 eb ea 8a 00 4c 89 73 08 48 89 d8 48 c1 e8
> RSP: 0018:ffffc900041dfb08 EFLAGS: 00010206
> RAX: 000000000000005a RBX: 00000000000002c8 RCX: ffffffff9a9ab501
> RDX: 0000000000000001 RSI: ffffffff8e46456f RDI: 00000000000002d0
> RBP: 0000000000000000 R08: ffffffff90793d37 R09: 1ffffffff20f27a6
> R10: dffffc0000000000 R11: fffffbfff20f27a7 R12: dffffc0000000000
> R13: dffffc0000000000 R14: ffffffff82b4b6c0 R15: ffff88811e37e7a0
> FS:  00007f1ef40546c0(0000) GS:ffff88818d708000(0000) knlGS:0000000000000=
000
> CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> CR2: 00007f1ef4053ff8 CR3: 0000000173ace000 CR4: 00000000000006f0
> Call Trace:
>  <TASK>
>  deactivate_locked_super+0xbc/0x110 fs/super.c:603
>  get_tree_bdev_flags+0x40e/0x560 fs/super.c:1895
>  vfs_get_tree+0x92/0x2a0 fs/super.c:1958
>  fc_mount fs/namespace.c:1198 [inline]
>  do_new_mount_fc fs/namespace.c:3772 [inline]
>  do_new_mount+0x319/0xdc0 fs/namespace.c:3848
>  do_mount fs/namespace.c:4181 [inline]
>  __do_sys_mount fs/namespace.c:4397 [inline]
>  __se_sys_mount+0x31d/0x420 fs/namespace.c:4374
>  do_syscall_x64 arch/x86/entry/syscall_64.c:61 [inline]
>  do_syscall_64+0x166/0x520 arch/x86/entry/syscall_64.c:84
>  entry_SYSCALL_64_after_hwframe+0x77/0x7f
> RIP: 0033:0x7f1ef319e0d9
> Code: ff c3 66 2e 0f 1f 84 00 00 00 00 00 0f 1f 44 00 00 48 89 f8 48 89 f=
7 48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 ff=
 ff 73 01 c3 48 c7 c1 e8 ff ff ff f7 d8 64 89 01 48
> RSP: 002b:00007f1ef4054028 EFLAGS: 00000246 ORIG_RAX: 00000000000000a5
> RAX: ffffffffffffffda RBX: 00007f1ef3425fa0 RCX: 00007f1ef319e0d9
> RDX: 0000200000000080 RSI: 00002000000000c0 RDI: 0000200000000000
> RBP: 00007f1ef3235024 R08: 0000000000000000 R09: 0000000000000000
> R10: 0000000000214003 R11: 0000000000000246 R12: 0000000000000000
> R13: 00007f1ef3426038 R14: 00007f1ef3425fa0 R15: 00007ffc4bde52a8
>  </TASK>
> Modules linked in:
> ---[ end trace 0000000000000000 ]---
> RIP: 0010:__call_rcu_common kernel/rcu/tree.c:3157 [inline]
> RIP: 0010:call_rcu+0xb9/0x8b0 kernel/rcu/tree.c:3279
> Code: 48 c1 e8 03 42 80 3c 28 00 74 08 48 89 df e8 0e eb 8a 00 48 c7 03 c=
0 9a ac 81 e9 b3 05 00 00 48 8d 7b 08 48 89 f8 48 c1 e8 03 <42> 80 3c 28 00=
 74 05 e8 eb ea 8a 00 4c 89 73 08 48 89 d8 48 c1 e8
> RSP: 0018:ffffc900041dfb08 EFLAGS: 00010206
> RAX: 000000000000005a RBX: 00000000000002c8 RCX: ffffffff9a9ab501
> RDX: 0000000000000001 RSI: ffffffff8e46456f RDI: 00000000000002d0
> RBP: 0000000000000000 R08: ffffffff90793d37 R09: 1ffffffff20f27a6
> R10: dffffc0000000000 R11: fffffbfff20f27a7 R12: dffffc0000000000
> R13: dffffc0000000000 R14: ffffffff82b4b6c0 R15: ffff88811e37e7a0
> FS:  00007f1ef40546c0(0000) GS:ffff88818d708000(0000) knlGS:0000000000000=
000
> CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> CR2: 00007f1ef4053ff8 CR3: 0000000173ace000 CR4: 00000000000006f0
> ----------------
> Code disassembly (best guess):
>    0:   48 c1 e8 03             shr    $0x3,%rax
>    4:   42 80 3c 28 00          cmpb   $0x0,(%rax,%r13,1)
>    9:   74 08                   je     0x13
>    b:   48 89 df                mov    %rbx,%rdi
>    e:   e8 0e eb 8a 00          call   0x8aeb21
>   13:   48 c7 03 c0 9a ac 81    movq   $0xffffffff81ac9ac0,(%rbx)
>   1a:   e9 b3 05 00 00          jmp    0x5d2
>   1f:   48 8d 7b 08             lea    0x8(%rbx),%rdi
>   23:   48 89 f8                mov    %rdi,%rax
>   26:   48 c1 e8 03             shr    $0x3,%rax
> * 2a:   42 80 3c 28 00          cmpb   $0x0,(%rax,%r13,1) <-- trapping in=
struction
>   2f:   74 05                   je     0x36
>   31:   e8 eb ea 8a 00          call   0x8aeb21
>   36:   4c 89 73 08             mov    %r14,0x8(%rbx)
>   3a:   48 89 d8                mov    %rbx,%rax
>   3d:   48                      rex.W
>   3e:   c1                      .byte 0xc1
>   3f:   e8                      .byte 0xe8
>
>
> ***
>
> general protection fault in erofs_kill_sb
>
> tree:      torvalds
> URL:       https://kernel.googlesource.com/pub/scm/linux/kernel/git/torva=
lds/linux
> base:      26260251022fbc2f248a3d747a9b2b961b18d2d8
> arch:      amd64
> compiler:  Debian clang version 22.1.8 (++20260613092233+e80beda6e255-1~e=
xp1~20260613092250.77), Debian LLD 22.1.8
> config:    https://ci.syzbot.org/builds/41c2a7e2-d41f-466f-8380-e05ef414b=
f62/config
> syz repro: https://ci.syzbot.org/findings/a828baa5-9634-4255-a0b1-41e60df=
7067d/syz_repro
>
> Oops: general protection fault, probably for non-canonical address 0xdfff=
fc0000000001: 0000 [#1] SMP KASAN PTI
> KASAN: null-ptr-deref in range [0x0000000000000008-0x000000000000000f]
> CPU: 0 UID: 0 PID: 5846 Comm: syz.0.17 Not tainted syzkaller #0 PREEMPT(f=
ull)
> Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS 1.16.2-debian-1.=
16.2-1 04/01/2014
> RIP: 0010:erofs_kill_sb+0x53/0x270 fs/erofs/super.c:950
> Code: 00 00 48 89 d8 48 c1 e8 03 48 89 44 24 08 80 3c 28 00 74 08 48 89 d=
f e8 bb 60 b8 fd 4c 8b 33 4d 8d 66 08 4d 89 e7 49 c1 ef 03 <41> 80 3c 2f 00=
 74 08 4c 89 e7 e8 9e 60 b8 fd 49 83 3c 24 00 4c 89
> RSP: 0018:ffffc90003dbfc08 EFLAGS: 00010202
> RAX: 1ffff1102edb18cf RBX: ffff888176d8c678 RCX: ffff88816bcabc00
> RDX: 0000000000000000 RSI: ffffffff8e46456f RDI: ffff888176d8c000
> RBP: dffffc0000000000 R08: ffffffff90793d37 R09: 1ffffffff20f27a6
> R10: dffffc0000000000 R11: ffffffff847e7250 R12: 0000000000000008
> R13: ffff888176d8c000 R14: 0000000000000000 R15: 0000000000000001
> FS:  00007efdff1c96c0(0000) GS:ffff88818d708000(0000) knlGS:0000000000000=
000
> CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> CR2: 00007ff27edb9095 CR3: 0000000174554000 CR4: 00000000000006f0
> Call Trace:
>  <TASK>
>  deactivate_locked_super+0xbc/0x110 fs/super.c:603
>  get_tree_bdev_flags+0x40e/0x560 fs/super.c:1895
>  vfs_get_tree+0x92/0x2a0 fs/super.c:1958
>  vfs_cmd_create+0xa2/0x200 fs/fsopen.c:231
>  __do_sys_fsconfig fs/fsopen.c:463 [inline]
>  __se_sys_fsconfig+0x6b9/0x810 fs/fsopen.c:350
>  do_syscall_x64 arch/x86/entry/syscall_64.c:61 [inline]
>  do_syscall_64+0x166/0x520 arch/x86/entry/syscall_64.c:84
>  entry_SYSCALL_64_after_hwframe+0x77/0x7f
> RIP: 0033:0x7efdfe39e0d9
> Code: ff c3 66 2e 0f 1f 84 00 00 00 00 00 0f 1f 44 00 00 48 89 f8 48 89 f=
7 48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 ff=
 ff 73 01 c3 48 c7 c1 e8 ff ff ff f7 d8 64 89 01 48
> RSP: 002b:00007efdff1c9028 EFLAGS: 00000246 ORIG_RAX: 00000000000001af
> RAX: ffffffffffffffda RBX: 00007efdfe625fa0 RCX: 00007efdfe39e0d9
> RDX: 0000000000000000 RSI: 0000000000000006 RDI: 0000000000000004
> RBP: 00007efdfe435024 R08: 0000000000000000 R09: 0000000000000000
> R10: 0000000000000000 R11: 0000000000000246 R12: 0000000000000000
> R13: 00007efdfe626038 R14: 00007efdfe625fa0 R15: 00007ffde183e908
>  </TASK>
> Modules linked in:
> ---[ end trace 0000000000000000 ]---
> RIP: 0010:erofs_kill_sb+0x53/0x270 fs/erofs/super.c:950
> Code: 00 00 48 89 d8 48 c1 e8 03 48 89 44 24 08 80 3c 28 00 74 08 48 89 d=
f e8 bb 60 b8 fd 4c 8b 33 4d 8d 66 08 4d 89 e7 49 c1 ef 03 <41> 80 3c 2f 00=
 74 08 4c 89 e7 e8 9e 60 b8 fd 49 83 3c 24 00 4c 89
> RSP: 0018:ffffc90003dbfc08 EFLAGS: 00010202
> RAX: 1ffff1102edb18cf RBX: ffff888176d8c678 RCX: ffff88816bcabc00
> RDX: 0000000000000000 RSI: ffffffff8e46456f RDI: ffff888176d8c000
> RBP: dffffc0000000000 R08: ffffffff90793d37 R09: 1ffffffff20f27a6
> R10: dffffc0000000000 R11: ffffffff847e7250 R12: 0000000000000008
> R13: ffff888176d8c000 R14: 0000000000000000 R15: 0000000000000001
> FS:  00007efdff1c96c0(0000) GS:ffff88818d708000(0000) knlGS:0000000000000=
000
> CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> CR2: 00007ff27edb9095 CR3: 0000000174554000 CR4: 00000000000006f0
> ----------------
> Code disassembly (best guess):
>    0:   00 00                   add    %al,(%rax)
>    2:   48 89 d8                mov    %rbx,%rax
>    5:   48 c1 e8 03             shr    $0x3,%rax
>    9:   48 89 44 24 08          mov    %rax,0x8(%rsp)
>    e:   80 3c 28 00             cmpb   $0x0,(%rax,%rbp,1)
>   12:   74 08                   je     0x1c
>   14:   48 89 df                mov    %rbx,%rdi
>   17:   e8 bb 60 b8 fd          call   0xfdb860d7
>   1c:   4c 8b 33                mov    (%rbx),%r14
>   1f:   4d 8d 66 08             lea    0x8(%r14),%r12
>   23:   4d 89 e7                mov    %r12,%r15
>   26:   49 c1 ef 03             shr    $0x3,%r15
> * 2a:   41 80 3c 2f 00          cmpb   $0x0,(%r15,%rbp,1) <-- trapping in=
struction
>   2f:   74 08                   je     0x39
>   31:   4c 89 e7                mov    %r12,%rdi
>   34:   e8 9e 60 b8 fd          call   0xfdb860d7
>   39:   49 83 3c 24 00          cmpq   $0x0,(%r12)
>   3e:   4c                      rex.WR
>   3f:   89                      .byte 0x89
>
>
> ***
>
> general protection fault in fuse_kill_sb_blk
>
> tree:      torvalds
> URL:       https://kernel.googlesource.com/pub/scm/linux/kernel/git/torva=
lds/linux
> base:      26260251022fbc2f248a3d747a9b2b961b18d2d8
> arch:      amd64
> compiler:  Debian clang version 22.1.8 (++20260613092233+e80beda6e255-1~e=
xp1~20260613092250.77), Debian LLD 22.1.8
> config:    https://ci.syzbot.org/builds/41c2a7e2-d41f-466f-8380-e05ef414b=
f62/config
> syz repro: https://ci.syzbot.org/findings/842bf23d-2982-4d44-81b0-f1e6e37=
301b2/syz_repro
>
> erofs (device loop0): mounted with root inode @ nid 36.
> /dev/loop0: Can't open blockdev
> Oops: general protection fault, probably for non-canonical address 0xdfff=
fc0000000000: 0000 [#1] SMP KASAN PTI
> KASAN: null-ptr-deref in range [0x0000000000000000-0x0000000000000007]
> CPU: 1 UID: 0 PID: 5856 Comm: syz.0.17 Not tainted syzkaller #0 PREEMPT(f=
ull)
> Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS 1.16.2-debian-1.=
16.2-1 04/01/2014
> RIP: 0010:fuse_mount_destroy fs/fuse/inode.c:1989 [inline]
> RIP: 0010:fuse_kill_sb_blk+0x23c/0x290 fs/fuse/inode.c:2016
> Code: 00 00 00 00 00 fc ff df 4c 89 f7 e8 9e e2 f2 fe 42 80 3c 2b 00 74 0=
8 48 89 ef e8 8f 92 de fe 48 8b 5d 00 48 89 d8 48 c1 e8 03 <42> 80 3c 28 00=
 74 08 48 89 df e8 75 92 de fe 48 8b 3b e8 3d 72 ff
> RSP: 0018:ffffc9000234fb08 EFLAGS: 00010246
> RAX: 0000000000000000 RBX: 0000000000000000 RCX: ffff88816c3cbc00
> RDX: 0000000000000000 RSI: 0000000000000008 RDI: 00000000ffffffff
> RBP: ffff888174cb6678 R08: ffff888174cb6087 R09: 1ffff1102e996c10
> R10: dffffc0000000000 R11: ffffed102e996c11 R12: ffff888174cb6078
> R13: dffffc0000000000 R14: ffff888174cb6000 R15: 0000000000000000
> FS:  00007fb71cf006c0(0000) GS:ffff8882a8d08000(0000) knlGS:0000000000000=
000
> CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> CR2: 0000200000001000 CR3: 00000001be98a000 CR4: 00000000000006f0
> Call Trace:
>  <TASK>
>  deactivate_locked_super+0xbc/0x110 fs/super.c:603
>  get_tree_bdev_flags+0x40e/0x560 fs/super.c:1895
>  fuse_get_tree+0x194/0x3b0 fs/fuse/inode.c:1877
>  vfs_get_tree+0x92/0x2a0 fs/super.c:1958
>  fc_mount fs/namespace.c:1198 [inline]
>  do_new_mount_fc fs/namespace.c:3772 [inline]
>  do_new_mount+0x319/0xdc0 fs/namespace.c:3848
>  do_mount fs/namespace.c:4181 [inline]
>  __do_sys_mount fs/namespace.c:4397 [inline]
>  __se_sys_mount+0x31d/0x420 fs/namespace.c:4374
>  do_syscall_x64 arch/x86/entry/syscall_64.c:61 [inline]
>  do_syscall_64+0x166/0x520 arch/x86/entry/syscall_64.c:84
>  entry_SYSCALL_64_after_hwframe+0x77/0x7f
> RIP: 0033:0x7fb71bf9e0d9
> Code: ff c3 66 2e 0f 1f 84 00 00 00 00 00 0f 1f 44 00 00 48 89 f8 48 89 f=
7 48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 ff=
 ff 73 01 c3 48 c7 c1 e8 ff ff ff f7 d8 64 89 01 48
> RSP: 002b:00007fb71cf00028 EFLAGS: 00000246 ORIG_RAX: 00000000000000a5
> RAX: ffffffffffffffda RBX: 00007fb71c225fa0 RCX: 00007fb71bf9e0d9
> RDX: 0000200000000140 RSI: 00002000000002c0 RDI: 0000200000000240
> RBP: 00007fb71c035024 R08: 0000200000000400 R09: 0000000000000000
> R10: 0000000000000000 R11: 0000000000000246 R12: 0000000000000000
> R13: 00007fb71c226038 R14: 00007fb71c225fa0 R15: 00007ffe55b01cb8
>  </TASK>
> Modules linked in:
> ---[ end trace 0000000000000000 ]---
> RIP: 0010:fuse_mount_destroy fs/fuse/inode.c:1989 [inline]
> RIP: 0010:fuse_kill_sb_blk+0x23c/0x290 fs/fuse/inode.c:2016
> Code: 00 00 00 00 00 fc ff df 4c 89 f7 e8 9e e2 f2 fe 42 80 3c 2b 00 74 0=
8 48 89 ef e8 8f 92 de fe 48 8b 5d 00 48 89 d8 48 c1 e8 03 <42> 80 3c 28 00=
 74 08 48 89 df e8 75 92 de fe 48 8b 3b e8 3d 72 ff
> RSP: 0018:ffffc9000234fb08 EFLAGS: 00010246
> RAX: 0000000000000000 RBX: 0000000000000000 RCX: ffff88816c3cbc00
> RDX: 0000000000000000 RSI: 0000000000000008 RDI: 00000000ffffffff
> RBP: ffff888174cb6678 R08: ffff888174cb6087 R09: 1ffff1102e996c10
> R10: dffffc0000000000 R11: ffffed102e996c11 R12: ffff888174cb6078
> R13: dffffc0000000000 R14: ffff888174cb6000 R15: 0000000000000000
> FS:  00007fb71cf006c0(0000) GS:ffff8882a8d08000(0000) knlGS:0000000000000=
000
> CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> CR2: 00007f9fb604de68 CR3: 00000001be98a000 CR4: 00000000000006f0
> ----------------
> Code disassembly (best guess), 7 bytes skipped:
>    0:   df 4c 89 f7             fisttps -0x9(%rcx,%rcx,4)
>    4:   e8 9e e2 f2 fe          call   0xfef2e2a7
>    9:   42 80 3c 2b 00          cmpb   $0x0,(%rbx,%r13,1)
>    e:   74 08                   je     0x18
>   10:   48 89 ef                mov    %rbp,%rdi
>   13:   e8 8f 92 de fe          call   0xfede92a7
>   18:   48 8b 5d 00             mov    0x0(%rbp),%rbx
>   1c:   48 89 d8                mov    %rbx,%rax
>   1f:   48 c1 e8 03             shr    $0x3,%rax
> * 23:   42 80 3c 28 00          cmpb   $0x0,(%rax,%r13,1) <-- trapping in=
struction
>   28:   74 08                   je     0x32
>   2a:   48 89 df                mov    %rbx,%rdi
>   2d:   e8 75 92 de fe          call   0xfede92a7
>   32:   48 8b 3b                mov    (%rbx),%rdi
>   35:   e8                      .byte 0xe8
>   36:   3d                      .byte 0x3d
>   37:   72 ff                   jb     0x38
>
>
> ***
>
> general protection fault in xfs_kill_sb
>
> tree:      torvalds
> URL:       https://kernel.googlesource.com/pub/scm/linux/kernel/git/torva=
lds/linux
> base:      26260251022fbc2f248a3d747a9b2b961b18d2d8
> arch:      amd64
> compiler:  Debian clang version 22.1.8 (++20260613092233+e80beda6e255-1~e=
xp1~20260613092250.77), Debian LLD 22.1.8
> config:    https://ci.syzbot.org/builds/41c2a7e2-d41f-466f-8380-e05ef414b=
f62/config
> syz repro: https://ci.syzbot.org/findings/6086312c-12df-4d69-b442-5c8a997=
93535/syz_repro
>
> /dev/loop1: Can't open blockdev
> Oops: general protection fault, probably for non-canonical address 0xdfff=
fc0000000035: 0000 [#1] SMP KASAN PTI
> KASAN: null-ptr-deref in range [0x00000000000001a8-0x00000000000001af]
> CPU: 0 UID: 0 PID: 5903 Comm: syz.1.24 Not tainted syzkaller #0 PREEMPT(f=
ull)
> Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS 1.16.2-debian-1.=
16.2-1 04/01/2014
> RIP: 0010:xfs_kill_sb+0x4e/0x260 fs/xfs/xfs_super.c:2335
> Code: 78 06 00 00 4c 89 f0 48 c1 e8 03 80 3c 18 00 74 08 4c 89 f7 e8 83 0=
8 96 fe 4d 8b 36 4d 8d be a8 01 00 00 4c 89 f8 48 c1 e8 03 <80> 3c 18 00 74=
 08 4c 89 ff e8 64 08 96 fe 4d 8b 27 4d 85 e4 0f 84
> RSP: 0018:ffffc900027afb50 EFLAGS: 00010206
> RAX: 0000000000000035 RBX: dffffc0000000000 RCX: ffff888110aa0000
> RDX: 0000000000000000 RSI: ffffffff8e46456f RDI: ffff888114d4e000
> RBP: ffffc900027afc00 R08: ffffffff90793d37 R09: 1ffffffff20f27a6
> R10: dffffc0000000000 R11: ffffffff83a0ca90 R12: dffffc0000000000
> R13: ffff888114d4e000 R14: 0000000000000000 R15: 00000000000001a8
> FS:  00007f104ac686c0(0000) GS:ffff88818d708000(0000) knlGS:0000000000000=
000
> CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> CR2: 0000555f35035578 CR3: 00000001bf1d2000 CR4: 00000000000006f0
> Call Trace:
>  <TASK>
>  deactivate_locked_super+0xbc/0x110 fs/super.c:603
>  get_tree_bdev_flags+0x40e/0x560 fs/super.c:1895
>  vfs_get_tree+0x92/0x2a0 fs/super.c:1958
>  fc_mount fs/namespace.c:1198 [inline]
>  do_new_mount_fc fs/namespace.c:3772 [inline]
>  do_new_mount+0x319/0xdc0 fs/namespace.c:3848
>  do_mount fs/namespace.c:4181 [inline]
>  __do_sys_mount fs/namespace.c:4397 [inline]
>  __se_sys_mount+0x31d/0x420 fs/namespace.c:4374
>  do_syscall_x64 arch/x86/entry/syscall_64.c:61 [inline]
>  do_syscall_64+0x166/0x520 arch/x86/entry/syscall_64.c:84
>  entry_SYSCALL_64_after_hwframe+0x77/0x7f
> RIP: 0033:0x7f1049d9e0d9
> Code: ff c3 66 2e 0f 1f 84 00 00 00 00 00 0f 1f 44 00 00 48 89 f8 48 89 f=
7 48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 ff=
 ff 73 01 c3 48 c7 c1 e8 ff ff ff f7 d8 64 89 01 48
> RSP: 002b:00007f104ac68028 EFLAGS: 00000246 ORIG_RAX: 00000000000000a5
> RAX: ffffffffffffffda RBX: 00007f104a026090 RCX: 00007f1049d9e0d9
> RDX: 0000200000000000 RSI: 00002000000001c0 RDI: 0000200000000080
> RBP: 00007f1049e35024 R08: 0000000000000000 R09: 0000000000000000
> R10: 0000000001a0c099 R11: 0000000000000246 R12: 0000000000000000
> R13: 00007f104a026128 R14: 00007f104a026090 R15: 00007ffd22a73788
>  </TASK>
> Modules linked in:
> ---[ end trace 0000000000000000 ]---
> RIP: 0010:xfs_kill_sb+0x4e/0x260 fs/xfs/xfs_super.c:2335
> Code: 78 06 00 00 4c 89 f0 48 c1 e8 03 80 3c 18 00 74 08 4c 89 f7 e8 83 0=
8 96 fe 4d 8b 36 4d 8d be a8 01 00 00 4c 89 f8 48 c1 e8 03 <80> 3c 18 00 74=
 08 4c 89 ff e8 64 08 96 fe 4d 8b 27 4d 85 e4 0f 84
> RSP: 0018:ffffc900027afb50 EFLAGS: 00010206
>
> RAX: 0000000000000035 RBX: dffffc0000000000 RCX: ffff888110aa0000
> RDX: 0000000000000000 RSI: ffffffff8e46456f RDI: ffff888114d4e000
> RBP: ffffc900027afc00 R08: ffffffff90793d37 R09: 1ffffffff20f27a6
> R10: dffffc0000000000 R11: ffffffff83a0ca90 R12: dffffc0000000000
> R13: ffff888114d4e000 R14: 0000000000000000 R15: 00000000000001a8
> FS:  00007f104ac686c0(0000) GS:ffff88818d708000(0000) knlGS:0000000000000=
000
> CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> CR2: 00007f5295e4de68 CR3: 00000001bf1d2000 CR4: 00000000000006f0
> ----------------
> Code disassembly (best guess):
>    0:   78 06                   js     0x8
>    2:   00 00                   add    %al,(%rax)
>    4:   4c 89 f0                mov    %r14,%rax
>    7:   48 c1 e8 03             shr    $0x3,%rax
>    b:   80 3c 18 00             cmpb   $0x0,(%rax,%rbx,1)
>    f:   74 08                   je     0x19
>   11:   4c 89 f7                mov    %r14,%rdi
>   14:   e8 83 08 96 fe          call   0xfe96089c
>   19:   4d 8b 36                mov    (%r14),%r14
>   1c:   4d 8d be a8 01 00 00    lea    0x1a8(%r14),%r15
>   23:   4c 89 f8                mov    %r15,%rax
>   26:   48 c1 e8 03             shr    $0x3,%rax
> * 2a:   80 3c 18 00             cmpb   $0x0,(%rax,%rbx,1) <-- trapping in=
struction
>   2e:   74 08                   je     0x38
>   30:   4c 89 ff                mov    %r15,%rdi
>   33:   e8 64 08 96 fe          call   0xfe96089c
>   38:   4d 8b 27                mov    (%r15),%r12
>   3b:   4d 85 e4                test   %r12,%r12
>   3e:   0f                      .byte 0xf
>   3f:   84                      .byte 0x84
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
> To test a fix for this bug, please reply with `#syz test`
> (on a separate line) and attach the patch to the email.
>
> Notes:
> - The patch will be applied on top of the tested series (as an
>   incremental fix).
> - To test a new version of the whole series, please send it directly
>   to syzbot@lists.linux.dev.
> - Arguments like custom git repos and branches are not supported.
>
> The email will later be sent to:
> [brauner@kernel.org hanzhijian1991@gmail.com jack@suse.cz linux-fsdevel@v=
ger.kernel.org linux-kernel@vger.kernel.org syzbot@syzkaller.appspotmail.co=
m viro@zeniv.linux.org.uk]
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
-upstream-moderation/6a89625a.91706f20.16b6e3.02b2.GAE%40google.com.



--=20
=E2=B2=A0=E2=B2=9F=E2=B2=93=E2=B2=99=E2=B2=8F=E2=B2=9B =E2=B2=84=E2=B2=89=
=E2=B2=B1=E2=B2=A3=E2=B2=85=E2=B2=93=E2=B2=9F=E2=B2=A5 - Pimyn Girgis
Software Engineer
Kernel Dynamic Analysis
pimyn@google.com
