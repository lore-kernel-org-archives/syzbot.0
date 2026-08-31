Received: from mail-qt1-f180.google.com (mail-qt1-f180.google.com [209.85.160.180])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 373F34F7978
	for <syzbot@lists.linux.dev>; Mon, 31 Aug 2026 15:00:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.160.180
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788188409; cv=pass; b=Q/RezF5y57HAZsVcbNiGLiYTdliqm/GgsWNt3EKa2mAJR6ujPjxS04xG7i/uAeLr6kmjN0gFU+saBbEvePjqsVxX472L7dA/BzQytGiWj2FgR/XSPf/TCEl2f3IM/2FK2rT7uhHi8wROLk7c+94fBrliAfs3jLxE+mLlEnH25E4=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788188409; c=relaxed/simple;
	bh=wJfBEfLv+Rwg7Tjw7PXm4/IPo+26W/5qnu3XOen5aCs=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=h1UqCJ3Q+PvfkZIPXDEP5gRaryST4dtPrjmOeJOdAGXQ0fFpemUCJMiMR0jXVrr4DTEIMOw64atKvnc5il35TWsJNHpY07qM1vDilJ9WBQGs++fnvHi5HvD+b3rmkRznQhjZ7pmyJmQCUSPTdBKALm/sTcKCa5DkHEB3WnkeFdA=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=l15yC/Ft; arc=pass smtp.client-ip=209.85.160.180
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="l15yC/Ft"
Received: by mail-qt1-f180.google.com with SMTP id d75a77b69052e-51bfad59921so35190281cf.0
        for <syzbot@lists.linux.dev>; Mon, 31 Aug 2026 08:00:07 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1788188406; cv=none;
        d=google.com; s=arc-20260327;
        b=gqMd6lQoOvYVjydMTQ5ORqFSkq7LzkQuizqymLhWV9Y96VRtHiVblwkNYeE//QXy5p
         AyhkSm+fp7FdIBUgbyLMqUDlXOcYK6qUgMowtJ+GFn9rvTwUGFjGnZDMkrVuS6xn6UVu
         eWXlu2maV6SVFabPemY56CuVkXbIjUgNk1L5nkiIK/VDPXl359o/NjuKOFxQZKRSgiiu
         LJLrWhlCMTJojOvmIjbtt3RZ8PlicWrv5Lj1Em3fMZqy4r3i7zwG/lPU+QNUMDBPGoqR
         LgEjwJPaA2lBlCRJIfFrfgMRvwONB3/iYmb8P+xbwN5CAf4F7iM0DiUAP0YdXSTF283c
         jM7w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=ieLlYx0vyeXO3RjHlzi38YD4dkPfW6u9uvQpCQ5tCDY=;
        fh=a/88Gy0NZoPNod2UL0j9/K9p4PBp++L8019AJBVMkZI=;
        b=DIHt92JsMoambTxJ7UcUJx76QcgPvmxX7XhQ2JnYdZKv2x0o4wr2S9L9KwlpanmyD0
         P/Ufss1cvnzFbVoR55Xj+t1yqOjReN9UYMNMrlzCSD+lUJhFj/nIMmoFMvdM5sxJNotB
         zh2dtWUNSk0Eo9yqJfD14oaKFCds60LCzUIdbpzBcKP11Zcl5n2jyr9Dqyl0wo/nuxQn
         YjYpGN92qhnHr/VY58qq3+UjboHvfzxzSqkMBAQV2KKAf6SKVmlySOKGcc55GwTXBgA7
         xlMI3UseG+vILfOVDP/KWsfTCCl5aiRC+SOTTsBLoQbx+Pg5WX0hlK9HndIodSu8QhSp
         7xDg==;
        darn=lists.linux.dev
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1788188406; x=1788793206; darn=lists.linux.dev;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=ieLlYx0vyeXO3RjHlzi38YD4dkPfW6u9uvQpCQ5tCDY=;
        b=l15yC/FtgKxlQ3C0R0m2W/w+l9QOrWOG2cXQBEx2iQFydRMBkcATFEagNvPs2NXAIV
         GPwHVoZdCQ1xK6Xi2fgOTF+02WUsDKdjFXub6P4y1quPUnLDVZMEUV1S0NKjpG18WXdS
         TVDCwWI3hWGG9n9M6UbCj0gXRZ+xry3J+SwtNN56lGtGeNDqjgYROJi6iMPiIoeXM9R7
         GAy69wuOlxbjVKLCcAt03cSoZ6hsGbHNtPX1YcGBz5wnyl3ih+oD59LetuHsoHCzM9Ms
         E71H3jucmhv1JiHomhoCZz24M2Hm70tPq4zUZZO//+EY2gAtzy7y8hBICDJ4seVg+Gk0
         xCng==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1788188406; x=1788793206;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=ieLlYx0vyeXO3RjHlzi38YD4dkPfW6u9uvQpCQ5tCDY=;
        b=S14oyEzn92r0w4vkrjim7FNff+B5KEzl3FFsQ3NgxLYE5Sp47joN34UMahaCslTcIu
         7cS+DyT07+HtOOKNWD8+iGR1fpk7rstR3TFW4CLji89KgelMOzlrKcnCiu1WmAWagA3h
         +BlbCtPyAqzDbNPVWRAhn+hxOO00GTy2qGwLz8D5tf6AeUV4YTH6Idfbk0fBxr6QKPDY
         0gtL7NNe7lRdKZEwRCBDY3JdKL5jNgFvC1Zsb8M+1Kt2gXwFcoCHDzGwkiTPLBUgFncz
         vMrk2UgbBvH/66OUfC8FmDn4iClUesJzqK50PKb74yveEpdRQv0It997dIRU7Kdd8BKh
         Ui4w==
