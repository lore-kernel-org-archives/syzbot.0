Received: from mail-pj1-f50.google.com (mail-pj1-f50.google.com [209.85.216.50])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CDBC029408
	for <syzbot@lists.linux.dev>; Wed, 23 Jul 2025 09:08:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.50
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1753261686; cv=none; b=nE5sdheKEazRZCe/Eb5IGLdNdlPWQomFq8fLINMW37DWBLfP18wy9Jk9VTEKIVSUV3Tz+ENQj/x8vUYkFCWyq1I39XmX7k45RjPzTZGRG7eDl5/CBSZTdaJ00Wl6wtgHeeHml0Q4t3sLfXRIo19HO5346Mfogx5FxMd/X/P7Z8E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1753261686; c=relaxed/simple;
	bh=RCAO9D+vcPEF9Ex9Ba91x9WeOo6DBI9DPFAss1nxkoc=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=gAksAwxVl+2eVCxW0QnRtHYcU57t/w5Yon38KdEKegWhvIogKA+E25/ofGAgT9yrEU6C0HPIWb32fVLIItwSFJ3ETuXidRMCE4yJviE6qYR9RaHqCfnb/Xkol+PO0z3XXm8LWIkCaZUJ35ppNfCTtJyWQt1lz9nOniUWfooCUQQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=mD4TFShQ; arc=none smtp.client-ip=209.85.216.50
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="mD4TFShQ"
Received: by mail-pj1-f50.google.com with SMTP id 98e67ed59e1d1-3134c67a173so6525011a91.1
        for <syzbot@lists.linux.dev>; Wed, 23 Jul 2025 02:08:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1753261684; x=1753866484; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=LQliMJroMz4lYADbdn2etD4d0/85yFKCaOpmaj9bboY=;
        b=mD4TFShQs6zg/Cf5kDJ4bcZLah3SNuUioX047rYZDY1p334Tr+cEi8MF2aNUCFsMq/
         v5QiMP40VzxisZHTmDnimCvna5G8iBH94VlR/WuB/CqUhWQOsh4D8xeRHKcVVnwvcyBp
         grbje3JLN/YP0XDZ7oowkhTHFP6VZ+MBZtEduhraB6GpbZs5iz5KWBNIbZseDSjAzewA
         UkrNyMsfNWYpExQt2ND9ycszL8GJBpQvDGVot332hFybEYmAvvEaCKFJHzWFhJEjdDf5
         U8PKfqIBoZ5nCZLD+3YogxwzFcvpPs9EdvfLvSRb8JDJJLODqzuUEdIW8QNLq5GukllH
         AjyA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1753261684; x=1753866484;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=LQliMJroMz4lYADbdn2etD4d0/85yFKCaOpmaj9bboY=;
        b=jroOLH2zqPzGEbxvcTaO8Kexm70olrHTXHdzwQKskmOTB2ZrGI1JC5W2xp2lmkwZK6
         cd+Ek2ONlK6MOZqwONK/sRC3B9AkiIRbGgcZcJs5dEQ+mKDdePZWzoV6Rp6bJCGvcqfS
         XeI1MhzVHuAJRI4s7x6g65FMd48KCOjyzfwqax//If6xa+G3D4mSLHFPb+wap/VNL4nI
         nc2P7Y7j1FKtwj6fpxML6m6T3wHqo2VdqqGXEScGQjAsYVVprqe3byVVjPxz3+JuaBo/
         H3GVqXELy/ObVia20rRNOCeQsYVk55rNFk1dcZ62PZ2i5k980NncAz/6KBYdv+BcvOBF
         +uJg==
X-Forwarded-Encrypted: i=1; AJvYcCW+HhQvYxNxzLF4hM7A3ezDSs6+vjY28vrPF3/MIqxxe6EBPbUJSEygsvJhwFh35PvCjfR6VfI=@lists.linux.dev
X-Gm-Message-State: AOJu0Yyn9jGbeBgm9siLLbUjQNnkg7U0nO7b15DWvZkPZOOwqV2Qdk1h
	lbHinrj9ypmEQ1KTS4NINDgdCmYmYddsiY8RwuGfYCr52zWMPrAqFJZUDzA9wj8GnFXMOHnSL2y
	RpGWkYbzEU5W9qC6FuAhloYe8XpvEc34VKjKh+1Pn
