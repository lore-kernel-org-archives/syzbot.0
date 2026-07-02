Received: from mail-oo1-f72.google.com (mail-oo1-f72.google.com [209.85.161.72])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9BB0B3B27F4
	for <syzbot@lists.linux.dev>; Thu,  2 Jul 2026 07:45:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.161.72
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782978315; cv=none; b=PZiAqSaPYjUY6DrG7wFJ63I+NGt957DQEBavFNDmBCh2dQ5dr9SuXjfllOHLybFUb5UYJkCtU2SHXT6tEjZzD3Ecq9Ykx1MmkC6aeYWzBHBG9O9xs3QxAvxNKhKMgiqsDK79zNAdfAiOgA9g2OblaHqtqCKvgZLAfggSv5kipyM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782978315; c=relaxed/simple;
	bh=9v/bwCtbQ+tZr2fp0KR9gXhUXe24ytcZG+/0nu/Tsec=;
	h=MIME-Version:Date:In-Reply-To:Message-ID:Subject:From:To:Cc:
	 Content-Type; b=SJOyVFetAiqXaozi+gYif912B/xzYpz5zgjcyYBepPvwfsyQvl2wqxfje9vWFDKS98uSubPjKsAuhFBhV9EEj12XceDqEhHl/GGEe+fGHguFg8Y4sHUPZ+GrI2BlBRrLJH9EkjWJhXYcBaU+jpx4iEbdMX/VvKiRAKCF5PDVH3g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com; arc=none smtp.client-ip=209.85.161.72
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com
Received: by mail-oo1-f72.google.com with SMTP id 006d021491bc7-6a1860650afso1015927eaf.0
        for <syzbot@lists.linux.dev>; Thu, 02 Jul 2026 00:45:11 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1782978310; x=1783583110;
        h=cc:to:from:subject:message-id:in-reply-to:date:mime-version
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=Me/2AKraw1ra1681YXvJ/43x71zgfTRdKV5wbNjIw/w=;
        b=Ya8CQiGsXuiG325t5jlRlRitbvHiRP1rZU2Heg7ftFvUVrujSAQVSd0XdQycrYIyJN
         X65T6q0gMGnkM4Zn5JOsJuPGQsGAd2L3Q7J5mJFRUhvpou5KvgygGIfkFd+9Wkb6CkQU
         FzxYqILFKECRdjB0b71jGfK1BODy9irk7Bt3wL7vBHIJMUfxb2e8EN1c0bg1DnZP98uI
         8LEFJp5OsWWGD6iFH4uZ+blqom/bbRNlrbxXFzdfGXrM413p1KHtt14fVuyW0UWpRUAl
         wE1J/j3e9570gCCm1F0iS6IT4SYe9aMQAv5qY1j3ifVu0Jnp01ngboSpzVP3arBcG+2r
         Tfsw==
X-Gm-Message-State: AOJu0YwFbUfsGqxkA0GyxPnfxRkkqqamLuBdvVLBY5wFfyr9d/v1jjP9
	4JPbpmbfcqZDDhzO57f6fjs0SwBfT/egkckoqqJDLuBjsve/hM54YR5KtdZdQE6kQyFG5m7OsSk
	dk05HFefmnTQm4xo1IeefY9BDAGjVVjuHJa/nsbd7yS5sW4BDU2lSKa1FCzc=
Precedence: bulk
X-Mailing-List: syzbot@lists.linux.dev
List-Id: <syzbot.lists.linux.dev>
List-Subscribe: <mailto:syzbot+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:syzbot+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Received: by 2002:a05:6820:1c81:b0:6a1:3699:4ca5 with SMTP id
 006d021491bc7-6a309ae7853mr2843353eaf.44.1782978310554; Thu, 02 Jul 2026
 00:45:10 -0700 (PDT)
Date: Thu, 02 Jul 2026 00:45:10 -0700
In-Reply-To: <20260701214334.266991-1-kuniyu@google.com>
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <6a461706.52c20a74.1f8b39.0008.GAE@google.com>
Subject: [syzbot ci] Re: net: Support per-netns device unregistration
From: syzbot ci <syzbot+ci052b96c9bf56ca1d@syzkaller.appspotmail.com>
To: andrew@lunn.ch, davem@davemloft.net, edumazet@google.com, horms@kernel.org, 
	kuba@kernel.org, kuni1840@gmail.com, kuniyu@google.com, 
	netdev@vger.kernel.org, pabeni@redhat.com
