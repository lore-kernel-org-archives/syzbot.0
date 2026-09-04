Received: from sipsolutions.net (s3.sipsolutions.net [168.119.38.16])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B1C6F43A7FD;
	Fri,  4 Sep 2026 09:25:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=168.119.38.16
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788513940; cv=none; b=F4H4bx6cay3adMxeV6SrbCGZ8bQkfcFEqQ4SOZ/uoJ95Qb3zfnytFJBuhpd35rQuATF48vaI+zuKrP2Mt10UpXLWJNCVJvKqqinvXjc6JGIMdilF+Iwyt00hPd4DuYxgOTxQF87279GJJ4qZAnBbSiKhSdGYdNAcvjLfcTj+FWg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788513940; c=relaxed/simple;
	bh=815KNxBt/nYrTWz6m2RyNWciv7yOUi+ag7e5Vt8OV80=;
	h=Message-ID:Subject:From:To:Cc:Date:In-Reply-To:References:
	 Content-Type:MIME-Version; b=NXkhboywQjPcHrmtQ6+IeEpX0723gJ7zGiHbLEFVKHprzF189ShAo6vwwfLkLozsLEFGUnnuaX77HcGk7bsvQyJVh6kApug7QOSYdzAU0yFy/ExWJYQaRCplXJTXYec2ejp4EIM4oDfUaaQsKZJQGXKhSYMHuDsPnUN1vzdbluU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=permerror header.from=sipsolutions.net; spf=pass smtp.mailfrom=sipsolutions.net; dkim=pass (2048-bit key) header.d=sipsolutions.net header.i=@sipsolutions.net header.b=ShUttETv; arc=none smtp.client-ip=168.119.38.16
Authentication-Results: smtp.subspace.kernel.org; dmarc=permerror header.from=sipsolutions.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=sipsolutions.net
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=sipsolutions.net header.i=@sipsolutions.net header.b="ShUttETv"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=sipsolutions.net; s=mail; h=MIME-Version:Content-Transfer-Encoding:
	Content-Type:References:In-Reply-To:Date:Cc:To:From:Subject:Message-ID:Sender
	:Reply-To:Content-ID:Content-Description:Resent-Date:Resent-From:Resent-To:
	Resent-Cc:Resent-Message-ID; bh=9FXH+yb5AOLWY+dXqsZTi2qgJteKLrrRcZjZZHsKnEA=;
	t=1788513938; x=1789723538; b=ShUttETvwGjqZ0PiiK8xC5e6EclArTF38O4lolPlgKn07OK
	yM26N0YOlPsNdIZvT+tvp7VvZDSTJiB7J2y48leCXaQQ5xrNTeeiSIAEKExtvrJOWNA8phHrK/dp0
	jK75O2VRrEjy053NsRi1cBbAb4RfFZmEgP/ZlgmcJKm1jiW6QJAMn2evlKD6KHq2Xq9ACsTCvus2t
	MSNeOmGRVt+Ozw3WsHaw3U9UxhutGDSjUZfdE/qdgJVpBEwciBAbaJWUv2/K4Z8Kbs5GLYGMM20Fb
	x2GjnL0YK0ILfq0h1vwn0UrwAXi7C8sH23dO+PFhD7V1gldO5IVnOxQfK/woSuJw==;
Received: by sipsolutions.net with esmtpsa (TLS1.3:ECDHE_X25519__ECDSA_SECP256R1_SHA256__AES_256_GCM:256)
	(Exim 4.98.2)
	(envelope-from <johannes@sipsolutions.net>)
	id 1x2QAx-00000001Ida-1wgw;
	Fri, 04 Sep 2026 11:25:35 +0200
Message-ID: <113768c35523738bdc7ab8441ecda64a063900bf.camel@sipsolutions.net>
Subject: Re: [PATCH 3/3] wifi: cfg80211: check if AP has been started before
 adding new station
From: Johannes Berg <johannes@sipsolutions.net>
To: Slawomir Stepien <sst@poczta.fm>, syzkaller-bugs@googlegroups.com, 
	linux-wireless@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, syzbot@lists.linux.dev, 
	syzbot+9bdc0c5998ab45b05030@syzkaller.appspotmail.com
Date: Fri, 04 Sep 2026 11:25:34 +0200
In-Reply-To: <20260813090434.2071318-3-sst@poczta.fm>
References: <20260813090434.2071318-1-sst@poczta.fm>
	 <20260813090434.2071318-3-sst@poczta.fm>
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

On Thu, 2026-08-13 at 11:04 +0200, Slawomir Stepien wrote:
>=20
>  	case NL80211_IFTYPE_P2P_GO:
> +		/* Add a new station only after the AP and link has been started */
> +		link_id =3D wdev->valid_links ? params.link_sta_params.link_id : 0;

max() maybe?

> +		if (!wdev->links[link_id].ap.beacon_interval)
> +			return -ENETDOWN;

I think the same issue might exist also for mesh, maybe address that as
well?

And I think you could have a fourth patch to clean up the mac80211 code
to no longer handle the "STA creation on AP_VLAN" case?

johannes
