Received: from mail-oi1-f199.google.com (mail-oi1-f199.google.com [209.85.167.199])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 43AAA45C6F1
	for <syzbot@lists.linux.dev>; Thu, 24 Sep 2026 23:24:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.167.199
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790292284; cv=none; b=C7GHd+VXAPS9ycCxRUoLO4/dk/2UTLz2jk6gD21nIANxoeskydxx2HXNnI8D2BDj8TgnaCefcTGAWNZ3vqPVTtm8VE4wlqjEHlhJQeg/wWRgk63xTGM3/aDkM51q25OrHr2dlQa9FmgG3F1UDBAM74iU8kY16lkOrQFITf/W+5I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790292284; c=relaxed/simple;
	bh=5yFQrZ/V3tI/GqKqlpZ8FgKgkeZVQ8VCdtDqYs858LQ=;
	h=MIME-Version:Date:Message-ID:Subject:From:To:Cc:Content-Type; b=lB6BzQ/oOUXE7tJjw8pbA/Um3oq2a2Kuy68/naownNRhwGLB3yZyr2Mru51HuA2Ohv4wNs6u1Qp1bs4yHu6kN16ZF+uaRH9wJcyjCIAllnQrA2np633pApaJT2OA0FxxUt0dZ3me+7dhnQomMWwNBknj4P78KUjHReUnJkP1y3U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com; arc=none smtp.client-ip=209.85.167.199
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com
Received: by mail-oi1-f199.google.com with SMTP id 5614622812f47-4c55ba309c2so709291b6e.1
        for <syzbot@lists.linux.dev>; Thu, 24 Sep 2026 16:24:38 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1790292277; x=1790897077;
        h=content-type:cc:to:from:subject:message-id:date:mime-version
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=xEDJc6Z8qvV97tbFPajANecjOeD4fnkS32ehdszmFww=;
        b=UVMS+nC7LNoeTBkjGzODU0yyp5HKdeEyvvc8mfJUuLy3u/zUqCkUANYCdnfxLh6u4V
         zRa+eapa6xaZGai+8iT0Tcu/xG4PWENCRRRA4uKbzmCikhu3pN3aV+a5HFxJiVU8PRlV
         LXdHhQne0Fye/BkVbJ6JeWla1mJmbgrp/KUk9PJ14ZrWGdJo/Lnf5xyoA8S5Mpb9d9VO
         8JOpoAr+Do16vzAuo//eblblcxBxxHu0dlOq56WHgZAaSGomZhGTJzacnkzcydVZ8JLZ
         DubqpfeJwlHa1VJqSRFCdqBkfWq3LPKQusleEb7NLwDYwgpUMO5QWMU34GngbR3K362i
         jJ9Q==
X-Gm-Message-State: AFuF++kLlJPLPHNrMqpQneliiAQWVfzppzunYeDm1TsvtfycNSVIyIoE
	1U3N2JUT8SFEK4ht0qB4y3n+e1zINUf5jBd/fPGMX/WuY/7Izj5u68NGRcxSj2Cd/L/peCgE9Vu
	n8irhZ8iGRIWozIHRMXup/jDqoCzXa0VgksGUB7Y+fVLoGJtLOxj1G9+MZUw=
Precedence: bulk
X-Mailing-List: syzbot@lists.linux.dev
List-Id: <syzbot.lists.linux.dev>
List-Subscribe: <mailto:syzbot+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:syzbot+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Received: by 2002:a05:6808:1388:b0:4d6:92b3:5c89 with SMTP id
 5614622812f47-4d72f1507bdmr4095339b6e.63.1790292277548; Thu, 24 Sep 2026
 16:24:37 -0700 (PDT)
Date: Thu, 24 Sep 2026 16:24:37 -0700
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <6ab5b135.7428d045.30104c.000a.GAE@google.com>
Subject: [moderation/CI] Re: isofs: Fix handling of directories with tight blocks
From: syzbot ci <syzbot+ci7856d3ed53ba2d98@syzkaller.appspotmail.com>
To: syzkaller-upstream-moderation@googlegroups.com
Cc: syzbot@lists.linux.dev
Content-Type: text/plain; charset="UTF-8"

syzbot ci has tested the following series

[v1] isofs: Fix handling of directories with tight blocks
https://lore.kernel.org/all/20260922121912.2258134-2-jack@suse.cz
* [PATCH] isofs: Fix handling of directories with tight blocks

and found the following issues:
* INFO: task hung in d_alloc_parallel
* INFO: task hung in lookup_slow

Full report is available here:
https://ci.syzbot.org/series/1c5e91af-d857-4245-95ce-5602d6c1fc78

***

INFO: task hung in d_alloc_parallel

tree:      vfs
URL:       https://kernel.googlesource.com/pub/scm/linux/kernel/git/vfs/vfs.git
base:      061b90224ee6e3d51fcfd606d34a1c79365ea1b5
arch:      amd64
compiler:  Debian clang version 22.1.8 (++20260613092233+e80beda6e255-1~exp1~20260613092250.77), Debian LLD 22.1.8
config:    https://ci.syzbot.org/builds/5fea1b08-98ff-4ff5-8b8d-d7bf6f5a222b/config
syz repro: https://ci.syzbot.org/findings/9651a622-bc22-4db7-91ce-80075a40390b/syz_repro

INFO: task syz.2.19:5860 blocked for more than 143 seconds.
      Not tainted syzkaller #0
"echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
task:syz.2.19        state:D stack:28296 pid:5860  tgid:5858  ppid:5737   task_flags:0x400140 flags:0x00080002
Call Trace:
 <TASK>
 context_switch kernel/sched/core.c:5526 [inline]
 __schedule+0x17dd/0x5940 kernel/sched/core.c:7277
 __schedule_loop kernel/sched/core.c:7354 [inline]
 schedule+0x164/0x2b0 kernel/sched/core.c:7369
 d_wait_lookup fs/dcache.c:2775 [inline]
 d_alloc_parallel+0xcdd/0x16b0 fs/dcache.c:2860
 __lookup_slow+0x82/0x2f0 fs/namei.c:1904
 lookup_slow+0x53/0x70 fs/namei.c:1936
 walk_component fs/namei.c:2282 [inline]
 link_path_walk+0xd2a/0x1910 fs/namei.c:2656
 path_lookupat+0xe4/0x8c0 fs/namei.c:2812
 do_o_path+0x9f/0x210 fs/namei.c:4980
 path_openat+0x16c5/0x1da0 fs/namei.c:5002
 do_file_open+0x23e/0x4a0 fs/namei.c:5038
 do_sys_openat2+0x115/0x200 fs/open.c:1442
 do_sys_open fs/open.c:1448 [inline]
 __do_sys_openat fs/open.c:1464 [inline]
 __se_sys_openat fs/open.c:1459 [inline]
 __x64_sys_openat+0x138/0x170 fs/open.c:1459
 do_syscall_x64 arch/x86/entry/syscall_64.c:61 [inline]
 do_syscall_64+0x166/0x520 arch/x86/entry/syscall_64.c:84
 entry_SYSCALL_64_after_hwframe+0x77/0x7f
