Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 34C033FE645
	for <syzbot@lists.linux.dev>; Tue, 25 Aug 2026 11:27:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=100.103.45.18
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787657229; cv=pass; b=McPeCpvX9SQUpMxsuBQOmrwjcev+se+UxBIQVsrNaAU1sUiVUL7ASIx2o4uOMvXvF1AduJOjMzDUSKB1h2+8cMyEiTgahllcQRT3Gy5hBevU4S/ElDLxS81E5psM5YrZjJixpyWC+x/NjAwUZi9Jj6itMjaE1Q9OMfeZVNf23Lw=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787657229; c=relaxed/simple;
	bh=/nanS065TlBm8RMB1VQp3Q7XNBTCXcLcKnG17dOhiGs=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=QmuVT8RJAGxVDkmbjgKeKhX74wU/W0AAIpvIZBpwgPwLpMM+PMH6Y0/dKnrTi08h+jXKbn+Ynri37U8eLIxyDe2DO1f2QUO6ISGgBvEXztH2scaSHplcukqHHJ8t8TVuPxl/3AqkLZKDEiJSYGacEpmYXk5xKLd+JpyNJiOIkcg=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=poczta.fm header.i=@poczta.fm header.b=cmhpM67M; arc=pass smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=poczta.fm header.i=@poczta.fm header.b="cmhpM67M"
Received: by smtp.kernel.org (Postfix)
	id D1FFA1F00A3A; Tue, 25 Aug 2026 11:27:06 +0000 (UTC)
Authentication-Results: smtp.kernel.org; arc=none smtp.remote-ip=217.74.67.75
ARC-Seal: i=1; d=kernel.org; s=arc20260519; a=rsa-sha256; cv=none;
	t=1787657226;
	b=wEOd6u5d0hEzcAmpCSUbECfTmLrOVdTl8QuPWVLBUtXcx0ekd1ioQ4TdDj69sNSuvtsZ
	 /UsZ5fthKD/SadfIND64d6CxX6epLm8CpLPC8Z7HvrVX7xv95JzMcdhhPP3Dqqk7+Q0P5
	 hRGmf+NiKiE2dp+Vs3nwcwtKHOHBro32FeyKc9xVVQSd3e6VPZfXUBQnL30fq/eqhoF2T
	 ZjfUEANp+TssqPofaOhGoq5z+RWNetLZEw06yn4leE5sy65Fx09dBh3z1stOwLa63Cu3f
	 0ga9iTMxjS02NUMsZqtszzpoqgAnNBQYb6B+ISgCEdLeXPUW8PJJAvCKAJsk5aXfAug==
ARC-Message-Signature: i=1; d=kernel.org; s=arc20260519; a=rsa-sha256;
	c=relaxed/relaxed; t=1787657226;
	h=DMARC-Filter:Received:Date:From:To:Cc:Subject:Message-ID:References:
	 MIME-Version:Content-Type:Content-Disposition:
	 Content-Transfer-Encoding:In-Reply-To:DKIM-Signature;
	bh=u849jbuokEGJrG4MX8DSBd4S8qyShqARHeqPFRwMBnk=;
	b=1LizbNO3No6+cw3uT2DAzkvwME+rpVJqdSnjADqNAV2j57JjC3eDohaC5o1ctouHbdiB
	 gVNep96X+82AxFb8bOcxV6I8PXczatr7w9xkrLmmjR9jNB0K/vUcIa5zn1+uffM/cwh9v
	 Xt4nryQkxA4/HKMjaE8+Z2NSi1hg7Y4FVL4c43X5SzN9qLO8dNRUrY22sLtBMga38Hajb
	 hZVcQ5y5Oyti4nkiIeCat9hoSXZpdYpi0YqEw+SJlu3E8U3/6t7K8VwS/j/fj8QsJfRaV
	 gI1CDflFq9+hzU4KyZNleQ9faYQqlTfixn4JEZgUe3RrbDWdOvLTLbfGtBoitROpgYw==
ARC-Authentication-Results: i=1; smtp.kernel.org; dkim=pass header.d=poczta.fm header.i=@poczta.fm header.a=rsa-sha256 header.s=dk header.b=cmhpM67M;
	dmarc=pass header.from=poczta.fm;
	spf=pass smtp.mailfrom=poczta.fm;
	arc=none smtp.remote-ip=217.74.67.75
Received: from smtpo75.interia.pl (smtpo75.interia.pl [217.74.67.75])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.kernel.org (Postfix) with ESMTPS id C27CC1F000E9
	for <syzbot@kernel.org>; Tue, 25 Aug 2026 11:27:04 +0000 (UTC)
Authentication-Results: smtp.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=poczta.fm header.i=@poczta.fm header.a=rsa-sha256 header.s=dk header.b=cmhpM67M
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.kernel.org C27CC1F000E9
Authentication-Results: smtp.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=poczta.fm
Authentication-Results: smtp.kernel.org; spf=pass smtp.mailfrom=poczta.fm
Received: from nr200 (unknown [80.68.231.31])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (P-256) server-digest SHA256)
	(No client certificate requested)
	by poczta.interia.pl (INTERIA.PL) with ESMTPSA;
	Tue, 25 Aug 2026 13:27:01 +0200 (CEST)
Date: Tue, 25 Aug 2026 13:26:58 +0200
From: Slawomir Stepien <sst@poczta.fm>
To: Thomas Zimmermann <tzimmermann@suse.de>
Cc: sashiko-reviews@lists.linux.dev, syzbot <syzbot@kernel.org>,
	dri-devel@lists.freedesktop.org
