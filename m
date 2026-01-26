Received: from mail-oi1-f181.google.com (mail-oi1-f181.google.com [209.85.167.181])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3D56E405F7
	for <syzbot@lists.linux.dev>; Mon, 26 Jan 2026 12:08:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.167.181
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769429284; cv=pass; b=ssqWc1wNYmifT4jgdEPbj9RGuKtHP+zAnLGvRBsLbTnUkFUThRClxN7AwC3Nja6e/vI2iAuOvco/n9F0V8MJjB3SUacIR4VqkOdgt1CYUgy1pZxORMb1qsIqL6H4S2nSir8VBVREZssn1Qxuz/VQ2dMuQeMyvkwD8bp6Sd649o0=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769429284; c=relaxed/simple;
	bh=vSVo/XcOa5u6omq3ahq99rjuLrPTA4w5uuR/rbV9JaQ=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=eAF0cLSOcSlszR4qZ2aXpJMAd2+/XoiVKw442PMejkiW/czhFEfLxOvBZ4dh0Bf7D2jZShrYQTFqVEQE1IjESD7+9SKVAS/b6wKAq9jk8p7eCo1fT+2gh83bge/cD1g1RCE80ZO5MYlNr/zHdHKbpFrZWXBD/UxsLppXYTr9LpU=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=ac4OWQ1M; arc=pass smtp.client-ip=209.85.167.181
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="ac4OWQ1M"
Received: by mail-oi1-f181.google.com with SMTP id 5614622812f47-45c8b850f96so2918868b6e.0
        for <syzbot@lists.linux.dev>; Mon, 26 Jan 2026 04:08:01 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1769429281; cv=none;
        d=google.com; s=arc-20240605;
        b=in3BoTHbdR5Do/TGK2GZfyaA9cYzyZD79Ib6CbZMtjZ4xMngdaz9sBtTm/bYWcI99O
         WSnOSjjC9/uUBKtum2PyxAHd1VVFiL1ytjxH3j68Ow/9/o7gJLjzyAQsega6jzjlrzr5
         IS2UEe1qdq30s4xTLyxTFFm97EBsse8PiaU2HNHcMc8Elr9ydtwHBJZbQ4oa1+qSo83Y
         ny/iFK2AUwX/qDqimmhKnH1bq9jqtuPW+2i9gspFglhhX8+o+kgBZp9S2npFSXL4SNV8
         rFVjPBcZosU5+7UOeEusU9BZVqo7i3/vOtGfXRKuZAiqt6MzQeYn8cnLiUO41LSiVUAp
         DDUQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=LO19CGx2MmQOTTYbiJdUWr/JyIOhKgFamiE1K+quqlc=;
        fh=2oK7CEFRHp4qG9+/o/ZATaCwzjnTUnPYokd7Q6yKPWA=;
        b=YaRwZyPrDcLvlKHr9PjjHUpGKd3mUuopnQ5iNTGnic6Qt/+PRz5PEuwyMDx7zH56nw
         gmQtdTgAZ5lYInhnVeSUOzVzutxn6Et6PeyO+zaXbv+T/hBWw2z/nDIQAoZp6FDsbTNs
         f9CpRXdzqLnyabk2qHeOJ1STfH4qnFt1nEGd2n3NbsSav2GIjnpluY/daIvJPs53lX+O
         PMKlFNUJ2VuOEDLviPiVtWl33QK8+qiR4DdLCywIqMGtjj1Y27gtfodYgGtGTh7tXTVL
         dFL770RdN5FFFJsTefiHGVM8JssEoCcqXY1jiBE5S3cYe1CfGZfQGvt6NRAfSfYXtPhO
         P8uQ==;
        darn=lists.linux.dev
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1769429281; x=1770034081; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=LO19CGx2MmQOTTYbiJdUWr/JyIOhKgFamiE1K+quqlc=;
        b=ac4OWQ1M0t8/p4x5IDsib1dc/mWX5bT3ZjBKeZUPXI3z1yo3PbonnK3cOMeOUoECqX
         l2ljtv3Zt1s+XILQ5/T4Xoi9By4tqtB80ix2ZP4x7uzbhlYidIwf6DVowEbK/GbaC+t9
         N85EQODnlnQBWMvm9vYchjNEW2pMhU4wKKNhlGx4bpC4wdKrXWpwuNV0nTolPUDTz00F
         7ORrW1DsOsvIjXoO5o8LHo9P/Pfn4folfVx2IPkCnbk9gt8mCBfJIXJlZJNkwIow28Yv
         fU3Bo3LA8JNKdezfJNd3sPS4lWG6E9GXyDqDNQU9TgjZMDgdzMP6eFnS8y4C9C4bw18z
         Gw/w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1769429281; x=1770034081;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=LO19CGx2MmQOTTYbiJdUWr/JyIOhKgFamiE1K+quqlc=;
        b=IypK68ErLfwzkuD4XnNZYyQeiAkipaDr2LsSpRZCXnRcRHI9gIz7hNbwoCFabmAuWN
         Uc95ZzChiSde65Dbi+OvnVsSkwbZui15eu/EsAn/t19dpj9BIi1WGnLG/8B8ACyci22q
         jvRTkm6l7LWg5mR9n5ubCq2UfKNkopshh9qLGQ0vVWlz+9fKY9YyuvXc1xgaB2SzpEk/
         XT3Z7LBOjkUgtC2kNhZ/XGBQviYLz588HPrRHvhWl0qrE6XbTj26pWPaJrJqAHdNIf8m
         7dn0YRwD8F1n3HP3cTuL7UItepQCK8uR/RsoK1LqR91MUpvjJHMIqkVz2KxKCMpkxf39
         +5Zg==
