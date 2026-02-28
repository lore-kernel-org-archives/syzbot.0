Received: from mail-oo1-f71.google.com (mail-oo1-f71.google.com [209.85.161.71])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E535B426D2A
	for <syzbot@lists.linux.dev>; Sat, 28 Feb 2026 11:20:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.161.71
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772277612; cv=none; b=mqlfeLAmQqWsKYP8OslJek7ZjpIQic6Fsg1kLy+3TGNt6ojUSueDAeq8myhEEUhBC40j7drou43qmtvf9uS2gaMOFMxPYBg3hTJpeK5vrQU5KB+RbdCOjDJBge5T9O8uJZpJfAx7hxQflgi/KGZlJWwIqHek3SH0n3ufHWRepYY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772277612; c=relaxed/simple;
	bh=Bse9odeOYT6wIoabkK4vv0jUcs5R4UOqR+MT+phNg58=;
	h=MIME-Version:Date:In-Reply-To:Message-ID:Subject:From:To:Cc:
	 Content-Type; b=j5dTAsSaPQXQbqfjJgalHowX0kkULDoaAeiALRie+9vtGpcl0Lzl5TR+wW+aeoyjHhAES9nwg9u9fhit4prIRX2XYbNxNFX8XKTW+YuRS0MCm7br/YhxNLtiW8VQP0Q8Ak1fyxjKVFUKmvWRlUT2kyIfNITFHBzsHz63bFwHCo8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com; arc=none smtp.client-ip=209.85.161.71
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com
Received: by mail-oo1-f71.google.com with SMTP id 006d021491bc7-679c6ef1538so64762099eaf.3
        for <syzbot@lists.linux.dev>; Sat, 28 Feb 2026 03:20:10 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1772277610; x=1772882410;
        h=cc:to:from:subject:message-id:in-reply-to:date:mime-version
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=kRhMowKcflxsR17ISGHfZ1IJzdddfU77+fgfBnAwVmk=;
        b=rUntTCNOxkRtD1BWaI5QUVk0yjALB+5owWO5OZeFtbweBQOCNmFA/A7stzvEwN19B5
         eeaHYOJ0nVhWR2+ZiZQMzigvKVMhIpe+FXOfXadenueqrDQDm9lWq8dAA7+cFUEBsS+v
         kN0RpKNuDpgiGBFZhNsVjcVJ6FgZXhhD6OQbDK+7jRQoo6KIIlEKPJp2tHoCTPHmXVBQ
         smIsgdTWTO3RvJJwdXjb22MB1dmT4+u++QMBm+eoFQcVMEQgx2unamnhG9TWwA1snLe3
         HgaJ839La5eT1HL45mX2WSnmtk4SYl+S1xbk6vG4EYcVtl4D9+9RbkMMftuPHBipgzXH
         w9wQ==
X-Gm-Message-State: AOJu0YxWfAPRAv4W4VCo5YVUUYStHol1yLJGgPQNTvJW37PSwY/G3fQq
	uxTmJbsuaKcpST2U2YHXm3TjlSvPuYDO3B6gTUAYUJm/3mLcQQjYsNxvgPi3YKonANRvMcW0GVv
	dovlJ06uxzB9WWWMjIGZjsI8KNPeltkNYpqvKH7Royz6a/GS8/6I9CqIJTsM=
Precedence: bulk
X-Mailing-List: syzbot@lists.linux.dev
List-Id: <syzbot.lists.linux.dev>
List-Subscribe: <mailto:syzbot+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:syzbot+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Received: by 2002:a05:6820:1b10:b0:677:e168:3f57 with SMTP id
 006d021491bc7-679fadc3022mr3603971eaf.4.1772277609900; Sat, 28 Feb 2026
 03:20:09 -0800 (PST)
Date: Sat, 28 Feb 2026 03:20:09 -0800
In-Reply-To: <20260227075250.1128175-1-zhaoyang.huang@unisoc.com>
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <69a2cf69.050a0220.3a55be.0037.GAE@google.com>
Subject: [syzbot ci] Re: mm: bail out when the PMD has been set in bloom filter
From: syzbot ci <syzbot+ci8d828f9cb74f67f6@syzkaller.appspotmail.com>
To: akpm@linux-foundation.org, huangzhaoyang@gmail.com, 
	linux-kernel@vger.kernel.org, linux-mm@kvack.org, steve.kang@unisoc.com, 
	yuzhao@google.com, zhaoyang.huang@unisoc.com
Cc: syzbot@lists.linux.dev, syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"

syzbot ci has tested the following series

[v1] mm: bail out when the PMD has been set in bloom filter
https://lore.kernel.org/all/20260227075250.1128175-1-zhaoyang.huang@unisoc.com
* [PATCH] mm: bail out when the PMD has been set in bloom filter

and found the following issue:
general protection fault in lru_gen_look_around

