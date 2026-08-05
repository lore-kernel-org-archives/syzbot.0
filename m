Received: from mail-oa1-f54.google.com (mail-oa1-f54.google.com [209.85.160.54])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4B9DC352014
	for <syzbot@lists.linux.dev>; Wed,  5 Aug 2026 14:13:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.160.54
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785939186; cv=pass; b=X4EWSyKs95KXESwpwgcr1YzI78Hue+CETAswu70p59w+HIoH2fT86K9M7zPDcQF/UReae92vp9NedYqAIA4TZmdmF/jbQH/HE0r9IQw89RtFa9LuxG9Xk2pZO+BJLPn690rAM+CDGS8hOzP5pUCnaXEJ6Fx65scPDl7ryHi13CY=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785939186; c=relaxed/simple;
	bh=0FgDUkeBaNSKWepg6S43lsmASYq6OUFxdv+y5bAuXAc=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=UOpcLbEzOzussQF/WYpf5jNePlvio9EJaOYjt+LkPTcoqElsKnQ7Vzh45AJdOKRJQFUMVt3gZeGZlun7jkoJmnfiNSMceMA7aBZhMIiRKMhGu3BMQEZca3JllzirtTbqWhuzGjAmwMLwcWKrHThj5XRkWO5JWyFyetM7spc9xhw=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=wl+fibiS; arc=pass smtp.client-ip=209.85.160.54
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="wl+fibiS"
Received: by mail-oa1-f54.google.com with SMTP id 586e51a60fabf-43bf9548df4so640306fac.0
        for <syzbot@lists.linux.dev>; Wed, 05 Aug 2026 07:13:04 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1785939183; cv=none;
        d=google.com; s=arc-20260327;
        b=p4eFSYcEYj+4GrbELU9yKfpAytYZ91LJBAn0xGXQYz41yAWBnjLXfdo9ne8x05Lvtg
         SxHxTCo3juIW3vbmumvKx8j11Y6JAuVCPIsm4sbNIXigJWvFGOMcLXbgqajpbB8NGtJJ
         Vm65WX01Hi0NA2XY0LPQls5fsAchxLd3RdkrSA6xneZaIndHnHULTGGaQc6at3CpOkG1
         TPvVi7eBQd1bxIJQJTAHg3YSiUN/y66bwLJKP5qcBDCM4w4GuZfDfZfdmyGoTmNzvwlY
         QAWfnfT0bL/MYpjLF3LM25JKYPEUgAvOSi3y+L4XV/C9Tfpj5tzUx1JCToVJ/npulvCf
         s21g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=RDod6rQyfTZzbG+avpqwefoM9i9P9+Ds1SjXYDiqpd0=;
        fh=4NM2fH5fJfH3QUSQn1Ni1SVmqh190HjSCA1ucOEjYfQ=;
        b=souWqzkHk/Ml9I5uPWbFgHUAlvjykubPOq53E5McE9ZO0kNTcaQROEifz3qyJiQKP2
         RzR4P+ZhluhsGQV5PyqlYutmMBXli+8B2sJGtONLQcOOjfJ0j2hhTHRYDL2Qh04PZ6Ep
         plNvLK1Vi+w0S5hOGUiV8TbwWkpw7odVT/KY9JvrspQ3n/XHFGqCcslO8RJcnzbgxhbf
         D0LOvZDqD9mk716IbtueRYTpYC245BCmTpRwkP4bqjbzSPDF3PXcY6EOvpbo6gSv2oFv
         re+CwpnODkhr52H8aoWPp7ktN8QG1A26W2cKpgGxarFXIBa22xLo6a8wMJlk3LZKlWUF
         Phjw==;
        darn=lists.linux.dev
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1785939183; x=1786543983; darn=lists.linux.dev;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=RDod6rQyfTZzbG+avpqwefoM9i9P9+Ds1SjXYDiqpd0=;
        b=wl+fibiSo2w/ERWv4hEhnSmtiq5o6TZlsMy9Pr/YDc//NrybQe8m5OvmKQ3hTj6HcW
         QGqg5pR4qsaN1KWzYOzIJXNP8xp17q7jD0OhQE+HWjGlyZYCeNhCAIlruDt6K4X679hg
         qyCNqfBmQ0PMeIErq2HPICb/NivZetWWyrRefrIqEtAEOHsRwh4M+yL5ty5QTWJGk/0l
         fgzyuOrZ4YlqOX92VTC3ZUxLCBVdyFaYbuwOgtIBz+uQvMgsTBuHs3FSviTLXXbXz+/B
         mQH4iNXP6zq4XE0GvdaJFT5csYMonkB6axvqihcDghCbTCzgCQtUHlku8uJFQ+tTN9MD
         hACA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1785939183; x=1786543983;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=RDod6rQyfTZzbG+avpqwefoM9i9P9+Ds1SjXYDiqpd0=;
        b=qyGS2q71mOnkGzSjCKW9MNMC1DJ5pXcNyQ2B8NO+L1uIf+balfxtPFBdE8atkWnYVC
         qAxCWutDcUT0/+yeN8oNDF4aVw4R6lXE6IMGfa/2IRqPq0+kGNiefe5COsvkXg/VvB4g
         s3+ukUlKpIe0geqL0lKyMHvmxN08RdhNuB3VGarUKxcpR8FTrVk2p0h4Xucah/blFPLc
         HCArk1jtxFqQiCnhHd38Yuy8UkjjzOVsH2Gi71OEK6bSlPCbnXz+I3OjVE1YZ7jgIP3X
         2iB83jNl66IyX96ytukAv3oh8BqOIogb7JSfJAc0+Fakfv9RQjm79flzrlbEBkesWqte
         NgxQ==
