Received: from mail-ot1-f47.google.com (mail-ot1-f47.google.com [209.85.210.47])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BC7443D1707
	for <syzbot@lists.linux.dev>; Wed, 29 Jul 2026 12:11:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.210.47
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785327116; cv=pass; b=us8/E72GTw6c/Ah9i36s9/kdqK3N4jd3QSe1O1jCdFu8rZRp7gmn6TYHEoncV2SpLYGMc32wJhGcvZ03erVja2EM1J8Dd9jZEN4h6Z9U1JUcxSTL49iUmEK1qqtGkzdmZX4kqojawNBvK6sAinuD+tCKXor4C0ptUQT0OKxyz0s=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785327116; c=relaxed/simple;
	bh=7BpagZmuhLFkXn4HeGB4XPR6gh7sGT+B0fZZgukpCm0=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=DlGPSAmEBjGe0eVVDrb71beKVgsEcTYri+N52dsDR7+8v9FOy40hqeN0a/wKtEd5yCYvLb9bdLzZotZsEqbQ+1/UOy0x8TpgBuNTN9oi+fd4N0W3wcCw0l3XkG2MouAY5Sx28om9oVc8WrMPeky0qsAmYCeyGkLfy2efRkXGVgc=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=GiyJmp29; arc=pass smtp.client-ip=209.85.210.47
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="GiyJmp29"
Received: by mail-ot1-f47.google.com with SMTP id 46e09a7af769-7eb6573bd52so646028a34.3
        for <syzbot@lists.linux.dev>; Wed, 29 Jul 2026 05:11:49 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1785327108; cv=none;
        d=google.com; s=arc-20260327;
        b=F80OEafBRqZopeuC6LzkpfB4VgHFKH2Q6ahWOMV+Ajw1EMeR8lmsXA/zxbWPfYJzFl
         cppdBVWKxW1lZfo97HcCoZ57iLpjB5ULAcHd+aTgfQBh8x9AT+MPF6MQaLs/OLnZKtGq
         kyjhl0eMmpu6muPwjRR2Vt4X+YkgpfUWvHINxgltWZRghWr8TYHkezmfIIDfZw/b48PC
         XOntJ/kGBjJ1gZC3wMeYDBj8C1CvMgP/hegH5PQkKaS/Ape+FtMsoJpXsBOGbdd1gzOn
         aXpFN9elapYwTMUMmKhX8fjkuOZ+84CDsWeLwjJyt5qGPM9TD+fIv6Jgcme+gbtxCCEF
         2qkQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=W/pxu/qSNLwLtIN1FPLMX3DMSINebaGj08BjSk07cB4=;
        fh=hnNcyOrFLzuS6w5ZlK3Rycrj4GeR9Zodmm0lcbbq2v4=;
        b=PH+O622JS8GuH05bdBqb9mz1TUFz3FJUzyQk4cP+9kVlf1MHVEfp321ukN0SaI8kEH
         TOhvTwW10+pyd8JxzYi9HCVykzUdKAbBRkSULeq8WgjeGGyB8GKUP12EgIr1SKtT0W+x
         9KfQNgHYbeGgtaO4opp7klo0tlOoEueVVbzsvif81sg3yVtwamJ5TA0JODnijWaTOpso
         w0QvxKe01vhiaJPgUrcAbG73fW5ocIxOJW75UcqwOxWHR5WS8PCyHzEhUaRxCUxmrUOr
         hqX7O48WwjbKI1nVU2vlziG4QDt96WUyOVeHun5NenBRH6xBTilC84q+nqgSx1RUBNs5
         m6Dw==;
        darn=lists.linux.dev
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1785327108; x=1785931908; darn=lists.linux.dev;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=W/pxu/qSNLwLtIN1FPLMX3DMSINebaGj08BjSk07cB4=;
        b=GiyJmp299efnHDBauj8saZkfKFw3Fp154ZJUNikdEpo7R9elIn3+dYxYn4pvPVuZAj
         pLL2A7t8O5T5v3lE3IJFuRXI0myNbPZgEY5wFVzBC3GiOi7ziMZKMz/ET1oUTpmvvSqG
         QcXRnwT3M0nY/uxxhJEZRin3C8EfoVaB9348h5ccLLbp6qmFHMMFfC6TXvR7NZ0/7hRj
         z0QlTsNtVThpuqN9ecD7or7JDY0b4qGCN2CZ+p6Bh7dmeOhlZZxAb+MBbbnp5wXNQwFi
         WBMqUc69bnpH/eqLaVjrdPaXV0pF1UGltPpXGOaGaPnPefR/hwlvmw+wjk5abUcTIFyg
         62mA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1785327108; x=1785931908;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=W/pxu/qSNLwLtIN1FPLMX3DMSINebaGj08BjSk07cB4=;
        b=LC+X2nb6kEzAThiTPImzD99wu+evol8QgZla4VR5Wll32MoBuwLE0OuSL7MiCI1uEf
         2ZHKFcfFEMhL63i/FQQHHubQyzJivtw2ab5vHHzKxYib492vIM48IMR+cjHMp7bsQ8wZ
         QKixOIe4AdcxwHqN13RLK03eohY3JU1++fmbAHZkJq0IcQmE1tO7O9L9VeSUP0ZNSbC4
         vW06vi7wOGo+TF8qJ5faeOVes3frJAEtvHdBY0O0QyMMihzvpj44ujeiRe0nR8bMzixy
         NdjZlu+cRcQm5iVWCMTTbbZ0g1utEdpwvUL8cLB1kzAa6EehXh7aeBpUkcu19hPdd7dF
         JTng==
