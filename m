Received: from mail-oi1-f173.google.com (mail-oi1-f173.google.com [209.85.167.173])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CFA5263CB
	for <syzbot@lists.linux.dev>; Sat, 18 Apr 2026 06:45:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.167.173
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776494751; cv=pass; b=soimN5PhvIHxsbclS4hrEbGBLaq5biNS5dAu0k+8k5E2lSKK2fFrP6dgAOwVRCI8inw6FmzUMTEFEvGxRa0ec/L/PNafvKc6NUumQO4K9cKDNWDpgj07lWrfgnHLP67WKZfBSfo2hpaLwZqsjBmPlic/yrGdm2qVVH5EXlLhCTA=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776494751; c=relaxed/simple;
	bh=PYMqS5hJvTH+G6xwcQAtsgBs4+Cidz/2k3oShyyL9lM=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=Vsv7ia66zq44m3BEFvkN5lfWAu8oYjgl/9hCb5cksts5q3dFwLsDvoCHHuo0dzmnccs56nhk0zeO4TLAqENrqjA/ZlI65kbOHeOjogp6zMTQIyeJ64Ch6LIRGeP3I3LNoz3vhC53oxlTyItYRWIyOJfff/bhqxqlSRlecul8ai4=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=SyiS8SPE; arc=pass smtp.client-ip=209.85.167.173
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="SyiS8SPE"
Received: by mail-oi1-f173.google.com with SMTP id 5614622812f47-47018d34159so960200b6e.2
        for <syzbot@lists.linux.dev>; Fri, 17 Apr 2026 23:45:48 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1776494748; cv=none;
        d=google.com; s=arc-20240605;
        b=ivdSipRoQWhuBOlHIm6fp5cRm63F1lfSAso+3P4fLul0ix4tdsOPFQxQUfoF1wCIqv
         S7RmHUcDREDhNqdXaXBzrYP2GgMLlzT3NrbnwNATkxTK9FwlmaHYwHRgsBSox3q8FMy4
         VwucLKO2zLrITLhmcAwXc11fbp3L7nj8x2NQUy6x7vnz+ejLngWUaBowLFmIZHwuk01Y
         gWRCXXaNgIhywnk26ppKka3q+Qf3N1HbJHRNkyJDcTi1Ml6xHP9PPoW/lMXMAYoLsHnL
         RvhPpTAo47vQXpa9gas90eNqU7e8Pp746YAJBWdT21N0Dmcnfc/XlDRcRQFNFit9tBzj
         w6KA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=39M7+KeJmT4lMyccAvgwolT2IgOurmSRT1xXmikz91I=;
        fh=PMvYV5Tt9zVHZYqnPSU3xWg9tmS3wF7NE10wdQ6m/8U=;
        b=X+PzG6489X2cSGta5EwH7tfUa+s8ZVJfR9zQGTNH924iHpsIBxpabH6MTNaPkSHqhq
         LHedmvxCJBFFQ/SGzzXodfzO3RLRgtgZ4kx1NSM3xZ5NwozXXoRuRdlmg9KD2zlGyN9H
         s3xK3nsea2Gyectgu0iMktMHWCzhZwHooYX1PXJUXXN3dSaGDF3jJ59mSXqtXu5UVv2Y
         YdNgzWsfOprix6yMRvQV+nPAjpcEuI4Q1NY57GSdZmEXoiN2I6VKzM32Vde3gMrq4E3D
         Lmc/xy4hAOFRYZ+wbUKSUw7r4Ne87pdjV4kYLFkIJ1g7yGoEoIm4EhAovM/fUyAa4A+Q
         M5eQ==;
        darn=lists.linux.dev
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1776494748; x=1777099548; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=39M7+KeJmT4lMyccAvgwolT2IgOurmSRT1xXmikz91I=;
        b=SyiS8SPEDpIP3+UnCob9o/j9u8BtPsz4wdzgUNMks0Ae9DKr9Md6LH7u3VVTvfFywJ
         Ut7dzLeHyimJ7/sXpTH+AVjTELGCcB1bWm8QqvNrV8H+KMmKxZLmxlj3KbYQpCtPpr1j
         GcSmEuQA/fBb0KfbXjbZFfqKafzo5Auvj6I8+oUQkVvC022vQFxM5Wl+xqdguZr9h2SP
         QlVcqpMzv/7nwL4zFHeGGPdolivosXjem1N/rDVIG2uEZS2GcEb4bx97IGTVyecllzDh
         JrQyiedWmJLbR2kBaYfkt10IreLkUND1Bg5Eya6vRGz57wZl4vLkjM62CR9zbQs1pzCa
         l5Ng==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1776494748; x=1777099548;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=39M7+KeJmT4lMyccAvgwolT2IgOurmSRT1xXmikz91I=;
        b=QfVcuO5Zrfrz+6xnpwMpopGa7MuWHgheg+12pywEf5DdcfqvzHmhveQCKvDy42ye3p
         ZPFy1btOks/xOjID/CZ64N+V8RayQHs47ZX1MYM3/CH09ZXecYZ07ylzwvkvPGWUsFEK
         B9EjblHU+0O5+8Dt4gRtgGa7BUwkdApvIiwyDqB58h8xddf5hPHBNk8gejUmm7J+Yk9D
         hskwdilw464h5gOMQ0xWOsyORV+EVFv0Xnw3RbB0vFl3uvaXbxdVYF6TgEoYWUBStP19
         mvlkDcM0wcXxP1ozFrqM+fl7wXRXrPCleT978k1mDlioxb6rO8a8QLoxlMbHorUuEqVA
         g5xw==
X-Forwarded-Encrypted: i=1; AFNElJ+AxH+Bss9nd99OnX0RTKPGIIejxC99uh/fPsRLYdVco4otFTnbOppTVtouxglJ9tkGdsv4qFs=@lists.linux.dev
X-Gm-Message-State: AOJu0Yyot6bENV9qVMtszP0KyNHun4zqV1EHDr0lg1aitETaykkSaNB3
	7y5FzcM2BGh6SWnsgStBYTnh0vhLURQF1cApU+OLuo1ZzUsdrCalRzBHlGbWW9iJcmadZFy6qQQ
	dsvi1pyndF6gNjTLv8C3LQZ1w9M6JIFcKoxJUTD5N
X-Gm-Gg: AeBDieuTwxdQFKPdtwfdK+UE+CUVKOb5ja7ubHIXX3bCkfCtYlikhB79Ui/pqFgE3N9
	mph11dw9+yWiy7O1+RAlGhBTlv3xkc/dMUX+yqTIPo9SqhdWdEwFzX4ahosHPmE/2LATgMxWOZf
	tB13gFaiYKYngvj4kFSO/wQZTweKvkbr/1tRp+0tAUKWkMfQnQuFENaNHf+xASl+P/Hsz3IMBvm
	u63UwmyYJI+kLwwzHXrJ53AhO+a8fimQZir3esZpfssd+aiVeQofZ8Y/RBfURxYX+5wytJm0gQw
	qhfAPVdPE0zco27RkyF7WHWGrdrspf9Ho7iHYe3AGSV/hG6jFzN94k7s0BMt1YVWi5YNNMOiGSh
	HshXo8QFzCdfvuTQMDw==
X-Received: by 2002:a05:6808:13c6:b0:467:13b5:8ae6 with SMTP id
 5614622812f47-4799c875e08mr3583875b6e.4.1776494746921; Fri, 17 Apr 2026
 23:45:46 -0700 (PDT)
Precedence: bulk
X-Mailing-List: syzbot@lists.linux.dev
List-Id: <syzbot.lists.linux.dev>
List-Subscribe: <mailto:syzbot+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:syzbot+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <69e2e6c5.a00a0220.1bd0ca.0034.GAE@google.com>
In-Reply-To: <69e2e6c5.a00a0220.1bd0ca.0034.GAE@google.com>
From: Aleksandr Nogikh <nogikh@google.com>
Date: Sat, 18 Apr 2026 08:45:34 +0200
X-Gm-Features: AQROBzBxT52SRO9iZUjfeXMHY1gAGnO46NKdqeFnMMsmUjNprBPC5dSqzv-d75E
Message-ID: <CANp29Y7nmrEqa+joHEahXkosPucf-DDa=hqzPQ07_dmtADhAUQ@mail.gmail.com>
Subject: Re: [moderation/CI] Re: Data in direntry (dirdata) feature
To: syzbot ci <syzbot+ci77dd955d2d487698@syzkaller.appspotmail.com>
Cc: syzkaller-upstream-moderation@googlegroups.com, syzbot@lists.linux.dev
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

#syz upstream

