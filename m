Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 184734562B1
	for <syzbot@lists.linux.dev>; Tue,  1 Sep 2026 07:19:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788247200; cv=none; b=lenuGEvhdXURBxHbLIrP+q/ubshN0IMuO/xBWZNbJ23iABUI1iowC/yX6M/fiQ+IRzlqiHNY+xcdtWQVTcWy+nb5mFXg62QKx46cxADU1Zm+8xL0gLFsTLzEdVZ/mkVlnlLELBK4/saXD9olJu+pnuc1Oj4rLAtOEjWwEptCRPk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788247200; c=relaxed/simple;
	bh=1k6SvENvEjYzl/25C74rme3ARcao/Z8y5ktfWVP+uRY=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=cSIErXX7eUCu4sBEo5YzRXjIdO7cEFoQcFGRDuTuJqlaG1HHrOEk62BgcsOY+nAbBmqwRwBCxSfgD8Bl8kkOXGO5hOZ0DbzM+w4Jd+ogLeJ19SCS7nYxAbjK/wbBKh899gwTfELPv6HRwGFbtQbVZqdKGiD1HWN/nD3BtXIdVBE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=SmN96TQK; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="SmN96TQK"
Received: by smtp.kernel.org (Postfix)
	id C74B31F00A3E; Tue,  1 Sep 2026 07:19:58 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5EF4A1F000E9;
	Tue,  1 Sep 2026 07:19:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788247198;
	bh=En8NI5CYr3Gdzq3Szy33g5qcxCTQrfJufFyXDLF1Oi4=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=SmN96TQKE4Q13Ke1IutQwZchzCzXbTcnkuGb1xVqouBenbg+N02pDNHbxu36UgfC9
	 chLnQYAt0JsE/HlB5YB5zON3OyoSrJgiSY6UWmuOGPqVLlbJRDm+0JKR7WfGBW1g+p
	 hLNcmG/PeEkWqiFmFFyYoNrErgD2qzVB58Nc80XdCBlDiZmtlJXOXEdRAJhSLbjsz0
	 S3ZnJgPLLj3KV2fdOyI7rSo8akUeZbU4WbHppWPbFK7DLxlNqsQIuTdYjge7KwWzH1
	 aIQJSUJPK23Mks+arHfilIVEoSxdT0YGtgjjQVJ3DOxiUp2HMuG6XdkxtoXdadzO2D
	 4unWCZYOdb1ug==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH] can: j1939: fix memory leaks caused by pending address
 claim timer
Reply-To: sashiko-reviews@lists.linux.dev
To: syzbot <syzbot@kernel.org>
Cc: "Vincent Mailhol" <mailhol@kernel.org>, "Oliver Hartkopp" <socketcan@hartkopp.net>, "Marc
 Kleine-Budde" <mkl@pengutronix.de>, "Oleksij Rempel" <o.rempel@pengutronix.de>, linux-can@vger.kernel.org
In-Reply-To: <1ca51efc-8929-4df1-ab11-72407b6d496f@mail.kernel.org>
References: <1ca51efc-8929-4df1-ab11-72407b6d496f@mail.kernel.org>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Tue, 01 Sep 2026 07:19:57 +0000
Message-Id: <20260901071958.5EF4A1F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: syzbot@lists.linux.dev
List-Id: <syzbot.lists.linux.dev>
List-Subscribe: <mailto:syzbot+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:syzbot+unsubscribe@lists.linux.dev>

Thank you for your contribution! Sashiko AI review found 2 potential issue(=
s) to consider:

New issues:
- [High] Ignoring hrtimer_try_to_cancel() failure introduces race condition=
s leading to inappropriate ECU mapping (NETDEV_DOWN, IDLE claims, and delay=
 bypass).

Pre-existing issues:
- [Critical] Lockless list_del in __j1939_ecu_release leads to linked list =
corruption and use-after-free.
--

commit 2b6762bc65c5c7e152f9be9bd0a6d303989290db
Author: Slawomir Stepien <sst@poczta.fm>

can: j1939: fix memory leaks caused by pending address claim timer

