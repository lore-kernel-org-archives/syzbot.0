Received: from sipsolutions.net (s3.sipsolutions.net [168.119.38.16])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9C5A73BCD00;
	Mon,  3 Aug 2026 13:15:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=168.119.38.16
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785762949; cv=none; b=ngl2yk6MZ7aiT2zbB6uXKOGCK9TNQEfOTWL5sucWH0G6ErxCsJiG/IeNI363SQUBNU+UYWRio+yBXAUCBxUO8QdZ6VxBVY10rdv70EgDBWc1d0MTQQZcHWVTy1O+B/UQsvPUpgk83fI7YRQef00XqjHNuJ+f+W5fS3CGQ8rFiKQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785762949; c=relaxed/simple;
	bh=7skgG640I9Y27CSJCPv4vVblkC9ONnYRz3n9i0WG8js=;
	h=Message-ID:Subject:From:To:Cc:Date:In-Reply-To:References:
	 Content-Type:MIME-Version; b=Qk4rgY7MZN5zf0sIDUBC9chOk+3PNM3M8Keh/XqTCWKQyQxXAjijvNrTuDqXsBZB2QRT6RMOMqC4ge4JcAZtXhSZawu+c3Xtu4nO5Vu4QzEt/6+q6qMvAJfE1hJIlBZBNdiAFTUTDgkd3aIsRgDwarKjPbH1eUg8tjL7KTK2U4Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=permerror header.from=sipsolutions.net; spf=pass smtp.mailfrom=sipsolutions.net; dkim=pass (2048-bit key) header.d=sipsolutions.net header.i=@sipsolutions.net header.b=po8rppf3; arc=none smtp.client-ip=168.119.38.16
Authentication-Results: smtp.subspace.kernel.org; dmarc=permerror header.from=sipsolutions.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=sipsolutions.net
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=sipsolutions.net header.i=@sipsolutions.net header.b="po8rppf3"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=sipsolutions.net; s=mail; h=MIME-Version:Content-Transfer-Encoding:
	Content-Type:References:In-Reply-To:Date:Cc:To:From:Subject:Message-ID:Sender
	:Reply-To:Content-ID:Content-Description:Resent-Date:Resent-From:Resent-To:
	Resent-Cc:Resent-Message-ID; bh=IVuFzLv86C3W5DdcoQiE0co6a6YTdM2LHmIH7EuYVAk=;
	t=1785762941; x=1786972541; b=po8rppf3bVm0rA9c0CVeST3bo4uXdNE/2liAJkoIPY4hOl1
	uC0g923lwVhKzjIQ/q4GunZ6fdS7KnaeYEhwHXNae8BopsJPKqxpkGuQgQ4AUC8HIhZG1oYtXaNI0
	5dCE/0fXwiQ4gmRVuCJa8QeGzqeEbq2VCWvDYCm1AP5IwW17GRdZQN32lnDmZQYCGCCEjbIuSyR3Z
	YvhVj8iUq/n9HvpRkd2C5aqs0Mu8Fsb5BjQV1s0jcp39V3SEuHhoJ48bao+jAP9IWfSQPyAiL7Yn7
	6HttSXv5fZk9yP7NyiqQkxfbWtB9WeE8nOO7S3CcJW9OxOekiXCBhCqazZ241ixw==;
Received: by sipsolutions.net with esmtpsa (TLS1.3:ECDHE_X25519__ECDSA_SECP256R1_SHA256__AES_256_GCM:256)
	(Exim 4.98.2)
	(envelope-from <johannes@sipsolutions.net>)
	id 1wqsVw-0000000E9jT-39Ir;
	Mon, 03 Aug 2026 15:15:33 +0200
Message-ID: <95571b0374a24554beb39cee4fb92852b1222942.camel@sipsolutions.net>
Subject: Re: [PATCH v2] mac80211: reject station addition if AP or MLO link
 is inactive
From: Johannes Berg <johannes@sipsolutions.net>
To: Slawomir Stepien <sst@poczta.fm>
Cc: syzkaller-bugs@googlegroups.com, linux-wireless@vger.kernel.org, 
	linux-kernel@vger.kernel.org, syzbot@lists.linux.dev, 
	syzbot+9bdc0c5998ab45b05030@syzkaller.appspotmail.com
