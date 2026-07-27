Received: from sipsolutions.net (s3.sipsolutions.net [168.119.38.16])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EE4AE3DC4BC;
	Mon, 27 Jul 2026 08:19:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=168.119.38.16
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785140353; cv=none; b=uvYW+sLFrA3iADBFmdcwKs6LHsnftEuv3NvDZ3HX1frffZlUX0ljeSOklBSDkU8pExygppbAOIWolTCJ2rES5XtZQyGfFfLwxst1Kp6dMix55+do/gq5BwZa515wap/GUFIVqWQAEpOztRjRu7W8W28yjUQlWP7CFXss9T0gWfA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785140353; c=relaxed/simple;
	bh=1hdwlpnfmP5MxpPLGHNe7Z9gXctieD7gGoOXG1smzKk=;
	h=Message-ID:Subject:From:To:Cc:Date:In-Reply-To:References:
	 Content-Type:MIME-Version; b=Cy7WADbN0Qfwh5W+3NtueKptiF6oXvDcCqa5boiMqF4BD3PgnoJakO+d/Jns95SsVq6f7McMwivpg7NMKIDY67+N35iyVGa1xr3ohG4xjjp3h+u8MZd2pr5WmCp7CVN27T75mYv2cLxrUuatNKH+yCSc7Fvg8ElcuSgh9b9vtH4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=permerror header.from=sipsolutions.net; spf=pass smtp.mailfrom=sipsolutions.net; dkim=pass (2048-bit key) header.d=sipsolutions.net header.i=@sipsolutions.net header.b=HbkyTvSg; arc=none smtp.client-ip=168.119.38.16
Authentication-Results: smtp.subspace.kernel.org; dmarc=permerror header.from=sipsolutions.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=sipsolutions.net
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=sipsolutions.net header.i=@sipsolutions.net header.b="HbkyTvSg"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=sipsolutions.net; s=mail; h=MIME-Version:Content-Transfer-Encoding:
	Content-Type:References:In-Reply-To:Date:Cc:To:From:Subject:Message-ID:Sender
	:Reply-To:Content-ID:Content-Description:Resent-Date:Resent-From:Resent-To:
	Resent-Cc:Resent-Message-ID; bh=20htQIMMefB01KOSqaQeJiYexQeGaj0lvGorN8enL1g=;
	t=1785140352; x=1786349952; b=HbkyTvSg7J2+ES3vpI23iAIxtPG9HbR9amk13aYM4RttN3I
	Ss1NjwM38UZ6KToH1BPN0Rl7oKZh+FhnfTGZgYRAO/J+8xMBaiir+uJ/3kDrHv2a46exDbulkUiyh
	A/0Clq/NwqOXynA2i0/NpXKd3eZZLIVhNwqptrxcg6G7pKQunj0tz2UQzvG1mzEBQtt+K+qryKpBk
	53pkb4HJs6G9b6n8BOPxePfFOZItoqwKsYVWmtqc5/MsWIIORsWO6/rpHKbWOdyc1jotb39wQOZJo
	h7JR+3o5Hyx9rBNQs2Lpr5llC1NrAmj7DOqadf+cxpxcMKariVIMurUZHy4kMx1g==;
Received: by sipsolutions.net with esmtpsa (TLS1.3:ECDHE_X25519__ECDSA_SECP256R1_SHA256__AES_256_GCM:256)
	(Exim 4.98.2)
	(envelope-from <johannes@sipsolutions.net>)
	id 1woGYG-0000000E27g-0eyD;
	Mon, 27 Jul 2026 10:19:08 +0200
Message-ID: <9a9a794ad16663cfd7a652b83455ff16156b9baa.camel@sipsolutions.net>
Subject: Re: [PATCH v2] mac80211: reject station addition if AP or MLO link
 is inactive
From: Johannes Berg <johannes@sipsolutions.net>
To: Slawomir Stepien <sst@poczta.fm>, syzkaller-bugs@googlegroups.com, 
	linux-wireless@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, syzbot@lists.linux.dev, 
	syzbot+9bdc0c5998ab45b05030@syzkaller.appspotmail.com
Date: Mon, 27 Jul 2026 10:19:05 +0200
In-Reply-To: <20260727074526.248393-1-sst@poczta.fm>
References: <20260727074526.248393-1-sst@poczta.fm>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.60.2 (3.60.2-1.fc44) 
Precedence: bulk
X-Mailing-List: syzbot@lists.linux.dev
List-Id: <syzbot.lists.linux.dev>
List-Subscribe: <mailto:syzbot+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:syzbot+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-malware-bazaar: not-scanned

Hi,

On Mon, 2026-07-27 at 09:45 +0200, Slawomir Stepien wrote:
> Currently, userspace can issue a netlink command to add a station to
> an AP or P2P GO interface before the AP has fully started, or before
> a specific MLO link has begun beaconing. This will e.g. lead to a
> WARN_ON trigger:
>=20
> WARNING: net/mac80211/rate.c:51 at rate_control_rate_init+0x5a6/0x630
> ...
> Call Trace:
>  <TASK>
>  rate_control_rate_init_all_links+0xf4/0x190 net/mac80211/rate.c:84
>  sta_apply_auth_flags+0x1bc/0x430 net/mac80211/cfg.c:2152
>  sta_apply_parameters+0x126d/0x1b10 net/mac80211/cfg.c:2618
>  ieee80211_add_station+0x3de/0x700 net/mac80211/cfg.c:2684
>  rdev_add_station+0xfc/0x290 net/wireless/rdev-ops.h:201
>  nl80211_new_station+0x1b4e/0x1fd0 net/wireless/nl80211.c:9505
>=20
> Fix this by introducing a two-tiered active state check in
> ieee80211_add_station():

Shouldn't we have enough information in cfg80211 to validate it there,
benefiting other drivers?

johannes
