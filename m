Received: from mail-qv1-f42.google.com (mail-qv1-f42.google.com [209.85.219.42])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 90E20372696
	for <syzbot@lists.linux.dev>; Tue, 14 Jul 2026 06:08:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.219.42
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784009306; cv=pass; b=dtFCXZevI8RLrGCwAtmE262r6Pcxcg0D3x+EN56YOQ/xhwvhtYBGb1vhO+o3+xzDEyLtplgXF2xIlZAnS/UkwagIrk8i8ZPLJNWDu+yaoKgPtnChXw7hAsc7Y99yLkihuHsoqAJ2momu+Tu6dL34r0XKaNy3lxfJTDAmoKzJU0Y=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784009306; c=relaxed/simple;
	bh=DGGmtLpeZGrMPqcdO/VkdoUuOoaQzNOG5Z11GdSZdAY=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=Vk2DARVBM2YHmSemT6HbJQA6MEKEsnd4rMGH09sozKJad9pwok/osuwEI/dYzqad78CzBA8i7PbQcajFCQ7yE9+vjU5Z2Z6g+fSswokSmJniSPXZiQgP7QH3skTYSvIZ1Tt6RSxjCBLsKrH2KdUpIECUrJiGgvWHVgIl+Bns8QI=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=hB/GI7nu; arc=pass smtp.client-ip=209.85.219.42
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="hB/GI7nu"
Received: by mail-qv1-f42.google.com with SMTP id 6a1803df08f44-8f0d6853360so29083806d6.0
        for <syzbot@lists.linux.dev>; Mon, 13 Jul 2026 23:08:24 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1784009303; cv=none;
        d=google.com; s=arc-20260327;
        b=eFsQ8tyHMltv4Sn/1XXNilaFgFP9pp09wuVzV/K3ZFnQxHsWa4gcfxPx/TNrMSrklc
         LGtVGJ/ueG0NkzGvf+1BJjOQqkMgTVSlnavxNkMddhtx3+RU9MvDdmqW4uXlfKMAMFkB
         aslhJVeElwqBq5yyTufBQel9M9/DIAua2RiksJvpaT0MID/IAB2Aqx2KBPwM7VHX6W6D
         Ex06EDhB0LHwB5UrrZE7fcSgw9a0eYbI9WXQPLnjII2s7bZA/wtiOxn6iFqtiYBO6s9g
         GAEVgo1ZpeFkWuKoJAgHNvdHNdr2vEWkSMjtGCxH33ETY2n9bJl/aXyl9aLB7nW3C8dx
         xXDg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=CpImB8G98C09XnIoF/gLSUUNbT2sLFKUtTnuJCtu2Ys=;
        fh=hRHeC6rZTMJuQH1TPim6/FFGXh0ffEbjRHrJHgLCdtU=;
        b=nJd4xzxuxws95p/kVoNs8Uapx6SN/seFheZHMtW8Zi7167t53qSsZs63Gm42TiK7Ut
         +Djpz4/LGzuyNfJR5xgpkv9qy7EZEV8SgqvlwlHqAgOje4++HCG8JzoIr2mk978Fmtvw
         wKTpKwpT4nsNeb7Fpg9XMbTGNqRQ+9mg3gOu+fF2/T8Uj+EaQD2GTUqFLGD9swe3ka71
         WsnVgWf905ex85BHHmCr0z0wmc9K6nfEPyEO/WShKWMRYNMXnJanAK4G0Z27UsBnAFOc
         0nv7yjcgqLPp0oA2WIH4xSDAU9M/fxDnmOaDTGSOrpBDkcAySNVMV4qjZdmeVugA4+eV
         G+EA==;
        darn=lists.linux.dev
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1784009303; x=1784614103; darn=lists.linux.dev;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=CpImB8G98C09XnIoF/gLSUUNbT2sLFKUtTnuJCtu2Ys=;
        b=hB/GI7nuRodhf8GxJGaZDZxyGNDEYa68MMr1FkkMzysOxHemPMpCShueZXxD5VcE/i
         uCFpMIdl2zreRx9wL7bGIeVd+rB3/3XYjqGdkHS6ARPvGuZfeKXFZO6fJnF8h935A95n
         OoGzObUTJsN8MuykqyeQFfUuPWLTTE4IhmxuuKZqXzosjrCAu0f2r38+oCI9mLGMJt/h
         cPTqwEvboGCEkk9X9aqCcFtG0H7oElbP0YaVskCvPROZ2iFBxyxtS9hyXJt+M7m7uIDe
         MATInGOYzyV9ETowctCKhl/jpVM6sYP9svXoNystdRKYSx6i9Mug/Vrh8JciQaNItmYZ
         ikYQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1784009303; x=1784614103;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=CpImB8G98C09XnIoF/gLSUUNbT2sLFKUtTnuJCtu2Ys=;
        b=sUmbDicYppzQClFGSUGGmPIf95eVy3+Hi/VS14UK7WOPIZyB4PbmHjdoMwsHRMZN8j
         /rf2LoBZe2Hguk2FrwUb/KGF5Ne4VhPERmaE5efZxuSWHaOsSOKcOVIrH4OPJeI0fMct
         zxsCRHAVuiEMfijQxy7zURBsB7WmqRGXwhwMfBC5fXqo/k8p2ezgIDehhx6mDGsPB4cE
         q9HvhycnnbHRIgNK4K4jpDMWPBUBJRguqdqWH4PO+i2iTU+qkjj4CFZEiWej2KEZxXv2
         pUEQmNa45IQ2j1g+7DYrkFBosOhm4LwgRX4WWJAff6TvlIsRYIDcvQJgXIbOobFAWBjS
         M4EQ==
