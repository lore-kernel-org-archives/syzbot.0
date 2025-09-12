Received: from mail-il1-f198.google.com (mail-il1-f198.google.com [209.85.166.198])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2E49627C145
	for <syzbot@lists.linux.dev>; Fri, 12 Sep 2025 09:13:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.198
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757668442; cv=none; b=q3JKLD8fa+uzQfb9p8FlQzSHaivThlB8QoxeB7Gn9/WdbZhHmg14c8BLfbP8x0h2W/UC8fy+om9yO4/IfdtIfQ+vkQqTnqGAK2L5YLckF7HaTKw22kFMFsAjdok3DM5HZ+q2glqOEv02XkobpuPHse3PQb1ZUNBy4qzVWyy0fFY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757668442; c=relaxed/simple;
	bh=hSDrM8ps+5FA8OGGzNQYID8KkXK+lKtQ55OVq3P93fE=;
	h=MIME-Version:Date:Message-ID:Subject:From:To:Cc:Content-Type; b=KkfMELvh7xSOm+UVGHwERY9nRzctdN/pq4L8va4TsKFi6LTcQEcIfj+PS974zn61+Ww3ABlE3YuSNY0xZmUZRR3H6LAmk5ovKUpzhtXpMPdq/ljhtg/7dl5Lbq56alMWExoRxsFoMW4iL8PsYgBzBLLJtdInzfxj+8FnzBntmiA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com; arc=none smtp.client-ip=209.85.166.198
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com
Received: by mail-il1-f198.google.com with SMTP id e9e14a558f8ab-4020e59b735so46615565ab.1
        for <syzbot@lists.linux.dev>; Fri, 12 Sep 2025 02:13:59 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1757668439; x=1758273239;
        h=content-transfer-encoding:cc:to:from:subject:message-id:date
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=KtM+eiQ6gNp85Lma2ltR5Som4fmBz72Pno9At/v15Nc=;
        b=L4O9XNSAnke4zWPyc0S46sBZkXGx6KV3MVHyfL80HY/6a5oR2KeCRZDtLpJ5aFmvG0
         Hf+i3ePpuYZn18CrxwQqIi/17Lr4lRFoKWWQkbs2g7h1GeImrgFCihqvy/5+95UyIz/2
         nxfXsOWR0Rwm8/Pi7PxqS2Op1MdF/WTQwUKrWlXV/GuPZYP5gRK7Fe+wW83Mhemby3oB
         h2jynnDUafm65DYtocDU+ghpG4CEw8U+n1iOzktSYtGUIYdSHETAqKhXLo+wGO5SMJtX
         MXBWwCcKgwLDZqxgSpzbg/vb84OwwQj9Jl98OE1xWhNghBsi0+D4mrm3y/xb15d2WnBi
         pLAw==
X-Gm-Message-State: AOJu0Yyn3H+pHmYg93O21J1NtwG5IaWDDwtiqfny3nflouEbv5IzzHBQ
	4n2JTBZt8+ZkXJJGRhAU34WfvkrPBUeOy1ocgeb70wb91S37e7KbLzYu6STt67BUwNdlUHkgMhi
	1Am+CPzvU+Y6AD1DduAmKZiTfJgbqwP0l3uNspbUq5a+R6tv2HXCmzZfiChc=
X-Google-Smtp-Source: AGHT+IHY66huh2cgKjSJXKOcgiUg9x8yN9+uHJOLIAs/t0QDGwmknsVhmICwSnoByas4HciOK3UPJkquo8Ns4QBmN7/8zUoWze0o
Precedence: bulk
X-Mailing-List: syzbot@lists.linux.dev
List-Id: <syzbot.lists.linux.dev>
List-Subscribe: <mailto:syzbot+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:syzbot+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Received: by 2002:a05:6e02:378d:b0:41b:3987:b3d3 with SMTP id
 e9e14a558f8ab-420a3ca7924mr33245275ab.20.1757668439235; Fri, 12 Sep 2025
 02:13:59 -0700 (PDT)
Date: Fri, 12 Sep 2025 02:13:59 -0700
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <68c3e457.050a0220.3c6139.049e.GAE@google.com>
Subject: [moderation/CI] Re: net: devmem: improve cpu cost of RX token management
From: syzbot ci <syzbot+ci6b3b9a0c3f217c63@syzkaller.appspotmail.com>
To: syzkaller-upstream-moderation@googlegroups.com
Cc: syzbot@lists.linux.dev
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

