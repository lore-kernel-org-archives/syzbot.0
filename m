Received: from mail-oi1-f179.google.com (mail-oi1-f179.google.com [209.85.167.179])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 372E135CB98
	for <syzbot@lists.linux.dev>; Tue, 18 Nov 2025 14:56:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.167.179
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763477809; cv=none; b=q5Teqed2s2bPnFKvPNNxS89OW6JT/ZLHxEy6xMzp89YyQFpAMQst2iyIqttxgG6oO6K2H82A6RuChmbVf1y4V3T3uLmSARVirzryrji9u1VcG5nAxgR1mdceeDjcodu3M6Mao14YSS272fLWLLK3kTCm4isF1Iqjis4CrV9zGBg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763477809; c=relaxed/simple;
	bh=xh5wlDNYRs5HnTxoOApSKf2EDk91ExH/dAeWIaGNcZI=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=aogDcmusvjbwuaMc0etvuSXsAzybqbt4EXaUixYLWC4VEElroKzJNgY/1MGO51t5Gn23lofDOkqrkd6o2P5m6gkErLzXnetFIcYzRAHg/XQftJIBGdJVUuKGnxisADFJI1zeHKk/TV0DUYIWeDjcdRLFajef/RCBY/ykddIghjw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=UP6Qh3QU; arc=none smtp.client-ip=209.85.167.179
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="UP6Qh3QU"
Received: by mail-oi1-f179.google.com with SMTP id 5614622812f47-450c65f3510so923896b6e.2
        for <syzbot@lists.linux.dev>; Tue, 18 Nov 2025 06:56:47 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1763477806; x=1764082606; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=sKX0P9VeyrwG9fb2y+dSR983aX/sEGoYFJeEU+mD6ik=;
        b=UP6Qh3QUw/a+ud8HUMbAqQ7Jct3yUesf4I7vDt63dgGWPFA1FwT/ERqPmLdCVzyLC0
         ODnKzu2sMxhgQleeNtmgDvhNYy/wsothka5MWCjDMkENb4YXOyf8/bCktYs7KBVJJzSA
         hEW7CFRsuFLIkVXVoPVG1OggRMAy2rTnrl5psl4/aX6QQixcpt6U/srA7tjqiVJPuMJx
         EHHgWwy+E3KmSLce52QP/3zEk/yGbd8H1jQobbupWOX87rbgNeTvU7v0enqOu6LXuEza
         +1InjpY5jY9SRsbcoXKeVpA1th8Byu/3JfxFawQu65Pk6CH/RsZk7meGkhvKZZcJNj+N
         FWEA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1763477806; x=1764082606;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=sKX0P9VeyrwG9fb2y+dSR983aX/sEGoYFJeEU+mD6ik=;
        b=WKilGRDp13o9PBuQrXgknudMinEIx8j5C7ccyg0UNHEWgAW1bkQGzH803oejNJX+x/
         lRejZvpVqQwoiHQ01/eB+oFXVBKgcCV6A8yZfu/2+vmX6CBv4MT9ydbPzCh4p91dV2uN
         xD2VDmJatBq1uYO4ydrLVmRNOFEZUip50qBcUmKx7slNmqJTo274UmMIpX1/j03O99SV
         4qEHpKOlK8xTyiHGV73dFVBF/dQA+5z85ztiaAXPTPF70HEZZ+cxp+G/nyZE5zaErtlD
         vUASf2ys7QLsOK0XaYdbOXxgbjLySB5idG0EXmZBybOUmhR5V6QgaPTDV6qehJq9HAGU
         ysIQ==
X-Forwarded-Encrypted: i=1; AJvYcCXHC2tPDFLwA7rwBnUt4esb0hpWFKuIg8P16LWxrv154gYFWyIWmYJQTcxLoDSXPzJxQr6wgbQ=@lists.linux.dev
X-Gm-Message-State: AOJu0YwSwKed7ngzdGrW3WGB5L8ySFL0B4tAzdzzBQHvPJy80/5akddF
	LcQI2rFkqv40uLeucOMwXeyUdEWtd+yJlV2OxHjEtN16dT+rZcMQPYuPPG5r/ml+QywNQEbbiOg
	rz9tkwD/vKErOKE1D2pzRNeitijvYMMY0hlRGf+XsLfluOmKVAjq6PbG2
