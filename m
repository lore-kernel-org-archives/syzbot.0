Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.160.69
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795071571;
	b=nh/CENtFntPvC0YnWqke8SG1/wRTYan0szyLKBwC0uqt+R6dZXkVbWxGfmjtBRt/z1AC
	 nqfrwAO5/Hd7wXeq5sgw1UvRGhNlwCFp8aZ/2IYN8SJMmfDad2iIuSapxhaVB9jTFcji/
	 mBvRt6c9/ImUCGSW4bIHZb/9Chkp0FKqk31WyCjF89BPFH6D3BFKiY49PprsHh4qn+1WN
	 LoTEeS+xgyTcG2GDAHD1Z+YUjFDv2YHZ5JyXdH47GRaFHLdfzQTQe959buAizc3JRFcgo
	 DVcnAyW+zLjo/zVJ3LlYk6iejhnYAtrJQlj5PWyX9VzBpqquAx7hMkKqNG9Uny8ckfw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795071571;
	h=DMARC-Filter:Received:X-Google-DKIM-Signature:X-Gm-Message-State:
	 MIME-Version:X-Received:Date:In-Reply-To:X-Google-Appengine-App-Id:
	 X-Google-Appengine-App-Id-Alias:Message-ID:Subject:From:To:Cc:
	 Content-Type;
	bh=JtxaAGlAPvYqJWwVU+/bBzfLRLBaPLHwCoCpjeQC2h8=;
	b=DLMYlNOgApg6EIXfb1oRjp54BMKYMCHYU1cQJUTrxXSFXGt5a9C4e/7SO/OtAF7OXxw5
	 5d41+yq++sOrx//GECT3N6szXUqc4InNKpHYH2yUBviWR52Ca93nczaW23rbWQyxRr5A4
	 Er3ynaU9ImJa1pzvHgKvd9V340pAJfwH2bfc8AmIcLnm2AfACeg2A8QZAmW05DRw8aqV7
	 DFCQqHhyOYjRVg4HE+7VoXb1J0intMJe0ALJvTpODU82cOPtRa0r4qU+Y5pJkVdGdhP6h
	 Lsbr842pvGy1NFYg4JiIBocC/IPPKelW/KdqK3XtmafDzv8+N5Q99gii54RFZxQGw+Q==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=fail header.from=syzkaller.appspotmail.com;
	spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com;
	arc=none smtp.remote-ip=209.85.160.69
Received: from mail-oa1-f69.google.com (mail-oa1-f69.google.com [209.85.160.69])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E68BE606A325
	for <syzbot@lists.linux.dev>; Thu, 19 Nov 2026 06:59:30 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org E68BE606A325
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com
Received: by mail-oa1-f69.google.com with SMTP id 586e51a60fabf-448d51840c4so1295296fac.1
        for <syzbot@lists.linux.dev>; Wed, 18 Nov 2026 22:59:30 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1795071570; x=1795676370;
        h=content-type:cc:to:from:subject:message-id:in-reply-to:date
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to:content-type;
        bh=JtxaAGlAPvYqJWwVU+/bBzfLRLBaPLHwCoCpjeQC2h8=;
        b=jadzTNH0GlNiId7/oIt//R1Ul2rGFFzQhPmgmYxpOscP4m7x6tgJvNhZvPwNb2nnNO
         prQ4OPCQ7ZgN/o8bZgphF59RwG6UXko27L7urK5CUXaQp7a9A3gO7k+zoIVzBJIhkd3q
         1UljBrtVbNmRC74T2fAfltawu7oguC7KTYzLJXedYrGNud6hz47qtwROzTJv8m++jBOC
         kc7DhA6uhnWnPHuCiuObGq3cyufCqayQ6X4iGESwxqjEi5oZzcEw+Y99TJz6HkQdLgV0
         rW08UDB14aLZPuT8KjyXaRUrGyiqRIPlgYAyBWd4PZJJNHCSVcwQQHvF0q87M8RIwzrQ
         ywiA==
