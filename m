Received: from mail-oo1-f71.google.com (mail-oo1-f71.google.com [209.85.161.71])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E8E97407CC6
	for <syzbot@lists.linux.dev>; Fri,  7 Aug 2026 19:26:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.161.71
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786130766; cv=none; b=pzcRY2gv6zXvmpgOJhPanvO7Tg83hJ7OAsE9zSblFS8cgwiSnAsXSzdGFThgK7MLuZTFSalQTs7p0e4DK9JjyvoLQrp0BzsOJugTgaYHu77BmnIguBh1HEUJi47cFJVoAea+lphL6HX3h0PtaNNwMHxryk+aK2q+oO32JRv1MzM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786130766; c=relaxed/simple;
	bh=xKFXwI4ScfksIlFxAF4D/6Q703OfIa9RCCzV94raJmA=;
	h=MIME-Version:Date:In-Reply-To:Message-ID:Subject:From:To:
	 Content-Type; b=BGBzSInKwAergPAwaGMCiNPO41T79cy46ONSNWNTojDeRlPE59cz4DtBp0jSzkIfSCmmTqOoq6pGHPiBxMktqv3XdnC3Gqzgy5wzynji5Cl5J/XcmupBjqzzhjNRageGlMQA2uZdO1r0tXR70aCB+9L1YXfZNb/+foU9QVv65RU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com; arc=none smtp.client-ip=209.85.161.71
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com
Received: by mail-oo1-f71.google.com with SMTP id 006d021491bc7-6a344ad5c7bso723610eaf.3
        for <syzbot@lists.linux.dev>; Fri, 07 Aug 2026 12:26:03 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1786130762; x=1786735562;
        h=content-type:to:from:subject:message-id:in-reply-to:date
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to:content-type;
        bh=fwnhjM2qVIWG6WHZ784gr6ggkPahKerjux79lyx9PYs=;
        b=EhqG0+zirzp1Q0U4MhnQtXR6gvRPi6+PEompXrPX5P/iQgfehtsuy4YdnikzJDkK3M
         BHXxrT6WtPOh2n8ZTJDcs1YRpuJmgJdmAOJbaaT96NeqhH8GWfgFODXuXlL2P186HdaD
         RNiN/NAfglD6NdcKeSKTdyZe5MDIpT26H/YLcaKyPQCndUj0j6mzKX2cO42nDYLW8gIG
         MjdZpQGbkW4LYvifVYA4bfY18odQPfeciDzV5L1orBiZx1LAaypw2VEznMO0KEcWA5kU
         w74iir+Syc4aNOjsVMBfEmfxnv5atW4HIsz3hKpyWdXJbSM4m5IMRFocDl16+85hE2w8
         5nDg==
X-Forwarded-Encrypted: i=1; AHgh+RqPncMo8lXkpIc+V6GvBi5Ib5CCS6LXjD9GmmYMuEGvXpS+Iw4HwUqnxWZkvP7ZtBkIOesuwJc=@lists.linux.dev
X-Gm-Message-State: AOJu0Ywgmjm8MEtVAY1NuW88tqR05ZjeQCacorGK3QQIrcUUu9zIyqkD
	uHlvuGQC4K45zEQsghSS7hNdOx7kAuVeamdVfZqfXB1LPncUrGTU+9WSMtXnT6x1Xj5n7bVKltb
	CFhltIZ5+s8HJQTUgyT8oOa0QggbvrKj4uKdVvodZUn/GlYrXZICt5I9LTn0=
Precedence: bulk
X-Mailing-List: syzbot@lists.linux.dev
List-Id: <syzbot.lists.linux.dev>
List-Subscribe: <mailto:syzbot+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:syzbot+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Received: by 2002:a05:6820:1508:b0:6a3:1dc5:356e with SMTP id
 006d021491bc7-6ae970ab4f0mr12205581eaf.36.1786130762111; Fri, 07 Aug 2026
 12:26:02 -0700 (PDT)
