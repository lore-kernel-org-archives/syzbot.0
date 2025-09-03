Received: from mail-il1-f198.google.com (mail-il1-f198.google.com [209.85.166.198])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 03D1E2EC56F
	for <syzbot@lists.linux.dev>; Wed,  3 Sep 2025 21:53:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.198
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756936425; cv=none; b=tv/WU70/y+qTvklEhndOPuuOaCn/L4be1ZuGSrw0ts5yyNH0dBm1LpXvl/HHko2agX84AXlBh3yOTzpq8TPlVgz3SYIVe5gZe6I6A8QA9FDCZTfRRs3Y6VY+nKZd7CFKxcW2UK+kNNKmRL5Pq/c7ytpSefQaNaGT+hMqNM7suz0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756936425; c=relaxed/simple;
	bh=GDCbW90cFJ3OVUHaq2eU5ygnheokkwkvlymXL8mtCL8=;
	h=MIME-Version:Date:In-Reply-To:Message-ID:Subject:From:To:Cc:
	 Content-Type; b=XrJMg6iksE2pZ01TxAOWQ8KvLF0TpLmwgaeN8i5hhfP2Ujj4aK2ahfA4JlmOKllH1ktOwpfz9+i9GVrmm7wgy0Pw57WeeklVSVnQYTk1HJFe0FqxjX5Sdo1e9fISJRlhdEuoCKaHt7OofsLSBiFIfbZImeVVB8JkF8dNbKJLfVc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com; arc=none smtp.client-ip=209.85.166.198
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com
Received: by mail-il1-f198.google.com with SMTP id e9e14a558f8ab-3f12be6bc4aso4160175ab.1
        for <syzbot@lists.linux.dev>; Wed, 03 Sep 2025 14:53:43 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1756936423; x=1757541223;
        h=cc:to:from:subject:message-id:in-reply-to:date:mime-version
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=0se4TpCFyD6RILSNfsbrrII1qLTm3jujIuylWaXL718=;
        b=dFqGhu1lvADY3Q3NwkEXOnUR95NL033/wsobea6E8vWXgmB79NYnbUVDwHI0W29oYj
         VMWrhaU/aZE1JArHuiPb8kI6aUVMw5aWSTVNmD1VUM5/3tSe0ihzJv3Lr7bVxgSrSecN
         V2nCe+5bPy2uXqQh0Tl9g8t5JIIiLUTALqheBrpWnQ/x6/9tR6UYfyfgiAWjrgfNj30v
         6H5Wge8Kt5ESF85Hquu/rdJGqc65JKcAdzJZE1+w9V6mAVNdN75fsAKNqSCYw1ueM6tz
         cLEUoVFJHpUPT++l5jlm9hxlAOyJFmk7Lkkadcc1lpMUSYQf5KcwewpKu4nkszLoi0LS
         Ww6Q==
X-Gm-Message-State: AOJu0YyXhcRxdm61efG3UUtiCwtRsMMOEEQvsE8HvFlRVTX+nrOVOsDy
	mm6KQxecG/2cDjMJVnD+6+aQoSYOxJPuQI+SPafJyfdw5kN3U8/phCAD4NeeTLCJSit8+oBQy9m
	xWiF48JJVb0kfiyDlv1QoR7V1A+fu11Q/8E+uP4eBfMH2o59LclFIFS65fMU=
X-Google-Smtp-Source: AGHT+IEJ0nYfBB5EYbHNoEHlmJTQiN3zZygLidkrnPGvykMjam1Lc+j5uH0mhmBEHx0U40x9wmuRP/LIKPX84kwyMmXtXCYb48Lb
Precedence: bulk
X-Mailing-List: syzbot@lists.linux.dev
List-Id: <syzbot.lists.linux.dev>
List-Subscribe: <mailto:syzbot+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:syzbot+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Received: by 2002:a05:6e02:4903:b0:3f6:5621:fbde with SMTP id
 e9e14a558f8ab-3f65621fe5fmr153119265ab.6.1756936423199; Wed, 03 Sep 2025
 14:53:43 -0700 (PDT)
