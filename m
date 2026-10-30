Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.167.198
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793373942;
	b=aYukoOb/IIJRO8Moxp/zQXs9Dt58W5jszePxAGxMRn0vdhhgSjoxjl2Gx6TeRCq4vM9h
	 ZC+5f585GCWYjMtN+5jbKfF61MUbV++U0raRpVLM/iSLZdFFYZkTlJFGl6ar1vhu7G02Q
	 sP8p8vWqxcDr+c5ilEHP9b8cEyBi6vt9ad0/dZvZsLk0W0KyKWp/pXtF6BT0Mif5keIN8
	 biVTzsmPhkQIaWHtCHslwSXyODnDRBXy5gS66nAv/O6i66zm5+qQQ1Ak3OzadHdngAlX5
	 6QfRJDHslvk5NxdT2/8ndwMm61Z60pFXDvgDQRTKOBczk9QJnb51XlQYMMfcYw/8qLQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793373942;
	h=DMARC-Filter:Received:X-Google-DKIM-Signature:X-Gm-Message-State:
	 MIME-Version:X-Received:Date:X-Google-Appengine-App-Id:
	 X-Google-Appengine-App-Id-Alias:Message-ID:Subject:From:To:Cc:
	 Content-Type;
	bh=D3vnLdiXuuhhQglu6b8pBI3ZKuDl3gYp7qCaasdpmVM=;
	b=0yz99wLrUZKJDpKSqZ9p6dInU3Vs5L/q6c4e/23T9uqqXhEqgneJgzhTAJ3PTJlCPTLG
	 h7sAwoT69mzJQ3WGSUPY5MyfDHSoWi7JiTygKyhEq+JBKjGLILVs9zWogXEgWMXUgeyas
	 rEdOC4hBQ/s28fF/LdTX+x+CzmprKZTUXOwq9UkDFMmaqaomewj+z+zuge42E9xFQM2vI
	 T9o5yH83feY2v49LkNPj1sPT3Bzv15qEoiYIXUt9bC7Hnk6Zr/PcbBL9r2JJ7YuG8mq6k
	 4iScfpTM1Bfd/GAssNcLiTrOfHsgiNLFHNIzAz5x5cxUxCF8hLkUyNRTs/B0f7r0Ptg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=fail header.from=syzkaller.appspotmail.com;
	spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com;
	arc=none smtp.remote-ip=209.85.167.198
Received: from mail-oi1-f198.google.com (mail-oi1-f198.google.com [209.85.167.198])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B5CB9606A325
	for <syzbot@lists.linux.dev>; Fri, 30 Oct 2026 15:25:41 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org B5CB9606A325
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com
Received: by mail-oi1-f198.google.com with SMTP id 5614622812f47-4eb0b989f0eso1137982b6e.0
        for <syzbot@lists.linux.dev>; Fri, 30 Oct 2026 08:25:41 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793373940; x=1793978740;
        h=content-type:cc:to:from:subject:message-id:date:mime-version
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=D3vnLdiXuuhhQglu6b8pBI3ZKuDl3gYp7qCaasdpmVM=;
        b=lMj7cMe/0JWCttAmjrf3q9uu2t/t1gxfZ/nJAFrERIbePZfKrGtFtAYq6YvpffKoY6
         ELuTBhcPbhqZq5Feo0upHYwWSDo7rIWu2uXtpBVzrFJ8pWNpTtEkBbmTQRMP3x3U77Nd
         1EEp2Cs+Bkkg+XIrFgfJ39WZk6R1Ibdio3u29upWXJgV70HDXUA1/dEpwPLIMpn4SwUO
         mlmoFddMxZ20ocUUbx2yzLwUKOjEYxB33N8Qd0M0siPtbPYqziQbPVGTXQv7xFrvTCSF
         1qDjIRNvd0KapLjkmWx2je8r584dnCfSJqL+XVSQ8m+Wv1AMRasWyXIDtToahAG1KPJx
         58aQ==
X-Gm-Message-State: AFq9FYJEBb86VjAaMcv0OneKlhoQXBqTyFf24w/8RHCnTIkxdJVj8/JX
	2NhAyQZOjEy4RX4NqQHot655/+WOd5hSahBCB8XnofBl1BJj/fPGlHVe99Nw73m/FBsqKEQx/JN
	V0eoZgcFb2dcIGcLCg/n3M6zQM9osuNPlMHYlKSwKJCrTs9tgoh79Mas/A1c=
