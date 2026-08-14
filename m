Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CE99F3C1F54
	for <syzbot@lists.linux.dev>; Fri, 14 Aug 2026 11:58:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=100.103.45.18
ARC-Seal:i=3; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786708740; cv=pass; b=X/Q4L6OBj5Cwgl2jAyQyBRdj+azVrw6W4zQeyxj9+Jb75zT3Wes8KtYnPvCuioEEfj9adfU42PcUv8SZulqUoRcQMYlS1xd3KAE3aBSrkskmeRCTXRFZTkyf0ha2YyvOTaUfsmBC0MrMDxMn2cZ4HJNmjoguCYE8vBxfjl7dDio=
ARC-Message-Signature:i=3; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786708740; c=relaxed/simple;
	bh=6qyXsxNJWXfECca0I4J0D9JF2E2U0Q5m4L+M8a55F3s=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=WLe6c9cB6Sg70DUrHyyOl1VNnA7FV/Rr2B8VkX3xXG/N8yaxYSHOlQ3ON2FsnQiknZvdSrXQtUZlg+zr/ju7AyblnNoaFGJeZKvndwQYLIcovSsfNHgkdYOktBFIUgr1eMnswchYfgnT2RHza9/+e8IujrFrv0j/K3Xn8M3721o=
ARC-Authentication-Results:i=3; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=eL9Bz9Ue; arc=pass smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="eL9Bz9Ue"
Received: by smtp.kernel.org (Postfix)
	id 8454B1F00A3A; Fri, 14 Aug 2026 11:58:58 +0000 (UTC)
Authentication-Results: smtp.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=209.85.210.43
ARC-Seal: i=2; d=kernel.org; s=arc20260519; a=rsa-sha256; cv=pass;
	t=1786708738;
	b=3ELy5qL/xQbBqPW8BZOAyp1vb5PDfIq40YtmdEocbNvhEtmPsuQgvwMKoSof0qqLM6Yu
	 iSRA3LizcJdmYl9CWCFPflurhhiEFBOnjj6o5NAE001FXkuhyEgm4OFkk5xh2aHZPqpNF
	 nvMZB/IjR7jOpK1+NsjAwFPHpXr/w9bqj2m7Bi79ncJXvLHqIn9tGT/mpC6JV6AgUCVS+
	 MysJK/DgU2XMKIP/4U7FYYjg5F+xFC300k1keqanE6XHskcgwnQ5vBVmsu26Yn8xoau8+
	 FxiRadEK2TuUZ2y1T8hc4Zn4G/tB45iSYHrG6SICJLRqDx7E0Jl/eBnU6HJFigiSuhw==
ARC-Message-Signature: i=2; d=kernel.org; s=arc20260519; a=rsa-sha256;
	c=relaxed/relaxed; t=1786708738;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Gm-Message-State:X-Gm-Gg:X-Received:MIME-Version:References:
	 In-Reply-To:From:Date:X-Gm-Features:Message-ID:Subject:To:Cc:
	 Content-Type:Content-Transfer-Encoding;
	bh=FTeB1gh2hA89RUQonVIIJYAuhk0qtjDlQT2f28m6Xzg=;
	b=KP9J5CAZNAZcu5EAhCioZ0P1W2fhqzqfJ+tCyk5PbogBaHbVPJ0zSy/lzopr07Hc55G1
	 rmQEsC0dmZSOyMRVxYG8z2AmmG9ucQ5RO9d2luszi00PHFySJZ3QyOp/4eYshrSt5192l
	 JrzOVvEf7nSXelXr6u7CTlywKIDS2TT1zxZuTxwHftColRMddiWW6dYJUmJ0VJizYYKp3
	 euSxCVXEB8gGouTGSQUgiC4DlmQt3xd0thJfJZ2SAzn0xgtHx5RdYe8FHA2d4ZzKjfQl+
	 ua80Zlk4nicFABgK7yE0fiiFR4Pmb3GShYAK8iMbivxHtlLUT/r6Ajl9P94UAZdgc8g==
ARC-Authentication-Results: i=2; smtp.kernel.org; dkim=pass header.d=google.com header.i=@google.com header.a=rsa-sha256 header.s=20251104 header.b=eL9Bz9Ue;
	dmarc=pass header.from=google.com;
	spf=pass smtp.mailfrom=google.com;
	arc=pass header.oldest-pass=0 smtp.remote-ip=209.85.210.43
Received: from mail-ot1-f43.google.com (mail-ot1-f43.google.com [209.85.210.43])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.kernel.org (Postfix) with ESMTPS id C984C1F000E9
	for <syzbot@kernel.org>; Fri, 14 Aug 2026 11:58:57 +0000 (UTC)
