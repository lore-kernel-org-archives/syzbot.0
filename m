Received: from mail-oi1-f200.google.com (mail-oi1-f200.google.com [209.85.167.200])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D146A3E2AD8
	for <syzbot@lists.linux.dev>; Fri,  2 Oct 2026 22:11:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.167.200
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790979062; cv=none; b=bdO7Qq9QZW7Jx8MGxxBhFJ7IZMVGCnfICjMMbIoHuxqpF7CoMK65Qm5RpVLtw+IFvE1l5129/vH5+4xy4lx1ffeFjTAfe5N8QRSW5HY1KEsimEaiDM42RMGEq2Neo+GbEeE+NBfAxq7Bq4W+ROLcuQTfwhjqoxqLW39iXWxw/BY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790979062; c=relaxed/simple;
	bh=KZtIelnNhIIoHDcCG3Q+3deiaN5DIf6hYK+4t8GiO6k=;
	h=MIME-Version:Date:Message-ID:Subject:From:To:Cc:Content-Type; b=s0zF4lsuG7sWZbwueU8dLgao5INTCLEYxRrzuqDEzMfwPgsc+Rj6ZHGzHvWueYC56SF9iKkRyGqAxZVUlP55JquVU+vrlnAW/QziWAi1urBykbWivpjZaCwdGOpWXqSBL9sljIEOZ75Zl/88Vdp4tbHKg0Auich/9jRvqR9BsEw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com; arc=none smtp.client-ip=209.85.167.200
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com
Received: by mail-oi1-f200.google.com with SMTP id 5614622812f47-4ab260600easo407124b6e.1
        for <syzbot@lists.linux.dev>; Fri, 02 Oct 2026 15:11:00 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1790979059; x=1791583859;
        h=content-transfer-encoding:content-type:cc:to:from:subject
         :message-id:date:mime-version:x-gm-message-state:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=0dQ8ju9tvoMpMlRy+osFwbkxmrVeuw/L+8DldCaDC0w=;
        b=GXkgpWJifqwbqaYjTnfLPYJ8Bwae7SYzLSCtA1k3cEE8STc11MXDtHaQwx9pO8MZoz
         nUeqdegQrq2EB08nBD1T9R1CMHzDGc92sLxavCi616xdqWkEcIb4Ttq3Iy6kYXh8twdZ
         SUdFhEfhDmRR7jgmRFY57OKFj0SYVUfxE8xNRxUGfczm4+IK6VDYdmMj3YeP6UEH9Ok5
         8AuLdRUKBMb9fPh0Vgchn70VtxvYKgEZlqRleNkfEhsG5NtWhl9cS2+b6YF77NeF8+g4
         2EqWcH7vI7SKXg0pUzoaBOnY9Xwn/IYJrhqV4ifZTeasb2YBpae1MNdvMmSIUVZqju4I
         KHoA==
X-Gm-Message-State: AFuF++mrWip6yfwwMnz40cwZ5v3mTofG0Nt4FIRjwP+DDfocv8chAuqE
	pLnjZ5FpuevthYtLpcnWr8yRhOQpLstRqWnJ68fA2X40LKNgk/v8fgtI88GkzCiOtQkx4918+kX
	dM+LLKJJNzEPYLzA1jpSMVbV0Wvo06+0kJ+rivXr5A+7hyEmtsxGkWqiAeCc=
Precedence: bulk
X-Mailing-List: syzbot@lists.linux.dev
List-Id: <syzbot.lists.linux.dev>
List-Subscribe: <mailto:syzbot+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:syzbot+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Received: by 2002:a05:6808:1a0f:b0:495:ca1b:7865 with SMTP id
 5614622812f47-4f307f07abbmr5633337b6e.11.1790979059675; Fri, 02 Oct 2026
 15:10:59 -0700 (PDT)
Date: Fri, 02 Oct 2026 15:10:59 -0700
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <6ac02bf3.9ad129c8.3858c0.0007.GAE@google.com>
Subject: [moderation/CI] Re: iommupt: Introduce IO page table shrinker
From: syzbot ci <syzbot+cic781094ef11c47b0@syzkaller.appspotmail.com>
To: syzkaller-upstream-moderation@googlegroups.com
Cc: syzbot@lists.linux.dev
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

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
URL:       https://kernel.googlesource.com/pub/scm/linux/kernel/git/axboe/l=
inux.git
base:      72d3fcf802c45d00b300f25b848a93c3a2bd7c7e
arch:      amd64
compiler:  Debian clang version 22.1.8 (++20260613092233+e80beda6e255-1~exp=
1~20260613092250.77), Debian LLD 22.1.8
config:    https://ci.syzbot.org/builds/40ee62cc-4991-4840-96ac-e3f70bd4b70=
b/config
syz repro: https://ci.syzbot.org/findings/96c389a5-7ad8-436e-87ca-df20279f6=
360/syz_repro

