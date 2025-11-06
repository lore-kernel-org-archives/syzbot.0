Received: from mail-il1-f197.google.com (mail-il1-f197.google.com [209.85.166.197])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B1CBA309F1A
	for <syzbot@lists.linux.dev>; Thu,  6 Nov 2025 09:03:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.197
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762419800; cv=none; b=NuNsKPA8FOVjTb0QsCwH+K0Jyy7c5IufFZdFWlz9IUvqoRUI9VHD8WxElkETs9/Je2LNZsh/pYJIR71MqU/lFVHND977EdF8QjRkerWvHPMPYkK+qRBZwK5i1nkQWrjAMpik7HjlwWxNHop/EC6NtTlhEfduIHgg5jj4UjYdXG0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762419800; c=relaxed/simple;
	bh=3BiETXl/7KYiMgO2xmY43yE1EckvGSBZswtZukHv/ok=;
	h=MIME-Version:Date:In-Reply-To:Message-ID:Subject:From:To:Cc:
	 Content-Type; b=Va4DdzCxBr+a6R3fkuBKqUnKo9E0dev6Vi8aYMg8dZpYcVZ+9XM+8KPI4KxpeG8d8whzO44/YvAQY+me6eY2WpXJWibr4tjlLOqxoLvyb4iLaIevi4XhvkJ6KkUVsKwvxblCm7nAlwLEe0RNjAaIXI/ufMQjvmjiNRnwiAp1Aqw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com; arc=none smtp.client-ip=209.85.166.197
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com
Received: by mail-il1-f197.google.com with SMTP id e9e14a558f8ab-4335b48ad16so622745ab.2
        for <syzbot@lists.linux.dev>; Thu, 06 Nov 2025 01:03:18 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1762419798; x=1763024598;
        h=cc:to:from:subject:message-id:in-reply-to:date:mime-version
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=NM+vtYwd4Q/5mXYOusRezwQD6kU0yTjiwGI1zHoa56s=;
        b=wFoNVyuLixWq5MoCwM4pqVceeN/pUlHVHuSweashgFfnfr3BhaVPTKde8eWhM9e2IH
         2uRCcBOSOWg2KjaOZVI9aYIBCsTcX8o9zhAg32lM3gDqsnMRpJXq5nzn3Ubh4yBHsFX2
         R0s5sAlFleUwh1glpauzBjtIcw0XXbpBhznJ1OP0AlCjuuDDaSbjmLaUPPFF/pTl3bUS
         l3ETYuzaQMfBBtvUL4a2ME9yGHpOaWJ4swNrvzg95lN8oeDco2+3YReEx7sKUZBF1R3T
         GX4PzN08N94xWgS64/ScucYyBNgICRsiz+NJIkdcCW8ehZ9MYYpjYmNXrn+PbKOqjd0F
         gluw==
X-Gm-Message-State: AOJu0YyAem6dy/QRLfYEEZackJPOToibTeyLG40nbdDBuuWbgqzJqkYK
	UNWj5LG4F+6UDmhsrrYAKkh1F0ekHkw+Zkop+YpQnQBx6JZ+iYNqfG1PRFHsODljtrbs7YT4GrO
	JRSrcsBybaucuH1xgq09wD/wDZc4Qs6Ftk2arDMkirbCG9ACuaZPJmOqh414=
X-Google-Smtp-Source: AGHT+IHYw6BpNjU970LvwCOmCC6rnyZOB0LxuLx4sUOzoknP7LuxVppDcrNAehHNomEHUHqlUyTcseQg9qNPR0QWUuXPYjfjkyEz
Precedence: bulk
X-Mailing-List: syzbot@lists.linux.dev
List-Id: <syzbot.lists.linux.dev>
List-Subscribe: <mailto:syzbot+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:syzbot+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Received: by 2002:a05:6e02:1c08:b0:433:2cdf:6457 with SMTP id
 e9e14a558f8ab-4334079054fmr85278665ab.12.1762419797969; Thu, 06 Nov 2025
 01:03:17 -0800 (PST)
