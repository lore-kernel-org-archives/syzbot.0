Received: from mail-oi1-f172.google.com (mail-oi1-f172.google.com [209.85.167.172])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DBD5C3655C2
	for <syzbot@lists.linux.dev>; Fri, 19 Jun 2026 10:08:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.167.172
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781863737; cv=pass; b=golcm2dxbSbIQZopUNfCUGppt8fm86vOHh0bz3lTE8qJkkNRSdBO26oSoj/IgdINz8qEeMwq8MPuPLe88G2rddJd/hRM6hpmr8kYFRW0SXey8YcuWyOe1u39f2gA2hNoKMy5OskBna88GWbCAq+crfqZ9R+qqP123E+pr+84pEU=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781863737; c=relaxed/simple;
	bh=QQVb/XBOqsv+lUXaqg3bWJGyrjxqhcIhWmyHFTjVMjo=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=EiPgGCrjGRzoB9+LRpN8t3zYpDQh2tIbXpY4LExcGM5pQp3kVmRmRa/ETBp2y16UaVfhS9cKWkTbGJC1dhRBK3QRha7el/xkiwFu1KHgn4QpeYccD9Sk0OiiIJ9rPH0sroPIUeMJyP/mIrRgqhMBLRF55Er62n1bn9Swzod4f/A=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=A7friT4k; arc=pass smtp.client-ip=209.85.167.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="A7friT4k"
Received: by mail-oi1-f172.google.com with SMTP id 5614622812f47-489f0c807c5so202063b6e.0
        for <syzbot@lists.linux.dev>; Fri, 19 Jun 2026 03:08:54 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1781863734; cv=none;
        d=google.com; s=arc-20240605;
        b=e3nafZ659ZiDEu/iRNC2xEJsit0LrOu+48ZzR71oiWuwJfF7FURUSsozdYOnGIdW1q
         jRyh9UVlHYJWsIGhMK3rKgBy5P/Jz96Eq1RxeSdbaQ/98Q6WQBKPfX0dY/0z258UARDU
         a0bnxjDss7iu4nrag7jY+t2DTY4pvpjG6tAPi7qsRQR9iDK1bpzOUDn+agRwi1QIHxx9
         lJE3XP+lRB/wEhFdEtrScdPpB8OZizKCHYyaVZqrNgnLctXoaB2xoOGdVxu1skF0l9o+
         STaQ6HX0eU6ijvt+8PXFJKu5Qp0eI+lHHDEWB3PRuNvXVV8NmU/cJQqGgUys4MrZfJXL
         kx/w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=FQSU4S8K8eJH+lfxBupynJtJylpwrIIGQN7Kt+9AJy4=;
        fh=TlYBBZMUQ2J7kkyzNKpFwWyYC12OW2SBNarNZuyJPeY=;
        b=KWoP9bm02lObnu6prl7cBXt2dLb8vAgI7DjMgq7ELpt7mEfnAEMVTrDJTdfhVsXHjX
         +E4l8SGloaUouiZWK6cnHA8YyEdZXOrza39Z1Hg63Y41yI+meSFBE5fx4KlYLRxAyaTL
         Z/jNrKCkA9LebW6YTH92VbmiPl4p+J9Ve5xOBvN2m8s0R31oUnHizEIcPOsWiJVirk+c
         WGqgW7pVGAmhp12P617QeMcHKtehuI55Sps7zPtrm8/Eq0hz7ncCmwZVTKJs/npL8gx+
         Jz9FiA4wNj/Ky4VR73dfVhtdWHdR6NsqW2VLHGbLdxjdKZgnS3Maah9tBxRqrrVap80v
         7Rrw==;
        darn=lists.linux.dev
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1781863734; x=1782468534; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=FQSU4S8K8eJH+lfxBupynJtJylpwrIIGQN7Kt+9AJy4=;
        b=A7friT4kyoDU+fBvkDiOGzaKGaAZsVLQpIXDsJfWxR19HT3sovc8byO9wAt22W2WjB
         2mgIjqxsDFA+I8kVx0+KmiDKRRGvvfs7Ere253KJH9jhswk81QDsCxaNX6qEDf6FDjXO
         af4XpXcls8T3soDDvXKEHtvrnDcyhWQVSsAVIAbOdqx+vT0XCWfH36rpBVkOq7uQgx+i
         rnr4rWo2TvvYt79CoYRWP2F5fBCLztoiBtAbvmfkSjiAg/CrUDAlC3YuFNBhuIfAzHWV
         W89W0Vem/OOrl4eNWWO8d+gZvzugcHKkxOc6/x5FD3bvjlGYYoJ+IKpf21tPo6rgUnKC
         uK8A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1781863734; x=1782468534;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=FQSU4S8K8eJH+lfxBupynJtJylpwrIIGQN7Kt+9AJy4=;
        b=WlHlZNelAaNtcj/wUu/5kNFQRiL3fka15O48tbLcy6nR8V+Db/BXgNDFoJzq64Tz+i
         kjdTo8OpxQxq9ss5k5HlDedYW3FMIaaFRWGnd+BZl3aCaqiSEPRWHgjPYGkdQl+KgkKp
         NrOQN0oNYEnjSEw7pb74Cbk/UenSP33kMjTi1JLZRFadCcccpxIp+dEnE6kTLJ9reGeX
         l8SLLHzU+nyWEc5NszkKxtfm7HWFJ22vsM3sVWMOeTH0pYigg4wH+/VhlxHETUw8bJX/
         zedn9F7LE2LdPP8iLwT2raiH2V+uoiDnILmNxtxbFFlpOOrvzJkMXTGlARPIhoavYjF6
         ZFJQ==
