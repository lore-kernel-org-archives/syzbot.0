Received: from mail-ot1-f52.google.com (mail-ot1-f52.google.com [209.85.210.52])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1120634B1B0
	for <syzbot@lists.linux.dev>; Wed, 12 Aug 2026 13:48:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.210.52
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786542488; cv=pass; b=cl+dLr+xlU+ht7LXhShnKaf8g0xnYW14PY3N8odwjzzu80YCsvq1nIGFceIBxcXMWZu6AQUNPuhD6CdkC2mRjKL+OXUFoQt7Y1nM8I6sq3S1GY5GJL1vBCpIg0EDqc6yID80iNq5lGOGxnMVKLQaalld6aa/pvQNo3cklCZkN+8=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786542488; c=relaxed/simple;
	bh=o9qHjDqZf/8y/FCyp0mNIDI80qCojCO5u3N81p5UGcg=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=CFauM/aNF51+JNXCpP4NQsiBNSrFO+txRN65Vodf57yv3dI7A6iC1eNKhWL3GjaU1vKdTS8CZbXhudyieg4xIvn+XjsaEdPPjiJ1L8oe4UEMD8uICvebE2Lz7jM55HP3DUZAzG7kD6r2ok93W9kpthoseBS75hew+6zSRKVbZYI=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=f89YTT/E; arc=pass smtp.client-ip=209.85.210.52
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="f89YTT/E"
Received: by mail-ot1-f52.google.com with SMTP id 46e09a7af769-7ee4399c3abso676858a34.2
        for <syzbot@lists.linux.dev>; Wed, 12 Aug 2026 06:48:06 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1786542486; cv=none;
        d=google.com; s=arc-20260327;
        b=EbmuBrYkgInFL91WX9MaDk11LOAHphjKUtuVyesZlwpQqGI3786d/gKxMgkoyuxFqj
         CTO7qPYjyfI1SMlVD6uhgXyjlq98XAa9dMbRlYYSiirKnoVgyVGLKDd4q/dtqw5p6teW
         YXmURk3jQG2faRUeHV5Vuz6XbFH39nMUR3FB43IM3qJT1t4xoVj2rbI3DPZSSYKDnBof
         t1TbdnQO/yYNNTc1cCBPB7mJB9biJBxixzsMZ7NJvym4N4TrxPmu5BmpzNK91TczYY8j
         Zj0nPW56QM7YQ+pDRAHpfdUDddPIcZT62bL6sFrdLwFbme/Uj+Tv0DSmQSt4jtiDzqxq
         QIOA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=2ArFBVVsCBwUrDlLeYPyLnMCmx3jVuSjRZusfq3YCy4=;
        fh=7mrekmcAEUaB/SMX3qaDY30zWQfKg8uloifrH5BXk1k=;
        b=EcFQtFZRQmfjBzoK3E3nCQF1pczjOWqhtktvQS9yjegDRn0wLPGqvLEM+3BBhJxEQD
         iVRXM/G/wZQNQ8w74GN7K5+ov3LeBr1++qrJZB/B9y+ssB1jAzO5DiGtxjGWlDl2ahle
         zHRC/y3DaLls1jgy73LBMVDy9MAUPnrHQA+YHEXyubBn9uLRDfLnsvPDfkfh5S8vVkOh
         FnI1gc08zUixs3SnWWkvrg2vxTtJOm6agPoZrjTJfMwUDTaJIeOabPDWejQ1e7Wc565F
         AqRTEEy5pty3LLS36PGCP3srQuvetWd2I2afIvyPC3siErZ1TFVGkIEgGKGN41tsx0Tp
         ozcA==;
        darn=lists.linux.dev
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1786542486; x=1787147286; darn=lists.linux.dev;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=2ArFBVVsCBwUrDlLeYPyLnMCmx3jVuSjRZusfq3YCy4=;
        b=f89YTT/EBnnYxGNwBFSdbYKHy6lhLVpuFH1JxENQcQ4gzkTdiLYB3TAKa5sx77Ns45
         QlBfIinfBU4O49CDRVqHocLhTsl+HN+icLSoFYwk34f3W8me9SEzkteDB0LZo9GJ43H3
         Lbtvibq+xy0Hx8dZ+6xpK4LHQamV66wrW9mYGvvAMbQHfWxcdRtbo39fUJ5az+3G47NJ
         1H2DMmL4xZDGHS87HTbpFBWdhlP4QSZP2gi2vkddOCyDC0uA7tLhHxK1H9dKdl6Ph8FE
         I7ejcj2ftRmGIk5vFnCo4ShAm7Qm0xyZGXJtU9IDXMjt5rP/noaNDGENYO6dKu8jJXVM
         kovw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1786542486; x=1787147286;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=2ArFBVVsCBwUrDlLeYPyLnMCmx3jVuSjRZusfq3YCy4=;
        b=C3p9f34tf3ZuTd6rfgqUDrU6ns8N4n2tFgiyuf3Hvew3tCQBU1oKar+f33ghk6UxEL
         E2aReM+m0O02Bqo67iwfRoQJZ0UAnf6IkuHnivTT6TvEzEE70n3lOrYHvltHHWnIu0hx
         GKO9oClzubQxivgz5KEhROuCvzbCQz6i2DxaPYxILskf1R8VnD26b+iLvJnALW1w9F74
         /vUNhYJfX6s85XXB5DjYiIfGaRtfa9lTorQmhX3O9nrVGRaXJsjVkXfDFaXp8uDe65xr
         j2F1ZJDNPglm8uBtAaOAqYV/n/ljTFZJAB6yH0LBoMEYc6Uc01aKYLyMloQl3lG6Eme8
         zQ8Q==
