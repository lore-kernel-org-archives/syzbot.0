Received: from mail-oo1-f71.google.com (mail-oo1-f71.google.com [209.85.161.71])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D19A7305E19
	for <syzbot@lists.linux.dev>; Mon,  9 Feb 2026 07:30:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.161.71
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770622214; cv=none; b=IdplkXKRRi8iATBVv+nHqpik56gBYwtZANc5+JE2AQFmD9E/OS13EYLqz7olp2nn4BHQ6Slhjh9TrOz1ldW9XaAkZaANBEpn2bfpvpNqFjDfr2vo+rT3Cex0IJMVO/Ej/0+KnfaZzwcHqOtmc+dG8s70mEz+L0UuruKdf0g9Uzs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770622214; c=relaxed/simple;
	bh=KBjTNSWERlmilHDPACfJJFaelG3/d+tYw7PbJAzJDiU=;
	h=MIME-Version:Date:In-Reply-To:Message-ID:Subject:From:To:Cc:
	 Content-Type; b=Qpvp6A5X7o+LHeJs0DElIOE27oXhTy1f0eHZt92/iYROHVM+Agf/JNPXyuxO8LuanKhkCudHDvl2n2EfjJ+SPQPykQVQZ9jjhN6cNGforNNXH2+Vupjxf3LXx9tzvGfiMT4XToot+1c8RcrlliKKVhUfTIO015uVyioNqSq2Z1s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com; arc=none smtp.client-ip=209.85.161.71
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com
Received: by mail-oo1-f71.google.com with SMTP id 006d021491bc7-662f738c3bfso14979097eaf.0
        for <syzbot@lists.linux.dev>; Sun, 08 Feb 2026 23:30:13 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1770622213; x=1771227013;
        h=cc:to:from:subject:message-id:in-reply-to:date:mime-version
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=wo9y2gnxwT1lAq+YK0l73/qrOfPXwyaLhEbP8EzcxA8=;
        b=oKOyBidmyje91IjBFEpE2bC1Zg+hs44DHlaqp9Xd6NR0PnYgQ6eOOpTlwUBcGvc6+S
         KPstt2qy9wjdHoNVHwBJkwTgyget09+NFpZji1GdIpoRWvHnJMK30TDKJoQebM/2rYWL
         U9bMM83sCoRhuOtUw+5r82BqmJdCrph3XlWQ50Eh4PY9LvqxWpuAei/eae94Mjt3pcoP
         hp086Pl+iZIoaLL7CwSs4c9BCvJA062Nk7+oewJhbSA8M8SDw4flDo+elBTZ6zMt6Ard
         lKFkrWZyeEUthfOTpDeR91OZGrUd8fA/sJ9QO8Eu5bp1tOaFcsy04vD50cqyxMF1DVfQ
         vh8g==
X-Gm-Message-State: AOJu0YzD6olxwnbNqzDMJjPkE7ATY1Du51QslrY+vi0UOZged4xwYUE9
	YQ3lN7ya5jnJGwAp2TOo2cIEqEBrq/2Ngcczz86DIV8HvVh1OCHAloRJ5NZBFE+W7dnXomm+UaW
	bVTgrdZDsMt9Ch54YMkL++SHhPOLpqBHZ8Gr38oa2ug4iwlxrw3kb/D1RaP4=
Precedence: bulk
X-Mailing-List: syzbot@lists.linux.dev
List-Id: <syzbot.lists.linux.dev>
List-Subscribe: <mailto:syzbot+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:syzbot+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Received: by 2002:a05:6820:617:b0:662:f90e:cdf2 with SMTP id
 006d021491bc7-66d09cabe78mr5100305eaf.12.1770622212888; Sun, 08 Feb 2026
 23:30:12 -0800 (PST)
Date: Sun, 08 Feb 2026 23:30:12 -0800
In-Reply-To: <20260209015111.28144-1-yangfeng59949@163.com>
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <69898d04.050a0220.3b3015.0070.GAE@google.com>
Subject: [syzbot ci] Re: bpf: test_run: Fix the null pointer dereference issue
 in bpf_lwt_xmit_push_encap
From: syzbot ci <syzbot+cid20e3a9789516928@syzkaller.appspotmail.com>
To: andrii@kernel.org, ast@kernel.org, bpf@vger.kernel.org, 
	daniel@iogearbox.net, davem@davemloft.net, edumazet@google.com, 
	horms@kernel.org, kuba@kernel.org, linux-kernel@vger.kernel.org, 
	netdev@vger.kernel.org, pabeni@redhat.com, yangfeng59949@163.com
Cc: syzbot@lists.linux.dev, syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"

syzbot ci has tested the following series

