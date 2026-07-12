Received: from mail-qv1-f47.google.com (mail-qv1-f47.google.com [209.85.219.47])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DE915368D4C
	for <syzbot@lists.linux.dev>; Sun, 12 Jul 2026 18:23:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.219.47
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783880618; cv=pass; b=i/TNcrqXJwqHSLzwpHdoU0nIy4E6hHdvXQTSMqNb1g3iZ7p1bJZ2l8aZ+HGgikI7S9V8Pi+WMCa9iC3UgxFSu39Q++ZECtYK4SC7g0Kfuq9vzkhQm1Q1Kn3mfy3qCZ+Sbj7ubMVwzqlq4NsvHxGEUHYuiY/HGhK5Taeptg7nveQ=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783880618; c=relaxed/simple;
	bh=TUaCkLWWRYnwBwA9z+42ZA+Np7h7+gaETlDRoibZDgg=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=PIq17eVxcp1HUJHOtBhcn9yiFLRR/io9NluMVe6tBJ0iWDXCBke0045B1A1hGW+apIZi+mrOlBL+RDXQmKUWlZQgoxXUdV5yer0oBQIq5h5J8XIpV3sPlz/qTrYNNW7p5yQhc2fM8UvM/xTsGRIdLNEdYfSgTwm7FZyn+RKBA/A=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=F3QP7r/a; arc=pass smtp.client-ip=209.85.219.47
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="F3QP7r/a"
Received: by mail-qv1-f47.google.com with SMTP id 6a1803df08f44-8f0d6853360so18228416d6.0
        for <syzbot@lists.linux.dev>; Sun, 12 Jul 2026 11:23:35 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1783880615; cv=none;
        d=google.com; s=arc-20260327;
        b=SUYk0rG1hoYe64+GGVbdW/FV+KE7HTnpTHe3vW6ZGg3iGDYz0KEDsw34/cSJ/yju1M
         du/+1vvLvQ417LtJGn5UA0BrsS7vO902tLAAyW6wrNLTR3H+u+yJXBnVt86BRO+wM7ET
         FEboILKA9u+pdk0gcY5uCDaO83+0X1owG8I2uAjdbxteaFb5M/kKUDDM0DydWcjWyx4L
         F22Cgvwz35yrw/RaUhWLGmUZPahD9+jK72E3r1G0hfgeDWfN9Q7hpUKMUI661PstI6yf
         NnM4vDxOIIqEbt4E11SjccZuj3l+JGpGVsK3ThrRm1aqz3zdVQd0I3rbXG+XipkVYlCw
         Lbiw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=6Ie6UYBf8nZ4y6wIm52qoNHQhjZrwHXGmt7fYZ2HRWs=;
        fh=fXWMDMDuFCqxR76sJzfv3SyeCy5cv8FIQSqiRzTPwd8=;
        b=AR9KQ69c6kirqOu6jnfFI/mBxn+FMBqshkPqQi35vKi5IwCMq9xNMfKdCj8ClQYWby
         hIZu+3IYAjQHjdgstf4JnrNUfKz7dW2QYl6RQs+Y/HCQJYoirn5iTDu7FPv3J4C0wPag
         FRl03dhV9gmY/BbNYyz1Jl1UHxps5eSlznA+SLSWxNmIpo7fYQhUuTH3u1tBquVS2W66
         9l4LYMvAf1PpE6jdPfFj/gasGziUcpRa2O/NehUl28W9yxt0ZqwG5GhuSPrSXCYKC12w
         fPn3eQsgm3QrwUlolxFiw73+S2Ns8CReFF1YvFUX4o4gZtxJEunr5BsMRYWjCwTF6mqB
         Lnsw==;
        darn=lists.linux.dev
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1783880615; x=1784485415; darn=lists.linux.dev;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=6Ie6UYBf8nZ4y6wIm52qoNHQhjZrwHXGmt7fYZ2HRWs=;
        b=F3QP7r/aHtx+SUJa9oFw5Fu2ZrHgQDr7Pr7rRxT4EyRdI5UbYohRiktSE2pxB+oSvw
         XpekpuWVu3dCAulEr47XwvIo8d8tEJ2m1/ZHVgxARwTNoatuwvkMIBZPJTkbz12wo6Hw
         +Oq2C+++l+1QmZ4/QeGB1GxQ8Hv7tEPBIA+dAYM7+dpPdbZDcaT3bdHnjDCXAsgHP6Wl
         WRcFE3aaDrHm1d2YJAVUQsUr3uOC1qU1Lw5q8rl6gtjDdUg6JUK00TL9NX3AUPYm9S3W
         49GxHqN1Ms92TfMSut8SLFIL3hTFRHn57usjlR8brHtRXeKVB3EY/v88SzboMRporjGF
         vMhA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1783880615; x=1784485415;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=6Ie6UYBf8nZ4y6wIm52qoNHQhjZrwHXGmt7fYZ2HRWs=;
        b=DhslOIDVDhftAF8H6kh4LQxdTclK0IJm+fpgxiOYM1smlfsiPNksumetaEUAxWA7bE
         axQCUOX9n3BWhgxEDwSPSTMkd/9GwNyy//6wJsRw7vktYQu+fBOr9DVPGPj+nwL39Wb0
         8nHRgNhRPlPiXZOQwlfPZnERYMJfHwoWDTb0XpmyOhAVRHKdCeu0V+fH2ajGhKwXBt62
         QJPfsRtfIBdPaps9fRaBz/bf2/o+qWFqQpWfMCDJNYAF+lHxSW5bmqf05rbNUaqAcaJ8
         kEenY+R6HbZFhEZN0ubOwx+1p6c+s6gWPKJghESaeW6e8QsAJGN6wuAsXPo71U33nRPl
         AjQA==
