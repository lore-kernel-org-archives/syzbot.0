Received: from mail-oo1-f50.google.com (mail-oo1-f50.google.com [209.85.161.50])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 29BC5285061
	for <syzbot@lists.linux.dev>; Mon, 17 Aug 2026 14:04:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.161.50
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786975479; cv=pass; b=s97a53A5CkQPa8/JBVmkU2WIWsC0L0NaFXstZ+jGYjJ2kswIwK2CsakBfpKDYuSQvOJuSPlI9wJ9YRZYcSlIoF8ZlcM6i+vMRgKA6LybmynHlUgHg5XX9u9KfDzulItZQ9M96ioBtJtPGJU16gU1L/ANR27n68+YoP3KtYIg4TU=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786975479; c=relaxed/simple;
	bh=BE4maXQgFKNpUctNwwGrqjVBbdmOrX4tS9VbQM95J9c=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=tS0rAC5WpAjLwpso2X6szXh9sinHrCZD2bwSp/SI0AVS2PJjz8+91qiNX4NeUXprPQ/lkCCR4ba/Iri5QDAwkl6hq3CyL3tycXSuav4hLtCNL/D/T8zXhMy1mG8TiQ7YvJrzGQ7caso6GC7U35DxPZJxTYgPOwCsCyUeqUh29C4=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=ItZjQIQy; arc=pass smtp.client-ip=209.85.161.50
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="ItZjQIQy"
Received: by mail-oo1-f50.google.com with SMTP id 006d021491bc7-6b051516aaaso2190031eaf.2
        for <syzbot@lists.linux.dev>; Mon, 17 Aug 2026 07:04:37 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1786975477; cv=none;
        d=google.com; s=arc-20260327;
        b=DyQNp1bBjii6fojQmfG2HhBgQcfIxmHBsnqu3dFM/HtYMC6Zjha6WGVLRBMJjNA6TJ
         slULdlBIkLs1oTGlgQsF3OI1S8YXyBaERpHP05veO6UNSW4/K4Fq1ptFkCywy/q1tZcf
         lDQ7V4FP4TUCtjnoBARG/TpBsmrtE+3a2uOgisZaXr7XrsvVlbsZawWT/0n9K8hs/mCT
         CvpOR/6SYBlLtPFQQEu73uQVOP/hxYtnpdsenktCThs7VAaPgg6xXuIYxM8I5n+BMwlS
         t5p8aJvsD3w+kkQ/i69ntsb0nqWY5FsgCHuYTaqr00Vux546/yAmcGKYGvaTaUfRsAEJ
         sFYA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=aP+6MoQFs4CQ8trb/G1U2gW7Ry1QTrDoqABKqNg1gB8=;
        fh=jiG/kJSI8xooOy3gn0HQZiRKci3ZW56oB0sopl1eIys=;
        b=QAFRowUYZIJiud+nlPhvVVn0j0nT12R/4yREgjD2QwPBvb8wCz/DkWwKPv5yxHw5RD
         2S7fdVr5L99MMsaeV/p5U/p/sVLqQge1iHgAlSK5CHTIBR6+baUtxHq+L+/tdktOCD8h
         KxivoOWKn5e3dn6kGhJR5H5KNIvIZouvIdMm8NrLfLsKvkdZUbIpMZr9wrsBJolW82FJ
         gwQbXEteh/6I34sgLBeNL4eDdd/9TUrXZE9VrO3st86rcCdkoyTtjIhJk2Wmhg6CPbdv
         S2obV/fF/KEx4tRSGdL2sIh3EVbAV1FKoqSwXgbRcvJOfaxLS3UwOgPvNdYsayLfBrij
         mA9g==;
        darn=lists.linux.dev
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1786975477; x=1787580277; darn=lists.linux.dev;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=aP+6MoQFs4CQ8trb/G1U2gW7Ry1QTrDoqABKqNg1gB8=;
        b=ItZjQIQy9DybGYpMiiKR2dg33UTlbLoXC8dC0ymt38oO9TVB/hGuyXJDiBS9YJRzrs
         VglFLs19vyxk1XOEdgIunUBeFsNXFlbQDfl7R7Z23TLoI3i4ZCFLDHvo0Vf/w9bJS+Y+
         g24SiP2wtQ1fmgFkpVtc4IotNNmrmJWK8MDCG4kcrVeq/E5uGdlv129WUi2Y8kHbGr1t
         NeTLsdhN62AQNQMbRVIh3a4gPi4wWps5CZQ/SvxZlC0kI3/eyiKeuJzHE44D7SmCn8Vi
         38aqn0JmgrIC0v2qAxhW4W80c01AjGYyULRQR8IV7zzK3Y4wananUUmRwHrh/RlyjmJk
         Rgtg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1786975477; x=1787580277;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=aP+6MoQFs4CQ8trb/G1U2gW7Ry1QTrDoqABKqNg1gB8=;
        b=l7gTKT7egof8RQw/WSJh966iQOAqzGd1y1cn8jnVkq/BnSQrVUWiqMCcpZmQ8bwPys
         lfiwcJopUt+IHpcsw+LwaM9tr5Ix8D9g3vk0BjkN/yhiY2OF7jjOyWvQKzC9xPnlKHBV
         tjru+4v6A/zkbHE4FZfcndq6th8a30znUuE1J0ERQenpN9m3BqKVRfdSfbprtdH/gAlT
         uDX3SnHDSDeUv9cVDFtcmUlbHojtGgl/9LMPmu+apYwHoitrA2SsF0lc8T5W9C9JfTFx
         YK76qvXqRkj+nIcaz/yIPT1PdtGGYRxbf44FFwWNBmO3qfnJENUm6cogdozqMXKhv7Zd
         S+pw==
