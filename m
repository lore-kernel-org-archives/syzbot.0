Received: from mail-oa1-f42.google.com (mail-oa1-f42.google.com [209.85.160.42])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F2BCE72626
	for <syzbot@lists.linux.dev>; Sat, 11 Oct 2025 14:10:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.160.42
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760191848; cv=none; b=IyKnHsb5HAq5x7+fAjsEQB4C9Gf41ZCwrNX9E3LEoz6lq4dHnsvhvUjBAAumSeQdGE09xUlf/8mvj9v2mp2QkQ1yva3jXRKjRs5dMJsN9q0SbMHw9oBOG1E3wbzxfEjqTmY78XScLboo+q6o2BIIAFqXY2PHCggvoVwkltUNRu4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760191848; c=relaxed/simple;
	bh=8OwuQueM8lx1WNPTkvY4Ni99xRjWSVkfo+AvMsSgT7E=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=We9dO88YnkJZX1ZYYvEdlSg6C476ejuvLzKYARQXMJUdD1acPq5mAXV06Hp3PaN9hKwcu5kDP3oHpYzoPDfU6h1RcSH3xj2olHGVuJoldOP7XLC4kSFFboncyjouIWqOHyX7+SwCcVVITeJ20WK6w2WoWmQuy4c+V2jiY7/VRpc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=nFHsbqXX; arc=none smtp.client-ip=209.85.160.42
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="nFHsbqXX"
Received: by mail-oa1-f42.google.com with SMTP id 586e51a60fabf-30cce50dfb4so1885755fac.0
        for <syzbot@lists.linux.dev>; Sat, 11 Oct 2025 07:10:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1760191846; x=1760796646; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=iW/S/bSV87Kpfwa40MZ0iErIZ8xTt5WDETFqpOOmlyI=;
        b=nFHsbqXXhBv5uMBgJXNJOmwImiQotum0MtPD8g/vwx6PPh9I0oihDhjU+YlrjyccCp
         TMtjyahxrjyTnNkl6JpLc38sB6gNuBOl8Mgq+aa3hBGOaEETlBPEBlvBZAx02ho27NEt
         63VDqMYCTHvssfhNhGVbaUFXllvTg+zsj/fdJ0F+VXqMBZ0+wrTif3Xr7tAAnUVkugAw
         7yI9VyJntD3WBzkcMIIlGwFstxYofvkHJ9X71qPOKXehoiomNh50Z8/wWH3cRelqsFCy
         mL0ttUzSy3sVo5SOKuEj8dvclOjy/Xlq8tmgo/DbGDsnxk7qbh6Pod+XBqlWrTv9Lkn5
         INUg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1760191846; x=1760796646;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=iW/S/bSV87Kpfwa40MZ0iErIZ8xTt5WDETFqpOOmlyI=;
        b=MkQoatCCgEY1ntL6rlBiV0nAVscJNljfIUpb1s0FFcGBoOR+rvBsDxAXAAATpx3n7j
         EqIYAKdsWT4ZENRNBfyuH3S2uFPYKfRKAQZfMUxNLI0pH218vphooeQVelHOAdNTxgIg
         jybZds5eJswbjkeUSvM0FQNy3effVzPttg0zzFCJtX/ox50TKk4ExjQJ1PRYbzwnCdlv
         +sTr7wyQO5C5ScvpBWYX/cc5dPbWPW5iy4hiALTQpkygZlvbvqTBxDpNYA7Day0e5CSu
         N6GJcWTMc7clRFy9KpDIYHSqx8JK5l1doxxqTBcdJw7oYD5b3uV8s0QK3d2TinSQR6de
         Wwog==
X-Forwarded-Encrypted: i=1; AJvYcCV1kMitBj6c0S/Vgxu/jtvc5Y6oMulch4ZCCSc5/yM9jh4ENyD0L4pvShmJPFHw+yMyEJNSP6s=@lists.linux.dev
X-Gm-Message-State: AOJu0Yw6lZVUBnRrLnEL+5RBonvbNbfdNDWgwEVqsG13sA6wUUEwQQsq
	vJ4yAmVTQdSJ6BpkGbc/5Ws2NIJ0PK0TYeoWFPkTj/G15X+kyjHaNDYy5lC06m2RFiX4w2WHkW6
	JIF1YQPXKJ1qssPaxvizS0od1lmKjliR3rxBECA5m8UUO74cKW9y9U8up
X-Gm-Gg: ASbGncsYci8CW7daK6lnZ/jPO9iI+Cva6+VouldY9ZcXL2wRxD27DbZCgLt9BG0pWP0
	EW8bt7ydv9Ykx5DHIMuhOxFoKs7qxxIjPJNbMnvlGcHw2ph2ZB+9PDqzVNs8OXvfbFvEAifXbG4
	Mmjl8UGbVrDYMwHkPoaCdxcmwNsqtT+/Zzy3G/sFf/15CTXDs/gpfuizRTX3qglPcR7n83An6b3
	AwubZkhmydkFivXgQD9DT+ifiZuXeRtVnSWLUlZmA68Zmo92jy/zaYGm4vNwuSLUzGvAhAHUENC
