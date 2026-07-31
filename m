Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E11743DF018
	for <syzbot@lists.linux.dev>; Fri, 31 Jul 2026 10:04:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=100.103.45.18
ARC-Seal:i=3; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785492250; cv=pass; b=I8VFyKCWG98tKpToyOHqGKiY0AHbmYGfsq5AY35hvVPIe/hRZIGjguOlHXotX6yvf/C5dKUuM7z/JXV5n54DipCHuMpEGzZijr2CdQsBJz0+1Xbk9H7o/TcEaVaL5fQfDVMpy8gvOlDLAdwYN17W8eL9eJjSgbguw89qs19q0XY=
ARC-Message-Signature:i=3; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785492250; c=relaxed/simple;
	bh=l8FUs0uxE253c7GIR9AtOz1umCH9Z5/NdjrgQkKeK2k=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=mlgtM+pWkhY4868wKPahVDPYSh5WmrNWpGiiYGZQdmy3cgR/HCQ1bx4TFG2xuswya0/FZQxmRzF9MUqy82oeijxtS1FANxhhMh8efWVLa6dKqhSV+9peiA6GdSExnb0KK8A/0dV72fmzzyhezANlUT6xEeZ6Ejd1SlXEpiDZy0E=
ARC-Authentication-Results:i=3; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=S0hZoII2; arc=pass smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="S0hZoII2"
Received: by smtp.kernel.org (Postfix)
	id B7D7F1F00A3A; Fri, 31 Jul 2026 10:03:56 +0000 (UTC)
Authentication-Results: smtp.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=209.85.210.54
ARC-Seal: i=2; d=kernel.org; s=arc20260519; a=rsa-sha256; cv=pass;
	t=1785492236;
	b=eXGxxcp/1xWXENTlzpSaxM0iOm/7VYMIQQN6P60tyWdPzVInxfbTyoPWB9sVHvceBui0
	 56j2YHAoHrrX9CWQ07Q7mLEzKL1xGH2Hf4SmMiVfA7yhtNWo3YMVuoYy2U6F9JZRMNTNW
	 aBH/B3lCQG8aVyhfQLStv48dP0kZ+1wk0RuPukmX6Oi4jqXmSsCSCpKSwe6qmnw/0o+Qs
	 g7Frv0jK/7RcDOtT7mM9YqeboX0ZJwX1v+qaJ2eMjjAFtSB/R617Ia/epJo0xJLscIZ2u
	 hGfP9MMVE4boTnkfGl7nbrnRLMTmrtEsgzkSBm10ONS5OwBMD9EsvNA+3+cC4PFWgjQ==
ARC-Message-Signature: i=2; d=kernel.org; s=arc20260519; a=rsa-sha256;
	c=relaxed/relaxed; t=1785492236;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Gm-Message-State:X-Gm-Gg:X-Received:MIME-Version:References:
	 In-Reply-To:From:Date:X-Gm-Features:Message-ID:Subject:To:Cc:
	 Content-Type:Content-Transfer-Encoding;
	bh=t6sAmlwv7gAbvbPr1bp5KZymBABy+/7jrbfhtEQa3Js=;
	b=fYfNsuxTHft+oNCQt6ai1OpOsfLsLLmOUc3tx6llbW+U/TFp9HXQIDA5QMbKVYkD4tW+
	 ClUGdccbg0dXR0JG/92OHEKoZJ03Jjdx22hb0agBmsjwh9Ik45YvXUfwbG3DTxtsPkxjZ
	 JALiYuXyaa6BkKkAi/q8xoHr0OtxAPHZJsKOfVnLiia+1So1sqcE2Alc95An64Mb8Gq8e
	 Qq8CDwTFDChoryQKfJwqQeovLqGeeswa7mMcPk5qvqpWBX9LG+WUGXWfP3R640mFtMK4K
	 nmVSfmxEoHUrFkXZ4bLq5wDLtvnJgySo9Oh0fXryPKh3OPUIiDxYmbWfiOMx7EzQ4HA==