X-Gm-Gg: ASbGncuNrBb0+MHlf8FkzhSwrqFXWycVhUI7GpS7PfvZbzNBqqk+cN4NEGgri0/rZwO
	MAunLQ/mbwiG9IkgBkk83tWSZr+abME+UEZl5mb6Yk+wW8RidYm/ZXdfOILnFMOoXWEshzvji1F
	uaf/ikbXIkMWEkvH97T8zsSGv9W//J6gq18LpjCxGcmsm2A6xwVpuNFf+y1C0D+b7oIItKt1Q+J
	3uLtfa6gFJ54MNQdIjjjm5OSbS+XW3Fseg=
X-Google-Smtp-Source: AGHT+IFWCNlqIag2rAdlqXI0S9VHnIM934aVi+EzYgRBQoiceVFaRpsIK8hbs6O1iHQZP4gDlN3j1/00GTikrHeV8po=
X-Received: by 2002:a17:90a:d643:b0:312:e9d:3ffa with SMTP id
 98e67ed59e1d1-31e507e82bcmr3201099a91.31.1753261683880; Wed, 23 Jul 2025
 02:08:03 -0700 (PDT)
Precedence: bulk
X-Mailing-List: syzbot@lists.linux.dev
List-Id: <syzbot.lists.linux.dev>
List-Subscribe: <mailto:syzbot+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:syzbot+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <68803314.a70a0220.693ce.010e.GAE@google.com>
In-Reply-To: <68803314.a70a0220.693ce.010e.GAE@google.com>
From: Aleksandr Nogikh <nogikh@google.com>
Date: Wed, 23 Jul 2025 11:07:52 +0200
X-Gm-Features: Ac12FXwT-P1FnXIZCRlsXea9OeHqg4xICzjbAxSyjXEWCwz1HH1_H99J6paVrOk
Message-ID: <CANp29Y478FWaVBSJRPsLehitCi3GqjX9i-PFSqBDLM0KPaw2Ng@mail.gmail.com>
Subject: Re: [moderation/CI] Re: vrf: Drop existing dst reference in vrf_ip6_input_dst
To: syzbot ci <syzbot+ci1ec3e0769f39071b@syzkaller.appspotmail.com>
Cc: syzkaller-upstream-moderation@googlegroups.com, syzbot@lists.linux.dev
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

#syz upstream

On Wed, Jul 23, 2025 at 2:55=E2=80=AFAM syzbot ci
<syzbot+ci1ec3e0769f39071b@syzkaller.appspotmail.com> wrote:
>
> syzbot ci has tested the following series
>
> [v1] vrf: Drop existing dst reference in vrf_ip6_input_dst
> https://lore.kernel.org/all/<20250722210256.143208-1-sdf@fomichev.me>
> * [PATCH net 1/2] vrf: Drop existing dst reference in vrf_ip6_input_dst
> * [PATCH net 2/2] net: Warn when overriding referenced dst entry
>
> and found the following issue:
> WARNING in nf_reject_fill_skb_dst
>
> Full report is available here:
> https://ci.syzbot.org/series/c92e1af5-3b8b-4c26-8104-acca93ad8939
>
> ***
>
> WARNING in nf_reject_fill_skb_dst
>
> tree:      net
> URL:       https://kernel.googlesource.com/pub/scm/linux/kernel/git/netde=
v/net.git
> base:      cf074eca0065bc5142e6004ae236bb35a2687fdf
> arch:      amd64
> compiler:  Debian clang version 20.1.7 (++20250616065708+6146a88f6049-1~e=
xp1~20250616065826.132), Debian LLD 20.1.7
> config:    https://ci.syzbot.org/builds/235c4af3-77ea-4670-9c9e-9de1ef0a5=
aa6/config
> syz repro: https://ci.syzbot.org/findings/1038832f-72d8-4491-9ac9-28339d3=
1f0f7/syz_repro
>
> ------------[ cut here ]------------
> WARNING: CPU: 1 PID: 12 at ./include/linux/skbuff.h:1165 nf_reject_fill_s=
kb_dst+0x313/0x3b0
> Modules linked in:
> CPU: 1 UID: 0 PID: 12 Comm: kworker/u8:0 Not tainted 6.16.0-rc6-syzkaller=
-00135-gcf074eca0065-dirty #0 PREEMPT(full)
> Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS 1.16.2-debian-1.=
16.2-1 04/01/2014
> Workqueue: ipv6_addrconf addrconf_dad_work
> RIP: 0010:nf_reject_fill_skb_dst+0x313/0x3b0
> Code: 8b 0d f1 35 98 08 48 3b 8c 24 e0 00 00 00 75 6b 48 8d 65 d8 5b 41 5=
c 41 5d 41 5e 41 5f 5d e9 54 19 69 01 cc e8 9e 7e b8 f7 90 <0f> 0b 90 e9 43=
 ff ff ff e8 90 7e b8 f7 90 0f 0b 90 e9 e3 fe ff ff
