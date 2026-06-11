Received: from mail-oo1-f72.google.com (mail-oo1-f72.google.com [209.85.161.72])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 37FC434B437
	for <syzbot@lists.linux.dev>; Thu, 11 Jun 2026 05:52:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.161.72
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781157142; cv=none; b=dwgts+p14mqly4jIGqK2CmSukqaSdL+tIC16G4EX4gGIH89PE58vcIu3uWGT1eWQIaWn6KcctHQcvaIIJOVrUvlPh4A3i3VrNVHVQrVvVjVUURDy6F1ykgLFw9dPiuwqOcuoyaqWC9tWV6/je4gwSAU0/GH/RK0UVTwJtd/I8To=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781157142; c=relaxed/simple;
	bh=vV1dvm4YcbRU97cq29HaULTBh1LAcjU3BqDgOcyNnMA=;
	h=MIME-Version:Date:Message-ID:Subject:From:To:Cc:Content-Type; b=T7Rzr+8BvlRbnb5mnIA2RTjynUY+Pr3BcFkdsnzmzzLXND5xlm8CbfbCBlENPpb+vQsXN3mjyFJyDTwRsDjIDvy8dFaQVEB4+TJ5hQu2xg6Gr6KUMrDA54QCGJKOCQI4wVEukevxnyA/Qe9MBB7mxrVfrR/DYEY5VVL2azN4vLg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com; arc=none smtp.client-ip=209.85.161.72
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com
Received: by mail-oo1-f72.google.com with SMTP id 006d021491bc7-69e47dbf2a7so732721eaf.1
        for <syzbot@lists.linux.dev>; Wed, 10 Jun 2026 22:52:17 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1781157137; x=1781761937;
        h=content-transfer-encoding:cc:to:from:subject:message-id:date
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=N7EHWGvaYZIBxdf1aDCYaje9Fsm30G0U+Ry5ye+0Jgg=;
        b=Jftx9N5A7+5SiLvr0ClQPq6mnIIlDnHh249EQl6zEHMBNQnDNsmlKUHCNufAXVrHYq
         DNpdhJmGGoqqkraUryPD+yrXBIPSXjHzUdKWst84dc+I0xJ6jJu1CsaYwYMn7vknTgGX
         WlgIsdWr3H//J+/XcMQX/a/ypRXJD4iP2TK9/iTHVVKJzlMGF645DUXpWZLf8Fps2fCi
         R2GgZAsXSLouFAyBjqa0PjZJXgiZkdQI6t+t5HabcEcPyWCwIofqKLSseDjupvfonRHE
         VwN6+YqWRWBPXGAO6FXkXDlsdnrbsfFoDxWVlK3wK2HirAnvG5zd6wkanoEgMfy1+8fS
         MBQQ==
X-Gm-Message-State: AOJu0YyDIIDmp4TvvIO0+JAWHRlW5y8J3YgNxd38ZJkrqjRymf41R3z3
	xpVN8uIDlnJCP9cHcrd017lYc3+JKzgt5k20sSXa9yccYUbMR8obcir7tJ8bJODjkXcv3uaP1KT
	M9V+OHIVUQAyc9wv40mTO8irGyagqX05DWIeIIV1bXjZjdZj2J0mZuhycsdw=
Precedence: bulk
X-Mailing-List: syzbot@lists.linux.dev
List-Id: <syzbot.lists.linux.dev>
List-Subscribe: <mailto:syzbot+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:syzbot+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Received: by 2002:a05:6820:1507:b0:694:8d2e:390e with SMTP id
 006d021491bc7-69ecb0e2084mr822525eaf.39.1781157137164; Wed, 10 Jun 2026
 22:52:17 -0700 (PDT)
Date: Wed, 10 Jun 2026 22:52:17 -0700
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <6a2a4d11.3b0a2d4e.8c8d1.0008.GAE@google.com>
Subject: [moderation/CI] Re: mm/huge_memory: do not add dropped split tail
 folios to LRU
From: syzbot ci <syzbot+ci25a876a2b0ee128b@syzkaller.appspotmail.com>
To: syzkaller-upstream-moderation@googlegroups.com
Cc: syzbot@lists.linux.dev
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

syzbot ci has tested the following series

[v1] mm/huge_memory: do not add dropped split tail folios to LRU
https://lore.kernel.org/all/20260610120535.2370844-1-zhaoyang.huang@unisoc.=
com
* [RFC PATCH] mm/huge_memory: do not add dropped split tail folios to LRU

and found the following issues:
* BUG: Bad page state in ext4_write_begin
* BUG: Bad page state in iomap_write_begin
* BUG: Bad page state in shmem_get_folio_gfp

Full report is available here:
https://ci.syzbot.org/series/c3e122ba-1000-4581-ba3f-237f41482af8

***

BUG: Bad page state in ext4_write_begin

tree:      mm-new
URL:       https://kernel.googlesource.com/pub/scm/linux/kernel/git/akpm/mm=
.git
base:      1ec3cca2d8b6b9ff6584ca626d4c8918bbf48d44
arch:      amd64
compiler:  Debian clang version 21.1.8 (++20251221033036+2078da43e25a-1~exp=
1~20251221153213.50), Debian LLD 21.1.8
config:    https://ci.syzbot.org/builds/ffde37a3-aed0-4f49-bba1-ca31cd6a4b0=
4/config
syz repro: https://ci.syzbot.org/findings/07322c5f-4419-4281-bbd5-1b06eebe9=
1f2/syz_repro

ext2 filesystem being mounted at /0/file1 supports timestamps until 2038-01=
-19 (0x7fffffff)
BUG: Bad page state in process syz.0.17  pfn:11e231
page: refcount:0 mapcount:0 mapping:0000000000000000 index:0x1 pfn:0x11e231
flags: 0x17ff20000000000(node=3D0|zone=3D2|lastcpupid=3D0x7ff)
raw: 017ff20000000000 0000000000000000 00000000ffffffff 0000000000000000
raw: 0000000000000001 0000000000000000 00000000ffffffff 0000000000000000
page dumped because: PAGE_FLAGS_CHECK_AT_FREE flag(s) set
page_owner tracks the page as allocated
page last allocated via order 0, migratetype Movable, gfp_mask 0x153cca(GFP=
_HIGHUSER_MOVABLE|__GFP_WRITE|__GFP_NOWARN|__GFP_NORETRY|__GFP_COMP), pid 5=
841, tgid 5840 (syz.0.17), ts 75851604747, free_ts 72751451789
 set_page_owner include/linux/page_owner.h:32 [inline]
 post_alloc_hook+0x22d/0x280 mm/page_alloc.c:1853
 prep_new_page mm/page_alloc.c:1861 [inline]
 get_page_from_freelist+0x2593/0x2610 mm/page_alloc.c:3941
 __alloc_frozen_pages_noprof+0x18d/0x380 mm/page_alloc.c:5221
 alloc_pages_mpol+0x235/0x490 mm/mempolicy.c:2490
 alloc_frozen_pages_noprof mm/mempolicy.c:2561 [inline]
 alloc_pages_noprof+0xac/0x2a0 mm/mempolicy.c:2581
 folio_alloc_noprof+0x1e/0x30 mm/mempolicy.c:2591
 filemap_alloc_folio_noprof+0x111/0x470 mm/filemap.c:1014
 __filemap_get_folio_mpol+0x3fc/0xb00 mm/filemap.c:2012
 __filemap_get_folio include/linux/pagemap.h:763 [inline]
 write_begin_get_folio include/linux/pagemap.h:789 [inline]
 ext4_write_begin+0x4ad/0x1890 fs/ext4/inode.c:1331
 generic_perform_write+0x2e2/0x8f0 mm/filemap.c:4325
 ext4_buffered_write_iter+0xce/0x3a0 fs/ext4/file.c:316
 ext4_file_write_iter+0x298/0x1bf0 fs/ext4/file.c:-1
 new_sync_write fs/read_write.c:595 [inline]
 vfs_write+0x61d/0xb90 fs/read_write.c:688
 ksys_pwrite64 fs/read_write.c:795 [inline]
 __do_sys_pwrite64 fs/read_write.c:803 [inline]
 __se_sys_pwrite64 fs/read_write.c:800 [inline]
 __x64_sys_pwrite64+0x199/0x230 fs/read_write.c:800
 do_syscall_x64 arch/x86/entry/syscall_64.c:63 [inline]
 do_syscall_64+0x174/0x580 arch/x86/entry/syscall_64.c:94
 entry_SYSCALL_64_after_hwframe+0x77/0x7f
page last free pid 5718 tgid 5718 stack trace:
 reset_page_owner include/linux/page_owner.h:25 [inline]
 __free_pages_prepare mm/page_alloc.c:1397 [inline]
 free_unref_folios+0xd9f/0x14c0 mm/page_alloc.c:2999
 folios_put_refs+0x9ff/0xb40 mm/swap.c:1008
 free_pages_and_swap_cache+0x41d/0x490 mm/swap_state.c:404
 __tlb_batch_free_encoded_pages mm/mmu_gather.c:138 [inline]
 tlb_batch_pages_flush mm/mmu_gather.c:151 [inline]
 tlb_flush_mmu_free mm/mmu_gather.c:417 [inline]
 tlb_flush_mmu+0x6d3/0xa30 mm/mmu_gather.c:424
 tlb_finish_mmu+0xf9/0x230 mm/mmu_gather.c:549
 exit_mmap+0x498/0x9e0 mm/mmap.c:1313
 __mmput+0x118/0x430 kernel/fork.c:1178
 exit_mm+0x1f6/0x2d0 kernel/exit.c:582
 do_exit+0x6a2/0x22c0 kernel/exit.c:964
 do_group_exit+0x21b/0x2d0 kernel/exit.c:1119
 get_signal+0x1284/0x1330 kernel/signal.c:3037
 arch_do_signal_or_restart+0xbc/0x840 arch/x86/kernel/signal.c:337
 __exit_to_user_mode_loop kernel/entry/common.c:64 [inline]
 exit_to_user_mode_loop+0xa9/0x680 kernel/entry/common.c:98
 __exit_to_user_mode_prepare include/linux/irq-entry-common.h:207 [inline]
 syscall_exit_to_user_mode_prepare include/linux/irq-entry-common.h:230 [in=
line]
 syscall_exit_to_user_mode include/linux/entry-common.h:318 [inline]
 do_syscall_64+0x353/0x580 arch/x86/entry/syscall_64.c:100
 entry_SYSCALL_64_after_hwframe+0x77/0x7f
Modules linked in:
CPU: 0 UID: 0 PID: 5841 Comm: syz.0.17 Not tainted syzkaller #0 PREEMPT(ful=
l)=20
Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS 1.16.2-debian-1.16=
.2-1 04/01/2014
Call Trace:
 <TASK>
 dump_stack_lvl+0xe8/0x150 lib/dump_stack.c:120
 bad_page+0x17f/0x1c0 mm/page_alloc.c:632
 free_page_is_bad mm/page_alloc.c:1076 [inline]
 __free_pages_prepare mm/page_alloc.c:1388 [inline]
 __free_frozen_pages+0xcd9/0xd30 mm/page_alloc.c:2938
 __folio_put+0x4a2/0x580 mm/swap.c:112
 __folio_split+0xffe/0x1570 mm/huge_memory.c:4199
 try_folio_split_to_order include/linux/huge_mm.h:411 [inline]
 try_folio_split_or_unmap+0x5b/0x1e0 mm/truncate.c:189
 truncate_inode_partial_folio+0x4ab/0x8e0 mm/truncate.c:255
 truncate_inode_pages_range+0x5f1/0xe30 mm/truncate.c:416
 ext4_truncate_failed_write fs/ext4/truncate.h:21 [inline]
 ext4_write_end+0x784/0xa30 fs/ext4/inode.c:1495
 generic_perform_write+0x620/0x8f0 mm/filemap.c:4346
 ext4_buffered_write_iter+0xce/0x3a0 fs/ext4/file.c:316
 ext4_file_write_iter+0x298/0x1bf0 fs/ext4/file.c:-1
 new_sync_write fs/read_write.c:595 [inline]
 vfs_write+0x61d/0xb90 fs/read_write.c:688
 ksys_pwrite64 fs/read_write.c:795 [inline]
 __do_sys_pwrite64 fs/read_write.c:803 [inline]
 __se_sys_pwrite64 fs/read_write.c:800 [inline]
 __x64_sys_pwrite64+0x199/0x230 fs/read_write.c:800
 do_syscall_x64 arch/x86/entry/syscall_64.c:63 [inline]
 do_syscall_64+0x174/0x580 arch/x86/entry/syscall_64.c:94
 entry_SYSCALL_64_after_hwframe+0x77/0x7f
RIP: 0033:0x7fb06359ce59
Code: ff c3 66 2e 0f 1f 84 00 00 00 00 00 0f 1f 44 00 00 48 89 f8 48 89 f7 =
48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 ff f=
f 73 01 c3 48 c7 c1 e8 ff ff ff f7 d8 64 89 01 48
RSP: 002b:00007fb0643ff028 EFLAGS: 00000246 ORIG_RAX: 0000000000000012
RAX: ffffffffffffffda RBX: 00007fb063815fa0 RCX: 00007fb06359ce59
RDX: 000000000000fdef RSI: 0000200000000140 RDI: 0000000000000004
RBP: 00007fb063632d6f R08: 0000000000000000 R09: 0000000000000000
R10: 0000000000000c00 R11: 0000000000000246 R12: 0000000000000000
R13: 00007fb063816038 R14: 00007fb063815fa0 R15: 00007ffe99cbba98
 </TASK>
