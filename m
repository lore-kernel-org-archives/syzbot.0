Received: from fhigh-b6-smtp.messagingengine.com (fhigh-b6-smtp.messagingengine.com [202.12.124.157])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4B7E33C73DD;
	Thu, 12 Mar 2026 17:07:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=202.12.124.157
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773335285; cv=none; b=qiSed4iC+OvXfsPDSKAnuYv6P+cIqyhjUHbPW/IHKGXrTIXlrWidMeVD/03iET9bmgBJUdg9NjRsUIde9OI1W/sp1g/QQu3HTAcPlqQ2DbhT3j9PBdteBug418GkcnSYrUZzlkQLjMKVXgtlILIF+YRSO2l6goUVxVNS3aYNBkg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773335285; c=relaxed/simple;
	bh=9GUkX1UymzuCmF+KVbUDSfJHfjasrgyAK24MrqryyCI=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=MaU4j+T5n65BE3TWySb56pocWWAQ9ZJdInRL293bcJw7OCNMz1zVNYAkRxcrdxmSlYfUl5aMLbP2UXtKtJ9DA79vJT1n83qTNn88itQo2vYoLT1AR5iR2eDJumhLh03t2mS31bKwPyVts4HnaJ5CUzYtQVw5SuB0Sfx5848aSq0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=queasysnail.net; spf=pass smtp.mailfrom=queasysnail.net; dkim=pass (2048-bit key) header.d=queasysnail.net header.i=@queasysnail.net header.b=bpoPhnD1; dkim=pass (2048-bit key) header.d=messagingengine.com header.i=@messagingengine.com header.b=tZGbEI2U; arc=none smtp.client-ip=202.12.124.157
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=queasysnail.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=queasysnail.net
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=queasysnail.net header.i=@queasysnail.net header.b="bpoPhnD1";
	dkim=pass (2048-bit key) header.d=messagingengine.com header.i=@messagingengine.com header.b="tZGbEI2U"
Received: from phl-compute-06.internal (phl-compute-06.internal [10.202.2.46])
	by mailfhigh.stl.internal (Postfix) with ESMTP id 67AFA7A0188;
	Thu, 12 Mar 2026 13:07:55 -0400 (EDT)
Received: from phl-frontend-03 ([10.202.2.162])
  by phl-compute-06.internal (MEProxy); Thu, 12 Mar 2026 13:07:56 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=queasysnail.net;
	 h=cc:cc:content-type:content-type:date:date:from:from
	:in-reply-to:in-reply-to:message-id:mime-version:references
	:reply-to:subject:subject:to:to; s=fm2; t=1773335275; x=
	1773421675; bh=IoHMK1Z5v/Far6DHpNRk4L2RknvP1nvllRWb9YRM5ro=; b=b
	poPhnD19l6zP3OhPXXt7rqc0r7xNFyQDJpertDLSn6S797mUwW3BYmGSGR2+RzbQ
	T6E3gs8Aepw2O0NkMySke902zenrCaSTzbJHt3TK6XDpJGfx68PA7+imBkCp33xu
	yuBaSOY2D2qlfzsHokLy1XoZDgHBhSMFLu3dfxGQoSRaX32fJjqZbDBEheCFuWQ2
	IfSnC4Car5NHtLTEkGcihx2mrkW/Pjxu3GciPeoW/nR4fHie6rf0dH4X1ZqkqB39
	vAb+tJdtkuK7Id+qXxlXyosVyx6/h1KhFGw123ffYz4X4fblYLAD8XcHpA0csmQk
	nfIx2Gh5yPOHXdlvxDAjA==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	messagingengine.com; h=cc:cc:content-type:content-type:date:date
	:feedback-id:feedback-id:from:from:in-reply-to:in-reply-to
	:message-id:mime-version:references:reply-to:subject:subject:to
	:to:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm1; t=
	1773335275; x=1773421675; bh=IoHMK1Z5v/Far6DHpNRk4L2RknvP1nvllRW
	b9YRM5ro=; b=tZGbEI2U8nOqovnVql7AVObILEhslHJFP5BnxjbqUbCGeVPe12a
	5K7RBtn+llzttiM4YH2cw6VJtQRrrJE5UHF+ZlYD5z8PJCfLrxBUqYqwJZyWO/+Z
	tc6AHE/2DUnn5xyir1Np95LN5/iEOj1F3NXkZfKqRJM6OhwD7KcAdln0wbeb/4Vs
	2qNOc0R7o2i2NKZzQM1aP3IcS854qrP26qzrQm1xCmhafzmeYZpr3vYT+5+QOW9a
	PvFvEC9qEbRdWTQmFtpdoxIgjZasTzHvAAEQpMAS7tvTCYbzTO+VmBe71k/hhEeN
	qgj2FUXBDZB7WSVNAD9zASxqIhPONBV3GLg==
