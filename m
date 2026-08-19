Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4124E31716B
	for <syzbot@lists.linux.dev>; Wed, 19 Aug 2026 09:12:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=100.103.45.18
ARC-Seal:i=3; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787130746; cv=pass; b=Ptlemz/qUwTmF0Rvkf6NYam4h9nMdk1tU1Z8xdleuy6HaQRupWUvz0/hOLPG3SqC1erTp4TwE/7OIx5NlH3yEGuuJy0nU5ZFUT1YjR/HfTebtQEzvwNQjGIPYH1CvgvpEKhF15pgx9V0OlsPezOZltMZBm2Y/crOca67jIHqnig=
ARC-Message-Signature:i=3; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787130746; c=relaxed/simple;
	bh=0jsVKaplioDI3RfvqV6dH1N41jEKVm3dnCsuuH8ktx4=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=q2+vFg4HZ1zbkmP0E7aj+2Mjj2gH18zi01XDtA3dc5nGLt22jqBP0iNOB0BZdkd2gA+BLE+a8N697IjqhUKPZU4zLzUDp9eJ60Uhftsl6gnUKqBFO9wJXFEPHKs6nFrdZEN4FS5hDPghI8fS+o78i2JSOMclRDLkDputYql1WcA=
ARC-Authentication-Results:i=3; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=Y6xBFpyr; arc=pass smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="Y6xBFpyr"
Received: by smtp.kernel.org (Postfix)
	id 286041F00A3F; Wed, 19 Aug 2026 09:12:25 +0000 (UTC)
Authentication-Results: smtp.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=74.125.224.43
ARC-Seal: i=2; d=kernel.org; s=arc20260519; a=rsa-sha256; cv=pass;
	t=1787130745;
	b=dLgFU4LmJD75hbzSXCbkfgHkBERP0uFqydYgAz0Cm5vqDJT2HQeyKFtbhX+C4I3x11+W
	 r1rv3eFpbRDHN7W1j4xv9PNR23Y1KEzR6uX8LUUYv56QoRzaHH9TEfWT0z0K0t83v3CZo
	 YCZgGnpL1waazBl1TkvbJ12UKixwFGQ0/OcFSXoVmvSngyhlKlpHpTWr/IH9fbEiLPIWC
	 ZV2xTobAIwBDlZOzv+b5JoArb8ueQ9sxEjdn8NvcYbP1bzcwf7Z+38xz3jiUxuCXZLBm5
	 T0C4rGtyldJX/dhRZ0+GukZDGK/eoOqpTMrEitZoguCFqx2C7lW8SxAvadKDjQNm9yA==
ARC-Message-Signature: i=2; d=kernel.org; s=arc20260519; a=rsa-sha256;
	c=relaxed/relaxed; t=1787130745;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Gm-Message-State:X-Gm-Gg:X-Received:MIME-Version:References:
	 In-Reply-To:From:Date:X-Gm-Features:Message-ID:Subject:To:Cc:
	 Content-Type;
	bh=E4gB6En5WX+1P6pIBA/eVdZpLbYsPByTdzKBMJ7oGB8=;
	b=ApRGRtgSqsxhQdkVsRNdHYtT/kjn1R6XXYaHdol+5VBc7K0lBp0EZOdc0Xp4EXTIo3fN
	 czC6tMB1A+N9brZUbxcR/lo/WWoUyKG05/2LQSdUthstk8NefY63A1cbTQoUHp/XCl6pT
	 h7C2Phow/nOvMkPpxC/NuLMRZV2Z0j/GJy9qmq7qyNEl62C0DaoHqtVvLaKNItJ/uaJhA
	 PtUkXQHNst9o9oEx0tsRrLiQD8CbMM2uaSh0hCgGJcKCsw9H3asVXtY/2JX8z/prF2NJG
	 utQZrY3pxZtMVLtnHwLOjGbwLiN5hH/YYeyZOLewqhTZqrsntnie9Lyktf0CDEeLCPQ==
ARC-Authentication-Results: i=2; smtp.kernel.org; dkim=pass header.d=google.com header.i=@google.com header.a=rsa-sha256 header.s=20251104 header.b=Y6xBFpyr;
	dmarc=pass header.from=google.com;
	spf=pass smtp.mailfrom=google.com;
	arc=pass header.oldest-pass=0 smtp.remote-ip=74.125.224.43
Received: from mail-yx1-f43.google.com (mail-yx1-f43.google.com [74.125.224.43])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.kernel.org (Postfix) with ESMTPS id 7ECF81F00A3A
	for <syzbot@kernel.org>; Wed, 19 Aug 2026 09:12:24 +0000 (UTC)