BUG: Bad page state in process syz.0.17  pfn:11e232
page: refcount:0 mapcount:0 mapping:0000000000000000 index:0x2 pfn:0x11e232
head: order:0 mapcount:0 entire_mapcount:1 nr_pages_mapped:0 pincount:0
flags: 0x17ff20000000040(head|node=3D0|zone=3D2|lastcpupid=3D0x7ff)
raw: 017ff20000000040 0000000000000000 ffffea0004788c90 0000000000000000
raw: 0000000000000002 0000000000000000 00000000ffffffff 0000000000000000
head: 017ff20000000040 0000000000000000 ffffea0004788c90 0000000000000000
head: 0000000000000002 0000000000000000 00000000ffffffff 0000000000000000
head: 017ff00000000000 0000000000000000 00000000ffffffff 0000000000000000
head: ffffffffffffffff 0000000000000000 00000000ffffffff 0000000000000000
page dumped because: PAGE_FLAGS_CHECK_AT_FREE flag(s) set
page_owner tracks the page as allocated
page last allocated via order 1, migratetype Movable, gfp_mask 0x153cca(GFP=
_HIGHUSER_MOVABLE|__GFP_WRITE|__GFP_NOWARN|__GFP_NORETRY|__GFP_COMP), pid 5=
841, tgid 5840 (syz.0.17), ts 75851604747, free_ts 72751458324
 set_page_owner include/linux/page_owner.h:32 [inline]
 post_alloc_hook+0x22d/0x280 mm/page_alloc.c:1853
 prep_new_page mm/page_alloc.c:1861 [inline]
 get_page_from_freelist+0x2593/0x2610 mm/page_alloc.c:3941
 __alloc_frozen_pages_noprof+0x18d/0x380 mm/page_alloc.c:5221
 alloc_pages_mpol+0x235/0x490 mm/mempolicy.c:2490
 alloc_frozen_pages_noprof mm/mempolicy.c:2561 [inline]
 alloc_pages_noprof+0xac/0x2a0 mm/mempolicy.c:2581
 folio_alloc_noprof+0x1e/0x30 mm/mempolicy.c:2591
 filemap_alloc_folio_noprof+0x111/0x470 mm/filemap.c:1014
 __filemap_get_folio_mpol+0x3fc/0xb00 mm/filemap.c:2012
 __filemap_get_folio include/linux/pagemap.h:763 [inline]
 write_begin_get_folio include/linux/pagemap.h:789 [inline]
 ext4_write_begin+0x4ad/0x1890 fs/ext4/inode.c:1331
 generic_perform_write+0x2e2/0x8f0 mm/filemap.c:4325
 ext4_buffered_write_iter+0xce/0x3a0 fs/ext4/file.c:316
 ext4_file_write_iter+0x298/0x1bf0 fs/ext4/file.c:-1
 new_sync_write fs/read_write.c:595 [inline]
 vfs_write+0x61d/0xb90 fs/read_write.c:688
 ksys_pwrite64 fs/read_write.c:795 [inline]
 __do_sys_pwrite64 fs/read_write.c:803 [inline]
 __se_sys_pwrite64 fs/read_write.c:800 [inline]
 __x64_sys_pwrite64+0x199/0x230 fs/read_write.c:800
 do_syscall_x64 arch/x86/entry/syscall_64.c:63 [inline]
 do_syscall_64+0x174/0x580 arch/x86/entry/syscall_64.c:94
 entry_SYSCALL_64_after_hwframe+0x77/0x7f
page last free pid 5718 tgid 5718 stack trace:
 reset_page_owner include/linux/page_owner.h:25 [inline]
 __free_pages_prepare mm/page_alloc.c:1397 [inline]
 free_unref_folios+0xd9f/0x14c0 mm/page_alloc.c:2999
 folios_put_refs+0x9ff/0xb40 mm/swap.c:1008
 free_pages_and_swap_cache+0x41d/0x490 mm/swap_state.c:404
 __tlb_batch_free_encoded_pages mm/mmu_gather.c:138 [inline]
 tlb_batch_pages_flush mm/mmu_gather.c:151 [inline]
 tlb_flush_mmu_free mm/mmu_gather.c:417 [inline]
 tlb_flush_mmu+0x6d3/0xa30 mm/mmu_gather.c:424
 tlb_finish_mmu+0xf9/0x230 mm/mmu_gather.c:549
 exit_mmap+0x498/0x9e0 mm/mmap.c:1313
 __mmput+0x118/0x430 kernel/fork.c:1178
 exit_mm+0x1f6/0x2d0 kernel/exit.c:582
 do_exit+0x6a2/0x22c0 kernel/exit.c:964
 do_group_exit+0x21b/0x2d0 kernel/exit.c:1119
 get_signal+0x1284/0x1330 kernel/signal.c:3037
 arch_do_signal_or_restart+0xbc/0x840 arch/x86/kernel/signal.c:337
 __exit_to_user_mode_loop kernel/entry/common.c:64 [inline]
 exit_to_user_mode_loop+0xa9/0x680 kernel/entry/common.c:98
 __exit_to_user_mode_prepare include/linux/irq-entry-common.h:207 [inline]
 syscall_exit_to_user_mode_prepare include/linux/irq-entry-common.h:230 [in=
line]
 syscall_exit_to_user_mode include/linux/entry-common.h:318 [inline]
 do_syscall_64+0x353/0x580 arch/x86/entry/syscall_64.c:100
 entry_SYSCALL_64_after_hwframe+0x77/0x7f
Modules linked in:

CPU: 1 UID: 0 PID: 5841 Comm: syz.0.17 Tainted: G    B               syzkal=
ler #0 PREEMPT(full)=20
Tainted: [B]=3DBAD_PAGE
Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS 1.16.2-debian-1.16=
.2-1 04/01/2014
Call Trace:
 <TASK>
 dump_stack_lvl+0xe8/0x150 lib/dump_stack.c:120
 bad_page+0x17f/0x1c0 mm/page_alloc.c:632
 free_page_is_bad mm/page_alloc.c:1076 [inline]
 __free_pages_prepare mm/page_alloc.c:1388 [inline]
 __free_frozen_pages+0xcd9/0xd30 mm/page_alloc.c:2938
 __folio_put+0x4a2/0x580 mm/swap.c:112
 __folio_split+0xffe/0x1570 mm/huge_memory.c:4199
 try_folio_split_to_order include/linux/huge_mm.h:411 [inline]
 try_folio_split_or_unmap+0x5b/0x1e0 mm/truncate.c:189
 truncate_inode_partial_folio+0x4ab/0x8e0 mm/truncate.c:255
 truncate_inode_pages_range+0x5f1/0xe30 mm/truncate.c:416
 ext4_truncate_failed_write fs/ext4/truncate.h:21 [inline]
 ext4_write_end+0x784/0xa30 fs/ext4/inode.c:1495
 generic_perform_write+0x620/0x8f0 mm/filemap.c:4346
 ext4_buffered_write_iter+0xce/0x3a0 fs/ext4/file.c:316
 ext4_file_write_iter+0x298/0x1bf0 fs/ext4/file.c:-1
 new_sync_write fs/read_write.c:595 [inline]
 vfs_write+0x61d/0xb90 fs/read_write.c:688
 ksys_pwrite64 fs/read_write.c:795 [inline]
 __do_sys_pwrite64 fs/read_write.c:803 [inline]
 __se_sys_pwrite64 fs/read_write.c:800 [inline]
 __x64_sys_pwrite64+0x199/0x230 fs/read_write.c:800
 do_syscall_x64 arch/x86/entry/syscall_64.c:63 [inline]
 do_syscall_64+0x174/0x580 arch/x86/entry/syscall_64.c:94
 entry_SYSCALL_64_after_hwframe+0x77/0x7f
RIP: 0033:0x7fb06359ce59
Code: ff c3 66 2e 0f 1f 84 00 00 00 00 00 0f 1f 44 00 00 48 89 f8 48 89 f7 =
48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 ff f=
f 73 01 c3 48 c7 c1 e8 ff ff ff f7 d8 64 89 01 48
RSP: 002b:00007fb0643ff028 EFLAGS: 00000246 ORIG_RAX: 0000000000000012
RAX: ffffffffffffffda RBX: 00007fb063815fa0 RCX: 00007fb06359ce59
RDX: 000000000000fdef RSI: 0000200000000140 RDI: 0000000000000004
RBP: 00007fb063632d6f R08: 0000000000000000 R09: 0000000000000000
R10: 0000000000000c00 R11: 0000000000000246 R12: 0000000000000000
R13: 00007fb063816038 R14: 00007fb063815fa0 R15: 00007ffe99cbba98
 </TASK>
BUG: Bad page state in process syz.0.17  pfn:11e234
page: refcount:0 mapcount:0 mapping:0000000000000000 index:0x4 pfn:0x11e234
head: order:0 mapcount:0 entire_mapcount:1 nr_pages_mapped:0 pincount:0
flags: 0x17ff20000000040(head|node=3D0|zone=3D2|lastcpupid=3D0x7ff)
raw: 017ff20000000040 0000000000000000 dead000000000122 0000000000000000
raw: 0000000000000004 0000000000000000 00000000ffffffff 0000000000000000
head: 017ff20000000040 0000000000000000 dead000000000122 0000000000000000
head: 0000000000000004 0000000000000000 00000000ffffffff 0000000000000000
head: 017ff00000000000 0000000000000000 00000000ffffffff 0000000000000000
head: ffffffffffffffff 0000000000000000 00000000ffffffff 0000000000000000
page dumped because: PAGE_FLAGS_CHECK_AT_FREE flag(s) set
page_owner tracks the page as allocated
page last allocated via order 2, migratetype Movable, gfp_mask 0x153cca(GFP=
_HIGHUSER_MOVABLE|__GFP_WRITE|__GFP_NOWARN|__GFP_NORETRY|__GFP_COMP), pid 5=
841, tgid 5840 (syz.0.17), ts 75851604747, free_ts 72751484534
 set_page_owner include/linux/page_owner.h:32 [inline]
 post_alloc_hook+0x22d/0x280 mm/page_alloc.c:1853
 prep_new_page mm/page_alloc.c:1861 [inline]
 get_page_from_freelist+0x2593/0x2610 mm/page_alloc.c:3941
 __alloc_frozen_pages_noprof+0x18d/0x380 mm/page_alloc.c:5221
 alloc_pages_mpol+0x235/0x490 mm/mempolicy.c:2490
 alloc_frozen_pages_noprof mm/mempolicy.c:2561 [inline]
 alloc_pages_noprof+0xac/0x2a0 mm/mempolicy.c:2581
 folio_alloc_noprof+0x1e/0x30 mm/mempolicy.c:2591
 filemap_alloc_folio_noprof+0x111/0x470 mm/filemap.c:1014
 __filemap_get_folio_mpol+0x3fc/0xb00 mm/filemap.c:2012
 __filemap_get_folio include/linux/pagemap.h:763 [inline]
 write_begin_get_folio include/linux/pagemap.h:789 [inline]
 ext4_write_begin+0x4ad/0x1890 fs/ext4/inode.c:1331
 generic_perform_write+0x2e2/0x8f0 mm/filemap.c:4325
 ext4_buffered_write_iter+0xce/0x3a0 fs/ext4/file.c:316
 ext4_file_write_iter+0x298/0x1bf0 fs/ext4/file.c:-1
 new_sync_write fs/read_write.c:595 [inline]
 vfs_write+0x61d/0xb90 fs/read_write.c:688
 ksys_pwrite64 fs/read_write.c:795 [inline]
 __do_sys_pwrite64 fs/read_write.c:803 [inline]
 __se_sys_pwrite64 fs/read_write.c:800 [inline]
 __x64_sys_pwrite64+0x199/0x230 fs/read_write.c:800
 do_syscall_x64 arch/x86/entry/syscall_64.c:63 [inline]
 do_syscall_64+0x174/0x580 arch/x86/entry/syscall_64.c:94
 entry_SYSCALL_64_after_hwframe+0x77/0x7f
page last free pid 5718 tgid 5718 stack trace:
 reset_page_owner include/linux/page_owner.h:25 [inline]
 __free_pages_prepare mm/page_alloc.c:1397 [inline]
 free_unref_folios+0xd9f/0x14c0 mm/page_alloc.c:2999
 folios_put_refs+0x9ff/0xb40 mm/swap.c:1008
 free_pages_and_swap_cache+0x41d/0x490 mm/swap_state.c:404
 __tlb_batch_free_encoded_pages mm/mmu_gather.c:138 [inline]
 tlb_batch_pages_flush mm/mmu_gather.c:151 [inline]
 tlb_flush_mmu_free mm/mmu_gather.c:417 [inline]
 tlb_flush_mmu+0x6d3/0xa30 mm/mmu_gather.c:424
 tlb_finish_mmu+0xf9/0x230 mm/mmu_gather.c:549
 exit_mmap+0x498/0x9e0 mm/mmap.c:1313
 __mmput+0x118/0x430 kernel/fork.c:1178
 exit_mm+0x1f6/0x2d0 kernel/exit.c:582
 do_exit+0x6a2/0x22c0 kernel/exit.c:964
 do_group_exit+0x21b/0x2d0 kernel/exit.c:1119
 get_signal+0x1284/0x1330 kernel/signal.c:3037
 arch_do_signal_or_restart+0xbc/0x840 arch/x86/kernel/signal.c:337
 __exit_to_user_mode_loop kernel/entry/common.c:64 [inline]
 exit_to_user_mode_loop+0xa9/0x680 kernel/entry/common.c:98
 __exit_to_user_mode_prepare include/linux/irq-entry-common.h:207 [inline]
 syscall_exit_to_user_mode_prepare include/linux/irq-entry-common.h:230 [in=
line]
 syscall_exit_to_user_mode include/linux/entry-common.h:318 [inline]
 do_syscall_64+0x353/0x580 arch/x86/entry/syscall_64.c:100
 entry_SYSCALL_64_after_hwframe+0x77/0x7f
