Received: from mail-oi2-f1.google.com (mail-oi2-f1.google.com [74.125.231.193])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 37B623B95F9
	for <syzbot@lists.linux.dev>; Fri, 28 Aug 2026 19:34:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=74.125.231.193
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787945676; cv=none; b=EZaTs4hqh9GMIVbh+tu4oFnH16mp5h3vy8DuksqiCPT4DyrnZD0knmXpSpAlXkr6JlxBb0gPavcue2aF/gZnuFVby5zawU+O4gLMkNPHqELe5CV7JJtYaMwScfkW8e8tWFK9Qvm2/H8wQbDW923czF/q/0hI5stCDUzCtmdE+ds=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787945676; c=relaxed/simple;
	bh=rIDic2O9l/GS7rRQDlr/0lWFt8qc/ste6l8CtDOTGr0=;
	h=MIME-Version:Date:In-Reply-To:Message-ID:Subject:From:To:
	 Content-Type; b=kP40W6Tp+x3b6iGSnlAa31ksBY/ei0CJ7E6KE5zEmsl15mg66j/daeitQIGmDAc8ZH3Im2JB4ssaS/ZJyQmCb4KKt9K7n0AKg/D+1JMcLiE8AQ3KiFYghxjJEtYLm/EgIFleLPL+KqN5kOvRTnrCeChCLMcaiWg+BbO5tHitcS0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com; arc=none smtp.client-ip=74.125.231.193
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com
Received: by mail-oi2-f1.google.com with SMTP id 5614622812f47-4b379409c74so475436b6e.0
        for <syzbot@lists.linux.dev>; Fri, 28 Aug 2026 12:34:35 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1787945674; x=1788550474;
        h=content-type:to:from:subject:message-id:in-reply-to:date
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to:content-type;
        bh=98nWEY1hN1kg8FloyxfUIcpI3fw4Dep5t6bB4KJAlno=;
        b=lEX7GUZTFMwAwtJzYhE2s5XjBkueEFlRwZTkJ6Pb9DVypxL0jVws5XCs/EAsP3dgt9
         l3RJt0luFaBojDhMfCZ24QHPlKMNAsNiLUaFNXaE1uhZQzR65jiVbitY3nCYcCaWJSDA
         e0JPtFODMRHd+HM6X0md7oI1bwVyqbliJJdCP06hQrvnvagI3Os7cfW+JH6V4WTh41oo
         zHpryzRr/c1kp1sqotnmwPB01HhmsniKXM/Z7gT+kgQcM6tvhK0f/Z3GsUljB577vrZn
         hqEityf0wdOJ188upIt74l4D5rA1Ci19gQtdRQumgmoiNV39IoRAJdoHyVXUOeeEVfZo
         FkbQ==
X-Forwarded-Encrypted: i=1; AHgh+RpRozxuMenZw3pYKbEaXMvB3WdjJ1oeBfLgdPd3VA7H62OYKAFTABoVvBH56C9rnCiq5Et2rIg=@lists.linux.dev
X-Gm-Message-State: AFuF++l3xt+2HvD1UcesEa8kp7ElMN/wJs/ROETUSCtBmFk4grn28OB9
	RD1DYpS0IWfUgBEVaSghTn70n0b5gMP00YFss8XkxK/ldze2HS1WdiLETe8prDRIjcGsJj0Uhbl
	alEyE3/o25MYGzEubn+6mMA38tPl0KNthfY4aIm5xkuit7ZVqw/kcLg2hOeg=
Precedence: bulk
X-Mailing-List: syzbot@lists.linux.dev
List-Id: <syzbot.lists.linux.dev>
List-Subscribe: <mailto:syzbot+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:syzbot+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Received: by 2002:a05:6808:1992:b0:4b3:2274:247a with SMTP id
 5614622812f47-4b39819525dmr10306895b6e.11.1787945674295; Fri, 28 Aug 2026
 12:34:34 -0700 (PDT)
Date: Fri, 28 Aug 2026 12:34:34 -0700
In-Reply-To: <6a7a68ea.9c11d2ce.289b96.00f3.GAE@google.com>
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <6a91e2ca.1d9ded08.62e62.00f3.GAE@google.com>
Subject: Re: [syzbot] [x25?] inconsistent lock state in valid_state (7)
From: syzbot <syzbot+15cbd86f569e8b084383@syzkaller.appspotmail.com>
To: davem@davemloft.net, edumazet@google.com, horms@kernel.org, 
	kirigirik076@gmail.com, kuba@kernel.org, linux-kernel@vger.kernel.org, 
	linux-x25@vger.kernel.org, ms@dev.tdt.de, netdev@vger.kernel.org, 
	pabeni@redhat.com, syzbot@kernel.org, syzbot@lists.linux.dev, 
	syzkaller-bugs@googlegroups.com, 
	syzkaller-upstream-moderation@googlegroups.com
