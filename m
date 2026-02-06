Received: from mail-oa1-f49.google.com (mail-oa1-f49.google.com [209.85.160.49])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4D43932B9A7
	for <syzbot@lists.linux.dev>; Fri,  6 Feb 2026 08:31:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.160.49
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770366687; cv=pass; b=JQaJqVb91uBYgWUiaNS0Q8buKOsN9GFZyDkOqKvTcHXCNl2xBSARmazc3vr8NRQ2NPLzS2A7BL3MRBcs+4aQITyKHQXriDbVJk6AmPXhg+/Thy7a7TKOxZTj4Tb2TAvMnrl53NjIallaMXith08+g7fJ/UbWx7lYgLUhex2FCFY=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770366687; c=relaxed/simple;
	bh=uytXJ276GpHc122LoHek8KLyvu1gYHfF7B06JYzoHRY=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=F8PmWQJgDQTY7zHQ1V8iFVdddtTiHOETRVl+MKrerizM9OEsmiYzYa9ULt7cF/+l90lxWznV5RoksRx6mYBBiqw+OPmjL+WeP2m+zTTgZ+PwDuW/4Ezu66X11jDBZ2VZwI40egbh8hBWvfO+sVcTuKCSLDgzZaXbzx+YUbTR2nU=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=GabikAbv; arc=pass smtp.client-ip=209.85.160.49
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="GabikAbv"
Received: by mail-oa1-f49.google.com with SMTP id 586e51a60fabf-4094fbd1808so225043fac.1
        for <syzbot@lists.linux.dev>; Fri, 06 Feb 2026 00:31:27 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1770366686; cv=none;
        d=google.com; s=arc-20240605;
        b=j9rl/t6hQuA9Hs//O3Ssbe3CUWHJyH4iy6+Ba9o4sqsZc5IR3RliuEEkEojqxoXJDO
         GPmECNIpUXJ2YGB9M4PgMSp573COmXD61ANhKSn1LzBtyPAypyd4KhB6dK4Dxnefdbhz
         JqvpCLE2qXAL3O6ytuzQIKbwfzOqrVIQ2yI2KJn1qiybW2dxG3T8DuqAX0ZB1Az5uciE
         FE3vyxomQogtCmYIWPQCwQUAfUdn+HUfAgjbivMWyJ4EkAC6/j+r7JefEsiC38R4kE4D
         vxJ34qgtEugPAsGklSlNzPwiqMGiaMlY59vkqdl3Q5OB0G0krL4+GCbfvegc1zH/NoxS
         xciw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=nOXmDGyEG7DI5DH7KugYXN+2K4AI1c9g41qAIEP44O4=;
        fh=QPLuC2PxQSA8gJydLTLLI3nGO8CN9eKiUXo9N9xBIiE=;
        b=ZuHQn2GyIC3dHXwBLvwQpKQlVPiZzQ4WbkNXZERfmYWd82nhxdQUvkBE6k7eLxqSVe
         +hhSnSJS+/mKYhL7SFOYYSmRFrclufCjkxd96TB207P6SDhuI62r+nnthSyhbzbgDHQl
         AJfM9DsdknyBt44qAvrOiOPzgJaDGkwrkpOqQNfTNko1DD6k1x3hhHgBKOIsNlvvF6vQ
         RpgxLzkPJGw4SFY+Hgdzhpxqj/MR+UPo4r7qPnUVANDQdg39ABdQ3UfAJVlbj3fWFR+h
         wXR1qiGzRyztI0V1ocR1MbSRsG9loox2uw4BsSI4/h0eymZOzalXDdU0luj0MxkRJINR
         /4Tw==;
        darn=lists.linux.dev
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1770366686; x=1770971486; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=nOXmDGyEG7DI5DH7KugYXN+2K4AI1c9g41qAIEP44O4=;
        b=GabikAbvDW9nf8qXscQhUCt4bmbWIsI+I7Dyyr4DuGXGis3jLbk77KsNg+vF1GCYlA
         bFn1csz5uwSN16w+Q2f5QZQ5Rgh/B0Rh75T2Vu2+Sv8v7iC5GSwei9RXxXVP5SoQ6cz5
         87/4ZPd3gw/CoN4wGmOn5a6ggEAOBwKvFEfUCEJtGiWDFBvBg9U/kZuxHjk+HIdB2LPF
         pyRzSdZN8Pxk/BuWk/kDRJjJ+ZZAiDgotAr/L6J4fsieNiRmvmIrwNCFJKjPsQwqQ68v
         FyaKTYK9Bnsqau35N2dTky+y45UCjE/SOoLYJ6pFX0MTVRkUQoILT01Zja5/U2GuY0wz
         JzgA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1770366686; x=1770971486;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=nOXmDGyEG7DI5DH7KugYXN+2K4AI1c9g41qAIEP44O4=;
        b=wG/JXfNOXUaymTGt3RNoiAfeOMfz6/Rk885YULgChKrN9+L3VPGRryWO1mrhob2V1+
         VKNetI7jFz6RFejBexpTstDb3o4jZDI2rEW2N1q3a2hswyucMWmXEpvXEHKZkj7bvfhr
         txEnxmtWXK4gR+MM+VNDlNF+yzv8Ew0KhpEXFbb+SlRmqtq9acuyLYmzu2Sw9/zA1qNE
         GnNLhKJz+GcXKYvs9E1at07VPw5jbKbAE/8wfkseKrpsnc09Os4exf2kZpdYG+evKIjU
         2MxQPeKZuCNCNP73CpPoorq5YOOdf0HKjR2J9/1skwFB+T5EhRI+ZOAeIoGYa5Z0od7N
         FGVQ==
