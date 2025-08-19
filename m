Received: from mail-pl1-f178.google.com (mail-pl1-f178.google.com [209.85.214.178])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2C55A24502C
	for <syzbot@lists.linux.dev>; Tue, 19 Aug 2025 15:40:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.178
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755618033; cv=none; b=NZxgCy/ktNZ8C7+1EsTpKodIkgC+UxZv+YzydReUo38RC1UcI4qt3KO9dWoTZIYO58iuD4u9jzdEEfuWa/ztAFhzYXZdMZv1Mb5P1Zw7DYUk+x/qk2nOy71Tqe/rzZSV/Z3ThPf7YJyl5Yr2tiZYUpNGPDrUuN23a8/VPEjvzD8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755618033; c=relaxed/simple;
	bh=LZOROMjLMSqyTO38u1EVUhkP8Ax5DaUGq3w3ip3AHFQ=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=D//x+JomXa/NslUk4IcNN4sezInzhQK7RdTaX+JrztbQwaqMclmiiqPXo2Zlq/pyvPpBd5Nx5rrfTH99h2lYvbky6rn3biYPCkEH0CrXgpbagv/i2Yh5wwui01XaBEcPkIdcx4TecEBQ4Mp0iYkralUtG6AmWc22Eg1+AZVUFYw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=RkXZGwvI; arc=none smtp.client-ip=209.85.214.178
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="RkXZGwvI"
Received: by mail-pl1-f178.google.com with SMTP id d9443c01a7336-24458317464so61349265ad.3
        for <syzbot@lists.linux.dev>; Tue, 19 Aug 2025 08:40:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1755618028; x=1756222828; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=CyIe6FCFSnRv9yGkBWARiwe57fhJ3uLysuZnsfA+ng8=;
        b=RkXZGwvIO9gedUbs7shpwGYh0EK50Ve8a2Y80MnV+LN13LLcZaVd0NX/12n39Bqhku
         yiteUkB416zZWpvTWTvKj7EFszQJ0MpNmfERbVTVBfS3AlL7NhchLtmEsoR3w0Ia1Zs2
         7To5PY5TTNw5eVcWta61lFSv6lYZdvk9M8v0o6rdek4BkKQlE1VJep36MxaosjGBjGSg
         9+dLFS192udAGRo3aYI4xRLrcgQ9RkydQOQEOFflkgD3WnQPNDRvVrqbs2s3ReihQ+Hf
         L5ojb0vX6s289lhaS6igN99AgrY2hvTvUmXZfELnZ7nv3x//duVOYwJnc/PoE6oCroAC
         Jocg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1755618028; x=1756222828;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=CyIe6FCFSnRv9yGkBWARiwe57fhJ3uLysuZnsfA+ng8=;
        b=e1XWXfCOIR/HLaVaay3Wt2xRAslfaZPFKiiF0imQWK0EQbNe72j2bL0IrW4263mARZ
         h4K0b07udgwVVXSEOYX3mOM9+QP5CY/Mflszsxl4TOQq8HJMkjNnChxXunridc2ny+jp
         zvPxT/i/y3jG5MY+U6kiGCBHJTD0SVw1cKX03nYOVBClhdnx8irzJtYVzhTaf9XNlVOv
         DT3Bn/xOcsnJfXc/sXgVFc1fbFRm3xte7k8UufBM81ixnh36rMej+vimYbXYj8wkA+8O
         xjuDb1z8nq1AlNgvOausMG/mNh4igRg2qvAXIlOkvaLLFuT2jXCPmqY0D2WLzMD2UIdJ
         4JQQ==
