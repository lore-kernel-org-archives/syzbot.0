Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 75D5542EEC1
	for <syzbot@lists.linux.dev>; Fri, 15 May 2026 09:44:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778838257; cv=none; b=lcyKW19qSTWgm2DrBAhgjZz8VjMP/3ZGuR5yS0ZD+dOim84ds0Yh78VvivTinVA3NNwEcjfiAhqm2fk8L+YbYW0XHZPmiqLCiVCeOcF8R3vJw1SgOXIwU+zmwyHD9dIUV4ias77VgcAmbydAtU/kiPh0QERe9toxpZ1/3OST9tw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778838257; c=relaxed/simple;
	bh=4lC6YjlRemMinPqwtmKokNE1CpoXiEw5+ga1Z3XyG5A=;
	h=MIME-Version:Date:In-Reply-To:Message-ID:Subject:From:To:Cc:
	 Content-Type; b=RtXkmd9mY85LkYHNySgOVy7r6bG5ri+Vm9FDPKLfGgHLJpItjWsnC7Vty8/UN7cAe8tbk6cnNd7jKpI4jRnIi0m8aHcaCtAGK3FHRV6NxmeO7ZksosBsD2GdvdGZMz/NNrOQgQZ5XyoAeJEYqtqMOQH2dDLCAnu7PGjBCEEX6ts=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix)
	id 65D27C2BCB3; Fri, 15 May 2026 09:44:17 +0000 (UTC)
Received: from mail-ot1-f70.google.com (mail-ot1-f70.google.com [209.85.210.70])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp.kernel.org (Postfix) with ESMTPS id 71322C2BCB0
	for <syzbot@kernel.org>; Fri, 15 May 2026 09:44:16 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 smtp.kernel.org 71322C2BCB0
Authentication-Results: smtp.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com
Authentication-Results: smtp.kernel.org; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com
Received: by mail-ot1-f70.google.com with SMTP id 46e09a7af769-7dce1e67fccso11532842a34.2
        for <syzbot@kernel.org>; Fri, 15 May 2026 02:44:16 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1778838255; x=1779443055;
        h=content-transfer-encoding:cc:to:from:subject:message-id:in-reply-to
         :date:mime-version:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=q1yqeGL6qCVwXgNxgG+uxPK5ueACkRpV7OimDthn2qQ=;
        b=Yk2qoetUjbNgu18mJV/juuJ89VzU99Zs9L0yO9fjRjpuVN4swHNZ617pNySpB+v3wG
         ypAETZkks81e0MEYTLw4Cn73Q3yE6mToSyZmhbg/tv78q1x1e/rXplaA5cON4kPYSlLZ
         mtn6a0dWbOi+3EWxx5VGhuAE7igv3h4BCsZvl9Ch9iCmDG6AO1r06ID6gnkrXD0TcfF8
         u4kXFqjGbZS4rP6Sf4FQ0OtTVlF8XSC9IDaRJFRQEdHiSoYaDrxqoVo8fO7mDw9YevMl
         X82czXRoI83U42jfe2Hxm/jLDviAhnkZKD2DJ12BEa20qJ1LSLezpTfOAzwungaK7BKD
         tN/A==
X-Forwarded-Encrypted: i=1; AFNElJ+TCkqy6kPZ2jnVsSWKjGujFIjIg8SczvIYQ5/ObVPZMmBFB3yWiBrePtcTljbHnB057goJCAg=@kernel.org
X-Gm-Message-State: AOJu0YyRHjREj2Q++CuJH0k+E7HEaqyPt6W6b0uq6nv54tBpNsSrjJix
	mUH/6ClbNl8eZQ+VLVJkZkgL3BpRSjJ+PgYrFDgND5qBg84UzFcN9HmA6gTj+GzmdK4pysaD27l
	44ixGLq2+STBGdScHCcCQeia2JczFKRY8PfVknjIASWjQ2IBcW1X7XUIwJEI=
Precedence: bulk
X-Mailing-List: syzbot@lists.linux.dev
List-Id: <syzbot.lists.linux.dev>
List-Subscribe: <mailto:syzbot+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:syzbot+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Received: by 2002:a05:6820:1c8c:b0:69b:bf80:2dbd with SMTP id
 006d021491bc7-69c9bfee652mr1857282eaf.59.1778838255462; Fri, 15 May 2026
 02:44:15 -0700 (PDT)
Date: Fri, 15 May 2026 02:44:15 -0700
In-Reply-To: <CANp29Y4G5HbXgrsuKBE0HLFud+OuLVz_9EAbLSMZtF1pSbiakg@mail.gmail.com>
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <6a06eaef.170a0220.1dc4b5.0021.GAE@google.com>
Subject: Re: Re: [PATCH RFC] drm/lease: Fix warning on large user-controlled allocations
From: syzbot ci <syzbot@syzkaller.appspotmail.com>
To: nogikh@google.com
Cc: nogikh@google.com, syzbot@kernel.org, syzbot@lists.linux.dev, 
	syzkaller-upstream-moderation@googlegroups.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

> Ok. Let's experiment with "upstreaming" it.
> #syz upstream

Failed to process the command. Contact syzkaller@googlegroups.com.

