Received: from mail-wm1-f50.google.com (mail-wm1-f50.google.com [209.85.128.50])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 49E65399004
	for <syzbot@lists.linux.dev>; Mon, 27 Apr 2026 08:40:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.128.50
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777279206; cv=pass; b=iT6nihKojrV6tDspC3ir6sLaNgTUuIJfVxE68RE8OfbJQhGJxTdz24XxOmnU/TjXgCLrF576Hr+glbcbr5Dv7aIF1CTbcXfvFb7w449EYO0Ir3BL5yBemXEfGd08KUz5fPM+vzWh53Hii6QofcHu36tBWaDLfTq/hsGvkr/Dzq4=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777279206; c=relaxed/simple;
	bh=Qt8+5y5K9O0K4V65L8bjQ4sYiwIFPU0mIt/eD5AyG6M=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=hYjmou4nt/gr3Tr/S0WRNZOums6minZhhEFqWL8XqypdsaFhLyLYe4ORxitPf1wEggjaw83k8ymqNnnZWFk54gXAuFYrhE8w+c2nhFYndDnGXng9FKtrC93oJlPQCFFAZGQ03wZIen4Fa00zu6wvFanDzDnB2PP2AGAltCFWkL8=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=P9wEX7jj; arc=pass smtp.client-ip=209.85.128.50
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="P9wEX7jj"
Received: by mail-wm1-f50.google.com with SMTP id 5b1f17b1804b1-48334ee0aeaso103700405e9.1
        for <syzbot@lists.linux.dev>; Mon, 27 Apr 2026 01:40:04 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1777279203; cv=none;
        d=google.com; s=arc-20240605;
        b=esl04u6xLd8Lc0ZpopOigQCdDrw3H4SliZcE6KcNpxFlt4IDJinK96ZhlniCM6ouRr
         OaQTl14HWpHQ6EGlNoKMLTx62w6ZJ15gfMcdpRQTwz27n7j8nAJFPby42WjZ2mOuZzFj
         kUIYnVW2e7akmgDGD2EkhJvIDDlS57ETQYbcndN7WpshSQ2SzJCXdCTLKqkfequH5iH5
         Iopg89q/kig7zNDY9Pfw2cwUzeTsgeGpzGAi3OvBgnUE80pP0sCB4SARC5l8DCYZvgOf
         uUChY65P59+nx7oVKFkQ+y5NR2eEElNjRW2UQWL9tQzYt7S3RT30if8GY/Ehh2egpNVI
         6+2g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=nlCkeK5pzW151P2Z/IElKhY/ZguD6o77P9EIJl1Kytc=;
        fh=hhbYAMtISKopmmiOst7Lidpxr/MTCa0rhU/uk2PvI90=;
        b=D+pbQtKXDN5D/sIY3BeAWoorr+c8X8o6yStieouWus+Q43AZRRRFzu1C6QLIBvHWV1
         oSep25DzMdKxCH9n9X0y9Gxm7kVPjPsCmSq6/oOLlvM+JIVDekaCqoXuVVHVsPUxay0r
         Z9y2M5eDoheaYZg41bmOQTgYW0lwdKEBrsaCAavVZK3QYuH5WCrGKDCM7Th7NRxCdLdN
         8qUD4eWDBwgZydaYX1kuwCji4TFdVYOxYoGUKuBoy6Adb64Y42zapxBffpgobZDyNioM
         21pe7zcBZHJaTHB8CDiQC2iJIB6NWmZvJHE1WIgQirpPeIzOqbu9urV+5c9HGO1v/mCd
         eefQ==;
        darn=lists.linux.dev
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1777279203; x=1777884003; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=nlCkeK5pzW151P2Z/IElKhY/ZguD6o77P9EIJl1Kytc=;
        b=P9wEX7jjbjccdjEX6PvxCL/J9sMQy1FSg/FwZap19NM+ogFS/vXH2JTTjTuvk04l4O
         yXnv4yuEfHPa90SsMXgHkGI9mmfFLH8wxbSkYFHwMUj6PAtpN3BuCPhdifGQ+H/gP6li
         1ley8xzmqPgjqZu5+thnHlTGjkUxfLeN5xtdAi0m4q7Jv3obWWqgO8XeNuC1Bi9Mv448
         YPK1zdiYmj93hx16M5nrQNEpmZOhCxfuG3Kg1hJtj7evkgOjmYhpEOWjGpFCYHwpb109
         /bkjYH8juU2DzJQpY0RmneP7QDF6uBR9X9/jRixMmBaZVRbhyzqTnWfPbqZpzCe+V2WM
         Uegg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1777279203; x=1777884003;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=nlCkeK5pzW151P2Z/IElKhY/ZguD6o77P9EIJl1Kytc=;
        b=HCqisguhmYmgCwUH/MPTMdxobitvky1pErW2NM6Eox9Pnko3FOv/XOiT1CiteLxgXT
         iky74ifZFF9Z7v7O8vmOA6dGngDPxP+1mNL/kAu+pfOi4RdiqXUqFsnkGIKizjU/LQ0c
         yYwX2lej8wTc4s9SbHB3BdRhjfaH4cOHYIGUchznC3Yqdwr16DM6Ktrgd6IQEzLqfuUu
         AigLoKTFDFDNuhHGGLfv66pdS1zM3YV/B7LKkEzLpgjRUeJ0lQFTY/gXpFP2AIx9Ip6n
         g07S0pNU68prW+UabhgOu707lw4bS5ly7+jeFaH0zfBNG6aQx0bmpdDlXzDGXxhVQ3wU
         wEFQ==
