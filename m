Received: from mail-oo1-f47.google.com (mail-oo1-f47.google.com [209.85.161.47])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2201C37DE8C
	for <syzbot@lists.linux.dev>; Mon, 13 Apr 2026 07:35:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.161.47
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776065751; cv=pass; b=UEVD4UNq6PRibiQ6NX8ALu9sTLkVx6EudZ2xC53a3kOb/9yNIpxMF4MGLBr5wUIZE4eM/4d1cKf5gpDvHBGQuqLJdC9VDX1TNfuhrPCwfCmtTc6zK+g4itjrO+PcebU7/pWvGVbGuqQve2LFV97Itbskn6ebWWu3DcP5UIdG0Sk=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776065751; c=relaxed/simple;
	bh=taQ7qLNSsht7H9K+n2F+oG/ZWXlq5FzWAiTZoH/4C7A=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=UUKhFTY3QVbVjh8IKNTRZZ31jHW4FHWNosLKYlcJHNrRA+0G6imwyQkBu9DzNZwjA4hyvSl4ghzzA7iuxY9xeT/D2LS0k6zsfLufjnvfs0ezDRiI4FBpAAvSdnwRHShfiU33s6/e7507jHPtC0NQlYr7oxPexTiKh7yxwpoo4Eg=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=LmTE+qVS; arc=pass smtp.client-ip=209.85.161.47
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="LmTE+qVS"
Received: by mail-oo1-f47.google.com with SMTP id 006d021491bc7-682d981b025so2350787eaf.3
        for <syzbot@lists.linux.dev>; Mon, 13 Apr 2026 00:35:49 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1776065749; cv=none;
        d=google.com; s=arc-20240605;
        b=JYzCgtVI0zzQ+f+e5B/Kd18LoGvuZhkumRzSAT6j+NYTEQtt+4jy0w9uyUSptKj8Xs
         Jy+QQ1uZ7vidUwaEAptznHdyik5+P4dbNSSNdz2lpBBiBXZXZA+fwxE2ilyrHHxZgAeo
         AXwsP7QEUgT/PnXnvL2g8v/xgkPOJ33HsvXHcvRpu4Kw1RAct/ZkB7oUMbneleMvBrR7
         c+JeahqBstnD1uEjVC0yZZHtFN4tYLyRHWUL68I4HY92WPUrrYLiHLAMnC2Kryt7AShA
         K+KUlRFNSY96YsYm+732oAoNu27tCHuNq3GkB/G55++fkiDkhFLyyUdDyS6jYmkC2I78
         ZjRg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=kezrw2JGPEvA198hCsZDRzF24uP0AMBi+Q65L1vrLN0=;
        fh=MA+pgZVc4sapjUb0Pjz9NIcHYIuI6Z5Y4/WzeB0yy0c=;
        b=I/Ii6lPv22fhxxFO2zwOYKZLwYgh353c4lz+emwcNcVYpHaRwJBzSwrXmFtdL2n1Xx
         Unukmk3fe12A9vecUcGoBXvwO6e31SCVFP/fA0GtSNNu4fT6TJu0bRgfzWt/IcKGE8CM
         hBA4T7KYDlv40y/3idY7oU38hwGz86CfYKJGlBbPZGPoWE+Z7Rj2829GBn6aTiiB1GoB
         Z891L5mgHlrvFwBIex7sg1aiVPxjLkJVn1dTlAuEfC1J4VE7gRQX0HuLYdGiWtrXO2Ey
         1I+vZ1PeDqumNsKU7pzD+wSw1QrLUkpdHbpC1QBtlv9thQspkCZNnwaAsupBJkra2fLM
         kZnw==;
        darn=lists.linux.dev
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1776065749; x=1776670549; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=kezrw2JGPEvA198hCsZDRzF24uP0AMBi+Q65L1vrLN0=;
        b=LmTE+qVSFt2+TibCzNiUwzoejztPWHXAomHOtB7PIkmh/tKSsiRZeuzD5s3N6llvyD
         IsmoIvJn09mSxVL3bFCOyJ81mimiyJcBKqj4hd0QhwH5ZWopF1zpJ6vE9GNvG3sVsMsG
         oAxo6tRV5dGEJiS4e6j+uY6J7Pu4OXLnaM/s4ub1ac9RCZE0Ub0QDof/oGOY/uOwkRzr
         YgmLVx/P7aP5AQ00vsGHvhlypiMa4glvSp47yKM2i5uJFw246xCLg2jD0jP3Uw7C/4x6
         zEOlL95/D7pxi7vi3IIKw893pS/3lbhif+veY7SbeRiRp3YKC8uOYcU3pQrnB8ReVcAf
         4ACQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1776065749; x=1776670549;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=kezrw2JGPEvA198hCsZDRzF24uP0AMBi+Q65L1vrLN0=;
        b=M2TFEUVvN2mUKBTNpc/5JfUacAv5BD6wHYUAXrwS8d0QGvffMH53qRZsrs3va11zBq
         Fp8486rP6baJAR0xDcC7f4d4kj3hF41HUgXbGeg7aQpe9lwFjQ2xqS2ITZVPeBTp+HR0
         1UR6GAWdJtGdUyg8laCq2a4YRsUXkotQ5tWOgXcHNUV3J3KcUqWeofL2W9gYbeX2DtR5
         7bAzSB3dNOhCZ1yIb5TFFlkz/l8Eu+JqtxtPxeGCouWKsc4JMdPqf7Gu3RfvZWtfjNGC
         yqdxknvXNxfLNJ9OyFF5zqWMhmc5SNq7zVVJsLWl0cH+N5iK6BJTBxxIvq+mXSP9YAp2
         8riA==
