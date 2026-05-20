Received: from mail-qv1-f42.google.com (mail-qv1-f42.google.com [209.85.219.42])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 27DF23D565B
	for <syzbot@lists.linux.dev>; Wed, 20 May 2026 10:07:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.219.42
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779271639; cv=pass; b=RGAMzl+B0zWTQPfHN9K1oUAIXSvDBPnE/XBqJxJ3G3v0Uxc1vO3OOeCx3vnFyDVTSNW0snKMdoIPVd8xi5vwXwtuN6vm5R22geDv15DyVIbqYizjAFP6s7g9om/7GaHwxFM2dTVsN9wnrLAvd1J6JBvhspiHdL+2JSFKiwJQ744=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779271639; c=relaxed/simple;
	bh=wzPGKegknZNLYvAVntT0wDJh+jazgHIq/Ia0HRG92wA=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=pr5PtTyz8v9HWdfmU27+CfNgPNaNax8MaEGsELyDO2hdNA2huyqNgYaOUd2NPH9wPozknWepzOUecmKP5WImZ7DbFaJ/owbWkb0rlqiOddkiot2ZFjWrVKJtJztt8tekbZ2Ch/sRZx6nPmAOrfiAd3v5avf3CYi32Zl42ex8/34=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=AESv29fZ; arc=pass smtp.client-ip=209.85.219.42
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="AESv29fZ"
Received: by mail-qv1-f42.google.com with SMTP id 6a1803df08f44-8b59772d441so60335826d6.0
        for <syzbot@lists.linux.dev>; Wed, 20 May 2026 03:07:14 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1779271631; cv=none;
        d=google.com; s=arc-20240605;
        b=ISlUkKURBRx8U2YwcPN8TASyOiZqLozKZ3Yde0E7Sd64EahpzpCo0iPIcMu755F3Um
         oXSYavFQZLDMNpaAds64koODROv8i+tcbdVNPr1TH7sk8iSyYRRL2FU2RPzWWdVwje+v
         0i4/u1vg4M1qn5Z2XB7RxNNBkLrXvpTNIWe4YidHe8wy/rSudRLh6tZPsMEC+FFLboct
         03FLKU1OkhZZTQ/S6IGqUL4GJnDfpqGhChOWvkr1fRKzcShRsb6gykedWLoscGb++sV/
         /6Uq+3d1Xd/7hgnVJozUs8yvzpvkpsYext00M+FX9exmFPFsXalEuEWH6wbTbGvKUfqo
         9Z0Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=YIgMtDDlILtc1pHNz/7G6VSQuPe0B3MpkOvK4clDa+k=;
        fh=xR7QHSpruoE6BCMDK900HNNRYGdNgWcesdd+lPVLkJk=;
        b=lVBjkLhJSFIuhYEcXiy4FDjnldKSVj6URMdjLJ3IDx9iMojLihS+aSQjHD4WDx6yXc
         fGFhsIY42lWB8icjIV+c4ygt5k4EaKnPWIlgy6sfKmeo56N0loapZlfzMU29gP0CFkYP
         mss9Ldw9padCoCHvPQ2IVO8Vh7UoNjO2OQYdQSPQLicARE9IYtfBo3TAyeBvd9rusEqJ
         OGWY7SP0fuNVaCG+s+2PW4d1rdWTV2qQeLo+eTg1sKFY9t+6pzv/F5pypX2lZKcbdCD3
         uKroRyfSmn3QZW7IRelC7zPYPM0iCFOBaXZ1IqBeh2RiZGbQoI8ImQrY3Npi2esOKwyW
         uJIA==;
        darn=lists.linux.dev
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1779271631; x=1779876431; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=YIgMtDDlILtc1pHNz/7G6VSQuPe0B3MpkOvK4clDa+k=;
        b=AESv29fZmFLSeRGCL0B4zSF5R4Azm+PfHaURCgQY56F4Rz17TjiaHKry1MvvH9yxJ+
         Bw2Srb2J/b3yOhqNbRuEz4ukbTm8uNWhCTGV7CZClUN2h30kahZ2szG5jjo/rMUMOSNj
         ePEovZK74/4AhYiFyUXYmMhJ+yFTUH3gvhrtoOfMKYjK53J+11x5/8ZvMW2GAdwJI4eZ
         4FdeU0NIFJHvY4xVNq0IrA8M3tHHwdgI+MlmsHFJpIZrsp/FXe91CzxDlZjFSsfKAt+s
         A2Z/gpCY7/J5kSphVZgXSuYpgBEc7gvg0Ib6JBosB+ZUq+26brsXooH57F8xo/ILJV7a
         CiEQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1779271631; x=1779876431;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=YIgMtDDlILtc1pHNz/7G6VSQuPe0B3MpkOvK4clDa+k=;
        b=Ld1of7XlNIoOrdPt+fo6TXzOC0nwiv7Dv3udgV7nEYaDz8AYsb9RT56DOliRrFBWyv
         LdE1+K21GJKMdaGWe5LNONHgOj4WqCBoTnulIo7p2VoPvVGF3/IR7gIF0ftLC6YiYS57
         KLYaq9WTXcKvBrvgxZOC+7yGmKwAtTfBUjgCCwSRw8X3cjsvlPXN8PhsjSgiq8EI34Eo
         hzVhW/mAloI+ELhG0PeVcWhwlFEv8jDFV2V5xH8IDB4Qq9GYZvJy92kfDZPqK2Mrv5Mx
         j1xu8uTEGdQL5oK9w/vGJS9xekw4/5dioizBp+1brXdnwc0Dzb4pasH/KXwTCoN7hmeu
         Lk8g==
