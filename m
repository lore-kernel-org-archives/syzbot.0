Received: from mail-oi1-f208.google.com (mail-oi1-f208.google.com [209.85.167.208])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AC5B137266E
	for <syzbot@lists.linux.dev>; Sun, 16 Aug 2026 15:09:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.167.208
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786892979; cv=none; b=lCkO6lOPdSXP1WHyW+5P4kAwl3pqjZpjgal0i0hzN3PHij6eNLqlHMhxYUKdiPyRlxj/KkJiggrc24d+LJbYnKR5DOqR4BamQDDn6GEl7wFEZGhrCjVKNdkH+zIjBEAc5SN/N4MuN0RIHeqrJAzhP2KJssegNhRGctwVXN5wz/g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786892979; c=relaxed/simple;
	bh=JlCT7Tjz2b9m7+URJCo3zLEgfl+7Y78A4svG4WZIAis=;
	h=MIME-Version:Date:In-Reply-To:Message-ID:Subject:From:To:
	 Content-Type; b=eiuPnD6YppiwIIHcsTv6H/rdcOb+y9hAiJXobil6JUfF2dUNScqmL7lqpibWqK5lttgC86+5yxIBdgXyfDBO4cIjNNWyfWulHKo8KiZ9Hw/YWqZP65mpOMu1Evy/gtHxyVY/+LQvvhjsN9mtN3txXOdmOnpAfIbTcoyGpKNOBdA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com; arc=none smtp.client-ip=209.85.167.208
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com
Received: by mail-oi1-f208.google.com with SMTP id 5614622812f47-4a4a7d0362eso3097942b6e.0
        for <syzbot@lists.linux.dev>; Sun, 16 Aug 2026 08:09:37 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1786892976; x=1787497776;
        h=content-type:to:from:subject:message-id:in-reply-to:date
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to:content-type;
        bh=UrfefYR3alXM+nZyPeL2keqEf+3xxZ4A+CBJes0IpY0=;
        b=Z9xh+iDx3IjWJS2OvJXUw1eOSnAVoxt6o2wfz0KcM5V98euppCkDf7qTDirrINDg5k
         AjZzLZE+a+6Ug7BqJukik+FumhTG0qHrMV6w8mk2JSjaQE476rCfpvQnIaMyCNglbPiU
         a6Wtc1skd4AR4SpUGBrIaMr/g6c6c/SS8V0Hg180kNL/Nrh3CwWL2zhzL5V+NJ+CRfB1
         haDvqsjC8qEQwv54S3aV+2J98/LtDzOn7Qb7xpk5bi6d62kKPA7DHRu6CJiTqhbAAMsc
         v6yw/OeS2/+cpdwZrwEdPDIks87IM9AhAFl//DeQ4eW19S2/9Lrj3PPwkXdQG7u7DUbM
         3ryA==
X-Forwarded-Encrypted: i=1; AHgh+Ror7HVvokiVIchojCXsSorYIH8omSxNP/XtRifajW56erKecrHgxwaXK/qM3+us1W5PUgivFvo=@lists.linux.dev
X-Gm-Message-State: AOJu0YxZLWXALI+p2KU28sYG/Hu2EMNz69LHu/e8fFcPkx6Ai6LxsBw8
	SSIgkb23/F85tYfkuU2+8h8//6fhuxZcz0jOWUu7BvXlQMh58yjP1w1yoAALS3RSXbkwnc9gyld
	+rlDlBRVEWpFFwe9BXw/YDonuqaQU2VnjQKEzQVR72qVaUy56amOxqxkfbpY=
Precedence: bulk
X-Mailing-List: syzbot@lists.linux.dev
List-Id: <syzbot.lists.linux.dev>
List-Subscribe: <mailto:syzbot+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:syzbot+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Received: by 2002:a05:6808:3447:b0:4af:88b7:94a5 with SMTP id
 5614622812f47-4b2412b0729mr16974943b6e.5.1786892976599; Sun, 16 Aug 2026
 08:09:36 -0700 (PDT)
