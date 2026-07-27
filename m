Received: from smtpo75.interia.pl (smtpo75.interia.pl [217.74.67.75])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 996A74908CD
	for <syzbot@lists.linux.dev>; Mon, 27 Jul 2026 10:26:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.74.67.75
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785147975; cv=none; b=s2yPJxhzRKpeAukTxMgvRE0IXBEjSlf7jlDT2Uf2fGzSYfnVOTUJGjMb89QBtS85FKuHC3SliWlhE7uDKBtzvZttQD+2aawBVf0zJIUW5S2kphF1fsBxD7EQhhOlXZZ9f54ghEbbkMrL+f8BZCyEGUcx8rj+yFv4FuWPff8bMhk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785147975; c=relaxed/simple;
	bh=EDGCZX/L5USTUoaVBHCMPMyVnd621+N9gstomG0BGPI=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=eHzwi+gBZORjFNBprUcfjFvnxHuiPjc//hVaAQNmJjPRh1sdA5CJ9pG5KsS3RwP1eSauSwgm5drN6B4alyC7hFOiaXUUpsOLgDAOqkRwCw08jfCXULk7f4FxqF3mdkL5H+vLshUHP9UV8TGhpcZ21CDMEo4ILLQhR4K4PSn6r7I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=poczta.fm; spf=pass smtp.mailfrom=poczta.fm; dkim=pass (1024-bit key) header.d=poczta.fm header.i=@poczta.fm header.b=nATCzlgU; arc=none smtp.client-ip=217.74.67.75
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=poczta.fm
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=poczta.fm
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=poczta.fm header.i=@poczta.fm header.b="nATCzlgU"
Received: from nr200 (unknown [80.68.231.31])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (P-256) server-digest SHA256)
	(No client certificate requested)
	by poczta.interia.pl (INTERIA.PL) with ESMTPSA;
	Mon, 27 Jul 2026 12:26:06 +0200 (CEST)
Date: Mon, 27 Jul 2026 12:26:03 +0200
From: Slawomir Stepien <sst@poczta.fm>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: syzkaller-bugs@googlegroups.com, linux-wireless@vger.kernel.org,
	linux-kernel@vger.kernel.org, syzbot@lists.linux.dev,
	syzbot+9bdc0c5998ab45b05030@syzkaller.appspotmail.com
Subject: Re: [PATCH v2] mac80211: reject station addition if AP or MLO link
 is inactive
Message-ID: <amcyO4e4bnBPinrP@nr200>
References: <20260727074526.248393-1-sst@poczta.fm>
 <9a9a794ad16663cfd7a652b83455ff16156b9baa.camel@sipsolutions.net>
 <amcjYrOESqnHjbhe@nr200>
 <741854f0b9774ce2da1e5c2fb551631aa4028122.camel@sipsolutions.net>
Precedence: bulk
X-Mailing-List: syzbot@lists.linux.dev
List-Id: <syzbot.lists.linux.dev>
List-Subscribe: <mailto:syzbot+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:syzbot+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <741854f0b9774ce2da1e5c2fb551631aa4028122.camel@sipsolutions.net>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=poczta.fm; s=dk;
	t=1785147967; bh=Skv4u+Bd4Ek7vYtCitVvYMvbYFt1hE/YhDDkH3PmXjA=;
	h=Date:From:To:Subject:Message-ID:MIME-Version:Content-Type;
	b=nATCzlgUAYtZchRUgIYMxFFZy7jclJWBLGjgJHq5EkFuHm0FhlxF+KBpXyfqzRiyJ
	 KwSreN7TLudrmnejbtKUXmmCczQjhuIakWO0vb6QiRxQtBodNHYnaNRxLz297n30l5
	 ck22gwzJT0FaoDPsj3hk00Xb8yHwre8FEUtetvmY=

On lip 27, 2026 11:25, Johannes Berg wrote:
> On Mon, 2026-07-27 at 11:22 +0200, Slawomir Stepien wrote:
> > 
> > I think we do not have. I'm looking at the struct wireless_dev fields and I see that there is just
> > info about what the configuration should be, not info about what is the current state of the device.
> > I also do not see any callback in struct cfg80211_ops that might help to get such info. If I'm wrong
> > then please correct my observation!
> 
> I think we maintain wdev->links[].ap.beacon_interval?

Ah: https://elixir.bootlin.com/linux/v7.1.4/source/net/wireless/nl80211.c#L7188 and
https://elixir.bootlin.com/linux/v7.1.4/source/net/wireless/ap.c#L36. Ok! Let me try using that in
v3 then. Thanks!

> > Beside this, do we think that all devices would always need this rejection? What if firmware of
> > these devices would benefit from *lack* of such rejection? Just thinking aloud, not that I know such
> > devices.
> 
> I don't think it should be legal in the userspace API, and even if they
> did, we'd have to add a flag to let hostapd know about it, and then when
> (probably never) we did that, we could change the checks along with the
> API.

Sure. If you think it should be like that I can agree, since I do not have any opinion here.

-- 
Slawomir Stepien
