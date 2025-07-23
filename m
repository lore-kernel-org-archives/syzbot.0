Received: from mail-il1-f197.google.com (mail-il1-f197.google.com [209.85.166.197])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5857678F26
	for <syzbot@lists.linux.dev>; Wed, 23 Jul 2025 00:55:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.197
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1753232151; cv=none; b=YrfVhrCLOPQoYjmpR+khoPQ71TiNhgi0PgYXSJjnw6d+6S8/4e11zNT7tfAoRKM4+UCcnxpJBfSkZNJPHDsa7jth5bWKuTXbFhkltj1cvopZpd9bY9c6TSnDdybhaWTkLerdcoMNybib8Ma+/b0jHmpnkzIAvwtAuv94IYsBwLE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1753232151; c=relaxed/simple;
	bh=6/T3mlRsnrqBkvvcn9GtIWIsDkczwR4PRqU2Hha5zoI=;
	h=MIME-Version:Date:Message-ID:Subject:From:To:Cc:Content-Type; b=j//eo1B4vRvCYiZityRWg+V0/uHtspcAJ1aF8SIBFqbFRzS8OtZXDa4lDp1X0T4d4HDtdC5R5DVDyhkffwFlKK9sT4myWXT4A8M635zIIigDTIvQYG6jG24xWtoq5dRKQC/AANsgNI574LJQPIktmt0WQi5jRfOv5zDRlY9OvYU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com; arc=none smtp.client-ip=209.85.166.197
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com
Received: by mail-il1-f197.google.com with SMTP id e9e14a558f8ab-3e29b48527eso83835525ab.1
        for <syzbot@lists.linux.dev>; Tue, 22 Jul 2025 17:55:49 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1753232148; x=1753836948;
        h=cc:to:from:subject:message-id:date:mime-version:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=eQ49n2ax96BPo1xc04Pxh5eq8ZP4zmwLrbcWd3JQr0w=;
        b=HN5/Ta2sKoyUJucg5ao/wObb4tBGYK2lmi3F5XBZ+M7TUYdURk7p0PSdxEIhxoXrYV
         5m7DPxvoNHEiYtognX2WmANNJAZeOP+ClDJpAf1TztPeFXdJKQ/X37mZoNa6Ds+5CaM4
         gd6LagdYkwTW2mYqcL4/syKbUbmoxV/0lrr9cs34nD1SIDmX1+owvrsveKPgHY2thynL
         SxjWcouLU/DwQ8lTWKuJ5mWebhz3eJ1RJzj2I4yXT+ue7c7zCdmYkGNJyyAvhn03NiCI
         MvjyANv3Dt49QL/5ndjTiqY8bfNqDkU0kgDydTCSr30tSxJp4Zr9dncmsrx2BzwyNHjo
         dHqA==
X-Gm-Message-State: AOJu0YxCDdbMA3kHewK8WVXV4pfbd29TAFfUT5Nc9ty5KlfwgAo0Ra31
	5ydIQHPBDI6K/XJUq+uKIE6ZAisdsQSrp2WUtxAt0dP3B3MU0bGJEhtrxKExgPRGXcyVZS5G2/u
	DVf4fV+Qc/oQdXtosiGX4QELJTt0IO+8QP2LDjZ9jQrmt3Akv9bsVQaqI3aQ=
X-Google-Smtp-Source: AGHT+IFaxcp26/RtJI5O8diw1LnP+CAKKdncyvM7tTjH7DE93PPcvyXTk5RcwLU9plEOFeHXLkTo3VRNzjbD9YopXQjEFd/IoUnr
Precedence: bulk
X-Mailing-List: syzbot@lists.linux.dev
List-Id: <syzbot.lists.linux.dev>
List-Subscribe: <mailto:syzbot+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:syzbot+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Received: by 2002:a05:6e02:18cd:b0:3e2:c5de:5f8 with SMTP id
 e9e14a558f8ab-3e330374e61mr20466375ab.9.1753232148429; Tue, 22 Jul 2025
 17:55:48 -0700 (PDT)
Date: Tue, 22 Jul 2025 17:55:48 -0700
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <68803314.a70a0220.693ce.010e.GAE@google.com>
Subject: [moderation/CI] Re: vrf: Drop existing dst reference in vrf_ip6_input_dst
From: syzbot ci <syzbot+ci1ec3e0769f39071b@syzkaller.appspotmail.com>
To: syzkaller-upstream-moderation@googlegroups.com
Cc: syzbot@lists.linux.dev
Content-Type: text/plain; charset="UTF-8"

syzbot ci has tested the following series

