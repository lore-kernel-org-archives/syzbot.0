Received: from mail-il1-f199.google.com (mail-il1-f199.google.com [209.85.166.199])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 431BB2E540C
	for <syzbot@lists.linux.dev>; Tue, 25 Nov 2025 08:45:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.199
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764060327; cv=none; b=XNICgpPbsu4nkt6lfqpFey1t+jZr1PYjaUUpSGQqc9nlHCoUMgfgc6Que/eOkDQqIo09iwt/jcnvgZoBX0JFj8MOOgqvSoEX8xWtVNaeoWQoJUI7F81AK8a6a005iqXVkWrseKEs3MlaCuF6xVUM+5PCJ1goCaHMFJjB1Kbqgx0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764060327; c=relaxed/simple;
	bh=zI+7hTvfWm6gb1ZiRqSNkpKksBKVctZzR944zS4l59U=;
	h=MIME-Version:Date:In-Reply-To:Message-ID:Subject:From:To:Cc:
	 Content-Type; b=qRVJmIQyF3dZ86SXD1JwSnPkiqLJ8l4VmmUhvjAPund1TLgohmTwR/4IQl63Y2ZUt95e3x1P9/c5wsaYT0q4rqTjBn36Q16QABtf+G+wfsLWhd+6D1cQm/OXIByHXK55NBLZZG2opnfJ+dtEt7G5++7KzeWEJ4v1JWw74U33Pxw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com; arc=none smtp.client-ip=209.85.166.199
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com
Received: by mail-il1-f199.google.com with SMTP id e9e14a558f8ab-43329b607e0so41259345ab.2
        for <syzbot@lists.linux.dev>; Tue, 25 Nov 2025 00:45:25 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1764060324; x=1764665124;
        h=cc:to:from:subject:message-id:in-reply-to:date:mime-version
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=+gVv0v9OI2GeOVZZmoIbI3vSnS/QLWkH/YjxAIOKRiE=;
        b=YbvZdI6Mh93uvzJEL607UrHnMvRZmhI5eYgtR5Pl2gsef2et5crAbAikOzM4iJ0+Fq
         Y+ruvisUXuLk8GfcUqntoCo2na0teRSBIJTdS5DSJu5exP0FuuFcCCgToLfk8lVnhCo7
         dXZW7D98pX+aWXRMhSPJ/YfkAl6ngBVxtNOkuLOlPyyykhpN5QGCCC9+nZFTpbu8BBP1
         sp9pjFSGX0XLdLUmAO9a5iOQmSe3YUGIE4f3WCtPtTklSyz5B3mYKrsXRLSt4xR+H7dq
         6auz9MjMAfEsUskvKzU1uIhC7qcm0IPr/In0JKAqohES1V47pSD3VHj2DMYSudlDIdol
         LE8w==
X-Gm-Message-State: AOJu0YwGd7mjb2Cltl/CEm12e20VjpPgcvmMQ2YNzwqkQW3tmX1osFuX
	x/cpvItidnKidl80NSGQBxKNC27kDWk/4r45izD5RFaBY9AS6F5DKvYs5b6xo5f7fKkdJ/Ztt2y
	HCgOAqW87KF14eyvRDpobx2QkQ0+NldmbYXWx5yJYlqmDvX1OYyiEt2HnaFg=
X-Google-Smtp-Source: AGHT+IE1xbseCNgfszoTJoHXO48RSypQVgoJzDt4pEkIKrykuN/tSP0QipH0rbGVkydwDCwSduPIw+lY6UyupnLwrKWjVF0qv31W
Precedence: bulk
X-Mailing-List: syzbot@lists.linux.dev
List-Id: <syzbot.lists.linux.dev>
List-Subscribe: <mailto:syzbot+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:syzbot+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Received: by 2002:a05:6e02:2681:b0:430:c68c:b2b9 with SMTP id
 e9e14a558f8ab-435b8e694b4mr121319055ab.22.1764060324388; Tue, 25 Nov 2025
 00:45:24 -0800 (PST)
Date: Tue, 25 Nov 2025 00:45:24 -0800
In-Reply-To: <20251124223749.503979-1-victor@mojatatu.com>
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <69256ca4.a70a0220.2ea503.0088.GAE@google.com>
Subject: [syzbot ci] Re: net/sched: Introduce qdisc quirk_chk op
From: syzbot ci <syzbot+ci4f0c6bd07d511716@syzkaller.appspotmail.com>
To: davem@davemloft.net, edumazet@google.com, jhs@mojatatu.com, 
	jiri@resnulli.us, kuba@kernel.org, netdev@vger.kernel.org, pabeni@redhat.com, 
	victor@mojatatu.com, xiyou.wangcong@gmail.com
Cc: syzbot@lists.linux.dev, syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"

syzbot ci has tested the following series

[v1] net/sched: Introduce qdisc quirk_chk op
https://lore.kernel.org/all/20251124223749.503979-1-victor@mojatatu.com
* [RFC PATCH net-next] net/sched: Introduce qdisc quirk_chk op

and found the following issue:
general protection fault in netem_quirk_chk

Full report is available here:
https://ci.syzbot.org/series/0ba1b5b2-32e5-45b5-9ede-1290a7852d5e

***

general protection fault in netem_quirk_chk

tree:      net-next
URL:       https://kernel.googlesource.com/pub/scm/linux/kernel/git/netdev/net-next.git
base:      e2c20036a8879476c88002730d8a27f4e3c32d4b
arch:      amd64
compiler:  Debian clang version 20.1.8 (++20250708063551+0c9f909b7976-1~exp1~20250708183702.136), Debian LLD 20.1.8
config:    https://ci.syzbot.org/builds/0064d8bc-3c48-4267-9b5e-0f43a8514002/config
C repro:   https://ci.syzbot.org/findings/17d4a158-13d5-439e-8a4d-10e6e40a2ab1/c_repro
syz repro: https://ci.syzbot.org/findings/17d4a158-13d5-439e-8a4d-10e6e40a2ab1/syz_repro