X-Forwarded-Encrypted: i=1; AJvYcCUrCsBBccp7ihCZENknnGNM/tq7K9/u/l8CIZ0NDnZ9ylzIEkP4QG760RCyJ5yrBBXgPkePgS4=@lists.linux.dev
X-Gm-Message-State: AOJu0YxmxXaDS1ryMJA5J9AruBYlh++hoJs9Eth5ufi4qex5lb0mFFiA
	XiM57INby16msxhVpw7kwYFSRm9RLaIHM9mV6AL//lMrpD3lByR7metokWclvZmDEANr7QCTBen
	3WcVtmk/5c1I4jeHhpAfg5RsXqkbitghQcMWmsQBW
X-Gm-Gg: AeBDieuOWgb265Z8mFOzFYhDSyXl/YIbZUitgxtH/SpjY36Lqkw1DabxeP4YRs1mrio
	yfdsclfzMpOxtWTQcp5HlMERMdENd4NcE6JbqhiI/jm4YvKs7EFqr+v+PbN6gXki6i661c9jeqk
	xP9t6P7v1Z4g9MdaiGLCTIDHsgSP/zKu6k2lpILLSLHU8aNpSK6rDpZUO3CzEQBXnUvJ9zQ4Kmv
	ZrWGh2edMawqtUjUDH2G8qJfXKu+UjvDB7nt7eCVvCaNzR/sDgeIlsSgPzckSHqY5W/xpefxSp+
	zt0ghxwuT+hsdFTpWBHiR3P6dUFCSxPTu6z2Pa9p+LbSSgrz2G7TUEa00/crsRiDfMCej32bykh
	FYjY=
X-Received: by 2002:a05:6820:c086:b0:67e:3967:16a6 with SMTP id
 006d021491bc7-68be80df829mr4161662eaf.39.1776065748205; Mon, 13 Apr 2026
 00:35:48 -0700 (PDT)
Precedence: bulk
X-Mailing-List: syzbot@lists.linux.dev
List-Id: <syzbot.lists.linux.dev>
List-Subscribe: <mailto:syzbot+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:syzbot+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <69dc1c7f.a00a0220.468cb.003e.GAE@google.com>
In-Reply-To: <69dc1c7f.a00a0220.468cb.003e.GAE@google.com>
From: Aleksandr Nogikh <nogikh@google.com>
Date: Mon, 13 Apr 2026 09:35:34 +0200
X-Gm-Features: AQROBzAVqmL9WUTlMZYqJmfzirrnCVynfMNbQxmpieXgTOmTuvIgeyhvtlfdIUk
Message-ID: <CANp29Y4vma3QzSWVxmC0Lzk+Z+0KODAOZ1Zn=xUECLkzFYv4_A@mail.gmail.com>
Subject: Re: [moderation/CI] Re: Implement a new generic pagewalk API
To: syzbot ci <syzbot+cif2f54dd12749875d@syzkaller.appspotmail.com>
Cc: syzkaller-upstream-moderation@googlegroups.com, syzbot@lists.linux.dev
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