X-Forwarded-Encrypted: i=1; AHgh+RrH3MFKy86P7f0W0ZCDCCGGjFpdmSQOzndUwHfyF+n3Nmn+12BdBn7MeJUcHj9cPEBy2zFcG2s=@lists.linux.dev
X-Gm-Message-State: AOJu0Yy1Lp/CQ4eTvkqHaPLoE7eZDYNH6JjEh/C3i2ym9dmn5xJHBgex
	vLrFbZJh3g7f9HUKF6irkj+qRb+y3ehDqqC1onI1e2GvBFfMduCbeT6FIF6wCXEAZgfnGjXZz4u
	P/dBYZNcz4tyaYugdapTYByrCybcLIJu3bl27Do69
X-Gm-Gg: AfdE7clQx874MWe1/JQ9zpsMMUtzMmvFg3wwS1xdpp5NQUZmFCUc9UOTgANWpgynN14
	lgF+w+DxA/aS60UmJFd/uHb7SJBXU8CWGOZNgA7owaZFq4ueEDeExoYtR6Ry1VLBQFcqZ5G/6W2
	hpfLopywfcIOfWw5ABefEilUzxk4c7XpgqCXtiOGaS59ytCldtFU6U/Z3wZgKGwn1LCzeKRh2ph
	9Nh2HoCuQ6yKWkeBJwZqTaXxM+idRiowu+74q6y7IUo5F59mzgtLyy90H0OkIqz0EHO6+HWXmW8
	CXzZ93V7ZBvGL7ORfQbT1W7usZMcMkh9mJQvG3qNmja+pStr3FTwek4PpA9/uFg=
X-Received: by 2002:a05:6214:3f82:b0:8fd:6e32:1aa4 with SMTP id
 6a1803df08f44-9074c894fb7mr10852806d6.62.1784009302607; Mon, 13 Jul 2026
 23:08:22 -0700 (PDT)
Precedence: bulk
X-Mailing-List: syzbot@lists.linux.dev
List-Id: <syzbot.lists.linux.dev>
List-Subscribe: <mailto:syzbot+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:syzbot+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <6a557fff.c90005c7.37d349.000e.GAE@google.com>
In-Reply-To: <6a557fff.c90005c7.37d349.000e.GAE@google.com>
From: Pimyn Girgis <pimyn@google.com>
Date: Tue, 14 Jul 2026 08:08:11 +0200
X-Gm-Features: AUfX_myo7cKO-Xk_HcPoV2nkuiuo61C5atSGe9ogl2eNgpguaemHQ95XKtL-aS8
Message-ID: <CAJWNTGyZ1_+9xZgtqDDAq+=MO=zzAq-vyd3TxW0C_6GQEkcREg@mail.gmail.com>
Subject: Re: [moderation/CI] Re: block: fix aligning of bounced dio read bios
To: syzbot ci <syzbot+cied2c9b8b2e051ad0@syzkaller.appspotmail.com>
Cc: syzkaller-upstream-moderation@googlegroups.com, syzbot@lists.linux.dev
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

#syz upstream