X-Forwarded-Encrypted: i=1; AHgh+RpmOdgOIenxGKHzCVOQShi7dkA5UZs+MVc6YxM/Xe0CYzCXy+B56l1vj2JnIAv49QCJKbCATM4=@lists.linux.dev
X-Gm-Message-State: AOJu0YyC1YvwmGm6ET2Z1VnOD4xRbh8XZjYnFJX6Pxunje/Ex1tzD9wz
	q2/9IEcBfVluEnYeNAnGHW1tRVG3LndWCCmV4YRZPMsDE4GnQYGvSXXvP+XHsk+JV+123YiPlLa
	fugxTOeQ7RwZeiGa98CAyvcBTHPLyrZf7Tca7rzJB
X-Gm-Gg: AfdE7cnJ5LNlZai/cXjkujxh4jma/mkxXg7VDkrzDBvvr8EWQ/+yNERNxon/C0pJGtT
	9DgJDd5yFsHrKNdLkqduzAD+k+IsX/vSf6nMayNUIRKeon7rhCFKbixW/ZAHyxn5n299e8UBp86
	KtbFmxoj2ds0Hg80MC0SZiV3MaojVFnlwfvN3cmxd6uwxpiDOm0BFbYhMl2QHcltdZXVBsaK/1e
	YpB97kg2+OG8aiBRLt5flhNHdIycMseCQcfTLlr8wfgO4mJ5Fc/azndjNxMtU/rl1LFNQW0FifR
	efmxkx3zf4Fma9CYO6U/yYzIgBI+d2ZFuqVmzxCNg+zjhbXsc16FJJ64eqVi
X-Received: by 2002:a05:6214:238a:b0:8ef:e857:c9d6 with SMTP id
 6a1803df08f44-903ff659b49mr69519606d6.22.1783880614135; Sun, 12 Jul 2026
 11:23:34 -0700 (PDT)
Precedence: bulk
X-Mailing-List: syzbot@lists.linux.dev
List-Id: <syzbot.lists.linux.dev>
List-Subscribe: <mailto:syzbot+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:syzbot+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <6a53d511.278cdcd2.e885.001e.GAE@google.com>
In-Reply-To: <6a53d511.278cdcd2.e885.001e.GAE@google.com>
From: Pimyn Girgis <pimyn@google.com>
Date: Sun, 12 Jul 2026 20:23:23 +0200
X-Gm-Features: AUfX_my1k2LrbeFk85ros6oI-rTPl11tReU4a0gJ09o718hDUN3m2PbdmzG2DWU
Message-ID: <CAJWNTGz=cFG4=MZQ6Fmb98i5yysBvuPBJWFN+C0gnR-oXC_iJw@mail.gmail.com>
Subject: Re: [moderation/CI] Re: mm: batch rmap walks during large folio migration
To: syzbot ci <syzbot+ci91cf95b6bb9daba3@syzkaller.appspotmail.com>
Cc: syzkaller-upstream-moderation@googlegroups.com, syzbot@lists.linux.dev
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

#syz upstream