Subject: Re: [PATCH] drm/cirrus-qemu: Validate BAR0 size during probe
Message-ID: <ao18Ag6ucRMqGRVI@nr200>
References: <b11f8965-5896-4119-98b7-6bd0eb9fa139@mail.kernel.org>
 <20260825074432.0B4511F00A3A@smtp.kernel.org>
 <ce0912d6-fdc4-4ead-9388-a9e0e9a1954c@suse.de>
 <ao1ketQ4oxNiWGAM@nr200>
 <7a61b8fc-68f4-4d8d-b5ff-0ffd9a9507fc@suse.de>
Precedence: bulk
X-Mailing-List: syzbot@lists.linux.dev
List-Id: <syzbot.lists.linux.dev>
List-Subscribe: <mailto:syzbot+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:syzbot+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <7a61b8fc-68f4-4d8d-b5ff-0ffd9a9507fc@suse.de>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=poczta.fm; s=dk;
	t=1787657222; bh=u849jbuokEGJrG4MX8DSBd4S8qyShqARHeqPFRwMBnk=;
	h=Date:From:To:Subject:Message-ID:MIME-Version:Content-Type;
	b=cmhpM67MEZ37ijAG671Dl4j3ZWeRnGYqh4YR7REM468lXUCBDEwTY2dm9SMflzmzn
	 JduRxTM2zNKIbkSGGj59M9QbOwS6aOtC1Y5ijxDslfEiyxjN0zCrmwfbRtAbHbnA3U
	 8FnXHmcHG4cGlxrKxQpWhzRsOKsb/Hh9rtZGhwGM=

On sie 25, 2026 12:21, Thomas Zimmermann wrote:
> Hi
> 
> Am 25.08.26 um 11:46 schrieb Slawomir Stepien:
> > On sie 25, 2026 10:00, Thomas Zimmermann wrote:
> > > (cc: Slawomir)
> > > 
> > > Hi,
> > Hello,
> > 
> > > thanks for the fix. Please see below for changes that should go into the
> > > patch.
> > thanks I will look into them and make a manual v2!
> > 
> > > Best regards
> > > Thomas
> > > 
> > > Am 25.08.26 um 09:44 schrieb sashiko-bot@kernel.org:
> > > > Thank you for your contribution! Sashiko AI review found 2 potential issue(s) to consider:
> > > > - [High] The exact equality check for BAR0 size (`!= CIRRUS_VRAM_SIZE`) incorrectly rejects valid QEMU configurations with larger VRAM.
> > > > - [High] The VRAM size validation check is placed after `aperture_remove_conflicting_pci_devices()`, meaning the firmware framebuffer is permanently destroyed even if the driver ultimately fails to bind.
> > > > --
> > > > 
> > > > --- Patch [1]: [PATCH] drm/cirrus-qemu: Validate BAR0 size during probe ---
> > > > commit 75467ead62a494b6afbc057c666ab59f7e4b8915
> > > > Author: Slawomir Stepien <sst@poczta.fm>
> > > > 
> > > > drm/cirrus-qemu: Validate BAR0 size during probe
> > > > 
> > > > This commit adds a check during PCI probe to verify that the BAR0 resource
> > > > length equals CIRRUS_VRAM_SIZE. This is intended to prevent supervisor write
> > > > page faults caused by writing past the end of the mapped I/O memory when
> > > > smaller BARs are presented.
> > > > 
> > > > Link: https://syzkaller.appspot.com/ai_job?id=ba262a3a-bccf-4ad8-a1b0-583c55d34fd6
> > > > 
> > > > > diff --git a/drivers/gpu/drm/tiny/cirrus-qemu.c b/drivers/gpu/drm/tiny/cirrus-qemu.c
> > > > > index 075221b431d37..70c995025f508 100644
> > > > > --- a/drivers/gpu/drm/tiny/cirrus-qemu.c
> > > > > +++ b/drivers/gpu/drm/tiny/cirrus-qemu.c
> > > > > @@ -602,6 +602,9 @@ static int cirrus_pci_probe(struct pci_dev *pdev,
> > > > >    	dev = &cirrus->dev;
> > > > > +	if (pci_resource_len(pdev, 0) != CIRRUS_VRAM_SIZE)
> > > > > +		return -ENODEV;
> > > > > +
> > > > [Severity: High]
> > > > Does this strict equality check unintentionally break valid QEMU
> > > > configurations that have more than 4 MB of VRAM?
> > > > 
> > > > When a VM is booted with a configuration like -device cirrus-vga,vgamem_mb=8,
> > > > the BAR0 size will be 8 MB. The check in cirrus_pci_probe() evaluates
> > > > to true (since 8 MB is not equal to 4 MB) and rejects the device by
> > > > returning -ENODEV.
> > > > 
> > > > Would it be safer to check if pci_resource_len(pdev, 0) < CIRRUS_VRAM_SIZE
> > > > instead of requiring an exact match?
> > It seems that 4MB is the default one and 8 and 16MB are just for compatibility:
> > 
> > (qemu hw/display/cirrus_vga.c):
> > 
> > 2951     /*
> > 2952      * Follow real hardware, cirrus card emulated has 4 MB video memory.
> > 2953      * Also accept 8 MB/16 MB for backward compatibility.
> > 2954      */
> > 2955     if (s->vga.vram_size_mb != 4 && s->vga.vram_size_mb != 8 &&
> > 2956         s->vga.vram_size_mb != 16) {
> > 2957         error_setg(errp, "Invalid cirrus_vga ram size '%u'",
> > 2958                    s->vga.vram_size_mb);
> > 2959         return;
> > 2960     }
> > 
> > I will add the 8 and 16MB then in v2.
> 
> Please check that  it is >= VRAM_SIZE, so we're flexible.

Sure!

-- 
Slawomir Stepien
