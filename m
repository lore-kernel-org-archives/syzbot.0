Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1D05F3ED3A0
	for <syzbot@lists.linux.dev>; Tue, 19 May 2026 14:08:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=10.30.226.201
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779199685; cv=pass; b=ciHoi6PeT7ZUats4tSYLa/GHdu+/bKPD2DqxQvoQ1O6/WAfwPPuhIID8/lwcbKMxmfQWRYthZoL3OvHSeQiwfWDvxkyn50PzEnbVVOjKCAkJG6OsQurw84Q3p2S+s53ED0XEgDW914SVtPi50xYIZ6yWbEe6Dwj2kz1UgNRvtE8=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779199685; c=relaxed/simple;
	bh=qyaIl/rB9lhXJOwgAEN2uMptAQLcktAvrapOG7Boz+c=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=FcIIbx/jHL4IyhGB7P+ORZHgYT6s98nLC3sIFhZXsXA3F6oxudBDBkeDlnEf6GtFNWt3XAXvCPHxvACZgvl4MAmIZ6v3dD+KzklDyXPr5qSSIy/vb3uqani2ySeLEhz7dSNJXcbzdr4WD3GxzNx/frLT9e1671XTIOfo41nas2g=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=lYLEJ1Fd; arc=pass smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="lYLEJ1Fd"
Received: by smtp.kernel.org (Postfix)
	id B95EFC2BCB8; Tue, 19 May 2026 14:08:04 +0000 (UTC)
Received: from mail-oa1-f45.google.com (mail-oa1-f45.google.com [209.85.160.45])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp.kernel.org (Postfix) with ESMTPS id A91D8C2BCB3
	for <syzbot@kernel.org>; Tue, 19 May 2026 14:08:03 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 smtp.kernel.org A91D8C2BCB3
Authentication-Results: smtp.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.kernel.org; spf=pass smtp.mailfrom=google.com
Received: by mail-oa1-f45.google.com with SMTP id 586e51a60fabf-43a6491f5dbso2590323fac.3
        for <syzbot@kernel.org>; Tue, 19 May 2026 07:08:03 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1779199682; cv=none;
        d=google.com; s=arc-20240605;
        b=L6l0S2ELkWFT14HKWPh0+sa5p2GB7uBpYlpKR5mA2URO2mfUczIg5ye1r56dbSwswU
         MKRrMT+zMlfam7YGE0lN0HjLaYMoE650RInRPom+EhaXxBReSCk8f96DlZ8Rism6n8CX
         V5wrxYpEAtG/J5ftUxP///DZLOD1NnBnPRGYJVvXxrocKgRpswyA7UYS3LAV0kAnAL1h
         jTpI+kRXhCR4UcnQMBskHdmGeMD8BVU0KtU3447X9D7UC2EXpJqs5ntCpLsBWxg2z5Hl
         HZlXYoXCEzckre35mWFynU1eQ3tEbA04BgKbDwiIWgA+KMDdQAj4GmkQ1HThZg+sOSO5
         aobg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=noAr99US+j4LKRGAp9eMzXx2TU40b1+nB3umhICI5l8=;
        fh=2Ld/g5BVZzBadtquf8mrXl84q+iOtbUed/2ECOFnmmI=;
        b=QA8AVPxV/qBObUZQEc2X1/8Owd6EylN0wvMQcZbfaResLNHFzJqUIvVKW4RigwLT5X
         pxBF6FxxkDKs1I5Uep4ieTQNxofOqzSMznOZz5K1VxklUx+Wdg6Fkw1MQ1C47oEg6mgJ
         KrnYsw0QhkzvTjj+oWM26vHb8kiFBVPK1WDqhDkF/gsbAFfzDkWktZBU7kPji/oQHJ6t
         dWTulGw8HJBf9XqNx10JinWj8AROL+sCVMb1piFyVx5oNaXKfSQlIjJmfL4pyFsy0o4s
         IWQK11HURB9qRAeRsW6zfL2IHJYAdzZKVqg2GJFGKoCqt6GjbNxAuIlCrnE5O7wFwjz7
         97Zg==;
        darn=kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1779199682; x=1779804482; darn=kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=noAr99US+j4LKRGAp9eMzXx2TU40b1+nB3umhICI5l8=;
        b=lYLEJ1FdpgtZH/1UKWAdsHq5Q/Q7G3NpQngntluILfsud+F5rWxlaHoccuaNoDOq38
         5ugNqcZuvsOD3lqA6d2i/KuId1pL1r74mK8KcMv+k3xdnynsHjowgTU0mlD8WQOSfBa/
         Cnrq80LPTNhEsZxeTkIh/YAo/7NyGICn8ZxmEfV2N1wWiN2/uIzrrm8vCHOhsg3htePD
         hEIZizpEWcXXqZiRNUfUCVjjmVfVM9l3j44nn4/clBVKD4diEd7ks7I8iojIt6efwpGw
         69UXFKXTTDu6FZp5KSMobs/pdD8ZB0pJau5ftzsYrToZcRHbxLyb1tNHSviX1dj8GEW6
         1s4Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1779199682; x=1779804482;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=noAr99US+j4LKRGAp9eMzXx2TU40b1+nB3umhICI5l8=;
        b=pVZqmlZuCoyZTnJnnMpq/KhTcsFAf0fLrAn2MrdSyoqh86gHqH/4MD1UJJ/A7B+Mi6
         AMMtTR9hVpZVrQO56L4UlofETS18PIEIvQiqwEDA8/GBzu080hXwbn6KgckQffqAMVKp
         2IUGWxpBqa7tkaFS+vExe1+QJCRtB87x4jPx+97P1y425WvNldisNKHB+QcxzAjg+YkJ
         haF4f60x4A1cVrvVSxySs5dIm1TPQDhM+DmdKCnKGx8oy4xpqhFYXUdA8lfje1JPlVVu
         tob/OQQl86I5JJJGPVZ9lIC9h8CylFHMrvHm59crBXHko1DC+sf4Aia3CNImh2+m0eyY
         iBDA==
