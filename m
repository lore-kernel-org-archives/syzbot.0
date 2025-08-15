Received: from mail-pl1-f175.google.com (mail-pl1-f175.google.com [209.85.214.175])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3AC36307498
	for <syzbot@lists.linux.dev>; Fri, 15 Aug 2025 15:43:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.175
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755272597; cv=none; b=AKOZDf0PGxQVi0zuTWiiTfP2P11cXMh2lKjlMdMwTLA6/Ta3Jo+ulMtABMXzyQSeKWeRfaIJRfo8Ufp6MOkUccgXvqkml+QhfPa7tWz+Vp3jWqD+4xLCV7o3tqp5WUIV2AVdOcLLzRl1zmnPiQCO+IORB21AQnY3ytAQF3mO5ZQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755272597; c=relaxed/simple;
	bh=oeSalf/yLwgjR0IO65N9CQyedrwdJmUBVZlN9f6Yfqs=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=Duj8rmfz1fAjhwEXHqx0zqCiG88uU82sC8DSgYe49v1gojOKZkNdkALQZEQYed4QfzfnfoQW4wLpfJiTGryoVSrJDEAx6nB0tSu10YnpRqxpAcjiIB0V/gF4UZTEggXkCB0Eo6eFhgjKdz1NnA7FFuJ2jDSOQAie6UR6FOuPlEg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=nqcSEWP5; arc=none smtp.client-ip=209.85.214.175
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="nqcSEWP5"
Received: by mail-pl1-f175.google.com with SMTP id d9443c01a7336-24457f47000so18295265ad.0
        for <syzbot@lists.linux.dev>; Fri, 15 Aug 2025 08:43:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1755272595; x=1755877395; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=buVtBGpVO2qFuCJLRA/MQVbYJ8Cn6PLF5emLFEWzGB8=;
        b=nqcSEWP5OHzlZpcRL4cRZ3rQzD2wmfAWQFm6LXrvz7O44PuLaGcF/B07OKaGncilwQ
         vTC/Z7Srywmlt1YyDi/4W+lPKGiP7V75Hh+H41YPYbvcvEjb72S6LaTPM8UxnQLY9T9I
         tUWmwUSYF10oVSFgNGYHjwbeTCYmEmbDXUuEOUvWet0KLIVvLd+zOlZ8o5XsZBA11P/m
         v/ypABCEgJX3D+qfwzf6xEv1PM92tU5s1FbFYYpI7RZ/7xt9jFympGHnxGdKFK6XeCr0
         m0eZPaeTPT9IBSsmV3nksJmQZYvFIlgJhrmO25UAhejHqIFYYF3E+0y8TtIZ6gL8z5lj
         1d0g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1755272595; x=1755877395;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=buVtBGpVO2qFuCJLRA/MQVbYJ8Cn6PLF5emLFEWzGB8=;
        b=cVtZF+/pX2G+G9Fl1lJ2ytM3KTDRWmvRngcAocjtrfIQ23JnSgGdJj7ypv2+n87qdt
         OZcVwSW39WQ6onI7TiII6tsEEIEV8fg3ufCmMtVvpdoK10N36mgSOc6Ot7aSDa/QYQ9V
         eP6XKd4Sphxv8jxiD1TfzR7wYd+UsIWr4UHpg8BWISEWsLQL6nh1aX42t52/ZshK9VAK
         bi5nsUM1oN0gR5fjN6y5RqihH3jpKQ97g7s7stvuaUsbt/D0eU0T7oUT5v2ZB1zWDNwX
         12ES7L/sGfe88DJxKopm2NjpAS3B80rndk1cUBrWuXtZSC9s9ZISQYaR9nA/LU9h3vay
         DQCA==
X-Forwarded-Encrypted: i=1; AJvYcCWvty2j1k/d31FXswwxoLdq26QpPjtkK8NaVC8e/jMlDphFIHmxKZdQOfnxMD+LRNHBcHNFi4I=@lists.linux.dev
X-Gm-Message-State: AOJu0YwBd3tUI5oGzUu71+KuFNP3dPpxex0utblOMMDZS8T6mkXIUzsa
	jaAAKUKVEee3EDxmx58DO0755NyH0erq2cuAqqqzeKoB9BF4TGOTk/AAbCFK+O/hVRx6l/zct7Y
	qnVMFPCOhSeh6np+iKQ7L9pKfzSMDfDrU40VI0aHH
