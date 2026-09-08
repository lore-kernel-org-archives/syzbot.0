Received: from mail-ot1-f54.google.com (mail-ot1-f54.google.com [209.85.210.54])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B743F5111AF
	for <syzbot@lists.linux.dev>; Tue,  8 Sep 2026 09:20:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.210.54
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788859217; cv=pass; b=BOfgzrGeaqmlvf+e0CoZYRhMvx/7Tr+hRB+cfvr5Y9g7ZN4uVYQYGUtLywDg1MbANzqQ+th9PhZ7Ko8wTB7Wu+diZZYlOFWY0R4Jw33/eAfmLj+GN/MhiTxRttny4kGsMRQG6NQS70dabWU1SVXUKM/D9f6EA7mxpBRcutWFnw4=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788859217; c=relaxed/simple;
	bh=bd1g/bjbJ5YY4Q2z1EAZG4ki1NzvirlwGttFRoRHHNA=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=jlUgqIBPl75gVJe/fupvZJAAt5XotJn3paRlZwRf8b+xcrwZJO7QBKyIYVkLlW2/YUj3wozWu7K+cXMAjUhKbV4kz2Tuc5XPp7uHJc8XchbLt2CPrr+eABQKB1gjKlvl5AYQaR/USxxjpMfH0wb+NXMR/Ccbh76XfTxsTwhIReA=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=uUv//KJf; arc=pass smtp.client-ip=209.85.210.54
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="uUv//KJf"
Received: by mail-ot1-f54.google.com with SMTP id 46e09a7af769-8009036d745so54856a34.1
        for <syzbot@lists.linux.dev>; Tue, 08 Sep 2026 02:20:13 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1788859213; cv=none;
        d=google.com; s=arc-20260327;
        b=mbnQdtZ4wtADdt7dyoobg0kFafXaUJ23aNyOHbhzR43MKOg58Z5fKDjHlRF+jsQKph
         hjz/eHhVhUNZytrd8ynyD5b5R5JigE3tgC+o/86I0jBiTSJo/G9OCuvL6FQ3JilVg5d5
         gzWq7ZjCtdp5E19YWEcO0gkXJ6CnmKlajDIFCIlsMaGBEa9qMZosn53l72qGyyB71Kd+
         DeK7eGHvlzRdTJkWGcbVr8AbHBlvRhlebtF7uPs4X1yE63+zh5Z1j7JALAoxJeGx6icm
         s/PQADxLbdeg12TJIFhijySSDyi0aCu8N2Mz2glgpXT3hXwQ4TKoi4yKPdcFy5dO13KR
         hJ4Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=YRBVlNVivbkM1/24ibMtw5m5ieJ7Itt5gSgbYY1oTSM=;
        fh=q/kkjKeEJam4eBhK+aX6KcYJl396t8qtBVH12pCqqfM=;
        b=mOyzc6w/10wzqW6M5k24FX04bvG+wP5AHZCpp2ni/6stx4qbAso6Ik9iBeqMZtwo8P
         KYhpKE8BqOo6lNBnDP/vTaoTT4J9HaLD6hIGBG3ZXQPb0AcnigyGaKol7Z0iHTNZhp3b
         pWDvq5kcCmz4YLY9N9GBmopIk2Ta1PLNrvPYb4kdhV3fHkaUBuzYdEbJUX57mRXEgTgf
         KJGM0fTMfcq0m1+ovsnwIOcMc+t6EAxdlBgET+jUWY6xu1N4NejFHuoBKeKjhYp+ZJOi
         O3lFVpFBbnh8EaMTe3VLd9AgJvH64PRHeuRJIGdoTH/YyG1JtecIRaDx31Iq9x5+fMfo
         SJrQ==;
        darn=lists.linux.dev
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1788859213; x=1789464013; darn=lists.linux.dev;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=YRBVlNVivbkM1/24ibMtw5m5ieJ7Itt5gSgbYY1oTSM=;
        b=uUv//KJfRdovSd8dJyP6B+mPkBtDtRwFjRuZr5MAWu/4AcaxWmEXQQiPqRONi921kP
         ewLgFoCQi9l/HUb7fiyWFtaByl4JOfN7S4aG+h5hwNC+3pPPHMqWbemBay8LkNRYgyRV
         kgb+/LFkRKrcku49xw5zXhBmHZb+nh+aUbsTBcrHHW87xufTOOK9Onebw6hNBLMlLdbN
         Fq0KP3A1dCEbxSxe2l1UX1pWYQ4egajP2N17RhecdWaPTjR5pcNndy4N1Fw0ahxy7o1u
         XZwpxmQ9s65aWIlRuaulqWdd0qxPjLpMm2HMnKnofXQ3jN0WhAlyTDWAdb1wgYc92b7J
         CHCQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1788859213; x=1789464013;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=YRBVlNVivbkM1/24ibMtw5m5ieJ7Itt5gSgbYY1oTSM=;
        b=SJ7r9Kh+Dyh7a7yFUNUg5n+/9B/Me8HEXTcUJihPxVvAqQEr2/hZVh04HLKS/q498Y
         XA1JSBvhQZqnl84MxW0MsRVcyzdHGf+E6xFBcV0vw904RzKxcyUIt8lPp2U5okPLatax
         rRPnaiRW8D4KCtUxeQZ+4lmMDR0KeTxOzfyMYOTGasWowc+xNCvWBi6GtkrwjYJo+oM1
         wMVfeTOnW2cUZMvvgdJMPReMZJY3NRMiJF8Sf0b6WmTcpDI2Yo3esSAcQXcA5yeRoget
         4/SEqseHEOzyrqUA/4ubxl/5pWmxlAcWhSOoQJ0i3vM/8fMGdN+JWhxntzLxZRjz55oQ
         3hOg==
