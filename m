Received: from mail-oi1-f197.google.com (mail-oi1-f197.google.com [209.85.167.197])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 967DE4071F8
	for <syzbot@lists.linux.dev>; Wed, 17 Jun 2026 13:28:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.167.197
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781702911; cv=none; b=CdACSrPT3vBNi7jdWsIbw2WR5PqgEGYN4N7KW9ywCCNPeQRZ2LqEcDGcUiyvDn1DwgERAf9LqIH9Cjtp8ITLpd3Ls29gJW1Y8LWgrQHBh4wtqdYoyOr/hNuIUtMNHDmj0cXBHvLuURKL+VsObj7TpyJij2aRXJcHBG1N6TmRT0g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781702911; c=relaxed/simple;
	bh=BRPvT+20hi42cCY7xrGTZTwc5fN4oWIaF9SSQYOtZ74=;
	h=MIME-Version:Date:In-Reply-To:Message-ID:Subject:From:To:Cc:
	 Content-Type; b=Hol7apLQm61+sXoaShGFtUm0f500enV9lDM7FMR2fRgp4v4u8dz4bjeO5bTBTGMLoTR5V3mV4pqwYYgRkxvlZpPmVry6EuZWn0I2ZQiiAq8liP310yTz8SO1o+HwRQrgd5Zvho5Xg/5zGYjnJMqbdg+19d2uL0j/rLhh3Pb/fgw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com; arc=none smtp.client-ip=209.85.167.197
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com
Received: by mail-oi1-f197.google.com with SMTP id 5614622812f47-4863a0c3105so9767790b6e.3
        for <syzbot@lists.linux.dev>; Wed, 17 Jun 2026 06:28:26 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1781702905; x=1782307705;
        h=cc:to:from:subject:message-id:in-reply-to:date:mime-version
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=fjiIFd/qu8PSbuNSvBMYF1UVbLAtUxT6tMmfwe+XIyc=;
        b=cmwbGeY2WXtU+RhD6JrxAqBxtJnq4uL+Y24/nb8Ug4WUzbM2M8LIN48hoiwZ8Tk0Es
         v0w+HpmFF98wdwuH1RbgIvSgNsll1SZjGP240GM+HzngzkgthDC9vY996ePWRJzRikSE
         I894m6q4mUAxF13EwWAL1yw96wTPy0eFj6o9V4fKrzVdA/Cq+zVvMVDM+mxBLcaTgALp
         e3ZILOop6gwTjOmZz6bTU7wF+DLKLxhLpgAlaXrwtQIzfKNIgXfvliDsPmyMZ5xYnzHR
         HhmQI3LPcSDoqPNXwbB4L8mwaUB5HYgXdHWv2U4xvtRZrbfRylWwXyTurftQTPgNquI7
         4S9A==
X-Gm-Message-State: AOJu0YwQLYl1+NZHfVy4Ci0zarDimanmUXY2uYgk8seYRFs91SWVW4ny
	8lUQp9WK4LazPRvytd8LnVVI0UytLgKSAG4Oyi1eakbzdnbtzq8bKDbsoM/SDD1f+DB+VdOy/nQ
	CUSOh0Y4vrVERdrvw/bUyCjvp9zIH0S/Xx3Zb1Uib5LA86G583H0z4LzlD7I=
Precedence: bulk
X-Mailing-List: syzbot@lists.linux.dev
List-Id: <syzbot.lists.linux.dev>
List-Subscribe: <mailto:syzbot+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:syzbot+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Received: by 2002:a05:6808:159d:b0:487:72fd:83d0 with SMTP id
 5614622812f47-4894289b876mr3183440b6e.13.1781702905448; Wed, 17 Jun 2026
 06:28:25 -0700 (PDT)
Date: Wed, 17 Jun 2026 06:28:25 -0700
In-Reply-To: <20260617084128.6603-1-kadlec@netfilter.org>
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <6a32a0f9.dc986f81.2c135.000b.GAE@google.com>
Subject: [syzbot ci] Re: netfilter: ipset fixes, second batch
From: syzbot ci <syzbot+ci4813d4c1f3fcd584@syzkaller.appspotmail.com>
To: kadlec@netfilter.org, netfilter-devel@vger.kernel.org, pablo@netfilter.org
Cc: syzbot@lists.linux.dev, syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"

syzbot ci has tested the following series

