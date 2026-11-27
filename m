Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=209.85.161.42
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1795760486;
	b=0kBa+rTSitBpNn6xg6bE+0Pn4l533JoogtLfPl4OLK6qXE2T4Lzw1zk7qIHKjegzlbyN
	 Bj8GI0jmkQuIQcN97pfncFcNWb0fpTq8j4ixtzOuqHhjp6IhOX8iXH9snA85ogMmrUs0X
	 jyvYLmGdUJG1lKxlQHCDyqFByxl29SlylJh35sgakT7RehdsyJMo2kHkhyi+KeO7GyHgG
	 YNVwdQ+fC7on2MCWjxvzCCEnIqqkObDn84OVZ378tFWXm87rbgybLGnjSlS+YAFcKLfNu
	 hNsJu+VzDdTAjeLuyLihGUpLTIhBWTDaI/HJdzau+YKovFi9qhFMOYpeBFrgYM6hitA==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795760486;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:
	 MIME-Version:References:In-Reply-To:From:Date:X-Gm-Features:
	 Message-ID:Subject:To:Cc:Content-Type:Content-Transfer-Encoding;
	bh=nw0Vfp4LHWnwYpUB+aIy2SeOGA9PfQtOzaPHYsXCZ1c=;
	b=X7nU6h5kmVDObcQsBp4uDLTo9SWzSGFwodocWspm5K4CQxQlV2hDJb8L30zCIM1JFyGJ
	 CSACzGFDfof1MPWhdcZ6qNKKf6jUvXRJrnshFVC1yas9LyPCx4warXr4qyeg/BZVr1giV
	 YRrGvH370BROjByXvD4eHaZvSDvdDD2R0yEB0pELZ6F0djFW68oMSTNOQUebmmvoeoVlM
	 tlXmmDot+Q9D4Gg8nk+Es8dxVlQhWKZBQHYB069w44xxl5BYK/z8RpdwYVzshQF/+3Nep
	 jzvUv0fjSOwBxSmc2mx+6/ONwKoq7bgzY/MCx+as7d0QMlUi54a5QARe2NlKYoxt4aA==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=google.com;
	spf=pass smtp.mailfrom=google.com;
	dkim=pass header.d=google.com header.i=@google.com header.a=rsa-sha256 header.s=20260707 header.b=XB5SQPG2;
	arc=pass header.oldest-pass=0 smtp.remote-ip=209.85.161.42
