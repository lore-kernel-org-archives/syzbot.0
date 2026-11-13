Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.218.48
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794573635;
	b=DTzFPvINd0XqhBSN2vQJi90j9+eDVtJeWT0lkQxrr4Bv0gW6IiPygPKLpAVSraQy013c
	 8ZERhJKom3O431VWAdJHbtJTP512bSFPkM1VgG1170XPNfT2HJUwIWFUiGL5x0c1dnXme
	 wGJR4Jksv8K9tYbf/fRjHzSMwybjtfaMZntkf02qdE5LSv0GWFKslIAAv5+pNPOUBPAIo
	 mycRumGxrvwM6RTcq4AlPqo6mVWxQZe4No0/nWQPLhx9P/Ckw0afaRAKFbvb0N6VUn8kg
	 291OZrJIO12aS4OZu50ePJ2ueEXIJei3uwhbYCuTET+ozvNGhlJueKUP7I0AuUuFcfA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794573635;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:Received:
	 Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:Content-Transfer-Encoding:
	 In-Reply-To;
	bh=YH1Aw+hN+FdLxvWXDU4craUlxyCuHUYXJSvNgOeGfPA=;
	b=yYMpUeYtCIl8M0mgiRCKvcLYKMRBm0QVxlfAYQGD4eHYZcHGR+biK4VxkkmDEi9MCJCd
	 uBopx8i5KXNh8jpuB0e0JECu2A/4Y7IIPNtTUIdHNe95dCNx/XaNTFMe6LGvyn5YtTnJq
	 8cD/l9R7346LgWTIUqsJaHQmjKRtLG7tI6rMWB8+odHJeeFH7e6HBmpOlkLzRm9caDNhI
	 RbL+uOM3aCpbGd9XpOrPMJhfTJMggOM5UUAis27EqpAJN+GuyiVspATMrm8wstK+5VVpZ
	 GrFnBeQasIORvfaWtpQTmH0MamFQUJiSMl61Si+UQqlZyUcdHv+8OdbEdP8h+/L8Igg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=nb6RmG8f;
	arc=none smtp.remote-ip=209.85.218.48
Received: from mail-ej1-f48.google.com (mail-ej1-f48.google.com [209.85.218.48])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8C4BC606A327
	for <syzbot@lists.linux.dev>; Fri, 13 Nov 2026 12:40:34 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 8C4BC606A327
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=nb6RmG8f
Received: by mail-ej1-f48.google.com with SMTP id a640c23a62f3a-c506094fd93so195496366b.1
        for <syzbot@lists.linux.dev>; Fri, 13 Nov 2026 04:40:34 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1794573633; x=1795178433; darn=lists.linux.dev;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :content-type:mime-version:references:message-id:subject:cc:to:from
         :date:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=YH1Aw+hN+FdLxvWXDU4craUlxyCuHUYXJSvNgOeGfPA=;
        b=nb6RmG8fDnGTVpM6w8sY7Q7vDRkPI3gOL6XtCUewTE4OY/HngPAWVKq2wbIqp+fhau
         twKuBvm0JrsAJ7nQBgJs4WFocpQeDRcoXE4H/Zgw2AsuAYeIadRor/ml6xUI9OxlQL2C
         cOlcEiv88/jnm1/CWXUQvKYlbf/wWZWIQvuIn/KQTVPQqMCPDF3H/W4W7BPrjPntW4JK
         BtiXQMCvBxoyLH/xuxGlB8/51T7sTCppyEtC088x3gdY58taEA0YyuNxWJhhllaf+Z2J
         AYb13XiWFJg6aUeYQNr4fDd329F3XlvwinGA9mNu+6cpWw00fhWElSNPuPh7zcaW9YfE
         uB0g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794573633; x=1795178433;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :content-type:mime-version:references:message-id:subject:cc:to:from
         :date:x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to:content-type;
        bh=YH1Aw+hN+FdLxvWXDU4craUlxyCuHUYXJSvNgOeGfPA=;
        b=twXtnVRSZfRoT4dW7YLCK5tnpcXPn4ROr0x7JPeozy5L3Nlvw9v3bcnoLRzDrmMFj6
         pMrm7wFGldmII7X2J7wyyeBkG7I+MvyiE0pNGTyATd8kBPO6xYJKSDE2kkKdsnUMWBsR
         SU3eKfHBvw/SbvLbTnJHdeQ4m7hp964ER9izjIn6qHiu1mzwV3I8vw31ZFDdCHWoLDXK
         HSri3rf9LhoTUlJhdQ4808yPG5se60SitJMT9snX234C4SJFtauV8abtQUUVVLlY/RDY
         4qYDL7x9pULzZGvn5ox2Hq0/38rgEsbeIMfRwKGHdlmfU7DVGrfIt/nCAXZAC2+Djngf
         arMA==
