Received: from sipsolutions.net (s3.sipsolutions.net [168.119.38.16])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 83FE1415F2E;
	Thu, 23 Jul 2026 09:14:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=168.119.38.16
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784798073; cv=none; b=CQyeTfGkzOExDLdzQ+N7GlVUpkgg95JYmRQs/b2H8gor3TSLORI42/RCl4yAlqnvnPl9peW9vZAkwltamjk5JfrN+yLla4uzsg64elTsBMHo5pQhxyHfFJ/FviJreExjUuRZeLMNbKGGkIJk9h63IwlHdMhTJ4RyvyweJUwm87g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784798073; c=relaxed/simple;
	bh=pGaahKgydI+3pwBXuLYQLRCa6O47vowTVWMZS012VBo=;
	h=Message-ID:Subject:From:To:Cc:Date:In-Reply-To:References:
	 Content-Type:MIME-Version; b=hgp0UTcHuCSZRNzfN6KsVXwN62pNbcwBCvZ9sH1if219K9C0qerYK6zgWnw6UDyTairzwnFFzR1LhHuTXu3Z881c1FdljCMHcvugTAqGOZFFBceG94SjOMZ38eCZlTCRYqglTg6H1Aj3td0/VJr2pZrjs6M0h4YR6NPJ+34aDZY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=permerror header.from=sipsolutions.net; spf=none smtp.mailfrom=sipsolutions.net; dkim=pass (2048-bit key) header.d=sipsolutions.net header.i=@sipsolutions.net header.b=JTMD2IRD; arc=none smtp.client-ip=168.119.38.16
Authentication-Results: smtp.subspace.kernel.org; dmarc=permerror header.from=sipsolutions.net
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=sipsolutions.net
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=sipsolutions.net header.i=@sipsolutions.net header.b="JTMD2IRD"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=sipsolutions.net; s=mail; h=MIME-Version:Content-Transfer-Encoding:
	Content-Type:References:In-Reply-To:Date:Cc:To:From:Subject:Message-ID:Sender
	:Reply-To:Content-ID:Content-Description:Resent-Date:Resent-From:Resent-To:
	Resent-Cc:Resent-Message-ID; bh=pGaahKgydI+3pwBXuLYQLRCa6O47vowTVWMZS012VBo=;
	t=1784798071; x=1786007671; b=JTMD2IRDASoexxp36O/RdERxHUiFZcouTuZYDWY245PDN7V
	j5NwYBT4BaPVP3N6zLwtqfEYfL1IXMIsh1gfduwfItaiRxklknHj4eHy9ljel5Yg9BcHdITmOR7Xz
	y9khdXi54Fi71LvQmSmhhh+WoBYs2KpQHqXmkZiGGl2GTn2VIZERXv5Nt2DHDQMVNlSEMD1AwrawT
	6qJVSqFfMGHLWtF5L/a/u+e7iCqfS/4FYJxeyfTvZOw25RjnVAkLI+L4BxNl0PNQICK6X+QimQxzE
	9gIarckYwNfr6P+TzzIKo+sDHa3t3XHG3jZkz9NAm2JSqMBGp814FbwNitg643Ig==;
Received: by sipsolutions.net with esmtpsa (TLS1.3:ECDHE_X25519__ECDSA_SECP256R1_SHA256__AES_256_GCM:256)
	(Exim 4.98.2)
	(envelope-from <johannes@sipsolutions.net>)
	id 1wmpVb-0000000AYzi-1hT9;
	Thu, 23 Jul 2026 11:14:28 +0200
Message-ID: <c9fa1c083ef9878240c2ee2fb223413153d93a68.camel@sipsolutions.net>
Subject: Re: [PATCH] wifi: mac80211: reject station association if AP is not
 started
From: Johannes Berg <johannes@sipsolutions.net>
To: syzbot <syzbot@kernel.org>, syzkaller-bugs@googlegroups.com, Slawomir
 Stepien <sst@poczta.fm>, linux-wireless@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, syzbot@lists.linux.dev
Date: Thu, 23 Jul 2026 11:14:26 +0200
In-Reply-To: <373210a9-4365-4cac-823a-0eec391858e7@mail.kernel.org>
References: <373210a9-4365-4cac-823a-0eec391858e7@mail.kernel.org>
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

On Thu, 2026-07-23 at 08:11 +0000, syzbot wrote:
> From: Slawomir Stepien <sst@poczta.fm>

I'm a bit confused? Did syzbot just pick up another patch?

> dereferences the NULL chanctx_conf, triggering a WARN_ON:

That can't be right?

> Fix this by rejecting the addition or modification of a station to the
> associated state if the AP has not been started (chanctx_conf is NULL).

That's a proxy for "AP is started", but not a good one, I think we
actually have a flag or so somewhere? Maybe even reject it in cfg80211?

> Exempt Multi-Link Operation (MLO) interfaces from this check, as they
> handle chanctx_conf per-link rather than globally on the VIF.

Feels like that's only necessary because the proxy is bad.

Also maybe a similar issue arises if an MLO AP is only half-started, and
stations are added to all links, or so?

johannes
