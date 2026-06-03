Received: from mail-oo1-f49.google.com (mail-oo1-f49.google.com [209.85.161.49])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6C8CD3659EB
	for <syzbot@lists.linux.dev>; Wed,  3 Jun 2026 06:42:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.161.49
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780468929; cv=pass; b=iuWyG/J2aLYwj3yMDBElM3fkOJjsez+TLN/80ujGSwKx23xy4RBnNmyB103lGEyV/HCN5/LDTA/2kimQAoioXidd/rdnv+J6dK0ID7e/909jV0v+9v/bb9JwRQM4iK4gTR2Y8sehLd1P7cgdd1hsX1t4z0Q9zMfIobhCEwGZp1U=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780468929; c=relaxed/simple;
	bh=nLvPJUEJiw7bp5REyoEcrssPMaCSyFe0uJdTOBltTzQ=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=m32rLJSRBDIOTmcVMVjanZSTuVepk5stW3tQ+EoW3yYX3aPda5k1vow1bQiFqDJTwlkxn5xIgkgSuAQSfv2mXph+E9xoHefRDi4EwARpzGGuTV/ZhttuiZtgod5rJZjw7ufsy8cpx6EGSeYZHSPY+vFHsS84wZyyydzc/ifY2ag=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=gMrDWGKA; arc=pass smtp.client-ip=209.85.161.49
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="gMrDWGKA"
Received: by mail-oo1-f49.google.com with SMTP id 006d021491bc7-69de4000a57so243586eaf.0
        for <syzbot@lists.linux.dev>; Tue, 02 Jun 2026 23:42:07 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1780468926; cv=none;
        d=google.com; s=arc-20240605;
        b=dsfgFPjEmlFywJYperJPiFdTnfOFDrrzuxK33Xd12jtIseKSSfVXa7KLHqVEdXtimf
         i9KF9eeJNi8myv/8Sa2o7b6+hLtDh2mQeKEl/jtRHjDOa0GGm/g2aolPUXIDTsF042i7
         aTZ/xfb8LgEuW3M/wrGkosVpw9rVgKiMtCf03Tf7Fjg7KJzL2f7lg0cd+VfHUNR5Ukp9
         gg/aI/1nt+ROguh8EgNsNc22a1ACpGHNBZwfdSrfhhQd4yWAMIZV7jwrEDdj70+kzmTv
         MKvNFIzE6hD9F5gqWRmhH+Oo2saaqF2SHib+nNASue5tDdU548rfT1F4ddqpTXLtotSi
         07Tg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=UZsnoWCYzUm8S5kIOmgbpGECaYuhsQU8ot0eNAl9Z8s=;
        fh=gT3vNyRmxVnEUXVJCO3e2q5zgdVey5b6GFdA/gaJTpk=;
        b=T5EDQAJFo7bj9MpynuGg+jQQqubxuRpxRNujz/81ktyki3/IhVYB0FssWQc4p2TkOL
         wN2Ey/cVUvY3eOA6LsSqUJU8WhtQElTKCfNzrlznH9bBDM/whaHahtVV+gTJ4GCZpmFZ
         a0SgXS1NdA65kWo5HEvKYzVRMwW8pc0MXQQDs0ZS7YJ9S69qx9fBaHQHBGx1kCbkBiT+
         8OLxVB3qH4Dvj5Z4IzGS88NG5NlzMATjVIVZiIi4pw2/WtVUPSxO/uGGGlG95Zbzhfie
         czQioIjIJIJ52bh7xsoMXaEdvnyAMDIMQv2V3yz7fiC0mgHKqxopSJYaf65hYTzPfv+w
         d0bA==;
        darn=lists.linux.dev
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1780468926; x=1781073726; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=UZsnoWCYzUm8S5kIOmgbpGECaYuhsQU8ot0eNAl9Z8s=;
        b=gMrDWGKA5nJjUmapG0DlkpGtaQEq1NtGSDgbf1ZjhN12QBUjfvDl9GeYtzHGbXtv5i
         O2RAkc4A5WjbLGLnGO/P0oJlbUH6qO/JhEOY6rOD83LD63HPI6XUFUJLhSPqBUwvAZYt
         xkktA9FVXKBeMv8KjWfduoaFqtESgKSiEkBvaDkUn9r0gRqPUOUl9XCsgtJeDhGfwRjt
         j96NnzzcY5Dx7o0z6pwLKfp8ITo6gkfR68LHog5qQOpDJ4YCHtPl7FcSA+aypa4HbKjt
         iGjJ/+5kbrGf1DEw120186euZBygmsIZ3fZWq4XlxXRI3GWegta+0cHKb9xFJn8p8jIa
         yIfw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1780468926; x=1781073726;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=UZsnoWCYzUm8S5kIOmgbpGECaYuhsQU8ot0eNAl9Z8s=;
        b=DpoAgm9DqgG+riZwR1/6YcNYrquJOBDdtCjUocWW1loeAzIgeMqe2rW9m6vf0ggjiL
         Nw8gBhHVBjBsrq+TmrILSYnuHLdI6Bc88OdYPmhyayKfhrtGUBRhHInvbpwvGn3DloUc
         FuhJlW3UtFY9OV2tpfc+CzEuN0bZt2+1A2/De8DhW55RNwyt2oQqyi2ZbDjk8cXeGRfd
         cyY7PpnrSupJcQA9KOCOrU0TAFFwNJoV6s0SqhaN2ki8JFMW/Od04gy5mwFAYc+MSdZM
         3sjzuHC0fsC5W57AG4v9PP6mFMDDSQa/RrOVjqicgOYIBJ/t0zsXa7Cax3u6UQJMEsGB
         oPng==
