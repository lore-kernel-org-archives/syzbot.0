Received: from mail-wr1-f50.google.com (mail-wr1-f50.google.com [209.85.221.50])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5D5E633A9E2
	for <syzbot@lists.linux.dev>; Wed, 12 Aug 2026 09:59:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.50
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786528786; cv=none; b=OzCZoTdLFp453jrGPkBGfmtbVmKPxKXP4I2fIBi2NQczUdlDMa2JctCE3yn6wrahvmSF+fwQta5ZlZk7KIBhwTced7gEpDQ5hWoWXMNa8kcjb5tyIGQRWlxpNrWsvnxP0dXYFpHEGJ25bC/37WdN0+8HTTxcOaNm43E68ELaVsk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786528786; c=relaxed/simple;
	bh=zNHAL9vkkD4rfWQICNBDhsARDY6cAEvivUXDAdctWq0=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=Tpj0eQA8mZ9w5iZgm0ZCejIgGLQBeG0eC6DhkHWXaHbhqSWQFRD43UAS113WAM56Jw8M6KFxTC+OFzZILoehWwYdy1q8KEgeioUJbO1a0UsT0o6iqBzv36/3W3hO//jgNrcuejqlZQO/qR4XafntwYSX/uhhK3yKYTkXF0WyKfw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=bfHCtaJM; arc=none smtp.client-ip=209.85.221.50
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="bfHCtaJM"
Received: by mail-wr1-f50.google.com with SMTP id ffacd0b85a97d-47f7854678cso501806f8f.1
        for <syzbot@lists.linux.dev>; Wed, 12 Aug 2026 02:59:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1786528783; x=1787133583; darn=lists.linux.dev;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=ulH/4qc+n73VHuKKL0fXHIlaS7i9e71LY1TmDgTqxwk=;
        b=bfHCtaJMeZa7aB+1IC+s7PByD9UbjFeWgBehEIWtTWA2+4IsdRwTNPmuJtLRjXxWHf
         lv7eK+X41fw5Dc2SWMlmzR2w0OWFbnBRq2d2wxlqPa9sZKaz5VDgHsJrme8DIvxHdSs/
         /003yAgJlMCXpcS3lbZiq9VcDVVsV/hMNpDVZ2JOzr4khcli3hQklgIEuFGVm+7t9pAo
         jbfbfkRJbaKEx3ZePFQ6aiLOEvqIoyeD71DcEz2Njo5oGIkc3yS6Vh+Ch5kQ9SnKd+qX
         XQrZLU1NG6fUNj6q3y0Xoa4pnhZsazlWBIWhhjh7C020w9VAYlSplkaJN8ap3/Q9GDz0
         +vXw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1786528783; x=1787133583;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=ulH/4qc+n73VHuKKL0fXHIlaS7i9e71LY1TmDgTqxwk=;
        b=m2B0gcG7Pytf98NOCLJmSYchiX8+5QLjeLTIpgAjHZ/zEwrCj0wjkNYrPBvqFeRy8/
         ruM2itPiwTHFpH7s24BT8ncKYeMS6qaxsraFcN71EA/lofhl3QDJ0yHoA/M+ZvBbEWV6
         yaeeC3VEh8FdZR6S8cH/imGVcBFIsarjYiFd77j016O+YYrt1Jld9CqBXlanUbrFpm+U
         GkXGb7ImKg8qGo8t+YcoKKM6q0bfTLvlqpNBfkVJuch307cqaNYvixSkxqzn+TUXtYa9
         LOLAXaqV/O9VdqBlkSY6zhD3F9wUxc7bl5L6E7obRt22KiwPMX0+g/BE2t6Xg5dBeP2J
         KRqw==
X-Gm-Message-State: AOJu0Yyz8sLquYtrZ8Ylt/Oua9zQNUDWlRvkqkz4CKxoRSi2CXWHDDo7
	Mcv9xsgpH4sHhbmtWR8c4+wD485MtJrKFSUKAb1EHpUHpx9rogeGbBUN76uAYVeMVgw=
