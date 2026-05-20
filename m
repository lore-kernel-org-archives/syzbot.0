Received: from mail-dl1-f45.google.com (mail-dl1-f45.google.com [74.125.82.45])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E3D212C3251
	for <syzbot@lists.linux.dev>; Wed, 20 May 2026 13:50:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=74.125.82.45
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779285020; cv=pass; b=bUX+QDJv0G/EiEQDr9RHHL7VUtfLKpR/YKWMn1Ja79n7GKngBU/D8ARaiunnY2ogoh4jGFH4HWS2IOced8YDk/gNj4SRc1gxEEXqtosBVbQNY1JhDPUqHdXPeMuprMDY2vxL10AeerNYwSVkd+pcJkF1qsKtjSKshn5WSlhw/y4=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779285020; c=relaxed/simple;
	bh=GOPalHIJ2v3kg8fJrBWOp2fWyxxXEl1WRvHWI2CmTfg=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=iEU6HHnKnMs8cSpH480mf/8015yMAZuRnWq8kvGzMs1J3n24O3km/O3blgTNEWpAqGJ3iRv+d71Qlsk6J5xiUK3qkY1kmw4IYHl3OEK1nDSB8PzYPFUGBVsPA67p1qZWf4T29j3Rr3K8kH+hy29UT/l/tC7pYD4l8EdOkiOOXzw=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=Fdn6hcxr; arc=pass smtp.client-ip=74.125.82.45
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="Fdn6hcxr"
Received: by mail-dl1-f45.google.com with SMTP id a92af1059eb24-1309f4ee97fso5467841c88.1
        for <syzbot@lists.linux.dev>; Wed, 20 May 2026 06:50:18 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1779285018; cv=none;
        d=google.com; s=arc-20240605;
        b=FHEWQOAzAkhnKc61CSSN7hOc1o++PtXOHAhpRiRbHUg9pLcF8fepfjJi4v9K3Cn43K
         xDgzYVYdxiOLlxlrDX8vnfIiZjm8AECwbGcamMOJ6XtPsVrZLzGAJTTCafdHEbZKSt8D
         h6le6QfH+O/+KvWgfgJvnHY4bIO9NJMM+1pd/Qtu64Xh4Y5OQrchTaIwQ8C+DQZOIRB8
         4U2zcStekDOYi74JAdcFI3OxT9ol1q/yyFHSs8xeF8MsHsi3WT1C7FGCMSKZ4WJeUX3f
         TeRQO84S7vTs8L+ZFEgTPgXS6W+sTE6OglMiTVeYO8DqozvDP6r1YUzCj9ovZAk6skvi
         JeXg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:dkim-signature;
        bh=Lxa/kc3ihht8eKSmSm4sC4+n5s5mY1kWZ0ImwtL3AS0=;
        fh=naDHEm+wNRCjxaxjpoX+H9ePHloLVa/bRHlRyaaX4LA=;
        b=j+XlGgjoi6GJTM0JwyWtDZfaBN/qHASQXo9HLmNvskg5O/WIw9HNMZOrqeamKvMQRO
         ECg5HMgrHqBXBzStgDZyDM8wn6Wm4PoBgmfW4bTSjsW0WebcZFB7YKXCNo4OeHLJt/Gk
         ocj7fZOHcTrCbPq8iKx3bMlYzC28GmO/TQPax3g2fKo7V0OjH3Clf1ge/T1B/YU/yuXM
         algLg4r5dBzId6rvXT1G//ZWB0vxMioUg0Kqf5CI2PaJxvZxml6OCdmVSr7QUnE0xfEC
         g6gRmXbI+xQxogaM7Iyltd52cEJf/yfe5VRLIYRNRPpMvqOgwx/FiGdzwamf9o/2U0/T
         DzzQ==;
        darn=lists.linux.dev
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1779285018; x=1779889818; darn=lists.linux.dev;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=Lxa/kc3ihht8eKSmSm4sC4+n5s5mY1kWZ0ImwtL3AS0=;
        b=Fdn6hcxr4FR6lfMrtxEu28R5N0Ddm/ZnN/DUqOtEGu1aYwqVG9pF9Oja/gYVP15eIE
         T/pwbf25ZuH38Je5KSKIJEyk4fZGfM6OFPlT3+EtwmYYyE2E1u15Dap4DQFqqo2eE9ch
         7f7mhQnsIvVSNPkRbj9hRQ6rHWG15dlpslBSDSbBE/SRaa0UYTFkpC8k+S36t3GyfzXN
         6W7W/mrJT9/BP+TDP1lOCPH4JccLbWxVmMkasvIvdGuEkOD3787SQ+GV1WgWbeIIlvBw
         jz+CyX0cFGoy0JsOMfJ6PyocHy2S9cyIVv1Z+bkXPla1n3bd+W/DoSry0KkIeGydWx9z
         Ww5g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1779285018; x=1779889818;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Lxa/kc3ihht8eKSmSm4sC4+n5s5mY1kWZ0ImwtL3AS0=;
        b=aIIvliYm+KbuOeyqIOFq9HJ+s26Blnej5VKg/1968trx/icyjSloUF5Rr9gC4f4pf0
         Bj9S2zia1++f+tXhL5RD2vaFrABiXACbyrJM5P1fsMH4WBD8Vsljy3vwTNCx0lJt5mLU
         YTeZGLt2m8CVeGZtTwxeg7menKwKpdfPrmyG0IFaQVISmTiWUWE4nvyuCViMhsjH+AJK
         xd0Gyynd/jI7wKZBFZeAeVz3F3eC8GBEvO20SyCK9j0l67U6uLSXrKfeNg8y8b8D8zfW
         HWs3rzToU+ETpoT/+jmuz8V3h0o/MjNXiU0PqwyRt8/0e9HmtgR9swub5PL7V8ydBLMX
         CrfA==
