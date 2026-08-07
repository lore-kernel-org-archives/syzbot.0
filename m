Received: from mail-ed1-f53.google.com (mail-ed1-f53.google.com [209.85.208.53])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7AB1C39EF25
	for <syzbot@lists.linux.dev>; Fri,  7 Aug 2026 13:08:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.53
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786108142; cv=none; b=oSKYOwZ2kZ3dLAufeefO+VSJC4aWSotjhAB3BTmtXrgRpSQRHZtRxDQdpzKCfPYK73i5tqC5mjFP7bC0FG+m16CAWQLTOknJZhtG1Zz7cmGlmHqnCMbEgAgBzioV9V8qeQaK9Lc8I/I2wpwMjrVuAD1omlW2hfa87McnfppgS2Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786108142; c=relaxed/simple;
	bh=KaDgs43eWEnsW2N7pAlu17TvBa83/W5QQ/mbLrbjU4Q=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=gbScyBxI0pqnNH0LKTYJNF14KxHHr5YT3CSSVSnZow6KD6FdlvA/RvtkFnbR7W10O2pZIlE23AKSclZPl5NtzKWMFwErkmudR0FJuTh3bjf3skEYdoy4+YNuKnZmbm3OX3Y/NX2eF5TaVQWFU+NLRnOwTRRYA9jM90q4WRTKU5Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=D2Te4CWP; arc=none smtp.client-ip=209.85.208.53
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="D2Te4CWP"
Received: by mail-ed1-f53.google.com with SMTP id 4fb4d7f45d1cf-6a097f5ab95so5309110a12.2
        for <syzbot@lists.linux.dev>; Fri, 07 Aug 2026 06:08:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1786108134; x=1786712934; darn=lists.linux.dev;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=hx05bVEo7B6VZOwu/gTD2X5od9QQVtH7XKZQ7gO14aM=;
        b=D2Te4CWPJu2lrT3uq/n/5NRk5RBJWw2yrj9z3RK2KLcpvldQIvbe3SM/+bHRMU7AAy
         7cGiBBxa+VvZ76SU/qkWYL9itifO53S47bq02FfajcZQk5tHZwiXHOtU1J9GZN9wPAub
         KvJbqaEJWCFthZem3Jd7nlrmmD1W7sa6UYh1bbIDTJmRNYSeN1ulwiAMxv1j/x4bujPV
         fGXwKROcDb+aroFvHylOvYphX/5K/oOI2uLaHIWHaXJs6E5y5NkkUPcDCFEQ/VVfXRvO
         keWNRfefsx2/wphOXhOdju9Y3PyaF6K0Xo7d3aO60TO2U7fqBhkSpCb+goei5rTDV6fi
         GSKA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1786108134; x=1786712934;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=hx05bVEo7B6VZOwu/gTD2X5od9QQVtH7XKZQ7gO14aM=;
        b=VI4+apphxc9RWGILZwTS+v05Rb/AOrJKgtrN2JyvSoLdA9LR+kszl2qYzlBwDGWXFI
         7B2qJ4o79aad3MTgeOrekAGwPP1JBOXZ+YUryrSWnQ4ak2X4KJ5j3b1Sk1TIxUiQOBgF
         yZUZcGbYV94GeHHf7PCdbKrDczdWpYSQYG3y3cQMOd/UqdqTKzs9Yr0DTSd9o79dkMva
         bd7Y4K3SjZZNMVfJneS0GDKJClQt5QSCQDBNk/1PTqLE3CYEqOHxOjMSPaOvuQ5/VLQs
         QijjGlDPuVWxyDm38kWLnM+NXFjoGpMQtBZnk9DiP3Smnt9FUbMV0xmV3XHKPUUC9uV2
         GEEA==
X-Gm-Message-State: AOJu0YwPN5CPaYszIcpUJ87WcQZHhaNq4P0CTKRE3VPOT2FU3EBkHAiT
	1GkH8G6DxQhMLshmrfcOICuJorC66RwZtApmeEIlUJ9Jp66CXkNq/dvG4Mx8DVbP
