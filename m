Received: from mail-oo1-f71.google.com (mail-oo1-f71.google.com [209.85.161.71])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0B8B03090C9
	for <syzbot@lists.linux.dev>; Sun, 25 Jan 2026 22:13:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.161.71
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769379223; cv=none; b=tm1av/IAZngVsAgwsIdJKdrhHGixeXNcL4G9CDxJRypUWq3M9dDCLbjPDdUgnA3qfqi/PJwboeCIO+cuFoEEOf0UtaPAopqQjZcNuu9bmMmJsN6EJDJoE1s4BxctrDeoI45LTCbd+JtRk12UkNNGbDSEPkz7REa8FCbUxTtBlZY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769379223; c=relaxed/simple;
	bh=C1FUxguK8eNbUKdAheciOskAfG05fLHGZq2eSVc71EQ=;
	h=MIME-Version:Date:In-Reply-To:Message-ID:Subject:From:To:Cc:
	 Content-Type; b=OBmUiKT+03wSDpOhAj9lUoxITidD1KZXUa1GaUQz8qzaGxqQFmIZDWTynwITBgeqTpfcIqxIey1Z28dR95mb8SEs8EV6Qg5S7fbasqjjUaK8avdxxoTslAf+Ku4ORE3KpwqhIPZewHkOonSAsRXIeoFoyUcmhTA9mKzzSQ00Ax4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com; arc=none smtp.client-ip=209.85.161.71
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com
Received: by mail-oo1-f71.google.com with SMTP id 006d021491bc7-662c684079eso10707724eaf.0
        for <syzbot@lists.linux.dev>; Sun, 25 Jan 2026 14:13:41 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1769379221; x=1769984021;
        h=cc:to:from:subject:message-id:in-reply-to:date:mime-version
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=xOMyMvanPWrG/uyGbh4XWJfw53pUCHbeHroFlQYIS5g=;
        b=HAgXwQW+o1LAmdG2KxywRtlWwBslTl2D/lZr4YVimUjhdz+EfsZot/aGu2Vm3wdwF9
         GkIQBgkTYVlcdmTri2snQcdOhW6oys66GABZSeixJ2SYcVX8sehd+3rZv/660aacr6z8
         QPn+dBoHYJlGWKKSkoQO4EushobUptltDEd4AiVinoB0AJirLX9MUDifrSCUrPMRttD1
         Z+69LzYCfxitAGkz4BVT1Y2FKpctiSPv+wQ0LyALWCMBWG+uryTwkwRRIuKlHWyEONH1
         8G9iQubrodvklEu3yxo+FtqVjQps0cYOflclxvTifA5dqEGMgaYLBJhsar8BglCElL/y
         t6fA==
X-Gm-Message-State: AOJu0YykQfZfvBbi7q/W5ZL0faHh8MWsNEkKrM76GEv/uUHDsyA9yE+6
	4RrEdQZcPlFQx5VEtaVm2sjmkzoe5hjbO3rwCF03NX+ocj++kjSyvzzmhpiyBfgil3Ae2xMqQ8q
	37sWCxtIuwwsmpnCIkFsgex0Vm/oBAx3TKCaTV8sGldUtBbkF0zgx40lKBKQ=
Precedence: bulk
X-Mailing-List: syzbot@lists.linux.dev
List-Id: <syzbot.lists.linux.dev>
List-Subscribe: <mailto:syzbot+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:syzbot+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Received: by 2002:a05:6820:2d08:b0:65d:5e1:ed1f with SMTP id
 006d021491bc7-662e03dc6ffmr1484692eaf.29.1769379221084; Sun, 25 Jan 2026
 14:13:41 -0800 (PST)
