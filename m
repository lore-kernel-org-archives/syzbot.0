Received: from mail-oo2-f43.google.com (mail-oo2-f43.google.com [74.125.231.171])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 51BC53016F1
	for <syzbot@lists.linux.dev>; Mon, 21 Sep 2026 03:22:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=74.125.231.171
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789960922; cv=pass; b=XCQk6XEIQH0FzZFMEyISxgCy+i22gdygkSrUZJfugB3/o08S3XnXul97bGPQzRlzlc81a3GvI8KxCCN/E441ZpV3E7DVu4C5thV80UZfHeBYOv9dOHNJhnAcu7G0KmPxd+41DATk4A3Is6OOHxoV9LW51A6XKNot4qoC1HeScR4=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789960922; c=relaxed/simple;
	bh=eGju8VLXtLV6i718vE5yWuyZSh4z9clYNGBydWAjsos=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=lMrodtFp+jD3bdaBfTTY0Sk0vYW8kYfQos+Q7Ny/2NQj4EIjh8TtR7WQd3umpTat//IZzIkilHD/ca7wp/bN2yOVhR8rsUEV2lqMQEdp0JFataIM2FMsMmE49zpTlFVKHaQcMAt0VfFNsMTBlvlsqwHkMYZSCcMNCo+FI3QI5X4=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=o97x5zGm; arc=pass smtp.client-ip=74.125.231.171
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="o97x5zGm"
Received: by mail-oo2-f43.google.com with SMTP id 006d021491bc7-6b1ae6c9b72so318609eaf.0
        for <syzbot@lists.linux.dev>; Sun, 20 Sep 2026 20:22:00 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1789960919; cv=none;
        d=google.com; s=arc-20260327;
        b=Zv6X7R3w7KvRaE4zwrmcmdPHwPoObJlsh13s9t23u/FIfwfxd7gh1I6WcwPUu9Q0nb
         UQNwR4XUlQVYpVelX42q0AMqTR0P3Wf82Ys7wuDrvuTp7SXtkji36PUHceR8EqUDJPwZ
         wEmVpcAxvP8iG0Z23KN3d74TgsOrTu/QSka+1KKVRhpkIQTozVArRFCdmr1tgAiEkUuz
         /0Sq57ahSgeWWYeK68F6tZad5TlvckLFN7f8ZPCCl0sk4Ddj77Sx5GMyVSUSqct3nmu2
         awrAYe0ci0rg8w4yXiFRMAwfV8ofasG89kkNds/46ap3rOqBSk5VfCTRMCjshasfXFXR
         Rf5Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=cQH/KbHuhd1229vB7nNczo0K4xt/QV3k9ojDRREzIfU=;
        fh=Q654XdA9oddX2hZO2qDuXR4BfBx2Pi08kpOby5wOb9w=;
        b=hmR21Ob7vAlbrpcqW771ThNO01ZYCSYJNPpW47lOlIhLz4N3P7OyyYhsCccmMQFTEt
         4Fr5rtyrZHJuiuJ530GxyiJPr4lFG91PMKCBbFLHGMPkuMGlOzq7qUb8Na0Sj/5LztRA
         V0p7L2XrzKx0SRB1q4CEKz4DbAH3KhjKv+7J2glLCbnn8qWjAujPLzkzq0Atfq5++wn4
         gL66S3PxQXJzcsLZ5MfjLlZqTfCJ/zZex716A+6pQfDb3lk0EWdXhAxrKLQTTxsy4+4s
         XAJdCwGoxaLRbx7cQCT88C91j4iAytMPh69r1m78zxYTppVN+4RiqmLAFvxGkaTL/VG+
         Aqrw==;
        darn=lists.linux.dev
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1789960919; x=1790565719; darn=lists.linux.dev;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=cQH/KbHuhd1229vB7nNczo0K4xt/QV3k9ojDRREzIfU=;
        b=o97x5zGm2Fhen4N/9C+1mua5kJFkPissQcGxwjKq3oJ8yyrHS/1lUaJQIyTSXnUq7/
         jdoYFBwO154TUigZ8vM8MUdMNF+YupH+JziVJrpzyBg3mY9fmJfJBxweKzKe2bVRaq36
         kK8cRDfWpYGUagqxxoBfKCXAcb9TTdr06sZPLAKPKqgdP8lm39VcUEXW/HXGdDjQbX/J
         WKrGy+RXrd0+X9n8cCN5mfuKTm+8tms89izMtpYu0bXOaPIUK+1FUJiS9ELC5uIS3Iv3
         FUjtNW+GyHbd1KwupBFhweeiKPLuR8s27WxnmMlemvl9wrznLApD1ZC04wnl30bEe301
         GM8w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1789960919; x=1790565719;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=cQH/KbHuhd1229vB7nNczo0K4xt/QV3k9ojDRREzIfU=;
        b=Y7hS002MXwwahQfuTrAO/Tkocx0SZORUh3giU/bEMdY00PEwL7Y0iXEvSqs5xKCbjE
         jt6hVzE+HZzwMGscvHUwAqb0PNLOo8T/0UDEUQd4hfRPlzn0aE/Au2R3kR5iBCJy7koa
         7eN3Qf5kW62EwoQrrXOB2zqEIxkmBWkUxrNLhS4WpjruBaWHAG6dEHaZprBrLPmSuMNL
         ceUp6Uq6QGswXT/ZXIyhtOarJTtttgjAfF/3pMgDTkiVPlA6cqZmJXDLqUVhzVZA4B21
         l4zZn8AVr97c8MKCVv0GVe/bpeta4ckq1ddU0u3541rtzDPu8YryCi8NV+ljS/DM13/1
         Vb3g==
