Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 16FC62ED16D
	for <syzbot@lists.linux.dev>; Thu,  6 Aug 2026 14:49:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=100.103.45.18
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786027795; cv=pass; b=uodSJySwPYpZUt49O/sRo7jlyAiwDQBf8sBpvR+57NEWnz5q/JVpQjMs3gWq4mM+kjTh7mQfjzT91yelalFJnM9EkCQdXZ1EOYC/HUS6R0jE71Fjo90OdLwC83wQNp8rhfwMwTx9PjEssu6I6bIZFPOloSPFAmvHPCJ1RIBiGMU=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786027795; c=relaxed/simple;
	bh=9A4kNYJ+OPQWURMkmJmD/xejOeQ0Mt7S6vGtMcOcM8g=;
	h=Message-ID:Subject:From:To:Cc:Date:In-Reply-To:References:
	 Content-Type:MIME-Version; b=l6SDytqKchuV9IqV4cfKYI9A9v7UWumK01n+OdmKe54zG6q2Lt9M0Z3iI9TV4LqTGJkgS8TbIeQ2Tu6EIEB/Fh2YmslT/zgcVOHhjeOwBy2UwGH2tt+mB3yIIiEsnEcaSJ7wJ1WoBOhWq02MqqkvKXvLrDlzxh6qZoDkYibR9LA=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=sipsolutions.net header.i=@sipsolutions.net header.b=DRS0Hf1U; arc=pass smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=sipsolutions.net header.i=@sipsolutions.net header.b="DRS0Hf1U"
Received: by smtp.kernel.org (Postfix)
	id F03C01F000E9; Thu,  6 Aug 2026 14:49:50 +0000 (UTC)
Authentication-Results: smtp.kernel.org; arc=none smtp.remote-ip=168.119.38.16
ARC-Seal: i=1; d=kernel.org; s=arc20260519; a=rsa-sha256; cv=none;
	t=1786027790;
	b=yup2YyfzHOSJGwz6ibHe0GzZTUZx03WXdOaP4NdBZ98YgJ5cCdtU2Btf8EDqRZz9/9jz
	 ona1PtpR3NrF66zqHsAs2ND4IQVeiR3r1jDk6iEdssbMtzjU4tyr9xJe/8ytjYrTqT60v
	 j60P1IHGF961JI4VvRexI5BSrDTW/OPFRKGM8XSLZmacfihthhswZpt6AsGTayB0TsvpS
	 fepVP897tGpDiN6zy4jojPFhr87NMOE35USeuUCcogbtplLAgKLdTOfW7Dw0C8+SBWAHP
	 TN/8BXra311n9DB0LPXfcCxFYq/W3Bahp3TBdc1S77zb4X7fOPjPh4zx2Jlw+7fvY0Q==
ARC-Message-Signature: i=1; d=kernel.org; s=arc20260519; a=rsa-sha256;
	c=relaxed/relaxed; t=1786027790;
	h=DKIM-Signature:Received:Message-ID:Subject:From:To:Cc:Date:
	 In-Reply-To:References:Content-Type:Content-Transfer-Encoding:
	 User-Agent:MIME-Version:X-malware-bazaar;
	bh=9A4kNYJ+OPQWURMkmJmD/xejOeQ0Mt7S6vGtMcOcM8g=;
	b=lKygG9MwTHTBvbBAwqLEfjaRTwYWZxU+VmTEDkANPQ9lyRjRgJ0QVTzOuhWBbVNSA8BO
	 8SQtMxAjDeLJLmoHjE1g2jnNzO/i8KEJ1CtJDjH/HjPvUM/hQT6tZf/zTmkBhNSw3zBeG
	 q+OYxEIcBJ7SbK/0gJ014loyAN/EZspeP9r8n/36OlI1y+VCvTjHs8rE/gOnXXczwGC4O
	 Mi0BIvX/sJojpIUHOuivhj91S50vI44yfjjWbVntVHsyNafNDYstKyU4CfggmCYNnbaF6
	 QFZgnuKKDTnHXA5HPU6NJFksTmQWMDyscrSxufwbcEmsjk9j8+fRXXR2gHKCO575U/Q==
ARC-Authentication-Results: i=1; smtp.kernel.org; dkim=pass header.d=sipsolutions.net header.i=@sipsolutions.net header.a=rsa-sha256 header.s=mail header.b=DRS0Hf1U;
	dmarc=permerror header.from=sipsolutions.net;
	spf=pass smtp.mailfrom=sipsolutions.net;
	arc=none smtp.remote-ip=168.119.38.16
Received: from sipsolutions.net (s3.sipsolutions.net [168.119.38.16])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (prime256v1) server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.kernel.org (Postfix) with ESMTPS id 287281F00A3A
	for <syzbot@kernel.org>; Thu,  6 Aug 2026 14:49:50 +0000 (UTC)
