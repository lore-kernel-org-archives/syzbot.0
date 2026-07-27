Received: from smtpo63.interia.pl (smtpo63.interia.pl [217.74.67.63])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 71805416CE5
	for <syzbot@lists.linux.dev>; Mon, 27 Jul 2026 13:26:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.74.67.63
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785158810; cv=none; b=O63fjVQGt6lQNmfyXhSCIRNtD/UrQz+uKdDkwyZgIk5Ln/O1m684UxmOtc1L2DPdEYYUQTvLA8wGUHvfd1XKphRi0FOaqYAu0TxJqtFCl1unlfEtBU2gcfDwOAvjD0TOKleRyZY26TyMHVSZLit+tEtg3F5OPbzrR+czbGD1qDM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785158810; c=relaxed/simple;
	bh=lD5SvdNk75UOScJp3ni/m4e8lptYubX4aJwa3zeIvF4=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=R1ECuowGv2dxIpxoP4y86TAqQzFp849pc1RV06XUveP1vXTcVLVRLe2Wv0yWRYw2HqDwMRgTOWdU9EQLxeE1VQF/tLGIHvoYSSlcVQQPqlhqxPrScKQILc0U1YPIbuAhGR0gw4MetMnyFotqJKTmqi74RdQDdUAKnLPyAn9OwaY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=poczta.fm; spf=pass smtp.mailfrom=poczta.fm; dkim=pass (1024-bit key) header.d=poczta.fm header.i=@poczta.fm header.b=Bc8TDAdk; arc=none smtp.client-ip=217.74.67.63
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=poczta.fm
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=poczta.fm
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=poczta.fm header.i=@poczta.fm header.b="Bc8TDAdk"
Received: from nr200 (unknown [80.68.231.31])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (P-256) server-digest SHA256)
	(No client certificate requested)
	by poczta.interia.pl (INTERIA.PL) with ESMTPSA;
	Mon, 27 Jul 2026 15:26:42 +0200 (CEST)
Date: Mon, 27 Jul 2026 15:26:40 +0200
From: Slawomir Stepien <sst@poczta.fm>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: syzkaller-bugs@googlegroups.com, linux-wireless@vger.kernel.org,
	linux-kernel@vger.kernel.org, syzbot@lists.linux.dev,
	syzbot+9bdc0c5998ab45b05030@syzkaller.appspotmail.com
Subject: Re: [PATCH v2] mac80211: reject station addition if AP or MLO link
 is inactive
Message-ID: <amdckJhgBz7xT2F7@nr200>
References: <20260727074526.248393-1-sst@poczta.fm>
 <9a9a794ad16663cfd7a652b83455ff16156b9baa.camel@sipsolutions.net>
 <amcjYrOESqnHjbhe@nr200>
 <741854f0b9774ce2da1e5c2fb551631aa4028122.camel@sipsolutions.net>
 <amcyO4e4bnBPinrP@nr200>
Precedence: bulk
X-Mailing-List: syzbot@lists.linux.dev
List-Id: <syzbot.lists.linux.dev>
List-Subscribe: <mailto:syzbot+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:syzbot+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <amcyO4e4bnBPinrP@nr200>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=poczta.fm; s=dk;
	t=1785158804; bh=pAb9wjj3IkLoMUeJ54KYrBI+XFpYZIGtqvlfjp8V3No=;
	h=Date:From:To:Subject:Message-ID:MIME-Version:Content-Type;
	b=Bc8TDAdk1G/LvIjPQqpLelKNcEvQaOotnLjCrmV87jRa2zfLvs+dz0C2NcqoCVxHB
	 luTfujbKt9UoMz1MVvmr3QnB0q1cpRvgM+WFxOLym0mNKTIrbHk3QeUHkoTwGrpoVF
	 lSM5d8RsE1isSMCsUoFkHJiAlhSnAJjFgLvRjiDA=

On lip 27, 2026 12:26, Slawomir Stepien wrote:
> On lip 27, 2026 11:25, Johannes Berg wrote:
> > On Mon, 2026-07-27 at 11:22 +0200, Slawomir Stepien wrote:
> > > 
> > > I think we do not have. I'm looking at the struct wireless_dev fields and I see that there is just
> > > info about what the configuration should be, not info about what is the current state of the device.
> > > I also do not see any callback in struct cfg80211_ops that might help to get such info. If I'm wrong
> > > then please correct my observation!
> > 
> > I think we maintain wdev->links[].ap.beacon_interval?
> 
> Ah: https://elixir.bootlin.com/linux/v7.1.4/source/net/wireless/nl80211.c#L7188 and
> https://elixir.bootlin.com/linux/v7.1.4/source/net/wireless/ap.c#L36. Ok! Let me try using that in
> v3 then. Thanks!

After taking a closer look at this I wonder how AP_VLAN should be handled? Is there a way on
cfg80211 level to be able to check AP_VLAN's main device state?

My code change would look something like this:

@@ -9404,6 +9404,12 @@ static int nl80211_new_station(struct sk_buff *skb, struct genl_info *info)
        case NL80211_IFTYPE_AP:
        case NL80211_IFTYPE_AP_VLAN:
        case NL80211_IFTYPE_P2P_GO:
+               /* Add new station only after the AP and link has been started */
+               int link = params.link_sta_params.link_id >= 0 ?
+                          params.link_sta_params.link_id : 0;
+               if (!wdev->links[link].ap.beacon_interval)
+                       return -ENETDOWN;
+
                /* ignore WME attributes if iface/sta is not capable */
                if (!(rdev->wiphy.flags & WIPHY_FLAG_AP_UAPSD) ||
                    !(params.sta_flags_set & BIT(NL80211_STA_FLAG_WME)))

but the NL80211_IFTYPE_AP_VLAN case would not work here, right? Can I just do the checking only for
NL80211_IFTYPE_AP and NL80211_IFTYPE_P2P_GO and skip NL80211_IFTYPE_AP_VLAN?

-- 
Slawomir Stepien