On Tue, Jul 14, 2026 at 2:17=E2=80=AFAM syzbot ci
<syzbot+cied2c9b8b2e051ad0@syzkaller.appspotmail.com> wrote:
>
> syzbot ci has tested the following series
>
> [v1] block: fix aligning of bounced dio read bios
> https://lore.kernel.org/all/20260713152912.2333321-1-hch@lst.de
> * [PATCH] block: fix aligning of bounced dio read bios
>
> and found the following issues:
> * KASAN: slab-out-of-bounds Read in bio_iov_iter_get_pages
> * KASAN: stack-out-of-bounds Read in bio_iov_iter_get_pages
> * KASAN: use-after-free Read in bio_iov_iter_get_pages
>
> Full report is available here:
> https://ci.syzbot.org/series/c5526ca4-0280-46b9-acac-a3952d0df609
>
> ***
>
> KASAN: slab-out-of-bounds Read in bio_iov_iter_get_pages
>
> tree:      torvalds
> URL:       https://kernel.googlesource.com/pub/scm/linux/kernel/git/torva=
lds/linux
> base:      a13c140cc289c0b7b3770bce5b3ad42ab35074aa
> arch:      amd64
> compiler:  Debian clang version 22.1.6 (++20260514074242+fc4aad7b5db3-1~e=
xp1~20260514074407.73), Debian LLD 22.1.6
> config:    https://ci.syzbot.org/builds/826b3d15-d916-4201-92f4-a3110bf41=
809/config
> syz repro: https://ci.syzbot.org/findings/329bf95d-8223-48af-b49b-aad0ba3=
1512c/syz_repro
>
> =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
> BUG: KASAN: slab-out-of-bounds in bio_iov_iter_align_down block/bio.c:120=
4 [inline]
> BUG: KASAN: slab-out-of-bounds in bio_iov_iter_get_pages+0x818/0xb00 bloc=
k/bio.c:1278
> Read of size 4 at addr ffff8881774e32f8 by task syz.2.19/5857
>
> CPU: 1 UID: 0 PID: 5857 Comm: syz.2.19 Not tainted syzkaller #0 PREEMPT(f=
ull)
> Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS 1.16.2-debian-1.=
16.2-1 04/01/2014
> Call Trace:
>  <TASK>
>  dump_stack_lvl+0xe8/0x150 lib/dump_stack.c:120
>  print_address_description+0x55/0x1e0 mm/kasan/report.c:378
>  print_report+0x58/0x70 mm/kasan/report.c:482
>  kasan_report+0x117/0x150 mm/kasan/report.c:595
>  bio_iov_iter_align_down block/bio.c:1204 [inline]
>  bio_iov_iter_get_pages+0x818/0xb00 block/bio.c:1278
>  blkdev_iov_iter_get_pages block/fops.c:49 [inline]
>  __blkdev_direct_IO+0x656/0xf30 block/fops.c:219
>  blkdev_direct_IO+0x122e/0x17a0 block/fops.c:435
>  blkdev_read_iter+0x223/0x420 block/fops.c:814
>  do_iter_readv_writev+0x612/0x8c0 fs/read_write.c:-1
>  vfs_readv+0x28d/0x850 fs/read_write.c:1019
>  do_preadv fs/read_write.c:1133 [inline]
>  __do_sys_preadv2 fs/read_write.c:1192 [inline]
>  __se_sys_preadv2+0x177/0x2a0 fs/read_write.c:1183
>  do_syscall_x64 arch/x86/entry/syscall_64.c:63 [inline]
>  do_syscall_64+0x174/0x580 arch/x86/entry/syscall_64.c:94
>  entry_SYSCALL_64_after_hwframe+0x77/0x7f
> RIP: 0033:0x7ff72e39ce59
> Code: ff c3 66 2e 0f 1f 84 00 00 00 00 00 0f 1f 44 00 00 48 89 f8 48 89 f=
7 48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 ff=
 ff 73 01 c3 48 c7 c1 e8 ff ff ff f7 d8 64 89 01 48