Authentication-Results: smtp.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=sipsolutions.net header.i=@sipsolutions.net header.a=rsa-sha256 header.s=mail header.b=DRS0Hf1U
Authentication-Results: smtp.kernel.org; dmarc=permerror header.from=sipsolutions.net
Authentication-Results: smtp.kernel.org; spf=pass smtp.mailfrom=sipsolutions.net
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=sipsolutions.net; s=mail; h=MIME-Version:Content-Transfer-Encoding:
	Content-Type:References:In-Reply-To:Date:Cc:To:From:Subject:Message-ID:Sender
	:Reply-To:Content-ID:Content-Description:Resent-Date:Resent-From:Resent-To:
	Resent-Cc:Resent-Message-ID; bh=9A4kNYJ+OPQWURMkmJmD/xejOeQ0Mt7S6vGtMcOcM8g=;
	t=1786027789; x=1787237389; b=DRS0Hf1Uh3vEaFbTET4xFxLrUTFKgJk3+F62DarsNdUrTAb
	XHWKqlcHX6w5vOm3o1mv9rX49h96pMWhjJeduu76lqF1Xwjc8oSpakU9iODoyJnlC819A9DSJiJFh
	Gedy/Gd6nMO0zROjSKdWe92oD7g4UA//8CjqdfNDzTLgDG6G4CK5d2Tmxx7Eg4D5Nh0Y21KLgzyVX
	3UY1kdW62BJjss6/1PJOaROwcwJX4PuNF+SBVQUVJChhJs1aMkV7at7JIUmxsH7GON92ysB1YKd7D
	Y1ACv+Lyqd+E4MOAoicItf04KuqbZpMyr2KIDP4am9q38eafj3YrccldVeuyve0A==;
Received: by sipsolutions.net with esmtpsa (TLS1.3:ECDHE_X25519__ECDSA_SECP256R1_SHA256__AES_256_GCM:256)
	(Exim 4.98.2)
	(envelope-from <johannes@sipsolutions.net>)
	id 1wrzPm-00000009EPO-2YzA;
	Thu, 06 Aug 2026 16:49:46 +0200
Message-ID: <8a0020fb5318ed645b0331d3790a75f83c0ee443.camel@sipsolutions.net>
Subject: Re: sysbot AI patches and wireless
From: Johannes Berg <johannes@sipsolutions.net>
To: Slawomir Stepien <sst@poczta.fm>
Cc: Aleksandr Nogikh <nogikh@google.com>, syzbot <syzbot@kernel.org>, 
	syzkaller-bugs@googlegroups.com, linux-wireless@vger.kernel.org, 
	linux-kernel@vger.kernel.org, syzbot@lists.linux.dev, Krystian Kaniewski
	 <krystianmkaniewski@gmail.com>
Date: Thu, 06 Aug 2026 16:49:45 +0200
In-Reply-To: <anRyTtgRT8gVUZYR@nr200>
References: <068e46b5-0c88-4432-959a-b9400d9691ee@mail.kernel.org>
	 <3b6c46b6d79f3a0e0ded2967db3cfd469314b05c.camel@sipsolutions.net>
	 <CANp29Y6sHOe5QY6BgzeUtKFGqc2pDyP8WAUzQ6E1-3oYgZTY0g@mail.gmail.com>
	 <6007f37089d14eb14deed54d34921f0ef691e1fa.camel@sipsolutions.net>
	 <anRyTtgRT8gVUZYR@nr200>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.60.2 (3.60.2-1.fc44) 
Precedence: bulk
X-Mailing-List: syzbot@lists.linux.dev
List-Id: <syzbot.lists.linux.dev>
List-Subscribe: <mailto:syzbot+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:syzbot+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-malware-bazaar: not-scanned

Hi Slawomir,

> > But I really cannot make that judgement call myself for every single
> > issue like that, if I could, see above, I could be doing all of this
> > myself. Need the contributors to do that. Slawomir did that after I
> > prompted (pun intended!) him to do that, and it didn't work out so well
>=20
> It didn't? Or it did? :)

Sorry, indeed, it *did* - thank you.

> Well I do not have new version of the patch yet, but I'm still
> investigating correct approach and testing a lot. I see now, that I shoul=
d do that in the 1st place.
> I'm sorry for that.

No worries.

This in just after our exchange here:

https://lore.kernel.org/ksummit/87y0ekm9nw.fsf@trenco.lwn.net/

It's definitely part of the job to train new contributors, and it's
actually very rewarding to see someone grow from first time contributor.
Sadly, now there's basically no "first-contact signal" that says "I care
about this more than landing this one patch". :-/ Getting a well-formed
(and well-argued) patch used to be worth something, now it's basically
not.

See also Dan's "pair programming" reply.

But I see the other side too; my first patch to the kernel, more than
two decades ago, was a similar thing, though argued first over IRC.
People need a support community to start out anywhere.

Also, I think with patches part of the issue is that there's an implicit
assumption that it'll get reviewed/merged/etc. - but as a submitter you
don't really have anyone to ask questions about that patch and process
before sending (unless you were hired into a Linux team or something).

I obviously don't have a solution to this - I'm just honestly stating
that it doesn't scale for me as the maintainer to be providing this,
certainly not in the format that syzbot's patch-as-a-service encourages,
but more generally also not. A few new folks per year is fine, a few per
month can't work.

Some people hang out on IRC (#linux-wireless, myself too), some people
build experience in other communities like OpenWRT first (or just remain
there), etc. Part of the issue is that we haven't _really_ documented
any of this as the wireless or even broader kernel community, but things
also shift frequently anyway. Another part is - not saying that's the
case for you - that some people just don't care and all they want is
land patches, so they'll go across subsystems, never learn one, and just
hope something sticks somewhere.

Meanwhile, I hope you're not too discouraged by all this, again, sorry
you got caught in the cross-fire here. (I'm going to be on vacation, we
can pick up the thread about your specific patches in September.)

johannes
