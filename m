Received: from mail-oi1-f198.google.com (mail-oi1-f198.google.com [209.85.167.198])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 88EF63016F7
	for <syzbot@lists.linux.dev>; Fri, 12 Jun 2026 20:25:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.167.198
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781295909; cv=none; b=oO3LGKk4aH5T6A2pjyn1PRDZiO/T/Gqi0of0UFiegXuIIBcFUsn2uPfP+brbnidEpPfTcEh3Fl0Pih2SfJgIF5+OcJ2DKm+ko33v4Yv7Zi2Ddnh9Sa9eBH1Mq4pX5WNbj1v5CtXbE5zSPuMPGBoQa8r6G1cqzBqYgJA1t7NTxAA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781295909; c=relaxed/simple;
	bh=4ctPAJLzNc8Mvglvg9fgpq8c2PjfOZxX7VvsbHGLfnI=;
	h=MIME-Version:Date:Message-ID:Subject:From:To:Cc:Content-Type; b=JTWGTvAen07a4bece+pPNW2sz+yO4hmNr+93kPEZdZzwuRlpB5jI+0SJvWOf2IHdlliIjPCNytHxhl7+ewm5v+5BUmt8GuPurnswzHeFIAqr6uWE1H71qqEjnQ8MYTnkEFVCDleeJkEO7ymFOGsug3wCIci7OBr7ZYxiwUWoTzU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com; arc=none smtp.client-ip=209.85.167.198
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com
Received: by mail-oi1-f198.google.com with SMTP id 5614622812f47-4865ab81f1fso2276680b6e.1
        for <syzbot@lists.linux.dev>; Fri, 12 Jun 2026 13:25:07 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1781295906; x=1781900706;
        h=cc:to:from:subject:message-id:date:mime-version:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=ahyHXxXr6jlNdk5Wik3dSbkEzJzYB76EKUsOHe4V2ow=;
        b=qy1YV45sgiz9iwKy5hZYVJYWWPwKHqcbn2Bmip2s2GDHgvBuLuEyQrqGnSQz58VDpi
         fg8X0N9yR9b9bo7Ggc3uPf/4oQbcXOrVIYTP8/TBg5fJ9b0fEAanZC/kj84SkTrPGNtd
         totnLIfp/car2oPgGvmxW1ttjQLxPGoVUywCSDAROoJ0rGtfoftNihO3pqPcARoD5ytL
         f/v5AEpR9zH2efegKpOkR4necxL4eGjIAhC5QMK9AJpshri2E0nw8D24tZzCWezSZrhU
         qmR2m8K+EIBdFxlt0ab7ArAxr3O72iFm1Cuwl1k8+HzM5uyjfUl4BMmOj7UTQuLiWg24
         Icrw==
X-Gm-Message-State: AOJu0YyxMhjwcayqHuzBxIejSBapLlEsjWfhKgIyAM9JFbcBflzqpmVv
	q7aJ39K4g8UscW1ojvcg65CfIwqzgDF/bA68bDtTwYUPe0lQUm6l5qCbRqm2PDSXJK62pbnTRpb
	F2b5nV2ct62hmeCeQoTD/fNc1y7eBeZ4kW+wXdN1cCruVuWLgD2ep2HqcIQ8=
Precedence: bulk
X-Mailing-List: syzbot@lists.linux.dev
List-Id: <syzbot.lists.linux.dev>
List-Subscribe: <mailto:syzbot+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:syzbot+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Received: by 2002:a05:6808:c295:b0:485:6129:10ff with SMTP id
 5614622812f47-48741be8517mr759747b6e.34.1781295906594; Fri, 12 Jun 2026
 13:25:06 -0700 (PDT)
Date: Fri, 12 Jun 2026 13:25:06 -0700
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <6a2c6b22.be3f099c.2836ae.0003.GAE@google.com>
Subject: [moderation/CI] Re: tcp: opportunistic loopback splice for BPF-paired sockets
From: syzbot ci <syzbot+ci8502ead12f7ad416@syzkaller.appspotmail.com>
To: syzkaller-upstream-moderation@googlegroups.com
Cc: syzbot@lists.linux.dev
Content-Type: text/plain; charset="UTF-8"

syzbot ci has tested the following series

