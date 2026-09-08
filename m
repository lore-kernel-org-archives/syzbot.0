Received: from sipsolutions.net (s3.sipsolutions.net [168.119.38.16])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7F4CD415B6C;
	Tue,  8 Sep 2026 09:46:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=168.119.38.16
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788860816; cv=none; b=JDxkXkqAck17JqUBS0SVChJWJlBhq0SQAUo8opr3kzWs7UW5cCuR5d/eaMaoxSnfGHhxN/IS/YgDuaXKvYg1E1Iwh+Buvm6JuSImbE52UjGuedX260PcBhQBItukLdzHca1ZFh9JGNcaIN9co/pqod/48CvNvlcZ0rDVOx2Clck=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788860816; c=relaxed/simple;
	bh=aSTeJujZL7Qd+AlQIHwP2EXaJ8b9n2ZuXBRSYbjS090=;
	h=Message-ID:Subject:From:To:Cc:Date:In-Reply-To:References:
	 Content-Type:MIME-Version; b=RldwTWRCDyqvJ8CaBZQoFqSyRo8mnNsCCawNPJ3cJ/kAbOkwHrRe73bqNagCu5ZlpOZAaQSJRj+6dxjNOXxi0BY3Z20iFRD4Y2pD5f7g8DaiAkRsJi+sBa5hmyk8+7DX0JEkabVt5mEijBwtt9qS1nk9H8Gq9If7k1EgWE9YsxU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=permerror header.from=sipsolutions.net; spf=pass smtp.mailfrom=sipsolutions.net; dkim=pass (2048-bit key) header.d=sipsolutions.net header.i=@sipsolutions.net header.b=xY68u+pF; arc=none smtp.client-ip=168.119.38.16
Authentication-Results: smtp.subspace.kernel.org; dmarc=permerror header.from=sipsolutions.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=sipsolutions.net
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=sipsolutions.net header.i=@sipsolutions.net header.b="xY68u+pF"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=sipsolutions.net; s=mail; h=MIME-Version:Content-Transfer-Encoding:
	Content-Type:References:In-Reply-To:Date:Cc:To:From:Subject:Message-ID:Sender
	:Reply-To:Content-ID:Content-Description:Resent-Date:Resent-From:Resent-To:
	Resent-Cc:Resent-Message-ID; bh=TNC6RcJ0ZVmGO15r7t4NvSjkRI555Tl8Fnd59Ry1rPM=;
	t=1788860814; x=1790070414; b=xY68u+pFaGd2cICpPhcpGiBkjUlpiZmqAfRwJiRRiSyH57+
	AoKZK6lStp9mhmX3y2B6DHQofStnxjvLomfQzzeR/YHJcAKA49jjPD4HLdOMReEv1bdbceee4a8XR
	vr1fa2ESb0aktPjPJLKWgPRglklplbea2untzPb94OGyj7hELtOyODzI5/LzAvqFbH1DWaBbQrNK2
	KDYTtYiHh/5IZA0KAmgnuyfsz3uGEn+hqZ83N2D4Y5bxRjybzZLIPt5TJYQDQJx8kpGF9OHFxRs3f
	w2hEZIyd2m3FCY+Py653YqbxsauJStUL4nANAhqU7v06vgjZZbb/mVU1cPmcs3sQ==;
Received: by sipsolutions.net with esmtpsa (TLS1.3:ECDHE_X25519__ECDSA_SECP256R1_SHA256__AES_256_GCM:256)
	(Exim 4.98.2)
	(envelope-from <johannes@sipsolutions.net>)
	id 1x3sPj-00000005ww4-1MCG;
	Tue, 08 Sep 2026 11:46:51 +0200
Message-ID: <8934029f86b1c0e75f777185b2768f8e9755cae5.camel@sipsolutions.net>
Subject: Re: [PATCH 3/3] wifi: cfg80211: check if AP has been started before
 adding new station
From: Johannes Berg <johannes@sipsolutions.net>
To: Slawomir Stepien <sst@poczta.fm>
Cc: syzkaller-bugs@googlegroups.com, linux-wireless@vger.kernel.org, 
	linux-kernel@vger.kernel.org, syzbot@lists.linux.dev, 
	syzbot+9bdc0c5998ab45b05030@syzkaller.appspotmail.com
Date: Tue, 08 Sep 2026 11:46:50 +0200
In-Reply-To: <ap_Y8OD0eBAnB8QS@nr200>
References: <20260813090434.2071318-1-sst@poczta.fm>
	 <20260813090434.2071318-3-sst@poczta.fm>
	 <113768c35523738bdc7ab8441ecda64a063900bf.camel@sipsolutions.net>
	 <ap_Y8OD0eBAnB8QS@nr200>
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

On Tue, 2026-09-08 at 11:44 +0200, Slawomir Stepien wrote:
> On wrz 04, 2026 11:25, Johannes Berg wrote:
> > On Thu, 2026-08-13 at 11:04 +0200, Slawomir Stepien wrote:
> > >=20
> > >  	case NL80211_IFTYPE_P2P_GO:
> > > +		/* Add a new station only after the AP and link has been started *=
/
> > > +		link_id =3D wdev->valid_links ? params.link_sta_params.link_id : 0=
;
> >=20
> > max() maybe?
> >=20
> > > +		if (!wdev->links[link_id].ap.beacon_interval)
> > > +			return -ENETDOWN;
> >=20
> > I think the same issue might exist also for mesh, maybe address that as
> > well?
> >=20
> > And I think you could have a fourth patch to clean up the mac80211 code
> > to no longer handle the "STA creation on AP_VLAN" case?
>=20
> But is there such case?
> The only part I think is related is the handling code when params.vlan is=
 set. However, this code is
> still OK. I do not see any other code that would be a good candidate for =
removal/change.
>=20
> Am I missing something here?

Don't think you're missing anything, there's just the block handling
param->vlan in add_station, it's dead code now. But why not kill it?

> Also, during this check, I've came to a conclusion that I will reword a b=
it the commit message for
> PATCH 1/3, since userspace can still add STA to AP_VLAN in one go, using
> attrs[NL80211_ATTR_STA_VLAN] and that's fine, since the wdev would be the=
 base AP interface, so all
> check will happen.

Sure :)

johannes