X-Gm-Gg: AR+sD12FZVRwYSHZ8SizlZ1cTmWswhLMVrG40c6M982asZ4uQP0lki/OP1Wo9HJv4wr
	cAR4WI/IldzDbP5dxR6PkbsqPOe+/f/74wQmr//W9ogiDU5BY/FbWvgo3cr0dJpP2s/b95ixlSJ
	6HmZIemr/2DSGqz9+KaVXoBThUa4w19wAWfOdbnBozL7VgVn/y6MuWAxsL0QKFa/XnkA0jZekjB
	CTxFNvi2MaWuaFFrwiC7nvHvK41cCh381mH0Kx5XyuJlNCViRxQfqAlFDLhf6xsQwo3NwlXAe3h
	s+JQ8gXzWWFdOCuYdPXsrFMIRzmLmcWvjgDKX+ixev67s1Ea7vjdTlA3YTLsMXh6C4YkMpKcye1
	t886lp4j0QtXEIADwk/dIKbkj//T3R809yu6fxR3Qj1i/urb0FXvqPFAiLLVFNtEuUgZZE7Dn8I
	hlrQm/+Al7CbiuZWXVgcjSivNu901xa65RAQQsFit5ebTp5FShz76+d3alA1WRhqmdjfqjF+BqQ
	YYH0HbDjVzihnY3dE26G8MkhWzVsQObHKuIY/gVB98FkkFR59jDAnlfka//AGQ0hzulooFz+9bw
	O/xv4oVdW9vsYmoxwxzp/60XaDKLSgE3Cq6zlVxUsCyZjFRZJTF80Xj5c7UqB3u3bQ==
X-Received: by 2002:a17:907:1c18:b0:c1c:67c3:7371 with SMTP id a640c23a62f3a-c207eb9dfd3mr233419466b.8.1786108133889;
        Fri, 07 Aug 2026 06:08:53 -0700 (PDT)
Received: from [192.168.100.51] (87-205-15-91.static.ip.netia.com.pl. [87.205.15.91])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-c2080c9047esm49953966b.33.2026.08.07.06.08.53
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 07 Aug 2026 06:08:53 -0700 (PDT)
Message-ID: <a29e64ad-2f97-46dd-9a31-9572e8f6f01d@gmail.com>
Date: Fri, 7 Aug 2026 15:08:52 +0200
Precedence: bulk
X-Mailing-List: syzbot@lists.linux.dev
List-Id: <syzbot.lists.linux.dev>
List-Subscribe: <mailto:syzbot+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:syzbot+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH RFC v4] drm/client: Avoid warning on vblank timeout during
 modeset client waits
To: syzbot <syzbot@kernel.org>, syzkaller-upstream-moderation@googlegroups.com
Cc: syzbot@lists.linux.dev
References: <d0de0809-9381-4925-b5d6-2499dab9e3ce@mail.kernel.org>
Content-Language: en-US
From: Krystian Kaniewski <krystianmkaniewski@gmail.com>
In-Reply-To: <d0de0809-9381-4925-b5d6-2499dab9e3ce@mail.kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

Please make two focused corrections.

Remove the synthetic full warning trace with placeholder timestamps from the
commit description. Keep a concise explanation based on the verified report,
including why PREEMPT_RT scheduling can delay VKMS vblank delivery and 
why the
client wait is best effort.

Document next to drm_crtc_wait_one_vblank_internal() that every caller 
must hold
a vblank reference across the complete wait.

Preserve the current behavior. The public helper must acquire the reference,
report an acquisition failure, return before timeout handling on that 
failure,
warn only after an actual counter-wait timeout, and warn before dropping the
reference. The client helper must use its existing outer get and put while
treating timeout as quiet best-effort pacing. Leave the atomic helper, 
timeout,
predicate, public API, and exported symbols unchanged. Retain all existing
attribution, report links, and the recipient set.

