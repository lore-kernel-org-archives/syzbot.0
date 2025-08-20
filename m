Received: from mail-pl1-f170.google.com (mail-pl1-f170.google.com [209.85.214.170])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8EF07156F5E
	for <syzbot@lists.linux.dev>; Wed, 20 Aug 2025 13:48:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.170
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755697726; cv=none; b=Atf3ZtLjBsRvMYRUDvJnOvAEgogZPzO3RgyZvjfmaNTkSCB/E6ilulKHeuAYrOeOF9brhxdYi5DoUghZPjmoEmfpHcpOqgG4C4Jtq5sUJ6PNbeVV2alURhPR/BSynzJAS9kSf5Agp9TPx78y0WVO+S2NduFaLnH1P/og0cV8ZBk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755697726; c=relaxed/simple;
	bh=X3gjSLSnVIbVgXppRDAQYlBkepRZvsugfS84KskugDw=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=trEgEiOgR/SEfOIZFKqcPTFGgmwnxDEWm7tq6oT6QObpVxQtBwBlraVuPDCuwIarCZVO9xBqE/qOPYdoFHiNgGji5DRmwh4wmR5QSSmQNU8DBwt1+LYRTRgcl3ujPrupHiH0of6XV5UinCMC2ZbZC9yCZdxK1n/dWzD8JJ739/M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=jOFN/HZS; arc=none smtp.client-ip=209.85.214.170
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="jOFN/HZS"
Received: by mail-pl1-f170.google.com with SMTP id d9443c01a7336-245f19a324bso5406785ad.0
        for <syzbot@lists.linux.dev>; Wed, 20 Aug 2025 06:48:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1755697723; x=1756302523; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=OfepP/MFrrImBj+tvP+kedCSSw/T+PsaSs1xEsrC3fs=;
        b=jOFN/HZSzfQg+jQFm+F0CA/n0+FVEcb8H0/H1aZuLPW/jMNP37fTYZCSW+NDZ9QIM6
         V9jI5jcZH8ZGBLsaAO+C0C0JQf+H5XgIEBLYoT4Cx/savoTz0imNnA48g9OFfP67Z6yC
         Q//q5H6CCP17U1uWSkEW+m4fB8dJizAhcbIZwpTiDlem7B48ay+ChpaEB+OcKi41Zbmt
         VEFbaJNIrrrtFznolaIXSNAwxy1nMZd5R4xDblQ3aq7ikCZVf+Y+HQq6BO0FNyZryfEU
         URenNBsbWyhlG9fRx9HJCEmK8TCyqMF+bzm1IFLn0sXmUJTW/1IQg9kPgNt5wCRkOmg7
         sTLw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1755697723; x=1756302523;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=OfepP/MFrrImBj+tvP+kedCSSw/T+PsaSs1xEsrC3fs=;
        b=twQekms7kp+2iw9E95x+fVFNpSaVQ21TFzb9WSX2qwTv34+uLiFLIZ345xkhL6sML2
         q8ZT8lD1KmeoWpwR016nl9rKjtnZj8xs/XdCfg7glLajT5QFdxUJOHfMHXzFOE4Ot7eu
         CLDDqT1BIgvE8IMHXKwjinkimYToxDjUfl8JzOOstqEAzM8TQV1tUW6sDTYLMEqr3ojY
         XMfF51t5IAsnaYrLGCjZz4KfU0R+hTQRIQwhC/rwlV7jXx40npxu3irTxyPkG+/bftyX
         56iKekjtk4WIcmsT1tlm7EV6AhdcSivwnzvRGeoVcRDCCyU6RV2Y/Qc6x2Ns+QGMBdqk
         No3A==
X-Forwarded-Encrypted: i=1; AJvYcCVAa5RrxE399bG4BTGHHkCP0rsxjF0G7HZP3GdRtS/h1OpIh12yJlFDAt68e1bzO6a6hob59UI=@lists.linux.dev
X-Gm-Message-State: AOJu0YziLB3aChl6mEdjigdIm7Wve2iOz34zRSAii4VuGKExRUMFKB0Y
	UNNSK95EGRJFWsLBsAVo0zlzZFe9wyebgosAL7Nn/dy5kuvYRRq1mYoBI6RKX4f1Y5JMjPxRUtv
	Rn7avbVgUKUFfQXmEJHF505D01hpcYFM6lN8T21of
