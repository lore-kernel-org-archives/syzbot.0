Received: from mail-io1-f71.google.com (mail-io1-f71.google.com [209.85.166.71])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 89C0427AC54
	for <syzbot@lists.linux.dev>; Sat, 11 Oct 2025 14:13:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.71
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760191987; cv=none; b=be/57ByCDH+rAzww8X4E7X8j79fs/i1vIl7DcUCUgX+goLtMque45NPiEjmzm/JUYfYfj+TbLffQkUXtU6JBw1GwyZaBFU2yAqxe3wImUs/eVwgHkLBYUU4i9qUMbu7vloRou0iBurqT/bt14QybvZTz/2oHi3Ugy39qG2DvKx8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760191987; c=relaxed/simple;
	bh=rMo7HfRIE7eA6+jB+hLqNHgWOJShn+j7QG+I35e6KqY=;
	h=MIME-Version:Date:In-Reply-To:Message-ID:Subject:From:To:Cc:
	 Content-Type; b=GlsO50AVXu08MXwh4mGb8j3+Fj/3BY4CaImSYQtlWj+XLkM2KUIwXC9mbHN5mn/Mr3qH1Lo+908lTKCR0ZlWwt+TyMSEeKueKbo9lORC1+yFOtnbhzGPawwZwvQRLYhv++dqRlgN35W3I6wSe/GuZ2JPAZmUJnNeCKcM3Wc7pb0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com; arc=none smtp.client-ip=209.85.166.71
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com
Received: by mail-io1-f71.google.com with SMTP id ca18e2360f4ac-927f4207211so1303451139f.3
        for <syzbot@lists.linux.dev>; Sat, 11 Oct 2025 07:13:05 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1760191984; x=1760796784;
        h=cc:to:from:subject:message-id:in-reply-to:date:mime-version
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=ip+uLuuOjcts4R2e3BONfrdlhtbZShsrdc7YY7Z9NqQ=;
        b=a7t1NQ8DqyQjj2AMcXnAl5pC9tsjuql+rAfN4uAcRBd5FITXASBFZRwpEOTeB3PMfj
         bqxxuzticonkqQz1oTFzpod3LkhDRHnrzRbO0yKYYewmDQ8pJpwC7tr+UYHWHlmuUBTo
         SErAm373tZFYmA4SgFfqGrjEoFsXmYsGjw8pRzGePsY6u+ROhCsoP+zvu7PAwKsRtLQE
         LwHsA94tOo8uB0GyFSVt9vu32T3+F61mBeKKRuC45g0NXsEzW5/o/+ZOTxyQlLr+57ck
         vyOq5SiWesAR/7S/36EiJH7ZJZ4Pds9/Bo1vcQReKhc6bcM+zUt+maj4sT5qLe7oBjCc
         +Igg==
X-Gm-Message-State: AOJu0YwoI+3N23iiIMRruvHsf7ceyZpCxGAv8zJTvi4QtTtd2GrlYfaB
	j+5cpD/K0NhEURkVSCIV5dzASHMyEvPteIkK4t6AUKIL5JCFZDWlRU6n3KqrF/3yZyEqzYzJMuz
	VHL0s20EB7gZDHXQg+JUT2LAz9nXVDBZaSlwyTzjIJ5O1eSQU1LxXMWR9heQ=
X-Google-Smtp-Source: AGHT+IEYPeX0/JDZU2gXu5fZkKpTTFLubdS5ByzTo1zPFXqvhpbxq1nIWID2iHSofUykOKknq0DL0gMJcAfCLjzG4rPoTWJu6fOB
Precedence: bulk
X-Mailing-List: syzbot@lists.linux.dev
List-Id: <syzbot.lists.linux.dev>
List-Subscribe: <mailto:syzbot+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:syzbot+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Received: by 2002:a05:6602:3584:b0:92f:1738:92a0 with SMTP id
 ca18e2360f4ac-93bd17e481dmr2099063739f.7.1760191984683; Sat, 11 Oct 2025
 07:13:04 -0700 (PDT)
