Received: from mail-io1-f72.google.com (mail-io1-f72.google.com [209.85.166.72])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C955127FD7C
	for <syzbot@lists.linux.dev>; Wed, 26 Nov 2025 08:16:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.72
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764144975; cv=none; b=pPtZvWFYH6m+NmZYWWl9+7yfeKhD8efToilbJ2I3eC53AckiKLUIuHX+a3KtlixniAHdwB4FHB6G1+Rw07EOMaeLoQ442S01aiRFV4BsyxeYls921RmL8AyzObVuNh9DlW/H2HyOSIvKWgUDlTUMDZCSw9KLGGil2UPxCSFGd70=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764144975; c=relaxed/simple;
	bh=paGpx1Oa8J+Ki16wybCrw0vFUSnFc3+ZWphHQ1j872g=;
	h=MIME-Version:Date:In-Reply-To:Message-ID:Subject:From:To:Cc:
	 Content-Type; b=aG9vEsf2i8uCDMmAbJNKFZy1bs8UnwCq48RCmPVyy8nqvPBRwbYGjtXWoSyJxnnMVBcLbqRAld3Z1mjudQfeihJblU69OvazcIjsmmI3+tfB3aH8HEwiBhke3rLBk1cjwtdguIZWpWWBQGYSrdN67AHvRECiVX497Vi8q39XNU4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com; arc=none smtp.client-ip=209.85.166.72
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com
Received: by mail-io1-f72.google.com with SMTP id ca18e2360f4ac-945c705df24so55394439f.0
        for <syzbot@lists.linux.dev>; Wed, 26 Nov 2025 00:16:13 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1764144973; x=1764749773;
        h=cc:to:from:subject:message-id:in-reply-to:date:mime-version
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=GV7L64Lukxwhs4+pNd9OeGnnt4P82bXGOhYOkGbjhyc=;
        b=Kt3vuFpnhKzr5k4m9RitCXWJj+HYRzTISje6C+RowzSPeoy0VvzngnAaEXYZmNRj36
         SbvjPGoGR8uoshVHDryZaDE/4ThxShHMuXzAf5SPe6jq3FUt1MabTEGhg+AFukzILP50
         JCfFxDAIkjYJ7RBMrp0XKqTK/6UScd7hSdpNxq5TDDrH4wq98sEr1l+eDUaHqQ1io1Zo
         qTLKLbB8G5Vz7iILnTTuuwDGIygId8ImyYAG8Yxg0tAHO266Bvt8uur4BXwgU1OYsjP7
         NzflVQ4XWvFU//Oo0qyBr9mo50q+emjGw/jf/I1sUVvCBIITCdebhwcfrnhBnjLycZDt
         /6sg==
X-Gm-Message-State: AOJu0YwaaDG+DcYzrBBOGDdOYR3U+GHmjnojmQ3k0O8YrIZQp8KydBbR
	dT/G7ByZyXJU6StENB4mGwCPpGfEg5jCxE1aS2d5djwZqf9KHRJQx7b6NFTWFAfNe56QMkH2JYx
	WBJJEWw2rBSDXcIlp0AUmbpK+m3THQkjdir/40nNRZfP8eDaKa7c7NTas/BQ=
X-Google-Smtp-Source: AGHT+IHhzXzUmxFpN2a7S+4xTfO5tz6udl/gx+iHQbfZ9mbRbJv32etnuETAGyXGLw8MpES/tuu9m7rvRiTzifzrpnqrP4+vG2VF
Precedence: bulk
X-Mailing-List: syzbot@lists.linux.dev
List-Id: <syzbot.lists.linux.dev>
List-Subscribe: <mailto:syzbot+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:syzbot+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Received: by 2002:a05:6e02:198b:b0:435:a410:d8b5 with SMTP id
 e9e14a558f8ab-435b9030219mr196964365ab.1.1764144972903; Wed, 26 Nov 2025
 00:16:12 -0800 (PST)
Date: Wed, 26 Nov 2025 00:16:12 -0800
In-Reply-To: <20251125224604.872351-1-victor@mojatatu.com>
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <6926b74c.a70a0220.d98e3.00cf.GAE@google.com>
Subject: [syzbot ci] Re: net/sched: Introduce qdisc quirk_chk op
From: syzbot ci <syzbot+ci7e35fdcdff8da55c@syzkaller.appspotmail.com>
To: davem@davemloft.net, edumazet@google.com, horms@kernel.org, 
	jhs@mojatatu.com, jiri@resnulli.us, kuba@kernel.org, netdev@vger.kernel.org, 
	pabeni@redhat.com, stephen@networkplumber.org, victor@mojatatu.com, 
	xiyou.wangcong@gmail.com
Cc: syzbot@lists.linux.dev, syzkaller-bugs@googlegroups.com
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
