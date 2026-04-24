Received: from mail-oo1-f72.google.com (mail-oo1-f72.google.com [209.85.161.72])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4279832AAC6
	for <syzbot@lists.linux.dev>; Fri, 24 Apr 2026 07:37:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.161.72
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777016254; cv=none; b=pUGlnw/E/mTZncGo6Ls+6fgJz5cP9VCpAjENEHepzfrTHns5dQ9usS9GmMYUL1opHyttjVH/TsvdADG3OTexRQmJc55YkueNJSXbFkbG7jjqU78fu3N42bHSuekAm+IXGjQw7SLeb84pfSAy7SxLz301YMW6r1lvl3qE3DTGu/Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777016254; c=relaxed/simple;
	bh=i3CgeMpB51Lmvkv/jpZJXrKytH2g2bOcYfcErhRk0CE=;
	h=MIME-Version:Date:In-Reply-To:Message-ID:Subject:From:To:Cc:
	 Content-Type; b=ujUOBDSWGkgaLIUAvG1chKDPoWBtIxQmo/DrlhLJ5cVenMOka/4BnuGrqAQJO+jCDf/LrMDU+u7whyddxEBiBNRxdOlxahXTQE7I+RDZBEuNBcXQfHf/5lchsiKThmMKis6fRlYJu2Y8wFacflPL6xR5Eor7sp7Q13rrBIbpKa0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com; arc=none smtp.client-ip=209.85.161.72
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com
Received: by mail-oo1-f72.google.com with SMTP id 006d021491bc7-679c5ed0942so11360888eaf.1
        for <syzbot@lists.linux.dev>; Fri, 24 Apr 2026 00:37:25 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1777016244; x=1777621044;
        h=cc:to:from:subject:message-id:in-reply-to:date:mime-version
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=ZCG1tHK7kFLFdP1Jusbqyo6hE+crF7q+lIdCDHFPPYo=;
        b=XlvHNe7HQmYMCUVbZXGAA5r37ANkUEltnAq8OWqGxlzwIVQoQmEDjKu/W129/oK063
         h9iNe9phEW1vMbiTScMFQpwHvHRx9LLWzR8CwlFod2TfXbkXMOGLA+ygt5osMudeLHvA
         B++TgAkMDd+6UrNYDEAD7zc7NFCPGgj5ZIKDh96sg0JhBZ1TIWo4NPTe9w/ahS7BNHy3
         SueAZsr0g6kQv39AXBuZs48Yq+EAFS8krtUCYXRDxc3mwXPQ8P22gQegQKm7qOLtT6e5
         zQpoTBfJYJOaqqUUFhHLdsj8N1eR3bXb3PBO0KW1wWzhz2TdON3YQ4zMviI6KhGYZvrA
         ZIwA==
X-Gm-Message-State: AOJu0YwQ7NvbRWRxo+uib8z3G0UdtqXUKF2gRqn0Dm6RCvaJ9g/wIIDw
	souEbTpOTvOz0wvRMkXqnXdk92vFz9WxnQPqmDXcx73YwO/65fHE5dRw/O9APyab1//olTJqeKU
	YbwnPH8ctM5jd/7wWUJ2AQ+o0QlqAJ+hcYEEdYEwcvOUrVNw5QE3E73b+tdo=
Precedence: bulk
X-Mailing-List: syzbot@lists.linux.dev
List-Id: <syzbot.lists.linux.dev>
List-Subscribe: <mailto:syzbot+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:syzbot+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Received: by 2002:a05:6820:180a:b0:67e:2905:83d2 with SMTP id
 006d021491bc7-69462e3a8ffmr17937119eaf.21.1777016244359; Fri, 24 Apr 2026
 00:37:24 -0700 (PDT)
Date: Fri, 24 Apr 2026 00:37:24 -0700
In-Reply-To: <20260423164307.29805-1-jp.kobryn@linux.dev>
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <69eb1db4.a00a0220.9259.0035.GAE@google.com>
Subject: [syzbot ci] Re: mm/lruvec: preemptively free dead folios during
 lru_add drain
From: syzbot ci <syzbot+ci81b95121e9579cdc@syzkaller.appspotmail.com>
To: akpm@linux-foundation.org, axelrasmussen@google.com, baohua@kernel.org, 
	bhe@redhat.com, chrisl@kernel.org, hannes@cmpxchg.org, jp.kobryn@linux.dev, 
	kasong@tencent.com, kernel-team@meta.com, linux-kernel@vger.kernel.org, 
	linux-mm@kvack.org, mhocko@suse.com, nphamcs@gmail.com, qi.zheng@linux.dev, 
	riel@surriel.com, shakeel.butt@linux.dev, shikemeng@huaweicloud.com, 
	vbabka@kernel.org, weixugc@google.com, willy@infradead.org, 
	youngjun.park@lge.com, yuanchu@google.com
Cc: syzbot@lists.linux.dev, syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"

syzbot ci has tested the following series

[v1] mm/lruvec: preemptively free dead folios during lru_add drain
https://lore.kernel.org/all/20260423164307.29805-1-jp.kobryn@linux.dev
* [PATCH] mm/lruvec: preemptively free dead folios during lru_add drain

and found the following issues:
* BUG: Bad page state in do_pte_missing
* BUG: Bad page state in do_wp_page

Full report is available here:
https://ci.syzbot.org/series/d16e663b-bcf5-49dd-937d-24a22e0c8d6a

***

BUG: Bad page state in do_pte_missing

tree:      mm-new
URL:       https://kernel.googlesource.com/pub/scm/linux/kernel/git/akpm/mm.git
base:      c9183ec6e2e3bd26a017392d6c3eaa40c580f153
arch:      amd64
compiler:  Debian clang version 21.1.8 (++20251221033036+2078da43e25a-1~exp1~20251221153213.50), Debian LLD 21.1.8
config:    https://ci.syzbot.org/builds/4d1a53f4-f506-4ba9-a8c2-a48196f95abc/config
syz repro: https://ci.syzbot.org/findings/19ba977e-39f2-4f40-b936-a8642aaab537/syz_repro

BUG: Bad page state: 15292 messages suppressed
BUG: Bad page state in process syz.2.1435  pfn:1af40e
page: refcount:0 mapcount:0 mapping:0000000000000000 index:0x7f14c9e16 pfn:0x1af40e
flags: 0x57ff00000020908(uptodate|active|owner_2|swapbacked|node=1|zone=2|lastcpupid=0x7ff)
raw: 057ff00000020908 0000000000000000 dead000000000122 0000000000000000
raw: 00000007f14c9e16 0000000000000000 00000000ffffffff 0000000000000000
page dumped because: PAGE_FLAGS_CHECK_AT_FREE flag(s) set
page_owner tracks the page as allocated
page last allocated via order 0, migratetype Movable, gfp_mask 0x140dca(GFP_HIGHUSER_MOVABLE|__GFP_ZERO|__GFP_COMP), pid 8846, tgid 8846 (syz.0.1431), ts 86965635591, free_ts 69887114766
 set_page_owner include/linux/page_owner.h:32 [inline]
 post_alloc_hook+0x22d/0x280 mm/page_alloc.c:1858
 prep_new_page mm/page_alloc.c:1866 [inline]
 get_page_from_freelist+0x24ba/0x2540 mm/page_alloc.c:3946
 __alloc_frozen_pages_noprof+0x18d/0x380 mm/page_alloc.c:5226
 alloc_pages_mpol+0x235/0x490 mm/mempolicy.c:2490
 folio_alloc_mpol_noprof+0x39/0x160 mm/mempolicy.c:2509
 vma_alloc_folio_noprof+0xe1/0x1e0 mm/mempolicy.c:2544
 folio_prealloc mm/memory.c:-1 [inline]
 alloc_anon_folio mm/memory.c:5282 [inline]
 do_anonymous_page mm/memory.c:5376 [inline]
 do_pte_missing+0x159d/0x33f0 mm/memory.c:4548
 handle_pte_fault mm/memory.c:6411 [inline]
 __handle_mm_fault mm/memory.c:6549 [inline]
 handle_mm_fault+0x1bd7/0x3170 mm/memory.c:6718
 do_user_addr_fault+0xa73/0x1340 arch/x86/mm/fault.c:1334
 handle_page_fault arch/x86/mm/fault.c:1474 [inline]
 exc_page_fault+0x6a/0xc0 arch/x86/mm/fault.c:1527
 asm_exc_page_fault+0x26/0x30 arch/x86/include/asm/idtentry.h:618
page last free pid 5831 tgid 5831 stack trace:
 reset_page_owner include/linux/page_owner.h:25 [inline]
 __free_pages_prepare mm/page_alloc.c:1402 [inline]
 free_unref_folios+0xcec/0x1480 mm/page_alloc.c:3004
 folios_put_refs+0xa3d/0xb80 mm/swap.c:1042
 free_pages_and_swap_cache+0x41d/0x490 mm/swap_state.c:404
 __tlb_batch_free_encoded_pages mm/mmu_gather.c:138 [inline]
 tlb_batch_pages_flush mm/mmu_gather.c:151 [inline]
 tlb_flush_mmu_free mm/mmu_gather.c:417 [inline]
 tlb_flush_mmu+0x6d3/0xa30 mm/mmu_gather.c:424
 tlb_finish_mmu+0xf9/0x230 mm/mmu_gather.c:549
 unmap_region+0x2a5/0x330 mm/vma.c:491
 vms_clear_ptes mm/vma.c:1303 [inline]
 vms_complete_munmap_vmas+0x493/0xc60 mm/vma.c:1345
 do_vmi_align_munmap+0x3b7/0x4b0 mm/vma.c:1604
 do_vmi_munmap+0x252/0x2d0 mm/vma.c:1652
 __vm_munmap+0x22c/0x3d0 mm/vma.c:3285
 __do_sys_munmap mm/mmap.c:1079 [inline]
 __se_sys_munmap mm/mmap.c:1076 [inline]
 __x64_sys_munmap+0x60/0x70 mm/mmap.c:1076
 do_syscall_x64 arch/x86/entry/syscall_64.c:63 [inline]
 do_syscall_64+0x15f/0xf80 arch/x86/entry/syscall_64.c:94
 entry_SYSCALL_64_after_hwframe+0x77/0x7f
Modules linked in:
CPU: 1 UID: 0 PID: 8855 Comm: syz.2.1435 Tainted: G    B               syzkaller #0 PREEMPT(full) 
Tainted: [B]=BAD_PAGE
Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS 1.16.2-debian-1.16.2-1 04/01/2014
Call Trace:
 <TASK>
 dump_stack_lvl+0xe8/0x150 lib/dump_stack.c:120
 bad_page+0x17f/0x1c0 mm/page_alloc.c:632
 free_page_is_bad mm/page_alloc.c:1073 [inline]
 __free_pages_prepare mm/page_alloc.c:1393 [inline]
 free_unref_folios+0xdcc/0x1480 mm/page_alloc.c:3004
 folio_batch_move_lru+0x816/0x9e0 mm/swap.c:206
 __folio_batch_add_and_move+0x510/0xc50 mm/swap.c:226
 folio_add_lru_vma+0x196/0x210 mm/swap.c:566
 map_anon_folio_pte_nopf+0x2ee/0x5e0 mm/memory.c:5301
 map_anon_folio_pte_pf+0xbe/0x260 mm/memory.c:5311
 do_anonymous_page mm/memory.c:5413 [inline]
 do_pte_missing+0x2d48/0x33f0 mm/memory.c:4548
 handle_pte_fault mm/memory.c:6411 [inline]
 __handle_mm_fault mm/memory.c:6549 [inline]
 handle_mm_fault+0x1bd7/0x3170 mm/memory.c:6718
 do_user_addr_fault+0xa73/0x1340 arch/x86/mm/fault.c:1334
 handle_page_fault arch/x86/mm/fault.c:1474 [inline]
 exc_page_fault+0x6a/0xc0 arch/x86/mm/fault.c:1527
 asm_exc_page_fault+0x26/0x30 arch/x86/include/asm/idtentry.h:618
RIP: 0033:0x7fca082696d2
Code: 48 89 ca 48 c1 e2 04 48 29 ca 48 8d 0d 5f c9 3a 00 48 c1 e2 04 48 01 c2 8b 44 24 1c c6 42 20 01 89 42 24 8b 44 24 24 89 6a 28 <89> 42 78 0f b6 44 24 43 89 72 2c 88 44 19 04 8b 44 24 20 31 c9 89
RSP: 002b:00007ffc5adb04c0 EFLAGS: 00010206
RAX: 0000000000000000 RBX: 0000000000000000 RCX: 00007fca08616018
RDX: 00007fca08615fa0 RSI: 0000000000000003 RDI: 0000000000000000
RBP: 0000000000001cd6 R08: 00007fca08615fa0 R09: 00007ffc5adb0357
R10: 0000000000000008 R11: 0000000000000246 R12: 0000000000000000
R13: 00007fca08615fac R14: 00007fca08615fa8 R15: 00007fca08615fa0
 </TASK>