X-Gm-Gg: ASbGncvAs0CX15FSUMDY/bEKzmmd0CVOpY+2X9aDGOvhSEqcpj4w4WJlfiDKqNvOhOa
	iU9/mLK9ZLUmGxu478Dq4W9Ab+LjclRua3KzC0lrWxFsRC6lZfLe4UZIq5CGxFWZbd8rMji/K5w
	riF6FPOeFwFsW1BTWYxjZQu2eZ38owm+UBm3loNaLI2xvwywlca1yrzz/m3jZ45P+0F/mHFsM41
	m36B0SFshspTZuk2f5Fe0KcJjbs+s9xX7Bn2lV6NNVyCw==
X-Google-Smtp-Source: AGHT+IHLN1XcC4qoFNA2fwnUs0VOxxNCeh0+rqp1dIs2ILG4ZYpSyxCFz5Z9x+hJrPTx/BfQ3rEN3ennhyaJk7Nlv5c=
X-Received: by 2002:a17:902:ebca:b0:23f:fa79:15d0 with SMTP id
 d9443c01a7336-2446d939290mr42172865ad.46.1755272595233; Fri, 15 Aug 2025
 08:43:15 -0700 (PDT)
Precedence: bulk
X-Mailing-List: syzbot@lists.linux.dev
List-Id: <syzbot.lists.linux.dev>
List-Subscribe: <mailto:syzbot+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:syzbot+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <689f5129.050a0220.e29e5.0019.GAE@google.com> <b2667c4ebbe5e0da59542d2d9026322bd70c6c6a.camel@infradead.org>
In-Reply-To: <b2667c4ebbe5e0da59542d2d9026322bd70c6c6a.camel@infradead.org>
From: Aleksandr Nogikh <nogikh@google.com>
Date: Fri, 15 Aug 2025 17:43:03 +0200
X-Gm-Features: Ac12FXwZeTLz5pSIIxD3s3_BO2OVk5Y7yPGqJiF3VA6MqkLXviIJ0ppRoKfOrWU
Message-ID: <CANp29Y7BFtp9YrgzMTJhF1rmF_xx_48zMuCwbkP978LHPazD1g@mail.gmail.com>
Subject: Re: [syzbot ci] Re: Support "generic" CPUID timing leaf as KVM guest
 and host.
To: David Woodhouse <dwmw2@infradead.org>
Cc: syzbot ci <syzbot+ci156aec4dff349a40@syzkaller.appspotmail.com>, 
	kvm@vger.kernel.org, linux-kernel@vger.kernel.org, x86@kernel.org, 
	syzbot@lists.linux.dev, syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Fri, Aug 15, 2025 at 5:36=E2=80=AFPM David Woodhouse <dwmw2@infradead.or=
g> wrote:
>
> On Fri, 2025-08-15 at 08:24 -0700, syzbot ci wrote:
> > syzbot ci has tested the following series
> >
> > [v1] Support "generic" CPUID timing leaf as KVM guest and host.
> > https://lore.kernel.org/all/20250814120237.2469583-1-dwmw2@infradead.or=
g
> > * [PATCH 1/3] KVM: x86: Restore caching of KVM CPUID base
> > * [PATCH 2/3] KVM: x86: Provide TSC frequency in "generic" timing infom=
ation CPUID leaf
> > * [PATCH 3/3] x86/kvm: Obtain TSC frequency from CPUID if present
> >
> > and found the following issue:
> > kernel build error
> >
> > Full report is available here:
> > https://ci.syzbot.org/series/a9510b1a-8024-41ce-9775-675f5c165e20
> >
> > ***
> >
> > kernel build error
> >
> > tree:      torvalds
> > URL:       https://kernel.googlesource.com/pub/scm/linux/kernel/git/tor=
valds/linux
> > base:      dfc0f6373094dd88e1eaf76c44f2ff01b65db851
> > arch:      amd64
> > compiler:  Debian clang version 20.1.7 (++20250616065708+6146a88f6049-1=
~exp1~20250616065826.132), Debian LLD 20.1.7
> > config:    https://ci.syzbot.org/builds/590edf8b-b2a0-4cbd-a80e-35083fe=
0988e/config
> >
> > arch/x86/kernel/kvm.c:899:30: error: a function declaration without a p=
rototype is deprecated in all versions of C [-Werror,-Wstrict-prototypes]
> >
> > ***
>
> #syz test:
> git://git.infradead.org/users/dwmw2/linux.git f280e5436b3297ebb3ac282faf5=
559139b097969
>

Hi David,

(FYI) The syz test command is not supported for "syzbot ci" reports
yet (but it's in the plans).

--=20
Aleksandr
