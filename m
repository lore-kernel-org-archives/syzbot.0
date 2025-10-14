Received: from mail-il1-f199.google.com (mail-il1-f199.google.com [209.85.166.199])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5A7263081C5
	for <syzbot@lists.linux.dev>; Tue, 14 Oct 2025 20:59:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.199
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760475554; cv=none; b=U+V63KZ1K1ZR9J23QDObThxUmTGDvdQb84KpgXaWRidqqUpf36Dm3+tx+1DIlkm5LqwA8e0VaQeQtsSQk5XkN6smLQTavBsc6+zxOhDvY0qUA/orX1m0iPOFpCElNCMtI7qYoV+A6/2Hwmocr8mWcC8vx9C0Z0qpJfpa4TTobN0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760475554; c=relaxed/simple;
	bh=9mUFL3G71fjBwrbnr1lNdwOtznlIv3DfcnsS1MT4w5o=;
	h=MIME-Version:Date:In-Reply-To:Message-ID:Subject:From:To:Cc:
	 Content-Type; b=pMWS82NgNsLUS6F8m55hB+9AJzoTR8wX5VL/GJjlOUP+LLdFfHOUPHjORp9q+Z16ztFac39qVnwyY5wk6mWP5/k+LaQMu8SsDPgguV+SI1uCsJwoQf3XSPOvxY7yR+iR+X36qqxqrrwxofn4bo0qLwKiHQXtQhUNv6Wv/w4u/yk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com; arc=none smtp.client-ip=209.85.166.199
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com
Received: by mail-il1-f199.google.com with SMTP id e9e14a558f8ab-42571c700d2so255974585ab.1
        for <syzbot@lists.linux.dev>; Tue, 14 Oct 2025 13:59:11 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1760475550; x=1761080350;
        h=cc:to:from:subject:message-id:in-reply-to:date:mime-version
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=eDIzKnyYQYVBVTMJTm3EU3kf+j9v36WaUpHJYFznX+M=;
        b=SRFBCONBimg44uUAjyiwQkcUkc4IglPulDoJVZuRt91OhVpO7MjN48qDspyA9WzS9D
         EPxjsdJle7zoOyZcraLQ1KnIx86MZsao1i1Pm0MbJiCOjQx6oLIUObZ1P6iKWvXpr8pf
         qj/M6PyfCeLLsc8HF8tP5oiI4fRGGRQoQdSTxWzus9ksH8qj+lwcFr7Ao1AgNNCQONef
         gSUr8FrfiOjSgun0LWqhVNvLXXqrNb9LErCULUlQaw1GfmBJ7LeksShWhSrHmS8hm+Oz
         zwOoOIjWcG2jifwOsl7hK9D9p0a++lvHxRvx+uh3ZoMmxldD0e6gnH2S5bnw5Z/JJfHa
         iKiQ==
X-Gm-Message-State: AOJu0YyKHMlLhamIe1/lCXLQXhkHGEmKRWASufn8XX6B73toWyp3QfgN
	+6gNt1OVUw3RwvcD5ZxIvR597Y2qp2P3E8NKL9ZySgzYnk6fL2l69PYy4NwiloIZ0mFDPz/j72P
	7kcLiw7A5Zs/yeiYg/5IEZzD8mtHr3VsAtzs4TgyrGvLtwA6KOasjQSNV8bk=
X-Google-Smtp-Source: AGHT+IGvkjZpBR5PAfCh6TiM3uyh3ugQUu7Xnk66IPevukGGiWpGu6g/KXTL5zY4tnbwb0s/hYulmmPon+osRbrlurVo5NjwfWKJ
Precedence: bulk
X-Mailing-List: syzbot@lists.linux.dev
List-Id: <syzbot.lists.linux.dev>
List-Subscribe: <mailto:syzbot+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:syzbot+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Received: by 2002:a05:6e02:3c04:b0:42e:729d:5f65 with SMTP id
 e9e14a558f8ab-42f87350876mr277577935ab.1.1760475550155; Tue, 14 Oct 2025
 13:59:10 -0700 (PDT)
Date: Tue, 14 Oct 2025 13:59:10 -0700
In-Reply-To: <20251014130437.1090448-1-baolu.lu@linux.intel.com>
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <68eeb99e.050a0220.91a22.0220.GAE@google.com>
Subject: [syzbot ci] Re: Fix stale IOTLB entries for kernel address space
From: syzbot ci <syzbot+cid009622971eb4566@syzkaller.appspotmail.com>
To: akpm@linux-foundation.org, apopple@nvidia.com, baolu.lu@linux.intel.com, 
	bp@alien8.de, dave.hansen@intel.com, dave.hansen@linux.intel.com, 
	david@redhat.com, iommu@lists.linux.dev, jannh@google.com, 
	jean-philippe@linaro.org, jgg@nvidia.com, joro@8bytes.org, 
	kevin.tian@intel.com, liam.howlett@oracle.com, linux-kernel@vger.kernel.org, 
	linux-mm@kvack.org, lorenzo.stoakes@oracle.com, luto@kernel.org, 
	mhocko@kernel.org, mingo@redhat.com, peterz@infradead.org, 
	robin.murphy@arm.com, rppt@kernel.org, security@kernel.org, 
	stable@vger.kernel.org, tglx@linutronix.de, urezki@gmail.com, 
	vasant.hegde@amd.com, vbabka@suse.cz, will@kernel.org, willy@infradead.org, 
	x86@kernel.org, yi1.lai@intel.com
