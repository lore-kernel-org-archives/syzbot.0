Received: from mail-ot1-f42.google.com (mail-ot1-f42.google.com [209.85.210.42])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2A9DB40DFDF
	for <syzbot@lists.linux.dev>; Sun, 26 Apr 2026 19:00:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.210.42
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777230041; cv=pass; b=sSohsSFK2HFNq9vAiw+3q02skQ/sK6T3M26hV6kyPmkPBx95x4hv9zb1VscblDcXdnqWnnEPAPG0sWHFCzGDiHhDxitj1XDQY0L5xvUJ2LzhroaUEo4CQb87KNmRB8wfMn4xHw6NCI9+cnC+M4b8rgc/fHSL57jAtsz8MnsoNEE=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777230041; c=relaxed/simple;
	bh=PKr9D4zuRRdbWrQZ4lOt1iIvTwSdtvYAPeCEJpOqgaM=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=EP/hR0+nqK6E4l8JBBclMeZ2h1k5ISan/t4D+ItnPzyuT7JQ/gRoG01evgE+LUlL7c/X1ESmj5QCG3dHgcmQzliRJjnT0IDuWc/d4JLmSZ9X5XIvx2WnnlQRnzufCIO/BG0TX1NHVRdiPVT+VkT9B+bb6UANmLFliUznlSRQamA=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=qIbE/QNP; arc=pass smtp.client-ip=209.85.210.42
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="qIbE/QNP"
Received: by mail-ot1-f42.google.com with SMTP id 46e09a7af769-7dca5f64e86so5884481a34.0
        for <syzbot@lists.linux.dev>; Sun, 26 Apr 2026 12:00:38 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1777230038; cv=none;
        d=google.com; s=arc-20240605;
        b=Lpu8tpJY7P4sOzfnyJF05P2DzAkAo7MWMsuqE6/unscGVnoVzz+eoPYPqh5DN6k2hN
         Zm0Wsl7Gxt45aOuk5ms4Hc5fPCGfUXlhJOolRrFfoMI4K6kwm8crRoB4auxdM+/lPZhX
         GtAQaZEegll+kAVe5NvZKCw2GQcDIePg96dZrKKh7nNVIUlxS8eI6K0RLRUoCVYNqVOV
         RZSKaq0lJHImtGF6/21BAsYWicXH+pGtpYHZCIokaBWcY/REeGAYMGnYM6swokKQzVZD
         zpFsfTE6PHj3CmqL/WxwPAPwSoMcwPwjYvxf9Mo2PnxBTqe0Dm3BIf5u2sluSA8Yw0aI
         xFYw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=uSE5FAH9RebysOC/waSswYPWiBidNvUekD4L4AUGqsQ=;
        fh=XbDbPOqGrlNp2mZ6Fu35zDlY5iUBSXtJ/CI923uCLOA=;
        b=cx10niZL+IvTtO/09bmStW7wDYVngnqSl48CoaxYnJhNY8Eoh45vgSZqlQ3G63MTJ1
         KKaHS/WQ0dN+nklvfC4Nn96u1sQuhwuyoNUY9E/ubppVSYZVIJ6VzUo1SJkVu4bH0Ufk
         +BeJrKjNXo8SwY6huvsp5vBUqInZODbhpNWwM/1iVXDDTpqwPalW6bA+rP3BKK4uFMj9
         xbeRnPT3BeUwk6r6xdtMjQfUegn/Hz276eNd5k7oktRVcmMcncFBV4HoMe/1LcOzEP7a
         drU8u73f7NBgxxL+tLUUnahmuCIQeJ583JM7bELqkuoYWv+exNHpEOPrSHZHxz4sQpWT
         CBBw==;
        darn=lists.linux.dev
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1777230038; x=1777834838; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=uSE5FAH9RebysOC/waSswYPWiBidNvUekD4L4AUGqsQ=;
        b=qIbE/QNPn6kVQL0Gr+XJtDylIcO44TFO42iXdmsucQOA6uq1vdFeTOoHjf3iAzz+aX
         wqPq7vQ0Poe4emiElClfC93515d5MS+wiK8WcDPr/wakxyR4doW+OMf1LtNMxjjR+wfk
         /EQvw4EL903+nsuafHcAQo4gpNQ9mID6sLnXty2IPBxi+jBS7r0ZaB3tjd0MvpxgtTy5
         TRfXVz6DSEjkZWBrj+wVNYxN+JJcpfVTqaGsXlUMjKtTsEUzb52av8LzU1TWW1MjFYCP
         R9Fc+4DmzlzA3f2aEoRLE4B0D0LBtymReELLaISZuDi1xN8+a5xi586e1kw6wvO5j1sl
         daUw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1777230038; x=1777834838;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=uSE5FAH9RebysOC/waSswYPWiBidNvUekD4L4AUGqsQ=;
        b=G4ky8KwYZM3X6UKDYM85fq6/6NwljqL2W4SCZwkeQ0OkU39DTFBbAOIdrr/xvvdXNF
         AyE271FwUDlLTNeF9GGRYHuVbXpjRvICG4dd2gg8qgMGZcIWfk1cBAufHJTtIgdv4R2+
         +esw8UPNOiDrtyicqqsISDF+L043bdeFyEeEdHUi/BJKfulAMTO2qOoJn83FP7S8YGDL
         uqpW7X/M6Fi3pM49KToYKfb+ATKyXh4qYfz8OhGsGA1uvDRlpPOYUBV2fGq2Ta4VSe3t
         aez/6jw+3n8nyIxcgn5Gf8TZnHKaW/sBNDob/spx3pLEmLoyDeVRAAgDBk7N4Po55m+w
         F/2w==
