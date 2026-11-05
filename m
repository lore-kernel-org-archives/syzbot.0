Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.218.49
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793908790;
	b=R4BNVpqslSvIxSLIzG7NiE4S4sX/Mwxkx5V1PO5XLkJSRJ706qofPeT+PqgKI3KdS7mA
	 22TjGeaEanHR+J68K6JeTm7kFG6wzwFSll0G3XRbuaK7pbse7zet+KnVnnrBIrcNYzeW6
	 KieBPseqP9I/e715Bg8XnQhcEEWWi563zQVBlQ3W4e8yErwTngYT3bQh3/KV1K4eemt0L
	 cu/DvAoOBTic9dLDfLd7uedmnMotxb9uIY5pshzAMkOrwZ5mlSUu0lQ6kDtRJ2s/urQKW
	 LabxA9ZhKjxd9bW7/ArZ1pFa8wxDY6tW+0vpYT5OAxXlQ75HZhcuVzaV95gSSkDFHcQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793908790;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Gm-Message-State:X-Gm-Gg:X-Received:Received:Message-ID:Date:
	 MIME-Version:User-Agent:Subject:To:Cc:References:Content-Language:
	 From:In-Reply-To:Content-Type:Content-Transfer-Encoding;
	bh=UTZuLWLTCrNGbyJ70dsexL5nrr29qoNxkrM70aIDajw=;
	b=YOMgZGJp4Bo1eLMLCr/sssXvl+O50KKqJspG2NpbzTjPGD9khJdmBwVuu3Y6rnlC4nTm
	 dox3xRHftYB483PmsX0kPCcH8nIlp56VW99ria8JS8/tIEERDxDJQXMQBfe0EoBjWVcgC
	 989ftRXhynw4JGtQTqJRPlVqiA0BlCqAQDaN4KVi1Gfi0ks87h/7aMFcZ/tfDCuEZ+++2
	 WfZnSD2m6WjLKM733motAspodx/cN9yQVxfITejDPAFntDvxWDmd9Ky08KMMYndXwW8DM
	 S9rFsnG9mZTm6oRsTXZMJI4TcPB+V3LJSUMTV6wJF/XKoRQpw6lksewn6ZPZb13Qtww==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=uicMJiUk;
	arc=none smtp.remote-ip=209.85.218.49
Received: from mail-ej1-f49.google.com (mail-ej1-f49.google.com [209.85.218.49])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6C5C7606A32D
	for <syzbot@lists.linux.dev>; Thu,  5 Nov 2026 19:59:50 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 6C5C7606A32D
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=uicMJiUk
Received: by mail-ej1-f49.google.com with SMTP id a640c23a62f3a-c4203bbb1e9so8799166b.3
        for <syzbot@lists.linux.dev>; Thu, 05 Nov 2026 11:59:50 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1793908789; x=1794513589; darn=lists.linux.dev;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=UTZuLWLTCrNGbyJ70dsexL5nrr29qoNxkrM70aIDajw=;
        b=uicMJiUkWXqmTO1F4KTjzDBVfVcs/AAIZjQPqWQlPB6H7YK+1HX9pCaxF8WHTTXAx1
         WAPp1m4Fsf2B/wwbdjuTuhhaRouv2CceUo6QMUUPv1wJWQ+sUnVgzxrJLWcj6RvHSWdE
         xsvex/e9zZ8/PsPw4YINietd2xaXK5czdEbJB+KKhJSXSh+gHDQy0NlRqaJl+oxVfZG5
         Z3H2BXcy7O1btPWyUDHydDJ3NBoUO/ppmYCTn/zaknVX6gG4Q+sFMHjW/ZmcPooSeZF1
         vagjmp8cKjaDRuQUfFpWxdOkWZnsRsG3ZUmSMNP55PTLk1PD0iv3JVVRvBJSiu8HCpb0
         yl/Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793908789; x=1794513589;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=UTZuLWLTCrNGbyJ70dsexL5nrr29qoNxkrM70aIDajw=;
        b=UScRNsD6OC6ELLsonlCkoxeVCxRafusxeUD0Uoj5nlKK0wqXKlLT4iC8CgVfTJs8GA
         4POxtns2LMC7OGpOKhzD2pjaHUa+zqRwalJlrjY22dj1HWBGxQPcJmHyyhXIwfxn3mNF
         gKz8rWRl1BzWga0K4BqaXRZTEeBYfnobp9MPeh2eEdF60Xg/JRDylKLxNnqSwr/uWq6Y
         fRtFjbk/Cv0O8drVGvILelCPhsSWnes0UhEKJkEsmywhUs7DlEcCg/uGAxQE+2WXZvCn
         7rNDfwBEmMhTZUId9y/GcS8gqzkXIc8NewJilMCKahm0UK4cuVuestae6JCyodSrYfIB
         9KLg==
