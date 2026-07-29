Received: from mail-oi1-f179.google.com (mail-oi1-f179.google.com [209.85.167.179])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C9F713AEF2F
	for <syzbot@lists.linux.dev>; Wed, 29 Jul 2026 09:15:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.167.179
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785316514; cv=pass; b=I86vXbugKwIAyth12BJ969ysG2gkrWzaZicO0an4w0IlMybm/r3ltAS82WrwU5NG/+hd6fs75sWzc43lbOvTqsCCTpdYCSra6VbDH+i1oRcIOcM5bNwF9Bzm2+KxwI/wEGVqnNt6sbX6brsTwVF+fccBvBhYB19lz8YZkd5Bqk4=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785316514; c=relaxed/simple;
	bh=FfyGEev0H5EXAXE4Oisw3YIAZej6SwXddoK7gp4XAew=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=sHLN3+ppowajzKhcug+QLFFoDZIjShtcaxLRMPIUmVMjiD9iRRyl0KRyYB5NJSPJ2ipcpvYTQNNaLEk1Up6h3rxDf/pzEitxooeAjtKu5EszmX3sBk0XtN6yuZSDtixxtVcoJ6LDDhnLU2gHP1dc2yEjCSK0N6wX7RDnyzZAz8U=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=URxQzdce; arc=pass smtp.client-ip=209.85.167.179
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="URxQzdce"
Received: by mail-oi1-f179.google.com with SMTP id 5614622812f47-497e6956acfso605455b6e.1
        for <syzbot@lists.linux.dev>; Wed, 29 Jul 2026 02:15:12 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1785316511; cv=none;
        d=google.com; s=arc-20260327;
        b=StqhD728GvFc7FFAjfLagZQQ5brKdKoIKeagF6SoRMDq8rxl7eQWn7QYqsAUGc47BG
         HGnGwgW4t0Ii+qnk4pkaKLZNoL/B0eHUaXd0VoRNtfUOERfHmMwfU3vPvOZI8D6G3XgG
         lOJSICyK1tzvdapJfbYtZ2HkdtaZTT+mxCPgSkmq/gfRQuQJTxHb4DBO7JViFLiwUp4A
         nHu0FTjuzliqwlk2cPt+3bY3/LrMFxbhC85xDil5n49X9U2t1V1Yqg0/CiMyqDLbCH4i
         ngHOhBhu5QxRRMSS05/afhmUTzgOjzG3Qn1xxcWWg8faIQxQlCu7qWg4YqK2p4qWB74C
         ZpUA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=q50P28nmQSRlk0nDBeeMM3L9OBr1f/ZN5zr9FcF4PFc=;
        fh=bGAO7zDJC5e+hq1rheor9sPqHBAY1itTaAMfvGQHixE=;
        b=nWjFuYQX/xlQzGCoOd5K2QvPLKIxUs8XiY4VO5cBdXAxgCfRm7bCfCGHs9yTUQsDZ1
         4hZ3H0ZSssRZriqNXjP1vq0yHPo3+3pitJ/dmwcSqifc5Gi+FWyCpSiGkMpBcQYejvCU
         74WpAsXSSGrITjHm+i5lOIQFrraGlL/rxuUu4ONUizLmQhcNTmekYN3Jork8AW8wkvZq
         zsZDI5gyKEc4EMpRKS5VY/ODMqET4nz9uD/Jwvnj7P3PpfN/1Nd8CAxCuO61G0zLwVe4
         JLHhxB9k+QLd1um7ziHALWKCEZzm/ksjSfdE3jk0M2/djMSw95bz7amd0fPQzSwlQeQW
         pRyA==;
        darn=lists.linux.dev
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1785316511; x=1785921311; darn=lists.linux.dev;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=q50P28nmQSRlk0nDBeeMM3L9OBr1f/ZN5zr9FcF4PFc=;
        b=URxQzdcel640gYXMOrjWQRZXI9SbOGoVL+SKhR7s6RHLbpelJe4SkxacvBy+FgynTw
         TlnzfIsbcHok39wn33+FZhqnq2sZcqsBHqcO2qu233v2eiqtko3Bi4b+Oy2b+4YA+xiZ
         cXDO/vWR0SfZfLTOrYhhdAKYdWtn5b1FBi0JNhb/eClzlnHCwqdl2kBFOWr14IpDan0g
         5++NQaUNNZVYgFSW90rm+kOM2OuwCeb4EEkq7YK6l9v7mIuhLrsHuIV26SSW7WZM8It9
         wmYDFHU0RjjolS405A63bdaJiIDeGppDFc/rqYaeqB59EnVDCE/UXoWIYLngr36zdbU2
         1eUg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1785316511; x=1785921311;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=q50P28nmQSRlk0nDBeeMM3L9OBr1f/ZN5zr9FcF4PFc=;
        b=Az40jsXyoOIZquv+6cStejMj82E/xVffzfLpG9m2Sm/XLHqKlckFJ48Qo4x05Nh40s
         qPhfooIWfqzDLzGjVNppLG5LFZhbaaWPBkl/fQVKovc1YxwpJ0jEpoXyBTRlXwzK74jo
         lWrYVSOSMjwVi075OhSBhEHyYc97mp27TyvBEh7DsvbizxrSkMmaTLfjZLAZ1O0nDfJ2
         qTUFOJ7q4uLn4HAz3kSnwsBWcSFHDLVh839hFB03e8RBK+m4xgWMmBQ9HxYpirmgtwFm
         bpZ+AfGiwfZX1WMMVz4/9gXiJG0uXs/IBMjt5nKCYKPY9A4BUTxXAs7AQzePTWl+jUe5
         jIvw==
