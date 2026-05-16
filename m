Received: from mail-lf1-f47.google.com (mail-lf1-f47.google.com [209.85.167.47])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 40F6339A045
	for <syzbot@lists.linux.dev>; Sat, 16 May 2026 10:09:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.167.47
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778926145; cv=pass; b=hCVzBVP5b/00RtZsP5+RytvEpQH5JtHlJkG9qlfjJxu3BBtVY2zaDoNc4l/9TqjoSzgQpM81NA1d/PESe+psqVklSnU0jydKWOKwTRHq2Ol6qP5ZS707dHUFMbEglYw1N3iELsAr2G5u/vnXU07u68tg0Tta0i8hfLI039718Ks=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778926145; c=relaxed/simple;
	bh=doGxpP21D2lQj0ocvyHIDsvMPWF3RI4aqrEk/f2zrpE=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=iXN3PI+wPx7FP8+J8Qt4WLPSXq/dv/Si62va+AmiORL9pj4gmx5HEsRMK6LcH9ijNZPcFMlzb/9dr9cOAZoX5zI7RCpbo4GGVjxyCBh2b6yXfM6jLZrVFgfFfrEjn1OoXpY1QC90oAMq7MlviIWH8w3AmIhHLKDbsQbo+GIXzpo=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=vbHra6O3; arc=pass smtp.client-ip=209.85.167.47
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="vbHra6O3"
Received: by mail-lf1-f47.google.com with SMTP id 2adb3069b0e04-5a995ab70d1so1078525e87.3
        for <syzbot@lists.linux.dev>; Sat, 16 May 2026 03:09:03 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1778926141; cv=none;
        d=google.com; s=arc-20240605;
        b=aYJ+p1CLgQYvqYtjPaW+IIVDLTBptvNSOpUDFVNbS4mpAa6a01evMEcRfimCXNicMb
         PPnbkP3kuMtXEzW4bv19p1iZsIDFCHre4TNXepR6jSSWq+tmQLdHTtvEuuBd5GdwTavA
         i+x4M5JqjpaXDkmU+PI2Ge7vxb8FMq1t569Fcuv1osDjI4pK+aqln0XnfcUSrvzaiUB/
         LJYPu639oQLhdSIFnsq5BdynLDai6jtpTmUwXmrGoCDT1kaVKhb3YK4aIBIoLIif3GvY
         lQQvgCUNJi+agDspdzCCj27SxC8xdaIFWr0bu6cS3cPTNtv/6A5yC4QvE5oAmJPeiOPQ
         3GHw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:dkim-signature;
        bh=BXuzz2FPwv09GcEqY45HY9Atu3wxH9wRjJKKUZ85g38=;
        fh=iWWG2A6e5GRFBX5jdTlSR86Y1KqzihWVRmJprOMoPs4=;
        b=H43ZQZoyG3jYEEjB/3iXtRoeWVUfyN5wZp4cCGRNHO27a9aRvWazO6Y4CBQLSN7V7m
         ils8wNN3Vh/o5CVp6erH4Zw4u3ccScfqUfntaVingwsWvNaD23EoaK6mUqR3c0Bdlt0L
         Q9Fz6HwiKNg/aLmGAbD9GhepEl968B/q3BRXafV0aN8CU8zBm5LhV2HnV0x0MAtfIoGD
         +CFNFuOnUdIvdO3pgR12oRf6fHZmg+dqnEU3nqd41XN98WYR7De0xjpIKiQSS1WZwmsy
         5zEg60xPIIpmD/ow1NQFXYtQrecYXSZNzmqSmBHoTNMHkexrgtQH15l3+ezs/GkTi1N9
         RcjA==;
        darn=lists.linux.dev
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1778926141; x=1779530941; darn=lists.linux.dev;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=BXuzz2FPwv09GcEqY45HY9Atu3wxH9wRjJKKUZ85g38=;
        b=vbHra6O3C3Zcvd3qcQGW7wuGP97TBSvhmSF+Q2KzJP9QBS9y2ADHD/4by7aVnbMxUt
         Zsrg/JmkZ0XXXFxgu2f7OHitLqWAZnsswEs/f8PfITKyeWJZgJXp85OPVZjGWnqhZiOJ
         unqq5UG3xm8Ii8v9lcZf/CXjDau/eM0BH5tXbhsV3sRlQ+08dUB6FgUWDHRfpZItnJxn
         C0/wdvvMyWq9KsuqSrtfh+dStq1Oz3FLt+n1zESGDO9/lraN+w9CGH29BN1KTV4silwL
         JktP82bvCt+QB04/RXfxKWEFFLYD7qS43gcCVMCsa8ZOfX2Il9P47z1bNtNqy5G8XOgs
         wy0g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1778926141; x=1779530941;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=BXuzz2FPwv09GcEqY45HY9Atu3wxH9wRjJKKUZ85g38=;
        b=Z3oIS3PV1shXJz+FShRwVo74zSA9YQ0YAnCTqcP8IhlpGaZxj7eZrN4ILzcz+E0WHO
         qoIJiFicyOpt8fQ6ZUVVDeUyh1lBpU4ZB5aCfQ9KlZ7kT1SkbOPnUTDWPcqxIPLK4jFB
         Lr3aId+vE2nxxswmDZu7spwObN6YJN7ohMkl+Bvc0GpN+7oM62P//nPpJmNM6f2/MhaB
         5bPpYqJXPP2khwB0FxyrDE+SkmfCxT5xVEkZvmGkQ/QM8puXSyDdkvN8eNKgImCOfn4l
         nJMLtbYz7LVoaplHvarw7UhIeTi2tObR4edxXfIBcB/EyZt/o6DUfgNHSOPiareYm72o
         btlg==
