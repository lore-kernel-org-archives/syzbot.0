Received: from mail-ot1-f41.google.com (mail-ot1-f41.google.com [209.85.210.41])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0F5D1372675
	for <syzbot@lists.linux.dev>; Sat, 20 Jun 2026 06:53:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.210.41
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781938421; cv=pass; b=E3nnPfI0PEAIpyHBgJ1hJSJAfkfizS3rUmqMSdlNRibbnOH2hy6xYAd5p+vw7a5j5ciPN+Xj6keOMMz7DiO0+uEtfEEEk7GX+Y3fxyRDLjuNITsMVueoxWlHr3MKYi9FdoszQ0CSlRV4f5lNyfZ0HY1ACo5jzltVocWtv++McqU=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781938421; c=relaxed/simple;
	bh=edFEw8Zp1cZ7k87YVkrUltDeh7uessmzsOBGmwyD4O8=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=QvQaw3wZgLbgkBcT4F8so9610sC7J+vQQDad81eP96NyXTJNskq04rENFZHGPBeQfkXvYBgbxsYIOiyN20UWPdWUM8WxuIBZR8brkhe2Rz4Hr7+4z1PTfszRCWGDeZmPft1kZSlKSPsxCB250knOuFP9HBy68m6dACjm21pI0ZI=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=B07TDiiK; arc=pass smtp.client-ip=209.85.210.41
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="B07TDiiK"
Received: by mail-ot1-f41.google.com with SMTP id 46e09a7af769-7e6fa36a1b6so2092952a34.1
        for <syzbot@lists.linux.dev>; Fri, 19 Jun 2026 23:53:37 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1781938417; cv=none;
        d=google.com; s=arc-20240605;
        b=YCcnk4hseRgDD/nhXkYhbjNuFlZHinHHrmftgindWUCDpiIrcbJBJqh1uesjfAXbNJ
         RNRbGxKoY2Oi844Vw+4cRjKJMmZkWXUFP5v5rrHty53tNITnZIDhtox2IwsFbwyoLhvx
         G0IegTJ6T8vk/j99moTm5yAZNlYnSHy1Ez7kEOZs5a3R69ELlcDcawwHZW13vHu5cEA7
         6sxVrXor37WGSJNFQeVYgxC+euI9/ZoYfEusR04361PB4xez6ueWjtMtnb8QpR6jWRgL
         ZU8tW4Y7De/D89EFAXq9KZVgRZYiXM+e1/Fps0sWydZt9zmuqxdXIRhe3SBTrHEh/wZw
         lwYg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=YwrzcaFFBZdc2NI7osLf/bG7iXj08PGptW8UWDcsWQ8=;
        fh=iVcHl/TGMs/hRr5lQzo9W7rrl8tNjNzlC73o5u0WZ4g=;
        b=QE2gmNsKUbfzGp+z2VgCw8ke/P2kEBjCbaFF1dFGOqfgfdDJsCwt78KijCExhq0CaI
         2M9ysgyzMI0zbr5Ii7x+TN5Hd+uLd6tJ63VNps9nn3FLjtz8CWrkB3RBXg6an0uZd42l
         rnlIijks8IrMkN7rz1SrliViqzg9W2ssd9FuEuqTz8okf+x+lHtiJCWNZMyQlcDLEYRI
         kjJb7mJQY22qbQYtbl2nhwdzm4GXgn1EgfLhBW4q2DiGWeUx9rEKZkJxLSuSgR2Cg3IK
         LNFCq9ca3C4PeiH9h3q//ucJsAyk6dNTOjdVZFWnEPmsSUJgTdZLDj5f2KPpXAly1GlP
         B7hA==;
        darn=lists.linux.dev
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1781938417; x=1782543217; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=YwrzcaFFBZdc2NI7osLf/bG7iXj08PGptW8UWDcsWQ8=;
        b=B07TDiiK+uwTPeqckrlE24N5CeSSQ25YCjk3x8pGcgVYNFxnDaqkNd3LAs3Z0/ysV3
         HDHb25UEvW3RENaGVYUmlEICbpQ3PpgpWwCjke0IWp4uEQyTFqxPCYHM8D3cz1VsGyFe
         SSpr0GcswMpxT2ZRqlsKxtTZrlqnxeDChf+Hrlbaq88kiEH6eAV8h1LwU357zNuVH2Tf
         /r4kplHhJQueMj73vjOZ0MX4Vz67SwMexHN4/v5q3oCWRUrqlI+PAlcvFJXigls9EC5b
         sFBY10e5Nsja+sr71mH1O70itIwcdGh8uHsGorbfsZ3ds+Pd3sY4VjK+YnpZ55/Iz8d8
         CVkg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1781938417; x=1782543217;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=YwrzcaFFBZdc2NI7osLf/bG7iXj08PGptW8UWDcsWQ8=;
        b=k36fbFCvq9bZ3parTeaJkv37YXowoZw8olb1Fte3qM49ckWF6tBkNvlkG/MvaZSPsA
         NnCY67JX0VK6rBFJO4/55ufmwNsYIB1/DJq1JFzRwIXOXRyvonyGEPCjZckmdmgZfT0q
         yVbBfiSCIHiY/Hx9B1L1mlahiCy0xojRcBZTuLIe6isG6Q3pqEy8J6HQE5C8urDXi8S/
         vdx5ORpX5ZDLEpEbyTDjTAoAB1WlECOUa+lD18wmTaiPFiaVuWNsvKJPPVwxoJxdrHxP
         WB9LWve0/0vNiYm1wNh3eLzqaHWhAnT763B6GJuXqvBzBvI0aMEQ11Nk4YEjjfkVoCws
         FGSg==
X-Forwarded-Encrypted: i=1; AFNElJ9P/hTw3wgi2nJ5nejI97al6CUwsj0mavGWUUVfJP9MHWEMLpkGiuzzeLlFm92AVMcfBY9SVHA=@lists.linux.dev
X-Gm-Message-State: AOJu0YzndNbHqgrpA3Ipp+rRgUeFNUFprqK1QQ64OxH2DjIKq6our+93
	dEgYB2FArGi8VnMNaJxuv9I952g3YhV0iOrmCDeGndMsHyGN+6yc0lLmO1D4M228HXqZS0E0mcT
	oazvA6EmrJ0V8NxVuPib8l4zWrve2Cl2UWE8t/VbJ
X-Gm-Gg: AfdE7clJUPpWFZKvH4uLvYXKKPzo+5fKvav+GjuHdDsjBHt+qADQi8Wpku1QdaWgiaH
	v5C5QrvTyihb70CaSjYuwxOOzXEcSMkTXE0TO7jmHRHvVy+2QVfTTxMozf9dDKarzTuWEaF2a6s
	UVRVgqehFsFYjSYiMNiFbfc6zCf4KEu7nWwnbFfFz90D6gaPVnoJ3kMpxHVoZltcmcnt/L8if/W
	b8RcHwij/ErBFR0ZlozbGVCchlr7lzdi9k92GnmU+fGxgdv2RYpNfmVpZYTSoiF21zcIqiZeTqS
	iCQ3xccv55S/LT3qJguDNLEnqhtw9eCSrtI82isuNLqhi6OObcJUb2MA1Djqsr/Fw+K3TGKz/90
	XspnTxcIjDE1Mq+IOfIsu
X-Received: by 2002:a05:6808:238b:b0:48a:67e8:69c4 with SMTP id
 5614622812f47-48a67e8776fmr3712799b6e.22.1781938415726; Fri, 19 Jun 2026
 23:53:35 -0700 (PDT)
Precedence: bulk
X-Mailing-List: syzbot@lists.linux.dev
List-Id: <syzbot.lists.linux.dev>
List-Subscribe: <mailto:syzbot+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:syzbot+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <6a35cfec.0df38f03.ad14c.0000.GAE@google.com>
In-Reply-To: <6a35cfec.0df38f03.ad14c.0000.GAE@google.com>
From: Aleksandr Nogikh <nogikh@google.com>
Date: Sat, 20 Jun 2026 08:53:24 +0200
X-Gm-Features: AVVi8CfAGyv8V_BLveGN99X7QulcPZd0KW2GKRRlC3q0rObYlC-k6Rt-n30n5UU
Message-ID: <CANp29Y52-vQHAM1nHh9ZGcYvOLTw3btgiKh9wi1E3DYsyAkxPw@mail.gmail.com>
Subject: Re: [moderation/CI] Re: Data in direntry (dirdata) feature
To: syzbot ci <syzbot+cic8893434510be6fc@syzkaller.appspotmail.com>
Cc: syzkaller-upstream-moderation@googlegroups.com, syzbot@lists.linux.dev
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

#syz upstream

