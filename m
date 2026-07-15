Received: from mail-oi1-f200.google.com (mail-oi1-f200.google.com [209.85.167.200])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9CA2C3C989B
	for <syzbot@lists.linux.dev>; Wed, 15 Jul 2026 08:24:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.167.200
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784103879; cv=none; b=jSXo+ERxd/rcR5I8V2AJTyfRP1tEZvd9NttEglJjxIu5O+Wzx945hf+LSxIO+KRdedwGeYOXve9uKWsnsdSjXBarnDAhWGaQ3FaqwSvcgIruZPszpCMa/UNfkornxpe50VMwZJer0XgOOQ19Nhufe9/jIPvm6535LDTU6B0E8tQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784103879; c=relaxed/simple;
	bh=nLS/4u/ShMz5xBliPXDnDeHoAwk0MtWRsOgWG9jTjGw=;
	h=MIME-Version:Date:Message-ID:Subject:From:To:Cc:Content-Type; b=E9oNqgNQ71heQqZaZU3E+BKSf0vhA285ArRjkFF8mmro9vwGh9qacfmBPLhZrD/tuURyaRkUOIAtkvoeoJxcD9URhwvgrBfQwIi6QTAXQ2QCglwE6R5yEOT2ASHyG3lVqlbLfDYf+/WgZOYhLM7rHmCNL/ahoPheba+THiCtYQ4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com; arc=none smtp.client-ip=209.85.167.200
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com
Received: by mail-oi1-f200.google.com with SMTP id 5614622812f47-495b8b30310so2644519b6e.1
        for <syzbot@lists.linux.dev>; Wed, 15 Jul 2026 01:24:37 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1784103876; x=1784708676;
        h=content-transfer-encoding:content-type:cc:to:from:subject
         :message-id:date:mime-version:x-gm-message-state:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=l9tpJDippKcWJYKr1d8sY6Hyl+fdcYWA0PS47JyRWI0=;
        b=ZjqNbGbnYi7zTIJQ0BBmzgJPXCqlMZGXN+mGia5L1ZFUYk0YM7qRXzqDzIxoyvGauW
         GsYUqkmBkHzDo7EdfVGS3lRtK5mIK1Mb6hSxD1A4LaGmvaCNHA1cSC9KACZdoi2tRfOo
         Yo625uzuoW/aJeAEru08cV+hPYzfcv+kQDWQjv5qGBL0xs2wTzUrZpmSxQdeqwoElTY6
         WcxdhGXp0ccVqJUtFtHGtMX6AaAWjPPSBVFZWUI6V8F5ztBOuDwm55ldExsXNP0d+g3M
         xfNbpZDb3PQavXAPHjZDyEvoWJES0pSh6GIrOr+CpmxHJtRmnGODvKrPyDhrY+r63H5v
         A8hw==
X-Gm-Message-State: AOJu0Yz825VfenBFzve6New8d9l1Wz/dm6dyg9VveAEGyGMC8X+aZU0g
	a8mFlnhBlHmgiQbeHKw2Z7enhYhyWaT4sjDeW8AkjxtI901UFx+O3id7UcrXtXVGWWSuSWP9ZGL
	FgL2VDEuyqFVT0yCx+NAnBAlk6VWL3oqE3htusn+JmtUaq/2lioyXur1w77A=
Precedence: bulk
X-Mailing-List: syzbot@lists.linux.dev
List-Id: <syzbot.lists.linux.dev>
List-Subscribe: <mailto:syzbot+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:syzbot+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Received: by 2002:a05:6808:1509:b0:4a2:df67:d08 with SMTP id
 5614622812f47-4a42b0848e3mr10691320b6e.39.1784103876610; Wed, 15 Jul 2026
 01:24:36 -0700 (PDT)
Date: Wed, 15 Jul 2026 01:24:36 -0700
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <6a5743c4.c90005c7.37d349.0045.GAE@google.com>
Subject: [moderation/CI] Re: Use generic_file_read_iter() in hugetlbfs
From: syzbot ci <syzbot+ci96d179bfbfeee8a0@syzkaller.appspotmail.com>
To: syzkaller-upstream-moderation@googlegroups.com
Cc: syzbot@lists.linux.dev
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