Date: Thu, 06 Nov 2025 01:03:17 -0800
In-Reply-To: <20251105161450.1730216-1-skorodumov.dmitry@huawei.com>
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <690c6455.050a0220.3d0d33.0119.GAE@google.com>
Subject: [syzbot ci] Re: ipvlan: support mac-nat mode
From: syzbot ci <syzbot+cia97091be86436383@syzkaller.appspotmail.com>
To: andrew@lunn.ch, andrey.bokhanko@huawei.com, corbet@lwn.net, 
	davem@davemloft.net, edumazet@google.com, horms@kernel.org, kuba@kernel.org, 
	linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org, 
	netdev@vger.kernel.org, pabeni@redhat.com, skorodumov.dmitry@huawei.com
Cc: syzbot@lists.linux.dev, syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"

syzbot ci has tested the following series

[v3] ipvlan: support mac-nat mode
https://lore.kernel.org/all/20251105161450.1730216-1-skorodumov.dmitry@huawei.com
* [PATCH net-next 01/14] ipvlan: Preparation to support mac-nat
* [PATCH net-next 02/14] ipvlan: Send mcasts out directly in ipvlan_xmit_mode_l2()
* [PATCH net-next 03/14] ipvlan: Handle rx mcast-ip and unicast eth
* [PATCH net-next 04/14] ipvlan: Added some kind of MAC NAT
* [PATCH net-next 05/14] ipvlan: Forget all IP when device goes down
* [PATCH net-next 06/14] ipvlan: Support GSO for port -> ipvlan
* [PATCH net-next 07/14] ipvlan: Support IPv6 for learnable l2-bridge
* [PATCH net-next 08/14] ipvlan: Make the addrs_lock be per port
* [PATCH net-next 09/14] ipvlan: Take addr_lock in ipvlan_open()
* [PATCH net-next 10/14] ipvlan: Don't allow children to use IPs of main
* [PATCH net-next 11/14] ipvlan: const-specifier for functions that use iaddr
* [PATCH net-next 12/14] ipvlan: Common code from v6/v4 validator_event
* [PATCH net-next 13/14] ipvlan: common code to handle ipv6/ipv4 address events
* [PATCH net-next 14/14] ipvlan: Ignore PACKET_LOOPBACK in handle_mode_l2()

and found the following issue:
WARNING: suspicious RCU usage in ipvlan_init

Full report is available here:
https://ci.syzbot.org/series/349ca33e-4ae2-4720-9a69-17a2a9e17107

***

WARNING: suspicious RCU usage in ipvlan_init

tree:      net-next
URL:       https://kernel.googlesource.com/pub/scm/linux/kernel/git/netdev/net-next.git
base:      01cc760632b875c4ad0d8fec0b0c01896b8a36d4
arch:      amd64
compiler:  Debian clang version 20.1.8 (++20250708063551+0c9f909b7976-1~exp1~20250708183702.136), Debian LLD 20.1.8
config:    https://ci.syzbot.org/builds/d6598a0d-2fcb-499d-95fc-30c5096555dc/config

batman_adv: batadv0: Not using interface batadv_slave_1 (retrying later): interface not active
hsr_slave_0: entered promiscuous mode
hsr_slave_1: entered promiscuous mode
=============================
WARNING: suspicious RCU usage
syzkaller #0 Not tainted
-----------------------------
./include/linux/inetdevice.h:239 suspicious rcu_dereference_check() usage!

other info that might help us debug this:


rcu_scheduler_active = 2, debug_locks = 1
2 locks held by syz-executor/6496:
 #0: ffffffff8ea2f980 (&ops->srcu#2){.+.+}-{0:0}, at: rtnl_link_ops_get+0x23/0x250
 #1: ffffffff8f2cb3c8 (rtnl_mutex){+.+.}-{4:4}, at: rtnl_newlink+0x8e9/0x1c80

stack backtrace:
CPU: 1 UID: 0 PID: 6496 Comm: syz-executor Not tainted syzkaller #0 PREEMPT(full) 
Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS 1.16.2-debian-1.16.2-1 04/01/2014
Call Trace:
 <TASK>
 dump_stack_lvl+0x189/0x250
 lockdep_rcu_suspicious+0x140/0x1d0
 ipvlan_init+0xff2/0x1260
 register_netdevice+0x6bf/0x1ae0
 ipvlan_link_new+0x57a/0xc70
 rtnl_newlink_create+0x310/0xb00
 rtnl_newlink+0x16e4/0x1c80
 rtnetlink_rcv_msg+0x7cf/0xb70
 netlink_rcv_skb+0x208/0x470
 netlink_unicast+0x82f/0x9e0
 netlink_sendmsg+0x805/0xb30
 __sock_sendmsg+0x21c/0x270
 __sys_sendto+0x3bd/0x520
 __x64_sys_sendto+0xde/0x100
 do_syscall_64+0xfa/0xfa0
 entry_SYSCALL_64_after_hwframe+0x77/0x7f
