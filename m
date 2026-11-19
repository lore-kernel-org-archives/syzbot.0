Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.167.200
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795058598;
	b=OArcbHA3QfN0DcOLuPm2K0SRNMq1JDge2JiQEWhYKGV57+WBselat2eehjJgsy5oxAbv
	 EgU5InX9UNzrhUiPE8gYbGx1379mF6/KEWAR/+f71rSpVZUXiP0/sY3sA7AStxQ0earUf
	 2ist0JcbdIUWe6H+gIr1CnS5mRyj06ey3HcTbZ1EFpG4JYeMADNK94of8bIgba6yy6ScB
	 S+ooyP0EILd/hOK4+wZzC7EAAkhWB0+N/SZ3s+aXIU0eIXOotiDZSbKZ9HyzBPE0qt/BW
	 fzvwfjx+QLhk9kFfzKEwfgJoAvbP3LrohxlfoLrAGWBW1aDBbrA8u+dJV60iwFE6Z4g==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795058598;
	h=DMARC-Filter:Received:X-Google-DKIM-Signature:X-Gm-Message-State:
	 MIME-Version:X-Received:Date:X-Google-Appengine-App-Id:
	 X-Google-Appengine-App-Id-Alias:Message-ID:Subject:From:To:Cc:
	 Content-Type:Content-Transfer-Encoding;
	bh=E2966irfp/7UZsvF3q3Hg/Iaj6BhG+BPsUzkt9T3LSU=;
	b=aX5ZkM5XXba1CHp+8DsjK9nDNkB5IJtUug7CM+6n7yP1JIgB1g9OXVK54rdHfQiMzMLR
	 aVIVf+5cwPdHQkiyG7N1pF62Sb7C4mu/bLsU+H9ignPqqAt55mYtEc6NpuMCkUEdXzmif
	 jHG/QOMiWjuoPUlX8NnAPajIzHvbB/ePytXHTgIR7RUHC3jpJTa3eA0SGJZxPAeCSWiNE
	 5GDy2PczGKBef+2vAwE91+IoXbajmPGfttHddN8imr4NsslWjBe6SCAWupwizK2r/DxiS
	 4efWtXe6ENManusjrcIL6WxJtj/0xX90pJIvX5fWNRH2U9VBdOipACydsDBTUojPTng==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=fail header.from=syzkaller.appspotmail.com;
	spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com;
	arc=none smtp.remote-ip=209.85.167.200
Received: from mail-oi1-f200.google.com (mail-oi1-f200.google.com [209.85.167.200])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9B0FB606A337
	for <syzbot@lists.linux.dev>; Thu, 19 Nov 2026 03:23:17 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 9B0FB606A337
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com
Received: by mail-oi1-f200.google.com with SMTP id 5614622812f47-4dab94dc3e7so3085686b6e.0
        for <syzbot@lists.linux.dev>; Wed, 18 Nov 2026 19:23:17 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1795058596; x=1795663396;
        h=content-transfer-encoding:content-type:cc:to:from:subject
         :message-id:date:mime-version:x-gm-message-state:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=E2966irfp/7UZsvF3q3Hg/Iaj6BhG+BPsUzkt9T3LSU=;
        b=dlUfxEXTHTyg65aFTN6xpip0TPNoS+DECenlTlKxyorPYoOjOSAz91AWWULf2+WhFh
         ytwcI438nDGE0bEmZeXQOmZhM3PUnKbi349vcP+02gsG1+EqYNKWnn6jZzI+MwnAPylz
         Hj8M8rG1xByZrGLZfoGvvGL1sYBOLCWNFw2cWQj71/NQ7nIYavw/4SYY6TTgH/ZnjdTe
         27JQjhvK0ONDk9L7xuLyDubNdrZtlKH6xgSue2PpqNDSX+LlJ9zjWKjxExAEYF9hK33p
         jG5nBulDCmK9eKyZzpQWCORvFwGeYqAWHDHNJ1Kz6lEc1MBJlIaUUX6ur6nyDlNNAflk
         nYlw==
X-Gm-Message-State: APuU4Z/87IGpIzWSsjO79qtjF93cyMapSeLcL+mh5FUhOWDKqITbgkTy
	CMpUJXtSqvTPjfbq1OzaXPq6odDu7rJQbBz3t3aYknxGPA1v60Mf5IY1mCenaOF0vVt9z8j2nJJ
	5sCBF3GdUWck34gg/ivjP0gHVgRP3yUlRX1yNX5K4X8T79URc/MAH2Sklk78=
