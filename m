Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CDB3F48094E
	for <syzbot@lists.linux.dev>; Thu,  6 Aug 2026 15:58:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=100.103.45.18
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786031930; cv=pass; b=mEN5zxi1EHT7weEOWy/5uMWdiuZ+Ce5UKfw5SjyvTGfN6FzGjIcvpyyYog5XBW/XpT3kfla5DfMmpJtPJgflWs157EfJEaSbYFYY58k3MGzI/0vsn7OG2LYONuY5oftER2XHK2h6S5ogTFVwEVa+HSa1il8QL5P6uNX/FrgkNYU=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786031930; c=relaxed/simple;
	bh=w01+NuLCw31Rr0dOXrVFp4tvsuQ/mSNCEnjj7QChSCM=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=Tis5GzY86Z3m5eYE6wG1xTckRY27pGUgUmgLw9mxhUfhxUQQDVoFG2C4I2qDTWh6B+bR9Af1Gt1xhJ6j/bNEtUOJi3RSjSjFDw9kzoexmrkcSUp6m12UOfNKmxW1YwHVZYN9admPguAsMXKCB+5DlntYSMKOLqaYDsw8oEl2fxE=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=qzPexoEM; arc=pass smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="qzPexoEM"
Received: by smtp.kernel.org (Postfix)
	id 019AD1F00A3D; Thu,  6 Aug 2026 15:58:41 +0000 (UTC)
Authentication-Results: smtp.kernel.org; arc=none smtp.remote-ip=209.85.208.44
ARC-Seal: i=1; d=kernel.org; s=arc20260519; a=rsa-sha256; cv=none;
	t=1786031920;
	b=bBJCJqCiddenCuMnhczvYSxpFVhhbxfbhT9G69FOuZzFErWDM7qCbDMja2RyQWoz7Ua/
	 KtesW18FG8zhtFVisHWuZxsEex98XxHDSEQVP2FNqewPvMT9LlQ86fBg4nsgMTWTXLFsS
	 BMgSNMuuOH4kEt7FTXhbskgIHshjjpKicYnurA3OSnLBMlhtTiBsSSLSVb+LU5kTJp8O2
	 QZf8zojhkuk9XupZtf7fXyWJHHCHebZKx+AqK8bUsAhjld0L8WOc8YMODCr8XAeNmVw2j
	 J9r/sx4SX4eZ598CLHe+9Eev64gq7ti+TbiB36HrTRBCxmMNCG1izIL0ZaKRq9VFaoA==
ARC-Message-Signature: i=1; d=kernel.org; s=arc20260519; a=rsa-sha256;
	c=relaxed/relaxed; t=1786031920;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Gm-Message-State:X-Gm-Gg:X-Received:Received:Message-ID:Date:
	 MIME-Version:User-Agent:Subject:To:Cc:References:Content-Language:
	 From:In-Reply-To:Content-Type:Content-Transfer-Encoding;
	bh=JohyEsXm5YdqjDvpMLtwsOGeSabHwTTmCEzJ7lV9JJw=;
	b=sB+M9hfvT/R1RGKgMzeM82B3yDLDmaAoPtqf9jkR33AYeak4PmK7sZmCwOSxQpg4R8HH
	 DYhw1jAOiEH5KsS0cyf0fPqkyX0yKJQuS9WO7xA/V+zgpK0OpeFYAErJSjsx47ApmNnId
	 Vc2TaxhfSYIJFyOS8czrvGWq5tDNqOxHPPk6SOFoUI2RcXf/zLedjv2g1wRpj3KQmYd+E
	 RYSEwvoqvMVTUGSyFqLPsmetk4fh0QImTLbG4mWSdOFq8DT03AotBjdFNp+xCCXSEeHEd
	 s7VArMOo6ndFZTf+5ONwCVWKds9Mt/i7AdO5xbEx6BjA7OmQ8n/FbLOko3B49cPHPng==
ARC-Authentication-Results: i=1; smtp.kernel.org; dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20251104 header.b=qzPexoEM;
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	arc=none smtp.remote-ip=209.85.208.44
Received: from mail-ed1-f44.google.com (mail-ed1-f44.google.com [209.85.208.44])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.kernel.org (Postfix) with ESMTPS id 1B06D1F000E9
	for <syzbot@kernel.org>; Thu,  6 Aug 2026 15:58:39 +0000 (UTC)
