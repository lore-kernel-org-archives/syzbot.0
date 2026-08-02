Received: from mail-ot1-f44.google.com (mail-ot1-f44.google.com [209.85.210.44])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B7975273D77
	for <syzbot@lists.linux.dev>; Sun,  2 Aug 2026 19:12:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.210.44
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785697951; cv=pass; b=QJsS4b/FDxcZ23mdxquIkX4HKapefXBw0UDE4OWc1v7h0RsNoqXTHt0oSAmAhVTysJ27Ln1PxOFaUiqcqXgQ54UgBXbqZVM+JAUWzzMcIhSfKS0oHmKc9AQIGpDLQsUwf9zpS18xiuqk2/jUi5VHNiEYINuwfTQ1wfzSBVSdQFw=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785697951; c=relaxed/simple;
	bh=fldb8csCOO38cL45Knsp19Jz7cvb0FAU6RsYCC97Y1o=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=sdpNK2yxNHdnhPZOG2lD7H7oibjAsjr5HY7ob6Q48U1fNWR7T6vUzFn/sMsEyiAZvm994gRpwy53+izuUnFpzfUtpAJNE7p4Oba7mjpzPojk47RxkB970WpFBVLZELGQVKuQdjayoXqkDZsOwmKiBn5fS5zEtVrzF9UgCd4m7RI=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=RM8KB6CA; arc=pass smtp.client-ip=209.85.210.44
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="RM8KB6CA"
Received: by mail-ot1-f44.google.com with SMTP id 46e09a7af769-7f0167e59a3so1357616a34.0
        for <syzbot@lists.linux.dev>; Sun, 02 Aug 2026 12:12:29 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1785697948; cv=none;
        d=google.com; s=arc-20260327;
        b=hFwYh5x+VFC2oZTgTqpJXEg5q8BDvFqRq1NVnxWOWTtFbFNl2XqdwAyNfXy5DGHghH
         e/YaCZHKyBg/PeRCdlONaFY/k4OkuH7bvAM5vQvNoH/jTpuaq+yzWIUTkD+GvLsTBcOx
         TnWnsGfump6tQxflCEBMvX34h1fj2ZTmYAWrZk7xDEm/XmXLjTdGhb0KhnQc0HGUsi5O
         Ua84ZyVlZ0cxree3mfoKP406IcOUf+X5+ikqIfyh8h1x6ODOmXwDI3/xrX8dvgc9TRJR
         1wOdh+7x0J/y+dYwch0S/JcyiOPyfoyY/z177lfIjzP4KuUfyJgpL93x+Pz3WX9m2Cza
         uHyw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=/DETgfKZGvKQKsEA1h1meqHiLemOyzE7UTCyEBGn+Qs=;
        fh=tL08zk8G8NZ4cQi3/H1bKxyhZRDIstnhygEOF250nq0=;
        b=TU9spyrSejvxiflnyIuyjIncivi0bnKNeNW05FaqFcFDOG4ArrLWFWGoL9gVQr32G4
         MPKWJIqbdZeTFytK7E5xYWe/BTP0o6H/yfg7tlw5lFdZEYk+h7UrmN7vaEKJKEOlOx+/
         4Bm/MH5cs7koMCM3gmu0qXtCG9G20UM2l4nC6dPQd/CPZ3ZXdrUtaf3pMNxkVyouAz3g
         4cSrgPn+hjpDeW303OTrZOLIOEHRWMWnZ4ClzNyVhT9dyGHcS4WowToDOqpqGjABDvxL
         XitaJWw5DSb1haCxxGofrXcHVnBFzL6QcidOSGQO1NqLsXluFdnACN80A0mtE40+qYb5
         2QvQ==;
        darn=lists.linux.dev
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1785697948; x=1786302748; darn=lists.linux.dev;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=/DETgfKZGvKQKsEA1h1meqHiLemOyzE7UTCyEBGn+Qs=;
        b=RM8KB6CAAIleLNtj9ReKIJ7LZ0parokgjcYLYn17OJiC82z/EFNSzFwun/WDph9rmg
         M8SZ1cjZcyfmEx2y+7x3m/Msh6xBea8T7hRetIhLtDJIba6zVS+ja1rlx6rexOBqNpY7
         skaSbwpFmQey2df8uxfD9qDqvBz0VrY6AB0s3i0AjcXQUyCoquuPiD4rJmov/LQZjWTp
         BJuI273C2JjIXoIM6ShNExT54g+pG83QUWkc/KK9T36QCufUlgxQicKVuj6IERZwokt0
         cJkNBzAqmbV8NEjWEtVfk5D6/Uq1dHghntGGNq5MaKriuU8NUPAS/5zfd4Td88kxJVDR
         l0PQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1785697948; x=1786302748;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=/DETgfKZGvKQKsEA1h1meqHiLemOyzE7UTCyEBGn+Qs=;
        b=ALWEpKy+qLuRRoQQiuwH58oY+oRCmyPpEkSLGY2WLtUkYgt2A4R9/XVTx0VRMyC3RM
         QrBPpuLEtx6DkKBAzoU9f34f+QVcFTbvvs1f0HP+zMNrUKe3ccldlIwmhKv//VDAkZ1u
         jHzEYsJZRvkvLVaKwpHutu81sgOf80h6IZmRSb44G6elsyL74zcKOnklm3zhTW2Mw62C
         apYqN8wQPxd9yK840p4KIsQNYh5aZ1M138W1oXKOtwjBJ/ht458tzlFf3fdMOs2H/WQs
         DzO63PNREeAV/GXWN87Lw5BsRK9CGMrGWMMB1wGoLtGd6y7BYVIin76CK17kvFIoM5eH
         xEhw==
