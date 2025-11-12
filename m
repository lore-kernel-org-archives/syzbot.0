Received: from mail-pf1-f177.google.com (mail-pf1-f177.google.com [209.85.210.177])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2851034575A
	for <syzbot@lists.linux.dev>; Wed, 12 Nov 2025 18:38:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.177
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762972717; cv=none; b=ryYIQq1Q0hzllkYfBQaxatsy5FFw3OUsVdFWNduIKEmrltFk/3EcKMQZJV5p62HPPteDNe2h3JeJedVrtHP8BBLRxvP98SuSf1usG937XQsIaqzrMZyNp3bOs0W5rueimI5z3iRsGSmYmEO2Tmp8pqTENfjpZXeWi+F6i8c5rCw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762972717; c=relaxed/simple;
	bh=rjdI/hPxB57OWIfqIRPggSIvkjgsaZxLZ95HFelCcGY=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=i8oXYz3g69zOIZZtXBTYpgvJsgUKVSW6Li4TysSRKdSPF38zESR50RZ1ldetrJ3XWURQk7aSfAU8YzMxQ9pEEDtkvS03beaTlEq+wSeMXnShwQGF/kn7WNgN/jLfdjaf4Dgj8xrUjvGplh9G6QepuaDpmQ1dKGgmPu4AnWh4pF8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=KgSbhvDQ; arc=none smtp.client-ip=209.85.210.177
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="KgSbhvDQ"
Received: by mail-pf1-f177.google.com with SMTP id d2e1a72fcca58-7af603c06easo3855b3a.0
        for <syzbot@lists.linux.dev>; Wed, 12 Nov 2025 10:38:35 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1762972715; x=1763577515; darn=lists.linux.dev;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=d+G8+iIuAhEgULEzocPDssGo8BH46zvY9bxVPTxi2Vs=;
        b=KgSbhvDQGTBR/4lMnmctcnCrjJjwUGVFALcO8JSZo5isIXoobtIT/wNNf6udlQKv2y
         FbdxPcEev2qyNH+lqPADocYdE8bjWyIZyF8hqlfvYrNIaIifF8RlpBaj5LYuzAO8zxK6
         CIlGofFghnn55eta6NJaC6t4KzqXHlOhOilTuxWnHGrAPh/FKq2Oco9Yus6WcwZLpdml
         c7fj6yMngZSl7Cu65Pj/4C3PJk+VK+W8wptAZtwo2NyTzT0FF7yPRyk9mscOpZZDd+KO
         nK+TBPwQOEEiKf0D3meu2wLDVPD3m2z6NqyftpZ56xZHKFGpmFhh7gxVA6hNpYzv5T1N
         R5dw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1762972715; x=1763577515;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=d+G8+iIuAhEgULEzocPDssGo8BH46zvY9bxVPTxi2Vs=;
        b=P/Spkw3pbcjmo8JTY5mQKSiXG4Zud4E3WJOgaJ/+JlQBBBpH8dPP1F4j0LPPbuYRr0
         VHivI3skdXSCV81BQigRwKA4K0DiLll1eRNqswYSdPMQbwM4nNcUhk2JrNmNapOn0vDk
         k4lz+CVNU6cicxSpeZljzlENTxU4XJ0Tc7U7NW/D+w6cWVptzF26vXKPaTJ9/VN+Kfmb
         icB3LSg4lqKJs1RBBo8YzgpSW84DtySbO1F+P90QOGoKRfkYj8dOWmcHSwovtDAExrje
         t78brhVH0rf6rraxlPjEg/GbTitz4ocgN6ZkTkPMmTySx9DDnMNRCI3q/FoJosrAAnEO
         cghg==
X-Forwarded-Encrypted: i=1; AJvYcCVZ3/1wLDxsTtefEIwCIee6PO8eOsQoAtLwNpdy8KuHodCyMOilGCEspYDhQPickAQOHLAhEgI=@lists.linux.dev
X-Gm-Message-State: AOJu0YwnpKVOIk5RhJiTboTpEQHx4cZkVhNJG/7SpjZMPoa8vfPlaWBt
	JTeP+eb9di6KIr1O6zSzs4LrCiLTyjfM9Mb09Wce4t2Ksa6GbkrO6Qx7
