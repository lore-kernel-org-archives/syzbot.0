Received: from mail-vk1-f199.google.com (mail-vk1-f199.google.com [209.85.221.199])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6EDE43DB629
	for <syzbot@lists.linux.dev>; Wed,  8 Apr 2026 20:41:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.199
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1775680911; cv=none; b=RLiMXRmUqsb78WrkPYIYA+/FlTFcBuBORbIu5aXWxVSNNEYx2TF40lQVIbAnQXEttrASIF467VBKBp3atm6Rx6HhdJi545hauQTMxFF4Re9PIpWLXK8X5+FMrfYu29xw/VCXgbTHKrRTVnGNrVoK2bk54ddUwOKzDe/1To/ChKs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1775680911; c=relaxed/simple;
	bh=6YQ0JH+ppPNdBJgrvxOdc8Znzvxw/WPnk/nMwdmkod4=;
	h=MIME-Version:Date:In-Reply-To:Message-ID:Subject:From:To:Cc:
	 Content-Type; b=r6FpJSLkiOYHJMgOdPkfpPekl4lv2TeRGLVGKkwH4lbTS93ErbaiJRpyQLX+DV9kwlbv882qQmiF5JXzkL0JYvKnBuYBJOiFXyN5+zlj4ox3GmTVC2ZcV0TpmXxF06E85styU0/AA0XySur4Qf5hTREfoCreSlHFtSo4YNjwsJU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com; arc=none smtp.client-ip=209.85.221.199
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com
Received: by mail-vk1-f199.google.com with SMTP id 71dfb90a1353d-56ee7e6ce4bso493389e0c.0
        for <syzbot@lists.linux.dev>; Wed, 08 Apr 2026 13:41:49 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1775680908; x=1776285708;
        h=cc:to:from:subject:message-id:in-reply-to:date:mime-version
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=SxaZ0G6ZIGuezWqdjpsYNlMnLQDl2Sl11e/LwXAUHmM=;
        b=U9qmiaY4eCBSoZw0AAKoC9ZAqui3iTYFOLP1oft3dL/HFDVG/eG8aHlQH1LGVkxKcE
         Wb+e3A3QK3gr5U+Wkgn4n8CGXklK4DyaQHvBU10ef4IRh+PdHaRcBGaQNbUOFk/ZOg3F
         j/IKALTKcYjrJK0mSW5GfnSIxJ28ac9j6WxJWRdpHiA3mA9Mqf7GvLHjcVLigSKIUfsZ
         iA65MmdT4IFHvYTp2AOJp9U5tTLm7fmPLymTAEd/TSqBvgxOoVR+H1w7nxKQUM7zvP1B
         6s5xH0rrnl9k+vLfPC3+Qdprm7rOUU74M0gQtZ7qsr93i2IjCGiNPN0n+Z6kxilfdl9P
         QdIg==
X-Gm-Message-State: AOJu0Yz5m85scZO8C0LedEC3kAHhvjs2QobI1WPvO6nQwID9VY3t+Xvo
	q+ZHtztaJhHiz0Z0S29xz1gVBUcqp3mPucmmUhMZFmPZhZxaH91mmbG7LgPtSTvYczzeTZTmD+1
	nLPsP7PkaizEZr5lGxbf7w8fkTjOjSfIO88UDJW7O8KE9bZoLijVDh9nyCnA=
Precedence: bulk
X-Mailing-List: syzbot@lists.linux.dev
List-Id: <syzbot.lists.linux.dev>
List-Subscribe: <mailto:syzbot+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:syzbot+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Received: by 2002:a05:6820:7513:b0:682:47e0:5d4e with SMTP id
 006d021491bc7-68a68d5f842mr325617eaf.14.1775679299916; Wed, 08 Apr 2026
 13:14:59 -0700 (PDT)
