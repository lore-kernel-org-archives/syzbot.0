Received: from mail-oi1-f169.google.com (mail-oi1-f169.google.com [209.85.167.169])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1D4D73D0918
	for <syzbot@lists.linux.dev>; Tue, 10 Mar 2026 17:01:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.167.169
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773162071; cv=pass; b=K3LKoeRyA/U46z/XwDbhbnd51I5VjIdwZ7WwRHH3C4ExYHQZ1Z2cnRMoBARevTS410l5/fbQG0wE4bYmsaRwDlBbyiR7zX9VUbzpq3joCYPJXB0tH5OCy9Zdg4OZnG+VfXEw9YG10R1Ky5IEb3XRZnoJrdxBf5Ikvrc4DQPM+3A=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773162071; c=relaxed/simple;
	bh=mZ7Oh2GBS8K/iLKe5xzEkdu8psz9KrjVC10bGaWRlWM=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=lh8lObBspXQwrskHnUfcH44zExsUxyCHHjsi2sIRxtgbki4D5XBVpxkAntegZyaFIQ9Kmk1MyGJGRtP27KmmN92BUUSmAbfpIyIpLoKfUXgNfr1ZJ72Mmk79u6lDlYpA1ulRsMNX1xjtFpNdzZKfmrpiRoAlK7U4UGJ4ThQTFrc=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=0CkFlWPp; arc=pass smtp.client-ip=209.85.167.169
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="0CkFlWPp"
Received: by mail-oi1-f169.google.com with SMTP id 5614622812f47-46726528f1cso446262b6e.0
        for <syzbot@lists.linux.dev>; Tue, 10 Mar 2026 10:01:09 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1773162069; cv=none;
        d=google.com; s=arc-20240605;
        b=OeShNqg7LtmWpsUxgUyiITOeJy46OsD1/XKPM9PdJfvgywFo8hutgGNOcL51IluWIt
         Ms2kt9+Bq9x5K9xcx74+ZF2seB7C1GCNRb30GN9xH9DHbN/sGiZEgcjGgVoNTcVJQYnB
         J90OpP5/6K7nY+Uj71Via0Pwm7VNKoks8C09hRUZFA5w7mrCYynbM3yBw+qvDzPXkWwQ
         8HJvxtQNRp1AkP1Dvof+PGeFgCF2s4A1bpKS8UZrpJvFoSuNPgAz8bN8xFYYbZrOhnlm
         MO7jwil/730IE9zxnmzfntXxoruQNteoyA67JiwVJsJnLOvuzrHhDepp9NuFcrGNhiNv
         i6og==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=lKmwQODgHbXp3ddYWFLOyTK8AC9kvOdMi/9Wf68NBPM=;
        fh=njNCNsUd4pmMTCDl+7kpMw9CEB0NvMvIWONXUQvZL6g=;
        b=GnILurMNyKPZKkz5OPbjpnZaX71xzdKSuCdlwAH5VZIxxlo4xw6shSw1L/LpYsmvM1
         hz4XPWDCkROfT81VEdyrgvKVa/XTU7rhD5H3EvRRmLoNYZyzNWbNZHq9VnD/l1Ucg3gh
         JIZqz4OMReiK4m+wBZC67fqQZhNcnSUv/A95GZQloZrWZewtXaWVZREvk2lavDpJSKJE
         VwIx0QVEZ067viANhI6yyIqX3rZPLr3B0/l9PJ/GKkh+pVBjQ9EZuB+iTGiIxzYxPWw3
         U/311PZNDPo9rq1WQ2HfIhzwcCaeXI68Z8wv+1RhBcQQa4wzi1Ov+8hKGbGqNGee0cV4
         kuRQ==;
        darn=lists.linux.dev
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1773162069; x=1773766869; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=lKmwQODgHbXp3ddYWFLOyTK8AC9kvOdMi/9Wf68NBPM=;
        b=0CkFlWPp7fYKECuKRr5g3Ad9WUDdIA7jue/Z9lwQBFYoOPM6Bu1U5KlpvspnnHCRqH
         /OGQaqZNCOdR9FCblrIqQ1YOcK+o2gwwlzFVD+1vu8uxAIFZ11lkww95zlMe/aHsjVEn
         uvOvZrUt7C5bqp8fIn+rESCMtxgpAFZewR3e4aPqZkQ4mzfZlEP5Zl3VBf4UG+Ntw7nY
         ejcFTHTGCTjkA3BSDQXsSNRIyIpiUuH6bLLwZ36SMejV5KFZOOvitXKxenQaxG7ANbE8
         RhZ6IDRNEG6Wv34PzTAv6sH8lco1d0kN+jDFBWkuFVTiCgNHvOmCIdFDPafsjeUxHUub
         whkg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1773162069; x=1773766869;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=lKmwQODgHbXp3ddYWFLOyTK8AC9kvOdMi/9Wf68NBPM=;
        b=o69jKN8L0bHbv7czBQ3HPPG7H7Qcabl84AMJYiQzWqTVe+F+wM9KpYO7uX6hICX/kL
         ynLkI6UlYq+wFaAGxSA1/rymSOeiC0sIyGJFOvZhbl8GPbWyilkCCN2uySSOEQhheYqK
         4DJAEhMj5ml61sddkBxlAD9+/LxRaX9NKbAU9Ph/Ar/vwn5sHwiqN18WCjF+VeGTUvCm
         tLQNIowAEIBlE1vRI4wPPpAgT84v4jTXFyfn+d/D2a1LCgqR2avLTc26l5mBTIUPhJca
         dx5igvWPuhxEMBTXfu6qSvtYm5BAUKTbls7nlTE5MonlImeS83iK2K//8WJnyqEkoHX+
         VWZg==
