Received: from mail-ot1-f41.google.com (mail-ot1-f41.google.com [209.85.210.41])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E895F43A7F4
	for <syzbot@lists.linux.dev>; Wed, 29 Jul 2026 09:01:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.210.41
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785315683; cv=pass; b=bOtP/M3z9yUTvryEHaGKFmeTtoaSqXZhh77Prt2QT33642Lu5VcvTMPC8bShma2D+LJx5L9Q8zte4A4SGbxMUceflbzRV9L1WvcNXmrYuvaHemoBgXA+qtP9WWMZJ7znV3sM0Iu3BoLbBPPD6t7s+DaKfEEmxZTIq5FoaJdwvLs=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785315683; c=relaxed/simple;
	bh=yjg774Y5QzWrUS430sdL5OZ/jVETb/vzYhm50CbIgwE=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=FJRQCwE9mehTo3MI39MchrlnRYdPXTsnf62Df+jv1qrQpQWG3QWqqBXUMe9KzP/D3zpDDu3aR5OMZwTt/pJU8343xnGJRhDo3fyvLtTvM/eTI6zsl0zXwn/XS7SUYYUlMbqUa7bqx4YUQFveOajwNVa5QgVIAj1Ly6nOogVnuSM=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=QmC6Hvx6; arc=pass smtp.client-ip=209.85.210.41
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="QmC6Hvx6"
Received: by mail-ot1-f41.google.com with SMTP id 46e09a7af769-7ec49608332so386013a34.3
        for <syzbot@lists.linux.dev>; Wed, 29 Jul 2026 02:01:21 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1785315681; cv=none;
        d=google.com; s=arc-20260327;
        b=duu2OJU7wCAvgREwl36nRyXkvPv7guq2CweI5hRVEzHkkmYodLt0Ln9ncX6VJTVIj8
         7WhbkflCzi+5YSuxaTmtP6m8QqSdpaFR0NiFkdfDkprwlc9EPQXeRbnXMPmORKRoFDHH
         O3yeT5gYT6+3Eo5cLDvZ/v6iuOAedRKum5NaP61O0S1/MkSVUdJf6SPcS5IYW+ht4jlK
         ndXtd4qEsOLcEUyvHF/5QxvyusGcHCRwfX9jgplrY7X4spHni9LROB60A53N+RcdSPRu
         djhJ+x1KQNO9JJPLXiQiChjo+IYy14v28Lz1v5WdM2w8mWdv0YV5Bexx3NYCDsGovE/L
         cmAA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=8U+xCTfNrH4fEq63CBJI11vovv+qlUgpyEB/fe2dEaQ=;
        fh=tOXPurlgo60HHkooYtgsgty8+73rF0zfNotkU1tUcJ4=;
        b=DhnNLtIJu47xiXKEfZc0Rz8QgyCIzoRGVc3/b56GCAJM/b4EAXEI3kW8KnGW6o6aVG
         1LP+SS38B+uio0tP7S4r/N64CnfUdldOo/EJYc6MyGKYOWinL+iqh+Y6pA+WP+83ee9W
         gNFxftO7x0aca0y84b4TUCyQujcVJlMXBJTuFFQtyn9NLlqvC73PZ6RhByGmai1W3l/D
         19jchUUOdUsbDmmVl9/6cXROAoH35IDtfswrwIkE9sicqd8BYGkO4eUJP8LvXy995r8i
         jlhta3cCQBWc/SOxwLmPovTLWqplqbEs1OVYRYrFLTTRKwFP9utwMWW9JK5DLI4AGviC
         1fRA==;
        darn=lists.linux.dev
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1785315681; x=1785920481; darn=lists.linux.dev;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=8U+xCTfNrH4fEq63CBJI11vovv+qlUgpyEB/fe2dEaQ=;
        b=QmC6Hvx6bJ5sKT907BHeHIAIiGq5EO3l5mucU5ddYSZ8vKkWt1V9LyC3jw12b5hJWr
         JvQS2v8ls37iGr9uT0SF2kSbjQ83goD+bxbSJCxPnspv7HGDlMUuAweSL+RgCXPw9CTq
         VrVPPSspCp/1jfob74qkIik1v50BmL/khsLsvYypTllUUeezLVXDiBDMuwA3xlicGR4L
         tNdFZXyqCKNul7aHEzaAlhX5QLcB7aonpGdkhjz606j/h596cOVm8B004Dq+yZ7R82nw
         8ktxkWHHCAgV+UHtt8rIbeoehYp+h3pEm85vuazRsxhoUYJaSkK7xp4DfV0CrDHPpsI+
         5GAA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1785315681; x=1785920481;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=8U+xCTfNrH4fEq63CBJI11vovv+qlUgpyEB/fe2dEaQ=;
        b=NnaKJks1DHK29OUcPS7YCCARDeEFwuvMrb9tjEJkdyBybrrt7Fb7yE4BMVJzV6I6IO
         YVQH/s9tBUOsgKBWc5XY73YCu9nVJnk3sCMF1QsdfXxaidyDHtYt5vT9y9hsczK7fy6B
         6Azyzb42zJKlCe6PKKe2DE5BujbY6Ff/XsziEsZw29MspCdr+qPSqg0Qoi0u5r/v9+lD
         zJ0urf77oWynSMW7abeRijrWeZsIonHcnptM9gN17F/0Ri8A4hVgfxTBbz4G5ig4rqIr
         Mff0CgRMbnh7sZ577KY9mFuO7Ls3gj92/3Bqxt7IB+fO5besNsy/gEh8/XTLSzA545bC
         HGmQ==
