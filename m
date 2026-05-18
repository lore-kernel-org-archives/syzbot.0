Received: from mail-oi1-f200.google.com (mail-oi1-f200.google.com [209.85.167.200])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4259A3E16AD
	for <syzbot@lists.linux.dev>; Mon, 18 May 2026 08:50:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.167.200
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779094230; cv=none; b=qRmoH5zqgoHwt8hTlR2uSzXRfBCVxmlLXV9I+LGOLiYmNOo/wUuqOBZzQbHJbnERSk62fvB1nxWZ6cPoQd4TZoPnWnBvWCZrMXbtI/lpnMQbxo95tzr5cnNnRAmOs8LlaZRYExr0UA8YPScp5nfpyfiNvlWSp2Bw0NEoh7sOSBQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779094230; c=relaxed/simple;
	bh=ak0UTsNz3TIH4qpUvCI1iYIoQgjsrFQq28EK8pRUGPI=;
	h=MIME-Version:Date:In-Reply-To:Message-ID:Subject:From:To:Cc:
	 Content-Type; b=tS1txhhLiSuR06dO0kpLTtVIXv1r+v3Q40jAfgpVGZFzjj8zWwkcvs2+6DES4cq0OpgYFztRloYaq5EAiu+t92x6KH86fAvaweF17sYrX4rxrIPFd1KGSn19RU9Xw6Mg/xRMtaZZMK/G+Vh9eqmlCbRBRDo5f7KAGdLxE3w1zvM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com; arc=none smtp.client-ip=209.85.167.200
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com
Received: by mail-oi1-f200.google.com with SMTP id 5614622812f47-4824a871018so1594595b6e.3
        for <syzbot@lists.linux.dev>; Mon, 18 May 2026 01:50:29 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1779094228; x=1779699028;
        h=content-transfer-encoding:cc:to:from:subject:message-id:in-reply-to
         :date:mime-version:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=MnOFbfdypKHPlJKlRQ+rTMSo2eu/oyjA/a9cpwWc95o=;
        b=d+/we0oL/8+lD8vmj5zTCmOFa+CcuB5yR9vGOQVWbohdpB85q6cOBNf46phs4CT5O5
         4YB1BnrkhR9wzJn8QNNCcxKb2gfLAHQk4KTa60tcwGlX8j7tvcwE8nHNPGDCe39DXfM2
         i6/8Sq2AEdMO12Q73QBhNtuM9zcZlj0SVVaaLlfF3CJhgZ2ft1P/A0/x4kWDxdrdh3P+
         VtDP0dw57ndjcjs7rTtxCH6oVbmHpEbJ6h+ChIhDY2SHXLDD2Oa3JMtuMxNciT/lo05R
         LRL3A9oWx4oxVylfrSKQNi9OtVLeeGVSm+h6Rm29E5x1RYy3NtdGBwKoPWvh2swklr1f
         33Hg==
X-Forwarded-Encrypted: i=1; AFNElJ+9GXukm58T94vTVePNycR/7aeCkibY/A8y5R0ofTdS7LPfP/7QfvCnbyAwYZlO7LkV3eg08g0=@lists.linux.dev
X-Gm-Message-State: AOJu0Yz4ccIW6C7f/tsTURWy1wd3FjffJFQD512DhViyeNyssjOv1uW8
	xh88BAOJQKm4CSluvk2Wcl10OqpPsUMQmOwNOOunScC07JEKLhsSM8ucB5cYV/7mbNegg4uLNbA
	n7fsboE9m4fPNSHAENyLy68nNmJOd4uvTk3J/2jdN93anv9pzCtTx29Jia/I=
Precedence: bulk
X-Mailing-List: syzbot@lists.linux.dev
List-Id: <syzbot.lists.linux.dev>
List-Subscribe: <mailto:syzbot+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:syzbot+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Received: by 2002:a05:6820:818b:b0:69b:5fcb:1d7f with SMTP id
 006d021491bc7-69c942af26amr8793610eaf.12.1779094228130; Mon, 18 May 2026
 01:50:28 -0700 (PDT)
Date: Mon, 18 May 2026 01:50:28 -0700
In-Reply-To: <CANp29Y4j=Yy5FnXBmwQsmRJLWdhJjUv1w_uncV6U5k2NzsKHyQ@mail.gmail.com>
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <6a0ad2d4.170a0220.bc3c0.000d.GAE@google.com>
Subject: Re: Re: [PATCH RFC] drm/lease: Fix warning on large user-controlled allocations
From: syzbot ci <syzbot@syzkaller.appspotmail.com>
To: nogikh@google.com
Cc: nogikh@google.com, syzbot@kernel.org, syzbot@lists.linux.dev, 
	syzkaller-upstream-moderation@googlegroups.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

> Let's try again and see if syzbot ci reacts:
>
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
