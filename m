Received: from mail-il1-f200.google.com (mail-il1-f200.google.com [209.85.166.200])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 03A12263F2D
	for <syzbot@lists.linux.dev>; Sat, 11 Oct 2025 13:34:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.200
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760189645; cv=none; b=PBxvSNVEeL9W+v6ZwEiQABRu98qJ7bMBswVEw054cXqEy2tXNWCjriRz9CUqGuuGbcAG6QNSMDJlJDpZ+dKiHZXyD7wmc6oGkjG2RVYk8ddQd7+FVtORwDt91blApJ4WdUnoIr/nzgReFhcs5oIgFl+/hWhflNsGkY5Cx1J1P+8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760189645; c=relaxed/simple;
	bh=n2PAkn0HzWvCJvrvI507OTXKTmojfN+d2CzXTb79YqA=;
	h=MIME-Version:Date:Message-ID:Subject:From:To:Cc:Content-Type; b=CZnExCj15j0H9POcZVF7d5yH/nWMhOmrVM9pKHSG7sdI1oard4V8qb6F/jtCVZOVycye85gywUFmBJS4kDiKpiQaxlnQMFavJVOztF4TLy4YY/uTKBIY4+/rzPj3WRB9rnkL7fccW2Akrq+aFHDPbBq3ZCB7Zz1B9EZY4gtnF+0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com; arc=none smtp.client-ip=209.85.166.200
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com
Received: by mail-il1-f200.google.com with SMTP id e9e14a558f8ab-4257626a814so130122425ab.0
        for <syzbot@lists.linux.dev>; Sat, 11 Oct 2025 06:34:03 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1760189643; x=1760794443;
        h=content-transfer-encoding:cc:to:from:subject:message-id:date
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=5BKYMj32q/AwNqxGDjg6wayq6enNMAgDk0h6PEFP7RM=;
        b=idBKEiUgqGJGflcmUX+XWZFEpCFQMubaAZvcUsV7MRSq9aTDWh+SuNZzt4iUA5jwmx
         +vXP5c/EZzKZGrLdd/5/M4ey2QZrDKPqe2TkxO5ua1lZdhFukPfSjpBvzlBdPqDSWfmm
         Udl7lv//waW5TfCq8ttu2tpdWLLKWFwflMpt8WXV3yx41ITkUk3G8B9/B6sSKj9Rmeiy
         OV3zNylocsdN065FLQxce1Hmzxt9cBs684VauWf3UxQqL7gpLm1XFWy6Y9EgvEtzXaUs
         vW//9WRKwnux6kVETyh3q70QNeh1O9qirVdDtfEtOWqFULMxTFvx/hgyjnFyqvbf87XV
         qWPw==
X-Gm-Message-State: AOJu0YwSJEnVQMA5oDOE9QJsEQqVwcc2cLDZYO7xfAKaPIrbU/Yeyg/H
	8yE9UTg6noWSPWTt2ulA5IsQkDQCYDLHlBC57cg59VQW5AdmXyxXtGpHGz2zwOxRS8VJYFbDHmT
	vRlvpd67OJNlRpgP8FcRa1jirOuyoL6aUVrsFRjv2eyOXJd8+GKTUvmtcbpM=
X-Google-Smtp-Source: AGHT+IHBdG98wqrh8T7PQNQkN+zaiot5bSB+E4VJn4F1/vP+RSZY0I7+k7BOh5iX5x8j1U68oGlTPa6vkLH3YvlF9sziZvbj4wif
Precedence: bulk
X-Mailing-List: syzbot@lists.linux.dev
List-Id: <syzbot.lists.linux.dev>
List-Subscribe: <mailto:syzbot+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:syzbot+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Received: by 2002:a05:6e02:1a8a:b0:425:6f0b:a1db with SMTP id
 e9e14a558f8ab-42f8737df63mr167105295ab.9.1760189643076; Sat, 11 Oct 2025
 06:34:03 -0700 (PDT)
Date: Sat, 11 Oct 2025 06:34:03 -0700
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <68ea5ccb.a70a0220.b3ac9.000a.GAE@google.com>
Subject: [moderation/CI] Re: fixes two virtio-net related bugs.
From: syzbot ci <syzbot+ci26f4fb10a5e60441@syzkaller.appspotmail.com>
To: syzkaller-upstream-moderation@googlegroups.com
Cc: syzbot@lists.linux.dev
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

syzbot ci has tested the following series

