Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=209.85.161.47
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1793567610;
	b=LUcGT0HtWu5OPYLCPKPJXW4WO0A+WTtOfZclpyvYYJm8TLcrp8VY/GljSsG1fQ0Jdw/8
	 OpsC9QJB7fbE1FFmrFRXqs6taktGqgvWpPHuALa50U6MjcgOvgepnAvXEAccDp53gKfqk
	 X9A3GIVggUpAEcwcSEEvXaPXnKQ+YQjEKxRpgNvZveQq1PteVWeWYIEzcv04+y3gFCfVd
	 pARSCQMvO9Qro9P3RVKpEz3+LnRIsd249Fz3C3lKYiwqHkewW38Hn2EMABadwvqN+d/Ws
	 5ipT58Pz7OJUYt0rq6JqTbIC3CYDwiwNoPoKE+DuX+rs5j6MruRS1fDBBz/eOe1Nulg==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793567610;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:
	 MIME-Version:References:In-Reply-To:From:Date:X-Gm-Features:
	 Message-ID:Subject:To:Cc:Content-Type:Content-Transfer-Encoding;
	bh=syUO8mWxxZvibP3RrEenC4XHyDrhPNBONGUjUu3alHU=;
	b=EK8iAQFgVSrTL5bVNoFfzawDbYfYBcMI9X9buy5omnf0nrZR+oz+lO9SyOuBPtpDW67U
	 d1jKStHsTs2rY0ZejRK3m6vo8J+BkqCwTL77D2+I6OVYbfqD3IopBMbOJgqlmPhxZf54c
	 JSmQ6flJli3CfVGSDzqAiWJegsmO0QTppSAZu5br5tZMoY4vBF6RfRBm7gVKmq+CldTZ9
	 QWRKpKrlG1W7d/3ZFZvlfBY9+w+pXE8R/5MZIXBga7EsqV4SzAO4Ojt7qa6yLgy2E7zQY
	 SD7MR2iioN0EAomK/6ghfaYCmedR20d2IL4FB/a0nC3NGQACFKJRVzd/FRpEB8RIcog==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=google.com;
	spf=pass smtp.mailfrom=google.com;
	dkim=pass header.d=google.com header.i=@google.com header.a=rsa-sha256 header.s=20260707 header.b="fT/8FrKz";
	arc=pass header.oldest-pass=0 smtp.remote-ip=209.85.161.47
