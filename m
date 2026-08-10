Received: from mail-pj1-f42.google.com (mail-pj1-f42.google.com [209.85.216.42])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 35FD03630A0
	for <syzbot@lists.linux.dev>; Mon, 10 Aug 2026 16:08:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.216.42
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786378091; cv=pass; b=h2AOcpwyP0kXhyuBhg1J+MqnbaN2W4ce8JZaanMytN/VJHeMZev5ZXEICRIp70wmAJK9HaMcVdFtccpMLuFL3paP5g3yQhFYCiZ5TZOiTC0kmAe9HiExYMwefoN2wVA3reTb/xT/Nj9X6NDKVg+ggGhzV703/Anf6B1efFHOeFg=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786378091; c=relaxed/simple;
	bh=sM1HE/gHfZZSCN0r1k4Ozt7cXYnKaeE5cbfz7ycovqQ=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=FcVlvXjMN6Ge+wJt6x4tulhRogG/WhQz3ULjtXSK2D8wpStclLVM7vR9wle19k0USfXP4jg/z8JISuVrC2/HyGi27t3bCBI+wPKSIDASZG5Tmoo43c4++/R/gZKx0gaEVMWQgjnv0Yl9Y+XqRAKeBEAlvG5KcJa1cgEyZ/Iecsk=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=dVQIhtEk; arc=pass smtp.client-ip=209.85.216.42
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="dVQIhtEk"
Received: by mail-pj1-f42.google.com with SMTP id 98e67ed59e1d1-38dcbade417so1892814a91.1
        for <syzbot@lists.linux.dev>; Mon, 10 Aug 2026 09:08:10 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1786378089; cv=none;
        d=google.com; s=arc-20260327;
        b=G/RDxsMgLbl2g2utdEB2oiDz+CAGNI1E632QHxnLQzqFb4cww3sixmaN+acJfS/IWj
         puPsCE/wlNzQ9Ppw32EMEN4FPMCWvg9eIbIyNY61qLcvmfcJdjuSeESq2AIzZXJS7c9n
         s2AlbwXMv0EFSJYYpO36iVca1Ys/zz4PCDEW11KAtiIkQ0mICstNjMeVYX0lM4N28Dfu
         AGAj2p2WcHumIDVZKAlWQzR7updtWWlfTX+G7tnfLvuXXCfYXt8CLeuh3Eca+gpRzYiw
         d2csF3lpMnPW2Q0TCqU1LY1b+m8/2z+XV77m2PoBItBwhHw7eVOWuV9SlbRitBje4+EJ
         oCfA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=bX/D9kWMVmi5S8/U3EVXtbh+MW20ihsEcQbTGqg9tnM=;
        fh=ntgoRAnFnB3sMTCB8iPp0AqBZKA/3NgcaHE/PYIGfpY=;
        b=jZ/n0Wxwq9qXNIpB7DKSpYjm+tYhP/0uMWhUgHfSjc9IKVTlkXtNIBcqTqVk7BcdQ/
         f7PNt5zvgY/1v7drkAAuyVTzanOzflHjMtZnb6OvXwEOjBRfEqMjkn2XXd/oo7rbHMEI
         0pvUJlGKJarTQrOtQKlWOXgac5MwXVBUMRYN6trUlwZwgtYYZ8qej4V1UeSbJe154mR6
         KmMzdtITBeybXX82qiMae4uCmUH/vclbzdgKeaZRjEg3Zy9sDPnPxOwvsRQiqQ0uKLmS
         bjhD/e/ceuQgO6IeSKkdp0012hFzyKJJToNKTeDhR+QlXv2esLRLVd+bX430VN7nla+i
         940g==;
        darn=lists.linux.dev
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1786378089; x=1786982889; darn=lists.linux.dev;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=bX/D9kWMVmi5S8/U3EVXtbh+MW20ihsEcQbTGqg9tnM=;
        b=dVQIhtEkeEERmrukin0H/Y8h1rfu9X1h6VSopgLcmZZIOTmRPYnuPbI+tSW/xy2QPQ
         PCSqmw2UG8TVc0QcolGf4r6RQyHmttxiGBoDrCfPgyx/Akx0NlCrdQHwN6xRF+SrthKZ
         Ph3DbeybpBX7arGVxvRO1U1EZgwFW3rTyPhU5eY8jx3bpEdKnpimF5U/DOKHjCUX3d23
         ywd9HWdUzABXp3Vi/vnPJ0Lj4mYcjEnXQvgl7arBUB9aOnSKE4iCQ0pfpdYr0EvVy1LI
         U9N1ojdYhF3CSfOndhwkjjzWsE5EU3YLIRYdiKPcUl6fi8p/Zjpg9Pg2Xs5lYHn2OHYX
         ZA7A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1786378089; x=1786982889;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=bX/D9kWMVmi5S8/U3EVXtbh+MW20ihsEcQbTGqg9tnM=;
        b=KCbdcoaqNaYyf7PnXP7pgM6I+ik2XDdkeUkUSqFhNXu/REtNb44oU9qMZJIBuSVYrN
         Z4LcarNcKK4eimFnmqiFqpwaPauPJRExqeIFI2Cn0XUm63ux7pid4X78RES8RQ46nehI
         /7AkI73eWmeDI7ob7pW3xsiKvu3OFeQ1vs2yoaOBbsD0MURWDYaSY0vEoIFOMNTrqPRZ
         NTDhH5wXuJjYJruiyRaynaXFpqQp3I1mo4sBCiXKniJJ0+WxLBuFvniT8hd/lWCjge8B
         6iRQ6j+0J14n9MGlFh45PuXtRny2sVAbSubFiN9ZHouGuKm7bUWZxgPG0hf9efRGw677
         UlRQ==
