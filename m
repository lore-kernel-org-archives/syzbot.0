Received: from mail-oi1-f197.google.com (mail-oi1-f197.google.com [209.85.167.197])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D0599305E19
	for <syzbot@lists.linux.dev>; Thu,  9 Jul 2026 19:55:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.167.197
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783626931; cv=none; b=kSOnAVYV52DdyAiR6sfglgW6W+RBwIAz1zYYjn8ePF3v9/0So5RX5CH6yqChBlYbfEwByRfuFZBjmR1xO326MTX/1e1iFvslOKfG2OxbH6SQECuOs90kv/8k3QhOjDwH4j6HCshDzC+h/ZuDBQMUW5PDtWtUYqjqEFGhNnkjWrQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783626931; c=relaxed/simple;
	bh=w32HbNOIzKmhkWsudd8fuJaJExiS7rxFrs8Hs7p9OQY=;
	h=MIME-Version:Date:Message-ID:Subject:From:To:Cc:Content-Type; b=ZRmv+yyZbAqJ6+GDfBKr+jyAlws5SjguR3CqkMCJUzRf6StWDmFmtlRppAcZwy0BlFB3Y/gyQDDYAa+JoOp4TOncozN6ucXIH/HzX46kxoJ6AWoPMJinxAImi43szoclfITG6837jfTfq5VDOCKPZKn6kL/YOt2GM7NHLG1JUnA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com; arc=none smtp.client-ip=209.85.167.197
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com
Received: by mail-oi1-f197.google.com with SMTP id 5614622812f47-48f0e5e664aso121145b6e.1
        for <syzbot@lists.linux.dev>; Thu, 09 Jul 2026 12:55:29 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1783626929; x=1784231729;
        h=content-type:cc:to:from:subject:message-id:date:mime-version
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=wxeWHgE2Zw5oSAUMqMz+HELZmnJAIc1WVmlzaB8g8HI=;
        b=krdv6i8E5HDauuGsQX/raJoPFE1n7q3EWpYWJcxbfeMuukIaWTpJLFRJ5hfq8jr6kZ
         GuqtY328B3EHzo6FrKMx6TwcOduVD+FmfdjWuHTbI4uZ8CwYrAxk1JOMzhYkZDKee8RH
         6fXvjS/owOe1UfKMfm9hItyKDwCg2aArzTRm3kZ4Zws1c6YrAmtO0ydCwWFO7XR7Phze
         32BTGgaI66W6TGBrwNQvGT64Ecp4h52DRMX1cWxbXIcxyX+EqAJg3UlOpF69hQGFFZ/6
         Gb5zBsEdkp6w91enRgsmX+XO1sMJAc4XvWUs0O9QTQTwxL+X70Hq3k1ocdA9ssEw71JA
         qkuA==
X-Gm-Message-State: AOJu0YycOo4VlhX/nTYUbMrFUtidl4g38K67SK98eOXI/FTxn0/MJbyf
	8H+SUQVD04LomFEZ/Di3VbS0d3/X9J+Jga7oU2GifvMtWJU1/7RCrv2eX8O4GA4X7jo4N70+/AG
	wAMcwst7FKUfFPLiWEij35awUh2my179cVpeQ/L109ckLq6DRAneoXp0n8/4=
Precedence: bulk
X-Mailing-List: syzbot@lists.linux.dev
List-Id: <syzbot.lists.linux.dev>
List-Subscribe: <mailto:syzbot+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:syzbot+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Received: by 2002:a05:6808:2f10:b0:49a:8f0d:cdc6 with SMTP id
 5614622812f47-4a2051049e1mr6916242b6e.34.1783626928870; Thu, 09 Jul 2026
 12:55:28 -0700 (PDT)
Date: Thu, 09 Jul 2026 12:55:28 -0700
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <6a4ffcb0.c76b52dc.2a15e.0000.GAE@google.com>
Subject: [moderation/CI] Re: netfilter: flowtable: tear down HW offloaded
 flows on FIB route changes
From: syzbot ci <syzbot+cid7cd031fc49e60cf@syzkaller.appspotmail.com>
To: syzkaller-upstream-moderation@googlegroups.com
Cc: syzbot@lists.linux.dev
Content-Type: text/plain; charset="UTF-8"

syzbot ci has tested the following series