X-ME-Sender: <xms:6vKyabQs5P9vaG1ziPRYpzX31kJ3SGSPwC8lpi9LRwq9SD5rtEIpGw>
    <xme:6vKyaeJXW6Q6lEOQEN_0DYIcKKb_795Fk-F8SIg_1a8_ZNbRcM2k-lQqg1YN9bZtl
    JCw2L1Dgs9V2UgQov19_Fk8N3Q6bhk2HfifWGMX0ICsrur5gFskemU>
X-ME-Received: <xmr:6vKyaaE26KepPkc5aKpgH0sSbkzyESmDfsJBx50hpwkWfccUv15n6JEvqVfZ>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeefgedrtddtgddvkeejfeegucetufdoteggodetrf
    dotffvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfurfetoffkrfgpnffqhgenuceu
    rghilhhouhhtmecufedttdenucesvcftvggtihhpihgvnhhtshculddquddttddmnecujf
    gurhepfffhvfevuffkfhggtggujgesthdtredttddtjeenucfhrhhomhepufgrsghrihhn
    rgcuffhusghrohgtrgcuoehsugesqhhuvggrshihshhnrghilhdrnhgvtheqnecuggftrf
    grthhtvghrnhepuefhhfffgfffhfefueeiudegtdefhfekgeetheegheeifffguedvueff
    fefgudffnecuvehluhhsthgvrhfuihiivgeptdenucfrrghrrghmpehmrghilhhfrhhomh
    epshgusehquhgvrghshihsnhgrihhlrdhnvghtpdhnsggprhgtphhtthhopedukedpmhho
    uggvpehsmhhtphhouhhtpdhrtghpthhtohepphgrsggvnhhisehrvgguhhgrthdrtghomh
    dprhgtphhtthhopehlihhuhhgrnhhgsghinhesghhmrghilhdrtghomhdprhgtphhtthho
    pehshiiisghothdotghitdelkehfrgejtgdujeelhegvtggvrggtsehshiiikhgrlhhlvg
    hrrdgrphhpshhpohhtmhgrihhlrdgtohhmpdhrtghpthhtoheprghnughrvgifsehluhhn
    nhdrtghhpdhrtghpthhtohepsghrihgughgvsehlihhsthhsrdhlihhnuhigrdguvghvpd
    hrtghpthhtohepuggrvhgvmhesuggrvhgvmhhlohhfthdrnhgvthdprhgtphhtthhopegv
    ughumhgriigvthesghhoohhglhgvrdgtohhmpdhrtghpthhtohephhhorhhmsheskhgvrh
    hnvghlrdhorhhgpdhrtghpthhtohepihguohhstghhsehnvhhiughirgdrtghomh
X-ME-Proxy: <xmx:6vKyaTSfVh1FJzPyOUGL7DhbTwDn-Yp2V5srIUhMolYZADoMz53vjg>
    <xmx:6vKyabWKgELkT5Y-lS2bhMwf1MJ-i6hQwewQQ54T8c-AgozTwoQZCA>
    <xmx:6vKyaagKGbcFb7ArRNNCo5UZ-iOz1l7ZQhhDgDeg8ZmY-aB_1A5rtg>
    <xmx:6vKyacfLC6q9OM5IgI9MOYrtNGt_zgZ_4st5VI9l1njoK4qVM3DFNA>
    <xmx:6_KyacB1FvP7GYWqNBuuNTjbi9Dh11w-wtP0EsDuHahZ5x-ObUBSyHgD>
