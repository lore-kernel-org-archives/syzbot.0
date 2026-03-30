Received: from mail-oo1-f70.google.com (mail-oo1-f70.google.com [209.85.161.70])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EBA2E3B6BE8
	for <syzbot@lists.linux.dev>; Mon, 30 Mar 2026 23:59:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.161.70
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774915184; cv=none; b=ATmlMbDhnBMalevVT3xBmh3RTNdnnL5xi84xN+CUbIOIeYbTe4W2dePQ7TAZ9RHLBV4bKbeLXT2O78y3/1WK8cBa35s2U+4IXsi/wbgraDi9iirJVi12YjET7VRySiosvleumVcq248BcWMsdfLwfll9j+Y0Afhm1Lp4fc7G/bE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774915184; c=relaxed/simple;
	bh=Bt2gmuNgK6g/lld4WAzNXAOU863+LQgLelCqPIBT4Nk=;
	h=MIME-Version:Date:Message-ID:Subject:From:To:Cc:Content-Type; b=YKkaeXWCETjXUpzyTxXGQryX65Iov/VX0c9aUCWZQtM6XsgV9Cmf4KCDR1Zo6/9pF36owXS7v3KB2ckfQMSxhWsuZLkzwUmE6+EjISSHfRscStMj8IRqsUejdMdnGsz7b3qUYgXHk8w/nih4laVUBdeUx6q9BuELV5/HgwQnPvo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com; arc=none smtp.client-ip=209.85.161.70
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com
Received: by mail-oo1-f70.google.com with SMTP id 006d021491bc7-66b612efb4aso14375152eaf.0
        for <syzbot@lists.linux.dev>; Mon, 30 Mar 2026 16:59:42 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1774915182; x=1775519982;
        h=cc:to:from:subject:message-id:date:mime-version:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=fMedVuh7DmfOI3ivPUqbwpjWbcUy4VcPUqaAmQJADbI=;
        b=PXYsaPD8LXRU/WEbjcPBbcbnTshqyzQxZ8fzGOIwWx1/YwNnqFc4JfiOr0N6c3XGjJ
         4kgJoQIwod9A1UWMkYFlEdiDQyyEAb+/INKPMQhr3tFmMikUOX7AlAuOpq0VDD5REE9W
         iNGNKt04ZQ3bh4PsdZVYNJNwJ2VGy+Ik1GV7TZFi6ZL7WQVFtOGQ4ww6TnFifMOJ9kZ0
         47iIfvYcgAoHyoYm408kbShp5G/W2W99ojANqbxxXrEdUge34iX96xb9CLTLqby88BK7
         GFtIW23K5WX4tvaHRzY7tQRVzgQxIhP1O4d0CgWWLr51Z19RaUBY6hAISxLt6EbVT3xU
         Ox4w==
X-Gm-Message-State: AOJu0Yw33Io3u/lIONMfu76kTV/llTwOgR70N9LKQIE9KYpD8HvzWA+f
	J3GWpDYmVzWHoPvProCq6fdSWdfWCOLUeO3bw+h2j54sLz076gy0elRT2HmG/WCqSLILXHI6I9o
	CieJLi6EHHhDrXb4OQzrvLYiZDW21n+5xh8jepX3dAcf7rqidavwLdnEQF24=
Precedence: bulk
X-Mailing-List: syzbot@lists.linux.dev
List-Id: <syzbot.lists.linux.dev>
List-Subscribe: <mailto:syzbot+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:syzbot+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Received: by 2002:a05:6820:1897:b0:67e:17fc:787d with SMTP id
 006d021491bc7-67e3d8e399fmr1072793eaf.18.1774915181936; Mon, 30 Mar 2026
 16:59:41 -0700 (PDT)
Date: Mon, 30 Mar 2026 16:59:41 -0700
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <69cb0e6d.050a0220.183828.001d.GAE@google.com>
Subject: [moderation/CI] Re: mm/vmalloc: Use dedicated unbound workqueue for
 vmap purge/drain
From: syzbot ci <syzbot+cif00a2aa5a854ea21@syzkaller.appspotmail.com>
To: syzkaller-upstream-moderation@googlegroups.com
Cc: syzbot@lists.linux.dev
Content-Type: text/plain; charset="UTF-8"

syzbot ci has tested the following series

[v2] mm/vmalloc: Use dedicated unbound workqueue for vmap purge/drain
https://lore.kernel.org/all/20260330175824.2777270-1-urezki@gmail.com
* [PATCH v2] mm/vmalloc: Use dedicated unbound workqueue for vmap purge/drain

and found the following issue:
possible deadlock in touch_wq_lockdep_map

Full report is available here:
https://ci.syzbot.org/series/4a8f638e-3a3f-4346-8189-2b5a0eb9ceaf

***

possible deadlock in touch_wq_lockdep_map

