Received: from mail-ot1-f70.google.com (mail-ot1-f70.google.com [209.85.210.70])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2151D2737F4
	for <syzbot@lists.linux.dev>; Thu,  8 Jan 2026 06:37:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.70
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767854285; cv=none; b=OPgn+niIkxwzOc0ThsFYrN7irrAx2aPNvYp+fIWW2kFkTc0Yym4agZzVwbIzQhLW/2CSDsYVSg2hQO4kffX9w8BrVFgy8m7dVpHV5n4NhQsnJUAoLwtNMBSXgROcK3AUbsEfLBKOnv9L8qm8160wjZSix+ki98AmnowFdtU0R88=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767854285; c=relaxed/simple;
	bh=ILvKRSqrZfBY8R9Sv0medJtSP+HX16ReDfjszaeLukE=;
	h=MIME-Version:Date:In-Reply-To:Message-ID:Subject:From:To:Cc:
	 Content-Type; b=C/FddC3tz93HU1YVwyLKiC4aWjt2SuVR0yq1MV0vtcMMaUa6jr7S4T6lsv4hV+L2ULu6G4zRc2bAY1mIm3/y9iq0p6OE81c0ikOofUFPa9Zolc7mY0VIg6aDintybhzPzWdHSGWeScKWfZYgRLdUAgGOyYjllimGAT2+DxrvVPk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com; arc=none smtp.client-ip=209.85.210.70
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com
Received: by mail-ot1-f70.google.com with SMTP id 46e09a7af769-7c75663feaeso5900725a34.3
        for <syzbot@lists.linux.dev>; Wed, 07 Jan 2026 22:37:55 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1767854274; x=1768459074;
        h=cc:to:from:subject:message-id:in-reply-to:date:mime-version
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=gqIBuhKVe2+1cy9MVOoRMx3f9L33YTIZn4K3zXXwQSg=;
        b=rnxTynIVjwtp5fUPsNiY2CYsrC/Q/jUpz2clDUl9Rb0a1PNkJqBvFBLLSX0BSUuAFe
         LcUbYi0Nvbtd7q8PlEmw4JJzNi+4/MBBL/ZQBw1ztmNkjK49BqZzBkvWlhA/UrMAP0bw
         SuOspUhMdEy6HYg0V3DCSSnU21J7l/+66WGp8r/KPMpgjZjNoznw0WLVIU6jH3VzaEBr
         +J4yRqDxtt/cZ1fJXvLNsCiodPR3lG6rq2QIFv5sMo/BtQ95Q6B0bREgJCrnrqhLx691
         Vtfyp+xlUR6ZH3DTg0wfBuGvrfGAmMvcXeTLoyzeSoXu4t2PVOidB2xRYZsU8IX1o2ah
         csGQ==
X-Gm-Message-State: AOJu0Yypz9VsJ1k5Y9yiFPnDvs631b3+CtGaHkqWw+9+rjWZIVi54Xqf
	7RmnjfPhWZTUDnDNAk3XwMcLUrXbCUXXqnPnug3z3tv7aixxAr9iouNMK8RTm37ASuv61dWwu06
	pPQuCKXd6TJq5Vw2Q59uNQ2TRlHebvXn/feNY5MrvBos10G5uR5x9TZPPfcg=
X-Google-Smtp-Source: AGHT+IHIfg3MfaIcvzzEKAjuxvTtaZyQdIckRHbJK0+t50UYjzoeOX8AdyZuFdPHRxMGZUOI8oplaw/SIT3W0Dkym7+Zfte1G2MU
Precedence: bulk
X-Mailing-List: syzbot@lists.linux.dev
List-Id: <syzbot.lists.linux.dev>
List-Subscribe: <mailto:syzbot+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:syzbot+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Received: by 2002:a05:6820:1624:b0:659:9a49:90ac with SMTP id
 006d021491bc7-65f54f7a4f7mr1813923eaf.43.1767854274203; Wed, 07 Jan 2026
 22:37:54 -0800 (PST)
