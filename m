Received: from mail-pl1-f171.google.com (mail-pl1-f171.google.com [209.85.214.171])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 021C923E350
	for <syzbot@lists.linux.dev>; Thu,  7 Aug 2025 15:09:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.171
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1754579379; cv=none; b=WdBfXD58hajmZPu03QYTUAqmKcohs91ieUXz7W7FgaRS8iz2OQUJWvMSzX6aWmx7TcoT29qaip9e0IofmGm0xFWXqrr/607DLZI7eeBh1k5gH9uIHaQm52dEFKze5nWVv3WDIU992f7v3Evo6C+10dx+4BxBUQrqI6wiEe//fhY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1754579379; c=relaxed/simple;
	bh=vXI9Zam5eYCmdhXZAZEND+qlnOZtF3m0aq2gFtw/4+4=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=r7A2fGRuWarjMcRTh9IbWLP/RCaEO4naerkmzeyM+iVWtVcg8VEIPAVyKzsUm5H8089lxkp5y1raLkFA1/sW/hvh//RhYC3/R1NisOUmaIf+gMCvB4GMlPKWKj+1xTN7+OUTRSImlhiaVd73ERChzOKB53XxMczBteUjBde/m3Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=Fv49FRm6; arc=none smtp.client-ip=209.85.214.171
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="Fv49FRm6"
Received: by mail-pl1-f171.google.com with SMTP id d9443c01a7336-24022261323so22620295ad.1
        for <syzbot@lists.linux.dev>; Thu, 07 Aug 2025 08:09:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1754579377; x=1755184177; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=vXI9Zam5eYCmdhXZAZEND+qlnOZtF3m0aq2gFtw/4+4=;
        b=Fv49FRm69wWh6+hODzj0IGxrDBmDJ1viOl/Jf7OFHMO4fT6n26MJtFnMPOC/FcepQh
         LAhlaqz5GXu4d6u0l57+ou8hq1OxPeT3sJ3HaeBn/JPmxe7GA0cTPSjQp8c8kNmcgjK3
         5I/qcmsSq0lReW2yiTcu6jlqxT2LIB6BjgtCaeEnzlcx76rgXaktfdUvUoHIURpUPve2
         XRn0vFuzw40zJt1+RDXNxocHqGvl61HOpz59zmbtGKdWa6Q4uWLG4v7LjOMX+oXv19Uu
         aQUCbUzmmBQGsKCrHJnrRe62z5iXsQn+7FHOlUKUOfIxQ5HXOQ/9TN8qcdoYbUjUHAqY
         Z4XA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1754579377; x=1755184177;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=vXI9Zam5eYCmdhXZAZEND+qlnOZtF3m0aq2gFtw/4+4=;
        b=S4+dG07XnZ58sgbl8EFH3JVD0imocRKRkp1p1aD5N+AJLxAoLIz8j3XM918z5YE60t
         +BIWpY3wZAnsH/1HQVnpOPG3jJeg0/EfeOo0V9L4NP97+vLOv4cfnd2cMSTqJkx59nRB
         QHGymZgTsqmYuFgrlrIAYNsx8idT/LmbrlCaf/HOhFCx3mVjfFa9I+OvAITS23PaGCXT
         6DBlrxjMOvOkfUEyBMqii4kZCkj4kVnIGh8xYnBZccu471D/r2VZZp31+ill8RyEQ7bY
         /jZFP8AdkzJAiidoAzxHVjn0FkuTiDfm7bBa1VmqtEtvsnxJJyjXaZSb3iDd2pYwIlb2
         rILg==
X-Forwarded-Encrypted: i=1; AJvYcCWfcpRaWCxbhFtQLWunTBHlQOoH0sJMC544aQ68Bkwcbm+Bhkx0Q2i9558w71y2jBzqwACvSQg=@lists.linux.dev
X-Gm-Message-State: AOJu0YzS4b9hF7wPhcmilycaL9KY8m6wC6cyRqRHaNknPsNn3fgKZUP9
	zt5ASSxyXvYNoaeSCG8OicG9mIVFrErwRDYau+W12qKzJkJp/5dqhqvzdPbNFI7gtaUZhquLfop
	e0QXtN5LdlRWHPzRLBtiPt/FV1RcUxN4KbX2iuKsq