Received: from mail-oo1-f47.google.com (mail-oo1-f47.google.com [209.85.161.47])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2FAB2606A324
	for <syzbot@lists.linux.dev>; Sun,  1 Nov 2026 21:13:29 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 2FAB2606A324
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=google.com header.i=@google.com header.a=rsa-sha256 header.s=20260707 header.b=fT/8FrKz
Received: by mail-oo1-f47.google.com with SMTP id 006d021491bc7-6faddda49e7so2024621eaf.3
        for <syzbot@lists.linux.dev>; Sun, 01 Nov 2026 13:13:29 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1793567609; cv=none;
        d=google.com; s=arc-20260327;
        b=VpjdCXorxk1LKl90cj8FCaA9EesHlb77m8Dib02LLdEP8EPkiqCdzFibN2CKYgMM+x
         +dRHL7WzzZWcM8bIeHSicv9n2Wf3kHecROtMsB88N7eNaDjAc8oF0fTdGY/jIedswygJ
         kZ4fLKuD2QrSmlqzjeZ7zkYuiTKSVFjdc58EIHbexeMugTD7HCUy/7oZWImfJNIz9FFE
         JcC/lq/roBIcI88WW82OJrC+QJZGTVv7u1pWHmTgHw5q+Gt5jDv7ivz07iC8Pbu2s8P9
         O9DWUizvJJ4+VVvVATk9VixREmMdEc1zZXqVowtMWaYPZpqNKXK/hNlbNe5vycOMoyk5
         FPBA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=syUO8mWxxZvibP3RrEenC4XHyDrhPNBONGUjUu3alHU=;
        fh=pI2j5XCNLoTMJslnRj3GPk/fEwD9C8f1OhuJdyAcrNA=;
        b=omjfsxx369ZRVa8drOf8SOzwVzluFeMVKZa0h23NaH7JRS0SJCX0eO/IVTFxH+9TiN
         HJ5vQpF7TN8SgypxxwLQhX8ryeFCj4sqG+ayAKzEbEF2N6ygTD0X9Mf8pRJfuQDnRJQN
         Dw7/jEKA99NBhx9xWnke+IAaq8gifRTTqzaXKGtyePzkFpVeCAIBLzoQhetnHZQeDok8
         QMDU+XrBbsBMbEInBESNeon0M56HbO72isitLTtFKE1s99TJpXAcPdPjZy14pr/0jVE9
         DFgi9jRaKAHe43/udvLpg7mYTXHRMYTUSpQMq5P6PYoWUxrUgEKkGIcs69t2Ezctk5Pk
         2VOA==;
        darn=lists.linux.dev
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20260707; t=1793567609; x=1794172409; darn=lists.linux.dev;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=syUO8mWxxZvibP3RrEenC4XHyDrhPNBONGUjUu3alHU=;
        b=fT/8FrKzsKRoAkPp6hXv8HEufMpNJnF/wumu8dQHdNszsb8dj7otIkAIqatTqZiYzj
         OZMdyvtLQ9Bv8qcCkiEaR48ihCijiiW6auT0qvCbtZzd76z8PNPAF5NIeiHHLj2QeTjI
         zY0hpCQpjtmHMMPvTJvkibWNbhNMr/qZqt9jJ7rtJU5apJNosobRydxGUZBz3zZR99DS
         ZcvSw+MoN0Oy6+Ti3CGKLMbo+mul7N045E4qGxQkpfMBy38gCFLCEAw7p18Hoeik3xfx
         NLjiDK6v512mA6lJnByOAQwK8EVCslPax+wh+ZgxgPknpvKGHqYuHZaKkf8z1+hF325K
         izHQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793567609; x=1794172409;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=syUO8mWxxZvibP3RrEenC4XHyDrhPNBONGUjUu3alHU=;
        b=kT2GKre1ttFvEwgXoeo0vBO/2p09pKnOfHTPlscpeqk1H4DSWESqiFiZVPMlcKnNlP
         UUH59uK9tJ7zSlRcUniwtzSF+2WyDSOzwVRNIpBtqRar1USK7eGSwHXVf+XE/WkHlQOx
         0wYUhTLbvXpOIrVrknTEldwuwBOnKZMo8eEmsG8S26vCLPGBsr/XGMn0r6AnoYvzF8ct
         sQNmp4J71t+TkoJ93x5yugy+dvyj9Gtg6uGfM+1YDi8GcuqSYTOX/DYXYVFkgjL99Lap
         k6BGiPPtAK3U0v1e4GwdQ0dDDA6hFtC6V9mL7mjZ6syctNH/7iiyLKJa9yo3uWqoeBGQ
         VSjg==
X-Forwarded-Encrypted: i=1; AKwUvByi3Bi4FJa1sC8NRb1Zz9a1zqb0fedXtzHel0kMfpQYCGl7Q0ajZD71wt1gOoZJFhR0xjybVxY=@lists.linux.dev
X-Gm-Message-State: AFq9FYICIoA8telfv51Dx4hhc8Aov+xAHIorSx/w9J6+tCFlpdv1juMG
	khVwVVz0jZ3iUaFVjbRe+naxMTEyJEKax4jOakXKI3magZJDH2/E+t9C6BP1HyMFmoefQhCl5WV
	ubijC/5T7iha8eIEss53otWxXjS7CkNLJF6upquvg