#syz upstream

On Mon, Apr 13, 2026 at 12:28=E2=80=AFAM syzbot ci
<syzbot+cif2f54dd12749875d@syzkaller.appspotmail.com> wrote:
>
> syzbot ci has tested the following series
>
> [v1] Implement a new generic pagewalk API
> https://lore.kernel.org/all/20260412174244.133715-1-osalvador@suse.de
> * [RFC PATCH 1/7] mm: Add softleaf_from_pud
> * [RFC PATCH 2/7] mm: Add {pmd,pud}_huge_lock helper
> * [RFC PATCH 3/7] mm: Implement folio_pmd_batch
> * [RFC PATCH 4/7] mm: Implement pt_range_walk
> * [RFC PATCH 5/7] mm: Make /proc/pid/smaps use the new generic pagewalk A=
PI
> * [RFC PATCH 6/7] mm: Make /proc/pid/numa_maps use the new generic pagewa=
lk API
> * [RFC PATCH 7/7] mm: Make /proc/pid/pagemap use the new generic pagewalk=
 API
>
> and found the following issues:
> * KASAN: slab-out-of-bounds Write in pagemap_read
> * WARNING in pt_range_walk
>
> Full report is available here:
> https://ci.syzbot.org/series/1f85248a-1ac0-48e8-8ce3-edb89a6b9ee5
>
> ***
>
> KASAN: slab-out-of-bounds Write in pagemap_read
>
> tree:      torvalds
> URL:       https://kernel.googlesource.com/pub/scm/linux/kernel/git/torva=
lds/linux
> base:      857fa8f2a5b184c206c703a3d9ce05cea683cfed
> arch:      amd64
> compiler:  Debian clang version 21.1.8 (++20251221033036+2078da43e25a-1~e=
xp1~20251221153213.50), Debian LLD 21.1.8
> config:    https://ci.syzbot.org/builds/932ed80d-9fb1-4c99-8096-4b7a9324b=
b7c/config
> syz repro: https://ci.syzbot.org/findings/1083a63d-0470-4ce7-8943-0a60046=
b9269/syz_repro
>
> =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
> BUG: KASAN: slab-out-of-bounds in add_to_pagemap fs/proc/task_mmu.c:1740 =
[inline]
> BUG: KASAN: slab-out-of-bounds in pagemap_read_walk_range fs/proc/task_mm=
u.c:2736 [inline]
> BUG: KASAN: slab-out-of-bounds in pagemap_read+0x19bc/0x21a0 fs/proc/task=
_mmu.c:2829
> Write of size 8 at addr ffff88816d32b000 by task syz.0.17/5958
>
> CPU: 0 UID: 0 PID: 5958 Comm: syz.0.17 Not tainted syzkaller #0 PREEMPT(f=
ull)
> Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS 1.16.2-debian-1.=
16.2-1 04/01/2014
> Call Trace:
>  <TASK>
>  dump_stack_lvl+0xe8/0x150 lib/dump_stack.c:120
>  print_address_description mm/kasan/report.c:378 [inline]
>  print_report+0xba/0x230 mm/kasan/report.c:482
>  kasan_report+0x117/0x150 mm/kasan/report.c:595
>  add_to_pagemap fs/proc/task_mmu.c:1740 [inline]
>  pagemap_read_walk_range fs/proc/task_mmu.c:2736 [inline]
>  pagemap_read+0x19bc/0x21a0 fs/proc/task_mmu.c:2829
>  vfs_read+0x20c/0xa70 fs/read_write.c:572
>  ksys_pread64 fs/read_write.c:765 [inline]
>  __do_sys_pread64 fs/read_write.c:773 [inline]
>  __se_sys_pread64 fs/read_write.c:770 [inline]
>  __x64_sys_pread64+0x199/0x230 fs/read_write.c:770
>  do_syscall_x64 arch/x86/entry/syscall_64.c:63 [inline]
>  do_syscall_64+0x14d/0xf80 arch/x86/entry/syscall_64.c:94
>  entry_SYSCALL_64_after_hwframe+0x77/0x7f
> RIP: 0033:0x7fd47239c819
> Code: ff c3 66 2e 0f 1f 84 00 00 00 00 00 0f 1f 44 00 00 48 89 f8 48 89 f=
7 48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 ff=
 ff 73 01 c3 48 c7 c1 e8 ff ff ff f7 d8 64 89 01 48
