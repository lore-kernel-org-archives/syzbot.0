Received: from mail-ot1-f45.google.com (mail-ot1-f45.google.com [209.85.210.45])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 02556353ED9
	for <syzbot@lists.linux.dev>; Thu,  6 Aug 2026 14:35:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.210.45
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786026927; cv=pass; b=Z+xrlyJgCREHg+MJ/dLj0kMQ+VGzsgn2mg5zT/mYU733Ieq/Tmo94NrNCfcYZOadjklyVO+sYK7CqbhBbCJnmKB754kmArH7cM7rzR6C1v5jiBVsUf9m+4uQui16ya2mo84NcGmQ3BiQqMEm179rK8hrOVSSadLgemmILMebdvc=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786026927; c=relaxed/simple;
	bh=NdtH1xFFGcgiYjV9sZ5XIzxrlxNCQSywITJ/BUXOvX0=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=JncxhyIQFQA2ZExk3fM1M4BltSG8RKzqGO5L5mbEfAveiUcmqLY/DDqO1zBoYn3tMCMbZ/xF9vv48ijm1XMvTVJupyiDeDhPybrBgD+qBma+RACK/WU4izov6vLKeEQ+hfJKXuMIqmPjDBx6179HMfNYutOW2XwBuSO48geqTzw=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=eYIixKGd; arc=pass smtp.client-ip=209.85.210.45
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="eYIixKGd"
Received: by mail-ot1-f45.google.com with SMTP id 46e09a7af769-7ec3b429a3aso1679993a34.1
        for <syzbot@lists.linux.dev>; Thu, 06 Aug 2026 07:35:25 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1786026924; cv=none;
        d=google.com; s=arc-20260327;
        b=ICvyCY17lH4FXXQiGqWaryUzWk1gEbXzCOMP2a+T5P/65DAZZOwp5kTQnN6fS+fI77
         28xtM6mzZ49wGVgd7KY6m6N4M9UqlcjE6M5i8AUagO0XfoJpJ2g6LI4DubnhpYtGH5VT
         uWoAHzIgw1bOHEgArBV6DJEH/IjvFkmKV0IQd8rr6X/fdNLAhIHc0/ZVWjGOWhWTeflk
         DTQfOV5TZvpoZ/bojD9zB9/1ffHsBvnWfo9m1Un6NEPXwfmZ99u40SvTQJd5gjfJGUor
         5eorxyZsZTuWNkm3yMslobLFY3VwtszmJi3ZpbB5mykZ+iuyLY81qnW0YU0J7zGqEHq2
         cLow==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=J3KxyFK3uoZ3NfW+v/d3K2ISGzYgFiPPlZtOpBCS9N4=;
        fh=jzVcugOClpTrGsZ5YLpwLqTekNpEYA6MMEZOzm93Ilg=;
        b=WimCuFeUwt8FYybFzH7lRLOb0LJ/M+mRvGqX6wf+o/OeFri2BOikHypwhkeBW9Uy0T
         kldO7rrG0fZcxe7+IGXd6G93QNJc641mdqv/XzQgVSGA8VScL+foA5gSm4PSCL9yEmpz
         PHUvUXKYPh5bmA+OupaNTEWiLsRJsEa8BZ9s32I/2rTDKIxUvbv9Lo3MP77maNudXRAe
         /X+KNJfPV+zVekSEoVobfp/9Uf58KMKPEYM1AnxAt05MXTyq5UBjhnfIjtOn7s0w1m1W
         P596HVkBpcOsHwq41994QG0o96femGmyMMxz3TgcYyB89PEhOdJ3eqbU7ozuxH9TOMO1
         tqyg==;
        darn=lists.linux.dev
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1786026924; x=1786631724; darn=lists.linux.dev;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=J3KxyFK3uoZ3NfW+v/d3K2ISGzYgFiPPlZtOpBCS9N4=;
        b=eYIixKGd8Bfx9KaW7DoqZZ60xhb23QyPGXSj9fxQUzLHHhVWsGO2nsizFDc6E5M+5U
         FYNZm298GzBVcgKQqzzegCBIKEKXzN3F4Z3lxZ+b8q/EfpggTkwBYbfBmCOQR5Eza5lj
         528+PVVdyPwb6tdAcV/LbuhNrYGgjPxYnqk+VMWpphrL2JKg22M6PXgMCYN6o4QK7dmB
         o+I8IYF3V/2fGVEvRs7Pn0ANi8BcZwLidntoo7Ki2K/4wuiivrtELjFUINy/r6EkHe3B
         iNyQVigTXT6pL4+RVNiEjg+Vb2ZHvgNqjhMQv9CyjwJBPuoA246GfNrt4JETdWX8iFka
         b2LA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1786026924; x=1786631724;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=J3KxyFK3uoZ3NfW+v/d3K2ISGzYgFiPPlZtOpBCS9N4=;
        b=fnRs686xRgF1w9M9jNw6qQxXKPHUFB5PXfLSK88WOyZdUmEbf8BYCygr/LGc4nsF/X
         RCvcDdSYm6abNxQOpEWKw5ntW3JI2Hz2ETrnOQa6V3tRwdBibfuPIti6n5f5rYJSQ2Zy
         8MisWfdRXA5As16LlIf3QEDG8SIMKjiWQbcOUTL2xRcgG2HFbDKCQiHeOzUXHFewlNyz
         ibSAJhe0ouGwZm9G0xAs9mtyUUHPC/n5AtI/8EDiLhHs46WkYe5pR6Hqony4/qAKyhGo
         fXmNQGd4amoZ372VQFyU4KT0GcGy/0NO3ZsSs5/kIGMfdEfIuQXTFm+9/naAzKqyl5Y2
         rZXQ==