On Sat, Apr 18, 2026 at 4:04=E2=80=AFAM syzbot ci
<syzbot+ci77dd955d2d487698@syzkaller.appspotmail.com> wrote:
>
> syzbot ci has tested the following series
>
> [v1] Data in direntry (dirdata) feature
> https://lore.kernel.org/all/20260417213723.74204-1-artem.blagodarenko@gma=
il.com
> * [PATCH 1/3] ext4: make dirdata work with metadata_csum
> * [PATCH 2/3] ext4: add dirdata support structures and helpers
> * [PATCH 3/3] ext4: dirdata feature
>
> and found the following issues:
> * KASAN: slab-out-of-bounds Read in __ext4_check_dir_entry
> * KASAN: slab-out-of-bounds Read in dx_probe
> * KASAN: slab-use-after-free Read in __ext4_check_dir_entry
> * KASAN: slab-use-after-free Read in dx_probe
> * KASAN: use-after-free Read in __ext4_check_dir_entry
>
> Full report is available here:
> https://ci.syzbot.org/series/590e846e-42c0-4497-b6ae-b95ed4468941
>
> ***
>
> KASAN: slab-out-of-bounds Read in __ext4_check_dir_entry
>
> tree:      torvalds
> URL:       https://kernel.googlesource.com/pub/scm/linux/kernel/git/torva=
lds/linux
> base:      70b672833f4025341c11b22c7f83778a5cd611bc
> arch:      amd64
> compiler:  Debian clang version 21.1.8 (++20251221033036+2078da43e25a-1~e=
xp1~20251221153213.50), Debian LLD 21.1.8
> config:    https://ci.syzbot.org/builds/7b860156-1ca9-441f-b899-ebfb5a096=
20d/config
> syz repro: https://ci.syzbot.org/findings/d27eccd2-4663-4047-abb9-9c24cb3=
2f887/syz_repro
>
> loop0: lost filesystem error report for type 5 error -117
> EXT4-fs (loop0): mounted filesystem 00000000-0000-0000-0000-000000000000 =
r/w without journal. Quota mode: none.
> =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
> BUG: KASAN: slab-out-of-bounds in ext4_dirent_get_data_len fs/ext4/ext4.h=
:4040 [inline]
> BUG: KASAN: slab-out-of-bounds in ext4_dir_entry_len fs/ext4/ext4.h:4060 =
[inline]
> BUG: KASAN: slab-out-of-bounds in __ext4_check_dir_entry+0x527/0xa70 fs/e=
xt4/dir.c:96
> Read of size 1 at addr ffff8881090bfe5c by task syz.0.20/5967
>
> CPU: 1 UID: 0 PID: 5967 Comm: syz.0.20 Not tainted syzkaller #0 PREEMPT(f=
ull)
> Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS 1.16.2-debian-1.=
16.2-1 04/01/2014
> Call Trace:
>  <TASK>
>  dump_stack_lvl+0xe8/0x150 lib/dump_stack.c:120
>  print_address_description mm/kasan/report.c:378 [inline]
>  print_report+0xba/0x230 mm/kasan/report.c:482
>  kasan_report+0x117/0x150 mm/kasan/report.c:595
>  ext4_dirent_get_data_len fs/ext4/ext4.h:4040 [inline]
>  ext4_dir_entry_len fs/ext4/ext4.h:4060 [inline]
>  __ext4_check_dir_entry+0x527/0xa70 fs/ext4/dir.c:96
>  ext4_inlinedir_to_tree+0x6be/0xbf0 fs/ext4/inline.c:1322
>  ext4_htree_fill_tree+0x50b/0x1230 fs/ext4/namei.c:1184
>  ext4_dx_readdir fs/ext4/dir.c:600 [inline]
>  ext4_readdir+0x2f7b/0x3870 fs/ext4/dir.c:146
>  iterate_dir+0x399/0x570 fs/readdir.c:108
>  __do_sys_getdents64 fs/readdir.c:412 [inline]
>  __se_sys_getdents64+0xf1/0x280 fs/readdir.c:397
>  do_syscall_x64 arch/x86/entry/syscall_64.c:63 [inline]
>  do_syscall_64+0x14d/0xf80 arch/x86/entry/syscall_64.c:94
>  entry_SYSCALL_64_after_hwframe+0x77/0x7f
> RIP: 0033:0x7fe47219c819
> Code: ff c3 66 2e 0f 1f 84 00 00 00 00 00 0f 1f 44 00 00 48 89 f8 48 89 f=
7 48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 ff=
 ff 73 01 c3 48 c7 c1 e8 ff ff ff f7 d8 64 89 01 48
