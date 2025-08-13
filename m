Received: from mail-pj1-f52.google.com (mail-pj1-f52.google.com [209.85.216.52])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A945F2DEA7D
	for <syzbot@lists.linux.dev>; Wed, 13 Aug 2025 07:55:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.52
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755071741; cv=none; b=RyU6Jo2Bj563AcdnEKjG0HQnatySezMK2nZxjWMJkBMsYWBux9uFM1Cz60hL0ig5AACDqneszRHEUWajdJ6f+gPKSHBqpV30YAeRUIhRB5GVNnNzHk9+x1yZ630ZsnqKDK31IykSYTf2kSXpN8/v4je8W87QM4l3tQ2zu7f71sA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755071741; c=relaxed/simple;
	bh=4W02RqRdRjgIiBernF8QGv3aKx9C919dRkBDia3/Phs=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=atBnk0P6uMKM9kYTPpnVlnpLmcHLP4wID2mDapBmlV49YVlnC/E8KNJvJ7E/3MEAlU8i68JZFVaGkECLtth8QB5NuiAYC30/c9MqsW5kMc/6lyx2dJyoCtJIACFo9XTn2Pl/OhukZkY61IEy+bQ65bMULFmcUDl4pC4tQfwYKis=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=KAAYm3dv; arc=none smtp.client-ip=209.85.216.52
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="KAAYm3dv"
Received: by mail-pj1-f52.google.com with SMTP id 98e67ed59e1d1-321a5d6d301so2268118a91.3
        for <syzbot@lists.linux.dev>; Wed, 13 Aug 2025 00:55:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1755071739; x=1755676539; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=1qIBjMIvBY3D6owj0BDmhAn/Tfte2yzkx12tXNhizdQ=;
        b=KAAYm3dvpsLNG0IGotxCEkJ0Xtjq5JZG/BEAw1k9qk9iAX3Y+m8LS9B3P01bldoQje
         0L9fNn/DH6qi7HkrBeI9ilx6eZRv924q0rOx+Prta6HR1/0xCIEuBfpehdu8Rk8b8Vqr
         EBOROO8bGyJaStsLdQKbnNYJ6dfhgLwDngGOUOc7e00V4nlxeAuvoc5beS5HD5cA5SxH
         8TmY409hosVixXmNgiTLZJ3fSTt3+9XMusq5/qSCwnT/PsNRzUyoK2qqXlg5dVTHBdFo
         F48QuZDjioMfrbfq6M4CDJomjmly/6xRbIK029oEPIyPEtKCKxaI/6FNpDHF8jiC32Y/
         E4tA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1755071739; x=1755676539;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=1qIBjMIvBY3D6owj0BDmhAn/Tfte2yzkx12tXNhizdQ=;
        b=gsZxD8zfCkXVIdh4OGuxX3tFzF8RDqDZpy0LZrwIuTP7sRw6ncfcXtVaVcB7DNLcC/
         UIk2eiEscnEPM9Z6mWVO5D7ezu4BAOsTjzo8tQKZj3YPYtuLceaMUhGlZtWtVV1/ZXKd
         7Y1X4mKve5aOF5oRnqM7iaii4t7AKHTmOFGK6LDz3D0ElfgclUbzhIoN2rjJwdJ0JlPs
         WPXenjRSAxoQa+NJe9PPOSFL/dSLAPmPqceoY+NRc2ll1hCA8GfZtxsQokv7umqepmAd
         R9xrEFIYibj3m/OfJt8letW9sNjm3LRKqtJIRSc9uPG7Cqo5/9vzjfz2XiSVuGVcikZW
         h+iQ==
X-Forwarded-Encrypted: i=1; AJvYcCWV0PPoH/Xa3UUIkb9jmP3cDgXuiggIsznJLEvA2WF8UYYnCOSPOBoWLZ9CsWb/ONEnkvCeUm4=@lists.linux.dev
X-Gm-Message-State: AOJu0YwtxST9Vbj74IZtOYytShFtcfl8Kf4roIwoF0m30p5rIMbKA9wU
	SAQn6QU53synZNS9yfSq1F38tBbbFK/LUe5+FAM9wFAVSwMtqPOp8A39BqS0PYPOOm2H2EWFWaE
	PlkdFWUP444XV8kcV2O5DDfdtFwEsY3IfT9ilrum6