Modules linked in:
CPU: 1 UID: 0 PID: 5841 Comm: syz.0.17 Tainted: G    B               syzkal=
ler #0 PREEMPT(full)=20
Tainted: [B]=3DBAD_PAGE
Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS 1.16.2-debian-1.16=
.2-1 04/01/2014
Call Trace:
 <TASK>
 dump_stack_lvl+0xe8/0x150 lib/dump_stack.c:120
 bad_page+0x17f/0x1c0 mm/page_alloc.c:632
 free_page_is_bad mm/page_alloc.c:1076 [inline]
 __free_pages_prepare mm/page_alloc.c:1388 [inline]
 __free_frozen_pages+0xcd9/0xd30 mm/page_alloc.c:2938
 __folio_put+0x4a2/0x580 mm/swap.c:112
 __folio_split+0xffe/0x1570 mm/huge_memory.c:4199
 try_folio_split_to_order include/linux/huge_mm.h:411 [inline]
 try_folio_split_or_unmap+0x5b/0x1e0 mm/truncate.c:189
 truncate_inode_partial_folio+0x4ab/0x8e0 mm/truncate.c:255
 truncate_inode_pages_range+0x5f1/0xe30 mm/truncate.c:416
 ext4_truncate_failed_write fs/ext4/truncate.h:21 [inline]
 ext4_write_end+0x784/0xa30 fs/ext4/inode.c:1495
 generic_perform_write+0x620/0x8f0 mm/filemap.c:4346
 ext4_buffered_write_iter+0xce/0x3a0 fs/ext4/file.c:316
 ext4_file_write_iter+0x298/0x1bf0 fs/ext4/file.c:-1
 new_sync_write fs/read_write.c:595 [inline]
 vfs_write+0x61d/0xb90 fs/read_write.c:688
 ksys_pwrite64 fs/read_write.c:795 [inline]
 __do_sys_pwrite64 fs/read_write.c:803 [inline]
 __se_sys_pwrite64 fs/read_write.c:800 [inline]
 __x64_sys_pwrite64+0x199/0x230 fs/read_write.c:800
 do_syscall_x64 arch/x86/entry/syscall_64.c:63 [inline]
 do_syscall_64+0x174/0x580 arch/x86/entry/syscall_64.c:94
 entry_SYSCALL_64_after_hwframe+0x77/0x7f
RIP: 0033:0x7fb06359ce59
Code: ff c3 66 2e 0f 1f 84 00 00 00 00 00 0f 1f 44 00 00 48 89 f8 48 89 f7 =
48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 ff f=
f 73 01 c3 48 c7 c1 e8 ff ff ff f7 d8 64 89 01 48
RSP: 002b:00007fb0643ff028 EFLAGS: 00000246 ORIG_RAX: 0000000000000012
RAX: ffffffffffffffda RBX: 00007fb063815fa0 RCX: 00007fb06359ce59
RDX: 000000000000fdef RSI: 0000200000000140 RDI: 0000000000000004
RBP: 00007fb063632d6f R08: 0000000000000000 R09: 0000000000000000
R10: 0000000000000c00 R11: 0000000000000246 R12: 0000000000000000
R13: 00007fb063816038 R14: 00007fb063815fa0 R15: 00007ffe99cbba98
 </TASK>


***

BUG: Bad page state in iomap_write_begin

tree:      mm-new
URL:       https://kernel.googlesource.com/pub/scm/linux/kernel/git/akpm/mm=
.git
base:      1ec3cca2d8b6b9ff6584ca626d4c8918bbf48d44
arch:      amd64
compiler:  Debian clang version 21.1.8 (++20251221033036+2078da43e25a-1~exp=
1~20251221153213.50), Debian LLD 21.1.8
config:    https://ci.syzbot.org/builds/ffde37a3-aed0-4f49-bba1-ca31cd6a4b0=
4/config
syz repro: https://ci.syzbot.org/findings/8030d7fe-0d2e-4e47-ab50-b1211533d=
9c1/syz_repro

XFS (loop0): Mounting V5 Filesystem d7dc424e-7990-42cb-9f91-9cb7200a101d
XFS (loop0): Ending clean mount
BUG: Bad page state in process syz.0.17  pfn:1a6481
page: refcount:0 mapcount:0 mapping:0000000000000000 index:0x8081 pfn:0x1a6=
481
flags: 0x57ff20000000000(node=3D1|zone=3D2|lastcpupid=3D0x7ff)
raw: 057ff20000000000 0000000000000000 00000000ffffffff 0000000000000000
raw: 0000000000008081 0000000000000000 00000000ffffffff 0000000000000000
page dumped because: PAGE_FLAGS_CHECK_AT_FREE flag(s) set
page_owner tracks the page as allocated
page last allocated via order 0, migratetype Movable, gfp_mask 0x153c4a(GFP=
_NOFS|__GFP_HIGHMEM|__GFP_MOVABLE|__GFP_WRITE|__GFP_NOWARN|__GFP_NORETRY|__=
GFP_COMP|__GFP_HARDWALL), pid 5877, tgid 5876 (syz.0.17), ts 79178255762, f=
ree_ts 72347127723
 set_page_owner include/linux/page_owner.h:32 [inline]
 post_alloc_hook+0x22d/0x280 mm/page_alloc.c:1853
 prep_new_page mm/page_alloc.c:1861 [inline]
 get_page_from_freelist+0x2593/0x2610 mm/page_alloc.c:3941
 __alloc_frozen_pages_noprof+0x18d/0x380 mm/page_alloc.c:5221
 alloc_pages_mpol+0x235/0x490 mm/mempolicy.c:2490
 alloc_frozen_pages_noprof mm/mempolicy.c:2561 [inline]
 alloc_pages_noprof+0xac/0x2a0 mm/mempolicy.c:2581
 folio_alloc_noprof+0x1e/0x30 mm/mempolicy.c:2591
 filemap_alloc_folio_noprof+0x111/0x470 mm/filemap.c:1014
 __filemap_get_folio_mpol+0x3fc/0xb00 mm/filemap.c:2012
 __filemap_get_folio include/linux/pagemap.h:763 [inline]
 iomap_get_folio fs/iomap/buffered-io.c:725 [inline]
 __iomap_get_folio fs/iomap/buffered-io.c:896 [inline]
 iomap_write_begin+0x6d9/0x14f0 fs/iomap/buffered-io.c:960
 iomap_write_iter fs/iomap/buffered-io.c:1144 [inline]
 iomap_file_buffered_write+0x47a/0xb30 fs/iomap/buffered-io.c:1225
 xfs_file_buffered_write+0x212/0x8c0 fs/xfs/xfs_file.c:1056
 new_sync_write fs/read_write.c:595 [inline]
 vfs_write+0x61d/0xb90 fs/read_write.c:688
 ksys_pwrite64 fs/read_write.c:795 [inline]
 __do_sys_pwrite64 fs/read_write.c:803 [inline]
 __se_sys_pwrite64 fs/read_write.c:800 [inline]
 __x64_sys_pwrite64+0x199/0x230 fs/read_write.c:800
 do_syscall_x64 arch/x86/entry/syscall_64.c:63 [inline]
 do_syscall_64+0x174/0x580 arch/x86/entry/syscall_64.c:94
 entry_SYSCALL_64_after_hwframe+0x77/0x7f
page last free pid 5710 tgid 5710 stack trace:
 reset_page_owner include/linux/page_owner.h:25 [inline]
 __free_pages_prepare mm/page_alloc.c:1397 [inline]
 free_unref_folios+0xd9f/0x14c0 mm/page_alloc.c:2999
 folios_put_refs+0x9ff/0xb40 mm/swap.c:1008
 free_pages_and_swap_cache+0x2b9/0x490 mm/swap_state.c:401
 __tlb_batch_free_encoded_pages mm/mmu_gather.c:138 [inline]
 tlb_batch_pages_flush mm/mmu_gather.c:151 [inline]
 tlb_flush_mmu_free mm/mmu_gather.c:417 [inline]
 tlb_flush_mmu+0x6d3/0xa30 mm/mmu_gather.c:424
 tlb_finish_mmu+0xf9/0x230 mm/mmu_gather.c:549
 exit_mmap+0x498/0x9e0 mm/mmap.c:1313
 __mmput+0x118/0x430 kernel/fork.c:1178
 exit_mm+0x1f6/0x2d0 kernel/exit.c:582
 do_exit+0x6a2/0x22c0 kernel/exit.c:964
 do_group_exit+0x21b/0x2d0 kernel/exit.c:1119
 get_signal+0x1284/0x1330 kernel/signal.c:3037
 arch_do_signal_or_restart+0xbc/0x840 arch/x86/kernel/signal.c:337
 __exit_to_user_mode_loop kernel/entry/common.c:64 [inline]
 exit_to_user_mode_loop+0xa9/0x680 kernel/entry/common.c:98
 __exit_to_user_mode_prepare include/linux/irq-entry-common.h:207 [inline]
 syscall_exit_to_user_mode_prepare include/linux/irq-entry-common.h:230 [in=
line]
 syscall_exit_to_user_mode include/linux/entry-common.h:318 [inline]
 do_syscall_64+0x353/0x580 arch/x86/entry/syscall_64.c:100
 entry_SYSCALL_64_after_hwframe+0x77/0x7f
Modules linked in:
CPU: 1 UID: 0 PID: 5877 Comm: syz.0.17 Not tainted syzkaller #0 PREEMPT(ful=
l)=20
Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS 1.16.2-debian-1.16=
.2-1 04/01/2014
Call Trace:
 <TASK>
 dump_stack_lvl+0xe8/0x150 lib/dump_stack.c:120
 bad_page+0x17f/0x1c0 mm/page_alloc.c:632
 free_page_is_bad mm/page_alloc.c:1076 [inline]
 __free_pages_prepare mm/page_alloc.c:1388 [inline]
 __free_frozen_pages+0xcd9/0xd30 mm/page_alloc.c:2938
 __folio_put+0x4a2/0x580 mm/swap.c:112
 __folio_split+0xffe/0x1570 mm/huge_memory.c:4199
 try_folio_split_to_order include/linux/huge_mm.h:411 [inline]
 try_folio_split_or_unmap+0x5b/0x1e0 mm/truncate.c:189
 truncate_inode_partial_folio+0x4ab/0x8e0 mm/truncate.c:255
 truncate_inode_pages_range+0x5f1/0xe30 mm/truncate.c:416
 iomap_write_failed fs/iomap/buffered-io.c:785 [inline]
 iomap_write_iter fs/iomap/buffered-io.c:1187 [inline]
 iomap_file_buffered_write+0x788/0xb30 fs/iomap/buffered-io.c:1225
 xfs_file_buffered_write+0x212/0x8c0 fs/xfs/xfs_file.c:1056
 new_sync_write fs/read_write.c:595 [inline]
 vfs_write+0x61d/0xb90 fs/read_write.c:688
 ksys_pwrite64 fs/read_write.c:795 [inline]
 __do_sys_pwrite64 fs/read_write.c:803 [inline]
 __se_sys_pwrite64 fs/read_write.c:800 [inline]
 __x64_sys_pwrite64+0x199/0x230 fs/read_write.c:800
 do_syscall_x64 arch/x86/entry/syscall_64.c:63 [inline]
 do_syscall_64+0x174/0x580 arch/x86/entry/syscall_64.c:94
 entry_SYSCALL_64_after_hwframe+0x77/0x7f
RIP: 0033:0x7f3f0719ce59
Code: ff c3 66 2e 0f 1f 84 00 00 00 00 00 0f 1f 44 00 00 48 89 f8 48 89 f7 =
48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 ff f=
f 73 01 c3 48 c7 c1 e8 ff ff ff f7 d8 64 89 01 48
RSP: 002b:00007f3f07ff7028 EFLAGS: 00000246 ORIG_RAX: 0000000000000012
RAX: ffffffffffffffda RBX: 00007f3f07415fa0 RCX: 00007f3f0719ce59
RDX: 00000000ffffffb7 RSI: 0000200000000040 RDI: 0000000000000004
RBP: 00007f3f07232d6f R08: 0000000000000000 R09: 0000000000000000
R10: 0000000008080c61 R11: 0000000000000246 R12: 0000000000000000
R13: 00007f3f07416038 R14: 00007f3f07415fa0 R15: 00007ffe415e9148
 </TASK>
