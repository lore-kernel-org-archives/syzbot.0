Received: from mail-oi1-f205.google.com (mail-oi1-f205.google.com [209.85.167.205])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B2B6F387363
	for <syzbot@lists.linux.dev>; Thu,  6 Aug 2026 06:07:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.167.205
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785996451; cv=none; b=fG+8xl7tLpulAwZsS1RbygxxighteAUF3p/pFhmx4wKyAmd5nJZkEVTBycwxbCx88scm4IzqwJr4HmDTwT0qnSxcZbRoBp4KvG7HLSHC4gpWCtP7eAD33Ky35OURy8E8Q3VXL/5D2Ut+Lri3yCQgcSHeuCm+pYGAzfrwSjwlFTI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785996451; c=relaxed/simple;
	bh=XD/oeNRa6fsIwzvAt+3bL4ySNXnxdRqFTy2cMiuLm38=;
	h=MIME-Version:Date:In-Reply-To:Message-ID:Subject:From:To:
	 Content-Type; b=jIWvo1sG+KShNLcjOkG95SRc/jhvnDu0nODmCjpRW1TqPlaWAcgSyTUZh4510dw1Bw7Jj3HrhBoQmh7xv8Btr26jk6KVd2hHWbkeI2oZIO5yZX49i5s6rmYEa2ocPKs5u+BhjT7oybwMAEwAJS4RMCKJTQZFoVuIIiuARW59b08=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com; arc=none smtp.client-ip=209.85.167.205
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com
Received: by mail-oi1-f205.google.com with SMTP id 5614622812f47-485ebc5706cso777554b6e.0
        for <syzbot@lists.linux.dev>; Wed, 05 Aug 2026 23:07:29 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1785996448; x=1786601248;
        h=content-type:to:from:subject:message-id:in-reply-to:date
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to:content-type;
        bh=T0tiywi8bazZl1tfStG5d9FtNgo6jpQ5XQA29Y/WOs0=;
        b=oPX0r71oJlG0wIugxgVqlFwIFQ4Mg77XZJvLCqUTZ8ATjIZg1miFUwld0BC/fXBNog
         tpRWKNlg8DQOXktjl51WxZFySwGZ3VQX/1MBm8mdXp8oB71YAbJLENsusnHijqz+QcmD
         7+MdWMUE3erSRNIYo9iCOIDVYlrLUZl9d5l+WB+e2F+xX2SigO4pvjETNv8cP86pW8ki
         LaDdRbPAzQy/7qe5sQGaTkkyji4lmwJ8dJ7qfA3fGkoKrYqq+naIBSEySjrqihPBLj9m
         ELiQzW9+q0Pqi6ZVR5cWtjQtmUx0Vllqsm3bJN1nUpb4oqhJ7BNH/K945EZ8MSofZSy7
         t8lw==
X-Forwarded-Encrypted: i=1; AHgh+Rq7faNB7OsK4X1Nd+nzTdLUKrhsVW6MpDg060XU29r9RxbG3I1Wre3UYfetE5YmS7B/HFyrtbs=@lists.linux.dev
X-Gm-Message-State: AOJu0Ywwp/3dJeX0ct67Q0+lVx8I4oQXLQ7JCru8yyHBAVy+0cLh8H8Q
	fA2AKYK426AwE6zozXUZsnlefbUNoG+3G4BnenIcQt2OogfY6LTAWIs8GDh5llEWfEG3ADwUIvD
	Su2gkhnOQltPizjShC6XCvnsi2/z0XmOwQJeY8fMorfZ2+Ht+h6UFO9AnUWI=
Precedence: bulk
X-Mailing-List: syzbot@lists.linux.dev
List-Id: <syzbot.lists.linux.dev>
List-Subscribe: <mailto:syzbot+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:syzbot+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Received: by 2002:a05:6820:4c11:b0:6ac:c13b:933 with SMTP id
 006d021491bc7-6aeb2424d4amr2368462eaf.13.1785996448629; Wed, 05 Aug 2026
 23:07:28 -0700 (PDT)