> RSP: 002b:00007fd473284028 EFLAGS: 00000246 ORIG_RAX: 0000000000000011
> RAX: ffffffffffffffda RBX: 00007fd472615fa0 RCX: 00007fd47239c819
> RDX: 0000000000019000 RSI: 0000200000000200 RDI: 0000000000000003
> RBP: 00007fd472432c91 R08: 0000000000000000 R09: 0000000000000000
> R10: 0000001000000000 R11: 0000000000000246 R12: 0000000000000000
> R13: 00007fd472616038 R14: 00007fd472615fa0 R15: 00007ffe3c81aa88
>  </TASK>
>
> Allocated by task 5958:
>  kasan_save_stack mm/kasan/common.c:57 [inline]
>  kasan_save_track+0x3e/0x80 mm/kasan/common.c:78
>  poison_kmalloc_redzone mm/kasan/common.c:398 [inline]
>  __kasan_kmalloc+0x93/0xb0 mm/kasan/common.c:415
>  kasan_kmalloc include/linux/kasan.h:263 [inline]
>  __kmalloc_cache_noprof+0x31c/0x660 mm/slub.c:5339
>  kmalloc_noprof include/linux/slab.h:962 [inline]
>  kmalloc_array_noprof include/linux/slab.h:1109 [inline]
>  pagemap_read+0x287/0x21a0 fs/proc/task_mmu.c:2781
>  vfs_read+0x20c/0xa70 fs/read_write.c:572
>  ksys_pread64 fs/read_write.c:765 [inline]
>  __do_sys_pread64 fs/read_write.c:773 [inline]
>  __se_sys_pread64 fs/read_write.c:770 [inline]
>  __x64_sys_pread64+0x199/0x230 fs/read_write.c:770
>  do_syscall_x64 arch/x86/entry/syscall_64.c:63 [inline]
>  do_syscall_64+0x14d/0xf80 arch/x86/entry/syscall_64.c:94
>  entry_SYSCALL_64_after_hwframe+0x77/0x7f
>
> The buggy address belongs to the object at ffff88816d32a000
>  which belongs to the cache kmalloc-4k of size 4096
> The buggy address is located 0 bytes to the right of
>  allocated 4096-byte region [ffff88816d32a000, ffff88816d32b000)
>
> The buggy address belongs to the physical page:
> page: refcount:0 mapcount:0 mapping:0000000000000000 index:0x0 pfn:0x16d3=
28
> head: order:3 mapcount:0 entire_mapcount:0 nr_pages_mapped:0 pincount:0
> flags: 0x57ff00000000040(head|node=3D1|zone=3D2|lastcpupid=3D0x7ff)
> page_type: f5(slab)
> raw: 057ff00000000040 ffff888100042140 dead000000000100 dead000000000122
> raw: 0000000000000000 0000000000040004 00000000f5000000 0000000000000000
> head: 057ff00000000040 ffff888100042140 dead000000000100 dead000000000122
> head: 0000000000000000 0000000000040004 00000000f5000000 0000000000000000
> head: 057ff00000000003 ffffea0005b4ca01 00000000ffffffff 00000000ffffffff
> head: ffffffffffffffff 0000000000000000 00000000ffffffff 0000000000000008
> page dumped because: kasan: bad access detected
> page_owner tracks the page as allocated
> page last allocated via order 3, migratetype Unmovable, gfp_mask 0xd20c0(=
__GFP_IO|__GFP_FS|__GFP_NOWARN|__GFP_NORETRY|__GFP_COMP|__GFP_NOMEMALLOC), =
pid 1, tgid 1 (swapper/0), ts 20801987900, free_ts 13278585415
>  set_page_owner include/linux/page_owner.h:32 [inline]
>  post_alloc_hook+0x231/0x280 mm/page_alloc.c:1889
>  prep_new_page mm/page_alloc.c:1897 [inline]
>  get_page_from_freelist+0x24dc/0x2580 mm/page_alloc.c:3962
>  __alloc_frozen_pages_noprof+0x18d/0x380 mm/page_alloc.c:5250
>  alloc_slab_page mm/slub.c:3255 [inline]
>  allocate_slab+0x77/0x660 mm/slub.c:3444
>  new_slab mm/slub.c:3502 [inline]
>  refill_objects+0x331/0x3c0 mm/slub.c:7134
>  refill_sheaf mm/slub.c:2804 [inline]
>  __pcs_replace_empty_main+0x2b9/0x620 mm/slub.c:4578
>  alloc_from_pcs mm/slub.c:4681 [inline]
>  slab_alloc_node mm/slub.c:4815 [inline]
>  __kmalloc_cache_noprof+0x392/0x660 mm/slub.c:5334
>  kmalloc_noprof include/linux/slab.h:962 [inline]
>  kzalloc_noprof include/linux/slab.h:1200 [inline]
>  kobject_uevent_env+0x28c/0x9e0 lib/kobject_uevent.c:540
>  driver_register+0x2d4/0x320 drivers/base/driver.c:257
>  usb_register_driver+0x1e4/0x390 drivers/usb/core/driver.c:1078
>  hid_init+0x39/0x70 drivers/hid/usbhid/hid-core.c:1710
>  do_one_initcall+0x250/0x8d0 init/main.c:1382
>  do_initcall_level+0x104/0x190 init/main.c:1444
>  do_initcalls+0x59/0xa0 init/main.c:1460
>  kernel_init_freeable+0x2a6/0x3e0 init/main.c:1692
>  kernel_init+0x1d/0x1d0 init/main.c:1582
> page last free pid 10 tgid 10 stack trace:
>  reset_page_owner include/linux/page_owner.h:25 [inline]
>  __free_pages_prepare mm/page_alloc.c:1433 [inline]
>  __free_frozen_pages+0xc2b/0xdb0 mm/page_alloc.c:2978
>  vfree+0x25a/0x400 mm/vmalloc.c:3479
>  delayed_vfree_work+0x55/0x80 mm/vmalloc.c:3398
>  process_one_work kernel/workqueue.c:3275 [inline]
>  process_scheduled_works+0xb02/0x1830 kernel/workqueue.c:3358
>  worker_thread+0xa50/0xfc0 kernel/workqueue.c:3439
>  kthread+0x388/0x470 kernel/kthread.c:467
>  ret_from_fork+0x51e/0xb90 arch/x86/kernel/process.c:158
>  ret_from_fork_asm+0x1a/0x30 arch/x86/entry/entry_64.S:245
>
> Memory state around the buggy address:
>  ffff88816d32af00: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
>  ffff88816d32af80: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
> >ffff88816d32b000: fc fc fc fc fc fc fc fc fc fc fc fc fc fc fc fc
>                    ^
>  ffff88816d32b080: fc fc fc fc fc fc fc fc fc fc fc fc fc fc fc fc
>  ffff88816d32b100: fc fc fc fc fc fc fc fc fc fc fc fc fc fc fc fc
> =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
>
>
> ***
>
> WARNING in pt_range_walk
>
> tree:      torvalds
> URL:       https://kernel.googlesource.com/pub/scm/linux/kernel/git/torva=
lds/linux
> base:      857fa8f2a5b184c206c703a3d9ce05cea683cfed
> arch:      amd64
> compiler:  Debian clang version 21.1.8 (++20251221033036+2078da43e25a-1~e=
xp1~20251221153213.50), Debian LLD 21.1.8
> config:    https://ci.syzbot.org/builds/932ed80d-9fb1-4c99-8096-4b7a9324b=
b7c/config
> syz repro: https://ci.syzbot.org/findings/e7c203a3-133f-4435-b9ed-ee292b6=
685fe/syz_repro
>
> ------------[ cut here ]------------
> next_addr < vma->vm_start || next_addr >=3D vma->vm_end
> WARNING: mm/pagewalk.c:1052 at pt_range_walk+0x145/0x35f0 mm/pagewalk.c:1=
052, CPU#1: syz.1.18/6005
> Modules linked in:
> CPU: 1 UID: 0 PID: 6005 Comm: syz.1.18 Not tainted syzkaller #0 PREEMPT(f=
ull)
> Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS 1.16.2-debian-1.=
16.2-1 04/01/2014
> RIP: 0010:pt_range_walk+0x145/0x35f0 mm/pagewalk.c:1052
> Code: df e8 9f 1a 15 00 49 89 dc 48 8b 1b 4c 89 ff 48 89 de e8 7e a5 aa f=
f 49 39 df 4c 89 b4 24 38 01 00 00 73 14 e8 0c a3 aa ff 90 <0f> 0b 90 41 be=
 01 00 00 00 e9 e5 21 00 00 49 8d 5c 24 08 48 89 d8
