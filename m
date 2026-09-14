Received: from mail-qv1-f41.google.com (mail-qv1-f41.google.com [209.85.219.41])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5DE1538B143
	for <syzbot@lists.linux.dev>; Mon, 14 Sep 2026 08:49:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.219.41
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789375777; cv=pass; b=VicL/fyQieX9gpmBXRyd2fmy9z0MLxDF4Y4cpMAicifdAxCJqnbXk0m6qUjvBVTXWYz7nQxcDuuE9s5tWqlUDfIVlxF5FUTTYh9MNAhL2pPRNDuO8pnAMntxU0x48GkIK2R9YGaa8MzFUWCVkSGYL0Uezn1L5UL1g4QDzPCGDcQ=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789375777; c=relaxed/simple;
	bh=Bx+DFiNcr5b6H5ydatgVokzPrhGAFQLZHvrYq3LaUL4=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=Lyv7BfA3Zp4mdS8+ibx2bDpCk7XKcJS43gILMzvxOqfDLP0pPXRjUTYzmQzYyb1nkKKP9h2FxCbAS1PMaI5fy8hj9cYE3cO3/Y8BhbIpRyn40YT6vBewvSm+o1hx9aV2lp1q+kmehF8m15TFlAPfAImRpvxa4FKRbKivYfcXgoQ=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=mVbXP7EE; arc=pass smtp.client-ip=209.85.219.41
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="mVbXP7EE"
Received: by mail-qv1-f41.google.com with SMTP id 6a1803df08f44-90cd4631090so28886866d6.1
        for <syzbot@lists.linux.dev>; Mon, 14 Sep 2026 01:49:34 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1789375773; cv=none;
        d=google.com; s=arc-20260327;
        b=dQkvwVf6gpyu3DDID64La4I92p05F/w7kG8LtvuejSysUJMu+Mixoqju62npHnSd6Q
         s10jd03IE+aQ1RpChacZH+KFZ++1PIyY6mocgMmc57Kv5t0DqOzd1KvIPJ2JatFLu5pX
         Nn9IqKQt+3fHVSIYI6jhu1lraJh18tWSacJEnWLIleFw6H6UY4HrX3v76Le6nKalTU+9
         oAqsVxKQFG1IXaeG9W0EBDZSfZN22hoNqT1zDGmtWbWnmxFQK6w3LsR/irzsaC47qglW
         PUEnA3VBDfz3TtyVCLkh5G+EgWJaoeDHYX1bfRl58ltbKyTE1mhoYYLtrFy/JqB5l0so
         qR8g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=xlVZPKutse0yOCgD2m//E1wvVTYEc9cYBKq1F7N0Hzk=;
        fh=mcDkQtClSKa0zjiYga+to3tBUGK8w4KThQtbJEUJa58=;
        b=dx/ziX7T4CK9qwd009FV8cYSLZ3tX2LRkCdqTUpGbLxw0voCUbdoFrtFdvciOSCmSN
         n6qdsRaEiwubSD8eMqLI8vunu90GTZGMT9QK7n/0X+peFj52lsst/pi9Nw0BZYe/cyLW
         757fM+ZHXZQf7vabEomsTcsP8rZD6T+3f155m2BFqQoQWV7OELZipwIwbPQayv1S4wKn
         9m8i+PwCk+WOIXtPN2rGme2ysguqDJDMw2i0KCDC2hBo0jCrQwv8rAzuStQqpXb8NSs7
         rk9JTd67zJR+S2bxmbG8jk1gmGhmDtIudly7XwHwjf5aohQlRK/huqIWoYaSFb5/nIK/
         64eQ==;
        darn=lists.linux.dev
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1789375773; x=1789980573; darn=lists.linux.dev;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=xlVZPKutse0yOCgD2m//E1wvVTYEc9cYBKq1F7N0Hzk=;
        b=mVbXP7EE3rgGfQwNQC/0HzAySgyWGgMcSZTPO1YHIuMQLV2xLozlq/hkknM1kd9xsr
         9MiGhEh0Ddzu1ACZhZixmsg8Hr7+O6lC8mhPIhiIaMRAq80eciTyZTJ+0HA4VoK8/lin
         TICuOcPlDsK28dk/4b+D6foW69Bece+Y5M+oGgL5UVqO4J2IQYguLUWJhrzCdz3Qrvs7
         KbrlvBykRPy31XUa2nSn/vxA6O7xOCvzff0hD1Yr1Pz0n27qgTp0+rjrnkVVWEvf7Yyf
         EIIcyyfqXsIQmoEOcJC4RL0yqFc5omlbC6JIhsy6Ci43cxLDZGe/+90EE7kdoOl1HmIT
         /nww==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1789375773; x=1789980573;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=xlVZPKutse0yOCgD2m//E1wvVTYEc9cYBKq1F7N0Hzk=;
        b=GIN+AbD7RbWSyX71LCxd6AP6suX9ZbFOMVKlnkidcPSdUOGwncp/iWrefxkYoXLUFB
         VPs1/Daj34yEL6gbm5jmgNJe6d5LG1kaL2XrYHpvM8PpM5E8LjFtYXo4mKZhr2UKa/wY
         oZ9JMCki4EZkYLtNbo5PiM7NIImQ6SZ6/WfsZwUH7OEDX4ZL740b5KA6RDU+yRxzdSBY
         TQitwydPshRVS7RcgzWFAjNkFohqc1pefqgx0Zu1rSTZxIlCYLMkHjXqeG0bhizgAxfU
         n85RMm5P8TstvH5IQ0X1EiCclFRfw8Ti+Ug0ZwmxEXs+nGpzevvDDSjIkq+EqswUSmgH
         J2ag==