X-Forwarded-Encrypted: i=1; AHgh+Rof+8UPqKYyAv2gljtBzNouM4cnXBICnQ9Bg21DxOOvwAbamvFJqO8DpeaktQLzbkajOL2R+Ss=@lists.linux.dev
X-Gm-Message-State: AOJu0YxhdwKD5JrWc9K23pJLrXREZTy1L08GGvqJY376u7eqLiS+CYit
	Wp+bjNmvK63kG8EKsLAC9LQUUQoKDYXpS/cvtg9gKoo/JZvpSh1ozyrRrdI/34h2fnauSLur8D1
	PZOmBZsvWTSJLI2SWoUUEAehmBO+ZFyIJ8lVM/2xF
X-Gm-Gg: AR+sD11Cl6m4+DtZaPPA9RLykWZmKff/GJteRKxquMw0qs+XE/qcXOj0D3ss6LUN+S8
	tHtEGGogM2vNMZzsaoZMi5XTLisYwSCsCfiIvLJtHSwhky8bIQTLlHKDmvTlRKRWbVAZ9vt/394
	5/99LnrVc2nCnxLZH4y4V4dm9SWziDXY1rgp/nlVPGGteyWUKpZqLTeJ+HeWeZ38b3i2dzHMtux
	P3Oi4/inShBiT8pyOaaXPRoMPOMDp1pkiJ+v5yZyEt+8Y4MBSrc92MJ8e/d3/dNJ6lLsAcHd+x7
	FV6rAdNxJ5Zn+fuDtE+7YzDgnQ50jA/k/F56RxgCLqozVDhk0xLrbSLkEEkwB7nfZymanxPUjvq
	RclkiYqrKo7D0vady1uTrD68wdhpl/25JVwYvAc1DQ5Fh3NI5VIdNm9MKUK2+XoFofB0dOha7nj
	8c/zP4xC0LCSxo
X-Received: by 2002:a05:6830:6f85:b0:7e9:ef39:1caf with SMTP id
 46e09a7af769-7effefef0camr3709846a34.16.1785315680267; Wed, 29 Jul 2026
 02:01:20 -0700 (PDT)
Precedence: bulk
X-Mailing-List: syzbot@lists.linux.dev
List-Id: <syzbot.lists.linux.dev>
List-Subscribe: <mailto:syzbot+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:syzbot+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <8e3a30ca-25ad-44cf-9fa2-b4d70f4572ab@mail.kernel.org>
In-Reply-To: <8e3a30ca-25ad-44cf-9fa2-b4d70f4572ab@mail.kernel.org>
From: Aleksandr Nogikh <nogikh@google.com>
Date: Wed, 29 Jul 2026 11:01:08 +0200
X-Gm-Features: AUfX_mxh9Up192pUEN1z2g5La4TgT2fGcI1dnoKvz0r-ryFAGqwO6jjqYErrIMc
Message-ID: <CANp29Y65A-pi6w9dNwoiLZ9oHfORbVt83YJECqadFnCatRG0QA@mail.gmail.com>
Subject: Re: [PATCH RFC] usb: gadget: midi2: Fix null-pointer dereference in f_midi2_free_ep_reqs
To: syzbot <syzbot@kernel.org>
Cc: syzkaller-upstream-moderation@googlegroups.com, syzbot@lists.linux.dev
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

#syz upstream