Date: Fri, 07 Aug 2026 12:26:02 -0700
In-Reply-To: <gzke36g4mm6sanr2fsln44fugfypmfmhnzibyws2ponsbjjius@lgai63h6ahli>
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <6a76314a.9c11d2ce.289b96.00ae.GAE@google.com>
Subject: Re: [syzbot] [tipc?] BUG: soft lockup in do_sock_setsockopt
From: syzbot <syzbot+10a41dc44eef71aa9450@syzkaller.appspotmail.com>
To: immersa.bartosz.chronowski@gmail.com, linux-kernel@vger.kernel.org, 
	syzbot@kernel.org, syzbot@lists.linux.dev, syzkaller-bugs@googlegroups.com, 
	syzkaller-upstream-moderation@googlegroups.com
Content-Type: text/plain; charset="UTF-8"

Hello,

syzbot has tested the proposed patch but the reproducer is still triggering an issue:
BUG: soft lockup in do_sock_setsockopt

watchdog: BUG: soft lockup - CPU#0 stuck for 246s! [syz.0.68:6590]
Modules linked in:
irq event stamp: 407959825
hardirqs last  enabled at (407959824): [<ffffffff81c807ae>] __local_bh_enable_ip+0x9e/0x120 kernel/softirq.c:455
hardirqs last disabled at (407959825): [<ffffffff8b9d833e>] sysvec_apic_timer_interrupt+0xe/0xc0 arch/x86/kernel/apic/apic.c:1062
softirqs last  enabled at (58): [<ffffffff8b4025e1>] spin_unlock_bh include/linux/spinlock.h:396 [inline]
softirqs last  enabled at (58): [<ffffffff8b4025e1>] tipc_skb_peek_port net/tipc/msg.h:1235 [inline]
softirqs last  enabled at (58): [<ffffffff8b4025e1>] tipc_sk_rcv+0x2e1/0x1c80 net/tipc/socket.c:2496
softirqs last disabled at (60): [<ffffffff8b402618>] spin_trylock_bh include/linux/spinlock.h:414 [inline]
softirqs last disabled at (60): [<ffffffff8b402618>] tipc_sk_rcv+0x318/0x1c80 net/tipc/socket.c:2501
CPU: 0 UID: 0 PID: 6590 Comm: syz.0.68 Not tainted syzkaller #0 PREEMPT(full) 
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 07/16/2026
RIP: 0010:lockdep_enabled kernel/locking/lockdep.c:121 [inline]
RIP: 0010:lock_release+0x5d/0x310 kernel/locking/lockdep.c:5881
Code: 87 07 02 00 00 48 0f a3 05 a0 51 36 0f 0f 82 02 02 00 00 44 8b 05 47 85 36 0f 45 85 c0 0f 84 48 01 00 00 65 8b 05 c3 6c 6f 12 <85> c0 0f 85 39 01 00 00 65 4c 8b 25 fb 25 6f 12 41 8b bc 24 9c 0b
RSP: 0018:ffffc90002e96b60 EFLAGS: 00000202
RAX: 0000000000000000 RBX: ffffffff8ebe6200 RCX: ffffffff8b3ea8cc
RDX: 0000000000000000 RSI: ffffffff8c3e9500 RDI: ffffffff8e420920
RBP: ffffffff8b3ea81a R08: 0000000000000001 R09: 0000000000000000
R10: 0000000000000001 R11: 0000000000000000 R12: ffff888030e0d800
R13: 0000000000000001 R14: 00000000240a719c R15: dffffc0000000000
FS:  00007f80f2b016c0(0000) GS:ffff888123edd000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 00007f80f2b00ff8 CR3: 000000007840d000 CR4: 0000000000350ef0
Call Trace:
 <TASK>
 rcu_lock_release include/linux/rcupdate.h:310 [inline]
 rcu_read_unlock include/linux/rcupdate.h:871 [inline]
 net_generic+0xef/0x2a0 include/net/netns/generic.h:48
 tipc_sk_lookup+0xa2/0xa00 net/tipc/socket.c:3001
 tipc_sk_rcv+0x2ee/0x1c80 net/tipc/socket.c:2497
 tipc_node_xmit+0x23e/0xfb0 net/tipc/node.c:1701
 tipc_node_xmit_skb net/tipc/node.c:1766 [inline]
 tipc_node_distr_xmit+0x177/0x3c0 net/tipc/node.c:1781
 tipc_sk_rcv+0xaab/0x1c80 net/tipc/socket.c:2506
 tipc_node_xmit+0x23e/0xfb0 net/tipc/node.c:1701
 tipc_sk_push_backlog+0x318/0xa00 net/tipc/socket.c:1314
 tipc_sk_conn_proto_rcv net/tipc/socket.c:1371 [inline]
 tipc_sk_proto_rcv net/tipc/socket.c:2161 [inline]
 tipc_sk_filter_rcv+0x248f/0x3250 net/tipc/socket.c:2357
 tipc_sk_enqueue net/tipc/socket.c:2450 [inline]
 tipc_sk_rcv+0xe90/0x1c80 net/tipc/socket.c:2502
 tipc_node_xmit+0x23e/0xfb0 net/tipc/node.c:1701
 tipc_node_xmit_skb net/tipc/node.c:1766 [inline]
 tipc_node_distr_xmit+0x177/0x3c0 net/tipc/node.c:1781
 tipc_sk_backlog_rcv+0x16f/0x1e0 net/tipc/socket.c:2417
 sk_backlog_rcv include/net/sock.h:1190 [inline]
 __release_sock+0x3a2/0x440 net/core/sock.c:3260
 release_sock+0x1e5/0x280 net/core/sock.c:3859
 sockopt_release_sock net/core/sock.c:1162 [inline]
 sk_setsockopt+0x46b/0x5d80 net/core/sock.c:1680
 do_sock_setsockopt+0x193/0x1d0 net/socket.c:2364
 __sys_setsockopt+0x195/0x220 net/socket.c:2393
 __do_sys_setsockopt net/socket.c:2399 [inline]
 __se_sys_setsockopt net/socket.c:2396 [inline]
 __x64_sys_setsockopt+0xbd/0x160 net/socket.c:2396
 do_syscall_x64 arch/x86/entry/syscall_64.c:63 [inline]
 do_syscall_64+0x10b/0x860 arch/x86/entry/syscall_64.c:94
 entry_SYSCALL_64_after_hwframe+0x77/0x7f