[v3] netfilter: ipset fixes, second batch
https://lore.kernel.org/all/20260617084128.6603-1-kadlec@netfilter.org
* [PATCH v3 1/7] netfilter: ipset: Don't use test_bit() in lockless RCU readers in hash types
* [PATCH v3 2/7] netfilter: ipset: Don't use test_bit() in lockless RCU readers in bitmap types
* [PATCH v3 3/7] netfilter: ipset: fix order of kfree_rcu() and rcu_assign_pointer()
* [PATCH v3 4/7] netfilter: ipset: exlude gc when resize is in progress
* [PATCH v3 5/7] netfilter: ipset: make sure gc is properly stopped
* [PATCH v3 6/7] netfilter: ipset: cleanup the add/del backlog when resize failed
* [PATCH v3 7/7] netfilter: ipset: rework cidr bookkeeping

and found the following issues:
* INFO: trying to register non-static key in hash_ipportip6_resize
* INFO: trying to register non-static key in hash_netport6_resize
* INFO: trying to register non-static key in hash_netportnet6_resize

Full report is available here:
https://ci.syzbot.org/series/7264660b-3f58-4809-9af0-c77ead1aac16

***

INFO: trying to register non-static key in hash_ipportip6_resize

tree:      nf-next
URL:       https://kernel.googlesource.com/pub/scm/linux/kernel/git/netfilter/nf-next.git
base:      3b165c2a29cfb6453f26e1ac833ca6afd28d28cf
arch:      amd64
compiler:  Debian clang version 21.1.8 (++20251221033036+2078da43e25a-1~exp1~20251221153213.50), Debian LLD 21.1.8
config:    https://ci.syzbot.org/builds/44611eeb-52b4-4b97-8744-2265cbb063fa/config
syz repro: https://ci.syzbot.org/findings/c1aaddfd-5ff4-410d-85fa-3c212552d465/syz_repro

INFO: trying to register non-static key.
The code is fine but needs lockdep annotation, or maybe
you didn't initialize this object before use?
turning off the locking correctness validator.
CPU: 0 UID: 0 PID: 5810 Comm: syz.0.17 Not tainted syzkaller #0 PREEMPT(full) 
Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS 1.16.2-debian-1.16.2-1 04/01/2014
Call Trace:
 <TASK>
 dump_stack_lvl+0xe8/0x150 lib/dump_stack.c:120
 assign_lock_key+0x133/0x150 kernel/locking/lockdep.c:984
 register_lock_class+0xcc/0x2e0 kernel/locking/lockdep.c:1299
 __lock_acquire+0xad/0x2cf0 kernel/locking/lockdep.c:5112
 lock_acquire+0x106/0x350 kernel/locking/lockdep.c:5868
 __raw_spin_lock_bh include/linux/spinlock_api_smp.h:150 [inline]
 _raw_spin_lock_bh+0x36/0x50 kernel/locking/spinlock.c:182
 spin_lock_bh include/linux/spinlock.h:348 [inline]
 hash_ipportip6_resize+0x4d4/0x1dd0 net/netfilter/ipset/ip_set_hash_gen.h:699
 call_ad+0x463/0xb60 net/netfilter/ipset/ip_set_core.c:1758
 ip_set_ad+0x824/0x9d0 net/netfilter/ipset/ip_set_core.c:1842
 nfnetlink_rcv_msg+0xc03/0x12c0 net/netfilter/nfnetlink.c:300
 netlink_rcv_skb+0x232/0x4b0 net/netlink/af_netlink.c:2556
 nfnetlink_rcv+0x2c0/0x27b0 net/netfilter/nfnetlink.c:667
 netlink_unicast_kernel net/netlink/af_netlink.c:1319 [inline]
 netlink_unicast+0x75c/0x8e0 net/netlink/af_netlink.c:1345
 netlink_sendmsg+0x813/0xb40 net/netlink/af_netlink.c:1900
 sock_sendmsg_nosec net/socket.c:787 [inline]
 __sock_sendmsg net/socket.c:802 [inline]
 ____sys_sendmsg+0x972/0x9f0 net/socket.c:2699
 ___sys_sendmsg+0x2a5/0x360 net/socket.c:2753
 __sys_sendmsg net/socket.c:2785 [inline]
 __do_sys_sendmsg net/socket.c:2790 [inline]
 __se_sys_sendmsg net/socket.c:2788 [inline]
 __x64_sys_sendmsg+0x1bd/0x2a0 net/socket.c:2788
 do_syscall_x64 arch/x86/entry/syscall_64.c:63 [inline]
 do_syscall_64+0x174/0x580 arch/x86/entry/syscall_64.c:94
 entry_SYSCALL_64_after_hwframe+0x77/0x7f
