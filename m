Received: from mail-wm1-f49.google.com (mail-wm1-f49.google.com [209.85.128.49])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 40CD954763
	for <syzbot@lists.linux.dev>; Fri, 24 Apr 2026 07:34:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.128.49
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777016092; cv=pass; b=KMI+BjU/SVPNTRrpxMdQYMY67wQZTb8Xxg4JP38w7ESlFQjASyy56c9+7F5Cq3ZJ0NXCccKa9FbLSnfTJ7NgOJxnaOPU8QNgbiaYE/z7hb2b2GKtAy6H+2I9bP7aLzfs+x5TRG+osllAK7iDY928qgcq6YShP7HsrDCvA7CEyhk=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777016092; c=relaxed/simple;
	bh=hdwfK76/oO6g1cojw+jl7wo71uBQzHT0RABelIupwow=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=IQRTyTlLnW6fSgxqqjtskz51UmnH8ow02AT1bavjzjgAunFesJGYxBRm3CMQ3Q8rxLFpTZkRPMT8f9R6ZeDhjFMbBpc/VVPFlMDLP3DHdj7yDUly+6N//CfWlySH+KKGuIZe9UKDWvVzjEdMjaKzCuZvrSzrbEEZ6twdjCT/+S8=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=U9k7g/3x; arc=pass smtp.client-ip=209.85.128.49
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="U9k7g/3x"
Received: by mail-wm1-f49.google.com with SMTP id 5b1f17b1804b1-4891c00e7aeso50170875e9.2
        for <syzbot@lists.linux.dev>; Fri, 24 Apr 2026 00:34:48 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1777016087; cv=none;
        d=google.com; s=arc-20240605;
        b=jKONJWB7waTndzzQBJeKd+th1pOMGPstgkHcWVEyycmslKniFA7qI3eDR9l6E/DaKA
         k4i7ckUJN79Z0IUxdMIAGGukwsJd00e0G+FCAbbiGbINl4L0PNMlctvpi4WvdAfAm4D0
         rPFObwPW9rT4pKXOVRwdTU4Jx4cOBhS87Q4BRFU6h8Tmo4DwgeaBZKRXVdHlkVl+DObb
         qROSkR30EeLkSC+OZQVE6j2IIQESnzk+dHffflsYD5EqT+CV6IVg36HBRUv7rSiVhcme
         YjrBUcbfVmGGHesu9uZ/BBINAUbV/lhlSf/xdS3d38niwDQlH5/UQgFdgT8mc9MRJtOD
         lOEg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=93Wb+UeDqWywMklXRzyfpy+JySoundWjI2o9h95io58=;
        fh=zT3ddqbErFQy15d8vuu+2QaDwmDcJ3Hqih2Cth7PedY=;
        b=ZKR119kyPZ7Zi1HEJTYcBBRlL94Es7C83+7AiMlwV3O0O/gOjoHt1KxhNrA2DYIFZq
         vWztqzXXCRE9pg8ehf/OIf4oCEH6OgEs9xvN6wfzWG/0ZSCIgAueqIxfH/9kJC2WLeAG
         d5rbpENNO8fjZSPHXmKHGo2rKlJg+MLPNdG1zXCPFaQ2Lun0nGr/EAsGyBOoGdKjHGRA
         pHW5XEj6AVF1C7sK9LPCzCs1XtVZVTaf4g1wT0MDh4DTU1DiIDaRz5cnGMCGfeP/+Xjy
         PAfTkrtDVFadSuT8rn7HwgJwzukb3NH1njhGkPbeRSjpYMKvjEOEMBlE5dE6oNmEcbxl
         YrHQ==;
        darn=lists.linux.dev
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1777016087; x=1777620887; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=93Wb+UeDqWywMklXRzyfpy+JySoundWjI2o9h95io58=;
        b=U9k7g/3xhrXbt/dh7A22v7rR9QlcG594l9E/lzWeLlVInRy+kk19b/FwUgJWk1lrMN
         XVQDoiDtfBFd9fcwbpi/LZfYbm57gJiv73eGv6qe7So8Rt0qB8oUJHRJEVpOl7Z7I83C
         pm0bXN5qhlMOMGVi1XVv64CeSGmWnzO9/7Ue4+YxK58uxcCXoRpkzevDty4QAn7jhylI
         uIXqovIay1wZtRMYHORhxYo94UXjMxrWqfok+VJPPMo0bDhDPvWppzGHSW1ch5M48LHr
         yg8PVmQ+4kkwHdTzl6T+pgYP2azgP4wAVhAPBd0zqCQGvLL3OQKLTDPRqOhKIaw3sx5K
         Dwhg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1777016087; x=1777620887;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=93Wb+UeDqWywMklXRzyfpy+JySoundWjI2o9h95io58=;
        b=T3X/2KQQSHJElFGR0Dd9wMygma5APqPOVdZA5BaL6a5ibQ2l+itmHSf3PqzeUP2Aik
         9uaURnYDNOc9ydQmZU8j91hDiuNmuRXTDrFsQYk+zNmAFhVpnjtpET2RwicHpcdz6/kg
         VFIf4EG7WjA1LM7cu5CfDysTRvP9JrsfWTtDpY7wOmHOllfQlCQ7Ci/3Yc2U5HFwmFun
         YpAZHy0DWCJXY/rTYGiYVwyjbdU6i0D1T15K2idp2wOu9JDE75M0uJu9rWpY7srnJk5i
         zdhNTKLNVallqHbrwMmKFlXOenRNc4lUIYwYqzNzG+S3Pg70nzBdE55GuHpSFZvBQwwV
         K7RQ==
X-Forwarded-Encrypted: i=1; AFNElJ+bl5rKSKjU7AgVSWc4g/mn/21P9YuNuG0MsrR1ZhBCxhaDCudrEcz7alsNgFgpdTLcZznxLl4=@lists.linux.dev
X-Gm-Message-State: AOJu0Yz3ByR8z8B4axmDTMVhz+sHO3uISzZSVzD8dZNosJIe0INTV2s2
	0ohWr6dtda3b34ihhvKvm0MzfnP4qJFK4uhpyyEYy6Csj48Ic8AqcHYBu8zNzafRYSwGfxg7kiu
	SyMDV+2rHFQ5DP9GX28tnjMmq6vfS4hvZSSE1r+6q
X-Gm-Gg: AeBDieuVL89sxtJTEwNZIOdkUpu1y9DfWnMbFrgIZldUPS/M1+2LtHQP8D81iOEZftT
	m2/7PpGEipyRMNKhwJGN1uap46tbzFxwlHJiBg0RtWkxpHlbJlUDaqwWk12S/mGxsCGcwwI+ZM1
	dx23jjMPcAN4ZhFz4Gt1pQacE/0yoNsjxQhQTmh1GEsRGsJAH/dgqYEJrW0HppAEenl2lC6Orb6
	Z6eDRSFe6r3O1c0/6/zy/SkSXn5L8AuFe+oXxE13SYOqcq7zkTwnsKUvvMFxTWCb5wHqFYB8Vli
	63V8+7XjVjERc4skcrO2ua8NTdg3Qvpm8HLSU80Xj8v2obDM7AltlTFyKi4yfnRekAA/XTaXYo3
	h/PpMqO4zlTl2tpSmFQ==
X-Received: by 2002:a05:600c:3006:b0:487:1108:48b8 with SMTP id
 5b1f17b1804b1-488fb739f86mr238087675e9.2.1777016085661; Fri, 24 Apr 2026
 00:34:45 -0700 (PDT)
Precedence: bulk
X-Mailing-List: syzbot@lists.linux.dev
List-Id: <syzbot.lists.linux.dev>
List-Subscribe: <mailto:syzbot+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:syzbot+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <69ea9513.a00a0220.9259.002d.GAE@google.com>
In-Reply-To: <69ea9513.a00a0220.9259.002d.GAE@google.com>
From: Pimyn Girgis <pimyn@google.com>
Date: Fri, 24 Apr 2026 09:34:34 +0200
X-Gm-Features: AQROBzCCrgKewyKOQEMQGgiB3TcKPO5-g1A-F0DSD57tjWOOndnoF8bE5iP2x3s
Message-ID: <CAJWNTGyPhS+pvhyKCikRzLF9HC9tF7Sxk6OxiSx3a=4E2ROm3g@mail.gmail.com>
Subject: Re: [moderation/CI] Re: mm/lruvec: preemptively free dead folios
 during lru_add drain
To: syzbot ci <syzbot+cif1732913c6ecf512@syzkaller.appspotmail.com>
Cc: syzkaller-upstream-moderation@googlegroups.com, syzbot@lists.linux.dev
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

#syz upstream

On Thu, Apr 23, 2026 at 11:54=E2=80=AFPM syzbot ci
<syzbot+cif1732913c6ecf512@syzkaller.appspotmail.com> wrote:
>
> syzbot ci has tested the following series
>
> [v1] mm/lruvec: preemptively free dead folios during lru_add drain
> https://lore.kernel.org/all/20260423164307.29805-1-jp.kobryn@linux.dev
> * [PATCH] mm/lruvec: preemptively free dead folios during lru_add drain
>
> and found the following issues:
> * BUG: Bad page state in do_pte_missing
> * BUG: Bad page state in do_wp_page
>
> Full report is available here:
> https://ci.syzbot.org/series/d16e663b-bcf5-49dd-937d-24a22e0c8d6a
>
> ***
>
> BUG: Bad page state in do_pte_missing
>
> tree:      mm-new
> URL:       https://kernel.googlesource.com/pub/scm/linux/kernel/git/akpm/=
mm.git
> base:      c9183ec6e2e3bd26a017392d6c3eaa40c580f153
> arch:      amd64
> compiler:  Debian clang version 21.1.8 (++20251221033036+2078da43e25a-1~e=
xp1~20251221153213.50), Debian LLD 21.1.8
> config:    https://ci.syzbot.org/builds/4d1a53f4-f506-4ba9-a8c2-a48196f95=
abc/config
> syz repro: https://ci.syzbot.org/findings/19ba977e-39f2-4f40-b936-a8642aa=
ab537/syz_repro
>
> BUG: Bad page state: 15292 messages suppressed
> BUG: Bad page state in process syz.2.1435  pfn:1af40e
> page: refcount:0 mapcount:0 mapping:0000000000000000 index:0x7f14c9e16 pf=
n:0x1af40e
> flags: 0x57ff00000020908(uptodate|active|owner_2|swapbacked|node=3D1|zone=
=3D2|lastcpupid=3D0x7ff)
> raw: 057ff00000020908 0000000000000000 dead000000000122 0000000000000000
> raw: 00000007f14c9e16 0000000000000000 00000000ffffffff 0000000000000000
> page dumped because: PAGE_FLAGS_CHECK_AT_FREE flag(s) set
> page_owner tracks the page as allocated
> page last allocated via order 0, migratetype Movable, gfp_mask 0x140dca(G=
FP_HIGHUSER_MOVABLE|__GFP_ZERO|__GFP_COMP), pid 8846, tgid 8846 (syz.0.1431=
), ts 86965635591, free_ts 69887114766
>  set_page_owner include/linux/page_owner.h:32 [inline]
>  post_alloc_hook+0x22d/0x280 mm/page_alloc.c:1858
>  prep_new_page mm/page_alloc.c:1866 [inline]
>  get_page_from_freelist+0x24ba/0x2540 mm/page_alloc.c:3946
>  __alloc_frozen_pages_noprof+0x18d/0x380 mm/page_alloc.c:5226
>  alloc_pages_mpol+0x235/0x490 mm/mempolicy.c:2490
>  folio_alloc_mpol_noprof+0x39/0x160 mm/mempolicy.c:2509
>  vma_alloc_folio_noprof+0xe1/0x1e0 mm/mempolicy.c:2544
>  folio_prealloc mm/memory.c:-1 [inline]
>  alloc_anon_folio mm/memory.c:5282 [inline]
>  do_anonymous_page mm/memory.c:5376 [inline]
>  do_pte_missing+0x159d/0x33f0 mm/memory.c:4548
>  handle_pte_fault mm/memory.c:6411 [inline]
>  __handle_mm_fault mm/memory.c:6549 [inline]
>  handle_mm_fault+0x1bd7/0x3170 mm/memory.c:6718
>  do_user_addr_fault+0xa73/0x1340 arch/x86/mm/fault.c:1334
>  handle_page_fault arch/x86/mm/fault.c:1474 [inline]
>  exc_page_fault+0x6a/0xc0 arch/x86/mm/fault.c:1527
>  asm_exc_page_fault+0x26/0x30 arch/x86/include/asm/idtentry.h:618
> page last free pid 5831 tgid 5831 stack trace:
>  reset_page_owner include/linux/page_owner.h:25 [inline]
>  __free_pages_prepare mm/page_alloc.c:1402 [inline]
>  free_unref_folios+0xcec/0x1480 mm/page_alloc.c:3004
>  folios_put_refs+0xa3d/0xb80 mm/swap.c:1042
>  free_pages_and_swap_cache+0x41d/0x490 mm/swap_state.c:404
>  __tlb_batch_free_encoded_pages mm/mmu_gather.c:138 [inline]
>  tlb_batch_pages_flush mm/mmu_gather.c:151 [inline]
>  tlb_flush_mmu_free mm/mmu_gather.c:417 [inline]
>  tlb_flush_mmu+0x6d3/0xa30 mm/mmu_gather.c:424
>  tlb_finish_mmu+0xf9/0x230 mm/mmu_gather.c:549
>  unmap_region+0x2a5/0x330 mm/vma.c:491
>  vms_clear_ptes mm/vma.c:1303 [inline]
>  vms_complete_munmap_vmas+0x493/0xc60 mm/vma.c:1345
>  do_vmi_align_munmap+0x3b7/0x4b0 mm/vma.c:1604
>  do_vmi_munmap+0x252/0x2d0 mm/vma.c:1652
>  __vm_munmap+0x22c/0x3d0 mm/vma.c:3285
>  __do_sys_munmap mm/mmap.c:1079 [inline]
>  __se_sys_munmap mm/mmap.c:1076 [inline]
>  __x64_sys_munmap+0x60/0x70 mm/mmap.c:1076
>  do_syscall_x64 arch/x86/entry/syscall_64.c:63 [inline]
>  do_syscall_64+0x15f/0xf80 arch/x86/entry/syscall_64.c:94
>  entry_SYSCALL_64_after_hwframe+0x77/0x7f
> Modules linked in:
> CPU: 1 UID: 0 PID: 8855 Comm: syz.2.1435 Tainted: G    B               sy=
zkaller #0 PREEMPT(full)
> Tainted: [B]=3DBAD_PAGE
> Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS 1.16.2-debian-1.=
16.2-1 04/01/2014
> Call Trace:
>  <TASK>
>  dump_stack_lvl+0xe8/0x150 lib/dump_stack.c:120
>  bad_page+0x17f/0x1c0 mm/page_alloc.c:632
>  free_page_is_bad mm/page_alloc.c:1073 [inline]
>  __free_pages_prepare mm/page_alloc.c:1393 [inline]
>  free_unref_folios+0xdcc/0x1480 mm/page_alloc.c:3004
>  folio_batch_move_lru+0x816/0x9e0 mm/swap.c:206
>  __folio_batch_add_and_move+0x510/0xc50 mm/swap.c:226
>  folio_add_lru_vma+0x196/0x210 mm/swap.c:566
>  map_anon_folio_pte_nopf+0x2ee/0x5e0 mm/memory.c:5301
>  map_anon_folio_pte_pf+0xbe/0x260 mm/memory.c:5311
>  do_anonymous_page mm/memory.c:5413 [inline]
>  do_pte_missing+0x2d48/0x33f0 mm/memory.c:4548
>  handle_pte_fault mm/memory.c:6411 [inline]
>  __handle_mm_fault mm/memory.c:6549 [inline]
>  handle_mm_fault+0x1bd7/0x3170 mm/memory.c:6718
>  do_user_addr_fault+0xa73/0x1340 arch/x86/mm/fault.c:1334
>  handle_page_fault arch/x86/mm/fault.c:1474 [inline]
>  exc_page_fault+0x6a/0xc0 arch/x86/mm/fault.c:1527
>  asm_exc_page_fault+0x26/0x30 arch/x86/include/asm/idtentry.h:618
> RIP: 0033:0x7fca082696d2
> Code: 48 89 ca 48 c1 e2 04 48 29 ca 48 8d 0d 5f c9 3a 00 48 c1 e2 04 48 0=
1 c2 8b 44 24 1c c6 42 20 01 89 42 24 8b 44 24 24 89 6a 28 <89> 42 78 0f b6=
 44 24 43 89 72 2c 88 44 19 04 8b 44 24 20 31 c9 89
