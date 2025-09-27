Received: from mail-il1-f198.google.com (mail-il1-f198.google.com [209.85.166.198])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CF9C414B08A
	for <syzbot@lists.linux.dev>; Sat, 27 Sep 2025 06:00:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.198
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758952823; cv=none; b=gSWOUb5XkgVDFoOtjZjbhOltoUPvJiSRxI3/UpBIa7eZEKKLec4o3KSM8M7XsGSFSwsjxiNgUVra/tvUQ7e34IVPvkITUasU3SXQpA3fLgRTBfxM74/K2alxB3CPQc7/Adq46741S7bPWpBfBHyWFP/RYreGK+MtmA55Qhl7Rzc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758952823; c=relaxed/simple;
	bh=FVQqXZ6vvoXNmyMYata7NERxIppVX1MU+bw6AFoO/xc=;
	h=MIME-Version:Date:In-Reply-To:Message-ID:Subject:From:To:Cc:
	 Content-Type; b=AbfDwteUzPAZNnl3P1nBvSvhkeXqJbk9ZapZC9vcMYO4UKQQIr5MNsJ+M29vOnzeIqbYg4xouHRkUb3Tk0me6sXQywKh9vHan5uIfBUT1fxyVAgucOx96Iqda562AoN7YId8AxorSgIkqIfWKm3JhwCRKk48VdlJgNREejpklQ0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com; arc=none smtp.client-ip=209.85.166.198
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com
Received: by mail-il1-f198.google.com with SMTP id e9e14a558f8ab-426d38c1e8fso22819075ab.0
        for <syzbot@lists.linux.dev>; Fri, 26 Sep 2025 23:00:21 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1758952821; x=1759557621;
        h=cc:to:from:subject:message-id:in-reply-to:date:mime-version
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=QWqloIokgAjTlc/Iwy59kZ1QnAzpWW7VXmqR0dpPQns=;
        b=EcTljTPTR0Hz5OYZKNO7pzWoa3sGrHXA+sk7gsbd3wKvRgFVNmcZTPlI4sEFFQ2DIH
         ftqXbT1NrYYtMfSGe9/yYfjtI+bD9LJ9+FjwELwQcdEIgigM2elK1V5L+yajQVty7ZJc
         stdQuelPZ06oqTZF8X88x59PZLjFcOEBYwQpj8kj2KOlK93SSoUuUTkFwnM5f2g98ESL
         gUTdHCsNfA1zo2zCYgbQARbhGYUWWho+hYZoHGsA8kieHe3+uYcCB0TxJqbMPv7UWBqB
         7Bh1OU9XmkNWAsr3liWiQIyYXHQikzmkcrLwuvSE27PR/n50vwZhjC1Q8EEFPNqEO1to
         QM1w==
X-Gm-Message-State: AOJu0YzyEsACbVmx3f6dGC86+MhFWm9WtsQNu18GUihjI7xjXEAgEEU/
	Hw8BSuMumkw3AipL9MGqyGBoFgSKwIfmbmRc3AWOpBUftQjcp+nhULtxgNhrXGRc3BqENJzq5j9
	1mWmnnROmHSZSY2K41GwZcOnAL58xTYXuHRS3xlLR6t9b6igpb1seuEjIc3U=
X-Google-Smtp-Source: AGHT+IHe74HBd6XEftIHGctkYHXJNu2pVLYANpsk/N72/KgZxq1RUrUa6XMWAdCTD7RhQCvIKhavXgVuoTBzps71NWqb/YQd/ADv
Precedence: bulk
X-Mailing-List: syzbot@lists.linux.dev
List-Id: <syzbot.lists.linux.dev>
List-Subscribe: <mailto:syzbot+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:syzbot+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Received: by 2002:a05:6e02:218f:b0:405:5e08:a3e4 with SMTP id
 e9e14a558f8ab-425955c5585mr136861695ab.1.1758952820978; Fri, 26 Sep 2025
 23:00:20 -0700 (PDT)
Date: Fri, 26 Sep 2025 23:00:20 -0700
In-Reply-To: <20250926-scratch-bobbyeshleman-devmem-tcp-token-upstream-v4-0-39156563c3ea@meta.com>
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <68d77d74.a00a0220.102ee.000e.GAE@google.com>
Subject: [syzbot ci] Re: net: devmem: improve cpu cost of RX token management
From: syzbot ci <syzbot+ci88b77c4aee0f7057@syzkaller.appspotmail.com>
To: almasrymina@google.com, bobbyeshleman@gmail.com, bobbyeshleman@meta.com, 
	davem@davemloft.net, dsahern@kernel.org, edumazet@google.com, 
	horms@kernel.org, kuba@kernel.org, kuniyu@google.com, 
	linux-kernel@vger.kernel.org, ncardwell@google.com, netdev@vger.kernel.org, 
	pabeni@redhat.com, sdf@fomichev.me, willemb@google.com
