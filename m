Received: from mail-oi1-f172.google.com (mail-oi1-f172.google.com [209.85.167.172])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 82AF84508F8
	for <syzbot@lists.linux.dev>; Wed, 29 Jul 2026 12:21:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.167.172
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785327715; cv=pass; b=rz6NkJCLhCk6c/gIRkTfwuF56ll6L5bScyMYaMvyq/5358oeG1IufnHg5jlInHwtu097XhxJ4TlUYgVAcaP5PXxM5C7Dti6piqLw9PYGyA/i7tH1MYi0kzJyEB4tIK7dv29Y6gQfphMKDVuMt4/SBpXn2BN6U6Rp3wHFKb7FEFI=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785327715; c=relaxed/simple;
	bh=dyhbTbzXpE4v538ZyWa1GSaNrQDsk1f/ircHokoPerk=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=OyZz5bkCAcnUgroG/3LB7lNyqA32FWLujw5rM1/OWeBbyHsCVH20vmRnrjuJ5UlUomgwp3jigHoND1oR00nShzJAH8jCtfPesVWqm6jfHcYJu6i5bDxELaPotX36pwh63fchB2YuuSKDJRcWwGnV+iIVrUbcfqpOl/S7s/PQjwI=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=VhEXT2+2; arc=pass smtp.client-ip=209.85.167.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="VhEXT2+2"
Received: by mail-oi1-f172.google.com with SMTP id 5614622812f47-497deab2d66so758311b6e.0
        for <syzbot@lists.linux.dev>; Wed, 29 Jul 2026 05:21:53 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1785327712; cv=none;
        d=google.com; s=arc-20260327;
        b=Mf+2nhbZZEZArgB2NKfi+gdEDC1879H+RIsMQBp1EZgVAupaqFnIiEngZGIQaKv8Y/
         wo+Uq/2nAcO+1BbTFbasYDkWPVgDIGIuHegIcLIh7nQ1vP6z8u+hp9eIsvArf4oK692v
         ZMqOXGw+OW1msol6qyjkITQhowfKtcL1FAnFf8otBvxXMGcVRlMlWSEmU+RuNqsVfyFF
         TihoILAbMTNzU3VH5oh3lA3+Mvon3plWaQDe1WMVgJyhyOw6XzglKs0ncH94eWqX28Bx
         JwPT1cGrObW0QmCLjFKu3EpsvqyhP5KNt48K7xWdLXr9mvDKSlEX44JCRbkCc+PWJcau
         tsAw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=iqKksYjXXpYEqYOx6kdzbVD2Qf1At08svC/LeNlSrew=;
        fh=lmvD8xskP2DnBoaFZI9BkIjNHCeXQJpzfkuX+fwU3Yk=;
        b=VQOJ8vEN/4ojMvYpYUL7znTghmLi6eDcjziNAvZC+Ow3R1IgttCdKAw6oecHp/+QQ7
         N9AuNJqoCxsY646qdZ80jfLuB+7QNmTj/LgACO2e0sQ+55Pxs0Pj/pA5jL+58Jeeje2a
         kcs8wHOrB2sybu3d+ihTXcK8MgOScnhwo+s2A549lGbWfCKrEWARNPncH7ePi2kcXPGk
         9b+CVhniEfh/EoS9+3NLro4TFY3wSFUORPQqKyWXj23fx11kWHIKgVkXzKp3f2M99JhP
         KLLD+msOrNsZSh3/cMBKWsXSEcFnJr5Syz9PHUfPooqNYqGS33/nnZqDrn1cFYselbDZ
         Rfhg==;
        darn=lists.linux.dev
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1785327712; x=1785932512; darn=lists.linux.dev;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=iqKksYjXXpYEqYOx6kdzbVD2Qf1At08svC/LeNlSrew=;
        b=VhEXT2+2AQrCyQQUwdktcRp526zeMqgzjQ5dmSr6tXp/aXsH+lB7JU6ZU5nuQdHhXB
         1S+o45DmF+BKkgkiriABS5d+g2OKHObWlT3Hfqwzp/7u218Hd1kycMLYkQJYGt2vr75E
         xjaY5I6oZ+5WZw9eBXd+TP+2mfdLa1YcqP3TOx6UQ8P6roXuDyLqBZIZGHXBXqAdKhVj
         H+gQGnq2Os4sy9vIxTjayijbthnSoYk4rdVvN+KCvlK5u/qq2zNbcuuwh56R+FECFU+b
         4DdkSyrAe0XH1VmrBvTz+R2jatodsPwoAbbU0cN/4E1vewe4uFOrtunB5Ok79pIe4fju
         59eg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1785327712; x=1785932512;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=iqKksYjXXpYEqYOx6kdzbVD2Qf1At08svC/LeNlSrew=;
        b=L3AHtRAnrf67vzskcu4dOc3K6myBwcmpR9JKVBp5t/TOE5yPAJalzbbDcAqE8sZOPE
         ICjx6mj9guZrh5890vDiL//lFwH7Dv4hB6cMA/xV1E37hycffRLH0yrvy25vm393qQOi
         DkK9tVJyiXTr6eIKToZ5V9Y0lgkTFhQAt87zgbxSHTya2TAPmtAjZ35r358LCVJ0516F
         Zzlb0gp3giSp9pPwTbZ840fYOLd2ZH5NNo6Zhk/IYkDN9KGfYg7pXyoFuLKMyCYHVBEb
         xW9QzOUhqqD8jb5vkmwaq/E3DxYzAjRnRQieG+c6KzYrKtduH3bu/QD8yO9ejhzXn0iL
         wWcQ==
