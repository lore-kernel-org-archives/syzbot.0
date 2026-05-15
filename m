Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2CFCD40DFC5
	for <syzbot@lists.linux.dev>; Fri, 15 May 2026 09:41:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=10.30.226.201
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778838115; cv=pass; b=cTqoYj4QdxcsmAMGJQjZRLPyVh9THi0oVifXuKpjh+Yy9YhSCwoTCaa9SxfEKMaigKZraaqfjdYunlP9JNLs3yDBtBNSq9Xi2LFcjLcdJ9ZuOyiivkNDH5aHYCD/ospbXKT8I1fPmnPCMdSfdFu2nRK/oukA11Pq8IPwKLyXWKM=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778838115; c=relaxed/simple;
	bh=nesNm7DWWkqQJWEDkbrvp7gou6QPyAO08/D5+8pkt4s=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=Uow8BShgZNDvOxbeJNk5dr2HrpPfkRfZFEZHBOzT2ASy3A6iWxX5D3o0P5w5mKERJZNBIx22azCDxW7210JONCY4HucIKFFHW1PFTOKV65DHk+B2HmffZC5zoG5NJoBNGeJMkkyfIZe+/LxvAc5kII87fKYdIB2b1gDdknZu6ys=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=L+Ezho/5; arc=pass smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="L+Ezho/5"
Received: by smtp.kernel.org (Postfix)
	id 2279EC2BCB8; Fri, 15 May 2026 09:41:55 +0000 (UTC)
Received: from mail-oa1-f45.google.com (mail-oa1-f45.google.com [209.85.160.45])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp.kernel.org (Postfix) with ESMTPS id 347A7C2BCB0
	for <syzbot@kernel.org>; Fri, 15 May 2026 09:41:54 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 smtp.kernel.org 347A7C2BCB0
Authentication-Results: smtp.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.kernel.org; spf=pass smtp.mailfrom=google.com
Received: by mail-oa1-f45.google.com with SMTP id 586e51a60fabf-439cc157c21so1579115fac.1
        for <syzbot@kernel.org>; Fri, 15 May 2026 02:41:53 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1778838113; cv=none;
        d=google.com; s=arc-20240605;
        b=I688Rkui3z0YRdKHhH4sLJQhfxDIn4hOdrv8o0Fmp5U6/nhFTJDqBadVSeXZ+dVg7d
         eNSS2Q1EwD1eeVYcRHl5sLfvcGCHUPlCvKdH+rIUAM4bHiHt05MJD5UDlouqbcCXbZ1j
         Iep+R9cRsK6A5RxwCYLZyOHKKIxfM4Ev/7Bcvute8gBEdNNM7tQ9s3BDs6QiQ4xidGA7
         M1EmT8ouk6VsdEEK/NnaiLun0fQyX5WNTAHiRJrVZkWfeeQxQ1dUk8fd8HfFzv2zbqCk
         h9ox39PhH6+Vykt5ls/osNAhPu1SdoduM6YwyHI0MRu6pKhCJ9vArkcCy+2YyDjzDmPD
         TxzQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=RvYTl5dvrLZcGh8BWF6B4JYD/RaCTxTErQLbyB/pUjc=;
        fh=2Ld/g5BVZzBadtquf8mrXl84q+iOtbUed/2ECOFnmmI=;
        b=MXvYiSM8386UXbGz0DcUeA/OXs8sFf6JlcXPaMNrb5tloyxxq9bgK2/oc942DBOzHN
         GaSpyjZ3rMaIJIB9ousxcLtkIZaAMuh5YkcTIqVON+UsILq4bAo9sGpsiYPYKOpU66td
         gXvMMK6h+u1z+BWRzp3cb/8gortLNyBYgkDXs39t4s98opo8kJzKgq/RyLnjVQgFDYit
         RnRWFGnSMIcM624m15eA9vS2yaOnIdDlBFAiZuRRqzYDhBoJy7JRbUKFpMS88lzLQqxQ
         LBqyFmqulUxqtugAJV9oOOoMp/EhGgR6oK04VOba6VYFssuS4ZNczkAjHLq8YBK9UKJW
         80Tg==;
        darn=kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1778838113; x=1779442913; darn=kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=RvYTl5dvrLZcGh8BWF6B4JYD/RaCTxTErQLbyB/pUjc=;
        b=L+Ezho/5h9zC2P5pb2Xq18wN70m5XR124nS7rI9jYWSNjE/zNecPBcaTx22zPOK/Wz
         JQBk1fH+sKbUQZKW1IHe6KKns/FEOPci2y5YZYU+B3TIx3oVmN1RXQddqS8ehXGnZB1D
         O9zebhqbV24c9gaCmVJsoPwVAQeRzRSfqIo2P6mgbEZc04lKT4hRuVzXtfWvGUAvGgDY
         yxye2PPxMxHPUq7JyhaaubziiTB5yqpX3+Hd/pSB/4bpve/+uqhipABzQ/0sfFZ6SgL6
         ujFmdLuXzoyvqexqtLf5z6PN6G79CYkI3aZFfRz3Gq811j0+sJEnxJeK8pEulycnXsM8
         lQgA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1778838113; x=1779442913;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=RvYTl5dvrLZcGh8BWF6B4JYD/RaCTxTErQLbyB/pUjc=;
        b=U/tqVr1PdGiE4cf9GceKCwH2AKvi/XXotXrpBappWScNE81xp+0Q4WOFiIyO6gi2qv
         26KJmAE1ACg1sYGQMch+EwHfw0e81+lhF6t/r5TVaHMWrUjdaWlismpNXfkD0q8U5i4b
         TTNC7yWvxZSRGErLJKIT+E8Sc7MJSpeXRx2Kn78MRJmxLCkZ3MQhkKsj749VPJamgahb
         cVWYz2kWKbtU8YlD9w+Km7XpLiwH4y3WbnI+tcVvouGrI4AYxsoc//kVW69IoD78vF0m
         p42UhGLJmd2BSkWVt6KkTjp4EFen60gAzfzQ7JZ9kjAzupeZhh8SXCdN22dmiWJwNGuL
         Ah2Q==