X-Forwarded-Encrypted: i=1; AHgh+RoaN5YbwfHsNnWEiCJJRc2eSVcqCAZ4LzgDBC3zx2kFJ7iUreoLIFVIS1Dww6bKrofCFoHoCAo=@lists.linux.dev
X-Gm-Message-State: AOJu0YzjQpeNAbfWSkVBA31LSyV4YkGg30vZRHYeuHWhJ2CAcXNIfcYG
	XdrZxNv9wWznZS5b0E9VgdL4/x1cS/KU39psOiNlnKimCcvF7O0TtWX+AfTQ3I4HnEcK7ARoCQU
	XI0x8HZMn74ahed5L4rvZTIvfY4xlEvY2RdVNuU6t
X-Gm-Gg: AR+sD11mhujQwDXu7c7L81/sNjHx4TXaKA61c5ONp/nzq8f8ciR/insLNnlRyQYT39m
	NHt503ICq/wwDgmnaMJS8P83xrF2Bq/jROW9NlWIunKtZqefvIjyUIQ8l81lS+ZNR/7YozQ826D
	xamhvZWp/eD2jbr4gM1XKxyjaDd/oeS3L3PK30sJJBLi2gOHAKoEethZg0hRLD/MZbrB+zbKges
	5FjznvQr8hPSBiKDk5tx+Dv5+4slbfJhvhpWM/Nkac4qAWClzZLe4WiO5CX9h9t9tzfg88dYADo
	3WXX2ih5uvtcs0KICiyQt2zBxJ7WBNcmZ8nPicq+hUk+ITGU5v8a5FZFPb/al1CshUAeUm06U+2
	TKfvojmaeNKSzhkwKakT0fXV4EbpQSC3Gqx51sX4v2OgRywhnPhZwPOpDCAW2zh6/ot8ItvyBmr
	JAEV4p+9wWGCU=
X-Received: by 2002:a05:6820:1c8a:b0:6b0:4c0a:c8bd with SMTP id
 006d021491bc7-6b11e222d57mr412870eaf.26.1786975476388; Mon, 17 Aug 2026
 07:04:36 -0700 (PDT)
Precedence: bulk
X-Mailing-List: syzbot@lists.linux.dev
List-Id: <syzbot.lists.linux.dev>
List-Subscribe: <mailto:syzbot+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:syzbot+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20d7b17b-9c29-4c28-95a4-e4377e35f440@mail.kernel.org>
In-Reply-To: <20d7b17b-9c29-4c28-95a4-e4377e35f440@mail.kernel.org>
From: Aleksandr Nogikh <nogikh@google.com>
Date: Mon, 17 Aug 2026 16:04:25 +0200
X-Gm-Features: AcwNN1Ug6dgw7aNQhaAEyyqnLCzIPILZJtTvnMokHtStbpIJQyj1HBx5FixBczk
Message-ID: <CANp29Y6HAAavTb1yeiRL-ybGwnfA-W1GYjDNYTFdTYT4cndQ_g@mail.gmail.com>
Subject: Re: [PATCH RFC] media: usbtv: fix null-pointer dereference on disconnect
To: syzbot <syzbot@kernel.org>
Cc: syzkaller-upstream-moderation@googlegroups.com, syzbot@lists.linux.dev
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

#syz upstream