Date: Sun, 25 Jan 2026 14:13:41 -0800
In-Reply-To: <20260126-swap-table-p3-v1-0-a74155fab9b0@tencent.com>
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <69769595.a00a0220.33ccc7.002b.GAE@google.com>
Subject: [syzbot ci] Re: mm, swap: swap table phase III: remove swap_map
From: syzbot ci <syzbot+cie25b4769e5d96875@syzkaller.appspotmail.com>
To: akpm@linux-foundation.org, baohua@kernel.org, bhe@redhat.com, 
	chrisl@kernel.org, david@kernel.org, hannes@cmpxchg.org, kasong@tencent.com, 
	linux-kernel@vger.kernel.org, linux-mm@kvack.org, lorenzo.stoakes@oracle.com, 
	nphamcs@gmail.com, ryncsn@gmail.com, shikemeng@huaweicloud.com
Cc: syzbot@lists.linux.dev, syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"

syzbot ci has tested the following series

[v1] mm, swap: swap table phase III: remove swap_map
https://lore.kernel.org/all/20260126-swap-table-p3-v1-0-a74155fab9b0@tencent.com
* [PATCH 01/12] mm, swap: protect si->swap_file properly and use as a mount indicator
* [PATCH 02/12] mm, swap: clean up swapon process and locking
* [PATCH 03/12] mm, swap: remove redundant arguments and locking for enabling a device
* [PATCH 04/12] mm, swap: consolidate bad slots setup and make it more robust
* [PATCH 05/12] mm/workingset: leave highest bits empty for anon shadow
* [PATCH 06/12] mm, swap: implement helpers for reserving data in the swap table
* [PATCH 07/12] mm, swap: mark bad slots in swap table directly
* [PATCH 08/12] mm, swap: simplify swap table sanity range check
* [PATCH 09/12] mm, swap: use the swap table to track the swap count
* [PATCH 10/12] mm, swap: no need to truncate the scan border
* [PATCH 11/12] mm, swap: simplify checking if a folio is swapped
* [PATCH 12/12] mm, swap: no need to clear the shadow explicitly

and found the following issue:
WARNING in swap_cluster_lock

Full report is available here:
https://ci.syzbot.org/series/3f6169fc-e24a-4a19-ba56-e5907b448edc

***

WARNING in swap_cluster_lock

tree:      mm-new
URL:       https://kernel.googlesource.com/pub/scm/linux/kernel/git/akpm/mm.git
base:      5a3704ed2dce0b54a7f038b765bb752b87ee8cc2
arch:      amd64
compiler:  Debian clang version 21.1.8 (++20251221033036+2078da43e25a-1~exp1~20251221153213.50), Debian LLD 21.1.8
config:    https://ci.syzbot.org/builds/0eabd97a-86d8-4606-9d94-dbe4e7fd7c07/config
C repro:   https://ci.syzbot.org/findings/5b039fd0-70da-4954-817d-8bf86315c684/c_repro
syz repro: https://ci.syzbot.org/findings/5b039fd0-70da-4954-817d-8bf86315c684/syz_repro

