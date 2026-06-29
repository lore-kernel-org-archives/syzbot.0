Received: from mail-ot1-f47.google.com (mail-ot1-f47.google.com [209.85.210.47])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1C730224B15
	for <syzbot@lists.linux.dev>; Mon, 29 Jun 2026 05:26:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.210.47
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782710767; cv=pass; b=qOw54iMIa8koMLwdRIjkZ2QDCKPYfIXUrYCckRdpYqrjJEmbdFrlBdafyIuWHM4xqRFhyf06sf8z1k86TcOW4tQ9CrjcxeO9c6lajqcG1uXauD2oEmXYGpuKIo5nzpSzQVCFGHkqQnQQ1qaaBoGjMRFawFYXqYUwHw80MGJrVsA=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782710767; c=relaxed/simple;
	bh=CJ/R5/EQpXsvQ+p4brOjtPRpUve+lfclm6dLP8alM2k=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=EajHUbOXJeqH2LU6tCrQpiZHmirVUneirP60SC5nbS8rhyGRB/ACrhEKCjA8RAS1teLkZdn2KpHIPYM9XP2I9P3ND5PzBGeei1kC+IAqzsvOuwRLO4kQ0MYWzYSXbaBGcUhi04Nsp44ZksCnvb6EM5Aq/+rBK443Lb1sZljPzIs=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=OAn2/OEY; arc=pass smtp.client-ip=209.85.210.47
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="OAn2/OEY"
Received: by mail-ot1-f47.google.com with SMTP id 46e09a7af769-7e9bc8dd61fso1618173a34.1
        for <syzbot@lists.linux.dev>; Sun, 28 Jun 2026 22:26:05 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1782710765; cv=none;
        d=google.com; s=arc-20260327;
        b=DyP8nnOZnpWAJwXIQdYxIhXMyKHxl91mLGvhxDmD/S8CWL1S1JigZSCT7eTiZ6kFzF
         gRphrOao35DhNiGapfx6Qoaw/6BsBBuqhp1MxUMwINI1cGrWGbwkTfHUWoxzHg0escq8
         v1H+XsAtcA81zZ4Amj1zSweY7Oe7QIYkcoe74p74KDYrfs6XOhLXjx/3gIk85LO8VD5N
         QiyVrOKDFXupkdgGivApVi1+gGfZYC5+yUjdxGrSDCmzTkoO4Nfgs3Xh6FKL23lqJdkw
         +0bgNedv+JjKThbkf9imgi8QTKEPOm48v764yI92xLE8dKwNa+03QcobqYGpJy+Uc2at
         l7Hg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=aOJnF3A8YalGp8OuEjlSdK0RDcHLOCH8RnLfEF9LDVs=;
        fh=wHKhLX4q9MxmjxxbuWCPQv6KtfDJ1rN/ww3oPgv2BOE=;
        b=U6nqmkgILGTkNQcRFE2owPeITPPzM8DmQcTi2JhZugW4QHDUIzJ1MkbmiPfaUtQ5sX
         /9uQ81HcfeePEIaO1lY10fdHjUZgHxqtGtZArevltQEtAlgyLeS/Locootd52mvmauWu
         p/HehIe8XYNVtFNsuWqQl5xptIRmD+jXOVK0zQLiVIjDhpwy8bccaW6pdcDjPq3BEcLK
         H+Ei7iMxuUsxn4lQXSh6Y3HvpUSdMovHnKAv53YozmQHuqUJunT1OChee075ZHyTdqSs
         m5nvr8Nx7JLSbcwTacOAOEYd9jrIi4qRSnGC7auhdmDi5xb9Bl2dCixacZckbhcsfYMy
         TjkQ==;
        darn=lists.linux.dev
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1782710765; x=1783315565; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=aOJnF3A8YalGp8OuEjlSdK0RDcHLOCH8RnLfEF9LDVs=;
        b=OAn2/OEYZc+uxJEyFJunaeK98pWkcUkSOv+8/8GV+6SjGIoNoXb+hInrGAkEPA3Q/w
         NqBjihxSclUkuZJmGqpCL/ucMW9qL4QIeqpYvAlNhQgGcvtlIpjsJmXW5p/NFtKVnfvZ
         oiUlMlGCm6fj+Ni3xe4+k8ankHBZw2UoGxFkg1+4PmNHVklAH3IRYC4XBJVg/7GlcmOk
         nht3E2OLEHj/T2RYPQ/enu4HWDsHXstJXRdMyXl9rfm+t7ptRFtJLUiYZvJHVgzdWB/9
         oRYfzKy2vj0xCIf4rwirKubAO+Pw0M/R0F06/6D65UPUHPU93UCaj7DseV5SXDwprP2d
         D4Zg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1782710765; x=1783315565;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=aOJnF3A8YalGp8OuEjlSdK0RDcHLOCH8RnLfEF9LDVs=;
        b=nnCZ7zZ4cZOsfH8T1X4xjtL3YEyQjFlbL+Gj3awJX23CtloH0HKm3AS2sKC8sxEt8X
         mUQdy/S6et/gXPo6gYhHe3ZXgs1U6QSShbxfmDN2jJ8yiaTFaCJu6PBvtqlBvUbDUEpq
         /wS2gFPosN/Btw4YFuVO4tAZfUoyOqlj6fDw4tbVTW5YLmp2GVdDetu/4hf/fX2AeCMD
         xERnP0FPKuguibWJ3Aq+KjrHlp786z5uiIbuKv/IQPJxSv3K+TWhymEkwkRxbujPGQMc
         HlK1rh4S0U4z9UG5Rtp9QpbkU2Fkv0g0wVO8MQPrtZgjE/On0YkA+n7RD78lrddqiSJn
         v68A==
