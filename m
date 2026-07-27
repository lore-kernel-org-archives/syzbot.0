Received: from smtpo63.interia.pl (smtpo63.interia.pl [217.74.67.63])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 70AB63EB0EF
	for <syzbot@lists.linux.dev>; Mon, 27 Jul 2026 09:22:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.74.67.63
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785144171; cv=none; b=nK3h2OkfASU9vN/U3UKpmEQek84F4cntem5Jkw2/u1fTlf7e2JRdYbUw/QuOeTymUFLNOO2ariX8PW3bkyPto/SNxfAx7OVBD8npDOfZBKIMwYQqs3tzo+++Em+xqZJNudi2aeuyuaviagUvzZtGf07ugnuq/UuKR5apA48JxlI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785144171; c=relaxed/simple;
	bh=iUN3fjhrer57UIOpJYXgvpTNk72tPahDSgYKzL7CVTE=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=qCSBGh4X4rQjPLG1RyYOxhKPNFcc0js6WYzHtg/61eOEThB9RH3Zd5peoCpAIU0+DtwBsKUHgGKpJVN6qHjpFLmUa1IDlzR4Wj0rXI64PWk560giQt+PCnnUu3ehIrsKG2NiGy2qOM9AFxscxCEb+Tg22wJdjchNHg1ON2mlCuk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=poczta.fm; spf=pass smtp.mailfrom=poczta.fm; dkim=pass (1024-bit key) header.d=poczta.fm header.i=@poczta.fm header.b=RDdWJ5DS; arc=none smtp.client-ip=217.74.67.63
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=poczta.fm
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=poczta.fm
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=poczta.fm header.i=@poczta.fm header.b="RDdWJ5DS"
Received: from nr200 (unknown [80.68.231.31])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (P-256) server-digest SHA256)
	(No client certificate requested)
	by poczta.interia.pl (INTERIA.PL) with ESMTPSA;
	Mon, 27 Jul 2026 11:22:44 +0200 (CEST)
Date: Mon, 27 Jul 2026 11:22:42 +0200
From: Slawomir Stepien <sst@poczta.fm>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: syzkaller-bugs@googlegroups.com, linux-wireless@vger.kernel.org,
	linux-kernel@vger.kernel.org, syzbot@lists.linux.dev,
	syzbot+9bdc0c5998ab45b05030@syzkaller.appspotmail.com
Subject: Re: [PATCH v2] mac80211: reject station addition if AP or MLO link
 is inactive
Message-ID: <amcjYrOESqnHjbhe@nr200>
References: <20260727074526.248393-1-sst@poczta.fm>
 <9a9a794ad16663cfd7a652b83455ff16156b9baa.camel@sipsolutions.net>
Precedence: bulk
X-Mailing-List: syzbot@lists.linux.dev
List-Id: <syzbot.lists.linux.dev>
List-Subscribe: <mailto:syzbot+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:syzbot+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <9a9a794ad16663cfd7a652b83455ff16156b9baa.camel@sipsolutions.net>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=poczta.fm; s=dk;
	t=1785144166; bh=8LsoGHtzJmiAeNrlGMrO3peOxtO7XvvzHZFkNnZHYDs=;
	h=Date:From:To:Subject:Message-ID:MIME-Version:Content-Type;
	b=RDdWJ5DSKLrIxFjE8h/WTuylEiQ8a+2iW2vJncHO3zzeo0Radnflwvh4t5zUxybEj
	 TFU8HEnVm18E7i0dg+HL9hhFwjbO8SpQTyxp0yE+7b/Cl+7xGJpxD+sSFF3JKD6mVS
	 rrMRZvsXkH2pJgU8sUZzJ5oncjzcKQQ7ki+jwzQk=

On lip 27, 2026 10:19, Johannes Berg wrote:
> Hi,
> 
> On Mon, 2026-07-27 at 09:45 +0200, Slawomir Stepien wrote:
> > Currently, userspace can issue a netlink command to add a station to
> > an AP or P2P GO interface before the AP has fully started, or before
> > a specific MLO link has begun beaconing. This will e.g. lead to a
> > WARN_ON trigger:
> > 
> > WARNING: net/mac80211/rate.c:51 at rate_control_rate_init+0x5a6/0x630
> > ...
> > Call Trace:
> >  <TASK>
> >  rate_control_rate_init_all_links+0xf4/0x190 net/mac80211/rate.c:84
> >  sta_apply_auth_flags+0x1bc/0x430 net/mac80211/cfg.c:2152
> >  sta_apply_parameters+0x126d/0x1b10 net/mac80211/cfg.c:2618
> >  ieee80211_add_station+0x3de/0x700 net/mac80211/cfg.c:2684
> >  rdev_add_station+0xfc/0x290 net/wireless/rdev-ops.h:201
> >  nl80211_new_station+0x1b4e/0x1fd0 net/wireless/nl80211.c:9505
> > 
> > Fix this by introducing a two-tiered active state check in
> > ieee80211_add_station():
> 
> Shouldn't we have enough information in cfg80211 to validate it there,
> benefiting other drivers?

I think we do not have. I'm looking at the struct wireless_dev fields and I see that there is just
info about what the configuration should be, not info about what is the current state of the device.
I also do not see any callback in struct cfg80211_ops that might help to get such info. If I'm wrong
then please correct my observation!

Beside this, do we think that all devices would always need this rejection? What if firmware of
these devices would benefit from *lack* of such rejection? Just thinking aloud, not that I know such
devices.

-- 
Slawomir Stepien
