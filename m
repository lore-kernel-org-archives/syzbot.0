Received: from mail-ot1-f72.google.com (mail-ot1-f72.google.com [209.85.210.72])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C548A3502A4
	for <syzbot@lists.linux.dev>; Mon, 18 May 2026 15:31:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.72
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779118279; cv=none; b=iiIChd9oeBCZ2iWfxSt6Sc7AXm5yicf1PRCQzO60xJga76QSkt23xQXJds6ri800pqlikEvgGGTBB9tUvfxdrDgk3+uHXpmqFMAEaaoHjY0lP6EAjpCXyp/JA4GVNomSj9DvLnirU84e59zTAb+9oO9H/dLhaRBkrUy7/yG9qdQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779118279; c=relaxed/simple;
	bh=wvEDrHACZwc11FcEI/WjS1RE1H/2F9DYHZegYmW1tb4=;
	h=MIME-Version:Date:Message-ID:Subject:From:To:Cc:Content-Type; b=N6GiCXYxYngR+EKu2uEQyMg2F5vS5rFKEJTwmW9POHznhqD8rfeEaafE5+bXfC2k+YiaBBeb+W9aUaqKGzJuBoy3G11D+xe3TlaG0XqXGvwh2Y0V6fvqw6gy6tH8ufd6HfqrofY0xdg/o61cV4hviAeTMOt0JrFxkF21sVTBa6M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com; arc=none smtp.client-ip=209.85.210.72
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com
Received: by mail-ot1-f72.google.com with SMTP id 46e09a7af769-7dce437f1a1so6842933a34.3
        for <syzbot@lists.linux.dev>; Mon, 18 May 2026 08:31:17 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1779118277; x=1779723077;
        h=cc:to:from:subject:message-id:date:mime-version:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=8Dq+rFgm4uy2MNsRmgsO2n9srSwIylAQeg9/dcWOncI=;
        b=QAd2reT4rv73KSLna2nhyLnMWbegF6Xjfb3eRzWcF/eTGUEjletZpYDPwtKA0QQ3k+
         v67zi9yTXT4ZkZGfuMC12yjOibGb1LFt4rjiIys2CQcgcZzADnpQcS2ZtL8XvPzp/ugu
         eLfcN9eFuTd+QXqxAy0uL9SK3NtT0nnIN3BWDgXr6o4sIuPEfy7gKauaddv6QOg5RErE
         UkThsKsQ4JzhdRdMg8TTuWm8QNOMxgJXdMkCfUL86Kh5MWicQ82VSH4rX1E867n6+XEO
         4cou5VPbZHfz3yuS5qpZJWNQ7lKkq8tH07quZaVwJJzTMtFKtjJJaeB1UwL86DSNnFUa
         fXuQ==
X-Gm-Message-State: AOJu0YwwiQkMq5XamkotWLlGev2qXqo2GN2K/W+HiL4u7V+PuSYJQ9y9
	zmQFX6XCws6Daa/QnnzsNVXTljaxRzOxWzKOa5ylDfkIc2dUIZ/QWn1zLRWImWBPj4nmAQgJAQ9
	WmF+oolYBBSQIJ3CnCFykbEcS4Wm8G8ARCFoT71RFW9SVMZttfu1i2KdXaks=
Precedence: bulk
X-Mailing-List: syzbot@lists.linux.dev
List-Id: <syzbot.lists.linux.dev>
List-Subscribe: <mailto:syzbot+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:syzbot+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Received: by 2002:a05:6830:67e8:b0:7dc:c926:4f6c with SMTP id
 46e09a7af769-7e4f2bada2bmr10832879a34.18.1779118276653; Mon, 18 May 2026
 08:31:16 -0700 (PDT)