Cc: syzbot@lists.linux.dev, syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"

syzbot ci has tested the following series

[v1] net: Support per-netns device unregistration
https://lore.kernel.org/all/20260701214334.266991-1-kuniyu@google.com
* [PATCH v1 net-next 01/14] rtnetlink: Lock sock_net(skb->sk) in rtnl_newlink().
* [PATCH v1 net-next 02/14] rtnetlink: Call unregister_netdevice_many() only once in rtnl_link_unregister().
* [PATCH v1 net-next 03/14] rtnetlink: Add per-netns rtnl_work.
* [PATCH v1 net-next 04/14] net: Wrap default_device_exit_net() with __rtnl_net_lock().
* [PATCH v1 net-next 05/14] net: Hold __rtnl_net_lock() in netdev_wait_allrefs_any().
* [PATCH v1 net-next 06/14] net: Add per-netns netdev unregistration infra.
* [PATCH v1 net-next 07/14] net: Call unregister_netdevice_many() per netns.
* [PATCH v1 net-next 08/14] veth: Support per-netns device unregistration.
* [PATCH v1 net-next 09/14] bareudp: Protect bareudp_list with mutex.
* [PATCH v1 net-next 10/14] bareudp: Support per-netns netdev unregistration.
* [PATCH v1 net-next 11/14] ipvlan: Convert ipvl_port.count to refcount_t.
* [PATCH v1 net-next 12/14] ipvlan: Synchronise ipvlan_init() and ipvlan_uninit() for the same lower dev.
* [PATCH v1 net-next 13/14] ipvlan: Protect ipvl_port.ipvlans with mutex.
* [PATCH v1 net-next 14/14] ipvlan: Support per-netns netdev unregistration.

and found the following issue:
possible deadlock in __dev_change_net_namespace

Full report is available here:
https://ci.syzbot.org/series/a744b257-d741-4780-8a53-f156b2a7afc9

***

possible deadlock in __dev_change_net_namespace

tree:      net-next
URL:       https://kernel.googlesource.com/pub/scm/linux/kernel/git/netdev/net-next.git
base:      d6e81529749190123aa0040626c7e5dbc20fdc9a
arch:      amd64
compiler:  Debian clang version 22.1.6 (++20260514074242+fc4aad7b5db3-1~exp1~20260514074407.73), Debian LLD 22.1.6
config:    https://ci.syzbot.org/builds/243cd0ec-28f9-4d21-8f16-3d2fbad8388d/config
syz repro: https://ci.syzbot.org/findings/a8a0740d-fdec-4a20-9aa5-7cb955707913/syz_repro

veth0_macvtap: left promiscuous mode
============================================
WARNING: possible recursive locking detected
syzkaller #0 Not tainted
--------------------------------------------
syz.1.18/5814 is trying to acquire lock:
ffffffff9a9b0418 (&net->dev_unreg_lock){+.+.}-{3:3}, at: spin_lock include/linux/spinlock.h:342 [inline]
ffffffff9a9b0418 (&net->dev_unreg_lock){+.+.}-{3:3}, at: unregister_netdevice_move_net net/core/dev.c:-1 [inline]
ffffffff9a9b0418 (&net->dev_unreg_lock){+.+.}-{3:3}, at: __dev_change_net_namespace+0x1479/0x2200 net/core/dev.c:12768

but task is already holding lock:
ffff88810b6cf8d8 (&net->dev_unreg_lock){+.+.}-{3:3}, at: spin_lock include/linux/spinlock.h:342 [inline]
ffff88810b6cf8d8 (&net->dev_unreg_lock){+.+.}-{3:3}, at: unregister_netdevice_move_net net/core/dev.c:-1 [inline]
ffff88810b6cf8d8 (&net->dev_unreg_lock){+.+.}-{3:3}, at: __dev_change_net_namespace+0x146a/0x2200 net/core/dev.c:12768