RIP: 0033:0x7f114c590e03
Code: 64 89 02 48 c7 c0 ff ff ff ff eb b7 66 2e 0f 1f 84 00 00 00 00 00 90 80 3d 61 77 22 00 00 41 89 ca 74 14 b8 2c 00 00 00 0f 05 <48> 3d 00 f0 ff ff 77 75 c3 0f 1f 40 00 55 48 83 ec 30 44 89 4c 24
RSP: 002b:00007ffecaf08958 EFLAGS: 00000202 ORIG_RAX: 000000000000002c
RAX: ffffffffffffffda RBX: 00007f114d314620 RCX: 00007f114c590e03
RDX: 0000000000000058 RSI: 00007f114d314670 RDI: 0000000000000003
RBP: 0000000000000001 R08: 00007ffecaf08974 R09: 000000000000000c
R10: 0000000000000000 R11: 0000000000000202 R12: 0000000000000003
R13: 0000000000000000 R14: 00007f114d314670 R15: 0000000000000000
 </TASK>

=============================
WARNING: suspicious RCU usage
syzkaller #0 Not tainted
-----------------------------
drivers/net/ipvlan/ipvlan_main.c:238 suspicious rcu_dereference_check() usage!

other info that might help us debug this:


rcu_scheduler_active = 2, debug_locks = 1
2 locks held by syz-executor/6496:
 #0: ffffffff8ea2f980 (&ops->srcu#2){.+.+}-{0:0}, at: rtnl_link_ops_get+0x23/0x250
 #1: ffffffff8f2cb3c8 (rtnl_mutex){+.+.}-{4:4}, at: rtnl_newlink+0x8e9/0x1c80

stack backtrace:
CPU: 0 UID: 0 PID: 6496 Comm: syz-executor Not tainted syzkaller #0 PREEMPT(full) 
Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS 1.16.2-debian-1.16.2-1 04/01/2014
Call Trace:
 <TASK>
 dump_stack_lvl+0x189/0x250
 lockdep_rcu_suspicious+0x140/0x1d0
 ipvlan_init+0x1025/0x1260
 register_netdevice+0x6bf/0x1ae0
 ipvlan_link_new+0x57a/0xc70
 rtnl_newlink_create+0x310/0xb00
 rtnl_newlink+0x16e4/0x1c80
 rtnetlink_rcv_msg+0x7cf/0xb70
 netlink_rcv_skb+0x208/0x470
 netlink_unicast+0x82f/0x9e0
 netlink_sendmsg+0x805/0xb30
 __sock_sendmsg+0x21c/0x270
 __sys_sendto+0x3bd/0x520
 __x64_sys_sendto+0xde/0x100
 do_syscall_64+0xfa/0xfa0
 entry_SYSCALL_64_after_hwframe+0x77/0x7f
RIP: 0033:0x7f114c590e03
Code: 64 89 02 48 c7 c0 ff ff ff ff eb b7 66 2e 0f 1f 84 00 00 00 00 00 90 80 3d 61 77 22 00 00 41 89 ca 74 14 b8 2c 00 00 00 0f 05 <48> 3d 00 f0 ff ff 77 75 c3 0f 1f 40 00 55 48 83 ec 30 44 89 4c 24
RSP: 002b:00007ffecaf08958 EFLAGS: 00000202 ORIG_RAX: 000000000000002c
RAX: ffffffffffffffda RBX: 00007f114d314620 RCX: 00007f114c590e03
RDX: 0000000000000058 RSI: 00007f114d314670 RDI: 0000000000000003
RBP: 0000000000000001 R08: 00007ffecaf08974 R09: 000000000000000c
R10: 0000000000000000 R11: 0000000000000202 R12: 0000000000000003
R13: 0000000000000000 R14: 00007f114d314670 R15: 0000000000000000
 </TASK>


***

If these findings have caused you to resend the series or submit a
separate fix, please add the following tag to your commit message:
  Tested-by: syzbot@syzkaller.appspotmail.com

---
This report is generated by a bot. It may contain errors.
syzbot ci engineers can be reached at syzkaller@googlegroups.com.
