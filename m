Received: from mail-oo1-f69.google.com (mail-oo1-f69.google.com [209.85.161.69])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CCE64332629
	for <syzbot@lists.linux.dev>; Thu, 12 Mar 2026 07:09:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.161.69
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773299385; cv=none; b=n6wE1anlUUrhNS4Nj+KXbLOVKGd45ix5pUa21UXl3H1RR3HVnfFA4oudTYQ7NPYgARC2TJQjB7mcaje1BoDURXM3WGNW1+CAWDqg04f4tz2m6mEJsN7k+jxPt5ycwMUjJUCYWGqF5lKas26mORuZD32TNC/vxevWE1oIIRudMnA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773299385; c=relaxed/simple;
	bh=wvCV3FKCG6cmd0zAQXsHVfTZuOyre6XE5byG/4bstlg=;
	h=MIME-Version:Date:Message-ID:Subject:From:To:Cc:Content-Type; b=oQYTmBFVt8v2O+dX6yQLdFg7ZarR8HG3a9/5UhNozydMDarKDNvsn3AX0Kh5uPlx+kV2tdT4om5Pb8yrp5lezgWG9rmnPQ1rpXyn+VVNjNhu9p0LXLr9RlnAbvbYVMjQ1jXNjjZXmtlgAPhX7chbE+7peBu7lm5P+5TssaoPd9s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com; arc=none smtp.client-ip=209.85.161.69
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com
Received: by mail-oo1-f69.google.com with SMTP id 006d021491bc7-67bb2273d42so13479244eaf.0
        for <syzbot@lists.linux.dev>; Thu, 12 Mar 2026 00:09:43 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1773299383; x=1773904183;
        h=content-transfer-encoding:cc:to:from:subject:message-id:date
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=CprUKK1kj4LDpANzib0yDH8bsdlEZ5d6jG1gyhCPWeE=;
        b=cBIHPm3S1TjD3lQzxFRLGuXmFrAzz7M6+H/wH6EYY8zvLn8nkZfndhoDi0+aOqub5m
         KWPq2MYtmWvg/VF68U2InBEdJ263VfN2MgFhgk4MiE2ENCvwpQnH23dMyH/gxizyBNTi
         UNRhpymiE2xWXUOzxvfv479cHlUqmf+xh7C6ehMChpu6fAVV+IeRIeDevJLbSFvIk2y4
         wYco7Z2XyYDZkTEjKf6B28bl/JKqL2qWv8n4G44cfh72+5oQ54EHiK0frWdJknfWZYYJ
         n4H4AR8XpUMzfow/tKv4a0c2ui3bYWSP8sLKzDOSeDyLZOqkzRdyzKk8OcRDDpkQe4i6
         1aUw==
X-Gm-Message-State: AOJu0Yx2W0RqF74x+tcnbfpXheSwLKoMl027F7iRoFeEuUq6PxoAnwCl
	p7d97i3D/YwY4iMClxja/n+kID9PqRm/F21iuuBEe2ORg2LyJimudIye5YW0xOkXMTWhtSLNWNe
	ooREqLqmt10GKxNhjZ5Mrr2yMV9nwb1zcBxlZhd1YniIPMfqVzrPKgmYTDZQ=
Precedence: bulk
X-Mailing-List: syzbot@lists.linux.dev
List-Id: <syzbot.lists.linux.dev>
List-Subscribe: <mailto:syzbot+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:syzbot+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Received: by 2002:a4a:ec43:0:b0:67b:b96c:272b with SMTP id
 006d021491bc7-67bc8a4e725mr3283616eaf.53.1773299382767; Thu, 12 Mar 2026
 00:09:42 -0700 (PDT)
Date: Thu, 12 Mar 2026 00:09:42 -0700
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <69b266b6.a00a0220.707e5.0010.GAE@google.com>
Subject: [moderation/CI] Re: ACPI: Add support for ACPI RAS2 feature table
From: syzbot ci <syzbot+cib6228ea0c23efd95@syzkaller.appspotmail.com>
To: syzkaller-upstream-moderation@googlegroups.com
Cc: syzbot@lists.linux.dev
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

syzbot ci has tested the following series

[v17] ACPI: Add support for ACPI RAS2 feature table
https://lore.kernel.org/all/20260311155518.1000-1-shiju.jose@huawei.com
* [PATCH v17 1/2] ACPI:RAS2: Add driver for the ACPI RAS2 feature table
* [PATCH v17 2/2] ras: mem: Add ACPI RAS2 memory driver

and found the following issue:
KASAN: slab-use-after-free Read in v4l2_fh_open

Full report is available here:
https://ci.syzbot.org/series/eb46de9e-9391-425e-8ce8-77a4150715c8

