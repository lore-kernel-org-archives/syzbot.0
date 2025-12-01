Received: from mail-il1-f198.google.com (mail-il1-f198.google.com [209.85.166.198])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A3EA92032D
	for <syzbot@lists.linux.dev>; Mon,  1 Dec 2025 00:43:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.198
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764549792; cv=none; b=VagPmYgVihO3FISVUlMUr08eKCoHeRADKzkUSaFk8CpFZip4pqTaTrv7h/szkghoqosxhs/AdV2z4+gM/9iHC6cbS/cmzn/M3m6nPgvhcWHDtVAyK4qGe34tDUS4Y0PAtEo67YDepres4kFtmBa/oSevGrJmkn0HQTqXHilPViI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764549792; c=relaxed/simple;
	bh=OfonqANNDfjrcZ39PYwLRZo5MDQkU3q71u43KlEmkbg=;
	h=MIME-Version:Date:Message-ID:Subject:From:To:Cc:Content-Type; b=Sorv8u9ZOUwoIj2R0bHeti9yHDwk4oFUkQuj6lqaiy1HY3rvOoqH3UNCIgy2cm6UcsZS6eKSznXaWUohJxe8FnWABZfLr2lMFbs89716xLczAjRzZ03oIwemWScxX0+hR+rd/e4/LPNvGS6zdpy8NYxwMyqGUjhMWAUJ/uDINgw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com; arc=none smtp.client-ip=209.85.166.198
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com
Received: by mail-il1-f198.google.com with SMTP id e9e14a558f8ab-43300f41682so22742825ab.1
        for <syzbot@lists.linux.dev>; Sun, 30 Nov 2025 16:43:09 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1764549789; x=1765154589;
        h=cc:to:from:subject:message-id:date:mime-version:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=yNQFxc9Ss+4rqrcBp6y+RRW36ZBhpN1V5ZYEiLRbQyY=;
        b=pxpJk7Ci+iXZ8frgyg7BGa0GmLLKOEh6Y/sbB5i1Rcx4BrQaoPtwA+uw/H5sQYTWYZ
         DJS9pPJ6HZZ0J9IGXIWgAYffm/LEcKXYbDdly/dS6SZ5YL4CIq3cDTLejK2b787wyM80
         VrEAUUqoVc+SFQyez80A/nbeBlwmeJvUpNY9XnWeNYPCSziobcGeC84aJyS/9xzpUQwK
         yqCtN08y0JctoDi70SdZBk4i4no1pjIFtbAonbOxay+xPsH6v95Tvq6dmvyyRhwGvJjF
         hg5OuId4HXXDml6Q6sD+oNOBFVWAvYJEsgSbdTZWGVeKZs1rkUyLFnnwKf6SYHn6MEfT
         Gf7w==
X-Gm-Message-State: AOJu0YyhvURKiqpWkhnUpNugq7m8Q18drnn7ohfMvwLuM1lGxVN+Qti6
	MyaLJVXzgVzkT0WS1qwz0nLq943D6qxz3FecOfpsMunFrCXIRWo1hOp6R1e1FFYct1w0jut2vbE
	H1vIEIVATkdcjh9Hf6zdVeP3BqprDKT/J3UP/sc8+k7656Ii684UZNv56TVA=
X-Google-Smtp-Source: AGHT+IENkZ+wQAA0hW/bzaygAOUoqjOB3YHVGermmffUmyKIeCUhAiCOUM/o1nU2nAhdhdIE50J8fUAfZ4jWhStCHEdvcDgiQ/MA
Precedence: bulk
X-Mailing-List: syzbot@lists.linux.dev
List-Id: <syzbot.lists.linux.dev>
List-Subscribe: <mailto:syzbot+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:syzbot+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Received: by 2002:a05:6e02:1749:b0:433:7cf7:14ce with SMTP id
 e9e14a558f8ab-435b986a858mr291882265ab.11.1764549788741; Sun, 30 Nov 2025
 16:43:08 -0800 (PST)
