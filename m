Received: from mail-io1-f70.google.com (mail-io1-f70.google.com [209.85.166.70])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E61E41D6187
	for <syzbot@lists.linux.dev>; Wed, 26 Nov 2025 04:21:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.70
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764130867; cv=none; b=YjJHpa1XnH55nSEd97RbRWPaNhBH2wvZoFLu3nhVjze9rSNjtC0UVx+K+7XW1pCMoIi0/znugqhZHdHvmCq/aHeC0+drs73u64ee9E9dJ+v61+1TNC8y0iJ/w9mlKballtZ+wINjGiPi5YOZkMBKUtaStwkfbfHZWbegXCzJnYE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764130867; c=relaxed/simple;
	bh=U5C2bROFa+QRqy/GHkD2grOGxXlP4SADhV7Vzi/NjVc=;
	h=MIME-Version:Date:Message-ID:Subject:From:To:Cc:Content-Type; b=WwM75tapqpEcwQ07TS/bvCphvUJj2Kb1dNcOTFSP+GaczccG8z3gdird8yIkwdvJCVO1LGmDMSVXH5/jsrgv+D4RKcDsTahZHq3qwF2KvDD/sYSugx+a8Dv9HBSpDS1GXvllDXn1vUPNf86I3/CSZ54Ankv3glELf3/aNlZt02E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com; arc=none smtp.client-ip=209.85.166.70
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com
Received: by mail-io1-f70.google.com with SMTP id ca18e2360f4ac-9486920a552so506636139f.3
        for <syzbot@lists.linux.dev>; Tue, 25 Nov 2025 20:21:05 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1764130865; x=1764735665;
        h=cc:to:from:subject:message-id:date:mime-version:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=mPzZ5wWhDtc9LdgD6qGCqWnmhaO/tbTelmCBCXqq2ow=;
        b=lHdOdCOlCl8SNmL1Vd0aMfeGgZSonWNrn3oKwyYo88KKpwJnCYI10twuy+IdDqwcnD
         7dlpS6PpKn95A5zYiKY8S38wnve6Am82KYNdCyQlV5DFxNmcx09JEDRicYXZOXznvUQR
         eYYo3Pb08RQ4Bp8KxTvM0hsngIAv7iD+k1O0SNZCjC4fYjHqHn9lmbn8aG7mSZZSH0Kj
         UDUatCNOuUG8Lf6O+OY9O2AyRAkBuJ7TkADABkM1GajUXD17AuYhDpK7bewC0SqjtLb+
         Jj5d9isKAoZ6YSKAwstdymP75tnS7wQ9f2nRvEvhkAnGkecToZ8nV5LYOpTcnLPRESWu
         xTtg==
X-Gm-Message-State: AOJu0YyiDNSpXTCVV09nXmVh7XfkYOcVpqgxokkTpkeTO+hRaJWEbWSQ
	Y5zf8TIHoBME0JNpt4FIZCGTrUY/EG/ro4dR3P0PUnyibCgfjQzXg7oxNHWO/CxhxjIOURo8PgX
	uw2WKX/47jXERAzlvFNy8JjiyH7iNORzVZnQYTLaj37fYtt5Q5/Vc/HL3bLI=
X-Google-Smtp-Source: AGHT+IGgcezoCGFtThr7OFKshaiImmCLd5wVBl1kCybLTB3HNreWs6OHdmQakmUWeFA93K0MO0vuoSWZshJiE4wKB4RuOQdvl4Zq
Precedence: bulk
X-Mailing-List: syzbot@lists.linux.dev
List-Id: <syzbot.lists.linux.dev>
List-Subscribe: <mailto:syzbot+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:syzbot+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Received: by 2002:a05:6e02:178f:b0:435:a462:552 with SMTP id
 e9e14a558f8ab-435dd0e8d19mr41193795ab.19.1764130865030; Tue, 25 Nov 2025
 20:21:05 -0800 (PST)
Date: Tue, 25 Nov 2025 20:21:05 -0800
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <69268031.a70a0220.d98e3.00c9.GAE@google.com>
Subject: [moderation/CI] Re: net/sched: Introduce qdisc quirk_chk op
From: syzbot ci <syzbot+cie1cc744dda2cfc97@syzkaller.appspotmail.com>
To: syzkaller-upstream-moderation@googlegroups.com
Cc: syzbot@lists.linux.dev
Content-Type: text/plain; charset="UTF-8"

