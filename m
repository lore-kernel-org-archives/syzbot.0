Received: from mail-oa1-f43.google.com (mail-oa1-f43.google.com [209.85.160.43])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F092B3CF692
	for <syzbot@lists.linux.dev>; Mon, 18 May 2026 07:27:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.160.43
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779089272; cv=pass; b=QQ6KJQVWYrNpOi+FZx1cwVSdhcn6p3UnSgc2lBzuVE6AXnkZjygEGl5DJVeKY04J5SQmu0g6M/gt6quKFO5j1nm5D1honpCyPnuK+oY75vSUO3tc1Eg7FlOP7RXuLwYkt7mMel4JW8nczjvnVJK6X5ivMJXyaSPs9J/46VrhZZg=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779089272; c=relaxed/simple;
	bh=4rffuRV4rGjNzSfdRmVpTAW5v0IzUMETfq65nKct18k=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=EV6eWu5GmaoGtLvppNxAa+uzQdKcOi2VxEsBoQMsyFBLiVo+XNa2pdZb5gug5c/Dj1GZ6+qJEGVu5GrXaXSddyCVrmBO6Wg7+Y0DYHdaWnhDIe5QOR+fUlkY6qUy365LatCnpkg01ry+m0Adwu+srze91XNoXPMNNtPTFtf3PvA=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=MUrwuHT9; arc=pass smtp.client-ip=209.85.160.43
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="MUrwuHT9"
Received: by mail-oa1-f43.google.com with SMTP id 586e51a60fabf-41576c5c01cso1400678fac.3
        for <syzbot@lists.linux.dev>; Mon, 18 May 2026 00:27:50 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1779089270; cv=none;
        d=google.com; s=arc-20240605;
        b=Eucu1hST8Nr/56JzpfoMB7BiYEXX95H1WNUDuNrWeY3N1X2jmQ/9JVKzK7z0Ah5FDS
         7w33yyAvhhscC7TkRwnAs3fCX8p/LKV8MQudSAV75kUjBKflMep2sMbHUKYZciDIR0S3
         fzSHe/UOSDU3B2s7OqlNV3rqNMq62thOOHGOyU8Crcq8thLC0zILReUzhnyKBnOQ51W3
         fz/PFqUWbgXTiF5ToUo3QDTnLCXm8eFAMohTOkRAWc3tTa5uGnMy8LxN/Tbju76aYhF5
         chmW+vVdbOG6Q7wCZEEpziDOCw7rK+iLO6G92f+3KzxOkwZxV0hc7fUtFsNA0yt9HvXn
         NNNQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=iaHNgdAG4ule/tr0L5H2KVLzZ6ptZZSYSxJJKYHoINY=;
        fh=MX5IFFzO5fNV1l9xtV8a2EIcMewAhFSY6MdkSq+Ky40=;
        b=Wxf0p/5Q3De8GS70WBzNuFW2TtIiaruZmhShM2Td9bGL3A3hJCG7Kzh0pMBgH0i7/J
         Z77GcQeC76KBkC13fgnVnv99+ZAUqu6Y8uLM6xWOedRN+743vlBFfMUmCDqk4rjSN1me
         Jeb2Xz5NIXnRvukJ7XRkjwwNSOd/tl90DiOURd+2vqv1wtjTAb9YAfN+ndKsik2GCMzu
         bxj6QKJE3gnO8QIKYXT5GuJlxuHoQJ/oUaxbt88fYrbRtFWlhL8mp1PWN2Jqs3/IyhLq
         fRLvamOVuqGng1v3emcO382FXIYU1mHRJOPBJz5V9FSNEpaPKfkB8qX1SScwmwZJJ3L6
         n1rQ==;
        darn=lists.linux.dev
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1779089270; x=1779694070; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=iaHNgdAG4ule/tr0L5H2KVLzZ6ptZZSYSxJJKYHoINY=;
        b=MUrwuHT97sm1btf6Zkyh7wCdROPoWSRv6LgDuiymyeDlwxRrowxKrMalGcJeT+GLRu
         JiA+Uuh3uYng5LKy+3dOb7ZSza3G7SGSJeyQp/7c0y7r7NYluaBPXh2RA89h7R7bVl7n
         4sQ/TmVIlkLZJP3Y8AhxVIz5t1Vu6/8EkG+wJ9mnX89Uwn0B+GVXeOBuwm17EjziSZsr
         x1EGHpshtKe6bjm0lt1kuAT5ckp++TYATlBREmVOdvBJqfbKZKoqcEPwbNThRKWEpX5C
         EGim7FBXrPhbosb+GHD1ifMOI5QyfPY5qsPJZe4Ki8mG9dLVXedUy+te7YskSDrfApKZ
         1hOw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1779089270; x=1779694070;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=iaHNgdAG4ule/tr0L5H2KVLzZ6ptZZSYSxJJKYHoINY=;
        b=JZOwLqGec01303dORJxKCqQPQZuwaBQoFaeRiztwZ6ovi3wVcFB3V7wSF+BLuuKOcI
         MxEWU5K4r6hyGBdxxqMReseYJZklS2uKghU9+VHAIoBNsoz0KYF4AxXLjL5fQSxG+SGi
         yM+jFPdQLCrC3lLT0SfmNc6lWbC8mNeks9dQJcSUDYzA+Yz+bu8CqIzRXMbWwmTBiWQA
         JQmK8WIXs4c8jutZyLUiMf4tMnM7EzoiJio0fpqgxdR4NQ8GCIl4VakqKRwUIBv0Ghj1
         Q+cEYNwUTEFPfQXuxlwgOEIaXH3hqGiyXl8LDj/KiMp86N117NQHeh9qzuz+jUPZf1eW
         rMZw==
