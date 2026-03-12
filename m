Received: from mail-oo1-f43.google.com (mail-oo1-f43.google.com [209.85.161.43])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5B4213A4538
	for <syzbot@lists.linux.dev>; Thu, 12 Mar 2026 09:16:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.161.43
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773307019; cv=pass; b=dTyL//JDMgUurG+6CVGZJem4DEYnSFK+IuaCkh/5atmqBJVKycEkUUPijesxk51rNkgkc3WFWUZhQRTVlTXeqwtVnJD/5fsO2wSbcWGqdSXSbodofpuuQCXRof1pxSdUBvjais3Xqip1lr8kmgF7LtI5QLqxGcxNM8lWSFNXsIU=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773307019; c=relaxed/simple;
	bh=ydFpUkCvRtED9Nv+ggvyywx6NdEs+psWNo/eJU1SFg0=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=nCtVw18BffdO7TKKFUabFSDnSOJrsEXcVqYLkCoDk9jNeRlSTSHrLqHNkD+0Aj5Wa8xQ/1FmcUhpGP6cbb28lCZZzZikRT/y6Gi8fW5TOGf/8ODdg0gO7ACuNnjxWHJwldcitHxh7HJGILbgOG/0+9L7jzNzy0XYZgfSJw+R9tU=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=Blrm5v9C; arc=pass smtp.client-ip=209.85.161.43
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="Blrm5v9C"
Received: by mail-oo1-f43.google.com with SMTP id 006d021491bc7-679b072ed3aso421443eaf.1
        for <syzbot@lists.linux.dev>; Thu, 12 Mar 2026 02:16:57 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1773307016; cv=none;
        d=google.com; s=arc-20240605;
        b=UwJ/sVbYj64jjes5A6GFtgQVtjG2YkowxuDvEA31RDnjYjg0qrkeds2HElj/56CqoZ
         7q9/jF5Fs/4kEtRdjCC33McBEKuuDNxNfbxt25PVbjRwPoQWFiW/BHripcK2UqVfKXvm
         bqO1YyrRv+AZYOSqhZdN9eoRr2X6NXea/sA5VxGsXalHGVsUgltlS6STrYkW8zCaVBbA
         3g3E3PWDa/A8puRQ4c2/dfkDMS1u+msivbHfk9RCpLOPDYqbuYJ4DbMiPEmvNSpids5W
         bML5f2NbYaw8VJbkCKutbE+kl8NzK0Cg1UXrQR5L20Z/0nYmzt9mL6cOlZfnUYj4wXQi
         ISNg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=10hevKvE8dgptsu/tfady8TtJqZSaULbq2RRAuUqmZM=;
        fh=bcRZHoVREPfv6DCkGe8pkl2j5U7d/e0wdBHTKNCHZkk=;
        b=FmA69LnKKrxGTHRovyuax+Kc9zz8xbJCJgfgtPVdGRoiQ61DHyubXGhqTOvmVquO5o
         xOKeIWj13sOChQ0rISi7MyFTik1HIhFy8BsjyGdXmKKz9F4qBm8alRbitF7gqOCDDhCu
         Sj6K+ahlIPN5AcRMhEfBptWGIED/c20MRI1KtV6+7qkB0Uh2IkPvgOkmpmgAeEGn/Dci
         +xlKfk0WvsqBZPKe8k7rwBFMx7jRRxjhYnpdtX4p5IomO3xfC5ZZrQeJefJVleb9gbKT
         BUkLo75zdQDO/vvJxk9m6NchWHXvfFy3RgnGKQCKzQQJFy0x4xjucv9R0KW/EG/Cl98N
         /8bA==;
        darn=lists.linux.dev
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1773307016; x=1773911816; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=10hevKvE8dgptsu/tfady8TtJqZSaULbq2RRAuUqmZM=;
        b=Blrm5v9CEoPexo005UgvcEIlpVIYqCmUDpmCvORw42asrb5iE2lwk0QmrJC1gggypy
         6i+KYtUUeHz+mnXl70ji8g6R43J3kNkUiaiYU7MoMjuKPvQTMWp0aE02Gx9nE/v6p51A
         urAebsVBOWtC6pkQhBsSEhgdctL8wl0O/DrGHqh8uUxuQCyO4T7uh6HIj1TUHPWBJ5oD
         RRjCUuzN/ueVFkaw1B9xNkjrdOqVplOcXbLcNbC4S43YYltb1su3xwO35s67pyM3oVDv
         Q/SooaAJOmUHH6bv+3latfKHVjFZrU+afuOwT+LTqbe6BXuf7revod/qHkvVBQrkHDqd
         ENgQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1773307016; x=1773911816;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=10hevKvE8dgptsu/tfady8TtJqZSaULbq2RRAuUqmZM=;
        b=t5N8z/ozYy9sSJvE3eYm0gZQxkT8HkZjI3uup5eFTTEMrQPl6XKKNcBXyyDM+o6IRm
         rMEj/p/iC1iNNWjVg8KF4WWj3bm0Ts+UjofkAdq9WGNwQrHw9+BW51jsOpUoCNwtCFPL
         5hPhKZyzAWXH805c4k34ncgLRVx4c5J9hJhT/0e9RBZWIixIS4LDIyhOhBUYSxM925al
         PAlvvciQ7R/z7wYnojwx9TreiDtR3/Fv5Fxb2LOFM57wMqX1oLD6B28tlKVDg7/CMZdB
         pzjihu1zqUOiNCLe7yj7NkPK8oktpSx3vJz4xQooqyoAbU7QWQ+oicOA3gCwYZtV0OSK
         idZQ==
