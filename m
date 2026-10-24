Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=209.85.219.46
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1792862167;
	b=PPF13oCM4+oJQG8iyxYcGA1LPTfC7Q2dvJSj1qwZytutoqeLw+Lhub0/lc/Z8erzwMTW
	 X/3GekUIxYnUIgvBLzbo1nwLuxBECbmJSsOh6klXnm9ECqsLFJJSOc4mjwX1E5O9wjBx/
	 CAWSh2QMlUrZDVNe+3ozJkewfMOQeJoCodNUoddMmsqwO+ZILmuJTBAy5aLb4ZPQahixe
	 bhI8Jg5PaM3FDK+ko6Y6wuAA7aPheDduRVFKTeCMOJgdG9NIMZvK+G7h4WaGJBe94LYhr
	 pI6l39GCMFBoT2U2UgjW+LovXzaay24BAW/wCEAIOThYrsNT7pLBEVER/jZ8pyFMR4Q==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792862167;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:
	 MIME-Version:References:In-Reply-To:From:Date:X-Gm-Features:
	 Message-ID:Subject:To:Cc:Content-Type:Content-Transfer-Encoding;
	bh=mPZPCkEtT6Wmn806M7Bx09wQNOGtzqpWCtR1kjQ/Zz4=;
	b=1YxsMRmSNGPBH3tbuMuMbhD9kQ7ZnovMYm+y0MaxN4bRjNMKSM04fRk6APnBennmP6JQ
	 xynBn5dPyw2BSL7zw5xD65GDHKMdN7aQf/PEbIMkqPp9rFgUb1BloS+lI3Swc16SkuayJ
	 y6Na1h6qVDukNeo7JUPhm/jvT6FJbadXeqwAXhvk7TaV1AGAMsgZNY8R87MewWRDHh8c9
	 rocJLM/fJ7kLVt0u8MyQhpRwZWdTi4hsA43qQUMnUkGZuVDj/8YnRsziS7VlB2YQmyO9s
	 7J1uF7AQzRTTu55CbKHxkhE1uQxelTe0PN2Hvcku8nkNCywjrD31XaJryAZOgN5Zi7A==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=google.com;
	spf=pass smtp.mailfrom=google.com;
	dkim=pass header.d=google.com header.i=@google.com header.a=rsa-sha256 header.s=20251104 header.b="Hvk/7tW4";
	arc=pass header.oldest-pass=0 smtp.remote-ip=209.85.219.46
