Received: from mail-oi1-f197.google.com (mail-oi1-f197.google.com [209.85.167.197])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B48BC39A7F2
	for <syzbot@lists.linux.dev>; Fri, 28 Aug 2026 22:46:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.167.197
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787957193; cv=none; b=Scj+LgxOunDl7tzlqbrZFIJ3e+xwc+NMZvEWPpngHa+Q3YAIZDM+ClaIHJmbISYXv9OQhAuiVetKEJAJ18xn1miu8buDHXhQjuxalT/a+2XoUZpdWmxM/ZZy0idSxoUDQII/rn28bbkEHk0uw5tpGxnz8T9TWPj2MIQjyOnCauo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787957193; c=relaxed/simple;
	bh=ku3v7vnuigDeR+jFCW/sK2Ns0W6RF7pXuQg3/IThsds=;
	h=MIME-Version:Date:Message-ID:Subject:From:To:Cc:Content-Type; b=Q93EGUA6jHgvIOioZvleeYU/Fsvt43cnLOF/CiakimgWiFYGEYU3g6YO8fstUBd9H2i27OVZ3weaqlDEQovI3k8/VpBlbj+VZmdaHSEeqP6KGp+1jIFSDSaTaigiy9qyJWFUd9WfuCAQHa67fPfHFjYAM+U45omz2UGcj1X4a74=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com; arc=none smtp.client-ip=209.85.167.197
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com
Received: by mail-oi1-f197.google.com with SMTP id 5614622812f47-48e5de5a23cso2389240b6e.0
        for <syzbot@lists.linux.dev>; Fri, 28 Aug 2026 15:46:31 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1787957190; x=1788561990;
        h=content-type:cc:to:from:subject:message-id:date:mime-version
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=M9Oo1pB78wMAag8O1R3CNYNZJS8TI/imouhy0hm40Rc=;
        b=aLhCPD+UuMG3XnjA9JMXOM5k35vy3GPfCs5/MUJgU8Lw2eIqY1frXbjilZjsKx4Ou0
         U8pYAEw59Zbd41BOZfdre5CgRhaUwx/reInRH9+DCKN0gfck6W5h6XhGi5y4t2TdH4iC
         II+SYcsKlzc4rrmKhn97alqnTdQJG+cCvN6fRfjNhhx3j+aCTQecjdLXKGx1iqXqQPeK
         TV9+rrfAvWTwHqNNz30GA8slclw1XutEV2qeTemj8Ynkz958oRk7ej8hbDBPYPMxObPq
         H0CUMrSMMVOVKYTsUn2ExHmohp/ykfuGXzEUGCNPVbN0BSX9NWfIHXh5Q3BHCMnAhXfc
         xKFw==
X-Gm-Message-State: AFuF++nmwOHp6I37lG8+tO6c8LPpjnar5mMyqFMZbePOpMH6pZqb0/c+
	E4dLRYU9PeD12uYwY+7fSWdWDn7y0p1/u9D8bdZrfUMprkHCQxB54a6aA/DaqHBxUemK4zU4wzM
	uUGiYSyTCYXZKoQiu4opWbX8OPwdNA3FP2k96vYpeoJdC7H1vT+E5yDn/4C0=
Precedence: bulk
X-Mailing-List: syzbot@lists.linux.dev
List-Id: <syzbot.lists.linux.dev>
List-Subscribe: <mailto:syzbot+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:syzbot+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Received: by 2002:a05:6808:1992:b0:4b3:2274:247a with SMTP id
 5614622812f47-4b39819525dmr11696565b6e.11.1787957190592; Fri, 28 Aug 2026
 15:46:30 -0700 (PDT)
Date: Fri, 28 Aug 2026 15:46:30 -0700
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <6a920fc6.1d9ded08.62e62.00f6.GAE@google.com>
Subject: [moderation/CI] Re: mm/memcontrol: fix stuck FLUSHING_CACHED_CHARGE
 bit on isolated cpus
