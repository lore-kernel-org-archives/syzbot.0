Received: from mail-ot1-f48.google.com (mail-ot1-f48.google.com [209.85.210.48])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 726BA421F0F
	for <syzbot@lists.linux.dev>; Thu, 30 Jul 2026 13:40:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.210.48
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785418818; cv=pass; b=XgnKkTvvq7Q1K65tRPVjweUlNR4WJKXojty2fG2nL9zHI1+podJjEQBRzgIPFRyRzddmqUQAe4OLi2OerJUjhwHC2hqbTprAXoPvsY+xJlkiw3C0Tosmwen/S/QB6jLWmEW9mw9gF27rgb7k2bwNKGBQ5wa8cCpPuxhaEbah+a8=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785418818; c=relaxed/simple;
	bh=CqdqAdyJhzy8SAqPy+51Zf6+qD3v1I8nL6rt+WZzl1I=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=lwTKD3B7gt0wq/6f6FjKTcHl6GADSSiZCq4stJ34PPsOyO0iTLtfTMTY4HtkJ5+aBvcN0Y9SoCByiyLZbIKb12j9OEKlrt5jgKuqCb3Qt42nwdDa3oOuKjj/c9If/HmgQ9JcAB610UT+0rmZ4CjAYYJfqsOsjCJr4YH/ZD7vhjA=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=mpTwpuOu; arc=pass smtp.client-ip=209.85.210.48
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="mpTwpuOu"
Received: by mail-ot1-f48.google.com with SMTP id 46e09a7af769-7ebd88be784so1647094a34.2
        for <syzbot@lists.linux.dev>; Thu, 30 Jul 2026 06:40:17 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1785418816; cv=none;
        d=google.com; s=arc-20260327;
        b=p8Ix0jsMeWvrZNvLytsJpd9UqVlCBmyqT3j9Mf2JVQ66wFh8YBnSx8sehkfgMTho2x
         cLyuah69yo6RRzkZxc9Wp5snPxPFfSqaXKok3BvdmoH6DCTtB16nTTJ/Gb6/v+Dr6qX3
         sJbJviW2rHoDadOSx0n7fCKQAqKGgiBH6SSbPFL98tmv8Z9/3x6KBsjZX4QZko2Fvb+o
         17k6UxYh+P3DDgnSe1ov52JuWCOzqoKLHh90OGZ/PMloBUNbWR6+4n+8/LPjUJUFszIT
         gvlX+Iq5fM+ttQLK5vGIsA/CISVuJNf19e1TIS2UUwiRjCAsHxX62PuKN4v90Qw1Yb7E
         zUqA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=Pv7rrDR2XqGC2X7Ezzi+Jh4LSpjuVVPtj/SQaLf+UvY=;
        fh=vEI801S/EgA0NkrHqSJtsCPwnkUlem/o69myROalz+I=;
        b=JOGh9mB8HSwZ5gKuQ04pWT3y48qaxwX5a4aX29GL0QIqv+3o55prbiuGmi+eh6fO/1
         WJ+o0nvEfqJZ2NChUwCvsoXDItbkAd8pmAON/B6c0lk7+s7igA8MVtMCld/zTfFYlu4C
         Z1Xoqr0bEcjGSZqeql95bWMnVHZWCd1gzB9A/ipJwfNqZ5B2FsozJWqiu84O5hsSehlu
         tuEXSlVdA+p6HVLhX6MrgmpvXp7A6Zb4LB8Fx0+WW8cPVroQNnUPAqYTelal+2f0btx4
         70TByeV2JKXXWxwi/LMSHREuWn0/gaWrbuHSCjr5Mpbrt+crL3PJehO+nsxv3RIhruL3
         iF5w==;
        darn=lists.linux.dev
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1785418816; x=1786023616; darn=lists.linux.dev;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=Pv7rrDR2XqGC2X7Ezzi+Jh4LSpjuVVPtj/SQaLf+UvY=;
        b=mpTwpuOuXDAM8me/8qZ/pDNEUfnOaS5heENfFtatnbTJNYDXeG4LT2tUc4gSK8oR59
         JUIuQi1ism0GnxVMT6o8ioPSC77WMl2VcQYEUwiB1WlvfmRlBKGZvGgHFo3vofiaZVE8
         s8vvETvTIfVuMXtfOdQyIqHN1mPGv2kCRj0FnuHBbz2zXnkUYrz4aXjLSQxjMh7IqxB6
         BzheNy5awBPbjk4ba7CalWJXRuEGovcOL/WT3jsIUw5OyLrRbPx3sFwhuSiUgTIB41jM
         UkLE3h26xAlkkhBSOiz3rvtSuJk/gyxmqQ4HHtwuuRfNawMobxCYHspF60K88ekEH2vp
         w8Sw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1785418816; x=1786023616;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=Pv7rrDR2XqGC2X7Ezzi+Jh4LSpjuVVPtj/SQaLf+UvY=;
        b=M5Ur8TUKLFrr9BxJE32PFoHSelgisNbDf2vW3TxS2/9vh/0emoknN9mjCrR+UUVO2v
         EU7Q7C0xAHXwTnfbvCHK02vW4sBggQTFEnxBWloo4gEuxAOQThkDwwAYoGY3zol/yE+o
         YRudEsGoiOCVs6cMIynWwtYqlAE+yjjX06nc7on5kxWR6gP+AR1LsZVcg4uU9SVLAYiC
         v3a43aMAc9KapXqunOcQO+92vpZIegrPhTYwwH2dXu/KU6S6UYJZDRyunMjAkMoWkz3m
         Nns58JytTQ/7r4CreeMBJVvv1Z/f+pjd5SHDtXMsMMgGAG9kfIPzegfM/1QCf76enut1
         sTGw==
