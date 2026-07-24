Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8FDD63A7D91
	for <syzbot@lists.linux.dev>; Fri, 24 Jul 2026 07:15:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=100.103.45.18
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784877314; cv=pass; b=CMcjiKAl1WoxHcF5pNJ+WBZt04nJgKuuVs/YyJoxGn9ZjYybvhO5h4P+UOkRZcaBjgs5xg3JTVPOfwNHKTJ/+NxidO3Nn1s4DNzHQEThF8tX7e5TL3Ris3nYxgkYX0h1lny0rf5phOO8cTiW1F1fJEpaIPtD+yCc6jU84v7V0fE=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784877314; c=relaxed/simple;
	bh=YLZe1Vd6SPoS1P8/C59OJ7Dc009J18QvBwwUp0g053E=;
	h=Message-ID:Subject:From:To:Cc:Date:In-Reply-To:References:
	 Content-Type:MIME-Version; b=buurO3Ephs9PcoO5QJ+Z8v1lYRTOA2YQ06Gov94t7D8QMNKMtjhv9+rIW42ArrZDdLOCclmXfwU5BLxjlPa+ZVDnzAhORDhODSlt7dpiQ3VsxTYyo5AP9Nv75ezhpGMasIx0uH64ttad1m+ffji0IGxAUFWLP5nJuxhWj/FRAsE=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=sipsolutions.net header.i=@sipsolutions.net header.b=ElWR+t1F; arc=pass smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=sipsolutions.net header.i=@sipsolutions.net header.b="ElWR+t1F"
Received: by smtp.kernel.org (Postfix)
	id 2E92F1F00A3D; Fri, 24 Jul 2026 07:15:11 +0000 (UTC)
Authentication-Results: smtp.kernel.org; arc=none smtp.remote-ip=168.119.38.16
ARC-Seal: i=1; d=kernel.org; s=arc20260519; a=rsa-sha256; cv=none;
	t=1784877311;
	b=ae5F0Y9mPKRdvefdiRBmxYSu+jZgHsVv255Dj6SBi/i6qNgxlxm0fN+bHV7gp5SHTxJx
	 GYmzA164740lDaDZCRE8j8xTdgGcvJHf7gPBaO7AgiHg4X7bmIxmhUZ4YU/nucWdYYkWc
	 ylWyyncIGS3BhyGJkPrJ+Oi6BjKgUoqqmsgN7fd1XUnPm86fpo8zHBYmrFIGuC1vSVqNb
	 St9wOfVbrYb9EM4O4Pn0DUg3ebIHEpFtavcopy9yIEsIh9cTRUZiSDCxIQCLBCPv1Avwr
	 QlO0RsO8pTIUDC0g+52DWs9wq9Rp423A0gOeKbP4c8H46NZijtvaGfgZBgUCDCSAfbg==
ARC-Message-Signature: i=1; d=kernel.org; s=arc20260519; a=rsa-sha256;
	c=relaxed/relaxed; t=1784877311;
	h=DKIM-Signature:Received:Message-ID:Subject:From:To:Cc:Date:
	 In-Reply-To:References:Content-Type:Content-Transfer-Encoding:
	 User-Agent:MIME-Version:X-malware-bazaar;
	bh=YLZe1Vd6SPoS1P8/C59OJ7Dc009J18QvBwwUp0g053E=;
	b=Br5gnnVkuuRYUp5xvU6X3Q07oiBdYIZUwoslhtdPtDcS2cGmUHUl2rI4+xa9HsOEjXH/
	 aw3kdqImWHbNSVTk05EX19dbAqtFOL856lB6Fypz1ScBfZZ78QODXvRfqaFQteNehDkyM
	 z9rXnRiY/gtVnEkazsR5mIPtWs8X2zD/es9GD+1hr4BFQ2y8gcRsS7rKuSuvTq8q0hqbh
	 xZmmpLC6200d4Y6aHjgc1ePdP+kTmSP9rz500ufpR7+IGt88HNMt1T9faK0fI0nF9P3Mz
	 JPjhTR6RgfkNG9uJutsbs6Bm1naYeKX/MZUcmlaNHqTQ6qF4gH9UhfqNKUcDVByc4yg==
ARC-Authentication-Results: i=1; smtp.kernel.org; dkim=pass header.d=sipsolutions.net header.i=@sipsolutions.net header.a=rsa-sha256 header.s=mail header.b=ElWR+t1F;
	dmarc=permerror header.from=sipsolutions.net;
	spf=none smtp.mailfrom=sipsolutions.net;
	arc=none smtp.remote-ip=168.119.38.16
