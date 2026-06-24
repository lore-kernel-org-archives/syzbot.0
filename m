Received: from mail-oo1-f43.google.com (mail-oo1-f43.google.com [209.85.161.43])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 05F0D2DE70D
	for <syzbot@lists.linux.dev>; Wed, 24 Jun 2026 11:52:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.161.43
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782301981; cv=pass; b=hN1MQNC1PMwr+ASAYnkxekV8ZGLCp7cwM3/0E3Hi8FrUYZ6GquTtsr1/O8gWLmNKuFEQysR4r7m7+QKsgMI8Cap0EOrPqV+T9bHD68IU3Q7rR/nVcrWuMLO54XHKq0/ln1mSTpD5nsm1JdG8h+oi5H5/oBN3W2yKRGaKu/MbE5E=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782301981; c=relaxed/simple;
	bh=32LIHWpuXg9VDoZGdSDPhAEfL3hktIx5S6S+702ftgI=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=rR18lVJaokCrflrxSYUsXL39c4tXkuT0LOlpA2a3KowqCa8Z6JnmUMKpuQmbV0tDxbVlUB9BvNDMN7xiCtMPtQbzYI/6dw7F3IXWzdIZ6l0fdfRUAu4SAyqvR4ED+/ZmN1GMDL3yPre2iQDDp1Up1PkKNxq77P3t4bcSN6yKQiE=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=TbRbiotu; arc=pass smtp.client-ip=209.85.161.43
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="TbRbiotu"
Received: by mail-oo1-f43.google.com with SMTP id 006d021491bc7-69e1eae4eb4so704232eaf.2
        for <syzbot@lists.linux.dev>; Wed, 24 Jun 2026 04:52:59 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1782301979; cv=none;
        d=google.com; s=arc-20240605;
        b=PdLPvEmNNQ6UwjjxHb6zmaDzmULYqxU5DQmNqlyuCFKmkWDOM2x1EU1XmRuZaoXlV6
         TkeR/0ua5UfFjAqwEGu4HSHHaRWp14RamIynzwCz/0PxscWf+Kg2lq1GdZOzphvlmQD7
         Jjb0rU5vNWJpfPXxpECrMtu6FGrusugIaimeBU6g8sqcpX/fnsv8w54wig7UGadyBfvd
         Iy/XO/kSqXcD4WqIB4T/2GQ6As51y7VpbTSSCCtlEF6FJ9wqNruqh+4+0uJWVqQK/Edd
         jPErD9lr/kDAqAlUFaEW9YwqagfCUpVoqbIjgAx4Pze8VfxZg2PY2fqZ5FbfrFnUSohf
         +2sQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=7WSeRft3fJR2NyyIpUlEtprUWSwYfvJiSte046NYL2w=;
        fh=2Gct4ccS2PkM2xxmywm03KppIuFi5fchLKeoijFqo3c=;
        b=OlDfyqOdeF5hiHfiDRWVfMEv1v6OtD9ONkQ8fAIaK7InlsaWGeqiPH/d7+i9Jccnt+
         wBWx//6wuWohHfCr08TsZ5N5czKgEzROXFzN+h5AO0/UzkUCkmfmuXw2RLlrevw96d4U
         4NVGoA0ybQbKMWWppHqeiOeE9LXadrNsUU06n2I1eKH6GYO3WsEJEG2zM9FL+WdAC4j+
         wJUHjdO3gELz2oRV2hhpcpUjxR21pr0VOPvfmjkJNKtrzUbuMySGbvIgLRPuu+11otZz
         9Fg7je7YZYBHFnkwJh15Hr9uiu8Q6/Y08/ZSmVWyisszEGaWclnm7KRwREvOIU3oqiAK
         20Kw==;
        darn=lists.linux.dev
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1782301979; x=1782906779; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=7WSeRft3fJR2NyyIpUlEtprUWSwYfvJiSte046NYL2w=;
        b=TbRbiotufy7OWFfVADazHqkykj/VKtVPZbpPn6U9wr03OtNhwlabhqNXhaUmWlnycE
         496xouNwp/eDMqytcMZgk+bGhocmLqp5v1CXnincw/SV27dyzFGNL7eeEwwqGNcOFdXC
         SeptorxxCsGztqK4J+4r+a+wT1YrvhXAwYt45Iyu+kU8Rag1/wJYJjk6aap2rRVEnHsq
         ME46/78feaR+p45mIj8IMvCVzMncYDZL4SzPUjs1xs4d9KjqNTaJ/xdhX2BuO7DDnmQ9
         tzfIektZE85VoM1VjhzuhvPiAaVVCO4LMvduRcjlz7vsYGJV0iFT9x+iXc2qsFM+QcY1
         8DZw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1782301979; x=1782906779;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=7WSeRft3fJR2NyyIpUlEtprUWSwYfvJiSte046NYL2w=;
        b=UpDVARKQsViXUvnS9krMnxSphgQk9qfEfR/TnGQU+wKnVOuiRoBxu+wCL9PerssRmi
         dWTQ8iPFbBFjfIwCNgILkK0kefVcfRc+NhKe2EcqCYTO8JPVBfw/iomaG8Q2D+JFVXuG
         7qofW2/eEByNxvrIG3uH0NqgMxz++WXB0hVs934KBG1uPbEEaZYJC1qDYTJyZWuv5m5a
         p8SiNt8bbPamM2B5U/CF3BFKauGMws7eQH56+rdnzXoisadvsozFjkIoDlWwW0n9m5TF
         GU1N3NfHjwTa9oiRdeSctei7NUIimFEkQfmDxPdAp6eynCGoXRGG9Jdt1+ZzQaF2pDr7
         YAbg==
