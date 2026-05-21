Received: from mail-lj1-f175.google.com (mail-lj1-f175.google.com [209.85.208.175])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1B9D03BBA09
	for <syzbot@lists.linux.dev>; Thu, 21 May 2026 11:27:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.208.175
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779362822; cv=pass; b=hhaJSZE53zKYXP86EGC9UVLSTPwYfVWxIo/gnaukmJORYHz6jttnnQnaxae2N1dizkWrGsFVYsM3JF/K4htFzDwx5nXihlWYDoqfJ9uwAgHGCx7v/fplhvP9v9azWWwNeuFleGSd3dLgfozDwCqqi7A4x9RwWhu43JTWjHKnrcs=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779362822; c=relaxed/simple;
	bh=KinQ+UOhkFymzt0ycgvyzba/bE4SnoCBDYZVHBOZGl4=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=n+ZVmu/BYdMa9zUAq9UJOtYCo9bEKq9UJlDLvBX1BMH+DwWotyb8wcuJDV/beXKGxcUSm6oWr3qq+MxYfXzDijrL6gwTfLS8XKPCqBLoMBxascUuwzRrgBWC09agWO1lRjZU2OPe0xyaqI0PZs6O8YxuaNTQmy96T28ymFqbY9M=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=IAeFPocH; arc=pass smtp.client-ip=209.85.208.175
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="IAeFPocH"
Received: by mail-lj1-f175.google.com with SMTP id 38308e7fff4ca-39393c1b5aaso6128711fa.3
        for <syzbot@lists.linux.dev>; Thu, 21 May 2026 04:27:00 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1779362819; cv=none;
        d=google.com; s=arc-20240605;
        b=VQPEVsb5Lnr1Q07dz/ucVA40hicOuUOLccsZjc+eQSRjsAcW+XVb8BnvINAgPw8Drl
         bXldb/9A1sR3JSIb4CmFPUT0YogE6ls0/op9krZCqrW/CXssbDbAacZPAY0axQBs5Afj
         i5++n3vizgyEvihY54K3r+mYwfcHJyJEi0Gve/+91lewtW2QgV9SJtyzJNmdoIR1uxmw
         Xls98feCGWT0nV5iy+bIQiPb4cjl42xxUsyCGokKjfBM7Lo5xc56S0gkOQvte6PW9g/a
         DTDLmgVx92LND31Da/nHnwyCC2+D6ECaB4hhERuWr3StGxWX7yanNe8qOi2bPfsm/yhr
         L76g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:dkim-signature;
        bh=kdUMgDeck/FjquUJmDRSVxOJQEXpMnwHJJZ92xzRZU0=;
        fh=5LFxGMJvUD0UeAAEJ9OrraKPDWZrDXKd/8OA81BXUaM=;
        b=CEmXwp4t3JVo4oC7yJm0d1guFENL4ERRKekjlwZjpdbaLYR0dXu3epWXFKkuFLi897
         j/fKGPvT+V4KdEGA6H0RwQ/WxozMnS+LX9qHb6BCdtNdWsQLGh5OmqqlkNX8XtPVDaCB
         p+UMLsHtK0SJbt4FzV9z0DvBBRA74YE3OscQ+JOOf8NI/WbRYyrcrGs9meUICOQ1mpQL
         oA3A76Jzykp/KQ7Th62u/D56bINUhS9X4N0AeFFDZLviNdWUiWDo5ucVkiLtttbIJ4Tg
         ilYDcRNWUI+CJ7ezMqmQUVqWIVMxi7GuR41ZYls+MiM3yDFQ452V1JnhTXID6xzaqd62
         Z5ig==;
        darn=lists.linux.dev
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1779362819; x=1779967619; darn=lists.linux.dev;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=kdUMgDeck/FjquUJmDRSVxOJQEXpMnwHJJZ92xzRZU0=;
        b=IAeFPocHBCCzxjpLusBQOhNxONLktkpEPoU+wBsXqieYXYA8LTwxNYh1CsXmSH7eks
         ZIGekNCpZaCAkCrDeTuLJgZgWJrfWXsCL6A4tFz/dgIuUGF5RaP6znLsdHUcYr88HWJm
         xR5SzEI6Ocj7x5cWCQ0l2t8mkNi5dAalUbZfIGxQQULKvzPU4zp2hXH7HU7u3nlTBPt2
         QKBsEg7hTGDcAlH1SVV7yiYgKcL3+9xxxV29a+d5MV6KasO0aoaC072ci7oTgT71O9kO
         0g3yK1a2lb7d6yTX3tgHY6jHul9BvvU6boyMa1YWtEhwwn9cGbqKnLQpt8UHSza5eOuk
         1Wjg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1779362819; x=1779967619;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=kdUMgDeck/FjquUJmDRSVxOJQEXpMnwHJJZ92xzRZU0=;
        b=eF5n+9o3mVxl1XPqOZAHxL98GvYkGCidOIvvETmTinchiqYGBsjLX54O2pQu3UTRpm
         B4p6P45CwyZ6uaRAw+c0FQYYZRUKFADNbt2p6evYlg1SpHP/oIiQiYzNCPkDvu0aSA8v
         oHs97PlekQ8hlTG2bnb7/hz0GmU+aM5KytobslyNpN09tknGZqoWL3gr1UkvW4fHzovk
         gPrVreQ0JM3doAS8K1/rVebPcXCv+o1rzr8Leg9xy2LNMdjRnSsBCGnsfWCZM6etJWX/
         ZI/fHXupDZIiv7BSI/MXuZIGALdIFsP0Xo18Edc7bGu/MRTU+o5LHXeJjUc07gXKpdnp
         +YjA==
