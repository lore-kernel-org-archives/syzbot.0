Received: from mail-oi1-f175.google.com (mail-oi1-f175.google.com [209.85.167.175])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B510C23909F
	for <syzbot@lists.linux.dev>; Thu, 13 Aug 2026 14:08:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.167.175
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786630107; cv=pass; b=BGCIHWz7G/dHk82yNc1rt6LynpqtXx3JVtSUKZPQhRLS4VAikS/w/Ejvm9gOMi6pJ/a0NH9N3WhHw+FMQ3OCnR3mv/EEM7grsClWB32JXbAiQn6wwD99oh85gEGzIg78G+xJ9JP+4pueT+7eFK5H8unErmCxBbYrJxbtcAM0/uI=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786630107; c=relaxed/simple;
	bh=fc/sUZXRDQGO9hKKkzqpBlQeF57SG66FusgHuXmxYSw=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=Metco9nhd9zysgH2HOBKycDLRq/9Ki3HT7jTSxmDA9EBTFIPzo3wYxuKXM6EzPw26UiLlg7z8YvtiHX1ElhzKqBeJfSU5aL36CUpujDA5RvD/FFHzd6zEzpuEirLLvTt2sodtuZhoFKmph8u1Ts4acjJ+yuVgLv3NGiVWDma7+A=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=t6wmSsBo; arc=pass smtp.client-ip=209.85.167.175
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="t6wmSsBo"
Received: by mail-oi1-f175.google.com with SMTP id 5614622812f47-497e6956acfso757309b6e.1
        for <syzbot@lists.linux.dev>; Thu, 13 Aug 2026 07:08:25 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1786630104; cv=none;
        d=google.com; s=arc-20260327;
        b=pF5rYWewZfJPyuYn+ho1O9DkvoJej9obnw/0KpzYytC9bnaBXtgSvhC19OfFTouTkb
         cpxTZyNWcsmhT3qXUqx0bx9HwzreE93MpC8PIgPdiyTLRtu4RZ3gDeeuFA8rU2F3vmL0
         xFAJkSYaeAVRQDZcSlCgwSqkY7JOyzU9gGV4YM4OtenifiO6Yffm1RlkAUwq2h/hfVpw
         S0fv8+EDr2eOk8xAgQ5Gf0jlfsZV6zJkbZCuimbOZhbmGhs8Ig5GRz2xW3cmbWKWbcss
         HKbPNLhZAcNRggvueTt377P6cNgdN5fqLPc6JZ4uqCMX+q27uvQqIk5tpDe0l7XAO4uA
         blcQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=2jz56VTRKnki0IpRSc17NaUGDGJJ9OKXaI0XJQ8WP8U=;
        fh=v/pZNZnoy4YBzInQ5Gz5t/lAs+mTmiWw3/2+QI50Kt8=;
        b=GRWNN8q09if5BA+vWhcgQWU/0P88q4IjBOYPBufWBSNQfFwsPRVIQ6F3nCDLdfvwK+
         TryHKcqiFcffCJ+tI2SwfGkwyGMtXv9CERdMSHFbfeO2e0/kV2xAwOJyRlfykpdKw7N+
         0nQTiE9cRTAAmsPIwMdH9CJPNGJmVo1LmncnJjTbQC6ZdOYptN6h0okqxef70erURjjB
         1/i3ti/PWXHYg+3xohCuHsMORGJyily93nRCzAYydNMII1GqT3LVRRLcoYxfXZqGu+JI
         cV8be46/+FDhSRTm+EYYpCE0rlRwb3ut+N6f05PlMXrruAGtRcf4vMsBvN9TpkS0zg7s
         Sp+g==;
        darn=lists.linux.dev
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1786630104; x=1787234904; darn=lists.linux.dev;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=2jz56VTRKnki0IpRSc17NaUGDGJJ9OKXaI0XJQ8WP8U=;
        b=t6wmSsBo0rLdfdSS33TXnh9k2DlVeOzidQk3tEjAGDJIc9MSVC3709uVewf+DI1lO5
         u+nOTbVmofPp42WMSC5ZH4csNaujbt0s/TLckBsY8iiDu7BcvPDRa5Y4H3IR9KjPWohY
         cRxtSrDG6Y/8PHQ3/Zzwn0zAexls7wDpLK8ul9v5wPEqY8vB560Le7JVVuUHwCSXEvDJ
         3T+hBkWuEXvFQQt9wNoiQAIRQCJAirfHJ54XbTzX90MZPZpKiBSnCumVx3qEt9xRBUZB
         iya+rL11fbUoU5bh4qM+R9U7oZjoIRMoTG7AGhzMqcQKhIofYBh+b3L/XxUaCyiDXKux
         AdJw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1786630104; x=1787234904;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=2jz56VTRKnki0IpRSc17NaUGDGJJ9OKXaI0XJQ8WP8U=;
        b=opBAgZYFHUcgRMgtfNAduGiIsjOx1W8ricWVWU37CPeVZBwcMA4QsawuJ3q7Byz9gm
         3wppVHoLBK0hl67kRRd1YhdZXK5cUSpk/7yKc0JB4etiWbBtuQOyUix5KIQDriP+irjU
         CQzsoVK0TsOHEIyeTNHw1IqPiZq/NB60kcH4fw/SN0G69cfNsdxB4/hI4xQ4oMQ7om0Y
         l6nv7/WH+UaYncyKMcfLMTXwwLWhQx2dHpfrO8XQKhPN5V86HZNNv2xZxZnLp4E7Fbd2
         3zlsj+ldjQ2sCwIH0HWh5CvRnZj6DsjxTwTG6DHNEY/pgEuDoQXCJ0XmdhvwSeXva/ka
         NOzw==
