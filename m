Received: from mail-oi1-f198.google.com (mail-oi1-f198.google.com [209.85.167.198])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6DCE4389E05
	for <syzbot@lists.linux.dev>; Sat,  3 Oct 2026 08:10:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.167.198
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791015034; cv=none; b=OdIjJmYRRpmXb7tZFw2UKms8Xm9vWrgrGaMVF1kvo8DYPfUZGWop/nhjf4+CJFS9EbxuhT0gSbs5Hgt0jXj8ejQ8IdDMO3f32xqaenRV9Gczf97PHbNin/pDgy2NpPF7SkMSq1Zu7Y5HHrJynIvDMIGfogEPgAb/zpe3h/Nc5f8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791015034; c=relaxed/simple;
	bh=1GbWSRG1Tg8HTAPfR8tlfIKArNgsa7BAmPF83bDFBl0=;
	h=MIME-Version:Date:In-Reply-To:Message-ID:Subject:From:To:Cc:
	 Content-Type; b=oMoqITWmjUju8bGURMv2a+Lvp4KBpwog/WUqc3iTIm41FGfu11oXrTL9ZecXKquENvAHbUqf+WxiNJb8XXhjS4YrkwCLN+If+Xan4w/vIvAfseKpS+GJMlgkIgPL9BWmhkMS4vV5kds4NvRXsyDVbbKF0VBUESEn/6EbUOQsdzk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com; arc=none smtp.client-ip=209.85.167.198
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com
Received: by mail-oi1-f198.google.com with SMTP id 5614622812f47-4cc89e86e4dso361961b6e.2
        for <syzbot@lists.linux.dev>; Sat, 03 Oct 2026 01:10:32 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1791015031; x=1791619831;
        h=content-type:cc:to:from:subject:message-id:in-reply-to:date
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to:content-type;
        bh=FU+MzeJUD4jN7QZs0C8lQMkG+5XN6W1QTOf7yTqArOg=;
        b=HjywffBfy5PsYDg7qSohlyI7+cHBFT/tuROKfSL64/FUa4E/PiFPwboBHJVLpy0FuS
         6J2W9U2fOIcNT3VMw5HKsrx5L9xR2ThcgZdy/eaMjm4Wh5berZeNNLHp4Wm9xirp7YQq
         MutSDjjWAAJAl2HSuxXheeV8kepntLAqBRcJvA5Wskel88fLtkD6TCU/e/M1JWFpCQwF
         OfvlQJHWwImCFDXHyZPmITpjV70byyYmz9v4LmWiMIyqlijWh6LfnAKCsdNDm3cZTWcH
         IAfRuRmKZtJ6Hl9Q8UExoDHc4lapPU+Y04nNAcWaQv6ueQrcYun2nisLzPkrcToiWaYJ
         E6Mg==
X-Gm-Message-State: AFuF++kA7UJ5lIWyS4wxL3D29iTtiKlYy/hhIehpFuz0TeWPcJMJ2wYW
	aady3vSOUCgeYSWq4RIDGcNsFm2jQ5Mp0oURU4GR1cYvdQh0XCRj9UVR3NssU5RomawVTRfhyvN
	lcAHdyqYuB51c1wTR4iXYqXh8VHJMiJ82QNJ7CFXeLoMN78mrVFAYuDzgKZs=
Precedence: bulk
X-Mailing-List: syzbot@lists.linux.dev
List-Id: <syzbot.lists.linux.dev>
List-Subscribe: <mailto:syzbot+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:syzbot+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Received: by 2002:a05:6808:2383:b0:4f3:2f34:fc51 with SMTP id
 5614622812f47-4f5267483a0mr4086203b6e.8.1791015031357; Sat, 03 Oct 2026
 01:10:31 -0700 (PDT)