X-Forwarded-Encrypted: i=1; AFNElJ+5M9qdUr0Ze2NkPWfGQ8+oHMkES00citBoXtJky26Lyua4r5aiDJXNmzi/5O9APCoqn9LkPpc=@lists.linux.dev
X-Gm-Message-State: AOJu0Yzcc/Ot1330Jyut6O6IwOGbHwYAPkFhGYeq8lzKWQ7IDSDsSuIK
	thrEqt13oVpv4vq3gThmAOxtTzk9ijHmvSl9t0cpeq8y6c0NaZL88MDbvwRKd7e6Cy9zhbF2fck
	MHCiNZ/djj20/d2O+PYFMQfvy1vUYo9N9NrdCS08v
X-Gm-Gg: AeBDieuzkcqczpGZ67aN+Af7D6ZFK0AcIJx//yYsbFcVPSdRC+l0Fez0suMc9fo2H6N
	YXdfmffqJ0vaq/ZAkC2TgppCosOw9cPc648YH/juO9+iArWlj12SjNtxDJWoaqEjj455tVc6Sga
	FiXVz3kLWHrhiUoNDvSOBXG3+A11+meog8aoWRKVbhnB0AKS6lf+z7aOQ2FV+ZK5Ka5PgGU52Uc
	stATyMH/6CSuxz+4XepkUOg4P4GYeuN2F1rsGstiF5soCJ/BUbL1MnkdthrjkzN0BAbTxA4czy2
	diEg36jlMcypIloycugXwgo9WKLie/r59bCd9F4SDfnYvZjyWaGDeTvuXJuUVf5p+pJfV8sN7Qq
	E7cAizG+2PwJZ5eAG5xPV330cZ6H6nA==
X-Received: by 2002:a05:600c:8b38:b0:487:59c:2bb8 with SMTP id
 5b1f17b1804b1-488fb7925dcmr593623215e9.27.1777279202098; Mon, 27 Apr 2026
 01:40:02 -0700 (PDT)
Precedence: bulk
X-Mailing-List: syzbot@lists.linux.dev
List-Id: <syzbot.lists.linux.dev>
List-Subscribe: <mailto:syzbot+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:syzbot+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <69ef1f0f.170a0220.11de9.0017.GAE@google.com>
In-Reply-To: <69ef1f0f.170a0220.11de9.0017.GAE@google.com>
From: Pimyn Girgis <pimyn@google.com>
Date: Mon, 27 Apr 2026 10:39:51 +0200
X-Gm-Features: AVHnY4Jbod9UCVrZ43ewFht6j7TQOAiCGw6UUBxT2VRdCCG_E_X9vtyep-5avZ0
Message-ID: <CAJWNTGybJTXoPJwj4MQyHkXohmHo3Tf3uazNR0UwJBn6OMt3Vg@mail.gmail.com>
Subject: Re: [moderation/CI] Re: Prepare to lift lookup out of exclusive lock
 for directory ops