BUG: Bad page state in process syz.2.1435  pfn:1af40f
page: refcount:0 mapcount:0 mapping:0000000000000000 index:0x7f14c9e17 pfn:0x1af40f
flags: 0x57ff00000020908(uptodate|active|owner_2|swapbacked|node=1|zone=2|lastcpupid=0x7ff)
raw: 057ff00000020908 0000000000000000 dead000000000122 0000000000000000
raw: 00000007f14c9e17 0000000000000000 00000000ffffffff 0000000000000000
page dumped because: PAGE_FLAGS_CHECK_AT_FREE flag(s) set
page_owner tracks the page as allocated
page last allocated via order 0, migratetype Movable, gfp_mask 0x140cca(GFP_HIGHUSER_MOVABLE|__GFP_COMP), pid 8846, tgid 8846 (syz.0.1431), ts 86965651367, free_ts 69887118923
 set_page_owner include/linux/page_owner.h:32 [inline]
 post_alloc_hook+0x22d/0x280 mm/page_alloc.c:1858
 prep_new_page mm/page_alloc.c:1866 [inline]
 get_page_from_freelist+0x24ba/0x2540 mm/page_alloc.c:3946
 __alloc_frozen_pages_noprof+0x18d/0x380 mm/page_alloc.c:5226
 alloc_pages_mpol+0x235/0x490 mm/mempolicy.c:2490
 folio_alloc_mpol_noprof+0x39/0x160 mm/mempolicy.c:2509
 vma_alloc_folio_noprof+0xe1/0x1e0 mm/mempolicy.c:2544
 folio_prealloc mm/memory.c:-1 [inline]
 wp_page_copy mm/memory.c:3859 [inline]
 do_wp_page+0x118a/0x4cc0 mm/memory.c:4320
 handle_pte_fault mm/memory.c:6427 [inline]
 __handle_mm_fault mm/memory.c:6549 [inline]
 handle_mm_fault+0x151d/0x3170 mm/memory.c:6718
 do_user_addr_fault+0xa73/0x1340 arch/x86/mm/fault.c:1334
 handle_page_fault arch/x86/mm/fault.c:1474 [inline]
 exc_page_fault+0x6a/0xc0 arch/x86/mm/fault.c:1527
 asm_exc_page_fault+0x26/0x30 arch/x86/include/asm/idtentry.h:618
page last free pid 5831 tgid 5831 stack trace:
 reset_page_owner include/linux/page_owner.h:25 [inline]
 __free_pages_prepare mm/page_alloc.c:1402 [inline]
 free_unref_folios+0xcec/0x1480 mm/page_alloc.c:3004
 folios_put_refs+0xa3d/0xb80 mm/swap.c:1042
 free_pages_and_swap_cache+0x41d/0x490 mm/swap_state.c:404
 __tlb_batch_free_encoded_pages mm/mmu_gather.c:138 [inline]
 tlb_batch_pages_flush mm/mmu_gather.c:151 [inline]
 tlb_flush_mmu_free mm/mmu_gather.c:417 [inline]
 tlb_flush_mmu+0x6d3/0xa30 mm/mmu_gather.c:424
 tlb_finish_mmu+0xf9/0x230 mm/mmu_gather.c:549
 unmap_region+0x2a5/0x330 mm/vma.c:491
 vms_clear_ptes mm/vma.c:1303 [inline]
 vms_complete_munmap_vmas+0x493/0xc60 mm/vma.c:1345
 do_vmi_align_munmap+0x3b7/0x4b0 mm/vma.c:1604
 do_vmi_munmap+0x252/0x2d0 mm/vma.c:1652
 __vm_munmap+0x22c/0x3d0 mm/vma.c:3285
 __do_sys_munmap mm/mmap.c:1079 [inline]
 __se_sys_munmap mm/mmap.c:1076 [inline]
 __x64_sys_munmap+0x60/0x70 mm/mmap.c:1076
 do_syscall_x64 arch/x86/entry/syscall_64.c:63 [inline]
 do_syscall_64+0x15f/0xf80 arch/x86/entry/syscall_64.c:94
 entry_SYSCALL_64_after_hwframe+0x77/0x7f
Modules linked in:
CPU: 1 UID: 0 PID: 8855 Comm: syz.2.1435 Tainted: G    B               syzkaller #0 PREEMPT(full) 
Tainted: [B]=BAD_PAGE
Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS 1.16.2-debian-1.16.2-1 04/01/2014
Call Trace:
 <TASK>
 dump_stack_lvl+0xe8/0x150 lib/dump_stack.c:120
 bad_page+0x17f/0x1c0 mm/page_alloc.c:632
 free_page_is_bad mm/page_alloc.c:1073 [inline]
 __free_pages_prepare mm/page_alloc.c:1393 [inline]
 free_unref_folios+0xdcc/0x1480 mm/page_alloc.c:3004
 folio_batch_move_lru+0x816/0x9e0 mm/swap.c:206
 __folio_batch_add_and_move+0x510/0xc50 mm/swap.c:226
 folio_add_lru_vma+0x196/0x210 mm/swap.c:566
 map_anon_folio_pte_nopf+0x2ee/0x5e0 mm/memory.c:5301
 map_anon_folio_pte_pf+0xbe/0x260 mm/memory.c:5311
 do_anonymous_page mm/memory.c:5413 [inline]
 do_pte_missing+0x2d48/0x33f0 mm/memory.c:4548
 handle_pte_fault mm/memory.c:6411 [inline]
 __handle_mm_fault mm/memory.c:6549 [inline]
 handle_mm_fault+0x1bd7/0x3170 mm/memory.c:6718
 do_user_addr_fault+0xa73/0x1340 arch/x86/mm/fault.c:1334
 handle_page_fault arch/x86/mm/fault.c:1474 [inline]
 exc_page_fault+0x6a/0xc0 arch/x86/mm/fault.c:1527
 asm_exc_page_fault+0x26/0x30 arch/x86/include/asm/idtentry.h:618
RIP: 0033:0x7fca082696d2
Code: 48 89 ca 48 c1 e2 04 48 29 ca 48 8d 0d 5f c9 3a 00 48 c1 e2 04 48 01 c2 8b 44 24 1c c6 42 20 01 89 42 24 8b 44 24 24 89 6a 28 <89> 42 78 0f b6 44 24 43 89 72 2c 88 44 19 04 8b 44 24 20 31 c9 89
RSP: 002b:00007ffc5adb04c0 EFLAGS: 00010206
RAX: 0000000000000000 RBX: 0000000000000000 RCX: 00007fca08616018
RDX: 00007fca08615fa0 RSI: 0000000000000003 RDI: 0000000000000000
RBP: 0000000000001cd6 R08: 00007fca08615fa0 R09: 00007ffc5adb0357
R10: 0000000000000008 R11: 0000000000000246 R12: 0000000000000000
R13: 00007fca08615fac R14: 00007fca08615fa8 R15: 00007fca08615fa0
 </TASK>
BUG: Bad page state in process syz.2.1435  pfn:1af410
page: refcount:0 mapcount:0 mapping:0000000000000000 index:0x7f14c91fd pfn:0x1af410
flags: 0x57ff00000020908(uptodate|active|owner_2|swapbacked|node=1|zone=2|lastcpupid=0x7ff)
raw: 057ff00000020908 0000000000000000 dead000000000122 0000000000000000
raw: 00000007f14c91fd 0000000000000000 00000000ffffffff 0000000000000000
page dumped because: PAGE_FLAGS_CHECK_AT_FREE flag(s) set
page_owner tracks the page as allocated
page last allocated via order 0, migratetype Movable, gfp_mask 0x140dca(GFP_HIGHUSER_MOVABLE|__GFP_ZERO|__GFP_COMP), pid 8849, tgid 8846 (syz.0.1431), ts 86965683544, free_ts 69887122392
 set_page_owner include/linux/page_owner.h:32 [inline]
 post_alloc_hook+0x22d/0x280 mm/page_alloc.c:1858
 prep_new_page mm/page_alloc.c:1866 [inline]
 get_page_from_freelist+0x24ba/0x2540 mm/page_alloc.c:3946
 __alloc_frozen_pages_noprof+0x18d/0x380 mm/page_alloc.c:5226
 alloc_pages_mpol+0x235/0x490 mm/mempolicy.c:2490
 folio_alloc_mpol_noprof+0x39/0x160 mm/mempolicy.c:2509
 vma_alloc_folio_noprof+0xe1/0x1e0 mm/mempolicy.c:2544
 folio_prealloc mm/memory.c:-1 [inline]
 alloc_anon_folio mm/memory.c:5282 [inline]
 do_anonymous_page mm/memory.c:5376 [inline]
 do_pte_missing+0x159d/0x33f0 mm/memory.c:4548
 handle_pte_fault mm/memory.c:6411 [inline]
 __handle_mm_fault mm/memory.c:6549 [inline]
 handle_mm_fault+0x1bd7/0x3170 mm/memory.c:6718
 do_user_addr_fault+0xa73/0x1340 arch/x86/mm/fault.c:1334
 handle_page_fault arch/x86/mm/fault.c:1474 [inline]
 exc_page_fault+0x6a/0xc0 arch/x86/mm/fault.c:1527
 asm_exc_page_fault+0x26/0x30 arch/x86/include/asm/idtentry.h:618
page last free pid 5831 tgid 5831 stack trace:
 reset_page_owner include/linux/page_owner.h:25 [inline]
 __free_pages_prepare mm/page_alloc.c:1402 [inline]
 free_unref_folios+0xcec/0x1480 mm/page_alloc.c:3004
 folios_put_refs+0xa3d/0xb80 mm/swap.c:1042
 free_pages_and_swap_cache+0x41d/0x490 mm/swap_state.c:404
 __tlb_batch_free_encoded_pages mm/mmu_gather.c:138 [inline]
 tlb_batch_pages_flush mm/mmu_gather.c:151 [inline]
 tlb_flush_mmu_free mm/mmu_gather.c:417 [inline]
 tlb_flush_mmu+0x6d3/0xa30 mm/mmu_gather.c:424
 tlb_finish_mmu+0xf9/0x230 mm/mmu_gather.c:549
 unmap_region+0x2a5/0x330 mm/vma.c:491
 vms_clear_ptes mm/vma.c:1303 [inline]
 vms_complete_munmap_vmas+0x493/0xc60 mm/vma.c:1345
 do_vmi_align_munmap+0x3b7/0x4b0 mm/vma.c:1604
 do_vmi_munmap+0x252/0x2d0 mm/vma.c:1652
 __vm_munmap+0x22c/0x3d0 mm/vma.c:3285
 __do_sys_munmap mm/mmap.c:1079 [inline]
 __se_sys_munmap mm/mmap.c:1076 [inline]
 __x64_sys_munmap+0x60/0x70 mm/mmap.c:1076
 do_syscall_x64 arch/x86/entry/syscall_64.c:63 [inline]
 do_syscall_64+0x15f/0xf80 arch/x86/entry/syscall_64.c:94
 entry_SYSCALL_64_after_hwframe+0x77/0x7f
Modules linked in:
CPU: 1 UID: 0 PID: 8855 Comm: syz.2.1435 Tainted: G    B               syzkaller #0 PREEMPT(full) 
Tainted: [B]=BAD_PAGE
Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS 1.16.2-debian-1.16.2-1 04/01/2014
Call Trace:
 <TASK>
 dump_stack_lvl+0xe8/0x150 lib/dump_stack.c:120
 bad_page+0x17f/0x1c0 mm/page_alloc.c:632
 free_page_is_bad mm/page_alloc.c:1073 [inline]
 __free_pages_prepare mm/page_alloc.c:1393 [inline]
 free_unref_folios+0xdcc/0x1480 mm/page_alloc.c:3004
 folio_batch_move_lru+0x816/0x9e0 mm/swap.c:206
 __folio_batch_add_and_move+0x510/0xc50 mm/swap.c:226
 folio_add_lru_vma+0x196/0x210 mm/swap.c:566
 map_anon_folio_pte_nopf+0x2ee/0x5e0 mm/memory.c:5301
 map_anon_folio_pte_pf+0xbe/0x260 mm/memory.c:5311
 do_anonymous_page mm/memory.c:5413 [inline]
 do_pte_missing+0x2d48/0x33f0 mm/memory.c:4548
 handle_pte_fault mm/memory.c:6411 [inline]
 __handle_mm_fault mm/memory.c:6549 [inline]
 handle_mm_fault+0x1bd7/0x3170 mm/memory.c:6718
 do_user_addr_fault+0xa73/0x1340 arch/x86/mm/fault.c:1334
 handle_page_fault arch/x86/mm/fault.c:1474 [inline]
 exc_page_fault+0x6a/0xc0 arch/x86/mm/fault.c:1527
 asm_exc_page_fault+0x26/0x30 arch/x86/include/asm/idtentry.h:618
