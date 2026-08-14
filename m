Received: from mail-oa1-f48.google.com (mail-oa1-f48.google.com [209.85.160.48])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3F30A459AF4
	for <syzbot@lists.linux.dev>; Fri, 14 Aug 2026 13:38:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.160.48
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786714720; cv=pass; b=guZV3iU+2/I32nU1lyHldebJg2L/AOXoww0/5cJbtEKKT8qID8Ayex5ODmEpd07nk5A79buIJVIN8BIfx5hBM2LpgDXB2lJWOVBcMTy71BREaNwpYw8/jnz/SZ77sRQNVe9IHMhZVqS3mPyV3HX5W8Urrvd4eQ6GIMhtOr+0q1g=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786714720; c=relaxed/simple;
	bh=llEs8Dgagm5ztfGQ24bnX/RL6fnvJKr997N7Nzvu4n4=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=OHICd6oXEBQ/nHcehi1EP3BQaG1h85M5CZry3ZQyehvXRNpHgdoL+Q7+mjDzPti9jz8kyvX+grCm7XH9H5nDfS/SYEVXVU7F1jkDLXMriIExvxkc/7Av1yRw5gXhyux/rW/Jx30jBETPTuDA+goGKoWj0mPL1h8KFeXZ+Dr0HEI=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=twHaR+Tm; arc=pass smtp.client-ip=209.85.160.48
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="twHaR+Tm"
Received: by mail-oa1-f48.google.com with SMTP id 586e51a60fabf-4518ad44e83so636829fac.0
        for <syzbot@lists.linux.dev>; Fri, 14 Aug 2026 06:38:39 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1786714718; cv=none;
        d=google.com; s=arc-20260327;
        b=XKpEQaZ22iGQNawNGURt/M8Ut/L4UzoNtMxVrBpHqu7YJBKfL88Hjlm56fJ3zW9ADp
         xiRAPxEK7XwK67lv13tUhD53BXO1Fjp3LbyTZNEtTCcfUUMXL2La593qhSX2zlEWCWT3
         9bGX12IwEsRIrpknyAuGrOcECyt8K1jmYi+Ya8l8VrRPpAJq6EbOv3JAsvPvM2WnB9oG
         C5h/MyLFQJ0rtlCT0BS/ZSCrP6YsEKzT0tgPvaXvBGdSorKFW2Du1BGLiaiL6WhTmc88
         vuOjhQd76k+uBuP7n9YWxdu9QGPpQyqkfOnT/vYR3DxquVdbk3ryXda+4E5xpriYoxXy
         qw0w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=h5y94mIJNJzdKUNy2CbJPeZfCNVq2VmsXcWCtje19XI=;
        fh=eG6en2/0hpMD8r1DGLKfUN2oW5w03GxNocMXoJdHJH8=;
        b=RBqpC9ODcN6ZwKGEI+Kw0KXDXtbuKrjb2fL973JFiYV4c16VP//4AvQRkwgxIfyy0I
         h2FfioErIjrLsMKBJ1yUC3oj1IQKI5jqN9wDVD3lifPRsAYWNzWFhuL0ksT6hyHD1ruO
         tdHsODVhR6JvGRZ1DEm2CCw5q9YmrmLyeumjoC93uX39SqFfVPa0Rxel95+F0smHGZJ1
         6RCyzYJRpT3i3KqUTr8usUWvRyEsatsNnr/6pBYPxWp2eA28bEBJzfJAoPjWWFNhgIxS
         ju8dj3T1nU5bJUxTZzbOkb72AaLEVoNdFPdz4rO7Duds5XpIifjFPq22P95PtIOodjel
         JyJQ==;
        darn=lists.linux.dev
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1786714718; x=1787319518; darn=lists.linux.dev;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=h5y94mIJNJzdKUNy2CbJPeZfCNVq2VmsXcWCtje19XI=;
        b=twHaR+Tm+jC0abN+JqgPjZR9Dbrm9zU5iYXutXDCDewcNNiJ42s4L5RukObCQJB0C5
         Y56F+VkSNFj+BfS75waKoGJWpEYOU1tKzDoA1WBVf7yWZb9oduljPi1osd76cFh1hUwr
         tcuk2lJTgmn4iers5WyfdjdvTdOLrCCQWDNejHLueubH4Jnpwo7zC29iQfs+YXC0c0pe
         WiKY3motMmEiEm18J0g8Nw7qOXjHlsL6uJ7IF6jnrh/7kpV7N+41Bewiqdyd2JuGGXER
         dM2tYtAeD20Euf/W6tzOFtCcNyh25Pu+klv2QrpdGt5FHxL+e7raeurHrwRBkG/e7q8M
         KJvQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1786714718; x=1787319518;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=h5y94mIJNJzdKUNy2CbJPeZfCNVq2VmsXcWCtje19XI=;
        b=Hz2cJCuHHqyxGSSfQ5Dp2jwfRKIzp8jwHl7eZFJ7coZ1qOpkHU0Vpe9qhVWIbYuG/4
         8pzFZ5Sv7GbkhPuU0uLPmPszTbudwqdlTFh1FeNZcxS1QEnQuWvdBH/QydNlD3sVOUBp
         s3XYfeKyg3R/kPe3SN/+YOc16fb0Fi9ZErDhmzf4OnpjRp1Ov1VBkB8M3LQDKNq3MoPO
         bOlsRrSf+m/4EGgQ3qX8sIpgBobIjRkhYuCtkGeR5WzIrw8L8I3ImABmLzLzRwXEsWfV
         I4236iPBOm7UMwifwnylkF/WpLr16NO7F15tyB4IU2y48M8h2otzw+i/SfMx1+44SePC
         TSbQ==
