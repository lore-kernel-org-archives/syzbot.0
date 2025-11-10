Received: from mail-ot1-f45.google.com (mail-ot1-f45.google.com [209.85.210.45])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0383C24677D
	for <syzbot@lists.linux.dev>; Mon, 10 Nov 2025 15:17:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.45
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762787868; cv=none; b=kq9gYhcXCTvMMj5Cehkk2nIYGdKbf99n/QBJFneYZzTQLgTRUsQZbBEXK2Rk8OLMX5JwzSRR6OYQPwwbrn7oZ2uYjSseaW5Cf2qna5PibPokrB2u8G97AKGx92PUV/72nO9h5pnZ9Ej/kChlBeI/PErNLa8gWYWbYQ1MRH9vZik=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762787868; c=relaxed/simple;
	bh=l+GouACfLMaRNiwx8ODlbR4TFykrsRiz4ofk4VKgSoo=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=n2FVc4U3BrmeNcnej6NFElpu/R9tB19Idsk3CHFShQ5FgkvoiPxzxIrHFm84WinSvbwkTl/FbmKTPuTf936mTgEW0jVNSE76m7HRTMSRnzTg32zlKRPETRRHqDOECLfCJl7NNQSpgTA7t+nxqicONwtjEh7/eQi1OFy3VwovlDA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=zQayLHxZ; arc=none smtp.client-ip=209.85.210.45
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="zQayLHxZ"
Received: by mail-ot1-f45.google.com with SMTP id 46e09a7af769-7c6e815310aso1890915a34.0
        for <syzbot@lists.linux.dev>; Mon, 10 Nov 2025 07:17:46 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1762787866; x=1763392666; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=insqb0imX2nlJbOM7Yn5qXQ44oOBPPiRhJZ1WddP7Nw=;
        b=zQayLHxZ9eftfm12cm+GdQAUrmc6XTFmPVwN0yrraeEYpTDtstVQpaB3WV9gmG0iON
         UL/fY1VtiQkD5rgV16mTLzMTHUnvV0PCd4alFw79uq5iX/ACj9y2ml+jL9AvyybPkrLc
         x/NeyDf+T3eNAdL2Jqj+i168lAPcnfDubDLr7BFnB58cOk8AJGG+SgCBthpFS2ajVcxl
         VmrOmVCBI0XMgYqmZu7pdj7UsE2UABgajtQedx3wqN02xBYhn4k13GKc8vRIzIqstpOR
         kFi0kiOXt3zgjuaTienSrWK+AZjhi0zfICBWZRnaQicWezgrgQtdhAZh7a9MyZozOy46
         iMLA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1762787866; x=1763392666;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=insqb0imX2nlJbOM7Yn5qXQ44oOBPPiRhJZ1WddP7Nw=;
        b=qjuPfAQzdmaRoNa1X7/rW/rLT8L3HN5y31pDNA42VWcxeAvlhIYo2toc181coSmj9b
         vgVbJdVWeix+7+KSjg0oJkKagOx02c2aYL7iC1KLWOd8eaSoPCPiF51G34Bc0sBVswmF
         O0cNr4M8zmwBNKt3bAWrRarwUXm+S9Cd0hXbdDrs59ViKw5Ct+yNF6g1giBY/WBUOph2
         ZxedscV4v0fEf6v5OvHkgGx+Yfbv3mmKqhv4QRzR9/mNTmh/UBOqJG9HCOiNUwt5ekq/
         WvJTZfBrNbgAg9EYfIUZN+Q7sJ6dxqVzBkxH5p3t8H7JdFazWO+MZODVYDRoOuXe5jWQ
         fP0Q==
X-Forwarded-Encrypted: i=1; AJvYcCVmW7iG2sscgfcZ4Kaf354mYUgQK5AJFSI8W1z3gQ7YH8ibfvrmBBs8OUyu7HgbHx7IP3IJ0p0=@lists.linux.dev
X-Gm-Message-State: AOJu0YxqYr0qbXcTIOHFuMyBvBbtRJ2EBBZ80aq4pTiobl/4dGA746Wt
	wILmEKW+/haVD+QU9uR7Hl6i9EqDfUcb6iTOKkqNzkJy4QXGHfOdCx+Yz2r6ggpjEcDUeJaFvst
	YuUbKvc8Ge4tqYha07SS5lL3fImc5X8eSXPDwDE5w
