Received: from mail-oo1-f47.google.com (mail-oo1-f47.google.com [209.85.161.47])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DC970366563
	for <syzbot@lists.linux.dev>; Tue, 19 May 2026 06:57:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.161.47
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779173833; cv=pass; b=TOhGqQJuBkbJZW4kN5fuZaUWuTiB1zimJlv7Rs1q1OEYZa3FFvPqtGv85eDgPhT/7OKJdLX/yWE3YraM5o7Hm0IoSS46/FpVNdto6H7sZrydS60ioL9rv3HUx3bFlg2pycITzoQ+uMJqNg9pEe0M3w/I/xOwTnZbcJR0YN/YweY=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779173833; c=relaxed/simple;
	bh=nYEQ8yBby9B8P97+M/PS2AgfdWIjvD0209AzEY6mVhw=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=nToRQ7GhS2McRgMotjEEiAXcED3WCCVG9R9rEwGG4mZJqVVg/VPMYUVMWEXD5C/KaohUmODXyW5GJDkBnw+azdvI7XLg96haSfGFg8ROmOzExvBHXnL7Hpq5nnh51tcqEZLmFt5H5QDEaTwtVxxgScXZj0UyvCDMgGgp6ckcbJ0=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=iQzURXOI; arc=pass smtp.client-ip=209.85.161.47
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="iQzURXOI"
Received: by mail-oo1-f47.google.com with SMTP id 006d021491bc7-69b747a8984so681207eaf.2
        for <syzbot@lists.linux.dev>; Mon, 18 May 2026 23:57:11 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1779173831; cv=none;
        d=google.com; s=arc-20240605;
        b=U79oJT7ifftMmfGT5iqk8o1M2ayFQbN7g4pE7vdC6LHj3VKiNcFyz1ad0hu9gk3B3l
         cqcYRZ0fdO4xqhfhf4Wj3Yk+ZwCvgEAzkPt2MdQQWUMNNHZmJkDEd6l8rQ6JThzWyqQ5
         m+J+ds3OW2zk019w+bY3cWDyV3OhKqCZv6m6JlqchQDn+IamLm6HbcF2lrWDAocaBXNl
         Srbx4cBAtviyHdFkRoskBqLeXNfTLimh4RGp0Lq3vCKW3QruGeex7Wg8rzr5hlXdlMkL
         VeUylD9JrekX5g0eicPS1YaHdita6VP5vEGA67xzIo46Epi7SUauc/mWMRlPWBvQJdER
         lDjg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=I8ec705M2cnVAJv3rtD/dDmN9Zkl8gdI1DbQqfiInBE=;
        fh=fKhwzBBB84IQD8V3R0FD5GB8Y/ii0ao3HgUGJkc7aMc=;
        b=hFGd/lp/XMaLT1SZtdmzgN6wN2tyEc5UgG7X2NKswiZyFirt0GM9spTPyZwJOj11lV
         SzBACVKnFBzYXlrKEy/ywzwd4QCEAiELGSpPeFkgAYXryZzpH64PXpGf3lT+8OCkGzv6
         uxo01Xvxl7T1kPNh75m63sYFgYyxmYmaMGKGYAoU7ACQfLBok+2kyotJAAWCk0feWt2I
         msz5bdNzEdTIAzBh0xZbxSQxaAr9CHxtMPTa91xJxTC+6ZmQlj6CX+MbAdT5nUjWdn1b
         +AsOuxoFGpPVLS7zzcoSAGdFyaw8hBrVOqgRPLBGPLCOW6yUvnAL4MgkHm3YXWLJJnr3
         WqOA==;
        darn=lists.linux.dev
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1779173831; x=1779778631; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=I8ec705M2cnVAJv3rtD/dDmN9Zkl8gdI1DbQqfiInBE=;
        b=iQzURXOIlTDv7lexncYprmU20PwBvJPRL4OPRAs0xKil1PHZfxgPdye8w9aT+KlOKf
         Gz+bOjIMPyJI3JuqEacoHkNKaW8X96Clx3k+FLMFZstbK+klj5Zlm8oa58y1wI3vxT8N
         O4DTUsqmU44jFHRD7JBZDo3WYX4FHuiFlyzKnQWXL0bP/sZWAznzU6AdzBX2otT9Rht0
         4JpC3hKu1mhIbmmP6rgXnsFHvO/nDLR1lg3r7Fp4kbz3/j+5vdFUow3bGHHqLoX2oZfS
         ixwj/0tqp4ghKzhs1c/mwUFte5vfFQtvYWM795DdNHcnpcmxmqwy9VO9nMMDKQQDVFdE
         fIJg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1779173831; x=1779778631;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=I8ec705M2cnVAJv3rtD/dDmN9Zkl8gdI1DbQqfiInBE=;
        b=FbD08p2W/t4woynO/4vnmjcF7ycqI6mBd08ELPr65K68IMQ+LGBxRzLV3C251Je9WM
         mApCIT50aGgjb7YXUo1dEvSSbNY4r5sCv33TAiWarefXlOPKODVuJao9vcfJfDnDCGTd
         l/yMXQoqNbZTAMUZ0maWn+PVdKpzKa6PfYQ8Hrwyqmp5M+TU38NPO7FiQzF3fI/74YQd
         YVtCQ6DAWl8DRRQKfjDrkOrYVAzQ27+b9+nGveASz0riRAvT9kmS2QCPsXBNGzdCYNvY
         UrDf6UQJoccHlSTcMquslXS2oR6NS59VGVqFgXMaNdzv9K6v8KZ1uJr3U86d3YWT8dNP
         gl+g==