X-Mailing-List: syzbot@lists.linux.dev
List-Id: <syzbot.lists.linux.dev>
List-Post: <mailto:syzbot@lists.linux.dev>
List-Help: <mailto:syzbot+help@lists.linux.dev>
List-Subscribe: <mailto:syzbot+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:syzbot+unsubscribe@lists.linux.dev>
List-Owner: <mailto:syzbot+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
X-Received: by 2002:a05:6808:1789:b0:539:df4e:2d25 with SMTP id
 5614622812f47-57740a4b0bdmr5359448b6e.28.1795058596744; Wed, 18 Nov 2026
 19:23:16 -0800 (PST)
Date: Wed, 18 Nov 2026 19:23:16 -0800
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <6afe6ba4.9188ef72.36dd88.0000.GAE@google.com>
Subject: [moderation/CI] Re: mTHP-friendly compression in zsmalloc and zram
 based on multi-pages
From: syzbot ci <syzbot+cia066b9a8a773fc2d@syzkaller.appspotmail.com>
To: syzkaller-upstream-moderation@googlegroups.com
Cc: syzbot@lists.linux.dev
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

syzbot ci has tested the following series

[v4] mTHP-friendly compression in zsmalloc and zram based on multi-pages
https://lore.kernel.org/all/20261115024455.1465726-1-zhaonanzhe@xiaomi.com
* [RFC PATCH v4 1/4] mm: zsmalloc: support objects compressed based on mult=
iple pages
* [RFC PATCH v4 2/4] zram: support compression at the granularity of multi-=
pages
* [RFC PATCH v4 3/4] zram: backend_zstd: use multi-page size for zstd param=
eter setup
* [RFC PATCH v4 4/4] mm: swap: allow direct reclaim for synchronous multi-p=
age swapin

and found the following issues:
* KASAN: vmalloc-out-of-bounds Read in zram_submit_bio
* WARNING in __mod_zone_page_state

Full report is available here:
https://ci.syzbot.org/series/fbfb33eb-ef1c-41ea-aa01-54cbecf7c03c

***

KASAN: vmalloc-out-of-bounds Read in zram_submit_bio

tree:      mm-new
URL:       https://kernel.googlesource.com/pub/scm/linux/kernel/git/akpm/mm=
.git
base:      40a41254dc1cf8babbd9178a1c87535695255bf1
arch:      amd64
compiler:  Debian clang version 22.1.8 (1~deb13u4), Debian LLD 22.1.8
config:    https://ci.syzbot.org/builds/0826548c-74e7-4858-8bd7-d0550838a24=
1/config
syz repro: https://ci.syzbot.org/findings/50cc4432-dd6a-4eee-9faf-f854d755d=
423/syz_repro

zram0: detected capacity change from 0 to 8
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
BUG: KASAN: vmalloc-out-of-bounds in test_slot_flag drivers/block/zram/zram=
_drv.c:118 [inline]
BUG: KASAN: vmalloc-out-of-bounds in __test_multi_pages_comp drivers/block/=
zram/zram_drv.c:2836 [inline]
BUG: KASAN: vmalloc-out-of-bounds in test_multi_pages_comp drivers/block/zr=
am/zram_drv.c:2864 [inline]
BUG: KASAN: vmalloc-out-of-bounds in zram_bio_read drivers/block/zram/zram_=
drv.c:3094 [inline]
BUG: KASAN: vmalloc-out-of-bounds in zram_submit_bio+0x2593/0x2790 drivers/=
block/zram/zram_drv.c:3164
Read of size 4 at addr ffffc9000343c018 by task syz.1.18/5883

CPU: 1 UID: 0 PID: 5883 Comm: syz.1.18 Not tainted syzkaller #0 PREEMPT(ful=
l)=20
Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS 1.16.2-debian-1.16=
.2-1 04/01/2014
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
Code: ff c3 66 2e 0f 1f 84 00 00 00 00 00 0f 1f 44 00 00 48 89 f8 48 89 f7 =
48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 ff f=
f 73 01 c3 48 c7 c1 e8 ff ff ff f7 d8 64 89 01 48
RSP: 002b:00007f06ca353028 EFLAGS: 00000246 ORIG_RAX: 0000000000000012
RAX: ffffffffffffffda RBX: 00007f06c9625fa0 RCX: 00007f06c93a8fd9
RDX: 0000000000000001 RSI: 00002000000007c0 RDI: 0000000000000004
RBP: 00007f06c9437fed R08: 0000000000000000 R09: 0000000000000000
R10: 00000000000000c4 R11: 0000000000000246 R12: 0000000000000000
R13: 00007f06c9626038 R14: 00007f06c9625fa0 R15: 00007ffe748226b8
 </TASK>

