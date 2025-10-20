Received: from mail-ot1-f51.google.com (mail-ot1-f51.google.com [209.85.210.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A413820B22
	for <syzbot@lists.linux.dev>; Mon, 20 Oct 2025 06:40:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.51
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760942415; cv=none; b=bvrEGIatyoAhJlADJ7+5hdMiwvHQlfLzkuzB5N7t4TWbCVC9nmKYsJ7pt6uIXD9KGuKbd2C888UZsoXMcgLl9dd1oAmWEufPwEPC0PRb6gC+Y2c67clTozMTGyJtl1wKYxb78/0Si/klC0kGhLOkFQlBYIJ5YX5//brP7Dq2pMw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760942415; c=relaxed/simple;
	bh=Nnn7avwJR3TyLrJPWz8Lv8nzQaIZc5Mgbvi0OgzhXjQ=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=eeFSkF4p+TMIjqfejYUUSO4Tm61gN1fJP14WCp+bE5B6lJC2+oDC4CXk0RTViPzGHUxCmDPYrTWgx4F/c58mPcs3N3FLzeYnwu9vnzaZwlcSPBSPdEsQwU6eMdrqisFCAa0U4l4vwKuVzxdwGs5pgNSNaKPI5T4E+rLy2Abs06M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=OEL9mpS9; arc=none smtp.client-ip=209.85.210.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="OEL9mpS9"
Received: by mail-ot1-f51.google.com with SMTP id 46e09a7af769-7b4f7a855baso2994407a34.3
        for <syzbot@lists.linux.dev>; Sun, 19 Oct 2025 23:40:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1760942412; x=1761547212; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=OAMpbaZFxPAm9Iy1GPBnSZkGimJs2s/P0yokXkquEeY=;
        b=OEL9mpS9HQiAyQFEzrfxR43LSFIkjvkfIvRIsF8T/e7h3Za1+ay1qmS9jdbzN4rDAi
         vmE7rYBW1VKiXYWbGQQexq0yEjl4HMlJC6qkQGveAywBWSuRyGE2n6CerquJDY3l+jV5
         9oPlZbcTIr4nhWY7aAQj9UN9VMXT4qXmr8cks9cDf9vjDoDyTPW2DdMsCDvS345OKfmB
         92tCe53fNqzUN6d5qK/LPREFjLCevRjtSgqRAmHzcCY5FotFig/kUxYkPRcH/iZytx9j
         0dFpF56oQGrDBWTNaiBE4VK+wmi/sXM8ik02VMy/uu8UCncqZqxzRxegrWKJWCTk3qcL
         Av9Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1760942412; x=1761547212;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=OAMpbaZFxPAm9Iy1GPBnSZkGimJs2s/P0yokXkquEeY=;
        b=nduMICn2DCI5bN+VfLb43TnLxpWpx0rinuNuJAGATR6J1GtEM+X895ZkxXkXYk1ekl
         bS8EzQ6O/iEpWX0LSS84dObezAr9Ru3VNJw0B9ZHA2RdUSsI+ufotYaBCJBQYO18Rt67
         6LrSoA2Ku05A3iRtV+DrjifO71Ii6/cwxkoXg28JVFbihmQFdUNFsKBuzI2TO65m/67s
         p/zJ8e1egoAnowoHtRczG/LUVyeXZsaUXkdsIlkRcAtnj1OCfQ16RpfVP4SggbwST/As
         ElcnVSKf5jRxGfm/BxUKxmGcGv83UKNnkHlL17rsLkOKabxnwuTL14hRDk48oaga3orh
         le6A==
X-Forwarded-Encrypted: i=1; AJvYcCXOd69LrkwKkoDZeA95NQxhbOlK03X2RT416qyEH02fAhkm3gusHtKMs4NwLE/deXEDk+SxvfY=@lists.linux.dev
X-Gm-Message-State: AOJu0YwVpm6xgYiKjJzmUU637wP89ynK3RxoQOtH7I2RvEscnzubSb2t
	nMWyPL1Cp1UtVgs+ijCc7EtoPMz6gMiBZVIqJlTSfCR8A7wJNJdem8xk2TJYzvmFs1f+hp3Q2b9
	pIXUH86pyr5uk8dwf1nIJ3U2Rw7BsUm2VJNne6Kuz
X-Gm-Gg: ASbGncvA1FrvcFP011ia8aSQtLyMPIgQtsmVdl1XfwYxpKKA+nszWXekf04Vv2LgXsI
	gPu9Z1AjHS+LbgkyB6evJHVkw2OWAgrefGE8TSb0GRcsaOduo0ecMhQ8Zazxqyx9jHQ6aUFWptm
	/WUJI4qgokv+IV97/hKvoqJYJ+Lg7lYJYxdew9ymh7kZa6KBZEMHL7t005HlksbvzuMhCih2MoF
	xq+2uSb+tS98oJLWI+LoVIPCkBr0ucQ6mssR96klpi57MDl0t4WYQgYJ1/kylSdxY3Od3eNP0HG
	GmPFBUyfUrWPcbdST+ZvsNwgO78j8lrhccy3cAQPobqK4mjz1bbHHc2HXbOzE1DljHBmX7E=
X-Google-Smtp-Source: AGHT+IHjA23JdxTYM7HkH2GPZRI1G3zNcP44U9CQz7xqCFXAUjCy+2FRKs2z1eDIsIQMW1hQYbSsxz+Euun2CPvMKno=
X-Received: by 2002:a05:6808:6d91:b0:442:5fa:290d with SMTP id
 5614622812f47-443a30afa6emr4798902b6e.43.1760942412429; Sun, 19 Oct 2025
 23:40:12 -0700 (PDT)
Precedence: bulk
X-Mailing-List: syzbot@lists.linux.dev
List-Id: <syzbot.lists.linux.dev>
List-Subscribe: <mailto:syzbot+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:syzbot+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <68f5ba78.050a0220.91a22.043d.GAE@google.com>
In-Reply-To: <68f5ba78.050a0220.91a22.043d.GAE@google.com>
From: Aleksandr Nogikh <nogikh@google.com>
Date: Mon, 20 Oct 2025 08:40:01 +0200
X-Gm-Features: AS18NWCSqTI9kh-q1OJ30H2w0axPom2E1uqGYfCpq9QW94E9opy16lMCMM0Unno
Message-ID: <CANp29Y4xM8PAGpF3X9rqNs9y_aFVbfkGLyoWAuoBCg2pU4FDNA@mail.gmail.com>
Subject: Re: [moderation/CI] Re: Separate ptdesc from struct page
To: syzbot ci <syzbot+ci1d0ea3c67212a0da@syzkaller.appspotmail.com>
Cc: syzkaller-upstream-moderation@googlegroups.com, syzbot@lists.linux.dev
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

#syz upstream

On Mon, Oct 20, 2025 at 6:28=E2=80=AFAM syzbot ci
<syzbot+ci1d0ea3c67212a0da@syzkaller.appspotmail.com> wrote:
>
> syzbot ci has tested the following series
>
> [v1] Separate ptdesc from struct page
> https://lore.kernel.org/all/20251020001652.2116669-1-willy@infradead.org
> * [RFC PATCH 1/7] mm: Use frozen pages for page tables
> * [RFC PATCH 2/7] mm: Account pagetable memory when allocated
> * [RFC PATCH 3/7] mm: Mark pagetable memory when allocated
> * [RFC PATCH 4/7] pgtable: Remove uses of page->lru
> * [RFC PATCH 5/7] x86: Call preallocate_vmalloc_pages() later
> * [RFC PATCH 6/7] mm: Add alloc_pages_memdesc family of APIs
> * [RFC PATCH 7/7] mm: Allocate ptdesc from slab
>
> and found the following issue:
> kernel BUG in pte_free_now
>
> Full report is available here:
> https://ci.syzbot.org/series/034eb8df-67a6-4c07-8ba5-3ac0df045a40
>
> ***
>
> kernel BUG in pte_free_now
>
> tree:      torvalds
> URL:       https://kernel.googlesource.com/pub/scm/linux/kernel/git/torva=
lds/linux
> base:      3a8660878839faadb4f1a6dd72c3179c1df56787
> arch:      amd64
> compiler:  Debian clang version 20.1.8 (++20250708063551+0c9f909b7976-1~e=
xp1~20250708183702.136), Debian LLD 20.1.8
> config:    https://ci.syzbot.org/builds/2cf2c360-080f-4864-9be9-e277d29fc=
594/config
> syz repro: https://ci.syzbot.org/findings/1f85642a-695a-4b8d-a5ee-b95a510=
5cc53/syz_repro
>
>  __do_softirq kernel/softirq.c:656 [inline]
>  invoke_softirq kernel/softirq.c:496 [inline]
>  __irq_exit_rcu+0xca/0x1f0 kernel/softirq.c:723
>  irq_exit_rcu+0x9/0x30 kernel/softirq.c:739
>  instr_sysvec_apic_timer_interrupt arch/x86/kernel/apic/apic.c:1052 [inli=
ne]
>  sysvec_apic_timer_interrupt+0xa6/0xc0 arch/x86/kernel/apic/apic.c:1052
>  asm_sysvec_apic_timer_interrupt+0x1a/0x20 arch/x86/include/asm/idtentry.=
h:697
> ------------[ cut here ]------------
> kernel BUG at ./include/linux/mm.h:2959!
> Oops: invalid opcode: 0000 [#1] SMP KASAN PTI
> CPU: 0 UID: 0 PID: 6093 Comm: syz.1.54 Not tainted syzkaller #0 PREEMPT(f=
ull)
> Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS 1.16.2-debian-1.=
16.2-1 04/01/2014
> RIP: 0010:page_ptdesc include/linux/mm.h:2959 [inline]
> RIP: 0010:pte_free include/asm-generic/pgalloc.h:115 [inline]
> RIP: 0010:pte_free_now+0xc2/0xd0 mm/pgtable-generic.c:249
> Code: 48 89 df e8 20 d1 13 00 48 8b 13 48 c7 c7 c0 89 76 8b 4c 89 f6 e8 6=
e 66 15 ff 4c 89 ff 48 c7 c6 00 8a 76 8b e8 1f c3 15 ff 90 <0f> 0b 66 66 66=
 2e 0f 1f 84 00 00 00 00 00 90 90 90 90 90 90 90 90
> RSP: 0018:ffffc90000007bb0 EFLAGS: 00010246
> RAX: de62a9f92d629d00 RBX: ffffea0005ca91e0 RCX: de62a9f92d629d00
> RDX: 0000000000000002 RSI: ffffffff8d9d1d2d RDI: ffff8881127ad700
> RBP: ffffc90000007e30 R08: ffffc90000007567 R09: 1ffff92000000eac
> R10: dffffc0000000000 R11: fffff52000000ead R12: dffffc0000000000
> R13: ffffffff81a82b37 R14: 0000000000000000 R15: ffffea0005ca91c0
> FS:  00007f66c98976c0(0000) GS:ffff88818e70c000(0000) knlGS:0000000000000=
000
> CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> CR2: 00007f66c9896fc8 CR3: 0000000112a72000 CR4: 00000000000006f0
> Call Trace:
>  <IRQ>
>  rcu_do_batch kernel/rcu/tree.c:2605 [inline]
>  rcu_core+0xcab/0x1770 kernel/rcu/tree.c:2861
>  handle_softirqs+0x286/0x870 kernel/softirq.c:622
>  __do_softirq kernel/softirq.c:656 [inline]
>  invoke_softirq kernel/softirq.c:496 [inline]
>  __irq_exit_rcu+0xca/0x1f0 kernel/softirq.c:723
>  irq_exit_rcu+0x9/0x30 kernel/softirq.c:739
>  instr_sysvec_apic_timer_interrupt arch/x86/kernel/apic/apic.c:1052 [inli=
ne]
>  sysvec_apic_timer_interrupt+0xa6/0xc0 arch/x86/kernel/apic/apic.c:1052
>  </IRQ>
>  <TASK>
>  asm_sysvec_apic_timer_interrupt+0x1a/0x20 arch/x86/include/asm/idtentry.=
h:697
> RIP: 0010:clear_page_rep+0xe/0x20 arch/x86/lib/clear_page_64.S:23
> Code: cc cc cc cc cc cc cc cc cc cc cc cc 90 90 90 90 90 90 90 90 90 90 9=
0 90 90 90 90 90 f3 0f 1e fa b9 00 02 00 00 31 c0 f3 48 ab <e9> 8d 46 04 00=
 90 90 90 90 90 90 90 90 90 90 90 90 90 90 90 90 90
> RSP: 0018:ffffc90003cb76d0 EFLAGS: 00000246
> RAX: 0000000000000000 RBX: fffa800000000000 RCX: 0000000000000000
> RDX: 0000000000000000 RSI: 0000000000000000 RDI: ffff8880123a2000
> RBP: fffa8000123a1000 R08: ffffea000048e847 R09: 1ffffd4000091d08
> R10: dffffc0000000000 R11: fffff94000091d09 R12: 0000000000000000
> R13: 1ffffffff1b404a6 R14: 1ffffffff1b404a4 R15: 0000000000000000
>  clear_page arch/x86/include/asm/page_64.h:54 [inline]
>  clear_highpage include/linux/highmem.h:240 [inline]
>  shmem_get_folio_gfp+0xaad/0x1660 mm/shmem.c:2583
>  shmem_fault+0x179/0x390 mm/shmem.c:2734
>  __do_fault+0x138/0x390 mm/memory.c:5280
>  do_read_fault mm/memory.c:5698 [inline]
>  do_fault mm/memory.c:5832 [inline]
>  do_pte_missing mm/memory.c:4361 [inline]
>  handle_pte_fault mm/memory.c:6177 [inline]
>  __handle_mm_fault+0x35e3/0x5400 mm/memory.c:6318
>  handle_mm_fault+0x40a/0x8e0 mm/memory.c:6487
>  faultin_page mm/gup.c:1126 [inline]
>  __get_user_pages+0x165c/0x2a00 mm/gup.c:1428
>  populate_vma_page_range+0x29f/0x3a0 mm/gup.c:1860
>  __mm_populate+0x24c/0x380 mm/gup.c:1963
>  mm_populate include/linux/mm.h:3451 [inline]
>  vm_mmap_pgoff+0x387/0x4d0 mm/util.c:586
>  do_syscall_x64 arch/x86/entry/syscall_64.c:63 [inline]
>  do_syscall_64+0xfa/0xfa0 arch/x86/entry/syscall_64.c:94
>  entry_SYSCALL_64_after_hwframe+0x77/0x7f
> RIP: 0033:0x7f66c898efc9
> Code: ff ff c3 66 2e 0f 1f 84 00 00 00 00 00 0f 1f 40 00 48 89 f8 48 89 f=
7 48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 ff=
 ff 73 01 c3 48 c7 c1 a8 ff ff ff f7 d8 64 89 01 48
> RSP: 002b:00007f66c9897038 EFLAGS: 00000246 ORIG_RAX: 0000000000000009
> RAX: ffffffffffffffda RBX: 00007f66c8be6090 RCX: 00007f66c898efc9
> RDX: b635773f06ebbeef RSI: 0000000000b36000 RDI: 0000200000000000
> RBP: 00007f66c8a11f91 R08: ffffffffffffffff R09: 00000000e9ba1000
> R10: 0000000000008031 R11: 0000000000000246 R12: 0000000000000000
> R13: 00007f66c8be6128 R14: 00007f66c8be6090 R15: 00007ffcfaf828b8
>  </TASK>
> Modules linked in:
> ---[ end trace 0000000000000000 ]---
> RIP: 0010:page_ptdesc include/linux/mm.h:2959 [inline]
> RIP: 0010:pte_free include/asm-generic/pgalloc.h:115 [inline]
> RIP: 0010:pte_free_now+0xc2/0xd0 mm/pgtable-generic.c:249
> Code: 48 89 df e8 20 d1 13 00 48 8b 13 48 c7 c7 c0 89 76 8b 4c 89 f6 e8 6=
e 66 15 ff 4c 89 ff 48 c7 c6 00 8a 76 8b e8 1f c3 15 ff 90 <0f> 0b 66 66 66=
 2e 0f 1f 84 00 00 00 00 00 90 90 90 90 90 90 90 90
> RSP: 0018:ffffc90000007bb0 EFLAGS: 00010246
> RAX: de62a9f92d629d00 RBX: ffffea0005ca91e0 RCX: de62a9f92d629d00
> RDX: 0000000000000002 RSI: ffffffff8d9d1d2d RDI: ffff8881127ad700
> RBP: ffffc90000007e30 R08: ffffc90000007567 R09: 1ffff92000000eac
> R10: dffffc0000000000 R11: fffff52000000ead R12: dffffc0000000000
> R13: ffffffff81a82b37 R14: 0000000000000000 R15: ffffea0005ca91c0
> FS:  00007f66c98976c0(0000) GS:ffff88818e70c000(0000) knlGS:0000000000000=
000
> CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> CR2: 00007f66c9896fc8 CR3: 0000000112a72000 CR4: 00000000000006f0
> ----------------
> Code disassembly (best guess):
>    0:   cc                      int3
>    1:   cc                      int3
>    2:   cc                      int3
>    3:   cc                      int3
>    4:   cc                      int3
>    5:   cc                      int3
>    6:   cc                      int3
>    7:   cc                      int3
>    8:   cc                      int3
>    9:   cc                      int3
>    a:   cc                      int3
>    b:   cc                      int3
>    c:   90                      nop
>    d:   90                      nop
>    e:   90                      nop
>    f:   90                      nop
>   10:   90                      nop
>   11:   90                      nop
>   12:   90                      nop
>   13:   90                      nop
>   14:   90                      nop
>   15:   90                      nop
>   16:   90                      nop
>   17:   90                      nop
>   18:   90                      nop
>   19:   90                      nop
>   1a:   90                      nop
>   1b:   90                      nop
>   1c:   f3 0f 1e fa             endbr64
>   20:   b9 00 02 00 00          mov    $0x200,%ecx
>   25:   31 c0                   xor    %eax,%eax
>   27:   f3 48 ab                rep stos %rax,%es:(%rdi)
> * 2a:   e9 8d 46 04 00          jmp    0x446bc <-- trapping instruction
>   2f:   90                      nop
>   30:   90                      nop
>   31:   90                      nop
>   32:   90                      nop
>   33:   90                      nop
>   34:   90                      nop
>   35:   90                      nop
>   36:   90                      nop
>   37:   90                      nop
>   38:   90                      nop
>   39:   90                      nop
>   3a:   90                      nop
>   3b:   90                      nop
>   3c:   90                      nop
>   3d:   90                      nop
>   3e:   90                      nop
>   3f:   90                      nop
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
> [hannes@cmpxchg.org linux-mm@kvack.org vishal.moola@gmail.com willy@infra=
dead.org]
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
-upstream-moderation/68f5ba78.050a0220.91a22.043d.GAE%40google.com.
