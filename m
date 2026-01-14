Received: from mail-ot1-f47.google.com (mail-ot1-f47.google.com [209.85.210.47])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AAC5F2C11CB
	for <syzbot@lists.linux.dev>; Wed, 14 Jan 2026 12:05:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.47
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768392339; cv=none; b=YiOucUdUTtb3+XG0kaIE44iWu11B/dn08FzOKQZFZO699RnyaRhS17Ko0pLAiGDIAUHga4JSR5dh15nfesaGKD01etIwTCDvToYz9OlJDlKhBYu6JyV2hm3+68ZaSWHe/jrkXt0EcdMHtrSXsMLy2e8WizuQwe0aoa06qqGUCRY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768392339; c=relaxed/simple;
	bh=NZ6x0vm5hWR8hKuPFHp2gmtnMmgGLvfQUuB/J/VC8Es=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=dE6xmz5cGlFfLsYl4I4SaGVZyIWpYhhpHaLIS0SL3xuw7Ck/llNJtaQOM8m9c96nrr9+cXzc98ks/UmAyLVcHusuyKpUrIw3RoqCIdumy8JwlUNHDmpov87VUDlmT/AG/HoZ+ebNyYmpx7Bh1LTN2gEhNxRkBPtCZl+TWdqMzH4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=D/8DarTw; arc=none smtp.client-ip=209.85.210.47
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="D/8DarTw"
Received: by mail-ot1-f47.google.com with SMTP id 46e09a7af769-7cfcbf34124so333297a34.0
        for <syzbot@lists.linux.dev>; Wed, 14 Jan 2026 04:05:37 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1768392336; x=1768997136; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=X7IUQu6YxPe6gLpDNmUad5ZKqumKPp9ill4F8mtYWhY=;
        b=D/8DarTwFrdgioXdaDl/kYuB/EzGAvkLc3vIB0SfkRr4q0vsUhJ1lp2hhV4pxw5G/U
         C5hb7Ohy/R5fLb9GBwoq91KlPBLQBJzMgqy6eKxpGWPAA4d/gsSS1qrJczqL1NQ7blGT
         cqyV/Trm3rEw3Pu+u1GoabqVlnS6rpVJP5uL+NSP8d8t60ednW+PRvfPs7bWwglu33ux
         IGZzycJUS2yvoiyc1A36/o2/8oj7Cgd3gjakkCi2WEid1Essmz5NyaV+YnZUzETSmV9O
         8wb6F6dzl87wQ1P8B78IcCyPBKUPxenSag11Z6vH8FbHdUdcMJ1CKaxDm/Ed1BuTgnNq
         vrvA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1768392336; x=1768997136;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=X7IUQu6YxPe6gLpDNmUad5ZKqumKPp9ill4F8mtYWhY=;
        b=tD0Cccj6hJS16hf1UbvEGDqxfbV+J/XdXF/00rDLqEl5FkKM002W0l02LHGBGolbRj
         O30HzPcAWTuk/aS/be6KO2PXaQbWLLPlwsHsCkC4rAxZmQBqhCSf7bLXgklkvdzBcfCs
         YCCYo5nIY+t7eq9zJ4/AguihF/zr6VIfZ2vMK5df2cTuX04+w//wfGvC1JZs+hKZnkUE
         f2cfq1M3tFHUBh6Ket0GBqGD0XmKGXs7sC6qjj8qte3dU85kdv3fv3ic2ONh0t0aSHVG
         gSfiPpy/jcTSM9QG2140DY2BUvEXYMPRGGFNdbZqYhN5cXbpGUXqZoGhymgZqn5T/yAj
         D1gw==
X-Forwarded-Encrypted: i=1; AJvYcCWI5rD42lbhJI/XtODZvAQSM+2oRVGQgqRvWkkuwD2cQE+MnIiqJXQ0MYj62lp2nAF3NCyQQcA=@lists.linux.dev
X-Gm-Message-State: AOJu0YzabPTRW4xFwu1J7uON1KFTqnZCQIJhQMamncLItQK0TfGKY4SA
	xjA8F1yyNFqdFW5o6OCX+gRi9pJCncckszd6vhoFJYk1DpvEgcZMjlgKjPwDzxknJhlrGZ/UN30
	PZvDxOrhedV/xyenvhyKUlIieEm+wePuDyO7YQ0vK
