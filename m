Received: from mail-io1-f71.google.com (mail-io1-f71.google.com [209.85.166.71])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8AAC12A1CA
	for <syzbot@lists.linux.dev>; Thu, 25 Sep 2025 06:22:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.71
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758781373; cv=none; b=GZcJBEGt3KDBwO2Bbm2Xdcz+b2RNVx7el2bxXW+1HAqniJO9euuwinr7WpcZnG2IlXfJW7UCVarIYKCi3Thhk4XpwKqcyIU6/KzrzUwuc2fIpFrtZdtyyeKO83IixrQ2reZ8LgeVKIx3ACDjnNPpwrH73775x6XJ7aBdsSVmnpo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758781373; c=relaxed/simple;
	bh=EIBdkU8impSAtiAzl+0rAtPjTWN5PhD7WBoNy6ilCg0=;
	h=MIME-Version:Date:Message-ID:Subject:From:To:Cc:Content-Type; b=nqWwcXUdfWQXZpWDE0H14MSsz8OJse10kwAY5Ie3GJvPdZoTFF7hdCEyBHTRXSKimkV6/CejcWADj+zFLMSsqsGRh06WIHVIhKhDdSuxVFuXudBLuZdUf+LVnWqM3GxsJ9iMWTcYiDdMtT8HpN97mpNy+Y7u0AkYoF1p/GMRmrg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com; arc=none smtp.client-ip=209.85.166.71
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com
Received: by mail-io1-f71.google.com with SMTP id ca18e2360f4ac-893dd6dfe1fso73949439f.1
        for <syzbot@lists.linux.dev>; Wed, 24 Sep 2025 23:22:51 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1758781370; x=1759386170;
        h=content-transfer-encoding:cc:to:from:subject:message-id:date
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=XH0ppVSJ1yIh3pJkpZJOb0I8zr+ywhDgpwqv8auGfM8=;
        b=ckmwd9ORR5qpz60C0Ztpt6L+Ohn8JYisH3SNXG+4ppvLZVuMJn8R/ZsOJpCCNhqC5I
         WWW4vwF/qfpzMuUtuvp5F4wIEXH55JSz6Xrzx8rizvkTyXNFATdjicrlLEuvsifb3teg
         yVKi8ALeGCoFdm3txjTiVS8SRgBZd5xg9ZjH4dJnTiEBYGDObL88n7QUtJgV2jfEN5Rw
         ZgI8fdOYdH/t24MpDC+8qWTlWKqIXZkjXe8Di9RQIbkoun7BN/8RMGoa06J3JboF1ujz
         wm1X1HwtwyStKCBEEunz7soQ11haornD4DCgIRg/KsB9aQSxQc+W7JxH9dMr+CHozSYT
         b70Q==
X-Gm-Message-State: AOJu0YztIzYJiBZMnIhBj3Y0BQG6op3bkon5+ppxIqWjctS1gBYRvpJx
	3f9uq3/FTXUoHYacW00Mb4v7MHmVjshc0TpX8NggDFVKS2iDBUR7qGsQBTnFK3m8cvBvCkmnX3j
	Dro5o3Nr4UISYrsBwSs6B1jDbS7+mSBPktlcLcuC94HDbaOD7tQWNcwyELec=
X-Google-Smtp-Source: AGHT+IHNpBJGS942/VhaMTq9nYbXNYFufnLdru0+0qruda9VJWRtvL2xz7SKuhHsp6tymTPoSnFY/5X+V/4ccCFM9f0vHa9FxqgM
Precedence: bulk
X-Mailing-List: syzbot@lists.linux.dev
List-Id: <syzbot.lists.linux.dev>
List-Subscribe: <mailto:syzbot+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:syzbot+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Received: by 2002:a05:6602:6d8d:b0:88d:7956:2e04 with SMTP id
 ca18e2360f4ac-9017230d488mr347131439f.19.1758781370549; Wed, 24 Sep 2025
 23:22:50 -0700 (PDT)
Date: Wed, 24 Sep 2025 23:22:50 -0700
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <68d4dfba.050a0220.25d7ab.0001.GAE@google.com>
Subject: [moderation/CI] Re: fixes two virtio-net related bugs.
From: syzbot ci <syzbot+ciaaef565a46ab8569@syzkaller.appspotmail.com>
To: syzkaller-upstream-moderation@googlegroups.com
Cc: syzbot@lists.linux.dev
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

syzbot ci has tested the following series

[v1] fixes two virtio-net related bugs.
https://lore.kernel.org/all/20250925022537.91774-1-xuanzhuo@linux.alibaba.c=
om
* [PATCH net 1/2] virtio-net: fix incorrect flags recording in big mode
* [PATCH net 2/2] virtio-net: correct hdr_len handling for VIRTIO_NET_F_GUE=
ST_HDRLEN

and found the following issue:
WARNING in virtio_net_hdr_from_skb

Full report is available here:
https://ci.syzbot.org/series/41a78b3d-b982-4507-b02f-1991c8d827c9

***

WARNING in virtio_net_hdr_from_skb

tree:      net
URL:       https://kernel.googlesource.com/pub/scm/linux/kernel/git/netdev/=
net.git
base:      f8b4687151021db61841af983f1cb7be6915d4ef
arch:      amd64
compiler:  Debian clang version 20.1.8 (++20250708063551+0c9f909b7976-1~exp=
1~20250708183702.136), Debian LLD 20.1.8
config:    https://ci.syzbot.org/builds/bb3f28da-9370-44d7-be20-9c443d5ebfc=
9/config
C repro:   https://ci.syzbot.org/findings/7af48589-24a5-4e09-bfe0-1969f5d98=
f4d/c_repro
syz repro: https://ci.syzbot.org/findings/7af48589-24a5-4e09-bfe0-1969f5d98=
f4d/syz_repro

