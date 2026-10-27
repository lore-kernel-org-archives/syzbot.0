Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=209.85.219.42
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1793089961;
	b=bG4V7WLJOa3cas3t9hfqenBJfDwfW8Qblv7L8n9rzk5bNVIg0GDTOseePXpHP/FV+Mea
	 eNINMVEfC2PO+ijVi/hNqI74OU5XUEYmI3PNG59QKsYIWdKSZ2VmCXBKay/dSzRcWbcPv
	 kWNDNpZGPA5Zj8qdKiPleApQBxXiMwsy9XC+LXcQ6+zsflKoz6z2vcpBDBbu963mWUV7g
	 GgwWu0yLjXrgk7IHJBEO9t3vjViI5P/bmKgLgJDyiGp5l7foLWdaPMxgMJ17dl2pvV1rE
	 A2ZH42DjJfk/cu15GTEMPfcfNFvts/3XOyMv9SSlYax5lk0duMClBmIgnXYA1NnDWDw==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793089961;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:
	 MIME-Version:References:In-Reply-To:From:Date:X-Gm-Features:
	 Message-ID:Subject:To:Cc:Content-Type:Content-Transfer-Encoding;
	bh=dAOLpWIzar1nhfyvh97D2hA4aDKN93kXnCVFpRFNnbw=;
	b=oTpgQWYS5pfmBAVFC0PLxUsubCl6TPzcZnwzztsjkvQNJsII9FpSKHIxlK58e8Q2Hatl
	 E1PZYbGRCqap8t+LVylhFNxhVYU+WZNjukuHjEIB99q128CZx/7WxKoBRZlexR0HQ2xNI
	 yyHO0rd59M7iXT839kbC5au7enwduXb541r5IyC7h9NFFpw1TuUkwvPxij4/gNHbLqxn4
	 Ky9jYxK334K1EY28aCWpZME70HMD0emY3ofgYwbQos05cIyo6OGIwmjKuFn1TykjwJ76F
	 0b1KMCJd1vZTlrOgLU0LhM9WFqgaBcot7+OykFhx4lCSXpt1TRYHCEbnKWzy2Ly7j3Q==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=google.com;
	spf=pass smtp.mailfrom=google.com;
	dkim=pass header.d=google.com header.i=@google.com header.a=rsa-sha256 header.s=20251104 header.b=nXCwaB1y;
	arc=pass header.oldest-pass=0 smtp.remote-ip=209.85.219.42
