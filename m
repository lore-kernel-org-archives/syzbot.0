Received: from mail-oo1-f46.google.com (mail-oo1-f46.google.com [209.85.161.46])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2A4A51373
	for <syzbot@lists.linux.dev>; Sun, 30 Nov 2025 10:08:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.161.46
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764497303; cv=none; b=CkJJZ7N5b71AYf9sG7dpcj0LF4gFL2SVqc6XALL/VY18983KdUonBrvUHNbtO9pIOBQKaMtWAXt439QlDQ18ywiM7ZDMXAUGz5nfHwi3Hho55GbdAZfTKtXr0EG0XeJ3ziXnu5Fa1BZH8iHYp2V5Vn6QoXamyXWdt9Mvy78eJ+Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764497303; c=relaxed/simple;
	bh=wHGIBu1f6uAa2k9XqE1nmoIZT+2gcn89pzYazeXCUdc=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=bF1c1v7oa4q1tiV9Rkau+fXboPinYMt17khaWYTUfpJVP5Hn3/2sBBN90VuKqZP2VRUjeFNYr+WF8Z61Sji0Kucbb5NxUtv49zS1320wxotXW8JfWqTXgbVn2QxdBOimZtkSZtG3dOday14pPOCJpUbFLFa6tt2dfxUU7oTQGDY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=itomupNF; arc=none smtp.client-ip=209.85.161.46
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="itomupNF"
Received: by mail-oo1-f46.google.com with SMTP id 006d021491bc7-656b8ca52e8so1236934eaf.3
        for <syzbot@lists.linux.dev>; Sun, 30 Nov 2025 02:08:20 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1764497300; x=1765102100; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Qrr2HPyleJhgsVobd667zknl19kqfnctk9r9xxRUTXQ=;
        b=itomupNFjIkBSWffMmoSdyf9sbWKOYRVCPBsVW4tfk1Ut9P0EdulWjNXxJv9idZNNW
         XFo3T9tnZYl7XYueQlrbnKS41590Kj/bWi7Ku6UBL99rfPTRtxsAnRMoTnnwVkQMRx8+
         i2WTh8RgXSIL3Kc278VftD3vPGFcaphIZlRqKB3eXJdzNZMX56KK6GBhckhZg7to0qsx
         8U+GxbG7o2ZvlrOSMLZex8+xeR1t0TslnBnAMPsBy+DwfRH2k5fo+GCMlikRbwVVSfni
         TQ4FRrrw8kIlgdLzVYlq12aTgqkkdV53D7GQhlJqWJfF4T80nuymCX65dDJ2xtb7cgtt
         z+Zw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1764497300; x=1765102100;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=Qrr2HPyleJhgsVobd667zknl19kqfnctk9r9xxRUTXQ=;
        b=fhJJarL88LfQcW5qar92kb0Nwp73uwQfT9wrqRY0SEMeuJmQtu6Qxrz875x0p4pfN5
         7IdGiOoHOeVGvoQIdB/HFdeAjSZr96ydUI10Z3BhqwSFnDqZyt3D8iyWA2twCzVA7i+3
         fGokFETUloaUZ1F6rV+bsxHXqot0eBZUYMpx5kEHnIhtP3U9zDpkbYrqWO1n6OqfrUVV
         rP+jEV2D+hRZ92rO1PPA3m1ksrJMPNIiZRyGY/wi9IDt20AuxSAH7FsATwyoMo1OswGN
         LWFd8WZAGsXrL7YriYd9Xn7NO43nGl0yY9wWGJ7rlvEt1spHrAFFUVtHtvLeYLng6tiI
         DkPA==
X-Forwarded-Encrypted: i=1; AJvYcCXJLGcxdITu+sQahul6otqPZPXezc8o3/G615xZI5f36jFc8IFdaXU3lUHELWDwONIM26L0/4o=@lists.linux.dev
X-Gm-Message-State: AOJu0YwtFiPAcaXaoRTYU3W/TWA/nW/IU4SxG22C5W8bmYi2tej+msZK
	t6Gb4bqgDttVnHoQhxbE9m9/zWtHJVtT4iuotdlokUZHK65Yv+1Ec8kjdo0Ezf0L9c8Eicx3tFy
	bjwrNIxudSIMhcTk6wV/5xTWdan2VeBRd9wHBxC55
