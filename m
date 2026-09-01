Received: from smtpo75.interia.pl (smtpo75.interia.pl [217.74.67.75])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 124BA3B42D7
	for <syzbot@lists.linux.dev>; Tue,  1 Sep 2026 07:04:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.74.67.75
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788246267; cv=none; b=QR1EZ9Rnrbasmi07xbH1XuxtrgCJwxvvc0dBObckWPg7cDKdF/AUnH68Xzo5snmcy6KTXREdlKE/pfkwF27UUKXRuE0qif3836E9y4/azJZa2TFC4uFJjLnjP/T16g0FjgKXLnk3JY0zGKdAQc5kBKsy5BXvA3oppF1arzgzvBI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788246267; c=relaxed/simple;
	bh=R4t+zKkP/m7v1726WxTpyt4g1BPYAEiA6cijixewKgU=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=SBnFxlLV+rL6E/Qpi5JCf81RPzGKsdfQ5Kx4ZHw0PfadJIYsB9QAwmj53/ho46pejto/X7QKkmK8ZlyzLksuYusLSiT77w34KkTz/MPNp5aD9eMCYU2crfSZ+G0RP3xvGoQ/mkXkDXXyUSk9McmkQKqpvzHkKmy344qAXC8vp84=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=poczta.fm; spf=pass smtp.mailfrom=poczta.fm; dkim=pass (1024-bit key) header.d=poczta.fm header.i=@poczta.fm header.b=TbXuVSJV; arc=none smtp.client-ip=217.74.67.75
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=poczta.fm
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=poczta.fm
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=poczta.fm header.i=@poczta.fm header.b="TbXuVSJV"
Received: from nr200 (unknown [80.68.231.31])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (P-256) server-digest SHA256)
	(No client certificate requested)
	by poczta.interia.pl (INTERIA.PL) with ESMTPSA;
	Tue,  1 Sep 2026 09:04:11 +0200 (CEST)
Date: Tue, 1 Sep 2026 09:04:09 +0200
From: Slawomir Stepien <sst@poczta.fm>
To: syzbot <syzbot@kernel.org>
Cc: syzkaller-upstream-moderation@googlegroups.com, syzbot@lists.linux.dev
Subject: Re: [PATCH RFC] can: j1939: fix memory leaks caused by pending
 address claim timer
Message-ID: <apZ46WhlSzFCL9bz@nr200>
References: <9ceb1720-e6ce-4063-9896-36cfaa47ac3b@mail.kernel.org>
Precedence: bulk
X-Mailing-List: syzbot@lists.linux.dev
List-Id: <syzbot.lists.linux.dev>
List-Subscribe: <mailto:syzbot+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:syzbot+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <9ceb1720-e6ce-4063-9896-36cfaa47ac3b@mail.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=poczta.fm; s=dk;
	t=1788246253; bh=32mC+Ov9BU7racPSqh59F31trw3rLAAtIB5OeFzTZOk=;
	h=Date:From:To:Subject:Message-ID:MIME-Version:Content-Type;
	b=TbXuVSJV1Vp8DRSLczy12wZAgHalK6HdU6WUpQm9fIHGBGuxK8dAJdNZUjivdEPN9
	 tkjaZF96NZxmdgxFh1/Wf71hJsLNPG2wINq3QI0MK445nxhKVlpqrlNMQkmNyBnH8P
	 pXwOg3r/TVtzWze45VAaKBiLh4SWqLS7WplqS6Ow=

#syz upstream