Received: from mail-oo1-f42.google.com (mail-oo1-f42.google.com [209.85.161.42])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0AE47606A31C
	for <syzbot@lists.linux.dev>; Fri, 27 Nov 2026 06:21:25 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 0AE47606A31C
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=google.com header.i=@google.com header.a=rsa-sha256 header.s=20260707 header.b=XB5SQPG2
Received: by mail-oo1-f42.google.com with SMTP id 006d021491bc7-6d290b10a35so3233650eaf.2
        for <syzbot@lists.linux.dev>; Thu, 26 Nov 2026 22:21:25 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1795760485; cv=none;
        d=google.com; s=arc-20260327;
        b=EF7LNbbks7uqhmvsInb9hKodg7uPERCRFCssj08uD5rize+C+pMO5X17X9wxgfGyKV
         yo8yiq2UU9LSL5VS1nmhxgTjSx2+TathNrWNMw+gfVShvYBZ+o5/ccN9MLWwDb498GRk
         ZJM/Pj5ZOAaL/6o+ybFsw5QZsue2w5sXYtBrGW/8wg+WlkmHumrN1K1AYqnLSKxM7z15
         wl9qWjpbR9Kc64o68+dr79I4s8oJPf0cszg5AVJCDQ50DJOseWlMd7OzDQt1IzSqTtTT
         4Te5OGUEYCKu6bvFM0/NZJrcU7i+YAcqcG2xltEC5mnZK+CTiQ21x5OAGAahY6jYQwNM
         Icqw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=nw0Vfp4LHWnwYpUB+aIy2SeOGA9PfQtOzaPHYsXCZ1c=;
        fh=mZhTZ1UF+3OmTObTWP21pJ87MdA0DDIzOMb++Ww2BnE=;
        b=VuNlTHkut+9AvGCpXKhz+HMTgv5xTWCVjjkgvh/uqsUazYHF+eDCvH6SSnSpL4CSOC
         3uf+jiSMo89YTMdpA7XLZ5Nk/XTDZQOQ6jAnzBrAqQBkf6D7ap9KujvQqfCXSxX6C0tM
         8Y6pS7TY32C5c0u3yZYfciKJ7etz9ExgCpyUeTL2Aq3DFMbgorbuNf6PZO1JpWHalFGM
         96opDzAXmdhdfNvj3+xR/QMxA1y7j2nG3Vh5iaEIyRkr0d1ZWKxiN1ZJ0RqnZqGPeGL5
         GE9Ei5upV5zPF8Doh0CqkS3OoGt4WDYUkU6DCRaQaEILOX3+ZMV3qawyj8zjQCKN5HTm
         onOg==;
        darn=lists.linux.dev
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20260707; t=1795760485; x=1796365285; darn=lists.linux.dev;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=nw0Vfp4LHWnwYpUB+aIy2SeOGA9PfQtOzaPHYsXCZ1c=;
        b=XB5SQPG2qFlnBceAwnnYWDWnXqGp0TKwsKWaj+YtdVA/vFrmi9AiRN6pZpEdFFhJPp
         kVb3J0nekWKosXXUNQxK/q7XDpnPHe9w/gqqPadIYAzXlGBVsJy5hDyxsfjN4jHHMklx
         omoeY37E8iM1jlnJj3OAwmVScKkGx6YQ85oM4q/S+SP8X6RwzOWCNshXxpefRz6TlWLd
         efWxCkeU+ak76Q8I2itmi+fbOlzatNRqT7cSdjk9kpqNgtWzyZwrUrfjx5EB8S8YhsIi
         AwRtkuMQvoo1Y7pH1sBQTOY9W2LkeWHuBGi3QyRrea4CdXBTmT45dDCYuTCPGqFAsXe9
         Ej6w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1795760485; x=1796365285;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=nw0Vfp4LHWnwYpUB+aIy2SeOGA9PfQtOzaPHYsXCZ1c=;
        b=wdLhDzMuGXbA577jnQJyaSrjM8sSrolh/T7bfLSeUJpVEEcoSJdrbNR8hxTQyvMokC
         A6zXis3UutK/n4Y+T0Kq3pJnFAeQXRkYt8YMBEgvSSn7Mfz2q910/MeMc0fYytB0mu1u
         ALmlxwbYFfyVnuv4a+39+r4NTnbwJYrOhWdptoTCft97lNVsVt5lpxvWXLxnEtafCKJA
         jCFLRxwd9T0XjiRe0n0mhAksjPQE+kVOVZqDTgvMuf6zau44EZpqq7CuS4ZJEw0y0qFZ
         7BVcA9HX/VptG7v+zY4NS9crttYmerjRWFUE1oQwxaFe81yQ/uo7byJh1udqmddD25TV
         bgsA==
X-Forwarded-Encrypted: i=1; AL+hErHh8vfxdVhpnr/UDiXBrwkWdvE2O4RQCIY9mxfkMKi+y2OQgpp2GFR5/FtMewpKi9egMsa+Qg0=@lists.linux.dev
X-Gm-Message-State: APuU4Z+Aw7BkPzCiDYHjhFp7ZT+207aizIat9EANHMvi625L9BBEhsS8
	qSmFwJLj4+DniuBKLJNtRzjoZj6MfpcXcF/uLaZt2hK2fYdhBkzNzW8vhRB7GTMsGgjPFsNq7z0
	AmTEqbbuO+G7TndpiERVYF+8H+BcYdNeyvzGMQogD