Received: from sipsolutions.net (s3.sipsolutions.net [168.119.38.16])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (prime256v1) server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.kernel.org (Postfix) with ESMTPS id 628FB1F000E9
	for <syzbot@kernel.org>; Fri, 24 Jul 2026 07:15:10 +0000 (UTC)
Authentication-Results: smtp.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=sipsolutions.net header.i=@sipsolutions.net header.a=rsa-sha256 header.s=mail header.b=ElWR+t1F
Authentication-Results: smtp.kernel.org; dmarc=permerror header.from=sipsolutions.net
Authentication-Results: smtp.kernel.org; spf=none smtp.mailfrom=sipsolutions.net
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=sipsolutions.net; s=mail; h=MIME-Version:Content-Transfer-Encoding:
	Content-Type:References:In-Reply-To:Date:Cc:To:From:Subject:Message-ID:Sender
	:Reply-To:Content-ID:Content-Description:Resent-Date:Resent-From:Resent-To:
	Resent-Cc:Resent-Message-ID; bh=YLZe1Vd6SPoS1P8/C59OJ7Dc009J18QvBwwUp0g053E=;
	t=1784877310; x=1786086910; b=ElWR+t1Fqn9jWDZBGIa2IpvDaAMFsu6xHUbSTn3aero0P6B
	z3gTEfv+lZ8xAFkmQNpL3u0003id1dkEe7NaMJczd1nWA0xcRMgEDrBWcT1U3Y215yv3yzkKTTSPh
	1Lt4+fFadqhAhWTuYggU0Fn0obTcKvvm4Ymk0pqFwIqKaRoFmMILWm/YfpylJgGK2/bD3bGoVbCGf
	l2B8deVBXJnRzUtDe939ZqekvWSh7JAaWhiXcFR05LIy9KaTGlgJs6B4QPNXSA/PFHzRJMlRSoQ1m
	l64+m4CJsWNAhPp4DQ2e87fmkO17WEM7KFH8aAFtCFj/vSv18kGVJWWGRmauUZ6Q==;
Received: by sipsolutions.net with esmtpsa (TLS1.3:ECDHE_X25519__ECDSA_SECP256R1_SHA256__AES_256_GCM:256)
	(Exim 4.98.2)
	(envelope-from <johannes@sipsolutions.net>)
	id 1wnA7e-000000021nm-3tiK;
	Fri, 24 Jul 2026 09:15:07 +0200
Message-ID: <86efc46da2c0c5cf73ca262f8be8c5086d626ee7.camel@sipsolutions.net>
Subject: Re: [PATCH] wifi: mac80211: reject station association if AP is not
 started
From: Johannes Berg <johannes@sipsolutions.net>
To: Slawomir Stepien <sst@poczta.fm>
Cc: syzbot <syzbot@kernel.org>, syzkaller-bugs@googlegroups.com, 
	linux-wireless@vger.kernel.org, linux-kernel@vger.kernel.org, 
	syzbot@lists.linux.dev
Date: Fri, 24 Jul 2026 09:15:06 +0200
In-Reply-To: <amMLPgO8Yv1wjMGa@nr200>
References: <373210a9-4365-4cac-823a-0eec391858e7@mail.kernel.org>
	 <c9fa1c083ef9878240c2ee2fb223413153d93a68.camel@sipsolutions.net>
	 <amMLPgO8Yv1wjMGa@nr200>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.58.3 (3.58.3-1.fc43) 
Precedence: bulk
X-Mailing-List: syzbot@lists.linux.dev
List-Id: <syzbot.lists.linux.dev>
List-Subscribe: <mailto:syzbot+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:syzbot+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-malware-bazaar: not-scanned

On Fri, 2026-07-24 at 08:50 +0200, Slawomir Stepien wrote:
> On lip 23, 2026 11:14, Johannes Berg wrote:
> > On Thu, 2026-07-23 at 08:11 +0000, syzbot wrote:
> > > From: Slawomir Stepien <sst@poczta.fm>
> >=20
> > I'm a bit confused? Did syzbot just pick up another patch?
>=20
> Hi Johannes!
>=20
> No, this issue has been found by syzbot while doing fuzzing testing.

Yeah, but the email? It's "From: syzbot <...>" and actually was
delivered to me by sea.source.kernel.org, whereas your other mail was
delivered to me by smtpo49.interia.pl, so I'm confused as to who sent
the mail and how :)

johannes
