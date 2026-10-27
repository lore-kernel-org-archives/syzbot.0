Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.210.69
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793139439;
	b=BVUPjicSh/BcPK+sWIO8cQpx/oB8bciDqfBWpVQJbDmndAqdIbcKYs3O2OuurmpTKkUV
	 zq2G17qq0rJwCBJemQ1ISk7U0kK+iysDYRQr3jcihIL2srq9LPZECRMF7EKdPOcfCCqYT
	 WfPYzBpdzWfVkTaRKfDbmfpCdYMTqy3p1IXN0DzrUMDEzH1eIP99lOGD3UIJv32yN2TvF
	 J0qG4OQf/o9RMMhyqh9ZTW70FLYMMCzVRhbgcLbXu5HuPftBsKe/rdRPQ3vgY3yG8tYv9
	 b5DxgCVBZUJCpr+Ij4r3r+ku/35I7Tu1XJYGQT47OvSfDpXcBR1YbHxNkgoTXUTnsPw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793139439;
	h=DMARC-Filter:Received:X-Google-DKIM-Signature:X-Gm-Message-State:
	 MIME-Version:X-Received:Date:X-Google-Appengine-App-Id:
	 X-Google-Appengine-App-Id-Alias:Message-ID:Subject:From:To:Cc:
	 Content-Type:Content-Transfer-Encoding;
	bh=Rep3vDtu7BPj6j/+CUsR5SlvNq0mY6fZ2j+T0N+Y7XY=;
	b=U4/5p7b3nNalVuIuWKeuclw5nsmNP2mu81qjeNMzrYJrAIHGT11+XSAjrIPrc9M0htge
	 NYCeP13R+UPPSnphXQmE1aZ68strrtiVtUi+E9B5Rn6JdUTVkZzEvoTxq+1s/TfBPXY2x
	 2QQU07h3ByozLDY8A6PtTh0ksoPsbcrGDZ3iC26URVKSgettpWihcc1B2dWR/hzEf8Ass
	 kQGqq1BIuYBZ1St0DHvLLeUgHpQsktQkkVEzfDncRDtUzeCHhrBKV5oSVfbSrsW6upW/+
	 okVOxnJxCCTnBf15ofBAskrPB5s8FXmGXwLLHn7dyhE7OHqWO66M7qWJfcRjgkpeTAg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=fail header.from=syzkaller.appspotmail.com;
	spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com;
	arc=none smtp.remote-ip=209.85.210.69
Received: from mail-ot1-f69.google.com (mail-ot1-f69.google.com [209.85.210.69])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 28F66606A31D
	for <syzbot@lists.linux.dev>; Tue, 27 Oct 2026 22:17:18 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 28F66606A31D
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com
Received: by mail-ot1-f69.google.com with SMTP id 46e09a7af769-81b50ab16edso515776a34.3
        for <syzbot@lists.linux.dev>; Tue, 27 Oct 2026 15:17:18 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793139438; x=1793744238;
        h=content-transfer-encoding:content-type:cc:to:from:subject
         :message-id:date:mime-version:x-gm-message-state:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=Rep3vDtu7BPj6j/+CUsR5SlvNq0mY6fZ2j+T0N+Y7XY=;
        b=YtN8zoHuIdr+cg7/IJW0Oh4FGxBJswtDrhAFuvSSxiBy8cKEAEL8k3ok8dRT9De49y
         rHFKzEWOSBAQFkjRCZKnMki/Uv/veGpr9xFSAQLalp18zABOoMy+KJgyNORFZO/D/VEO
         lC0LhudXqrndmgPqFBzVjXWscfrBsc8pNRaWCLhjbtbQJ2GyutzbMKTfR7gN1zKEqLS+
         EDMLCNUpuOfjWQEowTt1xhBOYcml+yA6ml/nixbfKGxR1Qwh81RZVR/8Spwt6xrsXTCo
         IV904FBjmpgNP1tv0VMUdvExVtGQWrmSFRY7m4yM7qAYXVZt5oc6mxcDYvIRCIzxRp/K
         EQ1g==
X-Gm-Message-State: AFq9FYLEPPrDqx10kCc7jHAa4e505huaDKQsM9v5tHpR6tB8lW8+hyA2
	jC4GhkQjz5XVdgCP0r2oehTUUozo81J2PiuIMmh7PkEyawzSAnQGH+PN6Uc2TX7YKn3bmGhPAfl
	uEa4osvpomm0h+sLioHKwaIoo97+nI99rdWriNsQ1uRFx/viH/oYsccn5NvQ=
