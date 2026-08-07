Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 92971359A90
	for <syzbot@lists.linux.dev>; Fri,  7 Aug 2026 07:31:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=100.103.45.18
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786087902; cv=pass; b=d7EvggCQ2vC91vKBfz1lfKJAV2KYHM6+vTEn3hyZV0fdBjhKU00Ikvcu4mkdDuf3htIo76Hv9i32dRolnhtzT8SvfRDGmrpvcTfPunUf+/fKmDxeBjiB6/8dVkAt9ye0NNv4AY8cBUYxH9Fd+WeH4LjBIOVmuVXKEmUwX/FFY5U=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786087902; c=relaxed/simple;
	bh=1VyDuJHYR+ciOz9BYEen75fLFOo4/umvL81BHUNGmEk=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=LEDpH0tjsFP8R4CmCrZwEiwPejPmE2dUdQgQXE4ft4GSCELGEW+SC50tNcLpwSvHuC+ntisQPLiEozyc947FSh5z9JetGCkSn+u7RfA3Fi1eB8nMAQMJsbcFvSZcRP1u0uODRRER0hSr4NF2VgicvDu7+3C4iNn9UBoy7dKew6Y=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=poczta.fm header.i=@poczta.fm header.b=WVimykD0; arc=pass smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=poczta.fm header.i=@poczta.fm header.b="WVimykD0"
Received: by smtp.kernel.org (Postfix)
	id C13801F00A3D; Fri,  7 Aug 2026 07:31:34 +0000 (UTC)
Authentication-Results: smtp.kernel.org; arc=none smtp.remote-ip=217.74.67.49
ARC-Seal: i=1; d=kernel.org; s=arc20260519; a=rsa-sha256; cv=none;
	t=1786087894;
	b=1Tgz1ms5W1L9FFbB0DgdZXnc+JFysFyadzXOjebqmWnXwIore91yNSIeYzbF+Z7QiQAX
	 D9dtMpBIIMsf83AnEeVNHbWyvpes9VRBLJtT3KdJnqFC3RaCWZg8zOzqHqOH+PKn/Kn02
	 EQ/LdS85f97X/vSqJfYm8+BFDJjygI5cs04tYtg0XeFQUV8DAUDW01XhKPY6VFlW/hoLu
	 gag2OcZZRY7HlAQsLVMKypis6GVs0wZzZ3kEURRxNMCH0ogCej92wGKxOR2S9hcGIZ85z
	 vlzTXolsz9iF24p9rsYXYSWfI/wCDhiFgseIRsEBqOY5iwTjwLiR7YM3DH36sX4dSXg==
ARC-Message-Signature: i=1; d=kernel.org; s=arc20260519; a=rsa-sha256;
	c=relaxed/relaxed; t=1786087894;
	h=DMARC-Filter:Received:Date:From:To:Cc:Subject:Message-ID:References:
	 MIME-Version:Content-Type:Content-Disposition:In-Reply-To:
	 DKIM-Signature;
	bh=qF4lEOy63wNW7hqrz8tDkLwya64utF2ElrqG9+tBOAw=;
	b=CRtvKToF9MOTHXeMUY8jGO649OZUeaeqPJjqhx8pRklgsEj5t8T9gPGBee58IzD/VRDU
	 MhkIt2lEl+8KoUel4rubLZm0P7HPDja0KuXgMELwaeWON7oGLvAWaGNuGlp9cgvS3JUn8
	 wMrXPZzlt8w+xWPYGGGiaagAMul7P7ndSO7AXVdoze8DHlJm4XSRAbCsJZYtzUmECiUlO
	 C5U5SfohpuIJloxQE/vSyfxAnYtqHmNtujkdi4CvzlgJzL1KrJAUcAUhtHWBq3UgXDhdP
	 v/MT6ONcoa9hZ3Ee0Sph26V1Pi84rbqOUYmPvMU0BX3EqlHrPcdqrYsrN0EjT8Z6b7A==
ARC-Authentication-Results: i=1; smtp.kernel.org; dkim=pass header.d=poczta.fm header.i=@poczta.fm header.a=rsa-sha256 header.s=dk header.b=WVimykD0;
	dmarc=pass header.from=poczta.fm;
	spf=pass smtp.mailfrom=poczta.fm;
	arc=none smtp.remote-ip=217.74.67.49