> RSP: 002b:00007fe4730c0028 EFLAGS: 00000246 ORIG_RAX: 00000000000000d9
> RAX: ffffffffffffffda RBX: 00007fe472415fa0 RCX: 00007fe47219c819
> RDX: 000000000000ff80 RSI: 9999999999999999 RDI: 0000000000000004
> RBP: 00007fe472232c91 R08: 0000000000000000 R09: 0000000000000000
> R10: 0000000000000000 R11: 0000000000000246 R12: 0000000000000000
> R13: 00007fe472416038 R14: 00007fe472415fa0 R15: 00007ffff595c618
>  </TASK>
>
> Allocated by task 5967:
>  kasan_save_stack mm/kasan/common.c:57 [inline]
>  kasan_save_track+0x3e/0x80 mm/kasan/common.c:78
>  poison_kmalloc_redzone mm/kasan/common.c:398 [inline]
>  __kasan_kmalloc+0x93/0xb0 mm/kasan/common.c:415
>  kasan_kmalloc include/linux/kasan.h:263 [inline]
>  __do_kmalloc_node mm/slub.c:5260 [inline]
>  __kmalloc_noprof+0x35c/0x760 mm/slub.c:5272
>  kmalloc_noprof include/linux/slab.h:954 [inline]
>  ext4_mb_init+0x15d/0x2ad0 fs/ext4/mballoc.c:3729
>  __ext4_fill_super fs/ext4/super.c:5623 [inline]
>  ext4_fill_super+0x5647/0x6320 fs/ext4/super.c:5793
>  get_tree_bdev_flags+0x431/0x4f0 fs/super.c:1694
>  vfs_get_tree+0x92/0x2a0 fs/super.c:1754
>  fc_mount fs/namespace.c:1193 [inline]
>  do_new_mount_fc fs/namespace.c:3763 [inline]
>  do_new_mount+0x341/0xd30 fs/namespace.c:3839
>  do_mount fs/namespace.c:4172 [inline]
>  __do_sys_mount fs/namespace.c:4361 [inline]
>  __se_sys_mount+0x31d/0x420 fs/namespace.c:4338
>  do_syscall_x64 arch/x86/entry/syscall_64.c:63 [inline]
>  do_syscall_64+0x14d/0xf80 arch/x86/entry/syscall_64.c:94
>  entry_SYSCALL_64_after_hwframe+0x77/0x7f
>
> The buggy address belongs to the object at ffff8881090bfe00
>  which belongs to the cache kmalloc-64 of size 64
> The buggy address is located 44 bytes to the right of
>  allocated 48-byte region [ffff8881090bfe00, ffff8881090bfe30)
>
> The buggy address belongs to the physical page:
> page: refcount:0 mapcount:0 mapping:0000000000000000 index:0x0 pfn:0x1090=
bf
> flags: 0x17ff00000000000(node=3D0|zone=3D2|lastcpupid=3D0x7ff)
> page_type: f5(slab)
> raw: 017ff00000000000 ffff8881000418c0 dead000000000100 dead000000000122
> raw: 0000000000000000 0000000800200020 00000000f5000000 0000000000000000
> page dumped because: kasan: bad access detected
> page_owner tracks the page as allocated
> page last allocated via order 0, migratetype Unmovable, gfp_mask 0xd2cc0(=
GFP_KERNEL|__GFP_NOWARN|__GFP_NORETRY|__GFP_COMP|__GFP_NOMEMALLOC), pid 1, =
tgid 1 (swapper/0), ts 16414655371, free_ts 15537272896
>  set_page_owner include/linux/page_owner.h:32 [inline]
>  post_alloc_hook+0x231/0x280 mm/page_alloc.c:1889
>  prep_new_page mm/page_alloc.c:1897 [inline]
>  get_page_from_freelist+0x24dc/0x2580 mm/page_alloc.c:3962
>  __alloc_frozen_pages_noprof+0x18d/0x380 mm/page_alloc.c:5250
>  alloc_slab_page mm/slub.c:3292 [inline]
>  allocate_slab+0x77/0x660 mm/slub.c:3481
>  new_slab mm/slub.c:3539 [inline]
>  refill_objects+0x331/0x3c0 mm/slub.c:7175
>  refill_sheaf mm/slub.c:2812 [inline]
>  __pcs_replace_empty_main+0x2e6/0x730 mm/slub.c:4615
>  alloc_from_pcs mm/slub.c:4717 [inline]
>  slab_alloc_node mm/slub.c:4851 [inline]
>  __do_kmalloc_node mm/slub.c:5259 [inline]
>  __kmalloc_noprof+0x474/0x760 mm/slub.c:5272
>  kmalloc_noprof include/linux/slab.h:954 [inline]
>  kzalloc_noprof include/linux/slab.h:1188 [inline]
>  kobject_get_path+0xc5/0x2f0 lib/kobject.c:161
>  kobject_uevent_env+0x2a1/0x9e0 lib/kobject_uevent.c:545
>  really_probe+0x789/0xaf0 drivers/base/dd.c:771
>  __driver_probe_device+0x18c/0x320 drivers/base/dd.c:863
>  driver_probe_device+0x4f/0x240 drivers/base/dd.c:893
>  __device_attach_driver+0x279/0x430 drivers/base/dd.c:1021
>  bus_for_each_drv+0x258/0x2f0 drivers/base/bus.c:500
>  __device_attach+0x2c5/0x450 drivers/base/dd.c:1093
>  device_initial_probe+0xa1/0xd0 drivers/base/dd.c:1148
> page last free pid 33 tgid 33 stack trace:
>  reset_page_owner include/linux/page_owner.h:25 [inline]
>  __free_pages_prepare mm/page_alloc.c:1433 [inline]
>  __free_frozen_pages+0xc2b/0xdb0 mm/page_alloc.c:2978
>  vfree+0x25a/0x400 mm/vmalloc.c:3479
>  delayed_vfree_work+0x55/0x80 mm/vmalloc.c:3398
>  process_one_work kernel/workqueue.c:3276 [inline]
>  process_scheduled_works+0xb6e/0x18c0 kernel/workqueue.c:3359
>  worker_thread+0xa53/0xfc0 kernel/workqueue.c:3440
>  kthread+0x388/0x470 kernel/kthread.c:436
>  ret_from_fork+0x51e/0xb90 arch/x86/kernel/process.c:158
>  ret_from_fork_asm+0x1a/0x30 arch/x86/entry/entry_64.S:245
>
> Memory state around the buggy address:
>  ffff8881090bfd00: 00 00 00 00 00 00 00 04 fc fc fc fc fc fc fc fc
>  ffff8881090bfd80: 00 00 00 00 00 00 00 00 fc fc fc fc fc fc fc fc
> >ffff8881090bfe00: 00 00 00 00 00 00 fc fc fc fc fc fc fc fc fc fc
>                                                     ^
>  ffff8881090bfe80: fa fb fb fb fb fb fb fb fc fc fc fc fc fc fc fc
>  ffff8881090bff00: 00 00 00 00 00 00 fc fc fc fc fc fc fc fc fc fc
> =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
>
>
> ***
>
> KASAN: slab-out-of-bounds Read in dx_probe
>
> tree:      torvalds
> URL:       https://kernel.googlesource.com/pub/scm/linux/kernel/git/torva=
lds/linux
> base:      70b672833f4025341c11b22c7f83778a5cd611bc
> arch:      amd64
> compiler:  Debian clang version 21.1.8 (++20251221033036+2078da43e25a-1~e=
xp1~20251221153213.50), Debian LLD 21.1.8
> config:    https://ci.syzbot.org/builds/7b860156-1ca9-441f-b899-ebfb5a096=
20d/config
> syz repro: https://ci.syzbot.org/findings/a5fcf3bd-f1ae-4b81-b5d2-f96899e=
a7690/syz_repro
>
> =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
> BUG: KASAN: slab-out-of-bounds in ext4_dir_entry_is_tail fs/ext4/ext4.h:4=
001 [inline]
> BUG: KASAN: slab-out-of-bounds in ext4_dirent_get_data_len fs/ext4/ext4.h=
:4024 [inline]
> BUG: KASAN: slab-out-of-bounds in ext4_dir_entry_len fs/ext4/ext4.h:4060 =
[inline]
> BUG: KASAN: slab-out-of-bounds in dx_root_limit fs/ext4/namei.c:583 [inli=
ne]
> BUG: KASAN: slab-out-of-bounds in dx_probe+0x1ac9/0x1d90 fs/ext4/namei.c:=
861
> Read of size 4 at addr ffff88816a408c10 by task syz.2.19/5980
>
> CPU: 1 UID: 0 PID: 5980 Comm: syz.2.19 Not tainted syzkaller #0 PREEMPT(f=
ull)
> Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS 1.16.2-debian-1.=
16.2-1 04/01/2014
> Call Trace:
>  <TASK>
>  dump_stack_lvl+0xe8/0x150 lib/dump_stack.c:120
>  print_address_description mm/kasan/report.c:378 [inline]
>  print_report+0xba/0x230 mm/kasan/report.c:482
>  kasan_report+0x117/0x150 mm/kasan/report.c:595
>  ext4_dir_entry_is_tail fs/ext4/ext4.h:4001 [inline]
>  ext4_dirent_get_data_len fs/ext4/ext4.h:4024 [inline]
>  ext4_dir_entry_len fs/ext4/ext4.h:4060 [inline]
>  dx_root_limit fs/ext4/namei.c:583 [inline]
>  dx_probe+0x1ac9/0x1d90 fs/ext4/namei.c:861
>  ext4_dx_find_entry fs/ext4/namei.c:1812 [inline]
>  __ext4_find_entry+0x5a9/0x2140 fs/ext4/namei.c:1652
>  ext4_lookup_entry fs/ext4/namei.c:1794 [inline]
>  ext4_lookup+0x17b/0x710 fs/ext4/namei.c:1860
>  __lookup_slow+0x2b7/0x410 fs/namei.c:1916
>  lookup_slow+0x53/0x70 fs/namei.c:1933
>  walk_component fs/namei.c:2279 [inline]
>  lookup_last fs/namei.c:2780 [inline]
>  path_lookupat+0x3f5/0x8c0 fs/namei.c:2804
>  filename_lookup+0x256/0x5d0 fs/namei.c:2833
>  user_path_at+0x40/0x160 fs/namei.c:3612
>  do_mount fs/namespace.c:4169 [inline]
>  __do_sys_mount fs/namespace.c:4361 [inline]
>  __se_sys_mount+0x2dc/0x420 fs/namespace.c:4338
>  do_syscall_x64 arch/x86/entry/syscall_64.c:63 [inline]
>  do_syscall_64+0x14d/0xf80 arch/x86/entry/syscall_64.c:94
>  entry_SYSCALL_64_after_hwframe+0x77/0x7f
> RIP: 0033:0x7f518919c819
> Code: ff c3 66 2e 0f 1f 84 00 00 00 00 00 0f 1f 44 00 00 48 89 f8 48 89 f=
7 48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 ff=
 ff 73 01 c3 48 c7 c1 e8 ff ff ff f7 d8 64 89 01 48
