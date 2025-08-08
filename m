Received: from mail-io1-f71.google.com (mail-io1-f71.google.com [209.85.166.71])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9A45F21D3F2
	for <syzbot@lists.linux.dev>; Fri,  8 Aug 2025 19:25:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.71
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1754681152; cv=none; b=sUvhzb9PDs83sWECN5Hcbji+D74HU74tkG8VZgDUcmIpIFaUNzVkDB66AAhUfA2g4nZlhydzk+ZhvxpTDgxBb/6r7rABDfIi05qjPmmCqgGW4IEr8Rp7dUTDHJ9CvH/bH3my3FsoqB+KG6P4RxFEfhZoo1YYVuShIqgt3isrlGA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1754681152; c=relaxed/simple;
	bh=s25OYODKD6omDXk437Qjwvm2LtsXU+dD8FJ3ij/n610=;
	h=MIME-Version:Date:Message-ID:Subject:From:To:Cc:Content-Type; b=pa9PmsBraoV7c8Zxq6nwb0M019/g4p5V8A20RG7tiR8inpbeSQtEKaKLEhQJxufsd9nVWDfS2Xtl8BDHaQpDCDz9BVAc8UIuLQEPav2hAI9qNoVjiLmPORMWBm0CIklfWO28KCY480VvOk9Eb6LwpjY9Etgowy6qawLsSk1Aw8c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com; arc=none smtp.client-ip=209.85.166.71
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com
Received: by mail-io1-f71.google.com with SMTP id ca18e2360f4ac-881878af906so434576239f.0
        for <syzbot@lists.linux.dev>; Fri, 08 Aug 2025 12:25:50 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1754681150; x=1755285950;
        h=cc:to:from:subject:message-id:date:mime-version:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=ZS9Wp/jXZspMvmDBHohkx+8Q3XL9dAg/XpIFkSE9yKM=;
        b=XQRTVSlvPlDqI3ts6OfZnmQoeZQgZQ+woSkxvXXQp8TOUIacjBmHXG5IKMIVJ+RQKf
         KgJA5oaiCfpCLN5j+bUBAA8lcyo7nbepR9KgQi6ZtFa9A07xlNvtMWJ6fEJ6/XAxQmMa
         1twNdCyyZ4teq+NaZd4ACL6hnNhzMfyq5cvMM7xyaXVKWAXURdUw+gMNcYbTuypD6his
         FC1pJ3JzbNFLHrDjsFyhCveSP7y43kzb0AmXNM7qLHFVxOF/C172fJT7iqzUyQ9knK7V
         zsejhXZNEgSXm44cdJg3J1Es7RCPIOO5VvkK4IXyAr5PHa9c54uUppKwSoA0HiVuhB0F
         TUcw==
X-Gm-Message-State: AOJu0YwYfyt8uLrmK9qlYVE8jH0Idgwszxgfk4kB3GDygNbyfhPq2/Sx
	zcU2i3iII9MN2+OU3UOxD49VSBcaam+3rLLjuQ/1lnxuzi+S7F1GP1dpk6mOfeacGNWtgIXC/R/
	+qPMa29J502kdqnoKTlsZNq/ms+6qovbtPSyXQqlnisrLHFKDoCdaDCDjMBY=
X-Google-Smtp-Source: AGHT+IGb9RdjK3eNaKX5+/10xC2e6oyanuwsh0VVZclr6H84lASDNVYEPsQMdZYEW+EGSkMBWq5INMWaLXTqIs9dShhSyhAsj4pq
Precedence: bulk
X-Mailing-List: syzbot@lists.linux.dev
List-Id: <syzbot.lists.linux.dev>
List-Subscribe: <mailto:syzbot+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:syzbot+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Received: by 2002:a5e:8f05:0:b0:87c:2e82:5a6a with SMTP id
 ca18e2360f4ac-883f11dc403mr763425439f.4.1754681149739; Fri, 08 Aug 2025
 12:25:49 -0700 (PDT)
Date: Fri, 08 Aug 2025 12:25:49 -0700
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <68964f3d.050a0220.7f033.0087.GAE@google.com>
Subject: [moderation/CI] Re: TUN/TAP: Improving throughput and latency by
 avoiding SKB drops
