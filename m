Received: from mail-ot1-f44.google.com (mail-ot1-f44.google.com [209.85.210.44])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 81AC33FC5B1
	for <syzbot@lists.linux.dev>; Thu, 21 May 2026 14:30:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.210.44
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779373838; cv=pass; b=Pjq/TEimW2NpO2IeOuNzsRRXC7lWpfgBxsfuIkJV/dQXkUhKKwe0Tt1O0tlGRFCYX3q0Hxi7/QFTdXe5IS9t4ONGtG19AVeI9zD6dhbHxUh+JoSHgkplpEho9UPwDgkjCuqfPC4cH3nWJR+ah5O4KbseeFPlOZG/OeBOkGqxf3E=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779373838; c=relaxed/simple;
	bh=bWmO9DpBwMqIRd/PI6paYvWCHyez1DaS/ETzLX6Lab4=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=PcbLb26Nc/JqZrDLKQI0p9gvrjcWoEKSSirgHOmyF5qL7ijfuAal89z19+anXCZCxCyHxpqCIeatfcD0oLXBwlkZMIlQq8rv4q7ZuPnP09VpfvM99Y/xyq644JgGfdwa26/FW6JUMkExntCk5X4AQGF+24UTjFsqZacXHqrFKOQ=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=akhaiQ5d; arc=pass smtp.client-ip=209.85.210.44
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="akhaiQ5d"
Received: by mail-ot1-f44.google.com with SMTP id 46e09a7af769-7dca00c1591so1760444a34.3
        for <syzbot@lists.linux.dev>; Thu, 21 May 2026 07:30:37 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1779373836; cv=none;
        d=google.com; s=arc-20240605;
        b=Y97P6tlxl47zvpevG46/wd618Ak06V55luws3S9DVjDmmIFESFJx8MhRnhYfNExy8S
         pt8Ks6gDMMzvUGPrsZJHWcc8sQiA98fhTxiLVyGYFgsICJiyz6vO9iXr1OMRuCCg1YSF
         bRZ/WPBE5MuNABmKSJb8NoDNScBj7FKFg6Pg1nCYdtON+lqOUIPrGhNlP+YU+Wwag3vH
         XFV7GVqjhsV0o6Wg9qkYXw30QXGf5cpZN7SfB6+9o02ML0R4MJ0DK7tIONWOe2joW3rG
         yYal5TBXSwyJaqe5vJuNtcFCaX6J9v38u+mg839UjiNd38j7lDdNa7BA5BrWDEY4EO5b
         D/9Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=PgGLIiyJ8wE3DdIjs3jsiwgS9kBz5mfj7Sj7VdRRb1k=;
        fh=eSPD2RPku7NW9Qd2WFmyKyhjwUsRC1fqwdA6w+yuBak=;
        b=fQIUIEoxQioVLsm/POA5Juv4TELAjbs4temEWTe/LZZhMwdi/VNB2JmsiAV+yaqnRq
         hRgKGGcAAZWIvQqBHNCpYfSGl74oLJp/lYom0/uv7LZTm/ll1NsQ2u/CI7cR1T785F7v
         BOUj84m108V3INhWHf3g13EIpX0wXk/fj/hc2/X1GLXDsybRW6B+01DfoPD0CfIHXOYi
         DKiBHiPv/TcrN0osTt7FyWGYkHfszZrAWtmFWaV3AFAj9qBjvGC0ou7FtoHo65Do7cXB
         gEgb9JpngQyVXKD2jClWBBSaSUsb0BWefbBPocC8djBgA/RjO2v82NlL3k6BrR5lPemB
         seyg==;
        darn=lists.linux.dev
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1779373836; x=1779978636; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=PgGLIiyJ8wE3DdIjs3jsiwgS9kBz5mfj7Sj7VdRRb1k=;
        b=akhaiQ5dI27uJd3I0W2yCuNZg69WvfsiVtwco+nX75VYkj2ocDd1lOPAS40oa+rfiP
         zJY+z/U1dEVWllXPX1MHzSwMDsxEGZNU+cDrIVHVdYm6nL2h0m9namLWMEsznVDgBpC4
         9YPd9810BA/+1cM8+WVec923tNmTgVOcgYjumt2vWP+bBpK+Qm314bbfXy2g7/lEj76l
         BmevocZKfKFQHpU48Ry5dRvwmWwk5yFVPCdAImT/aE4qdH+CqLOz11+0q8rAZ6YtkmXf
         lSEhdW6AYaofJ7LJll/AX7gYv0S7y7QC2OxE0itYhusSUSOFLPIo7z3/XGDCvjzNjrLJ
         GKGQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1779373836; x=1779978636;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=PgGLIiyJ8wE3DdIjs3jsiwgS9kBz5mfj7Sj7VdRRb1k=;
        b=rlHYDikVy0GR3wWsvC+GcKhZR6IKLB1k2GT1q0YGEUAAZ4QzPsN4yK+xrCiMHq0Xal
         4o0p0bb/+anGveIlVyt0Y8iw94EmR54mw2oKwjvzTm6blrrotrvrAarcqVMyTbphyRIg
         MgmU7ivrIVO7K7UtkzpQvpwWV5HSBAuux8xSELgoy2yPaePrdab6p2q3/kGdA18kkr8u
         av2EXVtgbQajbrpDiykKlUmGVX8b7BvcfQtQ5u0d+eUolGftOcBFEF+3WdFPWH0mp7qP
         rGWY7p7xMRYT2yVpZGG8pBh6xzWYf/keQKXXc0yJKlStWpBFc1n3Ei+Peo1ZS4GpaYya
         ul5A==
