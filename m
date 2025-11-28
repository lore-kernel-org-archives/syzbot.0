Received: from mail-oo1-f41.google.com (mail-oo1-f41.google.com [209.85.161.41])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9295430AD10
	for <syzbot@lists.linux.dev>; Fri, 28 Nov 2025 11:06:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.161.41
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764328001; cv=none; b=eg573/MYWVKd9M0mFfI7JELURJ5z28cR04n2jGkGV71yqMi8LyWoCrQP9Jw85LTkcoK3qJnjqELQyUHcPzuh+TZMM3vvIKV9dlfR741To8PEpxGFNkvAPtgHiqSup5TED8bWK3AGM6/2YpMyVb6mIHks6Z6Kb815yWBKqGc6bZ8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764328001; c=relaxed/simple;
	bh=Gm3i4F5SW5q6vhjN9O1LFJHd0H/OPzhj4D5OhKg+SMo=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=L1D1ZFEm35hD5bhBUW5ryAC/XnLObfhsa4PX9qYUHMI1LlAcXQx4CgDastPrtpIMBcBlo6PE6MLfOAsGFU7Iaq9dLgMn/ejTbXIUONEr863BTOAyUd6I+k1frDB1at8qP08DOeQn/X6NNOkqZb8ingX24/xoxwu6kKuZuknwz2o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=gYdWotR+; arc=none smtp.client-ip=209.85.161.41
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="gYdWotR+"
Received: by mail-oo1-f41.google.com with SMTP id 006d021491bc7-657509d761dso847761eaf.0
        for <syzbot@lists.linux.dev>; Fri, 28 Nov 2025 03:06:39 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1764327998; x=1764932798; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=dTgil8FqmeN8BYwydhqsieWZNZkIuEL473dH/X7lXSo=;
        b=gYdWotR+NeeIJw3v9pG6OdWZ6qpyRNDnInPn8psHFrMMrPUMYOTdmlI4iJGksOJY23
         5BRFsY25pcjpf3RJc/UpLs88Yf8OMfzL0rRf5vIP4xvI74Ya2cVfDKYddtjBjCzAO+Ia
         e0XkBEvU401bzMnZPJ8sSkpxzpsPaZg+fZC073LeqHtoqyC6DpwH1RXt/dReQ1Eq0i+a
         scFroTI2MMBgcVnBmbWPDwJZ5w0Q7fAsuTDLXgwQ375FGw36w9yXjyEVA+68hqVyDks6
         xJtEDBbEGFQGCtxFfuX9XsZ2VTy5MqsXGNRi92bddSx93r3XaH6I9TAiUrtbjCzkVSaS
         2Pew==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1764327998; x=1764932798;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=dTgil8FqmeN8BYwydhqsieWZNZkIuEL473dH/X7lXSo=;
        b=gSpoB2K7bEGQlE2kIUwHiMvbrtVn4L8sLZrC0E1qgp8khvTe0aYO1z39xLus74ob6y
         +1jFi88DPN7b4Uo2YtrdvgOAPCqZ+qlUWJzmcOURpldrFnzj/wAqLzhpI8VBS8/NBQh9
         s4ILa08prK0RuAyoiRIojJBS86iQUt8xc7k4V62+IyhpsZ0L1jSYTaXthQL6GYbpvQlr
         2URDD13myd0CexYVIplk1xcfavLg9li4rRWJSb3AQW4OeursZliYFfW0fLTkIliF+AEp
         lEnvRs5U93Hh+wBrz0n4ZBB1ZLGRabTr7zHMat1zwR3i/lUrgMg6UIR0oLTIAQdQEagQ
         0ElA==
X-Forwarded-Encrypted: i=1; AJvYcCUwhbTSEkYVxnEf2o4quAfAslEqptt0K9yp0bHQK8sF4LZ+p2xy/g8pcIXwWrWc+z0V4ynZ5Yw=@lists.linux.dev
X-Gm-Message-State: AOJu0YxZ0UGVVxfByngv1pU+Caf37ZTl+0cfYl6TnwGYwKwck9okbrcg
	ho2POYoxh2DmatiBjRU3VeTr4TbeQoor0aqrubv9kG0xawvQ+n2TuriTjqap2W4lRnugNw5q0W9
	s5Ve6N+OCp/QkzH6VrUt10FrVj8DE5gDTcKzxyy3K