Authentication-Results: smtp.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=google.com header.i=@google.com header.a=rsa-sha256 header.s=20251104 header.b=Y6xBFpyr
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.kernel.org 7ECF81F00A3A
Authentication-Results: smtp.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.kernel.org; spf=pass smtp.mailfrom=google.com
Received: by mail-yx1-f43.google.com with SMTP id 956f58d0204a3-66c711b7f2aso1407693d50.3
        for <syzbot@kernel.org>; Wed, 19 Aug 2026 02:12:24 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1787130743; cv=none;
        d=google.com; s=arc-20260327;
        b=ZT6Gz51MJ8qSlqBIsElwU7IZxF4RGlTwukDz+mZz74cQeobJT8c0fuhkplGCf8P9j5
         Q6c+pn4NmmKApAlffQfmqeKm2ZifoArnKSeTLJ3fknue0eXRKptjyhy9WzUWeFSFsPoc
         s0kp+nKz3U0tLTjxeZyr7nRJ1/4WpcUqZOsrxUhp+JLbZeemJzcY6EM3Sstn7sfr4tR4
         PSrN+usXSmAd8YmZbuJV4x0bPWUD80IbCrKNiUBic53gkXJfcA5Zgio80EOEQy8Z4UZL
         BKfOEXTOPl9l9mTOyFGoqHYqlVnwvn6h7BYb94g8pWMDh3twuCMnKeKAIJ41ffJajyyy
         OHDw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:dkim-signature;
        bh=E4gB6En5WX+1P6pIBA/eVdZpLbYsPByTdzKBMJ7oGB8=;
        fh=2Ld/g5BVZzBadtquf8mrXl84q+iOtbUed/2ECOFnmmI=;
        b=OgRLY49FjSbdTYeKA07tayPjhZUTS6B1ZELTtZ9KcSmDkZHnbfHLsVjS+RHHRPX+bk
         Y3k2xW9Ny3uwlGlFVpFvwYFFsJaFp9ehmiLya7/PWYrk5gNXR/ZtxLHiW5sE+ba5Bxpx
         yE+yAjkquOHnFTrOseSj9Xw3oFtVeVjU0DlG8vAFMXSeJdeFcWf8+XJw/Z9UTmBF0y3e
         9dwKvjGpDAC4QzoQw1UGNB/HnbGanqjdsr9MPWrTgrT4Swa0nQUZgT0la+4uL5nTXYK4
         TBY8v9diCrkls8uWIYM0VsMNOFmdLSUsUwDfDRMdFCZ2Y6k02xuRoyPtvPY5JtElYqwL
         t2Nw==;
        darn=kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1787130743; x=1787735543; darn=kernel.org;
        h=content-type:cc:to:subject:message-id:date:from:in-reply-to
         :references:mime-version:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=E4gB6En5WX+1P6pIBA/eVdZpLbYsPByTdzKBMJ7oGB8=;
        b=Y6xBFpyrutiOSpG3TKszGknteMyGDWUwvgeYXQOijF/MKlu2szTERFP+dh8z0XR3Db
         R2UWw/XNy4OqQhFMNaSWYIT6SoOjUgXumiL7kTt/LvFm7Jr3KX7plT3MfpbD5tpDaF7K
         9Nzfj+krMC3g2+KFGHPKbsn1hWWs7N4ebMIGrhxsuP4GU9aAB33zqqO1AzikzDoN761V
         hCphfyky6WwEHmFdOH/c7RywnF3eLS3BFETUG6G5LLVXQJSZe3XZTjUCIrHrf4yGMYA2
         MtHf5PzTVfWavFa+NRiYBr+BhIh/IXeagpUMlMA8BhPPWI+juB6UIVIZDyVF1HnJEjYM
         PJrQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1787130743; x=1787735543;
        h=content-type:cc:to:subject:message-id:date:from:in-reply-to
         :references:mime-version:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to:content-type;
        bh=E4gB6En5WX+1P6pIBA/eVdZpLbYsPByTdzKBMJ7oGB8=;
        b=PCGDHL5CWKsjHyAitST6yFnqGK95JnYODUpV5S4c6poGu2nC7Li8BtsntmHVaA/X+V
         /pPH/JWQ4KV97QUZo362ekl0/Y3TSBIyWqmqIjDoVcesEklUcFbd72zcGSTVRBWrLNpj
         iV80dP+Zy9b+2puTFuLk0AmI5y3vm4ozn+6ZG44fn6+Hi0cPlAkcVgNCp/35mKREJKwm
         norCyG3uIZCQtx971pbKMDcew3COQ4WJXmhONCvEYse0omffA4xa+kAgohysiTvn18D0
         iIqeKrAMm47fCTevaBa4/rBnsRD85/KSo86B9FXxXnl2pJiyW+ySAYwB4rGq3dHKoXLF
         VQGg==
X-Gm-Message-State: AFuF++mw/yXNwAsT2yd44wl9Wf2nK7XeRWL0oXVEUwKJfkz6pXGASZyg
	qPI0Pbr6cQx/YHOBi6l1CgHjJkmQUZChIWeNtKlZeft+8PvivVRhpBnqSSmbKN39GJfmOLRyH9n
	XjDfBm1R7RxhbghdTzAfjOgKCxGU9YW40/dcaGz3czMgXtl+eJRDevdIJ
