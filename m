Received: from mail-ed1-f41.google.com (mail-ed1-f41.google.com [209.85.208.41])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D35D237F8DD
	for <syzbot@lists.linux.dev>; Mon, 10 Aug 2026 13:26:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.41
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786368368; cv=none; b=LvN+TFOyUO1uh6GyIKfpO5cmAO7Q3UEEXrWgOXNfIwvEXVpja2IlABwYH4/DcWDoKZlKSiyk8wHWPivX+qXdDtT9fSKYy+ywJcQ5alCMOEmngaEhDh7ifijOnFU0yMB4He3BgkxqBDw0Cj7RgiDdulTQr+iLRSNF6/1bWBPI7mE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786368368; c=relaxed/simple;
	bh=HZOYizJ3vfOzVjAxasxwoP9SAB5TDMPbRclHYzC+FwU=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=WhHto2AsHOnPFRHrN2ZlwAuuHueTZp115uQX2DQgbww+nxoKpLeXDmEBo+fhHt2K1up/2eNLEpL8mD4JjH6f36ovAE/dH2kmQzlV3tjnMD0xx2fZ0Y/7phGkpTd5RtKvzv+JbCzOhmNsXFvlIgqGyHim0xthVIKBQK4KDYLORn4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=jSXJ4NoX; arc=none smtp.client-ip=209.85.208.41
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="jSXJ4NoX"
Received: by mail-ed1-f41.google.com with SMTP id 4fb4d7f45d1cf-6a0a4a18180so2798422a12.0
        for <syzbot@lists.linux.dev>; Mon, 10 Aug 2026 06:26:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1786368365; x=1786973165; darn=lists.linux.dev;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=39LD/DXBNV4v+rWX+oEKhY9Vd2coYVKTYXtHbnirCI0=;
        b=jSXJ4NoXdOOkDRl9pWKSVGw/HHdyEHNFy58znGb6AUO+iiwU0x1PjTUmDqJR+0mXf4
         3udxQVTSg5QM3FUjQSSiWmPFp2KzhAQ0v/Cr8H5cCtWrlAEV2c0+4K1QZhO2yfU/nhiz
         CZ6wJg7+2ybL7nGwVTrxWHedjQ6xanQ23CfaGpf+1EOvlBpp068v95iagawdPbsff7/s
         LVDdDAL9xEwtpLTQwEfUcW7b7WB1hRky7Aow6lhMXtRibC8jXeHD35eQm68pTtbH2IKd
         V9FzqDcnmFzWACrZOY1GW2fWimJWI+MrFtlHlKiq+CqIjK+V0pTXjt8oFMRUDZ3IGhni
         IAeg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1786368365; x=1786973165;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=39LD/DXBNV4v+rWX+oEKhY9Vd2coYVKTYXtHbnirCI0=;
        b=kBUvjlmld5t63YHyqtJSlkz9hORQlGXoTs60EbOjysozB8XORp+KNnmEV/JnKpHbiX
         vM8IK1P386aMJdaFIU334/wmllBBl5f0iNn/2BP6rGxNGEB9OA1NwtQbqnZ49Ysc7ZQ/
         0KgFQmiPYCWYiA0DSgbGOC4Y04twJK4pIq+dsCzHfWai9wuV+4TL9PtMlOGJqA9MzbYY
         hg2IjHDpJSHWmYkViu7vj5tQO6H8PEvcmyJUkx0bmEVkmCPsrwq9gfJHZVg49CkLzyp4
         f4uXfo/EUornFD6A/CRRTIOOAxw6OJUJrb7tYbGhJhXKwofpspQcZocc6wbqdKNF3R9Y
         hcsw==
X-Gm-Message-State: AOJu0YwalnNd7sv6VEm9W+ZVX7znRBU9LoVFQz9rsvidjD8k0IZ3gt+9
	KSaHN4qdFBOdTnUGrAdXz7llFeC4r/rtjYF4i7/D+t0wSqniytP+kd79Xv4sE1qY
X-Gm-Gg: AR+sD13/ew7v4X0R7zsLHr5jMEzEkXS+t5QvJmzDJrT4ZIAutYGD0tT9knP5k5oSNJp
	uIQlXuKXABuPeSTtxIXD9GCfk9vgZ3oB2DmOhuliOcT6CK/Y10hETCQsYZQ18DPSUkKb2lrUuS3
	wm8OKjV5DG8OV5so9NnOmgx16hRj+XjkF9fvG3Q/TEO3Y3S3ao+gBaMptJo9xozpWuo/e5OnPVk
	tecbV46B6mwAHWV8COWDBgAB5LOdg4KJGsAfsCc9wK3Sus8SS1I+Eeq7watSFOLE/eQPv9+oD0L
	E1rBrOoypdPwfSOhM2bid/vECzsgRmdA5+Qdzf7DTsDVUAAUujtxalAFCjCSS0p/o7rtdwwIVsc
	1uqSH/CC2hGulqE8zA83OddUn2hzZ+kgaXxwTtorOgTlsqswp6Tr0rZr6Ni/09e84QHd/j5Fia2
	8O6GZv2ZcifbFwRt1bzJBF4Th7E742tYVcKWTAD0/7BZQy3Ln/3OaafdG1KHCgvV33LknhvzeJD
	wNkw8Y1wXENUTudeHLHhMjWuQHyTqIaSgNqK/VRtzOFxQIdHYjTJuSP5WjdqXFv4iEyNrsZfE8Q
	ceffjAgueLxRO04Gma7nAPr29/3AJjywQkvmyXchSnEOpJmPCe/QGHc=