On Sat, Jun 20, 2026 at 1:25=E2=80=AFAM syzbot ci
<syzbot+cic8893434510be6fc@syzkaller.appspotmail.com> wrote:
>
> syzbot ci has tested the following series
>
> [v3] Data in direntry (dirdata) feature
> https://lore.kernel.org/all/20260619191022.27008-1-ablagodarenko@thelustr=
ecollective.com
> * [PATCH v3 01/10] ext4: replace ext4_dir_entry with ext4_dir_entry_2
> * [PATCH v3 02/10] ext4: add ext4_dir_entry_is_tail()
> * [PATCH v3 03/10] ext4: refactor dx_root to support variable dirent size=
s
> * [PATCH v3 04/10] ext4: add dirdata format definitions and access helper=
s
> * [PATCH v3 05/10] ext4: preserve dirdata bits in get_dtype()
> * [PATCH v3 06/10] ext4: add ext4_dir_entry_len() and harden dirdata pars=
ing
> * [PATCH v3 07/10] ext4: rename ext4_dir_rec_len() and clarify dirdata us=
age
> * [PATCH v3 08/10] ext4: dirdata feature
> * [PATCH v3 09/10] ext4: add dirdata set/get helpers
> * [PATCH v3 10/10] ext4: Add EXT4_IOC_SET_LUFID ioctl for setting LUFID o=
n directory entries
>
> and found the following issues:
> * KASAN: slab-out-of-bounds Read in __ext4_check_dir_entry
> * KASAN: slab-out-of-bounds Read in ext4_inlinedir_to_tree
> * KASAN: slab-use-after-free Read in __ext4_check_dir_entry
> * KASAN: slab-use-after-free Read in ext4_inlinedir_to_tree
> * KASAN: use-after-free Read in __ext4_check_dir_entry
>
> Full report is available here:
> https://ci.syzbot.org/series/a3c6e513-a6eb-4583-86f6-89176398b397
>
> ***
>
> KASAN: slab-out-of-bounds Read in __ext4_check_dir_entry
>
> tree:      torvalds
> URL:       https://kernel.googlesource.com/pub/scm/linux/kernel/git/torva=
lds/linux
> base:      08c7183f5b9ffe4408e74fff848a4cc2105361d4
> arch:      amd64
> compiler:  Debian clang version 22.1.6 (++20260514074242+fc4aad7b5db3-1~e=
xp1~20260514074407.73), Debian LLD 22.1.6
> config:    https://ci.syzbot.org/builds/0efdb868-daeb-4649-9bcb-5af41d993=
e73/config
> syz repro: https://ci.syzbot.org/findings/ec557d64-7b60-46c9-a0eb-feaa7a3=
eb2cd/syz_repro
>
> loop0: lost filesystem error report for type 5 error -117
> EXT4-fs (loop0): mounted filesystem 00000000-0000-0000-0000-000000000000 =
r/w without journal. Quota mode: none.
> =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
> BUG: KASAN: slab-out-of-bounds in ext4_dirent_get_data_len fs/ext4/ext4.h=
:4156 [inline]
> BUG: KASAN: slab-out-of-bounds in ext4_dir_entry_len fs/ext4/ext4.h:4183 =
[inline]
> BUG: KASAN: slab-out-of-bounds in __ext4_check_dir_entry+0x659/0xbe0 fs/e=
xt4/dir.c:96
> Read of size 1 at addr ffff88816e86bcd9 by task syz.0.21/5783
>
> CPU: 1 UID: 0 PID: 5783 Comm: syz.0.21 Not tainted syzkaller #0 PREEMPT(f=
ull)
> Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS 1.16.2-debian-1.=
16.2-1 04/01/2014
> Call Trace:
>  <TASK>
>  dump_stack_lvl+0xe8/0x150 lib/dump_stack.c:120
>  print_address_description+0x55/0x1e0 mm/kasan/report.c:378
>  print_report+0x58/0x70 mm/kasan/report.c:482
>  kasan_report+0x117/0x150 mm/kasan/report.c:595
>  ext4_dirent_get_data_len fs/ext4/ext4.h:4156 [inline]
>  ext4_dir_entry_len fs/ext4/ext4.h:4183 [inline]
>  __ext4_check_dir_entry+0x659/0xbe0 fs/ext4/dir.c:96
>  ext4_check_all_de+0x6a/0x140 fs/ext4/dir.c:657
>  ext4_convert_inline_data_nolock+0x1b7/0x980 fs/ext4/inline.c:1121
>  ext4_try_add_inline_entry+0x5cc/0x8a0 fs/ext4/inline.c:1247
>  __ext4_add_entry+0x385/0x3470 fs/ext4/namei.c:2552
>  ext4_add_entry fs/ext4/namei.c:2636 [inline]
>  ext4_mkdir+0x5f3/0xd30 fs/ext4/namei.c:3203
>  vfs_mkdir+0x406/0x620 fs/namei.c:5272
>  filename_mkdirat+0x285/0x510 fs/namei.c:5305
>  __do_sys_mkdirat fs/namei.c:5326 [inline]
>  __se_sys_mkdirat+0x35/0x150 fs/namei.c:5323
>  do_syscall_x64 arch/x86/entry/syscall_64.c:63 [inline]
>  do_syscall_64+0x174/0x580 arch/x86/entry/syscall_64.c:94
>  entry_SYSCALL_64_after_hwframe+0x77/0x7f
> RIP: 0033:0x7fb4c839ce59
> Code: ff c3 66 2e 0f 1f 84 00 00 00 00 00 0f 1f 44 00 00 48 89 f8 48 89 f=
7 48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 ff=
 ff 73 01 c3 48 c7 c1 e8 ff ff ff f7 d8 64 89 01 48