X-Mailing-List: syzbot@lists.linux.dev
List-Id: <syzbot.lists.linux.dev>
List-Post: <mailto:syzbot@lists.linux.dev>
List-Help: <mailto:syzbot+help@lists.linux.dev>
List-Subscribe: <mailto:syzbot+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:syzbot+unsubscribe@lists.linux.dev>
List-Owner: <mailto:syzbot+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
X-Received: by 2002:a05:6808:c12e:b0:4f5:dc0d:e013 with SMTP id
 5614622812f47-563ef615b7amr3282356b6e.4.1793373940671; Fri, 30 Oct 2026
 08:25:40 -0700 (PDT)
Date: Fri, 30 Oct 2026 08:25:40 -0700
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <6ae4b6f4.f57e0135.1770dd.007a.GAE@google.com>
Subject: [moderation/CI] Re: netfilter: flowtable: purge entries immediately
 when destroying the flowtable
From: syzbot ci <syzbot+ci30e56c2ea4509e19@syzkaller.appspotmail.com>
To: syzkaller-upstream-moderation@googlegroups.com
Cc: syzbot@lists.linux.dev
Content-Type: text/plain; charset="UTF-8"

syzbot ci has tested the following series

[v1] netfilter: flowtable: purge entries immediately when destroying the flowtable
https://lore.kernel.org/all/20261029171950.222776-1-pablo@netfilter.org
* [PATCH nf] netfilter: flowtable: purge entries immediately when destroying the flowtable

and found the following issues:
* BUG: sleeping function called from invalid context in flow_offload_work_del
* WARNING: locking bug in flow_offload_work_del

Full report is available here:
https://ci.syzbot.org/series/5482d6d8-0683-4f36-bb55-ffcf94a9edcc

***

BUG: sleeping function called from invalid context in flow_offload_work_del

tree:      nf
URL:       https://kernel.googlesource.com/pub/scm/linux/kernel/git/netfilter/nf.git
base:      734bef548a96e8774d6eef5dfa2026c6edc4e80b
arch:      amd64
compiler:  Debian clang version 22.1.8 (1~deb13u4), Debian LLD 22.1.8
config:    https://ci.syzbot.org/builds/94e4012e-ffd8-430a-9ba4-d5a167bf8988/config
syz repro: https://ci.syzbot.org/findings/6c0e698b-3bb6-4d1f-94cb-9ebf1c0a71db/syz_repro

BUG: sleeping function called from invalid context at kernel/locking/rwsem.c:1573
in_atomic(): 0, irqs_disabled(): 0, non_block: 0, pid: 5686, name: kworker/u8:3
preempt_count: 0, expected: 0
RCU nest depth: 1, expected: 0
locks held by kworker/u8:3/5686: 3, last CPU#0:
 #0: ffff8881108f3948 ((wq_completion)act_ct_workqueue){+.+.}-{0:0}, at: rcu_lock_acquire include/linux/rcupdate.h:309 [inline]
 #0: ffff8881108f3948 ((wq_completion)act_ct_workqueue){+.+.}-{0:0}, at: rcu_read_lock include/linux/rcupdate.h:849 [inline]
 #0: ffff8881108f3948 ((wq_completion)act_ct_workqueue){+.+.}-{0:0}, at: process_one_work kernel/workqueue.c:3460 [inline]
 #0: ffff8881108f3948 ((wq_completion)act_ct_workqueue){+.+.}-{0:0}, at: process_scheduled_works+0x97a/0x1630 kernel/workqueue.c:3578
 #1: ffffc90004e67c40 ((work_completion)(&(&ct_ft->rwork)->work)){+.+.}-{0:0}, at: rcu_lock_acquire include/linux/rcupdate.h:309 [inline]
 #1: ffffc90004e67c40 ((work_completion)(&(&ct_ft->rwork)->work)){+.+.}-{0:0}, at: rcu_read_lock include/linux/rcupdate.h:849 [inline]
 #1: ffffc90004e67c40 ((work_completion)(&(&ct_ft->rwork)->work)){+.+.}-{0:0}, at: process_one_work kernel/workqueue.c:3460 [inline]
 #1: ffffc90004e67c40 ((work_completion)(&(&ct_ft->rwork)->work)){+.+.}-{0:0}, at: process_scheduled_works+0x97a/0x1630 kernel/workqueue.c:3578
 #2: ffffffff8fd59ca0 (rcu_read_lock){....}-{1:3}, at: rcu_lock_acquire include/linux/rcupdate.h:309 [inline]
 #2: ffffffff8fd59ca0 (rcu_read_lock){....}-{1:3}, at: rcu_read_lock include/linux/rcupdate.h:849 [inline]
 #2: ffffffff8fd59ca0 (rcu_read_lock){....}-{1:3}, at: rhashtable_walk_start_check+0x64/0xcf0 lib/rhashtable.c:872
