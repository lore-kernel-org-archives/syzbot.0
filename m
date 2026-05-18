Received: from mail-oi1-f177.google.com (mail-oi1-f177.google.com [209.85.167.177])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 44D6040FDBC
	for <syzbot@lists.linux.dev>; Mon, 18 May 2026 12:36:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.167.177
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779107777; cv=pass; b=DAlwBw2WPEDsM5LNIdZSz4pWo5v6fVm/zNp7iowGbth+l62Zzs2dlrnZDIuJuIaqsQHe2Ma5R7w8s3T/Qvw5UrGmfDxasR+64sdVojtx/DZsC0cEux6OhdVvHEjuzW1AVtR91nJmetYWaYnhEeVTC5MMc5z7B/iD1Q2OVQJnOjU=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779107777; c=relaxed/simple;
	bh=69P60C0UAVX5tmKNciJZuP8chY3/N8hIwiomQWvrSfI=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=r+4oUmeQIyZBfOFjxKAgh036YgR/OPW/VrabVEj+E2wDWJczy+zPrZ1spAfqdJoQ2Pk+zXb+n7+kx/hF/WWoDHvt2yy8ZQMb65nIM2w5k97qZWXjSsYa4ZQs99qsl7wUrnIf1dD+eYWynNt46qa3+/SsO9CVGEsCCjd5s4Cy8h4=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=HG/2VgBW; arc=pass smtp.client-ip=209.85.167.177
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="HG/2VgBW"
Received: by mail-oi1-f177.google.com with SMTP id 5614622812f47-479e6bc357eso707277b6e.2
        for <syzbot@lists.linux.dev>; Mon, 18 May 2026 05:36:15 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1779107775; cv=none;
        d=google.com; s=arc-20240605;
        b=bJ3mOc4NoVPSOepdmWB2P4CHdNaEo0VeDbqpjdfRSLHIRan02ncIdEEcmzGl8KuZIa
         lSiXrfn1y23SlIITqFJfLXt4+0Rw90z9mzIqv/4TnN3DMg0FWPPfj6XM2Ef+v/4yQW/v
         vbJRZvT04+RkDU3Wq4gZkgSdE2wNz3j0MPWkD+7LrK2xRKH49ZbrIoXNnU9vnc/B5zXw
         hhDrYbCUTOwkoQm9IRNuaGoYF/jtddoLAIu48skadxZt6V6scDYRv/27b3FHL0Qfmxtl
         Fh65/iHjMen4Ljdn56/66NhnScxmYyFEBMyPVxMX0fvyhG57DR1hZ32mKQNHYawno41K
         5mQA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=1cUEnlcqB6W0ZGISALgI3VCu+no8s1oOcMKsY/Kl9zk=;
        fh=fS/5ZdwDpwTwxyjD1BS23gTbTmUzUxhuZq6EY7WDyJg=;
        b=T/WN5Rbp5Wm6aGWie0V2ffQmD7vab45JTirMeUhcRNYW+CbWj8/07vNoWnsELq46xk
         kZQkd+WgZcLMT6lGUvjWVqJDkDk++TsiiJiGaLeWjP+woRm15gPANTYsYtaa9f8FPvnv
         pvQKM64p12BGMIr8RimzXDNEA3Ia8zouGsWZzqxaTb/z16hen2yjgCtTUSbiCq66RtXi
         +QHwXbQUobs4mrcxkNInDjIb++8ctLBQimCCQXudctOQOtRQ45WPLA6bCvDQuxbZFfHW
         RWpK9cHcPW+0dmo490bHkrrGz2kEZRvRVnxpsMERv5xmLMc0lAkZzZhiYvkxvn6RGkZm
         atmQ==;
        darn=lists.linux.dev
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1779107775; x=1779712575; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=1cUEnlcqB6W0ZGISALgI3VCu+no8s1oOcMKsY/Kl9zk=;
        b=HG/2VgBWPOTIzprzlInM9Y+pQ02S/QEgWVFguZIKYxflIcoSa6J+3o10a1iiR0vuKI
         NE1vFf7Xus3PRh+LFptEN9qy35ob4B6qVo7DHhiNMEjO1dAnegG/6XBb+vAPM2bbUP8a
         Azg5tHStFMZocalDJb/yGGfFSXjN8Zry6bZ/pnwZOqDTFoW8KFtkZcmALXqjPFbXebJz
         g436XXaf+fA1FTFjf8zZGU2Ur9JXqREslva6NGuyh218BEpn5ZaymBPUFdRGC28cevFX
         UKqFIvZ8R8NQohBf+rmZCAiFizN7kxQygdFZNVIcfHEaZlO0umu9jeyxTdkYYjfd3elH
         Yzcg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1779107775; x=1779712575;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=1cUEnlcqB6W0ZGISALgI3VCu+no8s1oOcMKsY/Kl9zk=;
        b=jplPfR60+TKA8Ezqvcph7YBEi0pSiOyqV/2BP/IHGHLRsKHYI6qjef5SQPcSqs6SDz
         fxL7i3c24yu8s3xpTVTDkGOCdSmtqk1aqc6oSPD92CtYFvJ1EjJmXctak4LZOhegC6Pz
         upcRLfM+w/QHkfHiZwxQI3RecdUfehspsD2eClRKd4PK51bnKFhGYYdMs8i/LWi8AXGA
         pByohfwDWUwl2Dw0jXzF04YwvCxsZAV45dISCctzuyGwotiOYESGlK1Vqjq2zS8G6cvs
         xViX3sQIJK31tNpWejv+/BQexL72sTwDQec62h53niD072ryMHEZJztD6X4ri7HKJ765
         zPrQ==
