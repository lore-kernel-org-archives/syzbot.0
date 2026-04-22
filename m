Received: from mail-lj1-f171.google.com (mail-lj1-f171.google.com [209.85.208.171])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CF213372B26
	for <syzbot@lists.linux.dev>; Wed, 22 Apr 2026 09:34:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.171
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776850469; cv=none; b=BOR2AcdNrukYyf8H1wo160aCURWsKuHhZKcuuR+9+8VyK64CjwXVYf8DtTDppp4bmjXh35nV+2BIc8EO16fDvkBIz82H4Y0h6MzXaTgDPCLTeKb8DccYg8wIrVEYsTTtYyr5B1ebuQPdmKp7GSfi1rJNOQNn+PojkiaRpDQu5Nc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776850469; c=relaxed/simple;
	bh=qFAZe+FQH1eIodSLEJdfYvj5YJi3ZOBmWhDkdMFbvRU=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=ob56Fh3v91RFMGPwRAQvqzAHpowNBjcypF3l7h1sJFETHjXVIDSJWWMML2wKf9N6oy4S5UYUPkDwwiuVxqFSc8TXcYFFyUImAtXBQlGm19b/Gmn69ri6uT5R2D0IBbWrVTry1lZ8R+ROVCNeyzYh7lFddZuqZyOLo3Z7BpsuUcM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=oSeJujC/; arc=none smtp.client-ip=209.85.208.171
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="oSeJujC/"
Received: by mail-lj1-f171.google.com with SMTP id 38308e7fff4ca-38e9653b580so54575371fa.2
        for <syzbot@lists.linux.dev>; Wed, 22 Apr 2026 02:34:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1776850462; x=1777455262; darn=lists.linux.dev;
        h=mime-version:content-language:accept-language:in-reply-to
         :references:message-id:date:thread-index:thread-topic:subject:cc:to
         :from:from:to:cc:subject:date:message-id:reply-to;
        bh=TA57e4UZRsBVBmateWqbzAAg3N5O2/ARyvd+0kn2GlM=;
        b=oSeJujC/Pb+Re0Iu4dJE+CuKxrjko/FSjib7bITmUObdA68MUE1DrjNCYeEcr6kvp/
         v3v1ylhoRCTt+dVtzbQsOUK6VK91yPY5Jde86n74sFTq+Q9wMw4936zQd0bve6GyDgKx
         ktF5FCaJz8xr7pneEe8MPTFyLLYDx0CqGC4s4VY0qDkVvUt2khVcVlvsYuTSnxidZCnM
         Z0wyz41ABraO7xOrY31GyBmLFeGWxc6dkrFATk2R9HOh0goSy3Fx7ljSnGb8g0/u9esU
         ALpyRLJK/OVFsPXoLPdeiE3m7LteTSjO0VJuIrKXlXQyisqR34u9STCIRLO/Bv+nYjtQ
         F0hw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1776850462; x=1777455262;
        h=mime-version:content-language:accept-language:in-reply-to
         :references:message-id:date:thread-index:thread-topic:subject:cc:to
         :from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=TA57e4UZRsBVBmateWqbzAAg3N5O2/ARyvd+0kn2GlM=;
        b=M5DOVT+AI8O3zEPlxX6ZQXIPqfTRZMgpBGNzQrqswG93B9s0IonmvL1ifb1EfN66Xg
         OnVsXG4bMkyGen5kZhP2KEHtRDB+eaIZU97CDvyvPnBu6hJHGVhTIpSYzlhzGEZnENC2
         aLpNWgEfLF8R+5QKeJoQCFwWW4LHYDbZvYy3S3fCjLJkmUcaNUZiveSjfOYV8dxh63Bw
         TdjlGVxjQ/KbNKuYVzA7Nc6Ey4yTQX+vngh7yTU4X9M1bsKnxGUIxRo4SlRvAmYsFp8d
         o7aset2kv2u4rLF96sWy3sp8jlKtmwogfVy8s/g9R89DT/KFjuPAYLKlOMSGfQDhf3qL
         Ltlg==
X-Gm-Message-State: AOJu0Yw9ScHNMoKFZ4Etm+oMiZNIo4XfxMi0SXFkf4xpdkOhdaIVaSMi
	KXu1ErBcSH27S+xemPFAyLNfBJDqGgJFvnEjuI0PhE4fpRZGFPFDNG7kJYm5LQ==
X-Gm-Gg: AeBDiet6XgWaVneuykkQPA4ZSGbcUDTYjJE4Zo6AIGdAsIaMCax5M+eyxvyr50e30OL
	1NF9OTEFYGbSZifbnI5V8eIT9tfv7BhMY1iz40EAIZXQEvNnqSsoMDY/cWK+odOt2rLnq5Fibah
	ToQpDKfe3ytDubSe6JWa3Pv+FfA5qq/jVDROof7EDcqGm5d1dfKs11a1Vn9kbEutoylMC3Xpoxq
	45+YevGxcZ4puIR3nRGM/YjqxSTlYhGxzU1ca7sb4IURB4JtMDl7ZDgJrAWKGXAEMx5hOJJudWP
	wTViA4FILhRBQWciP8WMemYnYUrU2pLKE3PkvT36iQLgL5kkwl/KoaHwaVsYzS7hvxA7v/jtFNf
	rvxf4fb1cvIZdOcOuFWuY4zT7fXN0Lu788K4JcakYbbiiSsPKex2G55v6dN7pJVp6QDntoHR87M
	fAZ664oKSG93I8kpn0MTSp56fPnwT05db1/uZILV1dRBSDD5s/aFHY+p3sjT1OFK86Wr3nzLwnD
	EyDRmU3k5RgLJI3Y3CjKyrC60c6o4Gh5h4=
X-Received: by 2002:a2e:a549:0:b0:38e:1ebe:95f6 with SMTP id 38308e7fff4ca-38ec7b2a3camr73797211fa.28.1776850461041;
        Wed, 22 Apr 2026 02:34:21 -0700 (PDT)
Received: from GV2P190MB2754.EURP190.PROD.OUTLOOK.COM ([2603:1026:c11:cf5::5])
        by smtp.gmail.com with ESMTPSA id 38308e7fff4ca-38ecb6f0b6dsm35553621fa.20.2026.04.22.02.34.19
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 22 Apr 2026 02:34:20 -0700 (PDT)
From: Artem Blagodarenko <artem.blagodarenko@gmail.com>
To: syzbot ci <syzbot+ci6167b51351f50705@syzkaller.appspotmail.com>
CC: "syzbot@lists.linux.dev" <syzbot@lists.linux.dev>
Subject: Re: [syzbot ci] Re: Data in direntry (dirdata) feature
Thread-Topic: [syzbot ci] Re: Data in direntry (dirdata) feature
Thread-Index: AQHczv9kqjFe4WaKskKWPurb2hZQrLXq2DFd
X-MS-Exchange-MessageSentRepresentingType: 1
Date: Wed, 22 Apr 2026 09:34:19 +0000
Message-ID:
	<GV2P190MB275499A44FE1E8F8C1AF3A8FAB2D2@GV2P190MB2754.EURP190.PROD.OUTLOOK.COM>
References: <20260417213723.74204-1-artem.blagodarenko@gmail.com>
 <69e32908.a00a0220.1bd0ca.003f.GAE@google.com>
In-Reply-To: <69e32908.a00a0220.1bd0ca.003f.GAE@google.com>
Accept-Language: ru-RU, en-US
Content-Language: en-GB
X-MS-Has-Attach: yes
X-MS-Exchange-Organization-SCL: -1
X-MS-TNEF-Correlator:
X-MS-Exchange-Organization-RecordReviewCfmType: 0
x-ms-reactions: allow
Content-Type: multipart/mixed;
	boundary="_004_GV2P190MB275499A44FE1E8F8C1AF3A8FAB2D2GV2P190MB2754EURP_"
Precedence: bulk
X-Mailing-List: syzbot@lists.linux.dev
List-Id: <syzbot.lists.linux.dev>
List-Subscribe: <mailto:syzbot+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:syzbot+unsubscribe@lists.linux.dev>
MIME-Version: 1.0

--_004_GV2P190MB275499A44FE1E8F8C1AF3A8FAB2D2GV2P190MB2754EURP_
Content-Type: multipart/alternative;
	boundary="_000_GV2P190MB275499A44FE1E8F8C1AF3A8FAB2D2GV2P190MB2754EURP_"

--_000_GV2P190MB275499A44FE1E8F8C1AF3A8FAB2D2GV2P190MB2754EURP_
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable

#syz test


From: syzbot ci <syzbot+ci6167b51351f50705@syzkaller.appspotmail.com>
Date: Saturday, 18 April 2026 at 07:47
To: adilger.kernel@dilger.ca <adilger.kernel@dilger.ca>, adilger@dilger.ca =
<adilger@dilger.ca>, artem.blagodarenko@gmail.com <artem.blagodarenko@gmail=
.com>, linux-ext4@vger.kernel.org <linux-ext4@vger.kernel.org>, pravin.shel=
ar@sun.com <pravin.shelar@sun.com>
Cc: syzbot@lists.linux.dev <syzbot@lists.linux.dev>, syzkaller-bugs@googleg=
roups.com <syzkaller-bugs@googlegroups.com>
Subject: [syzbot ci] Re: Data in direntry (dirdata) feature

syzbot ci has tested the following series

[v1] Data in direntry (dirdata) feature
https://lore.kernel.org/all/20260417213723.74204-1-artem.blagodarenko@gmail=
.com
* [PATCH 1/3] ext4: make dirdata work with metadata_csum
* [PATCH 2/3] ext4: add dirdata support structures and helpers
* [PATCH 3/3] ext4: dirdata feature

and found the following issues:
* KASAN: slab-out-of-bounds Read in __ext4_check_dir_entry
* KASAN: slab-out-of-bounds Read in dx_probe
* KASAN: slab-use-after-free Read in __ext4_check_dir_entry
* KASAN: slab-use-after-free Read in dx_probe
* KASAN: use-after-free Read in __ext4_check_dir_entry

Full report is available here:
https://ci.syzbot.org/series/590e846e-42c0-4497-b6ae-b95ed4468941

***

KASAN: slab-out-of-bounds Read in __ext4_check_dir_entry

tree:      torvalds
URL:       https://kernel.googlesource.com/pub/scm/linux/kernel/git/torvald=
s/linux
base:      70b672833f4025341c11b22c7f83778a5cd611bc
arch:      amd64
compiler:  Debian clang version 21.1.8 (++20251221033036+2078da43e25a-1~exp=
1~20251221153213.50), Debian LLD 21.1.8
config:    https://ci.syzbot.org/builds/7b860156-1ca9-441f-b899-ebfb5a09620=
d/config
syz repro: https://ci.syzbot.org/findings/d27eccd2-4663-4047-abb9-9c24cb32f=
887/syz_repro

loop0: lost filesystem error report for type 5 error -117
EXT4-fs (loop0): mounted filesystem 00000000-0000-0000-0000-000000000000 r/=
w without journal. Quota mode: none.
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
BUG: KASAN: slab-out-of-bounds in ext4_dirent_get_data_len fs/ext4/ext4.h:4=
040 [inline]
BUG: KASAN: slab-out-of-bounds in ext4_dir_entry_len fs/ext4/ext4.h:4060 [i=
nline]
BUG: KASAN: slab-out-of-bounds in __ext4_check_dir_entry+0x527/0xa70 fs/ext=
4/dir.c:96
Read of size 1 at addr ffff8881090bfe5c by task syz.0.20/5967

CPU: 1 UID: 0 PID: 5967 Comm: syz.0.20 Not tainted syzkaller #0 PREEMPT(ful=
l)
Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS 1.16.2-debian-1.16=
.2-1 04/01/2014
Call Trace:
 <TASK>
 dump_stack_lvl+0xe8/0x150 lib/dump_stack.c:120
 print_address_description mm/kasan/report.c:378 [inline]
 print_report+0xba/0x230 mm/kasan/report.c:482
 kasan_report+0x117/0x150 mm/kasan/report.c:595
 ext4_dirent_get_data_len fs/ext4/ext4.h:4040 [inline]
 ext4_dir_entry_len fs/ext4/ext4.h:4060 [inline]
 __ext4_check_dir_entry+0x527/0xa70 fs/ext4/dir.c:96
 ext4_inlinedir_to_tree+0x6be/0xbf0 fs/ext4/inline.c:1322
 ext4_htree_fill_tree+0x50b/0x1230 fs/ext4/namei.c:1184
 ext4_dx_readdir fs/ext4/dir.c:600 [inline]
 ext4_readdir+0x2f7b/0x3870 fs/ext4/dir.c:146
 iterate_dir+0x399/0x570 fs/readdir.c:108
 __do_sys_getdents64 fs/readdir.c:412 [inline]
 __se_sys_getdents64+0xf1/0x280 fs/readdir.c:397
 do_syscall_x64 arch/x86/entry/syscall_64.c:63 [inline]
 do_syscall_64+0x14d/0xf80 arch/x86/entry/syscall_64.c:94
 entry_SYSCALL_64_after_hwframe+0x77/0x7f
RIP: 0033:0x7fe47219c819
Code: ff c3 66 2e 0f 1f 84 00 00 00 00 00 0f 1f 44 00 00 48 89 f8 48 89 f7 =
48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 ff f=
f 73 01 c3 48 c7 c1 e8 ff ff ff f7 d8 64 89 01 48
RSP: 002b:00007fe4730c0028 EFLAGS: 00000246 ORIG_RAX: 00000000000000d9
RAX: ffffffffffffffda RBX: 00007fe472415fa0 RCX: 00007fe47219c819
RDX: 000000000000ff80 RSI: 9999999999999999 RDI: 0000000000000004
RBP: 00007fe472232c91 R08: 0000000000000000 R09: 0000000000000000
R10: 0000000000000000 R11: 0000000000000246 R12: 0000000000000000
R13: 00007fe472416038 R14: 00007fe472415fa0 R15: 00007ffff595c618
 </TASK>

Allocated by task 5967:
 kasan_save_stack mm/kasan/common.c:57 [inline]
 kasan_save_track+0x3e/0x80 mm/kasan/common.c:78
 poison_kmalloc_redzone mm/kasan/common.c:398 [inline]
 __kasan_kmalloc+0x93/0xb0 mm/kasan/common.c:415
 kasan_kmalloc include/linux/kasan.h:263 [inline]
 __do_kmalloc_node mm/slub.c:5260 [inline]
 __kmalloc_noprof+0x35c/0x760 mm/slub.c:5272
 kmalloc_noprof include/linux/slab.h:954 [inline]
 ext4_mb_init+0x15d/0x2ad0 fs/ext4/mballoc.c:3729
 __ext4_fill_super fs/ext4/super.c:5623 [inline]
 ext4_fill_super+0x5647/0x6320 fs/ext4/super.c:5793
 get_tree_bdev_flags+0x431/0x4f0 fs/super.c:1694
 vfs_get_tree+0x92/0x2a0 fs/super.c:1754
 fc_mount fs/namespace.c:1193 [inline]
 do_new_mount_fc fs/namespace.c:3763 [inline]
 do_new_mount+0x341/0xd30 fs/namespace.c:3839
 do_mount fs/namespace.c:4172 [inline]
 __do_sys_mount fs/namespace.c:4361 [inline]
 __se_sys_mount+0x31d/0x420 fs/namespace.c:4338
 do_syscall_x64 arch/x86/entry/syscall_64.c:63 [inline]
 do_syscall_64+0x14d/0xf80 arch/x86/entry/syscall_64.c:94
 entry_SYSCALL_64_after_hwframe+0x77/0x7f

The buggy address belongs to the object at ffff8881090bfe00
 which belongs to the cache kmalloc-64 of size 64
The buggy address is located 44 bytes to the right of
 allocated 48-byte region [ffff8881090bfe00, ffff8881090bfe30)

The buggy address belongs to the physical page:
page: refcount:0 mapcount:0 mapping:0000000000000000 index:0x0 pfn:0x1090bf
flags: 0x17ff00000000000(node=3D0|zone=3D2|lastcpupid=3D0x7ff)
page_type: f5(slab)
raw: 017ff00000000000 ffff8881000418c0 dead000000000100 dead000000000122
raw: 0000000000000000 0000000800200020 00000000f5000000 0000000000000000
page dumped because: kasan: bad access detected
page_owner tracks the page as allocated
page last allocated via order 0, migratetype Unmovable, gfp_mask 0xd2cc0(GF=
P_KERNEL|__GFP_NOWARN|__GFP_NORETRY|__GFP_COMP|__GFP_NOMEMALLOC), pid 1, tg=
id 1 (swapper/0), ts 16414655371, free_ts 15537272896
 set_page_owner include/linux/page_owner.h:32 [inline]
 post_alloc_hook+0x231/0x280 mm/page_alloc.c:1889
 prep_new_page mm/page_alloc.c:1897 [inline]
 get_page_from_freelist+0x24dc/0x2580 mm/page_alloc.c:3962
 __alloc_frozen_pages_noprof+0x18d/0x380 mm/page_alloc.c:5250
 alloc_slab_page mm/slub.c:3292 [inline]
 allocate_slab+0x77/0x660 mm/slub.c:3481
 new_slab mm/slub.c:3539 [inline]
 refill_objects+0x331/0x3c0 mm/slub.c:7175
 refill_sheaf mm/slub.c:2812 [inline]
 __pcs_replace_empty_main+0x2e6/0x730 mm/slub.c:4615
 alloc_from_pcs mm/slub.c:4717 [inline]
 slab_alloc_node mm/slub.c:4851 [inline]
 __do_kmalloc_node mm/slub.c:5259 [inline]
 __kmalloc_noprof+0x474/0x760 mm/slub.c:5272
 kmalloc_noprof include/linux/slab.h:954 [inline]
 kzalloc_noprof include/linux/slab.h:1188 [inline]
 kobject_get_path+0xc5/0x2f0 lib/kobject.c:161
 kobject_uevent_env+0x2a1/0x9e0 lib/kobject_uevent.c:545
 really_probe+0x789/0xaf0 drivers/base/dd.c:771
 __driver_probe_device+0x18c/0x320 drivers/base/dd.c:863
 driver_probe_device+0x4f/0x240 drivers/base/dd.c:893
 __device_attach_driver+0x279/0x430 drivers/base/dd.c:1021
 bus_for_each_drv+0x258/0x2f0 drivers/base/bus.c:500
 __device_attach+0x2c5/0x450 drivers/base/dd.c:1093
 device_initial_probe+0xa1/0xd0 drivers/base/dd.c:1148
page last free pid 33 tgid 33 stack trace:
 reset_page_owner include/linux/page_owner.h:25 [inline]
 __free_pages_prepare mm/page_alloc.c:1433 [inline]
 __free_frozen_pages+0xc2b/0xdb0 mm/page_alloc.c:2978
 vfree+0x25a/0x400 mm/vmalloc.c:3479
 delayed_vfree_work+0x55/0x80 mm/vmalloc.c:3398
 process_one_work kernel/workqueue.c:3276 [inline]
 process_scheduled_works+0xb6e/0x18c0 kernel/workqueue.c:3359
 worker_thread+0xa53/0xfc0 kernel/workqueue.c:3440
 kthread+0x388/0x470 kernel/kthread.c:436
 ret_from_fork+0x51e/0xb90 arch/x86/kernel/process.c:158
 ret_from_fork_asm+0x1a/0x30 arch/x86/entry/entry_64.S:245

Memory state around the buggy address:
 ffff8881090bfd00: 00 00 00 00 00 00 00 04 fc fc fc fc fc fc fc fc
 ffff8881090bfd80: 00 00 00 00 00 00 00 00 fc fc fc fc fc fc fc fc
