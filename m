Received: from mail-oo1-f41.google.com (mail-oo1-f41.google.com [209.85.161.41])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2BDD0336881
	for <syzbot@lists.linux.dev>; Wed, 12 Aug 2026 11:36:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.161.41
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786534591; cv=pass; b=nDY2h0PYFrM1s0aRBsm0nXxyhRAL2RFfczv1chftjomsPcF8tUJSYrLiDav92bt4Mg4OdHtpKGUhK5g7td96ft/ueCQH6h9dO6rA1kBQ2byTrox+vITPfTG5RUKuEKhlqot74XXf9FTmRoF+36bg8yQK+l0yEu+KmlFaTg1zHis=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786534591; c=relaxed/simple;
	bh=q/6h8mxOBA59dDgpPQksu2SKxrdiK9G3hPcDOBimiYU=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=PKHQNBAsRlCIrBpt1RWwUAD0/uH052yWRKJJ8JNxOQpp065o8oVQeCm95UhiVSB5SAXfq4k1i6lDD3TuBwGOdSGLJ3lHvYj7dH1vO13DEDqEjZU4eIm2MamieUJ2ZPlfMAuHeoZkeiQiiZecTZLW7SisfBbp4HFDrqJvJjTB5W0=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=na8c8lQX; arc=pass smtp.client-ip=209.85.161.41
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="na8c8lQX"
Received: by mail-oo1-f41.google.com with SMTP id 006d021491bc7-6acbf97e9a1so500270eaf.1
        for <syzbot@lists.linux.dev>; Wed, 12 Aug 2026 04:36:29 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1786534589; cv=none;
        d=google.com; s=arc-20260327;
        b=m5fuBqfxAxdfOMlEzc1aR2gznng+y6GBH5rCP9wB1g4vHBntI9+S+Hmp3ZDxA9I5+t
         KkqOEusCqHqGdEyKpeBjV5WftNUuy1pjHlEvkfNs7CMYey8wNhVvw1s2Trkc79Y/YbT0
         Hrh5+ohcj/bGaiPDayoKlWM1NBB6+xe7yk92ImTQayIb7i6AxNYP6TFzhPYNHKQf0vSH
         7slbpyGloKQkvYj+QgkK1yalqqxDYMKBMRJoCUltX9JKJlAibyFK/Ot96Z0xPBkBm1tc
         ML/oSBjYLWGOHV5taoC6RWFGsgwkdXUFVBoCXTFx3hRxmVM8tz7M30GEFxguVXuIS+/i
         gwxw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=XwC/UaxnifFe9FwzzZuoQZkMoYwyN5Bt5HbnYRSq14s=;
        fh=Ir8DcQTpEUlJUfKii1kwXvpjo7JCnNlAB41lUudIRRg=;
        b=SCRpYLrEFMIXq5e44y/hHwUvCi2yytiJu/NCkqmZzqMI63HRp7iSIY3ie/284q51t6
         lSL1pvj+qVAxKRO/YvV/mOzljxoS+V/ZRuv+Q3RdTtZCdTgz9OizaK7HhGPnd5pyeRAn
         8O9bzTSTHQ475HKycktWQcHRq4hBSTdXsQ9NEhK8K9zo7tsoKR8vurCb0qrH4dk3MtP0
         2eOhUs8/VRQMjMFnYUlaBJDHEjw5I3mSzUYicsjuhK0KgqYj02fsCxc+6KiGut6DLeCb
         LqPlsNQLOIF/EL0uN3aGIWGIW0R3WoFqvVD7SjGqbNcBStlKQKyf9yweAmHjwn2K9fbE
         vyig==;
        darn=lists.linux.dev
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1786534589; x=1787139389; darn=lists.linux.dev;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=XwC/UaxnifFe9FwzzZuoQZkMoYwyN5Bt5HbnYRSq14s=;
        b=na8c8lQXaJDO6OSBWsy4WCt8b8NrRCF4wKj8/Lm2JoFjpy2anPnBF5FQSmoLGYU6se
         Qc1u54RI5zARX1Ma9Kuu7jhgPPVJm7lJmMOzanwEgHXxybCuRRihD3hnQ/XTCPbWD567
         AHEU43BUutElP0wkFLx5tSEzVpQG8r10WDrgPv/BqkzY8hMc7ogRwMPCzzkY2yW+VkIU
         46TBlusWftDvz6z2WWmrDQAgoyth+w5u8lTJaVOvrNHHC7A8zDYMl1skvbtgVeoIjEbO
         aWD4tafm248YllhPl6Vm0PJo0nkhobq/BbY/IIL4FPmL3EiMTyp/NkJMzghRbAUOKbSq
         c1yw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1786534589; x=1787139389;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=XwC/UaxnifFe9FwzzZuoQZkMoYwyN5Bt5HbnYRSq14s=;
        b=E2NKAT9sDuZzsnKawGI7npHy53V3oFxiB3GmK+wNdgJusHKmSQPLhKntElm0bHdj3V
         bZH+/n0mc6SLL00lyylpfC1hFgB9yLqbMzL3H640I+O+hllRWUeu/N0N+SKafPd5TkId
         5C94DW4EwRy+Bc1ZI35zoCPat4AIhsFNA0kaiHi+ABuD1AJLv3g93/3k3N2QqO21rKFb
         aGeZhnvMulRovzXBi1K9i4fNBUNJmYx449rBEWNSHtOVgbMrcQLNODmptvV2cy366A6C
         teu2DjzcUa1gfjw24tUNZlZ49y94rF3CXvvi6y6IRzGss24W68HiFnmFdUDM09S25Oxi
         oYuw==
