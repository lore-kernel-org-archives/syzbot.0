Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 940D1481FDD
	for <syzbot@lists.linux.dev>; Mon, 18 May 2026 16:36:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=10.30.226.201
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779122203; cv=pass; b=HIfaA10sMLehWtq2inPZ9P4CB2hYUjCvnDjeuvNIDG7iBOMu6z6pcgfcdKF+qp8zkJs1dxr5lXVWgZnjUy07ufzRBF8THSEBGI7TNLyEgk8keWOK3nuCyeX56D5sDXINLgKvzW9vhcVSEBfhWUTdHn/UoEzNKm8ZDSBgWP7EmO4=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779122203; c=relaxed/simple;
	bh=ZwVqFA/y4xjXfxKj9jVxQCpU4STj7CymA01t7kvmvQc=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=Y6pOAzfAfppThEt/hGMRTlGrlw/nZhHoyCV+ghX61r4H3A10g9XViKRGfstnvidfB7Rf8PnW29x/tT3EJcabsM6lUGky/r0ikDArc92VrjgJoY0tnRib0s5cjiH9o3yo2SnI0otv6KZoxdZ1y8y2jKYdHQQnmmoePaqomXf3b0Y=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=wdvpmKTE; arc=pass smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="wdvpmKTE"
Received: by smtp.kernel.org (Postfix)
	id 33A63C2BCC6; Mon, 18 May 2026 16:36:43 +0000 (UTC)
Received: from mail-oa1-f41.google.com (mail-oa1-f41.google.com [209.85.160.41])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp.kernel.org (Postfix) with ESMTPS id 4462AC2BCB7
	for <syzbot@kernel.org>; Mon, 18 May 2026 16:36:42 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 smtp.kernel.org 4462AC2BCB7
Authentication-Results: smtp.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.kernel.org; spf=pass smtp.mailfrom=google.com
Received: by mail-oa1-f41.google.com with SMTP id 586e51a60fabf-40ea36b56b7so2046755fac.3
        for <syzbot@kernel.org>; Mon, 18 May 2026 09:36:42 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1779122201; cv=none;
        d=google.com; s=arc-20240605;
        b=OF5Z/BOAHRqKfzUNByaycu7JqLHxb1HxuhZ21YVReP8uPDYqnfHwuIB8shvrUvqVkO
         i3An0NTL/EaR5piFQaTAhwpyY5geYkpvMldpASupEiDh7VaEWzOhcNmBLajsPfkI4deu
         /A62paiYFkm1I9e0MPjuUd0E+mqNZ7NVBOdVatQ8Ifm43BT7xh+bOKHpkZZyeLhRrrFM
         9bWb1AqLeCADC6pn/alKYHQQUla8iVpyZLFFGjPTNm5ogcdWrceT/LdVjFekVu3OrMOu
         jSBkmYUG//qpHhNPg1+X1OjQGpAoiUmhfc71Q8Yy9pGstX4vxcbeZKdkcpnBmWf+Lm0X
         AG5w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=k5qUZimRgG7xO+fY4RwExJiTtp7KzrVmDg7WzhsoOeA=;
        fh=2Ld/g5BVZzBadtquf8mrXl84q+iOtbUed/2ECOFnmmI=;
        b=Hy/xrODbUO5+vCvGEv7KWZ8on/uoOfcL4+rLYisdSlsV+Rq3/lBSWB1o2Mh5bG7eOT
         PUQ1XvHjNyqmreV3prStHLURaDNa0gqN90eh08Mkb0Kyr3Pdc/GWOgQ4jmep0dzjGTRs
         NJu1veImArYDooj3ufx7c/gjrXAWOkR5GWMbB47J/spK29Hq1sx6+S9bCnYtPyNRxAwv
         5pPb8wtMHxBMzibmuc404tCjts37I9kCGDxZRHvL7gARl43gfTIJVPtdpfbjLBgfh14Z
         ZKwYapRJFYcl2b7JjFO1sLFe54vAFmOHywhZUHjfNoYgS8X9jrAQJoEE11VBDDQjQp+l
         9GOQ==;
        darn=kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1779122201; x=1779727001; darn=kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=k5qUZimRgG7xO+fY4RwExJiTtp7KzrVmDg7WzhsoOeA=;
        b=wdvpmKTEonhkDxBGBMxjpVukgzYfma3aF5Nrv25+5tX9bYnAAsr770hgWkjg4YNZ6Z
         kujn7pNueWo2U3g6ucG9aaKmS/X54Nq5UhJ8Zq8agzb+YZFoob65rMTgdihaY6xJVVzk
         mt0bRhsZXIsVtcFiQ/mRWR3xBTx2qojyKF+mbZLRWPEqwm1GpUTMSZE1EHtK+aYmTOBv
         LZ7iHmuuSWn6+C4Aa9GcRHI4yHxWkyBj0MSozePe+dw+L4Le9VmIXD6VuAHdipODtYtf
         34BQ6lDcGJQDSKyXaF0SbB0fPZKpk+VQg8fuUYBQBXX9ri/5KSwnzxGMYRi6bGnjBHUK
         ILng==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1779122201; x=1779727001;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=k5qUZimRgG7xO+fY4RwExJiTtp7KzrVmDg7WzhsoOeA=;
        b=HEX+jh1XBABNjrcKqMEvky09SccIYn/5r2OMkmMRnT52Ay8ZZtf2VPas0Gb0fQ9gOT
         CgpYN+ur8XxFAbyz7a7l12TOWaijp+WS46ptJWDnMFFFQlxUWFJxL0S8+9vXReqobvLr
         o9CieyqgPLQ9d9e8Gp+PnYv24pWdqx0HLbt9Jxe8AwNzBfG3P1VETiOU6pprEoS+Bmvx
         WBCzvY4fxm1+uJS1ax0GIsywBIe1D+r+k2MtWvioNwGIaNzLlWWqy0B6bHuax4nPjloF
         h4Xf6GmW4vQUpGUYPpe6lmGCw2L6N3ZzD5mqjjHQTDRPOQICOlSgALa8I+uILUNwRV5B
         j41w==