X-Gm-Gg: ASbGncvbVjIAKymXI2+j0+afJPO1dFdj0qq2GV1/f/qiiZQxucVInpLF7waiAD4El0d
	1UpPDXGisbnjHiDoc79g1AQ9DM8xt8KJuheV96fgsaXIX0xZnrETbOE9meHVGDUMC+Pm9Bn+/hA
	E2duB8qqxz5Kt0MOAQGOau9QaPA5R7i0YBUZr5MRSRSEVXnYVT4TV5ESPDos+Vta2VH4iKnt86J
	LxSkmkmUAb7PHDCIWHA3sputXPUi8j1Yqinx6vk0XX/QFO0IQNw/X6/URrhiXynGSknmSDGFYcL
	LSCw6TEqPIA9GG/2KZIte8Rg9MEkprZmu9YWZngRbxhv4r+cqEX+BYORtQmu
X-Google-Smtp-Source: AGHT+IEbNowgeUANlmPJ0DjLYxSKiCENx0Vl99Zh2MAc7IfoMjfwJd0c5CCVN5ZuSHB/qzb7A69jP9UdPFXAtvACXfo=
X-Received: by 2002:a05:6820:178c:b0:657:57b7:e944 with SMTP id
 006d021491bc7-657bd92c086mr8336153eaf.0.1764497299910; Sun, 30 Nov 2025
 02:08:19 -0800 (PST)
Precedence: bulk
X-Mailing-List: syzbot@lists.linux.dev
List-Id: <syzbot.lists.linux.dev>
List-Subscribe: <mailto:syzbot+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:syzbot+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <692bbc76.050a0220.2ffa18.0015.GAE@google.com>
In-Reply-To: <692bbc76.050a0220.2ffa18.0015.GAE@google.com>
From: Aleksandr Nogikh <nogikh@google.com>
Date: Sun, 30 Nov 2025 11:08:07 +0100
X-Gm-Features: AWmQ_bnIENXXkw5UjxGvX6sutj4DjjBgg83Ic-7HB9KOIAuOOLi_0U6GqZGtcEE
Message-ID: <CANp29Y687X7zD3tux+ztJ1wTG1RP2Bs-mhp8Z4-f3GQPTYGARw@mail.gmail.com>
Subject: Re: [moderation/CI] Re: blk-mq: fix possible deadlocks
To: syzbot ci <syzbot+ci7514c9a05073e23e@syzkaller.appspotmail.com>
Cc: syzkaller-upstream-moderation@googlegroups.com, syzbot@lists.linux.dev
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

#syz upstream

On Sun, Nov 30, 2025 at 4:39=E2=80=AFAM syzbot ci
<syzbot+ci7514c9a05073e23e@syzkaller.appspotmail.com> wrote:
>
> syzbot ci has tested the following series
>
> [v3] blk-mq: fix possible deadlocks
> https://lore.kernel.org/all/20251130024349.2302128-1-yukuai@fnnas.com
> * [PATCH v3 01/10] blk-mq-debugfs: factor out a helper to register debugf=
s for all rq_qos
> * [PATCH v3 02/10] blk-rq-qos: fix possible debugfs_mutex deadlock
> * [PATCH v3 03/10] blk-mq-debugfs: make blk_mq_debugfs_register_rqos() st=
atic
> * [PATCH v3 04/10] blk-mq-debugfs: warn about possible deadlock
> * [PATCH v3 05/10] block/blk-rq-qos: add a new helper rq_qos_add_frozen()
> * [PATCH v3 06/10] blk-wbt: fix incorrect lock order for rq_qos_mutex and=
 freeze queue
