Received: from mail-pl1-f173.google.com (mail-pl1-f173.google.com [209.85.214.173])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1FEAA35959
	for <syzbot@lists.linux.dev>; Thu, 25 Sep 2025 07:17:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.173
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758784642; cv=none; b=DAm0v7f4JXv61e+GFX/LoMc7xG5sSzA96Zoyg+NAqAOLhZxpeNd2W25+nO29UVTJT3cTI+s8oURlUX6Hq/xq2BxZT7VGRYfc8vkhxeBhj65JzWIFI0OOyU8V8FMFR6bQqdxNLSre/WHrKRxm02iJGe+EofKnKxdPheIextWFX7M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758784642; c=relaxed/simple;
	bh=wkJin5friuYJrNx8VdS5ZXRcPzSfIJsnWEQZPjkSx2M=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=IGE0yJIkV/H4rGwMKZbAm0RWTG8bjU/Z8VUfcTVFr0svy02HL51CvEsY5CLis3agNF8fJ7QXEkhqUw8r4J1ZFk1dSz5oP1sgLzjEHUUlnRwKnGGwzcwHvxZofYDVEZZFZBV3iwegL+dCZPgbcdfjIKeaAPncxNCPYUmZOav+TUI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=TjCd3O/i; arc=none smtp.client-ip=209.85.214.173
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="TjCd3O/i"
Received: by mail-pl1-f173.google.com with SMTP id d9443c01a7336-27d69771e3eso5596895ad.3
        for <syzbot@lists.linux.dev>; Thu, 25 Sep 2025 00:17:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1758784639; x=1759389439; darn=lists.linux.dev;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=lSVUKhs5/+Z/0Rr6WKY3+iJkDd0vKMZeqP+3Lmjnngc=;
        b=TjCd3O/i0QQXq4yb+Fmmy++5IPrQIq2/B0R+Joi989DTW+lyS9L/YyOXmIt5a5J2c3
         SOQfBEWXAdooaociKXXgdojWBfIcQRJq9i9YW0GOoW3ppJ4ABnXA7YFOBMWMHVd/s1Ge
         URutPprAVkHg8uggco5W/RuNh2PUhShJceXYMiS6O7dXvGYNUzdFn66npbLoRDffzZuw
         0ifSncswDl/MAL7r7kNdCOraL/9au4ci6WCIbhyCCrchtu2Qi/s8MIDAxG07p/Ec8Zu+
         rpVFsiYNqe2sCN7uBpxa7yDWAzHRw6s9SiSRhsQ8qq/sGk4mbekhWT9+yVkMLNXezh2Y
         XJfw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1758784639; x=1759389439;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=lSVUKhs5/+Z/0Rr6WKY3+iJkDd0vKMZeqP+3Lmjnngc=;
        b=PrboUcBtA6Q3rsMNUKGTmjsjq0s9MNBroqUbI5mZSwJsYRB5jtPJXVAWSuJwr4AIO9
         Kyl4bKpLnS8WTwpoNfysL82s8vXkVQ2snzJKtLefg+wxP8Xf7IrXiFvpMsrgvg0FjKvx
         XuOyVFjF7KLynlErSuT8hFJv/2pMqNgLWMuB8u1K6akmmEIS0jG6gj4WF1EaR7SCqbKT
         bgKzqlJYnUP2MDKQoL9oYwsFt6HCPkbH+jY723RYNecZcct9NqTdFLRybPGgVtCbHbJY
         SvAw0VPmxDt2A2081m8r6A1ezXFqP9I7GiIW/goLcbLQa87+DMVv4vRH8Y0upl2lOM4M
         D0sA==
X-Forwarded-Encrypted: i=1; AJvYcCWVFg2FnxPaZiXYHkiNP1tiH31WLje942YGOGNsfG5nMxryHo0ZUEvMXZsNQsAFx3fs/UPKRhw=@lists.linux.dev
X-Gm-Message-State: AOJu0YysiBtQohsIW7QK23EK7CNLNxAF6RVSm8220jaOjV3Bg9mDjH/D
	/T77t/zc5A26Tf1tHpU6AyLfkBBfJd9UPUchOCRoNS8qo91+M3IActYDcK/RrupyNQUMDgZ1prz
	8FFU7Iy49x2lYsY7Fq1QxWyTVO7WlHWofEZeElHot
X-Gm-Gg: ASbGncu8aIyQBQa25aRvooJ3xWb3Yh9bJd97R4QhAhno5FhuVLnBpUB5o0AE6jf2BMi
	1kXFbe8IIqSoNV8aYnQqTQ1btWCoPCBVhVWP7jYYiytE3f8M7WAatKVDh8pfThQOyNqOq9w2cL7
	lj2GADI5SWWfeURV1QoLavGL65DXuycDFY97kWW9w4ZbYaliqi+76KNsufLvXNnZFT5potCR58X
	3ODNAvIaF0Zj8WvPPk10LBCssqzVn2/btaZT2sTNnXBrg==