syzbot ci has tested the following series

[v2] net/sched: Introduce qdisc quirk_chk op
https://lore.kernel.org/all/20251125224604.872351-1-victor@mojatatu.com
* [RFC PATCH net-next v2] net/sched: Introduce qdisc quirk_chk op

and found the following issue:
general protection fault in netem_quirk_chk

Full report is available here:
https://ci.syzbot.org/series/aa7207e5-00c6-4c9d-b330-9b2041104daf

***

general protection fault in netem_quirk_chk

tree:      net-next
URL:       https://kernel.googlesource.com/pub/scm/linux/kernel/git/netdev/net-next.git
base:      e2c20036a8879476c88002730d8a27f4e3c32d4b
arch:      amd64
compiler:  Debian clang version 20.1.8 (++20250708063551+0c9f909b7976-1~exp1~20250708183702.136), Debian LLD 20.1.8
config:    https://ci.syzbot.org/builds/bbda2e20-2099-41bd-a7d4-c298c61ed2f5/config
C repro:   https://ci.syzbot.org/findings/21f8d5f6-c5af-4e81-a8d5-56f5febd6f03/c_repro
syz repro: https://ci.syzbot.org/findings/21f8d5f6-c5af-4e81-a8d5-56f5febd6f03/syz_repro

netlink: 28 bytes leftover after parsing attributes in process `syz.0.17'.
Oops: general protection fault, probably for non-canonical address 0xdffffc0000000000: 0000 [#1] SMP KASAN PTI
KASAN: null-ptr-deref in range [0x0000000000000000-0x0000000000000007]
CPU: 1 UID: 0 PID: 5961 Comm: syz.0.17 Not tainted syzkaller #0 PREEMPT(full) 
Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS 1.16.2-debian-1.16.2-1 04/01/2014
RIP: 0010:nla_len include/net/netlink.h:1296 [inline]
RIP: 0010:parse_attr net/sched/sch_netem.c:960 [inline]
RIP: 0010:netem_quirk_chk+0x8a/0x740 net/sched/sch_netem.c:990
Code: 7c 24 60 49 c1 ef 03 43 c7 04 27 f1 f1 f1 f1 43 c7 44 27 13 f3 f3 f3 f3 43 c6 44 27 17 f3 e8 8d 68 67 f8 48 89 d8 48 c1 e8 03 <42> 0f b6 04 20 84 c0 0f 85 32 06 00 00 0f b7 03 83 c0 fc 44 0f b7
RSP: 0018:ffffc900032c7140 EFLAGS: 00010246
RAX: 0000000000000000 RBX: 0000000000000000 RCX: ffff88810ff73a00
RDX: 0000000000000000 RSI: 0000000000000000 RDI: ffff8881b82ce000
RBP: ffffc900032c72b8 R08: ffff88810ff73a00 R09: 0000000000000002
R10: 00000000fffffff1 R11: ffffffff89589ab0 R12: dffffc0000000000
R13: ffffffff89589ab0 R14: ffffffff8f7d9580 R15: 1ffff92000658e34
FS:  000055558efa7500(0000) GS:ffff8882a9f35000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 0000200000000100 CR3: 0000000114760000 CR4: 00000000000006f0
Call Trace:
 <TASK>
 qdisc_create+0x73f/0xf10 net/sched/sch_api.c:1319
 __tc_modify_qdisc net/sched/sch_api.c:1765 [inline]
 tc_modify_qdisc+0x1582/0x2140 net/sched/sch_api.c:1829
 rtnetlink_rcv_msg+0x77c/0xb70 net/core/rtnetlink.c:6967
 netlink_rcv_skb+0x208/0x470 net/netlink/af_netlink.c:2550
 netlink_unicast_kernel net/netlink/af_netlink.c:1318 [inline]
 netlink_unicast+0x82f/0x9e0 net/netlink/af_netlink.c:1344
 netlink_sendmsg+0x805/0xb30 net/netlink/af_netlink.c:1894
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
RIP: 0033:0x7f1beb98f749
Code: ff ff c3 66 2e 0f 1f 84 00 00 00 00 00 0f 1f 40 00 48 89 f8 48 89 f7 48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 ff ff 73 01 c3 48 c7 c1 a8 ff ff ff f7 d8 64 89 01 48
RSP: 002b:00007ffd1afcc778 EFLAGS: 00000246 ORIG_RAX: 000000000000002e
RAX: ffffffffffffffda RBX: 00007f1bebbe5fa0 RCX: 00007f1beb98f749
RDX: 0000000000000000 RSI: 0000200000000000 RDI: 0000000000000003
RBP: 00007f1beba13f91 R08: 0000000000000000 R09: 0000000000000000
R10: 0000000000000000 R11: 0000000000000246 R12: 0000000000000000
R13: 00007f1bebbe5fa0 R14: 00007f1bebbe5fa0 R15: 0000000000000003
 </TASK>
Modules linked in:
---[ end trace 0000000000000000 ]---
RIP: 0010:nla_len include/net/netlink.h:1296 [inline]
RIP: 0010:parse_attr net/sched/sch_netem.c:960 [inline]
RIP: 0010:netem_quirk_chk+0x8a/0x740 net/sched/sch_netem.c:990
Code: 7c 24 60 49 c1 ef 03 43 c7 04 27 f1 f1 f1 f1 43 c7 44 27 13 f3 f3 f3 f3 43 c6 44 27 17 f3 e8 8d 68 67 f8 48 89 d8 48 c1 e8 03 <42> 0f b6 04 20 84 c0 0f 85 32 06 00 00 0f b7 03 83 c0 fc 44 0f b7
RSP: 0018:ffffc900032c7140 EFLAGS: 00010246
RAX: 0000000000000000 RBX: 0000000000000000 RCX: ffff88810ff73a00
RDX: 0000000000000000 RSI: 0000000000000000 RDI: ffff8881b82ce000
RBP: ffffc900032c72b8 R08: ffff88810ff73a00 R09: 0000000000000002
R10: 00000000fffffff1 R11: ffffffff89589ab0 R12: dffffc0000000000
R13: ffffffff89589ab0 R14: ffffffff8f7d9580 R15: 1ffff92000658e34
FS:  000055558efa7500(0000) GS:ffff8882a9f35000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 0000200000000100 CR3: 0000000114760000 CR4: 00000000000006f0
----------------
Code disassembly (best guess), 1 bytes skipped:
   0:	24 60                	and    $0x60,%al
   2:	49 c1 ef 03          	shr    $0x3,%r15
   6:	43 c7 04 27 f1 f1 f1 	movl   $0xf1f1f1f1,(%r15,%r12,1)
   d:	f1
   e:	43 c7 44 27 13 f3 f3 	movl   $0xf3f3f3f3,0x13(%r15,%r12,1)
  15:	f3 f3
  17:	43 c6 44 27 17 f3    	movb   $0xf3,0x17(%r15,%r12,1)
  1d:	e8 8d 68 67 f8       	call   0xf86768af
  22:	48 89 d8             	mov    %rbx,%rax
  25:	48 c1 e8 03          	shr    $0x3,%rax
* 29:	42 0f b6 04 20       	movzbl (%rax,%r12,1),%eax <-- trapping instruction
  2e:	84 c0                	test   %al,%al
  30:	0f 85 32 06 00 00    	jne    0x668
  36:	0f b7 03             	movzwl (%rbx),%eax
  39:	83 c0 fc             	add    $0xfffffffc,%eax
  3c:	44                   	rex.R
  3d:	0f                   	.byte 0xf
  3e:	b7                   	.byte 0xb7


***

If these findings have caused you to resend the series or submit a
separate fix, please add the following tag to your commit message:
  Tested-by: syzbot@syzkaller.appspotmail.com

---
This report is generated by a bot. It may contain errors.
syzbot ci engineers can be reached at syzkaller@googlegroups.com.

The email will later be sent to:
[davem@davemloft.net edumazet@google.com horms@kernel.org jhs@mojatatu.com jiri@resnulli.us kuba@kernel.org netdev@vger.kernel.org pabeni@redhat.com stephen@networkplumber.org victor@mojatatu.com xiyou.wangcong@gmail.com]

If the report looks fine to you, reply with:
#syz upstream