X-Forwarded-Encrypted: i=1; AHgh+Ro9tEZKyHghc4znIc5NkdGY6UPIo1ssGcfsitZUVh1SsRR+SgTObcvcjl+d/ZeA1PH80GRDxPU=@lists.linux.dev
X-Gm-Message-State: AOJu0Yx0YH3aS5qlno91brVJ8fPQMNbhWNDhKEHnflY5xHsR0xTeYE1I
	zMdbfV7sHEL73++IrBbLzGkPmWSXjo8OnxdlESGzHhVv5PZK6RB6NcZv/n794JkPoj/s+we+36V
	P60Bnw6Ru3WK6Pvydhp3gRtR/pkpgxUFB26tPMl5M
X-Gm-Gg: AR+sD11NL2fWFPnPEuH3O02VwhnPqvVHWer/FGpWnGqaOTzqQr5veLvIhmvrMgXGm54
	8ndVm8+7xGZUGL1d0l5tzX7t6nyNKNl+yYN5sRHM0x/Cte0GnzdbNDRJpAK3FEa08IpwUtJOHPn
	Bv0zvzTJ7i1Etyu5DHxqBeCxWuv3zGAx4lb7QTymdYkfs7N8WGNgjDhBfSiGVx/LRUqRKlX3zOm
	BLmeC8rono7W3/RxscAqnTu7orfWUa1aFFLlKwcvWy9VX8/LNhEmQB8gOYQslRaG504Yv9erHqa
	ITG5O68/gb5ifsc9622ispVQ+VlQoHYg8WJkTIfmYcTsVrtyplc5+qidkYvnc6yLaH9h3xMUrjH
	AQGkz59cyBVvFyVliNaDVB2HQiQMlkrYPcAmHN/86TLDrBnxBa9qSUK/dp0tyMAxxdl2jOwkvlG
	NuT6rPfx8CYGLx
X-Received: by 2002:a05:6808:4fc9:b0:497:d3d6:6a40 with SMTP id
 5614622812f47-4b240f872f9mr5487854b6e.3.1786714717348; Fri, 14 Aug 2026
 06:38:37 -0700 (PDT)
