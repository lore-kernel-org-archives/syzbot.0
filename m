Received: from smtpo49.interia.pl (smtpo49.interia.pl [217.74.67.49])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2B24A282F3F
	for <syzbot@lists.linux.dev>; Wed, 29 Jul 2026 08:01:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.74.67.49
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785312117; cv=none; b=NktSU60SFpofdN5RfE7diYyR4DBaQHDy6M8iAPwForqHl2SrfOxkAGxaMQHzGB+waqAhNQnLh+8P2zaNAMlGCOt1gjj3w5fLL+4ABO/fOKw4akvhgf3UCY1Rb1se6IVrOG2pZq4gk2pItvO2PnEf5RxDoxH4pZhmCP71TXHSsJI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785312117; c=relaxed/simple;
	bh=nhuqskYlyBJjBlBhGOemWB2CLQRjQdwtQdJnf93CVh8=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=fgeceEgNhe1M1o0GsBTrLLML4yybyF4p50d93yEviiV3VXZiLlNo9NML0y3ygRfYLOzzDd4rjoOenqn1u5iH7/iYK9tuurjLMFyM8x5kMXsDc/ZSflSLW+4mJmDVH1Os2tA6JTu0qwLegmipQJcZAub3XAcmE/qguU6MSSOnd6k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=poczta.fm; spf=pass smtp.mailfrom=poczta.fm; dkim=pass (1024-bit key) header.d=poczta.fm header.i=@poczta.fm header.b=X9dbkdWa; arc=none smtp.client-ip=217.74.67.49
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=poczta.fm
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=poczta.fm
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=poczta.fm header.i=@poczta.fm header.b="X9dbkdWa"
Received: from nr200 (unknown [80.68.231.31])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (P-256) server-digest SHA256)
	(No client certificate requested)
	by poczta.interia.pl (INTERIA.PL) with ESMTPSA;
	Wed, 29 Jul 2026 10:01:47 +0200 (CEST)
Date: Wed, 29 Jul 2026 10:01:45 +0200
From: Slawomir Stepien <sst@poczta.fm>
To: syzbot <syzbot@kernel.org>
Cc: syzkaller-upstream-moderation@googlegroups.com, syzbot@lists.linux.dev
Subject: Re: [PATCH RFC v2] wifi: zd1211rw: reject secondary interfaces to
 prevent conflicts
Message-ID: <ammzaex8HJff4Imm@nr200>
References: <4ccb85ef-8c74-4226-92ac-f8145816eb0a@mail.kernel.org>
Precedence: bulk
X-Mailing-List: syzbot@lists.linux.dev
List-Id: <syzbot.lists.linux.dev>
List-Subscribe: <mailto:syzbot+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:syzbot+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4ccb85ef-8c74-4226-92ac-f8145816eb0a@mail.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=poczta.fm; s=dk;
	t=1785312109; bh=iOqC6b7YZGVbyctelFHkGa78bzESMbak/5EK+b69xlw=;
	h=Date:From:To:Subject:Message-ID:MIME-Version:Content-Type;
	b=X9dbkdWa1R0xBfXLTHdgtR3/xT/R8jeHvNYhsTJd0eKuRtGaytDq4BNobPx97PfX9
	 r2jDnanipebzB59Ph4HXI0xkIWndcl7Q9gwkVIYMlZ4f6z9QdgzNAFOYZM3tJ56uB3
	 m7e8P0pdgFkOPzQ6R7EsmQPJlihfGGCEXovCYrEI=

#syz upstream

On lip 28, 2026 11:14, syzbot wrote:
> The zd1211rw driver is designed for single-function Wi-Fi dongles and
> hardcodes its USB endpoints. When a malformed USB device exposes multiple
> interfaces that match the driver's device ID, the driver blindly binds to
> all of them.
> 
> During probe(), the driver calls usb_reset_device(), which iterates over
> all interfaces and invokes the pre_reset() callback for each bound
> interface. Since multiple interfaces are bound to zd1211rw, pre_reset() is
> called sequentially for each instance, acquiring their respective
> &mac->chip.mutex. Because all instances initialize their mutexes with the
> same lock class, lockdep detects a task acquiring a lock of the same class
> it already holds and flags it as a possible recursive deadlock:
> 
> WARNING: possible recursive locking detected
> kworker/0:1/11 is trying to acquire lock:
> ffff88810371dde0 (&chip->mutex){+.+.}-{4:4}, at:
> zd_chip_disable_rxtx+0x20/0x50
> drivers/net/wireless/zydas/zd1211rw/zd_chip.c:1465
> 
> but task is already holding lock:
> ffff8881138ddde0 (&chip->mutex){+.+.}-{4:4}, at: pre_reset+0x28c/0x380
> drivers/net/wireless/zydas/zd1211rw/zd_usb.c:1505
> 
> Fix this by explicitly rejecting secondary interfaces (bInterfaceNumber !=
> 0) during probe(). This ensures that only a single instance of the driver
> binds to the device, eliminating the recursive locking scenario.
> 
> Fixes: e85d0918b54f ("[PATCH] ZyDAS ZD1211 USB-WLAN driver")
> Assisted-by: Gemini:gemini-3.5-flash Gemini:gemini-3.1-pro-preview syzbot
> Reported-by: syzbot+0ec3d1a6cf1fbe79c153@syzkaller.appspotmail.com
> Closes: https://syzkaller.appspot.com/bug?extid=0ec3d1a6cf1fbe79c153
> Link: https://syzkaller.appspot.com/ai_job?id=00724ef7-fd77-4cde-9779-895b8f63c2f6
> To: <linux-wireless@vger.kernel.org>
> To: "Daniel Drake" <dsd@gentoo.org>
> Cc: "Johannes Berg" <johannes.berg@intel.com>
> Cc: "Kees Cook" <kees@kernel.org>
> Cc: <linux-kernel@vger.kernel.org>
> Cc: "Abdun Nihaal" <nihaal@cse.iitm.ac.in>
> 
> ---
> v2:
> - Removed the explanation of the -EAGAIN error from the commit message.
> - Removed the line containing only '=' from the commit message.
> 
> v1:
> https://lore.kernel.org/all/a15b9bcb-e2d2-4767-a0d1-87522fa559a1@mail.kernel.org/T/
> ---
> diff --git a/drivers/net/wireless/zydas/zd1211rw/zd_usb.c b/drivers/net/wireless/zydas/zd1211rw/zd_usb.c
> index 966d8ccb0..2bb2df12c 100644
> --- a/drivers/net/wireless/zydas/zd1211rw/zd_usb.c
> +++ b/drivers/net/wireless/zydas/zd1211rw/zd_usb.c
> @@ -1353,6 +1353,13 @@ static int probe(struct usb_interface *intf, const struct usb_device_id *id)
>  	struct zd_usb *usb;
>  	struct ieee80211_hw *hw = NULL;
>  
> +	/* ZD1211 devices are single-function. Reject secondary interfaces
> +	 * to prevent multiple instances from conflicting on hardcoded endpoints
> +	 * and triggering recursive locking warnings.
> +	 */
> +	if (intf->cur_altsetting->desc.bInterfaceNumber != 0)
> +		return -ENODEV;
> +
>  	print_id(udev);
>  
>  	if (id->driver_info & DEVICE_INSTALLER)
> 
> 
> base-commit: 1590cf0329716306e948a8fc29f1d3ee87d3989f

-- 
Slawomir Stepien