BUG: Bad page state in process syz.0.17  pfn:1a6482
page: refcount:0 mapcount:0 mapping:0000000000000000 index:0x8082 pfn:0x1a6=
482
head: order:0 mapcount:0 entire_mapcount:1 nr_pages_mapped:0 pincount:0
flags: 0x57ff20000000040(head|node=3D1|zone=3D2|lastcpupid=3D0x7ff)
raw: 057ff20000000040 0000000000000000 ffffea0006992090 0000000000000000
raw: 0000000000008082 0000000000000000 00000000ffffffff 0000000000000000
head: 057ff20000000040 0000000000000000 ffffea0006992090 0000000000000000
head: 0000000000008082 0000000000000000 00000000ffffffff 0000000000000000
head: 057ff00000000000 0000000000000000 00000000ffffffff 0000000000000000
head: ffffffffffffffff 0000000000000000 00000000ffffffff 0000000000000000
page dumped because: PAGE_FLAGS_CHECK_AT_FREE flag(s) set
page_owner tracks the page as allocated
page last allocated via order 1, migratetype Movable, gfp_mask 0x153c4a(GFP=
_NOFS|__GFP_HIGHMEM|__GFP_MOVABLE|__GFP_WRITE|__GFP_NOWARN|__GFP_NORETRY|__=
GFP_COMP|__GFP_HARDWALL), pid 5877, tgid 5876 (syz.0.17), ts 79178255762, f=
ree_ts 72347116236
 set_page_owner include/linux/page_owner.h:32 [inline]
 post_alloc_hook+0x22d/0x280 mm/page_alloc.c:1853
 prep_new_page mm/page_alloc.c:1861 [inline]
 get_page_from_freelist+0x2593/0x2610 mm/page_alloc.c:3941
 __alloc_frozen_pages_noprof+0x18d/0x380 mm/page_alloc.c:5221
 alloc_pages_mpol+0x235/0x490 mm/mempolicy.c:2490
 alloc_frozen_pages_noprof mm/mempolicy.c:2561 [inline]
 alloc_pages_noprof+0xac/0x2a0 mm/mempolicy.c:2581
 folio_alloc_noprof+0x1e/0x30 mm/mempolicy.c:2591
 filemap_alloc_folio_noprof+0x111/0x470 mm/filemap.c:1014
 __filemap_get_folio_mpol+0x3fc/0xb00 mm/filemap.c:2012
 __filemap_get_folio include/linux/pagemap.h:763 [inline]
 iomap_get_folio fs/iomap/buffered-io.c:725 [inline]
 __iomap_get_folio fs/iomap/buffered-io.c:896 [inline]
 iomap_write_begin+0x6d9/0x14f0 fs/iomap/buffered-io.c:960
 iomap_write_iter fs/iomap/buffered-io.c:1144 [inline]
 iomap_file_buffered_write+0x47a/0xb30 fs/iomap/buffered-io.c:1225
 xfs_file_buffered_write+0x212/0x8c0 fs/xfs/xfs_file.c:1056
 new_sync_write fs/read_write.c:595 [inline]
 vfs_write+0x61d/0xb90 fs/read_write.c:688
 ksys_pwrite64 fs/read_write.c:795 [inline]
 __do_sys_pwrite64 fs/read_write.c:803 [inline]
 __se_sys_pwrite64 fs/read_write.c:800 [inline]
 __x64_sys_pwrite64+0x199/0x230 fs/read_write.c:800
 do_syscall_x64 arch/x86/entry/syscall_64.c:63 [inline]
 do_syscall_64+0x174/0x580 arch/x86/entry/syscall_64.c:94
 entry_SYSCALL_64_after_hwframe+0x77/0x7f
page last free pid 5710 tgid 5710 stack trace:
 reset_page_owner include/linux/page_owner.h:25 [inline]
 __free_pages_prepare mm/page_alloc.c:1397 [inline]
 free_unref_folios+0xd9f/0x14c0 mm/page_alloc.c:2999
 folios_put_refs+0x9ff/0xb40 mm/swap.c:1008
 free_pages_and_swap_cache+0x2b9/0x490 mm/swap_state.c:401
 __tlb_batch_free_encoded_pages mm/mmu_gather.c:138 [inline]
 tlb_batch_pages_flush mm/mmu_gather.c:151 [inline]
 tlb_flush_mmu_free mm/mmu_gather.c:417 [inline]
 tlb_flush_mmu+0x6d3/0xa30 mm/mmu_gather.c:424
 tlb_finish_mmu+0xf9/0x230 mm/mmu_gather.c:549
 exit_mmap+0x498/0x9e0 mm/mmap.c:1313
 __mmput+0x118/0x430 kernel/fork.c:1178
 exit_mm+0x1f6/0x2d0 kernel/exit.c:582
 do_exit+0x6a2/0x22c0 kernel/exit.c:964
 do_group_exit+0x21b/0x2d0 kernel/exit.c:1119
 get_signal+0x1284/0x1330 kernel/signal.c:3037
 arch_do_signal_or_restart+0xbc/0x840 arch/x86/kernel/signal.c:337
 __exit_to_user_mode_loop kernel/entry/common.c:64 [inline]
 exit_to_user_mode_loop+0xa9/0x680 kernel/entry/common.c:98
 __exit_to_user_mode_prepare include/linux/irq-entry-common.h:207 [inline]
 syscall_exit_to_user_mode_prepare include/linux/irq-entry-common.h:230 [in=
line]
 syscall_exit_to_user_mode include/linux/entry-common.h:318 [inline]
 do_syscall_64+0x353/0x580 arch/x86/entry/syscall_64.c:100
 entry_SYSCALL_64_after_hwframe+0x77/0x7f
Modules linked in:
CPU: 0 UID: 0 PID: 5877 Comm: syz.0.17 Tainted: G    B               syzkal=
ler #0 PREEMPT(full)=20
Tainted: [B]=3DBAD_PAGE
Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS 1.16.2-debian-1.16=
.2-1 04/01/2014
Call Trace:
 <TASK>
 dump_stack_lvl+0xe8/0x150 lib/dump_stack.c:120
 bad_page+0x17f/0x1c0 mm/page_alloc.c:632
 free_page_is_bad mm/page_alloc.c:1076 [inline]
 __free_pages_prepare mm/page_alloc.c:1388 [inline]
 __free_frozen_pages+0xcd9/0xd30 mm/page_alloc.c:2938
 __folio_put+0x4a2/0x580 mm/swap.c:112
 __folio_split+0xffe/0x1570 mm/huge_memory.c:4199
 try_folio_split_to_order include/linux/huge_mm.h:411 [inline]
 try_folio_split_or_unmap+0x5b/0x1e0 mm/truncate.c:189
 truncate_inode_partial_folio+0x4ab/0x8e0 mm/truncate.c:255
 truncate_inode_pages_range+0x5f1/0xe30 mm/truncate.c:416
 iomap_write_failed fs/iomap/buffered-io.c:785 [inline]
 iomap_write_iter fs/iomap/buffered-io.c:1187 [inline]
 iomap_file_buffered_write+0x788/0xb30 fs/iomap/buffered-io.c:1225
 xfs_file_buffered_write+0x212/0x8c0 fs/xfs/xfs_file.c:1056
 new_sync_write fs/read_write.c:595 [inline]
 vfs_write+0x61d/0xb90 fs/read_write.c:688
 ksys_pwrite64 fs/read_write.c:795 [inline]
 __do_sys_pwrite64 fs/read_write.c:803 [inline]
 __se_sys_pwrite64 fs/read_write.c:800 [inline]
 __x64_sys_pwrite64+0x199/0x230 fs/read_write.c:800
 do_syscall_x64 arch/x86/entry/syscall_64.c:63 [inline]
 do_syscall_64+0x174/0x580 arch/x86/entry/syscall_64.c:94
 entry_SYSCALL_64_after_hwframe+0x77/0x7f
RIP: 0033:0x7f3f0719ce59
Code: ff c3 66 2e 0f 1f 84 00 00 00 00 00 0f 1f 44 00 00 48 89 f8 48 89 f7 =
48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 ff f=
f 73 01 c3 48 c7 c1 e8 ff ff ff f7 d8 64 89 01 48
RSP: 002b:00007f3f07ff7028 EFLAGS: 00000246 ORIG_RAX: 0000000000000012
RAX: ffffffffffffffda RBX: 00007f3f07415fa0 RCX: 00007f3f0719ce59
RDX: 00000000ffffffb7 RSI: 0000200000000040 RDI: 0000000000000004
RBP: 00007f3f07232d6f R08: 0000000000000000 R09: 0000000000000000
R10: 0000000008080c61 R11: 0000000000000246 R12: 0000000000000000
R13: 00007f3f07416038 R14: 00007f3f07415fa0 R15: 00007ffe415e9148
 </TASK>
BUG: Bad page state in process syz.0.17  pfn:1a6484
page: refcount:0 mapcount:0 mapping:0000000000000000 index:0x8084 pfn:0x1a6=
484
head: order:0 mapcount:0 entire_mapcount:1 nr_pages_mapped:0 pincount:0
flags: 0x57ff20000000040(head|node=3D1|zone=3D2|lastcpupid=3D0x7ff)
raw: 057ff20000000040 0000000000000000 dead000000000122 0000000000000000
raw: 0000000000008084 0000000000000000 00000000ffffffff 0000000000000000
head: 057ff20000000040 0000000000000000 dead000000000122 0000000000000000
head: 0000000000008084 0000000000000000 00000000ffffffff 0000000000000000
head: 057ff00000000000 0000000000000000 00000000ffffffff 0000000000000000
head: ffffffffffffffff 0000000000000000 00000000ffffffff 0000000000000000
page dumped because: PAGE_FLAGS_CHECK_AT_FREE flag(s) set
page_owner tracks the page as allocated
page last allocated via order 2, migratetype Movable, gfp_mask 0x153c4a(GFP=
_NOFS|__GFP_HIGHMEM|__GFP_MOVABLE|__GFP_WRITE|__GFP_NOWARN|__GFP_NORETRY|__=
GFP_COMP|__GFP_HARDWALL), pid 5877, tgid 5876 (syz.0.17), ts 79178255762, f=
ree_ts 72347038008
 set_page_owner include/linux/page_owner.h:32 [inline]
 post_alloc_hook+0x22d/0x280 mm/page_alloc.c:1853
 prep_new_page mm/page_alloc.c:1861 [inline]
 get_page_from_freelist+0x2593/0x2610 mm/page_alloc.c:3941
 __alloc_frozen_pages_noprof+0x18d/0x380 mm/page_alloc.c:5221
 alloc_pages_mpol+0x235/0x490 mm/mempolicy.c:2490
 alloc_frozen_pages_noprof mm/mempolicy.c:2561 [inline]
 alloc_pages_noprof+0xac/0x2a0 mm/mempolicy.c:2581
 folio_alloc_noprof+0x1e/0x30 mm/mempolicy.c:2591
 filemap_alloc_folio_noprof+0x111/0x470 mm/filemap.c:1014
 __filemap_get_folio_mpol+0x3fc/0xb00 mm/filemap.c:2012
 __filemap_get_folio include/linux/pagemap.h:763 [inline]
 iomap_get_folio fs/iomap/buffered-io.c:725 [inline]
 __iomap_get_folio fs/iomap/buffered-io.c:896 [inline]
 iomap_write_begin+0x6d9/0x14f0 fs/iomap/buffered-io.c:960
 iomap_write_iter fs/iomap/buffered-io.c:1144 [inline]
 iomap_file_buffered_write+0x47a/0xb30 fs/iomap/buffered-io.c:1225
 xfs_file_buffered_write+0x212/0x8c0 fs/xfs/xfs_file.c:1056
 new_sync_write fs/read_write.c:595 [inline]
 vfs_write+0x61d/0xb90 fs/read_write.c:688
 ksys_pwrite64 fs/read_write.c:795 [inline]
 __do_sys_pwrite64 fs/read_write.c:803 [inline]
 __se_sys_pwrite64 fs/read_write.c:800 [inline]
 __x64_sys_pwrite64+0x199/0x230 fs/read_write.c:800
 do_syscall_x64 arch/x86/entry/syscall_64.c:63 [inline]
 do_syscall_64+0x174/0x580 arch/x86/entry/syscall_64.c:94
 entry_SYSCALL_64_after_hwframe+0x77/0x7f
page last free pid 5710 tgid 5710 stack trace:
 reset_page_owner include/linux/page_owner.h:25 [inline]
 __free_pages_prepare mm/page_alloc.c:1397 [inline]
 free_unref_folios+0xd9f/0x14c0 mm/page_alloc.c:2999
 folios_put_refs+0x9ff/0xb40 mm/swap.c:1008
 free_pages_and_swap_cache+0x2b9/0x490 mm/swap_state.c:401
 __tlb_batch_free_encoded_pages mm/mmu_gather.c:138 [inline]
 tlb_batch_pages_flush mm/mmu_gather.c:151 [inline]
 tlb_flush_mmu_free mm/mmu_gather.c:417 [inline]
 tlb_flush_mmu+0x6d3/0xa30 mm/mmu_gather.c:424
 tlb_finish_mmu+0xf9/0x230 mm/mmu_gather.c:549
 exit_mmap+0x498/0x9e0 mm/mmap.c:1313
 __mmput+0x118/0x430 kernel/fork.c:1178
 exit_mm+0x1f6/0x2d0 kernel/exit.c:582
 do_exit+0x6a2/0x22c0 kernel/exit.c:964
 do_group_exit+0x21b/0x2d0 kernel/exit.c:1119
 get_signal+0x1284/0x1330 kernel/signal.c:3037
 arch_do_signal_or_restart+0xbc/0x840 arch/x86/kernel/signal.c:337
 __exit_to_user_mode_loop kernel/entry/common.c:64 [inline]
 exit_to_user_mode_loop+0xa9/0x680 kernel/entry/common.c:98
 __exit_to_user_mode_prepare include/linux/irq-entry-common.h:207 [inline]
 syscall_exit_to_user_mode_prepare include/linux/irq-entry-common.h:230 [in=
line]
 syscall_exit_to_user_mode include/linux/entry-common.h:318 [inline]
 do_syscall_64+0x353/0x580 arch/x86/entry/syscall_64.c:100
 entry_SYSCALL_64_after_hwframe+0x77/0x7f