X-Gm-Message-State: APuU4Z9mDfJcFGX0+LZQej1qkYZVecngBAuhZ7B6SjbnhvMjUVjGDgAO
	KtNyMcb7/uGgJ8XG0ls/p4gQ3TsfXH7vSU76k7HnVJMyi3pYxPnvM2Xv
X-Gm-Gg: AYBFou3G3+AS0y2759/kgGxrD/Kj4TNQvwfhQdl+SrlrnvYbEXTvLb4Kk6FMflWzIBW
	zp5sjnLiq70t1RcEh+S+NFPyatJ0pveCcRf7RUqXnY4rLPSpZn9Zgn+YCimWIFEJtubQxTPn6h7
	OCkZEheUikwxu0sBB0IjFsgmd3/0UIZcCNa546gS0BsYn5v9gAvFeP9YCcD6rViqKB9/ur0PNoD
	efV2RvG9Z7g+qpT+IplL608n8NiuNXriT4I4hKVdE4O/15t1/+FurkBgyngFpQa9/ZvyZirYUIm
	rBq2A6ae1KlK5wxHZhLYTMsgRvq8bBxXl0WoOMcM4kJKc5LvVjgkGcdC7fDpbxLHvzWnl2A/mIJ
	h+y0Ecvmi76xzGAxyhot7VMbKjEeLGpr26NoCsLmtkzNFTDP7KGdVHi0JFQVFcfpP54gVHs1xRo
	eurLGysZl9DrZllSPmVYYrUamhNRmkcDlo9ADNsMkp95ShI3q+aAQDdJSkcMOt+Tr8/c/I3HJzk
	IS//NGRIAWqoFZvO9kg4H4VWSZvL5kpTQlDcVU/Ko+zI646mdLp+7+i3lzqcna7xl7IYuzOMpYP
	/2HN4KbfZEb2BDDQuL/zsZ6WOnco2hElCj96S2ATHSndHgB7tpKAYu+g79myXwFXGAwR6usr/A/
	mRA==
X-Received: by 2002:a17:907:868d:b0:c3e:ee86:d2c with SMTP id a640c23a62f3a-c4d354c44edmr44560566b.27.1793908788688;
        Thu, 05 Nov 2026 11:59:48 -0800 (PST)
Received: from [192.168.0.50] (93-159-22-87.cgnat.inetia.pl. [93.159.22.87])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-c4d356c776csm13153666b.70.2026.11.05.11.59.46
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 05 Nov 2026 11:59:47 -0800 (PST)
Message-ID: <d81bffc7-f9c2-4990-ad00-f32f7a615e90@gmail.com>
Date: Thu, 5 Nov 2026 20:59:46 +0100
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
Subject: Re: [PATCH RFC v2] media: em28xx: clear dev->v4l2 when v4l2 init
 fails