Date: Wed, 03 Sep 2025 14:53:43 -0700
In-Reply-To: <20250903024406.2418362-1-xuanqiang.luo@linux.dev>
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <68b8b8e7.050a0220.3db4df.0204.GAE@google.com>
Subject: [syzbot ci] Re: inet: Avoid established lookup missing active sk
From: syzbot ci <syzbot+ci5d61d9552f28b0e0@syzkaller.appspotmail.com>
To: davem@davemloft.net, edumazet@google.com, kernelxing@tencent.com, 
	kuba@kernel.org, kuniyu@google.com, luoxuanqiang@kylinos.cn, 
	netdev@vger.kernel.org, xuanqiang.luo@linux.dev
Cc: syzbot@lists.linux.dev, syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"

syzbot ci has tested the following series

[v1] inet: Avoid established lookup missing active sk
https://lore.kernel.org/all/20250903024406.2418362-1-xuanqiang.luo@linux.dev
* [PATCH net] inet: Avoid established lookup missing active sk

and found the following issue:
inconsistent lock state in valid_state

Full report is available here:
https://ci.syzbot.org/series/e3eb0778-d6ff-4b0c-ae24-a5451a3472cb

***

inconsistent lock state in valid_state

tree:      net
URL:       https://kernel.googlesource.com/pub/scm/linux/kernel/git/netdev/net.git
base:      788bc43d8330511af433bf282021a8fecb6b9009
arch:      amd64
compiler:  Debian clang version 20.1.8 (++20250708063551+0c9f909b7976-1~exp1~20250708183702.136), Debian LLD 20.1.8
config:    https://ci.syzbot.org/builds/4fba502f-1812-45fd-881c-e5889996074b/config
C repro:   https://ci.syzbot.org/findings/1fde3273-fc6e-4ca1-9a99-a8f866c822cd/c_repro
syz repro: https://ci.syzbot.org/findings/1fde3273-fc6e-4ca1-9a99-a8f866c822cd/syz_repro

================================
WARNING: inconsistent lock state
syzkaller #0 Not tainted
--------------------------------
inconsistent {IN-SOFTIRQ-W} -> {SOFTIRQ-ON-W} usage.
syz.0.17/5984 [HC0[0]:SC0[0]:HE1:SE1] takes:
ffffc90000069958 (&ptr[i]){+.?.}-{3:3}, at: spin_lock include/linux/spinlock.h:351 [inline]
ffffc90000069958 (&ptr[i]){+.?.}-{3:3}, at: __inet_lookup_established+0x71d/0x8d0 net/ipv4/inet_hashtables.c:537
{IN-SOFTIRQ-W} state was registered at:
  lock_acquire+0x120/0x360 kernel/locking/lockdep.c:5868
  __raw_spin_lock include/linux/spinlock_api_smp.h:133 [inline]
  _raw_spin_lock+0x2e/0x40 kernel/locking/spinlock.c:154
  spin_lock include/linux/spinlock.h:351 [inline]
  __inet_lookup_established+0x71d/0x8d0 net/ipv4/inet_hashtables.c:537
  tcp_v4_early_demux+0x4e1/0x9d0 net/ipv4/tcp_ipv4.c:1995
  ip_rcv_finish_core+0x108e/0x1c00 net/ipv4/ip_input.c:346
  ip_list_rcv_finish net/ipv4/ip_input.c:616 [inline]
  ip_sublist_rcv+0x397/0x9b0 net/ipv4/ip_input.c:642
  ip_list_rcv+0x3e2/0x430 net/ipv4/ip_input.c:676
  __netif_receive_skb_list_ptype net/core/dev.c:6034 [inline]
  __netif_receive_skb_list_core+0x7d2/0x800 net/core/dev.c:6081
  __netif_receive_skb_list net/core/dev.c:6133 [inline]
  netif_receive_skb_list_internal+0x975/0xcc0 net/core/dev.c:6224
  gro_normal_list include/net/gro.h:532 [inline]
  gro_flush_normal include/net/gro.h:540 [inline]
  napi_complete_done+0x2f2/0x7c0 net/core/dev.c:6593
  e1000_clean+0xd0b/0x2b00 drivers/net/ethernet/intel/e1000/e1000_main.c:3815
  __napi_poll+0xc7/0x360 net/core/dev.c:7506
  napi_poll net/core/dev.c:7569 [inline]
  net_rx_action+0x707/0xe30 net/core/dev.c:7696
  handle_softirqs+0x286/0x870 kernel/softirq.c:579
  __do_softirq kernel/softirq.c:613 [inline]
  invoke_softirq kernel/softirq.c:453 [inline]
  __irq_exit_rcu+0xca/0x1f0 kernel/softirq.c:680
  irq_exit_rcu+0x9/0x30 kernel/softirq.c:696
  common_interrupt+0xbb/0xe0 arch/x86/kernel/irq.c:318
  asm_common_interrupt+0x26/0x40 arch/x86/include/asm/idtentry.h:693
  native_safe_halt arch/x86/include/asm/irqflags.h:48 [inline]
  pv_native_safe_halt+0x13/0x20 arch/x86/kernel/paravirt.c:81
  arch_safe_halt arch/x86/include/asm/paravirt.h:107 [inline]
  default_idle+0x13/0x20 arch/x86/kernel/process.c:757
  default_idle_call+0x74/0xb0 kernel/sched/idle.c:122
  cpuidle_idle_call kernel/sched/idle.c:190 [inline]
  do_idle+0x1e8/0x510 kernel/sched/idle.c:330
  cpu_startup_entry+0x44/0x60 kernel/sched/idle.c:428
  start_secondary+0x101/0x110 arch/x86/kernel/smpboot.c:315
  common_startup_64+0x13e/0x147