Date: Wed, 05 Aug 2026 23:07:28 -0700
In-Reply-To: <6a6d3cbd.6ce73036.24301b.000c.GAE@google.com>
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <6a7424a0.01d0871a.3a0d52.0012.GAE@google.com>
Subject: Re: [syzbot] [usb?] KASAN: slab-use-after-free Read in vhci_cleanup_unlink_list
From: syzbot <syzbot+f4518ac0a3dd3aafde38@syzkaller.appspotmail.com>
To: gregkh@linuxfoundation.org, i@zenithal.me, linux-kernel@vger.kernel.org, 
	linux-usb@vger.kernel.org, nobuo.iwata@fujixerox.co.jp, nogikh@google.com, 
	shuah@kernel.org, syzbot@kernel.org, syzbot@lists.linux.dev, 
	syzkaller-bugs@googlegroups.com, 
	syzkaller-upstream-moderation@googlegroups.com, valentina.manea.m@gmail.com
Content-Type: text/plain; charset="UTF-8"

syzbot has found a reproducer for the following issue on:

HEAD commit:    0d8395707651 Merge tag 'soc-fixes-7.2-2' of git://git.kern..
git tree:       upstream
console output: https://syzkaller.appspot.com/x/log.txt?x=1455929e580000
kernel config:  https://syzkaller.appspot.com/x/.config?x=145fa60d73086782
dashboard link: https://syzkaller.appspot.com/bug?extid=f4518ac0a3dd3aafde38
compiler:       gcc (Debian 14.2.0-19) 14.2.0, GNU ld (GNU Binutils for Debian) 2.44
syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=12e5bbb9580000
C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=16ffb7b9580000

Downloadable assets:
disk image (non-bootable): https://storage.googleapis.com/syzbot-assets/d900f083ada3/non_bootable_disk-0d839570.raw.xz
vmlinux: https://storage.googleapis.com/syzbot-assets/0b7275b6c889/vmlinux-0d839570.xz
kernel image: https://storage.googleapis.com/syzbot-assets/b752a676c1dd/bzImage-0d839570.xz

IMPORTANT: if you fix the issue, please add the following tag to the commit:
Reported-by: syzbot+f4518ac0a3dd3aafde38@syzkaller.appspotmail.com

vhci_hcd vhci_hcd.0: release socket
==================================================================
BUG: KASAN: slab-use-after-free in vdev_to_vhci_hcd drivers/usb/usbip/vhci.h:171 [inline]
BUG: KASAN: slab-use-after-free in vhci_cleanup_unlink_list+0x44/0x456 drivers/usb/usbip/vhci_hcd.c:985
Read of size 4 at addr ffff88802bf5d230 by task kworker/u32:3/5807

CPU: 1 UID: 0 PID: 5807 Comm: kworker/u32:3 Not tainted syzkaller #0 PREEMPT(full) 
Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS 1.16.3-debian-1.16.3-2 04/01/2014
Workqueue: usbip_event event_handler
Call Trace:
 <TASK>
 __dump_stack lib/dump_stack.c:94 [inline]
 dump_stack_lvl+0x100/0x190 lib/dump_stack.c:120
 print_address_description mm/kasan/report.c:378 [inline]
 print_report+0x13d/0x4b0 mm/kasan/report.c:482
 kasan_report+0xdf/0x1c0 mm/kasan/report.c:595
 vdev_to_vhci_hcd drivers/usb/usbip/vhci.h:171 [inline]
 vhci_cleanup_unlink_list+0x44/0x456 drivers/usb/usbip/vhci_hcd.c:985
 vhci_device_unlink_cleanup drivers/usb/usbip/vhci_hcd.c:1028 [inline]
 vhci_shutdown_connection.cold+0x165/0x37c drivers/usb/usbip/vhci_hcd.c:1069
 event_handler+0x216/0x570 drivers/usb/usbip/usbip_event.c:79
 process_one_work+0xa23/0x1940 kernel/workqueue.c:3322
 process_scheduled_works kernel/workqueue.c:3405 [inline]
 worker_thread+0x5ef/0xe50 kernel/workqueue.c:3486
 kthread+0x370/0x450 kernel/kthread.c:436
 ret_from_fork+0x72b/0xd50 arch/x86/kernel/process.c:158
 ret_from_fork_asm+0x1a/0x30 arch/x86/entry/entry_64.S:245
 </TASK>