X-Forwarded-Encrypted: i=1; AHgh+RqXF0usE2VV8/Wiu0r/W+IYQzrbXGTDBapzSOIoubRWH5WgCYsSpGSVJ6uAZTjmFr/MuvpMtsQ=@lists.linux.dev
X-Gm-Message-State: AOJu0YzI8Mhn7lTeHoPx2l5/zEQl/xpuDQEbS7motpCVtL7JDGCYhtKy
	pg5BYrGqbRPrbkPb370ymiPGj13ATbiIwSaSDc55KZgbaxrcM6K1dTLZcOvf1KSrHOOVsiXtMBF
	VA3eVgLR87B/Sqi4izfMtsHD0Ujrx+sLBvoVwYWSV
X-Gm-Gg: AR+sD12nVJom0h35OgYV9ZKs0yS1blT2inviFaKR+QIlM5YaB54QVtYA9PIomGTXPRP
	rDpW+lC+IEGVlcKgfGoBKU4IjZnxAH9iu6lG/b+LTUrXou52ZaQnTdIRmZYfu4kId/OTohf2sFJ
	15ZFCYM2xwgR+rJdfr3CWwaCO4Dn8jregFP4QQ2jbWJO8rSqtjiHLwaKnb51gRpVMdm5So3hG0I
	2dmVQNfYF0d6nmKhkec1RPQ98jHm68DOlvUZ5ciT2/qXUygJIVARTM77fpzyKRIQ7Htse946/It
	Z5HveyDW/RVv/Wg9XRZXDKqP2Z3Zoy6K5XZ2IQ2b0aIlKFZTqiUw8LQi6fNmtf0TYTUmPpcJVNM
	8fZUxPhvbr9Tj4KpmZN2GiJVtGV0Iw4MZYoP/qzvcw1NgIaXSQE4DEL4hLP4pUmjpsMHImrUHjs
	aFvt96/19wrAz4txZhbcF/gKE=
X-Received: by 2002:a05:6808:130a:b0:495:f697:92d9 with SMTP id
 5614622812f47-4ad730cedf9mr636790b6e.7.1785316510785; Wed, 29 Jul 2026
 02:15:10 -0700 (PDT)
Precedence: bulk
X-Mailing-List: syzbot@lists.linux.dev
List-Id: <syzbot.lists.linux.dev>
List-Subscribe: <mailto:syzbot+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:syzbot+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <a265f64a-bbf1-4c1c-b1d6-d1d79f78e228@mail.kernel.org>
In-Reply-To: <a265f64a-bbf1-4c1c-b1d6-d1d79f78e228@mail.kernel.org>
From: Aleksandr Nogikh <nogikh@google.com>
Date: Wed, 29 Jul 2026 11:14:59 +0200
X-Gm-Features: AUfX_mw5n0D2OO_XGFwsXehV0yHAYzPsxqwCuaxY_nJEN4nLd6kYKMbRXgpdAgg
Message-ID: <CANp29Y594kQjh-XyqzK0oB-RnM72gG2YpOOsZ_QJU+AidJYO9A@mail.gmail.com>
Subject: Re: [PATCH RFC] usb: usbtest: fix NULL pointer dereference in usbtest_probe
To: syzbot <syzbot@kernel.org>
Cc: syzkaller-upstream-moderation@googlegroups.com, syzbot@lists.linux.dev
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