RIP: 0033:0x7f2c4d99e159
RSP: 002b:00007f2c4e86b028 EFLAGS: 00000246 ORIG_RAX: 0000000000000101
RAX: ffffffffffffffda RBX: 00007f2c4dc26090 RCX: 00007f2c4d99e159
RDX: 0000000000200002 RSI: 0000200000000100 RDI: ffffffffffffff9c
RBP: 00007f2c4da3506b R08: 0000000000000000 R09: 0000000000000000
R10: 0000000000000000 R11: 0000000000000246 R12: 0000000000000000
R13: 00007f2c4dc26128 R14: 00007f2c4dc26090 R15: 00007fffbbb4ebb8
 </TASK>
INFO: task syz.1.18:5866 blocked for more than 143 seconds.
      Not tainted syzkaller #0
"echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
task:syz.1.18        state:D stack:28296 pid:5866  tgid:5862  ppid:5736   task_flags:0x400140 flags:0x00080002
Call Trace:
 <TASK>
 context_switch kernel/sched/core.c:5526 [inline]
 __schedule+0x17dd/0x5940 kernel/sched/core.c:7277
 __schedule_loop kernel/sched/core.c:7354 [inline]
 schedule+0x164/0x2b0 kernel/sched/core.c:7369
 d_wait_lookup fs/dcache.c:2775 [inline]
 d_alloc_parallel+0xcdd/0x16b0 fs/dcache.c:2860
 __lookup_slow+0x82/0x2f0 fs/namei.c:1904
 lookup_slow+0x53/0x70 fs/namei.c:1936
 walk_component fs/namei.c:2282 [inline]
 link_path_walk+0xd2a/0x1910 fs/namei.c:2656
 path_lookupat+0xe4/0x8c0 fs/namei.c:2812
 do_o_path+0x9f/0x210 fs/namei.c:4980
 path_openat+0x16c5/0x1da0 fs/namei.c:5002
 do_file_open+0x23e/0x4a0 fs/namei.c:5038
 do_sys_openat2+0x115/0x200 fs/open.c:1442
 do_sys_open fs/open.c:1448 [inline]
 __do_sys_openat fs/open.c:1464 [inline]
 __se_sys_openat fs/open.c:1459 [inline]
 __x64_sys_openat+0x138/0x170 fs/open.c:1459
 do_syscall_x64 arch/x86/entry/syscall_64.c:61 [inline]
 do_syscall_64+0x166/0x520 arch/x86/entry/syscall_64.c:84
 entry_SYSCALL_64_after_hwframe+0x77/0x7f
RIP: 0033:0x7f299799e159
RSP: 002b:00007f2996fdd028 EFLAGS: 00000246 ORIG_RAX: 0000000000000101
RAX: ffffffffffffffda RBX: 00007f2997c26090 RCX: 00007f299799e159
RDX: 0000000000200002 RSI: 0000200000000100 RDI: ffffff
RDX: 0000000000200002 RSI: 0000200000000100 RDI: ffffffffffffff9c
RBP: 00007f2997a3506b R08: 0000000000000000 R09: 0000000000000000
R10: 0000000000000000 R11: 0000000000000246 R12: 0000000000000000
R13: 00007f2997c26128 R14: 00007f2997c26090 R15: 00007ffc5b4deeb8
 </TASK>
INFO: task syz.0.17:5867 blocked for more than 143 seconds.
      Not tainted syzkaller #0
"echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
task:syz.0.17        state:D stack:28296 pid:5867  tgid:5864  ppid:5731   task_flags:0x400140 flags:0x00080002
Call Trace:
 <TASK>
 context_switch kernel/sched/core.c:5526 [inline]
 __schedule+0x17dd/0x5940 kernel/sched/core.c:7277
 __schedule_loop kernel/sched/core.c:7354 [inline]
 schedule+0x164/0x2b0 kernel/sched/core.c:7369
 d_wait_lookup fs/dcache.c:2775 [inline]
 d_alloc_parallel+0xcdd/0x16b0 fs/dcache.c:2860
 __lookup_slow+0x82/0x2f0 fs/namei.c:1904
 lookup_slow+0x53/0x70 fs/namei.c:1936
 walk_component fs/namei.c:2282 [inline]
 link_path_walk+0xd2a/0x1910 fs/namei.c:2656
 path_lookupat+0xe4/0x8c0 fs/namei.c:2812
 do_o_path+0x9f/0x210 fs/namei.c:4980
 path_openat+0x16c5/0x1da0 fs/namei.c:5002
 do_file_open+0x23e/0x4a0 fs/namei.c:5038
 do_sys_openat2+0x115/0x200 fs/open.c:1442
 do_sys_open fs/open.c:1448 [inline]
 __do_sys_openat fs/open.c:1464 [inline]
 __se_sys_openat fs/open.c:1459 [inline]
 __x64_sys_openat+0x138/0x170 fs/open.c:1459
 do_syscall_x64 arch/x86/entry/syscall_64.c:61 [inline]
 do_syscall_64+0x166/0x520 arch/x86/entry/syscall_64.c:84
 entry_SYSCALL_64_after_hwframe+0x77/0x7f
RIP: 0033:0x7f8d1299e159
RSP: 002b:00007f8d138b4028 EFLAGS: 00000246 ORIG_RAX: 0000000000000101
RAX: ffffffffffffffda RBX: 00007f8d12c26090 RCX: 00007f8d1299e159
RDX: 0000000000200002 RSI: 0000200000000100 RDI: ffffffffffffff9c
RBP: 00007f8d12a3506b R08: 0000000000000000 R09: 0000000000000000
R10: 0000000000000000 R11: 0000000000000246 R12: 0000000000000000
R13: 00007f8d12c26128 R14: 00007f8d12c26090 R15: 00007ffda1300988
 </TASK>

Showing all locks held in the system:
locks held by khungtaskd/36: 1, last CPU#1:
 #0: ffffffff8ed5c8e0 (rcu_read_lock){....}-{1:3}, at: rcu_lock_acquire include/linux/rcupdate.h:309 [inline]
 #0: ffffffff8ed5c8e0 (rcu_read_lock){....}-{1:3}, at: rcu_read_lock include/linux/rcupdate.h:849 [inline]
 #0: ffffffff8ed5c8e0 (rcu_read_lock){....}-{1:3}, at: debug_show_all_locks+0x2e/0x180 kernel/locking/lockdep.c:6871
locks held by getty/5424: 2, on CPU#1:
 #0: ffff888172fc30a0 (&tty->ldisc_sem){++++}-{0:0}, at: tty_ldisc_ref_wait+0x25/0x70 drivers/tty/tty_ldisc.c:243
 #1: ffffc900034832e8 (&ldata->atomic_read_lock){+.+.}-{4:4}, at: n_tty_read+0x45a/0x1360 drivers/tty/n_tty.c:2211
locks held by syz.2.19/5859: 1, last CPU#1:
 #0: ffff88811e2537c0 (&type->i_mutex_dir_key#8){.+.+}-{4:4}, at: inode_lock_shared include/linux/fs.h:1039 [inline]
 #0: ffff88811e2537c0 (&type->i_mutex_dir_key#8){.+.+}-{4:4}, at: lookup_slow+0x46/0x70 fs/namei.c:1935
locks held by syz.2.19/5860: 1, on CPU#1:
 #0: ffff88811e2537c0 (&type->i_mutex_dir_key#8){.+.+}-{4:4}, at: inode_lock_shared include/linux/fs.h:1039 [inline]
 #0: ffff88811e2537c0 (&type->i_mutex_dir_key#8){.+.+}-{4:4}, at: lookup_slow+0x46/0x70 fs/namei.c:1935