X-Forwarded-Encrypted: i=1; AFNElJ8G3FuPh1JFydNfg4fvXF+R1k7IUYslHXwMxDCqNr1P5ozobXmKvkxegyhTeKZ9iFrPnCPUgUY=@lists.linux.dev
X-Gm-Message-State: AOJu0YybgfrPjDatB9bqVBUrSEBdckkidyxgStYCWqSoqFqIg6NQ4/uW
	uylS+QAErpsYn+GNUQx2OOtLYz3hbTiNzetlgY0ylewJk0NCxzCiryBQIbZLvT3VPJ7IhGuJBLN
	t3y8AFoJqdf0bc1HEPlY/Gwe4pb3MhqFPyZfkFLKN
X-Gm-Gg: AfdE7cldekgFOyuBR+UJc4v5fJLt9spUSUs1H+HwR5OFbKiau7Q8OUGt1AnfcyDrmOw
	c9C0HWK8hzkGuBdUW0EJ6MDRUPINcLe9tBvxGu7YseHUb3500vzuoCWIZ9v3RmSCVvR1ypqafNK
	/TWV7lbSbnPF89MinfnEDNPr+2UVdT8QrL0U5hqUcPD1sTVn2cSqLd6j/9bGkXGMvNJqU30Us06
	DMQdFIL2ukiuTogrZHa6atXIQphAs4mt5rEnS7VAa+DER8szLuiKL7VQNGx8qkIo76RC3ajE4qb
	3hK9Qp9DK6LLMqglWCoyKd8uSfgS9t9WwGSeIujAkz577gGuGfYRI2+HaljCyeNO6pBeP0fJpza
	o1v60oHKGi7B5knXxWULomC+zjA==
X-Received: by 2002:a05:6820:808:b0:6a1:1f3a:8629 with SMTP id
 006d021491bc7-6a11f3a87bdmr2787912eaf.23.1782301978407; Wed, 24 Jun 2026
 04:52:58 -0700 (PDT)
Precedence: bulk
X-Mailing-List: syzbot@lists.linux.dev
List-Id: <syzbot.lists.linux.dev>
List-Subscribe: <mailto:syzbot+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:syzbot+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <6a3bc40e.ac6cd362.bc7d6.0003.GAE@google.com>
In-Reply-To: <6a3bc40e.ac6cd362.bc7d6.0003.GAE@google.com>
From: Aleksandr Nogikh <nogikh@google.com>
Date: Wed, 24 Jun 2026 13:52:47 +0200
X-Gm-Features: AVVi8CeENWWPPBv-mOBjLJqMf8ENyR15u80jD5FTs7bGTJNMqcAg5vbipXIEUgA
Message-ID: <CANp29Y6FigRAX=i=nDfASxnJBzHAZUMcZ=Hp_MfwUPxh8ouCPA@mail.gmail.com>
Subject: Re: [moderation/CI] Re: net: clear transport header during tunnel decapsulation
To: syzbot ci <syzbot+cic115a49afd959330@syzkaller.appspotmail.com>
Cc: syzkaller-upstream-moderation@googlegroups.com, syzbot@lists.linux.dev
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

#syz upstream