X-Forwarded-Encrypted: i=1; AHgh+RoblznaLN4V4DOAHY+wV48XgkqFtiCwhQtjyvthwOEScKVU/mmOk166xUH/kyCkdRD4heDRjBk=@lists.linux.dev
X-Gm-Message-State: AOJu0Yyf9tI4wIV1UVINuxqvYpciGzfM9LmI5y2N8+gIp/phdWcSdYCF
	N/gI6khgmanqzzIyGJpD+qmFM1J1zD9lvFer37GGQ+qtgACWsK1aotSyLOQRoLQcC/wXtQAquFR
	mKodKAI6w0CXCh5xwigqYVWHMAL/Xa5g9VWAD2nqt
X-Gm-Gg: AR+sD11ahDQpsOLqhvmRA4RROqlgmJdzw0gtEhrIYjnvm9t89V6ygtGqGJdUpkTG2i+
	So4Enlw0B8lq8wmA0hutEZ6zMy22H8Oee3ZkQtw6H/BTYk1xc5L/mm8K+Fk+nlx3AhNin9b4x9O
	27G0gi+GhEeaKKSKdDA9XA9mB15xNdxSLr+O1WuZeWq111DaO2iig0MUiX7yV0da7Wcueny+gdD
	yuw1nkcjLnPAK/3BLwgRsINQYYjgh5CFWKJVz0+3QZRzZiAO8qKrrAaaRSd9kw25v71nmqaIrJD
	o1ky6bj3ZTS/lH4+gyK4lnqGPRZVbrEfL+XuW9sEX1pw9d8mwvce3wn4kVb4q75cxukEL2w1NWY
	TNRtPdUT7zrrkM1thYcFl8LFFW3AfLrlxzj1kyC2pHqeGRyZTv20Hu6AZDUF48fXNYP4erNHJK/
	F16FtqxV2P8t+Xp1Q=
X-Received: by 2002:a05:6830:349d:b0:7ee:37dc:59e1 with SMTP id
 46e09a7af769-7f1971d52d3mr12163847a34.16.1785697948046; Sun, 02 Aug 2026
 12:12:28 -0700 (PDT)
Precedence: bulk
X-Mailing-List: syzbot@lists.linux.dev
List-Id: <syzbot.lists.linux.dev>
List-Subscribe: <mailto:syzbot+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:syzbot+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <6a6e4cfa.2d659fcc.1d46f5.01c0.GAE@google.com>
In-Reply-To: <6a6e4cfa.2d659fcc.1d46f5.01c0.GAE@google.com>
From: Aleksandr Nogikh <nogikh@google.com>
Date: Sun, 2 Aug 2026 21:12:16 +0200
X-Gm-Features: AUfX_mxr0Vwzpoj0Fcrb0db5GAfkle6zkmZYqn1hQ6P1r952s5KYcQzfj0fwOlU
Message-ID: <CANp29Y5wpi-L1KO+32oFVve-4NXDyAQD7Q0iub1FuEsZgv_YyQ@mail.gmail.com>
Subject: Re: [moderation/CI] Re: iomap: follow the alignment requirement for iomap_dio_hole_iter()
To: syzbot ci <syzbot+cid37113556dd77782@syzkaller.appspotmail.com>
Cc: syzkaller-upstream-moderation@googlegroups.com, syzbot@lists.linux.dev
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

#syz upstream