X-Forwarded-Encrypted: i=1; AJvYcCVDx0EzwG4ItYvLmOzBs/RFwj8G/bLO62G48h9Bf/js7BY8r/vOF3EDfGa9rhBNMqxfhMgXJF4=@lists.linux.dev
X-Gm-Message-State: AOJu0YyCnKyDhyeh5Oeihh1Lfx8cn0HI/8hF2RwZwxFy6ilTAB59qP8X
	WrfxZL9wGggnIyP2VBgw/rW+UdGVuLS7scH4AFOhnRLzEZvL78xIvniltZ/QUfWgMu5DcOLaOkA
	1Ev4e+6Ppwn/9Po6OULVBQnSM9sTiQKfCvIk5MLuTlo8EEtWyLpEe7QTk83w=
X-Gm-Gg: ATEYQzyyYM2MQtzflsefRR1q1mAHb8G839VtB4YuY3R6wGztdzultKYyXPaGr1J3WFV
	UiDSzj8C1l6cYUyANXgHMSVrYYl7hv3EesVMAMbUoSv6TU/d7X20OO+XP/kiSeJpJViLJBrXGHK
	AqLfQ1+YyVWonvyHNtFdy/ynzDjElcrdG0XmzuJEilXkIN7U82VmxKGT7Jg+UO66X4/jNCB61hJ
	eelJL2vVyCZo/fxU31YEtc1SREmR1OFriNnkOmuGEeeU7sD5StNz+lmAY3DmRPqIzhV0pZh2rM8
	YD5Go6OJHt/TCkJAs9HBGpeB04UhCeidwIGGggq/RQzuON9TXITcymR/2kOKjH3YSRxw
X-Received: by 2002:a05:6820:3092:b0:662:fbdd:1adb with SMTP id
 006d021491bc7-67bc88aa93bmr3715686eaf.25.1773307015765; Thu, 12 Mar 2026
 02:16:55 -0700 (PDT)
