Received: from smtpo75.interia.pl (smtpo75.interia.pl [217.74.67.75])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D529155295A
	for <syzbot@lists.linux.dev>; Tue,  8 Sep 2026 13:36:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.74.67.75
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788874580; cv=none; b=e2eDWrULsuH5Njp1lXKELguWDn8i1Csll/lz/Qjg2B+TIiUxACuJQa8JLRdLp6W3yrGWYlaWNoVMZJULufM/Pr60SLgvn55RgDU7BAnOfJS08jY4y5TFR/Sy487nefTmawdHx8EqXM9JFZpUvi0v66BiPOxbox8v3svM2WS3A8k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788874580; c=relaxed/simple;
	bh=d91FVQPyCh+jTIQ3aXYMVCYEU0FdnfxhA9uDRZlyrrs=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Ean7kxcnk8AD1HerKgqNiJ6y7t9TGfX1f4M1VV2QtF5PywEB8OcMN0HamEpu2TU35Nj9ZtSDqamMjyHq1yNI+8UP4Rps9sRgcjAgRrd+1xq8XVo3pH9nVkgIcTSy3UY+RsImXSX1pr2wbrJfJY8Qp2EvksmXbkrKLrCyQcVOHLI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=poczta.fm; spf=pass smtp.mailfrom=poczta.fm; dkim=pass (1024-bit key) header.d=poczta.fm header.i=@poczta.fm header.b=zQxDii8h; arc=none smtp.client-ip=217.74.67.75
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=poczta.fm
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=poczta.fm
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=poczta.fm header.i=@poczta.fm header.b="zQxDii8h"
Received: from nr200 (unknown [80.68.231.31])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (P-256) server-digest SHA256)
	(No client certificate requested)
	by poczta.interia.pl (INTERIA.PL) with ESMTPSA;
	Tue,  8 Sep 2026 15:36:00 +0200 (CEST)
Date: Tue, 8 Sep 2026 15:35:57 +0200
From: Slawomir Stepien <sst@poczta.fm>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: syzkaller-bugs@googlegroups.com, linux-wireless@vger.kernel.org,
	linux-kernel@vger.kernel.org, syzbot@lists.linux.dev,
	syzbot+9bdc0c5998ab45b05030@syzkaller.appspotmail.com
Subject: Re: [PATCH 3/3] wifi: cfg80211: check if AP has been started before
 adding new station
Message-ID: <aqAPPd4qHy0qjo1k@nr200>
References: <20260813090434.2071318-1-sst@poczta.fm>
 <20260813090434.2071318-3-sst@poczta.fm>
 <113768c35523738bdc7ab8441ecda64a063900bf.camel@sipsolutions.net>
 <ap_Y8OD0eBAnB8QS@nr200>
 <8934029f86b1c0e75f777185b2768f8e9755cae5.camel@sipsolutions.net>
 <ap_4hS6M8g4u6z--@nr200>
 <22e7ddfc50d7a6a16c437b876dab5fe223799610.camel@sipsolutions.net>
Precedence: bulk
X-Mailing-List: syzbot@lists.linux.dev
List-Id: <syzbot.lists.linux.dev>
List-Subscribe: <mailto:syzbot+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:syzbot+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <22e7ddfc50d7a6a16c437b876dab5fe223799610.camel@sipsolutions.net>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=poczta.fm; s=dk;
	t=1788874562; bh=lBw5ksq4+FXFhNeSk6hQ2VvNAC5I5/HvJUHhLvQbRj8=;
	h=Date:From:To:Subject:Message-ID:MIME-Version:Content-Type;
	b=zQxDii8hLUsaYr/bYhQWf7U/wkq+Ttc2YzDutw9jTlv/9ZQlDUFgT2g/qlYj4LOHV
	 3Yi2BGlUapTflGznIQDsk7RB2DqEeBorQ+1xqt/jbFQnELdCfRnu8BrOGHUODzihT0
	 9Bf35ia7nXCvqIyMpyZe051cXRHmZEzNtaQr2ZKI=

On wrz 08, 2026 14:25, Johannes Berg wrote:
> On Tue, 2026-09-08 at 13:59 +0200, Slawomir Stepien wrote:
> > > 
> > > Don't think you're missing anything, there's just the block handling
> > > param->vlan in add_station, it's dead code now. But why not kill it?
> > 
> > For the reason explained below (in my previous message).
> > There can still be a command from userspace with AP base interface (as wdev) with
> > attrs[NL80211_ATTR_STA_VLAN] set and this block will be executed in such case. Right?
> 
> D'oh. Going too fast, I somehow managed to not connect the two things.
> Sorry!
> 
> But it's another messy code path - if you have AP A and B, and VLANs A'
> and B' belonging to A and B respectively, then you can
> 
> 	add_station(A, vlan=B')
> 
> and it gets added on B/B', and B must be IFF_UP (because B' must be
> IFF_UP) but doesn't need to be beaconing and we're back to the bug, it
> seems? Maybe I'm missing something.

You can't add a vlan interface that dosn't have correct "parent" wiphy, get_vlan() checks that
already:

	v = dev_get_by_index(genl_info_net(info), nla_get_u32(vlanattr));
	if (!v)
		return ERR_PTR(-ENODEV);

	if (!v->ieee80211_ptr || v->ieee80211_ptr->wiphy != &rdev->wiphy) {
		ret = -EINVAL;
		goto error;
	}

> Since VLANs have to have the same local address as their AP (i.e. we
> need addr(B') == addr(B)), I guess get_vlan() could check this though,
> if it's indeed a problem, and that would avoid it through the chain of
> other invariants (IFF_UP, beaconing, etc.)

This check I've pasted should be good enough, right?

-- 
Slawomir Stepien