Date: Sun, 16 Aug 2026 08:09:36 -0700
In-Reply-To: <68b016f0.a00a0220.1337b0.0004.GAE@google.com>
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <6a81d2b0.dbb3a75c.20434b.0035.GAE@google.com>
Subject: Re: [syzbot] [block?] INFO: task hung in queue_limits_commit_update_frozen
From: syzbot <syzbot+f272bbfbf8498ddadea5@syzkaller.appspotmail.com>
To: axboe@kernel.dk, hch@lst.de, josef@toxicpanda.com, 
	krystianmkaniewski@gmail.com, linux-block@vger.kernel.org, 
	linux-kernel@vger.kernel.org, nbd@other.debian.org, netdev@vger.kernel.org, 
	syzbot@kernel.org, syzbot@lists.linux.dev, syzkaller-bugs@googlegroups.com, 
	syzkaller-upstream-moderation@googlegroups.com
Content-Type: text/plain; charset="UTF-8"

syzbot has found a reproducer for the following issue on:

HEAD commit:    e6a5d573d24c net: dsa: drop explicit NULL comparisons
git tree:       net-next
console+strace: https://syzkaller.appspot.com/x/log.txt?x=17149949580000
kernel config:  https://syzkaller.appspot.com/x/.config?x=f2baeae6059376eb
dashboard link: https://syzkaller.appspot.com/bug?extid=f272bbfbf8498ddadea5
compiler:       Debian clang version 22.1.8 (++20260613092233+e80beda6e255-1~exp1~20260613092250.77), Debian LLD 22.1.8
syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=135696c6580000
C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=15dd4679580000

Downloadable assets:
disk image: https://storage.googleapis.com/syzbot-assets/ec03d2a9ef9c/disk-e6a5d573.raw.xz
vmlinux: https://storage.googleapis.com/syzbot-assets/4d46598728d1/vmlinux-e6a5d573.xz
kernel image: https://storage.googleapis.com/syzbot-assets/cae584a81da1/bzImage-e6a5d573.xz

IMPORTANT: if you fix the issue, please add the following tag to the commit:
Reported-by: syzbot+f272bbfbf8498ddadea5@syzkaller.appspotmail.com

INFO: task syz-executor261:5647 blocked for more than 143 seconds.
      Not tainted syzkaller #0
"echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
task:syz-executor261 state:D stack:24224 pid:5647  tgid:5646  ppid:5643   task_flags:0x480140 flags:0x00080002
Call Trace:
 <TASK>
 context_switch kernel/sched/core.c:5510 [inline]
 __schedule+0x17d9/0x56c0 kernel/sched/core.c:7234
 __schedule_loop kernel/sched/core.c:7311 [inline]
 schedule+0x164/0x2b0 kernel/sched/core.c:7326
 blk_mq_freeze_queue_wait+0x101/0x180 block/blk-mq.c:191
 blk_mq_freeze_queue include/linux/blk-mq.h:956 [inline]
 queue_limits_commit_update_frozen+0x55/0xd0 block/blk-settings.c:590
 nbd_set_size+0x454/0x680 drivers/block/nbd.c:374
 nbd_genl_size_set drivers/block/nbd.c:2106 [inline]
 nbd_genl_reconfigure+0x7e9/0x1e80 drivers/block/nbd.c:2410
 genl_family_rcv_msg_doit+0x233/0x340 net/netlink/genetlink.c:1114
 genl_family_rcv_msg net/netlink/genetlink.c:1194 [inline]
 genl_rcv_msg+0x614/0x7a0 net/netlink/genetlink.c:1209
 netlink_rcv_skb+0x226/0x4a0 net/netlink/af_netlink.c:2556
 genl_rcv+0x28/0x40 net/netlink/genetlink.c:1218
 netlink_unicast_kernel net/netlink/af_netlink.c:1319 [inline]
 netlink_unicast+0x7bb/0x940 net/netlink/af_netlink.c:1345
 netlink_sendmsg+0x813/0xb40 net/netlink/af_netlink.c:1900
 sock_sendmsg_nosec+0x13a/0x180 net/socket.c:775
 __sock_sendmsg net/socket.c:790 [inline]
 ____sys_sendmsg+0x54e/0x850 net/socket.c:2684
 ___sys_sendmsg+0x2a5/0x360 net/socket.c:2738
 __sys_sendmsg net/socket.c:2770 [inline]
 __do_sys_sendmsg net/socket.c:2775 [inline]
 __se_sys_sendmsg net/socket.c:2773 [inline]
 __x64_sys_sendmsg+0x1b1/0x290 net/socket.c:2773
 do_syscall_x64 arch/x86/entry/syscall_64.c:63 [inline]
 do_syscall_64+0x174/0x580 arch/x86/entry/syscall_64.c:94
 entry_SYSCALL_64_after_hwframe+0x77/0x7f
