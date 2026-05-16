Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5B79D2F7EF7
	for <syzbot@lists.linux.dev>; Sat, 16 May 2026 09:17:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=10.30.226.201
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778923067; cv=pass; b=VV3+2gdwMACXL/rwiHaaVEWl12FaO+d0XKnm66iZ38mp6Ksr4XY9EK7yrFViUVtVzT52Yo6DCIv0arK4/Ipjx3hDyH/10znAqu7TohBT7eofoRCdgTVwU64NBl7GZKF9+LyxcP+MTIIMiMOe1Z2K4lJuBog3HpyhEovVA8du3Sc=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778923067; c=relaxed/simple;
	bh=N5UCEk7Kcn1fvkX5Ux7Pr8yJPSIOxqoV8Zkrh/yvw9U=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=TiWiLCRYDvvCVzlggU+1uOHkM8g9fxMoSJonz0ux3X8mLrsPklGfm1ArFMIOpMWvvRLRE4GINr4jqjOak8n9IExSTx3d30FM8gtjtYPWY7piR278NmSkWSscEnAjlC/2mfHtp9gKbNYBnLD7QE0SLmYQF9RAtk7GgaASRh87wIg=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=fhJUOPBQ; arc=pass smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="fhJUOPBQ"
Received: by smtp.kernel.org (Postfix)
	id 28FD0C2BCB7; Sat, 16 May 2026 09:17:47 +0000 (UTC)
Received: from mail-lj1-f176.google.com (mail-lj1-f176.google.com [209.85.208.176])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp.kernel.org (Postfix) with ESMTPS id 3FD47C19425
	for <syzbot@kernel.org>; Sat, 16 May 2026 09:17:46 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 smtp.kernel.org 3FD47C19425
Authentication-Results: smtp.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.kernel.org; spf=pass smtp.mailfrom=google.com
Received: by mail-lj1-f176.google.com with SMTP id 38308e7fff4ca-3938cc204a7so6486421fa.1
        for <syzbot@kernel.org>; Sat, 16 May 2026 02:17:45 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1778923064; cv=none;
        d=google.com; s=arc-20240605;
        b=WABwRBw3RyJl+HanSnMxyq9dsBnr1r1LELzsGSVobCC0+uspFmodqfZnIKgNaesDIZ
         KTEsD96AKw0UwmnCJpxvbblWd5Xb0kKt/I0p3Ik/kk3FJqxk0QkbMerBZj8UGwLswwJq
         cWddsj4gGOk+ANtZeOtXWyzQwJW1m66cmUKOoY0bUcrhpymI2MUlqfLdjODCpnYTDWFH
         mct04Bwum6h0rxl6uQJE5TUpu0bITrHd/vSO0CfcHdRWOU6+SMYkNupbx155WJVDVtXa
         aM4BXdAXGaGh1jtrqazlIU/JnzNgnqSq79gb9SHdELFNwzYcA9SeIspGAXFDEdx8T1DO
         D/oA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:dkim-signature;
        bh=J7sfAFjc6pqkBS64D1tAEBTQXyapsBonKM0zUXiqcgE=;
        fh=2Ld/g5BVZzBadtquf8mrXl84q+iOtbUed/2ECOFnmmI=;
        b=a9lWOF5AqB+6vaihgzTrr++LNcPIu4JVtoreRUyPnaN4mF+J+hgBW67cakzSWp6qsY
         RYUIb+oioYwnkIFvntmldlVoj3ET4klNm6CZjmZV6TqV68NlxkS/F+EMXJbItXrzLsTY
         1u+l07WkXUFddpebg2nncsY7u0RG/lqHTdqQdbBqma5dDbNlwdckhlaG48OSpJokpryG
         73d/CjH+lkBzvbDAp95eUN2PF7OmrEUs1aoDzx2R/BjlmrLMc/W5BGpyp5yWOZfUSlvw
         Ue7WqatSiASdXeS/rRFzSUYhfBapl7/ruvqZvALsrGajl1NTxUUxjgdluS50BIey7kfL
         FWZQ==;
        darn=kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1778923064; x=1779527864; darn=kernel.org;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=J7sfAFjc6pqkBS64D1tAEBTQXyapsBonKM0zUXiqcgE=;
        b=fhJUOPBQyv5eX38FWy3KYGWhuFCnOUhSPw1LtR34J8wWsYq4kqAiihRR7GlWbgMpon
         uNNzk3/YYIXKgZW5vcSHGGvFiROlWvrvKLgw1aXZH22OjxzJ7SO3P9Tlp+Z2rN7kFtmU
         NHWdGGrMFJT/T9MHyph/RgzOj4VsG0Wt8OblGKMmf7oss82Sdfw3T0Nrr0aJYHT7ytgb
         M2CW4fpzqUcwsRkDjkqmlP7QvZJ53zrZPu+ScM9fzDxLODOXuNJkzF7KSZcm03YP29c9
         WqrbGdnSRhSS/DhgasUGBmIh3b+g2oQApZSj036da51kNMQFgJHnFnO3uwkyaKambL3U
         VGnQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1778923064; x=1779527864;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=J7sfAFjc6pqkBS64D1tAEBTQXyapsBonKM0zUXiqcgE=;
        b=nNwVHjoq2iX/oW88D9VmnTtPeZZ4xS5mHR2ifVjINHo0GIhcXCmo6u6RzFCKJsfSwA
         S3AlQSNp0ldOdebJjnGs2DhSIOEz8Y0D0LY/cnrQkLLMj6BzLcXx+ICrq/AVILLJXX+l
         3DMSb8fwpVvnWFoz/f3mhYE/HTqf5yMHlJ602ugH9rhAnWcsr1JPxCw0AiYlJXJw+pbt
         7mRI8gp/FMk+W+EvwT/zQRAW98/NQT5VZxwMD9datiaQel4OWgMPXFxLUmUMUhAp8Q/+
         ETO2cqkJUKEincMrvKuuAXKlszuKGNdw8drFfdy2GKQCoE32iPUVH7qUFx+9Zh/2GSnQ
         mSoA==
