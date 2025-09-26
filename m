Received: from mail-il1-f198.google.com (mail-il1-f198.google.com [209.85.166.198])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CD8292A1CA
	for <syzbot@lists.linux.dev>; Fri, 26 Sep 2025 21:16:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.198
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758921397; cv=none; b=oK5bJJQprlknnE/N9yllIVVITNHLg8ICH/4Lks73HsTah3u6VqNMC0u0tREt1fAo/3uVq1tto1ktqRlCXcbs31taucTgGIOozyVdWiuJJvlNRUhuPONeJBl312wqQzxivPx52i0uWoUR53EUdCGSTvX9S95qd3so8WdVS5H8xDM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758921397; c=relaxed/simple;
	bh=YVZfcSmxltQN/FAcBPyerMu3TngKU7z3AmgGKIZYpB0=;
	h=MIME-Version:Date:Message-ID:Subject:From:To:Cc:Content-Type; b=srvB9dmwXGCCVmY/yn2YOO5A45Hxeg0+JOQxwjK+9I9yf5EwSbdqWXieeZhN6ym+4romhMRL0/dj4nD24TxDFKOsBAxOLOz4zEWRfQEUZQHjj2HkQUckhP5HvP0UAkAyyNMhYtCf6kprhO+9KeRDNCdKm4hc6L4nCE9Wf/vKVcQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com; arc=none smtp.client-ip=209.85.166.198
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com
Received: by mail-il1-f198.google.com with SMTP id e9e14a558f8ab-42590870dc0so68409065ab.3
        for <syzbot@lists.linux.dev>; Fri, 26 Sep 2025 14:16:35 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1758921395; x=1759526195;
        h=content-transfer-encoding:cc:to:from:subject:message-id:date
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=zM5X76JDZCf7K5+lyV4aaLKSZuGlvi+KfuIpetv8UcI=;
        b=fQp0+t8VEz0AKaKEYjraU4BzCY63B1l1McmjC6P1T6OZr3FxX+ByYgzsdgsPm3E1iD
         GWUNdlfe3At514VUqOzyrq9AXsC4YWCR1MPEtwVZ28CiW1eBZoHsmAOsngcWmyjLC6jK
         k4tGofG/VcpPYtLaRVqn7c4KHJuSRsTAtCmIzki+o2b5mrSqEOUR/PITFnV1zNQgbQQB
         shHjTdHrjv1SxoxX/GbPptt6OeZ7VwoAA5xNQo9he5NrK1lHzggRdo2uxmisniKOr+Ey
         U87gS2DRQmQ/5Up9tLs/OcNIkYwHqpcntBFZG4dw6AzITowa3AwoKezPOVKeYtrdn3wI
         6L4Q==
X-Gm-Message-State: AOJu0YzTIPUj5l2ahoE5/enEKrwXGUGaSJ6JGa3krG07Z6wJ2khRL920
	rtEUlcsoopqvZ24bw2uYG7liFYjQzuq8t1J1sGYTvorBNuYjdJbHxcWCC0oTrMeIBCNNfwcf7Rc
	gVzM4AE5awHkkH73L5aY3NtydD+PhsjwYMF1KImcV/ubl3BrX0pN3PXSqgB4=
X-Google-Smtp-Source: AGHT+IHMeZVD2pHYtfi4PLS3xeTTTla/jI6NQ1yvjdqbZ1pH/G+7glBAnhp/gtSJmwGHi73h6cf5WdfCRqsXZMWg2JdmRMUWRy+r
Precedence: bulk
X-Mailing-List: syzbot@lists.linux.dev
List-Id: <syzbot.lists.linux.dev>
List-Subscribe: <mailto:syzbot+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:syzbot+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Received: by 2002:a05:6e02:19ce:b0:425:7730:61b5 with SMTP id
 e9e14a558f8ab-425955ca97cmr139110465ab.4.1758921394977; Fri, 26 Sep 2025
 14:16:34 -0700 (PDT)