Received: from smtpo49.interia.pl (smtpo49.interia.pl [217.74.67.49])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.kernel.org (Postfix) with ESMTPS id E30721F00A3A
	for <syzbot@kernel.org>; Fri,  7 Aug 2026 07:31:27 +0000 (UTC)
Authentication-Results: smtp.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=poczta.fm header.i=@poczta.fm header.a=rsa-sha256 header.s=dk header.b=WVimykD0
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.kernel.org E30721F00A3A
Authentication-Results: smtp.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=poczta.fm
Authentication-Results: smtp.kernel.org; spf=pass smtp.mailfrom=poczta.fm
Received: from nr200 (unknown [80.68.231.31])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (P-256) server-digest SHA256)
	(No client certificate requested)
	by poczta.interia.pl (INTERIA.PL) with ESMTPSA;
	Fri,  7 Aug 2026 09:31:23 +0200 (CEST)
Date: Fri, 7 Aug 2026 09:31:20 +0200
From: Slawomir Stepien <sst@poczta.fm>
To: Jakub Kicinski <kuba@kernel.org>
Cc: syzbot <syzbot@kernel.org>, syzkaller-bugs@googlegroups.com,
	Andrew Lunn <andrew+netdev@lunn.ch>,
	"David S. Miller" <davem@davemloft.net>,
	Eric Dumazet <edumazet@google.com>, netdev@vger.kernel.org,
	Paolo Abeni <pabeni@redhat.com>, linux-kernel@vger.kernel.org,
	syzbot@lists.linux.dev
Subject: Re: [PATCH] netdevsim: fix deadlock in nsim_bus_dev_max_vfs_write()
Message-ID: <anWJyHCic8XvA0Q2@nr200>
References: <b7bf56ea-7522-4163-acd5-aaa69ad03b3a@mail.kernel.org>
 <20260805160851.571ed66f@kernel.org>
Precedence: bulk
X-Mailing-List: syzbot@lists.linux.dev
List-Id: <syzbot.lists.linux.dev>
List-Subscribe: <mailto:syzbot+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:syzbot+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260805160851.571ed66f@kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=poczta.fm; s=dk;
	t=1786087885; bh=qF4lEOy63wNW7hqrz8tDkLwya64utF2ElrqG9+tBOAw=;
	h=Date:From:To:Subject:Message-ID:MIME-Version:Content-Type;
	b=WVimykD0rQZfu7zdYgBAq0HfudsyaL9tOFC8XsII51f52/7Fye4NmA64YHCrKQ+Xu
	 4jE22bBavpjZZH+8L4icizt8Uf/RDPr4+rUatuGTISKyg9w7XJOVqNY2si2aIU+KvD
	 pNA3WFJo5NfLT5M1UWuG0HN00Zkp2+8Y+y77Pv8g=

On sie 05, 2026 16:08, Jakub Kicinski wrote:
> On Fri, 31 Jul 2026 09:55:04 +0000 (UTC) syzbot wrote:
> > --- a/drivers/net/netdevsim/dev.c
> > +++ b/drivers/net/netdevsim/dev.c
> > @@ -273,7 +273,11 @@ static ssize_t nsim_bus_dev_max_vfs_write(struct file *file,
> 
> Sorry to chime in poniewczasie.
> Please delete this file. netdevsim is a harness for in-tree selftests,
> none seems to be reading or writing the debugfs num_vfs AFAICT
> so let's just drop it?

That's true, but is netdevsim used *just* by the selftests (or was designed with only selftests in
mind)? What if someone is using it without selftests?

On the other hand: what sashiko found:
https://netdev-ai.bots.linux.dev/sashiko/#/patchset/b7bf56ea-7522-4163-acd5-aaa69ad03b3a%40mail.kernel.org
is true: the same issue will be with e.g. break_health. So it seems to me that a better approach
would be to change when the debugfs files are removed.

It seems to me that change in nsim_drv_remove() might be easy, but what about
nsim_dev_reload_down()...it seems it will have the same deadlock. Or am I missing something for this
case?

-- 
Slawomir Stepien
