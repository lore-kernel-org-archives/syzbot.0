Received: from mail-io1-f72.google.com (mail-io1-f72.google.com [209.85.166.72])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B925C2EA156
	for <syzbot@lists.linux.dev>; Fri, 21 Nov 2025 07:55:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.72
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763711759; cv=none; b=cS4cfYnlfD9ZqHtdCucocKsLgZKa0UYglHtcuBa1e1PfpplKHJqC8tE/c+D3omKsjglyxwbEv2/QdRobqRzFXiE4Uj25LxaoQGnraWtPf9M63jT3CgZaTMk8l+gorZ7O674kE+7LPcsXKaVsHZWUUNZHqINyCiEoo3Q/D36bMzw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763711759; c=relaxed/simple;
	bh=FnRwfxDQdWaLVNflYMbs1g96Y9dNq11XX8mpEYFLhhc=;
	h=MIME-Version:Date:Message-ID:Subject:From:To:Cc:Content-Type; b=fkXqcH90e8oEgffLuKDEmNVRYp7K6+MYj8RnmMqUTJZUV3Ud9SDtHva7uVf1GbRHBJjb3hdiumdEwM++ETLjXiOtKKj4hBmqmT/zlnCTSWnK9pD7LQCoNwSWaafPW+U0Od0FR3EOZl+esHctnPY+Je2GdB3n+AZcx2ctZXDi1eI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com; arc=none smtp.client-ip=209.85.166.72
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com
Received: by mail-io1-f72.google.com with SMTP id ca18e2360f4ac-9486ebd1e4dso137105739f.3
        for <syzbot@lists.linux.dev>; Thu, 20 Nov 2025 23:55:57 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1763711757; x=1764316557;
        h=cc:to:from:subject:message-id:date:mime-version:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=+BJLjbxjzOiZDNyDXlvka5QnZbBn6KUtz0lNaeHybbc=;
        b=wQjTKF174H/2SHBreiBSEZszm2+1yFInPpyAKoyD51oF4tZ3qidkgl2TM+/kKCE0sN
         BOxTuQBJS3/g6Oi2uHo+/IwFe4ESBQrfQgmW40jabUPA+++jvhMxzYX6wheS7R/OJ90G
         a4j1PWqW5gK/s2PD88WOuTTsK333myTviorTD4xv3vlorYqdcrTHeAInvc1R0GrNHOev
         S103f+V9CD6FLjUMJNFSnY6vscQnKizUzHu3Gd/xkn3J675LynJg6J8bAn1BhFwIq7cZ
         CU+RwAy/0MU9DqeO5BXQyAtss0RbsDDX7KLryH1+xighqAR/gbEHzZ2tTdGOY3P/k6cj
         uSOA==
X-Gm-Message-State: AOJu0YwtbopdvjW6AbJjha9I9KDkQXGfdvZBQnPOyiDTtehd9CbmQCVi
	wamJSGliGvc3Hai7v0sEoTTk61rvKWNhfdzCmVhxVKcY8993rBYEmU+2mhCxYiPMasiNE9+8yNC
	400T/qn9FrZVuG4RfZn4HmV+p5TCcHEh0Xarnd/5ZG+OeZjPmBMbxNvfhh54=
X-Google-Smtp-Source: AGHT+IGL3/GhbXWp5UDWU0WV4chkm99bj6e1rd43QWmbpUfHlhL6JEZ13HlcFUddamIs7VvotpC0iqYTzT3lwWbDURvUMmoRliVU
Precedence: bulk
X-Mailing-List: syzbot@lists.linux.dev
List-Id: <syzbot.lists.linux.dev>
List-Subscribe: <mailto:syzbot+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:syzbot+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Received: by 2002:a05:6e02:3989:b0:433:795e:2da with SMTP id
 e9e14a558f8ab-435b8e3da56mr13003145ab.3.1763711756827; Thu, 20 Nov 2025
 23:55:56 -0800 (PST)
Date: Thu, 20 Nov 2025 23:55:56 -0800
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <69201b0c.a70a0220.d98e3.003f.GAE@google.com>
Subject: [moderation/CI] Re: blk-mq: fix possible deadlocks
From: syzbot ci <syzbot+ci6b86736420e479a5@syzkaller.appspotmail.com>
To: syzkaller-upstream-moderation@googlegroups.com
Cc: syzbot@lists.linux.dev
Content-Type: text/plain; charset="UTF-8"

syzbot ci has tested the following series