X-Forwarded-Encrypted: i=1; AHgh+RrLRS1JY9b5jvg6fGYxEwDQI2ASV8UutyXRlPKfxcP725yckO0DBD8DGDfswCGCzvDrPf8woe4=@lists.linux.dev
X-Gm-Message-State: AOJu0YwTloUjoN7RkPnRHJXOye2jc+QINjzYcfOw/Hxy7RMPDaJVBWFa
	0BPIOH2DnL10lhNrTXZQoNbIVdEgEXzhfvInisn7aHF9S6pIrozeP6eMVop64TrAtEqmD94BPg+
	BTyanEjTTKDxB7d6W7rLnpMJau+NhP2tXB3M6kQxk
X-Gm-Gg: AR+sD11VCzw2FKeMBkHHVibauE2IJlYOz8GaiqBTQAutT2bH8dcSXulWXsBuZDmyzQO
	TWumYl1q+ApQolIeSb0vr9Ro2JzDhmosq3YX8VDKjwRW8MnyuxTsCwqRwM8Lv9biYz/3sM3NEIG
	Gbsq64UDrehrpN17qyjg2tYE0JoPRfQm254Pk8gTXmmQLg0WgZPKjL3NaORBaz1KqMZz3yaozVT
	iEsvU5lP39azD40/T1ItjetGp2WqlefdjEyVS06riy7gWSQt/2ZQhYw+QxlApJ+sdYP7L8F4Pft
	VKhfzlFaSTtbgg7md1xO+SdX4eJv5PCuaxP1A2RI/c7WEi2qp6yXKLRF2OegiASXRR0EjDFQ2bt
	JeSIudOb1iw==
X-Received: by 2002:a17:90b:5244:b0:38e:9eb2:9d43 with SMTP id
 98e67ed59e1d1-3903c5b685bmr42555978a91.16.1786378088940; Mon, 10 Aug 2026
 09:08:08 -0700 (PDT)