***

KASAN: slab-use-after-free Read in v4l2_fh_open

tree:      mm-new
URL:       https://kernel.googlesource.com/pub/scm/linux/kernel/git/akpm/mm=
.git
base:      e2dcf9065536ab4a1b00828ff0d19f7d282dfecc
arch:      amd64
compiler:  Debian clang version 21.1.8 (++20251221033036+2078da43e25a-1~exp=
1~20251221153213.50), Debian LLD 21.1.8
config:    https://ci.syzbot.org/builds/bfcbf64d-3906-4afb-be91-5827a5981b2=
b/config
syz repro: https://ci.syzbot.org/findings/734fec16-7250-4a8d-9c1a-16bde68a0=
8f9/syz_repro

=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
BUG: KASAN: slab-use-after-free in v4l2_fh_init drivers/media/v4l2-core/v4l=
2-fh.c:25 [inline]
BUG: KASAN: slab-use-after-free in v4l2_fh_open+0xac/0x420 drivers/media/v4=
l2-core/v4l2-fh.c:64
Read of size 8 at addr ffff88816a4c4740 by task v4l_id/6469

CPU: 0 UID: 0 PID: 6469 Comm: v4l_id Not tainted syzkaller #0 PREEMPT(full)=
=20
Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS 1.16.2-debian-1.16=
.2-1 04/01/2014
Call Trace:
 <TASK>
 dump_stack_lvl+0xe8/0x150 lib/dump_stack.c:120
 print_address_description mm/kasan/report.c:378 [inline]
 print_report+0xba/0x230 mm/kasan/report.c:482
 kasan_report+0x117/0x150 mm/kasan/report.c:595
 v4l2_fh_init drivers/media/v4l2-core/v4l2-fh.c:25 [inline]
 v4l2_fh_open+0xac/0x420 drivers/media/v4l2-core/v4l2-fh.c:64
 em28xx_v4l2_open+0x157/0x9a0 drivers/media/usb/em28xx/em28xx-video.c:2153
 v4l2_open+0x1bf/0x3a0 drivers/media/v4l2-core/v4l2-dev.c:433
 chrdev_open+0x4cd/0x5e0 fs/char_dev.c:414
 do_dentry_open+0x7ce/0x1420 fs/open.c:962
 vfs_open+0x3b/0x340 fs/open.c:1094
 do_open fs/namei.c:4637 [inline]
 path_openat+0x3486/0x3e20 fs/namei.c:4796
 do_filp_open+0x22d/0x490 fs/namei.c:4823
 do_sys_openat2+0x12f/0x220 fs/open.c:1430
 do_sys_open fs/open.c:1436 [inline]
 __do_sys_openat fs/open.c:1452 [inline]
 __se_sys_openat fs/open.c:1447 [inline]
 __x64_sys_openat+0x138/0x170 fs/open.c:1447
 do_syscall_x64 arch/x86/entry/syscall_64.c:63 [inline]
 do_syscall_64+0xe2/0xf80 arch/x86/entry/syscall_64.c:94
 entry_SYSCALL_64_after_hwframe+0x77/0x7f
RIP: 0033:0x7facd3f169a4
Code: 24 20 48 8d 44 24 30 48 89 44 24 28 64 8b 04 25 18 00 00 00 85 c0 75 =
2c 44 89 e2 48 89 ee bf 9c ff ff ff b8 01 01 00 00 0f 05 <48> 3d 00 f0 ff f=
f 76 60 48 8b 15 55 a4 0d 00 f7 d8 64 89 02 48 83
RSP: 002b:00007fff91448b20 EFLAGS: 00000246 ORIG_RAX: 0000000000000101
RAX: ffffffffffffffda RBX: 00007fff91448d38 RCX: 00007facd3f169a4
RDX: 0000000000000000 RSI: 00007fff91449f1b RDI: 00000000ffffff9c
RBP: 00007fff91449f1b R08: 0000000000000000 R09: 0000000000000000
R10: 0000000000000000 R11: 0000000000000246 R12: 0000000000000000
R13: 00007fff91448d50 R14: 000055c4d9189670 R15: 00007facd442da80
 </TASK>

Allocated by task 6051:
 kasan_save_stack mm/kasan/common.c:57 [inline]
 kasan_save_track+0x3e/0x80 mm/kasan/common.c:78
 poison_kmalloc_redzone mm/kasan/common.c:398 [inline]
 __kasan_kmalloc+0x93/0xb0 mm/kasan/common.c:415
 kasan_kmalloc include/linux/kasan.h:263 [inline]
 __kmalloc_cache_noprof+0x3d1/0x6e0 mm/slub.c:5776
 kmalloc_noprof include/linux/slab.h:957 [inline]
 kzalloc_noprof include/linux/slab.h:1094 [inline]
 em28xx_v4l2_init+0x10b/0x2e70 drivers/media/usb/em28xx/em28xx-video.c:2532
 em28xx_init_extension+0x120/0x1c0 drivers/media/usb/em28xx/em28xx-core.c:1=