On Sun, Jul 12, 2026 at 7:55=E2=80=AFPM syzbot ci
<syzbot+ci91cf95b6bb9daba3@syzkaller.appspotmail.com> wrote:
>
> syzbot ci has tested the following series
>
> [v1] mm: batch rmap walks during large folio migration
> https://lore.kernel.org/all/20260712-migrate-rmap-batch-v1-0-872a734431d1=
@amd.com
> * [PATCH 1/6] mm/rmap: Add batched version of folio_try_share_anon_rmap_p=
te
> * [PATCH 2/6] mm: factor out generic PTE batch detection from swap_pte_ba=
tch()
> * [PATCH 3/6] mm/migrate: split remove_migration_pte_hugetlb() out of rem=
ove_migration_pte()
> * [PATCH 4/6] mm/migrate: batch the restore-side migration rmap walk
> * [PATCH 5/6] mm/rmap: split try_to_migrate_hugetlb_one() out of try_to_m=
igrate_one()
> * [PATCH 6/6] mm/rmap: batch the unmap of large folios in try_to_migrate_=
one()
>
> and found the following issues:
> * BUG: scheduling while atomic in exit_to_user_mode_loop
> * BUG: sleeping function called from invalid context in migrate_pages
> * BUG: sleeping function called from invalid context in migrate_pages_bat=
ch
> * BUG: sleeping function called from invalid context in move_pages
> * BUG: sleeping function called from invalid context in store_status
>
> Full report is available here:
> https://ci.syzbot.org/series/f6ed0914-22d0-4ad7-be5e-be4ed8fb9961
>
> ***
>
> BUG: scheduling while atomic in exit_to_user_mode_loop
>
> tree:      mm-new
> URL:       https://kernel.googlesource.com/pub/scm/linux/kernel/git/akpm/=
mm.git
> base:      61cccb8363fcc282d4ae0555b8739dd227f5ad0b
> arch:      amd64
> compiler:  Debian clang version 22.1.6 (++20260514074242+fc4aad7b5db3-1~e=
xp1~20260514074407.73), Debian LLD 22.1.6
> config:    https://ci.syzbot.org/builds/a27db994-58f5-48f4-a7f5-528b63f5a=
7c6/config
> syz repro: https://ci.syzbot.org/findings/72fb0597-196f-4679-88a2-7d2dafd=
a8454/syz_repro
>
> BUG: scheduling while atomic: syz.0.17/5797/0x00000002
> 1 lock held by syz.0.17/5797:
>  #0: ffff88810aa64e58 (ptlock_ptr(ptdesc)){+.+.}-{3:3}, at: spin_lock inc=
lude/linux/spinlock.h:342 [inline]
>  #0: ffff88810aa64e58 (ptlock_ptr(ptdesc)){+.+.}-{3:3}, at: huge_pte_lock=
+0x17b/0x1e0 include/linux/hugetlb.h:1318
> Modules linked in:
> Preemption disabled at:
> [<0000000000000000>] 0x0
> Kernel panic - not syncing: scheduling while atomic: panic_on_warn set ..=
.
> CPU: 0 UID: 0 PID: 5797 Comm: syz.0.17 Not tainted syzkaller #0 PREEMPT(f=
ull)
> Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS 1.16.2-debian-1.=
16.2-1 04/01/2014
> Call Trace:
>  <TASK>
>  vpanic+0x56c/0xa60 kernel/panic.c:651
>  panic+0xc5/0xd0 kernel/panic.c:788
>  check_panic_on_warn+0x89/0xb0 kernel/panic.c:525
>  __schedule_bug+0xf6/0x150 kernel/sched/core.c:6061
>  schedule_debug kernel/sched/core.c:6090 [inline]
>  __schedule+0x189d/0x56c0 kernel/sched/core.c:7083
>  __schedule_loop kernel/sched/core.c:7311 [inline]
>  schedule+0x164/0x2b0 kernel/sched/core.c:7326
>  __exit_to_user_mode_loop kernel/entry/common.c:55 [inline]
>  exit_to_user_mode_loop+0x83/0x730 kernel/entry/common.c:101
>  __exit_to_user_mode_prepare include/linux/irq-entry-common.h:207 [inline=
]
>  syscall_exit_to_user_mode_prepare include/linux/irq-entry-common.h:230 [=
inline]
>  syscall_exit_to_user_mode include/linux/entry-common.h:318 [inline]
>  do_syscall_64+0x353/0x580 arch/x86/entry/syscall_64.c:100
>  entry_SYSCALL_64_after_hwframe+0x77/0x7f
> RIP: 0033:0x7f1b3439ce59
> Code: ff c3 66 2e 0f 1f 84 00 00 00 00 00 0f 1f 44 00 00 48 89 f8 48 89 f=
7 48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 ff=
 ff 73 01 c3 48 c7 c1 e8 ff ff ff f7 d8 64 89 01 48