X-Forwarded-Encrypted: i=1; AFNElJ84gz0vU4tFAx30VG3VTVwdW2kY271nP1IvqRpq6mIGhOdSILYxwP7gg4mGC7d4nFd2qypkYXs=@lists.linux.dev
X-Gm-Message-State: AOJu0YzSEvQInqXMfRkJKyri469bDGUXKS2Rxkk1lx64EamePZ1HInn7
	UVEHT93nWuBcnDZs6bDz6Boob+iNw6C5pOd4bd7Nrr3ct2vnZHr83f9AWr6ZxxyAeYxGkaBivUq
	ywfKfBd2OvIdliFaZA5cxrU/PsBUlSXSq/EBNDlx2
X-Gm-Gg: AeBDies/xcG0WQ5AA8pYnf77MdTSOKg+2NwMouo861dwrOZyl0XXXE1uwBbQM0K3GGG
	S7SQcYJYa2h/ySpvijqAqdPc0xVJvZY2Ne7sX1U7pUASSIK6yBTN3MXUHo9YrtJdwUuvKulXvW0
	tHN8OIsoaJm3DUJ4KPT5QFc/+Oq4bh+vzFs4D/kdbPDurhRPEzMnGl6gsiWsncmaZnERX6/mV4U
	CzUb2daKbuYORZhGv2mY+KZCUsRwX8xaEMvISTtmJAw1CtoPby2aG3TdaH4djx7vqON8fMAAuAY
	xiRqCebyLfMUaJR0KMt+B1MaBdt7Nl1yJ5ZGR26yD1G9fEUh4WexWlm7MhCtnM/LkKGgjNko2Ln
	1Vj5ZkAsk9lDWuSTD
X-Received: by 2002:a05:6820:f032:b0:694:9070:8228 with SMTP id
 006d021491bc7-6949070842emr15101833eaf.47.1777230037396; Sun, 26 Apr 2026
 12:00:37 -0700 (PDT)
Precedence: bulk
X-Mailing-List: syzbot@lists.linux.dev
List-Id: <syzbot.lists.linux.dev>
List-Subscribe: <mailto:syzbot+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:syzbot+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <69ee47c6.a00a0220.316485.0005.GAE@google.com>
In-Reply-To: <69ee47c6.a00a0220.316485.0005.GAE@google.com>
From: Aleksandr Nogikh <nogikh@google.com>
Date: Sun, 26 Apr 2026 21:00:25 +0200
X-Gm-Features: AVHnY4IN3VZdyl0Nch3ReXMkjneUInu3IEknyhIdyjXpsuxgn1pGFMpOPqNTpFE
Message-ID: <CANp29Y7-zT0PV81y+NxoMPsQ0JjJQ2UTWGNsd-gh0Og240Z3YQ@mail.gmail.com>
Subject: Re: [moderation/CI] Re: Implement a new generic pagewalk API
To: syzbot ci <syzbot+ci373afc5fb5256d32@syzkaller.appspotmail.com>
Cc: syzkaller-upstream-moderation@googlegroups.com, syzbot@lists.linux.dev
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

#syz upstream

