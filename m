Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C18B3399360
	for <syzbot@lists.linux.dev>; Fri, 24 Jul 2026 06:50:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=100.103.45.18
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784875855; cv=pass; b=odw7jphEIjvsvq2JvLe1ZPG3TD/QpXPQyjU+A3jfTfTVN+ZhwTEUuOppQPbjZx8q11URx5Uudye+sfj2Rxx7xq0oV178u1pdrNqm3dRu7pHgx5GcY8a1739MxpRYnweN834s54HwtRwRMibRbuFDopQWukhjvbAgc+6oYlBBCOQ=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784875855; c=relaxed/simple;
	bh=Cq2j6nCsG1W9YHy6Es6QD3t5KZFnZu4TP62QK/ukNQg=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=JnPZ99mrdX86VSn1wRJHfp00E621wBaJGmTSk3hg8k/lS9PP8mqqz48j4mU9WJoBF3WMK+EukN0mzE+WQfqOjzk1W19tFcy6lbtQGkXwhxeEy38sQLrv1pxAfX4h8LzvDzf4NtNMM2bajQ+v84uqs6DM1bHTSJGtVPyks+yZ+84=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=poczta.fm header.i=@poczta.fm header.b=tqfx5bxW; arc=pass smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=poczta.fm header.i=@poczta.fm header.b="tqfx5bxW"
Received: by smtp.kernel.org (Postfix)
	id 5185F1F00A3E; Fri, 24 Jul 2026 06:50:53 +0000 (UTC)
Authentication-Results: smtp.kernel.org; arc=none smtp.remote-ip=217.74.67.63
ARC-Seal: i=1; d=kernel.org; s=arc20260519; a=rsa-sha256; cv=none;
	t=1784875853;
	b=YgkHDsJIxiP/yUhLNWfoltUlTYaAnLAIm3J/tov9Yln1UDdI84XrM0aeggdE9nrT2Dsr
	 scnADd1C/NC4FKRlmGJFBU1Ck1bw6ZR7WLka2UIg2P3WAnBWqsnPJpv1TR4LJPqYs4Mep
	 ONT+f7iHpcyZl9q1vHxN8dAQxBtJ8etTMjT/kbVmfFN9cYuh7ld7v91a0rZJ6wUXnMpc0
	 E1Aoh8kMQajLK06bPZTOjllOUi/7mEqueBGBWUlQswSlspIuGHfLFgBa1rs+lmpNHq+Wu
	 4SIepTiMOoPLrroox3YSetonG9uyiBEFl4uQvpmAcrPSzOkBF+bgAJCW+UVe/uCsBtw==
ARC-Message-Signature: i=1; d=kernel.org; s=arc20260519; a=rsa-sha256;
	c=relaxed/relaxed; t=1784875853;
	h=DMARC-Filter:Received:Date:From:To:Cc:Subject:Message-ID:References:
	 MIME-Version:Content-Type:Content-Disposition:In-Reply-To:
	 DKIM-Signature;
	bh=HaUyiyeVE8/D8M/2JyJH7aoOIeDgF0ROU13rB91Bv7w=;
	b=HIRh9XW4lt/gqGTi4Zvr3fbe0R1kys3yB9Y4+LqGgR6I55uWSl1fLF4TWOrEC4nc+YxK
	 csRorNNE0ZfOg83ZvyO1XDrTGvS+HjalFH6UHfH8J7Qo8ycMu1vjBuzTe3ZzNQC6Z61vN
	 7WD3c7A7uddMDCvptlcZr92ukUoiFpunMcPyy96BytGA9/Rdh1C03tO/HVpiLz5Nmh9Ez
	 ygMDKykZi0a5xFpSRLTSBWrTNLleLXBJJRxK07hrdtrpwEE2xfYKbnh6GOhltYc0+Sg15
	 8AiAtnbLdmEdevy06rtBhZivqI0dsO3WeM2/eOUo23D9bxAi3CCkNvx5/46rTk82lIA==
