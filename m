Received: from mail-io1-f69.google.com (mail-io1-f69.google.com [209.85.166.69])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F1DCA33987
	for <syzbot@lists.linux.dev>; Mon, 20 Oct 2025 04:28:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.69
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760934522; cv=none; b=k82QBnhoorvSwpThoYTSvLy7kRL/VJyxXVEtOEzFmF0uRISqXDSw3ZSja9w59VFldOCKK33u1r0nJEQMNEyuGZmjwZPPyNEYvIxrnyw7bvAolcP0jrpcsyZMAOt7W7I8e4h1EiXS3tum8iR9YR+02YOS2VO0b8arjWgkVyei4iI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760934522; c=relaxed/simple;
	bh=S6TWYHXUTioENORdbHOT5zqHl5TWw/0X7bVtwc/WBbc=;
	h=MIME-Version:Date:Message-ID:Subject:From:To:Cc:Content-Type; b=T9Zs2ZWGRGO4RFsscYwtXgR2/0nzJt2nDnjhsXJaeVfW9RlD3IonS5y/HdHbrCcsTOb30JzCpH4cjZ+LVIO83QPHrhKOuk4VPM0zQPFbb6/w08sY2uWL5QOKL5jF0AcC4VR0XnvvyfNBj+T5LwttOv42xLHovD857JbBejM14nw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com; arc=none smtp.client-ip=209.85.166.69
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com
Received: by mail-io1-f69.google.com with SMTP id ca18e2360f4ac-93e86696b5fso182598139f.1
        for <syzbot@lists.linux.dev>; Sun, 19 Oct 2025 21:28:40 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1760934520; x=1761539320;
        h=cc:to:from:subject:message-id:date:mime-version:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=wysEvq86/AepsfjWBzNi+72Kes2zhRyWDG6GdcKvOWg=;
        b=m8cZ+7WdIB+zRkZOxQAmet9AmiTlMKOXb4I+/o08oU6zfMMk9S24Ke/b1W6VIpYuzI
         5Me1JE5sjMTahfnx8q7zzNQyI01WBL0v43QRc7AQnlGk4KC28TqeVPo6BEurSbstTkuY
         CjD6f03/8UJEL0v7czl66F7Tp/VHavYovsMK4USMASNLdZf7b8pyIfqgj21nv0FpwfvL
         8rbgIyLImeaLo48mnUqQYSJmJbkc1/fkrqxGieh/I9sgIkfpQAQi1AjELvDkvzNtqXz6
         asMvYOCBbObYndvCsiZIKyS5bsYxD2vYn3eG65tEV0nTAEhruUT4zwRJE4I77gEU8GTR
         8eAA==
X-Gm-Message-State: AOJu0YwGjAYKLT57e8mb8E1zzT0u+C8rpHwMbdeWE4iLuMmtoIMo53aZ
	hLFQyApnDupB+9m68G71GpeBojQrwE4JfXnY+OVRyZ+xuth8v/qH2EfMKi1esSYjqBqTWT0dWnA
	La++6U4LQQ7AYP0EoRgW5GCS5RAhL/BihKvXVDv69unK0dB7tazysCwxA/fs=
X-Google-Smtp-Source: AGHT+IE539HSnY96vtDITmkdY91EhnpgQqiy7w8f4Vh1hh1fzbFv683E8btfMsNXtaqDTqCHfkDl/9ETjGa+JZ+zBF6UakKj3INB
Precedence: bulk
X-Mailing-List: syzbot@lists.linux.dev
List-Id: <syzbot.lists.linux.dev>
List-Subscribe: <mailto:syzbot+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:syzbot+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Received: by 2002:a05:6602:3e8f:b0:93b:c6aa:5e14 with SMTP id
 ca18e2360f4ac-93e762c1ddemr1981839239f.7.1760934520148; Sun, 19 Oct 2025
 21:28:40 -0700 (PDT)
