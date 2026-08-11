Received: from mail-ot1-f47.google.com (mail-ot1-f47.google.com [209.85.210.47])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 984944457B1
	for <syzbot@lists.linux.dev>; Tue, 11 Aug 2026 13:07:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.210.47
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786453661; cv=pass; b=XYUeZnBNSqwUsViaGiJafT6l1CD/55ECwCiRWyFXvKIt0Zw1LUqkanC5qNlO8Um8QKSJOoUcQqNNyOqveg3MQ431zGGnowdVJ6npAHPnNV12XtYsXC5ihXm1S1qpKM+bvmPxr2fSUbkWaMNBWVOzV/LQEu+2pn0R2Gue0L9HwqU=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786453661; c=relaxed/simple;
	bh=tR9R2U7bD3UHwrWbp5R+7VDzqM21wHkG3T058D546N4=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=SC8ohaJ9nxuFBI19IdYiJzT04zeNM48rP0Vqnfnn4uqcJ60PEEtDF5EpnuLxUvAearzoYbHWdEvcMBxO2RPN1c5jCjIAM6pma1pEtoD/Qz/TlYkk0Me1K+zqidCEZnKNqCRWclJmYpMqEkV7BgxaBbvs60z9vqI/tsv1zx8HNWc=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=TcOfVc/F; arc=pass smtp.client-ip=209.85.210.47
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="TcOfVc/F"
Received: by mail-ot1-f47.google.com with SMTP id 46e09a7af769-7e9ecb1e13cso3049234a34.3
        for <syzbot@lists.linux.dev>; Tue, 11 Aug 2026 06:07:40 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1786453659; cv=none;
        d=google.com; s=arc-20260327;
        b=N6Lqejn49tgjuVmF6zF20lC6t2kU6lbetRh5h+V/OzTNh1hfW9+46dAxJUkVv77U+4
         q2e0fNFLGoDBsOMVklwpFTRTKevtmgS3BUm77Hxxrocq99G80c6VTuIo9TBWiHEwWKIj
         gmt/nYoOKtyCjsq623PjGEaq/0UbitPngZfMWEaY6qk3CK5/ufBeVhIrx4aB81Z5vKE4
         zgNeLEuhCwVQH+5VsIoLygl2uR2ugPAUmYcgMQ8SSCQsvsJKUTiW7VE7Gzj+rddpSIzJ
         HvEKS5m/g0nEjAHWUt/taV/Zts7ZFi4O4jVSVaygqxdYyN57I9I4pMfhjDcN1G/fhQlf
         hNLA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=tR9R2U7bD3UHwrWbp5R+7VDzqM21wHkG3T058D546N4=;
        fh=8luvCvyvL7y3g7ERAXCnQb7XjvnwuvjYVGIGCYtU3fk=;
        b=VluaPypt4Lgxr9Nl2CKfT5xLoXYTbSYegyp0n/wQhiuTQxuVu5ZM1IQvEdfEJKDUqZ
         nxCqTwyRlVkIX2JcdPcNC6R1zcJo4eCryDp8dxxFkUasgIXAOylQzl3mL6aGRrgRLrmH
         4BLAQRciM/wJ6iB28eaa6n0nb/7x6lt9R+EOMJ2LDTOoHyjwZBABZ1s7flKEvcO+bHOB
         1PT6oDk5Z9kp0Z1QIRrF3qKXvCxL4AnlCADwxD2/RuDz8Y/nQp0IdTft52ljeW9Z8bpA
         24wkWRA2+FR/kOt/MoKY9bZ0x3fKuZcH+B2j++S0faSvgpGRk8JACNUiN1iLWJFeS0K7
         fO4Q==;
        darn=lists.linux.dev
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1786453659; x=1787058459; darn=lists.linux.dev;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=tR9R2U7bD3UHwrWbp5R+7VDzqM21wHkG3T058D546N4=;
        b=TcOfVc/FCP2TbKa8PSlwItVSoRLEEZ1vWte9R6m9EAEyy/nObDsfN1tv2rB5MMy/8o
         UU5sxp4eVShRJ7mltpIT6xKA+adiHLwFk6UdO+CSdhZx0uwxfOW4qlm9aBbTseysDttn
         lna0albVqTpUayNg+8I9JXG1mG9hJ1h5XU+/mJKYH3pm27eVixUzCpJMBROdzwJ5U3Ko
         0ao4Q8+g/cjljZeLJwgxoadcE1gNquAbNRRW3Hp7FihRSihmfaO1NrLln9MOXfOA9H3Y
         bp2hoYzCnTCqwDXdjNdd4pM7wbl/YiZmhwedOIFwysx+E1Esewp6kbSwsCjK4IW+qCb4
         5jpQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1786453659; x=1787058459;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=tR9R2U7bD3UHwrWbp5R+7VDzqM21wHkG3T058D546N4=;
        b=VQEu5I08rky3g9BhZSWI5No64rvlyCecIS9TLUIdVnLkHZa9j4hNSMjm7Q2xSnjTcW
         E4SBR1tHFD6DSz9hT0zBRafSl23PvGVqdmZC7Pg9oVv6BgOa0mRbgWlpMxOAUKNQvuGH
         hBcwSCK7LoukXeUEnX7dwuCdDoWMjRdJ8z1Qd4M9HuzXZm7Kz+WdrF9b0agAlGC8B2Ss
         h7ZjT3HaCCZzQAe6cjXvyw8nbjz5GJQI6MctpcKRXL+FAn6FJSPry2NXPd4gLXDSBZZ+
         bAEOljWr5k6mkk5+H++TWej5+huUMTj0f5He8orOrDHDxBtn+qVq10o0K/yvIORIpyog
         Zl4w==