Received: from mail-qv1-f42.google.com (mail-qv1-f42.google.com [209.85.219.42])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2C64C606A31A
	for <syzbot@lists.linux.dev>; Tue, 27 Oct 2026 08:32:40 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 2C64C606A31A
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=google.com header.i=@google.com header.a=rsa-sha256 header.s=20251104 header.b=nXCwaB1y
Received: by mail-qv1-f42.google.com with SMTP id 6a1803df08f44-917a707f37eso39045806d6.0
        for <syzbot@lists.linux.dev>; Tue, 27 Oct 2026 01:32:40 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1793089960; cv=none;
        d=google.com; s=arc-20260327;
        b=irlOaAnMUfsQ1jd9xcuB+p1bFoeqFygomfvZPBE2qQzY7ZLL30t9uTKbTA2nLmKWCm
         AcVKDicGNnbwoKG9vFCt9mJIiXrsMPl5Ltfks3hM6xSpG1krJ4A/x1aM44cyoeSS0SWq
         c6LRfuI3AvzBF+9LclOkwKhLk14BMryX3hu40zUB++4UTAWbEXHcVOnYJfCAfn0pqWVI
         jAbh6QdtDwcMQbl1iLBspA1E5xrkQT5Eu5D3VLbZge0CDhXrPS9g4L5C56O6QBt/laTI
         FlDWCLP/Sdp58QY5Vqls/omil+/6AxK86duh2TuHqAaK39S+/L3+C4zQvOBdjveXmeZZ
         Ip5Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=dAOLpWIzar1nhfyvh97D2hA4aDKN93kXnCVFpRFNnbw=;
        fh=nXFmO6Wy3qDhdYqaheUqdRuhiSsCRkh2M/UiiUcoawQ=;
        b=oj5ue/zuRZrg3C7/7ReIGAx4Cj6zmvG1gQnnTxMRrGJrKNnDVz/JSd0q516p2uHqn5
         UwoC8AmBO5SKTHOcZ3cfHYP1yg9EMiULZVsc2Or2+DIppCR44n5S77iq6RH05H7GIaY+
         T+SvN6AjgaL/5rEpW/rLYhNDnI/PnK3olWhlerqZkxO9un05kD2mWMXHGk1d9ZBzFgt8
         ypXwrNvmCQcHmv2KX3pVJlkmHXXJ8j0hyhyJpQ16iEbfwW1EmiyOiHUAUl79erNQ6DeV
         JtSVH892gTsba5ezji9ouE9NgWfwQXzjzOACiI1Q4PJzX6MWwiQcKh0Nzw4nYgBpjLyS
         I5/A==;
        darn=lists.linux.dev
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1793089960; x=1793694760; darn=lists.linux.dev;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=dAOLpWIzar1nhfyvh97D2hA4aDKN93kXnCVFpRFNnbw=;
        b=nXCwaB1yeObnTGq27lv3dDJr3pEynHBfO45HbkHTK+q7WGr2kCLZHTWH5IdCuw6WaE
         h5cJh/7zFPzbxVTVki2VtR+hTqSIkqJYXszD/xfFEpaqwPbGpKwTS/lbYC4Bs4AJ1G18
         ODEHtuDyNOAIoW02DJtZEuw1XdoCmcsE8G8g5zWebdpg3zEZhpSppuNiKNfhYU9aY5yq
         BQu5MZsTmrytCWH34WeLD0gB6L/lNKSSzaJwrRNHxVbsIH7Wv6ZzffmDisa9T6GNFKim
         HgtgHNj2NtHYXBjSM0mh/zxb4ce20uMHAHwqAVfMFfazfBBagWSr2xDahJLEggJp/fsP
         R30g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793089960; x=1793694760;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=dAOLpWIzar1nhfyvh97D2hA4aDKN93kXnCVFpRFNnbw=;
        b=d6GxQfkpbLTSFP4XAGfiBPdrS8IYaOvlsocl0T4H0tSZJXbj++waguup1jWqU5jzTC
         ov3BfDljbBUyHWQE8EUgTI7qsnJTTSuKR+W6/EMWf4kvOt4PcWZJqh0Rw5FpcmuUvLTA
         8wwrfNvO+tEDhoddJkOy/j2+hUvA0X/R7jr8yeTgYCIHNOcFntytaJSEMm1+NR2pymu9
         Ar72/FnOFFSwbHyEYYlvwqr45HXIs3xs09tj1PNBnw63R+uvy0mMwjHTBr3QMuvN8ru9
         8Yi766DQEdLC90K3f4ALLS3BXGpsurF1XoD+xeI1XoAn8vuoh1jeiI/agP69SYsLeXOh
         h+Pg==
X-Forwarded-Encrypted: i=1; AKwUvBz29CvrX56J6gDeRA6X378oIf61Am1WV7e7wahZ5Y1o5gVbnLB7DHmqZaK0Uze610IxA2eh098=@lists.linux.dev
X-Gm-Message-State: AFq9FYK5TRe1Nh5AaUwY8Qg2Pq9xR3HQdzITB1gHQOWwXAsamuQEPw8r
	k/L9kiP91wOUVLUNiz74A0yZMHlTefstMBmjbxeyOc9IrFy+bwPsxPcXQRBaI2RrWdAQ2aoI0MD
	fb3jZ36fHqIli+RHMTlYzK2KlFt+d8Gi7hh+Rp8mM
X-Gm-Gg: AYBFou24y4MooBtO1SjJ9Z31V7s1ItgbBezg0/zP8tPDcJk84BdkcIbK9YNfj0qMTg0
	UBaw5sGLsn6eXEB9qkPXSp3cW0LOhpFcMUO38VcfmfJo4LFuG0nkbx3dfezmbnMFjzFdva4d3SM
	hBmbQb6yNlCk2f1SKkou4SW+hoZDdbTUUkIUvI2Cux8lOEavs/fmqfR9Q3AS7/v/P8R3LGFED73
	xfhQyyAEsR4Yeb7etdB6j2xq8Azq6DRWMmePy3KzVxv6Nb0T5OvtXHsu2QB1EyrYPF1A5QG7KLy
	GEtVNx2sZk8hh+kU+N1Y9AYYUkWYw9caK/W7usFkMpgygb8/BvAZwuvgX8fw00Uv9MUthamhm0z
	XDfUnc+kxHfTBWjmRVkaWc8eKRBqQZILsH00f18k7f+7+aOhq48o+K39BPBVwfe2QQLDeiIvpAh
	iLTT9ZGqwDhadyticmFVGd