Cc: syzbot@lists.linux.dev, syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"

syzbot ci has tested the following series

[v6] Fix stale IOTLB entries for kernel address space
https://lore.kernel.org/all/20251014130437.1090448-1-baolu.lu@linux.intel.com
* [PATCH v6 1/7] mm: Add a ptdesc flag to mark kernel page tables
* [PATCH v6 2/7] mm: Actually mark kernel page table pages
* [PATCH v6 3/7] x86/mm: Use 'ptdesc' when freeing PMD pages
* [PATCH v6 4/7] mm: Introduce pure page table freeing function
* [PATCH v6 5/7] x86/mm: Use pagetable_free()
* [PATCH v6 6/7] mm: Introduce deferred freeing for kernel page tables
* [PATCH v6 7/7] iommu/sva: Invalidate stale IOTLB entries for kernel address space

and found the following issues:
* KASAN: use-after-free Read in pmd_set_huge
* KASAN: use-after-free Read in vmap_range_noflush
* PANIC: double fault in search_extable

Full report is available here:
https://ci.syzbot.org/series/9d75a765-d6b2-4839-8db9-2f2e64e78cdd

***

KASAN: use-after-free Read in pmd_set_huge

tree:      torvalds
URL:       https://kernel.googlesource.com/pub/scm/linux/kernel/git/torvalds/linux
base:      0d97f2067c166eb495771fede9f7b73999c67f66
arch:      amd64
compiler:  Debian clang version 20.1.8 (++20250708063551+0c9f909b7976-1~exp1~20250708183702.136), Debian LLD 20.1.8
config:    https://ci.syzbot.org/builds/68e38247-432a-45b2-b187-a533b7040841/config
syz repro: https://ci.syzbot.org/findings/ce54ec93-1f21-4deb-b2f8-d34917bd1be2/syz_repro

==================================================================
BUG: KASAN: use-after-free in pmd_set_huge+0xd8/0x340 arch/x86/mm/pgtable.c:676
Read of size 8 at addr ffff888100efa960 by task syz.0.20/5965

CPU: 1 UID: 0 PID: 5965 Comm: syz.0.20 Not tainted syzkaller #0 PREEMPT(full) 
Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS 1.16.2-debian-1.16.2-1 04/01/2014
Call Trace:
 <TASK>
 dump_stack_lvl+0x189/0x250 lib/dump_stack.c:120
 print_address_description mm/kasan/report.c:378 [inline]
 print_report+0xca/0x240 mm/kasan/report.c:482
 kasan_report+0x118/0x150 mm/kasan/report.c:595
 pmd_set_huge+0xd8/0x340 arch/x86/mm/pgtable.c:676
 vmap_try_huge_pmd mm/vmalloc.c:161 [inline]
 vmap_pmd_range mm/vmalloc.c:177 [inline]
 vmap_pud_range mm/vmalloc.c:233 [inline]
 vmap_p4d_range mm/vmalloc.c:284 [inline]
 vmap_range_noflush+0x7b3/0xf80 mm/vmalloc.c:308
 __vmap_pages_range_noflush+0xd31/0xf30 mm/vmalloc.c:661
 vmap_pages_range_noflush mm/vmalloc.c:681 [inline]
 vmap_pages_range mm/vmalloc.c:701 [inline]
 __vmalloc_area_node mm/vmalloc.c:3766 [inline]
 __vmalloc_node_range_noprof+0xe8c/0x12d0 mm/vmalloc.c:3897
 __kvmalloc_node_noprof+0x674/0x910 mm/slub.c:7058
 nf_tables_newset+0x1330/0x2540 net/netfilter/nf_tables_api.c:5548
 nfnetlink_rcv_batch net/netfilter/nfnetlink.c:526 [inline]
 nfnetlink_rcv_skb_batch net/netfilter/nfnetlink.c:649 [inline]
 nfnetlink_rcv+0x11d9/0x2590 net/netfilter/nfnetlink.c:667
 netlink_unicast_kernel net/netlink/af_netlink.c:1320 [inline]
 netlink_unicast+0x82f/0x9e0 net/netlink/af_netlink.c:1346
 netlink_sendmsg+0x805/0xb30 net/netlink/af_netlink.c:1896
 sock_sendmsg_nosec net/socket.c:727 [inline]
 __sock_sendmsg+0x21c/0x270 net/socket.c:742
 ____sys_sendmsg+0x505/0x830 net/socket.c:2630
 ___sys_sendmsg+0x21f/0x2a0 net/socket.c:2684
 __sys_sendmsg net/socket.c:2716 [inline]
 __do_sys_sendmsg net/socket.c:2721 [inline]
 __se_sys_sendmsg net/socket.c:2719 [inline]
 __x64_sys_sendmsg+0x19b/0x260 net/socket.c:2719
 do_syscall_x64 arch/x86/entry/syscall_64.c:63 [inline]
 do_syscall_64+0xfa/0xfa0 arch/x86/entry/syscall_64.c:94
 entry_SYSCALL_64_after_hwframe+0x77/0x7f