X-Forwarded-Encrypted: i=1; AHgh+RpKNkTZUYFmNaLSo9IGaciQ9NapMmUde3zR1QYpFvAOH9RCPLC6gXcCiLaAI6TS7dB5M9BkDOw=@lists.linux.dev
X-Gm-Message-State: AOJu0YwqVdKWvI7MMmJJv6M6tD3d++E4/AwrjUHzjTD2nN21F36/+Rv6
	ubFekRadeMJYs3XwiYKO2p2f2jEPmPcbWPxvxUYJOqcKkJdM2RHFVm1BvM3Ias7pF+VwIjIiV3o
	5gzvGTRS75sjoRr1O05oIfxL3pmUhBmWxgUscItrl
X-Gm-Gg: AR+sD10CmZLdVnEURSNiUpqQJzFhGNrZfm//fooxHEwK6bPQkusfNOUqyFw0yATU1t1
	U0RRVPJmGpDwF6p3/S+HjeFK9aeI7Vfnkp0jKnxybbfTyKDyhlj8G3Q88qFNBGpIfkXJfiGzAbY
	JNBHL/Vb9vyzF2MKWF2rVbgDfMtf1pn6sKXzIKron3C+72Kuo7SaTbMpUkdkbMr9Q5ovDphtGr9
	zn5duqormblB/I8Rd2hFkGPMZpjJciEKUVz+xEJIzT466EK8WfvGdpVKFe26FYrQBtEiDwhhYGn
	IkbcJ5cdYIdXT+qQ6MsFlcJ/PC29Cn4ZbWDE2zBDZcv+ZKpZ2lGM+uHNw3Zmi1Sq7CrMfVbZ8Rp
	rUiXgujC0SBJAxc04RcMJw+32QTPm8c/X5p1TgIXeBBw7zdZD7fNfVwESWZE9Rk3GWa+ks1hfgb
	UOP4q97loFwhW+
X-Received: by 2002:a05:6808:f94:b0:495:e5a5:d62 with SMTP id
 5614622812f47-4ad8780d6f0mr1753556b6e.6.1785418815703; Thu, 30 Jul 2026
 06:40:15 -0700 (PDT)
Precedence: bulk
X-Mailing-List: syzbot@lists.linux.dev
List-Id: <syzbot.lists.linux.dev>
List-Subscribe: <mailto:syzbot+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:syzbot+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <6a6a702c.57649fcc.360844.0005.GAE@google.com> <b5e3e5c81ebcbf4f6a793b89463e4979fc7cba4d.camel@infradead.org>
In-Reply-To: <b5e3e5c81ebcbf4f6a793b89463e4979fc7cba4d.camel@infradead.org>
From: Aleksandr Nogikh <nogikh@google.com>
Date: Thu, 30 Jul 2026 15:40:04 +0200
X-Gm-Features: AUfX_mx3aT-Hp6Q79evErdovScYwuByvd_VePZhx5h0dgfZO54E0yocQbFwcJGo
Message-ID: <CANp29Y4TTLG-=O-Vd9D_7t04RbUOqhLQUbuCUgRFdphq-DBf7w@mail.gmail.com>
Subject: Re: [moderation/CI] Re: Cleaning up the KVM clock mess
To: David Woodhouse <dwmw2@infradead.org>
Cc: syzbot ci <syzbot+ci6e398c6b63e189f8@syzkaller.appspotmail.com>, 
	syzkaller-upstream-moderation@googlegroups.com, syzbot@lists.linux.dev
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Thanks for triaging this report!

The CI did recognize the base commit, but it didn't know about the
kvm-x86 tree, so couldn't fetch it.
I've added it in
https://github.com/google/syzkaller/commit/285e8c809b7ce04c728f02b57698320b=
cc0efa48

--=20
Aleksandr

On Thu, Jul 30, 2026 at 10:36=E2=80=AFAM David Woodhouse <dwmw2@infradead.o=
rg> wrote:
>
> #syz invalid
>
> The series (or at least patch 01/36) was posted with
>
>   base-commit: 271255273d5ff348fe29d89fe4712b2f7f7907c3
>
> which is the tip of kvm-x86/next and contains the timekeeping
> prerequisites (ktime_get_snapshot_id() et al). The CI applied it to a
> kvm-next tree at a204badd8432 which predates them, hence the build
> failure. Wrong base tree, not a bug in the series.
>
> --
> You received this message because you are subscribed to the Google Groups=
 "syzkaller-upstream-moderation" group.
> To unsubscribe from this group and stop receiving emails from it, send an=
 email to syzkaller-upstream-moderation+unsubscribe@googlegroups.com.
> To view this discussion visit https://groups.google.com/d/msgid/syzkaller=
-upstream-moderation/b5e3e5c81ebcbf4f6a793b89463e4979fc7cba4d.camel%40infra=
dead.org.
