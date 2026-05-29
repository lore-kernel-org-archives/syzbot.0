Received: from mail-dl1-f51.google.com (mail-dl1-f51.google.com [74.125.82.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 02F3A33F5B3
	for <syzbot@lists.linux.dev>; Fri, 29 May 2026 13:45:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=74.125.82.51
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780062317; cv=pass; b=gS790RSBxAplZhonZeQ6fct9P4gPIGcLKMRXrKii5c342HVo9nj5zE9RaeXuySL6n9WwO7DaYyOjZJBKp0QjB1h5oY3P/w4OKbykWVP5S3xe3HoHdASmSIVTAn+H3SNj95rwm4e/99I5mep2UFzyn71c73LSVV6QgYJymz+2O3I=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780062317; c=relaxed/simple;
	bh=wBnwAldTXVaXiwm1cpyKGNjRTnaMJ5DzANI6h0gH1oM=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=kntM3YuaWZgkAXbleO2PsgzIjDyEob9iw+9boo0ZUOpM+R5ZcKMp5MUMQaPL6pbYFSgjobtU52EGZwSMKlp1mhDe7oXAbh27akJjSZFSIa4Lp6zsN0nd7sXRn1ho7jLwbnfhecwprUiR7P2LDdPhSHX79bqfgrmBwB+wU+N0ceQ=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=ZGa1MMOG; arc=pass smtp.client-ip=74.125.82.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="ZGa1MMOG"
Received: by mail-dl1-f51.google.com with SMTP id a92af1059eb24-1370417c01cso6599659c88.1
        for <syzbot@lists.linux.dev>; Fri, 29 May 2026 06:45:14 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1780062314; cv=none;
        d=google.com; s=arc-20240605;
        b=Mpx87GaPz85wq0ffQeuxgrjGSjBrvwk1vSjTUvSMPJajPWNhvpUvpbCEIzk3CN1A2H
         HnHdpL4PHimpZ5+ogc1kyWTKfQN0HaNDB1OiGO1sCdbJxN/sciibQkY33L3kxKsa2C5k
         VGVfgzJeQZBcY/gPQ55Zb4haybMibdPIFjgg0NDFPCPn9okTdW1PNlPxRUVuNxRbnlQh
         CxpQ1/PglnDUmzqhmeBixIS0wSNfb4yR+8h/RDROB6ntS2B1pwpeo62Bjj1rxRT39PAn
         RFURY0PvOZ9lhd8O2AQVW08YzZ2PnN/kQC+WKtHKj8CpKUvc0ZUkyqs8h+xaqSk6+HjV
         /h2w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:dkim-signature;
        bh=8mnexebIp1bSJ97+mzd3yIogl9vFpgiTgN5Fo8elc6E=;
        fh=djgJux/wnzqKV4c5jP7825QQ2uAjArJ41Dqx67lcdII=;
        b=S6vvlJzLtvZTMI1ctVqjXR2sYUCz0Ve7fwlQ4i8MLDHk6OeU95TdmGKR5dif/e6UlT
         IQnBaConyLknCytkc2/AxW5Mdx9BoDfxub4reb7e/ysKF0rCIDsu2vkbfxAq5ElZWJhX
         EEcpVZKt+u0PFx1PJ/PqOmfRhsMFN1YTa5tUB9wpKGkvgN3sC4bXVKGYOZBxSCYZaJ/0
         1OZnoegDV8Ai5YKZMaCq606ClE5VK469OdmPO1AYoP8KPYKUY86scQthz/BED2RCwNOE
         AOlwkm6dGka3xIKIO92+yPG3zHZ5EM4tGRagjB66A5PJNzuVERgoTFsgFVzuhXCy26v6
         NrRA==;
        darn=lists.linux.dev
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1780062314; x=1780667114; darn=lists.linux.dev;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=8mnexebIp1bSJ97+mzd3yIogl9vFpgiTgN5Fo8elc6E=;
        b=ZGa1MMOGn37EpWFBrqeSt63rRYE6XuA6b3MZIeG30zbD5rV/A86NZwFYfY98d7CJM5
         AbIHTJMZSTLhwINWAy1j6xmGuXi51uKyfhhGRco82My3lGpJgzLJN41gZafyseNkFAGb
         tkD6t8kRooXrAzCUrzGLIgApVBA5NvSWsKPMRog16eQP6L4QMa9OB4lIjPpk8eWHR9tj
         06KPq8Y4JcS/bOzwglc53STIS0SdwPMN0u8FJ7Tr2eAsND3x4yaQSA8AcWtes2V80sKG
         p7sYMInuav2FsAjpzaVaM6Z1TDW3vjWFWqbtkbMN03C4DCza/oomcfgkSFcww1qDyTGv
         W+sg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1780062314; x=1780667114;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=8mnexebIp1bSJ97+mzd3yIogl9vFpgiTgN5Fo8elc6E=;
        b=iMPI3kBCyTYPzO7GTgFjT7xggqILAvdvMiZGhUZwkER/Q7Bk9UMKLiDhN68ZJ7/d1M
         jZqXm20nf/ieJ4YOCb7EQYesAJQXcSW3CQoJG+flEK8prW5e26/ft35Fbe4LD1bfLMEi
         KTbKulIY3dsL/M1VRoTRAGYnRVCaP/9NtbdlmyMbesPGrqAiLY++ztlNe83KP+5Ej22m
         MD7FV/WC3aWQqIreylUfQtNY8C8Wxbc7jUgJ+ggB8guyXfQJp8Ug7lJgNpCEVqFUZOG7
         1xyGiIrUNcR3T2XToIxoDbGPgyfTXfvR0dPmdjIYnagc8kIl/kAZhBN39BI0T33Fi/cw
         G/5w==
X-Forwarded-Encrypted: i=1; AFNElJ/J6J9JRNb7CwoyUsqpLlRYYMJ7fKzu9PePw/pHXkkgDrZ4nPoaZnzRSKfbjA9OalOeFsFPYpI=@lists.linux.dev
X-Gm-Message-State: AOJu0YzGM3zSuAjuhakgjFGF7tw6n68iCha+xPKFWC+8qql1hEs/PGog
	HlP8SO5bON8jJmSD5sJYg//Q+H8B85zNH6+13JyOtFi4/w9vTr2PlvGkz+qpy8dpe24nIS3/D+e
	mLC64zCqnZ3cISRFpJHexexyVnDD1mHvn/lnG7hYc
X-Gm-Gg: Acq92OGzh1mKbAZPBKhJDKUr0XxgKFPQ9T+d+Rsg0IPYEMWpBXr20tak/ap+YjvGD/c
	68Cz5ks5tKks5pk+xhKXB3MijAg6C0/2Z0Ztr5IrKtTY9CdoK+R8d2CA796zX+jDoFQDXZSbqwC
	u0v5RLzZN0/vM5MxV68F+CPjwUBEr81m7qck/U3rhKu+uZgnC5Ot+POuf0OssAyzx94oIBySoGe
	g0gEuMBCn4wQAhrusWAy0XsXdRGwLYwv1VbVkAryO+Bwh52Rc0vtCbbBnn/3mv33XLWtYiWFi2j
	1ezy7ngOopJ2OZBAPCkIFAIgC6kw4VruB02Jku7aFJbMp6CiYA==
X-Received: by 2002:a05:7022:ef0c:b0:136:9ebf:3bf4 with SMTP id
 a92af1059eb24-137aeff9002mr1079471c88.26.1780062313335; Fri, 29 May 2026
 06:45:13 -0700 (PDT)
Precedence: bulk
X-Mailing-List: syzbot@lists.linux.dev
List-Id: <syzbot.lists.linux.dev>
List-Subscribe: <mailto:syzbot+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:syzbot+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <a9d448c8-44ac-4c8c-a391-aad1478a7eb1@mail.kernel.org> <CANpmjNM4hLSAVkz4qGMOgQUXHHsvy9ceraSzzLGg7RaueCZeGg@mail.gmail.com>
In-Reply-To: <CANpmjNM4hLSAVkz4qGMOgQUXHHsvy9ceraSzzLGg7RaueCZeGg@mail.gmail.com>
From: Marco Elver <elver@google.com>
Date: Fri, 29 May 2026 15:44:35 +0200
X-Gm-Features: AVHnY4KG31-iwQYtBvKq69qGzKb78HNq7QRIIpzCxh-FS47eMwMmaezULHSYI_k
Message-ID: <CANpmjNNGCOGMCwVz0NVqae6y2rcZeERaQjE_zDpDkbBM3=_0BA@mail.gmail.com>
Subject: Re: [PATCH RFC v2] mtd: block2mtd: fix circular locking dependency in block2mtd_setup
To: syzbot <syzbot@kernel.org>
Cc: syzkaller-upstream-moderation@googlegroups.com, syzbot@lists.linux.dev
Content-Type: text/plain; charset="UTF-8"

On Fri, 29 May 2026 at 14:24, Marco Elver <elver@google.com> wrote:
>
> On Sat, 16 May 2026 at 17:41, 'syzbot' via
> syzkaller-upstream-moderation
> <syzkaller-upstream-moderation@googlegroups.com> wrote:
> >
> > syzkaller reported a circular locking dependency involving the global
> > param_lock and VFS locks (i_rwsem). The block2mtd driver performs a
> > synchronous VFS path lookup (kern_path via bdev_file_open_by_path)
> > inside its module parameter set callback (block2mtd_setup). This
> > callback is invoked by the sysfs core with param_lock held.
> >
> > The dependency chain is:
> > 1. i_rwsem -> cgroup_mutex (via cgroup_rmdir)
> > 2. cgroup_mutex -> rtnl_mutex (via cgroup_mkdir -> cgrp_css_online)
> > 3. rtnl_mutex -> param_lock (via mac80211_hwsim_new_radio ->
> >    ieee80211_rate_control_ops_get)
> > 4. param_lock -> i_rwsem (via block2mtd_setup -> kern_path)
> >
> > To fix this without breaking existing userspace scripts that expect
> > synchronous device creation, temporarily drop the param_lock during
> > the device creation process. This breaks the circular locking
> > dependency while preserving the synchronous nature of the operation.
> >
> > To implement this safely, introduce a local mutex (block2mtd_mutex)
> > to protect the module's internal state (blkmtd_device_list,
> > block2mtd_paramline, and block2mtd_init_called) from concurrent sysfs
> > writes, since param_lock will no longer provide this protection during
> > the critical section.
> >
> > Summary of changes:
> > 1. Introduce block2mtd_mutex to protect the global blkmtd_device_list
> >    and early-boot state variables.
> > 2. Drop param_lock in block2mtd_setup using kernel_param_unlock(kp->mod)
> >    and kernel_param_lock(kp->mod). For built-in modules, kp->mod is
> >    NULL,
> >    and these functions correctly unlock/lock the global param_lock.
> > 3. Protect block2mtd_setup with block2mtd_mutex to ensure that
> > concurrent
> >    sysfs writes are serialized and the device list is safely updated.
> > 4. Protect block2mtd_init and block2mtd_exit with block2mtd_mutex to
> >    ensure safe access to blkmtd_device_list and block2mtd_paramline.
> >
> > The lock ordering is now block2mtd_mutex -> VFS locks (i_rwsem) ->
> > mtd_table_mutex, which is strictly hierarchical and free of circular
> > dependencies.
> >
> > Fixes: f9d8c3c4236ef2a1c15b01200b9d164e2c5a54c7 ("block2mtd: port device access to files")
> > Assisted-by: Gemini:gemini-3.1-pro-preview Gemini:gemini-3-flash-preview
> > Reported-by: syzbot+65459fd3b61877d717a3@syzkaller.appspotmail.com
> > Link: https://syzkaller.appspot.com/bug?extid=65459fd3b61877d717a3
> > Link: https://syzkaller.appspot.com/ai_job?id=c3c46711-9492-41e5-bcb4-4fb68a746c23
> > To: <joern@lazybastard.org>
> > To: <linux-mtd@lists.infradead.org>
> > Cc: <linux-kernel@vger.kernel.org>
> > Cc: <miquel.raynal@bootlin.com>
> > Cc: <richard@nod.at>
> > Cc: <vigneshr@ti.com>
> >
> > ---
> > v2:
> > - Added comments in block2mtd_init() and block2mtd_exit() explaining the need for block2mtd_mutex to protect against concurrent sysfs writes.
> >
> > v1:
> > https://lore.kernel.org/all/9ceb3eb3-40e2-497b-8d68-257fd88a3946@mail.kernel.org/T/
> > ---
> > diff --git a/drivers/mtd/devices/block2mtd.c b/drivers/mtd/devices/block2mtd.c
> > index 03e80b2c4..42da6b9a5 100644
> > --- a/drivers/mtd/devices/block2mtd.c
> > +++ b/drivers/mtd/devices/block2mtd.c
> > @@ -45,7 +45,7 @@ struct block2mtd_dev {
> >
> >  /* Static info about the MTD, used in cleanup_module */
> >  static LIST_HEAD(blkmtd_device_list);
> > -
> > +static DEFINE_MUTEX(block2mtd_mutex);
> >
> >  static struct page *page_read(struct address_space *mapping, pgoff_t index)
> >  {
> > @@ -464,28 +464,43 @@ static int block2mtd_setup2(const char *val)
> >
> >  static int block2mtd_setup(const char *val, const struct kernel_param *kp)
> >  {
> > +       int ret = 0;
> > +
> > +       /*
> > +        * Drop the param_lock to avoid circular locking dependency
> > +        * with VFS locks during device lookup.
> > +        */
> > +       kernel_param_unlock(kp->mod);
> > +
> > +       mutex_lock(&block2mtd_mutex);
> > +
> >  #ifdef MODULE
> > -       return block2mtd_setup2(val);
> > +       ret = block2mtd_setup2(val);
> >  #else
> >         /* If more parameters are later passed in via
> >            /sys/module/block2mtd/parameters/block2mtd
> >            and block2mtd_init() has already been called,
> >            we can parse the argument now. */
> >
> > -       if (block2mtd_init_called)
> > -               return block2mtd_setup2(val);
> > +       if (block2mtd_init_called) {
> > +               ret = block2mtd_setup2(val);
> > +       } else {
> > +               /* During early boot stage, we only save the parameters
> > +                  here. We must parse them later: if the param passed
> > +                  from kernel boot command line, block2mtd_setup() is
> > +                  called so early that it is not possible to resolve
> > +                  the device (even kmalloc() fails). Deter that work to
> > +                  block2mtd_setup2(). */
> > +
> > +               strscpy(block2mtd_paramline, val, sizeof(block2mtd_paramline));
> > +       }
> > +#endif
> >
> > -       /* During early boot stage, we only save the parameters
> > -          here. We must parse them later: if the param passed
> > -          from kernel boot command line, block2mtd_setup() is
> > -          called so early that it is not possible to resolve
> > -          the device (even kmalloc() fails). Deter that work to
> > -          block2mtd_setup2(). */
> > +       mutex_unlock(&block2mtd_mutex);
> >
> > -       strscpy(block2mtd_paramline, val, sizeof(block2mtd_paramline));
> > +       kernel_param_lock(kp->mod);
> >
> > -       return 0;
> > -#endif
> > +       return ret;
> >  }
> >
> >
> > @@ -497,9 +512,15 @@ static int __init block2mtd_init(void)
> >         int ret = 0;
> >
> >  #ifndef MODULE
> > +       /*
> > +        * block2mtd_mutex protects block2mtd_init_called and
> > +        * block2mtd_paramline against concurrent sysfs writes.
> > +        */
> > +       mutex_lock(&block2mtd_mutex);
> >         if (strlen(block2mtd_paramline))
> >                 ret = block2mtd_setup2(block2mtd_paramline);
> >         block2mtd_init_called = 1;
> > +       mutex_unlock(&block2mtd_mutex);
> >  #endif
> >
> >         return ret;
> > @@ -511,6 +532,11 @@ static void block2mtd_exit(void)
> >         struct list_head *pos, *next;
> >
> >         /* Remove the MTD devices */
> > +       /*
> > +        * block2mtd_mutex protects blkmtd_device_list against
> > +        * concurrent sysfs writes.
> > +        */
> > +       mutex_lock(&block2mtd_mutex);
> >         list_for_each_safe(pos, next, &blkmtd_device_list) {
> >                 struct block2mtd_dev *dev = list_entry(pos, typeof(*dev), list);
> >                 block2mtd_sync(&dev->mtd);
> > @@ -522,6 +548,7 @@ static void block2mtd_exit(void)
> >                 list_del(&dev->list);
> >                 block2mtd_free_device(dev);
> >         }
> > +       mutex_unlock(&block2mtd_mutex);
> >  }
> >
> >  late_initcall(block2mtd_init);
>
>   The deadlock resolution is correct, but dropping  param_lock
> exposes a critical Use-After-Free (UAF) race condition during module
> unloading.
>
>   Because sysfs writes do not hold a module reference,  delete_module
> (rmmod) can proceed concurrently with an active sysfs parameter write.
>
>   1.  rmmod  starts, sets module state to  GOING , and calls  block2mtd_exit() .
>   2.  block2mtd_exit()  acquires  block2mtd_mutex , unregisters all
> active devices, clears  blkmtd_device_list , and releases
> block2mtd_mutex .
>   3. A concurrent sysfs write (which dropped  param_lock  to avoid the
> deadlock and was blocked on  block2mtd_mutex ) now acquires the mutex.
>   4. It calls  block2mtd_setup2()  $\rightarrow$  add_device() ,
> registers a new MTD device, and adds it to  blkmtd_device_list .
>   5. The sysfs write releases  block2mtd_mutex  and completes.
>   6.  delete_module  completes and frees the module memory.
>
>   This leaves an active MTD device registered in the kernel pointing
> to freed module code ( dev->mtd._read , etc.), leading to an immediate
> kernel panic on next access.
>
>   To prevent this, we must serialize the module exit state. Introduce
> a  block2mtd_exiting  flag synchronized by  block2mtd_mutex  to reject
> new registrations during unload.
>
>     diff --git a/drivers/mtd/devices/block2mtd.c
> b/drivers/mtd/devices/block2mtd.c
>     index f813272dad88..b12a84cf0e12 100644
>     --- a/drivers/mtd/devices/block2mtd.c
>     +++ b/drivers/mtd/devices/block2mtd.c
>     @@ -46,6 +46,7 @@ struct block2mtd_dev {
>      /* Static info about the MTD, used in cleanup_module */
>      static LIST_HEAD(blkmtd_device_list);
>      static DEFINE_MUTEX(block2mtd_mutex);
>     +static bool block2mtd_exiting;
>
>      static struct page *page_read(struct address_space *mapping, pgoff_t index)
>      {
>     @@ -477,6 +478,11 @@ static int block2mtd_setup(const char *val,
> const struct kernel_param *kp)
>
>          mutex_lock(&block2mtd_mutex);
>
>     +    if (block2mtd_exiting) {
>     +        ret = -ENODEV;
>     +        goto out_unlock;
>     +    }
>     +
>      #ifdef MODULE
>          ret = block2mtd_setup2(val);
>      #else
>     @@ -498,6 +504,7 @@ static int block2mtd_setup(const char *val,
> const struct kernel_param *kp)
>          }
>      #endif
>
>     +out_unlock:
>          mutex_unlock(&block2mtd_mutex);
>
>          kernel_param_lock(kp->mod);
>     @@ -529,6 +536,7 @@ static void block2mtd_exit(void)
>
>          /* Remove the MTD devices */
>          mutex_lock(&block2mtd_mutex);
>     +    block2mtd_exiting = true;
>          list_for_each_safe(pos, next, &blkmtd_device_list) {
>              struct block2mtd_dev *dev = list_entry(pos, typeof(*dev), list);
>              block2mtd_sync(&dev->mtd);

Another alternative is refcounting:

    static int block2mtd_setup(const char *val, const struct kernel_param *kp) {
           ...
           // Try to pin the module before dropping param_lock
           if (kp->mod && !try_module_get(kp->mod))
                  return -ENODEV; // Module is already unloading

           kernel_param_unlock(kp->mod);
           mutex_lock(&block2mtd_mutex);
           // critical section (VFS lookup & add_device)
           mutex_unlock(&block2mtd_mutex);
           kernel_param_lock(kp->mod);

           if (kp->mod)
                  module_put(kp->mod);
           ...
    }