> * [PATCH v3 07/10] blk-iocost: fix incorrect lock order for rq_qos_mutex =
and freeze queue
> * [PATCH v3 08/10] blk-iolatency: fix incorrect lock order for rq_qos_mut=
ex and freeze queue
> * [PATCH v3 09/10] blk-throttle: remove useless queue frozen
> * [PATCH v3 10/10] block/blk-rq-qos: cleanup rq_qos_add()
>
> and found the following issue:
> possible deadlock in pcpu_alloc_noprof
>
> Full report is available here:
> https://ci.syzbot.org/series/1aec77f0-c53f-4b3b-93fb-b3853983b6bd
>
> ***
>
> possible deadlock in pcpu_alloc_noprof
>
> tree:      linux-next
> URL:       https://kernel.googlesource.com/pub/scm/linux/kernel/git/next/=
linux-next
> base:      7d31f578f3230f3b7b33b0930b08f9afd8429817
> arch:      amd64
> compiler:  Debian clang version 20.1.8 (++20250708063551+0c9f909b7976-1~e=
xp1~20250708183702.136), Debian LLD 20.1.8
> config:    https://ci.syzbot.org/builds/70dca9e4-6667-4930-9024-150d656e5=
03e/config
>
> soft_limit_in_bytes is deprecated and will be removed. Please report your=
 usecase to linux-mm@kvack.org if you depend on this functionality.