X-Mailing-List: syzbot@lists.linux.dev
List-Id: <syzbot.lists.linux.dev>
List-Post: <mailto:syzbot@lists.linux.dev>
List-Help: <mailto:syzbot+help@lists.linux.dev>
List-Subscribe: <mailto:syzbot+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:syzbot+unsubscribe@lists.linux.dev>
List-Owner: <mailto:syzbot+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
X-Received: by 2002:a05:6808:181d:b0:4e5:2f2e:45b4 with SMTP id
 5614622812f47-56381c87f70mr345783b6e.21.1793139437950; Tue, 27 Oct 2026
 15:17:17 -0700 (PDT)
Date: Tue, 27 Oct 2026 15:17:17 -0700
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <6ae122ed.6200f071.51519.0f5d.GAE@google.com>
Subject: [moderation/CI] Re: mm, iomap: account dirty at page granularity for
 per-block dirty folios
From: syzbot ci <syzbot+ci873f68dff6fb0fa5@syzkaller.appspotmail.com>
To: syzkaller-upstream-moderation@googlegroups.com
Cc: syzbot@lists.linux.dev
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

syzbot ci has tested the following series

[v1] mm, iomap: account dirty at page granularity for per-block dirty folio=
s
https://lore.kernel.org/all/20261027112702.3747009-1-dipiets@amazon.it
* [PATCH 1/2] mm: add infrastructure for per-dirty-page accounting
* [PATCH 2/2] mm, iomap: account dirty at page granularity for per-block di=
rty folios

and found the following issues:
* KASAN: slab-out-of-bounds Read in folio_accounted_dirty_pages
* KASAN: slab-use-after-free Read in folio_accounted_dirty_pages

Full report is available here:
https://ci.syzbot.org/series/05041e6c-d357-4fc5-9bbe-6aae1760d639

***

KASAN: slab-out-of-bounds Read in folio_accounted_dirty_pages

tree:      axboe
URL:       https://kernel.googlesource.com/pub/scm/linux/kernel/git/axboe/l=
inux.git
base:      24a19b953e2a3d0ea5a8c4951a0ab8f32720c907
arch:      amd64
compiler:  Debian clang version 22.1.8 (1~deb13u4), Debian LLD 22.1.8
config:    https://ci.syzbot.org/builds/9865cf75-69fb-4fbd-b5fe-d0be9cd0380=
2/config
syz repro: https://ci.syzbot.org/findings/98cdf846-0b4c-4f94-8430-3b7db9efe=
057/syz_repro

=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
BUG: KASAN: slab-out-of-bounds in instrument_atomic_read include/linux/inst=
rumented.h:82 [inline]
BUG: KASAN: slab-out-of-bounds in _test_bit include/asm-generic/bitops/inst=
rumented-non-atomic.h:141 [inline]
BUG: KASAN: slab-out-of-bounds in mapping_dirty_per_block include/linux/pag=
emap.h:319 [inline]
BUG: KASAN: slab-out-of-bounds in folio_accounted_dirty_pages+0x53/0x1f0 mm=
/page-writeback.c:2654
Read of size 8 at addr ffff888168669f89 by task syz.1.47/5860

CPU: 0 UID: 0 PID: 5860 Comm: syz.1.47 Not tainted syzkaller #0 PREEMPT(ful=
l)=20
Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS 1.16.2-debian-1.16=
.2-1 04/01/2014
Call Trace:
 <TASK>
 dump_stack_lvl+0xe8/0x150 lib/dump_stack.c:120
 print_address_description+0x55/0x1e0 mm/kasan/report.c:378
 print_report+0x58/0x70 mm/kasan/report.c:482
 kasan_report+0x117/0x150 mm/kasan/report.c:595
 check_region_inline mm/kasan/generic.c:-1 [inline]
 kasan_check_range+0x264/0x2c0 mm/kasan/generic.c:200
 instrument_atomic_read include/linux/instrumented.h:82 [inline]
 _test_bit include/asm-generic/bitops/instrumented-non-atomic.h:141 [inline=
]
 mapping_dirty_per_block include/linux/pagemap.h:319 [inline]
 folio_accounted_dirty_pages+0x53/0x1f0 mm/page-writeback.c:2654
 __folio_migrate_mapping+0x3d0/0x2830 mm/migrate.c:624
 __migrate_folio mm/migrate.c:893 [inline]
 migrate_folio+0x10a/0x1a0 mm/migrate.c:920
 move_to_new_folio+0x1ed/0x460 mm/migrate.c:1135
 migrate_folio_move mm/migrate.c:1401 [inline]
 migrate_folios_move mm/migrate.c:1758 [inline]
 migrate_pages_batch+0x30b3/0x4f50 mm/migrate.c:2014
 migrate_pages_sync mm/migrate.c:2044 [inline]
 migrate_pages+0x1b9f/0x2920 mm/migrate.c:2153
 migrate_to_node mm/mempolicy.c:1322 [inline]
 do_migrate_pages+0x656/0x8b0 mm/mempolicy.c:1421
 kernel_migrate_pages mm/mempolicy.c:1935 [inline]
 __do_sys_migrate_pages mm/mempolicy.c:1953 [inline]
 __se_sys_migrate_pages+0xaa2/0xc90 mm/mempolicy.c:1949
 do_syscall_x64 arch/x86/entry/syscall_64.c:61 [inline]
 do_syscall_64+0x166/0x520 arch/x86/entry/syscall_64.c:84
 entry_SYSCALL_64_after_hwframe+0x77/0x7f
