Received: from mail-oi1-f174.google.com (mail-oi1-f174.google.com [209.85.167.174])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0B23926AEC
	for <syzbot@lists.linux.dev>; Mon, 22 Sep 2025 07:58:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.167.174
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758527904; cv=none; b=Jxb+cOTniExLRCqoxl08+1ZFZ4LO3xaqUGFc5Eikm4zLKFavhwHVwEPVAEvh/b6n4crLXylAruFDpBcdpLuegrn4kky57c+4HqNXlGMg8GDNhs8JFP66Yc3t+mfyHshFtRn/ZXDfU5tAfetcAFtuAbsVeosJptBZhv/z2WkTp40=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758527904; c=relaxed/simple;
	bh=HTNUj1N4/rHopqWeYeINmgos2Syd2I3wUp8ZHmKexyk=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=i4o9sEiPPSHJfpcUCEipZaCyan4RnR+msBeUjgZAdml2JpMQw72ZlHMoSCtg1B3biIZQfamy25OLpnJ9T0UvNG8Tz+SLxC6DaEQS27+Z8D8gWks0GiBColQjppnSYTbXgxHzD93MQ175OzYY1DI6LPvaPD5ecveA1WbgIh8P0pM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=phYR6L/Z; arc=none smtp.client-ip=209.85.167.174
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="phYR6L/Z"
Received: by mail-oi1-f174.google.com with SMTP id 5614622812f47-43d271944beso2186258b6e.0
        for <syzbot@lists.linux.dev>; Mon, 22 Sep 2025 00:58:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1758527902; x=1759132702; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=oahqWdT4eJWKdEhecbMn96m+F3MRAL5sNNVQ7KistOo=;
        b=phYR6L/ZVgQv2JeOPGRlE5E6NdmtRncgt910Vewu9ubRzncHvZeKgjreanWm3XgwPJ
         Wr1FaHc8+ruh2McKky+WRVSCxg+J38KFhfkhR1KSw1m03EmbxH5M2kYk8aPP0xJhcbcn
         mmNWyaL8L1GjmQ3bziAm9qYU0stYbgTU/sLTwu9FbLC0G0Sr0wNsCzF9gKgdsIbAjxgJ
         CIz94ylFFsuVT47O8AgYFDMAlpmLlrkzrF7OJOG8eEZL2mwd9jUJce62JKaosa+8Mte/
         E0VCDFWIWo1jmAITJjJ6R+1iRXAO4poNYO/RkCu1qbzRUP84CE/PdgGAYPYv+B9Aun6W
         VBmQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1758527902; x=1759132702;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=oahqWdT4eJWKdEhecbMn96m+F3MRAL5sNNVQ7KistOo=;
        b=RT9nz4cmBQSl09JvT08P8ZE26xz33P7IgOfk/PndkPovl8ZJGbyIm9fGifzH87Ltbd
         YXYToO74YeLqqeutbBJ/3QYCOV/3MyNGdSPqFl50uazuxXC/N94VsUK79lR1vW+RrqoH
         FpVp/lHyGChTpHlvqPSbTTwQWQdx0yDt4ShHtOvrjYoxBW5U4gopGhYBhO8E2EHUt6xU
         wUQL5aqsssPH9l+yX5YjU4EwjDnD2/1Jk/clT+HLQq4PgFRkUqju1xMoVBke79DXs+1o
         S9tsq6maFoizZPYxCWoOtRSI5arjqiY1nPIdTAnbDDmH1EDiyHRiXUQW1dj6EW6jagyV
         T/fg==
X-Forwarded-Encrypted: i=1; AJvYcCWzz7xEiH4KDUzwENRg0EXX/gK8rsFdf2G0BAE63R31wp0k2+If8OOex87thu1+XAAUmADNW7o=@lists.linux.dev
X-Gm-Message-State: AOJu0YwrAUOyL0+3bBHTTddm+5pr1gPg/njGqESDM+kP5B3GFL5MQTY6
	iizkKgdG7GyoB/okEnpD2ToChJXq7HmoxPP8o4hjn2Ks9WzmAMWuZIqQpsLYZJdcnQvY3KPfpxZ
	gxXe+s4BsfMAH1zMiwTk6wQTYmpagzsWzpzIZ/CZh