To: syzbot <syzbot@kernel.org>, syzkaller-upstream-moderation@googlegroups.com
Cc: syzbot@lists.linux.dev
References: <46d5ee1f-d8ae-4555-9edd-6afa90861d4e@mail.kernel.org>
Content-Language: en-US
From: Uladzislau Zhauniarovich <uladzislau.zhauniarovich@gmail.com>
In-Reply-To: <46d5ee1f-d8ae-4555-9edd-6afa90861d4e@mail.kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

Thanks, the dev->v4l2 hunk, its comment, the subject, Fixes: and
Cc: stable are right. Two things still block this, plus two smaller
ones. Please send a v3.

1) The KASAN report in the changelog is not a real report. It says
   "6.14.0-rc1", "v4l_id/1234", "QEMU Standard PC (Q35 ...)", and puts
   v4l2_device_put() in drivers/media/v4l2-core/v4l2-dev.c:1052. That
   function lives in v4l2-device.c, and the em28xx_free_v4l2() frame
   is missing. Do not synthesize or edit crash traces. Quote this real
   report from this bug, on linux-next 20a33c6b6cbe (2026/10/26),
   verbatim:

  BUG: KASAN: slab-use-after-free in v4l2_open+0x397/0x3a0 drivers/media/v4l2-core/v4l2-dev.c:444
  Read of size 4 at addr ffff888026878858 by task v4l_id/6347
  Call Trace:
   v4l2_open+0x397/0x3a0 drivers/media/v4l2-core/v4l2-dev.c:444
   chrdev_open+0x4d9/0x600 fs/char_dev.c:413
   do_dentry_open+0x80e/0x1360 fs/open.c:1000
   vfs_open_consume+0x4a/0x350 fs/open.c:1131
  Allocated by task 31:
   em28xx_v4l2_init+0xff/0x31f0 drivers/media/usb/em28xx/em28xx-video.c:2751
   em28xx_init_extension+0x120/0x1d0 drivers/media/usb/em28xx/em28xx-core.c:1245
  Freed by task 973:
   kfree+0x1c5/0x650 mm/slub.c:6923
   em28xx_free_v4l2+0x77/0xf0 drivers/media/usb/em28xx/em28xx-video.c:2337
   v4l2_device_put+0x81/0xd0 drivers/media/v4l2-core/v4l2-device.c:56
   em28xx_v4l2_fini+0x1f3/0x3e0 drivers/media/usb/em28xx/em28xx-video.c:2465
   em28xx_close_extension+0xde/0x390 drivers/media/usb/em28xx/em28xx-core.c:1262
   em28xx_usb_disconnect+0x16b/0x2f0 drivers/media/usb/em28xx/em28xx-cards.c:4489

2) Drop all em28xx_vb2_setup() hunks, and drop the "In addition, move
   em28xx_vb2_setup() ..." paragraph from the changelog. This was
   point 1) of my v1 review. Your job is based on 24a19b953e2a
   (v7.3-rc7), which predates the two mainline commits that already do
   this:

     487344a63f6a ("media: em28xx: setup queues before registering V4L2 device")
     65ed6e9e3fe2 ("media: usb: em28xx: check if vbi is supported before calling vb2_queue_init")

   Both are in v7.4-rc1, and this patch has to apply on top of them.
   Against v7.4-rc1, v2 fails in 2 of 7 hunks. Worse, three other
   hunks still apply on top of the already-moved code and would call
   mutex_init() and em28xx_vb2_setup() twice. If you can, rebase onto
   v7.4-rc1 (6628e7d4c6b2). If your base cannot move: on 24a19b953e2a
   without those two commits, the reproducer still hits the videobuf2
   GPF from 7c8bf63b7937 in the error path. That is expected, and it
   is not a reason to keep the hunks: that GPF is fixed by
   487344a63f6a, not by this patch.

