Received: from mail-pj1-f47.google.com (mail-pj1-f47.google.com [209.85.216.47])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B9C0B367F4A
	for <syzbot@lists.linux.dev>; Wed, 11 Mar 2026 00:47:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.47
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773190073; cv=none; b=VriFCCgViAqXErGvC60wMHms9nU/WWWttrbNCalLxLykX8v0WJru0S0GJdURSRtwjsN14V3+9/Fq+fABNonYku1llcMHeuPclqCGjB/w3i+HHHPwvz/mh2p55QkyOPRr+OvrcUS9aDejRPouKGZdOkyTq9Fe0TekWPcMgBESgoQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773190073; c=relaxed/simple;
	bh=0NOikj0F4XRAl27fF0T51r1cDQUQLoSd+Y7hpcI8wOg=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=rMuj0Ac5GN+L3uy/KMFkqgFJmpDv53EtS6pwrbE86C4rr4/WlNU0VPwezGkq/EhvGzC1uRUE8BV18/PuA3jLPvXQy3D8gVv9UnO9NqnYR3pUfwxt0VEpJ/JVnVgsnnZg8XXvHtf7nT2xPqD6cDW+AfUd1Z0D/aPfvJdR5kTgtX8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=HvIUFYE9; arc=none smtp.client-ip=209.85.216.47
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="HvIUFYE9"
Received: by mail-pj1-f47.google.com with SMTP id 98e67ed59e1d1-3598a09fcb3so4212562a91.0
        for <syzbot@lists.linux.dev>; Tue, 10 Mar 2026 17:47:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1773190072; x=1773794872; darn=lists.linux.dev;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=D87ZdyQZ4IabAndi5c77q4G/EVeuF8jpmWClRpdBIok=;
        b=HvIUFYE9DJU7OEci29RAOzYS42cyTR5i0YkT4Bj+72PIhL8Nm7WZkobi4FOq1VoIpD
         ItiEranwLo139DwLVKGijoGgZHfqoMmx/6/IPgs08OB+hzidMrvjp6MoYGk+DJW0uG6v
         fBK1AJZukTvR99qGlXJT9jmnKkKLO+T40KJ6sUTDFU9ehTKPjB7WVMwscx7g38fyVye6
         JDBrXJgXmSTz8iUmalpl8n71ohXaHD4l8qfom6upMjhzY1Ku7aIXNjowr54KYtpUm6vD
         yyCj0CnbRacbXZeWOK4WkCyC7e4Exybctid+6H8UhEDVGsxwQC2uNzXO3kfzwcIfu/Lp
         dRgA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1773190072; x=1773794872;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=D87ZdyQZ4IabAndi5c77q4G/EVeuF8jpmWClRpdBIok=;
        b=WkVglNFIUHbm2xMIi64d2mQLdSg/cN4gATvp6jHMBITXC5OuJxKvVNEjZTZnhFMhlS
         BYZPOQr1dAmShXDVxbC2UdRkEo5hD9iA0w2FW6ps2ESCTWK/RA5AKu1+IWaWhiIR8nZF
         JyFkXTlENhhb9o187nRIVYaHKqGCo8bmboQ3wlro/5U3BuU44+t8vRKbO9ALsOzXvFGN
         AxZxIhGWMnV0PYNzHDlchlygjDDkGwwKY4yo+6fZ69cFlbNRXcp0V/ae4CvLo/wU9ASg
         z5Am0TlymHOvzkOzJT0nE6a9LjSyePmDKLrB3SoAFE4trEAhXwSrql1noBy74HU68dsU
         UsPA==
X-Forwarded-Encrypted: i=1; AJvYcCW/vBtQb4ZSjeLFtxgzY2omF3a32g8Ah30tsl4aNJKckg7kI+8J/O175mW+XyIsjfQNRL2eLzM=@lists.linux.dev
X-Gm-Message-State: AOJu0YwMxbntTX1ouuuPyWoBrNea0MBO+aId6vHXysw11c98+9aUuwGj
	f8xKMQZ9gxb+53TyX0KnaAqC7GfMD8XXWXghmZc8B0x0s4EZe/Ri2+tY
X-Gm-Gg: ATEYQzxOAZGPZg82P6F4AUgXjLoXKjNTm0qT6LNyPAdZIRdIZnmVOSldAD1PyP7iv9B
	AMYcwI1A6NXF0NoBX9WLzJ1DF561nH/mBuzz1Ha1/OMLy/2OX3FrDujdBQKI9iAxb7Kl40gcP4g
	9SM+kNgXNa0QLxYCxGoF4rWYOgBxyVkhWm75NTvkdB1z+XnHjS1+FOBvOzwkPHKSAm+Ug7V7gAs
	s+CYc0ljhkM9rVTmNoOzcaZNCaVkDrEGLRzmfPBgZFe0JZ+FURfDTbKI2g738I5jxkoEPvpvSzp
	gMIJYH29OTBdo5VhOh7rdIt6PiRAlIbTvDGlO4eBplPJKwGzpslnXxr1OTdXGDivTnR821jLVo8
	/6MhOdwl8RoFzlqshOQYUDuITF3vFDZZF/BLbDvC/llR7YZsHdqrYXYCgj5es8Ac+g1VVQTjGlb
	KUOgvNinEicCEsjAJjm2lSuRR9lsA=
X-Received: by 2002:a17:902:db06:b0:2ae:5005:a26e with SMTP id d9443c01a7336-2aeae78cb97mr7226095ad.2.1773190071971;
        Tue, 10 Mar 2026 17:47:51 -0700 (PDT)