X-Forwarded-Encrypted: i=1; AKwUvByzO28IbgRe1IU8jpZmDY0Y6KZN3axy0D4qp2bM6FFE4ex3mUzMFJ4q8XXlrjNZhXCFxzaaRXk=@lists.linux.dev
X-Gm-Message-State: AFuF++nUpBOUEuH4Z9lB6o/x6SqNwUy+oTaAWHYRHgagj/tGKg79+eby
	twD0OfAqaz/SrT8gy9JdS56CmmvBz+b82ilVKvn/Pd2D0qy7XkDaAawlqFXTsC5ZzAuz4f5sSrh
	VRL4UQV0A8lBIJcNhiCw5l2SDLr82PsNfEMkQatj3PDaDnEqRsSb2b6VA
X-Gm-Gg: AYBFou065DzG9jL9S8wXjCfsB5jd3JZ+X7nFzyjkpw84gxUHvbxtjEhg2ylhsCNaent
	7DWTQCuPExLh1lchEYAcmbfhZDACMyNX+rFdlUYVwyyuGvWvaWWpmapAG16dve5CfWG40L+QsdX
	Tb/1tJPwAXakXwSII1zWnZH076Q1F1xr45lTidKnrPMDPZMgg+bvrrmRxZuEP4LBfscWZEtGnd/
	sraBTThrWWiKFvw9MiqVQE9ItBmJi7iGey9eB3m2xnoYSAh3qSLdoINq0TlskALnNKiOvZC0Iur
	GrXjKGzjXbs9fdPnTsiP2LOPBmBm0A4Xs95jwKfYz6Z0Cy2BC+uDW3qBeIhvOyJWOW6+S1IlM20
	/U3cBL9P9FWruEr9b8DQgYCjuwd41BwxQHrifNGncZhHBmPMJWMsXkHaUtTFOf80qTeh2
X-Received: by 2002:a4a:e908:0:b0:6c2:1f92:2447 with SMTP id
 006d021491bc7-6ca934d2b2emr7105673eaf.26.1789960918460; Sun, 20 Sep 2026
 20:21:58 -0700 (PDT)
Precedence: bulk
X-Mailing-List: syzbot@lists.linux.dev
List-Id: <syzbot.lists.linux.dev>
List-Subscribe: <mailto:syzbot+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:syzbot+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <6ab0a06e.514bccd6.255447.000c.GAE@google.com>
In-Reply-To: <6ab0a06e.514bccd6.255447.000c.GAE@google.com>
From: Aleksandr Nogikh <nogikh@google.com>
Date: Sun, 20 Sep 2026 23:21:46 -0400
X-Gm-Features: AcwNN1WUMgeRXBpgYszcW0g6mSlnuTgvuF-nUDtWc4kpjX7wy3UebWOctuCvKT0
Message-ID: <CANp29Y6Empd+fQsHT5xWp8eyRpmn2_Ww=GpiXp48yyMifXAU-A@mail.gmail.com>
Subject: Re: [moderation/CI] Re: net: opt loopback into instance locking
To: syzbot ci <syzbot+ci82cbe6e020993733@syzkaller.appspotmail.com>
Cc: syzkaller-upstream-moderation@googlegroups.com, syzbot@lists.linux.dev
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

#syz upstream