------------[ cut here ]------------
offset >= si->max
WARNING: mm/swap.h:88 at __swap_offset_to_cluster mm/swap.h:88 [inline], CPU#1: syz.0.548/6508
WARNING: mm/swap.h:88 at __swap_cluster_lock mm/swap.h:101 [inline], CPU#1: syz.0.548/6508
WARNING: mm/swap.h:88 at swap_cluster_lock+0xef/0x130 mm/swap.h:132, CPU#1: syz.0.548/6508
Modules linked in:
CPU: 1 UID: 0 PID: 6508 Comm: syz.0.548 Not tainted syzkaller #0 PREEMPT(full) 
Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS 1.16.2-debian-1.16.2-1 04/01/2014
RIP: 0010:__swap_offset_to_cluster mm/swap.h:88 [inline]
RIP: 0010:__swap_cluster_lock mm/swap.h:101 [inline]
RIP: 0010:swap_cluster_lock+0xef/0x130 mm/swap.h:132
Code: e8 86 3b 5a 09 4c 89 f8 5b 41 5c 41 5e 41 5f 5d e9 86 86 5a 09 cc e8 90 ff a0 ff 90 0f 0b 90 e9 3f ff ff ff e8 82 ff a0 ff 90 <0f> 0b 90 e9 6f ff ff ff e8 74 ff a0 ff 90 0f 0b 90 eb a4 e8 69 ff
RSP: 0018:ffffc90004ae66c0 EFLAGS: 00010293
RAX: ffffffff82219a6e RBX: 0000000000007a12 RCX: ffff888110363a80
RDX: 0000000000000000 RSI: 0000000000007a12 RDI: 0000000000007a12
RBP: 0000000000007a12 R08: 0000000000000003 R09: 0000000000000004
R10: dffffc0000000000 R11: fffff5200095cccc R12: dffffc0000000000
R13: ffff888175c2a010 R14: ffff888175c2a000 R15: 0000000000007a12
FS:  000055556978b500(0000) GS:ffff8882a9923000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 00007fca0a017dac CR3: 0000000112e64000 CR4: 00000000000006f0
Call Trace:
 <TASK>
 cluster_alloc_swap_entry+0x20f/0xa40 mm/swapfile.c:1090
 swap_alloc_slow mm/swapfile.c:1385 [inline]
 folio_alloc_swap+0x81f/0x1190 mm/swapfile.c:1717
 shrink_folio_list+0x2714/0x52b0 mm/vmscan.c:1306
 reclaim_folio_list+0x100/0x4f0 mm/vmscan.c:2205
 reclaim_pages+0x45b/0x530 mm/vmscan.c:2242
 madvise_cold_or_pageout_pte_range+0x19b9/0x1d00 mm/madvise.c:561
 walk_pmd_range mm/pagewalk.c:130 [inline]
 walk_pud_range mm/pagewalk.c:224 [inline]
 walk_p4d_range mm/pagewalk.c:262 [inline]
 walk_pgd_range+0x1032/0x1d30 mm/pagewalk.c:303
 __walk_page_range+0x14c/0x710 mm/pagewalk.c:411
 walk_page_range_vma_unsafe+0x309/0x410 mm/pagewalk.c:715
 madvise_pageout_page_range mm/madvise.c:620 [inline]
 madvise_pageout mm/madvise.c:645 [inline]
 madvise_vma_behavior+0x382e/0x4240 mm/madvise.c:1364
 madvise_walk_vmas+0x573/0xae0 mm/madvise.c:1719
 madvise_do_behavior+0x386/0x540 mm/madvise.c:1935
 do_madvise+0x1fa/0x2e0 mm/madvise.c:2028
 __do_sys_madvise mm/madvise.c:2037 [inline]
 __se_sys_madvise mm/madvise.c:2035 [inline]
 __x64_sys_madvise+0xa6/0xc0 mm/madvise.c:2035
 do_syscall_x64 arch/x86/entry/syscall_64.c:63 [inline]
 do_syscall_64+0xe2/0xf80 arch/x86/entry/syscall_64.c:94
 entry_SYSCALL_64_after_hwframe+0x77/0x7f
RIP: 0033:0x7fca09d9acb9
Code: ff c3 66 2e 0f 1f 84 00 00 00 00 00 0f 1f 44 00 00 48 89 f8 48 89 f7 48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 ff ff 73 01 c3 48 c7 c1 e8 ff ff ff f7 d8 64 89 01 48
RSP: 002b:00007ffe78abed08 EFLAGS: 00000246 ORIG_RAX: 000000000000001c
RAX: ffffffffffffffda RBX: 00007fca0a015fa0 RCX: 00007fca09d9acb9
RDX: 0000000000000015 RSI: 0000000000600003 RDI: 0000200000000000
RBP: 00007fca09e08bf7 R08: 0000000000000000 R09: 0000000000000000
R10: 0000000000000000 R11: 0000000000000246 R12: 0000000000000000
R13: 00007fca0a015fac R14: 00007fca0a015fa0 R15: 00007fca0a015fa0
 </TASK>


***

If these findings have caused you to resend the series or submit a
separate fix, please add the following tag to your commit message:
  Tested-by: syzbot@syzkaller.appspotmail.com

---
This report is generated by a bot. It may contain errors.
syzbot ci engineers can be reached at syzkaller@googlegroups.com.
