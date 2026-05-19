Received: from mail-oa1-f49.google.com (mail-oa1-f49.google.com [209.85.160.49])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F0F0740961E
	for <syzbot@lists.linux.dev>; Tue, 19 May 2026 14:23:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.160.49
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779200586; cv=pass; b=m679GT+HD9x2tNT4g8btiIONmM37q1MG2/xB3QGy5s++PCLtDHMhmJzYuqZJAe358lh8cszvmlXc5//zLtgKWyNDOW84x9rh7fnegiLw+Exrsv1lBIILtofKYH8EBKvkPm6czCrN0aghCTLTRiMNJfv8l/d8WQrAdbawx9tcA9o=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779200586; c=relaxed/simple;
	bh=9MMBQZIwc6xINwSGauUlfufLXcubIbyR98OxdTMIMs0=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=Z3TSkNBFgoaiSJQ8kgdayOmwasPsY1KsJ96tedax2jNfBCbze/77xcSpCX56NGbP1U+emCWrSQczEyJz1y8fH2F3xiPx/wpOS6sPhGeiBsAhQFWcXK/iCCcJ671PF7THwYUg9+dwKmebTgltZoEn658+0oubGs3xM+JnzqOnSqU=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=ril6wB6I; arc=pass smtp.client-ip=209.85.160.49
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="ril6wB6I"
Received: by mail-oa1-f49.google.com with SMTP id 586e51a60fabf-43aaeb6c96bso948337fac.3
        for <syzbot@lists.linux.dev>; Tue, 19 May 2026 07:23:04 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1779200584; cv=none;
        d=google.com; s=arc-20240605;
        b=QVZ2BWsjjFR5f/XLZcjTpDfkUisen7jFP26hET9/ZIm4W+iKqK9v2sqVG5jLMp7V4D
         UmrKzdn8G9rZVSt6Ts2NRprRYJ0/tHyO6JkGMD9UmdiK9PkrjxFMuWF40tZZmv+mx54O
         NbTs4betfZde1H6kdV1MctKpOAwR2zC6j9APvqqKXm16745D+nWLbQhGD0xF0F5UinQh
         p57JVG9ydrmQXx39tHI+thl99nUQhJNMpdjKncFvX8iYRxI8ITkp8djDhv5Tnp/qHDaf
         M7aYCNjzMqq8AxtVKKg/D4pVUCorJC0/nRjqElxWfniEqePWn8BkqbRU9WOQXQnbZOrU
         B4SQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=U85B73on+pS5wOF0o8AWpMg1gEkWrxdiM7ougEA6mmw=;
        fh=6UB8iegSZEzFOkzyxGQlTkwkHhaI9Qd0yCjBHP/BadM=;
        b=dnUKSXFNjFFNltPiTX/qT+FxhM/NqCGeka81MJZ7zi3RBYOKkScBORv5s/Mx8Nmhxu
         cUHrvcLchWPcXT8t4LVZKUhHWN8yhBlvqRmNnLrez9unCnrr3vXSdUseyhTAF+KYzwbk
         f4VDwtBDQAXa+qpVUB/LAJEaoeGj4ez0ZeBpQ/co7Vf5DUJxFhUQMxNE/GBHGkfQQD/+
         5+5Y7rMi08qHXVj0MZRBUxLvGOQVzd4I3RiMzFNNVfRIuYIdlBI2VOneT7BojbqKM3PC
         rNQ831N1RHPqB2ebsIFAmNf2BzQfp04Sb3HiO6bKut1W8VLR11ZPmD71NWEEDcuARl36
         /MBQ==;
        darn=lists.linux.dev
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1779200584; x=1779805384; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=U85B73on+pS5wOF0o8AWpMg1gEkWrxdiM7ougEA6mmw=;
        b=ril6wB6IYDfVycWl2vgYZ5rT8I8kw+lMqWPA8Nyrj/wjgzoZm4PcoJYKdtAPV8Rz1C
         00DH25w8xz8N5FIZkIysheYXMH623IpFTqVkhHxbBAk83Tv1/CVLn+4lOuyhdaMi7hLb
         ZKMynpH7qEObYIURVBf/70BaYhKSHScG328jnkKWeDUlUMtEmvFWelVHg8JJqeycVJKW
         sGv1SzMAp0SNgX0Q//JDzIkO/Rhbb7oa6Xu+OLz0RxxvifR2XfjC6fgxw0UJksXnCwAU
         v2CvjgOsxZv+X4pejWFEXE/eDJMHAf5KaTJfm4qRgIQ45b+mheGfgT4JCwxO7e70JPHu
         bHbw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1779200584; x=1779805384;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=U85B73on+pS5wOF0o8AWpMg1gEkWrxdiM7ougEA6mmw=;
        b=GeEGOvYEfcQYMPDKxKsdtGrhDQkiEr1X+0xHxNvhbt9d8/T3mZ9rDBxFi/tRJLWtyP
         h9XgcmW9m0tVKA5RA5UtF7viZSVQ2JxxDmfaC+2sFA2XBArvempJ1OXSUDjvOR/TvrZy
         gXeShPnW/Te+a0CreMd8USsBkdSKpKHKEofrT007kgoA+okQZl22cTG2TjWzk0pxTW7M
         jdn2oP99v8WpJvlspX8Oqkq6nVoBXBeIHIXi17kyn1olE/d+VBn0jIiuuEpgEAbRmwAS
         IhYyThriJPDKoBENPeJ/kfQU+xNMS8hPWrRc1HgrqfiuUbBkzyXq7MSm4URmSC3S+19a
         eSxQ==
