Received: from mail-il1-f200.google.com (mail-il1-f200.google.com [209.85.166.200])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EA806288C1E
	for <syzbot@lists.linux.dev>; Tue, 26 Aug 2025 08:51:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.200
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756198297; cv=none; b=qu5mXrwvEcUOTkts5paX7jilBVVhkt/FrkGd8auqn06xqZvh6KbSJLs3JuCqbrwQvgnJiTDJbyo2KNeO0UKb0qYLe4eV8OPR14AjibZ7K1y/oxHsYKPWoXBe+w/G90mJml6+BBz9tInyrqNzNmu8+A/juvXm9GnJY40Bh5lR0Is=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756198297; c=relaxed/simple;
	bh=rqbzpIMNF8lcLo+xCfnXXVC+y3Ijjnd4uYWZXRDrsAQ=;
	h=MIME-Version:Date:In-Reply-To:Message-ID:Subject:From:To:Cc:
	 Content-Type; b=ctVAsptUtK1q6N9z3HNdSVXqkwN43vuTlWaAmxI00VVN50r42YtXwIdQ9gCuA56ZD6D/53qkMIBy2OtO53U1xFfUuTtevjp4rMmqVfaI90Y3kuX6TPAvmo2gg5XXa+P3+hy34VHCzElzZZZw9Zz4ZDKSANSNRbu3bv2+qFjU6Dg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com; arc=none smtp.client-ip=209.85.166.200
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com
Received: by mail-il1-f200.google.com with SMTP id e9e14a558f8ab-3e6e61caf71so140638475ab.3
        for <syzbot@lists.linux.dev>; Tue, 26 Aug 2025 01:51:35 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1756198295; x=1756803095;
        h=cc:to:from:subject:message-id:in-reply-to:date:mime-version
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=V5Z8geFiUzuvb4xav6QXnStSoxIENWrkMk1y8NFINgg=;
        b=CztWXyjcE9/Qcyxl2wIPupVKIVvQAt7umb5vFTlyr6ggcWVbnn5K5EnQfMaV+n5NVx
         8a15JhnjnOnYr36/94k7XF3HmnX9KY7sbzsmXZKiggvSavQO/k9qEoSRUqEXFiXNkemu
         +0xy5ECqkNFTRvxqop1kK1au6QbCxWZkQ12KScTgu9Bjo0AZ7oh5i8a/pS2wPJqZ90bl
         oz4LdIlDlFsCR4ag34brq+50RgZyiK0FIwI3bZLUqhebtGeGfXyvlQi7A+89AxzwPdBk
         81DwZkGzRk4UVZRQKyhJoinN/lagIRRKLWQW8dQw+n/AkI8ywQQheIMlvVlIoJHEG/yh
         z38g==
X-Gm-Message-State: AOJu0YybY/BL5/cTg60xIHQKPbtCW0c13LQ0+zrOoWVb/OG9M+H4QR0X
	+lHuxCWKZkIycueM/zbRQ3CRwmCWGL6+cXPJEAqJPCARZME1xYHjxVM7oHMpm/mgUBhXmomvCGv
	SHkCds3mK1KHfsIWkHY4qpWKL3nPi8LvbmI42CI58WpoQXI8BQKeC46lzTsI=
X-Google-Smtp-Source: AGHT+IGyCWr0r9RDJeiW8aRxDMVAR/RmplC1QNzX7o7NXNCYjeAEdE8Lnppx22aFBoWOaVC2roEIjfX0CoBvLEDs8itAl1OaB3FS
Precedence: bulk
X-Mailing-List: syzbot@lists.linux.dev
List-Id: <syzbot.lists.linux.dev>
List-Subscribe: <mailto:syzbot+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:syzbot+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Received: by 2002:a05:6e02:3c03:b0:3e8:78b5:6834 with SMTP id
 e9e14a558f8ab-3e91fc22a64mr220178895ab.2.1756198295079; Tue, 26 Aug 2025
 01:51:35 -0700 (PDT)