> RSP: 002b:00007ffc9098d528 EFLAGS: 00000246 ORIG_RAX: 00000000000000ed
> RAX: 0000000000000000 RBX: 00007f1b34615fa0 RCX: 00007f1b3439ce59
> RDX: 0000000000004000 RSI: 0000000000002000 RDI: 0000200000195000
> RBP: 00007f1b34432e6f R08: 0000000000000008 R09: 0000000000000003
> R10: 0000200000000400 R11: 0000000000000246 R12: 0000000000000000
> R13: 00007f1b34615fac R14: 00007f1b34615fa0 R15: 00007f1b34615fa0
>  </TASK>
> Kernel Offset: disabled
> Rebooting in 86400 seconds..
>
>
> ***
>
> BUG: sleeping function called from invalid context in migrate_pages
>
> tree:      mm-new
> URL:       https://kernel.googlesource.com/pub/scm/linux/kernel/git/akpm/=
mm.git
> base:      61cccb8363fcc282d4ae0555b8739dd227f5ad0b
> arch:      amd64
> compiler:  Debian clang version 22.1.6 (++20260514074242+fc4aad7b5db3-1~e=
xp1~20260514074407.73), Debian LLD 22.1.6
> config:    https://ci.syzbot.org/builds/a27db994-58f5-48f4-a7f5-528b63f5a=
7c6/config
> syz repro: https://ci.syzbot.org/findings/9dd2d2c8-a699-4e7c-8f73-4400d30=
57853/syz_repro
>
> BUG: sleeping function called from invalid context at mm/migrate.c:1741
> in_atomic(): 1, irqs_disabled(): 0, non_block: 0, pid: 5809, name: syz.0.=
17
> preempt_count: 1, expected: 0
> RCU nest depth: 0, expected: 0
> 1 lock held by syz.0.17/5809:
>  #0: ffff88817766d6d8 (ptlock_ptr(ptdesc)){+.+.}-{3:3}, at: spin_lock inc=
lude/linux/spinlock.h:342 [inline]
>  #0: ffff88817766d6d8 (ptlock_ptr(ptdesc)){+.+.}-{3:3}, at: huge_pte_lock=
+0x17b/0x1e0 include/linux/hugetlb.h:1318
> Preemption disabled at:
> [<0000000000000000>] 0x0
> CPU: 1 UID: 0 PID: 5809 Comm: syz.0.17 Not tainted syzkaller #0 PREEMPT(f=
ull)
> Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS 1.16.2-debian-1.=
16.2-1 04/01/2014
> Call Trace:
>  <TASK>
>  dump_stack_lvl+0xe8/0x150 lib/dump_stack.c:120
>  __might_resched+0x378/0x4d0 kernel/sched/core.c:9197
>  migrate_hugetlbs mm/migrate.c:1741 [inline]
>  migrate_pages+0x49b/0x27e0 mm/migrate.c:2196
>  do_mbind mm/mempolicy.c:1617 [inline]
>  kernel_mbind mm/mempolicy.c:1760 [inline]
>  __do_sys_mbind mm/mempolicy.c:1834 [inline]
>  __se_sys_mbind+0xe82/0x10e0 mm/mempolicy.c:1830
>  do_syscall_x64 arch/x86/entry/syscall_64.c:63 [inline]
>  do_syscall_64+0x174/0x580 arch/x86/entry/syscall_64.c:94
>  entry_SYSCALL_64_after_hwframe+0x77/0x7f
> RIP: 0033:0x7fc92ad9ce59
> Code: ff c3 66 2e 0f 1f 84 00 00 00 00 00 0f 1f 44 00 00 48 89 f8 48 89 f=
7 48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 ff=
 ff 73 01 c3 48 c7 c1 e8 ff ff ff f7 d8 64 89 01 48