> RSP: 002b:00007f5189fbb028 EFLAGS: 00000246 ORIG_RAX: 00000000000000a5
> RAX: ffffffffffffffda RBX: 00007f5189415fa0 RCX: 00007f518919c819
> RDX: 0000200000000140 RSI: 0000200000000100 RDI: 0000000000000000
> RBP: 00007f5189232c91 R08: 0000200000000d80 R09: 0000000000000000
> R10: 0000000001302060 R11: 0000000000000246 R12: 0000000000000000
> R13: 00007f5189416038 R14: 00007f5189415fa0 R15: 00007ffc5d8d15b8
>  </TASK>
>
> Allocated by task 5243:
>  kasan_save_stack mm/kasan/common.c:57 [inline]
>  kasan_save_track+0x3e/0x80 mm/kasan/common.c:78
>  poison_kmalloc_redzone mm/kasan/common.c:398 [inline]
>  __kasan_kmalloc+0x93/0xb0 mm/kasan/common.c:415
>  kasan_kmalloc include/linux/kasan.h:263 [inline]
>  __do_kmalloc_node mm/slub.c:5260 [inline]
>  __kvmalloc_node_noprof+0x528/0x8a0 mm/slub.c:6752
>  evdev_open+0xeb/0x5b0 drivers/input/evdev.c:468
>  chrdev_open+0x4cd/0x5e0 fs/char_dev.c:411
>  do_dentry_open+0x785/0x14e0 fs/open.c:949
>  vfs_open+0x3b/0x340 fs/open.c:1081
>  do_open fs/namei.c:4671 [inline]
>  path_openat+0x2e08/0x3860 fs/namei.c:4830
>  do_file_open+0x23e/0x4a0 fs/namei.c:4859
>  do_sys_openat2+0x113/0x200 fs/open.c:1366
>  do_sys_open fs/open.c:1372 [inline]
>  __do_sys_openat fs/open.c:1388 [inline]
>  __se_sys_openat fs/open.c:1383 [inline]
>  __x64_sys_openat+0x138/0x170 fs/open.c:1383
>  do_syscall_x64 arch/x86/entry/syscall_64.c:63 [inline]
>  do_syscall_64+0x14d/0xf80 arch/x86/entry/syscall_64.c:94
>  entry_SYSCALL_64_after_hwframe+0x77/0x7f
>
> The buggy address belongs to the object at ffff88816a408000
>  which belongs to the cache kmalloc-2k of size 2048
> The buggy address is located 1088 bytes to the right of
>  allocated 2000-byte region [ffff88816a408000, ffff88816a4087d0)
>
> The buggy address belongs to the physical page:
> page: refcount:0 mapcount:0 mapping:0000000000000000 index:0x0 pfn:0x16a4=
08
> head: order:3 mapcount:0 entire_mapcount:0 nr_pages_mapped:0 pincount:0
> flags: 0x57ff00000000040(head|node=3D1|zone=3D2|lastcpupid=3D0x7ff)
> page_type: f5(slab)
> raw: 057ff00000000040 ffff888100042000 dead000000000100 dead000000000122
> raw: 0000000000000000 0000000800080008 00000000f5000000 0000000000000000
> head: 057ff00000000040 ffff888100042000 dead000000000100 dead000000000122
> head: 0000000000000000 0000000800080008 00000000f5000000 0000000000000000
> head: 057ff00000000003 ffffea0005a90201 00000000ffffffff 00000000ffffffff
> head: ffffffffffffffff 0000000000000000 00000000ffffffff 0000000000000008
> page dumped because: kasan: bad access detected
> page_owner tracks the page as allocated
> page last allocated via order 3, migratetype Unmovable, gfp_mask 0xd20c0(=
__GFP_IO|__GFP_FS|__GFP_NOWARN|__GFP_NORETRY|__GFP_COMP|__GFP_NOMEMALLOC), =
pid 5243, tgid 5243 (acpid), ts 25906150911, free_ts 21905842969
>  set_page_owner include/linux/page_owner.h:32 [inline]
>  post_alloc_hook+0x231/0x280 mm/page_alloc.c:1889
>  prep_new_page mm/page_alloc.c:1897 [inline]
>  get_page_from_freelist+0x24dc/0x2580 mm/page_alloc.c:3962
>  __alloc_frozen_pages_noprof+0x18d/0x380 mm/page_alloc.c:5250
>  alloc_slab_page mm/slub.c:3292 [inline]
>  allocate_slab+0x77/0x660 mm/slub.c:3481
>  new_slab mm/slub.c:3539 [inline]
>  refill_objects+0x331/0x3c0 mm/slub.c:7175
>  refill_sheaf mm/slub.c:2812 [inline]
>  __pcs_replace_empty_main+0x2e6/0x730 mm/slub.c:4615
>  alloc_from_pcs mm/slub.c:4717 [inline]
>  slab_alloc_node mm/slub.c:4851 [inline]
>  __do_kmalloc_node mm/slub.c:5259 [inline]
>  __kvmalloc_node_noprof+0x657/0x8a0 mm/slub.c:6752
>  evdev_open+0xeb/0x5b0 drivers/input/evdev.c:468
>  chrdev_open+0x4cd/0x5e0 fs/char_dev.c:411
>  do_dentry_open+0x785/0x14e0 fs/open.c:949
>  vfs_open+0x3b/0x340 fs/open.c:1081
>  do_open fs/namei.c:4671 [inline]
>  path_openat+0x2e08/0x3860 fs/namei.c:4830
>  do_file_open+0x23e/0x4a0 fs/namei.c:4859
>  do_sys_openat2+0x113/0x200 fs/open.c:1366
>  do_sys_open fs/open.c:1372 [inline]
>  __do_sys_openat fs/open.c:1388 [inline]
>  __se_sys_openat fs/open.c:1383 [inline]
>  __x64_sys_openat+0x138/0x170 fs/open.c:1383
>  do_syscall_x64 arch/x86/entry/syscall_64.c:63 [inline]
>  do_syscall_64+0x14d/0xf80 arch/x86/entry/syscall_64.c:94
> page last free pid 9 tgid 9 stack trace:
>  reset_page_owner include/linux/page_owner.h:25 [inline]
>  __free_pages_prepare mm/page_alloc.c:1433 [inline]
>  __free_frozen_pages+0xc2b/0xdb0 mm/page_alloc.c:2978
>  vfree+0x25a/0x400 mm/vmalloc.c:3479
>  delayed_vfree_work+0x55/0x80 mm/vmalloc.c:3398
>  process_one_work kernel/workqueue.c:3276 [inline]
>  process_scheduled_works+0xb6e/0x18c0 kernel/workqueue.c:3359
>  worker_thread+0xa53/0xfc0 kernel/workqueue.c:3440
>  kthread+0x388/0x470 kernel/kthread.c:436
>  ret_from_fork+0x51e/0xb90 arch/x86/kernel/process.c:158
>  ret_from_fork_asm+0x1a/0x30 arch/x86/entry/entry_64.S:245
>
> Memory state around the buggy address:
>  ffff88816a408b00: fc fc fc fc fc fc fc fc fc fc fc fc fc fc fc fc
>  ffff88816a408b80: fc fc fc fc fc fc fc fc fc fc fc fc fc fc fc fc
> >ffff88816a408c00: fc fc fc fc fc fc fc fc fc fc fc fc fc fc fc fc
>                          ^
>  ffff88816a408c80: fc fc fc fc fc fc fc fc fc fc fc fc fc fc fc fc
>  ffff88816a408d00: fc fc fc fc fc fc fc fc fc fc fc fc fc fc fc fc
> =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
>
>
> ***
>
> KASAN: slab-use-after-free Read in __ext4_check_dir_entry
>
> tree:      torvalds
> URL:       https://kernel.googlesource.com/pub/scm/linux/kernel/git/torva=
lds/linux
> base:      70b672833f4025341c11b22c7f83778a5cd611bc
> arch:      amd64
> compiler:  Debian clang version 21.1.8 (++20251221033036+2078da43e25a-1~e=
xp1~20251221153213.50), Debian LLD 21.1.8
> config:    https://ci.syzbot.org/builds/7b860156-1ca9-441f-b899-ebfb5a096=
20d/config
> syz repro: https://ci.syzbot.org/findings/e493ff66-4032-4979-9b5d-5118b27=
68ca5/syz_repro
>
> EXT4-fs (loop0): mounted filesystem 00000000-0000-0000-0000-000000000000 =
r/w without journal. Quota mode: none.
> =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
> BUG: KASAN: slab-use-after-free in ext4_dirent_get_data_len fs/ext4/ext4.=
h:4040 [inline]
> BUG: KASAN: slab-use-after-free in ext4_dir_entry_len fs/ext4/ext4.h:4060=
 [inline]
> BUG: KASAN: slab-use-after-free in __ext4_check_dir_entry+0x527/0xa70 fs/=
ext4/dir.c:96
> Read of size 1 at addr ffff88810138889c by task syz.0.24/5978
>
> CPU: 0 UID: 0 PID: 5978 Comm: syz.0.24 Not tainted syzkaller #0 PREEMPT(f=
ull)
> Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS 1.16.2-debian-1.=
16.2-1 04/01/2014
> Call Trace:
>  <TASK>
>  dump_stack_lvl+0xe8/0x150 lib/dump_stack.c:120
>  print_address_description mm/kasan/report.c:378 [inline]
>  print_report+0xba/0x230 mm/kasan/report.c:482
>  kasan_report+0x117/0x150 mm/kasan/report.c:595
>  ext4_dirent_get_data_len fs/ext4/ext4.h:4040 [inline]
>  ext4_dir_entry_len fs/ext4/ext4.h:4060 [inline]
>  __ext4_check_dir_entry+0x527/0xa70 fs/ext4/dir.c:96
>  ext4_inlinedir_to_tree+0x6be/0xbf0 fs/ext4/inline.c:1322
>  ext4_htree_fill_tree+0x50b/0x1230 fs/ext4/namei.c:1184
>  ext4_dx_readdir fs/ext4/dir.c:600 [inline]
>  ext4_readdir+0x2f7b/0x3870 fs/ext4/dir.c:146
>  iterate_dir+0x399/0x570 fs/readdir.c:108
>  __do_sys_getdents64 fs/readdir.c:412 [inline]
>  __se_sys_getdents64+0xf1/0x280 fs/readdir.c:397
>  do_syscall_x64 arch/x86/entry/syscall_64.c:63 [inline]
>  do_syscall_64+0x14d/0xf80 arch/x86/entry/syscall_64.c:94
>  entry_SYSCALL_64_after_hwframe+0x77/0x7f
> RIP: 0033:0x7ff3fe19c819
> Code: ff c3 66 2e 0f 1f 84 00 00 00 00 00 0f 1f 44 00 00 48 89 f8 48 89 f=
7 48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 ff=
 ff 73 01 c3 48 c7 c1 e8 ff ff ff f7 d8 64 89 01 48
