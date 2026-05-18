Received: from mail-oa1-f47.google.com (mail-oa1-f47.google.com [209.85.160.47])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5C1D1175A60
	for <syzbot@lists.linux.dev>; Mon, 18 May 2026 08:48:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.160.47
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779094124; cv=pass; b=WphvUYV9+g1Fny8NvuFv9+d1yg97fyjAfYXI6RD77LL7OVoCxXlS95B7YQ6FyfTvQVXgfG84XcsdPtCx+c0MR6RP33zAXWmz8pO00EmQHeXH9eGVwgWJmuxOKbkaCDEuNUqlxCsr2wmbRH70n3QVU5kt1+BILrEwaJc4Af5aO4s=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779094124; c=relaxed/simple;
	bh=rlDI3ImfAOsg3wUGnbnoApz1ozqMLD+4VKlOoZTi7+0=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=jwP65F30wN6tr6G8jF+OIRaVAFXu0zU6QMz8mzWlnxHA0oILfU3qrUWKUpb2d1nSzLEhQ5dB7ycfJqLOog4SmCF2/pZWWLaZrtn1p/d4CSRGXO1KH8X6pMLNsTJDXWaeEVfZhQWn5EHouxnbeCOiAo5zlky9WDcjYEsYuwu5UpI=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=BB7iXuC0; arc=pass smtp.client-ip=209.85.160.47
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="BB7iXuC0"
Received: by mail-oa1-f47.google.com with SMTP id 586e51a60fabf-4042905015cso1799297fac.0
        for <syzbot@lists.linux.dev>; Mon, 18 May 2026 01:48:43 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1779094122; cv=none;
        d=google.com; s=arc-20240605;
        b=UTg00TRxCsf4ZX9ff8aEoOBvCK45UIG713f46mNieFyfDx6uQBl5sB0Tg0uFD7AISM
         McIfTv+gShUfr1uP8EPIYH78BFc4Ft2DI9EoC+sZyxn8H5+NoV2XUsqyBVUdLGabFf5w
         IlQlrB38NTlvhdskKQDC9aZS9Q/eraPM96z3cWSiT7SQxFnxp0vrEI5Y5aRkrR0eV3je
         x3XobCyXyYfLLFDPuFDYOJQJ33clJ9unS7P0tDszwHVuOx2inveF+bnUfh29RlAxrW3a
         RbKKzi5PPHH6H9rI8UviD82igmaqaWnYNb79QjdR9IncKn3vjEU4+oWRSp2VPeVKf7Ca
         lpwA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=g3UWCT7jvSK8kb6zfQ3SQ6urpPEbmnyI9D6ohZJxkHU=;
        fh=izcwBmp/YV2SBwJCHVvrpx7kPtd8XwXfPl+1AyNs7SI=;
        b=OAidKn8tthWi7QF00ICaF04T/V33NNgqASDmpIeT1f0jLGkKsrkB4pgEBLg4jHuWoS
         IrTK+aGVRatB/NAn3O/+ySJY7PND0zzDMpnLRJZDa6jppytJEiqoqLFB8QJMCpAwai0v
         suqSL5ijgwp+ONvjZ8l3Wcu5KOaCOsGdrA6Sim6zoQFZSXdPmyIqk5FKSlu++99GuXz/
         SjpeNZmArJ8s3aMudPVJCCiF9iL2FZdDW/iN46lpyWDuaL9S3FVFhZKcpcZFpQ2hOHQS
         6Sj+li9IN/6DZ8JMyxEYNeStTdtZHDA0y2f9+IC4vQhc8eIPidqqxHu3BcP/7m1gKmck
         x6ZQ==;
        darn=lists.linux.dev
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1779094122; x=1779698922; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=g3UWCT7jvSK8kb6zfQ3SQ6urpPEbmnyI9D6ohZJxkHU=;
        b=BB7iXuC0r1x+gv/m23dG667NgO9zf2j0V8QT5EcnBG0fFwWG4jYWdIl8msE9S7LeVD
         /bt19eIXonSBssApbep/OAxFZnjNZgrZSztTTXZODeh1IofCAhm4MoYQKCewcd+pZtQz
         mRHd9Ga2gc2eIR2HVxNPc0U6AZ0mQ/I/keq2LPBzBYfUMra5szvp+dohZw0b9TKKwOJp
         67KJmULiqaBAqaHd/djl7W9EqZQ4jJqgafFdzaP3TDFFlP+pAWhaYoo4KVyTm/LodIqD
         D1xnZ8hb6S0LpzeXrOCUFoCbwjwOghmCY324m3zT7mr326tzg8x+vOAHiPHmlCYFelcm
         wCNA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1779094122; x=1779698922;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=g3UWCT7jvSK8kb6zfQ3SQ6urpPEbmnyI9D6ohZJxkHU=;
        b=e9q6Y73OD0sdkD5CnpWIniki52m1KGJl5cPz3kLBb4o1TbN7jLyKFwvuECZ/WNk/sp
         5G9Oafe4ssJP7c4w+0sEQwRIutuTlCRaJlJj0PqtQTFgZIDlxDDRDUYpYz4HDREt5O3B
         v9ZOAsQsQ0LF3RicIO7ovPEV1uMudR5H+j8JivL7VaFO9KeWHGYQFAyba6CmJGbjfgV7
         cgUiU0VKCL8BdRtOmNbTtbo2MWbL9NKZPUOLCXnmTMpvNVGQlpwRiGA6UwqE4Xa3ne2K
         I0VkrEsk0FPfWqRGFof/D0exESoaYLVmss3DtAqF1fpy8qRYFh2H6W/yCJLR9VFb2SsY
         G9Nw==