X-Gm-Gg: AY/fxX6k24HQWDvr5VSy8jcZ/CLLIJTf9KOHLZUnlELb3/RqHcZTPYqHcfzvsNkIrhC
	xjfXoi+VcU8raFfTiW6nuFKYr/5v/Grc+FvfNoCODZ4VPUWlemuhjgzkI+DJS4/sYBiOM9jjw79
	hAXhuGe42KeYVWsNVGRInr4qaPhlfqCD1Hh6xi/0U146hVTldE3dYcsYtx3FyVv213Qm0GpkcEN
	h/7DDm//ok9Qx9IDxaR22ZPB8t99FqsKifIqTedbsSanzb8pMJwG2Ke5peICVKJ7j4gAYZX3nGe
	0JyZBUl5+eJLm+5X6FaX6kX1UhAm3MnfeGaVKtkRZdgkENSMSDpbHFLYsg==
X-Received: by 2002:a05:6808:1b86:b0:44f:8f27:e39a with SMTP id
 5614622812f47-45c73b61663mr1368805b6e.8.1768392336144; Wed, 14 Jan 2026
 04:05:36 -0800 (PST)
Precedence: bulk
X-Mailing-List: syzbot@lists.linux.dev
List-Id: <syzbot.lists.linux.dev>
List-Subscribe: <mailto:syzbot+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:syzbot+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <696782de.a70a0220.2c0c17.0000.GAE@google.com>
In-Reply-To: <696782de.a70a0220.2c0c17.0000.GAE@google.com>
From: Aleksandr Nogikh <nogikh@google.com>
Date: Wed, 14 Jan 2026 13:05:25 +0100
X-Gm-Features: AZwV_Qg8oaYkBA9U40v0dISpeDyMm-upB3mmS4sp0o_yONKjJCVBmHLY6GNJLgI
Message-ID: <CANp29Y4de2SgTznQZR1TrZ4HYm4rHm2T9jFY48UrO=7WZAi+yA@mail.gmail.com>
Subject: Re: [moderation/CI] Re: iomap: add allocation cache for iomap_dio
To: syzbot ci <syzbot+ci7262165a567f7af3@syzkaller.appspotmail.com>
Cc: syzkaller-upstream-moderation@googlegroups.com, syzbot@lists.linux.dev
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

#syz upstream