X-Gm-Message-State: AOJu0YyalnnkQEBuTh5AlK9cTPwGO6VNnx1fXX+XMqqfHei7tascsGDD
	Fo3sYXDP3Nv1tcgG+HfAls2NHLR8C4ujx36W9EczATUL74W4JjCX7jR71J7KviXElko75nZrY/A
	51jRQuq6DAq13LEFOR7bTayG20Z5+eo1hYWsqoXWEswend0PrD/4g/AYP
X-Gm-Gg: Acq92OFcIKqBzKiBBDEPmzi2grTO0En41QSdVMmdmyxT4+I2EJV3uieAhWJt17Jxziv
	PJW4+g0bJAu5BASUJu72NqOonQhmmj7U7rznozLInoBxqkLeHUkY5M2guVxJr+WqWDVb4LvQFra
	SLhwWYm8MqE0bdbjavgGq3x7z57EWZNVnP4XSj6YYnLiHXwXNg9F2rXDmLhcenj3q5b7x7gFqvZ
	3pI0Age/mVvIGa2zsfWLpPzV7ZZ3TyYWcEmsAz+wtTqlCdTdvxSjZSwfAaJYfowGr/7wVxi+fvT
	z0Fe2amSb2+cm+B4zjfp04SqxT2YTslce1xUPRY5XxvGOiChatlEIE1GGgoPPq7eu57KpQ9vpfk
	jie8ABtrwiNpxoTBC
X-Received: by 2002:a05:6870:88a6:b0:42f:d3f1:6b7b with SMTP id
 586e51a60fabf-43a2dd3be58mr10240560fac.21.1779122200853; Mon, 18 May 2026
 09:36:40 -0700 (PDT)
Precedence: bulk
X-Mailing-List: syzbot@lists.linux.dev
List-Id: <syzbot.lists.linux.dev>
List-Subscribe: <mailto:syzbot+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:syzbot+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <9cbc091e-97f8-41a3-97eb-c1f2137ccc53@mail.kernel.org>
In-Reply-To: <9cbc091e-97f8-41a3-97eb-c1f2137ccc53@mail.kernel.org>
From: Aleksandr Nogikh <nogikh@google.com>
Date: Mon, 18 May 2026 18:36:29 +0200
X-Gm-Features: AVHnY4Kd-j_Uxgb6VZH7OLXvHOL3CvP24WLOc0O5mYlhRigid26yXiJvdKXWOTc
Message-ID: <CANp29Y7xJRyazoWXRv=ZdxFk=gqek2LgN82Kr=dtDLdBnjn_Vw@mail.gmail.com>
Subject: Re: [PATCH RFC] drm/lease: Fix warning on large user-controlled allocations
To: syzbot <syzbot@kernel.org>
Cc: syzkaller-upstream-moderation@googlegroups.com, syzbot@lists.linux.dev
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

... and after some more fixes

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