Date: Sat, 03 Oct 2026 01:10:31 -0700
In-Reply-To: <20261001230219.818128-1-praan@google.com>
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <6ac0b877.81dddff3.363068.0005.GAE@google.com>
Subject: [syzbot ci] Re: iommupt: Introduce IO page table shrinker
From: syzbot ci <syzbot+ci374b2971a7526572@syzkaller.appspotmail.com>
To: danielmentz@google.com, iommu@lists.linux.dev, jgg@ziepe.ca, 
	joro@8bytes.org, kevin.tian@intel.com, linux-kernel@vger.kernel.org, 
	linux-mm@kvack.org, loganodell@google.com, praan@google.com, 
	robin.murphy@arm.com, skhawaja@google.com, smostafa@google.com, 
	will@kernel.org
Cc: syzbot@lists.linux.dev, syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"

syzbot ci has tested the following series

[v1] iommupt: Introduce IO page table shrinker
https://lore.kernel.org/all/20261001230219.818128-1-praan@google.com
* [RFC PATCH 1/5] iommu: Add reclaim_list xarray to struct iommu_domain
* [RFC PATCH 2/5] iommupt: Implement refcounting logic for Leaf entries
* [RFC PATCH 3/5] iommupt: Add lockless sever_branch helper
* [RFC PATCH 4/5] iommupt: Introduce lockless page table shrinker
* [RFC PATCH 5/5] iommupt: Return real page count to the shrinker core

and found the following issues:
* BUG: spinlock bad magic in xa_destroy
* INFO: trying to register non-static key in xa_destroy
* INFO: trying to register non-static key in xa_store

Full report is available here:
https://ci.syzbot.org/series/792388cb-7e39-4d83-8008-54d31031a227

***

BUG: spinlock bad magic in xa_destroy

tree:      axboe
URL:       https://kernel.googlesource.com/pub/scm/linux/kernel/git/axboe/linux.git
base:      72d3fcf802c45d00b300f25b848a93c3a2bd7c7e
arch:      amd64
compiler:  Debian clang version 22.1.8 (++20260613092233+e80beda6e255-1~exp1~20260613092250.77), Debian LLD 22.1.8
config:    https://ci.syzbot.org/builds/40ee62cc-4991-4840-96ac-e3f70bd4b70b/config
syz repro: https://ci.syzbot.org/findings/96c389a5-7ad8-436e-87ca-df20279f6360/syz_repro

iommufd_mock iommufd_mock0: Adding to iommu group 0
BUG: spinlock bad magic on CPU#1, syz.2.19/5813
 lock: mock_blocking_domain+0x70/0xe0 selftest.c:-1, .magic: 00000000, .owner: <none>/-1, .owner_cpu: 0
CPU: 1 UID: 0 PID: 5813 Comm: syz.2.19 Not tainted syzkaller #0 PREEMPT(full) 
Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS 1.16.2-debian-1.16.2-1 04/01/2014
Call Trace:
 <TASK>
 dump_stack_lvl+0xe8/0x150 lib/dump_stack.c:120
 spin_bug kernel/locking/spinlock_debug.c:78 [inline]
 debug_spin_lock_before kernel/locking/spinlock_debug.c:86 [inline]
 do_raw_spin_lock+0x1e5/0x2f0 kernel/locking/spinlock_debug.c:115
 __raw_spin_lock_irqsave include/linux/spinlock_api_smp.h:156 [inline]
 _raw_spin_lock_irqsave+0x4c/0x60 kernel/locking/spinlock.c:181
 xa_destroy+0x59/0x2e0 lib/xarray.c:2393
 iommu_domain_free+0x25/0x170 drivers/iommu/iommu.c:2130
 iommu_deinit_device+0x353/0x5d0 drivers/iommu/iommu.c:600
 __iommu_group_remove_device+0x1dd/0x270 drivers/iommu/iommu.c:764
 iommu_release_device drivers/iommu/iommu.c:783 [inline]
 iommu_bus_notifier+0x6d/0x2c0 drivers/iommu/iommu.c:1826
 notifier_call_chain+0x1a5/0x3d0 kernel/notifier.c:85
 blocking_notifier_call_chain+0x6a/0x90 kernel/notifier.c:380
 bus_notify+0x143/0x180 drivers/base/bus.c:1086
 device_del+0x740/0x8f0 drivers/base/core.c:3982
 device_unregister+0x21/0xf0 drivers/base/core.c:4006
 mock_dev_destroy drivers/iommu/iommufd/selftest.c:1042 [inline]
 iommufd_test_mock_domain drivers/iommu/iommufd/selftest.c:1108 [inline]
 iommufd_test+0x3e03/0x6360 drivers/iommu/iommufd/selftest.c:2109
 iommufd_fops_ioctl+0x465/0x600 drivers/iommu/iommufd/main.c:556
 vfs_ioctl fs/ioctl.c:51 [inline]
 __do_sys_ioctl fs/ioctl.c:597 [inline]
 __se_sys_ioctl+0xfc/0x170 fs/ioctl.c:583
 do_syscall_x64 arch/x86/entry/syscall_64.c:61 [inline]
 do_syscall_64+0x166/0x520 arch/x86/entry/syscall_64.c:84
 entry_SYSCALL_64_after_hwframe+0x77/0x7f