RIP: 0033:0x7f04fcf9f559
Code: ff c3 66 2e 0f 1f 84 00 00 00 00 00 0f 1f 44 00 00 48 89 f8 48 89 f7 =
48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 ff f=
f 73 01 c3 48 c7 c1 e8 ff ff ff f7 d8 64 89 01 48
RSP: 002b:00007f04fc5fe028 EFLAGS: 00000246 ORIG_RAX: 0000000000000100
RAX: ffffffffffffffda RBX: 00007f04fd225fa0 RCX: 00007f04fcf9f559
RDX: 0000200000000040 RSI: 0000000000000009 RDI: 0000000000000000
RBP: 00007f04fd036b20 R08: 0000000000000000 R09: 0000000000000000
R10: 0000200000000380 R11: 0000000000000246 R12: 0000000000000000
R13: 00007f04fd226038 R14: 00007f04fd225fa0 R15: 00007ffc667db8b8
 </TASK>

Allocated by task 5729:
 kasan_save_stack mm/kasan/common.c:57 [inline]
 kasan_save_track+0x3e/0x80 mm/kasan/common.c:78
 unpoison_slab_object mm/kasan/common.c:351 [inline]
 __kasan_slab_alloc+0x6c/0x80 mm/kasan/common.c:377
 kasan_slab_alloc include/linux/kasan.h:253 [inline]
 slab_post_alloc_hook mm/slub.c:4683 [inline]
 slab_alloc_node mm/slub.c:4996 [inline]
 kmem_cache_alloc_noprof+0x2b9/0x600 mm/slub.c:5010
 anon_vma_alloc mm/rmap.c:94 [inline]
 anon_vma_fork+0x88/0x540 mm/rmap.c:395
 dup_mmap+0x954/0x1dc0 mm/mmap.c:1781
 dup_mm kernel/fork.c:1543 [inline]
 copy_mm+0x115/0x480 kernel/fork.c:1595
 copy_process+0x1e79/0x4400 kernel/fork.c:2311
 kernel_clone+0x2d7/0x940 kernel/fork.c:2771
 __do_sys_clone kernel/fork.c:2913 [inline]
 __se_sys_clone kernel/fork.c:2897 [inline]
 __x64_sys_clone+0x1b6/0x230 kernel/fork.c:2897
 do_syscall_x64 arch/x86/entry/syscall_64.c:61 [inline]
 do_syscall_64+0x166/0x520 arch/x86/entry/syscall_64.c:84
 entry_SYSCALL_64_after_hwframe+0x77/0x7f

The buggy address belongs to the object at ffff888168669e70
 which belongs to the cache anon_vma of size 200
The buggy address is located 81 bytes to the right of
 allocated 200-byte region [ffff888168669e70, ffff888168669f38)