Date: Sat, 11 Oct 2025 07:13:04 -0700
In-Reply-To: <20251011094107.16439-1-xuanzhuo@linux.alibaba.com>
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <68ea65f0.050a0220.91a22.01ce.GAE@google.com>
Subject: [syzbot ci] Re: fixes two virtio-net related bugs.
From: syzbot ci <syzbot+cia46944debf22e178@syzkaller.appspotmail.com>
To: alvaro.karsz@solid-run.com, andrew@lunn.ch, davem@davemloft.net, 
	edumazet@google.com, eperezma@redhat.com, hengqi@linux.alibaba.com, 
	jasowang@redhat.com, jiri@resnulli.us, kuba@kernel.org, mst@redhat.com, 
	netdev@vger.kernel.org, pabeni@redhat.com, virtualization@lists.linux.dev, 
	willemb@google.com, xuanzhuo@linux.alibaba.com
Cc: syzbot@lists.linux.dev, syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"

syzbot ci has tested the following series

[v1] fixes two virtio-net related bugs.
https://lore.kernel.org/all/20251011094107.16439-1-xuanzhuo@linux.alibaba.com
* [PATCH net v1 1/3] virtio-net: fix incorrect flags recording in big mode
* [PATCH net v1 2/3] virtio-net: correct hdr_len handling for VIRTIO_NET_F_GUEST_HDRLEN
* [PATCH net v1 3/3] virtio-net: correct hdr_len handling for tunnel gso

and found the following issue:
WARNING in virtio_net_hdr_from_skb

Full report is available here:
https://ci.syzbot.org/series/694015b3-a5d7-400b-a7c2-c9ee69c35027

***

WARNING in virtio_net_hdr_from_skb

tree:      net
URL:       https://kernel.googlesource.com/pub/scm/linux/kernel/git/netdev/net.git
base:      2c95a756e0cfc19af6d0b32b0c6cf3bada334998
arch:      amd64
compiler:  Debian clang version 20.1.8 (++20250708063551+0c9f909b7976-1~exp1~20250708183702.136), Debian LLD 20.1.8
config:    https://ci.syzbot.org/builds/5e67ae6c-bfc6-42cc-ab94-ff0cde528221/config
C repro:   https://ci.syzbot.org/findings/39fb9135-9abf-418b-82a0-6478c7642a48/c_repro
syz repro: https://ci.syzbot.org/findings/39fb9135-9abf-418b-82a0-6478c7642a48/syz_repro

