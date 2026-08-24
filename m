Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 55695417BE2
	for <syzbot@lists.linux.dev>; Mon, 24 Aug 2026 11:58:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=100.103.45.18
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787572735; cv=pass; b=fVi3AamcRE/zCZaPJuQ5MB79aPu+Hr/D+xqWwJBFYASWH/qXbwRufu0LN8Ry0B1j57oyG0CWAoYkAogBRNWQf+xAKosHvwWs0Y/+9S3VM9+Ho4vjtmA5GoI7zhh6cYgUCwy9YT/ZeCXfPIXq44NOIOOzzPfsylYbbhlcHIAAksY=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787572735; c=relaxed/simple;
	bh=emICK5/qnW90205Qvb+86L87S74pEFmyev1Z9BL/9zY=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=AgClJN+ojKzAakvpwxSka9ySez9IkT0D0eALCfJs1wsryMAQL47feU6o+jwYTSmvSsYIYf6GPLs+k9i1unM99U6Ub3JxVBk1g3mbmMS3ly2UHiSVzEFx3zFIFCH88SLTPQSpHQpFfhaDUEgu5fXZZi9oa6XkG47d8xLAemkvYZE=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=poczta.fm header.i=@poczta.fm header.b=hvNd82TJ; arc=pass smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=poczta.fm header.i=@poczta.fm header.b="hvNd82TJ"
Received: by smtp.kernel.org (Postfix)
	id E87BE1F00A3A; Mon, 24 Aug 2026 11:58:52 +0000 (UTC)
Authentication-Results: smtp.kernel.org; arc=none smtp.remote-ip=217.74.67.75
ARC-Seal: i=1; d=kernel.org; s=arc20260519; a=rsa-sha256; cv=none;
	t=1787572732;
	b=wn+LD4XbBrkJ8RM8j7wCq+Fw11J05Q23wL9yv8HLKVE5Gvb1IS3peSnw3HrAAMjKw9sS
	 8NhFuY44mROFrwNuPqZ8KGYAAnAnGHzOzhS7PQkkiEzM1cdh/hXDGvkzZwBtNHIZeyuPW
	 u2sRpTnanoSiu15AGhfmPxxAOs4kxKytGMg0GMzLvooF6+PvDee/ID1arc/LQJLKa3ZC9
	 DvJirpy4DRVGSSDbh1pKa/4uCWWxwSAT4NtNbx4f//9AHf1UCeueLkjvfbFOmA1rlxgF2
	 iUUmu2NBym/JUBxaXOPjA5AGAawrMFTUZcSYntzd4NtSfhESrCGA+vg+/S4KRSkiDEg==
ARC-Message-Signature: i=1; d=kernel.org; s=arc20260519; a=rsa-sha256;
	c=relaxed/relaxed; t=1787572732;
	h=DMARC-Filter:Received:Date:From:To:Cc:Subject:Message-ID:References:
	 MIME-Version:Content-Type:Content-Disposition:In-Reply-To:
	 DKIM-Signature;
	bh=UbHYck8WvBnA94SIGXSWUg/gY2wL//QWFj6Avk+5M6o=;
	b=z1MakmW5p/ibpMjm4U7m+R0JFeGjlWgtypLpGoJuHLwicCUZ/eqAWJRg0LLbJkFzsaDL
	 6FVAgyn5UkBvo4Pgve9FrwYV6Ry6TLzHRKoDuFr8HFC5mWwVErVS5mIOcYM6GrW0tHyK3
	 ej4uZhWi9Uefsf32uQ/MbyKF4Eclr2v7XKLdKGq2x3JzNBxO4T18Q5Fq8923TtTVu8kPS
	 dbPv8BA8jIslDfTsFCTqt1oqmwmClFSfHgKSkEew/aE1xBlrR8uLiYgYq2NLnp3fKccz3
	 SZBz+bHCCi8qjDMslpfBoxwbGFu8Vm5MHDJkCMe1FUmVVEwPuPJCHkP1VqZP2Asciew==
ARC-Authentication-Results: i=1; smtp.kernel.org; dkim=pass header.d=poczta.fm header.i=@poczta.fm header.a=rsa-sha256 header.s=dk header.b=hvNd82TJ;
	dmarc=pass header.from=poczta.fm;
	spf=pass smtp.mailfrom=poczta.fm;
	arc=none smtp.remote-ip=217.74.67.75
Received: from smtpo75.interia.pl (smtpo75.interia.pl [217.74.67.75])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.kernel.org (Postfix) with ESMTPS id E83DD1F000E9
	for <syzbot@kernel.org>; Mon, 24 Aug 2026 11:58:50 +0000 (UTC)
