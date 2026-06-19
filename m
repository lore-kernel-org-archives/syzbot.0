Received: from mail-oi1-f177.google.com (mail-oi1-f177.google.com [209.85.167.177])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 529CF40D598
	for <syzbot@lists.linux.dev>; Fri, 19 Jun 2026 05:22:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.167.177
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781846553; cv=pass; b=IBf3GLAZPAE/1IXWsBBCERTo4gj0/Aanyd6IXRbN7Ng+yWM/TlBWGRNReW0yFsRtD2piVNeVyIBifYHsz5hl/BBS7B2mSJGn97foW2pDoMABGBs8WIOjG7aRwRtuBVXlgu9aXoYpa3ild3r/fD0QIHdRttlLlHcIfcAxY0p5XuE=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781846553; c=relaxed/simple;
	bh=LUREygInbxNF/CfyMG18wYfSO6qCtyw3BIUg3UEa4+A=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=q+cz0OJHYDN5q9LIwrbdVasLnOMvvp1dxTiPtMP8pF1s9yIexN+aIk7t7W8WCGTThJ243EHmNL/AN/yoIUgCmT0C+d7MAJNRL3EvpV/WADpYBrzZql7SSHh5HzQZ8FiExDdh10q8nb4Co3T6AuMqjDuKptKqOXnVTze4u9AtWP4=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=Bc3F9X2j; arc=pass smtp.client-ip=209.85.167.177
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="Bc3F9X2j"
Received: by mail-oi1-f177.google.com with SMTP id 5614622812f47-48650c78e09so650527b6e.2
        for <syzbot@lists.linux.dev>; Thu, 18 Jun 2026 22:22:32 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1781846551; cv=none;
        d=google.com; s=arc-20240605;
        b=Y2eEx5G3BKdnfBeoShbliyK2JMz8EVIZB1Pynp9gNXehUpmFcFHC5ID2PA31Lk6KqV
         jsrY2fWp3Uy5qkZ17JnPmpzsCEY/p9oetjKGyfQMvEIQB1H5C+C9k3FR2gFYJu+gjatK
         EvpQnb+VD8f9CSRK40Rf3mbJHa3dJHIZP6lwJoJH7OO2QncU/AWt3klvVYKHpmQ8FooW
         +piMsQEY5HoYpg0CTmHNk2lUT0jBHWKSgYEP08AFfU/sEOczSEIj8uUBiLl/Yo++wGQT
         LeaUGThBoW8zauwZaI9fST2YBKd/BuHOPqnnmIXkZuLsqshDQW1NLCKNUPFiBiJaUS8+
         1arQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=LUREygInbxNF/CfyMG18wYfSO6qCtyw3BIUg3UEa4+A=;
        fh=GHJB0y6juCQLp3oEj9jtRr/G5ox2c1/FHE1kQzGyev0=;
        b=bnHw2OItOyb9CP3PIrHWF+6/5s6hEyWMQ17ujWP8E98zZxG+7+ULVHT0aNWUmgiMzL
         3Sx2OLma1Sv/94oP4ulqnFLuhAb+2nEHxmxDOcjMWgEMxcVLsGQiT6tX64uOFvu3DiIh
         ztwNsxBX+nf/J5qO/MxvlocWnmaOvH9TMFfDaTOeeON2I+yjdPxOPIqZVBiizT3+BcDG
         UerjvfX9o80yZriIlA6861qEBbJzy8XwM/z8mQtUqnKDPbxB0AcuTLD3hoOLSPUZtoWF
         6kcumvbxS0dB7hR9+OclsAyOY8Hl60WW5XW7pQ4ihHxCJsyFsmBi0V6UBTgL6wWHJdC1
         JEog==;
        darn=lists.linux.dev
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1781846551; x=1782451351; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=LUREygInbxNF/CfyMG18wYfSO6qCtyw3BIUg3UEa4+A=;
        b=Bc3F9X2jRd5NUwrKql73Kijxwo51xjuqkFFYSWOrN7t2uvpGbLgQG6FMEuKFTgfh8Q
         iquGynxyptKLRaJXvO0BuHTik5LsUjhIDY6UPlxWcN/nqaOTF2IzPPmkxel4v3pE0icw
         WcFJbLecp1S8LGCbIJ7LA8YPXcEf7eOCOw1jizNWhtHOyuKnGwOMoC54OD9ISpX1qemC
         dhHTW63EUD/MJ9fYtfBVvk6PymtQqKCMv7JDEmNJLPD7AXjFlsnSjvXfep4LqPABjgmH
         r9efXRvq4O1e7uuE3Bw1Y0zlufZgwYckwBq3w54EMWOwIOLi0ujmgs6FLxhfoNq+4MDi
         akUw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1781846551; x=1782451351;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=LUREygInbxNF/CfyMG18wYfSO6qCtyw3BIUg3UEa4+A=;
        b=foXIZYAJWIzNEDjR4uzQyuakYkjhrRLSUVTynRcfCNb8FYhYnUIZaiavTsDEkNS6E9
         9LM7nqxsURmuMW3v1lmbngq9yYapyOT/JWBmbJsu1c6TgocOR+LLo+dzhJDIianQJiAX
         jDXxkzzxVxuIn0vjY7jzO31q7YJZeHYQhQgGRxGFMU0nCCMK3qaREsNZbZLpOgleNUmS
         7JZsHrgBEmnOk+bPP5GTvc7Ld+Xc0v34WwuoBlE/8AsxcTNIco7shXaxeE4tLUQouT0V
         2SlSKPvFHg9s+NzxlPza1LIdMbjNfmpJTz6fApXwH9rVJdjxCmtt//uGoWQ+x59R0QoR
         AS/A==