X-Forwarded-Encrypted: i=1; AHgh+RqtLAyMFjvvaInqe+uSp2D5tImBfko6JNN3WdtzhKNIKHixLx9d7anid1bIyVWQqN4px3FKbhI=@lists.linux.dev
X-Gm-Message-State: AFuF++mr7WMiyIMVuCBTpfgPfSWcKpAQh9Mqgz2xIFpbZkkPG7S2RAYG
	UqNaI0NJQ+lUotv7vVRy1cGXip9U9UXLG63j++8AQY/WOIxkGvQOTA3TPRp+fGwYOuoKsgjR2OC
	JHNQxor8rRhtKwhDeoNr5D8QOZfzg5+UpejVRVjWe
X-Gm-Gg: AR+sD13PiYgUlGALm0knczHeJGsmnQ0SPMrxQF1rmIWQQfioP+pgJiNDixUmNnhvAHG
	JaB4K+KcosLdZCv3V/Jc0X6b4FupW6YDkt5RpUaSad3Hug7TyH6y6OzEpAPwfsy4HN4LlkqDM0k
	g1Cw5Y9KzZLftB1Iy8/SYZgtzeFhb1DrufdrKyoB5k/pxS9+Wk7IxHTro7YqhcsgzZY1h3MecKs
	BIZDdMPHmNnCQ+Zp3Ms26/KQQ1+hZEMVjany3fn5j8cNFfaTlseKP0n/tCFr1T1BmfRIrbANrLg
	MeCQzCYjnhl4eB5eppLPUh1S0ui7djBJyYfF/ru9tvfp4EC2/I/eieak9bncDadmPvEW3Bk0P/d
	saAZloU4e07dm2SWQF3NPbnXHu6zToU4pOeNyn8sgpeNYKz8SfVBZzk9i2A==
X-Received: by 2002:a05:622a:2512:b0:530:4ed:c251 with SMTP id
 d75a77b69052e-53021b9e3b4mr18674631cf.12.1788188404846; Mon, 31 Aug 2026
 08:00:04 -0700 (PDT)
Precedence: bulk
X-Mailing-List: syzbot@lists.linux.dev
List-Id: <syzbot.lists.linux.dev>
List-Subscribe: <mailto:syzbot+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:syzbot+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <5a786da9-f9cb-4957-938d-51000793a4a8@mail.kernel.org>
In-Reply-To: <5a786da9-f9cb-4957-938d-51000793a4a8@mail.kernel.org>
From: Eric Dumazet <edumazet@google.com>
Date: Mon, 31 Aug 2026 16:59:51 +0200
X-Gm-Features: AcwNN1Vj061KqWNnfn0-xipzLG7ZbvfYcBi0Wps-v1a38_YeDBMpkiOsYiD2FwY
Message-ID: <CANn89i+FVuGcPv=uBhYMrHfmMpkEnPTcLX=joWbZtBiqLSN-gg@mail.gmail.com>
Subject: Re: [PATCH] rxrpc: Fix use-after-free in rxrpc_destroy_all_peers()
To: syzbot <syzbot@kernel.org>
Cc: syzkaller-bugs@googlegroups.com, Marco Elver <elver@google.com>, 
	"David S. Miller" <davem@davemloft.net>, David Howells <dhowells@redhat.com>, 
	Jakub Kicinski <kuba@kernel.org>, linux-afs@lists.infradead.org, 
	Marc Dionne <marc.dionne@auristor.com>, netdev@vger.kernel.org, 
	Paolo Abeni <pabeni@redhat.com>, horms@kernel.org, linux-kernel@vger.kernel.org, 
	syzbot@lists.linux.dev
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Mon, Aug 31, 2026 at 4:41=E2=80=AFPM syzbot <syzbot@kernel.org> wrote:
>
> From: Marco Elver <elver@google.com>
>
> During network namespace teardown, rxrpc_destroy_all_peers() iterates ove=
r
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
> Additionally, insert rcu_barrier() in rxrpc_exit_net() prior to destroyin=
g
> peers and local endpoints. Without rcu_barrier(), rxrpc_destroy_all_peers=
()
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
> Closes: https://syzkaller.appspot.com/bug?extid=3Dc876adfab6362679008c
> Link: https://syzkaller.appspot.com/ai_job?id=3D7fecbeb2-cd9b-4ca2-8149-4=
8663e20b153
> Signed-off-by: Marco Elver <elver@google.com>
>
> ---
> diff --git a/net/rxrpc/net_ns.c b/net/rxrpc/net_ns.c
> index 9a9834145..c00cddfd3 100644
> --- a/net/rxrpc/net_ns.c
> +++ b/net/rxrpc/net_ns.c
> @@ -111,6 +111,11 @@ static __net_exit void rxrpc_exit_net(struct net *ne=
t)
>         timer_delete_sync(&rxnet->peer_keepalive_timer);
>         rxrpc_destroy_all_calls(rxnet);
>         rxrpc_destroy_all_connections(rxnet);
> +       /*
> +        * Wait for pending RCU callbacks that drop peer and local
> +        * references to avoid spurious leak warnings and panics.
> +        */
> +       rcu_barrier();

Hi Marco.

This rcu_barrier() is a pretty big hammer as you might guess.

Please ask your LLM to use pre_exit method in truct pernet_operations
rxrpc_net_ops
(split existing rxrpc_exit_net(struct net *net) in two parts)

pw-bot: cr
