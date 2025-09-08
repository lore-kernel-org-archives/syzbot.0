Received: from mail-pf1-f170.google.com (mail-pf1-f170.google.com [209.85.210.170])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 17D66314B84
	for <syzbot@lists.linux.dev>; Mon,  8 Sep 2025 18:00:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.170
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757354428; cv=none; b=byZZo6U6xRF0euTo4YdDzmSoVoSJS928O0s+M5gcyO8Y0LH8SF1cp4WM9dlbEsooJaY9vG8TnGNgm33DWKgg/m5igJ9gnYs5PFmIfZ0MHNfo4Vl8K9xt950sRn/Mx5/FAvMoXQfeEgrF6T9Kq/zxGynim1mYlS9BHUWt6n31YyM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757354428; c=relaxed/simple;
	bh=ArDTteNm9MOJDVPm0MPQ+3NkywvOOEVcIiDftLs6Ycs=;
	h=Message-ID:Subject:From:To:Cc:Date:In-Reply-To:References:
	 Content-Type:MIME-Version; b=Mq0nC9+Nx+Z2kWaNs8jmKdc74Kt1mG/EKuX6ea7JQ7gB/D6NgRLRrwaSdxme2ITBf27sXPawXI2A6AKNW2Nh0m9qVoc4hamkH0vwhOYICLvKlANUjYzKjZ/Nvk8UqsFNGvcLRQbZZCqxMvP1QoyZZfA81xiV95LHjKHTiZN6J+4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=a3lVkjHF; arc=none smtp.client-ip=209.85.210.170
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="a3lVkjHF"
Received: by mail-pf1-f170.google.com with SMTP id d2e1a72fcca58-77256e75eacso4218445b3a.0
        for <syzbot@lists.linux.dev>; Mon, 08 Sep 2025 11:00:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1757354425; x=1757959225; darn=lists.linux.dev;
        h=mime-version:user-agent:content-transfer-encoding:references
         :in-reply-to:date:cc:to:from:subject:message-id:from:to:cc:subject
         :date:message-id:reply-to;
        bh=ArDTteNm9MOJDVPm0MPQ+3NkywvOOEVcIiDftLs6Ycs=;
        b=a3lVkjHFpElY4zWQ4mQ/31G3rRQNM2fnQbuHE8x8lJtN4cEbUJQ8bpEyoQ2iOqjYdN
         nzC3SamwuL7PQGUugQyxEvaR4QLfoTVZ1KtdzZHwDmHE1V6nrhxOcuH2oB+URqysQA9o
         Tj9wq/VdQMzJPYXNibkcnUugKOSEwTHbECZ1kckTWg1z8yDKPXdtaXTet4POKg2issL6
         LmrgPTfWKFBb+LAhlTSNJdaYOXS8bhh0o6CaxxGnXkykhza6C+FOZbj8kbCPdBJ7kTUq
         FGcBY/MH78YCVqfkOeY7p4JLY+pMyJBEu9TkeCPmHYyrx5d0KSL1ExP+okJ3kb4wXWeL
         aNlw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1757354425; x=1757959225;
        h=mime-version:user-agent:content-transfer-encoding:references
         :in-reply-to:date:cc:to:from:subject:message-id:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=ArDTteNm9MOJDVPm0MPQ+3NkywvOOEVcIiDftLs6Ycs=;
        b=oJgRh/4+U2TE+78DbfyETTxHWUX40NVg1KaMZKJPJoLWqbZN1dXN0u5TBMKCWLWUkd
         /vFuy+L9mZzInP0MA+EvE7lF5iKBC/b3+N8yGC5sCC7cwpSSvohvUN9RieJ6UjKX6SUK
         NiVQFxk5bEw5DCxtlgksGbClXnuRJVjVJYxLigfXbgt/Fbh4clXZ/sNnT+bCrX09YYfX
         x5CpGx2i+k3gnWWQsWS2iAaah0v+GYHkPTFtqU/U8hnGJ78QwySAHm1ItgcOi/l3aR9b
         SL6l3/9Rw5fPmTxtmA8d9ozGG3g7YJmH0aOME/A05Qt92AUmUoicxDYD2Z8sFVCLR/V7
         YGwQ==
X-Forwarded-Encrypted: i=1; AJvYcCVNg+wLSPVNgMEDEgvcIGs5vjkawpNS0Vwp1XuMrF1PF1wBfLgt+Xj/W2MmosK8O0ekhuy/8MI=@lists.linux.dev
X-Gm-Message-State: AOJu0YznpfxZ7FUSeRqkLuM4tzCwsn/o0yIrGvJzPBk8FVJhJPORhuYj
	tFtRQpNsaJnaw8yYnMA0HN3O3zOYr89jd3J1zq+TtIZ/EjvdrPTRBlSl
