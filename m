Received: from fhigh-a1-smtp.messagingengine.com (fhigh-a1-smtp.messagingengine.com [103.168.172.152])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 31DB1332637;
	Wed, 11 Mar 2026 21:18:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=103.168.172.152
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773263943; cv=none; b=juDc5kg3G6PHg7m3gnh3Eev8UR14Ztx5I5jRUEWcjwPe9hugfj44s+nAyyhPsI0LDJQkb0H7F9gxm+xBngGKW2VFM+IR5mbrvh3uDqtahbrCtZxLGAmZwwOGVsmaT+FXvE3z6pBCtd1AcG6X2pMXy+VR6hkaFvbS2j96gwfixO0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773263943; c=relaxed/simple;
	bh=Ck1WGm3JB9WgBILFV8PcGp4nnOpEb0OCQOjIOYjUnPQ=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=dKlhjETt9g8ZKynacWGYhZYlJvm7RzCBina3yqk+3PC9S2KO/he59VjwU/ZbMSXd6+9JXXuw51w7ZXY3ZaSThNFNnI6fRtxMOKNI2c2dcNtJf41ot/bzwQ/cFEkkgNjrX27izCPUCruvvCmDDUqm65c6cnCgYVA/jW3WGwNDoco=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=queasysnail.net; spf=pass smtp.mailfrom=queasysnail.net; dkim=pass (2048-bit key) header.d=queasysnail.net header.i=@queasysnail.net header.b=mYchXt9A; dkim=pass (2048-bit key) header.d=messagingengine.com header.i=@messagingengine.com header.b=Xx5RTjzq; arc=none smtp.client-ip=103.168.172.152
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=queasysnail.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=queasysnail.net
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=queasysnail.net header.i=@queasysnail.net header.b="mYchXt9A";
	dkim=pass (2048-bit key) header.d=messagingengine.com header.i=@messagingengine.com header.b="Xx5RTjzq"
Received: from phl-compute-01.internal (phl-compute-01.internal [10.202.2.41])
	by mailfhigh.phl.internal (Postfix) with ESMTP id 5D38A140018D;
	Wed, 11 Mar 2026 17:18:59 -0400 (EDT)
Received: from phl-frontend-04 ([10.202.2.163])
  by phl-compute-01.internal (MEProxy); Wed, 11 Mar 2026 17:18:59 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=queasysnail.net;
	 h=cc:cc:content-type:content-type:date:date:from:from
	:in-reply-to:in-reply-to:message-id:mime-version:references
	:reply-to:subject:subject:to:to; s=fm2; t=1773263939; x=
	1773350339; bh=4dvTDrogvp784xveY6cb9wwHV9l3oDZGkVzPFiKZYpk=; b=m
	YchXt9A/l86ncX1/IknWrOIt/wZuEki/bJzlL5XwQ9P0+ZtQ8M6GMlIisDRz7W1v
	zwHpN8gIHRz0BeQrYDH6EdZQeYHFiczD1BhVtaE6+mD0NWgV9lutL1SqUq6O2TmA
	Nf4lSip8faMdT4DCsUQrdJEQibFo38gwHSiGZMnGZ/hEvsVUUjlDLJN2UxIOaUe/
	6GXOdaoETxoAH1VSP0lGQUNMDaFc2LCy4qUO2OzALnu8auJU8MVhR/0Qn5fPUfQ/
	e0+EtwUtgl75H8ZwGULePv4+84qKmR4TXAin5d0X90JytT2iwCjPyACfhLvWueoH
	N4UT2bvbgpYQaGJ4J5icg==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	messagingengine.com; h=cc:cc:content-type:content-type:date:date
	:feedback-id:feedback-id:from:from:in-reply-to:in-reply-to
	:message-id:mime-version:references:reply-to:subject:subject:to
	:to:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm1; t=
	1773263939; x=1773350339; bh=4dvTDrogvp784xveY6cb9wwHV9l3oDZGkVz
	PFiKZYpk=; b=Xx5RTjzqij2Al9h5rOMNmWveGexEjHbbDReT2P+CYReXF4lEk2o
	LKYHxXBCVZC2/Ne/3DunBup3qmn7cKsVB8zgQZx2ea+sgoa29a+A3AgLFa4b+IfB
	0Kmt9909Z69oY4UZ2QaC2ZZ8gZQI+Wddw6AihZbNlMhCcf3AOVrvMN3dg+4vNu6n
	zbGJRaKDMUnNgoNRMpCZxAAPG4i79QhtNq6yvn2qcPGtwLJd0w5SiR3mfKqdKPCv
	s1WjXstBkjhDvZoKcsWC2X5gpXIJlg7Tqv+Xlaz5N5rFRoKkpPDbgyGOs/oE1fmr
	IP44qW1hXWqhlCLRPs0MoeNL2FsYQpD7rEA==
X-ME-Sender: <xms:QdyxabnwV8fj_MHWDigFM9VYJ9ARw_dZmfdMEErrDvJvfnUppN1PoQ>
    <xme:QdyxaQNMXp1u7mGfbrAuNEtG-xIBPhFK0UsLz4zV0sJukMR26Znr2eVRiQi4gmtS0
    49b-yQVtNw1Mm2Rsa1mESafvmIbK9gXurRSmLz98RijHZ0qdmSP17yA>