X-Forwarded-Encrypted: i=1; AFNElJ/Lme0u0EjT3i6DyNo8bcZ8Q7E9HQQNEBYe6m/vIG53oWcpizgy3LYYQoKblRFWnTCTSTVOaLk=@lists.linux.dev
X-Gm-Message-State: AOJu0YyR9ng7KXcP5Qv6XZaF7NiuCUDIXK+JtgHDAzI+X2FjacXRWOlk
	2iOW6n2xayF2r16ZB2UQ6h7zVnuErmHmCSfl62JRkvBqlQy3tyWOE5LQwgBdpBlWK4BRl7x7xPy
	Gm9qjCmliOOnnUU4NVbhBRcD7ROfG7qse52JwcdPm
X-Gm-Gg: Acq92OFk5uvBXHVUekQlWJfXRMehzuSX831b8Bl4eJDDrFiarCBVwG57NHHMykbSTtO
	H0rQ+CS0vMUj/s/XvteEQGve0jALeFCqa4kOgkB72p949gM4iHsa+hZm4jloaMcgFmE6nDPR95q
	E4l15BqlsAsW/2yziSgZYP2cGp5yy0rUvYm+trRKvMANwa2Z88V7aWAgkQjCg1SlY4hzTETNNT3
	G4HRQ7JaYrTF4zQZW9YBjiYDbX/FGc9IqKfvYu+4Fe8AKyAFKNemXfLRGJOuSO6LBiEVEWTcPOY
	w6isVap6lf2mzBkAEckmt/rDhXbhIS+cWTkubgI3RhUpXbv7XGzZw8DhTtdEDxBo2QhLr0PpgXs
	VXFttirPeCzjOtDA=
X-Received: by 2002:a05:6808:c2d8:b0:479:e75e:e3 with SMTP id
 5614622812f47-482e57cf36dmr10291162b6e.43.1779107774657; Mon, 18 May 2026
 05:36:14 -0700 (PDT)
Precedence: bulk
X-Mailing-List: syzbot@lists.linux.dev
List-Id: <syzbot.lists.linux.dev>
List-Subscribe: <mailto:syzbot+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:syzbot+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <9cbc091e-97f8-41a3-97eb-c1f2137ccc53@mail.kernel.org>
In-Reply-To: <9cbc091e-97f8-41a3-97eb-c1f2137ccc53@mail.kernel.org>
From: Aleksandr Nogikh <nogikh@google.com>
Date: Mon, 18 May 2026 14:36:02 +0200
X-Gm-Features: AVHnY4LlS69jlG8hyWp_ycUFz1u0ap6wqGOwV8mlc3OIclCIBHhvtN2x1RJU0pg
Message-ID: <CANp29Y7fBpjFOmWLZp-6RtOksJrNqM3kBzKGBZAXmDNLw3okyQ@mail.gmail.com>
Subject: Re: [PATCH RFC] drm/lease: Fix warning on large user-controlled allocations
To: syzbot <syzbot@kernel.org>
Cc: syzkaller-upstream-moderation@googlegroups.com, syzbot@lists.linux.dev
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

