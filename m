Received: from mail-oi2-f13.google.com (mail-oi2-f13.google.com [74.125.231.205])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8F8374A7C9C
	for <syzbot@lists.linux.dev>; Thu,  1 Oct 2026 20:41:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=74.125.231.205
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790887314; cv=pass; b=hUH1sSj0i6oip6M+3GK6mbt9cjIvheg7qLeYTeyHaPdq/Ogz/C3ZoI93ehZoQFmmbXxbG860n3hVLBeqeTJIATdvXHjk39PpzZ3jTNw/i2wLoA9b5Yp8+wGH3WPThFhqoPX7MYEoZ+Lhb48Ct/8WzyvQCmcFeJS9LaHFzBvtoHY=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790887314; c=relaxed/simple;
	bh=4Wp3NTCRSjqNqfAS6qcMTPaFQh/ptARR00OYPzZnzek=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=XcMS3pR4EuZ4a7pP0c+jY/chBr3hOC0kIzeYQlyAAqbFjCcarubqtAUCSuC/aMpc236gr33aRIpjcoTmkdwC4d5aXHyLbzbFUg7rSX5JW2i3FdSz4iXKbwj/5POJeuzwpLpi4Gwrh01B11bxS58TG7gAv9g+TpPMfVDU9kX/t/M=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=rkSztzDN; arc=pass smtp.client-ip=74.125.231.205
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="rkSztzDN"
Received: by mail-oi2-f13.google.com with SMTP id 5614622812f47-4c4923c9429so3416815b6e.1
        for <syzbot@lists.linux.dev>; Thu, 01 Oct 2026 13:41:45 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1790887300; cv=none;
        d=google.com; s=arc-20260327;
        b=RltE/iZNGzLEsWRluF/WVVqWPcBs/HkSkGOzEY6W9ukJAghGWWXA+OgfnVlCqFqkej
         55CI7ZlYBzw8Z1x7MPqXCVMgdVqoG0Lqvmxj6jMCEkGUhz00x5UKpLazJt2XLxKbUwlE
         055OMrM9LUJAT4FoYUKZLCq8tAHjC+72O6FXIITD5Pp4EZT/+TsD3MK/6o3yc1B/rB0t
         Kjj5He/HESFOawmjazVMpHR2+Pkkg3ohcSG/HfjtF5fCBh37YcmHbdoaEi9hP12cZiRw
         C86sch3sfF+xku70TnMYcO0rsYpb8IQSI1fui/Hio1KkYXXTs1W6rFajMZr73BdXtmV6
         u75g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=pWiIk5M5EeMLv06FCFBKPFWWHjYZk+Jygq95Sah33GY=;
        fh=V8UZpX0E85Ul6nK1//zhj7vOZ3SieLDjDWjn3hIrO3Y=;
        b=P40BldB+CsiAYDOFK7bCTkSmRlUfwF4+1ZQfEQciMka0wr71rmgGsBYqTabqrugJJz
         LAnWHJfX4F0ZnhhW21XKuWaW1EgpBhpqKzpHO4rla9PPN0oiei5A5T868QwEoTe5xMru
         2rO17/VYAY9SBsMd+6kfUnJCJJMNcQwwRR7GI2hZcN0/LMjoXaisji8asFbsdvyhKVaN
         Y8Xasa5+MvGQ1jc+g4u1H8LqiFbJZCGagbDUP7COe781RfApKkX/UktQrSB7CtmXSgy/
         OdIduY98C6Key8YMPgPOTG8EzlxGd6AIwgpWyXZ1C5pPMokS3OxYmqIoXmjJvrpZFNha
         xfSg==;
        darn=lists.linux.dev
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1790887300; x=1791492100; darn=lists.linux.dev;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=pWiIk5M5EeMLv06FCFBKPFWWHjYZk+Jygq95Sah33GY=;
        b=rkSztzDNl0WCUty8++C8GWjTWtdaOaoCGlg6vAufiOIXuFKw7/GSicgV5w92bmfatW
         D42UulLJCoCJ0FH6vOhQjVN/SdYQlFlLh4hhY+v7mpEe8rgWiZ2GnjjgUihTd9/Q2Zke
         0yClFL7hkle2q+0djOhJj/EAqROOX03oNzsBJhQQgZyvHYCmCLiS2odr2Q8leedcvBhv
         NIFYUdwK/eOiH3alMhiPWWSzOhZXcr1F4ssLKKBUWRahaWTfwvD3fjar7KjQ7znRTKtf
         euDJ7gCuFgMxa4jdJXjkXr2WzuTo9c/XxSBvNJzBi3WcbAAkXl08Rmdr1xrhLBi3Z3LL
         unIQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1790887300; x=1791492100;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=pWiIk5M5EeMLv06FCFBKPFWWHjYZk+Jygq95Sah33GY=;
        b=TFvci74qtqGYaquNa5B8aR3yD1sXuPkvgRgW3tb2A7/GumkcmJmF6wTe6M2PqR+J5O
         EmI2ScTwrJ0gxCH+CKjZLHXzrd1K2yrSpWBs3hi1o5SkbANDMEUk717PS0zmiNKWl5ST
         puYaJoJhiBj4SbfR7JubZZ+Wt10wlTpcjwdH/Wj62vyUDHcyqgHxvUjPzpfE28SCJvn/
         ljx+eoCmvZ0gIIrgwN78tV99RA6sGuPpOqRwhM6Lj1Jc1B0pSWgNjSZ2WR0nA8smdl1+
         LAD0RZ+X0SmQYUer7pJlQPR8W3fHReIPtWatSEREI5BchRWH5i32P5kFvjTeTJqEl7HH
         UiPg==