Modules linked in:
CPU: 0 UID: 0 PID: 5877 Comm: syz.0.17 Tainted: G    B               syzkal=
ler #0 PREEMPT(full)=20
Tainted: [B]=3DBAD_PAGE
Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS 1.16.2-debian-1.16=
.2-1 04/01/2014
Call Trace:
 <TASK>
 dump_stack_lvl+0xe8/0x150 lib/dump_stack.c:120
 bad_page+0x17f/0x1c0 mm/page_alloc.c:632
 free_page_is_bad mm/page_alloc.c:1076 [inline]
 __free_pages_prepare mm/page_alloc.c:1388 [inline]
 __free_frozen_pages+0xcd9/0xd30 mm/page_alloc.c:2938
 __folio_put+0x4a2/0x580 mm/swap.c:112
 __folio_split+0xffe/0x1570 mm/huge_memory.c:4199
 try_folio_split_to_order include/linux/huge_mm.h:411 [inline]
 try_folio_split_or_unmap+0x5b/0x1e0 mm/truncate.c:189
 truncate_inode_partial_folio+0x4ab/0x8e0 mm/truncate.c:255
 truncate_inode_pages_range+0x5f1/0xe30 mm/truncate.c:416
 iomap_write_failed fs/iomap/buffered-io.c:785 [inline]
 iomap_write_iter fs/iomap/buffered-io.c:1187 [inline]
 iomap_file_buffered_write+0x788/0xb30 fs/iomap/buffered-io.c:1225
 xfs_file_buffered_write+0x212/0x8c0 fs/xfs/xfs_file.c:1056
 new_sync_write fs/read_write.c:595 [inline]
 vfs_write+0x61d/0xb90 fs/read_write.c:688
 ksys_pwrite64 fs/read_write.c:795 [inline]
 __do_sys_pwrite64 fs/read_write.c:803 [inline]
 __se_sys_pwrite64 fs/read_write.c:800 [inline]
 __x64_sys_pwrite64+0x199/0x230 fs/read_write.c:800
 do_syscall_x64 arch/x86/entry/syscall_64.c:63 [inline]
 do_syscall_64+0x174/0x580 arch/x86/entry/syscall_64.c:94
 entry_SYSCALL_64_after_hwframe+0x77/0x7f
RIP: 0033:0x7f3f0719ce59
Code: ff c3 66 2e 0f 1f 84 00 00 00 00 00 0f 1f 44 00 00 48 89 f8 48 89 f7 =
48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 ff f=
f 73 01 c3 48 c7 c1 e8 ff ff ff f7 d8 64 89 01 48
RSP: 002b:00007f3f07ff7028 EFLAGS: 00000246 ORIG_RAX: 0000000000000012
RAX: ffffffffffffffda RBX: 00007f3f07415fa0 RCX: 00007f3f0719ce59
RDX: 00000000ffffffb7 RSI: 0000200000000040 RDI: 0000000000000004
RBP: 00007f3f07232d6f R08: 0000000000000000 R09: 0000000000000000
R10: 0000000008080c61 R11: 0000000000000246 R12: 0000000000000000
R13: 00007f3f07416038 R14: 00007f3f07415fa0 R15: 00007ffe415e9148
 </TASK>
BUG: Bad page state in process syz.0.17  pfn:1a6488
page: refcount:0 mapcount:0 mapping:0000000000000000 index:0x8088 pfn:0x1a6=
488
head: order:0 mapcount:0 entire_mapcount:1 nr_pages_mapped:0 pincount:0
flags: 0x57ff20000000040(head|node=3D1|zone=3D2|lastcpupid=3D0x7ff)
raw: 057ff20000000040 0000000000000000 dead000000000122 0000000000000000
raw: 0000000000008088 0000000000000000 00000000ffffffff 0000000000000000
head: 057ff20000000040 0000000000000000 dead000000000122 0000000000000000
head: 0000000000008088 0000000000000000 00000000ffffffff 0000000000000000
head: 057ff00000000000 0000000000000000 00000000ffffffff 0000000000000000
head: ffffffffffffffff 0000000000000000 00000000ffffffff 0000000000000000
page dumped because: PAGE_FLAGS_CHECK_AT_FREE flag(s) set
page_owner tracks the page as allocated
page last allocated via order 3, migratetype Movable, gfp_mask 0x153c4a(GFP=
_NOFS|__GFP_HIGHMEM|__GFP_MOVABLE|__GFP_WRITE|__GFP_NOWARN|__GFP_NORETRY|__=
GFP_COMP|__GFP_HARDWALL), pid 5877, tgid 5876 (syz.0.17), ts 79178255762, f=
ree_ts 72346997158
 set_page_owner include/linux/page_owner.h:32 [inline]
 post_alloc_hook+0x22d/0x280 mm/page_alloc.c:1853
 prep_new_page mm/page_alloc.c:1861 [inline]
 get_page_from_freelist+0x2593/0x2610 mm/page_alloc.c:3941
 __alloc_frozen_pages_noprof+0x18d/0x380 mm/page_alloc.c:5221
 alloc_pages_mpol+0x235/0x490 mm/mempolicy.c:2490
 alloc_frozen_pages_noprof mm/mempolicy.c:2561 [inline]
 alloc_pages_noprof+0xac/0x2a0 mm/mempolicy.c:2581
 folio_alloc_noprof+0x1e/0x30 mm/mempolicy.c:2591
 filemap_alloc_folio_noprof+0x111/0x470 mm/filemap.c:1014
 __filemap_get_folio_mpol+0x3fc/0xb00 mm/filemap.c:2012
 __filemap_get_folio include/linux/pagemap.h:763 [inline]
 iomap_get_folio fs/iomap/buffered-io.c:725 [inline]
 __iomap_get_folio fs/iomap/buffered-io.c:896 [inline]
 iomap_write_begin+0x6d9/0x14f0 fs/iomap/buffered-io.c:960
 iomap_write_iter fs/iomap/buffered-io.c:1144 [inline]
 iomap_file_buffered_write+0x47a/0xb30 fs/iomap/buffered-io.c:1225
 xfs_file_buffered_write+0x212/0x8c0 fs/xfs/xfs_file.c:1056
 new_sync_write fs/read_write.c:595 [inline]
 vfs_write+0x61d/0xb90 fs/read_write.c:688
 ksys_pwrite64 fs/read_write.c:795 [inline]
 __do_sys_pwrite64 fs/read_write.c:803 [inline]
 __se_sys_pwrite64 fs/read_write.c:800 [inline]
 __x64_sys_pwrite64+0x199/0x230 fs/read_write.c:800
 do_syscall_x64 arch/x86/entry/syscall_64.c:63 [inline]
 do_syscall_64+0x174/0x580 arch/x86/entry/syscall_64.c:94
 entry_SYSCALL_64_after_hwframe+0x77/0x7f
page last free pid 5710 tgid 5710 stack trace:
 reset_page_owner include/linux/page_owner.h:25 [inline]
 __free_pages_prepare mm/page_alloc.c:1397 [inline]
 free_unref_folios+0xd9f/0x14c0 mm/page_alloc.c:2999
 folios_put_refs+0x9ff/0xb40 mm/swap.c:1008
 free_pages_and_swap_cache+0x2b9/0x490 mm/swap_state.c:401
 __tlb_batch_free_encoded_pages mm/mmu_gather.c:138 [inline]
 tlb_batch_pages_flush mm/mmu_gather.c:151 [inline]
 tlb_flush_mmu_free mm/mmu_gather.c:417 [inline]
 tlb_flush_mmu+0x6d3/0xa30 mm/mmu_gather.c:424
 tlb_finish_mmu+0xf9/0x230 mm/mmu_gather.c:549
 exit_mmap+0x498/0x9e0 mm/mmap.c:1313
 __mmput+0x118/0x430 kernel/fork.c:1178
 exit_mm+0x1f6/0x2d0 kernel/exit.c:582
 do_exit+0x6a2/0x22c0 kernel/exit.c:964
 do_group_exit+0x21b/0x2d0 kernel/exit.c:1119
 get_signal+0x1284/0x1330 kernel/signal.c:3037
 arch_do_signal_or_restart+0xbc/0x840 arch/x86/kernel/signal.c:337
 __exit_to_user_mode_loop kernel/entry/common.c:64 [inline]
 exit_to_user_mode_loop+0xa9/0x680 kernel/entry/common.c:98
 __exit_to_user_mode_prepare include/linux/irq-entry-common.h:207 [inline]
 syscall_exit_to_user_mode_prepare include/linux/irq-entry-common.h:230 [in=
line]
 syscall_exit_to_user_mode include/linux/entry-common.h:318 [inline]
 do_syscall_64+0x353/0x580 arch/x86/entry/syscall_64.c:100
 entry_SYSCALL_64_after_hwframe+0x77/0x7f
Modules linked in:

CPU: 1 UID: 0 PID: 5877 Comm: syz.0.17 Tainted: G    B               syzkal=
ler #0 PREEMPT(full)=20
Tainted: [B]=3DBAD_PAGE
Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS 1.16.2-debian-1.16=
.2-1 04/01/2014
Call Trace:
 <TASK>
 dump_stack_lvl+0xe8/0x150 lib/dump_stack.c:120
 bad_page+0x17f/0x1c0 mm/page_alloc.c:632
 free_page_is_bad mm/page_alloc.c:1076 [inline]
 __free_pages_prepare mm/page_alloc.c:1388 [inline]
 __free_frozen_pages+0xcd9/0xd30 mm/page_alloc.c:2938
 __folio_put+0x4a2/0x580 mm/swap.c:112
 __folio_split+0xffe/0x1570 mm/huge_memory.c:4199
 try_folio_split_to_order include/linux/huge_mm.h:411 [inline]
 try_folio_split_or_unmap+0x5b/0x1e0 mm/truncate.c:189
 truncate_inode_partial_folio+0x4ab/0x8e0 mm/truncate.c:255
 truncate_inode_pages_range+0x5f1/0xe30 mm/truncate.c:416
 iomap_write_failed fs/iomap/buffered-io.c:785 [inline]
 iomap_write_iter fs/iomap/buffered-io.c:1187 [inline]
 iomap_file_buffered_write+0x788/0xb30 fs/iomap/buffered-io.c:1225
 xfs_file_buffered_write+0x212/0x8c0 fs/xfs/xfs_file.c:1056
 new_sync_write fs/read_write.c:595 [inline]
 vfs_write+0x61d/0xb90 fs/read_write.c:688
 ksys_pwrite64 fs/read_write.c:795 [inline]
 __do_sys_pwrite64 fs/read_write.c:803 [inline]
 __se_sys_pwrite64 fs/read_write.c:800 [inline]
 __x64_sys_pwrite64+0x199/0x230 fs/read_write.c:800
 do_syscall_x64 arch/x86/entry/syscall_64.c:63 [inline]
 do_syscall_64+0x174/0x580 arch/x86/entry/syscall_64.c:94
 entry_SYSCALL_64_after_hwframe+0x77/0x7f
RIP: 0033:0x7f3f0719ce59
Code: ff c3 66 2e 0f 1f 84 00 00 00 00 00 0f 1f 44 00 00 48 89 f8 48 89 f7 =
48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 ff f=
f 73 01 c3 48 c7 c1 e8 ff ff ff f7 d8 64 89 01 48
RSP: 002b:00007f3f07ff7028 EFLAGS: 00000246 ORIG_RAX: 0000000000000012
RAX: ffffffffffffffda RBX: 00007f3f07415fa0 RCX: 00007f3f0719ce59
RDX: 00000000ffffffb7 RSI: 0000200000000040 RDI: 0000000000000004
RBP: 00007f3f07232d6f R08: 0000000000000000 R09: 0000000000000000
R10: 0000000008080c61 R11: 0000000000000246 R12: 0000000000000000
R13: 00007f3f07416038 R14: 00007f3f07415fa0 R15: 00007ffe415e9148
 </TASK>
BUG: Bad page state in process syz.0.17  pfn:1a6490
page: refcount:0 mapcount:0 mapping:0000000000000000 index:0x8090 pfn:0x1a6=
490
head: order:0 mapcount:0 entire_mapcount:1 nr_pages_mapped:0 pincount:0
flags: 0x57ff20000000040(head|node=3D1|zone=3D2|lastcpupid=3D0x7ff)
raw: 057ff20000000040 0000000000000000 dead000000000122 0000000000000000
raw: 0000000000008090 0000000000000000 00000000ffffffff 0000000000000000
head: 057ff20000000040 0000000000000000 dead000000000122 0000000000000000
head: 0000000000008090 0000000000000000 00000000ffffffff 0000000000000000
head: 057ff00000000000 0000000000000000 00000000ffffffff 0000000000000000
head: ffffffffffffffff 0000000000000000 00000000ffffffff 0000000000000000
page dumped because: PAGE_FLAGS_CHECK_AT_FREE flag(s) set
page_owner tracks the page as allocated
page last allocated via order 4, migratetype Movable, gfp_mask 0x153c4a(GFP=
_NOFS|__GFP_HIGHMEM|__GFP_MOVABLE|__GFP_WRITE|__GFP_NOWARN|__GFP_NORETRY|__=
GFP_COMP|__GFP_HARDWALL), pid 5877, tgid 5876 (syz.0.17), ts 79178255762, f=
ree_ts 72346919466
 set_page_owner include/linux/page_owner.h:32 [inline]
 post_alloc_hook+0x22d/0x280 mm/page_alloc.c:1853
 prep_new_page mm/page_alloc.c:1861 [inline]
 get_page_from_freelist+0x2593/0x2610 mm/page_alloc.c:3941
 __alloc_frozen_pages_noprof+0x18d/0x380 mm/page_alloc.c:5221
 alloc_pages_mpol+0x235/0x490 mm/mempolicy.c:2490
 alloc_frozen_pages_noprof mm/mempolicy.c:2561 [inline]
 alloc_pages_noprof+0xac/0x2a0 mm/mempolicy.c:2581
 folio_alloc_noprof+0x1e/0x30 mm/mempolicy.c:2591
 filemap_alloc_folio_noprof+0x111/0x470 mm/filemap.c:1014
 __filemap_get_folio_mpol+0x3fc/0xb00 mm/filemap.c:2012
 __filemap_get_folio include/linux/pagemap.h:763 [inline]
 iomap_get_folio fs/iomap/buffered-io.c:725 [inline]
 __iomap_get_folio fs/iomap/buffered-io.c:896 [inline]
 iomap_write_begin+0x6d9/0x14f0 fs/iomap/buffered-io.c:960
 iomap_write_iter fs/iomap/buffered-io.c:1144 [inline]
 iomap_file_buffered_write+0x47a/0xb30 fs/iomap/buffered-io.c:1225
 xfs_file_buffered_write+0x212/0x8c0 fs/xfs/xfs_file.c:1056
 new_sync_write fs/read_write.c:595 [inline]
 vfs_write+0x61d/0xb90 fs/read_write.c:688
 ksys_pwrite64 fs/read_write.c:795 [inline]
 __do_sys_pwrite64 fs/read_write.c:803 [inline]
 __se_sys_pwrite64 fs/read_write.c:800 [inline]
 __x64_sys_pwrite64+0x199/0x230 fs/read_write.c:800
 do_syscall_x64 arch/x86/entry/syscall_64.c:63 [inline]
 do_syscall_64+0x174/0x580 arch/x86/entry/syscall_64.c:94
 entry_SYSCALL_64_after_hwframe+0x77/0x7f
