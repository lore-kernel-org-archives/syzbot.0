Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1CDAB3A7F4A
	for <syzbot@lists.linux.dev>; Fri, 24 Jul 2026 12:05:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=100.103.45.18
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784894737; cv=pass; b=tTqpqSDRR/US/nGMMPR3yX8HSf+2LexVKipJ6UUzZieU6sij2/tqZW/UYjLNgdSzlqvs8j1MDlyFkR+VblDE9gX5GFRYOYjwqvBbs4gel/aQfnwNQICNwTTRUE4Q8tXAXUKBGR9l+1K4Jv9SsuwZSGTD84lz42bwRAfOQZE8iN4=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784894737; c=relaxed/simple;
	bh=6JWqdbeXuwxuJ3OgX9YlJ7Klum5SgMtFIEHAD2O/UcQ=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Em8sdk7ZHGRI0/gPYoYgFaOyKBRsspbAIzYx0Gy2ft6Wmkw9x3nNRSB3rNaR/cMjbtWUwmfQeiBO+h+T/SECUUVLTxXRoLgjdT2FF4UWh4VJDWLu3/PowBq/440b7k9DFhQbhETINFquBp2WybVG4pdjsz0rmEWzlirFhVQS7RE=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=poczta.fm header.i=@poczta.fm header.b=BX1nQulB; arc=pass smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=poczta.fm header.i=@poczta.fm header.b="BX1nQulB"
Received: by smtp.kernel.org (Postfix)
	id BCCFE1F00A3A; Fri, 24 Jul 2026 12:05:35 +0000 (UTC)
Authentication-Results: smtp.kernel.org; arc=none smtp.remote-ip=217.74.67.63
ARC-Seal: i=1; d=kernel.org; s=arc20260519; a=rsa-sha256; cv=none;
	t=1784894735;
	b=DWXlWAbU8LILYMMruryg3iNnRTZmKlpvbgzWlzHfmuiGhFdTchtDjqR0vZCqninwl7aQ
	 vzYKdiKMHepKNs6Rf5PuHIFKNq6ZDT1coNfRy5gWgfT4Hb9L8EKnAwvd7vcEYR4tUhawP
	 fqW8TfvtTedLjV1+AYDmTfIRDbex3lXWOmG4s0fkN7k7IJHUZMcSN6K3OP3J1gNRF0rOd
	 ZrTWZikioXQDOxH+bh/W6kZslby1V02CG+n3RPJNeqKmTUmi/iidzCkaRvf7U3j5WBKjR
	 C3bT/epbj+QrBEPFj4ziNUTEbTNRaDAhvbbKPDGTRWDt9yS0TnAQHXLtv74OmSta8YQ==
ARC-Message-Signature: i=1; d=kernel.org; s=arc20260519; a=rsa-sha256;
	c=relaxed/relaxed; t=1784894735;
	h=DMARC-Filter:Received:Date:From:To:Cc:Subject:Message-ID:References:
	 MIME-Version:Content-Type:Content-Disposition:In-Reply-To:
	 DKIM-Signature;
	bh=9WCcUBpcZugisq07q9owkL/cyHa7KP34+EFlP4Tgs1M=;
	b=DKFtkLOM8pbj71o9BVitMVL3lVYo4bJLz8aCPrLFjgq4FEJksKo6Q09K+jLoM/mc/z0e
	 a4T4ExknLRje2gq4Wqs96xLXjXj+02OZTlVx384vQiA3LyBAIcFcARNpdxM9MgaGoMujL
	 QOxxzDTQBk5o/F32T6Xk/MD3gv/1Nd4QtWNyKaEP9ajzWqcCJsLEgvCu8qUORB5H0chnM
	 iol0r1x6vRYEjPwFHyKQx60psc4k4dr/eJn3EzlMcXKhFJXgBvk6r54uXWBB9mnNSXGgo
	 zpUcH2ujI+VAhliBQVdTR69LBsWhpPuSxhI+Z0g3xBAoQNfkOjBhghT5en1yXZv4L0w==
