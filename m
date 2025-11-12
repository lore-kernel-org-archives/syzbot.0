Received: from mail-oi1-f180.google.com (mail-oi1-f180.google.com [209.85.167.180])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A568833B6E6
	for <syzbot@lists.linux.dev>; Wed, 12 Nov 2025 15:48:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.167.180
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762962504; cv=none; b=WoHFlHVr800levb0bzzvdKnhZxrTXP8FwVUsbvtrzzbXdk4HPIH5m3nTEfpMN4OKI5DXE+Lc5QHGQopJQL3f15JG+zvVgldIPKz3OuAhgJYo4ziI7Z25QGIeTc7aVVlqFqqityJF3DvFcmlLgjM96zTKMBIqbIRuyDLJywjwTH0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762962504; c=relaxed/simple;
	bh=EIx5/8k3KRA2JVFZcdbpTZ3Gncj5Oj9u+i90jqonpzs=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=BJ67mEeY3r+kp2QhUzNv3wLRJVWBRnZaPH67rNptgDdYK9JTiSvkEpGOBiVQWdjXMyxiyF0+pXnUrPCTjUZQnf5ecAiJpRUnk46aVr4uPDtRGwn/iL4CGk29wIjL3xfH0LTgMOs2PiTy5AhmVs09uPKlIk1Vpl1uSQ7NQoGFg1g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=dSK1cQ2t; arc=none smtp.client-ip=209.85.167.180
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="dSK1cQ2t"
Received: by mail-oi1-f180.google.com with SMTP id 5614622812f47-45045024527so266525b6e.1
        for <syzbot@lists.linux.dev>; Wed, 12 Nov 2025 07:48:22 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1762962502; x=1763567302; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=yeDSqTFcEtMwrGFQh08tlnGRd5wjSk2tovaF2dooiHM=;
        b=dSK1cQ2thX/lteTzofwsBe9UNOE9mpWNDtSnbqfsRjSSf2i4j9ME5pZ0+NRQSOGnnJ
         mtMgt2eInwiABmY8Gy8QjSIY50Gvz6RRMVEZUDAXorDD0l2V1crSMI20qTyCVPd31VCP
         fGeHs7Og+cQm2i/gUgQPGjxSwcX4kreEAcuBE1oAnlAcr/f+7GdsGvuaP9tzAS3t9zt8
         eAYA8qoB51/jZIfaVeAyeF4866ia7nAHh+2rIn342SYEHF4E3PVndz0razbqfudBgfQM
         2xMn8CpBbAdlT1mC9j43W2F/lZuX5qemCFtlz/eCKAHl5NUVKVvSM46gMBOsoM2tGLUh
         RCmA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1762962502; x=1763567302;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=yeDSqTFcEtMwrGFQh08tlnGRd5wjSk2tovaF2dooiHM=;
        b=gESeb+/1YVc01gGDI3tCuSxsWfPq9zF2dh74f2vfntQsPPOZ3cYnE+rE/yXjskt+Ft
         sV0SPQ3tJqGpFfBEIpsI9aKknkG9VIYapAKowvMxezu0XBeRZ4OKJaFwG2sl7FtoAo2B
         Vo4bhMawr1JwssB6YhIfrRBXu2uA9sbmkViF1fAR74C3Ubsy8Z3x6k24k2zEh49LU/Kp
         ejqydXIDXOy2ZQ8nhIVCza4qECpEFm3swpEjX1gVkRlW+Bt9c3n+Sxl9wp8bfVWwv3fd
         I5qbHAODUra7LvtpI1I0qhVUG0j8FQXjzGID50UQt9sRW2WRZW8fFrq0nKFeNecEa/j+
         Zq3Q==
X-Forwarded-Encrypted: i=1; AJvYcCUsOXHcA0+x0ZxsvkMx6HHg6jT8h+y6AEAgfxyMLOkH5helMy4ndbGdbukUXDup9ZEbCIdEJCk=@lists.linux.dev
X-Gm-Message-State: AOJu0YwuJvxB3z8nm+pZm34M3rD/vTlW5VI1HpvzFhaWedYHHhtBIhFA
	u6ZfERsUs7J6iTvINBwCri9defcO28KyeM5Muu/HDR8AblOu8cYZFsHxVFrAocmrZfcC2e8gfjG
	PiZDRa96M33T7lwaoMx6KZ2Gne8CKeMtgVlwKbO+U