X-Gm-Gg: ASbGncsMzp9BY66xk3V7PsMV0kBROFIg3tvJW2ByDfjf/X1S3OmBusIZMKuRYPpXuui
	zvQlqtUPoo1qebSOE2DV2XvL0duIqZpDSp2cuB7SFV3wkN+W5cHljcv2ZYr8EXx1EX2wuDnkAas
	3IF+lPzGdxrIyeiVRqARaSnrY5rP6Vmk0jWGIoy+3xNJD2N30Q4kLW+rDBpeaNX3ebv0Wfa5kp2
	R5Ppp0yNn8i+aygv66V1A0m9+jj3Qi43WiqigaDk6+H9JOGlqQXufrc3HwZ4zgmwGQCq/Bs8Mu4
	sCYV5q/HBZs67vU6AhXvvhz0gA8jUPRrOvA+gKiIyrLwnamDle06rk/E+hWyl8vrYtUw
X-Google-Smtp-Source: AGHT+IF5s5FkjFWXvsVS3auIWzGz0D+dBwo2sk93mVqFRl7srhXthKihYnsVqueo9K4qnUvpAOo6PTuZ//EyUGq2kTs=
X-Received: by 2002:a05:6808:c165:b0:450:ccef:c00c with SMTP id
 5614622812f47-45115b887d2mr8734232b6e.48.1764327998296; Fri, 28 Nov 2025
 03:06:38 -0800 (PST)
Precedence: bulk
X-Mailing-List: syzbot@lists.linux.dev
List-Id: <syzbot.lists.linux.dev>
List-Subscribe: <mailto:syzbot+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:syzbot+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <6928c55d.a70a0220.d98e3.0118.GAE@google.com>
In-Reply-To: <6928c55d.a70a0220.d98e3.0118.GAE@google.com>
From: Aleksandr Nogikh <nogikh@google.com>
Date: Fri, 28 Nov 2025 12:06:27 +0100
X-Gm-Features: AWmQ_bmZton4U5HbJNCYgmsKDMc61XOBObE2EFm010FyGFPWOhuZu3OT2M0cgzY
Message-ID: <CANp29Y60SS2u5cHGps3LKaRZ9ZY_T2or9gSrp+bcRe8jEm16ew@mail.gmail.com>
Subject: Re: [moderation/CI] Re: io_uring/zcrx: implement large rx buffer support
To: syzbot ci <syzbot+cidf5d85076b338c72@syzkaller.appspotmail.com>
Cc: syzkaller-upstream-moderation@googlegroups.com, syzbot@lists.linux.dev
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

The patch mentions "Depends on networking patches";
I could build it neither on latest io_uring, nor on latest linux-next mysel=
f.



On Thu, Nov 27, 2025 at 10:40=E2=80=AFPM syzbot ci
<syzbot+cidf5d85076b338c72@syzkaller.appspotmail.com> wrote:
>
> syzbot ci has tested the following series
>
> [v1] io_uring/zcrx: implement large rx buffer support
> https://lore.kernel.org/all/7486ab32e99be1f614b3ef8d0e9bc77015b173f7.1764=
265323.git.asml.silence@gmail.com
> * [PATCH review-only] io_uring/zcrx: implement large rx buffer support
>
> and found the following issue:
> kernel build error
>
> Full report is available here:
> https://ci.syzbot.org/series/eb38d633-11eb-4de2-b1fb-e4a7bd0c943f
>
> ***
>
> kernel build error
>
> tree:      linux-next
> URL:       https://kernel.googlesource.com/pub/scm/linux/kernel/git/next/=
linux-next
> base:      92fd6e84175befa1775e5c0ab682938eca27c0b2
> arch:      amd64
> compiler:  Debian clang version 20.1.8 (++20250708063551+0c9f909b7976-1~e=
xp1~20250708183702.136), Debian LLD 20.1.8
> config:    https://ci.syzbot.org/builds/bde1c86a-d7b7-474a-9faa-cdeb8160f=
cf5/config
>
> io_uring/zcrx.c:833:11: error: no member named 'rx_buf_len' in 'struct pp=
_memory_provider_params'
>
> ***
>
> If these findings have caused you to resend the series or submit a
> separate fix, please add the following tag to your commit message:
>   Tested-by: syzbot@syzkaller.appspotmail.com
>
> ---
> This report is generated by a bot. It may contain errors.
> syzbot ci engineers can be reached at syzkaller@googlegroups.com.
>
> The email will later be sent to:
> [asml.silence@gmail.com io-uring@vger.kernel.org netdev@vger.kernel.org]
>
> If the report looks fine to you, reply with:
> #syz upstream
>
> --
> You received this message because you are subscribed to the Google Groups=
 "syzkaller-upstream-moderation" group.
> To unsubscribe from this group and stop receiving emails from it, send an=
 email to syzkaller-upstream-moderation+unsubscribe@googlegroups.com.
> To view this discussion visit https://groups.google.com/d/msgid/syzkaller=
-upstream-moderation/6928c55d.a70a0220.d98e3.0118.GAE%40google.com.
