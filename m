Received: from mail-oi1-f197.google.com (mail-oi1-f197.google.com [209.85.167.197])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F10763B38B1
	for <syzbot@lists.linux.dev>; Fri,  7 Aug 2026 02:11:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.167.197
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786068720; cv=none; b=gSLFfPbk0RjhDMX/xEGGiRLH1n2Ph188zQwT/4vnSnaXZL4fdEqYJGJj/F6Ksv/u2E8mASSFOgU9TyPf7ovRQLIB15v7CDN3NjGCQUs1Pl3QHszRdqcgV2Wy1feW1FYdPpykDZQ6wRSEma3ejC2wdjSKFdxXJiCELGqAvMzO7tE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786068720; c=relaxed/simple;
	bh=1WECoMc2EYSVL0Nko7rU+H00Qk5h2g9Z0mHjyCYBpls=;
	h=MIME-Version:Date:Message-ID:Subject:From:To:Cc:Content-Type; b=M0+9inA6tQYFaC6i68FNSrBnUG8ZUEdaXLcHLu8lbMGJ0L18ruP4o7uN5k+dfRchZ9/k6e6Ea1LUB8/yLo44I/DAtildLHwJPLqh/H3FIAelkrQjiCyTLMvHe79jZD6wWcNfrAEfL992p6cpZVKQW6nHv3/0/k+kkW8+SlCFLy4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com; arc=none smtp.client-ip=209.85.167.197
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com
Received: by mail-oi1-f197.google.com with SMTP id 5614622812f47-49d4cb3ca23so3075216b6e.3
        for <syzbot@lists.linux.dev>; Thu, 06 Aug 2026 19:11:58 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1786068718; x=1786673518;
        h=content-transfer-encoding:content-type:cc:to:from:subject
         :message-id:date:mime-version:x-gm-message-state:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=otPd1ksl6C+ICa+OU1DO6JCanDMc5AOJMCQ1T/zJV5U=;
        b=PofxknAi5Sv1vsnfRK+ucYJSCfLgY7yQQ0VVNHpjYg2YhjK0rx+q9EC0a4CHMdoXpg
         Ad5ofGseN13bJ5Mh6DFhTENEOOVVHTKsSx8WgKWGCf4FNylLzrilsXuwxsyNPaiOBYtJ
         sZCx2JgqbSsgwlUtBq6ZEZvwgNvK96jCytkmcqWgOqPumr6bM9EwFb6rnmH1t3AAZi2p
         hOHk0ZS/kU9arKiBf7n+zQ2HoNg4qdS0vR13K2ZQayIo2ZOr6tJcdUYe2clqoaThuhqb
         nW5JbgQhkWJTqtW6JZxJSvfkWxvzNfyAQFuMx3RyrH/1Maccg7pDR8vfhhz+I2bGP3lO
         YMRg==
X-Gm-Message-State: AOJu0YwrE2W8/8ngDOH/3fYSCMlqhunb8eIBCksCMYrq2tRy3IGom17y
	FqY4Ro8MBL7A91P/N5W1yQRRNpl+4TxryK2ULVG2eWcAnlxY5BdQtqbe8YX8c1vD9AbrSpQFpUV
	2LVL4Zj1PLTQESSon6h9jx8TV1ulYvYu4Ac6WPgzKX0YjN6u4U7IKnbrCHHI=
Precedence: bulk
X-Mailing-List: syzbot@lists.linux.dev
List-Id: <syzbot.lists.linux.dev>
List-Subscribe: <mailto:syzbot+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:syzbot+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Received: by 2002:a05:6808:1910:b0:495:f519:70f0 with SMTP id
 5614622812f47-4afae01bf6emr11339882b6e.19.1786068717905; Thu, 06 Aug 2026
 19:11:57 -0700 (PDT)
Date: Thu, 06 Aug 2026 19:11:57 -0700
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <6a753eed.01d0871a.3a0d52.0037.GAE@google.com>
Subject: [moderation/CI] Re: Virtual Swap Space (Swap Table Edition)
From: syzbot ci <syzbot+ci0044aa36144eea42@syzkaller.appspotmail.com>
To: syzkaller-upstream-moderation@googlegroups.com
Cc: syzbot@lists.linux.dev
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

syzbot ci has tested the following series