Precedence: bulk
X-Mailing-List: syzbot@lists.linux.dev
List-Id: <syzbot.lists.linux.dev>
List-Subscribe: <mailto:syzbot+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:syzbot+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <69b266b6.a00a0220.707e5.0010.GAE@google.com>
In-Reply-To: <69b266b6.a00a0220.707e5.0010.GAE@google.com>
From: Aleksandr Nogikh <nogikh@google.com>
Date: Thu, 12 Mar 2026 09:16:44 +0000
X-Gm-Features: AaiRm51Iivo64YgiS4RKS8A2i1LfSsmJnwN8wNVAgmsRE74yxfmuyS_99pa6Jqo
Message-ID: <CANp29Y5eHrhuq_XtvgzFitHZ+aHe5_jpwSeB+uAVeXY_FiXtAA@mail.gmail.com>
Subject: Re: [moderation/CI] Re: ACPI: Add support for ACPI RAS2 feature table
To: syzbot ci <syzbot+cib6228ea0c23efd95@syzkaller.appspotmail.com>
Cc: syzkaller-upstream-moderation@googlegroups.com, syzbot@lists.linux.dev
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

#syz invalid

On Thu, Mar 12, 2026 at 8:09=E2=80=AFAM syzbot ci
<syzbot+cib6228ea0c23efd95@syzkaller.appspotmail.com> wrote:
>
> syzbot ci has tested the following series
>
> [v17] ACPI: Add support for ACPI RAS2 feature table
> https://lore.kernel.org/all/20260311155518.1000-1-shiju.jose@huawei.com
> * [PATCH v17 1/2] ACPI:RAS2: Add driver for the ACPI RAS2 feature table
> * [PATCH v17 2/2] ras: mem: Add ACPI RAS2 memory driver
>
> and found the following issue:
> KASAN: slab-use-after-free Read in v4l2_fh_open
>
> Full report is available here:
> https://ci.syzbot.org/series/eb46de9e-9391-425e-8ce8-77a4150715c8
>
> ***
>
> KASAN: slab-use-after-free Read in v4l2_fh_open
>
> tree:      mm-new
> URL:       https://kernel.googlesource.com/pub/scm/linux/kernel/git/akpm/=
mm.git
> base:      e2dcf9065536ab4a1b00828ff0d19f7d282dfecc
> arch:      amd64
> compiler:  Debian clang version 21.1.8 (++20251221033036+2078da43e25a-1~e=
xp1~20251221153213.50), Debian LLD 21.1.8
> config:    https://ci.syzbot.org/builds/bfcbf64d-3906-4afb-be91-5827a5981=
b2b/config
> syz repro: https://ci.syzbot.org/findings/734fec16-7250-4a8d-9c1a-16bde68=
a08f9/syz_repro
>
> =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
> BUG: KASAN: slab-use-after-free in v4l2_fh_init drivers/media/v4l2-core/v=
4l2-fh.c:25 [inline]
> BUG: KASAN: slab-use-after-free in v4l2_fh_open+0xac/0x420 drivers/media/=
v4l2-core/v4l2-fh.c:64
> Read of size 8 at addr ffff88816a4c4740 by task v4l_id/6469
>
> CPU: 0 UID: 0 PID: 6469 Comm: v4l_id Not tainted syzkaller #0 PREEMPT(ful=
l)
> Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS 1.16.2-debian-1.=
16.2-1 04/01/2014
> Call Trace:
>  <TASK>
>  dump_stack_lvl+0xe8/0x150 lib/dump_stack.c:120
>  print_address_description mm/kasan/report.c:378 [inline]
>  print_report+0xba/0x230 mm/kasan/report.c:482
>  kasan_report+0x117/0x150 mm/kasan/report.c:595
>  v4l2_fh_init drivers/media/v4l2-core/v4l2-fh.c:25 [inline]
>  v4l2_fh_open+0xac/0x420 drivers/media/v4l2-core/v4l2-fh.c:64
>  em28xx_v4l2_open+0x157/0x9a0 drivers/media/usb/em28xx/em28xx-video.c:215=
3
>  v4l2_open+0x1bf/0x3a0 drivers/media/v4l2-core/v4l2-dev.c:433
>  chrdev_open+0x4cd/0x5e0 fs/char_dev.c:414
>  do_dentry_open+0x7ce/0x1420 fs/open.c:962
>  vfs_open+0x3b/0x340 fs/open.c:1094
>  do_open fs/namei.c:4637 [inline]
>  path_openat+0x3486/0x3e20 fs/namei.c:4796
>  do_filp_open+0x22d/0x490 fs/namei.c:4823
>  do_sys_openat2+0x12f/0x220 fs/open.c:1430
>  do_sys_open fs/open.c:1436 [inline]
>  __do_sys_openat fs/open.c:1452 [inline]
>  __se_sys_openat fs/open.c:1447 [inline]
>  __x64_sys_openat+0x138/0x170 fs/open.c:1447
>  do_syscall_x64 arch/x86/entry/syscall_64.c:63 [inline]
>  do_syscall_64+0xe2/0xf80 arch/x86/entry/syscall_64.c:94
>  entry_SYSCALL_64_after_hwframe+0x77/0x7f
> RIP: 0033:0x7facd3f169a4
> Code: 24 20 48 8d 44 24 30 48 89 44 24 28 64 8b 04 25 18 00 00 00 85 c0 7=
5 2c 44 89 e2 48 89 ee bf 9c ff ff ff b8 01 01 00 00 0f 05 <48> 3d 00 f0 ff=
 ff 76 60 48 8b 15 55 a4 0d 00 f7 d8 64 89 02 48 83