[v1] tcp: opportunistic loopback splice for BPF-paired sockets
https://lore.kernel.org/all/20260612011452.134466-1-xiyou.wangcong@gmail.com
* [RFC PATCH bpf-next 1/5] tcp_bpf: add bpf_sock_splice_pair kfunc for opportunistic loopback splice
* [RFC PATCH bpf-next 2/5] tcp_bpf: busy-poll the splice ring before parking the receiver
* [RFC PATCH bpf-next 3/5] selftests/bpf: add tcp_splice basic round-trip test
* [RFC PATCH bpf-next 4/5] bpf: allow SO_BUSY_POLL in bpf_setsockopt()
* [RFC PATCH bpf-next 5/5] selftests/bpf: set SO_BUSY_POLL from the tcp_splice sockops prog

and found the following issues:
* WARNING: suspicious RCU usage in tcp_bpf_recvmsg
* WARNING: suspicious RCU usage in tcp_bpf_splice_sendmsg

Full report is available here:
https://ci.syzbot.org/series/7c43d5ae-cb19-4b2b-96ad-f7f0806ac63c

***

WARNING: suspicious RCU usage in tcp_bpf_recvmsg

tree:      bpf-next
URL:       https://kernel.googlesource.com/pub/scm/linux/kernel/git/bpf/bpf-next.git
base:      30dee2c176e7954f63d1fa3e52d172f30beb9bfb
arch:      amd64
compiler:  Debian clang version 21.1.8 (++20251221033036+2078da43e25a-1~exp1~20251221153213.50), Debian LLD 21.1.8
config:    https://ci.syzbot.org/builds/09e43fc4-ebab-492e-b1de-15bb86aa4588/config
syz repro: https://ci.syzbot.org/findings/79db1500-f71c-4550-8525-89bf06044d60/syz_repro

=============================
WARNING: suspicious RCU usage
syzkaller #0 Not tainted
-----------------------------
net/ipv4/tcp_bpf.c:883 suspicious rcu_dereference_check() usage!

other info that might help us debug this:


rcu_scheduler_active = 2, debug_locks = 1
no locks held by syz.0.17/5822.

stack backtrace:
CPU: 1 UID: 0 PID: 5822 Comm: syz.0.17 Not tainted syzkaller #0 PREEMPT(full) 
Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS 1.16.2-debian-1.16.2-1 04/01/2014
Call Trace:
 <TASK>
 dump_stack_lvl+0xe8/0x150 lib/dump_stack.c:120
 lockdep_rcu_suspicious+0x13f/0x1d0 kernel/locking/lockdep.c:6876
 sk_psock_is_spliced net/ipv4/tcp_bpf.c:883 [inline]
 tcp_bpf_recvmsg+0x1780/0x1980 net/ipv4/tcp_bpf.c:405
 sock_recvmsg_nosec+0xee/0x140 net/socket.c:1137
 ____sys_recvmsg+0x3e3/0x4a0 net/socket.c:2916
 ___sys_recvmsg+0x215/0x590 net/socket.c:2960
 do_recvmmsg+0x334/0x800 net/socket.c:3055
 __sys_recvmmsg net/socket.c:3129 [inline]
 __do_sys_recvmmsg net/socket.c:3152 [inline]
 __se_sys_recvmmsg net/socket.c:3145 [inline]
 __x64_sys_recvmmsg+0x198/0x250 net/socket.c:3145
 do_syscall_x64 arch/x86/entry/syscall_64.c:63 [inline]
 do_syscall_64+0x174/0x580 arch/x86/entry/syscall_64.c:94
 entry_SYSCALL_64_after_hwframe+0x77/0x7f
RIP: 0033:0x7f1af799ce59
Code: ff c3 66 2e 0f 1f 84 00 00 00 00 00 0f 1f 44 00 00 48 89 f8 48 89 f7 48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 ff ff 73 01 c3 48 c7 c1 e8 ff ff ff f7 d8 64 89 01 48
RSP: 002b:00007f1af87bc028 EFLAGS: 00000246 ORIG_RAX: 000000000000012b
RAX: ffffffffffffffda RBX: 00007f1af7c15fa0 RCX: 00007f1af799ce59
RDX: 0000000000000002 RSI: 0000200000000400 RDI: 0000000000000003
RBP: 00007f1af7a32d6f R08: 0000000000000000 R09: 0000000000000000
R10: 0000000000010051 R11: 0000000000000246 R12: 0000000000000000
R13: 00007f1af7c16038 R14: 00007f1af7c15fa0 R15: 00007ffdef205588
 </TASK>