RIP: 0033:0x7f4ef2b9ce59
Code: ff c3 66 2e 0f 1f 84 00 00 00 00 00 0f 1f 44 00 00 48 89 f8 48 89 f7 48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 ff ff 73 01 c3 48 c7 c1 e8 ff ff ff f7 d8 64 89 01 48
RSP: 002b:00007f4ef3b42028 EFLAGS: 00000246 ORIG_RAX: 000000000000002e
RAX: ffffffffffffffda RBX: 00007f4ef2e15fa0 RCX: 00007f4ef2b9ce59
RDX: 0000000000000000 RSI: 00002000000002c0 RDI: 0000000000000004
RBP: 00007f4ef2c32d6f R08: 0000000000000000 R09: 0000000000000000
R10: 0000000000000000 R11: 0000000000000246 R12: 0000000000000000
R13: 00007f4ef2e16038 R14: 00007f4ef2e15fa0 R15: 00007ffd926dea58
 </TASK>


***

INFO: trying to register non-static key in hash_netport6_resize

tree:      nf-next
URL:       https://kernel.googlesource.com/pub/scm/linux/kernel/git/netfilter/nf-next.git
base:      3b165c2a29cfb6453f26e1ac833ca6afd28d28cf
arch:      amd64
compiler:  Debian clang version 21.1.8 (++20251221033036+2078da43e25a-1~exp1~20251221153213.50), Debian LLD 21.1.8
config:    https://ci.syzbot.org/builds/44611eeb-52b4-4b97-8744-2265cbb063fa/config
syz repro: https://ci.syzbot.org/findings/60d79dbd-6e73-4ee8-be39-8bea69cb5f52/syz_repro

INFO: trying to register non-static key.
The code is fine but needs lockdep annotation, or maybe
you didn't initialize this object before use?
turning off the locking correctness validator.
CPU: 0 UID: 0 PID: 5834 Comm: syz.0.17 Not tainted syzkaller #0 PREEMPT(full) 
Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS 1.16.2-debian-1.16.2-1 04/01/2014
Call Trace:
 <TASK>
 dump_stack_lvl+0xe8/0x150 lib/dump_stack.c:120
 assign_lock_key+0x133/0x150 kernel/locking/lockdep.c:984
 register_lock_class+0xcc/0x2e0 kernel/locking/lockdep.c:1299
 __lock_acquire+0xad/0x2cf0 kernel/locking/lockdep.c:5112
 lock_acquire+0x106/0x350 kernel/locking/lockdep.c:5868
 __raw_spin_lock_bh include/linux/spinlock_api_smp.h:150 [inline]
 _raw_spin_lock_bh+0x36/0x50 kernel/locking/spinlock.c:182
 spin_lock_bh include/linux/spinlock.h:348 [inline]
 hash_netport6_resize+0x548/0x1d30 net/netfilter/ipset/ip_set_hash_gen.h:699
 call_ad+0x463/0xb60 net/netfilter/ipset/ip_set_core.c:1758
 ip_set_ad+0x824/0x9d0 net/netfilter/ipset/ip_set_core.c:1842
 nfnetlink_rcv_msg+0xc03/0x12c0 net/netfilter/nfnetlink.c:300
 netlink_rcv_skb+0x232/0x4b0 net/netlink/af_netlink.c:2556
 nfnetlink_rcv+0x2c0/0x27b0 net/netfilter/nfnetlink.c:667
 netlink_unicast_kernel net/netlink/af_netlink.c:1319 [inline]
 netlink_unicast+0x75c/0x8e0 net/netlink/af_netlink.c:1345
 netlink_sendmsg+0x813/0xb40 net/netlink/af_netlink.c:1900
 sock_sendmsg_nosec net/socket.c:787 [inline]
 __sock_sendmsg net/socket.c:802 [inline]
 ____sys_sendmsg+0x972/0x9f0 net/socket.c:2699
 ___sys_sendmsg+0x2a5/0x360 net/socket.c:2753
 __sys_sendmsg net/socket.c:2785 [inline]
 __do_sys_sendmsg net/socket.c:2790 [inline]
 __se_sys_sendmsg net/socket.c:2788 [inline]
 __x64_sys_sendmsg+0x1bd/0x2a0 net/socket.c:2788
 do_syscall_x64 arch/x86/entry/syscall_64.c:63 [inline]
 do_syscall_64+0x174/0x580 arch/x86/entry/syscall_64.c:94
 entry_SYSCALL_64_after_hwframe+0x77/0x7f
RIP: 0033:0x7f5c11d9ce59
Code: ff c3 66 2e 0f 1f 84 00 00 00 00 00 0f 1f 44 00 00 48 89 f8 48 89 f7 48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 ff ff 73 01 c3 48 c7 c1 e8 ff ff ff f7 d8 64 89 01 48
RSP: 002b:00007f5c113dd028 EFLAGS: 00000246 ORIG_RAX: 000000000000002e
RAX: ffffffffffffffda RBX: 00007f5c12016090 RCX: 00007f5c11d9ce59
RDX: 0000000000000090 RSI: 00002000000002c0 RDI: 0000000000000004
RBP: 00007f5c11e32d6f R08: 0000000000000000 R09: 0000000000000000
R10: 0000000000000000 R11: 0000000000000246 R12: 0000000000000000
R13: 00007f5c12016128 R14: 00007f5c12016090 R15: 00007ffd4124a0a8
 </TASK>