Date: Fri, 26 Sep 2025 14:16:34 -0700
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <68d702b2.050a0220.25d7ab.01c0.GAE@google.com>
Subject: [moderation/CI] Re: net: devmem: improve cpu cost of RX token management
From: syzbot ci <syzbot+ci91aff55081e4f959@syzkaller.appspotmail.com>
To: syzkaller-upstream-moderation@googlegroups.com
Cc: syzbot@lists.linux.dev
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

syzbot ci has tested the following series

[v4] net: devmem: improve cpu cost of RX token management
https://lore.kernel.org/all/20250926-scratch-bobbyeshleman-devmem-tcp-token=
-upstream-v4-0-39156563c3ea@meta.com
* [PATCH net-next v4 1/2] net: devmem: rename tx_vec to vec in dmabuf bindi=
ng
* [PATCH net-next v4 2/2] net: devmem: use niov array for token management

and found the following issue:
general protection fault in sock_devmem_dontneed

Full report is available here:
https://ci.syzbot.org/series/b8209bd4-e9f0-4c54-bad3-613e8431151b

***

general protection fault in sock_devmem_dontneed

tree:      net-next
URL:       https://kernel.googlesource.com/pub/scm/linux/kernel/git/netdev/=
net-next.git
base:      dc1dea796b197aba2c3cae25bfef45f4b3ad46fe
arch:      amd64
compiler:  Debian clang version 20.1.8 (++20250708063551+0c9f909b7976-1~exp=
1~20250708183702.136), Debian LLD 20.1.8
config:    https://ci.syzbot.org/builds/b4d90fd9-9fbe-4e17-8fc0-3d6603df09d=
a/config
C repro:   https://ci.syzbot.org/findings/ce81b3c3-3db8-4643-9731-cbe331c65=
fdb/c_repro
syz repro: https://ci.syzbot.org/findings/ce81b3c3-3db8-4643-9731-cbe331c65=
fdb/syz_repro

Oops: general protection fault, probably for non-canonical address 0xdffffc=
0000000000: 0000 [#1] SMP KASAN PTI
KASAN: null-ptr-deref in range [0x0000000000000000-0x0000000000000007]
CPU: 1 UID: 0 PID: 5996 Comm: syz.0.17 Not tainted syzkaller #0 PREEMPT(ful=
l)=20
Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS 1.16.2-debian-1.16=
.2-1 04/01/2014
RIP: 0010:sock_devmem_dontneed+0x372/0x920 net/core/sock.c:1113
Code: 48 44 8b 20 44 89 74 24 54 45 01 f4 48 8b 44 24 60 42 80 3c 28 00 74 =
08 48 89 df e8 e8 5a c9 f8 4c 8b 33 4c 89 f0 48 c1 e8 03 <42> 80 3c 28 00 7=
4 08 4c 89 f7 e8 cf 5a c9 f8 4d 8b 3e 4c 89 f8 48
RSP: 0018:ffffc90002a1fac0 EFLAGS: 00010246
RAX: 0000000000000000 RBX: ffff88810a8ab710 RCX: 1ffff11023002f45
RDX: ffff88801b339cc0 RSI: 0000000000002000 RDI: 0000000000000000
RBP: ffffc90002a1fc50 R08: ffffc90002a1fbdf R09: 0000000000000000
R10: ffffc90002a1fb60 R11: fffff52000543f7c R12: 0000000000f07000
R13: dffffc0000000000 R14: 0000000000000000 R15: ffff88810a8ab710
FS:  000055556f85a500(0000) GS:ffff8881a3c3d000(0000) knlGS:000000000000000=
0
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 00002000000a2000 CR3: 0000000024516000 CR4: 00000000000006f0
Call Trace:
 <TASK>
 sk_setsockopt+0x682/0x2dc0 net/core/sock.c:1304
 do_sock_setsockopt+0x11b/0x1b0 net/socket.c:2340
 __sys_setsockopt net/socket.c:2369 [inline]
 __do_sys_setsockopt net/socket.c:2375 [inline]
 __se_sys_setsockopt net/socket.c:2372 [inline]
 __x64_sys_setsockopt+0x13f/0x1b0 net/socket.c:2372
 do_syscall_x64 arch/x86/entry/syscall_64.c:63 [inline]
 do_syscall_64+0xfa/0x3b0 arch/x86/entry/syscall_64.c:94
 entry_SYSCALL_64_after_hwframe+0x77/0x7f