> RSP: 002b:00007ffc5adb04c0 EFLAGS: 00010206
> RAX: 0000000000000000 RBX: 0000000000000000 RCX: 00007fca08616018
> RDX: 00007fca08615fa0 RSI: 0000000000000003 RDI: 0000000000000000
> RBP: 0000000000001cd6 R08: 00007fca08615fa0 R09: 00007ffc5adb0357
> R10: 0000000000000008 R11: 0000000000000246 R12: 0000000000000000
> R13: 00007fca08615fac R14: 00007fca08615fa8 R15: 00007fca08615fa0
>  </TASK>
> BUG: Bad page state in process syz.2.1435  pfn:1af40f
> page: refcount:0 mapcount:0 mapping:0000000000000000 index:0x7f14c9e17 pf=
n:0x1af40f
> flags: 0x57ff00000020908(uptodate|active|owner_2|swapbacked|node=3D1|zone=
=3D2|lastcpupid=3D0x7ff)
> raw: 057ff00000020908 0000000000000000 dead000000000122 0000000000000000
> raw: 00000007f14c9e17 0000000000000000 00000000ffffffff 0000000000000000
> page dumped because: PAGE_FLAGS_CHECK_AT_FREE flag(s) set
> page_owner tracks the page as allocated
> page last allocated via order 0, migratetype Movable, gfp_mask 0x140cca(G=
FP_HIGHUSER_MOVABLE|__GFP_COMP), pid 8846, tgid 8846 (syz.0.1431), ts 86965=
651367, free_ts 69887118923
>  set_page_owner include/linux/page_owner.h:32 [inline]
>  post_alloc_hook+0x22d/0x280 mm/page_alloc.c:1858
>  prep_new_page mm/page_alloc.c:1866 [inline]
>  get_page_from_freelist+0x24ba/0x2540 mm/page_alloc.c:3946
>  __alloc_frozen_pages_noprof+0x18d/0x380 mm/page_alloc.c:5226
>  alloc_pages_mpol+0x235/0x490 mm/mempolicy.c:2490
>  folio_alloc_mpol_noprof+0x39/0x160 mm/mempolicy.c:2509
>  vma_alloc_folio_noprof+0xe1/0x1e0 mm/mempolicy.c:2544
>  folio_prealloc mm/memory.c:-1 [inline]
>  wp_page_copy mm/memory.c:3859 [inline]
>  do_wp_page+0x118a/0x4cc0 mm/memory.c:4320
>  handle_pte_fault mm/memory.c:6427 [inline]
>  __handle_mm_fault mm/memory.c:6549 [inline]
>  handle_mm_fault+0x151d/0x3170 mm/memory.c:6718
>  do_user_addr_fault+0xa73/0x1340 arch/x86/mm/fault.c:1334
>  handle_page_fault arch/x86/mm/fault.c:1474 [inline]
>  exc_page_fault+0x6a/0xc0 arch/x86/mm/fault.c:1527
>  asm_exc_page_fault+0x26/0x30 arch/x86/include/asm/idtentry.h:618
> page last free pid 5831 tgid 5831 stack trace:
>  reset_page_owner include/linux/page_owner.h:25 [inline]
>  __free_pages_prepare mm/page_alloc.c:1402 [inline]
>  free_unref_folios+0xcec/0x1480 mm/page_alloc.c:3004
>  folios_put_refs+0xa3d/0xb80 mm/swap.c:1042
>  free_pages_and_swap_cache+0x41d/0x490 mm/swap_state.c:404
>  __tlb_batch_free_encoded_pages mm/mmu_gather.c:138 [inline]
>  tlb_batch_pages_flush mm/mmu_gather.c:151 [inline]
>  tlb_flush_mmu_free mm/mmu_gather.c:417 [inline]
>  tlb_flush_mmu+0x6d3/0xa30 mm/mmu_gather.c:424
>  tlb_finish_mmu+0xf9/0x230 mm/mmu_gather.c:549
>  unmap_region+0x2a5/0x330 mm/vma.c:491
>  vms_clear_ptes mm/vma.c:1303 [inline]
>  vms_complete_munmap_vmas+0x493/0xc60 mm/vma.c:1345
>  do_vmi_align_munmap+0x3b7/0x4b0 mm/vma.c:1604
>  do_vmi_munmap+0x252/0x2d0 mm/vma.c:1652
>  __vm_munmap+0x22c/0x3d0 mm/vma.c:3285
>  __do_sys_munmap mm/mmap.c:1079 [inline]
>  __se_sys_munmap mm/mmap.c:1076 [inline]
>  __x64_sys_munmap+0x60/0x70 mm/mmap.c:1076
>  do_syscall_x64 arch/x86/entry/syscall_64.c:63 [inline]
>  do_syscall_64+0x15f/0xf80 arch/x86/entry/syscall_64.c:94
>  entry_SYSCALL_64_after_hwframe+0x77/0x7f
> Modules linked in:
> CPU: 1 UID: 0 PID: 8855 Comm: syz.2.1435 Tainted: G    B               sy=
zkaller #0 PREEMPT(full)
> Tainted: [B]=3DBAD_PAGE
> Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS 1.16.2-debian-1.=
16.2-1 04/01/2014
> Call Trace:
>  <TASK>
>  dump_stack_lvl+0xe8/0x150 lib/dump_stack.c:120
>  bad_page+0x17f/0x1c0 mm/page_alloc.c:632
>  free_page_is_bad mm/page_alloc.c:1073 [inline]
>  __free_pages_prepare mm/page_alloc.c:1393 [inline]
>  free_unref_folios+0xdcc/0x1480 mm/page_alloc.c:3004
>  folio_batch_move_lru+0x816/0x9e0 mm/swap.c:206
>  __folio_batch_add_and_move+0x510/0xc50 mm/swap.c:226
>  folio_add_lru_vma+0x196/0x210 mm/swap.c:566
>  map_anon_folio_pte_nopf+0x2ee/0x5e0 mm/memory.c:5301
>  map_anon_folio_pte_pf+0xbe/0x260 mm/memory.c:5311
>  do_anonymous_page mm/memory.c:5413 [inline]
>  do_pte_missing+0x2d48/0x33f0 mm/memory.c:4548
>  handle_pte_fault mm/memory.c:6411 [inline]
>  __handle_mm_fault mm/memory.c:6549 [inline]
>  handle_mm_fault+0x1bd7/0x3170 mm/memory.c:6718
>  do_user_addr_fault+0xa73/0x1340 arch/x86/mm/fault.c:1334
>  handle_page_fault arch/x86/mm/fault.c:1474 [inline]
>  exc_page_fault+0x6a/0xc0 arch/x86/mm/fault.c:1527
>  asm_exc_page_fault+0x26/0x30 arch/x86/include/asm/idtentry.h:618
> RIP: 0033:0x7fca082696d2
> Code: 48 89 ca 48 c1 e2 04 48 29 ca 48 8d 0d 5f c9 3a 00 48 c1 e2 04 48 0=
1 c2 8b 44 24 1c c6 42 20 01 89 42 24 8b 44 24 24 89 6a 28 <89> 42 78 0f b6=
 44 24 43 89 72 2c 88 44 19 04 8b 44 24 20 31 c9 89
> RSP: 002b:00007ffc5adb04c0 EFLAGS: 00010206
> RAX: 0000000000000000 RBX: 0000000000000000 RCX: 00007fca08616018
> RDX: 00007fca08615fa0 RSI: 0000000000000003 RDI: 0000000000000000
> RBP: 0000000000001cd6 R08: 00007fca08615fa0 R09: 00007ffc5adb0357
> R10: 0000000000000008 R11: 0000000000000246 R12: 0000000000000000
> R13: 00007fca08615fac R14: 00007fca08615fa8 R15: 00007fca08615fa0
>  </TASK>
> BUG: Bad page state in process syz.2.1435  pfn:1af410
> page: refcount:0 mapcount:0 mapping:0000000000000000 index:0x7f14c91fd pf=
n:0x1af410
> flags: 0x57ff00000020908(uptodate|active|owner_2|swapbacked|node=3D1|zone=
=3D2|lastcpupid=3D0x7ff)
> raw: 057ff00000020908 0000000000000000 dead000000000122 0000000000000000
> raw: 00000007f14c91fd 0000000000000000 00000000ffffffff 0000000000000000
> page dumped because: PAGE_FLAGS_CHECK_AT_FREE flag(s) set
> page_owner tracks the page as allocated
> page last allocated via order 0, migratetype Movable, gfp_mask 0x140dca(G=
FP_HIGHUSER_MOVABLE|__GFP_ZERO|__GFP_COMP), pid 8849, tgid 8846 (syz.0.1431=
), ts 86965683544, free_ts 69887122392
>  set_page_owner include/linux/page_owner.h:32 [inline]
>  post_alloc_hook+0x22d/0x280 mm/page_alloc.c:1858
>  prep_new_page mm/page_alloc.c:1866 [inline]
>  get_page_from_freelist+0x24ba/0x2540 mm/page_alloc.c:3946
>  __alloc_frozen_pages_noprof+0x18d/0x380 mm/page_alloc.c:5226
>  alloc_pages_mpol+0x235/0x490 mm/mempolicy.c:2490
>  folio_alloc_mpol_noprof+0x39/0x160 mm/mempolicy.c:2509
>  vma_alloc_folio_noprof+0xe1/0x1e0 mm/mempolicy.c:2544
>  folio_prealloc mm/memory.c:-1 [inline]
>  alloc_anon_folio mm/memory.c:5282 [inline]
>  do_anonymous_page mm/memory.c:5376 [inline]
>  do_pte_missing+0x159d/0x33f0 mm/memory.c:4548
>  handle_pte_fault mm/memory.c:6411 [inline]
>  __handle_mm_fault mm/memory.c:6549 [inline]
>  handle_mm_fault+0x1bd7/0x3170 mm/memory.c:6718
>  do_user_addr_fault+0xa73/0x1340 arch/x86/mm/fault.c:1334
>  handle_page_fault arch/x86/mm/fault.c:1474 [inline]
>  exc_page_fault+0x6a/0xc0 arch/x86/mm/fault.c:1527
>  asm_exc_page_fault+0x26/0x30 arch/x86/include/asm/idtentry.h:618
> page last free pid 5831 tgid 5831 stack trace:
>  reset_page_owner include/linux/page_owner.h:25 [inline]
>  __free_pages_prepare mm/page_alloc.c:1402 [inline]
>  free_unref_folios+0xcec/0x1480 mm/page_alloc.c:3004
>  folios_put_refs+0xa3d/0xb80 mm/swap.c:1042
>  free_pages_and_swap_cache+0x41d/0x490 mm/swap_state.c:404
>  __tlb_batch_free_encoded_pages mm/mmu_gather.c:138 [inline]
>  tlb_batch_pages_flush mm/mmu_gather.c:151 [inline]
>  tlb_flush_mmu_free mm/mmu_gather.c:417 [inline]
>  tlb_flush_mmu+0x6d3/0xa30 mm/mmu_gather.c:424
>  tlb_finish_mmu+0xf9/0x230 mm/mmu_gather.c:549
>  unmap_region+0x2a5/0x330 mm/vma.c:491
>  vms_clear_ptes mm/vma.c:1303 [inline]
>  vms_complete_munmap_vmas+0x493/0xc60 mm/vma.c:1345
>  do_vmi_align_munmap+0x3b7/0x4b0 mm/vma.c:1604
>  do_vmi_munmap+0x252/0x2d0 mm/vma.c:1652
>  __vm_munmap+0x22c/0x3d0 mm/vma.c:3285
>  __do_sys_munmap mm/mmap.c:1079 [inline]
>  __se_sys_munmap mm/mmap.c:1076 [inline]
>  __x64_sys_munmap+0x60/0x70 mm/mmap.c:1076
>  do_syscall_x64 arch/x86/entry/syscall_64.c:63 [inline]
>  do_syscall_64+0x15f/0xf80 arch/x86/entry/syscall_64.c:94
>  entry_SYSCALL_64_after_hwframe+0x77/0x7f
> Modules linked in:
> CPU: 1 UID: 0 PID: 8855 Comm: syz.2.1435 Tainted: G    B               sy=
zkaller #0 PREEMPT(full)
> Tainted: [B]=3DBAD_PAGE
> Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS 1.16.2-debian-1.=
16.2-1 04/01/2014
> Call Trace:
>  <TASK>
>  dump_stack_lvl+0xe8/0x150 lib/dump_stack.c:120
>  bad_page+0x17f/0x1c0 mm/page_alloc.c:632
>  free_page_is_bad mm/page_alloc.c:1073 [inline]
>  __free_pages_prepare mm/page_alloc.c:1393 [inline]
>  free_unref_folios+0xdcc/0x1480 mm/page_alloc.c:3004
>  folio_batch_move_lru+0x816/0x9e0 mm/swap.c:206
>  __folio_batch_add_and_move+0x510/0xc50 mm/swap.c:226
>  folio_add_lru_vma+0x196/0x210 mm/swap.c:566
>  map_anon_folio_pte_nopf+0x2ee/0x5e0 mm/memory.c:5301
>  map_anon_folio_pte_pf+0xbe/0x260 mm/memory.c:5311
>  do_anonymous_page mm/memory.c:5413 [inline]
>  do_pte_missing+0x2d48/0x33f0 mm/memory.c:4548
>  handle_pte_fault mm/memory.c:6411 [inline]
>  __handle_mm_fault mm/memory.c:6549 [inline]
>  handle_mm_fault+0x1bd7/0x3170 mm/memory.c:6718
>  do_user_addr_fault+0xa73/0x1340 arch/x86/mm/fault.c:1334
>  handle_page_fault arch/x86/mm/fault.c:1474 [inline]
>  exc_page_fault+0x6a/0xc0 arch/x86/mm/fault.c:1527
>  asm_exc_page_fault+0x26/0x30 arch/x86/include/asm/idtentry.h:618
> RIP: 0033:0x7fca082696d2
> Code: 48 89 ca 48 c1 e2 04 48 29 ca 48 8d 0d 5f c9 3a 00 48 c1 e2 04 48 0=
1 c2 8b 44 24 1c c6 42 20 01 89 42 24 8b 44 24 24 89 6a 28 <89> 42 78 0f b6=
 44 24 43 89 72 2c 88 44 19 04 8b 44 24 20 31 c9 89