X-Gm-Gg: AR+sD11TUA2VftIFMN5fyVGcWc7a+XWgCozUtwhrxali2EKCXhuA0ZHm0Vc0dg6LANV
	ekfEeDbUf1CUB4CyANIuxDEMXqvETSp7PP/KTlqD8J5VV4uelw2JEzRcD4fSqfWCdJueGzLN+4q
	cNXZhdMpGLkYLdB/N8BGQA6d5xlG0Xrh7yr+K+VncX79vMfKsEOYb9be/iQqNBO6CxcS3xn5+cV
	cfY1gGH/JhHSLOFKqLQTdGyBejdFvAZf6ZEOstz1QUG9bcuF9mkMLMcHXrJ4mvSJAlwtdPRZebb
	vA6myPL+vHtX2qwcMWzQvE5kL3n6esSPCMtFg/xyYGDVHmToGQ0Rt56Sh1ezOQEFpNxP+Pm/PhI
	tV2OpeM8QZItnfZDdDR4tirFrHUwx0fTyjIKCEb3A76pZCcl6X8AGlY6SjhvL5mpYAt77lo8zAo
	5+qctsISzNoSPCEnKaWhjs0GAiqBfck9y4q/+NQ8yU3AinBCsp0ypkvPxFWzProJ7svpJjR+ojL
	CPJkTHH5qt9KJLOPOG1KCyd2RfL4S9u6piOM6UbAOBBDkzIcIyE3yeG5sz4ta9nKIxs7rtrnsEu
	kwx7XY2YuKWx2KO3j+E73HtoSr743OcdWHyx3G5tPPAdRimQhP1piR4E0Y7PUmdslA==
X-Received: by 2002:a05:6000:4916:b0:481:4f9b:282b with SMTP id ffacd0b85a97d-48152cac88fmr5104783f8f.21.1786528781952;
        Wed, 12 Aug 2026 02:59:41 -0700 (PDT)
Received: from [192.168.100.51] (87-205-15-91.static.ip.netia.com.pl. [87.205.15.91])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-4815231c308sm5418436f8f.11.2026.08.12.02.59.41
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 12 Aug 2026 02:59:41 -0700 (PDT)
Message-ID: <76ece4d1-8502-4344-87c7-4299079fa6ba@gmail.com>
Date: Wed, 12 Aug 2026 11:59:40 +0200
Precedence: bulk
X-Mailing-List: syzbot@lists.linux.dev
List-Id: <syzbot.lists.linux.dev>
List-Subscribe: <mailto:syzbot+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:syzbot+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH RFC v6] drm/client: Avoid warning on vblank timeout during
 modeset client waits
To: syzbot <syzbot@kernel.org>, syzkaller-upstream-moderation@googlegroups.com
Cc: syzbot@lists.linux.dev
References: <b2ad033b-a674-49fe-825e-fb7555a327b5@mail.kernel.org>
Content-Language: en-US
From: Krystian Kaniewski <krystianmkaniewski@gmail.com>
In-Reply-To: <b2ad033b-a674-49fe-825e-fb7555a327b5@mail.kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

#syz upstream

On 8/11/2026 3:04 AM, syzbot wrote:
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
> Keeping the vblank reference acquisition (drm_vblank_get()) in the public
> wrapper drm_crtc_wait_one_vblank() rather than moving it to the internal
> helper prevents an enable_vblank() error from being mislabeled as a wait
> timeout.
>
> Fixes: d8c4bddcd8bc ("drm/fb-helper: Synchronize dirty worker with vblank")
> Assisted-by: Gemini:gemini-3.5-flash Gemini:gemini-3.1-pro-preview syzbot
> Reported-by: syzbot+f59157955aba9d0cb43b@syzkaller.appspotmail.com
> Closes: https://syzkaller.appspot.com/bug?extid=f59157955aba9d0cb43b
> Link: https://syzkaller.appspot.com/ai_job?id=f37d4830-e66f-4bce-be00-e7ac1d70c469
> To: "David Airlie" <airlied@gmail.com>
> To: <dri-devel@lists.freedesktop.org>
> To: "Maarten Lankhorst" <maarten.lankhorst@linux.intel.com>
> To: "Maxime Ripard" <mripard@kernel.org>
> To: "Simona Vetter" <simona@ffwll.ch>
> To: "Thomas Zimmermann" <tzimmermann@suse.de>
> Cc: <linux-kernel@vger.kernel.org>
>
> ---
> v6:
> - Convert drm_crtc_wait_one_vblank_internal() comment block to kernel-doc format
> - Remove the stack trace from the commit description
>
> v5:
> - Added a kernel-doc comment block for drm_crtc_wait_one_vblank_internal().
> https://lore.kernel.org/all/f9f73e7b-aefb-4240-ab24-020df624047a@mail.kernel.org/T/
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
> index f90fb2d13..9cac7013b 100644
> --- a/drivers/gpu/drm/drm_vblank.c
> +++ b/drivers/gpu/drm/drm_vblank.c
> @@ -1297,6 +1297,32 @@ void drm_crtc_vblank_put(struct drm_crtc *crtc)
>   }
>   EXPORT_SYMBOL(drm_crtc_vblank_put);
>   
> +/**
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