X-Forwarded-Encrypted: i=1; AJvYcCXhmOAptvQ+1saYv1dY79r0dj4xu5UaKgbkhAjL+HYGkG8RSzqlP5C4UOzYBGOL9nNkU0qExZs=@lists.linux.dev
X-Gm-Message-State: AOJu0YwjEfSjH2/yC5LtUNNT/rX66QVAbOYIllpZ3mYKSX+agKzAb+Hp
	P0xZSsCQNQjDM4+7MmiiyfW8CWPB338yLRwSr138h3e9ZPPf4BA5hS7nSfCtb+DRzj6FX5C/3fI
	jx0sScp+Oerw/7XW/WGILwsxTwxzA8S/5dk+xsqsk
X-Gm-Gg: AZuq6aJOPOCcFytkhCOSSpv7h1AME74i0nKIEVGgV5hFJUJgzsW2HjW68LwP8Yoje3d
	yJaDoQOamk/gkO6E+2dCNkVUjBLlSn1cXkbvkNkltHLTfot1vKQw/f34in4A6y0Lb079frHM8Nb
	s2IZty/ALVNE15Xkt1rNqX0UeFUci5nxg61cVlZvMrP8qf1YUUU8amo84SqQZmRIcyljhVB5BGf
	NGWDwBUiEUQuCntsqaf6TouFVd4BQTLi7fEFisIjJDmCTiWR6RQ7gZy+aiRxvIoJvTAXeFMCYL5
	hZDmw3xErOSl0CTzJAe9a8JP9Gf1QPNovSPL4F9hcqVqWSU+d3nQZwzatCv6RbwQ3w==
X-Received: by 2002:a05:6808:3509:b0:44d:a0ec:d9a5 with SMTP id
 5614622812f47-45ed9777505mr2043114b6e.1.1769429280816; Mon, 26 Jan 2026
 04:08:00 -0800 (PST)
Precedence: bulk
X-Mailing-List: syzbot@lists.linux.dev
List-Id: <syzbot.lists.linux.dev>
List-Subscribe: <mailto:syzbot+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:syzbot+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <69775114.050a0220.1d05e9.0017.GAE@google.com>
In-Reply-To: <69775114.050a0220.1d05e9.0017.GAE@google.com>
From: Aleksandr Nogikh <nogikh@google.com>
Date: Mon, 26 Jan 2026 13:07:49 +0100
X-Gm-Features: AZwV_QjZbso09C9SPNFwqXKN7mjCyGloSY5gle7-0nW7qJkF_DMlz5GVfooJuXs
Message-ID: <CANp29Y7_T-OkKK+LgjvXk-sbDQBvVY0EJfXYkOvuek53zR6RWg@mail.gmail.com>
Subject: Re: [moderation/CI] Re: nfc: nci: Fix race between rfkill and nci_unregister_device().
To: syzbot ci <syzbot+ci40448fefc50d1f1a@syzkaller.appspotmail.com>
Cc: syzkaller-upstream-moderation@googlegroups.com, syzbot@lists.linux.dev
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

#syz upstream