[v2] blk-mq: fix possible deadlocks
https://lore.kernel.org/all/20251121062829.1433332-1-yukuai@fnnas.com
* [PATCH v2 1/9] blk-mq-debugfs: factor out a helper to register debugfs for all rq_qos
* [PATCH v2 2/9] blk-rq-qos: fix possible debugfs_mutex deadlock
* [PATCH v2 3/9] blk-mq-debugfs: make blk_mq_debugfs_register_rqos() static
* [PATCH v2 4/9] blk-mq-debugfs: warn about possible deadlock
* [PATCH v2 5/9] block/blk-rq-qos: add a new helper rq_qos_add_frozen()
* [PATCH v2 6/9] blk-wbt: fix incorrect lock order for rq_qos_mutex and freeze queue
* [PATCH v2 7/9] blk-iocost: fix incorrect lock order for rq_qos_mutex and freeze queue
* [PATCH v2 8/9] blk-iolatency: fix incorrect lock order for rq_qos_mutex and freeze queue
* [PATCH v2 9/9] block/blk-rq-qos: cleanup rq_qos_add()

and found the following issue:
possible deadlock in pcpu_alloc_noprof

Full report is available here:
https://ci.syzbot.org/series/162b3190-cad9-45ce-843d-4ffb08b0d52e

***

possible deadlock in pcpu_alloc_noprof

tree:      torvalds
URL:       https://kernel.googlesource.com/pub/scm/linux/kernel/git/torvalds/linux
base:      23cb64fb76257309e396ea4cec8396d4a1dbae68
arch:      amd64
compiler:  Debian clang version 20.1.8 (++20250708063551+0c9f909b7976-1~exp1~20250708183702.136), Debian LLD 20.1.8
config:    https://ci.syzbot.org/builds/03f7d9f4-1663-4b30-aa9e-5333289a7df2/config

======================================================
WARNING: possible circular locking dependency detected
syzkaller #0 Not tainted
------------------------------------------------------
syz-executor/5988 is trying to acquire lock:
ffffffff8e046120 (fs_reclaim){+.+.}-{0:0}, at: prepare_alloc_pages+0x153/0x610

but task is already holding lock:
ffffffff8e025608 (pcpu_alloc_mutex){+.+.}-{4:4}, at: pcpu_alloc_noprof+0x286/0x1720

which lock already depends on the new lock.


the existing dependency chain (in reverse order) is:

-> #2 (pcpu_alloc_mutex){+.+.}-{4:4}:
       lock_acquire+0x120/0x360
       __mutex_lock+0x187/0x1350
       pcpu_alloc_noprof+0x286/0x1720
       blk_stat_alloc_callback+0xd5/0x220
       wbt_init+0xa3/0x500
       wbt_enable_default+0x25d/0x350
       blk_register_queue+0x36a/0x3f0
       __add_disk+0x677/0xd50
       add_disk_fwnode+0xfc/0x480
       loop_add+0x7f0/0xad0
       loop_init+0xd9/0x170
       do_one_initcall+0x236/0x820
       do_initcall_level+0x104/0x190
       do_initcalls+0x59/0xa0
       kernel_init_freeable+0x334/0x4b0
       kernel_init+0x1d/0x1d0
       ret_from_fork+0x4bc/0x870
       ret_from_fork_asm+0x1a/0x30

-> #1 (&q->q_usage_counter(io)#17){++++}-{0:0}:
       lock_acquire+0x120/0x360
       blk_alloc_queue+0x538/0x620
       __blk_mq_alloc_disk+0x15c/0x340
       loop_add+0x411/0xad0
       loop_init+0xd9/0x170
       do_one_initcall+0x236/0x820
       do_initcall_level+0x104/0x190
       do_initcalls+0x59/0xa0
       kernel_init_freeable+0x334/0x4b0
       kernel_init+0x1d/0x1d0
       ret_from_fork+0x4bc/0x870
       ret_from_fork_asm+0x1a/0x30

