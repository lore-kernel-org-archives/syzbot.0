Received: from mail-oa1-f43.google.com (mail-oa1-f43.google.com [209.85.160.43])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B740424293C
	for <syzbot@lists.linux.dev>; Mon, 18 May 2026 16:35:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.160.43
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779122109; cv=pass; b=M5cw/nrZtKwl7/WFvIiIoh+Yv/VT2aRE5v7FgtCrZ8JhDusA2PSDaYtbTx/ecfzNEM7PRVMeA6OMpzzoMj112+UQh6lRUytgrUB+GASzYpnT9t/YW1vtxGOXrlXTdmnqDD27Z7cUq3g/mCrjIGTMIFgcFZVhyT076S09zPRQdSI=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779122109; c=relaxed/simple;
	bh=BFIxaCguGfuWs8tjOGPpC2AYo47e2VtRKPnyb530AJU=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=qU9g04hlUYuU3WSX755ZXujaFK9P4fyEwxYU7G6jIhhBP+6oyZ2/FnfbCZCC7uMmm3kO3MbFH4T/kiF9liuslPemS6RI+1JNPLDprjYer/xhh6kApq1G+K4MY8oi3+TD4tqPho/tF1qbllnlnZUI0Hc70g+AaBDJacvQYW7zETw=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=kfONXkmT; arc=pass smtp.client-ip=209.85.160.43
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="kfONXkmT"
Received: by mail-oa1-f43.google.com with SMTP id 586e51a60fabf-40ef10ec84cso2166761fac.2
        for <syzbot@lists.linux.dev>; Mon, 18 May 2026 09:35:07 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1779122106; cv=none;
        d=google.com; s=arc-20240605;
        b=WVPz+pz01AU5DSD96Ewj/BwxOyqfOm0R/C9TV9zUfuDd+ZWM2CntxVcaR8sPp4dksC
         0WVtOzdUgBkzoWVVDjNDgb3NTvPuUE5DxipfV7CJUtCdTpJYzA+4lHQiM18tbyXHUKVl
         RH8AWPi8/ad2pFo5MMeCWqYuBSng/rFiE1rv6mfNX9ZBhww8L0LIyLIgZHF42t34qRTo
         HrF58hjy2CNDNT03xbuNRLqH1i1tSTp3UcdsST6KfVJ5jwFQnbYmtIQ+WG5+MJxNNygA
         wR8BfM0BOrv5RYnHx1Atuc+GAKP+YtZMpTUkiJaGnd4dCVHGSnY+uiJXpSmGz1leJx5U
         wvkg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=DWGPhcXPV82+Y4tFCevnHxNRJeNYF0dLd4U5uCBzmac=;
        fh=O9spw6fMLRvLPSi4N2n+oWWTASJzcslilPeWlT0DzIQ=;
        b=SbcEFfERWCrkVTd1UaCf6+q/3FIvvN9wh5XPHTX97s6XMPX4Zy2OeBcvDF8u7auW1E
         RwJRerM9EmSVAJ8wXTGSqeLGp1RU69VamPKIHB5LwETvd1hGfHpUNNIwZDysMRxpQy+u
         4OtJ7bGd5h7zWI71axW1KuHsdUmOe82LI7R4l2w79HGdbz2qHXjxDQN6f6H5oSQ6rfMp
         +Mqfa3RZmga+9gluscl4XH9Czig5/xGlTRPwS8wJFpUMxQly7hHyBqhfRZmTmDpiX1bw
         opEghkHqjpoDj8aFSqWkWWSNx19P3OciGi5YlnX17C1oNpHIy+GVBgcpyAL1GDGJUzbp
         4C1A==;
        darn=lists.linux.dev
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1779122106; x=1779726906; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=DWGPhcXPV82+Y4tFCevnHxNRJeNYF0dLd4U5uCBzmac=;
        b=kfONXkmTwAijPkkYx11jdrKvqoefyLWPEdEf/lYCYuACfzXPKGFdiaVlcBEb+ZSWNh
         /TWFMDF2yoMZ4glgxWvwsqh8YSQr5HkiJZ/OiEnNa2MRyMB5wwn2x/GzoGm+1YNFiYT9
         kuMidy3ZUv7OQ2QbUGtah628z14yd5qbqhcBvrngbsD55BnYHzzNVlZHdK4/GjievlC3
         L82e0DB0y/68dTvOtPvbQWZBvhRjtkhNeDxP2Q3LJQqp0+lpFeN+by+2RfUMwDNAaVK9
         dBxzVM4yfXzHv6lbkl4NajbLusugWRDqmDs4FahSqiPCrNM3KJNpB3DQiwxUvfitFp8M
         ayTQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1779122106; x=1779726906;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=DWGPhcXPV82+Y4tFCevnHxNRJeNYF0dLd4U5uCBzmac=;
        b=NrqkRMXuXFm8AlbxXk8FgFt9PJX7SLv88oqx0kDBOb4VsxRGVaLLjM5ke2xEHSR+nJ
         VloHg0r6kFCM4cuhAE6JZ6fK6g/E1J8YIFMFK0QVhtTtKR5ZFr/Lbghu6j8nobs9jLeC
         US3pYLwrfzZS+MyDZSdlg21+3jhQYp0Lz+5stW3w/2zVK52+4lAOPe1sy1bZynfzxjwF
         vzYhvziHfYyVZg66PunJo7dDKz55UECKQtn7sYmArU3vA9Y4uKLLLIaawxhQnTtJwjEG
         6zMnzFfusiAAYmkkExG+ZVj0sPb8rcMnP+b2rVfuu+O/mXNfNQl8p+S5OCTO1CtfjpVJ
         wCoQ==