X-Forwarded-Encrypted: i=1; AFNElJ/AHlmHXhaMJvc5x5/od6CTtI59LbHJD6hLqw7k/iuEYYSEwvXKXzapAM0P8KAGkON7d+pUN9M=@lists.linux.dev
X-Gm-Message-State: AOJu0YwP/X251FJ2XS9HOsvN9RogtAI8S0Ih9e8+4Pll1moDWPmF3Nq0
	HeSpA3EqFvFNXwigqyg5kN49FYI4EVzUImOgVccQ/LuuRkshtTEvUhqLACMsuu70kJoa4npmzLR
	F7a2P+1XIeb4qQkt8UKcdDOF3QAcZNsd6GiiuJZuK
X-Gm-Gg: Acq92OGAsXTysDOdH2ymYTlU7W4xcvBPsO1rEJwAoIbBxZfXTDW160q2PQ6eb4fyGvP
	BKf/BH2gXFAmjUhCAINhoXWylPYlZ/5tRbjL6SihZKcYD8gN4r84N1+YPbfVvBNL6xbC433qEPp
	F3o8bsgNusfKczUFHKzJSHnAnPUodWwy3uQRKtXkjkPDOk2ezm2J+kDBneKGvFA+njh9ezoRlaE
	fpVGIoi5j4D+JUz1xpbcyImXS/7v+uU59lVhPD+auRwepWNTlepQK+ZR9Q04nBvl2XGSyvStc5w
	MQkOQeelSdxTQH/KBMXODaHroa2OXytOFgb6Dhzyzrjn6DyM0qNkwZ7k5w==
X-Received: by 2002:a05:7022:f97:b0:12a:6fb7:87e7 with SMTP id
 a92af1059eb24-13503cf183amr10267575c88.0.1779285017530; Wed, 20 May 2026
 06:50:17 -0700 (PDT)
Precedence: bulk
X-Mailing-List: syzbot@lists.linux.dev
List-Id: <syzbot.lists.linux.dev>
List-Subscribe: <mailto:syzbot+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:syzbot+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <ba6abcc9-c09e-499a-92cf-3f59d45ef58a@mail.kernel.org>
In-Reply-To: <ba6abcc9-c09e-499a-92cf-3f59d45ef58a@mail.kernel.org>
From: Marco Elver <elver@google.com>
Date: Wed, 20 May 2026 15:49:40 +0200
X-Gm-Features: AVHnY4Ic2c9aj4V4C0TiWqIRKjYo4d9E-kzzAcJlCigFYQt8n3MwKo6SnP2SunM
Message-ID: <CANpmjNNF=grZNpVq=SRyg2HVJuDegzWHQrHW6Rji9tJ3gc97ZQ@mail.gmail.com>
Subject: Re: [PATCH RFC v3] wifi: cfg80211: replace WARN_ON() with pr_err() in
 netns switch
