Received: from mail-dl1-f52.google.com (mail-dl1-f52.google.com [74.125.82.52])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AB683369D77
	for <syzbot@lists.linux.dev>; Fri, 29 May 2026 12:24:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=74.125.82.52
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780057500; cv=pass; b=GRvm4SgonlTm1lDsoRT3F5ZA7gMGFbG1klbAIQh5y7Oci+3baaXibj4XJ6Iw9AHqhj9fchLlvB7wRgvWZwLuIad89cUggBsy0nPg90Rp7hWJVDbQcMygDtnj+hoq4kZeGNrbaIJHnDMaQnzWXCx2W0aMC8XIGAwshLVOTszW1Tc=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780057500; c=relaxed/simple;
	bh=jfShPVdCYMBk5WKEUli52FkbbqBvPqWfccsAFd0pQHE=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=N46ai7rt/OpTei9niySGl26l3cp14q8WUCqRG941ZBjenpEotsqyycP30MoMVkXizNGzMn63CzcZ9xu2EIZtispYYHadLimbfyvZVfnQSakm3BcI763MZnhYDouW7Z51oPXIzMfcC/alvHClDK1gj+7Ag974uQr3wgUWr7XNf5Y=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=rCK9euVz; arc=pass smtp.client-ip=74.125.82.52
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="rCK9euVz"
Received: by mail-dl1-f52.google.com with SMTP id a92af1059eb24-1353c2f35cfso6979143c88.1
        for <syzbot@lists.linux.dev>; Fri, 29 May 2026 05:24:58 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1780057498; cv=none;
        d=google.com; s=arc-20240605;
        b=R5y6nAEF69mY/ybNOY8AMtDKml/fj8BiZl2pOJaMRZ/MvSRtFxRpDMUetk4xZxC9ck
         6TnpPXpeQ1/l47imkmBoY45OWn/yJ1gPLAmVal9TpNZDTj5DDpZUtKhZTLdwR+E7iVK2
         sBE9S96IhWEVkTKJEVCsaWP3oLsncgaM3J/JgxmR/eTlz+39vwkeQzBxAGeZJOY+2h75
         UHNiIdLJeUH9jdc5m11mwL1i07oQGi7+1JW9TpNALgdG9frogP0TLCQtoI6mZA8cQC6n
         2jdj409Z2UxvpnDtDP7nXaYltxm3x3zuHlC5TkcXjvN91515tMEkN+yLt3DCDNbsrpp5
         4huQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:dkim-signature;
        bh=o9XTfVr6rKHGnvTuBsfJprsxGrvKaytA7n9h9vU9X3c=;
        fh=xMs+0pCG9qAcfzVLWCXcVNOaTT1bCTBJvum21P8FYW0=;
        b=Yr7/ViC+Ia9OgoFrEhUSC08M4fpm+d1KjEzVlDaRjBFwieoIkcuJcH8vcPSmndgcIb
         dtrBv70kEFYgoKiGtB0psg/xKRuq2/QOS7qLnrg+lEyNTs0+OuqaDXqobyqq+zQgChkP
         TIpQO58Q4MmQXH5DpeTG7h2L3RIH5aroCGBRsEpmkR7vS37ZA22YTsHuFePMOYOhTZWV
         zWMIkirAk3lp7Qn0+nVm0uJ+G7h/PzROlc8+jClSdaYODIZkvSpdfhEXclQCYXB1P8ag
         RPgCZxyJsZ6J9cUtTd5Y3a1d3pn8dCGjAfcV5sDuNoADTZ9q7RhCoJTD7fKnxirE24mj
         dR0g==;
        darn=lists.linux.dev
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1780057498; x=1780662298; darn=lists.linux.dev;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=o9XTfVr6rKHGnvTuBsfJprsxGrvKaytA7n9h9vU9X3c=;
        b=rCK9euVzmQxolxCg9oIMpJo/QhCUM2Ydhv+FUZN5wLx5WxlGh2PnjKFYZONP9q0Bsr
         nOcsuBev35ZD6OvIEoGBy9BOsgLbMdcEa87S/7bpFGNPgXCMU66HMw8zysGWfljS5i8q
         VdWKsLVVS+07yZ1wlVJGiVXByHg9/NlLemRX3Ack8tv0gdn025ts+r6n78H6/TxTs+5C
         rBDRjazeAh+YP7kutMHnMEHREXZwiSiXdS5Ww7uAk2De5BnfiWcvwzDKuxSdvJENQj5o
         gYVAj8LgdZhsic/ZFEXj3ccWAdAQKBei+Y4ezrVuO/hdIpgm0kxIEyQRQJQYkux9V/5c
         NiaA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1780057498; x=1780662298;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=o9XTfVr6rKHGnvTuBsfJprsxGrvKaytA7n9h9vU9X3c=;
        b=mUYusb1cWy4CJNcnD1mpGBwaLC5mXxGPuW1zKXtlzUVNCqMeCI9CivYiV1YkWlHOZz
         BsLvObFLUeSOK/kE1JtV/OrbcPqd+Fj3cv9/co5Bmp0nqj3ODoA70jX24TsyLcvUutQe
         nRFXlnp+Hm5Z6bRftwV1k9f/ie8+mNrYNsSijZpj8gjFg0kV5hi2epjZDELRlTpiWkLj
         31aDNVovn//Jst8DA2P0RPice/ptDSqgcQ7EXlbLz4XNxI41au703gtmXkGfdjAjTtw8
         OvBMvpIhTKi+/9rWIaC0n9ARqM059tQL7oHDU+v5l78jrX4JeBQIO0JnbwAzZ7rxBuDx
         G7qA==
