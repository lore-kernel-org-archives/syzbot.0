Received: from mail-wr1-f53.google.com (mail-wr1-f53.google.com [209.85.221.53])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 946E12BB13
	for <syzbot@lists.linux.dev>; Thu, 25 Sep 2025 07:11:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.53
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758784279; cv=none; b=N8DXWPv2SgTigsaTwracAjh8eBvBEFaxZU6iHM/nSQPlC9Fmtsj8/VZs+J5OwSurzbFtGeeYmoU/K8wZhnEuxWOwHn2EpJN9s9pVhWl8HKIaOs5cHCR05euMbvocNRoTyPP+jImevdf5jC0kyfF8eL8WbWgAxfZIYcy7tpk6HOk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758784279; c=relaxed/simple;
	bh=0eDYl3on0JAYoJf0g9qci9Xh25pvF5uGarpmx9OKjM8=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=DJF/LT8O+/swPnyu4BQFyeed9etq6GLrFH3mG9mnzt94rYe4WR3MX49KxiMOHY2e/RZ9br4eSkjI2JM3KC27Wyzr3YhkvfN5AiOBpBiaQrad5d7pgwhlQVrcGpMsi3gzQ8ujKJkKe7rpAXpXa3xlwu0mPlqku2X1UDfy5Qac3MQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=32/VEvlx; arc=none smtp.client-ip=209.85.221.53
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="32/VEvlx"
Received: by mail-wr1-f53.google.com with SMTP id ffacd0b85a97d-3f42b54d1b9so713764f8f.0
        for <syzbot@lists.linux.dev>; Thu, 25 Sep 2025 00:11:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1758784276; x=1759389076; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=XOUUgLVyqx7oGvP+rLGDmdRaaKJsUW2eJ7TT4nNkeic=;
        b=32/VEvlxtl7Z5/qiGUROGIIvMvghmL4BGrCMLKjx3Z5Op9lB6Onsha421C7z7g47lD
         4aSTYX4VEZXSAcwKUfVmm5z1vIDFcFpl0t/uDJPUL00x7uwA2utWrGBLReZYkGKfFuiI
         ur1max+shldy8L2/8xdBYKHWc8CWneMBh0ciw/ZYID4E/5ZqA+kY8hCY579Boy7Nwf6z
         wfau+V7fXCHGVpmBTCblXKJWX0sXdMa7yKnnrjap69lpd71qq3v3pDfL/sJZ1b3Iz1yT
         DA6uHczUHvL+mK/Q1nfx+v0opkdTmCH9LMV5CkK+de2u9pl305PsY95rYWeMaD8nniaU
         JVQg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1758784276; x=1759389076;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=XOUUgLVyqx7oGvP+rLGDmdRaaKJsUW2eJ7TT4nNkeic=;
        b=ZNZHExdRFVZx7eTFjmQ6DRjcrihTLe0lN7v+AWRcRdiFWQLaPTSh1q5jNxPzosK9bN
         0Ry+IXM/4gvXUwHFP6+wwhUVNIhmoPaZ9QfkQJUFH8zZlQi15RpgOe0Wof7vjYj1ewgz
         f89qd/pYy6Ik+ehQrLBpz791amqPqLZN8wJWRUQUuuvVvXCzmVtvk8K1zQ7mDWhw6Uz+
         4H1EGGHrOPccD1htCSycNYR4nW7rchnedmPKR4yv+Hcxhqx5634MSxGv1mSQLKrZmAx1
         UQaFgCfEelpIf0NciC7hXliJxTX1sOr2MnSM+guWTGh+HqQKljdN7vXbEBf0Te7LxAHx
         yd7w==
X-Forwarded-Encrypted: i=1; AJvYcCURk+7r8fr/cIbmRkynmAwprJ5ZS8MpmSTPr6d+ruH3DdoLq9jYP33NLFK0PU2D8vIfvGoVWmY=@lists.linux.dev
X-Gm-Message-State: AOJu0Yz4ao4Do/cDOpy9pUgdc1tkwkVxLnl4wdvGzQKU320BxT6G6RHK
	A3qvzPZXaiV94LQ+ieYYR8/L4wC+7CXD8i4aV0X9mh5fGX2xZ4LnefHS5DmImidmp4qMjC4p4+/
	RW+jiUXSAOIxAD8/j8Z8lLtZN/Hvtp+TSTdAS3eTN
X-Gm-Gg: ASbGncuIB+D4F3ZIFtPI/+k5OPee3MCgU3VX2+q0yfmmA/y12zVLj38EyrZB5WJtoqq
	Y/sf30bbv0DxEyTAeBmsSoES/ZCHAfJ0wn7ukWL7zAV6jZNOGjKGaJ/uPXbOXPeEst73jfXMYob
	npaihjpCTxAgoQ4SWcP8+W0WCYC6GVv9zoziZfVOILI3NlcJNR+ity45cSU0pSM3L1VXVjH/9Y8
	kQiWo5Me19PFg==
X-Google-Smtp-Source: AGHT+IFRCkrKz78bGjmaIFeWp8YiNRQs+gQ3RqKlE9l/xpN9uHu6YMfPpX15Uq1Gd8ICjWbW7gPx2sIjphZmIWKg2ug=
X-Received: by 2002:a05:6000:1a89:b0:3ec:df5a:90d with SMTP id
 ffacd0b85a97d-40e4accc914mr2587039f8f.60.1758784275656; Thu, 25 Sep 2025
 00:11:15 -0700 (PDT)