X-Forwarded-Encrypted: i=1; AKwUvBxKW+xMapbRLKOGa+9teVbaDkhvpbf0mJn36LQTUX5/4JRYhsQRT2rMzOVJmkpUPUJ7JU+GCSw=@lists.linux.dev
X-Gm-Message-State: AFuF++mpH7S7qpJ2NW+J6VmDwhuEIWulsTt6b8fjNj8T915XGdV4PReX
	Iv1csciy8ONir1lE/M6XMLWT7ZjybOyvQPZBUnwwm6G6APD7h+l5cwLx4wAC+1gZDXqZZMVwQvJ
	xTDNSMHR/BRflbVuiewb5Y07pezv+oZW+uFXLMJ2h
X-Gm-Gg: AYBFou0Kt5YkHKAzjRGPl74zD0hrOvvjvjSAKtdMr1gBIEpenAiIfLOgR7RJTvav8la
	W4D8j6/8gy25IshTnF+bQ8Xe3DuoKAU3hkIzGpyCzRyw7CtKhQ7i8qJakFjJQTLXZcDlaKIwgIW
	xd7hzViC2E6UIa5T1Cp9nDsJiADl+n/0J7dyqpgaWuG81Nb7D4hQSTTB0PSVMs61CEcbW96zIUo
	DU60qH6ai1AMM+JmsIhJ0C82RAfuAnYjmC8sVSc8NZo6cz0Ff/BhVy4Jcfyt1cP4Kt3yUuQEGJx
	sfYaVBJugpXcfAzR8/dRiFKY5FQ+3RgFB2wSh2ZfXp6UlZ+jnZTFsK+UO5WoUuQZR+VAdLkhhOl
	GktEDLnv4ANk9a4mE03nTtMlmCTu5HaHH26OfMnMjd6ic3bxf2ESXXL52uW1AgE6R4rl2Azl8QY
	PTWudBA5y0yC4tQg==
X-Received: by 2002:a05:6830:381b:b0:7f6:ec23:7956 with SMTP id
 46e09a7af769-7fa1e0ba59cmr31711101a34.2.1788859212020; Tue, 08 Sep 2026
 02:20:12 -0700 (PDT)