X-Gm-Gg: ASbGncuu18ulhtgFRoyoYBedp9J9UEfot3rv2HMcZBie4yIgQ46/txCQl6rnM3V6ins
	kdRT25Kr9BuEGw4BjnmiAMxbeWmshVrRtd/Eqpxv6L3ts555AWMR7UERznUqvdHYXIPlH8Msj8i
	UKfeMcJVYjDFiBqnxLK0C/odMb/8pSPjd/4eOqvYZXDaj1TBGeCTQv8NbxMPxk8wdr7GR44Pi3i
	7OmE3q/E/3Sulmc6lZ0Jw2wzuRAU1aMfq/FAR/KlUZQGVHXrGe0qhawJx56moo3DHQTUpQFbNMa
	K1zn7AQqYwk0eY+YOu2YsbvlB07q0+DjnzAG8S0/xERtZyQhMq21Qkw6U2+ZUC5vAjo1UcoIbC2
	PbnH1XLYDsu8HlVqKeJhcJ4w4I6E53GvBkA/iRysnt6lM4yl7/grLvOZ2RRB35OYqLjXSIrhpvo
	QUrXfBqxphbAAUj704tF+KyPuHLD1+ADX0
X-Google-Smtp-Source: AGHT+IHkCPrM3gjJlcuUw/ai+5zW7z604YwPQxNzYFX5718wDwKJoqe+bSM0awd32yJLRzmocpTJQg==
X-Received: by 2002:aa7:88d6:0:b0:7a2:7f45:5898 with SMTP id d2e1a72fcca58-7b8e01e21a5mr455797b3a.3.1762972715085;
        Wed, 12 Nov 2025 10:38:35 -0800 (PST)
Received: from fedora (c-67-164-59-41.hsd1.ca.comcast.net. [67.164.59.41])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-7b0cc17a956sm19641876b3a.44.2025.11.12.10.38.34
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 12 Nov 2025 10:38:34 -0800 (PST)
Date: Wed, 12 Nov 2025 10:38:32 -0800
From: "Vishal Moola (Oracle)" <vishal.moola@gmail.com>
To: Uladzislau Rezki <urezki@gmail.com>
Cc: syzbot ci <syzbot+ci9989da8336cb2bc7@syzkaller.appspotmail.com>,
	akpm@linux-foundation.org, hch@lst.de, linux-kernel@vger.kernel.org,
	linux-mm@kvack.org, syzbot@lists.linux.dev,
	syzkaller-bugs@googlegroups.com
Subject: Re: [syzbot ci] Re: make vmalloc gfp flags usage more apparent
Message-ID: <aRTUKDMa8avHdvKp@fedora>
References: <20251110160457.61791-1-vishal.moola@gmail.com>
 <69123b72.a70a0220.22f260.0105.GAE@google.com>
 <aROasppMPmek9Afh@milan>
 <aRQyMck_MeVvvCdX@infradead.org>
 <aRR3O7l2Ewx-VRoE@milan>
Precedence: bulk
X-Mailing-List: syzbot@lists.linux.dev
List-Id: <syzbot.lists.linux.dev>
List-Subscribe: <mailto:syzbot+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:syzbot+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aRR3O7l2Ewx-VRoE@milan>

On Wed, Nov 12, 2025 at 01:02:03PM +0100, Uladzislau Rezki wrote:
> On Tue, Nov 11, 2025 at 11:07:29PM -0800, Christoph Hellwig wrote:
> > On Tue, Nov 11, 2025 at 09:21:06PM +0100, Uladzislau Rezki wrote:
> > > > Unexpected gfp: 0x100000 (__GFP_HARDWALL). Fixing up to gfp: 0xdc0 (GFP_KERNEL|__GFP_ZERO). Fix your code!
> > > >
> > > It looks like we need to add __GFP_HARDWALL to the white-list-mask.
> > 
> > __GFP_HARDWALL is part of GFP_USER.  Doing GFP_USER vmalloc sounds like
> > a bit of an odd idea to me, but there are a few users mostly in bpf
> > and drm code (why do these always show up for odd API usage patterns?).
> > 
> > So I guess yes, we'll need to allow it for now, but I'd like to start
> > a discussion if it really makes much sense.
> > 
> <snip>
> 	/* plain bpf_prog allocation */
> 	prog = bpf_prog_alloc(bpf_prog_size(attr->insn_cnt), GFP_USER);
> 	if (!prog) {
> <snip>
> 
> I assume that was the place that triggered the splat.
> 
> Vishal, will you send the patch adding GFP_USER to address the splat?

Yes, I'll send a new version including __GFP_HARDWALL in the mask and
update the comment accordingly.