Date: Wed, 07 Jan 2026 22:37:54 -0800
In-Reply-To: <20260107125423.4031241-1-edumazet@google.com>
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <695f50c2.050a0220.1c677c.038a.GAE@google.com>
Subject: [syzbot ci] Re: net: update netdev_lock_{type,name}
From: syzbot ci <syzbot+ci131adae482253910@syzkaller.appspotmail.com>
To: davem@davemloft.net, edumazet@google.com, eric.dumazet@gmail.com, 
	horms@kernel.org, kuba@kernel.org, netdev@vger.kernel.org, pabeni@redhat.com
Cc: syzbot@lists.linux.dev, syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"

syzbot ci has tested the following series

[v2] net: update netdev_lock_{type,name}
https://lore.kernel.org/all/20260107125423.4031241-1-edumazet@google.com
* [PATCH v2 net] net: update netdev_lock_{type,name}

and found the following issue:
WARNING in register_netdevice

Full report is available here:
https://ci.syzbot.org/series/07a2abd3-8dbc-43d0-a5d9-cdbb1a35d769

***

WARNING in register_netdevice

tree:      net
URL:       https://kernel.googlesource.com/pub/scm/linux/kernel/git/netdev/net.git
base:      1806d210e5a8f431ad4711766ae4a333d407d972
arch:      amd64
compiler:  Debian clang version 21.1.8 (++20251202083448+f68f64eb8130-1~exp1~20251202083504.46), Debian LLD 21.1.8
config:    https://ci.syzbot.org/builds/f4fb7576-ea1f-485d-9ef1-c3270f1560d9/config
C repro:   https://ci.syzbot.org/findings/e4767ea9-6be5-4bce-9523-40ab12d29b67/c_repro
syz repro: https://ci.syzbot.org/findings/e4767ea9-6be5-4bce-9523-40ab12d29b67/syz_repro

------------[ cut here ]------------
netdev_lock_pos() could not find dev_type=805
WARNING: net/core/dev.c:529 at netdev_lock_pos net/core/dev.c:529 [inline], CPU#0: syz.0.17/5972
WARNING: net/core/dev.c:529 at netdev_set_addr_lockdep_class net/core/dev.c:547 [inline], CPU#0: syz.0.17/5972
WARNING: net/core/dev.c:529 at register_netdevice+0x7f9/0x1ba0 net/core/dev.c:11318, CPU#0: syz.0.17/5972
Modules linked in:
CPU: 0 UID: 0 PID: 5972 Comm: syz.0.17 Not tainted syzkaller #0 PREEMPT(full) 
Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS 1.16.2-debian-1.16.2-1 04/01/2014
RIP: 0010:netdev_lock_pos net/core/dev.c:529 [inline]
RIP: 0010:netdev_set_addr_lockdep_class net/core/dev.c:547 [inline]
RIP: 0010:register_netdevice+0x7fc/0x1ba0 net/core/dev.c:11318
Code: ca 56 db f8 48 c7 03 00 00 00 00 41 bd f4 ff ff ff 4c 8b 64 24 28 e9 8f f9 ff ff e8 4e 59 74 f8 48 8d 3d 27 79 82 06 44 89 e6 <67> 48 0f b9 3a 41 bc 40 00 00 00 49 bf 00 00 00 00 00 fc ff df 4c
RSP: 0018:ffffc9000768ef20 EFLAGS: 00010293
RAX: ffffffff894e19b2 RBX: fffffffffffffff8 RCX: ffff8881063c57c0
RDX: 0000000000000000 RSI: 0000000000000325 RDI: ffffffff8fd092e0
RBP: ffffc9000768f090 R08: 0000000000000003 R09: 0000000000000000
R10: dffffc0000000000 R11: ffffed10218fd9d4 R12: 0000000000000325
R13: ffffffff8c902318 R14: 000000000000fffe R15: 0000000000000040
FS:  000055556284f500(0000) GS:ffff88818e40f000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 00007f4739c706c0 CR3: 00000001bdb86000 CR4: 00000000000006f0
Call Trace:
 <TASK>
 ieee802154_if_add+0xb39/0x1050 net/mac802154/iface.c:667
 ieee802154_add_iface_deprecated+0x43/0x70 net/mac802154/cfg.c:26
 rdev_add_virtual_intf_deprecated net/ieee802154/rdev-ops.h:16 [inline]
 ieee802154_add_iface+0x472/0x860 net/ieee802154/nl-phy.c:218
 genl_family_rcv_msg_doit+0x22a/0x330 net/netlink/genetlink.c:1115
 genl_family_rcv_msg net/netlink/genetlink.c:1195 [inline]
 genl_rcv_msg+0x61c/0x7a0 net/netlink/genetlink.c:1210
 netlink_rcv_skb+0x232/0x4b0 net/netlink/af_netlink.c:2550
 genl_rcv+0x28/0x40 net/netlink/genetlink.c:1219
 netlink_unicast_kernel net/netlink/af_netlink.c:1318 [inline]
 netlink_unicast+0x80f/0x9b0 net/netlink/af_netlink.c:1344
 netlink_sendmsg+0x813/0xb40 net/netlink/af_netlink.c:1894
 sock_sendmsg_nosec net/socket.c:727 [inline]
 __sock_sendmsg+0x21c/0x270 net/socket.c:742
 ____sys_sendmsg+0x4d7/0x810 net/socket.c:2592
 ___sys_sendmsg+0x2a5/0x360 net/socket.c:2646
 __sys_sendmsg net/socket.c:2678 [inline]
 __do_sys_sendmsg net/socket.c:2683 [inline]
 __se_sys_sendmsg net/socket.c:2681 [inline]
 __x64_sys_sendmsg+0x1bd/0x2a0 net/socket.c:2681
 do_syscall_x64 arch/x86/entry/syscall_64.c:63 [inline]
 do_syscall_64+0xe2/0xf80 arch/x86/entry/syscall_64.c:94
 entry_SYSCALL_64_after_hwframe+0x77/0x7f