X-Forwarded-Encrypted: i=1; AKwUvBxIIOqMCp+i2XOdZgDF1EdA9BZ42UB+Ui3/ea82MBze+wy9OrADJzwMSPcJXLsr8F4WZNHHtMs=@lists.linux.dev
X-Gm-Message-State: AFuF++mb/mEo6ED8xTXEzTSibz4A3brvKHBakLe1OUEk37TfrBO0FZsA
	dzNH7HeQrW40xv5c7TSq3Sp5cq7ykBn2z3NSt3vtT7joJ1eDKt34nIqaD4evp0soNTv0jeybkBV
	LNjKGTOx6NV3YiJCTWw0cYZFSe/eH+j5hjxfTyof+2q3lK5PvzH18SPPv
X-Gm-Gg: AYBFou3LRohz04HDoU+mOHBNb+ZwLCtx7IfTiPCBKkiQG4bEoSrzEcbaTCsnYZcWZoN
	BxbEPoGkMf30Dq+gr1V8FvvnZmsFV4cWRFIYN0wJh5fbH2AQ9513vlH+DqZ/ASAkvhY6p7nt97d
	i6aEg2pnL69qMNlw1enRpUo8HvDo6QfGQ08/0iLE1ZVlp5IKpza445QBKP4u2o/w99k+a9s2ShO
	AsoMzZT3QlSNVDx9/QZQJpCEjR2XlirU3ejvYWBP86j8759XtODueKF5xAW7Z2xL5LzOaiMzPkt
	FjYb24YmkTRpUUJlZM1VWK+Ckl6NCa4PImmjRu1aXDMV+2fGDOZ0B9S8ncZfO1qcl1K0dB9FI8E
	08Fg2UkQi1+sOe2x8aKTmymGgcfheMyZlbNuK3Z6d
X-Received: by 2002:a05:6214:487:b0:90e:9d5f:d3b with SMTP id
 6a1803df08f44-91226b5ecd6mr64471456d6.16.1789375772490; Mon, 14 Sep 2026
 01:49:32 -0700 (PDT)