X-Forwarded-Encrypted: i=1; AFNElJ/rjy/av4ld1HJXESSmAK7t+N7nUlDlLQAU4VEycBjE6z6SgNRDCvJyAZjkY6e9wlFdr9i+x5s=@lists.linux.dev
X-Gm-Message-State: AOJu0YxSwa1ltLxPa7LFBS6oSjf4LpkUPbebaZl1+D6F8q65PnBoBzeZ
	REC1hoCTtk4/6tPUTAC10j4ta7bLBh2z/vh8L9u6+EeoMaWLw1R07jpZzmnUy3rnGtkCNMq7iqu
	u4O8Nvyzgqv+2htCh6DNgvy0bvQ3jRT8FI5Az40Xr
X-Gm-Gg: Acq92OHiT/Urb9dD2St7YJ3J3cfGN31h4nKBLyv3J4QGluLt71Ybizihn1Y3uU22W+L
	Wu0htXjufopsSZMTebEcoJxzBbAgsjj4ThOVF2oVT/ilY6+3TjkZDq0QcOko8CNEzrgLyKqE5S4
	RN1/RG9koTvzvpubHGPcd1TTXd4hQRrnlZP3+9P7dJXtzjcpd52AZZqN354M9y1ZzvUfWkxfjRb
	un/ANMakBn+FYqMCQSMkmvZJkxknz8/F7fp5AIJ6E5lZjZkzMdhGm44sPswppi1lsi4Yc6423Oj
	TnoL78syewwnLxjl7RyldnyjYXdZSsojNWcQMzhuJWQyFC6YzBMfSXccLhnIFR/7MqtKVziWqA7
	Qf84=
X-Received: by 2002:a05:6870:a114:b0:42b:d6a3:7c49 with SMTP id
 586e51a60fabf-43a2dce8c90mr13106368fac.17.1779200583452; Tue, 19 May 2026
 07:23:03 -0700 (PDT)
Precedence: bulk
X-Mailing-List: syzbot@lists.linux.dev
List-Id: <syzbot.lists.linux.dev>
List-Subscribe: <mailto:syzbot+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:syzbot+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <4e2d36a7-9417-4c50-9ec1-3e82c7a670f3@mail.kernel.org> <CANp29Y5hQ8KXKdqe0CYqSk=NvLwwRZ0GwXhqj5FEhYFOz5g7nQ@mail.gmail.com>
In-Reply-To: <CANp29Y5hQ8KXKdqe0CYqSk=NvLwwRZ0GwXhqj5FEhYFOz5g7nQ@mail.gmail.com>
From: Aleksandr Nogikh <nogikh@google.com>
Date: Tue, 19 May 2026 16:22:51 +0200
X-Gm-Features: AVHnY4LKEqdHNqApoXK9SyEud2stzjcDjJbl8a8dfooqZdkc54A3LWUqjrCL6y0
Message-ID: <CANp29Y6v+-wW3SjwcGwc_b7OeLjRoHw_1dgdXc2EK-XKfp8+kw@mail.gmail.com>
Subject: Re: [PATCH RFC v2] wifi: cfg80211: replace WARN_ON() with dev_err()
 in netns switch
