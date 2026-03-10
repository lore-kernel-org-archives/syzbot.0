Received: from fhigh-b8-smtp.messagingengine.com (fhigh-b8-smtp.messagingengine.com [202.12.124.159])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BD7733451BB;
	Tue, 10 Mar 2026 19:17:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=202.12.124.159
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773170229; cv=none; b=JhHL7GOxTURdJkp9ts1hhIqmZHAc7MvhdN1q7N1HomFAzXAE8xldgjNIZ0NiU2Xwx/i8vZMl/4EboFFugrb0HdWyufuvqlugUFx8oY4kWRubvJ0dVvrdq9bgcdzyKnQPIXm2LDKQrgZY54jxpG8ZifnUwCoaIWXJIAQo2kXT7jg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773170229; c=relaxed/simple;
	bh=JuP6+/Lr1cjvm2XE+GuIWXoKiVNwOzz0tz/+2UHI3Uc=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=dCngej/v/QVHbsUc0P3OdQAPxv8bW9LyRQRSpO6TFgxcCXhzzmGnpyzt6nISeNQIKl1DgrRPlcGHCBh2UWzhkjhAnG+wJ0CFppPLgEhJ9LuwtQtBpot+C8eM9Ye10HORC8VSlhMmEzoPUDQre3G5ah8Ic2aZ4P927mEKwQjHeIA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=queasysnail.net; spf=pass smtp.mailfrom=queasysnail.net; dkim=pass (2048-bit key) header.d=queasysnail.net header.i=@queasysnail.net header.b=LdREGZGo; dkim=pass (2048-bit key) header.d=messagingengine.com header.i=@messagingengine.com header.b=ZK6Aseud; arc=none smtp.client-ip=202.12.124.159
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=queasysnail.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=queasysnail.net
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=queasysnail.net header.i=@queasysnail.net header.b="LdREGZGo";
	dkim=pass (2048-bit key) header.d=messagingengine.com header.i=@messagingengine.com header.b="ZK6Aseud"
Received: from phl-compute-05.internal (phl-compute-05.internal [10.202.2.45])
	by mailfhigh.stl.internal (Postfix) with ESMTP id 26AD17A0045;
	Tue, 10 Mar 2026 15:17:05 -0400 (EDT)
Received: from phl-frontend-04 ([10.202.2.163])
  by phl-compute-05.internal (MEProxy); Tue, 10 Mar 2026 15:17:06 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=queasysnail.net;
	 h=cc:cc:content-type:content-type:date:date:from:from
	:in-reply-to:in-reply-to:message-id:mime-version:references
	:reply-to:subject:subject:to:to; s=fm2; t=1773170224; x=
	1773256624; bh=JI4/ouCYSUkfsJTeYVN/oRQFPt3CQ3rygZ0gT9OgWgg=; b=L
	dREGZGoLV4x/l+VXWiaIWnKW5W6YB7rIF8QhnlRGNbMJoU105gnkM9vVSXPvYRCY
	AoW4GBDiuARb10c7bC0/ft0QmPVUpBppe+DDIUgLy4sABeHAFWTxgYn3NBjIfO0T
	QVDFwwSTjb2AABxoDOQ/rk1T9BqMy7GYFlwNjeYCukmbp6FjK2h5DjxgNbWAr/x3
	ieLZlFtHNbq8wxQx5j7sJ+KrN9SOkWFqNqJRRnZ7vVBc8zXjK954xT1CAN/8EJea
	L5F7yhVU75QqHUJN4YE/zspJIUMz6pUExq9inYhHaoiCA7Nefsf5V/sAlMW4Om/o
	EQiU6nASyGZpYTQyrURgg==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	messagingengine.com; h=cc:cc:content-type:content-type:date:date
	:feedback-id:feedback-id:from:from:in-reply-to:in-reply-to
	:message-id:mime-version:references:reply-to:subject:subject:to
	:to:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm1; t=
	1773170224; x=1773256624; bh=JI4/ouCYSUkfsJTeYVN/oRQFPt3CQ3rygZ0
	gT9OgWgg=; b=ZK6AseudybgGquF2N3sOS7nr14uEW5OImuTAtacpbUJu8lanIg6
	ciGmr2xjxC3TV1+ix9Ba0xwvQpDco8t3dyOVrPsJAG0Wjy5s6LbScEXy9eYgqiIe
	Y0PSrQH6sg3SrI55Af5t4gY/vD1xdsmxBQJQSnIPAPLQkpbTI4FljlOiA6oIS+FC
	wYzknR7UGEi6YfdCGOmhJKOKzKW82P4C7jk3KsNgX6NAS77Dbd8O3Una63/+VDx/
	Ock9VB/5kEAvDdfhSVp4qB732oYjgXI/kjmtxzrDo6VILofpzOY1Capgrm7zzDW1
	PsKmtmqMqgob4KUdcxaf06esqX1ROGw/wNw==