X-Gm-Gg: ASbGncv0boxLhAUN4PKGEU+5ycXcLl92RdxMaDXCr/gDysC+RQXPFKc2YNVfcjK2VsR
	x3q0ILOz32SYlecJY7zXXJrtqt3iXpQeArKX3KlXoSFjLsyI7u8hfzaVyByYaa5aH5UBVjVAd9U
	Z0MIS34IIjH++jgNtwo5S9CCiDGqbfXR1xNVD/ujDy6D0URb99sX0bKWnQoLqgIBBR7zrEfeF/K
	6ZKGUWuszO6q/AfoEYPfMKVz/xYMrd2t/TMyI4xrsSuvg58tYtw7i1PpfVxsWKweQ==
X-Google-Smtp-Source: AGHT+IEV/PXDfTkZoxfMjbGhsLtf9Z5r766BAmw6daTBlPL5fvclwO7PFwRqTgNDpYTSdcKw6m8BsvEfuShZNeXQZpk=
X-Received: by 2002:a17:903:1c7:b0:242:9d61:2b60 with SMTP id
 d9443c01a7336-245ef0b7e4dmr35317685ad.6.1755697722483; Wed, 20 Aug 2025
 06:48:42 -0700 (PDT)
Precedence: bulk
X-Mailing-List: syzbot@lists.linux.dev
List-Id: <syzbot.lists.linux.dev>
List-Subscribe: <mailto:syzbot+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:syzbot+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <68a5d004.050a0220.3d78fd.0002.GAE@google.com>
In-Reply-To: <68a5d004.050a0220.3d78fd.0002.GAE@google.com>
From: Aleksandr Nogikh <nogikh@google.com>
Date: Wed, 20 Aug 2025 15:48:30 +0200
X-Gm-Features: Ac12FXwlKRK6ZOoCH9eGTQF4ggJYUxGNF780xR8cWJbdoNsHbbZhqSCWuI3mAro
Message-ID: <CANp29Y58T0LEp7mXHBGN7X6O-oZKxL9qiZL+n92A=s73x_qGeA@mail.gmail.com>
Subject: Re: [moderation/CI] Re: net: af_packet: Use hrtimer to do the retire operation
To: syzbot ci <syzbot+ci1b055c1c5811b39f@syzkaller.appspotmail.com>
Cc: syzkaller-upstream-moderation@googlegroups.com, syzbot@lists.linux.dev
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

#syz upstream

On Wed, Aug 20, 2025 at 3:39=E2=80=AFPM syzbot ci
<syzbot+ci1b055c1c5811b39f@syzkaller.appspotmail.com> wrote:
>
> syzbot ci has tested the following series
>
> [v6] net: af_packet: Use hrtimer to do the retire operation
> https://lore.kernel.org/all/20250820092925.2115372-1-jackzxcui1989@163.co=
m
> * [PATCH net-next v6] net: af_packet: Use hrtimer to do the retire operat=
ion
>
> and found the following issue:
> WARNING in hrtimer_forward
>
> Full report is available here:
> https://ci.syzbot.org/series/81b08fd6-a740-4520-9c88-b7dcdc7953a1
>
> ***
>
> WARNING in hrtimer_forward
>
> tree:      net-next
> URL:       https://kernel.googlesource.com/pub/scm/linux/kernel/git/netde=
v/net-next.git
> base:      da114122b83149d1f1db0586b1d67947b651aa20
> arch:      amd64
> compiler:  Debian clang version 20.1.7 (++20250616065708+6146a88f6049-1~e=
xp1~20250616065826.132), Debian LLD 20.1.7
> config:    https://ci.syzbot.org/builds/0ebac6ed-b7ae-4c3d-9edc-db3a521ad=
7a0/config
> C repro:   https://ci.syzbot.org/findings/c3421800-7bbc-4097-a1cf-36e97a4=
dea98/c_repro
> syz repro: https://ci.syzbot.org/findings/c3421800-7bbc-4097-a1cf-36e97a4=
dea98/syz_repro
>
> ------------[ cut here ]------------
> WARNING: CPU: 1 PID: 6012 at kernel/time/hrtimer.c:1052 hrtimer_forward+0=
x1d6/0x2b0 kernel/time/hrtimer.c:1052
> Modules linked in:
> CPU: 1 UID: 0 PID: 6012 Comm: syz.0.20 Not tainted syzkaller #0 PREEMPT(f=
ull)
> Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS 1.16.2-debian-1.=
16.2-1 04/01/2014
> RIP: 0010:hrtimer_forward+0x1d6/0x2b0 kernel/time/hrtimer.c:1052
> Code: 4c 89 33 48 8b 04 24 eb 07 e8 66 30 12 00 31 c0 48 83 c4 18 5b 41 5=
c 41 5d 41 5e 41 5f 5d e9 01 b0 ce 09 cc e8 4b 30 12 00 90 <0f> 0b 90 eb df=
 48 89 e8 4c 09 f8 48 c1 e8 20 74 0a 48 89 e8 31 d2