X-Forwarded-Encrypted: i=1; AFNElJ9SCnIB/Y2ddiHLBJh1G/lRWp269o/jgY4ltnh7MuQAil7WhoYzriIg58LiJSEd05S2T610Gko=@lists.linux.dev
X-Gm-Message-State: AOJu0Yz/354vZxsUrW7rBdICEUQPm7VTXE1JTZrXs2sMMLplK6WosXG6
	bAfaDag1stRu6oWHKDGRrPXMns2F51qgw+KT+yhkQRSd7FMWXc6tnzuWZdKMcFlInprVRz7YKK+
	LiLegNVsWFiSnHSg/Q2wChB2gRqydjX+WGp9DKVB2
X-Gm-Gg: AfdE7cl0ol2Yg44vx7EfmoNmLfDJDNaAVuAFL5VzT5331iloDd6mfclHyMN3KyzLRr1
	maqSbMWZocqTS0gOsBhiyEdCTigW6dy/8RbdZ8qr2oulRLokz99uEezRpz6+fXpbF1pe4c0Noq3
	ol//L0wniPqepcHvatdtknu7wZUNMNwd1awxaSAq6coBWsfzhC8KdUAerXFq4nWhdklKOxNWOAP
	dd/eY7Pp5nHtbt37UJp0tbLOTJm52U/FXHR5EfhS4WS8CPksUTbfDphGkX1A9RAsAzK5ynnz5nE
	aekWzU52eNoNStGeELtN/5mWBAtcO5e96kBGpgboC7Y45ZEPxyCGHxyAG/K4FdA92gefFUwMY0X
	KKiybirREbpC+GfH+epqkcDSBEXLGcbnwp97nDCO65JI=
X-Received: by 2002:a05:6820:180f:b0:6a1:50eb:2124 with SMTP id
 006d021491bc7-6a150eb2409mr5866972eaf.72.1782710764153; Sun, 28 Jun 2026
 22:26:04 -0700 (PDT)