X-Gm-Gg: ASbGncsXSPThSAivQlalAEC4wVBWFH7dQ84XM5Yhz7GnEyQ3Ap6Kc5DljgSs1sF6vMi
	9u9QZ1PtcPuH9b/xFATv3YSHrX6n5mlNa40AGlF32oO5woXQAZaxQ+UXqvVwNOhHyxPO0Te9V6I
	3LVdgTEyCm2kve06O43Cco6isEDPP3RJdYHV60PoZEQdoq8kT6VXcaoBhmebjJ/3Nyf674yEeLH
	TeyLEZySllf8t996VH7E0rGYAXbHZ3VnHkK/Q==
X-Google-Smtp-Source: AGHT+IHse8zneuZiOCBI2Xc8Ui2ZgdB+OwWk97w9xnyzvTT4Bg60Iy+IxrypHIph4GI5cf0mRNPQPOL99VaGRSRwppo=
X-Received: by 2002:a17:90b:180c:b0:321:4182:2b9e with SMTP id
 98e67ed59e1d1-321d0ddbde8mr3042987a91.12.1755071737345; Wed, 13 Aug 2025
 00:55:37 -0700 (PDT)
Precedence: bulk
X-Mailing-List: syzbot@lists.linux.dev
List-Id: <syzbot.lists.linux.dev>
List-Subscribe: <mailto:syzbot+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:syzbot+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <689be2e1.050a0220.7f033.013e.GAE@google.com>
In-Reply-To: <689be2e1.050a0220.7f033.013e.GAE@google.com>
From: Aleksandr Nogikh <nogikh@google.com>
Date: Wed, 13 Aug 2025 09:55:25 +0200
X-Gm-Features: Ac12FXwz7x6_731Qj8D05zcLFLLb5HxUYewsYuQEmdJEfoNohenLCVD3T8rEzBY
Message-ID: <CANp29Y6UVbrK=2KWT8VFomEptB7NBhEijfqoS0wPgydgBxFK=w@mail.gmail.com>
Subject: Re: [moderation/CI] Re: net: Convert to skb_dst_reset and skb_dst_restore
To: syzbot ci <syzbot+ci3cb22cefbd0c9566@syzkaller.appspotmail.com>
Cc: syzkaller-upstream-moderation@googlegroups.com, syzbot@lists.linux.dev
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

#syz upstream