> RSP: 0018:ffffc900029def90 EFLAGS: 00010293
> RAX: ffffffff81ad7be5 RBX: ffff888028782648 RCX: ffff88810e88d640
> RDX: 0000000000000000 RSI: 0000000000000001 RDI: 0000000000000000
> RBP: 000000000000116b R08: ffffffff8fa37e37 R09: 1ffffffff1f46fc6
> R10: dffffc0000000000 R11: ffffffff81724e10 R12: ffff888028782660
> R13: 00000000007a1200 R14: 1ffff110050f04cc R15: 0000000000000001
> FS:  000055555f6cd500(0000) GS:ffff8881a3c1c000(0000) knlGS:0000000000000=
000
> CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> CR2: 00007ffcf1be3d88 CR3: 0000000023c86000 CR4: 00000000000006f0
> Call Trace:
>  <TASK>
>  hrtimer_forward_now include/linux/hrtimer.h:366 [inline]
>  _prb_refresh_rx_retire_blk_timer net/packet/af_packet.c:697 [inline]
>  prb_open_block+0x3a7/0x5e0 net/packet/af_packet.c:930
>  prb_dispatch_next_block net/packet/af_packet.c:994 [inline]
>  __packet_lookup_frame_in_block net/packet/af_packet.c:1152 [inline]
>  packet_current_rx_frame net/packet/af_packet.c:1178 [inline]
>  tpacket_rcv+0x1229/0x2f40 net/packet/af_packet.c:2409
>  deliver_skb net/core/dev.c:2472 [inline]
>  deliver_ptype_list_skb net/core/dev.c:2487 [inline]
>  __netif_receive_skb_core+0x3107/0x4020 net/core/dev.c:5923
>  __netif_receive_skb_list_core+0x23f/0x800 net/core/dev.c:6054
>  __netif_receive_skb_list net/core/dev.c:6121 [inline]
>  netif_receive_skb_list_internal+0x975/0xcc0 net/core/dev.c:6212
>  netif_receive_skb_list+0x54/0x450 net/core/dev.c:6264
>  xdp_recv_frames net/bpf/test_run.c:280 [inline]
>  xdp_test_run_batch net/bpf/test_run.c:361 [inline]
>  bpf_test_run_xdp_live+0x1786/0x1b10 net/bpf/test_run.c:390
>  bpf_prog_test_run_xdp+0x713/0x1000 net/bpf/test_run.c:1322
>  bpf_prog_test_run+0x2c7/0x340 kernel/bpf/syscall.c:4590
>  __sys_bpf+0x581/0x870 kernel/bpf/syscall.c:6047
>  __do_sys_bpf kernel/bpf/syscall.c:6139 [inline]
>  __se_sys_bpf kernel/bpf/syscall.c:6137 [inline]
>  __x64_sys_bpf+0x7c/0x90 kernel/bpf/syscall.c:6137
>  do_syscall_x64 arch/x86/entry/syscall_64.c:63 [inline]
>  do_syscall_64+0xfa/0x3b0 arch/x86/entry/syscall_64.c:94
>  entry_SYSCALL_64_after_hwframe+0x77/0x7f
> RIP: 0033:0x7f31da38ebe9
> Code: ff ff c3 66 2e 0f 1f 84 00 00 00 00 00 0f 1f 40 00 48 89 f8 48 89 f=
7 48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 ff=
 ff 73 01 c3 48 c7 c1 a8 ff ff ff f7 d8 64 89 01 48
> RSP: 002b:00007ffcf1be5358 EFLAGS: 00000246 ORIG_RAX: 0000000000000141
> RAX: ffffffffffffffda RBX: 00007f31da5b5fa0 RCX: 00007f31da38ebe9
> RDX: 0000000000000050 RSI: 0000200000000600 RDI: 000000000000000a
> RBP: 00007f31da411e19 R08: 0000000000000000 R09: 0000000000000000
> R10: 0000000000000000 R11: 0000000000000246 R12: 0000000000000000
> R13: 00007f31da5b5fa0 R14: 00007f31da5b5fa0 R15: 0000000000000003
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
> [davem@davemloft.net edumazet@google.com ferenc@fejes.dev horms@kernel.or=
g jackzxcui1989@163.com kuba@kernel.org linux-kernel@vger.kernel.org netdev=
@vger.kernel.org pabeni@redhat.com willemdebruijn.kernel@gmail.com]
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
-upstream-moderation/68a5d004.050a0220.3d78fd.0002.GAE%40google.com.