Authentication-Results: smtp.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20251104 header.b=qzPexoEM
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.kernel.org 1B06D1F000E9
Authentication-Results: smtp.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-ed1-f44.google.com with SMTP id 4fb4d7f45d1cf-6a1d11bda7fso27124a12.2
        for <syzbot@kernel.org>; Thu, 06 Aug 2026 08:58:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1786031918; x=1786636718; darn=kernel.org;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=JohyEsXm5YdqjDvpMLtwsOGeSabHwTTmCEzJ7lV9JJw=;
        b=qzPexoEMJb7Ru3T5u1GzxPspkPPYDPrItfr5ZPvArGI0AFAoQTlRrdNpasrJ9XHLAU
         EYZvNaxlOAzIcofhfBxtmfoC5+5V2Pbq7C0V5q3klneKe4VeKj6E8bIeyfDWxEliLCpE
         xdlBa9y/zV88742O7H8zDmh2V9RoHPWHQLLyRrakHamYj6MmEL+8KjXsOjwbYzR0c4Ci
         HsUvglyBxeHwzZ3aRyZMi41WWUD8oD3CSuOoPzEgq7Y9U+FpZsRP8BHPZVmoZotP2ONI
         KZdB7a8vz6w87mMS16J19bAdEMB8EguD3EigFumfjwjiyJr/B4oA12VVGcGj91peu7D/
         eEtQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1786031918; x=1786636718;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=JohyEsXm5YdqjDvpMLtwsOGeSabHwTTmCEzJ7lV9JJw=;
        b=jgl75Z6rsPVdJbpaJs8Zb2103XZHoJivAij/UCA0yxjmjB8KNR4XZ6ZUpMubdFlbJH
         ljzclpdIFuFispbTpOIkPkhxOiCxVvxSAL/TX5E0g8vqBzoYbacPfmJrz+moYqpkTKAw
         nfdYCE1izQ4WJzBcQ+n1ZYdGTz3lNNHVaGKMXW4yXxNdfyKNlzzcKIjR7ZVx2vB7KI8N
         iv+WFFTwAXm/SRTwOd49SReSIlxXa4ZjpUwCltgBKtqWnLli9cLS2u6HTUGA5r1t72iq
         XEm811CnAuZJVUp3whLFQeC+TYSIV5lK8cXTOOofk5rJ5Eku+S+mXr1HoJSjNeH5RHFD
         Ou4Q==
X-Gm-Message-State: AOJu0YzcwtPWYAbp/KIcU70et7Xc2px+WwcCc3QWIPZEfMNA1UXgZ7WW
	1Bd04yamJDzo3Uu6iWzMdT5+W0TUEeyUrY7SxJNyHKljwmLcLCRvyD9R2FCiNdpA
X-Gm-Gg: AR+sD13ZhHOAOKKgQZTYWCgOpv3jtixWa24q2+SwgaOR9KDhPrsa26IOLAG54VtTkPw
	cj5OWOOexgBXoTub629ookRYszE4BJew0es1v1uF5zIVpIC/KnCisxcAKaQlPHMl/FWJlWOdn7q
	z1VtjSzg1/ICPIEuDAWJtyUno3c0uRrYhfxLU3IKNAt2U0GpLe+VuBr8M0PW45YeR8uyooHL4ns
	SjWjSKa51Ys15rJ5cMXBtYUC8qfV+VBKutwE9eyV3/LdruAG3JC41pBqCuMV8qzyP1lcERWTTG1
	kWAhJD++AQSoLQBoh5lGl8WeJFmSsixZmfg0J1QmwzXVAWtbvk5MoDW0PrklEBWU87Xujbg21s+
	gx/zKGyVofC86Guh2HsCj/Guobk8BDn/RaWXT1VaYei9XTkrS/ciUzXDXCWBcncOHMGqOOWvdNJ
	7AAslSjig4xHTcNAtAes4S+mCP4o0YKtKXcMXNPaLIJrQoY0NwIufMFY0JGhLbfjxEVRqR1PabD
	vHOSAH8mfopUS+uTra+aIsGYYqp9W4sm0P89GmT2qK4P73267fir/4ATyVaKipBWZjUTGrIBMNZ
	yNK9FrftRsEKgWCPGx+YjeRtUja1S5R6Vvc5NIVVAVlgIIJRj/sLGUo=
X-Received: by 2002:a17:907:1ca0:b0:c20:2299:1ddb with SMTP id a640c23a62f3a-c2039abc09cmr944468466b.3.1786031917924;
        Thu, 06 Aug 2026 08:58:37 -0700 (PDT)
