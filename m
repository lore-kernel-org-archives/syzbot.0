Received: from mail-oa1-f71.google.com (mail-oa1-f71.google.com [209.85.160.71])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 07EF1410D1C
	for <syzbot@lists.linux.dev>; Mon, 18 May 2026 12:36:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.160.71
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779107780; cv=none; b=O8fcmIbP/quZGp+jofLIbg9wZTjlu7BQMSjBdctf/CVjwEyY7of0jovuxEEhd2Xec2toEWgms0jY2YhcJZUjfapjQA6kWshD8iz9kt/1WX2YL2eUxYiLlXa5OnfZ+Uhe/T8mKAzPWqVR++IhB7sbqzjjk+wR6FUnDfZEbhYiado=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779107780; c=relaxed/simple;
	bh=hxrQ24wFEYiDlsw242neXgyDvZBYeMGXWNv9cueRWfQ=;
	h=MIME-Version:Date:In-Reply-To:Message-ID:Subject:From:To:Cc:
	 Content-Type; b=KSpKyqIwWeaCCezxPeURl7zS9QSAX9YQiIKJrXZHuc5iuJx48ip3Bh7wNCdWIodRP7lxZcLNrKJrNLXbxK7J0vp5nsOgYOtk2GNuWNsPcaupdtXEslCYBUEQexR1XdMTY6TqM7y+uX4VbR8CiTxATeCWZYSQJQ7UhhVkRlU8u9s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com; arc=none smtp.client-ip=209.85.160.71
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com
Received: by mail-oa1-f71.google.com with SMTP id 586e51a60fabf-439bc8a6ce4so2328528fac.2
        for <syzbot@lists.linux.dev>; Mon, 18 May 2026 05:36:18 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1779107778; x=1779712578;
        h=content-transfer-encoding:cc:to:from:subject:message-id:in-reply-to
         :date:mime-version:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=eQq2PM++d2hZHIlmQOlTW1K8Zhe9fg+7SpcA4aYvBqE=;
        b=sVAgnj3qMhThxEt1a1L1TArbUhQjO4bEFLtRx3frLuJqopEtpu7fhHBuDBgA7camzD
         U6bxsW0B4VRC2Z2TMLME4R7CXAwc1/NXJ5TtbLgJGOEkyAwn+Uzfm6sc2w80L3q/kEL+
         0U2blg0pFeJfGpykFwveB/BJEovQjH/ZnNSVy63EYiW4zxswboNp+4dDCGYR3YOxwOfI
         3eJbV8vV5cqub9OFG1CsSCYGrdt8Qgkd/zWbUAPW6uNxBkzaoRGQB3wHXhfFzMgsNSIo
         +V323dpZAQtdNLPPoGe+/As4TA5adtjFxnGLIxAz5Gtnw6CQAMMSq5TAZlksa5RjaCWB
         vZVQ==
X-Forwarded-Encrypted: i=1; AFNElJ83ox95YAGZllNQ4oGrYgbSVHZg8H0eVOmveaUXQRBg8Nh77dACMChW+/IAFiyC/3Co7wpn4O0=@lists.linux.dev
X-Gm-Message-State: AOJu0YzMH4O1zIerrxwdW6NH9dSgJXaurtNSYFEjnlTfLS9AqhDNsjxk
	UBy++1E71fYkICiky6GsTrfHN5Dd1tbIwpCHD6Ik3pCiFjtX/388WhkahtHTryJszBAWlhRgBoU
	us0tT2nS411s1r+nTGuMC2kkQGOsTfYC5ZIvVt8psBJPqL07Au1X8aE2EfCM=
Precedence: bulk
X-Mailing-List: syzbot@lists.linux.dev
List-Id: <syzbot.lists.linux.dev>
List-Subscribe: <mailto:syzbot+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:syzbot+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Received: by 2002:a05:6820:1f06:b0:686:48b7:d822 with SMTP id
 006d021491bc7-69c94372dadmr9018293eaf.39.1779107778093; Mon, 18 May 2026
 05:36:18 -0700 (PDT)
Date: Mon, 18 May 2026 05:36:18 -0700
In-Reply-To: <CANp29Y7fBpjFOmWLZp-6RtOksJrNqM3kBzKGBZAXmDNLw3okyQ@mail.gmail.com>
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <6a0b07c2.050a0220.2251c6.000c.GAE@google.com>
Subject: Re: [PATCH RFC] drm/lease: Fix warning on large user-controlled allocations
From: syzbot <syzbot+03fb58296859d8dbab4d@syzkaller.appspotmail.com>
To: nogikh@google.com
Cc: nogikh@google.com, syzbot@kernel.org, syzbot@lists.linux.dev, 
	syzkaller-upstream-moderation@googlegroups.com, linux-kernel@vger.kernel.org, 
	syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

> ... and with one more fix on syz-cluster side
>
> #syz upstream

Can't upstream, this is final destination.

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
>
> --=20
> You received this message because you are subscribed to the Google Groups=
 "syzkaller-upstream-moderation" group.
> To unsubscribe from this group and stop receiving emails from it, send an=
 email to syzkaller-upstream-moderation+unsubscribe@googlegroups.com.
> To view this discussion visit https://groups.google.com/d/msgid/syzkaller=
-upstream-moderation/CANp29Y7fBpjFOmWLZp-6RtOksJrNqM3kBzKGBZAXmDNLw3okyQ%40=
mail.gmail.com.