>ffff8881090bfe00: 00 00 00 00 00 00 fc fc fc fc fc fc fc fc fc fc
                                                    ^
 ffff8881090bfe80: fa fb fb fb fb fb fb fb fc fc fc fc fc fc fc fc
 ffff8881090bff00: 00 00 00 00 00 00 fc fc fc fc fc fc fc fc fc fc
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D


***

KASAN: slab-out-of-bounds Read in dx_probe

tree:      torvalds
URL:       https://kernel.googlesource.com/pub/scm/linux/kernel/git/torvald=
s/linux
base:      70b672833f4025341c11b22c7f83778a5cd611bc
arch:      amd64
compiler:  Debian clang version 21.1.8 (++20251221033036+2078da43e25a-1~exp=
1~20251221153213.50), Debian LLD 21.1.8
config:    https://ci.syzbot.org/builds/7b860156-1ca9-441f-b899-ebfb5a09620=
d/config
syz repro: https://ci.syzbot.org/findings/a5fcf3bd-f1ae-4b81-b5d2-f96899ea7=
690/syz_repro

=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
BUG: KASAN: slab-out-of-bounds in ext4_dir_entry_is_tail fs/ext4/ext4.h:400=
1 [inline]
BUG: KASAN: slab-out-of-bounds in ext4_dirent_get_data_len fs/ext4/ext4.h:4=
024 [inline]
BUG: KASAN: slab-out-of-bounds in ext4_dir_entry_len fs/ext4/ext4.h:4060 [i=
nline]
BUG: KASAN: slab-out-of-bounds in dx_root_limit fs/ext4/namei.c:583 [inline=
]
BUG: KASAN: slab-out-of-bounds in dx_probe+0x1ac9/0x1d90 fs/ext4/namei.c:86=
1
Read of size 4 at addr ffff88816a408c10 by task syz.2.19/5980

CPU: 1 UID: 0 PID: 5980 Comm: syz.2.19 Not tainted syzkaller #0 PREEMPT(ful=
l)
Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS 1.16.2-debian-1.16=
.2-1 04/01/2014
Call Trace:
 <TASK>
 dump_stack_lvl+0xe8/0x150 lib/dump_stack.c:120
 print_address_description mm/kasan/report.c:378 [inline]
 print_report+0xba/0x230 mm/kasan/report.c:482
 kasan_report+0x117/0x150 mm/kasan/report.c:595
 ext4_dir_entry_is_tail fs/ext4/ext4.h:4001 [inline]
 ext4_dirent_get_data_len fs/ext4/ext4.h:4024 [inline]
 ext4_dir_entry_len fs/ext4/ext4.h:4060 [inline]
 dx_root_limit fs/ext4/namei.c:583 [inline]
 dx_probe+0x1ac9/0x1d90 fs/ext4/namei.c:861
 ext4_dx_find_entry fs/ext4/namei.c:1812 [inline]
 __ext4_find_entry+0x5a9/0x2140 fs/ext4/namei.c:1652
 ext4_lookup_entry fs/ext4/namei.c:1794 [inline]
 ext4_lookup+0x17b/0x710 fs/ext4/namei.c:1860
 __lookup_slow+0x2b7/0x410 fs/namei.c:1916
 lookup_slow+0x53/0x70 fs/namei.c:1933
 walk_component fs/namei.c:2279 [inline]
 lookup_last fs/namei.c:2780 [inline]
 path_lookupat+0x3f5/0x8c0 fs/namei.c:2804
 filename_lookup+0x256/0x5d0 fs/namei.c:2833
 user_path_at+0x40/0x160 fs/namei.c:3612
 do_mount fs/namespace.c:4169 [inline]
 __do_sys_mount fs/namespace.c:4361 [inline]
 __se_sys_mount+0x2dc/0x420 fs/namespace.c:4338
 do_syscall_x64 arch/x86/entry/syscall_64.c:63 [inline]
 do_syscall_64+0x14d/0xf80 arch/x86/entry/syscall_64.c:94
 entry_SYSCALL_64_after_hwframe+0x77/0x7f
RIP: 0033:0x7f518919c819
Code: ff c3 66 2e 0f 1f 84 00 00 00 00 00 0f 1f 44 00 00 48 89 f8 48 89 f7 =
48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 ff f=
f 73 01 c3 48 c7 c1 e8 ff ff ff f7 d8 64 89 01 48
RSP: 002b:00007f5189fbb028 EFLAGS: 00000246 ORIG_RAX: 00000000000000a5
RAX: ffffffffffffffda RBX: 00007f5189415fa0 RCX: 00007f518919c819
RDX: 0000200000000140 RSI: 0000200000000100 RDI: 0000000000000000
RBP: 00007f5189232c91 R08: 0000200000000d80 R09: 0000000000000000
R10: 0000000001302060 R11: 0000000000000246 R12: 0000000000000000
R13: 00007f5189416038 R14: 00007f5189415fa0 R15: 00007ffc5d8d15b8
 </TASK>

Allocated by task 5243:
 kasan_save_stack mm/kasan/common.c:57 [inline]
 kasan_save_track+0x3e/0x80 mm/kasan/common.c:78
 poison_kmalloc_redzone mm/kasan/common.c:398 [inline]
 __kasan_kmalloc+0x93/0xb0 mm/kasan/common.c:415
 kasan_kmalloc include/linux/kasan.h:263 [inline]
 __do_kmalloc_node mm/slub.c:5260 [inline]
 __kvmalloc_node_noprof+0x528/0x8a0 mm/slub.c:6752
 evdev_open+0xeb/0x5b0 drivers/input/evdev.c:468
 chrdev_open+0x4cd/0x5e0 fs/char_dev.c:411
 do_dentry_open+0x785/0x14e0 fs/open.c:949
 vfs_open+0x3b/0x340 fs/open.c:1081
 do_open fs/namei.c:4671 [inline]
 path_openat+0x2e08/0x3860 fs/namei.c:4830
 do_file_open+0x23e/0x4a0 fs/namei.c:4859
 do_sys_openat2+0x113/0x200 fs/open.c:1366
 do_sys_open fs/open.c:1372 [inline]
 __do_sys_openat fs/open.c:1388 [inline]
 __se_sys_openat fs/open.c:1383 [inline]
 __x64_sys_openat+0x138/0x170 fs/open.c:1383
 do_syscall_x64 arch/x86/entry/syscall_64.c:63 [inline]
 do_syscall_64+0x14d/0xf80 arch/x86/entry/syscall_64.c:94
 entry_SYSCALL_64_after_hwframe+0x77/0x7f

The buggy address belongs to the object at ffff88816a408000
 which belongs to the cache kmalloc-2k of size 2048
The buggy address is located 1088 bytes to the right of
 allocated 2000-byte region [ffff88816a408000, ffff88816a4087d0)

The buggy address belongs to the physical page:
page: refcount:0 mapcount:0 mapping:0000000000000000 index:0x0 pfn:0x16a408
head: order:3 mapcount:0 entire_mapcount:0 nr_pages_mapped:0 pincount:0
flags: 0x57ff00000000040(head|node=3D1|zone=3D2|lastcpupid=3D0x7ff)
page_type: f5(slab)
raw: 057ff00000000040 ffff888100042000 dead000000000100 dead000000000122
raw: 0000000000000000 0000000800080008 00000000f5000000 0000000000000000
head: 057ff00000000040 ffff888100042000 dead000000000100 dead000000000122
head: 0000000000000000 0000000800080008 00000000f5000000 0000000000000000
head: 057ff00000000003 ffffea0005a90201 00000000ffffffff 00000000ffffffff
head: ffffffffffffffff 0000000000000000 00000000ffffffff 0000000000000008
page dumped because: kasan: bad access detected
page_owner tracks the page as allocated
page last allocated via order 3, migratetype Unmovable, gfp_mask 0xd20c0(__=
GFP_IO|__GFP_FS|__GFP_NOWARN|__GFP_NORETRY|__GFP_COMP|__GFP_NOMEMALLOC), pi=
d 5243, tgid 5243 (acpid), ts 25906150911, free_ts 21905842969
 set_page_owner include/linux/page_owner.h:32 [inline]
 post_alloc_hook+0x231/0x280 mm/page_alloc.c:1889
 prep_new_page mm/page_alloc.c:1897 [inline]
 get_page_from_freelist+0x24dc/0x2580 mm/page_alloc.c:3962
 __alloc_frozen_pages_noprof+0x18d/0x380 mm/page_alloc.c:5250
 alloc_slab_page mm/slub.c:3292 [inline]
 allocate_slab+0x77/0x660 mm/slub.c:3481
 new_slab mm/slub.c:3539 [inline]
 refill_objects+0x331/0x3c0 mm/slub.c:7175
 refill_sheaf mm/slub.c:2812 [inline]
 __pcs_replace_empty_main+0x2e6/0x730 mm/slub.c:4615
 alloc_from_pcs mm/slub.c:4717 [inline]
 slab_alloc_node mm/slub.c:4851 [inline]
 __do_kmalloc_node mm/slub.c:5259 [inline]
 __kvmalloc_node_noprof+0x657/0x8a0 mm/slub.c:6752
 evdev_open+0xeb/0x5b0 drivers/input/evdev.c:468
 chrdev_open+0x4cd/0x5e0 fs/char_dev.c:411
 do_dentry_open+0x785/0x14e0 fs/open.c:949
 vfs_open+0x3b/0x340 fs/open.c:1081
 do_open fs/namei.c:4671 [inline]
 path_openat+0x2e08/0x3860 fs/namei.c:4830
 do_file_open+0x23e/0x4a0 fs/namei.c:4859
 do_sys_openat2+0x113/0x200 fs/open.c:1366
 do_sys_open fs/open.c:1372 [inline]
 __do_sys_openat fs/open.c:1388 [inline]
 __se_sys_openat fs/open.c:1383 [inline]
 __x64_sys_openat+0x138/0x170 fs/open.c:1383
 do_syscall_x64 arch/x86/entry/syscall_64.c:63 [inline]
 do_syscall_64+0x14d/0xf80 arch/x86/entry/syscall_64.c:94
page last free pid 9 tgid 9 stack trace:
 reset_page_owner include/linux/page_owner.h:25 [inline]
 __free_pages_prepare mm/page_alloc.c:1433 [inline]
 __free_frozen_pages+0xc2b/0xdb0 mm/page_alloc.c:2978
 vfree+0x25a/0x400 mm/vmalloc.c:3479
 delayed_vfree_work+0x55/0x80 mm/vmalloc.c:3398
 process_one_work kernel/workqueue.c:3276 [inline]
 process_scheduled_works+0xb6e/0x18c0 kernel/workqueue.c:3359
 worker_thread+0xa53/0xfc0 kernel/workqueue.c:3440
 kthread+0x388/0x470 kernel/kthread.c:436
 ret_from_fork+0x51e/0xb90 arch/x86/kernel/process.c:158
 ret_from_fork_asm+0x1a/0x30 arch/x86/entry/entry_64.S:245

Memory state around the buggy address:
 ffff88816a408b00: fc fc fc fc fc fc fc fc fc fc fc fc fc fc fc fc
 ffff88816a408b80: fc fc fc fc fc fc fc fc fc fc fc fc fc fc fc fc
>ffff88816a408c00: fc fc fc fc fc fc fc fc fc fc fc fc fc fc fc fc
                         ^
 ffff88816a408c80: fc fc fc fc fc fc fc fc fc fc fc fc fc fc fc fc
 ffff88816a408d00: fc fc fc fc fc fc fc fc fc fc fc fc fc fc fc fc
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D


***

KASAN: slab-use-after-free Read in __ext4_check_dir_entry

tree:      torvalds
URL:       https://kernel.googlesource.com/pub/scm/linux/kernel/git/torvald=
s/linux
base:      70b672833f4025341c11b22c7f83778a5cd611bc
arch:      amd64
compiler:  Debian clang version 21.1.8 (++20251221033036+2078da43e25a-1~exp=
1~20251221153213.50), Debian LLD 21.1.8
config:    https://ci.syzbot.org/builds/7b860156-1ca9-441f-b899-ebfb5a09620=
d/config
syz repro: https://ci.syzbot.org/findings/e493ff66-4032-4979-9b5d-5118b2768=
ca5/syz_repro

EXT4-fs (loop0): mounted filesystem 00000000-0000-0000-0000-000000000000 r/=
w without journal. Quota mode: none.
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
BUG: KASAN: slab-use-after-free in ext4_dirent_get_data_len fs/ext4/ext4.h:=
4040 [inline]
BUG: KASAN: slab-use-after-free in ext4_dir_entry_len fs/ext4/ext4.h:4060 [=
inline]
BUG: KASAN: slab-use-after-free in __ext4_check_dir_entry+0x527/0xa70 fs/ex=
t4/dir.c:96
Read of size 1 at addr ffff88810138889c by task syz.0.24/5978

CPU: 0 UID: 0 PID: 5978 Comm: syz.0.24 Not tainted syzkaller #0 PREEMPT(ful=
l)
Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS 1.16.2-debian-1.16=
.2-1 04/01/2014
Call Trace:
 <TASK>
 dump_stack_lvl+0xe8/0x150 lib/dump_stack.c:120
 print_address_description mm/kasan/report.c:378 [inline]
 print_report+0xba/0x230 mm/kasan/report.c:482
 kasan_report+0x117/0x150 mm/kasan/report.c:595
 ext4_dirent_get_data_len fs/ext4/ext4.h:4040 [inline]
 ext4_dir_entry_len fs/ext4/ext4.h:4060 [inline]
 __ext4_check_dir_entry+0x527/0xa70 fs/ext4/dir.c:96
 ext4_inlinedir_to_tree+0x6be/0xbf0 fs/ext4/inline.c:1322
 ext4_htree_fill_tree+0x50b/0x1230 fs/ext4/namei.c:1184
 ext4_dx_readdir fs/ext4/dir.c:600 [inline]
 ext4_readdir+0x2f7b/0x3870 fs/ext4/dir.c:146
 iterate_dir+0x399/0x570 fs/readdir.c:108
 __do_sys_getdents64 fs/readdir.c:412 [inline]
 __se_sys_getdents64+0xf1/0x280 fs/readdir.c:397
 do_syscall_x64 arch/x86/entry/syscall_64.c:63 [inline]
 do_syscall_64+0x14d/0xf80 arch/x86/entry/syscall_64.c:94
 entry_SYSCALL_64_after_hwframe+0x77/0x7f
RIP: 0033:0x7ff3fe19c819
Code: ff c3 66 2e 0f 1f 84 00 00 00 00 00 0f 1f 44 00 00 48 89 f8 48 89 f7 =
48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 ff f=
f 73 01 c3 48 c7 c1 e8 ff ff ff f7 d8 64 89 01 48
RSP: 002b:00007ff3fefac028 EFLAGS: 00000246 ORIG_RAX: 00000000000000d9
RAX: ffffffffffffffda RBX: 00007ff3fe415fa0 RCX: 00007ff3fe19c819
RDX: 000000000000ff80 RSI: 9999999999999999 RDI: 0000000000000004
RBP: 00007ff3fe232c91 R08: 0000000000000000 R09: 0000000000000000
R10: 0000000000000000 R11: 0000000000000246 R12: 0000000000000000
R13: 00007ff3fe416038 R14: 00007ff3fe415fa0 R15: 00007ffd39a74998
 </TASK>

Allocated by task 5766:
 kasan_save_stack mm/kasan/common.c:57 [inline]
 kasan_save_track+0x3e/0x80 mm/kasan/common.c:78
 poison_kmalloc_redzone mm/kasan/common.c:398 [inline]
 __kasan_kmalloc+0x93/0xb0 mm/kasan/common.c:415
 kasan_kmalloc include/linux/kasan.h:263 [inline]
 __do_kmalloc_node mm/slub.c:5260 [inline]
 __kmalloc_noprof+0x35c/0x760 mm/slub.c:5272
 kmalloc_noprof include/linux/slab.h:954 [inline]
 kzalloc_noprof include/linux/slab.h:1188 [inline]
 tomoyo_encode2 security/tomoyo/realpath.c:45 [inline]
 tomoyo_encode+0x28b/0x550 security/tomoyo/realpath.c:80
 tomoyo_realpath_from_path+0x58d/0x5d0 security/tomoyo/realpath.c:283
 tomoyo_get_realpath security/tomoyo/file.c:151 [inline]
 tomoyo_check_open_permission+0x229/0x470 security/tomoyo/file.c:776
 security_file_open+0xa9/0x240 security/security.c:2637
 do_dentry_open+0x384/0x14e0 fs/open.c:926
 vfs_open+0x3b/0x340 fs/open.c:1081
 do_open fs/namei.c:4671 [inline]
 path_openat+0x2e08/0x3860 fs/namei.c:4830
 do_file_open+0x23e/0x4a0 fs/namei.c:4859
 do_sys_openat2+0x113/0x200 fs/open.c:1366
 do_sys_open fs/open.c:1372 [inline]
 __do_sys_openat fs/open.c:1388 [inline]
 __se_sys_openat fs/open.c:1383 [inline]
 __x64_sys_openat+0x138/0x170 fs/open.c:1383
 do_syscall_x64 arch/x86/entry/syscall_64.c:63 [inline]
 do_syscall_64+0x14d/0xf80 arch/x86/entry/syscall_64.c:94
 entry_SYSCALL_64_after_hwframe+0x77/0x7f

Freed by task 5766:
 kasan_save_stack mm/kasan/common.c:57 [inline]
 kasan_save_track+0x3e/0x80 mm/kasan/common.c:78
 kasan_save_free_info+0x46/0x50 mm/kasan/generic.c:584
 poison_slab_object mm/kasan/common.c:253 [inline]
 __kasan_slab_free+0x5c/0x80 mm/kasan/common.c:285
 kasan_slab_free include/linux/kasan.h:235 [inline]
 slab_free_hook mm/slub.c:2685 [inline]
 slab_free mm/slub.c:6165 [inline]
 kfree+0x1c1/0x630 mm/slub.c:6483
 tomoyo_check_open_permission+0x32c/0x470 security/tomoyo/file.c:791
 security_file_open+0xa9/0x240 security/security.c:2637
 do_dentry_open+0x384/0x14e0 fs/open.c:926
 vfs_open+0x3b/0x340 fs/open.c:1081
 do_open fs/namei.c:4671 [inline]
 path_openat+0x2e08/0x3860 fs/namei.c:4830
 do_file_open+0x23e/0x4a0 fs/namei.c:4859
 do_sys_openat2+0x113/0x200 fs/open.c:1366
 do_sys_open fs/open.c:1372 [inline]
 __do_sys_openat fs/open.c:1388 [inline]
 __se_sys_openat fs/open.c:1383 [inline]
 __x64_sys_openat+0x138/0x170 fs/open.c:1383
 do_syscall_x64 arch/x86/entry/syscall_64.c:63 [inline]
 do_syscall_64+0x14d/0xf80 arch/x86/entry/syscall_64.c:94
 entry_SYSCALL_64_after_hwframe+0x77/0x7f

The buggy address belongs to the object at ffff888101388880
 which belongs to the cache kmalloc-64 of size 64
The buggy address is located 28 bytes inside of
 freed 64-byte region [ffff888101388880, ffff8881013888c0)

