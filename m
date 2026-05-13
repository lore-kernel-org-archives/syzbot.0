Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A1A232D8773
	for <syzbot@lists.linux.dev>; Wed, 13 May 2026 13:57:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=10.30.226.201
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778680675; cv=pass; b=mDNwrfaXXCGYtQ1Inz2tA50cA2wbuO5KXVKiTLgndQ3Fc6kmAS+nt2ySTaStVqFuBR2XWnl8YuRL4qk6+m016mYGbi6N9/wPrE2SX0/bP54gTml6FEs6Ht3tL9RmZDOKttSd65j4MYAaHG/jJkDWSD+jCPs1Wdl751H/R+ZNtjM=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778680675; c=relaxed/simple;
	bh=gwflbrVRuzlpKqUu+St7e+/861vdAV6KOZ1HyRcPqSI=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=CY2vNm/0guDhg+tHVoQv765bqIMgReAsny+QtpX5NJK+DcPJ3fTfVhMCSj9KhImuKKlao0MrnkgUyg9EDJ+NxLogVytTOSdiLtQME9WEGP0wcw8ssCaQJlSKeIKFc4h8jsuJi1CsPVkVXX0zWvcDP+8+vOQHjBU0tLUCZuIjQrs=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=SIN1JigX; arc=pass smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="SIN1JigX"
Received: by smtp.kernel.org (Postfix)
	id 54358C2BCB3; Wed, 13 May 2026 13:57:55 +0000 (UTC)
Received: from mail-oi1-f181.google.com (mail-oi1-f181.google.com [209.85.167.181])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp.kernel.org (Postfix) with ESMTPS id 67128C19425
	for <syzbot@kernel.org>; Wed, 13 May 2026 13:57:54 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 smtp.kernel.org 67128C19425
Authentication-Results: smtp.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.kernel.org; spf=pass smtp.mailfrom=google.com
Received: by mail-oi1-f181.google.com with SMTP id 5614622812f47-47c918c62b4so3499818b6e.0
        for <syzbot@kernel.org>; Wed, 13 May 2026 06:57:54 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1778680673; cv=none;
        d=google.com; s=arc-20240605;
        b=YKn9sRe6M3JUs5q2MtwF4OX1PDmQIACd64WVJz8F7ikJHs9Z9XAZq25/AKVs+vbSwp
         A/LjiQjkhNDJRqeB66gbx8jl5Cz3CWta7ixSInjPV9njURwwmm+7nZK+6jAO2neS8IFX
         vnbq87GNYzlazrAt5cvLSsYlO+0Vn/uRvRcaaAjtE8sP0DqwhTUwMPWQ+lyzcqL+/yvc
         N7w+EBdsQblypjgYf96tbvTxYUx9owA75y0NkCVZD0N370LB96Q/6enSVSzjqKHQSuK/
         EiPJfRHmQ3CbnThgTICFcE0eru4sD7Y0Og0nm6iL8ILSwwSba47db6+jjVVAtpx1UT1S
         6Ytg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=5HnsxjmESbGyBoAD5Fw3LufHoRPMivmukj8jl54K2rE=;
        fh=2Ld/g5BVZzBadtquf8mrXl84q+iOtbUed/2ECOFnmmI=;
        b=WRY/bI39CkLoHX3DJIoZZl5nBjk5FpOvk56nJoavd+K6Bi1+qMuHN8s3iKWeh8qi2b
         EySkCqpriauYLHoDhRqYhXVg5oerbOyycdJO73Scuu32eWtVpuwGvfNeUFTz3Sncqu0q
         lvEbItiHWPrF8TK/+lCPpwJ3qx4OY5SRL2UWLLhGOKfWDF29mhRWEefsDJMBgmI3PRPp
         yr/HDu6QrTeLqUFfjEyHy0EC9EvPfg68SW8WGWwipxCKgoMedo2mRuDRJDi2vJ5XSkyp
         IhKYFfpsuOn9gS8b1sgRz0s10pIliq+Zdcw/+HYQi10uXyiTiWjndkvyfG7ahTw7wwI7
         +tUw==;
        darn=kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1778680673; x=1779285473; darn=kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=5HnsxjmESbGyBoAD5Fw3LufHoRPMivmukj8jl54K2rE=;
        b=SIN1JigXWElSAIWYyJ2M49p2c8x+tMflx87EghxOFWnFnApzyY7bfWvzFhJBCHMm2N
         9/FRoxEM8pxocvN8vCDnkfhUFaOmBN9KlrVGjN0CBaZjncp45VFKFW+Ap6ukx3HNsA+N
         KEvnag3z2V4j/luzAZiqrnFnT94tZ5qRwVicICu+psUgxX5DqUL33erWeL8pRzUYdgkp
         PpxYMV00Ac3pJQCcHd1OZkV//ZWmpjhfesXRNuLAeM8PYKGs9HdocqWm1oj1xADgoDR5
         kkUdxqL/eEya2jhawACeZM2YsSlEx2hbqTd9ZRPrn6kf7gRmXQQBMvdxFt/Lte2boH3O
         CbNQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1778680673; x=1779285473;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=5HnsxjmESbGyBoAD5Fw3LufHoRPMivmukj8jl54K2rE=;
        b=BfYat4ytkeqY6PJ2c+Qzlb45AmZ9441dS9LwWKErEYpux0JQEEW6FlprnEBSchXt8J
         KlvzCpVwcv0Wy83TYL1IBEqLOcuEu4uGJ2llQluCn8FTLe9izX8Mh/njeoAzFH/5vHQr
         sAI/azlPjYaefUe6DDzEbRCUK9h1l/EjKP0aHMICnVoWd3mqDknuaEKf/OfZaXUPh4rh
         3ph6ZdzLI/uoZ1Wfao/eK6BZ9l+lCU0eR78HzyYklEA3pjQ07tg/DdQisMAqWSF6v9h4
         fU2xJFROpeMnVRFLzSk7hRmi75FONP5BUxJb2AaSgLdAHRXTJ0bGHUOswQSusjQ4yNbx
         rytw==
