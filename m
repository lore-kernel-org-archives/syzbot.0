Received: from mail-oo1-f72.google.com (mail-oo1-f72.google.com [209.85.161.72])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C537F339853
	for <syzbot@lists.linux.dev>; Sat, 14 Mar 2026 18:32:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.161.72
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773513128; cv=none; b=tdM/jzVhzgaUPdun5ySxbWwA6TByBXI+zRqINriElPrweRpD1163Ob0J4pdZcsZeJfs9pMRWNaaEbtgo30VFh6GZoRPvNX6pcmEai6yTOrbd76qBMl4UXdthmaqx+R3H48bOwLsKfzaZFlze1WDZpS98/KaZyBSrAvVkOscaYsA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773513128; c=relaxed/simple;
	bh=yb/fU+drcS3D41HTA6jAho0co2f/EEOQWTE1NGnBYCQ=;
	h=MIME-Version:Date:In-Reply-To:Message-ID:Subject:From:To:Cc:
	 Content-Type; b=rbGbtp67DAM2FjcwQ+Gr58Njp16RaqtgjxZY472LqmNmH3RiLhqJt5Tn6Qa4sUgB8Q4oJUDOSLOaeVZA091kg8R4Phb4t+GEdew2Mgfi+8+ToTWxR19I4VoR7GKw2GbvheJWnvr62nxiSSxAl2ELwr+/jW35/I3FwsU5rLjbAkE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com; arc=none smtp.client-ip=209.85.161.72
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com
Received: by mail-oo1-f72.google.com with SMTP id 006d021491bc7-67bf2b72878so2324985eaf.2
        for <syzbot@lists.linux.dev>; Sat, 14 Mar 2026 11:32:06 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1773513126; x=1774117926;
        h=cc:to:from:subject:message-id:in-reply-to:date:mime-version
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=W+T9TYUZRKCoKnLMPATfiUen5h1lefHnm+Loteuyo/g=;
        b=X7TKWBuovAc2EQbLTViwpYT40dnkYxxdRir/GQAz2S84UTdbT9rsoPJsGDad2v43g+
         mjVzbhb5xxmyAQ4/Rgmd9hNT97jtLPr1hA5iesBcvOExUnOrHEuDtHCMPwqJKVGrUgv7
         5hbVaX0M43CksOHOqMAdp24XrQG992zmM+hGxY0ZpjGPQMO8TPIGzFulQYVJiNhyBU9L
         FPic8mgSqtLPogM3DUqAufw3RHh4Uqz/01WBX+Sy5rTl4G+osBeBzDgsWKEjnwrjEqGs
         WCRg5zLr6rtHUGb7nv+uIYItkDWGGsTCSvI0PuT5kdZMTaw7KALIKir438iZffmh5BuR
         deBg==
X-Gm-Message-State: AOJu0YyNf9pdoaTSHgoLVRSHURiWzG8voo8fbGgBOvN9T5RwtIkqKjN4
	/H0v5s1Gq5ydmceeTnaU97d/JMpstpfqV7b+IvZu+N5brfh7Kzi+MJytXn+fztI7wF1i3SgV7d6
	iEUZULXw8Lx2y/6Q8qa02KsoVsPh6MtNmk+Oq7wtbOu2ni4PtwqVPb/7v+fE=
Precedence: bulk
X-Mailing-List: syzbot@lists.linux.dev
List-Id: <syzbot.lists.linux.dev>
List-Subscribe: <mailto:syzbot+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:syzbot+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Received: by 2002:a05:6820:4a8e:b0:67b:b22c:f799 with SMTP id
 006d021491bc7-67bda984775mr3485113eaf.9.1773513125845; Sat, 14 Mar 2026
 11:32:05 -0700 (PDT)
