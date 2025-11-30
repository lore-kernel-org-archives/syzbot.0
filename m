Received: from mail-il1-f197.google.com (mail-il1-f197.google.com [209.85.166.197])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 961516BFCE
	for <syzbot@lists.linux.dev>; Sun, 30 Nov 2025 03:39:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.197
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764473977; cv=none; b=VC2srjXxcdLa8d8DVhzCEaQzBD+VrcGyeSeSUHnpjsMXl8rkAXJZUlxEbbvN0S2gaKaGUPPMjV2L44wg0yYuffgQ2Aww4oI9xolQtStbYASWolHbGKvl9WbfdnohlBW/1tut7LMhGPjIKXEr6aO+gf/hVtDgGS7XQv3x3CCMW18=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764473977; c=relaxed/simple;
	bh=sDpkJIjgEuC2Cit4v93kUBXiXDuLkOMsJ5nUX+9xeTk=;
	h=MIME-Version:Date:Message-ID:Subject:From:To:Cc:Content-Type; b=NS9RSgqgEYZB3/NRbUjQ3xnRlRBEbEUBvQvpL0EjjXuYy7mPseJielRrLJOuda7bTn/IuvYGCUzGUI3xrk3/xzgQUysrpZA7PvBnVLZVUKO75SmZfVEZH9ZhriOsK8oPPdLhdQAjxiwO8JrspCvaFgRDevxiJnsf/RZ1ckoCgzo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com; arc=none smtp.client-ip=209.85.166.197
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com
Received: by mail-il1-f197.google.com with SMTP id e9e14a558f8ab-43470d72247so20830975ab.3
        for <syzbot@lists.linux.dev>; Sat, 29 Nov 2025 19:39:35 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1764473975; x=1765078775;
        h=cc:to:from:subject:message-id:date:mime-version:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=4gb85y3lkKRAQJteh+b/Uv8ukq+wne2x90RejqnsrLM=;
        b=AZNZ9/bnRvRy5l95+ZQRGLtcXnQsFfHtsz9tTvCQrb9vlMz4QTMMpA9FpXMS7H4fME
         3hQGfbnB6HlJdjNH08mPDRNTGSM0Uc9imdhf7rBHlyacmZtKOpJZIitU7uNmRNc5Kfn+
         JBk9yaSRu8kHLBPq6KxA3FdyxgpI4+lFY0thYnmZrJ0zyyrvqoDM2OxoBECKxA9Nxwe3
         4zZNZQEmP94hv7zpBVTWaMRqsSkAOOD5NGp/b9ux2v+ZNUaxom5l4O8NuEa/F2DOUj2p
         6VIRtYBVQ6vyQBA/e29tJZAPdex0TW6awoP8VKZ4OGx03LgsvaQ32rV8U47+5FI+yLnx
         GgoA==
X-Gm-Message-State: AOJu0YwMv4MVEi9jmiSe6J03keIqftDg8wW7Qi/YLpQTavJH1qSeCRuC
	VLhmACzCY/e+JzrYN4m16CNfWud/P/8YvsK3o1Fy09RDIbbEsQQK8A1n9eGW9LC/HwN3h9++i+i
	lEjt4//9AcU6by9RKBy2I2ShNvKFaNSdZ8z65Viq5YhQAFHkyiCahIbFTOSQ=
X-Google-Smtp-Source: AGHT+IHhnJttCs7EPYhrVi96tLpJGoRB1KK0r3TJ53i8uueTc6j6IdBSS8OLeqxNHLN9ZJX1GS46Rdfcq3DU0BjBVx22Otb6yIf+
Precedence: bulk
X-Mailing-List: syzbot@lists.linux.dev
List-Id: <syzbot.lists.linux.dev>
List-Subscribe: <mailto:syzbot+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:syzbot+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Received: by 2002:a05:6e02:3082:b0:433:7c77:be5a with SMTP id
 e9e14a558f8ab-435b8e79f2fmr348842445ab.28.1764473974798; Sat, 29 Nov 2025
 19:39:34 -0800 (PST)
