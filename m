Received: from mail-oo1-f52.google.com (mail-oo1-f52.google.com [209.85.161.52])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EDAD519F137
	for <syzbot@lists.linux.dev>; Thu, 18 Jun 2026 15:12:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.161.52
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781795555; cv=pass; b=EDTLnbQ0Exq/Case/qaDy87VWKIY3bdzdl93EIM8t/hEPGQdGyrTRdn2X0cA3l9zZHy/O31RLWCRUaKhdtbfWJrGxOyKz/xe2Rp942eozk4sUib2J+oWbuosLdKOJoR3fh6szzQU0RKOoK0hv5XHgRK3pq8HNc187/tGwqbH8SA=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781795555; c=relaxed/simple;
	bh=TDVWqDFZ2c/hAmk/oyx8efUAphnTYInFgNZYqz2jlqU=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=ZvO56oTOABM0zxo6E0ObLK9jo6Fq9NfgugnnhDT1De+vsEHuENQqRV8RRY7IuT7/k6iE3rm/svkflqrP/ZxYzduNqvT0V1oYQT1lCjR4SuCIg7rJDbEsTD4uZUz97iQeKxFyxGC5mL7Sbmg5v7nwOMbOtnyON1vq84oGlqX4KKM=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=sIBVNJYA; arc=pass smtp.client-ip=209.85.161.52
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="sIBVNJYA"
Received: by mail-oo1-f52.google.com with SMTP id 006d021491bc7-69e8a8608d7so694367eaf.0
        for <syzbot@lists.linux.dev>; Thu, 18 Jun 2026 08:12:33 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1781795553; cv=none;
        d=google.com; s=arc-20240605;
        b=dW/6Z9QDXdBgVzdJnPTBglLOSJDDZ7DNHno+FnvpsTDqTNbvqM1MLX0gOmfcXlJ6Ai
         PSV6vtOTI6loyyFXQhlKrk18yaSM2mRfMs6+jVHLqpSlLS+oLfv7XuV0MQwhE2iQFtg3
         E/eJk2fY/5BvBvOmQENJda6HMtMPIFAynvgBb7M6pdEjfD3DhpvT6fkLWzjupZM3t6Dc
         xNPnQPkSvsIKexs+6axZQ3XBu8DP/b+ZjN2jC4g1pWMTgma8qQQTCqpdPYKvZqoJq68E
         fhLpMCP5jgJ/zgc3bAADcbLXMlgYCGuhvYQt3LUGq5EF6ea2K9hVQjuf6GItygqx/wA0
         g2bQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=C4Z6QF8BOQRoqoKlNS6Rua5hJomt7XSV34EX413EyyU=;
        fh=HvEoTMTdRM+8l4+Djac9uLgYc5KO+ENuq2tFtXy7UGc=;
        b=cgcawP7KgWBPT87oRT8BHo1EO9k2X2F40zslqBsHkW/HsbvmP7cGa1jfiwV46GDGCN
         dzXNb3l+PQZaz0XD5QacNczS0NEPHGxRV9ergxjULdr88ZeqsMbk2S++FTmFU3/vMyG0
         xv/k0zMHcxv1e+/EGVJsFlbIHOtp+CDf9FWf+1AXJlco9798IzsHlvGyUTp02QacvFmI
         vWUM0QVARkO4SOLJsUpE3uuRc5SmQDswsmJhz8gsHpH7NT3/B+scV1R4JG+SOOUxstqn
         QLAednQ86tFNOpZseCNDR5aRcIivA3pFNNLW85xYfG5jjx8c5v0hvTdNENPVEwgRt3g4
         ymxw==;
        darn=lists.linux.dev
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1781795553; x=1782400353; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=C4Z6QF8BOQRoqoKlNS6Rua5hJomt7XSV34EX413EyyU=;
        b=sIBVNJYARPRUD9JmbBAI633GnKnLu+f1/2g5Y+90sY+0woUb+lOllRa5AEtoCSrMkr
         4oj27zEf30nN9Kv1Ch9xbwhXmzgx4MQHBMMzXcZby5ehdNfzidGBAuaVknj7gougem+s
         duJeTP6FR5L84C6PzBbg1vegYmGrQljx4HY/Agmhlx/Fm6DzFhwvXZ60SlVm/2PGvNNy
         hpE05RQ3v/cnnqBdeViecqdw7t9LkMth59PliPdRydV9u1upnFEbQqNUn1IL4ql3uiIT
         z8qaCgd1uxVCCvSNVDo+m1Iwv5kPXS76vOpUT+cHxEf44vvdz8+W27u3B/GBFZOqY6R5
         LC2g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1781795553; x=1782400353;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=C4Z6QF8BOQRoqoKlNS6Rua5hJomt7XSV34EX413EyyU=;
        b=s/PIVcPQXsxO5RYYgV5Br5MXC6V7x71JOqhyb6NZJG+qZ6KHyR/4ldI/q0vW4MN6mK
         FsJc1MTRDCeea5ze4+CbVnPsZEeC9aMjT/YEIbguN7ecR7bVaGXw9Oxcw6HDxpknIc7g
         R1rQVWoM6S2DS7Qtnc4QxYnBeehGc6hJSYk/xBWKAxKD1kYj89JXQ0T0vUX6bcPeqoYG
         3bVZbWwg+eXZ2KotO3misl3fvoTO4XQG66FPB9Au6fRzV3ccve9C0HdXXiG4FrexIJpr
         xBCrqOFDBtKgdJ2I+RrGI/luM2Y8/59Fds3Y067bEMK5k7kdOxkV6D+MPktTy4qakkJG
         nOJA==
