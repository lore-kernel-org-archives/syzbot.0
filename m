Received: from mail-oi1-f197.google.com (mail-oi1-f197.google.com [209.85.167.197])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F1A1740D588
	for <syzbot@lists.linux.dev>; Fri,  7 Aug 2026 05:26:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.167.197
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786080374; cv=none; b=o7uH+npB0iORWUwJexvFb81nC2SWOdS3JH2hyLgqzyZMjxGwbkuuxi4VNQ4MeSugjY9RwWc7Spu/YldwMrm1JRnCg1b7NONlYGvfltfmXRh/X/QZGGLzPmiolWJJJYF/L2Q3Nx7kFhirZ8sp7p+VJe+9hziU1T0+bwBTq8ZZyCY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786080374; c=relaxed/simple;
	bh=XoAKRdAJIJ9Bz8/wlI6yz3LVQ9NQvOp4X8SzO7nxy1g=;
	h=MIME-Version:Date:In-Reply-To:Message-ID:Subject:From:To:Cc:
	 Content-Type; b=d3PB0gSIQxz90A8g4Ias0JJ1AVEVRdQ1XkRG4gS5NMsnVI8L2qekOcZFneIIVEML9uplnstMhQhR1d6xLuFgVtDYVgdf9k/ZL+k7HN3O6FmsEqWF3EicPRdHUG5wds7wNO/Bw2nHXDAn7PsadUmvcgm5SSofzkbQtCJZTj5woDs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com; arc=none smtp.client-ip=209.85.167.197
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com
Received: by mail-oi1-f197.google.com with SMTP id 5614622812f47-4a416619e8dso2181243b6e.1
        for <syzbot@lists.linux.dev>; Thu, 06 Aug 2026 22:26:10 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1786080369; x=1786685169;
        h=content-type:cc:to:from:subject:message-id:in-reply-to:date
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to:content-type;
        bh=T3m0nal8RAOlIDKOwy4iei8tz0r4SQ1BHd4+5WMc7ws=;
        b=pKcPkd8KUKTazejMbDDH0y1qHJQypc8kDqO34XKjSvFyETWpY00wbKvS/CpzUew7o6
         IQV2t8gFTLliCYpP0ntFfofpk4sst6t1kd+oizWfa0Hn4geO3A1kPeH0N0QuHQUw2tTp
         ovdghXHTdkXJOaVqU15zlyM5WgPcXwSUB5jPEdDm9Rt6mWy91jXKnSGq3DiVEwaK15+c
         ejjtWEfoc+xv5dlVwQPwK0a7w35fgPkEb0t/5CR+E+A59oxg3Gw6jXyL7dvIoS9p774L
         SsHTEAtT3szPQwOF5o8MLMBWTncANKnp14dXJLdBtlcZHWsZ+7NarVZQiTl6IE43d76q
         S6Hw==
X-Gm-Message-State: AOJu0Yw0tQZOArLqfAwylcjiEsCMpCH6JjqMIvgFW9/srlxphSwS6avF
	ZFmZoECbeI52aKxow+DWu4YBC9rx8XemrW5lk0RSHkOmF5x/h3RZcUGgq3/OiOu+p6ofY74uTR6
	iEKWIAUb67d4103ylmzcUYL3x5gKOvmHIgqOg9UQE5Ra5SewYpvEsGaAHevk=
Precedence: bulk
X-Mailing-List: syzbot@lists.linux.dev
List-Id: <syzbot.lists.linux.dev>
List-Subscribe: <mailto:syzbot+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:syzbot+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Received: by 2002:a05:6808:169f:b0:485:7c46:b866 with SMTP id
 5614622812f47-4afc513e9b0mr6403807b6e.16.1786080369495; Thu, 06 Aug 2026
 22:26:09 -0700 (PDT)
Date: Thu, 06 Aug 2026 22:26:09 -0700
In-Reply-To: <20260806184254.3790858-1-nphamcs@gmail.com>
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <6a756c71.01d0871a.3a0d52.003a.GAE@google.com>
Subject: [syzbot ci] Re: Virtual Swap Space (Swap Table Edition)
From: syzbot ci <syzbot+cif942a042aaa8793c@syzkaller.appspotmail.com>
To: akpm@linux-foundation.org, axelrasmussen@google.com, baohua@kernel.org, 
	baoquan.he@linux.dev, cgroups@vger.kernel.org, chengming.zhou@linux.dev, 
	chrisl@kernel.org, corbet@lwn.net, david@kernel.org, gourry@gourry.net, 
	hannes@cmpxchg.org, haowenchao22@gmail.com, kasong@tencent.com, 
	kernel-team@meta.com, liam@infradead.org, linux-doc@vger.kernel.org, 
	linux-kernel@vger.kernel.org, linux-mm@kvack.org, ljs@kernel.org, 
	mhocko@kernel.org, muchun.song@linux.dev, nphamcs@gmail.com, 
	qi.zheng@linux.dev, riel@surriel.com, roman.gushchin@linux.dev, 
	rppt@kernel.org, shakeel.butt@linux.dev, shikemeng@huaweicloud.com, 
	surenb@google.com, vbabka@kernel.org, weixugc@google.com, yosry@kernel.org, 
	youngjun.park@lge.com, yuanchu@google.com
Cc: syzbot@lists.linux.dev, syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"

syzbot ci has tested the following series

