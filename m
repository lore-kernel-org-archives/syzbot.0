Received: from mail-il1-f199.google.com (mail-il1-f199.google.com [209.85.166.199])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 58AA11A9B58
	for <syzbot@lists.linux.dev>; Wed, 15 Oct 2025 17:45:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.199
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760550347; cv=none; b=tKRcmIjRyDx4jmr54OyB+PrN3/tCotGdfhAS6T+m2O5X1kRDrxWCo2mmysIiFmpIKTQCC5wid79bLpCfHGehG7UXkyBnZXoYK3OQ0BTSeHBgGOelsOrSisiz1w9OLCkJ3b7D90BsocFKcyDZux0vZypRSUK80DGrIXpvn4yBNrY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760550347; c=relaxed/simple;
	bh=u8Eep/GibVkKIJLiCLUw+iujO/DcZJ6TID5DyRb8/sk=;
	h=MIME-Version:Date:Message-ID:Subject:From:To:Cc:Content-Type; b=ITHTUjhOiu24YjPuYHxXIKEQpAxKwuPFVh/Ev5dtzbvCD45Wh5X6NxRNnx7+5mToQutoZyvUh+35gb/XNyfN0Ql1dI8D/cAlSQkvGr0MMmsfBoOtNYN/gn6lNARPlizjcPdHXsXWrfS58gQYsnGY+ZFPi8bFo218wYH5bn3zXhA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com; arc=none smtp.client-ip=209.85.166.199
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com
Received: by mail-il1-f199.google.com with SMTP id e9e14a558f8ab-42f8824b65fso348777795ab.2
        for <syzbot@lists.linux.dev>; Wed, 15 Oct 2025 10:45:45 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1760550344; x=1761155144;
        h=content-transfer-encoding:cc:to:from:subject:message-id:date
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=cy6zGXb6REEKMEYytoSzgjoWac1qQc1srBHdqQcibsE=;
        b=AvYf58tahCjp1FR+sx6xAP0q0AYNBXpE5x+n1yLP5wuOn0zoMaDAw9y78Zned8tKPy
         bbj0KRnW6oFGShZi0is52yct8J4SvtjXmvDs3oue1UrV9kQzGmoQUcUvjbnFwovvU5Zr
         SARJeOJnVXsCCY4qklq23tDt5wa/H+BKILYravs+znsS5ss7gvFMQuCCLHnPiId7ThUv
         CT0EV9mtTJUTWALG09G2y9pKnRpy9H1EUUM7MZ+tmaCOGTLZlyLK6YvwJ84Jx3yhyHps
         MQsnWLOFoz6PGPc2cxNUicC0rXfprgNL8JPFoAb0j0ST7FGuBktGmIrGk4Lg+L+nbe/4
         bv2Q==
X-Gm-Message-State: AOJu0YwMIpam8PkaaoBdnZ1YeD4JHzFm6Uw978YVnHWE3AawNKC2EDiV
	QdBNWBGFloHrWarpuyil0VOuKqtnjcWVyOQeBAjGbuijFnyHnRk8I6mOUw+qQHaU+PRImKS11Cr
	dPKY5uhPM09jyNeo1jlWnIqTTl9UfcZCxk+oMMWUIBZsTEfu2PKaGc5ENNxc=
X-Google-Smtp-Source: AGHT+IFCMo6+rkzqFXHqYCsak1MfSxE57x3aU7pUprxZa8Xxpz2IxZGr/Ngp4R4iIFYMeNo+vk9KdhsHBpxS/VgnoDhPoVDEd4KL
Precedence: bulk
X-Mailing-List: syzbot@lists.linux.dev
List-Id: <syzbot.lists.linux.dev>
List-Subscribe: <mailto:syzbot+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:syzbot+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Received: by 2002:a05:6e02:1aa2:b0:430:ab98:7b27 with SMTP id
 e9e14a558f8ab-430ab987e0amr51484595ab.20.1760550344458; Wed, 15 Oct 2025
 10:45:44 -0700 (PDT)
