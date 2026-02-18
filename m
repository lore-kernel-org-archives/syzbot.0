Received: from mail-oa1-f46.google.com (mail-oa1-f46.google.com [209.85.160.46])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1A07426A09B
	for <syzbot@lists.linux.dev>; Wed, 18 Feb 2026 08:44:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.160.46
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771404287; cv=pass; b=GyXKo3jjq9x/K32W5rt1Q1lRsUjXheO9SRbfbjNTl2+DB8Td1QbUvM2LbOpmHf/ntpDhbMVAeOaUBFDL8LBT5gC024IjLLit+C4M2yL0AZqCiUovPlsg/AmDXEVCqggKIocw0qll2T5wiWPZX6FzslaA15v6x/zhEV7SI73uqow=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771404287; c=relaxed/simple;
	bh=3yLdR6vJm8ZiuH6Ks+0zvWcvquMmXon2OQlhLVW/5dc=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=ZIGFUqFrpdN9YYfDkIuS6POWTYq49ZecWdHnXgqbnfkKIN2/abwEAH8VuMJLNCqrjDSs5CqIEx4r+Wbrkyk1Ss9a0mpvFTdnSr4w2aygzX/PKY8Na9KmEXl8JIUu7/EYrvR6L6eavPnFJdeAHKWvbHKcvOYykPtDExr7fcfKWro=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=qkfcAEtq; arc=pass smtp.client-ip=209.85.160.46
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="qkfcAEtq"
Received: by mail-oa1-f46.google.com with SMTP id 586e51a60fabf-40429b1d8baso1718912fac.0
        for <syzbot@lists.linux.dev>; Wed, 18 Feb 2026 00:44:45 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1771404285; cv=none;
        d=google.com; s=arc-20240605;
        b=C+/IdmRux8YTHN1do2Ug9ZPRr3iFa5N4rig2HR8ywjLJiaTKWcNJfKUrivlnSEbnQ9
         D8fuuP8/l+TnkBWJa7c+T/l+nMi0LUG1y9nGcnRKA1PXP5Ue2xTSW/xcpwfzXgCqMLfV
         ekgY2yQ54h0oyBGXGrn8YlsrvLevepYtDcYy+vZHhgHBKX/eCNHi4xHawS86IrWnympw
         YG8vdSNFemS22gwa1J0Z9ZEghE1p1QtZJaw2RVNLqD4IegZLiWTJZ0C69lZd7AeCV26t
         JmrCvKqBrkvprbsSlv3uJYnK1F9dhLsOrHaqDwl7TKSYOK0S1+mccGCv6gGTRiEfAa3z
         tgjQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=c6T9HlUkJkn+6py2UgJEZvB1c7PNNFnsqrBOYt5rzEY=;
        fh=q3tLEnyfZ4jgfCUnTL779mdtgXtBl2/5Gai2cgXXZy4=;
        b=clmB2ffCwe2e/2dT7roo8unT9VmLYWqmyB1VT9ObWUFwlyxKhGwH4gX4zRqX0AZWZW
         Jb7WNDHAYrwa/oGVTpE6wiHp2jrNIN1voGz8OnEvsuo4cpxm1+Gq7twY1Abo079Uk7yg
         d0whmaDfckyVesmz1Hfy9aJqkp4dtlxYdn05GIn2VVDLjKkYV8X2Sra7hbowddxSIX4V
         I7OktfifFFdGzk7SWpWxoHTvqyKoKbqNoHAttWbfMF4Q7sy/kwHXEdbDFCG2scfgjiHR
         YFYF4u+HxSEYyo6HPlAQTO1tsFEgsZYQms4D/rcpFk0m2/iyjpwm2Qygf3CSnotbrHYd
         RjYA==;
        darn=lists.linux.dev
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1771404285; x=1772009085; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=c6T9HlUkJkn+6py2UgJEZvB1c7PNNFnsqrBOYt5rzEY=;
        b=qkfcAEtqNCizR+aD5Yus0RL+VmzClweo1i1N3eDjtaP9g8tlK6jaVCw9HiUJOMJn6d
         uCmojy3v4bQqJZ89Kt5dMUUGuu9Vgoi9tPTlbG58/Rd+B4FIl0kZzj/A0oOo+YXnG8Q8
         OazBvPUgmntKAoSS0eGLQsw008BlxHHhYUevkD0EQQ4NrFsgq5iS4BZ0Dj1fdhS7NUk1
         c5CiGDiqrp4yKin9QFzp00b0QkTJNmA7ZBI3+k+Q0s60AcY3BaZ/jbFRpC9UL1u4wj5K
         vbgxAL+UpYK0evYUoped16RRlKeOoV3f4r/0cNZb2nWtCh+RYhzZhNc/6/ZCXgeOBjgd
         WyPw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1771404285; x=1772009085;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=c6T9HlUkJkn+6py2UgJEZvB1c7PNNFnsqrBOYt5rzEY=;
        b=L8XLYneOw7kgCIBsVePoXGyzEIxGclcE5R4fKew7eJBC6oLYKiIExI2pVIGKHEBe2m
         PWfKAE3y+z1vEc6RgOS/nO+bDLuRPGceJONCQ6NLwl9DTaCY9h2Cks/BHaBkOK072FHF
         dVT+2dNJrOPukG6ZZ2wdCW5sKyavkqZrjBSQmZMJFIRn1Im9uqu7FOa99aqAZmM81QUu
         6KGpMUSX9eOuJl9x1tLWQv+wtrTuwkBMIn5h5h9PZZ6VV2Oc31TNLccHbpipljqDRjFt
         1NdF0lCsjFlZKaHeLeuA2kZN17GuLOqHbVuv+EKMrGlwec5cv7Bsx1ou3LjNGPAU2lkb
         bkkg==