locks held by syz.1.18/5863: 2, last CPU#0:
 #0: ffff8881b087b7c0 (&type->i_mutex_dir_key#8){.+.+}-{4:4}, at: inode_lock_shared include/linux/fs.h:1039 [inline]
 #0: ffff8881b087b7c0 (&type->i_mutex_dir_key#8){.+.+}-{4:4}, at: lookup_slow+0x46/0x70 fs/namei.c:1935
 #1: ffffffff8eea5ca0 (mmu_notifier_invalidate_range_start){+.+.}-{0:0}, at: fs_reclaim_acquire+0x7c/0x100 mm/page_alloc.c:4392
locks held by syz.1.18/5866: 1, on CPU#1:
 #0: ffff8881b087b7c0 (&type->i_mutex_dir_key#8){.+.+}-{4:4}, at: inode_lock_shared include/linux/fs.h:1039 [inline]
 #0: ffff8881b087b7c0 (&type->i_mutex_dir_key#8){.+.+}-{4:4}, at: lookup_slow+0x46/0x70 fs/namei.c:1935
locks held by syz.0.17/5865: 1, last CPU#0:
 #0: ffff88811e2532d0 (&type->i_mutex_dir_key#8){.+.+}-{4:4}, at: inode_lock_shared include/linux/fs.h:1039 [inline]
 #0: ffff88811e2532d0 (&type->i_mutex_dir_key#8){.+.+}-{4:4}, at: lookup_slow+0x46/0x70 fs/namei.c:1935
locks held by syz.0.17/5867: 1, on CPU#1:
 #0: ffff88811e2532d0 (&type->i_mutex_dir_key#8){.+.+}-{4:4}, at: inode_lock_shared include/linux/fs.h:1039 [inline]
 #0: ffff88811e2532d0 (&type->i_mutex_dir_key#8){.+.+}-{4:4}, at: lookup_slow+0x46/0x70 fs/namei.c:1935
locks held by syz.3.20/5989: 1, last CPU#1:
 #0: ffff88811e252de0 (&type->i_mutex_dir_key#8){.+.+}-{4:4}, at: inode_lock_shared include/linux/fs.h:1039 [inline]
 #0: ffff88811e252de0 (&type->i_mutex_dir_key#8){.+.+}-{4:4}, at: lookup_slow+0x46/0x70 fs/namei.c:1935
locks held by syz.3.20/5990: 1, on CPU#0:
 #0: ffff88811e252de0 (&type->i_mutex_dir_key#8){.+.+}-{4:4}, at: inode_lock_shared include/linux/fs.h:1039 [inline]
 #0: ffff88811e252de0 (&type->i_mutex_dir_key#8){.+.+}-{4:4}, at: lookup_slow+0x46/0x70 fs/namei.c:1935
locks held by syz.4.21/5992: 1, last CPU#0:
 #0: ffff8881b087b2d0 (&type->i_mutex_dir_key#8){.+.+}-{4:4}, at: inode_lock_shared include/linux/fs.h:1039 [inline]
 #0: ffff8881b087b2d0 (&type->i_mutex_dir_key#8){.+.+}-{4:4}, at: lookup_slow+0x46/0x70 fs/namei.c:1935
locks held by syz.4.21/5993: 1, on CPU#0:
 #0: ffff8881b087b2d0 (&type->i_mutex_dir_key#8){.+.+}-{4:4}, at: inode_lock_shared include/linux/fs.h:1039 [inline]
 #0: ffff8881b087b2d0 (&type->i_mutex_dir_key#8){.+.+}-{4:4}, at: lookup_slow+0x46/0x70 fs/namei.c:1935
locks held by syz.5.22/5995: 1, last CPU#0:
 #0: ffff8881b087ade0 (&type->i_mutex_dir_key#8){.+.+}-{4:4}, at: inode_lock_shared include/linux/fs.h:1039 [inline]
 #0: ffff8881b087ade0 (&type->i_mutex_dir_key#8){.+.+}-{4:4}, at: lookup_slow+0x46/0x70 fs/namei.c:1935
locks held by syz.5.22/5996: 1, on CPU#0:
 #0: ffff8881b087ade0 (&type->i_mutex_dir_key#8){.+.+}-{4:4}, at: inode_lock_shared include/linux/fs.h:1039 [inline]
 #0: ffff8881b087ade0 (&type->i_mutex_dir_key#8){.+.+}-{4:4}, at: lookup_slow+0x46/0x70 fs/namei.c:1935
locks held by syz.8.25/6124: 1, last CPU#0:
 #0: ffff8881b087a8f0 (&type->i_mutex_dir_key#8){.+.+}-{4:4}, at: inode_lock_shared include/linux/fs.h:1039 [inline]
 #0: ffff8881b087a8f0 (&type->i_mutex_dir_key#8){.+.+}-{4:4}, at: lookup_slow+0x46/0x70 fs/namei.c:1935
locks held by syz.8.25/6125: 1, on CPU#1:
 #0: ffff8881b087a8f0 (&type->i_mutex_dir_key#8){.+.+}-{4:4}, at: inode_lock_shared include/linux/fs.h:1039 [inline]
 #0: ffff8881b087a8f0 (&type->i_mutex_dir_key#8){.+.+}-{4:4}, at: lookup_slow+0x46/0x70 fs/namei.c:1935
locks held by syz.7.24/6127: 1, last CPU#1:
 #0: ffff88811e2528f0 (&type->i_mutex_dir_key#8){.+.+}-{4:4}, at: inode_lock_shared include/linux/fs.h:1039 [inline]
 #0: ffff88811e2528f0 (&type->i_mutex_dir_key#8){.+.+}-{4:4}, at: lookup_slow+0x46/0x70 fs/namei.c:1935
locks held by syz.7.24/6130: 1, on CPU#1:
 #0: ffff88811e2528f0 (&type->i_mutex_dir_key#8){.+.+}-{4:4}, at: inode_lock_shared include/linux/fs.h:1039 [inline]
 #0: ffff88811e2528f0 (&type->i_mutex_dir_key#8){.+.+}-{4:4}, at: lookup_slow+0x46/0x70 fs/namei.c:1935
locks held by syz.6.23/6129: 1, last CPU#0:
 #0: ffff8881b087a400 (&type->i_mutex_dir_key#8){.+.+}-{4:4}, at: inode_lock_shared include/linux/fs.h:1039 [inline]
 #0: ffff8881b087a400 (&type->i_mutex_dir_key#8){.+.+}-{4:4}, at: lookup_slow+0x46/0x70 fs/namei.c:1935
locks held by syz.6.23/6131: 1, on CPU#0:
 #0: ffff8881b087a400 (&type->i_mutex_dir_key#8){.+.+}-{4:4}, at: inode_lock_shared include/linux/fs.h:1039 [inline]
 #0: ffff8881b087a400 (&type->i_mutex_dir_key#8){.+.+}-{4:4}, at: lookup_slow+0x46/0x70 fs/namei.c:1935
locks held by syz.9.26/6247: 2, last CPU#1:
 #0: ffff88811e252400 (&type->i_mutex_dir_key#8){.+.+}-{4:4}, at: inode_lock_shared include/linux/fs.h:1039 [inline]
 #0: ffff88811e252400 (&type->i_mutex_dir_key#8){.+.+}-{4:4}, at: lookup_slow+0x46/0x70 fs/namei.c:1935
 #1: ffffffff8eea5ca0 (mmu_notifier_invalidate_range_start){+.+.}-{0:0}, at: fs_reclaim_acquire+0x7c/0x100 mm/page_alloc.c:4392
