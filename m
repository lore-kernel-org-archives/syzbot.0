Received: from mail-oo1-f41.google.com (mail-oo1-f41.google.com [209.85.161.41])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 64A9F3148DA
	for <syzbot@lists.linux.dev>; Wed,  3 Jun 2026 06:40:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.161.41
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780468804; cv=pass; b=YQNl6HCDW0n4sDi4pHKhE92ZwLykf/ZIbzJQYul9Gz9zf2A0sNsiqQ1cT3yQE/36Bq+HGS3rmslsn6xajubXnmfxqj2p8vvSK0Wrg98ffXYOgfIGnkm8sP0aJgNQS73atcS2saP89+YK9y5IY2kHwPjO1zRYTOPMB8rFsULJGg0=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780468804; c=relaxed/simple;
	bh=yPo0SWs7wyFcjEh0V5ysx4T3s6Wfsr9T4qUVBGvoUcY=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=YfXVmY0LUzNjmANmWA24dibM/tuze3Eo1zqxc7jUFgYtOyI8KbD+RMuApLYH6KfWywfuFyUR8WqywBGyT0VButGSjpKhG5PDgtUSJUDQROXGnRXAJYbgGw+lFk3UcoUvRaxrp986xL8Q9Z6HKAC71ssrrkWZtenjKXNxPnv8QL4=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=TEapgMVH; arc=pass smtp.client-ip=209.85.161.41
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="TEapgMVH"
Received: by mail-oo1-f41.google.com with SMTP id 006d021491bc7-69d8f70cb0cso7201750eaf.0
        for <syzbot@lists.linux.dev>; Tue, 02 Jun 2026 23:40:02 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1780468801; cv=none;
        d=google.com; s=arc-20240605;
        b=KrxIOQ0b7jposJzwFkAbTrdQDRUHVWQBxTmfWEq5yuTqhNL8VChASDtqciRsIWEq5+
         VGtOoQIo+Doa5PA2ekiV10tOw31pYApbocyvxkxhj00p+bfMmH8vaLPukCckLJ0sVUMi
         raeeDmrhqUbW4or2J4s1/J5Mje2MsjOk7yUp4NZw2Y1MN00sX1IsZ/VmL5TsYZ45FH+u
         AV1NpFl7p15xX6pTqdB9gACoObQ/U4BJPDDVd6O5oyqlAS9h5bCsRgOXhuQ1MO6R6QiP
         o+W80AH8VkWRSqwMTo8MNUpjQBuK+i6psYRE6RRyLm4iOK7MVklSNPY4D/9fZqC+tjgt
         jOxQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=h3QU49Ay14ZceLet0XTkfyt1/yIBPxSjfvF8ymrKzwA=;
        fh=Xinyj0MThZKJ4W+YtVPvRiXT5jOLyT/zrJNRtgVotmE=;
        b=PrW27VtT/58W633XNwQt0ZIrYAkfAIc2hgwHPTLe5zkf8lLcUS59pfy3HV34iGQuqk
         drjvDCqQK+mSLYNiADfxFdWDE/DXTg+0pxSk3QYXNyIcGMYKMdXp+9/Q3ggPp/jlehO3
         3SmK9d0FQOltlWauU4XpkMSr88xqK97ezoGx57kOqoLqMjRkmXTzZfFOzbPW5zk4b8eU
         ClUVY9Jz2TlfKF2h73nCZxpf9cXOvhHI/cK79iv20d3Y38fqnD6PTQZk2m0WO4OgwYsI
         O3Y7bh5ie5kawAlT8eNOlgwTq3xkY5J8asNqyYpbSeNzHoB99ySqITlOMDHXTrlsNMG5
         9QTw==;
        darn=lists.linux.dev
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1780468801; x=1781073601; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=h3QU49Ay14ZceLet0XTkfyt1/yIBPxSjfvF8ymrKzwA=;
        b=TEapgMVH1ZA9P8rUJJ+AV4tVzfYkT6YyKIyr2H15S0oVQ/frvYectaoicsFbS/0KvW
         hQlTfZToALySShZ8w9sl0+usjynk+NrRT31J0F6F803PgGk3G4YC2tHuRpFIgF/EuPPw
         i7BNyF93MxENAx+w4RsTg0D/m2gIsB5EfV28AF4mrb86oQWTeKIZ3uams/7rGSYNatWj
         1k087g+pp+HIYIcbidxAB1lTeVMR9fcqq03eVXRGetxA0sbiMU6JANPa1M3wLdtylaF0
         +/hNz0ilHTGxuKQzGNCQYBs6B1D3MXZZ/u37JpbZzOcdpWv/KraSodyABEIOPzuVQVIJ
         r+aA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1780468801; x=1781073601;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=h3QU49Ay14ZceLet0XTkfyt1/yIBPxSjfvF8ymrKzwA=;
        b=mNpFyYgzYlXWHzWfG1ZXuUbaQiueQQRErz/lvfu8MCIciVtVzKqq8Q6ci349l2zg6/
         Z9+HeWAbaxRYIo7Tw/hu4YHyXqKbVhfxuhmuE50MfJX2P++OVChjtJufOa6JTScCSQG5
         Mr7maoxzgZPk0D9Nkxmi0EJ4S6P9YsC8Bspl2VLP6m++oYxFfhsnp90NpbxI9YMeATD2
         Y1Q5Gjz1wYi6rbjxIv6yxpio1+DkQyKZWF/o2QK3Y9BFyC9vHwxi9FNgbNIdud7FhX5F
         v3TYBTJAfs4804X7xzyfBoGHsi4AZ2nrzRN7CElYzMEsut3Mhr2kIesU94ceICkIM0fE
         2OhA==