iommufd_mock iommufd_mock0: Adding to iommu group 0
BUG: spinlock bad magic on CPU#1, syz.2.19/5813
 lock: mock_blocking_domain+0x70/0xe0 selftest.c:-1, .magic: 00000000, .own=
er: <none>/-1, .owner_cpu: 0
CPU: 1 UID: 0 PID: 5813 Comm: syz.2.19 Not tainted syzkaller #0 PREEMPT(ful=
l)=20
Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS 1.16.2-debian-1.16=
.2-1 04/01/2014
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
Code: ff c3 66 2e 0f 1f 84 00 00 00 00 00 0f 1f 44 00 00 48 89 f8 48 89 f7 =
48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 ff f=
f 73 01 c3 48 c7 c1 e8 ff ff ff f7 d8 64 89 01 48
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
URL:       https://kernel.googlesource.com/pub/scm/linux/kernel/git/axboe/l=
inux.git
base:      72d3fcf802c45d00b300f25b848a93c3a2bd7c7e
arch:      amd64
compiler:  Debian clang version 22.1.8 (++20260613092233+e80beda6e255-1~exp=
1~20260613092250.77), Debian LLD 22.1.8
config:    https://ci.syzbot.org/builds/40ee62cc-4991-4840-96ac-e3f70bd4b70=
b/config
AI triage: https://ci.syzbot.org/findings/a8549c60-4ee9-4842-8c46-b28be84d7=
128/triage_trajectory

iommufd_mock iommufd_mock0: Adding to iommu group 0
INFO: trying to register non-static key.
The code is fine but needs lockdep annotation, or maybe
you didn't initialize this object before use?
turning off the locking correctness validator.
CPU: 1 UID: 0 PID: 5775 Comm: syz.2.31 Not tainted syzkaller #0 PREEMPT(ful=
l)=20
Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS 1.16.2-debian-1.16=
.2-1 04/01/2014
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
Code: ff c3 66 2e 0f 1f 84 00 00 00 00 00 0f 1f 44 00 00 48 89 f8 48 89 f7 =
48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 ff f=
f 73 01 c3 48 c7 c1 e8 ff ff ff f7 d8 64 89 01 48
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
URL:       https://kernel.googlesource.com/pub/scm/linux/kernel/git/axboe/l=
inux.git
base:      72d3fcf802c45d00b300f25b848a93c3a2bd7c7e
arch:      amd64
compiler:  Debian clang version 22.1.8 (++20260613092233+e80beda6e255-1~exp=
1~20260613092250.77), Debian LLD 22.1.8
config:    https://ci.syzbot.org/builds/40ee62cc-4991-4840-96ac-e3f70bd4b70=
b/config
AI triage: https://ci.syzbot.org/findings/2325a060-48cf-48dc-8bc1-c896d4732=
21f/triage_trajectory

INFO: trying to register non-static key.
The code is fine but needs lockdep annotation, or maybe
you didn't initialize this object before use?
turning off the locking correctness validator.
CPU: 0 UID: 0 PID: 6433 Comm: syz.2.305 Not tainted syzkaller #0 PREEMPT(fu=
ll)=20
Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS 1.16.2-debian-1.16=
.2-1 04/01/2014
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
Code: ff c3 66 2e 0f 1f 84 00 00 00 00 00 0f 1f 44 00 00 48 89 f8 48 89 f7 =
48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 ff f=
f 73 01 c3 48 c7 c1 e8 ff ff ff f7 d8 64 89 01 48
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

The email will later be sent to:
[danielmentz@google.com iommu@lists.linux.dev jgg@ziepe.ca joro@8bytes.org =
kevin.tian@intel.com linux-kernel@vger.kernel.org linux-mm@kvack.org logano=
dell@google.com praan@google.com robin.murphy@arm.com skhawaja@google.com s=
mostafa@google.com will@kernel.org]

If the report looks fine to you, reply with:
#syz upstream

If the report is a false positive, reply with
#syz invalid