X-Gm-Gg: AYBFou2VpbEzhcHKB+UDVn8ANp2rrxlbgpwHQf8TjobWJKsaf5MgxB4M6KZFM7BQETa
	dcoa2gfnbe/eNaq3bcEMtvoyn20QlFxmZB6JI4JSETvVdhI8ZYFyDkm+aP6ALL2M0TZnIGWUwT3
	gJulM/atSYJepLOpTYvBrMpJvZrTcmREIENmSWD9y0B4PBWqwkWMEJhyZAtBHZ+aHecZmdnPDSs
	a5yyTFOQuVNJt/xuy6Z4qAfzUUmfhpi1tmHvF75jbpTsDiw+KO1Sda0P5fvbHR4A6Mg0QS79KIQ
	lIYpKbU7sT3kb2GivoY8zjjFJRFy6Fn/TYwNZ6B1GOqMbIvr/W4Z5fx3pDz0miY4fU8BIBvBRcz
	+Mut1GU5RYP+HIsT+dU+xz/XYqjvy2DxLUUtcychjUBsf3AGU3aExbMbDX8Ety/8mqlmuC3Noop
	DnSTQ5LtPQ1wnBNiQUbGnimb2PCfCYaQT7/DNlXpxufshKIEffxBU9p4ggdlzqbyn2A5rHM+IrB
	hgjlgIezA==
X-Received: by 2002:a05:6820:2206:b0:6d8:93d:3772 with SMTP id
 006d021491bc7-714f2a641bdmr4393946eaf.89.1793567608508; Sun, 01 Nov 2026
 13:13:28 -0800 (PST)
X-Mailing-List: syzbot@lists.linux.dev
List-Id: <syzbot.lists.linux.dev>
List-Post: <mailto:syzbot@lists.linux.dev>
List-Help: <mailto:syzbot+help@lists.linux.dev>
List-Subscribe: <mailto:syzbot+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:syzbot+unsubscribe@lists.linux.dev>
List-Owner: <mailto:syzbot+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
References: <6ae76acb.7fe51036.1ecf7.002b.GAE@google.com>
In-Reply-To: <6ae76acb.7fe51036.1ecf7.002b.GAE@google.com>
From: Aleksandr Nogikh <nogikh@google.com>
Date: Sun, 1 Nov 2026 22:13:15 +0100
X-Gm-Features: AclHuK_051JGVXMnsMmNNXUFe1oKFCU2rtH6Z4i4e4LVTyvJQE9D2TEd_ScedZ8
Message-ID: <CANp29Y581kzYGRnGKdsMWcrX0SKFiDQWMeKRUEvnug2OVPndjg@mail.gmail.com>
Subject: Re: [moderation/CI] Re: media: em28xx: fix v4l2 use-after-free after
 failed init
To: syzbot ci <syzbot+ciedcd9b7e9104cbc7@syzkaller.appspotmail.com>
Cc: syzkaller-upstream-moderation@googlegroups.com, syzbot@lists.linux.dev
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

#syz upstream