Cc: syzbot@lists.linux.dev, syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"

syzbot ci has tested the following series

[v4] net: devmem: improve cpu cost of RX token management
https://lore.kernel.org/all/20250926-scratch-bobbyeshleman-devmem-tcp-token-upstream-v4-0-39156563c3ea@meta.com
* [PATCH net-next v4 1/2] net: devmem: rename tx_vec to vec in dmabuf binding
* [PATCH net-next v4 2/2] net: devmem: use niov array for token management

and found the following issue:
general protection fault in sock_devmem_dontneed

Full report is available here:
https://ci.syzbot.org/series/b8209bd4-e9f0-4c54-bad3-613e8431151b

***

general protection fault in sock_devmem_dontneed

tree:      net-next
URL:       https://kernel.googlesource.com/pub/scm/linux/kernel/git/netdev/net-next.git
base:      dc1dea796b197aba2c3cae25bfef45f4b3ad46fe
arch:      amd64
compiler:  Debian clang version 20.1.8 (++20250708063551+0c9f909b7976-1~exp1~20250708183702.136), Debian LLD 20.1.8
config:    https://ci.syzbot.org/builds/b4d90fd9-9fbe-4e17-8fc0-3d6603df09da/config
C repro:   https://ci.syzbot.org/findings/ce81b3c3-3db8-4643-9731-cbe331c65fdb/c_repro
syz repro: https://ci.syzbot.org/findings/ce81b3c3-3db8-4643-9731-cbe331c65fdb/syz_repro

Oops: general protection fault, probably for non-canonical address 0xdffffc0000000000: 0000 [#1] SMP KASAN PTI
KASAN: null-ptr-deref in range [0x0000000000000000-0x0000000000000007]
CPU: 1 UID: 0 PID: 5996 Comm: syz.0.17 Not tainted syzkaller #0 PREEMPT(full) 
Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS 1.16.2-debian-1.16.2-1 04/01/2014
RIP: 0010:sock_devmem_dontneed+0x372/0x920 net/core/sock.c:1113
Code: 48 44 8b 20 44 89 74 24 54 45 01 f4 48 8b 44 24 60 42 80 3c 28 00 74 08 48 89 df e8 e8 5a c9 f8 4c 8b 33 4c 89 f0 48 c1 e8 03 <42> 80 3c 28 00 74 08 4c 89 f7 e8 cf 5a c9 f8 4d 8b 3e 4c 89 f8 48
RSP: 0018:ffffc90002a1fac0 EFLAGS: 00010246
RAX: 0000000000000000 RBX: ffff88810a8ab710 RCX: 1ffff11023002f45
RDX: ffff88801b339cc0 RSI: 0000000000002000 RDI: 0000000000000000
RBP: ffffc90002a1fc50 R08: ffffc90002a1fbdf R09: 0000000000000000
R10: ffffc90002a1fb60 R11: fffff52000543f7c R12: 0000000000f07000
R13: dffffc0000000000 R14: 0000000000000000 R15: ffff88810a8ab710
FS:  000055556f85a500(0000) GS:ffff8881a3c3d000(0000) knlGS:0000000000000000
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
Code: ff ff c3 66 2e 0f 1f 84 00 00 00 00 00 0f 1f 40 00 48 89 f8 48 89 f7 48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 ff ff 73 01 c3 48 c7 c1 a8 ff ff ff f7 d8 64 89 01 48
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
Code: 48 44 8b 20 44 89 74 24 54 45 01 f4 48 8b 44 24 60 42 80 3c 28 00 74 08 48 89 df e8 e8 5a c9 f8 4c 8b 33 4c 89 f0 48 c1 e8 03 <42> 80 3c 28 00 74 08 4c 89 f7 e8 cf 5a c9 f8 4d 8b 3e 4c 89 f8 48
RSP: 0018:ffffc90002a1fac0 EFLAGS: 00010246
RAX: 0000000000000000 RBX: ffff88810a8ab710 RCX: 1ffff11023002f45
RDX: ffff88801b339cc0 RSI: 0000000000002000 RDI: 0000000000000000
RBP: ffffc90002a1fc50 R08: ffffc90002a1fbdf R09: 0000000000000000
R10: ffffc90002a1fb60 R11: fffff52000543f7c R12: 0000000000f07000
R13: dffffc0000000000 R14: 0000000000000000 R15: ffff88810a8ab710
FS:  000055556f85a500(0000) GS:ffff8881a3c3d000(0000) knlGS:0000000000000000
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
* 2a:	42 80 3c 28 00       	cmpb   $0x0,(%rax,%r13,1) <-- trapping instruction
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