X-Gm-Message-State: AOJu0YyTvi1gLakjxM4hkM5wFz7n+zwXRtkOXBg6/h551eO5YK3ANd65
	7aIy/MFLh1cCFzn2XS7MxQNgjbNROWt12V2pk1XbtGHaMnWCDepxIpJQAC4NrOPEcjWDPWYBLyl
	2o49kccixZ4IGkxhQ0G+xn9FxF7LW4gK1Ajwepvvz5Re4GY5M7taiy84N
X-Gm-Gg: Acq92OGBIsAfFMkUE/rxCE9qDre9NZNND2scBLxMB0OajfdCKBI+8iaGGJGwGy/Ug1U
	LW9w+aWDk+uTYBi+t+rChlyfY/TPy0lWFAFPdk1rPANoAZRh5PUsCGdWmIXOBdIQ037p1jrCfhd
	jKYcCFtoY9D0skjf3EAe6Nk1I3eY0e8zFuRcI4Fgkg7km3Tm1Snhd+amrUYF0aFnEDclkqBogr8
	KuR8vjuKMiRr+qaL801VNGFUptSUpU3vC4IzxmIkB3seK9H2D0FRUAHsFhII6029hIDwGG9Iold
	wPRkanTZ/SAo09wJk86TAOsuzq9tG7DeGUP8e3Lqu95ulKI72Xtbgh3nUqYmnchx1iRRpDkL7fH
	pxlw=
X-Received: by 2002:a05:6870:c191:b0:3f5:694f:9366 with SMTP id
 586e51a60fabf-43a2e06c22dmr11916822fac.30.1779199681825; Tue, 19 May 2026
 07:08:01 -0700 (PDT)
Precedence: bulk
X-Mailing-List: syzbot@lists.linux.dev
List-Id: <syzbot.lists.linux.dev>
List-Subscribe: <mailto:syzbot+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:syzbot+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <4e2d36a7-9417-4c50-9ec1-3e82c7a670f3@mail.kernel.org>
In-Reply-To: <4e2d36a7-9417-4c50-9ec1-3e82c7a670f3@mail.kernel.org>
From: Aleksandr Nogikh <nogikh@google.com>
Date: Tue, 19 May 2026 16:07:49 +0200
X-Gm-Features: AVHnY4J_JGCdXcKVzg75tPUaeZlVwUrBsbz0KPw4wyddcnZwS7zBw8TV6geYf_c
Message-ID: <CANp29Y5hQ8KXKdqe0CYqSk=NvLwwRZ0GwXhqj5FEhYFOz5g7nQ@mail.gmail.com>
Subject: Re: [PATCH RFC v2] wifi: cfg80211: replace WARN_ON() with dev_err()
 in netns switch
To: syzbot <syzbot@kernel.org>
Cc: syzkaller-upstream-moderation@googlegroups.com, syzbot@lists.linux.dev
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Debugging went 100% astray because of an strace output in the repro run res=
ults.

#syz reject