X-Gm-Message-State: AOJu0YwXpHnHtESoPR7/VfTMHV6FxhRj6Q1PnWh9H6zrIq1qK+dnlIMq
	+xmTBHeXZNaBRzxY/bUrq9BIZ55M7ktxAHELeXGyhLhiriRThNbGxp8pAmtavU8gcVlfyVSr9X6
	aSKvetQ2FFA4A/qGOcJUuehWpR1DJ9y2tkaxyjZDlouzvHJPHDSPIFHDm18w=
X-Gm-Gg: Acq92OEWw9II2nVmNApjXxLAWU1jLoSPKgd4TCKHKgXpvy1XYjsZOk7MVMVHbXwKTN/
	4GufGFyG2ArD7HidKIKrFx2bpyIHWZ1ZtwBtub8VqPZvmjKHIfLphZdh7v2xdELAcRTsehgX2in
	R/22zs2kNktRE+fZmsXGklBu2H/6914luAkZoBSdTSW3U6SLyUTaHZPcY3Td8NfcSS1d6p/VDZa
	Xr0rAAXsQ0BIWBSh3yOqe5HieP995EUyPrvIKjKbj8mzEZ6bdl2V3IwjvgW3gs0Ivd1JTJOPVUn
	t0EFxEw+jzjxYpGvG2EchoSG+k562FdrkS8ux5LWNutYQuUmT6xt/ZI9cH940X7dJxZEC7yKQHZ
	aN8SD
X-Received: by 2002:a05:6808:1b0b:b0:468:1574:4cc1 with SMTP id
 5614622812f47-482b5cf85f1mr1765704b6e.3.1778680672764; Wed, 13 May 2026
 06:57:52 -0700 (PDT)