Allocated by task 1:
 kasan_save_stack+0x30/0x50 mm/kasan/common.c:57
 kasan_save_track+0x14/0x30 mm/kasan/common.c:78
 poison_kmalloc_redzone mm/kasan/common.c:398 [inline]
 __kasan_kmalloc+0xaa/0xb0 mm/kasan/common.c:415
 kasan_kmalloc include/linux/kasan.h:263 [inline]
 __do_kmalloc_node mm/slub.c:5334 [inline]
 __kmalloc_noprof+0x322/0x820 mm/slub.c:5359
 _kmalloc_noprof include/linux/slab.h:992 [inline]
 _kzalloc_noprof include/linux/slab.h:1309 [inline]
 __usb_create_hcd+0x5e/0xac0 drivers/usb/core/hcd.c:2566
 vhci_hcd_probe+0x1a5/0x4e0 drivers/usb/usbip/vhci_hcd.c:1394
 platform_probe+0x106/0x1d0 drivers/base/platform.c:1439
 call_driver_probe drivers/base/dd.c:628 [inline]
 really_probe+0x241/0xa60 drivers/base/dd.c:706
 __driver_probe_device+0x20e/0x450 drivers/base/dd.c:868
 driver_probe_device+0x4a/0x140 drivers/base/dd.c:898
 __device_attach_driver+0x1df/0x320 drivers/base/dd.c:1026
 bus_for_each_drv+0x159/0x1e0 drivers/base/bus.c:500
 __device_attach+0x1e4/0x4d0 drivers/base/dd.c:1098
 device_initial_probe+0xaf/0xd0 drivers/base/dd.c:1153
 bus_probe_device+0x64/0x160 drivers/base/bus.c:620
 device_add+0x121d/0x1970 drivers/base/core.c:3772
 platform_device_add+0x35a/0x800 drivers/base/platform.c:762
 platform_device_register_full+0x5cf/0x830 drivers/base/platform.c:902
 vhci_hcd_init+0x1a1/0x2f0 drivers/usb/usbip/vhci_hcd.c:1557
 do_one_initcall+0x11d/0x700 init/main.c:1347
 do_initcall_level init/main.c:1409 [inline]
 do_initcalls init/main.c:1425 [inline]
 do_basic_setup init/main.c:1445 [inline]
 kernel_init_freeable+0x6ea/0x7b0 init/main.c:1658
 kernel_init+0x1f/0x1e0 init/main.c:1548
 ret_from_fork+0x72b/0xd50 arch/x86/kernel/process.c:158
 ret_from_fork_asm+0x1a/0x30 arch/x86/entry/entry_64.S:245