To: syzbot ci <syzbot+ci3dc0f43f5fbad93c@syzkaller.appspotmail.com>
Cc: syzkaller-upstream-moderation@googlegroups.com, syzbot@lists.linux.dev
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

#syz upstream

On Mon, Apr 27, 2026 at 10:32=E2=80=AFAM syzbot ci
<syzbot+ci3dc0f43f5fbad93c@syzkaller.appspotmail.com> wrote:
>
> syzbot ci has tested the following series
>
> [v3] Prepare to lift lookup out of exclusive lock for directory ops
> https://lore.kernel.org/all/20260427040517.828226-1-neilb@ownmail.net
> * [PATCH v3 01/19] VFS: fix various typos in documentation for start_crea=
ting start_removing etc
> * [PATCH v3 02/19] VFS: enhance d_splice_alias() to handle in-lookup dent=
ries
> * [PATCH v3 03/19] VFS: allow d_alloc_name() to be used with ->d_hash
> * [PATCH v3 04/19] VFS: use wait_var_event for waiting in d_alloc_paralle=
l()
> * [PATCH v3 05/19] VFS: introduce d_alloc_noblock()
> * [PATCH v3 06/19] VFS: add d_duplicate()
> * [PATCH v3 07/19] VFS: Add LOOKUP_SHARED flag.
> * [PATCH v3 08/19] VFS/xfs/ntfs: drop parent lock across d_alloc_parallel=
() in d_add_ci()
> * [PATCH v3 09/19] ovl: stop using lookup_one() in iterate_shared() handl=
ing.
> * [PATCH v3 10/19] VFS/ovl: add d_alloc_noblock_return()
> * [PATCH v3 11/19] efivarfs: use d_alloc_name()
> * [PATCH v3 12/19] shmem: use d_duplicate()
> * [PATCH v3 13/19] nfs: remove d_drop()/d_alloc_parallel() from nfs_atomi=
c_open()
> * [PATCH v3 14/19] nfs: use d_splice_alias() in nfs_link()
> * [PATCH v3 15/19] nfs: don't d_drop() before d_splice_alias()
> * [PATCH v3 16/19] nfs: don't d_drop() before d_splice_alias() in atomic_=
create.
> * [PATCH v3 17/19] nfs: Use d_alloc_noblock() in nfs_prime_dcache()
> * [PATCH v3 18/19] nfs: use d_alloc_noblock() in silly-rename
> * [PATCH v3 19/19] nfs: use d_duplicate()
>
> and found the following issues:
> * KASAN: slab-out-of-bounds Read in __dentry_kill
> * WARNING in __d_instantiate
>
> Full report is available here:
> https://ci.syzbot.org/series/9ec82ecc-cc80-4fe2-b595-e5c9d7c49aae
>
> ***
>
> KASAN: slab-out-of-bounds Read in __dentry_kill
>
> tree:      torvalds
> URL:       https://kernel.googlesource.com/pub/scm/linux/kernel/git/torva=
lds/linux
> base:      254f49634ee16a731174d2ae34bc50bd5f45e731
> arch:      amd64
> compiler:  Debian clang version 21.1.8 (++20251221033036+2078da43e25a-1~e=
xp1~20251221153213.50), Debian LLD 21.1.8
> config:    https://ci.syzbot.org/builds/01f9ecd4-e5ae-4e96-aff5-2636e33c0=
528/config
> syz repro: https://ci.syzbot.org/findings/ef8289e5-b522-4c69-bed5-f7be42e=
035c2/syz_repro
>
> overlayfs: "xino" feature enabled using 3 upper inode bits.
> =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
> BUG: KASAN: slab-out-of-bounds in __raw_spin_lock_irqsave include/linux/s=
pinlock_api_smp.h:132 [inline]
> BUG: KASAN: slab-out-of-bounds in _raw_spin_lock_irqsave+0x40/0x60 kernel=
/locking/spinlock.c:166
> Read of size 1 at addr ffff888119c6e5b8 by task syz.0.17/5869
>
> CPU: 0 UID: 0 PID: 5869 Comm: syz.0.17 Not tainted syzkaller #0 PREEMPT(f=
ull)
> Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS 1.16.2-debian-1.=
16.2-1 04/01/2014
> Call Trace:
>  <TASK>
>  dump_stack_lvl+0xe8/0x150 lib/dump_stack.c:120
>  print_address_description+0x55/0x1e0 mm/kasan/report.c:378
>  print_report+0x58/0x70 mm/kasan/report.c:482
>  kasan_report+0x117/0x150 mm/kasan/report.c:595
>  __kasan_check_byte+0x2a/0x40 mm/kasan/common.c:574
>  kasan_check_byte include/linux/kasan.h:402 [inline]
>  lock_acquire+0x84/0x350 kernel/locking/lockdep.c:5842
>  __raw_spin_lock_irqsave include/linux/spinlock_api_smp.h:132 [inline]
>  _raw_spin_lock_irqsave+0x40/0x60 kernel/locking/spinlock.c:166
>  complete_with_flags kernel/sched/completion.c:25 [inline]
>  complete+0x28/0x1b0 kernel/sched/completion.c:52
>  d_complete_waiters fs/dcache.c:651 [inline]
>  dentry_unlist fs/dcache.c:664 [inline]
>  __dentry_kill+0x552/0x690 fs/dcache.c:733
>  finish_dput+0xc9/0x480 fs/dcache.c:928
>  ovl_cache_update+0x68e/0xc30 fs/overlayfs/readdir.c:643
>  ovl_iterate_merged fs/overlayfs/readdir.c:882 [inline]
>  ovl_iterate+0x686/0x21a0 fs/overlayfs/readdir.c:930
>  wrap_directory_iterator+0x96/0xe0 fs/readdir.c:67
>  iterate_dir+0x399/0x570 fs/readdir.c:110
>  __do_sys_getdents64 fs/readdir.c:399 [inline]
>  __se_sys_getdents64+0xf1/0x280 fs/readdir.c:384
>  do_syscall_x64 arch/x86/entry/syscall_64.c:63 [inline]
>  do_syscall_64+0x15f/0xf80 arch/x86/entry/syscall_64.c:94
>  entry_SYSCALL_64_after_hwframe+0x77/0x7f
> RIP: 0033:0x7f7aa699cdd9
> Code: ff c3 66 2e 0f 1f 84 00 00 00 00 00 0f 1f 44 00 00 48 89 f8 48 89 f=
7 48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 ff=
 ff 73 01 c3 48 c7 c1 e8 ff ff ff f7 d8 64 89 01 48