117
 process_one_work kernel/workqueue.c:3257 [inline]
 process_scheduled_works+0xaec/0x17a0 kernel/workqueue.c:3340
 worker_thread+0xda6/0x1360 kernel/workqueue.c:3421
 kthread+0x726/0x8b0 kernel/kthread.c:463
 ret_from_fork+0x51b/0xa40 arch/x86/kernel/process.c:158
 ret_from_fork_asm+0x1a/0x30 arch/x86/entry/entry_64.S:246

Freed by task 6051:
 kasan_save_stack mm/kasan/common.c:57 [inline]
 kasan_save_track+0x3e/0x80 mm/kasan/common.c:78
 kasan_save_free_info+0x46/0x50 mm/kasan/generic.c:584
 poison_slab_object mm/kasan/common.c:253 [inline]
 __kasan_slab_free+0x5c/0x80 mm/kasan/common.c:285
 kasan_slab_free include/linux/kasan.h:235 [inline]
 slab_free_hook mm/slub.c:2540 [inline]
 slab_free mm/slub.c:6670 [inline]
 kfree+0x1be/0x650 mm/slub.c:6878
 em28xx_free_v4l2 drivers/media/usb/em28xx/em28xx-video.c:2118 [inline]
 kref_put include/linux/kref.h:65 [inline]
 em28xx_v4l2_init+0x1683/0x2e70 drivers/media/usb/em28xx/em28xx-video.c:290=
1
 em28xx_init_extension+0x120/0x1c0 drivers/media/usb/em28xx/em28xx-core.c:1=
117
 process_one_work kernel/workqueue.c:3257 [inline]
 process_scheduled_works+0xaec/0x17a0 kernel/workqueue.c:3340
 worker_thread+0xda6/0x1360 kernel/workqueue.c:3421
 kthread+0x726/0x8b0 kernel/kthread.c:463
 ret_from_fork+0x51b/0xa40 arch/x86/kernel/process.c:158
 ret_from_fork_asm+0x1a/0x30 arch/x86/entry/entry_64.S:246

The buggy address belongs to the object at ffff88816a4c4000
 which belongs to the cache kmalloc-8k of size 8192
The buggy address is located 1856 bytes inside of
 freed 8192-byte region [ffff88816a4c4000, ffff88816a4c6000)

The buggy address belongs to the physical page:
page: refcount:0 mapcount:0 mapping:0000000000000000 index:0x0 pfn:0x16a4c0
head: order:3 mapcount:0 entire_mapcount:0 nr_pages_mapped:0 pincount:0
anon flags: 0x57ff00000000040(head|node=3D1|zone=3D2|lastcpupid=3D0x7ff)
page_type: f5(slab)
raw: 057ff00000000040 ffff888100042280 0000000000000000 dead000000000001
raw: 0000000000000000 0000000080020002 00000000f5000000 0000000000000000
head: 057ff00000000040 ffff888100042280 0000000000000000 dead000000000001
head: 0000000000000000 0000000080020002 00000000f5000000 0000000000000000
head: 057ff00000000003 ffffea0005a93001 00000000ffffffff 00000000ffffffff
head: ffffffffffffffff 0000000000000000 00000000ffffffff 0000000000000008
page dumped because: kasan: bad access detected
page_owner tracks the page as allocated
page last allocated via order 3, migratetype Unmovable, gfp_mask 0xd20c0(__=
GFP_IO|__GFP_FS|__GFP_NOWARN|__GFP_NORETRY|__GFP_COMP|__GFP_NOMEMALLOC), pi=
d 5576, tgid 5576 (dhcpcd), ts 38711334781, free_ts 38591924367
 set_page_owner include/linux/page_owner.h:32 [inline]
 post_alloc_hook+0x228/0x280 mm/page_alloc.c:1857
 prep_new_page mm/page_alloc.c:1865 [inline]
 get_page_from_freelist+0x24dc/0x2580 mm/page_alloc.c:3915
 __alloc_frozen_pages_noprof+0x18d/0x380 mm/page_alloc.c:5210
 alloc_pages_mpol+0x232/0x4a0 mm/mempolicy.c:2486
 alloc_slab_page mm/slub.c:3075 [inline]
 allocate_slab+0x86/0x3a0 mm/slub.c:3248
 new_slab mm/slub.c:3302 [inline]
 ___slab_alloc+0xd82/0x1760 mm/slub.c:4656
 __slab_alloc+0x65/0x100 mm/slub.c:4779
 __slab_alloc_node mm/slub.c:4855 [inline]
 slab_alloc_node mm/slub.c:5251 [inline]
 __do_kmalloc_node mm/slub.c:5656 [inline]
 __kmalloc_node_track_caller_noprof+0x5b7/0x7f0 mm/slub.c:5764
 kmalloc_reserve+0x136/0x290 net/core/skbuff.c:608
 __alloc_skb+0x204/0x390 net/core/skbuff.c:690
 alloc_skb include/linux/skbuff.h:1383 [inline]
 nlmsg_new include/net/netlink.h:1055 [inline]
 nl80211_get_wiphy+0x77/0x210 net/wireless/nl80211.c:3445
 genl_family_rcv_msg_doit+0x22a/0x330 net/netlink/genetlink.c:1115
 genl_family_rcv_msg net/netlink/genetlink.c:1195 [inline]
 genl_rcv_msg+0x61c/0x7a0 net/netlink/genetlink.c:1210
 netlink_rcv_skb+0x232/0x4b0 net/netlink/af_netlink.c:2550
 genl_rcv+0x28/0x40 net/netlink/genetlink.c:1219
 netlink_unicast_kernel net/netlink/af_netlink.c:1318 [inline]
 netlink_unicast+0x80f/0x9b0 net/netlink/af_netlink.c:1344
