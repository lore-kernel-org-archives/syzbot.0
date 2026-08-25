Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C5BD47E105
	for <syzbot@lists.linux.dev>; Tue, 25 Aug 2026 09:46:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=100.103.45.18
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787651211; cv=pass; b=nhGD8+RCMHQllRIrRZAEPWmkLIUQjpp0ocv4Qes8gCzS+XdenUUY/qv/3H8hk6Wz2Md4yH3iUztYLK2+alH2On+4/jl4yfQdqCZ1YZv5QUa74f96g28CnC8PAgegbibteiSQiPfwrhk4b5CrYpy5Xo653DaEx/1VJ4+Y8LLn+tY=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787651211; c=relaxed/simple;
	bh=fmiVhvFRiGsrLjl8bbtw3ypouRNG4Hb3E/7h/x864v8=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=r3z/I6ktrU1z5YA8EAONIybzIYJFI8dMOEMSvTXsmcEzqvicPSQVgCZGA2Bb4cKlG8w664UF5MCVDxuEA5QUk6P9x3yMoIO+lJWuFKaz/IiEOCzZx+1e7kpfgJ4Ffjfz0EShyCqCqdc7B73KaMDuDA+LgrYVlqCGkHNRxIGdqpI=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=poczta.fm header.i=@poczta.fm header.b=orbBPggv; arc=pass smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=poczta.fm header.i=@poczta.fm header.b="orbBPggv"
Received: by smtp.kernel.org (Postfix)
	id 8C46A1F00A3A; Tue, 25 Aug 2026 09:46:49 +0000 (UTC)
Authentication-Results: smtp.kernel.org; arc=none smtp.remote-ip=217.74.67.49
ARC-Seal: i=1; d=kernel.org; s=arc20260519; a=rsa-sha256; cv=none;
	t=1787651209;
	b=z/RAeusWWnMmKCiHHxoee6fTh1qz8zET4NS0wTBCUG/OjyX6X3xzNn7hhMAgUkgAv0xJ
	 nLvQDK5gW9Y+0QRwz+DZNLQELYL7qgEmhjL9Wor0rzs5Qk6l0yNejMLjmkoDdridAUefR
	 243iUJ7B4O30W01DP45Oo+xgiNRsfmOAPc5PtLsP2ubsc9+eS51wh/zwdeDUvt8CZtnEr
	 b2Y3zA74ydKzzmva8CbstT2vWJnAJ/BmAdDgwUNTLSE1rmMvzw3r45DGDfr2DkmRYJsTG
	 4202cMLH1NAb8HnWzL2ayWpov5UGMT6bTG/U88WIAsHj9z3X4tmZbOBOQSbVEoIUG3A==
ARC-Message-Signature: i=1; d=kernel.org; s=arc20260519; a=rsa-sha256;
	c=relaxed/relaxed; t=1787651209;
	h=DMARC-Filter:Received:Date:From:To:Cc:Subject:Message-ID:References:
	 MIME-Version:Content-Type:Content-Disposition:In-Reply-To:
	 DKIM-Signature;
	bh=MvH/GZjMBZncc502+FYWTWv0K2Z8oMHl739kUmAgO54=;
	b=YHKgN9WmuOaKXart/NDCcY9bQchLa3rzGEDIkuH9QTxqaQWwsYwdEpJZrcz2G1dTmdtk
	 ebIZQnKFRM3BuKbQ2TTOYo38TFYO6/jEGE9f2IFI0DH/er3GgqqTSh+r7p8gLRP9PhG/L
	 6cPgsHKruBdvA0GhWBeQ7AVDzDJSHXkkbeaQ4UqXW1uVqVufKGAPemI04qs6tZXxz0frg
	 rEX5F19tHTFlMvUjMtzbJoCxW1ntnBUI6QlYEttEXXwZyg3xShI+tgmRvBFkagcRziGFi
	 aBAK8RQ0pJcOZ8uORnGSIFD9uCWglWZu+EF5Ti/ltEZQf57wZKlqnaNJrx1qU1f2Gyg==
