Received: from mail-il1-f199.google.com (mail-il1-f199.google.com [209.85.166.199])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7F69230DD04
	for <syzbot@lists.linux.dev>; Tue, 11 Nov 2025 14:09:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.199
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762870143; cv=none; b=pLpT+QanJwlWB5oRb2UBAsdfHFsqVo6xOvwGzvRjJHnElYjz/2R8I7ushdO5I4OjWxyQJ+rojLuV/2z25B99+QHqFbjdaKztY3D7h9+wI5C6GoCOrFHlRxxREtZ9aX9sL7LK07IeC8Ag+BFk9X6a0zY2QtSq1I8+yKHDIRQPyhM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762870143; c=relaxed/simple;
	bh=ArxyiOFu7/8nPuiBy4ho5ISc1baKmkk5k3bM0YU9jAo=;
	h=MIME-Version:Date:In-Reply-To:Message-ID:Subject:From:To:Cc:
	 Content-Type; b=Jz63Jl7OCZJdkzDvq/TupNyL5FUdWdZMtO0udtW4D8hMwQP6TbvuvXfby9UrF0CxP9BF3+lVmP7GfOLE7ijSVoSbv3Fvx6bkxzwey8q8F4ByoExWSytmW0g4hUMFMAGcXRcpxdhZFdTWusyGZTwD4a0jtZbIIWZcyBLS+PPgxUM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com; arc=none smtp.client-ip=209.85.166.199
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com
Received: by mail-il1-f199.google.com with SMTP id e9e14a558f8ab-433199c7fb4so42785805ab.3
        for <syzbot@lists.linux.dev>; Tue, 11 Nov 2025 06:09:01 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1762870140; x=1763474940;
        h=cc:to:from:subject:message-id:in-reply-to:date:mime-version
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=PaHLk+lw4hWVTyNp1Y0Jwl5O/xRGp4qKtAJp6UDcmMs=;
        b=PeRBvZVmqJO5HFc89681dZXOERE+3rkjONAQCcFWdVYafR1DD7X32V/Ndfr23Y9Hw5
         5rfTvSFFmDV6puceDaSclVFrma8hzFltDyyr4JTvxUGzeP6M+vCHseRTQP58VgHBkKDh
         DnCLkd9Z57OJT5YtzimqCdZg+kKi3bHbUfPwYJ3eWJ7RGKw2HY90cg1Rw8vdRIXxrnE7
         iRW0gmgWsOzpBaPPBbh5bItbZN9I81C+WwvRhIURFVxERbh5pcJM67TOJvrd8wA3JTV0
         lwKx397jwXl0LLG0m3EtY0Zb8Yu2VcZv7LzDHjQ4m0IctaAg6AGOMPHme8ZseFO/cM2C
         9E3Q==
X-Gm-Message-State: AOJu0YxCxksn3gSrUmiebPieIyh0CIzJ/uBsulQkmlZHHCS+rotYNoFR
	hBQrkeyeBGcp9k2LtxrFpk8NsBh6e/2D4dCVInKKB/JC9Z4wERn8f4UJoG+pa6KwqBRxl+WPaQ+
	2Op82IO8u/7SB2QHouM3HQb8YVBDLr/3mby0BO/m4wK3w1CRcIXRXgBK2hPg=
X-Google-Smtp-Source: AGHT+IE7DtU6V4dhm/rWWcNSb5/hQIvNn1t/ULtONi24IfVW4Jych9CAA/Xz4bqSTtPjaX1/qcCkWQ658GMba752eB1QKUSMu8X0
Precedence: bulk
X-Mailing-List: syzbot@lists.linux.dev
List-Id: <syzbot.lists.linux.dev>
List-Subscribe: <mailto:syzbot+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:syzbot+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Received: by 2002:a05:6e02:1b01:b0:433:5736:96a2 with SMTP id
 e9e14a558f8ab-43367e25667mr203330615ab.12.1762870140567; Tue, 11 Nov 2025
 06:09:00 -0800 (PST)
