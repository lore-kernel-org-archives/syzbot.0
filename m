Received: from mail-oo1-f72.google.com (mail-oo1-f72.google.com [209.85.161.72])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A6E582D948D
	for <syzbot@lists.linux.dev>; Tue, 10 Mar 2026 14:44:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.161.72
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773153876; cv=none; b=h48m+G6bT+b13FebvyI5wD5JE/aB36NDuGAyotPmSK2v5ckhKoyVreMi84dMAWk6rp5kjqbrRi8ovvmA+weRIBfWlTTSldUjo7wqC+sPNobSGwYNrGwUI9NwjL8NKX62gDsxsap3sSTBq5BJs6SH7ZNXvZmCGEWFD3RLXWBsFOM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773153876; c=relaxed/simple;
	bh=TM3ncN0Mqkb2uSMpkf6rwhNUNM5CtFbQGhfERHb93BA=;
	h=MIME-Version:Date:Message-ID:Subject:From:To:Cc:Content-Type; b=muNhC0f/yoBFi1cGChiGsaOILSkT9ilJ0/J3jvDa2AT+3mCPCGXdt3M3V6fMXGCNUGyqKVZluh6TR/KSy4OrLJ8Cvru7Dn1bvOG1SIHMvHHZF2tXMpbWQu7Y87Y4rUA1q9kWkIaIurYj+vpVJYdwqQp7IPt4V+1zD/ScC9KNDJw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com; arc=none smtp.client-ip=209.85.161.72
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com
Received: by mail-oo1-f72.google.com with SMTP id 006d021491bc7-67bb47e6846so29921066eaf.0
        for <syzbot@lists.linux.dev>; Tue, 10 Mar 2026 07:44:34 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1773153873; x=1773758673;
        h=content-transfer-encoding:cc:to:from:subject:message-id:date
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=/Lf7WU5IvlEQla2pRbSe/Xegwv57Atq2poxuemfGjmE=;
        b=XMQSQcMcrKe7izsRxpgCB3YQ8RNhcXBNh8ZUvdws6inw/m1Lp0fN75dfwHwj/c9sIN
         W4k9C7kq+8wwMRIZgo32ZJd1EldLTYMonfJ2It+eQ5MZYb++F+e6zTunX0AvIMb+ocw5
         TA80ktZxfeP8/4MSqradLgroZw9AaZrknAg/mBWatiZAI48O6usKriqI23DVCewGhlfE
         BeqcYjIkvaxThZe0Tpp0hESz2mpKve7K2kBZlEJqDMkoDE6KfFecU8zZ3nx7Z1lcoC8X
         TSrK30xVxj44wPuoOG5pr1uG+StzYEu+ep7Z+IZ3ru5+mDWFVFvbdPxlusXb6kSYPGgS
         wXXQ==
X-Gm-Message-State: AOJu0YxH8V/d9GWMygTxdI/bSEM9Lkozd5X9Ivhdm6rA94BMbgXuejHL
	/2VSpArzLuYXMMViuSiEw2adRo0/Hjy/hy4hMRBZzwz8dKf7yqQxrFuV9IqXdryOBBNEFTn/6uB
	AgYV9/xM+MjU1r8t9c41DdYVPKM2yi50EjN2/mz0HHPsgiJYB9FnGmm176ng=
Precedence: bulk
X-Mailing-List: syzbot@lists.linux.dev
List-Id: <syzbot.lists.linux.dev>
List-Subscribe: <mailto:syzbot+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:syzbot+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Received: by 2002:a05:6820:1c88:b0:67b:b1a2:b4d3 with SMTP id
 006d021491bc7-67bb1a2b710mr5198184eaf.72.1773153873667; Tue, 10 Mar 2026
 07:44:33 -0700 (PDT)
Date: Tue, 10 Mar 2026 07:44:33 -0700
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <69b02e51.050a0220.23b02c.0039.GAE@google.com>
Subject: [moderation/CI] Re: net: move netdev_compute_master_upper_features to ndo_set_features
From: syzbot ci <syzbot+cia977a1d1cb7ea767@syzkaller.appspotmail.com>
To: syzkaller-upstream-moderation@googlegroups.com
Cc: syzbot@lists.linux.dev
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

syzbot ci has tested the following series

[v1] net: move netdev_compute_master_upper_features to ndo_set_features
https://lore.kernel.org/all/20260310-offload_compute-v1-0-3df79c09ea65@gmai=
l.com
* [PATCH net-next 1/3] net: use ndo_set_features to set offload features fo=
r bonding/bridge/team
* [PATCH net-next 2/3] failover: use ndo_set_features for failover offload =
compute
* [PATCH net-next 3/3] net: no need to disable LRO specifically

and found the following issue:
WARNING in rtmsg_ifinfo_build_skb

Full report is available here:
https://ci.syzbot.org/series/d5001c4a-a51e-49c1-9106-624836e43ec2

***

WARNING in rtmsg_ifinfo_build_skb