X-Forwarded-Encrypted: i=1; AL+hErEmsy2Ck2fRRWRBg12mbpfa8RLm1py794jVfrniTzAAXqpSUvaqMZbVkIayS7ul8CAj8SE81UE=@lists.linux.dev
X-Gm-Message-State: APuU4Z8mY2Zz5WQ579gjzBVqKxFSYgsVb7IgwYPxJtQdVYzpSzQYdO6t
	0Ljo2yPb8TiXv4+xLq2t4zL2cuPEKj6FjJB5KCrqjmSGdyDR6vAbO52J4faT+InIINk=
X-Gm-Gg: AYBFou3tEg72YdtPbWBSIsRkUnlmNhcvzFosIwItFXF7U//7FIUKE86u6Ws3q2f5CpH
	f6NHCQgLOQS2h1VDoRUeL6epGzCHKXjF3GWZWrYa+dFAnJlnoNIzPNMAHvpeB3lZR9nzaz//ept
	3ClLsBDdkuoG/GGtF02qybR5xQ/GKGmaxKsCj+VpScBzOX9GUvkB+rP5rb7NaTmWWg4E01rwXfl
	DXwM3LXGzy2XZv5wg/YKzXmbIGLDyf3BP2bI7I9DThMZAEr7EDA+FqGnrYr7q5eF9TCHj/2Pi0e
	eepKLQb8wb2UeEG2RcGI6rnc8JqhOZwm9LrYJ0uLn1UwZmo9ncAHsjHVAhDbyKZcApGxSBNIZGq
	QK64uWHcSmIxRSz0VeH9L9/2YvAyoTKuahci1kOVE8tv0LqwUkp64BlD5LXNY4Eql3vdOmxDKkm
	6CSYc6Vum+PrNDdqLUEZXgMk0UWYBatN/g2UZ6K3nAVrQuax7LNGYH5nVSXGvY+QVsmCwTAKruP
	j8lsCzfAGnlthjA6ABshnR+qITqvR3ZOxo1v1/vou4qmN0IPieMejGwdAvKvBrlN+eLrZLRnwEp
	MSeYDz9PlYvs0VdrSPAevgRJJmAJmsHyyEWJZENlPEWzMjYY
X-Received: by 2002:a17:907:7ba3:b0:c41:5a0e:3356 with SMTP id a640c23a62f3a-c50963cf40dmr205491466b.41.1794573632724;
        Fri, 13 Nov 2026 04:40:32 -0800 (PST)
Received: from localhost ([188.146.170.61])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-c5095b24b88sm89132466b.16.2026.11.13.04.40.32
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 13 Nov 2026 04:40:32 -0800 (PST)
Date: Fri, 13 Nov 2026 13:40:31 +0100
From: Bartosz Chronowski <immersa.bartosz.chronowski@gmail.com>
To: syzbot <syzbot@kernel.org>
Cc: syzkaller-upstream-moderation@googlegroups.com, syzbot@lists.linux.dev
Subject: Re: [PATCH RFC v2] drm/lease: Use kvmalloc and bound object_count in
 create lease ioctl
Message-ID: <agka76rdnestbdpdoaploq5nvbeovrz7gluzmnt37ry35dofli@fzdeim53wbf3>
References: <c18e659d-1e93-4309-8c28-d9fa96827675@mail.kernel.org>
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
In-Reply-To: <c18e659d-1e93-4309-8c28-d9fa96827675@mail.kernel.org>