RIP: 0033:0x7fc5fff8eec9
Code: ff ff c3 66 2e 0f 1f 84 00 00 00 00 00 0f 1f 40 00 48 89 f8 48 89 f7 48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 ff ff 73 01 c3 48 c7 c1 a8 ff ff ff f7 d8 64 89 01 48
RSP: 002b:00007fc600ecb038 EFLAGS: 00000246 ORIG_RAX: 000000000000002e
RAX: ffffffffffffffda RBX: 00007fc6001e5fa0 RCX: 00007fc5fff8eec9
RDX: 0000000004008100 RSI: 00002000000000c0 RDI: 0000000000000003
RBP: 00007fc600011f91 R08: 0000000000000000 R09: 0000000000000000
R10: 0000000000000000 R11: 0000000000000246 R12: 0000000000000000
R13: 00007fc6001e6038 R14: 00007fc6001e5fa0 R15: 00007ffed63a0428
 </TASK>

The buggy address belongs to the physical page:
page: refcount:0 mapcount:0 mapping:0000000000000000 index:0x0 pfn:0x100efa
flags: 0x17ff00000000000(node=0|zone=2|lastcpupid=0x7ff)
raw: 017ff00000000000 ffffea0004772f88 ffff88823c6403a0 0000000000000000
raw: 0000000000000000 0000000000000000 00000000ffffffff 0000000000000000
page dumped because: kasan: bad access detected
page_owner tracks the page as freed
page last allocated via order 0, migratetype Unmovable, gfp_mask 0x40100(__GFP_ZERO|__GFP_COMP), pid 0, tgid 0 (swapper/0), ts 1659724794, free_ts 71235002142
 set_page_owner include/linux/page_owner.h:32 [inline]
 post_alloc_hook+0x240/0x2a0 mm/page_alloc.c:1850
 prep_new_page mm/page_alloc.c:1858 [inline]
 get_page_from_freelist+0x2365/0x2440 mm/page_alloc.c:3884
 __alloc_frozen_pages_noprof+0x181/0x370 mm/page_alloc.c:5183
 alloc_pages_mpol+0x232/0x4a0 mm/mempolicy.c:2416
 alloc_frozen_pages_noprof mm/mempolicy.c:2487 [inline]
 alloc_pages_noprof+0xa9/0x190 mm/mempolicy.c:2507
 pagetable_alloc_noprof include/linux/mm.h:3016 [inline]
 pmd_alloc_one_noprof include/asm-generic/pgalloc.h:144 [inline]
 __pmd_alloc+0x3a/0x5d0 mm/memory.c:6573
 pmd_alloc_track mm/pgalloc-track.h:37 [inline]
 vmap_pages_pmd_range mm/vmalloc.c:564 [inline]
 vmap_pages_pud_range mm/vmalloc.c:587 [inline]
 vmap_pages_p4d_range mm/vmalloc.c:605 [inline]
 vmap_small_pages_range_noflush mm/vmalloc.c:627 [inline]
 __vmap_pages_range_noflush+0x9cc/0xf30 mm/vmalloc.c:656
 vmap_pages_range_noflush mm/vmalloc.c:681 [inline]
 vmap_pages_range mm/vmalloc.c:701 [inline]
 vmap+0x1ca/0x310 mm/vmalloc.c:3521
 map_irq_stack arch/x86/kernel/irq_64.c:49 [inline]
 irq_init_percpu_irqstack+0x342/0x4a0 arch/x86/kernel/irq_64.c:76
 init_IRQ+0x15c/0x1c0 arch/x86/kernel/irqinit.c:90
 start_kernel+0x1cd/0x410 init/main.c:1016
 x86_64_start_reservations+0x24/0x30 arch/x86/kernel/head64.c:310
 x86_64_start_kernel+0x143/0x1c0 arch/x86/kernel/head64.c:291
 common_startup_64+0x13e/0x147