X-Forwarded-Encrypted: i=1; AHgh+RqaLOQzdWlPQ/768I8AfQPXcQQLdG6LrVfLZVCekhuzG7x1QHtVBLq42PAAZ63FJhf8GDZ0Eug=@lists.linux.dev
X-Gm-Message-State: AOJu0YyH9o8zKPP2mMStxurFzwxYamuI3Sb/RwhiEWeIbQSqr6D/5Acj
	EoVDQadXwUEAVcK/m3DaKHhKoEIXTagoq+wTV6mriM7u5/N1pIPicfuuc56wgPMEtU7ru9vSIo0
	6tDUQCs6UiwT6EHFXl5z6/UqZ3IgczLPHsDQ+tPC1
X-Gm-Gg: AR+sD12HNIlG+zg0FDZNN225HmN6pghkYcb+z8MZ8aSmbbK8yK1M5vNANWefptXV1TY
	rskW0OLG1DlLXEEkTGHtzdkV8QeE5bXax2EE7bXlY3HeS5aejJBpbxNqv0RC1DdicsUrGa68jMd
	kUxvUuHETVAVC2PKDa9fwPXVNPdSy+Ab5GrU/6BsXa9RNTij5D3oUABboB5EKDWoRbLMphqiyQt
	J6uI1AqdY70RStx1+iW9iQ4akkrTCLWxDs857wp6mo6lwwpyb4CbiRV37tWFHuPmzgwQdT/eX38
	jVSbPEZD4ZHAbj4jhAs8QBuPQujxKZMfZZ3fDHIBgwZo4vEHDPHdpTG73dV8ysVPGzCpYFsaEw7
	dlmUSpgg1sUpsT8GZ0+e/GGe2niuuhE1dc7RDs4mJwYpjWcoAwBTVUQWXQPW9L/lg310CWt5kCB
	mYB4gdC0zKTZDk
X-Received: by 2002:a05:6830:6b04:b0:7eb:d848:c867 with SMTP id
 46e09a7af769-7f3b772f749mr5241541a34.6.1786542485163; Wed, 12 Aug 2026
 06:48:05 -0700 (PDT)
