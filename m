Received: from mail-qv1-f70.google.com (mail-qv1-f70.google.com [209.85.219.70])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DA2E533E344
	for <syzbot@lists.linux.dev>; Thu, 14 May 2026 16:37:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.219.70
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778776629; cv=none; b=TtOt6NXRd4ks/dQeINUCZPQtYsPOg9PXu/FcmXy4Ged+T+1U/Px0FUz2lrMinfoRNgJ54S+rCuY1aLgTRf9MAq5/D5HhPDrKAiRg8zmbUzalE/k5aNmtIAWvlM3+OjXd+WU2drdwQqAGKGNnaFQeNtY+3vEE14SA0GbOw7JmcMI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778776629; c=relaxed/simple;
	bh=YNGM6B6NuwFx70ASStbseMDe6V9yQOe06GFioVm+jH8=;
	h=MIME-Version:Date:Message-ID:Subject:From:To:Cc:Content-Type; b=qvVk9OMo97Xi1PdszFaUbOZ/psln0V5wtvZ0aTs1QySBWBc00x7rYZPUgYYvF3VqrqXna7vE1qFiYQn9cohI3alAtuae22qWHQ2hdAj/1L3SEpBj4UEw6c+R4VUKvRG32Dd8AEJqcbceYvKXH0r90jRuCRuTapLunbUzqRZvzK4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com; arc=none smtp.client-ip=209.85.219.70
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com
Received: by mail-qv1-f70.google.com with SMTP id 6a1803df08f44-8b49424ad88so210407106d6.1
        for <syzbot@lists.linux.dev>; Thu, 14 May 2026 09:37:07 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1778776627; x=1779381427;
        h=cc:to:from:subject:message-id:date:mime-version:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=VDQsdqQBIUw/EpMNiy59PlV7tPclXN2XRm53rnAIj8U=;
        b=kvdMksWkw0yWJBuIpbcg8S1BtkypbrAaJOrOqRFWYmg7JCaO20YozjkekZtgjRf/rV
         eHmp9Zf81kQVurN7NvlgUkjTjcLttOxkzKL+nvimlvLldl2agbs2PypmnXc8DBLAXesK
         hkfbVJ8/XE4f96WoRd48NjlLT8wYqupokI7abiLIxaSSKz4d0NkonMg6eXDvHJ13kwck
         VlB0J7YZu4A9QRWiQzOe1faeHsb2p8tOYJWZIjQjvV3vZdRRtdTcVpJvWC2ZSJjFsmL6
         qrWsVic+bbXD1KsPJyF1Kmn6qcEmfmu1YnjMmVwo1NTGGZcm+qwOyjTLV922li3hVsGA
         WjjA==
X-Gm-Message-State: AOJu0Yw9tMB7kOQZ+eqTcvA+lstboiyIsQaFPz3sRoFUFpFZvqqAjCmR
	nl83hyzbQF+ZCvK2Z4d/rk5EfhBDnp9P7sAmixrEGgt24FMRtkjb2XOyKFv3AFoAFykcwWxhY42
	cry+QKFLDBz6UKmFf9tzU8ofBq/CLyEsamSiLWxPhjbi3Y72Qj4Jl3tycRg0=
Precedence: bulk
X-Mailing-List: syzbot@lists.linux.dev
List-Id: <syzbot.lists.linux.dev>
List-Subscribe: <mailto:syzbot+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:syzbot+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Received: by 2002:a05:6820:2206:b0:696:637e:4831 with SMTP id
 006d021491bc7-69c94315b9emr90246eaf.25.1778776167207; Thu, 14 May 2026
 09:29:27 -0700 (PDT)
Date: Thu, 14 May 2026 09:29:27 -0700
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <6a05f867.170a0220.290639.01cd.GAE@google.com>
Subject: [moderation/CI] Re: netfilter: ipset fixes
From: syzbot ci <syzbot+ci61c2ab2f25f83aed@syzkaller.appspotmail.com>
To: syzkaller-upstream-moderation@googlegroups.com
Cc: syzbot@lists.linux.dev
Content-Type: text/plain; charset="UTF-8"

syzbot ci has tested the following series

[v7] netfilter: ipset fixes
https://lore.kernel.org/all/20260514085519.12729-1-kadlec@netfilter.org
* [PATCH v7 01/10] netfilter: ipset: fix a potential dump-destroy race
* [PATCH v7 02/10] netfilter: ipset: Fix data race between add and list header in all hash types
* [PATCH v7 03/10] netfilter: ipset: Fix data race between add and dump in all hash types
* [PATCH v7 04/10] netfilter: ipset: annotate "pos" for concurrent readers/writers
* [PATCH v7 05/10] netfilter: ipset: Don't use test_bit() in lockless RCU readers in hash types
* [PATCH v7 06/10] netfilter: ipset: Don't use test_bit() in lockless RCU readers in bitmap types
* [PATCH v7 07/10] netfilter: ipset: fix order of kfree_rcu() and rcu_assign_pointer()
* [PATCH v7 08/10] netfilter: ipset: skip gc when resize is in progress
* [PATCH v7 09/10] netfilter: ipset: fix potential torn read in reuse/forceadd cases
* [PATCH v7 10/10] netfilter: ipset: add comment how cidr bookkeeping is working