The v2 code change is sound in the tested scenario; no code change is
requested. The patch still needs corrections to its description of the
reported tree and warning trace.

Required changes:
- Correct the reported-tree allocation to kcalloc() at drm_lease.c:389.
  kzalloc_objs() belongs to the later moderation base.
- Use the reported mm/page_alloc.c:4727 warning, or label the quoted
  mm/page_alloc.c:5340 stack as coming from a later source revision.

Keep the corrected signed-conversion explanation and the 1024-object
rationale. The existing Fixes: tag and recipients need no change.

Testing:
With the same base commit, C reproducer and comparable arm64 configuration,
the earlier unpatched test reproduced the selected warning and the v2 test
reproduced no crashes. The recorded v2 run used one guest and a 180-second
reproducer budget; total elapsed time, including guest startup, was
9 minutes 42 seconds under QEMU TCG.

Count-boundary, zero-object and real-lease tests passed, as did invalid-ID
recovery. Allocation-failure unwind was inspected in source but not tested
with forced ENOMEM.

Context:
The 1024-object cap addresses the resource-limit request from the v1 review.
It exceeds the DRM core limit of 96 distinct leaseable objects and bounds
both temporary arrays before user IDs are copied. The signed-range guard
remains separate, and both vmalloc-capable arrays keep matching kvfree()
cleanup. The new rejection path destroys the temporary IDR and releases
the lessor.

Impact assessment:
The selected request requires DRM-master access and demonstrated an
allocator warning and failed ioctl. A system configured to panic on warnings
could turn that warning into an outage. No memory corruption or disclosure
was shown. Sustained memory pressure and concurrency were not tested.

Kind Regards,
BART CHRONOWSKI

On Fri, Oct 23, 2026 at 01:18:15PM +0000, syzbot wrote:
> In drm_mode_create_lease_ioctl(), user space supplies an object_count and
> an array of object_ids to be leased. The kernel copies the IDs from user
> space using memdup_array_user(), and then fill_object_idr() allocates a
> temporary array of pointers using kzalloc_objs(struct drm_mode_object *,
> object_count) (at drivers/gpu/drm/drm_lease.c:389 in the reported tree).
>=20
> Because kzalloc_objs() performs a kmalloc-family allocation with GFP_KERN=
EL
> (which lacks __GFP_NOWARN), if user space requests a sufficiently large
> object_count (for example, 1,000,000 mode objects), the allocation for the
> pointer array (1,000,000 * 8 =3D 8,000,000 bytes on 64-bit systems) requi=
res
> order 11 pages. This exceeds MAX_PAGE_ORDER and triggers a warning in the
> page allocator at historical warning-site line drm_lease.c:389 in the
> reported tree:
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
> Furthermore, cl->object_count is an unbounded __u32, whereas helper
> functions such as fill_object_idr() take object_count as a signed integer.
> A value of cl->object_count greater than INT_MAX is converted to a signed
> parameter (becoming negative) rather than causing signed arithmetic
> overflow. In addition, an allocation size exceeding INT_MAX would trigger=
 a