tree:      net-next
URL:       https://kernel.googlesource.com/pub/scm/linux/kernel/git/netdev/=
net-next.git
base:      52ede1bce557c66309f41ac29dd190be23ca9129
arch:      amd64
compiler:  Debian clang version 21.1.8 (++20251221033036+2078da43e25a-1~exp=
1~20251221153213.50), Debian LLD 21.1.8
config:    https://ci.syzbot.org/builds/281e7e02-f6af-4b4a-845e-d1d5842a930=
1/config

batman_adv: batadv0: Not using interface batadv_slave_1 (retrying later): i=
nterface not active
hsr_slave_0: entered promiscuous mode
hsr_slave_1: entered promiscuous mode
------------[ cut here ]------------
err =3D=3D -EMSGSIZE
WARNING: net/core/rtnetlink.c:4421 at rtmsg_ifinfo_build_skb+0x218/0x260, C=
PU#0: syz-executor/6496
Modules linked in:
CPU: 0 UID: 0 PID: 6496 Comm: syz-executor Not tainted syzkaller #0 PREEMPT=
(full)=20
Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS 1.16.2-debian-1.16=
.2-1 04/01/2014
RIP: 0010:rtmsg_ifinfo_build_skb+0x218/0x260
Code: f6 ba 01 00 00 00 89 e9 e8 25 15 3a 00 4c 89 f0 48 83 c4 30 5b 41 5c =
41 5d 41 5e 41 5f 5d e9 7f 3a 2e 02 cc e8 49 3b 42 f8 90 <0f> 0b 90 eb 90 8=
9 d9 80 e1 07 fe c1 38 c1 0f 8c 95 fe ff ff 48 89
RSP: 0018:ffffc9000637e9a0 EFLAGS: 00010293
RAX: ffffffff89835e27 RBX: 0000000000000000 RCX: ffff8881b80a57c0
RDX: 0000000000000000 RSI: 00000000ffffffa6 RDI: 00000000ffffffa6
RBP: 00000000ffffffa6 R08: 0000000000000004 R09: 0000000000000004
R10: fffff52000c6fcdc R11: 0000000000000000 R12: 1ffff110235ddc21
R13: 0000000000000000 R14: ffff8881133dc780 R15: ffff88811aeee000
FS:  0000555557c4a500(0000) GS:ffff88818de65000(0000) knlGS:000000000000000=
0
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 000055555e1838c8 CR3: 0000000168b80000 CR4: 00000000000006f0
Call Trace:
 <TASK>
 rtnetlink_event+0x1b7/0x270
 notifier_call_chain+0x1be/0x400
 netdev_change_features+0x95/0xe0
 __netdev_upper_dev_link+0xb20/0xc80
 netdev_upper_dev_link+0xb0/0x100
 macsec_newlink+0xb11/0x1200
 rtnl_newlink_create+0x329/0xb70
 rtnl_newlink+0x1666/0x1be0
 rtnetlink_rcv_msg+0x7d5/0xbe0
 netlink_rcv_skb+0x232/0x4b0
 netlink_unicast+0x80f/0x9b0
 netlink_sendmsg+0x813/0xb40
 __sys_sendto+0x672/0x710
 __x64_sys_sendto+0xde/0x100
 do_syscall_64+0x14d/0xf80
 entry_SYSCALL_64_after_hwframe+0x77/0x7f
RIP: 0033:0x7ffadf757917
Code: 48 89 fa 4c 89 df e8 a8 56 00 00 8b 93 08 03 00 00 59 5e 48 83 f8 fc =
74 1a 5b c3 0f 1f 84 00 00 00 00 00 48 8b 44 24 10 0f 05 <5b> c3 0f 1f 80 0=
0 00 00 00 83 e2 39 83 fa 08 75 de e8 23 ff ff ff
RSP: 002b:00007ffd0eb79f80 EFLAGS: 00000202 ORIG_RAX: 000000000000002c
RAX: ffffffffffffffda RBX: 0000555557c4a500 RCX: 00007ffadf757917
RDX: 0000000000000054 RSI: 00007ffae0544670 RDI: 0000000000000003
RBP: 0000000000000001 R08: 00007ffd0eb79fe4 R09: 000000000000000c
R10: 0000000000000000 R11: 0000000000000202 R12: 0000000000000003
R13: 0000000000000000 R14: 00007ffae0544670 R15: 0000000000000000
 </TASK>


***

If these findings have caused you to resend the series or submit a
separate fix, please add the following tag to your commit message:
  Tested-by: syzbot@syzkaller.appspotmail.com

---
This report is generated by a bot. It may contain errors.
syzbot ci engineers can be reached at syzkaller@googlegroups.com.

The email will later be sent to:
[andrew@lunn.ch bridge@lists.linux.dev davem@davemloft.net edumazet@google.=
com horms@kernel.org idosch@nvidia.com jiri@resnulli.us jv@jvosburgh.net ku=
ba@kernel.org linux-kernel@vger.kernel.org liuhangbin@gmail.com netdev@vger=
.kernel.org pabeni@redhat.com razor@blackwall.org sridhar.samudrala@intel.c=
om]

If the report looks fine to you, reply with:
#syz upstream

If the report is a false positive, reply with
#syz invalid

