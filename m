Received: from mail-il1-f197.google.com (mail-il1-f197.google.com [209.85.166.197])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 31F591D554
	for <syzbot@lists.linux.dev>; Wed,  3 Sep 2025 17:46:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.197
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756921594; cv=none; b=A3LCY89zI97/0Jp68+7HgHwoZGNU+aeR/kcXSdpEsVm9STBfs+hF+6FpMjeVDgfw/N6vWyPydcf4wp4aflHX5QMJMje3ubI07DISA27+a4qPYQ6G/mwgY6bP9sobrKJZXmHyKqFv1pP3AEuhLILj+KeM1wKZ1ezsWhYkQiY+R4I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756921594; c=relaxed/simple;
	bh=zZhZCXb/kDx+4A4UKV/f5yV//7oJoKKMGlRbg52zu0c=;
	h=MIME-Version:Date:In-Reply-To:Message-ID:Subject:From:To:Cc:
	 Content-Type; b=q3ZRWtBcMwSobejj7vBvZDl5GAcA8LRN1QdFyVHwYwHYQEbJvN7miGEeDzE2U+8mw6EnvUurrEYlnXrQKgROHl4gpTD0gHf7uuRTTHjbvnYs26hJf7Iy1Uo9kh2L7PwMXPozke1okcR2gl0tEUUIZBZTws2GnJPU3ALv5zUf6v4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com; arc=none smtp.client-ip=209.85.166.197
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com
Received: by mail-il1-f197.google.com with SMTP id e9e14a558f8ab-3ea2bd7b667so2465105ab.0
        for <syzbot@lists.linux.dev>; Wed, 03 Sep 2025 10:46:32 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1756921592; x=1757526392;
        h=cc:to:from:subject:message-id:in-reply-to:date:mime-version
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=dKSwqifOLdDaIbVTuf5YJyDDnSy1g3uyCxhGGW90rrQ=;
        b=n+7YR8sOKllmKur4X/Ne6hTCeDVOoo1mOJLTNr8k1zG+z9tjSk8kCskzGmFCRF+Js3
         hUqq6k0SyrT1yvFeIq2fa0wBK4kauCOaCFHx1zPYgeLHwsc76iGZVKH6MOZgyQvXNBkS
         aAV13t2P5EDVfgeZ8svdGY9/dyBfGfAYm1GPPrRhnB4AZMzlpXmDN4NpAoqUih8+V7JI
         Kx0RI4drTzm8KzBMID+mmECR22CtzTF9Dca7e0i8vL9fHLDaG8y//kftlQnO7mPKH/HA
         FBnXssmuIgvVVQobJoXVFFuV2I6DpoMsdMZyXxN2GaZIWKduaUR9j1YrEpv6xpXSFLhc
         zpcA==
X-Gm-Message-State: AOJu0YwBCtpX0J+Pr4qCDPaEp5HARcFrekzHaFEvFgBEuTuQx203Gcnz
	e5SfG+niTYKbA0uZb6J7yPvp2Zz+yloIYUyNaooGWhCKyGSgf9k6ZaCVDQKfEsYQ2tUb5EjA2pD
	uywKL9yQwvH7EasC8HRCQaZCZZNxt5Voy0t/BxIehfAWKZLMp+f+yKBtwkag=
X-Google-Smtp-Source: AGHT+IFFJxVR9s3LuLEmG7cWeFeZaUwXJ4lBSwQ+DRJx+m3dHv4u9mHDWmorhzFaF/E+dT/BaHFjmuVPM/5MJbbk4N6aQIQ64c7N
Precedence: bulk
X-Mailing-List: syzbot@lists.linux.dev
List-Id: <syzbot.lists.linux.dev>
List-Subscribe: <mailto:syzbot+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:syzbot+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Received: by 2002:a05:6e02:17c9:b0:3f0:dce:2550 with SMTP id
 e9e14a558f8ab-3f401be27a3mr241636105ab.19.1756921592288; Wed, 03 Sep 2025
 10:46:32 -0700 (PDT)