Precedence: bulk
X-Mailing-List: syzbot@lists.linux.dev
List-Id: <syzbot.lists.linux.dev>
List-Subscribe: <mailto:syzbot+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:syzbot+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <0062e956-a8d4-4c8e-a25e-4deb5ff85b4b@mail.kernel.org>
In-Reply-To: <0062e956-a8d4-4c8e-a25e-4deb5ff85b4b@mail.kernel.org>
From: Aleksandr Nogikh <nogikh@google.com>
Date: Wed, 12 Aug 2026 15:47:54 +0200
X-Gm-Features: AUfX_mwQH41X9gvXx-6iclYRgkXAalOR39qZO8VwvcyoGXRM4hOp7Rmlzi53SsU
Message-ID: <CANp29Y5fCex2aQqPZyr7UKvPR-F+S1pccsK-yYa4epPqTkDQyw@mail.gmail.com>
Subject: Re: [PATCH RFC v2] usb: gadget: uvc: check endpoint enabled state in uvcg_video_enable()
To: syzbot <syzbot@kernel.org>
Cc: syzkaller-upstream-moderation@googlegroups.com, syzbot@lists.linux.dev
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Wed, Aug 12, 2026 at 3:28=E2=80=AFPM syzbot <syzbot@kernel.org> wrote:
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
> Assisted-by: Gemini:gemini-3.5-flash Gemini:gemini-3.1-pro-preview syzbot
> Reported-by: syzbot+44835f0858f11e3e923c@syzkaller.appspotmail.com
> Closes: https://syzkaller.appspot.com/bug?extid=3D44835f0858f11e3e923c
> Link: https://syzkaller.appspot.com/ai_job?id=3De3902952-fe28-4ca4-a910-c=
485a9927925
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
> v2:
> - Check that uvc->state is UVC_STATE_CONNECTED in uvc_v4l2_streamon() bef=
ore allowing streaming.
> - Update uvc->state to UVC_STATE_STREAMING before calling uvcg_video_enab=
le(), and revert it on failure.
> - Check video->ep->desc in addition to video->ep->enabled in uvcg_video_e=
nable().
> - Add safety checks for video->ep, video->ep->enabled, and video->ep->des=
c in uvc_video_alloc_requests().
>
> v1:
> https://lore.kernel.org/all/f345b3ad-4dff-4a90-8a9e-672979e4a8ba@mail.ker=
nel.org/T/
> ---
> diff --git a/drivers/usb/gadget/function/uvc_v4l2.c b/drivers/usb/gadget/=
function/uvc_v4l2.c
> index dfa0521a2..a80663c9a 100644
> --- a/drivers/usb/gadget/function/uvc_v4l2.c
> +++ b/drivers/usb/gadget/function/uvc_v4l2.c
> @@ -527,17 +527,24 @@ uvc_v4l2_streamon(struct file *file, void *fh, enum=
 v4l2_buf_type type)
>         if (type !=3D video->queue.queue.type)
>                 return -EINVAL;
>
> +       if (uvc->state !=3D UVC_STATE_CONNECTED)
> +               return -ENODEV;
> +
> +       uvc->state =3D UVC_STATE_STREAMING;
> +
>         /* Enable UVC video. */
>         ret =3D uvcg_video_enable(video);
> -       if (ret < 0)
> +       if (ret < 0) {
> +               if (uvc->state =3D=3D UVC_STATE_STREAMING)
> +                       uvc->state =3D UVC_STATE_CONNECTED;
>                 return ret;
> +       }
>
>         /*
>          * Complete the alternate setting selection setup phase now that
>          * userspace is ready to provide video frames.
>          */
>         uvc_function_setup_continue(uvc, 0);
> -       uvc->state =3D UVC_STATE_STREAMING;

Instead of all that changes, would just this suffice (at the right place)?

        if (uvc->state !=3D UVC_STATE_CONNECTED)
            return -ENODEV;

>
>         return 0;
>  }
> diff --git a/drivers/usb/gadget/function/uvc_video.c b/drivers/usb/gadget=
/function/uvc_video.c
> index 2f9700b3f..bd67a9d80 100644
> --- a/drivers/usb/gadget/function/uvc_video.c
> +++ b/drivers/usb/gadget/function/uvc_video.c
> @@ -551,6 +551,9 @@ uvc_video_alloc_requests(struct uvc_video *video)
>         unsigned int i;
>         int ret =3D -ENOMEM;
>
> +       if (video->ep =3D=3D NULL || !video->ep->enabled || !video->ep->d=
esc)
> +               return -ENODEV;
> +
>         /*
>          * calculate in uvc_video_prep_requests
>          * - video->uvc_num_requests
> @@ -764,7 +767,7 @@ int uvcg_video_enable(struct uvc_video *video)
>  {
>         int ret;
>
> -       if (video->ep =3D=3D NULL) {
> +       if (video->ep =3D=3D NULL || !video->ep->enabled || !video->ep->d=
esc) {
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