X-Google-Smtp-Source: AGHT+IFA9imzTAUtisyY1C+s9nbH6LSoPGfId9YQZDIVeQXECRAynYvQ4assMOUbG31nmZcEkcb7VvLbjX5oJqXfFC8=
X-Received: by 2002:a17:902:cec3:b0:261:1521:17a8 with SMTP id
 d9443c01a7336-27ed4a16b69mr31503615ad.16.1758784639044; Thu, 25 Sep 2025
 00:17:19 -0700 (PDT)
Precedence: bulk
X-Mailing-List: syzbot@lists.linux.dev
List-Id: <syzbot.lists.linux.dev>
List-Subscribe: <mailto:syzbot+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:syzbot+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20250925022537.91774-1-xuanzhuo@linux.alibaba.com> <68d4eb92.050a0220.25d7ab.0003.GAE@google.com>
In-Reply-To: <68d4eb92.050a0220.25d7ab.0003.GAE@google.com>
From: Marco Elver <elver@google.com>
Date: Thu, 25 Sep 2025 09:16:42 +0200
X-Gm-Features: AS18NWATumRaSLUFu677suqFcBV3K3UsryeU-HULamMGZj_eosgCQ-JFsU4-Q98
Message-ID: <CANpmjNM7cCDoLUGV4J+MfAbQFedmEXhNrhf7fYiFs7Gi7Yz0mg@mail.gmail.com>
Subject: Re: [syzbot ci] Re: fixes two virtio-net related bugs.
To: syzbot ci <syzbot+ci4290219e4732157d@syzkaller.appspotmail.com>
Cc: alvaro.karsz@solid-run.com, andrew@lunn.ch, davem@davemloft.net, 
	edumazet@google.com, eperezma@redhat.com, hengqi@linux.alibaba.com, 
	jasowang@redhat.com, jiri@resnulli.us, kuba@kernel.org, mst@redhat.com, 
	netdev@vger.kernel.org, pabeni@redhat.com, virtualization@lists.linux.dev, 
	willemb@google.com, xuanzhuo@linux.alibaba.com, syzbot@lists.linux.dev, 
	syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"

#syz upstream

