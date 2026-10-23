Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.218.51
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792749909;
	b=Qvc93Vd+2Jw5tG5ssOcN9Ik+wRhuLpyZ5nmRZ9Ck1V56c7oJhkCqMIrCDDPFQdY8Md8G
	 upVHwxzVFNeqFMxHYFhnUEVwxuKtQMqWPSgkZejP9yPC/xuJJ9xUR/un4r+7bgu9ws5HG
	 /euPqQ3fZmDpEj/hqEJ+mtOaOzieMb7DDaOKykRzs6kx1Tn+wJcURoKew2HP/eH5qFWac
	 388UI1NwSPLQeXN+5tPtjXZhGPx4fXSHQIg1wQ3nn2U3s0p/lmEjedQ6wye0opsOp4qC8
	 5wjgmoB9zErExGf0F5pSrUUHbvKklhqhXSH/rkkauwOx8YAZnUvgM3YGqlTNwnTaAOw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792749909;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:Received:
	 Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:Content-Transfer-Encoding:
	 In-Reply-To;
	bh=R2bDkbs/Zkbm/K4V08erGf8Q5Eh0RwjHLQvNrVlkkvE=;
	b=3jc+p6odq9AAI/fcH1GktUPQeg4YnQ8ARrd/JFG/BApdULmyTXJ4GaBt5fwSnTo/LM8m
	 MuR/Ue0YLeFAwLiRiHTEPf8WZifuvoUBizXgpnrRV4Dvy0kP94AOOcHk0LVOqmHq8j2hv
	 PYkzhGK1/bNIGUlwAtC4W4AcTeE6rXMHN8ese0BDQxTy1p0QugJwc0w+Hnu5h2kQ2zhUb
	 +DB8QGWhNQiL6AkLQFkTwGZLpgbhQlK2KthVNvS0MXhh9LweYOcOAbtNyAJGJyRBUe3sU
	 FcV9SClpZAdm4H5ZpKuHlfWY+9/K7AAB109sCLuBqtKI6dXClsbmxasfjPLIOscgA7Q==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20251104 header.b=nKHWwzBv;
	arc=none smtp.remote-ip=209.85.218.51
Received: from mail-ej1-f51.google.com (mail-ej1-f51.google.com [209.85.218.51])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 54F29606A31A
	for <syzbot@lists.linux.dev>; Fri, 23 Oct 2026 10:05:09 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 54F29606A31A
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20251104 header.b=nKHWwzBv
Received: by mail-ej1-f51.google.com with SMTP id a640c23a62f3a-c445c95d553so88080966b.1
        for <syzbot@lists.linux.dev>; Fri, 23 Oct 2026 03:05:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1792749908; x=1793354708; darn=lists.linux.dev;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :content-type:mime-version:references:message-id:subject:cc:to:from
         :date:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=R2bDkbs/Zkbm/K4V08erGf8Q5Eh0RwjHLQvNrVlkkvE=;
        b=nKHWwzBvNxjD+M6XIsq/2TkScWKL1OXoyH4dKvuMC8TcsTcw+unMVj6T/n6ISd6Ouz
         zoCRJj/EQyggBkuGeicmPeZ+ytTxrctWpyo1M1RXkjbP1GdYPyz/5yc6fwPC57XEnldD
         RJeoHmPzlDktk1kTE8ulHY1zjicNRbJxZ30zUKshnwGjjYvSr2vY9ZMMlN27ijanDgue
         Hh2uJA9jxg22QK2g3u+k2HD0uhs9yh3xulCxlSNhf1sjIvY8rXDx41Nb+f93htCxzsO6
         v2LKLnt+qz3ZseKGI8FLTuPEHNYzI1aFjNQ8PE1QBlfVtByPoytosHTWdziJhswQtZRS
         9sjg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1792749908; x=1793354708;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :content-type:mime-version:references:message-id:subject:cc:to:from
         :date:x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to:content-type;
        bh=R2bDkbs/Zkbm/K4V08erGf8Q5Eh0RwjHLQvNrVlkkvE=;
        b=W7jXtgO8b+h5EY2r5qgAOv+FkMxxISq4P4t8R+kVQYj7GFw7S0sriS2xwx1zGEUvS2
         GKhhP1xVj79idZAZpYgNJ2iXfaIqyLCg5t2cyKmxb6SjcpoOZ/4BuKv674WaTdsB3yKl
         EN0E6QDxQJu96y/F3JuOuVQAPrtR2e+VjsniHarAA/mJ5YiySlPjpsaIK2vw6Ts7xye2
         HEqxhEtOIp3oOeaVrzdUFGqsukqCxQEn8+Lvho/cDJiyCa9gTt/5bEM3/raeS40S99sC
         5jXHPI5zt/OK3yJoNeaCZQJv9OqALgOl13QPBOuYmUd2/XsPX+0kQKFAxCGtXrAL31ow
         wyrA==