X-Forwarded-Encrypted: i=1; AHgh+RqCySfI5OHUKQzph4z/dL6lNKOqDgCSAOY0kmujrnxfsi15Wv+0DSZ5BfPi2ZqUyYk4lsLVWH0=@lists.linux.dev
X-Gm-Message-State: AOJu0Yz8NZrRWWJ9jBB1/FsrS+7JKAmRtiLfdW10R8LImLkPs/1puJZG
	0XaybbA/R5xf7y/6RkKqVK9lDwYTzXcOAKMbDTwYbb4oE/jqoR2hvHmGOGnaYRlEdt5BcuBlO6r
	J9VwQiCKkGJoyC0kdy+EwVpyHVzIJK/p+vGe3ESA+Pu3nSudqsdHNPbeKdEY=
X-Gm-Gg: AR+sD134cw+MryUFsrTxjhiaVa8TLEWOum5mq6jEt2zm5n5p4Ko/mZO4Eva/Ivj03rT
	f9qd6YcywUW05I3tAFbBQLjOf8Hfgx2vHWUO50zDoRI05VLXI8z7WfEeuzCLJRlJm8OSpvZL1jw
	DpGzUyggPIeOL+/uTD450Bj1lpr+tYrg+xj8kFvg75y+5BjoBv3ifTZN/NyKYnzJXIHZ5bg/AY/
	C4GvTeX2veZZcJa59uqq+GRx11IYCV9AmolzH2nxllHs1MpmA2WtaSo32NFQyeCnkYTH8MifjKp
	Vbq5wzdRs9NuFFW9BM8cqGIoH1ldDXViw4/N4WaMGUOhl55erIfnyNZUIthsKYXYu42849KZ3SJ
	lXrFu4zgGceZtNe9/Id3NMT0TPPPdQqx/UvwNRuMZ6k2vE3zi1e2bDl9ijEAYFnDx+1GP6Wdngp
	QtGvTzMFiOPGCM
X-Received: by 2002:a05:6808:13d4:b0:4af:9364:b5a9 with SMTP id
 5614622812f47-4b228019344mr4619519b6e.6.1786630103713; Thu, 13 Aug 2026
 07:08:23 -0700 (PDT)
