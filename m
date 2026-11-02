Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.208.47
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793630280;
	b=cImQIMWE6aADMKJSAhnGTZ2a/NMOxo5jG7VA6SSsrKEj0jflCw5mIb2Ye2QwyOShg9pf
	 5gxz3zZ/nv/qmp8Cx8wpMwYQUeF1lxkn6MexjDwgkdxvJATAShEvAJFB10sKEeVziJ5yO
	 C+bD8Dsyai/Hcc/HONlVyynt4LcCjOnjQgGr+iyBap9PAq8t0cqOnB/GCIGxq+kMHNdYZ
	 R1REQTrm6+5aJErFYBK5vrSxy4axGA2xJUrzjsAeXyy9IPrEZrmS27ZwoUKCY1h2fDRbW
	 KT9MQb9rKj6DgS9mf5zyVFgDWdI1RXavRr11WI+BGp8DjgbOEZIKadLAYEElQQCHyLg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793630280;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Gm-Message-State:X-Gm-Gg:X-Received:Received:Message-ID:Date:
	 MIME-Version:User-Agent:Subject:To:Cc:References:Content-Language:
	 From:In-Reply-To:Content-Type:Content-Transfer-Encoding;
	bh=oFKwSlcjJGOcGHwRINyu72SwWJcZjQnjYT2LvNoG4a0=;
	b=0MlqziGS4P6aMWkjHReuNwQAcbuUSFUmIcZmAbrK1JQpgoSEuLFDPEkwTwCl+z7d/mxx
	 eW/PcA2jmeBKyJAicv5qJroyPBahO8JE1gtceTA5krNXJnzV+60/K9C38mJRr0beHNAmz
	 XGzrX97zEKirXETia9byqb7xGqBp5mhVyZ5YGk1ArpSLZRbK9CgmKbdc88KA893ayghXo
	 cnFQoGpoV/6qZRRXbv6XITnak8Bz8kcyLnuNeZM1DQru7QQ7akkzcfpEpZTf+T2HtaXj0
	 sex6yfvBOziYl2IXAz+Cd4i9T2scd4wDmkiUdOaw1FYZTh0n7ufmBwgvsOE0hWmN2og==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=LyF6SnL7;
	arc=none smtp.remote-ip=209.85.208.47
Received: from mail-ed1-f47.google.com (mail-ed1-f47.google.com [209.85.208.47])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 342FC607992E
	for <syzbot@lists.linux.dev>; Mon,  2 Nov 2026 14:38:00 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 342FC607992E
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=LyF6SnL7
Received: by mail-ed1-f47.google.com with SMTP id 4fb4d7f45d1cf-6b1f31c63ebso6658075a12.0
        for <syzbot@lists.linux.dev>; Mon, 02 Nov 2026 06:38:00 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1793630279; x=1794235079; darn=lists.linux.dev;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=oFKwSlcjJGOcGHwRINyu72SwWJcZjQnjYT2LvNoG4a0=;
        b=LyF6SnL7/C1cfEb6ov3ZoNrLXLYMoHO5ySJ2VE1UmM4bfNWw+6txwlWc0ZwDnSephq
         V827RS8LJJdCKPEojzVlcs2w1CQVeUEwDNdvdW5ITNzh1slP6m2Xs55d98nZf/e5fUjp
         Q9MuQRTsZqzspTV/HdlJQLKK1nzZ1FcSwLhi1GQVG94OZ7EzXOgpJVt4mXfMC++0plbA
         k6rSO9SPRSFqEw9ANa+uiG+OPNm3LE7BXSWHhfwz7KSycGL7MLqmJm72pl8cPqeAwonU
         +4NpV6DZJLOUATJ+ytEkoqKMa3Jhnmv/hnA/wwYiamBV/f1o50me6jFdFn1DTDHCHP8x
         MV9w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793630279; x=1794235079;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=oFKwSlcjJGOcGHwRINyu72SwWJcZjQnjYT2LvNoG4a0=;
        b=hQh59r1cB/vkO7FxOEf1ZJWxZTjmZ8mEZoJGyM5CAb/tMJ+Y+mke03RuTFcLoUH6j3
         daXuRHmA5tQSyn1+EiHTZxGAhxWTVjBXb5xN/sPc6FfLlgi8sQkQcfzr3PKH1SxsmnyU
         Ien3aq+VhF7tGtXYkK0cbRX9FPGTYjddfP6VETmfoUYGdGR7ka/5UpSHGlzrvxCLQgsN
         9PsyHzHN5AoasVAvzp54Ox8mViW6g9YJUfCxbrpdI3O/0PSbyeRUm/EJyqj2T8Gk8UXk
         0403XxlEQ/fSuAe7AwxqT7HMk92MuBugjD2Xry0isxkSrdHJzZdJQeVcrmH22UBQ8s8s
         jlYQ==