Precedence: bulk
X-Mailing-List: syzbot@lists.linux.dev
List-Id: <syzbot.lists.linux.dev>
List-Subscribe: <mailto:syzbot+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:syzbot+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <94a2df4a-c0d2-4a29-a692-e7250a623057@mail.kernel.org>
In-Reply-To: <94a2df4a-c0d2-4a29-a692-e7250a623057@mail.kernel.org>
From: Aleksandr Nogikh <nogikh@google.com>
Date: Fri, 14 Aug 2026 15:38:24 +0200
X-Gm-Features: AUfX_mzWiWmzckXhSaSOnnO-hSkx2UrsRxJQO3kzR9NP9ipGulute3h6IoMaDMk
Message-ID: <CANp29Y73TgQaGYowKoQ2TRAjgB3Y7dBq48ajtobUsn-o80qqGQ@mail.gmail.com>
Subject: Re: [PATCH RFC] Input: serio - check if device is registered in serio_find_driver()
To: syzbot <syzbot@kernel.org>
Cc: syzkaller-upstream-moderation@googlegroups.com, syzbot@lists.linux.dev
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Fri, Aug 14, 2026 at 11:42=E2=80=AFAM 'syzbot' via
syzkaller-upstream-moderation
<syzkaller-upstream-moderation@googlegroups.com> wrote:
>
> A general protection fault can occur in __device_attach() due to a race
> condition between serio_add_port() and serio_interrupt() when device_add(=
)
> fails.
>
> If device_add() fails (e.g., due to a memory allocation failure), it clea=
ns
> up and sets dev->p =3D NULL. However, there is a brief window during
> device_add() where kobject_add() sets state_in_sysfs =3D 1, causing
> device_is_registered() to return true. If an interrupt occurs during this
> window, serio_interrupt() might queue a SERIO_RESCAN_PORT event.
>
> When the workqueue processes this stale event, it eventually calls
> serio_find_driver(), which directly invokes device_attach() without
> verifying if the device was successfully registered. This leads to a NULL
> pointer dereference when __device_attach() attempts to lock the device
> using the freed dev->p.
>
> Oops: general protection fault, probably for non-canonical address
> 0xdffffc0000000021: 0000 [#1] SMP KASAN NOPTI
> KASAN: null-ptr-deref in range [0x0000000000000108-0x000000000000010f]
> CPU: 1 UID: 0 PID: 5689 Comm: kworker/1:4 Not tainted
> Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS
> 1.16.3-debian-1.16.3-2 04/01/2014
> Workqueue: events_long serio_handle_event
> RIP: 0010:__device_attach+0xb3/0x450 drivers/base/dd.c:1074
> Call Trace:
>  <TASK>
>  serio_find_driver drivers/input/serio/serio.c:112 [inline]
>  serio_handle_event+0x581/0x860 drivers/input/serio/serio.c:206
>  process_one_work kernel/workqueue.c:3322 [inline]
>  process_scheduled_works+0xa8e/0x14e0 kernel/workqueue.c:3405
>  worker_thread+0x92d/0xe10 kernel/workqueue.c:3486
>  kthread+0x388/0x470 kernel/kthread.c:436
>  ret_from_fork+0x514/0xb70 arch/x86/kernel/process.c:158
>  ret_from_fork_asm+0x1a/0x30 arch/x86/entry/entry_64.S:245
>  </TASK>
>
> Fix this by checking if the device is registered in serio_find_driver()
> before attempting to attach a driver, safely ignoring any stale events fo=
r
> devices that failed registration.
>
> Fixes: ddf1ffbd40c9 ("Input: serio - let device core tell us if device wa=
s registered")
> Assisted-by: Gemini:gemini-3.6-flash Gemini:gemini-3.1-pro-preview syzbot
> Reported-by: syzbot+de42beb9ccc760a210ab@syzkaller.appspotmail.com
> Closes: https://syzkaller.appspot.com/bug?extid=3Dde42beb9ccc760a210ab
> Link: https://syzkaller.appspot.com/ai_job?id=3D4397f1ef-be0d-4e1b-897a-f=
cd37e50cc6b
> To: "Dmitry Torokhov" <dmitry.torokhov@gmail.com>
> To: <linux-input@vger.kernel.org>
> Cc: "Kees Cook" <kees@kernel.org>
> Cc: <linux-kernel@vger.kernel.org>
>
> ---
> diff --git a/drivers/input/serio/serio.c b/drivers/input/serio/serio.c
> index 54dd26249..c24e431af 100644
> --- a/drivers/input/serio/serio.c
> +++ b/drivers/input/serio/serio.c
> @@ -109,6 +109,9 @@ static void serio_find_driver(struct serio *serio)
>  {
>         int error;
>
> +       if (!device_is_registered(&serio->dev))
> +               return;
> +
>         error =3D device_attach(&serio->dev);
>         if (error < 0 && error !=3D -EPROBE_DEFER)
>                 dev_warn(&serio->dev,
>
>


This papers over the real bug: serio_add_port() does not roll back
registration when device_add() fails.

Instead of defensive checks in serio_find_driver(), serio_add_port()
(and gameport_add_port()) must unwind on device_add() failure: stop
the port, unlink from lists, flush pending events with
serio_remove_pending_events(), and call put_device().

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
-upstream-moderation/94a2df4a-c0d2-4a29-a692-e7250a623057%40mail.kernel.org=
.
