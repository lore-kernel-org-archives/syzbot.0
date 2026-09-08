Received: from sipsolutions.net (s3.sipsolutions.net [168.119.38.16])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 11E12550DB5;
	Tue,  8 Sep 2026 13:37:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=168.119.38.16
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788874638; cv=none; b=gzjlrHL4Vri+zHQ2rtci2gjqEWIRm7RcuWfA8yc0qNgL6GEE8zZYcki26PIKFbB6IuSSR8RCs3b0az3QCx2PXy3sWrLQ/iWH7NvMJ+dT9fIYPDlnZ9yOPd5agHumNkK40rnNHKA8oO56HYtv0LWaciAMuuh1P29k2naR4rJIxRk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788874638; c=relaxed/simple;
	bh=IbM1Bv44TEHTLCWBNjA2HnURrhTufnRRCvdhOSZLlgY=;
	h=Message-ID:Subject:From:To:Cc:Date:In-Reply-To:References:
	 Content-Type:MIME-Version; b=dP4tNwr0exQ65lBQiw7BhgJMOEzzJUsXAxfVfmW2oAsVkmBQpW/z7HXh8BkR8ROJGY83RGpqglTWYKLqezax96wtSlwGt08MseLE1RudaU0S4lU5X2zJk9eYoRTqsN7q9c1Rrv8cmAZDc39kmllKTSzhmjQwFqeqvq1iLd2wfSY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=permerror header.from=sipsolutions.net; spf=pass smtp.mailfrom=sipsolutions.net; dkim=pass (2048-bit key) header.d=sipsolutions.net header.i=@sipsolutions.net header.b=B+APpEOs; arc=none smtp.client-ip=168.119.38.16
Authentication-Results: smtp.subspace.kernel.org; dmarc=permerror header.from=sipsolutions.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=sipsolutions.net
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=sipsolutions.net header.i=@sipsolutions.net header.b="B+APpEOs"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=sipsolutions.net; s=mail; h=MIME-Version:Content-Transfer-Encoding:
	Content-Type:References:In-Reply-To:Date:Cc:To:From:Subject:Message-ID:Sender
	:Reply-To:Content-ID:Content-Description:Resent-Date:Resent-From:Resent-To:
	Resent-Cc:Resent-Message-ID; bh=Baywc0yHKb2bcz/JRqx1yPA4dHvHWOqsOf8KAn6vPfw=;
	t=1788874635; x=1790084235; b=B+APpEOs91AzE75ZKQ0Yqvr4veoaMe9pVnXeZDsNeVgn4FT
	QfP96ENuO++3jXzFQ0oueFt8bswTIYlLA83wFoiA3PuVDZrJnQUbfns5yeb2A0D7Olh4CYPqihUD1
	9oJNOzzSxBhz8YAo9k4x6KJ/AijRmlYzZ/bwPTYf4bQZZ/DfwOvOQ+tKnXGt8yeJr9zsZPr2lcPOy
	H1e7f2OBbY9JBu76JS2C4pwg+OBixKRdka/Bcrp/szHjDNLuhbSKGQhnpTIq+itt+OFkHZtnfirFd
	mIXfWtNGzAgneXi7MNSHC7Dl2TnVgUf2Em4r2Rm6WEcO1+VmpkX8WTtVDr92JVSg==;
Received: by sipsolutions.net with esmtpsa (TLS1.3:ECDHE_X25519__ECDSA_SECP256R1_SHA256__AES_256_GCM:256)
	(Exim 4.98.2)
	(envelope-from <johannes@sipsolutions.net>)
	id 1x3w0c-00000006BkC-49u7;
	Tue, 08 Sep 2026 15:37:11 +0200
Message-ID: <98532cdcf1feb1591353bd4b8e3e84822e3e1a11.camel@sipsolutions.net>
Subject: Re: [PATCH 3/3] wifi: cfg80211: check if AP has been started before
 adding new station
From: Johannes Berg <johannes@sipsolutions.net>
To: Slawomir Stepien <sst@poczta.fm>
Cc: syzkaller-bugs@googlegroups.com, linux-wireless@vger.kernel.org, 
	linux-kernel@vger.kernel.org, syzbot@lists.linux.dev, 
	syzbot+9bdc0c5998ab45b05030@syzkaller.appspotmail.com
Date: Tue, 08 Sep 2026 15:37:10 +0200
In-Reply-To: <aqAPPd4qHy0qjo1k@nr200>
References: <20260813090434.2071318-1-sst@poczta.fm>
	 <20260813090434.2071318-3-sst@poczta.fm>
	 <113768c35523738bdc7ab8441ecda64a063900bf.camel@sipsolutions.net>
	 <ap_Y8OD0eBAnB8QS@nr200>
	 <8934029f86b1c0e75f777185b2768f8e9755cae5.camel@sipsolutions.net>
	 <ap_4hS6M8g4u6z--@nr200>
	 <22e7ddfc50d7a6a16c437b876dab5fe223799610.camel@sipsolutions.net>
	 <aqAPPd4qHy0qjo1k@nr200>
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

On Tue, 2026-09-08 at 15:35 +0200, Slawomir Stepien wrote:
> > But it's another messy code path - if you have AP A and B, and VLANs A'
> > and B' belonging to A and B respectively, then you can
> >=20
> > 	add_station(A, vlan=3DB')
> >=20
> > and it gets added on B/B', and B must be IFF_UP (because B' must be
> > IFF_UP) but doesn't need to be beaconing and we're back to the bug, it
> > seems? Maybe I'm missing something.
>=20
> You can't add a vlan interface that dosn't have correct "parent" wiphy, g=
et_vlan() checks that
> already:
>=20
> 	v =3D dev_get_by_index(genl_info_net(info), nla_get_u32(vlanattr));
> 	if (!v)
> 		return ERR_PTR(-ENODEV);
>=20
> 	if (!v->ieee80211_ptr || v->ieee80211_ptr->wiphy !=3D &rdev->wiphy) {

Sure, but that just means that A and B have to be on the same wiphy.

> This check I've pasted should be good enough, right?

Don't think so? You can have A, B, A' and B' all on the same wiphy.

johannes