The buggy address belongs to the physical page:
page: refcount:0 mapcount:0 mapping:0000000000000000 index:0xffff8881686691=
08 pfn:0x168669
memcg:ffff88816db0e201
flags: 0x57ff00000000200(workingset|node=3D1|zone=3D2|lastcpupid=3D0x7ff)
page_type: f5(slab)
raw: 057ff00000000200 ffff888101687140 ffff88816040c7c8 ffffea0005b62950
raw: ffff888168669108 00000002000f000b 00000000f5000000 ffff88816db0e201
page dumped because: kasan: bad access detected
page_owner tracks the page as allocated
page last allocated via order 0, migratetype Unmovable, gfp_mask 0xd2cc0(GF=
P_KERNEL|__GFP_NOWARN|__GFP_NORETRY|__GFP_COMP|__GFP_NOMEMALLOC), pid 5535,=
 tgid 5535 (rm), ts 43255388535
 set_page_owner include/linux/page_owner.h:33 [inline]
 post_alloc_hook+0x1f9/0x250 mm/page_alloc.c:1871
 prep_new_page mm/page_alloc.c:1879 [inline]
 get_page_from_freelist+0x2209/0x2280 mm/page_alloc.c:3943
 __alloc_frozen_pages_noprof+0x217/0x5a0 mm/page_alloc.c:5436
 alloc_slab_page mm/slub.c:3347 [inline]
 allocate_slab+0x7d/0x620 mm/slub.c:3462
 new_slab mm/slub.c:3513 [inline]
 refill_objects+0x2d5/0x350 mm/slub.c:7418
 refill_sheaf mm/slub.c:2885 [inline]
 __pcs_replace_empty_main+0x2c8/0x6c0 mm/slub.c:4774
 alloc_from_pcs mm/slub.c:4850 [inline]
 slab_alloc_node mm/slub.c:4984 [inline]
 kmem_cache_alloc_noprof+0x399/0x600 mm/slub.c:5010
 anon_vma_alloc mm/rmap.c:94 [inline]
 __anon_vma_prepare+0x10e/0x4d0 mm/rmap.c:201
 __vmf_anon_prepare mm/memory.c:3961 [inline]
 vmf_anon_prepare mm/internal.h:572 [inline]
 do_anonymous_page mm/memory.c:5478 [inline]
 do_pte_missing+0x2f18/0x34b0 mm/memory.c:4698
 handle_pte_fault mm/memory.c:6558 [inline]
 __handle_mm_fault mm/memory.c:6707 [inline]
 handle_mm_fault+0x1a53/0x3750 mm/memory.c:6876
 do_user_addr_fault+0xa4f/0x1340 arch/x86/mm/fault.c:1343
 handle_page_fault arch/x86/mm/fault.c:1483 [inline]
 exc_page_fault+0x6a/0xc0 arch/x86/mm/fault.c:1536
 asm_exc_page_fault+0x26/0x30 arch/x86/include/asm/idtentry.h:595
page last free pid 5049 tgid 5049 ts 18476194117 stack trace:
 reset_page_owner include/linux/page_owner.h:26 [inline]
 __free_pages_prepare mm/page_alloc.c:1418 [inline]
 __free_frozen_pages+0xc93/0xd90 mm/page_alloc.c:2962
 __slab_free+0x274/0x2c0 mm/slub.c:5823
 qlink_free mm/kasan/quarantine.c:163 [inline]
 qlist_free_all+0x99/0x100 mm/kasan/quarantine.c:179
 kasan_quarantine_reduce+0x148/0x160 mm/kasan/quarantine.c:286
 __kasan_slab_alloc+0x22/0x80 mm/kasan/common.c:361
 kasan_slab_alloc include/linux/kasan.h:253 [inline]
 slab_post_alloc_hook mm/slub.c:4683 [inline]
 slab_alloc_node mm/slub.c:4996 [inline]
 kmem_cache_alloc_node_noprof+0x354/0x610 mm/slub.c:5068
 __alloc_skb+0x1db/0x7a0 net/core/skbuff.c:704
 alloc_skb include/linux/skbuff.h:1384 [inline]
 alloc_skb_with_frags+0xc6/0x760 net/core/skbuff.c:6803
 sock_alloc_send_pskb+0x878/0x990 net/core/sock.c:3022
 unix_dgram_sendmsg+0x4da/0x17b0 net/unix/af_unix.c:2144
 sock_sendmsg_nosec+0x13a/0x180 net/socket.c:800
 __sock_sendmsg net/socket.c:815 [inline]
 sock_write_iter+0x2de/0x3e0 net/socket.c:1266
 new_sync_write fs/read_write.c:595 [inline]
 vfs_write+0x612/0xba0 fs/read_write.c:687
 ksys_write+0x150/0x270 fs/read_write.c:739
 do_syscall_x64 arch/x86/entry/syscall_64.c:61 [inline]
 do_syscall_64+0x166/0x520 arch/x86/entry/syscall_64.c:84
 entry_SYSCALL_64_after_hwframe+0x77/0x7f

Memory state around the buggy address:
 ffff888168669e80: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
 ffff888168669f00: 00 00 00 00 00 00 00 fc fc fc fc fc fc fc fc fc