Precedence: bulk
X-Mailing-List: syzbot@lists.linux.dev
List-Id: <syzbot.lists.linux.dev>
List-Subscribe: <mailto:syzbot+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:syzbot+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <efbfa532-8931-4227-9ba4-701ac86a342e@mail.kernel.org>
In-Reply-To: <efbfa532-8931-4227-9ba4-701ac86a342e@mail.kernel.org>
From: Marco Elver <elver@google.com>
Date: Mon, 10 Aug 2026 18:07:31 +0200
X-Gm-Features: AUfX_mzRP6IsVEA4PP70Qk2spQ_VSfBFE8509qOgUUhGMxKWutuXaXm3UaC-Cuw
Message-ID: <CANpmjNMOFq+vKs9XKdXjYuowJY0-R9XBrktjy2gm4nPWTFmW9g@mail.gmail.com>
Subject: Re: [PATCH RFC] rxrpc: Fix use-after-free in rxrpc_destroy_all_peers()
To: syzbot <syzbot@kernel.org>
Cc: syzkaller-upstream-moderation@googlegroups.com, syzbot@lists.linux.dev
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Mon, 10 Aug 2026 at 17:04, 'syzbot' via
syzkaller-upstream-moderation
<syzkaller-upstream-moderation@googlegroups.com> wrote:
>
> During network namespace teardown, rxrpc_destroy_all_peers() iterates ove=
r
> the rxnet->peer_hash table to print leaked peers. However, it does so
> without holding the rxnet->peer_hash_lock. This allows a race condition
> with asynchronous peer destruction triggered by the AFS subsystem via RCU=
,
> which can concurrently remove a peer from the hash table and free it.
>
> When the RCU grace period expires, afs_free_addrlist() calls
> rxrpc_kernel_put_peer(), which eventually invokes __rxrpc_put_peer(). Thi=
s
> function acquires rxnet->peer_hash_lock, removes the peer from the hash
> table, and frees it via kfree_rcu(). If rxrpc_destroy_all_peers() is
> concurrently iterating over the hash bucket, it may attempt to read the
> hash_link.next pointer of a physically freed peer, resulting in a KASAN
> slab-use-after-free. The crash log confirms this behavior, as one of the
> leaked peers printed right before the crash has a refcount of 0, indicati=
ng
> it was already put and waiting to be removed and freed.
>
> The crash report illustrates this issue:
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
> Freed by task 15:
>  kasan_save_stack mm/kasan/common.c:57 [inline]
>  kasan_save_track+0x3e/0x80 mm/kasan/common.c:78
>  kasan_save_free_info+0x40/0x50 mm/kasan/generic.c:584
>  poison_slab_object mm/kasan/common.c:253 [inline]
>  __kasan_slab_free+0x5c/0x80 mm/kasan/common.c:285
>  kasan_slab_free include/linux/kasan.h:235 [inline]
>  slab_free_hook mm/slub.c:2677 [inline]
>  __rcu_free_sheaf_prepare+0x12d/0x2a0 mm/slub.c:2928
>  rcu_free_sheaf+0x31/0x200 mm/slub.c:5978
>  rcu_do_batch kernel/rcu/tree.c:2645 [inline]
>  rcu_core+0x78b/0x10a0 kernel/rcu/tree.c:2897
>  handle_softirqs+0x225/0x840 kernel/softirq.c:622
>  run_ksoftirqd+0x36/0x60 kernel/softirq.c:1076
>  smpboot_thread_fn+0x57c/0xa80 kernel/smpboot.c:160
>  kthread+0x388/0x470 kernel/kthread.c:436
>  ret_from_fork+0x514/0xb70 arch/x86/kernel/process.c:158
>  ret_from_fork_asm+0x1a/0x30 arch/x86/entry/entry_64.S:245
>
> To fix this, acquire rxnet->peer_hash_lock using spin_lock_bh() before
> iterating over the rxnet->peer_hash table in rxrpc_destroy_all_peers(), a=
nd
> release it after the iteration is complete. The _bh variant is required
> because __rxrpc_put_peer() can be invoked from an RCU callback in softirq
> context, and using a plain spin_lock() could lead to a deadlock. This
> change ensures that the hash table structure remains stable during
> iteration and aligns with the locking patterns used in other teardown
> functions within the rxrpc subsystem.
>
> Fixes: 17226f124038 ("rxrpc: Fix leak of rxrpc_peer objects")
> Assisted-by: Gemini:gemini-3.5-flash Gemini:gemini-3.1-pro-preview syzbot
> Reported-by: syzbot+c876adfab6362679008c@syzkaller.appspotmail.com
> Closes: https://syzkaller.appspot.com/bug?extid=3Dc876adfab6362679008c
> Link: https://syzkaller.appspot.com/ai_job?id=3D148b52c4-bf79-4dde-932f-8=
b4de7e83f41
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
>         for (i =3D 0; i < HASH_SIZE(rxnet->peer_hash); i++) {
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

  Holding peer_hash_lock prevents the immediate KASAN slab-use-after-free
  during hash bucket traversal, but this fix is incomplete and masks a larg=
er
  lifecycle/quiescence bug in netns exit:

  1. False Positive Leak Warnings:
  rxrpc_destroy_all_peers() does not destroy peers; it audits for leaks.
  External kernel consumers (such as fs/afs) release peer references
  asynchronously via RCU callbacks (afs_free_addrlist() ->
  rxrpc_kernel_put_peer()). Because netns teardown (rxrpc_exit_net())
  does not synchronize or wait for in-flight RCU grace periods after
  destroying calls and connections, rxrpc_destroy_all_peers() races with
  pending RCU callbacks and logs spurious pr_err("Leaked peer...") messages
  for peers that are already undergoing normal destruction (refcount =3D=3D=
 0).
  2. Downstream Panic Hazard (rxrpc_destroy_all_locals()):
  Each struct rxrpc_peer holds a reference to peer->local. The local
  reference is only dropped when rxrpc_free_peer() runs. When netns exit
  proceeds directly from rxrpc_destroy_all_peers() to
  rxrpc_destroy_all_locals(), any in-flight peer release leaves
  rxnet->local_endpoints populated. rxrpc_destroy_all_locals() will then
  hit BUG():
    if (!hlist_empty(&rxnet->local_endpoints)) {
        ...
        BUG();
    }


  Please revise the patch to:

  1. Retain spin_lock_bh(&rxnet->peer_hash_lock) in rxrpc_destroy_all_peers=
()
  to ensure atomic traversal of the hash table against concurrent unlinks.
  2. Add an explicit rcu_barrier() in rxrpc_exit_net() after tearing down
  calls and connections, ensuring all pending RCU callbacks that drop peer
  and local references (e.g. from AFS address lists) complete prior to leak
  checks and local endpoint destruction (mirroring the pattern in
af_rxrpc_exit()).
  =E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80
  ### Suggested Revision

    diff --git a/net/rxrpc/net_ns.c b/net/rxrpc/net_ns.c
    index c7a023fb22d0..6e5458319fbc 100644
    --- a/net/rxrpc/net_ns.c
    +++ b/net/rxrpc/net_ns.c
    @@ -113,6 +113,12 @@ static __net_exit void rxrpc_exit_net(struct net *=
net)
         timer_delete_sync(&rxnet->peer_keepalive_timer);
         rxrpc_destroy_all_calls(rxnet);
         rxrpc_destroy_all_connections(rxnet);
    +
    +    /* Ensure all RCU callbacks releasing peer and local references
    +     * (e.g. afs_free_addrlist) have completed before leak assertions.
    +     */
    +    rcu_barrier();
    +
         rxrpc_destroy_all_peers(rxnet);
         rxrpc_destroy_all_locals(rxnet);
         proc_remove(rxnet->proc_net);
    diff --git a/net/rxrpc/peer_object.c b/net/rxrpc/peer_object.c
    index fa9a406e1168..d81ed180e55b 100644
    --- a/net/rxrpc/peer_object.c
    +++ b/net/rxrpc/peer_object.c
    @@ -454,6 +454,8 @@ void rxrpc_destroy_all_peers(struct rxrpc_net *rxne=
t)
         struct rxrpc_peer *peer;
         int i;

    +    spin_lock_bh(&rxnet->peer_hash_lock);
    +
         for (i =3D 0; i < HASH_SIZE(rxnet->peer_hash); i++) {
             if (hlist_empty(&rxnet->peer_hash[i]))
                 continue;
    @@ -465,6 +467,8 @@ void rxrpc_destroy_all_peers(struct rxrpc_net *rxne=
t)
    &peer->srx.transport);
             }
         }
    +
    +    spin_unlock_bh(&rxnet->peer_hash_lock);
     }


Please independently validate the above claims and retest as required!