On Wed, Jun 24, 2026 at 1:48=E2=80=AFPM syzbot ci
<syzbot+cic115a49afd959330@syzkaller.appspotmail.com> wrote:
>
> syzbot ci has tested the following series
>
> [v1] net: clear transport header during tunnel decapsulation
> https://lore.kernel.org/all/20260624073209.3703492-1-edumazet@google.com
> * [PATCH net] net: clear transport header during tunnel decapsulation
>
> and found the following issue:
> WARNING in geneve_udp_encap_recv
>
> Full report is available here:
> https://ci.syzbot.org/series/1f6dc47e-354f-4904-bc18-c2b7ea4d79b2
>
> ***
>
> WARNING in geneve_udp_encap_recv
>
> tree:      net
> URL:       https://kernel.googlesource.com/pub/scm/linux/kernel/git/netde=
v/net.git
> base:      d87363b0edfc7504ff2b144fe4cdd8154f90f42e
> arch:      amd64
> compiler:  Debian clang version 22.1.6 (++20260514074242+fc4aad7b5db3-1~e=
xp1~20260514074407.73), Debian LLD 22.1.6
> config:    https://ci.syzbot.org/builds/7bb83c16-d55d-4d99-8c2b-6050e0022=
ef6/config
>
> ------------[ cut here ]------------
> !skb_transport_header_was_set(skb)
> WARNING: ./include/linux/skbuff.h:3094 at geneve_udp_encap_recv+0x26ed/0x=
4130, CPU#1: kworker/1:3/5072
> Modules linked in:
> CPU: 1 UID: 0 PID: 5072 Comm: kworker/1:3 Not tainted syzkaller #0 PREEMP=
T(full)
> Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS 1.16.2-debian-1.=
16.2-1 04/01/2014
> Workqueue: mld mld_ifc_work
> RIP: 0010:geneve_udp_encap_recv+0x26ed/0x4130
> Code: c8 00 00 00 0f b6 04 01 84 c0 0f 85 f2 18 00 00 48 8b 7c 24 78 66 4=
4 89 6f 0a e8 7e 9b 7a 03 e9 8c 00 00 00 e8 f4 fc 33 fb 90 <0f> 0b 90 e9 2e=
 e3 ff ff 49 83 c6 06 4c 89 f0 48 c1 e8 03 48 b9 00
> RSP: 0018:ffffc90000a08620 EFLAGS: 00010246
> RAX: ffffffff8691f92c RBX: ffff8881bcc8b5d0 RCX: ffff88816a7abb80
> RDX: 0000000000000100 RSI: 000000000000ffff RDI: 000000000000ffff
> RBP: ffffc90000a08790 R08: ffffffff903114f7 R09: 1ffffffff206229e
> R10: dffffc0000000000 R11: fffffbfff206229f R12: ffff888109f6a108
> R13: 1ffff110213ed5df R14: 0000000000000010 R15: dffffc0000000000
> FS:  0000000000000000(0000) GS:ffff8882a927b000(0000) knlGS:0000000000000=
000
> CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> CR2: 00007f6956ea5440 CR3: 000000016f55c000 CR4: 00000000000006f0
> Call Trace:
>  <IRQ>
>  udp_queue_rcv_one_skb+0xfc5/0x10e0
>  udp_unicast_rcv_skb+0x21a/0x3a0
>  udp_rcv+0xecb/0x1db0
>  ip_protocol_deliver_rcu+0x27e/0x440
>  ip_local_deliver_finish+0x3bb/0x6f0
>  NF_HOOK+0x336/0x3c0
>  NF_HOOK+0x336/0x3c0
>  process_backlog+0xa34/0x1860
>  __napi_poll+0xaa/0x330
>  net_rx_action+0x61d/0xf50
>  handle_softirqs+0x225/0x840
>  do_softirq+0x76/0xd0
>  </IRQ>
>  <TASK>
>  __local_bh_enable_ip+0xf8/0x130
>  __dev_queue_xmit+0x1ed7/0x37f0
>  ip6_output+0x337/0x540
>  NF_HOOK+0x177/0x4f0
>  mld_sendpack+0x890/0xe10
>  mld_ifc_work+0x839/0xe70
>  process_scheduled_works+0xa8e/0x14e0
>  worker_thread+0xa47/0xfb0
>  kthread+0x388/0x470
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
> To test a patch for this bug, please reply with `#syz test`
> (should be on a separate line).
>
> The patch should be attached to the email.
> Note: arguments like custom git repos and branches are not supported.
>
> The email will later be sent to:
> [davem@davemloft.net dsahern@kernel.org edumazet@google.com eric.dumazet@=
gmail.com horms@kernel.org idosch@nvidia.com kuba@kernel.org netdev@vger.ke=
rnel.org pabeni@redhat.com syzbot@syzkaller.appspotmail.com]
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
-upstream-moderation/6a3bc40e.ac6cd362.bc7d6.0003.GAE%40google.com.