ARC-Authentication-Results: i=1; smtp.kernel.org; dkim=pass header.d=poczta.fm header.i=@poczta.fm header.a=rsa-sha256 header.s=dk header.b=orbBPggv;
	dmarc=pass header.from=poczta.fm;
	spf=pass smtp.mailfrom=poczta.fm;
	arc=none smtp.remote-ip=217.74.67.49
Received: from smtpo49.interia.pl (smtpo49.interia.pl [217.74.67.49])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.kernel.org (Postfix) with ESMTPS id A73CB1F000E9
	for <syzbot@kernel.org>; Tue, 25 Aug 2026 09:46:47 +0000 (UTC)
Authentication-Results: smtp.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=poczta.fm header.i=@poczta.fm header.a=rsa-sha256 header.s=dk header.b=orbBPggv
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.kernel.org A73CB1F000E9
Authentication-Results: smtp.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=poczta.fm
Authentication-Results: smtp.kernel.org; spf=pass smtp.mailfrom=poczta.fm
Received: from nr200 (unknown [80.68.231.31])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (P-256) server-digest SHA256)
	(No client certificate requested)
	by poczta.interia.pl (INTERIA.PL) with ESMTPSA;
	Tue, 25 Aug 2026 11:46:36 +0200 (CEST)
Date: Tue, 25 Aug 2026 11:46:34 +0200
From: Slawomir Stepien <sst@poczta.fm>
To: Thomas Zimmermann <tzimmermann@suse.de>
Cc: sashiko-reviews@lists.linux.dev, syzbot <syzbot@kernel.org>,
	dri-devel@lists.freedesktop.org
Subject: Re: [PATCH] drm/cirrus-qemu: Validate BAR0 size during probe
Message-ID: <ao1ketQ4oxNiWGAM@nr200>
References: <b11f8965-5896-4119-98b7-6bd0eb9fa139@mail.kernel.org>
 <20260825074432.0B4511F00A3A@smtp.kernel.org>
 <ce0912d6-fdc4-4ead-9388-a9e0e9a1954c@suse.de>
Precedence: bulk
X-Mailing-List: syzbot@lists.linux.dev
List-Id: <syzbot.lists.linux.dev>
List-Subscribe: <mailto:syzbot+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:syzbot+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ce0912d6-fdc4-4ead-9388-a9e0e9a1954c@suse.de>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=poczta.fm; s=dk;
	t=1787651198; bh=MvH/GZjMBZncc502+FYWTWv0K2Z8oMHl739kUmAgO54=;
	h=Date:From:To:Subject:Message-ID:MIME-Version:Content-Type;
	b=orbBPggvICoii+Nd15hkuQdaVT4uWhs0z4sbW4il/lbCDnVOE6amIE9ygg+Ht4iYT
	 CYHDmQ3C1E1Ty9JxV9OQg0L2sziOirldjm08W1Mh1nhm3Ng9xDbmKL3qZb6705X/kq
	 sQ+RYSnnW1c6qCNhYORfySESlYl9GLL9YB/U8T8Q=

On sie 25, 2026 10:00, Thomas Zimmermann wrote:
> (cc: Slawomir)
> 
> Hi,

Hello,

> thanks for the fix. Please see below for changes that should go into the
> patch.

thanks I will look into them and make a manual v2!