X-ME-Sender: <xms:L26waaPKDXfu4QCIx9w8mCTMZb3HR2oHrV3G7rdvwxY9R3mPo9bEHw>
    <xme:L26waaVQTJ9pBweukW5nCByI4CWi3efirC_sVN0HheWRGkchiObbKmgsq5qsdWyUt
    rXcdw48WO4d5Thvlz5td_lam7QPaPWamiv6WLnedsUmyA7ObmnO5t-b>
X-ME-Received: <xmr:L26waahTxW3dF4a3akUq2syxCsM8UaW93aVyFTRrwjW0ES61rio51uiR8ABf>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeefgedrtddtgddvkedukeegucetufdoteggodetrf
    dotffvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfurfetoffkrfgpnffqhgenuceu
    rghilhhouhhtmecufedttdenucenucfjughrpeffhffvvefukfhfgggtuggjsehttdertd
    dttdejnecuhfhrohhmpefurggsrhhinhgrucffuhgsrhhotggruceoshgusehquhgvrghs
    hihsnhgrihhlrdhnvghtqeenucggtffrrghtthgvrhhnpeeuhffhfffgfffhfeeuieduge
    dtfefhkeegteehgeehieffgfeuvdeuffefgfduffenucevlhhushhtvghrufhiiigvpedt
    necurfgrrhgrmhepmhgrihhlfhhrohhmpehsugesqhhuvggrshihshhnrghilhdrnhgvth
    dpnhgspghrtghpthhtohepudekpdhmohguvgepshhmthhpohhuthdprhgtphhtthhopehs
    hiiisghothdotghitdelkehfrgejtgdujeelhegvtggvrggtsehshiiikhgrlhhlvghrrd
    grphhpshhpohhtmhgrihhlrdgtohhmpdhrtghpthhtoheprghnughrvgifsehluhhnnhdr
    tghhpdhrtghpthhtohepsghrihgughgvsehlihhsthhsrdhlihhnuhigrdguvghvpdhrtg
    hpthhtohepuggrvhgvmhesuggrvhgvmhhlohhfthdrnhgvthdprhgtphhtthhopegvughu
    mhgriigvthesghhoohhglhgvrdgtohhmpdhrtghpthhtohephhhorhhmsheskhgvrhhnvg
    hlrdhorhhgpdhrtghpthhtohepihguohhstghhsehnvhhiughirgdrtghomhdprhgtphht
    thhopehjihhrihesrhgvshhnuhhllhhirdhushdprhgtphhtthhopehjvhesjhhvohhssg
    hurhhghhdrnhgvth
X-ME-Proxy: <xmx:MG6waS9FBNmQGJkNJB2Ht6y5H5u0X9x-K30y1w3ndns1QqVvnknUTw>
    <xmx:MG6waZS489vp7mxWMxn4-XBqNtvlGYWVLvpV9Ad5ivMNb_bH8FoyvA>
    <xmx:MG6waZvs7TMxk2Xmtv-RV61FBRzSD33SwP2Mw4b6evKUOHgoZw1k0Q>
    <xmx:MG6waT5StBnnM6F5oRP_UijvWoBflHEDDfLrIFlS6sa4CgMghPSKyg>
    <xmx:MG6waX886-s4cCWQYpUv-LwAvlJcKVF-wGOwu9mEX3vSO6moqTLsKglZ>
Feedback-ID: i934648bf:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Tue,
 10 Mar 2026 15:17:03 -0400 (EDT)
Date: Tue, 10 Mar 2026 20:17:01 +0100
From: Sabrina Dubroca <sd@queasysnail.net>
To: syzbot ci <syzbot+ci098fa7c1795eceac@syzkaller.appspotmail.com>
Cc: andrew@lunn.ch, bridge@lists.linux.dev, davem@davemloft.net,
	edumazet@google.com, horms@kernel.org, idosch@nvidia.com,
	jiri@resnulli.us, jv@jvosburgh.net, kuba@kernel.org,
	linux-kernel@vger.kernel.org, liuhangbin@gmail.com,
	netdev@vger.kernel.org, pabeni@redhat.com, razor@blackwall.org,
	sridhar.samudrala@intel.com, syzbot@lists.linux.dev,
	syzkaller-bugs@googlegroups.com