X-Forwarded-Encrypted: i=1; AFNElJ/oiY8fwmupy+4g7iyLAICF18nX/0EOJaZbtTj9CZI70+izrLSyeV91k6UysO6u7wUB1g4P2Zg=@lists.linux.dev
X-Gm-Message-State: AOJu0YxMrJ5jUeKjx+k1prlLObt44l7zNOrUDBnPOGO5tBH/vwJevh+k
	VngwMPufLuefJO80GI8fatTakj7iB3rsIDdL5UJQSYQfh6i5k/K/4A3VIQjm8WpjOGGU59HLRnF
	2ePl1Fcv33by3nIqiNtuFz/153HT5NT96PDkaNsL+
X-Gm-Gg: AfdE7ck3eb+oOiBFK+tsPS9KyMqf+WvQNrHmF7SXDapsJsrMhwg0/JDSgZ07+egGUrl
	FRVbKwn+IgXjsfylxK61DlHZnRIqO1Zcdyj7rLu+OKMVEnrh8MMy4/Np9gLzBysG1p2x639yWTM
	Aid052Uaqm4B+/UekLtrUaXRtspQuKofCwDZHghsRHkSf3acVBQBklunK/BRksfuJzUf1r/4oEa
	yKWZsuXyXfr2rttUP5lQZoow/jrQ1Tq0oNEzHMCQJjrmVpFqEo4+8ftLKSqpgLX5Wko4njXRqvB
	FWzq4njdi1Z0b6k+MeGPcFLDIYbBFUioi/pFNAVOrgxYk3F6+9+CmJFfTRJwMelJrno7DMyjSmB
	AaM/brTaqwQ==
X-Received: by 2002:a05:6808:10c8:b0:489:5cc2:59f8 with SMTP id
 5614622812f47-4896a9edc91mr1996528b6e.10.1781846550704; Thu, 18 Jun 2026
 22:22:30 -0700 (PDT)
Precedence: bulk
X-Mailing-List: syzbot@lists.linux.dev
List-Id: <syzbot.lists.linux.dev>
List-Subscribe: <mailto:syzbot+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:syzbot+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <CANp29Y6Tzp8DvhmZ7j1ccyYvsNic1mZ=Yp=Nd9vBnjjZ0zBjwQ@mail.gmail.com>
 <c4f3dfab-bb34-4a72-8453-100c3f5fa9ff@mail.kernel.org>
In-Reply-To: <c4f3dfab-bb34-4a72-8453-100c3f5fa9ff@mail.kernel.org>
From: Aleksandr Nogikh <nogikh@google.com>
Date: Fri, 19 Jun 2026 07:22:19 +0200
X-Gm-Features: AVVi8Cdq1FYgF3rfcJt3emLPG3sgchktBYFKEtQlTw42jfFodKCbLsxM1TITcS0
Message-ID: <CANp29Y7zwqYSEDSQaMq1g__FoPR+y9VA39Y3xsbBgNxzX2_qsQ@mail.gmail.com>
Subject: Re: [PATCH RFC] drm/lease: use kvmalloc for user-controlled allocations
To: syzbot <syzbot@kernel.org>
Cc: syzkaller-upstream-moderation@googlegroups.com, syzbot@lists.linux.dev
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Thu, Jun 18, 2026 at 6:19=E2=80=AFPM syzbot <syzbot@kernel.org> wrote:
>
> > Wasn't drm allocating physically contigious memory blocks on purpose?
> > But in this patch you are trying to change it to virtual memory allocat=
ions.
> These specific allocations (`object_ids` and `objects`) are temporary
> arrays used within the ioctl to store object IDs and pointers. Since
> they are not used for DMA or hardware access, they do not need to be
> physically contiguous. Using the `kvmalloc` family of functions here is
> safe and prevents the warning when a user requests a very large number
> of objects.
>


Then say it explicitly in the patch description.
