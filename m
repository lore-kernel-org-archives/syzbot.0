Received: from mail-oo1-f70.google.com (mail-oo1-f70.google.com [209.85.161.70])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4E0B5379ECF
	for <syzbot@lists.linux.dev>; Tue,  3 Mar 2026 02:55:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.161.70
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772506526; cv=none; b=V8EA92daX8Unwr4+KaBZ/G7vlC0PPRzeZNQy62fttor2Ea/7Kaosbxuf04eszQPYiy12ra4vK/6RPRzok9bR+xEivU5ThfBUgb8+0iL+og+kM/UNgixDpNsaCJlo8dCbzqOLWPQ3Ff4NJR3/zWNSpTX1IQMiXD5kT6jpuDg/07s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772506526; c=relaxed/simple;
	bh=qbpchKe/wrTGhS2pQ/fXv3V8/KZzeDUfM/MbyB10CgA=;
	h=MIME-Version:Date:In-Reply-To:Message-ID:Subject:From:To:Cc:
	 Content-Type; b=SxCUZxfDjDMrPmLmOKkbhDHMJqB39USEEul9LAbQpuAAjlAN2EevDhvd49oI4Qu/T5fgg8pJXluGymzAlnxygXETzUGF3MEY1a4K16zCeZmvcWY0DBwPK3HNlwG576CSYJdYW97H60XcsDOmRh7V9hrJblNOiB9Ep8PbJBp3ksI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com; arc=none smtp.client-ip=209.85.161.70
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com
Received: by mail-oo1-f70.google.com with SMTP id 006d021491bc7-676c2e00f3fso97136219eaf.0
        for <syzbot@lists.linux.dev>; Mon, 02 Mar 2026 18:55:25 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1772506524; x=1773111324;
        h=cc:to:from:subject:message-id:in-reply-to:date:mime-version
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=S1Y4DCcGa6Pc4fc3LNy/pPm5xDQt0ekzDgbigSxOwgM=;
        b=N7YDtOlW1KbMJKICECQaIa6eVSjE+DkcEexcxITfT73t7hDrcAsou024hPVgjgi+kr
         wqyoFI2Zgnplps2kimAWo3LLxxBZprLrC+hP06CF9pBSXW+/1Oy27q+XdxxCXttpmb9R
         MLxkrtHPbZCC7H2vTdZOTbDptolI9omaJmXvjeVsPHLx5s0QfMzmSqZ2YOSlLZaJKMa/
         npcE2ZkWlihkFGGKN5IaX1R8PVz10qwPtKjJqlq7Zdd9a2UU5np+alQiFmzSk/MVfOeJ
         Q0xuaAjvA4eVp85N+cEmNM97EW5qt4vj9dkI8CU68Nii5DG/Hb3TrEHpjAyhAt08BECA
         K/HA==
X-Gm-Message-State: AOJu0YyidmUoau0yRMhVjfLWmyhr9SQjnM/9JQS5fRkeOG+3SF9eDyMl
	gM1180fhCZC7xn8j68DQJeS8TLOtDJgpJmmV8aUYgazd7gthb9asj/+6wfo0GzG+ApfPRfknSaO
	jcd4cim0+YhnD1JY2Enhbr4OJDx2lTxkxCOv7Hou9+v8mGvAaY1YgzM2xfXE=
Precedence: bulk
X-Mailing-List: syzbot@lists.linux.dev
List-Id: <syzbot.lists.linux.dev>
List-Subscribe: <mailto:syzbot+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:syzbot+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Received: by 2002:a05:6820:2d43:b0:679:c749:f92e with SMTP id
 006d021491bc7-67a1da0f33emr490862eaf.8.1772506524396; Mon, 02 Mar 2026
 18:55:24 -0800 (PST)
Date: Mon, 02 Mar 2026 18:55:24 -0800
In-Reply-To: <0d112d38d6434ca2916a4d89b9aed312@BJMBX01.spreadtrum.com>
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <69a64d9c.050a0220.21ae90.0004.GAE@google.com>
Subject: Forwarded: reply: [syzbot ci] Re: mm: bail out when the PMD has been
 set in bloom filter