On Mon, Aug 17, 2026 at 1:09=E2=80=AFAM 'syzbot' via
syzkaller-upstream-moderation
<syzkaller-upstream-moderation@googlegroups.com> wrote:
>
> A null-pointer dereference can occur in usb_make_path() when called from
> usbtv_querycap() (and other ioctl handlers) during device disconnection.
>
> Oops: general protection fault, probably for non-canonical address
> 0xdffffc000000000a: 0000 [#1] SMP KASAN NOPTI
> KASAN: null-ptr-deref in range [0x0000000000000050-0x0000000000000057]
> RIP: 0010:usb_make_path include/linux/usb.h:985 [inline]
> RIP: 0010:usbtv_querycap+0x9c/0x100
> drivers/media/usb/usbtv/usbtv-video.c:612
> ...
> Call Trace:
>  <TASK>
>  v4l_querycap+0x236/0x470 drivers/media/v4l2-core/v4l2-ioctl.c:1106
>  __video_do_ioctl+0x8af/0xc70 drivers/media/v4l2-core/v4l2-ioctl.c:3133
>  video_usercopy+0x860/0x1430 drivers/media/v4l2-core/v4l2-ioctl.c:3475
>  v4l2_ioctl+0x18d/0x1e0 drivers/media/v4l2-core/v4l2-dev.c:366
>  vfs_ioctl fs/ioctl.c:51 [inline]
>  __do_sys_ioctl fs/ioctl.c:597 [inline]
>  __se_sys_ioctl+0xfc/0x170 fs/ioctl.c:583
>  do_syscall_x64 arch/x86/entry/syscall_64.c:63 [inline]
>  do_syscall_64+0x174/0x580 arch/x86/entry/syscall_64.c:94
>
> This happens due to a race condition between the USB device disconnect
> routine (usbtv_disconnect()) and V4L2 ioctls. When the device is
> disconnected, usbtv_disconnect() sets usbtv->udev =3D NULL without holdin=
g
> the usbtv->v4l2_lock mutex. Concurrently, an ioctl handler like
> usbtv_querycap() can be executing under the v4l2_lock and attempt to use
> usbtv->udev, leading to a crash.
>
> To fix this, move the usbtv->udev =3D NULL assignment into usbtv_video_fr=
ee()
> and protect it with mutex_lock(&usbtv->v4l2_lock). This ensures that no
> non-queue ioctl handler can run concurrently with the pointer being
> nullified. If an ioctl is already running, the mutex will block the
> disconnect path until the ioctl finishes. If an ioctl is blocked waiting
> for the lock, it will acquire it after the disconnect routine releases it=
,
> but will then check video_is_registered() (which was cleared by
> vb2_video_unregister_device()) and safely return -ENODEV.
>
> Acquiring v4l2_lock after vb2_video_unregister_device() avoids
> reintroducing a historical deadlock issue, and usbtv_audio_free() remains
> safe as it is called before usbtv_video_free().
>
> Fixes: 65e6a2773d65 ("media: usbtv: Remove useless locks in usbtv_video_f=
ree()")
> Assisted-by: Gemini:gemini-3.6-flash Gemini:gemini-3.1-pro-preview syzbot
> Reported-by: syzbot+37a57a84893052ab6071@syzkaller.appspotmail.com
> Closes: https://syzkaller.appspot.com/bug?extid=3D37a57a84893052ab6071
> Link: https://syzkaller.appspot.com/ai_job?id=3D5abbe65a-5853-4bc2-9135-5=
c75f88d51ed
> To: <linux-media@vger.kernel.org>
> To: "Mauro Carvalho Chehab" <mchehab@kernel.org>
> To: "Benjamin Gaignard" <benjamin.gaignard@collabora.com>
> Cc: "Hans Verkuil" <hverkuil+cisco@kernel.org>
> Cc: "Johan Hovold" <johan@kernel.org>
> Cc: "Kees Cook" <kees@kernel.org>
> Cc: <linux-kernel@vger.kernel.org>
>
> ---
> diff --git a/drivers/media/usb/usbtv/usbtv-core.c b/drivers/media/usb/usb=
tv/usbtv-core.c
> index 6c4facf4f..b33b54fdb 100644
> --- a/drivers/media/usb/usbtv/usbtv-core.c
> +++ b/drivers/media/usb/usbtv/usbtv-core.c
> @@ -136,8 +136,6 @@ static void usbtv_disconnect(struct usb_interface *in=
tf)
>         usbtv_audio_free(usbtv);
>         usbtv_video_free(usbtv);
>
> -       usbtv->udev =3D NULL;
> -
>         /* the usbtv structure will be deallocated when v4l2 will be
>            done using it */
>         v4l2_device_put(&usbtv->v4l2_dev);
> diff --git a/drivers/media/usb/usbtv/usbtv-video.c b/drivers/media/usb/us=
btv/usbtv-video.c
> index de0328100..ef066df71 100644
> --- a/drivers/media/usb/usbtv/usbtv-video.c
> +++ b/drivers/media/usb/usbtv/usbtv-video.c
> @@ -968,5 +968,9 @@ void usbtv_video_free(struct usbtv *usbtv)
>         vb2_video_unregister_device(&usbtv->vdev);
>         v4l2_device_disconnect(&usbtv->v4l2_dev);
>
> +       mutex_lock(&usbtv->v4l2_lock);
> +       usbtv->udev =3D NULL;
> +       mutex_unlock(&usbtv->v4l2_lock);
> +
>         v4l2_device_put(&usbtv->v4l2_dev);
>  }
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
>
> --
> You received this message because you are subscribed to the Google Groups=
 "syzkaller-upstream-moderation" group.
> To unsubscribe from this group and stop receiving emails from it, send an=
 email to syzkaller-upstream-moderation+unsubscribe@googlegroups.com.
> To view this discussion visit https://groups.google.com/d/msgid/syzkaller=
-upstream-moderation/20d7b17b-9c29-4c28-95a4-e4377e35f440%40mail.kernel.org=
.