X-Forwarded-Encrypted: i=1; AFNElJ+D1QF0SrTNbz8qhVBnMjUlkVDZaj0ntrngzDZ5vUuXaa6Kn8+/0NEulg8TvJ30FquEL4v6Fzg=@lists.linux.dev
X-Gm-Message-State: AOJu0YwJGNusBsH7HOw2pFMV66Igh/pW5/MpVeilVIHtSDWdxgrVG+F7
	Rlle8OB1QmFFRiUEcYwiUXLPKBtOgdsHOJuwwRlVU8B1IWajSvsIrUfabPYYggKqMNuKcWqvwj/
	vfDIRz5pyIt7OUVw/+JdIhJVr86C8yFiwfvFsmT19
X-Gm-Gg: Acq92OEn/+Lew2D52llAMtRVTXqkgZLrhilo7Jbtl1cTZ2zXn73g7PZz/CDkW9kc6B4
	dYClz4hS/3MGc7nqnhlme2/tULAswwYlVHM1WLm//0jDda7SAruVHQNf8tThF0+TeZCwNEUpWG8
	ooOvl3+6vlv7TyYhxUm6vdKvaAkMfSpO/WfCeQyxETwc7ClKtijwca9+94SdZ11G1cB42OHv4aK
	Sxd16dKuSBjYLKXSItTbqEp+X2DbyxV35YWVoUJWyERqA3Hf2z1+zHt/ghi4oBG/0aRcwQghQIn
	rot9B8N11UQo3TfNP+jVVnZB2RaOG9NsY5FX6laHvfc375aPnp+aOuZKhMEl4PRN1m4VzbYv4rk
	9KRqaha+UoLH0cM4=
X-Received: by 2002:a05:651c:886:b0:38e:9eb1:693b with SMTP id
 38308e7fff4ca-395ca2b22e4mr10474611fa.3.1779362818794; Thu, 21 May 2026
 04:26:58 -0700 (PDT)
Precedence: bulk
X-Mailing-List: syzbot@lists.linux.dev
List-Id: <syzbot.lists.linux.dev>
List-Subscribe: <mailto:syzbot+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:syzbot+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <83f1cd4e-d372-4be8-8ce6-32cbd7195ab1@mail.kernel.org>
In-Reply-To: <83f1cd4e-d372-4be8-8ce6-32cbd7195ab1@mail.kernel.org>
From: Dmitry Vyukov <dvyukov@google.com>
Date: Thu, 21 May 2026 13:26:47 +0200
X-Gm-Features: AVHnY4I590qeoXMM6KXTIdcI4DkuWJk_7FCJgAq9_hpnIKty3uBQuGdmvXoJw0A
Message-ID: <CACT4Y+bGf+-P_WVn045C1tvt3A9p7Xwrd0UohGwUzOhJO+JHYQ@mail.gmail.com>
Subject: Re: [PATCH RFC v2] firmware_loader: Fix recursive lock in device_cache_fw_images()
To: syzbot <syzbot@kernel.org>
Cc: syzkaller-upstream-moderation@googlegroups.com, syzbot@lists.linux.dev
Content-Type: text/plain; charset="UTF-8"

#syz upstream

On Sat, 16 May 2026 at 14:26, 'syzbot' via
syzkaller-upstream-moderation
<syzkaller-upstream-moderation@googlegroups.com> wrote:
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
> Fixes: ac39b3ea73aacde876d1d5ee1ca3e2719f771482 ("firmware loader: let caching firmware piggyback on loading firmware")
> Assisted-by: Gemini:gemini-3.1-pro-preview Gemini:gemini-3-flash-preview
> Reported-by: syzbot+e70e4c6f6eee43357ba7@syzkaller.appspotmail.com
> Link: https://syzkaller.appspot.com/bug?extid=e70e4c6f6eee43357ba7
> Link: https://syzkaller.appspot.com/ai_job?id=8cbf9f7d-812d-4db3-89fa-0aaef3ce3a2f
> To: <gregkh@linuxfoundation.org>
> To: <linux-kernel@vger.kernel.org>
> To: <rafael@kernel.org>
> Cc: <dakr@kernel.org>
> Cc: <driver-core@lists.linux.dev>
> Cc: <mcgrof@kernel.org>
> Cc: <russ.weight@linux.dev>
>
> ---
> v2:
> - Removed the empty comment after dpm_for_each_dev().
>
> v1:
> https://lore.kernel.org/all/7b8b3fbf-950b-4418-8cf1-772a4d639b14@mail.kernel.org/T/
> ---
> diff --git a/drivers/base/firmware_loader/main.c b/drivers/base/firmware_loader/main.c
> index a11b30dda..c96312ac2 100644
> --- a/drivers/base/firmware_loader/main.c
> +++ b/drivers/base/firmware_loader/main.c
> @@ -1503,9 +1503,10 @@ static void device_cache_fw_images(void)
>
>         mutex_lock(&fw_lock);
>         fwc->state = FW_LOADER_START_CACHE;
> -       dpm_for_each_dev(NULL, dev_cache_fw_image);
>         mutex_unlock(&fw_lock);
>
> +       dpm_for_each_dev(NULL, dev_cache_fw_image);
> +
>         /* wait for completion of caching firmware for all devices */
>         async_synchronize_full_domain(&fw_cache_domain);
>
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
> To view this discussion visit https://groups.google.com/d/msgid/syzkaller-upstream-moderation/83f1cd4e-d372-4be8-8ce6-32cbd7195ab1%40mail.kernel.org.