Subject: Re: [syzbot ci] Re: net: move netdev_compute_master_upper_features
 to ndo_set_features
Message-ID: <abBuLV3P6aTzUg3W@krikkit>
References: <20260310-offload_compute-v1-0-3df79c09ea65@gmail.com>
 <69b04e91.a70a0220.51e36.0000.GAE@google.com>
Precedence: bulk
X-Mailing-List: syzbot@lists.linux.dev
List-Id: <syzbot.lists.linux.dev>
List-Subscribe: <mailto:syzbot+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:syzbot+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <69b04e91.a70a0220.51e36.0000.GAE@google.com>

2026-03-10, 10:02:09 -0700, syzbot ci wrote:
> batman_adv: batadv0: Not using interface batadv_slave_1 (retrying later): interface not active
> hsr_slave_0: entered promiscuous mode
> hsr_slave_1: entered promiscuous mode
> ------------[ cut here ]------------
> err == -EMSGSIZE
> WARNING: net/core/rtnetlink.c:4421 at rtmsg_ifinfo_build_skb+0x218/0x260, CPU#0: syz-executor/6496

I'm not sure this one is caused by this series, but either way,
reviewing if_nlmsg_size/rtnl_fill_ifinfo for mismatches is really
unpleasant :/

Things I see in rtnl_fill_ifinfo but don't find in if_nlmsg_size:
 - IFLA_PARENT_DEV_NAME
 - IFLA_PARENT_DEV_BUS_NAME
   (both from 00e77ed8e64d ("rtnetlink: add
   IFLA_PARENT_[DEV|DEV_BUS]_NAME"), which doesn't include a change to
   if_nlmsg_size)
 - rtnl_link_slave_info_fill also outputs IFLA_INFO_SLAVE_KIND + the
   IFLA_INFO_SLAVE_DATA nest, but rtnl_link_get_slave_info_data_size
   only counts the nest, and its caller (rtnl_link_get_size) doesn't
   have anything more about the slave info. This may be what syzbot is
   tripping on here.


But there's a

    + nla_total_size(4) /* IFLA_WEIGHT */

that doesn't get filled anywhere.


> Modules linked in:
> CPU: 0 UID: 0 PID: 6496 Comm: syz-executor Not tainted syzkaller #0 PREEMPT(full) 
> Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS 1.16.2-debian-1.16.2-1 04/01/2014
> RIP: 0010:rtmsg_ifinfo_build_skb+0x218/0x260
> Code: f6 ba 01 00 00 00 89 e9 e8 25 15 3a 00 4c 89 f0 48 83 c4 30 5b 41 5c 41 5d 41 5e 41 5f 5d e9 7f 3a 2e 02 cc e8 49 3b 42 f8 90 <0f> 0b 90 eb 90 89 d9 80 e1 07 fe c1 38 c1 0f 8c 95 fe ff ff 48 89
> RSP: 0018:ffffc9000637e9a0 EFLAGS: 00010293
> RAX: ffffffff89835e27 RBX: 0000000000000000 RCX: ffff8881b80a57c0
> RDX: 0000000000000000 RSI: 00000000ffffffa6 RDI: 00000000ffffffa6
> RBP: 00000000ffffffa6 R08: 0000000000000004 R09: 0000000000000004
> R10: fffff52000c6fcdc R11: 0000000000000000 R12: 1ffff110235ddc21
> R13: 0000000000000000 R14: ffff8881133dc780 R15: ffff88811aeee000
> FS:  0000555557c4a500(0000) GS:ffff88818de65000(0000) knlGS:0000000000000000
> CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> CR2: 000055555e1838c8 CR3: 0000000168b80000 CR4: 00000000000006f0
> Call Trace:
>  <TASK>
>  rtnetlink_event+0x1b7/0x270
>  notifier_call_chain+0x1be/0x400
>  netdev_change_features+0x95/0xe0
>  __netdev_upper_dev_link+0xb20/0xc80
>  netdev_upper_dev_link+0xb0/0x100
>  macsec_newlink+0xb11/0x1200
>  rtnl_newlink_create+0x329/0xb70
>  rtnl_newlink+0x1666/0x1be0

-- 
Sabrina