syz.0.17 uses obsolete (PF_INET,SOCK_PACKET)
------------[ cut here ]------------
WARNING: CPU: 1 PID: 5956 at ./include/linux/skbuff.h:3071 skb_transport_header include/linux/skbuff.h:3071 [inline]
WARNING: CPU: 1 PID: 5956 at ./include/linux/skbuff.h:3071 tcp_hdr include/linux/tcp.h:26 [inline]
WARNING: CPU: 1 PID: 5956 at ./include/linux/skbuff.h:3071 tcp_hdrlen include/linux/tcp.h:36 [inline]
WARNING: CPU: 1 PID: 5956 at ./include/linux/skbuff.h:3071 virtio_net_hdr_from_skb+0x5e6/0x8d0 include/linux/virtio_net.h:226
Modules linked in:
CPU: 1 UID: 0 PID: 5956 Comm: syz.0.17 Not tainted syzkaller #0 PREEMPT(full) 
Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS 1.16.2-debian-1.16.2-1 04/01/2014
RIP: 0010:skb_transport_header include/linux/skbuff.h:3071 [inline]
RIP: 0010:tcp_hdr include/linux/tcp.h:26 [inline]
RIP: 0010:tcp_hdrlen include/linux/tcp.h:36 [inline]
RIP: 0010:virtio_net_hdr_from_skb+0x5e6/0x8d0 include/linux/virtio_net.h:226
Code: 6f 01 4c 89 e8 48 c1 e8 03 0f b6 04 28 84 c0 0f 85 d8 02 00 00 41 c6 45 00 05 66 41 bf 08 00 e9 2c fd ff ff e8 2b 33 a8 f7 90 <0f> 0b 90 e9 f4 fb ff ff e8 1d 33 a8 f7 90 0f 0b 90 e9 b7 fc ff ff
RSP: 0018:ffffc90003777228 EFLAGS: 00010293
RAX: ffffffff8a16e845 RBX: ffff8881763f4fd0 RCX: ffff888106388000
RDX: 0000000000000000 RSI: 000000000000ffff RDI: 000000000000ffff
RBP: 000000000000ffff R08: ffff88817517f059 R09: 0000000000000000
R10: ffff88817517f050 R11: ffffed102ea2fe0c R12: ffff88816a55a498
R13: ffff8881763f4fb6 R14: ffff8881763f4f00 R15: 1ffff1102ec7e9f6
FS:  0000555585886500(0000) GS:ffff8882a9d3b000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 0000200000010000 CR3: 00000001128ba000 CR4: 00000000000006f0
Call Trace:
 <TASK>
 tpacket_rcv+0x1527/0x31c0 net/packet/af_packet.c:2362
 deliver_skb net/core/dev.c:2472 [inline]
 deliver_ptype_list_skb net/core/dev.c:2487 [inline]
 __netif_receive_skb_core+0x3465/0x4380 net/core/dev.c:6023
 __netif_receive_skb_one_core net/core/dev.c:6077 [inline]
 __netif_receive_skb+0x72/0x380 net/core/dev.c:6192
 netif_receive_skb_internal net/core/dev.c:6278 [inline]
 netif_receive_skb+0x1cb/0x790 net/core/dev.c:6337
 tun_rx_batched+0x1b9/0x730 drivers/net/tun.c:1485
 tun_get_user+0x2b65/0x3e90 drivers/net/tun.c:1953
 tun_chr_write_iter+0x113/0x200 drivers/net/tun.c:1999
 new_sync_write fs/read_write.c:593 [inline]
 vfs_write+0x5c9/0xb30 fs/read_write.c:686
 ksys_write+0x145/0x250 fs/read_write.c:738
 do_syscall_x64 arch/x86/entry/syscall_64.c:63 [inline]
 do_syscall_64+0xfa/0xfa0 arch/x86/entry/syscall_64.c:94
 entry_SYSCALL_64_after_hwframe+0x77/0x7f
RIP: 0033:0x7fd130b8eec9
Code: ff ff c3 66 2e 0f 1f 84 00 00 00 00 00 0f 1f 40 00 48 89 f8 48 89 f7 48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 ff ff 73 01 c3 48 c7 c1 a8 ff ff ff f7 d8 64 89 01 48
RSP: 002b:00007ffcdba8f558 EFLAGS: 00000246 ORIG_RAX: 0000000000000001
RAX: ffffffffffffffda RBX: 00007fd130de5fa0 RCX: 00007fd130b8eec9
RDX: 000000000000fdef RSI: 00002000000002c0 RDI: 0000000000000003
RBP: 00007fd130c11f91 R08: 0000000000000000 R09: 0000000000000000
R10: 0000000000000000 R11: 0000000000000246 R12: 0000000000000000
R13: 00007fd130de5fa0 R14: 00007fd130de5fa0 R15: 0000000000000003
 </TASK>


***

If these findings have caused you to resend the series or submit a
separate fix, please add the following tag to your commit message:
  Tested-by: syzbot@syzkaller.appspotmail.com

---
This report is generated by a bot. It may contain errors.
syzbot ci engineers can be reached at syzkaller@googlegroups.com.
