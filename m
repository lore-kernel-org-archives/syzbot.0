Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C7E5135E1A5
	for <syzbot@lists.linux.dev>; Fri, 15 May 2026 19:48:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778874522; cv=none; b=bXY5hebIoJrwEFKA6MLgssZ6MS024rn5BDLpeycJaGvqBTxrZL8kduXWfDSvrRtyRVylB73Wiu5x0drsWBHP3tTDDqk1YqEY41VjbcqPJGd1Ju+D1n92NJP5g+tGs1z/o4MTfV+fcrzBb7hD0ALNu8oOtnCQx+j/UDjDdsnDXuQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778874522; c=relaxed/simple;
	bh=4lC6YjlRemMinPqwtmKokNE1CpoXiEw5+ga1Z3XyG5A=;
	h=MIME-Version:Date:In-Reply-To:Message-ID:Subject:From:To:Cc:
	 Content-Type; b=dsPMVd0N0P78gVhL8HXVfPAm6OihFK806j/n5vN8jeLoMl1fTTolzXGo49tBpUfY4zw7+DUiC5IzoDrMS6DCKsOWqPKu1ul3CbiNgye6BIUHmCWtK/O5JAULl4Okhet58XfcuWb83u348SNxSfLxj4gnoqC3ZHFiwcPyPWdVVIo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix)
	id 14012C2BCB3; Fri, 15 May 2026 19:48:42 +0000 (UTC)
Received: from mail-oa1-f71.google.com (mail-oa1-f71.google.com [209.85.160.71])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp.kernel.org (Postfix) with ESMTPS id 92485C2BCB0
	for <syzbot@kernel.org>; Fri, 15 May 2026 19:48:40 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 smtp.kernel.org 92485C2BCB0
Authentication-Results: smtp.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com
Authentication-Results: smtp.kernel.org; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com
Received: by mail-oa1-f71.google.com with SMTP id 586e51a60fabf-43a5232c87eso661372fac.3
        for <syzbot@kernel.org>; Fri, 15 May 2026 12:48:40 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1778874519; x=1779479319;
        h=content-transfer-encoding:cc:to:from:subject:message-id:in-reply-to
         :date:mime-version:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=q1yqeGL6qCVwXgNxgG+uxPK5ueACkRpV7OimDthn2qQ=;
        b=OZbv9iwpdmnQU7a1x4MO+oRDmkgiaG6mahjDSYCRMjs1nYXzdaR2bZw+e6ENWfBJC4
         7nAJiXFpXvQUZCDASb4Q9t26uNj8+p7qTOOJ1NvW1NTiwwWIbfv4movwAR/Lo0uLzqR2
         TsYZB4SiOGkqFdaOZ0ClewK77p4ip9zOIyTntuQGKUSJ+q1xjotv7R1l61S5hUjZi5gk
         Q2UkRFan7W7nDLk0SBBf4aUV/OEuh8NDsR0ytuJRAfFGV5ie6ZVOM5yrdfKzYzQ8JTi6
         jvKPtd4rICGPbA4KmKYm/xZa5Saeg2r/KEFRBzFLFSTNQx9zVzsJhhbeYiretfeC0Cgd
         MMHw==
X-Forwarded-Encrypted: i=1; AFNElJ8WWaPD5SyBrYqam3+vRXdGkjQI6Bo+X+Nyq22XU46XmVtpe6n9rfQPe5fyU6VK0FpnGLAFG0g=@kernel.org
X-Gm-Message-State: AOJu0YzrhvlSZQg3ecBYzx/lHpYnwGTuOWpd/Ysy16Qm8YsEL7KpXj5y
	/upjbenkORf2N9FQz7wu5ZQda3UBhJTbjU1BnrteQcIIl9Entq6LvC3/BRLeve0bQrcXScWf8y1
	8PPS4od00rq5nRifxB4tcBMMbQPgWzk4ohlu8ixRB2d4ewueUn3RA16qIxBI=
Precedence: bulk
X-Mailing-List: syzbot@lists.linux.dev
List-Id: <syzbot.lists.linux.dev>
List-Subscribe: <mailto:syzbot+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:syzbot+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Received: by 2002:a05:6820:602:b0:688:c97d:bfc3 with SMTP id
 006d021491bc7-69c9437cd86mr3533943eaf.38.1778874519674; Fri, 15 May 2026
 12:48:39 -0700 (PDT)
Date: Fri, 15 May 2026 12:48:39 -0700
In-Reply-To: <CANp29Y4G5HbXgrsuKBE0HLFud+OuLVz_9EAbLSMZtF1pSbiakg@mail.gmail.com>
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <6a077897.050a0220.298be4.0001.GAE@google.com>
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