> RSP: 002b:00007ff72f2bf028 EFLAGS: 00000246 ORIG_RAX: 0000000000000147
> RAX: ffffffffffffffda RBX: 00007ff72e615fa0 RCX: 00007ff72e39ce59
> RDX: 0000000000000002 RSI: 0000200000000400 RDI: 0000000000000003
> RBP: 00007ff72e432e6f R08: 0000000000000000 R09: 0000000000000001
> R10: 0000000000000000 R11: 0000000000000246 R12: 0000000000000000
> R13: 00007ff72e616038 R14: 00007ff72e615fa0 R15: 00007fff57584868
>  </TASK>
>
> Allocated by task 1:
>  kasan_save_stack mm/kasan/common.c:57 [inline]
>  kasan_save_track+0x3e/0x80 mm/kasan/common.c:78
>  unpoison_slab_object mm/kasan/common.c:340 [inline]
>  __kasan_slab_alloc+0x6c/0x80 mm/kasan/common.c:366
>  kasan_slab_alloc include/linux/kasan.h:253 [inline]
>  slab_post_alloc_hook mm/slub.c:4612 [inline]
>  slab_alloc_node mm/slub.c:4945 [inline]
>  kmem_cache_alloc_noprof+0x2a0/0x5f0 mm/slub.c:4959
>  mempool_init_node+0x1f4/0x4f0 mm/mempool.c:259
>  mempool_init_noprof+0x3a/0x50 mm/mempool.c:289
>  biovec_init_pool block/bio.c:1909 [inline]
>  bioset_init+0x5c1/0x7e0 block/bio.c:1978
>  btrfs_init_dio+0x1f/0x30 fs/btrfs/direct-io.c:1145
>  init_btrfs_fs+0x6d/0x1f0 fs/btrfs/super.c:2727
>  do_one_initcall+0x250/0x870 init/main.c:1347
>  do_initcall_level+0x10a/0x1a0 init/main.c:1409
>  do_initcalls+0x59/0xa0 init/main.c:1425
>  kernel_init_freeable+0x29d/0x3e0 init/main.c:1658
>  kernel_init+0x1d/0x1d0 init/main.c:1548
>  ret_from_fork+0x514/0xb70 arch/x86/kernel/process.c:158
>  ret_from_fork_asm+0x1a/0x30 arch/x86/entry/entry_64.S:245
>
> Freed by task 1:
>  kasan_save_stack mm/kasan/common.c:57 [inline]
>  kasan_save_track+0x3e/0x80 mm/kasan/common.c:78
>  kasan_save_free_info+0x40/0x50 mm/kasan/generic.c:584
>  poison_slab_object mm/kasan/common.c:253 [inline]
>  __kasan_mempool_poison_object+0x16e/0x1d0 mm/kasan/common.c:539
>  kasan_mempool_poison_object include/linux/kasan.h:363 [inline]
>  kasan_poison_element mm/mempool.c:156 [inline]
>  add_element mm/mempool.c:179 [inline]
>  mempool_init_node+0x2a6/0x4f0 mm/mempool.c:264
>  mempool_init_noprof+0x3a/0x50 mm/mempool.c:289
>  biovec_init_pool block/bio.c:1909 [inline]
>  bioset_init+0x5c1/0x7e0 block/bio.c:1978
>  btrfs_init_dio+0x1f/0x30 fs/btrfs/direct-io.c:1145
>  init_btrfs_fs+0x6d/0x1f0 fs/btrfs/super.c:2727
>  do_one_initcall+0x250/0x870 init/main.c:1347
>  do_initcall_level+0x10a/0x1a0 init/main.c:1409
>  do_initcalls+0x59/0xa0 init/main.c:1425
>  kernel_init_freeable+0x29d/0x3e0 init/main.c:1658
>  kernel_init+0x1d/0x1d0 init/main.c:1548
>  ret_from_fork+0x514/0xb70 arch/x86/kernel/process.c:158
>  ret_from_fork_asm+0x1a/0x30 arch/x86/entry/entry_64.S:245
>
> The buggy address belongs to the object at ffff8881774e2200
>  which belongs to the cache biovec-max of size 4096
> The buggy address is located 248 bytes to the right of
>  allocated 4096-byte region [ffff8881774e2200, ffff8881774e3200)
>
> The buggy address belongs to the physical page:
> page: refcount:0 mapcount:0 mapping:0000000000000000 index:0x0 pfn:0x1774=
e0
> head: order:3 mapcount:0 entire_mapcount:0 nr_pages_mapped:0 pincount:0
> flags: 0x57ff00000000040(head|node=3D1|zone=3D2|lastcpupid=3D0x7ff)
> page_type: f5(slab)
> raw: 057ff00000000040 ffff888160414b40 dead000000000100 dead000000000122
> raw: 0000000000000000 0000000800070007 00000000f5000000 0000000000000000
> head: 057ff00000000040 ffff888160414b40 dead000000000100 dead000000000122
> head: 0000000000000000 0000000800070007 00000000f5000000 0000000000000000
> head: 057ff00000000003 fffffffffffffe01 00000000ffffffff 00000000ffffffff
> head: ffffffffffffffff 0000000000000000 00000000ffffffff 0000000000000008
> page dumped because: kasan: bad access detected
> page_owner tracks the page as allocated
> page last allocated via order 3, migratetype Unmovable, gfp_mask 0xd20c0(=
__GFP_IO|__GFP_FS|__GFP_NOWARN|__GFP_NORETRY|__GFP_COMP|__GFP_NOMEMALLOC), =
pid 1, tgid 1 (swapper/0), ts 22595717829, free_ts 19809479246
>  set_page_owner include/linux/page_owner.h:32 [inline]
>  post_alloc_hook+0x1f9/0x250 mm/page_alloc.c:1859
>  prep_new_page mm/page_alloc.c:1867 [inline]
>  get_page_from_freelist+0x21fa/0x2270 mm/page_alloc.c:3946
>  __alloc_frozen_pages_noprof+0x18d/0x380 mm/page_alloc.c:5304
>  alloc_slab_page mm/slub.c:3294 [inline]
>  allocate_slab+0x79/0x5e0 mm/slub.c:3408
>  new_slab mm/slub.c:3454 [inline]
>  refill_objects+0x2d5/0x350 mm/slub.c:7338
>  refill_sheaf mm/slub.c:2832 [inline]
>  __pcs_replace_empty_main+0x2bf/0x6b0 mm/slub.c:4703
>  alloc_from_pcs mm/slub.c:4801 [inline]
>  slab_alloc_node mm/slub.c:4933 [inline]
>  kmem_cache_alloc_noprof+0x382/0x5f0 mm/slub.c:4959
>  mempool_init_node+0x1f4/0x4f0 mm/mempool.c:259
>  mempool_init_noprof+0x3a/0x50 mm/mempool.c:289
>  biovec_init_pool block/bio.c:1909 [inline]
>  bioset_init+0x5c1/0x7e0 block/bio.c:1978
>  btrfs_init_dio+0x1f/0x30 fs/btrfs/direct-io.c:1145
>  init_btrfs_fs+0x6d/0x1f0 fs/btrfs/super.c:2727
>  do_one_initcall+0x250/0x870 init/main.c:1347
>  do_initcall_level+0x10a/0x1a0 init/main.c:1409
>  do_initcalls+0x59/0xa0 init/main.c:1425
>  kernel_init_freeable+0x29d/0x3e0 init/main.c:1658
> page last free pid 11 tgid 11 stack trace:
>  reset_page_owner include/linux/page_owner.h:25 [inline]
>  __free_pages_prepare mm/page_alloc.c:1406 [inline]
>  free_pages_prepare+0x960/0xa60 mm/page_alloc.c:1451
>  __free_contig_range_common+0x174/0x340 mm/page_alloc.c:6897
>  __free_contig_range mm/page_alloc.c:6942 [inline]
>  free_pages_bulk+0x48/0x120 mm/page_alloc.c:5257
>  vm_area_free_pages mm/vmalloc.c:3439 [inline]
>  vfree+0x224/0x4a0 mm/vmalloc.c:3488
>  delayed_vfree_work+0x55/0x80 mm/vmalloc.c:3392
>  process_one_work kernel/workqueue.c:3322 [inline]
>  process_scheduled_works+0xa8e/0x14e0 kernel/workqueue.c:3405
>  worker_thread+0xa47/0xfb0 kernel/workqueue.c:3486
>  kthread+0x388/0x470 kernel/kthread.c:436
>  ret_from_fork+0x514/0xb70 arch/x86/kernel/process.c:158
>  ret_from_fork_asm+0x1a/0x30 arch/x86/entry/entry_64.S:245
>
> Memory state around the buggy address:
>  ffff8881774e3180: fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb
>  ffff8881774e3200: fc fc fc fc fc fc fc fc fc fc fc fc fc fc fc fc
> >ffff8881774e3280: fc fc fc fc fc fc fc fc fc fc fc fc fc fc fc fc
>                                                                 ^
>  ffff8881774e3300: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
>  ffff8881774e3380: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
> =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
>
>
> ***
>
> KASAN: stack-out-of-bounds Read in bio_iov_iter_get_pages
>
> tree:      torvalds
> URL:       https://kernel.googlesource.com/pub/scm/linux/kernel/git/torva=
lds/linux
> base:      a13c140cc289c0b7b3770bce5b3ad42ab35074aa
> arch:      amd64
> compiler:  Debian clang version 22.1.6 (++20260514074242+fc4aad7b5db3-1~e=
xp1~20260514074407.73), Debian LLD 22.1.6
> config:    https://ci.syzbot.org/builds/826b3d15-d916-4201-92f4-a3110bf41=
809/config
> syz repro: https://ci.syzbot.org/findings/7548167b-8086-40cf-b7c4-0729bb6=
4a887/syz_repro
>
> =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
> BUG: KASAN: stack-out-of-bounds in bio_iov_iter_align_down block/bio.c:12=
04 [inline]
> BUG: KASAN: stack-out-of-bounds in bio_iov_iter_get_pages+0x818/0xb00 blo=
ck/bio.c:1278
> Read of size 4 at addr ffffc90003d0f8d8 by task syz.0.17/5816
>
> CPU: 1 UID: 0 PID: 5816 Comm: syz.0.17 Not tainted syzkaller #0 PREEMPT(f=
ull)
> Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS 1.16.2-debian-1.=
16.2-1 04/01/2014
> Call Trace:
>  <TASK>
>  dump_stack_lvl+0xe8/0x150 lib/dump_stack.c:120
>  print_address_description+0x55/0x1e0 mm/kasan/report.c:378
>  print_report+0x58/0x70 mm/kasan/report.c:482
>  kasan_report+0x117/0x150 mm/kasan/report.c:595
>  bio_iov_iter_align_down block/bio.c:1204 [inline]
>  bio_iov_iter_get_pages+0x818/0xb00 block/bio.c:1278
>  blkdev_iov_iter_get_pages block/fops.c:49 [inline]
>  __blkdev_direct_IO_simple block/fops.c:87 [inline]
>  blkdev_direct_IO+0x103c/0x17a0 block/fops.c:429
>  blkdev_direct_write+0x7c/0x140 block/fops.c:697
>  blkdev_write_iter+0x52d/0x700 block/fops.c:765
>  do_iter_readv_writev+0x612/0x8c0 fs/read_write.c:-1
>  vfs_writev+0x343/0x990 fs/read_write.c:1058
>  do_pwritev fs/read_write.c:1154 [inline]
>  __do_sys_pwritev2 fs/read_write.c:1212 [inline]
>  __se_sys_pwritev2+0x177/0x2a0 fs/read_write.c:1203
>  do_syscall_x64 arch/x86/entry/syscall_64.c:63 [inline]
>  do_syscall_64+0x174/0x580 arch/x86/entry/syscall_64.c:94
>  entry_SYSCALL_64_after_hwframe+0x77/0x7f
> RIP: 0033:0x7f69e2f9ce59
> Code: ff c3 66 2e 0f 1f 84 00 00 00 00 00 0f 1f 44 00 00 48 89 f8 48 89 f=
7 48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 ff=
 ff 73 01 c3 48 c7 c1 e8 ff ff ff f7 d8 64 89 01 48
