Received: from mail-oi1-f200.google.com (mail-oi1-f200.google.com [209.85.167.200])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DA00A3B636A
	for <syzbot@lists.linux.dev>; Tue, 25 Aug 2026 20:07:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.167.200
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787688458; cv=none; b=OCKQK4ANbfgA3TySoVt/zD5FxDy1nSHY2+3M0gLUb2sHubHy37mSPZBoa2q5sBvZ2pPE6FCdX4oF2tVrFPmnhmjE2mo5JD1OWQjkBPDdQ7LuSCcySmsIYUu0NG3M9r9ly05BXG/LuYum5SRJ04ILxduGVRibLVAPXMXTsd4pN3k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787688458; c=relaxed/simple;
	bh=IqUPtS1OrVVKgQDl+JiFu/y4TbwemwqEKa/UGKCWMWE=;
	h=MIME-Version:Date:In-Reply-To:Message-ID:Subject:From:To:Cc:
	 Content-Type; b=U/3htXMN7nzHrBZLxj85inVIghfBBESte8FSQiH1Ph/bsuZoJSKYx5KdUGoJCnPLOkFGaWESnVzxtMAUNojZrjOUvpRyxVR3tJocCY4gN2yp5yzLN39seQE0pBdYETBP13IoPE5tYbZ6/gp5l/+nTar16dI5F+c90RnmIce3fHA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com; arc=none smtp.client-ip=209.85.167.200
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com
Received: by mail-oi1-f200.google.com with SMTP id 5614622812f47-4a49f09233fso290953b6e.0
        for <syzbot@lists.linux.dev>; Tue, 25 Aug 2026 13:07:36 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1787688456; x=1788293256;
        h=content-type:cc:to:from:subject:message-id:in-reply-to:date
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to:content-type;
        bh=pV1WjeHgrdLhIcvemmYEAIzR81INpamnbzvykyKd8bI=;
        b=MONetA5ad+iDpHZzRLXBYD4N710EONr8rsEORnjTsGj0Aka0+lP4QF1Nd5U4b1+G8A
         rD9c0Z+qGElzanqmU809AeBZm+6KZpJ8UpNZfeqrQfJdx6hsCOa09FzOwdvcCVLp0/L9
         WwiXgtVFp8FPdoTwQiSNN3diHkuRHDhBCo/uX5SHO7l7cf6QMdBtmQI96NlVlmygjDlf
         lsZzcey+6TpftfWIq70kTj6wVifoy92gNWwd8hpoR6+QlGxAtlf4lj+hH1Wdb8xwzatn
         lOb3sXTm+XxPv+uxU1PSib9SQpm36DC9mqVOfMv2pWjWYzrtztDZDyiXar4CxUoIbfPM
         +Nsw==
X-Gm-Message-State: AFuF++nqM0+hAfFKa9Ne3jRNaRx6H7NPD37E5MOzfHdEFjUHsy0KEN3+
	mW4Z14YeTYkBl8uuLO5h0HoAthvZFkHR5i9OgCqqadAhNezq1gGi0ebdufxepgSq++E6mc9Syyc
	F/zv07pMiydukfLKIwAgnDb5omm/kR57HK/Q0CEPi+ALfcU4FVp0sZ3kpgJc=
Precedence: bulk
X-Mailing-List: syzbot@lists.linux.dev
List-Id: <syzbot.lists.linux.dev>
List-Subscribe: <mailto:syzbot+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:syzbot+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Received: by 2002:a05:6808:3090:b0:495:ca1b:7865 with SMTP id
 5614622812f47-4b3504b104amr7078694b6e.11.1787688455876; Tue, 25 Aug 2026
 13:07:35 -0700 (PDT)