ARC-Authentication-Results: i=1; smtp.kernel.org; dkim=pass header.d=poczta.fm header.i=@poczta.fm header.a=rsa-sha256 header.s=dk header.b=tqfx5bxW;
	dmarc=pass header.from=poczta.fm;
	spf=pass smtp.mailfrom=poczta.fm;
	arc=none smtp.remote-ip=217.74.67.63
Received: from smtpo63.interia.pl (smtpo63.interia.pl [217.74.67.63])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.kernel.org (Postfix) with ESMTPS id E1AD71F00A3D
	for <syzbot@kernel.org>; Fri, 24 Jul 2026 06:50:50 +0000 (UTC)
Authentication-Results: smtp.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=poczta.fm header.i=@poczta.fm header.a=rsa-sha256 header.s=dk header.b=tqfx5bxW
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.kernel.org E1AD71F00A3D
Authentication-Results: smtp.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=poczta.fm
Authentication-Results: smtp.kernel.org; spf=pass smtp.mailfrom=poczta.fm
Received: from nr200 (unknown [80.68.231.31])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (P-256) server-digest SHA256)
	(No client certificate requested)
	by poczta.interia.pl (INTERIA.PL) with ESMTPSA;
	Fri, 24 Jul 2026 08:50:40 +0200 (CEST)
Date: Fri, 24 Jul 2026 08:50:38 +0200
From: Slawomir Stepien <sst@poczta.fm>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: syzbot <syzbot@kernel.org>, syzkaller-bugs@googlegroups.com,
	linux-wireless@vger.kernel.org, linux-kernel@vger.kernel.org,
	syzbot@lists.linux.dev
Subject: Re: [PATCH] wifi: mac80211: reject station association if AP is not
 started
Message-ID: <amMLPgO8Yv1wjMGa@nr200>
References: <373210a9-4365-4cac-823a-0eec391858e7@mail.kernel.org>
 <c9fa1c083ef9878240c2ee2fb223413153d93a68.camel@sipsolutions.net>
Precedence: bulk
X-Mailing-List: syzbot@lists.linux.dev
List-Id: <syzbot.lists.linux.dev>
List-Subscribe: <mailto:syzbot+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:syzbot+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <c9fa1c083ef9878240c2ee2fb223413153d93a68.camel@sipsolutions.net>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=poczta.fm; s=dk;
	t=1784875842; bh=HaUyiyeVE8/D8M/2JyJH7aoOIeDgF0ROU13rB91Bv7w=;
	h=Date:From:To:Subject:Message-ID:MIME-Version:Content-Type;
	b=tqfx5bxWFjmLF7gFIMSPUjc73EyYTmVddwyTlJuo1y1TLj5ybofbY7sfxDji2znUS
	 U0Oy1O2FYBguvXhG7qqBcCdPk+1Xd0B2cfFBaID6Vew9HKawB88hRB+s8xL0+5RVvj
	 484WK87Cc0fEcWrzkHhYCl60RolfngK6+Rp88x6o=

On lip 23, 2026 11:14, Johannes Berg wrote:
> On Thu, 2026-07-23 at 08:11 +0000, syzbot wrote:
> > From: Slawomir Stepien <sst@poczta.fm>
> 
> I'm a bit confused? Did syzbot just pick up another patch?

Hi Johannes!

No, this issue has been found by syzbot while doing fuzzing testing.

> > dereferences the NULL chanctx_conf, triggering a WARN_ON:
> 
> That can't be right?

Yeah, right. I will rephrase it in v2.

> > Fix this by rejecting the addition or modification of a station to the
> > associated state if the AP has not been started (chanctx_conf is NULL).
> 
> That's a proxy for "AP is started", but not a good one, I think we
> actually have a flag or so somewhere? Maybe even reject it in cfg80211?

I haven't seen a good place for rejection, but let me double check.

> > Exempt Multi-Link Operation (MLO) interfaces from this check, as they
> > handle chanctx_conf per-link rather than globally on the VIF.
> 
> Feels like that's only necessary because the proxy is bad.
> 
> Also maybe a similar issue arises if an MLO AP is only half-started, and
> stations are added to all links, or so?

Not sure about MLO, but your suggestion sounds logical and such case might be the same as this one.
I will take a look at this too.

-- 
Slawomir Stepien