RIP: 0033:0x7fca082696d2
Code: 48 89 ca 48 c1 e2 04 48 29 ca 48 8d 0d 5f c9 3a 00 48 c1 e2 04 48 01 c2 8b 44 24 1c c6 42 20 01 89 42 24 8b 44 24 24 89 6a 28 <89> 42 78 0f b6 44 24 43 89 72 2c 88 44 19 04 8b 44 24 20 31 c9 89
RSP: 002b:00007ffc5adb04c0 EFLAGS: 00010206
RAX: 0000000000000000 RBX: 0000000000000000 RCX: 00007fca08616018
RDX: 00007fca08615fa0 RSI: 0000000000000003 RDI: 0000000000000000
RBP: 0000000000001cd6 R08: 00007fca08615fa0 R09: 00007ffc5adb0357
R10: 0000000000000008 R11: 0000000000000246 R12: 0000000000000000
R13: 00007fca08615fac R14: 00007fca08615fa8 R15: 00007fca08615fa0
 </TASK>
BUG: Bad page state in process syz.2.1435  pfn:1af411
page: refcount:0 mapcount:0 mapping:0000000000000000 index:0x7f14c9e12 pfn:0x1af411
flags: 0x57ff00000020908(uptodate|active|owner_2|swapbacked|node=1|zone=2|lastcpupid=0x7ff)
raw: 057ff00000020908 0000000000000000 dead000000000122 0000000000000000
raw: 00000007f14c9e12 0000000000000000 00000000ffffffff 0000000000000000
page dumped because: PAGE_FLAGS_CHECK_AT_FREE flag(s) set
page_owner tracks the page as allocated
page last allocated via order 0, migratetype Movable, gfp_mask 0x140cca(GFP_HIGHUSER_MOVABLE|__GFP_COMP), pid 8846, tgid 8846 (syz.0.1431), ts 86965789200, free_ts 69887126279
 set_page_owner include/linux/page_owner.h:32 [inline]
 post_alloc_hook+0x22d/0x280 mm/page_alloc.c:1858
 prep_new_page mm/page_alloc.c:1866 [inline]
 get_page_from_freelist+0x24ba/0x2540 mm/page_alloc.c:3946
 __alloc_frozen_pages_noprof+0x18d/0x380 mm/page_alloc.c:5226
 alloc_pages_mpol+0x235/0x490 mm/mempolicy.c:2490
 folio_alloc_mpol_noprof+0x39/0x160 mm/mempolicy.c:2509
 vma_alloc_folio_noprof+0xe1/0x1e0 mm/mempolicy.c:2544
 folio_prealloc mm/memory.c:-1 [inline]
 wp_page_copy mm/memory.c:3859 [inline]
 do_wp_page+0x118a/0x4cc0 mm/memory.c:4320
 handle_pte_fault mm/memory.c:6427 [inline]
 __handle_mm_fault mm/memory.c:6549 [inline]
 handle_mm_fault+0x151d/0x3170 mm/memory.c:6718
 do_user_addr_fault+0xa73/0x1340 arch/x86/mm/fault.c:1334
 handle_page_fault arch/x86/mm/fault.c:1474 [inline]
 exc_page_fault+0x6a/0xc0 arch/x86/mm/fault.c:1527
 asm_exc_page_fault+0x26/0x30 arch/x86/include/asm/idtentry.h:618
page last free pid 5831 tgid 5831 stack trace:
 reset_page_owner include/linux/page_owner.h:25 [inline]
 __free_pages_prepare mm/page_alloc.c:1402 [inline]
 free_unref_folios+0xcec/0x1480 mm/page_alloc.c:3004
 folios_put_refs+0xa3d/0xb80 mm/swap.c:1042
 free_pages_and_swap_cache+0x41d/0x490 mm/swap_state.c:404
 __tlb_batch_free_encoded_pages mm/mmu_gather.c:138 [inline]
 tlb_batch_pages_flush mm/mmu_gather.c:151 [inline]
 tlb_flush_mmu_free mm/mmu_gather.c:417 [inline]
 tlb_flush_mmu+0x6d3/0xa30 mm/mmu_gather.c:424
 tlb_finish_mmu+0xf9/0x230 mm/mmu_gather.c:549
 unmap_region+0x2a5/0x330 mm/vma.c:491
 vms_clear_ptes mm/vma.c:1303 [inline]
 vms_complete_munmap_vmas+0x493/0xc60 mm/vma.c:1345
 do_vmi_align_munmap+0x3b7/0x4b0 mm/vma.c:1604
 do_vmi_munmap+0x252/0x2d0 mm/vma.c:1652
 __vm_munmap+0x22c/0x3d0 mm/vma.c:3285
 __do_sys_munmap mm/mmap.c:1079 [inline]
 __se_sys_munmap mm/mmap.c:1076 [inline]
 __x64_sys_munmap+0x60/0x70 mm/mmap.c:1076
 do_syscall_x64 arch/x86/entry/syscall_64.c:63 [inline]
 do_syscall_64+0x15f/0xf80 arch/x86/entry/syscall_64.c:94
 entry_SYSCALL_64_after_hwframe+0x77/0x7f
Modules linked in:
CPU: 1 UID: 0 PID: 8855 Comm: syz.2.1435 Tainted: G    B               syzkaller #0 PREEMPT(full) 
Tainted: [B]=BAD_PAGE
Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS 1.16.2-debian-1.16.2-1 04/01/2014
Call Trace:
 <TASK>
 dump_stack_lvl+0xe8/0x150 lib/dump_stack.c:120
 bad_page+0x17f/0x1c0 mm/page_alloc.c:632
 free_page_is_bad mm/page_alloc.c:1073 [inline]
 __free_pages_prepare mm/page_alloc.c:1393 [inline]
 free_unref_folios+0xdcc/0x1480 mm/page_alloc.c:3004
 folio_batch_move_lru+0x816/0x9e0 mm/swap.c:206
 __folio_batch_add_and_move+0x510/0xc50 mm/swap.c:226
 folio_add_lru_vma+0x196/0x210 mm/swap.c:566
 map_anon_folio_pte_nopf+0x2ee/0x5e0 mm/memory.c:5301
 map_anon_folio_pte_pf+0xbe/0x260 mm/memory.c:5311
 do_anonymous_page mm/memory.c:5413 [inline]
 do_pte_missing+0x2d48/0x33f0 mm/memory.c:4548
 handle_pte_fault mm/memory.c:6411 [inline]
 __handle_mm_fault mm/memory.c:6549 [inline]
 handle_mm_fault+0x1bd7/0x3170 mm/memory.c:6718
 do_user_addr_fault+0xa73/0x1340 arch/x86/mm/fault.c:1334
 handle_page_fault arch/x86/mm/fault.c:1474 [inline]
 exc_page_fault+0x6a/0xc0 arch/x86/mm/fault.c:1527
 asm_exc_page_fault+0x26/0x30 arch/x86/include/asm/idtentry.h:618
RIP: 0033:0x7fca082696d2
Code: 48 89 ca 48 c1 e2 04 48 29 ca 48 8d 0d 5f c9 3a 00 48 c1 e2 04 48 01 c2 8b 44 24 1c c6 42 20 01 89 42 24 8b 44 24 24 89 6a 28 <89> 42 78 0f b6 44 24 43 89 72 2c 88 44 19 04 8b 44 24 20 31 c9 89
RSP: 002b:00007ffc5adb04c0 EFLAGS: 00010206
RAX: 0000000000000000 RBX: 0000000000000000 RCX: 00007fca08616018
RDX: 00007fca08615fa0 RSI: 0000000000000003 RDI: 0000000000000000
RBP: 0000000000001cd6 R08: 00007fca08615fa0 R09: 00007ffc5adb0357
R10: 0000000000000008 R11: 0000000000000246 R12: 0000000000000000
R13: 00007fca08615fac R14: 00007fca08615fa8 R15: 00007fca08615fa0
 </TASK>
BUG: Bad page state in process syz.2.1435  pfn:1af40b
page: refcount:0 mapcount:0 mapping:0000000000000000 index:0x555573b0d pfn:0x1af40b
flags: 0x57ff0000002090c(referenced|uptodate|active|owner_2|swapbacked|node=1|zone=2|lastcpupid=0x7ff)
raw: 057ff0000002090c 0000000000000000 dead000000000122 0000000000000000
raw: 0000000555573b0d 0000000000000000 00000000ffffffff 0000000000000000
page dumped because: PAGE_FLAGS_CHECK_AT_FREE flag(s) set
page_owner tracks the page as allocated
page last allocated via order 0, migratetype Movable, gfp_mask 0x140cca(GFP_HIGHUSER_MOVABLE|__GFP_COMP), pid 8851, tgid 8851 (syz-executor), ts 86975719417, free_ts 86967133373
 set_page_owner include/linux/page_owner.h:32 [inline]
 post_alloc_hook+0x22d/0x280 mm/page_alloc.c:1858
 prep_new_page mm/page_alloc.c:1866 [inline]
 get_page_from_freelist+0x24ba/0x2540 mm/page_alloc.c:3946
 __alloc_frozen_pages_noprof+0x18d/0x380 mm/page_alloc.c:5226
 alloc_pages_mpol+0x235/0x490 mm/mempolicy.c:2490
 folio_alloc_mpol_noprof+0x39/0x160 mm/mempolicy.c:2509
 vma_alloc_folio_noprof+0xe1/0x1e0 mm/mempolicy.c:2544
 folio_prealloc mm/memory.c:-1 [inline]
 wp_page_copy mm/memory.c:3859 [inline]
 do_wp_page+0x118a/0x4cc0 mm/memory.c:4320
 handle_pte_fault mm/memory.c:6427 [inline]
 __handle_mm_fault mm/memory.c:6549 [inline]
 handle_mm_fault+0x151d/0x3170 mm/memory.c:6718
 do_user_addr_fault+0x75b/0x1340 arch/x86/mm/fault.c:1385
 handle_page_fault arch/x86/mm/fault.c:1474 [inline]
 exc_page_fault+0x6a/0xc0 arch/x86/mm/fault.c:1527
 asm_exc_page_fault+0x26/0x30 arch/x86/include/asm/idtentry.h:618
page last free pid 8849 tgid 8846 stack trace:
 reset_page_owner include/linux/page_owner.h:25 [inline]
 __free_pages_prepare mm/page_alloc.c:1402 [inline]
 free_unref_folios+0xcec/0x1480 mm/page_alloc.c:3004
 folios_put_refs+0xa3d/0xb80 mm/swap.c:1042
 free_pages_and_swap_cache+0x41d/0x490 mm/swap_state.c:404
 __tlb_batch_free_encoded_pages mm/mmu_gather.c:138 [inline]
 tlb_batch_pages_flush mm/mmu_gather.c:151 [inline]
 tlb_flush_mmu_free mm/mmu_gather.c:417 [inline]
 tlb_flush_mmu+0x6d3/0xa30 mm/mmu_gather.c:424
 tlb_finish_mmu+0xf9/0x230 mm/mmu_gather.c:549
 exit_mmap+0x498/0x9e0 mm/mmap.c:1313
 __mmput+0x118/0x430 kernel/fork.c:1178
 exit_mm+0x18e/0x250 kernel/exit.c:581
 do_exit+0x6a2/0x22c0 kernel/exit.c:963
 do_group_exit+0x21b/0x2d0 kernel/exit.c:1117
 get_signal+0x1284/0x1330 kernel/signal.c:3037
 arch_do_signal_or_restart+0xbc/0x830 arch/x86/kernel/signal.c:337
 __exit_to_user_mode_loop kernel/entry/common.c:64 [inline]
 exit_to_user_mode_loop+0x86/0x480 kernel/entry/common.c:98
 __exit_to_user_mode_prepare include/linux/irq-entry-common.h:207 [inline]
 syscall_exit_to_user_mode_prepare include/linux/irq-entry-common.h:238 [inline]
 syscall_exit_to_user_mode include/linux/entry-common.h:328 [inline]
 do_syscall_64+0x33e/0xf80 arch/x86/entry/syscall_64.c:100
 entry_SYSCALL_64_after_hwframe+0x77/0x7f
Modules linked in:

CPU: 1 UID: 0 PID: 8855 Comm: syz.2.1435 Tainted: G    B               syzkaller #0 PREEMPT(full) 
Tainted: [B]=BAD_PAGE
Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS 1.16.2-debian-1.16.2-1 04/01/2014
Call Trace:
 <TASK>
 dump_stack_lvl+0xe8/0x150 lib/dump_stack.c:120
 bad_page+0x17f/0x1c0 mm/page_alloc.c:632
 free_page_is_bad mm/page_alloc.c:1073 [inline]
 __free_pages_prepare mm/page_alloc.c:1393 [inline]
 free_unref_folios+0xdcc/0x1480 mm/page_alloc.c:3004
 folio_batch_move_lru+0x816/0x9e0 mm/swap.c:206
 __folio_batch_add_and_move+0x510/0xc50 mm/swap.c:226
 folio_add_lru_vma+0x196/0x210 mm/swap.c:566
 map_anon_folio_pte_nopf+0x2ee/0x5e0 mm/memory.c:5301
 map_anon_folio_pte_pf+0xbe/0x260 mm/memory.c:5311
 do_anonymous_page mm/memory.c:5413 [inline]
 do_pte_missing+0x2d48/0x33f0 mm/memory.c:4548
 handle_pte_fault mm/memory.c:6411 [inline]
 __handle_mm_fault mm/memory.c:6549 [inline]
 handle_mm_fault+0x1bd7/0x3170 mm/memory.c:6718
 do_user_addr_fault+0xa73/0x1340 arch/x86/mm/fault.c:1334
 handle_page_fault arch/x86/mm/fault.c:1474 [inline]
 exc_page_fault+0x6a/0xc0 arch/x86/mm/fault.c:1527
 asm_exc_page_fault+0x26/0x30 arch/x86/include/asm/idtentry.h:618