> WARN_ON_ONCE inside __kvmalloc_node_noprof().
>=20
> Fix these issues by validating cl->object_count early in
> drm_mode_create_lease_ioctl() so that values exceeding INT_MAX are reject=
ed
> with -EINVAL. In addition, cap object_count to DRM_MAX_LEASE_OBJECTS
> (1024). In DRM, only CRTCs, connectors, and planes are leaseable, and DRM
> core bounds each to 32 objects via 32-bit index bitmasks (totaling at most
> 96 leaseable objects). A limit of 1024 covers all supported leaseable
> objects while staying within a reasonable allocation budget. Additionally,
> switch the object_ids allocation to vmemdup_array_user() and the objects
> pointer array allocation to kvzalloc_objs(), freeing both with kvfree().
> The vmalloc fallback eliminates the high-order allocation warning, while
> the count limit controls resource usage.
>=20
> Fixes: 62884cd386b8 ("drm: Add four ioctls for managing drm mode object l=
eases [v7]")
> Assisted-by: Gemini:gemini-4-argon Gemini:gemini-3.8-flash syzbot
> Reported-by: syzbot+6754751ad05524dae739@syzkaller.appspotmail.com
> Closes: https://syzkaller.appspot.com/bug?extid=3D6754751ad05524dae739
> Link: https://syzkaller.appspot.com/ai_job?id=3D7dc96556-ceb4-414e-a4cf-b=
696df125160
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
> v2:
> - Define DRM_MAX_LEASE_OBJECTS (1024) and cap object_count to it to bound=
 per-request resource usage based on supported leaseable DRM objects.
> - Validate cl->object_count > INT_MAX directly in early checks.
> - Update commit description to clarify conversion to signed parameter, al=
location budget rationale, and historical warning site line in reported tre=
e.
>=20
> v1:
> https://lore.kernel.org/all/4c497e30-fff3-4ef0-81f9-b9b47ca9e22f@mail.ker=
nel.org/T/
> ---
> diff --git a/drivers/gpu/drm/drm_lease.c b/drivers/gpu/drm/drm_lease.c
> index 5d2cf724c..6f05dde38 100644
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
> @@ -69,6 +72,14 @@
>  #define drm_for_each_lessee(lessee, lessor) \
>  	list_for_each_entry((lessee), &(lessor)->lessees, lessee_list)
> =20
> +/*
> + * Only CRTCs, connectors, and planes are leaseable, and DRM core bounds
> + * each to 32 objects (32-bit index bitmasks). Cap per-request object_co=
unt
> + * to a small finite limit that covers all supported leaseable objects
> + * within a reasonable allocation budget.
> + */
> +#define DRM_MAX_LEASE_OBJECTS 1024
> +
>  static uint64_t drm_lease_idr_object;
> =20
>  struct drm_master *drm_lease_owner(struct drm_master *master)
> @@ -386,7 +397,7 @@ static int fill_object_idr(struct drm_device *dev,
>  	int ret;
>  	bool universal_planes =3D READ_ONCE(lessor_priv->universal_planes);
> =20
> -	objects =3D kzalloc_objs(struct drm_mode_object *, object_count);
> +	objects =3D kvzalloc_objs(struct drm_mode_object *, object_count);
>  	if (!objects)
>  		return -ENOMEM;
> =20
> @@ -462,7 +473,7 @@ static int fill_object_idr(struct drm_device *dev,
>  		if (objects[o])
>  			drm_mode_object_put(objects[o]);
>  	}
> -	kfree(objects);
> +	kvfree(objects);
>  	return ret;
>  }
> =20
> @@ -496,6 +507,11 @@ int drm_mode_create_lease_ioctl(struct drm_device *d=
ev,
>  		return -EINVAL;
>  	}
> =20
> +	if (cl->object_count > INT_MAX) {
> +		drm_dbg_lease(dev, "too many objects: %u\n", cl->object_count);
> +		return -EINVAL;
> +	}
> +
>  	lessor =3D drm_file_get_master(lessor_priv);
>  	/* Do not allow sub-leases */
>  	if (lessor->lessor) {
> @@ -509,8 +525,15 @@ int drm_mode_create_lease_ioctl(struct drm_device *d=
ev,
>  	/* Handle leased objects, if any */
>  	idr_init(&leases);
>  	if (object_count !=3D 0) {
> -		object_ids =3D memdup_array_user(u64_to_user_ptr(cl->object_ids),
> -					       object_count, sizeof(__u32));
> +		if (object_count > DRM_MAX_LEASE_OBJECTS) {
> +			drm_dbg_lease(dev, "too many objects: %zu\n", object_count);
> +			ret =3D -EINVAL;
> +			idr_destroy(&leases);
> +			goto out_lessor;
> +		}
> +
> +		object_ids =3D vmemdup_array_user(u64_to_user_ptr(cl->object_ids),
> +						object_count, sizeof(__u32));
>  		if (IS_ERR(object_ids)) {
>  			ret =3D PTR_ERR(object_ids);
>  			idr_destroy(&leases);
> @@ -520,7 +543,7 @@ int drm_mode_create_lease_ioctl(struct drm_device *de=
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