Content-Type: text/plain; charset="UTF-8"

syzbot has found a reproducer for the following issue on:

HEAD commit:    1b78070aaef6 Merge tag 'net-7.3-rc1' of git://git.kernel.o..
git tree:       net-next
console+strace: https://syzkaller.appspot.com/x/log.txt?x=134d8c15580000
kernel config:  https://syzkaller.appspot.com/x/.config?x=5e4e3a0e188a497e
dashboard link: https://syzkaller.appspot.com/bug?extid=15cbd86f569e8b084383
compiler:       Debian clang version 22.1.8 (++20260613092233+e80beda6e255-1~exp1~20260613092250.77), Debian LLD 22.1.8
syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=14336d79580000
C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=1781ce25580000

Downloadable assets:
disk image: https://storage.googleapis.com/syzbot-assets/18856a03a9a3/disk-1b78070a.raw.xz
vmlinux: https://storage.googleapis.com/syzbot-assets/cc2bc68d7ef4/vmlinux-1b78070a.xz
kernel image: https://storage.googleapis.com/syzbot-assets/05a5e00f8f91/bzImage-1b78070a.xz

IMPORTANT: if you fix the issue, please add the following tag to the commit:
Reported-by: syzbot+15cbd86f569e8b084383@syzkaller.appspotmail.com

================================
WARNING: inconsistent lock state
syzkaller #0 Not tainted
--------------------------------
inconsistent {SOFTIRQ-ON-W} -> {IN-SOFTIRQ-W} usage.
ksoftirqd/0/15 [HC0[0]:SC1[1]:HE1:SE0] takes:
ffff88807f892260 (sk_lock-AF_X25){+.?.}-{0:0}, at: lock_sock include/net/sock.h:1713 [inline]
ffff88807f892260 (sk_lock-AF_X25){+.?.}-{0:0}, at: x25_kill_by_neigh+0x10d/0x250 net/x25/af_x25.c:1778
{SOFTIRQ-ON-W} state was registered at:
  lock_acquire+0x115/0x350 kernel/locking/lockdep.c:5908
  lock_sock_nested+0x41/0x100 net/core/sock.c:3827
  lock_sock include/net/sock.h:1713 [inline]
  x25_bind+0x209/0x450 net/x25/af_x25.c:694
  __sys_bind_socket net/socket.c:1945 [inline]
  __sys_bind+0x2e3/0x410 net/socket.c:1976
  __do_sys_bind net/socket.c:1981 [inline]
  __se_sys_bind net/socket.c:1979 [inline]
  __x64_sys_bind+0x7a/0x90 net/socket.c:1979
  do_syscall_x64 arch/x86/entry/syscall_64.c:61 [inline]
  do_syscall_64+0x166/0x520 arch/x86/entry/syscall_64.c:84
  entry_SYSCALL_64_after_hwframe+0x77/0x7f
irq event stamp: 732208
hardirqs last  enabled at (732208): [<ffffffff8188ed06>] __local_bh_enable_ip+0xd6/0x140 kernel/softirq.c:478
hardirqs last disabled at (732207): [<ffffffff8188eca2>] __local_bh_enable_ip+0x72/0x140 kernel/softirq.c:455
softirqs last  enabled at (732126): [<ffffffff818919e6>] run_ksoftirqd+0x36/0x60 kernel/softirq.c:1108
softirqs last disabled at (732131): [<ffffffff818919e6>] run_ksoftirqd+0x36/0x60 kernel/softirq.c:1108

other info that might help us debug this:
 Possible unsafe locking scenario:

       CPU0
       ----
  lock(sk_lock-AF_X25);
  <Interrupt>
    lock(sk_lock-AF_X25);

 *** DEADLOCK ***

locks held by ksoftirqd/0/15: 1, last CPU#0:
 #0: ffffffff8ed5c6e0 (rcu_read_lock){....}-{1:3}, at: rcu_lock_acquire include/linux/rcupdate.h:309 [inline]
 #0: ffffffff8ed5c6e0 (rcu_read_lock){....}-{1:3}, at: rcu_read_lock include/linux/rcupdate.h:849 [inline]
 #0: ffffffff8ed5c6e0 (rcu_read_lock){....}-{1:3}, at: netif_receive_skb_core+0x33/0x2b0 net/core/dev.c:6288