X-Gm-Message-State: APuU4Z/9Y6BTng/rgSyWJjd8ihWdE/9b2kjs7kjVTrcipi+BaMBihNSD
	+XJOTaTHFTt5QFGBOd0erdO1Up8bi4SYvBfPI3Gl4RT7t21uGqdpoR1MBbsSW6OxGlQQHM0EfbG
	KDDPpkRBPxA5KLXfsRnzK3OcmhWbb1OofGpzzVwXyik/wQn23NZa/iKUtuoY=
X-Mailing-List: syzbot@lists.linux.dev
List-Id: <syzbot.lists.linux.dev>
List-Post: <mailto:syzbot@lists.linux.dev>
List-Help: <mailto:syzbot+help@lists.linux.dev>
List-Subscribe: <mailto:syzbot+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:syzbot+unsubscribe@lists.linux.dev>
List-Owner: <mailto:syzbot+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
X-Received: by 2002:a05:6808:50a5:b0:4ec:d580:2440 with SMTP id
 5614622812f47-5773d832984mr6120735b6e.54.1795071569762; Wed, 18 Nov 2026
 22:59:29 -0800 (PST)
Date: Wed, 18 Nov 2026 22:59:29 -0800
In-Reply-To: <20261115024455.1465726-1-zhaonanzhe@xiaomi.com>
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <6afe9e51.6dd4714a.145012.0000.GAE@google.com>
Subject: [syzbot ci] Re: mTHP-friendly compression in zsmalloc and zram based
 on multi-pages
From: syzbot ci <syzbot+ci5f7ebc1818317786@syzkaller.appspotmail.com>
To: akpm@linux-foundation.org, axboe@kernel.dk, 
	bala.seshasayee@linux.intel.com, baohua@kernel.org, chengming.zhou@linux.dev, 
	chrisl@kernel.org, david@kernel.org, hannes@cmpxchg.org, 
	kanchana.p.sridhar@intel.com, kasong@tencent.com, linux-block@vger.kernel.org, 
	linux-kernel@vger.kernel.org, linux-mm@kvack.org, minchan@kernel.org, 
	nphamcs@gmail.com, ryan.roberts@arm.com, senozhatsky@chromium.org, 
	surenb@google.com, terrelln@fb.com, usama.arif@linux.dev, 
	wajdi.k.feghali@intel.com, ying.huang@intel.com, yosry@kernel.org, 
	zhangbo56@xiaomi.com, zhaonanzhe@xiaomi.com, zhengtangquan@oppo.com
Cc: syzbot@lists.linux.dev, syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"

syzbot ci has tested the following series

[v4] mTHP-friendly compression in zsmalloc and zram based on multi-pages
https://lore.kernel.org/all/20261115024455.1465726-1-zhaonanzhe@xiaomi.com
* [RFC PATCH v4 1/4] mm: zsmalloc: support objects compressed based on multiple pages
* [RFC PATCH v4 2/4] zram: support compression at the granularity of multi-pages
* [RFC PATCH v4 3/4] zram: backend_zstd: use multi-page size for zstd parameter setup
* [RFC PATCH v4 4/4] mm: swap: allow direct reclaim for synchronous multi-page swapin

and found the following issues:
* KASAN: vmalloc-out-of-bounds Read in zram_submit_bio
* WARNING in __mod_zone_page_state

Full report is available here:
https://ci.syzbot.org/series/fbfb33eb-ef1c-41ea-aa01-54cbecf7c03c

***

KASAN: vmalloc-out-of-bounds Read in zram_submit_bio

tree:      mm-new
URL:       https://kernel.googlesource.com/pub/scm/linux/kernel/git/akpm/mm.git
base:      40a41254dc1cf8babbd9178a1c87535695255bf1
arch:      amd64
compiler:  Debian clang version 22.1.8 (1~deb13u4), Debian LLD 22.1.8
config:    https://ci.syzbot.org/builds/0826548c-74e7-4858-8bd7-d0550838a241/config
syz repro: https://ci.syzbot.org/findings/50cc4432-dd6a-4eee-9faf-f854d755d423/syz_repro

