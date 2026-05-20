Received: from mail-ot1-f49.google.com (mail-ot1-f49.google.com [209.85.210.49])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8CD972C3251
	for <syzbot@lists.linux.dev>; Wed, 20 May 2026 13:50:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.210.49
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779285005; cv=pass; b=LPj2CK8LN5PoV/sCi05L/M39uHf+AINRGPBoBl+Xaa7iFoG34zyfu1DJYuV0Erdwwv2f4yJyFxbjmDZrKm0ssATazz/YpqfOidcjz0qo3sIXcs8dzoym2b0iPsqNA/Zxf/n744EbWzvUcn9mQQqzYN5jmUE4gJhr/GK5PZXJs4c=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779285005; c=relaxed/simple;
	bh=XVUhZqMJ5SJrNSbG+QCHZ4+Y9PrG6i1xUKsTN6dNKe8=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=cz1Mxg0kZt9fNOM0EZW5uaSqe86rE6jBaYhYTlKG0jjGm+DSVg3h3BVjt6CjqefxeNoUCqAJrwRuPeasciIKNSQ2eujb9xGwrqAule1xKLqpEXmIQrOFNCyN2aCvpUBO0pOusTepaa3f1APoBxLnSc1Su3Gl/S5amnhcWHJuHEo=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=GSVZiVlG; arc=pass smtp.client-ip=209.85.210.49
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="GSVZiVlG"
Received: by mail-ot1-f49.google.com with SMTP id 46e09a7af769-7dcdaf06498so3250160a34.2
        for <syzbot@lists.linux.dev>; Wed, 20 May 2026 06:50:03 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1779285002; cv=none;
        d=google.com; s=arc-20240605;
        b=bqDDnZ2wAu85e4Y1aWy85hEnuBKNWNKpzU1BIfPLTqCquJDj6M2zVdE7m3hv16C/Qf
         pg8u21icW7zY+xZ27y3t/CnNCdy4RUeQDC7MTNEKc3NB1HrYMNhVqB+fgVsf72rzUZzV
         /USlCw5LNzQ3W+MBFhKTFxmdbRLT3udeowvPFSr9KjieDTO+AGHw6j2mx2fTxWsFCbts
         RFM9BerKKeuqiH/iLMrwHoC5gS6PFdt4M7axdQt1XYsJObJfZYDq3b3xfNbjAtsDl+JU
         4U5rXMsnNZuMhdF14qdFkBDT6X+QrwBgd4nw4WOIki/3YQL0VIKG4GR/R15OFksTCtuw
         tbew==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=uwq7ma0VcZeQ0sbzdz6jsI7yCCEmy43AJ97SkFd1oFc=;
        fh=5YblCD2yAxMeKgOHqCpDfLf0PYWG0Y8gacwGiv76Zko=;
        b=YlGvHsyqL9y3Fhx7V/3FouXOgAfa8bXliyM2ghKtlRZLQX1yFESRHiQ+AbspyHzask
         ZCeZf/DK3+8oS351sxrnLOFn2CaRrNH7/W8/tpbj2tGEHDbMvhwHDQYdpnRYllZ14Tkt
         CF+QAPE8/Uj6E78AcEs3WImGDOq9j227q96IMnIBqGWmamC2JVvXJVFjfVONEc882IpQ
         Hu+IGgGzVy2XeQF/dOhRaRGSNDCejbdhAMNNdB5rgL/1k0yzsElHkiPCDkEmrR/i4ObS
         qEIIeMckK1qbW1uJNWRJ7b3YOEOVE70KnHe9PaVfyEajXLLTXpqgzgeABVL9bjsN6KTK
         dbBQ==;
        darn=lists.linux.dev
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1779285002; x=1779889802; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=uwq7ma0VcZeQ0sbzdz6jsI7yCCEmy43AJ97SkFd1oFc=;
        b=GSVZiVlG6t5dhX65tDWw8oKZkxsDR48/U2941kpwzkvw9nt6S6FvPdB0ClXSZ/yXQq
         XDLhSFf8f4TwWC1t9tyuQDKS7hyu7qFoEQr/YweqI5cXXiJNg2p/+2CJ1HNdynH88KQb
         fxwsjtW38RuWNwhcbZdNA3ZQyuVN5XBsHBBRhoY9T+fCJAe3NezmmgAPWafIusVtDYNI
         LvADftGS5KgTeZ8niDGzke7nH02nkqBLsQ6X2htg4AJyP1AsTQOShkSJak5v01Y8dxZ7
         hq3TUF6qVKTwMjcdezAywnMIT0iwtX66fCa1+v/tLw9L3KBOcp5jppXZ+WMshK2YaIRU
         +01A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1779285002; x=1779889802;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=uwq7ma0VcZeQ0sbzdz6jsI7yCCEmy43AJ97SkFd1oFc=;
        b=ItfjVYR8XwaO5khkDoVHZ938tCUm4rYpv/FyULfUqAjlzGjDG8mVaaSL2IGQiCllpI
         D74js5Sn82GRUes68er8eYVMOaTkKaoNqdaGRL9h4c9tPyuMRgPFY5LzQWal9eqN9iAV
         VBDHH3bQ7FflSnYgo9rD7ZHenVbMxOiMYto3Y8dTKFyN2P9leBf5dMmc2BYMSMHXL8mr
         pzTYruIMkHZJz5D1kt40xDwQkBHBXpfc3wYvbLl3YQE4O6XOZLFXJbr1SZt6BpPsJEmT
         aeIj3/1imhEht/tO96QIKsrJGLWxhCg8PjzMdsmUVW9CsTBjiV84j3dESm+VgBBx2DX2
         fOiw==