#syz upstream

On Wed, Jul 29, 2026 at 10:26=E2=80=AFAM 'syzbot' via
syzkaller-upstream-moderation
<syzkaller-upstream-moderation@googlegroups.com> wrote:
>
> The usbtest driver relies on the driver_info field of the usb_device_id
> structure to hold a pointer to a struct usbtest_info, which contains
> necessary configuration for the device. When a new device ID is dynamical=
ly
> added via the sysfs new_id interface without specifying a reference devic=
e,
> the driver_info field defaults to 0. When the USB core binds the device
> using this dynamic ID, usbtest_probe() unconditionally casts the 0 to a
> pointer, resulting in a NULL pointer dereference when attempting to acces=
s
> the autoconf bitfield (at offset 0xa) of the struct usbtest_info.
>
> This leads to the following crash:
>
> Oops: general protection fault, probably for non-canonical address
> 0xdffffc0000000001: 0000 [#1] SMP KASAN NOPTI
> KASAN: null-ptr-deref in range [0x0000000000000008-0x000000000000000f]
> RIP: 0010:usbtest_probe+0x522/0xcc0 drivers/usb/misc/usbtest.c:2822
> Call Trace:
>  <TASK>
>  usb_probe_interface+0x653/0xc60 drivers/usb/core/driver.c:396
>  call_driver_probe drivers/base/dd.c:-1 [inline]
>  really_probe+0x254/0xae0 drivers/base/dd.c:706
>  __driver_probe_device+0x1e8/0x360 drivers/base/dd.c:868
>  driver_probe_device+0x4f/0x240 drivers/base/dd.c:898
>  __device_attach_driver+0x270/0x410 drivers/base/dd.c:1026
>  bus_for_each_drv+0x258/0x2f0 drivers/base/bus.c:500
>  __device_attach+0x2c4/0x450 drivers/base/dd.c:1098
>  device_initial_probe+0xa1/0xd0 drivers/base/dd.c:1153
>  bus_probe_device+0x12a/0x220 drivers/base/bus.c:620
>  device_add+0x7d7/0xb80 drivers/base/core.c:3772
>  usb_set_configuration+0x1ad8/0x2180 drivers/usb/core/message.c:2268
>  usb_generic_driver_probe+0x8d/0x150 drivers/usb/core/generic.c:250
>  usb_probe_device+0x1c3/0x3b0 drivers/usb/core/driver.c:291
>
> To fix this, validate that id->driver_info is not NULL before proceeding
> with the probe. If it is NULL, gracefully return -ENODEV. The check is
> placed before any memory allocation to avoid unnecessary work and simplif=
y
> error handling.
>
> Fixes: 733260ff9c45 ("[PATCH] USB: add dynamic id functionality to USB co=
re")
> Assisted-by: Gemini:gemini-3.5-flash Gemini:gemini-3.1-pro-preview syzbot
> Reported-by: syzbot+7e1e5911f9eac50bedc7@syzkaller.appspotmail.com
> Closes: https://syzkaller.appspot.com/bug?extid=3D7e1e5911f9eac50bedc7
> Link: https://syzkaller.appspot.com/ai_job?id=3D9e476ca5-99d1-47d2-b9d1-f=
3b501897179
> To: "Greg Kroah-Hartman" <gregkh@linuxfoundation.org>
> To: <linux-usb@vger.kernel.org>
> To: "Greg Kroah-Hartman" <gregkh@suse.de>
> Cc: "Kees Cook" <kees@kernel.org>
> Cc: <linux-kernel@vger.kernel.org>
>
> ---
> diff --git a/drivers/usb/misc/usbtest.c b/drivers/usb/misc/usbtest.c
> index 98071b25a..6410b3e26 100644
> --- a/drivers/usb/misc/usbtest.c
> +++ b/drivers/usb/misc/usbtest.c
> @@ -2786,10 +2786,13 @@ usbtest_probe(struct usb_interface *intf, const s=
truct usb_device_id *id)
>         }
>  #endif
>
> +       info =3D (struct usbtest_info *) id->driver_info;
> +       if (!info)
> +               return -ENODEV;
> +
>         dev =3D kzalloc_obj(*dev);
>         if (!dev)
>                 return -ENOMEM;
> -       info =3D (struct usbtest_info *) id->driver_info;
>         dev->info =3D info;
>         mutex_init(&dev->lock);
>
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
-upstream-moderation/a265f64a-bbf1-4c1c-b1d6-d1d79f78e228%40mail.kernel.org=
.
