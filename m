Received: from mail-pl1-f182.google.com (mail-pl1-f182.google.com [209.85.214.182])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2A55F47D92B
	for <syzbot@lists.linux.dev>; Tue, 18 Aug 2026 19:07:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.214.182
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787080050; cv=pass; b=BMIbepZydcSCYoK0rA0rqrIgi4gCXLI+WuE7c/zeE2colu1iK8INcyJycd2o2Vd86UVLDltvZuAnzAT21CMPv7sZnOjh/N8o0RkR8XIDlOpaVeoYrEkmsg5bYuR9xcRPDLDTnRe4VZGeeskSk2bibueHGjltV05dCgZ6gRs246U=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787080050; c=relaxed/simple;
	bh=Is9MCFNc7/20DnChPckLIHgGZL9bLFqw+45O+6OPt0g=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=X2eHz/UIkNQavImOeHUj3+OHU2UMq3hYpvR7/sYDdKySs26r6A61jM+IlS4v2NZgvL7qdINmHXJAFfVk6uPYSiOkaYFl3POGeoycXOxVXyA68D1Z4wUS6VQBCNksW/R8rPH8idUxeDv4iErrm+f72C47HgcrkC4ZkyJf5M74I4U=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=iNK1d1wU; arc=pass smtp.client-ip=209.85.214.182
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="iNK1d1wU"
Received: by mail-pl1-f182.google.com with SMTP id d9443c01a7336-2d530328efbso1809365ad.0
        for <syzbot@lists.linux.dev>; Tue, 18 Aug 2026 12:07:29 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1787080048; cv=none;
        d=google.com; s=arc-20260327;
        b=m8xUBEucJ/hBiXyhH9LzKSA4YfNCE3Q2YkSUJ5RSdV5DwxrAYG67CIPuzITWUU8hMY
         s4g24HmgLPFH99Kf+OW8SQwz9HHPH54GOe3TqYAwVfVv1b1TZeISQbiG+b5v2eO1BuFZ
         prKwi3+SsPZ95MjSog4h2IHZG/nWGhcg13aAEnpwQ50tIO5DHgRw14+Qnt0vKv62DGfr
         GvwhHL1wpVAiQsVHMvRY6IF+EZSiDI/ytxwVJGJ0Bk6fLJbtMDkJZ0pXmB+KW1zhjVdY
         5FxsX92CkFDFY6x5+8vV4F/7uAy1PbapHjK0hZIXz2HcCt9LDOCxSRsJhXRWODAzrnT5
         9yKw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:dkim-signature;
        bh=oUCREIIXdjJGeCx/q9kSDHSgFV+2sXnjOVCcQC2SM84=;
        fh=coF6kfMinbIXMSvdKVHjSdViJaxd2/nTX07fYzZDQzY=;
        b=ZEwio78XqXNeLOwe0cwScy0FsDalIoPxUtpglpdDcjBnGf7XORCPFTpvXzSi8lTW9a
         d6kZvuGkmnbuDfzBerPt+JBTgQvgPBeOjckyWD8E2QYGByLhNaWV7fU8Dzze9AIqvwl5
         DxpKSy4seWRnhV3Ou1w1TjOsrPNHinWjNj1adQr3AENrPClA3SNYxfiwptrOTFOcLuo/
         OSuG5vjfthMWyZ8GVoLLqNVBknB9rM6T7QZiuMtj636PMV6oDBO3OTC8fLFZbuzZZV+5
         BQHNXb2O98Piu6r+wGEAbEzG6yq7BCQj5wOe8vzNReG/XPBzzmb9dyJUum6yb19G7csz
         TMzw==;
        darn=lists.linux.dev
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1787080048; x=1787684848; darn=lists.linux.dev;
        h=content-type:cc:to:subject:message-id:date:from:in-reply-to
         :references:mime-version:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=oUCREIIXdjJGeCx/q9kSDHSgFV+2sXnjOVCcQC2SM84=;
        b=iNK1d1wUIr1c7SxKpX+6VSjpXwJU1FLnzzLZMba9UMYUyQojkJR5i5HI8zKMjmuBU8
         BM5UhAcArM2hwhcleq8z0GZzDyIT7/LlJUTseHKK2rayxOt4J3RVkCpkIYSuCDvav7tz
         fASphkl/fx/IfK61P8OQIOwJyYp1hKD1A6uw1DDcEK8d1SL4qLQaKCFRky3jQrVcO9oZ
         OTDduyPECF/JvXyrth/nFTpIH53A2ljvYBeIycPpvsI3FyxNAj74m4nEz5OCvQ1AU3Sz
         XcVlK2UQ1pIetkxlzccwgCX6OZfGZv1lAyjYydnCWmAkjp4XvDs9FHdCB9tpMJiqyLvR
         cTHA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1787080048; x=1787684848;
        h=content-type:cc:to:subject:message-id:date:from:in-reply-to
         :references:mime-version:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to:content-type;
        bh=oUCREIIXdjJGeCx/q9kSDHSgFV+2sXnjOVCcQC2SM84=;
        b=f7Ds8Xj0VhAifSR0yqIVI37qDZr0kX+GhGFwwWiB9Zo3K/vC3AL4xSGDiSKRD2qEGi
         gPyqnB+59N1OLLRimEF/Uvq4e8Y30/MsB5NEv3y+FKoR/YdkbagJvyVxPH6cWRFlNUf5
         0i+8vy5nZ/YPdq5qssiFZA6fiNdYMJ1U1OzSftrLLb9r6OlouhPbnmjnl8PBsj4ud/e3
         GE6KrbsY1NwBX8oOY1x/T1FilmiCW/+m8znfMQQCNss1Wfd3WiwNg0XCS0WglKRK7rSn
         U2Ms+SmRxnJmGybD1j1m1P0Qn1IAGB60oocMH/I+OTpFM1zqWQhRHAZgLFHAb6d0Zlpu
         +Kmw==