X-Gm-Gg: ASbGncvZWjIy6UafQyMt4186D60CzSYdWyjGwN7iDhfmG1MMjXd3ju1EZK4+xJO4a2o
	9l0kJoT7tHj07+r2t8MrdXV66F5TMffJAkd9Q+NOVPm7TUzMhZnDTft6PJXUurRwe0SgdgS1wja
	jGtgq9SBwuh/LOgyzQOiRTkIB2AR+1aCyZ48rvPiOiHbSttuz6qhzD3lYtqaH2IZCLHIp9RL8l8
	QTRG9qN9c6bFkAB1Hsafh5d3LIiQilwmaqeX/d+pahJsLm7xC2JpsXPOx07T5mNMLyqjpvd2s8r
	TY+3U/RmYzZ8eUnsg5fuJGtQarZlX5r0C25JP7LVXXR/OhYYAqmfwZal3HlqMB0dXaWLlnxyRZT
	Ww/P5qME4M492o69RgrBOzwhvlE+wtc5nyTPN0RfVIUlNUXSbmBXkhC30EQ==
X-Google-Smtp-Source: AGHT+IFl3A0tiSOO5sy0VIt1JcTPBYLa2cCFLc7gVDg0bmBFwaXmHwmc7qbYANpGSHd7nm1EalPsYQ==
X-Received: by 2002:a05:6a21:3384:b0:249:765e:d650 with SMTP id adf61e73a8af0-2533fab757fmr12183868637.27.1757354425113;
        Mon, 08 Sep 2025 11:00:25 -0700 (PDT)
Received: from ?IPv6:2a03:83e0:115c:1:613:2710:d29c:cd12? ([2620:10d:c090:500::5:c621])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-7722a26a34fsm29580459b3a.6.2025.09.08.11.00.23
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 08 Sep 2025 11:00:24 -0700 (PDT)
Message-ID: <cf36f407713920055fcee1e30c007d23a117e712.camel@gmail.com>
Subject: Re: [syzbot ci] Re: bpf: Use tnums for JEQ/JNE is_branch_taken logic
From: Eduard Zingerman <eddyz87@gmail.com>
To: Paul Chaignon <paul.chaignon@gmail.com>
Cc: syzbot ci <syzbot+ci59254af1cb47328a@syzkaller.appspotmail.com>, 
	andrii@kernel.org, ast@kernel.org, bpf@vger.kernel.org,
 daniel@iogearbox.net, 	shung-hsi.yu@suse.com, yonghong.song@linux.dev,
 syzbot@lists.linux.dev, 	syzkaller-bugs@googlegroups.com
Date: Mon, 08 Sep 2025 11:00:22 -0700
In-Reply-To: <aL8XJI_gpHjjvX7o@Tunnel>
References: 
	<ba9baf9f73d51d9bce9ef13778bd39408d67db79.1755098817.git.paul.chaignon@gmail.com>
	 <689eeec8.050a0220.e29e5.000f.GAE@google.com>
	 <aKWytdZ8mRegBE0H@mail.gmail.com>
	 <6d172613960339eff4b3a9261ef61a2c50f69dae.camel@gmail.com>
	 <aL8XJI_gpHjjvX7o@Tunnel>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.56.2 (3.56.2-1.fc42) 
Precedence: bulk
X-Mailing-List: syzbot@lists.linux.dev
List-Id: <syzbot.lists.linux.dev>
List-Subscribe: <mailto:syzbot+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:syzbot+unsubscribe@lists.linux.dev>
MIME-Version: 1.0

On Mon, 2025-09-08 at 19:49 +0200, Paul Chaignon wrote:
> On Wed, Aug 20, 2025 at 12:37:46PM -0700, Eduard Zingerman wrote:
> > On Wed, 2025-08-20 at 13:34 +0200, Paul Chaignon wrote:
> >=20
> > [...]
> >=20
> > > I have a patch to potentially fix this, but I'm still testing it and
> > > would prefer to send it separately as it doesn't really relate to my
> > > current patchset.
> >=20
> > I'd like to bring this point again: this is a cat-and-mouse game.
> > is_scalar_branch_taken() and regs_refine_cond_op() are essentially
> > same operation and should be treated as such: produce register states
> > for both branches and prune those that result in an impossible state.
> > There is nothing wrong with this logically and we haven't got a single
> > real bug from the invariant violations check if I remember correctly.
> >=20
> > Comparing the two functions, it looks like tricky cases are BPF_JE/JNE
> > and BPF_JSET/JSET|BPF_X. However, given that regs_refine_cond_op() is
> > called for a false branch with opcode reversed it looks like there is
> > no issues with these cases.
> >=20
> > I'll give this a try.
>=20
> Hi Eduard,
>=20
> Did you get a chance to look into this? syzkaller came back (finally)
> complaining about the remaining invariant violations:
> https://lore.kernel.org/bpf/68bacb3e.050a0220.192772.018d.GAE@google.com/
> If not, I can have a look at the end of the week.
>=20
> Paul

Hi Paul,

I have an unfinished branch here:
https://github.com/kernel-patches/bpf/commit/ef2e080a58206e23e3a521d2942f9b=
4d58a8627c
Don't like how it looks though. Planned on getting back to it this week.
Please ping me if you'd start working on a fix.

Thanks,
Eduard