From: syzbot ci <syzbot+cied200eaa2d6d2b7c@syzkaller.appspotmail.com>
To: syzkaller-upstream-moderation@googlegroups.com
Cc: syzbot@lists.linux.dev
Content-Type: text/plain; charset="UTF-8"

syzbot ci has tested the following series

[v2] mm/memcontrol: fix stuck FLUSHING_CACHED_CHARGE bit on isolated cpus
https://lore.kernel.org/all/20260828135036.7d44361f@fangorn
* [PATCH v2] mm/memcontrol: fix stuck FLUSHING_CACHED_CHARGE bit on isolated cpus

and found the following issue:
possible deadlock in blkg_conf_prep

Full report is available here:
https://ci.syzbot.org/series/b7c6073d-9eac-41ad-921f-a90980058034

***

possible deadlock in blkg_conf_prep

tree:      mm-new
URL:       https://kernel.googlesource.com/pub/scm/linux/kernel/git/akpm/mm.git
base:      91011cec827788fde4bddbf45ecc507525c2ae06
arch:      amd64
compiler:  Debian clang version 22.1.8 (++20260613092233+e80beda6e255-1~exp1~20260613092250.77), Debian LLD 22.1.8
config:    https://ci.syzbot.org/builds/c13b10a4-7bea-4b4c-a897-542d751e804f/config
syz repro: https://ci.syzbot.org/findings/539b38db-9b98-4110-88d1-eee54084fc25/syz_repro

======================================================
WARNING: possible circular locking dependency detected
syzkaller #0 Not tainted
------------------------------------------------------
syz.0.23/5880 is trying to acquire lock:
ffffffff8ee8f800 (fs_reclaim){+.+.}-{0:0}, at: might_alloc include/linux/sched/mm.h:316 [inline]
ffffffff8ee8f800 (fs_reclaim){+.+.}-{0:0}, at: slab_pre_alloc_hook mm/slub.c:4636 [inline]
ffffffff8ee8f800 (fs_reclaim){+.+.}-{0:0}, at: slab_alloc_node mm/slub.c:4974 [inline]
ffffffff8ee8f800 (fs_reclaim){+.+.}-{0:0}, at: kmem_cache_alloc_noprof+0x5f/0x600 mm/slub.c:5010

but task is already holding lock:
ffff88810a0b3bc0 (&q->blkcg_mutex){+.+.}-{4:4}, at: blkg_conf_prep+0xa3/0xd80 block/blk-cgroup.c:849

which lock already depends on the new lock.


the existing dependency chain (in reverse order) is:

-> #2 (&q->blkcg_mutex){+.+.}-{4:4}:
       __mutex_lock_common kernel/locking/mutex.c:646 [inline]
       __mutex_lock+0x19d/0x1550 kernel/locking/mutex.c:821
       blkcg_activate_policy+0x1cb/0x8e0 block/blk-cgroup.c:1608
       blk_throtl_init+0x2f7/0x420 block/blk-throttle.c:1339
       tg_set_conf+0x1db/0x4e0 block/blk-throttle.c:1368
       cgroup_file_write+0x331/0x8f0 kernel/cgroup/cgroup.c:4412
       kernfs_fop_write_iter+0x3a4/0x540 fs/kernfs/file.c:345
       new_sync_write fs/read_write.c:595 [inline]
       vfs_write+0x612/0xba0 fs/read_write.c:687
       ksys_write+0x150/0x270 fs/read_write.c:739
       do_syscall_x64 arch/x86/entry/syscall_64.c:61 [inline]
       do_syscall_64+0x166/0x520 arch/x86/entry/syscall_64.c:84
       entry_SYSCALL_64_after_hwframe+0x77/0x7f

