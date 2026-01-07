Received: from mail-oo1-f69.google.com (mail-oo1-f69.google.com [209.85.161.69])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 343E828A72B
	for <syzbot@lists.linux.dev>; Wed,  7 Jan 2026 21:20:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.161.69
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767820842; cv=none; b=oq6LdYztUUPkLARc/WerOnBEvTeWUxJOohWVNbhnOOvIUI7Pt/tBulZJuG9c7XTLH36Q41FdVer05i68qHmTJ2qfpFA4SCbFtJLZ7Ky2ThtWh4jf0f/rA7zkzB9yO7wIyZ6KsCKhasAhMLkc5N7mk7+AfRIebP0hFVkNk1TDLSg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767820842; c=relaxed/simple;
	bh=97pT7KcEdhj7j4o2P+M+d0qm7KBtkrkREkvw7rhbqmk=;
	h=MIME-Version:Date:Message-ID:Subject:From:To:Cc:Content-Type; b=XpsudIG97VsSHg/9ked6VisKSKhLAPeR8ZQ2tjSRDE+Ry1zmjvWhI01Why1x9BDzKnQ6UDuknzwuEIVXv8djD+f/n6tQWo/kJ5yx+OpGX2dIVXe5bOiHdfw81f6sr6f0bbpgzl0WE5BNCqK1vKWIIJmaVplas0bvmGBwTKJfysk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com; arc=none smtp.client-ip=209.85.161.69
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com
Received: by mail-oo1-f69.google.com with SMTP id 006d021491bc7-65ec1bb9db9so4605126eaf.0
        for <syzbot@lists.linux.dev>; Wed, 07 Jan 2026 13:20:37 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1767820836; x=1768425636;
        h=cc:to:from:subject:message-id:date:mime-version:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=7nSC6m3qC4jNKBbvck7m0MUeq1XJK1xUzyEQOPu6zaY=;
        b=clhgNWc5JFRc63yQXbhBAjGXV4W9+ECnKRO6FZK2LdRYl74QL5EE63BOtnEGi5uDz5
         7+s6mzgJMCbIFZKDaDBfwsaIaH4+LffvuUy10zd7zp7Vz7nyP1nUwAhICoLcwcgCeqZo
         il+DZBvgbb4eD8WWVLp3I0GfFvYdqcbs2K2Jl6rnWGoGKbLbnD34CROqoyzZeYlw2Hz8
         xYMqKFVqRE9Ll74FqH0n7OhS9OotXu+jj5qHBPaOGBcJ/BTLNIVUs8g9MhXAvUU9UNoC
         abuLU+qNfmvtNRuYhh9cOks2FLreKBKShwRR0JH+u7WfQ6mFZPJUaoab7RWRQIZwGdHg
         MaDg==
X-Gm-Message-State: AOJu0Yxkm8WKcsKmFjXCbkSeMWJznjdV+HZNqqpHSGmUJmsIjYMVB9ze
	ZXPRIf43/2A+pMYuKiVnH0UsgWrlc6mBU+c5WgiaSFCVGgaJ7uYAFSVscSUirhU4iRCCs89+g/C
	IVBVypVe0WtTn4JB2WkGvb0Ex79zUJek4yxQL2HmV5UEA5ow1ZUx2WPOLuQs=
X-Google-Smtp-Source: AGHT+IGoetosvndXcLChIgts1BgrjH/APYj0K/wRdVuI4tGnTpyNpgT/GIxPtNLhdbFTLReh2ae7dgT6dZdU1JqGh8/Dhxmqwzz0
Precedence: bulk
X-Mailing-List: syzbot@lists.linux.dev
List-Id: <syzbot.lists.linux.dev>
List-Subscribe: <mailto:syzbot+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:syzbot+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Received: by 2002:a05:6820:1688:b0:659:8350:61b6 with SMTP id
 006d021491bc7-65f54eea482mr1592687eaf.6.1767820836177; Wed, 07 Jan 2026
 13:20:36 -0800 (PST)
Date: Wed, 07 Jan 2026 13:20:36 -0800
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <695ece24.050a0220.1c677c.037e.GAE@google.com>
Subject: [moderation/CI] Re: net: update netdev_lock_{type,name}
From: syzbot ci <syzbot+ci56a5bef79a4c8127@syzkaller.appspotmail.com>
To: syzkaller-upstream-moderation@googlegroups.com
Cc: syzbot@lists.linux.dev
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

The email will later be sent to:
[davem@davemloft.net edumazet@google.com eric.dumazet@gmail.com horms@kernel.org kuba@kernel.org netdev@vger.kernel.org pabeni@redhat.com]

If the report looks fine to you, reply with:
#syz upstream

If the report is a false positive, reply with
#syz invalid

