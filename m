Received: from mail-ej1-f46.google.com (mail-ej1-f46.google.com [209.85.218.46])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D28AF381EBA
	for <syzbot@lists.linux.dev>; Thu,  6 Aug 2026 07:48:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.46
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786002518; cv=none; b=AHbDMrVDTQAtInCHWJyC20hBfeZj1fJYR9u7jNch9FTlVfh8MUOpS28TwJBAt8Ouq2NdnhvT/Le45r3ytiGa2sisSZoSBgz3Jpdfx4aFFD62aFr4aeXYt4aU3WDsLquJgVdo//0uDs0U2z+QfmfteGHvdMaCQbcYLJTnL4pc598=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786002518; c=relaxed/simple;
	bh=M/TF6QdRZdrMHh0XWw1tNlNquO1Krg8uiZCuXtiwgl0=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=tJNeFyl7TdCicQLqSClx0QTnTWUd+iQGSGhqFYh8I4Zx1s+0OLOdwZJ/lD/vqnZB7My9EVIdto6ZHDKzVJqEEMtYTe/T08dxkm1tokRbhop6K453AyowOsYEWmb/1u4fMONW+jN+AcV3DXBQR5ySMb5xUc9ybGDZSE/y9tYxgWo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=jw3rBOGQ; arc=none smtp.client-ip=209.85.218.46
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="jw3rBOGQ"
Received: by mail-ej1-f46.google.com with SMTP id a640c23a62f3a-c1c50c1e29bso272712666b.3
        for <syzbot@lists.linux.dev>; Thu, 06 Aug 2026 00:48:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1786002515; x=1786607315; darn=lists.linux.dev;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=XJMK4Igccl9LKOMVyafqE0KQaEPRXUy3Ffm7/dv7M7w=;
        b=jw3rBOGQi8H0DgNkMTKNgu4WRowsV3JLer/bwYFTOWxQdN3xZJX7/SG6qtaHckcZIc
         ZMfP9tRw0wQzPdrkH6pCAni22KOx5OYwdKu/wSDatoMjcWKVuljyPiFuDJ7YpduwqMrX
         3/u0p4SEApxwDhYZDDEIw22HRedRuO4oqBqxUR83UdNEXV1p0n7EM7h+4oaDkkExOmoP
         UIN98B91Ca2gIEuL01uRVkgMRLoklkxyT7zV7dAucYz+ZhqHa2YkF7bku1Evp+kFlQm4
         zJJ1T5RcSTr2EhLmcWCOfio20Sj/OKUHeTRhupz39e+9BqtPJtH+31elJ2NCSJxNqHWJ
         hgvg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1786002515; x=1786607315;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=XJMK4Igccl9LKOMVyafqE0KQaEPRXUy3Ffm7/dv7M7w=;
        b=ZndjdlEJrSrH6/dC4wIeQ+2ekIIQfZy/WdqtUTVI4SqDpR2Vh2aQyFvpfd8fl/0KlY
         eSSDQel5oKQ4GarFnVDXkaR4+ARmGLC4Q1UI9lsNqpweg3IcMITUhbMe28HVnT4GcKU+
         u+4/kZe/9JWit8WTHNePi2fxLsTG7vdMZw6P4DjPkptVk0jtmpwjGGtH7HNeTe69v7YC
         uBmNDH+DgMLIEzeE6pvSXUfVc8T2ITwSbXz0Odi2Wi8+gNA72BNOXJVVqx9h54Ix3zmL
         5I97sksLxXZRqnq2WksIg65T/JadKdwl6g7MB1A3e4fmZW8pMxbZS5affA4nbcWb/xxu
         44/g==
X-Gm-Message-State: AOJu0YwIx4KLqU30PpyBjhYRmrCk75piyOALXRvGRBeO1T4bD40q5Pcu
	cwz9zRol9K/1W5Gs6acPpNu2Vcmb4FSydx+4mPQkEZxc4jYRLJXDo9O8
