Received: from mail-ot1-f71.google.com (mail-ot1-f71.google.com [209.85.210.71])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BD9261A304A
	for <syzbot@lists.linux.dev>; Fri, 10 Apr 2026 06:45:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.71
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1775803546; cv=none; b=AKBGrv4H3wRnDnGWpJpnVta7+4/svR2+kaUcLIRaU7uxf69ve1aMqFbIdue4DAYrwoQQpuaXREKr6Sx4JIkgHbE1SJBOU5yoiMixTX73fRoksWSU25jeZmZHZ7tj66/4cUoMsbYiMG4Czg4ftXenh7MEHqaS4Y9JCh0mEiUOo5o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1775803546; c=relaxed/simple;
	bh=wT/zuKyWGx55grcFtGlGEt7NKeMDUfV29184QXpL3VE=;
	h=MIME-Version:Date:In-Reply-To:Message-ID:Subject:From:To:Cc:
	 Content-Type; b=q6DkZX7xbsZL/zhUlovgEAIx+bzAb7TamcHNuhEb7H6ziwbexFcVPy4YsiWjJ7cxmkhU61imf5dN6P/vVmiQkonbEOMyCQ6dW1QtDpnm5KdDq3r04RbHL9LMGxACQ+U4G6sTLzP7Qhv5DrT7HDLMruoSgidXne1u+wiwub6Rb5U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com; arc=none smtp.client-ip=209.85.210.71
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com
Received: by mail-ot1-f71.google.com with SMTP id 46e09a7af769-7dbb4f8b314so3096791a34.3
        for <syzbot@lists.linux.dev>; Thu, 09 Apr 2026 23:45:44 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1775803544; x=1776408344;
        h=cc:to:from:subject:message-id:in-reply-to:date:mime-version
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=qA3Bgec08hHe18kFcoPSxtNLaAedK6oXug7a4v0vhyU=;
        b=akWdAdT9BVVE31F6w0PgsrzTfyqEW4/aPIE2nO7VKN+g11ML83FmxzuRpfMKlN8hTp
         cGFq82nHprk4g5u5VCTwnGnFNX1jvm5ikCK9n12HtbVVCYTFgag0/UVx+HChBjJjyvrb
         ju400I1+feizqmxgLaRh6jHZVWl4is7GtHmgGjY6jt66TaJQk8vwKRwFO+BYqa1t3OtZ
         qLDEWLiUBzKYClMKx4YA+IWI7zchdSnWNiajshlhf//N+DuiOBnAmHLJDNbvUIBUS3AB
         rEuAtMA9PZpyrJYDhJd6XCJDuZ8hvyD2cQCP899QGItaEPIRa5IP/McPkaXGRYpUWrte
         Qzdg==
X-Gm-Message-State: AOJu0Yz5wEF7DIJ/fYfqUkYMNYzMI1HGMQmdixrhYYwQwI8rwFODvIzv
	uWg7zrWsjvBnlg0HY8gxVSd71ojjpz9ceBUWCxqY4CRjouOUhWPWhvIlb55XIdGHftQwQsAU6yv
	xTCknPoThkf1DxZdRNhPMl1hGBGY1wkN3iNmKX3P4tNc8fHw+4UiHfi+6jHs=
Precedence: bulk
X-Mailing-List: syzbot@lists.linux.dev
List-Id: <syzbot.lists.linux.dev>
List-Subscribe: <mailto:syzbot+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:syzbot+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Received: by 2002:a05:6820:2015:b0:682:52b9:e779 with SMTP id
 006d021491bc7-68be90cdf17mr1051890eaf.64.1775803543859; Thu, 09 Apr 2026
 23:45:43 -0700 (PDT)
Date: Thu, 09 Apr 2026 23:45:43 -0700
In-Reply-To: <20260409234158.837786-1-jane.chu@oracle.com>
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <69d89c97.050a0220.3030df.0026.GAE@google.com>
Subject: [syzbot ci] Re: hugetlb: normalize exported interfaces to use
 base-page indices
From: syzbot ci <syzbot+ci1ddebc06ab8137f5@syzkaller.appspotmail.com>
To: akpm@linux-foundation.org, baolin.wang@linux.alibaba.com, corbet@lwn.net, 
	david@kernel.org, hughd@google.com, jane.chu@oracle.com, 
	liam.howlett@oracle.com, linux-doc@vger.kernel.org, 
	linux-kernel@vger.kernel.org, linux-mm@kvack.org, lorenzo.stoakes@oracle.com, 
	mhocko@suse.com, muchun.song@linux.dev, osalvador@suse.de, peterx@redhat.com, 
	rppt@kernel.org, skhan@linuxfoundation.org, surenb@google.com, 
	vbabka@kernel.org
Cc: syzbot@lists.linux.dev, syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"

syzbot ci has tested the following series