page last free pid 5965 tgid 5964 stack trace:
 reset_page_owner include/linux/page_owner.h:25 [inline]
 free_pages_prepare mm/page_alloc.c:1394 [inline]
 __free_frozen_pages+0xbc4/0xd30 mm/page_alloc.c:2906
 pmd_free_pte_page+0xa1/0xc0 arch/x86/mm/pgtable.c:783
 vmap_try_huge_pmd mm/vmalloc.c:158 [inline]
 vmap_pmd_range mm/vmalloc.c:177 [inline]
 vmap_pud_range mm/vmalloc.c:233 [inline]
 vmap_p4d_range mm/vmalloc.c:284 [inline]
 vmap_range_noflush+0x774/0xf80 mm/vmalloc.c:308
 __vmap_pages_range_noflush+0xd31/0xf30 mm/vmalloc.c:661
 vmap_pages_range_noflush mm/vmalloc.c:681 [inline]
 vmap_pages_range mm/vmalloc.c:701 [inline]
 __vmalloc_area_node mm/vmalloc.c:3766 [inline]
 __vmalloc_node_range_noprof+0xe8c/0x12d0 mm/vmalloc.c:3897
 __kvmalloc_node_noprof+0x674/0x910 mm/slub.c:7058
 nf_tables_newset+0x1330/0x2540 net/netfilter/nf_tables_api.c:5548
 nfnetlink_rcv_batch net/netfilter/nfnetlink.c:526 [inline]
 nfnetlink_rcv_skb_batch net/netfilter/nfnetlink.c:649 [inline]
 nfnetlink_rcv+0x11d9/0x2590 net/netfilter/nfnetlink.c:667
 netlink_unicast_kernel net/netlink/af_netlink.c:1320 [inline]
 netlink_unicast+0x82f/0x9e0 net/netlink/af_netlink.c:1346
 netlink_sendmsg+0x805/0xb30 net/netlink/af_netlink.c:1896
 sock_sendmsg_nosec net/socket.c:727 [inline]
 __sock_sendmsg+0x21c/0x270 net/socket.c:742
 ____sys_sendmsg+0x505/0x830 net/socket.c:2630
 ___sys_sendmsg+0x21f/0x2a0 net/socket.c:2684
 __sys_sendmsg net/socket.c:2716 [inline]
 __do_sys_sendmsg net/socket.c:2721 [inline]
 __se_sys_sendmsg net/socket.c:2719 [inline]
 __x64_sys_sendmsg+0x19b/0x260 net/socket.c:2719
 do_syscall_x64 arch/x86/entry/syscall_64.c:63 [inline]
 do_syscall_64+0xfa/0xfa0 arch/x86/entry/syscall_64.c:94
 entry_SYSCALL_64_after_hwframe+0x77/0x7f

Memory state around the buggy address:
 ffff888100efa800: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
 ffff888100efa880: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
>ffff888100efa900: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
                                                       ^
 ffff888100efa980: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
 ffff888100efaa00: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
==================================================================


***

KASAN: use-after-free Read in vmap_range_noflush

tree:      torvalds
URL:       https://kernel.googlesource.com/pub/scm/linux/kernel/git/torvalds/linux
base:      0d97f2067c166eb495771fede9f7b73999c67f66
arch:      amd64
compiler:  Debian clang version 20.1.8 (++20250708063551+0c9f909b7976-1~exp1~20250708183702.136), Debian LLD 20.1.8
config:    https://ci.syzbot.org/builds/68e38247-432a-45b2-b187-a533b7040841/config
C repro:   https://ci.syzbot.org/findings/b676cfe4-8c9a-435c-aa8f-7315912fa378/c_repro
syz repro: https://ci.syzbot.org/findings/b676cfe4-8c9a-435c-aa8f-7315912fa378/syz_repro

==================================================================
BUG: KASAN: use-after-free in vmap_try_huge_pmd mm/vmalloc.c:158 [inline]
BUG: KASAN: use-after-free in vmap_pmd_range mm/vmalloc.c:177 [inline]
BUG: KASAN: use-after-free in vmap_pud_range mm/vmalloc.c:233 [inline]
BUG: KASAN: use-after-free in vmap_p4d_range mm/vmalloc.c:284 [inline]
BUG: KASAN: use-after-free in vmap_range_noflush+0x743/0xf80 mm/vmalloc.c:308
Read of size 8 at addr ffff888100efa128 by task syz.0.17/5955