X-Forwarded-Encrypted: i=1; AFNElJ+kkSucZgkqqoYqdMPg8h5C8M7B+3L9QI/3kEUo9+MbKuDKecNG3FmRZ9nkrcHVTBieBFBPc+A=@lists.linux.dev
X-Gm-Message-State: AOJu0Yze3jJkVY/bcUWI20J9B0WJYH3v3yYk0rZV1rQZNI2kAz6wxgb4
	VPos60YhOT24CNFC3XyGlTiigH8avM1oaV8+0KgaVhUuIsHPHsucNyhQGLFnGn9ORCzlqIz/KlL
	hD1Ev3VW/ZWXwkyJ2Sry6I0v7sKWaul3k5iXv8PWG
X-Gm-Gg: Acq92OGBu+D/wW8kWU8V/swNbtxcyN/FsEwr0WsF303UZ/FlJ/O3Kjtr1obcx1HQfUM
	jgITvv00ce4rwSGyCrNtvgYd+KdKCiuV16hU9fxfKzujg+SyXbP3ciRseVKyzC2+UsxLpyuDfqQ
	67Ee4jw5pehUonp7TjhWHMouWcnNNznsmxto+yb+whTuJ6xbr80237plp1O3yF1CAGr4OJ21Jwb
	UiSF2HfCCgs3TW606SwKTgipFobCuy/Kdd5Qn81XMkcIzUddj/okMUSTpxvJNqXJdDFu73sq01b
	bRgY4+MDMY3F9j5+zmiScLnP+DBLt/vafky5DXdmtfgdmrpr8FZ5OPmb8ffKqeikbUZwAPnW8ER
	GCGCy
X-Received: by 2002:a05:6820:4cc2:b0:69b:8c61:796c with SMTP id
 006d021491bc7-69c952e89c5mr12281805eaf.42.1779173830252; Mon, 18 May 2026
 23:57:10 -0700 (PDT)