RIP: 0033:0x7fca082696d2
Code: 48 89 ca 48 c1 e2 04 48 29 ca 48 8d 0d 5f c9 3a 00 48 c1 e2 04 48 01 c2 8b 44 24 1c c6 42 20 01 89 42 24 8b 44 24 24 89 6a 28 <89> 42 78 0f b6 44 24 43 89 72 2c 88 44 19 04 8b 44 24 20 31 c9 89
RSP: 002b:00007ffc5adb04c0 EFLAGS: 00010206
RAX: 0000000000000000 RBX: 0000000000000000 RCX: 00007fca08616018
RDX: 00007fca08615fa0 RSI: 0000000000000003 RDI: 0000000000000000
RBP: 0000000000001cd6 R08: 00007fca08615fa0 R09: 00007ffc5adb0357
R10: 0000000000000008 R11: 0000000000000246 R12: 0000000000000000
R13: 00007fca08615fac R14: 00007fca08615fa8 R15: 00007fca08615fa0
 </TASK>
BUG: Bad page state in process syz.2.1435  pfn:1af409
page: refcount:0 mapcount:0 mapping:0000000000000000 index:0x3ec pfn:0x1af409
flags: 0x57ff00000020908(uptodate|active|owner_2|swapbacked|node=1|zone=2|lastcpupid=0x7ff)
raw: 057ff00000020908 0000000000000000 dead000000000122 0000000000000000
raw: 00000000000003ec 0000000000000000 00000000ffffffff 0000000000000000
page dumped because: PAGE_FLAGS_CHECK_AT_FREE flag(s) set
page_owner tracks the page as allocated
page last allocated via order 0, migratetype Movable, gfp_mask 0x140cca(GFP_HIGHUSER_MOVABLE|__GFP_COMP), pid 8851, tgid 8851 (syz-executor), ts 86976014509, free_ts 86967128194
 set_page_owner include/linux/page_owner.h:32 [inline]
 post_alloc_hook+0x22d/0x280 mm/page_alloc.c:1858
 prep_new_page mm/page_alloc.c:1866 [inline]
 get_page_from_freelist+0x24ba/0x2540 mm/page_alloc.c:3946
 __alloc_frozen_pages_noprof+0x18d/0x380 mm/page_alloc.c:5226
 alloc_pages_mpol+0x235/0x490 mm/mempolicy.c:2490
 folio_alloc_mpol_noprof+0x39/0x160 mm/mempolicy.c:2509
 vma_alloc_folio_noprof+0xe1/0x1e0 mm/mempolicy.c:2544
 folio_prealloc mm/memory.c:-1 [inline]
 wp_page_copy mm/memory.c:3859 [inline]
 do_wp_page+0x118a/0x4cc0 mm/memory.c:4320
 handle_pte_fault mm/memory.c:6427 [inline]
 __handle_mm_fault mm/memory.c:6549 [inline]
 handle_mm_fault+0x151d/0x3170 mm/memory.c:6718
 do_user_addr_fault+0xa73/0x1340 arch/x86/mm/fault.c:1334
 handle_page_fault arch/x86/mm/fault.c:1474 [inline]
 exc_page_fault+0x6a/0xc0 arch/x86/mm/fault.c:1527
 asm_exc_page_fault+0x26/0x30 arch/x86/include/asm/idtentry.h:618
page last free pid 8849 tgid 8846 stack trace:
 reset_page_owner include/linux/page_owner.h:25 [inline]
 __free_pages_prepare mm/page_alloc.c:1402 [inline]
 free_unref_folios+0xcec/0x1480 mm/page_alloc.c:3004
 folios_put_refs+0xa3d/0xb80 mm/swap.c:1042
 free_pages_and_swap_cache+0x41d/0x490 mm/swap_state.c:404
 __tlb_batch_free_encoded_pages mm/mmu_gather.c:138 [inline]
 tlb_batch_pages_flush mm/mmu_gather.c:151 [inline]
 tlb_flush_mmu_free mm/mmu_gather.c:417 [inline]
 tlb_flush_mmu+0x6d3/0xa30 mm/mmu_gather.c:424
 tlb_finish_mmu+0xf9/0x230 mm/mmu_gather.c:549
 exit_mmap+0x498/0x9e0 mm/mmap.c:1313
 __mmput+0x118/0x430 kernel/fork.c:1178
 exit_mm+0x18e/0x250 kernel/exit.c:581
 do_exit+0x6a2/0x22c0 kernel/exit.c:963
 do_group_exit+0x21b/0x2d0 kernel/exit.c:1117
 get_signal+0x1284/0x1330 kernel/signal.c:3037
 arch_do_signal_or_restart+0xbc/0x830 arch/x86/kernel/signal.c:337
 __exit_to_user_mode_loop kernel/entry/common.c:64 [inline]
 exit_to_user_mode_loop+0x86/0x480 kernel/entry/common.c:98
 __exit_to_user_mode_prepare include/linux/irq-entry-common.h:207 [inline]
 syscall_exit_to_user_mode_prepare include/linux/irq-entry-common.h:238 [inline]
 syscall_exit_to_user_mode include/linux/entry-common.h:328 [inline]
 do_syscall_64+0x33e/0xf80 arch/x86/entry/syscall_64.c:100
 entry_SYSCALL_64_after_hwframe+0x77/0x7f
Modules linked in:

CPU: 1 UID: 0 PID: 8855 Comm: syz.2.1435 Tainted: G    B               syzkaller #0 PREEMPT(full) 
Tainted: [B]=BAD_PAGE
Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS 1.16.2-debian-1.16.2-1 04/01/2014
Call Trace:
 <TASK>
 dump_stack_lvl+0xe8/0x150 lib/dump_stack.c:120
 bad_page+0x17f/0x1c0 mm/page_alloc.c:632
 free_page_is_bad mm/page_alloc.c:1073 [inline]
 __free_pages_prepare mm/page_alloc.c:1393 [inline]
 free_unref_folios+0xdcc/0x1480 mm/page_alloc.c:3004
 folio_batch_move_lru+0x816/0x9e0 mm/swap.c:206
 __folio_batch_add_and_move+0x510/0xc50 mm/swap.c:226
 folio_add_lru_vma+0x196/0x210 mm/swap.c:566
 map_anon_folio_pte_nopf+0x2ee/0x5e0 mm/memory.c:5301
 map_anon_folio_pte_pf+0xbe/0x260 mm/memory.c:5311
 do_anonymous_page mm/memory.c:5413 [inline]
 do_pte_missing+0x2d48/0x33f0 mm/memory.c:4548
 handle_pte_fault mm/memory.c:6411 [inline]
 __handle_mm_fault mm/memory.c:6549 [inline]
 handle_mm_fault+0x1bd7/0x3170 mm/memory.c:6718
 do_user_addr_fault+0xa73/0x1340 arch/x86/mm/fault.c:1334
 handle_page_fault arch/x86/mm/fault.c:1474 [inline]
 exc_page_fault+0x6a/0xc0 arch/x86/mm/fault.c:1527
 asm_exc_page_fault+0x26/0x30 arch/x86/include/asm/idtentry.h:618
RIP: 0033:0x7fca082696d2
Code: 48 89 ca 48 c1 e2 04 48 29 ca 48 8d 0d 5f c9 3a 00 48 c1 e2 04 48 01 c2 8b 44 24 1c c6 42 20 01 89 42 24 8b 44 24 24 89 6a 28 <89> 42 78 0f b6 44 24 43 89 72 2c 88 44 19 04 8b 44 24 20 31 c9 89
RSP: 002b:00007ffc5adb04c0 EFLAGS: 00010206
RAX: 0000000000000000 RBX: 0000000000000000 RCX: 00007fca08616018
RDX: 00007fca08615fa0 RSI: 0000000000000003 RDI: 0000000000000000
RBP: 0000000000001cd6 R08: 00007fca08615fa0 R09: 00007ffc5adb0357
R10: 0000000000000008 R11: 0000000000000246 R12: 0000000000000000
R13: 00007fca08615fac R14: 00007fca08615fa8 R15: 00007fca08615fa0
 </TASK>
BUG: Bad page state in process syz.2.1435  pfn:1af571
page: refcount:0 mapcount:0 mapping:0000000000000000 index:0x7f14ca945 pfn:0x1af571
flags: 0x57ff00000020908(uptodate|active|owner_2|swapbacked|node=1|zone=2|lastcpupid=0x7ff)
raw: 057ff00000020908 0000000000000000 dead000000000122 0000000000000000
raw: 00000007f14ca945 0000000000000000 00000000ffffffff 0000000000000000
page dumped because: PAGE_FLAGS_CHECK_AT_FREE flag(s) set
page_owner tracks the page as allocated
page last allocated via order 0, migratetype Movable, gfp_mask 0x140cca(GFP_HIGHUSER_MOVABLE|__GFP_COMP), pid 8851, tgid 8851 (syz-executor), ts 86978306736, free_ts 86967122819
 set_page_owner include/linux/page_owner.h:32 [inline]
 post_alloc_hook+0x22d/0x280 mm/page_alloc.c:1858
 prep_new_page mm/page_alloc.c:1866 [inline]
 get_page_from_freelist+0x24ba/0x2540 mm/page_alloc.c:3946
 __alloc_frozen_pages_noprof+0x18d/0x380 mm/page_alloc.c:5226
 alloc_pages_mpol+0x235/0x490 mm/mempolicy.c:2490
 folio_alloc_mpol_noprof+0x39/0x160 mm/mempolicy.c:2509
 vma_alloc_folio_noprof+0xe1/0x1e0 mm/mempolicy.c:2544
 folio_prealloc mm/memory.c:-1 [inline]
 wp_page_copy mm/memory.c:3859 [inline]
 do_wp_page+0x118a/0x4cc0 mm/memory.c:4320
 handle_pte_fault mm/memory.c:6427 [inline]
 __handle_mm_fault mm/memory.c:6549 [inline]
 handle_mm_fault+0x151d/0x3170 mm/memory.c:6718
 do_user_addr_fault+0xa73/0x1340 arch/x86/mm/fault.c:1334
 handle_page_fault arch/x86/mm/fault.c:1474 [inline]
 exc_page_fault+0x6a/0xc0 arch/x86/mm/fault.c:1527
 asm_exc_page_fault+0x26/0x30 arch/x86/include/asm/idtentry.h:618
page last free pid 8849 tgid 8846 stack trace:
 reset_page_owner include/linux/page_owner.h:25 [inline]
 __free_pages_prepare mm/page_alloc.c:1402 [inline]
 free_unref_folios+0xcec/0x1480 mm/page_alloc.c:3004
 folios_put_refs+0xa3d/0xb80 mm/swap.c:1042
 free_pages_and_swap_cache+0x41d/0x490 mm/swap_state.c:404
 __tlb_batch_free_encoded_pages mm/mmu_gather.c:138 [inline]
 tlb_batch_pages_flush mm/mmu_gather.c:151 [inline]
 tlb_flush_mmu_free mm/mmu_gather.c:417 [inline]
 tlb_flush_mmu+0x6d3/0xa30 mm/mmu_gather.c:424
 tlb_finish_mmu+0xf9/0x230 mm/mmu_gather.c:549
 exit_mmap+0x498/0x9e0 mm/mmap.c:1313
 __mmput+0x118/0x430 kernel/fork.c:1178
 exit_mm+0x18e/0x250 kernel/exit.c:581
 do_exit+0x6a2/0x22c0 kernel/exit.c:963
 do_group_exit+0x21b/0x2d0 kernel/exit.c:1117
 get_signal+0x1284/0x1330 kernel/signal.c:3037
 arch_do_signal_or_restart+0xbc/0x830 arch/x86/kernel/signal.c:337
 __exit_to_user_mode_loop kernel/entry/common.c:64 [inline]
 exit_to_user_mode_loop+0x86/0x480 kernel/entry/common.c:98
 __exit_to_user_mode_prepare include/linux/irq-entry-common.h:207 [inline]
 syscall_exit_to_user_mode_prepare include/linux/irq-entry-common.h:238 [inline]
 syscall_exit_to_user_mode include/linux/entry-common.h:328 [inline]
 do_syscall_64+0x33e/0xf80 arch/x86/entry/syscall_64.c:100
 entry_SYSCALL_64_after_hwframe+0x77/0x7f
Modules linked in:

CPU: 1 UID: 0 PID: 8855 Comm: syz.2.1435 Tainted: G    B               syzkaller #0 PREEMPT(full) 
Tainted: [B]=BAD_PAGE
Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS 1.16.2-debian-1.16.2-1 04/01/2014
Call Trace:
 <TASK>
 dump_stack_lvl+0xe8/0x150 lib/dump_stack.c:120
 bad_page+0x17f/0x1c0 mm/page_alloc.c:632
 free_page_is_bad mm/page_alloc.c:1073 [inline]
 __free_pages_prepare mm/page_alloc.c:1393 [inline]
 free_unref_folios+0xdcc/0x1480 mm/page_alloc.c:3004
 folio_batch_move_lru+0x816/0x9e0 mm/swap.c:206
 __folio_batch_add_and_move+0x510/0xc50 mm/swap.c:226
 folio_add_lru_vma+0x196/0x210 mm/swap.c:566
 map_anon_folio_pte_nopf+0x2ee/0x5e0 mm/memory.c:5301
 map_anon_folio_pte_pf+0xbe/0x260 mm/memory.c:5311
 do_anonymous_page mm/memory.c:5413 [inline]
 do_pte_missing+0x2d48/0x33f0 mm/memory.c:4548
 handle_pte_fault mm/memory.c:6411 [inline]
 __handle_mm_fault mm/memory.c:6549 [inline]
 handle_mm_fault+0x1bd7/0x3170 mm/memory.c:6718
 do_user_addr_fault+0xa73/0x1340 arch/x86/mm/fault.c:1334
 handle_page_fault arch/x86/mm/fault.c:1474 [inline]
 exc_page_fault+0x6a/0xc0 arch/x86/mm/fault.c:1527
 asm_exc_page_fault+0x26/0x30 arch/x86/include/asm/idtentry.h:618
RIP: 0033:0x7fca082696d2
Code: 48 89 ca 48 c1 e2 04 48 29 ca 48 8d 0d 5f c9 3a 00 48 c1 e2 04 48 01 c2 8b 44 24 1c c6 42 20 01 89 42 24 8b 44 24 24 89 6a 28 <89> 42 78 0f b6 44 24 43 89 72 2c 88 44 19 04 8b 44 24 20 31 c9 89
RSP: 002b:00007ffc5adb04c0 EFLAGS: 00010206
RAX: 0000000000000000 RBX: 0000000000000000 RCX: 00007fca08616018
RDX: 00007fca08615fa0 RSI: 0000000000000003 RDI: 0000000000000000
RBP: 0000000000001cd6 R08: 00007fca08615fa0 R09: 00007ffc5adb0357
R10: 0000000000000008 R11: 0000000000000246 R12: 0000000000000000
R13: 00007fca08615fac R14: 00007fca08615fa8 R15: 00007fca08615fa0
 </TASK>
BUG: Bad page state in process syz.2.1435  pfn:1af40c
page: refcount:0 mapcount:0 mapping:0000000000000000 index:0x7f14c9e15 pfn:0x1af40c
flags: 0x57ff00000020908(uptodate|active|owner_2|swapbacked|node=1|zone=2|lastcpupid=0x7ff)
raw: 057ff00000020908 0000000000000000 dead000000000122 0000000000000000
raw: 00000007f14c9e15 0000000000000000 00000000ffffffff 0000000000000000
page dumped because: PAGE_FLAGS_CHECK_AT_FREE flag(s) set
page_owner tracks the page as allocated
page last allocated via order 0, migratetype Movable, gfp_mask 0x140dca(GFP_HIGHUSER_MOVABLE|__GFP_ZERO|__GFP_COMP), pid 8851, tgid 8851 (syz.0.1434), ts 86978464147, free_ts 86967036690
 set_page_owner include/linux/page_owner.h:32 [inline]
 post_alloc_hook+0x22d/0x280 mm/page_alloc.c:1858
 prep_new_page mm/page_alloc.c:1866 [inline]
 get_page_from_freelist+0x24ba/0x2540 mm/page_alloc.c:3946
 __alloc_frozen_pages_noprof+0x18d/0x380 mm/page_alloc.c:5226
 alloc_pages_mpol+0x235/0x490 mm/mempolicy.c:2490
 folio_alloc_mpol_noprof+0x39/0x160 mm/mempolicy.c:2509
 vma_alloc_folio_noprof+0xe1/0x1e0 mm/mempolicy.c:2544
 folio_prealloc mm/memory.c:-1 [inline]
 wp_page_copy mm/memory.c:3859 [inline]
 do_wp_page+0x118a/0x4cc0 mm/memory.c:4320
 handle_pte_fault mm/memory.c:6427 [inline]
 __handle_mm_fault mm/memory.c:6549 [inline]
 handle_mm_fault+0x151d/0x3170 mm/memory.c:6718
 do_user_addr_fault+0xa73/0x1340 arch/x86/mm/fault.c:1334
 handle_page_fault arch/x86/mm/fault.c:1474 [inline]
 exc_page_fault+0x6a/0xc0 arch/x86/mm/fault.c:1527
 asm_exc_page_fault+0x26/0x30 arch/x86/include/asm/idtentry.h:618
page last free pid 8849 tgid 8846 stack trace:
 reset_page_owner include/linux/page_owner.h:25 [inline]
 __free_pages_prepare mm/page_alloc.c:1402 [inline]
 free_unref_folios+0xcec/0x1480 mm/page_alloc.c:3004
 folios_put_refs+0xa3d/0xb80 mm/swap.c:1042
 free_pages_and_swap_cache+0x41d/0x490 mm/swap_state.c:404
 __tlb_batch_free_encoded_pages mm/mmu_gather.c:138 [inline]
 tlb_batch_pages_flush mm/mmu_gather.c:151 [inline]
 tlb_flush_mmu_free mm/mmu_gather.c:417 [inline]
 tlb_flush_mmu+0x6d3/0xa30 mm/mmu_gather.c:424
 tlb_finish_mmu+0xf9/0x230 mm/mmu_gather.c:549
 exit_mmap+0x498/0x9e0 mm/mmap.c:1313
 __mmput+0x118/0x430 kernel/fork.c:1178
 exit_mm+0x18e/0x250 kernel/exit.c:581
 do_exit+0x6a2/0x22c0 kernel/exit.c:963
 do_group_exit+0x21b/0x2d0 kernel/exit.c:1117
 get_signal+0x1284/0x1330 kernel/signal.c:3037
 arch_do_signal_or_restart+0xbc/0x830 arch/x86/kernel/signal.c:337
 __exit_to_user_mode_loop kernel/entry/common.c:64 [inline]
 exit_to_user_mode_loop+0x86/0x480 kernel/entry/common.c:98
 __exit_to_user_mode_prepare include/linux/irq-entry-common.h:207 [inline]
 syscall_exit_to_user_mode_prepare include/linux/irq-entry-common.h:238 [inline]
 syscall_exit_to_user_mode include/linux/entry-common.h:328 [inline]
 do_syscall_64+0x33e/0xf80 arch/x86/entry/syscall_64.c:100
 entry_SYSCALL_64_after_hwframe+0x77/0x7f
Modules linked in:
CPU: 1 UID: 0 PID: 8855 Comm: syz.2.1435 Tainted: G    B               syzkaller #0 PREEMPT(full) 
Tainted: [B]=BAD_PAGE
Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS 1.16.2-debian-1.16.2-1 04/01/2014
Call Trace:
 <TASK>
 dump_stack_lvl+0xe8/0x150 lib/dump_stack.c:120
 bad_page+0x17f/0x1c0 mm/page_alloc.c:632
 free_page_is_bad mm/page_alloc.c:1073 [inline]
 __free_pages_prepare mm/page_alloc.c:1393 [inline]
 free_unref_folios+0xdcc/0x1480 mm/page_alloc.c:3004
 folio_batch_move_lru+0x816/0x9e0 mm/swap.c:206
 __folio_batch_add_and_move+0x510/0xc50 mm/swap.c:226
 folio_add_lru_vma+0x196/0x210 mm/swap.c:566
 map_anon_folio_pte_nopf+0x2ee/0x5e0 mm/memory.c:5301
 map_anon_folio_pte_pf+0xbe/0x260 mm/memory.c:5311
 do_anonymous_page mm/memory.c:5413 [inline]
 do_pte_missing+0x2d48/0x33f0 mm/memory.c:4548
 handle_pte_fault mm/memory.c:6411 [inline]
 __handle_mm_fault mm/memory.c:6549 [inline]
 handle_mm_fault+0x1bd7/0x3170 mm/memory.c:6718
 do_user_addr_fault+0xa73/0x1340 arch/x86/mm/fault.c:1334
 handle_page_fault arch/x86/mm/fault.c:1474 [inline]
 exc_page_fault+0x6a/0xc0 arch/x86/mm/fault.c:1527
 asm_exc_page_fault+0x26/0x30 arch/x86/include/asm/idtentry.h:618
RIP: 0033:0x7fca082696d2
Code: 48 89 ca 48 c1 e2 04 48 29 ca 48 8d 0d 5f c9 3a 00 48 c1 e2 04 48 01 c2 8b 44 24 1c c6 42 20 01 89 42 24 8b 44 24 24 89 6a 28 <89> 42 78 0f b6 44 24 43 89 72 2c 88 44 19 04 8b 44 24 20 31 c9 89
RSP: 002b:00007ffc5adb04c0 EFLAGS: 00010206
RAX: 0000000000000000 RBX: 0000000000000000 RCX: 00007fca08616018
RDX: 00007fca08615fa0 RSI: 0000000000000003 RDI: 0000000000000000
RBP: 0000000000001cd6 R08: 00007fca08615fa0 R09: 00007ffc5adb0357
R10: 0000000000000008 R11: 0000000000000246 R12: 0000000000000000
R13: 00007fca08615fac R14: 00007fca08615fa8 R15: 00007fca08615fa0
 </TASK>
BUG: Bad page state in process syz.2.1435  pfn:1af40d
page: refcount:0 mapcount:0 mapping:0000000000000000 index:0x7f14c91fe pfn:0x1af40d
flags: 0x57ff00000020908(uptodate|active|owner_2|swapbacked|node=1|zone=2|lastcpupid=0x7ff)
raw: 057ff00000020908 0000000000000000 dead000000000122 0000000000000000
raw: 00000007f14c91fe 0000000000000000 00000000ffffffff 0000000000000000
page dumped because: PAGE_FLAGS_CHECK_AT_FREE flag(s) set
page_owner tracks the page as allocated
page last allocated via order 0, migratetype Movable, gfp_mask 0x140dca(GFP_HIGHUSER_MOVABLE|__GFP_ZERO|__GFP_COMP), pid 8851, tgid 8851 (syz.0.1434), ts 86979644815, free_ts 86967032365
 set_page_owner include/linux/page_owner.h:32 [inline]
 post_alloc_hook+0x22d/0x280 mm/page_alloc.c:1858
 prep_new_page mm/page_alloc.c:1866 [inline]
 get_page_from_freelist+0x24ba/0x2540 mm/page_alloc.c:3946
 __alloc_frozen_pages_noprof+0x18d/0x380 mm/page_alloc.c:5226
 alloc_pages_mpol+0x235/0x490 mm/mempolicy.c:2490
 folio_alloc_mpol_noprof+0x39/0x160 mm/mempolicy.c:2509
 vma_alloc_folio_noprof+0xe1/0x1e0 mm/mempolicy.c:2544
 folio_prealloc mm/memory.c:-1 [inline]
 alloc_anon_folio mm/memory.c:5282 [inline]
 do_anonymous_page mm/memory.c:5376 [inline]
 do_pte_missing+0x159d/0x33f0 mm/memory.c:4548
 handle_pte_fault mm/memory.c:6411 [inline]
 __handle_mm_fault mm/memory.c:6549 [inline]
 handle_mm_fault+0x1bd7/0x3170 mm/memory.c:6718
 do_user_addr_fault+0xa73/0x1340 arch/x86/mm/fault.c:1334
 handle_page_fault arch/x86/mm/fault.c:1474 [inline]
 exc_page_fault+0x6a/0xc0 arch/x86/mm/fault.c:1527
 asm_exc_page_fault+0x26/0x30 arch/x86/include/asm/idtentry.h:618