CPU: 1 UID: 0 PID: 5955 Comm: syz.0.17 Not tainted syzkaller #0 PREEMPT(full) 
Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS 1.16.2-debian-1.16.2-1 04/01/2014
Call Trace:
 <TASK>
 dump_stack_lvl+0x189/0x250 lib/dump_stack.c:120
 print_address_description mm/kasan/report.c:378 [inline]
 print_report+0xca/0x240 mm/kasan/report.c:482
 kasan_report+0x118/0x150 mm/kasan/report.c:595
 vmap_try_huge_pmd mm/vmalloc.c:158 [inline]
 vmap_pmd_range mm/vmalloc.c:177 [inline]
 vmap_pud_range mm/vmalloc.c:233 [inline]
 vmap_p4d_range mm/vmalloc.c:284 [inline]
 vmap_range_noflush+0x743/0xf80 mm/vmalloc.c:308
 __vmap_pages_range_noflush+0xd31/0xf30 mm/vmalloc.c:661
 vmap_pages_range_noflush mm/vmalloc.c:681 [inline]
 vmap_pages_range mm/vmalloc.c:701 [inline]
 __vmalloc_area_node mm/vmalloc.c:3766 [inline]
 __vmalloc_node_range_noprof+0xe8c/0x12d0 mm/vmalloc.c:3897
 __kvmalloc_node_noprof+0x674/0x910 mm/slub.c:7058
 kvmalloc_array_node_noprof include/linux/slab.h:1122 [inline]
 bpf_uprobe_multi_link_attach+0x54b/0xee0 kernel/trace/bpf_trace.c:3228
 link_create+0x673/0x850 kernel/bpf/syscall.c:5721
 __sys_bpf+0x6be/0x860 kernel/bpf/syscall.c:6204
 __do_sys_bpf kernel/bpf/syscall.c:6244 [inline]
 __se_sys_bpf kernel/bpf/syscall.c:6242 [inline]
 __x64_sys_bpf+0x7c/0x90 kernel/bpf/syscall.c:6242
 do_syscall_x64 arch/x86/entry/syscall_64.c:63 [inline]
 do_syscall_64+0xfa/0xfa0 arch/x86/entry/syscall_64.c:94
 entry_SYSCALL_64_after_hwframe+0x77/0x7f
RIP: 0033:0x7f3d8e78eec9
Code: ff ff c3 66 2e 0f 1f 84 00 00 00 00 00 0f 1f 40 00 48 89 f8 48 89 f7 48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 ff ff 73 01 c3 48 c7 c1 a8 ff ff ff f7 d8 64 89 01 48
RSP: 002b:00007f3d8f64c038 EFLAGS: 00000246 ORIG_RAX: 0000000000000141
RAX: ffffffffffffffda RBX: 00007f3d8e9e5fa0 RCX: 00007f3d8e78eec9
RDX: 0000000000000040 RSI: 00002000000005c0 RDI: 000000000000001c
RBP: 00007f3d8e811f91 R08: 0000000000000000 R09: 0000000000000000
R10: 0000000000000000 R11: 0000000000000246 R12: 0000000000000000
R13: 00007f3d8e9e6038 R14: 00007f3d8e9e5fa0 R15: 00007ffe8caa72c8
 </TASK>

The buggy address belongs to the physical page:
page: refcount:0 mapcount:0 mapping:0000000000000000 index:0x0 pfn:0x100efa
flags: 0x17ff00000000000(node=0|zone=2|lastcpupid=0x7ff)
raw: 017ff00000000000 ffffea00044109c8 ffff88823c6403a0 0000000000000000
raw: 0000000000000000 0000000000000000 00000000ffffffff 0000000000000000
page dumped because: kasan: bad access detected
page_owner tracks the page as freed
page last allocated via order 0, migratetype Unmovable, gfp_mask 0x40100(__GFP_ZERO|__GFP_COMP), pid 0, tgid 0 (swapper/0), ts 1684936790, free_ts 91274246476
 set_page_owner include/linux/page_owner.h:32 [inline]
 post_alloc_hook+0x240/0x2a0 mm/page_alloc.c:1850
 prep_new_page mm/page_alloc.c:1858 [inline]
 get_page_from_freelist+0x2365/0x2440 mm/page_alloc.c:3884
 __alloc_frozen_pages_noprof+0x181/0x370 mm/page_alloc.c:5183
 alloc_pages_mpol+0x232/0x4a0 mm/mempolicy.c:2416
 alloc_frozen_pages_noprof mm/mempolicy.c:2487 [inline]
 alloc_pages_noprof+0xa9/0x190 mm/mempolicy.c:2507
 pagetable_alloc_noprof include/linux/mm.h:3016 [inline]
 pmd_alloc_one_noprof include/asm-generic/pgalloc.h:144 [inline]
 __pmd_alloc+0x3a/0x5d0 mm/memory.c:6573
 pmd_alloc_track mm/pgalloc-track.h:37 [inline]
 vmap_pages_pmd_range mm/vmalloc.c:564 [inline]
 vmap_pages_pud_range mm/vmalloc.c:587 [inline]
 vmap_pages_p4d_range mm/vmalloc.c:605 [inline]
 vmap_small_pages_range_noflush mm/vmalloc.c:627 [inline]
 __vmap_pages_range_noflush+0x9cc/0xf30 mm/vmalloc.c:656
 vmap_pages_range_noflush mm/vmalloc.c:681 [inline]
 vmap_pages_range mm/vmalloc.c:701 [inline]
 vmap+0x1ca/0x310 mm/vmalloc.c:3521
 map_irq_stack arch/x86/kernel/irq_64.c:49 [inline]
 irq_init_percpu_irqstack+0x342/0x4a0 arch/x86/kernel/irq_64.c:76
 init_IRQ+0x15c/0x1c0 arch/x86/kernel/irqinit.c:90
 start_kernel+0x1cd/0x410 init/main.c:1016
 x86_64_start_reservations+0x24/0x30 arch/x86/kernel/head64.c:310
 x86_64_start_kernel+0x143/0x1c0 arch/x86/kernel/head64.c:291
 common_startup_64+0x13e/0x147
