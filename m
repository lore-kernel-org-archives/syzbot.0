Received: from mail-ot1-f71.google.com (mail-ot1-f71.google.com [209.85.210.71])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1ED691F4CB3
	for <syzbot@lists.linux.dev>; Wed,  8 Apr 2026 06:45:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.71
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1775630732; cv=none; b=smYUY28w02nAtQaYhXQQ0CwZvAOfrY9z7tS1h1rf+YhjJYm8nwlFamCViCHV0lVasgf2d+UOP+Vcu80CMZMXbkRqCx09PFE1CpdHh/wK5OQWsOHnP5hcGWcdnv3CAfGRVyZhLTy8/PrX+4WA+mNylNUBuotdkuqSzs6TiXCf5hs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1775630732; c=relaxed/simple;
	bh=xgEC+WfL2idF4NX3OWD/q4qLDceolgtCSjaHyw0T6To=;
	h=MIME-Version:Date:In-Reply-To:Message-ID:Subject:From:To:Cc:
	 Content-Type; b=HWAdIi5v96NTW97YszbkP2YEDz5cRIFnMGwbIr8+PR0wp6jFwojbnK/wRFDePVj7PoOujOUDyypJK7CSlZGOzHFIG29/8VsZj2LRNsxf64lH8P4acUfnCGfl9ESF0OcejQhzFkRzVVQ3pHt3kbS7NO1IhvVxQEL9zIutg0ZqOO8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com; arc=none smtp.client-ip=209.85.210.71
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com
Received: by mail-ot1-f71.google.com with SMTP id 46e09a7af769-7dbe0e914adso5078464a34.2
        for <syzbot@lists.linux.dev>; Tue, 07 Apr 2026 23:45:29 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1775630729; x=1776235529;
        h=cc:to:from:subject:message-id:in-reply-to:date:mime-version
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=7rEQTDJ7oEJhY7ymkpvRH1m82lHz0+1l7ZXL1EKQeIg=;
        b=rVBc+UFmP/KYNjdH/xJHRYgIdT6OyFtCqA70ba8uEUMMlz/b3bovG7lQem7iNR7E1V
         V/wwFdwo7QbIQm+/G5yfVhmFGaU4LVNkEAVuzbeECTYADjD+XhiHkHA0UhWAfybj3UK9
         hCD94QWb2SndjCBy2NhcowvlPFLVtljJ/3XlFRvENr5VwjAifU1L5Ts9lb0flForvlZc
         4tonMR69wl3EWRCceFWHtRPrXwtDdlV6J9jZDHOPIU6VzwHHFpMxboM/XVY05bIJrKCY
         noT0+Qu+VIm8zGSGrj/Ay3hZ8twHWS5sE4x3wyzUheM7Boe1s4bCNJ51NWSTvQZl92//
         rtow==
X-Gm-Message-State: AOJu0Yx4qcyzgKY1fs4LK4NJ8KYFm2cKEZjOtX1tU5DXo8BnwnZE82zP
	ufPIoMFCtjhB3Bep9j/QYREHl6CwKAx1BPNg6vWiLX/Zsd5BL69DA37wddD19ZD0RA1tZRK3V0d
	ndRpoTb1WtMEwedXSBhL3FferuC3UQ1o/1AVmoNA/8cDi3SpgjYOKNGmTVA8=
Precedence: bulk
X-Mailing-List: syzbot@lists.linux.dev
List-Id: <syzbot.lists.linux.dev>
List-Subscribe: <mailto:syzbot+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:syzbot+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Received: by 2002:a05:6820:4b84:b0:67e:366b:53b7 with SMTP id
 006d021491bc7-68220741a9dmr12203235eaf.53.1775630729067; Tue, 07 Apr 2026
 23:45:29 -0700 (PDT)
Date: Tue, 07 Apr 2026 23:45:29 -0700
In-Reply-To: <20260407170214.4157-2-fmancera@suse.de>
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <69d5f989.a00a0220.468cb.0009.GAE@google.com>
Subject: [syzbot ci] Re: net_sched: fix skb memory leak in deferred qdisc drops
From: syzbot ci <syzbot+ci2b150416153fb292@syzkaller.appspotmail.com>
To: damilola@aterlo.com, davem@davemloft.net, edumazet@google.com, 
	fmancera@suse.de, horms@kernel.org, kuba@kernel.org, netdev@vger.kernel.org, 
	pabeni@redhat.com
Cc: syzbot@lists.linux.dev, syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"

syzbot ci has tested the following series

[v1] net_sched: fix skb memory leak in deferred qdisc drops
https://lore.kernel.org/all/20260407170214.4157-2-fmancera@suse.de
* [PATCH net] net_sched: fix skb memory leak in deferred qdisc drops

and found the following issue:
WARNING: suspicious RCU usage in cake_dequeue

Full report is available here:
https://ci.syzbot.org/series/90acbb62-3e93-4bb7-af7a-51d555f5956b