> RSP: 002b:00007ffd4b254a88 EFLAGS: 00000246 ORIG_RAX: 0000000000000102
> RAX: ffffffffffffffda RBX: 00007fb4c8615fa0 RCX: 00007fb4c839ce59
> RDX: 0000000000000037 RSI: 0000200000000380 RDI: 0000000000000004
> RBP: 00007fb4c8432e6f R08: 0000000000000000 R09: 0000000000000000
> R10: 0000000000000000 R11: 0000000000000246 R12: 0000000000000000
> R13: 00007fb4c8615fac R14: 00007fb4c8615fa0 R15: 00007fb4c8615fa0
>  </TASK>
>
> Allocated by task 5056:
>  kasan_save_stack mm/kasan/common.c:57 [inline]
>  kasan_save_track+0x3e/0x80 mm/kasan/common.c:78
>  poison_kmalloc_redzone mm/kasan/common.c:398 [inline]
>  __kasan_kmalloc+0x93/0xb0 mm/kasan/common.c:415
>  kasan_kmalloc include/linux/kasan.h:263 [inline]
>  __kmalloc_cache_noprof+0x318/0x660 mm/slub.c:5451
>  _kmalloc_noprof include/linux/slab.h:969 [inline]
>  _kzalloc_noprof include/linux/slab.h:1286 [inline]
>  kernfs_get_open_node fs/kernfs/file.c:536 [inline]
>  kernfs_fop_open+0x7e6/0xce0 fs/kernfs/file.c:711
>  do_dentry_open+0x816/0x1380 fs/open.c:947
>  vfs_open+0x3b/0x340 fs/open.c:1079
>  do_open fs/namei.c:4700 [inline]
>  path_openat+0x2e44/0x3830 fs/namei.c:4859
>  do_file_open+0x23e/0x4a0 fs/namei.c:4888
>  do_sys_openat2+0x115/0x200 fs/open.c:1395
>  do_sys_open fs/open.c:1401 [inline]
>  __do_sys_openat fs/open.c:1417 [inline]
>  __se_sys_openat fs/open.c:1412 [inline]
>  __x64_sys_openat+0x138/0x170 fs/open.c:1412
>  do_syscall_x64 arch/x86/entry/syscall_64.c:63 [inline]
>  do_syscall_64+0x174/0x580 arch/x86/entry/syscall_64.c:94
>  entry_SYSCALL_64_after_hwframe+0x77/0x7f
>
> The buggy address belongs to the object at ffff88816e86bc00
>  which belongs to the cache kmalloc-128 of size 128
> The buggy address is located 89 bytes to the right of
>  allocated 128-byte region [ffff88816e86bc00, ffff88816e86bc80)
>
> The buggy address belongs to the physical page:
> page: refcount:0 mapcount:0 mapping:0000000000000000 index:0xffff88816e86=
bf00 pfn:0x16e86b
> flags: 0x57ff00000000200(workingset|node=3D1|zone=3D2|lastcpupid=3D0x7ff)
> page_type: f5(slab)
> raw: 057ff00000000200 ffff888100041a00 ffff888160400648 ffff888160400648
> raw: ffff88816e86bf00 000000080010000f 00000000f5000000 0000000000000000
> page dumped because: kasan: bad access detected
> page_owner tracks the page as allocated
> page last allocated via order 0, migratetype Unmovable, gfp_mask 0xd2cc0(=
GFP_KERNEL|__GFP_NOWARN|__GFP_NORETRY|__GFP_COMP|__GFP_NOMEMALLOC), pid 505=
6, tgid 5056 (udevd), ts 53238350188, free_ts 53091667410
>  set_page_owner include/linux/page_owner.h:32 [inline]
>  post_alloc_hook+0x22d/0x280 mm/page_alloc.c:1853
>  prep_new_page mm/page_alloc.c:1861 [inline]
>  get_page_from_freelist+0x24ae/0x2530 mm/page_alloc.c:3941
>  __alloc_frozen_pages_noprof+0x18d/0x380 mm/page_alloc.c:5221
>  alloc_slab_page mm/slub.c:3289 [inline]
>  allocate_slab+0x74/0x5d0 mm/slub.c:3404
>  new_slab mm/slub.c:3447 [inline]
>  refill_objects+0x328/0x3c0 mm/slub.c:7241
>  refill_sheaf mm/slub.c:2827 [inline]
>  __pcs_replace_empty_main+0x2e0/0x6b0 mm/slub.c:4692
>  alloc_from_pcs mm/slub.c:4790 [inline]
>  slab_alloc_node mm/slub.c:4924 [inline]
>  __kmalloc_cache_noprof+0x388/0x660 mm/slub.c:5446
>  _kmalloc_noprof include/linux/slab.h:969 [inline]
>  _kzalloc_noprof include/linux/slab.h:1286 [inline]
>  kernfs_get_open_node fs/kernfs/file.c:536 [inline]
>  kernfs_fop_open+0x7e6/0xce0 fs/kernfs/file.c:711
>  do_dentry_open+0x816/0x1380 fs/open.c:947
>  vfs_open+0x3b/0x340 fs/open.c:1079
>  do_open fs/namei.c:4700 [inline]
>  path_openat+0x2e44/0x3830 fs/namei.c:4859
>  do_file_open+0x23e/0x4a0 fs/namei.c:4888
>  do_sys_openat2+0x115/0x200 fs/open.c:1395
>  do_sys_open fs/open.c:1401 [inline]
>  __do_sys_openat fs/open.c:1417 [inline]
>  __se_sys_openat fs/open.c:1412 [inline]
>  __x64_sys_openat+0x138/0x170 fs/open.c:1412
>  do_syscall_x64 arch/x86/entry/syscall_64.c:63 [inline]
>  do_syscall_64+0x174/0x580 arch/x86/entry/syscall_64.c:94
>  entry_SYSCALL_64_after_hwframe+0x77/0x7f
> page last free pid 23 tgid 23 stack trace:
>  reset_page_owner include/linux/page_owner.h:25 [inline]
>  __free_pages_prepare mm/page_alloc.c:1397 [inline]
>  __free_frozen_pages+0xc0d/0xd20 mm/page_alloc.c:2938
>  __tlb_remove_table_free mm/mmu_gather.c:228 [inline]
>  tlb_remove_table_rcu+0x85/0x100 mm/mmu_gather.c:291
>  rcu_do_batch kernel/rcu/tree.c:2645 [inline]
>  rcu_core+0x78b/0x10a0 kernel/rcu/tree.c:2897
>  handle_softirqs+0x225/0x840 kernel/softirq.c:622
>  run_ksoftirqd+0x36/0x60 kernel/softirq.c:1076
>  smpboot_thread_fn+0x57c/0xa80 kernel/smpboot.c:160
>  kthread+0x388/0x470 kernel/kthread.c:436
>  ret_from_fork+0x514/0xb70 arch/x86/kernel/process.c:158
>  ret_from_fork_asm+0x1a/0x30 arch/x86/entry/entry_64.S:245
>
> Memory state around the buggy address:
>  ffff88816e86bb80: fc fc fc fc fc fc fc fc fc fc fc fc fc fc fc fc
>  ffff88816e86bc00: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
> >ffff88816e86bc80: fc fc fc fc fc fc fc fc fc fc fc fc fc fc fc fc
>                                                     ^
>  ffff88816e86bd00: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
>  ffff88816e86bd80: fc fc fc fc fc fc fc fc fc fc fc fc fc fc fc fc
> =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
>
>
> ***
>
> KASAN: slab-out-of-bounds Read in ext4_inlinedir_to_tree
>
> tree:      torvalds
> URL:       https://kernel.googlesource.com/pub/scm/linux/kernel/git/torva=
lds/linux
> base:      08c7183f5b9ffe4408e74fff848a4cc2105361d4
> arch:      amd64
> compiler:  Debian clang version 22.1.6 (++20260514074242+fc4aad7b5db3-1~e=
xp1~20260514074407.73), Debian LLD 22.1.6
> config:    https://ci.syzbot.org/builds/0efdb868-daeb-4649-9bcb-5af41d993=
e73/config
> syz repro: https://ci.syzbot.org/findings/bb78d414-4cff-400b-aaf6-76d450b=
12cda/syz_repro
>
> =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
> BUG: KASAN: slab-out-of-bounds in ext4_dir_entry_len fs/ext4/ext4.h:4182 =
[inline]
> BUG: KASAN: slab-out-of-bounds in ext4_inlinedir_to_tree+0xd95/0x10a0 fs/=
ext4/inline.c:1335
> Read of size 2 at addr ffff88816f219a3c by task syz.1.18/5830
>
> CPU: 1 UID: 0 PID: 5830 Comm: syz.1.18 Not tainted syzkaller #0 PREEMPT(f=
ull)
> Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS 1.16.2-debian-1.=
16.2-1 04/01/2014
> Call Trace:
>  <TASK>
>  dump_stack_lvl+0xe8/0x150 lib/dump_stack.c:120
>  print_address_description+0x55/0x1e0 mm/kasan/report.c:378
>  print_report+0x58/0x70 mm/kasan/report.c:482
>  kasan_report+0x117/0x150 mm/kasan/report.c:595
>  ext4_dir_entry_len fs/ext4/ext4.h:4182 [inline]
>  ext4_inlinedir_to_tree+0xd95/0x10a0 fs/ext4/inline.c:1335
>  ext4_htree_fill_tree+0x4c9/0x2480 fs/ext4/namei.c:1195
>  ext4_dx_readdir fs/ext4/dir.c:600 [inline]
>  ext4_readdir+0x2e2a/0x3720 fs/ext4/dir.c:146
>  iterate_dir+0x2e2/0x4d0 fs/readdir.c:110
>  __do_sys_getdents fs/readdir.c:319 [inline]
>  __se_sys_getdents+0xf1/0x270 fs/readdir.c:304
>  do_syscall_x64 arch/x86/entry/syscall_64.c:63 [inline]
>  do_syscall_64+0x174/0x580 arch/x86/entry/syscall_64.c:94
>  entry_SYSCALL_64_after_hwframe+0x77/0x7f
> RIP: 0033:0x7fe51459ce59
> Code: ff c3 66 2e 0f 1f 84 00 00 00 00 00 0f 1f 44 00 00 48 89 f8 48 89 f=
7 48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 ff=
 ff 73 01 c3 48 c7 c1 e8 ff ff ff f7 d8 64 89 01 48