irq event stamp: 807
hardirqs last  enabled at (807): [<ffffffff8184e7fd>] __local_bh_enable_ip+0x12d/0x1c0 kernel/softirq.c:412
hardirqs last disabled at (805): [<ffffffff8184e79e>] __local_bh_enable_ip+0xce/0x1c0 kernel/softirq.c:389
softirqs last  enabled at (806): [<ffffffff8962777b>] local_bh_disable include/linux/bottom_half.h:20 [inline]
softirqs last  enabled at (806): [<ffffffff8962777b>] rcu_read_lock_bh include/linux/rcupdate.h:892 [inline]
softirqs last  enabled at (806): [<ffffffff8962777b>] __dev_queue_xmit+0x27b/0x3b50 net/core/dev.c:4650
softirqs last disabled at (798): [<ffffffff8962777b>] local_bh_disable include/linux/bottom_half.h:20 [inline]
softirqs last disabled at (798): [<ffffffff8962777b>] rcu_read_lock_bh include/linux/rcupdate.h:892 [inline]
softirqs last disabled at (798): [<ffffffff8962777b>] __dev_queue_xmit+0x27b/0x3b50 net/core/dev.c:4650

other info that might help us debug this:
 Possible unsafe locking scenario:

       CPU0
       ----
  lock(&ptr[i]);
  <Interrupt>
    lock(&ptr[i]);

 *** DEADLOCK ***

1 lock held by syz.0.17/5984:
 #0: ffffffff8e139ee0 (rcu_read_lock){....}-{1:3}, at: rcu_lock_acquire include/linux/rcupdate.h:331 [inline]
 #0: ffffffff8e139ee0 (rcu_read_lock){....}-{1:3}, at: rcu_read_lock include/linux/rcupdate.h:841 [inline]
 #0: ffffffff8e139ee0 (rcu_read_lock){....}-{1:3}, at: inet_diag_find_one_icsk+0x2e/0x790 net/ipv4/inet_diag.c:527