>ffff888168669f80: fc fc fc fc fc fc fc fc fc fc fc fc fc fc fc fc
                      ^
 ffff88816866a000: fa fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb
 ffff88816866a080: fb fb fb fb fb fb fb fb fb fb fb fb fb fb fc fc
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D


***

KASAN: slab-use-after-free Read in folio_accounted_dirty_pages

tree:      axboe
URL:       https://kernel.googlesource.com/pub/scm/linux/kernel/git/axboe/l=
inux.git
base:      24a19b953e2a3d0ea5a8c4951a0ab8f32720c907
arch:      amd64
compiler:  Debian clang version 22.1.8 (1~deb13u4), Debian LLD 22.1.8
config:    https://ci.syzbot.org/builds/9865cf75-69fb-4fbd-b5fe-d0be9cd0380=
2/config
syz repro: https://ci.syzbot.org/findings/f9e47a91-9c37-465b-b43c-7404e404c=
bfd/syz_repro

=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
BUG: KASAN: slab-use-after-free in instrument_atomic_read include/linux/ins=
trumented.h:82 [inline]
BUG: KASAN: slab-use-after-free in _test_bit include/asm-generic/bitops/ins=
trumented-non-atomic.h:141 [inline]
BUG: KASAN: slab-use-after-free in mapping_dirty_per_block include/linux/pa=
gemap.h:319 [inline]
BUG: KASAN: slab-use-after-free in folio_accounted_dirty_pages+0x53/0x1f0 m=
m/page-writeback.c:2654
Read of size 8 at addr ffff888111a3d539 by task syz.0.17/5870

CPU: 0 UID: 0 PID: 5870 Comm: syz.0.17 Not tainted syzkaller #0 PREEMPT(ful=
l)=20
Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS 1.16.2-debian-1.16=
.2-1 04/01/2014
Call Trace:
 <TAS
 <TASK>
 dump_stack_lvl+0xe8/0x150 lib/dump_stack.c:120
 print_address_description+0x55/0x1e0 mm/kasan/report.c:378
 print_report+0x58/0x70 mm/kasan/report.c:482
 kasan_report+0x117/0x150 mm/kasan/report.c:595
 check_region_inline mm/kasan/generic.c:-1 [inline]
 kasan_check_range+0x264/0x2c0 mm/kasan/generic.c:200
 instrument_atomic_read include/linux/instrumented.h:82 [inline]
 _test_bit include/asm-generic/bitops/instrumented-non-atomic.h:141 [inline=
]
 mapping_dirty_per_block include/linux/pagemap.h:319 [inline]
 folio_accounted_dirty_pages+0x53/0x1f0 mm/page-writeback.c:2654
 __folio_migrate_mapping+0x3d0/0x2830 mm/migrate.c:624
 __migrate_folio mm/migrate.c:893 [inline]
 migrate_folio+0x10a/0x1a0 mm/migrate.c:920
 move_to_new_folio+0x1ed/0x460 mm/migrate.c:1135
 migrate_folio_move mm/migrate.c:1401 [inline]
 migrate_folios_move mm/migrate.c:1758 [inline]
 migrate_pages_batch+0x30b3/0x4f50 mm/migrate.c:2014
 migrate_pages_sync mm/migrate.c:2044 [inline]
 migrate_pages+0x1b9f/0x2920 mm/migrate.c:2153
 migrate_to_node mm/mempolicy.c:1322 [inline]
 do_migrate_pages+0x656/0x8b0 mm/mempolicy.c:1421
 kernel_migrate_pages mm/mempolicy.c:1935 [inline]
 __do_sys_migrate_pages mm/mempolicy.c:1953 [inline]
 __se_sys_migrate_pages+0xaa2/0xc90 mm/mempolicy.c:1949
 do_syscall_x64 arch/x86/entry/syscall_64.c:61 [inline]
 do_syscall_64+0x166/0x520 arch/x86/entry/syscall_64.c:84
 entry_SYSCALL_64_after_hwframe+0x77/0x7f
RIP: 0033:0x7f600f39f559
Code: ff c3 66 2e 0f 1f 84 00 00 00 00 00 0f 1f 44 00 00 48 89 f8 48 89 f7 =
48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 ff f=
f 73 01 c3 48 c7 c1 e8 ff ff ff f7 d8 64 89 01 48
RSP: 002b:00007f6010302028 EFLAGS: 00000246 ORIG_RAX: 0000000000000100
RAX: ffffffffffffffda RBX: 00007f600f625fa0 RCX: 00007f600f39f559
RDX: 0000200000000040 RSI: 0000000000000009 RDI: 0000000000000000
RBP: 00007f600f436b20 R08: 0000000000000000 R09: 0000000000000000
R10: 0000200000000380 R11: 0000000000000246 R12: 0000000000000000
R13: 00007f600f626038 R14: 00007f600f625fa0 R15: 00007ffcbfa14028
 </TASK>