> RSP: 0018:ffffc90003a279a0 EFLAGS: 00010293
> RAX: ffffffff821b140c RBX: 0000200001000000 RCX: ffff8881027a5700
> RDX: 0000000000000000 RSI: 0000200001000000 RDI: 0000200001000000
> RBP: ffffc90003a27bb0 R08: 00000000000000ff R09: 0000000000000003
> R10: 0000000000000002 R11: 0000000000000000 R12: ffff888105317380
> R13: dffffc0000000000 R14: 1ffff92000744f60 R15: 0000200001000000
> FS:  00007f0ccbd736c0(0000) GS:ffff8882a9467000(0000) knlGS:0000000000000=
000
> CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> CR2: 00007f0ccb04edd5 CR3: 0000000115dba000 CR4: 00000000000006f0
> Call Trace:
>  <TASK>
>  pagemap_scan_walk fs/proc/task_mmu.c:2479 [inline]
>  do_pagemap_scan fs/proc/task_mmu.c:2573 [inline]
>  do_pagemap_cmd+0xfd5/0x2600 fs/proc/task_mmu.c:2869
>  vfs_ioctl fs/ioctl.c:51 [inline]
>  __do_sys_ioctl fs/ioctl.c:597 [inline]
>  __se_sys_ioctl+0xfc/0x170 fs/ioctl.c:583
>  do_syscall_x64 arch/x86/entry/syscall_64.c:63 [inline]
>  do_syscall_64+0x14d/0xf80 arch/x86/entry/syscall_64.c:94
>  entry_SYSCALL_64_after_hwframe+0x77/0x7f
> RIP: 0033:0x7f0ccaf9c819
> Code: ff c3 66 2e 0f 1f 84 00 00 00 00 00 0f 1f 44 00 00 48 89 f8 48 89 f=
7 48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 ff=
 ff 73 01 c3 48 c7 c1 e8 ff ff ff f7 d8 64 89 01 48
> RSP: 002b:00007f0ccbd73028 EFLAGS: 00000246 ORIG_RAX: 0000000000000010
> RAX: ffffffffffffffda RBX: 00007f0ccb215fa0 RCX: 00007f0ccaf9c819
> RDX: 0000200000000100 RSI: 00000000c0606610 RDI: 0000000000000003
> RBP: 00007f0ccb032c91 R08: 0000000000000000 R09: 0000000000000000
> R10: 0000000000000000 R11: 0000000000000246 R12: 0000000000000000
> R13: 00007f0ccb216038 R14: 00007f0ccb215fa0 R15: 00007ffd9c7ebb48
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
> To test a patch for this bug, please reply with `#syz test`
> (should be on a separate line).
>
> The patch should be attached to the email.
> Note: arguments like custom git repos and branches are not supported.
>
> The email will later be sent to:
> [akpm@linux-foundation.org david@kernel.org david@redhat.com linux-kernel=
@vger.kernel.org linux-mm@kvack.org lorenzo.stoakes@oracle.com mhocko@suse.=
com muchun.song@linux.dev osalvador@suse.de vbabka@kernel.org]
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
-upstream-moderation/69dc1c7f.a00a0220.468cb.003e.GAE%40google.com.