X-Forwarded-Encrypted: i=1; AFNElJ+xvSpb7xSsRL03mJFLpfXgtaTismM2f32T2o1PuDPqfaoQxZRQaL8WjhdQ8oQ1gvgWrhpiDDw=@lists.linux.dev
X-Gm-Message-State: AOJu0YwTnbZ/TytjFjHbKrrZyWi5oXARuX6/StZDRp2wKTPQgb12K75Y
	BY5SMvUNIAddn1C4cyzsucXlQKmxjaI5IrXVIajQ3V4p9osp2+fUJDNiyeL1HPtowMSRQ9SqNSI
	3FsUxRab9L+RUXlB1PFCzzFtgcS+KWr2WzckGHn0s
X-Gm-Gg: Acq92OFjY5O+q+46eG79EyUwMX+CNRUL6c+TuJgrEJNdlzSrn5d4/rFMgwlruqs6N3t
	jkmcXNC4v9AySuU1RO1hlP7Kq+7APwPZqL0jbuK+KtmD+oXRzcPuWdmfDEwvnUsCkXiS0ZIMGer
	Qyrqc/LCyWdZlIEdkDgz6JOkMbaj6XGMnvxrM5q4ds3dy++Jig5xp5hVMTE0QT2YgML02Ilj4LX
	U3TTYw6HP9IMgLslVZ2HAdIH7nIhybeulE04qlk5AO6OjBDyLXhFqt85At33m+LyUrhAAFwFiis
	U/jsJ7+2iZDk7fgLrcDZfOsQ18V8LBsMkKliuZ38L86CdMLGGGpBOY//O4+S66F5hXvvwmkcd0v
	+Ma3NQ5mrfe22KUaQ
X-Received: by 2002:a05:6870:e2d4:b0:42c:2421:5777 with SMTP id
 586e51a60fabf-43a2d9d7a2dmr9088467fac.13.1779122106035; Mon, 18 May 2026
 09:35:06 -0700 (PDT)