The buggy address belongs to the physical page:
page: refcount:0 mapcount:0 mapping:0000000000000000 index:0x0 pfn:0x101388
flags: 0x17ff00000000000(node=3D0|zone=3D2|lastcpupid=3D0x7ff)
page_type: f5(slab)
raw: 017ff00000000000 ffff8881000418c0 dead000000000100 dead000000000122
raw: 0000000000000000 0000000800200020 00000000f5000000 0000000000000000
page dumped because: kasan: bad access detected
page_owner tracks the page as allocated
page last allocated via order 0, migratetype Unmovable, gfp_mask 0xd2cc0(GF=
P_KERNEL|__GFP_NOWARN|__GFP_NORETRY|__GFP_COMP|__GFP_NOMEMALLOC), pid 26, t=
gid 26 (kworker/u9:0), ts 4100832473, free_ts 4100767003
 set_page_owner include/linux/page_owner.h:32 [inline]
 post_alloc_hook+0x231/0x280 mm/page_alloc.c:1889
 prep_new_page mm/page_alloc.c:1897 [inline]
 get_page_from_freelist+0x24dc/0x2580 mm/page_alloc.c:3962
 __alloc_frozen_pages_noprof+0x18d/0x380 mm/page_alloc.c:5250
 alloc_slab_page mm/slub.c:3292 [inline]
 allocate_slab+0x77/0x660 mm/slub.c:3481
 new_slab mm/slub.c:3539 [inline]
 refill_objects+0x331/0x3c0 mm/slub.c:7175
 refill_sheaf mm/slub.c:2812 [inline]
 alloc_full_sheaf mm/slub.c:2834 [inline]
 __pcs_replace_empty_main+0x40a/0x730 mm/slub.c:4626
 alloc_from_pcs mm/slub.c:4717 [inline]
 slab_alloc_node mm/slub.c:4851 [inline]
 __do_kmalloc_node mm/slub.c:5259 [inline]
 __kmalloc_noprof+0x474/0x760 mm/slub.c:5272
 kmalloc_noprof include/linux/slab.h:954 [inline]
 kzalloc_noprof include/linux/slab.h:1188 [inline]
 lsm_blob_alloc security/security.c:193 [inline]
 lsm_task_alloc security/security.c:245 [inline]
 security_task_alloc+0x4d/0x330 security/security.c:2683
 copy_process+0x16df/0x3cd0 kernel/fork.c:2206
 kernel_clone+0x248/0x8e0 kernel/fork.c:2658
 user_mode_thread+0x110/0x180 kernel/fork.c:2734
 call_usermodehelper_exec_work+0x5c/0x230 kernel/umh.c:171
 process_one_work kernel/workqueue.c:3276 [inline]
 process_scheduled_works+0xb6e/0x18c0 kernel/workqueue.c:3359
 worker_thread+0xa53/0xfc0 kernel/workqueue.c:3440
 kthread+0x388/0x470 kernel/kthread.c:436
 ret_from_fork+0x51e/0xb90 arch/x86/kernel/process.c:158
page last free pid 26 tgid 26 stack trace:
 reset_page_owner include/linux/page_owner.h:25 [inline]
 __free_pages_prepare mm/page_alloc.c:1433 [inline]
 __free_frozen_pages+0xc2b/0xdb0 mm/page_alloc.c:2978
 __kasan_populate_vmalloc_do mm/kasan/shadow.c:393 [inline]
 __kasan_populate_vmalloc+0x1b2/0x1d0 mm/kasan/shadow.c:424
 kasan_populate_vmalloc include/linux/kasan.h:580 [inline]
 alloc_vmap_area+0xd73/0x14b0 mm/vmalloc.c:2129
 __get_vm_area_node+0x1f8/0x300 mm/vmalloc.c:3232
 __vmalloc_node_range_noprof+0x372/0x1730 mm/vmalloc.c:4024
 __vmalloc_node_noprof+0xc2/0x100 mm/vmalloc.c:4124
 alloc_thread_stack_node kernel/fork.c:355 [inline]
 dup_task_struct+0x292/0x9e0 kernel/fork.c:924
 copy_process+0x508/0x3cd0 kernel/fork.c:2051
 kernel_clone+0x248/0x8e0 kernel/fork.c:2658
 user_mode_thread+0x110/0x180 kernel/fork.c:2734
 call_usermodehelper_exec_work+0x5c/0x230 kernel/umh.c:171
 process_one_work kernel/workqueue.c:3276 [inline]
 process_scheduled_works+0xb6e/0x18c0 kernel/workqueue.c:3359
 worker_thread+0xa53/0xfc0 kernel/workqueue.c:3440
 kthread+0x388/0x470 kernel/kthread.c:436
 ret_from_fork+0x51e/0xb90 arch/x86/kernel/process.c:158
 ret_from_fork_asm+0x1a/0x30 arch/x86/entry/entry_64.S:245

Memory state around the buggy address:
 ffff888101388780: 00 00 00 00 00 00 00 04 fc fc fc fc fc fc fc fc
 ffff888101388800: fa fb fb fb fb fb fb fb fc fc fc fc fc fc fc fc
>ffff888101388880: fa fb fb fb fb fb fb fb fc fc fc fc fc fc fc fc
                            ^
 ffff888101388900: 00 00 00 00 00 00 00 fc fc fc fc fc fc fc fc fc
 ffff888101388980: 00 00 00 00 00 00 00 00 fc fc fc fc fc fc fc fc
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D


***

KASAN: slab-use-after-free Read in dx_probe

tree:      torvalds
URL:       https://kernel.googlesource.com/pub/scm/linux/kernel/git/torvald=
s/linux
base:      70b672833f4025341c11b22c7f83778a5cd611bc
arch:      amd64
compiler:  Debian clang version 21.1.8 (++20251221033036+2078da43e25a-1~exp=
1~20251221153213.50), Debian LLD 21.1.8
config:    https://ci.syzbot.org/builds/7b860156-1ca9-441f-b899-ebfb5a09620=
d/config
syz repro: https://ci.syzbot.org/findings/5524eff5-62fb-4cff-8d4e-7e3750aa9=
21b/syz_repro

EXT4-fs (loop2): mounted filesystem 00000000-0000-0000-0000-000000000000 ro=
 without journal. Quota mode: none.
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
BUG: KASAN: slab-use-after-free in ext4_dir_entry_is_tail fs/ext4/ext4.h:40=
01 [inline]
BUG: KASAN: slab-use-after-free in ext4_dirent_get_data_len fs/ext4/ext4.h:=
4024 [inline]
BUG: KASAN: slab-use-after-free in ext4_dir_entry_len fs/ext4/ext4.h:4060 [=
inline]
BUG: KASAN: slab-use-after-free in dx_root_limit fs/ext4/namei.c:583 [inlin=
e]
BUG: KASAN: slab-use-after-free in dx_probe+0x1ac9/0x1d90 fs/ext4/namei.c:8=
61
Read of size 4 at addr ffff888109c42c10 by task syz.2.20/5984

CPU: 0 UID: 0 PID: 5984 Comm: syz.2.20 Not tainted syzkaller #0 PREEMPT(ful=
l)
Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS 1.16.2-debian-1.16=
.2-1 04/01/2014
Call Trace:
 <TASK>
 dump_stack_lvl+0xe8/0x150 lib/dump_stack.c:120
 print_address_description mm/kasan/report.c:378 [inline]
 print_report+0xba/0x230 mm/kasan/report.c:482
 kasan_report+0x117/0x150 mm/kasan/report.c:595
 ext4_dir_entry_is_tail fs/ext4/ext4.h:4001 [inline]
 ext4_dirent_get_data_len fs/ext4/ext4.h:4024 [inline]
 ext4_dir_entry_len fs/ext4/ext4.h:4060 [inline]
 dx_root_limit fs/ext4/namei.c:583 [inline]
 dx_probe+0x1ac9/0x1d90 fs/ext4/namei.c:861
 ext4_dx_find_entry fs/ext4/namei.c:1812 [inline]
 __ext4_find_entry+0x5a9/0x2140 fs/ext4/namei.c:1652
 ext4_lookup_entry fs/ext4/namei.c:1794 [inline]
 ext4_lookup+0x17b/0x710 fs/ext4/namei.c:1860
 lookup_open fs/namei.c:4456 [inline]
 open_last_lookups fs/namei.c:4583 [inline]
 path_openat+0x11ac/0x3860 fs/namei.c:4827
 do_file_open+0x23e/0x4a0 fs/namei.c:4859
 do_sys_openat2+0x113/0x200 fs/open.c:1366
 do_sys_open fs/open.c:1372 [inline]
 __do_sys_openat fs/open.c:1388 [inline]
 __se_sys_openat fs/open.c:1383 [inline]
 __x64_sys_openat+0x138/0x170 fs/open.c:1383
 do_syscall_x64 arch/x86/entry/syscall_64.c:63 [inline]
 do_syscall_64+0x14d/0xf80 arch/x86/entry/syscall_64.c:94
 entry_SYSCALL_64_after_hwframe+0x77/0x7f
RIP: 0033:0x7fb97dd9c819
Code: ff c3 66 2e 0f 1f 84 00 00 00 00 00 0f 1f 44 00 00 48 89 f8 48 89 f7 =
48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 ff f=
f 73 01 c3 48 c7 c1 e8 ff ff ff f7 d8 64 89 01 48
RSP: 002b:00007fb97ec96028 EFLAGS: 00000246 ORIG_RAX: 0000000000000101
RAX: ffffffffffffffda RBX: 00007fb97e015fa0 RCX: 00007fb97dd9c819
RDX: 0000000000042041 RSI: 0000200000000700 RDI: ffffffffffffff9c
RBP: 00007fb97de32c91 R08: 0000000000000000 R09: 0000000000000000
R10: 000000000000001d R11: 0000000000000246 R12: 0000000000000000
R13: 00007fb97e016038 R14: 00007fb97e015fa0 R15: 00007fffcac5f5a8
 </TASK>

Allocated by task 5828:
 kasan_save_stack mm/kasan/common.c:57 [inline]
 kasan_save_track+0x3e/0x80 mm/kasan/common.c:78
 poison_kmalloc_redzone mm/kasan/common.c:398 [inline]
 __kasan_kmalloc+0x93/0xb0 mm/kasan/common.c:415
 kasan_kmalloc include/linux/kasan.h:263 [inline]
 __do_kmalloc_node mm/slub.c:5260 [inline]
 __kmalloc_noprof+0x35c/0x760 mm/slub.c:5272
 kmalloc_noprof include/linux/slab.h:954 [inline]
 tomoyo_realpath_from_path+0xe3/0x5d0 security/tomoyo/realpath.c:251
 tomoyo_get_realpath security/tomoyo/file.c:151 [inline]
 tomoyo_path_perm+0x283/0x560 security/tomoyo/file.c:827
 tomoyo_path_symlink+0xab/0xf0 security/tomoyo/tomoyo.c:212
 security_path_symlink+0x16f/0x360 security/security.c:1477
 filename_symlinkat+0x134/0x410 fs/namei.c:5638
 __do_sys_symlink fs/namei.c:5667 [inline]
 __se_sys_symlink+0x4d/0x2b0 fs/namei.c:5663
 do_syscall_x64 arch/x86/entry/syscall_64.c:63 [inline]
 do_syscall_64+0x14d/0xf80 arch/x86/entry/syscall_64.c:94
 entry_SYSCALL_64_after_hwframe+0x77/0x7f

Freed by task 5828:
 kasan_save_stack mm/kasan/common.c:57 [inline]
 kasan_save_track+0x3e/0x80 mm/kasan/common.c:78
 kasan_save_free_info+0x46/0x50 mm/kasan/generic.c:584
 poison_slab_object mm/kasan/common.c:253 [inline]
 __kasan_slab_free+0x5c/0x80 mm/kasan/common.c:285
 kasan_slab_free include/linux/kasan.h:235 [inline]
 slab_free_hook mm/slub.c:2685 [inline]
 slab_free mm/slub.c:6165 [inline]
 kfree+0x1c1/0x630 mm/slub.c:6483
 tomoyo_realpath_from_path+0x598/0x5d0 security/tomoyo/realpath.c:286
 tomoyo_get_realpath security/tomoyo/file.c:151 [inline]
 tomoyo_path_perm+0x283/0x560 security/tomoyo/file.c:827
 tomoyo_path_symlink+0xab/0xf0 security/tomoyo/tomoyo.c:212
 security_path_symlink+0x16f/0x360 security/security.c:1477
 filename_symlinkat+0x134/0x410 fs/namei.c:5638
 __do_sys_symlink fs/namei.c:5667 [inline]
 __se_sys_symlink+0x4d/0x2b0 fs/namei.c:5663
 do_syscall_x64 arch/x86/entry/syscall_64.c:63 [inline]
 do_syscall_64+0x14d/0xf80 arch/x86/entry/syscall_64.c:94
 entry_SYSCALL_64_after_hwframe+0x77/0x7f

The buggy address belongs to the object at ffff888109c42000
 which belongs to the cache kmalloc-4k of size 4096
The buggy address is located 3088 bytes inside of
 freed 4096-byte region [ffff888109c42000, ffff888109c43000)

The buggy address belongs to the physical page:
page: refcount:0 mapcount:0 mapping:0000000000000000 index:0x0 pfn:0x109c40
head: order:3 mapcount:0 entire_mapcount:0 nr_pages_mapped:0 pincount:0
flags: 0x17ff00000000040(head|node=3D0|zone=3D2|lastcpupid=3D0x7ff)
page_type: f5(slab)
raw: 017ff00000000040 ffff888100042140 dead000000000100 dead000000000122
raw: 0000000000000000 0000000800040004 00000000f5000000 0000000000000000
head: 017ff00000000040 ffff888100042140 dead000000000100 dead000000000122
head: 0000000000000000 0000000800040004 00000000f5000000 0000000000000000
head: 017ff00000000003 ffffea0004271001 00000000ffffffff 00000000ffffffff
head: ffffffffffffffff 0000000000000000 00000000ffffffff 0000000000000008
page dumped because: kasan: bad access detected
page_owner tracks the page as allocated
page last allocated via order 3, migratetype Unmovable, gfp_mask 0xd2040(__=
GFP_IO|__GFP_NOWARN|__GFP_NORETRY|__GFP_COMP|__GFP_NOMEMALLOC), pid 5828, t=
gid 5828 (udevd), ts 67573015608, free_ts 47549723112
 set_page_owner include/linux/page_owner.h:32 [inline]
 post_alloc_hook+0x231/0x280 mm/page_alloc.c:1889
 prep_new_page mm/page_alloc.c:1897 [inline]
 get_page_from_freelist+0x24dc/0x2580 mm/page_alloc.c:3962
 __alloc_frozen_pages_noprof+0x18d/0x380 mm/page_alloc.c:5250
 alloc_slab_page mm/slub.c:3292 [inline]
 allocate_slab+0x77/0x660 mm/slub.c:3481
 new_slab mm/slub.c:3539 [inline]
 refill_objects+0x331/0x3c0 mm/slub.c:7175
 refill_sheaf mm/slub.c:2812 [inline]
 __pcs_replace_empty_main+0x2e6/0x730 mm/slub.c:4615
 alloc_from_pcs mm/slub.c:4717 [inline]
 slab_alloc_node mm/slub.c:4851 [inline]
 __do_kmalloc_node mm/slub.c:5259 [inline]
 __kmalloc_noprof+0x474/0x760 mm/slub.c:5272
 kmalloc_noprof include/linux/slab.h:954 [inline]
 tomoyo_realpath_from_path+0xe3/0x5d0 security/tomoyo/realpath.c:251
 tomoyo_get_realpath security/tomoyo/file.c:151 [inline]
 tomoyo_path_perm+0x283/0x560 security/tomoyo/file.c:827
 tomoyo_path_symlink+0xab/0xf0 security/tomoyo/tomoyo.c:212
 security_path_symlink+0x16f/0x360 security/security.c:1477
 filename_symlinkat+0x134/0x410 fs/namei.c:5638
 __do_sys_symlink fs/namei.c:5667 [inline]
 __se_sys_symlink+0x4d/0x2b0 fs/namei.c:5663
 do_syscall_x64 arch/x86/entry/syscall_64.c:63 [inline]
 do_syscall_64+0x14d/0xf80 arch/x86/entry/syscall_64.c:94
 entry_SYSCALL_64_after_hwframe+0x77/0x7f
page last free pid 5718 tgid 5718 stack trace:
 reset_page_owner include/linux/page_owner.h:25 [inline]
 __free_pages_prepare mm/page_alloc.c:1433 [inline]
 __free_frozen_pages+0xc2b/0xdb0 mm/page_alloc.c:2978
 __slab_free+0x263/0x2b0 mm/slub.c:5573
 qlink_free mm/kasan/quarantine.c:163 [inline]
 qlist_free_all+0x97/0x100 mm/kasan/quarantine.c:179
 kasan_quarantine_reduce+0x148/0x160 mm/kasan/quarantine.c:286
 __kasan_slab_alloc+0x22/0x80 mm/kasan/common.c:350
 kasan_slab_alloc include/linux/kasan.h:253 [inline]
 slab_post_alloc_hook mm/slub.c:4538 [inline]
 slab_alloc_node mm/slub.c:4866 [inline]
 kmem_cache_alloc_noprof+0x2bc/0x650 mm/slub.c:4873
 alloc_filename fs/namei.c:142 [inline]
 do_getname+0x2e/0x250 fs/namei.c:182
 getname include/linux/fs.h:2512 [inline]
 getname_maybe_null include/linux/fs.h:2519 [inline]
 class_filename_maybe_null_constructor include/linux/fs.h:2543 [inline]
 vfs_fstatat+0x45/0x170 fs/stat.c:368
 __do_sys_newfstatat fs/stat.c:538 [inline]
 __se_sys_newfstatat fs/stat.c:532 [inline]
 __x64_sys_newfstatat+0x151/0x200 fs/stat.c:532
 do_syscall_x64 arch/x86/entry/syscall_64.c:63 [inline]
 do_syscall_64+0x14d/0xf80 arch/x86/entry/syscall_64.c:94
 entry_SYSCALL_64_after_hwframe+0x77/0x7f

Memory state around the buggy address:
 ffff888109c42b00: fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb
 ffff888109c42b80: fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb
>ffff888109c42c00: fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb
                         ^
 ffff888109c42c80: fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb
 ffff888109c42d00: fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D


***

KASAN: use-after-free Read in __ext4_check_dir_entry

tree:      torvalds
URL:       https://kernel.googlesource.com/pub/scm/linux/kernel/git/torvald=
s/linux
base:      70b672833f4025341c11b22c7f83778a5cd611bc
arch:      amd64
compiler:  Debian clang version 21.1.8 (++20251221033036+2078da43e25a-1~exp=
1~20251221153213.50), Debian LLD 21.1.8
config:    https://ci.syzbot.org/builds/7b860156-1ca9-441f-b899-ebfb5a09620=
d/config
syz repro: https://ci.syzbot.org/findings/21333690-a422-407b-92c7-9247a0075=
b74/syz_repro

loop1: lost filesystem error report for type 5 error -117
EXT4-fs (loop1): mounted filesystem 00000000-0000-0000-0000-000000000000 r/=
w without journal. Quota mode: none.
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
BUG: KASAN: use-after-free in ext4_dirent_get_data_len fs/ext4/ext4.h:4040 =
[inline]
BUG: KASAN: use-after-free in ext4_dir_entry_len fs/ext4/ext4.h:4060 [inlin=
e]
BUG: KASAN: use-after-free in __ext4_check_dir_entry+0x527/0xa70 fs/ext4/di=
r.c:96
Read of size 1 at addr ffff88810da3609c by task syz.1.20/5966