[v1] fixes two virtio-net related bugs.
https://lore.kernel.org/all/20251011094107.16439-1-xuanzhuo@linux.alibaba.c=
om
* [PATCH net v1 1/3] virtio-net: fix incorrect flags recording in big mode
* [PATCH net v1 2/3] virtio-net: correct hdr_len handling for VIRTIO_NET_F_=
GUEST_HDRLEN
* [PATCH net v1 3/3] virtio-net: correct hdr_len handling for tunnel gso

and found the following issue:
WARNING in virtio_net_hdr_from_skb

Full report is available here:
https://ci.syzbot.org/series/694015b3-a5d7-400b-a7c2-c9ee69c35027

***

WARNING in virtio_net_hdr_from_skb

tree:      net
URL:       https://kernel.googlesource.com/pub/scm/linux/kernel/git/netdev/=
net.git
base:      2c95a756e0cfc19af6d0b32b0c6cf3bada334998
arch:      amd64
compiler:  Debian clang version 20.1.8 (++20250708063551+0c9f909b7976-1~exp=
1~20250708183702.136), Debian LLD 20.1.8
config:    https://ci.syzbot.org/builds/5e67ae6c-bfc6-42cc-ab94-ff0cde52822=
1/config
C repro:   https://ci.syzbot.org/findings/39fb9135-9abf-418b-82a0-6478c7642=
a48/c_repro
syz repro: https://ci.syzbot.org/findings/39fb9135-9abf-418b-82a0-6478c7642=
a48/syz_repro

syz.0.17 uses obsolete (PF_INET,SOCK_PACKET)
------------[ cut here ]------------
WARNING: CPU: 1 PID: 5956 at ./include/linux/skbuff.h:3071 skb_transport_he=
ader include/linux/skbuff.h:3071 [inline]
WARNING: CPU: 1 PID: 5956 at ./include/linux/skbuff.h:3071 tcp_hdr include/=
linux/tcp.h:26 [inline]
WARNING: CPU: 1 PID: 5956 at ./include/linux/skbuff.h:3071 tcp_hdrlen inclu=
de/linux/tcp.h:36 [inline]
WARNING: CPU: 1 PID: 5956 at ./include/linux/skbuff.h:3071 virtio_net_hdr_f=
rom_skb+0x5e6/0x8d0 include/linux/virtio_net.h:226
Modules linked in:
CPU: 1 UID: 0 PID: 5956 Comm: syz.0.17 Not tainted syzkaller #0 PREEMPT(ful=
l)=20
Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS 1.16.2-debian-1.16=
.2-1 04/01/2014
RIP: 0010:skb_transport_header include/linux/skbuff.h:3071 [inline]
RIP: 0010:tcp_hdr include/linux/tcp.h:26 [inline]
RIP: 0010:tcp_hdrlen include/linux/tcp.h:36 [inline]
RIP: 0010:virtio_net_hdr_from_skb+0x5e6/0x8d0 include/linux/virtio_net.h:22=
6
Code: 6f 01 4c 89 e8 48 c1 e8 03 0f b6 04 28 84 c0 0f 85 d8 02 00 00 41 c6 =
45 00 05 66 41 bf 08 00 e9 2c fd ff ff e8 2b 33 a8 f7 90 <0f> 0b 90 e9 f4 f=
b ff ff e8 1d 33 a8 f7 90 0f 0b 90 e9 b7 fc ff ff
RSP: 0018:ffffc90003777228 EFLAGS: 00010293
RAX: ffffffff8a16e845 RBX: ffff8881763f4fd0 RCX: ffff888106388000
RDX: 0000000000000000 RSI: 000000000000ffff RDI: 000000000000ffff
RBP: 000000000000ffff R08: ffff88817517f059 R09: 0000000000000000
R10: ffff88817517f050 R11: ffffed102ea2fe0c R12: ffff88816a55a498
R13: ffff8881763f4fb6 R14: ffff8881763f4f00 R15: 1ffff1102ec7e9f6
FS:  0000555585886500(0000) GS:ffff8882a9d3b000(0000) knlGS:000000000000000=
0
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
Code: ff ff c3 66 2e 0f 1f 84 00 00 00 00 00 0f 1f 40 00 48 89 f8 48 89 f7 =
48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 ff f=
f 73 01 c3 48 c7 c1 a8 ff ff ff f7 d8 64 89 01 48
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

The email will later be sent to:
[alvaro.karsz@solid-run.com andrew@lunn.ch davem@davemloft.net edumazet@goo=
gle.com eperezma@redhat.com hengqi@linux.alibaba.com jasowang@redhat.com ji=
ri@resnulli.us kuba@kernel.org mst@redhat.com netdev@vger.kernel.org pabeni=
@redhat.com virtualization@lists.linux.dev willemb@google.com xuanzhuo@linu=
x.alibaba.com]

If the report looks fine to you, reply with:
#syz upstream