X-Forwarded-Encrypted: i=1; AFNElJ8zjXdMVSRhW+y+A+KWlQd4u1GP5/IhGGyqRBTgPST07/FnocINZXgx+8/Z+i7I/uEelB7Vt5A=@lists.linux.dev
X-Gm-Message-State: AOJu0YxznHzI88XB52H0nIrpUIZFsyw1wBFwdlBLBMdjAYK8ya0f8XfY
	Ow+dDT5rEJlZtvnRu0Xl3nr29AGxMKTy19QjDJKCekAqnDREbsrmRpaQkze+qpK16jwPZjMjWla
	jOGnLdHmRR2HCuufVoQ33Dl2BiHm8+RwoceT4jaIz
X-Gm-Gg: Acq92OEt9IO/8ke2bSbUneMAwuor9lMqsJjBFWaWcFEJzUYhSizgB0XekSt1qwKzYkW
	6fjPly9pzd3OPn2opFkxsxfKEHFMPHSbc+paJjg/ILp0v6hK89WaMyP4HPvzcVvbuBSTxYhWDBn
	ui7IVlO5zoPZ9RS4C8RiCZNsYZeo1WhTP4MPuJiywfEBUk2p2fXMOOcIsp8yHVhalCl49fIxnnh
	adh7Mm+d86oEgoLV6f1uSZifesCgGGWtos5ICCy29ObnJu89+toZPwVQNeoPQKo8J3hJRyMRiaD
	2dzhQHSKGynalzC0oUUaRbZ9yNLpZUzwa3382bjornyiMmLalFd0+9U9LpEMaJa2H2KmkVMuh7m
	XlggE
X-Received: by 2002:a05:6820:16a6:b0:69b:544f:c172 with SMTP id
 006d021491bc7-69c943714e6mr14677659eaf.25.1779285001760; Wed, 20 May 2026
 06:50:01 -0700 (PDT)
Precedence: bulk
X-Mailing-List: syzbot@lists.linux.dev
List-Id: <syzbot.lists.linux.dev>
List-Subscribe: <mailto:syzbot+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:syzbot+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <ba6abcc9-c09e-499a-92cf-3f59d45ef58a@mail.kernel.org>
In-Reply-To: <ba6abcc9-c09e-499a-92cf-3f59d45ef58a@mail.kernel.org>
From: Aleksandr Nogikh <nogikh@google.com>
Date: Wed, 20 May 2026 15:49:49 +0200
X-Gm-Features: AVHnY4IBU_J8_UAR_J4Yc03L1Bd_VodBI5bU-pIf2Kc8MsgsHUftwOTM6PuDp08
Message-ID: <CANp29Y4PuhA3gZnHKpXnVyuHzCXk5Y4QJfM5-Uv0OrD6ZY2Msg@mail.gmail.com>
Subject: Re: [PATCH RFC v3] wifi: cfg80211: replace WARN_ON() with pr_err() in
 netns switch