Date: Wed, 08 Apr 2026 13:14:59 -0700
In-Reply-To: <20260408125611.3592751-1-edumazet@google.com>
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <69d6b743.050a0220.d95e.0003.GAE@google.com>
Subject: [syzbot ci] Re: net/sched: no longer acquire RTNL in qdisc dumps
From: syzbot ci <syzbot+ci60965c6d6fd3c464@syzkaller.appspotmail.com>
To: davem@davemloft.net, edumazet@google.com, eric.dumazet@gmail.com, 
	horms@kernel.org, jhs@mojatatu.com, jiri@resnulli.us, kuba@kernel.org, 
	kuniyu@google.com, netdev@vger.kernel.org, pabeni@redhat.com, sdf@fomichev.me, 
	toke@toke.dk
Cc: syzbot@lists.linux.dev, syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"

syzbot ci has tested the following series

[v1] net/sched: no longer acquire RTNL in qdisc dumps
https://lore.kernel.org/all/20260408125611.3592751-1-edumazet@google.com
* [PATCH net-next 01/15] net/sched: rename qstats_overlimit_inc() to qstats_cpu_overlimit_inc()
* [PATCH net-next 02/15] net/sched: add qstats_cpu_drop_inc() helper
* [PATCH net-next 03/15] net/sched: add READ_ONCE() in gnet_stats_add_queue[_cpu]
* [PATCH net-next 04/15] net/sched: add qdisc_qlen_inc() and qdisc_qlen_dec()
* [PATCH net-next 05/15] net/sched: annotate data-races around sch->qstats.backlog
* [PATCH net-next 06/15] net/sched: sch_sfb: annotate data-races in sfb_dump_stats()
* [PATCH net-next 07/15] net/sched: sch_red: annotate data-races in red_dump_stats()
* [PATCH net-next 08/15] net/sched: sch_fq_codel: remove data-races from fq_codel_dump_stats()
* [PATCH net-next 09/15] net/sched: sch_pie: annotate data-races in pie_dump_stats()
* [PATCH net-next 10/15] net/sched: sch_fq_pie: annotate data-races in fq_pie_dump_stats()
* [PATCH net-next 11/15] net_sched: sch_hhf: annotate data-races in hhf_dump_stats()
* [PATCH net-next 12/15] net/sched: sch_choke: annotate data-races in choke_dump_stats()
* [PATCH net-next 13/15] net/sched: sch_cake: annotate data-races in cake_dump_stats()
* [PATCH net-next 14/15] net/sched: mq: no longer acquire qdisc spinlocks in dump operations
* [PATCH net-next 15/15] net/sched: convert tc_dump_qdisc() to RCU

and found the following issues:
* WARNING: suspicious RCU usage in mq_dump_common
* WARNING: suspicious RCU usage in mqprio_dump
* WARNING: suspicious RCU usage in tc_fill_qdisc

Full report is available here:
https://ci.syzbot.org/series/a6ab0157-80eb-4d29-ab75-31a471a9070e

***

WARNING: suspicious RCU usage in mq_dump_common

tree:      net-next
URL:       https://kernel.googlesource.com/pub/scm/linux/kernel/git/netdev/net-next.git
base:      b3e69fc3196fc421e26196e7792f17b0463edc6f
arch:      amd64
compiler:  Debian clang version 21.1.8 (++20251221033036+2078da43e25a-1~exp1~20251221153213.50), Debian LLD 21.1.8
config:    https://ci.syzbot.org/builds/f4a44029-347c-4dad-b84f-81c322454de4/config
syz repro: https://ci.syzbot.org/findings/d5d8c727-6baf-4738-bc33-e8a42f539e21/syz_repro

=============================
WARNING: suspicious RCU usage
syzkaller #0 Not tainted
-----------------------------
net/sched/sch_mq.c:158 suspicious rcu_dereference_check() usage!

other info that might help us debug this:


rcu_scheduler_active = 2, debug_locks = 1
1 lock held by syz.1.18/6007:
 #0: ffffffff8fbca4c8 (rtnl_mutex){+.+.}-{4:4}, at: rtnl_lock net/core/rtnetlink.c:80 [inline]
 #0: ffffffff8fbca4c8 (rtnl_mutex){+.+.}-{4:4}, at: rtnetlink_rcv_msg+0x722/0xbe0 net/core/rtnetlink.c:6986

