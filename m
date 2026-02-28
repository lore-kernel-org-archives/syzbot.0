Received: from mail-oi1-f197.google.com (mail-oi1-f197.google.com [209.85.167.197])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5A511373BEF
	for <syzbot@lists.linux.dev>; Sat, 28 Feb 2026 22:12:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.167.197
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772316755; cv=none; b=mkbUhmlnnoCKlPqXWIuV37rmGTNskaxLLuVP1u3DYjzaVD3u6iVzgMb6QQjGXYPwKpbTbRQjCTOSALXbUci/oWXDl07JI/5m71hHgPPTfBOweq5mKyK7shPTENHCfe1InHyY36KhiJyJRB9n5CQVFo9tQs5/kgTXDj5LH6xebA0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772316755; c=relaxed/simple;
	bh=KHeLoS7BWEI46FzR9qGtupaLwwefG46tni6wMTwbQ/s=;
	h=MIME-Version:Date:In-Reply-To:Message-ID:Subject:From:To:Cc:
	 Content-Type; b=kKzK10EALxFNpBI+1VUA3FaJeeVBuxrCnJ+umh7XY00pGAoHwzRL4Phw7AkvO5/U8pMX1VmXz1mvWw8PL3Mw1/W/50h0MuBR5YVXWKuqFNdly9bf1JWGuYPQOuwvG5d3nuiD0TpC3bz3YS8yOY37hlSXTjkpUjuXLg/tUIULB/s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com; arc=none smtp.client-ip=209.85.167.197
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com
Received: by mail-oi1-f197.google.com with SMTP id 5614622812f47-464bbea2120so33158572b6e.3
        for <syzbot@lists.linux.dev>; Sat, 28 Feb 2026 14:12:34 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1772316753; x=1772921553;
        h=cc:to:from:subject:message-id:in-reply-to:date:mime-version
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=g4lrXEHcsBV4g6kjs5fV0GLXi7ODwUGzXXo88xd8ebI=;
        b=ntYd+biDjENU6IJMVp4d0rmniyLfOvRDJTzTbtpgRZm4IJkdN9HcInWMAiyoJKlpme
         WD61PncFaPhqtvBAo80FxmKMH1YNmNUBqoMqkO6epDKMU2CJfOw1f5Y1zoa3Dimrm9Vg
         /teE4cJvHCDb1n7NkSioefhrbecAAnZi525400WkxvoKPvSJUSsevrY5AS3kXPbJzHoM
         GJc7cQnI4yyiZOvqD8S7uZH5cM7wq5b8MfSXZO33CYn/AkDWAEQm1/zppJQLhdAbVCkp
         vz2RRoUTrzjh4PkXGkt6NSlrMtZeHvfNgq7nRssC2obQbV+kRz1TzI9uy/tWtdKhs7Wt
         AMlg==
X-Gm-Message-State: AOJu0YyIWAEnrGRwk7jPUNkYdq7EZrQJUWEKbPkaXO3WhWQTvyJTBkLA
	1TWfGlc18d3EpUZk8a7ygNWVbQuQ3GdvSBiEyxQyy4ZWM8rX4Qxr9WqCbKrsDTN+ySCLW4jLF/K
	F3tim3JD+TqB99uKqTO3iRVwCCXr2GqtfQ6cuwoeRYZUMBEY91IknpQfbXLE=
Precedence: bulk
X-Mailing-List: syzbot@lists.linux.dev
List-Id: <syzbot.lists.linux.dev>
List-Subscribe: <mailto:syzbot+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:syzbot+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Received: by 2002:a05:6820:808:b0:662:fe9f:2259 with SMTP id
 006d021491bc7-679faf2678bmr4493097eaf.50.1772316753493; Sat, 28 Feb 2026
 14:12:33 -0800 (PST)
Date: Sat, 28 Feb 2026 14:12:33 -0800
In-Reply-To: <20260227220740.11928-1-mail@david-bauer.net>
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <69a36851.050a0220.3a55be.0047.GAE@google.com>
Subject: [syzbot ci] Re: l2tp: account for IP version in SKB headroom
From: syzbot ci <syzbot+ci9876702228569c74@syzkaller.appspotmail.com>
To: davem@davemloft.net, edumazet@google.com, horms@kernel.org, 
	kuba@kernel.org, linux-kernel@vger.kernel.org, mail@david-bauer.net, 
	netdev@vger.kernel.org, pabeni@redhat.com
Cc: syzbot@lists.linux.dev, syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"

syzbot ci has tested the following series

