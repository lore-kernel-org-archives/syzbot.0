Received: from smtpo49.interia.pl (smtpo49.interia.pl [217.74.67.49])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 95C032773E5
	for <syzbot@lists.linux.dev>; Tue, 25 Aug 2026 07:30:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.74.67.49
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787643047; cv=none; b=tF8/LO9yVHCr+wxwLIt+kYwnLR2yzMsbjFNuFybq3Cx+/Y7jFJFDp79eh/9/FpcpbSTHImoarDwtITsXRG+brEzZ/HEp3AwbJdJgdoohJGF5PtDplUxXwxCjDbDv3Iy/VFVOd+PD8sTo7M5bRUD1xaqWfjXSMZh8peG8fOA6GJQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787643047; c=relaxed/simple;
	bh=QNPsPX4KInNuEnbznTuVd8oKbW7SdLArzPhKjaxaYi0=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=gtRveUFkSQqVQ8MpLOOvVca2rffta5i4OKXmJxkDM2c7trSqHRDkjaYlj9G0hX50yw/KPSA3nlyacfhx7ydhfNFq2tyVpje6WIKgpf4/PzZ/rEPqGtOnV6utggcaxcFX+QQIH1KbHS8blBRGtWgTq5Dg8wLiVettvra6ff60SjM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=poczta.fm; spf=pass smtp.mailfrom=poczta.fm; dkim=pass (1024-bit key) header.d=poczta.fm header.i=@poczta.fm header.b=g82jPBCk; arc=none smtp.client-ip=217.74.67.49
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=poczta.fm
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=poczta.fm
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=poczta.fm header.i=@poczta.fm header.b="g82jPBCk"
Received: from nr200 (unknown [80.68.231.31])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (P-256) server-digest SHA256)
	(No client certificate requested)
	by poczta.interia.pl (INTERIA.PL) with ESMTPSA;
	Tue, 25 Aug 2026 09:30:33 +0200 (CEST)
Date: Tue, 25 Aug 2026 09:30:31 +0200
From: Slawomir Stepien <sst@poczta.fm>
To: syzbot <syzbot@kernel.org>
Cc: syzkaller-upstream-moderation@googlegroups.com, syzbot@lists.linux.dev
Subject: Re: [PATCH RFC v2] drm/cirrus-qemu: Validate BAR0 size during probe
Message-ID: <ao1ElwtHx3VIuovW@nr200>
References: <6e3c9a45-9c40-4717-9474-7abd0880ad79@mail.kernel.org>
Precedence: bulk
X-Mailing-List: syzbot@lists.linux.dev
List-Id: <syzbot.lists.linux.dev>
List-Subscribe: <mailto:syzbot+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:syzbot+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <6e3c9a45-9c40-4717-9474-7abd0880ad79@mail.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=poczta.fm; s=dk;
	t=1787643034; bh=1vMuJpuKKXFsMRu3VFTAEOye67cvwXBWrhelXa0Y3f8=;
	h=Date:From:To:Subject:Message-ID:MIME-Version:Content-Type;
	b=g82jPBCkf4ZCilEWc2JEIw4spyF62aWzXiAazDOMB9pERIkj3rzblQuGjH5ktRkAF
	 hsktcrbXjffPSXu7Kuqms1abJPu/J6P1yGhyHNDj0DMQE6xIXWCNA2M7tzddUYM0kz
	 /h+K1nApgmuFmL/PaG9Ck9orB/djgn5EoHOitTy4=

#syz upstream