X-Forwarded-Encrypted: i=1; AKwUvBwdWvVAk1whZjIFQFg/FTV5EH0nL+XPgceFPT0YGF7REtfmfhyNmmyXFJhDJSIW/Q6CekByrHA=@lists.linux.dev
X-Gm-Message-State: AFuF++numYXp/XsX5MklSZwmf6faEygGByiDl1Ry9QPIyadmUv0OLHt7
	OFt9hfn/DdaKxghAn9SzNGHeNWPYqalatfB0RdYfwMvhXI4eAcQ9vusPFrAuKhskBIVkKjXBFNb
	NBeO4J8Tf2EjEaWKNmyoHsy6Za2B8+pOGtK2WkxYn
X-Gm-Gg: AYBFou0DAUvUm7qBSt+EURhU4tDJ3ibpe8aGV3fwIWU+h96j7JX5w9CP6qQTD3dhUol
	R2YnBFdYFsLxJi9ueZ6wl7hDb0VSqA8CE3C14lFYtOcPbbycMOv00UYYBpRMxBLKz+ilhslaCQl
	3o5doOMjVxq5uiZp2cK9qgL1MZaMIWHQjFOoPzJ5lLEO8pxPYo74ntvCulAUjTePZ9hcDZY/ulg
	s3KlAPJf7wkizCQqEnBtyhYcWahByh+TB6H90fW4LTi2c867fEXoZnhNy9eeH46Ei9OwcWWkdni
	qM7xaHH48MtneP0v1p6rNCRHInz+PCVCJFzNJFHHjlUP+8bHe1SJ8RRlGNXJjzWPkhvDnU1DaL0
	Hu5YcfBcIQUEmhLziWy8dkSZBjI6PwXejLNBt7Sl0KmmuYvBii+Dpfuhy5r+yXHl3YUstb8gZHK
	/l+MQl6S0/fzyV66wWw6huxO+bPQ==
X-Received: by 2002:a05:6808:6507:b0:4e8:e664:f268 with SMTP id
 5614622812f47-4f5294ff29bmr334767b6e.25.1790887299478; Thu, 01 Oct 2026
 13:41:39 -0700 (PDT)
Precedence: bulk
X-Mailing-List: syzbot@lists.linux.dev
List-Id: <syzbot.lists.linux.dev>
List-Subscribe: <mailto:syzbot+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:syzbot+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <6abec21b.092aa46d.14d54.0005.GAE@google.com>
In-Reply-To: <6abec21b.092aa46d.14d54.0005.GAE@google.com>
From: Aleksandr Nogikh <nogikh@google.com>
Date: Thu, 1 Oct 2026 22:41:28 +0200
X-Gm-Features: AclHuK-3sBpgcFTsQ4rSxzUGiRer1jA65ATruZOxgy-GBDWgjA71NtxdObVr1Tg
Message-ID: <CANp29Y66SA-yazQjvEcEFZE1-pBtfT7xsAwUssRv2pp+wemaOg@mail.gmail.com>
Subject: Re: [moderation/CI] Re: ipv6: route: fix adding routes via the
 loopback device