Date: Tue, 25 Aug 2026 13:07:35 -0700
In-Reply-To: <20260825152152.86092-1-ahemadkhawar123@gmail.com>
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <6a8df607.dbb3a75c.7844.002c.GAE@google.com>
Subject: [syzbot ci] Re: xsk: Fix circular locking dependency in xsk_bind
From: syzbot ci <syzbot+ci9230f67b2f9ec34f@syzkaller.appspotmail.com>
To: ahemadkhawar123@gmail.com, ast@kernel.org, bpf@vger.kernel.org, 
	daniel@iogearbox.net, kuba@kernel.org, linux-kernel@vger.kernel.org, 
	maciej.fijalkowski@intel.com, magnus.karlsson@intel.com, 
	netdev@vger.kernel.org, pabeni@redhat.com, sdf@fomichev.me, 
	syzbot@syzkaller.appspotmail.com
Cc: syzbot@lists.linux.dev, syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"

syzbot ci has tested the following series

[v1] xsk: Fix circular locking dependency in xsk_bind
https://lore.kernel.org/all/20260825152152.86092-1-ahemadkhawar123@gmail.com
* [PATCH bpf-next] xsk: Fix circular locking dependency in xsk_bind

and found the following issue:
possible deadlock in xp_clear_dev

Full report is available here:
https://ci.syzbot.org/series/6f095c15-0f05-4d2e-a9eb-8d4d85f669a6

***

possible deadlock in xp_clear_dev

tree:      bpf-next
URL:       https://kernel.googlesource.com/pub/scm/linux/kernel/git/bpf/bpf-next.git
base:      5e289c5a4a526e870efac0ca658635c47138593a
arch:      amd64
compiler:  Debian clang version 22.1.8 (++20260613092233+e80beda6e255-1~exp1~20260613092250.77), Debian LLD 22.1.8
config:    https://ci.syzbot.org/builds/cde9ebbb-b104-4fe4-8779-17786d4f4336/config
syz repro: https://ci.syzbot.org/findings/bb56c4f2-d20c-4177-a137-583624105374/syz_repro