Allocated by task 5645:
 kasan_save_stack mm/kasan/common.c:57 [inline]
 kasan_save_track+0x3e/0x80 mm/kasan/common.c:78
 unpoison_slab_object mm/kasan/common.c:351 [inline]
 __kasan_slab_alloc+0x6c/0x80 mm/kasan/common.c:377
 kasan_slab_alloc include/linux/kasan.h:253 [inline]
 slab_post_alloc_hook mm/slub.c:4683 [inline]
 slab_alloc_node mm/slub.c:4996 [inline]
 kmem_cache_alloc_noprof+0x2b9/0x600 mm/slub.c:5010
 anon_vma_alloc mm/rmap.c:94 [inline]
 __anon_vma_prepare+0x10e/0x4d0 mm/rmap.c:201
 __vmf_anon_prepare mm/memory.c:3961 [inline]
 vmf_anon_prepare mm/internal.h:572 [inline]
 do_anonymous_page mm/memory.c:5478 [inline]
 do_pte_missing+0x2f18/0x34b0 mm/memory.c:4698
 handle_pte_fault mm/memory.c:6558 [inline]
 __handle_mm_fault mm/memory.c:6707 [inline]
 handle_mm_fault+0x1a53/0x3750 mm/memory.c:6876
 do_user_addr_fault+0xa4f/0x1340 arch/x86/mm/fault.c:1343
 handle_page_fault arch/x86/mm/fault.c:1483 [inline]
 exc_page_fault+0x6a/0xc0 arch/x86/mm/fault.c:1536
 asm_exc_page_fault+0x26/0x30 arch/x86/include/asm/idtentry.h:595

Freed by task 5646:
 kasan_save_stack mm/kasan/common.c:57 [inline]
 kasan_save_track+0x3e/0x80 mm/kasan/common.c:78
 kasan_save_free_info+0x40/0x50 mm/kasan/generic.c:584
 poison_slab_object mm/kasan/common.c:264 [inline]
 __kasan_slab_free+0x5c/0x80 mm/kasan/common.c:296
 kasan_slab_free include/linux/kasan.h:235 [inline]
 slab_free_hook mm/slub.c:2748 [inline]
 slab_free_after_rcu_debug+0x12a/0x220 mm/slub.c:6571
 rcu_do_batch kernel/rcu/tree.c:2650 [inline]
 rcu_core+0x926/0x1260 kernel/rcu/tree.c:2919
 handle_softirqs+0x226/0x860 kernel/softirq.c:645
 __do_softirq kernel/softirq.c:679 [inline]
 invoke_softirq kernel/softirq.c:519 [inline]
 __irq_exit_rcu+0xcb/0x220 kernel/softirq.c:758
 irq_exit_rcu+0x9/0x30 kernel/softirq.c:775
 instr_sysvec_apic_timer_interrupt arch/x86/kernel/apic/apic.c:1062 [inline=
]
 sysvec_apic_timer_interrupt+0xa6/0xc0 arch/x86/kernel/apic/apic.c:1062
 asm_sysvec_apic_timer_interrupt+0x1a/0x20 arch/x86/include/asm/idtentry.h:=
674

Last potentially related work creation:
 kasan_save_stack+0x3e/0x60 mm/kasan/common.c:57
 kasan_record_aux_stack+0xbd/0xd0 mm/kasan/generic.c:556
 slab_free_hook mm/slub.c:2709 [inline]
 slab_free mm/slub.c:6509 [inline]
 kmem_cache_free+0x45e/0x650 mm/slub.c:6636
 anon_vma_free mm/rmap.c:137 [inline]
 __put_anon_vma+0x12b/0x2d0 mm/rmap.c:2974
 put_anon_vma mm/internal.h:293 [inline]
 unlink_anon_vmas+0x544/0x720 mm/rmap.c:540
 free_pgtables+0x663/0xb70 mm/memory.c:401
 unmap_region+0x29d/0x330 mm/vma.c:534
 vms_clear_ptes mm/vma.c:1383 [inline]
 vms_complete_munmap_vmas+0x427/0xbe0 mm/vma.c:1425
 do_vmi_align_munmap+0x3b7/0x4b0 mm/vma.c:1684
 do_vmi_munmap+0x252/0x2d0 mm/vma.c:1732
 __vm_munmap+0x241/0x3e0 mm/vma.c:3415
 __do_sys_munmap mm/mmap.c:1094 [inline]
 __se_sys_munmap mm/mmap.c:1091 [inline]
 __x64_sys_munmap+0x60/0x70 mm/mmap.c:1091
 do_syscall_x64 arch/x86/entry/syscall_64.c:61 [inline]
 do_syscall_64+0x166/0x520 arch/x86/entry/syscall_64.c:84
 entry_SYSCALL_64_after_hwframe+0x77/0x7f