netlink: 28 bytes leftover after parsing attributes in process `syz.0.17'.
Oops: general protection fault, probably for non-canonical address 0xdffffc0000000002: 0000 [#1] SMP KASAN PTI
KASAN: null-ptr-deref in range [0x0000000000000010-0x0000000000000017]
CPU: 1 UID: 0 PID: 5959 Comm: syz.0.17 Not tainted syzkaller #0 PREEMPT(full) 
Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS 1.16.2-debian-1.16.2-1 04/01/2014
RIP: 0010:netem_quirk_chk+0x37/0x660 net/sched/sch_netem.c:999
Code: 53 48 83 ec 30 48 89 54 24 08 49 89 f7 48 89 fd 49 be 00 00 00 00 00 fc ff df e8 e4 68 67 f8 49 83 c7 14 4c 89 f8 48 c1 e8 03 <42> 0f b6 04 30 84 c0 0f 85 a0 05 00 00 41 8b 37 31 ff 89 74 24 04
RSP: 0018:ffffc90003737260 EFLAGS: 00010203
RAX: 0000000000000002 RBX: dffffc0000000000 RCX: ffff888113168000
RDX: 0000000000000000 RSI: 0000000000000000 RDI: ffff8881139f3000
RBP: ffff8881139f3000 R08: ffff888113168000 R09: 0000000000000002
R10: 00000000fffffff1 R11: ffffffff89589ab0 R12: ffff8881166a0000
R13: ffffffff89589ab0 R14: dffffc0000000000 R15: 0000000000000014
FS:  0000555559c83500(0000) GS:ffff8882a9f35000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 0000200000000100 CR3: 000000010a1b0000 CR4: 00000000000006f0
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
RIP: 0033:0x7fe6bff8f749
Code: ff ff c3 66 2e 0f 1f 84 00 00 00 00 00 0f 1f 40 00 48 89 f8 48 89 f7 48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 ff ff 73 01 c3 48 c7 c1 a8 ff ff ff f7 d8 64 89 01 48
RSP: 002b:00007fff10f91288 EFLAGS: 00000246 ORIG_RAX: 000000000000002e
RAX: ffffffffffffffda RBX: 00007fe6c01e5fa0 RCX: 00007fe6bff8f749
RDX: 0000000000000000 RSI: 0000200000000000 RDI: 0000000000000003
RBP: 00007fe6c0013f91 R08: 0000000000000000 R09: 0000000000000000
R10: 0000000000000000 R11: 0000000000000246 R12: 0000000000000000
R13: 00007fe6c01e5fa0 R14: 00007fe6c01e5fa0 R15: 0000000000000003
 </TASK>
Modules linked in:
---[ end trace 0000000000000000 ]---
RIP: 0010:netem_quirk_chk+0x37/0x660 net/sched/sch_netem.c:999
Code: 53 48 83 ec 30 48 89 54 24 08 49 89 f7 48 89 fd 49 be 00 00 00 00 00 fc ff df e8 e4 68 67 f8 49 83 c7 14 4c 89 f8 48 c1 e8 03 <42> 0f b6 04 30 84 c0 0f 85 a0 05 00 00 41 8b 37 31 ff 89 74 24 04
RSP: 0018:ffffc90003737260 EFLAGS: 00010203
RAX: 0000000000000002 RBX: dffffc0000000000 RCX: ffff888113168000
RDX: 0000000000000000 RSI: 0000000000000000 RDI: ffff8881139f3000
RBP: ffff8881139f3000 R08: ffff888113168000 R09: 0000000000000002
R10: 00000000fffffff1 R11: ffffffff89589ab0 R12: ffff8881166a0000
R13: ffffffff89589ab0 R14: dffffc0000000000 R15: 0000000000000014
FS:  0000555559c83500(0000) GS:ffff8882a9f35000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 0000200000000100 CR3: 000000010a1b0000 CR4: 00000000000006f0
----------------
Code disassembly (best guess):
   0:	53                   	push   %rbx
   1:	48 83 ec 30          	sub    $0x30,%rsp
   5:	48 89 54 24 08       	mov    %rdx,0x8(%rsp)
   a:	49 89 f7             	mov    %rsi,%r15
   d:	48 89 fd             	mov    %rdi,%rbp
  10:	49 be 00 00 00 00 00 	movabs $0xdffffc0000000000,%r14
  17:	fc ff df
  1a:	e8 e4 68 67 f8       	call   0xf8676903
  1f:	49 83 c7 14          	add    $0x14,%r15
  23:	4c 89 f8             	mov    %r15,%rax
  26:	48 c1 e8 03          	shr    $0x3,%rax
* 2a:	42 0f b6 04 30       	movzbl (%rax,%r14,1),%eax <-- trapping instruction
  2f:	84 c0                	test   %al,%al
  31:	0f 85 a0 05 00 00    	jne    0x5d7
  37:	41 8b 37             	mov    (%r15),%esi
  3a:	31 ff                	xor    %edi,%edi
  3c:	89 74 24 04          	mov    %esi,0x4(%rsp)


***

If these findings have caused you to resend the series or submit a
separate fix, please add the following tag to your commit message:
  Tested-by: syzbot@syzkaller.appspotmail.com

---
This report is generated by a bot. It may contain errors.
syzbot ci engineers can be reached at syzkaller@googlegroups.com.