[v1] l2tp: account for IP version in SKB headroom
https://lore.kernel.org/all/20260227220740.11928-1-mail@david-bauer.net
* [PATCH net-next 1/2] l2tp: account for IP version in SKB headroom
* [PATCH net-next 2/2] l2tp: unify headroom calculation

and found the following issue:
general protection fault in l2tp_eth_create

Full report is available here:
https://ci.syzbot.org/series/10f6234e-88a0-41c8-b9d2-a3e54f289fbd

***

general protection fault in l2tp_eth_create

tree:      net-next
URL:       https://kernel.googlesource.com/pub/scm/linux/kernel/git/netdev/net-next.git
base:      58e443b773ef054ae069cf777ba19adb99d73829
arch:      amd64
compiler:  Debian clang version 21.1.8 (++20251221033036+2078da43e25a-1~exp1~20251221153213.50), Debian LLD 21.1.8
config:    https://ci.syzbot.org/builds/66fb3a44-8edb-4c92-9149-328653e46ccd/config
C repro:   https://ci.syzbot.org/findings/9b3d30fe-b87f-4b00-99a6-464f0a271312/c_repro
syz repro: https://ci.syzbot.org/findings/9b3d30fe-b87f-4b00-99a6-464f0a271312/syz_repro

netlink: 8 bytes leftover after parsing attributes in process `syz.0.17'.
Oops: general protection fault, probably for non-canonical address 0xdffffc0000000012: 0000 [#1] SMP KASAN PTI
KASAN: null-ptr-deref in range [0x0000000000000090-0x0000000000000097]
CPU: 1 UID: 0 PID: 5971 Comm: syz.0.17 Not tainted syzkaller #0 PREEMPT(full) 
Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS 1.16.2-debian-1.16.2-1 04/01/2014
RIP: 0010:l2tp_session_udp_hdrlen net/l2tp/l2tp_core.h:340 [inline]
RIP: 0010:l2tp_session_overhead net/l2tp/l2tp_core.h:346 [inline]
RIP: 0010:l2tp_eth_adjust_mtu net/l2tp/l2tp_eth.c:202 [inline]
RIP: 0010:l2tp_eth_create+0x2cd/0xca0 net/l2tp/l2tp_eth.c:250
Code: 48 89 44 24 58 42 80 3c 28 00 74 08 48 89 df e8 b9 68 54 f7 48 89 5c 24 60 4c 8b 33 4d 8d a6 94 00 00 00 4c 89 e0 48 c1 e8 03 <42> 0f b6 04 28 84 c0 0f 85 35 08 00 00 45 8b 24 24 31 ff 44 89 e6
RSP: 0018:ffffc900040c7160 EFLAGS: 00010207
RAX: 0000000000000012 RBX: ffff888114d00020 RCX: 0000000000000000
RDX: ffff888104f90000 RSI: 0000000000000028 RDI: 0000000000000000
RBP: ffffc900040c7270 R08: 0000000000400dc0 R09: 00000000ffffffff
R10: dffffc0000000000 R11: fffffbfff2022f77 R12: 0000000000000094
R13: dffffc0000000000 R14: 0000000000000000 R15: ffff888114d00000
FS:  0000555574b08500(0000) GS:ffff8882a9467000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 000055a269259270 CR3: 0000000105770000 CR4: 00000000000006f0
Call Trace:
 <TASK>
 l2tp_nl_cmd_session_create+0x766/0xc60 net/l2tp/l2tp_netlink.c:639
 genl_family_rcv_msg_doit+0x22a/0x330 net/netlink/genetlink.c:1114
 genl_family_rcv_msg net/netlink/genetlink.c:1194 [inline]
 genl_rcv_msg+0x61c/0x7a0 net/netlink/genetlink.c:1209
 netlink_rcv_skb+0x232/0x4b0 net/netlink/af_netlink.c:2550
 genl_rcv+0x28/0x40 net/netlink/genetlink.c:1218
 netlink_unicast_kernel net/netlink/af_netlink.c:1318 [inline]
 netlink_unicast+0x80f/0x9b0 net/netlink/af_netlink.c:1344
 netlink_sendmsg+0x813/0xb40 net/netlink/af_netlink.c:1894
 sock_sendmsg_nosec net/socket.c:727 [inline]
 __sock_sendmsg net/socket.c:742 [inline]
 ____sys_sendmsg+0xa68/0xad0 net/socket.c:2592
 ___sys_sendmsg+0x2a5/0x360 net/socket.c:2646
 __sys_sendmsg net/socket.c:2678 [inline]
 __do_sys_sendmsg net/socket.c:2683 [inline]
 __se_sys_sendmsg net/socket.c:2681 [inline]
 __x64_sys_sendmsg+0x1bd/0x2a0 net/socket.c:2681
 do_syscall_x64 arch/x86/entry/syscall_64.c:63 [inline]
 do_syscall_64+0x14d/0xf80 arch/x86/entry/syscall_64.c:94
 entry_SYSCALL_64_after_hwframe+0x77/0x7f
RIP: 0033:0x7f371079c799
Code: ff c3 66 2e 0f 1f 84 00 00 00 00 00 0f 1f 44 00 00 48 89 f8 48 89 f7 48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 ff ff 73 01 c3 48 c7 c1 e8 ff ff ff f7 d8 64 89 01 48
RSP: 002b:00007fff7e0100f8 EFLAGS: 00000246 ORIG_RAX: 000000000000002e
RAX: ffffffffffffffda RBX: 00007f3710a15fa0 RCX: 00007f371079c799
RDX: 0000000020000034 RSI: 0000200000000140 RDI: 0000000000000005
RBP: 00007f3710832bd9 R08: 0000000000000000 R09: 0000000000000000
R10: 0000000000000000 R11: 0000000000000246 R12: 0000000000000000
R13: 00007f3710a15fac R14: 00007f3710a15fa0 R15: 00007f3710a15fa0
 </TASK>
Modules linked in:
---[ end trace 0000000000000000 ]---
RIP: 0010:l2tp_session_udp_hdrlen net/l2tp/l2tp_core.h:340 [inline]
RIP: 0010:l2tp_session_overhead net/l2tp/l2tp_core.h:346 [inline]
RIP: 0010:l2tp_eth_adjust_mtu net/l2tp/l2tp_eth.c:202 [inline]
RIP: 0010:l2tp_eth_create+0x2cd/0xca0 net/l2tp/l2tp_eth.c:250
Code: 48 89 44 24 58 42 80 3c 28 00 74 08 48 89 df e8 b9 68 54 f7 48 89 5c 24 60 4c 8b 33 4d 8d a6 94 00 00 00 4c 89 e0 48 c1 e8 03 <42> 0f b6 04 28 84 c0 0f 85 35 08 00 00 45 8b 24 24 31 ff 44 89 e6
RSP: 0018:ffffc900040c7160 EFLAGS: 00010207
RAX: 0000000000000012 RBX: ffff888114d00020 RCX: 0000000000000000
RDX: ffff888104f90000 RSI: 0000000000000028 RDI: 0000000000000000
RBP: ffffc900040c7270 R08: 0000000000400dc0 R09: 00000000ffffffff
R10: dffffc0000000000 R11: fffffbfff2022f77 R12: 0000000000000094
R13: dffffc0000000000 R14: 0000000000000000 R15: ffff888114d00000
FS:  0000555574b08500(0000) GS:ffff8882a9467000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 000055a269259270 CR3: 0000000105770000 CR4: 00000000000006f0
----------------
Code disassembly (best guess):
   0:	48 89 44 24 58       	mov    %rax,0x58(%rsp)
   5:	42 80 3c 28 00       	cmpb   $0x0,(%rax,%r13,1)
   a:	74 08                	je     0x14
   c:	48 89 df             	mov    %rbx,%rdi
   f:	e8 b9 68 54 f7       	call   0xf75468cd
  14:	48 89 5c 24 60       	mov    %rbx,0x60(%rsp)
  19:	4c 8b 33             	mov    (%rbx),%r14
  1c:	4d 8d a6 94 00 00 00 	lea    0x94(%r14),%r12
  23:	4c 89 e0             	mov    %r12,%rax
  26:	48 c1 e8 03          	shr    $0x3,%rax
* 2a:	42 0f b6 04 28       	movzbl (%rax,%r13,1),%eax <-- trapping instruction
  2f:	84 c0                	test   %al,%al
  31:	0f 85 35 08 00 00    	jne    0x86c
  37:	45 8b 24 24          	mov    (%r12),%r12d
  3b:	31 ff                	xor    %edi,%edi
  3d:	44 89 e6             	mov    %r12d,%esi


***

If these findings have caused you to resend the series or submit a
separate fix, please add the following tag to your commit message:
  Tested-by: syzbot@syzkaller.appspotmail.com

---
This report is generated by a bot. It may contain errors.
syzbot ci engineers can be reached at syzkaller@googlegroups.com.