Authentication-Results: smtp.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=google.com header.i=@google.com header.a=rsa-sha256 header.s=20251104 header.b=eL9Bz9Ue
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.kernel.org C984C1F000E9
Authentication-Results: smtp.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.kernel.org; spf=pass smtp.mailfrom=google.com
Received: by mail-ot1-f43.google.com with SMTP id 46e09a7af769-7f18c0e03e3so451086a34.2
        for <syzbot@kernel.org>; Fri, 14 Aug 2026 04:58:57 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1786708737; cv=none;
        d=google.com; s=arc-20260327;
        b=cwYGoygVKZDEVYLKr1G7+IlsB1Udh16T0lDlSYuWcqAfsXKDDIr1WXbQQp3l3Rdevz
         EC3o1qK4yfibjyIGSFTycMVGT5iUv+zhkee6ATwlHsoO1If2R/mTd87MsGP9ieLdVs5j
         mc/6dTnlS7Xon9C8MOOvPmgdGF2MOfAIir2ccyvPkqCqQScVfBMRVSGIIJOHTqA28u72
         d/Nbtnpr9TWktM3u3TM4y1pUMOXIPm/fRmC/fo0T9Sv+sFc2pBUxFfm4AxvrIfAOVeFm
         YkEskBaKmy00vM1L9ejc+p3x6VTMADvEBmKOf1DJspL/b7vE+FbYO6fBtXQGIy7Il350
         Yp8A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=FTeB1gh2hA89RUQonVIIJYAuhk0qtjDlQT2f28m6Xzg=;
        fh=2Ld/g5BVZzBadtquf8mrXl84q+iOtbUed/2ECOFnmmI=;
        b=aG/aAZKPaeyyTC/Qd2srKvDS1q83r6pkr4mrTJAQzK/krCEsj5yMCf5SJdwp6U7grs
         HbdF4/uHwVFIxtSpxkQP21ucF3W6ZBTEhKRY0FOkFbxjgdGU7/BxSnLzDULlGWlV5mc2
         QKzCuUGwdYlnpxSiNIVL3sMxWwPSBKG5/Iy73D+vFt3SPGFYO7h+fSAh1L44m9CeCnGO
         ciODfZbzGAW2svclhy5fVPE013/XJeV2kV2zjdabDeqkwJJQq0GIXc+si+/tUXKnR+JJ
         mEkPQEBXQB/8kiIxv+w1F/n1tBZ+rQdZXINT/FKSkyQdDr/4T9VCHC84KLkjePEOeEVp
         xO6A==;
        darn=kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1786708737; x=1787313537; darn=kernel.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=FTeB1gh2hA89RUQonVIIJYAuhk0qtjDlQT2f28m6Xzg=;
        b=eL9Bz9UeOhkFCTlUgXhMmRcYScWK3MQtapqhHq5u3u08FL4lnhl+2rmIdYf9sK17/K
         bgYuLXkDp0RiwA/6A+0TYzInlMVYM+v+gcfZObP27HQB49vCq6rEqGUtsn9ktAOe/y5g
         jNt6ul7tnaOOZgX9Ahgw+u9PSSuPph2JS9Eus9YFhR2Xad0QAFHlsqOswi8X//yww6yU
         Scx9A3ANcRQoBOMgeRkdA8/e0YAmpDrrQ9B+cjXNccCR2fKiTz+MLo9IcZWPLnzmWMkO
         3//0MeoQKOYxtYg1FhlfuXzXVphZ7lTWZue8gbQXaDUmniSEJfV5jHAKB9KGl1AVSu41
         xePQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1786708737; x=1787313537;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=FTeB1gh2hA89RUQonVIIJYAuhk0qtjDlQT2f28m6Xzg=;
        b=hjpJ5lSbbppNRYWS/e9ZbLr3++hPrUC1XlgyEycKl4ys1blfVNQaG29w/QTkmSmWJu
         6l7r0WLvnJB9xU0XP26GlwwSVyg0jw2us8nlwrg7JqQ8s/c8M3oBH9WoYEdFjRT7rgfk
         sWmi1NgpsjTROJd/XbkMQNzNc46hVlYZMB2gIkuyRIYYHaK2h9k8OGM2UrHSq7dWqjkg
         VVKEEEPRfihhtNR59CbHHJ72uf9Jbf+VoqqUi9V5wXY62c9gm2vimT/T1+VC2raWQAZg
         fSqMF/mwCcV8PeoV3OlqIdz2Pr06xwc5EiznRLtU8atPRryTuRqYHAvCGd42G4zZXD7N
         l9Qg==
X-Gm-Message-State: AOJu0YwFZ+X1m4MyYZ3lRgchl/68HVbB4P/76TxqY0yfjTqsIYg/it7x
	9R1SJj7BWO22DyaiX+O4ZIbIL+x86dyXUQePoGnBQIwtB6BTroVa/1NMaL4pisqxeEQvq7BHKrg
	ARKKFB6Z4kqtOu58pIrBFJJiFokrdcrofvTV52PvPjvGgVKmUz6YmE3JP