X-Forwarded-Encrypted: i=1; AHgh+Rqamuyoh40fxR1XBDDnhtqlxJVyqwY+FA+p5gHiqBbvM0j8ADuKq7pRle1reenRh/hFzO0/8hw=@lists.linux.dev
X-Gm-Message-State: AOJu0Yw33BpUOY2XhWZA6vCAiZ3Pqorxta0RipA48Rg+B/9vTCP1oQOm
	/GHrJc8/Zcv59furXe7q7W6SWh6PXezGXTdJHgfms7AaJQpk79Iop9Y3k/dlXBuX37jXiYZvD12
	e6/EiNqw3qx0zZtYpDKp+dq5tV1YdYvrPYhCuXl0P
X-Gm-Gg: AR+sD13JPbm+24M/XCHTr/AgBhjR4uCxGGLdUcUwK48CBFcl5C0rOcDEwKPltgELs8N
	4Bnm8wzAB7DhiVlTqqw19nRR48FKvnfL9XaRn7OH//VOgHy3DLobJlJj7w6HkVV+ys3588qrB7g
	FUYWbNOJ0piilr5GYAEC3qd18IEgdUF2ZEmkn1LcBwlIGn2a0beeK9UwZhSEMSiAWSHXLW4kkIH
	7EapU4WjNYkaaPfZw+raTj0e8ehmag3OxFFvgsP2a/DxDwiKDaBxvsGHHGKMUZE55DoGT2ztdK4
	5QJGM3qVJ8rw9NmUdHXjJimtdUZEyUQx/6kIofd9kXWCms4OH+yPOnziFgJUQKnYYeWZNkwqDiQ
	9CJ5fBBH2CU93BB7OsFohSdUrEK4rs35Q/BaAWwhmR5EHL4TzQHBwD6uqSt+hid7ChFn2wFvA2G
	poP7xa7xZcoWOR
X-Received: by 2002:a05:6830:6b0a:b0:7eb:c933:efef with SMTP id
 46e09a7af769-7f1e5f012d8mr10558769a34.14.1786026923999; Thu, 06 Aug 2026
 07:35:23 -0700 (PDT)
Precedence: bulk
X-Mailing-List: syzbot@lists.linux.dev
List-Id: <syzbot.lists.linux.dev>
List-Subscribe: <mailto:syzbot+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:syzbot+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <2026080322-obsessed-daringly-e6df@gregkh> <20260806142511.2337081-1-nogikh@google.com>
 <2026080617-gave-widely-c5dc@gregkh>
In-Reply-To: <2026080617-gave-widely-c5dc@gregkh>
From: Aleksandr Nogikh <nogikh@google.com>
Date: Thu, 6 Aug 2026 16:35:12 +0200
X-Gm-Features: AUfX_mzZPSC-0Q8aRJoqm5lwHTUm-1lAKHvE0QUwHrgLy3cPWtCKW_UfrQkGQko
Message-ID: <CANp29Y7R1OzK3mo_i6uBxLV6zCgFUVxMgrfozAT-QNivp+gHMg@mail.gmail.com>
Subject: Re: [PATCH v2] usb: usbtest: disable dynamic ID support
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org, 
	Kees Cook <kees@kernel.org>, syzbot@lists.linux.dev, 
	syzbot+7e1e5911f9eac50bedc7@syzkaller.appspotmail.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Thu, Aug 6, 2026 at 4:32=E2=80=AFPM Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> On Thu, Aug 06, 2026 at 02:25:11PM +0000, Aleksandr Nogikh wrote:
> > The usbtest driver relies on the driver_info field of struct usb_device=
_id
> > to point to a valid struct usbtest_info descriptor. This structure cont=
ains
> > essential test configurations, such as endpoint addresses and test mode=
s,
> > which are required during probe.
> >
> > When a user dynamically adds a new device ID via the sysfs new_id
> > interface without specifying a reference device, the USB core initializ=
es
> > driver_info to 0 (NULL). When a matching device is subsequently probed,
> > usbtest_probe() unconditionally casts driver_info to a struct usbtest_i=
nfo
> > pointer and dereferences it, leading to a NULL pointer dereference cras=
h:
> >
> >   Oops: general protection fault, probably for non-canonical address
> >   0xdffffc0000000001: 0000 [#1] SMP KASAN NOPTI
> >   KASAN: null-ptr-deref in range [0x0000000000000008-0x000000000000000f=
]
> >   RIP: 0010:usbtest_probe+0x3b9/0x1280 drivers/usb/misc/usbtest.c:2822
> >
> > Because usbtest strictly requires pre-defined usbtest_info descriptors
> > to function, dynamic ID binding via sysfs is fundamentally unsupported
> > for this driver.
> >
> > Fix this by setting .no_dynamic_id =3D 1 on usbtest_driver. This instru=
cts
> > the USB core to skip creating the new_id and remove_id sysfs interfaces
> > for usbtest, preventing invalid dynamic ID entries from being created.
> >
> > Reported-by: syzbot+7e1e5911f9eac50bedc7@syzkaller.appspotmail.com
> > Closes: https://syzkaller.appspot.com/bug?extid=3D7e1e5911f9eac50bedc7
> > Signed-off-by: Aleksandr Nogikh <nogikh@google.com>
>
> Shouldn't this also get a cc: stable?

Is there (in general) value in cc: stable without a Fixes: tag?

>
> thanks,
>
> greg k-h