To: syzbot <syzbot@kernel.org>
Cc: syzkaller-upstream-moderation@googlegroups.com, syzbot@lists.linux.dev
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Tue, May 19, 2026 at 8:37=E2=80=AFPM 'syzbot' via
syzkaller-upstream-moderation
<syzkaller-upstream-moderation@googlegroups.com> wrote:
>
> The syzkaller reported a kernel panic in cfg802154_switch_netns() when
> device_rename() fails with -ENOMEM. The crash occurs because WARN_ON()
> is used to handle the memory allocation failure, which escalates into a
> kernel panic when panic_on_warn is enabled.
>
> Memory allocation failures are expected runtime events under memory
> pressure and should be handled gracefully. The WARN_ON() macro must not
> be used for conditions that can legitimately happen. Failing to rename
> the device or change the network namespace is not a fatal system error.
>
> Replace the WARN_ON() calls with pr_err() in both
> cfg802154_switch_netns() and cfg80211_switch_netns(), as well as in
> their respective pernet exit handlers (cfg802154_pernet_exit() and
> cfg80211_pernet_exit()). This ensures that memory allocation failures
> under pressure are handled gracefully, logging the error for debugging
> purposes without bringing down the entire system.
>
> Fixes: 66e5c2672cd1 ("ieee802154: add netns support")
> Assisted-by: Gemini:gemini-3.1-pro-preview Gemini:gemini-3-flash-preview
> Reported-by: syzbot+bd5829ba3619f08e2341@syzkaller.appspotmail.com
> Reported-by: syzbot <syzbot+bd5829ba3619f08e2341@syzkaller.appspotmail.co=
m>
> Link: https://syzkaller.appspot.com/bug?extid=3Dbd5829ba3619f08e2341
> Link: https://syzkaller.appspot.com/ai_job?id=3Dc84689f4-6a93-47bf-80ca-3=
bc6137dce52
> To: <alex.aring@gmail.com>
> To: <davem@davemloft.net>
> To: <edumazet@google.com>
> To: <kuba@kernel.org>
> To: <linux-wpan@vger.kernel.org>
> To: <miquel.raynal@bootlin.com>
> To: <netdev@vger.kernel.org>
> To: <pabeni@redhat.com>
> To: <stefan@datenfreihafen.org>
> Cc: <horms@kernel.org>
> Cc: <johannes@sipsolutions.net>
> Cc: <linux-kernel@vger.kernel.org>
> Cc: <linux-wireless@vger.kernel.org>
>
> ---
> v3:
> - Replaced dev_err() with pr_err() for error logging.
> - Introduced revert_err variable to prevent overwriting the original erro=
r code during netns cleanup.

You have completely misunderstood Dmitry's comment on v2!
Please revert the code changes to what they were in v2, and update the
patch description.
I'll repeat the comments re. description:


1. Don't concentrate on the fact that syzkaller triggered it, this
detail is irrelevant.

2. Don't assume that panic_on_warn is set. It is usually not set on
production systems, and it won't be fatal system error. Say just that
WARN_ON is not a correct way to handle conditions that can happen.



>
> v2:
> - Replaced pr_err() with dev_err() to include device details in the error=
 messages.