Received: from [192.168.100.51] (87-205-15-91.static.ip.netia.com.pl. [87.205.15.91])
        by smtp.gmail.com with ESMTPSA id 4fb4d7f45d1cf-6a196420ca2sm1092014a12.26.2026.08.06.08.58.37
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 06 Aug 2026 08:58:37 -0700 (PDT)
Message-ID: <91ba6d36-11a7-415e-9657-8604101de7f9@gmail.com>
Date: Thu, 6 Aug 2026 17:58:37 +0200
Precedence: bulk
X-Mailing-List: syzbot@lists.linux.dev
List-Id: <syzbot.lists.linux.dev>
List-Subscribe: <mailto:syzbot+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:syzbot+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH RFC v2] drm/client: Avoid warning on vblank timeout during
 modeset client waits
To: syzbot <syzbot@kernel.org>, syzkaller-upstream-moderation@googlegroups.com
Cc: syzbot@lists.linux.dev
References: <5edd530e-c20d-42c4-bf55-0656081f030d@mail.kernel.org>
Content-Language: en-US
From: Krystian Kaniewski <krystianmkaniewski@gmail.com>
In-Reply-To: <5edd530e-c20d-42c4-bf55-0656081f030d@mail.kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

Keep the code changes unchanged and clean up the commit message. Remove 
the raw kernel cut marker and full warning trace because the unindented 
marker is treated as an invalid commit separator. Replace the 
first-person sentence about suppressing the warning with direct, 
impersonal wording.

Retain the PREEMPT_RT and VKMS root-cause explanation, the statement 
that timeout is acceptable only for best-effort client throttling, the 
`Fixes` tag, AI provenance, and the current code scope. In particular, 
preserve the client-only timeout suppression, both public helper 
diagnostics and return values, the unchanged atomic helper, the 
one-second timeout, wait predicate, reference behavior, private header 
placement, and exported ABI.

On 8/6/2026 12:55 PM, syzbot wrote:
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
> times out and triggers a warning in drm_crtc_wait_one_vblank():
>
> ------------[ cut here ]------------
> faux_driver vkms: [drm] vblank wait timed out on crtc 0
> WARNING: drivers/gpu/drm/drm_vblank.c:1329 at
> drm_crtc_wait_one_vblank+0x3bc/0x560
> Workqueue: events drm_fb_helper_damage_work
> RIP: 0010:drm_crtc_wait_one_vblank+0x51a/0x560
> Call Trace:
>   <TASK>
>   drm_client_modeset_wait_for_vblank+0xc5/0xf0
>   drivers/gpu/drm/drm_client_modeset.c:1331
>   drm_fb_helper_damage_work+0x6cf/0xf00 drivers/gpu/drm/drm_fb_helper.c:365
>   process_scheduled_works+0xa8e/0x14e0 kernel/workqueue.c:3405
>   worker_thread+0x92d/0xe10 kernel/workqueue.c:3486
>   kthread+0x388/0x470 kernel/kthread.c:436
>   </TASK>
>
> Since this vblank wait in the client modeset path is only used for optional
> client update throttling, a timeout is acceptable and does not indicate a
> kernel bug. Therefore, we should not trigger a warning in this case.
>
> Introduce drm_crtc_wait_one_vblank_internal(), which performs the vblank
> wait without triggering a warning on timeout. Use this new function in
> drm_client_modeset_wait_for_vblank() to avoid the warning, while keeping
> the warning in drm_crtc_wait_one_vblank() for other callers where a timeout
> might still indicate an actual issue.
>
> Fixes: d8c4bddcd8bc ("drm/fb-helper: Synchronize dirty worker with vblank")
> Assisted-by: Gemini:gemini-3.5-flash Gemini:gemini-3.1-pro-preview syzbot
> Reported-by: syzbot+f59157955aba9d0cb43b@syzkaller.appspotmail.com
> Closes: https://syzkaller.appspot.com/bug?extid=f59157955aba9d0cb43b
> Link: https://syzkaller.appspot.com/ai_job?id=dc062239-05be-4cff-92cb-604030dc57a5
> To: "David Airlie" <airlied@gmail.com>
> To: <dri-devel@lists.freedesktop.org>
> To: "Maarten Lankhorst" <maarten.lankhorst@linux.intel.com>
> To: "Maxime Ripard" <mripard@kernel.org>
> To: "Simona Vetter" <simona@ffwll.ch>
> To: "Thomas Zimmermann" <tzimmermann@suse.de>
> Cc: <linux-kernel@vger.kernel.org>
>
> ---
> v2:
> - Introduced drm_crtc_wait_one_vblank_internal() to allow waiting for vblank without warning on timeout.
> - Updated drm_client_modeset_wait_for_vblank() to use the new internal function, avoiding warnings during optional client update throttling.
> - Restored the warning in drm_crtc_wait_one_vblank() for other callers.
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
