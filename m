Received: from mail-oi1-f197.google.com (mail-oi1-f197.google.com [209.85.167.197])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 12C0B3DC4B3
	for <syzbot@lists.linux.dev>; Fri, 26 Jun 2026 07:07:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.167.197
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782457632; cv=none; b=Ku7f5Kl2kxl5w5BFC7n7VsNtcYGKlF2NgiJjB640cgaz77J6/PQdVLxvOeN4uNJ9YFgUTpk5ygoV1IXW5XHBUaU3J6wWAk0hctzlSYSeIhhknRbiz3olB1Pxom+igXbvJxtbIBZFIzq9SWruQ4h79UpUTizBeplTT/Rp2/JVVBM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782457632; c=relaxed/simple;
	bh=s7Oy0flxQurzVuJkE5ECZUKp6RyXLfRPi/6Yp6i1xGc=;
	h=MIME-Version:Date:In-Reply-To:Message-ID:Subject:From:To:Cc:
	 Content-Type; b=V1VHhQy+kHNkIQ6speqhbk9e5z/3lK6fKv6RqqEc23B655vLSAO1mTAwrMc+koOL9X81Bouog3Jr+gcE/y1pyMZBDvncG+7NzUr9Vk3bo6GC/PGf7abRmrMFuR06ncYXlKZV9+DKH7P2VEa/nQKXLC1VHiysDCk+F90pmrHEkBY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com; arc=none smtp.client-ip=209.85.167.197
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com
Received: by mail-oi1-f197.google.com with SMTP id 5614622812f47-49226201eb8so518110b6e.1
        for <syzbot@lists.linux.dev>; Fri, 26 Jun 2026 00:07:10 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1782457630; x=1783062430;
        h=cc:to:from:subject:message-id:in-reply-to:date:mime-version
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=czdbdcpVAREOzwNlhmk1Hg/0Gniz9DOq6ItmrF4V55Y=;
        b=ZGT2WRHN2Ey1KjpCAGb08RCbLmIy8KD6gzzoB/kWoQA1kbuF/G4KFkOA5BwQLnPQo+
         +XLfprzC51J6ul1xlJQYmGLXxAdYZl/3rrPP0JUViHSnHuTgnjveAFSTez9QQkeke42D
         UXNrsfiZ5cgPypzclng3TZGGy8xy+cBhR01t9JwlioUzgaXgkLwui5nUCp9ud4+mDPxC
         rSF8LnruyAgfDh3c6LS6DpZA2oCJJEHa+LBv1oUxUra6VeDbGi2JaunUmSwkutL2+Rv9
         Pk3I5rwm5zl4CD+iA9BDT/cLxDlfmPxoQIO7gwuZ417Euo7SpZl4GG4eFm3RIKdg2c1R
         M5+g==
X-Gm-Message-State: AOJu0Yz6GxF8br8mByq0Rq0eLuM+CaYOYqiBLC/iEntkoQtUONlGTiMx
	kg60hgVUC3+z9yqOtirX0MiL3gJYq18YS9fFaMQasR1dApJRZCSyMgZusQz11uDvsjXUYc08Y6c
	3rnWZwGykwyvjH49maYqy8JHP/IF9Vn8DcHM2GDNkCtBvAmvf7chZmwE86bE=
Precedence: bulk
X-Mailing-List: syzbot@lists.linux.dev
List-Id: <syzbot.lists.linux.dev>
List-Subscribe: <mailto:syzbot+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:syzbot+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Received: by 2002:a05:6808:1795:b0:493:9328:9b1 with SMTP id
 5614622812f47-493932813dbmr858784b6e.9.1782457630099; Fri, 26 Jun 2026
 00:07:10 -0700 (PDT)
Date: Fri, 26 Jun 2026 00:07:10 -0700
In-Reply-To: <cover.1782422707.git.jbingham@gmail.com>
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <6a3e251e.b42ede87.2ae58d.0001.GAE@google.com>
Subject: [syzbot ci] Re: minix: convert to iomap and add direct I/O
From: syzbot ci <syzbot+ci6eb2640f41075c71@syzkaller.appspotmail.com>
To: brauner@kernel.org, jbingham@gmail.com, jkoolstra@xs4all.nl, 
	linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: syzbot@lists.linux.dev, syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"