page last free pid 5710 tgid 5710 stack trace:
 reset_page_owner include/linux/page_owner.h:25 [inline]
 __free_pages_prepare mm/page_alloc.c:1397 [inline]
 free_unref_folios+0xd9f/0x14c0 mm/page_alloc.c:2999
 folios_put_refs+0x9ff/0xb40 mm/swap.c:1008
 free_pages_and_swap_cache+0x2b9/0x490 mm/swap_state.c:401
 __tlb_batch_free_encoded_pages mm/mmu_gather.c:138 [inline]
 tlb_batch_pages_flush mm/mmu_gather.c:151 [inline]
 tlb_flush_mmu_free mm/mmu_gather.c:417 [inline]
 tlb_flush_mmu+0x6d3/0xa30 mm/mmu_gather.c:424
 tlb_finish_mmu+0xf9/0x230 mm/mmu_gather.c:549
 exit_mmap+0x498/0x9e0 mm/mmap.c:1313
 __mmput+0x118/0x430 kernel/fork.c:1178
 exit_mm+0x1f6/0x2d0 kernel/exit.c:582
 do_exit+0x6a2/0x22c0 kernel/exit.c:964
 do_group_exit+0x21b/0x2d0 kernel/exit.c:1119
 get_signal+0x1284/0x1330 kernel/signal.c:3037
 arch_do_signal_or_restart+0xbc/0x840 arch/x86/kernel/signal.c:337
 __exit_to_user_mode_loop kernel/entry/common.c:64 [inline]
 exit_to_user_mode_loop+0xa9/0x680 kernel/entry/common.c:98
 __exit_to_user_mode_prepare include/linux/irq-entry-common.h:207 [inline]
 syscall_exit_to_user_mode_prepare include/linux/irq-entry-common.h:230 [in=
line]
 syscall_exit_to_user_mode include/linux/entry-common.h:318 [inline]
 do_syscall_64+0x353/0x580 arch/x86/entry/syscall_64.c:100
 entry_SYSCALL_64_after_hwframe+0x77/0x7f
Modules linked in:
CPU: 1 UID: 0 PID: 5877 Comm: syz.0.17 Tainted: G    B               syzkal=
ler #0 PREEMPT(full)=20
Tainted: [B]=3DBAD_PAGE
Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS 1.16.2-debian-1.16=
.2-1 04/01/2014
Call Trace:
 <TASK>
 dump_stack_lvl+0xe8/0x150 lib/dump_stack.c:120
 bad_page+0x17f/0x1c0 mm/page_alloc.c:632
 free_page_is_bad mm/page_alloc.c:1076 [inline]
 __free_pages_prepare mm/page_alloc.c:1388 [inline]
 __free_pages_ok+0xb8c/0xbd0 mm/page_alloc.c:1578
 __folio_put+0x4a2/0x580 mm/swap.c:112
 __folio_split+0xffe/0x1570 mm/huge_memory.c:4199
 try_folio_split_to_order include/linux/huge_mm.h:411 [inline]
 try_folio_split_or_unmap+0x5b/0x1e0 mm/truncate.c:189
 truncate_inode_partial_folio+0x4ab/0x8e0 mm/truncate.c:255
 truncate_inode_pages_range+0x5f1/0xe30 mm/truncate.c:416
 iomap_write_failed fs/iomap/buffered-io.c:785 [inline]
 iomap_write_iter fs/iomap/buffered-io.c:1187 [inline]
 iomap_file_buffered_write+0x788/0xb30 fs/iomap/buffered-io.c:1225
 xfs_file_buffered_write+0x212/0x8c0 fs/xfs/xfs_file.c:1056
 new_sync_write fs/read_write.c:595 [inline]
 vfs_write+0x61d/0xb90 fs/read_write.c:688
 ksys_pwrite64 fs/read_write.c:795 [inline]
 __do_sys_pwrite64 fs/read_write.c:803 [inline]
 __se_sys_pwrite64 fs/read_write.c:800 [inline]
 __x64_sys_pwrite64+0x199/0x230 fs/read_write.c:800
 do_syscall_x64 arch/x86/entry/syscall_64.c:63 [inline]
 do_syscall_64+0x174/0x580 arch/x86/entry/syscall_64.c:94
 entry_SYSCALL_64_after_hwframe+0x77/0x7f
RIP: 0033:0x7f3f0719ce59
Code: ff c3 66 2e 0f 1f 84 00 00 00 00 00 0f 1f 44 00 00 48 89 f8 48 89 f7 =
48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 ff f=
f 73 01 c3 48 c7 c1 e8 ff ff ff f7 d8 64 89 01 48
RSP: 002b:00007f3f07ff7028 EFLAGS: 00000246 ORIG_RAX: 0000000000000012
RAX: ffffffffffffffda RBX: 00007f3f07415fa0 RCX: 00007f3f0719ce59
RDX: 00000000ffffffb7 RSI: 0000200000000040 RDI: 0000000000000004
RBP: 00007f3f07232d6f R08: 0000000000000000 R09: 0000000000000000
R10: 0000000008080c61 R11: 0000000000000246 R12: 0000000000000000
R13: 00007f3f07416038 R14: 00007f3f07415fa0 R15: 00007ffe415e9148
 </TASK>
BUG: Bad page state in process syz.0.17  pfn:1a64a0
page: refcount:0 mapcount:0 mapping:0000000000000000 index:0x80a0 pfn:0x1a6=
4a0
head: order:0 mapcount:0 entire_mapcount:1 nr_pages_mapped:0 pincount:0
flags: 0x57ff20000000040(head|node=3D1|zone=3D2|lastcpupid=3D0x7ff)
raw: 057ff20000000040 0000000000000000 dead000000000122 0000000000000000
raw: 00000000000080a0 0000000000000000 00000000ffffffff 0000000000000000
head: 057ff20000000040 0000000000000000 dead000000000122 0000000000000000
head: 00000000000080a0 0000000000000000 00000000ffffffff 0000000000000000
head: 057ff00000000000 0000000000000000 00000000ffffffff 0000000000000000
head: ffffffffffffffff 0000000000000000 00000000ffffffff 0000000000000000
page dumped because: PAGE_FLAGS_CHECK_AT_FREE flag(s) set
page_owner tracks the page as allocated
page last allocated via order 5, migratetype Movable, gfp_mask 0x153c4a(GFP=
_NOFS|__GFP_HIGHMEM|__GFP_MOVABLE|__GFP_WRITE|__GFP_NOWARN|__GFP_NORETRY|__=
GFP_COMP|__GFP_HARDWALL), pid 5877, tgid 5876 (syz.0.17), ts 79178255762, f=
ree_ts 72346647882
 set_page_owner include/linux/page_owner.h:32 [inline]
 post_alloc_hook+0x22d/0x280 mm/page_alloc.c:1853
 prep_new_page mm/page_alloc.c:1861 [inline]
 get_page_from_freelist+0x2593/0x2610 mm/page_alloc.c:3941
 __alloc_frozen_pages_noprof+0x18d/0x380 mm/page_alloc.c:5221
 alloc_pages_mpol+0x235/0x490 mm/mempolicy.c:2490
 alloc_frozen_pages_noprof mm/mempolicy.c:2561 [inline]
 alloc_pages_noprof+0xac/0x2a0 mm/mempolicy.c:2581
 folio_alloc_noprof+0x1e/0x30 mm/mempolicy.c:2591
 filemap_alloc_folio_noprof+0x111/0x470 mm/filemap.c:1014
 __filemap_get_folio_mpol+0x3fc/0xb00 mm/filemap.c:2012
 __filemap_get_folio include/linux/pagemap.h:763 [inline]
 iomap_get_folio fs/iomap/buffered-io.c:725 [inline]
 __iomap_get_folio fs/iomap/buffered-io.c:896 [inline]
 iomap_write_begin+0x6d9/0x14f0 fs/iomap/buffered-io.c:960
 iomap_write_iter fs/iomap/buffered-io.c:1144 [inline]
 iomap_file_buffered_write+0x47a/0xb30 fs/iomap/buffered-io.c:1225
 xfs_file_buffered_write+0x212/0x8c0 fs/xfs/xfs_file.c:1056
 new_sync_write fs/read_write.c:595 [inline]
 vfs_write+0x61d/0xb90 fs/read_write.c:688
 ksys_pwrite64 fs/read_write.c:795 [inline]
 __do_sys_pwrite64 fs/read_write.c:803 [inline]
 __se_sys_pwrite64 fs/read_write.c:800 [inline]
 __x64_sys_pwrite64+0x199/0x230 fs/read_write.c:800
 do_syscall_x64 arch/x86/entry/syscall_64.c:63 [inline]
 do_syscall_64+0x174/0x580 arch/x86/entry/syscall_64.c:94
 entry_SYSCALL_64_after_hwframe+0x77/0x7f
page last free pid 5710 tgid 5710 stack trace:
 reset_page_owner include/linux/page_owner.h:25 [inline]
 __free_pages_prepare mm/page_alloc.c:1397 [inline]
 free_unref_folios+0xd9f/0x14c0 mm/page_alloc.c:2999
 folios_put_refs+0x9ff/0xb40 mm/swap.c:1008
 free_pages_and_swap_cache+0x2b9/0x490 mm/swap_state.c:401
 __tlb_batch_free_encoded_pages mm/mmu_gather.c:138 [inline]
 tlb_batch_pages_flush mm/mmu_gather.c:151 [inline]
 tlb_flush_mmu_free mm/mmu_gather.c:417 [inline]
 tlb_flush_mmu+0x6d3/0xa30 mm/mmu_gather.c:424
 tlb_finish_mmu+0xf9/0x230 mm/mmu_gather.c:549
 exit_mmap+0x498/0x9e0 mm/mmap.c:1313
 __mmput+0x118/0x430 kernel/fork.c:1178
 exit_mm+0x1f6/0x2d0 kernel/exit.c:582
 do_exit+0x6a2/0x22c0 kernel/exit.c:964
 do_group_exit+0x21b/0x2d0 kernel/exit.c:1119
 get_signal+0x1284/0x1330 kernel/signal.c:3037
 arch_do_signal_or_restart+0xbc/0x840 arch/x86/kernel/signal.c:337
 __exit_to_user_mode_loop kernel/entry/common.c:64 [inline]
 exit_to_user_mode_loop+0xa9/0x680 kernel/entry/common.c:98
 __exit_to_user_mode_prepare include/linux/irq-entry-common.h:207 [inline]
 syscall_exit_to_user_mode_prepare include/linux/irq-entry-common.h:230 [in=
line]
 syscall_exit_to_user_mode include/linux/entry-common.h:318 [inline]
 do_syscall_64+0x353/0x580 arch/x86/entry/syscall_64.c:100
 entry_SYSCALL_64_after_hwframe+0x77/0x7f
Modules linked in:
CPU: 0 UID: 0 PID: 5877 Comm: syz.0.17 Tainted: G    B               syzkal=
ler #0 PREEMPT(full)=20
Tainted: [B]=3DBAD_PAGE
Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS 1.16.2-debian-1.16=
.2-1 04/01/2014
Call Trace:
 <TASK>
 dump_stack_lvl+0xe8/0x150 lib/dump_stack.c:120
 bad_page+0x17f/0x1c0 mm/page_alloc.c:632
 free_page_is_bad mm/page_alloc.c:1076 [inline]
 __free_pages_prepare mm/page_alloc.c:1388 [inline]
 __free_pages_ok+0xb8c/0xbd0 mm/page_alloc.c:1578
 __folio_put+0x4a2/0x580 mm/swap.c:112
 __folio_split+0xffe/0x1570 mm/huge_memory.c:4199
 try_folio_split_to_order include/linux/huge_mm.h:411 [inline]
 try_folio_split_or_unmap+0x5b/0x1e0 mm/truncate.c:189
 truncate_inode_partial_folio+0x4ab/0x8e0 mm/truncate.c:255
 truncate_inode_pages_range+0x5f1/0xe30 mm/truncate.c:416
 iomap_write_failed fs/iomap/buffered-io.c:785 [inline]
 iomap_write_iter fs/iomap/buffered-io.c:1187 [inline]
 iomap_file_buffered_write+0x788/0xb30 fs/iomap/buffered-io.c:1225
 xfs_file_buffered_write+0x212/0x8c0 fs/xfs/xfs_file.c:1056
 new_sync_write fs/read_write.c:595 [inline]
 vfs_write+0x61d/0xb90 fs/read_write.c:688
 ksys_pwrite64 fs/read_write.c:795 [inline]
 __do_sys_pwrite64 fs/read_write.c:803 [inline]
 __se_sys_pwrite64 fs/read_write.c:800 [inline]
 __x64_sys_pwrite64+0x199/0x230 fs/read_write.c:800
 do_syscall_x64 arch/x86/entry/syscall_64.c:63 [inline]
 do_syscall_64+0x174/0x580 arch/x86/entry/syscall_64.c:94
 entry_SYSCALL_64_after_hwframe+0x77/0x7f