zram0: detected capacity change from 0 to 8
==================================================================
BUG: KASAN: vmalloc-out-of-bounds in test_slot_flag drivers/block/zram/zram_drv.c:118 [inline]
BUG: KASAN: vmalloc-out-of-bounds in __test_multi_pages_comp drivers/block/zram/zram_drv.c:2836 [inline]
BUG: KASAN: vmalloc-out-of-bounds in test_multi_pages_comp drivers/block/zram/zram_drv.c:2864 [inline]
BUG: KASAN: vmalloc-out-of-bounds in zram_bio_read drivers/block/zram/zram_drv.c:3094 [inline]
BUG: KASAN: vmalloc-out-of-bounds in zram_submit_bio+0x2593/0x2790 drivers/block/zram/zram_drv.c:3164
Read of size 4 at addr ffffc9000343c018 by task syz.1.18/5883

CPU: 1 UID: 0 PID: 5883 Comm: syz.1.18 Not tainted syzkaller #0 PREEMPT(full) 
Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS 1.16.2-debian-1.16.2-1 04/01/2014
Call Trace:
 <TASK>
 dump_stack_lvl+0xe8/0x150 lib/dump_stack.c:120
 print_address_description+0x55/0x1e0 mm/kasan/report.c:378
 print_report+0x58/0x70 mm/kasan/report.c:482
 kasan_report+0x117/0x150 mm/kasan/report.c:595
 test_slot_flag drivers/block/zram/zram_drv.c:118 [inline]
 __test_multi_pages_comp drivers/block/zram/zram_drv.c:2836 [inline]
 test_multi_pages_comp drivers/block/zram/zram_drv.c:2864 [inline]
 zram_bio_read drivers/block/zram/zram_drv.c:3094 [inline]
 zram_submit_bio+0x2593/0x2790 drivers/block/zram/zram_drv.c:3164
 __submit_bio+0x27f/0x340 block/blk-core.c:682
 __submit_bio_noacct block/blk-core.c:725 [inline]
 submit_bio_noacct_nocheck+0x4f2/0xb10 block/blk-core.c:793
 bh_submit fs/buffer.c:1150 [inline]
 __bh_read fs/buffer.c:2944 [inline]
 bh_read_nowait include/linux/buffer_head.h:504 [inline]
 __block_write_begin_int+0x147c/0x1930 fs/buffer.c:2060
 iomap_write_begin+0x1075/0x1530 fs/iomap/buffered-io.c:1105
 iomap_write_iter fs/iomap/buffered-io.c:1233 [inline]
 iomap_file_buffered_write+0x494/0xbb0 fs/iomap/buffered-io.c:1318
 blkdev_buffered_write+0xee/0x160 block/fops.c:739
 blkdev_write_iter+0x4f5/0x820 block/fops.c:829
 new_sync_write fs/read_write.c:595 [inline]
 vfs_write+0x612/0xba0 fs/read_write.c:687
 ksys_pwrite64 fs/read_write.c:794 [inline]
 __do_sys_pwrite64 fs/read_write.c:802 [inline]
 __se_sys_pwrite64 fs/read_write.c:799 [inline]
 __x64_sys_pwrite64+0x210/0x2c0 fs/read_write.c:799
 do_syscall_x64 arch/x86/entry/syscall_64.c:61 [inline]
 do_syscall_64+0x166/0x520 arch/x86/entry/syscall_64.c:84
 entry_SYSCALL_64_after_hwframe+0x77/0x7f