syzbot ci has tested the following series

[v1] minix: convert to iomap and add direct I/O
https://lore.kernel.org/all/cover.1782422707.git.jbingham@gmail.com
* [PATCH 1/3] minix: add iomap infrastructure
* [PATCH 2/3] minix: convert address space operations to iomap
* [PATCH 3/3] minix: convert file operations to iomap and add direct I/O

and found the following issues:
* BUG: unable to handle kernel NULL pointer dereference in page_symlink
* WARNING in block_truncate_page
* WARNING in iomap_writeback_folio
* general protection fault in minix_read_folio

Full report is available here:
https://ci.syzbot.org/series/5741f2fe-e35f-460c-b8ae-d02789a43a3a

***

BUG: unable to handle kernel NULL pointer dereference in page_symlink

tree:      torvalds
URL:       https://kernel.googlesource.com/pub/scm/linux/kernel/git/torvalds/linux
base:      ab9de95c9cf952332ab79453b4b5d1bfca8e514f
arch:      amd64
compiler:  Debian clang version 22.1.6 (++20260514074242+fc4aad7b5db3-1~exp1~20260514074407.73), Debian LLD 22.1.6
config:    https://ci.syzbot.org/builds/3e5d737a-bbd5-4a7b-9ad1-4a77f3c42b23/config
syz repro: https://ci.syzbot.org/findings/6370c479-1d88-4203-ab64-5ce5413cc836/syz_repro