X-Received: by 2002:a05:6214:3d10:b0:917:9338:6f16 with SMTP id
 6a1803df08f44-91c48d219d9mr154645776d6.3.1793089959391; Tue, 27 Oct 2026
 01:32:39 -0700 (PDT)
X-Mailing-List: syzbot@lists.linux.dev
List-Id: <syzbot.lists.linux.dev>
List-Post: <mailto:syzbot@lists.linux.dev>
List-Help: <mailto:syzbot+help@lists.linux.dev>
List-Subscribe: <mailto:syzbot+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:syzbot+unsubscribe@lists.linux.dev>
List-Owner: <mailto:syzbot+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
References: <6ae009fc.3a3d6196.2ecadf.002f.GAE@google.com>
In-Reply-To: <6ae009fc.3a3d6196.2ecadf.002f.GAE@google.com>
From: Pimyn Girgis <pimyn@google.com>
Date: Tue, 27 Oct 2026 09:32:28 +0100
X-Gm-Features: AclHuK_tufonoqIWQI8PRFyIkRZ-HDvSfrQWLgAChSvKwRz7RY5uZE05lei-Mi4
Message-ID: <CAJWNTGxT=FA0GDZd3c4853hp6iP1rCQi_B8upGMrkk2mF2Fpnw@mail.gmail.com>
Subject: Re: [moderation/CI] Re: gs_usb: fixes
To: syzbot ci <syzbot+cie8e5fbe72e8f515f@syzkaller.appspotmail.com>
Cc: syzkaller-upstream-moderation@googlegroups.com, syzbot@lists.linux.dev
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

#syz upstream

=E2=B2=A0=E2=B2=9F=E2=B2=93=E2=B2=99=E2=B2=8F=E2=B2=9B =E2=B2=84=E2=B2=89=
=E2=B2=B1=E2=B2=A3=E2=B2=85=E2=B2=93=E2=B2=9F=E2=B2=A5 - Pimyn Girgis
Software Engineer
Kernel Dynamic Analysis
pimyn@google.com


On Tue, Oct 27, 2026 at 3:18=E2=80=AFAM syzbot ci
<syzbot+cie8e5fbe72e8f515f@syzkaller.appspotmail.com> wrote:
>
> syzbot ci has tested the following series
>
> [v3] gs_usb: fixes
> https://lore.kernel.org/all/20261026-gs_usb-fixes-v3-0-3a68f1f62813@pengu=
tronix.de
> * [PATCH v3 1/4] can: gs_usb: gs_can_start_xmit(): don't leak uninitializ=
ed memory over USB
> * [PATCH v3 2/4] can: gs_usb: gs_usb_probe(): init netdev completely befo=
re register_candev()
> * [PATCH v3 3/4] can: gs_usb: gs_usb_receive_bulk_callback(): check for o=
verflow flag if SKB allocation fails
> * [PATCH v3 4/4] can: gs_usb: gs_usb_receive_bulk_callback(): add missing=
 call to can_rx_offload_irq_finish
