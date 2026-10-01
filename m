Received: from mail-oi1-f200.google.com (mail-oi1-f200.google.com [209.85.167.200])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8187135E956
	for <syzbot@lists.linux.dev>; Thu,  1 Oct 2026 20:27:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.167.200
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790886432; cv=none; b=cPUuUOOm6BIscKYF0kP5BMJBnCKF3nlYCUADT9TandkbotHPe9rMDi8SrwoNIbAlQcn18iymnXaEsf/t8D07Y1eqxeMoK166Mbrrmf4iSqdyeYAElaDOUoSOmKJT4z57IcrJ4w+MoF3yPyLp3BPxNbwkEuVhdl+pZJH1NVC9pNY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790886432; c=relaxed/simple;
	bh=XkImTB+pt9KI7pm8/rIFWBc15ENeJ5BnYLvlhH+KNz4=;
	h=MIME-Version:Date:Message-ID:Subject:From:To:Cc:Content-Type; b=JGRn5onbjyL+oNPQawCpz2CLRXSPqRLr59OOdQ/Ho0grO4CTQEhjEXPQHKZCOxZC/Cig0OZbmaz/2aOKgQ4cKYWJkc/vwRKdCnlsjCbx7nNC8US1rppiYKk7O+ulVOMz7sOFaOX7FzxQmSGm9p1Mab0uh1qiqe9Dm/8AvFCDxQg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com; arc=none smtp.client-ip=209.85.167.200
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com
Received: by mail-oi1-f200.google.com with SMTP id 5614622812f47-4dab94dc3e7so11569623b6e.0
        for <syzbot@lists.linux.dev>; Thu, 01 Oct 2026 13:27:10 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1790886427; x=1791491227;
        h=content-transfer-encoding:content-type:cc:to:from:subject
         :message-id:date:mime-version:x-gm-message-state:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=408P/tdMfGcnSjGI6xWGXMvA6nHAQCDQ8vrXpzLH5KQ=;
        b=w48M9fYeLMB3o+Z7kNvLIfpSh57nstOb4fmN2xZmU4R9+IbmVPUgebWjagA1y6nSyh
         BJf/RzvtThrzlgDlMUrdtKB4unWkqX/XqHukc42j1GttTAY6ZJKojitwXp60xioB0znc
         GSe8Mv/WPyMcij4zcAZAJu6NyiyqANJbpwGlclucC6kWroutb+Cb/EmECq+l6r6BVB1X
         TVnCgX/DwIVqzaoIgArtUqPiLpLlC/WMxLWSQDFDLAhPZo5OSoaN/1asRMGf7+8NQDqQ
         x3Z+8Kk8PAGsz7VlezexX4GleUaWKihkxRgelbcoDUu6pnGX7QNpeyjLX8Nx3e3rL0iD
         nxtg==
X-Gm-Message-State: AFuF++nQX64dqrkJkI2VAq830OO6zIujQjGata16Qxd4MHSJ7NywLVYh
	5IZsOlc7oQJ/RZPJLWBQDyWWFkd5MKmpMB/yR3c/acYvssRFGrGyu2S1p7UrxCIcrxjh+1/NZFj
	KD42rd7/gTdjj1H3mQo/WkVto5r1gULgAW7Sm/somYrjkqW+0eJTS+caltuk=
Precedence: bulk
X-Mailing-List: syzbot@lists.linux.dev
List-Id: <syzbot.lists.linux.dev>
List-Subscribe: <mailto:syzbot+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:syzbot+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Received: by 2002:a05:6808:10cb:b0:4d5:27da:a495 with SMTP id
 5614622812f47-4f52b1aa147mr255675b6e.47.1790886427759; Thu, 01 Oct 2026
 13:27:07 -0700 (PDT)
Date: Thu, 01 Oct 2026 13:27:07 -0700
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <6abec21b.092aa46d.14d54.0005.GAE@google.com>
Subject: [moderation/CI] Re: ipv6: route: fix adding routes via the loopback device
From: syzbot ci <syzbot+ci29028947805739bf@syzkaller.appspotmail.com>
To: syzkaller-upstream-moderation@googlegroups.com
Cc: syzbot@lists.linux.dev
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

syzbot ci has tested the following series

[v1] ipv6: route: fix adding routes via the loopback device
https://lore.kernel.org/all/20260930152229.1453929-1-hengyul@cs.unc.edu
* [PATCH net 1/2] ipv6: route: do not validate nexthop of routes promoted t=
o reject routes
* [PATCH net 2/2] selftests: net: fib_tests: add tests for IPv6 routes via =
loopback device

and found the following issue:
WARNING in nsim_fib_event_nb

Full report is available here:
https://ci.syzbot.org/series/7c566bff-eca1-4b49-90ae-6537c6011730

***

WARNING in nsim_fib_event_nb

tree:      net
URL:       https://kernel.googlesource.com/pub/scm/linux/kernel/git/netdev/=
net.git
base:      e23a64eb244356ee47c0620f0722d51bd88db522
arch:      amd64
compiler:  Debian clang version 22.1.8 (++20260613092233+e80beda6e255-1~exp=
1~20260613092250.77), Debian LLD 22.1.8
config:    https://ci.syzbot.org/builds/ef50b46f-5dab-4a9c-943a-321047ec062=
7/config
syz repro: https://ci.syzbot.org/findings/96331068-e137-4de8-85a3-65ac3caaf=
ea0/syz_repro