CPU: 0 UID: 0 PID: 5686 Comm: kworker/u8:3 Not tainted syzkaller #0 PREEMPT(full) 
Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS 1.16.2-debian-1.16.2-1 04/01/2014
Workqueue: act_ct_workqueue tcf_ct_flow_table_cleanup_work
Call Trace:
 <TASK>
 dump_stack_lvl+0xe8/0x150 lib/dump_stack.c:120
 __might_resched+0x36a/0x4c0 kernel/sched/core.c:9195
 down_read+0x26/0x320 kernel/locking/rwsem.c:1573
 nf_flow_offload_tuple net/netfilter/nf_flow_table_offload.c:920 [inline]
 flow_offload_tuple_del net/netfilter/nf_flow_table_offload.c:951 [inline]
 flow_offload_work_del+0x240/0x5e0 net/netfilter/nf_flow_table_offload.c:995
 nf_flow_table_offload_purge+0x51/0x80 net/netfilter/nf_flow_table_offload.c:1184
 nf_flow_table_do_purge net/netfilter/nf_flow_table_core.c:776 [inline]
 nf_flow_table_iterate net/netfilter/nf_flow_table_core.c:459 [inline]
 nf_flow_table_free+0x29b/0x3b0 net/netfilter/nf_flow_table_core.c:789
 tcf_ct_flow_table_cleanup_work+0x1a/0x90 net/sched/act_ct.c:386
 process_one_work kernel/workqueue.c:3495 [inline]
 process_scheduled_works+0xc3d/0x1630 kernel/workqueue.c:3578
 worker_thread+0xa47/0xfb0 kernel/workqueue.c:3659
 kthread+0x38b/0x480 kernel/kthread.c:436
 ret_from_fork+0x514/0xb70 arch/x86/kernel/process.c:158
 ret_from_fork_asm+0x1a/0x30 arch/x86/entry/entry_64.S:245
 </TASK>