> RSP: 002b:00007ffc5adb04c0 EFLAGS: 00010206
> RAX: 0000000000000000 RBX: 0000000000000000 RCX: 00007fca08616018
> RDX: 00007fca08615fa0 RSI: 0000000000000003 RDI: 0000000000000000
> RBP: 0000000000001cd6 R08: 00007fca08615fa0 R09: 00007ffc5adb0357
> R10: 0000000000000008 R11: 0000000000000246 R12: 0000000000000000
> R13: 00007fca08615fac R14: 00007fca08615fa8 R15: 00007fca08615fa0
>  </TASK>
> BUG: Bad page state in process syz.2.1435  pfn:1af411
> page: refcount:0 mapcount:0 mapping:0000000000000000 index:0x7f14c9e12 pf=
n:0x1af411
> flags: 0x57ff00000020908(uptodate|active|owner_2|swapbacked|node=3D1|zone=
=3D2|lastcpupid=3D0x7ff)
> raw: 057ff00000020908 0000000000000000 dead000000000122 0000000000000000
> raw: 00000007f14c9e12 0000000000000000 00000000ffffffff 0000000000000000
> page dumped because: PAGE_FLAGS_CHECK_AT_FREE flag(s) set
> page_owner tracks the page as allocated
> page last allocated via order 0, migratetype Movable, gfp_mask 0x140cca(G=
FP_HIGHUSER_MOVABLE|__GFP_COMP), pid 8846, tgid 8846 (syz.0.1431), ts 86965=
789200, free_ts 69887126279
>  set_page_owner include/linux/page_owner.h:32 [inline]
>  post_alloc_hook+0x22d/0x280 mm/page_alloc.c:1858
>  prep_new_page mm/page_alloc.c:1866 [inline]
>  get_page_from_freelist+0x24ba/0x2540 mm/page_alloc.c:3946
>  __alloc_frozen_pages_noprof+0x18d/0x380 mm/page_alloc.c:5226
>  alloc_pages_mpol+0x235/0x490 mm/mempolicy.c:2490
>  folio_alloc_mpol_noprof+0x39/0x160 mm/mempolicy.c:2509
>  vma_alloc_folio_noprof+0xe1/0x1e0 mm/mempolicy.c:2544
>  folio_prealloc mm/memory.c:-1 [inline]
>  wp_page_copy mm/memory.c:3859 [inline]
>  do_wp_page+0x118a/0x4cc0 mm/memory.c:4320
>  handle_pte_fault mm/memory.c:6427 [inline]
>  __handle_mm_fault mm/memory.c:6549 [inline]
>  handle_mm_fault+0x151d/0x3170 mm/memory.c:6718
>  do_user_addr_fault+0xa73/0x1340 arch/x86/mm/fault.c:1334
>  handle_page_fault arch/x86/mm/fault.c:1474 [inline]
>  exc_page_fault+0x6a/0xc0 arch/x86/mm/fault.c:1527
>  asm_exc_page_fault+0x26/0x30 arch/x86/include/asm/idtentry.h:618
> page last free pid 5831 tgid 5831 stack trace:
>  reset_page_owner include/linux/page_owner.h:25 [inline]
>  __free_pages_prepare mm/page_alloc.c:1402 [inline]
>  free_unref_folios+0xcec/0x1480 mm/page_alloc.c:3004
>  folios_put_refs+0xa3d/0xb80 mm/swap.c:1042
>  free_pages_and_swap_cache+0x41d/0x490 mm/swap_state.c:404
>  __tlb_batch_free_encoded_pages mm/mmu_gather.c:138 [inline]
>  tlb_batch_pages_flush mm/mmu_gather.c:151 [inline]
>  tlb_flush_mmu_free mm/mmu_gather.c:417 [inline]
>  tlb_flush_mmu+0x6d3/0xa30 mm/mmu_gather.c:424
>  tlb_finish_mmu+0xf9/0x230 mm/mmu_gather.c:549
>  unmap_region+0x2a5/0x330 mm/vma.c:491
>  vms_clear_ptes mm/vma.c:1303 [inline]
>  vms_complete_munmap_vmas+0x493/0xc60 mm/vma.c:1345
>  do_vmi_align_munmap+0x3b7/0x4b0 mm/vma.c:1604
>  do_vmi_munmap+0x252/0x2d0 mm/vma.c:1652
>  __vm_munmap+0x22c/0x3d0 mm/vma.c:3285
>  __do_sys_munmap mm/mmap.c:1079 [inline]
>  __se_sys_munmap mm/mmap.c:1076 [inline]
>  __x64_sys_munmap+0x60/0x70 mm/mmap.c:1076
>  do_syscall_x64 arch/x86/entry/syscall_64.c:63 [inline]
>  do_syscall_64+0x15f/0xf80 arch/x86/entry/syscall_64.c:94
>  entry_SYSCALL_64_after_hwframe+0x77/0x7f
> Modules linked in:
> CPU: 1 UID: 0 PID: 8855 Comm: syz.2.1435 Tainted: G    B               sy=
zkaller #0 PREEMPT(full)
> Tainted: [B]=3DBAD_PAGE
> Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS 1.16.2-debian-1.=
16.2-1 04/01/2014
> Call Trace:
>  <TASK>
>  dump_stack_lvl+0xe8/0x150 lib/dump_stack.c:120
>  bad_page+0x17f/0x1c0 mm/page_alloc.c:632
>  free_page_is_bad mm/page_alloc.c:1073 [inline]
>  __free_pages_prepare mm/page_alloc.c:1393 [inline]
>  free_unref_folios+0xdcc/0x1480 mm/page_alloc.c:3004
>  folio_batch_move_lru+0x816/0x9e0 mm/swap.c:206
>  __folio_batch_add_and_move+0x510/0xc50 mm/swap.c:226
>  folio_add_lru_vma+0x196/0x210 mm/swap.c:566
>  map_anon_folio_pte_nopf+0x2ee/0x5e0 mm/memory.c:5301
>  map_anon_folio_pte_pf+0xbe/0x260 mm/memory.c:5311
>  do_anonymous_page mm/memory.c:5413 [inline]
>  do_pte_missing+0x2d48/0x33f0 mm/memory.c:4548
>  handle_pte_fault mm/memory.c:6411 [inline]
>  __handle_mm_fault mm/memory.c:6549 [inline]
>  handle_mm_fault+0x1bd7/0x3170 mm/memory.c:6718
>  do_user_addr_fault+0xa73/0x1340 arch/x86/mm/fault.c:1334
>  handle_page_fault arch/x86/mm/fault.c:1474 [inline]
>  exc_page_fault+0x6a/0xc0 arch/x86/mm/fault.c:1527
>  asm_exc_page_fault+0x26/0x30 arch/x86/include/asm/idtentry.h:618
> RIP: 0033:0x7fca082696d2
> Code: 48 89 ca 48 c1 e2 04 48 29 ca 48 8d 0d 5f c9 3a 00 48 c1 e2 04 48 0=
1 c2 8b 44 24 1c c6 42 20 01 89 42 24 8b 44 24 24 89 6a 28 <89> 42 78 0f b6=
 44 24 43 89 72 2c 88 44 19 04 8b 44 24 20 31 c9 89
> RSP: 002b:00007ffc5adb04c0 EFLAGS: 00010206
> RAX: 0000000000000000 RBX: 0000000000000000 RCX: 00007fca08616018
> RDX: 00007fca08615fa0 RSI: 0000000000000003 RDI: 0000000000000000
> RBP: 0000000000001cd6 R08: 00007fca08615fa0 R09: 00007ffc5adb0357
> R10: 0000000000000008 R11: 0000000000000246 R12: 0000000000000000
> R13: 00007fca08615fac R14: 00007fca08615fa8 R15: 00007fca08615fa0
>  </TASK>
> BUG: Bad page state in process syz.2.1435  pfn:1af40b
> page: refcount:0 mapcount:0 mapping:0000000000000000 index:0x555573b0d pf=
n:0x1af40b
> flags: 0x57ff0000002090c(referenced|uptodate|active|owner_2|swapbacked|no=
de=3D1|zone=3D2|lastcpupid=3D0x7ff)
> raw: 057ff0000002090c 0000000000000000 dead000000000122 0000000000000000
> raw: 0000000555573b0d 0000000000000000 00000000ffffffff 0000000000000000
> page dumped because: PAGE_FLAGS_CHECK_AT_FREE flag(s) set
> page_owner tracks the page as allocated
> page last allocated via order 0, migratetype Movable, gfp_mask 0x140cca(G=
FP_HIGHUSER_MOVABLE|__GFP_COMP), pid 8851, tgid 8851 (syz-executor), ts 869=
75719417, free_ts 86967133373
>  set_page_owner include/linux/page_owner.h:32 [inline]
>  post_alloc_hook+0x22d/0x280 mm/page_alloc.c:1858
>  prep_new_page mm/page_alloc.c:1866 [inline]
>  get_page_from_freelist+0x24ba/0x2540 mm/page_alloc.c:3946
>  __alloc_frozen_pages_noprof+0x18d/0x380 mm/page_alloc.c:5226
>  alloc_pages_mpol+0x235/0x490 mm/mempolicy.c:2490
>  folio_alloc_mpol_noprof+0x39/0x160 mm/mempolicy.c:2509
>  vma_alloc_folio_noprof+0xe1/0x1e0 mm/mempolicy.c:2544
>  folio_prealloc mm/memory.c:-1 [inline]
>  wp_page_copy mm/memory.c:3859 [inline]
>  do_wp_page+0x118a/0x4cc0 mm/memory.c:4320
>  handle_pte_fault mm/memory.c:6427 [inline]
>  __handle_mm_fault mm/memory.c:6549 [inline]
>  handle_mm_fault+0x151d/0x3170 mm/memory.c:6718
>  do_user_addr_fault+0x75b/0x1340 arch/x86/mm/fault.c:1385
>  handle_page_fault arch/x86/mm/fault.c:1474 [inline]
>  exc_page_fault+0x6a/0xc0 arch/x86/mm/fault.c:1527
>  asm_exc_page_fault+0x26/0x30 arch/x86/include/asm/idtentry.h:618
> page last free pid 8849 tgid 8846 stack trace:
>  reset_page_owner include/linux/page_owner.h:25 [inline]
>  __free_pages_prepare mm/page_alloc.c:1402 [inline]
>  free_unref_folios+0xcec/0x1480 mm/page_alloc.c:3004
>  folios_put_refs+0xa3d/0xb80 mm/swap.c:1042
>  free_pages_and_swap_cache+0x41d/0x490 mm/swap_state.c:404
>  __tlb_batch_free_encoded_pages mm/mmu_gather.c:138 [inline]
>  tlb_batch_pages_flush mm/mmu_gather.c:151 [inline]
>  tlb_flush_mmu_free mm/mmu_gather.c:417 [inline]
>  tlb_flush_mmu+0x6d3/0xa30 mm/mmu_gather.c:424
>  tlb_finish_mmu+0xf9/0x230 mm/mmu_gather.c:549
>  exit_mmap+0x498/0x9e0 mm/mmap.c:1313
>  __mmput+0x118/0x430 kernel/fork.c:1178
>  exit_mm+0x18e/0x250 kernel/exit.c:581
>  do_exit+0x6a2/0x22c0 kernel/exit.c:963
>  do_group_exit+0x21b/0x2d0 kernel/exit.c:1117
>  get_signal+0x1284/0x1330 kernel/signal.c:3037
>  arch_do_signal_or_restart+0xbc/0x830 arch/x86/kernel/signal.c:337
>  __exit_to_user_mode_loop kernel/entry/common.c:64 [inline]
>  exit_to_user_mode_loop+0x86/0x480 kernel/entry/common.c:98
>  __exit_to_user_mode_prepare include/linux/irq-entry-common.h:207 [inline=
]
>  syscall_exit_to_user_mode_prepare include/linux/irq-entry-common.h:238 [=
inline]
>  syscall_exit_to_user_mode include/linux/entry-common.h:328 [inline]
>  do_syscall_64+0x33e/0xf80 arch/x86/entry/syscall_64.c:100
>  entry_SYSCALL_64_after_hwframe+0x77/0x7f
> Modules linked in:
>
> CPU: 1 UID: 0 PID: 8855 Comm: syz.2.1435 Tainted: G    B               sy=
zkaller #0 PREEMPT(full)
> Tainted: [B]=3DBAD_PAGE
> Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS 1.16.2-debian-1.=
16.2-1 04/01/2014
> Call Trace:
>  <TASK>
>  dump_stack_lvl+0xe8/0x150 lib/dump_stack.c:120
>  bad_page+0x17f/0x1c0 mm/page_alloc.c:632
>  free_page_is_bad mm/page_alloc.c:1073 [inline]
>  __free_pages_prepare mm/page_alloc.c:1393 [inline]
>  free_unref_folios+0xdcc/0x1480 mm/page_alloc.c:3004
>  folio_batch_move_lru+0x816/0x9e0 mm/swap.c:206
>  __folio_batch_add_and_move+0x510/0xc50 mm/swap.c:226
>  folio_add_lru_vma+0x196/0x210 mm/swap.c:566
>  map_anon_folio_pte_nopf+0x2ee/0x5e0 mm/memory.c:5301
>  map_anon_folio_pte_pf+0xbe/0x260 mm/memory.c:5311
>  do_anonymous_page mm/memory.c:5413 [inline]
>  do_pte_missing+0x2d48/0x33f0 mm/memory.c:4548
>  handle_pte_fault mm/memory.c:6411 [inline]
>  __handle_mm_fault mm/memory.c:6549 [inline]
>  handle_mm_fault+0x1bd7/0x3170 mm/memory.c:6718
>  do_user_addr_fault+0xa73/0x1340 arch/x86/mm/fault.c:1334
>  handle_page_fault arch/x86/mm/fault.c:1474 [inline]
>  exc_page_fault+0x6a/0xc0 arch/x86/mm/fault.c:1527
>  asm_exc_page_fault+0x26/0x30 arch/x86/include/asm/idtentry.h:618
> RIP: 0033:0x7fca082696d2
> Code: 48 89 ca 48 c1 e2 04 48 29 ca 48 8d 0d 5f c9 3a 00 48 c1 e2 04 48 0=
1 c2 8b 44 24 1c c6 42 20 01 89 42 24 8b 44 24 24 89 6a 28 <89> 42 78 0f b6=
 44 24 43 89 72 2c 88 44 19 04 8b 44 24 20 31 c9 89