On Sun, Nov 1, 2026 at 5:37=E2=80=AFPM syzbot ci
<syzbot+ciedcd9b7e9104cbc7@syzkaller.appspotmail.com> wrote:
>
> syzbot ci has tested the following series
>
> [v1] media: em28xx: fix v4l2 use-after-free after failed init
> https://lore.kernel.org/all/20261031204723.1415-1-drifabdelmalekmohamedsa=
id@gmail.com
> * [PATCH] media: em28xx: fix v4l2 use-after-free after failed init
>
> and found the following issue:
> possible deadlock in em28xx_release_resources
>
> Full report is available here:
> https://ci.syzbot.org/series/92e27f7a-9ca9-4693-ad76-730262f6efd0
>
> ***
>
> possible deadlock in em28xx_release_resources
>
> tree:      torvalds
> URL:       https://kernel.googlesource.com/pub/scm/linux/kernel/git/torva=
lds/linux
> base:      cbbddb6b08cc9900a87cccaa9b22bbe06aa4f50a
> arch:      amd64
> compiler:  Debian clang version 22.1.8 (1~deb13u4), Debian LLD 22.1.8
> config:    https://ci.syzbot.org/builds/5e867cfe-3c44-46f3-be9a-3394e1031=
2c7/config
> syz repro: https://ci.syzbot.org/findings/de514af7-755a-455f-9075-91732cf=
09a76/syz_repro
>
> em28xx 1-1:1.0: Closing video extension
> em28xx 1-1:1.0: Closing input extension
> =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
> WARNING: possible recursive locking detected
> syzkaller #0 Not tainted
> --------------------------------------------
> kworker/0:3/5059 is trying to acquire lock:
> ffff88801cd25cf0 (&dev->lock#3){+.+.}-{4:4}, at: em28xx_release_resources=
+0x75/0x240 drivers/media/usb/em28xx/em28xx-cards.c:3796
>
> but task is already holding lock:
> ffff88801cd25cf0 (&dev->lock#3){+.+.}-{4:4}, at: em28xx_v4l2_fini+0xb7/0x=
3f0 drivers/media/usb/em28xx/em28xx-video.c:2431
>
> other info that might help us debug this:
>  Possible unsafe locking scenario:
>
>        CPU0
>        ----
>   lock(&dev->lock#3);
>   lock(&dev->lock#3);
>
>  *** DEADLOCK ***
>
>  May be due to missing lock nesting notation
>
> locks held by kworker/0:3/5059: 6, last CPU#0:
>  #0: ffff8881032cb948 ((wq_completion)usb_hub_wq){+.+.}-{0:0}, at: rcu_lo=
ck_acquire include/linux/rcupdate.h:309 [inline]
>  #0: ffff8881032cb948 ((wq_completion)usb_hub_wq){+.+.}-{0:0}, at: rcu_re=
ad_lock include/linux/rcupdate.h:849 [inline]
>  #0: ffff8881032cb948 ((wq_completion)usb_hub_wq){+.+.}-{0:0}, at: proces=
s_one_work kernel/workqueue.c:3460 [inline]
>  #0: ffff8881032cb948 ((wq_completion)usb_hub_wq){+.+.}-{0:0}, at: proces=
s_scheduled_works+0x97a/0x1630 kernel/workqueue.c:3578
>  #1: ffffc900036cfc40 ((work_completion)(&hub->events)){+.+.}-{0:0}, at: =
rcu_lock_acquire include/linux/rcupdate.h:309 [inline]
>  #1: ffffc900036cfc40 ((work_completion)(&hub->events)){+.+.}-{0:0}, at: =
rcu_read_lock include/linux/rcupdate.h:849 [inline]
>  #1: ffffc900036cfc40 ((work_completion)(&hub->events)){+.+.}-{0:0}, at: =
process_one_work kernel/workqueue.c:3460 [inline]
>  #1: ffffc900036cfc40 ((work_completion)(&hub->events)){+.+.}-{0:0}, at: =
process_scheduled_works+0x97a/0x1630 kernel/workqueue.c:3578
>  #2: ffff88816eeb71d8 (&dev->mutex){....}-{4:4}, at: device_lock include/=
linux/device.h:1109 [inline]
>  #2: ffff88816eeb71d8 (&dev->mutex){....}-{4:4}, at: hub_event+0x184/0x4d=
30 drivers/usb/core/hub.c:5917
>  #3: ffff88801cdfc1d8 (&dev->mutex){....}-{4:4}, at: device_lock include/=
linux/device.h:1109 [inline]
>  #3: ffff88801cdfc1d8 (&dev->mutex){....}-{4:4}, at: usb_disconnect+0xfc/=
0x9a0 drivers/usb/core/hub.c:2346
>  #4: ffff88801ce5a1a0 (&dev->mutex){....}-{4:4}, at: device_lock include/=
linux/device.h:1109 [inline]
>  #4: ffff88801ce5a1a0 (&dev->mutex){....}-{4:4}, at: __device_driver_lock=
 drivers/base/dd.c:1046 [inline]
>  #4: ffff88801ce5a1a0 (&dev->mutex){....}-{4:4}, at: device_release_drive=
r_internal+0xa9/0x7d0 drivers/base/dd.c:1377
>  #5: ffff88801cd25cf0 (&dev->lock#3){+.+.}-{4:4}, at: em28xx_v4l2_fini+0x=
b7/0x3f0 drivers/media/usb/em28xx/em28xx-video.c:2431
>
> stack backtrace:
> CPU: 0 UID: 0 PID: 5059 Comm: kworker/0:3 Not tainted syzkaller #0 PREEMP=
T(full)
> Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS 1.16.2-debian-1.=
16.2-1 04/01/2014
> Workqueue: usb_hub_wq hub_event
> Call Trace:
>  <TASK>
>  dump_stack_lvl+0xe8/0x150 lib/dump_stack.c:120
>  print_deadlock_bug+0x27a/0x290 kernel/locking/lockdep.c:3085
>  check_deadlock kernel/locking/lockdep.c:3137 [inline]
>  validate_chain kernel/locking/lockdep.c:3939 [inline]
>  __lock_acquire+0x25db/0x2de0 kernel/locking/lockdep.c:5288
>  lock_acquire+0x115/0x350 kernel/locking/lockdep.c:5942
>  __mutex_lock_common kernel/locking/mutex.c:646 [inline]
>  __mutex_lock+0x197/0x15a0 kernel/locking/mutex.c:821
>  em28xx_release_resources+0x75/0x240 drivers/media/usb/em28xx/em28xx-card=
s.c:3796
>  em28xx_usb_disconnect+0x19f/0x2f0 drivers/media/usb/em28xx/em28xx-cards.=
c:4493
>  usb_unbind_interface+0x295/0x9c0 drivers/usb/core/driver.c:460
>  device_remove drivers/base/dd.c:619 [inline]
>  __device_release_driver drivers/base/dd.c:1357 [inline]
>  device_release_driver_internal+0x48d/0x7d0 drivers/base/dd.c:1380
>  bus_remove_device+0x444/0x560 drivers/base/bus.c:678
>  device_del+0x524/0x8f0 drivers/base/core.c:3967
>  usb_disable_device+0x3d4/0x8d0 drivers/usb/core/message.c:1484
>  usb_disconnect+0x346/0x9a0 drivers/usb/core/hub.c:2355
>  hub_port_connect drivers/usb/core/hub.c:5425 [inline]
>  hub_port_connect_change drivers/usb/core/hub.c:5725 [inline]
>  port_event drivers/usb/core/hub.c:5889 [inline]
>  hub_event+0x1bbb/0x4d30 drivers/usb/core/hub.c:5971
>  process_one_work kernel/workqueue.c:3495 [inline]
>  process_scheduled_works+0xc3d/0x1630 kernel/workqueue.c:3578
>  worker_thread+0xa47/0xfb0 kernel/workqueue.c:3659
>  kthread+0x38b/0x480 kernel/kthread.c:436
>  ret_from_fork+0x514/0xb70 arch/x86/kernel/process.c:158
>  ret_from_fork_asm+0x1a/0x30 arch/x86/entry/entry_64.S:245
>  </TASK>
>
>
> ***
>
> If these findings have caused you to resend the series or submit a
> separate fix, please add the following tag to your commit message:
>   Tested-by: syzbot@syzkaller.appspotmail.com
>
> ---
> This report is generated by a bot. It may contain errors.
> syzbot ci engineers can be reached at syzkaller@googlegroups.com.
>
> To test a fix for this bug, please reply with `#syz test`
> (on a separate line) and attach the patch to the email.
>
> Notes:
> - The patch will be applied on top of the tested series (as an
>   incremental fix).
> - To test a new version of the whole series, please send it directly
>   to syzbot@lists.linux.dev.
> - Arguments like custom git repos and branches are not supported.
>
> The email will later be sent to:
> [drifabdelmalekmohamedsaid@gmail.com hverkuil@kernel.org linux-kernel@vge=
r.kernel.org linux-media@vger.kernel.org linux-usb@vger.kernel.org mchehab@=
kernel.org stable@vger.kernel.org syzbot@syzkaller.appspotmail.com]
>
> If the report looks fine to you, reply with:
> #syz upstream
>
> If the report is a false positive, reply with
> #syz invalid
>
> --
> You received this message because you are subscribed to the Google Groups=
 "syzkaller-upstream-moderation" group.
> To unsubscribe from this group and stop receiving emails from it, send an=
 email to syzkaller-upstream-moderation+unsubscribe@googlegroups.com.
> To view this discussion visit https://groups.google.com/d/msgid/syzkaller=
-upstream-moderation/6ae76acb.7fe51036.1ecf7.002b.GAE%40google.com.