netlink: 14 bytes leftover after parsing attributes in process `syz.0.17'.
======================================================
WARNING: possible circular locking dependency detected
syzkaller #0 Not tainted
------------------------------------------------------
syz.0.17/5789 is trying to acquire lock:
ffff88816f80ee70 (&dev_instance_lock_key#3){+.+.}-{4:4}, at: netdev_lock include/linux/netdevice.h:2861 [inline]
ffff88816f80ee70 (&dev_instance_lock_key#3){+.+.}-{4:4}, at: netdev_lock_ops include/net/netdev_lock.h:42 [inline]
ffff88816f80ee70 (&dev_instance_lock_key#3){+.+.}-{4:4}, at: xp_clear_dev+0x13b/0x340 net/xdp/xsk_buff_pool.c:297

but task is already holding lock:
ffff8881741d06b8 (&xs->mutex){+.+.}-{4:4}, at: xsk_notifier+0xcd/0x230 net/xdp/xsk.c:2109

which lock already depends on the new lock.


the existing dependency chain (in reverse order) is:

-> #1 (&xs->mutex){+.+.}-{4:4}:
       __mutex_lock_common kernel/locking/mutex.c:646 [inline]
       __mutex_lock+0x19d/0x1550 kernel/locking/mutex.c:821
       xsk_bind+0x2c0/0x1370 net/xdp/xsk.c:1622
       __sys_bind_socket net/socket.c:1945 [inline]
       __sys_bind+0x2e3/0x410 net/socket.c:1976
       __do_sys_bind net/socket.c:1981 [inline]
       __se_sys_bind net/socket.c:1979 [inline]
       __x64_sys_bind+0x7a/0x90 net/socket.c:1979
       do_syscall_x64 arch/x86/entry/syscall_64.c:61 [inline]
       do_syscall_64+0x166/0x520 arch/x86/entry/syscall_64.c:84
       entry_SYSCALL_64_after_hwframe+0x77/0x7f

-> #0 (&dev_instance_lock_key#3){+.+.}-{4:4}:
       check_prev_add kernel/locking/lockdep.c:3181 [inline]
       check_prevs_add kernel/locking/lockdep.c:3300 [inline]
       validate_chain kernel/locking/lockdep.c:3924 [inline]
       __lock_acquire+0x1520/0x2cf0 kernel/locking/lockdep.c:5253
       lock_acquire+0x106/0x350 kernel/locking/lockdep.c:5886
       __mutex_lock_common kernel/locking/mutex.c:646 [inline]
       __mutex_lock+0x19d/0x1550 kernel/locking/mutex.c:821
       netdev_lock include/linux/netdevice.h:2861 [inline]
       netdev_lock_ops include/net/netdev_lock.h:42 [inline]
       xp_clear_dev+0x13b/0x340 net/xdp/xsk_buff_pool.c:297
       xsk_notifier+0x1a1/0x230 net/xdp/xsk.c:2118
       notifier_call_chain+0x1a5/0x3d0 kernel/notifier.c:85
       call_netdevice_notifiers_extack net/core/dev.c:2313 [inline]
       call_netdevice_notifiers net/core/dev.c:2327 [inline]
       unregister_netdevice_many_notify+0x17f9/0x2140 net/core/dev.c:12518
       rtnl_delete_link net/core/rtnetlink.c:3652 [inline]
       rtnl_dellink+0x5be/0x810 net/core/rtnetlink.c:3694
       rtnetlink_rcv_msg+0x802/0xc00 net/core/rtnetlink.c:7132
       netlink_rcv_skb+0x226/0x4a0 net/netlink/af_netlink.c:2556
       netlink_unicast_kernel net/netlink/af_netlink.c:1319 [inline]
       netlink_unicast+0x7bd/0x940 net/netlink/af_netlink.c:1345
       netlink_sendmsg+0x813/0xb40 net/netlink/af_netlink.c:1900
       sock_sendmsg_nosec+0x13a/0x180 net/socket.c:800
       __sock_sendmsg net/socket.c:815 [inline]
       ____sys_sendmsg+0x54e/0x850 net/socket.c:2713
       ___sys_sendmsg+0x2a5/0x360 net/socket.c:2767
       __sys_sendmsg net/socket.c:2799 [inline]
       __do_sys_sendmsg net/socket.c:2804 [inline]
       __se_sys_sendmsg net/socket.c:2802 [inline]
       __x64_sys_sendmsg+0x1b1/0x290 net/socket.c:2802
       do_syscall_x64 arch/x86/entry/syscall_64.c:61 [inline]
       do_syscall_64+0x166/0x520 arch/x86/entry/syscall_64.c:84
       entry_SYSCALL_64_after_hwframe+0x77/0x7f

other info that might help us debug this:

 Possible unsafe locking scenario:

       CPU0                    CPU1
       ----                    ----
  lock(&xs->mutex);
                               lock(&dev_instance_lock_key#3);
                               lock(&xs->mutex);
  lock(&dev_instance_lock_key#3);

 *** DEADLOCK ***

locks held by syz.0.17/5789: 3, last CPU#1:
 #0: ffffffff90036040 (rtnl_mutex){+.+.}-{4:4}, at: rtnl_lock net/core/rtnetlink.c:80 [inline]
 #0: ffffffff90036040 (rtnl_mutex){+.+.}-{4:4}, at: rtnl_net_lock include/linux/rtnetlink.h:134 [inline]
 #0: ffffffff90036040 (rtnl_mutex){+.+.}-{4:4}, at: rtnl_dellink+0x41b/0x810 net/core/rtnetlink.c:3686
 #1: ffff88801d81eed0 (&net->xdp.lock){+.+.}-{4:4}, at: xsk_notifier+0x89/0x230 net/xdp/xsk.c:2105
 #2: ffff8881741d06b8 (&xs->mutex){+.+.}-{4:4}, at: xsk_notifier+0xcd/0x230 net/xdp/xsk.c:2109

stack backtrace:
CPU: 1 UID: 0 PID: 5789 Comm: syz.0.17 Not tainted syzkaller #0 PREEMPT(full) 
Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS 1.16.2-debian-1.16.2-1 04/01/2014
Call Trace:
 <TASK>
 dump_stack_lvl+0xe8/0x150 lib/dump_stack.c:120
 print_circular_bug+0x2e1/0x300 kernel/locking/lockdep.c:2059
 check_noncircular+0x12e/0x150 kernel/locking/lockdep.c:2191
 check_prev_add kernel/locking/lockdep.c:3181 [inline]
 check_prevs_add kernel/locking/lockdep.c:3300 [inline]
 validate_chain kernel/locking/lockdep.c:3924 [inline]
 __lock_acquire+0x1520/0x2cf0 kernel/locking/lockdep.c:5253
 lock_acquire+0x106/0x350 kernel/locking/lockdep.c:5886
 __mutex_lock_common kernel/locking/mutex.c:646 [inline]
 __mutex_lock+0x19d/0x1550 kernel/locking/mutex.c:821
 netdev_lock include/linux/netdevice.h:2861 [inline]
 netdev_lock_ops include/net/netdev_lock.h:42 [inline]
 xp_clear_dev+0x13b/0x340 net/xdp/xsk_buff_pool.c:297
 xsk_notifier+0x1a1/0x230 net/xdp/xsk.c:2118
 notifier_call_chain+0x1a5/0x3d0 kernel/notifier.c:85
 call_netdevice_notifiers_extack net/core/dev.c:2313 [inline]
 call_netdevice_notifiers net/core/dev.c:2327 [inline]
 unregister_netdevice_many_notify+0x17f9/0x2140 net/core/dev.c:12518
 rtnl_delete_link net/core/rtnetlink.c:3652 [inline]
 rtnl_dellink+0x5be/0x810 net/core/rtnetlink.c:3694
 rtnetlink_rcv_msg+0x802/0xc00 net/core/rtnetlink.c:7132
 netlink_rcv_skb+0x226/0x4a0 net/netlink/af_netlink.c:2556
 netlink_unicast_kernel net/netlink/af_netlink.c:1319 [inline]
 netlink_unicast+0x7bd/0x940 net/netlink/af_netlink.c:1345
 netlink_sendmsg+0x813/0xb40 net/netlink/af_netlink.c:1900
 sock_sendmsg_nosec+0x13a/0x180 net/socket.c:800
 __sock_sendmsg net/socket.c:815 [inline]
 ____sys_sendmsg+0x54e/0x850 net/socket.c:2713
 ___sys_sendmsg+0x2a5/0x360 net/socket.c:2767
 __sys_sendmsg net/socket.c:2799 [inline]
 __do_sys_sendmsg net/socket.c:2804 [inline]
 __se_sys_sendmsg net/socket.c:2802 [inline]
 __x64_sys_sendmsg+0x1b1/0x290 net/socket.c:2802
 do_syscall_x64 arch/x86/entry/syscall_64.c:61 [inline]
 do_syscall_64+0x166/0x520 arch/x86/entry/syscall_64.c:84
 entry_SYSCALL_64_after_hwframe+0x77/0x7f
RIP: 0033:0x7f2ec039e0d9
Code: ff c3 66 2e 0f 1f 84 00 00 00 00 00 0f 1f 44 00 00 48 89 f8 48 89 f7 48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 ff ff 73 01 c3 48 c7 c1 e8 ff ff ff f7 d8 64 89 01 48
RSP: 002b:00007f2ec1214028 EFLAGS: 00000246 ORIG_RAX: 000000000000002e
RAX: ffffffffffffffda RBX: 00007f2ec0625fa0 RCX: 00007f2ec039e0d9
RDX: 0000000004048004 RSI: 00002000000001c0 RDI: 0000000000000005
RBP: 00007f2ec0435024 R08: 0000000000000000 R09: 0000000000000000
R10: 0000000000000000 R11: 0000000000000246 R12: 0000000000000000
R13: 00007f2ec0626038 R14: 00007f2ec0625fa0 R15: 00007ffca00aa538
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