> RSP: 002b:00007ffc5adb04c0 EFLAGS: 00010206
> RAX: 0000000000000000 RBX: 0000000000000000 RCX: 00007fca08616018
> RDX: 00007fca08615fa0 RSI: 0000000000000003 RDI: 0000000000000000
> RBP: 0000000000001cd6 R08: 00007fca08615fa0 R09: 00007ffc5adb0357
> R10: 0000000000000008 R11: 0000000000000246 R12: 0000000000000000
> R13: 00007fca08615fac R14: 00007fca08615fa8 R15: 00007fca08615fa0
>  </TASK>
> BUG: Bad page state in process syz.2.1435  pfn:1af409
> page: refcount:0 mapcount:0 mapping:0000000000000000 index:0x3ec pfn:0x1a=
f409
> flags: 0x57ff00000020908(uptodate|active|owner_2|swapbacked|node=3D1|zone=
=3D2|lastcpupid=3D0x7ff)
> raw: 057ff00000020908 0000000000000000 dead000000000122 0000000000000000
> raw: 00000000000003ec 0000000000000000 00000000ffffffff 0000000000000000
> page dumped because: PAGE_FLAGS_CHECK_AT_FREE flag(s) set
> page_owner tracks the page as allocated
> page last allocated via order 0, migratetype Movable, gfp_mask 0x140cca(G=
FP_HIGHUSER_MOVABLE|__GFP_COMP), pid 8851, tgid 8851 (syz-executor), ts 869=
76014509, free_ts 86967128194
>  set_page_owner include/linux/page_owner.h:32 [inline]
>  post_alloc_hook+0x22d/0x280 mm/page_alloc.c:1858
>  prep_new_page mm/page_alloc.c:1866 [inline]
>  get_page_from_freelist+0x24ba/0x2540 mm/page_alloc.c:3946
>  __alloc_frozen_pages_noprof+0x18d/0x380 mm/page_alloc.c:5226
>  alloc_pages_mpol+0x235/0x490 mm/mempolicy.c:2490
>  folio_alloc_mpol_noprof+0x39/0x160 mm/mempolicy.c:2509
>  vma_alloc_folio_noprof+0xe1/0x1e0 mm/mempolicy.c:2544
>  folio_prealloc mm/memory.c:-1 [inline]
>  wp_page_copy mm/memory.c:3859 [inline]
>  do_wp_page+0x118a/0x4cc0 mm/memory.c:4320
>  handle_pte_fault mm/memory.c:6427 [inline]
>  __handle_mm_fault mm/memory.c:6549 [inline]
>  handle_mm_fault+0x151d/0x3170 mm/memory.c:6718
>  do_user_addr_fault+0xa73/0x1340 arch/x86/mm/fault.c:1334
>  handle_page_fault arch/x86/mm/fault.c:1474 [inline]
>  exc_page_fault+0x6a/0xc0 arch/x86/mm/fault.c:1527
>  asm_exc_page_fault+0x26/0x30 arch/x86/include/asm/idtentry.h:618
> page last free pid 8849 tgid 8846 stack trace:
>  reset_page_owner include/linux/page_owner.h:25 [inline]
>  __free_pages_prepare mm/page_alloc.c:1402 [inline]
>  free_unref_folios+0xcec/0x1480 mm/page_alloc.c:3004
>  folios_put_refs+0xa3d/0xb80 mm/swap.c:1042
>  free_pages_and_swap_cache+0x41d/0x490 mm/swap_state.c:404
>  __tlb_batch_free_encoded_pages mm/mmu_gather.c:138 [inline]
>  tlb_batch_pages_flush mm/mmu_gather.c:151 [inline]
>  tlb_flush_mmu_free mm/mmu_gather.c:417 [inline]
>  tlb_flush_mmu+0x6d3/0xa30 mm/mmu_gather.c:424
>  tlb_finish_mmu+0xf9/0x230 mm/mmu_gather.c:549
>  exit_mmap+0x498/0x9e0 mm/mmap.c:1313
>  __mmput+0x118/0x430 kernel/fork.c:1178
>  exit_mm+0x18e/0x250 kernel/exit.c:581
>  do_exit+0x6a2/0x22c0 kernel/exit.c:963
>  do_group_exit+0x21b/0x2d0 kernel/exit.c:1117
>  get_signal+0x1284/0x1330 kernel/signal.c:3037
>  arch_do_signal_or_restart+0xbc/0x830 arch/x86/kernel/signal.c:337
>  __exit_to_user_mode_loop kernel/entry/common.c:64 [inline]
>  exit_to_user_mode_loop+0x86/0x480 kernel/entry/common.c:98
>  __exit_to_user_mode_prepare include/linux/irq-entry-common.h:207 [inline=
]
>  syscall_exit_to_user_mode_prepare include/linux/irq-entry-common.h:238 [=
inline]
>  syscall_exit_to_user_mode include/linux/entry-common.h:328 [inline]
>  do_syscall_64+0x33e/0xf80 arch/x86/entry/syscall_64.c:100
>  entry_SYSCALL_64_after_hwframe+0x77/0x7f
> Modules linked in:
>
> CPU: 1 UID: 0 PID: 8855 Comm: syz.2.1435 Tainted: G    B               sy=
zkaller #0 PREEMPT(full)
> Tainted: [B]=3DBAD_PAGE
> Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS 1.16.2-debian-1.=
16.2-1 04/01/2014
> Call Trace:
>  <TASK>
>  dump_stack_lvl+0xe8/0x150 lib/dump_stack.c:120
>  bad_page+0x17f/0x1c0 mm/page_alloc.c:632
>  free_page_is_bad mm/page_alloc.c:1073 [inline]
>  __free_pages_prepare mm/page_alloc.c:1393 [inline]
>  free_unref_folios+0xdcc/0x1480 mm/page_alloc.c:3004
>  folio_batch_move_lru+0x816/0x9e0 mm/swap.c:206
>  __folio_batch_add_and_move+0x510/0xc50 mm/swap.c:226
>  folio_add_lru_vma+0x196/0x210 mm/swap.c:566
>  map_anon_folio_pte_nopf+0x2ee/0x5e0 mm/memory.c:5301
>  map_anon_folio_pte_pf+0xbe/0x260 mm/memory.c:5311
>  do_anonymous_page mm/memory.c:5413 [inline]
>  do_pte_missing+0x2d48/0x33f0 mm/memory.c:4548
>  handle_pte_fault mm/memory.c:6411 [inline]
>  __handle_mm_fault mm/memory.c:6549 [inline]
>  handle_mm_fault+0x1bd7/0x3170 mm/memory.c:6718
>  do_user_addr_fault+0xa73/0x1340 arch/x86/mm/fault.c:1334
>  handle_page_fault arch/x86/mm/fault.c:1474 [inline]
>  exc_page_fault+0x6a/0xc0 arch/x86/mm/fault.c:1527
>  asm_exc_page_fault+0x26/0x30 arch/x86/include/asm/idtentry.h:618
> RIP: 0033:0x7fca082696d2
> Code: 48 89 ca 48 c1 e2 04 48 29 ca 48 8d 0d 5f c9 3a 00 48 c1 e2 04 48 0=
1 c2 8b 44 24 1c c6 42 20 01 89 42 24 8b 44 24 24 89 6a 28 <89> 42 78 0f b6=
 44 24 43 89 72 2c 88 44 19 04 8b 44 24 20 31 c9 89