X-Forwarded-Encrypted: i=1; AJvYcCXIe6EagNXSuSLR58fU9ZP7UhERPfPEKr7Y1nxY42+McMhw1g3jgLJUYiazmqOEx+XaBc8nMrE=@lists.linux.dev
X-Gm-Message-State: AOJu0YwoiXYRBZEJSu9GwF0UUh6VbhVjQIA1QtYT4NjBwh1SKRJVqipL
	U+hbeQYHfU/kCSeWCg+l3NFZlFjUasMt+jQ2goUtuUEQVo/48ZyHiiR5+BR09OQQ3smO6TxQPfU
	esRoGVPB5OHNqAbVsr9SWs2OA/7XzwGp+9YMjcxK+
X-Gm-Gg: AZuq6aJ5QjQ2bnuqlVomq0tSXjQrWQ49X3swPhFRuGNLv4xpkUXaxZ+lTO4S2ogEXbD
	Z1xlDYFHa6m/2GQ/ap75uJhM9fJunwElFe8HEI3eNuBnsrdEOOlJoKdanwvX3UvIz62RSN2H/7J
	OcZz4ydmTlArWmWGKYIBjWe1UkMrUANNkQftQcJ6N0riVT86nrkjkAvFzE1P5n6KmJtr4UluB3m
	ebWG6TiznJgvGy8FHZl0jaXbMeawo1qH3bW42PjYsOyXqu9Ju22Aj2R9/IgkfK5X2rGOfBV4AI0
	kMcl7NQs23qfPIlhT+qhBJibiUsylqs4tTi3GTn7A+tJTxuMCoa7ARJ+OqftreHzS8hN
X-Received: by 2002:a05:6871:e3:b0:3ec:554d:c222 with SMTP id
 586e51a60fabf-40a96f79906mr1131164fac.46.1770366685853; Fri, 06 Feb 2026
 00:31:25 -0800 (PST)
