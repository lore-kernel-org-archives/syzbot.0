Received: from mail-oi1-f200.google.com (mail-oi1-f200.google.com [209.85.167.200])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3689241A565
	for <syzbot@lists.linux.dev>; Wed, 29 Jul 2026 10:58:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.167.200
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785322718; cv=none; b=nfbQmLRCCj4QNV9FrgCGMl0i0U2VUcV0j8RLQXLWM4dtVpJ5o6S0HsfL78TNlE28dlYziz7ZHUbnWAfoc/AAATL+JmHf3VmAhIS+rwQdWFobGZjZ2ldgTWnDDKaJRxb5qH/4kSJvJRMzUzd0XsxcPN8qNfOcWsvR9JCv/9J31bk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785322718; c=relaxed/simple;
	bh=X6JymM8vk9K8Q0t8KpD0VDN/aJxleXdZSHwTQiPkNXM=;
	h=MIME-Version:Date:Message-ID:Subject:From:To:Cc:Content-Type; b=mCWvy5ncUJzPG7ISOSdK2ppSn/vYfgYeFpeMP36J1tMe7daz6TBUfpgveDbyDU0VeaT/Umv8YDmrC+Sec9PZnMObBxfgUUSZbDbxKjm/P4n25yUoMolWcTe/FVKxzVemB8ZCS+Tn9KMd71q5p1lddkEVnvbJN+rKZiZQnhGa21o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com; arc=none smtp.client-ip=209.85.167.200
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com
Received: by mail-oi1-f200.google.com with SMTP id 5614622812f47-4a43d32fa9fso1009457b6e.2
        for <syzbot@lists.linux.dev>; Wed, 29 Jul 2026 03:58:35 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1785322715; x=1785927515;
        h=content-type:cc:to:from:subject:message-id:date:mime-version
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=u8wk7U8ag1Sl0GVyM+iDM1qmqUpvPesKi3qQEAq63K4=;
        b=qNmn3j9wWisdPtwP2stnbeF34a2pYLieIowJNhVEyLatN6kFXvylBn5VKY/u3nNL8M
         HcnDkxiQiBd55KjkDxCNVdzc8h63fsgZE9hwUZYPqhw1Zs7JI011wrKP4nR+8GUmvGHZ
         y+HhCousfoBNHoE7Kq4d6BfDqHuUl/3dH4bX36Aq+IHW79ZKtLuR0buVwqOVSLH2gaPI
         KQSjTY9z55JEanMRu6tbx6ppZFA/eaoPQ+UVrtQKsmr7Vfs4P8/VP+7aXSgtCPlW8L+H
         W6CdjdNLwT97cGKxYruHd4sGIerDOEt9GWzvHrkSU7Ylehu4/xhERLsA0+O/8uc+DQkH
         SYAg==
X-Gm-Message-State: AOJu0YxV1XeXlvcCcfzReokQdj5VViFgcHQF1d/H9qmOa/Ba++/x3omo
	lGTnCjXBIG5PMqyJhpbZtCgcl4i7EMgNzPLf1qKPobOou0uSXnaZD6lqiFjzMbMpfQZT4Hbr9OW
	zJkTFy0lfjzZ/AoP9NXxEDtAG6pOD9daCiGQQf3s3dnqSCkM371NZnXDOSeg=
Precedence: bulk
X-Mailing-List: syzbot@lists.linux.dev
List-Id: <syzbot.lists.linux.dev>
List-Subscribe: <mailto:syzbot+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:syzbot+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Received: by 2002:a05:6808:2226:b0:4a4:80be:3ae9 with SMTP id
 5614622812f47-4ad5b9b7a52mr4323800b6e.28.1785322714946; Wed, 29 Jul 2026
 03:58:34 -0700 (PDT)
Date: Wed, 29 Jul 2026 03:58:34 -0700
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <6a69dcda.d9e86bb5.297b12.0063.GAE@google.com>
Subject: [moderation/CI] Re: zram: fix early release of global cdict/ddict in
 per-CPU error path
From: syzbot ci <syzbot+ci163dda578633ce51@syzkaller.appspotmail.com>
To: syzkaller-upstream-moderation@googlegroups.com
Cc: syzbot@lists.linux.dev
Content-Type: text/plain; charset="UTF-8"

syzbot ci has tested the following series

