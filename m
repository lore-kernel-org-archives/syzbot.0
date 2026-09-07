Received: from smtpo63.interia.pl (smtpo63.interia.pl [217.74.67.63])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 11B783CF1FD
	for <syzbot@lists.linux.dev>; Mon,  7 Sep 2026 09:46:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.74.67.63
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788774397; cv=none; b=s6+SCNkI4yWx/5Ttc5RIR0g7OyKQnmTRvI0cIYMV9wS5PjtMrv1Bk7kh/0lTwQTCwwe+UzojAyAf+FHVxSQP4IuFtgUyDJHzo+HKra+gcOOnGvlpZ6NVTpR/YXgsbpELwVE4XuizaXWBRLKjCKIi9RhyMZVnWYpw7PaPZbLdwIw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788774397; c=relaxed/simple;
	bh=NcIZPAEXx+xGpOzOy3HmqtQivZXN0toLyO/bs9gO084=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=cVcS8GzDlBq10aM2TvGCMhSbMW2wpvFi5ts4o4dJjhGYRtwsKiQCPJDgjhkCSnwjPz6XY+NsTqXt0TsY2uKBoREbgeTnY+FgvZy01m/T0CPDDNjsR1AJMvpU25hXtKnRLow3T6h1saMJQ0xnC9fbiLCmb5Q1e43lUn8IV677FQ0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=poczta.fm; spf=pass smtp.mailfrom=poczta.fm; dkim=pass (1024-bit key) header.d=poczta.fm header.i=@poczta.fm header.b=wuM37utD; arc=none smtp.client-ip=217.74.67.63
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=poczta.fm
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=poczta.fm
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=poczta.fm header.i=@poczta.fm header.b="wuM37utD"
Received: from nr200 (unknown [80.68.231.31])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (P-256) server-digest SHA256)
	(No client certificate requested)
	by poczta.interia.pl (INTERIA.PL) with ESMTPSA;
	Mon,  7 Sep 2026 11:46:24 +0200 (CEST)
Date: Mon, 7 Sep 2026 11:46:21 +0200
From: Slawomir Stepien <sst@poczta.fm>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: syzkaller-bugs@googlegroups.com, linux-wireless@vger.kernel.org,
	linux-kernel@vger.kernel.org, syzbot@lists.linux.dev,
	syzbot+9bdc0c5998ab45b05030@syzkaller.appspotmail.com
Subject: Re: [PATCH 3/3] wifi: cfg80211: check if AP has been started before
 adding new station
Message-ID: <ap6H7U3j0CgPj2IR@nr200>
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
	t=1788774386; bh=1IVuQ9U4trB4ZPIHclI3jr/GrbNDukNvOZV7lT2GCjA=;
	h=Date:From:To:Subject:Message-ID:MIME-Version:Content-Type;
	b=wuM37utDTKMlOwzx1mCA9VxR+WVjvLuJgS1BMlkR7eOeBbquuBWsbw9wNXzK6as2Y
	 XVMOEYjW7RL0ziDYeg5rHZvT6AitJdIHCG1blq11IxCj3OTqirZ+jxRizfGr+CSQqy
	 Upy867GIVrwDkL4g8i8e2+bOcrhptT1OjymwIJos=

On wrz 04, 2026 11:25, Johannes Berg wrote:
> On Thu, 2026-08-13 at 11:04 +0200, Slawomir Stepien wrote:
> > 
> >  	case NL80211_IFTYPE_P2P_GO:
> > +		/* Add a new station only after the AP and link has been started */
> > +		link_id = wdev->valid_links ? params.link_sta_params.link_id : 0;
> 
> max() maybe?

But wouldn't that blur the intent here? It's not about a bigger value. It's about MLO or not MLO
device handling.

> > +		if (!wdev->links[link_id].ap.beacon_interval)
> > +			return -ENETDOWN;
> 
> I think the same issue might exist also for mesh, maybe address that as
> well?

Sure, I will take a look at this.

> And I think you could have a fourth patch to clean up the mac80211 code
> to no longer handle the "STA creation on AP_VLAN" case?

Sure, will take a look on that too.

Thanks for review!

-- 
Slawomir Stepien