syzbot ci has tested the following series

[v2] net: devmem: improve cpu cost of RX token management
https://lore.kernel.org/all/20250911-scratch-bobbyeshleman-devmem-tcp-token=
-upstream-v2-0-c80d735bd453@meta.com
* [PATCH net-next v2 1/3] net: devmem: rename tx_vec to vec in dmabuf bindi=
ng
* [PATCH net-next v2 2/3] net: devmem: use niov array for token management
* [PATCH net-next v2 3/3] net: ethtool: prevent user from breaking devmem s=
ingle-binding rule

and found the following issue:
general protection fault in sock_devmem_dontneed

Full report is available here:
https://ci.syzbot.org/series/40b2252a-f8bb-4cec-bfc1-2ff8a3c55336

***

general protection fault in sock_devmem_dontneed

tree:      net-next
URL:       https://kernel.googlesource.com/pub/scm/linux/kernel/git/netdev/=
net-next.git
base:      5adf6f2b9972dbb69f4dd11bae52ba251c64ecb7
arch:      amd64
compiler:  Debian clang version 20.1.8 (++20250708063551+0c9f909b7976-1~exp=
1~20250708183702.136), Debian LLD 20.1.8
config:    https://ci.syzbot.org/builds/2c30c608-f14f-4e6d-9772-cc5e129939f=
c/config
C repro:   https://ci.syzbot.org/findings/c89c36f8-4666-47d0-bc39-35662a268=
e4d/c_repro
syz repro: https://ci.syzbot.org/findings/c89c36f8-4666-47d0-bc39-35662a268=
e4d/syz_repro

Oops: general protection fault, probably for non-canonical address 0xdffffc=
0000000000: 0000 [#1] SMP KASAN PTI
KASAN: null-ptr-deref in range [0x0000000000000000-0x0000000000000007]
CPU: 1 UID: 0 PID: 6028 Comm: syz.0.17 Not tainted syzkaller #0 PREEMPT(ful=
l)=20
Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS 1.16.2-debian-1.16=
.2-1 04/01/2014
RIP: 0010:sock_devmem_dontneed+0x40b/0x910 net/core/sock.c:1112
Code: 8b 44 24 18 44 8b 20 44 03 64 24 14 48 8b 44 24 68 80 3c 18 00 74 08 =
4c 89 ef e8 f0 bb c9 f8 4d 8b 7d 00 4c 89 f8 48 c1 e8 03 <80> 3c 18 00 74 0=
8 4c 89 ff e8 d7 bb c9 f8 4d 8b 2f 4c 89 e8 48 c1
RSP: 0018:ffffc90002987ac0 EFLAGS: 00010246
RAX: 0000000000000000 RBX: dffffc0000000000 RCX: 1ffff11020d27e78
RDX: ffff88810a039cc0 RSI: 0000000000000003 RDI: 0000000000000000
RBP: ffffc90002987c50 R08: ffffc90002987bdf R09: 0000000000000000
R10: ffffc90002987b60 R11: fffff52000530f7c R12: 0000000000000006
R13: ffff8881235cb710 R14: 0000000000000000 R15: 0000000000000000
FS:  000055555e866500(0000) GS:ffff8881a3c14000(0000) knlGS:000000000000000=
0
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 0000001b31b63fff CR3: 0000000027a20000 CR4: 00000000000006f0
Call Trace:
 <TASK>
 sk_setsockopt+0x682/0x2dc0 net/core/sock.c:1301
 do_sock_setsockopt+0x11b/0x1b0 net/socket.c:2340
 __sys_setsockopt net/socket.c:2369 [inline]
 __do_sys_setsockopt net/socket.c:2375 [inline]
 __se_sys_setsockopt net/socket.c:2372 [inline]
 __x64_sys_setsockopt+0x13f/0x1b0 net/socket.c:2372
 do_syscall_x64 arch/x86/entry/syscall_64.c:63 [inline]
 do_syscall_64+0xfa/0x3b0 arch/x86/entry/syscall_64.c:94
 entry_SYSCALL_64_after_hwframe+0x77/0x7f