... and with one more fix on syz-cluster side

#syz upstream

On Thu, May 14, 2026 at 12:26=E2=80=AFAM 'syzbot' via
syzkaller-upstream-moderation
<syzkaller-upstream-moderation@googlegroups.com> wrote:
>
> In drm_mode_create_lease_ioctl(), a user-provided object_count is used
> to allocate memory for object_ids and objects. When a user requests a
> massive number of objects, the allocation size can exceed the maximum
> contiguous physical memory limit (MAX_PAGE_ORDER). Since kzalloc_objs()
> defaults to GFP_KERNEL without __GFP_NOWARN, this triggers a
> WARN_ON_ONCE_GFP in the page allocator.
>
> To fix this, replace kzalloc_objs() with kvzalloc_objs() in
> fill_object_idr() and memdup_array_user() with vmemdup_array_user() in
> drm_mode_create_lease_ioctl(). This allows the allocations to gracefully
> fall back to virtually contiguous memory (vmalloc) if the requested size
> is too large or physical memory is fragmented, preventing the warning
> and allowing large lease requests to succeed or fail gracefully with
> -ENOMEM. Update the corresponding kfree() calls to kvfree() accordingly.
>
> Fixes: 62884cd386b876638720ef88374b31a84ca7ee5f ("drm: Add four ioctls fo=
r managing drm mode object leases [v7]")
> Assisted-by: Gemini:gemini-3.1-pro-preview Gemini:gemini-3-flash-preview
> Reported-by: syzbot+03fb58296859d8dbab4d@syzkaller.appspotmail.com
> Link: https://syzkaller.appspot.com/bug?extid=3D03fb58296859d8dbab4d
> Link: https://syzkaller.appspot.com/ai_job?id=3Dd9152b5a-380f-4c4e-af5b-1=
890078e5d46
> To: <airlied@gmail.com>
> To: <dri-devel@lists.freedesktop.org>
> To: <maarten.lankhorst@linux.intel.com>
> To: <mripard@kernel.org>
> To: <simona@ffwll.ch>
> To: <tzimmermann@suse.de>
> Cc: <linux-kernel@vger.kernel.org>
>
> ---
> diff --git a/drivers/gpu/drm/drm_lease.c b/drivers/gpu/drm/drm_lease.c
> index 5d2cf724c..9ccfa4712 100644
> --- a/drivers/gpu/drm/drm_lease.c
> +++ b/drivers/gpu/drm/drm_lease.c
> @@ -386,7 +386,7 @@ static int fill_object_idr(struct drm_device *dev,
>         int ret;
>         bool universal_planes =3D READ_ONCE(lessor_priv->universal_planes=
);
>
> -       objects =3D kzalloc_objs(struct drm_mode_object *, object_count);
> +       objects =3D kvzalloc_objs(struct drm_mode_object *, object_count)=
;
>         if (!objects)
>                 return -ENOMEM;
>
> @@ -462,7 +462,7 @@ static int fill_object_idr(struct drm_device *dev,
>                 if (objects[o])
>                         drm_mode_object_put(objects[o]);
>         }
> -       kfree(objects);
> +       kvfree(objects);
>         return ret;
>  }
>
> @@ -509,8 +509,8 @@ int drm_mode_create_lease_ioctl(struct drm_device *de=
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
> @@ -520,7 +520,7 @@ int drm_mode_create_lease_ioctl(struct drm_device *de=
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
> base-commit: 5d6919055dec134de3c40167a490f33c74c12581
> --
> This is an AI-generated patch subject to moderation.
> Reply with '#syz upstream' to send it to the mailing list.
> Reply with '#syz reject' to reject it.
>
> See  for more information.
>
> --
> You received this message because you are subscribed to the Google Groups=
 "syzkaller-upstream-moderation" group.
> To unsubscribe from this group and stop receiving emails from it, send an=
 email to syzkaller-upstream-moderation+unsubscribe@googlegroups.com.
> To view this discussion visit https://groups.google.com/d/msgid/syzkaller=
-upstream-moderation/9cbc091e-97f8-41a3-97eb-c1f2137ccc53%40mail.kernel.org=
.