On Sun, Apr 26, 2026 at 7:13=E2=80=AFPM syzbot ci
<syzbot+ci373afc5fb5256d32@syzkaller.appspotmail.com> wrote:
>
> syzbot ci has tested the following series
>
> [v2] Implement a new generic pagewalk API
> https://lore.kernel.org/all/20260426125719.24698-1-osalvador@suse.de
> * [RFC PATCH v2 1/7] mm: Add softleaf_from_pud
> * [RFC PATCH v2 2/7] mm: Add {pmd,pud}_huge_lock helper
> * [RFC PATCH v2 3/7] mm: Implement folio_pmd_batch
> * [RFC PATCH v2 4/7] mm: Implement pt_range_walk
> * [RFC PATCH v2 5/7] mm: Make /proc/pid/smaps use the new generic pagewal=
k API
> * [RFC PATCH v2 6/7] mm: Make /proc/pid/numa_maps use the new generic pag=
ewalk API
> * [RFC PATCH v2 7/7] mm: Make /proc/pid/pagemap use the new generic pagew=
alk API
>
> and found the following issues:
> * KASAN: slab-out-of-bounds Write in pagemap_read
> * WARNING in __page_table_check_pmds_set
> * WARNING in pt_range_walk
> * WARNING: bad unlock balance in pt_range_walk
>
> Full report is available here:
> https://ci.syzbot.org/series/409219de-ca42-45a5-9204-0b315095160c
>
> ***
>
> KASAN: slab-out-of-bounds Write in pagemap_read
>
> tree:      mm-new
> URL:       https://kernel.googlesource.com/pub/scm/linux/kernel/git/akpm/=
mm.git
> base:      819bd270abf9de3b7f306e233054b85a07c47820
> arch:      amd64
> compiler:  Debian clang version 21.1.8 (++20251221033036+2078da43e25a-1~e=
xp1~20251221153213.50), Debian LLD 21.1.8
> config:    https://ci.syzbot.org/builds/0361816f-57b2-43e4-aef2-186d8d35f=
dc9/config
> syz repro: https://ci.syzbot.org/findings/7f740037-7398-46f2-aa01-a57caa1=
86d06/syz_repro
>
> =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
> BUG: KASAN: slab-out-of-bounds in add_to_pagemap fs/proc/task_mmu.c:1776 =
[inline]
> BUG: KASAN: slab-out-of-bounds in pagemap_read_walk_range fs/proc/task_mm=
u.c:2949 [inline]
> BUG: KASAN: slab-out-of-bounds in pagemap_read+0x1d60/0x2810 fs/proc/task=
_mmu.c:3092
> Write of size 8 at addr ffff88816f1bd000 by task syz.1.18/5957
>
> CPU: 1 UID: 0 PID: 5957 Comm: syz.1.18 Not tainted syzkaller #0 PREEMPT(f=
ull)
> Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS 1.16.2-debian-1.=
16.2-1 04/01/2014
> Call Trace:
>  <TASK>
>  dump_stack_lvl+0xe8/0x150 lib/dump_stack.c:120
>  print_address_description mm/kasan/report.c:378 [inline]
>  print_report+0xba/0x230 mm/kasan/report.c:482
>  kasan_report+0x117/0x150 mm/kasan/report.c:595
>  add_to_pagemap fs/proc/task_mmu.c:1776 [inline]
>  pagemap_read_walk_range fs/proc/task_mmu.c:2949 [inline]
>  pagemap_read+0x1d60/0x2810 fs/proc/task_mmu.c:3092
>  vfs_read+0x20c/0xa70 fs/read_write.c:572
>  ksys_pread64 fs/read_write.c:765 [inline]
>  __do_sys_pread64 fs/read_write.c:773 [inline]
>  __se_sys_pread64 fs/read_write.c:770 [inline]
>  __x64_sys_pread64+0x199/0x230 fs/read_write.c:770
>  do_syscall_x64 arch/x86/entry/syscall_64.c:63 [inline]
>  do_syscall_64+0x14d/0xf80 arch/x86/entry/syscall_64.c:94
>  entry_SYSCALL_64_after_hwframe+0x77/0x7f
> RIP: 0033:0x7f340679cdd9
> Code: ff c3 66 2e 0f 1f 84 00 00 00 00 00 0f 1f 44 00 00 48 89 f8 48 89 f=
7 48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 ff=
 ff 73 01 c3 48 c7 c1 e8 ff ff ff f7 d8 64 89 01 48