X-Gm-Message-State: AOJu0YzL68hg7njC5P1f8djJYLYYqmJbai/NbbCwSRQwkEWzWZkSjv/s
	IwD7+rvGZ/AnLIbXpA2Otgy38XQmOP3vkmBK6b/gN7ailejC8YN6k5Oeuo5JxfR/2ULVrt5Iuie
	9N8BO1aeHGqPfITJHleYVoUHvu1hW+TPqFzqJX7b0IalauzuBFZPma30oAZ4=
X-Gm-Gg: Acq92OFQlxdh2T7xUf6WJhyDAkRfHm9Swg0cZ8Wdr8vIfFhVNvsPoyvH06Zt4CSIoUE
	0aHi2hbXFTs+rKyFq+x+Ra+/OthF2ww2H/zoje4F6g6ao34A+ASkBS8MdWYo6d639lGcC99SyTG
	NSgnYdgn2eo+pKKRMf3q7hwPdjyk2vaMva/Vgw0XbVLznL9gDzmx23HrZO1MO75nvwO76t/tuGw
	2uhV8n+VCXJQBKcAlIc0TXWCjsmcXr0uckcV6ooZf2GFYFbCtQFa9KGcN4Y9L7JxbK3wp7jSf5N
	7SS+DxmgsuX/W57GT0E0J2kbw5JBsx7N8O+iRz0zhno/7iLygprq
X-Received: by 2002:a05:651c:1543:b0:38e:a883:6303 with SMTP id
 38308e7fff4ca-39561ce5852mr23295341fa.9.1778923063832; Sat, 16 May 2026
 02:17:43 -0700 (PDT)
Precedence: bulk
X-Mailing-List: syzbot@lists.linux.dev
List-Id: <syzbot.lists.linux.dev>
List-Subscribe: <mailto:syzbot+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:syzbot+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <7b8b3fbf-950b-4418-8cf1-772a4d639b14@mail.kernel.org>
In-Reply-To: <7b8b3fbf-950b-4418-8cf1-772a4d639b14@mail.kernel.org>
From: Dmitry Vyukov <dvyukov@google.com>
Date: Sat, 16 May 2026 11:17:32 +0200
X-Gm-Features: AVHnY4IXibQBY4pvDNGPIMiWnin26izOo7ulJv0MGP0KYsAEE1oMb9vMQeoLT2U
Message-ID: <CACT4Y+agnpe-0ewcwB7QfuesOqZQApTr4GRFdvCGS7LmvMGzLQ@mail.gmail.com>
Subject: Re: [PATCH RFC] firmware_loader: Fix recursive lock in device_cache_fw_images()
To: syzbot <syzbot@kernel.org>
Cc: syzkaller-upstream-moderation@googlegroups.com, syzbot@lists.linux.dev
Content-Type: text/plain; charset="UTF-8"