> RSP: 002b:00007fc92bc65028 EFLAGS: 00000246 ORIG_RAX: 00000000000000ed
> RAX: ffffffffffffffda RBX: 00007fc92b015fa0 RCX: 00007fc92ad9ce59
> RDX: 0000000000000001 RSI: 0000000000600000 RDI: 0000200000000000
> RBP: 00007fc92ae32e6f R08: 0000000000000000 R09: 0000000000000003
> R10: 0000000000000000 R11: 0000000000000246 R12: 0000000000000000
> R13: 00007fc92b016038 R14: 00007fc92b015fa0 R15: 00007ffed35b2a68
>  </TASK>
>
> =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D
>
>
> ***
>
> BUG: sleeping function called from invalid context in migrate_pages_batch
>
> tree:      mm-new
> URL:       https://kernel.googlesource.com/pub/scm/linux/kernel/git/akpm/=
mm.git
> base:      61cccb8363fcc282d4ae0555b8739dd227f5ad0b
> arch:      amd64
> compiler:  Debian clang version 22.1.6 (++20260514074242+fc4aad7b5db3-1~e=
xp1~20260514074407.73), Debian LLD 22.1.6
> config:    https://ci.syzbot.org/builds/a27db994-58f5-48f4-a7f5-528b63f5a=
7c6/config
> syz repro: https://ci.syzbot.org/findings/1c235813-ad03-46d5-93c7-2702e35=
13739/syz_repro
>
> BUG: sleeping function called from invalid context at mm/migrate.c:1923
> in_atomic(): 1, irqs_disabled(): 0, non_block: 0, pid: 5820, name: syz.1.=
20
> preempt_count: 1, expected: 0
> RCU nest depth: 0, expected: 0
> 1 lock held by syz.1.20/5820:
>  #0: ffff88810903b618 (ptlock_ptr(ptdesc)){+.+.}-{3:3}, at: spin_lock inc=
lude/linux/spinlock.h:342 [inline]
>  #0: ffff88810903b618 (ptlock_ptr(ptdesc)){+.+.}-{3:3}, at: huge_pte_lock=
+0x17b/0x1e0 include/linux/hugetlb.h:1318
> Preemption disabled at:
> [<0000000000000000>] 0x0
> CPU: 1 UID: 0 PID: 5820 Comm: syz.1.20 Not tainted syzkaller #0 PREEMPT(f=
ull)
> Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS 1.16.2-debian-1.=
16.2-1 04/01/2014
> Call Trace:
>  <TASK>
>  dump_stack_lvl+0xe8/0x150 lib/dump_stack.c:120
>  __might_resched+0x378/0x4d0 kernel/sched/core.c:9197
>  migrate_pages_batch+0x5c5/0x5020 mm/migrate.c:1923
>  migrate_pages_sync mm/migrate.c:2115 [inline]
>  migrate_pages+0x1a8b/0x27e0 mm/migrate.c:2224
>  migrate_to_node mm/mempolicy.c:1322 [inline]
>  do_migrate_pages+0x656/0x8b0 mm/mempolicy.c:1421
>  kernel_migrate_pages mm/mempolicy.c:1935 [inline]
>  __do_sys_migrate_pages mm/mempolicy.c:1953 [inline]
>  __se_sys_migrate_pages+0xaa2/0xc90 mm/mempolicy.c:1949
>  do_syscall_x64 arch/x86/entry/syscall_64.c:63 [inline]
>  do_syscall_64+0x174/0x580 arch/x86/entry/syscall_64.c:94
>  entry_SYSCALL_64_after_hwframe+0x77/0x7f
> RIP: 0033:0x7f1175d9ce59
> Code: ff c3 66 2e 0f 1f 84 00 00 00 00 00 0f 1f 44 00 00 48 89 f8 48 89 f=
7 48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 ff=
 ff 73 01 c3 48 c7 c1 e8 ff ff ff f7 d8 64 89 01 48
> RSP: 002b:00007f1176c21028 EFLAGS: 00000246 ORIG_RAX: 0000000000000100
> RAX: ffffffffffffffda RBX: 00007f1176015fa0 RCX: 00007f1175d9ce59
> RDX: 0000200000000000 RSI: 0000000000000004 RDI: 0000000000000000
> RBP: 00007f1175e32e6f R08: 0000000000000000 R09: 0000000000000000
> R10: 0000200000000300 R11: 0000000000000246 R12: 0000000000000000
> R13: 00007f1176016038 R14: 00007f1176015fa0 R15: 00007ffd17a9f8a8
>  </TASK>
>
> =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D
>
>
> ***
>
> BUG: sleeping function called from invalid context in move_pages
>
> tree:      mm-new
> URL:       https://kernel.googlesource.com/pub/scm/linux/kernel/git/akpm/=
mm.git
> base:      61cccb8363fcc282d4ae0555b8739dd227f5ad0b
> arch:      amd64
> compiler:  Debian clang version 22.1.6 (++20260514074242+fc4aad7b5db3-1~e=
xp1~20260514074407.73), Debian LLD 22.1.6
> config:    https://ci.syzbot.org/builds/a27db994-58f5-48f4-a7f5-528b63f5a=
7c6/config
> syz repro: https://ci.syzbot.org/findings/5cf317a6-38fc-4f7b-aa15-e8cca68=
ee0f8/syz_repro
>
> BUG: sleeping function called from invalid context at mm/migrate.c:2320
> in_atomic(): 1, irqs_disabled(): 0, non_block: 0, pid: 5872, name: syz.0.=
21
> preempt_count: 1, expected: 0
> RCU nest depth: 0, expected: 0
> 1 lock held by syz.0.21/5872:
>  #0: ffff88810e2682b8 (ptlock_ptr(ptdesc)){+.+.}-{3:3}, at: spin_lock inc=
lude/linux/spinlock.h:342 [inline]
>  #0: ffff88810e2682b8 (ptlock_ptr(ptdesc)){+.+.}-{3:3}, at: huge_pte_lock=
+0x17b/0x1e0 include/linux/hugetlb.h:1318
> Preemption disabled at:
> [<0000000000000000>] 0x0
> CPU: 0 UID: 0 PID: 5872 Comm: syz.0.21 Not tainted syzkaller #0 PREEMPT(f=
ull)
> Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS 1.16.2-debian-1.=
16.2-1 04/01/2014
> Call Trace:
>  <TASK>
>  dump_stack_lvl+0xe8/0x150 lib/dump_stack.c:120
>  __might_resched+0x378/0x4d0 kernel/sched/core.c:9197
>  __might_fault+0x76/0x130 mm/memory.c:7425
>  store_status mm/migrate.c:2320 [inline]
>  move_pages_and_store_status mm/migrate.c:2431 [inline]
>  do_pages_move mm/migrate.c:2525 [inline]
>  kernel_move_pages mm/migrate.c:2704 [inline]
>  __do_sys_move_pages mm/migrate.c:2718 [inline]
>  __se_sys_move_pages+0x1b5d/0x1c80 mm/migrate.c:2713
>  do_syscall_x64 arch/x86/entry/syscall_64.c:63 [inline]
>  do_syscall_64+0x174/0x580 arch/x86/entry/syscall_64.c:94
>  entry_SYSCALL_64_after_hwframe+0x77/0x7f
> RIP: 0033:0x7f364019ce59
> Code: ff c3 66 2e 0f 1f 84 00 00 00 00 00 0f 1f 44 00 00 48 89 f8 48 89 f=
7 48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 ff=
 ff 73 01 c3 48 c7 c1 e8 ff ff ff f7 d8 64 89 01 48