Precedence: bulk
X-Mailing-List: syzbot@lists.linux.dev
List-Id: <syzbot.lists.linux.dev>
List-Subscribe: <mailto:syzbot+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:syzbot+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <6a6d3cbd.6ce73036.24301b.000c.GAE@google.com> <6a7424a0.01d0871a.3a0d52.0012.GAE@google.com>
In-Reply-To: <6a7424a0.01d0871a.3a0d52.0012.GAE@google.com>
From: Aleksandr Nogikh <nogikh@google.com>
Date: Tue, 8 Sep 2026 11:20:00 +0200
X-Gm-Features: AcwNN1VrcVk4ZvOhAjl1YoQBAYY230WsyXsDjU9XP-b3jB2TVS3HbGduRsDZ3rw
Message-ID: <CANp29Y55MAVRP-TwMMfTuWS=vTr3J=i_iGdKd6gz5Fodsu09yA@mail.gmail.com>
Subject: Re: [syzbot] [usb?] KASAN: slab-use-after-free Read in vhci_cleanup_unlink_list
To: syzbot <syzbot+f4518ac0a3dd3aafde38@syzkaller.appspotmail.com>
Cc: linux-kernel@vger.kernel.org, linux-usb@vger.kernel.org, 
	syzbot@lists.linux.dev, syzkaller-bugs@googlegroups.com, 
	syzkaller-upstream-moderation@googlegroups.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

#syz invalid

See the discussion at
https://lore.kernel.org/all/6a88012e.dbb3a75c.13dd47.0007.GAE@google.com/T/

