Received: from mail-oo1-f71.google.com (mail-oo1-f71.google.com [209.85.161.71])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 69BC731E853
	for <syzbot@lists.linux.dev>; Fri, 10 Apr 2026 04:19:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.161.71
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1775794778; cv=none; b=hgZ4Zu4JfmvBAhXOcZLYLifwWtJC88+xWkbtw+OOzxZmMARr90hbqXJlLoIn+XLJfPeAKiiF3WKkaznXuX3xOvXJ3EBVNY1btAhJWjkVkiakd88gC1EXmq3ZfCPd7pYso72Ar5Dmk80R3DJiZMEpvYoYSLc1Cdo45bNRJt+gWbk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1775794778; c=relaxed/simple;
	bh=m8M1XrTkiYlllbZSHhzLf8P3DwoJvwDAT+9r0w5Q9AM=;
	h=MIME-Version:Date:Message-ID:Subject:From:To:Cc:Content-Type; b=qMjpLh7wkHnQ2S6tmryjwfzDTg7c7D2X2inBBCak3iObXG9s7fht5EGHgEiAORrRtUvbopN/kdMnWJyUxUik2gorfA3b0gCxmGwC5WkBuHMSY9b+G/Y/fyg/qG5hkV3HQRmWSdtFlOlx/2htJMGI6XOr/KQjely9OvWu+GhiQNQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com; arc=none smtp.client-ip=209.85.161.71
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com
Received: by mail-oo1-f71.google.com with SMTP id 006d021491bc7-679c51b2d6cso2631288eaf.2
        for <syzbot@lists.linux.dev>; Thu, 09 Apr 2026 21:19:37 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1775794776; x=1776399576;
        h=content-transfer-encoding:cc:to:from:subject:message-id:date
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=ZlSr7mXiaMFElFXdg+D0j7E84zVyg6ifGFfBC88Q7ZI=;
        b=bj51s3PPLFb2mpZUV86fiCx/OOHoFwIAlUp4kVAX7T0qAA24a643Cc44s9rbITNAtt
         HlikZxmvex0NoPpfeAb0ZLmwHwEWgxr/fMQRiunF3fhhaX16a3tUz/vjViNa2e2V2ZoQ
         K/SdpFI9hbrPslNq6aaohFALs8Pz28owbemHDL7IsvCrt7hD9YlQTyZh7fkCI7ZMpID4
         11I/zFS9Z2u8uvwgGmlQehKHL1jIXO834O7DDkwDriMbizAT6HiufitsJxhJtT/sKiqY
         BCixGcsL2PPAzYOMtYS8cHE5ygRYGiNUMe3IXhHIbUac0TolFqMAVg6S7fKCjBUL+CY2
         1jBQ==
X-Gm-Message-State: AOJu0Yy7b/rXWEOZBgCOAr/4MRY/w0Wdrn0cOH+JTCMoypkUQxZS0yxN
	EG5hRrVKQd+6wcHhtE16KXwI9s5WQedoJ/+2QbJgxB8IoskRyHXMu9J0tgllib0BxTQW0wEJJuy
	IYOc45Pbgt7q53hfQ0pigiPeg/3hWdEW9SuVoF7GSMD0asUZ1NSXBX4fgUvY=
Precedence: bulk
X-Mailing-List: syzbot@lists.linux.dev
List-Id: <syzbot.lists.linux.dev>
List-Subscribe: <mailto:syzbot+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:syzbot+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Received: by 2002:a05:6820:1f05:b0:67e:f8c:6bdb with SMTP id
 006d021491bc7-68be681bc69mr803134eaf.24.1775794776424; Thu, 09 Apr 2026
 21:19:36 -0700 (PDT)
Date: Thu, 09 Apr 2026 21:19:36 -0700
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <69d87a58.050a0220.3030df.0023.GAE@google.com>
Subject: [moderation/CI] Re: hugetlb: normalize exported interfaces to use
 base-page indices
From: syzbot ci <syzbot+cie62ba228172539e7@syzkaller.appspotmail.com>
To: syzkaller-upstream-moderation@googlegroups.com
Cc: syzbot@lists.linux.dev
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

