Received: from mail-oi1-f173.google.com (mail-oi1-f173.google.com [209.85.167.173])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5660C3BC68D
	for <syzbot@lists.linux.dev>; Fri, 31 Jul 2026 10:11:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.167.173
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785492678; cv=pass; b=ByUD5YbqvJman34DPBjZ8NrTQKx9m4g21p2WHjrdQO8oVkGBJ5PaTSCUMHmnD1MNTmg8QgD+M7RD9UChA4hAm3d/CAxZYRqSHEpFhp5znKEr2oZY2hi0WMI6OPLzZazCU3NsGA97vjE5EhVtpZMLJDus5tbk/jfSVy95G9XnNaQ=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785492678; c=relaxed/simple;
	bh=29bf8lMlbXfQNXAhMEB+LOAuMqx4V1JP3Jt+Gau+wR4=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=G89X4a9uAzYbyzoZZhNj0hS6XWWIODEkYTFn5k0f0B0w/mSo3TznRjogqBWvs7xd/iDPiCI8e6LO2zCxpLoV7POh2eVC4FXomdSWEq8Qh/HNM1iMZRM2ByOo6+QHBDOsOwlTq8dRCACgsifYFjydHYllebzBbbt2mPvZfxHxYWw=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=rmw7+ene; arc=pass smtp.client-ip=209.85.167.173
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="rmw7+ene"
Received: by mail-oi1-f173.google.com with SMTP id 5614622812f47-49fa951b2c6so511412b6e.1
        for <syzbot@lists.linux.dev>; Fri, 31 Jul 2026 03:11:04 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1785492661; cv=none;
        d=google.com; s=arc-20260327;
        b=KOkEUMm4CpYhaWrY0vAf8qMMQaTlVaWBDsM8VQYaGlABN8dydcEK+FsMXMu13hlv42
         BbfS5NnwegXrpIA5MHMHrn1N78LHWxUMuWqqzg9hjqbPFKqEW67JQ2zoxp9x4MwowpII
         a3nyluSZoOqNTEBt7y/vxyaxMNPhMp4pgjiZoglS4/XWaGoFJgmfrsVn3O7dMc4dxY6+
         I7mYkaIk7gU903x9l4sP8R66lK6bXQttzvKOD+A2l4GSwWG0QDVUCzsL0XEj9px//dWy
         TNG3vqu4o+U90zP3+zsQZHfQvCbGfgdszf7oSdP/R9UQ33l6rmjFvLZF1L+WwoOpHTIl
         L9Hg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=sblFT3dEsVIGs6qmguUMjprVItGIvy/4picQ0nRJevw=;
        fh=VtIczgQKL3ostBV43tDbwSOaXgyKEu4KzRv79ezn3HI=;
        b=gQyQ9fDrCQGmEyhut2MX45XbPUzURSBIJlXmnbm5d+maerz5yljwzIETeeGpCRHHf/
         bHg61yYuSp7HNT1wU4me9/H6EqC+uHP6XxsPwRhxoslO7GMHO6Ga2zFQJz/82pYL3Uro
         ioMNgCAXeHbbMeAXWyr25MUIpKfKqR69dQshUEZqLaQXlkarzxtAKCSxVo4yb9vY0QUl
         N4gSB1S/tddaZO0XwzMdFHIBbZU3+1EQjHhnTPt405Flp++dYjao89h+lRA7htvA8P4U
         f63OpywBXT407Wsv+lnV0mP7ezW/23OcM5e24ZMEVUbgyk9HYcH7Xk6rf3msOaT3dEm1
         x2HQ==;
        darn=lists.linux.dev
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1785492661; x=1786097461; darn=lists.linux.dev;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=sblFT3dEsVIGs6qmguUMjprVItGIvy/4picQ0nRJevw=;
        b=rmw7+eneHNrXmcuyAvqK030EiAlu84OJk2rqkUIBevl8anhzsDPYArxnEICqhn8omr
         m+9LSBDNfieXXuhEoPiSrGJAFF+F1czREpCJwZ5KEk/+Xx/iOnwFIrwzQ5Pljxfs5vSH
         ZtqhZdhIlNujfw+u31OtzH53SF6zhjxDbvndj58JqxCN1X1ya+3QckAmtA2O3maa8ONY
         JDqT94W0NUxeXYk3y3LTi4/nmQbyWmkSSUl3R8vP5qPkMgAzKtqLfCPtl66AVFGkLahb
         iADZO+SbzwlkjdmoGpRn+DRMAx7J6pf249qHXgKPYtpPUJGpxxDBp7fTL6v2q+reE0Or
         RzQQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1785492661; x=1786097461;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=sblFT3dEsVIGs6qmguUMjprVItGIvy/4picQ0nRJevw=;
        b=cPgS+q55qPGgVcISqk6iKBgKvfkIFZSHxjeS9RrHAGv+p5WcSEU45RjAszr1ZtgOX8
         s2TkyfDTVbccQ1QgiJ+KZC8taRYwxbLcIBvatL1iiWSHdy/DPrPNCveUSDrB5ydHlbdk
         ICD/IuMEDgNVVvYwRf3wOLi9dUQGymu/EbaIWokcLRjKu+atTuWe0ZUAHTspnLZqk5BY
         yscihyAnzByBTPjunLm7C2Gh2v2gzjIqe1LGe6g816YJ3Cn/bkrGUK2Ti9TvMC51Yyaq
         Atltks1QB5lAYDZZqSwZp4zLQJANWcOs4gf+BLvU9GUCeTupHxRT1SCF3greXFKXQE/j
         8KDg==
