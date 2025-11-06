Received: from mail-il1-f197.google.com (mail-il1-f197.google.com [209.85.166.197])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C6909214A94
	for <syzbot@lists.linux.dev>; Thu,  6 Nov 2025 09:27:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.197
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762421271; cv=none; b=qSbwGNkR1Paz9YaP8W8b/znpD5iPT5raQD8CYkY3CRKBqAODz/97JAfuWpfDTUQqbyWCz2siHJqVuXHa0JKGOMne6hkF/Er+jYSGxZaWlzjkP1OANhDabAjfx84bcsF1EHRjEID4zW9YnUDosUHwKtZ+7/nrT0D/6DvSQr+cRYg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762421271; c=relaxed/simple;
	bh=xw8qo9h8SQlFw6HjdK6w8rlP9+L9e5aX6ertUQPO9vk=;
	h=MIME-Version:Date:Message-ID:Subject:From:To:Cc:Content-Type; b=aW39MKx0wrkY3+FEbTZWsOArlV5Y8aLe5KonTcRQuHPVPwzY3cBnPYNVrEeqWpzCMNK8BrfE0VXTEDz90GjX+OXevt5HHa+qiX98DS/TmzemRSovv4bHrkil6JH+Yj9vkN6mgXKPib36WSoDAEtFohaRiZo3drgU2DsRXATu9cs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com; arc=none smtp.client-ip=209.85.166.197
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com
Received: by mail-il1-f197.google.com with SMTP id e9e14a558f8ab-433270dad0dso1191855ab.0
        for <syzbot@lists.linux.dev>; Thu, 06 Nov 2025 01:27:49 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1762421269; x=1763026069;
        h=content-transfer-encoding:cc:to:from:subject:message-id:date
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=KGqd7U66P7BglVqFvrVVqKw4yHKvfsAYDBxerKETWHI=;
        b=EYFoDMTqmPYjbzHmPx7xy1oDhbh7Tx1dH8TVXdhskkwUE2ouoE29nVa97MsBOucu2S
         zPWSPsXqI+TF+e85lucNkImIOcAKSRtuFk5l4zZdgvdBYEiXGz5Bx0WD/tVorFOd2ivt
         o+MiNA/64sKL/DlnEX0DQAzFlX4zjv6aVGBXL8cg1s0EU4wkOkQyLVttnjSd+vwXs9Zb
         7ibBcbSU/PhwJVF1GwtUaWIAScswB3/Hu3LeiGZze2RbPixDRvHRf7npgsH8KbidyoeW
         czffXjjcdsoJYl6Z1Tf7TxrYDLy8pbpAzhtGNleoiSxlh8i97U5k82mxpsUMxuYmFi3v
         vSxA==
X-Gm-Message-State: AOJu0YwpQjrLl+LrGnottN6QKuWzFBDYZ+b11a429ofNZ+voyORg48rU
	tzrW9cPT4UTnie7OExvjWTMjjTFhmLRlXWibvAGASsGgRHw6hsUD18kPz/chhxZ8lNpoJwKAaBL
	4hHSbvvbJLoiAu9xPfU2nfhIjvybFWjAWzKwPONDb2bGm8v+tgaQvSYyj9hU=
X-Google-Smtp-Source: AGHT+IHV/ldvmdeIYMlcloi3AVltukrTjBqhoyDwmx7ZuVV8HG+66dzYiXfy3KienFHZwwMAkmDxYubG6qOCoDRv6HeoRYsTIJMm
Precedence: bulk
X-Mailing-List: syzbot@lists.linux.dev
List-Id: <syzbot.lists.linux.dev>
List-Subscribe: <mailto:syzbot+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:syzbot+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Received: by 2002:a05:6e02:174b:b0:433:3396:5fd3 with SMTP id
 e9e14a558f8ab-4334ee396famr33871865ab.4.1762421268843; Thu, 06 Nov 2025
 01:27:48 -0800 (PST)