X-Forwarded-Encrypted: i=1; AFNElJ9WLIfs7xK3Gq5RyR215DbGfY8qygtAEdnsiucXS1+ZG/iAj3LyrQsSqHaKZyYwGIpV3NggqSY=@lists.linux.dev
X-Gm-Message-State: AOJu0YzxrMpjmgIJWCdAaCyaHdtdKJHLagHWLjtWF62pGr/okuCu/HAt
	N3xyrBxvJ7FQ3izTkUHGMteP5n1hCzGQK47UEVetfjwdI5x6FvCi4HM6GjhyS8S2DCA3NRsZeH4
	+oEf1t29eq24fNTxnOwdtL6VlAPEX+8+Kb9CiCaYY
X-Gm-Gg: Acq92OHr7WFhpsxotghT1nNPT+yf4opfoaoerVkr0TfjjIVVcVUxxx/e7LUWjfDJYUx
	FqevBCIo5ZQN2JqEXjCj0/0ZxtxnMyKHYmJnPJQvLij6WGxQ9pMNHPlgR81aZtBU+yz3NX8jtTe
	CKQYBkJTA3uTyzu22IF1KKLBVU5v63DaBIRuPF2a2WUEYr0ctj3cyOyy1uK9lPqkSM8TQJmoCPo
	JWX2PGZ61KWBL8m0GARs5PATI9PdpvQOd7N1hYGCMTsYcyDDgMjXHPIDHMRYERvWh3ge2Uq0uqs
	7HjummmbZz+PjIxRPPPOUCxIUgiCe0BKKhT5wGhO80xlX/5g+kElCvsUp/XoxtaUFhUDACEj8OX
	N4w==
X-Received: by 2002:a05:6820:c93:b0:69e:9f4:5eee with SMTP id
 006d021491bc7-69e47ee8e06mr1366378eaf.22.1780468800740; Tue, 02 Jun 2026
 23:40:00 -0700 (PDT)
Precedence: bulk
X-Mailing-List: syzbot@lists.linux.dev
List-Id: <syzbot.lists.linux.dev>
List-Subscribe: <mailto:syzbot+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:syzbot+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <6a1fc867.b4221f80.1326c5.0006.GAE@google.com>
In-Reply-To: <6a1fc867.b4221f80.1326c5.0006.GAE@google.com>
From: Aleksandr Nogikh <nogikh@google.com>
Date: Wed, 3 Jun 2026 08:39:49 +0200
X-Gm-Features: AVHnY4IcsnWdlGM2WVxgikP3e1sD1aBg-18LACgLhPgL5IOhdFGyvDmUaH43gZI
Message-ID: <CANp29Y7+eSfYxQ4vWUJE8F8nGwBJhm9JU3LSO73C7eRrZwdX7w@mail.gmail.com>
Subject: Re: [moderation/CI] Re: block/fops: fix refcount underflow in __blkdev_direct_IO()
To: syzbot ci <syzbot+ci530a1fd72aa50bc7@syzkaller.appspotmail.com>
Cc: syzkaller-upstream-moderation@googlegroups.com, syzbot@lists.linux.dev
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