CPU: 0 UID: 0 PID: 5966 Comm: syz.1.20 Not tainted syzkaller #0 PREEMPT(ful=
l)
Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS 1.16.2-debian-1.16=
.2-1 04/01/2014
Call Trace:
 <TASK>
 dump_stack_lvl+0xe8/0x150 lib/dump_stack.c:120
 print_address_description mm/kasan/report.c:378 [inline]
 print_report+0xba/0x230 mm/kasan/report.c:482
 kasan_report+0x117/0x150 mm/kasan/report.c:595
 ext4_dirent_get_data_len fs/ext4/ext4.h:4040 [inline]
 ext4_dir_entry_len fs/ext4/ext4.h:4060 [inline]
 __ext4_check_dir_entry+0x527/0xa70 fs/ext4/dir.c:96
 ext4_inlinedir_to_tree+0x6be/0xbf0 fs/ext4/inline.c:1322
 ext4_htree_fill_tree+0x50b/0x1230 fs/ext4/namei.c:1184
 ext4_dx_readdir fs/ext4/dir.c:600 [inline]
 ext4_readdir+0x2f7b/0x3870 fs/ext4/dir.c:146
 iterate_dir+0x399/0x570 fs/readdir.c:108
 __do_sys_getdents64 fs/readdir.c:412 [inline]
 __se_sys_getdents64+0xf1/0x280 fs/readdir.c:397
 do_syscall_x64 arch/x86/entry/syscall_64.c:63 [inline]
 do_syscall_64+0x14d/0xf80 arch/x86/entry/syscall_64.c:94
 entry_SYSCALL_64_after_hwframe+0x77/0x7f
RIP: 0033:0x7fb82a19c819
Code: ff c3 66 2e 0f 1f 84 00 00 00 00 00 0f 1f 44 00 00 48 89 f8 48 89 f7 =
48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 ff f=
f 73 01 c3 48 c7 c1 e8 ff ff ff f7 d8 64 89 01 48
RSP: 002b:00007fb82b01a028 EFLAGS: 00000246 ORIG_RAX: 00000000000000d9
RAX: ffffffffffffffda RBX: 00007fb82a415fa0 RCX: 00007fb82a19c819
RDX: 000000000000ff80 RSI: 9999999999999999 RDI: 0000000000000004
RBP: 00007fb82a232c91 R08: 0000000000000000 R09: 0000000000000000
R10: 0000000000000000 R11: 0000000000000246 R12: 0000000000000000
R13: 00007fb82a416038 R14: 00007fb82a415fa0 R15: 00007ffdc30464e8
 </TASK>

The buggy address belongs to the physical page:
page: refcount:0 mapcount:0 mapping:0000000000000000 index:0xffff88810da360=
00 pfn:0x10da36
flags: 0x17ff00000000000(node=3D0|zone=3D2|lastcpupid=3D0x7ff)
page_type: f0(buddy)
raw: 017ff00000000000 ffffea0004364708 ffffea000436a7c8 0000000000000000
raw: ffff88810da36000 0000000000000000 00000000f0000000 0000000000000000
page dumped because: kasan: bad access detected
page_owner tracks the page as freed
page last allocated via order 0, migratetype Unmovable, gfp_mask 0xd2c00(GF=
P_NOIO|__GFP_NOWARN|__GFP_NORETRY|__GFP_COMP|__GFP_NOMEMALLOC), pid 1, tgid=
 1 (swapper/0), ts 15037633903, free_ts 26770192426
 set_page_owner include/linux/page_owner.h:32 [inline]
 post_alloc_hook+0x231/0x280 mm/page_alloc.c:1889
 prep_new_page mm/page_alloc.c:1897 [inline]
 get_page_from_freelist+0x24dc/0x2580 mm/page_alloc.c:3962
 __alloc_frozen_pages_noprof+0x18d/0x380 mm/page_alloc.c:5250
 alloc_slab_page mm/slub.c:3292 [inline]
 allocate_slab+0x77/0x660 mm/slub.c:3481
 new_slab mm/slub.c:3539 [inline]
 refill_objects+0x331/0x3c0 mm/slub.c:7175
 refill_sheaf mm/slub.c:2812 [inline]
 __pcs_replace_empty_main+0x2e6/0x730 mm/slub.c:4615
 alloc_from_pcs mm/slub.c:4717 [inline]
 slab_alloc_node mm/slub.c:4851 [inline]
 __do_kmalloc_node mm/slub.c:5259 [inline]
 __kmalloc_noprof+0x474/0x760 mm/slub.c:5272
 kmalloc_noprof include/linux/slab.h:954 [inline]
 usb_alloc_urb+0x46/0x150 drivers/usb/core/urb.c:75
 usb_internal_control_msg drivers/usb/core/message.c:110 [inline]
 usb_control_msg+0x118/0x3e0 drivers/usb/core/message.c:167
 usb_get_descriptor+0xb1/0x3e0 drivers/usb/core/message.c:852
 usb_get_configuration+0x3b9/0x54f0 drivers/usb/core/config.c:986
 usb_enumerate_device drivers/usb/core/hub.c:2527 [inline]
 usb_new_device+0x145/0x16f0 drivers/usb/core/hub.c:2665
 register_root_hub+0x270/0x5f0 drivers/usb/core/hcd.c:990
 usb_add_hcd+0xba1/0x10b0 drivers/usb/core/hcd.c:2987
 vhci_hcd_probe+0x1fa/0x3e0 drivers/usb/usbip/vhci_hcd.c:1401
 platform_probe+0xf9/0x190 drivers/base/platform.c:1418
page last free pid 5262 tgid 5262 stack trace:
 reset_page_owner include/linux/page_owner.h:25 [inline]
 __free_pages_prepare mm/page_alloc.c:1433 [inline]
 __free_frozen_pages+0xc2b/0xdb0 mm/page_alloc.c:2978
 __slab_free+0x263/0x2b0 mm/slub.c:5573
 qlink_free mm/kasan/quarantine.c:163 [inline]
 qlist_free_all+0x97/0x100 mm/kasan/quarantine.c:179
 kasan_quarantine_reduce+0x148/0x160 mm/kasan/quarantine.c:286
 __kasan_slab_alloc+0x22/0x80 mm/kasan/common.c:350
 kasan_slab_alloc include/linux/kasan.h:253 [inline]
 slab_post_alloc_hook mm/slub.c:4538 [inline]
 slab_alloc_node mm/slub.c:4866 [inline]
 kmem_cache_alloc_noprof+0x2bc/0x650 mm/slub.c:4873
 alloc_empty_file+0x55/0x1d0 fs/file_table.c:237
 path_openat+0x10f/0x3860 fs/namei.c:4816
 do_file_open+0x23e/0x4a0 fs/namei.c:4859
 do_sys_openat2+0x113/0x200 fs/open.c:1366
 do_sys_open fs/open.c:1372 [inline]
 __do_sys_openat fs/open.c:1388 [inline]
 __se_sys_openat fs/open.c:1383 [inline]
 __x64_sys_openat+0x138/0x170 fs/open.c:1383
 do_syscall_x64 arch/x86/entry/syscall_64.c:63 [inline]
 do_syscall_64+0x14d/0xf80 arch/x86/entry/syscall_64.c:94
 entry_SYSCALL_64_after_hwframe+0x77/0x7f

Memory state around the buggy address:
 ffff88810da35f80: 00 00 00 00 00 00 00 04 fc fc fc fc fc fc fc fc
 ffff88810da36000: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
>ffff88810da36080: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
                            ^
 ffff88810da36100: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
 ffff88810da36180: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D


***

If these findings have caused you to resend the series or submit a
separate fix, please add the following tag to your commit message:
  Tested-by: syzbot@syzkaller.appspotmail.com

---
This report is generated by a bot. It may contain errors.
syzbot ci engineers can be reached at syzkaller@googlegroups.com.

To test a patch for this bug, please reply with `#syz test`
(should be on a separate line).

The patch should be attached to the email.
Note: arguments like custom git repos and branches are not supported.

--_000_GV2P190MB275499A44FE1E8F8C1AF3A8FAB2D2GV2P190MB2754EURP_
Content-Type: text/html; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable

<html>
<head>
<meta http-equiv=3D"Content-Type" content=3D"text/html; charset=3Dus-ascii"=
>
</head>
<body>
<p style=3D"direction: ltr; line-height: normal; margin: 0px;"><span style=
=3D"font-family: &quot;Helvetica Neue&quot;; font-size: 13px; color: rgb(0,=
 0, 0);">#syz test</span></p>
