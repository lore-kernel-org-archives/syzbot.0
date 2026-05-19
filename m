Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BB1294A33FF
	for <syzbot@lists.linux.dev>; Tue, 19 May 2026 14:32:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=10.30.226.201
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779201149; cv=pass; b=bWhKp0SUXc5kTROSPSyq3cLxW/mU5SeFlU0g94ld7qBY3dwUJxBOWj2llhXcSsUDiCaYmEtPi6Zes23eCT5cC2mE92JdTEb8JfU4pDaoyustTbnI9wibU62CSQXo0ebwT0XIz7YBIiKHBfa4BIAy+VBCQOfhJv4pB1OIeI7poOo=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779201149; c=relaxed/simple;
	bh=amzsbuNqSonQsAWANajku0t6eVaR7o4RstosVHFSTkY=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=OwQIcIBUxNnWjfmVN9YcpvhYdOOpGgTrqdmA9e54CMJsMHs8c9pgHbc7o9eafaqfCh5KenTvo8c4ySX8nFoslbtFLvH4IpI3lBZ6wGM+FEDj4wn3QUO7eatjNOrM+qT6Iwn9gFuYUR/S4PlEYZQWiE6uKQ5xFffCZTkuKDF5tIQ=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=rOmABBDg; arc=pass smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="rOmABBDg"
Received: by smtp.kernel.org (Postfix)
	id 7A79CC2BCB3; Tue, 19 May 2026 14:32:29 +0000 (UTC)
Received: from mail-lf1-f47.google.com (mail-lf1-f47.google.com [209.85.167.47])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp.kernel.org (Postfix) with ESMTPS id 5BD05C2BCC6
	for <syzbot@kernel.org>; Tue, 19 May 2026 14:32:28 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 smtp.kernel.org 5BD05C2BCC6
Authentication-Results: smtp.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.kernel.org; spf=pass smtp.mailfrom=google.com
Received: by mail-lf1-f47.google.com with SMTP id 2adb3069b0e04-5a742b8b72eso4575448e87.1
        for <syzbot@kernel.org>; Tue, 19 May 2026 07:32:28 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1779201146; cv=none;
        d=google.com; s=arc-20240605;
        b=isw8jiRhe7sgCPKYP9NO6t3hsvnvurD6LlA9xfrpDTEDCnhalC73VkAkjrGX91o402
         hRbQsFSpDmiNpyucfp5p+tdJUd1odCGLNyfIVTdnnMw2MHVjzSntqXGixzrG1PrWuYBM
         UsL+RLmnN0j/OPZumvip9696n730qkoexz9nwY3Wo8RpcVG7KEUKzaQrtNAtleaxsXhb
         avu5c+ivi2UExafzFngoyFauB9xRz86PryGj3Sb4c06V/zCfcK5V9FLCOcF/ZEb7TndU
         4nZsjot18KvSDNyvo/doi7sNukenesXrvtdYE6x2KfDfVTHpAYggOeJDXHGi6SRjAnMT
         4pnA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=MDZ5VplGj+Spa8yP1p/ER24sTvZMNUi0cAi75iyQFxg=;
        fh=CLZWgVfOjpdO0yJ0/kvIoTk3c4vsoQgqamNYrO+GCzs=;
        b=BlGf3LC6l5aj58nqhAxpu9SgN5MPZeW9+9bL+FaoGG2fbhWKbJ99akTZIt3DYR71r4
         yO22+9VZcEf3a7Jki3uuaCrTkuUqPysKLq4fjJGKKH19fVaqun5ABmLHNDjrFqTA9xNJ
         pbE2UPosfKlngXb0bTHBKObjc9PokOHFhCXfGePUUp4ehL8cNS1xNZ4oiEtpHj5xToFc
         WSS0JpG+Eaqwqe226lH/rnYlaJHsPfwRtbkgMbxSp3GdtJVde9FtU4JI95vckN4OpOmZ
         KCsktL1al+L2UH8xmy6QRY9VQ0Y9D2K2ifYoHBZNDl8GTEMQf+S/h1fnsccyOkNg6aBv
         lykg==;
        darn=kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1779201146; x=1779805946; darn=kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=MDZ5VplGj+Spa8yP1p/ER24sTvZMNUi0cAi75iyQFxg=;
        b=rOmABBDgukiBAUf0mditeWQkSn6sB+ZeWlXOVYMvCjg0uHyY95N1N66ISxojHkbJ7O
         v9NnZNxQK6aODL6JML4v8psMXCDO1p51/LXmjNVcNLMMbtghklgTQ8ZubSu1/2GIpdwg
         Pd0V6TP26vPxcCLiyBDRucV3BNJWWHSJaQpuTne9gVFPqwCKm1r8BCrnG66olDHNYnlA
         5JN698Hdna0ZdxtjfTA/ICwySkLRgwp027pVFY3cFKuhIeX49Id6tyv6QwBWR00Lgg7Q
         97DRClVpiPfwYM1GhPcLBT7z2FB7w+PT20HsPly8L5ydDcW7WV0iz88ERlspn/9HkSF9
         gFkg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1779201146; x=1779805946;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=MDZ5VplGj+Spa8yP1p/ER24sTvZMNUi0cAi75iyQFxg=;
        b=Aug0GzwJ8lMQ2DWjt1vEpvTCxsZVpAD4Wa/l46RmcAN/7fg7kPzfCShygeMABw2tBZ
         SprBgiwLVFPSalV/wsYRyzJxJR7N3dmTv/cSOB/IvE5dV8AGIF7QINsaCAwZn2kF1Bky
         pbpGy4HxmDzhMsSyo9muMw1mXMnGikHp2AYhYxB6OvjBMbnSsXIwEPBAsjQqDTMJEAcl
         YuJ8ns9wB0ELRLUDg8H0mwLTxmu7/bTGHutqZuTxRV5+BFWF0eSWHR2L6CFJk2/87Hxg
         8728DRPZN7mj8WXyO6nN/ioO0dUVqxn9L+Y0xM2QPkAK3677LKr6RXhVfj8zkH3Dw2zC
         ZdDQ==