***

WARNING: suspicious RCU usage in tcp_bpf_splice_sendmsg

tree:      bpf-next
URL:       https://kernel.googlesource.com/pub/scm/linux/kernel/git/bpf/bpf-next.git
base:      30dee2c176e7954f63d1fa3e52d172f30beb9bfb
arch:      amd64
compiler:  Debian clang version 21.1.8 (++20251221033036+2078da43e25a-1~exp1~20251221153213.50), Debian LLD 21.1.8
config:    https://ci.syzbot.org/builds/09e43fc4-ebab-492e-b1de-15bb86aa4588/config
syz repro: https://ci.syzbot.org/findings/8144de7d-1a2e-454e-ab17-08d1c6586df2/syz_repro

=============================
WARNING: suspicious RCU usage
syzkaller #0 Not tainted
-----------------------------
net/ipv4/tcp_bpf.c:883 suspicious rcu_dereference_check() usage!

other info that might help us debug this:


rcu_scheduler_active = 2, debug_locks = 1
no locks held by syz.2.19/5817.

stack backtrace:
CPU: 0 UID: 0 PID: 5817 Comm: syz.2.19 Not tainted syzkaller #0 PREEMPT(full) 
Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS 1.16.2-debian-1.16.2-1 04/01/2014
Call Trace:
 <TASK>
 dump_stack_lvl+0xe8/0x150 lib/dump_stack.c:120
 lockdep_rcu_suspicious+0x13f/0x1d0 kernel/locking/lockdep.c:6876
 sk_psock_is_spliced net/ipv4/tcp_bpf.c:883 [inline]
 tcp_bpf_splice_sendmsg+0x1165/0x1490 net/ipv4/tcp_bpf.c:897
 sock_sendmsg_nosec net/socket.c:787 [inline]
 __sock_sendmsg net/socket.c:802 [inline]
 ____sys_sendmsg+0x80a/0x9f0 net/socket.c:2698
 ___sys_sendmsg+0x2a5/0x360 net/socket.c:2752
 __sys_sendmmsg+0x27c/0x4e0 net/socket.c:2841
 __do_sys_sendmmsg net/socket.c:2868 [inline]
 __se_sys_sendmmsg net/socket.c:2865 [inline]
 __x64_sys_sendmmsg+0xa0/0xc0 net/socket.c:2865
 do_syscall_x64 arch/x86/entry/syscall_64.c:63 [inline]
 do_syscall_64+0x174/0x580 arch/x86/entry/syscall_64.c:94
 entry_SYSCALL_64_after_hwframe+0x77/0x7f
RIP: 0033:0x7fd1c339ce59
Code: ff c3 66 2e 0f 1f 84 00 00 00 00 00 0f 1f 44 00 00 48 89 f8 48 89 f7 48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 ff ff 73 01 c3 48 c7 c1 e8 ff ff ff f7 d8 64 89 01 48
RSP: 002b:00007fd1c42e3028 EFLAGS: 00000246 ORIG_RAX: 0000000000000133
RAX: ffffffffffffffda RBX: 00007fd1c3615fa0 RCX: 00007fd1c339ce59
RDX: 0000000000000001 RSI: 0000200000001000 RDI: 0000000000000003
RBP: 00007fd1c3432d6f R08: 0000000000000000 R09: 0000000000000000
R10: 0000000004008005 R11: 0000000000000246 R12: 0000000000000000
R13: 00007fd1c3616038 R14: 00007fd1c3615fa0 R15: 00007ffdcdbac378
 </TASK>


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
[bpf@vger.kernel.org cwang@multikernel.io hemanthmalla@gmail.com jakub@cloudflare.com jiayuan.chen@linux.dev john.fastabend@gmail.com netdev@vger.kernel.org xiyou.wangcong@gmail.com zijianzhang@bytedance.com]

If the report looks fine to you, reply with:
#syz upstream

If the report is a false positive, reply with
#syz invalid

