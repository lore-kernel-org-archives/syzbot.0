Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 32E993C0A06
	for <syzbot@lists.linux.dev>; Thu, 30 Jul 2026 08:30:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=100.103.45.18
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785400214; cv=pass; b=lwjcKKw/GkIz5dBUw6qStg+KRx5T+Ius4Duihz7D8mRdEc1+Cu0Spi9jO2YOeEqId5KPjarVPannlQqPWWZc9r9Uq/uyjod9xrTZCagsBs5fTGmGBROl1qiPOfYGgvpCp2mJd61sYhUbAh5RYLb9UqKA/1F/WYQNKMtkkJZcrrw=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785400214; c=relaxed/simple;
	bh=hKZMhKORj9ZhOdiajaQlLWpx/bnFzTMmYZQm4PvPwXU=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=HL+IuLRQgqCorVUxIrG4zzPBPhrdlAzSx2I4VvicXcCEaATiycS97ns7jwrUeZbYftz+N/5SSqGFSlrLAphwyhcdIcwybMWrYqWptkYkJlhIR3iz+dIOFlUx0hWBiWoQ0BPoSG5KupywNNJtawkLzLyx8h4MzcNnEh/L1pjF02g=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=debian.org header.i=@debian.org header.b=gY8vCNO0; arc=pass smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=debian.org header.i=@debian.org header.b="gY8vCNO0"
Received: by smtp.kernel.org (Postfix)
	id D57C21F00A3A; Thu, 30 Jul 2026 08:30:12 +0000 (UTC)
Authentication-Results: smtp.kernel.org; arc=none smtp.remote-ip=82.195.75.108
ARC-Seal: i=1; d=kernel.org; s=arc20260519; a=rsa-sha256; cv=none;
	t=1785400212;
	b=hlfleJCkjR6pYfXa1zLtH/a4mmwMZQGBPbebs5LEKW+BRQR6To5Sl+MJ4EHaVK+oSp7F
	 dDRKwHDGAv4oVfK5cEQA89RHorC+gRayWqoj9wmKdCsuUseRSSWKZkXvDRC9SEEXCbxh9
	 9V9k14VZz4Rjab9tVdEnvSjt86fELrSYCKrdAIuqvU+MHpPlzOmwxrBLv2uw/wrnuMYum
	 iLDBuGwX/wzd+/zHzdkQTIdVv/YajrqrHRI8X2UXHtDptJBW/vks5aQmbPTvTZg6tFk1F
	 A7z5h+u4nrOyjUjnSrOzkzwHORCiHFmtz+T4/MZPHuQFAfdDUD5QcblBU20QvvstE0g==
ARC-Message-Signature: i=1; d=kernel.org; s=arc20260519; a=rsa-sha256;
	c=relaxed/relaxed; t=1785400212;
	h=DMARC-Filter:DKIM-Signature:Received:Date:From:To:Cc:Subject:
	 Message-ID:References:MIME-Version:Content-Type:Content-Disposition:
	 In-Reply-To:X-Debian-User;
	bh=hKZMhKORj9ZhOdiajaQlLWpx/bnFzTMmYZQm4PvPwXU=;
	b=DtHKDxSYTHeFzPlTDDp+ZlAUSNJNl9e0NVZi0xrDsugBQ8hXy8WZSbH2WpbEq5CKvyQB
	 TZwEbGBcsO8uY4o7GWPKN5vkRiPBFG7iT6i1ItPgCbM0Em32sNnnH6F8e2m9B3by5+ifz
	 SVRu3A8/hgXbbwhLFeocGRro905YgJk65zYq+JvLFnl4OJjWcJJnNkSDjqJx/XP67IXme
	 BuWy1lkgSSh0Q0KnldW2xhPJMk1IC1M+rYpzX64syCUbBS+Db6fqH/kPpNDslgkZjja6o
	 BEHlyx3hkpmtNLIJvgwoGJQoX+bodCw+4mKBJTJLPiKIkPS9uQg3xuiGcpulHjs9t1g==