locks held by syz.9.26/6248: 1, on CPU#0:
 #0: ffff88811e252400 (&type->i_mutex_dir_key#8){.+.+}-{4:4}, at: inode_lock_shared include/linux/fs.h:1039 [inline]
 #0: ffff88811e252400 (&type->i_mutex_dir_key#8){.+.+}-{4:4}, at: lookup_slow+0x46/0x70 fs/namei.c:1935
locks held by syz.1.1095/8434: 1, last CPU#1:
 #0: ffffffff8ed5c8e0 (rcu_read_lock){....}-{1:3}, at: rcu_lock_acquire include/linux/rcupdate.h:309 [inline]
 #0: ffffffff8ed5c8e0 (rcu_read_lock){....}-{1:3}, at: rcu_read_lock include/linux/rcupdate.h:849 [inline]
 #0: ffffffff8ed5c8e0 (rcu_read_lock){....}-{1:3}, at: find_lock_entries+0x12a/0xad0 mm/filemap.c:2188

=============================================

NMI backtrace for cpu 0
CPU: 0 UID: 0 PID: 36 Comm: khungtaskd Not tainted syzkaller #0 PREEMPT(full) 
Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS 1.16.2-debian-1.16.2-1 04/01/2014
Call Trace:
 <TASK>
 dump_stack_lvl+0xe8/0x150 lib/dump_stack.c:120
 nmi_cpu_backtrace+0x274/0x2d0 lib/nmi_backtrace.c:123
 nmi_trigger_cpumask_backtrace+0x17d/0x390 lib/nmi_backtrace.c:66
 trigger_all_cpu_backtrace include/linux/nmi.h:164 [inline]
 __sys_info lib/sys_info.c:157 [inline]
 sys_info+0x135/0x170 lib/sys_info.c:165
 check_hung_uninterruptible_tasks kernel/hung_task.c:353 [inline]
 watchdog+0xfd7/0x1030 kernel/hung_task.c:561
 kthread+0x38b/0x480 kernel/kthread.c:436
 ret_from_fork+0x514/0xb70 arch/x86/kernel/process.c:158
 ret_from_fork_asm+0x1a/0x30 arch/x86/entry/entry_64.S:245
 </TASK>
Sending NMI from CPU 0 to CPUs 1:
NMI backtrace for cpu 1
CPU: 1 UID: 0 PID: 5989 Comm: syz.3.20 Not tainted syzkaller #0 PREEMPT(full) 
Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS 1.16.2-debian-1.16.2-1 04/01/2014
RIP: 0010:check_preemption_disabled+0x6/0xd0 lib/smp_processor_id.c:14
Code: c7 c6 60 91 6d 8c eb 1c 66 66 66 2e 0f 1f 84 00 00 00 00 00 90 90 90 90 90 90 90 90 90 90 90 90 90 90 90 90 55 41 57 41 56 53 <65> 8b 05 db 2d af 07 65 48 8b 0d ab 2d af 07 85 c9 74 0c 5b 41 5e
RSP: 0018:ffffc9000273f3a8 EFLAGS: 00000002
RAX: 0000000000000001 RBX: ffffffff8260321f RCX: 0000000000000046
RDX: 0000000000000000 RSI: ffffffff8e4127e6 RDI: ffffffff8c6d9180
RBP: 0000000000000000 R08: ffffc9000273f567 R09: 1ffff920004e7eac
R10: dffffc0000000000 R11: fffff520004e7ead R12: 0000000000000400
R13: 0000000000000800 R14: ffff8881694e8000 R15: 0000000000000022
FS:  00007f30a0bd66c0(0000) GS:ffff8882a8cd0000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 0000001b34263fff CR3: 00000001172fe000 CR4: 00000000000006f0
Call Trace:
 <TASK>
 lockdep_hardirqs_off+0x57/0xd0 kernel/locking/lockdep.c:4555
 trace_hardirqs_off+0x12/0x40 kernel/trace/trace_preemptirq.c:104
 lookup_bh_lru fs/buffer.c:1264 [inline]
 find_get_block_common+0x6f/0xe10 fs/buffer.c:1301
 bdev_getblk+0x58/0x6e0 include/linux/gfp.h:-1
 __bread_gfp+0x89/0x380 fs/buffer.c:1412
 sb_bread include/linux/buffer_head.h:383 [inline]
 isofs_bread+0x1d9/0x270 fs/isofs/inode.c:1145
 isofs_find_entry fs/isofs/namei.c:72 [inline]
 isofs_lookup+0x260/0xdc0 fs/isofs/namei.c:162
 __lookup_slow+0x1fb/0x2f0 fs/namei.c:1919
 lookup_slow+0x53/0x70 fs/namei.c:1936
 walk_component fs/namei.c:2282 [inline]
 link_path_walk+0xd2a/0x1910 fs/namei.c:2656
 path_lookupat+0xe4/0x8c0 fs/namei.c:2812
 do_o_path+0x9f/0x210 fs/namei.c:4980
 path_openat+0x16c5/0x1da0 fs/namei.c:5002
 do_file_open+0x23e/0x4a0 fs/namei.c:5038
 do_sys_openat2+0x115/0x200 fs/open.c:1442
 do_sys_open fs/open.c:1448 [inline]
 __do_sys_openat fs/open.c:1464 [inline]
 __se_sys_openat fs/open.c:1459 [inline]
 __x64_sys_openat+0x138/0x170 fs/open.c:1459
 do_syscall_x64 arch/x86/entry/syscall_64.c:61 [inline]
 do_syscall_64+0x166/0x520 arch/x86/entry/syscall_64.c:84
 entry_SYSCALL_64_after_hwframe+0x77/0x7f
RIP: 0033:0x7f309fd9e159
Code: ff c3 66 2e 0f 1f 84 00 00 00 00 00 0f 1f 44 00 00 48 89 f8 48 89 f7 48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 ff ff 73 01 c3 48 c7 c1 e8 ff ff ff f7 d8 64 89 01 48
RSP: 002b:00007f30a0bd6028 EFLAGS: 00000246 ORIG_RAX: 0000000000000101
RAX: ffffffffffffffda RBX: 00007f30a0025fa0 RCX: 00007f309fd9e159
RDX: 0000000000200002 RSI: 00002000000000c0 RDI: ffffffffffffff9c
RBP: 00007f309fe3506b R08: 0000000000000000 R09: 0000000000000000
R10: 0000000000000000 R11: 0000000000000246 R12: 0000000000000000
R13: 00007f30a0026038 R14: 00007f30a0025fa0 R15: 00007ffdb7dac4f8
 </TASK>


***

INFO: task hung in lookup_slow

tree:      vfs
URL:       https://kernel.googlesource.com/pub/scm/linux/kernel/git/vfs/vfs.git
base:      061b90224ee6e3d51fcfd606d34a1c79365ea1b5
arch:      amd64
compiler:  Debian clang version 22.1.8 (++20260613092233+e80beda6e255-1~exp1~20260613092250.77), Debian LLD 22.1.8
config:    https://ci.syzbot.org/builds/5fea1b08-98ff-4ff5-8b8d-d7bf6f5a222b/config
syz repro: https://ci.syzbot.org/findings/312b0012-93c1-4dd0-8aaa-a1f18531ccb7/syz_repro

INFO: task syz.1.18:5813 blocked for more than 143 seconds.
      Not tainted syzkaller #0
"echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
task:syz.1.18        state:D stack:28704 pid:5813  tgid:5811  ppid:5739
task:syz.1.18        state:D stack:28704 pid:5813  tgid:5811  ppid:5739   task_flags:0x400140 flags:0x00080002
Call Trace:
 <TASK>
 context_switch kernel/sched/core.c:5526 [inline]
 __schedule+0x17dd/0x5940 kernel/sched/core.c:7277
 __schedule_loop kernel/sched/core.c:7354 [inline]
 schedule+0x164/0x2b0 kernel/sched/core.c:7369
 schedule_preempt_disabled+0x13/0x30 kernel/sched/core.c:7426
 rwsem_down_read_slowpath+0x6d8/0x980 kernel/locking/rwsem.c:1114
 __down_read_common kernel/locking/rwsem.c:1291 [inline]
 __down_read kernel/locking/rwsem.c:1304 [inline]
 down_read+0x9c/0x330 kernel/locking/rwsem.c:1576
 inode_lock_shared include/linux/fs.h:1039 [inline]
 lookup_slow+0x46/0x70 fs/namei.c:1935
 walk_component fs/namei.c:2282 [inline]
 lookup_last fs/namei.c:2789 [inline]
 path_lookupat+0x3f5/0x8c0 fs/namei.c:2813
 filename_lookup+0x265/0x5d0 fs/namei.c:2842
 user_path_at+0x40/0x160 fs/namei.c:3641
 do_mount fs/namespace.c:4178 [inline]
 __do_sys_mount fs/namespace.c:4395 [inline]
 __se_sys_mount+0x2dc/0x420 fs/namespace.c:4372
 do_syscall_x64 arch/x86/entry/syscall_64.c:61 [inline]
 do_syscall_64+0x166/0x520 arch/x86/entry/syscall_64.c:84
 entry_SYSCALL_64_after_hwframe+0x77/0x7f
RIP: 0033:0x7fbdcc59e159
RSP: 002b:00007fbdcbbfe028 EFLAGS: 00000246 ORIG_RAX: 00000000000000a5
RAX: ffffffffffffffda RBX: 00007fbdcc826090 RCX: 00007fbdcc59e159
RDX: 0000000000000000 RSI: 0000200000000240 RDI: 0000000000000000
RBP: 00007fbdcc63506b R08: 0000000000000000 R09: 0000000000000000
R10: 0000000000000000 R11: 0000000000000246 R12: 0000000000000000
R13: 00007fbdcc826128 R14: 00007fbdcc826090 R15: 00007ffda8e823c8
 </TASK>
INFO: task syz.2.19:5875 blocked for more than 143 seconds.
      Not tainted syzkaller #0
"echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
task:syz.2.19        state:D stack:28808 pid:5875  tgid:5870  ppid:5740   task_flags:0x400140 flags:0x00080002
Call Trace:
 <TASK>
 context_switch kernel/sched/core.c:5526 [inline]
 __schedule+0x17dd/0x5940 kernel/sched/core.c:7277
 __schedule_loop kernel/sched/core.c:7354 [inline]
 schedule+0x164/0x2b0 kernel/sched/core.c:7369
 schedule_preempt_disabled+0x13/0x30 kernel/sched/core.c:7426
 rwsem_down_read_slowpath+0x6d8/0x980 kernel/locking/rwsem.c:1114
 __down_read_common kernel/locking/rwsem.c:1291 [inline]
 __down_read kernel/locking/rwsem.c:1304 [inline]
 down_read+0x9c/0x330 kernel/locking/rwsem.c:1576
 inode_lock_shared include/linux/fs.h:1039 [inline]
 lookup_slow+0x46/0x70 fs/namei.c:1935
 walk_component fs/namei.c:2282 [inline]
 lookup_last fs/namei.c:2789 [inline]
 path_lookupat+0x3f5/0x8c0 fs/namei.c:2813
 filename_lookup+0x265/0x5d0 fs/namei.c:2842
 user_path_at+0x40/0x160 fs/namei.c:3641
 do_mount fs/namespace.c:4178 [inline]
 __do_sys_mount fs/namespace.c:4395 [inline]
 __se_sys_mount+0x2dc/0x420 fs/namespace.c:4372
 do_syscall_x64 arch/x86/entry/syscall_64.c:61 [inline]
 do_syscall_64+0x166/0x520 arch/x86/entry/syscall_64.c:84
 entry_SYSCALL_64_after_hwframe+0x77/0x7f
RIP: 0033:0x7fc452d9e159
RSP: 002b:00007fc4523dd028 EFLAGS: 00000246 ORIG_RAX: 00000000000000a5
RAX: ffffffffffffffda RBX: 00007fc453026090 RCX: 00007fc452d9e159
RDX: 0000000000000000 RSI: 0000200000000240 RDI: 0000000000000000
RBP: 00007fc452e3506b R08: 0000000000000000 R09: 0000000000000000
R10: 0000000000000000 R11: 0000000000000246 R12: 0000000000000000
R13: 00007fc453026128 R14: 00007fc453026090 R15: 00007ffc4eb10368
 </TASK>
INFO: task syz.0.17:5876 blocked for more than 143 seconds.
      Not tainted syzkaller #0
"echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
task:syz.0.17        state:D stack:28808 pid:5876  tgid:5873  ppid:5736   task_flags:0x400140 flags:0x00080002
Call Trace:
 <TASK>
 context_switch kernel/sched/core.c:5526 [inline]
 __schedule+0x17dd/0x5940 kernel/sched/core.c:7277
 __schedule_loop kernel/sched/core.c:7354 [inline]
 schedule+0x164/0x2b0 kernel/sched/core.c:7369
 schedule_preempt_disabled+0x13/0x30 kernel/sched/core.c:7426
 rwsem_down_read_slowpath+0x6d8/0x980 kernel/locking/rwsem.c:1114
 __down_read_common kernel/locking/rwsem.c:1291 [inline]
 __down_read kernel/locking/rwsem.c:1304 [inline]
 down_read+0x9c/0x330 kernel/locking/rwsem.c:1576
 inode_lock_shared include/linux/fs.h:1039 [inline]
 lookup_slow+0x46/0x70 fs/namei.c:1935
 walk_component fs/namei.c:2282 [inline]
 lookup_last fs/namei.c:2789 [inline]
 path_lookupat+0x3f5/0x8c0 fs/namei.c:2813
 filename_lookup+0x265/0x5d0 fs/namei.c:2842
 user_path_at+0x40/0x160 fs/namei.c:3641
 do_mount fs/namespace.c:4178 [inline]
 __do_sys_mount fs/namespace.c:4395 [inline]
 __se_sys_mount+0x2dc/0x420 fs/namespace.c:4372
 do_syscall_x64 arch/x86/entry/syscall_64.c:61 [inline]
 do_syscall_64+0x166/0x520 arch/x86/entry/syscall_64.c:84
 entry_SYSCALL_64_after_hwframe+0x77/0x7f
RIP: 0033:0x7f615a79e159
RSP: 002b:00007f615b674028 EFLAGS: 00000246 ORIG_RAX: 00000000000000a5
RAX: ffffffffffffffda RBX: 00007f615aa26090 RCX: 00007f615a79e159
RDX: 0000000000000000 RSI: 0000200000000240 RDI: 0000000000000000
RBP: 00007f615a83506b R08: 0000000000000000 R09: 0000000000000000
R10: 0000000000000000 R11: 0000000000000246 R12: 0000000000000000
R13: 00007f615aa26128 R14: 00007f615aa26090 R15: 00007ffc43a846c8
 </TASK>