page last free pid 8849 tgid 8846 stack trace:
 reset_page_owner include/linux/page_owner.h:25 [inline]
 __free_pages_prepare mm/page_alloc.c:1402 [inline]
 free_unref_folios+0xcec/0x1480 mm/page_alloc.c:3004
 folios_put_refs+0xa3d/0xb80 mm/swap.c:1042
 free_pages_and_swap_cache+0x41d/0x490 mm/swap_state.c:404
 __tlb_batch_free_encoded_pages mm/mmu_gather.c:138 [inline]
 tlb_batch_pages_flush mm/mmu_gather.c:151 [inline]
 tlb_flush_mmu_free mm/mmu_gather.c:417 [inline]
 tlb_flush_mmu+0x6d3/0xa30 mm/mmu_gather.c:424
 tlb_finish_mmu+0xf9/0x230 mm/mmu_gather.c:549
 exit_mmap+0x498/0x9e0 mm/mmap.c:1313
 __mmput+0x118/0x430 kernel/fork.c:1178
 exit_mm+0x18e/0x250 kernel/exit.c:581
 do_exit+0x6a2/0x22c0 kernel/exit.c:963
 do_group_exit+0x21b/0x2d0 kernel/exit.c:1117
 get_signal+0x1284/0x1330 kernel/signal.c:3037
 arch_do_signal_or_restart+0xbc/0x830 arch/x86/kernel/signal.c:337
 __exit_to_user_mode_loop kernel/entry/common.c:64 [inline]
 exit_to_user_mode_loop+0x86/0x480 kernel/entry/common.c:98
 __exit_to_user_mode_prepare include/linux/irq-entry-common.h:207 [inline]
 syscall_exit_to_user_mode_prepare include/linux/irq-entry-common.h:238 [inline]
 syscall_exit_to_user_mode include/linux/entry-common.h:328 [inline]
 do_syscall_64+0x33e/0xf80 arch/x86/entry/syscall_64.c:100
 entry_SYSCALL_64_after_hwframe+0x77/0x7f
Modules linked in:
CPU: 1 UID: 0 PID: 8855 Comm: syz.2.1435 Tainted: G    B               syzkaller #0 PREEMPT(full) 
Tainted: [B]=BAD_PAGE
Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS 1.16.2-debian-1.16.2-1 04/01/2014
Call Trace:
 <TASK>
 dump_stack_lvl+0xe8/0x150 lib/dump_stack.c:120
 bad_page+0x17f/0x1c0 mm/page_alloc.c:632
 free_page_is_bad mm/page_alloc.c:1073 [inline]
 __free_pages_prepare mm/page_alloc.c:1393 [inline]
 free_unref_folios+0xdcc/0x1480 mm/page_alloc.c:3004
 folio_batch_move_lru+0x816/0x9e0 mm/swap.c:206
 __folio_batch_add_and_move+0x510/0xc50 mm/swap.c:226
 folio_add_lru_vma+0x196/0x210 mm/swap.c:566
 map_anon_folio_pte_nopf+0x2ee/0x5e0 mm/memory.c:5301
 map_anon_folio_pte_pf+0xbe/0x260 mm/memory.c:5311
 do_anonymous_page mm/memory.c:5413 [inline]
 do_pte_missing+0x2d48/0x33f0 mm/memory.c:4548
 handle_pte_fault mm/memory.c:6411 [inline]
 __handle_mm_fault mm/memory.c:6549 [inline]
 handle_mm_fault+0x1bd7/0x3170 mm/memory.c:6718
 do_user_addr_fault+0xa73/0x1340 arch/x86/mm/fault.c:1334
 handle_page_fault arch/x86/mm/fault.c:1474 [inline]
 exc_page_fault+0x6a/0xc0 arch/x86/mm/fault.c:1527
 asm_exc_page_fault+0x26/0x30 arch/x86/include/asm/idtentry.h:618
RIP: 0033:0x7fca082696d2
Code: 48 89 ca 48 c1 e2 04 48 29 ca 48 8d 0d 5f c9 3a 00 48 c1 e2 04 48 01 c2 8b 44 24 1c c6 42 20 01 89 42 24 8b 44 24 24 89 6a 28 <89> 42 78 0f b6 44 24 43 89 72 2c 88 44 19 04 8b 44 24 20 31 c9 89
RSP: 002b:00007ffc5adb04c0 EFLAGS: 00010206
RAX: 0000000000000000 RBX: 0000000000000000 RCX: 00007fca08616018
RDX: 00007fca08615fa0 RSI: 0000000000000003 RDI: 0000000000000000
RBP: 0000000000001cd6 R08: 00007fca08615fa0 R09: 00007ffc5adb0357
R10: 0000000000000008 R11: 0000000000000246 R12: 0000000000000000
R13: 00007fca08615fac R14: 00007fca08615fa8 R15: 00007fca08615fa0
 </TASK>
BUG: Bad page state in process syz.2.1435  pfn:1af408
page: refcount:0 mapcount:0 mapping:0000000000000000 index:0x555573b20 pfn:0x1af408
flags: 0x57ff00000020908(uptodate|active|owner_2|swapbacked|node=1|zone=2|lastcpupid=0x7ff)
raw: 057ff00000020908 0000000000000000 dead000000000122 0000000000000000
raw: 0000000555573b20 0000000000000000 00000000ffffffff 0000000000000000
page dumped because: PAGE_FLAGS_CHECK_AT_FREE flag(s) set
page_owner tracks the page as allocated
page last allocated via order 0, migratetype Movable, gfp_mask 0x140cca(GFP_HIGHUSER_MOVABLE|__GFP_COMP), pid 8851, tgid 8851 (syz.0.1434), ts 86979662330, free_ts 86967025854
 set_page_owner include/linux/page_owner.h:32 [inline]
 post_alloc_hook+0x22d/0x280 mm/page_alloc.c:1858
 prep_new_page mm/page_alloc.c:1866 [inline]
 get_page_from_freelist+0x24ba/0x2540 mm/page_alloc.c:3946
 __alloc_frozen_pages_noprof+0x18d/0x380 mm/page_alloc.c:5226
 alloc_pages_mpol+0x235/0x490 mm/mempolicy.c:2490
 folio_alloc_mpol_noprof+0x39/0x160 mm/mempolicy.c:2509
 vma_alloc_folio_noprof+0xe1/0x1e0 mm/mempolicy.c:2544
 folio_prealloc mm/memory.c:-1 [inline]
 wp_page_copy mm/memory.c:3859 [inline]
 do_wp_page+0x118a/0x4cc0 mm/memory.c:4320
 handle_pte_fault mm/memory.c:6427 [inline]
 __handle_mm_fault mm/memory.c:6549 [inline]
 handle_mm_fault+0x151d/0x3170 mm/memory.c:6718
 do_user_addr_fault+0xa73/0x1340 arch/x86/mm/fault.c:1334
 handle_page_fault arch/x86/mm/fault.c:1474 [inline]
 exc_page_fault+0x6a/0xc0 arch/x86/mm/fault.c:1527
 asm_exc_page_fault+0x26/0x30 arch/x86/include/asm/idtentry.h:618
page last free pid 8849 tgid 8846 stack trace:
 reset_page_owner include/linux/page_owner.h:25 [inline]
 __free_pages_prepare mm/page_alloc.c:1402 [inline]
 free_unref_folios+0xcec/0x1480 mm/page_alloc.c:3004
 folios_put_refs+0xa3d/0xb80 mm/swap.c:1042
 free_pages_and_swap_cache+0x41d/0x490 mm/swap_state.c:404
 __tlb_batch_free_encoded_pages mm/mmu_gather.c:138 [inline]
 tlb_batch_pages_flush mm/mmu_gather.c:151 [inline]
 tlb_flush_mmu_free mm/mmu_gather.c:417 [inline]
 tlb_flush_mmu+0x6d3/0xa30 mm/mmu_gather.c:424
 tlb_finish_mmu+0xf9/0x230 mm/mmu_gather.c:549
 exit_mmap+0x498/0x9e0 mm/mmap.c:1313
 __mmput+0x118/0x430 kernel/fork.c:1178
 exit_mm+0x18e/0x250 kernel/exit.c:581
 do_exit+0x6a2/0x22c0 kernel/exit.c:963
 do_group_exit+0x21b/0x2d0 kernel/exit.c:1117
 get_signal+0x1284/0x1330 kernel/signal.c:3037
 arch_do_signal_or_restart+0xbc/0x830 arch/x86/kernel/signal.c:337
 __exit_to_user_mode_loop kernel/entry/common.c:64 [inline]
 exit_to_user_mode_loop+0x86/0x480 kernel/entry/common.c:98
 __exit_to_user_mode_prepare include/linux/irq-entry-common.h:207 [inline]
 syscall_exit_to_user_mode_prepare include/linux/irq-entry-common.h:238 [inline]
 syscall_exit_to_user_mode include/linux/entry-common.h:328 [inline]
 do_syscall_64+0x33e/0xf80 arch/x86/entry/syscall_64.c:100
 entry_SYSCALL_64_after_hwframe+0x77/0x7f
Modules linked in:
CPU: 1 UID: 0 PID: 8855 Comm: syz.2.1435 Tainted: G    B               syzkaller #0 PREEMPT(full) 
Tainted: [B]=BAD_PAGE
Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS 1.16.2-debian-1.16.2-1 04/01/2014
Call Trace:
 <TASK>
 dump_stack_lvl+0xe8/0x150 lib/dump_stack.c:120
 bad_page+0x17f/0x1c0 mm/page_alloc.c:632
 free_page_is_bad mm/page_alloc.c:1073 [inline]
 __free_pages_prepare mm/page_alloc.c:1393 [inline]
 free_unref_folios+0xdcc/0x1480 mm/page_alloc.c:3004
 folio_batch_move_lru+0x816/0x9e0 mm/swap.c:206
 __folio_batch_add_and_move+0x510/0xc50 mm/swap.c:226
 folio_add_lru_vma+0x196/0x210 mm/swap.c:566
 map_anon_folio_pte_nopf+0x2ee/0x5e0 mm/memory.c:5301
 map_anon_folio_pte_pf+0xbe/0x260 mm/memory.c:5311
 do_anonymous_page mm/memory.c:5413 [inline]
 do_pte_missing+0x2d48/0x33f0 mm/memory.c:4548
 handle_pte_fault mm/memory.c:6411 [inline]
 __handle_mm_fault mm/memory.c:6549 [inline]
 handle_mm_fault+0x1bd7/0x3170 mm/memory.c:6718
 do_user_addr_fault+0xa73/0x1340 arch/x86/mm/fault.c:1334
 handle_page_fault arch/x86/mm/fault.c:1474 [inline]
 exc_page_fault+0x6a/0xc0 arch/x86/mm/fault.c:1527
 asm_exc_page_fault+0x26/0x30 arch/x86/include/asm/idtentry.h:618
RIP: 0033:0x7fca082696d2
Code: 48 89 ca 48 c1 e2 04 48 29 ca 48 8d 0d 5f c9 3a 00 48 c1 e2 04 48 01 c2 8b 44 24 1c c6 42 20 01 89 42 24 8b 44 24 24 89 6a 28 <89> 42 78 0f b6 44 24 43 89 72 2c 88 44 19 04 8b 44 24 20 31 c9 89
RSP: 002b:00007ffc5adb04c0 EFLAGS: 00010206
RAX: 0000000000000000 RBX: 0000000000000000 RCX: 00007fca08616018
RDX: 00007fca08615fa0 RSI: 0000000000000003 RDI: 0000000000000000
RBP: 0000000000001cd6 R08: 00007fca08615fa0 R09: 00007ffc5adb0357
R10: 0000000000000008 R11: 0000000000000246 R12: 0000000000000000
R13: 00007fca08615fac R14: 00007fca08615fa8 R15: 00007fca08615fa0
 </TASK>
BUG: Bad page state in process syz.2.1435  pfn:1af412
page: refcount:0 mapcount:0 mapping:0000000000000000 index:0x7f14c9e16 pfn:0x1af412
flags: 0x57ff00000020908(uptodate|active|owner_2|swapbacked|node=1|zone=2|lastcpupid=0x7ff)
raw: 057ff00000020908 0000000000000000 dead000000000122 0000000000000000
raw: 00000007f14c9e16 0000000000000000 00000000ffffffff 0000000000000000
page dumped because: PAGE_FLAGS_CHECK_AT_FREE flag(s) set
page_owner tracks the page as allocated
page last allocated via order 0, migratetype Movable, gfp_mask 0x140dca(GFP_HIGHUSER_MOVABLE|__GFP_ZERO|__GFP_COMP), pid 8851, tgid 8851 (syz.0.1434), ts 86981021345, free_ts 69887129694
 set_page_owner include/linux/page_owner.h:32 [inline]
 post_alloc_hook+0x22d/0x280 mm/page_alloc.c:1858
 prep_new_page mm/page_alloc.c:1866 [inline]
 get_page_from_freelist+0x24ba/0x2540 mm/page_alloc.c:3946
 __alloc_frozen_pages_noprof+0x18d/0x380 mm/page_alloc.c:5226
 alloc_pages_mpol+0x235/0x490 mm/mempolicy.c:2490
 folio_alloc_mpol_noprof+0x39/0x160 mm/mempolicy.c:2509
 vma_alloc_folio_noprof+0xe1/0x1e0 mm/mempolicy.c:2544
 folio_prealloc mm/memory.c:-1 [inline]
 alloc_anon_folio mm/memory.c:5282 [inline]
 do_anonymous_page mm/memory.c:5376 [inline]
 do_pte_missing+0x159d/0x33f0 mm/memory.c:4548
 handle_pte_fault mm/memory.c:6411 [inline]
 __handle_mm_fault mm/memory.c:6549 [inline]
 handle_mm_fault+0x1bd7/0x3170 mm/memory.c:6718
 do_user_addr_fault+0xa73/0x1340 arch/x86/mm/fault.c:1334
 handle_page_fault arch/x86/mm/fault.c:1474 [inline]
 exc_page_fault+0x6a/0xc0 arch/x86/mm/fault.c:1527
 asm_exc_page_fault+0x26/0x30 arch/x86/include/asm/idtentry.h:618