> RSP: 002b:00007f34075d2028 EFLAGS: 00000246 ORIG_RAX: 0000000000000011
> RAX: ffffffffffffffda RBX: 00007f3406a15fa0 RCX: 00007f340679cdd9
> RDX: 0000000000019020 RSI: 0000200000000200 RDI: 0000000000000003
> RBP: 00007f3406832d69 R08: 0000000000000000 R09: 0000000000000000
> R10: 0000001000000000 R11: 0000000000000246 R12: 0000000000000000
> R13: 00007f3406a16038 R14: 00007f3406a15fa0 R15: 00007ffdb721f7e8
>  </TASK>
>
> Allocated by task 5957:
>  kasan_save_stack mm/kasan/common.c:57 [inline]
>  kasan_save_track+0x3e/0x80 mm/kasan/common.c:78
>  poison_kmalloc_redzone mm/kasan/common.c:398 [inline]
>  __kasan_kmalloc+0x93/0xb0 mm/kasan/common.c:415
>  kasan_kmalloc include/linux/kasan.h:263 [inline]
>  __kmalloc_cache_noprof+0x31c/0x660 mm/slub.c:5339
>  kmalloc_noprof include/linux/slab.h:962 [inline]
>  kmalloc_array_noprof include/linux/slab.h:1109 [inline]
>  pagemap_read+0x27d/0x2810 fs/proc/task_mmu.c:3033
>  vfs_read+0x20c/0xa70 fs/read_write.c:572
>  ksys_pread64 fs/read_write.c:765 [inline]
>  __do_sys_pread64 fs/read_write.c:773 [inline]
>  __se_sys_pread64 fs/read_write.c:770 [inline]
>  __x64_sys_pread64+0x199/0x230 fs/read_write.c:770
>  do_syscall_x64 arch/x86/entry/syscall_64.c:63 [inline]
>  do_syscall_64+0x14d/0xf80 arch/x86/entry/syscall_64.c:94
>  entry_SYSCALL_64_after_hwframe+0x77/0x7f
>
> The buggy address belongs to the object at ffff88816f1bc000
>  which belongs to the cache kmalloc-4k of size 4096
> The buggy address is located 0 bytes to the right of
>  allocated 4096-byte region [ffff88816f1bc000, ffff88816f1bd000)
>
> The buggy address belongs to the physical page:
> page: refcount:0 mapcount:0 mapping:0000000000000000 index:0xffff88816f1b=
8000 pfn:0x16f1b8
> head: order:3 mapcount:0 entire_mapcount:0 nr_pages_mapped:0 pincount:0
> flags: 0x57ff00000000240(workingset|head|node=3D1|zone=3D2|lastcpupid=3D0=
x7ff)
> page_type: f5(slab)
> raw: 057ff00000000240 ffff888100042140 ffff888160400a08 ffffea0005c6fe10
> raw: ffff88816f1b8000 0000000000040003 00000000f5000000 0000000000000000
> head: 057ff00000000240 ffff888100042140 ffff888160400a08 ffffea0005c6fe10
> head: ffff88816f1b8000 0000000000040003 00000000f5000000 0000000000000000
> head: 057ff00000000003 ffffea0005bc6e01 00000000ffffffff 00000000ffffffff
> head: ffffffffffffffff 0000000000000000 00000000ffffffff 0000000000000008
> page dumped because: kasan: bad access detected
> page_owner tracks the page as allocated
> page last allocated via order 3, migratetype Unmovable, gfp_mask 0xd2040(=
__GFP_IO|__GFP_NOWARN|__GFP_NORETRY|__GFP_COMP|__GFP_NOMEMALLOC), pid 5715,=
 tgid 5715 (rm), ts 50636400155, free_ts 46909302793
