Received: from mail-ej1-f54.google.com (mail-ej1-f54.google.com [209.85.218.54])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2C98013B58C
	for <syzbot@lists.linux.dev>; Fri,  7 Aug 2026 09:07:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.54
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786093679; cv=none; b=DLAKJ3WHL/Zpf0GEjlsw8zsU8ZTcZmQIlPIbD+9+WdswXrCtaeca2+2XMDe/bC802X3pAz3ZSt7M3NR0pgTivB9xRCgpEYSggYnQL0ZXjUUz6gpFp353JDJVZ+OJ5qblPrTzgZ7Os8qW2otPiHmtnmgMTA9Rp5/maKU6No6bnXg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786093679; c=relaxed/simple;
	bh=+8j7alp2JrkwSbF5p0MJHlU15GhlWakdZANGDt//VJs=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=Ku2BtMyRswNNpGZWZAV8JfXnf8vIE3exmDiAO28khQZA2qwWUgI4nKs4VMMDnsf1z2so82wGxnSXipTiQaG1ZjccYWcuP+aYZetDJmczTaIlv6/IxRQhcTqIJNC4CkZpiKhP33HD1lbuzEeLcus/JvEzb83XmR/2VyoP3I7diwg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=fLeEi8mM; arc=none smtp.client-ip=209.85.218.54
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="fLeEi8mM"
Received: by mail-ej1-f54.google.com with SMTP id a640c23a62f3a-c1fbe461f59so460887566b.2
        for <syzbot@lists.linux.dev>; Fri, 07 Aug 2026 02:07:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1786093675; x=1786698475; darn=lists.linux.dev;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=X0lH4pPBuy/D9mnlikrnB0VUHLOlrivlK94IzTKexHQ=;
        b=fLeEi8mMJiPwYYBSRXVGgICnwGm70vI2uvN8iQgP9UvfBdyl9veKF1xCUkAgcgjbIO
         kgOWnARyiV0OtkBfGfUyGm/CW2DGO/+YEnJrzKhZhFksR2KOpHB4iSW3NKEueZHpB7iF
         DL6zCIRd+l8RIgDARq1bQxbOkV7d6FBxQT2/3OeizdfC9X0vk/bZaFbfNXXc8KD1WG3C
         qTwr3M5zTOOKreZsZAIecy+Bcmp+6J1rHuzn4j4IOhTq/iHe8wgKFf+j+YYctrV5TS3O
         BzZobYceJlXz7fz2wYdyAitQIb99snk8fnBYcO4Tx/+wTqpVaPRpT6UdXpRBXs9gygc7
         YWLA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1786093675; x=1786698475;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=X0lH4pPBuy/D9mnlikrnB0VUHLOlrivlK94IzTKexHQ=;
        b=fsZbWziV2LkILlczsabZZtM0QlCWnxp4EWBvu+Zv32TrWAU+oYtCv7/BC5RLZHJovn
         3x4LSDEA4mVdxrXoGFM9rYVzno/ycWpF30Tb8dxvSiFuLNL/NCewFgXNBsrXGRwXxCui
         9SR+oe/srNimcvz6KAYQf1kB6sDNm/VouwVXBp4cZHxW6iw+tCGPyeeOW/vHau3pHKxk
         FDfj/92PP0v0RIzpLF5Ms61sJJqafVMW1bM3bp+soBP98rSHhKkPlHYYtJPzUZuqa6bL
         rahP8aRTDijDg9T7voFUM8gYlfMMvCQEGE5rgLovs7HqYBRCFRV4vbcaVC7HBKN8j1xQ
         kwHQ==
X-Gm-Message-State: AOJu0Yxi0In2fYwBovYjd+5uoeyQackfWNf6kNU5Cbs0A/PW5Z1ofjE3
	qsypPYQY9bXjejkED57nhOgIOpO5EWKVRaTWt3gXr0r1YJdE7WN8FGFmSVhaUQ==