Date: Tue, 26 Aug 2025 01:51:35 -0700
In-Reply-To: <20250826041148.426598-1-liuhangbin@gmail.com>
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <68ad7597.050a0220.37038e.00b7.GAE@google.com>
Subject: [syzbot ci] Re: hsr: add rcu lock for all hsr_for_each_port caller
From: syzbot ci <syzbot+cie5eccf65446b6e53@syzkaller.appspotmail.com>
To: aleksander.lobakin@intel.com, arvid.brodin@alten.se, danishanwar@ti.com, 
	davem@davemloft.net, edumazet@google.com, ffmancera@riseup.net, 
	horms@kernel.org, jkarrenpalo@gmail.com, johannes.berg@intel.com, 
	kuba@kernel.org, kuniyu@google.com, liaoyu15@huawei.com, liuhangbin@gmail.com, 
	m-karicheri2@ti.com, netdev@vger.kernel.org, pabeni@redhat.com, 
	sdf@fomichev.me, shaw.leon@gmail.com, w-kwok2@ti.com
Cc: syzbot@lists.linux.dev, syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"

syzbot ci has tested the following series

[v1] hsr: add rcu lock for all hsr_for_each_port caller
https://lore.kernel.org/all/20250826041148.426598-1-liuhangbin@gmail.com
* [PATCH net] hsr: add rcu lock for all hsr_for_each_port caller

and found the following issue:
BUG: sleeping function called from invalid context in dev_set_allmulti

Full report is available here:
https://ci.syzbot.org/series/3992f7f8-7052-4440-bc88-86be6f350cec

***

BUG: sleeping function called from invalid context in dev_set_allmulti

tree:      net
URL:       https://kernel.googlesource.com/pub/scm/linux/kernel/git/netdev/net.git
base:      51f27beeb79f9f92682158999bab489ff4fa16f6
arch:      amd64
compiler:  Debian clang version 20.1.7 (++20250616065708+6146a88f6049-1~exp1~20250616065826.132), Debian LLD 20.1.7
config:    https://ci.syzbot.org/builds/1a20cfb3-c3a6-4ba9-9bda-2f49b971b39c/config
C repro:   https://ci.syzbot.org/findings/9de559bc-f498-4b86-ab2e-34f1510e4fe4/c_repro
syz repro: https://ci.syzbot.org/findings/9de559bc-f498-4b86-ab2e-34f1510e4fe4/syz_repro

hsr1: entered promiscuous mode
hsr1: entered allmulticast mode
bond0: entered allmulticast mode
bond_slave_0: entered allmulticast mode
bond_slave_1: entered allmulticast mode
BUG: sleeping function called from invalid context at kernel/locking/mutex.c:575
in_atomic(): 0, irqs_disabled(): 0, non_block: 0, pid: 5996, name: syz.0.17
preempt_count: 0, expected: 0
RCU nest depth: 1, expected: 0
3 locks held by syz.0.17/5996:
 #0: ffffffff8fa59670 (&ops->srcu#2){.+.+}-{0:0}, at: rcu_lock_acquire include/linux/rcupdate.h:331 [inline]
 #0: ffffffff8fa59670 (&ops->srcu#2){.+.+}-{0:0}, at: rcu_read_lock include/linux/rcupdate.h:841 [inline]
 #0: ffffffff8fa59670 (&ops->srcu#2){.+.+}-{0:0}, at: rtnl_link_ops_get+0x23/0x250 net/core/rtnetlink.c:570
 #1: ffffffff8f537c08 (rtnl_mutex){+.+.}-{4:4}, at: rtnl_lock net/core/rtnetlink.c:80 [inline]
 #1: ffffffff8f537c08 (rtnl_mutex){+.+.}-{4:4}, at: rtnl_nets_lock net/core/rtnetlink.c:341 [inline]
 #1: ffffffff8f537c08 (rtnl_mutex){+.+.}-{4:4}, at: rtnl_newlink+0x8db/0x1c70 net/core/rtnetlink.c:4056
 #2: ffffffff8e139ea0 (rcu_read_lock){....}-{1:3}, at: rcu_lock_acquire include/linux/rcupdate.h:331 [inline]
 #2: ffffffff8e139ea0 (rcu_read_lock){....}-{1:3}, at: rcu_read_lock include/linux/rcupdate.h:841 [inline]
 #2: ffffffff8e139ea0 (rcu_read_lock){....}-{1:3}, at: hsr_change_rx_flags+0x28/0x2d0 net/hsr/hsr_device.c:522