X-Forwarded-Encrypted: i=1; AFNElJ8KEFMBflASJLm1Igrr65c1Upa5QPsDb6YJKnpKoiKycvQzQBOhRMMvMTA+50O1EuPY7l9D3LU=@lists.linux.dev
X-Gm-Message-State: AOJu0Yyxt0MPqS8EycfuvIMvY3lI4L0kddhzIjQl3yKq1GhgVQ/LXP1c
	zLRa3PrQ6EXa/K/AMDOxIJSGYdNkzttBZzyYOKCRtHCeMvwIcwp/NPPj9h1HUDsUtKUROZ7NmpE
	GBOX6KH6oyWCJ31etRyAzsDEAhuw2PZPkE2IiOKlg
X-Gm-Gg: AfdE7cn+4Sp9cxhIYwlc5o6dAAey/aI1+sJEkehEpuAbmIvs5RnkKlB/K3o8LLkvsem
	FB7XSqGL62FUb+2xfVNbDv94Vc7z4tknYPWMfnMi1B1N3uVjqMBP75oTeXANWzDQiHSFILP0Ww3
	DlbpR4KPgXldZzSh9dPncHmR/0eo4V5adODSBn3cHeCJhhijZQ+qXJAW0OfFbO1+hEKHtKH++P7
	lRa6Y5PEAolvetfCiP5E8lq7+gcyyc5icqOK9jFRQf3apjrEjl+BuE8uiWvgOk9c5tDF2/3Whmo
	5jH9yRD6ABcI7Nq/RX1sxjdHiC4UhZACWAoxyIkOXFqeIYDxTF6SMdpQ2kyI795F1FJEwsI5wSq
	YkVvM21K4LQ==
X-Received: by 2002:a05:6808:1806:b0:486:3537:2177 with SMTP id
 5614622812f47-4896c961250mr1552185b6e.16.1781863733096; Fri, 19 Jun 2026
 03:08:53 -0700 (PDT)