X-Gm-Gg: AR+sD11Nrn5fZBQfypWqghloAGnGEE02e0sHmD/8J6YZ/ntB7q48Re1Nfh8SBOR8y1i
	1pTJl1NDSoOD8msLgYdk/6TWh1gheA4xEzfQiE6EB16RWDmStgFcnwdj6fDB1+uhBVzQd1PrFUZ
	V+aLel8nRLJ1O3uCe3WfH3QO1+xgf/T/wvz9Y3AtQ5fdV6NqKNZ6Rm3zOaBL1PLKbMbiJ19DMlA
	yx5zaHpZXpa993lxi+FOhYhzoJ/2GTbINWYZdrJHJ6zkQHiGBs/e8yJwWzatbCOrjPtV9acBSqa
	5q00qSLhMMnRlZVSCfThRtVDVCi6JnuTfG8uffgk0HQgo49EyuKJjD4KmoeK5Faq78UvOzbCr93
	Yn4G04TCpo46UEF8kf36+20yxLJMUhotsFaB2AbOj9arNosJvZ28SZW2MheLFrO+FhngfrRkdEj
	itUK58lhayWv6Y
X-Received: by 2002:a05:6830:6d4d:b0:7e6:ee1f:96f1 with SMTP id
 46e09a7af769-7f3de5ce42dmr4457732a34.5.1786708736228; Fri, 14 Aug 2026
 04:58:56 -0700 (PDT)
Precedence: bulk
X-Mailing-List: syzbot@lists.linux.dev
List-Id: <syzbot.lists.linux.dev>
List-Subscribe: <mailto:syzbot+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:syzbot+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <bcef3402-a9bf-44cd-ac73-e98c83fdef5e@mail.kernel.org>
In-Reply-To: <bcef3402-a9bf-44cd-ac73-e98c83fdef5e@mail.kernel.org>
From: Aleksandr Nogikh <nogikh@google.com>
Date: Fri, 14 Aug 2026 13:58:43 +0200
X-Gm-Features: AUfX_myNkYRdySsl-uol0P-o6_4ZD4KbZzLsIVZZd7iJzpBsS_TwKSKb_VQql24
Message-ID: <CANp29Y6bx_OZP8V=YJBSa0=DzZdofhD7dWLEcDO0WAAPeowyxQ@mail.gmail.com>
Subject: Re: [PATCH RFC v4] usb: gadget: uvc: check endpoint enabled state in uvcg_video_enable()
To: syzbot <syzbot@kernel.org>
Cc: syzkaller-upstream-moderation@googlegroups.com, syzbot@lists.linux.dev
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

#syz upstream

On Thu, Aug 13, 2026 at 8:21=E2=80=AFPM syzbot <syzbot@kernel.org> wrote:
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
> Link: https://syzkaller.appspot.com/ai_job?id=3D6bcd0cc3-0532-4cbc-81bd-e=
487719ff9a3
> To: "Greg Kroah-Hartman" <gregkh@linuxfoundation.org>
> To: <linux-usb@vger.kernel.org>
> To: "Michael Grzeschik" <m.grzeschik@pengutronix.de>
> Cc: "Frank Li" <Frank.Li@nxp.com>
> Cc: "Jimmy Hu" <hhhuuu@google.com>
> Cc: "Kees Cook" <kees@kernel.org>
> Cc: <linux-kernel@vger.kernel.org>
> Cc: "Muhammad Bilal" <meatuni001@gmail.com>
> Cc: "Junzhong Pan" <panjunzhong@linux.spacemit.com>
> Cc: "Xu Yang" <xu.yang_2@nxp.com>
>
> ---
> v4:
> - Return 0 early in uvc_v4l2_streamon() if state is already UVC_STATE_STR=
EAMING.
>
> v3:
> - Removed redundant video->ep->desc checks in uvcg_video_enable() and uvc=
_video_alloc_requests().
> - Dropped uvc->state transition changes in uvc_v4l2_streamon().
> https://lore.kernel.org/all/7055a5f1-3cf0-4ead-ad20-e63879247c29@mail.ker=
nel.org/T/
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
> index dfa0521a2..da857c2c5 100644
> --- a/drivers/usb/gadget/function/uvc_v4l2.c
> +++ b/drivers/usb/gadget/function/uvc_v4l2.c
> @@ -527,6 +527,12 @@ uvc_v4l2_streamon(struct file *file, void *fh, enum =
v4l2_buf_type type)
>         if (type !=3D video->queue.queue.type)
>                 return -EINVAL;
>
> +       if (uvc->state =3D=3D UVC_STATE_STREAMING)
> +               return 0;
> +
> +       if (uvc->state !=3D UVC_STATE_CONNECTED)
> +               return -ENODEV;
> +
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