RIP: 0033:0x7f9ceff9e159
Code: ff c3 66 2e 0f 1f 84 00 00 00 00 00 0f 1f 44 00 00 48 89 f8 48 89 f7 48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 ff ff 73 01 c3 48 c7 c1 e8 ff ff ff f7 d8 64 89 01 48
RSP: 002b:00007f9cf0ea9028 EFLAGS: 00000246 ORIG_RAX: 0000000000000010
RAX: ffffffffffffffda RBX: 00007f9cf0225fa0 RCX: 00007f9ceff9e159
RDX: 0000200000000100 RSI: 0000000000003ba0 RDI: 0000000000000003
RBP: 00007f9cf003506b R08: 0000000000000000 R09: 0000000000000000
R10: 0000000000000000 R11: 0000000000000246 R12: 0000000000000000
R13: 00007f9cf0226038 R14: 00007f9cf0225fa0 R15: 00007ffe0de56058
 </TASK>


***

INFO: trying to register non-static key in xa_destroy

tree:      axboe
URL:       https://kernel.googlesource.com/pub/scm/linux/kernel/git/axboe/linux.git
base:      72d3fcf802c45d00b300f25b848a93c3a2bd7c7e
arch:      amd64
compiler:  Debian clang version 22.1.8 (++20260613092233+e80beda6e255-1~exp1~20260613092250.77), Debian LLD 22.1.8
config:    https://ci.syzbot.org/builds/40ee62cc-4991-4840-96ac-e3f70bd4b70b/config

iommufd_mock iommufd_mock0: Adding to iommu group 0
INFO: trying to register non-static key.
The code is fine but needs lockdep annotation, or maybe
you didn't initialize this object before use?
turning off the locking correctness validator.
CPU: 1 UID: 0 PID: 5775 Comm: syz.2.31 Not tainted syzkaller #0 PREEMPT(full) 
Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS 1.16.2-debian-1.16.2-1 04/01/2014
Call Trace:
 <TASK>
 dump_stack_lvl+0xe8/0x150
 assign_lock_key+0x133/0x150
 register_lock_class+0xcc/0x2e0
 __lock_acquire+0x10c/0x2de0
 lock_acquire+0x115/0x350
 _raw_spin_lock_irqsave+0x40/0x60
 xa_destroy+0x59/0x2e0
 iommu_domain_free+0x25/0x170
 iommufd_hwpt_nested_destroy+0x4d/0x1a0
 iommufd_object_remove+0x35a/0x4c0
 iommufd_fops_ioctl+0x465/0x600
 __se_sys_ioctl+0xfc/0x170
 do_syscall_64+0x166/0x520
 entry_SYSCALL_64_after_hwframe+0x77/0x7f
RIP: 0033:0x7f593cf9e159
Code: ff c3 66 2e 0f 1f 84 00 00 00 00 00 0f 1f 44 00 00 48 89 f8 48 89 f7 48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 ff ff 73 01 c3 48 c7 c1 e8 ff ff ff f7 d8 64 89 01 48
RSP: 002b:00007f593df41028 EFLAGS: 00000246 ORIG_RAX: 0000000000000010
RAX: ffffffffffffffda RBX: 00007f593d225fa0 RCX: 00007f593cf9e159
RDX: 0000200000000300 RSI: 0000000000003b80 RDI: 0000000000000003
RBP: 00007f593d03506b R08: 0000000000000000 R09: 0000000000000000
R10: 0000000000000000 R11: 0000000000000246 R12: 0000000000000000
R13: 00007f593d226038 R14: 00007f593d225fa0 R15: 00007ffe5c49ab68
 </TASK>


