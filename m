Received: from mail-oi1-f198.google.com (mail-oi1-f198.google.com [209.85.167.198])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7C8E93E8C55
	for <syzbot@lists.linux.dev>; Tue, 21 Jul 2026 09:33:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.167.198
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784626421; cv=none; b=Oej4KwpRV/vpKNTLj4cZJMwbf7ySZQxNOim4cXKQDidOd3u9L3fIyAR2+vKd2Eiq4dDusjk0Ibaq6ZFQgRFBYup04JiMc0jwrOOw81K0ii/ipUowZQ+fAkfXkA1AqpEk+fflXOu7ipVTbyfUX5bcWfEDMLEpya5q+ibvBAZuF6Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784626421; c=relaxed/simple;
	bh=V7J8tkLzXReczKd7NGEpc7rIJGw4IWgdzfOThI2CUF0=;
	h=MIME-Version:Date:Message-ID:Subject:From:To:Cc:Content-Type; b=KkiXh7Mu5W1wl4ZEpwi0JczEcGD3gn1GLnnfwzOl4Yb7P8X5I4n8Kq/B++v58/enShTKj73D9NXCaVn00A00Y4T73lSgiXF6i7rAC3FyP4Cb+18W84O2r4MwaPPBPIE9jn6qqqUCQhDmMHzxzNTLUMOpiOc8KrHCpwWvERBd4Xc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com; arc=none smtp.client-ip=209.85.167.198
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com
Received: by mail-oi1-f198.google.com with SMTP id 5614622812f47-4959c49e054so10614446b6e.3
        for <syzbot@lists.linux.dev>; Tue, 21 Jul 2026 02:33:40 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1784626419; x=1785231219;
        h=content-transfer-encoding:content-type:cc:to:from:subject
         :message-id:date:mime-version:x-gm-message-state:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=MCR4bBuPO9aggywcIwsltII3P2UovGBMBdVBfIF7AAM=;
        b=H50awDKtlUnEyZfFTxorLkFeWvYpY4h1we10hm2CjCHuriVlA19vaMzegpgeL2kElI
         w37ykEEY4hyBQYXhkA5a28h/PzDk0ZKy9QqSUu4NJbun0iRFfGI49mICKDmN9t2P5A3k
         IESjFXdzHyKInW54VUR9dMPP3BBC4gpO5tYUZLRgwcmC8TliNMxQ2QCxVdwJE2B0iLoN
         VWlxTEKY1Y9RR3+SxLO9LFHBFXrh5G3nBwVdiuotWmlB6cqTyxhn//0zVY6MFfntvRd7
         vMiNA05RvKXh0ewzff5eO5RdCIlp3OVsGbKs8mipJrZBhEzdaEx5IFeHA8XsCcwBDnO3
         cgfg==
X-Gm-Message-State: AOJu0YxOP1csFRQG9K3QDthGAMZnm8q5yYJHwdbS1+lc39+qIvlQej6y
	f4eEyU90e2pu/xc8OSl+YnLCZgoeOuB++8Ty2SFHTBlvUg1qYXvrnHtM2vAW5p89OeQUl5e5oQI
	fjbKy6yIwV7pWLRPCjWiclL6AN+RmbcNA1TeAbnUAKhLBxEBDtT7/Uq6JMPA=
Precedence: bulk
X-Mailing-List: syzbot@lists.linux.dev
List-Id: <syzbot.lists.linux.dev>
List-Subscribe: <mailto:syzbot+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:syzbot+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Received: by 2002:a05:6808:179c:b0:495:fed2:1db3 with SMTP id
 5614622812f47-4a4d016c5d6mr9193319b6e.5.1784626419427; Tue, 21 Jul 2026
 02:33:39 -0700 (PDT)
Date: Tue, 21 Jul 2026 02:33:39 -0700
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <6a5f3cf3.33ea6125.251e5.0000.GAE@google.com>
Subject: [moderation/CI] Re: mm/khugepaged: collapse_file() cleanups
From: syzbot ci <syzbot+cie7043cc98ea76fa1@syzkaller.appspotmail.com>
To: syzkaller-upstream-moderation@googlegroups.com
Cc: syzbot@lists.linux.dev
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

syzbot ci has tested the following series

[v1] mm/khugepaged: collapse_file() cleanups
https://lore.kernel.org/all/20260720142913.846902-1-pfalcato@suse.de
* [PATCH 1/8] mm/khugepaged: separate out windy folio logic from collapse_f=
ile
* [PATCH 2/8] mm/khugepaged: factor out page cache folio reading
* [PATCH 3/8] mm/khugepaged: factor out and simplify dirty/writeback handli=
ng
* [PATCH 4/8] mm/khugepaged: simplify prepare folio locking and exit paths
* [PATCH 5/8] mm/khugepaged: add kerneldoc to prepare_collapse_file_folio()
* [PATCH 6/8] mm/khugepaged: hoist isolation into collapse_isolate_folio()
* [PATCH 7/8] mm/khugepaged: hoist more code into collapse_isolate_folio()
* [PATCH 8/8] mm/khugepaged: fix and flesh out try_to_unmap_flush() comment