Full report is available here:
https://ci.syzbot.org/series/78ce04ff-c36e-4bcc-a097-f457e3ed9e5e

***

general protection fault in lru_gen_look_around

tree:      mm-new
URL:       https://kernel.googlesource.com/pub/scm/linux/kernel/git/akpm/mm.git
base:      8982358e1c87e3e1dc0aad37f4f93efe9c1cfe03
arch:      amd64
compiler:  Debian clang version 21.1.8 (++20251221033036+2078da43e25a-1~exp1~20251221153213.50), Debian LLD 21.1.8
config:    https://ci.syzbot.org/builds/e976d408-587c-416f-85ab-a60940674f35/config
C repro:   https://ci.syzbot.org/findings/ea92e1a7-69bd-4608-bc2c-2ff4ca118f9c/c_repro
syz repro: https://ci.syzbot.org/findings/ea92e1a7-69bd-4608-bc2c-2ff4ca118f9c/syz_repro

Oops: general protection fault, probably for non-canonical address 0xdffffc0000000003: 0000 [#1] SMP KASAN PTI
KASAN: null-ptr-deref in range [0x0000000000000018-0x000000000000001f]
CPU: 1 UID: 0 PID: 5967 Comm: syz.0.18 Not tainted syzkaller #0 PREEMPT(full) 
Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS 1.16.2-debian-1.16.2-1 04/01/2014
RIP: 0010:test_bloom_filter mm/vmscan.c:2785 [inline]
RIP: 0010:lru_gen_look_around+0x45c/0xd20 mm/vmscan.c:4206
Code: 22 be ff 48 c7 44 24 48 00 00 00 00 48 83 c3 28 48 89 dd 48 c1 ed 03 42 80 7c 25 00 00 74 08 48 89 df e8 97 b5 28 00 4c 8b 3b <41> 80 7c 24 03 00 74 0a bf 18 00 00 00 e8 82 b5 28 00 4c 8b 24 25
RSP: 0018:ffffc900046e5c90 EFLAGS: 00010246
RAX: 0000000000000000 RBX: ffffc900046e5e68 RCX: ffff8881100b1d00
RDX: 0000000000000000 RSI: 0000000000000000 RDI: 0000000000000000
RBP: 1ffff920008dcbcd R08: ffff88811008fcc3 R09: 1ffff11022011f98
R10: dffffc0000000000 R11: ffffed1022011f99 R12: dffffc0000000000
R13: 0000555585af4000 R14: ffffea0006a69fc0 R15: ffff888114457168
FS:  0000555585ad9500(0000) GS:ffff8882a9461000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 00007f4753817dac CR3: 00000001b9a5e000 CR4: 00000000000006f0
Call Trace:
 <TASK>
 folio_referenced_one+0x724/0x1360 mm/rmap.c:962
 rmap_walk_anon+0x5cb/0x7c0 mm/rmap.c:2973
 rmap_walk mm/rmap.c:3078 [inline]
 folio_referenced+0x3c0/0x5f0 mm/rmap.c:1081
 folio_check_references mm/vmscan.c:870 [inline]
 shrink_folio_list+0x1008/0x5240 mm/vmscan.c:1237
 evict_folios+0x3f82/0x5090 mm/vmscan.c:4853
 try_to_shrink_lruvec+0xb62/0xfa0 mm/vmscan.c:5008
 lru_gen_shrink_lruvec mm/vmscan.c:5157 [inline]
 shrink_lruvec+0x54e/0x2b30 mm/vmscan.c:5911
 shrink_node_memcgs mm/vmscan.c:6147 [inline]
 shrink_node+0xa41/0x3a90 mm/vmscan.c:6188
 shrink_zones mm/vmscan.c:6427 [inline]
 do_try_to_free_pages+0x6a2/0x1980 mm/vmscan.c:6489
 try_to_free_mem_cgroup_pages+0x2ff/0x870 mm/vmscan.c:6811
 try_charge_memcg+0x827/0x1560 mm/memcontrol.c:2642
 obj_cgroup_charge_pages mm/memcontrol.c:3084 [inline]
 __memcg_kmem_charge_page+0x32a/0x530 mm/memcontrol.c:3128
 __alloc_frozen_pages_noprof+0x1c1/0x380 mm/page_alloc.c:5271
 __alloc_pages_noprof mm/page_alloc.c:5288 [inline]
 alloc_pages_bulk_noprof+0x569/0x710 mm/page_alloc.c:5208
 alloc_pages_bulk_mempolicy_noprof+0x34e/0x1680 mm/mempolicy.c:2792
 vm_area_alloc_pages mm/vmalloc.c:3700 [inline]
 __vmalloc_area_node mm/vmalloc.c:3875 [inline]
 __vmalloc_node_range_noprof+0xbd9/0x1a80 mm/vmalloc.c:4058
 __bpf_map_area_alloc kernel/bpf/syscall.c:404 [inline]
 bpf_map_area_alloc+0x12d/0x170 kernel/bpf/syscall.c:411
 bloom_map_alloc+0x22f/0x470 kernel/bpf/bloom_filter.c:146
 map_create+0xafd/0x16a0 kernel/bpf/syscall.c:1507
 __sys_bpf+0x6e1/0x950 kernel/bpf/syscall.c:6210
 __do_sys_bpf kernel/bpf/syscall.c:6341 [inline]
 __se_sys_bpf kernel/bpf/syscall.c:6339 [inline]
 __x64_sys_bpf+0x7c/0x90 kernel/bpf/syscall.c:6339
 do_syscall_x64 arch/x86/entry/syscall_64.c:63 [inline]
 do_syscall_64+0x14d/0xf80 arch/x86/entry/syscall_64.c:94
 entry_SYSCALL_64_after_hwframe+0x77/0x7f
RIP: 0033:0x7f475359c799
Code: ff c3 66 2e 0f 1f 84 00 00 00 00 00 0f 1f 44 00 00 48 89 f8 48 89 f7 48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 ff ff 73 01 c3 48 c7 c1 e8 ff ff ff f7 d8 64 89 01 48
RSP: 002b:00007fff2e480d98 EFLAGS: 00000246 ORIG_RAX: 0000000000000141
RAX: ffffffffffffffda RBX: 00007f4753815fa0 RCX: 00007f475359c799
RDX: 0000000000000050 RSI: 0000200000000dc0 RDI: 0000000000000000
RBP: 00007f4753632bd9 R08: 0000000000000000 R09: 0000000000000000
R10: 0000000000000000 R11: 0000000000000246 R12: 0000000000000000
R13: 00007f4753815fac R14: 00007f4753815fa0 R15: 00007f4753815fa0
 </TASK>
Modules linked in:
---[ end trace 0000000000000000 ]---
RIP: 0010:test_bloom_filter mm/vmscan.c:2785 [inline]
RIP: 0010:lru_gen_look_around+0x45c/0xd20 mm/vmscan.c:4206
Code: 22 be ff 48 c7 44 24 48 00 00 00 00 48 83 c3 28 48 89 dd 48 c1 ed 03 42 80 7c 25 00 00 74 08 48 89 df e8 97 b5 28 00 4c 8b 3b <41> 80 7c 24 03 00 74 0a bf 18 00 00 00 e8 82 b5 28 00 4c 8b 24 25
RSP: 0018:ffffc900046e5c90 EFLAGS: 00010246
RAX: 0000000000000000 RBX: ffffc900046e5e68 RCX: ffff8881100b1d00
RDX: 0000000000000000 RSI: 0000000000000000 RDI: 0000000000000000
RBP: 1ffff920008dcbcd R08: ffff88811008fcc3 R09: 1ffff11022011f98
R10: dffffc0000000000 R11: ffffed1022011f99 R12: dffffc0000000000
R13: 0000555585af4000 R14: ffffea0006a69fc0 R15: ffff888114457168
FS:  0000555585ad9500(0000) GS:ffff8882a9461000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 00007f4753817dac CR3: 00000001b9a5e000 CR4: 00000000000006f0
----------------
Code disassembly (best guess):
   0:	22 be ff 48 c7 44    	and    0x44c748ff(%rsi),%bh
   6:	24 48                	and    $0x48,%al
   8:	00 00                	add    %al,(%rax)
   a:	00 00                	add    %al,(%rax)
   c:	48 83 c3 28          	add    $0x28,%rbx
  10:	48 89 dd             	mov    %rbx,%rbp
  13:	48 c1 ed 03          	shr    $0x3,%rbp
  17:	42 80 7c 25 00 00    	cmpb   $0x0,0x0(%rbp,%r12,1)
  1d:	74 08                	je     0x27
  1f:	48 89 df             	mov    %rbx,%rdi
  22:	e8 97 b5 28 00       	call   0x28b5be
  27:	4c 8b 3b             	mov    (%rbx),%r15
* 2a:	41 80 7c 24 03 00    	cmpb   $0x0,0x3(%r12) <-- trapping instruction
  30:	74 0a                	je     0x3c
  32:	bf 18 00 00 00       	mov    $0x18,%edi
  37:	e8 82 b5 28 00       	call   0x28b5be
  3c:	4c                   	rex.WR
  3d:	8b                   	.byte 0x8b
  3e:	24 25                	and    $0x25,%al


***

If these findings have caused you to resend the series or submit a
separate fix, please add the following tag to your commit message:
  Tested-by: syzbot@syzkaller.appspotmail.com

---
This report is generated by a bot. It may contain errors.
syzbot ci engineers can be reached at syzkaller@googlegroups.com.