Precedence: bulk
X-Mailing-List: syzbot@lists.linux.dev
List-Id: <syzbot.lists.linux.dev>
List-Subscribe: <mailto:syzbot+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:syzbot+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <3c78114e-ed6d-4b15-9d77-4f8ddd7f9cd8@mail.kernel.org>
In-Reply-To: <3c78114e-ed6d-4b15-9d77-4f8ddd7f9cd8@mail.kernel.org>
From: Aleksandr Nogikh <nogikh@google.com>
Date: Fri, 19 Jun 2026 12:08:41 +0200
X-Gm-Features: AVVi8CdNsS0zDXuH8hG3SMcvkFSU4hY7UTugyJbkcU9wrKN946uWRlU3HGEIWbc
Message-ID: <CANp29Y7LVN3udb7ZT7VKYxRB9ikLUaX6u6qNzKfbsryn+kzygg@mail.gmail.com>
Subject: Re: [PATCH RFC v2] drm/lease: use kvmalloc for temporary ioctl arrays
To: syzbot <syzbot@kernel.org>
Cc: syzkaller-upstream-moderation@googlegroups.com, syzbot@lists.linux.dev
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

#syz upstream

On Fri, Jun 19, 2026 at 8:20=E2=80=AFAM 'syzbot' via
syzkaller-upstream-moderation
<syzkaller-upstream-moderation@googlegroups.com> wrote:
>
> In drm_mode_create_lease_ioctl(), a user-controlled object_count is used =
to
> allocate memory for object_ids and objects. If a user provides a very lar=
ge
> object_count, the kernel attempts to allocate a contiguous memory chunk
> that exceeds the maximum allowed size by the slab allocator
> (KMALLOC_MAX_SIZE).
>
> For the objects array, kzalloc_objs() is used, which expands to a standar=
d
> kzalloc() call. When the requested size exceeds KMALLOC_MAX_SIZE, the SLU=
B
> allocator passes the request to the page allocator, which triggers a
> warning because the required page order is greater than MAX_PAGE_ORDER:
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
> The object_ids and objects arrays are temporary buffers used within the
> ioctl to store object IDs and pointers during the lease creation process.
> Since these arrays are not used for DMA or hardware access, they do not
> require physically contiguous memory.
>
> To fix this, replace memdup_array_user() with vmemdup_array_user() and
> kzalloc_objs() with kvcalloc(), along with changing their respective
> kfree() calls to kvfree(). The kvmalloc family of functions attempts a
> kmalloc() first and gracefully falls back to vmalloc() for large
> allocations. This prevents the kernel warning and makes the allocations
> more robust against memory fragmentation, gracefully returning -ENOMEM if
> the system cannot satisfy the request.
>
> Fixes: 62884cd386b8 ("drm: Add four ioctls for managing drm mode object l=
eases [v7]")
> Assisted-by: Gemini:gemini-3.1-pro-preview Gemini:gemini-3-flash-preview =
syzbot
> Reported-by: syzbot+03fb58296859d8dbab4d@syzkaller.appspotmail.com
> Closes: https://syzkaller.appspot.com/bug?extid=3D03fb58296859d8dbab4d
> Link: https://syzkaller.appspot.com/ai_job?id=3D22f7a1b3-b0e0-4e5d-abf2-e=
7119094823a
> To: "David Airlie" <airlied@gmail.com>
> To: <dri-devel@lists.freedesktop.org>
> To: "Maarten Lankhorst" <maarten.lankhorst@linux.intel.com>
> To: "Maxime Ripard" <mripard@kernel.org>
> To: "Simona Vetter" <simona@ffwll.ch>
> To: "Thomas Zimmermann" <tzimmermann@suse.de>
> Cc: <linux-kernel@vger.kernel.org>
>
> ---
> v2:
> - Explicitly stated that the allocated arrays are temporary and do not re=
quire physical contiguity as they are not used for DMA or hardware access.
>
> v1:
> https://lore.kernel.org/all/46506931-ba8f-4048-ab27-9777411db2fe@mail.ker=
nel.org/T/
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
-upstream-moderation/3c78114e-ed6d-4b15-9d77-4f8ddd7f9cd8%40mail.kernel.org=
.