X-Gm-Message-State: APuU4Z/NotZkrOrj82p3P/5H3SG6LTfdIAcnkJhN8GkTYW9dDv5Y5nKH
	ePawJBbYfuAuYjZeYHZH+XVNwJZnMdLYQmLMuGWZcYh+2Eqh4Up59HqI
X-Gm-Gg: AYBFou3eQt4JRkq60j2rqxpY286Zs6TVpB6NFZfm8W5tEFobZX84P438OmQ1Udunzfd
	4+OVrfR+Lx2XoAwQSRi/hAYJM6bE0E3KiXP7G+QUkmlcVb+Km6CrOFW6GGJoTeg7fx76FBZEv6t
	NaV/PhEYHwd7Mk/o+HgY6JBjFMWNvPw5XaxMg1LXjVMWeDkxL3njgqAk/8JQvEwJxAie39m/Gxn
	iWyGBQEv7csAV7Yjmk5jgTG9RWFxsc63DVlHLAUWx6bhq3icdW56schM35HqFtk7+mwpS3SF6zJ
	WwnIOX5d/FVusaqtGh1aeMvkMjJHskFAXZQ7ABqdV7sZPLWJSenWQIgwNAMlzHDKES7/qYTFBL+
	ZEG6KhRNjFt5iKy+uZsvLkDeyog8K+Eu1Z9pSN66a2YGPbufBUm8iInw3g8UklqiFcDOWGlc14u
	kk4Ru9ijhoIrFdmYIB7JSsSwJezhp3Yh7k4E8DV+ZVVOD+vlewfCikeeoDfLiAza+vxrH37PtYp
	Tl+GJGlNqJBToAh+wVdnIUXVpcbsyDff5TRLWixw7qH1qGdJhMKgNIVcYMcqFcuzDde7/vYS1Ez
	uLN9OWqr0iTv3mWF75cFqiolvC/iNP+NO56zjNtWPrAR6C4MVcxXKGl0qz3yMJDXI6Gy5XggRSP
	ewQGK
X-Received: by 2002:a17:907:2d14:b0:c3f:2:6faa with SMTP id a640c23a62f3a-c49d10fcf82mr1151440266b.1.1793630278310;
        Mon, 02 Nov 2026 06:37:58 -0800 (PST)
Received: from [192.168.0.50] (93-159-22-200.cgnat.inetia.pl. [93.159.22.200])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-c4cabef2fd2sm395868166b.76.2026.11.02.06.37.57
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 02 Nov 2026 06:37:57 -0800 (PST)
Message-ID: <8197cbc6-9310-4a40-b6be-698ade4bff06@gmail.com>
Date: Mon, 2 Nov 2026 15:37:56 +0100
X-Mailing-List: syzbot@lists.linux.dev
List-Id: <syzbot.lists.linux.dev>
List-Post: <mailto:syzbot@lists.linux.dev>
List-Help: <mailto:syzbot+help@lists.linux.dev>
List-Subscribe: <mailto:syzbot+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:syzbot+unsubscribe@lists.linux.dev>
List-Owner: <mailto:syzbot+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH RFC] media: em28xx: initialize videobuf2 queues before
 device registration
To: syzbot <syzbot@kernel.org>, syzkaller-upstream-moderation@googlegroups.com
Cc: syzbot@lists.linux.dev
References: <2fdb5af1-fad9-47fe-93dc-d1400f44b60b@mail.kernel.org>
Content-Language: en-US
From: Uladzislau Zhauniarovich <uladzislau.zhauniarovich@gmail.com>
In-Reply-To: <2fdb5af1-fad9-47fe-93dc-d1400f44b60b@mail.kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit


Thanks. Most of this patch is now redundant, but one hunk is the
actual fix for this report. Please send a v2 that keeps only that hunk,
rebased on current mainline (v7.4-rc1 or later).

1) Drop the videobuf2 changes. They are already in mainline:

   487344a63f6a ("media: em28xx: setup queues before registering V4L2 
device")
   65ed6e9e3fe2 ("media: usb: em28xx: check if vbi is supported before 
calling vb2_queue_init")

So drop all of the em28xx_vb2_setup() hunks (mutex_init/q->lock moves,
the em28xx_vbi_supported() check, and calling em28xx_vb2_setup() before
video_register_device()).

2) Drop this hunk in em28xx_v4l2_fini():

 > @@ -2429,6 +2437,7 @@ static int em28xx_v4l2_fini(struct em28xx *dev)
 >          vb2_video_unregister_device(&v4l2->vdev);
 >      }
 >
 > +    dev->v4l2 = NULL;
 >      mutex_unlock(&dev->lock);