Precedence: bulk
X-Mailing-List: syzbot@lists.linux.dev
List-Id: <syzbot.lists.linux.dev>
List-Subscribe: <mailto:syzbot+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:syzbot+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <698544e6.a00a0220.34fa92.0020.GAE@google.com>
In-Reply-To: <698544e6.a00a0220.34fa92.0020.GAE@google.com>
From: Aleksandr Nogikh <nogikh@google.com>
Date: Fri, 6 Feb 2026 09:31:14 +0100
X-Gm-Features: AZwV_QgFqHMpQP6WOhaAG0xclACNNFn1Gq-_Rv97bIrknNyyuGNx8tkEmZEdTqQ
Message-ID: <CANp29Y4UC_7ko8dZmjZDzJbU7c8W_p=_MByCy=WOLQVvL5iDqg@mail.gmail.com>
Subject: Re: [moderation/CI] Re: net: sched: refactor qdisc drop reasons into
 dedicated tracepoint
To: syzbot ci <syzbot+cib1b7e8a709c48e1b@syzkaller.appspotmail.com>
Cc: syzkaller-upstream-moderation@googlegroups.com, syzbot@lists.linux.dev
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

#syz upstream

On Fri, Feb 6, 2026 at 2:33=E2=80=AFAM syzbot ci
<syzbot+cib1b7e8a709c48e1b@syzkaller.appspotmail.com> wrote:
>
> syzbot ci has tested the following series
>
> [v2] net: sched: refactor qdisc drop reasons into dedicated tracepoint
> https://lore.kernel.org/all/177032644012.1975497.16411100029657607833.stg=
it@firesoul
> * [PATCH net-next v2 1/6] net: sched: introduce qdisc-specific drop reaso=
n tracing
> * [PATCH net-next v2 2/6] net: sched: sfq: convert to qdisc drop reasons
> * [PATCH net-next v2 3/6] net: sched: sch_cake: use enum qdisc_drop_reaso=
n for cobalt_should_drop
> * [PATCH net-next v2 4/6] net: sched: rename QDISC_DROP_CAKE_FLOOD to QDI=
SC_DROP_FLOOD_PROTECTION
> * [PATCH net-next v2 5/6] net: sched: rename QDISC_DROP_FQ_* to generic n=
ames
> * [PATCH net-next v2 6/6] net: sched: sch_dualpi2: use qdisc_dequeue_drop=
() for dequeue drops
>
> and found the following issue:
> WARNING in __dev_queue_xmit
>
> Full report is available here:
> https://ci.syzbot.org/series/51381d54-6fc9-4542-a8cd-eac656a11965
>
> ***
>
> WARNING in __dev_queue_xmit
>
> tree:      net-next
> URL:       https://kernel.googlesource.com/pub/scm/linux/kernel/git/netde=
v/net-next.git
> base:      7a4cd71fa4514cd85df39b3cf99da8142660cdcd
> arch:      amd64
> compiler:  Debian clang version 21.1.8 (++20251221033036+2078da43e25a-1~e=
xp1~20251221153213.50), Debian LLD 21.1.8
> config:    https://ci.syzbot.org/builds/17bc5e9e-8ccc-4afb-a291-312bbc43d=
f20/config
> C repro:   https://ci.syzbot.org/findings/20939160-05e8-4589-a6d5-6a253d5=
e39b0/c_repro
> syz repro: https://ci.syzbot.org/findings/20939160-05e8-4589-a6d5-6a253d5=
e39b0/syz_repro
>
> syzkaller0: entered promiscuous mode
> syzkaller0: entered allmulticast mode
> ------------[ cut here ]------------
> reason && reason < __QDISC_DROP_REASON
> WARNING: net/sched/sch_generic.c:50 at tcf_kfree_skb_list+0xd6/0x100 net/=
sched/sch_generic.c:50, CPU#0: syz.0.17/5949
> Modules linked in:
> CPU: 0 UID: 0 PID: 5949 Comm: syz.0.17 Not tainted syzkaller #0 PREEMPT(f=
ull)
> Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS 1.16.2-debian-1.=
16.2-1 04/01/2014
> RIP: 0010:tcf_kfree_skb_list+0xd6/0x100 net/sched/sch_generic.c:50
> Code: 89 e8 e8 5d 00 00 00 31 ff 4c 89 e6 ba 40 00 00 00 e8 be e6 d6 ff 4=
c 8b 24 24 4d 85 e4 74 27 e9 6e ff ff ff e8 1b f3 50 f8 90 <0f> 0b 90 eb c4=
 44 89 e9 80 e1 07 80 c1 03 38 c1 7c 96 4c 89 ef e8