X-Forwarded-Encrypted: i=1; AFNElJ+VmUHhimdhtwo/3sFHrqSUdSooG+U/DYENEkKPRbD+OKofCPiw9RxigGxilZI6hE/YZTjlM9g=@lists.linux.dev
X-Gm-Message-State: AOJu0YwYxpsu6573VCBMFRVTAU6jzyVAh9Ns0VKE0LXHqWfz7MrMo+6G
	fPttTnZAPgPQmybEyw1F8zuFNpKAaraJ0eUy3GyG09v+FbeXds0Bt5iK/OlcQsflkZJ/OIG+Ufx
	M4GqkVi63KHJ7vSJEZDD0ZgnzaV+/wmi0BDIe+X+/
X-Gm-Gg: Acq92OGSPGRSJFsGFhaAx1HyOpFn6L3dZR/s3UkzocirdyAmQsMHL7auPQPVu/BttIF
	kreYYghBddzDRpkspdsuorEn/8QuxSlMT2R2BVUi1Iw1XK+mg+X4CyGo9euBVFpEc/QiLKKnuvh
	CFeSUw4gsu7x19kQmdKWVZf5W8W5qbMZ8Tcus5Zox+Fs84TwEel3VJHTYAdqovZw75FnIgQIaLT
	L8eTSNtGeI7ONASCVphn2e2VosBsVGOaPDAxU1xCQoYitHHWw3P5ZuR/pWgKFUewGEbOwbnzq86
	hkaGKG15fb09C4fq6uGQ8JeuxJhrK9tdEy3NWsyrV+k6WjX52Ds2ug8yZn4GwmJKW+KftWTD30n
	OYg==
X-Received: by 2002:a05:6820:4c14:b0:69b:5486:e86 with SMTP id
 006d021491bc7-69e48b9a5c8mr807960eaf.10.1780468924205; Tue, 02 Jun 2026
 23:42:04 -0700 (PDT)
Precedence: bulk
X-Mailing-List: syzbot@lists.linux.dev
List-Id: <syzbot.lists.linux.dev>
List-Subscribe: <mailto:syzbot+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:syzbot+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <6a1ef366.278b5b03.2bcf39.003f.GAE@google.com>
In-Reply-To: <6a1ef366.278b5b03.2bcf39.003f.GAE@google.com>
From: Aleksandr Nogikh <nogikh@google.com>
Date: Wed, 3 Jun 2026 08:41:50 +0200
X-Gm-Features: AVHnY4KZQYAiMH3n9bN3fAXxKtLEN-UBEYLEH0krD26xRsHIGQHOqdPZSw3hXsA
Message-ID: <CANp29Y4RXgPwxDCUQMOyt=MC1xZ1kF8NXLy1x2Ob7UzRe6hdGA@mail.gmail.com>
Subject: Re: [moderation/CI] Re: fs: support freeze/thaw/mark_dead/sync with
 shared devices
To: syzbot ci <syzbot+cib8131b460c09aa4c@syzkaller.appspotmail.com>
Cc: syzkaller-upstream-moderation@googlegroups.com, syzbot@lists.linux.dev
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

#syz upstream