On sie 27, 2026 00:17, 'syzbot' via syzkaller-upstream-moderation wrote:
> A memory leak of struct j1939_ecu and struct j1939_priv objects occurs when
> a CAN netdev is stopped while an Address Claim timer is pending:
> 
> BUG: memory leak
> unreferenced object 0xffff888198faa000 (size 8192):
>   backtrace (crc 42a920ae):
>     j1939_priv_create net/can/j1939/main.c:131 [inline]
>     j1939_netdev_start+0x11b/0x5c0 net/can/j1939/main.c:268
>     j1939_sk_bind+0x42c/0x4a0 net/can/j1939/socket.c:506
>     __sys_bind+0x1fa/0x2c0 net/socket.c:1951
>     __x64_sys_bind+0x1c/0x30 net/socket.c:1954
>     do_syscall_64+0x14f/0x3c0 arch/x86/entry/syscall_64.c:94
> 
> BUG: memory leak
> unreferenced object 0xffff8881978f36c0 (size 192):
>   backtrace (crc f1bed932):
>     j1939_ecu_create_locked+0x4e/0x1c0 net/can/j1939/bus.c:155
>     j1939_local_ecu_get+0xe6/0x1b0 net/can/j1939/bus.c:293
>     j1939_sk_bind+0x300/0x4a0 net/can/j1939/socket.c:529
>     __sys_bind+0x1fa/0x2c0 net/socket.c:1951
>     __x64_sys_bind+0x1c/0x30 net/socket.c:1954
>     do_syscall_64+0x14f/0x3c0 arch/x86/entry/syscall_64.c:94
> 
> When an Address Claim message is processed, j1939_ecu_timer_start() starts
> a 250ms timer (ecu->ac_timer) and acquires a reference to the ECU. At this
> stage, the ECU is linked to priv->ecus but not yet mapped into priv->ents.
> If the socket is closed or the netdev is stopped before the timer expires,
> j1939_netdev_stop() calls __j1939_rx_release(), which invokes
> j1939_ecu_unmap_all(). However, j1939_ecu_unmap_all() only unmapped entries
> in priv->ents, leaving the pending ECU timer running. When ecu->ac_timer
> expires after netdev teardown, j1939_ecu_timer_handler() unconditionally
> maps the ECU into priv->ents of the stopped priv instance, where it will
> never be unmapped or freed. Since the leaked ECU retains a reference to
> priv, both the ECU and priv structures are leaked.
> 
> Furthermore, calling hrtimer_cancel() while holding priv->lock can lead to
> a deadlock if j1939_ecu_timer_handler() runs concurrently on another CPU
> waiting to acquire priv->lock.
> 
> Fix the memory leak and deadlock by:
> - Iterating over priv->ecus in j1939_ecu_unmap_all() to cancel any pending
> ECU timers with j1939_ecu_timer_cancel().
> - Checking kref_read(&priv->rx_kref) > 0 in j1939_ecu_timer_handler()
> before calling j1939_ecu_map_locked(ecu) so that unmapped ECUs are not
> mapped into a stopped netdev.
> - Using hrtimer_try_to_cancel() in j1939_ecu_timer_cancel() to avoid
> spinning with priv->lock held.
> - Taking temporary references with j1939_priv_get() and j1939_priv_put()
> around j1939_ecu_unmap_all() and j1939_ecu_timer_handler() to ensure priv
> memory remains valid while held.
> 
> Fixes: 9d71dd0c7009 ("can: add support of SAE J1939 protocol")
> Assisted-by: Gemini:gemini-3.7-flash Gemini:gemini-3.1-pro-preview syzbot
> Reported-by: syzbot+489e907b2a026a6f5fa0@syzkaller.appspotmail.com
> Closes: https://syzkaller.appspot.com/bug?extid=489e907b2a026a6f5fa0
> Link: https://syzkaller.appspot.com/ai_job?id=c118979e-3d39-430b-b07e-608d26aeaa70
> To: <linux-can@vger.kernel.org>
> To: "Marc Kleine-Budde" <mkl@pengutronix.de>
> To: "Oleksij Rempel" <o.rempel@pengutronix.de>
> To: "Robin van der Gracht" <robin@protonic.nl>
> To: "Oliver Hartkopp" <socketcan@hartkopp.net>
> Cc: <kernel@pengutronix.de>
> Cc: <linux-kernel@vger.kernel.org>
> 
> ---
> diff --git a/net/can/j1939/bus.c b/net/can/j1939/bus.c
> index cdc3c0a71..71e52f25a 100644
> --- a/net/can/j1939/bus.c
> +++ b/net/can/j1939/bus.c
> @@ -98,13 +98,18 @@ void j1939_ecu_unmap(struct j1939_ecu *ecu)
>  
>  void j1939_ecu_unmap_all(struct j1939_priv *priv)
>  {
> +	struct j1939_ecu *ecu, *tmp;
>  	int i;
>  
> +	j1939_priv_get(priv);
>  	write_lock_bh(&priv->lock);
>  	for (i = 0; i < ARRAY_SIZE(priv->ents); i++)
>  		if (priv->ents[i].ecu)
>  			j1939_ecu_unmap_locked(priv->ents[i].ecu);
> +	list_for_each_entry_safe(ecu, tmp, &priv->ecus, list)
> +		j1939_ecu_timer_cancel(ecu);
>  	write_unlock_bh(&priv->lock);
> +	j1939_priv_put(priv);
>  }
>  
>  void j1939_ecu_timer_start(struct j1939_ecu *ecu)
> @@ -121,7 +126,7 @@ void j1939_ecu_timer_start(struct j1939_ecu *ecu)
>  
>  void j1939_ecu_timer_cancel(struct j1939_ecu *ecu)
>  {
> -	if (hrtimer_cancel(&ecu->ac_timer))
> +	if (hrtimer_try_to_cancel(&ecu->ac_timer) == 1)
>  		j1939_ecu_put(ecu);
>  }
>  
> @@ -131,17 +136,18 @@ static enum hrtimer_restart j1939_ecu_timer_handler(struct hrtimer *hrtimer)
>  		container_of(hrtimer, struct j1939_ecu, ac_timer);
>  	struct j1939_priv *priv = ecu->priv;
>  
> +	j1939_priv_get(priv);
>  	write_lock_bh(&priv->lock);
> -	/* TODO: can we test if ecu->addr is unicast before starting
> -	 * the timer?
> -	 */
> -	j1939_ecu_map_locked(ecu);
> +	/* Only map the ECU if the netdev is still active */
> +	if (kref_read(&priv->rx_kref) > 0)
> +		j1939_ecu_map_locked(ecu);
>  
>  	/* The corresponding j1939_ecu_get() is in
>  	 * j1939_ecu_timer_start().
>  	 */
>  	j1939_ecu_put(ecu);
>  	write_unlock_bh(&priv->lock);
> +	j1939_priv_put(priv);
>  
>  	return HRTIMER_NORESTART;
>  }
> 
> 
> base-commit: 8d3ae59288f1e7d58d76558a6ee96d533bc5019f

-- 
Slawomir Stepien