X-Forwarded-Encrypted: i=1; AFNElJ/xIdBLgWirmrd7aPoDEkFStm9gOichmoSigAqwG4DJ+arcgx2X2lbe06TexyIBQkd2uL7avUQ=@lists.linux.dev
X-Gm-Message-State: AOJu0YyLeVDLeDL6e/zC7NatcTTlPti7e6uIRrgpMUUp9Gi7eIDLL230
	X6CL4iQLNceYqE/B7tVHRFvYcXupT0rh1Qe2PK+zHOrbftcTfoxn2GQE42TOEQPW4Y2AAO1mGZw
	MYz8qyDsPick/yTit9FSYMINrzQcOoK0ZiE72Z0/+
X-Gm-Gg: Acq92OFnW21UWzjbawgB6iqdBVXMNjItIsRezQKolZ2xBC51ZsCMbUG1OP3tSijV1xf
	j+ulTqG90gSuMNlWlG1jiKcbbq9hqVdJH7unNwN74aZaBZC4PS4hPfj/iITvx3u86P+vjFhgG8d
	lviuS/Y4nS5uiv8a1B4tK2v+C+0J9RI7Pyq/nhGwrZtKS+hUPZU5FFuZCHjJb665tdnCI32q1Cu
	9FjVaO3OO1/3169pttgO5F2yjmX7DexDEp2Z4b+N2PGDYIXefCFoWzvG+9p/H5j65iO3LjqmEBo
	k/ZR69wJFiSZlYqJAoPlLmSs469yuE8w9+BPdfbzV45d3i6MzSrCd4SpvUEk
X-Received: by 2002:a05:7022:520:b0:136:682b:4c3a with SMTP id
 a92af1059eb24-137af648d4bmr1157427c88.24.1780057497108; Fri, 29 May 2026
 05:24:57 -0700 (PDT)
Precedence: bulk
X-Mailing-List: syzbot@lists.linux.dev
List-Id: <syzbot.lists.linux.dev>
List-Subscribe: <mailto:syzbot+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:syzbot+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <a9d448c8-44ac-4c8c-a391-aad1478a7eb1@mail.kernel.org>
In-Reply-To: <a9d448c8-44ac-4c8c-a391-aad1478a7eb1@mail.kernel.org>
From: Marco Elver <elver@google.com>
Date: Fri, 29 May 2026 14:24:20 +0200
X-Gm-Features: AVHnY4LG3OL8glohin7nZV2viLFis_ecXjL0lTGylzOGPIRwR-VEyUeuM-SRRxg
Message-ID: <CANpmjNM4hLSAVkz4qGMOgQUXHHsvy9ceraSzzLGg7RaueCZeGg@mail.gmail.com>
Subject: Re: [PATCH RFC v2] mtd: block2mtd: fix circular locking dependency in block2mtd_setup
To: syzbot <syzbot@kernel.org>
Cc: syzkaller-upstream-moderation@googlegroups.com, syzbot@lists.linux.dev
Content-Type: text/plain; charset="UTF-8"