> RSP: 002b:00007f7aa780a028 EFLAGS: 00000246 ORIG_RAX: 00000000000000d9
> RAX: ffffffffffffffda RBX: 00007f7aa6c15fa0 RCX: 00007f7aa699cdd9
> RDX: 0000000000001000 RSI: 0000200000000400 RDI: 0000000000000003
> RBP: 00007f7aa6a32d69 R08: 0000000000000000 R09: 0000000000000000
> R10: 0000000000000000 R11: 0000000000000246 R12: 0000000000000000
> R13: 00007f7aa6c16038 R14: 00007f7aa6c15fa0 R15: 00007ffce28f8638
>  </TASK>
>
> Allocated by task 5869:
>  kasan_save_stack mm/kasan/common.c:57 [inline]
>  kasan_save_track+0x3e/0x80 mm/kasan/common.c:78
>  unpoison_slab_object mm/kasan/common.c:340 [inline]
>  __kasan_slab_alloc+0x6c/0x80 mm/kasan/common.c:366
>  kasan_slab_alloc include/linux/kasan.h:253 [inline]
>  slab_post_alloc_hook mm/slub.c:4569 [inline]
>  slab_alloc_node mm/slub.c:4898 [inline]
>  kmem_cache_alloc_lru_noprof+0x2b8/0x640 mm/slub.c:4917
>  __d_alloc+0x37/0x6f0 fs/dcache.c:1808
>  __d_alloc_parallel+0xe3/0x1660 fs/dcache.c:2758
>  ovl_cache_update+0x2c4/0xc30 fs/overlayfs/readdir.c:577
>  ovl_iterate_merged fs/overlayfs/readdir.c:882 [inline]
>  ovl_iterate+0x686/0x21a0 fs/overlayfs/readdir.c:930
>  wrap_directory_iterator+0x96/0xe0 fs/readdir.c:67
>  iterate_dir+0x399/0x570 fs/readdir.c:110
>  __do_sys_getdents64 fs/readdir.c:399 [inline]
>  __se_sys_getdents64+0xf1/0x280 fs/readdir.c:384
>  do_syscall_x64 arch/x86/entry/syscall_64.c:63 [inline]
>  do_syscall_64+0x15f/0xf80 arch/x86/entry/syscall_64.c:94
>  entry_SYSCALL_64_after_hwframe+0x77/0x7f
>
> Last potentially related work creation:
>  kasan_save_stack+0x3e/0x60 mm/kasan/common.c:57
>  kasan_record_aux_stack+0xbd/0xd0 mm/kasan/generic.c:556
>  __call_rcu_common kernel/rcu/tree.c:3131 [inline]
>  call_rcu+0xee/0x890 kernel/rcu/tree.c:3251
>  __dentry_kill+0x4a9/0x690 fs/dcache.c:738
>  finish_dput+0xc9/0x480 fs/dcache.c:928
>  ovl_cache_update+0x68e/0xc30 fs/overlayfs/readdir.c:643
>  ovl_iterate_merged fs/overlayfs/readdir.c:882 [inline]
>  ovl_iterate+0x686/0x21a0 fs/overlayfs/readdir.c:930
>  wrap_directory_iterator+0x96/0xe0 fs/readdir.c:67
>  iterate_dir+0x399/0x570 fs/readdir.c:110
>  __do_sys_getdents64 fs/readdir.c:399 [inline]
>  __se_sys_getdents64+0xf1/0x280 fs/readdir.c:384
>  do_syscall_x64 arch/x86/entry/syscall_64.c:63 [inline]
>  do_syscall_64+0x15f/0xf80 arch/x86/entry/syscall_64.c:94
>  entry_SYSCALL_64_after_hwframe+0x77/0x7f
>
> The buggy address belongs to the object at ffff888119c6e468
>  which belongs to the cache dentry of size 312
> The buggy address is located 24 bytes to the right of
>  allocated 312-byte region [ffff888119c6e468, ffff888119c6e5a0)
>
> The buggy address belongs to the physical page:
> page: refcount:0 mapcount:0 mapping:0000000000000000 index:0x0 pfn:0x119c=
6e
> head: order:1 mapcount:0 entire_mapcount:0 nr_pages_mapped:0 pincount:0
> memcg:ffff888119c6fed9
> flags: 0x17ff00000000040(head|node=3D0|zone=3D2|lastcpupid=3D0x7ff)
> page_type: f5(slab)
> raw: 017ff00000000040 ffff888160417140 dead000000000100 dead000000000122
> raw: 0000000000000000 0000000800150015 00000000f5000000 ffff888119c6fed9
> head: 017ff00000000040 ffff888160417140 dead000000000100 dead000000000122
> head: 0000000000000000 0000000800150015 00000000f5000000 ffff888119c6fed9
> head: 017ff00000000001 ffffffffffffff81 00000000ffffffff 00000000ffffffff
> head: ffffffffffffffff 0000000000000000 00000000ffffffff 0000000000000002
> page dumped because: kasan: bad access detected
> page_owner tracks the page as allocated
> page last allocated via order 1, migratetype Reclaimable, gfp_mask 0xd20d=
0(__GFP_RECLAIMABLE|__GFP_IO|__GFP_FS|__GFP_NOWARN|__GFP_NORETRY|__GFP_COMP=
|__GFP_NOMEMALLOC), pid 5645, tgid 5645 (syz-executor), ts 69015847006, fre=
e_ts 0
>  set_page_owner include/linux/page_owner.h:32 [inline]
>  post_alloc_hook+0x231/0x280 mm/page_alloc.c:1858
>  prep_new_page mm/page_alloc.c:1866 [inline]
>  get_page_from_freelist+0x24ba/0x2540 mm/page_alloc.c:3946
>  __alloc_frozen_pages_noprof+0x18d/0x380 mm/page_alloc.c:5226
>  alloc_slab_page mm/slub.c:3278 [inline]
>  allocate_slab+0x77/0x660 mm/slub.c:3467
>  new_slab mm/slub.c:3525 [inline]
>  refill_objects+0x339/0x3d0 mm/slub.c:7251
>  refill_sheaf mm/slub.c:2816 [inline]
>  __pcs_replace_empty_main+0x321/0x720 mm/slub.c:4651
>  alloc_from_pcs mm/slub.c:4749 [inline]
>  slab_alloc_node mm/slub.c:4883 [inline]
>  kmem_cache_alloc_lru_noprof+0x37c/0x640 mm/slub.c:4917
>  __d_alloc+0x37/0x6f0 fs/dcache.c:1808
>  d_alloc+0x4b/0x190 fs/dcache.c:1887
>  lookup_one_qstr_excl+0xd8/0x360 fs/namei.c:1801
>  __start_dirop fs/namei.c:2915 [inline]
>  start_dirop fs/namei.c:2937 [inline]
>  filename_create+0x20e/0x370 fs/namei.c:4949
>  filename_mkdirat+0xd2/0x510 fs/namei.c:5286
>  __do_sys_mkdirat fs/namei.c:5314 [inline]
>  __se_sys_mkdirat+0x35/0x150 fs/namei.c:5311
>  do_syscall_x64 arch/x86/entry/syscall_64.c:63 [inline]
>  do_syscall_64+0x15f/0xf80 arch/x86/entry/syscall_64.c:94
>  entry_SYSCALL_64_after_hwframe+0x77/0x7f
> page_owner free stack trace missing
>
> Memory state around the buggy address:
>  ffff888119c6e480: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
>  ffff888119c6e500: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
> >ffff888119c6e580: 00 00 00 00 fc fc fc fc fc fc fc fc fa fb fb fb
>                                         ^
>  ffff888119c6e600: fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb
>  ffff888119c6e680: fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb
> =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
>
>
> ***
>
> WARNING in __d_instantiate
>
> tree:      torvalds
> URL:       https://kernel.googlesource.com/pub/scm/linux/kernel/git/torva=
lds/linux
> base:      254f49634ee16a731174d2ae34bc50bd5f45e731
> arch:      amd64
> compiler:  Debian clang version 21.1.8 (++20251221033036+2078da43e25a-1~e=
xp1~20251221153213.50), Debian LLD 21.1.8
> config:    https://ci.syzbot.org/builds/01f9ecd4-e5ae-4e96-aff5-2636e33c0=
528/config
> syz repro: https://ci.syzbot.org/findings/f4cad05d-60bf-4656-a4e7-27c99f4=
f056b/syz_repro
>
> loop2: detected capacity change from 0 to 16
> erofs (device loop2): mounted with root inode @ nid 36.
> ------------[ cut here ]------------
> d_in_lookup(dentry)
> WARNING: fs/dcache.c:2112 at __d_instantiate+0x3ea/0x6e0 fs/dcache.c:2112=
, CPU#0: syz.2.19/5857
> Modules linked in:
> CPU: 0 UID: 0 PID: 5857 Comm: syz.2.19 Not tainted syzkaller #0 PREEMPT(f=
ull)
> Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS 1.16.2-debian-1.=
16.2-1 04/01/2014
> RIP: 0010:__d_instantiate+0x3ea/0x6e0 fs/dcache.c:2112
> Code: 03 41 80 f6 01 41 0f b6 ce c1 e1 0d 09 c1 89 0b 48 83 c4 10 5b 41 5=
c 41 5d 41 5e 41 5f 5d e9 7d 25 61 09 cc e8 87 21 7c ff 90 <0f> 0b 90 e9 7f=
 fd ff ff e8 79 21 7c ff 41 81 cc 00 00 01 00 e9 34