Precedence: bulk
X-Mailing-List: syzbot@lists.linux.dev
List-Id: <syzbot.lists.linux.dev>
List-Subscribe: <mailto:syzbot+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:syzbot+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <6a40e8d9.ac7367b4.6675.000e.GAE@google.com>
In-Reply-To: <6a40e8d9.ac7367b4.6675.000e.GAE@google.com>
From: Aleksandr Nogikh <nogikh@google.com>
Date: Mon, 29 Jun 2026 07:25:53 +0200
X-Gm-Features: AVVi8Cd-KqK5rQl1bvFr_MqaqHJeeEJ37STclFwi_pVA6Xfd1LyCKtztZCUHGDY
Message-ID: <CANp29Y55PPoEQg1AK-Xv5C6K5W_YifWfNJDyy_6vjqDsszm7bA@mail.gmail.com>
Subject: Re: [moderation/CI] Re: minix: convert to iomap and add direct I/O
To: syzbot ci <syzbot+ci5c37f430385ce431@syzkaller.appspotmail.com>
Cc: syzkaller-upstream-moderation@googlegroups.com, syzbot@lists.linux.dev
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

#syz upstream

On Sun, Jun 28, 2026 at 11:26=E2=80=AFAM syzbot ci
<syzbot+ci5c37f430385ce431@syzkaller.appspotmail.com> wrote:
>
> syzbot ci has tested the following series
>
> [v2] minix: convert to iomap and add direct I/O
> https://lore.kernel.org/all/cover.1782619718.git.jbingham@gmail.com
> * [PATCH v2 1/4] minix: add iomap infrastructure
> * [PATCH v2 2/4] minix: convert address space operations to iomap
> * [PATCH v2 3/4] minix: convert file operations to iomap and add
> * [PATCH v2 4/4] minix: fix symlink and truncate for iomap
>
> and found the following issues:
> * BUG: sleeping function called from invalid context in bdev_getblk
> * BUG: sleeping function called from invalid context in find_get_block_co=
mmon
>
> Full report is available here:
> https://ci.syzbot.org/series/3b663c96-cf07-46e0-9b8d-785fe615029d
>
> ***
>
> BUG: sleeping function called from invalid context in bdev_getblk
>
> tree:      torvalds
> URL:       https://kernel.googlesource.com/pub/scm/linux/kernel/git/torva=
lds/linux
> base:      780d569e6c4b422290f5cba319eb904b355d64be
> arch:      amd64
> compiler:  Debian clang version 22.1.6 (++20260514074242+fc4aad7b5db3-1~e=
xp1~20260514074407.73), Debian LLD 22.1.6
> config:    https://ci.syzbot.org/builds/61f38821-60a2-4c7c-a39e-27291869d=
296/config
> syz repro: https://ci.syzbot.org/findings/dda4e5c2-7cbc-498a-98ea-83cad3c=
680e3/syz_repro
>
>          option from the mount to silence this warning.
> =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D
> BUG: sleeping function called from invalid context at ./include/linux/sch=
ed/mm.h:323
> in_atomic(): 0, irqs_disabled(): 0, non_block: 0, pid: 5865, name: syz.1.=
18
> preempt_count: 0, expected: 0
> RCU nest depth: 1, expected: 0
> 1 lock held by syz.1.18/5865:
>  #0: ffffffff8e959c20 (rcu_read_lock){....}-{1:3}, at: rcu_lock_acquire i=
nclude/linux/rcupdate.h:300 [inline]
>  #0: ffffffff8e959c20 (rcu_read_lock){....}-{1:3}, at: rcu_read_lock incl=
ude/linux/rcupdate.h:840 [inline]
>  #0: ffffffff8e959c20 (rcu_read_lock){....}-{1:3}, at: path_init+0x124/0x=
1330 fs/namei.c:2689
> CPU: 1 UID: 0 PID: 5865 Comm: syz.1.18 Not tainted syzkaller #0 PREEMPT(f=
ull)
> Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS 1.16.2-debian-1.=
16.2-1 04/01/2014
> Call Trace:
>  <TASK>
>  dump_stack_lvl+0xe8/0x150 lib/dump_stack.c:120
>  __might_resched+0x378/0x4d0 kernel/sched/core.c:9197
>  might_alloc include/linux/sched/mm.h:323 [inline]
>  bdev_getblk+0xce/0x6e0 fs/buffer.c:1435
>  __bread_gfp+0x89/0x380 fs/buffer.c:1493
>  sb_bread include/linux/buffer_head.h:348 [inline]
>  minix_get_link+0x143/0x340 fs/minix/namei.c:396
>  pick_link+0x782/0xfe0 fs/namei.c:2064
>  step_into_slowpath+0x58a/0x820 fs/namei.c:2127
>  step_into fs/namei.c:2152 [inline]
>  open_last_lookups fs/namei.c:4643 [inline]
>  path_openat+0x224e/0x3830 fs/namei.c:4856
>  do_file_open+0x23e/0x4a0 fs/namei.c:4888
>  do_sys_openat2+0x115/0x200 fs/open.c:1368
>  do_sys_open fs/open.c:1374 [inline]
>  __do_sys_openat fs/open.c:1390 [inline]
>  __se_sys_openat fs/open.c:1385 [inline]
>  __x64_sys_openat+0x138/0x170 fs/open.c:1385
>  do_syscall_x64 arch/x86/entry/syscall_64.c:63 [inline]
>  do_syscall_64+0x174/0x580 arch/x86/entry/syscall_64.c:94
>  entry_SYSCALL_64_after_hwframe+0x77/0x7f
> RIP: 0033:0x7f9618b9ce59
> Code: ff c3 66 2e 0f 1f 84 00 00 00 00 00 0f 1f 44 00 00 48 89 f8 48 89 f=
7 48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 ff=
 ff 73 01 c3 48 c7 c1 e8 ff ff ff f7 d8 64 89 01 48