Date: Sat, 14 Mar 2026 11:32:05 -0700
In-Reply-To: <20260313173114.1220551-1-amorenoz@redhat.com>
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <69b5a9a5.a00a0220.3b25d1.0019.GAE@google.com>
Subject: [syzbot ci] Re: net: openvswitch: decouple flow_table from ovs_mutex
From: syzbot ci <syzbot+cifa1b40cf1698008f@syzkaller.appspotmail.com>
To: aconole@redhat.com, amorenoz@redhat.com, davem@davemloft.net, 
	dev@openvswitch.org, echaudro@redhat.com, edumazet@google.com, 
	horms@kernel.org, i.maximets@ovn.org, kuba@kernel.org, 
	linux-kernel@vger.kernel.org, netdev@vger.kernel.org, pabeni@redhat.com
Cc: syzbot@lists.linux.dev, syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"

syzbot ci has tested the following series

[v1] net: openvswitch: decouple flow_table from ovs_mutex
https://lore.kernel.org/all/20260313173114.1220551-1-amorenoz@redhat.com
* [PATCH net-next v1] net: openvswitch: decouple flow_table from ovs_mutex

and found the following issue:
BUG: sleeping function called from invalid context in __alloc_skb

Full report is available here:
https://ci.syzbot.org/series/dad18167-5b3c-4436-a026-ab60850e4342

***

BUG: sleeping function called from invalid context in __alloc_skb

tree:      net-next
URL:       https://kernel.googlesource.com/pub/scm/linux/kernel/git/netdev/net-next.git
base:      ce8ee8583ed83122405eabaa8fb351be4d9dc65c
arch:      amd64
compiler:  Debian clang version 21.1.8 (++20251221033036+2078da43e25a-1~exp1~20251221153213.50), Debian LLD 21.1.8
config:    https://ci.syzbot.org/builds/2b4330f1-9bd1-42b5-8e81-a127a9bf1b82/config
C repro:   https://ci.syzbot.org/findings/8259a139-586c-46ee-8e3e-4ed8801b7533/c_repro
syz repro: https://ci.syzbot.org/findings/8259a139-586c-46ee-8e3e-4ed8801b7533/syz_repro

BUG: sleeping function called from invalid context at ./include/linux/sched/mm.h:323
in_atomic(): 0, irqs_disabled(): 0, non_block: 0, pid: 5961, name: syz.0.17
preempt_count: 0, expected: 0
RCU nest depth: 1, expected: 0
2 locks held by syz.0.17/5961:
 #0: ffffffff8fc3a570 (cb_lock){++++}-{4:4}, at: genl_rcv+0x19/0x40 net/netlink/genetlink.c:1218
 #1: ffffffff8e7602e0 (rcu_read_lock){....}-{1:3}, at: rcu_lock_acquire include/linux/rcupdate.h:312 [inline]
 #1: ffffffff8e7602e0 (rcu_read_lock){....}-{1:3}, at: rcu_read_lock include/linux/rcupdate.h:850 [inline]
 #1: ffffffff8e7602e0 (rcu_read_lock){....}-{1:3}, at: ovs_flow_cmd_set+0x3c5/0xd60 net/openvswitch/datapath.c:1320
CPU: 0 UID: 0 PID: 5961 Comm: syz.0.17 Not tainted syzkaller #0 PREEMPT(full) 
Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS 1.16.2-debian-1.16.2-1 04/01/2014
Call Trace:
 <TASK>
 dump_stack_lvl+0xe8/0x150 lib/dump_stack.c:120
 __might_resched+0x378/0x4d0 kernel/sched/core.c:8884
 might_alloc include/linux/sched/mm.h:323 [inline]
 slab_pre_alloc_hook mm/slub.c:4452 [inline]
 slab_alloc_node mm/slub.c:4807 [inline]
 kmem_cache_alloc_node_noprof+0x7f/0x690 mm/slub.c:4882
 __alloc_skb+0x1d0/0x7d0 net/core/skbuff.c:702
 alloc_skb include/linux/skbuff.h:1383 [inline]
 nlmsg_new include/net/netlink.h:1055 [inline]
 netlink_ack+0x146/0xa50 net/netlink/af_netlink.c:2487
 netlink_rcv_skb+0x2b6/0x4b0 net/netlink/af_netlink.c:2556
 genl_rcv+0x28/0x40 net/netlink/genetlink.c:1219
 netlink_unicast_kernel net/netlink/af_netlink.c:1318 [inline]
 netlink_unicast+0x80f/0x9b0 net/netlink/af_netlink.c:1344
 netlink_sendmsg+0x813/0xb40 net/netlink/af_netlink.c:1894
 sock_sendmsg_nosec net/socket.c:727 [inline]
 __sock_sendmsg net/socket.c:742 [inline]
 ____sys_sendmsg+0xa68/0xad0 net/socket.c:2592
 ___sys_sendmsg+0x2a5/0x360 net/socket.c:2646
 __sys_sendmsg net/socket.c:2678 [inline]
 __do_sys_sendmsg net/socket.c:2683 [inline]
 __se_sys_sendmsg net/socket.c:2681 [inline]
 __x64_sys_sendmsg+0x1bd/0x2a0 net/socket.c:2681
 do_syscall_x64 arch/x86/entry/syscall_64.c:63 [inline]
 do_syscall_64+0x14d/0xf80 arch/x86/entry/syscall_64.c:94
 entry_SYSCALL_64_after_hwframe+0x77/0x7f
