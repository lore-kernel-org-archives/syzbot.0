Received: from mail-il1-f200.google.com (mail-il1-f200.google.com [209.85.166.200])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AE87B158DA3
	for <syzbot@lists.linux.dev>; Thu, 13 Nov 2025 13:36:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.200
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763041011; cv=none; b=G48wkNCNkzIDTvbFWW/R1bv3c/UJU3CoGxr+MkZbl+6iWfWM1evYjijKsuDMfmVs03VjWJG30Pfugx9rB38GTaMpHxAFUAabAUxHVHU/5U6pRyMIgNSaaZKsJdctF1RB4wdc4m+aPmpy2NjFQ1YZwOFEY/3j//NvZbE5lORaTaY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763041011; c=relaxed/simple;
	bh=MFt9zrCqWJgCRHQFFdo6aN+ULiVY5hEaI4RIOvZZcj0=;
	h=MIME-Version:Date:Message-ID:Subject:From:To:Cc:Content-Type; b=pC4+rQrxeRw6l+7+C/joer3+zP4Gh54lPvV+L2nokxouAqcsG0S/TFwG6+pxRLiVclukqB81Rx7PDdVkTqerBTZZ6wM9YN8aHns6CwlzxeUY6N+diPFYTHOTIAo/KbMn6lpEIMHyHOsSmYf7wPp1QR0BKLJqCLZssv2Ve4ghVa8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com; arc=none smtp.client-ip=209.85.166.200
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com
Received: by mail-il1-f200.google.com with SMTP id e9e14a558f8ab-433770ba913so10553835ab.1
        for <syzbot@lists.linux.dev>; Thu, 13 Nov 2025 05:36:49 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1763041009; x=1763645809;
        h=content-transfer-encoding:cc:to:from:subject:message-id:date
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=ZIRuJHSd5qWue7EddDOGxkDclJN+7gp6hU3BpKskBUY=;
        b=N1gSJROBlK7ryg/xERk+uthJfvh9vJfxkJuWSXNf2cSGW+hJOl6PhF/TD79iwLhy6o
         6YRhh0Tct1quYaOVWPuYLcWdcEtoBW7em9V88Pjs4Kl7g3X4mrbtSUYJpC6zv7YHp99z
         vJ9UXiZxE6RLgv0Ht3Ouiqs9fxjnKhO6pJgTmm/8C3MR5Ym8d8EeK25VlDGK6FtfwPzT
         SQ27+fzvLcLYGqmPk1C0NwGHuaDtdhv+gceoU5LBgb3GxR6DSEqDgF8HgEoq0AJYKqkn
         gcJM0PNi7j+3EnN3Z7I6nJ6Nb05TPMp96p7kGS3zs7ONhvYoblVmk0RE4yjNv90AQ9D5
         G7/w==
X-Gm-Message-State: AOJu0YzZDlp+0SC+pot/RoPHRZmX/1AFeO76GopfZeZY2nqjaMtfkWZ8
	5UL26Apq+GkP9GgLiFXHhnspNChEO/sCBTTtTOSdw06Ddhs3zWb6hsoCPDkm4y6unJisFezWSPM
	BttFDgt8/8qJvNAL+MWQJA2kiTd6Y9vPIzF7cMXQfL4pTip9iCaFcypOL/Io=
X-Google-Smtp-Source: AGHT+IGJq0jSamPpACtxoBXd/t+TVItV9gM5s6klwHveKLshNsjkwLtW/q3vHuUNF6dwLSKnLsJcDpUOoMLxCjOxybMxQL0ZY5Cb
Precedence: bulk
X-Mailing-List: syzbot@lists.linux.dev
List-Id: <syzbot.lists.linux.dev>
List-Subscribe: <mailto:syzbot+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:syzbot+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Received: by 2002:a05:6e02:3790:b0:433:68f0:bdbd with SMTP id
 e9e14a558f8ab-43473ddd7c2mr87632885ab.29.1763041008873; Thu, 13 Nov 2025
 05:36:48 -0800 (PST)
Date: Thu, 13 Nov 2025 05:36:48 -0800
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <6915def0.a70a0220.3124cb.0027.GAE@google.com>
Subject: [moderation/CI] Re: netfilter: nfnetlink_queue: optimize verdict
 lookup with hash table
From: syzbot ci <syzbot+cia78fa5f55802723c@syzkaller.appspotmail.com>
To: syzkaller-upstream-moderation@googlegroups.com
Cc: syzbot@lists.linux.dev
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

syzbot ci has tested the following series

[v2] netfilter: nfnetlink_queue: optimize verdict lookup with hash table
https://lore.kernel.org/all/20251113092606.91406-1-scott_mitchell@apple.com
* [PATCH v2] netfilter: nfnetlink_queue: optimize verdict lookup with hash =
table

and found the following issue:
BUG: sleeping function called from invalid context in instance_create

Full report is available here:
https://ci.syzbot.org/series/001a6a6c-7e1b-46e8-995d-5b6d650af320

***

BUG: sleeping function called from invalid context in instance_create