To: syzbot ci <syzbot+ci29028947805739bf@syzkaller.appspotmail.com>
Cc: syzkaller-upstream-moderation@googlegroups.com, syzbot@lists.linux.dev
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

#syz upstream


On Thu, Oct 1, 2026 at 10:27=E2=80=AFPM syzbot ci
<syzbot+ci29028947805739bf@syzkaller.appspotmail.com> wrote:
>
> syzbot ci has tested the following series
>
> [v1] ipv6: route: fix adding routes via the loopback device
> https://lore.kernel.org/all/20260930152229.1453929-1-hengyul@cs.unc.edu
> * [PATCH net 1/2] ipv6: route: do not validate nexthop of routes promoted=
 to reject routes
> * [PATCH net 2/2] selftests: net: fib_tests: add tests for IPv6 routes vi=
a loopback device
>
> and found the following issue:
> WARNING in nsim_fib_event_nb
>
> Full report is available here:
> https://ci.syzbot.org/series/7c566bff-eca1-4b49-90ae-6537c6011730
>
> ***
>
> WARNING in nsim_fib_event_nb
>
> tree:      net
> URL:       https://kernel.googlesource.com/pub/scm/linux/kernel/git/netde=
v/net.git
> base:      e23a64eb244356ee47c0620f0722d51bd88db522
> arch:      amd64
> compiler:  Debian clang version 22.1.8 (++20260613092233+e80beda6e255-1~e=
xp1~20260613092250.77), Debian LLD 22.1.8
> config:    https://ci.syzbot.org/builds/ef50b46f-5dab-4a9c-943a-321047ec0=
627/config
> syz repro: https://ci.syzbot.org/findings/96331068-e137-4de8-85a3-65ac3ca=
afea0/syz_repro
>
> ------------[ cut here ]------------
> i !=3D fen6_info->nsiblings
> WARNING: drivers/net/netdevsim/fib.c:831 at nsim_fib6_event_init drivers/=
net/netdevsim/fib.c:831 [inline], CPU#1: syz.2.19/5834
> WARNING: drivers/net/netdevsim/fib.c:831 at nsim_fib6_prepare_event drive=
rs/net/netdevsim/fib.c:947 [inline], CPU#1: syz.2.19/5834
> WARNING: drivers/net/netdevsim/fib.c:831 at nsim_fib_event_schedule_work =
drivers/net/netdevsim/fib.c:1003 [inline], CPU#1: syz.2.19/5834
> WARNING: drivers/net/netdevsim/fib.c:831 at nsim_fib_event_nb+0x1029/0x11=
d0 drivers/net/netdevsim/fib.c:1043, CPU#1: syz.2.19/5834
> Modules linked in:
> CPU: 1 UID: 0 PID: 5834 Comm: syz.2.19 Not tainted syzkaller #0 PREEMPT(f=
ull)
> Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS 1.16.2-debian-1.=
16.2-1 04/01/2014
> RIP: 0010:nsim_fib6_event_init drivers/net/netdevsim/fib.c:831 [inline]
> RIP: 0010:nsim_fib6_prepare_event drivers/net/netdevsim/fib.c:947 [inline=
]
> RIP: 0010:nsim_fib_event_schedule_work drivers/net/netdevsim/fib.c:1003 [=
inline]
> RIP: 0010:nsim_fib_event_nb+0x1029/0x11d0 drivers/net/netdevsim/fib.c:104=
3
> Code: eb 0d 4d 89 fd e8 97 75 6e fa be 01 00 00 00 48 89 df e8 aa db 85 f=
d 4d 89 ef 4c 8b 6c 24 20 e9 4a f3 ff ff e8 78 75 6e fa 90 <0f> 0b 90 e9 db=
 fa ff ff 89 e9 80 e1 07 80 c1 03 38 c1 0f 8c df f0