X-Received: by 2002:a05:6402:1f85:b0:698:5610:76e5 with SMTP id 4fb4d7f45d1cf-6a1e5ac27b2mr12046699a12.6.1786368364837;
        Mon, 10 Aug 2026 06:26:04 -0700 (PDT)
Received: from [192.168.100.51] (87-205-15-91.static.ip.netia.com.pl. [87.205.15.91])
        by smtp.gmail.com with ESMTPSA id 4fb4d7f45d1cf-6a1f750d833sm3165104a12.6.2026.08.10.06.26.03
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 10 Aug 2026 06:26:04 -0700 (PDT)
Message-ID: <3d830ed2-bc23-4b50-9b05-ae8431b4bcdb@gmail.com>
Date: Mon, 10 Aug 2026 15:26:03 +0200
Precedence: bulk
X-Mailing-List: syzbot@lists.linux.dev
List-Id: <syzbot.lists.linux.dev>
List-Subscribe: <mailto:syzbot+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:syzbot+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH RFC v5] drm/client: Avoid warning on vblank timeout during
 modeset client waits
To: syzbot <syzbot@kernel.org>, syzkaller-upstream-moderation@googlegroups.com
Cc: syzbot@lists.linux.dev
References: <f9f73e7b-aefb-4240-ab24-020df624047a@mail.kernel.org>
Content-Language: en-US
From: Krystian Kaniewski <krystianmkaniewski@gmail.com>
In-Reply-To: <f9f73e7b-aefb-4240-ab24-020df624047a@mail.kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

Remove the remaining synthetic stack trace from the commit description. The
line numbers, offsets, and later symbol names in that excerpt do not 
come from
the original report. Keep the concise verified explanation of PREEMPT_RT
timer-thread starvation, best-effort client pacing, and acquisition-error
provenance.

Change the new function comment opener from `/*` to `/**` so the block is
actual kernel-doc as claimed by the changelog. Preserve the caller-held 
vblank
reference requirement documented in that block.

Preserve the current code behavior. The public helper must acquire the
reference, report acquisition failure, return before timeout handling on 
that
failure, warn only after an actual counter-wait timeout, and warn before
dropping the reference. The client helper must use its existing outer 
get and
put while treating timeout as quiet best-effort pacing. Leave the atomic
helper, timeout, predicate, public API, and exported symbols unchanged. 
Retain
all existing attribution, report links, and the recipient set.

On 8/7/2026 3:58 PM, syzbot wrote:
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
> WARNING: drivers/gpu/drm/drm_vblank.c:1329 at
> drm_crtc_wait_one_vblank+0x3bc/0x560
> Workqueue: events drm_fb_helper_damage_work
> RIP: 0010:drm_crtc_wait_one_vblank+0x51a/0x560
> Call Trace:
>   <TASK>
>   drm_client_modeset_wait_for_vblank+0xc5/0xf0
>   drm_fb_helper_fb_dirty [inline]
>   drm_fb_helper_damage_work+0x6cf/0xf00
>   process_one_work kernel/workqueue.c:3322 [inline]
>   process_scheduled_works+0xa8e/0x14e0
>   worker_thread+0x92d/0xe10
>   kthread+0x388/0x470
>   ret_from_fork+0x514/0xb70
>   ret_from_fork_asm+0x1a/0x30
>   </TASK>
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
> Link: https://syzkaller.appspot.com/ai_job?id=99547107-9c8e-4e10-8b8a-950541b8fc0d
> To: "David Airlie" <airlied@gmail.com>
> To: <dri-devel@lists.freedesktop.org>
> To: "Maarten Lankhorst" <maarten.lankhorst@linux.intel.com>
> To: "Maxime Ripard" <mripard@kernel.org>
> To: "Simona Vetter" <simona@ffwll.ch>
> To: "Thomas Zimmermann" <tzimmermann@suse.de>
> Cc: <linux-kernel@vger.kernel.org>
>
> ---
> v5:
> - Added a kernel-doc comment block for drm_crtc_wait_one_vblank_internal().
>
> v4:
> - Keep vblank reference acquisition in the public drm_crtc_wait_one_vblank() wrapper instead of moving it to drm_crtc_wait_one_vblank_internal().
> - Update the commit description to explain how this prevents enable_vblank() errors from being mislabeled as wait timeouts.
> https://lore.kernel.org/all/d0de0809-9381-4925-b5d6-2499dab9e3ce@mail.kernel.org/T/
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
> index f90fb2d13..e2bf5ed65 100644
> --- a/drivers/gpu/drm/drm_vblank.c
> +++ b/drivers/gpu/drm/drm_vblank.c
> @@ -1297,6 +1297,32 @@ void drm_crtc_vblank_put(struct drm_crtc *crtc)
>   }
>   EXPORT_SYMBOL(drm_crtc_vblank_put);
>   
> +/*
> + * drm_crtc_wait_one_vblank_internal - wait for one vblank
> + * @crtc: DRM crtc
> + *
> + * This waits for one vblank to pass on @crtc, using the irq driver interfaces.
> + * Every caller must hold a vblank reference across the complete wait.
> + *
> + * Returns: 0 on success, negative error on failures.
> + */
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
> @@ -1311,26 +1337,20 @@ int drm_crtc_wait_one_vblank(struct drm_crtc *crtc)
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