X-Forwarded-Encrypted: i=1; AFNElJ+9cqYn5FQlozC/i1nTE8M8JmVZTq374Wxp3eZPQvdFkhIQ+hKDmpo5cDil8JqGjlzf54gSF9Y=@lists.linux.dev
X-Gm-Message-State: AOJu0Yy9x453luhamCdPgzMTage437IEDDiitTsD2NOsZaxDg5PwC1pf
	GvLBPzH+9UHwPF8SP55A6hS4O+hHmNthv9ri5KU+nEBDE95xfRAj1lCRqWQSMW+80K0vMotvhZh
	Cc6XVxcoYRsqeuYtnFLEjSZ/vrKRCWjUkQFvITo3/
X-Gm-Gg: Acq92OHxaiB3TIQ9kJ/ro2o1mhwui3TfEPc5/5nGRzoG99wqOa19gVbULDlO4Z5q1jr
	xuaplZw5AvbThVxtxnc7O0RBXJlBGjmNig94hEYp001la2FUNJO0ULIlweHaDP5LM/hHE/mabZ7
	S2oi/w+PlODVI/X6iUeNsAmyXJoCfSkO/yswIJWw6y/RvKJbwCqU30wUADt5cE/n/cCuc0pzU0p
	KSC1sJLUBrqn6I7VLQisFmLNG5gwmQV5bZQvhJf60b0TUIvCp1fQvKOfUk+HoieG+Pwuj6Sx0Gh
	cPY/G+T3trWdbI2oC7Z6alL1/Nwd+RTjh9vYlh28ofPtcp3sIXn33hNM5spz6gUAXpRG/67D0Sb
	eTkpn
X-Received: by 2002:a05:6870:5491:b0:439:dc49:6cfd with SMTP id
 586e51a60fabf-43a2de155a4mr8515235fac.37.1779094121769; Mon, 18 May 2026
 01:48:41 -0700 (PDT)
Precedence: bulk
X-Mailing-List: syzbot@lists.linux.dev
List-Id: <syzbot.lists.linux.dev>
List-Subscribe: <mailto:syzbot+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:syzbot+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <9cbc091e-97f8-41a3-97eb-c1f2137ccc53@mail.kernel.org>
In-Reply-To: <9cbc091e-97f8-41a3-97eb-c1f2137ccc53@mail.kernel.org>
From: Aleksandr Nogikh <nogikh@google.com>
Date: Mon, 18 May 2026 10:48:30 +0200
X-Gm-Features: AVHnY4LGj5HJmQHHqE0XQgWDl4XtmbJklq-vxS-SI9sfKerAyE8wx4JvDw_QbeU
Message-ID: <CANp29Y4j=Yy5FnXBmwQsmRJLWdhJjUv1w_uncV6U5k2NzsKHyQ@mail.gmail.com>
Subject: Re: [PATCH RFC] drm/lease: Fix warning on large user-controlled allocations
To: syzbot <syzbot@kernel.org>
Cc: syzkaller-upstream-moderation@googlegroups.com, syzbot@lists.linux.dev
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Let's try again and see if syzbot ci reacts:

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