X-Forwarded-Encrypted: i=1; AFNElJ/KmFULNtYgDgoKx2U/VrmQM9YExYXL1HTnjzfJZgHb48J6iNy9nbbPbMjD1GRUKisVedHRqqQ=@lists.linux.dev
X-Gm-Message-State: AOJu0Yzjkf2DtTmOLjMl10fD9W6JiOCcU0pYxcIemMHWfWGCbTzvRXhQ
	KBGMye9feBxcHAef7MfBD0C1pTJyC7aqk2GR0QwIWVXCJGp35OKiME873cmscAn62c/vFZd2WFx
	MvcMdmdv26G8M4OAYd9j77bc4+gQ6hRlI56auUu+w
X-Gm-Gg: Acq92OFrbf6UKSi4fWmDoe7E/Tic+ZujVDE1Cjw3TxrP/g4P7Z6i6xoUeM6bwAiqozc
	ShFTo1OT7RZk+tPJyGagvZxtrKF6Cwc2yOftjSCuBkQBOKzYtHFn8uZ1HoICsAuq15Cn1u78als
	BYUYiAYEXf5peNVXcPuIrF1DvckXC4sSDIy9RNssCyZTH7RCE4nbSp3BanxAEHcefYfCcWX0uMN
	xDWo98ti8ljwxX/SxXaDUTilsRXj0eoCCDJNqEndl4K8dYXnKNuWvLMOvZusZMDTIeK+HUodfdY
	MF+6PXj6utnzMX0rpeFHuSk7aVfSQVeGe1U3OOIG0V3Eb/E/KTWIbVpDjQiAsyQQdb2RZJv4FVg
	DYfmg5IBrbx0=
X-Received: by 2002:a05:6820:1622:b0:69e:9a18:14ec with SMTP id
 006d021491bc7-6a0b60eafbcmr6793160eaf.33.1781795552190; Thu, 18 Jun 2026
 08:12:32 -0700 (PDT)