***

INFO: trying to register non-static key in hash_netportnet6_resize

tree:      nf-next
URL:       https://kernel.googlesource.com/pub/scm/linux/kernel/git/netfilter/nf-next.git
base:      3b165c2a29cfb6453f26e1ac833ca6afd28d28cf
arch:      amd64
compiler:  Debian clang version 21.1.8 (++20251221033036+2078da43e25a-1~exp1~20251221153213.50), Debian LLD 21.1.8
config:    https://ci.syzbot.org/builds/44611eeb-52b4-4b97-8744-2265cbb063fa/config
syz repro: https://ci.syzbot.org/findings/a0e027e2-8833-4fe6-8f75-2f388682c035/syz_repro

INFO: trying to register non-static key.
The code is fine but needs lockdep annotation, or maybe
you didn't initialize this object before use?
turning off the locking correctness validator.
CPU: 0 UID: 0 PID: 5880 Comm: syz.0.17 Not tainted syzkaller #0 PREEMPT(full) 
Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS 1.16.2-debian-1.16.2-1 04/01/2014
Call Trace:
 <TASK>
 dump_stack_lvl+0xe8/0x150 lib/dump_stack.c:120
 assign_lock_key+0x133/0x150 kernel/locking/lockdep.c:984
 register_lock_class+0xcc/0x2e0 kernel/locking/lockdep.c:1299
 __lock_acquire+0xad/0x2cf0 kernel/locking/lockdep.c:5112
 lock_acquire+0x106/0x350 kernel/locking/lockdep.c:5868
 __raw_spin_lock_bh include/linux/spinlock_api_smp.h:150 [inline]
 _raw_spin_lock_bh+0x36/0x50 kernel/locking/spinlock.c:182
 spin_lock_bh include/linux/spinlock.h:348 [inline]
 hash_netportnet6_resize+0x5aa/0x2040 net/netfilter/ipset/ip_set_hash_gen.h:699
 call_ad+0x463/0xb60 net/netfilter/ipset/ip_set_core.c:1758
 ip_set_ad+0x824/0x9d0 net/netfilter/ipset/ip_set_core.c:1842
 nfnetlink_rcv_msg+0xc03/0x12c0 net/netfilter/nfnetlink.c:300
 netlink_rcv_skb+0x232/0x4b0 net/netlink/af_netlink.c:2556
 nfnetlink_rcv+0x2c0/0x27b0 net/netfilter/nfnetlink.c:667
 netlink_unicast_kernel net/netlink/af_netlink.c:1319 [inline]
 netlink_unicast+0x75c/0x8e0 net/netlink/af_netlink.c:1345
 netlink_sendmsg+0x813/0xb40 net/netlink/af_netlink.c:1900
 sock_sendmsg_nosec net/socket.c:787 [inline]
 __sock_sendmsg net/socket.c:802 [inline]
 ____sys_sendmsg+0x972/0x9f0 net/socket.c:2699
 ___sys_sendmsg+0x2a5/0x360 net/socket.c:2753
 __sys_sendmsg net/socket.c:2785 [inline]
 __do_sys_sendmsg net/socket.c:2790 [inline]
 __se_sys_sendmsg net/socket.c:2788 [inline]
 __x64_sys_sendmsg+0x1bd/0x2a0 net/socket.c:2788
 do_syscall_x64 arch/x86/entry/syscall_64.c:63 [inline]
 do_syscall_64+0x174/0x580 arch/x86/entry/syscall_64.c:94
 entry_SYSCALL_64_after_hwframe+0x77/0x7f
RIP: 0033:0x7f9c00b9ce59
Code: ff c3 66 2e 0f 1f 84 00 00 00 00 00 0f 1f 44 00 00 48 89 f8 48 89 f7 48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 ff ff 73 01 c3 48 c7 c1 e8 ff ff ff f7 d8 64 89 01 48
RSP: 002b:00007f9c01a82028 EFLAGS: 00000246 ORIG_RAX: 000000000000002e
RAX: ffffffffffffffda RBX: 00007f9c00e15fa0 RCX: 00007f9c00b9ce59
RDX: 0000000000000000 RSI: 00002000000002c0 RDI: 0000000000000004
RBP: 00007f9c00c32d6f R08: 0000000000000000 R09: 0000000000000000
R10: 0000000000000000 R11: 0000000000000246 R12: 0000000000000000
R13: 00007f9c00e16038 R14: 00007f9c00e15fa0 R15: 00007ffe8ca45b58
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