syzbot ci has tested the following series

[v3] Use generic_file_read_iter() in hugetlbfs
https://lore.kernel.org/all/20260714180840.3731244-1-willy@infradead.org
* [PATCH v3 1/9] mm: Rename folio_contain_hwpoison_page() to folio_has_hwpo=
ison_page()
* [PATCH v3 2/9] hugetlb: Mark some function arguments as const
* [PATCH v3 3/9] memory-failure: Track hugetlb poison in a hash table
* [PATCH v3 4/9] mm: Handle hugetlb correctly in is_page_hwpoison()
* [PATCH v3 5/9] filemap: Add hwpoison handling to filemap_read()
* [PATCH v3 6/9] filemap: Remove checks in mapping_set_folio_order_range()
* [PATCH v3 7/9] hugetlb: Set mapping folio order
* [PATCH v3 8/9] filemap: Add support for authoritative mappings
* [PATCH v3 9/9] hugetlb: replace hugetlbfs_read_iter() with generic_file_r=
ead_iter()

and found the following issues:
* BUG: unable to handle kernel NULL pointer dereference in filemap_read_fol=
io
* WARNING in bio_add_page

Full report is available here:
https://ci.syzbot.org/series/1ea7e79d-5597-441f-9992-9436608be7df

***

BUG: unable to handle kernel NULL pointer dereference in filemap_read_folio

tree:      mm-new
URL:       https://kernel.googlesource.com/pub/scm/linux/kernel/git/akpm/mm=
.git
base:      0e35b9b6ec0ffcc5e23cbdec09f5c622ad532b53
arch:      amd64
compiler:  Debian clang version 22.1.6 (++20260514074242+fc4aad7b5db3-1~exp=
1~20260514074407.73), Debian LLD 22.1.6
config:    https://ci.syzbot.org/builds/75e70bfb-8622-4cc5-b17f-aece199fcf0=
c/config
syz repro: https://ci.syzbot.org/findings/739ca35a-a1c0-4131-8e74-405498f14=
c31/syz_repro

BUG: kernel NULL pointer dereference, address: 0000000000000000
#PF: supervisor instruction fetch in kernel mode
#PF: error_code(0x0010) - not-present page
PGD 800000016c1bc067 P4D 800000016c1bc067 PUD 0=20
Oops: Oops: 0010 [#1] SMP KASAN PTI
CPU: 0 UID: 0 PID: 5815 Comm: syz.0.17 Not tainted syzkaller #0 PREEMPT(ful=
l)=20
Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS 1.16.2-debian-1.16=
.2-1 04/01/2014
RIP: 0010:0x0
Code: Unable to access opcode bytes at 0xffffffffffffffd6.
RSP: 0018:ffffc9000297ebf8 EFLAGS: 00010293
RAX: ffffffff82063c39 RBX: 1ffff9200052fd84 RCX: ffff88816cc35940
RDX: 0000000000000000 RSI: ffffea00047cf100 RDI: ffff888112445200
RBP: ffffc9000297ecb0 R08: ffffea00047cf107 R09: 1ffffd40008f9e20
R10: dffffc0000000000 R11: 0000000000000000 R12: 0000000000000000
R13: 1ffffd40008f9e20 R14: ffffea00047cf100 R15: 1ffffd40008f9e21
FS:  00007f7d325fe6c0(0000) GS:ffff88818dc0e000(0000) knlGS:000000000000000=
0
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: ffffffffffffffd6 CR3: 000000011311c000 CR4: 00000000000006f0
Call Trace:
 <TASK>
 filemap_read_folio+0x12c/0x3a0 mm/filemap.c:2512
 filemap_create_folio mm/filemap.c:2650 [inline]
 filemap_get_pages+0xe9a/0x21e0 mm/filemap.c:2714
 filemap_read+0x428/0x1730 mm/filemap.c:2841
 __kernel_read+0x4ca/0x960 fs/read_write.c:532
 integrity_kernel_read+0x89/0xd0 security/integrity/iint.c:28
 ima_calc_file_hash_tfm security/integrity/ima/ima_crypto.c:222 [inline]
 ima_calc_file_hash+0x451/0x890 security/integrity/ima/ima_crypto.c:280
 ima_collect_measurement+0x51b/0xa00 security/integrity/ima/ima_api.c:300
 process_measurement+0x1272/0x1c10 security/integrity/ima/ima_main.c:425
 ima_file_mmap+0x1b0/0x200 security/integrity/ima/ima_main.c:523
 security_mmap_file+0x773/0xa20 security/security.c:2581
 vm_mmap_pgoff+0x134/0x4e0 mm/util.c:575
 ksys_mmap_pgoff+0x57d/0x760 mm/mmap.c:606
 do_syscall_x64 arch/x86/entry/syscall_64.c:63 [inline]
 do_syscall_64+0x174/0x580 arch/x86/entry/syscall_64.c:94
 entry_SYSCALL_64_after_hwframe+0x77/0x7f