tree:      mm-new
URL:       https://kernel.googlesource.com/pub/scm/linux/kernel/git/akpm/mm.git
base:      af42d6d3650b95295a3f08fc35189998bc26c2e1
arch:      amd64
compiler:  Debian clang version 21.1.8 (++20251221033036+2078da43e25a-1~exp1~20251221153213.50), Debian LLD 21.1.8
config:    https://ci.syzbot.org/builds/d94b1f61-6a69-4415-b385-b3c99018e8c2/config
syz repro: https://ci.syzbot.org/findings/01e4d436-e924-4ce6-8902-78c6000bf34e/syz_repro

============================================
WARNING: possible recursive locking detected
syzkaller #0 Not tainted
--------------------------------------------
kworker/u9:1/33 is trying to acquire lock:
ffff88810168e948 ((wq_completion)vmap_drain){+.+.}-{0:0}, at: touch_wq_lockdep_map+0xb5/0x180 kernel/workqueue.c:3991

but task is already holding lock:
ffff88810168e948 ((wq_completion)vmap_drain){+.+.}-{0:0}, at: process_one_work kernel/workqueue.c:3251 [inline]
ffff88810168e948 ((wq_completion)vmap_drain){+.+.}-{0:0}, at: process_scheduled_works+0xa52/0x18c0 kernel/workqueue.c:3359

other info that might help us debug this:
 Possible unsafe locking scenario:

       CPU0
       ----
  lock((wq_completion)vmap_drain);
  lock((wq_completion)vmap_drain);

 *** DEADLOCK ***

 May be due to missing lock nesting notation

4 locks held by kworker/u9:1/33:
 #0: ffff88810168e948 ((wq_completion)vmap_drain){+.+.}-{0:0}, at: process_one_work kernel/workqueue.c:3251 [inline]
 #0: ffff88810168e948 ((wq_completion)vmap_drain){+.+.}-{0:0}, at: process_scheduled_works+0xa52/0x18c0 kernel/workqueue.c:3359
 #1: ffffc90000a97c40 (drain_vmap_work){+.+.}-{0:0}, at: process_one_work kernel/workqueue.c:3252 [inline]
 #1: ffffc90000a97c40 (drain_vmap_work){+.+.}-{0:0}, at: process_scheduled_works+0xa8d/0x18c0 kernel/workqueue.c:3359
 #2: ffffffff8e87ed68 (vmap_purge_lock){+.+.}-{4:4}, at: drain_vmap_area_work+0x17/0x40 mm/vmalloc.c:2443
 #3: ffffffff8e75e5e0 (rcu_read_lock){....}-{1:3}, at: rcu_lock_acquire include/linux/rcupdate.h:312 [inline]
 #3: ffffffff8e75e5e0 (rcu_read_lock){....}-{1:3}, at: rcu_read_lock include/linux/rcupdate.h:850 [inline]
 #3: ffffffff8e75e5e0 (rcu_read_lock){....}-{1:3}, at: start_flush_work kernel/workqueue.c:4234 [inline]
 #3: ffffffff8e75e5e0 (rcu_read_lock){....}-{1:3}, at: __flush_work+0x100/0xc50 kernel/workqueue.c:4292

stack backtrace:
CPU: 1 UID: 0 PID: 33 Comm: kworker/u9:1 Not tainted syzkaller #0 PREEMPT(full) 
Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS 1.16.2-debian-1.16.2-1 04/01/2014
Workqueue: vmap_drain drain_vmap_area_work
Call Trace:
 <TASK>
 dump_stack_lvl+0xe8/0x150 lib/dump_stack.c:120
 print_deadlock_bug+0x279/0x290 kernel/locking/lockdep.c:3041
 check_deadlock kernel/locking/lockdep.c:3093 [inline]
 validate_chain kernel/locking/lockdep.c:3895 [inline]
 __lock_acquire+0x253f/0x2cf0 kernel/locking/lockdep.c:5237
 lock_acquire+0xf0/0x2e0 kernel/locking/lockdep.c:5868
 touch_wq_lockdep_map+0xcb/0x180 kernel/workqueue.c:3991
 start_flush_work kernel/workqueue.c:4272 [inline]
 __flush_work+0x87c/0xc50 kernel/workqueue.c:4292
 __purge_vmap_area_lazy+0x7db/0xab0 mm/vmalloc.c:2419
 drain_vmap_area_work+0x27/0x40 mm/vmalloc.c:2444
 process_one_work kernel/workqueue.c:3276 [inline]
 process_scheduled_works+0xb6e/0x18c0 kernel/workqueue.c:3359
 worker_thread+0xa53/0xfc0 kernel/workqueue.c:3440
 kthread+0x388/0x470 kernel/kthread.c:436
 ret_from_fork+0x51e/0xb90 arch/x86/kernel/process.c:158
 ret_from_fork_asm+0x1a/0x30 arch/x86/entry/entry_64.S:245
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
[akpm@linux-foundation.org bhe@redhat.com linux-kernel@vger.kernel.org linux-mm@kvack.org lirongqing@baidu.com urezki@gmail.com]

If the report looks fine to you, reply with:
#syz upstream

If the report is a false positive, reply with
#syz invalid