Precedence: bulk
X-Mailing-List: syzbot@lists.linux.dev
List-Id: <syzbot.lists.linux.dev>
List-Subscribe: <mailto:syzbot+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:syzbot+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <6a0b8269.170a0220.2651cb.0002.GAE@google.com>
In-Reply-To: <6a0b8269.170a0220.2651cb.0002.GAE@google.com>
From: Aleksandr Nogikh <nogikh@google.com>
Date: Tue, 19 May 2026 08:56:59 +0200
X-Gm-Features: AVHnY4IEY3_rzZSWhHkfKgVtxlf34zHSVap395X_DR49hMoWEgD7E2goOnxt7lg
Message-ID: <CANp29Y5pSpWnvuRPuGCw6bn=srWYfUwz0+NFQ7+1fd6h8qPBbA@mail.gmail.com>
Subject: Re: [moderation/CI] Re: vfs: add O_CREAT|O_DIRECTORY to open*(2)
To: syzbot ci <syzbot+cib500a722a95fa7e2@syzkaller.appspotmail.com>
Cc: syzkaller-upstream-moderation@googlegroups.com, syzbot@lists.linux.dev
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

#syz upstream

On Mon, May 18, 2026 at 11:19=E2=80=AFPM syzbot ci
<syzbot+cib500a722a95fa7e2@syzkaller.appspotmail.com> wrote:
>
> syzbot ci has tested the following series
>
> [v4] vfs: add O_CREAT|O_DIRECTORY to open*(2)
> https://lore.kernel.org/all/20260518165237.2084042-1-jkoolstra@xs4all.nl
> * [RFC PATCH v4 1/2] vfs: add O_CREAT|O_DIRECTORY to open*(2)
> * [RFC PATCH v4 2/2] selftest: add tests for open*(O_CREAT|O_DIRECTORY)
>
> and found the following issues:
> * KASAN: slab-out-of-bounds Read in ovl_dir_release
> * general protection fault in path_openat
>
> Full report is available here:
> https://ci.syzbot.org/series/0d511b6b-6434-45cd-bbf3-51fe9d916e99
>
> ***
>
> KASAN: slab-out-of-bounds Read in ovl_dir_release
>
> tree:      torvalds
> URL:       https://kernel.googlesource.com/pub/scm/linux/kernel/git/torva=
lds/linux
> base:      5200f5f493f79f14bbdc349e402a40dfb32f23c8
> arch:      amd64
> compiler:  Debian clang version 21.1.8 (++20251221033036+2078da43e25a-1~e=
xp1~20251221153213.50), Debian LLD 21.1.8
> config:    https://ci.syzbot.org/builds/024b677f-50e7-4ef9-ae98-2652f5098=
bfd/config
> syz repro: https://ci.syzbot.org/findings/a7087360-137c-41f5-ae13-db4d551=
fe142/syz_repro
>
> =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
> BUG: KASAN: slab-out-of-bounds in ovl_dir_release+0x228/0x2a0 fs/overlayf=
s/readdir.c:1033
> Read of size 8 at addr ffff88816cd2c818 by task syz.0.17/5813
>
> CPU: 0 UID: 0 PID: 5813 Comm: syz.0.17 Not tainted syzkaller #0 PREEMPT(f=
ull)
> Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS 1.16.2-debian-1.=
16.2-1 04/01/2014
> Call Trace:
>  <TASK>
>  dump_stack_lvl+0xe8/0x150 lib/dump_stack.c:120
>  print_address_description+0x55/0x1e0 mm/kasan/report.c:378
>  print_report+0x58/0x70 mm/kasan/report.c:482
>  kasan_report+0x117/0x150 mm/kasan/report.c:595
>  ovl_dir_release+0x228/0x2a0 fs/overlayfs/readdir.c:1033
>  __fput+0x44f/0xa60 fs/file_table.c:510
>  task_work_run+0x1d9/0x270 kernel/task_work.c:233
>  resume_user_mode_work include/linux/resume_user_mode.h:50 [inline]
>  __exit_to_user_mode_loop kernel/entry/common.c:67 [inline]
>  exit_to_user_mode_loop+0xf3/0x4d0 kernel/entry/common.c:98
>  __exit_to_user_mode_prepare include/linux/irq-entry-common.h:207 [inline=
]
>  syscall_exit_to_user_mode_prepare include/linux/irq-entry-common.h:230 [=
inline]
>  syscall_exit_to_user_mode include/linux/entry-common.h:318 [inline]
>  do_syscall_64+0x33e/0xf80 arch/x86/entry/syscall_64.c:100
>  entry_SYSCALL_64_after_hwframe+0x77/0x7f
> RIP: 0033:0x7fe1a159ce59
> Code: ff c3 66 2e 0f 1f 84 00 00 00 00 00 0f 1f 44 00 00 48 89 f8 48 89 f=
7 48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 ff=
 ff 73 01 c3 48 c7 c1 e8 ff ff ff f7 d8 64 89 01 48