[v3] Virtual Swap Space (Swap Table Edition)
https://lore.kernel.org/all/20260806184254.3790858-1-nphamcs@gmail.com
* [PATCH v3 01/11] mm, swap: add virtual swap device infrastructure
* [PATCH v3 02/11] mm, swap: support zswap and zeroswap as vswap backends
* [PATCH v3 03/11] mm, swap: prepare the swap IO path for vswap
* [PATCH v3 04/11] mm, swap: support physical swap as a vswap backend
* [PATCH v3 05/11] mm, swap: enable THP swapin for vswap entries
* [PATCH v3 06/11] mm, swap: write back vswap zswap entries to physical swa=
p
* [PATCH v3 07/11] mm, swap: reclaim physical slots backing cache-only vswa=
p entries
* [PATCH v3 08/11] mm, swap: only charge physical swap entries
* [PATCH v3 09/11] mm, swap: add debugfs counters for vswap
* [PATCH v3 10/11] mm, swap: defer memcg_table allocation for physical swap=
 clusters
* [PATCH v3 11/11] mm, swap: widen swap_info_struct max/pages to unsigned l=
ong

and found the following issue:
KASAN: null-ptr-deref Read in swap_entry_backend_has_flag

Full report is available here:
https://ci.syzbot.org/series/e7da1097-3230-4e50-80cb-1dfafeebea40

***

KASAN: null-ptr-deref Read in swap_entry_backend_has_flag

tree:      linux-next
URL:       https://kernel.googlesource.com/pub/scm/linux/kernel/git/next/li=
nux-next
base:      bacc32cc7de65ffff70080a48eb294f89e434d5e
arch:      amd64
compiler:  Debian clang version 22.1.8 (++20260613092233+e80beda6e255-1~exp=
1~20260613092250.77), Debian LLD 22.1.8
config:    https://ci.syzbot.org/builds/4f943657-9481-4637-9b1f-9be1bff18f9=
2/config
syz repro: https://ci.syzbot.org/findings/f6c4f1ab-951c-4759-b397-e22c23c3b=
f32/syz_repro

=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
BUG: KASAN: null-ptr-deref in instrument_atomic_read include/linux/instrume=
nted.h:82 [inline]
BUG: KASAN: null-ptr-deref in atomic_long_read include/linux/atomic/atomic-=
instrumented.h:3188 [inline]
BUG: KASAN: null-ptr-deref in __vtable_get mm/vswap.h:147 [inline]
BUG: KASAN: null-ptr-deref in vswap_to_phys mm/vswap.h:197 [inline]
BUG: KASAN: null-ptr-deref in swap_entry_backend_has_flag+0xfe/0x220 mm/vsw=
ap.h:441
Read of size 8 at addr 0000000000000000 by task syz.2.20/5818

CPU: 1 UID: 0 PID: 5818 Comm: syz.2.20 Not tainted syzkaller #0 PREEMPT(ful=
l)=20
Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS 1.16.2-debian-1.16=
.2-1 04/01/2014
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
Code: ff c3 66 2e 0f 1f 84 00 00 00 00 00 0f 1f 44 00 00 48 89 f8 48 89 f7 =
48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 ff f=
f 73 01 c3 48 c7 c1 e8 ff ff ff f7 d8 64 89 01 48
RSP: 002b:00007fbcae5c4028 EFLAGS: 00000246 ORIG_RAX: 000000000000001c
RAX: ffffffffffffffda RBX: 00007fbcada25fa0 RCX: 00007fbcad79e019
RDX: 0000000000000019 RSI: 0000000000c00000 RDI: 0000200000000000
RBP: 00007fbcad83500c R08: 0000000000000000 R09: 0000000000000000
R10: 0000000000000000 R11: 0000000000000246 R12: 0000000000000000
R13: 00007fbcada26038 R14: 00007fbcada25fa0 R15: 00007fff095fa0b8
 </TASK>
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

To test a patch for this bug, please reply with `#syz test`
(should be on a separate line).

The patch should be attached to the email.
Note: arguments like custom git repos and branches are not supported.

The email will later be sent to:
[akpm@linux-foundation.org axelrasmussen@google.com baohua@kernel.org baoqu=
an.he@linux.dev cgroups@vger.kernel.org chengming.zhou@linux.dev chrisl@ker=
nel.org corbet@lwn.net david@kernel.org gourry@gourry.net hannes@cmpxchg.or=
g haowenchao22@gmail.com kasong@tencent.com kernel-team@meta.com liam@infra=
dead.org linux-doc@vger.kernel.org linux-kernel@vger.kernel.org linux-mm@kv=
ack.org ljs@kernel.org mhocko@kernel.org muchun.song@linux.dev nphamcs@gmai=
l.com qi.zheng@linux.dev riel@surriel.com roman.gushchin@linux.dev rppt@ker=
nel.org shakeel.butt@linux.dev shikemeng@huaweicloud.com surenb@google.com =
vbabka@kernel.org weixugc@google.com yosry@kernel.org youngjun.park@lge.com=
 yuanchu@google.com]

If the report looks fine to you, reply with:
#syz upstream

If the report is a false positive, reply with
#syz invalid

