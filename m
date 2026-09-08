Received: from mail-ot1-f46.google.com (mail-ot1-f46.google.com [209.85.210.46])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 08D2D39B978
	for <syzbot@lists.linux.dev>; Tue,  8 Sep 2026 09:33:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.210.46
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788859990; cv=pass; b=Yb70+PTJ7yVcJVfYI1R0buWjeqscNwhIm1COzjJOJEmnNox8XoZcIWFWJpki0kXCAyBgw6GqBSNdPz0U851OeyC7OdKdJXSp38V4bV2ShH9QA4sy4VTY4c5r7PdCSr3/3XK7H3s0XpfPIn3MHOglgQ0QcpUaYfwfHMy/2RS41Wc=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788859990; c=relaxed/simple;
	bh=mhZJw1lItxN4uyMTIUmMeKIDDgykIncS4/7v7ktlTw0=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=KMhPZTU/xTMEOp6l6PSLgkhKfQGzBUWeEbwUlRT+N1I7JL+hdJ5fG/DEDMBjeN+AgG63d8sBS3jUOfCfULoxGFgW86Hkdku0UOOY29aPegR81sYgh/kf6Tah8BS187Ot4G0XA2wFDW9bEP8xax1Eu+5aImCln44JcAAARemhM0g=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=KijD41Pf; arc=pass smtp.client-ip=209.85.210.46
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="KijD41Pf"
Received: by mail-ot1-f46.google.com with SMTP id 46e09a7af769-7f4e596e393so4378811a34.1
        for <syzbot@lists.linux.dev>; Tue, 08 Sep 2026 02:33:08 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1788859988; cv=none;
        d=google.com; s=arc-20260327;
        b=Gf6FixpYR37iKTn0ZJpPcfNERo0NmnQKaAlykP+PKuJ8j6uS2Fr34Rq1IPlb/Ae3Ot
         zQq4xfRIo9XSl5SkgSYjX/AWS8H79fGn2Vf6ncyBOO7cFUXGsoe1oPahai/mvrxIqX+D
         f5YSAeolxEBQ/BuhM3pma+oIvRI1DGAu3sSEXx0eiX8NpYzqbz5lzTB9LkPKkUN7R2Bf
         fwgmQg/Vg037TWNRHQQo7j68XJavwlq7V3/RwkdbzuYSBRRJTPbdzftsYGFSjzYg4bNg
         utTlXSlDqCoOnxbSTfRb+PGxeWtT5d/e4H80I6J48RBKmIftXZQPWJfJgzxqBEM+YbyJ
         hczQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=To6IX9R2BZVBls/IG4QT4peIRZYibtyb26HFuoqhd7A=;
        fh=GEBq45E61ARrUxC+IYEWaNdma6jSBSJ1s/zN7wrYWvM=;
        b=OxqtmeYFe3Mh3nEu3vWznry9L8QxDB6DZQbps15JHwJK5hlsHGrQJebbKKUIIG2/oB
         b7NiwXA+2a1IhHOlXPHAbTvOyuIqd49aOmueTYDVCIxZcabNcMh8zogAjQPckZ8oKICU
         tWan446wLFjfNt8tkjLAlrMO/Zupf68TdmyIyTgRMHqp194IBU+g/uyWdRRbXf1QXh8t
         lyiBQo1VmMgb7nQRiwewN9VfKGuNcnlHzLGw83mJ2fnFrzjQHAUkOm0DJ0CgIlYZOw7q
         Ld9pPhZicdC0IkHXir3BxM4WqS2pt62NoL+NxF54mPBzAJbml05VYrhir4eeow2uMCnh
         kaQw==;
        darn=lists.linux.dev
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1788859988; x=1789464788; darn=lists.linux.dev;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=To6IX9R2BZVBls/IG4QT4peIRZYibtyb26HFuoqhd7A=;
        b=KijD41PfYcs8ESY5pO0W3jOA0TPaS1KO1iuXl+kG7hfsQGh+vBbH8h/Dzih61u+X/3
         srtUO+F0jkxoMp4xz/qQ+4nLNdceIZqL9uZjz/CkT/vyS9wjyTAhaLyCz7RgDYgzAoN9
         tDG4E/f4vSracxCksTKsW94YylFNrncfacCnJpKUwvI43yUr/RT4+J1AMIE++W23rbqW
         sk/opV34UsCcae0/pyiV20kj3yL/J6ILRSSkEhzCuvfBUyYFHICCD5W38shJKbgDyAlG
         7lFV6arI8SbXEHw/0ph/PyX+EkvA8BqnrrIkTErkkvFc8InR/B9VoSmrSR1NBITjF8Ir
         VCLw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1788859988; x=1789464788;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=To6IX9R2BZVBls/IG4QT4peIRZYibtyb26HFuoqhd7A=;
        b=iFb/EaYOtkVYIcEkUuolSbyJlmzCVfWxAlBXiUryeymLQXS0XAFfVhmoDBGw5M1YnM
         LuwXSZ4O8z3lfo03f7qUVOSzKGYL64yl2/26BAC10Oq0PKIX8/aLIXRwO61AKbn9JsF4
         85N7JiVjttlXIUuVZJIl0kdi0y/ucyEYCkzgMU2/zSJBuP658kTQo3jR/mulXtBcUT5U
         vEO4xBjfqbZf2uBfbQ0AB4Y+odthiLpxt19XA/lXHFpaxxjxuy6zYFRKoXZ0Okxwgibf
         SUmpiCSIylQRs+MStg+y0rNReUZ+nDz9nnrJ0pZWxDrTdNR8n3nFb5KH4xixzzewZg80
         kj/A==