Received: from mail-qv1-f46.google.com (mail-qv1-f46.google.com [209.85.219.46])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4BD46606A31A
	for <syzbot@lists.linux.dev>; Sat, 24 Oct 2026 17:16:07 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 4BD46606A31A
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=google.com header.i=@google.com header.a=rsa-sha256 header.s=20251104 header.b=Hvk/7tW4
Received: by mail-qv1-f46.google.com with SMTP id 6a1803df08f44-91b83459526so22268336d6.2
        for <syzbot@lists.linux.dev>; Sat, 24 Oct 2026 10:16:07 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1792862166; cv=none;
        d=google.com; s=arc-20260327;
        b=Thdg9OIpEH/AF0KmHazYZnjgvjFwOlFYss20GqtzM7kMQNOTyLbZSue/HOhjqBCvhG
         sLgNpv9WBXPrADDnCj2WpwO6foqOKnC2N0Z/Hso46s9U+2obVcNpOFPFuN0JuJY82azJ
         xYTCwpJJqXrbB8kzh6WJdTTX8gc++nQUTO90PPZtk9YgNm2AQYQHQVzJYKOmsLbwOuIy
         Ndp8o991WeKgsDBqKU/rKj1QKalbzBLfozqevCXFbDVNDXFTEd7BucPeWfvrb7/MK8w3
         Gs/8eXL0xqa3r32NLpG5iZoR2jkQ9s32eZ2wzB2ykhB2AprEAFMA/LyNvyV0Hcd4nzZt
         4DFQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=mPZPCkEtT6Wmn806M7Bx09wQNOGtzqpWCtR1kjQ/Zz4=;
        fh=cVcOFvyvCe9mViqAQBAs0wyW3CouDVesmO1ON7zsrIk=;
        b=redxZn9xNH/m8XtgJc4PjH/mWWTb6lqGfOhqSAiX2qMDDRoje9vMs+iYOuD+1sRnod
         NznaMJiVdEkotueaolPphnHG3BJhDyM15R+ZrOBW8pPYIBlqtkYzHdTpn/vrqtndUiTz
         XDwTp1DuLrqF9d7LyBnEAwe9HjUqPDU/HdGMn8V9OAsBpKjGaSrWCNZO6z59F52BhDAM
         PEKlt7e+5bsSlYPlD5SAVVTLe6Mep1lWycOO+EVaoaLUdoiBpGlHOecptmB6TEw6wG/R
         PW2xFAIGOAeTWplxLsyWa4YzPR3GYpbWvdN3yBDQ0AJVAje+dfuwbgby90h07OAVf9zI
         qJYw==;
        darn=lists.linux.dev
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1792862166; x=1793466966; darn=lists.linux.dev;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=mPZPCkEtT6Wmn806M7Bx09wQNOGtzqpWCtR1kjQ/Zz4=;
        b=Hvk/7tW4BUchmaCNpb1wINfcg4LjCgJrt65gJrR3mxkjwnHj2igKh+qAaXVcDiz3jU
         WwoBC+jd+VGdEo5W3bqJfD2H0cpG0p4y9gmPJViSy6YrZC5PRo7H8XgQdX1XXEvD+KmG
         LpQHKXhrjRsJ638Sn/2qJrE5e/LejmNX+va9qdHNCyup39dW0LmGlCb42dszgnyn49d/
         K79UtLA+Dkni06e7HM4DOw426/ZgdKg8VrfFmBMu9LLcpJHV/85nXogHTZ8fcMJRtE45
         lo4FpRW9s5+klXI+d7GA96jEo2krbCrNOybF6DxLGMQJPsJxhXI4079IQGo65OsxXLs+
         l9Mg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1792862166; x=1793466966;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=mPZPCkEtT6Wmn806M7Bx09wQNOGtzqpWCtR1kjQ/Zz4=;
        b=ig4EI1D/jFzrCszxvpJ7y0Fl4NhcExz/8059ahfhQ03fHIRSR7iyipTfI5tJWKwoKo
         2f2zO9HZXAdxnD0c8jqOXxgDy+wIzBOWJyJLtHSsfNx7Qo/L/HHsN6cfZV88V/MZtj0Z
         +u8p2HvoJcA5eOceKaHiOssKIQoTJbZKZOHOtZ9NIgWw5CzSWT9dEFeh7JYSYyubzD4m
         BqKo/zypzRiLRa39HAxdsslY9rngoiFKGOQUH39l6rmqimh3Xn37i6E/rW3++OXB+GXQ
         bNlnHbKkdAIk5xtuU+84fmGdpIzOwma4KfL9xgS2IPS4vVy8XA5iWc4ETI7XbMW/B5uU
         lAhw==
X-Forwarded-Encrypted: i=1; AKwUvBzuaaudNm942Lo0wGDwEApLDFhKw8d3gV7JAnIKn6AExZ5jnv3Q+FnBCg78A2lAWyijhCVTlYk=@lists.linux.dev
X-Gm-Message-State: AFq9FYLdXwMnVVPxiL/HsmtY/ZaWBYAC10Ic2w/orx63E6qbKHBKW4Du
	sjf4A4N3niLqzH+Qz+F6BO5rasL/A4qIJuJXGV4mfqy6So7CmBiToXPBzSgHVxIuhHrB+UYK33N
	Md7LWNuMFkXZoVGW1TSj2kLjvMqfTVbCdBPAkSOUB