X-Forwarded-Encrypted: i=1; AKwUvBzKu90sJUYwL8znA9Ecv7xidnkRsEUvk9FUzVvXMHQBWd1plXrvTPNISTBEvPS4dj7Z3LsdC80=@lists.linux.dev
X-Gm-Message-State: AFq9FYLrzDsmktZA+o8YefpLSZ3xNcGxBYHO5pespRIQkLbfKTuMANL6
	MEUmfZWtpeTFUccrZ7UHAyvNRHKflHVBHh5faWiFq8XdWmlc/4Hfk4uK
X-Gm-Gg: AYBFou0wRIKz3BcFd7ROL3cM3zN9Ra3tRZWoUFLCvm9rnSS9UTZDI1Ipza/8xmPZzBp
	g0kjUwdUPvTgDt9Tsy3Wpcbc3DY57PJ7VyfQ8+VaGel6Ko4gM12MivQJ4rKQweVs4FUsi0WCQiK
	lgh/2A5Bo3yz6vd/tpJLhG/XnWpDzvKwitDP1p9m+g2IukDvb586VrFpw8mYo0WLT5cNqi7PHv/
	E5O5VPMoBuiU7iHdTl5/sZ6NPy2WA8L0g7R0/1qBFQXhRZd8DTet8VDDjIgPHtJAeiY6zlKc4VI
	3JNWmIFco8QbPsx66TRilAV0E1Mlo8nxyvqHG1W8OTgTQOvx/fkClMpRurMztdYib+038vCxSyr
	uUe62JmZ8m+JiV0eB3F1k/VtM8y9rNEwIMHS2TPGWvUFjq98wZ2h5qwf8HgqPcGP0QwSOcw6Hm9
	BqbhI0aBr8cKgOEcRbWsEjwWozzqIUFwNtVW4Plx3b28+4ZHj0BveCazIboFMaFv7qK5DNr5892
	NVzAoF+2idQEBw3FLxlPa26+G60wLpKodHj8Wx0UMzokFrdOfMYUqpOwMIeKMHMH8PVLDq+eFD+
	svCL
X-Received: by 2002:a17:907:3d45:b0:c25:afb6:2d91 with SMTP id a640c23a62f3a-c46a8ee3401mr257385166b.2.1792749907316;
        Fri, 23 Oct 2026 03:05:07 -0700 (PDT)
Received: from localhost ([37.30.48.34])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-c46a5caef37sm84176266b.57.2026.10.23.03.05.06
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 23 Oct 2026 03:05:06 -0700 (PDT)
Date: Fri, 23 Oct 2026 12:05:05 +0200
From: Bartosz Chronowski <immersa.bartosz.chronowski@gmail.com>
To: syzbot <syzbot@kernel.org>
Cc: syzkaller-upstream-moderation@googlegroups.com, syzbot@lists.linux.dev
Subject: Re: [PATCH RFC] drm/lease: Use kvmalloc and bound object_count in
 create lease ioctl
Message-ID: <b3ujzzzry3mvnq2gomddwlmslw5mcbe22i2ta73kpjqskhtzsd@ffddm6c7qnrm>
References: <4c497e30-fff3-4ef0-81f9-b9b47ca9e22f@mail.kernel.org>
X-Mailing-List: syzbot@lists.linux.dev
List-Id: <syzbot.lists.linux.dev>
List-Post: <mailto:syzbot@lists.linux.dev>
List-Help: <mailto:syzbot+help@lists.linux.dev>
List-Subscribe: <mailto:syzbot+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:syzbot+unsubscribe@lists.linux.dev>
List-Owner: <mailto:syzbot+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable
In-Reply-To: <4c497e30-fff3-4ef0-81f9-b9b47ca9e22f@mail.kernel.org>

The v1 allocator change addresses the selected warning: both temporary arra=
ys
can use vmalloc-backed storage, the pointer array remains zeroed, and both =
frees
match. In one matched 180-second run, the unpatched kernel reproduced the w=
arning
and the patched kernel did not; guest probes also exercised zero-object and=
 real
leases. The patch still needs changes because its count guard permits an
impractical allocation before object lookup, and the description overstates=
 the
signed-count problem and blurs the warning trace's source revision.

Keep the allocator and cleanup changes, but reject excessive object_count
values before copying the IDs. The current INT_MAX / sizeof(pointer) guard
admits about 268 million IDs on arm64, enough for roughly 2 GiB of pointers
plus 1 GiB of copied IDs before the first lookup. Choose and explain a fini=
te
per-request limit tied to the lease objects the ioctl can support and a
reasonable allocation budget. Keep the signed helper-parameter bound as a
separate check, and preserve zero-object and valid leases and their cleanup.