> RSP: 002b:00007ff3fefac028 EFLAGS: 00000246 ORIG_RAX: 00000000000000d9
> RAX: ffffffffffffffda RBX: 00007ff3fe415fa0 RCX: 00007ff3fe19c819
> RDX: 000000000000ff80 RSI: 9999999999999999 RDI: 0000000000000004
> RBP: 00007ff3fe232c91 R08: 0000000000000000 R09: 0000000000000000
> R10: 0000000000000000 R11: 0000000000000246 R12: 0000000000000000
> R13: 00007ff3fe416038 R14: 00007ff3fe415fa0 R15: 00007ffd39a74998
>  </TASK>
>
> Allocated by task 5766:
>  kasan_save_stack mm/kasan/common.c:57 [inline]
>  kasan_save_track+0x3e/0x80 mm/kasan/common.c:78
>  poison_kmalloc_redzone mm/kasan/common.c:398 [inline]
>  __kasan_kmalloc+0x93/0xb0 mm/kasan/common.c:415
>  kasan_kmalloc include/linux/kasan.h:263 [inline]
>  __do_kmalloc_node mm/slub.c:5260 [inline]
>  __kmalloc_noprof+0x35c/0x760 mm/slub.c:5272
>  kmalloc_noprof include/linux/slab.h:954 [inline]
>  kzalloc_noprof include/linux/slab.h:1188 [inline]
>  tomoyo_encode2 security/tomoyo/realpath.c:45 [inline]
>  tomoyo_encode+0x28b/0x550 security/tomoyo/realpath.c:80
>  tomoyo_realpath_from_path+0x58d/0x5d0 security/tomoyo/realpath.c:283
>  tomoyo_get_realpath security/tomoyo/file.c:151 [inline]
>  tomoyo_check_open_permission+0x229/0x470 security/tomoyo/file.c:776
>  security_file_open+0xa9/0x240 security/security.c:2637
>  do_dentry_open+0x384/0x14e0 fs/open.c:926
>  vfs_open+0x3b/0x340 fs/open.c:1081
>  do_open fs/namei.c:4671 [inline]
>  path_openat+0x2e08/0x3860 fs/namei.c:4830
>  do_file_open+0x23e/0x4a0 fs/namei.c:4859
>  do_sys_openat2+0x113/0x200 fs/open.c:1366
>  do_sys_open fs/open.c:1372 [inline]
>  __do_sys_openat fs/open.c:1388 [inline]
>  __se_sys_openat fs/open.c:1383 [inline]
>  __x64_sys_openat+0x138/0x170 fs/open.c:1383
>  do_syscall_x64 arch/x86/entry/syscall_64.c:63 [inline]
>  do_syscall_64+0x14d/0xf80 arch/x86/entry/syscall_64.c:94
>  entry_SYSCALL_64_after_hwframe+0x77/0x7f
>
> Freed by task 5766:
>  kasan_save_stack mm/kasan/common.c:57 [inline]
>  kasan_save_track+0x3e/0x80 mm/kasan/common.c:78
>  kasan_save_free_info+0x46/0x50 mm/kasan/generic.c:584
>  poison_slab_object mm/kasan/common.c:253 [inline]
>  __kasan_slab_free+0x5c/0x80 mm/kasan/common.c:285
>  kasan_slab_free include/linux/kasan.h:235 [inline]
>  slab_free_hook mm/slub.c:2685 [inline]
>  slab_free mm/slub.c:6165 [inline]
>  kfree+0x1c1/0x630 mm/slub.c:6483
>  tomoyo_check_open_permission+0x32c/0x470 security/tomoyo/file.c:791
>  security_file_open+0xa9/0x240 security/security.c:2637
>  do_dentry_open+0x384/0x14e0 fs/open.c:926
>  vfs_open+0x3b/0x340 fs/open.c:1081
>  do_open fs/namei.c:4671 [inline]
>  path_openat+0x2e08/0x3860 fs/namei.c:4830
>  do_file_open+0x23e/0x4a0 fs/namei.c:4859
>  do_sys_openat2+0x113/0x200 fs/open.c:1366
>  do_sys_open fs/open.c:1372 [inline]
>  __do_sys_openat fs/open.c:1388 [inline]
>  __se_sys_openat fs/open.c:1383 [inline]
>  __x64_sys_openat+0x138/0x170 fs/open.c:1383
>  do_syscall_x64 arch/x86/entry/syscall_64.c:63 [inline]
>  do_syscall_64+0x14d/0xf80 arch/x86/entry/syscall_64.c:94
>  entry_SYSCALL_64_after_hwframe+0x77/0x7f
>
> The buggy address belongs to the object at ffff888101388880
>  which belongs to the cache kmalloc-64 of size 64
> The buggy address is located 28 bytes inside of
>  freed 64-byte region [ffff888101388880, ffff8881013888c0)
>
> The buggy address belongs to the physical page:
> page: refcount:0 mapcount:0 mapping:0000000000000000 index:0x0 pfn:0x1013=
88
> flags: 0x17ff00000000000(node=3D0|zone=3D2|lastcpupid=3D0x7ff)
> page_type: f5(slab)
> raw: 017ff00000000000 ffff8881000418c0 dead000000000100 dead000000000122
> raw: 0000000000000000 0000000800200020 00000000f5000000 0000000000000000
> page dumped because: kasan: bad access detected
> page_owner tracks the page as allocated
> page last allocated via order 0, migratetype Unmovable, gfp_mask 0xd2cc0(=
GFP_KERNEL|__GFP_NOWARN|__GFP_NORETRY|__GFP_COMP|__GFP_NOMEMALLOC), pid 26,=
 tgid 26 (kworker/u9:0), ts 4100832473, free_ts 4100767003