> RSP: 002b:00007ffc5adb04c0 EFLAGS: 00010206
> RAX: 0000000000000000 RBX: 0000000000000000 RCX: 00007fca08616018
> RDX: 00007fca08615fa0 RSI: 0000000000000003 RDI: 0000000000000000
> RBP: 0000000000001cd6 R08: 00007fca08615fa0 R09: 00007ffc5adb0357
> R10: 0000000000000008 R11: 0000000000000246 R12: 0000000000000000
> R13: 00007fca08615fac R14: 00007fca08615fa8 R15: 00007fca08615fa0
>  </TASK>
> BUG: Bad page state in process syz.2.1435  pfn:1af571
> page: refcount:0 mapcount:0 mapping:0000000000000000 index:0x7f14ca945 pf=
n:0x1af571
> flags: 0x57ff00000020908(uptodate|active|owner_2|swapbacked|node=3D1|zone=
=3D2|lastcpupid=3D0x7ff)
> raw: 057ff00000020908 0000000000000000 dead000000000122 0000000000000000
> raw: 00000007f14ca945 0000000000000000 00000000ffffffff 0000000000000000
> page dumped because: PAGE_FLAGS_CHECK_AT_FREE flag(s) set
> page_owner tracks the page as allocated
> page last allocated via order 0, migratetype Movable, gfp_mask 0x140cca(G=
FP_HIGHUSER_MOVABLE|__GFP_COMP), pid 8851, tgid 8851 (syz-executor), ts 869=
78306736, free_ts 86967122819
>  set_page_owner include/linux/page_owner.h:32 [inline]
>  post_alloc_hook+0x22d/0x280 mm/page_alloc.c:1858
>  prep_new_page mm/page_alloc.c:1866 [inline]
>  get_page_from_freelist+0x24ba/0x2540 mm/page_alloc.c:3946
>  __alloc_frozen_pages_noprof+0x18d/0x380 mm/page_alloc.c:5226
>  alloc_pages_mpol+0x235/0x490 mm/mempolicy.c:2490
>  folio_alloc_mpol_noprof+0x39/0x160 mm/mempolicy.c:2509
>  vma_alloc_folio_noprof+0xe1/0x1e0 mm/mempolicy.c:2544
>  folio_prealloc mm/memory.c:-1 [inline]
>  wp_page_copy mm/memory.c:3859 [inline]
>  do_wp_page+0x118a/0x4cc0 mm/memory.c:4320
>  handle_pte_fault mm/memory.c:6427 [inline]
>  __handle_mm_fault mm/memory.c:6549 [inline]
>  handle_mm_fault+0x151d/0x3170 mm/memory.c:6718
>  do_user_addr_fault+0xa73/0x1340 arch/x86/mm/fault.c:1334
>  handle_page_fault arch/x86/mm/fault.c:1474 [inline]
>  exc_page_fault+0x6a/0xc0 arch/x86/mm/fault.c:1527
>  asm_exc_page_fault+0x26/0x30 arch/x86/include/asm/idtentry.h:618
> page last free pid 8849 tgid 8846 stack trace:
>  reset_page_owner include/linux/page_owner.h:25 [inline]
>  __free_pages_prepare mm/page_alloc.c:1402 [inline]
>  free_unref_folios+0xcec/0x1480 mm/page_alloc.c:3004
>  folios_put_refs+0xa3d/0xb80 mm/swap.c:1042
>  free_pages_and_swap_cache+0x41d/0x490 mm/swap_state.c:404
>  __tlb_batch_free_encoded_pages mm/mmu_gather.c:138 [inline]
>  tlb_batch_pages_flush mm/mmu_gather.c:151 [inline]
>  tlb_flush_mmu_free mm/mmu_gather.c:417 [inline]
>  tlb_flush_mmu+0x6d3/0xa30 mm/mmu_gather.c:424
>  tlb_finish_mmu+0xf9/0x230 mm/mmu_gather.c:549
>  exit_mmap+0x498/0x9e0 mm/mmap.c:1313
>  __mmput+0x118/0x430 kernel/fork.c:1178
>  exit_mm+0x18e/0x250 kernel/exit.c:581
>  do_exit+0x6a2/0x22c0 kernel/exit.c:963
>  do_group_exit+0x21b/0x2d0 kernel/exit.c:1117
>  get_signal+0x1284/0x1330 kernel/signal.c:3037
>  arch_do_signal_or_restart+0xbc/0x830 arch/x86/kernel/signal.c:337
>  __exit_to_user_mode_loop kernel/entry/common.c:64 [inline]
>  exit_to_user_mode_loop+0x86/0x480 kernel/entry/common.c:98
>  __exit_to_user_mode_prepare include/linux/irq-entry-common.h:207 [inline=
]
>  syscall_exit_to_user_mode_prepare include/linux/irq-entry-common.h:238 [=
inline]
>  syscall_exit_to_user_mode include/linux/entry-common.h:328 [inline]
>  do_syscall_64+0x33e/0xf80 arch/x86/entry/syscall_64.c:100
>  entry_SYSCALL_64_after_hwframe+0x77/0x7f
> Modules linked in:
>
> CPU: 1 UID: 0 PID: 8855 Comm: syz.2.1435 Tainted: G    B               sy=
zkaller #0 PREEMPT(full)
> Tainted: [B]=3DBAD_PAGE
> Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS 1.16.2-debian-1.=
16.2-1 04/01/2014
> Call Trace:
>  <TASK>
>  dump_stack_lvl+0xe8/0x150 lib/dump_stack.c:120
>  bad_page+0x17f/0x1c0 mm/page_alloc.c:632
>  free_page_is_bad mm/page_alloc.c:1073 [inline]
>  __free_pages_prepare mm/page_alloc.c:1393 [inline]
>  free_unref_folios+0xdcc/0x1480 mm/page_alloc.c:3004
>  folio_batch_move_lru+0x816/0x9e0 mm/swap.c:206
>  __folio_batch_add_and_move+0x510/0xc50 mm/swap.c:226
>  folio_add_lru_vma+0x196/0x210 mm/swap.c:566
>  map_anon_folio_pte_nopf+0x2ee/0x5e0 mm/memory.c:5301
>  map_anon_folio_pte_pf+0xbe/0x260 mm/memory.c:5311
>  do_anonymous_page mm/memory.c:5413 [inline]
>  do_pte_missing+0x2d48/0x33f0 mm/memory.c:4548
>  handle_pte_fault mm/memory.c:6411 [inline]
>  __handle_mm_fault mm/memory.c:6549 [inline]
>  handle_mm_fault+0x1bd7/0x3170 mm/memory.c:6718
>  do_user_addr_fault+0xa73/0x1340 arch/x86/mm/fault.c:1334
>  handle_page_fault arch/x86/mm/fault.c:1474 [inline]
>  exc_page_fault+0x6a/0xc0 arch/x86/mm/fault.c:1527
>  asm_exc_page_fault+0x26/0x30 arch/x86/include/asm/idtentry.h:618
> RIP: 0033:0x7fca082696d2
> Code: 48 89 ca 48 c1 e2 04 48 29 ca 48 8d 0d 5f c9 3a 00 48 c1 e2 04 48 0=
1 c2 8b 44 24 1c c6 42 20 01 89 42 24 8b 44 24 24 89 6a 28 <89> 42 78 0f b6=
 44 24 43 89 72 2c 88 44 19 04 8b 44 24 20 31 c9 89
> RSP: 002b:00007ffc5adb04c0 EFLAGS: 00010206
> RAX: 0000000000000000 RBX: 0000000000000000 RCX: 00007fca08616018
> RDX: 00007fca08615fa0 RSI: 0000000000000003 RDI: 0000000000000000
> RBP: 0000000000001cd6 R08: 00007fca08615fa0 R09: 00007ffc5adb0357
> R10: 0000000000000008 R11: 0000000000000246 R12: 0000000000000000
> R13: 00007fca08615fac R14: 00007fca08615fa8 R15: 00007fca08615fa0
>  </TASK>
> BUG: Bad page state in process syz.2.1435  pfn:1af40c
> page: refcount:0 mapcount:0 mapping:0000000000000000 index:0x7f14c9e15 pf=
n:0x1af40c
> flags: 0x57ff00000020908(uptodate|active|owner_2|swapbacked|node=3D1|zone=
=3D2|lastcpupid=3D0x7ff)
> raw: 057ff00000020908 0000000000000000 dead000000000122 0000000000000000
> raw: 00000007f14c9e15 0000000000000000 00000000ffffffff 0000000000000000
> page dumped because: PAGE_FLAGS_CHECK_AT_FREE flag(s) set
> page_owner tracks the page as allocated
> page last allocated via order 0, migratetype Movable, gfp_mask 0x140dca(G=
FP_HIGHUSER_MOVABLE|__GFP_ZERO|__GFP_COMP), pid 8851, tgid 8851 (syz.0.1434=
), ts 86978464147, free_ts 86967036690
>  set_page_owner include/linux/page_owner.h:32 [inline]
>  post_alloc_hook+0x22d/0x280 mm/page_alloc.c:1858
>  prep_new_page mm/page_alloc.c:1866 [inline]
>  get_page_from_freelist+0x24ba/0x2540 mm/page_alloc.c:3946
>  __alloc_frozen_pages_noprof+0x18d/0x380 mm/page_alloc.c:5226
>  alloc_pages_mpol+0x235/0x490 mm/mempolicy.c:2490
>  folio_alloc_mpol_noprof+0x39/0x160 mm/mempolicy.c:2509
>  vma_alloc_folio_noprof+0xe1/0x1e0 mm/mempolicy.c:2544
>  folio_prealloc mm/memory.c:-1 [inline]
>  wp_page_copy mm/memory.c:3859 [inline]
>  do_wp_page+0x118a/0x4cc0 mm/memory.c:4320
>  handle_pte_fault mm/memory.c:6427 [inline]
>  __handle_mm_fault mm/memory.c:6549 [inline]
>  handle_mm_fault+0x151d/0x3170 mm/memory.c:6718
>  do_user_addr_fault+0xa73/0x1340 arch/x86/mm/fault.c:1334
>  handle_page_fault arch/x86/mm/fault.c:1474 [inline]
>  exc_page_fault+0x6a/0xc0 arch/x86/mm/fault.c:1527
>  asm_exc_page_fault+0x26/0x30 arch/x86/include/asm/idtentry.h:618
> page last free pid 8849 tgid 8846 stack trace:
>  reset_page_owner include/linux/page_owner.h:25 [inline]
>  __free_pages_prepare mm/page_alloc.c:1402 [inline]
>  free_unref_folios+0xcec/0x1480 mm/page_alloc.c:3004
>  folios_put_refs+0xa3d/0xb80 mm/swap.c:1042
>  free_pages_and_swap_cache+0x41d/0x490 mm/swap_state.c:404
>  __tlb_batch_free_encoded_pages mm/mmu_gather.c:138 [inline]
>  tlb_batch_pages_flush mm/mmu_gather.c:151 [inline]
>  tlb_flush_mmu_free mm/mmu_gather.c:417 [inline]
>  tlb_flush_mmu+0x6d3/0xa30 mm/mmu_gather.c:424
>  tlb_finish_mmu+0xf9/0x230 mm/mmu_gather.c:549
>  exit_mmap+0x498/0x9e0 mm/mmap.c:1313
>  __mmput+0x118/0x430 kernel/fork.c:1178
>  exit_mm+0x18e/0x250 kernel/exit.c:581
>  do_exit+0x6a2/0x22c0 kernel/exit.c:963
>  do_group_exit+0x21b/0x2d0 kernel/exit.c:1117
>  get_signal+0x1284/0x1330 kernel/signal.c:3037
>  arch_do_signal_or_restart+0xbc/0x830 arch/x86/kernel/signal.c:337
>  __exit_to_user_mode_loop kernel/entry/common.c:64 [inline]
>  exit_to_user_mode_loop+0x86/0x480 kernel/entry/common.c:98
>  __exit_to_user_mode_prepare include/linux/irq-entry-common.h:207 [inline=
]
>  syscall_exit_to_user_mode_prepare include/linux/irq-entry-common.h:238 [=
inline]
>  syscall_exit_to_user_mode include/linux/entry-common.h:328 [inline]
>  do_syscall_64+0x33e/0xf80 arch/x86/entry/syscall_64.c:100
>  entry_SYSCALL_64_after_hwframe+0x77/0x7f
> Modules linked in:
> CPU: 1 UID: 0 PID: 8855 Comm: syz.2.1435 Tainted: G    B               sy=
zkaller #0 PREEMPT(full)
> Tainted: [B]=3DBAD_PAGE
> Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS 1.16.2-debian-1.=
16.2-1 04/01/2014
> Call Trace:
>  <TASK>
>  dump_stack_lvl+0xe8/0x150 lib/dump_stack.c:120
>  bad_page+0x17f/0x1c0 mm/page_alloc.c:632
>  free_page_is_bad mm/page_alloc.c:1073 [inline]
>  __free_pages_prepare mm/page_alloc.c:1393 [inline]
>  free_unref_folios+0xdcc/0x1480 mm/page_alloc.c:3004
>  folio_batch_move_lru+0x816/0x9e0 mm/swap.c:206
>  __folio_batch_add_and_move+0x510/0xc50 mm/swap.c:226
>  folio_add_lru_vma+0x196/0x210 mm/swap.c:566
>  map_anon_folio_pte_nopf+0x2ee/0x5e0 mm/memory.c:5301
>  map_anon_folio_pte_pf+0xbe/0x260 mm/memory.c:5311
>  do_anonymous_page mm/memory.c:5413 [inline]
>  do_pte_missing+0x2d48/0x33f0 mm/memory.c:4548
>  handle_pte_fault mm/memory.c:6411 [inline]
>  __handle_mm_fault mm/memory.c:6549 [inline]
>  handle_mm_fault+0x1bd7/0x3170 mm/memory.c:6718
>  do_user_addr_fault+0xa73/0x1340 arch/x86/mm/fault.c:1334
>  handle_page_fault arch/x86/mm/fault.c:1474 [inline]
>  exc_page_fault+0x6a/0xc0 arch/x86/mm/fault.c:1527
>  asm_exc_page_fault+0x26/0x30 arch/x86/include/asm/idtentry.h:618
> RIP: 0033:0x7fca082696d2
> Code: 48 89 ca 48 c1 e2 04 48 29 ca 48 8d 0d 5f c9 3a 00 48 c1 e2 04 48 0=
1 c2 8b 44 24 1c c6 42 20 01 89 42 24 8b 44 24 24 89 6a 28 <89> 42 78 0f b6=
 44 24 43 89 72 2c 88 44 19 04 8b 44 24 20 31 c9 89