X-Gm-Message-State: AOJu0YzkR/UoOR6jdSP56+/j1ZCiZ3gS4upaG83x4b0NFcWssMlQkEMB
	tUPpHMzFnt13ssrVr5QrjAlTQHa9DreCDWpnsQGrjt6aTgu6pl48ZUAtDKJaxCeKX0fQewSvruW
	qc2Jk3T5MAT59HVPPaVT+DBHhVBiyHDn1LL+wj71yxPA59sGU+Qe1NIpQ
X-Gm-Gg: Acq92OG36BMCfXN5XP6r5ASI1cBKCKGnoabikLJ2fbD0lExuFnJoPx8Lp+gKAk4uxwA
	sTO+eXs8kt+S2tq66c41Gfn42gY/1+3IXTpUl92MzczkKV/hRyyPn8KrZln6i9eFVU78MZ+xRUS
	ahGD7WdK0HG7r7WGEb2A/B/f+L/zL97Zjzik54RG+1nNrWtslSsl6WXVfNhEjmwR8LFo2o9QYes
	wGoK8H3D7nI6J2+VSYf7tve9Gbxl+xaFdlEMxUnKO+k960YopUEG1J5D5aba90i1G2OzZoenWL7
	8VynRcBEgOEFUqqxox98QYEDRFSa324RF4/H/dmKKNS6B3nXW/kSJ3RGClL+K3l3QC5CB4/8Y++
	tlVY9
X-Received: by 2002:a05:6870:f201:b0:439:b79f:92da with SMTP id
 586e51a60fabf-43a2de040a5mr2224027fac.26.1778838112475; Fri, 15 May 2026
 02:41:52 -0700 (PDT)
Precedence: bulk
X-Mailing-List: syzbot@lists.linux.dev
List-Id: <syzbot.lists.linux.dev>
List-Subscribe: <mailto:syzbot+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:syzbot+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <9cbc091e-97f8-41a3-97eb-c1f2137ccc53@mail.kernel.org>
In-Reply-To: <9cbc091e-97f8-41a3-97eb-c1f2137ccc53@mail.kernel.org>
From: Aleksandr Nogikh <nogikh@google.com>
Date: Fri, 15 May 2026 11:41:40 +0200
X-Gm-Features: AVHnY4IssnZ23BYUmV0uE8DFGOe80ooErA_OFu1idR5il2y262vwaRSR9dSfAno
Message-ID: <CANp29Y4G5HbXgrsuKBE0HLFud+OuLVz_9EAbLSMZtF1pSbiakg@mail.gmail.com>
Subject: Re: [PATCH RFC] drm/lease: Fix warning on large user-controlled allocations
To: syzbot <syzbot@kernel.org>
Cc: syzkaller-upstream-moderation@googlegroups.com, syzbot@lists.linux.dev
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Ok. Let's experiment with "upstreaming" it.
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