> RSP: 002b:00007fe515527028 EFLAGS: 00000246 ORIG_RAX: 000000000000004e
> RAX: ffffffffffffffda RBX: 00007fe514815fa0 RCX: 00007fe51459ce59
> RDX: 0000000000000000 RSI: 0000000000000000 RDI: 0000000000000006
> RBP: 00007fe514632e6f R08: 0000000000000000 R09: 0000000000000000
> R10: 0000000000000000 R11: 0000000000000246 R12: 0000000000000000
> R13: 00007fe514816038 R14: 00007fe514815fa0 R15: 00007fffd9b381d8
>  </TASK>
>
> Allocated by task 5830:
>  kasan_save_stack mm/kasan/common.c:57 [inline]
>  kasan_save_track+0x3e/0x80 mm/kasan/common.c:78
>  poison_kmalloc_redzone mm/kasan/common.c:398 [inline]
>  __kasan_kmalloc+0x93/0xb0 mm/kasan/common.c:415
>  kasan_kmalloc include/linux/kasan.h:263 [inline]
>  __do_kmalloc_node mm/slub.c:5334 [inline]
>  __kmalloc_noprof+0x358/0x750 mm/slub.c:5347
>  _kmalloc_noprof include/linux/slab.h:973 [inline]
>  ext4_inlinedir_to_tree+0x2ec/0x10a0 fs/ext4/inline.c:1292
>  ext4_htree_fill_tree+0x4c9/0x2480 fs/ext4/namei.c:1195
>  ext4_dx_readdir fs/ext4/dir.c:600 [inline]
>  ext4_readdir+0x2e2a/0x3720 fs/ext4/dir.c:146
>  iterate_dir+0x2e2/0x4d0 fs/readdir.c:110
>  __do_sys_getdents fs/readdir.c:319 [inline]
>  __se_sys_getdents+0xf1/0x270 fs/readdir.c:304
>  do_syscall_x64 arch/x86/entry/syscall_64.c:63 [inline]
>  do_syscall_64+0x174/0x580 arch/x86/entry/syscall_64.c:94
>  entry_SYSCALL_64_after_hwframe+0x77/0x7f
>
> The buggy address belongs to the object at ffff88816f219a00
>  which belongs to the cache kmalloc-64 of size 64
> The buggy address is located 0 bytes to the right of
>  allocated 60-byte region [ffff88816f219a00, ffff88816f219a3c)
>
> The buggy address belongs to the physical page:
> page: refcount:0 mapcount:0 mapping:0000000000000000 index:0x0 pfn:0x16f2=
19
> flags: 0x57ff00000000000(node=3D1|zone=3D2|lastcpupid=3D0x7ff)
> page_type: f5(slab)
> raw: 057ff00000000000 ffff8881000418c0 dead000000000100 dead000000000122
> raw: 0000000000000000 0000000800200020 00000000f5000000 0000000000000000
> page dumped because: kasan: bad access detected
> page_owner tracks the page as allocated
> page last allocated via order 0, migratetype Unmovable, gfp_mask 0xd2cc0(=
GFP_KERNEL|__GFP_NOWARN|__GFP_NORETRY|__GFP_COMP|__GFP_NOMEMALLOC), pid 1, =
tgid 1 (swapper/0), ts 10138712683, free_ts 10137977139
>  set_page_owner include/linux/page_owner.h:32 [inline]
>  post_alloc_hook+0x22d/0x280 mm/page_alloc.c:1853
>  prep_new_page mm/page_alloc.c:1861 [inline]
>  get_page_from_freelist+0x24ae/0x2530 mm/page_alloc.c:3941
>  __alloc_frozen_pages_noprof+0x18d/0x380 mm/page_alloc.c:5221
>  alloc_slab_page mm/slub.c:3289 [inline]
>  allocate_slab+0x74/0x5d0 mm/slub.c:3404
>  new_slab mm/slub.c:3447 [inline]
>  refill_objects+0x328/0x3c0 mm/slub.c:7241
>  refill_sheaf mm/slub.c:2827 [inline]
>  __pcs_replace_empty_main+0x2e0/0x6b0 mm/slub.c:4692
>  alloc_from_pcs mm/slub.c:4790 [inline]
>  slab_alloc_node mm/slub.c:4924 [inline]
>  __do_kmalloc_node mm/slub.c:5333 [inline]
>  __kmalloc_noprof+0x464/0x750 mm/slub.c:5347
>  _kmalloc_noprof include/linux/slab.h:973 [inline]
>  _kzalloc_noprof include/linux/slab.h:1286 [inline]
>  kobject_get_path+0xc5/0x2f0 lib/kobject.c:161
>  kobject_uevent_env+0x29e/0x9e0 lib/kobject_uevent.c:548
>  device_add+0x544/0xb80 drivers/base/core.c:3738
>  scsi_add_host_with_dma+0x5db/0xd00 drivers/scsi/hosts.c:287
>  ata_scsi_add_hosts+0x29b/0x4b0 drivers/ata/libata-scsi.c:4659
>  ata_host_register+0x1c5/0x7d0 drivers/ata/libata-core.c:6131
>  ata_host_activate+0x33c/0x3c0 drivers/ata/libata-core.c:6234
>  ahci_init_one+0x1afa/0x22b0 drivers/ata/ahci.c:3090
>  local_pci_probe drivers/pci/pci-driver.c:332 [inline]
>  pci_call_probe drivers/pci/pci-driver.c:394 [inline]
>  __pci_device_probe drivers/pci/pci-driver.c:455 [inline]
>  pci_device_probe+0x431/0xc90 drivers/pci/pci-driver.c:489
> page last free pid 36 tgid 36 stack trace:
>  reset_page_owner include/linux/page_owner.h:25 [inline]
>  __free_pages_prepare mm/page_alloc.c:1397 [inline]
>  __free_frozen_pages+0xc0d/0xd20 mm/page_alloc.c:2938
>  __kasan_populate_vmalloc_do mm/kasan/shadow.c:393 [inline]
>  __kasan_populate_vmalloc+0x1a8/0x1c0 mm/kasan/shadow.c:424
>  kasan_populate_vmalloc include/linux/kasan.h:580 [inline]
>  alloc_vmap_area+0xd1a/0x1420 mm/vmalloc.c:2123
>  __get_vm_area_node+0x1f2/0x300 mm/vmalloc.c:3226
>  __vmalloc_node_range_noprof+0x358/0x1730 mm/vmalloc.c:4024
>  __vmalloc_node_noprof+0xc2/0x100 mm/vmalloc.c:4124
>  alloc_thread_stack_node kernel/fork.c:358 [inline]
>  dup_task_struct+0x28e/0x850 kernel/fork.c:928
>  copy_process+0x81b/0x42e0 kernel/fork.c:2109
>  kernel_clone+0x2d7/0x940 kernel/fork.c:2745
>  user_mode_thread+0x110/0x180 kernel/fork.c:2821
>  call_usermodehelper_exec_work+0x5c/0x230 kernel/umh.c:171
>  process_one_work kernel/workqueue.c:3322 [inline]
>  process_scheduled_works+0xa8e/0x14e0 kernel/workqueue.c:3405
>  worker_thread+0xa47/0xfb0 kernel/workqueue.c:3486
>  kthread+0x388/0x470 kernel/kthread.c:436
>  ret_from_fork+0x514/0xb70 arch/x86/kernel/process.c:158
>  ret_from_fork_asm+0x1a/0x30 arch/x86/entry/entry_64.S:245
>
> Memory state around the buggy address:
>  ffff88816f219900: 00 00 00 00 00 00 00 00 fc fc fc fc fc fc fc fc
>  ffff88816f219980: fa fb fb fb fb fb fb fb fc fc fc fc fc fc fc fc
> >ffff88816f219a00: 00 00 00 00 00 00 00 04 fc fc fc fc fc fc fc fc
>                                         ^
>  ffff88816f219a80: fa fb fb fb fb fb fb fb fc fc fc fc fc fc fc fc
>  ffff88816f219b00: fa fb fb fb fb fb fb fb fc fc fc fc fc fc fc fc
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
> base:      08c7183f5b9ffe4408e74fff848a4cc2105361d4
> arch:      amd64
> compiler:  Debian clang version 22.1.6 (++20260514074242+fc4aad7b5db3-1~e=
xp1~20260514074407.73), Debian LLD 22.1.6
> config:    https://ci.syzbot.org/builds/0efdb868-daeb-4649-9bcb-5af41d993=
e73/config
> syz repro: https://ci.syzbot.org/findings/f322e293-7a3f-469a-ae1f-677c84e=
b4c0f/syz_repro
>
> =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
> BUG: KASAN: slab-use-after-free in ext4_dirent_get_data_len fs/ext4/ext4.=
h:4156 [inline]
> BUG: KASAN: slab-use-after-free in ext4_dir_entry_len fs/ext4/ext4.h:4183=
 [inline]
> BUG: KASAN: slab-use-after-free in __ext4_check_dir_entry+0x659/0xbe0 fs/=
ext4/dir.c:96
> Read of size 1 at addr ffff888103e89c1d by task syz.2.19/5867
>
> CPU: 0 UID: 0 PID: 5867 Comm: syz.2.19 Not tainted syzkaller #0 PREEMPT(f=
ull)
> Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS 1.16.2-debian-1.=
16.2-1 04/01/2014
> Call Trace:
>  <TASK>
>  dump_stack_lvl+0xe8/0x150 lib/dump_stack.c:120
>  print_address_description+0x55/0x1e0 mm/kasan/report.c:378
>  print_report+0x58/0x70 mm/kasan/report.c:482
>  kasan_report+0x117/0x150 mm/kasan/report.c:595
>  ext4_dirent_get_data_len fs/ext4/ext4.h:4156 [inline]
>  ext4_dir_entry_len fs/ext4/ext4.h:4183 [inline]
>  __ext4_check_dir_entry+0x659/0xbe0 fs/ext4/dir.c:96
>  ext4_check_all_de+0x6a/0x140 fs/ext4/dir.c:657
>  ext4_convert_inline_data_nolock+0x1b7/0x980 fs/ext4/inline.c:1121
>  ext4_try_add_inline_entry+0x5cc/0x8a0 fs/ext4/inline.c:1247
>  __ext4_add_entry+0x385/0x3470 fs/ext4/namei.c:2552
>  ext4_add_entry fs/ext4/namei.c:2636 [inline]
>  ext4_mkdir+0x5f3/0xd30 fs/ext4/namei.c:3203
>  vfs_mkdir+0x406/0x620 fs/namei.c:5272
>  filename_mkdirat+0x285/0x510 fs/namei.c:5305
>  __do_sys_mkdirat fs/namei.c:5326 [inline]
>  __se_sys_mkdirat+0x35/0x150 fs/namei.c:5323
>  do_syscall_x64 arch/x86/entry/syscall_64.c:63 [inline]
>  do_syscall_64+0x174/0x580 arch/x86/entry/syscall_64.c:94
>  entry_SYSCALL_64_after_hwframe+0x77/0x7f
> RIP: 0033:0x7fb01d39ce59
> Code: ff c3 66 2e 0f 1f 84 00 00 00 00 00 0f 1f 44 00 00 48 89 f8 48 89 f=
7 48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 ff=
 ff 73 01 c3 48 c7 c1 e8 ff ff ff f7 d8 64 89 01 48