> RSP: 002b:00007ffc5adb04c0 EFLAGS: 00010206
> RAX: 0000000000000000 RBX: 0000000000000000 RCX: 00007fca08616018
> RDX: 00007fca08615fa0 RSI: 0000000000000003 RDI: 0000000000000000
> RBP: 0000000000001cd6 R08: 00007fca08615fa0 R09: 00007ffc5adb0357
> R10: 0000000000000008 R11: 0000000000000246 R12: 0000000000000000
> R13: 00007fca08615fac R14: 00007fca08615fa8 R15: 00007fca08615fa0
>  </TASK>
> BUG: Bad page state in process syz.2.1435  pfn:1af40d
> page: refcount:0 mapcount:0 mapping:0000000000000000 index:0x7f14c91fe pf=
n:0x1af40d
> flags: 0x57ff00000020908(uptodate|active|owner_2|swapbacked|node=3D1|zone=
=3D2|lastcpupid=3D0x7ff)
> raw: 057ff00000020908 0000000000000000 dead000000000122 0000000000000000
> raw: 00000007f14c91fe 0000000000000000 00000000ffffffff 0000000000000000
> page dumped because: PAGE_FLAGS_CHECK_AT_FREE flag(s) set
> page_owner tracks the page as allocated
> page last allocated via order 0, migratetype Movable, gfp_mask 0x140dca(G=
FP_HIGHUSER_MOVABLE|__GFP_ZERO|__GFP_COMP), pid 8851, tgid 8851 (syz.0.1434=
), ts 86979644815, free_ts 86967032365
>  set_page_owner include/linux/page_owner.h:32 [inline]
>  post_alloc_hook+0x22d/0x280 mm/page_alloc.c:1858
>  prep_new_page mm/page_alloc.c:1866 [inline]
>  get_page_from_freelist+0x24ba/0x2540 mm/page_alloc.c:3946
>  __alloc_frozen_pages_noprof+0x18d/0x380 mm/page_alloc.c:5226
>  alloc_pages_mpol+0x235/0x490 mm/mempolicy.c:2490
>  folio_alloc_mpol_noprof+0x39/0x160 mm/mempolicy.c:2509
>  vma_alloc_folio_noprof+0xe1/0x1e0 mm/mempolicy.c:2544
>  folio_prealloc mm/memory.c:-1 [inline]
>  alloc_anon_folio mm/memory.c:5282 [inline]
>  do_anonymous_page mm/memory.c:5376 [inline]
>  do_pte_missing+0x159d/0x33f0 mm/memory.c:4548
>  handle_pte_fault mm/memory.c:6411 [inline]
>  __handle_mm_fault mm/memory.c:6549 [inline]
>  handle_mm_fault+0x1bd7/0x3170 mm/memory.c:6718
>  do_user_addr_fault+0xa73/0x1340 arch/x86/mm/fault.c:1334
>  handle_page_fault arch/x86/mm/fault.c:1474 [inline]
>  exc_page_fault+0x6a/0xc0 arch/x86/mm/fault.c:1527
>  asm_exc_page_fault+0x26/0x30 arch/x86/include/asm/idtentry.h:618
> page last free pid 8849 tgid 8846 stack trace:
>  reset_page_owner include/linux/page_owner.h:25 [inline]
>  __free_pages_prepare mm/page_alloc.c:1402 [inline]
>  free_unref_folios+0xcec/0x1480 mm/page_alloc.c:3004
>  folios_put_refs+0xa3d/0xb80 mm/swap.c:1042
>  free_pages_and_swap_cache+0x41d/0x490 mm/swap_state.c:404
>  __tlb_batch_free_encoded_pages mm/mmu_gather.c:138 [inline]
>  tlb_batch_pages_flush mm/mmu_gather.c:151 [inline]
>  tlb_flush_mmu_free mm/mmu_gather.c:417 [inline]
>  tlb_flush_mmu+0x6d3/0xa30 mm/mmu_gather.c:424
>  tlb_finish_mmu+0xf9/0x230 mm/mmu_gather.c:549
>  exit_mmap+0x498/0x9e0 mm/mmap.c:1313
>  __mmput+0x118/0x430 kernel/fork.c:1178
>  exit_mm+0x18e/0x250 kernel/exit.c:581
>  do_exit+0x6a2/0x22c0 kernel/exit.c:963
>  do_group_exit+0x21b/0x2d0 kernel/exit.c:1117
>  get_signal+0x1284/0x1330 kernel/signal.c:3037
>  arch_do_signal_or_restart+0xbc/0x830 arch/x86/kernel/signal.c:337
>  __exit_to_user_mode_loop kernel/entry/common.c:64 [inline]
>  exit_to_user_mode_loop+0x86/0x480 kernel/entry/common.c:98
>  __exit_to_user_mode_prepare include/linux/irq-entry-common.h:207 [inline=
]
>  syscall_exit_to_user_mode_prepare include/linux/irq-entry-common.h:238 [=
inline]
>  syscall_exit_to_user_mode include/linux/entry-common.h:328 [inline]
>  do_syscall_64+0x33e/0xf80 arch/x86/entry/syscall_64.c:100
>  entry_SYSCALL_64_after_hwframe+0x77/0x7f
> Modules linked in:
> CPU: 1 UID: 0 PID: 8855 Comm: syz.2.1435 Tainted: G    B               sy=
zkaller #0 PREEMPT(full)
> Tainted: [B]=3DBAD_PAGE
> Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS 1.16.2-debian-1.=
16.2-1 04/01/2014
> Call Trace:
>  <TASK>
>  dump_stack_lvl+0xe8/0x150 lib/dump_stack.c:120
>  bad_page+0x17f/0x1c0 mm/page_alloc.c:632
>  free_page_is_bad mm/page_alloc.c:1073 [inline]
>  __free_pages_prepare mm/page_alloc.c:1393 [inline]
>  free_unref_folios+0xdcc/0x1480 mm/page_alloc.c:3004
>  folio_batch_move_lru+0x816/0x9e0 mm/swap.c:206
>  __folio_batch_add_and_move+0x510/0xc50 mm/swap.c:226
>  folio_add_lru_vma+0x196/0x210 mm/swap.c:566
>  map_anon_folio_pte_nopf+0x2ee/0x5e0 mm/memory.c:5301
>  map_anon_folio_pte_pf+0xbe/0x260 mm/memory.c:5311
>  do_anonymous_page mm/memory.c:5413 [inline]
>  do_pte_missing+0x2d48/0x33f0 mm/memory.c:4548
>  handle_pte_fault mm/memory.c:6411 [inline]
>  __handle_mm_fault mm/memory.c:6549 [inline]
>  handle_mm_fault+0x1bd7/0x3170 mm/memory.c:6718
>  do_user_addr_fault+0xa73/0x1340 arch/x86/mm/fault.c:1334
>  handle_page_fault arch/x86/mm/fault.c:1474 [inline]
>  exc_page_fault+0x6a/0xc0 arch/x86/mm/fault.c:1527
>  asm_exc_page_fault+0x26/0x30 arch/x86/include/asm/idtentry.h:618
> RIP: 0033:0x7fca082696d2
> Code: 48 89 ca 48 c1 e2 04 48 29 ca 48 8d 0d 5f c9 3a 00 48 c1 e2 04 48 0=
1 c2 8b 44 24 1c c6 42 20 01 89 42 24 8b 44 24 24 89 6a 28 <89> 42 78 0f b6=
 44 24 43 89 72 2c 88 44 19 04 8b 44 24 20 31 c9 89
> RSP: 002b:00007ffc5adb04c0 EFLAGS: 00010206
> RAX: 0000000000000000 RBX: 0000000000000000 RCX: 00007fca08616018
> RDX: 00007fca08615fa0 RSI: 0000000000000003 RDI: 0000000000000000
> RBP: 0000000000001cd6 R08: 00007fca08615fa0 R09: 00007ffc5adb0357
> R10: 0000000000000008 R11: 0000000000000246 R12: 0000000000000000
> R13: 00007fca08615fac R14: 00007fca08615fa8 R15: 00007fca08615fa0
>  </TASK>
> BUG: Bad page state in process syz.2.1435  pfn:1af408
> page: refcount:0 mapcount:0 mapping:0000000000000000 index:0x555573b20 pf=
n:0x1af408
> flags: 0x57ff00000020908(uptodate|active|owner_2|swapbacked|node=3D1|zone=
=3D2|lastcpupid=3D0x7ff)
> raw: 057ff00000020908 0000000000000000 dead000000000122 0000000000000000
> raw: 0000000555573b20 0000000000000000 00000000ffffffff 0000000000000000
> page dumped because: PAGE_FLAGS_CHECK_AT_FREE flag(s) set
> page_owner tracks the page as allocated
> page last allocated via order 0, migratetype Movable, gfp_mask 0x140cca(G=
FP_HIGHUSER_MOVABLE|__GFP_COMP), pid 8851, tgid 8851 (syz.0.1434), ts 86979=
662330, free_ts 86967025854
>  set_page_owner include/linux/page_owner.h:32 [inline]
>  post_alloc_hook+0x22d/0x280 mm/page_alloc.c:1858
>  prep_new_page mm/page_alloc.c:1866 [inline]
>  get_page_from_freelist+0x24ba/0x2540 mm/page_alloc.c:3946
>  __alloc_frozen_pages_noprof+0x18d/0x380 mm/page_alloc.c:5226
>  alloc_pages_mpol+0x235/0x490 mm/mempolicy.c:2490
>  folio_alloc_mpol_noprof+0x39/0x160 mm/mempolicy.c:2509
>  vma_alloc_folio_noprof+0xe1/0x1e0 mm/mempolicy.c:2544
>  folio_prealloc mm/memory.c:-1 [inline]
>  wp_page_copy mm/memory.c:3859 [inline]
>  do_wp_page+0x118a/0x4cc0 mm/memory.c:4320
>  handle_pte_fault mm/memory.c:6427 [inline]
>  __handle_mm_fault mm/memory.c:6549 [inline]
>  handle_mm_fault+0x151d/0x3170 mm/memory.c:6718
>  do_user_addr_fault+0xa73/0x1340 arch/x86/mm/fault.c:1334
>  handle_page_fault arch/x86/mm/fault.c:1474 [inline]
>  exc_page_fault+0x6a/0xc0 arch/x86/mm/fault.c:1527
>  asm_exc_page_fault+0x26/0x30 arch/x86/include/asm/idtentry.h:618
> page last free pid 8849 tgid 8846 stack trace:
>  reset_page_owner include/linux/page_owner.h:25 [inline]
>  __free_pages_prepare mm/page_alloc.c:1402 [inline]
>  free_unref_folios+0xcec/0x1480 mm/page_alloc.c:3004
>  folios_put_refs+0xa3d/0xb80 mm/swap.c:1042
>  free_pages_and_swap_cache+0x41d/0x490 mm/swap_state.c:404
>  __tlb_batch_free_encoded_pages mm/mmu_gather.c:138 [inline]
>  tlb_batch_pages_flush mm/mmu_gather.c:151 [inline]
>  tlb_flush_mmu_free mm/mmu_gather.c:417 [inline]
>  tlb_flush_mmu+0x6d3/0xa30 mm/mmu_gather.c:424
>  tlb_finish_mmu+0xf9/0x230 mm/mmu_gather.c:549
>  exit_mmap+0x498/0x9e0 mm/mmap.c:1313
>  __mmput+0x118/0x430 kernel/fork.c:1178
>  exit_mm+0x18e/0x250 kernel/exit.c:581
>  do_exit+0x6a2/0x22c0 kernel/exit.c:963
>  do_group_exit+0x21b/0x2d0 kernel/exit.c:1117
>  get_signal+0x1284/0x1330 kernel/signal.c:3037
>  arch_do_signal_or_restart+0xbc/0x830 arch/x86/kernel/signal.c:337
>  __exit_to_user_mode_loop kernel/entry/common.c:64 [inline]
>  exit_to_user_mode_loop+0x86/0x480 kernel/entry/common.c:98
>  __exit_to_user_mode_prepare include/linux/irq-entry-common.h:207 [inline=
]
>  syscall_exit_to_user_mode_prepare include/linux/irq-entry-common.h:238 [=
inline]
>  syscall_exit_to_user_mode include/linux/entry-common.h:328 [inline]
>  do_syscall_64+0x33e/0xf80 arch/x86/entry/syscall_64.c:100
>  entry_SYSCALL_64_after_hwframe+0x77/0x7f
> Modules linked in:
> CPU: 1 UID: 0 PID: 8855 Comm: syz.2.1435 Tainted: G    B               sy=
zkaller #0 PREEMPT(full)
> Tainted: [B]=3DBAD_PAGE
> Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS 1.16.2-debian-1.=
16.2-1 04/01/2014
> Call Trace:
>  <TASK>
>  dump_stack_lvl+0xe8/0x150 lib/dump_stack.c:120
>  bad_page+0x17f/0x1c0 mm/page_alloc.c:632
>  free_page_is_bad mm/page_alloc.c:1073 [inline]
>  __free_pages_prepare mm/page_alloc.c:1393 [inline]
>  free_unref_folios+0xdcc/0x1480 mm/page_alloc.c:3004
>  folio_batch_move_lru+0x816/0x9e0 mm/swap.c:206
>  __folio_batch_add_and_move+0x510/0xc50 mm/swap.c:226
>  folio_add_lru_vma+0x196/0x210 mm/swap.c:566
>  map_anon_folio_pte_nopf+0x2ee/0x5e0 mm/memory.c:5301
>  map_anon_folio_pte_pf+0xbe/0x260 mm/memory.c:5311
>  do_anonymous_page mm/memory.c:5413 [inline]
>  do_pte_missing+0x2d48/0x33f0 mm/memory.c:4548
>  handle_pte_fault mm/memory.c:6411 [inline]
>  __handle_mm_fault mm/memory.c:6549 [inline]
>  handle_mm_fault+0x1bd7/0x3170 mm/memory.c:6718
>  do_user_addr_fault+0xa73/0x1340 arch/x86/mm/fault.c:1334
>  handle_page_fault arch/x86/mm/fault.c:1474 [inline]
>  exc_page_fault+0x6a/0xc0 arch/x86/mm/fault.c:1527
>  asm_exc_page_fault+0x26/0x30 arch/x86/include/asm/idtentry.h:618
> RIP: 0033:0x7fca082696d2
> Code: 48 89 ca 48 c1 e2 04 48 29 ca 48 8d 0d 5f c9 3a 00 48 c1 e2 04 48 0=
1 c2 8b 44 24 1c c6 42 20 01 89 42 24 8b 44 24 24 89 6a 28 <89> 42 78 0f b6=
 44 24 43 89 72 2c 88 44 19 04 8b 44 24 20 31 c9 89