On Wed, Jul 29, 2026 at 10:17=E2=80=AFAM 'syzbot' via
syzkaller-upstream-moderation
<syzkaller-upstream-moderation@googlegroups.com> wrote:
>
> A null-pointer dereference occurs in f_midi2_free_ep_reqs() when attempti=
ng
> to clean up an endpoint that was never initialized.
>
> When configuring the MIDI 2.0 gadget via configfs and setting the block
> direction to SNDRV_UMP_DIR_INPUT, the initialization of the midi1_ep_out
> endpoint is explicitly skipped during the gadget bind phase
> (f_midi2_bind()). As a result, the usb_ep->card field remains NULL.
>
> Later, when the host sets the alternate setting, f_midi2_set_alt()
> unconditionally stops both the IN and OUT endpoints by calling
> f_midi2_stop_eps(), which in turn calls f_midi2_free_ep_reqs() for both
> endpoints. When f_midi2_free_ep_reqs() is called for the uninitialized
> midi1_ep_out, it attempts to dereference usb_ep->card to determine the
> number of requests to free, leading to a crash.
>
> Fix this by using usb_ep->num_reqs instead of usb_ep->card->info.num_reqs
> in f_midi2_free_ep_reqs(). usb_ep->num_reqs is correctly set during
> f_midi2_init_ep() and remains 0 if the endpoint was never initialized,
> safely avoiding the loop. For consistency, apply the same change to
> f_midi2_alloc_ep_reqs().
>
> Oops: general protection fault, probably for non-canonical address
> 0xdffffc00000000ee: 0000 [#1] SMP KASAN NOPTI
> KASAN: null-ptr-deref in range [0x0000000000000770-0x0000000000000777]
> ...
> RIP: 0010:f_midi2_free_ep_reqs drivers/usb/gadget/function/f_midi2.c:1166
> [inline]
> RIP: 0010:f_midi2_stop_eps+0x28e/0x4d0
> drivers/usb/gadget/function/f_midi2.c:1246
> ...
> Call Trace:
>  <TASK>
>  f_midi2_set_alt+0x11c/0xf00 drivers/usb/gadget/function/f_midi2.c:1296
>  composite_setup+0x1ffd/0x3480 drivers/usb/gadget/composite.c:1933
>  configfs_composite_setup+0xbd/0x100 drivers/usb/gadget/configfs.c:1877
>
> Fixes: 8b645922b223 ("usb: gadget: Add support for USB MIDI 2.0 function =
driver")
> Assisted-by: Gemini:gemini-3.5-flash Gemini:gemini-3.1-pro-preview syzbot
> Reported-by: syzbot+bbb6dad313f4aaa8da6b@syzkaller.appspotmail.com
> Closes: https://syzkaller.appspot.com/bug?extid=3Dbbb6dad313f4aaa8da6b
> Link: https://syzkaller.appspot.com/ai_job?id=3D8ce30b1a-8cf7-4e38-bcf7-1=
f69e6f6313f
> To: "Greg Kroah-Hartman" <gregkh@linuxfoundation.org>
> To: <linux-usb@vger.kernel.org>
> To: "Takashi Iwai" <tiwai@suse.de>
> Cc: "Christophe JAILLET" <christophe.jaillet@wanadoo.fr>
> Cc: "Kees Cook" <kees@kernel.org>
> Cc: <linux-kernel@vger.kernel.org>
>
> ---
> diff --git a/drivers/usb/gadget/function/f_midi2.c b/drivers/usb/gadget/f=
unction/f_midi2.c
> index 19fdac024..5e54cf994 100644
> --- a/drivers/usb/gadget/function/f_midi2.c
> +++ b/drivers/usb/gadget/function/f_midi2.c
> @@ -1145,7 +1145,7 @@ static int f_midi2_alloc_ep_reqs(struct f_midi2_usb=
_ep *usb_ep)
>         if (!usb_ep->reqs)
>                 return -EINVAL;
>
> -       for (i =3D 0; i < midi2->info.num_reqs; i++) {
> +       for (i =3D 0; i < usb_ep->num_reqs; i++) {
>                 if (usb_ep->reqs[i].req)
>                         continue;
>                 usb_ep->reqs[i].req =3D alloc_ep_req(usb_ep->usb_ep,
> @@ -1160,10 +1160,9 @@ static int f_midi2_alloc_ep_reqs(struct f_midi2_us=
b_ep *usb_ep)
>  /* Free allocated requests */
>  static void f_midi2_free_ep_reqs(struct f_midi2_usb_ep *usb_ep)
>  {
> -       struct f_midi2 *midi2 =3D usb_ep->card;
>         int i;
>
> -       for (i =3D 0; i < midi2->info.num_reqs; i++) {
> +       for (i =3D 0; i < usb_ep->num_reqs; i++) {
>                 if (!usb_ep->reqs[i].req)
>                         continue;
>                 free_ep_req(usb_ep->usb_ep, usb_ep->reqs[i].req);
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
-upstream-moderation/8e3a30ca-25ad-44cf-9fa2-b4d70f4572ab%40mail.kernel.org=
.