X-Gm-Gg: AR+sD12ldZPXOcbgVDaUakIbVHpWb7HSqd7jXpV1W8Yhf8mkCkMduFGlONTWk/5HuOx
	wrENa6gCC1Lxx6F6YZJ9qOGzUYTxOV3A6e0X0bQKde2K4hQgxKfAGDmw5I+ShCpnDXbtJGxboaf
	jJyilvGljJMNqkiRzZkao+L8dtFop016PEX3MIGIoiPzP2MqvIv/+rob8HSdpYBmPs025cOl7Zx
	x70CimS7fOvgYOSdfjEhPEmPlrhdZ5b8ylNSp8fY48A4k/0V9XYx8CemeVSBfspSzR5yHX48Vh9
	0j5THiShw+klRr01mgCCML8H12lGknQssV7DzMwaZtrESxMl/wKZ4ZDhLEfAuNZx4yqCvZbEAHt
	ZKnEQ/6jcoyCUiX85Ze6qHI3UA9po5D/65rSkuD2PzQqNsTBYYeYsBtzxbTKbwvaEDhhTp+x69f
	zDgDBIebKSYjzbzrYsyqbbEA6mCVZM6x3ViS0aAFOrjFIWpeCX7FtMETi5/449wHEghV8MDXFrV
	LJyCPIaNWJxhZRIxNKM1Sxb2WeuRNQ8n2GijiVlBjHLuhrP7E2Inbj4fuY98X2rpfxL6uEBmOVs
	Z5fqKpjikNY/ShLxB7M9Vz5PpLfTDe0bBgTe68Q/YL7OfmTiDGAlidc=
X-Received: by 2002:a17:907:3cd2:b0:c20:295d:6574 with SMTP id a640c23a62f3a-c207320a7e7mr375294566b.12.1786093674710;
        Fri, 07 Aug 2026 02:07:54 -0700 (PDT)
Received: from [192.168.100.51] (87-205-15-91.static.ip.netia.com.pl. [87.205.15.91])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-c2080a29a8fsm28909166b.4.2026.08.07.02.07.53
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 07 Aug 2026 02:07:54 -0700 (PDT)
Message-ID: <00b8feba-9c2c-4ce8-8f48-7c9b13ec6403@gmail.com>
Date: Fri, 7 Aug 2026 11:07:53 +0200
Precedence: bulk
X-Mailing-List: syzbot@lists.linux.dev
List-Id: <syzbot.lists.linux.dev>
List-Subscribe: <mailto:syzbot+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:syzbot+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH RFC v3] drm/client: Avoid warning on vblank timeout during
 modeset client waits
To: syzbot <syzbot@kernel.org>, syzkaller-upstream-moderation@googlegroups.com
Cc: syzbot@lists.linux.dev
References: <0bbd5c22-3a1c-4e66-9d45-932bb858d0af@mail.kernel.org>
Content-Language: en-US
From: Krystian Kaniewski <krystianmkaniewski@gmail.com>
In-Reply-To: <0bbd5c22-3a1c-4e66-9d45-932bb858d0af@mail.kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

Keep the timeout-warning suppression limited to the best-effort DRM 
client path, but fix the public helper's error-source ambiguity. The 
current wrapper emits the wait-timeout warning whenever the internal 
helper returns `-ETIMEDOUT`. That return value can also come from 
`drm_vblank_get()`, which propagates the driver's `enable_vblank()` 
errno. If acquisition returns `-ETIMEDOUT`, no wait occurred, yet the 
patch emits both the availability warning and a false wait-timeout warning.

Separate vblank acquisition from the quiet counter wait. Make the 
private helper perform only the counter sampling and 
`wait_event_timeout()` under a caller-held vblank reference. Keep the 
client's existing outer `drm_crtc_vblank_get()` and 
`drm_crtc_vblank_put()` pair, call the private helper between them, and 
continue to ignore its timeout result.

In the exported `drm_crtc_wait_one_vblank()` wrapper, perform 
`drm_vblank_get()` and its availability warning directly, and return an 
acquisition error immediately. Only after successful acquisition should 
it call the private helper and emit the timeout warning for 
`-ETIMEDOUT`. Preserve the original warning-before-put ordering, return 
values, one-second deadline, wait predicate, public signature, exported 
ABI, and strict behavior of all direct public callers. Keep 
`drm_atomic_helper_wait_for_vblanks()` unchanged.