X-Forwarded-Encrypted: i=1; AHgh+RoQhN+MLjc3xIfBa2CtSTnO/ANRYh+KQekLnn9EFk6xKcaKam311aXv/z4vbwzDHFkdNhqYCTE=@lists.linux.dev
X-Gm-Message-State: AOJu0YznvzmaUZLqcoTijM+Mb7PrJ75CaU5ZRsmWCIuHyBp5At654SLA
	dHMBKlzWe3/V/hHv5px3rIAhJDp8DHC013lcLoyiyflG5Xjq4IKC6HilqcWBFautomZzWmSM7nB
	ZSOnylA6teOD/Aoyvdlr249ZgtqSZAy+jW8y4LBmFZnF633JJM9KCg+Zm
X-Gm-Gg: AR+sD10nymITMwXTzmQLtXdMu5tpW33M74jRr5wKldVw4btRfTrYV7rKdk78Yo6+KDC
	ZwrZiW+wYsNVRV1ueF3iOv5mZz4OFy/mO+bMxZ1sgcO8XVjBdCN4nePiNkz7h1fT+Mdt9e81BgL
	bzcS9sUzLXkey+89Fcf5M03qXbEl8b9QeLOE71ZXvxyFuRHFCEmnOwEdMSFnnCkRCZu2gN1xrjn
	PAi4gKSC8WS2Vqz+YxSFh/vvbbPN/lNGbqDwGkZbQdaZJbTYiTlsQiywBx2yVgfCoYsqJ9Gmjg4
	ep1NYC7l8BVkB60YbTyHhLnc3pQp7EFKNKPq4KzvagzvBznKqklTSEBlOK1ur973AxmvwEX2yVe
	J
X-Received: by 2002:a17:90b:4a4d:b0:37f:fb1d:63fa with SMTP id
 98e67ed59e1d1-3955a7dfc5cmr12369715a91.15.1787080047473; Tue, 18 Aug 2026
 12:07:27 -0700 (PDT)