From: syzbot <syzbot@syzkaller.appspotmail.com>
To: syzbot@lists.linux.dev
Cc: syzbot <syzbot+ci8d828f9cb74f67f6@syzkaller.appspotmail.com>, 
	zhaoyang.huang@unisoc.com
Content-Type: text/plain; charset="UTF-8"

For archival purposes, forwarding an incoming command email to
syzbot@lists.linux.dev.

***

Subject: reply: [syzbot ci] Re: mm: bail out when the PMD has been set in bloom filter
Author: zhaoyang.huang@unisoc.com


>syzbot ci has tested the following series
>
>[v1] mm: bail out when the PMD has been set in bloom filter 
>https://lore.kernel.org/all/20260227075250.1128175-1-zhaoyang.huang@uni
>soc.com
>* [PATCH] mm: bail out when the PMD has been set in bloom filter
>
>and found the following issue:
>general protection fault in lru_gen_look_around
>
>Full report is available here:
>https://ci.syzbot.org/series/78ce04ff-c36e-4bcc-a097-f457e3ed9e5e
>
>***
>
>general protection fault in lru_gen_look_around
>
>tree:      mm-new
>URL:
>https://kernel.googlesource.com/pub/scm/linux/kernel/git/akpm/mm.git
>base:      8982358e1c87e3e1dc0aad37f4f93efe9c1cfe03
>arch:      amd64
>compiler:  Debian clang version 21.1.8
>(++20251221033036+2078da43e25a-1~exp1~20251221153213.50), Debian LLD 
>21.1.8
>config:
>https://ci.syzbot.org/builds/e976d408-587c-416f-85ab-a60940674f35/confi
>g
>C repro:
>https://ci.syzbot.org/findings/ea92e1a7-69bd-4608-bc2c-2ff4ca118f9c/c_r
>epr
>o
>syz repro:
>https://ci.syzbot.org/findings/ea92e1a7-69bd-4608-bc2c-2ff4ca118f9c/syz
>_re
>pro
>
>Oops: general protection fault, probably for non-canonical address
>0xdffffc0000000003: 0000 [#1] SMP KASAN PTI
>KASAN: null-ptr-deref in range [0x0000000000000018-0x000000000000001f]
>CPU: 1 UID: 0 PID: 5967 Comm: syz.0.18 Not tainted syzkaller #0 
>PREEMPT(full) Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS
>1.16.2-debian-1.16.2-1 04/01/2014
>RIP: 0010:test_bloom_filter mm/vmscan.c:2785 [inline]
>RIP: 0010:lru_gen_look_around+0x45c/0xd20 mm/vmscan.c:4206
>Code: 22 be ff 48 c7 44 24 48 00 00 00 00 48 83 c3 28 48 89 dd 48 c1 ed 
>03 42
>80 7c 25 00 00 74 08 48 89 df e8 97 b5 28 00 4c 8b 3b <41> 80 7c 24 03 
>00 74 0a bf 18 00 00 00 e8 82 b5 28 00 4c 8b 24 25
>RSP: 0018:ffffc900046e5c90 EFLAGS: 00010246
>RAX: 0000000000000000 RBX: ffffc900046e5e68 RCX: ffff8881100b1d00
>RDX: 0000000000000000 RSI: 0000000000000000 RDI: 0000000000000000
>RBP: 1ffff920008dcbcd R08: ffff88811008fcc3 R09: 1ffff11022011f98
>R10: dffffc0000000000 R11: ffffed1022011f99 R12: dffffc0000000000
>R13: 0000555585af4000 R14: ffffea0006a69fc0 R15: ffff888114457168
>FS:  0000555585ad9500(0000) GS:ffff8882a9461000(0000)
>knlGS:0000000000000000
>CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
>CR2: 00007f4753817dac CR3: 00000001b9a5e000 CR4: 00000000000006f0 Call 
>Trace:
> <TASK>
> folio_referenced_one+0x724/0x1360 mm/rmap.c:962
> rmap_walk_anon+0x5cb/0x7c0 mm/rmap.c:2973  rmap_walk
>mm/rmap.c:3078 [inline]
> folio_referenced+0x3c0/0x5f0 mm/rmap.c:1081  folio_check_references
>mm/vmscan.c:870 [inline]
> shrink_folio_list+0x1008/0x5240 mm/vmscan.c:1237
> evict_folios+0x3f82/0x5090 mm/vmscan.c:4853
> try_to_shrink_lruvec+0xb62/0xfa0 mm/vmscan.c:5008 
>lru_gen_shrink_lruvec mm/vmscan.c:5157 [inline]
> shrink_lruvec+0x54e/0x2b30 mm/vmscan.c:5911  shrink_node_memcgs
>mm/vmscan.c:6147 [inline]
> shrink_node+0xa41/0x3a90 mm/vmscan.c:6188  shrink_zones
>mm/vmscan.c:6427 [inline]
> do_try_to_free_pages+0x6a2/0x1980 mm/vmscan.c:6489
> try_to_free_mem_cgroup_pages+0x2ff/0x870 mm/vmscan.c:6811
> try_charge_memcg+0x827/0x1560 mm/memcontrol.c:2642 
>obj_cgroup_charge_pages mm/memcontrol.c:3084 [inline]
> __memcg_kmem_charge_page+0x32a/0x530 mm/memcontrol.c:3128
> __alloc_frozen_pages_noprof+0x1c1/0x380 mm/page_alloc.c:5271 
>__alloc_pages_noprof mm/page_alloc.c:5288 [inline]
> alloc_pages_bulk_noprof+0x569/0x710 mm/page_alloc.c:5208
> alloc_pages_bulk_mempolicy_noprof+0x34e/0x1680 mm/mempolicy.c:2792 
>vm_area_alloc_pages mm/vmalloc.c:3700 [inline]  __vmalloc_area_node
>mm/vmalloc.c:3875 [inline]
> __vmalloc_node_range_noprof+0xbd9/0x1a80 mm/vmalloc.c:4058 
>__bpf_map_area_alloc kernel/bpf/syscall.c:404 [inline]
> bpf_map_area_alloc+0x12d/0x170 kernel/bpf/syscall.c:411
> bloom_map_alloc+0x22f/0x470 kernel/bpf/bloom_filter.c:146
> map_create+0xafd/0x16a0 kernel/bpf/syscall.c:1507
> __sys_bpf+0x6e1/0x950 kernel/bpf/syscall.c:6210  __do_sys_bpf
>kernel/bpf/syscall.c:6341 [inline]  __se_sys_bpf 
>kernel/bpf/syscall.c:6339 [inline]
> __x64_sys_bpf+0x7c/0x90 kernel/bpf/syscall.c:6339
> do_syscall_x64 arch/x86/entry/syscall_64.c:63 [inline]
> do_syscall_64+0x14d/0xf80 arch/x86/entry/syscall_64.c:94 
>entry_SYSCALL_64_after_hwframe+0x77/0x7f
>RIP: 0033:0x7f475359c799
>Code: ff c3 66 2e 0f 1f 84 00 00 00 00 00 0f 1f 44 00 00 48 89 f8 48 89 
>f7 48 89
>d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 ff ff 
>73 01 c3
>48 c7 c1 e8 ff ff ff f7 d8 64 89 01 48
>RSP: 002b:00007fff2e480d98 EFLAGS: 00000246 ORIG_RAX:
>0000000000000141
>RAX: ffffffffffffffda RBX: 00007f4753815fa0 RCX: 00007f475359c799
>RDX: 0000000000000050 RSI: 0000200000000dc0 RDI: 0000000000000000
>RBP: 00007f4753632bd9 R08: 0000000000000000 R09: 0000000000000000
>R10: 0000000000000000 R11: 0000000000000246 R12: 0000000000000000
>R13: 00007f4753815fac R14: 00007f4753815fa0 R15: 00007f4753815fa0 
></TASK> Modules linked in:
>---[ end trace 0000000000000000 ]---
>RIP: 0010:test_bloom_filter mm/vmscan.c:2785 [inline]
>RIP: 0010:lru_gen_look_around+0x45c/0xd20 mm/vmscan.c:4206
>Code: 22 be ff 48 c7 44 24 48 00 00 00 00 48 83 c3 28 48 89 dd 48 c1 ed 
>03 42
>80 7c 25 00 00 74 08 48 89 df e8 97 b5 28 00 4c 8b 3b <41> 80 7c 24 03 
>00 74 0a bf 18 00 00 00 e8 82 b5 28 00 4c 8b 24 25
>RSP: 0018:ffffc900046e5c90 EFLAGS: 00010246
>RAX: 0000000000000000 RBX: ffffc900046e5e68 RCX: ffff8881100b1d00
>RDX: 0000000000000000 RSI: 0000000000000000 RDI: 0000000000000000
>RBP: 1ffff920008dcbcd R08: ffff88811008fcc3 R09: 1ffff11022011f98
>R10: dffffc0000000000 R11: ffffed1022011f99 R12: dffffc0000000000
>R13: 0000555585af4000 R14: ffffea0006a69fc0 R15: ffff888114457168
>FS:  0000555585ad9500(0000) GS:ffff8882a9461000(0000)
>knlGS:0000000000000000
>CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
>CR2: 00007f4753817dac CR3: 00000001b9a5e000 CR4: 00000000000006f0
>----------------
>Code disassembly (best guess):
>   0:   22 be ff 48 c7 44       and    0x44c748ff(%rsi),%bh
>   6:   24 48                   and    $0x48,%al
>   8:   00 00                   add    %al,(%rax)
>   a:   00 00                   add    %al,(%rax)
>   c:   48 83 c3 28             add    $0x28,%rbx
>  10:   48 89 dd                mov    %rbx,%rbp
>  13:   48 c1 ed 03             shr    $0x3,%rbp
>  17:   42 80 7c 25 00 00       cmpb   $0x0,0x0(%rbp,%r12,1)
>  1d:   74 08                   je     0x27
>  1f:   48 89 df                mov    %rbx,%rdi
>  22:   e8 97 b5 28 00          call   0x28b5be
>  27:   4c 8b 3b                mov    (%rbx),%r15
>* 2a:   41 80 7c 24 03 00       cmpb   $0x0,0x3(%r12) <-- trapping
>instruction
>  30:   74 0a                   je     0x3c
>  32:   bf 18 00 00 00          mov    $0x18,%edi
>  37:   e8 82 b5 28 00          call   0x28b5be
>  3c:   4c                      rex.WR
>  3d:   8b                      .byte 0x8b
>  3e:   24 25                   and    $0x25,%al

#syz test git://kernel.googlesource.com/pub/scm/linux/kernel/git/akpm/mm.git mm-new

---
 mm/vmscan.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/mm/vmscan.c b/mm/vmscan.c
index 10f1e7d716ca..5558a24d1564 100644
--- a/mm/vmscan.c
+++ b/mm/vmscan.c
@@ -4234,6 +4234,10 @@ bool lru_gen_look_around(struct page_vma_mapped_walk *pvmw)
 	/* avoid taking the LRU lock under the PTL when possible */
 	walk = current->reclaim_state ? current->reclaim_state->mm_walk : NULL;
 
+	/* may the pmd has been set in bloom filter */
+	if (mm_state && test_bloom_filter(mm_state, max_seq, pvmw->pmd))
+		return true;
+
 	start = max(addr & PMD_MASK, vma->vm_start);
 	end = min(addr | ~PMD_MASK, vma->vm_end - 1) + 1;
 
--
>
>
>***
>
>If these findings have caused you to resend the series or submit a 
>separate fix, please add the following tag to your commit message:
>  Tested-by: syzbot@syzkaller.appspotmail.com
>
>---
>This report is generated by a bot. It may contain errors.
>syzbot ci engineers can be reached at syzkaller@googlegroups.com.