> RSP: 002b:00007ffc5adb04c0 EFLAGS: 00010206
> RAX: 0000000000000000 RBX: 0000000000000000 RCX: 00007fca08616018
> RDX: 00007fca08615fa0 RSI: 0000000000000003 RDI: 0000000000000000
> RBP: 0000000000001cd6 R08: 00007fca08615fa0 R09: 00007ffc5adb0357
> R10: 0000000000000008 R11: 0000000000000246 R12: 0000000000000000
> R13: 00007fca08615fac R14: 00007fca08615fa8 R15: 00007fca08615fa0
>  </TASK>
> BUG: Bad page state in process syz.2.1435  pfn:1af412
> page: refcount:0 mapcount:0 mapping:0000000000000000 index:0x7f14c9e16 pf=
n:0x1af412
> flags: 0x57ff00000020908(uptodate|active|owner_2|swapbacked|node=3D1|zone=
=3D2|lastcpupid=3D0x7ff)
> raw: 057ff00000020908 0000000000000000 dead000000000122 0000000000000000
> raw: 00000007f14c9e16 0000000000000000 00000000ffffffff 0000000000000000
> page dumped because: PAGE_FLAGS_CHECK_AT_FREE flag(s) set
> page_owner tracks the page as allocated
> page last allocated via order 0, migratetype Movable, gfp_mask 0x140dca(G=
FP_HIGHUSER_MOVABLE|__GFP_ZERO|__GFP_COMP), pid 8851, tgid 8851 (syz.0.1434=
), ts 86981021345, free_ts 69887129694
>  set_page_owner include/linux/page_owner.h:32 [inline]
>  post_alloc_hook+0x22d/0x280 mm/page_alloc.c:1858
>  prep_new_page mm/page_alloc.c:1866 [inline]
>  get_page_from_freelist+0x24ba/0x2540 mm/page_alloc.c:3946
>  __alloc_frozen_pages_noprof+0x18d/0x380 mm/page_alloc.c:5226
>  alloc_pages_mpol+0x235/0x490 mm/mempolicy.c:2490
>  folio_alloc_mpol_noprof+0x39/0x160 mm/mempolicy.c:2509
>  vma_alloc_folio_noprof+0xe1/0x1e0 mm/mempolicy.c:2544
>  folio_prealloc mm/memory.c:-1 [inline]
>  alloc_anon_folio mm/memory.c:5282 [inline]
>  do_anonymous_page mm/memory.c:5376 [inline]
>  do_pte_missing+0x159d/0x33f0 mm/memory.c:4548
>  handle_pte_fault mm/memory.c:6411 [inline]
>  __handle_mm_fault mm/memory.c:6549 [inline]
>  handle_mm_fault+0x1bd7/0x3170 mm/memory.c:6718
>  do_user_addr_fault+0xa73/0x1340 arch/x86/mm/fault.c:1334
>  handle_page_fault arch/x86/mm/fault.c:1474 [inline]
>  exc_page_fault+0x6a/0xc0 arch/x86/mm/fault.c:1527
>  asm_exc_page_fault+0x26/0x30 arch/x86/include/asm/idtentry.h:618
> page last free pid 5831 tgid 5831 stack trace:
>  reset_page_owner include/linux/page_owner.h:25 [inline]
>  __free_pages_prepare mm/page_alloc.c:1402 [inline]
>  free_unref_folios+0xcec/0x1480 mm/page_alloc.c:3004
>  folios_put_refs+0xa3d/0xb80 mm/swap.c:1042
>  free_pages_and_swap_cache+0x41d/0x490 mm/swap_state.c:404
>  __tlb_batch_free_encoded_pages mm/mmu_gather.c:138 [inline]
>  tlb_batch_pages_flush mm/mmu_gather.c:151 [inline]
>  tlb_flush_mmu_free mm/mmu_gather.c:417 [inline]
>  tlb_flush_mmu+0x6d3/0xa30 mm/mmu_gather.c:424
>  tlb_finish_mmu+0xf9/0x230 mm/mmu_gather.c:549
>  unmap_region+0x2a5/0x330 mm/vma.c:491
>  vms_clear_ptes mm/vma.c:1303 [inline]
>  vms_complete_munmap_vmas+0x493/0xc60 mm/vma.c:1345
>  do_vmi_align_munmap+0x3b7/0x4b0 mm/vma.c:1604
>  do_vmi_munmap+0x252/0x2d0 mm/vma.c:1652
>  __vm_munmap+0x22c/0x3d0 mm/vma.c:3285
>  __do_sys_munmap mm/mmap.c:1079 [inline]
>  __se_sys_munmap mm/mmap.c:1076 [inline]
>  __x64_sys_munmap+0x60/0x70 mm/mmap.c:1076
>  do_syscall_x64 arch/x86/entry/syscall_64.c:63 [inline]
>  do_syscall_64+0x15f/0xf80 arch/x86/entry/syscall_64.c:94
>  entry_SYSCALL_64_after_hwframe+0x77/0x7f
> Modules linked in:
> CPU: 1 UID: 0 PID: 8855 Comm: syz.2.1435 Tainted: G    B               sy=
zkaller #0 PREEMPT(full)
> Tainted: [B]=3DBAD_PAGE
> Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS 1.16.2-debian-1.=
16.2-1 04/01/2014
> Call Trace:
>  <TASK>
>  dump_stack_lvl+0xe8/0x150 lib/dump_stack.c:120
>  bad_page+0x17f/0x1c0 mm/page_alloc.c:632
>  free_page_is_bad mm/page_alloc.c:1073 [inline]
>  __free_pages_prepare mm/page_alloc.c:1393 [inline]
>  free_unref_folios+0xdcc/0x1480 mm/page_alloc.c:3004
>  folio_batch_move_lru+0x816/0x9e0 mm/swap.c:206
>  __folio_batch_add_and_move+0x510/0xc50 mm/swap.c:226
>  folio_add_lru_vma+0x196/0x210 mm/swap.c:566
>  map_anon_folio_pte_nopf+0x2ee/0x5e0 mm/memory.c:5301
>  map_anon_folio_pte_pf+0xbe/0x260 mm/memory.c:5311
>  do_anonymous_page mm/memory.c:5413 [inline]
>  do_pte_missing+0x2d48/0x33f0 mm/memory.c:4548
>  handle_pte_fault mm/memory.c:6411 [inline]
>  __handle_mm_fault mm/memory.c:6549 [inline]
>  handle_mm_fault+0x1bd7/0x3170 mm/memory.c:6718
>  do_user_addr_fault+0xa73/0x1340 arch/x86/mm/fault.c:1334
>  handle_page_fault arch/x86/mm/fault.c:1474 [inline]
>  exc_page_fault+0x6a/0xc0 arch/x86/mm/fault.c:1527
>  asm_exc_page_fault+0x26/0x30 arch/x86/include/asm/idtentry.h:618
> RIP: 0033:0x7fca082696d2
> Code: 48 89 ca 48 c1 e2 04 48 29 ca 48 8d 0d 5f c9 3a 00 48 c1 e2 04 48 0=
1 c2 8b 44 24 1c c6 42 20 01 89 42 24 8b 44 24 24 89 6a 28 <89> 42 78 0f b6=
 44 24 43 89 72 2c 88 44 19 04 8b 44 24 20 31 c9 89
> RSP: 002b:00007ffc5adb04c0 EFLAGS: 00010206
> RAX: 0000000000000000 RBX: 0000000000000000 RCX: 00007fca08616018
> RDX: 00007fca08615fa0 RSI: 0000000000000003 RDI: 0000000000000000
> RBP: 0000000000001cd6 R08: 00007fca08615fa0 R09: 00007ffc5adb0357
> R10: 0000000000000008 R11: 0000000000000246 R12: 0000000000000000
> R13: 00007fca08615fac R14: 00007fca08615fa8 R15: 00007fca08615fa0
>  </TASK>
> BUG: Bad page state in process syz.2.1435  pfn:1af413
> page: refcount:0 mapcount:0 mapping:0000000000000000 index:0x7f14c9e17 pf=
n:0x1af413
> flags: 0x57ff00000020908(uptodate|active|owner_2|swapbacked|node=3D1|zone=
=3D2|lastcpupid=3D0x7ff)
> raw: 057ff00000020908 0000000000000000 dead000000000122 0000000000000000
> raw: 00000007f14c9e17 0000000000000000 00000000ffffffff 0000000000000000
> page dumped because: PAGE_FLAGS_CHECK_AT_FREE flag(s) set
> page_owner tracks the page as allocated
> page last allocated via order 0, migratetype Movable, gfp_mask 0x140cca(G=
FP_HIGHUSER_MOVABLE|__GFP_COMP), pid 8851, tgid 8851 (syz.0.1434), ts 86981=
071632, free_ts 69887133292
>  set_page_owner include/linux/page_owner.h:32 [inline]
>  post_alloc_hook+0x22d/0x280 mm/page_alloc.c:1858
>  prep_new_page mm/page_alloc.c:1866 [inline]
>  get_page_from_freelist+0x24ba/0x2540 mm/page_alloc.c:3946
>  __alloc_frozen_pages_noprof+0x18d/0x380 mm/page_alloc.c:5226
>  alloc_pages_mpol+0x235/0x490 mm/mempolicy.c:2490
>  folio_alloc_mpol_noprof+0x39/0x160 mm/mempolicy.c:2509
>  vma_alloc_folio_noprof+0xe1/0x1e0 mm/mempolicy.c:2544
>  folio_prealloc mm/memory.c:-1 [inline]
>  wp_page_copy mm/memory.c:3859 [inline]
>  do_wp_page+0x118a/0x4cc0 mm/memory.c:4320
>  handle_pte_fault mm/memory.c:6427 [inline]
>  __handle_mm_fault mm/memory.c:6549 [inline]
>  handle_mm_fault+0x151d/0x3170 mm/memory.c:6718
>  do_user_addr_fault+0xa73/0x1340 arch/x86/mm/fault.c:1334
>  handle_page_fault arch/x86/mm/fault.c:1474 [inline]
>  exc_page_fault+0x6a/0xc0 arch/x86/mm/fault.c:1527
>  asm_exc_page_fault+0x26/0x30 arch/x86/include/asm/idtentry.h:618
> page last free pid 5831 tgid 5831 stack trace:
>  reset_page_owner include/linux/page_owner.h:25 [inline]
>  __free_pages_prepare mm/page_alloc.c:1402 [inline]
>  free_unref_folios+0xcec/0x1480 mm/page_alloc.c:3004
>  folios_put_refs+0xa3d/0xb80 mm/swap.c:1042
>  free_pages_and_swap_cache+0x41d/0x490 mm/swap_state.c:404
>  __tlb_batch_free_encoded_pages mm/mmu_gather.c:138 [inline]
>  tlb_batch_pages_flush mm/mmu_gather.c:151 [inline]
>  tlb_flush_mmu_free mm/mmu_gather.c:417 [inline]
>  tlb_flush_mmu+0x6d3/0xa30 mm/mmu_gather.c:424
>  tlb_finish_mmu+0xf9/0x230 mm/mmu_gather.c:549
>  unmap_region+0x2a5/0x330 mm/vma.c:491
>  vms_clear_ptes mm/vma.c:1303 [inline]
>  vms_complete_munmap_vmas+0x493/0xc60 mm/vma.c:1345
>  do_vmi_align_munmap+0x3b7/0x4b0 mm/vma.c:1604
>  do_vmi_munmap+0x252/0x2d0 mm/vma.c:1652
>  __vm_munmap+0x22c/0x3d0 mm/vma.c:3285
>  __do_sys_munmap mm/mmap.c:1079 [inline]
>  __se_sys_munmap mm/mmap.c:1076 [inline]
>  __x64_sys_munmap+0x60/0x70 mm/mmap.c:1076
>  do_syscall_x64 arch/x86/entry/syscall_64.c:63 [inline]
>  do_syscall_64+0x15f/0xf80 arch/x86/entry/syscall_64.c:94
>  entry_SYSCALL_64_after_hwframe+0x77/0x7f
> Modules linked in:
> CPU: 1 UID: 0 PID: 8855 Comm: syz.2.1435 Tainted: G    B               sy=
zkaller #0 PREEMPT(full)
> Tainted: [B]=3DBAD_PAGE
> Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS 1.16.2-debian-1.=
16.2-1 04/01/2014
> Call Trace:
>  <TASK>
>  dump_stack_lvl+0xe8/0x150 lib/dump_stack.c:120
>  bad_page+0x17f/0x1c0 mm/page_alloc.c:632
>  free_page_is_bad mm/page_alloc.c:1073 [inline]
>  __free_pages_prepare mm/page_alloc.c:1393 [inline]
>  free_unref_folios+0xdcc/0x1480 mm/page_alloc.c:3004
>  folio_batch_move_lru+0x816/0x9e0 mm/swap.c:206
>  __folio_batch_add_and_move+0x510/0xc50 mm/swap.c:226
>  folio_add_lru_vma+0x196/0x210 mm/swap.c:566
>  map_anon_folio_pte_nopf+0x2ee/0x5e0 mm/memory.c:5301
>  map_anon_folio_pte_pf+0xbe/0x260 mm/memory.c:5311
>  do_anonymous_page mm/memory.c:5413 [inline]
>  do_pte_missing+0x2d48/0x33f0 mm/memory.c:4548
>  handle_pte_fault mm/memory.c:6411 [inline]
>  __handle_mm_fault mm/memory.c:6549 [inline]
>  handle_mm_fault+0x1bd7/0x3170 mm/memory.c:6718
>  do_user_addr_fault+0xa73/0x1340 arch/x86/mm/fault.c:1334
>  handle_page_fault arch/x86/mm/fault.c:1474 [inline]
>  exc_page_fault+0x6a/0xc0 arch/x86/mm/fault.c:1527
>  asm_exc_page_fault+0x26/0x30 arch/x86/include/asm/idtentry.h:618
> RIP: 0033:0x7fca082696d2
> Code: 48 89 ca 48 c1 e2 04 48 29 ca 48 8d 0d 5f c9 3a 00 48 c1 e2 04 48 0=
1 c2 8b 44 24 1c c6 42 20 01 89 42 24 8b 44 24 24 89 6a 28 <89> 42 78 0f b6=
 44 24 43 89 72 2c 88 44 19 04 8b 44 24 20 31 c9 89