syzbot ci has tested the following series

[v1] hugetlb: normalize exported interfaces to use base-page indices
https://lore.kernel.org/all/20260409234158.837786-1-jane.chu@oracle.com
* [PATCH 1/6] hugetlb: open-code hugetlb folio lookup index conversion
* [PATCH 2/6] hugetlb: remove the hugetlb_linear_page_index() helper
* [PATCH 3/6] hugetlb: make hugetlb_fault_mutex_hash() take PAGE_SIZE index
* [PATCH 4/6] hugetlb: drop vma_hugecache_offset() in favor of linear_page_=
index()
* [PATCH 5/6] hugetlb: make hugetlb_add_to_page_cache() use PAGE_SIZE-based=
 index
* [PATCH 6/6] hugetlb: pass hugetlb reservation ranges in base-page indices

and found the following issue:
WARNING: bad unlock balance in hugetlb_no_page

Full report is available here:
https://ci.syzbot.org/series/95c5ba82-0135-4026-b7c7-b0819e1ca4d6

***

WARNING: bad unlock balance in hugetlb_no_page

tree:      mm-new
URL:       https://kernel.googlesource.com/pub/scm/linux/kernel/git/akpm/mm=
.git
base:      06a6cfb92448a97ef429a7fbd395a20a9d388acc
arch:      amd64
compiler:  Debian clang version 21.1.8 (++20251221033036+2078da43e25a-1~exp=
1~20251221153213.50), Debian LLD 21.1.8
config:    https://ci.syzbot.org/builds/cefe8576-3c99-42d3-9b51-1e70d62a64a=
7/config
syz repro: https://ci.syzbot.org/findings/3a14cc12-14a8-4fac-9614-ae7ae2555=
e58/syz_repro

=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
WARNING: bad unlock balance detected!
syzkaller #0 Not tainted
-------------------------------------
syz.0.17/5971 is trying to release lock (&hugetlb_fault_mutex_table[i]) at:
[<ffffffff8229b876>] hugetlb_handle_userfault mm/hugetlb.c:5686 [inline]
[<ffffffff8229b876>] hugetlb_no_page+0x1986/0x1da0 mm/hugetlb.c:5770
but there are no more locks to release!

other info that might help us debug this:
2 locks held by syz.0.17/5971:
 #0: ffff88816b85fb88 (vm_lock){++++}-{0:0}, at: lock_vma_under_rcu+0x1d1/0=
x500 mm/mmap_lock.c:310
 #1: ffff88816079e338 (&hugetlb_fault_mutex_table[i]){+.+.}-{4:4}, at: huge=
tlb_fault+0x317/0x1440 mm/hugetlb.c:5991

stack backtrace:
CPU: 0 UID: 0 PID: 5971 Comm: syz.0.17 Not tainted syzkaller #0 PREEMPT(ful=
l)=20
Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS 1.16.2-debian-1.16=
.2-1 04/01/2014
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
Code: 41 89 00 31 c0 c3 b9 40 00 00 00 bf 40 00 00 00 eb bc 0f 1f 40 00 48 =
89 7c 24 f8 48 89 74 24 f0 48 8b 7c 24 f8 4c 8b 44 24 f0 <8b> 4f 50 8b 47 5=
8 4c 01 c1 41 8b 34 00 8b 11 21 d6 89 f0 8d 72 01
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

The email will later be sent to:
[akpm@linux-foundation.org baolin.wang@linux.alibaba.com corbet@lwn.net dav=
id@kernel.org hughd@google.com jane.chu@oracle.com liam.howlett@oracle.com =
linux-doc@vger.kernel.org linux-kernel@vger.kernel.org linux-mm@kvack.org l=
orenzo.stoakes@oracle.com mhocko@suse.com muchun.song@linux.dev osalvador@s=
use.de peterx@redhat.com rppt@kernel.org skhan@linuxfoundation.org surenb@g=
oogle.com vbabka@kernel.org]

If the report looks fine to you, reply with:
#syz upstream

If the report is a false positive, reply with
#syz invalid