> RSP: 002b:00007ffe25af07f8 EFLAGS: 00000246 ORIG_RAX: 00000000000001b4
> RAX: 0000000000000000 RBX: 00007ffe25af08e0 RCX: 00007fe1a159ce59
> RDX: 0000000000000000 RSI: 000000000000001e RDI: 0000000000000003
> RBP: 0000000000012e15 R08: 0000000000000001 R09: 0000000000000000
> R10: 0000001b32a20000 R11: 0000000000000246 R12: 00007ffe25af0920
> R13: 00007fe1a1815fac R14: 0000000000012e53 R15: 00007fe1a1815fa0
>  </TASK>
>
> Allocated by task 5814:
>  kasan_save_stack mm/kasan/common.c:57 [inline]
>  kasan_save_track+0x3e/0x80 mm/kasan/common.c:78
>  poison_kmalloc_redzone mm/kasan/common.c:398 [inline]
>  __kasan_kmalloc+0x93/0xb0 mm/kasan/common.c:415
>  kasan_kmalloc include/linux/kasan.h:263 [inline]
>  __kmalloc_cache_noprof+0x31c/0x660 mm/slub.c:5419
>  kmalloc_noprof include/linux/slab.h:950 [inline]
>  kzalloc_noprof include/linux/slab.h:1188 [inline]
>  ovl_file_alloc+0x4f/0x90 fs/overlayfs/file.c:99
>  ovl_create_tmpfile fs/overlayfs/dir.c:1399 [inline]
>  ovl_tmpfile+0x3fc/0x7d0 fs/overlayfs/dir.c:1448
>  vfs_tmpfile+0x3ff/0x890 fs/namei.c:4794
>  do_tmpfile+0xd3/0x240 fs/namei.c:4859
>  path_openat+0x33c7/0x3b40 fs/namei.c:4893
>  do_file_open+0x23e/0x4a0 fs/namei.c:4931
>  do_sys_openat2+0x113/0x200 fs/open.c:1367
>  do_sys_open fs/open.c:1373 [inline]
>  __do_sys_open fs/open.c:1381 [inline]
>  __se_sys_open fs/open.c:1377 [inline]
>  __x64_sys_open+0x11e/0x150 fs/open.c:1377
>  do_syscall_x64 arch/x86/entry/syscall_64.c:63 [inline]
>  do_syscall_64+0x15f/0xf80 arch/x86/entry/syscall_64.c:94
>  entry_SYSCALL_64_after_hwframe+0x77/0x7f
>
> The buggy address belongs to the object at ffff88816cd2c800
>  which belongs to the cache kmalloc-16 of size 16
> The buggy address is located 8 bytes to the right of
>  allocated 16-byte region [ffff88816cd2c800, ffff88816cd2c810)
>
> The buggy address belongs to the physical page:
> page: refcount:0 mapcount:0 mapping:0000000000000000 index:0xffff88816cd2=
c840 pfn:0x16cd2c
> flags: 0x57ff00000000200(workingset|node=3D1|zone=3D2|lastcpupid=3D0x7ff)
> page_type: f5(slab)
> raw: 057ff00000000200 ffff888100041640 ffff888160400408 ffff888160400408
> raw: ffff88816cd2c840 0000000800800042 00000000f5000000 0000000000000000
> page dumped because: kasan: bad access detected
> page_owner tracks the page as allocated
> page last allocated via order 0, migratetype Unmovable, gfp_mask 0x252800=
(GFP_NOWAIT|__GFP_NORETRY|__GFP_COMP|__GFP_THISNODE), pid 5741, tgid 5741 (=
syz-executor), ts 77437404410, free_ts 77431264562
>  set_page_owner include/linux/page_owner.h:32 [inline]
>  post_alloc_hook+0x231/0x280 mm/page_alloc.c:1858
>  prep_new_page mm/page_alloc.c:1866 [inline]
>  get_page_from_freelist+0x24ba/0x2540 mm/page_alloc.c:3946
>  __alloc_frozen_pages_noprof+0x18d/0x380 mm/page_alloc.c:5226
>  alloc_slab_page mm/slub.c:3278 [inline]
>  allocate_slab+0x77/0x660 mm/slub.c:3467
>  new_slab mm/slub.c:3525 [inline]
>  ___slab_alloc+0x154/0x6c0 mm/slub.c:4444
>  __slab_alloc_node mm/slub.c:4510 [inline]
>  slab_alloc_node mm/slub.c:4886 [inline]
>  __do_kmalloc_node mm/slub.c:5294 [inline]
>  __kvmalloc_node_noprof+0x34d/0x8a0 mm/slub.c:6832
>  xt_jumpstack_alloc net/netfilter/x_tables.c:1449 [inline]
>  do_replace_table+0x191/0x620 net/netfilter/x_tables.c:1486
>  xt_register_table+0x269/0x960 net/netfilter/x_tables.c:1596
>  ip6t_register_table+0x16b/0x330 net/ipv6/netfilter/ip6_tables.c:1754
>  ip6table_raw_table_init+0x54/0x80 net/ipv6/netfilter/ip6table_raw.c:48
>  xt_find_table_lock+0x30c/0x3f0 net/netfilter/x_tables.c:1353
>  xt_request_find_table_lock+0x26/0x100 net/netfilter/x_tables.c:1378
>  get_info net/ipv6/netfilter/ip6_tables.c:979 [inline]
>  do_ip6t_get_ctl+0x716/0x1230 net/ipv6/netfilter/ip6_tables.c:1668
>  nf_getsockopt+0x26e/0x290 net/netfilter/nf_sockopt.c:116
>  ipv6_getsockopt+0x1fd/0x2b0 net/ipv6/ipv6_sockglue.c:1464
>  do_sock_getsockopt+0x51d/0x7e0 net/socket.c:2487
> page last free pid 15 tgid 15 stack trace:
>  reset_page_owner include/linux/page_owner.h:25 [inline]
>  __free_pages_prepare mm/page_alloc.c:1402 [inline]
>  __free_frozen_pages+0xbc7/0xd30 mm/page_alloc.c:2943
>  rcu_do_batch kernel/rcu/tree.c:2617 [inline]
>  rcu_core+0x7cd/0x1070 kernel/rcu/tree.c:2869
>  handle_softirqs+0x22a/0x840 kernel/softirq.c:622
>  run_ksoftirqd+0x36/0x60 kernel/softirq.c:1076
>  smpboot_thread_fn+0x541/0xa50 kernel/smpboot.c:160
>  kthread+0x389/0x470 kernel/kthread.c:436
>  ret_from_fork+0x514/0xb70 arch/x86/kernel/process.c:158
>  ret_from_fork_asm+0x1a/0x30 arch/x86/entry/entry_64.S:245
>
> Memory state around the buggy address:
>  ffff88816cd2c700: fc fc fc fc fc fc fc fc fc fc fc fc fc fc fc fc
>  ffff88816cd2c780: fc fc fc fc fc fc fc fc fc fc fc fc fc fc fc fc
> >ffff88816cd2c800: 00 00 fc fc 00 00 fc fc fc fc fc fc fc fc fc fc
>                             ^
>  ffff88816cd2c880: fc fc fc fc fc fc fc fc fc fc fc fc fc fc fc fc
>  ffff88816cd2c900: fc fc fc fc fc fc fc fc fc fc fc fc fc fc fc fc
> =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
>
>
> ***
>
> general protection fault in path_openat
>
> tree:      torvalds
> URL:       https://kernel.googlesource.com/pub/scm/linux/kernel/git/torva=
lds/linux
> base:      5200f5f493f79f14bbdc349e402a40dfb32f23c8
> arch:      amd64
> compiler:  Debian clang version 21.1.8 (++20251221033036+2078da43e25a-1~e=
xp1~20251221153213.50), Debian LLD 21.1.8
> config:    https://ci.syzbot.org/builds/024b677f-50e7-4ef9-ae98-2652f5098=
bfd/config
> syz repro: https://ci.syzbot.org/findings/4b3b0fe3-064c-43e2-b887-b3a52d8=
7a16a/syz_repro
>
> BTRFS info (device loop1): enabling ssd optimizations
> BTRFS info (device loop1): turning on async discard
> BTRFS info (device loop1): enabling free space tree
> BTRFS info (device loop1): use zstd compression, level 3
> Oops: general protection fault, probably for non-canonical address 0xdfff=
fc0000000000: 0000 [#1] SMP KASAN PTI
> KASAN: null-ptr-deref in range [0x0000000000000000-0x0000000000000007]
> CPU: 1 UID: 0 PID: 5849 Comm: syz.1.18 Not tainted syzkaller #0 PREEMPT(f=
ull)
> Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS 1.16.2-debian-1.=
16.2-1 04/01/2014
> RIP: 0010:__d_entry_type include/linux/dcache.h:429 [inline]
> RIP: 0010:d_can_lookup include/linux/dcache.h:444 [inline]
> RIP: 0010:do_open fs/namei.c:4726 [inline]
> RIP: 0010:path_openat+0x2e66/0x3b40 fs/namei.c:4902
> Code: e8 8f 49 7f ff eb 62 48 8b 44 24 78 42 80 3c 20 00 48 8b 5c 24 68 7=
4 08 48 89 df e8 44 87 ea ff 4c 8b 3b 4c 89 f8 48 c1 e8 03 <42> 0f b6 04 20=
 84 c0 0f 85 cb 09 00 00 41 bc 00 00 38 00 45 23 27