X-Forwarded-Encrypted: i=1; AHgh+RrtREuMs26Dju1lKgVThalc4qGfT/AQMtGGtosf2zzlh/rdHcNhGvfCpQH/XCpB2c8f0iGAbTY=@lists.linux.dev
X-Gm-Message-State: AOJu0YzEeZjFxyOUn3cpjHoaRiGjphJQN8ULufEI7onpoWX/PGz/21Is
	FQqu5ekWLUtpnOTwQaXsJLcptvc/R+OmpS+ieHIwkcBNsheWnyyJpr3J0BTQthsKOgOELwd8+E9
	llgWfCvBGleMzjnmc7UhizLnaa62+zWwKQirEfTzg
X-Gm-Gg: AR+sD10iFfRvYsMlXzUwd2bYbFqs/eDdIRhepMLX3R2eBELNTEcmrmd05q/0VPlysuy
	v8XESFhIOl43SOJiYXbubeu3jGC/Ap7cFNNdjOISTld/BdOYFlUZ9rqb8jDeO05g+q11O2HlZBq
	FUWz33DeSbFCNb4/I40kSfiNm6yVmtMr2EmLNIWrtzoev6Tu9dOU7vhmeBR7pBVR84b+gWjTK+U
	ho/X2igNqUxUv853XJaySvpxHty6XdFxg9tRnXaqrk7vbx5McPKg7P6O06oam7k4VAkD50q4/GV
	G143+tYuUM4ZLL5Po2T5Eu94gQI5/ECCjfq+qu4kOsHvZTz8iS8xyrmWX+yxf2qT87dunEZ9ZeZ
	S9eMd+L68MTMtG0ru492ThXvOeA/JrMWUzd12lv+Zv7mXhBBg6jPv3rHFvrN4yjtpIiKDzLgOaB
	21CmOUJ7ncZrYX
X-Received: by 2002:a05:6808:10ce:b0:4a3:d383:b3ea with SMTP id
 5614622812f47-4ad5bb44357mr3637986b6e.27.1785327107316; Wed, 29 Jul 2026
 05:11:47 -0700 (PDT)
Precedence: bulk
X-Mailing-List: syzbot@lists.linux.dev
List-Id: <syzbot.lists.linux.dev>
List-Subscribe: <mailto:syzbot+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:syzbot+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <6a69dcda.d9e86bb5.297b12.0063.GAE@google.com>
In-Reply-To: <6a69dcda.d9e86bb5.297b12.0063.GAE@google.com>
From: Aleksandr Nogikh <nogikh@google.com>
Date: Wed, 29 Jul 2026 14:11:34 +0200
X-Gm-Features: AUfX_mxf6Z1u_shF5YIlt4bA_fKVk93y2fv2vG9EWSp3wOwCg3eXa4HhiaX0sQU
Message-ID: <CANp29Y4Rn9RqcbzdTsk5ZaFqOHijkVGXuwd7ecCCPgxfKucdTA@mail.gmail.com>
Subject: Re: [moderation/CI] Re: zram: fix early release of global cdict/ddict
 in per-CPU error path
