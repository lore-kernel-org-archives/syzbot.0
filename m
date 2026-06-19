Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7D1CA372055
	for <syzbot@lists.linux.dev>; Fri, 19 Jun 2026 10:21:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781864520; cv=none; b=sbihHO6p3pJjwwbgtApowNVZENnowdXfwe+hDeaWcSiipcScETt8YZqLubbXjHxLSU2DeDFMSkPM4bhCBAnlD+dwHfbAEXaK6xYXabY9iMfT3ke5NjueQNbpTJgyLDa6Zij3aq9oIdovgPHDDKag1fW2HVBw6oHKYzZwBPoCq9s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781864520; c=relaxed/simple;
	bh=5cAqNeWA+mcuJQWRqd30unHMyTMQKzEd5XYuvoBQbys=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=ofLOfXk+cplBtohefADocWRoPW37uObKXLUeNHIqqIu2LcuO6Y9tpR+0yx5plK8RCSoQhF/C5SkvArGDtERNz7hxhslCTRSVWLeWNmhMC5HLJqhY9kd9xalcFN7eZSOQnL5j3Jw9cDuqr+AV25qNGaZTT+n8wHclLTQCqY1nQ+4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=kiEyecHs; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="kiEyecHs"
Received: by smtp.kernel.org (Postfix)
	id 0E1171F00A3A; Fri, 19 Jun 2026 10:21:57 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C670B1F000E9;
	Fri, 19 Jun 2026 10:21:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1781864517;
	bh=wajVLqh1VnzE9ylsKSE3noKIunqLO+jBnIBXRU0NTvQ=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=kiEyecHsjYJxB358yHmoo/PnPePhXl93/2+fJT3WL7SEacopAME2CQfMSYQCIPVw/
	 pUS0PC2Ao3Kr1r1myw/QqmqUETbSj1dBPnRxOJVDCYRlrtAWcA6IlC1sCEOe8YBrwl
	 bSIv+mdktVyWYlR9N7YaInG35KZ07tkSbVAl7YZYzT9GC8fG7xDn0HCta+v8vMjyeM
	 HkadA4DRB9/iTWuLP2uO9DlWh+W6udFpFJ4KCo4JiOnRJ79QMuipE0V6ZVQfkPTyiO
	 82u49qeqWJq9+KBD97HOAy+ijzp54hbZYAmKcnihZspcVgQZRJHZkf+jAeAPqLTZPH
	 iMTGiUWPXmWkA==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH] drm/lease: use kvmalloc for temporary ioctl arrays
Reply-To: sashiko-reviews@lists.linux.dev
To: syzbot <syzbot@kernel.org>
Cc: dri-devel@lists.freedesktop.org
In-Reply-To: <c718300f-9eec-4292-95c9-1b35e1c697e7@mail.kernel.org>
References: <c718300f-9eec-4292-95c9-1b35e1c697e7@mail.kernel.org>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Fri, 19 Jun 2026 10:21:56 +0000
Message-Id: <20260619102156.C670B1F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: syzbot@lists.linux.dev
List-Id: <syzbot.lists.linux.dev>
List-Subscribe: <mailto:syzbot+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:syzbot+unsubscribe@lists.linux.dev>

Thank you for your contribution! Sashiko AI review found 1 potential issue(=
s) to consider:
- [High] Unbounded user-controlled array allocation and unbounded loop iter=
ation leading to soft lockup (Denial of Service).
--

commit 7fbca73c75b2d8380009850496a05eb9659b0cab
Author: Aleksandr Nogikh <nogikh@google.com>

drm/lease: use kvmalloc for temporary ioctl arrays

This commit replaces kzalloc_objs() and memdup_array_user() with
kvcalloc() and vmemdup_array_user() in drm_mode_create_lease_ioctl()
to prevent warnings when userspace provides a large object_count.

Link: https://syzkaller.appspot.com/ai_job?id=3D22f7a1b3-b0e0-4e5d-abf2-e71=
19094823a

> diff --git a/drivers/gpu/drm/drm_lease.c b/drivers/gpu/drm/drm_lease.c
> index 5d2cf724cbd7b..240e0ea6c5c3d 100644
> --- a/drivers/gpu/drm/drm_lease.c
> +++ b/drivers/gpu/drm/drm_lease.c
> @@ -386,7 +386,8 @@ static int fill_object_idr(struct drm_device *dev,
>  	int ret;
>  	bool universal_planes =3D READ_ONCE(lessor_priv->universal_planes);
> =20
> -	objects =3D kzalloc_objs(struct drm_mode_object *, object_count);
> +	objects =3D kvcalloc(object_count, sizeof(struct drm_mode_object *),
> +			   GFP_KERNEL);

[Severity: High]
Does removing the implicit size limit of kmalloc allow object_count to beco=
me
arbitrarily large?

If object_count is massive, will the subsequent unbounded loop in
fill_object_idr() cause soft lockups?

	for (o =3D 0; o < object_count; o++) {
		objects[o] =3D drm_mode_object_find(dev, lessor_priv,
						  object_ids[o],
						  DRM_MODE_OBJECT_ANY);
		...

Since drm_mode_object_find() acquires and releases a subsystem mutex on each
iteration, and there is no cond_resched() in this loop, could a large
object_count cause the kernel to spin for an excessive amount of time?

[ ... ]

> @@ -509,8 +510,8 @@ int drm_mode_create_lease_ioctl(struct drm_device *de=
v,
>  	/* Handle leased objects, if any */
>  	idr_init(&leases);
>  	if (object_count !=3D 0) {
> -		object_ids =3D memdup_array_user(u64_to_user_ptr(cl->object_ids),
> -					       object_count, sizeof(__u32));
> +		object_ids =3D vmemdup_array_user(u64_to_user_ptr(cl->object_ids),
> +						object_count, sizeof(__u32));

[Severity: High]
Similar to the objects array above, does changing to vmemdup_array_user()
remove the implicit bounds check on object_count that was previously enforc=
ed
by the slab allocator limits?

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/c718300f-9eec-4292-=
95c9-1b35e1c697e7@mail.kernel.org?part=3D1