>  set_page_owner include/linux/page_owner.h:32 [inline]
>  post_alloc_hook+0x231/0x280 mm/page_alloc.c:1889
>  prep_new_page mm/page_alloc.c:1897 [inline]
>  get_page_from_freelist+0x24dc/0x2580 mm/page_alloc.c:3962
>  __alloc_frozen_pages_noprof+0x18d/0x380 mm/page_alloc.c:5250
>  alloc_slab_page mm/slub.c:3255 [inline]
>  allocate_slab+0x77/0x660 mm/slub.c:3444
>  new_slab mm/slub.c:3502 [inline]
>  refill_objects+0x331/0x3c0 mm/slub.c:7134
>  refill_sheaf mm/slub.c:2804 [inline]
>  __pcs_replace_empty_main+0x2b9/0x620 mm/slub.c:4578
>  alloc_from_pcs mm/slub.c:4681 [inline]
>  slab_alloc_node mm/slub.c:4815 [inline]
>  __do_kmalloc_node mm/slub.c:5218 [inline]
>  __kmalloc_noprof+0x474/0x760 mm/slub.c:5231
>  kmalloc_noprof include/linux/slab.h:966 [inline]
>  tomoyo_realpath_from_path+0xe3/0x5d0 security/tomoyo/realpath.c:251
>  tomoyo_get_realpath security/tomoyo/file.c:151 [inline]
>  tomoyo_path_perm+0x283/0x560 security/tomoyo/file.c:827
>  tomoyo_path_unlink+0xaa/0xf0 security/tomoyo/tomoyo.c:162
>  security_path_unlink+0x15f/0x330 security/security.c:1457
>  filename_unlinkat+0x349/0x610 fs/namei.c:5537
>  __do_sys_unlink fs/namei.c:5575 [inline]
>  __se_sys_unlink+0x2e/0x140 fs/namei.c:5572
>  do_syscall_x64 arch/x86/entry/syscall_64.c:63 [inline]
>  do_syscall_64+0x14d/0xf80 arch/x86/entry/syscall_64.c:94
>  entry_SYSCALL_64_after_hwframe+0x77/0x7f
> page last free pid 5257 tgid 5257 stack trace:
>  reset_page_owner include/linux/page_owner.h:25 [inline]
>  __free_pages_prepare mm/page_alloc.c:1433 [inline]
>  __free_frozen_pages+0xc2b/0xdb0 mm/page_alloc.c:2978
>  __slab_free+0x263/0x2b0 mm/slub.c:5532
>  qlink_free mm/kasan/quarantine.c:163 [inline]
>  qlist_free_all+0x97/0x100 mm/kasan/quarantine.c:179
>  kasan_quarantine_reduce+0x148/0x160 mm/kasan/quarantine.c:286
>  __kasan_slab_alloc+0x22/0x80 mm/kasan/common.c:350
>  kasan_slab_alloc include/linux/kasan.h:253 [inline]
>  slab_post_alloc_hook mm/slub.c:4501 [inline]
>  slab_alloc_node mm/slub.c:4830 [inline]
>  kmem_cache_alloc_noprof+0x2bc/0x650 mm/slub.c:4837
>  alloc_filename fs/namei.c:142 [inline]
>  do_getname+0x2e/0x250 fs/namei.c:182
>  getname_flags fs/namei.c:225 [inline]
>  getname include/linux/fs.h:2512 [inline]
>  class_filename_constructor include/linux/fs.h:2539 [inline]
>  __do_sys_unlink fs/namei.c:5574 [inline]
>  __se_sys_unlink+0x1e/0x140 fs/namei.c:5572
>  do_syscall_x64 arch/x86/entry/syscall_64.c:63 [inline]
>  do_syscall_64+0x14d/0xf80 arch/x86/entry/syscall_64.c:94
>  entry_SYSCALL_64_after_hwframe+0x77/0x7f
>
> Memory state around the buggy address:
>  ffff88816f1bcf00: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
>  ffff88816f1bcf80: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
> >ffff88816f1bd000: fc fc fc fc fc fc fc fc fc fc fc fc fc fc fc fc
>                    ^
>  ffff88816f1bd080: fc fc fc fc fc fc fc fc fc fc fc fc fc fc fc fc
>  ffff88816f1bd100: fc fc fc fc fc fc fc fc fc fc fc fc fc fc fc fc
> =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
>
>
> ***
>
> WARNING in __page_table_check_pmds_set
>
> tree:      mm-new
> URL:       https://kernel.googlesource.com/pub/scm/linux/kernel/git/akpm/=
mm.git
> base:      819bd270abf9de3b7f306e233054b85a07c47820
> arch:      amd64
> compiler:  Debian clang version 21.1.8 (++20251221033036+2078da43e25a-1~e=
xp1~20251221153213.50), Debian LLD 21.1.8
> config:    https://ci.syzbot.org/builds/0361816f-57b2-43e4-aef2-186d8d35f=
dc9/config
> syz repro: https://ci.syzbot.org/findings/f8fe52b4-cef7-4d25-8e60-cbbb1a4=
f4df5/syz_repro
>
> ------------[ cut here ]------------
> softleaf_cached_writable(entry)
> WARNING: mm/page_table_check.c:227 at page_table_check_pmd_flags mm/page_=
table_check.c:227 [inline], CPU#1: syz.0.17/6022
> WARNING: mm/page_table_check.c:227 at __page_table_check_pmds_set+0x18e/0=
x340 mm/page_table_check.c:240, CPU#1: syz.0.17/6022
> Modules linked in:
> CPU: 1 UID: 0 PID: 6022 Comm: syz.0.17 Not tainted syzkaller #0 PREEMPT(f=
ull)
> Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS 1.16.2-debian-1.=
16.2-1 04/01/2014
> RIP: 0010:page_table_check_pmd_flags mm/page_table_check.c:227 [inline]
> RIP: 0010:__page_table_check_pmds_set+0x18e/0x340 mm/page_table_check.c:2=
40
> Code: 89 fe e8 85 44 89 ff 48 b8 00 00 00 00 00 00 00 94 4c 01 f8 48 c1 e=
8 3b 0f 94 c0 4d 39 e5 76 0f 84 c0 74 0b e8 83 3f 89 ff 90 <0f> 0b 90 eb 05=
 e8 78 3f 89 ff 31 ff 89 ee e8 af 43 89 ff 41 89 ef