#syz upstream

On Wed, Jun 3, 2026 at 8:23=E2=80=AFAM syzbot ci
<syzbot+ci530a1fd72aa50bc7@syzkaller.appspotmail.com> wrote:
>
> syzbot ci has tested the following series
>
> [v1] block/fops: fix refcount underflow in __blkdev_direct_IO()
> https://lore.kernel.org/all/20260603021035.3690601-1-vulab@iscas.ac.cn
> * [PATCH] block/fops: fix refcount underflow in __blkdev_direct_IO()
>
> and found the following issue:
> KASAN: invalid-free in mempool_free
>
> Full report is available here:
> https://ci.syzbot.org/series/3498c893-003a-4780-92e5-c3090ee3fe45
>
> ***
>
> KASAN: invalid-free in mempool_free
>
> tree:      torvalds
> URL:       https://kernel.googlesource.com/pub/scm/linux/kernel/git/torva=
lds/linux
> base:      ba3e43a9e601636f5edb54e259a74f96ca3b8fd8
> arch:      amd64
> compiler:  Debian clang version 21.1.8 (++20251221033036+2078da43e25a-1~e=
xp1~20251221153213.50), Debian LLD 21.1.8
> config:    https://ci.syzbot.org/builds/0616259e-7b19-4982-aeee-0a50317c4=
cc6/config
> syz repro: https://ci.syzbot.org/findings/d2d98b4c-c6a9-4ecb-b313-ebd5a6d=
1b0d8/syz_repro
>
> =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
> BUG: KASAN: double-free in mempool_free+0xec/0x130 mm/mempool.c:711
> Free of addr ffff888177994400 by task syz.0.17/5875
>
> CPU: 1 UID: 0 PID: 5875 Comm: syz.0.17 Not tainted syzkaller #0 PREEMPT(f=
ull)
> Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS 1.16.2-debian-1.=
16.2-1 04/01/2014
> Call Trace:
>  <TASK>
>  dump_stack_lvl+0xe8/0x150 lib/dump_stack.c:120
>  print_address_description+0x55/0x1e0 mm/kasan/report.c:378
>  print_report+0x58/0x70 mm/kasan/report.c:482
>  kasan_report_invalid_free+0xea/0x110 mm/kasan/report.c:557
>  check_slab_allocation mm/kasan/common.c:-1 [inline]
>  __kasan_slab_pre_free+0x104/0x120 mm/kasan/common.c:261
>  kasan_slab_pre_free include/linux/kasan.h:199 [inline]
>  slab_free_hook mm/slub.c:2634 [inline]
>  slab_free mm/slub.c:6251 [inline]
>  kmem_cache_free+0x130/0x650 mm/slub.c:6378
>  mempool_free+0xec/0x130 mm/mempool.c:711
>  bio_free+0x1e9/0x330 block/bio.c:205
>  __blkdev_direct_IO+0xd89/0xf40 block/fops.c:290
>  blkdev_direct_IO+0x121a/0x1790 block/fops.c:438
>  blkdev_read_iter+0x23d/0x440 block/fops.c:841
>  do_iter_readv_writev+0x619/0x8c0 fs/read_write.c:-1
>  vfs_readv+0x288/0x840 fs/read_write.c:1020
>  do_preadv fs/read_write.c:1134 [inline]
>  __do_sys_preadv2 fs/read_write.c:1193 [inline]
>  __se_sys_preadv2+0x184/0x2a0 fs/read_write.c:1184
>  do_syscall_x64 arch/x86/entry/syscall_64.c:63 [inline]
>  do_syscall_64+0x174/0x580 arch/x86/entry/syscall_64.c:94
>  entry_SYSCALL_64_after_hwframe+0x77/0x7f
> RIP: 0033:0x7f125c99ce59
> Code: ff c3 66 2e 0f 1f 84 00 00 00 00 00 0f 1f 44 00 00 48 89 f8 48 89 f=
7 48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 ff=
 ff 73 01 c3 48 c7 c1 e8 ff ff ff f7 d8 64 89 01 48