3) Wording: "subsequent calls to v4l2_open() ... succeed" is not quite
   it. New opens after the nodes are unregistered already fail in
   v4l2_open(). The problem is the open that is already in progress:
   v4l_id is inside em28xx_v4l2_open(), blocked on dev->lock while
   em28xx_v4l2_init() holds it. When init fails and drops the lock,
   that open finds dev->v4l2 still set and succeeds on the
   unregistered node.

4) Put the tags in one trailer block, without the blank line between
   "Cc: stable@vger.kernel.org" and "Fixes:". Order: Fixes:, Cc:
   stable, then the rest.

The v3 diff should be the single em28xx_v4l2_init() hunk from v2 (the
comment plus "dev->v4l2 = NULL;"), and nothing else.

On 02/11/2026 17:53, syzbot wrote:
> In em28xx_v4l2_init(), if an error occurs after video_register_device()
> succeeds, the cleanup path at unregister_dev unregisters the devices and
> puts the v4l2_dev reference, but leaves dev->v4l2 set. Because dev->v4l2
> remains non-NULL, subsequent calls to v4l2_open() (such as from v4l_id when
> opening the device node) succeed instead of returning -ENODEV. When the
> device is later disconnected, em28xx_close_extension() invokes
> em28xx_v4l2_fini(), which sees dev->v4l2 is still set and calls
> v4l2_device_put() a second time. This prematurely drops the reference count
> to zero while v4l_id still holds the device, leading to a
> slab-use-after-free:
> 
> BUG: KASAN: slab-use-after-free in v4l2_release+0xcd/0xe0
> Read of size 8 at addr ffff888114efc000 by task v4l_id/1234
> CPU: 1 UID: 0 PID: 1234 Comm: v4l_id Not tainted 6.14.0-rc1 #1
> Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS
> 1.16.3-debian-1.16.3-2 04/01/2014
> Call Trace:
>  <TASK>
>  dump_stack_lvl+0x68/0x90
>  print_report+0xd3/0x620
>  kasan_report+0xb9/0xf0
>  v4l2_release+0xcd/0xe0
>  __fput+0x3f6/0xb30
>  task_work_run+0x14d/0x240
>  do_exit+0xa38/0x2c00
>  do_group_exit+0xd4/0x2a0
>  __x64_sys_exit_group+0x3e/0x50
>  do_syscall_64+0xcb/0x250
>  entry_SYSCALL_64_after_hwframe+0x77/0x7f
>  </TASK>
> 
> Allocated by task 6297:
>  kasan_save_stack+0x33/0x60
>  kasan_save_track+0x14/0x30
>  __kasan_kmalloc+0xaa/0xb0
>  em28xx_v4l2_init+0x9e/0x2df0 drivers/media/usb/em28xx/em28xx-video.c:2860
>  em28xx_init_extension+0x120/0x1d0
>  drivers/media/usb/em28xx/em28xx-core.c:1248
>  process_scheduled_works+0xc3d/0x1630 kernel/workqueue.c:3479
>  worker_thread+0x92d/0xe10 kernel/workqueue.c:3560
>  kthread+0x38b/0x480 kernel/kthread.c:436
>  ret_from_fork+0x514/0xb70 arch/x86/kernel/process.c:158
>  ret_from_fork_asm+0x1a/0x30 arch/x86/entry/entry_64.S:245
> 
> Freed by task 6297:
>  kasan_save_stack+0x33/0x60
>  kasan_save_track+0x14/0x30
>  kasan_save_free_info+0x2b/0x50
>  __kasan_slab_free+0x106/0x1a0
>  kfree+0xd4/0x340
>  v4l2_device_put+0xbc/0xf0 drivers/media/v4l2-core/v4l2-dev.c:1052
>  em28xx_v4l2_fini+0x120/0x180 drivers/media/usb/em28xx/em28xx-video.c:2445
>  em28xx_close_extension+0x120/0x1d0
>  drivers/media/usb/em28xx/em28xx-core.c:1270
>  em28xx_usb_disconnect+0x10a/0x230
>  drivers/media/usb/em28xx/em28xx-cards.c:4254
>  usb_unbind_interface+0x1eb/0x8e0 drivers/usb/core/driver.c:461
>  device_release_driver_internal+0x43b/0x610 drivers/base/dd.c:1297
>  bus_remove_device+0x2cc/0x3e0 drivers/base/bus.c:575
>  device_del+0x49f/0x910 drivers/base/core.c:3851
>  usb_disable_device+0x35b/0x7b0 drivers/usb/core/message.c:1418
>  usb_disconnect+0x2c6/0x8d0 drivers/usb/core/hub.c:2303
> 
> Fix this by clearing dev->v4l2 under dev->lock in the unregister_dev error
> path of em28xx_v4l2_init(). This ensures em28xx_v4l2_open() fails with
> -ENODEV and prevents em28xx_v4l2_fini() from tearing down the instance a
> second time upon disconnect.
> 
> In addition, move em28xx_vb2_setup() before video_register_device() and
> check its return value so that videobuf2 queues are initialized prior to
> device registration and can be safely cleaned up if an error occurs. In
> em28xx_vb2_setup(), initialize vb_queue_lock and vb_vbi_queue_lock and
> assign q->lock before calling vb2_queue_init(), and make VBI queue
> initialization conditional on em28xx_vbi_supported().
> 
> Cc: stable@vger.kernel.org
> 
> Fixes: 288254383674 ("media: em28xx: use v4l2_device release callback")
> Assisted-by: Gemini:gemini-4-argon Gemini:gemini-3.8-flash syzbot
> Reported-by: syzbot+1a7507a194fff09e5c44@syzkaller.appspotmail.com
> Closes: https://syzkaller.appspot.com/bug?extid=1a7507a194fff09e5c44
> Link: https://syzkaller.appspot.com/ai_job?id=4d612d4a-3dfa-43bd-9919-40019986527f
> To: <linux-media@vger.kernel.org>
> To: "Mauro Carvalho Chehab" <mchehab@kernel.org>
> To: "Hans Verkuil" <hverkuil+cisco@kernel.org>
> Cc: <linux-kernel@vger.kernel.org>
> 
> ---
> v2:
> - Update patch subject to reflect clearing dev->v4l2 on init failure
> - Rewrite commit description to explain the slab-use-after-free and replace the lockdep/GPF report with the KASAN report
> - Drop setting dev->v4l2 to NULL in em28xx_v4l2_fini()
> - Add comment explaining why dev->v4l2 is cleared in em28xx_v4l2_init()
> - Add Cc: stable@vger.kernel.org tag
> 
> v1:
> https://lore.kernel.org/all/2fdb5af1-fad9-47fe-93dc-d1400f44b60b@mail.kernel.org/T/
> ---
> diff --git a/drivers/media/usb/em28xx/em28xx-video.c b/drivers/media/usb/em28xx/em28xx-video.c
> index 79af15476..a48815840 100644
> --- a/drivers/media/usb/em28xx/em28xx-video.c
> +++ b/drivers/media/usb/em28xx/em28xx-video.c
> @@ -1396,6 +1396,9 @@ static int em28xx_vb2_setup(struct em28xx *dev)
>  	struct vb2_queue *q;
>  	struct em28xx_v4l2 *v4l2 = dev->v4l2;
>  
> +	mutex_init(&v4l2->vb_queue_lock);
> +	mutex_init(&v4l2->vb_vbi_queue_lock);
> +
>  	/* Setup Videobuf2 for Video capture */
>  	q = &v4l2->vb_vidq;
>  	q->type = V4L2_BUF_TYPE_VIDEO_CAPTURE;
> @@ -1405,11 +1408,15 @@ static int em28xx_vb2_setup(struct em28xx *dev)
>  	q->buf_struct_size = sizeof(struct em28xx_buffer);
>  	q->ops = &em28xx_video_qops;
>  	q->mem_ops = &vb2_vmalloc_memops;
> +	q->lock = &v4l2->vb_queue_lock;
>  
>  	rc = vb2_queue_init(q);
>  	if (rc < 0)
>  		return rc;
>  
> +	if (!em28xx_vbi_supported(dev))
> +		return 0;
> +
>  	/* Setup Videobuf2 for VBI capture */
>  	q = &v4l2->vb_vbiq;
>  	q->type = V4L2_BUF_TYPE_VBI_CAPTURE;
> @@ -1419,6 +1426,7 @@ static int em28xx_vb2_setup(struct em28xx *dev)
>  	q->buf_struct_size = sizeof(struct em28xx_buffer);
>  	q->ops = &em28xx_vbi_qops;
>  	q->mem_ops = &vb2_vmalloc_memops;
> +	q->lock = &v4l2->vb_vbi_queue_lock;
>  
>  	rc = vb2_queue_init(q);
>  	if (rc < 0)
> @@ -2948,12 +2956,14 @@ static int em28xx_v4l2_init(struct em28xx *dev)
>  	if (ret)
>  		goto unregister_dev;
>  
> +	/* initialize videobuf2 stuff */
> +	ret = em28xx_vb2_setup(dev);
> +	if (ret)
> +		goto unregister_dev;
> +
>  	/* allocate and fill video video_device struct */
>  	em28xx_vdev_init(dev, &v4l2->vdev, &em28xx_video_template, "video");
> -	mutex_init(&v4l2->vb_queue_lock);
> -	mutex_init(&v4l2->vb_vbi_queue_lock);
>  	v4l2->vdev.queue = &v4l2->vb_vidq;
> -	v4l2->vdev.queue->lock = &v4l2->vb_queue_lock;
>  	v4l2->vdev.device_caps = V4L2_CAP_READWRITE | V4L2_CAP_VIDEO_CAPTURE |
>  				 V4L2_CAP_STREAMING;
>  	if (dev->int_audio_type != EM28XX_INT_AUDIO_NONE)
> @@ -2998,7 +3008,6 @@ static int em28xx_v4l2_init(struct em28xx *dev)
>  				 "vbi");
>  
>  		v4l2->vbi_dev.queue = &v4l2->vb_vbiq;
> -		v4l2->vbi_dev.queue->lock = &v4l2->vb_vbi_queue_lock;
>  		v4l2->vbi_dev.device_caps = V4L2_CAP_STREAMING |
>  			V4L2_CAP_READWRITE | V4L2_CAP_VBI_CAPTURE;
>  		if ((v4l2->vdev.device_caps & V4L2_CAP_TUNER) == 0)
> @@ -3068,9 +3077,6 @@ static int em28xx_v4l2_init(struct em28xx *dev)
>  	/* Save some power by putting tuner to sleep */
>  	v4l2_device_call_all(&v4l2->v4l2_dev, 0, tuner, standby);
>  
> -	/* initialize videobuf2 stuff */
> -	em28xx_vb2_setup(dev);
> -
>  	dev_info(&dev->intf->dev,
>  		 "V4L2 extension successfully initialized\n");
>  
> @@ -3097,6 +3103,12 @@ static int em28xx_v4l2_init(struct em28xx *dev)
>  		vb2_video_unregister_device(&v4l2->vdev);
>  	}
>  
> +	/*
> +	 * Clear dev->v4l2 to prevent em28xx_v4l2_open() from opening an
> +	 * unregistered node (failing with -ENODEV instead) and to prevent
> +	 * em28xx_v4l2_fini() from tearing down the instance a second time.
> +	 */
> +	dev->v4l2 = NULL;
>  	mutex_unlock(&dev->lock);
>  
>  	/*
> 
> 
> base-commit: 24a19b953e2a3d0ea5a8c4951a0ab8f32720c907