[v2] zram: fix early release of global cdict/ddict in per-CPU error path
https://lore.kernel.org/all/20260728092935.31139-1-haoqinhuang7@gmail.com
* [PATCH v2 1/5] zram: fix early release of global cdict/ddict in per-CPU error path
* [PATCH v2 2/5] zram: make dict update in comp_params_store() atomic
* [PATCH v2 3/5] zstd: move ZSTD_MAX_CLEVEL to zstd_lib.h
* [PATCH v2 4/5] zram: add per-backend caps and validate parameters early
* [PATCH v2 5/5] zram: reset per-priority params when changing algorithm before init

and found the following issue:
KASAN: slab-use-after-free Read in event_handler

Full report is available here:
https://ci.syzbot.org/series/e2672818-2e9a-4685-8cee-6e5202cb0372

***

KASAN: slab-use-after-free Read in event_handler

tree:      axboe
URL:       https://kernel.googlesource.com/pub/scm/linux/kernel/git/axboe/linux.git
base:      923b1b5a3a5cc642172d8cf8c6097ad1169b6217
arch:      amd64
compiler:  Debian clang version 22.1.8 (++20260613092233+e80beda6e255-1~exp1~20260613092250.77), Debian LLD 22.1.8
config:    https://ci.syzbot.org/builds/444dc77b-c272-46a7-ac65-9b594a954b56/config
syz repro: https://ci.syzbot.org/findings/6c520622-cfcc-490d-88c4-b7f28288e76c/syz_repro

vhci_hcd vhci_hcd.0: release socket
vhci_hcd vhci_hcd.0: disconnect device
==================================================================
BUG: KASAN: slab-use-after-free in __raw_spin_lock_irqsave include/linux/spinlock_api_smp.h:132 [inline]
BUG: KASAN: slab-use-after-free in _raw_spin_lock_irqsave+0x40/0x60 kernel/locking/spinlock.c:166
Read of size 1 at addr ffff88816d3a8478 by task kworker/u8:5/5796

CPU: 1 UID: 0 PID: 5796 Comm: kworker/u8:5 Not tainted syzkaller #0 PREEMPT(full) 
Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS 1.16.2-debian-1.16.2-1 04/01/2014
Workqueue: usbip_event event_handler
Call Trace:
 <TASK>
 dump_stack_lvl+0xe8/0x150 lib/dump_stack.c:120
 print_address_description+0x55/0x1e0 mm/kasan/report.c:378
 print_report+0x58/0x70 mm/kasan/report.c:482
 kasan_report+0x117/0x150 mm/kasan/report.c:595
 __kasan_check_byte+0x2a/0x40 mm/kasan/common.c:574
 kasan_check_byte include/linux/kasan.h:402 [inline]
 lock_acquire+0x84/0x350 kernel/locking/lockdep.c:5842
 __raw_spin_lock_irqsave include/linux/spinlock_api_smp.h:132 [inline]
 _raw_spin_lock_irqsave+0x40/0x60 kernel/locking/spinlock.c:166
 unset_event drivers/usb/usbip/usbip_event.c:35 [inline]
 event_handler+0x2b0/0x4b0 drivers/usb/usbip/usbip_event.c:80
 process_one_work kernel/workqueue.c:3322 [inline]
 process_scheduled_works+0xa8e/0x14e0 kernel/workqueue.c:3405
 worker_thread+0xa47/0xfb0 kernel/workqueue.c:3486
 kthread+0x388/0x470 kernel/kthread.c:436
 ret_from_fork+0x514/0xb70 arch/x86/kernel/process.c:158
 ret_from_fork_asm+0x1a/0x30 arch/x86/entry/entry_64.S:245
 </TASK>