Precedence: bulk
X-Mailing-List: syzbot@lists.linux.dev
List-Id: <syzbot.lists.linux.dev>
List-Subscribe: <mailto:syzbot+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:syzbot+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <68d4dfba.050a0220.25d7ab.0001.GAE@google.com>
In-Reply-To: <68d4dfba.050a0220.25d7ab.0001.GAE@google.com>
From: Aleksandr Nogikh <nogikh@google.com>
Date: Thu, 25 Sep 2025 09:11:01 +0200
X-Gm-Features: AS18NWAL5HEteY9CaZFrGLmvhOnsyvDgtJAesaDs9VdDsuD8e4kxD0rG1Gqm9X4
Message-ID: <CANp29Y7QwuTiN2OVdEJ1XgH58VwraZFrnouHEwGNi6k0jvCm-w@mail.gmail.com>
Subject: Re: [moderation/CI] Re: fixes two virtio-net related bugs.
To: syzbot ci <syzbot+ciaaef565a46ab8569@syzkaller.appspotmail.com>
Cc: syzkaller-upstream-moderation@googlegroups.com, syzbot@lists.linux.dev
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

#syz upstream

On Thu, Sep 25, 2025 at 8:22=E2=80=AFAM syzbot ci
<syzbot+ciaaef565a46ab8569@syzkaller.appspotmail.com> wrote:
>
> syzbot ci has tested the following series
>
> [v1] fixes two virtio-net related bugs.
> https://lore.kernel.org/all/20250925022537.91774-1-xuanzhuo@linux.alibaba=
.com
> * [PATCH net 1/2] virtio-net: fix incorrect flags recording in big mode
> * [PATCH net 2/2] virtio-net: correct hdr_len handling for VIRTIO_NET_F_G=
UEST_HDRLEN
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
> URL:       https://kernel.googlesource.com/pub/scm/linux/kernel/git/netde=
v/net.git
> base:      f8b4687151021db61841af983f1cb7be6915d4ef
> arch:      amd64
> compiler:  Debian clang version 20.1.8 (++20250708063551+0c9f909b7976-1~e=
xp1~20250708183702.136), Debian LLD 20.1.8
> config:    https://ci.syzbot.org/builds/bb3f28da-9370-44d7-be20-9c443d5eb=
fc9/config
> C repro:   https://ci.syzbot.org/findings/7af48589-24a5-4e09-bfe0-1969f5d=
98f4d/c_repro
> syz repro: https://ci.syzbot.org/findings/7af48589-24a5-4e09-bfe0-1969f5d=
98f4d/syz_repro
>
> syz.0.17 uses obsolete (PF_INET,SOCK_PACKET)
> ------------[ cut here ]------------
> WARNING: CPU: 0 PID: 6010 at ./include/linux/skbuff.h:3024 skb_transport_=
header include/linux/skbuff.h:3024 [inline]
> WARNING: CPU: 0 PID: 6010 at ./include/linux/skbuff.h:3024 skb_transport_=
offset include/linux/skbuff.h:3175 [inline]
> WARNING: CPU: 0 PID: 6010 at ./include/linux/skbuff.h:3024 virtio_net_hdr=
_from_skb+0x669/0xa30 include/linux/virtio_net.h:222
> Modules linked in:
> CPU: 0 UID: 0 PID: 6010 Comm: syz.0.17 Not tainted syzkaller #0 PREEMPT(f=
ull)
> Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS 1.16.2-debian-1.=
16.2-1 04/01/2014
> RIP: 0010:skb_transport_header include/linux/skbuff.h:3024 [inline]
> RIP: 0010:skb_transport_offset include/linux/skbuff.h:3175 [inline]
> RIP: 0010:virtio_net_hdr_from_skb+0x669/0xa30 include/linux/virtio_net.h:=
222
> Code: 00 00 00 fc ff df 0f b6 04 10 84 c0 0f 85 b0 03 00 00 41 c6 45 00 0=
5 48 8b 74 24 08 83 c6 08 e9 ca fd ff ff e8 c8 1c 72 f7 90 <0f> 0b 90 e9 a7=
 fa ff ff e8 ba 1c 72 f7 90 0f 0b 90 e9 62 fc ff ff
> RSP: 0018:ffffc90002def490 EFLAGS: 00010293
> RAX: ffffffff8a4da238 RBX: 1ffff11004dafca6 RCX: ffff888023c9b980
> RDX: 0000000000000000 RSI: 000000000000ffff RDI: 000000000000ffff
> RBP: 1ffff1100537cbd8 R08: ffff88804138e059 R09: 0000000000000000
> R10: ffff88804138e050 R11: ffffed1008271c0c R12: ffff888029be4000
> R13: ffff888026d7e536 R14: ffff888029be5ec4 R15: 000000000000ffff
> FS:  0000555557e59500(0000) GS:ffff8880b8615000(0000) knlGS:0000000000000=
000
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
> Code: ff ff c3 66 2e 0f 1f 84 00 00 00 00 00 0f 1f 40 00 48 89 f8 48 89 f=
7 48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 ff=
 ff 73 01 c3 48 c7 c1 a8 ff ff ff f7 d8 64 89 01 48
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
-upstream-moderation/68d4dfba.050a0220.25d7ab.0001.GAE%40google.com.