X-Gm-Gg: AR+sD13Cs5WUguR7l25+Mtd5XJQHOH/HEr9uuDlywFDmGC/YzxFXcDVmN74NyRtKvLd
	gFe73WCfviUCZ4cK802AX/rPFVlpsGChOf6HU7yrRdP51vBuZY7T7Sobp8z5hhCi4V06aply8un
	q7/sZvbl8MEYzqfQtBetrY3iWvjotp8jf2aoHHOpLMlVFxwO3hZdpVdwbRo2nujYpAxgBk+SQw5
	rPaOe8OYijKvQxJfKycY+lX7/CHvt4f6a7seCZc6n0BgA6kzUg7Fc/G6x75GE0iwzLbHAuJ5noG
	tRokj+83wYV+Gf0dnBi694ZOxFKRf1cS4KFYRBBMgUrIQMpIrY6x1wSp1eFXz8mfkaj4B780zOU
	m
X-Received: by 2002:a53:c80d:0:b0:668:172a:47a7 with SMTP id
 956f58d0204a3-66ccb6ce373mr938464d50.25.1787130741936; Wed, 19 Aug 2026
 02:12:21 -0700 (PDT)
Precedence: bulk
X-Mailing-List: syzbot@lists.linux.dev
List-Id: <syzbot.lists.linux.dev>
List-Subscribe: <mailto:syzbot+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:syzbot+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <61c18ade-b0ce-426a-9c62-a7a1e550fe46@mail.kernel.org>
In-Reply-To: <61c18ade-b0ce-426a-9c62-a7a1e550fe46@mail.kernel.org>
From: Marco Elver <elver@google.com>
Date: Wed, 19 Aug 2026 11:11:44 +0200
X-Gm-Features: AcwNN1X-h2fcf_uBotHkG-2UVTKAss0yIeDrs7Gri8wJoGL9j3cJVPCOlJMwEkA
Message-ID: <CANpmjNMhiiiZvtD3of5aCw2qp06dFsDrLUxBK09tC-F2hkPOEA@mail.gmail.com>
Subject: Re: [PATCH RFC v3] rxrpc: Fix use-after-free in rxrpc_destroy_all_peers()
To: syzbot <syzbot@kernel.org>
Cc: syzkaller-upstream-moderation@googlegroups.com, syzbot@lists.linux.dev
Content-Type: text/plain; charset="UTF-8"

#syz upstream

On Tue, 18 Aug 2026 at 22:52, syzbot <syzbot@kernel.org> wrote:
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
> Link: https://syzkaller.appspot.com/ai_job?id=7fecbeb2-cd9b-4ca2-8149-48663e20b153
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
> v3:
> - Added inline comments explaining the purpose of rcu_barrier() in rxrpc_exit_net() and peer_hash_lock acquisition in rxrpc_destroy_all_peers().
>
> v2:
> - Added rcu_barrier() in rxrpc_exit_net() before peer and local endpoint teardown.
> - Updated commit message to detail how rcu_barrier() prevents spurious leak warnings and downstream panics in rxrpc_destroy_all_locals().
> https://lore.kernel.org/all/23b6e672-549a-4fd9-b731-9bfdc16148ea@mail.kernel.org/T/
>
> v1:
> https://lore.kernel.org/all/efbfa532-8931-4227-9ba4-701ac86a342e@mail.kernel.org/T/
> ---
> diff --git a/net/rxrpc/net_ns.c b/net/rxrpc/net_ns.c
> index 9a9834145..c00cddfd3 100644
> --- a/net/rxrpc/net_ns.c
> +++ b/net/rxrpc/net_ns.c
> @@ -111,6 +111,11 @@ static __net_exit void rxrpc_exit_net(struct net *net)
>         timer_delete_sync(&rxnet->peer_keepalive_timer);
>         rxrpc_destroy_all_calls(rxnet);
>         rxrpc_destroy_all_connections(rxnet);
> +       /*
> +        * Wait for pending RCU callbacks that drop peer and local
> +        * references to avoid spurious leak warnings and panics.
> +        */
> +       rcu_barrier();
>         rxrpc_destroy_all_peers(rxnet);
>         rxrpc_destroy_all_locals(rxnet);
>         proc_remove(rxnet->proc_net);
> diff --git a/net/rxrpc/peer_object.c b/net/rxrpc/peer_object.c
> index fa9a406e1..32da76256 100644
> --- a/net/rxrpc/peer_object.c
> +++ b/net/rxrpc/peer_object.c
> @@ -454,6 +454,12 @@ void rxrpc_destroy_all_peers(struct rxrpc_net *rxnet)
>         struct rxrpc_peer *peer;
>         int i;
>
> +       /*
> +        * The lock is needed to prevent use-after-free if a peer is being
> +        * destroyed concurrently by an RCU callback.
> +        */
> +       spin_lock_bh(&rxnet->peer_hash_lock);
> +
>         for (i = 0; i < HASH_SIZE(rxnet->peer_hash); i++) {
>                 if (hlist_empty(&rxnet->peer_hash[i]))
>                         continue;
> @@ -465,6 +471,8 @@ void rxrpc_destroy_all_peers(struct rxrpc_net *rxnet)
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