RIP: 0033:0x7f3f0719ce59
Code: ff c3 66 2e 0f 1f 84 00 00 00 00 00 0f 1f 44 00 00 48 89 f8 48 89 f7 =
48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 ff f=
f 73 01 c3 48 c7 c1 e8 ff ff ff f7 d8 64 89 01 48
RSP: 002b:00007f3f07ff7028 EFLAGS: 00000246 ORIG_RAX: 0000000000000012
RAX: ffffffffffffffda RBX: 00007f3f07415fa0 RCX: 00007f3f0719ce59
RDX: 00000000ffffffb7 RSI: 0000200000000040 RDI: 0000000000000004
RBP: 00007f3f07232d6f R08: 0000000000000000 R09: 0000000000000000
R10: 0000000008080c61 R11: 0000000000000246 R12: 0000000000000000
R13: 00007f3f07416038 R14: 00007f3f07415fa0 R15: 00007ffe415e9148
 </TASK>
BUG: Bad page state in process syz.0.17  pfn:1a64c0
page: refcount:0 mapcount:0 mapping:0000000000000000 index:0x80c0 pfn:0x1a6=
4c0
head: order:0 mapcount:0 entire_mapcount:1 nr_pages_mapped:0 pincount:0
flags: 0x57ff20000000040(head|node=3D1|zone=3D2|lastcpupid=3D0x7ff)
raw: 057ff20000000040 0000000000000000 dead000000000122 0000000000000000
raw: 00000000000080c0 0000000000000000 00000000ffffffff 0000000000000000
head: 057ff20000000040 0000000000000000 dead000000000122 0000000000000000
head: 00000000000080c0 0000000000000000 00000000ffffffff 0000000000000000
head: 057ff00000000000 0000000000000000 00000000ffffffff 0000000000000000
head: ffffffffffffffff 0000000000000000 00000000ffffffff 0000000000000000
page dumped because: PAGE_FLAGS_CHECK_AT_FREE flag(s) set
page_owner tracks the page as allocated
page last allocated via order 6, migratetype Movable, gfp_mask 0x153c4a(GFP=
_NOFS|__GFP_HIGHMEM|__GFP_MOVABLE|__GFP_WRITE|__GFP_NOWARN|__GFP_NORETRY|__=
GFP_COMP|__GFP_HARDWALL), pid 5877, tgid 5876 (syz.0.17), ts 79178255762, f=
ree_ts 72346190117
 set_page_owner include/linux/page_owner.h:32 [inline]
 post_alloc_hook+0x22d/0x280 mm/page_alloc.c:1853
 prep_new_page mm/page_alloc.c:1861 [inline]
 get_page_from_freelist+0x2593/0x2610 mm/page_alloc.c:3941
 __alloc_frozen_pages_noprof+0x18d/0x380 mm/page_alloc.c:5221
 alloc_pages_mpol+0x235/0x490 mm/mempolicy.c:2490
 alloc_frozen_pages_noprof mm/mempolicy.c:2561 [inline]
 alloc_pages_noprof+0xac/0x2a0 mm/mempolicy.c:2581
 folio_alloc_noprof+0x1e/0x30 mm/mempolicy.c:2591
 filemap_alloc_folio_noprof+0x111/0x470 mm/filemap.c:1014
 __filemap_get_folio_mpol+0x3fc/0xb00 mm/filemap.c:2012
 __filemap_get_folio include/linux/pagemap.h:763 [inline]
 iomap_get_folio fs/iomap/buffered-io.c:725 [inline]
 __iomap_get_folio fs/iomap/buffered-io.c:896 [inline]
 iomap_write_begin+0x6d9/0x14f0 fs/iomap/buffered-io.c:960
 iomap_write_iter fs/iomap/buffered-io.c:1144 [inline]
 iomap_file_buffered_write+0x47a/0xb30 fs/iomap/buffered-io.c:1225
 xfs_file_buffered_write+0x212/0x8c0 fs/xfs/xfs_file.c:1056
 new_sync_write fs/read_write.c:595 [inline]
 vfs_write+0x61d/0xb90 fs/read_write.c:688
 ksys_pwrite64 fs/read_write.c:795 [inline]
 __do_sys_pwrite64 fs/read_write.c:803 [inline]
 __se_sys_pwrite64 fs/read_write.c:800 [inline]
 __x64_sys_pwrite64+0x199/0x230 fs/read_write.c:800
 do_syscall_x64 arch/x86/entry/syscall_64.c:63 [inline]
 do_syscall_64+0x174/0x580 arch/x86/entry/syscall_64.c:94
 entry_SYSCALL_64_after_hwframe+0x77/0x7f
page last free pid 5710 tgid 5710 stack trace:
 reset_page_owner include/linux/page_owner.h:25 [inline]
 __free_pages_prepare mm/page_alloc.c:1397 [inline]
 free_unref_folios+0xd9f/0x14c0 mm/page_alloc.c:2999
 folios_put_refs+0x9ff/0xb40 mm/swap.c:1008
 free_pages_and_swap_cache+0x2b9/0x490 mm/swap_state.c:401
 __tlb_batch_free_encoded_pages mm/mmu_gather.c:138 [inline]
 tlb_batch_pages_flush mm/mmu_gather.c:151 [inline]
 tlb_flush_mmu_free mm/mmu_gather.c:417 [inline]
 tlb_flush_mmu+0x6d3/0xa30 mm/mmu_gather.c:424
 tlb_finish_mmu+0xf9/0x230 mm/mmu_gather.c:549
 exit_mmap+0x498/0x9e0 mm/mmap.c:1313
 __mmput+0x118/0x430 kernel/fork.c:1178
 exit_mm+0x1f6/0x2d0 kernel/exit.c:582
 do_exit+0x6a2/0x22c0 kernel/exit.c:964
 do_group_exit+0x21b/0x2d0 kernel/exit.c:1119
 get_signal+0x1284/0x1330 kernel/signal.c:3037
 arch_do_signal_or_restart+0xbc/0x840 arch/x86/kernel/signal.c:337
 __exit_to_user_mode_loop kernel/entry/common.c:64 [inline]
 exit_to_user_mode_loop+0xa9/0x680 kernel/entry/common.c:98
 __exit_to_user_mode_prepare include/linux/irq-entry-common.h:207 [inline]
 syscall_exit_to_user_mode_prepare include/linux/irq-entry-common.h:230 [in=
line]
 syscall_exit_to_user_mode include/linux/entry-common.h:318 [inline]
 do_syscall_64+0x353/0x580 arch/x86/entry/syscall_64.c:100
 entry_SYSCALL_64_after_hwframe+0x77/0x7f
Modules linked in:
CPU: 0 UID: 0 PID: 5877 Comm: syz.0.17 Tainted: G    B               syzkal=
ler #0 PREEMPT(full)=20
Tainted: [B]=3DBAD_PAGE
Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS 1.16.2-debian-1.16=
.2-1 04/01/2014
Call Trace:
 <TASK>
 dump_stack_lvl+0xe8/0x150 lib/dump_stack.c:120
 bad_page+0x17f/0x1c0 mm/page_alloc.c:632
 free_page_is_bad mm/page_alloc.c:1076 [inline]
 __free_pages_prepare mm/page_alloc.c:1388 [inline]
 __free_pages_ok+0xb8c/0xbd0 mm/page_alloc.c:1578
 __folio_put+0x4a2/0x580 mm/swap.c:112
 __folio_split+0xffe/0x1570 mm/huge_memory.c:4199
 try_folio_split_to_order include/linux/huge_mm.h:411 [inline]
 try_folio_split_or_unmap+0x5b/0x1e0 mm/truncate.c:189
 truncate_inode_partial_folio+0x4ab/0x8e0 mm/truncate.c:255
 truncate_inode_pages_range+0x5f1/0xe30 mm/truncate.c:416
 iomap_write_failed fs/iomap/buffered-io.c:785 [inline]
 iomap_write_iter fs/iomap/buffered-io.c:1187 [inline]
 iomap_file_buffered_write+0x788/0xb30 fs/iomap/buffered-io.c:1225
 xfs_file_buffered_write+0x212/0x8c0 fs/xfs/xfs_file.c:1056
 new_sync_write fs/read_write.c:595 [inline]
 vfs_write+0x61d/0xb90 fs/read_write.c:688
 ksys_pwrite64 fs/read_write.c:795 [inline]
 __do_sys_pwrite64 fs/read_write.c:803 [inline]
 __se_sys_pwrite64 fs/read_write.c:800 [inline]
 __x64_sys_pwrite64+0x199/0x230 fs/read_write.c:800
 do_syscall_x64 arch/x86/entry/syscall_64.c:63 [inline]
 do_syscall_64+0x174/0x580 arch/x86/entry/syscall_64.c:94
 entry_SYSCALL_64_after_hwframe+0x77/0x7f
RIP: 0033:0x7f3f0719ce59
Code: ff c3 66 2e 0f 1f 84 00 00 00 00 00 0f 1f 44 00 00 48 89 f8 48 89 f7 =
48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 ff f=
f 73 01 c3 48 c7 c1 e8 ff ff ff f7 d8 64 89 01 48
RSP: 002b:00007f3f07ff7028 EFLAGS: 00000246 ORIG_RAX: 0000000000000012
RAX: ffffffffffffffda RBX: 00007f3f07415fa0 RCX: 00007f3f0719ce59
RDX: 00000000ffffffb7 RSI: 0000200000000040 RDI: 0000000000000004
RBP: 00007f3f07232d6f R08: 0000000000000000 R09: 0000000000000000
R10: 0000000008080c61 R11: 0000000000000246 R12: 0000000000000000
R13: 00007f3f07416038 R14: 00007f3f07415fa0 R15: 00007ffe415e9148
 </TASK>


***

BUG: Bad page state in shmem_get_folio_gfp

tree:      mm-new
URL:       https://kernel.googlesource.com/pub/scm/linux/kernel/git/akpm/mm=
.git
base:      1ec3cca2d8b6b9ff6584ca626d4c8918bbf48d44
arch:      amd64
compiler:  Debian clang version 21.1.8 (++20251221033036+2078da43e25a-1~exp=
1~20251221153213.50), Debian LLD 21.1.8
config:    https://ci.syzbot.org/builds/ffde37a3-aed0-4f49-bba1-ca31cd6a4b0=
4/config
syz repro: https://ci.syzbot.org/findings/f40ca5d2-8fd7-4dbe-a861-a7c4a5f44=
2dd/syz_repro

BUG: Bad page state in process syz.0.53  pfn:11ea80
page: refcount:0 mapcount:0 mapping:0000000000000000 index:0x680 pfn:0x11ea=
80
head: order:0 mapcount:0 entire_mapcount:1 nr_pages_mapped:0 pincount:0
flags: 0x17ff7800002025c(referenced|uptodate|dirty|workingset|head|swapback=
ed|node=3D0|zone=3D2|lastcpupid=3D0x7ff)
raw: 017ff7800002025c 0000000000000000 dead000000000122 0000000000000000
raw: 0000000000000680 0000000000000000 00000000ffffffff 0000000000000000
head: 017ff7800002025c 0000000000000000 dead000000000122 0000000000000000
head: 0000000000000680 0000000000000000 00000000ffffffff 0000000000000000
head: 017ff00000000000 0000000000000000 00000000ffffffff 0000000000000000
head: ffffffffffffffff 0000000000000000 00000000ffffffff 0000000000000000
page dumped because: PAGE_FLAGS_CHECK_AT_FREE flag(s) set
page_owner tracks the page as allocated
page last allocated via order 7, migratetype Movable, gfp_mask 0x3d20ca(GFP=
_TRANSHUGE_LIGHT|__GFP_NORETRY|__GFP_THISNODE), pid 5990, tgid 5988 (syz.0.=
53), ts 80487329937, free_ts 80461370315
 set_page_owner include/linux/page_owner.h:32 [inline]
 post_alloc_hook+0x22d/0x280 mm/page_alloc.c:1853
 prep_new_page mm/page_alloc.c:1861 [inline]
 get_page_from_freelist+0x2593/0x2610 mm/page_alloc.c:3941
 __alloc_frozen_pages_noprof+0x18d/0x380 mm/page_alloc.c:5221
 alloc_pages_mpol+0x1da/0x490 mm/mempolicy.c:2476
 folio_alloc_mpol_noprof+0x39/0x160 mm/mempolicy.c:2509
 shmem_alloc_folio+0xba/0x160 mm/shmem.c:1933
 shmem_alloc_and_add_folio+0x62f/0xf80 mm/shmem.c:1962
 shmem_get_folio_gfp+0x555/0x1670 mm/shmem.c:2552
 shmem_get_folio mm/shmem.c:2670 [inline]
 shmem_write_begin+0x16c/0x330 mm/shmem.c:3303
 generic_perform_write+0x2e2/0x8f0 mm/filemap.c:4325
 shmem_file_write_iter+0xf8/0x120 mm/shmem.c:3478
 new_sync_write fs/read_write.c:595 [inline]
 vfs_write+0x61d/0xb90 fs/read_write.c:688
 ksys_write+0x150/0x270 fs/read_write.c:740
 do_syscall_x64 arch/x86/entry/syscall_64.c:63 [inline]
 do_syscall_64+0x174/0x580 arch/x86/entry/syscall_64.c:94
 entry_SYSCALL_64_after_hwframe+0x77/0x7f