X-Gm-Message-State: AOJu0YwatQoiO6snUPEPQPGe++6hzA08BXqttJhPXKm8Sx8mRhnB7wki
	pBo0ccHafWjnzC3kneQkPPnneszCfuq8VD18/vZ3lEYEbqzzuTEIpL8jh5htCI7EHng+kVg5n6f
	pmrS4w0hI4feURMAU+DdiTpaPmlwjZupxetnevz6jUhD+0Ou1+oRl+5724pM=
X-Gm-Gg: Acq92OHq4XJLc6Hz+6tCk1qF+v9M8Wo4cPBzNVWeCZ9F5fr1cK2/A3QUuB8Tdf9NFRN
	FshDGMwxXZUapofAaSpIRzsX3w9HPxoocDUusIcy2brSS75AUaVmke15JpV5PigScXBBibDkLJ7
	Tcqt6JdqXiAsI2QsVnRtiSeV+NvkXkTKjIyi+PfcnA8TGL9MnxWbh4fG1ATN5988jUDLiv5676B
	Ex33nXQsAtSZPIWfg4GsKVYMATli8ITR8Y+f+NWiYKP9PiTstEuBNXHZgfh1sCDOPyxePrfwe5Y
	LwanghFClo7IbTN4kHIZUaiNm7zEnjOHaXB1TTe5PvT83whs8H6u7BmOKiTNHHnNs7k/Z5mbplD
	DZLSH
X-Received: by 2002:a05:6512:3a84:b0:5a8:fc25:3843 with SMTP id
 2adb3069b0e04-5aa0e744088mr5531323e87.39.1779201145851; Tue, 19 May 2026
 07:32:25 -0700 (PDT)
Precedence: bulk
X-Mailing-List: syzbot@lists.linux.dev
List-Id: <syzbot.lists.linux.dev>
List-Subscribe: <mailto:syzbot+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:syzbot+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <4e2d36a7-9417-4c50-9ec1-3e82c7a670f3@mail.kernel.org>
 <CANp29Y5hQ8KXKdqe0CYqSk=NvLwwRZ0GwXhqj5FEhYFOz5g7nQ@mail.gmail.com> <CANp29Y6v+-wW3SjwcGwc_b7OeLjRoHw_1dgdXc2EK-XKfp8+kw@mail.gmail.com>
In-Reply-To: <CANp29Y6v+-wW3SjwcGwc_b7OeLjRoHw_1dgdXc2EK-XKfp8+kw@mail.gmail.com>
From: Dmitry Vyukov <dvyukov@google.com>
Date: Tue, 19 May 2026 16:32:13 +0200
X-Gm-Features: AVHnY4LYG9c9PCMFqYtMJVWtMNE85lDelaOgNfL2VuVJLHtxa_w8ryUHQztRnLc
Message-ID: <CACT4Y+akjLnzms+Xf5Oe07Y48+2V3mojyUf=-8Ua5GGUnsG9jw@mail.gmail.com>
Subject: Re: [PATCH RFC v2] wifi: cfg80211: replace WARN_ON() with dev_err()
 in netns switch