RIP: 0033:0x7f4739d9acb9
Code: ff c3 66 2e 0f 1f 84 00 00 00 00 00 0f 1f 44 00 00 48 89 f8 48 89 f7 48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 ff ff 73 01 c3 48 c7 c1 e8 ff ff ff f7 d8 64 89 01 48
RSP: 002b:00007ffd43a0e968 EFLAGS: 00000246 ORIG_RAX: 000000000000002e
RAX: ffffffffffffffda RBX: 00007f473a005fa0 RCX: 00007f4739d9acb9
RDX: 0000000020048000 RSI: 00002000000009c0 RDI: 0000000000000004
RBP: 00007f4739e08bf7 R08: 0000000000000000 R09: 0000000000000000
R10: 0000000000000000 R11: 0000000000000246 R12: 0000000000000000
R13: 00007f473a005fac R14: 00007f473a005fa0 R15: 00007f473a005fa0
 </TASK>
----------------
Code disassembly (best guess):
   0:	ca 56 db             	lret   $0xdb56
   3:	f8                   	clc
   4:	48 c7 03 00 00 00 00 	movq   $0x0,(%rbx)
   b:	41 bd f4 ff ff ff    	mov    $0xfffffff4,%r13d
  11:	4c 8b 64 24 28       	mov    0x28(%rsp),%r12
  16:	e9 8f f9 ff ff       	jmp    0xfffff9aa
  1b:	e8 4e 59 74 f8       	call   0xf874596e
  20:	48 8d 3d 27 79 82 06 	lea    0x6827927(%rip),%rdi        # 0x682794e
  27:	44 89 e6             	mov    %r12d,%esi
* 2a:	67 48 0f b9 3a       	ud1    (%edx),%rdi <-- trapping instruction
  2f:	41 bc 40 00 00 00    	mov    $0x40,%r12d
  35:	49 bf 00 00 00 00 00 	movabs $0xdffffc0000000000,%r15
  3c:	fc ff df
  3f:	4c                   	rex.WR


***

If these findings have caused you to resend the series or submit a
separate fix, please add the following tag to your commit message:
  Tested-by: syzbot@syzkaller.appspotmail.com

---
This report is generated by a bot. It may contain errors.
syzbot ci engineers can be reached at syzkaller@googlegroups.com.