Authentication-Results: smtp.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=poczta.fm header.i=@poczta.fm header.a=rsa-sha256 header.s=dk header.b=hvNd82TJ
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.kernel.org E83DD1F000E9
Authentication-Results: smtp.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=poczta.fm
Authentication-Results: smtp.kernel.org; spf=pass smtp.mailfrom=poczta.fm
Received: from nr200 (unknown [80.68.231.31])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (P-256) server-digest SHA256)
	(No client certificate requested)
	by poczta.interia.pl (INTERIA.PL) with ESMTPSA;
	Mon, 24 Aug 2026 13:58:47 +0200 (CEST)
Date: Mon, 24 Aug 2026 13:58:44 +0200
From: Slawomir Stepien <sst@poczta.fm>
To: syzbot <syzbot@kernel.org>
Cc: syzkaller-upstream-moderation@googlegroups.com, syzbot@lists.linux.dev
Subject: Re: [PATCH RFC] drm/cirrus-qemu: Use actual VRAM size to prevent
 out-of-bounds write
Message-ID: <aowx9LUZgrhDZnSM@nr200>
References: <6e0e7e49-c50d-472e-9cc2-ceaf814e0fc7@mail.kernel.org>
Precedence: bulk
X-Mailing-List: syzbot@lists.linux.dev
List-Id: <syzbot.lists.linux.dev>
List-Subscribe: <mailto:syzbot+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:syzbot+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <6e0e7e49-c50d-472e-9cc2-ceaf814e0fc7@mail.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=poczta.fm; s=dk;
	t=1787572728; bh=UbHYck8WvBnA94SIGXSWUg/gY2wL//QWFj6Avk+5M6o=;
	h=Date:From:To:Subject:Message-ID:MIME-Version:Content-Type;
	b=hvNd82TJNgX35dfWnQLlVYWfykUbKrDfZq08zazz6YMYfBrsDMYaaNlM7YxvdINVl
	 H2I1byin3n5iATUHYEqLRrA904GUEvB6L57bZ0qg1wl4fhLCJSnlC+svwPtuu8zDkU
	 iRTMr4mBnenNf5L7/TwrPWL83RiWDCuW//VDYZ00=

