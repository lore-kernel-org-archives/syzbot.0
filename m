Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B267A4C8FFC
	for <syzbot@lists.linux.dev>; Fri, 15 May 2026 16:06:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778861180; cv=none; b=W0IfXtKTyEgcO9hr04Oedf7mWhW5hUNOag7lgAGiKxjgiXzAXNXSG6jw+5tKUGSYzfowM0zC1YiK8W67c0KkIrQVythzsOXGIrIx++lFDLsJ/Mqb7mtERq0nPCtw5t8KL+AIscOkK6Gp31mqws5ozbf6nYGbKkEUtIqmKMeLVtc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778861180; c=relaxed/simple;
	bh=4lC6YjlRemMinPqwtmKokNE1CpoXiEw5+ga1Z3XyG5A=;
	h=MIME-Version:Date:In-Reply-To:Message-ID:Subject:From:To:Cc:
	 Content-Type; b=LiKRW2wg9aFN/NTCzOYrxX//Rlr2Ic72PKkftS/+bc5QiD6Mj+VmzHXT9SONEwyKFwOl3T9dfise4UIaolADfM+fqncH978wlk64FC6eCdEfXuqM3kNK/EQEv/pf2jfjsAn/hkkFtPtW3X193Q7kwUgHJW+efhSxrbSnSeelY/g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix)
	id 8BCAEC2BCB3; Fri, 15 May 2026 16:06:20 +0000 (UTC)
Received: from mail-ot1-f69.google.com (mail-ot1-f69.google.com [209.85.210.69])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp.kernel.org (Postfix) with ESMTPS id 83713C2BCB0
	for <syzbot@kernel.org>; Fri, 15 May 2026 16:06:19 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 smtp.kernel.org 83713C2BCB0
Authentication-Results: smtp.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com
Authentication-Results: smtp.kernel.org; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com
Received: by mail-ot1-f69.google.com with SMTP id 46e09a7af769-7dbd60b7ecbso19153579a34.1
        for <syzbot@kernel.org>; Fri, 15 May 2026 09:06:19 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1778861178; x=1779465978;
        h=content-transfer-encoding:cc:to:from:subject:message-id:in-reply-to
         :date:mime-version:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=q1yqeGL6qCVwXgNxgG+uxPK5ueACkRpV7OimDthn2qQ=;
        b=nUseO5fY449KWGWjLv31xPKpE8uyk3SRq679jclEgXyY+LXuAg6gLaTCoxIDczDR/u
         /LAIWc/oYEayy+L8K2+9WGXjLWHxm7g6joZUz6SchJa6bWFrlR4ZuhzxnhFqKg67SgNL
         /DbXjx6gj9IMFpAmLpeg1/05hapRM6/osUR08c9F96a9CG39D5gM+KmZBwsjxyo41NCH
         IfhJx5UYY/Rl7BoXrGMVVPXoS7CL4oPUtvgWbSxN/fv3ljF4YK/l2kyYNhBppLInKsH4
         WBdE8WJc7vHC2XH2cCV677Of/Sc8DOQmEG/aGRKD19csC40eRvZ5C1noDVubReCONaCg
         0BjA==
X-Forwarded-Encrypted: i=1; AFNElJ/XYReYJe2txGqYCfD3mMDc0Vmn7llys7Bb0BALHprTBq+ajU/2ZibWjfh3R0F8yzzH2TuKav0=@kernel.org
X-Gm-Message-State: AOJu0YyW/Dy6RhJo54SyWMBN7nyP3TRKO371V60IWnPcqZRa2tXgJ8dm
	Y2aQAMtqqzM6mtFoS7sWZOWDCN7UVPsFS85F8HKLgc87E+TbiRimWWyxSJff/D63GpEZ+I5vQLL
	4NW4t8v8TYtQxORBqWbarzy+HUIcrK6l2VwCTg/QcQ7BYroode/Rku4x6RGY=
Precedence: bulk
X-Mailing-List: syzbot@lists.linux.dev
List-Id: <syzbot.lists.linux.dev>
List-Subscribe: <mailto:syzbot+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:syzbot+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Received: by 2002:a05:6830:3491:b0:7dc:d2ad:fb17 with SMTP id
 46e09a7af769-7e4f2badcfbmr2896462a34.20.1778861178283; Fri, 15 May 2026
 09:06:18 -0700 (PDT)
Date: Fri, 15 May 2026 09:06:18 -0700
In-Reply-To: <CANp29Y4G5HbXgrsuKBE0HLFud+OuLVz_9EAbLSMZtF1pSbiakg@mail.gmail.com>
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <6a07447a.050a0220.f80e4.0000.GAE@google.com>
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