It is not needed. em28xx_v4l2_fini() runs once per device. Since
288254383674 ("media: em28xx: use v4l2_device release callback"),
dev->v4l2 is meant to stay valid until the last file handle is gone,
and em28xx_free_v4l2() already clears it at that point. Keep the
lifetime rules of that commit unchanged.

3) Keep this hunk exactly as it is. It is the fix:

 > @@ -3097,6 +3104,7 @@ static int em28xx_v4l2_init(struct em28xx *dev)
 >          vb2_video_unregister_device(&v4l2->vdev);
 >      }
 >
 > +    dev->v4l2 = NULL;
 >      mutex_unlock(&dev->lock);

Before 288254383674 the error path cleared dev->v4l2. That commit moved
the clearing into em28xx_free_v4l2(), so after a failed init dev->v4l2
still points to the dying instance. Two things follow:

   - udev's v4l_id can be inside v4l2_open() -> em28xx_v4l2_open(),
     blocked on dev->lock while init runs. When it gets the lock, it
     finds dev->v4l2 set and opens the node that was just unregistered,
     instead of getting -ENODEV.

   - On disconnect, em28xx_v4l2_fini() sees dev->v4l2 != NULL and calls
     v4l2_device_put() a second time. The error path already dropped
     the initial reference, so the refcount hits zero while v4l_id
     still holds the video_device. em28xx_free_v4l2() frees struct
     em28xx_v4l2, which embeds that video_device, and v4l2_open() reads
     vdev->dev_debug from freed memory.

That is exactly the latest crash of this bug, on linux-next
20a33c6b6cbe (2026/10/26), which already has 288254383674:

   BUG: KASAN: slab-use-after-free in v4l2_open+0x397/0x3a0 
drivers/media/v4l2-core/v4l2-dev.c:444
   Freed by task 973:
    em28xx_free_v4l2+0x77/0xf0 drivers/media/usb/em28xx/em28xx-video.c:2337
    v4l2_device_put+0x81/0xd0 drivers/media/v4l2-core/v4l2-device.c:56
    em28xx_v4l2_fini+0x1f3/0x3e0 
drivers/media/usb/em28xx/em28xx-video.c:2465
    em28xx_close_extension+0xde/0x390 
drivers/media/usb/em28xx/em28xx-core.c:1262
    em28xx_usb_disconnect+0x16b/0x2f0 
drivers/media/usb/em28xx/em28xx-cards.c:4489

Please add a short comment above the assignment saying why it is
there: so em28xx_v4l2_open() of the briefly registered node fails with
-ENODEV, and em28xx_v4l2_fini() does not tear the instance down a second
time.

4) Tags and commit message for v2:

   - Fixes: 288254383674 ("media: em28xx: use v4l2_device release callback")
     instead of 7c8bf63b7937.
   - Cc: stable@vger.kernel.org (288254383674 is in v7.3).
   - Subject, e.g.: "media: em28xx: clear dev->v4l2 when v4l2 init fails"
   - Rewrite the changelog around the mechanism in 3) and quote the
     linux-next KASAN report above, not the videobuf2 splat.

The diff should be a single hunk in em28xx_v4l2_init() of about
8 lines (the comment plus "dev->v4l2 = NULL;").