<div style=3D"direction: ltr; font-family: Aptos, Arial, Helvetica, sans-se=
rif; font-size: 12pt; color: rgb(0, 0, 0);">
<br>
</div>
<div style=3D"direction: ltr; font-family: Aptos, Arial, Helvetica, sans-se=
rif; font-size: 12pt; color: rgb(0, 0, 0);">
<br>
</div>
<div id=3D"mail-editor-reference-message-container" style=3D"color: inherit=
; background-color: inherit;">
<div class=3D"ms-outlook-mobile-reference-message skipProofing">
<meta name=3D"Generator" content=3D"Microsoft Exchange Server" style=3D"col=
or: inherit; background-color: inherit;">
</div>
<div class=3D"ms-outlook-mobile-reference-message skipProofing" style=3D"te=
xt-align: left; padding: 3pt 0in 0in; border-width: 1pt medium medium; bord=
er-style: solid none none; border-color: rgb(181, 196, 223) currentcolor cu=
rrentcolor; font-family: Aptos; font-size: 12pt; color: black;">
<b>From: </b>syzbot ci &lt;syzbot+ci6167b51351f50705@syzkaller.appspotmail.=
com&gt;<br>
<b>Date: </b>Saturday, 18 April 2026 at 07:47<br>
<b>To: </b>adilger.kernel@dilger.ca &lt;adilger.kernel@dilger.ca&gt;, adilg=
er@dilger.ca &lt;adilger@dilger.ca&gt;, artem.blagodarenko@gmail.com &lt;ar=
tem.blagodarenko@gmail.com&gt;, linux-ext4@vger.kernel.org &lt;linux-ext4@v=
ger.kernel.org&gt;, pravin.shelar@sun.com &lt;pravin.shelar@sun.com&gt;<br>
<b>Cc: </b>syzbot@lists.linux.dev &lt;syzbot@lists.linux.dev&gt;, syzkaller=
-bugs@googlegroups.com &lt;syzkaller-bugs@googlegroups.com&gt;<br>
<b>Subject: </b>[syzbot ci] Re: Data in direntry (dirdata) feature<br>
<br>
</div>
<div class=3D"PlainText" style=3D"font-size: 11pt;">syzbot ci has tested th=
e following series<br>
<br>
[v1] Data in direntry (dirdata) feature<br>
<a href=3D"https://lore.kernel.org/all/20260417213723.74204-1-artem.blagoda=
renko@gmail.com" data-outlook-id=3D"7f7e28d9-ba7f-40d2-8a1f-6d412dd5dd07">h=
ttps://lore.kernel.org/all/20260417213723.74204-1-artem.blagodarenko@gmail.=
com</a><br>
* [PATCH 1/3] ext4: make dirdata work with metadata_csum<br>
* [PATCH 2/3] ext4: add dirdata support structures and helpers<br>
* [PATCH 3/3] ext4: dirdata feature<br>
<br>
and found the following issues:<br>
* KASAN: slab-out-of-bounds Read in __ext4_check_dir_entry<br>
* KASAN: slab-out-of-bounds Read in dx_probe<br>
* KASAN: slab-use-after-free Read in __ext4_check_dir_entry<br>
* KASAN: slab-use-after-free Read in dx_probe<br>
* KASAN: use-after-free Read in __ext4_check_dir_entry<br>
<br>
Full report is available here:<br>
<a href=3D"https://ci.syzbot.org/series/590e846e-42c0-4497-b6ae-b95ed446894=
1" data-outlook-id=3D"cf1e4c1a-38dd-4c99-9dce-5d57ef6e9695">https://ci.syzb=
ot.org/series/590e846e-42c0-4497-b6ae-b95ed4468941</a><br>
<br>
***<br>
<br>
KASAN: slab-out-of-bounds Read in __ext4_check_dir_entry<br>
<br>
tree:&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; torvalds<br>
URL:&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; <a href=3D"https://kernel.googleso=
urce.com/pub/scm/linux/kernel/git/torvalds/linux" data-outlook-id=3D"2e532c=
dd-0ebf-4156-92ef-c8c05b802ba5">
https://kernel.googlesource.com/pub/scm/linux/kernel/git/torvalds/linux</a>=
<br>
base:&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; 70b672833f4025341c11b22c7f83778a5cd611b=
c<br>
arch:&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; amd64<br>
compiler:&nbsp; Debian clang version 21.1.8 (++20251221033036+2078da43e25a-=
1~exp1~20251221153213.50), Debian LLD 21.1.8<br>
config:&nbsp;&nbsp;&nbsp; <a href=3D"https://ci.syzbot.org/builds/7b860156-=
1ca9-441f-b899-ebfb5a09620d/config" data-outlook-id=3D"c729b3d0-5034-49e8-9=
f9e-8544665b3054">
https://ci.syzbot.org/builds/7b860156-1ca9-441f-b899-ebfb5a09620d/config</a=
><br>
syz repro: <a href=3D"https://ci.syzbot.org/findings/d27eccd2-4663-4047-abb=
9-9c24cb32f887/syz_repro" data-outlook-id=3D"36f7b711-6428-439f-a8b5-ebd055=
ba87d3">
https://ci.syzbot.org/findings/d27eccd2-4663-4047-abb9-9c24cb32f887/syz_rep=
ro</a><br>
<br>
loop0: lost filesystem error report for type 5 error -117<br>
EXT4-fs (loop0): mounted filesystem 00000000-0000-0000-0000-000000000000 r/=
w without journal. Quota mode: none.<br>
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D<br>
BUG: KASAN: slab-out-of-bounds in ext4_dirent_get_data_len fs/ext4/ext4.h:4=
040 [inline]<br>
BUG: KASAN: slab-out-of-bounds in ext4_dir_entry_len fs/ext4/ext4.h:4060 [i=
nline]<br>
BUG: KASAN: slab-out-of-bounds in __ext4_check_dir_entry+0x527/0xa70 fs/ext=
4/dir.c:96<br>
Read of size 1 at addr ffff8881090bfe5c by task syz.0.20/5967<br>
<br>
CPU: 1 UID: 0 PID: 5967 Comm: syz.0.20 Not tainted syzkaller #0 PREEMPT(ful=
l)<br>
Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS 1.16.2-debian-1.16=
.2-1 04/01/2014<br>
Call Trace:<br>
&nbsp;&lt;TASK&gt;<br>
&nbsp;dump_stack_lvl+0xe8/0x150 lib/dump_stack.c:120<br>
&nbsp;print_address_description mm/kasan/report.c:378 [inline]<br>
&nbsp;print_report+0xba/0x230 mm/kasan/report.c:482<br>
&nbsp;kasan_report+0x117/0x150 mm/kasan/report.c:595<br>
&nbsp;ext4_dirent_get_data_len fs/ext4/ext4.h:4040 [inline]<br>
&nbsp;ext4_dir_entry_len fs/ext4/ext4.h:4060 [inline]<br>
&nbsp;__ext4_check_dir_entry+0x527/0xa70 fs/ext4/dir.c:96<br>
&nbsp;ext4_inlinedir_to_tree+0x6be/0xbf0 fs/ext4/inline.c:1322<br>
&nbsp;ext4_htree_fill_tree+0x50b/0x1230 fs/ext4/namei.c:1184<br>
&nbsp;ext4_dx_readdir fs/ext4/dir.c:600 [inline]<br>
&nbsp;ext4_readdir+0x2f7b/0x3870 fs/ext4/dir.c:146<br>
&nbsp;iterate_dir+0x399/0x570 fs/readdir.c:108<br>
&nbsp;__do_sys_getdents64 fs/readdir.c:412 [inline]<br>
&nbsp;__se_sys_getdents64+0xf1/0x280 fs/readdir.c:397<br>
&nbsp;do_syscall_x64 arch/x86/entry/syscall_64.c:63 [inline]<br>
&nbsp;do_syscall_64+0x14d/0xf80 arch/x86/entry/syscall_64.c:94<br>
&nbsp;entry_SYSCALL_64_after_hwframe+0x77/0x7f<br>
RIP: 0033:0x7fe47219c819<br>
Code: ff c3 66 2e 0f 1f 84 00 00 00 00 00 0f 1f 44 00 00 48 89 f8 48 89 f7 =
48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 &lt;48&gt; 3d 01 f=
0 ff ff 73 01 c3 48 c7 c1 e8 ff ff ff f7 d8 64 89 01 48<br>
RSP: 002b:00007fe4730c0028 EFLAGS: 00000246 ORIG_RAX: 00000000000000d9<br>
RAX: ffffffffffffffda RBX: 00007fe472415fa0 RCX: 00007fe47219c819<br>
RDX: 000000000000ff80 RSI: 9999999999999999 RDI: 0000000000000004<br>
RBP: 00007fe472232c91 R08: 0000000000000000 R09: 0000000000000000<br>
R10: 0000000000000000 R11: 0000000000000246 R12: 0000000000000000<br>
R13: 00007fe472416038 R14: 00007fe472415fa0 R15: 00007ffff595c618<br>
&nbsp;&lt;/TASK&gt;<br>
<br>
Allocated by task 5967:<br>
&nbsp;kasan_save_stack mm/kasan/common.c:57 [inline]<br>
&nbsp;kasan_save_track+0x3e/0x80 mm/kasan/common.c:78<br>
&nbsp;poison_kmalloc_redzone mm/kasan/common.c:398 [inline]<br>
&nbsp;__kasan_kmalloc+0x93/0xb0 mm/kasan/common.c:415<br>
&nbsp;kasan_kmalloc include/linux/kasan.h:263 [inline]<br>
&nbsp;__do_kmalloc_node mm/slub.c:5260 [inline]<br>
&nbsp;__kmalloc_noprof+0x35c/0x760 mm/slub.c:5272<br>
&nbsp;kmalloc_noprof include/linux/slab.h:954 [inline]<br>
&nbsp;ext4_mb_init+0x15d/0x2ad0 fs/ext4/mballoc.c:3729<br>
&nbsp;__ext4_fill_super fs/ext4/super.c:5623 [inline]<br>
&nbsp;ext4_fill_super+0x5647/0x6320 fs/ext4/super.c:5793<br>
&nbsp;get_tree_bdev_flags+0x431/0x4f0 fs/super.c:1694<br>
&nbsp;vfs_get_tree+0x92/0x2a0 fs/super.c:1754<br>
&nbsp;fc_mount fs/namespace.c:1193 [inline]<br>
&nbsp;do_new_mount_fc fs/namespace.c:3763 [inline]<br>
&nbsp;do_new_mount+0x341/0xd30 fs/namespace.c:3839<br>
&nbsp;do_mount fs/namespace.c:4172 [inline]<br>
&nbsp;__do_sys_mount fs/namespace.c:4361 [inline]<br>
&nbsp;__se_sys_mount+0x31d/0x420 fs/namespace.c:4338<br>
&nbsp;do_syscall_x64 arch/x86/entry/syscall_64.c:63 [inline]<br>
&nbsp;do_syscall_64+0x14d/0xf80 arch/x86/entry/syscall_64.c:94<br>
&nbsp;entry_SYSCALL_64_after_hwframe+0x77/0x7f<br>
<br>
The buggy address belongs to the object at ffff8881090bfe00<br>
&nbsp;which belongs to the cache kmalloc-64 of size 64<br>
The buggy address is located 44 bytes to the right of<br>
&nbsp;allocated 48-byte region [ffff8881090bfe00, ffff8881090bfe30)<br>
<br>
The buggy address belongs to the physical page:<br>
page: refcount:0 mapcount:0 mapping:0000000000000000 index:0x0 pfn:0x1090bf=
<br>
flags: 0x17ff00000000000(node=3D0|zone=3D2|lastcpupid=3D0x7ff)<br>
page_type: f5(slab)<br>
raw: 017ff00000000000 ffff8881000418c0 dead000000000100 dead000000000122<br=
>
raw: 0000000000000000 0000000800200020 00000000f5000000 0000000000000000<br=
>
page dumped because: kasan: bad access detected<br>
page_owner tracks the page as allocated<br>
page last allocated via order 0, migratetype Unmovable, gfp_mask 0xd2cc0(GF=
P_KERNEL|__GFP_NOWARN|__GFP_NORETRY|__GFP_COMP|__GFP_NOMEMALLOC), pid 1, tg=
id 1 (swapper/0), ts 16414655371, free_ts 15537272896<br>
&nbsp;set_page_owner include/linux/page_owner.h:32 [inline]<br>
&nbsp;post_alloc_hook+0x231/0x280 mm/page_alloc.c:1889<br>
&nbsp;prep_new_page mm/page_alloc.c:1897 [inline]<br>
&nbsp;get_page_from_freelist+0x24dc/0x2580 mm/page_alloc.c:3962<br>
&nbsp;__alloc_frozen_pages_noprof+0x18d/0x380 mm/page_alloc.c:5250<br>
&nbsp;alloc_slab_page mm/slub.c:3292 [inline]<br>
&nbsp;allocate_slab+0x77/0x660 mm/slub.c:3481<br>
&nbsp;new_slab mm/slub.c:3539 [inline]<br>
&nbsp;refill_objects+0x331/0x3c0 mm/slub.c:7175<br>
&nbsp;refill_sheaf mm/slub.c:2812 [inline]<br>
&nbsp;__pcs_replace_empty_main+0x2e6/0x730 mm/slub.c:4615<br>
&nbsp;alloc_from_pcs mm/slub.c:4717 [inline]<br>
&nbsp;slab_alloc_node mm/slub.c:4851 [inline]<br>
&nbsp;__do_kmalloc_node mm/slub.c:5259 [inline]<br>
&nbsp;__kmalloc_noprof+0x474/0x760 mm/slub.c:5272<br>
&nbsp;kmalloc_noprof include/linux/slab.h:954 [inline]<br>
&nbsp;kzalloc_noprof include/linux/slab.h:1188 [inline]<br>
&nbsp;kobject_get_path+0xc5/0x2f0 lib/kobject.c:161<br>
&nbsp;kobject_uevent_env+0x2a1/0x9e0 lib/kobject_uevent.c:545<br>
&nbsp;really_probe+0x789/0xaf0 drivers/base/dd.c:771<br>
&nbsp;__driver_probe_device+0x18c/0x320 drivers/base/dd.c:863<br>
&nbsp;driver_probe_device+0x4f/0x240 drivers/base/dd.c:893<br>
&nbsp;__device_attach_driver+0x279/0x430 drivers/base/dd.c:1021<br>
&nbsp;bus_for_each_drv+0x258/0x2f0 drivers/base/bus.c:500<br>
&nbsp;__device_attach+0x2c5/0x450 drivers/base/dd.c:1093<br>
&nbsp;device_initial_probe+0xa1/0xd0 drivers/base/dd.c:1148<br>
page last free pid 33 tgid 33 stack trace:<br>
&nbsp;reset_page_owner include/linux/page_owner.h:25 [inline]<br>
&nbsp;__free_pages_prepare mm/page_alloc.c:1433 [inline]<br>
&nbsp;__free_frozen_pages+0xc2b/0xdb0 mm/page_alloc.c:2978<br>
&nbsp;vfree+0x25a/0x400 mm/vmalloc.c:3479<br>
&nbsp;delayed_vfree_work+0x55/0x80 mm/vmalloc.c:3398<br>
&nbsp;process_one_work kernel/workqueue.c:3276 [inline]<br>
&nbsp;process_scheduled_works+0xb6e/0x18c0 kernel/workqueue.c:3359<br>
&nbsp;worker_thread+0xa53/0xfc0 kernel/workqueue.c:3440<br>
&nbsp;kthread+0x388/0x470 kernel/kthread.c:436<br>
&nbsp;ret_from_fork+0x51e/0xb90 arch/x86/kernel/process.c:158<br>
&nbsp;ret_from_fork_asm+0x1a/0x30 arch/x86/entry/entry_64.S:245<br>
<br>
Memory state around the buggy address:<br>
&nbsp;ffff8881090bfd00: 00 00 00 00 00 00 00 04 fc fc fc fc fc fc fc fc<br>
&nbsp;ffff8881090bfd80: 00 00 00 00 00 00 00 00 fc fc fc fc fc fc fc fc<br>
&gt;ffff8881090bfe00: 00 00 00 00 00 00 fc fc fc fc fc fc fc fc fc fc<br>
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nb=
sp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;=
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nb=
sp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;=
&nbsp; ^<br>
&nbsp;ffff8881090bfe80: fa fb fb fb fb fb fb fb fc fc fc fc fc fc fc fc<br>
&nbsp;ffff8881090bff00: 00 00 00 00 00 00 fc fc fc fc fc fc fc fc fc fc<br>
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D<br>
<br>
<br>
***<br>
<br>
KASAN: slab-out-of-bounds Read in dx_probe<br>
<br>
tree:&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; torvalds<br>
URL:&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; <a href=3D"https://kernel.googleso=
urce.com/pub/scm/linux/kernel/git/torvalds/linux" data-outlook-id=3D"b7677e=
70-7551-46e2-a098-75ab9e8c1c8f">
https://kernel.googlesource.com/pub/scm/linux/kernel/git/torvalds/linux</a>=
<br>
base:&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; 70b672833f4025341c11b22c7f83778a5cd611b=
c<br>
arch:&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; amd64<br>
compiler:&nbsp; Debian clang version 21.1.8 (++20251221033036+2078da43e25a-=
1~exp1~20251221153213.50), Debian LLD 21.1.8<br>
config:&nbsp;&nbsp;&nbsp; <a href=3D"https://ci.syzbot.org/builds/7b860156-=
1ca9-441f-b899-ebfb5a09620d/config" data-outlook-id=3D"dc350231-42d5-424a-a=
7de-8da96eaab065">
https://ci.syzbot.org/builds/7b860156-1ca9-441f-b899-ebfb5a09620d/config</a=
><br>
syz repro: <a href=3D"https://ci.syzbot.org/findings/a5fcf3bd-f1ae-4b81-b5d=
2-f96899ea7690/syz_repro" data-outlook-id=3D"76c2ae4e-9271-4362-af97-19c925=
4df0c3">
https://ci.syzbot.org/findings/a5fcf3bd-f1ae-4b81-b5d2-f96899ea7690/syz_rep=
ro</a><br>
<br>
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D<br>
BUG: KASAN: slab-out-of-bounds in ext4_dir_entry_is_tail fs/ext4/ext4.h:400=
1 [inline]<br>
BUG: KASAN: slab-out-of-bounds in ext4_dirent_get_data_len fs/ext4/ext4.h:4=
024 [inline]<br>
BUG: KASAN: slab-out-of-bounds in ext4_dir_entry_len fs/ext4/ext4.h:4060 [i=
nline]<br>
BUG: KASAN: slab-out-of-bounds in dx_root_limit fs/ext4/namei.c:583 [inline=
]<br>
BUG: KASAN: slab-out-of-bounds in dx_probe+0x1ac9/0x1d90 fs/ext4/namei.c:86=
1<br>
Read of size 4 at addr ffff88816a408c10 by task syz.2.19/5980<br>
<br>
CPU: 1 UID: 0 PID: 5980 Comm: syz.2.19 Not tainted syzkaller #0 PREEMPT(ful=
l)<br>
Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS 1.16.2-debian-1.16=
.2-1 04/01/2014<br>
Call Trace:<br>
&nbsp;&lt;TASK&gt;<br>
&nbsp;dump_stack_lvl+0xe8/0x150 lib/dump_stack.c:120<br>
&nbsp;print_address_description mm/kasan/report.c:378 [inline]<br>
&nbsp;print_report+0xba/0x230 mm/kasan/report.c:482<br>
&nbsp;kasan_report+0x117/0x150 mm/kasan/report.c:595<br>
&nbsp;ext4_dir_entry_is_tail fs/ext4/ext4.h:4001 [inline]<br>
&nbsp;ext4_dirent_get_data_len fs/ext4/ext4.h:4024 [inline]<br>
&nbsp;ext4_dir_entry_len fs/ext4/ext4.h:4060 [inline]<br>
&nbsp;dx_root_limit fs/ext4/namei.c:583 [inline]<br>
&nbsp;dx_probe+0x1ac9/0x1d90 fs/ext4/namei.c:861<br>
&nbsp;ext4_dx_find_entry fs/ext4/namei.c:1812 [inline]<br>
&nbsp;__ext4_find_entry+0x5a9/0x2140 fs/ext4/namei.c:1652<br>
&nbsp;ext4_lookup_entry fs/ext4/namei.c:1794 [inline]<br>
&nbsp;ext4_lookup+0x17b/0x710 fs/ext4/namei.c:1860<br>
&nbsp;__lookup_slow+0x2b7/0x410 fs/namei.c:1916<br>
&nbsp;lookup_slow+0x53/0x70 fs/namei.c:1933<br>
&nbsp;walk_component fs/namei.c:2279 [inline]<br>
&nbsp;lookup_last fs/namei.c:2780 [inline]<br>
&nbsp;path_lookupat+0x3f5/0x8c0 fs/namei.c:2804<br>
&nbsp;filename_lookup+0x256/0x5d0 fs/namei.c:2833<br>
&nbsp;user_path_at+0x40/0x160 fs/namei.c:3612<br>
&nbsp;do_mount fs/namespace.c:4169 [inline]<br>
&nbsp;__do_sys_mount fs/namespace.c:4361 [inline]<br>
&nbsp;__se_sys_mount+0x2dc/0x420 fs/namespace.c:4338<br>
&nbsp;do_syscall_x64 arch/x86/entry/syscall_64.c:63 [inline]<br>
&nbsp;do_syscall_64+0x14d/0xf80 arch/x86/entry/syscall_64.c:94<br>
&nbsp;entry_SYSCALL_64_after_hwframe+0x77/0x7f<br>
RIP: 0033:0x7f518919c819<br>
Code: ff c3 66 2e 0f 1f 84 00 00 00 00 00 0f 1f 44 00 00 48 89 f8 48 89 f7 =
48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 &lt;48&gt; 3d 01 f=
0 ff ff 73 01 c3 48 c7 c1 e8 ff ff ff f7 d8 64 89 01 48<br>
RSP: 002b:00007f5189fbb028 EFLAGS: 00000246 ORIG_RAX: 00000000000000a5<br>
RAX: ffffffffffffffda RBX: 00007f5189415fa0 RCX: 00007f518919c819<br>
RDX: 0000200000000140 RSI: 0000200000000100 RDI: 0000000000000000<br>
RBP: 00007f5189232c91 R08: 0000200000000d80 R09: 0000000000000000<br>
R10: 0000000001302060 R11: 0000000000000246 R12: 0000000000000000<br>
R13: 00007f5189416038 R14: 00007f5189415fa0 R15: 00007ffc5d8d15b8<br>
&nbsp;&lt;/TASK&gt;<br>
<br>
Allocated by task 5243:<br>
&nbsp;kasan_save_stack mm/kasan/common.c:57 [inline]<br>
&nbsp;kasan_save_track+0x3e/0x80 mm/kasan/common.c:78<br>
&nbsp;poison_kmalloc_redzone mm/kasan/common.c:398 [inline]<br>
&nbsp;__kasan_kmalloc+0x93/0xb0 mm/kasan/common.c:415<br>
&nbsp;kasan_kmalloc include/linux/kasan.h:263 [inline]<br>
&nbsp;__do_kmalloc_node mm/slub.c:5260 [inline]<br>
&nbsp;__kvmalloc_node_noprof+0x528/0x8a0 mm/slub.c:6752<br>
&nbsp;evdev_open+0xeb/0x5b0 drivers/input/evdev.c:468<br>
&nbsp;chrdev_open+0x4cd/0x5e0 fs/char_dev.c:411<br>
&nbsp;do_dentry_open+0x785/0x14e0 fs/open.c:949<br>
&nbsp;vfs_open+0x3b/0x340 fs/open.c:1081<br>
&nbsp;do_open fs/namei.c:4671 [inline]<br>
&nbsp;path_openat+0x2e08/0x3860 fs/namei.c:4830<br>
&nbsp;do_file_open+0x23e/0x4a0 fs/namei.c:4859<br>
&nbsp;do_sys_openat2+0x113/0x200 fs/open.c:1366<br>
&nbsp;do_sys_open fs/open.c:1372 [inline]<br>
&nbsp;__do_sys_openat fs/open.c:1388 [inline]<br>
&nbsp;__se_sys_openat fs/open.c:1383 [inline]<br>
&nbsp;__x64_sys_openat+0x138/0x170 fs/open.c:1383<br>
&nbsp;do_syscall_x64 arch/x86/entry/syscall_64.c:63 [inline]<br>
&nbsp;do_syscall_64+0x14d/0xf80 arch/x86/entry/syscall_64.c:94<br>
&nbsp;entry_SYSCALL_64_after_hwframe+0x77/0x7f<br>
<br>
The buggy address belongs to the object at ffff88816a408000<br>
&nbsp;which belongs to the cache kmalloc-2k of size 2048<br>
The buggy address is located 1088 bytes to the right of<br>
&nbsp;allocated 2000-byte region [ffff88816a408000, ffff88816a4087d0)<br>
<br>
The buggy address belongs to the physical page:<br>
page: refcount:0 mapcount:0 mapping:0000000000000000 index:0x0 pfn:0x16a408=
<br>
head: order:3 mapcount:0 entire_mapcount:0 nr_pages_mapped:0 pincount:0<br>
flags: 0x57ff00000000040(head|node=3D1|zone=3D2|lastcpupid=3D0x7ff)<br>
page_type: f5(slab)<br>
raw: 057ff00000000040 ffff888100042000 dead000000000100 dead000000000122<br=
>
raw: 0000000000000000 0000000800080008 00000000f5000000 0000000000000000<br=
>
head: 057ff00000000040 ffff888100042000 dead000000000100 dead000000000122<b=
r>
head: 0000000000000000 0000000800080008 00000000f5000000 0000000000000000<b=
r>
head: 057ff00000000003 ffffea0005a90201 00000000ffffffff 00000000ffffffff<b=
r>
head: ffffffffffffffff 0000000000000000 00000000ffffffff 0000000000000008<b=
r>
page dumped because: kasan: bad access detected<br>
page_owner tracks the page as allocated<br>
page last allocated via order 3, migratetype Unmovable, gfp_mask 0xd20c0(__=
GFP_IO|__GFP_FS|__GFP_NOWARN|__GFP_NORETRY|__GFP_COMP|__GFP_NOMEMALLOC), pi=
d 5243, tgid 5243 (acpid), ts 25906150911, free_ts 21905842969<br>
&nbsp;set_page_owner include/linux/page_owner.h:32 [inline]<br>
&nbsp;post_alloc_hook+0x231/0x280 mm/page_alloc.c:1889<br>
&nbsp;prep_new_page mm/page_alloc.c:1897 [inline]<br>
&nbsp;get_page_from_freelist+0x24dc/0x2580 mm/page_alloc.c:3962<br>
&nbsp;__alloc_frozen_pages_noprof+0x18d/0x380 mm/page_alloc.c:5250<br>
&nbsp;alloc_slab_page mm/slub.c:3292 [inline]<br>
&nbsp;allocate_slab+0x77/0x660 mm/slub.c:3481<br>
&nbsp;new_slab mm/slub.c:3539 [inline]<br>
&nbsp;refill_objects+0x331/0x3c0 mm/slub.c:7175<br>
&nbsp;refill_sheaf mm/slub.c:2812 [inline]<br>
&nbsp;__pcs_replace_empty_main+0x2e6/0x730 mm/slub.c:4615<br>
&nbsp;alloc_from_pcs mm/slub.c:4717 [inline]<br>
&nbsp;slab_alloc_node mm/slub.c:4851 [inline]<br>
&nbsp;__do_kmalloc_node mm/slub.c:5259 [inline]<br>
&nbsp;__kvmalloc_node_noprof+0x657/0x8a0 mm/slub.c:6752<br>
&nbsp;evdev_open+0xeb/0x5b0 drivers/input/evdev.c:468<br>
&nbsp;chrdev_open+0x4cd/0x5e0 fs/char_dev.c:411<br>
&nbsp;do_dentry_open+0x785/0x14e0 fs/open.c:949<br>
&nbsp;vfs_open+0x3b/0x340 fs/open.c:1081<br>
&nbsp;do_open fs/namei.c:4671 [inline]<br>
&nbsp;path_openat+0x2e08/0x3860 fs/namei.c:4830<br>
&nbsp;do_file_open+0x23e/0x4a0 fs/namei.c:4859<br>
&nbsp;do_sys_openat2+0x113/0x200 fs/open.c:1366<br>
&nbsp;do_sys_open fs/open.c:1372 [inline]<br>
&nbsp;__do_sys_openat fs/open.c:1388 [inline]<br>
&nbsp;__se_sys_openat fs/open.c:1383 [inline]<br>
&nbsp;__x64_sys_openat+0x138/0x170 fs/open.c:1383<br>
&nbsp;do_syscall_x64 arch/x86/entry/syscall_64.c:63 [inline]<br>
&nbsp;do_syscall_64+0x14d/0xf80 arch/x86/entry/syscall_64.c:94<br>
page last free pid 9 tgid 9 stack trace:<br>
&nbsp;reset_page_owner include/linux/page_owner.h:25 [inline]<br>
&nbsp;__free_pages_prepare mm/page_alloc.c:1433 [inline]<br>
&nbsp;__free_frozen_pages+0xc2b/0xdb0 mm/page_alloc.c:2978<br>
&nbsp;vfree+0x25a/0x400 mm/vmalloc.c:3479<br>
&nbsp;delayed_vfree_work+0x55/0x80 mm/vmalloc.c:3398<br>
&nbsp;process_one_work kernel/workqueue.c:3276 [inline]<br>
&nbsp;process_scheduled_works+0xb6e/0x18c0 kernel/workqueue.c:3359<br>
&nbsp;worker_thread+0xa53/0xfc0 kernel/workqueue.c:3440<br>
&nbsp;kthread+0x388/0x470 kernel/kthread.c:436<br>
&nbsp;ret_from_fork+0x51e/0xb90 arch/x86/kernel/process.c:158<br>
&nbsp;ret_from_fork_asm+0x1a/0x30 arch/x86/entry/entry_64.S:245<br>
<br>
Memory state around the buggy address:<br>
&nbsp;ffff88816a408b00: fc fc fc fc fc fc fc fc fc fc fc fc fc fc fc fc<br>
&nbsp;ffff88816a408b80: fc fc fc fc fc fc fc fc fc fc fc fc fc fc fc fc<br>
&gt;ffff88816a408c00: fc fc fc fc fc fc fc fc fc fc fc fc fc fc fc fc<br>
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nb=
sp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; ^<br>
&nbsp;ffff88816a408c80: fc fc fc fc fc fc fc fc fc fc fc fc fc fc fc fc<br>
&nbsp;ffff88816a408d00: fc fc fc fc fc fc fc fc fc fc fc fc fc fc fc fc<br>
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D<br>
<br>
<br>
***<br>
<br>
KASAN: slab-use-after-free Read in __ext4_check_dir_entry<br>
<br>
tree:&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; torvalds<br>
URL:&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; <a href=3D"https://kernel.googleso=
urce.com/pub/scm/linux/kernel/git/torvalds/linux" data-outlook-id=3D"34a214=
03-7579-4bce-9c39-4eb88bc94d24">
https://kernel.googlesource.com/pub/scm/linux/kernel/git/torvalds/linux</a>=
<br>
base:&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; 70b672833f4025341c11b22c7f83778a5cd611b=
c<br>
arch:&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; amd64<br>
compiler:&nbsp; Debian clang version 21.1.8 (++20251221033036+2078da43e25a-=
1~exp1~20251221153213.50), Debian LLD 21.1.8<br>
config:&nbsp;&nbsp;&nbsp; <a href=3D"https://ci.syzbot.org/builds/7b860156-=
1ca9-441f-b899-ebfb5a09620d/config" data-outlook-id=3D"33836192-550b-4dd2-8=
bcd-7c1443753139">
https://ci.syzbot.org/builds/7b860156-1ca9-441f-b899-ebfb5a09620d/config</a=
><br>
syz repro: <a href=3D"https://ci.syzbot.org/findings/e493ff66-4032-4979-9b5=
d-5118b2768ca5/syz_repro" data-outlook-id=3D"2347d342-f26d-41b5-90c0-9a753b=
176a42">
https://ci.syzbot.org/findings/e493ff66-4032-4979-9b5d-5118b2768ca5/syz_rep=
ro</a><br>
<br>
EXT4-fs (loop0): mounted filesystem 00000000-0000-0000-0000-000000000000 r/=
w without journal. Quota mode: none.<br>
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D<br>
BUG: KASAN: slab-use-after-free in ext4_dirent_get_data_len fs/ext4/ext4.h:=
4040 [inline]<br>
BUG: KASAN: slab-use-after-free in ext4_dir_entry_len fs/ext4/ext4.h:4060 [=
inline]<br>
BUG: KASAN: slab-use-after-free in __ext4_check_dir_entry+0x527/0xa70 fs/ex=
t4/dir.c:96<br>
Read of size 1 at addr ffff88810138889c by task syz.0.24/5978<br>
<br>
CPU: 0 UID: 0 PID: 5978 Comm: syz.0.24 Not tainted syzkaller #0 PREEMPT(ful=
l)<br>
Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS 1.16.2-debian-1.16=
.2-1 04/01/2014<br>
Call Trace:<br>
&nbsp;&lt;TASK&gt;<br>
&nbsp;dump_stack_lvl+0xe8/0x150 lib/dump_stack.c:120<br>
&nbsp;print_address_description mm/kasan/report.c:378 [inline]<br>
&nbsp;print_report+0xba/0x230 mm/kasan/report.c:482<br>
&nbsp;kasan_report+0x117/0x150 mm/kasan/report.c:595<br>
&nbsp;ext4_dirent_get_data_len fs/ext4/ext4.h:4040 [inline]<br>
&nbsp;ext4_dir_entry_len fs/ext4/ext4.h:4060 [inline]<br>
&nbsp;__ext4_check_dir_entry+0x527/0xa70 fs/ext4/dir.c:96<br>
&nbsp;ext4_inlinedir_to_tree+0x6be/0xbf0 fs/ext4/inline.c:1322<br>
&nbsp;ext4_htree_fill_tree+0x50b/0x1230 fs/ext4/namei.c:1184<br>
&nbsp;ext4_dx_readdir fs/ext4/dir.c:600 [inline]<br>
&nbsp;ext4_readdir+0x2f7b/0x3870 fs/ext4/dir.c:146<br>
&nbsp;iterate_dir+0x399/0x570 fs/readdir.c:108<br>
&nbsp;__do_sys_getdents64 fs/readdir.c:412 [inline]<br>
&nbsp;__se_sys_getdents64+0xf1/0x280 fs/readdir.c:397<br>
&nbsp;do_syscall_x64 arch/x86/entry/syscall_64.c:63 [inline]<br>
&nbsp;do_syscall_64+0x14d/0xf80 arch/x86/entry/syscall_64.c:94<br>
&nbsp;entry_SYSCALL_64_after_hwframe+0x77/0x7f<br>
RIP: 0033:0x7ff3fe19c819<br>
Code: ff c3 66 2e 0f 1f 84 00 00 00 00 00 0f 1f 44 00 00 48 89 f8 48 89 f7 =
48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 &lt;48&gt; 3d 01 f=
0 ff ff 73 01 c3 48 c7 c1 e8 ff ff ff f7 d8 64 89 01 48<br>
RSP: 002b:00007ff3fefac028 EFLAGS: 00000246 ORIG_RAX: 00000000000000d9<br>
RAX: ffffffffffffffda RBX: 00007ff3fe415fa0 RCX: 00007ff3fe19c819<br>
RDX: 000000000000ff80 RSI: 9999999999999999 RDI: 0000000000000004<br>
RBP: 00007ff3fe232c91 R08: 0000000000000000 R09: 0000000000000000<br>
R10: 0000000000000000 R11: 0000000000000246 R12: 0000000000000000<br>
R13: 00007ff3fe416038 R14: 00007ff3fe415fa0 R15: 00007ffd39a74998<br>
&nbsp;&lt;/TASK&gt;<br>
<br>
Allocated by task 5766:<br>
&nbsp;kasan_save_stack mm/kasan/common.c:57 [inline]<br>
&nbsp;kasan_save_track+0x3e/0x80 mm/kasan/common.c:78<br>
&nbsp;poison_kmalloc_redzone mm/kasan/common.c:398 [inline]<br>
&nbsp;__kasan_kmalloc+0x93/0xb0 mm/kasan/common.c:415<br>
&nbsp;kasan_kmalloc include/linux/kasan.h:263 [inline]<br>
&nbsp;__do_kmalloc_node mm/slub.c:5260 [inline]<br>
&nbsp;__kmalloc_noprof+0x35c/0x760 mm/slub.c:5272<br>
&nbsp;kmalloc_noprof include/linux/slab.h:954 [inline]<br>
&nbsp;kzalloc_noprof include/linux/slab.h:1188 [inline]<br>
&nbsp;tomoyo_encode2 security/tomoyo/realpath.c:45 [inline]<br>
&nbsp;tomoyo_encode+0x28b/0x550 security/tomoyo/realpath.c:80<br>
&nbsp;tomoyo_realpath_from_path+0x58d/0x5d0 security/tomoyo/realpath.c:283<=
br>
&nbsp;tomoyo_get_realpath security/tomoyo/file.c:151 [inline]<br>
&nbsp;tomoyo_check_open_permission+0x229/0x470 security/tomoyo/file.c:776<b=
r>
&nbsp;security_file_open+0xa9/0x240 security/security.c:2637<br>
&nbsp;do_dentry_open+0x384/0x14e0 fs/open.c:926<br>
&nbsp;vfs_open+0x3b/0x340 fs/open.c:1081<br>
&nbsp;do_open fs/namei.c:4671 [inline]<br>
&nbsp;path_openat+0x2e08/0x3860 fs/namei.c:4830<br>
&nbsp;do_file_open+0x23e/0x4a0 fs/namei.c:4859<br>
&nbsp;do_sys_openat2+0x113/0x200 fs/open.c:1366<br>
&nbsp;do_sys_open fs/open.c:1372 [inline]<br>
&nbsp;__do_sys_openat fs/open.c:1388 [inline]<br>
&nbsp;__se_sys_openat fs/open.c:1383 [inline]<br>
&nbsp;__x64_sys_openat+0x138/0x170 fs/open.c:1383<br>
&nbsp;do_syscall_x64 arch/x86/entry/syscall_64.c:63 [inline]<br>
&nbsp;do_syscall_64+0x14d/0xf80 arch/x86/entry/syscall_64.c:94<br>
&nbsp;entry_SYSCALL_64_after_hwframe+0x77/0x7f<br>
<br>
Freed by task 5766:<br>
&nbsp;kasan_save_stack mm/kasan/common.c:57 [inline]<br>
&nbsp;kasan_save_track+0x3e/0x80 mm/kasan/common.c:78<br>
&nbsp;kasan_save_free_info+0x46/0x50 mm/kasan/generic.c:584<br>
&nbsp;poison_slab_object mm/kasan/common.c:253 [inline]<br>
&nbsp;__kasan_slab_free+0x5c/0x80 mm/kasan/common.c:285<br>
&nbsp;kasan_slab_free include/linux/kasan.h:235 [inline]<br>
&nbsp;slab_free_hook mm/slub.c:2685 [inline]<br>
&nbsp;slab_free mm/slub.c:6165 [inline]<br>
&nbsp;kfree+0x1c1/0x630 mm/slub.c:6483<br>
&nbsp;tomoyo_check_open_permission+0x32c/0x470 security/tomoyo/file.c:791<b=
r>
&nbsp;security_file_open+0xa9/0x240 security/security.c:2637<br>
&nbsp;do_dentry_open+0x384/0x14e0 fs/open.c:926<br>
&nbsp;vfs_open+0x3b/0x340 fs/open.c:1081<br>
&nbsp;do_open fs/namei.c:4671 [inline]<br>
&nbsp;path_openat+0x2e08/0x3860 fs/namei.c:4830<br>
&nbsp;do_file_open+0x23e/0x4a0 fs/namei.c:4859<br>
&nbsp;do_sys_openat2+0x113/0x200 fs/open.c:1366<br>
&nbsp;do_sys_open fs/open.c:1372 [inline]<br>
&nbsp;__do_sys_openat fs/open.c:1388 [inline]<br>
&nbsp;__se_sys_openat fs/open.c:1383 [inline]<br>
&nbsp;__x64_sys_openat+0x138/0x170 fs/open.c:1383<br>
&nbsp;do_syscall_x64 arch/x86/entry/syscall_64.c:63 [inline]<br>
&nbsp;do_syscall_64+0x14d/0xf80 arch/x86/entry/syscall_64.c:94<br>
&nbsp;entry_SYSCALL_64_after_hwframe+0x77/0x7f<br>
<br>
The buggy address belongs to the object at ffff888101388880<br>
&nbsp;which belongs to the cache kmalloc-64 of size 64<br>
The buggy address is located 28 bytes inside of<br>
&nbsp;freed 64-byte region [ffff888101388880, ffff8881013888c0)<br>
<br>
The buggy address belongs to the physical page:<br>
page: refcount:0 mapcount:0 mapping:0000000000000000 index:0x0 pfn:0x101388=
<br>
flags: 0x17ff00000000000(node=3D0|zone=3D2|lastcpupid=3D0x7ff)<br>
page_type: f5(slab)<br>
raw: 017ff00000000000 ffff8881000418c0 dead000000000100 dead000000000122<br=
>
raw: 0000000000000000 0000000800200020 00000000f5000000 0000000000000000<br=
>
page dumped because: kasan: bad access detected<br>
page_owner tracks the page as allocated<br>
page last allocated via order 0, migratetype Unmovable, gfp_mask 0xd2cc0(GF=
P_KERNEL|__GFP_NOWARN|__GFP_NORETRY|__GFP_COMP|__GFP_NOMEMALLOC), pid 26, t=
gid 26 (kworker/u9:0), ts 4100832473, free_ts 4100767003<br>
&nbsp;set_page_owner include/linux/page_owner.h:32 [inline]<br>
&nbsp;post_alloc_hook+0x231/0x280 mm/page_alloc.c:1889<br>
&nbsp;prep_new_page mm/page_alloc.c:1897 [inline]<br>
&nbsp;get_page_from_freelist+0x24dc/0x2580 mm/page_alloc.c:3962<br>
&nbsp;__alloc_frozen_pages_noprof+0x18d/0x380 mm/page_alloc.c:5250<br>
&nbsp;alloc_slab_page mm/slub.c:3292 [inline]<br>
&nbsp;allocate_slab+0x77/0x660 mm/slub.c:3481<br>
&nbsp;new_slab mm/slub.c:3539 [inline]<br>
&nbsp;refill_objects+0x331/0x3c0 mm/slub.c:7175<br>
&nbsp;refill_sheaf mm/slub.c:2812 [inline]<br>
&nbsp;alloc_full_sheaf mm/slub.c:2834 [inline]<br>
&nbsp;__pcs_replace_empty_main+0x40a/0x730 mm/slub.c:4626<br>
&nbsp;alloc_from_pcs mm/slub.c:4717 [inline]<br>
&nbsp;slab_alloc_node mm/slub.c:4851 [inline]<br>
&nbsp;__do_kmalloc_node mm/slub.c:5259 [inline]<br>
&nbsp;__kmalloc_noprof+0x474/0x760 mm/slub.c:5272<br>
&nbsp;kmalloc_noprof include/linux/slab.h:954 [inline]<br>
&nbsp;kzalloc_noprof include/linux/slab.h:1188 [inline]<br>
&nbsp;lsm_blob_alloc security/security.c:193 [inline]<br>
&nbsp;lsm_task_alloc security/security.c:245 [inline]<br>
&nbsp;security_task_alloc+0x4d/0x330 security/security.c:2683<br>
&nbsp;copy_process+0x16df/0x3cd0 kernel/fork.c:2206<br>
&nbsp;kernel_clone+0x248/0x8e0 kernel/fork.c:2658<br>
&nbsp;user_mode_thread+0x110/0x180 kernel/fork.c:2734<br>
&nbsp;call_usermodehelper_exec_work+0x5c/0x230 kernel/umh.c:171<br>
&nbsp;process_one_work kernel/workqueue.c:3276 [inline]<br>
&nbsp;process_scheduled_works+0xb6e/0x18c0 kernel/workqueue.c:3359<br>
&nbsp;worker_thread+0xa53/0xfc0 kernel/workqueue.c:3440<br>
&nbsp;kthread+0x388/0x470 kernel/kthread.c:436<br>
&nbsp;ret_from_fork+0x51e/0xb90 arch/x86/kernel/process.c:158<br>
page last free pid 26 tgid 26 stack trace:<br>
&nbsp;reset_page_owner include/linux/page_owner.h:25 [inline]<br>
&nbsp;__free_pages_prepare mm/page_alloc.c:1433 [inline]<br>
&nbsp;__free_frozen_pages+0xc2b/0xdb0 mm/page_alloc.c:2978<br>
&nbsp;__kasan_populate_vmalloc_do mm/kasan/shadow.c:393 [inline]<br>
&nbsp;__kasan_populate_vmalloc+0x1b2/0x1d0 mm/kasan/shadow.c:424<br>
&nbsp;kasan_populate_vmalloc include/linux/kasan.h:580 [inline]<br>
&nbsp;alloc_vmap_area+0xd73/0x14b0 mm/vmalloc.c:2129<br>
&nbsp;__get_vm_area_node+0x1f8/0x300 mm/vmalloc.c:3232<br>
&nbsp;__vmalloc_node_range_noprof+0x372/0x1730 mm/vmalloc.c:4024<br>
&nbsp;__vmalloc_node_noprof+0xc2/0x100 mm/vmalloc.c:4124<br>
&nbsp;alloc_thread_stack_node kernel/fork.c:355 [inline]<br>
&nbsp;dup_task_struct+0x292/0x9e0 kernel/fork.c:924<br>
&nbsp;copy_process+0x508/0x3cd0 kernel/fork.c:2051<br>
&nbsp;kernel_clone+0x248/0x8e0 kernel/fork.c:2658<br>
&nbsp;user_mode_thread+0x110/0x180 kernel/fork.c:2734<br>
&nbsp;call_usermodehelper_exec_work+0x5c/0x230 kernel/umh.c:171<br>
&nbsp;process_one_work kernel/workqueue.c:3276 [inline]<br>
&nbsp;process_scheduled_works+0xb6e/0x18c0 kernel/workqueue.c:3359<br>
&nbsp;worker_thread+0xa53/0xfc0 kernel/workqueue.c:3440<br>
&nbsp;kthread+0x388/0x470 kernel/kthread.c:436<br>
&nbsp;ret_from_fork+0x51e/0xb90 arch/x86/kernel/process.c:158<br>
&nbsp;ret_from_fork_asm+0x1a/0x30 arch/x86/entry/entry_64.S:245<br>
<br>
Memory state around the buggy address:<br>
&nbsp;ffff888101388780: 00 00 00 00 00 00 00 04 fc fc fc fc fc fc fc fc<br>
&nbsp;ffff888101388800: fa fb fb fb fb fb fb fb fc fc fc fc fc fc fc fc<br>
&gt;ffff888101388880: fa fb fb fb fb fb fb fb fc fc fc fc fc fc fc fc<br>
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nb=
sp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;=
&nbsp;&nbsp; ^<br>
&nbsp;ffff888101388900: 00 00 00 00 00 00 00 fc fc fc fc fc fc fc fc fc<br>
&nbsp;ffff888101388980: 00 00 00 00 00 00 00 00 fc fc fc fc fc fc fc fc<br>
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D<br>
<br>
<br>
***<br>
<br>
KASAN: slab-use-after-free Read in dx_probe<br>
<br>
tree:&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; torvalds<br>
URL:&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; <a href=3D"https://kernel.googleso=
urce.com/pub/scm/linux/kernel/git/torvalds/linux" data-outlook-id=3D"df1749=
4e-35af-4d1d-8328-551b61d76d4a">
https://kernel.googlesource.com/pub/scm/linux/kernel/git/torvalds/linux</a>=
<br>
base:&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; 70b672833f4025341c11b22c7f83778a5cd611b=
c<br>
arch:&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; amd64<br>
compiler:&nbsp; Debian clang version 21.1.8 (++20251221033036+2078da43e25a-=
1~exp1~20251221153213.50), Debian LLD 21.1.8<br>
config:&nbsp;&nbsp;&nbsp; <a href=3D"https://ci.syzbot.org/builds/7b860156-=
1ca9-441f-b899-ebfb5a09620d/config" data-outlook-id=3D"8dffbec0-c430-411d-8=
3ef-dd557697bb79">
https://ci.syzbot.org/builds/7b860156-1ca9-441f-b899-ebfb5a09620d/config</a=
><br>
syz repro: <a href=3D"https://ci.syzbot.org/findings/5524eff5-62fb-4cff-8d4=
e-7e3750aa921b/syz_repro" data-outlook-id=3D"c15d77a8-a16b-4791-acfe-f1f681=
851a29">
https://ci.syzbot.org/findings/5524eff5-62fb-4cff-8d4e-7e3750aa921b/syz_rep=
ro</a><br>
<br>
EXT4-fs (loop2): mounted filesystem 00000000-0000-0000-0000-000000000000 ro=
 without journal. Quota mode: none.<br>
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D<br>
BUG: KASAN: slab-use-after-free in ext4_dir_entry_is_tail fs/ext4/ext4.h:40=
01 [inline]<br>
BUG: KASAN: slab-use-after-free in ext4_dirent_get_data_len fs/ext4/ext4.h:=
4024 [inline]<br>
BUG: KASAN: slab-use-after-free in ext4_dir_entry_len fs/ext4/ext4.h:4060 [=
inline]<br>
BUG: KASAN: slab-use-after-free in dx_root_limit fs/ext4/namei.c:583 [inlin=
e]<br>
BUG: KASAN: slab-use-after-free in dx_probe+0x1ac9/0x1d90 fs/ext4/namei.c:8=
61<br>
Read of size 4 at addr ffff888109c42c10 by task syz.2.20/5984<br>
<br>
CPU: 0 UID: 0 PID: 5984 Comm: syz.2.20 Not tainted syzkaller #0 PREEMPT(ful=
l)<br>
Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS 1.16.2-debian-1.16=
.2-1 04/01/2014<br>
Call Trace:<br>
&nbsp;&lt;TASK&gt;<br>
&nbsp;dump_stack_lvl+0xe8/0x150 lib/dump_stack.c:120<br>
&nbsp;print_address_description mm/kasan/report.c:378 [inline]<br>
&nbsp;print_report+0xba/0x230 mm/kasan/report.c:482<br>
&nbsp;kasan_report+0x117/0x150 mm/kasan/report.c:595<br>
&nbsp;ext4_dir_entry_is_tail fs/ext4/ext4.h:4001 [inline]<br>
&nbsp;ext4_dirent_get_data_len fs/ext4/ext4.h:4024 [inline]<br>
&nbsp;ext4_dir_entry_len fs/ext4/ext4.h:4060 [inline]<br>
&nbsp;dx_root_limit fs/ext4/namei.c:583 [inline]<br>
&nbsp;dx_probe+0x1ac9/0x1d90 fs/ext4/namei.c:861<br>
&nbsp;ext4_dx_find_entry fs/ext4/namei.c:1812 [inline]<br>
&nbsp;__ext4_find_entry+0x5a9/0x2140 fs/ext4/namei.c:1652<br>
&nbsp;ext4_lookup_entry fs/ext4/namei.c:1794 [inline]<br>
&nbsp;ext4_lookup+0x17b/0x710 fs/ext4/namei.c:1860<br>
&nbsp;lookup_open fs/namei.c:4456 [inline]<br>
&nbsp;open_last_lookups fs/namei.c:4583 [inline]<br>
&nbsp;path_openat+0x11ac/0x3860 fs/namei.c:4827<br>
&nbsp;do_file_open+0x23e/0x4a0 fs/namei.c:4859<br>
&nbsp;do_sys_openat2+0x113/0x200 fs/open.c:1366<br>
&nbsp;do_sys_open fs/open.c:1372 [inline]<br>
&nbsp;__do_sys_openat fs/open.c:1388 [inline]<br>
&nbsp;__se_sys_openat fs/open.c:1383 [inline]<br>
&nbsp;__x64_sys_openat+0x138/0x170 fs/open.c:1383<br>
&nbsp;do_syscall_x64 arch/x86/entry/syscall_64.c:63 [inline]<br>
&nbsp;do_syscall_64+0x14d/0xf80 arch/x86/entry/syscall_64.c:94<br>
&nbsp;entry_SYSCALL_64_after_hwframe+0x77/0x7f<br>
RIP: 0033:0x7fb97dd9c819<br>
Code: ff c3 66 2e 0f 1f 84 00 00 00 00 00 0f 1f 44 00 00 48 89 f8 48 89 f7 =
48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 &lt;48&gt; 3d 01 f=
0 ff ff 73 01 c3 48 c7 c1 e8 ff ff ff f7 d8 64 89 01 48<br>
RSP: 002b:00007fb97ec96028 EFLAGS: 00000246 ORIG_RAX: 0000000000000101<br>
RAX: ffffffffffffffda RBX: 00007fb97e015fa0 RCX: 00007fb97dd9c819<br>
RDX: 0000000000042041 RSI: 0000200000000700 RDI: ffffffffffffff9c<br>
RBP: 00007fb97de32c91 R08: 0000000000000000 R09: 0000000000000000<br>
R10: 000000000000001d R11: 0000000000000246 R12: 0000000000000000<br>
R13: 00007fb97e016038 R14: 00007fb97e015fa0 R15: 00007fffcac5f5a8<br>
&nbsp;&lt;/TASK&gt;<br>
<br>
Allocated by task 5828:<br>
&nbsp;kasan_save_stack mm/kasan/common.c:57 [inline]<br>
&nbsp;kasan_save_track+0x3e/0x80 mm/kasan/common.c:78<br>
&nbsp;poison_kmalloc_redzone mm/kasan/common.c:398 [inline]<br>
&nbsp;__kasan_kmalloc+0x93/0xb0 mm/kasan/common.c:415<br>
&nbsp;kasan_kmalloc include/linux/kasan.h:263 [inline]<br>
&nbsp;__do_kmalloc_node mm/slub.c:5260 [inline]<br>
&nbsp;__kmalloc_noprof+0x35c/0x760 mm/slub.c:5272<br>
&nbsp;kmalloc_noprof include/linux/slab.h:954 [inline]<br>
&nbsp;tomoyo_realpath_from_path+0xe3/0x5d0 security/tomoyo/realpath.c:251<b=
r>
&nbsp;tomoyo_get_realpath security/tomoyo/file.c:151 [inline]<br>
&nbsp;tomoyo_path_perm+0x283/0x560 security/tomoyo/file.c:827<br>
&nbsp;tomoyo_path_symlink+0xab/0xf0 security/tomoyo/tomoyo.c:212<br>
&nbsp;security_path_symlink+0x16f/0x360 security/security.c:1477<br>
&nbsp;filename_symlinkat+0x134/0x410 fs/namei.c:5638<br>
&nbsp;__do_sys_symlink fs/namei.c:5667 [inline]<br>
&nbsp;__se_sys_symlink+0x4d/0x2b0 fs/namei.c:5663<br>
&nbsp;do_syscall_x64 arch/x86/entry/syscall_64.c:63 [inline]<br>
&nbsp;do_syscall_64+0x14d/0xf80 arch/x86/entry/syscall_64.c:94<br>
&nbsp;entry_SYSCALL_64_after_hwframe+0x77/0x7f<br>
<br>
Freed by task 5828:<br>
&nbsp;kasan_save_stack mm/kasan/common.c:57 [inline]<br>
&nbsp;kasan_save_track+0x3e/0x80 mm/kasan/common.c:78<br>
&nbsp;kasan_save_free_info+0x46/0x50 mm/kasan/generic.c:584<br>
&nbsp;poison_slab_object mm/kasan/common.c:253 [inline]<br>
&nbsp;__kasan_slab_free+0x5c/0x80 mm/kasan/common.c:285<br>
&nbsp;kasan_slab_free include/linux/kasan.h:235 [inline]<br>
&nbsp;slab_free_hook mm/slub.c:2685 [inline]<br>
&nbsp;slab_free mm/slub.c:6165 [inline]<br>
&nbsp;kfree+0x1c1/0x630 mm/slub.c:6483<br>
&nbsp;tomoyo_realpath_from_path+0x598/0x5d0 security/tomoyo/realpath.c:286<=
br>
&nbsp;tomoyo_get_realpath security/tomoyo/file.c:151 [inline]<br>
&nbsp;tomoyo_path_perm+0x283/0x560 security/tomoyo/file.c:827<br>
&nbsp;tomoyo_path_symlink+0xab/0xf0 security/tomoyo/tomoyo.c:212<br>
&nbsp;security_path_symlink+0x16f/0x360 security/security.c:1477<br>
&nbsp;filename_symlinkat+0x134/0x410 fs/namei.c:5638<br>
&nbsp;__do_sys_symlink fs/namei.c:5667 [inline]<br>
&nbsp;__se_sys_symlink+0x4d/0x2b0 fs/namei.c:5663<br>
&nbsp;do_syscall_x64 arch/x86/entry/syscall_64.c:63 [inline]<br>
&nbsp;do_syscall_64+0x14d/0xf80 arch/x86/entry/syscall_64.c:94<br>
&nbsp;entry_SYSCALL_64_after_hwframe+0x77/0x7f<br>
<br>
The buggy address belongs to the object at ffff888109c42000<br>
&nbsp;which belongs to the cache kmalloc-4k of size 4096<br>
The buggy address is located 3088 bytes inside of<br>
&nbsp;freed 4096-byte region [ffff888109c42000, ffff888109c43000)<br>
<br>
The buggy address belongs to the physical page:<br>
page: refcount:0 mapcount:0 mapping:0000000000000000 index:0x0 pfn:0x109c40=
<br>
head: order:3 mapcount:0 entire_mapcount:0 nr_pages_mapped:0 pincount:0<br>
flags: 0x17ff00000000040(head|node=3D0|zone=3D2|lastcpupid=3D0x7ff)<br>
page_type: f5(slab)<br>
raw: 017ff00000000040 ffff888100042140 dead000000000100 dead000000000122<br=
>
raw: 0000000000000000 0000000800040004 00000000f5000000 0000000000000000<br=
>
head: 017ff00000000040 ffff888100042140 dead000000000100 dead000000000122<b=
r>
head: 0000000000000000 0000000800040004 00000000f5000000 0000000000000000<b=
r>
head: 017ff00000000003 ffffea0004271001 00000000ffffffff 00000000ffffffff<b=
r>
head: ffffffffffffffff 0000000000000000 00000000ffffffff 0000000000000008<b=
r>
page dumped because: kasan: bad access detected<br>
page_owner tracks the page as allocated<br>
page last allocated via order 3, migratetype Unmovable, gfp_mask 0xd2040(__=
GFP_IO|__GFP_NOWARN|__GFP_NORETRY|__GFP_COMP|__GFP_NOMEMALLOC), pid 5828, t=
gid 5828 (udevd), ts 67573015608, free_ts 47549723112<br>
&nbsp;set_page_owner include/linux/page_owner.h:32 [inline]<br>
&nbsp;post_alloc_hook+0x231/0x280 mm/page_alloc.c:1889<br>
&nbsp;prep_new_page mm/page_alloc.c:1897 [inline]<br>
&nbsp;get_page_from_freelist+0x24dc/0x2580 mm/page_alloc.c:3962<br>
&nbsp;__alloc_frozen_pages_noprof+0x18d/0x380 mm/page_alloc.c:5250<br>
&nbsp;alloc_slab_page mm/slub.c:3292 [inline]<br>
&nbsp;allocate_slab+0x77/0x660 mm/slub.c:3481<br>
&nbsp;new_slab mm/slub.c:3539 [inline]<br>
&nbsp;refill_objects+0x331/0x3c0 mm/slub.c:7175<br>
&nbsp;refill_sheaf mm/slub.c:2812 [inline]<br>
&nbsp;__pcs_replace_empty_main+0x2e6/0x730 mm/slub.c:4615<br>
&nbsp;alloc_from_pcs mm/slub.c:4717 [inline]<br>
&nbsp;slab_alloc_node mm/slub.c:4851 [inline]<br>
&nbsp;__do_kmalloc_node mm/slub.c:5259 [inline]<br>
&nbsp;__kmalloc_noprof+0x474/0x760 mm/slub.c:5272<br>
&nbsp;kmalloc_noprof include/linux/slab.h:954 [inline]<br>
&nbsp;tomoyo_realpath_from_path+0xe3/0x5d0 security/tomoyo/realpath.c:251<b=
r>
&nbsp;tomoyo_get_realpath security/tomoyo/file.c:151 [inline]<br>
&nbsp;tomoyo_path_perm+0x283/0x560 security/tomoyo/file.c:827<br>
&nbsp;tomoyo_path_symlink+0xab/0xf0 security/tomoyo/tomoyo.c:212<br>
&nbsp;security_path_symlink+0x16f/0x360 security/security.c:1477<br>
&nbsp;filename_symlinkat+0x134/0x410 fs/namei.c:5638<br>
&nbsp;__do_sys_symlink fs/namei.c:5667 [inline]<br>
&nbsp;__se_sys_symlink+0x4d/0x2b0 fs/namei.c:5663<br>
&nbsp;do_syscall_x64 arch/x86/entry/syscall_64.c:63 [inline]<br>
&nbsp;do_syscall_64+0x14d/0xf80 arch/x86/entry/syscall_64.c:94<br>
&nbsp;entry_SYSCALL_64_after_hwframe+0x77/0x7f<br>
page last free pid 5718 tgid 5718 stack trace:<br>
&nbsp;reset_page_owner include/linux/page_owner.h:25 [inline]<br>
&nbsp;__free_pages_prepare mm/page_alloc.c:1433 [inline]<br>
&nbsp;__free_frozen_pages+0xc2b/0xdb0 mm/page_alloc.c:2978<br>
&nbsp;__slab_free+0x263/0x2b0 mm/slub.c:5573<br>
&nbsp;qlink_free mm/kasan/quarantine.c:163 [inline]<br>
&nbsp;qlist_free_all+0x97/0x100 mm/kasan/quarantine.c:179<br>
&nbsp;kasan_quarantine_reduce+0x148/0x160 mm/kasan/quarantine.c:286<br>
&nbsp;__kasan_slab_alloc+0x22/0x80 mm/kasan/common.c:350<br>
&nbsp;kasan_slab_alloc include/linux/kasan.h:253 [inline]<br>
&nbsp;slab_post_alloc_hook mm/slub.c:4538 [inline]<br>
&nbsp;slab_alloc_node mm/slub.c:4866 [inline]<br>
&nbsp;kmem_cache_alloc_noprof+0x2bc/0x650 mm/slub.c:4873<br>
&nbsp;alloc_filename fs/namei.c:142 [inline]<br>
&nbsp;do_getname+0x2e/0x250 fs/namei.c:182<br>
&nbsp;getname include/linux/fs.h:2512 [inline]<br>
&nbsp;getname_maybe_null include/linux/fs.h:2519 [inline]<br>
&nbsp;class_filename_maybe_null_constructor include/linux/fs.h:2543 [inline=
]<br>
&nbsp;vfs_fstatat+0x45/0x170 fs/stat.c:368<br>
&nbsp;__do_sys_newfstatat fs/stat.c:538 [inline]<br>
&nbsp;__se_sys_newfstatat fs/stat.c:532 [inline]<br>
&nbsp;__x64_sys_newfstatat+0x151/0x200 fs/stat.c:532<br>
&nbsp;do_syscall_x64 arch/x86/entry/syscall_64.c:63 [inline]<br>
&nbsp;do_syscall_64+0x14d/0xf80 arch/x86/entry/syscall_64.c:94<br>
&nbsp;entry_SYSCALL_64_after_hwframe+0x77/0x7f<br>
<br>
Memory state around the buggy address:<br>
&nbsp;ffff888109c42b00: fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb<br>
&nbsp;ffff888109c42b80: fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb<br>
&gt;ffff888109c42c00: fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb<br>
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nb=
sp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; ^<br>
&nbsp;ffff888109c42c80: fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb<br>
&nbsp;ffff888109c42d00: fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb<br>
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D<br>
<br>
<br>
***<br>
<br>
KASAN: use-after-free Read in __ext4_check_dir_entry<br>
<br>
tree:&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; torvalds<br>
URL:&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; <a href=3D"https://kernel.googleso=
urce.com/pub/scm/linux/kernel/git/torvalds/linux" data-outlook-id=3D"083b5b=
01-4bb0-4d1e-a48a-3a84cbfe69c9">
https://kernel.googlesource.com/pub/scm/linux/kernel/git/torvalds/linux</a>=
<br>
base:&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; 70b672833f4025341c11b22c7f83778a5cd611b=
c<br>
arch:&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; amd64<br>
compiler:&nbsp; Debian clang version 21.1.8 (++20251221033036+2078da43e25a-=
1~exp1~20251221153213.50), Debian LLD 21.1.8<br>
config:&nbsp;&nbsp;&nbsp; <a href=3D"https://ci.syzbot.org/builds/7b860156-=
1ca9-441f-b899-ebfb5a09620d/config" data-outlook-id=3D"79734ce6-db91-444d-a=
a4c-0c0262382203">
https://ci.syzbot.org/builds/7b860156-1ca9-441f-b899-ebfb5a09620d/config</a=
><br>
syz repro: <a href=3D"https://ci.syzbot.org/findings/21333690-a422-407b-92c=
7-9247a0075b74/syz_repro" data-outlook-id=3D"0202a69e-a0fa-479a-aac2-23b583=
5c271b">
https://ci.syzbot.org/findings/21333690-a422-407b-92c7-9247a0075b74/syz_rep=
ro</a><br>
<br>
loop1: lost filesystem error report for type 5 error -117<br>
EXT4-fs (loop1): mounted filesystem 00000000-0000-0000-0000-000000000000 r/=
w without journal. Quota mode: none.<br>
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D<br>
BUG: KASAN: use-after-free in ext4_dirent_get_data_len fs/ext4/ext4.h:4040 =
[inline]<br>
BUG: KASAN: use-after-free in ext4_dir_entry_len fs/ext4/ext4.h:4060 [inlin=
e]<br>
BUG: KASAN: use-after-free in __ext4_check_dir_entry+0x527/0xa70 fs/ext4/di=
r.c:96<br>
Read of size 1 at addr ffff88810da3609c by task syz.1.20/5966<br>
<br>
CPU: 0 UID: 0 PID: 5966 Comm: syz.1.20 Not tainted syzkaller #0 PREEMPT(ful=
l)<br>
Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS 1.16.2-debian-1.16=
.2-1 04/01/2014<br>
Call Trace:<br>
&nbsp;&lt;TASK&gt;<br>
&nbsp;dump_stack_lvl+0xe8/0x150 lib/dump_stack.c:120<br>
&nbsp;print_address_description mm/kasan/report.c:378 [inline]<br>
&nbsp;print_report+0xba/0x230 mm/kasan/report.c:482<br>
&nbsp;kasan_report+0x117/0x150 mm/kasan/report.c:595<br>
&nbsp;ext4_dirent_get_data_len fs/ext4/ext4.h:4040 [inline]<br>
&nbsp;ext4_dir_entry_len fs/ext4/ext4.h:4060 [inline]<br>
&nbsp;__ext4_check_dir_entry+0x527/0xa70 fs/ext4/dir.c:96<br>
&nbsp;ext4_inlinedir_to_tree+0x6be/0xbf0 fs/ext4/inline.c:1322<br>
&nbsp;ext4_htree_fill_tree+0x50b/0x1230 fs/ext4/namei.c:1184<br>
&nbsp;ext4_dx_readdir fs/ext4/dir.c:600 [inline]<br>
&nbsp;ext4_readdir+0x2f7b/0x3870 fs/ext4/dir.c:146<br>
&nbsp;iterate_dir+0x399/0x570 fs/readdir.c:108<br>
&nbsp;__do_sys_getdents64 fs/readdir.c:412 [inline]<br>
&nbsp;__se_sys_getdents64+0xf1/0x280 fs/readdir.c:397<br>
&nbsp;do_syscall_x64 arch/x86/entry/syscall_64.c:63 [inline]<br>
&nbsp;do_syscall_64+0x14d/0xf80 arch/x86/entry/syscall_64.c:94<br>
&nbsp;entry_SYSCALL_64_after_hwframe+0x77/0x7f<br>
RIP: 0033:0x7fb82a19c819<br>
Code: ff c3 66 2e 0f 1f 84 00 00 00 00 00 0f 1f 44 00 00 48 89 f8 48 89 f7 =
48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 &lt;48&gt; 3d 01 f=
0 ff ff 73 01 c3 48 c7 c1 e8 ff ff ff f7 d8 64 89 01 48<br>
RSP: 002b:00007fb82b01a028 EFLAGS: 00000246 ORIG_RAX: 00000000000000d9<br>
RAX: ffffffffffffffda RBX: 00007fb82a415fa0 RCX: 00007fb82a19c819<br>
RDX: 000000000000ff80 RSI: 9999999999999999 RDI: 0000000000000004<br>
RBP: 00007fb82a232c91 R08: 0000000000000000 R09: 0000000000000000<br>
R10: 0000000000000000 R11: 0000000000000246 R12: 0000000000000000<br>
R13: 00007fb82a416038 R14: 00007fb82a415fa0 R15: 00007ffdc30464e8<br>
&nbsp;&lt;/TASK&gt;<br>
<br>
The buggy address belongs to the physical page:<br>
page: refcount:0 mapcount:0 mapping:0000000000000000 index:0xffff88810da360=
00 pfn:0x10da36<br>
flags: 0x17ff00000000000(node=3D0|zone=3D2|lastcpupid=3D0x7ff)<br>
page_type: f0(buddy)<br>
raw: 017ff00000000000 ffffea0004364708 ffffea000436a7c8 0000000000000000<br=
>
raw: ffff88810da36000 0000000000000000 00000000f0000000 0000000000000000<br=
>
page dumped because: kasan: bad access detected<br>
page_owner tracks the page as freed<br>
page last allocated via order 0, migratetype Unmovable, gfp_mask 0xd2c00(GF=
P_NOIO|__GFP_NOWARN|__GFP_NORETRY|__GFP_COMP|__GFP_NOMEMALLOC), pid 1, tgid=
 1 (swapper/0), ts 15037633903, free_ts 26770192426<br>
