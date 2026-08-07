Received: from mail-ot1-f41.google.com (mail-ot1-f41.google.com [209.85.210.41])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E3183318EC4
	for <syzbot@lists.linux.dev>; Fri,  7 Aug 2026 14:18:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.210.41
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786112319; cv=pass; b=hGvYVtUI4jmDAdcylM16R+fNFiTu8ujbOvePPGYQCYH4SW59rMemhYJpVzmxjQzRpfg7oq3H/yKOfHRAsutCnXjUNr/vio4JpsTMuWd6XHexmvd1bgvIuKa6ALORZUxGHVYxWYHtxV3+TwRgKMf4eC9eecIk5tpNpVb74BONmoo=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786112319; c=relaxed/simple;
	bh=xQuwE/MAnkcPhAl1xnNy+xdjjQRvVgNAORp7hRl0fbo=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=sz7Z4hC3pBsMybdIVB2tE7/71zs+9wk5rjbJP58R+bDRjcSiD7HFMHJHzhkKYA71k5Is/WAIMXCCSOi8ruxI9u+44EiQhShWt98Pq9X4F5hJZS1qZOhfYqMDDWFn4nHL62MZcMi95ugTb4yhrHaeHeRp5DYt5/N9DRdABx4kqbE=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=ADJu0WU4; arc=pass smtp.client-ip=209.85.210.41
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="ADJu0WU4"
Received: by mail-ot1-f41.google.com with SMTP id 46e09a7af769-7e9ecd7216cso2006880a34.3
        for <syzbot@lists.linux.dev>; Fri, 07 Aug 2026 07:18:37 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1786112317; cv=none;
        d=google.com; s=arc-20260327;
        b=H7wh2mEfnRUAEVkq8t22BnjwIEFgy1igkTIfLmvmAQRqS/JgJ5Zu9vySNE0sdyd4NL
         mdgiFqzYo9x2KecxozhkZTZYUfht2xsGtN7yxFcusJz5zzA1idpyPfxunoYF7WEwYJ/N
         MTeO7XgFa4y29EOZIABl2OEkWYAmeZhN2mHjx173IhW7g1DLz6QkoVMzs9O9I/gE2Da0
         CPS5ldK1zia54C54XtL3XyAr63bNkS3pUptP42lFWMd+fe+rdpUWXMvMr7OUUoLqAnkb
         d7JI9EEQ8WF+n9MCYK2wxnHh/X6MwHj74Pv/cGGH/mSfELVfSJF084wfwuAxEWsAo6En
         2Q1Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=mzs4z8L+wfJloOnGXsZCdQZ4DprTclm6OHqI46jCAx4=;
        fh=h7qNZNGPtReuOEjwnhi9y0k1oLKCCipwXP7Mh+30wdc=;
        b=IM14azJZS9N+v6/OJAFKewCdweHaRM6XCzkwJQO1ETguar1lPjOhqU2ihcpcS61GsF
         gnxmfMzW+2qg6e7Ooo2IfF3zU8uh1nerjDAl505Q7Eo3WlQ58Tvcg5exQJEKkunUU06r
         EsGbOB6j7mlvnHmG7m0p/0lmoKqpFrZXp2kzRyDvWR382sTqPVZnuY1WfZZ0FatPfbhO
         6qZVrg8ajSKg7eCnQhzf64PG9XWg+fbv+SzY39ON4fmfJ2V0cgTC3ARGRzDmRuOsdwTi
         AP8LjGFqhyiCjKShX/oIsq8Y5TOPzqToA8Nsx/++DWoJ81ZauJedmb43vqWEWXRAQy4h
         qd5A==;
        darn=lists.linux.dev
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1786112317; x=1786717117; darn=lists.linux.dev;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=mzs4z8L+wfJloOnGXsZCdQZ4DprTclm6OHqI46jCAx4=;
        b=ADJu0WU4Nhi3pe9eXguLEYqgjOPrPpHLMgzZGILMySwE9emmeMIEO5c4nSK56kxzq6
         Yb8Zm1fE8+T+kt5LcWrCczyi3jLvfXdEpgbKeN8ud8/Vy1YaXD5/D+gAPyVbrFzzS/WR
         YfjQe01DcmCs6erHdOQvmW12OqYEHLQOm856fj+jrtiy2w8ufy23mRx9m0k8VC9CSX57
         KR+5SDFvelnw2+QayiVGVarxs9Fqrdwt1p6NgplKLR9mPb0ct8w0Y8si34Eb254CNq7E
         tTZVIPAKv81KPpr5fbOX+WAOqNnZPoDm9T+Kq724262uwVhfFXEvlphegLedRI0iETbZ
         LqZg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1786112317; x=1786717117;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=mzs4z8L+wfJloOnGXsZCdQZ4DprTclm6OHqI46jCAx4=;
        b=iH1I3Xg/g8fHSPaPTGSDr46SMtEK+zlD7Zghm+TLESUoRsFVrD+MNgKXWabhewSdhi
         d64q+3x74Hh/X+rIkD/Fl1fvpwwsHui/DD8d5M6hryQ30Lh4yQ3CpjdF266duYmnj3bB
         +Ypx6CQjxHdZTgQ7+5pVR/4rGiXqXU5hhCBsgafVg0nf0MJQt8rxcPaR/zQXsezcKzFT
         sHOSyijdMKOVcwlUkRNlO3Y7s1WeXq0pjLHBwkb85EttpCaLWrtpGV7IJxdE1dkKje+D
         5P2MFNPRc8WQ6lzIdfcpJnfDHifUI2gvywIfwicN0X15vrC51YsCt0ovnOsif5mEOniS
         ZzvA==