X-Forwarded-Encrypted: i=1; AJvYcCXit9ctYFXJLErNViTK4zUtzlLva8osVSJkMLrN11lROytsyoOnjw8cRaAwWxT//9ekpgXXcsg=@lists.linux.dev
X-Gm-Message-State: AOJu0YzxDnAXefR01uA/ANLiYpanXtJV4zS0qyCjhmdctYhNjkGzFBLR
	wkWkWqkyasTf8rw2WAkBVpmgT7c6cezXAeKxNuuye3bxRpGbLVjIvKG/0GBKJfTlHytWYnzwYX6
	a8SKCI86pvB5lzHviEKmVxlQ0FFStkeqZkRAyEib/t6r7za/+SwbZ4Pmk
X-Gm-Gg: AZuq6aLG5Y0XN/S69i2C8wg8uTPDEd1/AkO60vXVoQ4iR7Ba4mYkurBnUzXLTwBQU6M
	jaKpSx3l41e1rakL/GACH36qf/AkXYIiMc5B9p/dZ/PDeQ7lHvNo0HerXY7k94+ORg0aMF6ogkj
	zj5ZdIv6hXffclg9oTfIx5mdO21j/DPYWVw053G/DqEJrvqOL7HXJ1NUrhb2xodIvTU8SWvJ8b0
	0ao3tbaGb9BbASdeTbTDHG2OKMK7JUvM0HvYsRtBSM5roRZNqHLV+goKJapKbOCkuYpq8n0Ahw6
	ZxV48lUMcKAWh1XSdgvVTq2SofLWp+zYqHM9OiLeFk2eoSzaWGFOfryUAmB1D3qMLpHIug==
X-Received: by 2002:a05:6870:f148:b0:409:8ccb:bc29 with SMTP id
 586e51a60fabf-40ef40ece84mr7477524fac.59.1771404284452; Wed, 18 Feb 2026
 00:44:44 -0800 (PST)