X-Forwarded-Encrypted: i=1; AFNElJ805wI9hdHAB+iV+t+WgJTkShYDKcyXcXHDUqUcv/NxgIbEwN4V1okTiaeWyk8Ic3KwbuH8Puw=@lists.linux.dev
X-Gm-Message-State: AOJu0YxtRABuGSNF/6Ql96zWuVnCPJNMsu1gElxx0ty/F8Tc7QujjCeh
	uEdZPx6l/Gd7ogRtwq0OCL6dul6MCpNmmk/hHQL4akxzTEAqfkfKXqUReL/sZY+zXqcqQvgKowY
	lY2s9A8OtVw/nSti1kJeDuOG+H39IiG6wrPN+F/V1
X-Gm-Gg: Acq92OECfvYYTTtEQX4c5iOmUoj5eSIvJVRNCd1aOqtJ4xg5eW8qbQHHFFUnX5sChis
	FPzJpt1/wygwOIGUXbVk0clMTigI9NUtp33iqgyVWI+iVnneYILM33E2KH4igtw6RspoRq8UjlE
	W2TXHVKzpksA6k4BUWYO2CM8sQF/w5o/zhjiAegBge6ZwbXRkUzscsR/KeFqvPAxa8oo2/UBJK7
	576yKykFuJRxYb3HZnV1hn4R9LxQzw/oMYvsOljF2icDO5scovF7mHMiCgWykpwb4wWobKvAKax
	Esa/ii906cEhriHPcK3o5E7WXZhHAqbWWCp0ClkBJ/w9SBBU
X-Received: by 2002:a05:6214:5889:b0:89e:bae9:9d56 with SMTP id
 6a1803df08f44-8ca0f70f638mr438962656d6.45.1779271631070; Wed, 20 May 2026
 03:07:11 -0700 (PDT)