> =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D
> WARNING: possible circular locking dependency detected
> syzkaller #0 Not tainted
> ------------------------------------------------------
> syz-executor/6047 is trying to acquire lock:
> ffffffff8e04f760 (fs_reclaim){+.+.}-{0:0}, at: prepare_alloc_pages+0x152/=
0x650
>
> but task is already holding lock:
> ffffffff8e02dde8 (pcpu_alloc_mutex){+.+.}-{4:4}, at: pcpu_alloc_noprof+0x=
25b/0x1750
>
> which lock already depends on the new lock.
>
>
> the existing dependency chain (in reverse order) is:
>
> -> #2 (pcpu_alloc_mutex){+.+.}-{4:4}:
>        __mutex_lock+0x187/0x1350
>        pcpu_alloc_noprof+0x25b/0x1750
>        blk_stat_alloc_callback+0xd5/0x220
>        wbt_init+0xa3/0x500
>        wbt_enable_default+0x25d/0x350
>        blk_register_queue+0x36a/0x3f0
>        __add_disk+0x677/0xd50
>        add_disk_fwnode+0xfc/0x480
>        loop_add+0x7f0/0xad0
>        loop_init+0xd9/0x170
>        do_one_initcall+0x1fb/0x820
>        do_initcall_level+0x104/0x190
>        do_initcalls+0x59/0xa0
>        kernel_init_freeable+0x334/0x4b0
>        kernel_init+0x1d/0x1d0
>        ret_from_fork+0x599/0xb30
>        ret_from_fork_asm+0x1a/0x30
>
> -> #1 (&q->q_usage_counter(io)#17){++++}-{0:0}:
>        blk_alloc_queue+0x538/0x620
>        __blk_mq_alloc_disk+0x15c/0x340
>        loop_add+0x411/0xad0
>        loop_init+0xd9/0x170
>        do_one_initcall+0x1fb/0x820
>        do_initcall_level+0x104/0x190
>        do_initcalls+0x59/0xa0
>        kernel_init_freeable+0x334/0x4b0
>        kernel_init+0x1d/0x1d0
>        ret_from_fork+0x599/0xb30
>        ret_from_fork_asm+0x1a/0x30
>
> -> #0 (fs_reclaim){+.+.}-{0:0}:
>        __lock_acquire+0x15a6/0x2cf0
>        lock_acquire+0x117/0x340
>        fs_reclaim_acquire+0x72/0x100
>        prepare_alloc_pages+0x152/0x650
>        __alloc_frozen_pages_noprof+0x123/0x370
>        __alloc_pages_noprof+0xa/0x30
>        pcpu_populate_chunk+0x182/0xb30
>        pcpu_alloc_noprof+0xcb6/0x1750
>        xt_percpu_counter_alloc+0x161/0x220
>        translate_table+0x1323/0x2040
>        ip6t_register_table+0x106/0x7d0
>        ip6table_nat_table_init+0x43/0x2e0
>        xt_find_table_lock+0x30c/0x3e0
>        xt_request_find_table_lock+0x26/0x100
>        do_ip6t_get_ctl+0x730/0x1180
>        nf_getsockopt+0x26e/0x290
>        ipv6_getsockopt+0x1ed/0x290
>        do_sock_getsockopt+0x2b4/0x3d0
>        __x64_sys_getsockopt+0x1a5/0x250
>        do_syscall_64+0xfa/0xf80
>        entry_SYSCALL_64_after_hwframe+0x77/0x7f
>
> other info that might help us debug this:
>
> Chain exists of:
>   fs_reclaim --> &q->q_usage_counter(io)#17 --> pcpu_alloc_mutex
>
>  Possible unsafe locking scenario:
>
>        CPU0                    CPU1
>        ----                    ----
>   lock(pcpu_alloc_mutex);
>                                lock(&q->q_usage_counter(io)#17);
>                                lock(pcpu_alloc_mutex);
>   lock(fs_reclaim);
>
>  *** DEADLOCK ***
>
> 1 lock held by syz-executor/6047:
>  #0: ffffffff8e02dde8 (pcpu_alloc_mutex){+.+.}-{4:4}, at: pcpu_alloc_nopr=
of+0x25b/0x1750
>
> stack backtrace:
> CPU: 0 UID: 0 PID: 6047 Comm: syz-executor Not tainted syzkaller #0 PREEM=
PT(full)
> Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS 1.16.2-debian-1.=
16.2-1 04/01/2014
> Call Trace:
>  <TASK>
>  dump_stack_lvl+0x189/0x250
>  print_circular_bug+0x2e2/0x300
>  check_noncircular+0x12e/0x150
>  __lock_acquire+0x15a6/0x2cf0
>  lock_acquire+0x117/0x340
>  fs_reclaim_acquire+0x72/0x100
>  prepare_alloc_pages+0x152/0x650
>  __alloc_frozen_pages_noprof+0x123/0x370
>  __alloc_pages_noprof+0xa/0x30
>  pcpu_populate_chunk+0x182/0xb30
>  pcpu_alloc_noprof+0xcb6/0x1750
>  xt_percpu_counter_alloc+0x161/0x220
>  translate_table+0x1323/0x2040
>  ip6t_register_table+0x106/0x7d0
>  ip6table_nat_table_init+0x43/0x2e0
>  xt_find_table_lock+0x30c/0x3e0
>  xt_request_find_table_lock+0x26/0x100
>  do_ip6t_get_ctl+0x730/0x1180
>  nf_getsockopt+0x26e/0x290
>  ipv6_getsockopt+0x1ed/0x290
>  do_sock_getsockopt+0x2b4/0x3d0
>  __x64_sys_getsockopt+0x1a5/0x250
>  do_syscall_64+0xfa/0xf80
>  entry_SYSCALL_64_after_hwframe+0x77/0x7f
> RIP: 0033:0x7feba799150a
> Code: ff c3 66 0f 1f 44 00 00 48 c7 c2 a8 ff ff ff f7 d8 64 89 02 b8 ff f=
f ff ff eb b8 0f 1f 44 00 00 49 89 ca b8 37 00 00 00 0f 05 <48> 3d 00 f0 ff=
 ff 77 06 c3 0f 1f 44 00 00 48 c7 c2 a8 ff ff ff f7
> RSP: 002b:00007fff14c6a9e8 EFLAGS: 00000246 ORIG_RAX: 0000000000000037
> RAX: ffffffffffffffda RBX: 0000000000000003 RCX: 00007feba799150a
> RDX: 0000000000000040 RSI: 0000000000000029 RDI: 0000000000000003
> RBP: 0000000000000029 R08: 00007fff14c6aa0c R09: ffffffffff000000
> R10: 00007feba7bb6368 R11: 0000000000000246 R12: 00007feba7a30907
> R13: 00007feba7bb7e60 R14: 00007feba7bb6368 R15: 00007feba7bb6360
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
> The email will later be sent to:
> [axboe@kernel.dk bvanassche@acm.org linux-block@vger.kernel.org ming.lei@=
redhat.com nilay@linux.ibm.com tj@kernel.org yukuai@fnnas.com]
>
> If the report looks fine to you, reply with:
> #syz upstream
>
> --
> You received this message because you are subscribed to the Google Groups=
 "syzkaller-upstream-moderation" group.
> To unsubscribe from this group and stop receiving emails from it, send an=
 email to syzkaller-upstream-moderation+unsubscribe@googlegroups.com.
> To view this discussion visit https://groups.google.com/d/msgid/syzkaller=
-upstream-moderation/692bbc76.050a0220.2ffa18.0015.GAE%40google.com.