The buggy address belongs to a 1-page vmalloc region starting at 0xffffc900=
0343c000 allocated at zram_meta_alloc drivers/block/zram/zram_drv.c:2043 [i=
nline]
The buggy address belongs to a 1-page vmalloc region starting at 0xffffc900=
0343c000 allocated at disksize_store+0x11d/0x430 drivers/block/zram/zram_dr=
v.c:3304
The buggy address belongs to the physical page:
page: refcount:1 mapcount:0 mapping:0000000000000000 index:0xffff888170b2c0=
00 pfn:0x170b2c
flags: 0x57ff00000000000(node=3D1|zone=3D2|lastcpupid=3D0x7ff)
raw: 057ff00000000000 0000000000000000 dead000000000122 0000000000000000
raw: ffff888170b2c000 0000000000000000 00000001ffffffff 0000000000000000
page dumped because: kasan: bad access detected
page_owner tracks the page as allocated
page last allocated via order 0, migratetype Unmovable, gfp_mask 0x2dc2(GFP=
_KERNEL|__GFP_HIGHMEM|__GFP_ZERO|__GFP_NOWARN), pid 5883, tgid 5882 (syz.1.=
18), ts 56638265335
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
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D


***

WARNING in __mod_zone_page_state

tree:      mm-new
URL:       https://kernel.googlesource.com/pub/scm/linux/kernel/git/akpm/mm=
.git
base:      40a41254dc1cf8babbd9178a1c87535695255bf1
arch:      amd64
compiler:  Debian clang version 22.1.8 (1~deb13u4), Debian LLD 22.1.8
config:    https://ci.syzbot.org/builds/0826548c-74e7-4858-8bd7-d0550838a24=
1/config
syz repro: https://ci.syzbot.org/findings/02951484-1645-42b3-8301-7ebe9e49e=
e59/syz_repro

------------[ cut here ]------------
IS_ENABLED(CONFIG_PREEMPT_COUNT) && __lockdep_enabled && (preempt_count() =
=3D=3D 0 && this_cpu_read(hardirqs_enabled))
WARNING: mm/vmstat.c:361 at __mod_zone_page_state+0xfc/0x140 mm/vmstat.c:36=
1, CPU#0: syz.0.21/5857
Modules linked in:
CPU: 0 UID: 0 PID: 5857 Comm: syz.0.21 Not tainted syzkaller #0 PREEMPT(ful=
l)=20
Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS 1.16.2-debian-1.16=
.2-1 04/01/2014
RIP: 0010:__mod_zone_page_state+0xfc/0x140 mm/vmstat.c:361
Code: d3 e8 09 65 43 88 1c 34 5b 41 5c 41 5d 41 5e 41 5f 5d c3 cc cc cc cc =
cc 48 89 df 4c 89 fe 89 ea e8 59 00 00 00 31 db eb ce 90 <0f> 0b 90 eb 8b 4=
8 c7 c7 00 44 26 90 4c 89 f6 e8 70 4d 10 03 e9 34
RSP: 0018:ffffc90003a2e2e8 EFLAGS: 00010202
RAX: 0000000000000001 RBX: 0000000000000001 RCX: ffff888103b33c00
RDX: 0000000000000001 RSI: 0000000000000009 RDI: ffff88815fffbb00
RBP: 0000000000000009 R08: ffffea000080de07 R09: 1ffffd4000101bc0
R10: dffffc0000000000 R11: fffff94000101bc1 R12: ffffffff94e3d1c0
R13: dffffc0000000000 R14: 0000000000000009 R15: ffff88815fffbb00
FS:  00007fca0f3e26c0(0000) GS:ffff88818be05000(0000) knlGS:000000000000000=
0
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
Code: ff c3 66 2e 0f 1f 84 00 00 00 00 00 0f 1f 44 00 00 48 89 f8 48 89 f7 =
48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 ff f=
f 73 01 c3 48 c7 c1 e8 ff ff ff f7 d8 64 89 01 48
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

The email will later be sent to:
[akpm@linux-foundation.org axboe@kernel.dk bala.seshasayee@linux.intel.com =
baohua@kernel.org chengming.zhou@linux.dev chrisl@kernel.org david@kernel.o=
rg hannes@cmpxchg.org kanchana.p.sridhar@intel.com kasong@tencent.com linux=
-block@vger.kernel.org linux-kernel@vger.kernel.org linux-mm@kvack.org minc=
han@kernel.org nphamcs@gmail.com ryan.roberts@arm.com senozhatsky@chromium.=
org surenb@google.com terrelln@fb.com usama.arif@linux.dev wajdi.k.feghali@=
intel.com ying.huang@intel.com yosry@kernel.org zhangbo56@xiaomi.com zhaona=
nzhe@xiaomi.com zhengtangquan@oppo.com]

If the report looks fine to you, reply with:
#syz upstream

If the report is a false positive, reply with
#syz invalid