Precedence: bulk
X-Mailing-List: syzbot@lists.linux.dev
List-Id: <syzbot.lists.linux.dev>
List-Subscribe: <mailto:syzbot+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:syzbot+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <07235ee0-41fb-43e2-8391-d1e398576250@mail.kernel.org>
In-Reply-To: <07235ee0-41fb-43e2-8391-d1e398576250@mail.kernel.org>
From: Alexander Potapenko <glider@google.com>
Date: Wed, 20 May 2026 12:06:33 +0200
X-Gm-Features: AVHnY4L0pvt8OYi2oiMJNl_mpf9aaxtqVDWpzNmmSa2RxZbTfLC-vW2NuPwVpm4
Message-ID: <CAG_fn=UED2NHO0qiRjKcKu2Dp+XZ8jPbOJcftHeZnvD1FRHZjg@mail.gmail.com>
Subject: Re: [PATCH RFC] net/sched: fix watchdog timer teardown race
To: syzbot <syzbot@kernel.org>
Cc: syzkaller-upstream-moderation@googlegroups.com, syzbot@lists.linux.dev, 
	Dmitry Vyukov <dvyukov@google.com>, Aleksandr Nogikh <nogikh@google.com>, Marco Elver <elver@google.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Wed, May 13, 2026 at 11:16=E2=80=AFPM 'syzbot' via
syzkaller-upstream-moderation
<syzkaller-upstream-moderation@googlegroups.com> wrote:
>
> A race condition exists between network device unregistration and
> concurrent link state change events (e.g., usbnet_deferred_kevent).
> During device unregistration, __dev_close_many() clears
> __LINK_STATE_START and calls netdev_watchdog_down() to delete the
> watchdog timer. However, a concurrent link state change can call
> netif_carrier_on(), which checks netif_running(dev). If this check
> happens before __LINK_STATE_START is cleared, it proceeds to call
> netdev_watchdog_up(). If netdev_watchdog_up() is delayed and executes
> after netdev_watchdog_down() has deleted the timer, it will re-arm the
> timer. This leaves the timer armed during the final teardown phase,
> eventually triggering the WARN_ON(timer_pending(&dev->watchdog_timer))
> in dev_shutdown().
>
> Attempting to fix this by adding a lock-free double-check in
> netdev_watchdog_up() introduces a subtle refcount underflow bug.
> Instead, the most robust approach is to ensure the timer is completely
> dead during the final teardown phase. Since dev_shutdown() is called
> from process context under the rtnl_lock(), it is safe to sleep and
> block. We can use timer_delete_sync() in dev_shutdown() to deactivate
> the timer and wait for any concurrently running callbacks to finish. If
> the timer was left armed, timer_delete_sync() returns 1, allowing us to
> safely call netdev_put() to balance the refcount. This guarantees that
> the timer is definitively dead before the WARN_ON check.
>
> Fixes: d7811e623dd4be3e3bdba2d6330f7f15541ee45f ("[NET]: Drop tx lock in =
dev_watchdog_up")
> Assisted-by: Gemini:gemini-3.1-pro-preview Gemini:gemini-3-flash-preview
> Reported-by: syzbot+c9ecf60a8adb7629821e@syzkaller.appspotmail.com
> Link: https://syzkaller.appspot.com/bug?extid=3Dc9ecf60a8adb7629821e
> Link: https://syzkaller.appspot.com/ai_job?id=3D2f0da36f-92ca-4f82-a3f9-9=
2648d57a2ae
> To: <davem@davemloft.net>
> To: <edumazet@google.com>
> To: <jhs@mojatatu.com>
> To: <jiri@resnulli.us>
> To: <kuba@kernel.org>
> To: <netdev@vger.kernel.org>
> To: <pabeni@redhat.com>
> Cc: <horms@kernel.org>
> Cc: <linux-kernel@vger.kernel.org>
>
> ---
> diff --git a/net/sched/sch_generic.c b/net/sched/sch_generic.c
> index a93321db8..e4e72077b 100644
> --- a/net/sched/sch_generic.c
> +++ b/net/sched/sch_generic.c
> @@ -1493,6 +1493,8 @@ void dev_shutdown(struct net_device *dev)
>         qdisc_put(rtnl_dereference(dev->qdisc));
>         rcu_assign_pointer(dev->qdisc, &noop_qdisc);
>
> +       if (timer_delete_sync(&dev->watchdog_timer))
> +               netdev_put(dev, &dev->watchdog_dev_tracker);
>         WARN_ON(timer_pending(&dev->watchdog_timer));

Now that we deleted `watchdog_timer`, timer_pending() cannot possibly
be true, right? Do we still need this warning?