X-Gm-Gg: AYBFou3kNBTaDPWld40uq6Gw14G5c9irz/17d7uX3Ce/m7ZMFYcvSRhuvKW6LSSg3Ps
	XiTBTpveRrOHJwCaC5ihR8NVJCwkW5PtmVBDCdjJ9TQE7HvN3hDb2bgv/i0UDLS+Y1yJaiqkmdT
	a6qPwiO7FA1yWDqq5xZLxh9skW0SpM9T/VCLiD2mEt3Xo1vuJIIlZ0fth3xeT9WCbFybPm96iAk
	or1NGMEEGWagFnngBWBA0nnbG+AvFra/W2WxGA48qII/5L6Sp9ib17pmXF+G9zFaP4J1pzzxUeB
	qoWFTlALBJbXB6DyN2HPmEyCJvMtrcRnUoXIV/CvnRIJvVM+x4jFtxRhiNl8nyf+AZlvxQ2IVt3
	k6CTMiAutmkPpBMehPCH6JuTBEgCdDG2KGQ6fsHFddL5a0w6CJK9KNKmpTckeXRaIpAs+
X-Received: by 2002:a05:6214:53c1:b0:91b:8296:3b88 with SMTP id
 6a1803df08f44-91c48e36df9mr38325926d6.15.1792862165634; Sat, 24 Oct 2026
 10:16:05 -0700 (PDT)
X-Mailing-List: syzbot@lists.linux.dev
List-Id: <syzbot.lists.linux.dev>
List-Post: <mailto:syzbot@lists.linux.dev>
List-Help: <mailto:syzbot+help@lists.linux.dev>
List-Subscribe: <mailto:syzbot+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:syzbot+unsubscribe@lists.linux.dev>
List-Owner: <mailto:syzbot+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
References: <6adca9c8.998fdb85.f0000.000f.GAE@google.com>
In-Reply-To: <6adca9c8.998fdb85.f0000.000f.GAE@google.com>
From: Pimyn Girgis <pimyn@google.com>
Date: Sat, 24 Oct 2026 19:15:54 +0200
X-Gm-Features: AclHuK_QHlFLv3eBlAZRDh2bnDG7OkM013xVSm_COMzQWspCwRFXFjCA5dW8QMM
Message-ID: <CAJWNTGz-fT4wfZ5r_=dTZHHUr_Zuh_hkvn9SwNYeMx7ahFyZcw@mail.gmail.com>
Subject: Re: [moderation/CI] Re: ipv6: Protect multiple routes insertion by
 table lock.
To: syzbot ci <syzbot+ci8f91d74e670176f2@syzkaller.appspotmail.com>
Cc: syzkaller-upstream-moderation@googlegroups.com, syzbot@lists.linux.dev
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

#syz upstream