> RSP: 002b:00007f69e3dd7028 EFLAGS: 00000246 ORIG_RAX: 0000000000000148
> RAX: ffffffffffffffda RBX: 00007f69e3215fa0 RCX: 00007f69e2f9ce59
> RDX: 0000000000000001 RSI: 00002000000004c0 RDI: 0000000000000003
> RBP: 00007f69e3032e6f R08: 0000000000000006 R09: 000000000000000a
> R10: 0000000000000400 R11: 0000000000000246 R12: 0000000000000000
> R13: 00007f69e3216038 R14: 00007f69e3215fa0 R15: 00007ffd3e932d38
>  </TASK>
>
> The buggy address belongs to stack of task syz.0.17/5816
>  and is located at offset 24 in frame:
>  blkdev_direct_IO+0x0/0x17a0 block/fops.c:467
>
> This frame has 2 objects:
>  [32, 96) 'inline_vecs.i'
>  [128, 264) 'bio.i'
>
> The buggy address belongs to a vmalloc virtual mapping
> The buggy address belongs to the physical page:
> page: refcount:1 mapcount:0 mapping:0000000000000000 index:0x0 pfn:0x1bc8=
af
> memcg:ffff888171c78902
> flags: 0x57ff00000000000(node=3D1|zone=3D2|lastcpupid=3D0x7ff)
> raw: 057ff00000000000 0000000000000000 ffffea0006f22b88 0000000000000000
> raw: 0000000000000000 0000000000000000 00000001ffffffff ffff888171c78902
> page dumped because: kasan: bad access detected
> page_owner tracks the page as allocated
> page last allocated via order 0, migratetype Unmovable, gfp_mask 0x29c2(G=
FP_NOWAIT|__GFP_HIGHMEM|__GFP_IO|__GFP_FS|__GFP_ZERO), pid 5815, tgid 5815 =
(syz.0.17), ts 75932045692, free_ts 28228426703
>  set_page_owner include/linux/page_owner.h:32 [inline]
>  post_alloc_hook+0x1f9/0x250 mm/page_alloc.c:1859
>  prep_new_page mm/page_alloc.c:1867 [inline]
>  get_page_from_freelist+0x21fa/0x2270 mm/page_alloc.c:3946
>  __alloc_frozen_pages_noprof+0x18d/0x380 mm/page_alloc.c:5304
>  alloc_pages_mpol+0x212/0x380 mm/mempolicy.c:2490
>  alloc_frozen_pages_noprof mm/mempolicy.c:2561 [inline]
>  alloc_pages_noprof+0xac/0x2a0 mm/mempolicy.c:2581
>  vm_area_alloc_pages mm/vmalloc.c:3667 [inline]
>  __vmalloc_area_node mm/vmalloc.c:3892 [inline]
>  __vmalloc_node_range_noprof+0x795/0x1730 mm/vmalloc.c:4082
>  __vmalloc_node_noprof+0xc2/0x100 mm/vmalloc.c:4143
>  alloc_thread_stack_node kernel/fork.c:359 [inline]
>  dup_task_struct+0x2a0/0x8e0 kernel/fork.c:929
>  copy_process+0x820/0x4390 kernel/fork.c:2115
>  kernel_clone+0x2d7/0x940 kernel/fork.c:2748
>  __do_sys_clone3 kernel/fork.c:3050 [inline]
>  __se_sys_clone3+0x33c/0x360 kernel/fork.c:3029
>  do_syscall_x64 arch/x86/entry/syscall_64.c:63 [inline]
>  do_syscall_64+0x174/0x580 arch/x86/entry/syscall_64.c:94
>  entry_SYSCALL_64_after_hwframe+0x77/0x7f
> page last free pid 5066 tgid 5066 stack trace:
>  reset_page_owner include/linux/page_owner.h:25 [inline]
>  __free_pages_prepare mm/page_alloc.c:1406 [inline]
>  __free_frozen_pages+0xc1e/0xd10 mm/page_alloc.c:2950
>  __slab_free+0x274/0x2c0 mm/slub.c:5767
>  qlink_free mm/kasan/quarantine.c:163 [inline]
>  qlist_free_all+0x99/0x100 mm/kasan/quarantine.c:179
>  kasan_quarantine_reduce+0x148/0x160 mm/kasan/quarantine.c:286
>  __kasan_slab_alloc+0x22/0x80 mm/kasan/common.c:350
>  kasan_slab_alloc include/linux/kasan.h:253 [inline]
>  slab_post_alloc_hook mm/slub.c:4612 [inline]
>  slab_alloc_node mm/slub.c:4945 [inline]
>  kmem_cache_alloc_noprof+0x2a0/0x5f0 mm/slub.c:4959
>  alloc_filename fs/namei.c:147 [inline]
>  do_getname+0x2e/0x250 fs/namei.c:187
>  getname_flags fs/namei.c:230 [inline]
>  getname include/linux/fs.h:2537 [inline]
>  class_filename_constructor include/linux/fs.h:2564 [inline]
>  __do_sys_symlink fs/namei.c:5710 [inline]
>  __se_sys_symlink+0x2b/0x2b0 fs/namei.c:5708
>  do_syscall_x64 arch/x86/entry/syscall_64.c:63 [inline]
>  do_syscall_64+0x174/0x580 arch/x86/entry/syscall_64.c:94
>  entry_SYSCALL_64_after_hwframe+0x77/0x7f
>
> Memory state around the buggy address:
>  ffffc90003d0f780: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
>  ffffc90003d0f800: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
> >ffffc90003d0f880: 00 00 00 00 00 00 00 00 f1 f1 f1 f1 00 00 00 00
>                                                     ^
>  ffffc90003d0f900: 00 00 00 00 f2 f2 f2 f2 00 00 00 00 00 00 00 00
>  ffffc90003d0f980: 00 00 00 00 00 00 00 00 00 f3 f3 f3 f3 f3 f3 f3
> =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
>
>
> ***
>
> KASAN: use-after-free Read in bio_iov_iter_get_pages
>
> tree:      torvalds
> URL:       https://kernel.googlesource.com/pub/scm/linux/kernel/git/torva=
lds/linux
> base:      a13c140cc289c0b7b3770bce5b3ad42ab35074aa
> arch:      amd64
> compiler:  Debian clang version 22.1.6 (++20260514074242+fc4aad7b5db3-1~e=
xp1~20260514074407.73), Debian LLD 22.1.6
> config:    https://ci.syzbot.org/builds/826b3d15-d916-4201-92f4-a3110bf41=
809/config
> syz repro: https://ci.syzbot.org/findings/9daf86a2-4bc7-464d-9b7d-713887f=
8d527/syz_repro
>
> =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
> BUG: KASAN: use-after-free in bio_iov_iter_align_down block/bio.c:1204 [i=
nline]
> BUG: KASAN: use-after-free in bio_iov_iter_get_pages+0x818/0xb00 block/bi=
o.c:1278
> Read of size 4 at addr ffff88816bf6fff8 by task syz.2.19/5822
>
> CPU: 1 UID: 0 PID: 5822 Comm: syz.2.19 Not tainted syzkaller #0 PREEMPT(f=
ull)
> Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS 1.16.2-debian-1.=
16.2-1 04/01/2014
> Call Trace:
>  <TASK>
>  dump_stack_lvl+0xe8/0x150 lib/dump_stack.c:120
>  print_address_description+0x55/0x1e0 mm/kasan/report.c:378
>  print_report+0x58/0x70 mm/kasan/report.c:482
>  kasan_report+0x117/0x150 mm/kasan/report.c:595
>  bio_iov_iter_align_down block/bio.c:1204 [inline]
>  bio_iov_iter_get_pages+0x818/0xb00 block/bio.c:1278
>  blkdev_iov_iter_get_pages block/fops.c:49 [inline]
>  __blkdev_direct_IO+0x656/0xf30 block/fops.c:219
>  blkdev_direct_IO+0x122e/0x17a0 block/fops.c:435
>  blkdev_read_iter+0x223/0x420 block/fops.c:814
>  do_iter_readv_writev+0x612/0x8c0 fs/read_write.c:-1
>  vfs_readv+0x28d/0x850 fs/read_write.c:1019
>  do_preadv fs/read_write.c:1133 [inline]
>  __do_sys_preadv2 fs/read_write.c:1192 [inline]
>  __se_sys_preadv2+0x177/0x2a0 fs/read_write.c:1183
>  do_syscall_x64 arch/x86/entry/syscall_64.c:63 [inline]
>  do_syscall_64+0x174/0x580 arch/x86/entry/syscall_64.c:94
>  entry_SYSCALL_64_after_hwframe+0x77/0x7f
> RIP: 0033:0x7fc69259ce59
> Code: ff c3 66 2e 0f 1f 84 00 00 00 00 00 0f 1f 44 00 00 48 89 f8 48 89 f=
7 48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 ff=
 ff 73 01 c3 48 c7 c1 e8 ff ff ff f7 d8 64 89 01 48