> RSP: 002b:00007f3640f79028 EFLAGS: 00000246 ORIG_RAX: 0000000000000117
> RAX: ffffffffffffffda RBX: 00007f3640415fa0 RCX: 00007f364019ce59
> RDX: 00002000000003c0 RSI: 0000000000000002 RDI: 0000000000000000
> RBP: 00007f3640232e6f R08: 0000000000000000 R09: 0000000000000000
> R10: 0000200000000000 R11: 0000000000000246 R12: 0000000000000000
> R13: 00007f3640416038 R14: 00007f3640415fa0 R15: 00007fff4d7049e8
>  </TASK>
>
> =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D
> [ BUG: Invalid wait context ]
> syzkaller #0 Tainted: G        W
> -----------------------------
> syz.0.21/5872 is trying to lock:
> ffff88816dd71078 (&mm->mmap_lock){++++}-{4:4}, at: __might_fault+0xaf/0x1=
30 mm/memory.c:7427
> other info that might help us debug this:
> context-{5:5}
> 1 lock held by syz.0.21/5872:
>  #0: ffff88810e2682b8 (ptlock_ptr(ptdesc)){+.+.}-{3:3}, at: spin_lock inc=
lude/linux/spinlock.h:342 [inline]
>  #0: ffff88810e2682b8 (ptlock_ptr(ptdesc)){+.+.}-{3:3}, at: huge_pte_lock=
+0x17b/0x1e0 include/linux/hugetlb.h:1318
> stack backtrace:
> CPU: 0 UID: 0 PID: 5872 Comm: syz.0.21 Tainted: G        W           syzk=
aller #0 PREEMPT(full)
> Tainted: [W]=3DWARN
> Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS 1.16.2-debian-1.=
16.2-1 04/01/2014
> Call Trace:
>  <TASK>
>  dump_stack_lvl+0xe8/0x150 lib/dump_stack.c:120
>  print_lock_invalid_wait_context kernel/locking/lockdep.c:4830 [inline]
>  check_wait_context kernel/locking/lockdep.c:4902 [inline]
>  __lock_acquire+0xef0/0x2e50 kernel/locking/lockdep.c:5188
>  lock_acquire+0x115/0x350 kernel/locking/lockdep.c:5890
>  __might_fault+0xcb/0x130 mm/memory.c:7427
>  store_status mm/migrate.c:2320 [inline]
>  move_pages_and_store_status mm/migrate.c:2431 [inline]
>  do_pages_move mm/migrate.c:2525 [inline]
>  kernel_move_pages mm/migrate.c:2704 [inline]
>  __do_sys_move_pages mm/migrate.c:2718 [inline]
>  __se_sys_move_pages+0x1b5d/0x1c80 mm/migrate.c:2713
>  do_syscall_x64 arch/x86/entry/syscall_64.c:63 [inline]
>  do_syscall_64+0x174/0x580 arch/x86/entry/syscall_64.c:94
>  entry_SYSCALL_64_after_hwframe+0x77/0x7f
> RIP: 0033:0x7f364019ce59
> Code: ff c3 66 2e 0f 1f 84 00 00 00 00 00 0f 1f 44 00 00 48 89 f8 48 89 f=
7 48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 ff=
 ff 73 01 c3 48 c7 c1 e8 ff ff ff f7 d8 64 89 01 48