> RSP: 0018:ffffc9000405f960 EFLAGS: 00010246
> RAX: 0000000000000000 RBX: ffffc9000405fc28 RCX: 0000000000000000
> RDX: ffff88810fe50000 RSI: 0000000000000002 RDI: 0000000000000000
> RBP: ffffc9000405fbb0 R08: ffff8881b949469b R09: 1ffff110372928d3
> R10: dffffc0000000000 R11: ffffed10372928d4 R12: dffffc0000000000
> R13: 1ffff1102eb65c88 R14: 000000000015d0c0 R15: 0000000000000001
> FS:  00007f074937f6c0(0000) GS:ffff8882a928a000(0000) knlGS:0000000000000=
000
> CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> CR2: 00000c2113360000 CR3: 0000000103f3a000 CR4: 00000000000006f0
> Call Trace:
>  <TASK>
>  do_file_open+0x23e/0x4a0 fs/namei.c:4931
>  do_sys_openat2+0x113/0x200 fs/open.c:1367
>  do_sys_open fs/open.c:1373 [inline]
>  __do_sys_openat fs/open.c:1389 [inline]
>  __se_sys_openat fs/open.c:1384 [inline]
>  __x64_sys_openat+0x138/0x170 fs/open.c:1384
>  do_syscall_x64 arch/x86/entry/syscall_64.c:63 [inline]
>  do_syscall_64+0x15f/0xf80 arch/x86/entry/syscall_64.c:94
>  entry_SYSCALL_64_after_hwframe+0x77/0x7f
> RIP: 0033:0x7f074859ce59
> Code: ff c3 66 2e 0f 1f 84 00 00 00 00 00 0f 1f 44 00 00 48 89 f8 48 89 f=
7 48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 ff=
 ff 73 01 c3 48 c7 c1 e8 ff ff ff f7 d8 64 89 01 48