Date: Wed, 15 Oct 2025 10:45:44 -0700
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <68efddc8.050a0220.1186a4.00e8.GAE@google.com>
Subject: [moderation/CI] Re: netkit: Support for io_uring zero-copy and AF_XDP
From: syzbot ci <syzbot+ci9295004d7677133b@syzkaller.appspotmail.com>
To: syzkaller-upstream-moderation@googlegroups.com
Cc: syzbot@lists.linux.dev
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

syzbot ci has tested the following series

[v2] netkit: Support for io_uring zero-copy and AF_XDP
https://lore.kernel.org/all/20251015140140.62273-1-daniel@iogearbox.net
* [PATCH net-next v2 01/15] net: Add bind-queue operation
* [PATCH net-next v2 02/15] net: Implement netdev_nl_bind_queue_doit
* [PATCH net-next v2 03/15] net: Add peer info to queue-get response
* [PATCH net-next v2 04/15] net, ethtool: Disallow peered real rxqs to be r=
esized
* [PATCH net-next v2 05/15] net: Proxy net_mp_{open,close}_rxq for mapped q=
ueues
* [PATCH net-next v2 06/15] xsk: Move NETDEV_XDP_ACT_ZC into generic header
* [PATCH net-next v2 07/15] xsk: Move pool registration into single functio=
n
* [PATCH net-next v2 08/15] xsk: Add small helper xp_pool_bindable
* [PATCH net-next v2 09/15] xsk: Change xsk_rcv_check to check netdev/queue=
_id from pool
* [PATCH net-next v2 10/15] xsk: Proxy pool management for mapped queues
* [PATCH net-next v2 11/15] netkit: Add single device mode for netkit
* [PATCH net-next v2 12/15] netkit: Document fast vs slowpath members via m=
acros
* [PATCH net-next v2 13/15] netkit: Implement rtnl_link_ops->alloc and ndo_=
queue_create
* [PATCH net-next v2 14/15] netkit: Add io_uring zero-copy support for TCP
* [PATCH net-next v2 15/15] netkit: Add xsk support for af_xdp applications

and found the following issue:
WARNING in netif_get_rx_queue_peer_locked

Full report is available here:
https://ci.syzbot.org/series/19b5990a-1eef-44da-a6f0-ffb03bd8adff

***

WARNING in netif_get_rx_queue_peer_locked

tree:      net-next
URL:       https://kernel.googlesource.com/pub/scm/linux/kernel/git/netdev/=
net-next.git
base:      18a7e218cfcdca6666e1f7356533e4c988780b57
arch:      amd64
compiler:  Debian clang version 20.1.8 (++20250708063551+0c9f909b7976-1~exp=
1~20250708183702.136), Debian LLD 20.1.8
config:    https://ci.syzbot.org/builds/7583f7f3-9e92-4fe2-85f2-76165506285=
2/config
C repro:   https://ci.syzbot.org/findings/75520448-5da8-4fc1-817b-a6c9e4d48=
7e1/c_repro
syz repro: https://ci.syzbot.org/findings/75520448-5da8-4fc1-817b-a6c9e4d48=
7e1/syz_repro