Showing all locks held in the system:
locks held by khungtaskd/35: 1, last CPU#1:
 #0: ffffffff8ed5c8e0 (rcu_read_lock){....}-{1:3}, at: rcu_lock_acquire include/linux/rcupdate.h:309 [inline]
 #0: ffffffff8ed5c8e0 (rcu_read_lock){....}-{1:3}, at: rcu_read_lock include/linux/rcupdate.h:849 [inline]
 #0: ffffffff8ed5c8e0 (rcu_read_lock){....}-{1:3}, at: debug_show_all_locks+0x2e/0x180 kernel/locking/lockdep.c:6871
locks held by kworker/u10:6/1113: 2, on CPU#1:
 #0: ffff8881000ac140 ((wq_completion)events_unbound){+.+.}-{0:0}, at: rcu_lock_acquire include/linux/rcupdate.h:309 [inline]
 #0: ffff8881000ac140 ((wq_completion)events_unbound){+.+.}-{0:0}, at: rcu_read_lock include/linux/rcupdate.h:849 [inline]
 #0: ffff8881000ac140 ((wq_completion)events_unbound){+.+.}-{0:0}, at: process_one_work kernel/workqueue.c:3361 [inline]
 #0: ffff8881000ac140 ((wq_completion)events_unbound){+.+.}-{0:0}, at: process_scheduled_works+0x97a/0x1630 kernel/workqueue.c:3479
 #1: ffffc90006fb7c40 ((work_completion)(&sub_info->work)){+.+.}-{0:0}, at: rcu_lock_acquire include/linux/rcupdate.h:309 [inline]
 #1: ffffc90006fb7c40 ((work_completion)(&sub_info->work)){+.+.}-{0:0}, at: rcu_read_lock include/linux/rcupdate.h:849 [inline]
 #1: ffffc90006fb7c40 ((work_completion)(&sub_info->work)){+.+.}-{0:0}, at: process_one_work kernel/workqueue.c:3361 [inline]
 #1: ffffc90006fb7c40 ((work_completion)(&sub_info->work)){+.+.}-{0:0}, at: process_scheduled_works+0x97a/0x1630 kernel/workqueue.c:3479
locks held by getty/5423: 2, on CPU#1:
 #0: ffff888175c4b0a0 (&tty->ldisc_sem){++++}-{0:0}, at: tty_ldisc_ref_wait+0x25/0x70 drivers/tty/tty_ldisc.c:243
 #1: ffffc900034762e8 (&ldata->atomic_read_lock){+.+.}-{4:4}, at: n_tty_read+0x45a/0x1360 drivers/tty/n_tty.c:2211
locks held by syz.1.18/5812: 2, last CPU#1:
 #0: ffff8881a249b7c0 (&type->i_mutex_dir_key#8/1){+.+.}-{4:4}, at: inode_lock_nested include/linux/fs.h:1069 [inline]
 #0: ffff8881a249b7c0 (&type->i_mutex_dir_key#8/1){+.+.}-{4:4}, at: __start_dirop fs/namei.c:2918 [inline]
 #0: ffff8881a249b7c0 (&type->i_mutex_dir_key#8/1){+.+.}-{4:4}, at: start_dirop fs/namei.c:2942 [inline]
 #0: ffff8881a249b7c0 (&type->i_mutex_dir_key#8/1){+.+.}-{4:4}, at: filename_create+0x200/0x370 fs/namei.c:5101
 #1: ffffffff8eea5ca0 (mmu_notifier_invalidate_range_start){+.+.}-{0:0}, at: fs_reclaim_acquire+0x7c/0x100 mm/page_alloc.c:4392
locks held by syz.1.18/5813: 1, on CPU#0:
 #0: ffff8881a249b7c0 (&type->i_mutex_dir_key#9){.+.+}-{4:4}, at: inode_lock_shared include/linux/fs.h:1039 [inline]
 #0: ffff8881a249b7c0 (&type->i_mutex_dir_key#9){.+.+}-{4:4}, at: lookup_slow+0x46/0x70 fs/namei.c:1935
locks held by syz.2.19/5871: 1, last CPU#0:
 #0: ffff8881a249b2d0 (&type->i_mutex_dir_key#8/1){+.+.}-{4:4}, at: inode_lock_nested include/linux/fs.h:1069 [inline]
 #0: ffff8881a249b2d0 (&type->i_mutex_dir_key#8/1){+.+.}-{4:4}, at: __start_dirop fs/namei.c:2918 [inline]
 #0: ffff8881a249b2d0 (&type->i_mutex_dir_key#8/1){+.+.}-{4:4}, at: start_dirop fs/namei.c:2942 [inline]
 #0: ffff8881a249b2d0 (&type->i_mutex_dir_key#8/1){+.+.}-{4:4}, at: filename_create+0x200/0x370 fs/namei.c:5101
locks held by syz.2.19/5875: 1, on CPU#1:
 #0: ffff8881a249b2d0 (&type->i_mutex_dir_key#9){.+.+}-{4:4}, at: inode_lock_shared include/linux/fs.h:1039 [inline]
 #0: ffff8881a249b2d0 (&type->i_mutex_dir_key#9){.+.+}-{4:4}, at: lookup_slow+0x46/0x70 fs/namei.c:1935
locks held by syz.0.17/5874: 1, last CPU#1:
 #0: ffff8881189eb7c0 (&type->i_mutex_dir_key#8/1){+.+.}-{4:4}, at: inode_lock_nested include/linux/fs.h:1069 [inline]
 #0: ffff8881189eb7c0 (&type->i_mutex_dir_key#8/1){+.+.}-{4:4}, at: __start_dirop fs/namei.c:2918 [inline]
 #0: ffff8881189eb7c0 (&type->i_mutex_dir_key#8/1){+.+.}-{4:4}, at: start_dirop fs/namei.c:2942 [inline]
 #0: ffff8881189eb7c0 (&type->i_mutex_dir_key#8/1){+.+.}-{4:4}, at: filename_create+0x200/0x370 fs/namei.c:5101
locks held by syz.0.17/5876: 1, on CPU#1:
 #0: ffff8881189eb7c0 (&type->i_mutex_dir_key#9){.+.+}-{4:4}, at: inode_lock_shared include/linux/fs.h:1039 [inline]
 #0: ffff8881189eb7c0 (&type->i_mutex_dir_key#9){.+.+}-{4:4}, at: lookup_slow+0x46/0x70 fs/namei.c:1935
locks held by syz.3.20/5940: 1, last CPU#1:
 #0: ffff8881189eb2d0 (&type->i_mutex_dir_key#8/1){+.+.}-{4:4}, at: inode_lock_nested include/linux/fs.h:1069 [inline]
 #0: ffff8881189eb2d0 (&type->i_mutex_dir_key#8/1){+.+.}-{4:4}, at: __start_dirop fs/namei.c:2918 [inline]
 #0: ffff8881189eb2d0 (&type->i_mutex_dir_key#8/1){+.+.}-{4:4}, at: start_dirop fs/namei.c:2942 [inline]
 #0: ffff8881189eb2d0 (&type->i_mutex_dir_key#8/1){+.+.}-{4:4}, at: filename_create+0x200/0x370 fs/namei.c:5101
