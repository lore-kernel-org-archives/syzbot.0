Received: from mail-io1-f70.google.com (mail-io1-f70.google.com [209.85.166.70])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 35B142820DC
	for <syzbot@lists.linux.dev>; Wed, 23 Jul 2025 09:09:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.70
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1753261777; cv=none; b=qLo5BWQIoTCneEf8oCGYJJo0jHwo4KwVIKW45Y4AFj5lXxJuL4Wt9VuVQllJG8aFMDq5C1f0OKy9JvrvDL7JTc5PnXF9VdNKvBDbM8potIF/6UxL3o1fgNBH2fGUAIfEc4nYaQey5xN1CuPK+u/pHdNHeAF/7tV5D0Eiff+H8OQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1753261777; c=relaxed/simple;
	bh=/yGUGKAhGBPBrwTTEOjI9B+HkXKztIO+0eBa5uesc3s=;
	h=MIME-Version:Date:In-Reply-To:Message-ID:Subject:From:To:Cc:
	 Content-Type; b=E2KFoxTxD/CNfwMq3sSSGBvtVLhTQUlU9ivYOWJDc3IubWECfjQmHAbZD13vvHG110F3SjL5FIZ5iFohuFj9IJ6SYTKXassWpoNFLcs5b+M8OcAO6/nX6CgqxNTa4BZeNU8LksqcCKdTHQ8A3JP9oq9HhRVwiZy501ygUeJp4hM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com; arc=none smtp.client-ip=209.85.166.70
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com
Received: by mail-io1-f70.google.com with SMTP id ca18e2360f4ac-86d1218df67so650231839f.1
        for <syzbot@lists.linux.dev>; Wed, 23 Jul 2025 02:09:35 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1753261775; x=1753866575;
        h=cc:to:from:subject:message-id:in-reply-to:date:mime-version
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=TvFG3sQTKMwo29OtOJz9i/cr+68WnmlBBDZAn9btd1A=;
        b=xVX7dO9AVgvFIaaoI2IllJc7YssjCoCa6ldw98mJ9BR7kcF4lqV/KtpJ/bGfdyz/G8
         nZ7db0hZE0tLUxuj7NGoI6tmhFRo+G4XyZL2Uv7BdV4TmLTWwRFlXABT50LNNBtk/G1V
         SxxGu0Z7NBtzjfcD1gbLG7hIFtQ5sJY1n5QnALcTt+V5HTAPqTGH1Gp6tcsVYXwy1Ax9
         MErCMVpg3G+7SLimhJjJpH9qfNvs2c/NIDCOiiwW4mxwW5eFolFcVbgBFrFyRkVk49z4
         YP7P7baLStjfJwGyK+RB0x9n2gueOi91CNh/tVvHyJn4GJDN7NWjhCqTpBeShfBmVrHu
         qYRw==
X-Gm-Message-State: AOJu0YyWuWKB//+lS5G6fr+0MBdJnk0qCqHu4EJOgve5Fq/umMTYBg/M
	f+Fn5XlWc20NE59Qwakx/rxaC3cCqAyBABPyRq07V7QvwqWEsrpM7HkAhrL70DEhEW53huWFMNL
	nZO0VPtO6a9azm26xo1CGfBtyKJKkMrTzxtbu75lm7HW3WB3RvK95tBY2wYk=
X-Google-Smtp-Source: AGHT+IFAeZxnWZN6oyV6j+V0s/nOmFK6pRexyplCpc2+fX0UQLepZSpXUWTIKp0c4WkSDYL6cj51kYBhiyyzzpLl/WkoydOWc6oG
Precedence: bulk
X-Mailing-List: syzbot@lists.linux.dev
List-Id: <syzbot.lists.linux.dev>
List-Subscribe: <mailto:syzbot+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:syzbot+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Received: by 2002:a05:6602:3a0d:b0:875:ba1e:4d7e with SMTP id
 ca18e2360f4ac-87c64fbb367mr491673439f.6.1753261775276; Wed, 23 Jul 2025
 02:09:35 -0700 (PDT)
Date: Wed, 23 Jul 2025 02:09:35 -0700
In-Reply-To: <20250722210256.143208-1-sdf@fomichev.me>
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <6880a6cf.050a0220.40ccf.0000.GAE@google.com>
Subject: [syzbot ci] Re: vrf: Drop existing dst reference in vrf_ip6_input_dst
From: syzbot ci <syzbot+ci7bed65dd2de1adbd@syzkaller.appspotmail.com>
To: andrew@lunn.ch, davem@davemloft.net, dsahern@kernel.org, 
	edumazet@google.com, horms@kernel.org, kuba@kernel.org, 
	linux-kernel@vger.kernel.org, netdev@vger.kernel.org, pabeni@redhat.com, 
	sdf@fomichev.me
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