------------[ cut here ]------------
i !=3D fen6_info->nsiblings
WARNING: drivers/net/netdevsim/fib.c:831 at nsim_fib6_event_init drivers/ne=
t/netdevsim/fib.c:831 [inline], CPU#1: syz.2.19/5834
WARNING: drivers/net/netdevsim/fib.c:831 at nsim_fib6_prepare_event drivers=
/net/netdevsim/fib.c:947 [inline], CPU#1: syz.2.19/5834
WARNING: drivers/net/netdevsim/fib.c:831 at nsim_fib_event_schedule_work dr=
ivers/net/netdevsim/fib.c:1003 [inline], CPU#1: syz.2.19/5834
WARNING: drivers/net/netdevsim/fib.c:831 at nsim_fib_event_nb+0x1029/0x11d0=
 drivers/net/netdevsim/fib.c:1043, CPU#1: syz.2.19/5834
Modules linked in:
CPU: 1 UID: 0 PID: 5834 Comm: syz.2.19 Not tainted syzkaller #0 PREEMPT(ful=
l)=20
Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS 1.16.2-debian-1.16=
.2-1 04/01/2014
RIP: 0010:nsim_fib6_event_init drivers/net/netdevsim/fib.c:831 [inline]
RIP: 0010:nsim_fib6_prepare_event drivers/net/netdevsim/fib.c:947 [inline]
RIP: 0010:nsim_fib_event_schedule_work drivers/net/netdevsim/fib.c:1003 [in=
line]
RIP: 0010:nsim_fib_event_nb+0x1029/0x11d0 drivers/net/netdevsim/fib.c:1043
Code: eb 0d 4d 89 fd e8 97 75 6e fa be 01 00 00 00 48 89 df e8 aa db 85 fd =
4d 89 ef 4c 8b 6c 24 20 e9 4a f3 ff ff e8 78 75 6e fa 90 <0f> 0b 90 e9 db f=
a ff ff 89 e9 80 e1 07 80 c1 03 38 c1 0f 8c df f0
RSP: 0018:ffffc9000388f030 EFLAGS: 00010293
RAX: ffffffff87596688 RBX: 0000000000000001 RCX: ffff88816f738000
RDX: 0000000000000000 RSI: 0000000000000001 RDI: 0000000000000000
RBP: ffffc9000388f1c0 R08: ffff88816ecf302f R09: 1ffff1102dd9e605
R10: dffffc0000000000 R11: ffffed102dd9e606 R12: dffffc0000000000
R13: 0000000000000001 R14: 0000000000000000 R15: ffff8881be596000
FS:  00007f94438b96c0(0000) GS:ffff8882a8cca000(0000) knlGS:000000000000000=
0
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 00007f94429eb840 CR3: 000000016e632000 CR4: 00000000000006f0
Call Trace:
 <TASK>
 notifier_call_chain+0x1a5/0x3d0 kernel/notifier.c:85
 atomic_notifier_call_chain+0xda/0x180 kernel/notifier.c:223
 call_fib_notifiers+0x31/0x60 net/core/fib_notifier.c:36
 call_fib6_multipath_entry_notifiers+0xf5/0x160 net/ipv6/ip6_fib.c:428
 ip6_route_multipath_add net/ipv6/route.c:5591 [inline]
 inet6_rtm_newroute+0x14f5/0x1a30 net/ipv6/route.c:5713
 rtnetlink_rcv_msg+0x802/0xc00 net/core/rtnetlink.c:7137
 netlink_rcv_skb+0x226/0x4a0 net/netlink/af_netlink.c:2575
 netlink_unicast_kernel net/netlink/af_netlink.c:1338 [inline]
 netlink_unicast+0x7bd/0x940 net/netlink/af_netlink.c:1364
 netlink_sendmsg+0x813/0xb40 net/netlink/af_netlink.c:1919
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
RIP: 0033:0x7f944299e159
Code: ff c3 66 2e 0f 1f 84 00 00 00 00 00 0f 1f 44 00 00 48 89 f8 48 89 f7 =
48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 ff f=
f 73 01 c3 48 c7 c1 e8 ff ff ff f7 d8 64 89 01 48
RSP: 002b:00007f94438b9028 EFLAGS: 00000246 ORIG_RAX: 000000000000002e
RAX: ffffffffffffffda RBX: 00007f9442c25fa0 RCX: 00007f944299e159
RDX: 0000000004000040 RSI: 0000200000000000 RDI: 0000000000000003
RBP: 00007f9442a3506b R08: 0000000000000000 R09: 0000000000000000
R10: 0000000000000000 R11: 0000000000000246 R12: 0000000000000000
R13: 00007f9442c26038 R14: 00007f9442c25fa0 R15: 00007ffdb2cbb968
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

The email will later be sent to:
[davem@davemloft.net dsahern@kernel.org edumazet@kernel.org hengyul@cs.unc.=
edu horms@kernel.org idosch@nvidia.com jiayuan.chen@linux.dev jiayuan.chen@=
shopee.com kuba@kernel.org linux-kernel@vger.kernel.org linux-kselftest@vge=
r.kernel.org netdev@vger.kernel.org pabeni@redhat.com shuah@kernel.org stab=
le@vger.kernel.org]

If the report looks fine to you, reply with:
#syz upstream

If the report is a false positive, reply with
#syz invalid