X-Gm-Gg: ASbGncsC6DXc6PwxLCGJ9YC8zJkaISSVHIFChp6HrtC3znDSTUmOWzO7Srmiu8qO0ST
	YRpd9o8xoR6+vGRdv4SYTb/nxn0eKSKu0yiKbDfxxYG6TD8Fy3AhbliaIh70FCV3yTE5PWwHyES
	z7TomSXfJvCgMy6+35s/WSOU8xMCyUrbNojtnoKTszCSJt/iZRQcr1+ziaJowPYKrbA+HIlSJsh
	IS/+l0ZQ9AYaeIvX2VyufJyZYyOdfQLJo3rFEOxtb/MToVRHG/C0EsdGn5J2VA/OOXpCu7RgUkY
	j+ZLdhuxKKi4m+JQwAwfPzX1Hdx8AdWyOLYS6Q6SL5PHoC5kToWX2LbiXA==
X-Google-Smtp-Source: AGHT+IFaFCsu4cXd1LiuffkswdLwyYQXpk1CNMoicQjCAz+RSQ7o1HAoZFFZ18G56GTmoR9SqVsIvvlcO1HR7WaGOOE=
X-Received: by 2002:a05:6808:1314:b0:450:3122:f0b0 with SMTP id
 5614622812f47-450973bdd11mr7800433b6e.9.1763477806151; Tue, 18 Nov 2025
 06:56:46 -0800 (PST)
Precedence: bulk
X-Mailing-List: syzbot@lists.linux.dev
List-Id: <syzbot.lists.linux.dev>
List-Subscribe: <mailto:syzbot+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:syzbot+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <691c73c3.a70a0220.3124cb.00c7.GAE@google.com>
In-Reply-To: <691c73c3.a70a0220.3124cb.00c7.GAE@google.com>
From: Aleksandr Nogikh <nogikh@google.com>
Date: Tue, 18 Nov 2025 15:56:34 +0100
X-Gm-Features: AWmQ_bnpXHcdeeh93SxcZztnWPS77VSyjqUUlT_Wde9kF3fBrZ8UGeVN5IWxi_4
Message-ID: <CANp29Y6biSWZXc1So35GZG1+39rmBV3kS0EPAJwZ8ZLFf1hQ0g@mail.gmail.com>
Subject: Re: [moderation/CI] Re: ipvlan: support mac-nat mode
To: syzbot ci <syzbot+cif71652b69cb8251b@syzkaller.appspotmail.com>
Cc: syzkaller-upstream-moderation@googlegroups.com, syzbot@lists.linux.dev
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

#syz upstream

