Received: from mail-io1-f70.google.com (mail-io1-f70.google.com [209.85.166.70])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1AE2C1E8338
	for <syzbot@lists.linux.dev>; Fri,  8 Aug 2025 19:33:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.70
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1754681632; cv=none; b=QBMUp4buK18w7N0/pyk2MjZzwtYbu7kQKPUI1bHIa3fmUyj5wcqwOQsNz17Hx9tJ3l2EjBCewjRPaN+DzmcZ2uJwt4vGuuSn61QsQHvrWuyl5Q7vb4kN62XNCB2V6lEaFjQdQtkfGL5y9ltioMXZ7WlwBiwzPOgFGTk1VETYC5o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1754681632; c=relaxed/simple;
	bh=ms/pVaoQqOgGiV430f2WqbB8SnyVC07S3OsBQ6xzaHg=;
	h=MIME-Version:Date:In-Reply-To:Message-ID:Subject:From:To:Cc:
	 Content-Type; b=uwMBm8Uvva0puTItYuTOJhXhxICTJ2JpkutCv57TPV7BlbvjCUJRjB2mFa/bGfolBm040VmZdcW2ISazEJng4XjcZS5Sgt88DM867KUDV+UbeoXuS/qq5gfGxjNLFcHbtBvjSlW9b+JxJuHC7i08V5Sn+ece8tV7BtMswLTEcj0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com; arc=none smtp.client-ip=209.85.166.70
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com
Received: by mail-io1-f70.google.com with SMTP id ca18e2360f4ac-881855cd566so248277139f.2
        for <syzbot@lists.linux.dev>; Fri, 08 Aug 2025 12:33:50 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1754681630; x=1755286430;
        h=cc:to:from:subject:message-id:in-reply-to:date:mime-version
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=PJ4QNSucLp3lg6gtIXtQ36rPonTR5UPedNLhb5Hvpj0=;
        b=LGwwME7hmOC+DCO4iQmIZgMW/kvpSnzmmlvOX8oFqGjxUkpFH+ZqFUBck31CDaKLYi
         20vL1EluAHKBftbO8pUc6L7H231+CDvDq+tYbUn2LNMzZwsVtk3jNgKbiqpNoMfXYHu6
         ghHQusOF4jUmyr8qmWqOa8MNmnIzV5hnAEmDdvNnNIsSeiYTqUneYjaqSAyJLqjZ5hH4
         Iit5ipTHEwEkI25wQKmW96TR6iQI8L01ByX0KKmjqjjUPlCRd4twgEgb4iBK/CPa4AX3
         IQfpafIjCrEJYfWNn+Etc0ViOvfILgNGS6uDWc3QnXZ2DP6XmfunpXJQw45juiFO5cz2
         beeg==
X-Gm-Message-State: AOJu0YxNqYt9ctMwgH198eossObGqKXB/bLQTD/erab3UqY9kTDQCv4D
	K9ImcgBWFWCXZ44s3cvauRx8FjoyPR6jHFgfV6DA90WIsJ4KGJN7VfhgnHifQsUvJ93LSdWhvbD
	f3dfjyWYA/ui5TdIh9bZo8LYsvaz2AnwWYchUaFUTCClcVhca9TcHI/2khyU=
X-Google-Smtp-Source: AGHT+IHDARiz/A/iKJftayzfILsno7n236kXIpOHO40uVKmHagaNTInRIv43JxuhI44oxt4yszG8HR7wlKSNUew80GHGyKx/KLJf
Precedence: bulk
X-Mailing-List: syzbot@lists.linux.dev
List-Id: <syzbot.lists.linux.dev>
List-Subscribe: <mailto:syzbot+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:syzbot+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Received: by 2002:a05:6602:1595:b0:881:99eb:e212 with SMTP id
 ca18e2360f4ac-883f12550d5mr771824239f.9.1754681630334; Fri, 08 Aug 2025
 12:33:50 -0700 (PDT)
Date: Fri, 08 Aug 2025 12:33:50 -0700
In-Reply-To: <20250808153721.261334-1-simon.schippers@tu-dortmund.de>
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <6896511e.050a0220.7f033.0088.GAE@google.com>
Subject: [syzbot ci] Re: TUN/TAP: Improving throughput and latency by avoiding
 SKB drops
From: syzbot ci <syzbot+cieaa424e2117e71dd@syzkaller.appspotmail.com>
To: jasowang@redhat.com, linux-kernel@vger.kernel.org, netdev@vger.kernel.org, 
	simon.schippers@tu-dortmund.de, tim.gebauer@tu-dortmund.de, 
	willemdebruijn.kernel@gmail.com
Cc: syzbot@lists.linux.dev, syzkaller-bugs@googlegroups.com
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