Date: Tue, 11 Nov 2025 06:09:00 -0800
In-Reply-To: <20251111093204.1432437-1-edumazet@google.com>
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <6913437c.a70a0220.22f260.013b.GAE@google.com>
Subject: [syzbot ci] Re: net_sched: speedup qdisc dequeue
From: syzbot ci <syzbot+ci51c71986dfbbfee2@syzkaller.appspotmail.com>
To: davem@davemloft.net, edumazet@google.com, eric.dumazet@gmail.com, 
	horms@kernel.org, jhs@mojatatu.com, jiri@resnulli.us, kuba@kernel.org, 
	kuniyu@google.com, netdev@vger.kernel.org, pabeni@redhat.com, toke@redhat.com, 
	willemb@google.com, xiyou.wangcong@gmail.com
Cc: syzbot@lists.linux.dev, syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"

syzbot ci has tested the following series

[v2] net_sched: speedup qdisc dequeue
https://lore.kernel.org/all/20251111093204.1432437-1-edumazet@google.com
* [PATCH v2 net-next 01/14] net_sched: make room for (struct qdisc_skb_cb)->pkt_segs
* [PATCH v2 net-next 02/14] net: init shinfo->gso_segs from qdisc_pkt_len_init()
* [PATCH v2 net-next 03/14] net_sched: initialize qdisc_skb_cb(skb)->pkt_segs in qdisc_pkt_len_init()
* [PATCH v2 net-next 04/14] net: use qdisc_pkt_len_segs_init() in sch_handle_ingress()
* [PATCH v2 net-next 05/14] net_sched: use qdisc_skb_cb(skb)->pkt_segs in bstats_update()
* [PATCH v2 net-next 06/14] net_sched: cake: use qdisc_pkt_segs()
* [PATCH v2 net-next 07/14] net_sched: add Qdisc_read_mostly and Qdisc_write groups
* [PATCH v2 net-next 08/14] net_sched: sch_fq: move qdisc_bstats_update() to fq_dequeue_skb()
* [PATCH v2 net-next 09/14] net_sched: sch_fq: prefetch one skb ahead in dequeue()
* [PATCH v2 net-next 10/14] net: prefech skb->priority in __dev_xmit_skb()
* [PATCH v2 net-next 11/14] net: annotate a data-race in __dev_xmit_skb()
* [PATCH v2 net-next 12/14] net_sched: add tcf_kfree_skb_list() helper
* [PATCH v2 net-next 13/14] net_sched: add qdisc_dequeue_drop() helper
* [PATCH v2 net-next 14/14] net_sched: use qdisc_dequeue_drop() in cake, codel, fq_codel

and found the following issue:
WARNING in sk_skb_reason_drop

Full report is available here:
https://ci.syzbot.org/series/a9dbee91-6b1f-4ab9-b55d-43f7f50de064

***

WARNING in sk_skb_reason_drop

tree:      net-next
URL:       https://kernel.googlesource.com/pub/scm/linux/kernel/git/netdev/net-next.git
base:      a0c3aefb08cd81864b17c23c25b388dba90b9dad
arch:      amd64
compiler:  Debian clang version 20.1.8 (++20250708063551+0c9f909b7976-1~exp1~20250708183702.136), Debian LLD 20.1.8
config:    https://ci.syzbot.org/builds/a5059d85-d1f8-4036-a0fd-b677b5945ea9/config
C repro:   https://ci.syzbot.org/findings/e529fc3a-766e-4d6c-899a-c35a8fdaa940/c_repro
syz repro: https://ci.syzbot.org/findings/e529fc3a-766e-4d6c-899a-c35a8fdaa940/syz_repro