X-Forwarded-Encrypted: i=1; AKwUvBxCsfs8Oh7F47fDqBag9GpEg8bBvruuO+MRwgYogVBYtKUKEL/UObGg9wigW3gq3OI4LqvDFko=@lists.linux.dev
X-Gm-Message-State: AFuF++niyzqiyV9UXJm0YNdS68h0evJ7LV47Gd5Q3Xiz3w1QKa1d6WVn
	D5PjTmGNaULOpXTjtPUI8Gwlcry/wcIttmlNu24GhiObbMvamGgGwaTaOonbtDHzdj0z9SGUsdr
	ZmLiOtfdUWepDTyCnKESI7F7Q1qriJC7Jo6QQf7pX
X-Gm-Gg: AYBFou2tkryA0zhfeEW+v5z5MQ90cTknOGVhVMOx2HMggwB6UGE5jxRUhyIxWM5ur9Z
	+ZkG410ucVlfZiBjTE7TW1ruyD8mCI3Perjig//dD4iiKSd0GGemc4wlxcfw7Rh/6ASukuCc29Y
	2Bz2oIo2hmimcgufvDAyEIUP93wTMlsfiV86IlJVgJAIZllr+Gw4NGCjhqqzArR7+MNmewB+fae
	bShB9z+QhvsVwimvC+91rBoRe7sWvjTcwk94DzH9oAC+T96C8qC74PST1ellZjFup4ReaAkGk51
	4B46qY2YNi4S6hZ1xgqvuW5clTdi76M6GvNeDgXIFuvYzXPgIPamguh9np8JmQ1krpcaisoUwqN
	e+oB6+zK3tsBOP+yzJTxX8JScnKC0PY8L8NoUpxySdDfbZDau8P35clyoA1Dfi4OQVQCpDRN+Hw
	v7fsoDjw4I0tlv
X-Received: by 2002:a05:6830:8284:b0:7fa:ac4f:79a with SMTP id
 46e09a7af769-7faac4f0eb7mr15521780a34.22.1788859987240; Tue, 08 Sep 2026
 02:33:07 -0700 (PDT)
Precedence: bulk
X-Mailing-List: syzbot@lists.linux.dev
List-Id: <syzbot.lists.linux.dev>
List-Subscribe: <mailto:syzbot+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:syzbot+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <2835933a-117e-405a-a369-86459e8c8299@mail.kernel.org>
In-Reply-To: <2835933a-117e-405a-a369-86459e8c8299@mail.kernel.org>
From: Aleksandr Nogikh <nogikh@google.com>
Date: Tue, 8 Sep 2026 11:32:55 +0200
X-Gm-Features: AcwNN1UjXcLE0TF2ryOHe73_547Wqp-CLP_4pSBJFlmYGJK5MHDHFDHFL6CQ7Ko
Message-ID: <CANp29Y49REGo09mcAXVQBWfAg9v3ipVUPuVLKp8s29creF_Wrw@mail.gmail.com>
Subject: Re: [PATCH RFC] net: usb: asix: hold RTNL lock around phylink_connect_phy()
To: syzbot <syzbot@kernel.org>
Cc: syzkaller-upstream-moderation@googlegroups.com, syzbot@lists.linux.dev
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