and found the following issues:
* WARNING: suspicious RCU usage in hash_ipmac4_gc
* WARNING: suspicious RCU usage in hash_mac4_gc
* WARNING: suspicious RCU usage in hash_netport4_gc

Full report is available here:
https://ci.syzbot.org/series/4eaa3601-8f4b-4397-8346-80b76fdcbbe3

***

WARNING: suspicious RCU usage in hash_ipmac4_gc

tree:      nf-next
URL:       https://kernel.googlesource.com/pub/scm/linux/kernel/git/netfilter/nf-next.git
base:      8b2feced65cd3aa0597d596ed5733a1abd4c4d78
arch:      amd64
compiler:  Debian clang version 21.1.8 (++20251221033036+2078da43e25a-1~exp1~20251221153213.50), Debian LLD 21.1.8
config:    https://ci.syzbot.org/builds/0cf592b8-68f8-4eb4-a6f6-8cd4105f126e/config
syz repro: https://ci.syzbot.org/findings/3b9878ac-3e49-41d8-9981-f2c8119c9a04/syz_repro

=============================
WARNING: suspicious RCU usage
syzkaller #0 Not tainted
-----------------------------
net/netfilter/ipset/ip_set_hash_gen.h:585 suspicious rcu_dereference_protected() usage!

other info that might help us debug this:


rcu_scheduler_active = 2, debug_locks = 1
2 locks held by kworker/0:0/9:
 #0: ffff888100069d40 ((wq_completion)events_power_efficient){+.+.}-{0:0}, at: process_one_work kernel/workqueue.c:3277 [inline]
 #0: ffff888100069d40 ((wq_completion)events_power_efficient){+.+.}-{0:0}, at: process_scheduled_works+0xa35/0x1860 kernel/workqueue.c:3385
 #1: ffffc900000e7c40 ((work_completion)(&(&gc->dwork)->work)){+.+.}-{0:0}, at: process_one_work kernel/workqueue.c:3278 [inline]
 #1: ffffc900000e7c40 ((work_completion)(&(&gc->dwork)->work)){+.+.}-{0:0}, at: process_scheduled_works+0xa70/0x1860 kernel/workqueue.c:3385

stack backtrace:
CPU: 0 UID: 0 PID: 9 Comm: kworker/0:0 Not tainted syzkaller #0 PREEMPT(full) 
Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS 1.16.2-debian-1.16.2-1 04/01/2014
Workqueue: events_power_efficient hash_ipmac4_gc
Call Trace:
 <TASK>
 dump_stack_lvl+0xe8/0x150 lib/dump_stack.c:120
 lockdep_rcu_suspicious+0x13f/0x1d0 kernel/locking/lockdep.c:6876
 hash_ipmac4_gc+0x324/0x3e0 net/netfilter/ipset/ip_set_hash_gen.h:585
 process_one_work kernel/workqueue.c:3302 [inline]
 process_scheduled_works+0xb5d/0x1860 kernel/workqueue.c:3385
 worker_thread+0xa53/0xfc0 kernel/workqueue.c:3466
 kthread+0x388/0x470 kernel/kthread.c:436
 ret_from_fork+0x514/0xb70 arch/x86/kernel/process.c:158
 ret_from_fork_asm+0x1a/0x30 arch/x86/entry/entry_64.S:245
 </TASK>


***

WARNING: suspicious RCU usage in hash_mac4_gc

tree:      nf-next
URL:       https://kernel.googlesource.com/pub/scm/linux/kernel/git/netfilter/nf-next.git
base:      8b2feced65cd3aa0597d596ed5733a1abd4c4d78
arch:      amd64
compiler:  Debian clang version 21.1.8 (++20251221033036+2078da43e25a-1~exp1~20251221153213.50), Debian LLD 21.1.8
config:    https://ci.syzbot.org/builds/0cf592b8-68f8-4eb4-a6f6-8cd4105f126e/config
syz repro: https://ci.syzbot.org/findings/446cefef-5142-4649-a8dc-3c247165e5b7/syz_repro

=============================
WARNING: suspicious RCU usage
syzkaller #0 Not tainted
-----------------------------
net/netfilter/ipset/ip_set_hash_gen.h:585 suspicious rcu_dereference_protected() usage!

other info that might help us debug this:


rcu_scheduler_active = 2, debug_locks = 1
2 locks held by kworker/0:1/10:
 #0: ffff888100069d40 ((wq_completion)events_power_efficient){+.+.}-{0:0}, at: process_one_work kernel/workqueue.c:3277 [inline]
 #0: ffff888100069d40 ((wq_completion)events_power_efficient){+.+.}-{0:0}, at: process_scheduled_works+0xa35/0x1860 kernel/workqueue.c:3385
 #1: ffffc900000f7c40 ((work_completion)(&(&gc->dwork)->work)){+.+.}-{0:0}, at: process_one_work kernel/workqueue.c:3278 [inline]
 #1: ffffc900000f7c40 ((work_completion)(&(&gc->dwork)->work)){+.+.}-{0:0}, at: process_scheduled_works+0xa70/0x1860 kernel/workqueue.c:3385

stack backtrace:
CPU: 0 UID: 0 PID: 10 Comm: kworker/0:1 Not tainted syzkaller #0 PREEMPT(full) 
Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS 1.16.2-debian-1.16.2-1 04/01/2014
Workqueue: events_power_efficient hash_mac4_gc
Call Trace:
 <TASK>
 dump_stack_lvl+0xe8/0x150 lib/dump_stack.c:120
 lockdep_rcu_suspicious+0x13f/0x1d0 kernel/locking/lockdep.c:6876
 hash_mac4_gc+0x324/0x3e0 net/netfilter/ipset/ip_set_hash_gen.h:585
 process_one_work kernel/workqueue.c:3302 [inline]
 process_scheduled_works+0xb5d/0x1860 kernel/workqueue.c:3385
 worker_thread+0xa53/0xfc0 kernel/workqueue.c:3466
 kthread+0x388/0x470 kernel/kthread.c:436
 ret_from_fork+0x514/0xb70 arch/x86/kernel/process.c:158
 ret_from_fork_asm+0x1a/0x30 arch/x86/entry/entry_64.S:245
 </TASK>


***

WARNING: suspicious RCU usage in hash_netport4_gc

tree:      nf-next
URL:       https://kernel.googlesource.com/pub/scm/linux/kernel/git/netfilter/nf-next.git
base:      8b2feced65cd3aa0597d596ed5733a1abd4c4d78
arch:      amd64
compiler:  Debian clang version 21.1.8 (++20251221033036+2078da43e25a-1~exp1~20251221153213.50), Debian LLD 21.1.8
config:    https://ci.syzbot.org/builds/0cf592b8-68f8-4eb4-a6f6-8cd4105f126e/config
syz repro: https://ci.syzbot.org/findings/7493a52e-0299-4492-9a63-c84a8959d94f/syz_repro

=============================
WARNING: suspicious RCU usage
syzkaller #0 Not tainted
-----------------------------
net/netfilter/ipset/ip_set_hash_gen.h:585 suspicious rcu_dereference_protected() usage!

other info that might help us debug this:


rcu_scheduler_active = 2, debug_locks = 1
2 locks held by kworker/0:4/5744:
 #0: ffff888100069d40 ((wq_completion)events_power_efficient){+.+.}-{0:0}, at: process_one_work kernel/workqueue.c:3277 [inline]
 #0: ffff888100069d40 ((wq_completion)events_power_efficient){+.+.}-{0:0}, at: process_scheduled_works+0xa35/0x1860 kernel/workqueue.c:3385
 #1: ffffc900038bfc40 ((work_completion)(&(&gc->dwork)->work)){+.+.}-{0:0}, at: process_one_work kernel/workqueue.c:3278 [inline]
 #1: ffffc900038bfc40 ((work_completion)(&(&gc->dwork)->work)){+.+.}-{0:0}, at: process_scheduled_works+0xa70/0x1860 kernel/workqueue.c:3385

stack backtrace:
CPU: 0 UID: 0 PID: 5744 Comm: kworker/0:4 Not tainted syzkaller #0 PREEMPT(full) 
Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS 1.16.2-debian-1.16.2-1 04/01/2014
Workqueue: events_power_efficient hash_netport4_gc
Call Trace:
 <TASK>
 dump_stack_lvl+0xe8/0x150 lib/dump_stack.c:120
 lockdep_rcu_suspicious+0x13f/0x1d0 kernel/locking/lockdep.c:6876
 hash_netport4_gc+0x32e/0x3f0 net/netfilter/ipset/ip_set_hash_gen.h:585
 process_one_work kernel/workqueue.c:3302 [inline]
 process_scheduled_works+0xb5d/0x1860 kernel/workqueue.c:3385
 worker_thread+0xa53/0xfc0 kernel/workqueue.c:3466
 kthread+0x388/0x470 kernel/kthread.c:436
 ret_from_fork+0x514/0xb70 arch/x86/kernel/process.c:158
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
[kadlec@netfilter.org netfilter-devel@vger.kernel.org pablo@netfilter.org]

If the report looks fine to you, reply with:
#syz upstream

If the report is a false positive, reply with
#syz invalid