locks held by syz.3.20/5941: 1, on CPU#0:
 #0: ffff8881189eb2d0 (&type->i_mutex_dir_key#9){.+.+}-{4:4}, at: inode_lock_shared include/linux/fs.h:1039 [inline]
 #0: ffff8881189eb2d0 (&type->i_mutex_dir_key#9){.+.+}-{4:4}, at: lookup_slow+0x46/0x70 fs/namei.c:1935
locks held by syz.5.22/6003: 1, last CPU#0:
 #0: ffff8881a249ade0 (&type->i_mutex_dir_key#8/1){+.+.}-{4:4}, at: inode_lock_nested include/linux/fs.h:1069 [inline]
 #0: ffff8881a249ade0 (&type->i_mutex_dir_key#8/1){+.+.}-{4:4}, at: __start_dirop fs/namei.c:2918 [inline]
 #0: ffff8881a249ade0 (&type->i_mutex_dir_key#8/1){+.+.}-{4:4}, at: start_dirop fs/namei.c:2942 [inline]
 #0: ffff8881a249ade0 (&type->i_mutex_dir_key#8/1){+.+.}-{4:4}, at: filename_create+0x200/0x370 fs/namei.c:5101
locks held by syz.5.22/6004: 1, on CPU#0:
 #0: ffff8881a249ade0 (&type->i_mutex_dir_key#9){.+.+}-{4:4}, at: inode_lock_shared include/linux/fs.h:1039 [inline]
 #0: ffff8881a249ade0 (&type->i_mutex_dir_key#9){.+.+}-{4:4}, at: lookup_slow+0x46/0x70 fs/namei.c:1935
locks held by syz.4.21/6006: 1, last CPU#1:
 #0: ffff8881189eade0 (&type->i_mutex_dir_key#8/1){+.+.}-{4:4}, at: inode_lock_nested include/linux/fs.h:1069 [inline]
 #0: ffff8881189eade0 (&type->i_mutex_dir_key#8/1){+.+.}-{4:4}, at: __start_dirop fs/namei.c:2918 [inline]
 #0: ffff8881189eade0 (&type->i_mutex_dir_key#8/1){+.+.}-{4:4}, at: start_dirop fs/namei.c:2942 [inline]
 #0: ffff8881189eade0 (&type->i_mutex_dir_key#8/1){+.+.}-{4:4}, at: filename_create+0x200/0x370 fs/namei.c:5101
locks held by syz.4.21/6007: 1, on CPU#0:
 #0: ffff8881189eade0 (&type->i_mutex_dir_key#9){.+.+}-{4:4}, at: inode_lock_shared include/linux/fs.h:1039 [inline]
 #0: ffff8881189eade0 (&type->i_mutex_dir_key#9){.+.+}-{4:4}, at: lookup_slow+0x46/0x70 fs/namei.c:1935
locks held by syz.6.23/6053: 2, last CPU#0:
 #0: ffff8881a249a8f0 (&type->i_mutex_dir_key#8/1){+.+.}-{4:4}, at: inode_lock_nested include/linux/fs.h:1069 [inline]
 #0: ffff8881a249a8f0 (&type->i_mutex_dir_key#8/1){+.+.}-{4:4}, at: __start_dirop fs/namei.c:2918 [inline]
 #0: ffff8881a249a8f0 (&type->i_mutex_dir_key#8/1){+.+.}-{4:4}, at: start_dirop fs/namei.c:2942 [inline]
 #0: ffff8881a249a8f0 (&type->i_mutex_dir_key#8/1){+.+.}-{4:4}, at: filename_create+0x200/0x370 fs/namei.c:5101
 #1: ffffffff8eea5ca0 (mmu_notifier_invalidate_range_start){+.+.}-{0:0}, at: fs_reclaim_acquire+0x7c/0x100 mm/page_alloc.c:4392
locks held by syz.6.23/6057: 1, on CPU#1:
 #0: ffff8881a249a8f0 (&type->i_mutex_dir_key#9){.+.+}-{4:4}, at: inode_lock_shared include/linux/fs.h:1039 [inline]
 #0: ffff8881a249a8f0 (&type->i_mutex_dir_key#9){.+.+}-{4:4}, at: lookup_slow+0x46/0x70 fs/namei.c:1935
locks held by syz.7.24/6135: 1, last CPU#0:
 #0: ffff8881a249a400 (&type->i_mutex_dir_key#8/1){+.+.}-{4:4}, at: inode_lock_nested include/linux/fs.h:1069 [inline]
 #0: ffff8881a249a400 (&type->i_mutex_dir_key#8/1){+.+.}-{4:4}, at: __start_dirop fs/namei.c:2918 [inline]
 #0: ffff8881a249a400 (&type->i_mutex_dir_key#8/1){+.+.}-{4:4}, at: start_dirop fs/namei.c:2942 [inline]
 #0: ffff8881a249a400 (&type->i_mutex_dir_key#8/1){+.+.}-{4:4}, at: filename_create+0x200/0x370 fs/namei.c:5101
locks held by syz.7.24/6136: 1, on CPU#1:
 #0: ffff8881a249a400 (&type->i_mutex_dir_key#9){.+.+}-{4:4}, at: inode_lock_shared include/linux/fs.h:1039 [inline]
 #0: ffff8881a249a400 (&type->i_mutex_dir_key#9){.+.+}-{4:4}, at: lookup_slow+0x46/0x70 fs/namei.c:1935
locks held by syz.8.25/6138: 1, last CPU#0:
 #0: ffff8881a2499f10 (&type->i_mutex_dir_key#8/1){+.+.}-{4:4}, at: inode_lock_nested include/linux/fs.h:1069 [inline]
 #0: ffff8881a2499f10 (&type->i_mutex_dir_key#8/1){+.+.}-{4:4}, at: __start_dirop fs/namei.c:2918 [inline]
 #0: ffff8881a2499f10 (&type->i_mutex_dir_key#8/1){+.+.}-{4:4}, at: start_dirop fs/namei.c:2942 [inline]
 #0: ffff8881a2499f10 (&type->i_mutex_dir_key#8/1){+.+.}-{4:4}, at: filename_create+0x200/0x370 fs/namei.c:5101
locks held by syz.8.25/6139: 1, on CPU#0:
 #0: ffff8881a2499f10 (&type->i_mutex_dir_key#9){.+.+}-{4:4}, at: inode_lock_shared include/linux/fs.h:1039 [inline]
 #0: ffff8881a2499f10 (&type->i_mutex_dir_key#9){.+.+}-{4:4}, at: lookup_slow+0x46/0x70 fs/namei.c:1935
locks held by syz.9.26/6183: 1, last CPU#1:
 #0: ffff8881189ea8f0 (&type->i_mutex_dir_key#8/1){+.+.}-{4:4}, at: inode_lock_nested include/linux/fs.h:1069 [inline]
 #0: ffff8881189ea8f0 (&type->i_mutex_dir_key#8/1){+.+.}-{4:4}, at: __start_dirop fs/namei.c:2918 [inline]
 #0: ffff8881189ea8f0 (&type->i_mutex_dir_key#8/1){+.+.}-{4:4}, at: start_dirop fs/namei.c:2942 [inline]
 #0: ffff8881189ea8f0 (&type->i_mutex_dir_key#8/1){+.+.}-{4:4}, at: filename_create+0x200/0x370 fs/namei.c:5101