-> #1 (&q->q_usage_counter(io)#17){++++}-{0:0}:
       blk_alloc_queue+0x544/0x690 block/blk-core.c:504
       blk_mq_alloc_queue block/blk-mq.c:4420 [inline]
       __blk_mq_alloc_disk+0x194/0x390 block/blk-mq.c:4467
       loop_add+0x480/0xb40 drivers/block/loop.c:2071
       loop_init+0xd7/0x160 drivers/block/loop.c:2310
       do_one_initcall+0x250/0x870 init/main.c:1357
       do_initcall_level+0x10a/0x1a0 init/main.c:1419
       do_initcalls+0x59/0xa0 init/main.c:1435
       kernel_init_freeable+0x29d/0x3e0 init/main.c:1670
       kernel_init+0x22/0x1d0 init/main.c:1560
       ret_from_fork+0x514/0xb70 arch/x86/kernel/process.c:158
       ret_from_fork_asm+0x1a/0x30 arch/x86/entry/entry_64.S:245

-> #0 (fs_reclaim){+.+.}-{0:0}:
       check_prev_add kernel/locking/lockdep.c:3181 [inline]
       check_prevs_add kernel/locking/lockdep.c:3300 [inline]
       validate_chain kernel/locking/lockdep.c:3924 [inline]
       __lock_acquire+0x15ff/0x2e50 kernel/locking/lockdep.c:5254
       lock_acquire+0x115/0x350 kernel/locking/lockdep.c:5908
       __fs_reclaim_acquire mm/page_alloc.c:4375 [inline]
       fs_reclaim_acquire+0x71/0x100 mm/page_alloc.c:4389
       might_alloc include/linux/sched/mm.h:316 [inline]
       slab_pre_alloc_hook mm/slub.c:4636 [inline]
       slab_alloc_node mm/slub.c:4974 [inline]
       kmem_cache_alloc_noprof+0x5f/0x600 mm/slub.c:5010
       __radix_tree_preload+0x2df/0x870 lib/radix-tree.c:338
       blkg_conf_prep+0x621/0xd80 block/blk-cgroup.c:885
       tg_set_conf+0x20b/0x4e0 block/blk-throttle.c:1373
       cgroup_file_write+0x331/0x8f0 kernel/cgroup/cgroup.c:4412
       kernfs_fop_write_iter+0x3a4/0x540 fs/kernfs/file.c:345
       new_sync_write fs/read_write.c:595 [inline]
       vfs_write+0x612/0xba0 fs/read_write.c:687
       ksys_write+0x150/0x270 fs/read_write.c:739
       do_syscall_x64 arch/x86/entry/syscall_64.c:61 [inline]
       do_syscall_64+0x166/0x520 arch/x86/entry/syscall_64.c:84
       entry_SYSCALL_64_after_hwframe+0x77/0x7f

other info that might help us debug this:

Chain exists of:
  fs_reclaim --> &q->q_usage_counter(io)#17 --> &q->blkcg_mutex

 Possible unsafe locking scenario:

       CPU0                    CPU1
       ----                    ----
  lock(&q->blkcg_mutex);
                               lock(&q->q_usage_counter(io)#17);
                               lock(&q->blkcg_mutex);
  lock(fs_reclaim);

 *** DEADLOCK ***

locks held by syz.0.23/5880: 6, last CPU#1:
 #0: ffff88816db7d8f0 (&f->f_pos_lock){+.+.}-{4:4}, at: fdget_pos+0x246/0x320 fs/file.c:1259
 #1: ffff88816ee86460 (sb_writers#10){.+.+}-{0:0}, at: file_start_write include/linux/fs.h:2753 [inline]
 #1: ffff88816ee86460 (sb_writers#10){.+.+}-{0:0}, at: vfs_write+0x22b/0xba0 fs/read_write.c:683
 #2: ffff88816db7ac80 (&of->mutex){+.+.}-{4:4}, at: kernfs_fop_write_iter+0x1d8/0x540 fs/kernfs/file.c:336
 #3: ffff88816fe82e18 (kn->active#56){.+.+}-{0:0}, at: kernfs_get_active_of fs/kernfs/file.c:73 [inline]
 #3: ffff88816fe82e18 (kn->active#56){.+.+}-{0:0}, at: kernfs_fop_write_iter+0x22b/0x540 fs/kernfs/file.c:337
 #4: ffff88810a0b3a40 (&q->rq_qos_mutex){+.+.}-{4:4}, at: blkg_conf_open_bdev+0x2a8/0x3c0 block/blk-cgroup.c:806
 #5: ffff88810a0b3bc0 (&q->blkcg_mutex){+.+.}-{4:4}, at: blkg_conf_prep+0xa3/0xd80 block/blk-cgroup.c:849

stack backtrace:
CPU: 1 UID: 0 PID: 5880 Comm: syz.0.23 Not tainted syzkaller #0 PREEMPT(full) 
Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS 1.16.2-debian-1.16.2-1 04/01/2014
Call Trace:
 <TASK>
 dump_stack_lvl+0xe8/0x150 lib/dump_stack.c:120
 print_circular_bug+0x2e2/0x300 kernel/locking/lockdep.c:2059
 check_noncircular+0x12f/0x150 kernel/locking/lockdep.c:2191
 check_prev_add kernel/locking/lockdep.c:3181 [inline]
 check_prevs_add kernel/locking/lockdep.c:3300 [inline]
 validate_chain kernel/locking/lockdep.c:3924 [inline]
 __lock_acquire+0x15ff/0x2e50 kernel/locking/lockdep.c:5254
 lock_acquire+0x115/0x350 kernel/locking/lockdep.c:5908
 __fs_reclaim_acquire mm/page_alloc.c:4375 [inline]
 fs_reclaim_acquire+0x71/0x100 mm/page_alloc.c:4389
 might_alloc include/linux/sched/mm.h:316 [inline]
 slab_pre_alloc_hook mm/slub.c:4636 [inline]
 slab_alloc_node mm/slub.c:4974 [inline]
 kmem_cache_alloc_noprof+0x5f/0x600 mm/slub.c:5010
 __radix_tree_preload+0x2df/0x870 lib/radix-tree.c:338
 blkg_conf_prep+0x621/0xd80 block/blk-cgroup.c:885
 tg_set_conf+0x20b/0x4e0 block/blk-throttle.c:1373
 cgroup_file_write+0x331/0x8f0 kernel/cgroup/cgroup.c:4412
 kernfs_fop_write_iter+0x3a4/0x540 fs/kernfs/file.c:345
 new_sync_write fs/read_write.c:595 [inline]
 vfs_write+0x612/0xba0 fs/read_write.c:687
 ksys_write+0x150/0x270 fs/read_write.c:739
 do_syscall_x64 arch/x86/entry/syscall_64.c:61 [inline]
 do_syscall_64+0x166/0x520 arch/x86/entry/syscall_64.c:84
 entry_SYSCALL_64_after_hwframe+0x77/0x7f
RIP: 0033:0x7f8d5f99e159
Code: ff c3 66 2e 0f 1f 84 00 00 00 00 00 0f 1f 44 00 00 48 89 f8 48 89 f7 48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 ff ff 73 01 c3 48 c7 c1 e8 ff ff ff f7 d8 64 89 01 48
RSP: 002b:00007f8d608b0028 EFLAGS: 00000246 ORIG_RAX: 0000000000000001
RAX: ffffffffffffffda RBX: 00007f8d5fc25fa0 RCX: 00007f8d5f99e159
RDX: 000000000000006a RSI: 00002000000000c0 RDI: 0000000000000005
RBP: 00007f8d5fa35024 R08: 0000000000000000 R09: 0000000000000000
R10: 0000000000000000 R11: 0000000000000246 R12: 0000000000000000
R13: 00007f8d5fc26038 R14: 00007f8d5fc25fa0 R15: 00007ffd10d387c8
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
[akpm@linux-foundation.org cgroups@vger.kernel.org hannes@cmpxchg.org kernel-team@meta.com linux-kernel@vger.kernel.org linux-mm@kvack.org mhocko@kernel.org muchun.song@linux.dev riel@surriel.com roman.gushchin@linux.dev shakeel.butt@linux.dev]

If the report looks fine to you, reply with:
#syz upstream

If the report is a false positive, reply with
#syz invalid