stack backtrace:
CPU: 0 UID: 0 PID: 5984 Comm: syz.0.17 Not tainted syzkaller #0 PREEMPT(full) 
Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS 1.16.2-debian-1.16.2-1 04/01/2014
Call Trace:
 <TASK>
 dump_stack_lvl+0x189/0x250 lib/dump_stack.c:120
 print_usage_bug+0x297/0x2e0 kernel/locking/lockdep.c:4042
 valid_state+0xc3/0xf0 kernel/locking/lockdep.c:4056
 mark_lock_irq+0x36/0x390 kernel/locking/lockdep.c:4267
 mark_lock+0x11b/0x190 kernel/locking/lockdep.c:4753
 mark_usage kernel/locking/lockdep.c:-1 [inline]
 __lock_acquire+0x9e2/0xd20 kernel/locking/lockdep.c:5191
 lock_acquire+0x120/0x360 kernel/locking/lockdep.c:5868
 __raw_spin_lock include/linux/spinlock_api_smp.h:133 [inline]
 _raw_spin_lock+0x2e/0x40 kernel/locking/spinlock.c:154
 spin_lock include/linux/spinlock.h:351 [inline]
 __inet_lookup_established+0x71d/0x8d0 net/ipv4/inet_hashtables.c:537
 __inet_lookup include/net/inet_hashtables.h:408 [inline]
 inet_lookup+0xc4/0x290 include/net/inet_hashtables.h:428
 inet_diag_find_one_icsk+0x1c1/0x790 net/ipv4/inet_diag.c:529
 inet_diag_dump_one_icsk+0xa4/0x520 net/ipv4/inet_diag.c:576
 inet_diag_cmd_exact+0x3d5/0x4e0 net/ipv4/inet_diag.c:628
 inet_diag_get_exact_compat net/ipv4/inet_diag.c:1406 [inline]
 inet_diag_rcv_msg_compat+0x2b5/0x3b0 net/ipv4/inet_diag.c:1428
 sock_diag_rcv_msg+0x4cc/0x600 net/core/sock_diag.c:-1
 netlink_rcv_skb+0x208/0x470 net/netlink/af_netlink.c:2552
 netlink_unicast_kernel net/netlink/af_netlink.c:1320 [inline]
 netlink_unicast+0x82f/0x9e0 net/netlink/af_netlink.c:1346
 netlink_sendmsg+0x805/0xb30 net/netlink/af_netlink.c:1896
 sock_sendmsg_nosec net/socket.c:714 [inline]
 __sock_sendmsg+0x21c/0x270 net/socket.c:729
 ____sys_sendmsg+0x505/0x830 net/socket.c:2614
 ___sys_sendmsg+0x21f/0x2a0 net/socket.c:2668
 __sys_sendmsg net/socket.c:2700 [inline]
 __do_sys_sendmsg net/socket.c:2705 [inline]
 __se_sys_sendmsg net/socket.c:2703 [inline]
 __x64_sys_sendmsg+0x19b/0x260 net/socket.c:2703
 do_syscall_x64 arch/x86/entry/syscall_64.c:63 [inline]
 do_syscall_64+0xfa/0x3b0 arch/x86/entry/syscall_64.c:94
 entry_SYSCALL_64_after_hwframe+0x77/0x7f
RIP: 0033:0x7f0e1a18ebe9
Code: ff ff c3 66 2e 0f 1f 84 00 00 00 00 00 0f 1f 40 00 48 89 f8 48 89 f7 48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 ff ff 73 01 c3 48 c7 c1 a8 ff ff ff f7 d8 64 89 01 48
RSP: 002b:00007ffd085aadc8 EFLAGS: 00000246 ORIG_RAX: 000000000000002e
RAX: ffffffffffffffda RBX: 00007f0e1a3c5fa0 RCX: 00007f0e1a18ebe9
RDX: 0000000000000000 RSI: 0000200000000200 RDI: 0000000000000003
RBP: 00007f0e1a211e19 R08: 0000000000000000 R09: 0000000000000000
R10: 0000000000000000 R11: 0000000000000246 R12: 0000000000000000
R13: 00007f0e1a3c5fa0 R14: 00007f0e1a3c5fa0 R15: 0000000000000003
 </TASK>


***

If these findings have caused you to resend the series or submit a
separate fix, please add the following tag to your commit message:
  Tested-by: syzbot@syzkaller.appspotmail.com

---
This report is generated by a bot. It may contain errors.
syzbot ci engineers can be reached at syzkaller@googlegroups.com.