Feedback-ID: i934648bf:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Thu,
 12 Mar 2026 13:07:53 -0400 (EDT)
Date: Thu, 12 Mar 2026 18:07:51 +0100
From: Sabrina Dubroca <sd@queasysnail.net>
To: Paolo Abeni <pabeni@redhat.com>
Cc: Hangbin Liu <liuhangbin@gmail.com>,
	syzbot ci <syzbot+ci098fa7c1795eceac@syzkaller.appspotmail.com>,
	andrew@lunn.ch, bridge@lists.linux.dev, davem@davemloft.net,
	edumazet@google.com, horms@kernel.org, idosch@nvidia.com,
	jiri@resnulli.us, jv@jvosburgh.net, kuba@kernel.org,
	linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
	razor@blackwall.org, sridhar.samudrala@intel.com,
	syzbot@lists.linux.dev, syzkaller-bugs@googlegroups.com
Subject: Re: [syzbot ci] Re: net: move netdev_compute_master_upper_features
 to ndo_set_features
Message-ID: <abLy56AN2BgUI1nG@krikkit>
References: <20260310-offload_compute-v1-0-3df79c09ea65@gmail.com>
 <69b04e91.a70a0220.51e36.0000.GAE@google.com>
 <abBuLV3P6aTzUg3W@krikkit>
 <abC7rdjxv9ENw-tA@fedora>
 <abHcP3GTO29rfKML@krikkit>
 <bcc536ac-dde1-4b63-8fed-70850818472b@redhat.com>
 <abKf8Fg865Fhipwk@krikkit>
 <abLPBEg_-j5rp4IM@fedora>
 <abLivB2KPK0JcTFR@krikkit>
 <2d1e0acc-efad-4166-b738-721d88d533ca@redhat.com>
Precedence: bulk
X-Mailing-List: syzbot@lists.linux.dev
List-Id: <syzbot.lists.linux.dev>
List-Subscribe: <mailto:syzbot+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:syzbot+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <2d1e0acc-efad-4166-b738-721d88d533ca@redhat.com>

2026-03-12, 17:47:45 +0100, Paolo Abeni wrote:
> 
> 
> On 3/12/26 4:58 PM, Sabrina Dubroca wrote:
> > 2026-03-12, 14:34:44 +0000, Hangbin Liu wrote:
> >> On Thu, Mar 12, 2026 at 12:13:52PM +0100, Sabrina Dubroca wrote:
> >>> Proper fix (so that the notification we're sending during
> >>> upper_dev_link has full linkinfo) would be to move
> >>> netdev_upper_dev_link() to after macsec_changelink_common() and fix up
> >>> the error handling. I don't see anything in macsec_add_dev or
> >>> macsec_changelink_common that needs the device to be linked. But
> >>
> >> If we move the netdev_upper_dev_link() after macsec_changelink_common(),
> >> we will not goto nla_put_failure via default, right?
> > 
> > Yes.
> > 
> >>> anyway it doesn't make sense for macsec_fill_info to return -EMSGSIZE
> >>> on invalid data, so the "bandaid" should be included as well.
> >>>
> >>> Should this be part of this series (either just the "bandaid" or the
> >>> "proper fix"+bandaid), since we never saw a problem before?
> >>
> >> Since macsec need the "bandaid" fix either way. How about you post the
> >> "bandaid" fix to net. And I include the "proper fix" in this series for
> >> net-next?
> > 
> > But I don't think it's needed in net. Am I missing a codepath (before
> > your series) where macsec_fill_info could be called for the new device
> > before macsec_newlink returns? If not, it doesn't really qualify as a
> > fix, that's why I was asking Paolo.
> 
> FWIW, I don't see a codepath calling into rtmsg_ifinfo_build_skb()
> before device initialization, so I would be fine targeting net-next with
> the EMSGSIZE-related change.
> 
> Side note, it looks like that the WARN() in the rnnetlink code here
> helped identifying a real problem and correctly returning 0 when the
> key_len is not yet initialized will silence it forever, what about
> preserving a warning for this kind of race? something alike:

Right, I was thinking about putting a DEBUG_NET_WARN_ON_ONCE there.

-- 
Sabrina