syzkaller0: entered promiscuous mode
syzkaller0: entered allmulticast mode
------------[ cut here ]------------
WARNING: CPU: 0 PID: 5965 at net/core/skbuff.c:1192 __sk_skb_reason_drop net/core/skbuff.c:1189 [inline]
WARNING: CPU: 0 PID: 5965 at net/core/skbuff.c:1192 sk_skb_reason_drop+0x76/0x170 net/core/skbuff.c:1214
Modules linked in:
CPU: 0 UID: 0 PID: 5965 Comm: syz.0.17 Not tainted syzkaller #0 PREEMPT(full) 
Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS 1.16.2-debian-1.16.2-1 04/01/2014
RIP: 0010:__sk_skb_reason_drop net/core/skbuff.c:1189 [inline]
RIP: 0010:sk_skb_reason_drop+0x76/0x170 net/core/skbuff.c:1214
Code: 20 2e a0 f8 83 fd 01 75 26 41 8d ae 00 00 fd ff bf 01 00 fd ff 89 ee e8 08 2e a0 f8 81 fd 00 00 fd ff 77 32 e8 bb 29 a0 f8 90 <0f> 0b 90 eb 53 bf 01 00 00 00 89 ee e8 e9 2d a0 f8 85 ed 0f 8e b2
RSP: 0018:ffffc9000284f3b0 EFLAGS: 00010293
RAX: ffffffff891fdcd5 RBX: ffff888113587680 RCX: ffff88816e6f3a00
RDX: 0000000000000000 RSI: 000000006e1a2a10 RDI: 00000000fffd0001
RBP: 000000006e1a2a10 R08: ffff888113587767 R09: 1ffff110226b0eec
R10: dffffc0000000000 R11: ffffed10226b0eed R12: ffff888113587764
R13: dffffc0000000000 R14: 000000006e1d2a10 R15: 0000000000000000
FS:  000055558e11c500(0000) GS:ffff88818eb38000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 0000200000002280 CR3: 000000011053c000 CR4: 00000000000006f0
Call Trace:
 <TASK>
 kfree_skb_reason include/linux/skbuff.h:1322 [inline]
 tcf_kfree_skb_list include/net/sch_generic.h:1127 [inline]
 __dev_xmit_skb net/core/dev.c:4258 [inline]
 __dev_queue_xmit+0x2669/0x3180 net/core/dev.c:4783
 packet_snd net/packet/af_packet.c:3076 [inline]
 packet_sendmsg+0x3e33/0x5080 net/packet/af_packet.c:3108
 sock_sendmsg_nosec net/socket.c:727 [inline]
 __sock_sendmsg+0x21c/0x270 net/socket.c:742
 ____sys_sendmsg+0x505/0x830 net/socket.c:2630
 ___sys_sendmsg+0x21f/0x2a0 net/socket.c:2684
 __sys_sendmsg net/socket.c:2716 [inline]
 __do_sys_sendmsg net/socket.c:2721 [inline]
 __se_sys_sendmsg net/socket.c:2719 [inline]
 __x64_sys_sendmsg+0x19b/0x260 net/socket.c:2719
 do_syscall_x64 arch/x86/entry/syscall_64.c:63 [inline]
 do_syscall_64+0xfa/0xfa0 arch/x86/entry/syscall_64.c:94
 entry_SYSCALL_64_after_hwframe+0x77/0x7f
RIP: 0033:0x7fc1a7b8efc9
Code: ff ff c3 66 2e 0f 1f 84 00 00 00 00 00 0f 1f 40 00 48 89 f8 48 89 f7 48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 ff ff 73 01 c3 48 c7 c1 a8 ff ff ff f7 d8 64 89 01 48
RSP: 002b:00007fff4ba6d968 EFLAGS: 00000246 ORIG_RAX: 000000000000002e
RAX: ffffffffffffffda RBX: 00007fc1a7de5fa0 RCX: 00007fc1a7b8efc9
RDX: 0000000000000004 RSI: 00002000000000c0 RDI: 0000000000000007
RBP: 00007fc1a7c11f91 R08: 0000000000000000 R09: 0000000000000000
R10: 0000000000000000 R11: 0000000000000246 R12: 0000000000000000
R13: 00007fc1a7de5fa0 R14: 00007fc1a7de5fa0 R15: 0000000000000003
 </TASK>


***

If these findings have caused you to resend the series or submit a
separate fix, please add the following tag to your commit message:
  Tested-by: syzbot@syzkaller.appspotmail.com

---
This report is generated by a bot. It may contain errors.
syzbot ci engineers can be reached at syzkaller@googlegroups.com.