X-Forwarded-Encrypted: i=1; AFNElJ8TqRYDf0BtVonqHbSeIuk2Up+JOeLaDZ8ZQd/Id7Zyjsxz/d4OZyhqboPCxMXr8kHjLUgajS8=@lists.linux.dev
X-Gm-Message-State: AOJu0YzPrIj+4c4GHE8/m49pnyX4VbpoOg/lSu9nSJHdynVLMyuCViMr
	6KyOT2bRGwetV7eEeo/PHbHQAXpmPUuQ8bIIxH1g9yfLO46/FdQl5tv/oLjYpYLt/sOiIo8fgkT
	Vr3I5nDHMzR5jvBbvG+xdGcLFMnSU2SnfFOiE3BAF
X-Gm-Gg: Acq92OGATr4iXsrNKTJuDp/S/bIAcOwsLr/XXHMMVNhusHyV00qjzd6aQsvRyP7/Cyu
	WL+bnsvVe7OQI2wFLLdCDQpTvlt2iN+1mZX8YPysaE/tiUdyFQy79aXxW3mTGVUgWJnJvv0fbKM
	qdwWGtbt+WRiPGe+JqXJiT0ngq1EdC/YAxzDqYh53qU9wOG4bFt4CUzXJSCWrETSH7V19l7ZNeD
	TVnfSGJQIDGHTew7k5h1Kee7Hjo/HPXcMATGTW7ayKytFbFDzO87B8BCTUQUrF+jHWFR0zbaOwS
	U8vKzBWNL94yVdxIdXnerff33NcmHo13EcurITp+gyxWu5mO+Iq8nGAG2SQ1i68xbx/dl1HOWi+
	MQKOI
X-Received: by 2002:a05:6820:f036:b0:69d:6696:846e with SMTP id
 006d021491bc7-69d6eed271bmr1224802eaf.29.1779373835978; Thu, 21 May 2026
 07:30:35 -0700 (PDT)
Precedence: bulk
X-Mailing-List: syzbot@lists.linux.dev
List-Id: <syzbot.lists.linux.dev>
List-Subscribe: <mailto:syzbot+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:syzbot+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <36638f2b-6f91-4e33-b630-fd7045eebc84@mail.kernel.org>
 <20260521-kultur-zahnpasta-f09198836179@brauner> <CANp29Y5Cjy6k2vLp2+2O9FXwRXAmNP_ja6seORVXVQnrdUwH3g@mail.gmail.com>
 <2026052159-conductor-suffice-4c81@gregkh>
In-Reply-To: <2026052159-conductor-suffice-4c81@gregkh>
From: Aleksandr Nogikh <nogikh@google.com>
Date: Thu, 21 May 2026 16:30:24 +0200
X-Gm-Features: AVHnY4L69FM7sqFXS0wtxo-zw9uwRckpjr5S38o0a71LtHBSi-Rm4Zdrfb_AQEc
Message-ID: <CANp29Y4Pe5Skz9A21ksAymybgyVhHgpaQJ38UTX4=+YLvzoMgA@mail.gmail.com>
Subject: Re: [PATCH] signal: clear JOBCTL_PENDING_MASK for caller in zap_other_threads()
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Christian Brauner <brauner@kernel.org>, syzkaller-bugs@googlegroups.com, 
	linux-kernel@vger.kernel.org, syzbot <syzbot@kernel.org>, adrianhuang0701@gmail.com, 
	akpm@linux-foundation.org, kexinsun@smail.nju.edu.cn, oleg@redhat.com, 
	peterz@infradead.org, syzbot@lists.linux.dev, tglx@kernel.org, 
	Dmitry Vyukov <dvyukov@google.com>, Marco Elver <elver@google.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Thu, May 21, 2026 at 4:17=E2=80=AFPM Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> On Thu, May 21, 2026 at 03:03:35PM +0200, Aleksandr Nogikh wrote:
> > (+Greg)
> >
> > Hi Christian and Oleg,
> >
> > Thanks for reviewing and accepting the patch!
> >
> > However, it seems that we first need to clarify how these types of
> > patches should be submitted to ensure we don't violate the Linux
> > kernel rules regarding AI-assisted contributions.
>
> The documentation is very clear on this, what is missing?
>
> > In a discussion under another patch by syzbot [1], Greg noted that
> > syzbot cannot be listed as the author. The official documentation [2]
> > isn't very specific about how to handle this exact scenario.
>
> A "tool" can not sign off on a patch.  That's always been the case, a
> person has to take ownership and responsibility for it from a legal and
> technical point of view.  Again, nothing new here, been this way for a
> very long time.

The documentation was very clear that the `Signed-off-by` tag must
belong to a real person and these 2 patches actually did have such a
Signed-off-by.

We've just updated syzbot to also add a `From: ` tag with the
name/email of the person who pre-reviewed the patch and approved
sending it to LKML.

--=20
Aleksandr

>
> thanks,
>
> greg k-h