To: syzbot <syzbot@kernel.org>
Cc: syzkaller-upstream-moderation@googlegroups.com, syzbot@lists.linux.dev, 
	Aleksandr Nogikh <nogikh@google.com>, Dmitry Vyukov <dvyukov@google.com>
Content-Type: text/plain; charset="UTF-8"

#syz reject

On Tue, 19 May 2026 at 20:37, 'syzbot' via
syzkaller-upstream-moderation
<syzkaller-upstream-moderation@googlegroups.com> wrote:
>
> The syzkaller reported a kernel panic in cfg802154_switch_netns() when

"The syzkaller" is incorrect grammar. It's "syzkaller reported ...".

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
> Reported-by: syzbot <syzbot+bd5829ba3619f08e2341@syzkaller.appspotmail.com>
> Link: https://syzkaller.appspot.com/bug?extid=bd5829ba3619f08e2341
> Link: https://syzkaller.appspot.com/ai_job?id=c84689f4-6a93-47bf-80ca-3bc6137dce52
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
> - Introduced revert_err variable to prevent overwriting the original error code during netns cleanup.
>
> v2:
> - Replaced pr_err() with dev_err() to include device details in the error messages.
> https://lore.kernel.org/all/4e2d36a7-9417-4c50-9ec1-3e82c7a670f3@mail.kernel.org/T/
>
> v1:
> https://lore.kernel.org/all/7d949fbc-9781-4428-bfac-e51501b18bf7@mail.kernel.org/T/
> ---
> diff --git a/net/ieee802154/core.c b/net/ieee802154/core.c
> index 89b671b12..dcf46b848 100644
> --- a/net/ieee802154/core.c
> +++ b/net/ieee802154/core.c
> @@ -234,6 +234,8 @@ int cfg802154_switch_netns(struct cfg802154_registered_device *rdev,
>         }
>
>         if (err) {
> +               int revert_err;
> +
>                 /* failed -- clean up to old netns */
>                 net = wpan_phy_net(&rdev->wpan_phy);
>
> @@ -243,9 +245,11 @@ int cfg802154_switch_netns(struct cfg802154_registered_device *rdev,
>                         if (!wpan_dev->netdev)
>                                 continue;
>                         wpan_dev->netdev->netns_immutable = false;
> -                       err = dev_change_net_namespace(wpan_dev->netdev, net,
> -                                                      "wpan%d");
> -                       WARN_ON(err);
> +                       revert_err = dev_change_net_namespace(wpan_dev->netdev,
> +                                                             net, "wpan%d");
> +                       if (revert_err)
> +                               pr_err("failed to revert netns: %d\n",
> +                                      revert_err);
>                         wpan_dev->netdev->netns_immutable = true;
>                 }
>
> @@ -255,7 +259,8 @@ int cfg802154_switch_netns(struct cfg802154_registered_device *rdev,
>         wpan_phy_net_set(&rdev->wpan_phy, net);
>
>         err = device_rename(&rdev->wpan_phy.dev, dev_name(&rdev->wpan_phy.dev));
> -       WARN_ON(err);
> +       if (err)
> +               pr_err("failed to rename device: %d\n", err);

This will silently return 0 - shouldn't the caller be notified of the failure?

>         return 0;
>  }
> @@ -350,8 +355,10 @@ static void __net_exit cfg802154_pernet_exit(struct net *net)
>
>         rtnl_lock();
>         list_for_each_entry(rdev, &cfg802154_rdev_list, list) {
> -               if (net_eq(wpan_phy_net(&rdev->wpan_phy), net))
> -                       WARN_ON(cfg802154_switch_netns(rdev, &init_net));
> +               if (net_eq(wpan_phy_net(&rdev->wpan_phy), net)) {
> +                       if (cfg802154_switch_netns(rdev, &init_net))
> +                               pr_err("failed to switch netns on exit\n");
> +               }
>         }
>         rtnl_unlock();
>  }
> diff --git a/net/wireless/core.c b/net/wireless/core.c
> index 6783e0672..674802d1c 100644
> --- a/net/wireless/core.c
> +++ b/net/wireless/core.c
> @@ -173,6 +173,8 @@ int cfg80211_switch_netns(struct cfg80211_registered_device *rdev,
>         }
>
>         if (err) {
> +               int revert_err;
> +
>                 /* failed -- clean up to old netns */
>                 net = wiphy_net(&rdev->wiphy);
>
> @@ -182,9 +184,11 @@ int cfg80211_switch_netns(struct cfg80211_registered_device *rdev,
>                         if (!wdev->netdev)
>                                 continue;
>                         wdev->netdev->netns_immutable = false;
> -                       err = dev_change_net_namespace(wdev->netdev, net,
> -                                                       "wlan%d");
> -                       WARN_ON(err);
> +                       revert_err = dev_change_net_namespace(wdev->netdev, net,
> +                                                             "wlan%d");
> +                       if (revert_err)
> +                               pr_err("failed to revert netns: %d\n",
> +                                      revert_err);

In general this design is just suboptimal to begin with. The original
author used WARN_ON, because it was assumed "this should never
happen". Clearly, that assumption is wrong, but the fix is not to
paper over the WARN_ON with pr_err.

There's a real failure here; and that should either be handled by the
caller, or be made impossible by design. I currently do not see how
the caller can get us out of this bad state -- where we have e.g. half
of netdevs in the previous and the other half in the new namespace.
That just doesn't work.

If you look at the definition of __dev_change_net_namespace itself, there's a:

```
/* Fixup kobjects */
dev_set_uevent_suppress(&dev->dev, 1);
err = device_rename(&dev->dev, dev->name);
dev_set_uevent_suppress(&dev->dev, 0);
WARN_ON(err);
```

So whatever we do in the callers of dev_change_net_namespace() is
completely pointless, because we're still going to get a WARN_ON.

This needs a different design that avoids the problem to begin with.
As long as we allocate memory, this is not going to be easy. One idea
is to keep the old name around, and only free once all operations
completed. But unclear if there's a clean and surgical fix to do this
without a broader refactor.

This comment holds for all other callsites as well.

Please double-check this explanation.

>                         wdev->netdev->netns_immutable = true;
>                 }
>
> @@ -204,7 +208,8 @@ int cfg80211_switch_netns(struct cfg80211_registered_device *rdev,
>         wiphy_net_set(&rdev->wiphy, net);
>
>         err = device_rename(&rdev->wiphy.dev, dev_name(&rdev->wiphy.dev));
> -       WARN_ON(err);
> +       if (err)
> +               pr_err("failed to rename device: %d\n", err);
>
>         nl80211_notify_wiphy(rdev, NL80211_CMD_NEW_WIPHY);
>
> @@ -1809,8 +1814,10 @@ static void __net_exit cfg80211_pernet_exit(struct net *net)
>
>         rtnl_lock();
>         for_each_rdev(rdev) {
> -               if (net_eq(wiphy_net(&rdev->wiphy), net))
> -                       WARN_ON(cfg80211_switch_netns(rdev, &init_net));
> +               if (net_eq(wiphy_net(&rdev->wiphy), net)) {
> +                       if (cfg80211_switch_netns(rdev, &init_net))
> +                               pr_err("failed to switch netns on exit\n");
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
> See https://github.com/google/syzkaller/blob/master/docs/syzbot_ai_patches.md for more information.
>
> --
> You received this message because you are subscribed to the Google Groups "syzkaller-upstream-moderation" group.
> To unsubscribe from this group and stop receiving emails from it, send an email to syzkaller-upstream-moderation+unsubscribe@googlegroups.com.
> To view this discussion visit https://groups.google.com/d/msgid/syzkaller-upstream-moderation/ba6abcc9-c09e-499a-92cf-3f59d45ef58a%40mail.kernel.org.