On Tue, May 19, 2026 at 12:08=E2=80=AFAM 'syzbot' via
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
>
> Fixes: 04600794958f1833f5571c6cde40f260ab557f55 ("cfg80211: support sysfs=
 namespaces")
> Assisted-by: Gemini:gemini-3.1-pro-preview Gemini:gemini-3-flash-preview
> Reported-by: syzbot+bd5829ba3619f08e2341@syzkaller.appspotmail.com
> Link: https://syzkaller.appspot.com/bug?extid=3Dbd5829ba3619f08e2341
> Link: https://syzkaller.appspot.com/ai_job?id=3Da1cfc84c-7c0f-4340-891d-8=
85fcee80cad
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
> - Replaced pr_err() with dev_err() to include device details in the error=
 messages.
>
> v1:
> https://lore.kernel.org/all/7d949fbc-9781-4428-bfac-e51501b18bf7@mail.ker=
nel.org/T/
> ---
> diff --git a/net/ieee802154/core.c b/net/ieee802154/core.c
> index 89b671b12..07082857c 100644
> --- a/net/ieee802154/core.c
> +++ b/net/ieee802154/core.c
> @@ -245,7 +245,9 @@ int cfg802154_switch_netns(struct cfg802154_registere=
d_device *rdev,
>                         wpan_dev->netdev->netns_immutable =3D false;
>                         err =3D dev_change_net_namespace(wpan_dev->netdev=
, net,
>                                                        "wpan%d");
> -                       WARN_ON(err);
> +                       if (err)
> +                               dev_err(&rdev->wpan_phy.dev,
> +                                       "failed to change netns: %d\n", e=
rr);
>                         wpan_dev->netdev->netns_immutable =3D true;
>                 }
>
> @@ -255,7 +257,9 @@ int cfg802154_switch_netns(struct cfg802154_registere=
d_device *rdev,
>         wpan_phy_net_set(&rdev->wpan_phy, net);
>
>         err =3D device_rename(&rdev->wpan_phy.dev, dev_name(&rdev->wpan_p=
hy.dev));
> -       WARN_ON(err);
> +       if (err)
> +               dev_err(&rdev->wpan_phy.dev, "failed to rename device: %d=
\n",
> +                       err);
>
>         return 0;
>  }
> @@ -350,8 +354,11 @@ static void __net_exit cfg802154_pernet_exit(struct =
net *net)
>
>         rtnl_lock();
>         list_for_each_entry(rdev, &cfg802154_rdev_list, list) {
> -               if (net_eq(wpan_phy_net(&rdev->wpan_phy), net))
> -                       WARN_ON(cfg802154_switch_netns(rdev, &init_net));
> +               if (net_eq(wpan_phy_net(&rdev->wpan_phy), net)) {
> +                       if (cfg802154_switch_netns(rdev, &init_net))
> +                               dev_err(&rdev->wpan_phy.dev,
> +                                       "failed to switch netns on exit\n=
");
> +               }
>         }
>         rtnl_unlock();
>  }
> diff --git a/net/wireless/core.c b/net/wireless/core.c
> index 6783e0672..6badcec46 100644
> --- a/net/wireless/core.c
> +++ b/net/wireless/core.c
> @@ -184,7 +184,9 @@ int cfg80211_switch_netns(struct cfg80211_registered_=
device *rdev,
>                         wdev->netdev->netns_immutable =3D false;
>                         err =3D dev_change_net_namespace(wdev->netdev, ne=
t,
>                                                         "wlan%d");
> -                       WARN_ON(err);
> +                       if (err)
> +                               dev_err(&rdev->wiphy.dev,
> +                                       "failed to change netns: %d\n", e=
rr);
>                         wdev->netdev->netns_immutable =3D true;
>                 }
>
> @@ -204,7 +206,8 @@ int cfg80211_switch_netns(struct cfg80211_registered_=
device *rdev,
>         wiphy_net_set(&rdev->wiphy, net);
>
>         err =3D device_rename(&rdev->wiphy.dev, dev_name(&rdev->wiphy.dev=
));
> -       WARN_ON(err);
> +       if (err)
> +               dev_err(&rdev->wiphy.dev, "failed to rename device: %d\n"=
, err);
>
>         nl80211_notify_wiphy(rdev, NL80211_CMD_NEW_WIPHY);
>
> @@ -1809,8 +1812,11 @@ static void __net_exit cfg80211_pernet_exit(struct=
 net *net)
>
>         rtnl_lock();
>         for_each_rdev(rdev) {
> -               if (net_eq(wiphy_net(&rdev->wiphy), net))
> -                       WARN_ON(cfg80211_switch_netns(rdev, &init_net));
> +               if (net_eq(wiphy_net(&rdev->wiphy), net)) {
> +                       if (cfg80211_switch_netns(rdev, &init_net))
> +                               dev_err(&rdev->wiphy.dev,
> +                                       "failed to switch netns on exit\n=
");
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
-upstream-moderation/4e2d36a7-9417-4c50-9ec1-3e82c7a670f3%40mail.kernel.org=
.