Allocated by task 1:
 kasan_save_stack mm/kasan/common.c:57 [inline]
 kasan_save_track+0x3e/0x80 mm/kasan/common.c:78
 poison_kmalloc_redzone mm/kasan/common.c:398 [inline]
 __kasan_kmalloc+0x93/0xb0 mm/kasan/common.c:415
 kasan_kmalloc include/linux/kasan.h:263 [inline]
 __do_kmalloc_node mm/slub.c:5362 [inline]
 __kmalloc_noprof+0x375/0x720 mm/slub.c:5387
 _kmalloc_noprof include/linux/slab.h:973 [inline]
 _kzalloc_noprof include/linux/slab.h:1290 [inline]
 __usb_create_hcd+0x67/0x900 drivers/usb/core/hcd.c:2566
 vhci_hcd_probe+0x104/0x3e0 drivers/usb/usbip/vhci_hcd.c:1378
 platform_probe+0xf9/0x190 drivers/base/platform.c:1439
 call_driver_probe drivers/base/dd.c:-1 [inline]
 really_probe+0x254/0xae0 drivers/base/dd.c:706
 __driver_probe_device+0x1e8/0x360 drivers/base/dd.c:868
 driver_probe_device+0x4f/0x240 drivers/base/dd.c:898
 __device_attach_driver+0x270/0x410 drivers/base/dd.c:1026
 bus_for_each_drv+0x258/0x2f0 drivers/base/bus.c:500
 __device_attach+0x2c4/0x450 drivers/base/dd.c:1098
 device_initial_probe+0xa1/0xd0 drivers/base/dd.c:1153
 bus_probe_device+0x12a/0x220 drivers/base/bus.c:620
 device_add+0x7d7/0xb80 drivers/base/core.c:3772
 platform_device_add+0x4bd/0x860 drivers/base/platform.c:762
 platform_device_register_full+0x62d/0x710 drivers/base/platform.c:902
 vhci_hcd_init+0x227/0x360 drivers/usb/usbip/vhci_hcd.c:1557
 do_one_initcall+0x250/0x870 init/main.c:1347
 do_initcall_level+0x10a/0x1a0 init/main.c:1409
 do_initcalls+0x59/0xa0 init/main.c:1425
 kernel_init_freeable+0x29d/0x3e0 init/main.c:1658
 kernel_init+0x1d/0x1d0 init/main.c:1548
 ret_from_fork+0x514/0xb70 arch/x86/kernel/process.c:158
 ret_from_fork_asm+0x1a/0x30 arch/x86/entry/entry_64.S:245

Freed by task 5870:
 kasan_save_stack mm/kasan/common.c:57 [inline]
 kasan_save_track+0x3e/0x80 mm/kasan/common.c:78
 kasan_save_free_info+0x40/0x50 mm/kasan/generic.c:584
 poison_slab_object mm/kasan/common.c:253 [inline]
 __kasan_slab_free+0x5c/0x80 mm/kasan/common.c:285
 kasan_slab_free include/linux/kasan.h:235 [inline]
 slab_free_hook mm/slub.c:2705 [inline]
 slab_free mm/slub.c:6405 [inline]
 kfree+0x1c5/0x640 mm/slub.c:6720
 vhci_hcd_remove+0xe4/0x110 drivers/usb/usbip/vhci_hcd.c:1434
 device_remove drivers/base/dd.c:616 [inline]
 __device_release_driver drivers/base/dd.c:1349 [inline]
 device_release_driver_internal+0x48b/0x880 drivers/base/dd.c:1372
 unbind_store+0x1a1/0x1d0 drivers/base/bus.c:244
 kernfs_fop_write_iter+0x3a4/0x540 fs/kernfs/file.c:345
 new_sync_write fs/read_write.c:595 [inline]
 vfs_write+0x612/0xba0 fs/read_write.c:687
 ksys_write+0x150/0x270 fs/read_write.c:739
 do_syscall_x64 arch/x86/entry/syscall_64.c:63 [inline]
 do_syscall_64+0x174/0x580 arch/x86/entry/syscall_64.c:94
 entry_SYSCALL_64_after_hwframe+0x77/0x7f