X-Google-Smtp-Source: AGHT+IHQz/yOLZGd0XP7mjgnatzVJiU3PfslbQ+Iv2ZkwCdv8B86YimNP1DwYV7GNnfz+LNUT5YXZ+8da55iN67USLU=
X-Received: by 2002:a05:6870:f10d:b0:321:fcf1:e841 with SMTP id
 586e51a60fabf-3c0f62f8b58mr8198536fac.6.1760191845722; Sat, 11 Oct 2025
 07:10:45 -0700 (PDT)
Precedence: bulk
X-Mailing-List: syzbot@lists.linux.dev
List-Id: <syzbot.lists.linux.dev>
List-Subscribe: <mailto:syzbot+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:syzbot+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <68ea5ccb.a70a0220.b3ac9.000a.GAE@google.com>
In-Reply-To: <68ea5ccb.a70a0220.b3ac9.000a.GAE@google.com>
From: Aleksandr Nogikh <nogikh@google.com>
Date: Sat, 11 Oct 2025 16:10:34 +0200
X-Gm-Features: AS18NWBYKCazFYdCrzPrZVx4vTpSYop1BgPEn1hz28PbIIC-MVylRjd_PaxxZFc
Message-ID: <CANp29Y7aw9F5ObcphJMh-n2L+o4pwfY-F-Fx9ZpkcXn0Ntba0g@mail.gmail.com>
Subject: Re: [moderation/CI] Re: fixes two virtio-net related bugs.
To: syzbot ci <syzbot+ci26f4fb10a5e60441@syzkaller.appspotmail.com>
Cc: syzkaller-upstream-moderation@googlegroups.com, syzbot@lists.linux.dev
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

#syz upstream


On Sat, Oct 11, 2025 at 3:34=E2=80=AFPM syzbot ci
<syzbot+ci26f4fb10a5e60441@syzkaller.appspotmail.com> wrote:
>
> syzbot ci has tested the following series
>
> [v1] fixes two virtio-net related bugs.
> https://lore.kernel.org/all/20251011094107.16439-1-xuanzhuo@linux.alibaba=
.com
> * [PATCH net v1 1/3] virtio-net: fix incorrect flags recording in big mod=
e
> * [PATCH net v1 2/3] virtio-net: correct hdr_len handling for VIRTIO_NET_=
F_GUEST_HDRLEN
> * [PATCH net v1 3/3] virtio-net: correct hdr_len handling for tunnel gso
>
> and found the following issue:
> WARNING in virtio_net_hdr_from_skb
>
> Full report is available here:
> https://ci.syzbot.org/series/694015b3-a5d7-400b-a7c2-c9ee69c35027
>
> ***
>
> WARNING in virtio_net_hdr_from_skb
>
> tree:      net
> URL:       https://kernel.googlesource.com/pub/scm/linux/kernel/git/netde=
v/net.git
> base:      2c95a756e0cfc19af6d0b32b0c6cf3bada334998
> arch:      amd64
> compiler:  Debian clang version 20.1.8 (++20250708063551+0c9f909b7976-1~e=
xp1~20250708183702.136), Debian LLD 20.1.8
> config:    https://ci.syzbot.org/builds/5e67ae6c-bfc6-42cc-ab94-ff0cde528=
221/config
> C repro:   https://ci.syzbot.org/findings/39fb9135-9abf-418b-82a0-6478c76=
42a48/c_repro
> syz repro: https://ci.syzbot.org/findings/39fb9135-9abf-418b-82a0-6478c76=
42a48/syz_repro
>
> syz.0.17 uses obsolete (PF_INET,SOCK_PACKET)
> ------------[ cut here ]------------
> WARNING: CPU: 1 PID: 5956 at ./include/linux/skbuff.h:3071 skb_transport_=
header include/linux/skbuff.h:3071 [inline]
> WARNING: CPU: 1 PID: 5956 at ./include/linux/skbuff.h:3071 tcp_hdr includ=
e/linux/tcp.h:26 [inline]
> WARNING: CPU: 1 PID: 5956 at ./include/linux/skbuff.h:3071 tcp_hdrlen inc=
lude/linux/tcp.h:36 [inline]
> WARNING: CPU: 1 PID: 5956 at ./include/linux/skbuff.h:3071 virtio_net_hdr=
_from_skb+0x5e6/0x8d0 include/linux/virtio_net.h:226
> Modules linked in:
> CPU: 1 UID: 0 PID: 5956 Comm: syz.0.17 Not tainted syzkaller #0 PREEMPT(f=
ull)
> Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS 1.16.2-debian-1.=
16.2-1 04/01/2014
> RIP: 0010:skb_transport_header include/linux/skbuff.h:3071 [inline]
> RIP: 0010:tcp_hdr include/linux/tcp.h:26 [inline]
> RIP: 0010:tcp_hdrlen include/linux/tcp.h:36 [inline]
> RIP: 0010:virtio_net_hdr_from_skb+0x5e6/0x8d0 include/linux/virtio_net.h:=
226
> Code: 6f 01 4c 89 e8 48 c1 e8 03 0f b6 04 28 84 c0 0f 85 d8 02 00 00 41 c=
6 45 00 05 66 41 bf 08 00 e9 2c fd ff ff e8 2b 33 a8 f7 90 <0f> 0b 90 e9 f4=
 fb ff ff e8 1d 33 a8 f7 90 0f 0b 90 e9 b7 fc ff ff