page last free pid 5831 tgid 5831 stack trace:
 reset_page_owner include/linux/page_owner.h:25 [inline]
 __free_pages_prepare mm/page_alloc.c:1402 [inline]
 free_unref_folios+0xcec/0x1480 mm/page_alloc.c:3004
 folios_put_refs+0xa3d/0xb80 mm/swap.c:1042
 free_pages_and_swap_cache+0x41d/0x490 mm/swap_state.c:404
 __tlb_batch_free_encoded_pages mm/mmu_gather.c:138 [inline]
 tlb_batch_pages_flush mm/mmu_gather.c:151 [inline]
 tlb_flush_mmu_free mm/mmu_gather.c:417 [inline]
 tlb_flush_mmu+0x6d3/0xa30 mm/mmu_gather.c:424
 tlb_finish_mmu+0xf9/0x230 mm/mmu_gather.c:549
 unmap_region+0x2a5/0x330 mm/vma.c:491
 vms_clear_ptes mm/vma.c:1303 [inline]
 vms_complete_munmap_vmas+0x493/0xc60 mm/vma.c:1345
 do_vmi_align_munmap+0x3b7/0x4b0 mm/vma.c:1604
 do_vmi_munmap+0x252/0x2d0 mm/vma.c:1652
 __vm_munmap+0x22c/0x3d0 mm/vma.c:3285
 __do_sys_munmap mm/mmap.c:1079 [inline]
 __se_sys_munmap mm/mmap.c:1076 [inline]
 __x64_sys_munmap+0x60/0x70 mm/mmap.c:1076
 do_syscall_x64 arch/x86/entry/syscall_64.c:63 [inline]
 do_syscall_64+0x15f/0xf80 arch/x86/entry/syscall_64.c:94
 entry_SYSCALL_64_after_hwframe+0x77/0x7f
Modules linked in:
CPU: 1 UID: 0 PID: 8855 Comm: syz.2.1435 Tainted: G    B               syzkaller #0 PREEMPT(full) 
Tainted: [B]=BAD_PAGE
Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS 1.16.2-debian-1.16.2-1 04/01/2014
Call Trace:
 <TASK>
 dump_stack_lvl+0xe8/0x150 lib/dump_stack.c:120
 bad_page+0x17f/0x1c0 mm/page_alloc.c:632
 free_page_is_bad mm/page_alloc.c:1073 [inline]
 __free_pages_prepare mm/page_alloc.c:1393 [inline]
 free_unref_folios+0xdcc/0x1480 mm/page_alloc.c:3004
 folio_batch_move_lru+0x816/0x9e0 mm/swap.c:206
 __folio_batch_add_and_move+0x510/0xc50 mm/swap.c:226
 folio_add_lru_vma+0x196/0x210 mm/swap.c:566
 map_anon_folio_pte_nopf+0x2ee/0x5e0 mm/memory.c:5301
 map_anon_folio_pte_pf+0xbe/0x260 mm/memory.c:5311
 do_anonymous_page mm/memory.c:5413 [inline]
 do_pte_missing+0x2d48/0x33f0 mm/memory.c:4548
 handle_pte_fault mm/memory.c:6411 [inline]
 __handle_mm_fault mm/memory.c:6549 [inline]
 handle_mm_fault+0x1bd7/0x3170 mm/memory.c:6718
 do_user_addr_fault+0xa73/0x1340 arch/x86/mm/fault.c:1334
 handle_page_fault arch/x86/mm/fault.c:1474 [inline]
 exc_page_fault+0x6a/0xc0 arch/x86/mm/fault.c:1527
 asm_exc_page_fault+0x26/0x30 arch/x86/include/asm/idtentry.h:618
RIP: 0033:0x7fca082696d2
Code: 48 89 ca 48 c1 e2 04 48 29 ca 48 8d 0d 5f c9 3a 00 48 c1 e2 04 48 01 c2 8b 44 24 1c c6 42 20 01 89 42 24 8b 44 24 24 89 6a 28 <89> 42 78 0f b6 44 24 43 89 72 2c 88 44 19 04 8b 44 24 20 31 c9 89
RSP: 002b:00007ffc5adb04c0 EFLAGS: 00010206
RAX: 0000000000000000 RBX: 0000000000000000 RCX: 00007fca08616018
RDX: 00007fca08615fa0 RSI: 0000000000000003 RDI: 0000000000000000
RBP: 0000000000001cd6 R08: 00007fca08615fa0 R09: 00007ffc5adb0357
R10: 0000000000000008 R11: 0000000000000246 R12: 0000000000000000
R13: 00007fca08615fac R14: 00007fca08615fa8 R15: 00007fca08615fa0
 </TASK>
BUG: Bad page state in process syz.2.1435  pfn:1af413
page: refcount:0 mapcount:0 mapping:0000000000000000 index:0x7f14c9e17 pfn:0x1af413
flags: 0x57ff00000020908(uptodate|active|owner_2|swapbacked|node=1|zone=2|lastcpupid=0x7ff)
raw: 057ff00000020908 0000000000000000 dead000000000122 0000000000000000
raw: 00000007f14c9e17 0000000000000000 00000000ffffffff 0000000000000000
page dumped because: PAGE_FLAGS_CHECK_AT_FREE flag(s) set
page_owner tracks the page as allocated
page last allocated via order 0, migratetype Movable, gfp_mask 0x140cca(GFP_HIGHUSER_MOVABLE|__GFP_COMP), pid 8851, tgid 8851 (syz.0.1434), ts 86981071632, free_ts 69887133292
 set_page_owner include/linux/page_owner.h:32 [inline]
 post_alloc_hook+0x22d/0x280 mm/page_alloc.c:1858
 prep_new_page mm/page_alloc.c:1866 [inline]
 get_page_from_freelist+0x24ba/0x2540 mm/page_alloc.c:3946
 __alloc_frozen_pages_noprof+0x18d/0x380 mm/page_alloc.c:5226
 alloc_pages_mpol+0x235/0x490 mm/mempolicy.c:2490
 folio_alloc_mpol_noprof+0x39/0x160 mm/mempolicy.c:2509
 vma_alloc_folio_noprof+0xe1/0x1e0 mm/mempolicy.c:2544
 folio_prealloc mm/memory.c:-1 [inline]
 wp_page_copy mm/memory.c:3859 [inline]
 do_wp_page+0x118a/0x4cc0 mm/memory.c:4320
 handle_pte_fault mm/memory.c:6427 [inline]
 __handle_mm_fault mm/memory.c:6549 [inline]
 handle_mm_fault+0x151d/0x3170 mm/memory.c:6718
 do_user_addr_fault+0xa73/0x1340 arch/x86/mm/fault.c:1334
 handle_page_fault arch/x86/mm/fault.c:1474 [inline]
 exc_page_fault+0x6a/0xc0 arch/x86/mm/fault.c:1527
 asm_exc_page_fault+0x26/0x30 arch/x86/include/asm/idtentry.h:618
page last free pid 5831 tgid 5831 stack trace:
 reset_page_owner include/linux/page_owner.h:25 [inline]
 __free_pages_prepare mm/page_alloc.c:1402 [inline]
 free_unref_folios+0xcec/0x1480 mm/page_alloc.c:3004
 folios_put_refs+0xa3d/0xb80 mm/swap.c:1042
 free_pages_and_swap_cache+0x41d/0x490 mm/swap_state.c:404
 __tlb_batch_free_encoded_pages mm/mmu_gather.c:138 [inline]
 tlb_batch_pages_flush mm/mmu_gather.c:151 [inline]
 tlb_flush_mmu_free mm/mmu_gather.c:417 [inline]
 tlb_flush_mmu+0x6d3/0xa30 mm/mmu_gather.c:424
 tlb_finish_mmu+0xf9/0x230 mm/mmu_gather.c:549
 unmap_region+0x2a5/0x330 mm/vma.c:491
 vms_clear_ptes mm/vma.c:1303 [inline]
 vms_complete_munmap_vmas+0x493/0xc60 mm/vma.c:1345
 do_vmi_align_munmap+0x3b7/0x4b0 mm/vma.c:1604
 do_vmi_munmap+0x252/0x2d0 mm/vma.c:1652
 __vm_munmap+0x22c/0x3d0 mm/vma.c:3285
 __do_sys_munmap mm/mmap.c:1079 [inline]
 __se_sys_munmap mm/mmap.c:1076 [inline]
 __x64_sys_munmap+0x60/0x70 mm/mmap.c:1076
 do_syscall_x64 arch/x86/entry/syscall_64.c:63 [inline]
 do_syscall_64+0x15f/0xf80 arch/x86/entry/syscall_64.c:94
 entry_SYSCALL_64_after_hwframe+0x77/0x7f
Modules linked in:
CPU: 1 UID: 0 PID: 8855 Comm: syz.2.1435 Tainted: G    B               syzkaller #0 PREEMPT(full) 
Tainted: [B]=BAD_PAGE
Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS 1.16.2-debian-1.16.2-1 04/01/2014
Call Trace:
 <TASK>
 dump_stack_lvl+0xe8/0x150 lib/dump_stack.c:120
 bad_page+0x17f/0x1c0 mm/page_alloc.c:632
 free_page_is_bad mm/page_alloc.c:1073 [inline]
 __free_pages_prepare mm/page_alloc.c:1393 [inline]
 free_unref_folios+0xdcc/0x1480 mm/page_alloc.c:3004
 folio_batch_move_lru+0x816/0x9e0 mm/swap.c:206
 __folio_batch_add_and_move+0x510/0xc50 mm/swap.c:226
 folio_add_lru_vma+0x196/0x210 mm/swap.c:566
 map_anon_folio_pte_nopf+0x2ee/0x5e0 mm/memory.c:5301
 map_anon_folio_pte_pf+0xbe/0x260 mm/memory.c:5311
 do_anonymous_page mm/memory.c:5413 [inline]
 do_pte_missing+0x2d48/0x33f0 mm/memory.c:4548
 handle_pte_fault mm/memory.c:6411 [inline]
 __handle_mm_fault mm/memory.c:6549 [inline]
 handle_mm_fault+0x1bd7/0x3170 mm/memory.c:6718
 do_user_addr_fault+0xa73/0x1340 arch/x86/mm/fault.c:1334
 handle_page_fault arch/x86/mm/fault.c:1474 [inline]
 exc_page_fault+0x6a/0xc0 arch/x86/mm/fault.c:1527
 asm_exc_page_fault+0x26/0x30 arch/x86/include/asm/idtentry.h:618
RIP: 0033:0x7fca082696d2
Code: 48 89 ca 48 c1 e2 04 48 29 ca 48 8d 0d 5f c9 3a 00 48 c1 e2 04 48 01 c2 8b 44 24 1c c6 42 20 01 89 42 24 8b 44 24 24 89 6a 28 <89> 42 78 0f b6 44 24 43 89 72 2c 88 44 19 04 8b 44 24 20 31 c9 89
RSP: 002b:00007ffc5adb04c0 EFLAGS: 00010206
RAX: 0000000000000000 RBX: 0000000000000000 RCX: 00007fca08616018
RDX: 00007fca08615fa0 RSI: 0000000000000003 RDI: 0000000000000000
RBP: 0000000000001cd6 R08: 00007fca08615fa0 R09: 00007ffc5adb0357
R10: 0000000000000008 R11: 0000000000000246 R12: 0000000000000000
R13: 00007fca08615fac R14: 00007fca08615fa8 R15: 00007fca08615fa0
 </TASK>
BUG: Bad page state in process syz.2.1435  pfn:1af414
page: refcount:0 mapcount:0 mapping:0000000000000000 index:0x7f14c9e12 pfn:0x1af414
flags: 0x57ff00000020908(uptodate|active|owner_2|swapbacked|node=1|zone=2|lastcpupid=0x7ff)
raw: 057ff00000020908 0000000000000000 dead000000000122 0000000000000000
raw: 00000007f14c9e12 0000000000000000 00000000ffffffff 0000000000000000
page dumped because: PAGE_FLAGS_CHECK_AT_FREE flag(s) set
page_owner tracks the page as allocated
page last allocated via order 0, migratetype Movable, gfp_mask 0x140cca(GFP_HIGHUSER_MOVABLE|__GFP_COMP), pid 8851, tgid 8851 (syz.0.1434), ts 86982688821, free_ts 69887137521
 set_page_owner include/linux/page_owner.h:32 [inline]
 post_alloc_hook+0x22d/0x280 mm/page_alloc.c:1858
 prep_new_page mm/page_alloc.c:1866 [inline]
 get_page_from_freelist+0x24ba/0x2540 mm/page_alloc.c:3946
 __alloc_frozen_pages_noprof+0x18d/0x380 mm/page_alloc.c:5226
 alloc_pages_mpol+0x235/0x490 mm/mempolicy.c:2490
 folio_alloc_mpol_noprof+0x39/0x160 mm/mempolicy.c:2509
 vma_alloc_folio_noprof+0xe1/0x1e0 mm/mempolicy.c:2544
 folio_prealloc mm/memory.c:-1 [inline]
 wp_page_copy mm/memory.c:3859 [inline]
 do_wp_page+0x118a/0x4cc0 mm/memory.c:4320
 handle_pte_fault mm/memory.c:6427 [inline]
 __handle_mm_fault mm/memory.c:6549 [inline]
 handle_mm_fault+0x151d/0x3170 mm/memory.c:6718
 do_user_addr_fault+0xa73/0x1340 arch/x86/mm/fault.c:1334
 handle_page_fault arch/x86/mm/fault.c:1474 [inline]
 exc_page_fault+0x6a/0xc0 arch/x86/mm/fault.c:1527
 asm_exc_page_fault+0x26/0x30 arch/x86/include/asm/idtentry.h:618