Date: Sat, 29 Nov 2025 19:39:34 -0800
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <692bbc76.050a0220.2ffa18.0015.GAE@google.com>
Subject: [moderation/CI] Re: blk-mq: fix possible deadlocks
From: syzbot ci <syzbot+ci7514c9a05073e23e@syzkaller.appspotmail.com>
To: syzkaller-upstream-moderation@googlegroups.com
Cc: syzbot@lists.linux.dev
Content-Type: text/plain; charset="UTF-8"

syzbot ci has tested the following series

[v3] blk-mq: fix possible deadlocks
https://lore.kernel.org/all/20251130024349.2302128-1-yukuai@fnnas.com
* [PATCH v3 01/10] blk-mq-debugfs: factor out a helper to register debugfs for all rq_qos
* [PATCH v3 02/10] blk-rq-qos: fix possible debugfs_mutex deadlock
* [PATCH v3 03/10] blk-mq-debugfs: make blk_mq_debugfs_register_rqos() static
* [PATCH v3 04/10] blk-mq-debugfs: warn about possible deadlock
* [PATCH v3 05/10] block/blk-rq-qos: add a new helper rq_qos_add_frozen()
* [PATCH v3 06/10] blk-wbt: fix incorrect lock order for rq_qos_mutex and freeze queue
* [PATCH v3 07/10] blk-iocost: fix incorrect lock order for rq_qos_mutex and freeze queue
* [PATCH v3 08/10] blk-iolatency: fix incorrect lock order for rq_qos_mutex and freeze queue
* [PATCH v3 09/10] blk-throttle: remove useless queue frozen
* [PATCH v3 10/10] block/blk-rq-qos: cleanup rq_qos_add()

and found the following issue:
possible deadlock in pcpu_alloc_noprof

Full report is available here:
https://ci.syzbot.org/series/1aec77f0-c53f-4b3b-93fb-b3853983b6bd

***

possible deadlock in pcpu_alloc_noprof

tree:      linux-next
URL:       https://kernel.googlesource.com/pub/scm/linux/kernel/git/next/linux-next
base:      7d31f578f3230f3b7b33b0930b08f9afd8429817
arch:      amd64
compiler:  Debian clang version 20.1.8 (++20250708063551+0c9f909b7976-1~exp1~20250708183702.136), Debian LLD 20.1.8
config:    https://ci.syzbot.org/builds/70dca9e4-6667-4930-9024-150d656e503e/config

soft_limit_in_bytes is deprecated and will be removed. Please report your usecase to linux-mm@kvack.org if you depend on this functionality.
======================================================
WARNING: possible circular locking dependency detected
syzkaller #0 Not tainted
------------------------------------------------------
syz-executor/6047 is trying to acquire lock:
ffffffff8e04f760 (fs_reclaim){+.+.}-{0:0}, at: prepare_alloc_pages+0x152/0x650

but task is already holding lock:
ffffffff8e02dde8 (pcpu_alloc_mutex){+.+.}-{4:4}, at: pcpu_alloc_noprof+0x25b/0x1750

which lock already depends on the new lock.


the existing dependency chain (in reverse order) is:

-> #2 (pcpu_alloc_mutex){+.+.}-{4:4}:
       __mutex_lock+0x187/0x1350
       pcpu_alloc_noprof+0x25b/0x1750
       blk_stat_alloc_callback+0xd5/0x220
       wbt_init+0xa3/0x500
       wbt_enable_default+0x25d/0x350
       blk_register_queue+0x36a/0x3f0
       __add_disk+0x677/0xd50
       add_disk_fwnode+0xfc/0x480
       loop_add+0x7f0/0xad0
       loop_init+0xd9/0x170
       do_one_initcall+0x1fb/0x820
       do_initcall_level+0x104/0x190
       do_initcalls+0x59/0xa0
       kernel_init_freeable+0x334/0x4b0
       kernel_init+0x1d/0x1d0
       ret_from_fork+0x599/0xb30
       ret_from_fork_asm+0x1a/0x30

-> #1 (&q->q_usage_counter(io)#17){++++}-{0:0}:
       blk_alloc_queue+0x538/0x620
       __blk_mq_alloc_disk+0x15c/0x340
       loop_add+0x411/0xad0
       loop_init+0xd9/0x170
       do_one_initcall+0x1fb/0x820
       do_initcall_level+0x104/0x190
       do_initcalls+0x59/0xa0
       kernel_init_freeable+0x334/0x4b0
       kernel_init+0x1d/0x1d0
       ret_from_fork+0x599/0xb30
       ret_from_fork_asm+0x1a/0x30