On sie 24, 2026 13:12, syzbot wrote:
> The `cirrus-qemu` driver relies on `CIRRUS_VRAM_SIZE` (4 MB) to validate
> framebuffer sizes. However, during PCI probe, the driver mapped BAR0
> without verifying that its size matches `CIRRUS_VRAM_SIZE`.
> 
> If a PCI device with a BAR0 smaller than 4 MB is bound to the driver, the
> mapped VRAM will be smaller than expected. Because validation checks assume
> 4 MB VRAM, framebuffers larger than the mapped memory can be created.
> 
> When the display plane is updated (e.g. during release),
> `cirrus_primary_plane_helper_atomic_update()` copies the framebuffer to
> VRAM using `drm_fb_memcpy()`. Writing past the end of the mapped I/O memory
> causes a supervisor write page fault:
> 
> BUG: unable to handle page fault for address: ffffc9000389c000
> #PF: supervisor write access in kernel mode
> #PF: error_code(0x0002) - not-present page
> ...
> RIP: 0010:memcpy_toio+0x7c/0xe0 arch/x86/lib/iomem.c:110
> ...
> Call Trace:
>  <TASK>
>  iosys_map_memcpy_to include/linux/iosys-map.h:285 [inline]
>  drm_fb_memcpy+0x325/0x5d0 drivers/gpu/drm/drm_format_helper.c:442
>  cirrus_primary_plane_helper_atomic_update+0x98a/0xb00
>  drivers/gpu/drm/tiny/cirrus-qemu.c:358
>  drm_atomic_helper_commit_planes+0x626/0xea0
>  drivers/gpu/drm/drm_atomic_helper.c:3038
>  drm_atomic_helper_commit_tail+0x60/0x510
>  drivers/gpu/drm/drm_atomic_helper.c:1989
>  commit_tail+0x2b1/0x3c0 drivers/gpu/drm/drm_atomic_helper.c:2074
>  drm_atomic_helper_commit+0xa77/0xb10
>  drivers/gpu/drm/drm_atomic_helper.c:2312
> 
> Fix this by validating in `cirrus_pci_probe()` that the PCI BAR0 resource
> length equals `CIRRUS_VRAM_SIZE`, returning `-ENODEV` if it does not match.
> 
> Fixes: ab3e023b1b4c ("drm/cirrus: rewrite and modernize driver.")
> Assisted-by: Gemini:gemini-3.6-flash Gemini:gemini-3.1-pro-preview syzbot
> Reported-by: syzbot+2442951a6abb004df963@syzkaller.appspotmail.com
> Closes: https://syzkaller.appspot.com/bug?extid=2442951a6abb004df963
> Link: https://syzkaller.appspot.com/ai_job?id=ba262a3a-bccf-4ad8-a1b0-583c55d34fd6
> To: "David Airlie" <airlied@gmail.com>
> To: "Dave Airlie" <airlied@redhat.com>
> To: <dri-devel@lists.freedesktop.org>
> To: "Gerd Hoffmann" <kraxel@redhat.com>
> To: "Maarten Lankhorst" <maarten.lankhorst@linux.intel.com>
> To: "Maxime Ripard" <mripard@kernel.org>
> To: "Simona Vetter" <simona@ffwll.ch>
> To: "Thomas Zimmermann" <tzimmermann@suse.de>
> To: <virtualization@lists.linux.dev>
> Cc: "Jani Nikula" <jani.nikula@intel.com>
> Cc: <linux-kernel@vger.kernel.org>
> 
> ---
> v2:
> - Reject device in probe if PCI BAR0 resource length does not equal CIRRUS_VRAM_SIZE instead of dynamically tracking VRAM size.
> - Retain CIRRUS_VRAM_SIZE and keep atomic check and mode validation hooks unchanged.
> 
> v1:
> https://lore.kernel.org/all/6e0e7e49-c50d-472e-9cc2-ceaf814e0fc7@mail.kernel.org/T/
> ---
> diff --git a/drivers/gpu/drm/tiny/cirrus-qemu.c b/drivers/gpu/drm/tiny/cirrus-qemu.c
> index 075221b43..70c995025 100644
> --- a/drivers/gpu/drm/tiny/cirrus-qemu.c
> +++ b/drivers/gpu/drm/tiny/cirrus-qemu.c
> @@ -602,6 +602,9 @@ static int cirrus_pci_probe(struct pci_dev *pdev,
>  
>  	dev = &cirrus->dev;
>  
> +	if (pci_resource_len(pdev, 0) != CIRRUS_VRAM_SIZE)
> +		return -ENODEV;
> +
>  	cirrus->vram = devm_ioremap(&pdev->dev, pci_resource_start(pdev, 0),
>  				    pci_resource_len(pdev, 0));
>  	if (cirrus->vram == NULL)
> 
> 
> base-commit: db2ddb87143519e20a95aa36c60b36107b736a58

-- 
Slawomir Stepien