> RSP: 0018:ffffc900038274a0 EFLAGS: 00010293
> RAX: ffffffff82498229 RBX: ffff888114bb8a48 RCX: ffff88810b5e9d80
> RDX: 0000000000000000 RSI: 0000000001000000 RDI: 0000000000000000
> RBP: 0000000001000000 R08: 0000000000000003 R09: 0000000000000004
> R10: dffffc0000000000 R11: fffff52000704e8c R12: 0000000000280000
> R13: dffffc0000000000 R14: ffff888113d61960 R15: ffff888113d61964
> FS:  00007fadb922c6c0(0000) GS:ffff88818dc93000(0000) knlGS:0000000000000=
000
> CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> CR2: 00007fadb8272700 CR3: 000000016d53e000 CR4: 00000000000006f0
> Call Trace:
>  <TASK>
>  d_make_persistent+0x8e/0x180 fs/dcache.c:3068
>  shmem_mknod+0x2ea/0x360 mm/shmem.c:3881
>  shmem_whiteout mm/shmem.c:4012 [inline]
>  shmem_rename2+0x265/0x430 mm/shmem.c:4052
>  vfs_rename+0xa96/0xeb0 fs/namei.c:6053
>  ovl_do_rename_rd fs/overlayfs/overlayfs.h:372 [inline]
>  ovl_check_rename_whiteout fs/overlayfs/super.c:593 [inline]
>  ovl_make_workdir fs/overlayfs/super.c:713 [inline]
>  ovl_get_workdir fs/overlayfs/super.c:836 [inline]
>  ovl_fill_super_creds fs/overlayfs/super.c:1449 [inline]
>  ovl_fill_super+0x46b7/0x5e20 fs/overlayfs/super.c:1560
>  vfs_get_super fs/super.c:1327 [inline]
>  get_tree_nodev+0xbb/0x150 fs/super.c:1346
>  vfs_get_tree+0x92/0x2a0 fs/super.c:1754
>  fc_mount fs/namespace.c:1193 [inline]
>  do_new_mount_fc fs/namespace.c:3758 [inline]
>  do_new_mount+0x341/0xd30 fs/namespace.c:3834
>  do_mount fs/namespace.c:4167 [inline]
>  __do_sys_mount fs/namespace.c:4383 [inline]
>  __se_sys_mount+0x31d/0x420 fs/namespace.c:4360
>  do_syscall_x64 arch/x86/entry/syscall_64.c:63 [inline]
>  do_syscall_64+0x15f/0xf80 arch/x86/entry/syscall_64.c:94
>  entry_SYSCALL_64_after_hwframe+0x77/0x7f
> RIP: 0033:0x7fadb839cdd9
> Code: ff c3 66 2e 0f 1f 84 00 00 00 00 00 0f 1f 44 00 00 48 89 f8 48 89 f=
7 48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 ff=
 ff 73 01 c3 48 c7 c1 e8 ff ff ff f7 d8 64 89 01 48
> RSP: 002b:00007fadb922c028 EFLAGS: 00000246 ORIG_RAX: 00000000000000a5
> RAX: ffffffffffffffda RBX: 00007fadb8615fa0 RCX: 00007fadb839cdd9
> RDX: 0000200000000340 RSI: 00002000000000c0 RDI: 0000000000000000
> RBP: 00007fadb8432d69 R08: 0000200000000380 R09: 0000000000000000
> R10: 0000000000000000 R11: 0000000000000246 R12: 0000000000000000
> R13: 00007fadb8616038 R14: 00007fadb8615fa0 R15: 00007ffe45be7c28
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
> [amir73il@gmail.com anna@kernel.org ardb@kernel.org brauner@kernel.org ja=
ck@suse.cz jk@ozlabs.org jlayton@kernel.org linux-efi@vger.kernel.org linux=
-fsdevel@vger.kernel.org linux-kernel@vger.kernel.org linux-nfs@vger.kernel=
.org linux-unionfs@vger.kernel.org miklos@szeredi.hu neilb@ownmail.net torv=
alds@linux-foundation.org trondmy@kernel.org viro@zeniv.linux.org.uk]
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
-upstream-moderation/69ef1f0f.170a0220.11de9.0017.GAE%40google.com.