Date: Mon, 18 May 2026 08:31:16 -0700
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <6a0b30c4.a70a0220.202581.0004.GAE@google.com>
Subject: [moderation/CI] Re: rtnetlink: RTNL avoidance in rtnl_getlink()
From: syzbot ci <syzbot+ci99ea617af90e9814@syzkaller.appspotmail.com>
To: syzkaller-upstream-moderation@googlegroups.com
Cc: syzbot@lists.linux.dev
Content-Type: text/plain; charset="UTF-8"

syzbot ci has tested the following series

[v1] rtnetlink: RTNL avoidance in rtnl_getlink()
https://lore.kernel.org/all/20260518100134.809042-1-edumazet@google.com
* [PATCH net-next 1/2] rtnetlink: use nla_nest_end_safe() in rtnl_fill_prop_list()
* [PATCH net-next 2/2] rtnetlink: do not acquire RTNL for RTM_GETLINK with RTEXT_FILTER_NAME_ONLY

and found the following issue:
WARNING in rtnl_fill_ifinfo

Full report is available here:
https://ci.syzbot.org/series/c0efec5e-90ce-4ba2-8383-16d7bc172521

***

WARNING in rtnl_fill_ifinfo

tree:      net-next
URL:       https://kernel.googlesource.com/pub/scm/linux/kernel/git/netdev/net-next.git
base:      627ac78f2741e2ebd2225e2e953b6964a8a9182f
arch:      amd64
compiler:  Debian clang version 21.1.8 (++20251221033036+2078da43e25a-1~exp1~20251221153213.50), Debian LLD 21.1.8
config:    https://ci.syzbot.org/builds/9507e45e-17a8-457b-a47d-5229f306e1f1/config
syz repro: https://ci.syzbot.org/findings/e56b032e-6444-4682-b577-34e22399b7cc/syz_repro

------------[ cut here ]------------
RTNL: assertion failed at net/core/rtnetlink.c (2071)
WARNING: net/core/rtnetlink.c:2071 at rtnl_fill_ifinfo+0xc73/0x2770 net/core/rtnetlink.c:2071, CPU#1: syz.1.18/5818
Modules linked in:
CPU: 1 UID: 0 PID: 5818 Comm: syz.1.18 Not tainted syzkaller #0 PREEMPT(full) 
Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS 1.16.2-debian-1.16.2-1 04/01/2014
RIP: 0010:rtnl_fill_ifinfo+0xc7f/0x2770 net/core/rtnetlink.c:2071
Code: 5a 41 f8 45 85 f6 74 2c e8 be 55 41 f8 e9 91 fc ff ff e8 b4 55 41 f8 48 8d 3d 9d af bb 06 48 c7 c6 40 1c de 8c ba 17 08 00 00 <67> 48 0f b9 3a e9 5d f4 ff ff 48 8d 8c 24 00 02 00 00 48 8b 44 24
RSP: 0018:ffffc90003bcee40 EFLAGS: 00010293
RAX: ffffffff89846eac RBX: 1ffff92000779dd4 RCX: ffff88816b500000
RDX: 0000000000000817 RSI: ffffffff8cde1c40 RDI: ffffffff90401e50
RBP: ffffc90003bcf118 R08: ffffffff8fdd1227 R09: 1ffffffff1fba244
R10: dffffc0000000000 R11: fffffbfff1fba245 R12: 0000000000000010
R13: 0000000000000003 R14: 1ffff92000779dd4 R15: ffff88816b898000
FS:  00007f293800b6c0(0000) GS:ffff8882a927a000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 00007f2937072780 CR3: 000000016a7d4000 CR4: 00000000000006f0
Call Trace:
 <TASK>
 rtnl_getlink+0xce4/0x10d0 net/core/rtnetlink.c:4267
 rtnetlink_rcv_msg+0x7d5/0xbe0 net/core/rtnetlink.c:7042
 netlink_rcv_skb+0x232/0x4b0 net/netlink/af_netlink.c:2551
 netlink_unicast_kernel net/netlink/af_netlink.c:1319 [inline]
 netlink_unicast+0x75c/0x8e0 net/netlink/af_netlink.c:1345
 netlink_sendmsg+0x813/0xb40 net/netlink/af_netlink.c:1895
 sock_sendmsg_nosec net/socket.c:787 [inline]
 __sock_sendmsg net/socket.c:802 [inline]
 ____sys_sendmsg+0x972/0x9f0 net/socket.c:2698
 ___sys_sendmsg+0x2a5/0x360 net/socket.c:2752
 __sys_sendmsg net/socket.c:2784 [inline]
 __do_sys_sendmsg net/socket.c:2789 [inline]
 __se_sys_sendmsg net/socket.c:2787 [inline]
 __x64_sys_sendmsg+0x1bd/0x2a0 net/socket.c:2787
 do_syscall_x64 arch/x86/entry/syscall_64.c:63 [inline]
 do_syscall_64+0x15f/0xf80 arch/x86/entry/syscall_64.c:94
 entry_SYSCALL_64_after_hwframe+0x77/0x7f