Precedence: bulk
X-Mailing-List: syzbot@lists.linux.dev
List-Id: <syzbot.lists.linux.dev>
List-Subscribe: <mailto:syzbot+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:syzbot+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <6aa7b165.3aa11909.1a03b8.007a.GAE@google.com>
In-Reply-To: <6aa7b165.3aa11909.1a03b8.007a.GAE@google.com>
From: Pimyn Girgis <pimyn@google.com>
Date: Mon, 14 Sep 2026 10:49:20 +0200
X-Gm-Features: AcwNN1Ujf069L7M54rSujeYshuBX2lg93-lZ2Fug6V-oGLJ6IXsCWpT0tkLKybg
Message-ID: <CAJWNTGxDu20PS3VTyB5tC-vtpM9hg4iK1+BynfwbrErdkzR-dQ@mail.gmail.com>
Subject: Re: [moderation/CI] Re: fs/proc: split the inode list for procfs
To: syzbot ci <syzbot+cif1533b673d3bef08@syzkaller.appspotmail.com>
Cc: syzkaller-upstream-moderation@googlegroups.com, syzbot@lists.linux.dev
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

#syz upstream


On Mon, Sep 14, 2026 at 10:33=E2=80=AFAM syzbot ci
<syzbot+cif1533b673d3bef08@syzkaller.appspotmail.com> wrote:
>
> syzbot ci has tested the following series
>
> [v1] fs/proc: split the inode list for procfs
> https://lore.kernel.org/all/20260914061449.4024632-1-huangsj@hygon.cn
> * [RFC PATCH 1/3] fs/drop_caches: do not scan procfs in drop_pagecache_sb=
()
> * [RFC PATCH 2/3] fs/super: introduce a helper sb_inodes_empty()
> * [RFC PATCH 3/3] fs/proc: split the inode list
>
> and found the following issue:
> KASAN: slab-out-of-bounds Read in hook_sb_delete
>
> Full report is available here:
> https://ci.syzbot.org/series/736afa16-0dc2-40e7-9a6c-74db419044d7
>
> ***
>
> KASAN: slab-out-of-bounds Read in hook_sb_delete
>
> tree:      vfs
> URL:       https://kernel.googlesource.com/pub/scm/linux/kernel/git/vfs/v=
fs.git
> base:      15aa70de9f706fb0e3852f636b8a0a9d5bc048ab
> arch:      amd64
> compiler:  Debian clang version 22.1.8 (++20260613092233+e80beda6e255-1~e=
xp1~20260613092250.77), Debian LLD 22.1.8
> config:    https://ci.syzbot.org/builds/cd4bf6c8-aad6-4b38-b003-31dcd0a8a=
4bf/config
>
> ima: No TPM chip found, activating TPM-bypass!
> Loading compiled-in module X.509 certificates
> Loaded X.509 cert 'Build time autogenerated kernel key: affe42cfbb2369724=
f6c4c4a3fe3f0b2fe4692dc'
> ima: Allocated hash algorithm: sha256
> ima: No architecture policies found
> evm: Initialising EVM extended attributes:
> evm: security.selinux (disabled)
> evm: security.SMACK64 (disabled)
> evm: security.SMACK64EXEC (disabled)
> evm: security.SMACK64TRANSMUTE (disabled)
> evm: security.SMACK64MMAP (disabled)
> evm: security.apparmor
> evm: security.ima
> evm: security.capability
> evm: HMAC attrs: 0x1
> PM:   Magic number: 10:739:371
> usb usb44-port5: hash matches
> udc dummy_udc.27: hash matches
> dummy_udc dummy_udc.27: hash matches
> usb usb12-port1: hash matches
> netconsole: network logging started
> gtp: GTP module loaded (pdp ctx size 128 bytes)
> rdma_rxe: loaded
> cfg80211: Loading compiled-in X.509 certificates for regulatory database
> Loaded X.509 cert 'sforshee: 00b28ddf47aef9cea7'
> Loaded X.509 cert 'wens: 61c038651aabdcf94bd0ac7ff06c7248db18c600'
> clk: Disabling unused clocks
> ALSA device list:
>   #0: Dummy 1
>   #1: Loopback 1
>   #2: Virtual MIDI Card 1
> md: Waiting for all devices to be available before autodetect
> md: If you don't use raid, use raid=3Dnoautodetect
> md: Autodetecting RAID arrays.
> md: autorun ...
> md: ... autorun DONE.
> EXT4-fs (sda1): mounted filesystem b4773fba-1738-4da0-8a90-0fe043d0a496 r=
o with ordered data mode. Quota mode: none.
> VFS: Mounted root (ext4 filesystem) readonly on device 8:1.
> devtmpfs: mounted
> VFS: Pivoted into new rootfs
> Freeing unused kernel image (initmem) memory: 27172K
> Write protecting the kernel read-only data: 223232k
> Freeing unused kernel image (text/rodata gap) memory: 1552K
> Freeing unused kernel image (rodata/data gap) memory: 804K
> x86/mm: Checked W+X mappings: passed, no W+X pages found.
> x86/mm: Checking user space page tables
> x86/mm: Checked W+X mappings: passed, no W+X pages found.
> Failed to set sysctl parameter 'max_rcu_stall_to_panic=3D1': parameter no=
t found
> Run /sbin/init as init process
> =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
> BUG: KASAN: slab-out-of-bounds in _raw_spin_lock+0x2e/0x40
> Read of size 1 at addr ffff88810eea9ce0 by task init/1
>
> CPU: 0 UID: 0 PID: 1 Comm: init Not tainted syzkaller #0 PREEMPT(full)
> Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS 1.16.2-debian-1.=
16.2-1 04/01/2014
> Call Trace:
>  <TASK>
>  dump_stack_lvl+0xe8/0x150
>  print_address_description+0x55/0x1e0
>  print_report+0x58/0x70
>  kasan_report+0x117/0x150
>  __kasan_check_byte+0x2a/0x40
>  lock_acquire+0x7d/0x350
>  _raw_spin_lock+0x2e/0x40
>  hook_sb_delete+0x15d/0xd10
>  security_sb_delete+0x76/0x110
>  generic_shutdown_super+0xb2/0x3d0
>  kill_anon_super+0x3b/0x70
>  proc_kill_sb+0x47/0x180
>  deactivate_locked_super+0xbc/0x110
>  cleanup_mnt+0x3d3/0x460
>  mntput_no_expire_slowpath+0xa58/0xbf0
>  __fput+0x6a4/0xa50
>  task_work_run+0x1d9/0x270
>  exit_to_user_mode_loop+0x204/0x770
>  ret_from_fork+0x593/0xb70
>  ret_from_fork_asm+0x1a/0x30
>  </TASK>
>
> Allocated by task 1:
>  kasan_save_track+0x3e/0x80
>  __kasan_kmalloc+0x93/0xb0
>  __kmalloc_flags_noprof+0x532/0x7a0
>  __alloc_empty_sheaf+0x28/0x40
>  __pcs_replace_empty_main+0x43b/0x6c0
>  kmem_cache_alloc_noprof+0x399/0x600
>  bio_alloc_bioset+0x271/0xc60
>  ext4_mpage_readpages+0x12a7/0x1c40
>  read_pages+0x193/0x5a0
>  page_cache_ra_unbounded+0x754/0x9d0
>  page_cache_ra_order+0xb47/0xee0
>  filemap_get_pages+0x86d/0x1ec0
>  filemap_read+0x426/0x11e0
>  ext4_file_read_iter+0x553/0xad0
>  __kernel_read+0x4ca/0x960
>  integrity_kernel_read+0x89/0xd0
>  ima_calc_file_hash+0x451/0x890
>  ima_collect_measurement+0x51b/0xa00
>  process_measurement+0x1272/0x1c10
>  ima_file_mmap+0x1b0/0x200
>  security_mmap_file+0x773/0xa20
>  vm_mmap_pgoff+0x134/0x4e0
>  elf_load+0x237/0x6a0
>  load_elf_interp+0x4da/0xb50
>  load_elf_binary+0x1bda/0x28d0
>  bprm_execve+0x930/0x1590
>  kernel_execve+0x8c3/0x9c0
>  try_to_run_init_process+0x13/0x60
>  kernel_init+0xb2/0x1d0
>  ret_from_fork+0x514/0xb70
>  ret_from_fork_asm+0x1a/0x30
>
> The buggy address belongs to the object at ffff88810eea9c00
>  which belongs to the cache kmalloc-128 of size 128
> The buggy address is located 96 bytes to the right of
>  allocated 128-byte region [ffff88810eea9c00, ffff88810eea9c80)
>
> The buggy address belongs to the physical page:
> page: refcount:0 mapcount:0 mapping:0000000000000000 index:0x0 pfn:0x10ee=
a9
> flags: 0x17ff00000000000(node=3D0|zone=3D2|lastcpupid=3D0x7ff)
> page_type: f5(slab)
> raw: 017ff00000000000 ffff888100041a00 dead000000000122 0000000000000000
> raw: 0000000000000000 0000000000100010 00000000f5000000 0000000000000000
> page dumped because: kasan: bad access detected
> page_owner tracks the page as allocated
> page last allocated via order 0, migratetype Unmovable, gfp_mask 0xd2c40(=
GFP_NOFS|__GFP_NOWARN|__GFP_NORETRY|__GFP_COMP|__GFP_NOMEMALLOC), pid 1, tg=
id 1 (swapper/0), ts 18944299736
>  post_alloc_hook+0x1f9/0x250
>  get_page_from_freelist+0x2209/0x2280
>  __alloc_frozen_pages_noprof+0x217/0x5a0
>  allocate_slab+0x7d/0x620
>  refill_objects+0x2d5/0x350
>  __pcs_replace_empty_main+0x2c8/0x6c0
>  __kmalloc_noprof+0x47b/0x720
>  tomoyo_commit_ok+0x29/0x1d0
>  tomoyo_update_domain+0x4ea/0x7e0
>  tomoyo_update_mount_acl+0x11c/0x2d0
>  tomoyo_write_file+0xae4/0xc50
>  tomoyo_supervisor+0xff8/0x1560
>  tomoyo_mount_permission+0x670/0x9e0
>  security_sb_mount+0xe4/0x320
>  path_mount+0xbc/0x1050
>  init_mount+0xc3/0x110
> page_owner free stack trace missing
>
> Memory state around the buggy address:
>  ffff88810eea9b80: fc fc fc fc fc fc fc fc fc fc fc fc fc fc fc fc
>  ffff88810eea9c00: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
> >ffff88810eea9c80: fc fc fc fc fc fc fc fc fc fc fc fc fc fc fc fc
>                                                        ^
>  ffff88810eea9d00: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
>  ffff88810eea9d80: fc fc fc fc fc fc fc fc fc fc fc fc fc fc fc fc
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
> To test a fix for this bug, please reply with `#syz test`
> (on a separate line) and attach the patch to the email.
>
> Notes:
> - The patch will be applied on top of the tested series (as an
>   incremental fix).
> - To test a new version of the whole series, please send it directly
>   to syzbot@lists.linux.dev.
> - Arguments like custom git repos and branches are not supported.
>
> The email will later be sent to:
> [adobriyan@gmail.com akpm@linux-foundation.org aleksa@amutable.com braune=
r@kernel.org dev.jain@arm.com ebiggers@kernel.org fangbaoshun@hygon.cn hpa@=
zytor.com huangsj@hygon.cn jack@suse.cz jannh@google.com joannelkoong@gmail=
.com joel.granados@kernel.org kees@kernel.org legion@kernel.org libaokun@li=
nux.alibaba.com linux-fsdevel@vger.kernel.org linux-kernel@vger.kernel.org =
ljs@kernel.org mjguzik@gmail.com oleg@redhat.com ryan.roberts@arm.com sande=
en@redhat.com tj@kernel.org viro@zeniv.linux.org.uk yingzhiwei@hygon.cn zho=
ngyuan@hygon.cn]
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
-upstream-moderation/6aa7b165.3aa11909.1a03b8.007a.GAE%40google.com.



--=20
=E2=B2=A0=E2=B2=9F=E2=B2=93=E2=B2=99=E2=B2=8F=E2=B2=9B =E2=B2=84=E2=B2=89=
=E2=B2=B1=E2=B2=A3=E2=B2=85=E2=B2=93=E2=B2=9F=E2=B2=A5 - Pimyn Girgis
Software Engineer
Kernel Dynamic Analysis
pimyn@google.com