> RSP: 002b:00007f3640f79028 EFLAGS: 00000246 ORIG_RAX: 0000000000000117
> RAX: ffffffffffffffda RBX: 00007f3640415fa0 RCX: 00007f364019ce59
> RDX: 00002000000003c0 RSI: 0000000000000002 RDI: 0000000000000000
> RBP: 00007f3640232e6f R08: 0000000000000000 R09: 0000000000000000
> R10: 0000200000000000 R11: 0000000000000246 R12: 0000000000000000
> R13: 00007f3640416038 R14: 00007f3640415fa0 R15: 00007fff4d7049e8
>  </TASK>
> BUG: scheduling while atomic: syz.0.21/5872/0x00000002
> INFO: lockdep is turned off.
> Modules linked in:
> Preemption disabled at:
> [<0000000000000000>] 0x0
>
>
> ***
>
> BUG: sleeping function called from invalid context in store_status
>
> tree:      mm-new
> URL:       https://kernel.googlesource.com/pub/scm/linux/kernel/git/akpm/=
mm.git
> base:      61cccb8363fcc282d4ae0555b8739dd227f5ad0b
> arch:      amd64
> compiler:  Debian clang version 22.1.6 (++20260514074242+fc4aad7b5db3-1~e=
xp1~20260514074407.73), Debian LLD 22.1.6
> config:    https://ci.syzbot.org/builds/a27db994-58f5-48f4-a7f5-528b63f5a=
7c6/config
> syz repro: https://ci.syzbot.org/findings/bd9708eb-bf3f-4bb4-acb1-82ff8e5=
bb3c2/syz_repro
>
> BUG: sleeping function called from invalid context at mm/migrate.c:2320
> in_atomic(): 1, irqs_disabled(): 0, non_block: 0, pid: 5813, name: syz.1.=
18
> preempt_count: 1, expected: 0
> RCU nest depth: 0, expected: 0
> 1 lock held by syz.1.18/5813:
>  #0: ffff888176f9ac78 (ptlock_ptr(ptdesc)){+.+.}-{3:3}, at: spin_lock inc=
lude/linux/spinlock.h:342 [inline]
>  #0: ffff888176f9ac78 (ptlock_ptr(ptdesc)){+.+.}-{3:3}, at: huge_pte_lock=
+0x17b/0x1e0 include/linux/hugetlb.h:1318
> Preemption disabled at:
> [<0000000000000000>] 0x0
> CPU: 1 UID: 0 PID: 5813 Comm: syz.1.18 Not tainted syzkaller #0 PREEMPT(f=
ull)
> Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS 1.16.2-debian-1.=
16.2-1 04/01/2014
> Call Trace:
>  <TASK>
>  dump_stack_lvl+0xe8/0x150 lib/dump_stack.c:120
>  __might_resched+0x378/0x4d0 kernel/sched/core.c:9197
>  __might_fault+0x76/0x130 mm/memory.c:7425
>  store_status+0x40/0xb0 mm/migrate.c:2320
>  move_pages_and_store_status mm/migrate.c:2431 [inline]
>  do_pages_move mm/migrate.c:2513 [inline]
>  kernel_move_pages mm/migrate.c:2704 [inline]
>  __do_sys_move_pages mm/migrate.c:2718 [inline]
>  __se_sys_move_pages+0x10e4/0x1c80 mm/migrate.c:2713
>  do_syscall_x64 arch/x86/entry/syscall_64.c:63 [inline]
>  do_syscall_64+0x174/0x580 arch/x86/entry/syscall_64.c:94
>  entry_SYSCALL_64_after_hwframe+0x77/0x7f
> RIP: 0033:0x7fb06159ce59
> Code: ff c3 66 2e 0f 1f 84 00 00 00 00 00 0f 1f 44 00 00 48 89 f8 48 89 f=
7 48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 ff=
 ff 73 01 c3 48 c7 c1 e8 ff ff ff f7 d8 64 89 01 48