On Wed, Jan 14, 2026 at 12:49=E2=80=AFPM syzbot ci
<syzbot+ci7262165a567f7af3@syzkaller.appspotmail.com> wrote:
>
> syzbot ci has tested the following series
>
> [v2] iomap: add allocation cache for iomap_dio
> https://lore.kernel.org/all/20260114074113.151089-1-guzebing1612@gmail.co=
m
> * [PATCH v2] iomap: add allocation cache for iomap_dio
>
> and found the following issue:
> BUG: sleeping function called from invalid context in __iomap_dio_rw
>
> Full report is available here:
> https://ci.syzbot.org/series/2217a3d5-b2ea-47d6-9bca-2776e95fd748
>
> ***
>
> BUG: sleeping function called from invalid context in __iomap_dio_rw
>
> tree:      torvalds
> URL:       https://kernel.googlesource.com/pub/scm/linux/kernel/git/torva=
lds/linux
> base:      b2c43efc3c8d9cda34eb8421249d15e6fed4d650
> arch:      amd64
> compiler:  Debian clang version 21.1.8 (++20251221033036+2078da43e25a-1~e=
xp1~20251221153213.50), Debian LLD 21.1.8
> config:    https://ci.syzbot.org/builds/1397dec0-a77b-450c-9c93-79aa717e1=
cff/config
> C repro:   https://ci.syzbot.org/findings/b20bf03e-8485-4437-9a20-8d11cc0=
561d4/c_repro
> syz repro: https://ci.syzbot.org/findings/b20bf03e-8485-4437-9a20-8d11cc0=
561d4/syz_repro
>
> EXT4-fs (loop0): mounted filesystem 00000000-0000-0000-0000-000000000000 =
r/w without journal. Quota mode: none.
> BUG: sleeping function called from invalid context at ./include/linux/sch=
ed/mm.h:321
> in_atomic(): 1, irqs_disabled(): 0, non_block: 0, pid: 5964, name: syz.0.=
17
> preempt_count: 1, expected: 0
> RCU nest depth: 0, expected: 0
> 1 lock held by syz.0.17/5964:
>  #0: ffff88811839aa20 (&sb->s_type->i_mutex_key#9){++++}-{4:4}, at: inode=
_lock_shared include/linux/fs.h:995 [inline]
>  #0: ffff88811839aa20 (&sb->s_type->i_mutex_key#9){++++}-{4:4}, at: ext4_=
dio_read_iter fs/ext4/file.c:78 [inline]
>  #0: ffff88811839aa20 (&sb->s_type->i_mutex_key#9){++++}-{4:4}, at: ext4_=
file_read_iter+0x298/0x660 fs/ext4/file.c:145
> Preemption disabled at:
> [<ffffffff825b641d>] pcpu_cache_list_alloc fs/iomap/direct-io.c:129 [inli=
ne]
> [<ffffffff825b641d>] __iomap_dio_rw+0x30d/0x2510 fs/iomap/direct-io.c:749
> CPU: 0 UID: 0 PID: 5964 Comm: syz.0.17 Not tainted syzkaller #0 PREEMPT(f=
ull)
> Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS 1.16.2-debian-1.=
16.2-1 04/01/2014
> Call Trace:
>  <TASK>
>  dump_stack_lvl+0x1a9/0x280 lib/dump_stack.c:120
>  __might_resched+0x4b0/0x630 kernel/sched/core.c:8925
>  might_alloc include/linux/sched/mm.h:321 [inline]
>  slab_pre_alloc_hook mm/slub.c:4906 [inline]
>  slab_alloc_node mm/slub.c:5241 [inline]
>  __do_kmalloc_node mm/slub.c:5626 [inline]
>  __kmalloc_noprof+0xbc/0x7d0 mm/slub.c:5639
>  kmalloc_noprof include/linux/slab.h:961 [inline]
>  pcpu_cache_list_alloc fs/iomap/direct-io.c:134 [inline]
>  __iomap_dio_rw+0xbdd/0x2510 fs/iomap/direct-io.c:749
>  iomap_dio_rw+0x45/0xb0 fs/iomap/direct-io.c:947
>  ext4_dio_read_iter fs/ext4/file.c:94 [inline]
>  ext4_file_read_iter+0x4f8/0x660 fs/ext4/file.c:145
>  copy_splice_read+0x5ff/0xaa0 fs/splice.c:363
>  do_splice_read fs/splice.c:981 [inline]
>  splice_direct_to_actor+0x4a0/0xc70 fs/splice.c:1086
>  do_splice_direct_actor fs/splice.c:1204 [inline]
>  do_splice_direct+0x195/0x290 fs/splice.c:1230
>  do_sendfile+0x535/0x7c0 fs/read_write.c:1370
>  __do_sys_sendfile64 fs/read_write.c:1431 [inline]
>  __se_sys_sendfile64+0x144/0x1a0 fs/read_write.c:1417
>  do_syscall_x64 arch/x86/entry/syscall_64.c:63 [inline]
>  do_syscall_64+0xf0/0xfa0 arch/x86/entry/syscall_64.c:94
>  entry_SYSCALL_64_after_hwframe+0x77/0x7f
> RIP: 0033:0x7f8cd8b9acb9
> Code: ff c3 66 2e 0f 1f 84 00 00 00 00 00 0f 1f 44 00 00 48 89 f8 48 89 f=
7 48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 ff=
 ff 73 01 c3 48 c7 c1 e8 ff ff ff f7 d8 64 89 01 48
> RSP: 002b:00007ffeab7c8828 EFLAGS: 00000246 ORIG_RAX: 0000000000000028
> RAX: ffffffffffffffda RBX: 00007f8cd8e15fa0 RCX: 00007f8cd8b9acb9
> RDX: 0000000000000000 RSI: 0000000000000004 RDI: 0000000000000004
> RBP: 00007f8cd8c08bf7 R08: 0000000000000000 R09: 0000000000000000
> R10: 0000000000fffe82 R11: 0000000000000246 R12: 0000000000000000
> R13: 00007f8cd8e15fac R14: 00007f8cd8e15fa0 R15: 00007f8cd8e15fa0
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
> [brauner@kernel.org changfengnan@bytedance.com djwong@kernel.org guzebing=
1612@gmail.com linux-fsdevel@vger.kernel.org linux-kernel@vger.kernel.org l=
inux-xfs@vger.kernel.org]
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
-upstream-moderation/696782de.a70a0220.2c0c17.0000.GAE%40google.com.