> https://lore.kernel.org/all/4e2d36a7-9417-4c50-9ec1-3e82c7a670f3@mail.ker=
nel.org/T/
>
> v1:
> https://lore.kernel.org/all/7d949fbc-9781-4428-bfac-e51501b18bf7@mail.ker=
nel.org/T/
> ---
> diff --git a/net/ieee802154/core.c b/net/ieee802154/core.c
> index 89b671b12..dcf46b848 100644
> --- a/net/ieee802154/core.c
> +++ b/net/ieee802154/core.c
> @@ -234,6 +234,8 @@ int cfg802154_switch_netns(struct cfg802154_registere=
d_device *rdev,
>         }
>
>         if (err) {
> +               int revert_err;
> +
>                 /* failed -- clean up to old netns */
>                 net =3D wpan_phy_net(&rdev->wpan_phy);
>
> @@ -243,9 +245,11 @@ int cfg802154_switch_netns(struct cfg802154_register=
ed_device *rdev,
>                         if (!wpan_dev->netdev)
>                                 continue;
>                         wpan_dev->netdev->netns_immutable =3D false;
> -                       err =3D dev_change_net_namespace(wpan_dev->netdev=
, net,
> -                                                      "wpan%d");
> -                       WARN_ON(err);
> +                       revert_err =3D dev_change_net_namespace(wpan_dev-=
>netdev,
> +                                                             net, "wpan%=
d");
> +                       if (revert_err)
> +                               pr_err("failed to revert netns: %d\n",
> +                                      revert_err);
>                         wpan_dev->netdev->netns_immutable =3D true;
>                 }
>
> @@ -255,7 +259,8 @@ int cfg802154_switch_netns(struct cfg802154_registere=
d_device *rdev,
>         wpan_phy_net_set(&rdev->wpan_phy, net);
>
>         err =3D device_rename(&rdev->wpan_phy.dev, dev_name(&rdev->wpan_p=
hy.dev));
> -       WARN_ON(err);
> +       if (err)
> +               pr_err("failed to rename device: %d\n", err);
>
>         return 0;
>  }
> @@ -350,8 +355,10 @@ static void __net_exit cfg802154_pernet_exit(struct =
net *net)
>
>         rtnl_lock();
>         list_for_each_entry(rdev, &cfg802154_rdev_list, list) {
> -               if (net_eq(wpan_phy_net(&rdev->wpan_phy), net))
> -                       WARN_ON(cfg802154_switch_netns(rdev, &init_net));
> +               if (net_eq(wpan_phy_net(&rdev->wpan_phy), net)) {
> +                       if (cfg802154_switch_netns(rdev, &init_net))
> +                               pr_err("failed to switch netns on exit\n"=
);
> +               }
>         }
>         rtnl_unlock();
>  }
> diff --git a/net/wireless/core.c b/net/wireless/core.c
> index 6783e0672..674802d1c 100644
> --- a/net/wireless/core.c
> +++ b/net/wireless/core.c
> @@ -173,6 +173,8 @@ int cfg80211_switch_netns(struct cfg80211_registered_=
device *rdev,
>         }
>
>         if (err) {
> +               int revert_err;
> +
>                 /* failed -- clean up to old netns */
>                 net =3D wiphy_net(&rdev->wiphy);
>
> @@ -182,9 +184,11 @@ int cfg80211_switch_netns(struct cfg80211_registered=
_device *rdev,
>                         if (!wdev->netdev)
>                                 continue;
>                         wdev->netdev->netns_immutable =3D false;
> -                       err =3D dev_change_net_namespace(wdev->netdev, ne=
t,
> -                                                       "wlan%d");
> -                       WARN_ON(err);
> +                       revert_err =3D dev_change_net_namespace(wdev->net=
dev, net,
> +                                                             "wlan%d");
> +                       if (revert_err)
> +                               pr_err("failed to revert netns: %d\n",
> +                                      revert_err);
>                         wdev->netdev->netns_immutable =3D true;
>                 }
>
> @@ -204,7 +208,8 @@ int cfg80211_switch_netns(struct cfg80211_registered_=
device *rdev,
>         wiphy_net_set(&rdev->wiphy, net);
>
>         err =3D device_rename(&rdev->wiphy.dev, dev_name(&rdev->wiphy.dev=
));
> -       WARN_ON(err);
> +       if (err)
> +               pr_err("failed to rename device: %d\n", err);
>
>         nl80211_notify_wiphy(rdev, NL80211_CMD_NEW_WIPHY);
>
> @@ -1809,8 +1814,10 @@ static void __net_exit cfg80211_pernet_exit(struct=
 net *net)
>
>         rtnl_lock();
>         for_each_rdev(rdev) {
> -               if (net_eq(wiphy_net(&rdev->wiphy), net))
> -                       WARN_ON(cfg80211_switch_netns(rdev, &init_net));
> +               if (net_eq(wiphy_net(&rdev->wiphy), net)) {
> +                       if (cfg80211_switch_netns(rdev, &init_net))
> +                               pr_err("failed to switch netns on exit\n"=
);
> +               }
>         }
>         rtnl_unlock();
>  }
>
>
> base-commit: 5d6919055dec134de3c40167a490f33c74c12581
> --
> This is an AI-generated patch subject to moderation.
> Reply with '#syz upstream' to send it to the mailing list.
> Reply with '#syz reject' to reject it.
>
> See https://github.com/google/syzkaller/blob/master/docs/syzbot_ai_patche=
s.md for more information.
>
> --
> You received this message because you are subscribed to the Google Groups=
 "syzkaller-upstream-moderation" group.
> To unsubscribe from this group and stop receiving emails from it, send an=
 email to syzkaller-upstream-moderation+unsubscribe@googlegroups.com.
> To view this discussion visit https://groups.google.com/d/msgid/syzkaller=
-upstream-moderation/ba6abcc9-c09e-499a-92cf-3f59d45ef58a%40mail.kernel.org=
.