[v4] bpf: test_run: Fix the null pointer dereference issue in bpf_lwt_xmit_push_encap
https://lore.kernel.org/all/20260209015111.28144-1-yangfeng59949@163.com
* [PATCH v4] bpf: test_run: Fix the null pointer dereference issue in bpf_lwt_xmit_push_encap

and found the following issues:
* general protection fault in ip6_tnl_xmit
* general protection fault in tnl_update_pmtu
* general protection fault in wg_xmit
* general protection fault in xfrm_lookup_with_ifid

Full report is available here:
https://ci.syzbot.org/series/af38a4c5-943d-44d2-91e6-299e4e0a94db

***

general protection fault in ip6_tnl_xmit

tree:      bpf-next
URL:       https://kernel.googlesource.com/pub/scm/linux/kernel/git/bpf/bpf-next.git
base:      db975debcb8c4cd367a78811bc1ba84c83f854bd
arch:      amd64
compiler:  Debian clang version 21.1.8 (++20251221033036+2078da43e25a-1~exp1~20251221153213.50), Debian LLD 21.1.8
config:    https://ci.syzbot.org/builds/c4ef1868-7d17-40c4-b5a7-b2d7bec3a6fe/config
C repro:   https://ci.syzbot.org/findings/311bc7a0-3bf0-490c-b561-a21f38f4d8e9/c_repro
syz repro: https://ci.syzbot.org/findings/311bc7a0-3bf0-490c-b561-a21f38f4d8e9/syz_repro