RIP: 0033:0x7f06c93a8fd9
Code: ff c3 66 2e 0f 1f 84 00 00 00 00 00 0f 1f 44 00 00 48 89 f8 48 89 f7 48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 ff ff 73 01 c3 48 c7 c1 e8 ff ff ff f7 d8 64 89 01 48
RSP: 002b:00007f06ca353028 EFLAGS: 00000246 ORIG_RAX: 0000000000000012
RAX: ffffffffffffffda RBX: 00007f06c9625fa0 RCX: 00007f06c93a8fd9
RDX: 0000000000000001 RSI: 00002000000007c0 RDI: 0000000000000004
RBP: 00007f06c9437fed R08: 0000000000000000 R09: 0000000000000000
R10: 00000000000000c4 R11: 0000000000000246 R12: 0000000000000000
R13: 00007f06c9626038 R14: 00007f06c9625fa0 R15: 00007ffe748226b8
 </TASK>

The buggy address belongs to a 1-page vmalloc region starting at 0xffffc9000343c000 allocated at zram_meta_alloc drivers/block/zram/zram_drv.c:2043 [inline]
The buggy address belongs to a 1-page vmalloc region starting at 0xffffc9000343c000 allocated at disksize_store+0x11d/0x430 drivers/block/zram/zram_drv.c:3304
The buggy address belongs to the physical page:
page: refcount:1 mapcount:0 mapping:0000000000000000 index:0xffff888170b2c000 pfn:0x170b2c
flags: 0x57ff00000000000(node=1|zone=2|lastcpupid=0x7ff)
raw: 057ff00000000000 0000000000000000 dead000000000122 0000000000000000
raw: ffff888170b2c000 0000000000000000 00000001ffffffff 0000000000000000
page dumped because: kasan: bad access detected
page_owner tracks the page as allocated
page last allocated via order 0, migratetype Unmovable, gfp_mask 0x2dc2(GFP_KERNEL|__GFP_HIGHMEM|__GFP_ZERO|__GFP_NOWARN), pid 5883, tgid 5882 (syz.1.18), ts 56638265335
 set_page_owner include/linux/page_owner.h:33 [inline]
 post_alloc_hook+0x1f9/0x250 mm/page_alloc.c:1858
 prep_new_page mm/page_alloc.c:1866 [inline]
 get_page_from_freelist+0x2224/0x2290 mm/page_alloc.c:3939
 __alloc_frozen_pages_noprof+0x1fe/0x410 mm/page_alloc.c:5463
 __alloc_pages_noprof+0x10/0x100 mm/page_alloc.c:5498
 alloc_pages_bulk_noprof+0x67a/0x8a0 mm/page_alloc.c:5322
 vm_area_alloc_pages mm/vmalloc.c:3948 [inline]
 __vmalloc_area_node mm/vmalloc.c:4123 [inline]
 __vmalloc_node_range_noprof+0xad1/0x16f0 mm/vmalloc.c:4323
 __vmalloc_node_noprof mm/vmalloc.c:4384 [inline]
 vzalloc_noprof+0xb2/0xe0 mm/vmalloc.c:4462
 zram_meta_alloc drivers/block/zram/zram_drv.c:2043 [inline]
 disksize_store+0x11d/0x430 drivers/block/zram/zram_drv.c:3304
 kernfs_fop_write_iter+0x3a4/0x540 fs/kernfs/file.c:345
 new_sync_write fs/read_write.c:595 [inline]
 vfs_write+0x612/0xba0 fs/read_write.c:687
 ksys_write+0x150/0x270 fs/read_write.c:739
 do_syscall_x64 arch/x86/entry/syscall_64.c:61 [inline]
 do_syscall_64+0x166/0x520 arch/x86/entry/syscall_64.c:84
 entry_SYSCALL_64_after_hwframe+0x77/0x7f