>  set_page_owner include/linux/page_owner.h:32 [inline]
>  post_alloc_hook+0x231/0x280 mm/page_alloc.c:1889
>  prep_new_page mm/page_alloc.c:1897 [inline]
>  get_page_from_freelist+0x24dc/0x2580 mm/page_alloc.c:3962
>  __alloc_frozen_pages_noprof+0x18d/0x380 mm/page_alloc.c:5250
>  alloc_slab_page mm/slub.c:3292 [inline]
>  allocate_slab+0x77/0x660 mm/slub.c:3481
>  new_slab mm/slub.c:3539 [inline]
>  refill_objects+0x331/0x3c0 mm/slub.c:7175
>  refill_sheaf mm/slub.c:2812 [inline]
>  alloc_full_sheaf mm/slub.c:2834 [inline]
>  __pcs_replace_empty_main+0x40a/0x730 mm/slub.c:4626
>  alloc_from_pcs mm/slub.c:4717 [inline]
>  slab_alloc_node mm/slub.c:4851 [inline]
>  __do_kmalloc_node mm/slub.c:5259 [inline]
>  __kmalloc_noprof+0x474/0x760 mm/slub.c:5272
>  kmalloc_noprof include/linux/slab.h:954 [inline]
>  kzalloc_noprof include/linux/slab.h:1188 [inline]
>  lsm_blob_alloc security/security.c:193 [inline]
>  lsm_task_alloc security/security.c:245 [inline]
>  security_task_alloc+0x4d/0x330 security/security.c:2683
>  copy_process+0x16df/0x3cd0 kernel/fork.c:2206
>  kernel_clone+0x248/0x8e0 kernel/fork.c:2658
>  user_mode_thread+0x110/0x180 kernel/fork.c:2734
>  call_usermodehelper_exec_work+0x5c/0x230 kernel/umh.c:171
>  process_one_work kernel/workqueue.c:3276 [inline]
>  process_scheduled_works+0xb6e/0x18c0 kernel/workqueue.c:3359
>  worker_thread+0xa53/0xfc0 kernel/workqueue.c:3440
>  kthread+0x388/0x470 kernel/kthread.c:436
>  ret_from_fork+0x51e/0xb90 arch/x86/kernel/process.c:158
> page last free pid 26 tgid 26 stack trace:
>  reset_page_owner include/linux/page_owner.h:25 [inline]
>  __free_pages_prepare mm/page_alloc.c:1433 [inline]
>  __free_frozen_pages+0xc2b/0xdb0 mm/page_alloc.c:2978
>  __kasan_populate_vmalloc_do mm/kasan/shadow.c:393 [inline]
>  __kasan_populate_vmalloc+0x1b2/0x1d0 mm/kasan/shadow.c:424
>  kasan_populate_vmalloc include/linux/kasan.h:580 [inline]
>  alloc_vmap_area+0xd73/0x14b0 mm/vmalloc.c:2129
>  __get_vm_area_node+0x1f8/0x300 mm/vmalloc.c:3232
>  __vmalloc_node_range_noprof+0x372/0x1730 mm/vmalloc.c:4024
>  __vmalloc_node_noprof+0xc2/0x100 mm/vmalloc.c:4124
>  alloc_thread_stack_node kernel/fork.c:355 [inline]
>  dup_task_struct+0x292/0x9e0 kernel/fork.c:924
>  copy_process+0x508/0x3cd0 kernel/fork.c:2051
>  kernel_clone+0x248/0x8e0 kernel/fork.c:2658
>  user_mode_thread+0x110/0x180 kernel/fork.c:2734
>  call_usermodehelper_exec_work+0x5c/0x230 kernel/umh.c:171
>  process_one_work kernel/workqueue.c:3276 [inline]
>  process_scheduled_works+0xb6e/0x18c0 kernel/workqueue.c:3359
>  worker_thread+0xa53/0xfc0 kernel/workqueue.c:3440
>  kthread+0x388/0x470 kernel/kthread.c:436
>  ret_from_fork+0x51e/0xb90 arch/x86/kernel/process.c:158
>  ret_from_fork_asm+0x1a/0x30 arch/x86/entry/entry_64.S:245
>
> Memory state around the buggy address:
>  ffff888101388780: 00 00 00 00 00 00 00 04 fc fc fc fc fc fc fc fc
>  ffff888101388800: fa fb fb fb fb fb fb fb fc fc fc fc fc fc fc fc
> >ffff888101388880: fa fb fb fb fb fb fb fb fc fc fc fc fc fc fc fc
>                             ^
>  ffff888101388900: 00 00 00 00 00 00 00 fc fc fc fc fc fc fc fc fc
>  ffff888101388980: 00 00 00 00 00 00 00 00 fc fc fc fc fc fc fc fc
> =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
>
>
> ***
>
> KASAN: slab-use-after-free Read in dx_probe
>
> tree:      torvalds
> URL:       https://kernel.googlesource.com/pub/scm/linux/kernel/git/torva=
lds/linux
> base:      70b672833f4025341c11b22c7f83778a5cd611bc
> arch:      amd64
> compiler:  Debian clang version 21.1.8 (++20251221033036+2078da43e25a-1~e=
xp1~20251221153213.50), Debian LLD 21.1.8
> config:    https://ci.syzbot.org/builds/7b860156-1ca9-441f-b899-ebfb5a096=
20d/config
> syz repro: https://ci.syzbot.org/findings/5524eff5-62fb-4cff-8d4e-7e3750a=
a921b/syz_repro
>
> EXT4-fs (loop2): mounted filesystem 00000000-0000-0000-0000-000000000000 =
ro without journal. Quota mode: none.
> =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
> BUG: KASAN: slab-use-after-free in ext4_dir_entry_is_tail fs/ext4/ext4.h:=
4001 [inline]
> BUG: KASAN: slab-use-after-free in ext4_dirent_get_data_len fs/ext4/ext4.=
h:4024 [inline]
> BUG: KASAN: slab-use-after-free in ext4_dir_entry_len fs/ext4/ext4.h:4060=
 [inline]
> BUG: KASAN: slab-use-after-free in dx_root_limit fs/ext4/namei.c:583 [inl=
ine]
> BUG: KASAN: slab-use-after-free in dx_probe+0x1ac9/0x1d90 fs/ext4/namei.c=
:861
> Read of size 4 at addr ffff888109c42c10 by task syz.2.20/5984
>
> CPU: 0 UID: 0 PID: 5984 Comm: syz.2.20 Not tainted syzkaller #0 PREEMPT(f=
ull)
> Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS 1.16.2-debian-1.=
16.2-1 04/01/2014
> Call Trace:
>  <TASK>
>  dump_stack_lvl+0xe8/0x150 lib/dump_stack.c:120
>  print_address_description mm/kasan/report.c:378 [inline]
>  print_report+0xba/0x230 mm/kasan/report.c:482
>  kasan_report+0x117/0x150 mm/kasan/report.c:595
>  ext4_dir_entry_is_tail fs/ext4/ext4.h:4001 [inline]
>  ext4_dirent_get_data_len fs/ext4/ext4.h:4024 [inline]
>  ext4_dir_entry_len fs/ext4/ext4.h:4060 [inline]
>  dx_root_limit fs/ext4/namei.c:583 [inline]
>  dx_probe+0x1ac9/0x1d90 fs/ext4/namei.c:861
>  ext4_dx_find_entry fs/ext4/namei.c:1812 [inline]
>  __ext4_find_entry+0x5a9/0x2140 fs/ext4/namei.c:1652
>  ext4_lookup_entry fs/ext4/namei.c:1794 [inline]
>  ext4_lookup+0x17b/0x710 fs/ext4/namei.c:1860
>  lookup_open fs/namei.c:4456 [inline]
>  open_last_lookups fs/namei.c:4583 [inline]
>  path_openat+0x11ac/0x3860 fs/namei.c:4827
>  do_file_open+0x23e/0x4a0 fs/namei.c:4859
>  do_sys_openat2+0x113/0x200 fs/open.c:1366
>  do_sys_open fs/open.c:1372 [inline]
>  __do_sys_openat fs/open.c:1388 [inline]
>  __se_sys_openat fs/open.c:1383 [inline]
>  __x64_sys_openat+0x138/0x170 fs/open.c:1383
>  do_syscall_x64 arch/x86/entry/syscall_64.c:63 [inline]
>  do_syscall_64+0x14d/0xf80 arch/x86/entry/syscall_64.c:94
>  entry_SYSCALL_64_after_hwframe+0x77/0x7f
> RIP: 0033:0x7fb97dd9c819
> Code: ff c3 66 2e 0f 1f 84 00 00 00 00 00 0f 1f 44 00 00 48 89 f8 48 89 f=
7 48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 ff=
 ff 73 01 c3 48 c7 c1 e8 ff ff ff f7 d8 64 89 01 48