Last potentially related work creation:
 kasan_save_stack+0x3e/0x60 mm/kasan/common.c:57
 kasan_record_aux_stack+0xbd/0xd0 mm/kasan/generic.c:556
 insert_work+0x3d/0x330 kernel/workqueue.c:2226
 __queue_work+0xcd8/0x10a0 kernel/workqueue.c:2401
 queue_work_on+0x106/0x1d0 kernel/workqueue.c:2452
 usb_rh_urb_dequeue drivers/usb/core/hcd.c:845 [inline]
 unlink1+0x344/0x3e0 drivers/usb/core/hcd.c:1580
 usb_hcd_unlink_urb+0xe6/0x1e0 drivers/usb/core/hcd.c:1617
 usb_kill_urb+0x10b/0x2f0 drivers/usb/core/urb.c:716
 hub_quiesce+0x211/0x330 drivers/usb/core/hub.c:1412
 hub_suspend+0x904/0xad0 drivers/usb/core/hub.c:4008
 usb_suspend_interface drivers/usb/core/driver.c:1323 [inline]
 usb_suspend_both+0x285/0x1040 drivers/usb/core/driver.c:1446
 usb_runtime_suspend+0x58/0x110 drivers/usb/core/driver.c:2000
 __rpm_callback+0x2c7/0x950 drivers/base/power/runtime.c:406
 rpm_callback drivers/base/power/runtime.c:460 [inline]
 rpm_suspend+0x8a0/0x17b0 drivers/base/power/runtime.c:698
 __pm_runtime_suspend+0x12f/0x1a0 drivers/base/power/runtime.c:1167
 pm_runtime_put_sync_autosuspend include/linux/pm_runtime.h:740 [inline]
 usb_new_device+0xadf/0x1620 drivers/usb/core/hub.c:2727
 register_root_hub+0x250/0x5c0 drivers/usb/core/hcd.c:990
 usb_add_hcd+0xac7/0xf80 drivers/usb/core/hcd.c:2987
 vhci_hcd_probe+0x141/0x3e0 drivers/usb/usbip/vhci_hcd.c:1388
 platform_probe+0xf9/0x190 drivers/base/platform.c:1439
 call_driver_probe drivers/base/dd.c:-1 [inline]
 really_probe+0x254/0xae0 drivers/base/dd.c:706
 __driver_probe_device+0x1e8/0x360 drivers/base/dd.c:868
 driver_probe_device+0x4f/0x240 drivers/base/dd.c:898
 __device_attach_driver+0x270/0x410 drivers/base/dd.c:1026
 bus_for_each_drv+0x258/0x2f0 drivers/base/bus.c:500
 __device_attach+0x2c4/0x450 drivers/base/dd.c:1098
 device_initial_probe+0xa1/0xd0 drivers/base/dd.c:1153
 bus_probe_device+0x12a/0x220 drivers/base/bus.c:620
 device_add+0x7d7/0xb80 drivers/base/core.c:3772
 platform_device_add+0x4bd/0x860 drivers/base/platform.c:762
 platform_device_register_full+0x62d/0x710 drivers/base/platform.c:902
 vhci_hcd_init+0x227/0x360 drivers/usb/usbip/vhci_hcd.c:1557
 do_one_initcall+0x250/0x870 init/main.c:1347
 do_initcall_level+0x10a/0x1a0 init/main.c:1409
 do_initcalls+0x59/0xa0 init/main.c:1425
 kernel_init_freeable+0x29d/0x3e0 init/main.c:1658
 kernel_init+0x1d/0x1d0 init/main.c:1548
 ret_from_fork+0x514/0xb70 arch/x86/kernel/process.c:158
 ret_from_fork_asm+0x1a/0x30 arch/x86/entry/entry_64.S:245

Second to last potentially related work creation:
 kasan_save_stack+0x3e/0x60 mm/kasan/common.c:57
 kasan_record_aux_stack+0xbd/0xd0 mm/kasan/generic.c:556
 insert_work+0x3d/0x330 kernel/workqueue.c:2226
 __queue_work+0xcd8/0x10a0 kernel/workqueue.c:2401
 queue_work_on+0x106/0x1d0 kernel/workqueue.c:2452
 rh_call_control drivers/usb/core/hcd.c:706 [inline]
 rh_urb_enqueue drivers/usb/core/hcd.c:817 [inline]
 usb_hcd_submit_urb+0xa3b/0x1b60 drivers/usb/core/hcd.c:1538
 usb_start_wait_urb+0x13f/0x5b0 drivers/usb/core/message.c:62
 usb_internal_control_msg drivers/usb/core/message.c:117 [inline]
 usb_control_msg+0x234/0x3e0 drivers/usb/core/message.c:167
 get_port_status drivers/usb/core/hub.c:607 [inline]
 hub_ext_port_status+0x114/0x810 drivers/usb/core/hub.c:624
 usb_hub_port_status drivers/usb/core/hub.c:674 [inline]
 hub_activate+0x740/0x1b20 drivers/usb/core/hub.c:1185
 process_one_work kernel/workqueue.c:3322 [inline]
 process_scheduled_works+0xa8e/0x14e0 kernel/workqueue.c:3405
 worker_thread+0xa47/0xfb0 kernel/workqueue.c:3486
 kthread+0x388/0x470 kernel/kthread.c:436
 ret_from_fork+0x514/0xb70 arch/x86/kernel/process.c:158
 ret_from_fork_asm+0x1a/0x30 arch/x86/entry/entry_64.S:245