and found the following issue:
WARNING: bad unlock balance in collapse_scan_file

Full report is available here:
https://ci.syzbot.org/series/cc30d9d4-857a-45de-a8e8-b99f9346d0da

***

WARNING: bad unlock balance in collapse_scan_file

tree:      mm-new
URL:       https://kernel.googlesource.com/pub/scm/linux/kernel/git/akpm/mm=
.git
base:      c872b70f5d6c742ad34b8e838c92af81c8920b3e
arch:      amd64
compiler:  Debian clang version 22.1.8 (++20260613092233+e80beda6e255-1~exp=
1~20260613092250.77), Debian LLD 22.1.8
config:    https://ci.syzbot.org/builds/e6e237b7-5a64-4732-bb37-4e62c3103d4=
a/config
syz repro: https://ci.syzbot.org/findings/51ee94c3-7fe6-47f6-81ed-a53cf51bb=
3f9/syz_repro

=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
WARNING: bad unlock balance detected!
syzkaller #0 Not tainted
-------------------------------------
syz.0.17/5868 is trying to release lock (&xa->xa_lock) at:
[<ffffffff823ac70f>] spin_unlock_irq include/linux/spinlock.h:402 [inline]
[<ffffffff823ac70f>] prepare_collapse_file_folio mm/khugepaged.c:2331 [inli=
ne]
[<ffffffff823ac70f>] collapse_file mm/khugepaged.c:2539 [inline]
[<ffffffff823ac70f>] collapse_scan_file+0x2cbf/0x4dc0 mm/khugepaged.c:2849
but there are no more locks to release!

other info that might help us debug this:
no locks held by syz.0.17/5868.

stack backtrace:
CPU: 0 UID: 0 PID: 5868 Comm: syz.0.17 Not tainted syzkaller #0 PREEMPT(ful=
l)=20
Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS 1.16.2-debian-1.16=
.2-1 04/01/2014
Call Trace:
 <TASK>
 dump_stack_lvl+0xe8/0x150 lib/dump_stack.c:120
 print_unlock_imbalance_bug+0xdc/0xf0 kernel/locking/lockdep.c:5299
 __lock_release kernel/locking/lockdep.c:5528 [inline]
 lock_release+0x1fb/0x3c0 kernel/locking/lockdep.c:5912
 __raw_spin_unlock_irq include/linux/spinlock_api_smp.h:185 [inline]
 _raw_spin_unlock_irq+0x16/0x50 kernel/locking/spinlock.c:206
 spin_unlock_irq include/linux/spinlock.h:402 [inline]
 prepare_collapse_file_folio mm/khugepaged.c:2331 [inline]
 collapse_file mm/khugepaged.c:2539 [inline]
 collapse_scan_file+0x2cbf/0x4dc0 mm/khugepaged.c:2849
 collapse_single_pmd+0x2b1/0x3da0 mm/khugepaged.c:2884
 madvise_collapse+0x2cf/0x790 mm/khugepaged.c:3310
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
RIP: 0033:0x7fb60079de99
Code: ff c3 66 2e 0f 1f 84 00 00 00 00 00 0f 1f 44 00 00 48 89 f8 48 89 f7 =
48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 ff f=
f 73 01 c3 48 c7 c1 e8 ff ff ff f7 d8 64 89 01 48
RSP: 002b:00007fb6015c0028 EFLAGS: 00000246 ORIG_RAX: 000000000000001c
RAX: ffffffffffffffda RBX: 00007fb600a25fa0 RCX: 00007fb60079de99
RDX: 0000000000000019 RSI: 0000000000600003 RDI: 0000200000000000
RBP: 00007fb600833eaf R08: 0000000000000000 R09: 0000000000000000
R10: 0000000000000000 R11: 0000000000000246 R12: 0000000000000000
R13: 00007fb600a26038 R14: 00007fb600a25fa0 R15: 00007ffc7db2f618
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
[akpm@linux-foundation.org baohua@kernel.org baolin.wang@linux.alibaba.com =
david@kernel.org dev.jain@arm.com lance.yang@linux.dev liam@infradead.org l=
inux-kernel@vger.kernel.org linux-mm@kvack.org ljs@kernel.org npache@redhat=
.com pfalcato@suse.de ryan.roberts@arm.com usama.arif@linux.dev ziy@nvidia.=
com]

If the report looks fine to you, reply with:
#syz upstream

If the report is a false positive, reply with
#syz invalid