To: syzbot ci <syzbot+ci163dda578633ce51@syzkaller.appspotmail.com>
Cc: syzkaller-upstream-moderation@googlegroups.com, syzbot@lists.linux.dev
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

No, not related.

#syz invalid

On Wed, Jul 29, 2026 at 12:58=E2=80=AFPM syzbot ci
<syzbot+ci163dda578633ce51@syzkaller.appspotmail.com> wrote:
>
> syzbot ci has tested the following series
>
> [v2] zram: fix early release of global cdict/ddict in per-CPU error path
> https://lore.kernel.org/all/20260728092935.31139-1-haoqinhuang7@gmail.com
> * [PATCH v2 1/5] zram: fix early release of global cdict/ddict in per-CPU=
 error path
> * [PATCH v2 2/5] zram: make dict update in comp_params_store() atomic
> * [PATCH v2 3/5] zstd: move ZSTD_MAX_CLEVEL to zstd_lib.h
> * [PATCH v2 4/5] zram: add per-backend caps and validate parameters early
> * [PATCH v2 5/5] zram: reset per-priority params when changing algorithm =
before init
>
> and found the following issue:
> KASAN: slab-use-after-free Read in event_handler
>
> Full report is available here:
> https://ci.syzbot.org/series/e2672818-2e9a-4685-8cee-6e5202cb0372
>
> ***
>
> KASAN: slab-use-after-free Read in event_handler
>
> tree:      axboe
> URL:       https://kernel.googlesource.com/pub/scm/linux/kernel/git/axboe=
/linux.git
> base:      923b1b5a3a5cc642172d8cf8c6097ad1169b6217
> arch:      amd64
> compiler:  Debian clang version 22.1.8 (++20260613092233+e80beda6e255-1~e=
xp1~20260613092250.77), Debian LLD 22.1.8
> config:    https://ci.syzbot.org/builds/444dc77b-c272-46a7-ac65-9b594a954=
b56/config
> syz repro: https://ci.syzbot.org/findings/6c520622-cfcc-490d-88c4-b7f2828=
8e76c/syz_repro
>
> vhci_hcd vhci_hcd.0: release socket
> vhci_hcd vhci_hcd.0: disconnect device
> =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
> BUG: KASAN: slab-use-after-free in __raw_spin_lock_irqsave include/linux/=
spinlock_api_smp.h:132 [inline]
> BUG: KASAN: slab-use-after-free in _raw_spin_lock_irqsave+0x40/0x60 kerne=
l/locking/spinlock.c:166
> Read of size 1 at addr ffff88816d3a8478 by task kworker/u8:5/5796
>
> CPU: 1 UID: 0 PID: 5796 Comm: kworker/u8:5 Not tainted syzkaller #0 PREEM=
PT(full)
> Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS 1.16.2-debian-1.=
16.2-1 04/01/2014
> Workqueue: usbip_event event_handler
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
>  unset_event drivers/usb/usbip/usbip_event.c:35 [inline]
>  event_handler+0x2b0/0x4b0 drivers/usb/usbip/usbip_event.c:80
>  process_one_work kernel/workqueue.c:3322 [inline]
>  process_scheduled_works+0xa8e/0x14e0 kernel/workqueue.c:3405
>  worker_thread+0xa47/0xfb0 kernel/workqueue.c:3486
>  kthread+0x388/0x470 kernel/kthread.c:436
>  ret_from_fork+0x514/0xb70 arch/x86/kernel/process.c:158
>  ret_from_fork_asm+0x1a/0x30 arch/x86/entry/entry_64.S:245
>  </TASK>
>
> Allocated by task 1:
>  kasan_save_stack mm/kasan/common.c:57 [inline]
>  kasan_save_track+0x3e/0x80 mm/kasan/common.c:78
>  poison_kmalloc_redzone mm/kasan/common.c:398 [inline]
>  __kasan_kmalloc+0x93/0xb0 mm/kasan/common.c:415
>  kasan_kmalloc include/linux/kasan.h:263 [inline]
>  __do_kmalloc_node mm/slub.c:5362 [inline]
>  __kmalloc_noprof+0x375/0x720 mm/slub.c:5387
>  _kmalloc_noprof include/linux/slab.h:973 [inline]
>  _kzalloc_noprof include/linux/slab.h:1290 [inline]
>  __usb_create_hcd+0x67/0x900 drivers/usb/core/hcd.c:2566
>  vhci_hcd_probe+0x104/0x3e0 drivers/usb/usbip/vhci_hcd.c:1378
>  platform_probe+0xf9/0x190 drivers/base/platform.c:1439
>  call_driver_probe drivers/base/dd.c:-1 [inline]
>  really_probe+0x254/0xae0 drivers/base/dd.c:706
>  __driver_probe_device+0x1e8/0x360 drivers/base/dd.c:868
>  driver_probe_device+0x4f/0x240 drivers/base/dd.c:898
>  __device_attach_driver+0x270/0x410 drivers/base/dd.c:1026
>  bus_for_each_drv+0x258/0x2f0 drivers/base/bus.c:500
>  __device_attach+0x2c4/0x450 drivers/base/dd.c:1098
>  device_initial_probe+0xa1/0xd0 drivers/base/dd.c:1153
>  bus_probe_device+0x12a/0x220 drivers/base/bus.c:620
>  device_add+0x7d7/0xb80 drivers/base/core.c:3772
>  platform_device_add+0x4bd/0x860 drivers/base/platform.c:762
>  platform_device_register_full+0x62d/0x710 drivers/base/platform.c:902
>  vhci_hcd_init+0x227/0x360 drivers/usb/usbip/vhci_hcd.c:1557
>  do_one_initcall+0x250/0x870 init/main.c:1347
>  do_initcall_level+0x10a/0x1a0 init/main.c:1409
>  do_initcalls+0x59/0xa0 init/main.c:1425
>  kernel_init_freeable+0x29d/0x3e0 init/main.c:1658
>  kernel_init+0x1d/0x1d0 init/main.c:1548
>  ret_from_fork+0x514/0xb70 arch/x86/kernel/process.c:158
>  ret_from_fork_asm+0x1a/0x30 arch/x86/entry/entry_64.S:245
>
> Freed by task 5870:
>  kasan_save_stack mm/kasan/common.c:57 [inline]
>  kasan_save_track+0x3e/0x80 mm/kasan/common.c:78
>  kasan_save_free_info+0x40/0x50 mm/kasan/generic.c:584
>  poison_slab_object mm/kasan/common.c:253 [inline]
>  __kasan_slab_free+0x5c/0x80 mm/kasan/common.c:285
>  kasan_slab_free include/linux/kasan.h:235 [inline]
>  slab_free_hook mm/slub.c:2705 [inline]
>  slab_free mm/slub.c:6405 [inline]
>  kfree+0x1c5/0x640 mm/slub.c:6720
>  vhci_hcd_remove+0xe4/0x110 drivers/usb/usbip/vhci_hcd.c:1434
>  device_remove drivers/base/dd.c:616 [inline]
>  __device_release_driver drivers/base/dd.c:1349 [inline]
>  device_release_driver_internal+0x48b/0x880 drivers/base/dd.c:1372
>  unbind_store+0x1a1/0x1d0 drivers/base/bus.c:244
>  kernfs_fop_write_iter+0x3a4/0x540 fs/kernfs/file.c:345
>  new_sync_write fs/read_write.c:595 [inline]
>  vfs_write+0x612/0xba0 fs/read_write.c:687
>  ksys_write+0x150/0x270 fs/read_write.c:739
>  do_syscall_x64 arch/x86/entry/syscall_64.c:63 [inline]
>  do_syscall_64+0x174/0x580 arch/x86/entry/syscall_64.c:94
>  entry_SYSCALL_64_after_hwframe+0x77/0x7f
>
> Last potentially related work creation:
>  kasan_save_stack+0x3e/0x60 mm/kasan/common.c:57
>  kasan_record_aux_stack+0xbd/0xd0 mm/kasan/generic.c:556
>  insert_work+0x3d/0x330 kernel/workqueue.c:2226
>  __queue_work+0xcd8/0x10a0 kernel/workqueue.c:2401
>  queue_work_on+0x106/0x1d0 kernel/workqueue.c:2452
>  usb_rh_urb_dequeue drivers/usb/core/hcd.c:845 [inline]
>  unlink1+0x344/0x3e0 drivers/usb/core/hcd.c:1580
>  usb_hcd_unlink_urb+0xe6/0x1e0 drivers/usb/core/hcd.c:1617
>  usb_kill_urb+0x10b/0x2f0 drivers/usb/core/urb.c:716
>  hub_quiesce+0x211/0x330 drivers/usb/core/hub.c:1412
>  hub_suspend+0x904/0xad0 drivers/usb/core/hub.c:4008
>  usb_suspend_interface drivers/usb/core/driver.c:1323 [inline]
>  usb_suspend_both+0x285/0x1040 drivers/usb/core/driver.c:1446
>  usb_runtime_suspend+0x58/0x110 drivers/usb/core/driver.c:2000
>  __rpm_callback+0x2c7/0x950 drivers/base/power/runtime.c:406
>  rpm_callback drivers/base/power/runtime.c:460 [inline]
>  rpm_suspend+0x8a0/0x17b0 drivers/base/power/runtime.c:698
>  __pm_runtime_suspend+0x12f/0x1a0 drivers/base/power/runtime.c:1167
>  pm_runtime_put_sync_autosuspend include/linux/pm_runtime.h:740 [inline]
>  usb_new_device+0xadf/0x1620 drivers/usb/core/hub.c:2727
>  register_root_hub+0x250/0x5c0 drivers/usb/core/hcd.c:990
>  usb_add_hcd+0xac7/0xf80 drivers/usb/core/hcd.c:2987
>  vhci_hcd_probe+0x141/0x3e0 drivers/usb/usbip/vhci_hcd.c:1388
>  platform_probe+0xf9/0x190 drivers/base/platform.c:1439
>  call_driver_probe drivers/base/dd.c:-1 [inline]
>  really_probe+0x254/0xae0 drivers/base/dd.c:706
>  __driver_probe_device+0x1e8/0x360 drivers/base/dd.c:868
>  driver_probe_device+0x4f/0x240 drivers/base/dd.c:898
>  __device_attach_driver+0x270/0x410 drivers/base/dd.c:1026
>  bus_for_each_drv+0x258/0x2f0 drivers/base/bus.c:500
>  __device_attach+0x2c4/0x450 drivers/base/dd.c:1098
>  device_initial_probe+0xa1/0xd0 drivers/base/dd.c:1153
>  bus_probe_device+0x12a/0x220 drivers/base/bus.c:620
>  device_add+0x7d7/0xb80 drivers/base/core.c:3772
>  platform_device_add+0x4bd/0x860 drivers/base/platform.c:762
>  platform_device_register_full+0x62d/0x710 drivers/base/platform.c:902
>  vhci_hcd_init+0x227/0x360 drivers/usb/usbip/vhci_hcd.c:1557
>  do_one_initcall+0x250/0x870 init/main.c:1347
>  do_initcall_level+0x10a/0x1a0 init/main.c:1409
>  do_initcalls+0x59/0xa0 init/main.c:1425
>  kernel_init_freeable+0x29d/0x3e0 init/main.c:1658
>  kernel_init+0x1d/0x1d0 init/main.c:1548
>  ret_from_fork+0x514/0xb70 arch/x86/kernel/process.c:158
>  ret_from_fork_asm+0x1a/0x30 arch/x86/entry/entry_64.S:245
>
> Second to last potentially related work creation:
>  kasan_save_stack+0x3e/0x60 mm/kasan/common.c:57
>  kasan_record_aux_stack+0xbd/0xd0 mm/kasan/generic.c:556
>  insert_work+0x3d/0x330 kernel/workqueue.c:2226
>  __queue_work+0xcd8/0x10a0 kernel/workqueue.c:2401
>  queue_work_on+0x106/0x1d0 kernel/workqueue.c:2452
>  rh_call_control drivers/usb/core/hcd.c:706 [inline]
>  rh_urb_enqueue drivers/usb/core/hcd.c:817 [inline]
>  usb_hcd_submit_urb+0xa3b/0x1b60 drivers/usb/core/hcd.c:1538
>  usb_start_wait_urb+0x13f/0x5b0 drivers/usb/core/message.c:62
>  usb_internal_control_msg drivers/usb/core/message.c:117 [inline]
>  usb_control_msg+0x234/0x3e0 drivers/usb/core/message.c:167
>  get_port_status drivers/usb/core/hub.c:607 [inline]
>  hub_ext_port_status+0x114/0x810 drivers/usb/core/hub.c:624
>  usb_hub_port_status drivers/usb/core/hub.c:674 [inline]
>  hub_activate+0x740/0x1b20 drivers/usb/core/hub.c:1185
>  process_one_work kernel/workqueue.c:3322 [inline]
>  process_scheduled_works+0xa8e/0x14e0 kernel/workqueue.c:3405
>  worker_thread+0xa47/0xfb0 kernel/workqueue.c:3486
>  kthread+0x388/0x470 kernel/kthread.c:436
>  ret_from_fork+0x514/0xb70 arch/x86/kernel/process.c:158
>  ret_from_fork_asm+0x1a/0x30 arch/x86/entry/entry_64.S:245
>
> The buggy address belongs to the object at ffff88816d3a8000
>  which belongs to the cache kmalloc-8k of size 8192
> The buggy address is located 1144 bytes inside of
>  freed 8192-byte region [ffff88816d3a8000, ffff88816d3aa000)
>
> The buggy address belongs to the physical page:
> page: refcount:0 mapcount:0 mapping:0000000000000000 index:0x0 pfn:0x16d3=
a8
> head: order:3 mapcount:0 entire_mapcount:0 nr_pages_mapped:0 pincount:0
> flags: 0x57ff00000000040(head|node=3D1|zone=3D2|lastcpupid=3D0x7ff)
> page_type: f5(slab)
> raw: 057ff00000000040 ffff888100042280 dead000000000122 0000000000000000
> raw: 0000000000000000 0000000800020002 00000000f5000000 0000000000000000
> head: 057ff00000000040 ffff888100042280 dead000000000122 0000000000000000
> head: 0000000000000000 0000000800020002 00000000f5000000 0000000000000000
> head: 057ff00000000003 fffffffffffffe01 00000000ffffffff 00000000ffffffff
> head: ffffffffffffffff 0000000000000000 00000000ffffffff 0000000000000008
> page dumped because: kasan: bad access detected
> page_owner tracks the page as allocated
> page last allocated via order 3, migratetype Unmovable, gfp_mask 0xd20c0(=
__GFP_IO|__GFP_FS|__GFP_NOWARN|__GFP_NORETRY|__GFP_COMP|__GFP_NOMEMALLOC), =
pid 1, tgid 1 (swapper/0), ts 15263763575, free_ts 0
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
>  __kmalloc_cache_noprof+0x3a7/0x660 mm/slub.c:5511
>  _kmalloc_noprof include/linux/slab.h:969 [inline]
>  _kzalloc_noprof include/linux/slab.h:1290 [inline]
>  dummy_hcd_init+0x3e2/0xd00 drivers/usb/gadget/udc/dummy_hcd.c:2836
>  do_one_initcall+0x250/0x870 init/main.c:1347
>  do_initcall_level+0x10a/0x1a0 init/main.c:1409
>  do_initcalls+0x59/0xa0 init/main.c:1425
>  kernel_init_freeable+0x29d/0x3e0 init/main.c:1658
>  kernel_init+0x1d/0x1d0 init/main.c:1548
>  ret_from_fork+0x514/0xb70 arch/x86/kernel/process.c:158
>  ret_from_fork_asm+0x1a/0x30 arch/x86/entry/entry_64.S:245
> page_owner free stack trace missing
>
> Memory state around the buggy address:
>  ffff88816d3a8300: fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb
>  ffff88816d3a8380: fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb
> >ffff88816d3a8400: fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb
>                                                                 ^
>  ffff88816d3a8480: fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb
>  ffff88816d3a8500: fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb
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
> [akpm@linux-foundation.org axboe@kernel.dk dsterba@suse.com haoqinhuang7@=
gmail.com haoqinhuang@tencent.com linux-block@vger.kernel.org linux-kernel@=
vger.kernel.org minchan@kernel.org senozhatsky@chromium.org terrelln@fb.com=
 zigiwang@tencent.com]
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
-upstream-moderation/6a69dcda.d9e86bb5.297b12.0063.GAE%40google.com.
