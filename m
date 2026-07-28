Received: from smtpo75.interia.pl (smtpo75.interia.pl [217.74.67.75])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B9A0C41D64E
	for <syzbot@lists.linux.dev>; Tue, 28 Jul 2026 10:00:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.74.67.75
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785232807; cv=none; b=Rrgg15LC8dPbW8me7Z/mNZIvoS6kn1uM5g2bRrk6HMvi1pvRMc4nlN+IcoGMy3cw88CnQgR6+SJoggPQE9w4HiAY8sW6l+Hb+wof1jek6cxJ8IC66fSOiobnhf/PM9/H4o0BpO7VdhF1YDwn34DoJDS6TZO7IG/1o6Ym0vuIFLE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785232807; c=relaxed/simple;
	bh=6bK64N9kYe/do/T2X41ChhS1xO8PasG5eC5VHZsF5m0=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=qwfYvu5Azz+MZ73dLT6nDmQAb1RlXQ9LasZeafaz1qtEaxCkfISOOPVwrEq99QHSbWNP20Wmp4MJzlbOWI8gvV1jcEtZls+BL6bLyCFTDqmSkltceV3Pv1db1mgMYNUFRaaoPpnTHYF8oSUk8Xg+S5hgBi6+LjcpDzHfmf8hXPo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=poczta.fm; spf=pass smtp.mailfrom=poczta.fm; dkim=pass (1024-bit key) header.d=poczta.fm header.i=@poczta.fm header.b=s0zbc3SN; arc=none smtp.client-ip=217.74.67.75
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=poczta.fm
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=poczta.fm
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=poczta.fm header.i=@poczta.fm header.b="s0zbc3SN"
Received: from nr200 (unknown [80.68.231.31])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (P-256) server-digest SHA256)
	(No client certificate requested)
	by poczta.interia.pl (INTERIA.PL) with ESMTPSA;
	Tue, 28 Jul 2026 11:59:53 +0200 (CEST)
Date: Tue, 28 Jul 2026 11:59:51 +0200
From: Slawomir Stepien <sst@poczta.fm>
To: syzbot <syzbot@kernel.org>
Cc: syzkaller-upstream-moderation@googlegroups.com, syzbot@lists.linux.dev
Subject: Re: [PATCH RFC] wifi: zd1211rw: reject secondary interfaces to
 prevent conflicts
Message-ID: <amh9l5yv-BS8yTRz@nr200>
References: <a15b9bcb-e2d2-4767-a0d1-87522fa559a1@mail.kernel.org>
Precedence: bulk
X-Mailing-List: syzbot@lists.linux.dev
List-Id: <syzbot.lists.linux.dev>
List-Subscribe: <mailto:syzbot+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:syzbot+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <a15b9bcb-e2d2-4767-a0d1-87522fa559a1@mail.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=poczta.fm; s=dk;
	t=1785232794; bh=ak4OvhCX54K9d7b7fpyEA5dC3XE7y0ROGaipEtGQdAY=;
	h=Date:From:To:Subject:Message-ID:MIME-Version:Content-Type;
	b=s0zbc3SNCxEbeyxKM8tc+Us6xVDpRnrW5A6rRXBf/MivywJA/7TgglgToTLkdL6f3
	 AVxjt8RLTmMbaTYUXFy8IcfVuXJLngl92iPzRE8RSMfcovkpMj2jCzGDY9GJ56xvSa
	 KryO/rc/z8rod/oekqkpcZ9gKFWDYTbcv8OJ0q7M=

On lip 20, 2026 11:46, 'syzbot' via syzkaller-upstream-moderation wrote:
> The zd1211rw driver is designed for single-function Wi-Fi dongles and
> hardcodes its USB endpoints. When a malformed USB device exposes multiple
> interfaces that match the driver's device ID, the driver blindly binds to
> all of them. This leads to two critical issues.
> 
> First, multiple driver instances attempt to submit URBs to the exact same
> hardcoded endpoints concurrently. This overloads the endpoint's periodic
> bandwidth or queue limits, resulting in -EAGAIN (-11) errors during I/O
> operations.

I'm a bit lost here. Can you explain why we see -EAGAIN error in logs?

Maybe the -EAGAIN error is caused because we do not have real true device? If this is the case, I
would not add this paragraph to the commit message.

> Second, during probe(), the driver calls usb_reset_device(), which iterates
> over all interfaces and invokes the pre_reset() callback for each bound
> interface. Since multiple interfaces are bound to zd1211rw, pre_reset() is
> called sequentially for each instance, acquiring their respective
> &mac->chip.mutex. Because all instances initialize their mutexes with the
> same lock class, lockdep detects a task acquiring a lock of the same class
> it already holds and flags it as a possible recursive deadlock:
> 
> ============================================

Please remove this line with only =.

> WARNING: possible recursive locking detected
> ...
> kworker/0:0/4961 is trying to acquire lock:
> ffff888105315de0 (&chip->mutex){+.+.}-{4:4}, at:
> zd_chip_disable_rxtx+0x20/0x50
> drivers/net/wireless/zydas/zd1211rw/zd_chip.c:1465
> 
> but task is already holding lock:
> ffff8881129cdde0 (&chip->mutex){+.+.}-{4:4}, at: pre_reset+0x28c/0x380
> drivers/net/wireless/zydas/zd1211rw/zd_usb.c:1505
> 
> Fix this by explicitly rejecting secondary interfaces (bInterfaceNumber !=
> 0) during probe(). This ensures that only a single instance of the driver
> binds to the device, eliminating both the endpoint conflicts and the
> recursive locking scenario.
> 
> Fixes: e85d0918b54f ("[PATCH] ZyDAS ZD1211 USB-WLAN driver")
> Assisted-by: Gemini:gemini-3.1-pro-preview syzbot
> Reported-by: syzbot+0ec3d1a6cf1fbe79c153@syzkaller.appspotmail.com
> Closes: https://syzkaller.appspot.com/bug?extid=0ec3d1a6cf1fbe79c153
> Link: https://syzkaller.appspot.com/ai_job?id=31453070-c764-4248-98b8-5f0a8f8393c3
> To: <linux-wireless@vger.kernel.org>
> To: "Daniel Drake" <dsd@gentoo.org>
> Cc: "Bjorn Helgaas" <bhelgaas@google.com>
> Cc: "Johannes Berg" <johannes.berg@intel.com>
> Cc: "Kees Cook" <kees@kernel.org>
> Cc: <linux-kernel@vger.kernel.org>
> Cc: "Abdun Nihaal" <nihaal@cse.iitm.ac.in>
> 
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