Precedence: bulk
X-Mailing-List: syzbot@lists.linux.dev
List-Id: <syzbot.lists.linux.dev>
List-Subscribe: <mailto:syzbot+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:syzbot+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <23b6e672-549a-4fd9-b731-9bfdc16148ea@mail.kernel.org>
In-Reply-To: <23b6e672-549a-4fd9-b731-9bfdc16148ea@mail.kernel.org>
From: Marco Elver <elver@google.com>
Date: Tue, 18 Aug 2026 21:06:50 +0200
X-Gm-Features: AcwNN1VykKXQn45rCZX95IX93eCpWATH55O4qVKzt23OnAzc2aBvtZ1QL1aq1tU
Message-ID: <CANpmjNMusov3xpSNiT9Hag6-vyjmLVU4dudJGcNJ5wqmYtMq0g@mail.gmail.com>
Subject: Re: [PATCH RFC v2] rxrpc: Fix use-after-free in rxrpc_destroy_all_peers()
To: syzbot <syzbot@kernel.org>
Cc: syzkaller-upstream-moderation@googlegroups.com, syzbot@lists.linux.dev
Content-Type: text/plain; charset="UTF-8"

Can we please add some code comments (1-3 lines max, properly
formatted) explaining why the rcu_barrier() and the spin_lock are
needed respectively? Having all this in the commit message is fine,
but will get lost.