&nbsp;set_page_owner include/linux/page_owner.h:32 [inline]<br>
&nbsp;post_alloc_hook+0x231/0x280 mm/page_alloc.c:1889<br>
&nbsp;prep_new_page mm/page_alloc.c:1897 [inline]<br>
&nbsp;get_page_from_freelist+0x24dc/0x2580 mm/page_alloc.c:3962<br>
&nbsp;__alloc_frozen_pages_noprof+0x18d/0x380 mm/page_alloc.c:5250<br>
&nbsp;alloc_slab_page mm/slub.c:3292 [inline]<br>
&nbsp;allocate_slab+0x77/0x660 mm/slub.c:3481<br>
&nbsp;new_slab mm/slub.c:3539 [inline]<br>
&nbsp;refill_objects+0x331/0x3c0 mm/slub.c:7175<br>
&nbsp;refill_sheaf mm/slub.c:2812 [inline]<br>
&nbsp;__pcs_replace_empty_main+0x2e6/0x730 mm/slub.c:4615<br>
&nbsp;alloc_from_pcs mm/slub.c:4717 [inline]<br>
&nbsp;slab_alloc_node mm/slub.c:4851 [inline]<br>
&nbsp;__do_kmalloc_node mm/slub.c:5259 [inline]<br>
&nbsp;__kmalloc_noprof+0x474/0x760 mm/slub.c:5272<br>
&nbsp;kmalloc_noprof include/linux/slab.h:954 [inline]<br>
&nbsp;usb_alloc_urb+0x46/0x150 drivers/usb/core/urb.c:75<br>
&nbsp;usb_internal_control_msg drivers/usb/core/message.c:110 [inline]<br>
&nbsp;usb_control_msg+0x118/0x3e0 drivers/usb/core/message.c:167<br>
&nbsp;usb_get_descriptor+0xb1/0x3e0 drivers/usb/core/message.c:852<br>
&nbsp;usb_get_configuration+0x3b9/0x54f0 drivers/usb/core/config.c:986<br>
&nbsp;usb_enumerate_device drivers/usb/core/hub.c:2527 [inline]<br>
&nbsp;usb_new_device+0x145/0x16f0 drivers/usb/core/hub.c:2665<br>
&nbsp;register_root_hub+0x270/0x5f0 drivers/usb/core/hcd.c:990<br>
&nbsp;usb_add_hcd+0xba1/0x10b0 drivers/usb/core/hcd.c:2987<br>
&nbsp;vhci_hcd_probe+0x1fa/0x3e0 drivers/usb/usbip/vhci_hcd.c:1401<br>
&nbsp;platform_probe+0xf9/0x190 drivers/base/platform.c:1418<br>
page last free pid 5262 tgid 5262 stack trace:<br>
&nbsp;reset_page_owner include/linux/page_owner.h:25 [inline]<br>
&nbsp;__free_pages_prepare mm/page_alloc.c:1433 [inline]<br>
&nbsp;__free_frozen_pages+0xc2b/0xdb0 mm/page_alloc.c:2978<br>
&nbsp;__slab_free+0x263/0x2b0 mm/slub.c:5573<br>
&nbsp;qlink_free mm/kasan/quarantine.c:163 [inline]<br>
&nbsp;qlist_free_all+0x97/0x100 mm/kasan/quarantine.c:179<br>
&nbsp;kasan_quarantine_reduce+0x148/0x160 mm/kasan/quarantine.c:286<br>
&nbsp;__kasan_slab_alloc+0x22/0x80 mm/kasan/common.c:350<br>
&nbsp;kasan_slab_alloc include/linux/kasan.h:253 [inline]<br>
&nbsp;slab_post_alloc_hook mm/slub.c:4538 [inline]<br>
&nbsp;slab_alloc_node mm/slub.c:4866 [inline]<br>
&nbsp;kmem_cache_alloc_noprof+0x2bc/0x650 mm/slub.c:4873<br>
&nbsp;alloc_empty_file+0x55/0x1d0 fs/file_table.c:237<br>
&nbsp;path_openat+0x10f/0x3860 fs/namei.c:4816<br>
&nbsp;do_file_open+0x23e/0x4a0 fs/namei.c:4859<br>
&nbsp;do_sys_openat2+0x113/0x200 fs/open.c:1366<br>
&nbsp;do_sys_open fs/open.c:1372 [inline]<br>
&nbsp;__do_sys_openat fs/open.c:1388 [inline]<br>
&nbsp;__se_sys_openat fs/open.c:1383 [inline]<br>
&nbsp;__x64_sys_openat+0x138/0x170 fs/open.c:1383<br>
&nbsp;do_syscall_x64 arch/x86/entry/syscall_64.c:63 [inline]<br>
&nbsp;do_syscall_64+0x14d/0xf80 arch/x86/entry/syscall_64.c:94<br>
&nbsp;entry_SYSCALL_64_after_hwframe+0x77/0x7f<br>
<br>
Memory state around the buggy address:<br>
&nbsp;ffff88810da35f80: 00 00 00 00 00 00 00 04 fc fc fc fc fc fc fc fc<br>
&nbsp;ffff88810da36000: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff<br>
&gt;ffff88810da36080: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff<br>
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nb=
sp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;=
&nbsp;&nbsp; ^<br>
&nbsp;ffff88810da36100: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff<br>
&nbsp;ffff88810da36180: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff<br>
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D<br>
<br>
<br>
***<br>
<br>
If these findings have caused you to resend the series or submit a<br>
separate fix, please add the following tag to your commit message:<br>
&nbsp; Tested-by: syzbot@syzkaller.appspotmail.com<br>
<br>
---<br>
This report is generated by a bot. It may contain errors.<br>
syzbot ci engineers can be reached at syzkaller@googlegroups.com.<br>
<br>
To test a patch for this bug, please reply with `#syz test`<br>
(should be on a separate line).<br>
<br>
The patch should be attached to the email.<br>
Note: arguments like custom git repos and branches are not supported.<br>
</div>
</div>
</body>
</html>