Fixes a memory leak and deadlock involving pending Address Claim timers dur=
ing
netdev teardown. It cancels timers during j1939_ecu_unmap_all() and adds
kref_read(&priv->rx_kref) checks to prevent remapping ECUs on stopped
interfaces.

Link: https://syzkaller.appspot.com/ai_job?id=3Dc118979e-3d39-430b-b07e-608=
d26aeaa70

> diff --git a/net/can/j1939/bus.c b/net/can/j1939/bus.c
> index cdc3c0a719379..71e52f25aa604 100644
> --- a/net/can/j1939/bus.c
> +++ b/net/can/j1939/bus.c
[ ... ]
> @@ -121,7 +126,7 @@ void j1939_ecu_timer_start(struct j1939_ecu *ecu)
> =20
>  void j1939_ecu_timer_cancel(struct j1939_ecu *ecu)
>  {
> -	if (hrtimer_cancel(&ecu->ac_timer))
> +	if (hrtimer_try_to_cancel(&ecu->ac_timer) =3D=3D 1)
>  		j1939_ecu_put(ecu);
>  }

[Severity: High]
Does ignoring the -1 return value from hrtimer_try_to_cancel() introduce ra=
ce
conditions that could lead to inappropriate ECU mapping?

The patch replaces a deadlocking hrtimer_cancel() with hrtimer_try_to_cance=
l()
but ignores failures. If the timer callback is running concurrently on anot=
her
CPU, it will block on write_lock_bh(&priv->lock).=20

If the current CPU executes j1939_ecu_unmap_all() or processes an IDLE claim
in j1939_ac_process(), it holds priv->lock, calls hrtimer_try_to_cancel()
(which fails and returns -1), modifies the state, and unlocks.

The other CPU running the timer callback then acquires the lock and could
execute j1939_ecu_map_locked() based on old state. Could this cause the ECU=
 to
be mapped back onto a DOWN interface, ignore IDLE claims by re-mapping the =
old
address, or bypass the J1939 250ms delay by immediately mapping the new
address?

[ ... ]
> @@ -131,17 +136,18 @@ static enum hrtimer_restart j1939_ecu_timer_handler=
(struct hrtimer *hrtimer)
>  		container_of(hrtimer, struct j1939_ecu, ac_timer);
>  	struct j1939_priv *priv =3D ecu->priv;
> =20
> +	j1939_priv_get(priv);
>  	write_lock_bh(&priv->lock);
> -	/* TODO: can we test if ecu->addr is unicast before starting
> -	 * the timer?
> -	 */
> -	j1939_ecu_map_locked(ecu);
> +	/* Only map the ECU if the netdev is still active */
> +	if (kref_read(&priv->rx_kref) > 0)
> +		j1939_ecu_map_locked(ecu);
> =20
>  	/* The corresponding j1939_ecu_get() is in
>  	 * j1939_ecu_timer_start().
>  	 */
>  	j1939_ecu_put(ecu);

[Severity: Critical]
This is a pre-existing issue, but could dropping the last ECU reference
outside of priv->lock lead to list corruption?

In __j1939_ecu_release(), there is a lockless call to list_del(&ecu->list).
If CPU 1 receives an address claim, j1939_ac_recv() takes a temporary
reference via j1939_ecu_get_by_addr(). If CPU 2 concurrently executes
j1939_ecu_unmap_all(), unmapping the ECU and dropping its mapping reference,
then when CPU 1 finishes processing it calls j1939_ecu_put(), dropping the
final reference.

Because paths like j1939_ac_recv() and j1939_ac_fixup() call
j1939_ecu_put(ecu) without holding priv->lock, does this cause
__j1939_ecu_release() to execute list_del(&ecu->list) locklessly, resulting
in list corruption and use-after-free crashes on subsequent traversals?

>  	write_unlock_bh(&priv->lock);
> +	j1939_priv_put(priv);
> =20
>  	return HRTIMER_NORESTART;
>  }

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/1ca51efc-8929-4df1-=
ab11-72407b6d496f@mail.kernel.org?part=3D1