> RSP: 002b:00007f074937f028 EFLAGS: 00000246 ORIG_RAX: 0000000000000101
> RAX: ffffffffffffffda RBX: 00007f0748815fa0 RCX: 00007f074859ce59
> RDX: 00000000001dd0c0 RSI: 0000200000000240 RDI: ffffffffffffff9c
> RBP: 00007f0748632d6f R08: 0000000000000000 R09: 0000000000000000
> R10: 0000000000000000 R11: 0000000000000246 R12: 0000000000000000
> R13: 00007f0748816038 R14: 00007f0748815fa0 R15: 00007fff34fee548
>  </TASK>
> Modules linked in:
> ---[ end trace 0000000000000000 ]---
> RIP: 0010:__d_entry_type include/linux/dcache.h:429 [inline]
> RIP: 0010:d_can_lookup include/linux/dcache.h:444 [inline]
> RIP: 0010:do_open fs/namei.c:4726 [inline]
> RIP: 0010:path_openat+0x2e66/0x3b40 fs/namei.c:4902
> Code: e8 8f 49 7f ff eb 62 48 8b 44 24 78 42 80 3c 20 00 48 8b 5c 24 68 7=
4 08 48 89 df e8 44 87 ea ff 4c 8b 3b 4c 89 f8 48 c1 e8 03 <42> 0f b6 04 20=
 84 c0 0f 85 cb 09 00 00 41 bc 00 00 38 00 45 23 27