Precedence: bulk
X-Mailing-List: syzbot@lists.linux.dev
List-Id: <syzbot.lists.linux.dev>
List-Subscribe: <mailto:syzbot+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:syzbot+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <affecee3-b60c-498b-ae12-99ade5e65f05@mail.kernel.org>
In-Reply-To: <affecee3-b60c-498b-ae12-99ade5e65f05@mail.kernel.org>
From: Aleksandr Nogikh <nogikh@google.com>
Date: Wed, 13 May 2026 15:57:41 +0200
X-Gm-Features: AVHnY4IwdMAm0h4eOPtV89ikdb1Nt1XsTdxCyeKpHtmDcW9tPh5TA1KxR4fpVWM
Message-ID: <CANp29Y4Bp3Havn8Ooyj1YrCxCPtaLG-QWoLjnyUfwf3GxWmMHA@mail.gmail.com>
Subject: Re: [PATCH RFC] wifi: zd1211rw: restrict binding to a single interface
To: syzbot <syzbot@kernel.org>
Cc: syzkaller-upstream-moderation@googlegroups.com, syzbot@lists.linux.dev
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Is it correct to return ENODEV here?

On Tue, May 12, 2026 at 11:05=E2=80=AFPM 'syzbot' via
syzkaller-upstream-moderation
<syzkaller-upstream-moderation@googlegroups.com> wrote:
>
> A malicious USB device with multiple interfaces can trigger a lockdep
> warning about a possible recursive locking deadlock in the zd1211rw
> driver.
>
> The driver lacks a check for the interface number in its probe function,
> allowing it to bind to all interfaces of a matching USB device. During
> probe, the driver calls usb_reset_device(). If the device has multiple
> interfaces, usb_reset_device() invokes the pre_reset callback for all
> currently bound interfaces. Because pre_reset acquires and holds
> &chip->mutex, calling it for multiple interfaces sequentially causes the
> task to acquire multiple mutexes of the same lock class, triggering the
> lockdep warning.
>
> Real ZD1211 Wi-Fi dongles only have a single interface (interface 0).
> Binding to multiple interfaces is a bug that not only causes this
> lockdep warning but would also lead to functional issues if the
> interfaces share endpoints.
>
> Fix this by rejecting any interface other than 0 at the beginning of the
> probe function. This ensures that at most one interface is ever bound to
> this driver per device, preventing the recursive locking scenario and
> underlying functional bugs.
>
> Fixes: e85d0918b54fbd9b38003752f7d665416b06edd8 ("[PATCH] ZyDAS ZD1211 US=
B-WLAN driver")
> Assisted-by: Gemini:gemini-3.1-pro-preview Gemini:gemini-3-flash-preview
> Reported-by: syzbot+0ec3d1a6cf1fbe79c153@syzkaller.appspotmail.com
> Link: https://syzkaller.appspot.com/bug?extid=3D0ec3d1a6cf1fbe79c153
> Link: https://syzkaller.appspot.com/ai_job?id=3D81d3d19a-926e-45c1-a50d-0=
98739716a84
> To: <linux-wireless@vger.kernel.org>
> Cc: <linux-kernel@vger.kernel.org>
>
> ---
> diff --git a/drivers/net/wireless/zydas/zd1211rw/zd_usb.c b/drivers/net/w=
ireless/zydas/zd1211rw/zd_usb.c
> index 966d8ccb0..968fa338f 100644
> --- a/drivers/net/wireless/zydas/zd1211rw/zd_usb.c
> +++ b/drivers/net/wireless/zydas/zd1211rw/zd_usb.c
> @@ -1353,6 +1353,10 @@ static int probe(struct usb_interface *intf, const=
 struct usb_device_id *id)
>         struct zd_usb *usb;
>         struct ieee80211_hw *hw =3D NULL;
>
> +       /* ZD1211 devices only have a single interface */
> +       if (intf->cur_altsetting->desc.bInterfaceNumber !=3D 0)
> +               return -ENODEV;
> +
>         print_id(udev);
>
>         if (id->driver_info & DEVICE_INSTALLER)
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
-upstream-moderation/affecee3-b60c-498b-ae12-99ade5e65f05%40mail.kernel.org=
.
