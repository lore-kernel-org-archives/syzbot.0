Received: from mail-pl1-f176.google.com (mail-pl1-f176.google.com [209.85.214.176])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C9A7120B80D
	for <syzbot@lists.linux.dev>; Sun, 17 Aug 2025 08:32:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.176
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755419537; cv=none; b=bC+otFkpF29EKID6tcN3Ti1LkLtXRWxj1LFhrmc8Nrdskq4MZ7v+98z7nVnhQKexzmiDJnB7BNqSY9WRyQPaxbEY374w6YcU50VwzFtJNnb2aN+2DZzY+O2ijpjR1ARGJJIPNUn4eLJHesVzc1xb9VbzdFr96Ld7tscTKfPMYfs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755419537; c=relaxed/simple;
	bh=Nivnggrfa747pD+kSMqjA8MnnIu8OeL7wccF8DXP8Sg=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=XCehOEUUU2q7Hq6PGU3jz7NcoR4WXpzkxEGstsYN+xQw3r+iU8hMcwoZ7Kc+G57c0rXWDfbfwi3j88ek1uDS+g/la9wZ3azcK4+EZTXQ62e3+N+nFW5EQkNT1cTh4Z/tajZAzt8A2ddSU7Vw0gi7/+embET7pn/2fv+kh19G6gQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=eJEZB6Nk; arc=none smtp.client-ip=209.85.214.176
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="eJEZB6Nk"
Received: by mail-pl1-f176.google.com with SMTP id d9443c01a7336-244580591b0so22166815ad.1
        for <syzbot@lists.linux.dev>; Sun, 17 Aug 2025 01:32:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1755419535; x=1756024335; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=YweHAm+41ud1dq4XVNswisNc+6gVbF14361cvsGjxvk=;
        b=eJEZB6NkUJJ6Q/pQ2ejUVgHwYb55TI1/vt+ohs4+qATLZ8RkacST5KGpbpd+L62Q1I
         0c4NgQpTedDcI2jcXZs+4od56kBkUIowkFpCveVgxdk09b3u+nc+cUErWsKRW8+ZXGGp
         o5a9L92BBDqaM3D6Vw9B4B9hwfYp4PttJPdoMyaJk7FRmbmJT8HHZ99LZVaGJMS26NyG
         mbptbfk2hCAvYEi3ZGoAQDiDDyfFrAT3DzPEg1zW0xzYZosyLc66nbQgGv6bHeLyoonv
         Es65aDwuHE1f3lFf/UppgciXjnHSTTsF9Cp0B/48TesNoUbbdpVeyanp0nR5G7natBra
         DdKw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1755419535; x=1756024335;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=YweHAm+41ud1dq4XVNswisNc+6gVbF14361cvsGjxvk=;
        b=m61xBpzYQnTLqaXcwcQoH6Hl4A1uYt5793u7bqEZlUxuI4jHk4VFBbs8XKjFd8Q8zS
         f5QxnXSZ1rAJqUx9PBV/bprP43+4W1VwbD9luzRSxdBVoLA5uI8/nudpnwgspLiqzsFl
         +hpNbz954DF1h1yOtvmA7XdwItlGddfxnbqi0gy97D7GTHNochixpJ/vcWhjjhLRJyuq
         OJ0MK+GGLfirsVpYJS1Y3jMdolohLW+3RY/+9aTQrqbEgyA2LQTUe8TW07EzwI8ILzFG
         DnG8u0dggRrpBqVgK2N6QZ/hVkm+Xi+L7qwk6h91817vxxH1tNsSqFOznSSngFroHwjX
         QeKA==
X-Forwarded-Encrypted: i=1; AJvYcCWRjfpcIXHAmw4nuI8tEn5PlwRkJGbwQDjbO1uTT/xjjKaslQLumTSCuQt9p0iWdjQmgU/w04I=@lists.linux.dev
X-Gm-Message-State: AOJu0Yzg0Yi/lxKJiaMQU88W+RvffOghJMZzKeckZfRr+AuNTixK/Kd+
	inKynnf7rQ6xXw9zqqI+VUlEpZk9tuVBJ+WinTGRozz8FkjpcaBrY6cR9GThLOTviaLwGtEyDwX
	kzA0Qij7Jq9SFp+yvLyX6tTxh8wwUiBYH5AiKe1UH
X-Gm-Gg: ASbGncsk4DOIrUwLfxeRa5FLV+asYLwS3fn26g0tfddNZAUHgVdBcxirUvdfOcKjIxI
	I96rqitgqXrFWsmJuD+Z5DHFtP2LAjb+xPoliPXp1zUupkJFqZORWsrqcsa0F1erXexQJlL4VQT
	tdSicpe+NYW1/enCbURJhgDQODsPTjGPGehlBcDbk5NBJzCtX07zacswH7eVlX54d8MdhWsPGTI
	K9msCT/ch1ISvXHLrmT32fi9HIorI6HncpadqP9PuHNAHH2tt4DzOeuJA==