Correct the description to say that an unsigned cl->object_count outside the
signed helper's range would be converted to a signed parameter; the evidence
does not show signed arithmetic overflow. Identify drm_lease.c:389 as the
historical warning-site line in the reported tree, rather than treating that
line and a later source location as the same revision. Explain that vmalloc
fallback removes the selected high-order allocation warning while the new
count limit controls resource use. The existing Fixes: tag and recipients n=
eed
no change for this revision.

After revising the guard, repeat the exact-base build and matched unpatched=
 /
patched reproducer check. Exercise counts around the new limit, zero-object
and real leases, invalid-ID recovery, and allocation-failure unwind. The
current run did not inject ENOMEM, so cleanup on that path remains supported
by source inspection rather than a forced-failure test.

Impact assessment: the selected trigger proves a warning and failed ioctl f=
or
a DRM master, not memory disclosure or corruption. Warning-to-panic policy
could turn that warning into an outage. The present multi-GiB count allowan=
ce
is a resource concern; repeated or memory-pressure behavior was not tested.

Kind Regards / Mit freundlichen Gr=C3=BC=C3=9Fen
BART CHRONOWSKI

On Wed, Oct 14, 2026 at 12:40:00AM +0000, 'syzbot' via syzkaller-upstream-m=
oderation wrote:
> In drm_mode_create_lease_ioctl(), user space supplies an object_count and
> an array of object_ids to be leased. The kernel copies the IDs from user
> space using memdup_array_user(), and then fill_object_idr() allocates a
> temporary array of pointers using kzalloc_objs(struct drm_mode_object *,
> object_count).
>=20
> Because kzalloc_objs() performs a kmalloc-family allocation with GFP_KERN=
EL
> (which lacks __GFP_NOWARN), if user space requests a sufficiently large
> object_count (for example, 1,000,000 mode objects), the allocation for the
> pointer array (1,000,000 * 8 =3D 8,000,000 bytes on 64-bit systems) requi=
res
> order 11 pages. This exceeds MAX_PAGE_ORDER and triggers a warning in the
> page allocator:
>=20
> WARNING: mm/page_alloc.c:5340 at alloc_order_allowed mm/page_alloc.c:5340
> [inline]
> WARNING: mm/page_alloc.c:5340 at __alloc_frozen_pages_noprof+0xe4/0x640
> mm/page_alloc.c:5397
> Call trace:
>  alloc_order_allowed mm/page_alloc.c:5340 [inline]
>  __alloc_frozen_pages_noprof+0xe4/0x640 mm/page_alloc.c:5397
>  alloc_pages_mpol+0x1fc/0x3d0 mm/mempolicy.c:2486
>  alloc_frozen_pages_noprof+0xe0/0x214 mm/mempolicy.c:2557
>  ___kmalloc_large_node+0xf0/0x160 mm/slub.c:5353
>  __kmalloc_large_node_noprof+0x2c/0x8c mm/slub.c:5385
>  fill_object_idr drivers/gpu/drm/drm_lease.c:389 [inline]
>  drm_mode_create_lease_ioctl+0x45c/0x15c8 drivers/gpu/drm/drm_lease.c:521
>  drm_ioctl_kernel+0x250/0x328 drivers/gpu/drm/drm_ioctl.c:817
>  drm_ioctl+0x65c/0xa58 drivers/gpu/drm/drm_ioctl.c:914
>  vfs_ioctl fs/ioctl.c:51 [inline]
>  __do_sys_ioctl fs/ioctl.c:597 [inline]
>=20
> Furthermore, cl->object_count is an unbounded __u32, whereas
> fill_object_idr() and validate_lease() treat object_count as a signed
> integer. A value of cl->object_count greater than or equal to 2^31 results
> in signed integer overflow. In addition, an allocation size exceeding
> INT_MAX would trigger a WARN_ON_ONCE inside __kvmalloc_node_noprof().
>=20
> Fix these issues by validating cl->object_count early in
> drm_mode_create_lease_ioctl() so that requests with cl->object_count >
> INT_MAX / sizeof(struct drm_mode_object *) are rejected with -EINVAL.
> Additionally, switch the object_ids allocation to vmemdup_array_user() and
> the objects pointer array allocation to kvzalloc_objs(), freeing both with
> kvfree(), so that large allocations can fall back to vmalloc without
> triggering allocator warnings or failing under memory fragmentation.
>=20
> Fixes: 62884cd386b8 ("drm: Add four ioctls for managing drm mode object l=
eases [v7]")
> Assisted-by: Gemini:gemini-3.8-flash Gemini:gemini-3.1-pro-preview syzbot
> Reported-by: syzbot+6754751ad05524dae739@syzkaller.appspotmail.com
> Closes: https://syzkaller.appspot.com/bug?extid=3D6754751ad05524dae739
> Link: https://syzkaller.appspot.com/ai_job?id=3D9d9e7ba8-2ca5-4a5b-a7be-8=
e951e80e2f7
> To: "David Airlie" <airlied@gmail.com>
> To: <dri-devel@lists.freedesktop.org>
> To: "Maarten Lankhorst" <maarten.lankhorst@linux.intel.com>
> To: "Maxime Ripard" <mripard@kernel.org>
> To: "Simona Vetter" <simona@ffwll.ch>
> To: "Thomas Zimmermann" <tzimmermann@suse.de>
> To: "Keith Packard" <keithp@keithp.com>
> Cc: <linux-kernel@vger.kernel.org>
>=20
> ---
> diff --git a/drivers/gpu/drm/drm_lease.c b/drivers/gpu/drm/drm_lease.c
> index 5d2cf724c..6d31bc95d 100644
> --- a/drivers/gpu/drm/drm_lease.c
> +++ b/drivers/gpu/drm/drm_lease.c
> @@ -3,6 +3,9 @@
>   * Copyright =C2=A9 2017 Keith Packard <keithp@keithp.com>
>   */
>  #include <linux/file.h>
> +#include <linux/limits.h>
> +#include <linux/slab.h>
> +#include <linux/string.h>
>  #include <linux/uaccess.h>
> =20
>  #include <drm/drm_auth.h>
> @@ -386,7 +389,7 @@ static int fill_object_idr(struct drm_device *dev,
>  	int ret;
>  	bool universal_planes =3D READ_ONCE(lessor_priv->universal_planes);
> =20
> -	objects =3D kzalloc_objs(struct drm_mode_object *, object_count);
> +	objects =3D kvzalloc_objs(struct drm_mode_object *, object_count);
>  	if (!objects)
>  		return -ENOMEM;
> =20
> @@ -462,7 +465,7 @@ static int fill_object_idr(struct drm_device *dev,
>  		if (objects[o])
>  			drm_mode_object_put(objects[o]);
>  	}
> -	kfree(objects);
> +	kvfree(objects);
>  	return ret;
>  }
> =20
> @@ -496,6 +499,11 @@ int drm_mode_create_lease_ioctl(struct drm_device *d=
ev,
>  		return -EINVAL;
>  	}
> =20
> +	if (cl->object_count > INT_MAX / sizeof(struct drm_mode_object *)) {
> +		drm_dbg_lease(dev, "too many objects: %u\n", cl->object_count);
> +		return -EINVAL;
> +	}
> +
>  	lessor =3D drm_file_get_master(lessor_priv);
>  	/* Do not allow sub-leases */
>  	if (lessor->lessor) {
> @@ -509,8 +517,8 @@ int drm_mode_create_lease_ioctl(struct drm_device *de=
v,
>  	/* Handle leased objects, if any */
>  	idr_init(&leases);
>  	if (object_count !=3D 0) {
> -		object_ids =3D memdup_array_user(u64_to_user_ptr(cl->object_ids),
> -					       object_count, sizeof(__u32));
> +		object_ids =3D vmemdup_array_user(u64_to_user_ptr(cl->object_ids),
> +						object_count, sizeof(__u32));
>  		if (IS_ERR(object_ids)) {
>  			ret =3D PTR_ERR(object_ids);
>  			idr_destroy(&leases);
> @@ -520,7 +528,7 @@ int drm_mode_create_lease_ioctl(struct drm_device *de=
v,
>  		/* fill and validate the object idr */
>  		ret =3D fill_object_idr(dev, lessor_priv, &leases,
>  				      object_count, object_ids);
> -		kfree(object_ids);
> +		kvfree(object_ids);
>  		if (ret) {
>  			drm_dbg_lease(dev, "lease object lookup failed: %i\n", ret);
>  			idr_destroy(&leases);
>=20
>=20
> base-commit: 24a19b953e2a3d0ea5a8c4951a0ab8f32720c907
> --=20
> This is an AI-generated patch subject to moderation.
> Reply with '#syz upstream' to Sign-off the patch as a human author
> and send it to the upstream kernel mailing lists.
> Reply with '#syz reject' to reject it ('#syz unreject' to undo).
>=20
> See https://goo.gle/syzbot-ai-patches for information about AI-generated =
patches.
> You can comment on the patch as usual, syzbot will try to address
> the comments and send a new version of the patch if necessary.
> syzbot engineers can be reached at syzkaller@googlegroups.com.
>=20
> --=20
> You received this message because you are subscribed to the Google Groups=
 "syzkaller-upstream-moderation" group.
> To unsubscribe from this group and stop receiving emails from it, send an=
 email to syzkaller-upstream-moderation+unsubscribe@googlegroups.com.
> To view this discussion visit https://groups.google.com/d/msgid/syzkaller=
-upstream-moderation/4c497e30-fff3-4ef0-81f9-b9b47ca9e22f%40mail.kernel.org.