CPU: 0 UID: 0 PID: 5996 Comm: syz.0.17 Not tainted syzkaller #0 PREEMPT(full) 
Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS 1.16.2-debian-1.16.2-1 04/01/2014
Call Trace:
 <TASK>
 dump_stack_lvl+0x189/0x250 lib/dump_stack.c:120
 __might_resched+0x495/0x610 kernel/sched/core.c:8957
 __mutex_lock_common kernel/locking/mutex.c:575 [inline]
 __mutex_lock+0x109/0x1360 kernel/locking/mutex.c:760
 netdev_lock include/linux/netdevice.h:2761 [inline]
 netdev_lock_ops include/net/netdev_lock.h:42 [inline]
 dev_set_allmulti+0x10e/0x260 net/core/dev_api.c:312
 hsr_change_rx_flags+0x1b2/0x2d0 net/hsr/hsr_device.c:530
 dev_change_rx_flags net/core/dev.c:9332 [inline]
 netif_set_allmulti+0x212/0x380 net/core/dev.c:9430
 __dev_change_flags+0x52e/0x6d0 net/core/dev.c:9571
 rtnl_configure_link net/core/rtnetlink.c:3579 [inline]
 rtnl_newlink_create+0x555/0xb00 net/core/rtnetlink.c:3835
 __rtnl_newlink net/core/rtnetlink.c:3942 [inline]
 rtnl_newlink+0x16d6/0x1c70 net/core/rtnetlink.c:4057
 rtnetlink_rcv_msg+0x7cf/0xb70 net/core/rtnetlink.c:6946
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
RIP: 0033:0x7ff4b418ebe9
Code: ff ff c3 66 2e 0f 1f 84 00 00 00 00 00 0f 1f 40 00 48 89 f8 48 89 f7 48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 ff ff 73 01 c3 48 c7 c1 a8 ff ff ff f7 d8 64 89 01 48
RSP: 002b:00007ffef8386cc8 EFLAGS: 00000246 ORIG_RAX: 000000000000002e
RAX: ffffffffffffffda RBX: 00007ff4b43b5fa0 RCX: 00007ff4b418ebe9
RDX: 00000000000080c0 RSI: 00002000000002c0 RDI: 0000000000000003
RBP: 00007ff4b4211e19 R08: 0000000000000000 R09: 0000000000000000
R10: 0000000000000000 R11: 0000000000000246 R12: 0000000000000000
R13: 00007ff4b43b5fa0 R14: 00007ff4b43b5fa0 R15: 0000000000000003
 </TASK>