other info that might help us debug this:
 Possible unsafe locking scenario:

       CPU0
       ----
  lock(&net->dev_unreg_lock);
  lock(&net->dev_unreg_lock);

 *** DEADLOCK ***

 May be due to missing lock nesting notation

4 locks held by syz.1.18/5814:
 #0: ffffffff8fdeb0c0 (rtnl_mutex){+.+.}-{4:4}, at: rtnl_lock net/core/rtnetlink.c:80 [inline]
 #0: ffffffff8fdeb0c0 (rtnl_mutex){+.+.}-{4:4}, at: rtnl_nets_lock+0x2a/0x2b0 net/core/rtnetlink.c:366
 #1: ffffffff9a9b0380 (&net->rtnl_mutex){+.+.}-{4:4}, at: rtnl_nets_lock+0x76/0x2b0 net/core/rtnetlink.c:369
 #2: ffff88810b6cf840 (&net->rtnl_mutex){+.+.}-{4:4}, at: rtnl_nets_lock+0xbf/0x2b0 net/core/rtnetlink.c:369
 #3: ffff88810b6cf8d8 (&net->dev_unreg_lock){+.+.}-{3:3}, at: spin_lock include/linux/spinlock.h:342 [inline]
 #3: ffff88810b6cf8d8 (&net->dev_unreg_lock){+.+.}-{3:3}, at: unregister_netdevice_move_net net/core/dev.c:-1 [inline]
 #3: ffff88810b6cf8d8 (&net->dev_unreg_lock){+.+.}-{3:3}, at: __dev_change_net_namespace+0x146a/0x2200 net/core/dev.c:12768

stack backtrace:
CPU: 0 UID: 0 PID: 5814 Comm: syz.1.18 Not tainted syzkaller #0 PREEMPT(full) 
Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS 1.16.2-debian-1.16.2-1 04/01/2014
Call Trace:
 <TASK>
 dump_stack_lvl+0xe8/0x150 lib/dump_stack.c:120
 print_deadlock_bug+0x279/0x290 kernel/locking/lockdep.c:3041
 check_deadlock kernel/locking/lockdep.c:3093 [inline]
 validate_chain kernel/locking/lockdep.c:3895 [inline]
 __lock_acquire+0x24df/0x2cf0 kernel/locking/lockdep.c:5237
 lock_acquire+0x106/0x350 kernel/locking/lockdep.c:5868
 __raw_spin_lock include/linux/spinlock_api_smp.h:158 [inline]
 _raw_spin_lock+0x2e/0x40 kernel/locking/spinlock.c:158
 spin_lock include/linux/spinlock.h:342 [inline]
 unregister_netdevice_move_net net/core/dev.c:-1 [inline]
 __dev_change_net_namespace+0x1479/0x2200 net/core/dev.c:12768
 do_setlink+0x2d1/0x4670 net/core/rtnetlink.c:3148
 rtnl_changelink net/core/rtnetlink.c:3880 [inline]
 __rtnl_newlink net/core/rtnetlink.c:4053 [inline]
 rtnl_newlink+0x1612/0x1b50 net/core/rtnetlink.c:4192
 rtnetlink_rcv_msg+0x802/0xc00 net/core/rtnetlink.c:7109
 netlink_rcv_skb+0x226/0x4a0 net/netlink/af_netlink.c:2556
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
RIP: 0033:0x7fbdc639ce59
Code: ff c3 66 2e 0f 1f 84 00 00 00 00 00 0f 1f 44 00 00 48 89 f8 48 89 f7 48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 ff ff 73 01 c3 48 c7 c1 e8 ff ff ff f7 d8 64 89 01 48
RSP: 002b:00007fbdc59fe028 EFLAGS: 00000246 ORIG_RAX: 000000000000002e
RAX: ffffffffffffffda RBX: 00007fbdc6615fa0 RCX: 00007fbdc639ce59
RDX: 0000000000000000 RSI: 0000200000000740 RDI: 0000000000000003
RBP: 00007fbdc6432e6f R08: 0000000000000000 R09: 0000000000000000
R10: 0000000000000000 R11: 0000000000000246 R12: 0000000000000000
R13: 00007fbdc6616038 R14: 00007fbdc6615fa0 R15: 00007ffd94dcb1f8
 </TASK>
syz.1.18 (5814) used greatest stack depth: 19864 bytes left


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