On Sun, Sep 20, 2026 at 11:11=E2=80=AFPM syzbot ci
<syzbot+ci82cbe6e020993733@syzkaller.appspotmail.com> wrote:
>
> syzbot ci has tested the following series
>
> [v1] net: opt loopback into instance locking
> https://lore.kernel.org/all/20260918210419.4088201-1-kuba@kernel.org
> * [PATCH net-next] net: opt loopback into instance locking
>
> and found the following issue:
> WARNING in ipv6_add_dev
>
> Full report is available here:
> https://ci.syzbot.org/series/f12bc892-cfa6-4277-beac-794482c9a3f7
>
> ***
>
> WARNING in ipv6_add_dev
>
> tree:      net-next
> URL:       https://kernel.googlesource.com/pub/scm/linux/kernel/git/netde=
v/net-next.git
> base:      8830e65ed46de41f849eefb8ba227d4852c460f6
> arch:      amd64
> compiler:  Debian clang version 22.1.8 (++20260613092233+e80beda6e255-1~e=
xp1~20260613092250.77), Debian LLD 22.1.8
> config:    https://ci.syzbot.org/builds/ae142b5c-beb2-4c41-814c-2cd3e14bd=
bb0/config
>
> usbcore: registered new interface driver snd-usb-hiface
> usbcore: registered new interface driver snd-bcd2000
> usbcore: registered new interface driver snd_usb_pod
> usbcore: registered new interface driver snd_usb_podhd
> usbcore: registered new interface driver snd_usb_toneport
> usbcore: registered new interface driver snd_usb_variax
> drop_monitor: Initializing network drop monitor service
> NET: Registered PF_LLC protocol family
> GACT probability on
> Mirror/redirect action on
> Simple TC action Loaded
> u32 classifier
>     Performance counters on
>     input device check on
>     Actions configured
> nf_conntrack_irc: The irc conntrack helper is scheduled for removal.
> Please contact the netfilter-devel mailing list if you still need this.
> The pptp conntrack helper is scheduled for removal.
> Please contact the netfilter-devel mailing list if you still need this.
> The DCCP match is deprecated and scheduled to be removed in 2027.
> Please contact the netfilter-devel mailing list or update your iptables r=
ules
> xt_time: kernel timezone is -0000
> IPVS: Registered protocols (TCP, UDP, SCTP, AH, ESP)
> IPVS: Connection hash table configured (size=3D4096, memory=3D32Kbytes)
> IPVS: ipvs loaded.
> IPVS: [rr] scheduler registered.
> IPVS: [wrr] scheduler registered.
> IPVS: [lc] scheduler registered.
> IPVS: [wlc] scheduler registered.
> IPVS: [fo] scheduler registered.
> IPVS: [ovf] scheduler registered.
> IPVS: [lblc] scheduler registered.
> IPVS: [lblcr] scheduler registered.
> IPVS: [dh] scheduler registered.
> IPVS: [sh] scheduler registered.
> IPVS: [mh] scheduler registered.
> IPVS: [sed] scheduler registered.
> IPVS: [nq] scheduler registered.
> IPVS: [twos] scheduler registered.
> IPVS: [sip] pe registered.
> ipip: IPv4 and MPLS over IPv4 tunneling driver
> gre: GRE over IPv4 demultiplexer driver
> ip_gre: GRE over IPv4 tunneling driver
> IPv4 over IPsec tunneling driver
> Initializing XFRM netlink socket
> IPsec XFRM device driver
> xfrm_iptfs: IPsec IP-TFS tunnel mode module
> NET: Registered PF_INET6 protocol family
> ------------[ cut here ]------------
> debug_locks && !(lock_is_held(&(&dev->lock)->dep_map) !=3D 0)
> WARNING: ./include/net/netdev_lock.h:70 at ipv6_add_dev+0xfc1/0x1400, CPU=
#0: swapper/0/1
> Modules linked in:
> CPU: 0 UID: 0 PID: 1 Comm: swapper/0 Not tainted syzkaller #0 PREEMPT(ful=
l)
> Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS 1.16.2-debian-1.=
16.2-1 04/01/2014
> RIP: 0010:ipv6_add_dev+0xfc1/0x1400
> Code: ff ff e8 a2 6e 3a f7 48 8d 3d 6b 56 fd 05 48 c7 c6 80 a2 32 8d ba 8=
0 01 00 00 67 48 0f b9 3a e9 ab f0 ff ff e8 80 6e 3a f7 90 <0f> 0b 90 e9 cb=
 f1 ff ff e8 72 6e 3a f7 48 8d 3d 5b 56 fd 05 48 c7
> RSP: 0000:ffffc900000678c0 EFLAGS: 00010293
> RAX: ffffffff8a8d6400 RBX: dffffc0000000000 RCX: ffff888102abda00
> RDX: 0000000000000000 RSI: 0000000000000000 RDI: 0000000000000000
> RBP: 0000000000000000 R08: ffffffff90253707 R09: 1ffffffff204a6e0
> R10: dffffc0000000000 R11: fffffbfff204a6e1 R12: dffffc0000000000
> R13: ffff88810c036000 R14: ffffffff8caa6a10 R15: ffff88810c036008
> FS:  0000000000000000(0000) GS:ffff88818d6cd000(0000) knlGS:0000000000000=
000
> CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> CR2: ffff88823ffff000 CR3: 000000000eb48000 CR4: 00000000000006f0
> Call Trace:
>  <TASK>
>  addrconf_init+0x8b/0x170
>  inet6_init+0x228/0x3f0
>  do_one_initcall+0x250/0x870
>  do_initcall_level+0x10a/0x1a0
>  do_initcalls+0x59/0xa0
>  kernel_init_freeable+0x29d/0x3e0
>  kernel_init+0x22/0x1d0
>  ret_from_fork+0x514/0xb70
>  ret_from_fork_asm+0x1a/0x30
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
> [andrew@lunn.ch davem@davemloft.net edumazet@google.com horms@kernel.org =
kuba@kernel.org netdev@vger.kernel.org pabeni@redhat.com]
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
-upstream-moderation/6ab0a06e.514bccd6.255447.000c.GAE%40google.com.