On Tue, 18 Aug 2026 at 18:27, syzbot <syzbot@kernel.org> wrote:
>
> During network namespace teardown, rxrpc_destroy_all_peers() iterates over
> the rxnet->peer_hash table to print leaked peers. However, it does so
> without holding rxnet->peer_hash_lock. This allows a race condition with
> asynchronous peer destruction, where RCU callbacks concurrently remove
> peers from the hash table and free them. When rxrpc_destroy_all_peers()
> accesses the freed peer, it results in a KASAN slab-use-after-free.
>
> BUG: KASAN: slab-use-after-free in rxrpc_destroy_all_peers+0xcc/0x150
> net/rxrpc/peer_object.c:461
> Read of size 8 at addr ffff88811089e420 by task kworker/u8:1/13
> Call Trace:
>  <TASK>
>  rxrpc_destroy_all_peers+0xcc/0x150 net/rxrpc/peer_object.c:461
>  rxrpc_exit_net+0x7f/0xc0 net/rxrpc/net_ns.c:114
>  ops_exit_list net/core/net_namespace.c:199 [inline]
>  ops_undo_list+0x43d/0x8d0 net/core/net_namespace.c:252
>  cleanup_net+0x572/0x810 net/core/net_namespace.c:702
>  process_one_work kernel/workqueue.c:3322 [inline]
>  process_scheduled_works+0xa8e/0x14e0 kernel/workqueue.c:3405
>  worker_thread+0x92d/0xe10 kernel/workqueue.c:3486
>  kthread+0x388/0x470 kernel/kthread.c:436
>  ret_from_fork+0x514/0xb70 arch/x86/kernel/process.c:158
>  ret_from_fork_asm+0x1a/0x30 arch/x86/entry/entry_64.S:245
>  </TASK>
>
> To fix the slab-use-after-free, acquire rxnet->peer_hash_lock with
> spin_lock_bh() while iterating over rxnet->peer_hash in
> rxrpc_destroy_all_peers().
>
> Additionally, insert rcu_barrier() in rxrpc_exit_net() prior to destroying
> peers and local endpoints. Without rcu_barrier(), rxrpc_destroy_all_peers()
> races with pending RCU callbacks that drop peer and local references,
> logging spurious leak warnings. Furthermore, this missing synchronization
> causes a downstream panic hazard in rxrpc_destroy_all_locals() because
> in-flight peer releases leave rxnet->local_endpoints populated. Calling
> rcu_barrier() ensures all pending RCU callbacks that drop peer and local
> references complete prior to leak checks and local endpoint destruction.
>
> Fixes: 17226f124038 ("rxrpc: Fix leak of rxrpc_peer objects")
> Assisted-by: Gemini:gemini-3.6-flash Gemini:gemini-3.1-pro-preview syzbot
> Reported-by: syzbot+c876adfab6362679008c@syzkaller.appspotmail.com
> Closes: https://syzkaller.appspot.com/bug?extid=c876adfab6362679008c
> Link: https://syzkaller.appspot.com/ai_job?id=ca098ef4-2067-4197-977f-d5d409f27cb8
> To: "David S. Miller" <davem@davemloft.net>
> To: "David Howells" <dhowells@redhat.com>
> To: "Eric Dumazet" <edumazet@google.com>
> To: "Jakub Kicinski" <kuba@kernel.org>
> To: <linux-afs@lists.infradead.org>
> To: "Marc Dionne" <marc.dionne@auristor.com>
> To: <netdev@vger.kernel.org>
> To: "Paolo Abeni" <pabeni@redhat.com>
> Cc: "Simon Horman" <horms@kernel.org>
> Cc: <linux-kernel@vger.kernel.org>
>
> ---
> v2:
> - Added rcu_barrier() in rxrpc_exit_net() before peer and local endpoint teardown.
> - Updated commit message to detail how rcu_barrier() prevents spurious leak warnings and downstream panics in rxrpc_destroy_all_locals().
>
> v1:
> https://lore.kernel.org/all/efbfa532-8931-4227-9ba4-701ac86a342e@mail.kernel.org/T/
> ---
> diff --git a/net/rxrpc/net_ns.c b/net/rxrpc/net_ns.c
> index 9a9834145..6895f51b7 100644
> --- a/net/rxrpc/net_ns.c
> +++ b/net/rxrpc/net_ns.c
> @@ -111,6 +111,7 @@ static __net_exit void rxrpc_exit_net(struct net *net)
>         timer_delete_sync(&rxnet->peer_keepalive_timer);
>         rxrpc_destroy_all_calls(rxnet);
>         rxrpc_destroy_all_connections(rxnet);
> +       rcu_barrier();
>         rxrpc_destroy_all_peers(rxnet);
>         rxrpc_destroy_all_locals(rxnet);
>         proc_remove(rxnet->proc_net);
> diff --git a/net/rxrpc/peer_object.c b/net/rxrpc/peer_object.c
> index fa9a406e1..d81ed180e 100644
> --- a/net/rxrpc/peer_object.c
> +++ b/net/rxrpc/peer_object.c
> @@ -454,6 +454,8 @@ void rxrpc_destroy_all_peers(struct rxrpc_net *rxnet)
>         struct rxrpc_peer *peer;
>         int i;
>
> +       spin_lock_bh(&rxnet->peer_hash_lock);
> +
>         for (i = 0; i < HASH_SIZE(rxnet->peer_hash); i++) {
>                 if (hlist_empty(&rxnet->peer_hash[i]))
>                         continue;
> @@ -465,6 +467,8 @@ void rxrpc_destroy_all_peers(struct rxrpc_net *rxnet)
>                                &peer->srx.transport);
>                 }
>         }
> +
> +       spin_unlock_bh(&rxnet->peer_hash_lock);
>  }
>
>  /**
>
>
> base-commit: db2ddb87143519e20a95aa36c60b36107b736a58
> --
> This is an AI-generated patch subject to moderation.
> Reply with '#syz upstream' to Sign-off the patch as a human author
> and send it to the upstream kernel mailing lists.
> Reply with '#syz reject' to reject it ('#syz unreject' to undo).
>
> See https://goo.gle/syzbot-ai-patches for information about AI-generated patches.
> You can comment on the patch as usual, syzbot will try to address
> the comments and send a new version of the patch if necessary.
> syzbot engineers can be reached at syzkaller@googlegroups.com.
