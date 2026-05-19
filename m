Received: from mail-lj1-f177.google.com (mail-lj1-f177.google.com [209.85.208.177])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 464413ED3D7
	for <syzbot@lists.linux.dev>; Tue, 19 May 2026 14:20:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.208.177
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779200430; cv=pass; b=cGTqno076lNogOeX6aDneET3rAyJFtW2hSADSJAy5dAMk+4vEZb8t4Qvl0XFWEMJtLl1Zbdd2BFV7Jn0UjAF47Ljcpo0hbdmhBrlyq1ZeB2P9VC1ybA2TXFDTXlMzVmYZKEYALdslZm1GrEtXWFgpbZ4R0i024roEr3UuQ7RAvk=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779200430; c=relaxed/simple;
	bh=ucuIplcHOBuniV1EccocxxnYa4y0W8bcBcHznEzllfk=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=a9CJtrU1epxGPGac1Xk3u7PNNvVxNoM7+X18MaSzkMtkEcVRHMO5p5BbftIraEwCcXnlZfqOz7I4TShSQipovJnBDaSQrdnBzg7R5vr7sOobeNRFkuFCvXWxDhnz8sTnJq6nH+QrxoEBMmpJ65QceV/xMGg/Fv/xx1dtUS8INmQ=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=GzdkKWaG; arc=pass smtp.client-ip=209.85.208.177
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="GzdkKWaG"
Received: by mail-lj1-f177.google.com with SMTP id 38308e7fff4ca-3942e9977a5so47817081fa.1
        for <syzbot@lists.linux.dev>; Tue, 19 May 2026 07:20:27 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1779200426; cv=none;
        d=google.com; s=arc-20240605;
        b=dg0/mmGbQmCNBvsuMDmaauKkeDuyAKAVOlm23Msjf7Kscnu8lTHQCzCORyJOaeZvXr
         EHCNwTZa7ibcyfoE0fB7UHA6zthyNBF7ksKV+I6IITA/+z7bQg7M4TOH0xtckxyCkndF
         t+fe8S7GA5gqSsztycUnw+52vBWI6T6m5CE+qm0pBK6MMLn3vJ2Jet+A8m+tHOl1IPHl
         5YNVLxWUKNSnUxHgzZf2F8kkK3x4xRRjSywfS/4VZt0a6XSoEF3Ynvx37AbniI2HAv9N
         B7mNUHkygT9heY/d+fcfiWrZWwBcmA16T16Ozn+vbIrx8CXAKJ0biqUtl1iHtv/8qyf6
         8b8Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:dkim-signature;
        bh=t/NpE98bQ5dk+xefyvnTe99H9UtKrYR9SOHo4VQlGq8=;
        fh=qgqXlltDHtmmVqqY/8bZr7lAgBZRHaWH8+3+apuMxz0=;
        b=gYzMT3bjn7B9I8ttLenLFtCuYWh6JlPzTlRw/TKFxPbeOMFhkvifqDwdPE58ehh/gf
         TY65PVRHw87sU7ziMWUbkSxL0Kcoq4x05HqFqiKeZhevgMErmW2sMeS6BImyNMSPpMUE
         ubs+d87mhKBLwznktFFWJGKZhIc7hGeaiZS/ZV5tYrt1CL+ZfbU/xIw9oII8UVH2Y2ff
         m2Qce22MuWaiJAfPAj/u4BgTCUm7Kjw4GEl85UpeFIT+PMrfhD2vLAKnjqGoZ3/a9d/d
         ZUe1YrhHakrtguK+tXVtngFFn5JSFOTT0fSKnaOAo/Ih2LcPe0/omkOUTLxjFyVfVyNK
         Qh/g==;
        darn=lists.linux.dev
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1779200426; x=1779805226; darn=lists.linux.dev;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=t/NpE98bQ5dk+xefyvnTe99H9UtKrYR9SOHo4VQlGq8=;
        b=GzdkKWaG9NlR85xO68Gk5wC+bV630QHK9Uc8lJXQgekKz9gfrwn7CK/NQ/twmeBc1j
         Nw9B9xZ4fTFjmyV9oe+xwt5/hKp2pVy77Q5KbHjS5pBfXBW93yJFDLSiS05g6ZdGVymm
         ZH3I45LiP+mVuwMTrO0zMWfPy+uQmIKL2gW/d1bZQ7dVFJgckUwSD93Re5Txv1+vtu9r
         2fBzgTMsDXmxwXBU7foxXb4a6MB+XdXeiECfwWzhbY/+R5slAyTDIXoqJFRzINfdLlog
         0OCQc1rPXjwJPK9NJGx9/HYQ2HQL9DkgmkDPCBKMVPozK7lspKlRhpciWDNuEgZ8CyaZ
         nLCQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1779200426; x=1779805226;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=t/NpE98bQ5dk+xefyvnTe99H9UtKrYR9SOHo4VQlGq8=;
        b=BnQLwaqoz7PtOoE/fbmHrNoOSKC9NuDUyBsM2BHLd7/rXYQJ4PwRmOfl/i4rPWu4Jw
         cTT3OwUMB8XV3KbYTIpuuiM3pBM5o4120WjbuleepbArc1W9nEJtng+s4QEytLHjNE69
         bJnDpJzjgVIozXPcwTrLEbz5mPhV1vT4fwA4OjrtK8rbRJtvzjuFOi1WCH6pjLZZI7dl
         yCbRaAFDoRBw7ojwu4VnS97XwD2bTopWVWDEo+s00b2Aqu5dpCC4QtVFCSSc/tlzQnIg
         k9Xfw+/WsQ8lSuYSHM11X/4QA88t//DhYbp69kwrqWPC5zruvG6Ev3PIab7c7gjD1db7
         7IKw==
