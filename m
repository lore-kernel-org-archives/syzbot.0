Received: from mail-il1-f200.google.com (mail-il1-f200.google.com [209.85.166.200])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 61B342C3272
	for <syzbot@lists.linux.dev>; Wed,  5 Nov 2025 21:31:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.200
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762378290; cv=none; b=DSR0BvM3nLJGyW+lbo6WLkaIE1IW613QACwz1IFWNorzOZqNSIyROSIZSso1i1Dx315auQe54KN4hSLGpkWGjVlUwnIoCvg3LYtLtWhKWYQtvfobzPHUF11AsfteNjz2yyBio3NBWRKJi7OAObmqS/+J1QJCXkV1xWPkS3gG288=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762378290; c=relaxed/simple;
	bh=dZHCC6y1MiAzehrBEEDjASYUXsONQyBdZzo1zE0J7h0=;
	h=MIME-Version:Date:Message-ID:Subject:From:To:Cc:Content-Type; b=JNyx/8ktvQgU3e5/SKrZvTK5EOgoyECOiWSeiGgxGlMm4Hd+WtmqrH19F4jTJLU7IAjbDkInjnTVEXA0ywz2wZtAGCqwvcZ7wa3nI+po2y/n2xv9qisfTPP/5RJnAA9/FZ8k78kor05d5uVV5vFWNQvBzkQtitQvHNsUQrNNl6s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com; arc=none smtp.client-ip=209.85.166.200
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com
Received: by mail-il1-f200.google.com with SMTP id e9e14a558f8ab-4334affe616so3095855ab.2
        for <syzbot@lists.linux.dev>; Wed, 05 Nov 2025 13:31:28 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1762378287; x=1762983087;
        h=cc:to:from:subject:message-id:date:mime-version:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=rzIO63lpOLlOU5Ggze2UpxqDUjZly2goiSABnaUFiKg=;
        b=MzCukgId+uDhjCvHUYQ77oGqZdfUnVhQH80Smfej2UVZfmn9V9irEHicFBDskNCNB0
         LMjwTaC35t84xtQlQEcgRgjY2T1kxhgB7U0mzU/hdvLrJ/JXy88euS7JUQkqkTwcY5nf
         rKsYj0Zvl6oqIGCIdJ6G/4elh+9Q9lEDC2EYnEYBIwNsBOLpNCnZwk5mBG0hrhaauhiz
         ++CFwSX1zCiMelmuxlTIy7Hvc+2ICB6jH2MrtLiCSL8hSdEYxpX0t0Pa3S95LyA/LVSe
         YL7UYV+RHbGHqWQDaBuG6fbyu3cuDUaLe+T0TXJM6MxyKmRY+ytGMmXW3J6mkVuygDzk
         1LrA==
X-Gm-Message-State: AOJu0YxkjQGKo1TeJgvs2KEwlnhetDbKL+oLBW3kymURJXFWiDzNyzbw
	SuGvMXJPBLmNS2BiXfwdqHQSgSiBIKl6hbKAKJZq+v+ArhJObkXyoUliR+y03FCKXAfxHCgUupK
	F5IB5aBPo4yQaiahnawpRqXLaVDJYeOMMjH/AVrQGBDNUL3hTsOcMyARCNp4=
X-Google-Smtp-Source: AGHT+IFxQHxuoGHQaB3aVkeYWIPn0qIpCdhldP6mcz9VRSZ3P6QdOIO/bg0z+QEbKNsdwgs9VQXqyQ8cP37g9nxs9N3KHQu6gh7n
Precedence: bulk
X-Mailing-List: syzbot@lists.linux.dev
List-Id: <syzbot.lists.linux.dev>
List-Subscribe: <mailto:syzbot+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:syzbot+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Received: by 2002:a05:6e02:1888:b0:433:2ebb:71fb with SMTP id
 e9e14a558f8ab-433407bdd46mr63536935ab.18.1762378287483; Wed, 05 Nov 2025
 13:31:27 -0800 (PST)
Date: Wed, 05 Nov 2025 13:31:27 -0800
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <690bc22f.050a0220.baf87.0072.GAE@google.com>
Subject: [moderation/CI] Re: ipvlan: support mac-nat mode
From: syzbot ci <syzbot+cid64ea3db584eba82@syzkaller.appspotmail.com>
To: syzkaller-upstream-moderation@googlegroups.com
Cc: syzbot@lists.linux.dev
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

The email will later be sent to:
[andrew@lunn.ch andrey.bokhanko@huawei.com corbet@lwn.net davem@davemloft.net edumazet@google.com horms@kernel.org kuba@kernel.org linux-doc@vger.kernel.org linux-kernel@vger.kernel.org netdev@vger.kernel.org pabeni@redhat.com skorodumov.dmitry@huawei.com]

If the report looks fine to you, reply with:
#syz upstream