> RSP: 002b:00007fb062390028 EFLAGS: 00000246 ORIG_RAX: 0000000000000117
> RAX: ffffffffffffffda RBX: 00007fb061815fa0 RCX: 00007fb06159ce59
> RDX: 00002000000017c0 RSI: 0000000000000003 RDI: 0000000000000000
> RBP: 00007fb061632e6f R08: 0000200000001840 R09: 0000000000000002
> R10: 0000200000001800 R11: 0000000000000246 R12: 0000000000000000
> R13: 00007fb061816038 R14: 00007fb061815fa0 R15: 00007ffcb4b262e8
>  </TASK>
>
> =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D
> [ BUG: Invalid wait context ]
> syzkaller #0 Tainted: G        W
> -----------------------------
> syz.1.18/5813 is trying to lock:
> ffff88817695d038 (&mm->mmap_lock){++++}-{4:4}, at: __might_fault+0xaf/0x1=
30 mm/memory.c:7427
> other info that might help us debug this:
> context-{5:5}
> 1 lock held by syz.1.18/5813:
>  #0: ffff888176f9ac78 (ptlock_ptr(ptdesc)){+.+.}-{3:3}, at: spin_lock inc=
lude/linux/spinlock.h:342 [inline]
>  #0: ffff888176f9ac78 (ptlock_ptr(ptdesc)){+.+.}-{3:3}, at: huge_pte_lock=
+0x17b/0x1e0 include/linux/hugetlb.h:1318
> stack backtrace:
> CPU: 1 UID: 0 PID: 5813 Comm: syz.1.18 Tainted: G        W           syzk=
aller #0 PREEMPT(full)
> Tainted: [W]=3DWARN
> Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS 1.16.2-debian-1.=
16.2-1 04/01/2014
> Call Trace:
>  <TASK>
>  dump_stack_lvl+0xe8/0x150 lib/dump_stack.c:120
>  print_lock_invalid_wait_context kernel/locking/lockdep.c:4830 [inline]
>  check_wait_context kernel/locking/lockdep.c:4902 [inline]
>  __lock_acquire+0xef0/0x2e50 kernel/locking/lockdep.c:5188
>  lock_acquire+0x115/0x350 kernel/locking/lockdep.c:5890
>  __might_fault+0xcb/0x130 mm/memory.c:7427
>  store_status+0x40/0xb0 mm/migrate.c:2320
>  move_pages_and_store_status mm/migrate.c:2431 [inline]
>  do_pages_move mm/migrate.c:2513 [inline]
>  kernel_move_pages mm/migrate.c:2704 [inline]
>  __do_sys_move_pages mm/migrate.c:2718 [inline]
>  __se_sys_move_pages+0x10e4/0x1c80 mm/migrate.c:2713
>  do_syscall_x64 arch/x86/entry/syscall_64.c:63 [inline]
>  do_syscall_64+0x174/0x580 arch/x86/entry/syscall_64.c:94
>  entry_SYSCALL_64_after_hwframe+0x77/0x7f
> RIP: 0033:0x7fb06159ce59
> Code: ff c3 66 2e 0f 1f 84 00 00 00 00 00 0f 1f 44 00 00 48 89 f8 48 89 f=
7 48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 ff=
 ff 73 01 c3 48 c7 c1 e8 ff ff ff f7 d8 64 89 01 48
> RSP: 002b:00007fb062390028 EFLAGS: 00000246 ORIG_RAX: 0000000000000117
> RAX: ffffffffffffffda RBX: 00007fb061815fa0 RCX: 00007fb06159ce59
> RDX: 00002000000017c0 RSI: 0000000000000003 RDI: 0000000000000000
> RBP: 00007fb061632e6f R08: 0000200000001840 R09: 0000000000000002
> R10: 0000200000001800 R11: 0000000000000246 R12: 0000000000000000
> R13: 00007fb061816038 R14: 00007fb061815fa0 R15: 00007ffcb4b262e8
>  </TASK>
> BUG: scheduling while atomic: syz.1.18/5813/0x00000002
> INFO: lockdep is turned off.
> Modules linked in:
> Preemption disabled at:
> [<0000000000000000>] 0x0
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
> [akpm@linux-foundation.org apopple@nvidia.com bharata@amd.com byungchul@s=
k.com david@kernel.org dev.jain@arm.com fvdl@google.com gourry@gourry.net h=
arry@kernel.org jannh@google.com joshua.hahnjy@gmail.com kinseyho@google.co=
m kmanaouil.dev@gmail.com lance.yang@linux.dev liam@infradead.org linux-ker=
nel@vger.kernel.org linux-mm@kvack.org ljs@kernel.org matthew.brost@intel.c=
om mhocko@suse.com rakie.kim@sk.com riel@surriel.com rientjes@google.com rp=
pt@kernel.org shivankg@amd.com surenb@google.com vbabka@kernel.org weixugc@=
google.com ying.huang@linux.alibaba.com ziy@nvidia.com]
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
-upstream-moderation/6a53d511.278cdcd2.e885.001e.GAE%40google.com.



--=20
=E2=B2=A0=E2=B2=9F=E2=B2=93=E2=B2=99=E2=B2=8F=E2=B2=9B =E2=B2=84=E2=B2=89=
=E2=B2=B1=E2=B2=A3=E2=B2=85=E2=B2=93=E2=B2=9F=E2=B2=A5 - Pimyn Girgis
Software Engineer
Kernel Dynamic Analysis
pimyn@google.com