Date: Sun, 19 Oct 2025 21:28:40 -0700
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <68f5ba78.050a0220.91a22.043d.GAE@google.com>
Subject: [moderation/CI] Re: Separate ptdesc from struct page
From: syzbot ci <syzbot+ci1d0ea3c67212a0da@syzkaller.appspotmail.com>
To: syzkaller-upstream-moderation@googlegroups.com
Cc: syzbot@lists.linux.dev
Content-Type: text/plain; charset="UTF-8"

syzbot ci has tested the following series

[v1] Separate ptdesc from struct page
https://lore.kernel.org/all/20251020001652.2116669-1-willy@infradead.org
* [RFC PATCH 1/7] mm: Use frozen pages for page tables
* [RFC PATCH 2/7] mm: Account pagetable memory when allocated
* [RFC PATCH 3/7] mm: Mark pagetable memory when allocated
* [RFC PATCH 4/7] pgtable: Remove uses of page->lru
* [RFC PATCH 5/7] x86: Call preallocate_vmalloc_pages() later
* [RFC PATCH 6/7] mm: Add alloc_pages_memdesc family of APIs
* [RFC PATCH 7/7] mm: Allocate ptdesc from slab

and found the following issue:
kernel BUG in pte_free_now

Full report is available here:
https://ci.syzbot.org/series/034eb8df-67a6-4c07-8ba5-3ac0df045a40

***

kernel BUG in pte_free_now

tree:      torvalds
URL:       https://kernel.googlesource.com/pub/scm/linux/kernel/git/torvalds/linux
base:      3a8660878839faadb4f1a6dd72c3179c1df56787
arch:      amd64
compiler:  Debian clang version 20.1.8 (++20250708063551+0c9f909b7976-1~exp1~20250708183702.136), Debian LLD 20.1.8
config:    https://ci.syzbot.org/builds/2cf2c360-080f-4864-9be9-e277d29fc594/config
syz repro: https://ci.syzbot.org/findings/1f85642a-695a-4b8d-a5ee-b95a5105cc53/syz_repro

 __do_softirq kernel/softirq.c:656 [inline]
 invoke_softirq kernel/softirq.c:496 [inline]
 __irq_exit_rcu+0xca/0x1f0 kernel/softirq.c:723
 irq_exit_rcu+0x9/0x30 kernel/softirq.c:739
 instr_sysvec_apic_timer_interrupt arch/x86/kernel/apic/apic.c:1052 [inline]
 sysvec_apic_timer_interrupt+0xa6/0xc0 arch/x86/kernel/apic/apic.c:1052
 asm_sysvec_apic_timer_interrupt+0x1a/0x20 arch/x86/include/asm/idtentry.h:697