>
> and found the following issue:
> general protection fault in can_rx_offload_del
>
> Full report is available here:
> https://ci.syzbot.org/series/0c1fc4c5-6a50-43da-a45c-fbc3a8685c3d
>
> ***
>
> general protection fault in can_rx_offload_del
>
> tree:      axboe
> URL:       https://kernel.googlesource.com/pub/scm/linux/kernel/git/axboe=
/linux.git
> base:      734bef548a96e8774d6eef5dfa2026c6edc4e80b
> arch:      amd64
> compiler:  Debian clang version 22.1.8 (1~deb13u4), Debian LLD 22.1.8
> config:    https://ci.syzbot.org/builds/03f4b948-ccf7-4d18-8177-b98472672=
46c/config
> syz repro: https://ci.syzbot.org/findings/e4142ca3-3d98-40ef-95df-e6f3ad5=
9fd4e/syz_repro
>
> gs_usb 1-1:0.0: Couldn't get bit timing const for channel 0 (-EPROTO)
> Oops: general protection fault, probably for non-canonical address 0xdfff=
fc000000005f: 0000 [#1] SMP KASAN PTI
> KASAN: null-ptr-deref in range [0x00000000000002f8-0x00000000000002ff]
> CPU: 1 UID: 0 PID: 5651 Comm: kworker/1:4 Not tainted syzkaller #0 PREEMP=
T(full)
> Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS 1.16.2-debian-1.=
16.2-1 04/01/2014
> Workqueue: usb_hub_wq hub_event
> RIP: 0010:__netif_napi_del include/linux/netdevice.h:3007 [inline]
> RIP: 0010:netif_napi_del include/linux/netdevice.h:3026 [inline]
> RIP: 0010:can_rx_offload_del+0x3c/0x1e0 drivers/net/can/dev/rx-offload.c:=
423
> Code: 48 89 fb 48 bd 00 00 00 00 00 fc ff df e8 9c 5f fc fa 4c 8d a3 d0 0=
0 00 00 49 89 dd 4c 8d b3 00 01 00 00 4c 89 f3 48 c1 eb 03 <80> 3c 2b 00 74=
 08 4c 89 f7 e8 26 57 6d fb 41 bf 38 0e 00 00 49 8b
> RSP: 0018:ffffc90006a4eb30 EFLAGS: 00010206
> RAX: ffffffff86cbe694 RBX: 000000000000005f RCX: ffff8881ba5cbc00
> RDX: 0000000000000000 RSI: 000000000000009e RDI: 00000000000001f9
> RBP: dffffc0000000000 R08: ffffc90006a4e6c7 R09: 1ffff92000d49cd8
> R10: dffffc0000000000 R11: fffff52000d49cd9 R12: 00000000000002c9
> R13: 00000000000001f9 R14: 00000000000002f9 R15: 0000000000000000
> FS:  0000000000000000(0000) GS:ffff8882a7ca4000(0000) knlGS:0000000000000=
000
> CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> CR2: 00007fd875c71220 CR3: 0000000115016000 CR4: 00000000000006f0
> Call Trace:
>  <TASK>
>  gs_destroy_candev drivers/net/can/usb/gs_usb.c:1510 [inline]
>  gs_usb_probe+0x2201/0x2730 drivers/net/can/usb/gs_usb.c:1639
>  usb_probe_interface+0x788/0xe50 drivers/usb/core/driver.c:399
>  call_driver_probe drivers/base/dd.c:-1 [inline]
>  really_probe+0x254/0xae0 drivers/base/dd.c:706
>  __driver_probe_device+0x1e8/0x360 drivers/base/dd.c:868
>  driver_probe_device+0x4f/0x240 drivers/base/dd.c:898
>  __device_attach_driver+0x270/0x410 drivers/base/dd.c:1026
>  bus_for_each_drv+0x258/0x2f0 drivers/base/bus.c:503
>  __device_attach+0x2c4/0x450 drivers/base/dd.c:1098
>  device_initial_probe+0xa1/0xd0 drivers/base/dd.c:1153
>  bus_probe_device+0x12a/0x220 drivers/base/bus.c:623
>  device_add+0x7d7/0xb80 drivers/base/core.c:3776
>  usb_set_configuration+0x1bb5/0x2260 drivers/usb/core/message.c:2274
>  usb_generic_driver_probe+0x8d/0x150 drivers/usb/core/generic.c:250
>  usb_probe_device+0x1c3/0x3b0 drivers/usb/core/driver.c:293
>  call_driver_probe drivers/base/dd.c:-1 [inline]
>  really_probe+0x254/0xae0 drivers/base/dd.c:706
>  __driver_probe_device+0x1e8/0x360 drivers/base/dd.c:868
>  driver_probe_device+0x4f/0x240 drivers/base/dd.c:898
>  __device_attach_driver+0x270/0x410 drivers/base/dd.c:1026
>  bus_for_each_drv+0x258/0x2f0 drivers/base/bus.c:503
>  __device_attach+0x2c4/0x450 drivers/base/dd.c:1098
>  device_initial_probe+0xa1/0xd0 drivers/base/dd.c:1153
>  bus_probe_device+0x12a/0x220 drivers/base/bus.c:623
>  device_add+0x7d7/0xb80 drivers/base/core.c:3776
>  usb_new_device+0x9aa/0x1690 drivers/usb/core/hub.c:2713
>  hub_port_connect drivers/usb/core/hub.c:5585 [inline]
>  hub_port_connect_change drivers/usb/core/hub.c:5725 [inline]
>  port_event drivers/usb/core/hub.c:5889 [inline]
>  hub_event+0x28e8/0x4d30 drivers/usb/core/hub.c:5971
>  process_one_work kernel/workqueue.c:3495 [inline]
>  process_scheduled_works+0xc3d/0x1630 kernel/workqueue.c:3578
>  worker_thread+0xa47/0xfb0 kernel/workqueue.c:3659
>  kthread+0x38b/0x480 kernel/kthread.c:436
>  ret_from_fork+0x514/0xb70 arch/x86/kernel/process.c:158
>  ret_from_fork_asm+0x1a/0x30 arch/x86/entry/entry_64.S:245
>  </TASK>
> Modules linked in:
> ---[ end trace 0000000000000000 ]---
> RIP: 0010:__netif_napi_del include/linux/netdevice.h:3007 [inline]
> RIP: 0010:netif_napi_del include/linux/netdevice.h:3026 [inline]
> RIP: 0010:can_rx_offload_del+0x3c/0x1e0 drivers/net/can/dev/rx-offload.c:=
423
> Code: 48 89 fb 48 bd 00 00 00 00 00 fc ff df e8 9c 5f fc fa 4c 8d a3 d0 0=
0 00 00 49 89 dd 4c 8d b3 00 01 00 00 4c 89 f3 48 c1 eb 03 <80> 3c 2b 00 74=
 08 4c 89 f7 e8 26 57 6d fb 41 bf 38 0e 00 00 49 8b
> RSP: 0018:ffffc90006a4eb30 EFLAGS: 00010206
> RAX: ffffffff86cbe694 RBX: 000000000000005f RCX: ffff8881ba5cbc00
> RDX: 0000000000000000 RSI: 000000000000009e RDI: 00000000000001f9
> RBP: dffffc0000000000 R08: ffffc90006a4e6c7 R09: 1ffff92000d49cd8
> R10: dffffc0000000000 R11: fffff52000d49cd9 R12: 00000000000002c9
> R13: 00000000000001f9 R14: 00000000000002f9 R15: 0000000000000000
> FS:  0000000000000000(0000) GS:ffff8882a7ca4000(0000) knlGS:0000000000000=
000
> CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> CR2: 00007f58953fcfe0 CR3: 000000000fb48000 CR4: 00000000000006f0
> ----------------
> Code disassembly (best guess):
>    0:   48 89 fb                mov    %rdi,%rbx
>    3:   48 bd 00 00 00 00 00    movabs $0xdffffc0000000000,%rbp
>    a:   fc ff df
>    d:   e8 9c 5f fc fa          call   0xfafc5fae
>   12:   4c 8d a3 d0 00 00 00    lea    0xd0(%rbx),%r12
>   19:   49 89 dd                mov    %rbx,%r13
>   1c:   4c 8d b3 00 01 00 00    lea    0x100(%rbx),%r14
>   23:   4c 89 f3                mov    %r14,%rbx
>   26:   48 c1 eb 03             shr    $0x3,%rbx
> * 2a:   80 3c 2b 00             cmpb   $0x0,(%rbx,%rbp,1) <-- trapping in=
struction
>   2e:   74 08                   je     0x38
>   30:   4c 89 f7                mov    %r14,%rdi
>   33:   e8 26 57 6d fb          call   0xfb6d575e
>   38:   41 bf 38 0e 00 00       mov    $0xe38,%r15d
>   3e:   49                      rex.WB
>   3f:   8b                      .byte 0x8b
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
> [eric@evenchick.com kernel@pengutronix.de linux-can@vger.kernel.org linux=
-kernel@vger.kernel.org mailhol@kernel.org max@schneidersoft.net mkl@pengut=
ronix.de pfink@christ-es.de stable@vger.kernel.org wg@grandegger.com]
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
-upstream-moderation/6ae009fc.3a3d6196.2ecadf.002f.GAE%40google.com.



--=20
=E2=B2=A0=E2=B2=9F=E2=B2=93=E2=B2=99=E2=B2=8F=E2=B2=9B =E2=B2=84=E2=B2=89=
=E2=B2=B1=E2=B2=A3=E2=B2=85=E2=B2=93=E2=B2=9F=E2=B2=A5 - Pimyn Girgis
Software Engineer
Kernel Dynamic Analysis
pimyn@google.com