On 8/7/2026 12:30 PM, syzbot wrote:
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
> [   12.345678] faux_driver vkms: [drm] vblank wait timed out on crtc 0
> [   12.345679] WARNING: drivers/gpu/drm/drm_vblank.c:1329 at
> drm_crtc_wait_one_vblank+0x3bc/0x560
> [   12.345680] CPU: 0 UID: 0 PID: 9 Comm: kworker/0:0 Not tainted
> [   12.345681] Workqueue: events drm_fb_helper_damage_work
> [   12.345682] RIP: 0010:drm_crtc_wait_one_vblank+0x51a/0x560
> [   12.345683] Call Trace:
> [   12.345684]  <TASK>
> [   12.345685]  drm_client_modeset_wait_for_vblank+0xc5/0xf0
> [   12.345686]  drm_fb_helper_fb_dirty [inline]
> [   12.345687]  drm_fb_helper_damage_work+0x6cf/0xf00
> [   12.345688]  process_one_work kernel/workqueue.c:3322 [inline]
> [   12.345689]  process_scheduled_works+0xa8e/0x14e0
> [   12.345690]  worker_thread+0x92d/0xe10
> [   12.345691]  kthread+0x388/0x470
> [   12.345692]  ret_from_fork+0x514/0xb70
> [   12.345693]  ret_from_fork_asm+0x1a/0x30
> [   12.345694]  </TASK>
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
> Keeping the vblank reference acquisition (drm_vblank_get()) in the public
> wrapper drm_crtc_wait_one_vblank() rather than moving it to the internal
> helper prevents an enable_vblank() error from being mislabeled as a wait
> timeout.
>
> Fixes: d8c4bddcd8bc ("drm/fb-helper: Synchronize dirty worker with vblank")
> Assisted-by: Gemini:gemini-3.5-flash Gemini:gemini-3.1-pro-preview syzbot
> Reported-by: syzbot+f59157955aba9d0cb43b@syzkaller.appspotmail.com
> Closes: https://syzkaller.appspot.com/bug?extid=f59157955aba9d0cb43b
> Link: https://syzkaller.appspot.com/ai_job?id=be2179ac-d334-4861-a28c-7b1d32526126
> To: "David Airlie" <airlied@gmail.com>
> To: <dri-devel@lists.freedesktop.org>
> To: "Maarten Lankhorst" <maarten.lankhorst@linux.intel.com>
> To: "Maxime Ripard" <mripard@kernel.org>
> To: "Simona Vetter" <simona@ffwll.ch>
> To: "Thomas Zimmermann" <tzimmermann@suse.de>
> Cc: <linux-kernel@vger.kernel.org>
>
> ---
> v4:
> - Keep vblank reference acquisition in the public drm_crtc_wait_one_vblank() wrapper instead of moving it to drm_crtc_wait_one_vblank_internal().
> - Update the commit description to explain how this prevents enable_vblank() errors from being mislabeled as wait timeouts.
>
> v3:
> - Removed the raw kernel cut marker and full warning trace from the commit description.
> - Replaced first-person phrasing with impersonal wording in the commit description.
> https://lore.kernel.org/all/0bbd5c22-3a1c-4e66-9d45-932bb858d0af@mail.kernel.org/T/
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
> index f90fb2d13..923e20053 100644
> --- a/drivers/gpu/drm/drm_vblank.c
> +++ b/drivers/gpu/drm/drm_vblank.c
> @@ -1297,6 +1297,23 @@ void drm_crtc_vblank_put(struct drm_crtc *crtc)
>   }
>   EXPORT_SYMBOL(drm_crtc_vblank_put);
>   
> +int drm_crtc_wait_one_vblank_internal(struct drm_crtc *crtc)
> +{
> +	struct drm_device *dev = crtc->dev;
> +	int pipe = drm_crtc_index(crtc);
> +	struct drm_vblank_crtc *vblank = drm_crtc_vblank_crtc(crtc);
> +	int ret;
> +	u64 last;
> +
> +	last = drm_vblank_count(dev, pipe);
> +
> +	ret = wait_event_timeout(vblank->queue,
> +				 last != drm_vblank_count(dev, pipe),
> +				 msecs_to_jiffies(1000));
> +
> +	return ret ? 0 : -ETIMEDOUT;
> +}
> +
>   /**
>    * drm_crtc_wait_one_vblank - wait for one vblank
>    * @crtc: DRM crtc
> @@ -1311,26 +1328,20 @@ int drm_crtc_wait_one_vblank(struct drm_crtc *crtc)
>   {
>   	struct drm_device *dev = crtc->dev;
>   	int pipe = drm_crtc_index(crtc);
> -	struct drm_vblank_crtc *vblank = drm_crtc_vblank_crtc(crtc);
>   	int ret;
> -	u64 last;
>   
>   	ret = drm_vblank_get(dev, pipe);
>   	if (drm_WARN(dev, ret, "vblank not available on crtc %i, ret=%i\n",
>   		     pipe, ret))
>   		return ret;
>   
> -	last = drm_vblank_count(dev, pipe);
> -
> -	ret = wait_event_timeout(vblank->queue,
> -				 last != drm_vblank_count(dev, pipe),
> -				 msecs_to_jiffies(1000));
> +	ret = drm_crtc_wait_one_vblank_internal(crtc);
>   
> -	drm_WARN(dev, ret == 0, "vblank wait timed out on crtc %i\n", pipe);
> +	drm_WARN(dev, ret == -ETIMEDOUT, "vblank wait timed out on crtc %i\n", pipe);
>   
>   	drm_vblank_put(dev, pipe);
>   
> -	return ret ? 0 : -ETIMEDOUT;
> +	return ret;
>   }
>   EXPORT_SYMBOL(drm_crtc_wait_one_vblank);
>   
>
>
> base-commit: f5098b6bae761e346ebcd9da7f95622c04733cff