To: Aleksandr Nogikh <nogikh@google.com>
Cc: syzbot <syzbot@kernel.org>, syzkaller-upstream-moderation@googlegroups.com, 
	syzbot@lists.linux.dev
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Tue, 19 May 2026 at 16:23, 'Aleksandr Nogikh' via
syzkaller-upstream-moderation
<syzkaller-upstream-moderation@googlegroups.com> wrote:
>
> On Tue, May 19, 2026 at 4:07=E2=80=AFPM Aleksandr Nogikh <nogikh@google.c=
om> wrote:
> >
> > Debugging went 100% astray because of an strace output in the repro run=
 results.
> >
> > #syz reject
>
> Please ignore.
> Dmitry correctly noted that this message is not related to this patch.
>
> >
> > On Tue, May 19, 2026 at 12:08=E2=80=AFAM 'syzbot' via
> > syzkaller-upstream-moderation
> > <syzkaller-upstream-moderation@googlegroups.com> wrote:
> > >
> > > The syzkaller reported a kernel panic in cfg802154_switch_netns() whe=
n
> > > device_rename() fails with -ENOMEM. The crash occurs because WARN_ON(=
)
> > > is used to handle the memory allocation failure, which escalates into=
 a
> > > kernel panic when panic_on_warn is enabled.
> > >
> > > Memory allocation failures are expected runtime events under memory
> > > pressure and should be handled gracefully. The WARN_ON() macro must n=
ot
> > > be used for conditions that can legitimately happen. Failing to renam=
e
> > > the device or change the network namespace is not a fatal system erro=
r.
> > >
> > > Replace the WARN_ON() calls with dev_err() in both
> > > cfg802154_switch_netns() and cfg80211_switch_netns(), as well as in
> > > their respective pernet exit handlers (cfg802154_pernet_exit() and
> > > cfg80211_pernet_exit()). This ensures that memory allocation failures
> > > under pressure are handled gracefully, logging the error for debuggin=
g
> > > purposes without bringing down the entire system.

Change the description in 2 ways:
1. Don't concentrate on the fact that syzkaller triggered it, this
detail is irrelevant.

2. Don't assume that panic_on_warn is set. It is usually not set on
production systems, and it won't be fatal system error. Say just that
WARN_ON is not a correct way to handle conditions that can happen.