X-Google-Smtp-Source: AGHT+IG6M11ulBvC7K5Dsrvxd53jLZtYOLmLnYkt2zl3Q5DOUrEBFx9S76paNjk+qFv1zUc0HOFhM9oTci4ZGefAZXg=
X-Received: by 2002:a17:902:ce89:b0:240:1bba:fc7d with SMTP id
 d9443c01a7336-2446d8ac792mr139040375ad.33.1755419534565; Sun, 17 Aug 2025
 01:32:14 -0700 (PDT)
Precedence: bulk
X-Mailing-List: syzbot@lists.linux.dev
List-Id: <syzbot.lists.linux.dev>
List-Subscribe: <mailto:syzbot+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:syzbot+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <68a10100.050a0220.e29e5.004f.GAE@google.com>
In-Reply-To: <68a10100.050a0220.e29e5.004f.GAE@google.com>
From: Aleksandr Nogikh <nogikh@google.com>
Date: Sun, 17 Aug 2025 10:32:03 +0200
X-Gm-Features: Ac12FXxSssW85E7Ko2Ov2VVo8p_WuIGgfoG9xQhOIbWIpgidw-lOkSjr6Hte8TI
Message-ID: <CANp29Y7b-NghEbhfNzyxPCgBEskmbO6Otj8NEjUKHcXVU6stFg@mail.gmail.com>
Subject: Re: [moderation/CI] Re: introduce uncharged file mapped folios
To: syzbot ci <syzbot+cib318a83238f8e465@syzkaller.appspotmail.com>
Cc: syzkaller-upstream-moderation@googlegroups.com, syzbot@lists.linux.dev
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

#syz upstream

On Sun, Aug 17, 2025 at 12:06=E2=80=AFAM syzbot ci
<syzbot+cib318a83238f8e465@syzkaller.appspotmail.com> wrote:
>
> syzbot ci has tested the following series
>
> [v2] introduce uncharged file mapped folios
> https://lore.kernel.org/all/cover.1755300815.git.boris@bur.io
> * [PATCH v2 1/3] mm/filemap: add AS_UNCHARGED
> * [PATCH v2 2/3] mm: add vmstat for cgroup uncharged pages
> * [PATCH v2 3/3] btrfs: set AS_UNCHARGED on the btree_inode
>
> and found the following issue:
> WARNING in folio_lruvec_lock_irqsave
>
> Full report is available here:
> https://ci.syzbot.org/series/15fd2538-1138-43c0-b4d6-6d7f53b0be69
>
> ***
>
> WARNING in folio_lruvec_lock_irqsave
>
> tree:      torvalds
> URL:       https://kernel.googlesource.com/pub/scm/linux/kernel/git/torva=
lds/linux
> base:      dfc0f6373094dd88e1eaf76c44f2ff01b65db851
> arch:      amd64
> compiler:  Debian clang version 20.1.7 (++20250616065708+6146a88f6049-1~e=
xp1~20250616065826.132), Debian LLD 20.1.7
> config:    https://ci.syzbot.org/builds/5b3f7bc8-d0c2-4985-8ae6-d51ea4e2b=
aed/config
> C repro:   https://ci.syzbot.org/findings/f02552bd-e7e6-4c3f-8cc3-04a5a94=
6771d/c_repro
> syz repro: https://ci.syzbot.org/findings/f02552bd-e7e6-4c3f-8cc3-04a5a94=
6771d/syz_repro
>
>  do_new_mount+0x2a2/0x9e0 fs/namespace.c:3805
>  do_mount fs/namespace.c:4133 [inline]
>  __do_sys_mount fs/namespace.c:4344 [inline]
>  __se_sys_mount+0x317/0x410 fs/namespace.c:4321
>  do_syscall_x64 arch/x86/entry/syscall_64.c:63 [inline]
>  do_syscall_64+0xfa/0x3b0 arch/x86/entry/syscall_64.c:94
>  entry_SYSCALL_64_after_hwframe+0x77/0x7f
> ------------[ cut here ]------------
> WARNING: CPU: 0 PID: 5951 at ./include/linux/memcontrol.h:734 folio_lruve=
c include/linux/memcontrol.h:734 [inline]
> WARNING: CPU: 0 PID: 5951 at ./include/linux/memcontrol.h:734 folio_lruve=
c_lock_irqsave+0x184/0x1d0 mm/memcontrol.c:1252
> Modules linked in:
> CPU: 0 UID: 0 PID: 5951 Comm: syz-executor Not tainted 6.17.0-rc1-syzkall=
er-00036-gdfc0f6373094-dirty #0 PREEMPT(full)
> Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS 1.16.2-debian-1.=
16.2-1 04/01/2014
> RIP: 0010:folio_lruvec include/linux/memcontrol.h:734 [inline]
> RIP: 0010:folio_lruvec_lock_irqsave+0x184/0x1d0 mm/memcontrol.c:1252
> Code: 74 0c 4c 89 f7 e8 cc 53 f8 ff 48 8b 04 24 49 89 06 eb a0 48 89 df 4=
8 c7 c6 60 4e 98 8b e8 a4 36 fd fe c6 05 52 a1 62 0d 01 90 <0f> 0b 90 e9 a5=
 fe ff ff 44 89 e1 80 e1 07 80 c1 03 38 c1 0f 8c 22