RIP: 0033:0x7fea0438ec29
Code: ff ff c3 66 2e 0f 1f 84 00 00 00 00 00 0f 1f 40 00 48 89 f8 48 89 f7 =
48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 ff f=
f 73 01 c3 48 c7 c1 a8 ff ff ff f7 d8 64 89 01 48
RSP: 002b:00007ffd04a8f368 EFLAGS: 00000246 ORIG_RAX: 0000000000000036
RAX: ffffffffffffffda RBX: 00007fea045d5fa0 RCX: 00007fea0438ec29
RDX: 0000000000000050 RSI: 0000000000000001 RDI: 0000000000000003
RBP: 00007fea04411e41 R08: 0000000000000010 R09: 0000000000000000
R10: 00002000000a2000 R11: 0000000000000246 R12: 0000000000000000
R13: 00007fea045d5fa0 R14: 00007fea045d5fa0 R15: 0000000000000005
 </TASK>
Modules linked in:
---[ end trace 0000000000000000 ]---
RIP: 0010:sock_devmem_dontneed+0x372/0x920 net/core/sock.c:1113
Code: 48 44 8b 20 44 89 74 24 54 45 01 f4 48 8b 44 24 60 42 80 3c 28 00 74 =
08 48 89 df e8 e8 5a c9 f8 4c 8b 33 4c 89 f0 48 c1 e8 03 <42> 80 3c 28 00 7=
4 08 4c 89 f7 e8 cf 5a c9 f8 4d 8b 3e 4c 89 f8 48
RSP: 0018:ffffc90002a1fac0 EFLAGS: 00010246
RAX: 0000000000000000 RBX: ffff88810a8ab710 RCX: 1ffff11023002f45
RDX: ffff88801b339cc0 RSI: 0000000000002000 RDI: 0000000000000000
RBP: ffffc90002a1fc50 R08: ffffc90002a1fbdf R09: 0000000000000000
R10: ffffc90002a1fb60 R11: fffff52000543f7c R12: 0000000000f07000
R13: dffffc0000000000 R14: 0000000000000000 R15: ffff88810a8ab710
FS:  000055556f85a500(0000) GS:ffff8881a3c3d000(0000) knlGS:000000000000000=
0
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 00002000000a2000 CR3: 0000000024516000 CR4: 00000000000006f0
----------------
Code disassembly (best guess):
   0:	48                   	rex.W
   1:	44 8b 20             	mov    (%rax),%r12d
   4:	44 89 74 24 54       	mov    %r14d,0x54(%rsp)
   9:	45 01 f4             	add    %r14d,%r12d
   c:	48 8b 44 24 60       	mov    0x60(%rsp),%rax
  11:	42 80 3c 28 00       	cmpb   $0x0,(%rax,%r13,1)
  16:	74 08                	je     0x20
  18:	48 89 df             	mov    %rbx,%rdi
  1b:	e8 e8 5a c9 f8       	call   0xf8c95b08
  20:	4c 8b 33             	mov    (%rbx),%r14
  23:	4c 89 f0             	mov    %r14,%rax
  26:	48 c1 e8 03          	shr    $0x3,%rax
* 2a:	42 80 3c 28 00       	cmpb   $0x0,(%rax,%r13,1) <-- trapping instruct=
ion
  2f:	74 08                	je     0x39
  31:	4c 89 f7             	mov    %r14,%rdi
  34:	e8 cf 5a c9 f8       	call   0xf8c95b08
  39:	4d 8b 3e             	mov    (%r14),%r15
  3c:	4c 89 f8             	mov    %r15,%rax
  3f:	48                   	rex.W


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

