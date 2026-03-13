Received: from sipsolutions.net (s3.sipsolutions.net [168.119.38.16])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 79C15366DBB;
	Fri, 13 Mar 2026 09:05:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=168.119.38.16
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773392725; cv=none; b=U6rs2jJ77c6SOBKKNolK8treRLPQc7OycwT+tCzvIlDj0zHf+LeX0yBHPc8aljWEqeOE/VM3idMUYNNwg+2ZmPDIUsddOkCw8gQVr6u8qJBwz6wq71tvHLryoyAXCoOEi2Db6Utz8cmX1j1mEabtJPh044OsOH/DdZu9swhB5r4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773392725; c=relaxed/simple;
	bh=IlfMLdaeqkjsl/5qy0NydkWGbW/oAuVJ699N3GtU52M=;
	h=Message-ID:Subject:From:To:Cc:Date:In-Reply-To:References:
	 Content-Type:MIME-Version; b=dW8VTgVALpW0dMtHPLZz5tpBDeZN4bH7nLQS1nVsrquklaWZ2b2zjUcIgSLgp+t83+LYXaVXJlu2UeuhCRjOvEY11dLYFC30Py1jvRDXI8gAajIbB8VCZkvz011opF5QaIPoBabkG7AcL9ltFN1FlFonIBvVgA1BpZaVV/e7UY0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=sipsolutions.net; spf=pass smtp.mailfrom=sipsolutions.net; dkim=pass (2048-bit key) header.d=sipsolutions.net header.i=@sipsolutions.net header.b=HN2ZqsS5; arc=none smtp.client-ip=168.119.38.16
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=sipsolutions.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=sipsolutions.net
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=sipsolutions.net header.i=@sipsolutions.net header.b="HN2ZqsS5"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=sipsolutions.net; s=mail; h=MIME-Version:Content-Transfer-Encoding:
	Content-Type:References:In-Reply-To:Date:Cc:To:From:Subject:Message-ID:Sender
	:Reply-To:Content-ID:Content-Description:Resent-Date:Resent-From:Resent-To:
	Resent-Cc:Resent-Message-ID; bh=45qQd602PD+/oCuiLP2Z8IjqiIstChX0chLIAOGMNqs=;
	t=1773392724; x=1774602324; b=HN2ZqsS5SZl7lnvjszj6zC56sfcq//cv0MjfqHSsdFsfUcn
	StIVcEDQMsE/Sv5ce30mnI3PLzT7w68rF5Fm/ocZZPWiS29VPwlaQXZOQgsBL3FoN9tA3Rddyqzv1
	49F+DSwD1LBt76i8A48bgpDkUMnDrWYH2mHDdxxKYd4GzeHWwW24v2s8NwX1MGKZozxqtLIM08154
	cwiOvctvyRiUz1HO/PpybOmK/LYF5AprtgHF1BhEnyyj4wicAo/rPBn/O1Xny8GM7gXh3NlaVeqx2
	2dDTCoinYVSg3Kd64MwQ7wHkEvwvotc0tEVripa1Qi1m8+AQKYuwvEDtPAtUx9aw==;
Received: by sipsolutions.net with esmtpsa (TLS1.3:ECDHE_X25519__RSA_PSS_RSAE_SHA256__AES_256_GCM:256)
	(Exim 4.98.2)
	(envelope-from <johannes@sipsolutions.net>)
	id 1w0ySK-0000000GpyH-1FTM;
	Fri, 13 Mar 2026 10:05:16 +0100
Message-ID: <855780e1bece0de480b7fd3e1cf67c9f70129818.camel@sipsolutions.net>
Subject: Re: [syzbot ci] Re: misc chandef cleanups
From: Johannes Berg <johannes@sipsolutions.net>
To: syzbot ci <syzbot+ci0f91523e1d0ef709@syzkaller.appspotmail.com>, 
	arien.judge@morsemicro.com, lachlan.hodges@morsemicro.com, 
	linux-wireless@vger.kernel.org
Cc: syzbot@lists.linux.dev, syzkaller-bugs@googlegroups.com
Date: Fri, 13 Mar 2026 10:05:15 +0100
In-Reply-To: <69b3ce9d.050a0220.12d28.010d.GAE@google.com> (sfid-20260313_094520_033447_DA8338B5)
References: <69b3ce9d.050a0220.12d28.010d.GAE@google.com>
	 (sfid-20260313_094520_033447_DA8338B5)
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

On Fri, 2026-03-13 at 01:45 -0700, syzbot ci wrote:
> syzbot ci has tested the following series
>=20
> [v3] misc chandef cleanups
> https://lore.kernel.org/all/20260312045804.362974-1-lachlan.hodges@morsem=
icro.com
> * [PATCH wireless-next v3 1/3] wifi: mac80211: don't use cfg80211_chandef=
_create() for default chandef
> * [PATCH wireless-next v3 2/3] wifi: cfg80211: restrict cfg80211_chandef_=
create() to only HT-based bands
> * [PATCH wireless-next v3 3/3] wifi: cfg80211: check non-S1G width with S=
1G chandef
>=20
> and found the following issue:
> WARNING in cfg80211_chandef_create
>=20
> Full report is available here:
> https://ci.syzbot.org/series/ce6fc7d6-d8d4-4d00-a746-db78cba13e47
>=20
> ***
>=20
> WARNING in cfg80211_chandef_create

D'oh, just after I apply it.

diff --git a/net/wireless/nl80211.c b/net/wireless/nl80211.c
index 3e867930e253..7314312ec567 100644
--- a/net/wireless/nl80211.c
+++ b/net/wireless/nl80211.c
@@ -3634,8 +3634,6 @@ static int _nl80211_parse_chandef(struct cfg80211_reg=
istered_device *rdev,
 		case NL80211_CHAN_HT20:
 		case NL80211_CHAN_HT40PLUS:
 		case NL80211_CHAN_HT40MINUS:
-			cfg80211_chandef_create(chandef, chandef->chan,
-						chantype);
 			/* user input for center_freq is incorrect */
 			if (attrs[NL80211_ATTR_CENTER_FREQ1] &&
 			    chandef->center_freq1 !=3D nla_get_u32(attrs[NL80211_ATTR_CENTER_FR=
EQ1])) {
@@ -3652,6 +3650,11 @@ static int _nl80211_parse_chandef(struct cfg80211_re=
gistered_device *rdev,
 						    "center frequency 2 can't be used");
 				return -EINVAL;
 			}
+			if (chandef->chan->band =3D=3D NL80211_BAND_60GHZ ||
+			    chandef->chan->band =3D=3D NL80211_BAND_S1GHZ)
+				return -EINVAL;
+			cfg80211_chandef_create(chandef, chandef->chan,
+						chantype);
 			break;
 		default:
 			NL_SET_ERR_MSG_ATTR(extack,


I think?

johannes