ARC-Authentication-Results: i=2; smtp.kernel.org; dkim=pass header.d=google.com header.i=@google.com header.a=rsa-sha256 header.s=20251104 header.b=S0hZoII2;
	dmarc=pass header.from=google.com;
	spf=pass smtp.mailfrom=google.com;
	arc=pass header.oldest-pass=0 smtp.remote-ip=209.85.210.54
Received: from mail-ot1-f54.google.com (mail-ot1-f54.google.com [209.85.210.54])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.kernel.org (Postfix) with ESMTPS id 1EB041F000E9
	for <syzbot@kernel.org>; Fri, 31 Jul 2026 10:03:55 +0000 (UTC)
Authentication-Results: smtp.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=google.com header.i=@google.com header.a=rsa-sha256 header.s=20251104 header.b=S0hZoII2
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.kernel.org 1EB041F000E9
Authentication-Results: smtp.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.kernel.org; spf=pass smtp.mailfrom=google.com
Received: by mail-ot1-f54.google.com with SMTP id 46e09a7af769-7eb29ed2bbdso281467a34.2
        for <syzbot@kernel.org>; Fri, 31 Jul 2026 03:03:55 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1785492235; cv=none;
        d=google.com; s=arc-20260327;
        b=em4RhS4fVSge3p8OMt5xMIFvNnsvmlJaDMu+pzohv2N09yqSo1Es/49T3unkT58II7
         9PwVsyt9lAyyUzQUDl7EWwdBcrrvsfZOZXJra7s3Pnoa2hbRdL3V6MM3h5hV8r432t5R
         En/7e3kGWGtb6Adt96lqiYN3Mx6LM5FLMbKbmRkHdCdAyTrhWccnQKC7pfFiUw+7V8mc
         mCUaoq6o/pkYY6crC7qYL281KCFhaqB8tlbtU7EoqUda5C2oAouHf4bcknmOziI15o+v
         jsLjGPDoLG4YgN4Fc1ZswNCDBUOWJj5ji69pEqsx8hENaZNkaVqfPi53rsK0ZmM46495
         6GhQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=t6sAmlwv7gAbvbPr1bp5KZymBABy+/7jrbfhtEQa3Js=;
        fh=2Ld/g5BVZzBadtquf8mrXl84q+iOtbUed/2ECOFnmmI=;
        b=ezhw+1PJG9q0mBeqCDAL5bc5uwpe4sAqx2CUBmXunghA1ovnGbKqG2woXCSAsMz7JC
         DEQfLEz2f4LGdHXFiyTGgpMqYDxlGcH7x+873ZOLgR1+bQCrIlTDVq31VZd4QzvhAh+c
         KXhzdQSYmpzwUHl/C7jqlNlB19fmQvrp4I9ozeNsvj2OkdeNnLJTGUQO4JKc19ZilgbB
         OMimCBurj1dklz2e6sfSeB23ODVajt3Y4liaeBzXotpKpJY87S/GqD02PNWEB+298HG7
         cmS3dDYIstNRV1Fo+HFMx/dJbL96j1aOJIS0579kGJxE7SoELEWyYb9cut3BSsTSkVev
         Dumw==;
        darn=kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1785492235; x=1786097035; darn=kernel.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=t6sAmlwv7gAbvbPr1bp5KZymBABy+/7jrbfhtEQa3Js=;
        b=S0hZoII2S0TpF75GmWFOPHQHtS2KVVI2RXtO4Yjm7B6g9RJ0nnZvrBoJDHXHRFGeLh
         4SjhrGzdp1ciLyZVRXcwHnvP03dk+jv54u7YbT+vTF3vHf3aI1e5ZPiXs1PphCvvBVki
         1mKnJ/Aryf7uRBPy5KwXcDF8Gbbe2QmRJywRdi6QZ8L348GIBfjHuMrda1QgS90MDOFD
         qVq4616dHTuDbskemFfOriC0gDwcIK4M0oFFmPco4mnep7Ob2P2kB4Ri0oHYnHrdqt8i
         huWEF2oCiCcx0ocFNjFauM6zNfQg9OQBcvLMEDgYu3KcgGNVR62YANcqYQYm7q0tGrz2
         MBQA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1785492235; x=1786097035;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=t6sAmlwv7gAbvbPr1bp5KZymBABy+/7jrbfhtEQa3Js=;
        b=oMlYIItsBAvKZMsHCNF5vIfGYdo9meEKoe5WU6iPiLxEgXSxW0E89uifZPqZDEYaKr
         4aRf7Y8IMldNHJJ48ryqCQC8RZBYVW/ktet+gzQiazCcU/yHV6uzLrtZIyrdOguDP5EH
         bSEav1KhMnu4rOGQRrLllK+/XP7ZKmYxfyucK7yAcwerYC17SgiXfD2/+Ve7BTZSZ0qG
         jzbgH0lEGj197TLhL9z0a0rJpdA2ndeW/JOMJos2OMM0R/aMC8tDVYGPdV/Uhds0jKrT
         lV0z8nPZUDgBvSffYgIEHyvi/zlEdBmgros5d1cY4eCKtvlhfNnnuJkrqQqdSFZ18sUc
         cr+w==