> RSP: 002b:00007fb01e269028 EFLAGS: 00000246 ORIG_RAX: 0000000000000102
> RAX: ffffffffffffffda RBX: 00007fb01d615fa0 RCX: 00007fb01d39ce59
> RDX: 0000000000000037 RSI: 0000200000000380 RDI: 0000000000000004
> RBP: 00007fb01d432e6f R08: 0000000000000000 R09: 0000000000000000
> R10: 0000000000000000 R11: 0000000000000246 R12: 0000000000000000
> R13: 00007fb01d616038 R14: 00007fb01d615fa0 R15: 00007ffdec822cc8
>  </TASK>
>
> Allocated by task 5630:
>  kasan_save_stack mm/kasan/common.c:57 [inline]
>  kasan_save_track+0x3e/0x80 mm/kasan/common.c:78
>  poison_kmalloc_redzone mm/kasan/common.c:398 [inline]
>  __kasan_kmalloc+0x93/0xb0 mm/kasan/common.c:415
>  kasan_kmalloc include/linux/kasan.h:263 [inline]
>  __kmalloc_cache_noprof+0x318/0x660 mm/slub.c:5451
>  _kmalloc_noprof include/linux/slab.h:969 [inline]
>  __hw_addr_create+0x62/0x240 net/core/dev_addr_lists.c:69
>  __hw_addr_add_ex+0x1ce/0x520 net/core/dev_addr_lists.c:127
>  __hw_addr_add net/core/dev_addr_lists.c:144 [inline]
>  dev_addr_init+0x15a/0x240 net/core/dev_addr_lists.c:696
>  alloc_netdev_mqs+0x2b4/0x1270 net/core/dev.c:12064
>  __ip_tunnel_create+0x348/0x560 net/ipv4/ip_tunnel.c:255
>  ip_tunnel_init_net+0x2ea/0x810 net/ipv4/ip_tunnel.c:1150
>  ops_init+0x35d/0x5d0 net/core/net_namespace.c:137
>  setup_net+0x118/0x350 net/core/net_namespace.c:446
>  copy_net_ns+0x4f9/0x720 net/core/net_namespace.c:579
>  create_new_namespaces+0x3f0/0x6b0 kernel/nsproxy.c:132
>  unshare_nsproxy_namespaces+0x149/0x190 kernel/nsproxy.c:234
>  ksys_unshare+0x57d/0xa00 kernel/fork.c:3266
>  __do_sys_unshare kernel/fork.c:3340 [inline]
>  __se_sys_unshare kernel/fork.c:3338 [inline]
>  __x64_sys_unshare+0x38/0x50 kernel/fork.c:3338
>  do_syscall_x64 arch/x86/entry/syscall_64.c:63 [inline]
>  do_syscall_64+0x174/0x580 arch/x86/entry/syscall_64.c:94
>  entry_SYSCALL_64_after_hwframe+0x77/0x7f
>
> Freed by task 68:
>  kasan_save_stack mm/kasan/common.c:57 [inline]
>  kasan_save_track+0x3e/0x80 mm/kasan/common.c:78
>  kasan_save_free_info+0x40/0x50 mm/kasan/generic.c:584
>  poison_slab_object mm/kasan/common.c:253 [inline]
>  __kasan_slab_free+0x5c/0x80 mm/kasan/common.c:285
>  kasan_slab_free include/linux/kasan.h:235 [inline]
>  slab_free_hook mm/slub.c:2700 [inline]
>  slab_free_freelist_hook mm/slub.c:2729 [inline]
>  slab_free_bulk mm/slub.c:6344 [inline]
>  kmem_cache_free_bulk+0x30f/0x1180 mm/slub.c:7076
>  kfree_bulk include/linux/slab.h:891 [inline]
>  kvfree_rcu_bulk+0xc6/0x190 mm/slab_common.c:1502
>  kvfree_rcu_drain_ready mm/slab_common.c:1704 [inline]
>  kfree_rcu_monitor+0x21a/0x2b0 mm/slab_common.c:1777
>  process_one_work kernel/workqueue.c:3322 [inline]
>  process_scheduled_works+0xa8e/0x14e0 kernel/workqueue.c:3405
>  worker_thread+0xa47/0xfb0 kernel/workqueue.c:3486
>  kthread+0x388/0x470 kernel/kthread.c:436
>  ret_from_fork+0x514/0xb70 arch/x86/kernel/process.c:158
>  ret_from_fork_asm+0x1a/0x30 arch/x86/entry/entry_64.S:245
>
> Last potentially related work creation:
>  kasan_save_stack+0x3e/0x60 mm/kasan/common.c:57
>  kasan_record_aux_stack+0xbd/0xd0 mm/kasan/generic.c:556
>  kvfree_call_rcu+0x100/0x430 mm/slab_common.c:1970
>  __hw_addr_flush net/core/dev_addr_lists.c:500 [inline]
>  dev_addr_flush+0x16c/0x210 net/core/dev_addr_lists.c:673
>  free_netdev+0x26c/0x6e0 net/core/dev.c:12209
>  netdev_run_todo+0xf3d/0x10d0 net/core/dev.c:11743
>  ops_exit_rtnl_list net/core/net_namespace.c:189 [inline]
>  ops_undo_list+0x396/0x8d0 net/core/net_namespace.c:248
>  cleanup_net+0x572/0x810 net/core/net_namespace.c:702
>  process_one_work kernel/workqueue.c:3322 [inline]
>  process_scheduled_works+0xa8e/0x14e0 kernel/workqueue.c:3405
>  worker_thread+0xa47/0xfb0 kernel/workqueue.c:3486
>  kthread+0x388/0x470 kernel/kthread.c:436
>  ret_from_fork+0x514/0xb70 arch/x86/kernel/process.c:158
>  ret_from_fork_asm+0x1a/0x30 arch/x86/entry/entry_64.S:245
>
> The buggy address belongs to the object at ffff888103e89c00
>  which belongs to the cache kmalloc-128 of size 128
> The buggy address is located 29 bytes inside of
>  freed 128-byte region [ffff888103e89c00, ffff888103e89c80)
>
> The buggy address belongs to the physical page:
> page: refcount:0 mapcount:0 mapping:0000000000000000 index:0x0 pfn:0x103e=
89
> flags: 0x17ff00000000000(node=3D0|zone=3D2|lastcpupid=3D0x7ff)
> page_type: f5(slab)
> raw: 017ff00000000000 ffff888100041a00 dead000000000100 dead000000000122
> raw: 0000000000000000 0000000800100010 00000000f5000000 0000000000000000
> page dumped because: kasan: bad access detected
> page_owner tracks the page as allocated
> page last allocated via order 0, migratetype Unmovable, gfp_mask 0xd2cc0(=
GFP_KERNEL|__GFP_NOWARN|__GFP_NORETRY|__GFP_COMP|__GFP_NOMEMALLOC), pid 1, =
tgid 1 (swapper/0), ts 2773920656, free_ts 0
>  set_page_owner include/linux/page_owner.h:32 [inline]
>  post_alloc_hook+0x22d/0x280 mm/page_alloc.c:1853
>  prep_new_page mm/page_alloc.c:1861 [inline]
>  get_page_from_freelist+0x24ae/0x2530 mm/page_alloc.c:3941
>  __alloc_frozen_pages_noprof+0x18d/0x380 mm/page_alloc.c:5221
>  alloc_slab_page mm/slub.c:3289 [inline]
>  allocate_slab+0x74/0x5d0 mm/slub.c:3404
>  new_slab mm/slub.c:3447 [inline]
>  refill_objects+0x328/0x3c0 mm/slub.c:7241
>  refill_sheaf mm/slub.c:2827 [inline]
>  __pcs_replace_empty_main+0x2e0/0x6b0 mm/slub.c:4692
>  alloc_from_pcs mm/slub.c:4790 [inline]
>  slab_alloc_node mm/slub.c:4924 [inline]
>  __do_kmalloc_node mm/slub.c:5333 [inline]
>  __kmalloc_noprof+0x464/0x750 mm/slub.c:5347
>  _kmalloc_noprof include/linux/slab.h:973 [inline]
>  _kzalloc_noprof include/linux/slab.h:1286 [inline]
>  __alloc_empty_sheaf+0x24/0x40 mm/slub.c:2774
>  alloc_empty_sheaf mm/slub.c:2794 [inline]
>  __pcs_replace_empty_main+0x447/0x6b0 mm/slub.c:4687
>  alloc_from_pcs mm/slub.c:4790 [inline]
>  slab_alloc_node mm/slub.c:4924 [inline]
>  kmem_cache_alloc_lru_noprof+0x372/0x640 mm/slub.c:4958
>  alloc_inode+0x6a/0x1b0 fs/inode.c:341
>  new_inode+0x1f/0x170 fs/inode.c:1177
>  debugfs_get_inode fs/debugfs/inode.c:72 [inline]
>  debugfs_create_dir+0x68/0x350 fs/debugfs/inode.c:578
>  blk_dev_init+0xdf/0x150 block/blk-core.c:1333
>  genhd_device_init+0x1c/0x50 block/genhd.c:1002
>  do_one_initcall+0x250/0x870 init/main.c:1347
> page_owner free stack trace missing
>
> Memory state around the buggy address:
>  ffff888103e89b00: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
>  ffff888103e89b80: fc fc fc fc fc fc fc fc fc fc fc fc fc fc fc fc
> >ffff888103e89c00: fa fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb
>                             ^
>  ffff888103e89c80: fc fc fc fc fc fc fc fc fc fc fc fc fc fc fc fc
>  ffff888103e89d00: fa fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb
> =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
>
>
> ***
>
> KASAN: slab-use-after-free Read in ext4_inlinedir_to_tree
>
> tree:      torvalds
> URL:       https://kernel.googlesource.com/pub/scm/linux/kernel/git/torva=
lds/linux
> base:      08c7183f5b9ffe4408e74fff848a4cc2105361d4
> arch:      amd64
> compiler:  Debian clang version 22.1.6 (++20260514074242+fc4aad7b5db3-1~e=
xp1~20260514074407.73), Debian LLD 22.1.6
> config:    https://ci.syzbot.org/builds/0efdb868-daeb-4649-9bcb-5af41d993=
e73/config
> syz repro: https://ci.syzbot.org/findings/b1e2a550-a6c3-410a-ae53-ca1e536=
6cc94/syz_repro
>
> loop0: lost filesystem error report for type 5 error -117
> EXT4-fs (loop0): mounted filesystem 00000000-0000-0000-0000-000000000000 =
r/w without journal. Quota mode: none.
> =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
> BUG: KASAN: slab-use-after-free in ext4_dirent_get_data_len fs/ext4/ext4.=
h:4156 [inline]
> BUG: KASAN: slab-use-after-free in ext4_dir_entry_len fs/ext4/ext4.h:4183=
 [inline]
