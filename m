Received: from mail-ot1-f44.google.com (mail-ot1-f44.google.com [209.85.210.44])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 253C153A88F
	for <syzbot@lists.linux.dev>; Tue,  8 Sep 2026 14:52:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.210.44
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788879166; cv=pass; b=l6hkqdwbLjBw/vin2ec8kb9O+py6Wv9GCVNy8v1t7wBb/KKACvdFAfaHjIcECcCIPEOs5An8OaTeu5Ljyhn/jnygU2Xk+ezqjDjAyvfj5ZanEAyBiQ5K4vEr2nSyDWCGzRQ8/ZmEuvNyUmsTSK6MgKa9h7pH6HVFZ4pFNbzNmk4=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788879166; c=relaxed/simple;
	bh=QU01LWw5RhwGddkEtsJPpWMGZwK1J3kNWdxdc+J+iu0=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=hbh3/e71GQH59jtFG/ajJj8kKk3cJ+1d+HoAKMD+z1EOethSoCtgiJSW4Un0Zz2rC3ds+F0pRfwEIl85HMzNRjXQuqo3e7tvRxcWr5UexfT/lvU+ZXWgRPeGuB6Y+8rME4/aRuh6DCnP8JwGiRsrAZDJjlCY8NDeo6B8adIq7Co=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=Br6pGXG3; arc=pass smtp.client-ip=209.85.210.44
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="Br6pGXG3"
Received: by mail-ot1-f44.google.com with SMTP id 46e09a7af769-7ffe6893503so626733a34.2
        for <syzbot@lists.linux.dev>; Tue, 08 Sep 2026 07:52:36 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1788879150; cv=none;
        d=google.com; s=arc-20260327;
        b=imoNqnhyjCQEwjoIHNIoUJ9kcnf0gtpUVE9HDU+tEOINRAUb1hxHdacLf169VW5Wl1
         UNCvzqe9oWLy0EISkBLuF1yu6F22VZ9JkXd6Beps8KB5lJ1gQmaMx6FlGvy5WDUHlg7e
         g3QFLXBlG19pNP9DEEeOOGD63nfkqfugc1jou3vv+V0GHDlru64fPixuaXDzolCxpM05
         UAqPNYJXSzGJOo4dexV2+4LJyQfN2wwBJg9Jtzw2g/YobI5RVlUFkeIo5wIp6o9GYplL
         EASJdVJN2MHnFzLtInj+8nI/anz8NX7VuevNYXJ/LzsHnC2AodjbBt87UUi2s598WOjE
         r1mw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=P2wTm+M7L3c2LBRJXVPz3AkTs2Cmv+dRzugqf4j409U=;
        fh=e2Xydg7hj5kDnjVsLWqnKkffzXjEdoU5TYjOA7nE8qo=;
        b=BNUFAZY0ovG10T2QhK76pJA139rK163IhsSc289S4oP2pvpyf0unnT6fcW6V9jwlwJ
         dB8zj3tcm2BRqRaFLbC7aoDISu1uczI8JMymtq669AcCAQow2GObynwCl1k1S7F3EXTR
         Q7ji/AtqutiWfstfHW1xbwAWDRfG7cyysIFm10m1Ylaj1jr52D/hCLibhTARfSvWmLPL
         MPbIHTkwnD1GUTQb+/YJwp/u9wdgnqpxQlec6UCETogERsCkqbmXLTkXfiiBuqQNcSyI
         nAXf+oBB/K3e/9netEJiXQ1H6gGuW0v2y3KpsIpO+hLXsyCeQcN0LNdT+O5yN84gwF44
         SRUg==;
        darn=lists.linux.dev
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1788879150; x=1789483950; darn=lists.linux.dev;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=P2wTm+M7L3c2LBRJXVPz3AkTs2Cmv+dRzugqf4j409U=;
        b=Br6pGXG32uiwmhyOYSgGvYH5p2cByxjf7ChO3I17hxVGgWEWOKxG+wGor7uJUXAw/G
         SOV7mEazfN3FRJx08+k3GEMLVB3t0y7lpmGoUN/lbF+o2I8ZS3QkSSxpBGBnNSYtYE3g
         JDEAJ6pBFGGLgX9PxDqQUIGfmBj6lB/Y0UzjGxfijg/OViPQoAOrF/TYeZZaBUIwJ3Sb
         x3HqldFVXMiqKFoEmipMg2EFrIfOt7FoKpAX+MyQrHp1KEDjKHmUc9efsT7KJic4zbZ3
         da2U/SFcsqwWiKrZFqBQ1Lr3fG3n8AAZ4AQqRp90KKD49olJXwDMj8Owr5+EAO/xzrnO
         yEYQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1788879150; x=1789483950;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=P2wTm+M7L3c2LBRJXVPz3AkTs2Cmv+dRzugqf4j409U=;
        b=VnY0DXFir0A/5AdueHggbCkS20aeA6csBzzDqC8ehuu5NoJ/iuem8eliTqqlE/p8TB
         fBtAub2xIvPPptkNd9gkOuwpodcWc4hecTbJLiv+ea5JhffLRnElBQuhofffZHHTL3dU
         +zsb/xVHUOzSN/Wtn4/GIPEPEmOirRFJ0cbQD7zmKycFIFM//UJQL6tRD5fIzcZD7nay
         vB6nPEO+pojfjGVJA3NnTt0lS1xSmn4pCoxfRay6IKVdkLC4iSo5USjGerA5p6VeEjkH
         2QHGi4FwJT4CBxEbNWYJnKLVK7rQ4/g3HA0XyIRLfEcXD0Uhz+cf7zEnAtkCUEPpACxV
         +zyQ==