X-Gm-Message-State: AOJu0YweC8iTWCE2ltz1o4EglqMM1da6Knc01mMD/MJsW04Oc+PQbgIb
	pQOdSCO6ucl7zGn7USV8zNQp0HxicZaouR6D9NqSwy3TUB5DGIQKO7er6umDjwrhpm2njCann4Q
	7dNLedJo0m7hU8FZ5plnaGCFMa+bc/JjJXrPQ9QoZxRZTNBV89p4Jolq4
X-Gm-Gg: AR+sD124SpS5TST96xtQvbZP7LKAng3C8j0Cpq8KYfxXmydHGQMmg7Jvtu7hlxfroE3
	B7mgjzlHHrweSpfPuuK3s6Is2vCuXfQRL3wpJSzfgDm7eQ5J9K7ENtYsIFvXUIqaJEjfG7zKQU3
	BN/dPAGBWR8eD+1QRPxsthm6zFP0irDvklaS8ZYj2zhGJr9EmWWZCd/dHGvjv7bp4iZqyhH/D1S
	rn1DYOhc7tlCRPIxsCo7lFI0U5sXlYPCu6dN8p9Zk/pchOP9iMCrnSwRaAgK4cpGou8Drlt9Cl9
	N11sR2x9AdQzMDjbhyCd0iOKp29YUDWhFxluJN864XSrFrR+QJY1VHWxcbVqjxdTh8ukvslZYkZ
	gLpAKUomuBtoYkD0hR9327irmxZit27gQQ03OB9/9I1v2EYh2YBJv3vw8HmaJxzaYdIEQuMsZNN
	tWGr2XQIv7OKtD
X-Received: by 2002:a05:6830:6012:b0:7e6:c9eb:535a with SMTP id
 46e09a7af769-7f189b8db04mr1726127a34.6.1785492234378; Fri, 31 Jul 2026
 03:03:54 -0700 (PDT)
Precedence: bulk
X-Mailing-List: syzbot@lists.linux.dev
List-Id: <syzbot.lists.linux.dev>
List-Subscribe: <mailto:syzbot+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:syzbot+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <7c563560-c865-48d0-a1af-7d786d353d3c@mail.kernel.org>
In-Reply-To: <7c563560-c865-48d0-a1af-7d786d353d3c@mail.kernel.org>
From: Aleksandr Nogikh <nogikh@google.com>
Date: Fri, 31 Jul 2026 12:03:43 +0200
X-Gm-Features: AUfX_mzGLRZddoKS27CmiXYFvhZJ4WTXVrUswdnkUiaKZM3DJLUTWDodKu7yQDQ
Message-ID: <CANp29Y5i6Tp7g1-H2L8N3mCdBNX9hMwWh9GRFmRSbAuDnyPkdg@mail.gmail.com>
Subject: Re: [PATCH RFC] xfrm: add missing RCU read lock in xfrm_send_migrate_state()
To: syzbot <syzbot@kernel.org>
Cc: syzkaller-upstream-moderation@googlegroups.com, syzbot@lists.linux.dev
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