X-Forwarded-Encrypted: i=1; AHgh+RrL4pFA1k6BiAiSsQcaRm9FVOnQb9f7Izef/2sMOel2KExkUQC+4w76T4sp/3jXQrsHWOSGImM=@lists.linux.dev
X-Gm-Message-State: AOJu0Yzmy3cgKfa2tkbG24RTQzGsLizzKwS8m4ivG/UF2hZjdM6w/dog
	kuGXy2jrRqwgHQ8YxizRIOHAGQLXc4qw3844yFLCvp3duu7uBSoYMKDySkrdA+TFb5zZptT0VxN
	np4XHVGkUjgH4Ffh1G8fBqoMt090BVkpTeurR+Obe
X-Gm-Gg: AR+sD107o2D8gts5j7Z1NfO+0Il9WJvrNW71gBYjkUU4Ih7Uc9tX756G6ca0ZxTQm/d
	HYzVNqTSjWoRw4/elE8KPiYAiahjpypTliIPQiP11jCYWXo5IEoR36uCmt5mAp+35yuZ0yMpT4K
	TLTT7JLauy5IJyqef6AAjuYCdE7PYty1khOGBtSSaykSPvvQlLhOWfAhY4N23AeZUxbxXCQIu5j
	kupA7ws8VQvaA3/cQd7wu831upt5BLg7fVbO2s5+DDtYrEPBGGMx6NfklzO0P/tSrn2jOAkha56
	mlGkUbkHoHLMIKbjZIyXZHhPeu8dOcFbYLnELcmZ7c0XfmaNlwLzy7vznTb8/q2jh9AWozG1mOn
	3oI13HZSlgzOTu2U/miR6vKBkxIQA7EE9lDr1dQjoY8HdKryo1PM98cOSIKm43MGlnoxh45wkNm
	1v7clzJXrRl7exuz8UnJ+dVNTI
X-Received: by 2002:a05:6808:15a7:b0:495:fa67:7496 with SMTP id
 5614622812f47-4ad7332ab54mr1063966b6e.14.1785327711575; Wed, 29 Jul 2026
 05:21:51 -0700 (PDT)
Precedence: bulk
X-Mailing-List: syzbot@lists.linux.dev
List-Id: <syzbot.lists.linux.dev>
List-Subscribe: <mailto:syzbot+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:syzbot+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <ba57a566-316f-4ab3-9a6d-6d0f02a2480a@mail.kernel.org>
In-Reply-To: <ba57a566-316f-4ab3-9a6d-6d0f02a2480a@mail.kernel.org>
From: Aleksandr Nogikh <nogikh@google.com>
Date: Wed, 29 Jul 2026 14:21:39 +0200
X-Gm-Features: AUfX_mxC0-T-zrMFqWdqqJIUxo7vwRvjQamZSBn-R4AvCI8uAOGpCiqzrRpf3UI
Message-ID: <CANp29Y7+G=-sVb1d1iU72KTvZ5K=ad6fG8ZtCucEgv1jpo14Kw@mail.gmail.com>
Subject: Re: [PATCH RFC] usb: gadget: dummy_hcd: prevent unbind via sysfs
To: syzbot <syzbot@kernel.org>
Cc: syzkaller-upstream-moderation@googlegroups.com, syzbot@lists.linux.dev
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

#syz upstream