X-Gm-Gg: AZFdTZfG97TPyCawzIqm3lrhM9MmtUCztJ1tK8NChGgcN8M4BwsZqoWKMJZiL6n+PLR
	KjpRUZYgzndcWlASXvfagu6oVx0UsrdfwFbJOVBS3DxTf1eHLRkhUdzai6NA4dMjY29PH95PzYV
	yBw+NkCqWuQP03+mwz1pB7VexN//WMe5R3xjDvz/Ys8UJy6NEsX7HhEojp3332EQfjul3yaxJUC
	BI1bpNU4fN4tZrXvtVBpRGC6LBFxS3J7cbf0lLf2Io6xo0nkYVJ0688NucnKEblaOWBSNV03Snn
	aftv5OO/H1YdnS6RkU2a/LcDSrj3dE9UuhsGF4/m3zqODFCs9XogK8vcPPp7J8/u4stk/0lUA62
	fOAgSvSl8hSH5r6B8scSuT/PwUGa6DdCQYtb+7FkH+PlJDk/KCj//YXHdjPUxs0owqUvwf8G0Vd
	30m4UzKKNJrDDVlPI2jPc5k7o10mZIWpno1e9ZvD0hUMorFSBCcP2YHNxQT+zhRymw4AtSJ0Etp
	TskEUv/ew==
X-Received: by 2002:a05:6820:1c8f:b0:71b:8112:ff76 with SMTP id
 006d021491bc7-71b811307femr5060006eaf.65.1795760484157; Thu, 26 Nov 2026
 22:21:24 -0800 (PST)
X-Mailing-List: syzbot@lists.linux.dev
List-Id: <syzbot.lists.linux.dev>
List-Post: <mailto:syzbot@lists.linux.dev>
List-Help: <mailto:syzbot+help@lists.linux.dev>
List-Subscribe: <mailto:syzbot+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:syzbot+unsubscribe@lists.linux.dev>
List-Owner: <mailto:syzbot+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
References: <6b0913c1.28411dd9.2968b4.000c.GAE@google.com>
In-Reply-To: <6b0913c1.28411dd9.2968b4.000c.GAE@google.com>
From: Aleksandr Nogikh <nogikh@google.com>
Date: Fri, 27 Nov 2026 07:21:13 +0100
X-Gm-Features: Aa3M54pWqU9KBEclnli_FNaYLe-cNBytND-PZ9rh1NQ6Zjh5kr7J-z6_4QTHu-4
Message-ID: <CANp29Y4P3W=qRdKakO4j8z3bajHj-s0S_-Gg4VY=1d7UW1agpQ@mail.gmail.com>
Subject: Re: [moderation/CI] Re: ALSA: line6: Stop URBs synchronously via
 sync_stop callback
To: syzbot ci <syzbot+ci6928a73fc601c810@syzkaller.appspotmail.com>
Cc: syzkaller-upstream-moderation@googlegroups.com, syzbot@lists.linux.dev
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

#syz upstream