RIP: 0033:0x7f4c60b9c799
Code: ff c3 66 2e 0f 1f 84 00 00 00 00 00 0f 1f 44 00 00 48 89 f8 48 89 f7 48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 ff ff 73 01 c3 48 c7 c1 e8 ff ff ff f7 d8 64 89 01 48
RSP: 002b:00007ffc44689868 EFLAGS: 00000246 ORIG_RAX: 000000000000002e
RAX: ffffffffffffffda RBX: 00007f4c60e15fa0 RCX: 00007f4c60b9c799
RDX: 000000000000c000 RSI: 0000200000000000 RDI: 0000000000000003
RBP: 00007f4c60c32c99 R08: 0000000000000000 R09: 0000000000000000
R10: 0000000000000000 R11: 0000000000000246 R12: 0000000000000000
R13: 00007f4c60e15fac R14: 00007f4c60e15fa0 R15: 00007f4c60e15fa0
 </TASK>

================================================
WARNING: lock held when returning to user space!
syzkaller #0 Tainted: G        W          
------------------------------------------------
syz.0.17/5961 is leaving the kernel with locks still held!
1 lock held by syz.0.17/5961:
 #0: ffffffff8e7602e0 (rcu_read_lock){....}-{1:3}, at: rcu_lock_acquire include/linux/rcupdate.h:312 [inline]
 #0: ffffffff8e7602e0 (rcu_read_lock){....}-{1:3}, at: rcu_read_lock include/linux/rcupdate.h:850 [inline]
 #0: ffffffff8e7602e0 (rcu_read_lock){....}-{1:3}, at: ovs_flow_cmd_set+0x3c5/0xd60 net/openvswitch/datapath.c:1320
