Received: from mail-oi1-f173.google.com (mail-oi1-f173.google.com [209.85.167.173])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AAC62403156
	for <syzbot@lists.linux.dev>; Mon,  3 Aug 2026 15:04:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.167.173
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785769458; cv=pass; b=Ly5ErCmSNQqQIXFfROe0zZZMDyfqSouKPuB5N86jqarr0Ay/bUpEINd9oRWls4f4bciiHNZDDWLY4u/TwJroyULRZCwifvGBP9dV0mhFhZiKRmK+ldgKaorCFrzr2CnCi9iyF8RCRrADKPozj/iUY1BpDgvzfNfrJ6ynLpUYf/M=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785769458; c=relaxed/simple;
	bh=9iNdn50hKPleESQnQ8An8gNoEmZ0g7ncs9XZhJY1XEw=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=d+a/iM4+Qs1AzwHtedClx9dpeUMulxuxKbH0+VQz4Tr/Uy1VOYTsNMOxsa8CKHt3UlVkoGerB4c9bjRt8XJICdJnEDlUM1xplz3ESvpKsxwveyrOTeZm/qxmZChZ18apMHb0zB3RhfqzHD45aXzVvsdC3BHLvDfOl/pyF3X8AmM=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=XtnwdwLB; arc=pass smtp.client-ip=209.85.167.173
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="XtnwdwLB"
Received: by mail-oi1-f173.google.com with SMTP id 5614622812f47-4955cd5da3dso1042496b6e.2
        for <syzbot@lists.linux.dev>; Mon, 03 Aug 2026 08:04:13 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1785769452; cv=none;
        d=google.com; s=arc-20260327;
        b=oonXjmbtIQ1R9L2F9rk1kF/D7/ZlyZQCNFopLBoh+6JZ+S/Wgz3QH3zsZWIC+jUDMp
         0KVemTvcejz0LwS3deYyOYIbzTW/wbhXBLDHX52z74GRTPcmfGP4zY9Pvz8PhkbMMsF7
         kWnOw/lmae18fiB5NjIkQSzGct/JOJwyflnPLYLYQ5Kzwmw+x1GuS88vZ5GjnrD02U+y
         RRU91dDw4+NKITF0EdEvur3PQ2daWjlgsUUtGLCb2DIe1XoHynBcvpyBuOJZTCccyCX7
         47HBVhBO9V6vwWFnWCLvQlI4dmLYJtdQvEn2SYCTuE/skh0NcG/p5CEyF6EYHuOUHgRB
         njmQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=bB5Vm/CAXL1ig3tYYUrc4LUvzZRsFDnoyqTrFu5sGl0=;
        fh=JFBzuuC2KArzswOG1WfLbanQ6Y1uf0+O1Imza7cxU0s=;
        b=hJNHbvjvaou3lXaBRu7ZyohWQwz1WuTOLFgoNWzS1wA5umo6EmySvcsVtQqg7/hzIq
         JdEOJEOv7jVVj3CT5VUhRJBEbQwH7mqbyc8QK8/8GanQdKzOTluucmlSkMEK10rBNgWS
         ZR1Tu1NNqXZLNj7WgZzYWKML4TUm6eJQWWGlOuhDUiYdcM2uIJ3ctt4/951px/ko28+2
         Q5u/DFHAQlKcqP39wavVr11XJFLVifmcajGz/sP8iHfoOMN7LXhWYcq3rVHUBF6zuafj
         5tx/CPs4ghwYa3l+/A2473EZ0YDIVMT+kfXG7MiapyblN8JaxLjM5If1NJw3J2rA6hXE
         NYOg==;
        darn=lists.linux.dev
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1785769452; x=1786374252; darn=lists.linux.dev;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=bB5Vm/CAXL1ig3tYYUrc4LUvzZRsFDnoyqTrFu5sGl0=;
        b=XtnwdwLB56JVpYC2QDTsPtIx7FqKI5YGEl6Qta2t0SN5Mpvq23I5/dWi8Wt5M8MQpi
         PTJAnUvmF/3XInuFnZ+gpYs8FcnDGQ5BR1RDw1nrDF1HbcpgSLbq0fcUxUxN8gfazrl2
         Zqm29PckapicqX9L6+4ajmC8VI3Wf7FsAW/cLDxgq3e+ZmMEbDunoIe7CjZeQw7pW2iN
         nyFKBj+SdJRIALqx81uqmsmmZm2bBOk/cO6e25qJAVVF2NoJ/bC2YItT1ZWTqT7lgcd6
         QBoz+4R/Bus2013VdaA+ev522KFpDDO2dsinK23XQohS7S9nEAMmQL344/1SuB8gaefH
         TgYA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1785769452; x=1786374252;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=bB5Vm/CAXL1ig3tYYUrc4LUvzZRsFDnoyqTrFu5sGl0=;
        b=lda/SLrOvwJp+EHVQLFkUk+AI0CCKJqSM+tb6OB1tSy1oQNxK0RGIdQIsa2n4/hYcj
         Grhhh3XYS7kyEfiSyppZFSEj6w/6oATR/AklZFF/i9VhJgWNCgyUfrDBXxvccfpCeNE3
         KKIYJJxYbCEBWgLPCsFr0WuBDuqTI9sPoi008cKzjSfE/nyPBpt5dWX1b5zWiVRikn0R
         cFSzyBoFsQKYvb8saotprIbZs4nijMwNT+de14jalLwdq3saZ9NyADU4d1uO3eLtFJHm
         O3VrVt9FG44vVuPcZ+eMavu+Oa7McUWj2hDYarhjM2gGRucvEwo3t64f8JIyCP8FWXK2
         dVpw==