locks held by syz.9.26/6184: 1, on CPU#0:
 #0: ffff8881189ea8f0 (&type->i_mutex_dir_key#9){.+.+}-{4:4}, at: inode_lock_shared include/linux/fs.h:1039 [inline]
 #0: ffff8881189ea8f0 (&type->i_mutex_dir_key#9){.+.+}-{4:4}, at: lookup_slow+0x46/0x70 fs/namei.c:1935
locks held by syz.1.815/8671: 1, last CPU#0:
 #0: ffff88810ecf03b8 (&mm->mmap_lock){++++}-{4:4}, at: mmap_write_lock include/linux/mmap_lock.h:544 [inline]
 #0: ffff88810ecf03b8 (&mm->mmap_lock){++++}-{4:4}, at: exit_mmap+0x2d8/0x9f0 mm/mmap.c:1323
locks held by syz.2.816/8673: 1, on CPU#1:
 #0: ffffffff8f4f0ed8 (tomoyo_ss){.+.+}-{0:0}, at: srcu_lock_acquire include/linux/srcu.h:198 [inline]
 #0: ffffffff8f4f0ed8 (tomoyo_ss){.+.+}-{0:0}, at: srcu_read_lock include/linux/srcu.h:305 [inline]
 #0: ffffffff8f4f0ed8 (tomoyo_ss){.+.+}-{0:0}, at: tomoyo_read_lock security/tomoyo/common.h:1112 [inline]
 #0: ffffffff8f4f0ed8 (tomoyo_ss){.+.+}-{0:0}, at: tomoyo_mount_permission+0x2b5/0x9e0 security/tomoyo/mount.c:238
locks held by modprobe/8675: 1, last CPU#1:
 #0: ffff88817439f678 (&mm->mmap_lock){++++}-{4:4}, at: mmap_write_lock include/linux/mmap_lock.h:544 [inline]
 #0: ffff88817439f678 (&mm->mmap_lock){++++}-{4:4}, at: exit_mmap+0x2d8/0x9f0 mm/mmap.c:1323

=============================================

NMI backtrace for cpu 1
CPU: 1 UID: 0 PID: 35 Comm: khungtaskd Not tainted syzkaller #0 PREEMPT(full) 
Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS 1.16.2-debian-1.16.2-1 04/01/2014
Call Trace:
 <TASK>
 dump_stack_lvl+0xe8/0x150 lib/dump_stack.c:120
 nmi_cpu_backtrace+0x274/0x2d0 lib/nmi_backtrace.c:123
 nmi_trigger_cpumask_backtrace+0x17d/0x390 lib/nmi_backtrace.c:66
 trigger_all_cpu_backtrace include/linux/nmi.h:164 [inline]
 __sys_info lib/sys_info.c:157 [inline]
 sys_info+0x135/0x170 lib/sys_info.c:165
 check_hung_uninterruptible_tasks kernel/hung_task.c:353 [inline]
 watchdog+0xfd7/0x1030 kernel/hung_task.c:561
 kthread+0x38b/0x480 kernel/kthread.c:436
 ret_from_fork+0x514/0xb70 arch/x86/kernel/process.c:158
 ret_from_fork_asm+0x1a/0x30 arch/x86/entry/entry_64.S:245
 </TASK>
Sending NMI from CPU 1 to CPUs 0:
NMI backtrace for cpu 0
CPU: 0 UID: 0 PID: 6138 Comm: syz.8.25 Not tainted syzkaller #0 PREEMPT(full) 
Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS 1.16.2-debian-1.16.2-1 04/01/2014
RIP: 0010:__sanitizer_cov_trace_const_cmp8+0x0/0xa0 kernel/kcov.c:316
Code: 74 0a 18 48 89 44 0a 20 c3 cc cc cc cc cc 66 66 66 2e 0f 1f 84 00 00 00 00 00 90 90 90 90 90 90 90 90 90 90 90 90 90 90 90 90 <f3> 0f 1e fa 48 8b 04 24 65 48 8b 0d 18 1e cd 11 65 48 8b 15 18 1e
RSP: 0018:ffffc900043df9b8 EFLAGS: 00000246
RAX: f8f8f8f8f8f8f8f8 RBX: ffff8881a2499dd0 RCX: ffff88816b385a00
RDX: 0000000000000000 RSI: 0000000000000022 RDI: 0000000000000000
RBP: ffffc900043dfb30 R08: ffffc900043dfa07 R09: 1ffff9200087bf40
R10: dffffc0000000000 R11: fffff5200087bf41 R12: 1ffff9200087bf38
R13: dffffc0000000000 R14: 0000000000000022 R15: ffffc900043dfa00
FS:  00007f875414d6c0(0000) GS:ffff88818d6d0000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 00007fcd7861f440 CR3: 00000001beb7a000 CR4: 00000000000006f0
Call Trace:
 <TASK>
 isofs_bread+0x15e/0x270 fs/isofs/inode.c:1143
 isofs_find_entry fs/isofs/namei.c:72 [inline]
 isofs_lookup+0x260/0xdc0 fs/isofs/namei.c:162
 lookup_one_qstr_excl+0x12d/0x360 fs/namei.c:1810
 __start_dirop fs/namei.c:2920 [inline]
 start_dirop fs/namei.c:2942 [inline]
 filename_create+0x20e/0x370 fs/namei.c:5101
 filename_mkdirat+0xd2/0x510 fs/namei.c:5445
 __do_sys_mkdirat fs/namei.c:5473 [inline]
 __se_sys_mkdirat+0x35/0x150 fs/namei.c:5470
 do_syscall_x64 arch/x86/entry/syscall_64.c:61 [inline]
 do_syscall_64+0x166/0x520 arch/x86/entry/syscall_64.c:84
 entry_SYSCALL_64_after_hwframe+0x77/0x7f
RIP: 0033:0x7f875319e159
Code: ff c3 66 2e 0f 1f 84 00 00 00 00 00 0f 1f 44 00 00 48 89 f8 48 89 f7 48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 ff ff 73 01 c3 48 c7 c1 e8 ff ff ff f7 d8 64 89 01 48
RSP: 002b:00007f875414d028 EFLAGS: 00000246 ORIG_RAX: 0000000000000102
RAX: ffffffffffffffda RBX: 00007f8753425fa0 RCX: 00007f875319e159
RDX: 00000000000001ff RSI: 0000200000000200 RDI: ffffffffffffff9c
RBP: 00007f875323506b R08: 0000000000000000 R09: 0000000000000000
R10: 0000000000000000 R11: 0000000000000246 R12: 0000000000000000
R13: 00007f8753426038 R14: 00007f8753425fa0 R15: 00007ffc77a2a958
 </TASK>


***

If these findings have caused you to resend the series or submit a
separate fix, please add the following tag to your commit message:
  Tested-by: syzbot@syzkaller.appspotmail.com

---
This report is generated by a bot. It may contain errors.
syzbot ci engineers can be reached at syzkaller@googlegroups.com.

To test a fix for this bug, please reply with `#syz test`
(on a separate line) and attach the patch to the email.

Notes:
- The patch will be applied on top of the tested series (as an
  incremental fix).
- To test a new version of the whole series, please send it directly
  to syzbot@lists.linux.dev.
- Arguments like custom git repos and branches are not supported.

The email will later be sent to:
[jack@suse.cz linux-fsdevel@vger.kernel.org matthias.goergens@gmail.com scdbackup@gmx.net]

If the report looks fine to you, reply with:
#syz upstream

If the report is a false positive, reply with
#syz invalid