From: syzbot ci <syzbot+cidfe78bc1bc79cb69@syzkaller.appspotmail.com>
To: syzkaller-upstream-moderation@googlegroups.com
Cc: syzbot@lists.linux.dev
Content-Type: text/plain; charset="UTF-8"

syzbot ci has tested the following series

[v1] TUN/TAP: Improving throughput and latency by avoiding SKB drops
https://lore.kernel.org/all/20250808153721.261334-1-simon.schippers@tu-dortmund.de
* [PATCH net] TUN/TAP: Improving throughput and latency by avoiding SKB drops

and found the following issue:
general protection fault in tun_net_xmit

Full report is available here:
https://ci.syzbot.org/series/4a9dd6ad-3c81-4957-b447-4d1e8e9ee7a2

***

general protection fault in tun_net_xmit

tree:      net
URL:       https://kernel.googlesource.com/pub/scm/linux/kernel/git/netdev/net.git
base:      ae633388cae349886f1a3cfb27aa092854b24c1b
arch:      amd64
compiler:  Debian clang version 20.1.7 (++20250616065708+6146a88f6049-1~exp1~20250616065826.132), Debian LLD 20.1.7
config:    https://ci.syzbot.org/builds/f35af9e4-44af-4a13-8842-d9d36ecb06e7/config
C repro:   https://ci.syzbot.org/findings/e400bf02-40dc-43bb-8c15-d21b7ecb7304/c_repro
syz repro: https://ci.syzbot.org/findings/e400bf02-40dc-43bb-8c15-d21b7ecb7304/syz_repro