Date: Thu, 06 Nov 2025 01:27:48 -0800
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <690c6a14.050a0220.1e8caa.00cf.GAE@google.com>
Subject: [moderation/CI] Re: tipc: Fix use-after-free in tipc_mon_reinit_self().
From: syzbot ci <syzbot+ci5eddf783202c98fd@syzkaller.appspotmail.com>
To: syzkaller-upstream-moderation@googlegroups.com
Cc: syzbot@lists.linux.dev
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

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
URL:       https://kernel.googlesource.com/pub/scm/linux/kernel/git/netdev/=
net.git
base:      3d18a84eddde169d6dbf3c72cc5358b988c347d0
arch:      amd64
compiler:  Debian clang version 20.1.8 (++20250708063551+0c9f909b7976-1~exp=
1~20250708183702.136), Debian LLD 20.1.8
config:    https://ci.syzbot.org/builds/b2774856-e331-420e-a340-5107ec4b06f=
9/config
C repro:   https://ci.syzbot.org/findings/1f0a4298-b797-4217-8d6d-15f98c0ff=
d38/c_repro
syz repro: https://ci.syzbot.org/findings/1f0a4298-b797-4217-8d6d-15f98c0ff=
d38/syz_repro

tipc: Started in network mode
tipc: Node identity 4, cluster identity 4711
tipc: Node number set to 4
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
WARNING: possible recursive locking detected
syzkaller #0 Not tainted
--------------------------------------------
syz.0.17/5963 is trying to acquire lock:
ffffffff8f2cb1c8 (rtnl_mutex){+.+.}-{4:4}, at: tipc_mon_reinit_self+0x25/0x=
360 net/tipc/monitor.c:714

but task is already holding lock:
ffffffff8f2cb1c8 (rtnl_mutex){+.+.}-{4:4}, at: __tipc_nl_compat_doit net/ti=
pc/netlink_compat.c:358 [inline]
ffffffff8f2cb1c8 (rtnl_mutex){+.+.}-{4:4}, at: tipc_nl_compat_doit+0x1fd/0x=
5f0 net/tipc/netlink_compat.c:393

other info that might help us debug this:
 Possible unsafe locking scenario:

       CPU0
       ----
  lock(rtnl_mutex);
  lock(rtnl_mutex);

 *** DEADLOCK ***

 May be due to missing lock nesting notation

3 locks held by syz.0.17/5963:
 #0: ffffffff8f331050 (cb_lock){++++}-{4:4}, at: genl_rcv+0x19/0x40 net/net=
link/genetlink.c:1218
 #1: ffffffff8f330e68 (genl_mutex){+.+.}-{4:4}, at: genl_lock net/netlink/g=
enetlink.c:35 [inline]
 #1: ffffffff8f330e68 (genl_mutex){+.+.}-{4:4}, at: genl_op_lock net/netlin=
k/genetlink.c:60 [inline]
 #1: ffffffff8f330e68 (genl_mutex){+.+.}-{4:4}, at: genl_rcv_msg+0x10d/0x79=
0 net/netlink/genetlink.c:1209
 #2: ffffffff8f2cb1c8 (rtnl_mutex){+.+.}-{4:4}, at: __tipc_nl_compat_doit n=
et/tipc/netlink_compat.c:358 [inline]
 #2: ffffffff8f2cb1c8 (rtnl_mutex){+.+.}-{4:4}, at: tipc_nl_compat_doit+0x1=
fd/0x5f0 net/tipc/netlink_compat.c:393

stack backtrace:
CPU: 1 UID: 0 PID: 5963 Comm: syz.0.17 Not tainted syzkaller #0 PREEMPT(ful=
l)=20
Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS 1.16.2-debian-1.16=
.2-1 04/01/2014
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
Code: ff ff c3 66 2e 0f 1f 84 00 00 00 00 00 0f 1f 40 00 48 89 f8 48 89 f7 =
48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 ff f=
f 73 01 c3 48 c7 c1 a8 ff ff ff f7 d8 64 89 01 48
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

The email will later be sent to:
[davem@davemloft.net edumazet@google.com hoang.h.le@dektech.com.au horms@ke=
rnel.org jmaloy@redhat.com kuba@kernel.org kuni1840@gmail.com kuniyu@google=
.com netdev@vger.kernel.org pabeni@redhat.com syzbot@syzkaller.appspotmail.=
com tipc-discussion@lists.sourceforge.net]

If the report looks fine to you, reply with:
#syz upstream