X-Forwarded-Encrypted: i=1; AHgh+Rrozit+BdSGU8OoJU9lnJfCdzOXy+VIRtIdaaT18C6qS8FhiNxrcs2bFAhJ6qm4C2nSvyktnzI=@lists.linux.dev
X-Gm-Message-State: AOJu0YwInXDwGenX9M6RM0UfPNH6Kklfvkkm7uOp4/Jh8caZ3Fl3MRlg
	+l+BIG8vQszlRM3mu7ycYasMYeznc723rEJ6siBSwuijGyZRTNuBuicvpqRPcKTKp4/E9z4fYuf
	KE5a3ydfVPWG5nJNRPscPSwrngtTYFurro1p7+NIp
X-Gm-Gg: AR+sD10m9YxXFKQm6tyuO0mj2bb4wZrsr/USva+mbeInuH0WXciLs1RVvoF1rTzM8Zq
	cF43vhTaPi3J7NFzNLn2ghQk/gTdNOmnxVtBw8QFs1RhHw15Rlp0kED0pUt/2lBlFIkpc4xT7bF
	VFPtCCuFaOVh8eZHbRZgvXU/12IScBz596zcR8GaqQzm7u3d8nqIFBkPwwBOvZLjpkJALUe14RI
	vK3wZAMct2KYW5ONM7PzujAMh5tT1DrVLdJJiMWO39tRUS5Y5Fvts30VqKaVBkcXSoUlN4pd7n1
	7wO5ch7os3iCVUCgYfeorX+10Gi7aSKnA9UHkmAsPjHUh5OmoiQNvA4LLd75HsiuP4qT08e5m96
	UTaQaSh0OmIwbNgUPFTK1yRqWfeucN2n/nB78nEes7Tx/NnZyFoe1hjq9UKztmRENtLN90mwNkO
	zKBdxIw6e3Iv/i
X-Received: by 2002:a05:6870:21ca:b0:459:fe2:ef54 with SMTP id
 586e51a60fabf-4599ea801eamr3729977fac.1.1785939182288; Wed, 05 Aug 2026
 07:13:02 -0700 (PDT)
Precedence: bulk
X-Mailing-List: syzbot@lists.linux.dev
List-Id: <syzbot.lists.linux.dev>
List-Subscribe: <mailto:syzbot+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:syzbot+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <2650cf0f-26f9-48b5-b198-e4cb67c59cf0@mail.kernel.org>
 <2026080336-covenant-limpness-55cc@gregkh> <2026080322-obsessed-daringly-e6df@gregkh>
In-Reply-To: <2026080322-obsessed-daringly-e6df@gregkh>
From: Aleksandr Nogikh <nogikh@google.com>
Date: Wed, 5 Aug 2026 16:12:51 +0200
X-Gm-Features: AUfX_myhx1UT7YuZLv76ps63pUQOVA0rWCMh7UFrFfX-goB0uNf0WfxNsQaXwwM
Message-ID: <CANp29Y7i54S8jXyd50uBU0TYgm5GmcKNxAsP6_XDuq8zSvG3cg@mail.gmail.com>
Subject: Re: [PATCH] usb: usbtest: fix NULL pointer dereference in usbtest_probe
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: syzbot <syzbot@kernel.org>, syzkaller-bugs@googlegroups.com, 
	linux-usb@vger.kernel.org, Greg Kroah-Hartman <gregkh@suse.de>, kees@kernel.org, 
	linux-kernel@vger.kernel.org, syzbot@lists.linux.dev
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Hi Greg,

Thanks for the review!