RIP: 0033:0x7f80f1b9c819
Code: ff c3 66 2e 0f 1f 84 00 00 00 00 00 0f 1f 44 00 00 48 89 f8 48 89 f7 48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 ff ff 73 01 c3 48 c7 c1 e8 ff ff ff f7 d8 64 89 01 48
RSP: 002b:00007f80f2b01028 EFLAGS: 00000246 ORIG_RAX: 0000000000000036
RAX: ffffffffffffffda RBX: 00007f80f1e16090 RCX: 00007f80f1b9c819
RDX: 0000000000000021 RSI: 0000000000000001 RDI: 0000000000000003
RBP: 00007f80f1c32c91 R08: 0000000000000004 R09: 0000000000000000
R10: 0000200000000540 R11: 0000000000000246 R12: 0000000000000000
R13: 00007f80f1e16128 R14: 00007f80f1e16090 R15: 00007ffff6021578
 </TASK>
Sending NMI from CPU 0 to CPUs 1:
NMI backtrace for cpu 1
CPU: 1 UID: 0 PID: 6589 Comm: syz.0.68 Not tainted syzkaller #0 PREEMPT(full) 
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 07/16/2026
RIP: 0010:pv_native_safe_halt+0xf/0x20 arch/x86/kernel/paravirt.c:64
Code: 86 a4 02 e9 6e b8 72 f5 0f 1f 00 90 90 90 90 90 90 90 90 90 90 90 90 90 90 90 90 f3 0f 1e fa 66 90 0f 00 2d 03 fa 2d 00 fb f4 <e9> 47 b8 72 f5 66 2e 0f 1f 84 00 00 00 00 00 66 90 90 90 90 90 90
RSP: 0018:ffffc90002e378d8 EFLAGS: 00000246
RAX: 000000000001931e RBX: 0000000000000003 RCX: 0000000000000004
RDX: 0000000000000000 RSI: ffffffff8e168355 RDI: ffffffff8c3e9580
RBP: ffff8880799cca50 R08: 0000000000000001 R09: 0000000000000000
R10: 0000000000000001 R11: 0000000000000000 R12: 0000000000000003
R13: 0000000000000003 R14: ffff8880b853c5c0 R15: 0000000000000000
FS:  00007f80f2b226c0(0000) GS:ffff888123fdd000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 0000200000000000 CR3: 000000007840d000 CR4: 0000000000350ef0
Call Trace:
 <TASK>
 arch_safe_halt arch/x86/include/asm/paravirt.h:62 [inline]
 kvm_wait arch/x86/kernel/kvm.c:1096 [inline]
 kvm_wait+0x124/0x160 arch/x86/kernel/kvm.c:1078
 pv_wait arch/x86/include/asm/paravirt-spinlock.h:83 [inline]
 pv_wait_head_or_lock kernel/locking/qspinlock_paravirt.h:466 [inline]
 __pv_queued_spin_lock_slowpath+0x4b0/0xc00 kernel/locking/qspinlock.c:325
 pv_queued_spin_lock_slowpath arch/x86/include/asm/paravirt-spinlock.h:35 [inline]
 queued_spin_lock_slowpath arch/x86/include/asm/paravirt-spinlock.h:66 [inline]
 queued_spin_lock include/asm-generic/qspinlock.h:114 [inline]
 do_raw_spin_lock+0x1e0/0x260 kernel/locking/spinlock_debug.c:116
 spin_lock_bh include/linux/spinlock.h:348 [inline]
 lock_sock_nested+0x5f/0xf0 net/core/sock.c:3846
 lock_sock include/net/sock.h:1713 [inline]
 tipc_sendstream+0x41/0x70 net/tipc/socket.c:1550
 sock_sendmsg_nosec net/socket.c:775 [inline]
 __sock_sendmsg net/socket.c:790 [inline]
 ____sys_sendmsg+0xa4d/0xbe0 net/socket.c:2684
 ___sys_sendmsg+0x190/0x1e0 net/socket.c:2738
 __sys_sendmsg+0x160/0x210 net/socket.c:2770
 do_syscall_x64 arch/x86/entry/syscall_64.c:63 [inline]
 do_syscall_64+0x10b/0x860 arch/x86/entry/syscall_64.c:94
 entry_SYSCALL_64_after_hwframe+0x77/0x7f