> RSP: 0018:ffffc90003ce7af8 EFLAGS: 00010293
> RAX: ffffffff823c4d7d RBX: ffff888111416001 RCX: ffff88816cbd1d00
> RDX: 0000000000000000 RSI: 6c00000000000000 RDI: 6c00000000000000
> RBP: 0000000000000001 R08: 0000000000000001 R09: 0000000000000003
> R10: 0000000000000002 R11: 0000000000000000 R12: c7fffffffffffffe
> R13: dfffffffdc9bfe06 R14: ffff888111416008 R15: 6c00000000000000
> FS:  00007ff0386af6c0(0000) GS:ffff8882a9466000(0000) knlGS:0000000000000=
000
> CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> CR2: 0000555574a1a9e8 CR3: 00000001063c6000 CR4: 00000000000006f0
> Call Trace:
>  <TASK>
>  page_table_check_pmds_set include/linux/page_table_check.h:92 [inline]
>  set_pmd_at arch/x86/include/asm/pgtable.h:1234 [inline]
>  make_uffd_wp_pmd fs/proc/task_mmu.c:1903 [inline]
>  pagemap_scan_walk fs/proc/task_mmu.c:2631 [inline]
>  do_pagemap_scan fs/proc/task_mmu.c:2785 [inline]
>  do_pagemap_cmd+0x3bd8/0x4310 fs/proc/task_mmu.c:3131
>  vfs_ioctl fs/ioctl.c:51 [inline]
>  __do_sys_ioctl fs/ioctl.c:597 [inline]
>  __se_sys_ioctl+0xfc/0x170 fs/ioctl.c:583
>  do_syscall_x64 arch/x86/entry/syscall_64.c:63 [inline]
>  do_syscall_64+0x14d/0xf80 arch/x86/entry/syscall_64.c:94
>  entry_SYSCALL_64_after_hwframe+0x77/0x7f
> RIP: 0033:0x7ff03779cdd9
> Code: ff c3 66 2e 0f 1f 84 00 00 00 00 00 0f 1f 44 00 00 48 89 f8 48 89 f=
7 48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 ff=
 ff 73 01 c3 48 c7 c1 e8 ff ff ff f7 d8 64 89 01 48