> RSP: 0018:ffffc900001e0360 EFLAGS: 00010246
> RAX: ffffffff8a07aa52 RBX: ffff888110f75500 RCX: ffff88801c2f5640
> RDX: 0000000000000100 RSI: 0000000000000000 RDI: 0000000000000000
> RBP: ffffc900001e0490 R08: ffffffff8fa1d6f7 R09: 1ffffffff1f43ade
> R10: dffffc0000000000 R11: fffffbfff1f43adf R12: ffff888110f75501
> R13: dffffc0000000001 R14: 1ffff9200003c070 R15: 0000000000000000
> FS:  0000000000000000(0000) GS:ffff8881a3c22000(0000) knlGS:0000000000000=
000
> CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> CR2: 00002000000000c0 CR3: 000000001ff6e000 CR4: 00000000000006f0
> Call Trace:
>  <IRQ>
>  nf_send_unreach+0x17b/0x700
>  nft_reject_inet_eval+0x4bc/0x690
>  nft_do_chain+0x40c/0x1920
>  nft_do_chain_inet+0x25d/0x340
>  nf_hook_slow+0xc5/0x220
>  NF_HOOK+0x206/0x3a0
>  __netif_receive_skb+0x143/0x380
>  process_backlog+0x60e/0x14f0
>  __napi_poll+0xc7/0x480
>  net_rx_action+0x707/0xe30
>  handle_softirqs+0x286/0x870
>  do_softirq+0xec/0x180
>  </IRQ>
>  <TASK>
>  __local_bh_enable_ip+0x17d/0x1c0
>  __dev_queue_xmit+0x1cd7/0x3a70
>  ip6_finish_output2+0x11fe/0x16a0
>  ndisc_send_skb+0xc77/0x1500
>  ndisc_send_ns+0xcb/0x150
>  addrconf_dad_work+0xaae/0x14b0
>  process_scheduled_works+0xae1/0x17b0
>  worker_thread+0x8a0/0xda0
>  kthread+0x711/0x8a0
>  ret_from_fork+0x3fc/0x770
>  ret_from_fork_asm+0x1a/0x30
>  </TASK>
>
>
> ---
> This report is generated by a bot. It may contain errors.
> syzbot ci engineers can be reached at syzkaller@googlegroups.com.
>
> The email will later be sent to:
> [andrew@lunn.ch davem@davemloft.net dsahern@kernel.org edumazet@google.co=
m horms@kernel.org kuba@kernel.org linux-kernel@vger.kernel.org netdev@vger=
.kernel.org pabeni@redhat.com sdf@fomichev.me]
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
-upstream-moderation/68803314.a70a0220.693ce.010e.GAE%40google.com.