X-Gm-Gg: ASbGncuEKHA1jmCoLTHLrqNPPFaKMMjpwaihGj3YCaB8vDan+oQSx4qQqttyiyzSqDu
	8HP7Sfgpq+ZpoK0HjkP+CwdmVOb6Bi1SCmu+eut8Ri2ojJ4NO1zQgtBIirqTXaJ/HPOmol+QV3S
	81G1oPdnqUXoJs+Suizq8ZRVGqy6uGLdcGwJmkCexjFyHOidI4B/7pvduCwGunPfaXxGtOe7yZh
	T/ZkK3ao8iqImZ/5CtAtBD/rWIN6+o/w8iQeegmsY2iaas6
X-Google-Smtp-Source: AGHT+IG8QlJyGrI/LcZsqPJ4tTpGg3cKXVWXjR1Ly1wLcsKoXFz1GMnQ///H1MLhMEXGNQE8r3JHiVH9uD53B/zlYEk=
X-Received: by 2002:a17:902:f64a:b0:240:4d19:8774 with SMTP id
 d9443c01a7336-242b076a24amr47832795ad.24.1754579376834; Thu, 07 Aug 2025
 08:09:36 -0700 (PDT)
Precedence: bulk
X-Mailing-List: syzbot@lists.linux.dev
List-Id: <syzbot.lists.linux.dev>
List-Subscribe: <mailto:syzbot+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:syzbot+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20250722100743.38914e9a@kernel.org> <20250723162547.1395048-1-nogikh@google.com>
 <20250723094720.3e41b6ed@kernel.org> <20250807064116.6aa8e14f@kernel.org>
In-Reply-To: <20250807064116.6aa8e14f@kernel.org>
From: Aleksandr Nogikh <nogikh@google.com>
Date: Thu, 7 Aug 2025 17:09:24 +0200
X-Gm-Features: Ac12FXyf-LII2oKhENT74R1IUHeqtiItmnUOlh8HIq0rExOfD6gVb883YMc88zw
Message-ID: <CANp29Y5mZJJgn5LYDiLx11bH__NXZ32ut6VUTsEyXwqrOhksTw@mail.gmail.com>
Subject: Re: [syzbot ci] Re: net: Revert tx queue length on partial failure in dev_qdisc_change_tx_queue_len()
To: Jakub Kicinski <kuba@kernel.org>
Cc: dvyukov@google.com, linux-kernel-mentees@lists.linux.dev, 
	linux-kernel@vger.kernel.org, netdev@vger.kernel.org, syzbot@lists.linux.dev, 
	syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Hi Jakub,

On Thu, Aug 7, 2025 at 3:41=E2=80=AFPM Jakub Kicinski <kuba@kernel.org> wro=
te:
>
> On Wed, 23 Jul 2025 09:47:20 -0700 Jakub Kicinski wrote:
> > On Wed, 23 Jul 2025 18:25:47 +0200 Aleksandr Nogikh wrote:
> > > On Tue, 22 Jul 2025 Jakub Kicinski wrote:
> > > > I think this email is missing a References: header ?
> > > > It doesn't get threaded properly.
> > >
> > > Yes, that was indeed a bug that has now been fixed, thanks for
> > > reaching out!
> >
> > Thank you!
>
> One more thing, would it be possible to add / correct the DKIM on these
> messages? Looks like when our bots load the syzbot ci emails from lore
> the DKIM verification fails. I see a X-Google-DKIM-Signature: header,
> but no real DKIM-Signature:

Thanks for letting us know!
Do these bots also face DKIM verification issues with regular syzbot
emails? We send them absolutely the same way, so the problem must
affect all reports.

We use the GAE Mail API, and its documentation[1] says that it signs
emails with DKIM only if a custom domain is configured. Since we send
from the default GAE domain, this would explain the verification
failures.

We'll explore the ways to fix this.

[1] https://cloud.google.com/appengine/docs/standard/services/mail?tab=3Dgo=
#authentication_with_domainkeys_identified_mail_dkim

--=20
Aleksandr
