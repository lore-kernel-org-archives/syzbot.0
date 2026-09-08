Received: from smtpo63.interia.pl (smtpo63.interia.pl [217.74.67.63])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6CFB4524AE5
	for <syzbot@lists.linux.dev>; Tue,  8 Sep 2026 09:44:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.74.67.63
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788860666; cv=none; b=Ox5IJQFnpPQD/Xg0TXlsQuq8kW/Rln4KyvpAPd7L7pkrBBh/vppPdtfg2Gs7Whhddb+TTBeOteKdaBob7n0ojpe56KwJy6wVpQLNzytpCqU30EorDjV8ZNp2XSI89JI7Br8oih9Y0ZabNOadSVqlErWzkDYqE9zrGIl64E41B5s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788860666; c=relaxed/simple;
	bh=3nSzLZLYMzxlGIZlESoUGe+P1IGAPlZ6M0eSLcsLM3E=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Nr2xz5AQNL37J2zFfgjVNsbCfJo4TjIceuu6mGvwdR5LCugP0WWQjzW78qWeqPLR02q5W7muakYgNMhnabFdOJ356oKp89CcJNDB7FY0p4nrq7TYn24uAbzCwo2hbqmZwZW8I2qKhGF1FTZfl6odxBQNron40+PSpFISNDEZUms=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=poczta.fm; spf=pass smtp.mailfrom=poczta.fm; dkim=pass (1024-bit key) header.d=poczta.fm header.i=@poczta.fm header.b=q7zaBDqC; arc=none smtp.client-ip=217.74.67.63
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=poczta.fm
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=poczta.fm
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=poczta.fm header.i=@poczta.fm header.b="q7zaBDqC"
Received: from nr200 (unknown [80.68.231.31])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (P-256) server-digest SHA256)
	(No client certificate requested)
	by poczta.interia.pl (INTERIA.PL) with ESMTPSA;
	Tue,  8 Sep 2026 11:44:18 +0200 (CEST)
Date: Tue, 8 Sep 2026 11:44:16 +0200
From: Slawomir Stepien <sst@poczta.fm>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: syzkaller-bugs@googlegroups.com, linux-wireless@vger.kernel.org,
	linux-kernel@vger.kernel.org, syzbot@lists.linux.dev,
	syzbot+9bdc0c5998ab45b05030@syzkaller.appspotmail.com
Subject: Re: [PATCH 3/3] wifi: cfg80211: check if AP has been started before
 adding new station
Message-ID: <ap_Y8OD0eBAnB8QS@nr200>
References: <20260813090434.2071318-1-sst@poczta.fm>
 <20260813090434.2071318-3-sst@poczta.fm>
 <113768c35523738bdc7ab8441ecda64a063900bf.camel@sipsolutions.net>
Precedence: bulk
X-Mailing-List: syzbot@lists.linux.dev
List-Id: <syzbot.lists.linux.dev>
List-Subscribe: <mailto:syzbot+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:syzbot+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <113768c35523738bdc7ab8441ecda64a063900bf.camel@sipsolutions.net>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=poczta.fm; s=dk;
	t=1788860660; bh=qRS7sqO90bq5MVdJypTliiG6818q57NEQsDft4ry+hI=;
	h=Date:From:To:Subject:Message-ID:MIME-Version:Content-Type;
	b=q7zaBDqCkkw/yyr04OVA2Hq5CU58aK1lTU13Ra10D3cNCQUwRzv/chDGAMRcNaTpP
	 eP52WU8Lpc9JUaxRurYVFm/b5Rgzjz+nO9djoqFI5k/a45+sjNcKxWyZORoZMtzvuk
	 SOTugGULAeLg/0UJyMB18y58ulP/Ja2rZBhv4Lag=

On wrz 04, 2026 11:25, Johannes Berg wrote:
> On Thu, 2026-08-13 at 11:04 +0200, Slawomir Stepien wrote:
> > 
> >  	case NL80211_IFTYPE_P2P_GO:
> > +		/* Add a new station only after the AP and link has been started */
> > +		link_id = wdev->valid_links ? params.link_sta_params.link_id : 0;
> 
> max() maybe?
> 
> > +		if (!wdev->links[link_id].ap.beacon_interval)
> > +			return -ENETDOWN;
> 
> I think the same issue might exist also for mesh, maybe address that as
> well?
> 
> And I think you could have a fourth patch to clean up the mac80211 code
> to no longer handle the "STA creation on AP_VLAN" case?

But is there such case?
The only part I think is related is the handling code when params.vlan is set. However, this code is
still OK. I do not see any other code that would be a good candidate for removal/change.

Am I missing something here?

Also, during this check, I've came to a conclusion that I will reword a bit the commit message for
PATCH 1/3, since userspace can still add STA to AP_VLAN in one go, using
attrs[NL80211_ATTR_STA_VLAN] and that's fine, since the wdev would be the base AP interface, so all
check will happen.

-- 
Slawomir Stepien