page last free pid 5892 tgid 5892 stack trace:
 reset_page_owner include/linux/page_owner.h:25 [inline]
 free_pages_prepare mm/page_alloc.c:1394 [inline]
 __free_frozen_pages+0xbc4/0xd30 mm/page_alloc.c:2906
 __pagetable_free include/linux/mm.h:3026 [inline]
 kernel_pgtable_work_func+0x276/0x2e0 mm/pgtable-generic.c:436
 process_one_work kernel/workqueue.c:3263 [inline]
 process_scheduled_works+0xae1/0x17b0 kernel/workqueue.c:3346
 worker_thread+0x8a0/0xda0 kernel/workqueue.c:3427
 kthread+0x711/0x8a0 kernel/kthread.c:463
 ret_from_fork+0x4bc/0x870 arch/x86/kernel/process.c:158
 ret_from_fork_asm+0x1a/0x30 arch/x86/entry/entry_64.S:245

Memory state around the buggy address:
 ffff888100efa000: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
 ffff888100efa080: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
>ffff888100efa100: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
                                  ^
 ffff888100efa180: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
 ffff888100efa200: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
==================================================================


***

PANIC: double fault in search_extable

tree:      torvalds
URL:       https://kernel.googlesource.com/pub/scm/linux/kernel/git/torvalds/linux
base:      0d97f2067c166eb495771fede9f7b73999c67f66
arch:      amd64
compiler:  Debian clang version 20.1.8 (++20250708063551+0c9f909b7976-1~exp1~20250708183702.136), Debian LLD 20.1.8
config:    https://ci.syzbot.org/builds/68e38247-432a-45b2-b187-a533b7040841/config
syz repro: https://ci.syzbot.org/findings/967ed946-aab2-484a-8267-954586f5962b/syz_repro

