Received: from mail-il1-f199.google.com (mail-il1-f199.google.com [209.85.166.199])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4F2CE15442C
	for <syzbot@lists.linux.dev>; Thu,  6 Nov 2025 09:38:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.199
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762421931; cv=none; b=EjkfCQeVNfHTd2MwK2FMH1DGAnIDQtB0vfxAl1Zcsi1T1u1QdoAhYxF1ttuba0cfZJMABEAV/jQLwUmwHikfTYUsWoWqlFYY96qlHm3c5jEpX1WvuedHjoJusCI7/DfAX51YZvmncd1PgEFqE8+Az+/Lyf23zdeyBKnj2W8B7V0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762421931; c=relaxed/simple;
	bh=DtghamWpAqJB0XWQ7CTqHFHj1cr0WF4rtk3lIQlCrqQ=;
	h=MIME-Version:Date:In-Reply-To:Message-ID:Subject:From:To:Cc:
	 Content-Type; b=lGXwh68SuKzmXZh89OvyfPK1Kv2rWtGB00YVtyV08GVrumlasudN5rBEch1c3WHJ7tBInww2CVT0EWVNIeydMHTCCfCVQ2XZjXEfcPUxKKx7nfgV0FQBuc6Tu/4V66gLCbfz64oU+VjKDYC6wpKvF59byfyhGfTr+4vxIWxOXSQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com; arc=none smtp.client-ip=209.85.166.199
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com
Received: by mail-il1-f199.google.com with SMTP id e9e14a558f8ab-43335646758so823805ab.3
        for <syzbot@lists.linux.dev>; Thu, 06 Nov 2025 01:38:50 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1762421929; x=1763026729;
        h=cc:to:from:subject:message-id:in-reply-to:date:mime-version
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=4XCdKUDePwC5bK3gnta/IB7CyT1KUfoGo6riGX180/U=;
        b=XerxZGXEThl37GxtCvcsh7OfHGmJkIPyAI+0zqPu1ftsMYU5f9yzCUJ78XHejlJIFo
         QrLNcp1ithkjvn5c+a62prkCu5BXOmY2PFAgz7k2HSCvcIJE5GbmaFaiNb4m7wuZVeuT
         kaQcinIvIoChaLetZ6hoEaUB5+7I8sz9IVMFdRTZB0DXTDbBHF05VPo5DdYRcIGyVLAZ
         Bl1oPddCi73jg+CnUv/HubWspgFvPE0NAVOir/agHd9jq3Wq9eg9WOtc7zXWrvT0vevw
         wlOsT3DLN5evfHmaG/g2z2E/lvVmoN2B3hiFE/4YnU4SfOuid8ZHk4VqMM3odRDOddfs
         Ktiw==
X-Gm-Message-State: AOJu0YxRUgkKH7WNjxMjf7eNCMycPNWbsuMUX/pjShYK9cWAavSBOHUV
	8JNDVtyHQOeSh9tl/jmwiDUiGHeRlIIf7yRLSFthDX3xorrkqA6KH/uJuwmQJn9q/OLX665PCxI
	V8Sr0JqCCDqRrb6+ywuiXJhhGq+m6K1HR58ysgXUXj4K7GGmPnGRxK8BMXuA=
X-Google-Smtp-Source: AGHT+IH9osoLtWiCfH/NNOXjcc2ah3tFcq/2eWNZvEHN1P6kE0z6RiQNUsqnqRukosCs2D1Akiz5WhECLDbLEokeBK9MQKL3dDs5
Precedence: bulk
X-Mailing-List: syzbot@lists.linux.dev
List-Id: <syzbot.lists.linux.dev>
List-Subscribe: <mailto:syzbot+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:syzbot+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Received: by 2002:a05:6e02:1aab:b0:433:206d:5333 with SMTP id
 e9e14a558f8ab-43340800e28mr91240385ab.30.1762421929495; Thu, 06 Nov 2025
 01:38:49 -0800 (PST)