X-Gm-Gg: ASbGnctkKhn0Cs4V56a1FDWtw4zt4VofwHT/hIjyqUcOJtJOQ06OpP1LNOnIUkCuLNQ
	+GGqiCB3NPjYQ4bUEzR+tpoNhgmPUCnuyOn+EuZizFYn2k0QMiLgfWT6vMpEMy93ULhVwFeiXbt
	EzQu48tZQt/RCuqaZDJwzNRpo40VwA+eemmmQxd2EE6SfZJWGAHoNn/2snB12qFcoNRyGS+9oDs
	LIZ
X-Google-Smtp-Source: AGHT+IF8RmArNn08xqgz2YL++Bkd1waSXT6QYxQLrepHMkn220jZgScbG31ZDE0t39Xo6Z2cBJvnXWgH9psMC4tPY90=
X-Received: by 2002:a05:6808:4f1e:b0:438:398d:b262 with SMTP id
 5614622812f47-43d6b72b33bmr5873578b6e.8.1758527901672; Mon, 22 Sep 2025
 00:58:21 -0700 (PDT)
Precedence: bulk
X-Mailing-List: syzbot@lists.linux.dev
List-Id: <syzbot.lists.linux.dev>
List-Subscribe: <mailto:syzbot+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:syzbot+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <68ce3c87.a00a0220.37dadf.0025.GAE@google.com> <2ea0ad29b6956b7d5b812d688b9676e1824dad30.camel@sipsolutions.net>
In-Reply-To: <2ea0ad29b6956b7d5b812d688b9676e1824dad30.camel@sipsolutions.net>
From: Aleksandr Nogikh <nogikh@google.com>
Date: Mon, 22 Sep 2025 09:58:10 +0200
X-Gm-Features: AS18NWCEcgDFLsPjMsqTcyYqoT9kdjid6s7FWOmr5KWPuTbUV7k9nx3w9J0JWwc
Message-ID: <CANp29Y7T6JRHjMDZZN9UpcbJB0vwkuq2pJv+54VvFJRh5NXL7Q@mail.gmail.com>
Subject: Re: [syzbot ci] Re: wifi: cfg80211: remove IEEE80211_CHAN_{1,2,4,8,16}MHZ
 flags
To: Johannes Berg <johannes@sipsolutions.net>
Cc: syzbot ci <syzbot+cib69b4e10bd070489@syzkaller.appspotmail.com>, 
	lachlan.hodges@morsemicro.com, linux-wireless@vger.kernel.org, 
	syzbot@lists.linux.dev, syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Mon, Sep 22, 2025 at 9:46=E2=80=AFAM Johannes Berg <johannes@sipsolution=
s.net> wrote:
>
> On Fri, 2025-09-19 at 22:32 -0700, syzbot ci wrote:
> > syzbot ci has tested the following series
> >
> > [v1] wifi: cfg80211: remove IEEE80211_CHAN_{1,2,4,8,16}MHZ flags
> > https://lore.kernel.org/all/20250919122325.f0abcf092b9b.I04478fde87a79c=
7909f1cc4249430deaf71e8bd0@changeid
> > * [PATCH wireless-next] wifi: cfg80211: remove IEEE80211_CHAN_{1,2,4,8,=
16}MHZ flags
> >
> > and found the following issue:
> > kernel build error
>
> Hmm. I don't know if this is really useful? The 0-day bot does similar
> build tests, probably more comprehensively, and
>
> > tree:      torvalds
> > URL:       https://kernel.googlesource.com/pub/scm/linux/kernel/git/tor=
valds/linux
> > base:      f83ec76bf285bea5727f478a68b894f5543ca76e
>
> unlike syzbot, I'm pretty sure it would've known not to attempt applying
> the patches to Linus's tree when they were destined to wireless-next.
>
>
> IMHO there's enough noise already, this only adds to the noise, not to
> the signal.

I'll drop reporting build errors from syzbot ci so that only fuzzer
bugs are reported, thanks for the feedback.

--=20
Aleksandr

>
> johannes
>
> --