ARC-Authentication-Results: i=1; smtp.kernel.org; dkim=pass header.d=debian.org header.i=@debian.org header.a=rsa-sha256 header.s=smtpauto.stravinsky header.b=gY8vCNO0;
	dmarc=pass header.from=debian.org;
	spf=pass smtp.mailfrom=debian.org;
	arc=none smtp.remote-ip=82.195.75.108
Received: from stravinsky.debian.org (stravinsky.debian.org [82.195.75.108])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (prime256v1) server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.kernel.org (Postfix) with ESMTPS id 0035F1F000E9;
	Thu, 30 Jul 2026 08:30:11 +0000 (UTC)
Authentication-Results: smtp.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=debian.org header.i=@debian.org header.a=rsa-sha256 header.s=smtpauto.stravinsky header.b=gY8vCNO0
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.kernel.org 0035F1F000E9
Authentication-Results: smtp.kernel.org; dmarc=pass (p=none dis=none) header.from=debian.org
Authentication-Results: smtp.kernel.org; spf=pass smtp.mailfrom=debian.org
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=debian.org;
	s=smtpauto.stravinsky; h=X-Debian-User:In-Reply-To:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=hKZMhKORj9ZhOdiajaQlLWpx/bnFzTMmYZQm4PvPwXU=; b=gY8vCNO0PmJWtEi0LAXpOtQTdE
	m9+7we/OlZTgR4+hdsXMFNouqz7cf7Nns4IOT/xX79art4JAtBYqOUftvjor/HhFGOO+Wort1yzgA
	7BDN2Bg9GuAYVth1jlHTKZe0Y4DlKsz8ML32Ins7mua021FrGTVYFD+BCt3DBWOpiDlKaUmaea3At
	xhVedktEE2L/m3waBXOsLDUvkEKhNatbXEcFy3Essl7xSkM5ysO5paLyb5Rb1wO6V2q6/IOoHqxOe
	pPkSF21XcPooZvsDzERegr1OAaNcqXnDgH8WzH63fS37ekxNgPfqSzCkd96aMtovOLh95qgycxos/
	FFUc3o1w==;
Received: from authenticated-user
	by stravinsky.debian.org with esmtpsa (TLS1.3:ECDHE_X25519__RSA_PSS_RSAE_SHA256__AES_256_GCM:256)
	(Exim 4.96)
	(envelope-from <leitao@debian.org>)
	id 1wpM9Y-0096LD-28;
	Thu, 30 Jul 2026 08:30:08 +0000
Date: Thu, 30 Jul 2026 01:30:03 -0700
From: Breno Leitao <leitao@debian.org>
To: Jeffin Philip <jeffinphilip14@gmail.com>
Cc: a.hindborg@kernel.org, viro@zeniv.linux.org.uk, sage@newdream.net, 
	linux-kernel@vger.kernel.org, syzbot <syzbot@kernel.org>, 
	syzbot+8358d1f3d9c15bdf1c9a@syzkaller.appspotmail.com
Subject: Re: [PATCH] configfs: fix race between symlink and rmdir
Message-ID: <amsLTqLR1I9LOyN2@gmail.com>
References: <20260730032040.95378-1-jeffinphilip14@gmail.com>
Precedence: bulk
X-Mailing-List: syzbot@lists.linux.dev
List-Id: <syzbot.lists.linux.dev>
List-Subscribe: <mailto:syzbot+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:syzbot+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260730032040.95378-1-jeffinphilip14@gmail.com>
X-Debian-User: leitao

On Thu, Jul 30, 2026 at 08:50:40AM +0530, Jeffin Philip wrote:
> From: syzbot <syzbot@kernel.org>

I have never seen a syzbot fix before. Have the policy change and now we
have fixes from bots?