The buggy address belongs to the object at ffff888111a3d528
 which belongs to the cache anon_vma of size 200
The buggy address is located 17 bytes inside of
 freed 200-byte region [ffff888111a3d528, ffff888111a3d5f0)

The buggy address belongs to the physical page:
page: refcount:0 mapcount:0 mapping:0000000000000000 index:0xffff888111a3d5=
28 pfn:0x111a3d
memcg:ffff888111a3df79
flags: 0x17ff00000000200(workingset|node=3D0|zone=3D2|lastcpupid=3D0x7ff)
page_type: f5(slab)
raw: 017ff00000000200 ffff888101688140 ffff8881006957c8 ffffea00047d6bd0
raw: ffff888111a3d528 00000002000f0009 00000000f5000000 ffff888111a3df79
page dumped because: kasan: bad access detected
page_owner tracks the page as allocated
page last allocated via order 0, migratetype Unmovable, gfp_mask 0xd2cc0(GF=
P_KERNEL|__GFP_NOWARN|__GFP_NORETRY|__GFP_COMP|__GFP_NOMEMALLOC), pid 5634,=
 tgid 5634 (syz-executor), ts 59634551582
 set_page_owner include/linux/page_owner.h:33 [inline]
 post_alloc_hook+0x1f9/0x250 mm/page_alloc.c:1871
 prep_new_page mm/page_alloc.c:1879 [inline]
 get_page_from_freelist+0x2209/0x2280 mm/page_alloc.c:3943
 __alloc_frozen_pages_noprof+0x217/0x5a0 mm/page_alloc.c:5436
 alloc_slab_page mm/slub.c:3347 [inline]
 allocate_slab+0x7d/0x620 mm/slub.c:3462
 new_slab mm/slub.c:3513 [inline]
 refill_objects+0x2d5/0x350 mm/slub.c:7418
 refill_sheaf mm/slub.c:2885 [inline]
 __pcs_replace_empty_main+0x2c8/0x6c0 mm/slub.c:4774
 alloc_from_pcs mm/slub.c:4850 [inline]
 slab_alloc_node mm/slub.c:4984 [inline]
 kmem_cache_alloc_noprof+0x399/0x600 mm/slub.c:5010
 anon_vma_alloc mm/rmap.c:94 [inline]
 anon_vma_fork+0x88/0x540 mm/rmap.c:395
 dup_mmap+0x954/0x1dc0 mm/mmap.c:1781
 dup_mm kernel/fork.c:1543 [inline]
 copy_mm+0x115/0x480 kernel/fork.c:1595
 copy_process+0x1e79/0x4400 kernel/fork.c:2311
 kernel_clone+0x2d7/0x940 kernel/fork.c:2771
 __do_sys_clone kernel/fork.c:2913 [inline]
 __se_sys_clone kernel/fork.c:2897 [inline]
 __x64_sys_clone+0x1b6/0x230 kernel/fork.c:2897
 do_syscall_x64 arch/x86/entry/syscall_64.c:61 [inline]
 do_syscall_64+0x166/0x520 arch/x86/entry/syscall_64.c:84
 entry_SYSCALL_64_after_hwframe+0x77/0x7f