stack backtrace:
CPU: 0 UID: 0 PID: 15 Comm: ksoftirqd/0 Not tainted syzkaller #0 PREEMPT(full) 
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 07/24/2026
Call Trace:
 <TASK>
 dump_stack_lvl+0xe8/0x150 lib/dump_stack.c:120
 print_usage_bug+0x28c/0x2e0 kernel/locking/lockdep.c:4058
 valid_state+0xbe/0xf0 kernel/locking/lockdep.c:4072
 mark_lock_irq+0x36/0x380 kernel/locking/lockdep.c:4283
 mark_lock+0x117/0x190 kernel/locking/lockdep.c:4769
 mark_usage kernel/locking/lockdep.c:-1 [inline]
 __lock_acquire+0x6b7/0x2e50 kernel/locking/lockdep.c:5208
 lock_acquire+0x115/0x350 kernel/locking/lockdep.c:5908
 lock_sock_nested+0x41/0x100 net/core/sock.c:3827
 lock_sock include/net/sock.h:1713 [inline]
 x25_kill_by_neigh+0x10d/0x250 net/x25/af_x25.c:1778
 x25_lapb_receive_frame+0x1b0/0xfb0 net/x25/x25_dev.c:138
 __netif_receive_skb_one_core net/core/dev.c:6264 [inline]
 netif_receive_skb_core+0x2a6/0x2b0 net/core/dev.c:6289
 lapbeth_napi_poll+0x42/0x90 drivers/net/wan/lapbether.c:100
 __napi_poll+0xaa/0x330 net/core/dev.c:7787
 napi_poll net/core/dev.c:7850 [inline]
 net_rx_action+0x61d/0xf50 net/core/dev.c:8007
 handle_softirqs+0x226/0x860 kernel/softirq.c:645
 run_ksoftirqd+0x36/0x60 kernel/softirq.c:1108
 smpboot_thread_fn+0x565/0xa70 kernel/smpboot.c:160
 kthread+0x38b/0x480 kernel/kthread.c:436
 ret_from_fork+0x514/0xb70 arch/x86/kernel/process.c:158
 ret_from_fork_asm+0x1a/0x30 arch/x86/entry/entry_64.S:245
 </TASK>
BUG: sleeping function called from invalid context at net/core/sock.c:3829
in_atomic(): 1, irqs_disabled(): 0, non_block: 0, pid: 15, name: ksoftirqd/0
preempt_count: 100, expected: 0
RCU nest depth: 1, expected: 0
INFO: lockdep is turned off.
Preemption disabled at:
[<ffffffff8188ef0b>] softirq_handle_begin kernel/softirq.c:486 [inline]
[<ffffffff8188ef0b>] handle_softirqs+0xab/0x860 kernel/softirq.c:621
CPU: 0 UID: 0 PID: 15 Comm: ksoftirqd/0 Not tainted syzkaller #0 PREEMPT(full) 
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 07/24/2026
Call Trace:
 <TASK>
 dump_stack_lvl+0xe8/0x150 lib/dump_stack.c:120
 __might_resched+0x36a/0x4c0 kernel/sched/core.c:9234
 lock_sock_nested+0x56/0x100 net/core/sock.c:3829
 lock_sock include/net/sock.h:1713 [inline]
 x25_kill_by_neigh+0x10d/0x250 net/x25/af_x25.c:1778
 x25_lapb_receive_frame+0x1b0/0xfb0 net/x25/x25_dev.c:138
 __netif_receive_skb_one_core net/core/dev.c:6264 [inline]
 netif_receive_skb_core+0x2a6/0x2b0 net/core/dev.c:6289
 lapbeth_napi_poll+0x42/0x90 drivers/net/wan/lapbether.c:100
 __napi_poll+0xaa/0x330 net/core/dev.c:7787
 napi_poll net/core/dev.c:7850 [inline]
 net_rx_action+0x61d/0xf50 net/core/dev.c:8007
 handle_softirqs+0x226/0x860 kernel/softirq.c:645
 run_ksoftirqd+0x36/0x60 kernel/softirq.c:1108
 smpboot_thread_fn+0x565/0xa70 kernel/smpboot.c:160
 kthread+0x38b/0x480 kernel/kthread.c:436
 ret_from_fork+0x514/0xb70 arch/x86/kernel/process.c:158
 ret_from_fork_asm+0x1a/0x30 arch/x86/entry/entry_64.S:245
 </TASK>


---
If you want syzbot to run the reproducer, reply with:
#syz test: git://repo/address.git branch-or-commit-hash
If you attach or paste a git patch, syzbot will apply it before testing.