X-Forwarded-Encrypted: i=1; AJvYcCWfKzs0oIB7ps4qqv0nsda5MZ4Vbl4DhpjlPx4DF46b9utIFAMPqfdHr7h6A4P3ObjekQ3/tPI=@lists.linux.dev
X-Gm-Message-State: AOJu0YxSJbD+bhlLVk+6OddK4A4clomctwrfoV6E3dgTdddhv4IkIbwL
	6HWQgiyzP+4GOXm8jufYagRqF8xHhVj7uyF4u6XanFJUES9XcRDp1nTfTqVMHJX+3yN/CRVSGU8
	3/DMEPKe5c3RzWMhYYyh/ltOCjgtTkfa07VHzPCgR
X-Gm-Gg: ATEYQzzhFeGm1QYyk0tD4zbzvK5NYI4R8nCQHOL593N7CKZx05IDIPJJO5haB5qIDlX
	f/pdcicCzOFX1nt8ZOSCh9LXQc0jif6xqtkTuLd1ZXtYXnu+nJp5MyCVT3rfQz8OYoIqVQGVhYX
	S6v0lQEkntMMNQseMhXY4GQreJcC3Z+HbisCV4pvX4uQ0cwAsN7Cxe/9S/FgcBTGRlGsYPSOUrp
	2wA67DsnEc+qzWEYAeKciFOjPpN0up9NQqSLh6q0vqik7KznUPyIv8mZ3jKAgPsramgzzqE50SJ
	TwiZU69iLg97BNMvMw3/fRlA/QcTxzqyQJ0axsju
X-Received: by 2002:a05:6808:c2b5:b0:450:3c7b:e7d0 with SMTP id
 5614622812f47-466dcb633d9mr8928188b6e.48.1773162067818; Tue, 10 Mar 2026
 10:01:07 -0700 (PDT)
Precedence: bulk
X-Mailing-List: syzbot@lists.linux.dev
List-Id: <syzbot.lists.linux.dev>
List-Subscribe: <mailto:syzbot+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:syzbot+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <69b02e51.050a0220.23b02c.0039.GAE@google.com>
In-Reply-To: <69b02e51.050a0220.23b02c.0039.GAE@google.com>
From: Aleksandr Nogikh <nogikh@google.com>
Date: Tue, 10 Mar 2026 17:00:56 +0000
X-Gm-Features: AaiRm51W434ywx2KUvpOmrRfk9pGqFSzg2FgXPhzCso5BjCBN7Dg2MY15E3122Y
Message-ID: <CANp29Y54xue7kkQ34-YRLpZ-+E0L+7UBXhcYbo328=8ZasGShw@mail.gmail.com>
Subject: Re: [moderation/CI] Re: net: move netdev_compute_master_upper_features
 to ndo_set_features
To: syzbot ci <syzbot+cia977a1d1cb7ea767@syzkaller.appspotmail.com>
Cc: syzkaller-upstream-moderation@googlegroups.com, syzbot@lists.linux.dev
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

#syz upstream

On Tue, Mar 10, 2026 at 2:44=E2=80=AFPM syzbot ci
<syzbot+cia977a1d1cb7ea767@syzkaller.appspotmail.com> wrote:
>
> syzbot ci has tested the following series
>
> [v1] net: move netdev_compute_master_upper_features to ndo_set_features
> https://lore.kernel.org/all/20260310-offload_compute-v1-0-3df79c09ea65@gm=
ail.com
> * [PATCH net-next 1/3] net: use ndo_set_features to set offload features =
for bonding/bridge/team
> * [PATCH net-next 2/3] failover: use ndo_set_features for failover offloa=
d compute
> * [PATCH net-next 3/3] net: no need to disable LRO specifically
>
> and found the following issue:
> WARNING in rtmsg_ifinfo_build_skb
>
> Full report is available here:
> https://ci.syzbot.org/series/d5001c4a-a51e-49c1-9106-624836e43ec2
>
> ***
>
> WARNING in rtmsg_ifinfo_build_skb
>
> tree:      net-next
> URL:       https://kernel.googlesource.com/pub/scm/linux/kernel/git/netde=
v/net-next.git
> base:      52ede1bce557c66309f41ac29dd190be23ca9129
> arch:      amd64
> compiler:  Debian clang version 21.1.8 (++20251221033036+2078da43e25a-1~e=
xp1~20251221153213.50), Debian LLD 21.1.8
> config:    https://ci.syzbot.org/builds/281e7e02-f6af-4b4a-845e-d1d5842a9=
301/config
>
> batman_adv: batadv0: Not using interface batadv_slave_1 (retrying later):=
 interface not active