X-Forwarded-Encrypted: i=1; AFNElJ93wCVOPtyvKB22SlLPEfj9/AxJBMKreSYt5E/kwiHkZ4w13CPJZNUT/HyEi9Lp+DxZVrAZDSU=@lists.linux.dev
X-Gm-Message-State: AOJu0YwzJ8gLJvS4h5haOz25Ltp5GP3w8Ddf1kO54SPl1FA79xp+4ywR
	IyMxloPsB3azCj6A8Y1Jfz4jaUmRJ/XVurL0xQwbaeFDf10WslviivnLYKXY0DYFxVkrVjGD9R2
	MXTEnX5HhtCvb+NvjSoNkvCWrqCOFbDyCUc7Hlaj8
X-Gm-Gg: Acq92OFMiQt7GPMhYNqH3e7MiW4h4S8QduWDoqVJ1chQXVdzgs4HKaA7WZ2AG/Stxid
	a5Bm6qTO9D9rApPeH7DLhmtfv/lOS01LDwiVW+UmJplVN2bZ5K35RPhV0rYXAmntsz/+Je5b8D5
	LqpJdSM51eyAzZT17THdDxjr23rkvkxZN00Z5pThTuj9TKHXIkQ50knCFVHK53/ot3vF0zkWAFx
	na6+ewPYknDDP2v7BmjXUMO29ClKCKzA6LFTmAyxf1THAMQT4E1kDNtvsBOJkNueUAe0Qm8r1if
	odAQ3UOioQD+twz66x3B4PKwrHf9JRASrffx7OMzV6NVTNBLRqdjpVV6kRZIVdXYFQ8x/2jon6E
	/wuqw
X-Received: by 2002:a05:6870:160b:b0:422:f606:1420 with SMTP id
 586e51a60fabf-43a2ddde34amr9695044fac.34.1779089269314; Mon, 18 May 2026
 00:27:49 -0700 (PDT)
Precedence: bulk
X-Mailing-List: syzbot@lists.linux.dev
List-Id: <syzbot.lists.linux.dev>
List-Subscribe: <mailto:syzbot+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:syzbot+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <6a0a301d.050a0220.f80e4.000c.GAE@google.com>
In-Reply-To: <6a0a301d.050a0220.f80e4.000c.GAE@google.com>
From: Aleksandr Nogikh <nogikh@google.com>
Date: Mon, 18 May 2026 09:27:37 +0200
X-Gm-Features: AVHnY4LwvbbNW8bgRjfjJK7IYDMhCLNO6ZQ-tkp5fbLvLAFh2Qd4wo7wcjVDrCA
Message-ID: <CANp29Y6Dff8vBNHTvkg0L4rtGCOMj1QPXeY67VGqh0sn86o0mw@mail.gmail.com>
Subject: Re: [moderation/CI] Re: vfs: add O_CREAT|O_DIRECTORY to open*(2)
To: syzbot ci <syzbot+ci965f32f28e164dd5@syzkaller.appspotmail.com>
Cc: syzkaller-upstream-moderation@googlegroups.com, syzbot@lists.linux.dev
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

#syz upstream