Freed by task 5926:
 kasan_save_stack+0x30/0x50 mm/kasan/common.c:57
 kasan_save_track+0x14/0x30 mm/kasan/common.c:78
 kasan_save_free_info+0x3b/0x70 mm/kasan/generic.c:584
 poison_slab_object mm/kasan/common.c:253 [inline]
 __kasan_slab_free+0x5f/0x80 mm/kasan/common.c:285
 kasan_slab_free include/linux/kasan.h:235 [inline]
 slab_free_hook mm/slub.c:2677 [inline]
 slab_free mm/slub.c:6377 [inline]
 kfree+0x22b/0x6c0 mm/slub.c:6692
 hcd_release drivers/usb/core/hcd.c:2690 [inline]
 kref_put include/linux/kref.h:65 [inline]
 usb_put_hcd drivers/usb/core/hcd.c:2704 [inline]
 usb_put_hcd+0x149/0x1f0 drivers/usb/core/hcd.c:2701
 vhci_hcd_remove+0xb5/0x1b0 drivers/usb/usbip/vhci_hcd.c:1431
 platform_remove+0x5f/0x80 drivers/base/platform.c:1456
 device_remove+0xcb/0x180 drivers/base/dd.c:616
 __device_release_driver drivers/base/dd.c:1349 [inline]
 device_release_driver_internal+0x44e/0x620 drivers/base/dd.c:1372
 unbind_store+0xf8/0x110 drivers/base/bus.c:244
 drv_attr_store+0x74/0xb0 drivers/base/bus.c:125
 sysfs_kf_write+0xf2/0x150 fs/sysfs/file.c:145
 kernfs_fop_write_iter+0x3e0/0x5f0 fs/kernfs/file.c:345
 new_sync_write fs/read_write.c:595 [inline]
 vfs_write+0x6ac/0x1050 fs/read_write.c:687
 ksys_write+0x12a/0x250 fs/read_write.c:739
 do_syscall_x64 arch/x86/entry/syscall_64.c:63 [inline]
 do_syscall_64+0x115/0x870 arch/x86/entry/syscall_64.c:94
 entry_SYSCALL_64_after_hwframe+0x77/0x7f

Last potentially related work creation:
 kasan_save_stack+0x30/0x50 mm/kasan/common.c:57
 kasan_record_aux_stack+0xa7/0xc0 mm/kasan/generic.c:556
 insert_work+0x36/0x230 kernel/workqueue.c:2226
 __queue_work+0x9bc/0x12b0 kernel/workqueue.c:2401
 queue_work_on+0x1a9/0x1e0 kernel/workqueue.c:2452
 queue_work include/linux/workqueue.h:699 [inline]
 usb_hcd_giveback_urb+0x330/0x4a0 drivers/usb/core/hcd.c:1758
 usb_rh_urb_dequeue drivers/usb/core/hcd.c:845 [inline]
 unlink1+0x418/0x510 drivers/usb/core/hcd.c:1580
 usb_hcd_unlink_urb+0x131/0x210 drivers/usb/core/hcd.c:1617
 usb_kill_urb drivers/usb/core/urb.c:716 [inline]
 usb_kill_urb+0x121/0x320 drivers/usb/core/urb.c:703
 hub_quiesce+0x1e9/0x320 drivers/usb/core/hub.c:1412
 hub_suspend+0x4ab/0x9e0 drivers/usb/core/hub.c:4008
 usb_suspend_interface drivers/usb/core/driver.c:1323 [inline]
 usb_suspend_both+0x288/0x950 drivers/usb/core/driver.c:1446
 usb_runtime_suspend+0x49/0x120 drivers/usb/core/driver.c:2000
 __rpm_callback+0xc8/0x620 drivers/base/power/runtime.c:406
 rpm_callback+0x16a/0x1b0 drivers/base/power/runtime.c:460
 rpm_suspend+0x2f4/0x11a0 drivers/base/power/runtime.c:698
 __pm_runtime_suspend+0xba/0x1a0 drivers/base/power/runtime.c:1167
 pm_runtime_autosuspend include/linux/pm_runtime.h:415 [inline]
 usb_runtime_idle+0x7e/0x90 drivers/usb/core/driver.c:2037
 rpm_idle+0x322/0x790 drivers/base/power/runtime.c:550
 pm_runtime_work+0x120/0x150 drivers/base/power/runtime.c:995
 process_one_work+0xa23/0x1940 kernel/workqueue.c:3322
 process_scheduled_works kernel/workqueue.c:3405 [inline]
 worker_thread+0x5ef/0xe50 kernel/workqueue.c:3486
 kthread+0x370/0x450 kernel/kthread.c:436
 ret_from_fork+0x72b/0xd50 arch/x86/kernel/process.c:158
 ret_from_fork_asm+0x1a/0x30 arch/x86/entry/entry_64.S:245