> RSP: 002b:00007ff0386af028 EFLAGS: 00000246 ORIG_RAX: 0000000000000010
> RAX: ffffffffffffffda RBX: 00007ff037a16090 RCX: 00007ff03779cdd9
> RDX: 00002000000001c0 RSI: 00000000c0606610 RDI: 0000000000000003
> RBP: 00007ff037832d69 R08: 0000000000000000 R09: 0000000000000000
> R10: 0000000000000000 R11: 0000000000000246 R12: 0000000000000000
> R13: 00007ff037a16128 R14: 00007ff037a16090 R15: 00007ffd47ec5488
>  </TASK>
>
>
> ***
>
> WARNING in pt_range_walk
>
> tree:      mm-new
> URL:       https://kernel.googlesource.com/pub/scm/linux/kernel/git/akpm/=
mm.git
> base:      819bd270abf9de3b7f306e233054b85a07c47820
> arch:      amd64
> compiler:  Debian clang version 21.1.8 (++20251221033036+2078da43e25a-1~e=
xp1~20251221153213.50), Debian LLD 21.1.8
> config:    https://ci.syzbot.org/builds/0361816f-57b2-43e4-aef2-186d8d35f=
dc9/config
> syz repro: https://ci.syzbot.org/findings/02bfe437-a81f-4510-9fff-4b769eb=
9a0a4/syz_repro
>
> ------------[ cut here ]------------
> next_addr < vma->vm_start || next_addr >=3D vma->vm_end
> WARNING: mm/pagewalk.c:1052 at pt_range_walk+0x14e/0x35a0 mm/pagewalk.c:1=
052, CPU#1: syz.2.19/6013
> Modules linked in:
> CPU: 1 UID: 0 PID: 6013 Comm: syz.2.19 Not tainted syzkaller #0 PREEMPT(f=
ull)
> Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS 1.16.2-debian-1.=
16.2-1 04/01/2014
> RIP: 0010:pt_range_walk+0x14e/0x35a0 mm/pagewalk.c:1052
> Code: 74 08 48 89 df e8 12 1a 15 00 49 89 de 48 8b 1b 48 8b 7c 24 10 48 8=
9 de e8 6f a5 aa ff 48 39 5c 24 10 73 13 e8 03 a3 aa ff 90 <0f> 0b 90 b8 01=
 00 00 00 e9 88 2b 00 00 49 8d 5e 08 48 89 d8 48 c1
> RSP: 0018:ffffc90003d37920 EFLAGS: 00010293
> RAX: ffffffff821b11f0 RBX: 0000200000800000 RCX: ffff8881134f5700
> RDX: 0000000000000000 RSI: 0000200000800000 RDI: 0000200000800000
> RBP: ffffc90003d37b30 R08: 00000000000000ff R09: 1ffff1102dc8b830
> R10: dffffc0000000000 R11: ffffed102dc8b831 R12: ffff8881709b1800
> R13: dffffc0000000000 R14: ffff8881709b1800 R15: 0000200000800000
> FS:  00007f33141ff6c0(0000) GS:ffff8882a9466000(0000) knlGS:0000000000000=
000
> CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> CR2: 00007f331344f0d1 CR3: 000000017150e000 CR4: 00000000000006f0
> Call Trace:
>  <TASK>
>  pagemap_scan_walk fs/proc/task_mmu.c:2463 [inline]
>  do_pagemap_scan fs/proc/task_mmu.c:2785 [inline]
>  do_pagemap_cmd+0x3924/0x4310 fs/proc/task_mmu.c:3131
>  vfs_ioctl fs/ioctl.c:51 [inline]
>  __do_sys_ioctl fs/ioctl.c:597 [inline]
>  __se_sys_ioctl+0xfc/0x170 fs/ioctl.c:583
>  do_syscall_x64 arch/x86/entry/syscall_64.c:63 [inline]
>  do_syscall_64+0x14d/0xf80 arch/x86/entry/syscall_64.c:94
>  entry_SYSCALL_64_after_hwframe+0x77/0x7f
> RIP: 0033:0x7f331339cdd9
> Code: ff c3 66 2e 0f 1f 84 00 00 00 00 00 0f 1f 44 00 00 48 89 f8 48 89 f=
7 48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 ff=
 ff 73 01 c3 48 c7 c1 e8 ff ff ff f7 d8 64 89 01 48