Received: from fedora ([209.132.188.88])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2aeae378974sm4231175ad.82.2026.03.10.17.47.44
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 10 Mar 2026 17:47:51 -0700 (PDT)
Date: Wed, 11 Mar 2026 00:47:41 +0000
From: Hangbin Liu <liuhangbin@gmail.com>
To: Sabrina Dubroca <sd@queasysnail.net>
Cc: syzbot ci <syzbot+ci098fa7c1795eceac@syzkaller.appspotmail.com>,
	andrew@lunn.ch, bridge@lists.linux.dev, davem@davemloft.net,
	edumazet@google.com, horms@kernel.org, idosch@nvidia.com,
	jiri@resnulli.us, jv@jvosburgh.net, kuba@kernel.org,
	linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
	pabeni@redhat.com, razor@blackwall.org, sridhar.samudrala@intel.com,
	syzbot@lists.linux.dev, syzkaller-bugs@googlegroups.com
Subject: Re: [syzbot ci] Re: net: move netdev_compute_master_upper_features
 to ndo_set_features
Message-ID: <abC7rdjxv9ENw-tA@fedora>
References: <20260310-offload_compute-v1-0-3df79c09ea65@gmail.com>
 <69b04e91.a70a0220.51e36.0000.GAE@google.com>
 <abBuLV3P6aTzUg3W@krikkit>
Precedence: bulk
X-Mailing-List: syzbot@lists.linux.dev
List-Id: <syzbot.lists.linux.dev>
List-Subscribe: <mailto:syzbot+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:syzbot+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <abBuLV3P6aTzUg3W@krikkit>

On Tue, Mar 10, 2026 at 08:17:01PM +0100, Sabrina Dubroca wrote:
> 2026-03-10, 10:02:09 -0700, syzbot ci wrote:
> > batman_adv: batadv0: Not using interface batadv_slave_1 (retrying later): interface not active
> > hsr_slave_0: entered promiscuous mode
> > hsr_slave_1: entered promiscuous mode
> > ------------[ cut here ]------------
> > err == -EMSGSIZE
> > WARNING: net/core/rtnetlink.c:4421 at rtmsg_ifinfo_build_skb+0x218/0x260, CPU#0: syz-executor/6496
> 
> I'm not sure this one is caused by this series, but either way,


 rtnetlink_event+0x1b7/0x270
 notifier_call_chain+0x1be/0x400
 netdev_change_features+0x95/0xe0
 __netdev_upper_dev_link+0xb20/0xc80
 netdev_upper_dev_link+0xb0/0x100


This patch calls netdev_change_features() after __netdev_upper_dev_link(),
Which trigger a NETDEV_FEAT_CHANGE notify and calls rtmsg_ifinfo_event()
to fill the new link info. Maybe the event is a bit early and macsec has
data not ready?

Thanks
Hangbin

> reviewing if_nlmsg_size/rtnl_fill_ifinfo for mismatches is really
> unpleasant :/
> 
> Things I see in rtnl_fill_ifinfo but don't find in if_nlmsg_size:
>  - IFLA_PARENT_DEV_NAME
>  - IFLA_PARENT_DEV_BUS_NAME
>    (both from 00e77ed8e64d ("rtnetlink: add
>    IFLA_PARENT_[DEV|DEV_BUS]_NAME"), which doesn't include a change to
>    if_nlmsg_size)
>  - rtnl_link_slave_info_fill also outputs IFLA_INFO_SLAVE_KIND + the
>    IFLA_INFO_SLAVE_DATA nest, but rtnl_link_get_slave_info_data_size
>    only counts the nest, and its caller (rtnl_link_get_size) doesn't
>    have anything more about the slave info. This may be what syzbot is
>    tripping on here.
> 
> 
> But there's a
> 
>     + nla_total_size(4) /* IFLA_WEIGHT */
> 
> that doesn't get filled anywhere.
> 
> 
> > Modules linked in:
> > CPU: 0 UID: 0 PID: 6496 Comm: syz-executor Not tainted syzkaller #0 PREEMPT(full) 
> > Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS 1.16.2-debian-1.16.2-1 04/01/2014
> > RIP: 0010:rtmsg_ifinfo_build_skb+0x218/0x260
> > Code: f6 ba 01 00 00 00 89 e9 e8 25 15 3a 00 4c 89 f0 48 83 c4 30 5b 41 5c 41 5d 41 5e 41 5f 5d e9 7f 3a 2e 02 cc e8 49 3b 42 f8 90 <0f> 0b 90 eb 90 89 d9 80 e1 07 fe c1 38 c1 0f 8c 95 fe ff ff 48 89
> > RSP: 0018:ffffc9000637e9a0 EFLAGS: 00010293
> > RAX: ffffffff89835e27 RBX: 0000000000000000 RCX: ffff8881b80a57c0
> > RDX: 0000000000000000 RSI: 00000000ffffffa6 RDI: 00000000ffffffa6
> > RBP: 00000000ffffffa6 R08: 0000000000000004 R09: 0000000000000004
> > R10: fffff52000c6fcdc R11: 0000000000000000 R12: 1ffff110235ddc21
> > R13: 0000000000000000 R14: ffff8881133dc780 R15: ffff88811aeee000
> > FS:  0000555557c4a500(0000) GS:ffff88818de65000(0000) knlGS:0000000000000000
> > CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> > CR2: 000055555e1838c8 CR3: 0000000168b80000 CR4: 00000000000006f0
> > Call Trace:
> >  <TASK>
> >  rtnetlink_event+0x1b7/0x270
> >  notifier_call_chain+0x1be/0x400
> >  netdev_change_features+0x95/0xe0
> >  __netdev_upper_dev_link+0xb20/0xc80
> >  netdev_upper_dev_link+0xb0/0x100
> >  macsec_newlink+0xb11/0x1200
> >  rtnl_newlink_create+0x329/0xb70
> >  rtnl_newlink+0x1666/0x1be0
> 
> -- 
> Sabrina