X-Forwarded-Encrypted: i=1; AHgh+RoHxqm+D4Kf7cpesty/rp3EWYeU5H6UNOYwlGh4VB3OAVUTdgbP/A7sslJ2MnbHu2jNMDmlXNE=@lists.linux.dev
X-Gm-Message-State: AOJu0Yz6GqJLpc4nMCOy9aOnmyd8x3DbM8bNYep5T1SU8cx35GxZao53
	0ImPMrUXfNhf+7Ad37MTpstr4pmS9ynLbkcdxonpVjqrXBUeZrNBUglIYDy4OjTjpRMYFAPn3jF
	stkZypo6Q8jvO/gPGSfrZIETvrbzZWbLcxHOjEuE3
X-Gm-Gg: AR+sD105xfP8XZeM2nle7M9GJxjx7SB9Cgp+C0zVsnx6lV7t3iKTSNuOi8RDbAjCV+J
	aHczksr6BMRgvzzD3PWsih4UcY2KkZpj26f72BDFXqzp4bAzDp8m1g7RBiaTEcGElsUabsJn2Dw
	e+a/fm/Yq2bqm7YxjYxNuLSfjvdz+l1+fhjgsIpv5QNgoE2SSUIjocng9aWt9WwPNGsB/cdxbLo
	+rVNv76zPi4rN8BcDAdFvpW5Z7bd952r0e+JwK9CsRq4+Hxw3tnQrFNlyc9LpmD90v8/4WEi9mi
	e6n2fild34yyibOojgAHD53z+HYARVzFG0s+cUdzzezMDrya6fxUfz6/DWHmfuZqyX/5fJf3mk3
	gh1dq1ZxBTr58UGYTpb7vyjo3Rh9yB3TqtGL1eYsn3c45IqhzOukJs/X6UCmuPqqMc+bpN6SK8L
	VpmDzm2Uxlx/FQTL2WVI70+rc=
X-Received: by 2002:a05:6808:2507:b0:495:e997:528d with SMTP id
 5614622812f47-4ae4c3d5b2dmr1305824b6e.3.1785492661060; Fri, 31 Jul 2026
 03:11:01 -0700 (PDT)
Precedence: bulk
X-Mailing-List: syzbot@lists.linux.dev
List-Id: <syzbot.lists.linux.dev>
List-Subscribe: <mailto:syzbot+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:syzbot+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <19c83890-3da4-471c-bbca-8d873b803586@mail.kernel.org>
In-Reply-To: <19c83890-3da4-471c-bbca-8d873b803586@mail.kernel.org>
From: Aleksandr Nogikh <nogikh@google.com>
Date: Fri, 31 Jul 2026 12:10:49 +0200
X-Gm-Features: AUfX_mxm5u_qtqDfrkJW3MvYxrwuo0Df2HcDC_SqBqNvjglPnEmST3EoZ12WQCM
Message-ID: <CANp29Y5Q-NdjxbSdq_ansUzpFqPaLEv+Wdp7rL5YwN-qwWtsMA@mail.gmail.com>
Subject: Re: [PATCH RFC] usb: atm: cxacru: properly kill rcv_urb on error in cxacru_cm()
To: syzbot <syzbot@kernel.org>
Cc: syzkaller-upstream-moderation@googlegroups.com, syzbot@lists.linux.dev
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