On Thu, 25 Sept 2025 at 09:13, syzbot ci
<syzbot+ci4290219e4732157d@syzkaller.appspotmail.com> wrote:
>
> syzbot ci has tested the following series
>
> [v1] fixes two virtio-net related bugs.
> https://lore.kernel.org/all/20250925022537.91774-1-xuanzhuo@linux.alibaba.com
> * [PATCH net 1/2] virtio-net: fix incorrect flags recording in big mode
> * [PATCH net 2/2] virtio-net: correct hdr_len handling for VIRTIO_NET_F_GUEST_HDRLEN
>
> and found the following issue:
> WARNING in virtio_net_hdr_from_skb
>
> Full report is available here:
> https://ci.syzbot.org/series/41a78b3d-b982-4507-b02f-1991c8d827c9
>
> ***
>
> WARNING in virtio_net_hdr_from_skb
>
> tree:      net
> URL:       https://kernel.googlesource.com/pub/scm/linux/kernel/git/netdev/net.git
> base:      f8b4687151021db61841af983f1cb7be6915d4ef
> arch:      amd64
> compiler:  Debian clang version 20.1.8 (++20250708063551+0c9f909b7976-1~exp1~20250708183702.136), Debian LLD 20.1.8
> config:    https://ci.syzbot.org/builds/bb3f28da-9370-44d7-be20-9c443d5ebfc9/config
> C repro:   https://ci.syzbot.org/findings/7af48589-24a5-4e09-bfe0-1969f5d98f4d/c_repro
> syz repro: https://ci.syzbot.org/findings/7af48589-24a5-4e09-bfe0-1969f5d98f4d/syz_repro
>
> syz.0.17 uses obsolete (PF_INET,SOCK_PACKET)
> ------------[ cut here ]------------
> WARNING: CPU: 0 PID: 6010 at ./include/linux/skbuff.h:3024 skb_transport_header include/linux/skbuff.h:3024 [inline]
> WARNING: CPU: 0 PID: 6010 at ./include/linux/skbuff.h:3024 skb_transport_offset include/linux/skbuff.h:3175 [inline]
> WARNING: CPU: 0 PID: 6010 at ./include/linux/skbuff.h:3024 virtio_net_hdr_from_skb+0x669/0xa30 include/linux/virtio_net.h:222
> Modules linked in:
> CPU: 0 UID: 0 PID: 6010 Comm: syz.0.17 Not tainted syzkaller #0 PREEMPT(full)
> Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS 1.16.2-debian-1.16.2-1 04/01/2014
> RIP: 0010:skb_transport_header include/linux/skbuff.h:3024 [inline]
> RIP: 0010:skb_transport_offset include/linux/skbuff.h:3175 [inline]
> RIP: 0010:virtio_net_hdr_from_skb+0x669/0xa30 include/linux/virtio_net.h:222
> Code: 00 00 00 fc ff df 0f b6 04 10 84 c0 0f 85 b0 03 00 00 41 c6 45 00 05 48 8b 74 24 08 83 c6 08 e9 ca fd ff ff e8 c8 1c 72 f7 90 <0f> 0b 90 e9 a7 fa ff ff e8 ba 1c 72 f7 90 0f 0b 90 e9 62 fc ff ff
> RSP: 0018:ffffc90002def490 EFLAGS: 00010293
> RAX: ffffffff8a4da238 RBX: 1ffff11004dafca6 RCX: ffff888023c9b980
> RDX: 0000000000000000 RSI: 000000000000ffff RDI: 000000000000ffff
> RBP: 1ffff1100537cbd8 R08: ffff88804138e059 R09: 0000000000000000
> R10: ffff88804138e050 R11: ffffed1008271c0c R12: ffff888029be4000
> R13: ffff888026d7e536 R14: ffff888029be5ec4 R15: 000000000000ffff
> FS:  0000555557e59500(0000) GS:ffff8880b8615000(0000) knlGS:0000000000000000
> CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> CR2: 0000200000003000 CR3: 00000000414a0000 CR4: 00000000000006f0
> Call Trace:
>  <TASK>
>  tpacket_rcv+0x15c8/0x3290 net/packet/af_packet.c:2416
>  __netif_receive_skb_one_core net/core/dev.c:5991 [inline]
>  __netif_receive_skb+0x164/0x380 net/core/dev.c:6104
>  netif_receive_skb_internal net/core/dev.c:6190 [inline]
>  netif_receive_skb+0x1cb/0x790 net/core/dev.c:6249
>  tun_rx_batched+0x1b9/0x730 drivers/net/tun.c:1485
>  tun_get_user+0x2aa2/0x3e20 drivers/net/tun.c:1950
>  tun_chr_write_iter+0x113/0x200 drivers/net/tun.c:1996
>  new_sync_write fs/read_write.c:593 [inline]
>  vfs_write+0x5c9/0xb30 fs/read_write.c:686
>  ksys_write+0x145/0x250 fs/read_write.c:738
>  do_syscall_x64 arch/x86/entry/syscall_64.c:63 [inline]
>  do_syscall_64+0xfa/0x3b0 arch/x86/entry/syscall_64.c:94
>  entry_SYSCALL_64_after_hwframe+0x77/0x7f
> RIP: 0033:0x7fe74f78ec29
> Code: ff ff c3 66 2e 0f 1f 84 00 00 00 00 00 0f 1f 40 00 48 89 f8 48 89 f7 48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 ff ff 73 01 c3 48 c7 c1 a8 ff ff ff f7 d8 64 89 01 48
> RSP: 002b:00007fffd7d9aa28 EFLAGS: 00000246 ORIG_RAX: 0000000000000001
> RAX: ffffffffffffffda RBX: 00007fe74f9d5fa0 RCX: 00007fe74f78ec29
> RDX: 0000000000000fb5 RSI: 0000200000002780 RDI: 0000000000000004
> RBP: 00007fe74f811e41 R08: 0000000000000000 R09: 0000000000000000
> R10: 0000000000000000 R11: 0000000000000246 R12: 0000000000000000
> R13: 00007fe74f9d5fa0 R14: 00007fe74f9d5fa0 R15: 0000000000000003
>  </TASK>
>
>
> ***
>
> If these findings have caused you to resend the series or submit a
> separate fix, please add the following tag to your commit message:
>   Tested-by: syzbot@syzkaller.appspotmail.com
>
> ---
> This report is generated by a bot. It may contain errors.
> syzbot ci engineers can be reached at syzkaller@googlegroups.com.
>
> --
> You received this message because you are subscribed to the Google Groups "syzkaller-bugs" group.
> To unsubscribe from this group and stop receiving emails from it, send an email to syzkaller-bugs+unsubscribe@googlegroups.com.
> To view this discussion visit https://groups.google.com/d/msgid/syzkaller-bugs/68d4eb92.050a0220.25d7ab.0003.GAE%40google.com.