> RSP: 002b:00007fc691bfe028 EFLAGS: 00000246 ORIG_RAX: 0000000000000147
> RAX: ffffffffffffffda RBX: 00007fc692815fa0 RCX: 00007fc69259ce59
> RDX: 0000000000000006 RSI: 0000200000000e80 RDI: 0000000000000003
> RBP: 00007fc692632e6f R08: 0000000000000000 R09: 0000000000000000
> R10: 0000000000000000 R11: 0000000000000246 R12: 0000000000000000
> R13: 00007fc692816038 R14: 00007fc692815fa0 R15: 00007ffe0610dd38
>  </TASK>
>
> The buggy address belongs to the physical page:
> page: refcount:0 mapcount:0 mapping:0000000000000000 index:0x0 pfn:0x16bf=
6f
> flags: 0x57ff00000000000(node=3D1|zone=3D2|lastcpupid=3D0x7ff)
> raw: 057ff00000000000 0000000000000000 ffffea0005afdbc8 0000000000000000
> raw: 0000000000000000 0000000000000000 00000000ffffffff 0000000000000000
> page dumped because: kasan: bad access detected
> page_owner tracks the page as freed
> page last allocated via order 3, migratetype Unmovable, gfp_mask 0xd2040(=
__GFP_IO|__GFP_NOWARN|__GFP_NORETRY|__GFP_COMP|__GFP_NOMEMALLOC), pid 5461,=
 tgid 5461 (rm), ts 41922484692, free_ts 75795985916