On Mon, Jan 26, 2026 at 12:33=E2=80=AFPM syzbot ci
<syzbot+ci40448fefc50d1f1a@syzkaller.appspotmail.com> wrote:
>
> syzbot ci has tested the following series
>
> [v1] nfc: nci: Fix race between rfkill and nci_unregister_device().
> https://lore.kernel.org/all/20260126071359.2693214-1-kuniyu@google.com
> * [PATCH v1 net] nfc: nci: Fix race between rfkill and nci_unregister_dev=
ice().
>
> and found the following issue:
> KASAN: slab-use-after-free Read in nci_unregister_device
>
> Full report is available here:
> https://ci.syzbot.org/series/1b1f8783-f1b1-4eaf-8140-aeb610bb4b90
>
> ***
>
> KASAN: slab-use-after-free Read in nci_unregister_device
>
> tree:      net
> URL:       https://kernel.googlesource.com/pub/scm/linux/kernel/git/netde=
v/net.git
> base:      1742272bd3fae6362301d0f11eb9db9030348afc
> arch:      amd64
> compiler:  Debian clang version 21.1.8 (++20251221033036+2078da43e25a-1~e=
xp1~20251221153213.50), Debian LLD 21.1.8
> config:    https://ci.syzbot.org/builds/f8117535-23ea-4dd0-8208-c2a71b5d6=
f69/config
> C repro:   https://ci.syzbot.org/findings/0d078d52-d526-410a-b2a3-55b7b31=
4bf59/c_repro
> syz repro: https://ci.syzbot.org/findings/0d078d52-d526-410a-b2a3-55b7b31=
4bf59/syz_repro
>
> =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
> BUG: KASAN: slab-use-after-free in nci_unregister_device+0x123/0x230 net/=
nfc/nci/core.c:1320
> Read of size 8 at addr ffff888113d56628 by task syz.0.17/5980
>
> CPU: 1 UID: 0 PID: 5980 Comm: syz.0.17 Not tainted syzkaller #0 PREEMPT(f=
ull)
> Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS 1.16.2-debian-1.=
16.2-1 04/01/2014
> Call Trace:
>  <TASK>
>  dump_stack_lvl+0xe8/0x150 lib/dump_stack.c:120
>  print_address_description mm/kasan/report.c:378 [inline]
>  print_report+0xba/0x230 mm/kasan/report.c:482
>  kasan_report+0x117/0x150 mm/kasan/report.c:595
>  nci_unregister_device+0x123/0x230 net/nfc/nci/core.c:1320
>  virtual_ncidev_close+0x56/0x90 drivers/nfc/virtual_ncidev.c:168
>  __fput+0x44f/0xa70 fs/file_table.c:468
>  task_work_run+0x1d9/0x270 kernel/task_work.c:233
>  resume_user_mode_work include/linux/resume_user_mode.h:50 [inline]
>  __exit_to_user_mode_loop kernel/entry/common.c:44 [inline]
>  exit_to_user_mode_loop+0xed/0x480 kernel/entry/common.c:75
>  __exit_to_user_mode_prepare include/linux/irq-entry-common.h:226 [inline=
]
>  syscall_exit_to_user_mode_prepare include/linux/irq-entry-common.h:256 [=
inline]
>  syscall_exit_to_user_mode_work include/linux/entry-common.h:159 [inline]
>  syscall_exit_to_user_mode include/linux/entry-common.h:194 [inline]
>  do_syscall_64+0x2b7/0xf80 arch/x86/entry/syscall_64.c:100
>  entry_SYSCALL_64_after_hwframe+0x77/0x7f
> RIP: 0033:0x7f148199acb9
> Code: ff c3 66 2e 0f 1f 84 00 00 00 00 00 0f 1f 44 00 00 48 89 f8 48 89 f=
7 48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 ff=
 ff 73 01 c3 48 c7 c1 e8 ff ff ff f7 d8 64 89 01 48