Precedence: bulk
X-Mailing-List: syzbot@lists.linux.dev
List-Id: <syzbot.lists.linux.dev>
List-Subscribe: <mailto:syzbot+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:syzbot+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <7d949fbc-9781-4428-bfac-e51501b18bf7@mail.kernel.org>
In-Reply-To: <7d949fbc-9781-4428-bfac-e51501b18bf7@mail.kernel.org>
From: Aleksandr Nogikh <nogikh@google.com>
Date: Mon, 18 May 2026 18:34:54 +0200
X-Gm-Features: AVHnY4LIn-TrMVv5-XVCl3etjnKzVm1Qelcp98fIlPyEuvQTPDNt1DuUkdMaY-4
Message-ID: <CANp29Y7crNbnnyAfZsHetubWe48MD4oquwH7GWxDYaY0zMP9Mw@mail.gmail.com>
Subject: Re: [PATCH RFC] wifi: cfg80211: replace WARN_ON() with pr_err() in
 netns switch
To: syzbot <syzbot@kernel.org>
Cc: syzkaller-upstream-moderation@googlegroups.com, syzbot@lists.linux.dev
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Wed, May 13, 2026 at 11:51=E2=80=AFPM 'syzbot' via
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
> Fixes: 66e5c2672cd11b9310008099faf6a4ffb9dfb6d0 ("ieee802154: add netns s=
upport")
> Assisted-by: Gemini:gemini-3.1-pro-preview
> Reported-by: syzbot+bd5829ba3619f08e2341@syzkaller.appspotmail.com
> Link: https://syzkaller.appspot.com/bug?extid=3Dbd5829ba3619f08e2341
> Link: https://syzkaller.appspot.com/ai_job?id=3D46668339-436e-4563-9254-7=
3690dc813fe
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
> diff --git a/net/ieee802154/core.c b/net/ieee802154/core.c
> index 89b671b12..98c498e3e 100644
> --- a/net/ieee802154/core.c
> +++ b/net/ieee802154/core.c
> @@ -245,7 +245,8 @@ int cfg802154_switch_netns(struct cfg802154_registere=
d_device *rdev,
>                         wpan_dev->netdev->netns_immutable =3D false;
>                         err =3D dev_change_net_namespace(wpan_dev->netdev=
, net,
>                                                        "wpan%d");
> -                       WARN_ON(err);
> +                       if (err)
> +                               pr_err("failed to change netns: %d\n", er=
r);

Is it safe to just print error and continue here?
Though I guess WARN_ON is also expected to not abort execution unless
told so by the configuration.

Another moment (here and there) - do we want to include more details
into the error? E.g. about the device? How other code in ieee802154
handles this?

>                         wpan_dev->netdev->netns_immutable =3D true;
>                 }
>
> @@ -255,7 +256,8 @@ int cfg802154_switch_netns(struct cfg802154_registere=
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
> @@ -350,8 +352,10 @@ static void __net_exit cfg802154_pernet_exit(struct =
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
> index 6783e0672..ed5eac41f 100644
> --- a/net/wireless/core.c
> +++ b/net/wireless/core.c
> @@ -184,7 +184,8 @@ int cfg80211_switch_netns(struct cfg80211_registered_=
device *rdev,
>                         wdev->netdev->netns_immutable =3D false;
>                         err =3D dev_change_net_namespace(wdev->netdev, ne=
t,
>                                                         "wlan%d");
> -                       WARN_ON(err);
> +                       if (err)
> +                               pr_err("failed to change netns: %d\n", er=
r);
>                         wdev->netdev->netns_immutable =3D true;
>                 }
>
> @@ -204,7 +205,8 @@ int cfg80211_switch_netns(struct cfg80211_registered_=
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
> @@ -1809,8 +1811,10 @@ static void __net_exit cfg80211_pernet_exit(struct=
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
> See  for more information.
>
> --
> You received this message because you are subscribed to the Google Groups=
 "syzkaller-upstream-moderation" group.
> To unsubscribe from this group and stop receiving emails from it, send an=
 email to syzkaller-upstream-moderation+unsubscribe@googlegroups.com.
> To view this discussion visit https://groups.google.com/d/msgid/syzkaller=
-upstream-moderation/7d949fbc-9781-4428-bfac-e51501b18bf7%40mail.kernel.org=
.