X-Gm-Gg: AR+sD11/OdELvN6SQTlkIIcQGJPyiSn2pGnHoGVqsnrJBDHZgDznopZsozlFRUF6b2o
	siQMWdPjd6mfJEHXuO9Uph/Z+sJYAKdIo5CRedDJlMkJCSCG94qLgkWaXVn0bfETBWIAnLhdC0i
	HqGQE5pGQW8PGtNYPKcDX0oTJLQjsKLV2JgY4MnZcBlpI2AOW1YSbIRQKkQkfzIzZR4HxRYrL7q
	axqxkDggLg1kmw/3g+knB4rKEaTImHoTptLHyZsn+qLsoLYgy9LfPxrh6Ut5fSVZU4Hg2U3ttAn
	QR9JvSMMhAiRh+SJKsQDEo37hb4FeJLxONM24bj4nOXo8Nl3tIEW10pryigp0leGUiuedb25boT
	S9yj1cVyFbcQwu5uQsboO6FUrElerj+YQl6OFAqRB+IlfdACmyhc+4E54qIXKIwjBLvCxQnZK/H
	NfteQvU4RZgz7A+IUvIBem5tpVi2CIi5WtJvCa2QYpENQWtmMiK/TzGcIWabAfjCThAF+ug/7+p
	RmcqnW+nniWPQ4AFe2JaeySW06yENYPhyhwrZgfQ75EA4loeIj68cmYHmga+JfO9mUhzGiP8PkC
	bjtf2buM8VUImlRBFawZO2B+/aiPIr/Giyd9n7y9fYfq10Hu5xdlXo0=
X-Received: by 2002:a17:907:d515:b0:c15:dcc6:d06d with SMTP id a640c23a62f3a-c20397cd2aamr596120966b.0.1786002514614;
        Thu, 06 Aug 2026 00:48:34 -0700 (PDT)
Received: from [192.168.100.51] (87-205-15-91.static.ip.netia.com.pl. [87.205.15.91])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-c203642435dsm217036966b.44.2026.08.06.00.48.34
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 06 Aug 2026 00:48:34 -0700 (PDT)
Message-ID: <d7491322-e1c0-4592-af9a-106b28c9ad00@gmail.com>
Date: Thu, 6 Aug 2026 09:48:33 +0200
Precedence: bulk
X-Mailing-List: syzbot@lists.linux.dev
List-Id: <syzbot.lists.linux.dev>
List-Subscribe: <mailto:syzbot+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:syzbot+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH RFC] drm/vblank: Replace WARN with drm_err for vblank wait
 timeouts
To: syzbot <syzbot@kernel.org>, syzkaller-upstream-moderation@googlegroups.com
Cc: syzbot@lists.linux.dev
References: <7527aaed-dcb2-4bde-a807-1677dcd0af99@mail.kernel.org>
Content-Language: en-US
From: Krystian Kaniewski <krystianmkaniewski@gmail.com>
In-Reply-To: <7527aaed-dcb2-4bde-a807-1677dcd0af99@mail.kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

Revise the patch so that it suppresses the vblank warning only for the 
best-effort DRM client/fbdev throttling path reached through 
drm_client_modeset_wait_for_vblank(). Keep the WARN behavior of the 
exported drm_crtc_wait_one_vblank() helper and leave 
drm_atomic_helper_wait_for_vblanks() unchanged, because those 
driver-facing paths can diagnose genuine vblank failures and the atomic 
helper is not in the reported stack.

Implement the narrow behavior through a DRM-internal, non-exported 
warning-free entry point backed by the same wait implementation as 
drm_crtc_wait_one_vblank(). The public helper must retain its existing 
warnings. Preserve the one-second timeout, wait predicate, vblank 
reference balance, exported ABI, public helper return values, and 
drm_client_modeset_wait_for_vblank() semantics: -EBUSY only when an 
external DRM master prevents the wait and zero otherwise. Do not add 
unrelated enabled-state checks, locking changes, CRTC-index validation, 
timer-priority changes, public headers, or atomic-helper changes.

Use `Fixes: d8c4bddcd8bc ("drm/fb-helper: Synchronize dirty worker with 
vblank")`. Explain that PREEMPT_RT can delay VKMS software vblank 
delivery beyond the timeout, and that this is acceptable only for 
optional client update throttling.