UDPLite6: UDP-Lite is deprecated and scheduled to be removed in 2025, pleas=
e contact the netdev mailing list
------------[ cut here ]------------
WARNING: CPU: 1 PID: 5959 at ./include/net/netdev_lock.h:17 netdev_assert_l=
ocked include/net/netdev_lock.h:17 [inline]
WARNING: CPU: 1 PID: 5959 at ./include/net/netdev_lock.h:17 netif_get_rx_qu=
eue_peer_locked+0x2f1/0x3a0 net/core/netdev_rx_queue.c:71
Modules linked in:
CPU: 1 UID: 0 PID: 5959 Comm: syz.0.17 Not tainted syzkaller #0 PREEMPT(ful=
l)=20
Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS 1.16.2-debian-1.16=
.2-1 04/01/2014
RIP: 0010:netdev_assert_locked include/net/netdev_lock.h:17 [inline]
RIP: 0010:netif_get_rx_queue_peer_locked+0x2f1/0x3a0 net/core/netdev_rx_que=
ue.c:71
Code: 6c 7e f8 eb 08 e8 3f 6c 7e f8 45 31 f6 4c 89 f0 48 83 c4 38 5b 41 5c =
41 5d 41 5e 41 5f 5d e9 c6 1c 0d 02 cc e8 20 6c 7e f8 90 <0f> 0b 90 e9 a9 f=
d ff ff 48 c7 c1 90 44 9e 8f 80 e1 07 80 c1 03 38
RSP: 0018:ffffc90003f17ab0 EFLAGS: 00010293
RAX: ffffffff894127e0 RBX: ffffc90003f17b60 RCX: ffff8881709cba00
RDX: 0000000000000000 RSI: 0000000000000000 RDI: 0000000000000000
RBP: 0000000000000000 R08: ffffffff8f4df8a7 R09: 1ffffffff1e9bf14
R10: dffffc0000000000 R11: fffffbfff1e9bf15 R12: dffffc0000000000
R13: 0000000000000001 R14: 1ffff920007e2f6c R15: ffff8881b1832000
FS:  0000555580884500(0000) GS:ffff8882a9d0f000(0000) knlGS:000000000000000=
0
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 0000555580884808 CR3: 00000001ba58c000 CR4: 00000000000006f0
Call Trace:
 <TASK>
 xsk_reg_pool_at_qid+0x20b/0x630 net/xdp/xsk.c:159
 xp_assign_dev+0x115/0x760 net/xdp/xsk_buff_pool.c:181
 xsk_bind+0x473/0xf90 net/xdp/xsk.c:1407
 __sys_bind_socket net/socket.c:1874 [inline]
 __sys_bind+0x2c6/0x3e0 net/socket.c:1905
 __do_sys_bind net/socket.c:1910 [inline]
 __se_sys_bind net/socket.c:1908 [inline]
 __x64_sys_bind+0x7a/0x90 net/socket.c:1908
 do_syscall_x64 arch/x86/entry/syscall_64.c:63 [inline]
 do_syscall_64+0xfa/0xfa0 arch/x86/entry/syscall_64.c:94
 entry_SYSCALL_64_after_hwframe+0x77/0x7f
RIP: 0033:0x7fb19bd8eec9
Code: ff ff c3 66 2e 0f 1f 84 00 00 00 00 00 0f 1f 40 00 48 89 f8 48 89 f7 =
48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 ff f=
f 73 01 c3 48 c7 c1 a8 ff ff ff f7 d8 64 89 01 48
RSP: 002b:00007ffd789e00a8 EFLAGS: 00000246 ORIG_RAX: 0000000000000031
RAX: ffffffffffffffda RBX: 00007fb19bfe5fa0 RCX: 00007fb19bd8eec9
RDX: 0000000000000010 RSI: 0000200000000180 RDI: 0000000000000003
RBP: 00007fb19be11f91 R08: 0000000000000000 R09: 0000000000000000
R10: 0000000000000000 R11: 0000000000000246 R12: 0000000000000000
R13: 00007fb19bfe5fa0 R14: 00007fb19bfe5fa0 R15: 0000000000000003
 </TASK>


***

If these findings have caused you to resend the series or submit a
separate fix, please add the following tag to your commit message:
  Tested-by: syzbot@syzkaller.appspotmail.com

---
This report is generated by a bot. It may contain errors.
syzbot ci engineers can be reached at syzkaller@googlegroups.com.

The email will later be sent to:
[bpf@vger.kernel.org daniel@iogearbox.net davem@davemloft.net dw@davidwei.u=
k john.fastabend@gmail.com jordan@jrife.io kuba@kernel.org maciej.fijalkows=
ki@intel.com magnus.karlsson@intel.com martin.lau@kernel.org netdev@vger.ke=
rnel.org pabeni@redhat.com razor@blackwall.org sdf@fomichev.me toke@redhat.=
com wangdongdong.6@bytedance.com willemb@google.com yangzhenze@bytedance.co=
m]

If the report looks fine to you, reply with:
#syz upstream