On Sat, Oct 24, 2026 at 2:51=E2=80=AFPM syzbot ci
<syzbot+ci8f91d74e670176f2@syzkaller.appspotmail.com> wrote:
>
> syzbot ci has tested the following series
>
> [v1] ipv6: Protect multiple routes insertion by table lock.
> https://lore.kernel.org/all/20261023191517.607834-1-kuniyu@google.com
> * [PATCH v1 net] ipv6: Protect multiple routes insertion by table lock.
>
> and found the following issue:
> WARNING: suspicious RCU usage in rt6_multipath_rebalance
>
> Full report is available here:
> https://ci.syzbot.org/series/7d878fa2-f84a-4468-85e2-c2a5e263aeff
>
> ***
>
> WARNING: suspicious RCU usage in rt6_multipath_rebalance
>
> tree:      net
> URL:       https://kernel.googlesource.com/pub/scm/linux/kernel/git/netde=
v/net.git
> base:      7076f684d5132e6a6145e1da2fa74771ecd052e5
> arch:      amd64
> compiler:  Debian clang version 22.1.8 (1~deb13u4), Debian LLD 22.1.8
> config:    https://ci.syzbot.org/builds/bbb3053f-f23f-4fe3-a9e9-853964281=
19d/config
> AI triage: https://ci.syzbot.org/findings/64360b2e-48dc-4b55-b253-6a51753=
5ecb7/triage_trajectory
>
> IPv6: RTM_NEWROUTE with no NLM_F_CREATE or NLM_F_REPLACE
> IPv6: NLM_F_CREATE should be set when creating new route
> =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D
> WARNING: suspicious RCU usage
> syzkaller #0 Not tainted
> -----------------------------
> ./include/net/addrconf.h:351 suspicious rcu_dereference_check() usage!
>
> other info that might help us debug this:
>
>
> rcu_scheduler_active =3D 2, debug_locks =3D 1
> locks held by syz.2.3386/18922: 1, last CPU#0:
>  #0: ffff888177df3430 (&tb->tb6_lock){+...}-{3:3}, at: inet6_rtm_newroute=
+0x3dc/0x1ab0
>
> stack backtrace:
> CPU: 0 UID: 0 PID: 18922 Comm: syz.2.3386 Not tainted syzkaller #0 PREEMP=
T(full)
> Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS 1.16.2-debian-1.=
16.2-1 04/01/2014
> Call Trace:
>  <TASK>
>  dump_stack_lvl+0xe8/0x150
>  lockdep_rcu_suspicious+0x140/0x1d0
>  rt6_multipath_rebalance+0xf11/0x1080
>  fib6_del+0xada/0x15a0
>  inet6_rtm_newroute+0x15b5/0x1ab0
>  rtnetlink_rcv_msg+0x802/0xc00
>  netlink_rcv_skb+0x226/0x4a0
>  netlink_unicast+0x8ef/0xa80
>  netlink_sendmsg+0x7f0/0xb20
>  sock_sendmsg_nosec+0x14e/0x190
>  ____sys_sendmsg+0x54e/0x850
>  ___sys_sendmsg+0x2a5/0x360
>  __sys_sendmmsg+0x273/0x4e0
>  __x64_sys_sendmmsg+0xa0/0xc0
>  do_syscall_64+0x166/0x520
>  entry_SYSCALL_64_after_hwframe+0x77/0x7f
> RIP: 0033:0x7fa77459f559
> Code: ff c3 66 2e 0f 1f 84 00 00 00 00 00 0f 1f 44 00 00 48 89 f8 48 89 f=
7 48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 ff=
 ff 73 01 c3 48 c7 c1 e8 ff ff ff f7 d8 64 89 01 48
> RSP: 002b:00007fa775488028 EFLAGS: 00000246 ORIG_RAX: 0000000000000133
> RAX: ffffffffffffffda RBX: 00007fa774826090 RCX: 00007fa77459f559
> RDX: 040000000000009f RSI: 00002000000002c0 RDI: 000000000000000b
> RBP: 00007fa774636b20 R08: 0000000000000000 R09: 0000000000000000
> R10: 0000000000000000 R11: 0000000000000246 R12: 0000000000000000
> R13: 00007fa774826128 R14: 00007fa774826090 R15: 00007fffd26b46d8
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
> [davem@davemloft.net dsahern@kernel.org edumazet@kernel.org horms@kernel.=
org idosch@nvidia.com kuba@kernel.org kuni1840@gmail.com kuniyu@google.com =
netdev@vger.kernel.org pabeni@redhat.com syzbot@syzkaller.appspotmail.com]
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
-upstream-moderation/6adca9c8.998fdb85.f0000.000f.GAE%40google.com.



--=20
=E2=B2=A0=E2=B2=9F=E2=B2=93=E2=B2=99=E2=B2=8F=E2=B2=9B =E2=B2=84=E2=B2=89=
=E2=B2=B1=E2=B2=A3=E2=B2=85=E2=B2=93=E2=B2=9F=E2=B2=A5 - Pimyn Girgis
Software Engineer
Kernel Dynamic Analysis
pimyn@google.com