X-Forwarded-Encrypted: i=1; AHgh+RrP8pItq7fsHVwdYy/zjbz0JpfqSDMEBNHVxj79xJCsr26dnj0yw6YInne78jXfJQJmXXxm2qk=@lists.linux.dev
X-Gm-Message-State: AOJu0YxHivWAN8ZAoocczJqeHvMyb+3s5DlRlsvHzJdbs1IWFHR7ClGn
	dHlEfY9BBpNUzMM845t8rZ+96Sa1sYBn3mRqdq6go8DrmRBLdKeeQ65WV7y/ShC1+Y6vC3mthjB
	vvPmSr9gykHY3flRPJTZ+9kVVF0CnRJ0Vv2odW+w67ELjJKPShURq5/Awn/Q=
X-Gm-Gg: AR+sD11mqHrHfyRTq9n43/2MJfE4/L10+8MUH0eawpyPqhHU7F/Oi1W3UKv/Bo1bv4g
	fjvD8Przr/a+xm+TU1jNBYFWhnipbKE4OCGADDSIQWaTCyemdfinGv80VPBz+uMbv6Gyiza1bSl
	8G631eMxJIrJmgimBPaREH1XIwgcaYHCUrT/iDa6o+4p2603ScDmb1MhT9j+kFSFO3MkZHKocvT
	bBCuQgzQblXJgkNL1IPItxc82Js3AeZQ2VWDTTRvr9QFy0DKYrNAxCS8gKZYCN28zQfYT+X/mrA
	moBdJPHIHl6jjYTTlXc7KlOZW9pT/TMDOJWcXSID8UYI0mJz6hX/aCMfOpPqCXFdAw+/K4GRzyy
	nQ8QZT07qpOLIDQEUcJK9vuKdt4Bh41Mmea3/fET1tYGorOULvLbki1zvitRVEP7KKF2cwJiSMK
	bAtzRV7mMvjg6jm7GpM5xYwjA=
X-Received: by 2002:a05:6820:3088:b0:6aa:e573:9ce0 with SMTP id
 006d021491bc7-6b0b2673f66mr3677020eaf.16.1786534588390; Wed, 12 Aug 2026
 04:36:28 -0700 (PDT)
Precedence: bulk
X-Mailing-List: syzbot@lists.linux.dev
List-Id: <syzbot.lists.linux.dev>
List-Subscribe: <mailto:syzbot+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:syzbot+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <f345b3ad-4dff-4a90-8a9e-672979e4a8ba@mail.kernel.org>
In-Reply-To: <f345b3ad-4dff-4a90-8a9e-672979e4a8ba@mail.kernel.org>
From: Aleksandr Nogikh <nogikh@google.com>
Date: Wed, 12 Aug 2026 13:36:17 +0200
X-Gm-Features: AUfX_myleEE0pByerKBFIzjv0ZPOJqhToPFe5KAhjUX1Np0_bipKXgxkgdMk5j0
Message-ID: <CANp29Y6hUUYBGYsgL2A6jFJH+cpiEhsm+ChgDw+D13OkL=aopw@mail.gmail.com>
Subject: Re: [PATCH RFC] usb: gadget: uvc: check endpoint enabled state in uvcg_video_enable()
To: syzbot <syzbot@kernel.org>
Cc: syzkaller-upstream-moderation@googlegroups.com, syzbot@lists.linux.dev
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

The fix papers over a different problem.

1. Validate state in uvc_v4l2_streamon() to prevent completing the
setup handshake out of turn.
2. Check `!video->ep->enabled` / `!video->ep->desc` in uvc_video.c to
guard against concurrent USB disconnects/resets during request
allocation.