page last free pid 5883 tgid 5882 ts 56638249897 stack trace:
 reset_page_owner include/linux/page_owner.h:26 [inline]
 __free_pages_prepare mm/page_alloc.c:1402 [inline]
 __free_frozen_pages+0xc97/0xd90 mm/page_alloc.c:2956
 __kasan_populate_vmalloc_do mm/kasan/shadow.c:393 [inline]
 __kasan_populate_vmalloc+0x1a8/0x1c0 mm/kasan/shadow.c:424
 kasan_populate_vmalloc include/linux/kasan.h:587 [inline]
 alloc_vmap_area+0xd10/0x1410 mm/vmalloc.c:2190
 __get_vm_area_node+0x24a/0x330 mm/vmalloc.c:3334
 __vmalloc_node_range_noprof+0x36e/0x16f0 mm/vmalloc.c:4283
 __vmalloc_node_noprof mm/vmalloc.c:4384 [inline]
 vzalloc_noprof+0xb2/0xe0 mm/vmalloc.c:4462
 zram_meta_alloc drivers/block/zram/zram_drv.c:2043 [inline]
 disksize_store+0x11d/0x430 drivers/block/zram/zram_drv.c:3304
 kernfs_fop_write_iter+0x3a4/0x540 fs/kernfs/file.c:345
 new_sync_write fs/read_write.c:595 [inline]
 vfs_write+0x612/0xba0 fs/read_write.c:687
 ksys_write+0x150/0x270 fs/read_write.c:739
 do_syscall_x64 arch/x86/entry/syscall_64.c:61 [inline]
 do_syscall_64+0x166/0x520 arch/x86/entry/syscall_64.c:84
 entry_SYSCALL_64_after_hwframe+0x77/0x7f

Memory state around the buggy address:
 ffffc9000343bf00: f8 f8 f8 f8 f8 f8 f8 f8 f8 f8 f8 f8 f8 f8 f8 f8
 ffffc9000343bf80: f8 f8 f8 f8 f8 f8 f8 f8 f8 f8 f8 f8 f8 f8 f8 f8
>ffffc9000343c000: 00 00 f8 f8 f8 f8 f8 f8 f8 f8 f8 f8 f8 f8 f8 f8
                            ^
 ffffc9000343c080: f8 f8 f8 f8 f8 f8 f8 f8 f8 f8 f8 f8 f8 f8 f8 f8
 ffffc9000343c100: f8 f8 f8 f8 f8 f8 f8 f8 f8 f8 f8 f8 f8 f8 f8 f8
==================================================================


***

WARNING in __mod_zone_page_state

tree:      mm-new
URL:       https://kernel.googlesource.com/pub/scm/linux/kernel/git/akpm/mm.git
base:      40a41254dc1cf8babbd9178a1c87535695255bf1
arch:      amd64
compiler:  Debian clang version 22.1.8 (1~deb13u4), Debian LLD 22.1.8
config:    https://ci.syzbot.org/builds/0826548c-74e7-4858-8bd7-d0550838a241/config
syz repro: https://ci.syzbot.org/findings/02951484-1645-42b3-8301-7ebe9e49ee59/syz_repro