[v1] netfilter: flowtable: tear down HW offloaded flows on FIB route changes
https://lore.kernel.org/all/20260708205404.911832-1-anzaki@gmail.com
* [PATCH nf] netfilter: flowtable: tear down HW offloaded flows on FIB route changes

and found the following issue:
general protection fault in net_generic

Full report is available here:
https://ci.syzbot.org/series/75cd5a68-8e8e-41ef-9da6-dea3554407a7

***

general protection fault in net_generic

tree:      nf
URL:       https://kernel.googlesource.com/pub/scm/linux/kernel/git/netfilter/nf.git
base:      60444706aa17616efc03190d099ac347e28b3d0a
arch:      amd64
compiler:  Debian clang version 22.1.6 (++20260514074242+fc4aad7b5db3-1~exp1~20260514074407.73), Debian LLD 22.1.6
config:    https://ci.syzbot.org/builds/b941607c-6459-4d25-8127-6c11f2a37ef0/config
syz repro: https://ci.syzbot.org/findings/93de0afd-01d4-4d54-9d3f-13094335f314/syz_repro

Oops: general protection fault, probably for non-canonical address 0xdffffc00000002c8: 0000 [#1] SMP KASAN PTI
KASAN: probably user-memory-access in range [0x0000000000001640-0x0000000000001647]
CPU: 1 UID: 0 PID: 5813 Comm: syz.2.19 Not tainted syzkaller #0 PREEMPT(full) 
Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS 1.16.2-debian-1.16.2-1 04/01/2014
RIP: 0010:net_generic+0xd4/0x240 include/net/netns/generic.h:46
Code: 8c be 4a 03 00 00 48 c7 c2 c0 83 e0 8c e8 14 1b 09 f8 49 bf 00 00 00 00 00 fc ff df 49 81 c6 40 16 00 00 4c 89 f0 48 c1 e8 03 <42> 80 3c 38 00 74 08 4c 89 f7 e8 0d a4 9a f8 4d 8b 26 e8 45 e8 1b
RSP: 0018:ffffc90003bde998 EFLAGS: 00010202
RAX: 00000000000002c8 RBX: ffffffff8999417e RCX: ffff8881699c5940
RDX: 0000000000000000 RSI: ffffffff8c2ab760 RDI: ffffffff8c2ab720
RBP: 0000000000000005 R08: ffffffff8999417e R09: 0000000000000000
R10: 0000000000000000 R11: ffffffff8e959c20 R12: ffff8881b1679870
R13: dffffc0000000000 R14: 0000000000001640 R15: dffffc0000000000
FS:  00007ff6de31c6c0(0000) GS:ffff8882a921d000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 00007ff6dd272780 CR3: 000000016bc8e000 CR4: 00000000000006f0
Call Trace:
 <TASK>
 fib_seq_sum+0x29/0x280 net/core/fib_notifier.c:43
 register_fib_notifier+0x49/0x360 net/core/fib_notifier.c:106
 nf_flow_table_init+0x34a/0x460 net/netfilter/nf_flow_table_core.c:888
 tcf_ct_flow_table_get+0x13b6/0x1f40 net/sched/act_ct.c:352
 tcf_ct_init+0x6bd/0xb10 net/sched/act_ct.c:1423
 tcf_action_init_1+0x4ba/0x740 net/sched/act_api.c:1433
 tcf_action_init+0x30e/0xb10 net/sched/act_api.c:1508
 tcf_action_add net/sched/act_api.c:2106 [inline]
 tc_ctl_action+0x43b/0xc70 net/sched/act_api.c:2163
 rtnetlink_rcv_msg+0x7b9/0xc00 net/core/rtnetlink.c:7085
 netlink_rcv_skb+0x226/0x4a0 net/netlink/af_netlink.c:2556
 netlink_unicast_kernel net/netlink/af_netlink.c:1319 [inline]
 netlink_unicast+0x7bb/0x940 net/netlink/af_netlink.c:1345
 netlink_sendmsg+0x813/0xb40 net/netlink/af_netlink.c:1900
 sock_sendmsg_nosec+0x13a/0x180 net/socket.c:775
 __sock_sendmsg net/socket.c:790 [inline]
 ____sys_sendmsg+0x54e/0x850 net/socket.c:2684
 ___sys_sendmsg+0x2a5/0x360 net/socket.c:2738
 __sys_sendmsg net/socket.c:2770 [inline]
 __do_sys_sendmsg net/socket.c:2775 [inline]
 __se_sys_sendmsg net/socket.c:2773 [inline]
 __x64_sys_sendmsg+0x1b1/0x290 net/socket.c:2773
 do_syscall_x64 arch/x86/entry/syscall_64.c:63 [inline]
 do_syscall_64+0x174/0x580 arch/x86/entry/syscall_64.c:94
 entry_SYSCALL_64_after_hwframe+0x77/0x7f
RIP: 0033:0x7ff6dd39ce59
Code: ff c3 66 2e 0f 1f 84 00 00 00 00 00 0f 1f 44 00 00 48 89 f8 48 89 f7 48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 ff ff 73 01 c3 48 c7 c1 e8 ff ff ff f7 d8 64 89 01 48
RSP: 002b:00007ff6de31c028 EFLAGS: 00000246 ORIG_RAX: 000000000000002e
RAX: ffffffffffffffda RBX: 00007ff6dd615fa0 RCX: 00007ff6dd39ce59
RDX: 0000000000000040 RSI: 0000200000000080 RDI: 0000000000000003
RBP: 00007ff6dd432e6f R08: 0000000000000000 R09: 0000000000000000
R10: 0000000000000000 R11: 0000000000000246 R12: 0000000000000000
R13: 00007ff6dd616038 R14: 00007ff6dd615fa0 R15: 00007ffd83f8d058
 </TASK>
Modules linked in:
---[ end trace 0000000000000000 ]---
RIP: 0010:net_generic+0xd4/0x240 include/net/netns/generic.h:46
Code: 8c be 4a 03 00 00 48 c7 c2 c0 83 e0 8c e8 14 1b 09 f8 49 bf 00 00 00 00 00 fc ff df 49 81 c6 40 16 00 00 4c 89 f0 48 c1 e8 03 <42> 80 3c 38 00 74 08 4c 89 f7 e8 0d a4 9a f8 4d 8b 26 e8 45 e8 1b
RSP: 0018:ffffc90003bde998 EFLAGS: 00010202
RAX: 00000000000002c8 RBX: ffffffff8999417e RCX: ffff8881699c5940
RDX: 0000000000000000 RSI: ffffffff8c2ab760 RDI: ffffffff8c2ab720
RBP: 0000000000000005 R08: ffffffff8999417e R09: 0000000000000000
R10: 0000000000000000 R11: ffffffff8e959c20 R12: ffff8881b1679870
R13: dffffc0000000000 R14: 0000000000001640 R15: dffffc0000000000
FS:  00007ff6de31c6c0(0000) GS:ffff8882a921d000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 00007ff6dd3ea540 CR3: 000000016bc8e000 CR4: 00000000000006f0
----------------
Code disassembly (best guess):
   0:	8c be 4a 03 00 00    	mov    %?,0x34a(%rsi)
   6:	48 c7 c2 c0 83 e0 8c 	mov    $0xffffffff8ce083c0,%rdx
   d:	e8 14 1b 09 f8       	call   0xf8091b26
  12:	49 bf 00 00 00 00 00 	movabs $0xdffffc0000000000,%r15
  19:	fc ff df
  1c:	49 81 c6 40 16 00 00 	add    $0x1640,%r14
  23:	4c 89 f0             	mov    %r14,%rax
  26:	48 c1 e8 03          	shr    $0x3,%rax
* 2a:	42 80 3c 38 00       	cmpb   $0x0,(%rax,%r15,1) <-- trapping instruction
  2f:	74 08                	je     0x39
  31:	4c 89 f7             	mov    %r14,%rdi
  34:	e8 0d a4 9a f8       	call   0xf89aa446
  39:	4d 8b 26             	mov    (%r14),%r12
  3c:	e8                   	.byte 0xe8
  3d:	45                   	rex.RB
  3e:	e8                   	.byte 0xe8
  3f:	1b                   	.byte 0x1b


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
[anzaki@gmail.com davem@davemloft.net edumazet@google.com fw@strlen.de horms@kernel.org kuba@kernel.org netdev@vger.kernel.org netfilter-devel@vger.kernel.org pabeni@redhat.com pablo@netfilter.org]

If the report looks fine to you, reply with:
#syz upstream

If the report is a false positive, reply with
#syz invalid