=============================
[ BUG: Invalid wait context ]
syzkaller #0 Tainted: G        W           
-----------------------------
kworker/u8:3/5686 is trying to lock:
ffff88817589eb28 (&flowtable->flow_block_lock){.+.+}-{4:4}, at: nf_flow_offload_tuple net/netfilter/nf_flow_table_offload.c:920 [inline]
ffff88817589eb28 (&flowtable->flow_block_lock){.+.+}-{4:4}, at: flow_offload_tuple_del net/netfilter/nf_flow_table_offload.c:951 [inline]
ffff88817589eb28 (&flowtable->flow_block_lock){.+.+}-{4:4}, at: flow_offload_work_del+0x240/0x5e0 net/netfilter/nf_flow_table_offload.c:995
other info that might help us debug this:
context-{5:5}
locks held by kworker/u8:3/5686: 3, last CPU#0:
 #0: ffff8881108f3948 ((wq_completion)act_ct_workqueue){+.+.}-{0:0}, at: rcu_lock_acquire include/linux/rcupdate.h:309 [inline]
 #0: ffff8881108f3948 ((wq_completion)act_ct_workqueue){+.+.}-{0:0}, at: rcu_read_lock include/linux/rcupdate.h:849 [inline]
 #0: ffff8881108f3948 ((wq_completion)act_ct_workqueue){+.+.}-{0:0}, at: process_one_work kernel/workqueue.c:3460 [inline]
 #0: ffff8881108f3948 ((wq_completion)act_ct_workqueue){+.+.}-{0:0}, at: process_scheduled_works+0x97a/0x1630 kernel/workqueue.c:3578
 #1: ffffc90004e67c40 ((work_completion)(&(&ct_ft->rwork)->work)){+.+.}-{0:0}, at: rcu_lock_acquire include/linux/rcupdate.h:309 [inline]
 #1: ffffc90004e67c40 ((work_completion)(&(&ct_ft->rwork)->work)){+.+.}-{0:0}, at: rcu_read_lock include/linux/rcupdate.h:849 [inline]
 #1: ffffc90004e67c40 ((work_completion)(&(&ct_ft->rwork)->work)){+.+.}-{0:0}, at: process_one_work kernel/workqueue.c:3460 [inline]
 #1: ffffc90004e67c40 ((work_completion)(&(&ct_ft->rwork)->work)){+.+.}-{0:0}, at: process_scheduled_works+0x97a/0x1630 kernel/workqueue.c:3578
 #2: ffffffff8fd59ca0 (rcu_read_lock){....}-{1:3}, at: rcu_lock_acquire include/linux/rcupdate.h:309 [inline]
 #2: ffffffff8fd59ca0 (rcu_read_lock){....}-{1:3}, at: rcu_read_lock include/linux/rcupdate.h:849 [inline]
 #2: ffffffff8fd59ca0 (rcu_read_lock){....}-{1:3}, at: rhashtable_walk_start_check+0x64/0xcf0 lib/rhashtable.c:872
stack backtrace:
CPU: 0 UID: 0 PID: 5686 Comm: kworker/u8:3 Tainted: G        W            syzkaller #0 PREEMPT(full) 
Tainted: [W]=WARN
Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS 1.16.2-debian-1.16.2-1 04/01/2014
Workqueue: act_ct_workqueue tcf_ct_flow_table_cleanup_work
Call Trace:
 <TASK>
 dump_stack_lvl+0xe8/0x150 lib/dump_stack.c:120
 print_lock_invalid_wait_context kernel/locking/lockdep.c:4874 [inline]
 check_wait_context kernel/locking/lockdep.c:4946 [inline]
 __lock_acquire+0xf5b/0x2de0 kernel/locking/lockdep.c:5238
 lock_acquire+0x115/0x350 kernel/locking/lockdep.c:5942
 down_read+0x45/0x320 kernel/locking/rwsem.c:1574
 nf_flow_offload_tuple net/netfilter/nf_flow_table_offload.c:920 [inline]
 flow_offload_tuple_del net/netfilter/nf_flow_table_offload.c:951 [inline]
 flow_offload_work_del+0x240/0x5e0 net/netfilter/nf_flow_table_offload.c:995
 nf_flow_table_offload_purge+0x51/0x80 net/netfilter/nf_flow_table_offload.c:1184
 nf_flow_table_do_purge net/netfilter/nf_flow_table_core.c:776 [inline]
 nf_flow_table_iterate net/netfilter/nf_flow_table_core.c:459 [inline]
 nf_flow_table_free+0x29b/0x3b0 net/netfilter/nf_flow_table_core.c:789
 tcf_ct_flow_table_cleanup_work+0x1a/0x90 net/sched/act_ct.c:386
 process_one_work kernel/workqueue.c:3495 [inline]
 process_scheduled_works+0xc3d/0x1630 kernel/workqueue.c:3578
 worker_thread+0xa47/0xfb0 kernel/workqueue.c:3659
 kthread+0x38b/0x480 kernel/kthread.c:436
 ret_from_fork+0x514/0xb70 arch/x86/kernel/process.c:158
 ret_from_fork_asm+0x1a/0x30 arch/x86/entry/entry_64.S:245
 </TASK>


***

WARNING: locking bug in flow_offload_work_del

tree:      nf
URL:       https://kernel.googlesource.com/pub/scm/linux/kernel/git/netfilter/nf.git
base:      734bef548a96e8774d6eef5dfa2026c6edc4e80b
arch:      amd64
compiler:  Debian clang version 22.1.8 (1~deb13u4), Debian LLD 22.1.8
config:    https://ci.syzbot.org/builds/94e4012e-ffd8-430a-9ba4-d5a167bf8988/config
AI triage: https://ci.syzbot.org/findings/8d3389f2-6e3f-4f98-bc3b-bba34041a26f/triage_trajectory