RIP: 0033:0x7f293719ce59
Code: ff c3 66 2e 0f 1f 84 00 00 00 00 00 0f 1f 44 00 00 48 89 f8 48 89 f7 48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 ff ff 73 01 c3 48 c7 c1 e8 ff ff ff f7 d8 64 89 01 48
RSP: 002b:00007f293800b028 EFLAGS: 00000246 ORIG_RAX: 000000000000002e
RAX: ffffffffffffffda RBX: 00007f2937415fa0 RCX: 00007f293719ce59
RDX: 0000000000000004 RSI: 0000200000000ac0 RDI: 0000000000000003
RBP: 00007f2937232d6f R08: 0000000000000000 R09: 0000000000000000
R10: 0000000000000000 R11: 0000000000000246 R12: 0000000000000000
R13: 00007f2937416038 R14: 00007f2937415fa0 R15: 00007ffffb498538
 </TASK>
----------------
Code disassembly (best guess):
   0:	5a                   	pop    %rdx
   1:	41 f8                	rex.B clc
   3:	45 85 f6             	test   %r14d,%r14d
   6:	74 2c                	je     0x34
   8:	e8 be 55 41 f8       	call   0xf84155cb
   d:	e9 91 fc ff ff       	jmp    0xfffffca3
  12:	e8 b4 55 41 f8       	call   0xf84155cb
  17:	48 8d 3d 9d af bb 06 	lea    0x6bbaf9d(%rip),%rdi        # 0x6bbafbb
  1e:	48 c7 c6 40 1c de 8c 	mov    $0xffffffff8cde1c40,%rsi
  25:	ba 17 08 00 00       	mov    $0x817,%edx
* 2a:	67 48 0f b9 3a       	ud1    (%edx),%rdi <-- trapping instruction
  2f:	e9 5d f4 ff ff       	jmp    0xfffff491
  34:	48 8d 8c 24 00 02 00 	lea    0x200(%rsp),%rcx
  3b:	00
  3c:	48                   	rex.W
  3d:	8b                   	.byte 0x8b
  3e:	44                   	rex.R
  3f:	24                   	.byte 0x24


***

If these findings have caused you to resend the series or submit a
separate fix, please add the following tag to your commit message:
  Tested-by: syzbot@syzkaller.appspotmail.com

---
This report is generated by a bot. It may contain errors.
syzbot ci engineers can be reached at syzkaller@googlegroups.com.

To test a patch for this bug, please reply with `#syz test`
(should be on a separate line).

The patch should be attached to the email.
Note: arguments like custom git repos and branches are not supported.

The email will later be sent to:
[davem@davemloft.net edumazet@google.com eric.dumazet@gmail.com horms@kernel.org kuba@kernel.org kuniyu@google.com netdev@vger.kernel.org pabeni@redhat.com]

If the report looks fine to you, reply with:
#syz upstream

If the report is a false positive, reply with
#syz invalid