Precedence: bulk
X-Mailing-List: syzbot@lists.linux.dev
List-Id: <syzbot.lists.linux.dev>
List-Subscribe: <mailto:syzbot+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:syzbot+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <7055a5f1-3cf0-4ead-ad20-e63879247c29@mail.kernel.org>
In-Reply-To: <7055a5f1-3cf0-4ead-ad20-e63879247c29@mail.kernel.org>
From: Aleksandr Nogikh <nogikh@google.com>
Date: Thu, 13 Aug 2026 16:08:12 +0200
X-Gm-Features: AUfX_myNAUwYmmScRDfubPVT-PL6OYEuBWdk7l9DY1M2aRCyrSVVZDqsQsuqYEw
Message-ID: <CANp29Y6GVqfrYM72u9ro6W--bPAB6Oa+pYwG0EQ8Pq4w47XTsA@mail.gmail.com>
Subject: Re: [PATCH RFC v3] usb: gadget: uvc: check endpoint enabled state in uvcg_video_enable()
To: syzbot <syzbot@kernel.org>
Cc: syzkaller-upstream-moderation@googlegroups.com, syzbot@lists.linux.dev
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Wed, Aug 12, 2026 at 5:21=E2=80=AFPM syzbot <syzbot@kernel.org> wrote:
>
> A NULL pointer dereference can occur in uvc_video_prep_requests() if
> userspace issues a VIDIOC_STREAMON ioctl before the USB host has fully
> configured the streaming endpoint.
>
> When userspace calls VIDIOC_STREAMON, the driver handles it in
> uvc_v4l2_streamon(), which in turn calls uvcg_video_enable(). Currently,
> uvcg_video_enable() only checks if the endpoint pointer is allocated
> (video->ep =3D=3D NULL), but it fails to check if the endpoint is actuall=
y
> enabled (video->ep->enabled).
>
> The endpoint descriptor (video->ep->desc) is only assigned when the USB
> host explicitly selects the streaming alternate setting via a SET_INTERFA=
CE
> control request. If userspace prematurely calls VIDIOC_STREAMON before th=
e
> host has selected the streaming alternate setting, video->ep->desc will
> still be NULL.
>
> Because uvcg_video_enable() does not verify the endpoint's enabled state,
> it proceeds to call uvc_video_alloc_requests() and then
> uvc_video_prep_requests(). Inside uvc_video_prep_requests(), the code
> unconditionally dereferences video->ep->desc, resulting in a KASAN
> null-ptr-deref / general protection fault:
>
> Oops: general protection fault, probably for non-canonical address
> 0xdffffc0000000000: 0000 [#1] SMP KASAN NOPTI
> KASAN: null-ptr-deref in range [0x0000000000000000-0x0000000000000007]
> RIP: 0010:usb_endpoint_xfer_isoc include/uapi/linux/usb/ch9.h:571 [inline=
]
> RIP: 0010:uvc_video_prep_requests
> drivers/usb/gadget/function/uvc_video.c:508 [inline]
> RIP: 0010:uvc_video_alloc_requests
> drivers/usb/gadget/function/uvc_video.c:559 [inline]
> RIP: 0010:uvcg_video_enable+0x142/0xe70
> drivers/usb/gadget/function/uvc_video.c:784
> Call Trace:
>  <TASK>
>  uvc_v4l2_streamon+0x7e/0x110 drivers/usb/gadget/function/uvc_v4l2.c:531
>  __video_do_ioctl+0x8af/0xc70 drivers/media/v4l2-core/v4l2-ioctl.c:3133
>  video_usercopy+0x860/0x1430 drivers/media/v4l2-core/v4l2-ioctl.c:3475
>  v4l2_ioctl+0x18d/0x1e0 drivers/media/v4l2-core/v4l2-dev.c:366
>  vfs_ioctl fs/ioctl.c:51 [inline]
>  __do_sys_ioctl fs/ioctl.c:597 [inline]
>  __se_sys_ioctl+0xfc/0x170 fs/ioctl.c:583
>
> To fix this, update uvcg_video_enable() to also verify that the endpoint =
is
> enabled (!video->ep->enabled). This ensures that if userspace prematurely
> calls VIDIOC_STREAMON, the driver will safely reject the request with
> -ENODEV instead of crashing the kernel.
>
> Fixes: 48dbe731171e ("usb: gadget: uvc: set req_size and n_requests based=
 on the frame interval")
> Assisted-by: Gemini:gemini-3.6-flash Gemini:gemini-3.1-pro-preview syzbot
> Reported-by: syzbot+44835f0858f11e3e923c@syzkaller.appspotmail.com
> Closes: https://syzkaller.appspot.com/bug?extid=3D44835f0858f11e3e923c
> Link: https://syzkaller.appspot.com/ai_job?id=3D4091c0e6-1fa1-4376-b736-3=
b983cb8ff62
> To: "Greg Kroah-Hartman" <gregkh@linuxfoundation.org>
> To: <linux-usb@vger.kernel.org>
> To: "Michael Grzeschik" <m.grzeschik@pengutronix.de>
> Cc: "Frank Li" <Frank.Li@nxp.com>
> Cc: "Jimmy Hu" <hhhuuu@google.com>
> Cc: "Hans Verkuil" <hverkuil+cisco@kernel.org>
> Cc: "Kees Cook" <kees@kernel.org>
> Cc: "Laurent Pinchart" <laurent.pinchart+renesas@ideasonboard.com>
> Cc: <linux-kernel@vger.kernel.org>
> Cc: "Muhammad Bilal" <meatuni001@gmail.com>
> Cc: "Junzhong Pan" <panjunzhong@linux.spacemit.com>
> Cc: "Xu Yang" <xu.yang_2@nxp.com>
>
> ---
> v3:
> - Removed redundant video->ep->desc checks in uvcg_video_enable() and uvc=
_video_alloc_requests().
> - Dropped uvc->state transition changes in uvc_v4l2_streamon().
>
> v2:
> - Check that uvc->state is UVC_STATE_CONNECTED in uvc_v4l2_streamon() bef=
ore allowing streaming.
> - Update uvc->state to UVC_STATE_STREAMING before calling uvcg_video_enab=
le(), and revert it on failure.
> - Check video->ep->desc in addition to video->ep->enabled in uvcg_video_e=
nable().
> - Add safety checks for video->ep, video->ep->enabled, and video->ep->des=
c in uvc_video_alloc_requests().
> https://lore.kernel.org/all/0062e956-a8d4-4c8e-a25e-4deb5ff85b4b@mail.ker=
nel.org/T/
>
> v1:
> https://lore.kernel.org/all/f345b3ad-4dff-4a90-8a9e-672979e4a8ba@mail.ker=
nel.org/T/
> ---
> diff --git a/drivers/usb/gadget/function/uvc_v4l2.c b/drivers/usb/gadget/=
function/uvc_v4l2.c
> index dfa0521a2..17f0bcd3a 100644
> --- a/drivers/usb/gadget/function/uvc_v4l2.c
> +++ b/drivers/usb/gadget/function/uvc_v4l2.c
> @@ -527,6 +527,9 @@ uvc_v4l2_streamon(struct file *file, void *fh, enum v=
4l2_buf_type type)
>         if (type !=3D video->queue.queue.type)
>                 return -EINVAL;
>
> +       if (uvc->state !=3D UVC_STATE_CONNECTED)
> +               return -ENODEV;
> +

Should we also check for UVC_STATE_STREAMING as well?

>         /* Enable UVC video. */
>         ret =3D uvcg_video_enable(video);
>         if (ret < 0)
> diff --git a/drivers/usb/gadget/function/uvc_video.c b/drivers/usb/gadget=
/function/uvc_video.c
> index 2f9700b3f..d4aeedacc 100644
> --- a/drivers/usb/gadget/function/uvc_video.c
> +++ b/drivers/usb/gadget/function/uvc_video.c
> @@ -764,7 +764,7 @@ int uvcg_video_enable(struct uvc_video *video)
>  {
>         int ret;
>
> -       if (video->ep =3D=3D NULL) {
> +       if (video->ep =3D=3D NULL || !video->ep->enabled) {
>                 uvcg_info(&video->uvc->func,
>                           "Video enable failed, device is uninitialized.\=
n");
>                 return -ENODEV;
>
>
> base-commit: db2ddb87143519e20a95aa36c60b36107b736a58
> --
> This is an AI-generated patch subject to moderation.
> Reply with '#syz upstream' to Sign-off the patch as a human author
> and send it to the upstream kernel mailing lists.
> Reply with '#syz reject' to reject it ('#syz unreject' to undo).
>
> See https://goo.gle/syzbot-ai-patches for information about AI-generated =
patches.
> You can comment on the patch as usual, syzbot will try to address
> the comments and send a new version of the patch if necessary.
> syzbot engineers can be reached at syzkaller@googlegroups.com.