>
> On Thu, May 14, 2026 at 12:26=E2=80=AFAM 'syzbot' via
> syzkaller-upstream-moderation
> <syzkaller-upstream-moderation@googlegroups.com> wrote:
>>
>> In drm_mode_create_lease_ioctl(), a user-provided object_count is used
>> to allocate memory for object_ids and objects. When a user requests a
>> massive number of objects, the allocation size can exceed the maximum
>> contiguous physical memory limit (MAX_PAGE_ORDER). Since kzalloc_objs()
>> defaults to GFP_KERNEL without __GFP_NOWARN, this triggers a
>> WARN_ON_ONCE_GFP in the page allocator.
>>
>> To fix this, replace kzalloc_objs() with kvzalloc_objs() in
>> fill_object_idr() and memdup_array_user() with vmemdup_array_user() in
>> drm_mode_create_lease_ioctl(). This allows the allocations to gracefully
>> fall back to virtually contiguous memory (vmalloc) if the requested size
>> is too large or physical memory is fragmented, preventing the warning
>> and allowing large lease requests to succeed or fail gracefully with
>> -ENOMEM. Update the corresponding kfree() calls to kvfree() accordingly.
>>
>> Fixes: 62884cd386b876638720ef88374b31a84ca7ee5f ("drm: Add four ioctls f=
or managing drm mode object leases [v7]")
>> Assisted-by: Gemini:gemini-3.1-pro-preview Gemini:gemini-3-flash-preview
>> Reported-by: syzbot+03fb58296859d8dbab4d@syzkaller.appspotmail.com
>> Link: https://syzkaller.appspot.com/bug?extid=3D03fb58296859d8dbab4d
>> Link: https://syzkaller.appspot.com/ai_job?id=3Dd9152b5a-380f-4c4e-af5b-=
1890078e5d46
>> To: <airlied@gmail.com>
>> To: <dri-devel@lists.freedesktop.org>
>> To: <maarten.lankhorst@linux.intel.com>
>> To: <mripard@kernel.org>
>> To: <simona@ffwll.ch>
>> To: <tzimmermann@suse.de>
>> Cc: <linux-kernel@vger.kernel.org>
>>
>> ---
>> diff --git a/drivers/gpu/drm/drm_lease.c b/drivers/gpu/drm/drm_lease.c
>> index 5d2cf724c..9ccfa4712 100644
>> --- a/drivers/gpu/drm/drm_lease.c
>> +++ b/drivers/gpu/drm/drm_lease.c
>> @@ -386,7 +386,7 @@ static int fill_object_idr(struct drm_device *dev,
>>         int ret;
>>         bool universal_planes =3D READ_ONCE(lessor_priv->universal_plane=
s);
>>
>> -       objects =3D kzalloc_objs(struct drm_mode_object *, object_count)=
;
>> +       objects =3D kvzalloc_objs(struct drm_mode_object *, object_count=
);
>>         if (!objects)
>>                 return -ENOMEM;
>>
>> @@ -462,7 +462,7 @@ static int fill_object_idr(struct drm_device *dev,
>>                 if (objects[o])
>>                         drm_mode_object_put(objects[o]);
>>         }
>> -       kfree(objects);
>> +       kvfree(objects);
>>         return ret;
>>  }
>>
>> @@ -509,8 +509,8 @@ int drm_mode_create_lease_ioctl(struct drm_device *d=
ev,
>>         /* Handle leased objects, if any */
>>         idr_init(&leases);
>>         if (object_count !=3D 0) {
>> -               object_ids =3D memdup_array_user(u64_to_user_ptr(cl->obj=
ect_ids),
>> -                                              object_count, sizeof(__u3=
2));
>> +               object_ids =3D vmemdup_array_user(u64_to_user_ptr(cl->ob=
ject_ids),
>> +                                               object_count, sizeof(__u=
32));
>>                 if (IS_ERR(object_ids)) {
>>                         ret =3D PTR_ERR(object_ids);
>>                         idr_destroy(&leases);
>> @@ -520,7 +520,7 @@ int drm_mode_create_lease_ioctl(struct drm_device *d=
ev,
>>                 /* fill and validate the object idr */
>>                 ret =3D fill_object_idr(dev, lessor_priv, &leases,
>>                                       object_count, object_ids);
>> -               kfree(object_ids);
>> +               kvfree(object_ids);
>>                 if (ret) {
>>                         drm_dbg_lease(dev, "lease object lookup failed: =
%i\n", ret);
>>                         idr_destroy(&leases);
>>
>>
>> base-commit: 5d6919055dec134de3c40167a490f33c74c12581
>> --
>> This is an AI-generated patch subject to moderation.
>> Reply with '#syz upstream' to send it to the mailing list.
>> Reply with '#syz reject' to reject it.
>>
>> See  for more information.
>>
>> --
>> You received this message because you are subscribed to the Google Group=
s "syzkaller-upstream-moderation" group.
>> To unsubscribe from this group and stop receiving emails from it, send a=
n email to syzkaller-upstream-moderation+unsubscribe@googlegroups.com.
>> To view this discussion visit https://groups.google.com/d/msgid/syzkalle=
r-upstream-moderation/9cbc091e-97f8-41a3-97eb-c1f2137ccc53%40mail.kernel.or=
g.