> RSP: 002b:00007fff4e2266c8 EFLAGS: 00000246 ORIG_RAX: 00000000000001b4
> RAX: 0000000000000000 RBX: 00007f1481c17da0 RCX: 00007f148199acb9
> RDX: 0000000000000000 RSI: 000000000000001e RDI: 0000000000000003
> RBP: 00007f1481c17da0 R08: 0000000000000006 R09: 0000000000000000
> R10: 00007f1481c17cb0 R11: 0000000000000246 R12: 0000000000012770
> R13: 00007f1481c1609c R14: 00000000000124bb R15: 00007f1481c16090
>  </TASK>
>
> Allocated by task 13:
>  kasan_save_stack mm/kasan/common.c:57 [inline]
>  kasan_save_track+0x3e/0x80 mm/kasan/common.c:78
>  poison_kmalloc_redzone mm/kasan/common.c:398 [inline]
>  __kasan_kmalloc+0x93/0xb0 mm/kasan/common.c:415
>  kasan_kmalloc include/linux/kasan.h:263 [inline]
>  __do_kmalloc_node mm/slub.c:5657 [inline]
>  __kmalloc_node_track_caller_noprof+0x558/0x7f0 mm/slub.c:5768
>  alloc_dr drivers/base/devres.c:119 [inline]
>  devm_kmalloc+0x7f/0x300 drivers/base/devres.c:864
>  devm_kzalloc include/linux/device/devres.h:54 [inline]
>  nci_core_conn_create_rsp_packet net/nfc/nci/rsp.c:282 [inline]
>  nci_rsp_packet+0x894/0x3200 net/nfc/nci/rsp.c:384
>  nci_rx_work+0x1f8/0x3f0 net/nfc/nci/core.c:1551
>  process_one_work kernel/workqueue.c:3257 [inline]
>  process_scheduled_works+0xaec/0x17a0 kernel/workqueue.c:3340
>  worker_thread+0x89f/0xd90 kernel/workqueue.c:3421
>  kthread+0x726/0x8b0 kernel/kthread.c:463
>  ret_from_fork+0x51b/0xa40 arch/x86/kernel/process.c:158
>  ret_from_fork_asm+0x1a/0x30 arch/x86/entry/entry_64.S:246
>
> Freed by task 5980:
>  kasan_save_stack mm/kasan/common.c:57 [inline]
>  kasan_save_track+0x3e/0x80 mm/kasan/common.c:78
>  kasan_save_free_info+0x46/0x50 mm/kasan/generic.c:584
>  poison_slab_object mm/kasan/common.c:253 [inline]
>  __kasan_slab_free+0x5c/0x80 mm/kasan/common.c:285
>  kasan_slab_free include/linux/kasan.h:235 [inline]
>  slab_free_hook mm/slub.c:2540 [inline]
>  slab_free mm/slub.c:6674 [inline]
>  kfree+0x1be/0x650 mm/slub.c:6882
>  release_nodes drivers/base/devres.c:506 [inline]
>  devres_release_all+0x1b2/0x240 drivers/base/devres.c:535
>  device_del+0x736/0x8f0 drivers/base/core.c:3893
>  nfc_unregister_device+0x19c/0x330 net/nfc/core.c:1188
>  nci_unregister_device+0x42/0x230 net/nfc/nci/core.c:1306
>  virtual_ncidev_close+0x56/0x90 drivers/nfc/virtual_ncidev.c:168
>  __fput+0x44f/0xa70 fs/file_table.c:468
>  task_work_run+0x1d9/0x270 kernel/task_work.c:233
>  resume_user_mode_work include/linux/resume_user_mode.h:50 [inline]
>  __exit_to_user_mode_loop kernel/entry/common.c:44 [inline]
>  exit_to_user_mode_loop+0xed/0x480 kernel/entry/common.c:75
>  __exit_to_user_mode_prepare include/linux/irq-entry-common.h:226 [inline=
]
>  syscall_exit_to_user_mode_prepare include/linux/irq-entry-common.h:256 [=
inline]
>  syscall_exit_to_user_mode_work include/linux/entry-common.h:159 [inline]
>  syscall_exit_to_user_mode include/linux/entry-common.h:194 [inline]
>  do_syscall_64+0x2b7/0xf80 arch/x86/entry/syscall_64.c:100
>  entry_SYSCALL_64_after_hwframe+0x77/0x7f
>
> The buggy address belongs to the object at ffff888113d56600
>  which belongs to the cache kmalloc-128 of size 128
> The buggy address is located 40 bytes inside of
>  freed 128-byte region [ffff888113d56600, ffff888113d56680)
>
> The buggy address belongs to the physical page:
> page: refcount:0 mapcount:0 mapping:0000000000000000 index:0xffff888113d5=
6900 pfn:0x113d56
> flags: 0x17ff00000000200(workingset|node=3D0|zone=3D2|lastcpupid=3D0x7ff)
> page_type: f5(slab)
> raw: 017ff00000000200 ffff888100041a00 ffff888100040648 ffffea00044fbf90
> raw: ffff888113d56900 000000000010000c 00000000f5000000 0000000000000000
> page dumped because: kasan: bad access detected
> page_owner tracks the page as allocated
> page last allocated via order 0, migratetype Unmovable, gfp_mask 0x52cc0(=
GFP_KERNEL|__GFP_NOWARN|__GFP_NORETRY|__GFP_COMP), pid 5277, tgid 5277 (ude=
vadm), ts 29935854573, free_ts 29929951093
>  set_page_owner include/linux/page_owner.h:32 [inline]
>  post_alloc_hook+0x228/0x280 mm/page_alloc.c:1884
>  prep_new_page mm/page_alloc.c:1892 [inline]
>  get_page_from_freelist+0x24dc/0x2580 mm/page_alloc.c:3945
>  __alloc_frozen_pages_noprof+0x18d/0x380 mm/page_alloc.c:5240
>  alloc_pages_mpol+0x232/0x4a0 mm/mempolicy.c:2486
>  alloc_slab_page mm/slub.c:3075 [inline]
>  allocate_slab+0x86/0x3a0 mm/slub.c:3248
>  new_slab mm/slub.c:3302 [inline]
>  ___slab_alloc+0xd82/0x1760 mm/slub.c:4656
>  __slab_alloc+0x65/0x100 mm/slub.c:4779
>  __slab_alloc_node mm/slub.c:4855 [inline]
>  slab_alloc_node mm/slub.c:5251 [inline]
>  __kmalloc_cache_noprof+0x40d/0x6e0 mm/slub.c:5775
>  kmalloc_noprof include/linux/slab.h:957 [inline]
>  kzalloc_noprof include/linux/slab.h:1094 [inline]
>  kernfs_get_open_node fs/kernfs/file.c:543 [inline]
>  kernfs_fop_open+0x7b5/0xca0 fs/kernfs/file.c:718
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
> page last free pid 5277 tgid 5277 stack trace:
>  reset_page_owner include/linux/page_owner.h:25 [inline]
>  free_pages_prepare mm/page_alloc.c:1433 [inline]
>  __free_frozen_pages+0xbb0/0xd10 mm/page_alloc.c:2973
>  __slab_free+0x2ce/0x320 mm/slub.c:6008
>  qlink_free mm/kasan/quarantine.c:163 [inline]
>  qlist_free_all+0x97/0x100 mm/kasan/quarantine.c:179
>  kasan_quarantine_reduce+0x148/0x160 mm/kasan/quarantine.c:286
>  __kasan_slab_alloc+0x22/0x80 mm/kasan/common.c:350
>  kasan_slab_alloc include/linux/kasan.h:253 [inline]
>  slab_post_alloc_hook mm/slub.c:4953 [inline]
>  slab_alloc_node mm/slub.c:5263 [inline]
>  __do_kmalloc_node mm/slub.c:5656 [inline]
>  __kmalloc_noprof+0x3c2/0x7e0 mm/slub.c:5669
>  kmalloc_noprof include/linux/slab.h:961 [inline]
>  kernfs_fop_write_iter+0x158/0x540 fs/kernfs/file.c:329
>  new_sync_write fs/read_write.c:593 [inline]
>  vfs_write+0x61d/0xb90 fs/read_write.c:686
>  ksys_write+0x150/0x270 fs/read_write.c:738
>  do_syscall_x64 arch/x86/entry/syscall_64.c:63 [inline]
>  do_syscall_64+0xe2/0xf80 arch/x86/entry/syscall_64.c:94
>  entry_SYSCALL_64_after_hwframe+0x77/0x7f
>
> Memory state around the buggy address:
>  ffff888113d56500: fa fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb
>  ffff888113d56580: fc fc fc fc fc fc fc fc fc fc fc fc fc fc fc fc
> >ffff888113d56600: fa fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb
>                                   ^
>  ffff888113d56680: fc fc fc fc fc fc fc fc fc fc fc fc fc fc fc fc
>  ffff888113d56700: 00 00 00 00 00 00 00 00 00 00 00 00 00 fc fc fc
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
> [davem@davemloft.net edumazet@google.com horms@kernel.org ilane@ti.com ku=
ba@kernel.org kuni1840@gmail.com kuniyu@google.com netdev@vger.kernel.org p=
abeni@redhat.com syzbot@syzkaller.appspotmail.com]
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
-upstream-moderation/69775114.050a0220.1d05e9.0017.GAE%40google.com.