Date: Mon, 03 Aug 2026 15:15:25 +0200
In-Reply-To: <anCTJFZ54Y93O8Qs@nr200>
References: <20260727074526.248393-1-sst@poczta.fm>
	 <9a9a794ad16663cfd7a652b83455ff16156b9baa.camel@sipsolutions.net>
	 <amcjYrOESqnHjbhe@nr200>
	 <741854f0b9774ce2da1e5c2fb551631aa4028122.camel@sipsolutions.net>
	 <amcyO4e4bnBPinrP@nr200> <amdckJhgBz7xT2F7@nr200>
	 <28f4f5b6fbe594c41538d5068b2d77495250ecd7.camel@sipsolutions.net>
	 <anCTJFZ54Y93O8Qs@nr200>
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

On Mon, 2026-08-03 at 15:09 +0200, Slawomir Stepien wrote:
> On lip 31, 2026 14:40, Johannes Berg wrote:
> > On Mon, 2026-07-27 at 15:26 +0200, Slawomir Stepien wrote:
> > > After taking a closer look at this I wonder how AP_VLAN should be han=
dled? Is there a way on
> > > cfg80211 level to be able to check AP_VLAN's main device state?
> >=20
> > Hmm, yeah that might be an issue? I guess in theory it could track it,
> > but it doesn't.
> >=20
> > > My code change would look something like this:
> > >=20
> > > @@ -9404,6 +9404,12 @@ static int nl80211_new_station(struct sk_buff =
*skb, struct genl_info *info)
> > >         case NL80211_IFTYPE_AP:
> > >         case NL80211_IFTYPE_AP_VLAN:
> > >         case NL80211_IFTYPE_P2P_GO:
> > > +               /* Add new station only after the AP and link has bee=
n started */
> > > +               int link =3D params.link_sta_params.link_id >=3D 0 ?
> > > +                          params.link_sta_params.link_id : 0;
> > > +               if (!wdev->links[link].ap.beacon_interval)
> > > +                       return -ENETDOWN;
> > > +
> > >                 /* ignore WME attributes if iface/sta is not capable =
*/
> > >                 if (!(rdev->wiphy.flags & WIPHY_FLAG_AP_UAPSD) ||
> > >                     !(params.sta_flags_set & BIT(NL80211_STA_FLAG_WME=
)))
> > >=20
> > > but the NL80211_IFTYPE_AP_VLAN case would not work here, right? Can I=
 just do the checking only for
> > > NL80211_IFTYPE_AP and NL80211_IFTYPE_P2P_GO and skip NL80211_IFTYPE_A=
P_VLAN?
> >=20
> > Yeah it'd just reject everything, I guess.
> >=20
> > I think in practice stations are added at the AP interface first and
> > then moved to a VLAN, which would argue for actually rejecting
>=20
> But are they moved and then this `case NL80211_IFTYPE_AP_VLAN` should mat=
ch?

I'm not entirely sure, but I believe they're _added_ to the AP first,
and then _modified_ to be in the AP_VLAN via another path
(NL80211_CMD_SET_STATION, NL80211_ATTR_VLAN_ID).

The question is whether or not we can rely on this, i.e. no userspace
ever used the other path.

> In my tests this case doesn't match, even after the STA is assoc with vla=
n interface (e.g.
> wlan0.10).

Right.

> My test is done using qemu with:

I'd probably use UML/hwsim tests, but sure.

> This index 4 is assigned to wlan0, so it will never have iftype =3D=3D NL=
80211_IFTYPE_AP_VLAN.
> Also the print of wdev->identifier will give 0x1 and not 0x2.
>=20
> So, is it even possible that `case NL80211_IFTYPE_AP_VLAN` would match? I=
f it will never match, then
> do I understand that the change I proposed should be correct for other ca=
ses?

Well, it's _possible_, right? It just appears to not be used in
practice, as I described above (guess your test says I'm right).

But then I think we should do two changes:

1) simply refuse adding stations to AP_VLAN, i.e. drop the
   NL80211_IFTYPE_AP_VLAN case entirely from the function

2) make the change you suggested validating the link


Actually only validating the link as you showed would basically achieve
(1) with -ENETDOWN (we've been using -ENOLINK btw) rather than with the
-EOPNOTSUPP error from the default switch case, but it also seems less
explicit...

Or maybe just do both in one commit?

johannes