[v1] hugetlb: normalize exported interfaces to use base-page indices
https://lore.kernel.org/all/20260409234158.837786-1-jane.chu@oracle.com
* [PATCH 1/6] hugetlb: open-code hugetlb folio lookup index conversion
* [PATCH 2/6] hugetlb: remove the hugetlb_linear_page_index() helper
* [PATCH 3/6] hugetlb: make hugetlb_fault_mutex_hash() take PAGE_SIZE index
* [PATCH 4/6] hugetlb: drop vma_hugecache_offset() in favor of linear_page_index()
* [PATCH 5/6] hugetlb: make hugetlb_add_to_page_cache() use PAGE_SIZE-based index
* [PATCH 6/6] hugetlb: pass hugetlb reservation ranges in base-page indices

and found the following issue:
WARNING: bad unlock balance in hugetlb_no_page

Full report is available here:
https://ci.syzbot.org/series/95c5ba82-0135-4026-b7c7-b0819e1ca4d6

***

WARNING: bad unlock balance in hugetlb_no_page

tree:      mm-new
URL:       https://kernel.googlesource.com/pub/scm/linux/kernel/git/akpm/mm.git
base:      06a6cfb92448a97ef429a7fbd395a20a9d388acc
arch:      amd64
compiler:  Debian clang version 21.1.8 (++20251221033036+2078da43e25a-1~exp1~20251221153213.50), Debian LLD 21.1.8
config:    https://ci.syzbot.org/builds/cefe8576-3c99-42d3-9b51-1e70d62a64a7/config
syz repro: https://ci.syzbot.org/findings/3a14cc12-14a8-4fac-9614-ae7ae2555e58/syz_repro

=====================================
WARNING: bad unlock balance detected!
syzkaller #0 Not tainted
-------------------------------------
syz.0.17/5971 is trying to release lock (&hugetlb_fault_mutex_table[i]) at:
[<ffffffff8229b876>] hugetlb_handle_userfault mm/hugetlb.c:5686 [inline]
[<ffffffff8229b876>] hugetlb_no_page+0x1986/0x1da0 mm/hugetlb.c:5770
but there are no more locks to release!

other info that might help us debug this:
2 locks held by syz.0.17/5971:
 #0: ffff88816b85fb88 (vm_lock){++++}-{0:0}, at: lock_vma_under_rcu+0x1d1/0x500 mm/mmap_lock.c:310
 #1: ffff88816079e338 (&hugetlb_fault_mutex_table[i]){+.+.}-{4:4}, at: hugetlb_fault+0x317/0x1440 mm/hugetlb.c:5991

stack backtrace:
CPU: 0 UID: 0 PID: 5971 Comm: syz.0.17 Not tainted syzkaller #0 PREEMPT(full) 
Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS 1.16.2-debian-1.16.2-1 04/01/2014
Call Trace:
 <TASK>
 dump_stack_lvl+0xe8/0x150 lib/dump_stack.c:120
 print_unlock_imbalance_bug+0xdc/0xf0 kernel/locking/lockdep.c:5298
 __lock_release kernel/locking/lockdep.c:5537 [inline]
 lock_release+0x248/0x3d0 kernel/locking/lockdep.c:5889
 __mutex_unlock_slowpath+0xd3/0x7d0 kernel/locking/mutex.c:938
 hugetlb_handle_userfault mm/hugetlb.c:5686 [inline]
 hugetlb_no_page+0x1986/0x1da0 mm/hugetlb.c:5770
 hugetlb_fault+0x67f/0x1440 mm/hugetlb.c:-1
 handle_mm_fault+0x2007/0x3170 mm/memory.c:6716
 do_user_addr_fault+0xa73/0x1340 arch/x86/mm/fault.c:1334
 handle_page_fault arch/x86/mm/fault.c:1474 [inline]
 exc_page_fault+0x6a/0xc0 arch/x86/mm/fault.c:1527
 asm_exc_page_fault+0x26/0x30 arch/x86/include/asm/idtentry.h:618
RIP: 0033:0x7fa742251964
Code: 41 89 00 31 c0 c3 b9 40 00 00 00 bf 40 00 00 00 eb bc 0f 1f 40 00 48 89 7c 24 f8 48 89 74 24 f0 48 8b 7c 24 f8 4c 8b 44 24 f0 <8b> 4f 50 8b 47 58 4c 01 c1 41 8b 34 00 8b 11 21 d6 89 f0 8d 72 01
RSP: 002b:00007fa7431fd018 EFLAGS: 00010212
RAX: 00007fa742251950 RBX: 00007fa742615fa0 RCX: 0000000000000000
RDX: 0000000000000000 RSI: 0000000000000000 RDI: 0000200000400000
RBP: 00007fa742432c91 R08: 0000000000000000 R09: 0000000000000000
R10: 0000200000400000 R11: 0000000000000000 R12: 0000000000000000
R13: 00007fa742616038 R14: 00007fa742615fa0 R15: 00007ffe952c6908
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