Date: Thu, 06 Nov 2025 01:38:49 -0800
In-Reply-To: <20251106053309.401275-1-kuniyu@google.com>
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <690c6ca9.050a0220.1e8caa.00d2.GAE@google.com>
Subject: [syzbot ci] Re: tipc: Fix use-after-free in tipc_mon_reinit_self().
From: syzbot ci <syzbot+cif2d6d318f7e85f0b@syzkaller.appspotmail.com>
To: davem@davemloft.net, edumazet@google.com, hoang.h.le@dektech.com.au, 
	horms@kernel.org, jmaloy@redhat.com, kuba@kernel.org, kuni1840@gmail.com, 
	kuniyu@google.com, netdev@vger.kernel.org, pabeni@redhat.com, 
	syzbot@syzkaller.appspotmail.com, tipc-discussion@lists.sourceforge.net
Cc: syzbot@lists.linux.dev, syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"

syzbot ci has tested the following series

[v1] tipc: Fix use-after-free in tipc_mon_reinit_self().
https://lore.kernel.org/all/20251106053309.401275-1-kuniyu@google.com
* [PATCH v1 net] tipc: Fix use-after-free in tipc_mon_reinit_self().

and found the following issue:
possible deadlock in tipc_mon_reinit_self

Full report is available here:
https://ci.syzbot.org/series/bfabf013-65e3-4ca9-8f54-0c7eef8be01a

***

possible deadlock in tipc_mon_reinit_self

tree:      net
URL:       https://kernel.googlesource.com/pub/scm/linux/kernel/git/netdev/net.git
base:      3d18a84eddde169d6dbf3c72cc5358b988c347d0
arch:      amd64
compiler:  Debian clang version 20.1.8 (++20250708063551+0c9f909b7976-1~exp1~20250708183702.136), Debian LLD 20.1.8
config:    https://ci.syzbot.org/builds/b2774856-e331-420e-a340-5107ec4b06f9/config
C repro:   https://ci.syzbot.org/findings/1f0a4298-b797-4217-8d6d-15f98c0ffd38/c_repro
syz repro: https://ci.syzbot.org/findings/1f0a4298-b797-4217-8d6d-15f98c0ffd38/syz_repro

tipc: Started in network mode
tipc: Node identity 4, cluster identity 4711
tipc: Node number set to 4
============================================
WARNING: possible recursive locking detected
syzkaller #0 Not tainted
--------------------------------------------
syz.0.17/5963 is trying to acquire lock:
ffffffff8f2cb1c8 (rtnl_mutex){+.+.}-{4:4}, at: tipc_mon_reinit_self+0x25/0x360 net/tipc/monitor.c:714

but task is already holding lock:
ffffffff8f2cb1c8 (rtnl_mutex){+.+.}-{4:4}, at: __tipc_nl_compat_doit net/tipc/netlink_compat.c:358 [inline]
ffffffff8f2cb1c8 (rtnl_mutex){+.+.}-{4:4}, at: tipc_nl_compat_doit+0x1fd/0x5f0 net/tipc/netlink_compat.c:393

other info that might help us debug this:
 Possible unsafe locking scenario:

       CPU0
       ----
  lock(rtnl_mutex);
  lock(rtnl_mutex);

 *** DEADLOCK ***

 May be due to missing lock nesting notation

3 locks held by syz.0.17/5963:
 #0: ffffffff8f331050 (cb_lock){++++}-{4:4}, at: genl_rcv+0x19/0x40 net/netlink/genetlink.c:1218
 #1: ffffffff8f330e68 (genl_mutex){+.+.}-{4:4}, at: genl_lock net/netlink/genetlink.c:35 [inline]
 #1: ffffffff8f330e68 (genl_mutex){+.+.}-{4:4}, at: genl_op_lock net/netlink/genetlink.c:60 [inline]
 #1: ffffffff8f330e68 (genl_mutex){+.+.}-{4:4}, at: genl_rcv_msg+0x10d/0x790 net/netlink/genetlink.c:1209
 #2: ffffffff8f2cb1c8 (rtnl_mutex){+.+.}-{4:4}, at: __tipc_nl_compat_doit net/tipc/netlink_compat.c:358 [inline]
 #2: ffffffff8f2cb1c8 (rtnl_mutex){+.+.}-{4:4}, at: tipc_nl_compat_doit+0x1fd/0x5f0 net/tipc/netlink_compat.c:393