> RSP: 002b:00007f125d829028 EFLAGS: 00000246 ORIG_RAX: 0000000000000147
> RAX: ffffffffffffffda RBX: 00007f125cc15fa0 RCX: 00007f125c99ce59
> RDX: 0000000000000005 RSI: 0000200000000080 RDI: 0000000000000003
> RBP: 00007f125ca32d6f R08: 0000000000000000 R09: 000000000000001f
> R10: 0000000000002000 R11: 0000000000000246 R12: 0000000000000000
> R13: 00007f125cc16038 R14: 00007f125cc15fa0 R15: 00007fff02d2e3e8
>  </TASK>
>
> Allocated by task 5875:
>  kasan_save_stack mm/kasan/common.c:57 [inline]
>  kasan_save_track+0x3e/0x80 mm/kasan/common.c:78
>  unpoison_slab_object mm/kasan/common.c:340 [inline]
>  __kasan_slab_alloc+0x6c/0x80 mm/kasan/common.c:366
>  kasan_slab_alloc include/linux/kasan.h:253 [inline]
>  slab_post_alloc_hook mm/slub.c:4570 [inline]
>  slab_alloc_node mm/slub.c:4899 [inline]
>  kmem_cache_alloc_noprof+0x2bc/0x650 mm/slub.c:4906
>  bio_alloc_bioset+0x599/0xc90 block/bio.c:571
>  __blkdev_direct_IO+0x294/0xf40 block/fops.c:186
>  blkdev_direct_IO+0x121a/0x1790 block/fops.c:438
>  blkdev_read_iter+0x23d/0x440 block/fops.c:841
>  do_iter_readv_writev+0x619/0x8c0 fs/read_write.c:-1
>  vfs_readv+0x288/0x840 fs/read_write.c:1020
>  do_preadv fs/read_write.c:1134 [inline]
>  __do_sys_preadv2 fs/read_write.c:1193 [inline]
>  __se_sys_preadv2+0x184/0x2a0 fs/read_write.c:1184
>  do_syscall_x64 arch/x86/entry/syscall_64.c:63 [inline]
>  do_syscall_64+0x174/0x580 arch/x86/entry/syscall_64.c:94
>  entry_SYSCALL_64_after_hwframe+0x77/0x7f
>
> Freed by task 5875:
>  kasan_save_stack mm/kasan/common.c:57 [inline]
>  kasan_save_track+0x3e/0x80 mm/kasan/common.c:78
>  kasan_save_free_info+0x46/0x50 mm/kasan/generic.c:584
>  poison_slab_object mm/kasan/common.c:253 [inline]
>  __kasan_slab_free+0x5c/0x80 mm/kasan/common.c:285
>  kasan_slab_free include/linux/kasan.h:235 [inline]
>  slab_free_hook mm/slub.c:2689 [inline]
>  slab_free mm/slub.c:6251 [inline]
>  kmem_cache_free+0x182/0x650 mm/slub.c:6378
>  mempool_free+0xec/0x130 mm/mempool.c:711
>  bio_free+0x1e9/0x330 block/bio.c:205
>  __blkdev_direct_IO+0xd6e/0xf40 block/fops.c:288
>  blkdev_direct_IO+0x121a/0x1790 block/fops.c:438
>  blkdev_read_iter+0x23d/0x440 block/fops.c:841
>  do_iter_readv_writev+0x619/0x8c0 fs/read_write.c:-1
>  vfs_readv+0x288/0x840 fs/read_write.c:1020
>  do_preadv fs/read_write.c:1134 [inline]
>  __do_sys_preadv2 fs/read_write.c:1193 [inline]
>  __se_sys_preadv2+0x184/0x2a0 fs/read_write.c:1184
>  do_syscall_x64 arch/x86/entry/syscall_64.c:63 [inline]
>  do_syscall_64+0x174/0x580 arch/x86/entry/syscall_64.c:94
>  entry_SYSCALL_64_after_hwframe+0x77/0x7f
>
> The buggy address belongs to the object at ffff888177994400
>  which belongs to the cache biovec-max of size 4096
> The buggy address is located 0 bytes inside of
>  4096-byte region [ffff888177994400, ffff888177995400)
>
> The buggy address belongs to the physical page:
> page: refcount:0 mapcount:0 mapping:0000000000000000 index:0xffff88817799=
0000 pfn:0x177990
> head: order:3 mapcount:0 entire_mapcount:0 nr_pages_mapped:0 pincount:0
> flags: 0x57ff00000000240(workingset|head|node=3D1|zone=3D2|lastcpupid=3D0=
x7ff)
> page_type: f5(slab)
> raw: 057ff00000000240 ffff8881604148c0 ffff8881622adc48 ffffea0005de5010
> raw: ffff888177990000 0000000800070003 00000000f5000000 0000000000000000
> head: 057ff00000000240 ffff8881604148c0 ffff8881622adc48 ffffea0005de5010
> head: ffff888177990000 0000000800070003 00000000f5000000 0000000000000000
> head: 057ff00000000003 fffffffffffffe01 00000000ffffffff 00000000ffffffff
> head: ffffffffffffffff 0000000000000000 00000000ffffffff 0000000000000008
> page dumped because: kasan: bad access detected
> page_owner tracks the page as allocated
> page last allocated via order 3, migratetype Unmovable, gfp_mask 0xd2800(=
GFP_NOWAIT|__GFP_NORETRY|__GFP_COMP|__GFP_NOMEMALLOC), pid 5065, tgid 5065 =
(udevd), ts 29098398773, free_ts 24434603765
>  set_page_owner include/linux/page_owner.h:32 [inline]
>  post_alloc_hook+0x22d/0x280 mm/page_alloc.c:1853
>  prep_new_page mm/page_alloc.c:1861 [inline]
>  get_page_from_freelist+0x2593/0x2610 mm/page_alloc.c:3941
>  __alloc_frozen_pages_noprof+0x18d/0x380 mm/page_alloc.c:5221
>  alloc_slab_page mm/slub.c:3278 [inline]
>  allocate_slab+0x77/0x660 mm/slub.c:3467
>  new_slab mm/slub.c:3525 [inline]
>  refill_objects+0x339/0x3d0 mm/slub.c:7272
>  refill_sheaf mm/slub.c:2816 [inline]
>  __pcs_replace_empty_main+0x321/0x720 mm/slub.c:4652
>  alloc_from_pcs mm/slub.c:4750 [inline]
>  slab_alloc_node mm/slub.c:4884 [inline]
>  kmem_cache_alloc_noprof+0x37d/0x650 mm/slub.c:4906
>  bio_alloc_bioset+0x599/0xc90 block/bio.c:571
>  bio_alloc include/linux/bio.h:367 [inline]
>  ext4_mpage_readpages+0x13b5/0x1f30 fs/ext4/readpage.c:355
>  read_pages+0x193/0x5a0 mm/readahead.c:163
>  page_cache_ra_unbounded+0x794/0xa10 mm/readahead.c:304
>  do_page_cache_ra mm/readahead.c:334 [inline]
>  page_cache_ra_order+0xae4/0xe80 mm/readahead.c:538
>  filemap_readahead mm/filemap.c:2664 [inline]
>  filemap_get_pages+0x897/0x1ef0 mm/filemap.c:2710
>  filemap_read+0x447/0x1230 mm/filemap.c:2806
>  __kernel_read+0x504/0x9b0 fs/read_write.c:532
>  integrity_kernel_read+0x89/0xd0 security/integrity/iint.c:28
> page last free pid 10 tgid 10 stack trace:
>  reset_page_owner include/linux/page_owner.h:25 [inline]
>  __free_pages_prepare mm/page_alloc.c:1397 [inline]
>  __free_frozen_pages+0xc1c/0xd30 mm/page_alloc.c:2938
>  vfree+0x1d1/0x2f0 mm/vmalloc.c:3472
>  delayed_vfree_work+0x55/0x80 mm/vmalloc.c:3392
>  process_one_work kernel/workqueue.c:3314 [inline]
>  process_scheduled_works+0xb5d/0x1860 kernel/workqueue.c:3397
>  worker_thread+0xa53/0xfc0 kernel/workqueue.c:3478
>  kthread+0x389/0x470 kernel/kthread.c:436
>  ret_from_fork+0x514/0xb70 arch/x86/kernel/process.c:158
>  ret_from_fork_asm+0x1a/0x30 arch/x86/entry/entry_64.S:245
>
> Memory state around the buggy address:
>  ffff888177994300: fc fc fc fc fc fc fc fc fc fc fc fc fc fc fc fc
>  ffff888177994380: fc fc fc fc fc fc fc fc fc fc fc fc fc fc fc fc
> >ffff888177994400: fa fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb
>                    ^
>  ffff888177994480: fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb
>  ffff888177994500: fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb
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
> [axboe@kernel.dk linux-block@vger.kernel.org linux-kernel@vger.kernel.org=
 stable@vger.kernel.org vulab@iscas.ac.cn]
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
-upstream-moderation/6a1fc867.b4221f80.1326c5.0006.GAE%40google.com.