Date: Sun, 30 Nov 2025 16:43:08 -0800
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <692ce49c.a70a0220.2ea503.00aa.GAE@google.com>
Subject: [moderation/CI] Re: Multi-queue aware sch_cake
From: syzbot ci <syzbot+ci17459ab283a71134@syzkaller.appspotmail.com>
To: syzkaller-upstream-moderation@googlegroups.com
Cc: syzbot@lists.linux.dev
Content-Type: text/plain; charset="UTF-8"

syzbot ci has tested the following series

[v3] Multi-queue aware sch_cake
https://lore.kernel.org/all/20251130-mq-cake-sub-qdisc-v3-0-5f66c548ecdc@redhat.com
* [PATCH net-next v3 1/5] net/sched: Export mq functions for reuse
* [PATCH net-next v3 2/5] net/sched: sch_cake: Factor out config variables into separate struct
* [PATCH net-next v3 3/5] net/sched: sch_cake: Add cake_mq qdisc for using cake on mq devices
* [PATCH net-next v3 4/5] net/sched: sch_cake: Share config across cake_mq sub-qdiscs
* [PATCH net-next v3 5/5] net/sched: sch_cake: share shaper state across sub-instances of cake_mq

and found the following issue:
general protection fault in cake_destroy

Full report is available here:
https://ci.syzbot.org/series/469dbe1a-fdda-4481-ae02-4a1ec685d27e

***

general protection fault in cake_destroy

tree:      net-next
URL:       https://kernel.googlesource.com/pub/scm/linux/kernel/git/netdev/net-next.git
base:      db4029859d6fd03f0622d394f4cdb1be86d7ec62
arch:      amd64
compiler:  Debian clang version 20.1.8 (++20250708063551+0c9f909b7976-1~exp1~20250708183702.136), Debian LLD 20.1.8
config:    https://ci.syzbot.org/builds/e4777953-23df-407f-8d5c-6b069ad52321/config
C repro:   https://ci.syzbot.org/findings/c250604b-a027-4732-9850-88499503b6a4/c_repro
syz repro: https://ci.syzbot.org/findings/c250604b-a027-4732-9850-88499503b6a4/syz_repro