X-Gm-Gg: ASbGncso8TRrlYNqO8WfrtWPZIOqRDIWu4CZnJORus7Y10EbeJjll1S/Bqn2ebuPnLl
	+qX0NOsIpElfgHL+c0GswexKZ1Hfvr6B2+VmTWpELUUD6JldlJ0Ggq10qNq3k2W1O/J6jb02SBw
	deZqz346ZpaiM4cDiau1nDD5FxvXYpE+nvT7PIvyUI3tJ3QEqCFzEsfXQF7rKjGr7aVStCgFnGY
	gQfQpOXSACYKSjt87KX3nJCxzOHblC7QSgDK9enz1CkCGxYD+ri49ghY0d6FfxIzVERWdNCXeV1
	53zXPSvr9+rh4+G4Uh+ivCqd4/bmQyd2ZgZMF7cNYiptqGM=
X-Google-Smtp-Source: AGHT+IEgUzGLnoXRm2DlDzxEpNJXpkibcVmlY4h5s/RtzU+Zz+/AkgAeWvFKMWTrA2FZcU6jvQ/HwEXMxGxbgfO3kTA=
X-Received: by 2002:a05:6808:2f18:b0:438:430b:3dce with SMTP id
 5614622812f47-4502a3211a3mr4515908b6e.10.1762787865471; Mon, 10 Nov 2025
 07:17:45 -0800 (PST)
Precedence: bulk
X-Mailing-List: syzbot@lists.linux.dev
List-Id: <syzbot.lists.linux.dev>
List-Subscribe: <mailto:syzbot+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:syzbot+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <69120149.a70a0220.22f260.00f5.GAE@google.com>
In-Reply-To: <69120149.a70a0220.22f260.00f5.GAE@google.com>
From: Aleksandr Nogikh <nogikh@google.com>
Date: Mon, 10 Nov 2025 16:17:31 +0100
X-Gm-Features: AWmQ_bnzE1seJom_Q0iCFRsXdGUbs2CK0XtDetcUrW5XZWifNUB9dx4mpQvwAr4
Message-ID: <CANp29Y4jMb-2+C6+wvoyEXfuxi47jeQd41H6fY_44oUOuKE0eg@mail.gmail.com>
Subject: Re: [moderation/CI] Re: mm/hugetlb: fix possible deadlocks in hugetlb
 VMA unmap paths
To: syzbot ci <syzbot+cib881ceec4291ccf4@syzkaller.appspotmail.com>
Cc: syzkaller-upstream-moderation@googlegroups.com, syzbot@lists.linux.dev
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

#syz upstream