stack backtrace:
CPU: 1 UID: 0 PID: 6007 Comm: syz.1.18 Not tainted syzkaller #0 PREEMPT(full) 
Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS 1.16.2-debian-1.16.2-1 04/01/2014
Call Trace:
 <TASK>
 dump_stack_lvl+0xe8/0x150 lib/dump_stack.c:120
 lockdep_rcu_suspicious+0x13f/0x1d0 kernel/locking/lockdep.c:6876
 mq_dump_common+0x2fa/0x5e0 net/sched/sch_mq.c:158
 mq_dump+0x7e/0x150 net/sched/sch_mq.c:181
 tc_fill_qdisc+0x663/0x11c0 net/sched/sch_api.c:937
 qdisc_notify+0x1cf/0x440 net/sched/sch_api.c:1033
 notify_and_destroy net/sched/sch_api.c:1058 [inline]
 qdisc_graft+0x114a/0x15b0 net/sched/sch_api.c:1158
 __tc_modify_qdisc net/sched/sch_api.c:1760 [inline]
 tc_modify_qdisc+0x18a4/0x2290 net/sched/sch_api.c:1816
 rtnetlink_rcv_msg+0x77e/0xbe0 net/core/rtnetlink.c:6989
 netlink_rcv_skb+0x232/0x4b0 net/netlink/af_netlink.c:2550
 netlink_unicast_kernel net/netlink/af_netlink.c:1318 [inline]
 netlink_unicast+0x80f/0x9b0 net/netlink/af_netlink.c:1344
 netlink_sendmsg+0x813/0xb40 net/netlink/af_netlink.c:1894
 sock_sendmsg_nosec net/socket.c:721 [inline]
 __sock_sendmsg net/socket.c:736 [inline]
 ____sys_sendmsg+0x972/0x9f0 net/socket.c:2585
 ___sys_sendmsg+0x2a5/0x360 net/socket.c:2639
 __sys_sendmsg net/socket.c:2671 [inline]
 __do_sys_sendmsg net/socket.c:2676 [inline]
 __se_sys_sendmsg net/socket.c:2674 [inline]
 __x64_sys_sendmsg+0x1bd/0x2a0 net/socket.c:2674
 do_syscall_x64 arch/x86/entry/syscall_64.c:63 [inline]
 do_syscall_64+0x14d/0xf80 arch/x86/entry/syscall_64.c:94
 entry_SYSCALL_64_after_hwframe+0x77/0x7f
RIP: 0033:0x7f1d3839c819
Code: ff c3 66 2e 0f 1f 84 00 00 00 00 00 0f 1f 44 00 00 48 89 f8 48 89 f7 48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 ff ff 73 01 c3 48 c7 c1 e8 ff ff ff f7 d8 64 89 01 48
RSP: 002b:00007f1d392c4028 EFLAGS: 00000246 ORIG_RAX: 000000000000002e
RAX: ffffffffffffffda RBX: 00007f1d38615fa0 RCX: 00007f1d3839c819
RDX: 0000000000044080 RSI: 0000200000000040 RDI: 0000000000000003
RBP: 00007f1d38432c91 R08: 0000000000000000 R09: 0000000000000000
R10: 0000000000000000 R11: 0000000000000246 R12: 0000000000000000
R13: 00007f1d38616038 R14: 00007f1d38615fa0 R15: 00007fff29960058
 </TASK>

=============================
WARNING: suspicious RCU usage
syzkaller #0 Not tainted
-----------------------------
net/sched/sch_api.c:943 suspicious rcu_dereference_check() usage!

other info that might help us debug this:


rcu_scheduler_active = 2, debug_locks = 1
1 lock held by syz.1.18/6007:
 #0: ffffffff8fbca4c8 (rtnl_mutex){+.+.}-{4:4}, at: rtnl_lock net/core/rtnetlink.c:80 [inline]
 #0: ffffffff8fbca4c8 (rtnl_mutex){+.+.}-{4:4}, at: rtnetlink_rcv_msg+0x722/0xbe0 net/core/rtnetlink.c:6986