stack backtrace:
CPU: 1 UID: 0 PID: 5963 Comm: syz.0.17 Not tainted syzkaller #0 PREEMPT(full) 
Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS 1.16.2-debian-1.16.2-1 04/01/2014
Call Trace:
 <TASK>
 dump_stack_lvl+0x189/0x250 lib/dump_stack.c:120
 print_deadlock_bug+0x28b/0x2a0 kernel/locking/lockdep.c:3041
 check_deadlock kernel/locking/lockdep.c:3093 [inline]
 validate_chain+0x1a3f/0x2140 kernel/locking/lockdep.c:3895
 __lock_acquire+0xab9/0xd20 kernel/locking/lockdep.c:5237
 lock_acquire+0x120/0x360 kernel/locking/lockdep.c:5868
 __mutex_lock_common kernel/locking/mutex.c:598 [inline]
 __mutex_lock+0x187/0x1350 kernel/locking/mutex.c:760
 tipc_mon_reinit_self+0x25/0x360 net/tipc/monitor.c:714
 tipc_net_finalize+0x115/0x190 net/tipc/net.c:140
 tipc_net_init+0x104/0x190 net/tipc/net.c:122
 __tipc_nl_net_set+0x3b9/0x5a0 net/tipc/net.c:263
 __tipc_nl_compat_doit net/tipc/netlink_compat.c:371 [inline]
 tipc_nl_compat_doit+0x3bc/0x5f0 net/tipc/netlink_compat.c:393
 tipc_nl_compat_handle net/tipc/netlink_compat.c:-1 [inline]
 tipc_nl_compat_recv+0x83c/0xbe0 net/tipc/netlink_compat.c:1321
 genl_family_rcv_msg_doit+0x215/0x300 net/netlink/genetlink.c:1115
 genl_family_rcv_msg net/netlink/genetlink.c:1195 [inline]
 genl_rcv_msg+0x60e/0x790 net/netlink/genetlink.c:1210
 netlink_rcv_skb+0x208/0x470 net/netlink/af_netlink.c:2552
 genl_rcv+0x28/0x40 net/netlink/genetlink.c:1219
 netlink_unicast_kernel net/netlink/af_netlink.c:1320 [inline]
 netlink_unicast+0x82f/0x9e0 net/netlink/af_netlink.c:1346
 netlink_sendmsg+0x805/0xb30 net/netlink/af_netlink.c:1896
 sock_sendmsg_nosec net/socket.c:727 [inline]
 __sock_sendmsg+0x21c/0x270 net/socket.c:742
 ____sys_sendmsg+0x505/0x830 net/socket.c:2630
 ___sys_sendmsg+0x21f/0x2a0 net/socket.c:2684
 __sys_sendmsg net/socket.c:2716 [inline]
 __do_sys_sendmsg net/socket.c:2721 [inline]
 __se_sys_sendmsg net/socket.c:2719 [inline]
 __x64_sys_sendmsg+0x19b/0x260 net/socket.c:2719
 do_syscall_x64 arch/x86/entry/syscall_64.c:63 [inline]
 do_syscall_64+0xfa/0xfa0 arch/x86/entry/syscall_64.c:94
 entry_SYSCALL_64_after_hwframe+0x77/0x7f
RIP: 0033:0x7f13d8b8efc9
Code: ff ff c3 66 2e 0f 1f 84 00 00 00 00 00 0f 1f 40 00 48 89 f8 48 89 f7 48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 ff ff 73 01 c3 48 c7 c1 a8 ff ff ff f7 d8 64 89 01 48
RSP: 002b:00007fff77cccbf8 EFLAGS: 00000246 ORIG_RAX: 000000000000002e
RAX: ffffffffffffffda RBX: 00007f13d8de5fa0 RCX: 00007f13d8b8efc9
RDX: 0000000000000000 RSI: 00002000000001c0 RDI: 0000000000000003
RBP: 00007f13d8c11f91 R08: 0000000000000000 R09: 0000000000000000
R10: 0000000000000000 R11: 0000000000000246 R12: 0000000000000000
R13: 00007f13d8de5fa0 R14: 00007f13d8de5fa0 R15: 0000000000000003
 </TASK>


***

If these findings have caused you to resend the series or submit a
separate fix, please add the following tag to your commit message:
  Tested-by: syzbot@syzkaller.appspotmail.com

---
This report is generated by a bot. It may contain errors.
syzbot ci engineers can be reached at syzkaller@googlegroups.com.