Second to last potentially related work creation:
 kasan_save_stack+0x30/0x50 mm/kasan/common.c:57
 kasan_record_aux_stack+0xa7/0xc0 mm/kasan/generic.c:556
 insert_work+0x36/0x230 kernel/workqueue.c:2226
 __queue_work+0x9bc/0x12b0 kernel/workqueue.c:2401
 queue_work_on+0x1a9/0x1e0 kernel/workqueue.c:2452
 queue_work include/linux/workqueue.h:699 [inline]
 usb_hcd_giveback_urb+0x3b8/0x4a0 drivers/usb/core/hcd.c:1760
 rh_call_control drivers/usb/core/hcd.c:706 [inline]
 rh_urb_enqueue drivers/usb/core/hcd.c:817 [inline]
 usb_hcd_submit_urb+0xab7/0x2150 drivers/usb/core/hcd.c:1538
 usb_submit_urb+0x827/0x19b0 drivers/usb/core/urb.c:586
 usb_start_wait_urb+0x10e/0x580 drivers/usb/core/message.c:62
 usb_internal_control_msg drivers/usb/core/message.c:117 [inline]
 usb_control_msg+0x328/0x4b0 drivers/usb/core/message.c:167
 set_port_feature drivers/usb/core/hub.c:466 [inline]
 hub_suspend+0x826/0x9e0 drivers/usb/core/hub.c:3996
 usb_suspend_interface drivers/usb/core/driver.c:1323 [inline]
 usb_suspend_both+0x288/0x950 drivers/usb/core/driver.c:1446
 usb_runtime_suspend+0x49/0x120 drivers/usb/core/driver.c:2000
 __rpm_callback+0xc8/0x620 drivers/base/power/runtime.c:406
 rpm_callback+0x16a/0x1b0 drivers/base/power/runtime.c:460
 rpm_suspend+0x2f4/0x11a0 drivers/base/power/runtime.c:698
 __pm_runtime_suspend+0xba/0x1a0 drivers/base/power/runtime.c:1167
 pm_runtime_autosuspend include/linux/pm_runtime.h:415 [inline]
 usb_runtime_idle+0x7e/0x90 drivers/usb/core/driver.c:2037
 rpm_idle+0x322/0x790 drivers/base/power/runtime.c:550
 pm_runtime_work+0x120/0x150 drivers/base/power/runtime.c:995
 process_one_work+0xa23/0x1940 kernel/workqueue.c:3322
 process_scheduled_works kernel/workqueue.c:3405 [inline]
 worker_thread+0x5ef/0xe50 kernel/workqueue.c:3486
 kthread+0x370/0x450 kernel/kthread.c:436
 ret_from_fork+0x72b/0xd50 arch/x86/kernel/process.c:158
 ret_from_fork_asm+0x1a/0x30 arch/x86/entry/entry_64.S:245

The buggy address belongs to the object at ffff88802bf5c000
 which belongs to the cache kmalloc-8k of size 8192
The buggy address is located 4656 bytes inside of
 freed 8192-byte region [ffff88802bf5c000, ffff88802bf5e000)

