Received: from mail-oo1-f72.google.com (mail-oo1-f72.google.com [209.85.161.72])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 126E4346FB3
	for <syzbot@lists.linux.dev>; Fri,  6 Feb 2026 08:32:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.161.72
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770366734; cv=none; b=RoPYhqa9mdvyjeidN8HIh3GFg1/NiBIYz5UBUqR+LLUC29qGbTTWy0gKL7mU0J316JzeKaW9lEOqfMFFhk2m420wFv1K+2ydJsYfqaJGMhRDx0DernpeU6GKoYuSfANrmI1U0IgRknsPnPK80wyeXqDNEWTc1CxayyCzIiEfIwM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770366734; c=relaxed/simple;
	bh=L5b8qOVQgNvhOSD+v+84L84qH7uRefmcsqF3UxEZMpE=;
	h=MIME-Version:Date:In-Reply-To:Message-ID:Subject:From:To:Cc:
	 Content-Type; b=Lea7Dl68u23skt9Ljo+8kzqykpkzN1WB+G0lX2kzNh6Ihdk10jPfu5APr5TbFpdgb+N/mgkPFdOvZ0luEitIjveyVRNKGyLnJkP5UjjJbQt3evivtYWIjX5diBEW967E8KmbEoEbjJxNgZdAJJnfUh9E26/+H7rW1R9Trz0kHrA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com; arc=none smtp.client-ip=209.85.161.72
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com
Received: by mail-oo1-f72.google.com with SMTP id 006d021491bc7-662f839d680so534136eaf.2
        for <syzbot@lists.linux.dev>; Fri, 06 Feb 2026 00:32:13 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1770366733; x=1770971533;
        h=cc:to:from:subject:message-id:in-reply-to:date:mime-version
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=dPmTo2ri7jG36KtEfZNF+L2qJMQS+9NuLWlVMlY7PME=;
        b=oMHhIEVIZUVf6A76YTM1CbzbIzZUmlT4O9mM8RMNCX1lbItU497zViN+uqKKEc9L5L
         Cn3KdqtKqjOg8Hcvq+EZyqeak51hwyrGMCa0x9+SKDDjA/1TaPJZ4rM8fXgJvDUaLkaQ
         1SVIA3MjVvCl2eKHuURBm18hBWfDh0aaDrU7n1s8cwqHZGgogmWxRCO+UT2ctYfbxh21
         albPMpr9ZW3SId6oHEZl+ULFjyLEsSlB5G6lX9zO6M7lpznvMySjtzyHKstYJTk6pIbS
         DfpGSH1HAdz5PRNHmjnH2cV7pUmqvlTwXX0WLyXHEos/CMLOqzj6vtj1gdeFs0gLkxO/
         ANhg==
X-Gm-Message-State: AOJu0YzPuj3RN6ZTH5NoAfhdtJFx6fwjfB2hRN3+BiIlZu/d13wvywJW
	KxoCFzVivdkBbN7bQ9ZRf4QXU5t7wKrD4H0HhmSbSkxp8Z0tftkeRrcJWvaPzUniFn0swbNjcp8
	pi63XRukfj0f6cHusA9WQiPRaaxSRfV4peG5fnfvTh6VDI3orfH312H6ozyk=
Precedence: bulk
X-Mailing-List: syzbot@lists.linux.dev
List-Id: <syzbot.lists.linux.dev>
List-Subscribe: <mailto:syzbot+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:syzbot+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Received: by 2002:a05:6820:3093:b0:663:8c6:978c with SMTP id
 006d021491bc7-66d0c75d6a8mr1083916eaf.65.1770366732936; Fri, 06 Feb 2026
 00:32:12 -0800 (PST)
Date: Fri, 06 Feb 2026 00:32:12 -0800
In-Reply-To: <177032644012.1975497.16411100029657607833.stgit@firesoul>
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <6985a70c.050a0220.3b3015.0034.GAE@google.com>
Subject: [syzbot ci] Re: net: sched: refactor qdisc drop reasons into
 dedicated tracepoint
From: syzbot ci <syzbot+ci335f183b8446659a@syzkaller.appspotmail.com>
To: atenart@redhat.com, bpf@vger.kernel.org, carges@cloudflare.com, 
	davem@davemloft.net, edumazet@google.com, eric.dumazet@gmail.com, 
	hawk@kernel.org, horms@kernel.org, jhs@mojatatu.com, jiri@resnulli.us, 
	kernel-team@cloudflare.com, kuba@kernel.org, netdev@vger.kernel.org, 
	pabeni@redhat.com, toke@toke.dk, xiyou.wangcong@gmail.com
Cc: syzbot@lists.linux.dev, syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"

syzbot ci has tested the following series

[v2] net: sched: refactor qdisc drop reasons into dedicated tracepoint
https://lore.kernel.org/all/177032644012.1975497.16411100029657607833.stgit@firesoul
* [PATCH net-next v2 1/6] net: sched: introduce qdisc-specific drop reason tracing
* [PATCH net-next v2 2/6] net: sched: sfq: convert to qdisc drop reasons
* [PATCH net-next v2 3/6] net: sched: sch_cake: use enum qdisc_drop_reason for cobalt_should_drop
* [PATCH net-next v2 4/6] net: sched: rename QDISC_DROP_CAKE_FLOOD to QDISC_DROP_FLOOD_PROTECTION
* [PATCH net-next v2 5/6] net: sched: rename QDISC_DROP_FQ_* to generic names
* [PATCH net-next v2 6/6] net: sched: sch_dualpi2: use qdisc_dequeue_drop() for dequeue drops