netlink: 'syz.0.17': attribute type 9 has an invalid length.
Oops: general protection fault, probably for non-canonical address 0xdffffc0000000006: 0000 [#1] SMP KASAN PTI
KASAN: null-ptr-deref in range [0x0000000000000030-0x0000000000000037]
CPU: 1 UID: 0 PID: 5958 Comm: syz.0.17 Not tainted syzkaller #0 PREEMPT(full) 
Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS 1.16.2-debian-1.16.2-1 04/01/2014
RIP: 0010:cake_destroy+0x9f/0x100 net/sched/sch_cake.c:2790
Code: 81 c3 98 02 00 00 48 89 d8 48 c1 e8 03 42 80 3c 38 00 74 08 48 89 df e8 bf 0f c8 f8 48 8b 1b 4c 8d 73 34 4c 89 f0 48 c1 e8 03 <42> 0f b6 04 38 84 c0 75 35 41 0f b6 2e 31 ff 89 ee e8 eb 4e 62 f8
RSP: 0018:ffffc90003247298 EFLAGS: 00010207
RAX: 0000000000000006 RBX: 0000000000000000 RCX: 13d577b5b867bd00
RDX: 0000000000000000 RSI: ffffffff8bbf08c0 RDI: ffffffff8bbf0880
RBP: ffffc90003247410 R08: ffffc9000324727f R09: 0000000000000000
R10: ffffc90003247260 R11: fffff52000648e50 R12: ffffffff895db710
R13: 00000000ffffffde R14: 0000000000000034 R15: dffffc0000000000
FS:  000055555e5bf500(0000) GS:ffff8882a9f31000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 000055555e5bf808 CR3: 00000001bb50a000 CR4: 00000000000006f0
Call Trace:
 <TASK>
 qdisc_create+0xaa3/0xea0 net/sched/sch_api.c:1353
 __tc_modify_qdisc net/sched/sch_api.c:1753 [inline]
 tc_modify_qdisc+0x1547/0x2020 net/sched/sch_api.c:1817
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
RIP: 0033:0x7ff769b8f7c9
Code: ff ff c3 66 2e 0f 1f 84 00 00 00 00 00 0f 1f 40 00 48 89 f8 48 89 f7 48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 ff ff 73 01 c3 48 c7 c1 a8 ff ff ff f7 d8 64 89 01 48
RSP: 002b:00007ffd59035098 EFLAGS: 00000246 ORIG_RAX: 000000000000002e
RAX: ffffffffffffffda RBX: 00007ff769de5fa0 RCX: 00007ff769b8f7c9
RDX: 0000000000000000 RSI: 0000200000000000 RDI: 0000000000000003
RBP: 00007ff769bf297f R08: 0000000000000000 R09: 0000000000000000
R10: 0000000000000000 R11: 0000000000000246 R12: 0000000000000000
R13: 00007ff769de5fa0 R14: 00007ff769de5fa0 R15: 0000000000000003
 </TASK>
Modules linked in:
---[ end trace 0000000000000000 ]---
RIP: 0010:cake_destroy+0x9f/0x100 net/sched/sch_cake.c:2790
Code: 81 c3 98 02 00 00 48 89 d8 48 c1 e8 03 42 80 3c 38 00 74 08 48 89 df e8 bf 0f c8 f8 48 8b 1b 4c 8d 73 34 4c 89 f0 48 c1 e8 03 <42> 0f b6 04 38 84 c0 75 35 41 0f b6 2e 31 ff 89 ee e8 eb 4e 62 f8
RSP: 0018:ffffc90003247298 EFLAGS: 00010207
RAX: 0000000000000006 RBX: 0000000000000000 RCX: 13d577b5b867bd00
RDX: 0000000000000000 RSI: ffffffff8bbf08c0 RDI: ffffffff8bbf0880
RBP: ffffc90003247410 R08: ffffc9000324727f R09: 0000000000000000
R10: ffffc90003247260 R11: fffff52000648e50 R12: ffffffff895db710
R13: 00000000ffffffde R14: 0000000000000034 R15: dffffc0000000000
FS:  000055555e5bf500(0000) GS:ffff8882a9f31000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 000055555e5bf808 CR3: 00000001bb50a000 CR4: 00000000000006f0
----------------
Code disassembly (best guess):
   0:	81 c3 98 02 00 00    	add    $0x298,%ebx
   6:	48 89 d8             	mov    %rbx,%rax
   9:	48 c1 e8 03          	shr    $0x3,%rax
   d:	42 80 3c 38 00       	cmpb   $0x0,(%rax,%r15,1)
  12:	74 08                	je     0x1c
  14:	48 89 df             	mov    %rbx,%rdi
  17:	e8 bf 0f c8 f8       	call   0xf8c80fdb
  1c:	48 8b 1b             	mov    (%rbx),%rbx
  1f:	4c 8d 73 34          	lea    0x34(%rbx),%r14
  23:	4c 89 f0             	mov    %r14,%rax
  26:	48 c1 e8 03          	shr    $0x3,%rax
* 2a:	42 0f b6 04 38       	movzbl (%rax,%r15,1),%eax <-- trapping instruction
  2f:	84 c0                	test   %al,%al
  31:	75 35                	jne    0x68
  33:	41 0f b6 2e          	movzbl (%r14),%ebp
  37:	31 ff                	xor    %edi,%edi
  39:	89 ee                	mov    %ebp,%esi
  3b:	e8 eb 4e 62 f8       	call   0xf8624f2b


***

If these findings have caused you to resend the series or submit a
separate fix, please add the following tag to your commit message:
  Tested-by: syzbot@syzkaller.appspotmail.com

---
This report is generated by a bot. It may contain errors.
syzbot ci engineers can be reached at syzkaller@googlegroups.com.

The email will later be sent to:
[cake@lists.bufferbloat.net davem@davemloft.net edumazet@google.com horms@kernel.org j.koeppeler@tu-berlin.de jhs@mojatatu.com jiri@resnulli.us kuba@kernel.org netdev@vger.kernel.org pabeni@redhat.com toke@redhat.com toke@toke.dk xiyou.wangcong@gmail.com]

If the report looks fine to you, reply with:
#syz upstream