On sie 16, 2026 23:42, 'syzbot' via syzkaller-upstream-moderation wrote:
> The `cirrus-qemu` driver previously relied on a hardcoded constant
> `CIRRUS_VRAM_SIZE` (4 MB) to validate framebuffer sizes. However, during
> device probe, the driver maps the VRAM using the actual size of the PCI
> device's BAR0.
> 
> If a privileged user unbinds a random PCI device with a BAR0 smaller than 4
> MB and binds the `cirrus-qemu` driver to it, the mapped VRAM will be
> smaller than 4 MB. Because the validation checks still used the hardcoded 4
> MB size, the driver would allow the creation of a framebuffer larger than
> the actually mapped VRAM.
> 
> When the DRM device is closed, `drm_release()` triggers a full atomic
> commit to restore the fbdev mode. This calls
> `cirrus_primary_plane_helper_atomic_update()`, which uses `drm_fb_memcpy()`
> to copy the framebuffer into the mapped VRAM. Since the mapped VRAM is
> smaller than the framebuffer, `memcpy_toio()` writes past the end of the
> mapped I/O memory, resulting in a supervisor write page fault:
> 
> BUG: unable to handle page fault for address: ffffc900033dd000
> #PF: supervisor write access in kernel mode
> #PF: error_code(0x0002) - not-present page
> ...
> RIP: 0010:rep_movs arch/x86/lib/iomem.c:13 [inline]
> RIP: 0010:string_memcpy_toio arch/x86/lib/iomem.c:64 [inline]
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
> ...
> 
> To fix this, remove the hardcoded `CIRRUS_VRAM_SIZE` and dynamically track
> the actual VRAM size in `struct cirrus_device`. Initialize this size from
> the PCI resource length during probe, ensuring it is non-zero. Update the
> validation hooks `cirrus_primary_plane_helper_atomic_check()` and
> `cirrus_mode_config_mode_valid()` to use the dynamically tracked VRAM size,
> ensuring that framebuffers strictly fit within the mapped memory.
> 
> Fixes: ab3e023b1b4c ("drm/cirrus: rewrite and modernize driver.")
> Assisted-by: Gemini:gemini-3.6-flash Gemini:gemini-3.1-pro-preview syzbot
> Reported-by: syzbot+2442951a6abb004df963@syzkaller.appspotmail.com
> Closes: https://syzkaller.appspot.com/bug?extid=2442951a6abb004df963
> Link: https://syzkaller.appspot.com/ai_job?id=0995d2c9-3eea-4945-84e7-ab3d2acd4f21
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
> Cc: "Luca Ceresoli" <luca.ceresoli@bootlin.com>
> 
> ---
> diff --git a/drivers/gpu/drm/tiny/cirrus-qemu.c b/drivers/gpu/drm/tiny/cirrus-qemu.c
> index 075221b43..7f8cb3264 100644
> --- a/drivers/gpu/drm/tiny/cirrus-qemu.c
> +++ b/drivers/gpu/drm/tiny/cirrus-qemu.c
> @@ -55,7 +55,6 @@
>  #define DRIVER_MINOR 0
>  
>  #define CIRRUS_MAX_PITCH (0x1FF << 3)      /* (4096 - 1) & ~111b bytes */
> -#define CIRRUS_VRAM_SIZE (4 * 1024 * 1024) /* 4 MB */
>  
>  struct cirrus_device {
>  	struct drm_device	       dev;
> @@ -68,6 +67,7 @@ struct cirrus_device {
>  
>  	/* HW resources */
>  	void __iomem		       *vram;
> +	size_t			       vram_size;
>  	void __iomem		       *mmio;
>  };
>  
> @@ -298,6 +298,7 @@ static const uint64_t cirrus_primary_plane_format_modifiers[] = {
>  static int cirrus_primary_plane_helper_atomic_check(struct drm_plane *plane,
>  						    struct drm_atomic_commit *state)
>  {
> +	struct cirrus_device *cirrus = to_cirrus(plane->dev);
>  	struct drm_plane_state *new_plane_state = drm_atomic_get_new_plane_state(state, plane);
>  	struct drm_framebuffer *fb = new_plane_state->fb;
>  	struct drm_crtc *new_crtc = new_plane_state->crtc;
> @@ -319,7 +320,7 @@ static int cirrus_primary_plane_helper_atomic_check(struct drm_plane *plane,
>  	/* validate size constraints */
>  	if (fb->pitches[0] > CIRRUS_MAX_PITCH)
>  		return -EINVAL;
> -	else if (fb->pitches[0] > CIRRUS_VRAM_SIZE / fb->height)
> +	else if (fb->pitches[0] > cirrus->vram_size / fb->height)
>  		return -EINVAL;
>  
>  	return 0;
> @@ -514,6 +515,7 @@ static int cirrus_pipe_init(struct cirrus_device *cirrus)
>  static enum drm_mode_status cirrus_mode_config_mode_valid(struct drm_device *dev,
>  							  const struct drm_display_mode *mode)
>  {
> +	struct cirrus_device *cirrus = to_cirrus(dev);
>  	const struct drm_format_info *format = drm_format_info(DRM_FORMAT_XRGB8888);
>  	u64 pitch;
>  
> @@ -525,7 +527,7 @@ static enum drm_mode_status cirrus_mode_config_mode_valid(struct drm_device *dev
>  		return MODE_BAD_WIDTH;
>  	if (pitch > CIRRUS_MAX_PITCH)
>  		return MODE_BAD_WIDTH; /* maximum programmable pitch */
> -	if (pitch > CIRRUS_VRAM_SIZE / mode->vdisplay)
> +	if (pitch > cirrus->vram_size / mode->vdisplay)
>  		return MODE_MEM;
>  
>  	return MODE_OK;
> @@ -602,8 +604,12 @@ static int cirrus_pci_probe(struct pci_dev *pdev,
>  
>  	dev = &cirrus->dev;
>  
> +	if (pci_resource_len(pdev, 0) == 0)

How about checking here also if the returned value is == to CIRRUS_VRAM_SIZE and leave the
CIRRUS_VRAM_SIZE as it is right now? Or even better:

if (pci_resource_len(pdev, 0) != CIRRUS_VRAM_SIZE)
	return -ENODEV;

This will make this change a much simpler one!

It seems, after checking the qemu sources, that CLGD5446 must have 4MB and there is not other
option.

> +		return -ENODEV;
> +
> +	cirrus->vram_size = pci_resource_len(pdev, 0);
>  	cirrus->vram = devm_ioremap(&pdev->dev, pci_resource_start(pdev, 0),
> -				    pci_resource_len(pdev, 0));
> +				    cirrus->vram_size);
>  	if (cirrus->vram == NULL)
>  		return -ENOMEM;
>  
> 
> 
> base-commit: db2ddb87143519e20a95aa36c60b36107b736a58

-- 
Slawomir Stepien