X-Forwarded-Encrypted: i=1; AKwUvByVnAtgGGirHedXaqKMYchLVBqDkHFCI8TCTYfCQWuC1S+R27T82AS4LADC40dctNqs1qgUsrA=@lists.linux.dev
X-Gm-Message-State: AFuF++kiviQRevdkvDwoVVTmqaEQxrMkMzr6NIoKKA7Do0ynLTk8GD5f
	Ny44t06kuMUnRfQQhVFFZO2LORHEuDTfIzLd6CetlrywOEH8Jwbw3BrofxDCrKwA5JVTdp3++wY
	RbDMs+dsXSPYOr/ToYHr9g2Ic4IavHwCwKys7GzRY
X-Gm-Gg: AYBFou39IxO7iOwT5gSsZf6PFWCehyo0svpZjB/Rk53WEYIKQj3Fdc3IqCzqY1aJNqh
	SZA11vpHtdwV4TMFoWnAlmQPhNu8rOQWG2ACznBXs61Tk+9OSgitsOPMa1RHFYX97HH++doORqB
	p2ojTTRR70+HuOEhBnwGYqOf8n7+FNNPMG12gdbixw1tEcIdO+vM669twwNsoDrUUTc6SO+uEjg
	N3zdEnQ7VoQQg108qPVp4pA5B2jDSoufyGjm5/dThhLwN+MJWasztsUbAjF+PSS6/WHe6BJjwpe
	ekGzB9F90zvQdACSCVKrAQqZn7HY7efVaSKOx11E1aH40Y5c96YpZLaYh4pMhywdS0YtJiMP9iJ
	2GiXhaqYUhqAyVtEcLGvHtiwbbn4Y/9y35KCgUPiINGfjE1ftIOFuSHiKF+y81/oc7t/4luscMH
	HaGlbOtyTdBoDo
X-Received: by 2002:a05:6820:603:b0:6b1:b867:1a1 with SMTP id
 006d021491bc7-6b6fc7d43ccmr27251302eaf.12.1788879149624; Tue, 08 Sep 2026
 07:52:29 -0700 (PDT)
Precedence: bulk
X-Mailing-List: syzbot@lists.linux.dev
List-Id: <syzbot.lists.linux.dev>
List-Subscribe: <mailto:syzbot+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:syzbot+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <5e1c820e-982c-4c4b-ae8f-682ae1fe2da2@mail.kernel.org>
In-Reply-To: <5e1c820e-982c-4c4b-ae8f-682ae1fe2da2@mail.kernel.org>
From: Aleksandr Nogikh <nogikh@google.com>
Date: Tue, 8 Sep 2026 16:52:18 +0200
X-Gm-Features: AcwNN1VH8-H9XURccaKk2br0WdDEYi3QTZxUI8PEloRVT0Wpu-6aRWCAT0An8-8
Message-ID: <CANp29Y59vwL6Prb3Yx3AbB_+DT=X+As1JiBBgR3=NEY40z8jFA@mail.gmail.com>
Subject: Re: [PATCH RFC v3] net: phy: fix suspicious RCU usage in phy_detach()
To: syzbot <syzbot@kernel.org>
Cc: syzkaller-upstream-moderation@googlegroups.com, syzbot@lists.linux.dev
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Tue, Sep 8, 2026 at 2:38=E2=80=AFPM syzbot <syzbot@kernel.org> wrote:
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

Update the description to be more understandable

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
> condition checking whether the RTNL lock is held or dev->reg_state !=3D
> NETREG_REGISTERED. This allows safe cleanup on probe failure before devic=
e
> registration without requiring drivers to acquire the RTNL lock.
>
> Fixes: 35f7cad1743e ("net: Add the possibility to support a selected hwts=
tamp in netdevice")
> Assisted-by: Gemini:gemini-3.7-flash syzbot
> Reported-by: syzbot+694b49f41098a5df4fd7@syzkaller.appspotmail.com
> Closes: https://syzkaller.appspot.com/bug?extid=3D694b49f41098a5df4fd7
> Link: https://syzkaller.appspot.com/ai_job?id=3D63daf6f3-5d22-4261-b346-d=
fd3a5537965
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
> v3:
> - Check dev->reg_state !=3D NETREG_REGISTERED instead of dev->reg_state =
=3D=3D NETREG_UNINITIALIZED in phy_detach().
>
> v2:
> - Moved the fix to phy_detach() in phylib by allowing rcu_dereference_pro=
tected() when dev->reg_state is NETREG_UNINITIALIZED, instead of acquiring =
RTNL in asix.
> - Updated the commit subject and description to reflect the changes in ph=
ylib.
> https://lore.kernel.org/all/5a7201b1-c826-4855-9105-3caa58977bc3@mail.ker=
nel.org/T/
>
> v1:
> https://lore.kernel.org/all/2835933a-117e-405a-a369-86459e8c8299@mail.ker=
nel.org/T/
> ---
> diff --git a/drivers/net/phy/phy_device.c b/drivers/net/phy/phy_device.c
> index 94b2e85e0..ac09943e1 100644
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
> +                                                  dev->reg_state !=3D NE=
TREG_REGISTERED);
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