page last free pid 5831 tgid 5831 stack trace:
 reset_page_owner include/linux/page_owner.h:25 [inline]
 __free_pages_prepare mm/page_alloc.c:1402 [inline]
 free_unref_folios+0xcec/0x1480 mm/page_alloc.c:3004
 folios_put_refs+0xa3d/0xb80 mm/swap.c:1042
 free_pages_and_swap_cache+0x41d/0x490 mm/swap_state.c:404
 __tlb_batch_free_encoded_pages mm/mmu_gather.c:138 [inline]
 tlb_batch_pages_flush mm/mmu_gather.c:151 [inline]
 tlb_flush_mmu_free mm/mmu_gather.c:417 [inline]
 tlb_flush_mmu+0x6d3/0xa30 mm/mmu_gather.c:424
 tlb_finish_mmu+0xf9/0x230 mm/mmu_gather.c:549
 unmap_region+0x2a5/0x330 mm/vma.c:491
 vms_clear_ptes mm/vma.c:1303 [inline]
 vms_complete_munmap_vmas+0x493/0xc60 mm/vma.c:1345
 do_vmi_align_munmap+0x3b7/0x4b0 mm/vma.c:1604
 do_vmi_munmap+0x252/0x2d0 mm/vma.c:1652
 __vm_munmap+0x22c/0x3d0 mm/vma.c:3285
 __do_sys_munmap mm/mmap.c:1079 [inline]
 __se_sys_munmap mm/mmap.c:1076 [inline]
 __x64_sys_munmap+0x60/0x70 mm/mmap.c:1076
 do_syscall_x64 arch/x86/entry/syscall_64.c:63 [inline]
 do_syscall_64+0x15f/0xf80 arch/x86/entry/syscall_64.c:94
 entry_SYSCALL_64_after_hwframe+0x77/0x7f
Modules linked in:

CPU: 1 UID: 0 PID: 8855 Comm: syz.2.1435 Tainted: G    B               syzkaller #0 PREEMPT(full) 
Tainted: [B]=BAD_PAGE
Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS 1.16.2-debian-1.16.2-1 04/01/2014
Call Trace:
 <TASK>
 dump_stack_lvl+0xe8/0x150 lib/dump_stack.c:120
 bad_page+0x17f/0x1c0 mm/page_alloc.c:632
 free_page_is_bad mm/page_alloc.c:1073 [inline]
 __free_pages_prepare mm/page_alloc.c:1393 [inline]
 free_unref_folios+0xdcc/0x1480 mm/page_alloc.c:3004
 folio_batch_move_lru+0x816/0x9e0 mm/swap.c:206
 __folio_batch_add_and_move+0x510/0xc50 mm/swap.c:226
 folio_add_lru_vma+0x196/0x210 mm/swap.c:566
 map_anon_folio_pte_nopf+0x2ee/0x5e0 mm/memory.c:5301
 map_anon_folio_pte_pf+0xbe/0x260 mm/memory.c:5311
 do_anonymous_page mm/memory.c:5413 [inline]
 do_pte_missing+0x2d48/0x33f0 mm/memory.c:4548
 handle_pte_fault mm/memory.c:6411 [inline]
 __handle_mm_fault mm/memory.c:6549 [inline]
 handle_mm_fault+0x1bd7/0x3170 mm/memory.c:6718
 do_user_addr_fault+0xa73/0x1340 arch/x86/mm/fault.c:1334
 handle_page_fault arch/x86/mm/fault.c:1474 [inline]
 exc_page_fault+0x6a/0xc0 arch/x86/mm/fault.c:1527
 asm_exc_page_fault+0x26/0x30 arch/x86/include/asm/idtentry.h:618
RIP: 0033:0x7fca082696d2
Code: 48 89 ca 48 c1 e2 04 48 29 ca 48 8d 0d 5f c9 3a 00 48 c1 e2 04 48 01 c2 8b 44 24 1c c6 42 20 01 89 42 24 8b 44 24 24 89 6a 28 <89> 42 78 0f b6 44 24 43 89 72 2c 88 44 19 04 8b 44 24 20 31 c9 89
RSP: 002b:00007ffc5adb04c0 EFLAGS: 00010206
RAX: 0000000000000000 RBX: 0000000000000000 RCX: 00007fca08616018
RDX: 00007fca08615fa0 RSI: 0000000000000003 RDI: 0000000000000000
RBP: 0000000000001cd6 R08: 00007fca08615fa0 R09: 00007ffc5adb0357
R10: 0000000000000008 R11: 0000000000000246 R12: 0000000000000000
R13: 00007fca08615fac R14: 00007fca08615fa8 R15: 00007fca08615fa0
 </TASK>


***

BUG: Bad page state in do_wp_page

tree:      mm-new
URL:       https://kernel.googlesource.com/pub/scm/linux/kernel/git/akpm/mm.git
base:      c9183ec6e2e3bd26a017392d6c3eaa40c580f153
arch:      amd64
compiler:  Debian clang version 21.1.8 (++20251221033036+2078da43e25a-1~exp1~20251221153213.50), Debian LLD 21.1.8
config:    https://ci.syzbot.org/builds/4d1a53f4-f506-4ba9-a8c2-a48196f95abc/config
syz repro: https://ci.syzbot.org/findings/5db96cfa-fea0-4d9d-9b97-6924026375b7/syz_repro

BUG: Bad page state: 5753 messages suppressed
BUG: Bad page state in process syz-executor  pfn:11e4a5
page: refcount:0 mapcount:0 mapping:0000000000000000 index:0x7f4658e12 pfn:0x11e4a5
flags: 0x17ff00000020908(uptodate|active|owner_2|swapbacked|node=0|zone=2|lastcpupid=0x7ff)
raw: 017ff00000020908 0000000000000000 dead000000000122 0000000000000000
raw: 00000007f4658e12 0000000000000000 00000000ffffffff 0000000000000000
page dumped because: PAGE_FLAGS_CHECK_AT_FREE flag(s) set
page_owner tracks the page as allocated
page last allocated via order 0, migratetype Movable, gfp_mask 0x140cca(GFP_HIGHUSER_MOVABLE|__GFP_COMP), pid 6083, tgid 6083 (syz.1.50), ts 86214702085, free_ts 66376409073
 set_page_owner include/linux/page_owner.h:32 [inline]
 post_alloc_hook+0x22d/0x280 mm/page_alloc.c:1858
 prep_new_page mm/page_alloc.c:1866 [inline]
 get_page_from_freelist+0x24ba/0x2540 mm/page_alloc.c:3946
 __alloc_frozen_pages_noprof+0x18d/0x380 mm/page_alloc.c:5226
 alloc_pages_mpol+0x235/0x490 mm/mempolicy.c:2490
 folio_alloc_mpol_noprof+0x39/0x160 mm/mempolicy.c:2509
 vma_alloc_folio_noprof+0xe1/0x1e0 mm/mempolicy.c:2544
 folio_prealloc mm/memory.c:-1 [inline]
 wp_page_copy mm/memory.c:3859 [inline]
 do_wp_page+0x118a/0x4cc0 mm/memory.c:4320
 handle_pte_fault mm/memory.c:6427 [inline]
 __handle_mm_fault mm/memory.c:6549 [inline]
 handle_mm_fault+0x151d/0x3170 mm/memory.c:6718
 do_user_addr_fault+0xa73/0x1340 arch/x86/mm/fault.c:1334
 handle_page_fault arch/x86/mm/fault.c:1474 [inline]
 exc_page_fault+0x6a/0xc0 arch/x86/mm/fault.c:1527
 asm_exc_page_fault+0x26/0x30 arch/x86/include/asm/idtentry.h:618
page last free pid 5817 tgid 5790 stack trace:
 reset_page_owner include/linux/page_owner.h:25 [inline]
 __free_pages_prepare mm/page_alloc.c:1402 [inline]
 __free_frozen_pages+0xbc7/0xd30 mm/page_alloc.c:2943
 __folio_put+0x4a2/0x580 mm/swap.c:112
 folio_put include/linux/mm.h:2090 [inline]
 migrate_folio_done mm/migrate.c:1201 [inline]
 migrate_folio_move mm/migrate.c:1432 [inline]
 migrate_folios_move mm/migrate.c:1740 [inline]
 migrate_pages_batch+0x3dac/0x4ca0 mm/migrate.c:1996
 migrate_pages+0x1e02/0x2a10 mm/migrate.c:2130
 migrate_misplaced_folio+0x273/0x720 mm/migrate.c:2751
 do_numa_page mm/memory.c:6199 [inline]
 handle_pte_fault mm/memory.c:6417 [inline]
 __handle_mm_fault mm/memory.c:6549 [inline]
 handle_mm_fault+0x20ea/0x3170 mm/memory.c:6718
 do_user_addr_fault+0x75b/0x1340 arch/x86/mm/fault.c:1385
 handle_page_fault arch/x86/mm/fault.c:1474 [inline]
 exc_page_fault+0x6a/0xc0 arch/x86/mm/fault.c:1527
 asm_exc_page_fault+0x26/0x30 arch/x86/include/asm/idtentry.h:618
Modules linked in:
CPU: 0 UID: 0 PID: 6089 Comm: syz-executor Tainted: G    B               syzkaller #0 PREEMPT(full) 
Tainted: [B]=BAD_PAGE
Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS 1.16.2-debian-1.16.2-1 04/01/2014
Call Trace:
 <TASK>
 dump_stack_lvl+0xe8/0x150 lib/dump_stack.c:120
 bad_page+0x17f/0x1c0 mm/page_alloc.c:632
 free_page_is_bad mm/page_alloc.c:1073 [inline]
 __free_pages_prepare mm/page_alloc.c:1393 [inline]
 free_unref_folios+0xdcc/0x1480 mm/page_alloc.c:3004
 folio_batch_move_lru+0x816/0x9e0 mm/swap.c:206
 __folio_batch_add_and_move+0x510/0xc50 mm/swap.c:226
 folio_add_lru_vma+0x196/0x210 mm/swap.c:566
 wp_page_copy mm/memory.c:3927 [inline]
 do_wp_page+0x3deb/0x4cc0 mm/memory.c:4320
 handle_pte_fault mm/memory.c:6427 [inline]
 __handle_mm_fault mm/memory.c:6549 [inline]
 handle_mm_fault+0x151d/0x3170 mm/memory.c:6718
 do_user_addr_fault+0xa73/0x1340 arch/x86/mm/fault.c:1334
 handle_page_fault arch/x86/mm/fault.c:1474 [inline]
 exc_page_fault+0x6a/0xc0 arch/x86/mm/fault.c:1527
 asm_exc_page_fault+0x26/0x30 arch/x86/include/asm/idtentry.h:618
RIP: 0033:0x7f4658b61da7
Code: 00 00 00 80 3d 51 aa de 00 00 0f 84 b4 00 00 00 48 c7 c0 e0 ff ff ff c7 05 4a aa de 00 00 00 00 00 64 48 8b 08 48 85 c9 74 0b <48> c7 81 80 08 00 00 01 00 00 00 48 c7 05 23 aa de 00 00 00 00 00
RSP: 002b:00007ffc5850f508 EFLAGS: 00010202
RAX: ffffffffffffffe0 RBX: 0000000000000000 RCX: 00007f4658dece20
RDX: 0000000000000000 RSI: 00007f4658c52ee0 RDI: 00007f4659948060
RBP: 00007ffc5850f66c R08: 00007f4659948060 R09: 0000000000000000
R10: 0000000000000008 R11: 0000000000000246 R12: 0000000000000001
R13: 00000000000927c0 R14: 0000000000015068 R15: 00007ffc5850f6c0
 </TASK>


***

If these findings have caused you to resend the series or submit a
separate fix, please add the following tag to your commit message:
  Tested-by: syzbot@syzkaller.appspotmail.com

---
This report is generated by a bot. It may contain errors.
syzbot ci engineers can be reached at syzkaller@googlegroups.com.

To test a patch for this bug, please reply with `#syz test`
(should be on a separate line).

The patch should be attached to the email.
Note: arguments like custom git repos and branches are not supported.