stack backtrace:
CPU: 0 UID: 0 PID: 6007 Comm: syz.1.18 Not tainted syzkaller #0 PREEMPT(full) 
Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS 1.16.2-debian-1.16.2-1 04/01/2014
Call Trace:
 <TASK>
 dump_stack_lvl+0xe8/0x150 lib/dump_stack.c:120
 lockdep_rcu_suspicious+0x13f/0x1d0 kernel/locking/lockdep.c:6876
 tc_fill_qdisc+0xd90/0x11c0 net/sched/sch_api.c:943
 qdisc_notify+0x1cf/0x440 net/sched/sch_api.c:1033
 notify_and_destroy net/sched/sch_api.c:1058 [inline]
 qdisc_graft+0x114a/0x15b0 net/sched/sch_api.c:1158
 __tc_modify_qdisc net/sched/sch_api.c:1760 [inline]
 tc_modify_qdisc+0x18a4/0x2290 net/sched/sch_api.c:1816
 rtnetlink_rcv_msg+0x77e/0xbe0 net/core/rtnetlink.c:6989
 netlink_rcv_skb+0x232/0x4b0 net/netlink/af_netlink.c:2550
 netlink_unicast_kernel net/netlink/af_netlink.c:1318 [inline]
 netlink_unicast+0x80f/0x9b0 net/netlink/af_netlink.c:1344
 netlink_sendmsg+0x813/0xb40 net/netlink/af_netlink.c:1894
 sock_sendmsg_nosec net/socket.c:721 [inline]
 __sock_sendmsg net/socket.c:736 [inline]
 ____sys_sendmsg+0x972/0x9f0 net/socket.c:2585
 ___sys_sendmsg+0x2a5/0x360 net/socket.c:2639
 __sys_sendmsg net/socket.c:2671 [inline]
 __do_sys_sendmsg net/socket.c:2676 [inline]
 __se_sys_sendmsg net/socket.c:2674 [inline]
 __x64_sys_sendmsg+0x1bd/0x2a0 net/socket.c:2674
 do_syscall_x64 arch/x86/entry/syscall_64.c:63 [inline]
 do_syscall_64+0x14d/0xf80 arch/x86/entry/syscall_64.c:94
 entry_SYSCALL_64_after_hwframe+0x77/0x7f
RIP: 0033:0x7f1d3839c819
Code: ff c3 66 2e 0f 1f 84 00 00 00 00 00 0f 1f 44 00 00 48 89 f8 48 89 f7 48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 ff ff 73 01 c3 48 c7 c1 e8 ff ff ff f7 d8 64 89 01 48
RSP: 002b:00007f1d392c4028 EFLAGS: 00000246 ORIG_RAX: 000000000000002e
RAX: ffffffffffffffda RBX: 00007f1d38615fa0 RCX: 00007f1d3839c819
RDX: 0000000000044080 RSI: 0000200000000040 RDI: 0000000000000003
RBP: 00007f1d38432c91 R08: 0000000000000000 R09: 0000000000000000
R10: 0000000000000000 R11: 0000000000000246 R12: 0000000000000000
R13: 00007f1d38616038 R14: 00007f1d38615fa0 R15: 00007fff29960058
 </TASK>


***

WARNING: suspicious RCU usage in mqprio_dump

tree:      net-next
URL:       https://kernel.googlesource.com/pub/scm/linux/kernel/git/netdev/net-next.git
base:      b3e69fc3196fc421e26196e7792f17b0463edc6f
arch:      amd64
compiler:  Debian clang version 21.1.8 (++20251221033036+2078da43e25a-1~exp1~20251221153213.50), Debian LLD 21.1.8
config:    https://ci.syzbot.org/builds/f4a44029-347c-4dad-b84f-81c322454de4/config
syz repro: https://ci.syzbot.org/findings/159b3573-da89-4289-89cf-85c39c62db59/syz_repro

=============================
WARNING: suspicious RCU usage
syzkaller #0 Not tainted
-----------------------------
net/sched/sch_mqprio.c:570 suspicious rcu_dereference_check() usage!

other info that might help us debug this:


rcu_scheduler_active = 2, debug_locks = 1
1 lock held by syz.1.18/5958:
 #0: ffffffff8fbca4c8 (rtnl_mutex){+.+.}-{4:4}, at: rtnl_lock net/core/rtnetlink.c:80 [inline]
 #0: ffffffff8fbca4c8 (rtnl_mutex){+.+.}-{4:4}, at: rtnetlink_rcv_msg+0x722/0xbe0 net/core/rtnetlink.c:6986

stack backtrace:
CPU: 1 UID: 0 PID: 5958 Comm: syz.1.18 Not tainted syzkaller #0 PREEMPT(full) 
Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS 1.16.2-debian-1.16.2-1 04/01/2014
Call Trace:
 <TASK>
 dump_stack_lvl+0xe8/0x150 lib/dump_stack.c:120
 lockdep_rcu_suspicious+0x13f/0x1d0 kernel/locking/lockdep.c:6876
 mqprio_dump+0x3db/0x1370 net/sched/sch_mqprio.c:570
 tc_fill_qdisc+0x663/0x11c0 net/sched/sch_api.c:937
 qdisc_notify+0x28c/0x440 net/sched/sch_api.c:1038
 notify_and_destroy net/sched/sch_api.c:1058 [inline]
 qdisc_graft+0x114a/0x15b0 net/sched/sch_api.c:1158
 __tc_modify_qdisc net/sched/sch_api.c:1760 [inline]
 tc_modify_qdisc+0x18a4/0x2290 net/sched/sch_api.c:1816
 rtnetlink_rcv_msg+0x77e/0xbe0 net/core/rtnetlink.c:6989
 netlink_rcv_skb+0x232/0x4b0 net/netlink/af_netlink.c:2550
 netlink_unicast_kernel net/netlink/af_netlink.c:1318 [inline]
 netlink_unicast+0x80f/0x9b0 net/netlink/af_netlink.c:1344
 netlink_sendmsg+0x813/0xb40 net/netlink/af_netlink.c:1894
 sock_sendmsg_nosec net/socket.c:721 [inline]
 __sock_sendmsg net/socket.c:736 [inline]
 ____sys_sendmsg+0x972/0x9f0 net/socket.c:2585
 ___sys_sendmsg+0x2a5/0x360 net/socket.c:2639
 __sys_sendmsg net/socket.c:2671 [inline]
 __do_sys_sendmsg net/socket.c:2676 [inline]
 __se_sys_sendmsg net/socket.c:2674 [inline]
 __x64_sys_sendmsg+0x1bd/0x2a0 net/socket.c:2674
 do_syscall_x64 arch/x86/entry/syscall_64.c:63 [inline]
 do_syscall_64+0x14d/0xf80 arch/x86/entry/syscall_64.c:94
 entry_SYSCALL_64_after_hwframe+0x77/0x7f
RIP: 0033:0x7ff019b9c819
Code: ff c3 66 2e 0f 1f 84 00 00 00 00 00 0f 1f 44 00 00 48 89 f8 48 89 f7 48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 ff ff 73 01 c3 48 c7 c1 e8 ff ff ff f7 d8 64 89 01 48
RSP: 002b:00007ff01ab3e028 EFLAGS: 00000246 ORIG_RAX: 000000000000002e
RAX: ffffffffffffffda RBX: 00007ff019e15fa0 RCX: 00007ff019b9c819
RDX: 0000000020000000 RSI: 0000200000000200 RDI: 0000000000000005
RBP: 00007ff019c32c91 R08: 0000000000000000 R09: 0000000000000000
R10: 0000000000000000 R11: 0000000000000246 R12: 0000000000000000
R13: 00007ff019e16038 R14: 00007ff019e15fa0 R15: 00007ffc53020ce8
 </TASK>

=============================
WARNING: suspicious RCU usage
syzkaller #0 Not tainted
-----------------------------
net/sched/sch_api.c:943 suspicious rcu_dereference_check() usage!

other info that might help us debug this:


rcu_scheduler_active = 2, debug_locks = 1
1 lock held by syz.1.18/5958:
 #0: ffffffff8fbca4c8 (rtnl_mutex){+.+.}-{4:4}, at: rtnl_lock net/core/rtnetlink.c:80 [inline]
 #0: ffffffff8fbca4c8 (rtnl_mutex){+.+.}-{4:4}, at: rtnetlink_rcv_msg+0x722/0xbe0 net/core/rtnetlink.c:6986

stack backtrace:
CPU: 1 UID: 0 PID: 5958 Comm: syz.1.18 Not tainted syzkaller #0 PREEMPT(full) 
Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS 1.16.2-debian-1.16.2-1 04/01/2014
Call Trace:
 <TASK>
 dump_stack_lvl+0xe8/0x150 lib/dump_stack.c:120
 lockdep_rcu_suspicious+0x13f/0x1d0 kernel/locking/lockdep.c:6876
 tc_fill_qdisc+0xd90/0x11c0 net/sched/sch_api.c:943
 qdisc_notify+0x28c/0x440 net/sched/sch_api.c:1038
 notify_and_destroy net/sched/sch_api.c:1058 [inline]
 qdisc_graft+0x114a/0x15b0 net/sched/sch_api.c:1158
 __tc_modify_qdisc net/sched/sch_api.c:1760 [inline]
 tc_modify_qdisc+0x18a4/0x2290 net/sched/sch_api.c:1816
 rtnetlink_rcv_msg+0x77e/0xbe0 net/core/rtnetlink.c:6989
 netlink_rcv_skb+0x232/0x4b0 net/netlink/af_netlink.c:2550
 netlink_unicast_kernel net/netlink/af_netlink.c:1318 [inline]
 netlink_unicast+0x80f/0x9b0 net/netlink/af_netlink.c:1344
 netlink_sendmsg+0x813/0xb40 net/netlink/af_netlink.c:1894
 sock_sendmsg_nosec net/socket.c:721 [inline]
 __sock_sendmsg net/socket.c:736 [inline]
 ____sys_sendmsg+0x972/0x9f0 net/socket.c:2585
 ___sys_sendmsg+0x2a5/0x360 net/socket.c:2639
 __sys_sendmsg net/socket.c:2671 [inline]
 __do_sys_sendmsg net/socket.c:2676 [inline]
 __se_sys_sendmsg net/socket.c:2674 [inline]
 __x64_sys_sendmsg+0x1bd/0x2a0 net/socket.c:2674
 do_syscall_x64 arch/x86/entry/syscall_64.c:63 [inline]
 do_syscall_64+0x14d/0xf80 arch/x86/entry/syscall_64.c:94
 entry_SYSCALL_64_after_hwframe+0x77/0x7f
RIP: 0033:0x7ff019b9c819
Code: ff c3 66 2e 0f 1f 84 00 00 00 00 00 0f 1f 44 00 00 48 89 f8 48 89 f7 48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 ff ff 73 01 c3 48 c7 c1 e8 ff ff ff f7 d8 64 89 01 48
RSP: 002b:00007ff01ab3e028 EFLAGS: 00000246 ORIG_RAX: 000000000000002e
RAX: ffffffffffffffda RBX: 00007ff019e15fa0 RCX: 00007ff019b9c819
RDX: 0000000020000000 RSI: 0000200000000200 RDI: 0000000000000005
RBP: 00007ff019c32c91 R08: 0000000000000000 R09: 0000000000000000
R10: 0000000000000000 R11: 0000000000000246 R12: 0000000000000000
R13: 00007ff019e16038 R14: 00007ff019e15fa0 R15: 00007ffc53020ce8
 </TASK>


***

WARNING: suspicious RCU usage in tc_fill_qdisc

tree:      net-next
URL:       https://kernel.googlesource.com/pub/scm/linux/kernel/git/netdev/net-next.git
base:      b3e69fc3196fc421e26196e7792f17b0463edc6f
arch:      amd64
compiler:  Debian clang version 21.1.8 (++20251221033036+2078da43e25a-1~exp1~20251221153213.50), Debian LLD 21.1.8
config:    https://ci.syzbot.org/builds/f4a44029-347c-4dad-b84f-81c322454de4/config
syz repro: https://ci.syzbot.org/findings/0dada8ec-a4b6-42a1-8516-d70ce8ccccc7/syz_repro