------------[ cut here ]------------
Voluntary context switch within RCU read-side critical section!
WARNING: kernel/rcu/tree_plugin.h:332 at rcu_note_context_switch+0xcac/0xf40 kernel/rcu/tree_plugin.h:332, CPU#1: syz.0.17/5961
Modules linked in:
CPU: 1 UID: 0 PID: 5961 Comm: syz.0.17 Tainted: G        W           syzkaller #0 PREEMPT(full) 
Tainted: [W]=WARN
Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS 1.16.2-debian-1.16.2-1 04/01/2014
RIP: 0010:rcu_note_context_switch+0xcac/0xf40 kernel/rcu/tree_plugin.h:332
Code: 00 41 c6 45 00 00 48 8b 3d b1 e5 65 0e 48 81 c4 b8 00 00 00 5b 41 5c 41 5d 41 5e 41 5f 5d e9 4b 63 ff ff 48 8d 3d 14 c3 69 0e <67> 48 0f b9 3a e9 1b f4 ff ff 90 0f 0b 90 45 84 e4 0f 84 ea f3 ff
RSP: 0000:ffffc900061dfbb0 EFLAGS: 00010002
RAX: 0000000000000000 RBX: ffff8881626b3a00 RCX: 0000000080000002
RDX: 0000000000000000 RSI: ffffffff8c27a4e0 RDI: ffffffff90150f10
RBP: dffffc0000000000 R08: ffffffff901183b7 R09: 1ffffffff2023076
R10: dffffc0000000000 R11: fffffbfff2023077 R12: 0000000000000000
R13: 0000000000000000 R14: ffff88823c63bd40 R15: ffff8881626b3e84
FS:  000055556739f500(0000) GS:ffff8882a9464000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 00007ffc9debcf78 CR3: 000000016d29c000 CR4: 00000000000006f0
Call Trace:
 <TASK>
 __schedule+0x2ff/0x5340 kernel/sched/core.c:6791
 __schedule_loop kernel/sched/core.c:6989 [inline]
 schedule+0x164/0x360 kernel/sched/core.c:7004
 __exit_to_user_mode_loop kernel/entry/common.c:54 [inline]
 exit_to_user_mode_loop kernel/entry/common.c:98 [inline]
 __exit_to_user_mode_prepare include/linux/irq-entry-common.h:226 [inline]
 irqentry_exit_to_user_mode_prepare include/linux/irq-entry-common.h:270 [inline]
 irqentry_exit_to_user_mode include/linux/irq-entry-common.h:339 [inline]
 irqentry_exit+0x155/0x620 kernel/entry/common.c:219
 asm_sysvec_call_function_single+0x1a/0x20 arch/x86/include/asm/idtentry.h:704
RIP: 0033:0x7f4c60b9c799
Code: ff c3 66 2e 0f 1f 84 00 00 00 00 00 0f 1f 44 00 00 48 89 f8 48 89 f7 48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 ff ff 73 01 c3 48 c7 c1 e8 ff ff ff f7 d8 64 89 01 48
RSP: 002b:00007ffc44689868 EFLAGS: 00000246
RAX: 0000000000000020 RBX: 00007f4c60e15fa0 RCX: 00007f4c60b9c799
RDX: 000000000000c000 RSI: 0000200000000000 RDI: 0000000000000003
RBP: 00007f4c60c32c99 R08: 0000000000000000 R09: 0000000000000000
R10: 0000000000000000 R11: 0000000000000246 R12: 0000000000000000
R13: 00007f4c60e15fac R14: 00007f4c60e15fa0 R15: 00007f4c60e15fa0
 </TASK>
----------------
Code disassembly (best guess):
   0:	00 41 c6             	add    %al,-0x3a(%rcx)
   3:	45 00 00             	add    %r8b,(%r8)
   6:	48 8b 3d b1 e5 65 0e 	mov    0xe65e5b1(%rip),%rdi        # 0xe65e5be
   d:	48 81 c4 b8 00 00 00 	add    $0xb8,%rsp
  14:	5b                   	pop    %rbx
  15:	41 5c                	pop    %r12
  17:	41 5d                	pop    %r13
  19:	41 5e                	pop    %r14
  1b:	41 5f                	pop    %r15
  1d:	5d                   	pop    %rbp
  1e:	e9 4b 63 ff ff       	jmp    0xffff636e
  23:	48 8d 3d 14 c3 69 0e 	lea    0xe69c314(%rip),%rdi        # 0xe69c33e
* 2a:	67 48 0f b9 3a       	ud1    (%edx),%rdi <-- trapping instruction
  2f:	e9 1b f4 ff ff       	jmp    0xfffff44f
  34:	90                   	nop
  35:	0f 0b                	ud2
  37:	90                   	nop
  38:	45 84 e4             	test   %r12b,%r12b
  3b:	0f                   	.byte 0xf
  3c:	84 ea                	test   %ch,%dl
  3e:	f3                   	repz
  3f:	ff                   	.byte 0xff


***

If these findings have caused you to resend the series or submit a
separate fix, please add the following tag to your commit message:
  Tested-by: syzbot@syzkaller.appspotmail.com

---
This report is generated by a bot. It may contain errors.
syzbot ci engineers can be reached at syzkaller@googlegroups.com.