On Tue, Nov 18, 2025 at 2:25=E2=80=AFPM syzbot ci
<syzbot+cif71652b69cb8251b@syzkaller.appspotmail.com> wrote:
>
> syzbot ci has tested the following series
>
> [v4] ipvlan: support mac-nat mode
> https://lore.kernel.org/all/20251118100046.2944392-1-skorodumov.dmitry@hu=
awei.com
> * [PATCH net-next 01/13] ipvlan: Support MACNAT mode
> * [PATCH net-next 02/13] ipvlan: macnat: Handle rx mcast-ip and unicast e=
th
> * [PATCH net-next 03/13] ipvlan: Forget all IP when device goes down
> * [PATCH net-next 04/13] ipvlan: Support IPv6 in macnat mode.
> * [PATCH net-next 05/13] ipvlan: Fix compilation warning about __be32 -> =
u32
> * [PATCH net-next 06/13] ipvlan: Make the addrs_lock be per port
> * [PATCH net-next 07/13] ipvlan: Take addr_lock in ipvlan_open()
> * [PATCH net-next 08/13] ipvlan: Don't allow children to use IPs of main
> * [PATCH net-next 09/13] ipvlan: const-specifier for functions that use i=
addr
> * [PATCH net-next 10/13] ipvlan: Common code from v6/v4 validator_event
> * [PATCH net-next 11/13] ipvlan: common code to handle ipv6/ipv4 address =
events
> * [PATCH net-next 12/13] ipvlan: Ignore PACKET_LOOPBACK in handle_mode_l2=
()
> * [PATCH net-next 13/13] selftests: drv-net: selftest for ipvlan-macnat m=
ode
>
> and found the following issue:
> WARNING: suspicious RCU usage in ipvlan_addr_event
>
> Full report is available here:
> https://ci.syzbot.org/series/e483b93a-1063-4c8a-b0e2-89530e79768b
>
> ***
>
> WARNING: suspicious RCU usage in ipvlan_addr_event
>
> tree:      net-next
> URL:       https://kernel.googlesource.com/pub/scm/linux/kernel/git/netde=
v/net-next.git
> base:      c99ebb6132595b4b288a413981197eb076547c5a
> arch:      amd64
> compiler:  Debian clang version 20.1.8 (++20250708063551+0c9f909b7976-1~e=
xp1~20250708183702.136), Debian LLD 20.1.8
> config:    https://ci.syzbot.org/builds/ac5af6f3-6b14-4e35-9d81-ee1522de3=
952/config
>
> 8021q: adding VLAN 0 to HW filter on device batadv0
> =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D
> WARNING: suspicious RCU usage
> syzkaller #0 Not tainted
> -----------------------------
> drivers/net/ipvlan/ipvlan.h:128 suspicious rcu_dereference_check() usage!
>
> other info that might help us debug this:
>
>
> rcu_scheduler_active =3D 2, debug_locks =3D 1
> 2 locks held by syz-executor/5984:
>  #0: ffffffff8f2cc248 (rtnl_mutex){+.+.}-{4:4}, at: inet_rtm_newaddr+0x3b=
0/0x18b0
>  #1: ffffffff8f39d9b0 ((inetaddr_chain).rwsem){++++}-{4:4}, at: blocking_=
notifier_call_chain+0x54/0x90
>
> stack backtrace:
> CPU: 1 UID: 0 PID: 5984 Comm: syz-executor Not tainted syzkaller #0 PREEM=
PT(full)
> Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS 1.16.2-debian-1.=
16.2-1 04/01/2014
> Call Trace:
>  <TASK>
>  dump_stack_lvl+0x189/0x250
>  lockdep_rcu_suspicious+0x140/0x1d0
>  ipvlan_addr_event+0x60b/0x950
>  notifier_call_chain+0x1b6/0x3e0
>  blocking_notifier_call_chain+0x6a/0x90
>  __inet_insert_ifa+0xa13/0xbf0
>  inet_rtm_newaddr+0xf3a/0x18b0
>  rtnetlink_rcv_msg+0x7cf/0xb70
>  netlink_rcv_skb+0x208/0x470
>  netlink_unicast+0x82f/0x9e0
>  netlink_sendmsg+0x805/0xb30
>  __sock_sendmsg+0x21c/0x270
>  __sys_sendto+0x3bd/0x520
>  __x64_sys_sendto+0xde/0x100
>  do_syscall_64+0xfa/0xfa0
>  entry_SYSCALL_64_after_hwframe+0x77/0x7f
> RIP: 0033:0x7f711f191503
> Code: 64 89 02 48 c7 c0 ff ff ff ff eb b7 66 2e 0f 1f 84 00 00 00 00 00 9=
0 80 3d 61 70 22 00 00 41 89 ca 74 14 b8 2c 00 00 00 0f 05 <48> 3d 00 f0 ff=
 ff 77 75 c3 0f 1f 40 00 55 48 83 ec 30 44 89 4c 24
> RSP: 002b:00007ffc44b05f28 EFLAGS: 00000202 ORIG_RAX: 000000000000002c
> RAX: ffffffffffffffda RBX: 00007f711ff14620 RCX: 00007f711f191503
> RDX: 0000000000000028 RSI: 00007f711ff14670 RDI: 0000000000000003
> RBP: 0000000000000001 R08: 00007ffc44b05f44 R09: 000000000000000c
> R10: 0000000000000000 R11: 0000000000000202 R12: 0000000000000003
> R13: 0000000000000000 R14: 00007f711ff14670 R15: 0000000000000000
>  </TASK>
> syz-executor (5984) used greatest stack depth: 19864 bytes left
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
> [andrew@lunn.ch andrey.bokhanko@huawei.com corbet@lwn.net davem@davemloft=
.net edumazet@google.com horms@kernel.org kuba@kernel.org linux-doc@vger.ke=
rnel.org linux-kernel@vger.kernel.org linux-kselftest@vger.kernel.org netde=
v@vger.kernel.org pabeni@redhat.com shuah@kernel.org skorodumov.dmitry@huaw=
ei.com]
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
-upstream-moderation/691c73c3.a70a0220.3124cb.00c7.GAE%40google.com.