On Sun, May 17, 2026 at 11:16=E2=80=AFPM syzbot ci
<syzbot+ci965f32f28e164dd5@syzkaller.appspotmail.com> wrote:
>
> syzbot ci has tested the following series
>
> [v3] vfs: add O_CREAT|O_DIRECTORY to open*(2)
> https://lore.kernel.org/all/20260517170244.1832119-1-jkoolstra@xs4all.nl
> * [RFC PATCH v3 1/2] vfs: add O_CREAT|O_DIRECTORY to open*(2)
> * [RFC PATCH v3 2/2] selftest: add tests for open*(O_CREAT|O_DIRECTORY)
>
> and found the following issues:
> * WARNING: lock held when returning to user space in filename_create
> * WARNING: lock held when returning to user space in start_creating
> * possible deadlock in mnt_want_write
>
> Full report is available here:
> https://ci.syzbot.org/series/6c2681e8-f8f3-4287-8f97-bd6ea26a767f
>
> ***
>
> WARNING: lock held when returning to user space in filename_create
>
> tree:      torvalds
> URL:       https://kernel.googlesource.com/pub/scm/linux/kernel/git/torva=
lds/linux
> base:      6916d5703ddf9a38f1f6c2cc793381a24ee914c6
> arch:      amd64
> compiler:  Debian clang version 21.1.8 (++20251221033036+2078da43e25a-1~e=
xp1~20251221153213.50), Debian LLD 21.1.8
> config:    https://ci.syzbot.org/builds/7a0474b8-fd0f-4804-8833-2232742e0=
6e3/config
> syz repro: https://ci.syzbot.org/findings/512f2832-177b-4b65-b835-bdff3e4=
402bc/syz_repro
>
> hpfs: hpfs_map_4sectors(): unaligned read
> hpfs: hpfs_map_4sectors(): unaligned read
> hpfs: filesystem error: unable to find root dir
> =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
> WARNING: lock held when returning to user space!
> syzkaller #0 Not tainted
> ------------------------------------------------
> syz.0.17/5814 is leaving the kernel with locks still held!
> 1 lock held by syz.0.17/5814:
>  #0: ffff8881bab5b878 (&type->i_mutex_dir_key#8/1){+.+.}-{4:4}, at: inode=
_lock_nested include/linux/fs.h:1074 [inline]
>  #0: ffff8881bab5b878 (&type->i_mutex_dir_key#8/1){+.+.}-{4:4}, at: __sta=
rt_dirop fs/namei.c:2919 [inline]
>  #0: ffff8881bab5b878 (&type->i_mutex_dir_key#8/1){+.+.}-{4:4}, at: start=
_dirop fs/namei.c:2943 [inline]
>  #0: ffff8881bab5b878 (&type->i_mutex_dir_key#8/1){+.+.}-{4:4}, at: filen=
ame_create+0x200/0x370 fs/namei.c:4984
>
>
> ***
>
> WARNING: lock held when returning to user space in start_creating
>
> tree:      torvalds
> URL:       https://kernel.googlesource.com/pub/scm/linux/kernel/git/torva=
lds/linux
> base:      6916d5703ddf9a38f1f6c2cc793381a24ee914c6
> arch:      amd64
> compiler:  Debian clang version 21.1.8 (++20251221033036+2078da43e25a-1~e=
xp1~20251221153213.50), Debian LLD 21.1.8
> config:    https://ci.syzbot.org/builds/7a0474b8-fd0f-4804-8833-2232742e0=
6e3/config
> syz repro: https://ci.syzbot.org/findings/7bdf5f73-8cce-4785-aa9e-dd89622=
cf613/syz_repro
>
> overlayfs: failed to create directory ./bus/work (errno: 126); mounting r=
ead-only
> =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
> WARNING: lock held when returning to user space!
> syzkaller #0 Not tainted
> ------------------------------------------------
> syz.1.18/5833 is leaving the kernel with locks still held!
> 1 lock held by syz.1.18/5833:
>  #0: ffff8881ba0c4518 (&type->i_mutex_dir_key#3/1){+.+.}-{4:4}, at: inode=
_lock_nested include/linux/fs.h:1074 [inline]
>  #0: ffff8881ba0c4518 (&type->i_mutex_dir_key#3/1){+.+.}-{4:4}, at: __sta=
rt_dirop fs/namei.c:2919 [inline]
>  #0: ffff8881ba0c4518 (&type->i_mutex_dir_key#3/1){+.+.}-{4:4}, at: start=
_dirop fs/namei.c:2943 [inline]
>  #0: ffff8881ba0c4518 (&type->i_mutex_dir_key#3/1){+.+.}-{4:4}, at: start=
_creating+0xbe/0x100 fs/namei.c:3412
>
>
> ***
>
> possible deadlock in mnt_want_write
>
> tree:      torvalds
> URL:       https://kernel.googlesource.com/pub/scm/linux/kernel/git/torva=
lds/linux
> base:      6916d5703ddf9a38f1f6c2cc793381a24ee914c6
> arch:      amd64
> compiler:  Debian clang version 21.1.8 (++20251221033036+2078da43e25a-1~e=
xp1~20251221153213.50), Debian LLD 21.1.8
> config:    https://ci.syzbot.org/builds/7a0474b8-fd0f-4804-8833-2232742e0=
6e3/config
> syz repro: https://ci.syzbot.org/findings/6d4f386f-fb66-4862-b644-4ac19c7=
9f6a3/syz_repro
>
> =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D
> WARNING: possible circular locking dependency detected
> syzkaller #0 Not tainted
> ------------------------------------------------------
> syz.0.17/5836 is trying to acquire lock:
> ffff888118cba410
>  (sb_writers#12){.+.+}-{0:0}, at: mnt_want_write+0x41/0x90 fs/namespace.c=
:493
>
> but task is already holding lock:
> ffff88811f1627e0 (&ovl_i_mutex_dir_key[depth]/1){+.+.}-{4:4}, at: inode_l=
ock_nested include/linux/fs.h:1074 [inline]
> ffff88811f1627e0 (&ovl_i_mutex_dir_key[depth]/1){+.+.}-{4:4}, at: __start=
_dirop fs/namei.c:2919 [inline]
> ffff88811f1627e0 (&ovl_i_mutex_dir_key[depth]/1){+.+.}-{4:4}, at: start_d=
irop fs/namei.c:2943 [inline]
> ffff88811f1627e0 (&ovl_i_mutex_dir_key[depth]/1){+.+.}-{4:4}, at: filenam=
e_create+0x200/0x370 fs/namei.c:4984
>
> which lock already depends on the new lock.
>
>
> the existing dependency chain (in reverse order) is:
>
> -> #1 (&ovl_i_mutex_dir_key[depth]/1){+.+.}-{4:4}:
>        down_write_nested+0x9d/0x210 kernel/locking/rwsem.c:1751
>        inode_lock_nested include/linux/fs.h:1074 [inline]
>        __start_dirop fs/namei.c:2919 [inline]
>        start_dirop fs/namei.c:2943 [inline]
>        filename_unlinkat+0x2a7/0x610 fs/namei.c:5599
>        __do_sys_unlink fs/namei.c:5653 [inline]
>        __se_sys_unlink+0x2e/0x140 fs/namei.c:5650
>        do_syscall_x64 arch/x86/entry/syscall_64.c:63 [inline]
>        do_syscall_64+0x15f/0xf80 arch/x86/entry/syscall_64.c:94
>        entry_SYSCALL_64_after_hwframe+0x77/0x7f
>
> -> #0 (sb_writers#12){.+.+}-{0:0}:
>        check_prev_add kernel/locking/lockdep.c:3165 [inline]
>        check_prevs_add kernel/locking/lockdep.c:3284 [inline]
>        validate_chain kernel/locking/lockdep.c:3908 [inline]
>        __lock_acquire+0x15a5/0x2cf0 kernel/locking/lockdep.c:5237
>        lock_acquire+0x106/0x350 kernel/locking/lockdep.c:5868
>        percpu_down_read_internal include/linux/percpu-rwsem.h:53 [inline]
>        percpu_down_read_freezable include/linux/percpu-rwsem.h:83 [inline=
]
>        __sb_start_write include/linux/fs/super.h:19 [inline]
>        sb_start_write+0x4d/0x1c0 include/linux/fs/super.h:125
>        mnt_want_write+0x41/0x90 fs/namespace.c:493
>        filename_create+0x154/0x370 fs/namei.c:4977
>        filename_mkdirat+0xd2/0x510 fs/namei.c:5337
>        __do_sys_mkdirat fs/namei.c:5365 [inline]
>        __se_sys_mkdirat+0x35/0x150 fs/namei.c:5362
>        do_syscall_x64 arch/x86/entry/syscall_64.c:63 [inline]
>        do_syscall_64+0x15f/0xf80 arch/x86/entry/syscall_64.c:94
>        entry_SYSCALL_64_after_hwframe+0x77/0x7f
>
> other info that might help us debug this:
>
>  Possible unsafe locking scenario:
>
>        CPU0                    CPU1
>        ----                    ----
>   lock(&ovl_i_mutex_dir_key[depth]/1);
>                                lock(sb_writers#12);
>                                lock(&ovl_i_mutex_dir_key[depth]/1);
>   rlock(sb_writers#12);
>
>  *** DEADLOCK ***
>
> 1 lock held by syz.0.17/5836:
>  #0: ffff88811f1627e0 (&ovl_i_mutex_dir_key[depth]/1){+.+.}-{4:4}, at: in=
ode_lock_nested include/linux/fs.h:1074 [inline]
>  #0: ffff88811f1627e0 (&ovl_i_mutex_dir_key[depth]/1){+.+.}-{4:4}, at: __=
start_dirop fs/namei.c:2919 [inline]
>  #0: ffff88811f1627e0 (&ovl_i_mutex_dir_key[depth]/1){+.+.}-{4:4}, at: st=
art_dirop fs/namei.c:2943 [inline]
>  #0: ffff88811f1627e0 (&ovl_i_mutex_dir_key[depth]/1){+.+.}-{4:4}, at: fi=
lename_create+0x200/0x370 fs/namei.c:4984
>
> stack backtrace:
> CPU: 0 UID: 0 PID: 5836 Comm: syz.0.17 Not tainted syzkaller #0 PREEMPT(f=
ull)
> Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS 1.16.2-debian-1.=
16.2-1 04/01/2014
> Call Trace:
>  <TASK>
>  dump_stack_lvl+0xe8/0x150 lib/dump_stack.c:120
>  print_circular_bug+0x2e1/0x300 kernel/locking/lockdep.c:2043
>  check_noncircular+0x12e/0x150 kernel/locking/lockdep.c:2175
>  check_prev_add kernel/locking/lockdep.c:3165 [inline]
>  check_prevs_add kernel/locking/lockdep.c:3284 [inline]
>  validate_chain kernel/locking/lockdep.c:3908 [inline]
>  __lock_acquire+0x15a5/0x2cf0 kernel/locking/lockdep.c:5237
>  lock_acquire+0x106/0x350 kernel/locking/lockdep.c:5868
>  percpu_down_read_internal include/linux/percpu-rwsem.h:53 [inline]
>  percpu_down_read_freezable include/linux/percpu-rwsem.h:83 [inline]
>  __sb_start_write include/linux/fs/super.h:19 [inline]
>  sb_start_write+0x4d/0x1c0 include/linux/fs/super.h:125
>  mnt_want_write+0x41/0x90 fs/namespace.c:493
>  filename_create+0x154/0x370 fs/namei.c:4977
>  filename_mkdirat+0xd2/0x510 fs/namei.c:5337
>  __do_sys_mkdirat fs/namei.c:5365 [inline]
>  __se_sys_mkdirat+0x35/0x150 fs/namei.c:5362
>  do_syscall_x64 arch/x86/entry/syscall_64.c:63 [inline]
>  do_syscall_64+0x15f/0xf80 arch/x86/entry/syscall_64.c:94
>  entry_SYSCALL_64_after_hwframe+0x77/0x7f
> RIP: 0033:0x7f2f5e99ce59
> Code: ff c3 66 2e 0f 1f 84 00 00 00 00 00 0f 1f 44 00 00 48 89 f8 48 89 f=
7 48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 ff=
 ff 73 01 c3 48 c7 c1 e8 ff ff ff f7 d8 64 89 01 48
> RSP: 002b:00007f2f5f771028 EFLAGS: 00000246 ORIG_RAX: 0000000000000102
> RAX: ffffffffffffffda RBX: 00007f2f5ec15fa0 RCX: 00007f2f5e99ce59
> RDX: 0000000000000010 RSI: 0000200000002040 RDI: ffffffffffffff9c
> RBP: 00007f2f5ea32d6f R08: 0000000000000000 R09: 0000000000000000
> R10: 0000000000000000 R11: 0000000000000246 R12: 0000000000000000
> R13: 00007f2f5ec16038 R14: 00007f2f5ec15fa0 R15: 00007ffe96c961d8
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
> To test a patch for this bug, please reply with `#syz test`
> (should be on a separate line).
>
> The patch should be attached to the email.
> Note: arguments like custom git repos and branches are not supported.
>
> The email will later be sent to:
> [brauner@kernel.org cmirabil@redhat.com cyphar@cyphar.com jack@suse.cz jk=
oolstra@xs4all.nl linux-fsdevel@vger.kernel.org linux-kernel@vger.kernel.or=
g viro@zeniv.linux.org.uk]
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
-upstream-moderation/6a0a301d.050a0220.f80e4.000c.GAE%40google.com.