>  set_page_owner include/linux/page_owner.h:32 [inline]
>  post_alloc_hook+0x1f9/0x250 mm/page_alloc.c:1859
>  prep_new_page mm/page_alloc.c:1867 [inline]
>  get_page_from_freelist+0x21fa/0x2270 mm/page_alloc.c:3946
>  __alloc_frozen_pages_noprof+0x18d/0x380 mm/page_alloc.c:5304
>  alloc_slab_page mm/slub.c:3294 [inline]
>  allocate_slab+0x79/0x5e0 mm/slub.c:3408
>  new_slab mm/slub.c:3454 [inline]
>  refill_objects+0x2d5/0x350 mm/slub.c:7338
>  refill_sheaf mm/slub.c:2832 [inline]
>  __pcs_replace_empty_main+0x2bf/0x6b0 mm/slub.c:4703
>  alloc_from_pcs mm/slub.c:4801 [inline]
>  slab_alloc_node mm/slub.c:4933 [inline]
>  __do_kmalloc_node mm/slub.c:5361 [inline]
>  __kmalloc_noprof+0x485/0x720 mm/slub.c:5387
>  _kmalloc_noprof include/linux/slab.h:973 [inline]
>  tomoyo_realpath_from_path+0xef/0x640 security/tomoyo/realpath.c:251
>  tomoyo_get_realpath security/tomoyo/file.c:151 [inline]
>  tomoyo_path_perm+0x283/0x560 security/tomoyo/file.c:827
>  security_inode_getattr+0x12b/0x310 security/security.c:1895
>  vfs_getattr fs/stat.c:259 [inline]
>  vfs_fstat fs/stat.c:281 [inline]
>  vfs_fstatat+0xb4/0x170 fs/stat.c:371
>  __do_sys_newfstatat fs/stat.c:538 [inline]
>  __se_sys_newfstatat fs/stat.c:532 [inline]
>  __x64_sys_newfstatat+0x151/0x200 fs/stat.c:532
>  do_syscall_x64 arch/x86/entry/syscall_64.c:63 [inline]
>  do_syscall_64+0x174/0x580 arch/x86/entry/syscall_64.c:94
>  entry_SYSCALL_64_after_hwframe+0x77/0x7f
> page last free pid 5753 tgid 5753 stack trace:
>  reset_page_owner include/linux/page_owner.h:25 [inline]
>  __free_pages_prepare mm/page_alloc.c:1406 [inline]
>  __free_frozen_pages+0xc1e/0xd10 mm/page_alloc.c:2950
>  __slab_free+0x274/0x2c0 mm/slub.c:5767
>  qlink_free mm/kasan/quarantine.c:163 [inline]
>  qlist_free_all+0x99/0x100 mm/kasan/quarantine.c:179
>  kasan_quarantine_reduce+0x148/0x160 mm/kasan/quarantine.c:286
>  __kasan_slab_alloc+0x22/0x80 mm/kasan/common.c:350
>  kasan_slab_alloc include/linux/kasan.h:253 [inline]
>  slab_post_alloc_hook mm/slub.c:4612 [inline]
>  slab_alloc_node mm/slub.c:4945 [inline]
>  __do_kmalloc_node mm/slub.c:5361 [inline]
>  __kvmalloc_node_noprof+0x4cd/0x860 mm/slub.c:6933
>  proc_sys_call_handler+0x3d0/0x830 fs/proc/proc_sysctl.c:583
>  new_sync_write fs/read_write.c:595 [inline]
>  vfs_write+0x612/0xba0 fs/read_write.c:687
>  ksys_write+0x150/0x270 fs/read_write.c:739
>  do_syscall_x64 arch/x86/entry/syscall_64.c:63 [inline]
>  do_syscall_64+0x174/0x580 arch/x86/entry/syscall_64.c:94
>  entry_SYSCALL_64_after_hwframe+0x77/0x7f
>
> Memory state around the buggy address:
>  ffff88816bf6fe80: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
>  ffff88816bf6ff00: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
> >ffff88816bf6ff80: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
>                                                                 ^
>  ffff88816bf70000: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
>  ffff88816bf70080: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
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
> [axboe@kernel.dk hch@lst.de kbusch@kernel.org linux-block@vger.kernel.org=
 z1281552865@gmail.com]
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
-upstream-moderation/6a557fff.c90005c7.37d349.000e.GAE%40google.com.



--=20
=E2=B2=A0=E2=B2=9F=E2=B2=93=E2=B2=99=E2=B2=8F=E2=B2=9B =E2=B2=84=E2=B2=89=
=E2=B2=B1=E2=B2=A3=E2=B2=85=E2=B2=93=E2=B2=9F=E2=B2=A5 - Pimyn Girgis
Software Engineer
Kernel Dynamic Analysis
pimyn@google.com