On Tue, Aug 11, 2026 at 11:16=E2=80=AFPM 'syzbot' via
syzkaller-upstream-moderation
<syzkaller-upstream-moderation@googlegroups.com> wrote:
>
> A NULL pointer dereference can occur in uvc_video_prep_requests() if
> userspace issues a VIDIOC_STREAMON ioctl before the USB host has fully
> configured the streaming endpoint.
>
> When userspace calls VIDIOC_STREAMON, the driver handles it in
> uvc_v4l2_streamon(), which in turn calls uvcg_video_enable(). Currently,
> uvcg_video_enable() only checks if the endpoint pointer is allocated
> (video->ep =3D=3D NULL), but it fails to check if the endpoint is actuall=
y
> enabled (video->ep->enabled).
>
> The endpoint descriptor (video->ep->desc) is only assigned when the USB
> host explicitly selects the streaming alternate setting via a SET_INTERFA=
CE
> control request. If userspace prematurely calls VIDIOC_STREAMON before th=
e
> host has selected the streaming alternate setting, video->ep->desc will
> still be NULL.
>
> Because uvcg_video_enable() does not verify the endpoint's enabled state,
> it proceeds to call uvc_video_alloc_requests() and then
> uvc_video_prep_requests(). Inside uvc_video_prep_requests(), the code
> unconditionally dereferences video->ep->desc, resulting in a KASAN
> null-ptr-deref / general protection fault:
>
> Oops: general protection fault, probably for non-canonical address
> 0xdffffc0000000000: 0000 [#1] SMP KASAN NOPTI
> KASAN: null-ptr-deref in range [0x0000000000000000-0x0000000000000007]
> RIP: 0010:usb_endpoint_xfer_isoc include/uapi/linux/usb/ch9.h:571 [inline=
]
> RIP: 0010:uvc_video_prep_requests
> drivers/usb/gadget/function/uvc_video.c:508 [inline]
> RIP: 0010:uvc_video_alloc_requests
> drivers/usb/gadget/function/uvc_video.c:559 [inline]
> RIP: 0010:uvcg_video_enable+0x142/0xe70
> drivers/usb/gadget/function/uvc_video.c:784
> Call Trace:
>  <TASK>
>  uvc_v4l2_streamon+0x7e/0x110 drivers/usb/gadget/function/uvc_v4l2.c:531
>  __video_do_ioctl+0x8af/0xc70 drivers/media/v4l2-core/v4l2-ioctl.c:3133
>  video_usercopy+0x860/0x1430 drivers/media/v4l2-core/v4l2-ioctl.c:3475
>  v4l2_ioctl+0x18d/0x1e0 drivers/media/v4l2-core/v4l2-dev.c:366
>  vfs_ioctl fs/ioctl.c:51 [inline]
>  __do_sys_ioctl fs/ioctl.c:597 [inline]
>  __se_sys_ioctl+0xfc/0x170 fs/ioctl.c:583
>
> To fix this, update uvcg_video_enable() to also verify that the endpoint =
is
> enabled (!video->ep->enabled). This ensures that if userspace prematurely
> calls VIDIOC_STREAMON, the driver will safely reject the request with
> -ENODEV instead of crashing the kernel.
>
> Fixes: 48dbe731171e ("usb: gadget: uvc: set req_size and n_requests based=
 on the frame interval")
> Assisted-by: Gemini:gemini-3.5-flash Gemini:gemini-3.1-pro-preview syzbot
> Reported-by: syzbot+44835f0858f11e3e923c@syzkaller.appspotmail.com
> Closes: https://syzkaller.appspot.com/bug?extid=3D44835f0858f11e3e923c
> Link: https://syzkaller.appspot.com/ai_job?id=3D7c0e5e06-0c49-4143-aeab-5=
a4c53b4bdaa
> To: "Greg Kroah-Hartman" <gregkh@linuxfoundation.org>
> To: <linux-usb@vger.kernel.org>
> To: "Michael Grzeschik" <m.grzeschik@pengutronix.de>
> Cc: "Frank Li" <Frank.Li@nxp.com>
> Cc: "Kees Cook" <kees@kernel.org>
> Cc: <linux-kernel@vger.kernel.org>
> Cc: "Junzhong Pan" <panjunzhong@linux.spacemit.com>
> Cc: "Xu Yang" <xu.yang_2@nxp.com>
>
> ---
> diff --git a/drivers/usb/gadget/function/uvc_video.c b/drivers/usb/gadget=
/function/uvc_video.c
> index 2f9700b3f..d4aeedacc 100644
> --- a/drivers/usb/gadget/function/uvc_video.c
> +++ b/drivers/usb/gadget/function/uvc_video.c
> @@ -764,7 +764,7 @@ int uvcg_video_enable(struct uvc_video *video)
>  {
>         int ret;
>
> -       if (video->ep =3D=3D NULL) {
> +       if (video->ep =3D=3D NULL || !video->ep->enabled) {
>                 uvcg_info(&video->uvc->func,
>                           "Video enable failed, device is uninitialized.\=
n");
>                 return -ENODEV;
>
>
> base-commit: db2ddb87143519e20a95aa36c60b36107b736a58
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
-upstream-moderation/f345b3ad-4dff-4a90-8a9e-672979e4a8ba%40mail.kernel.org=
.