X-Forwarded-Encrypted: i=1; AHgh+RpEm3btqSgKm3LGrDG0AU7IJXJPQWMG95wNOzHeo8xo49cS8490Vp3tebSE9tK0KRseTf68GCc=@lists.linux.dev
X-Gm-Message-State: AOJu0YyDbuEz5lu7aR924Tn13hhIdN8h8oeXT2T8DkM/HdWHwZdlKQAL
	zUAdvSM/tbEL6UZdUzy02OmT2Jlsun6x6/JbtkB4oYD9l+v0WNG7Vb5NL4UxtKhK4cWO2NxGsYb
	lAlY/mNoaphbZP7NlbzvLdt4d4DqSUbfHiMrxkFAh
X-Gm-Gg: AR+sD11VKQUJwsk3nqr07LOUJXU5DXTpCqBIyC2ZtOMBVCY0OE0YgEMxg9JKOXR7Tmj
	3Z7DiR1rXGsu7FfNtKov53VodtX9zZRx9A3JBdZLjxaHLGq14PbJ247FQH/OvUF2BWSFotDRIdX
	rrIm/rvrEaia2L61rgaqZu2uF6XML2PqCGMIghXnWjPGV8lYq1Qmp808K+pQxYNDu4pwiRLu6AJ
	58xP+3Oo31bVZk7zlqH8gZAAlYxAcbNyK6XnvcC/GoSoPDI3+DqdMB5xn0WP3k0atePW5vqc2Mv
	awqbwkmCW616x3kQM84ODVDXLqAPCC4z5rJg9lLgxQJwIIPbIszOjuzAInV6QcjBbig5hB6mPQF
	PO+8FadiSFJXvRIvT/ItHCdeh1cdsceH+rrKrNrz6FPvctHo6gdEQuIe86pqRXFcplE8rtb8hii
	0kwFqLsDqWpja+
X-Received: by 2002:a05:6808:c1e8:b0:497:d371:21c8 with SMTP id
 5614622812f47-4af5e2cd936mr15745770b6e.19.1785769451914; Mon, 03 Aug 2026
 08:04:11 -0700 (PDT)
Precedence: bulk
X-Mailing-List: syzbot@lists.linux.dev
List-Id: <syzbot.lists.linux.dev>
List-Subscribe: <mailto:syzbot+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:syzbot+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <330619da-665c-4dd6-ac14-30e8bef174fd@mail.kernel.org>
In-Reply-To: <330619da-665c-4dd6-ac14-30e8bef174fd@mail.kernel.org>
From: Aleksandr Nogikh <nogikh@google.com>
Date: Mon, 3 Aug 2026 17:04:00 +0200
X-Gm-Features: AUfX_mzKGal5NBhEa6Tmu8HEN83ADg5aEG361ZqVumhaCjsBQf89iivSg2IMpGc
Message-ID: <CANp29Y73zeaR5Xkob11VFxgmjHcYvOjdjLaTO55vBVuY=L1KHg@mail.gmail.com>
Subject: Re: [PATCH RFC] usbip: fix use-after-free in event_handler()
To: syzbot <syzbot@kernel.org>
Cc: syzkaller-upstream-moderation@googlegroups.com, syzbot@lists.linux.dev
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

#syz upstream

