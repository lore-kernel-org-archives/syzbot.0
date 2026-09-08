Received: from mail-ot1-f51.google.com (mail-ot1-f51.google.com [209.85.210.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0AF81533594
	for <syzbot@lists.linux.dev>; Tue,  8 Sep 2026 12:06:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.210.51
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788869208; cv=pass; b=PwTpvoEtCF7cM293ZEjuVzHbsj4yqQ6Ic7Nk6kosUgDblrwkl6vDCMx2ay6XfScGTguIPUoqipn8sHqn6mW1uODWfelvfozsVFVutdWSTwtTycvLfmzUYxKuf5Qd9A2PbAd/iQjHAsXOJKduP1izeQDKaIZmu1JkpvwV5hCn64o=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788869208; c=relaxed/simple;
	bh=IBEo1FS4L5fUaLDolysMAI/e1LuRp8R3Ue9ubO+fEVc=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=H23YlqfRBtXuOabJGfN2NvRIxLTGGf/GEiEXGaHJzdfXVTZ19IDdS6xvzBOdaEW0VzNra++bUNmNE5rI4wNKZIy+wBYS9zS0Q9CS3kvJnnfBzkM8d+R6/4eJ3lsK0NDn7hXrJMXFR0i4I0zWEsCeW0h2HEufu6ocJM+KBU1CnX0=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=W/6+4/5o; arc=pass smtp.client-ip=209.85.210.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="W/6+4/5o"
Received: by mail-ot1-f51.google.com with SMTP id 46e09a7af769-7f4df360cc9so5070474a34.1
        for <syzbot@lists.linux.dev>; Tue, 08 Sep 2026 05:06:43 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1788869201; cv=none;
        d=google.com; s=arc-20260327;
        b=QzZ6sbnwt7QnB80ct/yeAE40PccyTMlStv320qIZvJIOcQFOseEumT7eT3au61O5Xq
         sFUG9DuNzjM5cadEMmwGSFkSxl6slcU7tlEu4rW7+5cLuStLtw5S1BeZzwrfsFdPH978
         BGNqVROHVdJi0Yfmq/jaS9FwDvWoMcWn3dyopk9kJJ1+aZs2bD1iB2M5hbePaV9NckHC
         O2QQlTt4EEEz/2W/p7PfmBZ6KiHE4nELJlYvUH8hI2Kk6ed+leC7CUeGKnu8xLEM2ycG
         UGS9SDWvsiLeii/4CTHqWwcyCVJMxW48xjaxn3LDZGmlQGJqfdoiw+NAkub0iPyigYSf
         kvLg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=I2XGpFJYGYdAW4FLjaZcGv7JF4d29sj493tkbkgrUhE=;
        fh=T8PpPXZqq48Ovdvxiuz1hZWgX1X8V55bQny7zxao6hc=;
        b=mJJpdY6+QiEsSoxhIKWaNEBsFd1Of4wVuXVSc3GtHbzOMAm7dD5BmXvio7libNZ2M5
         ja+AuytKdEwRic2PO8WAMpxQRkhGqbqadblJm/ZihNNdreIPnk3+K8GDteq9TCxf3Tzx
         bEC/tuRW3G5v1nYOJWWaFSPzIWbFDeggvZXbEJL8kf7T59+KXc7aPPKclrzgIAgc7Gp+
         WK/WLxUeRyZjskMJRB0twJxFaEoMNexbih0J1d94+3pu9oegWVsrBxef4khiuK7yDNSt
         cvSar5IXdmSHzDMhbJBMbsWFH27NDee/NN5l0hFVoe5TYnalGL/Kol+SRWixoO4It2S1
         w3dA==;
        darn=lists.linux.dev
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1788869201; x=1789474001; darn=lists.linux.dev;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=I2XGpFJYGYdAW4FLjaZcGv7JF4d29sj493tkbkgrUhE=;
        b=W/6+4/5o36IHTpaInn3/oTev+1uZaztjXKZDiGRhmOW9kFYSJR8CK/if//0UfS4zvJ
         wy4d58mrtDApxJI/7W+MTYQ/xLf6RlS/hZzGdhRruec6lV7Bzdw0Bpd1Y8WfdVYz9EU7
         2P5adGRHBecqz6NhUBbu9gPuk7wveL/WKe6wld5bd9t7HmI6yiAYm1jt92kk+Px73UUG
         X7tE0+FpPVCGm23D+uw3+0cOHBgJncYWPZs2RuYr1qYR7yD4w0Jb/qIX+kl1DCex0t3j
         814oM22YR6PTbu/WXC4+nprlAHN7pQJO9ArKCTDb/O/6OJNW7I98ngtrVjtTGp8kUgl6
         KCQA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1788869201; x=1789474001;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=I2XGpFJYGYdAW4FLjaZcGv7JF4d29sj493tkbkgrUhE=;
        b=gExkWUpiJ8LhalfR1+XAWi42e4bVtY011dSof81TMk1PQ5gNuctC1k35ASTBSVpcg7
         C4DzebEpqhE7NE10sdkZ7PVRxjG/bdLTcrxnXJeMRHZ7VhlrnSmbPw8DEcfE2a6pOhfz
         t1Vo6j735wxLjSLA+eZBbeDffQjlb92S02oXP68p809Ex1WIT2A24IYSBPFqhjzkTQ7S
         dW4LOgHerGs/VGgc9Ygo6E3ix9ac5lYYfTa+BosBjIjDA1HbOmsmZFNlG8bttykocN/4
         KtRQcKGMelkBmrpnTNnZh7eQC8t2IdsWN8m0n16EVWbN1+Nvi6XbNBtYCK1e+Bb7Jt1m
         SaMg==
X-Forwarded-Encrypted: i=1; AKwUvByXrsdQBEl/aOJgKQZjqLIP+I2aBfcCW+la2XPzK//4K+IEkx/RynSLOi2OSiXsyJgfFm6q2Fo=@lists.linux.dev
X-Gm-Message-State: AFuF++mzJMCmIc8Uv0TKJXtwqHVGQJxstB+kTiluHryOAnFX/4XPjCID
	HogYV4CcvPTkAX4fMteS83UVHX2XtkElwJJtHAtTmaTFJ2XyEBRhzmzomSvwiEt62bISIL+iHbz
	p2SLT3u792uUnmO+ULOdbgabe1sC+He73Lw4W074r
X-Gm-Gg: AYBFou1wWtuvzR8vkeqY6VoARN1q4A7ySmtEsDEwEDcyZDyHnUHlCXTe6aNBJCZaVt7
	qBXBViRWT1Ulu7xVuywHeqOYnKlXiIIG2uGkb2O6qHpmWooo9uVgjpBY8NQF9APKgWEDVjJdfyR
	Dc0p2fYHStEYpR1UrFN72QYopwK9R9WrA3I1KsupHKaHdN3Q2VORWqK+foRgHiFx7aMMfRqEeD0
	oIsf3iGTWevFkxOrTjiviWEqSPR00V7tT+lJZx93tmvbhEx4ItxnBLwzht6qlLxUsELt/hh1hD8
	CGpwF2p5Dv8V17DpQD/Yzj9J5MyzkGMG0mExIgGYjfH0D95GCQDxycYNYfw5/r6Hve+p9PaX82k
	nuRy9kgZ56n8mZ7SwGiour511hfaYBEHdWXoT0BSM4dBLdL9auFePdO/iTqlENIJIMMVi74O8gH
	dkevFGAIZ8viZH
X-Received: by 2002:a05:6830:e01:b0:800:1292:4d9f with SMTP id
 46e09a7af769-80012924fb9mr702305a34.16.1788869200782; Tue, 08 Sep 2026
 05:06:40 -0700 (PDT)
Precedence: bulk
X-Mailing-List: syzbot@lists.linux.dev
List-Id: <syzbot.lists.linux.dev>
List-Subscribe: <mailto:syzbot+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:syzbot+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <5a7201b1-c826-4855-9105-3caa58977bc3@mail.kernel.org>
In-Reply-To: <5a7201b1-c826-4855-9105-3caa58977bc3@mail.kernel.org>
From: Aleksandr Nogikh <nogikh@google.com>
Date: Tue, 8 Sep 2026 14:06:29 +0200
X-Gm-Features: AcwNN1Uzh5sIx26s7RVMW8d-EsJkaOPZ3vB8ZsNCR-q09DFZMNObwexot-wE4Dc
Message-ID: <CANp29Y4ibb_u6Ov7ejfxg96PuUGdJdgsZejKoRmBUNzzfGZBEw@mail.gmail.com>
Subject: Re: [PATCH RFC v2] net: phy: fix suspicious RCU usage in phy_detach()
To: syzbot <syzbot@kernel.org>
Cc: syzkaller-upstream-moderation@googlegroups.com, syzbot@lists.linux.dev
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Tue, Sep 8, 2026 at 12:30=E2=80=AFPM syzbot <syzbot@kernel.org> wrote:
>
> During device probe (for example, in ax88772_bind()), drivers may invoke
> phylink_connect_phy() before the net_device is registered (while
> dev->reg_state is NETREG_UNINITIALIZED) and without holding the RTNL lock=
.
> If connecting or bringing up the PHY fails inside phylink_connect_phy(),
> the error cleanup path invokes phy_detach(). In phy_detach(), dev->hwprov
> is dereferenced using rtnl_dereference(), which expects the RTNL lock to =
be
> held. Because the RTNL lock is not held, lockdep triggers a suspicious RC=
U
> usage warning:
>
> WARNING: suspicious RCU usage
> drivers/net/phy/phy_device.c:1944 suspicious rcu_dereference_protected()
> usage!
>
> Call Trace:
>  <TASK>
>  dump_stack_lvl+0xe8/0x150 lib/dump_stack.c:120
>  lockdep_rcu_suspicious+0x140/0x1d0 kernel/locking/lockdep.c:6972
>  phy_detach+0x219/0x550 drivers/net/phy/phy_device.c:1944
>  phylink_connect_phy+0x1dc/0x300 drivers/net/phy/phylink.c:2251
>  ax88772_init_phy+0xe3/0x390 drivers/net/usb/asix_devices.c:714
>  ax88772_bind+0x9cb/0xe50 drivers/net/usb/asix_devices.c:925
>  usbnet_probe+0xab3/0x2ad0 drivers/net/usb/usbnet.c:1808
>  </TASK>
>
> Fix this by using rcu_dereference_protected() in phy_detach() with a
> condition checking whether the RTNL lock is held or dev->reg_state =3D=3D
> NETREG_UNINITIALIZED. This allows safe cleanup on probe failure before
> device registration without requiring drivers to acquire the RTNL lock.
>
> Fixes: 35f7cad1743e ("net: Add the possibility to support a selected hwts=
tamp in netdevice")
> Assisted-by: Gemini:gemini-3.7-flash syzbot
> Reported-by: syzbot+694b49f41098a5df4fd7@syzkaller.appspotmail.com
> Closes: https://syzkaller.appspot.com/bug?extid=3D694b49f41098a5df4fd7
> Link: https://syzkaller.appspot.com/ai_job?id=3D360ce09e-643b-4b98-9061-0=
d730f847be9
> To: "Andrew Lunn" <andrew@lunn.ch>
> To: "David S. Miller" <davem@davemloft.net>
> To: "Eric Dumazet" <edumazet@google.com>
> To: "Heiner Kallweit" <hkallweit1@gmail.com>
> To: "Jakub Kicinski" <kuba@kernel.org>
> To: <netdev@vger.kernel.org>
> To: "Paolo Abeni" <pabeni@redhat.com>
> To: "Kory Maincent" <kory.maincent@bootlin.com>
> Cc: <linux-kernel@vger.kernel.org>
> Cc: "Russell King" <linux@armlinux.org.uk>
>
> ---
> v2:
> - Moved the fix to phy_detach() in phylib by allowing rcu_dereference_pro=
tected() when dev->reg_state is NETREG_UNINITIALIZED, instead of acquiring =
RTNL in asix.
> - Updated the commit subject and description to reflect the changes in ph=
ylib.
>
> v1:
> https://lore.kernel.org/all/2835933a-117e-405a-a369-86459e8c8299@mail.ker=
nel.org/T/
> ---
> diff --git a/drivers/net/phy/phy_device.c b/drivers/net/phy/phy_device.c
> index 94b2e85e0..50c7a060b 100644
> --- a/drivers/net/phy/phy_device.c
> +++ b/drivers/net/phy/phy_device.c
> @@ -1939,9 +1939,13 @@ void phy_detach(struct phy_device *phydev)
>                 struct hwtstamp_provider *hwprov;
>
>                 /* hwprov may technically be protected by ops lock but
> -                * not for devices with a phydev, see phy_link_topo_add_p=
hy()
> +                * not for devices with a phydev, see phy_link_topo_add_p=
hy().
> +                * RTNL is not held when cleaning up on probe failure bef=
ore
> +                * device registration.
>                  */
> -               hwprov =3D rtnl_dereference(dev->hwprov);
> +               hwprov =3D rcu_dereference_protected(dev->hwprov,
> +                                                  lockdep_rtnl_is_held()=
 ||
> +                                                  dev->reg_state =3D=3D =
NETREG_UNINITIALIZED);

should that be `dev->reg_state !=3D NETREG_REGISTERED`?

>                 /* Disable timestamp if it is the one selected */
>                 if (hwprov && hwprov->phydev =3D=3D phydev) {
>                         rcu_assign_pointer(dev->hwprov, NULL);
>
>
> base-commit: df2908090cda368b01ff43709f51890076c56157
> --
> This is an AI-generated patch subject to moderation.
> Reply with '#syz upstream' to Sign-off the patch as a human author
> and send it to the upstream kernel mailing lists.
> Reply with '#syz reject' to reject it ('#syz unreject' to undo).
>
> See https://goo.gle/syzbot-ai-patches for information about AI-generated =
patches.
> You can comment on the patch as usual, syzbot will try to address
> the comments and send a new version of the patch if necessary.
> syzbot engineers can be reached at syzkaller@googlegroups.com.