> Best regards
> Thomas
> 
> Am 25.08.26 um 09:44 schrieb sashiko-bot@kernel.org:
> > Thank you for your contribution! Sashiko AI review found 2 potential issue(s) to consider:
> > - [High] The exact equality check for BAR0 size (`!= CIRRUS_VRAM_SIZE`) incorrectly rejects valid QEMU configurations with larger VRAM.
> > - [High] The VRAM size validation check is placed after `aperture_remove_conflicting_pci_devices()`, meaning the firmware framebuffer is permanently destroyed even if the driver ultimately fails to bind.
> > --
> > 
> > --- Patch [1]: [PATCH] drm/cirrus-qemu: Validate BAR0 size during probe ---
> > commit 75467ead62a494b6afbc057c666ab59f7e4b8915
> > Author: Slawomir Stepien <sst@poczta.fm>
> > 
> > drm/cirrus-qemu: Validate BAR0 size during probe
> > 
> > This commit adds a check during PCI probe to verify that the BAR0 resource
> > length equals CIRRUS_VRAM_SIZE. This is intended to prevent supervisor write
> > page faults caused by writing past the end of the mapped I/O memory when
> > smaller BARs are presented.
> > 
> > Link: https://syzkaller.appspot.com/ai_job?id=ba262a3a-bccf-4ad8-a1b0-583c55d34fd6
> > 
> > > diff --git a/drivers/gpu/drm/tiny/cirrus-qemu.c b/drivers/gpu/drm/tiny/cirrus-qemu.c
> > > index 075221b431d37..70c995025f508 100644
> > > --- a/drivers/gpu/drm/tiny/cirrus-qemu.c
> > > +++ b/drivers/gpu/drm/tiny/cirrus-qemu.c
> > > @@ -602,6 +602,9 @@ static int cirrus_pci_probe(struct pci_dev *pdev,
> > >   	dev = &cirrus->dev;
> > > +	if (pci_resource_len(pdev, 0) != CIRRUS_VRAM_SIZE)
> > > +		return -ENODEV;
> > > +
> > [Severity: High]
> > Does this strict equality check unintentionally break valid QEMU
> > configurations that have more than 4 MB of VRAM?
> > 
> > When a VM is booted with a configuration like -device cirrus-vga,vgamem_mb=8,
> > the BAR0 size will be 8 MB. The check in cirrus_pci_probe() evaluates
> > to true (since 8 MB is not equal to 4 MB) and rejects the device by
> > returning -ENODEV.
> > 
> > Would it be safer to check if pci_resource_len(pdev, 0) < CIRRUS_VRAM_SIZE
> > instead of requiring an exact match?

It seems that 4MB is the default one and 8 and 16MB are just for compatibility:

(qemu hw/display/cirrus_vga.c):

2951     /*
2952      * Follow real hardware, cirrus card emulated has 4 MB video memory.
2953      * Also accept 8 MB/16 MB for backward compatibility.
2954      */
2955     if (s->vga.vram_size_mb != 4 && s->vga.vram_size_mb != 8 &&
2956         s->vga.vram_size_mb != 16) {
2957         error_setg(errp, "Invalid cirrus_vga ram size '%u'",
2958                    s->vga.vram_size_mb);
2959         return;
2960     }

I will add the 8 and 16MB then in v2.

> > [Severity: High]
> > Is it safe to place this validation check after the call to
> > aperture_remove_conflicting_pci_devices() earlier in cirrus_pci_probe()?
> > 
> > If this new size check fails (either due to a malformed device or a larger
> > valid VRAM size), cirrus_pci_probe() aborts with -ENODEV. However, because
> > aperture_remove_conflicting_pci_devices() was already executed at the start
> > of the probe function, the firmware framebuffers (like efifb or simplefb)
> > have been permanently destroyed.
> > 
> > Could this leave the system with a dead display output? Would it make sense
> > to move this PCI configuration check to the very beginning of the probe
> > function, before any destructive actions occur?

Yeah I guess this new check can be before aperture_remove_conflicting_pci_devices().

> > >   	cirrus->vram = devm_ioremap(&pdev->dev, pci_resource_start(pdev, 0),
> > >   				    pci_resource_len(pdev, 0));
> > >   	if (cirrus->vram == NULL)

-- 
Slawomir Stepien