> RSP: 0018:ffffc90003777228 EFLAGS: 00010293
> RAX: ffffffff8a16e845 RBX: ffff8881763f4fd0 RCX: ffff888106388000
> RDX: 0000000000000000 RSI: 000000000000ffff RDI: 000000000000ffff
> RBP: 000000000000ffff R08: ffff88817517f059 R09: 0000000000000000
> R10: ffff88817517f050 R11: ffffed102ea2fe0c R12: ffff88816a55a498
> R13: ffff8881763f4fb6 R14: ffff8881763f4f00 R15: 1ffff1102ec7e9f6
> FS:  0000555585886500(0000) GS:ffff8882a9d3b000(0000) knlGS:0000000000000=
000
> CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> CR2: 0000200000010000 CR3: 00000001128ba000 CR4: 00000000000006f0
> Call Trace:
>  <TASK>
>  tpacket_rcv+0x1527/0x31c0 net/packet/af_packet.c:2362
>  deliver_skb net/core/dev.c:2472 [inline]
>  deliver_ptype_list_skb net/core/dev.c:2487 [inline]
>  __netif_receive_skb_core+0x3465/0x4380 net/core/dev.c:6023
>  __netif_receive_skb_one_core net/core/dev.c:6077 [inline]
>  __netif_receive_skb+0x72/0x380 net/core/dev.c:6192
>  netif_receive_skb_internal net/core/dev.c:6278 [inline]
>  netif_receive_skb+0x1cb/0x790 net/core/dev.c:6337
>  tun_rx_batched+0x1b9/0x730 drivers/net/tun.c:1485
>  tun_get_user+0x2b65/0x3e90 drivers/net/tun.c:1953
>  tun_chr_write_iter+0x113/0x200 drivers/net/tun.c:1999
>  new_sync_write fs/read_write.c:593 [inline]
>  vfs_write+0x5c9/0xb30 fs/read_write.c:686
>  ksys_write+0x145/0x250 fs/read_write.c:738
>  do_syscall_x64 arch/x86/entry/syscall_64.c:63 [inline]
>  do_syscall_64+0xfa/0xfa0 arch/x86/entry/syscall_64.c:94
>  entry_SYSCALL_64_after_hwframe+0x77/0x7f
> RIP: 0033:0x7fd130b8eec9
> Code: ff ff c3 66 2e 0f 1f 84 00 00 00 00 00 0f 1f 40 00 48 89 f8 48 89 f=
7 48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 ff=
 ff 73 01 c3 48 c7 c1 a8 ff ff ff f7 d8 64 89 01 48
> RSP: 002b:00007ffcdba8f558 EFLAGS: 00000246 ORIG_RAX: 0000000000000001
> RAX: ffffffffffffffda RBX: 00007fd130de5fa0 RCX: 00007fd130b8eec9
> RDX: 000000000000fdef RSI: 00002000000002c0 RDI: 0000000000000003
> RBP: 00007fd130c11f91 R08: 0000000000000000 R09: 0000000000000000
> R10: 0000000000000000 R11: 0000000000000246 R12: 0000000000000000
> R13: 00007fd130de5fa0 R14: 00007fd130de5fa0 R15: 0000000000000003
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
> The email will later be sent to:
> [alvaro.karsz@solid-run.com andrew@lunn.ch davem@davemloft.net edumazet@g=
oogle.com eperezma@redhat.com hengqi@linux.alibaba.com jasowang@redhat.com =
jiri@resnulli.us kuba@kernel.org mst@redhat.com netdev@vger.kernel.org pabe=
ni@redhat.com virtualization@lists.linux.dev willemb@google.com xuanzhuo@li=
nux.alibaba.com]
>
> If the report looks fine to you, reply with:
> #syz upstream
>
> --
> You received this message because you are subscribed to the Google Groups=
 "syzkaller-upstream-moderation" group.
> To unsubscribe from this group and stop receiving emails from it, send an=
 email to syzkaller-upstream-moderation+unsubscribe@googlegroups.com.
> To view this discussion visit https://groups.google.com/d/msgid/syzkaller=
-upstream-moderation/68ea5ccb.a70a0220.b3ac9.000a.GAE%40google.com.