[v3] Virtual Swap Space (Swap Table Edition)
https://lore.kernel.org/all/20260806184254.3790858-1-nphamcs@gmail.com
* [PATCH v3 01/11] mm, swap: add virtual swap device infrastructure
* [PATCH v3 02/11] mm, swap: support zswap and zeroswap as vswap backends
* [PATCH v3 03/11] mm, swap: prepare the swap IO path for vswap
* [PATCH v3 04/11] mm, swap: support physical swap as a vswap backend
* [PATCH v3 05/11] mm, swap: enable THP swapin for vswap entries
* [PATCH v3 06/11] mm, swap: write back vswap zswap entries to physical swap
* [PATCH v3 07/11] mm, swap: reclaim physical slots backing cache-only vswap entries
* [PATCH v3 08/11] mm, swap: only charge physical swap entries
* [PATCH v3 09/11] mm, swap: add debugfs counters for vswap
* [PATCH v3 10/11] mm, swap: defer memcg_table allocation for physical swap clusters
* [PATCH v3 11/11] mm, swap: widen swap_info_struct max/pages to unsigned long

and found the following issue:
KASAN: null-ptr-deref Read in swap_entry_backend_has_flag

Full report is available here:
https://ci.syzbot.org/series/e7da1097-3230-4e50-80cb-1dfafeebea40

***

KASAN: null-ptr-deref Read in swap_entry_backend_has_flag

tree:      linux-next
URL:       https://kernel.googlesource.com/pub/scm/linux/kernel/git/next/linux-next
base:      bacc32cc7de65ffff70080a48eb294f89e434d5e
arch:      amd64
compiler:  Debian clang version 22.1.8 (++20260613092233+e80beda6e255-1~exp1~20260613092250.77), Debian LLD 22.1.8
config:    https://ci.syzbot.org/builds/4f943657-9481-4637-9b1f-9be1bff18f92/config
syz repro: https://ci.syzbot.org/findings/f6c4f1ab-951c-4759-b397-e22c23c3bf32/syz_repro

==================================================================
BUG: KASAN: null-ptr-deref in instrument_atomic_read include/linux/instrumented.h:82 [inline]
BUG: KASAN: null-ptr-deref in atomic_long_read include/linux/atomic/atomic-instrumented.h:3188 [inline]
BUG: KASAN: null-ptr-deref in __vtable_get mm/vswap.h:147 [inline]
BUG: KASAN: null-ptr-deref in vswap_to_phys mm/vswap.h:197 [inline]
BUG: KASAN: null-ptr-deref in swap_entry_backend_has_flag+0xfe/0x220 mm/vswap.h:441
Read of size 8 at addr 0000000000000000 by task syz.2.20/5818

CPU: 1 UID: 0 PID: 5818 Comm: syz.2.20 Not tainted syzkaller #0 PREEMPT(full) 
Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS 1.16.2-debian-1.16.2-1 04/01/2014
Call Trace:
 <TASK>
 dump_stack_lvl+0xe8/0x150 lib/dump_stack.c:120
 kasan_report+0x117/0x150 mm/kasan/report.c:595
 check_region_inline mm/kasan/generic.c:-1 [inline]
 kasan_check_range+0x264/0x2c0 mm/kasan/generic.c:200
 instrument_atomic_read include/linux/instrumented.h:82 [inline]
 atomic_long_read include/linux/atomic/atomic-instrumented.h:3188 [inline]
 __vtable_get mm/vswap.h:147 [inline]
 vswap_to_phys mm/vswap.h:197 [inline]
 swap_entry_backend_has_flag+0xfe/0x220 mm/vswap.h:441
 do_swap_page+0x3c0/0x5620 mm/memory.c:4975
 __collapse_huge_page_swapin mm/khugepaged.c:1202 [inline]
 collapse_huge_page mm/khugepaged.c:1325 [inline]
 mthp_collapse mm/khugepaged.c:1524 [inline]
 collapse_scan_pmd mm/khugepaged.c:1786 [inline]
 collapse_single_pmd+0x24c6/0x3da0 mm/khugepaged.c:2803
 madvise_collapse+0x2cf/0x790 mm/khugepaged.c:3237
 madvise_vma_behavior+0x115f/0x4170 mm/madvise.c:1363
 madvise_walk_vmas+0x576/0xb00 mm/madvise.c:1712
 madvise_do_behavior+0x385/0x540 mm/madvise.c:1907
 do_madvise+0x327/0x3a0 mm/madvise.c:2005
 __do_sys_madvise mm/madvise.c:2014 [inline]
 __se_sys_madvise mm/madvise.c:2012 [inline]
 __x64_sys_madvise+0xa6/0xc0 mm/madvise.c:2012
 do_syscall_x64 arch/x86/entry/syscall_64.c:63 [inline]
 do_syscall_64+0x174/0x580 arch/x86/entry/syscall_64.c:94
 entry_SYSCALL_64_after_hwframe+0x77/0x7f
RIP: 0033:0x7fbcad79e019
Code: ff c3 66 2e 0f 1f 84 00 00 00 00 00 0f 1f 44 00 00 48 89 f8 48 89 f7 48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 ff ff 73 01 c3 48 c7 c1 e8 ff ff ff f7 d8 64 89 01 48
RSP: 002b:00007fbcae5c4028 EFLAGS: 00000246 ORIG_RAX: 000000000000001c
RAX: ffffffffffffffda RBX: 00007fbcada25fa0 RCX: 00007fbcad79e019
RDX: 0000000000000019 RSI: 0000000000c00000 RDI: 0000200000000000
RBP: 00007fbcad83500c R08: 0000000000000000 R09: 0000000000000000
R10: 0000000000000000 R11: 0000000000000246 R12: 0000000000000000
R13: 00007fbcada26038 R14: 00007fbcada25fa0 R15: 00007fff095fa0b8
 </TASK>
==================================================================


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