syz.0.17 uses obsolete (PF_INET,SOCK_PACKET)
------------[ cut here ]------------
WARNING: CPU: 0 PID: 6010 at ./include/linux/skbuff.h:3024 skb_transport_he=
ader include/linux/skbuff.h:3024 [inline]
WARNING: CPU: 0 PID: 6010 at ./include/linux/skbuff.h:3024 skb_transport_of=
fset include/linux/skbuff.h:3175 [inline]
WARNING: CPU: 0 PID: 6010 at ./include/linux/skbuff.h:3024 virtio_net_hdr_f=
rom_skb+0x669/0xa30 include/linux/virtio_net.h:222
Modules linked in:
CPU: 0 UID: 0 PID: 6010 Comm: syz.0.17 Not tainted syzkaller #0 PREEMPT(ful=
l)=20
Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS 1.16.2-debian-1.16=
.2-1 04/01/2014
RIP: 0010:skb_transport_header include/linux/skbuff.h:3024 [inline]
RIP: 0010:skb_transport_offset include/linux/skbuff.h:3175 [inline]
RIP: 0010:virtio_net_hdr_from_skb+0x669/0xa30 include/linux/virtio_net.h:22=
2
Code: 00 00 00 fc ff df 0f b6 04 10 84 c0 0f 85 b0 03 00 00 41 c6 45 00 05 =
48 8b 74 24 08 83 c6 08 e9 ca fd ff ff e8 c8 1c 72 f7 90 <0f> 0b 90 e9 a7 f=
a ff ff e8 ba 1c 72 f7 90 0f 0b 90 e9 62 fc ff ff
RSP: 0018:ffffc90002def490 EFLAGS: 00010293
RAX: ffffffff8a4da238 RBX: 1ffff11004dafca6 RCX: ffff888023c9b980
RDX: 0000000000000000 RSI: 000000000000ffff RDI: 000000000000ffff
RBP: 1ffff1100537cbd8 R08: ffff88804138e059 R09: 0000000000000000
R10: ffff88804138e050 R11: ffffed1008271c0c R12: ffff888029be4000
R13: ffff888026d7e536 R14: ffff888029be5ec4 R15: 000000000000ffff
FS:  0000555557e59500(0000) GS:ffff8880b8615000(0000) knlGS:000000000000000=
0
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 0000200000003000 CR3: 00000000414a0000 CR4: 00000000000006f0
Call Trace:
 <TASK>
 tpacket_rcv+0x15c8/0x3290 net/packet/af_packet.c:2416
 __netif_receive_skb_one_core net/core/dev.c:5991 [inline]
 __netif_receive_skb+0x164/0x380 net/core/dev.c:6104
 netif_receive_skb_internal net/core/dev.c:6190 [inline]
 netif_receive_skb+0x1cb/0x790 net/core/dev.c:6249
 tun_rx_batched+0x1b9/0x730 drivers/net/tun.c:1485
 tun_get_user+0x2aa2/0x3e20 drivers/net/tun.c:1950
 tun_chr_write_iter+0x113/0x200 drivers/net/tun.c:1996
 new_sync_write fs/read_write.c:593 [inline]
 vfs_write+0x5c9/0xb30 fs/read_write.c:686
 ksys_write+0x145/0x250 fs/read_write.c:738
 do_syscall_x64 arch/x86/entry/syscall_64.c:63 [inline]
 do_syscall_64+0xfa/0x3b0 arch/x86/entry/syscall_64.c:94
 entry_SYSCALL_64_after_hwframe+0x77/0x7f
RIP: 0033:0x7fe74f78ec29
Code: ff ff c3 66 2e 0f 1f 84 00 00 00 00 00 0f 1f 40 00 48 89 f8 48 89 f7 =
48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 ff f=
f 73 01 c3 48 c7 c1 a8 ff ff ff f7 d8 64 89 01 48
RSP: 002b:00007fffd7d9aa28 EFLAGS: 00000246 ORIG_RAX: 0000000000000001
RAX: ffffffffffffffda RBX: 00007fe74f9d5fa0 RCX: 00007fe74f78ec29
RDX: 0000000000000fb5 RSI: 0000200000002780 RDI: 0000000000000004
RBP: 00007fe74f811e41 R08: 0000000000000000 R09: 0000000000000000
R10: 0000000000000000 R11: 0000000000000246 R12: 0000000000000000
R13: 00007fe74f9d5fa0 R14: 00007fe74f9d5fa0 R15: 0000000000000003
 </TASK>


***

If these findings have caused you to resend the series or submit a
separate fix, please add the following tag to your commit message:
  Tested-by: syzbot@syzkaller.appspotmail.com

---
This report is generated by a bot. It may contain errors.
syzbot ci engineers can be reached at syzkaller@googlegroups.com.

The email will later be sent to:
[alvaro.karsz@solid-run.com andrew@lunn.ch davem@davemloft.net edumazet@goo=
gle.com eperezma@redhat.com hengqi@linux.alibaba.com jasowang@redhat.com ji=
ri@resnulli.us kuba@kernel.org mst@redhat.com netdev@vger.kernel.org pabeni=
@redhat.com virtualization@lists.linux.dev willemb@google.com xuanzhuo@linu=
x.alibaba.com]

If the report looks fine to you, reply with:
#syz upstream