On Tue, Jun 2, 2026 at 5:14=E2=80=AFPM syzbot ci
<syzbot+cib8131b460c09aa4c@syzkaller.appspotmail.com> wrote:
>
> syzbot ci has tested the following series
>
> [v1] fs: support freeze/thaw/mark_dead/sync with shared devices
> https://lore.kernel.org/all/20260602-work-super-bdev_holder_global-v1-0-b=
b0fd82f3861@kernel.org
> * [PATCH RFC 1/8] fs, block: move blk_mode_t and fop_flags_t into <linux/=
types.h>
> * [PATCH RFC 2/8] fs: add a global device to super block hash table
> * [PATCH RFC 3/8] fs: refuse to claim any frozen block device
> * [PATCH RFC 4/8] xfs: port to fs_bdev_file_open_by_path()
> * [PATCH RFC 5/8] btrfs: open via dedicated fs bdev helpers
> * [PATCH RFC 6/8] ext4: open via dedicated fs bdev helpers
> * [PATCH RFC 7/8] erofs: open via dedicated fs bdev helpers
> * [PATCH RFC 8/8] super: make fs_holder_ops private
>
> and found the following issue:
> general protection fault in close_fs_devices
>
> Full report is available here:
> https://ci.syzbot.org/series/9511f00a-a3c2-44ab-9a0b-2d65de5bbd49
>
> ***
>
> general protection fault in close_fs_devices
>
> tree:      bpf-next
> URL:       https://kernel.googlesource.com/pub/scm/linux/kernel/git/bpf/b=
pf-next.git
> base:      254f49634ee16a731174d2ae34bc50bd5f45e731
> arch:      amd64
> compiler:  Debian clang version 21.1.8 (++20251221033036+2078da43e25a-1~e=
xp1~20251221153213.50), Debian LLD 21.1.8
> config:    https://ci.syzbot.org/builds/4af26755-5773-453e-807d-ee451d2fd=
ec5/config
> syz repro: https://ci.syzbot.org/findings/2d8d96f7-d133-47dc-b4ca-5c0c65e=
1b6c9/syz_repro
>
> btrfs: Deprecated parameter 'usebackuproot'
> BTRFS warning: 'usebackuproot' is deprecated, use 'rescue=3Dusebackuproot=
' instead
> BTRFS: device fsid ed167579-eb65-4e76-9a50-61ac97e9b59d devid 1281 transi=
d 8 /dev/loop1 (7:1) scanned by syz.1.18 (5863)
> Oops: general protection fault, probably for non-canonical address 0xdfff=
fc00000000f8: 0000 [#1] SMP KASAN PTI
> KASAN: null-ptr-deref in range [0x00000000000007c0-0x00000000000007c7]
> CPU: 1 UID: 0 PID: 5863 Comm: syz.1.18 Not tainted syzkaller #0 PREEMPT(f=
ull)
> Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS 1.16.2-debian-1.=
16.2-1 04/01/2014
> RIP: 0010:btrfs_close_bdev fs/btrfs/volumes.c:1140 [inline]
> RIP: 0010:btrfs_close_one_device fs/btrfs/volumes.c:1161 [inline]
> RIP: 0010:close_fs_devices+0x47c/0x860 fs/btrfs/volumes.c:1204
> Code: 3c 08 00 74 08 48 89 ef e8 b1 95 38 fe 48 8b 6d 00 b8 c0 07 00 00 4=
8 01 c5 48 89 e8 48 c1 e8 03 48 b9 00 00 00 00 00 fc ff df <80> 3c 08 00 74=
 08 48 89 ef e8 86 95 38 fe 48 8b 75 00 4c 89 ff e8
> RSP: 0018:ffffc90004007a48 EFLAGS: 00010202
> RAX: 00000000000000f8 RBX: 1ffff110368c440b RCX: dffffc0000000000
> RDX: 0000000000000000 RSI: 0000000000000000 RDI: 0000000000000000
> RBP: 00000000000007c0 R08: ffff8881b462206f R09: 1ffff110368c440d
> R10: dffffc0000000000 R11: ffffed10368c440e R12: ffff8881b4622000
> R13: ffff8881b4622068 R14: ffff8881b4622058 R15: ffff8881707b7a00
> FS:  00007f849d6ce6c0(0000) GS:ffff8882a9292000(0000) knlGS:0000000000000=
000
> CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> CR2: 00007f849c786a00 CR3: 00000001bbbcc000 CR4: 00000000000006f0
> Call Trace:
>  <TASK>
>  btrfs_close_devices+0xcd/0x570 fs/btrfs/volumes.c:1219
>  btrfs_free_fs_info+0x4f/0x360 fs/btrfs/disk-io.c:1205
>  deactivate_locked_super+0xbc/0x130 fs/super.c:477
>  btrfs_get_tree_super fs/btrfs/super.c:-1 [inline]
>  btrfs_get_tree_subvol fs/btrfs/super.c:2087 [inline]
>  btrfs_get_tree+0xca6/0x1910 fs/btrfs/super.c:2121
>  vfs_get_tree+0x92/0x2a0 fs/super.c:1928
>  fc_mount fs/namespace.c:1193 [inline]
>  do_new_mount_fc fs/namespace.c:3758 [inline]
>  do_new_mount+0x341/0xd30 fs/namespace.c:3834
>  do_mount fs/namespace.c:4167 [inline]
>  __do_sys_mount fs/namespace.c:4383 [inline]
>  __se_sys_mount+0x31d/0x420 fs/namespace.c:4360
>  do_syscall_x64 arch/x86/entry/syscall_64.c:63 [inline]
>  do_syscall_64+0x15f/0xf80 arch/x86/entry/syscall_64.c:94
>  entry_SYSCALL_64_after_hwframe+0x77/0x7f
> RIP: 0033:0x7f849c79e0ca
> Code: 48 c7 c2 e8 ff ff ff f7 d8 64 89 02 b8 ff ff ff ff c3 66 2e 0f 1f 8=
4 00 00 00 00 00 0f 1f 40 00 49 89 ca b8 a5 00 00 00 0f 05 <48> 3d 01 f0 ff=
 ff 73 01 c3 48 c7 c1 e8 ff ff ff f7 d8 64 89 01 48