--_000_GV2P190MB275499A44FE1E8F8C1AF3A8FAB2D2GV2P190MB2754EURP_--

--_004_GV2P190MB275499A44FE1E8F8C1AF3A8FAB2D2GV2P190MB2754EURP_
Content-Type: application/octet-stream; name="0001-ext4-fix-syzbot.patch"
Content-Description: 0001-ext4-fix-syzbot.patch
Content-Disposition: attachment; filename="0001-ext4-fix-syzbot.patch";
	size=4270; creation-date="Wed, 22 Apr 2026 09:34:13 GMT";
	modification-date="Wed, 22 Apr 2026 09:34:13 GMT"
Content-Transfer-Encoding: base64

RnJvbSAxOGRmNjY4Mzc5OWUyNTk0NzlkYzUzMjYwZTU5YjVkMWZkYzZhMTQzIE1vbiBTZXAgMTcg
MDA6MDA6MDAgMjAwMQpGcm9tOiBBcnRlbSBCbGFnb2RhcmVua28gPGFydGVtLmJsYWdvZGFyZW5r
b0BnbWFpbC5jb20+CkRhdGU6IFNhdCwgMTggQXByIDIwMjYgMTc6MzM6MjMgLTA0MDAKU3ViamVj
dDogW1BBVENIXSBleHQ0OiBmaXggc3l6Ym90CgpTaWduZWQtb2ZmLWJ5OiBBcnRlbSBCbGFnb2Rh
cmVua28gPGFydGVtLmJsYWdvZGFyZW5rb0BnbWFpbC5jb20+Ci0tLQogZnMvZXh0NC9leHQ0Lmgg
ICB8IDMzICsrKysrKysrKysrKysrKysrKysrKysrKysrKystLS0tLQogZnMvZXh0NC9pbmxpbmUu
YyB8ICA4ICsrKysrKystCiAyIGZpbGVzIGNoYW5nZWQsIDM1IGluc2VydGlvbnMoKyksIDYgZGVs
ZXRpb25zKC0pCgpkaWZmIC0tZ2l0IGEvZnMvZXh0NC9leHQ0LmggYi9mcy9leHQ0L2V4dDQuaApp
bmRleCAyODI3MWQ0MmJmYWYuLmM1ZDRhYWVkOGU2ZSAxMDA2NDQKLS0tIGEvZnMvZXh0NC9leHQ0
LmgKKysrIGIvZnMvZXh0NC9leHQ0LmgKQEAgLTQwMDcsNiArNDAwNyw3IEBAIHN0YXRpYyBpbmxp
bmUgYm9vbCBleHQ0X2Rpcl9lbnRyeV9pc190YWlsKHN0cnVjdCBleHQ0X2Rpcl9lbnRyeV8yICpk
ZSkKIC8qCiAgKiBleHQ0X2RpcmVudF9nZXRfZGF0YV9sZW4oKSAtIENvbXB1dGUgdGhlIHRvdGFs
IGRpcmRhdGEgbGVuZ3RoIGZvciBhbiBlbnRyeS4KICAqIEBkZTogZGlyZWN0b3J5IGVudHJ5Cisg
KiBAcmVjX2xlbjogdGhlIHJlY29yZCBsZW5ndGggb2YgdGhlIGRpcmVjdG9yeSBlbnRyeSAoZGVj
b2RlZCkKICAqCiAgKiBDb21wdXRlcyB0aGUgbGVuZ3RoIG9mIG9wdGlvbmFsIGRhdGEgc3RvcmVk
IGFmdGVyIHRoZSBmaWxlbmFtZSAoYW5kIGl0cwogICogaW1wbGljaXQgTlVMIHRlcm1pbmF0b3Ip
LiAgRWFjaCBleHRlbnNpb24gaXMgaW5kaWNhdGVkIGJ5IGEgYml0IGluIHRoZQpAQCAtNDAxNSwy
MSArNDAxNiwzOSBAQCBzdGF0aWMgaW5saW5lIGJvb2wgZXh0NF9kaXJfZW50cnlfaXNfdGFpbChz
dHJ1Y3QgZXh0NF9kaXJfZW50cnlfMiAqZGUpCiAgKgogICogUmV0dXJucyAwIGZvciB0YWlsIGVu
dHJpZXMgYW5kIGZvciBlbnRyaWVzIHdpdGggbm8gZGlyZGF0YS4KICAqLwotc3RhdGljIGlubGlu
ZSBpbnQgZXh0NF9kaXJlbnRfZ2V0X2RhdGFfbGVuKHN0cnVjdCBleHQ0X2Rpcl9lbnRyeV8yICpk
ZSkKK3N0YXRpYyBpbmxpbmUgaW50IGV4dDRfZGlyZW50X2dldF9kYXRhX2xlbihzdHJ1Y3QgZXh0
NF9kaXJfZW50cnlfMiAqZGUsCisJCQkJCSAgIHVuc2lnbmVkIGludCByZWNfbGVuKQogewogCV9f
dTggZXh0cmFfZGF0YV9mbGFnczsKIAlzdHJ1Y3QgZXh0NF9kaXJlbnRfZGF0YV9oZWFkZXIgKmRk
aDsKIAlpbnQgZGxlbiA9IDA7CisJdW5zaWduZWQgaW50IG9mZnNldDsKIAogCWlmIChleHQ0X2Rp
cl9lbnRyeV9pc190YWlsKGRlKSkKIAkJcmV0dXJuIDA7CiAKIAlleHRyYV9kYXRhX2ZsYWdzID0g
KGRlLT5maWxlX3R5cGUgJiB+RVhUNF9GVF9NQVNLKSA+PiA0OwotCWRkaCA9IChzdHJ1Y3QgZXh0
NF9kaXJlbnRfZGF0YV9oZWFkZXIgKikoZGUtPm5hbWUgKyBkZS0+bmFtZV9sZW4gKwotCQkJCQkJ
IDEgLyogTlVMIHRlcm1pbmF0b3IgKi8pOworCS8qIG9mZnNldCBmcm9tIHN0YXJ0IG9mIGVudHJ5
IHRvIGFmdGVyIGZpbGVuYW1lICsgTlVMICovCisJb2Zmc2V0ID0gRVhUNF9CQVNFX0RJUl9MRU4g
KyBkZS0+bmFtZV9sZW4gKyAxOworCisJLyogYm91bmRzIGNoZWNrOiBlbnN1cmUgd2Ugc3RhcnQg
cmVhZGluZyB3aXRoaW4gdGhlIGVudHJ5ICovCisJaWYgKG9mZnNldCA+PSByZWNfbGVuKQorCQly
ZXR1cm4gMDsKKworCWRkaCA9IChzdHJ1Y3QgZXh0NF9kaXJlbnRfZGF0YV9oZWFkZXIgKikoKGNo
YXIgKilkZSArIG9mZnNldCk7CiAKIAl3aGlsZSAoZXh0cmFfZGF0YV9mbGFncykgewogCQlpZiAo
ZXh0cmFfZGF0YV9mbGFncyAmIDEpIHsKKwkJCS8qIGJvdW5kcyBjaGVjayBiZWZvcmUgcmVhZGlu
ZyBkZGhfbGVuZ3RoICovCisJCQlpZiAob2Zmc2V0ICsgc2l6ZW9mKHN0cnVjdCBleHQ0X2RpcmVu
dF9kYXRhX2hlYWRlcikgPgorCQkJICAgIHJlY19sZW4pCisJCQkJcmV0dXJuIGRsZW47CisKKwkJ
CS8qIHZhbGlkYXRlIGRkaF9sZW5ndGggaXMgcmVhc29uYWJsZSAqLworCQkJaWYgKGRkaC0+ZGRo
X2xlbmd0aCA9PSAwIHx8IGRkaC0+ZGRoX2xlbmd0aCA+CisJCQkgICAgcmVjX2xlbiAtIG9mZnNl
dCkKKwkJCQlyZXR1cm4gZGxlbjsKKwogCQkJLyoKIAkJCSAqIFRoZSBmaXJzdCBkaXJkYXRhIGZp
ZWxkIGlzIHByZWNlZGVkIGJ5IGEgTlVMCiAJCQkgKiB0ZXJtaW5hdG9yIGJ5dGUgdGhhdCBpcyBh
bHJlYWR5IGluY2x1ZGVkIGluIGRkaCdzCkBAIC00MDM4LDcgKzQwNTcsOSBAQCBzdGF0aWMgaW5s
aW5lIGludCBleHQ0X2RpcmVudF9nZXRfZGF0YV9sZW4oc3RydWN0IGV4dDRfZGlyX2VudHJ5XzIg
KmRlKQogCQkJaWYgKGRsZW4gPT0gMCkKIAkJCQlkbGVuID0gMTsgLyogTlVMIHRlcm1pbmF0b3Ig
Ki8KIAkJCWRsZW4gKz0gZGRoLT5kZGhfbGVuZ3RoOwotCQkJZGRoID0gZXh0NF9kaXJkYXRhX25l
eHQoZGRoKTsKKwkJCW9mZnNldCArPSBkZGgtPmRkaF9sZW5ndGg7CisJCQlkZGggPSAoc3RydWN0
IGV4dDRfZGlyZW50X2RhdGFfaGVhZGVyICopCisJCQkJCSgoY2hhciAqKWRkaCArIGRkaC0+ZGRo
X2xlbmd0aCk7CiAJCX0KIAkJZXh0cmFfZGF0YV9mbGFncyA+Pj0gMTsKIAl9CkBAIC00MDU3LDcg
KzQwNzgsOSBAQCBzdGF0aWMgaW5saW5lIGludCBleHQ0X2RpcmVudF9nZXRfZGF0YV9sZW4oc3Ry
dWN0IGV4dDRfZGlyX2VudHJ5XzIgKmRlKQogc3RhdGljIGlubGluZSB1bnNpZ25lZCBpbnQgZXh0
NF9kaXJfZW50cnlfbGVuKHN0cnVjdCBleHQ0X2Rpcl9lbnRyeV8yICpkZSwKIAkJCQkJICAgICAg
Y29uc3Qgc3RydWN0IGlub2RlICpkaXIpCiB7Ci0JdW5zaWduZWQgaW50IGRpcmRhdGEgPSBleHQ0
X2RpcmVudF9nZXRfZGF0YV9sZW4oZGUpOworCXVuc2lnbmVkIGludCBibG9ja3NpemUgPSAoZGly
ICYmIGRpci0+aV9zYikgPyBkaXItPmlfc2ItPnNfYmxvY2tzaXplIDogNDA5NjsKKwl1bnNpZ25l
ZCBpbnQgcmVjX2xlbiA9IGV4dDRfcmVjX2xlbl9mcm9tX2Rpc2soZGUtPnJlY19sZW4sIGJsb2Nr
c2l6ZSk7CisJdW5zaWduZWQgaW50IGRpcmRhdGEgPSBleHQ0X2RpcmVudF9nZXRfZGF0YV9sZW4o
ZGUsIHJlY19sZW4pOwogCiAJcmV0dXJuIGV4dDRfZGlyZW50X3JlY19sZW4oZGUtPm5hbWVfbGVu
ICsgZGlyZGF0YSwgZGlyKTsKIH0KZGlmZiAtLWdpdCBhL2ZzL2V4dDQvaW5saW5lLmMgYi9mcy9l
eHQ0L2lubGluZS5jCmluZGV4IDA3MWE2MzdjODg2OS4uNzA5YWNiZjVlMTk4IDEwMDY0NAotLS0g
YS9mcy9leHQ0L2lubGluZS5jCisrKyBiL2ZzL2V4dDQvaW5saW5lLmMKQEAgLTEzMTgsNyArMTMx
OCwxMyBAQCBpbnQgZXh0NF9pbmxpbmVkaXJfdG9fdHJlZShzdHJ1Y3QgZmlsZSAqZGlyX2ZpbGUs
CiAJCQlwb3MgPSBFWFQ0X0lOTElORV9ET1RET1RfU0laRTsKIAkJfSBlbHNlIHsKIAkJCWRlID0g
KHN0cnVjdCBleHQ0X2Rpcl9lbnRyeV8yICopKGRpcl9idWYgKyBwb3MpOwotCQkJcG9zICs9IGV4
dDRfcmVjX2xlbl9mcm9tX2Rpc2soZGUtPnJlY19sZW4sIGlubGluZV9zaXplKTsKKwkJCS8qIFVz
ZSBleHQ0X2Rpcl9lbnRyeV9sZW4gdG8gYWNjb3VudCBmb3IgZGlyZGF0YSBleHRlbnNpb25zICov
CisJCQlwb3MgKz0gZXh0NF9kaXJfZW50cnlfbGVuKGRlLCBkaXIpOworCQkJLyogVmFsaWRhdGUg
cG9zIGRvZXNuJ3QgZXhjZWVkIGJ1ZmZlciB0byBwcmV2ZW50IHVzZS1hZnRlci1mcmVlICovCisJ
CQlpZiAocG9zID4gaW5saW5lX3NpemUpIHsKKwkJCQlyZXQgPSBjb3VudDsKKwkJCQlnb3RvIG91
dDsKKwkJCX0KIAkJCWlmIChleHQ0X2NoZWNrX2Rpcl9lbnRyeShpbm9kZSwgZGlyX2ZpbGUsIGRl
LAogCQkJCQkgaWxvYy5iaCwgZGlyX2J1ZiwKIAkJCQkJIGlubGluZV9zaXplLCBwb3MpKSB7Ci0t
IAoyLjQzLjcKCg==

--_004_GV2P190MB275499A44FE1E8F8C1AF3A8FAB2D2GV2P190MB2754EURP_--