traps: PANIC: double fault, error_code: 0x0
Oops: double fault: 0000 [#1] SMP KASAN PTI
CPU: 1 UID: 0 PID: 5921 Comm: syz-executor Not tainted syzkaller #0 PREEMPT(full) 
Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS 1.16.2-debian-1.16.2-1 04/01/2014
RIP: 0010:search_extable+0x69/0xd0 lib/extable.c:115
Code: 8d 48 c7 44 24 10 20 50 40 8b 49 89 e5 49 c1 ed 03 48 b8 f1 f1 f1 f1 00 f3 f3 f3 49 bc 00 00 00 00 00 fc ff df 4b 89 44 25 00 <e8> 12 45 7f f6 48 89 5c 24 20 b9 0c 00 00 00 48 8d 7c 24 20 4c 89
RSP: 0018:ffffc90003e5f000 EFLAGS: 00010806
RAX: f3f3f300f1f1f1f1 RBX: ffffffff8b4b123e RCX: 0000000000001c56
RDX: ffffffff8b4b123e RSI: 0000000000000972 RDI: ffffffff8dc137d0
RBP: ffffc90003e5f0a0 R08: 0000000000000001 R09: 0000000000000002
R10: 0000000000000011 R11: 0000000000000000 R12: dffffc0000000000
R13: 1ffff920007cbe00 R14: 0000000000000972 R15: ffffffff8dc137d0
FS:  000055558b2ef500(0000) GS:ffff8882a9d0f000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: ffffc90003e5eff8 CR3: 00000001ba5ea000 CR4: 00000000000006f0
Call Trace:
 <TASK>
 search_kernel_exception_table kernel/extable.c:49 [inline]
 search_exception_tables+0x3a/0x60 kernel/extable.c:58
 fixup_exception+0xb1/0x20b0 arch/x86/mm/extable.c:319
 kernelmode_fixup_or_oops+0x68/0xf0 arch/x86/mm/fault.c:726
 __bad_area_nosemaphore+0x11a/0x780 arch/x86/mm/fault.c:783
 handle_page_fault arch/x86/mm/fault.c:1474 [inline]
 exc_page_fault+0xcf/0x100 arch/x86/mm/fault.c:1532
 asm_exc_page_fault+0x26/0x30 arch/x86/include/asm/idtentry.h:623
RIP: 0010:in_irq_stack arch/x86/kernel/dumpstack_64.c:165 [inline]
RIP: 0010:get_stack_info_noinstr+0xee/0x130 arch/x86/kernel/dumpstack_64.c:182
Code: 08 48 8d 90 08 80 ff ff 49 39 d7 40 0f 92 c6 49 39 cf 40 0f 93 c7 40 08 f7 75 27 41 c7 06 02 00 00 00 49 89 56 08 49 89 4e 10 <48> 8b 00 49 89 46 18 89 d8 5b 41 5c 41 5d 41 5e 41 5f e9 8b 12 03
RSP: 0018:ffffc90003e5f470 EFLAGS: 00010046
RAX: ffffc90000a08ff8 RBX: ffff88816ac1ba01 RCX: ffffc90000a09000
RDX: ffffc90000a01000 RSI: ffffffff8d837700 RDI: ffffffff8bc07500
RBP: ffffc90003e5f630 R08: ffffc90003e5f500 R09: 0000000000000000
R10: ffffc90003e5f5a0 R11: fffff520007cbeb8 R12: ffff88816ac1ba00
R13: fffffe000004f000 R14: ffffc90003e5f5a0 R15: ffffc90000a08ff8
 get_stack_guard_info arch/x86/include/asm/stacktrace.h:45 [inline]
 page_fault_oops+0x12a/0xa10 arch/x86/mm/fault.c:663
 __bad_area_nosemaphore+0x11a/0x780 arch/x86/mm/fault.c:783
 handle_page_fault arch/x86/mm/fault.c:1474 [inline]
 exc_page_fault+0xcf/0x100 arch/x86/mm/fault.c:1532
 asm_exc_page_fault+0x26/0x30 arch/x86/include/asm/idtentry.h:623
RIP: 0010:instr_sysvec_apic_timer_interrupt arch/x86/kernel/apic/apic.c:1052 [inline]
RIP: 0010:sysvec_apic_timer_interrupt+0x8e/0xc0 arch/x86/kernel/apic/apic.c:1052
Code: 00 00 48 c7 c7 c0 b4 67 8b e8 ae 23 00 00 65 c6 05 50 d7 45 07 01 48 c7 c7 a0 b4 67 8b e8 9a 23 00 00 65 4c 8b 1d 02 d7 45 07 <49> 89 23 4c 89 dc e8 77 23 39 f6 48 89 df e8 4f 2f 25 f6 e8 8a 24
RSP: 0018:ffffc90003e5f830 EFLAGS: 00010082
RAX: 0000000000000001 RBX: ffffc90003e5f848 RCX: 4d01a0d08cb75600
RDX: 0000000000000000 RSI: ffffffff8b67b4a0 RDI: ffffffff8bc07560
RBP: 0000000000000000 R08: ffffffff8f9e1177 R09: 1ffffffff1f3c22e
R10: dffffc0000000000 R11: ffffc90000a08ff8 R12: 0000000000000000
R13: 0000000000000000 R14: 0000000000000000 R15: 0000000000000000
 asm_sysvec_apic_timer_interrupt+0x1a/0x20 arch/x86/include/asm/idtentry.h:702
RIP: 0010:check_preemption_disabled+0x0/0x120 lib/smp_processor_id.c:13
Code: c7 00 75 c0 8b 48 c7 c6 40 75 c0 8b eb 1c 66 66 66 2e 0f 1f 84 00 00 00 00 00 90 90 90 90 90 90 90 90 90 90 90 90 90 90 90 90 <55> 41 57 41 56 53 48 83 ec 10 65 48 8b 05 ae b4 45 07 48 89 44 24
RSP: 0018:ffffc90003e5f8f0 EFLAGS: 00000282
RAX: 0000000000000000 RBX: 00007f5f1858e627 RCX: dffffc0000000000
RDX: 0000000000000000 RSI: ffffffff8bc07540 RDI: ffffffff8bc07500
RBP: 0000000000000001 R08: 0000000000000022 R09: ffffffff81731d25
R10: ffffc90003e5f9b8 R11: ffffffff81abbe80 R12: ffff88816ac1ba00
R13: dffffc0000000000 R14: dffffc0000000000 R15: 1ffff920007cbf36
 rcu_is_watching_curr_cpu include/linux/context_tracking.h:128 [inline]
 rcu_is_watching+0x15/0xb0 kernel/rcu/tree.c:751
 kernel_text_address+0x80/0xe0 kernel/extable.c:113
 __kernel_text_address+0xd/0x40 kernel/extable.c:79
 unwind_get_return_address+0x4d/0x90 arch/x86/kernel/unwind_orc.c:369
 arch_stack_walk+0xfc/0x150 arch/x86/kernel/stacktrace.c:26
 stack_trace_save+0x9c/0xe0 kernel/stacktrace.c:122
 ref_tracker_free+0xef/0x7d0 lib/ref_tracker.c:307
 __netns_tracker_free include/net/net_namespace.h:379 [inline]
 put_net_track include/net/net_namespace.h:394 [inline]
 __sk_destruct+0x3c3/0x660 net/core/sock.c:2368
 sock_put include/net/sock.h:1972 [inline]
 unix_release_sock+0xa7b/0xd50 net/unix/af_unix.c:732
 unix_release+0x92/0xd0 net/unix/af_unix.c:1196
 __sock_release net/socket.c:662 [inline]
 sock_close+0xc3/0x240 net/socket.c:1455
 __fput+0x44c/0xa70 fs/file_table.c:468
 fput_close_sync+0x119/0x200 fs/file_table.c:573
 __do_sys_close fs/open.c:1589 [inline]
 __se_sys_close fs/open.c:1574 [inline]
 __x64_sys_close+0x7f/0x110 fs/open.c:1574
 do_syscall_x64 arch/x86/entry/syscall_64.c:63 [inline]
 do_syscall_64+0xfa/0xfa0 arch/x86/entry/syscall_64.c:94
 entry_SYSCALL_64_after_hwframe+0x77/0x7f
RIP: 0033:0x7f5f1858e627
Code: 44 00 00 48 c7 c2 a8 ff ff ff f7 d8 64 89 02 b8 ff ff ff ff eb bc 66 2e 0f 1f 84 00 00 00 00 00 0f 1f 00 b8 03 00 00 00 0f 05 <48> 3d 00 f0 ff ff 77 01 c3 48 c7 c2 a8 ff ff ff f7 d8 64 89 02 b8
RSP: 002b:00007ffec60e5be8 EFLAGS: 00000246 ORIG_RAX: 0000000000000003
RAX: ffffffffffffffda RBX: 0000000000000005 RCX: 00007f5f1858e627
RDX: 0000000000000000 RSI: 0000000000008933 RDI: 0000000000000005
RBP: 00007ffec60e5bf0 R08: 000000000000000a R09: 0000000000000001
R10: 000000000000000f R11: 0000000000000246 R12: 0000000000000024
R13: 000000000000002d R14: 00007f5f19314620 R15: 0000000000000024
 </TASK>
Modules linked in:
---[ end trace 0000000000000000 ]---
RIP: 0010:search_extable+0x69/0xd0 lib/extable.c:115
Code: 8d 48 c7 44 24 10 20 50 40 8b 49 89 e5 49 c1 ed 03 48 b8 f1 f1 f1 f1 00 f3 f3 f3 49 bc 00 00 00 00 00 fc ff df 4b 89 44 25 00 <e8> 12 45 7f f6 48 89 5c 24 20 b9 0c 00 00 00 48 8d 7c 24 20 4c 89
RSP: 0018:ffffc90003e5f000 EFLAGS: 00010806
RAX: f3f3f300f1f1f1f1 RBX: ffffffff8b4b123e RCX: 0000000000001c56
RDX: ffffffff8b4b123e RSI: 0000000000000972 RDI: ffffffff8dc137d0
RBP: ffffc90003e5f0a0 R08: 0000000000000001 R09: 0000000000000002
R10: 0000000000000011 R11: 0000000000000000 R12: dffffc0000000000
R13: 1ffff920007cbe00 R14: 0000000000000972 R15: ffffffff8dc137d0
FS:  000055558b2ef500(0000) GS:ffff8882a9d0f000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: ffffc90003e5eff8 CR3: 00000001ba5ea000 CR4: 00000000000006f0
----------------
Code disassembly (best guess):
   0:	8d 48 c7             	lea    -0x39(%rax),%ecx
   3:	44 24 10             	rex.R and $0x10,%al
   6:	20 50 40             	and    %dl,0x40(%rax)
   9:	8b 49 89             	mov    -0x77(%rcx),%ecx
   c:	e5 49                	in     $0x49,%eax
   e:	c1 ed 03             	shr    $0x3,%ebp
  11:	48 b8 f1 f1 f1 f1 00 	movabs $0xf3f3f300f1f1f1f1,%rax
  18:	f3 f3 f3
  1b:	49 bc 00 00 00 00 00 	movabs $0xdffffc0000000000,%r12
  22:	fc ff df
  25:	4b 89 44 25 00       	mov    %rax,0x0(%r13,%r12,1)
* 2a:	e8 12 45 7f f6       	call   0xf67f4541 <-- trapping instruction
  2f:	48 89 5c 24 20       	mov    %rbx,0x20(%rsp)
  34:	b9 0c 00 00 00       	mov    $0xc,%ecx
  39:	48 8d 7c 24 20       	lea    0x20(%rsp),%rdi
  3e:	4c                   	rex.WR
  3f:	89                   	.byte 0x89


***

If these findings have caused you to resend the series or submit a
separate fix, please add the following tag to your commit message:
  Tested-by: syzbot@syzkaller.appspotmail.com

---
This report is generated by a bot. It may contain errors.
syzbot ci engineers can be reached at syzkaller@googlegroups.com.