> RSP: 002b:00007fff91448b20 EFLAGS: 00000246 ORIG_RAX: 0000000000000101
> RAX: ffffffffffffffda RBX: 00007fff91448d38 RCX: 00007facd3f169a4
> RDX: 0000000000000000 RSI: 00007fff91449f1b RDI: 00000000ffffff9c
> RBP: 00007fff91449f1b R08: 0000000000000000 R09: 0000000000000000
> R10: 0000000000000000 R11: 0000000000000246 R12: 0000000000000000
> R13: 00007fff91448d50 R14: 000055c4d9189670 R15: 00007facd442da80
>  </TASK>
>
> Allocated by task 6051:
>  kasan_save_stack mm/kasan/common.c:57 [inline]
>  kasan_save_track+0x3e/0x80 mm/kasan/common.c:78
>  poison_kmalloc_redzone mm/kasan/common.c:398 [inline]
>  __kasan_kmalloc+0x93/0xb0 mm/kasan/common.c:415
>  kasan_kmalloc include/linux/kasan.h:263 [inline]
>  __kmalloc_cache_noprof+0x3d1/0x6e0 mm/slub.c:5776
>  kmalloc_noprof include/linux/slab.h:957 [inline]
>  kzalloc_noprof include/linux/slab.h:1094 [inline]
>  em28xx_v4l2_init+0x10b/0x2e70 drivers/media/usb/em28xx/em28xx-video.c:25=
32
>  em28xx_init_extension+0x120/0x1c0 drivers/media/usb/em28xx/em28xx-core.c=
:1117
>  process_one_work kernel/workqueue.c:3257 [inline]
>  process_scheduled_works+0xaec/0x17a0 kernel/workqueue.c:3340
>  worker_thread+0xda6/0x1360 kernel/workqueue.c:3421
>  kthread+0x726/0x8b0 kernel/kthread.c:463
>  ret_from_fork+0x51b/0xa40 arch/x86/kernel/process.c:158
>  ret_from_fork_asm+0x1a/0x30 arch/x86/entry/entry_64.S:246
>
> Freed by task 6051:
>  kasan_save_stack mm/kasan/common.c:57 [inline]
>  kasan_save_track+0x3e/0x80 mm/kasan/common.c:78
>  kasan_save_free_info+0x46/0x50 mm/kasan/generic.c:584
>  poison_slab_object mm/kasan/common.c:253 [inline]
>  __kasan_slab_free+0x5c/0x80 mm/kasan/common.c:285
>  kasan_slab_free include/linux/kasan.h:235 [inline]
>  slab_free_hook mm/slub.c:2540 [inline]
>  slab_free mm/slub.c:6670 [inline]
>  kfree+0x1be/0x650 mm/slub.c:6878
>  em28xx_free_v4l2 drivers/media/usb/em28xx/em28xx-video.c:2118 [inline]
>  kref_put include/linux/kref.h:65 [inline]
>  em28xx_v4l2_init+0x1683/0x2e70 drivers/media/usb/em28xx/em28xx-video.c:2=
901
>  em28xx_init_extension+0x120/0x1c0 drivers/media/usb/em28xx/em28xx-core.c=
:1117
>  process_one_work kernel/workqueue.c:3257 [inline]
>  process_scheduled_works+0xaec/0x17a0 kernel/workqueue.c:3340
>  worker_thread+0xda6/0x1360 kernel/workqueue.c:3421
>  kthread+0x726/0x8b0 kernel/kthread.c:463
>  ret_from_fork+0x51b/0xa40 arch/x86/kernel/process.c:158
>  ret_from_fork_asm+0x1a/0x30 arch/x86/entry/entry_64.S:246
>
> The buggy address belongs to the object at ffff88816a4c4000
>  which belongs to the cache kmalloc-8k of size 8192
> The buggy address is located 1856 bytes inside of
>  freed 8192-byte region [ffff88816a4c4000, ffff88816a4c6000)
>
> The buggy address belongs to the physical page:
> page: refcount:0 mapcount:0 mapping:0000000000000000 index:0x0 pfn:0x16a4=
c0
> head: order:3 mapcount:0 entire_mapcount:0 nr_pages_mapped:0 pincount:0
> anon flags: 0x57ff00000000040(head|node=3D1|zone=3D2|lastcpupid=3D0x7ff)
> page_type: f5(slab)
> raw: 057ff00000000040 ffff888100042280 0000000000000000 dead000000000001
> raw: 0000000000000000 0000000080020002 00000000f5000000 0000000000000000
> head: 057ff00000000040 ffff888100042280 0000000000000000 dead000000000001
> head: 0000000000000000 0000000080020002 00000000f5000000 0000000000000000
> head: 057ff00000000003 ffffea0005a93001 00000000ffffffff 00000000ffffffff
> head: ffffffffffffffff 0000000000000000 00000000ffffffff 0000000000000008
> page dumped because: kasan: bad access detected
> page_owner tracks the page as allocated
> page last allocated via order 3, migratetype Unmovable, gfp_mask 0xd20c0(=
__GFP_IO|__GFP_FS|__GFP_NOWARN|__GFP_NORETRY|__GFP_COMP|__GFP_NOMEMALLOC), =
pid 5576, tgid 5576 (dhcpcd), ts 38711334781, free_ts 38591924367
>  set_page_owner include/linux/page_owner.h:32 [inline]
>  post_alloc_hook+0x228/0x280 mm/page_alloc.c:1857
>  prep_new_page mm/page_alloc.c:1865 [inline]
>  get_page_from_freelist+0x24dc/0x2580 mm/page_alloc.c:3915
>  __alloc_frozen_pages_noprof+0x18d/0x380 mm/page_alloc.c:5210
>  alloc_pages_mpol+0x232/0x4a0 mm/mempolicy.c:2486
>  alloc_slab_page mm/slub.c:3075 [inline]
>  allocate_slab+0x86/0x3a0 mm/slub.c:3248
>  new_slab mm/slub.c:3302 [inline]
>  ___slab_alloc+0xd82/0x1760 mm/slub.c:4656
>  __slab_alloc+0x65/0x100 mm/slub.c:4779
>  __slab_alloc_node mm/slub.c:4855 [inline]
>  slab_alloc_node mm/slub.c:5251 [inline]
>  __do_kmalloc_node mm/slub.c:5656 [inline]
>  __kmalloc_node_track_caller_noprof+0x5b7/0x7f0 mm/slub.c:5764
>  kmalloc_reserve+0x136/0x290 net/core/skbuff.c:608
>  __alloc_skb+0x204/0x390 net/core/skbuff.c:690
>  alloc_skb include/linux/skbuff.h:1383 [inline]
>  nlmsg_new include/net/netlink.h:1055 [inline]
>  nl80211_get_wiphy+0x77/0x210 net/wireless/nl80211.c:3445
>  genl_family_rcv_msg_doit+0x22a/0x330 net/netlink/genetlink.c:1115
>  genl_family_rcv_msg net/netlink/genetlink.c:1195 [inline]
>  genl_rcv_msg+0x61c/0x7a0 net/netlink/genetlink.c:1210
>  netlink_rcv_skb+0x232/0x4b0 net/netlink/af_netlink.c:2550
>  genl_rcv+0x28/0x40 net/netlink/genetlink.c:1219
>  netlink_unicast_kernel net/netlink/af_netlink.c:1318 [inline]
>  netlink_unicast+0x80f/0x9b0 net/netlink/af_netlink.c:1344
> page last free pid 5693 tgid 5693 stack trace:
>  reset_page_owner include/linux/page_owner.h:25 [inline]
>  free_pages_prepare mm/page_alloc.c:1406 [inline]
>  __free_frozen_pages+0xbf8/0xd70 mm/page_alloc.c:2943
>  discard_slab mm/slub.c:3346 [inline]
>  __put_partials+0x146/0x170 mm/slub.c:3886
>  __slab_free+0x294/0x320 mm/slub.c:5952
>  qlink_free mm/kasan/quarantine.c:163 [inline]
>  qlist_free_all+0x97/0x100 mm/kasan/quarantine.c:179
>  kasan_quarantine_reduce+0x148/0x160 mm/kasan/quarantine.c:286
>  __kasan_slab_alloc+0x22/0x80 mm/kasan/common.c:350
>  kasan_slab_alloc include/linux/kasan.h:253 [inline]
>  slab_post_alloc_hook mm/slub.c:4953 [inline]
>  slab_alloc_node mm/slub.c:5263 [inline]
>  kmem_cache_alloc_noprof+0x370/0x6e0 mm/slub.c:5270
>  getname_flags+0xb7/0x540 fs/namei.c:146
>  getname include/linux/fs.h:2498 [inline]
>  do_sys_openat2+0xca/0x220 fs/open.c:1426
>  do_sys_open fs/open.c:1436 [inline]
>  __do_sys_openat fs/open.c:1452 [inline]
>  __se_sys_openat fs/open.c:1447 [inline]
>  __x64_sys_openat+0x138/0x170 fs/open.c:1447
>  do_syscall_x64 arch/x86/entry/syscall_64.c:63 [inline]
>  do_syscall_64+0xe2/0xf80 arch/x86/entry/syscall_64.c:94
>  entry_SYSCALL_64_after_hwframe+0x77/0x7f
>
> Memory state around the buggy address:
>  ffff88816a4c4600: fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb
>  ffff88816a4c4680: fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb
> >ffff88816a4c4700: fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb
>                                            ^
>  ffff88816a4c4780: fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb
>  ffff88816a4c4800: fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb
> =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
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
> [akpm@linux-foundation.org bp@alien8.de dave.hansen@linux.intel.com dferg=
uson@amperecomputing.com duenwen@google.com erdemaktas@google.com gthelen@g=
oogle.com james.morse@arm.com jiaqiyan@google.com jon.grimm@amd.com jonatha=
n.cameron@huawei.com jthoughton@google.com kangkang.shen@futurewei.com lenb=
@kernel.org leo.duran@amd.com linux-acpi@vger.kernel.org linux-doc@vger.ker=
nel.org linux-edac@vger.kernel.org linux-mm@kvack.org linuxarm@huawei.com m=
chehab@kernel.org naoya.horiguchi@nec.com nifan.cxl@gmail.com pgonda@google=
.com prime.zeng@hisilicon.com rafael@kernel.org rientjes@google.com roberto=
.sassu@huawei.com rppt@kernel.org shiju.jose@huawei.com somasundaram.a@hpe.=
com tanxiaofei@huawei.com tony.luck@intel.com wanghuiqiang@huawei.com wbs@o=
s.amperecomputing.com wschwartz@amperecomputing.com yazen.ghannam@amd.com]
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
-upstream-moderation/69b266b6.a00a0220.707e5.0010.GAE%40google.com.