Precedence: bulk
X-Mailing-List: syzbot@lists.linux.dev
List-Id: <syzbot.lists.linux.dev>
List-Subscribe: <mailto:syzbot+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:syzbot+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <69952e71.a70a0220.2c38d7.0110.GAE@google.com>
In-Reply-To: <69952e71.a70a0220.2c38d7.0110.GAE@google.com>
From: Aleksandr Nogikh <nogikh@google.com>
Date: Wed, 18 Feb 2026 09:44:33 +0100
X-Gm-Features: AaiRm50Tm1nmH0HL6WriyOrvu0elOfhxyBAWhVSpqu_P6vuMN5ufQHv839tUNFs
Message-ID: <CANp29Y5DP3c0ZdCoh8RO+Bb84bfefQBnPKFVCszDo1QDsA4LOg@mail.gmail.com>
Subject: Re: [moderation/CI] Re: fat: Add FS_IOC_GETFSLABEL /
 FS_IOC_SETFSLABEL ioctls
To: syzbot ci <syzbot+ci43a7f1c751c4d308@syzkaller.appspotmail.com>
Cc: syzkaller-upstream-moderation@googlegroups.com, syzbot@lists.linux.dev
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

#syz upstream

On Wed, Feb 18, 2026 at 4:13=E2=80=AFAM syzbot ci
<syzbot+ci43a7f1c751c4d308@syzkaller.appspotmail.com> wrote:
>
> syzbot ci has tested the following series
>
> [v2] fat: Add FS_IOC_GETFSLABEL / FS_IOC_SETFSLABEL ioctls
> https://lore.kernel.org/all/20260217230628.719475-1-ethan.ferguson@zetier=
.com
> * [PATCH v2 1/2] fat: Add FS_IOC_GETFSLABEL ioctl
> * [PATCH v2 2/2] fat: Add FS_IOC_SETFSLABEL ioctl
>
> and found the following issue:
> KASAN: stack-out-of-bounds Write in msdos_format_name
>
> Full report is available here:
> https://ci.syzbot.org/series/da73a18c-15c6-438b-8ee3-f34978d4930c
>
> ***
>
> KASAN: stack-out-of-bounds Write in msdos_format_name
>
> tree:      bpf-next
> URL:       https://kernel.googlesource.com/pub/scm/linux/kernel/git/bpf/b=
pf-next.git
> base:      9f2693489ef8558240d9e80bfad103650daed0af
> arch:      amd64
> compiler:  Debian clang version 21.1.8 (++20251221033036+2078da43e25a-1~e=
xp1~20251221153213.50), Debian LLD 21.1.8
> config:    https://ci.syzbot.org/builds/972e08c3-3f0c-4dc8-b311-d7aec3efb=
56b/config
> C repro:   https://ci.syzbot.org/findings/f100bebc-8929-4992-996b-73c5de2=
585ba/c_repro
> syz repro: https://ci.syzbot.org/findings/f100bebc-8929-4992-996b-73c5de2=
585ba/syz_repro
>
> loop0: rw=3D8912896, sector=3D1192, nr_sectors =3D 4 limit=3D256
> syz.0.17: attempt to access beyond end of device
> loop0: rw=3D8388608, sector=3D1192, nr_sectors =3D 4 limit=3D256
> =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
> BUG: KASAN: stack-out-of-bounds in msdos_format_name+0x5fe/0xd90 fs/fat/n=
amei_msdos.c:69
> Write of size 1 at addr ffffc90003a27dcb by task syz.0.17/5956
>
> CPU: 0 UID: 0 PID: 5956 Comm: syz.0.17 Not tainted syzkaller #0 PREEMPT(f=
ull)
> Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS 1.16.2-debian-1.=
16.2-1 04/01/2014
> Call Trace:
>  <TASK>
>  dump_stack_lvl+0xe8/0x150 lib/dump_stack.c:120
>  print_address_description mm/kasan/report.c:378 [inline]
>  print_report+0xba/0x230 mm/kasan/report.c:482
>  kasan_report+0x117/0x150 mm/kasan/report.c:595
>  msdos_format_name+0x5fe/0xd90 fs/fat/namei_msdos.c:69
>  fat_convert_volume_label_str fs/fat/file.c:193 [inline]
>  fat_ioctl_set_volume_label fs/fat/file.c:215 [inline]
>  fat_generic_ioctl+0xebd/0x12a0 fs/fat/file.c:246
>  vfs_ioctl fs/ioctl.c:51 [inline]
>  __do_sys_ioctl fs/ioctl.c:597 [inline]
>  __se_sys_ioctl+0xfc/0x170 fs/ioctl.c:583
>  do_syscall_x64 arch/x86/entry/syscall_64.c:63 [inline]
>  do_syscall_64+0xe2/0xf80 arch/x86/entry/syscall_64.c:94
>  entry_SYSCALL_64_after_hwframe+0x77/0x7f
> RIP: 0033:0x7fa55ed9bf79
> Code: ff c3 66 2e 0f 1f 84 00 00 00 00 00 0f 1f 44 00 00 48 89 f8 48 89 f=
7 48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 ff=
 ff 73 01 c3 48 c7 c1 e8 ff ff ff f7 d8 64 89 01 48