Oops: general protection fault, probably for non-canonical address 0xdffffc0000000002: 0000 [#1] SMP KASAN PTI
KASAN: null-ptr-deref in range [0x0000000000000010-0x0000000000000017]
CPU: 1 UID: 0 PID: 12 Comm: kworker/u8:0 Not tainted 6.16.0-syzkaller-06620-gae633388cae3-dirty #0 PREEMPT(full) 
Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS 1.16.2-debian-1.16.2-1 04/01/2014
Workqueue: ipv6_addrconf addrconf_dad_work
RIP: 0010:__ptr_ring_full include/linux/ptr_ring.h:51 [inline]
RIP: 0010:ptr_ring_full include/linux/ptr_ring.h:59 [inline]
RIP: 0010:tun_net_xmit+0x3ee/0x19c0 drivers/net/tun.c:1026
Code: 54 24 18 48 89 d0 48 c1 e8 03 48 89 44 24 58 42 0f b6 04 28 84 c0 0f 85 f9 11 00 00 48 63 02 48 8d 1c c3 48 89 d8 48 c1 e8 03 <42> 80 3c 28 00 74 08 48 89 df e8 d3 0f ac fb 48 8b 1b 48 8b 7c 24
RSP: 0018:ffffc900000f6f00 EFLAGS: 00010202
RAX: 0000000000000002 RBX: 0000000000000010 RCX: dffffc0000000000
RDX: ffff88811bf90940 RSI: 0000000000000004 RDI: ffffc900000f6e80
RBP: ffffc900000f7050 R08: 0000000000000003 R09: 0000000000000004
R10: dffffc0000000000 R11: fffff5200001edd0 R12: 0000000000000000
R13: dffffc0000000000 R14: ffff8881054c8000 R15: 0000000000000000
FS:  0000000000000000(0000) GS:ffff8881a3c80000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 0000200000002280 CR3: 0000000110b70000 CR4: 00000000000006f0
Call Trace:
 <TASK>
 __netdev_start_xmit include/linux/netdevice.h:5219 [inline]
 netdev_start_xmit include/linux/netdevice.h:5228 [inline]
 xmit_one net/core/dev.c:3827 [inline]
 dev_hard_start_xmit+0x2d7/0x830 net/core/dev.c:3843
 sch_direct_xmit+0x241/0x4b0 net/sched/sch_generic.c:344
 __dev_xmit_skb net/core/dev.c:4102 [inline]
 __dev_queue_xmit+0x1857/0x3b50 net/core/dev.c:4679
 neigh_output include/net/neighbour.h:547 [inline]
 ip6_finish_output2+0x11fe/0x16a0 net/ipv6/ip6_output.c:141
 NF_HOOK include/linux/netfilter.h:318 [inline]
 ndisc_send_skb+0xb54/0x1440 net/ipv6/ndisc.c:512
 addrconf_dad_completed+0x7ae/0xd60 net/ipv6/addrconf.c:4360
 addrconf_dad_work+0xc36/0x14b0 net/ipv6/addrconf.c:-1
 process_one_work kernel/workqueue.c:3238 [inline]
 process_scheduled_works+0xae1/0x17b0 kernel/workqueue.c:3321
 worker_thread+0x8a0/0xda0 kernel/workqueue.c:3402
 kthread+0x711/0x8a0 kernel/kthread.c:464
 ret_from_fork+0x3fc/0x770 arch/x86/kernel/process.c:148
 ret_from_fork_asm+0x1a/0x30 arch/x86/entry/entry_64.S:245
 </TASK>
Modules linked in:
---[ end trace 0000000000000000 ]---
RIP: 0010:__ptr_ring_full include/linux/ptr_ring.h:51 [inline]
RIP: 0010:ptr_ring_full include/linux/ptr_ring.h:59 [inline]
RIP: 0010:tun_net_xmit+0x3ee/0x19c0 drivers/net/tun.c:1026
Code: 54 24 18 48 89 d0 48 c1 e8 03 48 89 44 24 58 42 0f b6 04 28 84 c0 0f 85 f9 11 00 00 48 63 02 48 8d 1c c3 48 89 d8 48 c1 e8 03 <42> 80 3c 28 00 74 08 48 89 df e8 d3 0f ac fb 48 8b 1b 48 8b 7c 24
RSP: 0018:ffffc900000f6f00 EFLAGS: 00010202
RAX: 0000000000000002 RBX: 0000000000000010 RCX: dffffc0000000000
RDX: ffff88811bf90940 RSI: 0000000000000004 RDI: ffffc900000f6e80
RBP: ffffc900000f7050 R08: 0000000000000003 R09: 0000000000000004
R10: dffffc0000000000 R11: fffff5200001edd0 R12: 0000000000000000
R13: dffffc0000000000 R14: ffff8881054c8000 R15: 0000000000000000
FS:  0000000000000000(0000) GS:ffff8881a3c80000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 0000200000002280 CR3: 0000000110b70000 CR4: 00000000000006f0
----------------
Code disassembly (best guess):
   0:	54                   	push   %rsp
   1:	24 18                	and    $0x18,%al
   3:	48 89 d0             	mov    %rdx,%rax
   6:	48 c1 e8 03          	shr    $0x3,%rax
   a:	48 89 44 24 58       	mov    %rax,0x58(%rsp)
   f:	42 0f b6 04 28       	movzbl (%rax,%r13,1),%eax
  14:	84 c0                	test   %al,%al
  16:	0f 85 f9 11 00 00    	jne    0x1215
  1c:	48 63 02             	movslq (%rdx),%rax
  1f:	48 8d 1c c3          	lea    (%rbx,%rax,8),%rbx
  23:	48 89 d8             	mov    %rbx,%rax
  26:	48 c1 e8 03          	shr    $0x3,%rax
* 2a:	42 80 3c 28 00       	cmpb   $0x0,(%rax,%r13,1) <-- trapping instruction
  2f:	74 08                	je     0x39
  31:	48 89 df             	mov    %rbx,%rdi
  34:	e8 d3 0f ac fb       	call   0xfbac100c
  39:	48 8b 1b             	mov    (%rbx),%rbx
  3c:	48                   	rex.W
  3d:	8b                   	.byte 0x8b
  3e:	7c 24                	jl     0x64


***

If these findings have caused you to resend the series or submit a
separate fix, please add the following tag to your commit message:
Tested-by: syzbot@syzkaller.appspotmail.com

---
This report is generated by a bot. It may contain errors.
syzbot ci engineers can be reached at syzkaller@googlegroups.com.

The email will later be sent to:
[jasowang@redhat.com linux-kernel@vger.kernel.org netdev@vger.kernel.org simon.schippers@tu-dortmund.de tim.gebauer@tu-dortmund.de willemdebruijn.kernel@gmail.com]

If the report looks fine to you, reply with:
#syz upstream