> RSP: 0018:ffffc90003e67360 EFLAGS: 00010293
> RAX: ffffffff89718645 RBX: ffff8881133cc000 RCX: ffff8881738b9d40
> RDX: 0000000000000000 RSI: 0000000000000001 RDI: 000000000002ffff
> RBP: 0000000000000001 R08: ffff88811571195b R09: 1ffff11022ae232b
> R10: dffffc0000000000 R11: ffffed1022ae232c R12: ffff88810a9bca80
> R13: 0000000000000002 R14: ffff888109569400 R15: ffff888115711800
> FS:  000055558d217500(0000) GS:ffff88818e31a000(0000) knlGS:0000000000000=
000
> CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> CR2: 0000200000001410 CR3: 0000000166b9c000 CR4: 00000000000006f0
> Call Trace:
>  <TASK>
>  __dev_xmit_skb net/core/dev.c:4272 [inline]
>  __dev_queue_xmit+0x18e5/0x3180 net/core/dev.c:4797
>  packet_snd net/packet/af_packet.c:3077 [inline]
>  packet_sendmsg+0x3eb6/0x50f0 net/packet/af_packet.c:3109
>  sock_sendmsg_nosec net/socket.c:727 [inline]
>  __sock_sendmsg+0x21c/0x270 net/socket.c:742
>  ____sys_sendmsg+0x4d7/0x810 net/socket.c:2592
>  ___sys_sendmsg+0x2a5/0x360 net/socket.c:2646
>  __sys_sendmsg net/socket.c:2678 [inline]
>  __do_sys_sendmsg net/socket.c:2683 [inline]
>  __se_sys_sendmsg net/socket.c:2681 [inline]
>  __x64_sys_sendmsg+0x1bd/0x2a0 net/socket.c:2681
>  do_syscall_x64 arch/x86/entry/syscall_64.c:63 [inline]
>  do_syscall_64+0xe2/0xf80 arch/x86/entry/syscall_64.c:94
>  entry_SYSCALL_64_after_hwframe+0x77/0x7f
> RIP: 0033:0x7f6544b9acb9
> Code: ff c3 66 2e 0f 1f 84 00 00 00 00 00 0f 1f 44 00 00 48 89 f8 48 89 f=
7 48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 ff=
 ff 73 01 c3 48 c7 c1 e8 ff ff ff f7 d8 64 89 01 48
> RSP: 002b:00007ffc871586c8 EFLAGS: 00000246 ORIG_RAX: 000000000000002e
> RAX: ffffffffffffffda RBX: 00007f6544e15fa0 RCX: 00007f6544b9acb9
> RDX: 0000000000000004 RSI: 00002000000000c0 RDI: 0000000000000008
> RBP: 00007f6544c08bf7 R08: 0000000000000000 R09: 0000000000000000
> R10: 0000000000000000 R11: 0000000000000246 R12: 0000000000000000
> R13: 00007f6544e15fac R14: 00007f6544e15fa0 R15: 00007f6544e15fa0
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
> [atenart@redhat.com bpf@vger.kernel.org carges@cloudflare.com davem@davem=
loft.net edumazet@google.com eric.dumazet@gmail.com hawk@kernel.org horms@k=
ernel.org jhs@mojatatu.com jiri@resnulli.us kernel-team@cloudflare.com kuba=
@kernel.org netdev@vger.kernel.org pabeni@redhat.com toke@toke.dk xiyou.wan=
gcong@gmail.com]
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
-upstream-moderation/698544e6.a00a0220.34fa92.0020.GAE%40google.com.