X-Forwarded-Encrypted: i=1; AJvYcCXWSr1aRjhegcjWEoMRRvQhpRcM7qhx8kwwAsHKB8mnI+h/NzhNcNKq/x38VWzrvts7OWP1MJg=@lists.linux.dev
X-Gm-Message-State: AOJu0YwlYD2z+AY53KRI1OmSuBJFxId92iwVv3/ODbqevwSMZJQ4iQDg
	Hhk/cyGCET30k6sQGTAb23NvOHzhKc7ptCnqWcJZ/bQOypfbku2W88FaA9UYGHuJQ6baMQ/sa5s
	tE+6Bl7ErUr6ZzVcMov2cXMW9kvtndzMSyieVgirTlHlHpyuSz26WtCyhxPg=
X-Gm-Gg: ASbGncsW/FnhDEkDlgNXyb31Z65N6pSqGCJ4tiqyaNGVepil0E6lAQyfC4od3Mf/lms
	2215RaiO14SHT54orEP0HH02MO8jsbBmi62a3/O/MR8+PzVEfye7x07oaUI5aNC5spXR0UWKYEv
	0N0WT6RsNQ0TRo/5hXpwqeVOn4rIB+HnaGLMXbYfBJcv132IYDUYFWSD1Ddhi8taJiPk8xJHJPl
	QCZBOOxVgiqQIHxfbKvIXqpFQuqPhjeRS0cGmZD0mnI8Q==
X-Google-Smtp-Source: AGHT+IG1Igjg7Lj7gyBotHkaOr88qr+/AW6ecrQKFY0fVvgzp9ilx0zWBzKIQZhk1MGEU1lX9SH1XCPz8iXPLRF8wwA=
X-Received: by 2002:a17:902:c947:b0:244:5089:ff44 with SMTP id
 d9443c01a7336-245e0526b5emr39407665ad.41.1755618028048; Tue, 19 Aug 2025
 08:40:28 -0700 (PDT)
Precedence: bulk
X-Mailing-List: syzbot@lists.linux.dev
List-Id: <syzbot.lists.linux.dev>
List-Subscribe: <mailto:syzbot+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:syzbot+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <68a38e69.050a0220.e29e5.00b3.GAE@google.com>
In-Reply-To: <68a38e69.050a0220.e29e5.00b3.GAE@google.com>
From: Marco Elver <elver@google.com>
Date: Tue, 19 Aug 2025 17:39:50 +0200
X-Gm-Features: Ac12FXwQbImAGDC48iMDsqh74DjGuG61bIe0lvrYRVduT6_T60SeCBfgyKshhzk
Message-ID: <CANpmjNPT_EjUH_dkopJQC-QTjPRKX9gYhO7WUA+cmnnAbWEjzw@mail.gmail.com>
Subject: Re: [moderation/CI] Re: net: Convert to skb_dstref_steal and skb_dstref_restore
To: syzbot ci <syzbot+cifa4f8269e9e14b21@syzkaller.appspotmail.com>
Cc: syzkaller-upstream-moderation@googlegroups.com, syzbot@lists.linux.dev
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

#syz upstream