RIP: 0033:0x7f289ec90aa9
RSP: 002b:00007f289ec611d8 EFLAGS: 00000246 ORIG_RAX: 000000000000002e
RAX: ffffffffffffffda RBX: 00007f289ed3bb88 RCX: 00007f289ec90aa9
RDX: 0000000000080000 RSI: 0000200000000c40 RDI: 0000000000000006
RBP: 00007f289ed3bb80 R08: 35203a6b63617473 R09: 35203a6b63617473
R10: 35203a6b63617473 R11: 0000000000000246 R12: 00007f289ed0c4a0
R13: 0000200000000c00 R14: 0000200000000c50 R15: 0000200000000c40
 </TASK>

Showing all locks held in the system:
1 lock held by khungtaskd/31:
 #0: ffffffff8eb59c60 (rcu_read_lock){....}-{1:3}, at: rcu_lock_acquire include/linux/rcupdate.h:300 [inline]
 #0: ffffffff8eb59c60 (rcu_read_lock){....}-{1:3}, at: rcu_read_lock include/linux/rcupdate.h:840 [inline]
 #0: ffffffff8eb59c60 (rcu_read_lock){....}-{1:3}, at: debug_show_all_locks+0x2e/0x180 kernel/locking/lockdep.c:6775
2 locks held by kworker/u9:0/50:
 #0: ffff888026e67940 ((wq_completion)nbd0-recv){+.+.}-{0:0}, at: process_one_work kernel/workqueue.c:3297 [inline]
 #0: ffff888026e67940 ((wq_completion)nbd0-recv){+.+.}-{0:0}, at: process_scheduled_works+0xa20/0x14e0 kernel/workqueue.c:3405
 #1: ffffc90000bb7c40 ((work_completion)(&args->work)){+.+.}-{0:0}, at: process_one_work kernel/workqueue.c:3297 [inline]
 #1: ffffc90000bb7c40 ((work_completion)(&args->work)){+.+.}-{0:0}, at: process_scheduled_works+0xa20/0x14e0 kernel/workqueue.c:3405