X-Forwarded-Encrypted: i=1; AFNElJ9Juvpq4reAjh8c8ElL+18OWxedWLGC2wauogaIElNhD4TySZYTksR4sC3MCbzYBsZ7xRIKcr0=@lists.linux.dev
X-Gm-Message-State: AOJu0Yy6PQRo92jU9lEudJ7DjNNYSrBOK2YBsDa1NMxUgq8xfCYwcOTs
	tP+avm3sna/ch1iITW4oaVIADlHvV5kvrg74UGRt9q7m0B0UTpx2CDNACZDAo+u633LVY07spJw
	qMPqHjbRjff5fbb1D4gkkMTi47jPOMXO5JERY34+2
X-Gm-Gg: Acq92OGwqtaUJelNpZvNEauaahPOwtdQ7CNGJ+Hvu/oQQhsErlVe1Mi3KS3H4yRwonc
	XgsVv9qrIIFGAXerHGEvQbaNw0xzSTJKT5qSIrquIvekd4yX/GgzSFQjdC4sZo/6IJIiHWSNnko
	v9S8YnynPfit2hRf/ysO43Yd/OCDDT9cwW4ECpC4fY244xJSzGfenQOSjqdjB8h66MV3ufSYgaS
	8e7fUpi3yHEj8/aG+S66yz3hOQ86DukX8x14q5IngbWCeaAKfPs3+i+Km+MLyLnzXjJWQo2JwcE
	XRESPODFSssvD+CzfffaG46ov6yp8hoaVsXsqaptdK5oxXXLRrXMrS8nkdg3HQ0=
X-Received: by 2002:a05:6512:2384:b0:5a2:c4f1:2635 with SMTP id
 2adb3069b0e04-5aa0e74e119mr1898088e87.41.1778926140775; Sat, 16 May 2026
 03:09:00 -0700 (PDT)