On 8/2/2026 11:09 PM, syzbot wrote:
> On PREEMPT_RT kernels, a user-space task with elevated Real-Time (RT)
> priority can starve essential kernel threads. For example, the VKMS driver
> simulates vblank interrupts using hrtimers. On PREEMPT_RT, these timers run
> in the per-CPU timer threads at a low RT priority. If a user-space task
> elevates its priority above the timer thread and monopolizes the CPU, the
> timer thread is starved and the vblank hrtimer never fires.
>
> This leads to a timeout when a worker thread waits for the vblank event.
> For instance, a console update triggers a framebuffer update, scheduling
> drm_fb_helper_damage_work() on the system workqueue. The worker thread
> eventually calls drm_crtc_wait_one_vblank() to synchronize the screen
> update with the vblank interval. Due to the starved timer, the wait times
> out and triggers a drm_WARN. A similar issue exists in
> drm_atomic_helper_wait_for_vblanks() where a WARN is triggered upon
> timeout.
>
> WARN macros must not be used for conditions that can legitimately happen,
> and pr_err or drm_err should be used instead if necessary. Since this
> timeout is an expected consequence of RT scheduling starvation rather than
> a kernel bug, replace the warnings with drm_err(). This ensures the timeout
> is still logged for diagnostic purposes without triggering an unnecessary
> backtrace.
>
> Fixes: 74afeb812850 ("drm/vblank: Add vblank timer")
> Assisted-by: Gemini:gemini-3.5-flash Gemini:gemini-3.1-pro-preview syzbot
> Reported-by: syzbot+f59157955aba9d0cb43b@syzkaller.appspotmail.com
> Closes: https://syzkaller.appspot.com/bug?extid=f59157955aba9d0cb43b
> Link: https://syzkaller.appspot.com/ai_job?id=396433fb-a59e-4936-97d4-4d2e7ced2ee9
> To: "David Airlie" <airlied@gmail.com>
> To: <dri-devel@lists.freedesktop.org>
> To: "Maarten Lankhorst" <maarten.lankhorst@linux.intel.com>
> To: "Maxime Ripard" <mripard@kernel.org>
> To: "Simona Vetter" <simona@ffwll.ch>
> To: "Thomas Zimmermann" <tzimmermann@suse.de>
> Cc: <linux-kernel@vger.kernel.org>
>
> ---
> diff --git a/drivers/gpu/drm/drm_atomic_helper.c b/drivers/gpu/drm/drm_atomic_helper.c
> index 51f39edc3..0266beff9 100644
> --- a/drivers/gpu/drm/drm_atomic_helper.c
> +++ b/drivers/gpu/drm/drm_atomic_helper.c
> @@ -1918,8 +1918,9 @@ drm_atomic_helper_wait_for_vblanks(struct drm_device *dev,
>   						drm_crtc_vblank_count(crtc),
>   					 msecs_to_jiffies(1000));
>   
> -		WARN(!ret, "[CRTC:%d:%s] vblank wait timed out\n",
> -		     crtc->base.id, crtc->name);
> +		if (!ret)
> +			drm_err(dev, "[CRTC:%d:%s] vblank wait timed out\n",
> +				crtc->base.id, crtc->name);
>   
>   		drm_crtc_vblank_put(crtc);
>   	}
> diff --git a/drivers/gpu/drm/drm_vblank.c b/drivers/gpu/drm/drm_vblank.c
> index f90fb2d13..7f7f4dd35 100644
> --- a/drivers/gpu/drm/drm_vblank.c
> +++ b/drivers/gpu/drm/drm_vblank.c
> @@ -1326,7 +1326,8 @@ int drm_crtc_wait_one_vblank(struct drm_crtc *crtc)
>   				 last != drm_vblank_count(dev, pipe),
>   				 msecs_to_jiffies(1000));
>   
> -	drm_WARN(dev, ret == 0, "vblank wait timed out on crtc %i\n", pipe);
> +	if (ret == 0)
> +		drm_err(dev, "vblank wait timed out on crtc %i\n", pipe);
>   
>   	drm_vblank_put(dev, pipe);
>   
>
>
> base-commit: f5098b6bae761e346ebcd9da7f95622c04733cff