On 16/10/2026 20:57, syzbot wrote:
> In em28xx_v4l2_init(), the videobuf2 queues (v4l2->vb_vidq and
> v4l2->vb_vbiq) are assigned to v4l2->vdev.queue and v4l2->vbi_dev.queue,
> and the video devices are registered with video_register_device() before
> em28xx_vb2_setup() is called to initialize the queues via vb2_queue_init().
>
> When an error occurs after video_register_device() succeeds but before
> em28xx_vb2_setup() is reached (such as v4l2_mc_create_media_graph() failing
> when no decoder is present), the error cleanup path at unregister_dev calls
> vb2_video_unregister_device() on the registered devices. Because
> vdev->queue is set, vb2_video_unregister_device() calls
> vb2_queue_release(), which invokes __vb2_queue_cancel(). However, because
> vb2_queue_init() was never called on the queue, its internal locks and
> waitqueue heads remain zero-filled. This triggers a lockdep warning when
> acquiring q->done_wq.lock, followed by a NULL pointer dereference in
> __wake_up_common() when dereferencing the uninitialized waitqueue head:
>
> INFO: trying to register non-static key.
> The code is fine but needs lockdep annotation, or maybe
> you didn't initialize this object before use?
> turning off the locking correctness validator.
> Call Trace:
>   <TASK>
>   dump_stack_lvl+0xe8/0x150 lib/dump_stack.c:120
>   register_lock_class+0xcc/0x2e0 kernel/locking/lockdep.c:1343
>   __lock_acquire+0x10c/0x2de0 kernel/locking/lockdep.c:5162
>   lock_acquire+0x115/0x350 kernel/locking/lockdep.c:5942
>   _raw_spin_lock_irqsave+0x40/0x60 kernel/locking/spinlock.c:181
>   __wake_up_common_lock+0x30/0x1f0 kernel/sched/wait.c:125
>   __vb2_queue_cancel+0x2de/0xde0
>   drivers/media/common/videobuf2/videobuf2-core.c:2244
>   vb2_core_queue_release+0x2f/0x150
>   drivers/media/common/videobuf2/videobuf2-core.c:2677
>   vb2_queue_release drivers/media/common/videobuf2/videobuf2-v4l2.c:943
>   [inline]
>   vb2_video_unregister_device+0x15b/0x200
>   drivers/media/common/videobuf2/videobuf2-v4l2.c:1279
>   em28xx_v4l2_init+0x1a12/0x2df0
>   drivers/media/usb/em28xx/em28xx-video.c:3097
>   </TASK>
> Oops: general protection fault, probably for non-canonical address
> 0xdffffc0000000000: 0000 [#1] SMP KASAN NOPTI
> KASAN: null-ptr-deref in range [0x0000000000000000-0x0000000000000007]
> RIP: 0010:__wake_up_common kernel/sched/wait.c:105 [inline]
> RIP: 0010:__wake_up_common_lock+0xd6/0x1f0 kernel/sched/wait.c:126
> Call Trace:
>   <TASK>
>   __vb2_queue_cancel+0x2de/0xde0
>   drivers/media/common/videobuf2/videobuf2-core.c:2244
>   vb2_core_queue_release+0x2f/0x150
>   drivers/media/common/videobuf2/videobuf2-core.c:2677
>   vb2_queue_release drivers/media/common/videobuf2/videobuf2-v4l2.c:943
>   [inline]
>   vb2_video_unregister_device+0x15b/0x200
>   drivers/media/common/videobuf2/videobuf2-v4l2.c:1279
>   em28xx_v4l2_init+0x1a12/0x2df0
>   drivers/media/usb/em28xx/em28xx-video.c:3097
>   </TASK>
>
> Additionally, if em28xx_v4l2_init() fails, dev->v4l2 is left set. When the
> device is later disconnected, em28xx_close_extension() invokes
> em28xx_v4l2_fini(), which calls v4l2_device_put() a second time and leads
> to a use-after-free.
>
> Fix this by moving em28xx_vb2_setup() before video_register_device() and
> checking its return value so that queues are initialized prior to device
> registration and any subsequent cleanup. In em28xx_vb2_setup(), initialize
> vb_queue_lock and vb_vbi_queue_lock and assign q->lock before calling
> vb2_queue_init(), and make VBI queue initialization conditional on
> em28xx_vbi_supported(). Finally, set dev->v4l2 to NULL under dev->lock in
> both the unregister_dev error path and in em28xx_v4l2_fini() to prevent
> em28xx_v4l2_fini() from performing a duplicate teardown upon disconnect.
>
> Fixes: 7c8bf63b7937 ("media: em28xx: use vb2_video_unregister_device")
> Assisted-by: Gemini:gemini-4-argon Gemini:gemini-3.8-flash syzbot
> Reported-by: syzbot+1a7507a194fff09e5c44@syzkaller.appspotmail.com
> Closes: https://syzkaller.appspot.com/bug?extid=1a7507a194fff09e5c44
> Link: https://syzkaller.appspot.com/ai_job?id=9fb455aa-6431-4fd2-9460-4bb223f71e03
> To: <linux-media@vger.kernel.org>
> To: "Mauro Carvalho Chehab" <mchehab@kernel.org>
> To: "Hans Verkuil" <hverkuil+cisco@kernel.org>
> Cc: <linux-kernel@vger.kernel.org>
>
> ---
> diff --git a/drivers/media/usb/em28xx/em28xx-video.c b/drivers/media/usb/em28xx/em28xx-video.c
> index 79af15476..edcd884ec 100644
> --- a/drivers/media/usb/em28xx/em28xx-video.c
> +++ b/drivers/media/usb/em28xx/em28xx-video.c
> @@ -1396,6 +1396,9 @@ static int em28xx_vb2_setup(struct em28xx *dev)
>   	struct vb2_queue *q;
>   	struct em28xx_v4l2 *v4l2 = dev->v4l2;
>   
> +	mutex_init(&v4l2->vb_queue_lock);
> +	mutex_init(&v4l2->vb_vbi_queue_lock);
> +
>   	/* Setup Videobuf2 for Video capture */
>   	q = &v4l2->vb_vidq;
>   	q->type = V4L2_BUF_TYPE_VIDEO_CAPTURE;
> @@ -1405,11 +1408,15 @@ static int em28xx_vb2_setup(struct em28xx *dev)
>   	q->buf_struct_size = sizeof(struct em28xx_buffer);
>   	q->ops = &em28xx_video_qops;
>   	q->mem_ops = &vb2_vmalloc_memops;
> +	q->lock = &v4l2->vb_queue_lock;
>   
>   	rc = vb2_queue_init(q);
>   	if (rc < 0)
>   		return rc;
>   
> +	if (!em28xx_vbi_supported(dev))
> +		return 0;
> +
>   	/* Setup Videobuf2 for VBI capture */
>   	q = &v4l2->vb_vbiq;
>   	q->type = V4L2_BUF_TYPE_VBI_CAPTURE;
> @@ -1419,6 +1426,7 @@ static int em28xx_vb2_setup(struct em28xx *dev)
>   	q->buf_struct_size = sizeof(struct em28xx_buffer);
>   	q->ops = &em28xx_vbi_qops;
>   	q->mem_ops = &vb2_vmalloc_memops;
> +	q->lock = &v4l2->vb_vbi_queue_lock;
>   
>   	rc = vb2_queue_init(q);
>   	if (rc < 0)
> @@ -2429,6 +2437,7 @@ static int em28xx_v4l2_fini(struct em28xx *dev)
>   		vb2_video_unregister_device(&v4l2->vdev);
>   	}
>   
> +	dev->v4l2 = NULL;
>   	mutex_unlock(&dev->lock);
>   
>   	/*
> @@ -2948,12 +2957,14 @@ static int em28xx_v4l2_init(struct em28xx *dev)
>   	if (ret)
>   		goto unregister_dev;
>   
> +	/* initialize videobuf2 stuff */
> +	ret = em28xx_vb2_setup(dev);
> +	if (ret)
> +		goto unregister_dev;
> +
>   	/* allocate and fill video video_device struct */
>   	em28xx_vdev_init(dev, &v4l2->vdev, &em28xx_video_template, "video");
> -	mutex_init(&v4l2->vb_queue_lock);
> -	mutex_init(&v4l2->vb_vbi_queue_lock);
>   	v4l2->vdev.queue = &v4l2->vb_vidq;
> -	v4l2->vdev.queue->lock = &v4l2->vb_queue_lock;
>   	v4l2->vdev.device_caps = V4L2_CAP_READWRITE | V4L2_CAP_VIDEO_CAPTURE |
>   				 V4L2_CAP_STREAMING;
>   	if (dev->int_audio_type != EM28XX_INT_AUDIO_NONE)
> @@ -2998,7 +3009,6 @@ static int em28xx_v4l2_init(struct em28xx *dev)
>   				 "vbi");
>   
>   		v4l2->vbi_dev.queue = &v4l2->vb_vbiq;
> -		v4l2->vbi_dev.queue->lock = &v4l2->vb_vbi_queue_lock;
>   		v4l2->vbi_dev.device_caps = V4L2_CAP_STREAMING |
>   			V4L2_CAP_READWRITE | V4L2_CAP_VBI_CAPTURE;
>   		if ((v4l2->vdev.device_caps & V4L2_CAP_TUNER) == 0)
> @@ -3068,9 +3078,6 @@ static int em28xx_v4l2_init(struct em28xx *dev)
>   	/* Save some power by putting tuner to sleep */
>   	v4l2_device_call_all(&v4l2->v4l2_dev, 0, tuner, standby);
>   
> -	/* initialize videobuf2 stuff */
> -	em28xx_vb2_setup(dev);
> -
>   	dev_info(&dev->intf->dev,
>   		 "V4L2 extension successfully initialized\n");
>   
> @@ -3097,6 +3104,7 @@ static int em28xx_v4l2_init(struct em28xx *dev)
>   		vb2_video_unregister_device(&v4l2->vdev);
>   	}
>   
> +	dev->v4l2 = NULL;
>   	mutex_unlock(&dev->lock);
>   
>   	/*
>
>
> base-commit: 24a19b953e2a3d0ea5a8c4951a0ab8f32720c907