Precedence: bulk
X-Mailing-List: syzbot@lists.linux.dev
List-Id: <syzbot.lists.linux.dev>
List-Subscribe: <mailto:syzbot+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:syzbot+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <9ceb3eb3-40e2-497b-8d68-257fd88a3946@mail.kernel.org>
In-Reply-To: <9ceb3eb3-40e2-497b-8d68-257fd88a3946@mail.kernel.org>
From: Dmitry Vyukov <dvyukov@google.com>
Date: Sat, 16 May 2026 12:08:49 +0200
X-Gm-Features: AVHnY4K90GNAwfEtB-MwexstASGXo3Un-dER1xxoUBo5OySCt700J97AQXS6zM8
Message-ID: <CACT4Y+aZZJHB7CJLSNGKDkyb-TxfAaCbp1Sf8QKnwhuCviDkaQ@mail.gmail.com>
Subject: Re: [PATCH RFC] mtd: block2mtd: fix circular locking dependency in block2mtd_setup
To: syzbot <syzbot@kernel.org>
Cc: syzkaller-upstream-moderation@googlegroups.com, syzbot@lists.linux.dev
Content-Type: text/plain; charset="UTF-8"

On Sun, 10 May 2026 at 03:38, 'syzbot' via
syzkaller-upstream-moderation
<syzkaller-upstream-moderation@googlegroups.com> wrote:
>
> mtd: block2mtd: fix circular locking dependency in block2mtd_setup
>
> syzkaller reported a circular locking dependency involving the global
> param_lock and VFS locks (i_rwsem). The block2mtd driver performs a
> synchronous VFS path lookup (kern_path via bdev_file_open_by_path)
> inside its module parameter set callback (block2mtd_setup). This
> callback is invoked by the sysfs core with param_lock held.
>
> The dependency chain is:
> 1. i_rwsem -> cgroup_mutex (via cgroup_rmdir)
> 2. cgroup_mutex -> rtnl_mutex (via cgroup_mkdir -> cgrp_css_online)
> 3. rtnl_mutex -> param_lock (via mac80211_hwsim_new_radio ->
>    ieee80211_rate_control_ops_get)
> 4. param_lock -> i_rwsem (via block2mtd_setup -> kern_path)
>
> To fix this without breaking existing userspace scripts that expect
> synchronous device creation, temporarily drop the param_lock during
> the device creation process. This breaks the circular locking
> dependency while preserving the synchronous nature of the operation.
>
> To implement this safely, introduce a local mutex (block2mtd_mutex)
> to protect the module's internal state (blkmtd_device_list,
> block2mtd_paramline, and block2mtd_init_called) from concurrent sysfs
> writes, since param_lock will no longer provide this protection during
> the critical section.
>
> Summary of changes:
> 1. Introduce block2mtd_mutex to protect the global blkmtd_device_list
>    and early-boot state variables.
> 2. Drop param_lock in block2mtd_setup using kernel_param_unlock(kp->mod)
>    and kernel_param_lock(kp->mod). For built-in modules, kp->mod is
>    NULL,
>    and these functions correctly unlock/lock the global param_lock.
> 3. Protect block2mtd_setup with block2mtd_mutex to ensure that
> concurrent
>    sysfs writes are serialized and the device list is safely updated.
> 4. Protect block2mtd_init and block2mtd_exit with block2mtd_mutex to
>    ensure safe access to blkmtd_device_list and block2mtd_paramline.
>
> The lock ordering is now block2mtd_mutex -> VFS locks (i_rwsem) ->
> mtd_table_mutex, which is strictly hierarchical and free of circular
> dependencies.
>
> Assisted-by: Gemini:gemini-3.1-pro-preview Gemini:gemini-3-flash-preview
> To: <joern@lazybastard.org>
> To: <linux-mtd@lists.infradead.org>
> Cc: <linux-kernel@vger.kernel.org>
> Cc: <miquel.raynal@bootlin.com>
> Cc: <richard@nod.at>
> Cc: <vigneshr@ti.com>
>
> ---
> diff --git a/drivers/mtd/devices/block2mtd.c b/drivers/mtd/devices/block2mtd.c
> index 03e80b2c4..f813272da 100644
> --- a/drivers/mtd/devices/block2mtd.c
> +++ b/drivers/mtd/devices/block2mtd.c
> @@ -45,7 +45,7 @@ struct block2mtd_dev {
>
>  /* Static info about the MTD, used in cleanup_module */
>  static LIST_HEAD(blkmtd_device_list);
> -
> +static DEFINE_MUTEX(block2mtd_mutex);
>
>  static struct page *page_read(struct address_space *mapping, pgoff_t index)
>  {
> @@ -464,28 +464,43 @@ static int block2mtd_setup2(const char *val)
>
>  static int block2mtd_setup(const char *val, const struct kernel_param *kp)
>  {
> +       int ret = 0;
> +
> +       /*
> +        * Drop the param_lock to avoid circular locking dependency
> +        * with VFS locks during device lookup.
> +        */
> +       kernel_param_unlock(kp->mod);
> +
> +       mutex_lock(&block2mtd_mutex);
> +
>  #ifdef MODULE
> -       return block2mtd_setup2(val);
> +       ret = block2mtd_setup2(val);
>  #else
>         /* If more parameters are later passed in via
>            /sys/module/block2mtd/parameters/block2mtd
>            and block2mtd_init() has already been called,
>            we can parse the argument now. */
>
> -       if (block2mtd_init_called)
> -               return block2mtd_setup2(val);
> +       if (block2mtd_init_called) {
> +               ret = block2mtd_setup2(val);
> +       } else {
> +               /* During early boot stage, we only save the parameters
> +                  here. We must parse them later: if the param passed
> +                  from kernel boot command line, block2mtd_setup() is
> +                  called so early that it is not possible to resolve
> +                  the device (even kmalloc() fails). Deter that work to
> +                  block2mtd_setup2(). */
> +
> +               strscpy(block2mtd_paramline, val, sizeof(block2mtd_paramline));
> +       }
> +#endif
>
> -       /* During early boot stage, we only save the parameters
> -          here. We must parse them later: if the param passed
> -          from kernel boot command line, block2mtd_setup() is
> -          called so early that it is not possible to resolve
> -          the device (even kmalloc() fails). Deter that work to
> -          block2mtd_setup2(). */
> +       mutex_unlock(&block2mtd_mutex);
>
> -       strscpy(block2mtd_paramline, val, sizeof(block2mtd_paramline));
> +       kernel_param_lock(kp->mod);
>
> -       return 0;
> -#endif
> +       return ret;
>  }
>
>
> @@ -497,9 +512,11 @@ static int __init block2mtd_init(void)
>         int ret = 0;
>
>  #ifndef MODULE
> +       mutex_lock(&block2mtd_mutex);

Why do we need to hold block2mtd_mutex here and in block2mtd_exit?
What possible executions does this prevent?

>         if (strlen(block2mtd_paramline))
>                 ret = block2mtd_setup2(block2mtd_paramline);
>         block2mtd_init_called = 1;
> +       mutex_unlock(&block2mtd_mutex);
>  #endif
>
>         return ret;
> @@ -511,6 +528,7 @@ static void block2mtd_exit(void)
>         struct list_head *pos, *next;
>
>         /* Remove the MTD devices */
> +       mutex_lock(&block2mtd_mutex);
>         list_for_each_safe(pos, next, &blkmtd_device_list) {
>                 struct block2mtd_dev *dev = list_entry(pos, typeof(*dev), list);
>                 block2mtd_sync(&dev->mtd);
> @@ -522,6 +540,7 @@ static void block2mtd_exit(void)
>                 list_del(&dev->list);
>                 block2mtd_free_device(dev);
>         }
> +       mutex_unlock(&block2mtd_mutex);
>  }
>
>  late_initcall(block2mtd_init);
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
> To view this discussion visit https://groups.google.com/d/msgid/syzkaller-upstream-moderation/9ceb3eb3-40e2-497b-8d68-257fd88a3946%40mail.kernel.org.