On Mon, Nov 10, 2025 at 4:14=E2=80=AFPM syzbot ci
<syzbot+cib881ceec4291ccf4@syzkaller.appspotmail.com> wrote:
>
> syzbot ci has tested the following series
>
> [v2] mm/hugetlb: fix possible deadlocks in hugetlb VMA unmap paths
> https://lore.kernel.org/all/20251110111553.88384-1-lance.yang@linux.dev
> * [PATCH v2 1/1] mm/hugetlb: fix possible deadlocks in hugetlb VMA unmap =
paths
>
> and found the following issue:
> possible deadlock in unmap_vmas
>
> Full report is available here:
> https://ci.syzbot.org/series/3106300b-af9f-40dc-985b-33cb937712aa
>
> ***
>
> possible deadlock in unmap_vmas
>
> tree:      mm-new
> URL:       https://kernel.googlesource.com/pub/scm/linux/kernel/git/akpm/=
mm.git
> base:      02dafa01ec9a00c3758c1c6478d82fe601f5f1ba
> arch:      amd64
> compiler:  Debian clang version 20.1.8 (++20250708063551+0c9f909b7976-1~e=
xp1~20250708183702.136), Debian LLD 20.1.8
> config:    https://ci.syzbot.org/builds/089d8dad-bc85-4724-8a79-2ad934bec=
f17/config
> C repro:   https://ci.syzbot.org/findings/3dded3f6-aef2-4f4c-9dba-b23214d=
f5e12/c_repro
> syz repro: https://ci.syzbot.org/findings/3dded3f6-aef2-4f4c-9dba-b23214d=
f5e12/syz_repro
>
> =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D
> WARNING: possible circular locking dependency detected
> syzkaller #0 Not tainted
> ------------------------------------------------------
> syz.0.17/5963 is trying to acquire lock:
> ffff88816cbda8e8 (&resv_map->rw_sema){+.+.}-{4:4}, at: hugetlb_zap_begin =
include/linux/hugetlb.h:257 [inline]
> ffff88816cbda8e8 (&resv_map->rw_sema){+.+.}-{4:4}, at: unmap_vmas+0x23d/0=
x580 mm/memory.c:2098
>
> but task is already holding lock:
> ffff888172c80418 (&hugetlbfs_i_mmap_rwsem_key){+.+.}-{4:4}, at: i_mmap_lo=
ck_write include/linux/fs.h:548 [inline]
> ffff888172c80418 (&hugetlbfs_i_mmap_rwsem_key){+.+.}-{4:4}, at: __hugetlb=
_zap_begin+0x2aa/0x3a0 mm/hugetlb.c:5331
>
> which lock already depends on the new lock.
>
>
> the existing dependency chain (in reverse order) is:
>
> -> #1 (&hugetlbfs_i_mmap_rwsem_key){+.+.}-{4:4}:
>        lock_acquire+0x120/0x360 kernel/locking/lockdep.c:5868
>        down_write+0x96/0x1f0 kernel/locking/rwsem.c:1590
>        i_mmap_lock_write include/linux/fs.h:548 [inline]
>        hugetlb_change_protection+0x56a/0x18c0 mm/hugetlb.c:6439
>        change_protection+0x386/0x38c0 mm/mprotect.c:655
>        mprotect_fixup+0x6fe/0x9c0 mm/mprotect.c:774
>        do_mprotect_pkey+0x8c5/0xcd0 mm/mprotect.c:930
>        __do_sys_mprotect mm/mprotect.c:951 [inline]
>        __se_sys_mprotect mm/mprotect.c:948 [inline]
>        __x64_sys_mprotect+0x80/0x90 mm/mprotect.c:948
>        do_syscall_x64 arch/x86/entry/syscall_64.c:63 [inline]
>        do_syscall_64+0xfa/0xfa0 arch/x86/entry/syscall_64.c:94
>        entry_SYSCALL_64_after_hwframe+0x77/0x7f
>
> -> #0 (&resv_map->rw_sema){+.+.}-{4:4}:
>        check_prev_add kernel/locking/lockdep.c:3165 [inline]
>        check_prevs_add kernel/locking/lockdep.c:3284 [inline]
>        validate_chain+0xb9b/0x2140 kernel/locking/lockdep.c:3908
>        __lock_acquire+0xab9/0xd20 kernel/locking/lockdep.c:5237
>        lock_acquire+0x120/0x360 kernel/locking/lockdep.c:5868
>        down_write+0x96/0x1f0 kernel/locking/rwsem.c:1590
>        hugetlb_zap_begin include/linux/hugetlb.h:257 [inline]
>        unmap_vmas+0x23d/0x580 mm/memory.c:2098
>        exit_mmap+0x23e/0xb30 mm/mmap.c:1277
>        __mmput+0x118/0x430 kernel/fork.c:1133
>        exit_mm+0x1da/0x2c0 kernel/exit.c:582
>        do_exit+0x648/0x2300 kernel/exit.c:954
>        do_group_exit+0x21c/0x2d0 kernel/exit.c:1107
>        __do_sys_exit_group kernel/exit.c:1118 [inline]
>        __se_sys_exit_group kernel/exit.c:1116 [inline]
>        __x64_sys_exit_group+0x3f/0x40 kernel/exit.c:1116
>        x64_sys_call+0x21f7/0x2200 arch/x86/include/generated/asm/syscalls=
_64.h:232
>        do_syscall_x64 arch/x86/entry/syscall_64.c:63 [inline]
>        do_syscall_64+0xfa/0xfa0 arch/x86/entry/syscall_64.c:94
>        entry_SYSCALL_64_after_hwframe+0x77/0x7f
>
> other info that might help us debug this:
>
>  Possible unsafe locking scenario:
>
>        CPU0                    CPU1
>        ----                    ----
>   lock(&hugetlbfs_i_mmap_rwsem_key);
>                                lock(&resv_map->rw_sema);
>                                lock(&hugetlbfs_i_mmap_rwsem_key);
>   lock(&resv_map->rw_sema);
>
>  *** DEADLOCK ***
>
> 2 locks held by syz.0.17/5963:
>  #0: ffff88810e0f8ca0 (&mm->mmap_lock){++++}-{4:4}, at: mmap_read_lock in=
clude/linux/mmap_lock.h:365 [inline]
>  #0: ffff88810e0f8ca0 (&mm->mmap_lock){++++}-{4:4}, at: exit_mmap+0x126/0=
xb30 mm/mmap.c:1262
>  #1: ffff888172c80418 (&hugetlbfs_i_mmap_rwsem_key){+.+.}-{4:4}, at: i_mm=
ap_lock_write include/linux/fs.h:548 [inline]
>  #1: ffff888172c80418 (&hugetlbfs_i_mmap_rwsem_key){+.+.}-{4:4}, at: __hu=
getlb_zap_begin+0x2aa/0x3a0 mm/hugetlb.c:5331
>
> stack backtrace:
> CPU: 1 UID: 0 PID: 5963 Comm: syz.0.17 Not tainted syzkaller #0 PREEMPT(f=
ull)
> Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS 1.16.2-debian-1.=
16.2-1 04/01/2014
> Call Trace:
>  <TASK>
>  dump_stack_lvl+0x189/0x250 lib/dump_stack.c:120
>  print_circular_bug+0x2ee/0x310 kernel/locking/lockdep.c:2043
>  check_noncircular+0x134/0x160 kernel/locking/lockdep.c:2175
>  check_prev_add kernel/locking/lockdep.c:3165 [inline]
>  check_prevs_add kernel/locking/lockdep.c:3284 [inline]
>  validate_chain+0xb9b/0x2140 kernel/locking/lockdep.c:3908
>  __lock_acquire+0xab9/0xd20 kernel/locking/lockdep.c:5237
>  lock_acquire+0x120/0x360 kernel/locking/lockdep.c:5868
>  down_write+0x96/0x1f0 kernel/locking/rwsem.c:1590
>  hugetlb_zap_begin include/linux/hugetlb.h:257 [inline]
>  unmap_vmas+0x23d/0x580 mm/memory.c:2098
>  exit_mmap+0x23e/0xb30 mm/mmap.c:1277
>  __mmput+0x118/0x430 kernel/fork.c:1133
>  exit_mm+0x1da/0x2c0 kernel/exit.c:582
>  do_exit+0x648/0x2300 kernel/exit.c:954
>  do_group_exit+0x21c/0x2d0 kernel/exit.c:1107
>  __do_sys_exit_group kernel/exit.c:1118 [inline]
>  __se_sys_exit_group kernel/exit.c:1116 [inline]
>  __x64_sys_exit_group+0x3f/0x40 kernel/exit.c:1116
>  x64_sys_call+0x21f7/0x2200 arch/x86/include/generated/asm/syscalls_64.h:=
232
>  do_syscall_x64 arch/x86/entry/syscall_64.c:63 [inline]
>  do_syscall_64+0xfa/0xfa0 arch/x86/entry/syscall_64.c:94
>  entry_SYSCALL_64_after_hwframe+0x77/0x7f
> RIP: 0033:0x7f6bb058efc9
> Code: Unable to access opcode bytes at 0x7f6bb058ef9f.
> RSP: 002b:00007ffedbb6b2f8 EFLAGS: 00000246 ORIG_RAX: 00000000000000e7
> RAX: ffffffffffffffda RBX: 0000000000000000 RCX: 00007f6bb058efc9
> RDX: 0000000000000064 RSI: 0000000000000000 RDI: 0000000000000000
> RBP: 0000000000000003 R08: 00000002dbb6b3ef R09: 00007f6bb07b1280
> R10: 0000000000000001 R11: 0000000000000246 R12: 0000000000000000
> R13: 00007f6bb07b1280 R14: 0000000000000003 R15: 00007ffedbb6b3b0
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
> [akpm@linux-foundation.org david@redhat.com lance.yang@linux.dev linux-ke=
rnel@vger.kernel.org linux-mm@kvack.org muchun.song@linux.dev osalvador@sus=
e.de syzbot@lists.linux.dev syzbot@syzkaller.appspotmail.com syzkaller-bugs=
@googlegroups.com]
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
-upstream-moderation/69120149.a70a0220.22f260.00f5.GAE%40google.com.