On Mon, 18 Aug 2025 at 22:34, syzbot ci
<syzbot+cifa4f8269e9e14b21@syzkaller.appspotmail.com> wrote:
>
> syzbot ci has tested the following series
>
> [v2] net: Convert to skb_dstref_steal and skb_dstref_restore
> https://lore.kernel.org/all/20250818154032.3173645-1-sdf@fomichev.me
> * [PATCH net-next v2 1/7] net: Add skb_dstref_steal and skb_dstref_restor=
e
> * [PATCH net-next v2 2/7] xfrm: Switch to skb_dstref_steal to clear dst_e=
ntry
> * [PATCH net-next v2 3/7] netfilter: Switch to skb_dstref_steal to clear =
dst_entry
> * [PATCH net-next v2 4/7] net: Switch to skb_dstref_steal/skb_dstref_rest=
ore for ip_route_input callers
> * [PATCH net-next v2 5/7] staging: octeon: Convert to skb_dst_drop
> * [PATCH net-next v2 6/7] chtls: Convert to skb_dst_reset
> * [PATCH net-next v2 7/7] net: Add skb_dst_check_unset
>
> and found the following issue:
> WARNING in nf_reject_fill_skb_dst
>
> Full report is available here:
> https://ci.syzbot.org/series/74fec874-bca1-42a5-bb58-f3f49b95e348
>
> ***
>
> WARNING in nf_reject_fill_skb_dst
>
> tree:      net-next
> URL:       https://kernel.googlesource.com/pub/scm/linux/kernel/git/netde=
v/net-next.git
> base:      8159572936392b514e404bab2d60e47cebd5acfe
> arch:      amd64
> compiler:  Debian clang version 20.1.7 (++20250616065708+6146a88f6049-1~e=
xp1~20250616065826.132), Debian LLD 20.1.7
> config:    https://ci.syzbot.org/builds/10161afb-c9c1-4272-851c-1ded15995=
879/config
> C repro:   https://ci.syzbot.org/findings/7f681f6a-9952-49a0-8533-0bc1852=
91f81/c_repro
> syz repro: https://ci.syzbot.org/findings/7f681f6a-9952-49a0-8533-0bc1852=
91f81/syz_repro
>
> ------------[ cut here ]------------
> WARNING: CPU: 1 PID: 5862 at ./include/linux/skbuff.h:1165 skb_dst_check_=
unset include/linux/skbuff.h:1164 [inline]
> WARNING: CPU: 1 PID: 5862 at ./include/linux/skbuff.h:1165 skb_dst_set in=
clude/linux/skbuff.h:1211 [inline]
> WARNING: CPU: 1 PID: 5862 at ./include/linux/skbuff.h:1165 nf_reject_fill=
_skb_dst+0x2a4/0x330 net/ipv4/netfilter/nf_reject_ipv4.c:234
> Modules linked in:
> CPU: 1 UID: 0 PID: 5862 Comm: kworker/u8:2 Not tainted 6.17.0-rc1-syzkall=
er-00207-g815957293639-dirty #0 PREEMPT(full)
> Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS 1.16.2-debian-1.=
16.2-1 04/01/2014
> Workqueue: ipv6_addrconf addrconf_dad_work
> RIP: 0010:skb_dst_check_unset include/linux/skbuff.h:1164 [inline]
> RIP: 0010:skb_dst_set include/linux/skbuff.h:1211 [inline]
> RIP: 0010:nf_reject_fill_skb_dst+0x2a4/0x330 net/ipv4/netfilter/nf_reject=
_ipv4.c:234
> Code: 8b 0d 60 75 8b 08 48 3b 8c 24 e0 00 00 00 75 5d 48 8d 65 d8 5b 41 5=
c 41 5d 41 5e 41 5f 5d e9 03 91 67 01 cc e8 ad d0 aa f7 90 <0f> 0b 90 e9 38=
 ff ff ff 44 89 f9 80 e1 07 fe c1 38 c1 0f 8c 2b fe