Looks leigt to me.

On Sun, 10 May 2026 at 15:05, 'syzbot' via
syzkaller-upstream-moderation
<syzkaller-upstream-moderation@googlegroups.com> wrote:
>
> firmware_loader: Fix recursive lock in device_cache_fw_images()
>
> A recursive locking deadlock can occur in the firmware loader's power
> management notification handler.
>
> During system suspend or hibernation preparation, fw_pm_notify() calls
> device_cache_fw_images(). This function acquires fw_lock to set the
> firmware cache state to FW_LOADER_START_CACHE and then iterates over
> all devices using dpm_for_each_dev() while still holding the lock.
>
> For each device, dev_cache_fw_image() schedules asynchronous work to
> cache the firmware. If memory allocation for the async work entry fails
> (e.g., in out-of-memory conditions), async_schedule_node_domain()
> falls back to executing the work function synchronously in the current
> thread.
>
> The synchronous execution path (__async_dev_cache_fw_image() ->
> cache_firmware() -> request_firmware() -> assign_fw()) attempts
> to acquire fw_lock again. Since the current thread already holds
> fw_lock, this results in a recursive locking deadlock.
>
> Fix this by releasing fw_lock immediately after updating the cache
> state and before calling dpm_for_each_dev(). The lock is only needed
> to protect the state update. Concurrent firmware requests will correctly
> see the FW_LOADER_START_CACHE state and use the piggyback mechanism,
> which is independently protected by its own fwc->name_lock.
>
> Assisted-by: Gemini:gemini-3.1-pro-preview Gemini:gemini-3-flash-preview
> To: <gregkh@linuxfoundation.org>
> To: <linux-kernel@vger.kernel.org>
> To: <rafael@kernel.org>
> Cc: <dakr@kernel.org>
> Cc: <driver-core@lists.linux.dev>
> Cc: <mcgrof@kernel.org>
> Cc: <russ.weight@linux.dev>
>
> ---
> diff --git a/drivers/base/firmware_loader/main.c b/drivers/base/firmware_loader/main.c
> index a11b30dda..68d5d30aa 100644
> --- a/drivers/base/firmware_loader/main.c
> +++ b/drivers/base/firmware_loader/main.c
> @@ -1503,10 +1503,11 @@ static void device_cache_fw_images(void)
>
>         mutex_lock(&fw_lock);
>         fwc->state = FW_LOADER_START_CACHE;
> -       dpm_for_each_dev(NULL, dev_cache_fw_image);
>         mutex_unlock(&fw_lock);
>
> -       /* wait for completion of caching firmware for all devices */
> +       dpm_for_each_dev(NULL, dev_cache_fw_image); /*
> +
> +*/     /* wait for completion of caching firmware for all devices */

Remove the empty comment after dpm_for_each_dev.

>         async_synchronize_full_domain(&fw_cache_domain);
>
>         fw_fallback_set_default_timeout();
>
>
> base-commit: 7fd2df204f342fc17d1a0bfcd474b24232fb0f32
> --
> This is an AI-generated patch subject to moderation.
> Reply with '#syz upstream' to send it to the mailing list.
> Reply with '#syz reject' to reject it.
>
> See  for more information.
>
> --
> You received this message because you are subscribed to the Google Groups "syzkaller-upstream-moderation" group.
> To unsubscribe from this group and stop receiving emails from it, send an email to syzkaller-upstream-moderation+unsubscribe@googlegroups.com.
> To view this discussion visit https://groups.google.com/d/msgid/syzkaller-upstream-moderation/7b8b3fbf-950b-4418-8cf1-772a4d639b14%40mail.kernel.org.