On Sat, 16 May 2026 at 17:41, 'syzbot' via
syzkaller-upstream-moderation
<syzkaller-upstream-moderation@googlegroups.com> wrote:
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
> Fixes: f9d8c3c4236ef2a1c15b01200b9d164e2c5a54c7 ("block2mtd: port device access to files")
> Assisted-by: Gemini:gemini-3.1-pro-preview Gemini:gemini-3-flash-preview
> Reported-by: syzbot+65459fd3b61877d717a3@syzkaller.appspotmail.com
> Link: https://syzkaller.appspot.com/bug?extid=65459fd3b61877d717a3
> Link: https://syzkaller.appspot.com/ai_job?id=c3c46711-9492-41e5-bcb4-4fb68a746c23
> To: <joern@lazybastard.org>
> To: <linux-mtd@lists.infradead.org>
> Cc: <linux-kernel@vger.kernel.org>
> Cc: <miquel.raynal@bootlin.com>
> Cc: <richard@nod.at>
> Cc: <vigneshr@ti.com>
>
> ---
> v2:
> - Added comments in block2mtd_init() and block2mtd_exit() explaining the need for block2mtd_mutex to protect against concurrent sysfs writes.
>
> v1:
> https://lore.kernel.org/all/9ceb3eb3-40e2-497b-8d68-257fd88a3946@mail.kernel.org/T/
> ---
> diff --git a/drivers/mtd/devices/block2mtd.c b/drivers/mtd/devices/block2mtd.c
> index 03e80b2c4..42da6b9a5 100644
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
> @@ -497,9 +512,15 @@ static int __init block2mtd_init(void)
>         int ret = 0;
>
>  #ifndef MODULE
> +       /*
> +        * block2mtd_mutex protects block2mtd_init_called and
> +        * block2mtd_paramline against concurrent sysfs writes.
> +        */
> +       mutex_lock(&block2mtd_mutex);
>         if (strlen(block2mtd_paramline))
>                 ret = block2mtd_setup2(block2mtd_paramline);
>         block2mtd_init_called = 1;
> +       mutex_unlock(&block2mtd_mutex);
>  #endif
>
>         return ret;
> @@ -511,6 +532,11 @@ static void block2mtd_exit(void)
>         struct list_head *pos, *next;
>
>         /* Remove the MTD devices */
> +       /*
> +        * block2mtd_mutex protects blkmtd_device_list against
> +        * concurrent sysfs writes.
> +        */
> +       mutex_lock(&block2mtd_mutex);
>         list_for_each_safe(pos, next, &blkmtd_device_list) {
>                 struct block2mtd_dev *dev = list_entry(pos, typeof(*dev), list);
>                 block2mtd_sync(&dev->mtd);
> @@ -522,6 +548,7 @@ static void block2mtd_exit(void)
>                 list_del(&dev->list);
>                 block2mtd_free_device(dev);
>         }
> +       mutex_unlock(&block2mtd_mutex);
>  }
>
>  late_initcall(block2mtd_init);

  The deadlock resolution is correct, but dropping  param_lock
exposes a critical Use-After-Free (UAF) race condition during module
unloading.

  Because sysfs writes do not hold a module reference,  delete_module
(rmmod) can proceed concurrently with an active sysfs parameter write.

  1.  rmmod  starts, sets module state to  GOING , and calls  block2mtd_exit() .
  2.  block2mtd_exit()  acquires  block2mtd_mutex , unregisters all
active devices, clears  blkmtd_device_list , and releases
block2mtd_mutex .
  3. A concurrent sysfs write (which dropped  param_lock  to avoid the
deadlock and was blocked on  block2mtd_mutex ) now acquires the mutex.
  4. It calls  block2mtd_setup2()  $\rightarrow$  add_device() ,
registers a new MTD device, and adds it to  blkmtd_device_list .
  5. The sysfs write releases  block2mtd_mutex  and completes.
  6.  delete_module  completes and frees the module memory.

  This leaves an active MTD device registered in the kernel pointing
to freed module code ( dev->mtd._read , etc.), leading to an immediate
kernel panic on next access.

  To prevent this, we must serialize the module exit state. Introduce
a  block2mtd_exiting  flag synchronized by  block2mtd_mutex  to reject
new registrations during unload.

    diff --git a/drivers/mtd/devices/block2mtd.c
b/drivers/mtd/devices/block2mtd.c
    index f813272dad88..b12a84cf0e12 100644
    --- a/drivers/mtd/devices/block2mtd.c
    +++ b/drivers/mtd/devices/block2mtd.c
    @@ -46,6 +46,7 @@ struct block2mtd_dev {
     /* Static info about the MTD, used in cleanup_module */
     static LIST_HEAD(blkmtd_device_list);
     static DEFINE_MUTEX(block2mtd_mutex);
    +static bool block2mtd_exiting;

     static struct page *page_read(struct address_space *mapping, pgoff_t index)
     {
    @@ -477,6 +478,11 @@ static int block2mtd_setup(const char *val,
const struct kernel_param *kp)

         mutex_lock(&block2mtd_mutex);

    +    if (block2mtd_exiting) {
    +        ret = -ENODEV;
    +        goto out_unlock;
    +    }
    +
     #ifdef MODULE
         ret = block2mtd_setup2(val);
     #else
    @@ -498,6 +504,7 @@ static int block2mtd_setup(const char *val,
const struct kernel_param *kp)
         }
     #endif

    +out_unlock:
         mutex_unlock(&block2mtd_mutex);

         kernel_param_lock(kp->mod);
    @@ -529,6 +536,7 @@ static void block2mtd_exit(void)

         /* Remove the MTD devices */
         mutex_lock(&block2mtd_mutex);
    +    block2mtd_exiting = true;
         list_for_each_safe(pos, next, &blkmtd_device_list) {
             struct block2mtd_dev *dev = list_entry(pos, typeof(*dev), list);
             block2mtd_sync(&dev->mtd);