> RSP: 0018:ffffc900001e0360 EFLAGS: 00010246
> RAX: ffffffff8a14dae3 RBX: ffff88810f943b00 RCX: ffff888109618000
> RDX: 0000000000000100 RSI: 0000000000000000 RDI: 0000000000000000
> RBP: ffffc900001e0490 R08: ffffffff8fa37e37 R09: 1ffffffff1f46fc6
> R10: dffffc0000000000 R11: fffffbfff1f46fc7 R12: ffff88810ec56101
> R13: dffffc0000000001 R14: 1ffff9200003c070 R15: 0000000000000000
> FS:  0000000000000000(0000) GS:ffff8881a3c1b000(0000) knlGS:0000000000000=
000
> CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> CR2: 0000000002f6a520 CR3: 0000000027716000 CR4: 00000000000006f0
> Call Trace:
>  <IRQ>
>  nf_send_unreach+0x17b/0x6e0 net/ipv4/netfilter/nf_reject_ipv4.c:325
>  nft_reject_inet_eval+0x4bc/0x690 net/netfilter/nft_reject_inet.c:27
>  expr_call_ops_eval net/netfilter/nf_tables_core.c:237 [inline]
>  nft_do_chain+0x40c/0x1920 net/netfilter/nf_tables_core.c:285
>  nft_do_chain_inet+0x25d/0x340 net/netfilter/nft_chain_filter.c:161
>  nf_hook_entry_hookfn include/linux/netfilter.h:158 [inline]
>  nf_hook_slow+0xc5/0x220 net/netfilter/core.c:623
>  nf_hook include/linux/netfilter.h:273 [inline]
>  NF_HOOK+0x206/0x3a0 include/linux/netfilter.h:316
>  __netif_receive_skb_one_core net/core/dev.c:5979 [inline]
>  __netif_receive_skb+0x143/0x380 net/core/dev.c:6092
>  process_backlog+0x60e/0x14f0 net/core/dev.c:6444
>  __napi_poll+0xc7/0x360 net/core/dev.c:7494
>  napi_poll net/core/dev.c:7557 [inline]
>  net_rx_action+0x707/0xe30 net/core/dev.c:7684
>  handle_softirqs+0x286/0x870 kernel/softirq.c:579
>  do_softirq+0xec/0x180 kernel/softirq.c:480
>  </IRQ>
>  <TASK>
>  __local_bh_enable_ip+0x17d/0x1c0 kernel/softirq.c:407
>  local_bh_enable include/linux/bottom_half.h:33 [inline]
>  rcu_read_unlock_bh include/linux/rcupdate.h:910 [inline]
>  __dev_queue_xmit+0x1d79/0x3b50 net/core/dev.c:4740
>  neigh_output include/net/neighbour.h:547 [inline]
>  ip6_finish_output2+0x11fe/0x16a0 net/ipv6/ip6_output.c:141
>  NF_HOOK include/linux/netfilter.h:318 [inline]
>  ndisc_send_skb+0xb96/0x1470 net/ipv6/ndisc.c:512
>  ndisc_send_ns+0xcb/0x150 net/ipv6/ndisc.c:670
>  addrconf_dad_work+0xaae/0x14b0 net/ipv6/addrconf.c:4282
>  process_one_work kernel/workqueue.c:3236 [inline]
>  process_scheduled_works+0xae1/0x17b0 kernel/workqueue.c:3319
>  worker_thread+0x8a0/0xda0 kernel/workqueue.c:3400
>  kthread+0x711/0x8a0 kernel/kthread.c:463
>  ret_from_fork+0x3fc/0x770 arch/x86/kernel/process.c:148
>  ret_from_fork_asm+0x1a/0x30 arch/x86/entry/entry_64.S:245
>  </TASK>
>
>
> ***
>
> If these findings have caused you to resend the series or submit a
> separate fix, please add the following tag to your commit message:
> Tested-by: syzbot@syzkaller.appspotmail.com
>
> ---
> This report is generated by a bot. It may contain errors.
> syzbot ci engineers can be reached at syzkaller@googlegroups.com.
>
> The email will later be sent to:
> [abhishektamboli9@gmail.com andrew@lunn.ch ayush.sawal@chelsio.com corete=
am@netfilter.org davem@davemloft.net dsahern@kernel.org edumazet@google.com=
 fw@strlen.de gregkh@linuxfoundation.org herbert@gondor.apana.org.au horms@=
kernel.org kadlec@netfilter.org kuba@kernel.org linux-kernel@vger.kernel.or=
g linux-staging@lists.linux.dev mhal@rbox.co netdev@vger.kernel.org netfilt=
er-devel@vger.kernel.org pabeni@redhat.com pablo@netfilter.org sdf@fomichev=
.me steffen.klassert@secunet.com]
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
-upstream-moderation/68a38e69.050a0220.e29e5.00b3.GAE%40google.com.