RIP: 0033:0x7f7d32f9ce59
Code: ff c3 66 2e 0f 1f 84 00 00 00 00 00 0f 1f 44 00 00 48 89 f8 48 89 f7 =
48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 ff f=
f 73 01 c3 48 c7 c1 e8 ff ff ff f7 d8 64 89 01 48
RSP: 002b:00007f7d325fe028 EFLAGS: 00000246 ORIG_RAX: 0000000000000009
RAX: ffffffffffffffda RBX: 00007f7d33215fa0 RCX: 00007f7d32f9ce59
RDX: 0000000000000007 RSI: 0000000000003000 RDI: 0000200000000000
RBP: 00007f7d33032e6f R08: ffffffffffffffff R09: 0000000000000000
R10: 0000000000040033 R11: 0000000000000246 R12: 0000000000000000
R13: 00007f7d33216038 R14: 00007f7d33215fa0 R15: 00007ffc38aa2f18
 </TASK>
Modules linked in:
CR2: 0000000000000000
---[ end trace 0000000000000000 ]---
RIP: 0010:0x0
Code: Unable to access opcode bytes at 0xffffffffffffffd6.
RSP: 0018:ffffc9000297ebf8 EFLAGS: 00010293
RAX: ffffffff82063c39 RBX: 1ffff9200052fd84 RCX: ffff88816cc35940
RDX: 0000000000000000 RSI: ffffea00047cf100 RDI: ffff888112445200
RBP: ffffc9000297ecb0 R08: ffffea00047cf107 R09: 1ffffd40008f9e20
R10: dffffc0000000000 R11: 0000000000000000 R12: 0000000000000000
R13: 1ffffd40008f9e20 R14: ffffea00047cf100 R15: 1ffffd40008f9e21
FS:  00007f7d325fe6c0(0000) GS:ffff88818dc0e000(0000) knlGS:000000000000000=
0
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: ffffffffffffffd6 CR3: 000000011311c000 CR4: 00000000000006f0


***

WARNING in bio_add_page

tree:      mm-new
URL:       https://kernel.googlesource.com/pub/scm/linux/kernel/git/akpm/mm=
.git
base:      0e35b9b6ec0ffcc5e23cbdec09f5c622ad532b53
arch:      amd64
compiler:  Debian clang version 22.1.6 (++20260514074242+fc4aad7b5db3-1~exp=
1~20260514074407.73), Debian LLD 22.1.6
config:    https://ci.syzbot.org/builds/75e70bfb-8622-4cc5-b17f-aece199fcf0=
c/config
syz repro: https://ci.syzbot.org/findings/a77d3cb3-6a99-45a3-bd83-722c3f7fc=
d2c/syz_repro