#syz upstream

On Fri, Jul 31, 2026 at 10:11=E2=80=AFAM 'syzbot' via
syzkaller-upstream-moderation
<syzkaller-upstream-moderation@googlegroups.com> wrote:
>
> xfrm_nlmsg_multicast() requires the RCU read lock to be held because it
> safely dereferences the net->xfrm.nlsk pointer using rcu_dereference().
> When it is called from xfrm_send_migrate_state(), the RCU read lock is no=
t
> held, which triggers a suspicious RCU usage warning:
>
> WARNING: suspicious RCU usage
> net/xfrm/xfrm_user.c:1630 suspicious rcu_dereference_check() usage!
>
> Call Trace:
>  lockdep_rcu_suspicious+0x13f/0x1d0 kernel/locking/lockdep.c:6876
>  xfrm_nlmsg_multicast+0x1d8/0x1f0 net/xfrm/xfrm_user.c:1630
>  xfrm_send_migrate_state+0x870/0xae0 net/xfrm/xfrm_user.c:3340
>  xfrm_do_migrate_state+0x1749/0x1e90 net/xfrm/xfrm_user.c:3507
>  xfrm_user_rcv_msg+0x7a8/0xf30 net/xfrm/xfrm_user.c:3907
>
> Fix this by wrapping the xfrm_nlmsg_multicast() call in
> xfrm_send_migrate_state() with rcu_read_lock() and rcu_read_unlock().
>
> Fixes: a9d155ea9b44 ("xfrm: add XFRM_MSG_MIGRATE_STATE for single SA migr=
ation")
> Assisted-by: Gemini:gemini-3.5-flash Gemini:gemini-3.1-pro-preview syzbot
> Reported-by: syzbot+c0e99a1aa85a286d7a3b@syzkaller.appspotmail.com
> Closes: https://syzkaller.appspot.com/bug?extid=3Dc0e99a1aa85a286d7a3b
> Link: https://syzkaller.appspot.com/ai_job?id=3D8977f559-3a7e-4bb5-b4d6-1=
196956260b6
> To: "David S. Miller" <davem@davemloft.net>
> To: "Eric Dumazet" <edumazet@google.com>
> To: "Herbert Xu" <herbert@gondor.apana.org.au>
> To: "Jakub Kicinski" <kuba@kernel.org>
> To: <netdev@vger.kernel.org>
> To: "Paolo Abeni" <pabeni@redhat.com>
> To: "Steffen Klassert" <steffen.klassert@secunet.com>
> To: "Antony Antony" <antony.antony@secunet.com>
> Cc: "Simon Horman" <horms@kernel.org>
> Cc: <linux-kernel@vger.kernel.org>
>
> ---
> diff --git a/net/xfrm/xfrm_user.c b/net/xfrm/xfrm_user.c
> index d6db63304..0ba0614d6 100644
> --- a/net/xfrm/xfrm_user.c
> +++ b/net/xfrm/xfrm_user.c
> @@ -3337,7 +3337,11 @@ static int xfrm_send_migrate_state(struct net *net=
,
>                 return err;
>         }
>
> -       return xfrm_nlmsg_multicast(net, skb, 0, XFRMNLGRP_MIGRATE);
> +       rcu_read_lock();
> +       err =3D xfrm_nlmsg_multicast(net, skb, 0, XFRMNLGRP_MIGRATE);
> +       rcu_read_unlock();
> +
> +       return err;
>  }
>
>  static int xfrm_do_migrate_state(struct sk_buff *skb, struct nlmsghdr *n=
lh,
>
>
> base-commit: f5098b6bae761e346ebcd9da7f95622c04733cff
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
-upstream-moderation/7c563560-c865-48d0-a1af-7d786d353d3c%40mail.kernel.org=
.