X-Forwarded-Encrypted: i=1; AHgh+RoDLADm4JV5WSJQXkYzYRxQrAxF69pNOOOdumqZw+lJ4qPZRJFWuirgDeOv0AnpQCafY/H6njg=@lists.linux.dev
X-Gm-Message-State: AOJu0Yx3ibnskGnL5KW2zKPB/gUZTDZcTScxAPr+dryEWlACA/5ptomH
	uC/tPkOyXUg+2nVrohT8lQqmtNOqheSMei9gO9KsbgUp4YYtsj5J5nQQzVzsFnh5wNIU6RoXKxj
	jnWbKIAnkF6uw0Ef0nPYE6JZgGjpsBD3SNmYFCnmS
X-Gm-Gg: AR+sD10Xoc3vcmzsQ0vZpPF28e8NyEoec3yIip20KcX43Gp2VWdkfpJZ5Ed74rjWFZV
	XJuCjD8wvSmKaoKDg+GwTYKUwZ2bCqJ/nj5kiIqUPg0Nptd8m8Fgg++Swe1iEHI958P8CnBHHTY
	D/bHOI3r/1qtIvcFngoPiRsEXEf3QuOfDnFiRB/0adPYLsSbIztasDJPAoiiHBMFEZQxQpmKWnX
	9u3QXckDH5kOWj2LVqocEYQ9kBdoohb2N+RsjbAZTdNOYfaKcLUc0vQ9FmHr83Wy71bsBXRaZhk
	gLzUA4qPn3YFlRBXbLkykGxuOE1Fx9QN4a+0HCZ5qeTs+HWf4Nopp/891OFTP1UL20abNChs+Bm
	6SOS1giD85pvGLw9YN8p4Tk1D62v+cgj6atqheqndfFiNhlyu9Volviut2nuI/InOkb9DOCpGsl
	jsj06Wq0z9NMwl
X-Received: by 2002:a05:6830:2a8b:b0:7e6:efb8:fe66 with SMTP id
 46e09a7af769-7f3a83be911mr2234501a34.12.1786453653917; Tue, 11 Aug 2026
 06:07:33 -0700 (PDT)
Precedence: bulk
X-Mailing-List: syzbot@lists.linux.dev
List-Id: <syzbot.lists.linux.dev>
List-Subscribe: <mailto:syzbot+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:syzbot+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <ee9bc932-2fbf-4e8f-90e2-6cf604be9ff1@mail.kernel.org>
 <b47d2b37-0aba-46cc-afaf-cf824d99524e@linuxfoundation.org>
 <CANp29Y51K1Y0Z77oUEQmDpVPjJuz3fQhvvZp2=fw3GWSPiCg3w@mail.gmail.com> <34d4ca1b-ce89-444f-bb02-245287edfad0@linuxfoundation.org>
In-Reply-To: <34d4ca1b-ce89-444f-bb02-245287edfad0@linuxfoundation.org>
From: Aleksandr Nogikh <nogikh@google.com>
Date: Tue, 11 Aug 2026 15:07:21 +0200
X-Gm-Features: AUfX_mwvtn3h7hNqRwJX1cg6RvUezxiWY5Wu99Gv0uwmP6_b0fFWHfXPkZhtJsc
Message-ID: <CANp29Y4NLVebq6L7STgcFJYSJo81ZpO4hNvaJQT14OGDZqwzxQ@mail.gmail.com>
Subject: Re: [PATCH] usbip: fix use-after-free in event_handler()
To: Shuah Khan <skhan@linuxfoundation.org>
Cc: syzbot <syzbot@kernel.org>, syzkaller-bugs@googlegroups.com, 
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>, linux-usb@vger.kernel.org, 
	Shuah Khan <shuah@kernel.org>, Valentina Manea <valentina.manea.m@gmail.com>, 
	Nobuo Iwata <nobuo.iwata@fujixerox.co.jp>, i@zenithal.me, linux-kernel@vger.kernel.org, 
	syzbot@lists.linux.dev
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Mon, Aug 10, 2026 at 9:33=E2=80=AFPM Shuah Khan <skhan@linuxfoundation.o=
rg> wrote:
>
< ... >
> >
> > During unbinding, we must wait for the scheduled removal event to
> > finish before we can safely free the device structures. From what I
> > see in the code, once we have reached wait_event_interruptible(),
> > there's no way to abort the process or somehow gracefully handle the
> > error.
> >
>
> Yes I agree with you on rewinding being hard.
>
> Care to explain the scope of this assist?
>
> Assisted-by: Gemini:gemini-3.5-flash Gemini:gemini-3.1-pro-preview syzbot

It was generated by the syzbot's AI patch generation agent:
https://github.com/google/syzkaller/blob/master/docs/syzbot_ai_patches.md

We manually review the patches it suggests and upstream those we
believe are fully correct.

--=20
Aleksandr

>
> thanks,
> -- Shuah
>
>
>