------------[ cut here ]------------
kernel BUG at ./include/linux/mm.h:2959!
Oops: invalid opcode: 0000 [#1] SMP KASAN PTI
CPU: 0 UID: 0 PID: 6093 Comm: syz.1.54 Not tainted syzkaller #0 PREEMPT(full) 
Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS 1.16.2-debian-1.16.2-1 04/01/2014
RIP: 0010:page_ptdesc include/linux/mm.h:2959 [inline]
RIP: 0010:pte_free include/asm-generic/pgalloc.h:115 [inline]
RIP: 0010:pte_free_now+0xc2/0xd0 mm/pgtable-generic.c:249
Code: 48 89 df e8 20 d1 13 00 48 8b 13 48 c7 c7 c0 89 76 8b 4c 89 f6 e8 6e 66 15 ff 4c 89 ff 48 c7 c6 00 8a 76 8b e8 1f c3 15 ff 90 <0f> 0b 66 66 66 2e 0f 1f 84 00 00 00 00 00 90 90 90 90 90 90 90 90
RSP: 0018:ffffc90000007bb0 EFLAGS: 00010246
RAX: de62a9f92d629d00 RBX: ffffea0005ca91e0 RCX: de62a9f92d629d00
RDX: 0000000000000002 RSI: ffffffff8d9d1d2d RDI: ffff8881127ad700
RBP: ffffc90000007e30 R08: ffffc90000007567 R09: 1ffff92000000eac
R10: dffffc0000000000 R11: fffff52000000ead R12: dffffc0000000000
R13: ffffffff81a82b37 R14: 0000000000000000 R15: ffffea0005ca91c0
FS:  00007f66c98976c0(0000) GS:ffff88818e70c000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 00007f66c9896fc8 CR3: 0000000112a72000 CR4: 00000000000006f0
Call Trace:
 <IRQ>
 rcu_do_batch kernel/rcu/tree.c:2605 [inline]
 rcu_core+0xcab/0x1770 kernel/rcu/tree.c:2861
 handle_softirqs+0x286/0x870 kernel/softirq.c:622
 __do_softirq kernel/softirq.c:656 [inline]
 invoke_softirq kernel/softirq.c:496 [inline]
 __irq_exit_rcu+0xca/0x1f0 kernel/softirq.c:723
 irq_exit_rcu+0x9/0x30 kernel/softirq.c:739
 instr_sysvec_apic_timer_interrupt arch/x86/kernel/apic/apic.c:1052 [inline]
 sysvec_apic_timer_interrupt+0xa6/0xc0 arch/x86/kernel/apic/apic.c:1052
 </IRQ>
 <TASK>
 asm_sysvec_apic_timer_interrupt+0x1a/0x20 arch/x86/include/asm/idtentry.h:697
RIP: 0010:clear_page_rep+0xe/0x20 arch/x86/lib/clear_page_64.S:23
Code: cc cc cc cc cc cc cc cc cc cc cc cc 90 90 90 90 90 90 90 90 90 90 90 90 90 90 90 90 f3 0f 1e fa b9 00 02 00 00 31 c0 f3 48 ab <e9> 8d 46 04 00 90 90 90 90 90 90 90 90 90 90 90 90 90 90 90 90 90
RSP: 0018:ffffc90003cb76d0 EFLAGS: 00000246
RAX: 0000000000000000 RBX: fffa800000000000 RCX: 0000000000000000
RDX: 0000000000000000 RSI: 0000000000000000 RDI: ffff8880123a2000
RBP: fffa8000123a1000 R08: ffffea000048e847 R09: 1ffffd4000091d08
R10: dffffc0000000000 R11: fffff94000091d09 R12: 0000000000000000
R13: 1ffffffff1b404a6 R14: 1ffffffff1b404a4 R15: 0000000000000000
 clear_page arch/x86/include/asm/page_64.h:54 [inline]
 clear_highpage include/linux/highmem.h:240 [inline]
 shmem_get_folio_gfp+0xaad/0x1660 mm/shmem.c:2583
 shmem_fault+0x179/0x390 mm/shmem.c:2734
 __do_fault+0x138/0x390 mm/memory.c:5280
 do_read_fault mm/memory.c:5698 [inline]
 do_fault mm/memory.c:5832 [inline]
 do_pte_missing mm/memory.c:4361 [inline]
 handle_pte_fault mm/memory.c:6177 [inline]
 __handle_mm_fault+0x35e3/0x5400 mm/memory.c:6318
 handle_mm_fault+0x40a/0x8e0 mm/memory.c:6487
 faultin_page mm/gup.c:1126 [inline]
 __get_user_pages+0x165c/0x2a00 mm/gup.c:1428
 populate_vma_page_range+0x29f/0x3a0 mm/gup.c:1860
 __mm_populate+0x24c/0x380 mm/gup.c:1963
 mm_populate include/linux/mm.h:3451 [inline]
 vm_mmap_pgoff+0x387/0x4d0 mm/util.c:586
 do_syscall_x64 arch/x86/entry/syscall_64.c:63 [inline]
 do_syscall_64+0xfa/0xfa0 arch/x86/entry/syscall_64.c:94
 entry_SYSCALL_64_after_hwframe+0x77/0x7f
RIP: 0033:0x7f66c898efc9
Code: ff ff c3 66 2e 0f 1f 84 00 00 00 00 00 0f 1f 40 00 48 89 f8 48 89 f7 48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 ff ff 73 01 c3 48 c7 c1 a8 ff ff ff f7 d8 64 89 01 48
RSP: 002b:00007f66c9897038 EFLAGS: 00000246 ORIG_RAX: 0000000000000009
RAX: ffffffffffffffda RBX: 00007f66c8be6090 RCX: 00007f66c898efc9
RDX: b635773f06ebbeef RSI: 0000000000b36000 RDI: 0000200000000000
RBP: 00007f66c8a11f91 R08: ffffffffffffffff R09: 00000000e9ba1000
R10: 0000000000008031 R11: 0000000000000246 R12: 0000000000000000
R13: 00007f66c8be6128 R14: 00007f66c8be6090 R15: 00007ffcfaf828b8
 </TASK>
Modules linked in:
---[ end trace 0000000000000000 ]---
RIP: 0010:page_ptdesc include/linux/mm.h:2959 [inline]
RIP: 0010:pte_free include/asm-generic/pgalloc.h:115 [inline]
RIP: 0010:pte_free_now+0xc2/0xd0 mm/pgtable-generic.c:249
Code: 48 89 df e8 20 d1 13 00 48 8b 13 48 c7 c7 c0 89 76 8b 4c 89 f6 e8 6e 66 15 ff 4c 89 ff 48 c7 c6 00 8a 76 8b e8 1f c3 15 ff 90 <0f> 0b 66 66 66 2e 0f 1f 84 00 00 00 00 00 90 90 90 90 90 90 90 90
RSP: 0018:ffffc90000007bb0 EFLAGS: 00010246
RAX: de62a9f92d629d00 RBX: ffffea0005ca91e0 RCX: de62a9f92d629d00
RDX: 0000000000000002 RSI: ffffffff8d9d1d2d RDI: ffff8881127ad700
RBP: ffffc90000007e30 R08: ffffc90000007567 R09: 1ffff92000000eac
R10: dffffc0000000000 R11: fffff52000000ead R12: dffffc0000000000
R13: ffffffff81a82b37 R14: 0000000000000000 R15: ffffea0005ca91c0
FS:  00007f66c98976c0(0000) GS:ffff88818e70c000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 00007f66c9896fc8 CR3: 0000000112a72000 CR4: 00000000000006f0
----------------
Code disassembly (best guess):
   0:	cc                   	int3
   1:	cc                   	int3
   2:	cc                   	int3
   3:	cc                   	int3
   4:	cc                   	int3
   5:	cc                   	int3
   6:	cc                   	int3
   7:	cc                   	int3
   8:	cc                   	int3
   9:	cc                   	int3
   a:	cc                   	int3
   b:	cc                   	int3
   c:	90                   	nop
   d:	90                   	nop
   e:	90                   	nop
   f:	90                   	nop
  10:	90                   	nop
  11:	90                   	nop
  12:	90                   	nop
  13:	90                   	nop
  14:	90                   	nop
  15:	90                   	nop
  16:	90                   	nop
  17:	90                   	nop
  18:	90                   	nop
  19:	90                   	nop
  1a:	90                   	nop
  1b:	90                   	nop
  1c:	f3 0f 1e fa          	endbr64
  20:	b9 00 02 00 00       	mov    $0x200,%ecx
  25:	31 c0                	xor    %eax,%eax
  27:	f3 48 ab             	rep stos %rax,%es:(%rdi)
* 2a:	e9 8d 46 04 00       	jmp    0x446bc <-- trapping instruction
  2f:	90                   	nop
  30:	90                   	nop
  31:	90                   	nop
  32:	90                   	nop
  33:	90                   	nop
  34:	90                   	nop
  35:	90                   	nop
  36:	90                   	nop
  37:	90                   	nop
  38:	90                   	nop
  39:	90                   	nop
  3a:	90                   	nop
  3b:	90                   	nop
  3c:	90                   	nop
  3d:	90                   	nop
  3e:	90                   	nop
  3f:	90                   	nop


***

If these findings have caused you to resend the series or submit a
separate fix, please add the following tag to your commit message:
  Tested-by: syzbot@syzkaller.appspotmail.com

---
This report is generated by a bot. It may contain errors.
syzbot ci engineers can be reached at syzkaller@googlegroups.com.

The email will later be sent to:
[hannes@cmpxchg.org linux-mm@kvack.org vishal.moola@gmail.com willy@infradead.org]

If the report looks fine to you, reply with:
#syz upstream