On Sat, Aug 1, 2026 at 9:46=E2=80=AFPM syzbot ci
<syzbot+cid37113556dd77782@syzkaller.appspotmail.com> wrote:
>
> syzbot ci has tested the following series
>
> [v2] iomap: follow the alignment requirement for iomap_dio_hole_iter()
> https://lore.kernel.org/all/9209e7204fc6b7b60c28f196750084be8a2faba8.1785=
489008.git.wqu@suse.com
> * [PATCH v2] iomap: follow the alignment requirement for iomap_dio_hole_i=
ter()
>
> and found the following issue:
> general protection fault in iomap_dio_hole_iter
>
> Full report is available here:
> https://ci.syzbot.org/series/9d98023b-4249-4697-ab21-ea7cf83805c8
>
> ***
>
> general protection fault in iomap_dio_hole_iter
>
> tree:      vfs
> URL:       https://kernel.googlesource.com/pub/scm/linux/kernel/git/vfs/v=
fs.git
> base:      fa20f6cb6063f7f1a6a56693d4a8713f19058d23
> arch:      amd64
> compiler:  Debian clang version 22.1.8 (++20260613092233+e80beda6e255-1~e=
xp1~20260613092250.77), Debian LLD 22.1.8
> config:    https://ci.syzbot.org/builds/a53b891c-9ac3-484a-a77e-61c04d351=
57f/config
> syz repro: https://ci.syzbot.org/findings/8ed3b1e3-7e4e-4c2c-b0f6-934cfea=
6e536/syz_repro
>
> syz.0.17: attempt to access beyond end of device
> loop0: rw=3D2049, sector=3D53248, nr_sectors =3D 976 limit=3D40427
> Oops: general protection fault, probably for non-canonical address 0xdfff=
fc0000000003: 0000 [#1] SMP KASAN PTI
> KASAN: null-ptr-deref in range [0x0000000000000018-0x000000000000001f]
> CPU: 1 UID: 0 PID: 6257 Comm: syz.0.17 Not tainted syzkaller #0 PREEMPT(f=
ull)
> Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS 1.16.2-debian-1.=
16.2-1 04/01/2014
> RIP: 0010:bdev_get_queue include/linux/blkdev.h:1056 [inline]
> RIP: 0010:bdev_logical_block_size include/linux/blkdev.h:1401 [inline]
> RIP: 0010:iomap_dio_alignment fs/iomap/direct-io.c:412 [inline]
> RIP: 0010:iomap_dio_hole_iter+0x1bf/0x390 fs/iomap/direct-io.c:598
> Code: fc ff df 80 3c 08 00 74 08 4c 89 ef e8 aa d7 c7 ff 49 8b 6d 00 48 8=
3 c5 18 48 89 e8 48 c1 e8 03 48 b9 00 00 00 00 00 fc ff df <80> 3c 08 00 74=
 08 48 89 ef e8 83 d7 c7 ff 41 bd 58 01 00 00 4c 03
> RSP: 0018:ffffc90003eff500 EFLAGS: 00010206
> RAX: 0000000000000003 RBX: ffffc90003eff680 RCX: dffffc0000000000
> RDX: 0000000000000000 RSI: 0000000000000000 RDI: 0000000000000000
> RBP: 0000000000000018 R08: ffff88816dc38fff R09: 0000000000000000
> R10: ffff88816dc38000 R11: ffffed102db87200 R12: 0000000000001000
> R13: ffffc90003eff6c8 R14: ffff88816b839c00 R15: 1ffff1102d707388
> FS:  00007ffb1678d6c0(0000) GS:ffff8882a8f4b000(0000) knlGS:0000000000000=
000
> CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> CR2: 0000563ae8dcd0a8 CR3: 0000000110cf4000 CR4: 00000000000006f0
> Call Trace:
>  <TASK>
>  iomap_dio_iter fs/iomap/direct-io.c:-1 [inline]
>  __iomap_dio_rw+0xe56/0x1ac0 fs/iomap/direct-io.c:823
>  f2fs_dio_read_iter fs/f2fs/file.c:4887 [inline]
>  f2fs_file_read_iter+0x60b/0x940 fs/f2fs/file.c:4950
>  copy_splice_read+0x5ff/0xaa0 fs/splice.c:362
>  do_splice_read fs/splice.c:979 [inline]
>  splice_direct_to_actor+0x4b6/0xcb0 fs/splice.c:1084
>  do_splice_direct_actor fs/splice.c:1202 [inline]
>  do_splice_direct+0x195/0x290 fs/splice.c:1228
>  do_sendfile+0x52e/0x7c0 fs/read_write.c:1371
>  __do_sys_sendfile64 fs/read_write.c:1432 [inline]
>  __se_sys_sendfile64+0x144/0x1a0 fs/read_write.c:1418
>  do_syscall_x64 arch/x86/entry/syscall_64.c:63 [inline]
>  do_syscall_64+0x174/0x580 arch/x86/entry/syscall_64.c:94
>  entry_SYSCALL_64_after_hwframe+0x77/0x7f
> RIP: 0033:0x7ffb1599e019
> Code: ff c3 66 2e 0f 1f 84 00 00 00 00 00 0f 1f 44 00 00 48 89 f8 48 89 f=
7 48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 ff=
 ff 73 01 c3 48 c7 c1 e8 ff ff ff f7 d8 64 89 01 48