> BUG: KASAN: slab-use-after-free in ext4_inlinedir_to_tree+0x8f0/0x10a0 fs=
/ext4/inline.c:1335
> Read of size 1 at addr ffff888111d0149d by task syz.0.19/5801
>
> CPU: 1 UID: 0 PID: 5801 Comm: syz.0.19 Not tainted syzkaller #0 PREEMPT(f=
ull)
> Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS 1.16.2-debian-1.=
16.2-1 04/01/2014
> Call Trace:
>  <TASK>
>  dump_stack_lvl+0xe8/0x150 lib/dump_stack.c:120
>  print_address_description+0x55/0x1e0 mm/kasan/report.c:378
>  print_report+0x58/0x70 mm/kasan/report.c:482
>  kasan_report+0x117/0x150 mm/kasan/report.c:595
>  ext4_dirent_get_data_len fs/ext4/ext4.h:4156 [inline]
>  ext4_dir_entry_len fs/ext4/ext4.h:4183 [inline]
>  ext4_inlinedir_to_tree+0x8f0/0x10a0 fs/ext4/inline.c:1335
>  ext4_htree_fill_tree+0x4c9/0x2480 fs/ext4/namei.c:1195
>  ext4_dx_readdir fs/ext4/dir.c:600 [inline]
>  ext4_readdir+0x2e2a/0x3720 fs/ext4/dir.c:146
>  iterate_dir+0x2e2/0x4d0 fs/readdir.c:110
>  __do_sys_getdents fs/readdir.c:319 [inline]
>  __se_sys_getdents+0xf1/0x270 fs/readdir.c:304
>  do_syscall_x64 arch/x86/entry/syscall_64.c:63 [inline]
>  do_syscall_64+0x174/0x580 arch/x86/entry/syscall_64.c:94
>  entry_SYSCALL_64_after_hwframe+0x77/0x7f
> RIP: 0033:0x7f6e8459ce59
> Code: ff c3 66 2e 0f 1f 84 00 00 00 00 00 0f 1f 44 00 00 48 89 f8 48 89 f=
7 48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 ff=
 ff 73 01 c3 48 c7 c1 e8 ff ff ff f7 d8 64 89 01 48