X-Forwarded-Encrypted: i=1; AFNElJ+7ip8XSpSjqeiQN/cZSO1JjGZRsPfaHEalp2GVKIEFfXZ5bFeRrCw194OXevs+8m6DNZOqNtY=@lists.linux.dev
X-Gm-Message-State: AOJu0Yw0/syNLqg2KVzCWXmlxZQ7dd3lZriGb0TOXAYJ9v+9p2ssdoQw
	mHm0Yc7u5Qz2mBkwqVd+0gCPFXTBY25VDT2L/P7NLvskqKfwZRJLOb2FJtFVnZFMjbns5NRMbJZ
	DNAbxklyDDVK2fz8m11PeMpEgSrLCNtgIkulWX5YC
X-Gm-Gg: Acq92OH+5grEPg7nXvnL5hwNHoNoNqqLMd6cX9yNlIOMCBc6KbToT/uM48KkA7u7kOr
	y/BpsWlivLGoGGmiFf0Rw6ZMbXDyIlAC8D4oBvi/ctgUd3Z4zsKJA0WYfqo9xbDvAlSmzPEPUI1
	oOnI/yZXhvTLSeMLfIwzndApEwz+qEztDSUgUq6tyNR3Po/LWwxEuS5Aj5GYQbLjllpp47XdJha
	ann2MQLK0+RiWPb2047msO9FAlseQHJ1jeHi4TfBfgZlFl2ZtoUCyPcNyJbGyyER5tdsqxW7Q5l
	ODXGYRv43LuyO5b/YX5dlhebgz3UUly0WfSBjaaoWChRVKf/9DE0JK8aaoaS048LIgoabWhwN6A
	qTcA1
X-Received: by 2002:a2e:9b86:0:b0:393:d582:b62a with SMTP id
 38308e7fff4ca-3945b492590mr60569081fa.5.1779200425759; Tue, 19 May 2026
 07:20:25 -0700 (PDT)
Precedence: bulk
X-Mailing-List: syzbot@lists.linux.dev
List-Id: <syzbot.lists.linux.dev>
List-Subscribe: <mailto:syzbot+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:syzbot+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <4e2d36a7-9417-4c50-9ec1-3e82c7a670f3@mail.kernel.org>
In-Reply-To: <4e2d36a7-9417-4c50-9ec1-3e82c7a670f3@mail.kernel.org>
From: Dmitry Vyukov <dvyukov@google.com>
Date: Tue, 19 May 2026 16:20:14 +0200
X-Gm-Features: AVHnY4J4OEBlAjDito6_Gnuo9u6R6qpMMSXE3xcgZDCcX6L7hRBYJt5W6_Pld5I
Message-ID: <CACT4Y+YZMLXzb0+qB7TuJh7XAiGY_FEz9oWnBwfsSB8s00=QRQ@mail.gmail.com>
Subject: Re: [PATCH RFC v2] wifi: cfg80211: replace WARN_ON() with dev_err()
 in netns switch
To: syzbot <syzbot@kernel.org>
Cc: syzkaller-upstream-moderation@googlegroups.com, syzbot@lists.linux.dev
Content-Type: text/plain; charset="UTF-8"

On Tue, 19 May 2026 at 00:07, 'syzbot' via
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
> Replace the WARN_ON() calls with dev_err() in both
> cfg802154_switch_netns() and cfg80211_switch_netns(), as well as in
> their respective pernet exit handlers (cfg802154_pernet_exit() and
> cfg80211_pernet_exit()). This ensures that memory allocation failures
> under pressure are handled gracefully, logging the error for debugging
> purposes without bringing down the entire system.

Change the description in 2 ways:
1. Don't concentrate on the fact that syzkaller triggered it, this
detail is irrelevant.
2. Don't assume that panic_on_warn is set. It is usually not set on
production systems, and it won't be fatal system error. Say just that
WARN_ON is not a correct way to handle conditions that can happen.