BUG: sleeping function called from invalid context at kernel/locking/rwsem.c:1573
in_atomic(): 0, irqs_disabled(): 0, non_block: 0, pid: 5634, name: kworker/u8:2
preempt_count: 0, expected: 0
RCU nest depth: 1, expected: 0
locks held by kworker/u8:2/5634: 3, last CPU#1:
 #0: ffff888115805948 ((wq_completion)act_ct_workqueue){+.+.}-{0:0}, at: process_scheduled_works+0x97a/0x1630
 #1: ffffc9000473fc40 ((work_completion)(&(&ct_ft->rwork)->work)){+.+.}-{0:0}, at: process_scheduled_works+0x97a/0x1630
 #2: ffffffff8fd59ca0 (rcu_read_lock){....}-{1:3}, at: rhashtable_walk_start_check+0x64/0xcf0
CPU: 1 UID: 0 PID: 5634 Comm: kworker/u8:2 Not tainted syzkaller #0 PREEMPT(full) 
Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS 1.16.2-debian-1.16.2-1 04/01/2014
Workqueue: act_ct_workqueue tcf_ct_flow_table_cleanup_work
Call Trace:
 <TASK>
 dump_stack_lvl+0xe8/0x150
 __might_resched+0x36a/0x4c0
 down_read+0x26/0x320
 flow_offload_work_del+0x240/0x5e0
 nf_flow_table_offload_purge+0x51/0x80
 nf_flow_table_free+0x29b/0x3b0
 tcf_ct_flow_table_cleanup_work+0x1a/0x90
 process_scheduled_works+0xc3d/0x1630
 worker_thread+0xa47/0xfb0
 kthread+0x38b/0x480
 ret_from_fork+0x514/0xb70
 ret_from_fork_asm+0x1a/0x30
 </TASK>
=============================
[ BUG: Invalid wait context ]
syzkaller #0 Tainted: G        W           
-----------------------------
kworker/u8:2/5634 is trying to lock:
ffff8881b9d94b28 (&flowtable->flow_block_lock){++++}-{4:4}, at: flow_offload_work_del+0x240/0x5e0
other info that might help us debug this:
context-{5:5}
locks held by kworker/u8:2/5634: 3, last CPU#0:
 #0: ffff888115805948 ((wq_completion)act_ct_workqueue){+.+.}-{0:0}, at: process_scheduled_works+0x97a/0x1630
 #1: ffffc9000473fc40 ((work_completion)(&(&ct_ft->rwork)->work)){+.+.}-{0:0}, at: process_scheduled_works+0x97a/0x1630
 #2: ffffffff8fd59ca0 (rcu_read_lock){....}-{1:3}, at: rhashtable_walk_start_check+0x64/0xcf0
stack backtrace:
CPU: 0 UID: 0 PID: 5634 Comm: kworker/u8:2 Tainted: G        W            syzkaller #0 PREEMPT(full) 
Tainted: [W]=WARN
Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS 1.16.2-debian-1.16.2-1 04/01/2014
Workqueue: act_ct_workqueue tcf_ct_flow_table_cleanup_work
Call Trace:
 <TASK>
 dump_stack_lvl+0xe8/0x150
 __lock_acquire+0xf5b/0x2de0
 lock_acquire+0x115/0x350
 down_read+0x45/0x320
 flow_offload_work_del+0x240/0x5e0
 nf_flow_table_offload_purge+0x51/0x80
 nf_flow_table_free+0x29b/0x3b0
 tcf_ct_flow_table_cleanup_work+0x1a/0x90
 process_scheduled_works+0xc3d/0x1630
 worker_thread+0xa47/0xfb0
 kthread+0x38b/0x480
 ret_from_fork+0x514/0xb70
 ret_from_fork_asm+0x1a/0x30
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
[netfilter-devel@vger.kernel.org pablo@netfilter.org]

If the report looks fine to you, reply with:
#syz upstream

If the report is a false positive, reply with
#syz invalid