tree:      nf-next
URL:       https://kernel.googlesource.com/pub/scm/linux/kernel/git/netfilt=
er/nf-next.git
base:      0d0eb186421d0886ac466008235f6d9eedaf918e
arch:      amd64
compiler:  Debian clang version 20.1.8 (++20250708063551+0c9f909b7976-1~exp=
1~20250708183702.136), Debian LLD 20.1.8
config:    https://ci.syzbot.org/builds/69a4254b-f4aa-45a7-a4bd-2d23940887f=
3/config
C repro:   https://ci.syzbot.org/findings/8074062c-0aee-4734-a3d1-587b80676=
bf1/c_repro
syz repro: https://ci.syzbot.org/findings/8074062c-0aee-4734-a3d1-587b80676=
bf1/syz_repro

netlink: 'syz.0.17': attribute type 6 has an invalid length.
BUG: sleeping function called from invalid context at ./include/linux/sched=
/mm.h:321
in_atomic(): 1, irqs_disabled(): 0, non_block: 0, pid: 5968, name: syz.0.17
preempt_count: 1, expected: 0
RCU nest depth: 1, expected: 0
3 locks held by syz.0.17/5968:
 #0: ffffffff99cc1c30 (nfnl_subsys_queue){+.+.}-{4:4}, at: nfnl_lock net/ne=
tfilter/nfnetlink.c:98 [inline]
 #0: ffffffff99cc1c30 (nfnl_subsys_queue){+.+.}-{4:4}, at: nfnetlink_rcv_ms=
g+0x9dc/0x1130 net/netfilter/nfnetlink.c:295
 #1: ffffffff8df3d2e0 (rcu_read_lock){....}-{1:3}, at: rcu_lock_acquire inc=
lude/linux/rcupdate.h:331 [inline]
 #1: ffffffff8df3d2e0 (rcu_read_lock){....}-{1:3}, at: rcu_read_lock includ=
e/linux/rcupdate.h:867 [inline]
 #1: ffffffff8df3d2e0 (rcu_read_lock){....}-{1:3}, at: nfqnl_recv_config+0x=
222/0xf90 net/netfilter/nfnetlink_queue.c:1653
 #2: ffff888112297d18 (&q->instances_lock){+.+.}-{3:3}, at: spin_lock inclu=
de/linux/spinlock.h:351 [inline]
 #2: ffff888112297d18 (&q->instances_lock){+.+.}-{3:3}, at: instance_create=
+0x121/0x740 net/netfilter/nfnetlink_queue.c:206
Preemption disabled at:
[<0000000000000000>] 0x0
CPU: 1 UID: 0 PID: 5968 Comm: syz.0.17 Not tainted syzkaller #0 PREEMPT(ful=
l)=20
Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS 1.16.2-debian-1.16=
.2-1 04/01/2014
Call Trace:
 <TASK>
 dump_stack_lvl+0x189/0x250 lib/dump_stack.c:120
 __might_resched+0x495/0x610 kernel/sched/core.c:8927
 might_alloc include/linux/sched/mm.h:321 [inline]
 slab_pre_alloc_hook mm/slub.c:4913 [inline]
 slab_alloc_node mm/slub.c:5248 [inline]
 __do_kmalloc_node mm/slub.c:5633 [inline]
 __kvmalloc_node_noprof+0x149/0x910 mm/slub.c:7089
 kvmalloc_array_node_noprof include/linux/slab.h:1122 [inline]
 instance_create+0x203/0x740 net/netfilter/nfnetlink_queue.c:218
 nfqnl_recv_config+0x660/0xf90 net/netfilter/nfnetlink_queue.c:1667
 nfnetlink_rcv_msg+0xb4d/0x1130 net/netfilter/nfnetlink.c:302
 netlink_rcv_skb+0x208/0x470 net/netlink/af_netlink.c:2550
 nfnetlink_rcv+0x282/0x2590 net/netfilter/nfnetlink.c:669
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
RIP: 0033:0x7f7a65f8f6c9
Code: ff ff c3 66 2e 0f 1f 84 00 00 00 00 00 0f 1f 40 00 48 89 f8 48 89 f7 =
48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 ff f=
f 73 01 c3 48 c7 c1 a8 ff ff ff f7 d8 64 89 01 48
RSP: 002b:00007ffde4361588 EFLAGS: 00000246 ORIG_RAX: 000000000000002e
RAX: ffffffffffffffda RBX: 00007f7a661e5fa0 RCX: 00007f7a65f8f6c9
RDX: 0000000000008010 RSI: 00002000000000c0 RDI: 0000000000000003
RBP: 00007f7a66011f91 R08: 0000000000000000 R09: 0000000000000000
R10: 0000000000000000 R11: 0000000000000246 R12: 0000000000000000
R13: 00007f7a661e5fa0 R14: 00007f7a661e5fa0 R15: 0000000000000003
 </TASK>


***

If these findings have caused you to resend the series or submit a
separate fix, please add the following tag to your commit message:
  Tested-by: syzbot@syzkaller.appspotmail.com

---
This report is generated by a bot. It may contain errors.
syzbot ci engineers can be reached at syzkaller@googlegroups.com.

The email will later be sent to:
[coreteam@netfilter.org davem@davemloft.net edumazet@google.com fw@strlen.d=
e horms@kernel.org kadlec@netfilter.org kuba@kernel.org linux-kernel@vger.k=
ernel.org netdev@vger.kernel.org netfilter-devel@vger.kernel.org pabeni@red=
hat.com pablo@netfilter.org phil@nwl.cc scott.k.mitch1@gmail.com scott_mitc=
hell@apple.com]

If the report looks fine to you, reply with:
#syz upstream