> hsr_slave_0: entered promiscuous mode
> hsr_slave_1: entered promiscuous mode
> ------------[ cut here ]------------
> err =3D=3D -EMSGSIZE
> WARNING: net/core/rtnetlink.c:4421 at rtmsg_ifinfo_build_skb+0x218/0x260,=
 CPU#0: syz-executor/6496
> Modules linked in:
> CPU: 0 UID: 0 PID: 6496 Comm: syz-executor Not tainted syzkaller #0 PREEM=
PT(full)
> Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS 1.16.2-debian-1.=
16.2-1 04/01/2014
> RIP: 0010:rtmsg_ifinfo_build_skb+0x218/0x260
> Code: f6 ba 01 00 00 00 89 e9 e8 25 15 3a 00 4c 89 f0 48 83 c4 30 5b 41 5=
c 41 5d 41 5e 41 5f 5d e9 7f 3a 2e 02 cc e8 49 3b 42 f8 90 <0f> 0b 90 eb 90=
 89 d9 80 e1 07 fe c1 38 c1 0f 8c 95 fe ff ff 48 89
> RSP: 0018:ffffc9000637e9a0 EFLAGS: 00010293
> RAX: ffffffff89835e27 RBX: 0000000000000000 RCX: ffff8881b80a57c0
> RDX: 0000000000000000 RSI: 00000000ffffffa6 RDI: 00000000ffffffa6
> RBP: 00000000ffffffa6 R08: 0000000000000004 R09: 0000000000000004
> R10: fffff52000c6fcdc R11: 0000000000000000 R12: 1ffff110235ddc21
> R13: 0000000000000000 R14: ffff8881133dc780 R15: ffff88811aeee000
> FS:  0000555557c4a500(0000) GS:ffff88818de65000(0000) knlGS:0000000000000=
000
> CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> CR2: 000055555e1838c8 CR3: 0000000168b80000 CR4: 00000000000006f0
> Call Trace:
>  <TASK>
>  rtnetlink_event+0x1b7/0x270
>  notifier_call_chain+0x1be/0x400
>  netdev_change_features+0x95/0xe0
>  __netdev_upper_dev_link+0xb20/0xc80
>  netdev_upper_dev_link+0xb0/0x100
>  macsec_newlink+0xb11/0x1200
>  rtnl_newlink_create+0x329/0xb70
>  rtnl_newlink+0x1666/0x1be0
>  rtnetlink_rcv_msg+0x7d5/0xbe0
>  netlink_rcv_skb+0x232/0x4b0
>  netlink_unicast+0x80f/0x9b0
>  netlink_sendmsg+0x813/0xb40
>  __sys_sendto+0x672/0x710
>  __x64_sys_sendto+0xde/0x100
>  do_syscall_64+0x14d/0xf80
>  entry_SYSCALL_64_after_hwframe+0x77/0x7f
> RIP: 0033:0x7ffadf757917
> Code: 48 89 fa 4c 89 df e8 a8 56 00 00 8b 93 08 03 00 00 59 5e 48 83 f8 f=
c 74 1a 5b c3 0f 1f 84 00 00 00 00 00 48 8b 44 24 10 0f 05 <5b> c3 0f 1f 80=
 00 00 00 00 83 e2 39 83 fa 08 75 de e8 23 ff ff ff
> RSP: 002b:00007ffd0eb79f80 EFLAGS: 00000202 ORIG_RAX: 000000000000002c
> RAX: ffffffffffffffda RBX: 0000555557c4a500 RCX: 00007ffadf757917
> RDX: 0000000000000054 RSI: 00007ffae0544670 RDI: 0000000000000003
> RBP: 0000000000000001 R08: 00007ffd0eb79fe4 R09: 000000000000000c
> R10: 0000000000000000 R11: 0000000000000202 R12: 0000000000000003
> R13: 0000000000000000 R14: 00007ffae0544670 R15: 0000000000000000
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
> [andrew@lunn.ch bridge@lists.linux.dev davem@davemloft.net edumazet@googl=
e.com horms@kernel.org idosch@nvidia.com jiri@resnulli.us jv@jvosburgh.net =
kuba@kernel.org linux-kernel@vger.kernel.org liuhangbin@gmail.com netdev@vg=
er.kernel.org pabeni@redhat.com razor@blackwall.org sridhar.samudrala@intel=
.com]
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
-upstream-moderation/69b02e51.050a0220.23b02c.0039.GAE%40google.com.