Oops: general protection fault, probably for non-canonical address 0xdffffc000000000d: 0000 [#1] SMP KASAN PTI
KASAN: null-ptr-deref in range [0x0000000000000068-0x000000000000006f]
CPU: 1 UID: 0 PID: 5991 Comm: syz.0.17 Not tainted syzkaller #0 PREEMPT(full) 
Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS 1.16.2-debian-1.16.2-1 04/01/2014
RIP: 0010:dst_neigh_lookup include/net/dst.h:404 [inline]
RIP: 0010:ip6_tnl_xmit+0x14a1/0x2af0 net/ipv6/ip6_tunnel.c:1123
Code: 74 12 4c 89 ef e8 af d8 ea f7 48 ba 00 00 00 00 00 fc ff df 4d 01 f4 49 83 c4 18 4d 8b 6d 00 49 83 c5 68 4c 89 e8 48 c1 e8 03 <80> 3c 10 00 74 08 4c 89 ef e8 81 d8 ea f7 4d 8b 5d 00 4c 89 ff 31
RSP: 0018:ffffc90003976e60 EFLAGS: 00010202
RAX: 000000000000000d RBX: 1ffff1102e6c7d07 RCX: ffff88810b2c57c0
RDX: dffffc0000000000 RSI: 0000000000000000 RDI: 0000000000000000
RBP: ffffc90003977028 R08: ffff88810b2c57c0 R09: 0000000000000002
R10: 000000000000dd86 R11: 0000000000000000 R12: ffff88816a0ce066
R13: 0000000000000068 R14: ffff88816a0ce000 R15: ffffc90003977ba0
FS:  000055555f394500(0000) GS:ffff8882a9927000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 0000001b30263fff CR3: 000000010d832000 CR4: 00000000000006f0
Call Trace:
 <TASK>
 ipxip6_tnl_xmit net/ipv6/ip6_tunnel.c:1400 [inline]
 ip6_tnl_start_xmit+0xc79/0x11d0 net/ipv6/ip6_tunnel.c:1448
 __netdev_start_xmit include/linux/netdevice.h:5273 [inline]
 netdev_start_xmit include/linux/netdevice.h:5282 [inline]
 xmit_one net/core/dev.c:3853 [inline]
 dev_hard_start_xmit+0x2cd/0x7f0 net/core/dev.c:3869
 __dev_queue_xmit+0x14dd/0x32a0 net/core/dev.c:4819
 dev_queue_xmit include/linux/netdevice.h:3381 [inline]
 __bpf_tx_skb+0x18e/0x260 net/core/filter.c:2153
 ____bpf_clone_redirect net/core/filter.c:2487 [inline]
 bpf_clone_redirect+0x313/0x4b0 net/core/filter.c:2450
 bpf_prog_2f59963de350c2d2+0x5e/0x67
 bpf_dispatcher_nop_func include/linux/bpf.h:1402 [inline]
 __bpf_prog_run include/linux/filter.h:723 [inline]
 bpf_prog_run include/linux/filter.h:730 [inline]
 bpf_test_run+0x354/0x830 net/bpf/test_run.c:423
 bpf_prog_test_run_skb+0x13b4/0x1e00 net/bpf/test_run.c:1168
 bpf_prog_test_run+0x2c7/0x340 kernel/bpf/syscall.c:4721
 __sys_bpf+0x643/0x950 kernel/bpf/syscall.c:6246
 __do_sys_bpf kernel/bpf/syscall.c:6341 [inline]
 __se_sys_bpf kernel/bpf/syscall.c:6339 [inline]
 __x64_sys_bpf+0x7c/0x90 kernel/bpf/syscall.c:6339
 do_syscall_x64 arch/x86/entry/syscall_64.c:63 [inline]
 do_syscall_64+0xe2/0xf80 arch/x86/entry/syscall_64.c:94
 entry_SYSCALL_64_after_hwframe+0x77/0x7f
RIP: 0033:0x7ff39439acb9
Code: ff c3 66 2e 0f 1f 84 00 00 00 00 00 0f 1f 44 00 00 48 89 f8 48 89 f7 48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 ff ff 73 01 c3 48 c7 c1 e8 ff ff ff f7 d8 64 89 01 48
RSP: 002b:00007ffc03f9fef8 EFLAGS: 00000246 ORIG_RAX: 0000000000000141
RAX: ffffffffffffffda RBX: 00007ff394615fa0 RCX: 00007ff39439acb9
RDX: 0000000000000028 RSI: 00002000000000c0 RDI: 000000000000000a
RBP: 00007ff394408bf7 R08: 0000000000000000 R09: 0000000000000000
R10: 0000000000000000 R11: 0000000000000246 R12: 0000000000000000
R13: 00007ff394615fac R14: 00007ff394615fa0 R15: 00007ff394615fa0
 </TASK>
Modules linked in:
---[ end trace 0000000000000000 ]---
RIP: 0010:dst_neigh_lookup include/net/dst.h:404 [inline]
RIP: 0010:ip6_tnl_xmit+0x14a1/0x2af0 net/ipv6/ip6_tunnel.c:1123
Code: 74 12 4c 89 ef e8 af d8 ea f7 48 ba 00 00 00 00 00 fc ff df 4d 01 f4 49 83 c4 18 4d 8b 6d 00 49 83 c5 68 4c 89 e8 48 c1 e8 03 <80> 3c 10 00 74 08 4c 89 ef e8 81 d8 ea f7 4d 8b 5d 00 4c 89 ff 31
RSP: 0018:ffffc90003976e60 EFLAGS: 00010202
RAX: 000000000000000d RBX: 1ffff1102e6c7d07 RCX: ffff88810b2c57c0
RDX: dffffc0000000000 RSI: 0000000000000000 RDI: 0000000000000000
RBP: ffffc90003977028 R08: ffff88810b2c57c0 R09: 0000000000000002
R10: 000000000000dd86 R11: 0000000000000000 R12: ffff88816a0ce066
R13: 0000000000000068 R14: ffff88816a0ce000 R15: ffffc90003977ba0
FS:  000055555f394500(0000) GS:ffff8882a9927000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 0000001b30263fff CR3: 000000010d832000 CR4: 00000000000006f0
----------------
Code disassembly (best guess):
   0:	74 12                	je     0x14
   2:	4c 89 ef             	mov    %r13,%rdi
   5:	e8 af d8 ea f7       	call   0xf7ead8b9
   a:	48 ba 00 00 00 00 00 	movabs $0xdffffc0000000000,%rdx
  11:	fc ff df
  14:	4d 01 f4             	add    %r14,%r12
  17:	49 83 c4 18          	add    $0x18,%r12
  1b:	4d 8b 6d 00          	mov    0x0(%r13),%r13
  1f:	49 83 c5 68          	add    $0x68,%r13
  23:	4c 89 e8             	mov    %r13,%rax
  26:	48 c1 e8 03          	shr    $0x3,%rax
* 2a:	80 3c 10 00          	cmpb   $0x0,(%rax,%rdx,1) <-- trapping instruction
  2e:	74 08                	je     0x38
  30:	4c 89 ef             	mov    %r13,%rdi
  33:	e8 81 d8 ea f7       	call   0xf7ead8b9
  38:	4d 8b 5d 00          	mov    0x0(%r13),%r11
  3c:	4c 89 ff             	mov    %r15,%rdi
  3f:	31                   	.byte 0x31


***

general protection fault in tnl_update_pmtu

tree:      bpf-next
URL:       https://kernel.googlesource.com/pub/scm/linux/kernel/git/bpf/bpf-next.git
base:      db975debcb8c4cd367a78811bc1ba84c83f854bd
arch:      amd64
compiler:  Debian clang version 21.1.8 (++20251221033036+2078da43e25a-1~exp1~20251221153213.50), Debian LLD 21.1.8
config:    https://ci.syzbot.org/builds/c4ef1868-7d17-40c4-b5a7-b2d7bec3a6fe/config
C repro:   https://ci.syzbot.org/findings/78a52206-e4f0-4a95-a881-32bbaab25810/c_repro
syz repro: https://ci.syzbot.org/findings/78a52206-e4f0-4a95-a881-32bbaab25810/syz_repro

Oops: general protection fault, probably for non-canonical address 0xdffffc000000000a: 0000 [#1] SMP KASAN PTI
KASAN: null-ptr-deref in range [0x0000000000000050-0x0000000000000057]
CPU: 0 UID: 0 PID: 5980 Comm: syz.0.17 Not tainted syzkaller #0 PREEMPT(full) 
Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS 1.16.2-debian-1.16.2-1 04/01/2014
RIP: 0010:skb_dst_update_pmtu_no_confirm include/net/dst.h:565 [inline]
RIP: 0010:tnl_update_pmtu+0x52b/0x1190 net/ipv4/ip_tunnel.c:533
Code: c1 e8 03 42 80 3c 38 00 74 08 48 89 df e8 ad 38 2a f8 4c 8b 3b 49 83 c7 50 4c 89 f8 48 c1 e8 03 48 b9 00 00 00 00 00 fc ff df <80> 3c 08 00 74 08 4c 89 ff e8 87 38 2a f8 4d 8b 3f 4d 85 ff 8b 5c
RSP: 0018:ffffc90003d56e28 EFLAGS: 00010206
RAX: 000000000000000a RBX: ffffc90003d57ba8 RCX: dffffc0000000000
RDX: 0000000000000000 RSI: ffffc90003d57ba0 RDI: 0000000000000000
RBP: ffffc90003d57ba0 R08: ffffffff89db4393 R09: ffffffff8e35a3a0
R10: ffffc90003d56de0 R11: fffff520007aadbe R12: ffff88816a305380
R13: ffff88816a3053d8 R14: 1ffff1102d460a7b R15: 0000000000000050
FS:  000055559418b500(0000) GS:ffff88818e327000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 0000001b30863fff CR3: 00000001bea06000 CR4: 00000000000006f0
Call Trace:
 <TASK>
 ip_tunnel_xmit+0xd36/0x2430 net/ipv4/ip_tunnel.c:805
 __gre_xmit net/ipv4/ip_gre.c:490 [inline]
 ipgre_xmit+0x8e6/0xc60 net/ipv4/ip_gre.c:694
 __netdev_start_xmit include/linux/netdevice.h:5273 [inline]
 netdev_start_xmit include/linux/netdevice.h:5282 [inline]
 xmit_one net/core/dev.c:3853 [inline]
 dev_hard_start_xmit+0x2cd/0x7f0 net/core/dev.c:3869
 __dev_queue_xmit+0x14dd/0x32a0 net/core/dev.c:4819
 dev_queue_xmit include/linux/netdevice.h:3381 [inline]
 __bpf_tx_skb+0x18e/0x260 net/core/filter.c:2153
 ____bpf_clone_redirect net/core/filter.c:2487 [inline]
 bpf_clone_redirect+0x313/0x4b0 net/core/filter.c:2450
 bpf_prog_7c64685fc60f7d44+0x5f/0x68
 bpf_dispatcher_nop_func include/linux/bpf.h:1402 [inline]
 __bpf_prog_run include/linux/filter.h:723 [inline]
 bpf_prog_run include/linux/filter.h:730 [inline]
 bpf_test_run+0x354/0x830 net/bpf/test_run.c:423
 bpf_prog_test_run_skb+0x13b4/0x1e00 net/bpf/test_run.c:1168
 bpf_prog_test_run+0x2c7/0x340 kernel/bpf/syscall.c:4721
 __sys_bpf+0x643/0x950 kernel/bpf/syscall.c:6246
 __do_sys_bpf kernel/bpf/syscall.c:6341 [inline]
 __se_sys_bpf kernel/bpf/syscall.c:6339 [inline]
 __x64_sys_bpf+0x7c/0x90 kernel/bpf/syscall.c:6339
 do_syscall_x64 arch/x86/entry/syscall_64.c:63 [inline]
 do_syscall_64+0xe2/0xf80 arch/x86/entry/syscall_64.c:94
 entry_SYSCALL_64_after_hwframe+0x77/0x7f
RIP: 0033:0x7f6668d9acb9
Code: ff c3 66 2e 0f 1f 84 00 00 00 00 00 0f 1f 44 00 00 48 89 f8 48 89 f7 48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 ff ff 73 01 c3 48 c7 c1 e8 ff ff ff f7 d8 64 89 01 48
RSP: 002b:00007ffcdef544a8 EFLAGS: 00000246 ORIG_RAX: 0000000000000141
RAX: ffffffffffffffda RBX: 00007f6669015fa0 RCX: 00007f6668d9acb9
RDX: 000000000000002c RSI: 0000200000000080 RDI: 000000000000000a
RBP: 00007f6668e08bf7 R08: 0000000000000000 R09: 0000000000000000
R10: 0000000000000000 R11: 0000000000000246 R12: 0000000000000000
R13: 00007f6669015fac R14: 00007f6669015fa0 R15: 00007f6669015fa0
 </TASK>
Modules linked in:
---[ end trace 0000000000000000 ]---
RIP: 0010:skb_dst_update_pmtu_no_confirm include/net/dst.h:565 [inline]
RIP: 0010:tnl_update_pmtu+0x52b/0x1190 net/ipv4/ip_tunnel.c:533
Code: c1 e8 03 42 80 3c 38 00 74 08 48 89 df e8 ad 38 2a f8 4c 8b 3b 49 83 c7 50 4c 89 f8 48 c1 e8 03 48 b9 00 00 00 00 00 fc ff df <80> 3c 08 00 74 08 4c 89 ff e8 87 38 2a f8 4d 8b 3f 4d 85 ff 8b 5c
RSP: 0018:ffffc90003d56e28 EFLAGS: 00010206
RAX: 000000000000000a RBX: ffffc90003d57ba8 RCX: dffffc0000000000
RDX: 0000000000000000 RSI: ffffc90003d57ba0 RDI: 0000000000000000
RBP: ffffc90003d57ba0 R08: ffffffff89db4393 R09: ffffffff8e35a3a0
R10: ffffc90003d56de0 R11: fffff520007aadbe R12: ffff88816a305380
R13: ffff88816a3053d8 R14: 1ffff1102d460a7b R15: 0000000000000050
FS:  000055559418b500(0000) GS:ffff88818e327000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 0000001b30863fff CR3: 00000001bea06000 CR4: 00000000000006f0
----------------
Code disassembly (best guess):
   0:	c1 e8 03             	shr    $0x3,%eax
   3:	42 80 3c 38 00       	cmpb   $0x0,(%rax,%r15,1)
   8:	74 08                	je     0x12
   a:	48 89 df             	mov    %rbx,%rdi
   d:	e8 ad 38 2a f8       	call   0xf82a38bf
  12:	4c 8b 3b             	mov    (%rbx),%r15
  15:	49 83 c7 50          	add    $0x50,%r15
  19:	4c 89 f8             	mov    %r15,%rax
  1c:	48 c1 e8 03          	shr    $0x3,%rax
  20:	48 b9 00 00 00 00 00 	movabs $0xdffffc0000000000,%rcx
  27:	fc ff df
* 2a:	80 3c 08 00          	cmpb   $0x0,(%rax,%rcx,1) <-- trapping instruction
  2e:	74 08                	je     0x38
  30:	4c 89 ff             	mov    %r15,%rdi
  33:	e8 87 38 2a f8       	call   0xf82a38bf
  38:	4d 8b 3f             	mov    (%r15),%r15
  3b:	4d 85 ff             	test   %r15,%r15
  3e:	8b                   	.byte 0x8b
  3f:	5c                   	pop    %rsp


***

general protection fault in wg_xmit

tree:      bpf-next
URL:       https://kernel.googlesource.com/pub/scm/linux/kernel/git/bpf/bpf-next.git
base:      db975debcb8c4cd367a78811bc1ba84c83f854bd
arch:      amd64
compiler:  Debian clang version 21.1.8 (++20251221033036+2078da43e25a-1~exp1~20251221153213.50), Debian LLD 21.1.8
config:    https://ci.syzbot.org/builds/c4ef1868-7d17-40c4-b5a7-b2d7bec3a6fe/config
C repro:   https://ci.syzbot.org/findings/9650e699-cf43-4d3b-841d-ae1a23f976f0/c_repro
syz repro: https://ci.syzbot.org/findings/9650e699-cf43-4d3b-841d-ae1a23f976f0/syz_repro

Oops: general protection fault, probably for non-canonical address 0xdffffc0000000004: 0000 [#1] SMP KASAN PTI
KASAN: null-ptr-deref in range [0x0000000000000020-0x0000000000000027]
CPU: 0 UID: 0 PID: 5985 Comm: syz.0.17 Not tainted syzkaller #0 PREEMPT(full) 
Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS 1.16.2-debian-1.16.2-1 04/01/2014
RIP: 0010:dst_mtu include/net/dst.h:219 [inline]
RIP: 0010:wg_xmit+0x355/0xf70 drivers/net/wireguard/device.c:173
Code: 00 fc ff df 80 3c 08 00 74 08 4c 89 ff e8 83 84 d9 fb 4d 8b 3f 49 83 c7 20 4c 89 f8 48 c1 e8 03 48 b9 00 00 00 00 00 fc ff df <80> 3c 08 00 74 08 4c 89 ff e8 5d 84 d9 fb 4d 8b 3f 49 81 ff e0 38
RSP: 0018:ffffc90003cc7060 EFLAGS: 00010202
RAX: 0000000000000004 RBX: ffffc90003cc7ba0 RCX: dffffc0000000000
RDX: 0000000000000000 RSI: 0000000000000000 RDI: 0000000000000000
RBP: ffffc90003cc7190 R08: ffffffff8fced577 R09: 1ffffffff1f9daae
R10: dffffc0000000000 R11: fffffbfff1f9daaf R12: ffffc90003cc70c0
R13: 1ffff1102ebe283b R14: ffff888175f14180 R15: 0000000000000020
FS:  00005555734f8500(0000) GS:ffff88818e327000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 0000001b30663fff CR3: 00000001704ae000 CR4: 00000000000006f0
Call Trace:
 <TASK>
 __netdev_start_xmit include/linux/netdevice.h:5273 [inline]
 netdev_start_xmit include/linux/netdevice.h:5282 [inline]
 xmit_one net/core/dev.c:3853 [inline]
 dev_hard_start_xmit+0x2cd/0x7f0 net/core/dev.c:3869
 __dev_queue_xmit+0x14dd/0x32a0 net/core/dev.c:4819
 dev_queue_xmit include/linux/netdevice.h:3381 [inline]
 __bpf_tx_skb+0x18e/0x260 net/core/filter.c:2153
 ____bpf_clone_redirect net/core/filter.c:2487 [inline]
 bpf_clone_redirect+0x313/0x4b0 net/core/filter.c:2450
 bpf_prog_bd919e7baf24f63c+0x5f/0x68
 bpf_dispatcher_nop_func include/linux/bpf.h:1402 [inline]
 __bpf_prog_run include/linux/filter.h:723 [inline]
 bpf_prog_run include/linux/filter.h:730 [inline]
 bpf_test_run+0x354/0x830 net/bpf/test_run.c:423
 bpf_prog_test_run_skb+0x13b4/0x1e00 net/bpf/test_run.c:1168
 bpf_prog_test_run+0x2c7/0x340 kernel/bpf/syscall.c:4721
 __sys_bpf+0x643/0x950 kernel/bpf/syscall.c:6246
 __do_sys_bpf kernel/bpf/syscall.c:6341 [inline]
 __se_sys_bpf kernel/bpf/syscall.c:6339 [inline]
 __x64_sys_bpf+0x7c/0x90 kernel/bpf/syscall.c:6339
 do_syscall_x64 arch/x86/entry/syscall_64.c:63 [inline]
 do_syscall_64+0xe2/0xf80 arch/x86/entry/syscall_64.c:94
 entry_SYSCALL_64_after_hwframe+0x77/0x7f
RIP: 0033:0x7fc57899acb9
Code: ff c3 66 2e 0f 1f 84 00 00 00 00 00 0f 1f 44 00 00 48 89 f8 48 89 f7 48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 ff ff 73 01 c3 48 c7 c1 e8 ff ff ff f7 d8 64 89 01 48
RSP: 002b:00007ffd806bfbf8 EFLAGS: 00000246 ORIG_RAX: 0000000000000141
RAX: ffffffffffffffda RBX: 00007fc578c15fa0 RCX: 00007fc57899acb9
RDX: 0000000000000050 RSI: 0000200000000080 RDI: 000000000000000a
RBP: 00007fc578a08bf7 R08: 0000000000000000 R09: 0000000000000000
R10: 0000000000000000 R11: 0000000000000246 R12: 0000000000000000
R13: 00007fc578c15fac R14: 00007fc578c15fa0 R15: 00007fc578c15fa0
 </TASK>
Modules linked in:
---[ end trace 0000000000000000 ]---
RIP: 0010:dst_mtu include/net/dst.h:219 [inline]
RIP: 0010:wg_xmit+0x355/0xf70 drivers/net/wireguard/device.c:173
Code: 00 fc ff df 80 3c 08 00 74 08 4c 89 ff e8 83 84 d9 fb 4d 8b 3f 49 83 c7 20 4c 89 f8 48 c1 e8 03 48 b9 00 00 00 00 00 fc ff df <80> 3c 08 00 74 08 4c 89 ff e8 5d 84 d9 fb 4d 8b 3f 49 81 ff e0 38
RSP: 0018:ffffc90003cc7060 EFLAGS: 00010202
RAX: 0000000000000004 RBX: ffffc90003cc7ba0 RCX: dffffc0000000000
RDX: 0000000000000000 RSI: 0000000000000000 RDI: 0000000000000000
RBP: ffffc90003cc7190 R08: ffffffff8fced577 R09: 1ffffffff1f9daae
R10: dffffc0000000000 R11: fffffbfff1f9daaf R12: ffffc90003cc70c0
R13: 1ffff1102ebe283b R14: ffff888175f14180 R15: 0000000000000020
FS:  00005555734f8500(0000) GS:ffff88818e327000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 0000001b30663fff CR3: 00000001704ae000 CR4: 00000000000006f0
----------------
Code disassembly (best guess), 3 bytes skipped:
   0:	df 80 3c 08 00 74    	filds  0x7400083c(%rax)
   6:	08 4c 89 ff          	or     %cl,-0x1(%rcx,%rcx,4)
   a:	e8 83 84 d9 fb       	call   0xfbd98492
   f:	4d 8b 3f             	mov    (%r15),%r15
  12:	49 83 c7 20          	add    $0x20,%r15
  16:	4c 89 f8             	mov    %r15,%rax
  19:	48 c1 e8 03          	shr    $0x3,%rax
  1d:	48 b9 00 00 00 00 00 	movabs $0xdffffc0000000000,%rcx
  24:	fc ff df
* 27:	80 3c 08 00          	cmpb   $0x0,(%rax,%rcx,1) <-- trapping instruction
  2b:	74 08                	je     0x35
  2d:	4c 89 ff             	mov    %r15,%rdi
  30:	e8 5d 84 d9 fb       	call   0xfbd98492
  35:	4d 8b 3f             	mov    (%r15),%r15
  38:	49                   	rex.WB
  39:	81                   	.byte 0x81
  3a:	ff e0                	jmp    *%rax
  3c:	38                   	.byte 0x38


***

general protection fault in xfrm_lookup_with_ifid

tree:      bpf-next
URL:       https://kernel.googlesource.com/pub/scm/linux/kernel/git/bpf/bpf-next.git
base:      db975debcb8c4cd367a78811bc1ba84c83f854bd
arch:      amd64
compiler:  Debian clang version 21.1.8 (++20251221033036+2078da43e25a-1~exp1~20251221153213.50), Debian LLD 21.1.8
config:    https://ci.syzbot.org/builds/c4ef1868-7d17-40c4-b5a7-b2d7bec3a6fe/config
C repro:   https://ci.syzbot.org/findings/2ae3c5a4-d593-4385-8e69-f77a40c2382d/c_repro
syz repro: https://ci.syzbot.org/findings/2ae3c5a4-d593-4385-8e69-f77a40c2382d/syz_repro

Oops: general protection fault, probably for non-canonical address 0xdffffc0000000000: 0000 [#1] SMP KASAN PTI
KASAN: null-ptr-deref in range [0x0000000000000000-0x0000000000000007]
CPU: 0 UID: 0 PID: 5978 Comm: syz.0.17 Not tainted syzkaller #0 PREEMPT(full) 
Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS 1.16.2-debian-1.16.2-1 04/01/2014
RIP: 0010:xfrm_lookup_with_ifid+0xe1/0x1af0 net/xfrm/xfrm_policy.c:3181
Code: 24 20 4d 8d 66 08 4c 89 e0 48 c1 e8 03 4d 89 ee 42 80 3c 28 00 74 08 4c 89 e7 e8 5a 1f 17 f8 4d 8b 24 24 4c 89 e0 48 c1 e8 03 <42> 0f b6 04 30 84 c0 0f 85 94 17 00 00 41 0f b7 04 24 89 44 24 28
RSP: 0018:ffffc900045f6ea0 EFLAGS: 00010246
RAX: 0000000000000000 RBX: ffffc900045f6f40 RCX: 0000000000000000
RDX: 0000000000000000 RSI: 0000000000000000 RDI: ffffc900045f6f50
RBP: ffffc900045f6fb8 R08: ffffc900045f6f4f R09: 0000000000000000
R10: ffffc900045f6f40 R11: fffff520008bedea R12: 0000000000000000
R13: dffffc0000000000 R14: dffffc0000000000 R15: 0000000000000000
FS:  00005555873db500(0000) GS:ffff88818e327000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 0000001b2fa63fff CR3: 000000016e128000 CR4: 00000000000006f0
Call Trace:
 <TASK>
 xfrm_lookup net/xfrm/xfrm_policy.c:3336 [inline]
 xfrm_lookup_route+0x3c/0x1c0 net/xfrm/xfrm_policy.c:3347
 vti_xmit net/ipv4/ip_vti.c:217 [inline]
 vti_tunnel_xmit+0x48e/0x18f0 net/ipv4/ip_vti.c:307
 __netdev_start_xmit include/linux/netdevice.h:5273 [inline]
 netdev_start_xmit include/linux/netdevice.h:5282 [inline]
 xmit_one net/core/dev.c:3853 [inline]
 dev_hard_start_xmit+0x2cd/0x7f0 net/core/dev.c:3869
 __dev_queue_xmit+0x14dd/0x32a0 net/core/dev.c:4819
 dev_queue_xmit include/linux/netdevice.h:3381 [inline]
 __bpf_tx_skb+0x18e/0x260 net/core/filter.c:2153
 ____bpf_clone_redirect net/core/filter.c:2487 [inline]
 bpf_clone_redirect+0x313/0x4b0 net/core/filter.c:2450
 bpf_prog_e16758452f539c38+0x5f/0x68
 bpf_dispatcher_nop_func include/linux/bpf.h:1402 [inline]
 __bpf_prog_run include/linux/filter.h:723 [inline]
 bpf_prog_run include/linux/filter.h:730 [inline]
 bpf_test_run+0x354/0x830 net/bpf/test_run.c:423
 bpf_prog_test_run_skb+0x13b4/0x1e00 net/bpf/test_run.c:1168
 bpf_prog_test_run+0x2c7/0x340 kernel/bpf/syscall.c:4721
 __sys_bpf+0x643/0x950 kernel/bpf/syscall.c:6246
 __do_sys_bpf kernel/bpf/syscall.c:6341 [inline]
 __se_sys_bpf kernel/bpf/syscall.c:6339 [inline]
 __x64_sys_bpf+0x7c/0x90 kernel/bpf/syscall.c:6339
 do_syscall_x64 arch/x86/entry/syscall_64.c:63 [inline]
 do_syscall_64+0xe2/0xf80 arch/x86/entry/syscall_64.c:94
 entry_SYSCALL_64_after_hwframe+0x77/0x7f
RIP: 0033:0x7f722f59acb9
Code: ff c3 66 2e 0f 1f 84 00 00 00 00 00 0f 1f 44 00 00 48 89 f8 48 89 f7 48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 ff ff 73 01 c3 48 c7 c1 e8 ff ff ff f7 d8 64 89 01 48
RSP: 002b:00007fff2a77bfd8 EFLAGS: 00000246 ORIG_RAX: 0000000000000141
RAX: ffffffffffffffda RBX: 00007f722f815fa0 RCX: 00007f722f59acb9
RDX: 000000000000002c RSI: 0000200000000080 RDI: 000000000000000a
RBP: 00007f722f608bf7 R08: 0000000000000000 R09: 0000000000000000
R10: 0000000000000000 R11: 0000000000000246 R12: 0000000000000000
R13: 00007f722f815fac R14: 00007f722f815fa0 R15: 00007f722f815fa0
 </TASK>
Modules linked in:
---[ end trace 0000000000000000 ]---
RIP: 0010:xfrm_lookup_with_ifid+0xe1/0x1af0 net/xfrm/xfrm_policy.c:3181
Code: 24 20 4d 8d 66 08 4c 89 e0 48 c1 e8 03 4d 89 ee 42 80 3c 28 00 74 08 4c 89 e7 e8 5a 1f 17 f8 4d 8b 24 24 4c 89 e0 48 c1 e8 03 <42> 0f b6 04 30 84 c0 0f 85 94 17 00 00 41 0f b7 04 24 89 44 24 28
RSP: 0018:ffffc900045f6ea0 EFLAGS: 00010246
RAX: 0000000000000000 RBX: ffffc900045f6f40 RCX: 0000000000000000
RDX: 0000000000000000 RSI: 0000000000000000 RDI: ffffc900045f6f50
RBP: ffffc900045f6fb8 R08: ffffc900045f6f4f R09: 0000000000000000
R10: ffffc900045f6f40 R11: fffff520008bedea R12: 0000000000000000
R13: dffffc0000000000 R14: dffffc0000000000 R15: 0000000000000000
FS:  00005555873db500(0000) GS:ffff88818e327000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 0000001b2fa63fff CR3: 000000016e128000 CR4: 00000000000006f0
----------------
Code disassembly (best guess):
   0:	24 20                	and    $0x20,%al
   2:	4d 8d 66 08          	lea    0x8(%r14),%r12
   6:	4c 89 e0             	mov    %r12,%rax
   9:	48 c1 e8 03          	shr    $0x3,%rax
   d:	4d 89 ee             	mov    %r13,%r14
  10:	42 80 3c 28 00       	cmpb   $0x0,(%rax,%r13,1)
  15:	74 08                	je     0x1f
  17:	4c 89 e7             	mov    %r12,%rdi
  1a:	e8 5a 1f 17 f8       	call   0xf8171f79
  1f:	4d 8b 24 24          	mov    (%r12),%r12
  23:	4c 89 e0             	mov    %r12,%rax
  26:	48 c1 e8 03          	shr    $0x3,%rax
* 2a:	42 0f b6 04 30       	movzbl (%rax,%r14,1),%eax <-- trapping instruction
  2f:	84 c0                	test   %al,%al
  31:	0f 85 94 17 00 00    	jne    0x17cb
  37:	41 0f b7 04 24       	movzwl (%r12),%eax
  3c:	89 44 24 28          	mov    %eax,0x28(%rsp)


***

If these findings have caused you to resend the series or submit a
separate fix, please add the following tag to your commit message:
  Tested-by: syzbot@syzkaller.appspotmail.com

---
This report is generated by a bot. It may contain errors.
syzbot ci engineers can be reached at syzkaller@googlegroups.com.