> RSP: 002b:00007ffef0bce788 EFLAGS: 00000246 ORIG_RAX: 000000000000004e
> RAX: ffffffffffffffda RBX: 00007f6e84815fa0 RCX: 00007f6e8459ce59
> RDX: 0000000000000000 RSI: 0000000000000000 RDI: 0000000000000004
> RBP: 00007f6e84632e6f R08: 0000000000000000 R09: 0000000000000000
> R10: 0000000000000000 R11: 0000000000000246 R12: 0000000000000000
> R13: 00007f6e84815fac R14: 00007f6e84815fa0 R15: 00007f6e84815fa0
>  </TASK>
>
> Allocated by task 5738:
>  kasan_save_stack mm/kasan/common.c:57 [inline]
>  kasan_save_track+0x3e/0x80 mm/kasan/common.c:78
>  poison_kmalloc_redzone mm/kasan/common.c:398 [inline]
>  __kasan_kmalloc+0x93/0xb0 mm/kasan/common.c:415
>  kasan_kmalloc include/linux/kasan.h:263 [inline]
>  __kmalloc_cache_noprof+0x318/0x660 mm/slub.c:5451
>  _kmalloc_noprof include/linux/slab.h:969 [inline]
>  __kthread_create_on_node+0x115/0x3d0 kernel/kthread.c:483
>  kthread_create_on_node+0xeb/0x140 kernel/kthread.c:559
>  napi_kthread_create net/core/dev.c:1656 [inline]
>  netif_napi_add_weight_locked+0x699/0x940 net/core/dev.c:7594
>  netif_napi_add_weight include/linux/netdevice.h:2870 [inline]
>  netif_napi_add include/linux/netdevice.h:2887 [inline]
>  wg_peer_create+0x52d/0x860 drivers/net/wireguard/peer.c:57
>  set_peer drivers/net/wireguard/netlink.c:392 [inline]
>  wg_set_device_doit+0xf3a/0x2120 drivers/net/wireguard/netlink.c:569
>  genl_family_rcv_msg_doit+0x233/0x340 net/netlink/genetlink.c:1114
>  genl_family_rcv_msg net/netlink/genetlink.c:1194 [inline]
>  genl_rcv_msg+0x614/0x7a0 net/netlink/genetlink.c:1209
>  netlink_rcv_skb+0x226/0x4a0 net/netlink/af_netlink.c:2556
>  genl_rcv+0x28/0x40 net/netlink/genetlink.c:1218
>  netlink_unicast_kernel net/netlink/af_netlink.c:1319 [inline]
>  netlink_unicast+0x7bb/0x940 net/netlink/af_netlink.c:1345
>  netlink_sendmsg+0x813/0xb40 net/netlink/af_netlink.c:1900
>  sock_sendmsg_nosec+0x13a/0x180 net/socket.c:775
>  __sock_sendmsg net/socket.c:790 [inline]
>  __sys_sendto+0x408/0x5a0 net/socket.c:2252
>  __do_sys_sendto net/socket.c:2259 [inline]
>  __se_sys_sendto net/socket.c:2255 [inline]
>  __x64_sys_sendto+0xde/0x100 net/socket.c:2255
>  do_syscall_x64 arch/x86/entry/syscall_64.c:63 [inline]
>  do_syscall_64+0x174/0x580 arch/x86/entry/syscall_64.c:94
>  entry_SYSCALL_64_after_hwframe+0x77/0x7f
>
> Freed by task 5738:
>  kasan_save_stack mm/kasan/common.c:57 [inline]
>  kasan_save_track+0x3e/0x80 mm/kasan/common.c:78
>  kasan_save_free_info+0x40/0x50 mm/kasan/generic.c:584
>  poison_slab_object mm/kasan/common.c:253 [inline]
>  __kasan_slab_free+0x5c/0x80 mm/kasan/common.c:285
>  kasan_slab_free include/linux/kasan.h:235 [inline]
>  slab_free_hook mm/slub.c:2700 [inline]
>  slab_free mm/slub.c:6310 [inline]
>  kfree+0x1c5/0x640 mm/slub.c:6625
>  __kthread_create_on_node+0x2fe/0x3d0 kernel/kthread.c:523
>  kthread_create_on_node+0xeb/0x140 kernel/kthread.c:559
>  napi_kthread_create net/core/dev.c:1656 [inline]
>  netif_napi_add_weight_locked+0x699/0x940 net/core/dev.c:7594
>  netif_napi_add_weight include/linux/netdevice.h:2870 [inline]
>  netif_napi_add include/linux/netdevice.h:2887 [inline]
>  wg_peer_create+0x52d/0x860 drivers/net/wireguard/peer.c:57
>  set_peer drivers/net/wireguard/netlink.c:392 [inline]
>  wg_set_device_doit+0xf3a/0x2120 drivers/net/wireguard/netlink.c:569
>  genl_family_rcv_msg_doit+0x233/0x340 net/netlink/genetlink.c:1114
>  genl_family_rcv_msg net/netlink/genetlink.c:1194 [inline]
>  genl_rcv_msg+0x614/0x7a0 net/netlink/genetlink.c:1209
>  netlink_rcv_skb+0x226/0x4a0 net/netlink/af_netlink.c:2556
>  genl_rcv+0x28/0x40 net/netlink/genetlink.c:1218
>  netlink_unicast_kernel net/netlink/af_netlink.c:1319 [inline]
>  netlink_unicast+0x7bb/0x940 net/netlink/af_netlink.c:1345
>  netlink_sendmsg+0x813/0xb40 net/netlink/af_netlink.c:1900
>  sock_sendmsg_nosec+0x13a/0x180 net/socket.c:775
>  __sock_sendmsg net/socket.c:790 [inline]
>  __sys_sendto+0x408/0x5a0 net/socket.c:2252
>  __do_sys_sendto net/socket.c:2259 [inline]
>  __se_sys_sendto net/socket.c:2255 [inline]
>  __x64_sys_sendto+0xde/0x100 net/socket.c:2255
>  do_syscall_x64 arch/x86/entry/syscall_64.c:63 [inline]
>  do_syscall_64+0x174/0x580 arch/x86/entry/syscall_64.c:94
>  entry_SYSCALL_64_after_hwframe+0x77/0x7f
>
> The buggy address belongs to the object at ffff888111d01480
>  which belongs to the cache kmalloc-64 of size 64
> The buggy address is located 29 bytes inside of
>  freed 64-byte region [ffff888111d01480, ffff888111d014c0)
>
> The buggy address belongs to the physical page:
> page: refcount:0 mapcount:0 mapping:0000000000000000 index:0x0 pfn:0x111d=
01
> flags: 0x17ff00000000000(node=3D0|zone=3D2|lastcpupid=3D0x7ff)
> page_type: f5(slab)
> raw: 017ff00000000000 ffff8881000418c0 dead000000000100 dead000000000122
> raw: 0000000000000000 0000000800200020 00000000f5000000 0000000000000000
> page dumped because: kasan: bad access detected
> page_owner tracks the page as allocated
> page last allocated via order 0, migratetype Unmovable, gfp_mask 0xd2cc0(=
GFP_KERNEL|__GFP_NOWARN|__GFP_NORETRY|__GFP_COMP|__GFP_NOMEMALLOC), pid 111=
3, tgid 1113 (kworker/u9:4), ts 18841797934, free_ts 18841792693
>  set_page_owner include/linux/page_owner.h:32 [inline]
>  post_alloc_hook+0x22d/0x280 mm/page_alloc.c:1853
>  prep_new_page mm/page_alloc.c:1861 [inline]
>  get_page_from_freelist+0x24ae/0x2530 mm/page_alloc.c:3941
>  __alloc_frozen_pages_noprof+0x18d/0x380 mm/page_alloc.c:5221
>  alloc_slab_page mm/slub.c:3289 [inline]
>  allocate_slab+0x74/0x5d0 mm/slub.c:3404
>  new_slab mm/slub.c:3447 [inline]
>  refill_objects+0x328/0x3c0 mm/slub.c:7241
>  refill_sheaf mm/slub.c:2827 [inline]
>  __pcs_replace_empty_main+0x2e0/0x6b0 mm/slub.c:4692
>  alloc_from_pcs mm/slub.c:4790 [inline]
>  slab_alloc_node mm/slub.c:4924 [inline]
>  __do_kmalloc_node mm/slub.c:5333 [inline]
>  __kmalloc_node_noprof+0x56a/0x7b0 mm/slub.c:5340
>  _kmalloc_node_noprof include/linux/slab.h:1174 [inline]
>  __vmalloc_area_node mm/vmalloc.c:3857 [inline]
>  __vmalloc_node_range_noprof+0x5d9/0x1730 mm/vmalloc.c:4064
>  __vmalloc_node_noprof+0xc2/0x100 mm/vmalloc.c:4124
>  alloc_thread_stack_node kernel/fork.c:358 [inline]
>  dup_task_struct+0x28e/0x850 kernel/fork.c:928
>  copy_process+0x81b/0x42e0 kernel/fork.c:2109
>  kernel_clone+0x2d7/0x940 kernel/fork.c:2745
>  user_mode_thread+0x110/0x180 kernel/fork.c:2821
>  call_usermodehelper_exec_work+0x5c/0x230 kernel/umh.c:171
>  process_one_work kernel/workqueue.c:3322 [inline]
>  process_scheduled_works+0xa8e/0x14e0 kernel/workqueue.c:3405
>  worker_thread+0xa47/0xfb0 kernel/workqueue.c:3486
> page last free pid 1113 tgid 1113 stack trace:
>  reset_page_owner include/linux/page_owner.h:25 [inline]
>  __free_pages_prepare mm/page_alloc.c:1397 [inline]
>  __free_frozen_pages+0xc0d/0xd20 mm/page_alloc.c:2938
>  __kasan_populate_vmalloc_do mm/kasan/shadow.c:393 [inline]
>  __kasan_populate_vmalloc+0x1a8/0x1c0 mm/kasan/shadow.c:424
>  kasan_populate_vmalloc include/linux/kasan.h:580 [inline]
>  alloc_vmap_area+0xd1a/0x1420 mm/vmalloc.c:2123
>  __get_vm_area_node+0x1f2/0x300 mm/vmalloc.c:3226
>  __vmalloc_node_range_noprof+0x358/0x1730 mm/vmalloc.c:4024
>  __vmalloc_node_noprof+0xc2/0x100 mm/vmalloc.c:4124
>  alloc_thread_stack_node kernel/fork.c:358 [inline]
>  dup_task_struct+0x28e/0x850 kernel/fork.c:928
>  copy_process+0x81b/0x42e0 kernel/fork.c:2109
>  kernel_clone+0x2d7/0x940 kernel/fork.c:2745
>  user_mode_thread+0x110/0x180 kernel/fork.c:2821
>  call_usermodehelper_exec_work+0x5c/0x230 kernel/umh.c:171
>  process_one_work kernel/workqueue.c:3322 [inline]
>  process_scheduled_works+0xa8e/0x14e0 kernel/workqueue.c:3405
>  worker_thread+0xa47/0xfb0 kernel/workqueue.c:3486
>  kthread+0x388/0x470 kernel/kthread.c:436
>  ret_from_fork+0x514/0xb70 arch/x86/kernel/process.c:158
>  ret_from_fork_asm+0x1a/0x30 arch/x86/entry/entry_64.S:245
>
> Memory state around the buggy address:
>  ffff888111d01380: 00 00 00 00 00 00 00 04 fc fc fc fc fc fc fc fc
>  ffff888111d01400: fa fb fb fb fb fb fb fb fc fc fc fc fc fc fc fc
> >ffff888111d01480: fa fb fb fb fb fb fb fb fc fc fc fc fc fc fc fc
>                             ^
>  ffff888111d01500: 00 00 00 00 00 00 02 fc fc fc fc fc fc fc fc fc
>  ffff888111d01580: fa fb fb fb fb fb fb fb fc fc fc fc fc fc fc fc
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
> base:      08c7183f5b9ffe4408e74fff848a4cc2105361d4
> arch:      amd64
> compiler:  Debian clang version 22.1.6 (++20260514074242+fc4aad7b5db3-1~e=
xp1~20260514074407.73), Debian LLD 22.1.6
> config:    https://ci.syzbot.org/builds/0efdb868-daeb-4649-9bcb-5af41d993=
e73/config
> syz repro: https://ci.syzbot.org/findings/07c4f835-36f6-4535-a165-aa25c5a=
f571c/syz_repro
>
> EXT4-fs error (device loop2): ext4_inlinedir_to_tree:1343: inode #21: blo=
ck 10: comm syz.2.19: path /: bad entry in directory: directory entry overr=
un - offset=3D20, inode=3D0, rec_len=3D1024, size=3D60 fake=3D0
> =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
> BUG: KASAN: use-after-free in ext4_dirent_get_data_len fs/ext4/ext4.h:415=
6 [inline]
> BUG: KASAN: use-after-free in ext4_dir_entry_len fs/ext4/ext4.h:4183 [inl=
ine]
> BUG: KASAN: use-after-free in __ext4_check_dir_entry+0x659/0xbe0 fs/ext4/=
dir.c:96
> Read of size 1 at addr ffff888112785045 by task syz.2.19/5869
>
> CPU: 0 UID: 0 PID: 5869 Comm: syz.2.19 Not tainted syzkaller #0 PREEMPT(f=
ull)
> Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS 1.16.2-debian-1.=
16.2-1 04/01/2014
> Call Trace:
>  <TASK>
>  dump_stack_lvl+0xe8/0x150 lib/dump_stack.c:120
>  print_address_description+0x55/0x1e0 mm/kasan/report.c:378
>  print_report+0x58/0x70 mm/kasan/report.c:482
>  kasan_report+0x117/0x150 mm/kasan/report.c:595
>  ext4_dirent_get_data_len fs/ext4/ext4.h:4156 [inline]
>  ext4_dir_entry_len fs/ext4/ext4.h:4183 [inline]
>  __ext4_check_dir_entry+0x659/0xbe0 fs/ext4/dir.c:96
>  ext4_find_dest_de+0x14e/0x6e0 fs/ext4/namei.c:2221
>  ext4_add_dirent_to_inline+0xcc/0x410 fs/ext4/inline.c:984
>  ext4_try_add_inline_entry+0x21e/0x8a0 fs/ext4/inline.c:1213
>  __ext4_add_entry+0x385/0x3470 fs/ext4/namei.c:2552
>  __ext4_link+0x498/0x720 fs/ext4/namei.c:3649
>  ext4_link+0x1dc/0x2b0 fs/ext4/namei.c:3689
>  vfs_link+0x491/0x650 fs/namei.c:5787
>  ovl_do_link fs/overlayfs/overlayfs.h:233 [inline]
>  ovl_copy_up_tmpfile fs/overlayfs/copy_up.c:891 [inline]
>  ovl_do_copy_up fs/overlayfs/copy_up.c:986 [inline]
>  ovl_copy_up_one fs/overlayfs/copy_up.c:1189 [inline]
>  ovl_copy_up_flags+0x1c52/0x3930 fs/overlayfs/copy_up.c:1243
>  ovl_open+0x13f/0x300 fs/overlayfs/file.c:211
>  do_dentry_open+0x816/0x1380 fs/open.c:947
>  vfs_open+0x3b/0x340 fs/open.c:1079
>  dentry_open+0x61/0xa0 fs/open.c:1102
>  ima_calc_file_hash+0x15f/0x890 security/integrity/ima/ima_crypto.c:269
>  ima_collect_measurement+0x51b/0xa00 security/integrity/ima/ima_api.c:300
>  process_measurement+0x1272/0x1c10 security/integrity/ima/ima_main.c:425
>  ima_file_check+0xe1/0x130 security/integrity/ima/ima_main.c:685
>  security_file_post_open+0xb3/0x260 security/security.c:2755
>  do_open fs/namei.c:4702 [inline]
>  path_openat+0x2e90/0x3830 fs/namei.c:4859
>  do_file_open+0x23e/0x4a0 fs/namei.c:4888
>  do_sys_openat2+0x115/0x200 fs/open.c:1395
>  do_sys_open fs/open.c:1401 [inline]
>  __do_sys_openat fs/open.c:1417 [inline]
>  __se_sys_openat fs/open.c:1412 [inline]
>  __x64_sys_openat+0x138/0x170 fs/open.c:1412
>  do_syscall_x64 arch/x86/entry/syscall_64.c:63 [inline]
>  do_syscall_64+0x174/0x580 arch/x86/entry/syscall_64.c:94
>  entry_SYSCALL_64_after_hwframe+0x77/0x7f
> RIP: 0033:0x7fae54f9ce59
> Code: ff c3 66 2e 0f 1f 84 00 00 00 00 00 0f 1f 44 00 00 48 89 f8 48 89 f=
7 48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 ff=
 ff 73 01 c3 48 c7 c1 e8 ff ff ff f7 d8 64 89 01 48