X-Forwarded-Encrypted: i=1; AHgh+RoqOgxoEEddM2TCm+XQKmQSOwKBLId0um3ToQ/zKBKdVh5uHwIFjYsaKyDooW2VPNtutpg8bX0=@lists.linux.dev
X-Gm-Message-State: AOJu0Yzmz5gpcNbpDzAcIIzMoUEfo2zEavbI68MP7zVfe564acc8RBPF
	bOLWtPnmq05li9BCRkevLXaxyAe0ArmyyioB3N4cUnXgUDrp/2+CGvPzE6zItXZmxnbw6Bi6XWP
	0rp+C28QKz881HZIXWeOBY5hBf6c5cfsa6+N+Bo5k
X-Gm-Gg: AR+sD12SkH70ayt9sdtD+6/obsolHv59NowjkwY2jm+p+gB0jretxmRbk4GWVWsTKhI
	vTh5bBZTQB5zNEnPewSgk0eL8RnRDrEmC9yFkWHhuzSS6f1guemJvGRUFfQ88B9yuF1f/1rhuzA
	XFEUZp5oXzKBgxDIvop8c1VrzSc+Bd5x7MSfKLpRnObNRYeRTLW2Ed5Me+b/yyOTxpoWsyN07MK
	P6gox78il1MR0Nvqqva2DeYrUDfqjJeKRPIsdVJ0f5BZX3b+1gTPwrmhtedkCM6xd9lUwzBQFsz
	/Vdn9yQgyohZoYs47uj83EHID8Jv9nTmlM3XpCWK8CVVvPSzr9veJRv49fIR6I1KgmRhOsCc5I2
	OQe4Hh/6BidWIx0UlMhjDZJcbJekLTpNyCOXiluGMG9Gsn5VK9JPtXSvYMm0Ddgh4P6oYWx77m4
	kiYxIiA63RjaWK
X-Received: by 2002:a05:6808:344b:b0:497:dedc:605c with SMTP id
 5614622812f47-4b1ab77a7a9mr287484b6e.7.1786112316084; Fri, 07 Aug 2026
 07:18:36 -0700 (PDT)
Precedence: bulk
X-Mailing-List: syzbot@lists.linux.dev
List-Id: <syzbot.lists.linux.dev>
List-Subscribe: <mailto:syzbot+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:syzbot+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <ee9bc932-2fbf-4e8f-90e2-6cf604be9ff1@mail.kernel.org> <b47d2b37-0aba-46cc-afaf-cf824d99524e@linuxfoundation.org>
In-Reply-To: <b47d2b37-0aba-46cc-afaf-cf824d99524e@linuxfoundation.org>
From: Aleksandr Nogikh <nogikh@google.com>
Date: Fri, 7 Aug 2026 16:18:24 +0200
X-Gm-Features: AUfX_my4HtjtCrRtKzHWyUtzFni5hkI-iqkp7piQNUPiq_LTV40Dav2LnTa-Mwc
Message-ID: <CANp29Y51K1Y0Z77oUEQmDpVPjJuz3fQhvvZp2=fw3GWSPiCg3w@mail.gmail.com>
Subject: Re: [PATCH] usbip: fix use-after-free in event_handler()
To: Shuah Khan <skhan@linuxfoundation.org>
Cc: syzbot <syzbot@kernel.org>, syzkaller-bugs@googlegroups.com, 
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>, linux-usb@vger.kernel.org, 
	Shuah Khan <shuah@kernel.org>, Valentina Manea <valentina.manea.m@gmail.com>, 
	Nobuo Iwata <nobuo.iwata@fujixerox.co.jp>, i@zenithal.me, linux-kernel@vger.kernel.org, 
	syzbot@lists.linux.dev
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Hi Shuah,