X-Gm-Gg: ASbGncuw5Sb68F1R+Va6jOu4sNtvIsfPtbHb5C426x5ImRyJKd3CO82X8O0O4j7uKwm
	0detVPmvfxAVi5V/Tfx+92LAzgNOyWaen146CcAWifH0tdIRctCNEmgG2avw7cGR/iwEjcXDX8w
	HzvBow/VHYc5syaCTAZ36E+IbTtYpU/NbSubUkWoidUNSSwDzoXQZ1vBBy/qL93aaYvm7awhPVz
	pUFPEoVeKibKhOxJ1icP0e5fnA2TgcLZMa5WrC01OEi3k1zlXl9okdih00QvfZgmBSrTYJOQNbb
	Je2gSbofNIlxjV9+kZ0c/N3wnLyrQWcufWGF/FZN85B+Z7WbVlMWzJc=
X-Google-Smtp-Source: AGHT+IGp089OolDYz8zVjt7KUGFyAt43FLDRUD/H/EG/qXO5q9GVygd+98iMdBucbI8o7IfEU80B16daL+lXTVCAv9c=
X-Received: by 2002:a05:6808:f8b:b0:44f:9f6a:f022 with SMTP id
 5614622812f47-4506089e16bmr3395952b6e.15.1762962501379; Wed, 12 Nov 2025
 07:48:21 -0800 (PST)
Precedence: bulk
X-Mailing-List: syzbot@lists.linux.dev
List-Id: <syzbot.lists.linux.dev>
List-Subscribe: <mailto:syzbot+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:syzbot+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <6914a2f4.a70a0220.3124cb.0004.GAE@google.com>
In-Reply-To: <6914a2f4.a70a0220.3124cb.0004.GAE@google.com>
From: Aleksandr Nogikh <nogikh@google.com>
Date: Wed, 12 Nov 2025 16:48:09 +0100
X-Gm-Features: AWmQ_bnX_LA08AVKdhHE46joRJ_CW5uvrVV7DcMAqdvSJp6QzUXg-9q3efPH94s
Message-ID: <CANp29Y736hbEpjwngjF=6YmGj4aHbXxe7f3+YtU4n29L9GBABA@mail.gmail.com>
Subject: Re: [moderation/CI] Re: xfs: single block atomic writes for buffered IO
To: syzbot ci <syzbot+ci0a2621b0bce36927@syzkaller.appspotmail.com>
Cc: syzkaller-upstream-moderation@googlegroups.com, syzbot@lists.linux.dev
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

#syz upstream