***

INFO: trying to register non-static key in xa_store

tree:      axboe
URL:       https://kernel.googlesource.com/pub/scm/linux/kernel/git/axboe/linux.git
base:      72d3fcf802c45d00b300f25b848a93c3a2bd7c7e
arch:      amd64
compiler:  Debian clang version 22.1.8 (++20260613092233+e80beda6e255-1~exp1~20260613092250.77), Debian LLD 22.1.8
config:    https://ci.syzbot.org/builds/40ee62cc-4991-4840-96ac-e3f70bd4b70b/config

INFO: trying to register non-static key.
The code is fine but needs lockdep annotation, or maybe
you didn't initialize this object before use?
turning off the locking correctness validator.
CPU: 0 UID: 0 PID: 6433 Comm: syz.2.305 Not tainted syzkaller #0 PREEMPT(full) 
Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS 1.16.2-debian-1.16.2-1 04/01/2014
Call Trace:
 <TASK>
 dump_stack_lvl+0xe8/0x150
 assign_lock_key+0x133/0x150
 register_lock_class+0xcc/0x2e0
 __lock_acquire+0x10c/0x2de0
 lock_acquire+0x115/0x350
 _raw_spin_lock+0x2e/0x40
 xa_store+0x23/0x50
 __unmap_range+0x748/0x1190
 __unmap_range+0xbed/0x1190
 __unmap_range+0xbed/0x1190
 amdv1_mock_unmap_range+0x418/0x5e0
 __iommu_unmap+0x138/0x740
 iommu_unmap+0x114/0x200
 iopt_area_unmap_domain_range+0x279/0x310
 __iopt_area_unfill_domain+0x8a2/0xf30
 iopt_table_remove_domain+0x7e8/0xa90
 iommufd_hwpt_paging_destroy+0x1c1/0x2f0
 iommufd_object_remove+0x35a/0x4c0
 iommufd_hw_pagetable_detach+0x564/0x6a0
 iommufd_device_detach+0x1c/0x80
 iommufd_selftest_destroy+0xae/0x130
 iommufd_fops_release+0x186/0x3b0
 __fput+0x418/0xa50
 task_work_run+0x1d9/0x270
 exit_to_user_mode_loop+0x204/0x770
 do_syscall_64+0x328/0x520
 entry_SYSCALL_64_after_hwframe+0x77/0x7f
RIP: 0033:0x7fed0639e159
Code: ff c3 66 2e 0f 1f 84 00 00 00 00 00 0f 1f 44 00 00 48 89 f8 48 89 f7 48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 ff ff 73 01 c3 48 c7 c1 e8 ff ff ff f7 d8 64 89 01 48
RSP: 002b:00007fff16748678 EFLAGS: 00000246 ORIG_RAX: 00000000000001b4
RAX: 0000000000000000 RBX: 00007fff16748760 RCX: 00007fed0639e159
RDX: 0000000000000000 RSI: 000000000000001e RDI: 0000000000000003
RBP: 000000000001312c R08: 0000000000000001 R09: 0000000000000000
R10: 0000001b31420000 R11: 0000000000000246 R12: 00007fff167487a0
R13: 00007fed06625fac R14: 0000000000013174 R15: 00007fed06625fa0
 </TASK>


***

If these findings have caused you to resend the series or submit a
separate fix, please add the following tag to your commit message:
  Tested-by: syzbot@syzkaller.appspotmail.com

---
This report is generated by a bot. It may contain errors.
syzbot ci engineers can be reached at syzkaller@googlegroups.com.

To test a fix for this bug, please reply with `#syz test`
(on a separate line) and attach the patch to the email.

Notes:
- The patch will be applied on top of the tested series (as an
  incremental fix).
- To test a new version of the whole series, please send it directly
  to syzbot@lists.linux.dev.
- Arguments like custom git repos and branches are not supported.