> RSP: 0018:ffffc9000359f540 EFLAGS: 00010246
> RAX: f0f9782cf8520600 RBX: ffffea0000807140 RCX: f0f9782cf8520600
> RDX: 0000000000000002 RSI: ffffffff8dba6067 RDI: ffff888020a73980
> RBP: ffffc9000359f5e0 R08: ffff88804b024253 R09: 1ffff1100960484a
> R10: dffffc0000000000 R11: ffffed100960484b R12: ffff88804b032fe8
> R13: ffff88801ba80918 R14: ffff888106950000 R15: 0000000000000000
> FS:  0000555587fa3500(0000) GS:ffff8880b861c000(0000) knlGS:0000000000000=
000
> CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> CR2: 000000c00003e720 CR3: 0000000029a9c000 CR4: 00000000000006f0
> Call Trace:
>  <TASK>
>  folio_lruvec_relock_irqsave include/linux/memcontrol.h:1544 [inline]
>  folio_batch_move_lru+0x20a/0x3a0 mm/swap.c:167
>  lru_add_drain_cpu+0x119/0x880 mm/swap.c:647
>  lru_add_drain+0x122/0x3e0 mm/swap.c:735
>  __folio_batch_release+0x48/0x90 mm/swap.c:1054
>  folio_batch_release include/linux/pagevec.h:101 [inline]
>  invalidate_inode_pages2_range+0x889/0xa80 mm/truncate.c:707
>  close_ctree+0x6ff/0x1380 fs/btrfs/disk-io.c:4408
>  generic_shutdown_super+0x135/0x2c0 fs/super.c:643
>  kill_anon_super+0x3b/0x70 fs/super.c:1282
>  btrfs_kill_super+0x41/0x50 fs/btrfs/super.c:2114
>  deactivate_locked_super+0xbc/0x130 fs/super.c:474
>  cleanup_mnt+0x425/0x4c0 fs/namespace.c:1378
>  task_work_run+0x1d4/0x260 kernel/task_work.c:227
>  resume_user_mode_work include/linux/resume_user_mode.h:50 [inline]
>  exit_to_user_mode_loop+0xec/0x110 kernel/entry/common.c:43
>  exit_to_user_mode_prepare include/linux/irq-entry-common.h:225 [inline]
>  syscall_exit_to_user_mode_work include/linux/entry-common.h:175 [inline]
>  syscall_exit_to_user_mode include/linux/entry-common.h:210 [inline]
>  do_syscall_64+0x2bd/0x3b0 arch/x86/entry/syscall_64.c:100
>  entry_SYSCALL_64_after_hwframe+0x77/0x7f
> RIP: 0033:0x7f4a78b8ff17
> Code: a8 ff ff ff f7 d8 64 89 01 48 83 c8 ff c3 0f 1f 44 00 00 31 f6 e9 0=
9 00 00 00 66 0f 1f 84 00 00 00 00 00 b8 a6 00 00 00 0f 05 <48> 3d 00 f0 ff=
 ff 77 01 c3 48 c7 c2 a8 ff ff ff f7 d8 64 89 02 b8
> RSP: 002b:00007ffe33fe80a8 EFLAGS: 00000246 ORIG_RAX: 00000000000000a6
> RAX: 0000000000000000 RBX: 00007f4a78c11c05 RCX: 00007f4a78b8ff17
> RDX: 0000000000000000 RSI: 0000000000000009 RDI: 00007ffe33fe8160
> RBP: 00007ffe33fe8160 R08: 0000000000000000 R09: 0000000000000000
> R10: 00000000ffffffff R11: 0000000000000246 R12: 00007ffe33fe91f0
> R13: 00007f4a78c11c05 R14: 000000000000f471 R15: 00007ffe33fe9230
>  </TASK>
>
>
> ***
>
> If these findings have caused you to resend the series or submit a
> separate fix, please add the following tag to your commit message:
> Tested-by: syzbot@syzkaller.appspotmail.com
>
> ---
> This report is generated by a bot. It may contain errors.
> syzbot ci engineers can be reached at syzkaller@googlegroups.com.
>
> The email will later be sent to:
> [boris@bur.io kernel-team@fb.com linux-btrfs@vger.kernel.org linux-fsdeve=
l@vger.kernel.org linux-mm@kvack.org shakeel.butt@linux.dev willy@infradead=
.org wqu@suse.com]
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
-upstream-moderation/68a10100.050a0220.e29e5.004f.GAE%40google.com.