Thanks for reviewing the patch!

On Tue, Aug 4, 2026 at 7:31=E2=80=AFPM Shuah Khan <skhan@linuxfoundation.or=
g> wrote:
>
> On 8/3/26 09:05, syzbot wrote:
> > From: Aleksandr Nogikh <nogikh@google.com>
> >
> > The event_handler function in drivers/usb/usbip/usbip_event.c is a
> > workqueue item responsible for processing events for a struct usbip_dev=
ice.
> > During device teardown, usbip_stop_eh() is called to wait for the event
> > handler to finish processing. However, usbip_stop_eh() uses
> > wait_event_interruptible() and ignores its return value. If the process
> > unbinding the driver receives a signal, wait_event_interruptible() retu=
rns
> > immediately, causing the teardown process to falsely assume the event
> > handler has finished.
>
> Does this mean unbinding didn't happen?

The unbinding did happen (and finished freeing the memory), but
without actually waiting for event_handler() in
drivers/usb/usbip/usbip_event.c to finish processing the removal
event. As the device memory was prematurely freed, we got the
use-after-free crash in event_handler().

For reference, here's a C reproducer for the original bug:
https://syzkaller.appspot.com/text?tag=3DReproC&x=3D16ffb7b9580000
It sets up a timer to deliver a signal and wakes up the
wait_event_interruptible() call.

>
> The teardown process then proceeds to free the
> > usbip_device memory. Meanwhile, the event_handler workqueue is still
> > running and attempts to access the freed usbip_device, resulting in a K=
ASAN
> > slab-use-after-free crash.
> >
> > BUG: KASAN: slab-use-after-free in __mutex_lock_common
> > kernel/locking/rtmutex_api.c:559 [inline]
> > BUG: KASAN: slab-use-after-free in mutex_lock_nested+0x5a/0x1d0
> > kernel/locking/rtmutex_api.c:578
> > Read of size 1 at addr ffff8881145245b0 by task kworker/u8:5/6177
> >
> > Call Trace:
> >   <TASK>
> >   lock_acquire+0x84/0x350 kernel/locking/lockdep.c:5842
> >   __mutex_lock_common kernel/locking/rtmutex_api.c:559 [inline]
> >   mutex_lock_nested+0x5a/0x1d0 kernel/locking/rtmutex_api.c:578
> >   event_handler+0x1e3/0x4a0 drivers/usb/usbip/usbip_event.c:73
> >   process_one_work kernel/workqueue.c:3322 [inline]
> >   process_scheduled_works+0xa8e/0x14e0 kernel/workqueue.c:3405
> >   worker_thread+0xa47/0xfb0 kernel/workqueue.c:3486
> >   kthread+0x388/0x470 kernel/kthread.c:436
> >   ret_from_fork+0x514/0xb70 arch/x86/kernel/process.c:158
> >   ret_from_fork_asm+0x1a/0x30 arch/x86/entry/entry_64.S:245
> >   </TASK>
> >
> > To fix this, change wait_event_interruptible() to wait_event() in
> > usbip_stop_eh(). This ensures that the teardown process strictly waits =
for
> > the event handler to finish its execution and drop all references to th=
e
> > usbip_device before the memory is freed, preventing the use-after-free.
> > This change is safe from deadlocks because usbip_stop_eh() is never cal=
led
> > with locks held that the event_handler would need to acquire.
>
> Correct - usbip_stop_eh() is called without lock hold after updating
> the shutdown_busid status to true. However I am curious what happens
> to the unbinding? Should usbip_stop_eh() check the return value of
> wait_event_interruptible() and handle the error instead?

During unbinding, we must wait for the scheduled removal event to
finish before we can safely free the device structures. From what I
see in the code, once we have reached wait_event_interruptible(),
there's no way to abort the process or somehow gracefully handle the
error.

--=20
Aleksandr

>
> thanks,
> -- Shuah