page last free pid 5749 tgid 5749 stack trace:
 reset_page_owner include/linux/page_owner.h:25 [inline]
 __free_pages_prepare mm/page_alloc.c:1397 [inline]
 free_unref_folios+0xd9f/0x14c0 mm/page_alloc.c:2999
 folios_put_refs+0x9ff/0xb40 mm/swap.c:1008
 folio_batch_release include/linux/folio_batch.h:101 [inline]
 shmem_undo_range+0x52c/0x1660 mm/shmem.c:1149
 shmem_truncate_range mm/shmem.c:1277 [inline]
 shmem_evict_inode+0x289/0xae0 mm/shmem.c:1407
 evict+0x61e/0xb10 fs/inode.c:841
 __dentry_kill+0x1a2/0x690 fs/dcache.c:718
 shrink_kill+0xa9/0x2c0 fs/dcache.c:1195
 shrink_dentry_list+0x2e0/0x5e0 fs/dcache.c:1222
 shrink_dcache_tree+0xe9/0x5d0 fs/dcache.c:-1
 do_one_tree fs/dcache.c:1721 [inline]
 shrink_dcache_for_umount+0xa8/0x1f0 fs/dcache.c:1738
 generic_shutdown_super+0x6f/0x2d0 fs/super.c:624
 kill_anon_super+0x3b/0x70 fs/super.c:1292
 deactivate_locked_super+0xbc/0x130 fs/super.c:476
 cleanup_mnt+0x437/0x4d0 fs/namespace.c:1312
 task_work_run+0x1d9/0x270 kernel/task_work.c:233
 resume_user_mode_work include/linux/resume_user_mode.h:50 [inline]
 __exit_to_user_mode_loop kernel/entry/common.c:67 [inline]
 exit_to_user_mode_loop+0x193/0x680 kernel/entry/common.c:98
Modules linked in:
CPU: 0 UID: 0 PID: 5990 Comm: syz.0.53 Not tainted syzkaller #0 PREEMPT(ful=
l)=20
Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS 1.16.2-debian-1.16=
.2-1 04/01/2014
Call Trace:
 <TASK>
 dump_stack_lvl+0xe8/0x150 lib/dump_stack.c:120
 bad_page+0x17f/0x1c0 mm/page_alloc.c:632
 free_page_is_bad mm/page_alloc.c:1076 [inline]
 __free_pages_prepare mm/page_alloc.c:1388 [inline]
 __free_pages_ok+0xb8c/0xbd0 mm/page_alloc.c:1578
 __folio_put+0x4a2/0x580 mm/swap.c:112
 __folio_split+0xffe/0x1570 mm/huge_memory.c:4199
 try_folio_split_to_order include/linux/huge_mm.h:411 [inline]
 try_folio_split_or_unmap+0x5b/0x1e0 mm/truncate.c:189
 truncate_inode_partial_folio+0x4ab/0x8e0 mm/truncate.c:255
 shmem_undo_range+0x9a2/0x1660 mm/shmem.c:1181
 shmem_truncate_range mm/shmem.c:1277 [inline]
 shmem_fallocate+0x51c/0xec0 mm/shmem.c:3703
 vfs_fallocate+0x669/0x7e0 fs/open.c:338
 madvise_remove mm/madvise.c:1039 [inline]
 madvise_vma_behavior+0x2bc8/0x4300 mm/madvise.c:1352
 madvise_walk_vmas+0x573/0xae0 mm/madvise.c:1713
 madvise_do_behavior+0x386/0x540 mm/madvise.c:1929
 do_madvise+0x1fa/0x2e0 mm/madvise.c:2022
 __do_sys_madvise mm/madvise.c:2031 [inline]
 __se_sys_madvise mm/madvise.c:2029 [inline]
 __x64_sys_madvise+0xa6/0xc0 mm/madvise.c:2029
 do_syscall_x64 arch/x86/entry/syscall_64.c:63 [inline]
 do_syscall_64+0x174/0x580 arch/x86/entry/syscall_64.c:94
 entry_SYSCALL_64_after_hwframe+0x77/0x7f
RIP: 0033:0x7fc37db9ce59
Code: ff c3 66 2e 0f 1f 84 00 00 00 00 00 0f 1f 44 00 00 48 89 f8 48 89 f7 =
48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 ff f=
f 73 01 c3 48 c7 c1 e8 ff ff ff f7 d8 64 89 01 48
RSP: 002b:00007fc37ead0028 EFLAGS: 00000246 ORIG_RAX: 000000000000001c
RAX: ffffffffffffffda RBX: 00007fc37de15fa0 RCX: 00007fc37db9ce59
RDX: 0000000000000009 RSI: 0000000000600003 RDI: 0000200000000000
RBP: 00007fc37dc32d6f R08: 0000000000000000 R09: 0000000000000000
R10: 0000000000000000 R11: 0000000000000246 R12: 0000000000000000
R13: 00007fc37de16038 R14: 00007fc37de15fa0 R15: 00007fff07d58848
 </TASK>
BUG: Bad page state in process syz.0.53  pfn:11eb00
page: refcount:0 mapcount:0 mapping:0000000000000000 index:0x700 pfn:0x11eb=
00
head: order:0 mapcount:0 entire_mapcount:1 nr_pages_mapped:0 pincount:0
flags: 0x17ff7800002025c(referenced|uptodate|dirty|workingset|head|swapback=
ed|node=3D0|zone=3D2|lastcpupid=3D0x7ff)
raw: 017ff7800002025c 0000000000000000 dead000000000122 0000000000000000
raw: 0000000000000700 0000000000000000 00000000ffffffff 0000000000000000
head: 017ff7800002025c 0000000000000000 dead000000000122 0000000000000000
head: 0000000000000700 0000000000000000 00000000ffffffff 0000000000000000
head: 017ff00000000000 0000000000000000 00000000ffffffff 0000000000000000
head: ffffffffffffffff 0000000000000000 00000000ffffffff 0000000000000000
page dumped because: PAGE_FLAGS_CHECK_AT_FREE flag(s) set
page_owner tracks the page as allocated
page last allocated via order 8, migratetype Movable, gfp_mask 0x3d20ca(GFP=
_TRANSHUGE_LIGHT|__GFP_NORETRY|__GFP_THISNODE), pid 5990, tgid 5988 (syz.0.=
53), ts 80487329937, free_ts 80461370315
 set_page_owner include/linux/page_owner.h:32 [inline]
 post_alloc_hook+0x22d/0x280 mm/page_alloc.c:1853
 prep_new_page mm/page_alloc.c:1861 [inline]
 get_page_from_freelist+0x2593/0x2610 mm/page_alloc.c:3941
 __alloc_frozen_pages_noprof+0x18d/0x380 mm/page_alloc.c:5221
 alloc_pages_mpol+0x1da/0x490 mm/mempolicy.c:2476
 folio_alloc_mpol_noprof+0x39/0x160 mm/mempolicy.c:2509
 shmem_alloc_folio+0xba/0x160 mm/shmem.c:1933
 shmem_alloc_and_add_folio+0x62f/0xf80 mm/shmem.c:1962
 shmem_get_folio_gfp+0x555/0x1670 mm/shmem.c:2552
 shmem_get_folio mm/shmem.c:2670 [inline]
 shmem_write_begin+0x16c/0x330 mm/shmem.c:3303
 generic_perform_write+0x2e2/0x8f0 mm/filemap.c:4325
 shmem_file_write_iter+0xf8/0x120 mm/shmem.c:3478
 new_sync_write fs/read_write.c:595 [inline]
 vfs_write+0x61d/0xb90 fs/read_write.c:688
 ksys_write+0x150/0x270 fs/read_write.c:740
 do_syscall_x64 arch/x86/entry/syscall_64.c:63 [inline]
 do_syscall_64+0x174/0x580 arch/x86/entry/syscall_64.c:94
 entry_SYSCALL_64_after_hwframe+0x77/0x7f
page last free pid 5749 tgid 5749 stack trace:
 reset_page_owner include/linux/page_owner.h:25 [inline]
 __free_pages_prepare mm/page_alloc.c:1397 [inline]
 free_unref_folios+0xd9f/0x14c0 mm/page_alloc.c:2999
 folios_put_refs+0x9ff/0xb40 mm/swap.c:1008
 folio_batch_release include/linux/folio_batch.h:101 [inline]
 shmem_undo_range+0x52c/0x1660 mm/shmem.c:1149
 shmem_truncate_range mm/shmem.c:1277 [inline]
 shmem_evict_inode+0x289/0xae0 mm/shmem.c:1407
 evict+0x61e/0xb10 fs/inode.c:841
 __dentry_kill+0x1a2/0x690 fs/dcache.c:718
 shrink_kill+0xa9/0x2c0 fs/dcache.c:1195
 shrink_dentry_list+0x2e0/0x5e0 fs/dcache.c:1222
 shrink_dcache_tree+0xe9/0x5d0 fs/dcache.c:-1
 do_one_tree fs/dcache.c:1721 [inline]
 shrink_dcache_for_umount+0xa8/0x1f0 fs/dcache.c:1738
 generic_shutdown_super+0x6f/0x2d0 fs/super.c:624
 kill_anon_super+0x3b/0x70 fs/super.c:1292
 deactivate_locked_super+0xbc/0x130 fs/super.c:476
 cleanup_mnt+0x437/0x4d0 fs/namespace.c:1312
 task_work_run+0x1d9/0x270 kernel/task_work.c:233
 resume_user_mode_work include/linux/resume_user_mode.h:50 [inline]
 __exit_to_user_mode_loop kernel/entry/common.c:67 [inline]
 exit_to_user_mode_loop+0x193/0x680 kernel/entry/common.c:98
Modules linked in:
CPU: 0 UID: 0 PID: 5990 Comm: syz.0.53 Tainted: G    B               syzkal=
ler #0 PREEMPT(full)=20
Tainted: [B]=3DBAD_PAGE
Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS 1.16.2-debian-1.16=
.2-1 04/01/2014
Call Trace:
 <TASK>
 dump_stack_lvl+0xe8/0x150 lib/dump_stack.c:120
 bad_page+0x17f/0x1c0 mm/page_alloc.c:632
 free_page_is_bad mm/page_alloc.c:1076 [inline]
 __free_pages_prepare mm/page_alloc.c:1388 [inline]
 __free_pages_ok+0xb8c/0xbd0 mm/page_alloc.c:1578
 __folio_put+0x4a2/0x580 mm/swap.c:112
 __folio_split+0xffe/0x1570 mm/huge_memory.c:4199
 try_folio_split_to_order include/linux/huge_mm.h:411 [inline]
 try_folio_split_or_unmap+0x5b/0x1e0 mm/truncate.c:189
 truncate_inode_partial_folio+0x4ab/0x8e0 mm/truncate.c:255
 shmem_undo_range+0x9a2/0x1660 mm/shmem.c:1181
 shmem_truncate_range mm/shmem.c:1277 [inline]
 shmem_fallocate+0x51c/0xec0 mm/shmem.c:3703
 vfs_fallocate+0x669/0x7e0 fs/open.c:338
 madvise_remove mm/madvise.c:1039 [inline]
 madvise_vma_behavior+0x2bc8/0x4300 mm/madvise.c:1352
 madvise_walk_vmas+0x573/0xae0 mm/madvise.c:1713
 madvise_do_behavior+0x386/0x540 mm/madvise.c:1929
 do_madvise+0x1fa/0x2e0 mm/madvise.c:2022
 __do_sys_madvise mm/madvise.c:2031 [inline]
 __se_sys_madvise mm/madvise.c:2029 [inline]
 __x64_sys_madvise+0xa6/0xc0 mm/madvise.c:2029
 do_syscall_x64 arch/x86/entry/syscall_64.c:63 [inline]
 do_syscall_64+0x174/0x580 arch/x86/entry/syscall_64.c:94
 entry_SYSCALL_64_after_hwframe+0x77/0x7f
RIP: 0033:0x7fc37db9ce59
Code: ff c3 66 2e 0f 1f 84 00 00 00 00 00 0f 1f 44 00 00 48 89 f8 48 89 f7 =
48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 ff f=
f 73 01 c3 48 c7 c1 e8 ff ff ff f7 d8 64 89 01 48
RSP: 002b:00007fc37ead0028 EFLAGS: 00000246 ORIG_RAX: 000000000000001c
RAX: ffffffffffffffda RBX: 00007fc37de15fa0 RCX: 00007fc37db9ce59
RDX: 0000000000000009 RSI: 0000000000600003 RDI: 0000200000000000
RBP: 00007fc37dc32d6f R08: 0000000000000000 R09: 0000000000000000
R10: 0000000000000000 R11: 0000000000000246 R12: 0000000000000000
R13: 00007fc37de16038 R14: 00007fc37de15fa0 R15: 00007fff07d58848
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

The email will later be sent to:
[akpm@linux-foundation.org baohua@kernel.org baolin.wang@linux.alibaba.com =
david@kernel.org dev.jain@arm.com huangzhaoyang@gmail.com lance.yang@linux.=
dev liam.howlett@oracle.com linux-kernel@vger.kernel.org linux-mm@kvack.org=
 lorenzo.stoakes@oracle.com npache@redhat.com ryan.roberts@arm.com steve.ka=
ng@unisoc.com zhaoyang.huang@unisoc.com ziy@nvidia.com]

If the report looks fine to you, reply with:
#syz upstream

If the report is a false positive, reply with
#syz invalid