page last free pid 805 tgid 805 ts 42732995302 stack trace:
 reset_page_owner include/linux/page_owner.h:26 [inline]
 __free_pages_prepare mm/page_alloc.c:1418 [inline]
 __free_frozen_pages+0xc93/0xd90 mm/page_alloc.c:2962
 __slab_free+0x274/0x2c0 mm/slub.c:5823
 qlink_free mm/kasan/quarantine.c:163 [inline]
 qlist_free_all+0x99/0x100 mm/kasan/quarantine.c:179
 kasan_quarantine_reduce+0x148/0x160 mm/kasan/quarantine.c:286
 __kasan_slab_alloc+0x22/0x80 mm/kasan/common.c:361
 kasan_slab_alloc include/linux/kasan.h:253 [inline]
 slab_post_alloc_hook mm/slub.c:4683 [inline]
 slab_alloc_node mm/slub.c:4996 [inline]
 __kmalloc_cache_noprof+0x29f/0x600 mm/slub.c:5559
 _kmalloc_noprof include/linux/slab.h:991 [inline]
 _kzalloc_noprof include/linux/slab.h:1312 [inline]
 drm_atomic_commit_alloc+0xa9/0x100 drivers/gpu/drm/drm_atomic.c:258
 drm_atomic_helper_dirtyfb+0x129/0xfd0 drivers/gpu/drm/drm_damage_helper.c:=
128
 drm_fbdev_shmem_helper_fb_dirty+0x160/0x310 drivers/gpu/drm/drm_fbdev_shme=
m.c:117
 drm_fb_helper_fb_dirty drivers/gpu/drm/drm_fb_helper.c:339 [inline]
 drm_fb_helper_damage_work+0x84c/0xf20 drivers/gpu/drm/drm_fb_helper.c:365
 process_one_work kernel/workqueue.c:3396 [inline]
 process_scheduled_works+0xc3d/0x1630 kernel/workqueue.c:3479
 worker_thread+0xa47/0xfb0 kernel/workqueue.c:3560
 kthread+0x38b/0x480 kernel/kthread.c:436
 ret_from_fork+0x514/0xb70 arch/x86/kernel/process.c:158
 ret_from_fork_asm+0x1a/0x30 arch/x86/entry/entry_64.S:245

Memory state around the buggy address:
 ffff888111a3d400: fc fc fc fc 00 00 00 00 00 00 00 00 00 00 00 00
 ffff888111a3d480: 00 00 00 00 00 00 00 00 00 00 00 00 00 fc fc fc
>ffff888111a3d500: fc fc fc fc fc fa fb fb fb fb fb fb fb fb fb fb
                                        ^
 ffff888111a3d580: fb fb fb fb fb fb fb fb fb fb fb fb fb fb fc fc
 ffff888111a3d600: fc fc fc fc fc fc fa fb fb fb fb fb fb fb fb fb
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D


***

If these findings have caused you to resend the series or submit a
separate fix, please add the following tag to your commit message:
  Tested-by: syzbot@syzkaller.appspotmail.com

---
This report is generated by a bot. It may contain errors.
syzbot ci engineers can be reached at syzkaller@googlegroups.com.

To test a fix for this bug, please reply with `#syz test`
(on a separate line) and attach the patch to the email.

Notes:
- The patch will be applied on top of the tested series (as an
  incremental fix).
- To test a new version of the whole series, please send it directly
  to syzbot@lists.linux.dev.
- Arguments like custom git repos and branches are not supported.

The email will later be sent to:
[abuehaze@amazon.com agruenba@redhat.com akpm@linux-foundation.org alisaidi=
@amazon.com almaz.alexandrovich@paragon-software.com apopple@nvidia.com bla=
kgeof@amazon.com brauner@kernel.org byungchul@sk.com cem@kernel.org david@k=
ernel.org dipietro.salvatore@gmail.com dipiets@amazon.it djwong@kernel.org =
dlemoal@kernel.org exfat@lists.linux.dev fuse-devel@lists.linux.dev gfs2@li=
sts.linux.dev gourry@gourry.net hyc.lee@gmail.com jack@suse.cz joshua.hahnj=
y@gmail.com jth@kernel.org liam@infradead.org linkinjeon@kernel.org linux-f=
sdevel@vger.kernel.org linux-kernel@vger.kernel.org linux-mm@kvack.org linu=
x-xfs@vger.kernel.org ljs@kernel.org matthew.brost@intel.com mhocko@suse.co=
m miklos@szeredi.hu naohiro.aota@wdc.com ntfs3@lists.linux.dev ntfs@lists.l=
inux.dev rakie.kim@sk.com ritesh.list@gmail.com rppt@kernel.org rvvandan@am=
azon.com ryan.roberts@arm.com sj1557.seo@samsung.com stable@vger.kernel.org=
 surenb@google.com vbabka@kernel.org viro@zeniv.linux.org.uk willy@infradea=
d.org ying.huang@linux.alibaba.com yuezhang.mo@sony.com ziy@nvidia.com]

If the report looks fine to you, reply with:
#syz upstream

If the report is a false positive, reply with
#syz invalid