ARC-Authentication-Results: i=1; smtp.kernel.org; dkim=pass header.d=poczta.fm header.i=@poczta.fm header.a=rsa-sha256 header.s=dk header.b=BX1nQulB;
	dmarc=pass header.from=poczta.fm;
	spf=pass smtp.mailfrom=poczta.fm;
	arc=none smtp.remote-ip=217.74.67.63
Received: from smtpo63.interia.pl (smtpo63.interia.pl [217.74.67.63])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.kernel.org (Postfix) with ESMTPS id 290461F000E9
	for <syzbot@kernel.org>; Fri, 24 Jul 2026 12:05:32 +0000 (UTC)
Authentication-Results: smtp.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=poczta.fm header.i=@poczta.fm header.a=rsa-sha256 header.s=dk header.b=BX1nQulB
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.kernel.org 290461F000E9
Authentication-Results: smtp.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=poczta.fm
Authentication-Results: smtp.kernel.org; spf=pass smtp.mailfrom=poczta.fm
Received: from nr200 (unknown [80.68.231.31])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (P-256) server-digest SHA256)
	(No client certificate requested)
	by poczta.interia.pl (INTERIA.PL) with ESMTPSA;
	Fri, 24 Jul 2026 14:03:20 +0200 (CEST)
Date: Fri, 24 Jul 2026 14:02:58 +0200
From: Slawomir Stepien <sst@poczta.fm>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: syzbot <syzbot@kernel.org>, syzkaller-bugs@googlegroups.com,
	linux-wireless@vger.kernel.org, linux-kernel@vger.kernel.org,
	syzbot@lists.linux.dev
Subject: Re: [PATCH] wifi: mac80211: reject station association if AP is not
 started
Message-ID: <amNUcscgkmCjJdnT@nr200>
References: <373210a9-4365-4cac-823a-0eec391858e7@mail.kernel.org>
 <c9fa1c083ef9878240c2ee2fb223413153d93a68.camel@sipsolutions.net>
 <amMLPgO8Yv1wjMGa@nr200>
 <86efc46da2c0c5cf73ca262f8be8c5086d626ee7.camel@sipsolutions.net>
Precedence: bulk
X-Mailing-List: syzbot@lists.linux.dev
List-Id: <syzbot.lists.linux.dev>
List-Subscribe: <mailto:syzbot+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:syzbot+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <86efc46da2c0c5cf73ca262f8be8c5086d626ee7.camel@sipsolutions.net>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=poczta.fm; s=dk;
	t=1784894730; bh=9WCcUBpcZugisq07q9owkL/cyHa7KP34+EFlP4Tgs1M=;
	h=Date:From:To:Subject:Message-ID:MIME-Version:Content-Type;
	b=BX1nQulB7njOGni5MWKWw025B7m/y3cZfvjjUuoNhYJSP09cqKqasSE/XqsckiXcB
	 5koJHZ/CauhtM0y/hoV4BpMaaw/EmW8rI9e+mwRYwMSdard6emcKpCBtg1AaYG/yCN
	 wqQWxne+Kr5AP/uqUT5pWH7wyHDedruMFzslvqFY=

On lip 24, 2026 09:15, Johannes Berg wrote:
> On Fri, 2026-07-24 at 08:50 +0200, Slawomir Stepien wrote:
> > On lip 23, 2026 11:14, Johannes Berg wrote:
> > > On Thu, 2026-07-23 at 08:11 +0000, syzbot wrote:
> > > > From: Slawomir Stepien <sst@poczta.fm>
> > > 
> > > I'm a bit confused? Did syzbot just pick up another patch?
> > 
> > Hi Johannes!
> > 
> > No, this issue has been found by syzbot while doing fuzzing testing.
> 
> Yeah, but the email? It's "From: syzbot <...>" and actually was
> delivered to me by sea.source.kernel.org, whereas your other mail was
> delivered to me by smtpo49.interia.pl, so I'm confused as to who sent
> the mail and how :)

The initial e-mail with patch was sent by the syzbot on my request, that's why I'm in the added From
and Signed-off-by (bot can't be the Author of commit and I'm responsible for handling this patch on
mailing list).

You can read more about this here:
https://github.com/google/syzkaller/blob/master/docs/syzbot_ai_patches.md.

-- 
Slawomir Stepien