The buggy address belongs to the physical page:
page: refcount:0 mapcount:0 mapping:0000000000000000 index:0x0 pfn:0x2bf58
head: order:3 mapcount:0 entire_mapcount:0 nr_pages_mapped:0 pincount:0
flags: 0xfff00000000040(head|node=0|zone=1|lastcpupid=0x7ff)
page_type: f5(slab)
raw: 00fff00000000040 ffff88801bc43180 dead000000000122 0000000000000000
raw: 0000000000000000 0000000800020002 00000000f5000000 0000000000000000
head: 00fff00000000040 ffff88801bc43180 dead000000000122 0000000000000000
head: 0000000000000000 0000000800020002 00000000f5000000 0000000000000000
head: 00fff00000000003 fffffffffffffe01 00000000ffffffff 00000000ffffffff
head: ffffffffffffffff 0000000000000000 00000000ffffffff 0000000000000008
page dumped because: kasan: bad access detected
page_owner tracks the page as allocated
page last allocated via order 3, migratetype Unmovable, gfp_mask 0xd20c0(__GFP_IO|__GFP_FS|__GFP_NOWARN|__GFP_NORETRY|__GFP_COMP|__GFP_NOMEMALLOC), pid 1, tgid 1 (swapper/0), ts 7941256619, free_ts 7717626992
 set_page_owner include/linux/page_owner.h:32 [inline]
 post_alloc_hook+0xfd/0x120 mm/page_alloc.c:1859
 prep_new_page mm/page_alloc.c:1867 [inline]
 get_page_from_freelist+0xf48/0x3530 mm/page_alloc.c:3946
 __alloc_frozen_pages_noprof+0x299/0x2dc0 mm/page_alloc.c:5304
 alloc_slab_page mm/slub.c:3266 [inline]
 allocate_slab mm/slub.c:3380 [inline]
 new_slab+0xa2/0x640 mm/slub.c:3426
 refill_objects+0xe3/0x410 mm/slub.c:7310
 refill_sheaf mm/slub.c:2804 [inline]
 __pcs_replace_empty_main+0x376/0x680 mm/slub.c:4675
 alloc_from_pcs mm/slub.c:4773 [inline]
 slab_alloc_node mm/slub.c:4905 [inline]
 __do_kmalloc_node mm/slub.c:5333 [inline]
 __kmalloc_noprof+0x66d/0x820 mm/slub.c:5359
 _kmalloc_noprof include/linux/slab.h:992 [inline]
 acpi_ut_initialize_buffer+0x144/0x220 drivers/acpi/acpica/utalloc.c:327
 acpi_rs_create_pci_routing_table+0x135/0xe00 drivers/acpi/acpica/rscreate.c:212
 acpi_rs_get_prt_method_data+0xc1/0x150 drivers/acpi/acpica/rsutils.c:456
 acpi_get_irq_routing_table+0xb8/0x140 drivers/acpi/acpica/rsxface.c:137
 acpi_pci_irq_find_prt_entry+0x179/0xdd0 drivers/acpi/pci_irq.c:215
 acpi_pci_irq_lookup+0x8e/0x6b0 drivers/acpi/pci_irq.c:299
 acpi_pci_irq_enable+0x1f5/0x6f0 drivers/acpi/pci_irq.c:414
 pcibios_enable_device+0xb6/0xe0 arch/x86/pci/common.c:699
 do_pci_enable_device+0x21f/0x4a0 drivers/pci/pci.c:1998
page last free pid 1351 tgid 1351 stack trace:
 reset_page_owner include/linux/page_owner.h:25 [inline]
 __free_pages_prepare mm/page_alloc.c:1406 [inline]
 free_pages_prepare+0x586/0xd80 mm/page_alloc.c:1451
 __free_contig_range_common+0x14f/0x250 mm/page_alloc.c:6897
 __free_contig_range mm/page_alloc.c:6942 [inline]
 free_pages_bulk+0x12a/0x200 mm/page_alloc.c:5257
 vm_area_free_pages+0xad/0x2b0 mm/vmalloc.c:3439
 vfree mm/vmalloc.c:3488 [inline]
 vfree+0x107/0x750 mm/vmalloc.c:3462
 delayed_vfree_work+0x56/0x80 mm/vmalloc.c:3392
 process_one_work+0xa23/0x1940 kernel/workqueue.c:3322
 process_scheduled_works kernel/workqueue.c:3405 [inline]
 worker_thread+0x5ef/0xe50 kernel/workqueue.c:3486
 kthread+0x370/0x450 kernel/kthread.c:436
 ret_from_fork+0x72b/0xd50 arch/x86/kernel/process.c:158
 ret_from_fork_asm+0x1a/0x30 arch/x86/entry/entry_64.S:245

Memory state around the buggy address:
 ffff88802bf5d100: fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb
 ffff88802bf5d180: fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb
>ffff88802bf5d200: fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb
                                     ^
 ffff88802bf5d280: fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb
 ffff88802bf5d300: fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb
==================================================================


---
If you want syzbot to run the reproducer, reply with:
#syz test: git://repo/address.git branch-or-commit-hash
If you attach or paste a git patch, syzbot will apply it before testing.