On Mon, Aug 3, 2026 at 5:15=E2=80=AFPM Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> On Mon, Aug 03, 2026 at 05:13:00PM +0200, Greg Kroah-Hartman wrote:
> > On Wed, Jul 29, 2026 at 09:19:54AM +0000, syzbot wrote:
> > > From: Aleksandr Nogikh <nogikh@google.com>
> > >
> > > The usbtest driver relies on the driver_info field of the usb_device_=
id
> > > structure to hold a pointer to a struct usbtest_info, which contains
> > > necessary configuration for the device. When a new device ID is dynam=
ically
> > > added via the sysfs new_id interface without specifying a reference d=
evice,
> > > the driver_info field defaults to 0. When the USB core binds the devi=
ce
> > > using this dynamic ID, usbtest_probe() unconditionally casts the 0 to=
 a
> > > pointer, resulting in a NULL pointer dereference when attempting to a=
ccess
> > > the autoconf bitfield (at offset 0xa) of the struct usbtest_info.
> > >
> > > This leads to the following crash:
> > >
> > > Oops: general protection fault, probably for non-canonical address
> > > 0xdffffc0000000001: 0000 [#1] SMP KASAN NOPTI
> > > KASAN: null-ptr-deref in range [0x0000000000000008-0x000000000000000f=
]
> > > RIP: 0010:usbtest_probe+0x522/0xcc0 drivers/usb/misc/usbtest.c:2822
> > > Call Trace:
> > >  <TASK>
> > >  usb_probe_interface+0x653/0xc60 drivers/usb/core/driver.c:396
> > >  call_driver_probe drivers/base/dd.c:-1 [inline]
> > >  really_probe+0x254/0xae0 drivers/base/dd.c:706
> > >  __driver_probe_device+0x1e8/0x360 drivers/base/dd.c:868
> > >  driver_probe_device+0x4f/0x240 drivers/base/dd.c:898
> > >  __device_attach_driver+0x270/0x410 drivers/base/dd.c:1026
> > >  bus_for_each_drv+0x258/0x2f0 drivers/base/bus.c:500
> > >  __device_attach+0x2c4/0x450 drivers/base/dd.c:1098
> > >  device_initial_probe+0xa1/0xd0 drivers/base/dd.c:1153
> > >  bus_probe_device+0x12a/0x220 drivers/base/bus.c:620
> > >  device_add+0x7d7/0xb80 drivers/base/core.c:3772
> > >  usb_set_configuration+0x1ad8/0x2180 drivers/usb/core/message.c:2268
> > >  usb_generic_driver_probe+0x8d/0x150 drivers/usb/core/generic.c:250
> > >  usb_probe_device+0x1c3/0x3b0 drivers/usb/core/driver.c:291
> > >
> > > To fix this, validate that id->driver_info is not NULL before proceed=
ing
> > > with the probe. If it is NULL, gracefully return -ENODEV. The check i=
s
> > > placed before any memory allocation to avoid unnecessary work and sim=
plify
> > > error handling.
> > >
> > > Fixes: 733260ff9c45 ("[PATCH] USB: add dynamic id functionality to US=
B core")
>
> Not really, but I can see why the LLM thinks this.  It's "just how this
> driver works" instead, right?
>
> > > Assisted-by: Gemini:gemini-3.5-flash Gemini:gemini-3.1-pro-preview sy=
zbot
> > > Reported-by: syzbot+7e1e5911f9eac50bedc7@syzkaller.appspotmail.com
> > > Closes: https://syzkaller.appspot.com/bug?extid=3D7e1e5911f9eac50bedc=
7
> > > Link: https://syzkaller.appspot.com/ai_job?id=3D9e476ca5-99d1-47d2-b9=
d1-f3b501897179
> > > Signed-off-by: Aleksandr Nogikh <nogikh@google.com>
> > >
> > > ---
> > > diff --git a/drivers/usb/misc/usbtest.c b/drivers/usb/misc/usbtest.c
> > > index 98071b25a..6410b3e26 100644
> > > --- a/drivers/usb/misc/usbtest.c
> > > +++ b/drivers/usb/misc/usbtest.c
> > > @@ -2786,10 +2786,13 @@ usbtest_probe(struct usb_interface *intf, con=
st struct usb_device_id *id)
> > >     }
> > >  #endif
> > >
> > > +   info =3D (struct usbtest_info *) id->driver_info;
> >
> > Extra space there, right?  Didn't checkpatch catch that?

The checkpatch was happy with the diff:
total: 0 errors, 0 warnings, 14 lines checked

You mean the whitespace after `*)`?
I've just looked at the other code in `drivers/usb/misc/usbtest.c`,
and it's inconsistent: in some cases there's a whiltespace, in some
isn't.

> >
> > And this really isn't the proper solution, just don't allow dynamic
> > binding for this driver.  That should resolve it, right?

I'll double-check that and send a v2, thanks for the suggestion.

>
> If you don't want to do that, you need a BIG comment here as to what you
> are trying to prevent, as a NULL check just looks like any other normal
> check, while you are trying to prevent a specific use case from being
> possible, and it WILL have user-visable affect.
>
> thanks,
>
> greg k-h

--=20
Aleksandr