> RSP: 0018:ffffc9000388f030 EFLAGS: 00010293
> RAX: ffffffff87596688 RBX: 0000000000000001 RCX: ffff88816f738000
> RDX: 0000000000000000 RSI: 0000000000000001 RDI: 0000000000000000
> RBP: ffffc9000388f1c0 R08: ffff88816ecf302f R09: 1ffff1102dd9e605
> R10: dffffc0000000000 R11: ffffed102dd9e606 R12: dffffc0000000000
> R13: 0000000000000001 R14: 0000000000000000 R15: ffff8881be596000
> FS:  00007f94438b96c0(0000) GS:ffff8882a8cca000(0000) knlGS:0000000000000=
000
> CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> CR2: 00007f94429eb840 CR3: 000000016e632000 CR4: 00000000000006f0
> Call Trace:
>  <TASK>
>  notifier_call_chain+0x1a5/0x3d0 kernel/notifier.c:85
>  atomic_notifier_call_chain+0xda/0x180 kernel/notifier.c:223
>  call_fib_notifiers+0x31/0x60 net/core/fib_notifier.c:36
>  call_fib6_multipath_entry_notifiers+0xf5/0x160 net/ipv6/ip6_fib.c:428
>  ip6_route_multipath_add net/ipv6/route.c:5591 [inline]
>  inet6_rtm_newroute+0x14f5/0x1a30 net/ipv6/route.c:5713
>  rtnetlink_rcv_msg+0x802/0xc00 net/core/rtnetlink.c:7137
>  netlink_rcv_skb+0x226/0x4a0 net/netlink/af_netlink.c:2575
>  netlink_unicast_kernel net/netlink/af_netlink.c:1338 [inline]
>  netlink_unicast+0x7bd/0x940 net/netlink/af_netlink.c:1364
>  netlink_sendmsg+0x813/0xb40 net/netlink/af_netlink.c:1919
>  sock_sendmsg_nosec+0x13a/0x180 net/socket.c:800
>  __sock_sendmsg net/socket.c:815 [inline]
>  ____sys_sendmsg+0x54e/0x850 net/socket.c:2713
>  ___sys_sendmsg+0x2a5/0x360 net/socket.c:2767
>  __sys_sendmsg net/socket.c:2799 [inline]
>  __do_sys_sendmsg net/socket.c:2804 [inline]
>  __se_sys_sendmsg net/socket.c:2802 [inline]
>  __x64_sys_sendmsg+0x1b1/0x290 net/socket.c:2802
>  do_syscall_x64 arch/x86/entry/syscall_64.c:61 [inline]
>  do_syscall_64+0x166/0x520 arch/x86/entry/syscall_64.c:84
>  entry_SYSCALL_64_after_hwframe+0x77/0x7f
> RIP: 0033:0x7f944299e159
> Code: ff c3 66 2e 0f 1f 84 00 00 00 00 00 0f 1f 44 00 00 48 89 f8 48 89 f=
7 48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 ff=
 ff 73 01 c3 48 c7 c1 e8 ff ff ff f7 d8 64 89 01 48
> RSP: 002b:00007f94438b9028 EFLAGS: 00000246 ORIG_RAX: 000000000000002e
> RAX: ffffffffffffffda RBX: 00007f9442c25fa0 RCX: 00007f944299e159
> RDX: 0000000004000040 RSI: 0000200000000000 RDI: 0000000000000003
> RBP: 00007f9442a3506b R08: 0000000000000000 R09: 0000000000000000
> R10: 0000000000000000 R11: 0000000000000246 R12: 0000000000000000
> R13: 00007f9442c26038 R14: 00007f9442c25fa0 R15: 00007ffdb2cbb968
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
> To test a fix for this bug, please reply with `#syz test`
> (on a separate line) and attach the patch to the email.
>
> Notes:
> - The patch will be applied on top of the tested series (as an
>   incremental fix).
> - To test a new version of the whole series, please send it directly
>   to syzbot@lists.linux.dev.
> - Arguments like custom git repos and branches are not supported.
>
> The email will later be sent to:
> [davem@davemloft.net dsahern@kernel.org edumazet@kernel.org hengyul@cs.un=
c.edu horms@kernel.org idosch@nvidia.com jiayuan.chen@linux.dev jiayuan.che=
n@shopee.com kuba@kernel.org linux-kernel@vger.kernel.org linux-kselftest@v=
ger.kernel.org netdev@vger.kernel.org pabeni@redhat.com shuah@kernel.org st=
able@vger.kernel.org]
>
> If the report looks fine to you, reply with:
> #syz upstream
>
> If the report is a false positive, reply with
> #syz invalid
>
> --
> You received this message because you are subscribed to the Google Groups=
 "syzkaller-upstream-moderation" group.
> To unsubscribe from this group and stop receiving emails from it, send an=
 email to syzkaller-upstream-moderation+unsubscribe@googlegroups.com.
> To view this discussion visit https://groups.google.com/d/msgid/syzkaller=
-upstream-moderation/6abec21b.092aa46d.14d54.0005.GAE%40google.com.