and found the following issue:
WARNING in __dev_queue_xmit

Full report is available here:
https://ci.syzbot.org/series/51381d54-6fc9-4542-a8cd-eac656a11965

***

WARNING in __dev_queue_xmit

tree:      net-next
URL:       https://kernel.googlesource.com/pub/scm/linux/kernel/git/netdev/net-next.git
base:      7a4cd71fa4514cd85df39b3cf99da8142660cdcd
arch:      amd64
compiler:  Debian clang version 21.1.8 (++20251221033036+2078da43e25a-1~exp1~20251221153213.50), Debian LLD 21.1.8
config:    https://ci.syzbot.org/builds/17bc5e9e-8ccc-4afb-a291-312bbc43df20/config
C repro:   https://ci.syzbot.org/findings/20939160-05e8-4589-a6d5-6a253d5e39b0/c_repro
syz repro: https://ci.syzbot.org/findings/20939160-05e8-4589-a6d5-6a253d5e39b0/syz_repro

syzkaller0: entered promiscuous mode
syzkaller0: entered allmulticast mode
------------[ cut here ]------------
reason && reason < __QDISC_DROP_REASON
WARNING: net/sched/sch_generic.c:50 at tcf_kfree_skb_list+0xd6/0x100 net/sched/sch_generic.c:50, CPU#0: syz.0.17/5949
Modules linked in:
CPU: 0 UID: 0 PID: 5949 Comm: syz.0.17 Not tainted syzkaller #0 PREEMPT(full) 
Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS 1.16.2-debian-1.16.2-1 04/01/2014
RIP: 0010:tcf_kfree_skb_list+0xd6/0x100 net/sched/sch_generic.c:50
Code: 89 e8 e8 5d 00 00 00 31 ff 4c 89 e6 ba 40 00 00 00 e8 be e6 d6 ff 4c 8b 24 24 4d 85 e4 74 27 e9 6e ff ff ff e8 1b f3 50 f8 90 <0f> 0b 90 eb c4 44 89 e9 80 e1 07 80 c1 03 38 c1 7c 96 4c 89 ef e8
RSP: 0018:ffffc90003e67360 EFLAGS: 00010293
RAX: ffffffff89718645 RBX: ffff8881133cc000 RCX: ffff8881738b9d40
RDX: 0000000000000000 RSI: 0000000000000001 RDI: 000000000002ffff
RBP: 0000000000000001 R08: ffff88811571195b R09: 1ffff11022ae232b
R10: dffffc0000000000 R11: ffffed1022ae232c R12: ffff88810a9bca80
R13: 0000000000000002 R14: ffff888109569400 R15: ffff888115711800
FS:  000055558d217500(0000) GS:ffff88818e31a000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 0000200000001410 CR3: 0000000166b9c000 CR4: 00000000000006f0
Call Trace:
 <TASK>
 __dev_xmit_skb net/core/dev.c:4272 [inline]
 __dev_queue_xmit+0x18e5/0x3180 net/core/dev.c:4797
 packet_snd net/packet/af_packet.c:3077 [inline]
 packet_sendmsg+0x3eb6/0x50f0 net/packet/af_packet.c:3109
 sock_sendmsg_nosec net/socket.c:727 [inline]
 __sock_sendmsg+0x21c/0x270 net/socket.c:742
 ____sys_sendmsg+0x4d7/0x810 net/socket.c:2592
 ___sys_sendmsg+0x2a5/0x360 net/socket.c:2646
 __sys_sendmsg net/socket.c:2678 [inline]
 __do_sys_sendmsg net/socket.c:2683 [inline]
 __se_sys_sendmsg net/socket.c:2681 [inline]
 __x64_sys_sendmsg+0x1bd/0x2a0 net/socket.c:2681
 do_syscall_x64 arch/x86/entry/syscall_64.c:63 [inline]
 do_syscall_64+0xe2/0xf80 arch/x86/entry/syscall_64.c:94
 entry_SYSCALL_64_after_hwframe+0x77/0x7f
RIP: 0033:0x7f6544b9acb9
Code: ff c3 66 2e 0f 1f 84 00 00 00 00 00 0f 1f 44 00 00 48 89 f8 48 89 f7 48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 ff ff 73 01 c3 48 c7 c1 e8 ff ff ff f7 d8 64 89 01 48
RSP: 002b:00007ffc871586c8 EFLAGS: 00000246 ORIG_RAX: 000000000000002e
RAX: ffffffffffffffda RBX: 00007f6544e15fa0 RCX: 00007f6544b9acb9
RDX: 0000000000000004 RSI: 00002000000000c0 RDI: 0000000000000008
RBP: 00007f6544c08bf7 R08: 0000000000000000 R09: 0000000000000000
R10: 0000000000000000 R11: 0000000000000246 R12: 0000000000000000
R13: 00007f6544e15fac R14: 00007f6544e15fa0 R15: 00007f6544e15fa0
 </TASK>


***

If these findings have caused you to resend the series or submit a
separate fix, please add the following tag to your commit message:
  Tested-by: syzbot@syzkaller.appspotmail.com

---
This report is generated by a bot. It may contain errors.
syzbot ci engineers can be reached at syzkaller@googlegroups.com.