On Fri, Nov 27, 2026 at 6:23=E2=80=AFAM syzbot ci
<syzbot+ci6928a73fc601c810@syzkaller.appspotmail.com> wrote:
>
> syzbot ci has tested the following series
>
> [v4] ALSA: line6: Stop URBs synchronously via sync_stop callback
> https://lore.kernel.org/all/20261122090454.6217-1-25031212351@stu.xidian.=
edu.cn
> * [PATCH v4] ALSA: line6: Stop URBs synchronously via sync_stop callback
>
> and found the following issue:
> general protection fault in line6_kill_audio_urbs
>
> Full report is available here:
> https://ci.syzbot.org/series/142062cf-1e2f-45f6-889f-e755c6f0dfc7
>
> ***
>
> general protection fault in line6_kill_audio_urbs
>
> tree:      torvalds
> URL:       https://kernel.googlesource.com/pub/scm/linux/kernel/git/torva=
lds/linux
> base:      9437ee8b6cf607e883b36e44bd755968daaebd48
> arch:      amd64
> compiler:  Debian clang version 22.1.8 (1~deb13u4), Debian LLD 22.1.8
> config:    https://ci.syzbot.org/builds/fa7bddbf-e0c4-41e2-9f96-995d29f44=
c33/config
> syz repro: https://ci.syzbot.org/findings/3b9dd218-32a8-4b85-8604-77328ad=
a3c3e/syz_repro
>
> snd_usb_toneport 1-1:0.0: cannot get proper max packet size
> Oops: general protection fault, probably for non-canonical address 0xdfff=
fc0000000000: 0000 [#1] SMP KASAN PTI
> KASAN: null-ptr-deref in range [0x0000000000000000-0x0000000000000007]
> CPU: 0 UID: 0 PID: 994 Comm: kworker/0:3 Not tainted syzkaller #0 PREEMPT=
(full)
> Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS 1.16.2-debian-1.=
16.2-1 04/01/2014
> Workqueue: usb_hub_wq hub_event
> RIP: 0010:line6_kill_audio_urbs+0x1eb/0x320 sound/usb/line6/pcm.c:133
> Code: 4c 8b 24 24 4c 89 e5 48 c1 ed 03 42 80 7c 35 00 00 74 08 4c 89 e7 e=
8 d4 96 92 f8 4d 8b 24 24 4a 8d 3c 23 48 89 f8 48 c1 e8 03 <42> 80 3c 30 00=
 74 05 e8 b9 96 92 f8 4d 8b 24 1c 4d 85 e4 74 0f e8
> RSP: 0018:ffffc9000632ec10 EFLAGS: 00010246
> RAX: 0000000000000000 RBX: 0000000000000000 RCX: 0000000000000000
> RDX: ffff88810d8e0000 RSI: 0000000000000010 RDI: 0000000000000000
> RBP: 1ffff11023131427 R08: ffffffff91be37bf R09: 1ffffffff237c6f7
> R10: dffffc0000000000 R11: fffffbfff237c6f8 R12: 0000000000000000
> R13: 0000000000000001 R14: dffffc0000000000 R15: ffff88811898a000
> FS:  0000000000000000(0000) GS:ffff88818bdf6000(0000) knlGS:0000000000000=
000
> CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> CR2: 000055bf9470d0a0 CR3: 0000000117d14000 CR4: 00000000000006f0
> Call Trace:
>  <TASK>
>  line6_pcm_disconnect+0x1c/0x30 sound/usb/line6/pcm.c:515
>  line6_disconnect+0x166/0x260 sound/usb/line6/driver.c:844
>  line6_probe+0x9f5/0xcd0 sound/usb/line6/driver.c:818
>  usb_probe_interface+0x751/0xe00 drivers/usb/core/driver.c:399
>  call_driver_probe drivers/base/dd.c:-1 [inline]
>  really_probe+0x254/0xae0 drivers/base/dd.c:707
>  __driver_probe_device+0x1e8/0x360 drivers/base/dd.c:869
>  driver_probe_device+0x4f/0x240 drivers/base/dd.c:899
>  __device_attach_driver+0x270/0x410 drivers/base/dd.c:1027
>  bus_for_each_drv+0x258/0x2f0 drivers/base/bus.c:500
>  __device_attach+0x2bd/0x430 drivers/base/dd.c:1131
>  device_initial_probe+0x9c/0x100 drivers/base/dd.c:1190
>  __bus_probe_device+0x126/0x220 drivers/base/bus.c:614
>  device_add+0x7d7/0xb80 drivers/base/core.c:3778
>  usb_set_configuration+0x1bb5/0x2260 drivers/usb/core/message.c:2280
>  usb_generic_driver_probe+0x8d/0x150 drivers/usb/core/generic.c:250
>  usb_probe_device+0x1c3/0x3b0 drivers/usb/core/driver.c:293
>  call_driver_probe drivers/base/dd.c:-1 [inline]
>  really_probe+0x254/0xae0 drivers/base/dd.c:707
>  __driver_probe_device+0x1e8/0x360 drivers/base/dd.c:869
>  driver_probe_device+0x4f/0x240 drivers/base/dd.c:899
>  __device_attach_driver+0x270/0x410 drivers/base/dd.c:1027
>  bus_for_each_drv+0x258/0x2f0 drivers/base/bus.c:500
>  __device_attach+0x2bd/0x430 drivers/base/dd.c:1131
>  device_initial_probe+0x9c/0x100 drivers/base/dd.c:1190
>  __bus_probe_device+0x126/0x220 drivers/base/bus.c:614
>  device_add+0x7d7/0xb80 drivers/base/core.c:3778
>  usb_new_device+0x9aa/0x1690 drivers/usb/core/hub.c:2713
>  hub_port_connect drivers/usb/core/hub.c:5585 [inline]
>  hub_port_connect_change drivers/usb/core/hub.c:5725 [inline]
>  port_event drivers/usb/core/hub.c:5889 [inline]
>  hub_event+0x28e8/0x4d30 drivers/usb/core/hub.c:5971
>  process_one_work kernel/workqueue.c:3497 [inline]
>  process_scheduled_works+0xc5d/0x1650 kernel/workqueue.c:3580
>  worker_thread+0xa47/0xfb0 kernel/workqueue.c:3661
>  kthread+0x38b/0x480 kernel/kthread.c:436
>  ret_from_fork+0x514/0xb70 arch/x86/kernel/process.c:158
>  ret_from_fork_asm+0x1a/0x30 arch/x86/entry/entry_64.S:245
>  </TASK>
> Modules linked in:
> ---[ end trace 0000000000000000 ]---
> RIP: 0010:line6_kill_audio_urbs+0x1eb/0x320 sound/usb/line6/pcm.c:133
> Code: 4c 8b 24 24 4c 89 e5 48 c1 ed 03 42 80 7c 35 00 00 74 08 4c 89 e7 e=
8 d4 96 92 f8 4d 8b 24 24 4a 8d 3c 23 48 89 f8 48 c1 e8 03 <42> 80 3c 30 00=
 74 05 e8 b9 96 92 f8 4d 8b 24 1c 4d 85 e4 74 0f e8
> RSP: 0018:ffffc9000632ec10 EFLAGS: 00010246
> RAX: 0000000000000000 RBX: 0000000000000000 RCX: 0000000000000000
> RDX: ffff88810d8e0000 RSI: 0000000000000010 RDI: 0000000000000000
> RBP: 1ffff11023131427 R08: ffffffff91be37bf R09: 1ffffffff237c6f7
> R10: dffffc0000000000 R11: fffffbfff237c6f8 R12: 0000000000000000
> R13: 0000000000000001 R14: dffffc0000000000 R15: ffff88811898a000
> FS:  0000000000000000(0000) GS:ffff88818bdf6000(0000) knlGS:0000000000000=
000
> CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> CR2: 000055bf9470d0a0 CR3: 0000000117d14000 CR4: 00000000000006f0
> ----------------
> Code disassembly (best guess):
>    0:   4c 8b 24 24             mov    (%rsp),%r12
>    4:   4c 89 e5                mov    %r12,%rbp
>    7:   48 c1 ed 03             shr    $0x3,%rbp
>    b:   42 80 7c 35 00 00       cmpb   $0x0,0x0(%rbp,%r14,1)
>   11:   74 08                   je     0x1b
>   13:   4c 89 e7                mov    %r12,%rdi
>   16:   e8 d4 96 92 f8          call   0xf89296ef
>   1b:   4d 8b 24 24             mov    (%r12),%r12
>   1f:   4a 8d 3c 23             lea    (%rbx,%r12,1),%rdi
>   23:   48 89 f8                mov    %rdi,%rax
>   26:   48 c1 e8 03             shr    $0x3,%rax
> * 2a:   42 80 3c 30 00          cmpb   $0x0,(%rax,%r14,1) <-- trapping in=
struction
>   2f:   74 05                   je     0x36
>   31:   e8 b9 96 92 f8          call   0xf89296ef
>   36:   4d 8b 24 1c             mov    (%r12,%rbx,1),%r12
>   3a:   4d 85 e4                test   %r12,%r12
>   3d:   74 0f                   je     0x4e
>   3f:   e8                      .byte 0xe8
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
> The email will later be sent to:
> [25031212351@stu.xidian.edu.cn byu@xidian.edu.cn linux-kernel@vger.kernel=
.org linux-sound@vger.kernel.org perex@perex.cz stable@vger.kernel.org tiwa=
i@suse.de wencheng@xidian.edu.cn]
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
-upstream-moderation/6b0913c1.28411dd9.2968b4.000c.GAE%40google.com.