On Mon, Aug 3, 2026 at 11:26=E2=80=AFAM 'syzbot' via
syzkaller-upstream-moderation
<syzkaller-upstream-moderation@googlegroups.com> wrote:
>
> The event_handler function in drivers/usb/usbip/usbip_event.c is a
> workqueue item responsible for processing events for a struct usbip_devic=
e.
> During device teardown, usbip_stop_eh() is called to wait for the event
> handler to finish processing. However, usbip_stop_eh() uses
> wait_event_interruptible() and ignores its return value. If the process
> unbinding the driver receives a signal, wait_event_interruptible() return=
s
> immediately, causing the teardown process to falsely assume the event
> handler has finished. The teardown process then proceeds to free the
> usbip_device memory. Meanwhile, the event_handler workqueue is still
> running and attempts to access the freed usbip_device, resulting in a KAS=
AN
> slab-use-after-free crash.
>
> BUG: KASAN: slab-use-after-free in __mutex_lock_common
> kernel/locking/rtmutex_api.c:559 [inline]
> BUG: KASAN: slab-use-after-free in mutex_lock_nested+0x5a/0x1d0
> kernel/locking/rtmutex_api.c:578
> Read of size 1 at addr ffff8881145245b0 by task kworker/u8:5/6177
>
> Call Trace:
>  <TASK>
>  lock_acquire+0x84/0x350 kernel/locking/lockdep.c:5842
>  __mutex_lock_common kernel/locking/rtmutex_api.c:559 [inline]
>  mutex_lock_nested+0x5a/0x1d0 kernel/locking/rtmutex_api.c:578
>  event_handler+0x1e3/0x4a0 drivers/usb/usbip/usbip_event.c:73
>  process_one_work kernel/workqueue.c:3322 [inline]
>  process_scheduled_works+0xa8e/0x14e0 kernel/workqueue.c:3405
>  worker_thread+0xa47/0xfb0 kernel/workqueue.c:3486
>  kthread+0x388/0x470 kernel/kthread.c:436
>  ret_from_fork+0x514/0xb70 arch/x86/kernel/process.c:158
>  ret_from_fork_asm+0x1a/0x30 arch/x86/entry/entry_64.S:245
>  </TASK>
>
> To fix this, change wait_event_interruptible() to wait_event() in
> usbip_stop_eh(). This ensures that the teardown process strictly waits fo=
r
> the event handler to finish its execution and drop all references to the
> usbip_device before the memory is freed, preventing the use-after-free.
> This change is safe from deadlocks because usbip_stop_eh() is never calle=
d
> with locks held that the event_handler would need to acquire.
>
> Fixes: bb7871ad99ea ("usbip: event handler as one thread")
> Assisted-by: Gemini:gemini-3.5-flash Gemini:gemini-3.1-pro-preview syzbot
> Reported-by: syzbot+f4518ac0a3dd3aafde38@syzkaller.appspotmail.com
> Closes: https://syzkaller.appspot.com/bug?extid=3Df4518ac0a3dd3aafde38
> Link: https://syzkaller.appspot.com/ai_job?id=3D88101c8e-4da9-45de-b879-0=
549d6fe5649
> To: "Greg Kroah-Hartman" <gregkh@linuxfoundation.org>
> To: <linux-usb@vger.kernel.org>
> To: "Shuah Khan" <shuah@kernel.org>
> To: "Valentina Manea" <valentina.manea.m@gmail.com>
> To: "Nobuo Iwata" <nobuo.iwata@fujixerox.co.jp>
> Cc: "Hongren Zheng" <i@zenithal.me>
> Cc: <linux-kernel@vger.kernel.org>
>
> ---
> diff --git a/drivers/usb/usbip/usbip_event.c b/drivers/usb/usbip/usbip_ev=
ent.c
> index 0e00c2d00..81d761891 100644
> --- a/drivers/usb/usbip/usbip_event.c
> +++ b/drivers/usb/usbip/usbip_event.c
> @@ -115,7 +115,7 @@ void usbip_stop_eh(struct usbip_device *ud)
>         if (pending)
>                 usbip_dbg_eh("usbip_eh waiting completion %lx\n", pending=
);
>
> -       wait_event_interruptible(ud->eh_waitq, !(ud->event & ~USBIP_EH_BY=
E));
> +       wait_event(ud->eh_waitq, !(ud->event & ~USBIP_EH_BYE));
>         usbip_dbg_eh("usbip_eh has stopped\n");
>  }
>  EXPORT_SYMBOL_GPL(usbip_stop_eh);
>
>
> base-commit: 075b74841bd0065a3bda3440873c747938e69b68
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
-upstream-moderation/330619da-665c-4dd6-ac14-30e8bef174fd%40mail.kernel.org=
.