On Thu, Aug 6, 2026 at 8:07=E2=80=AFAM syzbot
<syzbot+f4518ac0a3dd3aafde38@syzkaller.appspotmail.com> wrote:
>
> syzbot has found a reproducer for the following issue on:
>
> HEAD commit:    0d8395707651 Merge tag 'soc-fixes-7.2-2' of git://git.ker=
n..
> git tree:       upstream
> console output: https://syzkaller.appspot.com/x/log.txt?x=3D1455929e58000=
0
> kernel config:  https://syzkaller.appspot.com/x/.config?x=3D145fa60d73086=
782
> dashboard link: https://syzkaller.appspot.com/bug?extid=3Df4518ac0a3dd3aa=
fde38
> compiler:       gcc (Debian 14.2.0-19) 14.2.0, GNU ld (GNU Binutils for D=
ebian) 2.44
> syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=3D12e5bbb9580=
000
> C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=3D16ffb7b958000=
0
>
> Downloadable assets:
> disk image (non-bootable): https://storage.googleapis.com/syzbot-assets/d=
900f083ada3/non_bootable_disk-0d839570.raw.xz
> vmlinux: https://storage.googleapis.com/syzbot-assets/0b7275b6c889/vmlinu=
x-0d839570.xz
> kernel image: https://storage.googleapis.com/syzbot-assets/b752a676c1dd/b=
zImage-0d839570.xz
>
> IMPORTANT: if you fix the issue, please add the following tag to the comm=
it:
> Reported-by: syzbot+f4518ac0a3dd3aafde38@syzkaller.appspotmail.com
>
> vhci_hcd vhci_hcd.0: release socket
> =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
> BUG: KASAN: slab-use-after-free in vdev_to_vhci_hcd drivers/usb/usbip/vhc=
i.h:171 [inline]
> BUG: KASAN: slab-use-after-free in vhci_cleanup_unlink_list+0x44/0x456 dr=
ivers/usb/usbip/vhci_hcd.c:985
> Read of size 4 at addr ffff88802bf5d230 by task kworker/u32:3/5807
>
> CPU: 1 UID: 0 PID: 5807 Comm: kworker/u32:3 Not tainted syzkaller #0 PREE=
MPT(full)
> Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS 1.16.3-debian-1.=
16.3-2 04/01/2014
> Workqueue: usbip_event event_handler
> Call Trace:
>  <TASK>
>  __dump_stack lib/dump_stack.c:94 [inline]
>  dump_stack_lvl+0x100/0x190 lib/dump_stack.c:120
>  print_address_description mm/kasan/report.c:378 [inline]
>  print_report+0x13d/0x4b0 mm/kasan/report.c:482
>  kasan_report+0xdf/0x1c0 mm/kasan/report.c:595
>  vdev_to_vhci_hcd drivers/usb/usbip/vhci.h:171 [inline]
>  vhci_cleanup_unlink_list+0x44/0x456 drivers/usb/usbip/vhci_hcd.c:985
>  vhci_device_unlink_cleanup drivers/usb/usbip/vhci_hcd.c:1028 [inline]
>  vhci_shutdown_connection.cold+0x165/0x37c drivers/usb/usbip/vhci_hcd.c:1=
069
>  event_handler+0x216/0x570 drivers/usb/usbip/usbip_event.c:79
>  process_one_work+0xa23/0x1940 kernel/workqueue.c:3322
>  process_scheduled_works kernel/workqueue.c:3405 [inline]
>  worker_thread+0x5ef/0xe50 kernel/workqueue.c:3486
>  kthread+0x370/0x450 kernel/kthread.c:436
>  ret_from_fork+0x72b/0xd50 arch/x86/kernel/process.c:158
>  ret_from_fork_asm+0x1a/0x30 arch/x86/entry/entry_64.S:245
>  </TASK>
>
> Allocated by task 1:
>  kasan_save_stack+0x30/0x50 mm/kasan/common.c:57
>  kasan_save_track+0x14/0x30 mm/kasan/common.c:78
>  poison_kmalloc_redzone mm/kasan/common.c:398 [inline]
>  __kasan_kmalloc+0xaa/0xb0 mm/kasan/common.c:415
>  kasan_kmalloc include/linux/kasan.h:263 [inline]
>  __do_kmalloc_node mm/slub.c:5334 [inline]
>  __kmalloc_noprof+0x322/0x820 mm/slub.c:5359
>  _kmalloc_noprof include/linux/slab.h:992 [inline]
>  _kzalloc_noprof include/linux/slab.h:1309 [inline]
>  __usb_create_hcd+0x5e/0xac0 drivers/usb/core/hcd.c:2566
>  vhci_hcd_probe+0x1a5/0x4e0 drivers/usb/usbip/vhci_hcd.c:1394
>  platform_probe+0x106/0x1d0 drivers/base/platform.c:1439
>  call_driver_probe drivers/base/dd.c:628 [inline]
>  really_probe+0x241/0xa60 drivers/base/dd.c:706
>  __driver_probe_device+0x20e/0x450 drivers/base/dd.c:868
>  driver_probe_device+0x4a/0x140 drivers/base/dd.c:898
>  __device_attach_driver+0x1df/0x320 drivers/base/dd.c:1026
>  bus_for_each_drv+0x159/0x1e0 drivers/base/bus.c:500
>  __device_attach+0x1e4/0x4d0 drivers/base/dd.c:1098
>  device_initial_probe+0xaf/0xd0 drivers/base/dd.c:1153
>  bus_probe_device+0x64/0x160 drivers/base/bus.c:620
>  device_add+0x121d/0x1970 drivers/base/core.c:3772
>  platform_device_add+0x35a/0x800 drivers/base/platform.c:762
>  platform_device_register_full+0x5cf/0x830 drivers/base/platform.c:902
>  vhci_hcd_init+0x1a1/0x2f0 drivers/usb/usbip/vhci_hcd.c:1557
>  do_one_initcall+0x11d/0x700 init/main.c:1347
>  do_initcall_level init/main.c:1409 [inline]
>  do_initcalls init/main.c:1425 [inline]
>  do_basic_setup init/main.c:1445 [inline]
>  kernel_init_freeable+0x6ea/0x7b0 init/main.c:1658
>  kernel_init+0x1f/0x1e0 init/main.c:1548
>  ret_from_fork+0x72b/0xd50 arch/x86/kernel/process.c:158
>  ret_from_fork_asm+0x1a/0x30 arch/x86/entry/entry_64.S:245
>
> Freed by task 5926:
>  kasan_save_stack+0x30/0x50 mm/kasan/common.c:57
>  kasan_save_track+0x14/0x30 mm/kasan/common.c:78
>  kasan_save_free_info+0x3b/0x70 mm/kasan/generic.c:584
>  poison_slab_object mm/kasan/common.c:253 [inline]
>  __kasan_slab_free+0x5f/0x80 mm/kasan/common.c:285
>  kasan_slab_free include/linux/kasan.h:235 [inline]
>  slab_free_hook mm/slub.c:2677 [inline]
>  slab_free mm/slub.c:6377 [inline]
>  kfree+0x22b/0x6c0 mm/slub.c:6692
>  hcd_release drivers/usb/core/hcd.c:2690 [inline]
>  kref_put include/linux/kref.h:65 [inline]
>  usb_put_hcd drivers/usb/core/hcd.c:2704 [inline]
>  usb_put_hcd+0x149/0x1f0 drivers/usb/core/hcd.c:2701
>  vhci_hcd_remove+0xb5/0x1b0 drivers/usb/usbip/vhci_hcd.c:1431
>  platform_remove+0x5f/0x80 drivers/base/platform.c:1456
>  device_remove+0xcb/0x180 drivers/base/dd.c:616
>  __device_release_driver drivers/base/dd.c:1349 [inline]
>  device_release_driver_internal+0x44e/0x620 drivers/base/dd.c:1372
>  unbind_store+0xf8/0x110 drivers/base/bus.c:244
>  drv_attr_store+0x74/0xb0 drivers/base/bus.c:125
>  sysfs_kf_write+0xf2/0x150 fs/sysfs/file.c:145
>  kernfs_fop_write_iter+0x3e0/0x5f0 fs/kernfs/file.c:345
>  new_sync_write fs/read_write.c:595 [inline]
>  vfs_write+0x6ac/0x1050 fs/read_write.c:687
>  ksys_write+0x12a/0x250 fs/read_write.c:739
>  do_syscall_x64 arch/x86/entry/syscall_64.c:63 [inline]
>  do_syscall_64+0x115/0x870 arch/x86/entry/syscall_64.c:94
>  entry_SYSCALL_64_after_hwframe+0x77/0x7f
>
> Last potentially related work creation:
>  kasan_save_stack+0x30/0x50 mm/kasan/common.c:57
>  kasan_record_aux_stack+0xa7/0xc0 mm/kasan/generic.c:556
>  insert_work+0x36/0x230 kernel/workqueue.c:2226
>  __queue_work+0x9bc/0x12b0 kernel/workqueue.c:2401
>  queue_work_on+0x1a9/0x1e0 kernel/workqueue.c:2452
>  queue_work include/linux/workqueue.h:699 [inline]
>  usb_hcd_giveback_urb+0x330/0x4a0 drivers/usb/core/hcd.c:1758
>  usb_rh_urb_dequeue drivers/usb/core/hcd.c:845 [inline]
>  unlink1+0x418/0x510 drivers/usb/core/hcd.c:1580
>  usb_hcd_unlink_urb+0x131/0x210 drivers/usb/core/hcd.c:1617
>  usb_kill_urb drivers/usb/core/urb.c:716 [inline]
>  usb_kill_urb+0x121/0x320 drivers/usb/core/urb.c:703
>  hub_quiesce+0x1e9/0x320 drivers/usb/core/hub.c:1412
>  hub_suspend+0x4ab/0x9e0 drivers/usb/core/hub.c:4008
>  usb_suspend_interface drivers/usb/core/driver.c:1323 [inline]
>  usb_suspend_both+0x288/0x950 drivers/usb/core/driver.c:1446
>  usb_runtime_suspend+0x49/0x120 drivers/usb/core/driver.c:2000
>  __rpm_callback+0xc8/0x620 drivers/base/power/runtime.c:406
>  rpm_callback+0x16a/0x1b0 drivers/base/power/runtime.c:460
>  rpm_suspend+0x2f4/0x11a0 drivers/base/power/runtime.c:698
>  __pm_runtime_suspend+0xba/0x1a0 drivers/base/power/runtime.c:1167
>  pm_runtime_autosuspend include/linux/pm_runtime.h:415 [inline]
>  usb_runtime_idle+0x7e/0x90 drivers/usb/core/driver.c:2037
>  rpm_idle+0x322/0x790 drivers/base/power/runtime.c:550
>  pm_runtime_work+0x120/0x150 drivers/base/power/runtime.c:995
>  process_one_work+0xa23/0x1940 kernel/workqueue.c:3322
>  process_scheduled_works kernel/workqueue.c:3405 [inline]
>  worker_thread+0x5ef/0xe50 kernel/workqueue.c:3486
>  kthread+0x370/0x450 kernel/kthread.c:436
>  ret_from_fork+0x72b/0xd50 arch/x86/kernel/process.c:158
>  ret_from_fork_asm+0x1a/0x30 arch/x86/entry/entry_64.S:245
>
> Second to last potentially related work creation:
>  kasan_save_stack+0x30/0x50 mm/kasan/common.c:57
>  kasan_record_aux_stack+0xa7/0xc0 mm/kasan/generic.c:556
>  insert_work+0x36/0x230 kernel/workqueue.c:2226
>  __queue_work+0x9bc/0x12b0 kernel/workqueue.c:2401
>  queue_work_on+0x1a9/0x1e0 kernel/workqueue.c:2452
>  queue_work include/linux/workqueue.h:699 [inline]
>  usb_hcd_giveback_urb+0x3b8/0x4a0 drivers/usb/core/hcd.c:1760
>  rh_call_control drivers/usb/core/hcd.c:706 [inline]
>  rh_urb_enqueue drivers/usb/core/hcd.c:817 [inline]
>  usb_hcd_submit_urb+0xab7/0x2150 drivers/usb/core/hcd.c:1538
>  usb_submit_urb+0x827/0x19b0 drivers/usb/core/urb.c:586
>  usb_start_wait_urb+0x10e/0x580 drivers/usb/core/message.c:62
>  usb_internal_control_msg drivers/usb/core/message.c:117 [inline]
>  usb_control_msg+0x328/0x4b0 drivers/usb/core/message.c:167
>  set_port_feature drivers/usb/core/hub.c:466 [inline]
>  hub_suspend+0x826/0x9e0 drivers/usb/core/hub.c:3996
>  usb_suspend_interface drivers/usb/core/driver.c:1323 [inline]
>  usb_suspend_both+0x288/0x950 drivers/usb/core/driver.c:1446
>  usb_runtime_suspend+0x49/0x120 drivers/usb/core/driver.c:2000
>  __rpm_callback+0xc8/0x620 drivers/base/power/runtime.c:406
>  rpm_callback+0x16a/0x1b0 drivers/base/power/runtime.c:460
>  rpm_suspend+0x2f4/0x11a0 drivers/base/power/runtime.c:698
>  __pm_runtime_suspend+0xba/0x1a0 drivers/base/power/runtime.c:1167
>  pm_runtime_autosuspend include/linux/pm_runtime.h:415 [inline]
>  usb_runtime_idle+0x7e/0x90 drivers/usb/core/driver.c:2037
>  rpm_idle+0x322/0x790 drivers/base/power/runtime.c:550
>  pm_runtime_work+0x120/0x150 drivers/base/power/runtime.c:995
>  process_one_work+0xa23/0x1940 kernel/workqueue.c:3322
>  process_scheduled_works kernel/workqueue.c:3405 [inline]
>  worker_thread+0x5ef/0xe50 kernel/workqueue.c:3486
>  kthread+0x370/0x450 kernel/kthread.c:436
>  ret_from_fork+0x72b/0xd50 arch/x86/kernel/process.c:158
>  ret_from_fork_asm+0x1a/0x30 arch/x86/entry/entry_64.S:245
>
> The buggy address belongs to the object at ffff88802bf5c000
>  which belongs to the cache kmalloc-8k of size 8192
> The buggy address is located 4656 bytes inside of
>  freed 8192-byte region [ffff88802bf5c000, ffff88802bf5e000)
>
> The buggy address belongs to the physical page:
> page: refcount:0 mapcount:0 mapping:0000000000000000 index:0x0 pfn:0x2bf5=
8
> head: order:3 mapcount:0 entire_mapcount:0 nr_pages_mapped:0 pincount:0
> flags: 0xfff00000000040(head|node=3D0|zone=3D1|lastcpupid=3D0x7ff)
> page_type: f5(slab)
> raw: 00fff00000000040 ffff88801bc43180 dead000000000122 0000000000000000
> raw: 0000000000000000 0000000800020002 00000000f5000000 0000000000000000
> head: 00fff00000000040 ffff88801bc43180 dead000000000122 0000000000000000
> head: 0000000000000000 0000000800020002 00000000f5000000 0000000000000000
> head: 00fff00000000003 fffffffffffffe01 00000000ffffffff 00000000ffffffff
> head: ffffffffffffffff 0000000000000000 00000000ffffffff 0000000000000008
> page dumped because: kasan: bad access detected
> page_owner tracks the page as allocated
> page last allocated via order 3, migratetype Unmovable, gfp_mask 0xd20c0(=
__GFP_IO|__GFP_FS|__GFP_NOWARN|__GFP_NORETRY|__GFP_COMP|__GFP_NOMEMALLOC), =
pid 1, tgid 1 (swapper/0), ts 7941256619, free_ts 7717626992
>  set_page_owner include/linux/page_owner.h:32 [inline]
>  post_alloc_hook+0xfd/0x120 mm/page_alloc.c:1859
>  prep_new_page mm/page_alloc.c:1867 [inline]
>  get_page_from_freelist+0xf48/0x3530 mm/page_alloc.c:3946
>  __alloc_frozen_pages_noprof+0x299/0x2dc0 mm/page_alloc.c:5304
>  alloc_slab_page mm/slub.c:3266 [inline]
>  allocate_slab mm/slub.c:3380 [inline]
>  new_slab+0xa2/0x640 mm/slub.c:3426
>  refill_objects+0xe3/0x410 mm/slub.c:7310
>  refill_sheaf mm/slub.c:2804 [inline]
>  __pcs_replace_empty_main+0x376/0x680 mm/slub.c:4675
>  alloc_from_pcs mm/slub.c:4773 [inline]
>  slab_alloc_node mm/slub.c:4905 [inline]
>  __do_kmalloc_node mm/slub.c:5333 [inline]
>  __kmalloc_noprof+0x66d/0x820 mm/slub.c:5359
>  _kmalloc_noprof include/linux/slab.h:992 [inline]
>  acpi_ut_initialize_buffer+0x144/0x220 drivers/acpi/acpica/utalloc.c:327
>  acpi_rs_create_pci_routing_table+0x135/0xe00 drivers/acpi/acpica/rscreat=
e.c:212
>  acpi_rs_get_prt_method_data+0xc1/0x150 drivers/acpi/acpica/rsutils.c:456
>  acpi_get_irq_routing_table+0xb8/0x140 drivers/acpi/acpica/rsxface.c:137
>  acpi_pci_irq_find_prt_entry+0x179/0xdd0 drivers/acpi/pci_irq.c:215
>  acpi_pci_irq_lookup+0x8e/0x6b0 drivers/acpi/pci_irq.c:299
>  acpi_pci_irq_enable+0x1f5/0x6f0 drivers/acpi/pci_irq.c:414
>  pcibios_enable_device+0xb6/0xe0 arch/x86/pci/common.c:699
>  do_pci_enable_device+0x21f/0x4a0 drivers/pci/pci.c:1998
> page last free pid 1351 tgid 1351 stack trace:
>  reset_page_owner include/linux/page_owner.h:25 [inline]
>  __free_pages_prepare mm/page_alloc.c:1406 [inline]
>  free_pages_prepare+0x586/0xd80 mm/page_alloc.c:1451
>  __free_contig_range_common+0x14f/0x250 mm/page_alloc.c:6897
>  __free_contig_range mm/page_alloc.c:6942 [inline]
>  free_pages_bulk+0x12a/0x200 mm/page_alloc.c:5257
>  vm_area_free_pages+0xad/0x2b0 mm/vmalloc.c:3439
>  vfree mm/vmalloc.c:3488 [inline]
>  vfree+0x107/0x750 mm/vmalloc.c:3462
>  delayed_vfree_work+0x56/0x80 mm/vmalloc.c:3392
>  process_one_work+0xa23/0x1940 kernel/workqueue.c:3322
>  process_scheduled_works kernel/workqueue.c:3405 [inline]
>  worker_thread+0x5ef/0xe50 kernel/workqueue.c:3486
>  kthread+0x370/0x450 kernel/kthread.c:436
>  ret_from_fork+0x72b/0xd50 arch/x86/kernel/process.c:158
>  ret_from_fork_asm+0x1a/0x30 arch/x86/entry/entry_64.S:245
>
> Memory state around the buggy address:
>  ffff88802bf5d100: fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb
>  ffff88802bf5d180: fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb
> >ffff88802bf5d200: fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb
>                                      ^
>  ffff88802bf5d280: fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb
>  ffff88802bf5d300: fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb
> =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
>
>
> ---
> If you want syzbot to run the reproducer, reply with:
> #syz test: git://repo/address.git branch-or-commit-hash
> If you attach or paste a git patch, syzbot will apply it before testing.