> RSP: 002b:00007ffb1678d028 EFLAGS: 00000246 ORIG_RAX: 0000000000000028
> RAX: ffffffffffffffda RBX: 00007ffb15c25fa0 RCX: 00007ffb1599e019
> RDX: 0000000000000000 RSI: 0000000000000004 RDI: 0000000000000004
> RBP: 00007ffb15a3500c R08: 0000000000000000 R09: 0000000000000000
> R10: 0000000800000009 R11: 0000000000000246 R12: 0000000000000000
> R13: 00007ffb15c26038 R14: 00007ffb15c25fa0 R15: 00007ffc15b4ab58
>  </TASK>
> Modules linked in:
> ---[ end trace 0000000000000000 ]---
> RIP: 0010:bdev_get_queue include/linux/blkdev.h:1056 [inline]
> RIP: 0010:bdev_logical_block_size include/linux/blkdev.h:1401 [inline]
> RIP: 0010:iomap_dio_alignment fs/iomap/direct-io.c:412 [inline]
> RIP: 0010:iomap_dio_hole_iter+0x1bf/0x390 fs/iomap/direct-io.c:598
> Code: fc ff df 80 3c 08 00 74 08 4c 89 ef e8 aa d7 c7 ff 49 8b 6d 00 48 8=
3 c5 18 48 89 e8 48 c1 e8 03 48 b9 00 00 00 00 00 fc ff df <80> 3c 08 00 74=
 08 48 89 ef e8 83 d7 c7 ff 41 bd 58 01 00 00 4c 03
> RSP: 0018:ffffc90003eff500 EFLAGS: 00010206
> RAX: 0000000000000003 RBX: ffffc90003eff680 RCX: dffffc0000000000
> RDX: 0000000000000000 RSI: 0000000000000000 RDI: 0000000000000000
> RBP: 0000000000000018 R08: ffff88816dc38fff R09: 0000000000000000
> R10: ffff88816dc38000 R11: ffffed102db87200 R12: 0000000000001000
> R13: ffffc90003eff6c8 R14: ffff88816b839c00 R15: 1ffff1102d707388
> FS:  00007ffb1678d6c0(0000) GS:ffff8882a8f4b000(0000) knlGS:0000000000000=
000
> CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> CR2: 0000558d8b221b40 CR3: 0000000110cf4000 CR4: 00000000000006f0
> ----------------
> Code disassembly (best guess), 2 bytes skipped:
>    0:   df 80 3c 08 00 74       filds  0x7400083c(%rax)
>    6:   08 4c 89 ef             or     %cl,-0x11(%rcx,%rcx,4)
>    a:   e8 aa d7 c7 ff          call   0xffc7d7b9
>    f:   49 8b 6d 00             mov    0x0(%r13),%rbp
>   13:   48 83 c5 18             add    $0x18,%rbp
>   17:   48 89 e8                mov    %rbp,%rax
>   1a:   48 c1 e8 03             shr    $0x3,%rax
>   1e:   48 b9 00 00 00 00 00    movabs $0xdffffc0000000000,%rcx
>   25:   fc ff df
> * 28:   80 3c 08 00             cmpb   $0x0,(%rax,%rcx,1) <-- trapping in=
struction
>   2c:   74 08                   je     0x36
>   2e:   48 89 ef                mov    %rbp,%rdi
>   31:   e8 83 d7 c7 ff          call   0xffc7d7b9
>   36:   41 bd 58 01 00 00       mov    $0x158,%r13d
>   3c:   4c                      rex.WR
>   3d:   03                      .byte 0x3
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
> [linux-btrfs@vger.kernel.org linux-fsdevel@vger.kernel.org linux-xfs@vger=
.kernel.org wqu@suse.com]
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
-upstream-moderation/6a6e4cfa.2d659fcc.1d46f5.01c0.GAE%40google.com.
