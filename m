Received: from sipsolutions.net (s3.sipsolutions.net [168.119.38.16])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E67EF3E120E;
	Fri, 31 Jul 2026 12:40:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=168.119.38.16
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785501623; cv=none; b=CuQQcJ6i0hYiN3r/mKYzsQDb36FZIAs9huhSYa445RpUCO1Ui3MQ85vC7mO5hFYg0AZVz/5xiTGCIrSt6BgfzD9WkLjakfm+P4AW7GXoN7NzrRrGPSSgAOgqIn7cR2vla23RwHwHhvu6BZpq4KC61WS1MOYk3nW7ZQeA9uReEIs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785501623; c=relaxed/simple;
	bh=tn2B029Dtir033b/0Q0ceEw2++qPx2SRAqXFZAZL2Eo=;
	h=Message-ID:Subject:From:To:Cc:Date:In-Reply-To:References:
	 Content-Type:MIME-Version; b=u3HKx3y1ZiLkbvE/cZ7eoZbpxRIs8kXR/BaOhYD72pnAM8IWLqM0tH8VJHOnTQjbNaPtHi98RCp140QJZTwxWgOAsew1Jw/e5WL1Ytjkj8HOie2wecv+tJX8LJSpR399OjEDnKQqtSk/DAC6h4ZgH5cBZCiCWcwyk1VKCNvbT6k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=permerror header.from=sipsolutions.net; spf=pass smtp.mailfrom=sipsolutions.net; dkim=pass (2048-bit key) header.d=sipsolutions.net header.i=@sipsolutions.net header.b=xduaMDKM; arc=none smtp.client-ip=168.119.38.16
Authentication-Results: smtp.subspace.kernel.org; dmarc=permerror header.from=sipsolutions.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=sipsolutions.net
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=sipsolutions.net header.i=@sipsolutions.net header.b="xduaMDKM"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=sipsolutions.net; s=mail; h=MIME-Version:Content-Transfer-Encoding:
	Content-Type:References:In-Reply-To:Date:Cc:To:From:Subject:Message-ID:Sender
	:Reply-To:Content-ID:Content-Description:Resent-Date:Resent-From:Resent-To:
	Resent-Cc:Resent-Message-ID; bh=sqWCceK2vYuDCSiE8EHX4JY4JDuJ6uArfkAkp2kVxsg=;
	t=1785501621; x=1786711221; b=xduaMDKMmskNd7RSCqAC986h+LMJ78AG6bnurHdgLEkPQ3/
	RXtluvz1oMhG8sPkNJqPe6fguWOzKTqNrJUdqMwtUW6fZttQKVP662RGCCndfDH47qFC6Mxb33lxF
	7F58NcTzcEUVsJQ1WSjoLAjFapacVblolkOGhnyj4oxcO7JIjiEoaro+sRWpBlJ3hlKzMO6+3Nuki
	8+RHfNAkmtiHV3lf+8KiOvtenapaxGk9fln3qOT0z002YML8mr31NPy7EDrETXTU69C84XpcZJleq
	Ql/fj/+2Fcqg9S+CwBzquIgPTvfWJiUtc81DTYEnVI4RolW2cVSOtMRu2QJJkS8w==;
Received: by sipsolutions.net with esmtpsa (TLS1.3:ECDHE_X25519__ECDSA_SECP256R1_SHA256__AES_256_GCM:256)
	(Exim 4.98.2)
	(envelope-from <johannes@sipsolutions.net>)
	id 1wpmXB-00000002cdV-3ogt;
	Fri, 31 Jul 2026 14:40:18 +0200
Message-ID: <28f4f5b6fbe594c41538d5068b2d77495250ecd7.camel@sipsolutions.net>
Subject: Re: [PATCH v2] mac80211: reject station addition if AP or MLO link
 is inactive
From: Johannes Berg <johannes@sipsolutions.net>
To: Slawomir Stepien <sst@poczta.fm>
Cc: syzkaller-bugs@googlegroups.com, linux-wireless@vger.kernel.org, 
	linux-kernel@vger.kernel.org, syzbot@lists.linux.dev, 
	syzbot+9bdc0c5998ab45b05030@syzkaller.appspotmail.com
Date: Fri, 31 Jul 2026 14:40:16 +0200
In-Reply-To: <amdckJhgBz7xT2F7@nr200>
References: <20260727074526.248393-1-sst@poczta.fm>
	 <9a9a794ad16663cfd7a652b83455ff16156b9baa.camel@sipsolutions.net>
	 <amcjYrOESqnHjbhe@nr200>
	 <741854f0b9774ce2da1e5c2fb551631aa4028122.camel@sipsolutions.net>
	 <amcyO4e4bnBPinrP@nr200> <amdckJhgBz7xT2F7@nr200>
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

On Mon, 2026-07-27 at 15:26 +0200, Slawomir Stepien wrote:
> After taking a closer look at this I wonder how AP_VLAN should be handled=
? Is there a way on
> cfg80211 level to be able to check AP_VLAN's main device state?

Hmm, yeah that might be an issue? I guess in theory it could track it,
but it doesn't.

> My code change would look something like this:
>=20
> @@ -9404,6 +9404,12 @@ static int nl80211_new_station(struct sk_buff *skb=
, struct genl_info *info)
>         case NL80211_IFTYPE_AP:
>         case NL80211_IFTYPE_AP_VLAN:
>         case NL80211_IFTYPE_P2P_GO:
> +               /* Add new station only after the AP and link has been st=
arted */
> +               int link =3D params.link_sta_params.link_id >=3D 0 ?
> +                          params.link_sta_params.link_id : 0;
> +               if (!wdev->links[link].ap.beacon_interval)
> +                       return -ENETDOWN;
> +
>                 /* ignore WME attributes if iface/sta is not capable */
>                 if (!(rdev->wiphy.flags & WIPHY_FLAG_AP_UAPSD) ||
>                     !(params.sta_flags_set & BIT(NL80211_STA_FLAG_WME)))
>=20
> but the NL80211_IFTYPE_AP_VLAN case would not work here, right? Can I jus=
t do the checking only for
> NL80211_IFTYPE_AP and NL80211_IFTYPE_P2P_GO and skip NL80211_IFTYPE_AP_VL=
AN?

Yeah it'd just reject everything, I guess.

I think in practice stations are added at the AP interface first and
then moved to a VLAN, which would argue for actually rejecting
everything being OK anyway - but then that shouldn't be because of this
but rather by just removing the AP_VLAN case there, or so.

Not sure what the best thing would be though.

johannes