On Wed, Aug 13, 2025 at 2:57=E2=80=AFAM syzbot ci
<syzbot+ci3cb22cefbd0c9566@syzkaller.appspotmail.com> wrote:
>
> syzbot ci has tested the following series
>
> [v1] net: Convert to skb_dst_reset and skb_dst_restore
> https://lore.kernel.org/all/20250812155245.507012-1-sdf@fomichev.me
> * [PATCH net-next 1/7] net: Add skb_dst_reset and skb_dst_restore
> * [PATCH net-next 2/7] xfrm: Switch to skb_dst_reset to clear dst_entry
> * [PATCH net-next 3/7] netfilter: Switch to skb_dst_reset to clear dst_en=
try
> * [PATCH net-next 4/7] net: Switch to skb_dst_reset/skb_dst_restore for i=
p_route_input callers
> * [PATCH net-next 5/7] staging: octeon: Convert to skb_dst_drop
> * [PATCH net-next 6/7] chtls: Convert to skb_dst_reset
> * [PATCH net-next 7/7] net: Add skb_dst_check_unset
>
> and found the following issue:
> WARNING in nf_reject_fill_skb_dst
>
> Full report is available here:
> https://ci.syzbot.org/series/dcc132bc-db4e-4a0b-a95c-9960b8a48d10
>
> ***
>
> WARNING in nf_reject_fill_skb_dst
>
> tree:      net-next
> URL:       https://kernel.googlesource.com/pub/scm/linux/kernel/git/netde=
v/net-next.git
> base:      37816488247ddddbc3de113c78c83572274b1e2e
> arch:      amd64
> compiler:  Debian clang version 20.1.7 (++20250616065708+6146a88f6049-1~e=
xp1~20250616065826.132), Debian LLD 20.1.7
> config:    https://ci.syzbot.org/builds/2aac43d4-6d95-49c6-8e28-28941fdb3=
117/config
> C repro:   https://ci.syzbot.org/findings/0af27fa7-d0b6-43d6-8965-58fbc54=
ca186/c_repro
> syz repro: https://ci.syzbot.org/findings/0af27fa7-d0b6-43d6-8965-58fbc54=
ca186/syz_repro
>
> ------------[ cut here ]------------
> WARNING: CPU: 1 PID: 5901 at ./include/linux/skbuff.h:1165 skb_dst_check_=
unset include/linux/skbuff.h:1164 [inline]
> WARNING: CPU: 1 PID: 5901 at ./include/linux/skbuff.h:1165 skb_dst_set in=
clude/linux/skbuff.h:1210 [inline]
> WARNING: CPU: 1 PID: 5901 at ./include/linux/skbuff.h:1165 nf_reject_fill=
_skb_dst+0x2a4/0x330 net/ipv4/netfilter/nf_reject_ipv4.c:234
> Modules linked in:
> CPU: 1 UID: 0 PID: 5901 Comm: kworker/u8:3 Not tainted 6.16.0-syzkaller-1=
2063-g37816488247d-dirty #0 PREEMPT(full)
> Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS 1.16.2-debian-1.=
16.2-1 04/01/2014
> Workqueue: ipv6_addrconf addrconf_dad_work
> RIP: 0010:skb_dst_check_unset include/linux/skbuff.h:1164 [inline]
> RIP: 0010:skb_dst_set include/linux/skbuff.h:1210 [inline]
> RIP: 0010:nf_reject_fill_skb_dst+0x2a4/0x330 net/ipv4/netfilter/nf_reject=
_ipv4.c:234
> Code: 8b 0d 60 b1 8b 08 48 3b 8c 24 e0 00 00 00 75 5d 48 8d 65 d8 5b 41 5=
c 41 5d 41 5e 41 5f 5d e9 03 8d 67 01 cc e8 cd 6c ab f7 90 <0f> 0b 90 e9 38=
 ff ff ff 44 89 f9 80 e1 07 fe c1 38 c1 0f 8c 2b fe
> RSP: 0018:ffffc900001e0360 EFLAGS: 00010246
> RAX: ffffffff8a143ee3 RBX: ffff888110b91200 RCX: ffff88810a3d8000
> RDX: 0000000000000100 RSI: 0000000000000000 RDI: 0000000000000000
> RBP: ffffc900001e0490 R08: ffffffff8fa34737 R09: 1ffffffff1f468e6
> R10: dffffc0000000000 R11: fffffbfff1f468e7 R12: ffff888011c5c101
> R13: dffffc0000000001 R14: 1ffff9200003c070 R15: 0000000000000000
> FS:  0000000000000000(0000) GS:ffff8881a3c21000(0000) knlGS:0000000000000=
000
> CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> CR2: 000000c003cc5000 CR3: 000000010fc16000 CR4: 00000000000006f0
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
>  __napi_poll+0xc7/0x360 net/core/dev.c:7489
>  napi_poll net/core/dev.c:7552 [inline]
>  net_rx_action+0x707/0xe30 net/core/dev.c:7679
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
 gregkh@linuxfoundation.org herbert@gondor.apana.org.au horms@kernel.org ka=
dlec@netfilter.org kuba@kernel.org linux-kernel@vger.kernel.org linux-stagi=
ng@lists.linux.dev mhal@rbox.co netdev@vger.kernel.org netfilter-devel@vger=
.kernel.org pabeni@redhat.com pablo@netfilter.org sdf@fomichev.me steffen.k=
lassert@secunet.com]
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
-upstream-moderation/689be2e1.050a0220.7f033.013e.GAE%40google.com.