***

WARNING: suspicious RCU usage in cake_dequeue

tree:      net
URL:       https://kernel.googlesource.com/pub/scm/linux/kernel/git/netdev/net.git
base:      a9b8b18364fffce4c451e6f6fd218fa4ab646705
arch:      amd64
compiler:  Debian clang version 21.1.8 (++20251221033036+2078da43e25a-1~exp1~20251221153213.50), Debian LLD 21.1.8
config:    https://ci.syzbot.org/builds/a5e0fad0-c9c8-4102-b2af-b4d1c7947ee3/config
syz repro: https://ci.syzbot.org/findings/b1dd239a-f59f-414f-8bde-578258899e94/syz_repro

=============================
WARNING: suspicious RCU usage
syzkaller #0 Not tainted
-----------------------------
./include/net/sch_generic.h:581 suspicious rcu_dereference_check() usage!

other info that might help us debug this:


rcu_scheduler_active = 2, debug_locks = 1
2 locks held by syz.0.51/6016:
 #0: ffffffff8e75e640 (rcu_read_lock_bh){....}-{1:3}, at: local_bh_disable include/linux/bottom_half.h:20 [inline]
 #0: ffffffff8e75e640 (rcu_read_lock_bh){....}-{1:3}, at: rcu_read_lock_bh include/linux/rcupdate.h:903 [inline]
 #0: ffffffff8e75e640 (rcu_read_lock_bh){....}-{1:3}, at: __dev_queue_xmit+0x277/0x3890 net/core/dev.c:4778
 #1: ffff8881ad9e8170 (&sch->root_lock_key#31){+...}-{3:3}, at: spin_lock include/linux/spinlock.h:341 [inline]
 #1: ffff8881ad9e8170 (&sch->root_lock_key#31){+...}-{3:3}, at: __dev_xmit_skb net/core/dev.c:4241 [inline]
 #1: ffff8881ad9e8170 (&sch->root_lock_key#31){+...}-{3:3}, at: __dev_queue_xmit+0xbf2/0x3890 net/core/dev.c:4819

stack backtrace:
CPU: 1 UID: 0 PID: 6016 Comm: syz.0.51 Not tainted syzkaller #0 PREEMPT(full) 
Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS 1.16.2-debian-1.16.2-1 04/01/2014
Call Trace:
 <TASK>
 dump_stack_lvl+0xe8/0x150 lib/dump_stack.c:120
 lockdep_rcu_suspicious+0x13f/0x1d0 kernel/locking/lockdep.c:6876
 qdisc_root_sleeping include/net/sch_generic.h:581 [inline]
 qdisc_dequeue_drop include/net/sch_generic.h:1173 [inline]
 cake_dequeue+0x23a7/0x4e50 net/sched/sch_cake.c:2240
 dequeue_skb net/sched/sch_generic.c:297 [inline]
 qdisc_restart net/sched/sch_generic.c:402 [inline]
 __qdisc_run+0x26c/0x15d0 net/sched/sch_generic.c:420
 qdisc_run include/net/pkt_sched.h:120 [inline]
 __dev_xmit_skb net/core/dev.c:4286 [inline]
 __dev_queue_xmit+0x1bad/0x3890 net/core/dev.c:4819
 packet_snd net/packet/af_packet.c:3076 [inline]
 packet_sendmsg+0x3eb6/0x50f0 net/packet/af_packet.c:3108
 sock_sendmsg_nosec net/socket.c:727 [inline]
 __sock_sendmsg net/socket.c:742 [inline]
 __sys_sendto+0x672/0x710 net/socket.c:2206
 __do_sys_sendto net/socket.c:2213 [inline]
 __se_sys_sendto net/socket.c:2209 [inline]
 __x64_sys_sendto+0xde/0x100 net/socket.c:2209
 do_syscall_x64 arch/x86/entry/syscall_64.c:63 [inline]
 do_syscall_64+0x14d/0xf80 arch/x86/entry/syscall_64.c:94
 entry_SYSCALL_64_after_hwframe+0x77/0x7f
RIP: 0033:0x7f077b39c819
Code: ff c3 66 2e 0f 1f 84 00 00 00 00 00 0f 1f 44 00 00 48 89 f8 48 89 f7 48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 ff ff 73 01 c3 48 c7 c1 e8 ff ff ff f7 d8 64 89 01 48
RSP: 002b:00007f077c28c028 EFLAGS: 00000246 ORIG_RAX: 000000000000002c
RAX: ffffffffffffffda RBX: 00007f077b615fa0 RCX: 00007f077b39c819
RDX: 000000000000fc13 RSI: 0000200000000800 RDI: 0000000000000003
RBP: 00007f077b432c91 R08: 0000000000000000 R09: fffffffffffffef0
R10: 0000000000000880 R11: 0000000000000246 R12: 0000000000000000
R13: 00007f077b616038 R14: 00007f077b615fa0 R15: 00007fffceb20038
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