> > > Fixes: 04600794958f1833f5571c6cde40f260ab557f55 ("cfg80211: support s=
ysfs namespaces")
> > > Assisted-by: Gemini:gemini-3.1-pro-preview Gemini:gemini-3-flash-prev=
iew
> > > Reported-by: syzbot+bd5829ba3619f08e2341@syzkaller.appspotmail.com
> > > Link: https://syzkaller.appspot.com/bug?extid=3Dbd5829ba3619f08e2341
> > > Link: https://syzkaller.appspot.com/ai_job?id=3Da1cfc84c-7c0f-4340-89=
1d-885fcee80cad
> > > To: <alex.aring@gmail.com>
> > > To: <davem@davemloft.net>
> > > To: <edumazet@google.com>
> > > To: <kuba@kernel.org>
> > > To: <linux-wpan@vger.kernel.org>
> > > To: <miquel.raynal@bootlin.com>
> > > To: <netdev@vger.kernel.org>
> > > To: <pabeni@redhat.com>
> > > To: <stefan@datenfreihafen.org>
> > > Cc: <horms@kernel.org>
> > > Cc: <johannes@sipsolutions.net>
> > > Cc: <linux-kernel@vger.kernel.org>
> > > Cc: <linux-wireless@vger.kernel.org>
> > >
> > > ---
> > > v2:
> > > - Replaced pr_err() with dev_err() to include device details in the e=
rror messages.
> > >
> > > v1:
> > > https://lore.kernel.org/all/7d949fbc-9781-4428-bfac-e51501b18bf7@mail=
.kernel.org/T/
> > > ---
> > > diff --git a/net/ieee802154/core.c b/net/ieee802154/core.c
> > > index 89b671b12..07082857c 100644
> > > --- a/net/ieee802154/core.c
> > > +++ b/net/ieee802154/core.c
> > > @@ -245,7 +245,9 @@ int cfg802154_switch_netns(struct cfg802154_regis=
tered_device *rdev,
> > >                         wpan_dev->netdev->netns_immutable =3D false;
> > >                         err =3D dev_change_net_namespace(wpan_dev->ne=
tdev, net,
> > >                                                        "wpan%d");
> > > -                       WARN_ON(err);
> > > +                       if (err)
> > > +                               dev_err(&rdev->wpan_phy.dev,
> > > +                                       "failed to change netns: %d\n=
", err);
> > >                         wpan_dev->netdev->netns_immutable =3D true;
> > >                 }
> > >
> > > @@ -255,7 +257,9 @@ int cfg802154_switch_netns(struct cfg802154_regis=
tered_device *rdev,
> > >         wpan_phy_net_set(&rdev->wpan_phy, net);
> > >
> > >         err =3D device_rename(&rdev->wpan_phy.dev, dev_name(&rdev->wp=
an_phy.dev));
> > > -       WARN_ON(err);
> > > +       if (err)
> > > +               dev_err(&rdev->wpan_phy.dev, "failed to rename device=
: %d\n",
> > > +                       err);
> > >
> > >         return 0;
> > >  }
> > > @@ -350,8 +354,11 @@ static void __net_exit cfg802154_pernet_exit(str=
uct net *net)
> > >
> > >         rtnl_lock();
> > >         list_for_each_entry(rdev, &cfg802154_rdev_list, list) {
> > > -               if (net_eq(wpan_phy_net(&rdev->wpan_phy), net))
> > > -                       WARN_ON(cfg802154_switch_netns(rdev, &init_ne=
t));
> > > +               if (net_eq(wpan_phy_net(&rdev->wpan_phy), net)) {
> > > +                       if (cfg802154_switch_netns(rdev, &init_net))
> > > +                               dev_err(&rdev->wpan_phy.dev,
> > > +                                       "failed to switch netns on ex=
it\n");
> > > +               }
> > >         }
> > >         rtnl_unlock();
> > >  }
> > > diff --git a/net/wireless/core.c b/net/wireless/core.c
> > > index 6783e0672..6badcec46 100644
> > > --- a/net/wireless/core.c
> > > +++ b/net/wireless/core.c
> > > @@ -184,7 +184,9 @@ int cfg80211_switch_netns(struct cfg80211_registe=
red_device *rdev,
> > >                         wdev->netdev->netns_immutable =3D false;
> > >                         err =3D dev_change_net_namespace(wdev->netdev=
, net,
> > >                                                         "wlan%d");
> > > -                       WARN_ON(err);
> > > +                       if (err)
> > > +                               dev_err(&rdev->wiphy.dev,
> > > +                                       "failed to change netns: %d\n=
", err);
> > >                         wdev->netdev->netns_immutable =3D true;
> > >                 }
> > >
> > > @@ -204,7 +206,8 @@ int cfg80211_switch_netns(struct cfg80211_registe=
red_device *rdev,
> > >         wiphy_net_set(&rdev->wiphy, net);
> > >
> > >         err =3D device_rename(&rdev->wiphy.dev, dev_name(&rdev->wiphy=
.dev));
> > > -       WARN_ON(err);
> > > +       if (err)
> > > +               dev_err(&rdev->wiphy.dev, "failed to rename device: %=
d\n", err);
> > >
> > >         nl80211_notify_wiphy(rdev, NL80211_CMD_NEW_WIPHY);
> > >
> > > @@ -1809,8 +1812,11 @@ static void __net_exit cfg80211_pernet_exit(st=
ruct net *net)
> > >
> > >         rtnl_lock();
> > >         for_each_rdev(rdev) {
> > > -               if (net_eq(wiphy_net(&rdev->wiphy), net))
> > > -                       WARN_ON(cfg80211_switch_netns(rdev, &init_net=
));
> > > +               if (net_eq(wiphy_net(&rdev->wiphy), net)) {
> > > +                       if (cfg80211_switch_netns(rdev, &init_net))
> > > +                               dev_err(&rdev->wiphy.dev,
> > > +                                       "failed to switch netns on ex=
it\n");
> > > +               }
> > >         }
> > >         rtnl_unlock();
> > >  }
> > >
> > >
> > > base-commit: 5d6919055dec134de3c40167a490f33c74c12581
> > > --
> > > This is an AI-generated patch subject to moderation.
> > > Reply with '#syz upstream' to send it to the mailing list.
> > > Reply with '#syz reject' to reject it.
> > >
> > > See  for more information.
> > >
> > > --
> > > You received this message because you are subscribed to the Google Gr=
oups "syzkaller-upstream-moderation" group.
> > > To unsubscribe from this group and stop receiving emails from it, sen=
d an email to syzkaller-upstream-moderation+unsubscribe@googlegroups.com.
> > > To view this discussion visit https://groups.google.com/d/msgid/syzka=
ller-upstream-moderation/4e2d36a7-9417-4c50-9ec1-3e82c7a670f3%40mail.kernel=
.org.
>
> --
> You received this message because you are subscribed to the Google Groups=
 "syzkaller-upstream-moderation" group.
> To unsubscribe from this group and stop receiving emails from it, send an=
 email to syzkaller-upstream-moderation+unsubscribe@googlegroups.com.
> To view this discussion visit https://groups.google.com/d/msgid/syzkaller=
-upstream-moderation/CANp29Y6v%2B-wW3SjwcGwc_b7OeLjRoHw_1dgdXc2EK-XKfp8%2Bk=
w%40mail.gmail.com.