Precedence: bulk
X-Mailing-List: syzbot@lists.linux.dev
List-Id: <syzbot.lists.linux.dev>
List-Subscribe: <mailto:syzbot+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:syzbot+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <46506931-ba8f-4048-ab27-9777411db2fe@mail.kernel.org>
In-Reply-To: <46506931-ba8f-4048-ab27-9777411db2fe@mail.kernel.org>
From: Aleksandr Nogikh <nogikh@google.com>
Date: Thu, 18 Jun 2026 17:12:09 +0200
X-Gm-Features: AVVi8Cf_SoQZ7e1Z1LVK37WGYsIofim_rBB1hXGLMZPXSKKYmmq8qCed7b2qeCk
Message-ID: <CANp29Y6Tzp8DvhmZ7j1ccyYvsNic1mZ=Yp=Nd9vBnjjZ0zBjwQ@mail.gmail.com>
Subject: Re: [PATCH RFC] drm/lease: use kvmalloc for user-controlled allocations
To: syzbot <syzbot@kernel.org>
Cc: syzkaller-upstream-moderation@googlegroups.com, syzbot@lists.linux.dev
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Wasn't drm allocating physically contigious memory blocks on purpose?
But in this patch you are trying to change it to virtual memory allocations=
.

On Mon, Jun 15, 2026 at 6:39=E2=80=AFPM 'syzbot' via
syzkaller-upstream-moderation
<syzkaller-upstream-moderation@googlegroups.com> wrote:
>
> In drm_mode_create_lease_ioctl(), a user-controlled object_count is used =
to
> allocate memory for object_ids and objects. If a user provides a very lar=
ge
> object_count (e.g., 1,000,000), the kernel attempts to allocate a
> contiguous memory chunk that exceeds the maximum allowed size by the slab
> allocator (KMALLOC_MAX_SIZE).
>
> For the objects array, kzalloc_objs() is used, which expands to a standar=
d
> kzalloc() call without the __GFP_NOWARN flag. When the requested size
> exceeds KMALLOC_MAX_SIZE, the SLUB allocator passes the request to the pa=
ge
> allocator, which triggers a WARN_ON_ONCE_GFP because the required page
> order is greater than MAX_PAGE_ORDER:
>
> WARNING: mm/page_alloc.c:5197 at __alloc_frozen_pages_noprof+0x2ce/0x380
> mm/page_alloc.c:5197
> Call Trace:
>  <TASK>
>  alloc_pages_mpol+0x212/0x380 mm/mempolicy.c:2490
>  ___kmalloc_large_node+0x4c/0x120 mm/slub.c:5237
>  __kmalloc_large_node_noprof+0x18/0x90 mm/slub.c:5268
>  __do_kmalloc_node mm/slub.c:5284 [inline]
>  __kmalloc_noprof+0x3e4/0x750 mm/slub.c:5308
>  kmalloc_noprof include/linux/slab.h:954 [inline]
>  kzalloc_noprof include/linux/slab.h:1188 [inline]
>  fill_object_idr drivers/gpu/drm/drm_lease.c:389 [inline]
>  drm_mode_create_lease_ioctl+0x533/0x1ab0 drivers/gpu/drm/drm_lease.c:521
>
> To fix this, replace memdup_array_user() with vmemdup_array_user() and
> kzalloc_objs() with kvcalloc(), along with changing their respective
> kfree() calls to kvfree(). The kvmalloc family of functions attempts a
> kmalloc() first with __GFP_NOWARN applied internally, and gracefully fall=
s
> back to vmalloc() for large allocations. This prevents the kernel warning
> and makes the allocations more robust against memory fragmentation,
> gracefully returning -ENOMEM if the system cannot satisfy the request.
>
> Fixes: 62884cd386b8 ("drm: Add four ioctls for managing drm mode object l=
eases [v7]")
> Assisted-by: Gemini:gemini-3.1-pro-preview syzbot
> Reported-by: syzbot+03fb58296859d8dbab4d@syzkaller.appspotmail.com
> Closes: https://syzkaller.appspot.com/bug?extid=3D03fb58296859d8dbab4d
> Link: https://syzkaller.appspot.com/ai_job?id=3D73f2715e-0f0e-4924-ad92-d=
4ef4f06a14f
> To: "David Airlie" <airlied@gmail.com>
> To: <dri-devel@lists.freedesktop.org>
> To: "Maarten Lankhorst" <maarten.lankhorst@linux.intel.com>
> To: "Maxime Ripard" <mripard@kernel.org>
> To: "Simona Vetter" <simona@ffwll.ch>
> To: "Thomas Zimmermann" <tzimmermann@suse.de>
> Cc: <linux-kernel@vger.kernel.org>
>
> ---
> diff --git a/drivers/gpu/drm/drm_lease.c b/drivers/gpu/drm/drm_lease.c
> index 5d2cf724c..240e0ea6c 100644
> --- a/drivers/gpu/drm/drm_lease.c
> +++ b/drivers/gpu/drm/drm_lease.c
> @@ -386,7 +386,8 @@ static int fill_object_idr(struct drm_device *dev,
>         int ret;
>         bool universal_planes =3D READ_ONCE(lessor_priv->universal_planes=
);
>
> -       objects =3D kzalloc_objs(struct drm_mode_object *, object_count);
> +       objects =3D kvcalloc(object_count, sizeof(struct drm_mode_object =
*),
> +                          GFP_KERNEL);
>         if (!objects)
>                 return -ENOMEM;
>
> @@ -462,7 +463,7 @@ static int fill_object_idr(struct drm_device *dev,
>                 if (objects[o])
>                         drm_mode_object_put(objects[o]);
>         }
> -       kfree(objects);
> +       kvfree(objects);
>         return ret;
>  }
>
> @@ -509,8 +510,8 @@ int drm_mode_create_lease_ioctl(struct drm_device *de=
v,
>         /* Handle leased objects, if any */
>         idr_init(&leases);
>         if (object_count !=3D 0) {
> -               object_ids =3D memdup_array_user(u64_to_user_ptr(cl->obje=
ct_ids),
> -                                              object_count, sizeof(__u32=
));
> +               object_ids =3D vmemdup_array_user(u64_to_user_ptr(cl->obj=
ect_ids),
> +                                               object_count, sizeof(__u3=
2));
>                 if (IS_ERR(object_ids)) {
>                         ret =3D PTR_ERR(object_ids);
>                         idr_destroy(&leases);
> @@ -520,7 +521,7 @@ int drm_mode_create_lease_ioctl(struct drm_device *de=
v,
>                 /* fill and validate the object idr */
>                 ret =3D fill_object_idr(dev, lessor_priv, &leases,
>                                       object_count, object_ids);
> -               kfree(object_ids);
> +               kvfree(object_ids);
>                 if (ret) {
>                         drm_dbg_lease(dev, "lease object lookup failed: %=
i\n", ret);
>                         idr_destroy(&leases);
>
>
> base-commit: 8cd9520d35a6c38db6567e97dd93b1f11f185dc6
> --
> This is an AI-generated patch subject to moderation.
> Reply with '#syz upstream' to Sign-off the patch as a human author
> and send it to the upstream kernel mailing lists.
> Reply with '#syz reject' to reject it ('#syz unreject' to undo).
>
> See https://goo.gle/syzbot-ai-patches for information about AI-generated =
patches.
> You can comment on the patch as usual, syzbot will try to address
> the comments and send a new version of the patch if necessary.
> syzbot engineers can be reached at syzkaller@googlegroups.com.
>
> --
> You received this message because you are subscribed to the Google Groups=
 "syzkaller-upstream-moderation" group.
> To unsubscribe from this group and stop receiving emails from it, send an=
 email to syzkaller-upstream-moderation+unsubscribe@googlegroups.com.
> To view this discussion visit https://groups.google.com/d/msgid/syzkaller=
-upstream-moderation/46506931-ba8f-4048-ab27-9777411db2fe%40mail.kernel.org=
.