RIP: 0033:0x7f80f1b9c819
Code: ff c3 66 2e 0f 1f 84 00 00 00 00 00 0f 1f 44 00 00 48 89 f8 48 89 f7 48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 ff ff 73 01 c3 48 c7 c1 e8 ff ff ff f7 d8 64 89 01 48
RSP: 002b:00007f80f2b22028 EFLAGS: 00000246 ORIG_RAX: 000000000000002e
RAX: ffffffffffffffda RBX: 00007f80f1e15fa0 RCX: 00007f80f1b9c819
RDX: 0000000000000000 RSI: 0000200000000780 RDI: 0000000000000004
RBP: 00007f80f1c32c91 R08: 0000000000000000 R09: 0000000000000000
R10: 0000000000000000 R11: 0000000000000246 R12: 0000000000000000
R13: 00007f80f1e16038 R14: 00007f80f1e15fa0 R15: 00007ffff6021578
 </TASK>


Tested on:

commit:         a13307e9 Merge tag 'bpf-fixes' of git://git.kernel.org..
git tree:       upstream
console output: https://syzkaller.appspot.com/x/log.txt?x=126c8fb9580000
kernel config:  https://syzkaller.appspot.com/x/.config?x=7ea511081a30ab4a
dashboard link: https://syzkaller.appspot.com/bug?extid=10a41dc44eef71aa9450
compiler:       gcc (Debian 14.2.0-19) 14.2.0, GNU ld (GNU Binutils for Debian) 2.44

Note: no patches were applied.