> RSP: 002b:00007ffc5adb04c0 EFLAGS: 00010206
> RAX: 0000000000000000 RBX: 0000000000000000 RCX: 00007fca08616018
> RDX: 00007fca08615fa0 RSI: 0000000000000003 RDI: 0000000000000000
> RBP: 0000000000001cd6 R08: 00007fca08615fa0 R09: 00007ffc5adb0357
> R10: 0000000000000008 R11: 0000000000000246 R12: 0000000000000000
> R13: 00007fca08615fac R14: 00007fca08615fa8 R15: 00007fca08615fa0
>  </TASK>
> BUG: Bad page state in process syz.2.1435  pfn:1af414
> page: refcount:0 mapcount:0 mapping:0000000000000000 index:0x7f14c9e12 pf=
n:0x1af414
> flags: 0x57ff00000020908(uptodate|active|owner_2|swapbacked|node=3D1|zone=
=3D2|lastcpupid=3D0x7ff)
> raw: 057ff00000020908 0000000000000000 dead000000000122 0000000000000000
> raw: 00000007f14c9e12 0000000000000000 00000000ffffffff 0000000000000000
> page dumped because: PAGE_FLAGS_CHECK_AT_FREE flag(s) set
> page_owner tracks the page as allocated
> page last allocated via order 0, migratetype Movable, gfp_mask 0x140cca(G=
FP_HIGHUSER_MOVABLE|__GFP_COMP), pid 8851, tgid 8851 (syz.0.1434), ts 86982=
688821, free_ts 69887137521
>  set_page_owner include/linux/page_owner.h:32 [inline]
>  post_alloc_hook+0x22d/0x280 mm/page_alloc.c:1858
>  prep_new_page mm/page_alloc.c:1866 [inline]
>  get_page_from_freelist+0x24ba/0x2540 mm/page_alloc.c:3946
>  __alloc_frozen_pages_noprof+0x18d/0x380 mm/page_alloc.c:5226
>  alloc_pages_mpol+0x235/0x490 mm/mempolicy.c:2490
>  folio_alloc_mpol_noprof+0x39/0x160 mm/mempolicy.c:2509
>  vma_alloc_folio_noprof+0xe1/0x1e0 mm/mempolicy.c:2544
>  folio_prealloc mm/memory.c:-1 [inline]
>  wp_page_copy mm/memory.c:3859 [inline]
>  do_wp_page+0x118a/0x4cc0 mm/memory.c:4320
>  handle_pte_fault mm/memory.c:6427 [inline]
>  __handle_mm_fault mm/memory.c:6549 [inline]
>  handle_mm_fault+0x151d/0x3170 mm/memory.c:6718
>  do_user_addr_fault+0xa73/0x1340 arch/x86/mm/fault.c:1334
>  handle_page_fault arch/x86/mm/fault.c:1474 [inline]
>  exc_page_fault+0x6a/0xc0 arch/x86/mm/fault.c:1527
>  asm_exc_page_fault+0x26/0x30 arch/x86/include/asm/idtentry.h:618
> page last free pid 5831 tgid 5831 stack trace:
>  reset_page_owner include/linux/page_owner.h:25 [inline]
>  __free_pages_prepare mm/page_alloc.c:1402 [inline]
>  free_unref_folios+0xcec/0x1480 mm/page_alloc.c:3004
>  folios_put_refs+0xa3d/0xb80 mm/swap.c:1042
>  free_pages_and_swap_cache+0x41d/0x490 mm/swap_state.c:404
>  __tlb_batch_free_encoded_pages mm/mmu_gather.c:138 [inline]
>  tlb_batch_pages_flush mm/mmu_gather.c:151 [inline]
>  tlb_flush_mmu_free mm/mmu_gather.c:417 [inline]
>  tlb_flush_mmu+0x6d3/0xa30 mm/mmu_gather.c:424
>  tlb_finish_mmu+0xf9/0x230 mm/mmu_gather.c:549
>  unmap_region+0x2a5/0x330 mm/vma.c:491
>  vms_clear_ptes mm/vma.c:1303 [inline]
>  vms_complete_munmap_vmas+0x493/0xc60 mm/vma.c:1345
>  do_vmi_align_munmap+0x3b7/0x4b0 mm/vma.c:1604
>  do_vmi_munmap+0x252/0x2d0 mm/vma.c:1652
>  __vm_munmap+0x22c/0x3d0 mm/vma.c:3285
>  __do_sys_munmap mm/mmap.c:1079 [inline]
>  __se_sys_munmap mm/mmap.c:1076 [inline]
>  __x64_sys_munmap+0x60/0x70 mm/mmap.c:1076
>  do_syscall_x64 arch/x86/entry/syscall_64.c:63 [inline]
>  do_syscall_64+0x15f/0xf80 arch/x86/entry/syscall_64.c:94
>  entry_SYSCALL_64_after_hwframe+0x77/0x7f
> Modules linked in:
>
> CPU: 1 UID: 0 PID: 8855 Comm: syz.2.1435 Tainted: G    B               sy=
zkaller #0 PREEMPT(full)
> Tainted: [B]=3DBAD_PAGE
> Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS 1.16.2-debian-1.=
16.2-1 04/01/2014
> Call Trace:
>  <TASK>
>  dump_stack_lvl+0xe8/0x150 lib/dump_stack.c:120
>  bad_page+0x17f/0x1c0 mm/page_alloc.c:632
>  free_page_is_bad mm/page_alloc.c:1073 [inline]
>  __free_pages_prepare mm/page_alloc.c:1393 [inline]
>  free_unref_folios+0xdcc/0x1480 mm/page_alloc.c:3004
>  folio_batch_move_lru+0x816/0x9e0 mm/swap.c:206
>  __folio_batch_add_and_move+0x510/0xc50 mm/swap.c:226
>  folio_add_lru_vma+0x196/0x210 mm/swap.c:566
>  map_anon_folio_pte_nopf+0x2ee/0x5e0 mm/memory.c:5301
>  map_anon_folio_pte_pf+0xbe/0x260 mm/memory.c:5311
>  do_anonymous_page mm/memory.c:5413 [inline]
>  do_pte_missing+0x2d48/0x33f0 mm/memory.c:4548
>  handle_pte_fault mm/memory.c:6411 [inline]
>  __handle_mm_fault mm/memory.c:6549 [inline]
>  handle_mm_fault+0x1bd7/0x3170 mm/memory.c:6718
>  do_user_addr_fault+0xa73/0x1340 arch/x86/mm/fault.c:1334
>  handle_page_fault arch/x86/mm/fault.c:1474 [inline]
>  exc_page_fault+0x6a/0xc0 arch/x86/mm/fault.c:1527
>  asm_exc_page_fault+0x26/0x30 arch/x86/include/asm/idtentry.h:618
> RIP: 0033:0x7fca082696d2
> Code: 48 89 ca 48 c1 e2 04 48 29 ca 48 8d 0d 5f c9 3a 00 48 c1 e2 04 48 0=
1 c2 8b 44 24 1c c6 42 20 01 89 42 24 8b 44 24 24 89 6a 28 <89> 42 78 0f b6=
 44 24 43 89 72 2c 88 44 19 04 8b 44 24 20 31 c9 89
> RSP: 002b:00007ffc5adb04c0 EFLAGS: 00010206
> RAX: 0000000000000000 RBX: 0000000000000000 RCX: 00007fca08616018
> RDX: 00007fca08615fa0 RSI: 0000000000000003 RDI: 0000000000000000
> RBP: 0000000000001cd6 R08: 00007fca08615fa0 R09: 00007ffc5adb0357
> R10: 0000000000000008 R11: 0000000000000246 R12: 0000000000000000
> R13: 00007fca08615fac R14: 00007fca08615fa8 R15: 00007fca08615fa0
>  </TASK>
>
>
> ***
>
> BUG: Bad page state in do_wp_page
>
> tree:      mm-new
> URL:       https://kernel.googlesource.com/pub/scm/linux/kernel/git/akpm/=
mm.git
> base:      c9183ec6e2e3bd26a017392d6c3eaa40c580f153
> arch:      amd64
> compiler:  Debian clang version 21.1.8 (++20251221033036+2078da43e25a-1~e=
xp1~20251221153213.50), Debian LLD 21.1.8
> config:    https://ci.syzbot.org/builds/4d1a53f4-f506-4ba9-a8c2-a48196f95=
abc/config
> syz repro: https://ci.syzbot.org/findings/5db96cfa-fea0-4d9d-9b97-6924026=
375b7/syz_repro
>
> BUG: Bad page state: 5753 messages suppressed
> BUG: Bad page state in process syz-executor  pfn:11e4a5
> page: refcount:0 mapcount:0 mapping:0000000000000000 index:0x7f4658e12 pf=
n:0x11e4a5
> flags: 0x17ff00000020908(uptodate|active|owner_2|swapbacked|node=3D0|zone=
=3D2|lastcpupid=3D0x7ff)
> raw: 017ff00000020908 0000000000000000 dead000000000122 0000000000000000
> raw: 00000007f4658e12 0000000000000000 00000000ffffffff 0000000000000000
> page dumped because: PAGE_FLAGS_CHECK_AT_FREE flag(s) set
> page_owner tracks the page as allocated
> page last allocated via order 0, migratetype Movable, gfp_mask 0x140cca(G=
FP_HIGHUSER_MOVABLE|__GFP_COMP), pid 6083, tgid 6083 (syz.1.50), ts 8621470=
2085, free_ts 66376409073
>  set_page_owner include/linux/page_owner.h:32 [inline]
>  post_alloc_hook+0x22d/0x280 mm/page_alloc.c:1858
>  prep_new_page mm/page_alloc.c:1866 [inline]
>  get_page_from_freelist+0x24ba/0x2540 mm/page_alloc.c:3946
>  __alloc_frozen_pages_noprof+0x18d/0x380 mm/page_alloc.c:5226
>  alloc_pages_mpol+0x235/0x490 mm/mempolicy.c:2490
>  folio_alloc_mpol_noprof+0x39/0x160 mm/mempolicy.c:2509
>  vma_alloc_folio_noprof+0xe1/0x1e0 mm/mempolicy.c:2544
>  folio_prealloc mm/memory.c:-1 [inline]
>  wp_page_copy mm/memory.c:3859 [inline]
>  do_wp_page+0x118a/0x4cc0 mm/memory.c:4320
>  handle_pte_fault mm/memory.c:6427 [inline]
>  __handle_mm_fault mm/memory.c:6549 [inline]
>  handle_mm_fault+0x151d/0x3170 mm/memory.c:6718
>  do_user_addr_fault+0xa73/0x1340 arch/x86/mm/fault.c:1334
>  handle_page_fault arch/x86/mm/fault.c:1474 [inline]
>  exc_page_fault+0x6a/0xc0 arch/x86/mm/fault.c:1527
>  asm_exc_page_fault+0x26/0x30 arch/x86/include/asm/idtentry.h:618
> page last free pid 5817 tgid 5790 stack trace:
>  reset_page_owner include/linux/page_owner.h:25 [inline]
>  __free_pages_prepare mm/page_alloc.c:1402 [inline]
>  __free_frozen_pages+0xbc7/0xd30 mm/page_alloc.c:2943
>  __folio_put+0x4a2/0x580 mm/swap.c:112
>  folio_put include/linux/mm.h:2090 [inline]
>  migrate_folio_done mm/migrate.c:1201 [inline]
>  migrate_folio_move mm/migrate.c:1432 [inline]
>  migrate_folios_move mm/migrate.c:1740 [inline]
>  migrate_pages_batch+0x3dac/0x4ca0 mm/migrate.c:1996
>  migrate_pages+0x1e02/0x2a10 mm/migrate.c:2130
>  migrate_misplaced_folio+0x273/0x720 mm/migrate.c:2751
>  do_numa_page mm/memory.c:6199 [inline]
>  handle_pte_fault mm/memory.c:6417 [inline]
>  __handle_mm_fault mm/memory.c:6549 [inline]
>  handle_mm_fault+0x20ea/0x3170 mm/memory.c:6718
>  do_user_addr_fault+0x75b/0x1340 arch/x86/mm/fault.c:1385
>  handle_page_fault arch/x86/mm/fault.c:1474 [inline]
>  exc_page_fault+0x6a/0xc0 arch/x86/mm/fault.c:1527
>  asm_exc_page_fault+0x26/0x30 arch/x86/include/asm/idtentry.h:618
> Modules linked in:
> CPU: 0 UID: 0 PID: 6089 Comm: syz-executor Tainted: G    B               =
syzkaller #0 PREEMPT(full)
> Tainted: [B]=3DBAD_PAGE
> Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS 1.16.2-debian-1.=
16.2-1 04/01/2014
> Call Trace:
>  <TASK>
>  dump_stack_lvl+0xe8/0x150 lib/dump_stack.c:120
>  bad_page+0x17f/0x1c0 mm/page_alloc.c:632
>  free_page_is_bad mm/page_alloc.c:1073 [inline]
>  __free_pages_prepare mm/page_alloc.c:1393 [inline]
>  free_unref_folios+0xdcc/0x1480 mm/page_alloc.c:3004
>  folio_batch_move_lru+0x816/0x9e0 mm/swap.c:206
>  __folio_batch_add_and_move+0x510/0xc50 mm/swap.c:226
>  folio_add_lru_vma+0x196/0x210 mm/swap.c:566
>  wp_page_copy mm/memory.c:3927 [inline]
>  do_wp_page+0x3deb/0x4cc0 mm/memory.c:4320
>  handle_pte_fault mm/memory.c:6427 [inline]
>  __handle_mm_fault mm/memory.c:6549 [inline]
>  handle_mm_fault+0x151d/0x3170 mm/memory.c:6718
>  do_user_addr_fault+0xa73/0x1340 arch/x86/mm/fault.c:1334
>  handle_page_fault arch/x86/mm/fault.c:1474 [inline]
>  exc_page_fault+0x6a/0xc0 arch/x86/mm/fault.c:1527
>  asm_exc_page_fault+0x26/0x30 arch/x86/include/asm/idtentry.h:618
> RIP: 0033:0x7f4658b61da7
> Code: 00 00 00 80 3d 51 aa de 00 00 0f 84 b4 00 00 00 48 c7 c0 e0 ff ff f=
f c7 05 4a aa de 00 00 00 00 00 64 48 8b 08 48 85 c9 74 0b <48> c7 81 80 08=
 00 00 01 00 00 00 48 c7 05 23 aa de 00 00 00 00 00
> RSP: 002b:00007ffc5850f508 EFLAGS: 00010202
> RAX: ffffffffffffffe0 RBX: 0000000000000000 RCX: 00007f4658dece20
> RDX: 0000000000000000 RSI: 00007f4658c52ee0 RDI: 00007f4659948060
> RBP: 00007ffc5850f66c R08: 00007f4659948060 R09: 0000000000000000
> R10: 0000000000000008 R11: 0000000000000246 R12: 0000000000000001
> R13: 00000000000927c0 R14: 0000000000015068 R15: 00007ffc5850f6c0
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
> [akpm@linux-foundation.org axelrasmussen@google.com baohua@kernel.org bhe=
@redhat.com chrisl@kernel.org hannes@cmpxchg.org jp.kobryn@linux.dev kasong=
@tencent.com kernel-team@meta.com linux-kernel@vger.kernel.org linux-mm@kva=
ck.org mhocko@suse.com nphamcs@gmail.com qi.zheng@linux.dev riel@surriel.co=
m shakeel.butt@linux.dev shikemeng@huaweicloud.com vbabka@kernel.org weixug=
c@google.com willy@infradead.org youngjun.park@lge.com yuanchu@google.com]
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
-upstream-moderation/69ea9513.a00a0220.9259.002d.GAE%40google.com.