On Wed, Nov 12, 2025 at 4:08=E2=80=AFPM syzbot ci
<syzbot+ci0a2621b0bce36927@syzkaller.appspotmail.com> wrote:
>
> syzbot ci has tested the following series
>
> [v1] xfs: single block atomic writes for buffered IO
> https://lore.kernel.org/all/cover.1762945505.git.ojaswin@linux.ibm.com
> * [RFC PATCH 1/8] fs: Rename STATX{_ATTR}_WRITE_ATOMIC -> STATX{_ATTR}_WR=
ITE_ATOMIC_DIO
> * [RFC PATCH 2/8] mm: Add PG_atomic
> * [RFC PATCH 3/8] fs: Add initial buffered atomic write support info to s=
tatx
> * [RFC PATCH 4/8] iomap: buffered atomic write support
> * [RFC PATCH 5/8] iomap: pin pages for RWF_ATOMIC buffered write
> * [RFC PATCH 6/8] xfs: Report atomic write min and max for buf io as well
> * [RFC PATCH 7/8] iomap: Add bs<ps buffered atomic writes support
> * [RFC PATCH 8/8] xfs: Lift the bs =3D=3D ps restriction for HW buffered =
atomic writes
>
> and found the following issue:
> KASAN: slab-out-of-bounds Read in __bitmap_clear
>
> Full report is available here:
> https://ci.syzbot.org/series/430a088a-50e2-46d3-87ff-a1f0fa67b66c
>
> ***
>
> KASAN: slab-out-of-bounds Read in __bitmap_clear
>
> tree:      linux-next
> URL:       https://kernel.googlesource.com/pub/scm/linux/kernel/git/next/=
linux-next
> base:      ab40c92c74c6b0c611c89516794502b3a3173966
> arch:      amd64
> compiler:  Debian clang version 20.1.8 (++20250708063551+0c9f909b7976-1~e=
xp1~20250708183702.136), Debian LLD 20.1.8
> config:    https://ci.syzbot.org/builds/02d3e137-5d7e-4c95-8f32-43b8663d9=
5df/config
> C repro:   https://ci.syzbot.org/findings/92a3582f-40a6-4936-8fcd-dc55c44=
7a432/c_repro
> syz repro: https://ci.syzbot.org/findings/92a3582f-40a6-4936-8fcd-dc55c44=
7a432/syz_repro
>
> =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
> BUG: KASAN: slab-out-of-bounds in __bitmap_clear+0x155/0x180 lib/bitmap.c=
:395
> Read of size 8 at addr ffff88816ced7cd0 by task kworker/0:1/10
>
> CPU: 0 UID: 0 PID: 10 Comm: kworker/0:1 Not tainted syzkaller #0 PREEMPT(=
full)
> Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS 1.16.2-debian-1.=
16.2-1 04/01/2014
> Workqueue: xfs-conv/loop0 xfs_end_io
> Call Trace:
>  <TASK>
>  dump_stack_lvl+0x189/0x250 lib/dump_stack.c:120
>  print_address_description mm/kasan/report.c:378 [inline]
>  print_report+0xca/0x240 mm/kasan/report.c:482
>  kasan_report+0x118/0x150 mm/kasan/report.c:595
>  __bitmap_clear+0x155/0x180 lib/bitmap.c:395
>  bitmap_clear include/linux/bitmap.h:496 [inline]
>  ifs_clear_range_atomic fs/iomap/buffered-io.c:241 [inline]
>  iomap_clear_range_atomic+0x25c/0x630 fs/iomap/buffered-io.c:268
>  iomap_finish_folio_write+0x2f0/0x410 fs/iomap/buffered-io.c:1971
>  iomap_finish_ioend_buffered+0x223/0x5e0 fs/iomap/ioend.c:58
>  iomap_finish_ioends+0x116/0x2b0 fs/iomap/ioend.c:295
>  xfs_end_ioend+0x50b/0x690 fs/xfs/xfs_aops.c:168
>  xfs_end_io+0x253/0x2d0 fs/xfs/xfs_aops.c:205
>  process_one_work+0x94a/0x15d0 kernel/workqueue.c:3267
>  process_scheduled_works kernel/workqueue.c:3350 [inline]
>  worker_thread+0x9b0/0xee0 kernel/workqueue.c:3431
>  kthread+0x711/0x8a0 kernel/kthread.c:463
>  ret_from_fork+0x599/0xb30 arch/x86/kernel/process.c:158
>  ret_from_fork_asm+0x1a/0x30 arch/x86/entry/entry_64.S:245
>  </TASK>
>
> Allocated by task 5952:
>  kasan_save_stack mm/kasan/common.c:56 [inline]
>  kasan_save_track+0x3e/0x80 mm/kasan/common.c:77
>  poison_kmalloc_redzone mm/kasan/common.c:397 [inline]
>  __kasan_kmalloc+0x93/0xb0 mm/kasan/common.c:414
>  kasan_kmalloc include/linux/kasan.h:262 [inline]
>  __do_kmalloc_node mm/slub.c:5672 [inline]
>  __kmalloc_noprof+0x41d/0x800 mm/slub.c:5684
>  kmalloc_noprof include/linux/slab.h:961 [inline]
>  kzalloc_noprof include/linux/slab.h:1094 [inline]
>  ifs_alloc+0x1e4/0x530 fs/iomap/buffered-io.c:356
>  iomap_writeback_folio+0x81c/0x26a0 fs/iomap/buffered-io.c:2084
>  iomap_writepages+0x162/0x2d0 fs/iomap/buffered-io.c:2168
>  xfs_vm_writepages+0x28a/0x300 fs/xfs/xfs_aops.c:701
>  do_writepages+0x32e/0x550 mm/page-writeback.c:2598
>  filemap_writeback mm/filemap.c:387 [inline]
>  filemap_fdatawrite_range mm/filemap.c:412 [inline]
>  file_write_and_wait_range+0x23e/0x340 mm/filemap.c:786
>  xfs_file_fsync+0x195/0x800 fs/xfs/xfs_file.c:137
>  generic_write_sync include/linux/fs.h:2639 [inline]
>  xfs_file_buffered_write+0x723/0x8a0 fs/xfs/xfs_file.c:1015
>  do_iter_readv_writev+0x623/0x8c0 fs/read_write.c:-1
>  vfs_writev+0x31a/0x960 fs/read_write.c:1057
>  do_pwritev fs/read_write.c:1153 [inline]
>  __do_sys_pwritev2 fs/read_write.c:1211 [inline]
>  __se_sys_pwritev2+0x179/0x290 fs/read_write.c:1202
>  do_syscall_x64 arch/x86/entry/syscall_64.c:63 [inline]
>  do_syscall_64+0xfa/0xfa0 arch/x86/entry/syscall_64.c:94
>  entry_SYSCALL_64_after_hwframe+0x77/0x7f
>
> The buggy address belongs to the object at ffff88816ced7c80
>  which belongs to the cache kmalloc-96 of size 96
> The buggy address is located 0 bytes to the right of
>  allocated 80-byte region [ffff88816ced7c80, ffff88816ced7cd0)
>
> The buggy address belongs to the physical page:
> page: refcount:0 mapcount:0 mapping:0000000000000000 index:0x0 pfn:0x16ce=
d7
> flags: 0x57ff00000000000(node=3D1|zone=3D2|lastcpupid=3D0x7ff)
> page_type: f5(slab)
> raw: 057ff00000000000 ffff888100041280 dead000000000100 dead000000000122
> raw: 0000000000000000 0000000080200020 00000000f5000000 0000000000000000
> page dumped because: kasan: bad access detected
> page_owner tracks the page as allocated
> page last allocated via order 0, migratetype Unmovable, gfp_mask 0x252800=
(GFP_NOWAIT|__GFP_NORETRY|__GFP_COMP|__GFP_THISNODE), pid 1, tgid 1 (swappe=
r/0), ts 12041529441, free_ts 0
>  set_page_owner include/linux/page_owner.h:32 [inline]
>  post_alloc_hook+0x240/0x2a0 mm/page_alloc.c:1851
>  prep_new_page mm/page_alloc.c:1859 [inline]
>  get_page_from_freelist+0x2365/0x2440 mm/page_alloc.c:3920
>  __alloc_frozen_pages_noprof+0x181/0x370 mm/page_alloc.c:5209
>  alloc_slab_page mm/slub.c:3086 [inline]
>  allocate_slab+0x71/0x350 mm/slub.c:3257
>  new_slab mm/slub.c:3311 [inline]
>  ___slab_alloc+0xf56/0x1990 mm/slub.c:4671
>  __slab_alloc+0x65/0x100 mm/slub.c:4794
>  __slab_alloc_node mm/slub.c:4870 [inline]
>  slab_alloc_node mm/slub.c:5266 [inline]
>  __kmalloc_cache_node_noprof+0x4b7/0x6f0 mm/slub.c:5799
>  kmalloc_node_noprof include/linux/slab.h:983 [inline]
>  alloc_node_nr_active kernel/workqueue.c:4908 [inline]
>  __alloc_workqueue+0x6a9/0x1b80 kernel/workqueue.c:5762
>  alloc_workqueue_noprof+0xd4/0x210 kernel/workqueue.c:5822
>  nbd_dev_add+0x4f1/0xae0 drivers/block/nbd.c:1961
>  nbd_init+0x168/0x1f0 drivers/block/nbd.c:2691
>  do_one_initcall+0x25a/0x860 init/main.c:1378
>  do_initcall_level+0x104/0x190 init/main.c:1440
>  do_initcalls+0x59/0xa0 init/main.c:1456
>  kernel_init_freeable+0x334/0x4b0 init/main.c:1688
>  kernel_init+0x1d/0x1d0 init/main.c:1578
> page_owner free stack trace missing
>
> Memory state around the buggy address:
>  ffff88816ced7b80: 00 00 00 00 00 00 00 00 00 00 fc fc fc fc fc fc
>  ffff88816ced7c00: 00 00 00 00 00 00 00 00 00 00 fc fc fc fc fc fc
> >ffff88816ced7c80: 00 00 00 00 00 00 00 00 00 00 fc fc fc fc fc fc
>                                                  ^
>  ffff88816ced7d00: fa fb fb fb fb fb fb fb fb fb fb fb fc fc fc fc
>  ffff88816ced7d80: 00 00 00 00 00 00 00 00 00 00 fc fc fc fc fc fc
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
> [axboe@kernel.dk brauner@kernel.org dchinner@redhat.com djwong@kernel.org=
 hch@lst.de jack@suse.cz john.g.garry@oracle.com linux-block@vger.kernel.or=
g linux-ext4@vger.kernel.org linux-fsdevel@vger.kernel.org linux-kernel@vge=
r.kernel.org linux-mm@kvack.org linux-trace-kernel@vger.kernel.org linux-xf=
s@vger.kernel.org martin.petersen@oracle.com nilay@linux.ibm.com ojaswin@li=
nux.ibm.com ritesh.list@gmail.com rostedt@goodmis.org tytso@mit.edu willy@i=
nfradead.org]
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
-upstream-moderation/6914a2f4.a70a0220.3124cb.0004.GAE%40google.com.