> RSP: 002b:00007f9619a29028 EFLAGS: 00000246 ORIG_RAX: 0000000000000101
> RAX: ffffffffffffffda RBX: 00007f9618e15fa0 RCX: 00007f9618b9ce59
> RDX: 0000000000105042 RSI: 0000200000000080 RDI: ffffffffffffff9c
> RBP: 00007f9618c32e6f R08: 0000000000000000 R09: 0000000000000000
> R10: 00000000000001ff R11: 0000000000000246 R12: 0000000000000000
> R13: 00007f9618e16038 R14: 00007f9618e15fa0 R15: 00007fffce8916b8
>  </TASK>
>
>
> ***
>
> BUG: sleeping function called from invalid context in find_get_block_comm=
on
>
> tree:      torvalds
> URL:       https://kernel.googlesource.com/pub/scm/linux/kernel/git/torva=
lds/linux
> base:      780d569e6c4b422290f5cba319eb904b355d64be
> arch:      amd64
> compiler:  Debian clang version 22.1.6 (++20260514074242+fc4aad7b5db3-1~e=
xp1~20260514074407.73), Debian LLD 22.1.6
> config:    https://ci.syzbot.org/builds/61f38821-60a2-4c7c-a39e-27291869d=
296/config
> syz repro: https://ci.syzbot.org/findings/2af8da3b-836a-479e-9af0-fef473c=
2f315/syz_repro
>
> loop2: detected capacity change from 0 to 64
> bad symlink on inode 4
> BUG: sleeping function called from invalid context at ./include/linux/pag=
emap.h:1155
> in_atomic(): 0, irqs_disabled(): 0, non_block: 0, pid: 5813, name: syz.2.=
19
> preempt_count: 0, expected: 0
> RCU nest depth: 1, expected: 0
> 1 lock held by syz.2.19/5813:
>  #0: ffffffff8e959c20 (rcu_read_lock){....}-{1:3}, at: rcu_lock_acquire i=
nclude/linux/rcupdate.h:300 [inline]
>  #0: ffffffff8e959c20 (rcu_read_lock){....}-{1:3}, at: rcu_read_lock incl=
ude/linux/rcupdate.h:840 [inline]
>  #0: ffffffff8e959c20 (rcu_read_lock){....}-{1:3}, at: path_init+0x124/0x=
1330 fs/namei.c:2689
> CPU: 1 UID: 0 PID: 5813 Comm: syz.2.19 Not tainted syzkaller #0 PREEMPT(f=
ull)
> Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS 1.16.2-debian-1.=
16.2-1 04/01/2014
> Call Trace:
>  <TASK>
>  dump_stack_lvl+0xe8/0x150 lib/dump_stack.c:120
>  __might_resched+0x378/0x4d0 kernel/sched/core.c:9197
>  folio_lock include/linux/pagemap.h:1155 [inline]
>  __find_get_block_slow fs/buffer.c:242 [inline]
>  find_get_block_common+0x2d0/0xe10 fs/buffer.c:1386
>  bdev_getblk+0x58/0x6e0 include/linux/gfp.h:-1
>  __bread_gfp+0x89/0x380 fs/buffer.c:1493
>  sb_bread include/linux/buffer_head.h:348 [inline]
>  minix_get_link+0x143/0x340 fs/minix/namei.c:396
>  pick_link+0x782/0xfe0 fs/namei.c:2064
>  step_into_slowpath+0x58a/0x820 fs/namei.c:2127
>  step_into fs/namei.c:2152 [inline]
>  open_last_lookups fs/namei.c:4643 [inline]
>  path_openat+0x224e/0x3830 fs/namei.c:4856
>  do_file_open+0x23e/0x4a0 fs/namei.c:4888
>  do_sys_openat2+0x115/0x200 fs/open.c:1368
>  do_sys_open fs/open.c:1374 [inline]
>  __do_sys_openat fs/open.c:1390 [inline]
>  __se_sys_openat fs/open.c:1385 [inline]
>  __x64_sys_openat+0x138/0x170 fs/open.c:1385
>  do_syscall_x64 arch/x86/entry/syscall_64.c:63 [inline]
>  do_syscall_64+0x174/0x580 arch/x86/entry/syscall_64.c:94
>  entry_SYSCALL_64_after_hwframe+0x77/0x7f
> RIP: 0033:0x7fd37ef9ce59
> Code: ff c3 66 2e 0f 1f 84 00 00 00 00 00 0f 1f 44 00 00 48 89 f8 48 89 f=
7 48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 ff=
 ff 73 01 c3 48 c7 c1 e8 ff ff ff f7 d8 64 89 01 48
> RSP: 002b:00007fd37fe06028 EFLAGS: 00000246 ORIG_RAX: 0000000000000101
> RAX: ffffffffffffffda RBX: 00007fd37f215fa0 RCX: 00007fd37ef9ce59
> RDX: 0000000000000042 RSI: 0000200000000080 RDI: ffffffffffffff9c
> RBP: 00007fd37f032e6f R08: 0000000000000000 R09: 0000000000000000
> R10: 0000000000000000 R11: 0000000000000246 R12: 0000000000000000
> R13: 00007fd37f216038 R14: 00007fd37f215fa0 R15: 00007ffe5e5f14f8
>  </TASK>
> bad symlink on inode 4
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
> [brauner@kernel.org hch@infradead.org jack@suse.cz jbingham@gmail.com jko=
olstra@xs4all.nl linux-fsdevel@vger.kernel.org linux-kernel@vger.kernel.org=
 syzkaller@googlegroups.com viro@zeniv.linux.org.uk]
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
-upstream-moderation/6a40e8d9.ac7367b4.6675.000e.GAE%40google.com.