[v1] vrf: Drop existing dst reference in vrf_ip6_input_dst
https://lore.kernel.org/all/<20250722210256.143208-1-sdf@fomichev.me>
* [PATCH net 1/2] vrf: Drop existing dst reference in vrf_ip6_input_dst
* [PATCH net 2/2] net: Warn when overriding referenced dst entry

and found the following issue:
WARNING in nf_reject_fill_skb_dst

Full report is available here:
https://ci.syzbot.org/series/c92e1af5-3b8b-4c26-8104-acca93ad8939

***

WARNING in nf_reject_fill_skb_dst

tree:      net
URL:       https://kernel.googlesource.com/pub/scm/linux/kernel/git/netdev/net.git
base:      cf074eca0065bc5142e6004ae236bb35a2687fdf
arch:      amd64
compiler:  Debian clang version 20.1.7 (++20250616065708+6146a88f6049-1~exp1~20250616065826.132), Debian LLD 20.1.7
config:    https://ci.syzbot.org/builds/235c4af3-77ea-4670-9c9e-9de1ef0a5aa6/config
syz repro: https://ci.syzbot.org/findings/1038832f-72d8-4491-9ac9-28339d31f0f7/syz_repro

------------[ cut here ]------------
WARNING: CPU: 1 PID: 12 at ./include/linux/skbuff.h:1165 nf_reject_fill_skb_dst+0x313/0x3b0
Modules linked in:
CPU: 1 UID: 0 PID: 12 Comm: kworker/u8:0 Not tainted 6.16.0-rc6-syzkaller-00135-gcf074eca0065-dirty #0 PREEMPT(full) 
Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS 1.16.2-debian-1.16.2-1 04/01/2014
Workqueue: ipv6_addrconf addrconf_dad_work
RIP: 0010:nf_reject_fill_skb_dst+0x313/0x3b0
Code: 8b 0d f1 35 98 08 48 3b 8c 24 e0 00 00 00 75 6b 48 8d 65 d8 5b 41 5c 41 5d 41 5e 41 5f 5d e9 54 19 69 01 cc e8 9e 7e b8 f7 90 <0f> 0b 90 e9 43 ff ff ff e8 90 7e b8 f7 90 0f 0b 90 e9 e3 fe ff ff
RSP: 0018:ffffc900001e0360 EFLAGS: 00010246
RAX: ffffffff8a07aa52 RBX: ffff888110f75500 RCX: ffff88801c2f5640
RDX: 0000000000000100 RSI: 0000000000000000 RDI: 0000000000000000
RBP: ffffc900001e0490 R08: ffffffff8fa1d6f7 R09: 1ffffffff1f43ade
R10: dffffc0000000000 R11: fffffbfff1f43adf R12: ffff888110f75501
R13: dffffc0000000001 R14: 1ffff9200003c070 R15: 0000000000000000
FS:  0000000000000000(0000) GS:ffff8881a3c22000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 00002000000000c0 CR3: 000000001ff6e000 CR4: 00000000000006f0
Call Trace:
 <IRQ>
 nf_send_unreach+0x17b/0x700
 nft_reject_inet_eval+0x4bc/0x690
 nft_do_chain+0x40c/0x1920
 nft_do_chain_inet+0x25d/0x340
 nf_hook_slow+0xc5/0x220
 NF_HOOK+0x206/0x3a0
 __netif_receive_skb+0x143/0x380
 process_backlog+0x60e/0x14f0
 __napi_poll+0xc7/0x480
 net_rx_action+0x707/0xe30
 handle_softirqs+0x286/0x870
 do_softirq+0xec/0x180
 </IRQ>
 <TASK>
 __local_bh_enable_ip+0x17d/0x1c0
 __dev_queue_xmit+0x1cd7/0x3a70
 ip6_finish_output2+0x11fe/0x16a0
 ndisc_send_skb+0xc77/0x1500
 ndisc_send_ns+0xcb/0x150
 addrconf_dad_work+0xaae/0x14b0
 process_scheduled_works+0xae1/0x17b0
 worker_thread+0x8a0/0xda0
 kthread+0x711/0x8a0
 ret_from_fork+0x3fc/0x770
 ret_from_fork_asm+0x1a/0x30
 </TASK>


---
This report is generated by a bot. It may contain errors.
syzbot ci engineers can be reached at syzkaller@googlegroups.com.

The email will later be sent to:
[andrew@lunn.ch davem@davemloft.net dsahern@kernel.org edumazet@google.com horms@kernel.org kuba@kernel.org linux-kernel@vger.kernel.org netdev@vger.kernel.org pabeni@redhat.com sdf@fomichev.me]

If the report looks fine to you, reply with:
#syz upstream