RIP: 0033:0x7faf24f8eba9
Code: ff ff c3 66 2e 0f 1f 84 00 00 00 00 00 0f 1f 40 00 48 89 f8 48 89 f7 =
48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 ff f=
f 73 01 c3 48 c7 c1 a8 ff ff ff f7 d8 64 89 01 48
RSP: 002b:00007ffc3eb96018 EFLAGS: 00000246 ORIG_RAX: 0000000000000036
RAX: ffffffffffffffda RBX: 00007faf251d5fa0 RCX: 00007faf24f8eba9
RDX: 0000000000000050 RSI: 0000000000000001 RDI: 0000000000000003
RBP: 00007faf25011e19 R08: 0000000000000048 R09: 0000000000000000
R10: 0000200000000100 R11: 0000000000000246 R12: 0000000000000000
R13: 00007faf251d5fa0 R14: 00007faf251d5fa0 R15: 0000000000000005
 </TASK>
Modules linked in:
---[ end trace 0000000000000000 ]---
RIP: 0010:sock_devmem_dontneed+0x40b/0x910 net/core/sock.c:1112
Code: 8b 44 24 18 44 8b 20 44 03 64 24 14 48 8b 44 24 68 80 3c 18 00 74 08 =
4c 89 ef e8 f0 bb c9 f8 4d 8b 7d 00 4c 89 f8 48 c1 e8 03 <80> 3c 18 00 74 0=
8 4c 89 ff e8 d7 bb c9 f8 4d 8b 2f 4c 89 e8 48 c1
RSP: 0018:ffffc90002987ac0 EFLAGS: 00010246
RAX: 0000000000000000 RBX: dffffc0000000000 RCX: 1ffff11020d27e78
RDX: ffff88810a039cc0 RSI: 0000000000000003 RDI: 0000000000000000
RBP: ffffc90002987c50 R08: ffffc90002987bdf R09: 0000000000000000
R10: ffffc90002987b60 R11: fffff52000530f7c R12: 0000000000000006
R13: ffff8881235cb710 R14: 0000000000000000 R15: 0000000000000000
FS:  000055555e866500(0000) GS:ffff8881a3c14000(0000) knlGS:000000000000000=
0
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 0000001b31b63fff CR3: 0000000027a20000 CR4: 00000000000006f0
----------------
Code disassembly (best guess):
   0:	8b 44 24 18          	mov    0x18(%rsp),%eax
   4:	44 8b 20             	mov    (%rax),%r12d
   7:	44 03 64 24 14       	add    0x14(%rsp),%r12d
   c:	48 8b 44 24 68       	mov    0x68(%rsp),%rax
  11:	80 3c 18 00          	cmpb   $0x0,(%rax,%rbx,1)
  15:	74 08                	je     0x1f
  17:	4c 89 ef             	mov    %r13,%rdi
  1a:	e8 f0 bb c9 f8       	call   0xf8c9bc0f
  1f:	4d 8b 7d 00          	mov    0x0(%r13),%r15
  23:	4c 89 f8             	mov    %r15,%rax
  26:	48 c1 e8 03          	shr    $0x3,%rax
* 2a:	80 3c 18 00          	cmpb   $0x0,(%rax,%rbx,1) <-- trapping instruct=
ion
  2e:	74 08                	je     0x38
  30:	4c 89 ff             	mov    %r15,%rdi
  33:	e8 d7 bb c9 f8       	call   0xf8c9bc0f
  38:	4d 8b 2f             	mov    (%r15),%r13
  3b:	4c 89 e8             	mov    %r13,%rax
  3e:	48                   	rex.W
  3f:	c1                   	.byte 0xc1


***

If these findings have caused you to resend the series or submit a
separate fix, please add the following tag to your commit message:
  Tested-by: syzbot@syzkaller.appspotmail.com

---
This report is generated by a bot. It may contain errors.
syzbot ci engineers can be reached at syzkaller@googlegroups.com.

The email will later be sent to:
[almasrymina@google.com bobbyeshleman@gmail.com bobbyeshleman@meta.com dave=
m@davemloft.net dsahern@kernel.org edumazet@google.com horms@kernel.org kub=
a@kernel.org kuniyu@google.com linux-kernel@vger.kernel.org ncardwell@googl=
e.com netdev@vger.kernel.org pabeni@redhat.com sdf@fomichev.me willemb@goog=
le.com]

If the report looks fine to you, reply with:
#syz upstream