------------[ cut here ]------------
len =3D=3D 0
WARNING: block/bio.c:1044 at bio_add_page+0x516/0x700 block/bio.c:1044, CPU=
#0: udevd/5627
Modules linked in:
CPU: 0 UID: 0 PID: 5627 Comm: udevd Not tainted syzkaller #0 PREEMPT(full)=
=20
Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS 1.16.2-debian-1.16=
.2-1 04/01/2014
RIP: 0010:bio_add_page+0x516/0x700 block/bio.c:1044
Code: 31 ed 44 89 e8 48 83 c4 50 5b 41 5c 41 5d 41 5e 41 5f 5d c3 cc cc cc =
cc cc e8 86 b2 30 fd 90 0f 0b 90 eb db e8 7b b2 30 fd 90 <0f> 0b 90 eb d0 e=
8 70 b2 30 fd 90 0f 0b 90 e9 76 fe ff ff e8 62 b2
RSP: 0018:ffffc90004a0f0d8 EFLAGS: 00010293
RAX: ffffffff8495b105 RBX: 0000000000000000 RCX: ffff88816d2c1dc0
RDX: 0000000000000000 RSI: 0000000000000000 RDI: 0000000000000000
RBP: 1ffff11020ef5792 R08: ffff8881077abcff R09: 1ffff11020ef579f
R10: dffffc0000000000 R11: ffffed1020ef57a0 R12: ffff8881077abc94
R13: 0000000000000000 R14: dffffc0000000000 R15: 0000000000000000
FS:  00007f1740f39c80(0000) GS:ffff88818dc0e000(0000) knlGS:000000000000000=
0
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 00005641bf6c0b88 CR3: 00000001bbfcc000 CR4: 00000000000006f0
Call Trace:
 <TASK>
 bio_add_folio+0x64/0x90 block/bio.c:1099
 do_mpage_readpage+0xd8c/0x1b40 fs/mpage.c:294
 mpage_readahead+0x3e7/0x800 fs/mpage.c:370
 read_pages+0x193/0x5a0 mm/readahead.c:174
 page_cache_ra_unbounded+0x754/0x9d0 mm/readahead.c:315
 do_page_cache_ra mm/readahead.c:348 [inline]
 force_page_cache_ra+0x26c/0x2e0 mm/readahead.c:378
 filemap_get_pages+0x560/0x21e0 mm/filemap.c:2708
 filemap_read+0x428/0x1730 mm/filemap.c:2841
 blkdev_read_iter+0x2f1/0x420 block/fops.c:830
 new_sync_read fs/read_write.c:493 [inline]
 vfs_read+0x595/0xa80 fs/read_write.c:574
 ksys_read+0x150/0x270 fs/read_write.c:716
 do_syscall_x64 arch/x86/entry/syscall_64.c:63 [inline]
 do_syscall_64+0x174/0x580 arch/x86/entry/syscall_64.c:94
 entry_SYSCALL_64_after_hwframe+0x77/0x7f
RIP: 0033:0x7f1740b16b6a
Code: 00 3d 00 00 41 00 75 0d 50 48 8d 3d 2d 08 0a 00 e8 ea 7d 01 00 31 c0 =
e9 07 ff ff ff 64 8b 04 25 18 00 00 00 85 c0 75 1b 0f 05 <48> 3d 00 f0 ff f=
f 76 6c 48 8b 15 8f a2 0d 00 f7 d8 64 89 02 48 83
RSP: 002b:00007ffe51f09b58 EFLAGS: 00000246 ORIG_RAX: 0000000000000000
RAX: ffffffffffffffda RBX: 0000000000000000 RCX: 00007f1740b16b6a
RDX: 0000000000000400 RSI: 00005641bf68db38 RDI: 0000000000000009
RBP: 0000000000000400 R08: 00005641bf68db10 R09: 0000000000000008
R10: 0000000000000051 R11: 0000000000000246 R12: 00005641bf68db10
R13: 00005641bf68db28 R14: 00005641bf690128 R15: 00005641bf6900d0
 </TASK>


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
[akpm@linux-foundation.org christian@brauner.io david@kernel.org jack@suse.=
cz jane.chu@oracle.com linmiaohe@huawei.com linux-fsdevel@vger.kernel.org l=
inux-mm@kvack.org muchun.song@linux.dev nao.horiguchi@gmail.com osalvador@s=
use.de usama.arif@linux.dev willy@infradead.org]

If the report looks fine to you, reply with:
#syz upstream

If the report is a false positive, reply with
#syz invalid