On Wed, Jul 29, 2026 at 1:47=E2=80=AFPM 'syzbot' via
syzkaller-upstream-moderation
<syzkaller-upstream-moderation@googlegroups.com> wrote:
>
> The dummy_hcd (Host Controller) and dummy_udc (Device Controller) are
> implemented as two separate platform drivers that share the same underlyi=
ng
> state (struct dummy). They are designed to be created and destroyed
> together during the module's init and exit phases.
>
> If userspace forces the dummy_hcd driver to unbind from the device via
> sysfs, dummy_hcd_remove() cleans up the host controllers and sets the
> pointers to NULL (dum->hs_hcd =3D NULL). However, the dummy_udc driver is
> still bound to its device, meaning the USB gadget is still registered wit=
h
> the udc-core subsystem.
>
> If a new gadget driver is subsequently registered, it binds to the
> still-registered dummy_udc gadget, invoking the dummy_udc_start() callbac=
k.
> This callback attempts to retrieve the HCD state using
> gadget_to_dummy_hcd(), which returns NULL because of the unbind. This
> results in a null-pointer dereference:
>
> Oops: general protection fault, probably for non-canonical address
> 0xdffffc0000000000: 0000 [#1] SMP KASAN NOPTI
> KASAN: null-ptr-deref in range [0x0000000000000000-0x0000000000000007]
> ...
> RIP: 0010:dummy_udc_start+0xd0/0x1f0
> drivers/usb/gadget/udc/dummy_hcd.c:1022
> ...
> Call Trace:
>  <TASK>
>  usb_gadget_udc_start_locked drivers/usb/gadget/udc/core.c:1237 [inline]
>  gadget_bind_driver+0x3a8/0x9e0 drivers/usb/gadget/udc/core.c:1667
>  call_driver_probe drivers/base/dd.c:-1 [inline]
>  really_probe+0x254/0xae0 drivers/base/dd.c:706
>  __driver_probe_device+0x1e8/0x360 drivers/base/dd.c:868
>  driver_probe_device+0x4f/0x240 drivers/base/dd.c:898
>  __driver_attach+0x339/0x600 drivers/base/dd.c:1292
>  bus_for_each_dev+0x23b/0x2c0 drivers/base/bus.c:383
>  bus_add_driver+0x345/0x670 drivers/base/bus.c:763
>  driver_register+0x23a/0x320 drivers/base/driver.c:174
>  usb_gadget_register_driver_owner+0xf9/0x270
>  drivers/usb/gadget/udc/core.c:1752
>  raw_ioctl_run drivers/usb/gadget/legacy/raw_gadget.c:596 [inline]
>  raw_ioctl+0x1541/0x41c0 drivers/usb/gadget/legacy/raw_gadget.c:1307
>
> Adding NULL checks to the UDC callbacks is not a robust solution because
> there is no synchronization between dummy_hcd_remove() and the UDC
> callbacks, which would result in a use-after-free race condition if the H=
CD
> were unbound concurrently.
>
> Fix this by setting .suppress_bind_attrs =3D true in both driver definiti=
ons.
> This prevents userspace from unbinding these drivers dynamically, ensurin=
g
> their lifecycles remain strictly synchronized with the module's load/unlo=
ad
> process.
>
> Fixes: d9b762510c18 ("[PATCH] USB dummy_hcd: Use separate pdevs for HC an=
d UDC")
> Assisted-by: Gemini:gemini-3.5-flash Gemini:gemini-3.1-pro-preview syzbot
> Reported-by: syzbot+d270af829aca04e783fc@syzkaller.appspotmail.com
> Closes: https://syzkaller.appspot.com/bug?extid=3Dd270af829aca04e783fc
> Link: https://syzkaller.appspot.com/ai_job?id=3D7a763ada-c07c-458f-9fea-f=
7e913dc1f2f
> To: "Greg Kroah-Hartman" <gregkh@linuxfoundation.org>
> To: <linux-usb@vger.kernel.org>
> To: "Alan Stern" <stern@rowland.harvard.edu>
> Cc: <linux-kernel@vger.kernel.org>
> Cc: "Jinchao Wang" <wangjinchao600@gmail.com>
>
> ---
> diff --git a/drivers/usb/gadget/udc/dummy_hcd.c b/drivers/usb/gadget/udc/=
dummy_hcd.c
> index c0e40fa6d..415096835 100644
> --- a/drivers/usb/gadget/udc/dummy_hcd.c
> +++ b/drivers/usb/gadget/udc/dummy_hcd.c
> @@ -1180,6 +1180,7 @@ static struct platform_driver dummy_udc_driver =3D =
{
>         .resume         =3D dummy_udc_resume,
>         .driver         =3D {
>                 .name   =3D gadget_name,
> +               .suppress_bind_attrs =3D true,
>         },
>  };
>
> @@ -2802,6 +2803,7 @@ static struct platform_driver dummy_hcd_driver =3D =
{
>         .resume         =3D dummy_hcd_resume,
>         .driver         =3D {
>                 .name   =3D driver_name,
> +               .suppress_bind_attrs =3D true,
>         },
>  };
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
-upstream-moderation/ba57a566-316f-4ab3-9a6d-6d0f02a2480a%40mail.kernel.org=
.