> Fixes: 04600794958f1833f5571c6cde40f260ab557f55 ("cfg80211: support sysfs namespaces")
> Assisted-by: Gemini:gemini-3.1-pro-preview Gemini:gemini-3-flash-preview
> Reported-by: syzbot+bd5829ba3619f08e2341@syzkaller.appspotmail.com
> Link: https://syzkaller.appspot.com/bug?extid=bd5829ba3619f08e2341
> Link: https://syzkaller.appspot.com/ai_job?id=a1cfc84c-7c0f-4340-891d-885fcee80cad
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
> v2:
> - Replaced pr_err() with dev_err() to include device details in the error messages.
>
> v1:
> https://lore.kernel.org/all/7d949fbc-9781-4428-bfac-e51501b18bf7@mail.kernel.org/T/
> ---
> diff --git a/net/ieee802154/core.c b/net/ieee802154/core.c
> index 89b671b12..07082857c 100644
> --- a/net/ieee802154/core.c
> +++ b/net/ieee802154/core.c
> @@ -245,7 +245,9 @@ int cfg802154_switch_netns(struct cfg802154_registered_device *rdev,
>                         wpan_dev->netdev->netns_immutable = false;
>                         err = dev_change_net_namespace(wpan_dev->netdev, net,
>                                                        "wpan%d");
> -                       WARN_ON(err);
> +                       if (err)
> +                               dev_err(&rdev->wpan_phy.dev,
> +                                       "failed to change netns: %d\n", err);
>                         wpan_dev->netdev->netns_immutable = true;
>                 }
>
> @@ -255,7 +257,9 @@ int cfg802154_switch_netns(struct cfg802154_registered_device *rdev,
>         wpan_phy_net_set(&rdev->wpan_phy, net);
>
>         err = device_rename(&rdev->wpan_phy.dev, dev_name(&rdev->wpan_phy.dev));
> -       WARN_ON(err);
> +       if (err)
> +               dev_err(&rdev->wpan_phy.dev, "failed to rename device: %d\n",
> +                       err);
>
>         return 0;
>  }
> @@ -350,8 +354,11 @@ static void __net_exit cfg802154_pernet_exit(struct net *net)
>
>         rtnl_lock();
>         list_for_each_entry(rdev, &cfg802154_rdev_list, list) {
> -               if (net_eq(wpan_phy_net(&rdev->wpan_phy), net))
> -                       WARN_ON(cfg802154_switch_netns(rdev, &init_net));
> +               if (net_eq(wpan_phy_net(&rdev->wpan_phy), net)) {
> +                       if (cfg802154_switch_netns(rdev, &init_net))
> +                               dev_err(&rdev->wpan_phy.dev,
> +                                       "failed to switch netns on exit\n");
> +               }
>         }
>         rtnl_unlock();
>  }
> diff --git a/net/wireless/core.c b/net/wireless/core.c
> index 6783e0672..6badcec46 100644
> --- a/net/wireless/core.c
> +++ b/net/wireless/core.c
> @@ -184,7 +184,9 @@ int cfg80211_switch_netns(struct cfg80211_registered_device *rdev,
>                         wdev->netdev->netns_immutable = false;
>                         err = dev_change_net_namespace(wdev->netdev, net,
>                                                         "wlan%d");
> -                       WARN_ON(err);
> +                       if (err)
> +                               dev_err(&rdev->wiphy.dev,
> +                                       "failed to change netns: %d\n", err);
>                         wdev->netdev->netns_immutable = true;
>                 }
>
> @@ -204,7 +206,8 @@ int cfg80211_switch_netns(struct cfg80211_registered_device *rdev,
>         wiphy_net_set(&rdev->wiphy, net);
>
>         err = device_rename(&rdev->wiphy.dev, dev_name(&rdev->wiphy.dev));
> -       WARN_ON(err);
> +       if (err)
> +               dev_err(&rdev->wiphy.dev, "failed to rename device: %d\n", err);
>
>         nl80211_notify_wiphy(rdev, NL80211_CMD_NEW_WIPHY);
>
> @@ -1809,8 +1812,11 @@ static void __net_exit cfg80211_pernet_exit(struct net *net)
>
>         rtnl_lock();
>         for_each_rdev(rdev) {
> -               if (net_eq(wiphy_net(&rdev->wiphy), net))
> -                       WARN_ON(cfg80211_switch_netns(rdev, &init_net));
> +               if (net_eq(wiphy_net(&rdev->wiphy), net)) {
> +                       if (cfg80211_switch_netns(rdev, &init_net))
> +                               dev_err(&rdev->wiphy.dev,
> +                                       "failed to switch netns on exit\n");
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
> You received this message because you are subscribed to the Google Groups "syzkaller-upstream-moderation" group.
> To unsubscribe from this group and stop receiving emails from it, send an email to syzkaller-upstream-moderation+unsubscribe@googlegroups.com.
> To view this discussion visit https://groups.google.com/d/msgid/syzkaller-upstream-moderation/4e2d36a7-9417-4c50-9ec1-3e82c7a670f3%40mail.kernel.org.