BUG: kernel NULL pointer dereference, address: 0000000000000000
#PF: supervisor instruction fetch in kernel mode
#PF: error_code(0x0010) - not-present page
PGD 800000016c223067 P4D 800000016c223067 PUD 0 
Oops: Oops: 0010 [#1] SMP KASAN PTI
CPU: 1 UID: 0 PID: 5877 Comm: syz.1.18 Not tainted syzkaller #0 PREEMPT(full) 
Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS 1.16.2-debian-1.16.2-1 04/01/2014
RIP: 0010:0x0
Code: Unable to access opcode bytes at 0xffffffffffffffd6.
RSP: 0018:ffffc90003a3fc18 EFLAGS: 00010246
RAX: 1ffffffff17ce4d0 RBX: ffffffff8be72680 RCX: 0000000000000008
RDX: 0000000000000000 RSI: ffff8881b4c23820 RDI: 0000000000000000
RBP: ffffc90003a3fd48 R08: ffffc90003a3fcc0 R09: ffffc90003a3fce0
R10: 000000000000000b R11: 0000000000000000 R12: ffff88816cfec218
R13: 1ffffffff17ce4d1 R14: 0000000000000008 R15: dffffc0000000000
FS:  00007fc3dc9f66c0(0000) GS:ffff8882a9227000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: ffffffffffffffd6 CR3: 000000016bc24000 CR4: 00000000000006f0
Call Trace:
 <TASK>
 page_symlink+0x27a/0x440 fs/namei.c:6418
 minix_symlink+0xcc/0x150 fs/minix/namei.c:87
 vfs_symlink+0x18b/0x330 fs/namei.c:5656
 filename_symlinkat+0x1cd/0x410 fs/namei.c:5681
 __do_sys_symlink fs/namei.c:5708 [inline]
 __se_sys_symlink+0x4d/0x2b0 fs/namei.c:5704
 do_syscall_x64 arch/x86/entry/syscall_64.c:63 [inline]
 do_syscall_64+0x174/0x580 arch/x86/entry/syscall_64.c:94
 entry_SYSCALL_64_after_hwframe+0x77/0x7f
RIP: 0033:0x7fc3dd39ce59
Code: ff c3 66 2e 0f 1f 84 00 00 00 00 00 0f 1f 44 00 00 48 89 f8 48 89 f7 48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 ff ff 73 01 c3 48 c7 c1 e8 ff ff ff f7 d8 64 89 01 48
RSP: 002b:00007fc3dc9f6028 EFLAGS: 00000246 ORIG_RAX: 0000000000000058
RAX: ffffffffffffffda RBX: 00007fc3dd615fa0 RCX: 00007fc3dd39ce59
RDX: 0000000000000000 RSI: 00002000000002c0 RDI: 0000200000000100
RBP: 00007fc3dd432e6f R08: 0000000000000000 R09: 0000000000000000
R10: 0000000000000000 R11: 0000000000000246 R12: 0000000000000000
R13: 00007fc3dd616038 R14: 00007fc3dd615fa0 R15: 00007ffc9f986118
 </TASK>
Modules linked in:
CR2: 0000000000000000
---[ end trace 0000000000000000 ]---
RIP: 0010:0x0
Code: Unable to access opcode bytes at 0xffffffffffffffd6.
RSP: 0018:ffffc90003a3fc18 EFLAGS: 00010246
RAX: 1ffffffff17ce4d0 RBX: ffffffff8be72680 RCX: 0000000000000008
RDX: 0000000000000000 RSI: ffff8881b4c23820 RDI: 0000000000000000
RBP: ffffc90003a3fd48 R08: ffffc90003a3fcc0 R09: ffffc90003a3fce0
R10: 000000000000000b R11: 0000000000000000 R12: ffff88816cfec218
R13: 1ffffffff17ce4d1 R14: 0000000000000008 R15: dffffc0000000000
FS:  00007fc3dc9f66c0(0000) GS:ffff8882a9227000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: ffffffffffffffd6 CR3: 000000016bc24000 CR4: 00000000000006f0


***

WARNING in block_truncate_page

tree:      torvalds
URL:       https://kernel.googlesource.com/pub/scm/linux/kernel/git/torvalds/linux
base:      ab9de95c9cf952332ab79453b4b5d1bfca8e514f
arch:      amd64
compiler:  Debian clang version 22.1.6 (++20260514074242+fc4aad7b5db3-1~exp1~20260514074407.73), Debian LLD 22.1.6
config:    https://ci.syzbot.org/builds/3e5d737a-bbd5-4a7b-9ad1-4a77f3c42b23/config
syz repro: https://ci.syzbot.org/findings/a5a50111-30c6-4d8b-876d-586b3b49470f/syz_repro

loop0: detected capacity change from 0 to 64
------------[ cut here ]------------
bh->b_size != blocksize
WARNING: fs/buffer.c:2696 at block_truncate_page+0x70a/0x830 fs/buffer.c:2696, CPU#0: syz.0.17/5866
Modules linked in:
CPU: 0 UID: 0 PID: 5866 Comm: syz.0.17 Not tainted syzkaller #0 PREEMPT(full) 
Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS 1.16.2-debian-1.16.2-1 04/01/2014
RIP: 0010:block_truncate_page+0x70a/0x830 fs/buffer.c:2696
Code: 5c d0 6a ff 89 e8 48 83 c4 40 5b 41 5c 41 5d 41 5e 41 5f 5d e9 c7 05 5b 09 cc e8 41 d0 6a ff e9 51 ff ff ff e8 37 d0 6a ff 90 <0f> 0b 90 e9 76 fc ff ff 44 89 f1 80 e1 07 38 c1 0f 8c 50 f9 ff ff
RSP: 0018:ffffc90003a8f9e8 EFLAGS: 00010293
RAX: ffffffff825b6069 RBX: 0000000000000003 RCX: ffff888113619dc0
RDX: 0000000000000000 RSI: 0000000000000400 RDI: ffffffff93ef90a0
RBP: 0000000000000000 R08: ffff88810b3f1d07 R09: 1ffff1102167e3a0
R10: dffffc0000000000 R11: ffffed102167e3a1 R12: 0000000000000400
R13: ffff88810b3f1d00 R14: ffffffff93ef90a0 R15: 1ffff1102167e3a0
FS:  00007f743592d6c0(0000) GS:ffff88818dc27000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 0000001b33163fff CR3: 0000000021428000 CR4: 00000000000006f0
Call Trace:
 <TASK>
 truncate fs/minix/itree_common.c:314 [inline]
 V2_minix_truncate+0x22d/0x1150 fs/minix/itree_v2.c:73
 minix_setattr+0x14f/0x1a0 fs/minix/file.c:195
 notify_change+0xbba/0xea0 fs/attr.c:556
 do_truncate+0x1c2/0x250 fs/open.c:68
 do_ftruncate+0x4d4/0x580 fs/open.c:194
 ksys_ftruncate fs/open.c:206 [inline]
 __do_sys_ftruncate fs/open.c:211 [inline]
 __se_sys_ftruncate fs/open.c:209 [inline]
 __x64_sys_ftruncate+0x8f/0xe0 fs/open.c:209
 do_syscall_x64 arch/x86/entry/syscall_64.c:63 [inline]
 do_syscall_64+0x174/0x580 arch/x86/entry/syscall_64.c:94
 entry_SYSCALL_64_after_hwframe+0x77/0x7f
RIP: 0033:0x7f743499ce59
Code: ff c3 66 2e 0f 1f 84 00 00 00 00 00 0f 1f 44 00 00 48 89 f8 48 89 f7 48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 ff ff 73 01 c3 48 c7 c1 e8 ff ff ff f7 d8 64 89 01 48
RSP: 002b:00007f743592d028 EFLAGS: 00000246 ORIG_RAX: 000000000000004d
RAX: ffffffffffffffda RBX: 00007f7434c15fa0 RCX: 00007f743499ce59
RDX: 0000000000000000 RSI: 0000000000000003 RDI: 0000000000000004
RBP: 00007f7434a32e6f R08: 0000000000000000 R09: 0000000000000000
R10: 0000000000000000 R11: 0000000000000246 R12: 0000000000000000
R13: 00007f7434c16038 R14: 00007f7434c15fa0 R15: 00007ffd57fa9d88
 </TASK>


***

WARNING in iomap_writeback_folio

tree:      torvalds
URL:       https://kernel.googlesource.com/pub/scm/linux/kernel/git/torvalds/linux
base:      ab9de95c9cf952332ab79453b4b5d1bfca8e514f
arch:      amd64
compiler:  Debian clang version 22.1.6 (++20260514074242+fc4aad7b5db3-1~exp1~20260514074407.73), Debian LLD 22.1.6
config:    https://ci.syzbot.org/builds/3e5d737a-bbd5-4a7b-9ad1-4a77f3c42b23/config
syz repro: https://ci.syzbot.org/findings/faeadbdc-8f36-45bd-b9df-40b83300c68d/syz_repro

------------[ cut here ]------------
atomic_read(&ifs->write_bytes_pending) != 0
WARNING: fs/iomap/buffered-io.c:1828 at iomap_writeback_init fs/iomap/buffered-io.c:1828 [inline], CPU#1: kworker/u10:5/4737
WARNING: fs/iomap/buffered-io.c:1828 at iomap_writeback_folio+0x20f6/0x2790 fs/iomap/buffered-io.c:1974, CPU#1: kworker/u10:5/4737
Modules linked in:
CPU: 1 UID: 0 PID: 4737 Comm: kworker/u10:5 Not tainted syzkaller #0 PREEMPT(full) 
Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS 1.16.2-debian-1.16.2-1 04/01/2014
Workqueue: writeback wb_workfn (flush-7:0)
RIP: 0010:iomap_writeback_init fs/iomap/buffered-io.c:1828 [inline]
RIP: 0010:iomap_writeback_folio+0x20f6/0x2790 fs/iomap/buffered-io.c:1974
Code: e8 4f 96 5b ff 48 8d 3d 28 c1 ce 0d 67 48 0f b9 3a e9 da e3 ff ff e8 39 96 5b ff 90 0f 0b 90 e9 4b e5 ff ff e8 2b 96 5b ff 90 <0f> 0b 90 e9 cc e8 ff ff e8 1d 96 5b ff bf e4 ff ff ff 44 89 ee e8
RSP: 0018:ffffc90003e3ef80 EFLAGS: 00010293
RAX: ffffffff826a9a75 RBX: 00000000ffff8881 RCX: ffff88816b235940
RDX: 0000000000000000 RSI: 00000000ffff8881 RDI: 0000000000000000
RBP: 1ffff11036dd96d9 R08: ffff8881babac587 R09: 1ffff110375758b0
R10: dffffc0000000000 R11: ffffed10375758b1 R12: 1ffff110375758b0
R13: 000000000000000a R14: ffff8881babac584 R15: ffffea0006bc8ac0
FS:  0000000000000000(0000) GS:ffff8882a9227000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 00005555779c0a28 CR3: 0000000113804000 CR4: 00000000000006f0
Call Trace:
 <TASK>
 iomap_writepages+0x167/0x2e0 fs/iomap/buffered-io.c:2051
 minix_writepages+0xef/0x160 fs/minix/inode.c:488
 do_writepages+0x338/0x560 mm/page-writeback.c:2571
 __writeback_single_inode+0x12e/0xf90 fs/fs-writeback.c:1787
 writeback_sb_inodes+0x9de/0x1b00 fs/fs-writeback.c:2079
 wb_writeback+0x41c/0xad0 fs/fs-writeback.c:2264
 wb_do_writeback fs/fs-writeback.c:2432 [inline]
 wb_workfn+0x431/0x10f0 fs/fs-writeback.c:2477
 process_one_work kernel/workqueue.c:3322 [inline]
 process_scheduled_works+0xa8e/0x14e0 kernel/workqueue.c:3405
 worker_thread+0xa47/0xfb0 kernel/workqueue.c:3486
 kthread+0x388/0x470 kernel/kthread.c:436
 ret_from_fork+0x514/0xb70 arch/x86/kernel/process.c:158
 ret_from_fork_asm+0x1a/0x30 arch/x86/entry/entry_64.S:245
 </TASK>


***

general protection fault in minix_read_folio

tree:      torvalds
URL:       https://kernel.googlesource.com/pub/scm/linux/kernel/git/torvalds/linux
base:      ab9de95c9cf952332ab79453b4b5d1bfca8e514f
arch:      amd64
compiler:  Debian clang version 22.1.6 (++20260514074242+fc4aad7b5db3-1~exp1~20260514074407.73), Debian LLD 22.1.6
config:    https://ci.syzbot.org/builds/3e5d737a-bbd5-4a7b-9ad1-4a77f3c42b23/config
syz repro: https://ci.syzbot.org/findings/fe6b7658-93e2-48c4-8808-28a98a8cc13c/syz_repro

WARNING: The mand mount option has been deprecated and
         and is ignored by this kernel. Remove the mand
         option from the mount to silence this warning.
=======================================================
Oops: general protection fault, probably for non-canonical address 0xdffffc000000000c: 0000 [#1] SMP KASAN PTI
KASAN: null-ptr-deref in range [0x0000000000000060-0x0000000000000067]
CPU: 1 UID: 0 PID: 5816 Comm: syz.0.17 Not tainted syzkaller #0 PREEMPT(full) 
Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS 1.16.2-debian-1.16.2-1 04/01/2014
RIP: 0010:minix_read_folio+0x8b/0x1d0 fs/minix/inode.c:493
Code: f1 f1 f8 f8 f8 f8 4b 89 44 25 00 48 b8 f8 f8 f3 f3 f3 f3 f3 f3 4b 89 44 25 08 e8 50 fb 1e ff 49 83 c6 60 4c 89 f0 48 c1 e8 03 <42> 80 3c 20 00 74 08 4c 89 f7 e8 a6 89 8c ff 4d 8b 36 49 83 c6 28
RSP: 0018:ffffc9000398f680 EFLAGS: 00010206
RAX: 000000000000000c RBX: ffffea0006c67fc0 RCX: ffff888102368000
RDX: 0000000000000000 RSI: ffffea0006c67fc0 RDI: 0000000000000000
RBP: ffffc9000398f750 R08: ffffea0006c67fc7 R09: 1ffffd4000d8cff8
R10: dffffc0000000000 R11: ffffffff82a734d0 R12: dffffc0000000000
R13: 1ffff92000731ed0 R14: 0000000000000060 R15: 1ffffd4000d8cff9
FS:  00007f5343f936c0(0000) GS:ffff8882a9227000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 0000001b33763fff CR3: 00000001be366000 CR4: 00000000000006f0
Call Trace:
 <TASK>
 filemap_read_folio+0x12c/0x3a0 mm/filemap.c:2510
 do_read_cache_folio+0x354/0x590 mm/filemap.c:4140
 read_mapping_folio include/linux/pagemap.h:1015 [inline]
 __page_get_link+0x52/0x300 fs/namei.c:6332
 page_get_link+0x27/0xc0 fs/namei.c:6362
 pick_link+0x72f/0xfe0 fs/namei.c:-1
 step_into_slowpath+0x58a/0x820 fs/namei.c:2127
 step_into fs/namei.c:2152 [inline]
 open_last_lookups fs/namei.c:4643 [inline]
 path_openat+0x224e/0x3830 fs/namei.c:4856
 do_file_open+0x23e/0x4a0 fs/namei.c:4888
 do_sys_openat2+0x115/0x200 fs/open.c:1368
 do_sys_open fs/open.c:1374 [inline]
 __do_sys_openat fs/open.c:1390 [inline]
 __se_sys_openat fs/open.c:1385 [inline]
 __x64_sys_openat+0x138/0x170 fs/open.c:1385
 do_syscall_x64 arch/x86/entry/syscall_64.c:63 [inline]
 do_syscall_64+0x174/0x580 arch/x86/entry/syscall_64.c:94
 entry_SYSCALL_64_after_hwframe+0x77/0x7f
RIP: 0033:0x7f534319ce59
Code: ff c3 66 2e 0f 1f 84 00 00 00 00 00 0f 1f 44 00 00 48 89 f8 48 89 f7 48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 ff ff 73 01 c3 48 c7 c1 e8 ff ff ff f7 d8 64 89 01 48
RSP: 002b:00007f5343f93028 EFLAGS: 00000246 ORIG_RAX: 0000000000000101
RAX: ffffffffffffffda RBX: 00007f5343415fa0 RCX: 00007f534319ce59
RDX: 00000000000c4842 RSI: 0000200000000300 RDI: ffffffffffffff9c
RBP: 00007f5343232e6f R08: 0000000000000000 R09: 0000000000000000
R10: 0000000000000000 R11: 0000000000000246 R12: 0000000000000000
R13: 00007f5343416038 R14: 00007f5343415fa0 R15: 00007fff456bcb68
 </TASK>
Modules linked in:
---[ end trace 0000000000000000 ]---
RIP: 0010:minix_read_folio+0x8b/0x1d0 fs/minix/inode.c:493
Code: f1 f1 f8 f8 f8 f8 4b 89 44 25 00 48 b8 f8 f8 f3 f3 f3 f3 f3 f3 4b 89 44 25 08 e8 50 fb 1e ff 49 83 c6 60 4c 89 f0 48 c1 e8 03 <42> 80 3c 20 00 74 08 4c 89 f7 e8 a6 89 8c ff 4d 8b 36 49 83 c6 28
RSP: 0018:ffffc9000398f680 EFLAGS: 00010206
RAX: 000000000000000c RBX: ffffea0006c67fc0 RCX: ffff888102368000
RDX: 0000000000000000 RSI: ffffea0006c67fc0 RDI: 0000000000000000
RBP: ffffc9000398f750 R08: ffffea0006c67fc7 R09: 1ffffd4000d8cff8
R10: dffffc0000000000 R11: ffffffff82a734d0 R12: dffffc0000000000
R13: 1ffff92000731ed0 R14: 0000000000000060 R15: 1ffffd4000d8cff9
FS:  00007f5343f936c0(0000) GS:ffff8882a9227000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 00007f53431ea540 CR3: 00000001be366000 CR4: 00000000000006f0
----------------
Code disassembly (best guess):
   0:	f1                   	int1
   1:	f1                   	int1
   2:	f8                   	clc
   3:	f8                   	clc
   4:	f8                   	clc
   5:	f8                   	clc
   6:	4b 89 44 25 00       	mov    %rax,0x0(%r13,%r12,1)
   b:	48 b8 f8 f8 f3 f3 f3 	movabs $0xf3f3f3f3f3f3f8f8,%rax
  12:	f3 f3 f3
  15:	4b 89 44 25 08       	mov    %rax,0x8(%r13,%r12,1)
  1a:	e8 50 fb 1e ff       	call   0xff1efb6f
  1f:	49 83 c6 60          	add    $0x60,%r14
  23:	4c 89 f0             	mov    %r14,%rax
  26:	48 c1 e8 03          	shr    $0x3,%rax
* 2a:	42 80 3c 20 00       	cmpb   $0x0,(%rax,%r12,1) <-- trapping instruction
  2f:	74 08                	je     0x39
  31:	4c 89 f7             	mov    %r14,%rdi
  34:	e8 a6 89 8c ff       	call   0xff8c89df
  39:	4d 8b 36             	mov    (%r14),%r14
  3c:	49 83 c6 28          	add    $0x28,%r14


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