> RSP: 002b:00007ffe3b0c1748 EFLAGS: 00000246 ORIG_RAX: 0000000000000010
> RAX: ffffffffffffffda RBX: 00007fa55f015fa0 RCX: 00007fa55ed9bf79
> RDX: 0000200000000240 RSI: 0000000041009432 RDI: 0000000000000004
> RBP: 00007fa55ee327e0 R08: 0000000000000000 R09: 0000000000000000
> R10: 0000000000000000 R11: 0000000000000246 R12: 0000000000000000
> R13: 00007fa55f015fac R14: 00007fa55f015fa0 R15: 00007fa55f015fa0
>  </TASK>
>
> The buggy address belongs to stack of task syz.0.17/5956
>  and is located at offset 427 in frame:
>  fat_generic_ioctl+0x0/0x12a0
>
> This frame has 4 objects:
>  [32, 56) 'range.i'
>  [96, 352) 'from_user.i'
>  [416, 427) 'new_vol_label.i'
>  [448, 528) 'ia.i'
>
> The buggy address belongs to a 8-page vmalloc region starting at 0xffffc9=
0003a20000 allocated at copy_process+0x508/0x3980 kernel/fork.c:2052
> The buggy address belongs to the physical page:
> page: refcount:1 mapcount:0 mapping:0000000000000000 index:0x0 pfn:0x1750=
f7
> memcg:ffff888111b31502
> flags: 0x57ff00000000000(node=3D1|zone=3D2|lastcpupid=3D0x7ff)
> raw: 057ff00000000000 0000000000000000 dead000000000122 0000000000000000
> raw: 0000000000000000 0000000000000000 00000001ffffffff ffff888111b31502
> page dumped because: kasan: bad access detected
> page_owner tracks the page as allocated
> page last allocated via order 0, migratetype Unmovable, gfp_mask 0x29c2(G=
FP_NOWAIT|__GFP_HIGHMEM|__GFP_IO|__GFP_FS|__GFP_ZERO), pid 41, tgid 41 (kwo=
rker/u10:2), ts 69338575178, free_ts 66424269276
>  set_page_owner include/linux/page_owner.h:32 [inline]
>  post_alloc_hook+0x228/0x280 mm/page_alloc.c:1884
>  prep_new_page mm/page_alloc.c:1892 [inline]
>  get_page_from_freelist+0x24dc/0x2580 mm/page_alloc.c:3945
>  __alloc_frozen_pages_noprof+0x18d/0x380 mm/page_alloc.c:5240
>  alloc_pages_mpol+0x232/0x4a0 mm/mempolicy.c:2486
>  alloc_frozen_pages_noprof mm/mempolicy.c:2557 [inline]
>  alloc_pages_noprof+0xa8/0x190 mm/mempolicy.c:2577
>  vm_area_alloc_pages mm/vmalloc.c:3649 [inline]
>  __vmalloc_area_node mm/vmalloc.c:3863 [inline]
>  __vmalloc_node_range_noprof+0x79b/0x1730 mm/vmalloc.c:4051
>  __vmalloc_node_noprof+0xc2/0x100 mm/vmalloc.c:4111
>  alloc_thread_stack_node kernel/fork.c:354 [inline]
>  dup_task_struct+0x228/0x9a0 kernel/fork.c:923
>  copy_process+0x508/0x3980 kernel/fork.c:2052
>  kernel_clone+0x248/0x870 kernel/fork.c:2651
>  user_mode_thread+0x110/0x180 kernel/fork.c:2727
>  call_usermodehelper_exec_sync kernel/umh.c:132 [inline]
>  call_usermodehelper_exec_work+0x9c/0x230 kernel/umh.c:163
>  process_one_work kernel/workqueue.c:3257 [inline]
>  process_scheduled_works+0xaec/0x17a0 kernel/workqueue.c:3340
>  worker_thread+0xda6/0x1360 kernel/workqueue.c:3421
>  kthread+0x726/0x8b0 kernel/kthread.c:463
>  ret_from_fork+0x51b/0xa40 arch/x86/kernel/process.c:158
> page last free pid 5918 tgid 5918 stack trace:
>  reset_page_owner include/linux/page_owner.h:25 [inline]
>  free_pages_prepare mm/page_alloc.c:1433 [inline]
>  __free_frozen_pages+0xbf8/0xd70 mm/page_alloc.c:2973
>  discard_slab mm/slub.c:3346 [inline]
>  __put_partials+0x146/0x170 mm/slub.c:3886
>  __slab_free+0x294/0x320 mm/slub.c:5956
>  qlink_free mm/kasan/quarantine.c:163 [inline]
>  qlist_free_all+0x97/0x100 mm/kasan/quarantine.c:179
>  kasan_quarantine_reduce+0x148/0x160 mm/kasan/quarantine.c:286
>  __kasan_slab_alloc+0x22/0x80 mm/kasan/common.c:350
>  kasan_slab_alloc include/linux/kasan.h:253 [inline]
>  slab_post_alloc_hook mm/slub.c:4953 [inline]
>  slab_alloc_node mm/slub.c:5263 [inline]
>  __kmalloc_cache_noprof+0x36f/0x6e0 mm/slub.c:5775
>  kmalloc_noprof include/linux/slab.h:957 [inline]
>  kzalloc_noprof include/linux/slab.h:1094 [inline]
>  ref_tracker_alloc+0x161/0x4d0 lib/ref_tracker.c:271
>  __netdev_tracker_alloc include/linux/netdevice.h:4400 [inline]
>  netdev_hold include/linux/netdevice.h:4429 [inline]
>  netdev_queue_add_kobject net/core/net-sysfs.c:1994 [inline]
>  netdev_queue_update_kobjects+0x1d1/0x6c0 net/core/net-sysfs.c:2056
>  register_queue_kobjects net/core/net-sysfs.c:2119 [inline]
>  netdev_register_kobject+0x258/0x310 net/core/net-sysfs.c:2362
>  register_netdevice+0x12a0/0x1cd0 net/core/dev.c:11406
>  register_netdev+0x40/0x60 net/core/dev.c:11522
>  loopback_net_init+0x75/0x150 drivers/net/loopback.c:218
>  ops_init+0x35c/0x5c0 net/core/net_namespace.c:137
>  setup_net+0x118/0x340 net/core/net_namespace.c:446
>  copy_net_ns+0x50e/0x730 net/core/net_namespace.c:581
>
> Memory state around the buggy address:
>  ffffc90003a27c80: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
>  ffffc90003a27d00: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
> >ffffc90003a27d80: f2 f2 f2 f2 f2 f2 f2 f2 00 03 f2 f2 f8 f8 f8 f8
>                                               ^
>  ffffc90003a27e00: f8 f8 f8 f8 f8 f8 f3 f3 f3 f3 f3 f3 00 00 00 00
>  ffffc90003a27e80: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
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
> [ethan.ferguson@zetier.com hirofumi@mail.parknet.co.jp linux-fsdevel@vger=
.kernel.org linux-kernel@vger.kernel.org]
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
-upstream-moderation/69952e71.a70a0220.2c38d7.0110.GAE%40google.com.