This papers over a phylib issue in an individual MAC driver.

phylink_connect_phy() does not require the RTNL lock, and taking RTNL
in USB probe (ax88772_bind) introduces lock inversion risks. The real
bug could be in phy_detach().

On Mon, Sep 7, 2026 at 9:04=E2=80=AFPM 'syzbot' via
syzkaller-upstream-moderation
<syzkaller-upstream-moderation@googlegroups.com> wrote:
>
> During device probe in ax88772_bind(), ax88772_init_phy() invokes
> phylink_connect_phy() to connect the PHY to the phylink instance without
> holding the RTNL lock. If phylink_bringup_phy() fails inside
> phylink_connect_phy(), the error cleanup path invokes phy_detach(). In
> phy_detach(), dev->hwprov is dereferenced using rtnl_dereference(), which
> expects the RTNL lock to be held. Because the RTNL lock is not held,
> lockdep triggers a suspicious RCU usage warning:
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
> Fix this by acquiring and releasing the RTNL lock around the call to
> phylink_connect_phy() in ax88772_init_phy(). This ensures that the RTNL
> lock is held when connecting the PHY and during any cleanup in phy_detach=
()
> on failure.
>
> Fixes: 35f7cad1743e ("net: Add the possibility to support a selected hwts=
tamp in netdevice")
> Assisted-by: Gemini:gemini-3.7-flash Gemini:gemini-3.1-pro-preview syzbot
> Reported-by: syzbot+694b49f41098a5df4fd7@syzkaller.appspotmail.com
> Closes: https://syzkaller.appspot.com/bug?extid=3D694b49f41098a5df4fd7
> Link: https://syzkaller.appspot.com/ai_job?id=3D9fb2ef8a-63d1-4762-bbc3-0=
10edc6ff458
> To: "Andrew Lunn" <andrew+netdev@lunn.ch>
> To: "David S. Miller" <davem@davemloft.net>
> To: "Eric Dumazet" <edumazet@google.com>
> To: "Jakub Kicinski" <kuba@kernel.org>
> To: <linux-usb@vger.kernel.org>
> To: "Russell King" <linux@armlinux.org.uk>
> To: <netdev@vger.kernel.org>
> To: "Paolo Abeni" <pabeni@redhat.com>
> To: "Kory Maincent" <kory.maincent@bootlin.com>
> Cc: "Ethan Nelson-Moore" <enelsonmoore@gmail.com>
> Cc: <linux-kernel@vger.kernel.org>
> Cc: "Oleksij Rempel" <o.rempel@pengutronix.de>
> Cc: "Peter Korsgaard" <peter@korsgaard.com>
>
> ---
> diff --git a/drivers/net/usb/asix_devices.c b/drivers/net/usb/asix_device=
s.c
> index 293ef80c4..67b22c736 100644
> --- a/drivers/net/usb/asix_devices.c
> +++ b/drivers/net/usb/asix_devices.c
> @@ -711,7 +711,9 @@ static int ax88772_init_phy(struct usbnet *dev)
>                 return -ENODEV;
>         }
>
> +       rtnl_lock();
>         ret =3D phylink_connect_phy(priv->phylink, priv->phydev);
> +       rtnl_unlock();
>         if (ret) {
>                 netdev_err(dev->net, "Could not connect PHY\n");
>                 return ret;
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
>
> --
> You received this message because you are subscribed to the Google Groups=
 "syzkaller-upstream-moderation" group.
> To unsubscribe from this group and stop receiving emails from it, send an=
 email to syzkaller-upstream-moderation+unsubscribe@googlegroups.com.
> To view this discussion visit https://groups.google.com/d/msgid/syzkaller=
-upstream-moderation/2835933a-117e-405a-a369-86459e8c8299%40mail.kernel.org=
.