> RSP: 002b:00007fb97ec96028 EFLAGS: 00000246 ORIG_RAX: 0000000000000101
> RAX: ffffffffffffffda RBX: 00007fb97e015fa0 RCX: 00007fb97dd9c819
> RDX: 0000000000042041 RSI: 0000200000000700 RDI: ffffffffffffff9c
> RBP: 00007fb97de32c91 R08: 0000000000000000 R09: 0000000000000000
> R10: 000000000000001d R11: 0000000000000246 R12: 0000000000000000
> R13: 00007fb97e016038 R14: 00007fb97e015fa0 R15: 00007fffcac5f5a8
>  </TASK>
>
> Allocated by task 5828:
>  kasan_save_stack mm/kasan/common.c:57 [inline]
>  kasan_save_track+0x3e/0x80 mm/kasan/common.c:78
>  poison_kmalloc_redzone mm/kasan/common.c:398 [inline]
>  __kasan_kmalloc+0x93/0xb0 mm/kasan/common.c:415
>  kasan_kmalloc include/linux/kasan.h:263 [inline]
>  __do_kmalloc_node mm/slub.c:5260 [inline]
>  __kmalloc_noprof+0x35c/0x760 mm/slub.c:5272
>  kmalloc_noprof include/linux/slab.h:954 [inline]
>  tomoyo_realpath_from_path+0xe3/0x5d0 security/tomoyo/realpath.c:251
>  tomoyo_get_realpath security/tomoyo/file.c:151 [inline]
>  tomoyo_path_perm+0x283/0x560 security/tomoyo/file.c:827
>  tomoyo_path_symlink+0xab/0xf0 security/tomoyo/tomoyo.c:212
>  security_path_symlink+0x16f/0x360 security/security.c:1477
>  filename_symlinkat+0x134/0x410 fs/namei.c:5638
>  __do_sys_symlink fs/namei.c:5667 [inline]
>  __se_sys_symlink+0x4d/0x2b0 fs/namei.c:5663
>  do_syscall_x64 arch/x86/entry/syscall_64.c:63 [inline]
>  do_syscall_64+0x14d/0xf80 arch/x86/entry/syscall_64.c:94
>  entry_SYSCALL_64_after_hwframe+0x77/0x7f
>
> Freed by task 5828:
>  kasan_save_stack mm/kasan/common.c:57 [inline]
>  kasan_save_track+0x3e/0x80 mm/kasan/common.c:78
>  kasan_save_free_info+0x46/0x50 mm/kasan/generic.c:584
>  poison_slab_object mm/kasan/common.c:253 [inline]
>  __kasan_slab_free+0x5c/0x80 mm/kasan/common.c:285
>  kasan_slab_free include/linux/kasan.h:235 [inline]
>  slab_free_hook mm/slub.c:2685 [inline]
>  slab_free mm/slub.c:6165 [inline]
>  kfree+0x1c1/0x630 mm/slub.c:6483
>  tomoyo_realpath_from_path+0x598/0x5d0 security/tomoyo/realpath.c:286
>  tomoyo_get_realpath security/tomoyo/file.c:151 [inline]
>  tomoyo_path_perm+0x283/0x560 security/tomoyo/file.c:827
>  tomoyo_path_symlink+0xab/0xf0 security/tomoyo/tomoyo.c:212
>  security_path_symlink+0x16f/0x360 security/security.c:1477
>  filename_symlinkat+0x134/0x410 fs/namei.c:5638
>  __do_sys_symlink fs/namei.c:5667 [inline]
>  __se_sys_symlink+0x4d/0x2b0 fs/namei.c:5663
>  do_syscall_x64 arch/x86/entry/syscall_64.c:63 [inline]
>  do_syscall_64+0x14d/0xf80 arch/x86/entry/syscall_64.c:94
>  entry_SYSCALL_64_after_hwframe+0x77/0x7f
>
> The buggy address belongs to the object at ffff888109c42000
>  which belongs to the cache kmalloc-4k of size 4096
> The buggy address is located 3088 bytes inside of
>  freed 4096-byte region [ffff888109c42000, ffff888109c43000)
>
> The buggy address belongs to the physical page:
> page: refcount:0 mapcount:0 mapping:0000000000000000 index:0x0 pfn:0x109c=
40
> head: order:3 mapcount:0 entire_mapcount:0 nr_pages_mapped:0 pincount:0
> flags: 0x17ff00000000040(head|node=3D0|zone=3D2|lastcpupid=3D0x7ff)
> page_type: f5(slab)
> raw: 017ff00000000040 ffff888100042140 dead000000000100 dead000000000122
> raw: 0000000000000000 0000000800040004 00000000f5000000 0000000000000000
> head: 017ff00000000040 ffff888100042140 dead000000000100 dead000000000122
> head: 0000000000000000 0000000800040004 00000000f5000000 0000000000000000
> head: 017ff00000000003 ffffea0004271001 00000000ffffffff 00000000ffffffff
> head: ffffffffffffffff 0000000000000000 00000000ffffffff 0000000000000008
> page dumped because: kasan: bad access detected
> page_owner tracks the page as allocated
> page last allocated via order 3, migratetype Unmovable, gfp_mask 0xd2040(=
__GFP_IO|__GFP_NOWARN|__GFP_NORETRY|__GFP_COMP|__GFP_NOMEMALLOC), pid 5828,=
 tgid 5828 (udevd), ts 67573015608, free_ts 47549723112
>  set_page_owner include/linux/page_owner.h:32 [inline]
>  post_alloc_hook+0x231/0x280 mm/page_alloc.c:1889
>  prep_new_page mm/page_alloc.c:1897 [inline]
>  get_page_from_freelist+0x24dc/0x2580 mm/page_alloc.c:3962
>  __alloc_frozen_pages_noprof+0x18d/0x380 mm/page_alloc.c:5250
>  alloc_slab_page mm/slub.c:3292 [inline]
>  allocate_slab+0x77/0x660 mm/slub.c:3481
>  new_slab mm/slub.c:3539 [inline]
>  refill_objects+0x331/0x3c0 mm/slub.c:7175
>  refill_sheaf mm/slub.c:2812 [inline]
>  __pcs_replace_empty_main+0x2e6/0x730 mm/slub.c:4615
>  alloc_from_pcs mm/slub.c:4717 [inline]
>  slab_alloc_node mm/slub.c:4851 [inline]
>  __do_kmalloc_node mm/slub.c:5259 [inline]
>  __kmalloc_noprof+0x474/0x760 mm/slub.c:5272
>  kmalloc_noprof include/linux/slab.h:954 [inline]
>  tomoyo_realpath_from_path+0xe3/0x5d0 security/tomoyo/realpath.c:251
>  tomoyo_get_realpath security/tomoyo/file.c:151 [inline]
>  tomoyo_path_perm+0x283/0x560 security/tomoyo/file.c:827
>  tomoyo_path_symlink+0xab/0xf0 security/tomoyo/tomoyo.c:212
>  security_path_symlink+0x16f/0x360 security/security.c:1477
>  filename_symlinkat+0x134/0x410 fs/namei.c:5638
>  __do_sys_symlink fs/namei.c:5667 [inline]
>  __se_sys_symlink+0x4d/0x2b0 fs/namei.c:5663
>  do_syscall_x64 arch/x86/entry/syscall_64.c:63 [inline]
>  do_syscall_64+0x14d/0xf80 arch/x86/entry/syscall_64.c:94
>  entry_SYSCALL_64_after_hwframe+0x77/0x7f
> page last free pid 5718 tgid 5718 stack trace:
>  reset_page_owner include/linux/page_owner.h:25 [inline]
>  __free_pages_prepare mm/page_alloc.c:1433 [inline]
>  __free_frozen_pages+0xc2b/0xdb0 mm/page_alloc.c:2978
>  __slab_free+0x263/0x2b0 mm/slub.c:5573
>  qlink_free mm/kasan/quarantine.c:163 [inline]
>  qlist_free_all+0x97/0x100 mm/kasan/quarantine.c:179
>  kasan_quarantine_reduce+0x148/0x160 mm/kasan/quarantine.c:286
>  __kasan_slab_alloc+0x22/0x80 mm/kasan/common.c:350
>  kasan_slab_alloc include/linux/kasan.h:253 [inline]
>  slab_post_alloc_hook mm/slub.c:4538 [inline]
>  slab_alloc_node mm/slub.c:4866 [inline]
>  kmem_cache_alloc_noprof+0x2bc/0x650 mm/slub.c:4873
>  alloc_filename fs/namei.c:142 [inline]
>  do_getname+0x2e/0x250 fs/namei.c:182
>  getname include/linux/fs.h:2512 [inline]
>  getname_maybe_null include/linux/fs.h:2519 [inline]
>  class_filename_maybe_null_constructor include/linux/fs.h:2543 [inline]
>  vfs_fstatat+0x45/0x170 fs/stat.c:368
>  __do_sys_newfstatat fs/stat.c:538 [inline]
>  __se_sys_newfstatat fs/stat.c:532 [inline]
>  __x64_sys_newfstatat+0x151/0x200 fs/stat.c:532
>  do_syscall_x64 arch/x86/entry/syscall_64.c:63 [inline]
>  do_syscall_64+0x14d/0xf80 arch/x86/entry/syscall_64.c:94
>  entry_SYSCALL_64_after_hwframe+0x77/0x7f
>
> Memory state around the buggy address:
>  ffff888109c42b00: fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb
>  ffff888109c42b80: fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb
> >ffff888109c42c00: fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb
>                          ^
>  ffff888109c42c80: fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb
>  ffff888109c42d00: fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb
> =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
>
>
> ***
>
> KASAN: use-after-free Read in __ext4_check_dir_entry
>
> tree:      torvalds
> URL:       https://kernel.googlesource.com/pub/scm/linux/kernel/git/torva=
lds/linux
> base:      70b672833f4025341c11b22c7f83778a5cd611bc
> arch:      amd64
> compiler:  Debian clang version 21.1.8 (++20251221033036+2078da43e25a-1~e=
xp1~20251221153213.50), Debian LLD 21.1.8
> config:    https://ci.syzbot.org/builds/7b860156-1ca9-441f-b899-ebfb5a096=
20d/config
> syz repro: https://ci.syzbot.org/findings/21333690-a422-407b-92c7-9247a00=
75b74/syz_repro
>
> loop1: lost filesystem error report for type 5 error -117
> EXT4-fs (loop1): mounted filesystem 00000000-0000-0000-0000-000000000000 =
r/w without journal. Quota mode: none.
> =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
> BUG: KASAN: use-after-free in ext4_dirent_get_data_len fs/ext4/ext4.h:404=
0 [inline]
> BUG: KASAN: use-after-free in ext4_dir_entry_len fs/ext4/ext4.h:4060 [inl=
ine]
> BUG: KASAN: use-after-free in __ext4_check_dir_entry+0x527/0xa70 fs/ext4/=
dir.c:96
> Read of size 1 at addr ffff88810da3609c by task syz.1.20/5966
>
> CPU: 0 UID: 0 PID: 5966 Comm: syz.1.20 Not tainted syzkaller #0 PREEMPT(f=
ull)
> Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS 1.16.2-debian-1.=
16.2-1 04/01/2014
> Call Trace:
>  <TASK>
>  dump_stack_lvl+0xe8/0x150 lib/dump_stack.c:120
>  print_address_description mm/kasan/report.c:378 [inline]
>  print_report+0xba/0x230 mm/kasan/report.c:482
>  kasan_report+0x117/0x150 mm/kasan/report.c:595
>  ext4_dirent_get_data_len fs/ext4/ext4.h:4040 [inline]
>  ext4_dir_entry_len fs/ext4/ext4.h:4060 [inline]
>  __ext4_check_dir_entry+0x527/0xa70 fs/ext4/dir.c:96
>  ext4_inlinedir_to_tree+0x6be/0xbf0 fs/ext4/inline.c:1322
>  ext4_htree_fill_tree+0x50b/0x1230 fs/ext4/namei.c:1184
>  ext4_dx_readdir fs/ext4/dir.c:600 [inline]
>  ext4_readdir+0x2f7b/0x3870 fs/ext4/dir.c:146
>  iterate_dir+0x399/0x570 fs/readdir.c:108
>  __do_sys_getdents64 fs/readdir.c:412 [inline]
>  __se_sys_getdents64+0xf1/0x280 fs/readdir.c:397
>  do_syscall_x64 arch/x86/entry/syscall_64.c:63 [inline]
>  do_syscall_64+0x14d/0xf80 arch/x86/entry/syscall_64.c:94
>  entry_SYSCALL_64_after_hwframe+0x77/0x7f
> RIP: 0033:0x7fb82a19c819
> Code: ff c3 66 2e 0f 1f 84 00 00 00 00 00 0f 1f 44 00 00 48 89 f8 48 89 f=
7 48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 ff=
 ff 73 01 c3 48 c7 c1 e8 ff ff ff f7 d8 64 89 01 48