-> #0 (fs_reclaim){+.+.}-{0:0}:
       validate_chain+0xb9b/0x2140
       __lock_acquire+0xab9/0xd20
       lock_acquire+0x120/0x360
       fs_reclaim_acquire+0x72/0x100
       prepare_alloc_pages+0x153/0x610
       __alloc_frozen_pages_noprof+0x123/0x370
       __alloc_pages_noprof+0xa/0x30
       pcpu_populate_chunk+0x182/0xb30
       pcpu_alloc_noprof+0xcbf/0x1720
       xt_percpu_counter_alloc+0x161/0x220
       translate_table+0x1323/0x2040
       ip6t_register_table+0x106/0x7d0
       ip6table_filter_table_init+0x75/0xb0
       xt_find_table_lock+0x30c/0x3e0
       xt_request_find_table_lock+0x26/0x100
       do_ip6t_get_ctl+0x730/0x1180
       nf_getsockopt+0x26e/0x290
       ipv6_getsockopt+0x1ed/0x290
       do_sock_getsockopt+0x372/0x450
       __x64_sys_getsockopt+0x1a5/0x250
       do_syscall_64+0xfa/0xfa0
       entry_SYSCALL_64_after_hwframe+0x77/0x7f

other info that might help us debug this:

Chain exists of:
  fs_reclaim --> &q->q_usage_counter(io)#17 --> pcpu_alloc_mutex

 Possible unsafe locking scenario:

       CPU0                    CPU1
       ----                    ----
  lock(pcpu_alloc_mutex);
                               lock(&q->q_usage_counter(io)#17);
                               lock(pcpu_alloc_mutex);
  lock(fs_reclaim);

 *** DEADLOCK ***

1 lock held by syz-executor/5988:
 #0: ffffffff8e025608 (pcpu_alloc_mutex){+.+.}-{4:4}, at: pcpu_alloc_noprof+0x286/0x1720

stack backtrace:
CPU: 1 UID: 0 PID: 5988 Comm: syz-executor Not tainted syzkaller #0 PREEMPT(full) 
Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS 1.16.2-debian-1.16.2-1 04/01/2014
Call Trace:
 <TASK>
 dump_stack_lvl+0x189/0x250
 print_circular_bug+0x2ee/0x310
 check_noncircular+0x134/0x160
 validate_chain+0xb9b/0x2140
 __lock_acquire+0xab9/0xd20
 lock_acquire+0x120/0x360
 fs_reclaim_acquire+0x72/0x100
 prepare_alloc_pages+0x153/0x610
 __alloc_frozen_pages_noprof+0x123/0x370
 __alloc_pages_noprof+0xa/0x30
 pcpu_populate_chunk+0x182/0xb30
 pcpu_alloc_noprof+0xcbf/0x1720
 xt_percpu_counter_alloc+0x161/0x220
 translate_table+0x1323/0x2040
 ip6t_register_table+0x106/0x7d0
 ip6table_filter_table_init+0x75/0xb0
 xt_find_table_lock+0x30c/0x3e0
 xt_request_find_table_lock+0x26/0x100
 do_ip6t_get_ctl+0x730/0x1180
 nf_getsockopt+0x26e/0x290
 ipv6_getsockopt+0x1ed/0x290
 do_sock_getsockopt+0x372/0x450
 __x64_sys_getsockopt+0x1a5/0x250
 do_syscall_64+0xfa/0xfa0
 entry_SYSCALL_64_after_hwframe+0x77/0x7f
RIP: 0033:0x7fb85019140a
Code: ff c3 66 0f 1f 44 00 00 48 c7 c2 a8 ff ff ff f7 d8 64 89 02 b8 ff ff ff ff eb b8 0f 1f 44 00 00 49 89 ca b8 37 00 00 00 0f 05 <48> 3d 00 f0 ff ff 77 06 c3 0f 1f 44 00 00 48 c7 c2 a8 ff ff ff f7
RSP: 002b:00007fffbe029728 EFLAGS: 00000246 ORIG_RAX: 0000000000000037
RAX: ffffffffffffffda RBX: 0000000000000003 RCX: 00007fb85019140a
RDX: 0000000000000040 RSI: 0000000000000029 RDI: 0000000000000003
RBP: 0000000000000029 R08: 00007fffbe02974c R09: ffffffffffffff00
R10: 00007fb8503b2ca8 R11: 0000000000000246 R12: 00007fb85021340a
R13: 00007fb8503b4e60 R14: 00007fb8503b2ca8 R15: 00007fb8503b2ca0
 </TASK>


***

If these findings have caused you to resend the series or submit a
separate fix, please add the following tag to your commit message:
  Tested-by: syzbot@syzkaller.appspotmail.com

---
This report is generated by a bot. It may contain errors.
syzbot ci engineers can be reached at syzkaller@googlegroups.com.

The email will later be sent to:
[axboe@kernel.dk bvanassche@acm.org linux-block@vger.kernel.org ming.lei@redhat.com nilay@linux.ibm.com tj@kernel.org yukuai@fnnas.com]

If the report looks fine to you, reply with:
#syz upstream