X-ME-Received: <xmr:Qdyxaa7O6wEtqvfxgn4svL9DLaKmSMK-cOi8kKXt0xPrX1g0XkSB7PkoXdc7>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeefgedrtddtgddvkeegleeiucetufdoteggodetrf
    dotffvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfurfetoffkrfgpnffqhgenuceu
    rghilhhouhhtmecufedttdenucesvcftvggtihhpihgvnhhtshculddquddttddmnecujf
    gurhepfffhvfevuffkfhggtggujgesthdtredttddtjeenucfhrhhomhepufgrsghrihhn
    rgcuffhusghrohgtrgcuoehsugesqhhuvggrshihshhnrghilhdrnhgvtheqnecuggftrf
    grthhtvghrnhepuefhhfffgfffhfefueeiudegtdefhfekgeetheegheeifffguedvueff
    fefgudffnecuvehluhhsthgvrhfuihiivgeptdenucfrrghrrghmpehmrghilhhfrhhomh
    epshgusehquhgvrghshihsnhgrihhlrdhnvghtpdhnsggprhgtphhtthhopedukedpmhho
    uggvpehsmhhtphhouhhtpdhrtghpthhtoheplhhiuhhhrghnghgsihhnsehgmhgrihhlrd
    gtohhmpdhrtghpthhtohepshihiigsohhtodgtihdtleekfhgrjegtudejleehvggtvggr
    tgesshihiihkrghllhgvrhdrrghpphhsphhothhmrghilhdrtghomhdprhgtphhtthhope
    grnhgurhgvfieslhhunhhnrdgthhdprhgtphhtthhopegsrhhiughgvgeslhhishhtshdr
    lhhinhhugidruggvvhdprhgtphhtthhopegurghvvghmsegurghvvghmlhhofhhtrdhnvg
    htpdhrtghpthhtohepvgguuhhmrgiivghtsehgohhoghhlvgdrtghomhdprhgtphhtthho
    pehhohhrmhhssehkvghrnhgvlhdrohhrghdprhgtphhtthhopehiughoshgthhesnhhvih
    guihgrrdgtohhmpdhrtghpthhtohepjhhirhhisehrvghsnhhulhhlihdruhhs
X-ME-Proxy: <xmx:Qtyxab0Kdh1k_JNzulDgnlL0w6Zsx1Q63aBASeOlXk47VxnidaU7Gw>
    <xmx:QtyxaQpqynodIxueD5DNU-Cx0OTcPNnvKl1Q1UvMKNurxqKHWXs_xA>
    <xmx:Qtyxadl_j6VgoDMxQmpvFrrQ7W1SucPjmJ2Td67dDqHBtf4gfQdK4A>
    <xmx:QtyxaaS38SbptzcuPgJCvjCyvQGdkVjL7aEPU6Phhiq_bddmho4hcA>
    <xmx:Q9yxabX-8p5DvKatHiRpc1zttMUuerQe5aoJiLAKFWBdNJJsQQ4FfKiI>
Feedback-ID: i934648bf:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Wed,
 11 Mar 2026 17:18:57 -0400 (EDT)
Date: Wed, 11 Mar 2026 22:18:55 +0100
From: Sabrina Dubroca <sd@queasysnail.net>
To: Hangbin Liu <liuhangbin@gmail.com>
Cc: syzbot ci <syzbot+ci098fa7c1795eceac@syzkaller.appspotmail.com>,
	andrew@lunn.ch, bridge@lists.linux.dev, davem@davemloft.net,
	edumazet@google.com, horms@kernel.org, idosch@nvidia.com,
	jiri@resnulli.us, jv@jvosburgh.net, kuba@kernel.org,
	linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
	pabeni@redhat.com, razor@blackwall.org, sridhar.samudrala@intel.com,
	syzbot@lists.linux.dev, syzkaller-bugs@googlegroups.com
Subject: Re: [syzbot ci] Re: net: move netdev_compute_master_upper_features
 to ndo_set_features
Message-ID: <abHcP3GTO29rfKML@krikkit>
References: <20260310-offload_compute-v1-0-3df79c09ea65@gmail.com>
 <69b04e91.a70a0220.51e36.0000.GAE@google.com>
 <abBuLV3P6aTzUg3W@krikkit>
 <abC7rdjxv9ENw-tA@fedora>
Precedence: bulk
X-Mailing-List: syzbot@lists.linux.dev
List-Id: <syzbot.lists.linux.dev>
List-Subscribe: <mailto:syzbot+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:syzbot+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <abC7rdjxv9ENw-tA@fedora>

2026-03-11, 00:47:41 +0000, Hangbin Liu wrote:
> On Tue, Mar 10, 2026 at 08:17:01PM +0100, Sabrina Dubroca wrote:
> > 2026-03-10, 10:02:09 -0700, syzbot ci wrote:
> > > batman_adv: batadv0: Not using interface batadv_slave_1 (retrying later): interface not active
> > > hsr_slave_0: entered promiscuous mode
> > > hsr_slave_1: entered promiscuous mode
> > > ------------[ cut here ]------------
> > > err == -EMSGSIZE
> > > WARNING: net/core/rtnetlink.c:4421 at rtmsg_ifinfo_build_skb+0x218/0x260, CPU#0: syz-executor/6496
> > 
> > I'm not sure this one is caused by this series, but either way,
> 
> 
>  rtnetlink_event+0x1b7/0x270
>  notifier_call_chain+0x1be/0x400
>  netdev_change_features+0x95/0xe0
>  __netdev_upper_dev_link+0xb20/0xc80
>  netdev_upper_dev_link+0xb0/0x100
> 
> 
> This patch calls netdev_change_features() after __netdev_upper_dev_link(),
> Which trigger a NETDEV_FEAT_CHANGE notify and calls rtmsg_ifinfo_event()
> to fill the new link info. Maybe the event is a bit early and macsec has
> data not ready?

But this would still mean that there's a mismatch between
if_nlmsg_size() and rtnl_fill_ifinfo(), and your patch is only
revealing it.

I'll send fixes for the stuff I mentioned, no idea if that's what
syzbot saw since we don't have a repro.

-- 
Sabrina