> RSP: 002b:00007f849d6cde58 EFLAGS: 00000246 ORIG_RAX: 00000000000000a5
> RAX: ffffffffffffffda RBX: 00007f849d6cdee0 RCX: 00007f849c79e0ca
> RDX: 00002000000055c0 RSI: 0000200000000340 RDI: 00007f849d6cdea0
> RBP: 00002000000055c0 R08: 00007f849d6cdee0 R09: 0000000000000408
> R10: 0000000000000408 R11: 0000000000000246 R12: 0000200000000340
> R13: 00007f849d6cdea0 R14: 00000000000055f5 R15: 0000200000000380
>  </TASK>
> Modules linked in:
> ---[ end trace 0000000000000000 ]---
> RIP: 0010:btrfs_close_bdev fs/btrfs/volumes.c:1140 [inline]
> RIP: 0010:btrfs_close_one_device fs/btrfs/volumes.c:1161 [inline]
> RIP: 0010:close_fs_devices+0x47c/0x860 fs/btrfs/volumes.c:1204
> Code: 3c 08 00 74 08 48 89 ef e8 b1 95 38 fe 48 8b 6d 00 b8 c0 07 00 00 4=
8 01 c5 48 89 e8 48 c1 e8 03 48 b9 00 00 00 00 00 fc ff df <80> 3c 08 00 74=
 08 48 89 ef e8 86 95 38 fe 48 8b 75 00 4c 89 ff e8
> RSP: 0018:ffffc90004007a48 EFLAGS: 00010202
>
> RAX: 00000000000000f8 RBX: 1ffff110368c440b RCX: dffffc0000000000
> RDX: 0000000000000000 RSI: 0000000000000000 RDI: 0000000000000000
> RBP: 00000000000007c0 R08: ffff8881b462206f R09: 1ffff110368c440d
> R10: dffffc0000000000 R11: ffffed10368c440e R12: ffff8881b4622000
> R13: ffff8881b4622068 R14: ffff8881b4622058 R15: ffff8881707b7a00
> FS:  00007f849d6ce6c0(0000) GS:ffff8882a9292000(0000) knlGS:0000000000000=
000
> CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> CR2: 0000557941c2b058 CR3: 00000001bbbcc000 CR4: 00000000000006f0
> ----------------
> Code disassembly (best guess):
>    0:   3c 08                   cmp    $0x8,%al
>    2:   00 74 08 48             add    %dh,0x48(%rax,%rcx,1)
>    6:   89 ef                   mov    %ebp,%edi
>    8:   e8 b1 95 38 fe          call   0xfe3895be
>    d:   48 8b 6d 00             mov    0x0(%rbp),%rbp
>   11:   b8 c0 07 00 00          mov    $0x7c0,%eax
>   16:   48 01 c5                add    %rax,%rbp
>   19:   48 89 e8                mov    %rbp,%rax
>   1c:   48 c1 e8 03             shr    $0x3,%rax
>   20:   48 b9 00 00 00 00 00    movabs $0xdffffc0000000000,%rcx
>   27:   fc ff df
> * 2a:   80 3c 08 00             cmpb   $0x0,(%rax,%rcx,1) <-- trapping in=
struction
>   2e:   74 08                   je     0x38
>   30:   48 89 ef                mov    %rbp,%rdi
>   33:   e8 86 95 38 fe          call   0xfe3895be
>   38:   48 8b 75 00             mov    0x0(%rbp),%rsi
>   3c:   4c 89 ff                mov    %r15,%rdi
>   3f:   e8                      .byte 0xe8
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
> [axboe@kernel.dk brauner@kernel.org cem@kernel.org clm@fb.com dsterba@sus=
e.com hch@lst.de jack@suse.cz linux-block@vger.kernel.org linux-btrfs@vger.=
kernel.org linux-erofs@lists.ozlabs.org linux-ext4@vger.kernel.org linux-fs=
devel@vger.kernel.org linux-kernel@vger.kernel.org linux-xfs@vger.kernel.or=
g tytso@mit.edu viro@zeniv.linux.org.uk xiang@kernel.org]
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
-upstream-moderation/6a1ef366.278b5b03.2bcf39.003f.GAE%40google.com.