To: syzbot <syzbot@kernel.org>
Cc: syzkaller-upstream-moderation@googlegroups.com, syzbot@lists.linux.dev
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Tue, May 19, 2026 at 4:07=E2=80=AFPM Aleksandr Nogikh <nogikh@google.com=
> wrote:
>
> Debugging went 100% astray because of an strace output in the repro run r=
esults.
>
> #syz reject

Please ignore.
Dmitry correctly noted that this message is not related to this patch.

>
> On Tue, May 19, 2026 at 12:08=E2=80=AFAM 'syzbot' via
> syzkaller-upstream-moderation
> <syzkaller-upstream-moderation@googlegroups.com> wrote:
> >
> > The syzkaller reported a kernel panic in cfg802154_switch_netns() when
> > device_rename() fails with -ENOMEM. The crash occurs because WARN_ON()
> > is used to handle the memory allocation failure, which escalates into a
> > kernel panic when panic_on_warn is enabled.
> >
> > Memory allocation failures are expected runtime events under memory
> > pressure and should be handled gracefully. The WARN_ON() macro must not
> > be used for conditions that can legitimately happen. Failing to rename
> > the device or change the network namespace is not a fatal system error.
> >
> > Replace the WARN_ON() calls with dev_err() in both
> > cfg802154_switch_netns() and cfg80211_switch_netns(), as well as in
> > their respective pernet exit handlers (cfg802154_pernet_exit() and
> > cfg80211_pernet_exit()). This ensures that memory allocation failures
> > under pressure are handled gracefully, logging the error for debugging
> > purposes without bringing down the entire system.
> >
> > Fixes: 04600794958f1833f5571c6cde40f260ab557f55 ("cfg80211: support sys=
fs namespaces")
> > Assisted-by: Gemini:gemini-3.1-pro-preview Gemini:gemini-3-flash-previe=
w
> > Reported-by: syzbot+bd5829ba3619f08e2341@syzkaller.appspotmail.com
> > Link: https://syzkaller.appspot.com/bug?extid=3Dbd5829ba3619f08e2341
> > Link: https://syzkaller.appspot.com/ai_job?id=3Da1cfc84c-7c0f-4340-891d=
-885fcee80cad
> > To: <alex.aring@gmail.com>
> > To: <davem@davemloft.net>
> > To: <edumazet@google.com>
> > To: <kuba@kernel.org>
> > To: <linux-wpan@vger.kernel.org>
> > To: <miquel.raynal@bootlin.com>
> > To: <netdev@vger.kernel.org>
> > To: <pabeni@redhat.com>
> > To: <stefan@datenfreihafen.org>
> > Cc: <horms@kernel.org>
> > Cc: <johannes@sipsolutions.net>
> > Cc: <linux-kernel@vger.kernel.org>
> > Cc: <linux-wireless@vger.kernel.org>
> >
> > ---
> > v2:
> > - Replaced pr_err() with dev_err() to include device details in the err=
or messages.
> >
> > v1:
> > https://lore.kernel.org/all/7d949fbc-9781-4428-bfac-e51501b18bf7@mail.k=
ernel.org/T/
> > ---
> > diff --git a/net/ieee802154/core.c b/net/ieee802154/core.c
> > index 89b671b12..07082857c 100644
> > --- a/net/ieee802154/core.c
> > +++ b/net/ieee802154/core.c
> > @@ -245,7 +245,9 @@ int cfg802154_switch_netns(struct cfg802154_registe=
red_device *rdev,
> >                         wpan_dev->netdev->netns_immutable =3D false;
> >                         err =3D dev_change_net_namespace(wpan_dev->netd=
ev, net,
> >                                                        "wpan%d");
> > -                       WARN_ON(err);
> > +                       if (err)
> > +                               dev_err(&rdev->wpan_phy.dev,
> > +                                       "failed to change netns: %d\n",=
 err);
> >                         wpan_dev->netdev->netns_immutable =3D true;
> >                 }
> >
> > @@ -255,7 +257,9 @@ int cfg802154_switch_netns(struct cfg802154_registe=
red_device *rdev,
> >         wpan_phy_net_set(&rdev->wpan_phy, net);
> >
> >         err =3D device_rename(&rdev->wpan_phy.dev, dev_name(&rdev->wpan=
_phy.dev));
> > -       WARN_ON(err);
> > +       if (err)
> > +               dev_err(&rdev->wpan_phy.dev, "failed to rename device: =
%d\n",
> > +                       err);
> >
> >         return 0;
> >  }
> > @@ -350,8 +354,11 @@ static void __net_exit cfg802154_pernet_exit(struc=
t net *net)
> >
> >         rtnl_lock();
> >         list_for_each_entry(rdev, &cfg802154_rdev_list, list) {
> > -               if (net_eq(wpan_phy_net(&rdev->wpan_phy), net))
> > -                       WARN_ON(cfg802154_switch_netns(rdev, &init_net)=
);
> > +               if (net_eq(wpan_phy_net(&rdev->wpan_phy), net)) {
> > +                       if (cfg802154_switch_netns(rdev, &init_net))
> > +                               dev_err(&rdev->wpan_phy.dev,
> > +                                       "failed to switch netns on exit=
\n");
> > +               }
> >         }
> >         rtnl_unlock();
> >  }
> > diff --git a/net/wireless/core.c b/net/wireless/core.c
> > index 6783e0672..6badcec46 100644
> > --- a/net/wireless/core.c
> > +++ b/net/wireless/core.c
> > @@ -184,7 +184,9 @@ int cfg80211_switch_netns(struct cfg80211_registere=
d_device *rdev,
> >                         wdev->netdev->netns_immutable =3D false;
> >                         err =3D dev_change_net_namespace(wdev->netdev, =
net,
> >                                                         "wlan%d");
> > -                       WARN_ON(err);
> > +                       if (err)
> > +                               dev_err(&rdev->wiphy.dev,
> > +                                       "failed to change netns: %d\n",=
 err);
> >                         wdev->netdev->netns_immutable =3D true;
> >                 }
> >
> > @@ -204,7 +206,8 @@ int cfg80211_switch_netns(struct cfg80211_registere=
d_device *rdev,
> >         wiphy_net_set(&rdev->wiphy, net);
> >
> >         err =3D device_rename(&rdev->wiphy.dev, dev_name(&rdev->wiphy.d=
ev));
> > -       WARN_ON(err);
> > +       if (err)
> > +               dev_err(&rdev->wiphy.dev, "failed to rename device: %d\=
n", err);
> >
> >         nl80211_notify_wiphy(rdev, NL80211_CMD_NEW_WIPHY);
> >
> > @@ -1809,8 +1812,11 @@ static void __net_exit cfg80211_pernet_exit(stru=
ct net *net)
> >
> >         rtnl_lock();
> >         for_each_rdev(rdev) {
> > -               if (net_eq(wiphy_net(&rdev->wiphy), net))
> > -                       WARN_ON(cfg80211_switch_netns(rdev, &init_net))=
;
> > +               if (net_eq(wiphy_net(&rdev->wiphy), net)) {
> > +                       if (cfg80211_switch_netns(rdev, &init_net))
> > +                               dev_err(&rdev->wiphy.dev,
> > +                                       "failed to switch netns on exit=
\n");
> > +               }
> >         }
> >         rtnl_unlock();
> >  }
> >
> >
> > base-commit: 5d6919055dec134de3c40167a490f33c74c12581
> > --
> > This is an AI-generated patch subject to moderation.
> > Reply with '#syz upstream' to send it to the mailing list.
> > Reply with '#syz reject' to reject it.
> >
> > See  for more information.
> >
> > --
> > You received this message because you are subscribed to the Google Grou=
ps "syzkaller-upstream-moderation" group.
> > To unsubscribe from this group and stop receiving emails from it, send =
an email to syzkaller-upstream-moderation+unsubscribe@googlegroups.com.
> > To view this discussion visit https://groups.google.com/d/msgid/syzkall=
er-upstream-moderation/4e2d36a7-9417-4c50-9ec1-3e82c7a670f3%40mail.kernel.o=
rg.