Date: Wed, 03 Sep 2025 10:46:32 -0700
In-Reply-To: <20250902-scratch-bobbyeshleman-devmem-tcp-token-upstream-v1-0-d946169b5550@meta.com>
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <68b87ef8.050a0220.3db4df.01fb.GAE@google.com>
Subject: [syzbot ci] Re: net: devmem: improve cpu cost of RX token management
From: syzbot ci <syzbot+ci4cf7c6dde1c8793c@syzkaller.appspotmail.com>
To: almasrymina@google.com, bobbyeshleman@gmail.com, bobbyeshleman@meta.com, 
	davem@davemloft.net, dsahern@kernel.org, edumazet@google.com, 
	horms@kernel.org, kuba@kernel.org, kuniyu@google.com, 
	linux-kernel@vger.kernel.org, ncardwell@google.com, netdev@vger.kernel.org, 
	pabeni@redhat.com, sdf@fomichev.me, willemb@google.com
Cc: syzbot@lists.linux.dev, syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"

syzbot ci has tested the following series

[v1] net: devmem: improve cpu cost of RX token management
https://lore.kernel.org/all/20250902-scratch-bobbyeshleman-devmem-tcp-token-upstream-v1-0-d946169b5550@meta.com
* [PATCH net-next 1/2] net: devmem: rename tx_vec to vec in dmabuf binding
* [PATCH net-next 2/2] net: devmem: use niov array for token management

and found the following issue:
general protection fault in sock_devmem_dontneed

Full report is available here:
https://ci.syzbot.org/series/c0dc7223-4222-461c-b04b-b6f0004c7509

***

general protection fault in sock_devmem_dontneed

tree:      net-next
URL:       https://kernel.googlesource.com/pub/scm/linux/kernel/git/netdev/net-next.git
base:      864ecc4a6dade82d3f70eab43dad0e277aa6fc78
arch:      amd64
compiler:  Debian clang version 20.1.8 (++20250708063551+0c9f909b7976-1~exp1~20250708183702.136), Debian LLD 20.1.8
config:    https://ci.syzbot.org/builds/6c521908-0a73-48bc-a0fd-2576cf868361/config
C repro:   https://ci.syzbot.org/findings/9374f388-d643-42ea-831b-872eb5000b3c/c_repro
syz repro: https://ci.syzbot.org/findings/9374f388-d643-42ea-831b-872eb5000b3c/syz_repro