=============================
WARNING: suspicious RCU usage
syzkaller #0 Not tainted
-----------------------------
net/sched/sch_api.c:943 suspicious rcu_dereference_check() usage!

other info that might help us debug this:


rcu_scheduler_active = 2, debug_locks = 1
1 lock held by syz.0.17/5963:
 #0: ffffffff8fbca4c8 (rtnl_mutex){+.+.}-{4:4}, at: rtnl_lock net/core/rtnetlink.c:80 [inline]
 #0: ffffffff8fbca4c8 (rtnl_mutex){+.+.}-{4:4}, at: rtnetlink_rcv_msg+0x722/0xbe0 net/core/rtnetlink.c:6986

stack backtrace:
CPU: 0 UID: 0 PID: 5963 Comm: syz.0.17 Not tainted syzkaller #0 PREEMPT(full) 
Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS 1.16.2-debian-1.16.2-1 04/01/2014
Call Trace:
 <TASK>
 dump_stack_lvl+0xe8/0x150 lib/dump_stack.c:120
 lockdep_rcu_suspicious+0x13f/0x1d0 kernel/locking/lockdep.c:6876
 tc_fill_qdisc+0xd90/0x11c0 net/sched/sch_api.c:943
 qdisc_notify+0x1cf/0x440 net/sched/sch_api.c:1033
 notify_and_destroy net/sched/sch_api.c:1058 [inline]
 qdisc_graft+0x114a/0x15b0 net/sched/sch_api.c:1158
 __tc_modify_qdisc net/sched/sch_api.c:1760 [inline]
 tc_modify_qdisc+0x18a4/0x2290 net/sched/sch_api.c:1816
 rtnetlink_rcv_msg+0x77e/0xbe0 net/core/rtnetlink.c:6989
 netlink_rcv_skb+0x232/0x4b0 net/netlink/af_netlink.c:2550
 netlink_unicast_kernel net/netlink/af_netlink.c:1318 [inline]
 netlink_unicast+0x80f/0x9b0 net/netlink/af_netlink.c:1344
 netlink_sendmsg+0x813/0xb40 net/netlink/af_netlink.c:1894
 sock_sendmsg_nosec net/socket.c:721 [inline]
 __sock_sendmsg net/socket.c:736 [inline]
 ____sys_sendmsg+0x972/0x9f0 net/socket.c:2585
 ___sys_sendmsg+0x2a5/0x360 net/socket.c:2639
 __sys_sendmsg net/socket.c:2671 [inline]
 __do_sys_sendmsg net/socket.c:2676 [inline]
 __se_sys_sendmsg net/socket.c:2674 [inline]
 __x64_sys_sendmsg+0x1bd/0x2a0 net/socket.c:2674
 do_syscall_x64 arch/x86/entry/syscall_64.c:63 [inline]
 do_syscall_64+0x14d/0xf80 arch/x86/entry/syscall_64.c:94
 entry_SYSCALL_64_after_hwframe+0x77/0x7f
RIP: 0033:0x7f9e5e39c819
Code: ff c3 66 2e 0f 1f 84 00 00 00 00 00 0f 1f 44 00 00 48 89 f8 48 89 f7 48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 ff ff 73 01 c3 48 c7 c1 e8 ff ff ff f7 d8 64 89 01 48
RSP: 002b:00007f9e5f2d6028 EFLAGS: 00000246 ORIG_RAX: 000000000000002e
RAX: ffffffffffffffda RBX: 00007f9e5e615fa0 RCX: 00007f9e5e39c819
RDX: 0000000000000000 RSI: 00002000000007c0 RDI: 0000000000000003
RBP: 00007f9e5e432c91 R08: 0000000000000000 R09: 0000000000000000
R10: 0000000000000000 R11: 0000000000000246 R12: 0000000000000000
R13: 00007f9e5e616038 R14: 00007f9e5e615fa0 R15: 00007ffc6a25e4e8
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