The buggy address belongs to the object at ffff88816d3a8000
 which belongs to the cache kmalloc-8k of size 8192
The buggy address is located 1144 bytes inside of
 freed 8192-byte region [ffff88816d3a8000, ffff88816d3aa000)

The buggy address belongs to the physical page:
page: refcount:0 mapcount:0 mapping:0000000000000000 index:0x0 pfn:0x16d3a8
head: order:3 mapcount:0 entire_mapcount:0 nr_pages_mapped:0 pincount:0
flags: 0x57ff00000000040(head|node=1|zone=2|lastcpupid=0x7ff)
page_type: f5(slab)
raw: 057ff00000000040 ffff888100042280 dead000000000122 0000000000000000
raw: 0000000000000000 0000000800020002 00000000f5000000 0000000000000000
head: 057ff00000000040 ffff888100042280 dead000000000122 0000000000000000
head: 0000000000000000 0000000800020002 00000000f5000000 0000000000000000
head: 057ff00000000003 fffffffffffffe01 00000000ffffffff 00000000ffffffff
head: ffffffffffffffff 0000000000000000 00000000ffffffff 0000000000000008
page dumped because: kasan: bad access detected
page_owner tracks the page as allocated
page last allocated via order 3, migratetype Unmovable, gfp_mask 0xd20c0(__GFP_IO|__GFP_FS|__GFP_NOWARN|__GFP_NORETRY|__GFP_COMP|__GFP_NOMEMALLOC), pid 1, tgid 1 (swapper/0), ts 15263763575, free_ts 0
 set_page_owner include/linux/page_owner.h:32 [inline]
 post_alloc_hook+0x1f9/0x250 mm/page_alloc.c:1859
 prep_new_page mm/page_alloc.c:1867 [inline]
 get_page_from_freelist+0x21fa/0x2270 mm/page_alloc.c:3946
 __alloc_frozen_pages_noprof+0x18d/0x380 mm/page_alloc.c:5304
 alloc_slab_page mm/slub.c:3294 [inline]
 allocate_slab+0x79/0x5e0 mm/slub.c:3408
 new_slab mm/slub.c:3454 [inline]
 refill_objects+0x2d5/0x350 mm/slub.c:7338
 refill_sheaf mm/slub.c:2832 [inline]
 __pcs_replace_empty_main+0x2bf/0x6b0 mm/slub.c:4703
 alloc_from_pcs mm/slub.c:4801 [inline]
 slab_alloc_node mm/slub.c:4933 [inline]
 __kmalloc_cache_noprof+0x3a7/0x660 mm/slub.c:5511
 _kmalloc_noprof include/linux/slab.h:969 [inline]
 _kzalloc_noprof include/linux/slab.h:1290 [inline]
 dummy_hcd_init+0x3e2/0xd00 drivers/usb/gadget/udc/dummy_hcd.c:2836
 do_one_initcall+0x250/0x870 init/main.c:1347
 do_initcall_level+0x10a/0x1a0 init/main.c:1409
 do_initcalls+0x59/0xa0 init/main.c:1425
 kernel_init_freeable+0x29d/0x3e0 init/main.c:1658
 kernel_init+0x1d/0x1d0 init/main.c:1548
 ret_from_fork+0x514/0xb70 arch/x86/kernel/process.c:158
 ret_from_fork_asm+0x1a/0x30 arch/x86/entry/entry_64.S:245
page_owner free stack trace missing

Memory state around the buggy address:
 ffff88816d3a8300: fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb
 ffff88816d3a8380: fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb
>ffff88816d3a8400: fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb
                                                                ^
 ffff88816d3a8480: fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb
 ffff88816d3a8500: fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb
==================================================================


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

The email will later be sent to:
[akpm@linux-foundation.org axboe@kernel.dk dsterba@suse.com haoqinhuang7@gmail.com haoqinhuang@tencent.com linux-block@vger.kernel.org linux-kernel@vger.kernel.org minchan@kernel.org senozhatsky@chromium.org terrelln@fb.com zigiwang@tencent.com]

If the report looks fine to you, reply with:
#syz upstream

If the report is a false positive, reply with
#syz invalid