page last free pid 5693 tgid 5693 stack trace:
 reset_page_owner include/linux/page_owner.h:25 [inline]
 free_pages_prepare mm/page_alloc.c:1406 [inline]
 __free_frozen_pages+0xbf8/0xd70 mm/page_alloc.c:2943
 discard_slab mm/slub.c:3346 [inline]
 __put_partials+0x146/0x170 mm/slub.c:3886
 __slab_free+0x294/0x320 mm/slub.c:5952
 qlink_free mm/kasan/quarantine.c:163 [inline]
 qlist_free_all+0x97/0x100 mm/kasan/quarantine.c:179
 kasan_quarantine_reduce+0x148/0x160 mm/kasan/quarantine.c:286
 __kasan_slab_alloc+0x22/0x80 mm/kasan/common.c:350
 kasan_slab_alloc include/linux/kasan.h:253 [inline]
 slab_post_alloc_hook mm/slub.c:4953 [inline]
 slab_alloc_node mm/slub.c:5263 [inline]
 kmem_cache_alloc_noprof+0x370/0x6e0 mm/slub.c:5270
 getname_flags+0xb7/0x540 fs/namei.c:146
 getname include/linux/fs.h:2498 [inline]
 do_sys_openat2+0xca/0x220 fs/open.c:1426
 do_sys_open fs/open.c:1436 [inline]
 __do_sys_openat fs/open.c:1452 [inline]
 __se_sys_openat fs/open.c:1447 [inline]
 __x64_sys_openat+0x138/0x170 fs/open.c:1447
 do_syscall_x64 arch/x86/entry/syscall_64.c:63 [inline]
 do_syscall_64+0xe2/0xf80 arch/x86/entry/syscall_64.c:94
 entry_SYSCALL_64_after_hwframe+0x77/0x7f

Memory state around the buggy address:
 ffff88816a4c4600: fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb
 ffff88816a4c4680: fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb
>ffff88816a4c4700: fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb
                                           ^
 ffff88816a4c4780: fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb
 ffff88816a4c4800: fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb
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

The email will later be sent to:
[akpm@linux-foundation.org bp@alien8.de dave.hansen@linux.intel.com dfergus=
on@amperecomputing.com duenwen@google.com erdemaktas@google.com gthelen@goo=
gle.com james.morse@arm.com jiaqiyan@google.com jon.grimm@amd.com jonathan.=
cameron@huawei.com jthoughton@google.com kangkang.shen@futurewei.com lenb@k=
ernel.org leo.duran@amd.com linux-acpi@vger.kernel.org linux-doc@vger.kerne=
l.org linux-edac@vger.kernel.org linux-mm@kvack.org linuxarm@huawei.com mch=
ehab@kernel.org naoya.horiguchi@nec.com nifan.cxl@gmail.com pgonda@google.c=
om prime.zeng@hisilicon.com rafael@kernel.org rientjes@google.com roberto.s=
assu@huawei.com rppt@kernel.org shiju.jose@huawei.com somasundaram.a@hpe.co=
m tanxiaofei@huawei.com tony.luck@intel.com wanghuiqiang@huawei.com wbs@os.=
amperecomputing.com wschwartz@amperecomputing.com yazen.ghannam@amd.com]

If the report looks fine to you, reply with:
#syz upstream

If the report is a false positive, reply with
#syz invalid