------------[ cut here ]------------
IS_ENABLED(CONFIG_PREEMPT_COUNT) && __lockdep_enabled && (preempt_count() == 0 && this_cpu_read(hardirqs_enabled))
WARNING: mm/vmstat.c:361 at __mod_zone_page_state+0xfc/0x140 mm/vmstat.c:361, CPU#0: syz.0.21/5857
Modules linked in:
CPU: 0 UID: 0 PID: 5857 Comm: syz.0.21 Not tainted syzkaller #0 PREEMPT(full) 
Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS 1.16.2-debian-1.16.2-1 04/01/2014
RIP: 0010:__mod_zone_page_state+0xfc/0x140 mm/vmstat.c:361
Code: d3 e8 09 65 43 88 1c 34 5b 41 5c 41 5d 41 5e 41 5f 5d c3 cc cc cc cc cc 48 89 df 4c 89 fe 89 ea e8 59 00 00 00 31 db eb ce 90 <0f> 0b 90 eb 8b 48 c7 c7 00 44 26 90 4c 89 f6 e8 70 4d 10 03 e9 34
RSP: 0018:ffffc90003a2e2e8 EFLAGS: 00010202
RAX: 0000000000000001 RBX: 0000000000000001 RCX: ffff888103b33c00
RDX: 0000000000000001 RSI: 0000000000000009 RDI: ffff88815fffbb00
RBP: 0000000000000009 R08: ffffea000080de07 R09: 1ffffd4000101bc0
R10: dffffc0000000000 R11: fffff94000101bc1 R12: ffffffff94e3d1c0
R13: dffffc0000000000 R14: 0000000000000009 R15: ffff88815fffbb00
FS:  00007fca0f3e26c0(0000) GS:ffff88818be05000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 00007fca0e471a20 CR3: 00000001bab1c000 CR4: 00000000000006f0
Call Trace:
 <TASK>
 __zone_stat_add_folio include/linux/vmstat.h:437 [inline]
 zpdesc_inc_zone_page_state mm/zsmalloc.c:346 [inline]
 alloc_zspage+0x73c/0x1510 mm/zsmalloc.c:1121
 zs_store+0x906/0xd50 mm/zsmalloc.c:1407
 zswap_compress mm/zswap.c:953 [inline]
 zswap_store_page mm/zswap.c:1542 [inline]
 zswap_store+0x12aa/0x2230 mm/zswap.c:1657
 swap_writeout+0x9bc/0x1700 mm/page_io.c:248
 pageout mm/vmscan.c:619 [inline]
 shrink_folio_list+0x3135/0x4e90 mm/vmscan.c:1392
 reclaim_folio_list+0x141/0x4a0 mm/vmscan.c:2176
 reclaim_pages+0x452/0x530 mm/vmscan.c:2213
 madvise_cold_or_pageout_pte_range+0x1b7e/0x2390 mm/madvise.c:574
 walk_pmd_range mm/pagewalk.c:147 [inline]
 walk_pud_range mm/pagewalk.c:237 [inline]
 walk_p4d_range mm/pagewalk.c:278 [inline]
 walk_pgd_range+0x102d/0x1dc0 mm/pagewalk.c:319
 __walk_page_range+0x16d/0x720 mm/pagewalk.c:427
 walk_page_range_vma_unsafe+0x309/0x410 mm/pagewalk.c:735
 madvise_pageout_page_range mm/madvise.c:633 [inline]
 madvise_pageout mm/madvise.c:658 [inline]
 madvise_vma_behavior+0x2db7/0x47f0 mm/madvise.c:1393
 madvise_walk_vmas+0x576/0xb10 mm/madvise.c:1751
 madvise_do_behavior+0x385/0x540 mm/madvise.c:1947
 do_madvise+0x33a/0x3c0 mm/madvise.c:2045
 __do_sys_madvise mm/madvise.c:2054 [inline]
 __se_sys_madvise mm/madvise.c:2052 [inline]
 __x64_sys_madvise+0xa6/0xc0 mm/madvise.c:2052
 do_syscall_x64 arch/x86/entry/syscall_64.c:61 [inline]
 do_syscall_64+0x166/0x520 arch/x86/entry/syscall_64.c:84
 entry_SYSCALL_64_after_hwframe+0x77/0x7f
RIP: 0033:0x7fca0e5a8fd9
Code: ff c3 66 2e 0f 1f 84 00 00 00 00 00 0f 1f 44 00 00 48 89 f8 48 89 f7 48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 ff ff 73 01 c3 48 c7 c1 e8 ff ff ff f7 d8 64 89 01 48
RSP: 002b:00007fca0f3e2028 EFLAGS: 00000246 ORIG_RAX: 000000000000001c
RAX: ffffffffffffffda RBX: 00007fca0e825fa0 RCX: 00007fca0e5a8fd9
RDX: 0000000000000015 RSI: 0000000000600003 RDI: 0000200000000000
RBP: 00007fca0e637fed R08: 0000000000000000 R09: 0000000000000000
R10: 0000000000000000 R11: 0000000000000246 R12: 0000000000000000
R13: 00007fca0e826038 R14: 00007fca0e825fa0 R15: 00007fff2ba215c8
 </TASK>


***

If these findings have caused you to resend the series or submit a
separate fix, please add the following tag to your commit message:
  Tested-by: syzbot@syzkaller.appspotmail.com

---
This report is generated by a bot. It may contain errors.
syzbot ci engineers can be reached at syzkaller@googlegroups.com.