> RSP: 0018:ffffc9000405f960 EFLAGS: 00010246
> RAX: 0000000000000000 RBX: ffffc9000405fc28 RCX: 0000000000000000
> RDX: ffff88810fe50000 RSI: 0000000000000002 RDI: 0000000000000000
> RBP: ffffc9000405fbb0 R08: ffff8881b949469b R09: 1ffff110372928d3
> R10: dffffc0000000000 R11: ffffed10372928d4 R12: dffffc0000000000
> R13: 1ffff1102eb65c88 R14: 000000000015d0c0 R15: 0000000000000001
> FS:  00007f074937f6c0(0000) GS:ffff8882a928a000(0000) knlGS:0000000000000=
000
> CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> CR2: 00007f1c7a2f73b0 CR3: 0000000103f3a000 CR4: 00000000000006f0
> ----------------
> Code disassembly (best guess):
>    0:   e8 8f 49 7f ff          call   0xff7f4994
>    5:   eb 62                   jmp    0x69
>    7:   48 8b 44 24 78          mov    0x78(%rsp),%rax
>    c:   42 80 3c 20 00          cmpb   $0x0,(%rax,%r12,1)
>   11:   48 8b 5c 24 68          mov    0x68(%rsp),%rbx
>   16:   74 08                   je     0x20
>   18:   48 89 df                mov    %rbx,%rdi
>   1b:   e8 44 87 ea ff          call   0xffea8764
>   20:   4c 8b 3b                mov    (%rbx),%r15
>   23:   4c 89 f8                mov    %r15,%rax
>   26:   48 c1 e8 03             shr    $0x3,%rax
> * 2a:   42 0f b6 04 20          movzbl (%rax,%r12,1),%eax <-- trapping in=
struction
>   2f:   84 c0                   test   %al,%al
>   31:   0f 85 cb 09 00 00       jne    0xa02
>   37:   41 bc 00 00 38 00       mov    $0x380000,%r12d
>   3d:   45 23 27                and    (%r15),%r12d
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
> [brauner@kernel.org cmirabil@redhat.com cyphar@cyphar.com jack@suse.cz jk=
oolstra@xs4all.nl jori.koolstra@gmail.com linux-fsdevel@vger.kernel.org lin=
ux-kernel@vger.kernel.org viro@zeniv.linux.org.uk]
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
-upstream-moderation/6a0b8269.170a0220.2651cb.0002.GAE%40google.com.
