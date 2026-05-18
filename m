Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A7971333440
	for <syzbot@lists.linux.dev>; Mon, 18 May 2026 10:46:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779101182; cv=none; b=Pw2stqO5GaH+mUvRdtp42PZSs4Z3kx1G8ESv9qcNxulGoHB3AUG7jy4j43GQgj2PBQuJ2pOOC7oJ0xaZsTpQdpMxGUyASgPeP1cC5lnxOTP2BuNq6+oBlSnTmUMiseprINmf0e6H0e0RuBC/chTtOCieqWbJGRsy5yClNRLg3p0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779101182; c=relaxed/simple;
	bh=ak0UTsNz3TIH4qpUvCI1iYIoQgjsrFQq28EK8pRUGPI=;
	h=MIME-Version:Date:In-Reply-To:Message-ID:Subject:From:To:Cc:
	 Content-Type; b=Pop3xa5FMFEDvWGzKY2syAw6V7vD3qUhJfaf6/Ed2lA5PDDeaYsGA4nv27z5dhqbznk2AJdZenBLHTxpZLrnic23SqKm/wSZo9dmCDtT9ACmhTZjWcNtBWXmfe26WVIeQ4ZMYnLZdvCOzGA7x/rMJ00Xshwqda3vJTq2Zwx+Qyo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix)
	id 91FE8C2BCB7; Mon, 18 May 2026 10:46:21 +0000 (UTC)
Received: from mail-ot1-f71.google.com (mail-ot1-f71.google.com [209.85.210.71])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp.kernel.org (Postfix) with ESMTPS id 9FAA3C2BCC6
	for <syzbot@kernel.org>; Mon, 18 May 2026 10:46:20 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 smtp.kernel.org 9FAA3C2BCC6
Authentication-Results: smtp.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com
Authentication-Results: smtp.kernel.org; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com
Received: by mail-ot1-f71.google.com with SMTP id 46e09a7af769-7e56b6ffa10so7012346a34.1
        for <syzbot@kernel.org>; Mon, 18 May 2026 03:46:20 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1779101179; x=1779705979;
        h=content-transfer-encoding:cc:to:from:subject:message-id:in-reply-to
         :date:mime-version:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=MnOFbfdypKHPlJKlRQ+rTMSo2eu/oyjA/a9cpwWc95o=;
        b=nB5VBKwvXOEI8S506jExsCXiRduiTEfVfs4WYdna+lC638JYT1tP9I0wgO25UYO2Vq
         45xxcxBhLbClAYbIRwc+bqCX6Wmej2XyfwLiMO3QunrvXmu3o/ZUHmzEMftR9s4K7vMB
         eedLU4o4ywU2KdmYTp3rjPGoQ4bpiLrXzd4Hr0Z8YItNrx3jwQgfBeaVyaDE1utvEua8
         /cZX4cemunjS+owItPYmuUweGuM7Dp37qTFnEKGy773L2Xu7XpFUIF8nVZaDBRQYHr68
         Mifv07/uRETrcvmNDDLmpX4jVLC5UIecFq6PKq/P1udfv58SXdHQ7iu11mCnmtE/TPNr
         jlig==
X-Forwarded-Encrypted: i=1; AFNElJ+b02JQoW5DxqPN92dRZyzQBpJUTyBRsj2KXZt/iAPHz6UCMBRtjByE2TMX9u9PQ4rAIf1CUEw=@kernel.org
X-Gm-Message-State: AOJu0YzjqvPVoXbIGR5E8fg7oE//DlMDBnxiJGfMJ8y9WBtlHUnwOyR+
	FUjcnUGmgqlHNGs3knG3oLi/kSz3v+DkFE3w0Q0RfU3jZmTie2wTa2r0N9paH8W16npmpKufSBu
	z7xArG0Y04GPHC2aQK44XNfHgLZ+Y0qjjieimlE+O8USNe00JvpxgfiY24E4=
Precedence: bulk
X-Mailing-List: syzbot@lists.linux.dev
List-Id: <syzbot.lists.linux.dev>
List-Subscribe: <mailto:syzbot+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:syzbot+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Received: by 2002:a05:6820:828e:b0:69d:d07:db6 with SMTP id
 006d021491bc7-69d0d0711b0mr5214614eaf.42.1779101179531; Mon, 18 May 2026
 03:46:19 -0700 (PDT)
Date: Mon, 18 May 2026 03:46:19 -0700
In-Reply-To: <CANp29Y4j=Yy5FnXBmwQsmRJLWdhJjUv1w_uncV6U5k2NzsKHyQ@mail.gmail.com>
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <6a0aedfb.170a0220.143669.0000.GAE@google.com>
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