Retain the cleaned commit-message style, corrected `Fixes` tag, AI 
provenance, report links, and current recipient list. Update the 
explanation to state that keeping acquisition in the public wrapper 
prevents an `enable_vblank()` error from being mislabeled as a wait timeout.

On 8/6/2026 8:10 PM, syzbot wrote:
> On PREEMPT_RT kernels, a user-space task with elevated Real-Time (RT)
> priority can starve essential kernel threads. For example, the VKMS driver
> simulates vblank interrupts using hrtimers. On PREEMPT_RT, these timers run
> in the per-CPU timer threads at a low RT priority. If a user-space task
> elevates its priority above the timer thread and monopolizes the CPU, the
> timer thread is starved and the VKMS software vblank delivery is delayed
> beyond the timeout.
>
> This leads to a timeout when a worker thread waits for the vblank event.
> For instance, a console update triggers a framebuffer update, scheduling
> drm_fb_helper_damage_work() on the system workqueue. The worker thread
> eventually calls drm_client_modeset_wait_for_vblank() to synchronize the
> screen update with the vblank interval. Due to the starved timer, the wait
> times out and triggers a warning in drm_crtc_wait_one_vblank().
>
> Since this vblank wait in the client modeset path is only used for optional
> client update throttling, a timeout is acceptable and does not indicate a
> kernel bug. Therefore, a warning should not be triggered in this case.
>
> Introduce drm_crtc_wait_one_vblank_internal(), which performs the vblank
> wait without triggering a warning on timeout. This new function is used in
> drm_client_modeset_wait_for_vblank() to avoid the warning, while keeping
> the warning in drm_crtc_wait_one_vblank() for other callers where a timeout
> might still indicate an actual issue.
>
> Fixes: d8c4bddcd8bc ("drm/fb-helper: Synchronize dirty worker with vblank")
> Assisted-by: Gemini:gemini-3.5-flash Gemini:gemini-3.1-pro-preview syzbot
> Reported-by: syzbot+f59157955aba9d0cb43b@syzkaller.appspotmail.com
> Closes: https://syzkaller.appspot.com/bug?extid=f59157955aba9d0cb43b
> Link: https://syzkaller.appspot.com/ai_job?id=527b7209-9098-44da-8634-7792d361dea5
> To: "David Airlie" <airlied@gmail.com>
> To: <dri-devel@lists.freedesktop.org>
> To: "Maarten Lankhorst" <maarten.lankhorst@linux.intel.com>
> To: "Maxime Ripard" <mripard@kernel.org>
> To: "Simona Vetter" <simona@ffwll.ch>
> To: "Thomas Zimmermann" <tzimmermann@suse.de>
> Cc: <linux-kernel@vger.kernel.org>
>
> ---
> v3:
> - Removed the raw kernel cut marker and full warning trace from the commit description.
> - Replaced first-person phrasing with impersonal wording in the commit description.
>
> v2:
> - Introduced drm_crtc_wait_one_vblank_internal() to allow waiting for vblank without warning on timeout.
> - Updated drm_client_modeset_wait_for_vblank() to use the new internal function, avoiding warnings during optional client update throttling.
> - Restored the warning in drm_crtc_wait_one_vblank() for other callers.
> https://lore.kernel.org/all/5edd530e-c20d-42c4-bf55-0656081f030d@mail.kernel.org/T/
>
> v1:
> https://lore.kernel.org/all/7527aaed-dcb2-4bde-a807-1677dcd0af99@mail.kernel.org/T/
> ---
> diff --git a/drivers/gpu/drm/drm_client_modeset.c b/drivers/gpu/drm/drm_client_modeset.c
> index 0080a8e95..7ff0f24a0 100644
> --- a/drivers/gpu/drm/drm_client_modeset.c
> +++ b/drivers/gpu/drm/drm_client_modeset.c
> @@ -1328,7 +1328,7 @@ int drm_client_modeset_wait_for_vblank(struct drm_client_dev *client, unsigned i
>   	 */
>   	ret = drm_crtc_vblank_get(crtc);
>   	if (!ret) {
> -		drm_crtc_wait_one_vblank(crtc);
> +		drm_crtc_wait_one_vblank_internal(crtc);
>   		drm_crtc_vblank_put(crtc);
>   	}
>   
> diff --git a/drivers/gpu/drm/drm_internal.h b/drivers/gpu/drm/drm_internal.h
> index f893b1e3a..6fd33672d 100644
> --- a/drivers/gpu/drm/drm_internal.h
> +++ b/drivers/gpu/drm/drm_internal.h
> @@ -115,6 +115,7 @@ void drm_vblank_disable_and_save(struct drm_device *dev, unsigned int pipe);
>   int drm_vblank_get(struct drm_device *dev, unsigned int pipe);
>   void drm_vblank_put(struct drm_device *dev, unsigned int pipe);
>   u64 drm_vblank_count(struct drm_device *dev, unsigned int pipe);
> +int drm_crtc_wait_one_vblank_internal(struct drm_crtc *crtc);
>   
>   /* drm_vblank_work.c */
>   static inline void drm_vblank_flush_worker(struct drm_vblank_crtc *vblank)
> diff --git a/drivers/gpu/drm/drm_vblank.c b/drivers/gpu/drm/drm_vblank.c
> index f90fb2d13..7758e8265 100644
> --- a/drivers/gpu/drm/drm_vblank.c
> +++ b/drivers/gpu/drm/drm_vblank.c
> @@ -1297,17 +1297,7 @@ void drm_crtc_vblank_put(struct drm_crtc *crtc)
>   }
>   EXPORT_SYMBOL(drm_crtc_vblank_put);
>   
> -/**
> - * drm_crtc_wait_one_vblank - wait for one vblank
> - * @crtc: DRM crtc
> - *
> - * This waits for one vblank to pass on @crtc, using the irq driver interfaces.
> - * It is a failure to call this when the vblank irq for @crtc is disabled, e.g.
> - * due to lack of driver support or because the crtc is off.
> - *
> - * Returns: 0 on success, negative error on failures.
> - */
> -int drm_crtc_wait_one_vblank(struct drm_crtc *crtc)
> +int drm_crtc_wait_one_vblank_internal(struct drm_crtc *crtc)
>   {
>   	struct drm_device *dev = crtc->dev;
>   	int pipe = drm_crtc_index(crtc);
> @@ -1326,12 +1316,30 @@ int drm_crtc_wait_one_vblank(struct drm_crtc *crtc)
>   				 last != drm_vblank_count(dev, pipe),
>   				 msecs_to_jiffies(1000));
>   
> -	drm_WARN(dev, ret == 0, "vblank wait timed out on crtc %i\n", pipe);
> -
>   	drm_vblank_put(dev, pipe);
>   
>   	return ret ? 0 : -ETIMEDOUT;
>   }
> +
> +/**
> + * drm_crtc_wait_one_vblank - wait for one vblank
> + * @crtc: DRM crtc
> + *
> + * This waits for one vblank to pass on @crtc, using the irq driver interfaces.
> + * It is a failure to call this when the vblank irq for @crtc is disabled, e.g.
> + * due to lack of driver support or because the crtc is off.
> + *
> + * Returns: 0 on success, negative error on failures.
> + */
> +int drm_crtc_wait_one_vblank(struct drm_crtc *crtc)
> +{
> +	int ret = drm_crtc_wait_one_vblank_internal(crtc);
> +
> +	drm_WARN(crtc->dev, ret == -ETIMEDOUT, "vblank wait timed out on crtc %i\n",
> +		 drm_crtc_index(crtc));
> +
> +	return ret;
> +}
>   EXPORT_SYMBOL(drm_crtc_wait_one_vblank);
>   
>   /**
>
>
> base-commit: f5098b6bae761e346ebcd9da7f95622c04733cff