-> #0 (fs_reclaim){+.+.}-{0:0}:
       __lock_acquire+0x15a6/0x2cf0
       lock_acquire+0x117/0x340
       fs_reclaim_acquire+0x72/0x100
       prepare_alloc_pages+0x152/0x650
       __alloc_frozen_pages_noprof+0x123/0x370
       __alloc_pages_noprof+0xa/0x30
       pcpu_populate_chunk+0x182/0xb30
       pcpu_alloc_noprof+0xcb6/0x1750
       xt_percpu_counter_alloc+0x161/0x220
       translate_table+0x1323/0x2040
       ip6t_register_table+0x106/0x7d0
       ip6table_nat_table_init+0x43/0x2e0
       xt_find_table_lock+0x30c/0x3e0
       xt_request_find_table_lock+0x26/0x100
       do_ip6t_get_ctl+0x730/0x1180
       nf_getsockopt+0x26e/0x290
       ipv6_getsockopt+0x1ed/0x290
       do_sock_getsockopt+0x2b4/0x3d0
       __x64_sys_getsockopt+0x1a5/0x250
       do_syscall_64+0xfa/0xf80
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

1 lock held by syz-executor/6047:
 #0: ffffffff8e02dde8 (pcpu_alloc_mutex){+.+.}-{4:4}, at: pcpu_alloc_noprof+0x25b/0x1750

stack backtrace:
CPU: 0 UID: 0 PID: 6047 Comm: syz-executor Not tainted syzkaller #0 PREEMPT(full) 
Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS 1.16.2-debian-1.16.2-1 04/01/2014
Call Trace:
 <TASK>
 dump_stack_lvl+0x189/0x250
 print_circular_bug+0x2e2/0x300
 check_noncircular+0x12e/0x150
 __lock_acquire+0x15a6/0x2cf0
 lock_acquire+0x117/0x340
 fs_reclaim_acquire+0x72/0x100
 prepare_alloc_pages+0x152/0x650
 __alloc_frozen_pages_noprof+0x123/0x370
 __alloc_pages_noprof+0xa/0x30
 pcpu_populate_chunk+0x182/0xb30
 pcpu_alloc_noprof+0xcb6/0x1750
 xt_percpu_counter_alloc+0x161/0x220
 translate_table+0x1323/0x2040
 ip6t_register_table+0x106/0x7d0
 ip6table_nat_table_init+0x43/0x2e0
 xt_find_table_lock+0x30c/0x3e0
 xt_request_find_table_lock+0x26/0x100
 do_ip6t_get_ctl+0x730/0x1180
 nf_getsockopt+0x26e/0x290
 ipv6_getsockopt+0x1ed/0x290
 do_sock_getsockopt+0x2b4/0x3d0
 __x64_sys_getsockopt+0x1a5/0x250
 do_syscall_64+0xfa/0xf80
 entry_SYSCALL_64_after_hwframe+0x77/0x7f
RIP: 0033:0x7feba799150a
Code: ff c3 66 0f 1f 44 00 00 48 c7 c2 a8 ff ff ff f7 d8 64 89 02 b8 ff ff ff ff eb b8 0f 1f 44 00 00 49 89 ca b8 37 00 00 00 0f 05 <48> 3d 00 f0 ff ff 77 06 c3 0f 1f 44 00 00 48 c7 c2 a8 ff ff ff f7
RSP: 002b:00007fff14c6a9e8 EFLAGS: 00000246 ORIG_RAX: 0000000000000037
RAX: ffffffffffffffda RBX: 0000000000000003 RCX: 00007feba799150a
RDX: 0000000000000040 RSI: 0000000000000029 RDI: 0000000000000003
RBP: 0000000000000029 R08: 00007fff14c6aa0c R09: ffffffffff000000
R10: 00007feba7bb6368 R11: 0000000000000246 R12: 00007feba7a30907
R13: 00007feba7bb7e60 R14: 00007feba7bb6368 R15: 00007feba7bb6360
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