Oops: general protection fault, probably for non-canonical address 0xdffffc0000000000: 0000 [#1] SMP KASAN PTI
KASAN: null-ptr-deref in range [0x0000000000000000-0x0000000000000007]
CPU: 0 UID: 0 PID: 5993 Comm: syz.0.17 Not tainted syzkaller #0 PREEMPT(full) 
Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS 1.16.2-debian-1.16.2-1 04/01/2014
RIP: 0010:sock_devmem_dontneed+0x3fd/0x960 net/core/sock.c:1112
Code: 8b 44 24 40 44 8b 28 44 03 6c 24 14 48 8b 44 24 20 42 80 3c 20 00 74 08 4c 89 ff e8 4d eb c9 f8 4d 8b 3f 4c 89 f8 48 c1 e8 03 <42> 80 3c 20 00 74 08 4c 89 ff e8 34 eb c9 f8 4d 8b 3f 4c 89 f8 48
RSP: 0018:ffffc90001c4fac0 EFLAGS: 00010246
RAX: 0000000000000000 RBX: 0000000000000000 RCX: 1ffff11004ddcfe0
RDX: ffff88801f6a8000 RSI: 0000000000000400 RDI: 0000000000000000
RBP: ffffc90001c4fc50 R08: ffffc90001c4fbdf R09: 0000000000000000
R10: ffffc90001c4fb60 R11: fffff52000389f7c R12: dffffc0000000000
R13: 00000000ffffffff R14: 0000000000000000 R15: 0000000000000000
FS:  000055558634d500(0000) GS:ffff8880b8614000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 0000001b30e63fff CR3: 0000000026b68000 CR4: 00000000000006f0
Call Trace:
 <TASK>
 sk_setsockopt+0x682/0x2dc0 net/core/sock.c:1302
 do_sock_setsockopt+0x11b/0x1b0 net/socket.c:2340
 __sys_setsockopt net/socket.c:2369 [inline]
 __do_sys_setsockopt net/socket.c:2375 [inline]
 __se_sys_setsockopt net/socket.c:2372 [inline]
 __x64_sys_setsockopt+0x13f/0x1b0 net/socket.c:2372
 do_syscall_x64 arch/x86/entry/syscall_64.c:63 [inline]
 do_syscall_64+0xfa/0x3b0 arch/x86/entry/syscall_64.c:94
 entry_SYSCALL_64_after_hwframe+0x77/0x7f
RIP: 0033:0x7fea2bb8ebe9
Code: ff ff c3 66 2e 0f 1f 84 00 00 00 00 00 0f 1f 40 00 48 89 f8 48 89 f7 48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 ff ff 73 01 c3 48 c7 c1 a8 ff ff ff f7 d8 64 89 01 48
RSP: 002b:00007ffc81c63348 EFLAGS: 00000246 ORIG_RAX: 0000000000000036
RAX: ffffffffffffffda RBX: 00007fea2bdc5fa0 RCX: 00007fea2bb8ebe9
RDX: 0000000000000050 RSI: 0000000000000001 RDI: 0000000000000003
RBP: 00007fea2bc11e19 R08: 0000000000000048 R09: 0000000000000000
R10: 0000200000000100 R11: 0000000000000246 R12: 0000000000000000
R13: 00007fea2bdc5fa0 R14: 00007fea2bdc5fa0 R15: 0000000000000005
 </TASK>
Modules linked in:
---[ end trace 0000000000000000 ]---
RIP: 0010:sock_devmem_dontneed+0x3fd/0x960 net/core/sock.c:1112
Code: 8b 44 24 40 44 8b 28 44 03 6c 24 14 48 8b 44 24 20 42 80 3c 20 00 74 08 4c 89 ff e8 4d eb c9 f8 4d 8b 3f 4c 89 f8 48 c1 e8 03 <42> 80 3c 20 00 74 08 4c 89 ff e8 34 eb c9 f8 4d 8b 3f 4c 89 f8 48
RSP: 0018:ffffc90001c4fac0 EFLAGS: 00010246
RAX: 0000000000000000 RBX: 0000000000000000 RCX: 1ffff11004ddcfe0
RDX: ffff88801f6a8000 RSI: 0000000000000400 RDI: 0000000000000000
RBP: ffffc90001c4fc50 R08: ffffc90001c4fbdf R09: 0000000000000000
R10: ffffc90001c4fb60 R11: fffff52000389f7c R12: dffffc0000000000
R13: 00000000ffffffff R14: 0000000000000000 R15: 0000000000000000
FS:  000055558634d500(0000) GS:ffff8880b8614000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 0000001b30e63fff CR3: 0000000026b68000 CR4: 00000000000006f0
----------------
Code disassembly (best guess):
   0:	8b 44 24 40          	mov    0x40(%rsp),%eax
   4:	44 8b 28             	mov    (%rax),%r13d
   7:	44 03 6c 24 14       	add    0x14(%rsp),%r13d
   c:	48 8b 44 24 20       	mov    0x20(%rsp),%rax
  11:	42 80 3c 20 00       	cmpb   $0x0,(%rax,%r12,1)
  16:	74 08                	je     0x20
  18:	4c 89 ff             	mov    %r15,%rdi
  1b:	e8 4d eb c9 f8       	call   0xf8c9eb6d
  20:	4d 8b 3f             	mov    (%r15),%r15
  23:	4c 89 f8             	mov    %r15,%rax
  26:	48 c1 e8 03          	shr    $0x3,%rax
* 2a:	42 80 3c 20 00       	cmpb   $0x0,(%rax,%r12,1) <-- trapping instruction
  2f:	74 08                	je     0x39
  31:	4c 89 ff             	mov    %r15,%rdi
  34:	e8 34 eb c9 f8       	call   0xf8c9eb6d
  39:	4d 8b 3f             	mov    (%r15),%r15
  3c:	4c 89 f8             	mov    %r15,%rax
  3f:	48                   	rex.W


***

If these findings have caused you to resend the series or submit a
separate fix, please add the following tag to your commit message:
  Tested-by: syzbot@syzkaller.appspotmail.com

---
This report is generated by a bot. It may contain errors.
syzbot ci engineers can be reached at syzkaller@googlegroups.com.