7 locks held by kworker/u8:4/62:
 #0: ffff88801b06c140 ((wq_completion)events_unbound){+.+.}-{0:0}, at: process_one_work kernel/workqueue.c:3297 [inline]
 #0: ffff88801b06c140 ((wq_completion)events_unbound){+.+.}-{0:0}, at: process_scheduled_works+0xa20/0x14e0 kernel/workqueue.c:3405
 #1: ffffc9000203fc40 ((work_completion)(&(&kfence_timer)->work)){+.+.}-{0:0}, at: process_one_work kernel/workqueue.c:3297 [inline]
 #1: ffffc9000203fc40 ((work_completion)(&(&kfence_timer)->work)){+.+.}-{0:0}, at: process_scheduled_works+0xa20/0x14e0 kernel/workqueue.c:3405
 #2: ffffffff8e9e75f0 (cpu_hotplug_lock){++++}-{0:0}, at: lock_timer_base kernel/time/timer.c:1004 [inline]
 #2: ffffffff8e9e75f0 (cpu_hotplug_lock){++++}-{0:0}, at: __mod_timer+0x1a9/0xed0 kernel/time/timer.c:1085
 #3: ffffffff9a991198 (&obj_hash[i].lock){-.-.}-{2:2}, at: debug_object_activate+0xb7/0x420 lib/debugobjects.c:873
 #4: ffffffff8e9fd1a0 (text_mutex){+.+.}-{4:4}, at: arch_jump_label_transform_apply+0x17/0x30 arch/x86/kernel/jump_label.c:145
 #5: ffffffff8eb59c60 (rcu_read_lock){....}-{1:3}, at: rcu_lock_acquire include/linux/rcupdate.h:300 [inline]
 #5: ffffffff8eb59c60 (rcu_read_lock){....}-{1:3}, at: rcu_read_lock include/linux/rcupdate.h:840 [inline]
 #5: ffffffff8eb59c60 (rcu_read_lock){....}-{1:3}, at: __pte_offset_map+0x29/0x240 mm/pgtable-generic.c:290
 #6: ffff88801b060618 (ptlock_ptr(ptdesc)#2){+.+.}-{3:3}, at: spin_lock include/linux/spinlock.h:342 [inline]
 #6: ffff88801b060618 (ptlock_ptr(ptdesc)#2){+.+.}-{3:3}, at: pte_offset_map_lock+0x13d/0x210 mm/pgtable-generic.c:404
2 locks held by getty/5362:
 #0: ffff88803616f0a0 (&tty->ldisc_sem){++++}-{0:0}, at: tty_ldisc_ref_wait+0x25/0x70 drivers/tty/tty_ldisc.c:243
 #1: ffffc900032332e8 (&ldata->atomic_read_lock){+.+.}-{4:4}, at: n_tty_read+0x45a/0x1360 drivers/tty/n_tty.c:2211
1 lock held by udevd/5644:
 #0: ffff888026e70350 (&disk->open_mutex){+.+.}-{4:4}, at: bdev_open+0xde/0xd70 block/bdev.c:948
6 locks held by syz-executor261/5647:
 #0: ffffffff90099b68 (cb_lock){++++}-{4:4}, at: genl_rcv+0x19/0x40 net/netlink/genetlink.c:1217
 #1: ffffffff900999a0 (genl_mutex){+.+.}-{4:4}, at: genl_lock net/netlink/genetlink.c:35 [inline]
 #1: ffffffff900999a0 (genl_mutex){+.+.}-{4:4}, at: genl_op_lock net/netlink/genetlink.c:60 [inline]
 #1: ffffffff900999a0 (genl_mutex){+.+.}-{4:4}, at: genl_rcv_msg+0x10b/0x7a0 net/netlink/genetlink.c:1208
 #2: ffff888026e60260 (&nbd->config_lock){+.+.}-{4:4}, at: nbd_genl_reconfigure+0x4bc/0x1e80 drivers/block/nbd.c:2401
 #3: ffff888026f747c8 (&q->limits_lock){+.+.}-{4:4}, at: queue_limits_start_update include/linux/blkdev.h:1103 [inline]
 #3: ffff888026f747c8 (&q->limits_lock){+.+.}-{4:4}, at: nbd_set_size+0x263/0x680 drivers/block/nbd.c:354
 #4: ffff888026f74190 (&q->q_usage_counter(io)#49){++++}-{0:0}, at: blk_mq_freeze_queue include/linux/blk-mq.h:956 [inline]
 #4: ffff888026f74190 (&q->q_usage_counter(io)#49){++++}-{0:0}, at: queue_limits_commit_update_frozen+0x55/0xd0 block/blk-settings.c:590
 #5: ffff888026f741c8 (&q->q_usage_counter(queue)#33){+.+.}-{0:0}, at: blk_mq_freeze_queue include/linux/blk-mq.h:956 [inline]
 #5: ffff888026f741c8 (&q->q_usage_counter(queue)#33){+.+.}-{0:0}, at: queue_limits_commit_update_frozen+0x55/0xd0 block/blk-settings.c:590