=============================
[ BUG: Invalid wait context ]
syzkaller #0 Tainted: G        W          
-----------------------------
syz.0.17/5996 is trying to lock:
ffff888110848d30 (&dev_instance_lock_key#3){+.+.}-{4:4}, at: netdev_lock include/linux/netdevice.h:2761 [inline]
ffff888110848d30 (&dev_instance_lock_key#3){+.+.}-{4:4}, at: netdev_lock_ops include/net/netdev_lock.h:42 [inline]
ffff888110848d30 (&dev_instance_lock_key#3){+.+.}-{4:4}, at: dev_set_allmulti+0x10e/0x260 net/core/dev_api.c:312
other info that might help us debug this:
context-{5:5}
3 locks held by syz.0.17/5996:
 #0: ffffffff8fa59670 (&ops->srcu#2){.+.+}-{0:0}, at: rcu_lock_acquire include/linux/rcupdate.h:331 [inline]
 #0: ffffffff8fa59670 (&ops->srcu#2){.+.+}-{0:0}, at: rcu_read_lock include/linux/rcupdate.h:841 [inline]
 #0: ffffffff8fa59670 (&ops->srcu#2){.+.+}-{0:0}, at: rtnl_link_ops_get+0x23/0x250 net/core/rtnetlink.c:570
 #1: ffffffff8f537c08 (rtnl_mutex){+.+.}-{4:4}, at: rtnl_lock net/core/rtnetlink.c:80 [inline]
 #1: ffffffff8f537c08 (rtnl_mutex){+.+.}-{4:4}, at: rtnl_nets_lock net/core/rtnetlink.c:341 [inline]
 #1: ffffffff8f537c08 (rtnl_mutex){+.+.}-{4:4}, at: rtnl_newlink+0x8db/0x1c70 net/core/rtnetlink.c:4056
 #2: ffffffff8e139ea0 (rcu_read_lock){....}-{1:3}, at: rcu_lock_acquire include/linux/rcupdate.h:331 [inline]
 #2: ffffffff8e139ea0 (rcu_read_lock){....}-{1:3}, at: rcu_read_lock include/linux/rcupdate.h:841 [inline]
 #2: ffffffff8e139ea0 (rcu_read_lock){....}-{1:3}, at: hsr_change_rx_flags+0x28/0x2d0 net/hsr/hsr_device.c:522
stack backtrace:
CPU: 0 UID: 0 PID: 5996 Comm: syz.0.17 Tainted: G        W           syzkaller #0 PREEMPT(full) 
Tainted: [W]=WARN
Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS 1.16.2-debian-1.16.2-1 04/01/2014
Call Trace:
 <TASK>
 dump_stack_lvl+0x189/0x250 lib/dump_stack.c:120
 print_lock_invalid_wait_context kernel/locking/lockdep.c:4830 [inline]
 check_wait_context kernel/locking/lockdep.c:4902 [inline]
 __lock_acquire+0xbcb/0xd20 kernel/locking/lockdep.c:5187
 lock_acquire+0x120/0x360 kernel/locking/lockdep.c:5868
 __mutex_lock_common kernel/locking/mutex.c:598 [inline]
 __mutex_lock+0x187/0x1360 kernel/locking/mutex.c:760
 netdev_lock include/linux/netdevice.h:2761 [inline]
 netdev_lock_ops include/net/netdev_lock.h:42 [inline]
 dev_set_allmulti+0x10e/0x260 net/core/dev_api.c:312
 hsr_change_rx_flags+0x1b2/0x2d0 net/hsr/hsr_device.c:530
 dev_change_rx_flags net/core/dev.c:9332 [inline]
 netif_set_allmulti+0x212/0x380 net/core/dev.c:9430
 __dev_change_flags+0x52e/0x6d0 net/core/dev.c:9571
 rtnl_configure_link net/core/rtnetlink.c:3579 [inline]
 rtnl_newlink_create+0x555/0xb00 net/core/rtnetlink.c:3835
 __rtnl_newlink net/core/rtnetlink.c:3942 [inline]
 rtnl_newlink+0x16d6/0x1c70 net/core/rtnetlink.c:4057
 rtnetlink_rcv_msg+0x7cf/0xb70 net/core/rtnetlink.c:6946
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
RIP: 0033:0x7ff4b418ebe9
Code: ff ff c3 66 2e 0f 1f 84 00 00 00 00 00 0f 1f 40 00 48 89 f8 48 89 f7 48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 ff ff 73 01 c3 48 c7 c1 a8 ff ff ff f7 d8 64 89 01 48
RSP: 002b:00007ffef8386cc8 EFLAGS: 00000246 ORIG_RAX: 000000000000002e
RAX: ffffffffffffffda RBX: 00007ff4b43b5fa0 RCX: 00007ff4b418ebe9
RDX: 00000000000080c0 RSI: 00002000000002c0 RDI: 0000000000000003
RBP: 00007ff4b4211e19 R08: 0000000000000000 R09: 0000000000000000
R10: 0000000000000000 R11: 0000000000000246 R12: 0000000000000000
R13: 00007ff4b43b5fa0 R14: 00007ff4b43b5fa0 R15: 0000000000000003
 </TASK>
dummy0: entered allmulticast mode


***

If these findings have caused you to resend the series or submit a
separate fix, please add the following tag to your commit message:
  Tested-by: syzbot@syzkaller.appspotmail.com

---
This report is generated by a bot. It may contain errors.
syzbot ci engineers can be reached at syzkaller@googlegroups.com.