> RSP: 002b:00007fb82b01a028 EFLAGS: 00000246 ORIG_RAX: 00000000000000d9
> RAX: ffffffffffffffda RBX: 00007fb82a415fa0 RCX: 00007fb82a19c819
> RDX: 000000000000ff80 RSI: 9999999999999999 RDI: 0000000000000004
> RBP: 00007fb82a232c91 R08: 0000000000000000 R09: 0000000000000000
> R10: 0000000000000000 R11: 0000000000000246 R12: 0000000000000000
> R13: 00007fb82a416038 R14: 00007fb82a415fa0 R15: 00007ffdc30464e8
>  </TASK>
>
> The buggy address belongs to the physical page:
> page: refcount:0 mapcount:0 mapping:0000000000000000 index:0xffff88810da3=
6000 pfn:0x10da36
> flags: 0x17ff00000000000(node=3D0|zone=3D2|lastcpupid=3D0x7ff)
> page_type: f0(buddy)
> raw: 017ff00000000000 ffffea0004364708 ffffea000436a7c8 0000000000000000
> raw: ffff88810da36000 0000000000000000 00000000f0000000 0000000000000000
> page dumped because: kasan: bad access detected
> page_owner tracks the page as freed
> page last allocated via order 0, migratetype Unmovable, gfp_mask 0xd2c00(=
GFP_NOIO|__GFP_NOWARN|__GFP_NORETRY|__GFP_COMP|__GFP_NOMEMALLOC), pid 1, tg=
id 1 (swapper/0), ts 15037633903, free_ts 26770192426
>  set_page_owner include/linux/page_owner.h:32 [inline]
>  post_alloc_hook+0x231/0x280 mm/page_alloc.c:1889
>  prep_new_page mm/page_alloc.c:1897 [inline]
>  get_page_from_freelist+0x24dc/0x2580 mm/page_alloc.c:3962
>  __alloc_frozen_pages_noprof+0x18d/0x380 mm/page_alloc.c:5250
>  alloc_slab_page mm/slub.c:3292 [inline]
>  allocate_slab+0x77/0x660 mm/slub.c:3481
>  new_slab mm/slub.c:3539 [inline]
>  refill_objects+0x331/0x3c0 mm/slub.c:7175
>  refill_sheaf mm/slub.c:2812 [inline]
>  __pcs_replace_empty_main+0x2e6/0x730 mm/slub.c:4615
>  alloc_from_pcs mm/slub.c:4717 [inline]
>  slab_alloc_node mm/slub.c:4851 [inline]
>  __do_kmalloc_node mm/slub.c:5259 [inline]
>  __kmalloc_noprof+0x474/0x760 mm/slub.c:5272
>  kmalloc_noprof include/linux/slab.h:954 [inline]
>  usb_alloc_urb+0x46/0x150 drivers/usb/core/urb.c:75
>  usb_internal_control_msg drivers/usb/core/message.c:110 [inline]
>  usb_control_msg+0x118/0x3e0 drivers/usb/core/message.c:167
>  usb_get_descriptor+0xb1/0x3e0 drivers/usb/core/message.c:852
>  usb_get_configuration+0x3b9/0x54f0 drivers/usb/core/config.c:986
>  usb_enumerate_device drivers/usb/core/hub.c:2527 [inline]
>  usb_new_device+0x145/0x16f0 drivers/usb/core/hub.c:2665
>  register_root_hub+0x270/0x5f0 drivers/usb/core/hcd.c:990
>  usb_add_hcd+0xba1/0x10b0 drivers/usb/core/hcd.c:2987
>  vhci_hcd_probe+0x1fa/0x3e0 drivers/usb/usbip/vhci_hcd.c:1401
>  platform_probe+0xf9/0x190 drivers/base/platform.c:1418
> page last free pid 5262 tgid 5262 stack trace:
>  reset_page_owner include/linux/page_owner.h:25 [inline]
>  __free_pages_prepare mm/page_alloc.c:1433 [inline]
>  __free_frozen_pages+0xc2b/0xdb0 mm/page_alloc.c:2978
>  __slab_free+0x263/0x2b0 mm/slub.c:5573
>  qlink_free mm/kasan/quarantine.c:163 [inline]
>  qlist_free_all+0x97/0x100 mm/kasan/quarantine.c:179
>  kasan_quarantine_reduce+0x148/0x160 mm/kasan/quarantine.c:286
>  __kasan_slab_alloc+0x22/0x80 mm/kasan/common.c:350
>  kasan_slab_alloc include/linux/kasan.h:253 [inline]
>  slab_post_alloc_hook mm/slub.c:4538 [inline]
>  slab_alloc_node mm/slub.c:4866 [inline]
>  kmem_cache_alloc_noprof+0x2bc/0x650 mm/slub.c:4873
>  alloc_empty_file+0x55/0x1d0 fs/file_table.c:237
>  path_openat+0x10f/0x3860 fs/namei.c:4816
>  do_file_open+0x23e/0x4a0 fs/namei.c:4859
>  do_sys_openat2+0x113/0x200 fs/open.c:1366
>  do_sys_open fs/open.c:1372 [inline]
>  __do_sys_openat fs/open.c:1388 [inline]
>  __se_sys_openat fs/open.c:1383 [inline]
>  __x64_sys_openat+0x138/0x170 fs/open.c:1383
>  do_syscall_x64 arch/x86/entry/syscall_64.c:63 [inline]
>  do_syscall_64+0x14d/0xf80 arch/x86/entry/syscall_64.c:94
>  entry_SYSCALL_64_after_hwframe+0x77/0x7f
>
> Memory state around the buggy address:
>  ffff88810da35f80: 00 00 00 00 00 00 00 04 fc fc fc fc fc fc fc fc
>  ffff88810da36000: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
> >ffff88810da36080: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
>                             ^
>  ffff88810da36100: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
>  ffff88810da36180: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
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
> To test a patch for this bug, please reply with `#syz test`
> (should be on a separate line).
>
> The patch should be attached to the email.
> Note: arguments like custom git repos and branches are not supported.
>
> The email will later be sent to:
> [adilger.kernel@dilger.ca adilger@dilger.ca artem.blagodarenko@gmail.com =
linux-ext4@vger.kernel.org pravin.shelar@sun.com]
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
-upstream-moderation/69e2e6c5.a00a0220.1bd0ca.0034.GAE%40google.com.