=============================================

NMI backtrace for cpu 1
CPU: 1 UID: 0 PID: 31 Comm: khungtaskd Not tainted syzkaller #0 PREEMPT(full) 
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 07/24/2026
Call Trace:
 <TASK>
 dump_stack_lvl+0xe8/0x150 lib/dump_stack.c:120
 nmi_cpu_backtrace+0x274/0x2d0 lib/nmi_backtrace.c:122
 nmi_trigger_cpumask_backtrace+0x17a/0x380 lib/nmi_backtrace.c:65
 trigger_all_cpu_backtrace include/linux/nmi.h:162 [inline]
 __sys_info lib/sys_info.c:157 [inline]
 sys_info+0x135/0x170 lib/sys_info.c:165
 check_hung_uninterruptible_tasks kernel/hung_task.c:353 [inline]
 watchdog+0xfd7/0x1030 kernel/hung_task.c:561
 kthread+0x388/0x470 kernel/kthread.c:436
 ret_from_fork+0x514/0xb70 arch/x86/kernel/process.c:158
 ret_from_fork_asm+0x1a/0x30 arch/x86/entry/entry_64.S:245
 </TASK>
Sending NMI from CPU 1 to CPUs 0:
NMI backtrace for cpu 0
CPU: 0 UID: 0 PID: 0 Comm: swapper/0 Not tainted syzkaller #0 PREEMPT(full) 
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 07/24/2026
RIP: 0010:pv_native_safe_halt+0xf/0x20 arch/x86/kernel/paravirt.c:64
Code: bb 7c 02 c3 cc cc cc cc cc cc cc 90 90 90 90 90 90 90 90 90 90 90 90 90 90 90 90 f3 0f 1e fa 66 90 0f 00 2d b3 ce 15 00 fb f4 <e9> 4c 07 03 00 cc cc cc cc cc cc cc cc cc cc cc cc 90 90 90 90 90
RSP: 0018:ffffffff8e807de0 EFLAGS: 00000246
RAX: 00000000000de999 RBX: ffffffff819b433c RCX: 0000000080000001
RDX: 0000000000000001 RSI: ffffffff8e23666e RDI: ffffffff8c4bbf80
RBP: ffffffff8e807eb8 R08: ffff8880b86338db R09: 1ffff110170c671b
R10: dffffc0000000000 R11: ffffed10170c671c R12: 0000000000000000
R13: 1ffffffff1d11de8 R14: 1ffffffff1d00fc4 R15: dffffc0000000000
FS:  0000000000000000(0000) GS:ffff888124f4c000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 0000561f5d89e168 CR3: 000000000e946000 CR4: 00000000003526f0
Call Trace:
 <TASK>
 arch_safe_halt arch/x86/kernel/process.c:767 [inline]
 default_idle+0x9/0x20 arch/x86/kernel/process.c:768
 default_idle_call+0x72/0xb0 kernel/sched/idle.c:122
 cpuidle_idle_call kernel/sched/idle.c:199 [inline]
 do_idle+0x1cc/0x540 kernel/sched/idle.c:355
 cpu_startup_entry+0x43/0x60 kernel/sched/idle.c:454
 rest_init+0x2de/0x300 init/main.c:717
 start_kernel+0x392/0x3e0 init/main.c:1175
 x86_64_start_reservations+0x24/0x30 arch/x86/kernel/head64.c:310
 x86_64_start_kernel+0x137/0x1b0 arch/x86/kernel/head64.c:291
 common_startup_64+0x13e/0x157
 </TASK>


---
If you want syzbot to run the reproducer, reply with:
#syz test: git://repo/address.git branch-or-commit-hash
If you attach or paste a git patch, syzbot will apply it before testing.