> RSP: 002b:00007f33141ff028 EFLAGS: 00000246 ORIG_RAX: 0000000000000010
> RAX: ffffffffffffffda RBX: 00007f3313615fa0 RCX: 00007f331339cdd9
> RDX: 0000200000000140 RSI: 00000000c0606610 RDI: 0000000000000003
> RBP: 00007f3313432d69 R08: 0000000000000000 R09: 0000000000000000
> R10: 0000000000000000 R11: 0000000000000246 R12: 0000000000000000
> R13: 00007f3313616038 R14: 00007f3313615fa0 R15: 00007fff980e14d8
>  </TASK>
>
>
> ***
>
> WARNING: bad unlock balance in pt_range_walk
>
> tree:      mm-new
> URL:       https://kernel.googlesource.com/pub/scm/linux/kernel/git/akpm/=
mm.git
> base:      819bd270abf9de3b7f306e233054b85a07c47820
> arch:      amd64
> compiler:  Debian clang version 21.1.8 (++20251221033036+2078da43e25a-1~e=
xp1~20251221153213.50), Debian LLD 21.1.8
> config:    https://ci.syzbot.org/builds/0361816f-57b2-43e4-aef2-186d8d35f=
dc9/config
> syz repro: https://ci.syzbot.org/findings/1e53935d-6673-468b-905d-88da8f1=
e39f3/syz_repro
>
> loop1: detected capacity change from 0 to 4096
> =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
> WARNING: bad unlock balance detected!
> syzkaller #0 Not tainted
> -------------------------------------
> syz.1.18/5968 is trying to release lock (ptlock_ptr(ptdesc)) at:
> [<ffffffff821aeb0a>] spin_unlock include/linux/spinlock.h:389 [inline]
> [<ffffffff821aeb0a>] pt_range_walk+0x25a/0x35a0 mm/pagewalk.c:1058
> but there are no more locks to release!
>
> other info that might help us debug this:
> 1 lock held by syz.1.18/5968:
>  #0: ffff8881626b0340 (&mm->mmap_lock){++++}-{4:4}, at: mmap_read_lock_ki=
llable include/linux/mmap_lock.h:601 [inline]
>  #0: ffff8881626b0340 (&mm->mmap_lock){++++}-{4:4}, at: do_pagemap_scan f=
s/proc/task_mmu.c:2746 [inline]
>  #0: ffff8881626b0340 (&mm->mmap_lock){++++}-{4:4}, at: do_pagemap_cmd+0x=
618/0x4310 fs/proc/task_mmu.c:3131
>
> stack backtrace:
> CPU: 1 UID: 0 PID: 5968 Comm: syz.1.18 Not tainted syzkaller #0 PREEMPT(f=
ull)
> Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS 1.16.2-debian-1.=
16.2-1 04/01/2014
> Call Trace:
>  <TASK>
>  dump_stack_lvl+0xe8/0x150 lib/dump_stack.c:120
>  print_unlock_imbalance_bug+0xdc/0xf0 kernel/locking/lockdep.c:5298
>  __lock_release kernel/locking/lockdep.c:5537 [inline]
>  lock_release+0x248/0x3d0 kernel/locking/lockdep.c:5889
>  __raw_spin_unlock include/linux/spinlock_api_smp.h:167 [inline]
>  _raw_spin_unlock+0x16/0x50 kernel/locking/spinlock.c:186
>  spin_unlock include/linux/spinlock.h:389 [inline]
>  pt_range_walk+0x25a/0x35a0 mm/pagewalk.c:1058
>  pagemap_scan_walk fs/proc/task_mmu.c:2463 [inline]
>  do_pagemap_scan fs/proc/task_mmu.c:2785 [inline]
>  do_pagemap_cmd+0x3924/0x4310 fs/proc/task_mmu.c:3131
>  vfs_ioctl fs/ioctl.c:51 [inline]
>  __do_sys_ioctl fs/ioctl.c:597 [inline]
>  __se_sys_ioctl+0xfc/0x170 fs/ioctl.c:583
>  do_syscall_x64 arch/x86/entry/syscall_64.c:63 [inline]
>  do_syscall_64+0x14d/0xf80 arch/x86/entry/syscall_64.c:94
>  entry_SYSCALL_64_after_hwframe+0x77/0x7f
> RIP: 0033:0x7f0ce439cdd9
> Code: ff c3 66 2e 0f 1f 84 00 00 00 00 00 0f 1f 44 00 00 48 89 f8 48 89 f=
7 48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 ff=
 ff 73 01 c3 48 c7 c1 e8 ff ff ff f7 d8 64 89 01 48
> RSP: 002b:00007f0ce5214028 EFLAGS: 00000246 ORIG_RAX: 0000000000000010
> RAX: ffffffffffffffda RBX: 00007f0ce4615fa0 RCX: 00007f0ce439cdd9
> RDX: 0000200000000140 RSI: 00000000c0606610 RDI: 0000000000000004
> RBP: 00007f0ce4432d69 R08: 0000000000000000 R09: 0000000000000000
> R10: 0000000000000000 R11: 0000000000000246 R12: 0000000000000000
> R13: 00007f0ce4616038 R14: 00007f0ce4615fa0 R15: 00007fffbeb73768
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
> [akpm@linux-foundation.org david@kernel.org david@redhat.com linux-kernel=
@vger.kernel.org linux-mm@kvack.org lorenzo.stoakes@oracle.com mhocko@suse.=
com muchun.song@linux.dev osalvador@suse.de vbabka@kernel.org]
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
-upstream-moderation/69ee47c6.a00a0220.316485.0005.GAE%40google.com.