> RSP: 002b:00007fae55ddb028 EFLAGS: 00000246 ORIG_RAX: 0000000000000101
> RAX: ffffffffffffffda RBX: 00007fae55215fa0 RCX: 00007fae54f9ce59
> RDX: 000000000000003f RSI: 0000200000000380 RDI: ffffffffffffff9c
> RBP: 00007fae55032e6f R08: 0000000000000000 R09: 0000000000000000
> R10: 0000000000000186 R11: 0000000000000246 R12: 0000000000000000
> R13: 00007fae55216038 R14: 00007fae55215fa0 R15: 00007ffedd6a9a88
>  </TASK>
>
> The buggy address belongs to the physical page:
> page: refcount:0 mapcount:0 mapping:0000000000000000 index:0x0 pfn:0x1127=
85
> flags: 0x17ff00000000000(node=3D0|zone=3D2|lastcpupid=3D0x7ff)
> page_type: f0(buddy)
> raw: 017ff00000000000 ffffea000449e048 ffffea000449e2c8 0000000000000000
> raw: 0000000000000000 0000000000000000 00000000f0000000 0000000000000000
> page dumped because: kasan: bad access detected
> page_owner tracks the page as freed
> page last allocated via order 0, migratetype Unmovable, gfp_mask 0xcc0(GF=
P_KERNEL), pid 26, tgid 26 (kworker/u9:0), ts 18747225753, free_ts 49527089=
310
>  set_page_owner include/linux/page_owner.h:32 [inline]
>  post_alloc_hook+0x22d/0x280 mm/page_alloc.c:1853
>  prep_new_page mm/page_alloc.c:1861 [inline]
>  get_page_from_freelist+0x24ae/0x2530 mm/page_alloc.c:3941
>  __alloc_frozen_pages_noprof+0x18d/0x380 mm/page_alloc.c:5221
>  __alloc_pages_noprof+0x10/0x100 mm/page_alloc.c:5255
>  alloc_pages_bulk_noprof+0x5ff/0x7c0 mm/page_alloc.c:5175
>  ___alloc_pages_bulk mm/kasan/shadow.c:345 [inline]
>  __kasan_populate_vmalloc_do mm/kasan/shadow.c:370 [inline]
>  __kasan_populate_vmalloc+0xb7/0x1c0 mm/kasan/shadow.c:424
>  kasan_populate_vmalloc include/linux/kasan.h:580 [inline]
>  alloc_vmap_area+0xd1a/0x1420 mm/vmalloc.c:2123
>  __get_vm_area_node+0x1f2/0x300 mm/vmalloc.c:3226
>  __vmalloc_node_range_noprof+0x358/0x1730 mm/vmalloc.c:4024
>  __vmalloc_node_noprof+0xc2/0x100 mm/vmalloc.c:4124
>  alloc_thread_stack_node kernel/fork.c:358 [inline]
>  dup_task_struct+0x28e/0x850 kernel/fork.c:928
>  copy_process+0x81b/0x42e0 kernel/fork.c:2109
>  kernel_clone+0x2d7/0x940 kernel/fork.c:2745
>  user_mode_thread+0x110/0x180 kernel/fork.c:2821
>  call_usermodehelper_exec_work+0x5c/0x230 kernel/umh.c:171
>  process_one_work kernel/workqueue.c:3322 [inline]
>  process_scheduled_works+0xa8e/0x14e0 kernel/workqueue.c:3405
> page last free pid 5625 tgid 5625 stack trace:
>  reset_page_owner include/linux/page_owner.h:25 [inline]
>  __free_pages_prepare mm/page_alloc.c:1397 [inline]
>  __free_frozen_pages+0xc0d/0xd20 mm/page_alloc.c:2938
>  kasan_depopulate_vmalloc_pte+0x6d/0x90 mm/kasan/shadow.c:484
>  apply_to_pte_range mm/memory.c:3338 [inline]
>  apply_to_pmd_range mm/memory.c:3382 [inline]
>  apply_to_pud_range mm/memory.c:3418 [inline]
>  apply_to_p4d_range mm/memory.c:3454 [inline]
>  __apply_to_page_range+0xbd8/0x1420 mm/memory.c:3490
>  __kasan_release_vmalloc+0xa2/0xd0 mm/kasan/shadow.c:602
>  kasan_release_vmalloc include/linux/kasan.h:593 [inline]
>  kasan_release_vmalloc_node mm/vmalloc.c:2284 [inline]
>  purge_vmap_node+0x220/0x960 mm/vmalloc.c:2306
>  __purge_vmap_area_lazy+0x783/0xb40 mm/vmalloc.c:2396
>  drain_vmap_area_work+0x27/0x40 mm/vmalloc.c:2430
>  process_one_work kernel/workqueue.c:3322 [inline]
>  process_scheduled_works+0xa8e/0x14e0 kernel/workqueue.c:3405
>  worker_thread+0xa47/0xfb0 kernel/workqueue.c:3486
>  kthread+0x388/0x470 kernel/kthread.c:436
>  ret_from_fork+0x514/0xb70 arch/x86/kernel/process.c:158
>  ret_from_fork_asm+0x1a/0x30 arch/x86/entry/entry_64.S:245
>
> Memory state around the buggy address:
>  ffff888112784f00: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
>  ffff888112784f80: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
> >ffff888112785000: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
>                                            ^
>  ffff888112785080: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
>  ffff888112785100: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
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
> [adilger.kernel@dilger.ca adilger@dilger.ca adilger@diliger.ca artem.blag=
odarenko@gmail.com linux-ext4@vger.kernel.org pravin.shelar@sun.com]
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
-upstream-moderation/6a35cfec.0df38f03.ad14c.0000.GAE%40google.com.