#syz upstream

On Fri, Jul 31, 2026 at 9:54=E2=80=AFAM 'syzbot' via
syzkaller-upstream-moderation
<syzkaller-upstream-moderation@googlegroups.com> wrote:
>
> If cxacru_cm() encounters an error while submitting or waiting for snd_ur=
b,
> it aborts and returns the error without killing the already submitted
> rcv_urb. This leaves the rcv_urb active.
>
> When this happens during initialization (e.g., in cxacru_atm_start()), th=
e
> driver may ignore the error and proceed to call cxacru_poll_status(), whi=
ch
> invokes cxacru_cm() again. Attempting to submit the still-active rcv_urb
> triggers a warning in usb_submit_urb():
>
> cxacru 1-1:1.0: send of cm 0x84 failed (-104)
> ATM dev 0: cxacru_atm_start: CHIP_ADSL_LINE_START returned -104
> ------------[ cut here ]------------
> URB ffff88812658d200 submitted while active
> WARNING: drivers/usb/core/urb.c:379 at usb_submit_urb+0x79/0x18b0
> drivers/usb/core/urb.c:379
> ...
> Call Trace:
>  <TASK>
>  cxacru_cm+0x21a/0xf10 drivers/usb/atm/cxacru.c:631
>  cxacru_cm_get_array drivers/usb/atm/cxacru.c:722 [inline]
>  cxacru_poll_status+0x178/0x1110 drivers/usb/atm/cxacru.c:828
>  cxacru_atm_start+0x185/0x360 drivers/usb/atm/cxacru.c:814
>  usbatm_atm_init+0x144/0x3a0 drivers/usb/atm/usbatm.c:927
>  usbatm_usb_probe+0x15cb/0x1db0 drivers/usb/atm/usbatm.c:1178
>  cxacru_usb_probe+0x17f/0x220 drivers/usb/atm/cxacru.c:1370
> ...
>
> To fix this, ensure that rcv_urb is properly killed if cxacru_cm() aborts
> early. We can safely call usb_kill_urb() on rcv_urb in the error path, as
> it is safe to call even if the URB is not active (e.g., if it failed to
> submit in the first place, or if it already completed).
>
> Fixes: 1b0e61465234 ("[PATCH] USB ATM: driver for the Conexant AccessRunn=
er chipset cxacru")
> Assisted-by: Gemini:gemini-3.5-flash Gemini:gemini-3.1-pro-preview syzbot
> Reported-by: syzbot+c9dff578c3a41775176a@syzkaller.appspotmail.com
> Closes: https://syzkaller.appspot.com/bug?extid=3Dc9dff578c3a41775176a
> Link: https://syzkaller.appspot.com/ai_job?id=3D75fec6f2-c8a6-43b1-b184-4=
d26baba86cc
> To: "Chas Williams" <3chas3@gmail.com>
> To: <accessrunner-general@lists.sourceforge.net>
> To: "Greg Kroah-Hartman" <gregkh@linuxfoundation.org>
> To: <linux-atm-general@lists.sourceforge.net>
> To: <linux-usb@vger.kernel.org>
> To: <netdev@vger.kernel.org>
> To: "Duncan Sands" <duncan.sands@math.u-psud.fr>
> Cc: <linux-kernel@vger.kernel.org>
>
> ---
> diff --git a/drivers/usb/atm/cxacru.c b/drivers/usb/atm/cxacru.c
> index f1900c567..429ac20a8 100644
> --- a/drivers/usb/atm/cxacru.c
> +++ b/drivers/usb/atm/cxacru.c
> @@ -700,6 +700,8 @@ static int cxacru_cm(struct cxacru_data *instance, en=
um cxacru_cm_request cm,
>         ret =3D offd;
>         usb_dbg(instance->usbatm, "cm %#x\n", cm);
>  fail:
> +       if (ret < 0)
> +               usb_kill_urb(instance->rcv_urb);
>         mutex_unlock(&instance->cm_serialize);
>  err:
>         return ret;
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
-upstream-moderation/19c83890-3da4-471c-bbca-8d873b803586%40mail.kernel.org=
.
