Received: from mail-oi1-f198.google.com (mail-oi1-f198.google.com [209.85.167.198])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3733C372EEF
	for <syzbot@lists.linux.dev>; Fri, 10 Jul 2026 20:52:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.167.198
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783716758; cv=none; b=NCm7qtlwlbbqg7oKy/N+5yrly7H2lxvcaWeSFqwYpVDYnd9f4h2xRuaBsyURitAMCpjkA5GckPXFayO2jBjh4ar/wYtoBuOfnjZTpyoEZLF386XULAlPSxa/9is0U/+J9Ru1GRn0jjk2PEVsP65QQCtwKhhqry3KtvEiSBsK9ec=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783716758; c=relaxed/simple;
	bh=0XNswUa7KKd5ja8BnEVLt+pvlTWr3odXbkaPHYeBBpA=;
	h=MIME-Version:Date:Message-ID:Subject:From:To:Cc:Content-Type; b=CkGaecmocQx0W+tBCFdfStDdDEyviUtqMStvfv4qJogtQW344Fy0wkhq8nTvqmJZvjE7jqfT0iWI3N9z4CXt3/NyB/Aj1kGoZre7H5shU0FvfJ1aQKoFbDaYJ21mqALvT+8lCHrvFT5/iin9dLu/NkNzgVmJjEDY1SPURX+hLK8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com; arc=none smtp.client-ip=209.85.167.198
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com
Received: by mail-oi1-f198.google.com with SMTP id 5614622812f47-49aa4525b82so1461018b6e.1
        for <syzbot@lists.linux.dev>; Fri, 10 Jul 2026 13:52:36 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1783716756; x=1784321556;
        h=content-type:cc:to:from:subject:message-id:date:mime-version
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=IY7CIealzC3VRACKQ960VZ8cyutXKRkSgrRM4mGKHZI=;
        b=dPNg95fTlsiBulpWBh85Ue343g0vwAcmKbkPkJlMaOGdQnqRoIzYc57fGV25WwayVT
         QzM3fkCF+R3Dxa74axMAYU5PGmOUywlLcMSbJz/Re3BJ8J9nUeR6/xHHgBf+NeCz5cck
         igaeCdEOyolcNgvY4NG3lHAhND8uGKbdEuFCz9zYX/jmAlnr8q8VhFBeW0gmxGkHru4U
         J6/P3bckzW/KZdrFHoOoM3CZ15Ii/2SJtk5IH6dzNUJ+sZZ85qBm3XXnZrs4uIAdmgVk
         KSNzjuzl7kDo2tk0/rNtOYAUvN7QKCryllXgSKR06dRD2aiDR6plqbiVO08NifdqBGqu
         KBQw==
X-Gm-Message-State: AOJu0YzHB6LFdD6MtYYw13GBdYFHTnEcd3RFvZBXj+oo7jKJdL0Hownh
	uFytXVJ6+6JJ5fPVxSb5oUD/D4MBlIHLPRGh0jJJ6nSd20kJlvkALZJfxKd+jbCdRsDq+/dzdq4
	3exjMaoCeLD8kzgn/LI/eTHqzDmIzRHJAhBZcDWmTFRaEtwh5CHSijrlG31k=
Precedence: bulk
X-Mailing-List: syzbot@lists.linux.dev
List-Id: <syzbot.lists.linux.dev>
List-Subscribe: <mailto:syzbot+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:syzbot+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Received: by 2002:a05:6808:4483:b0:486:8a11:6e8b with SMTP id
 5614622812f47-4a42ac1c102mr545789b6e.2.1783716756223; Fri, 10 Jul 2026
 13:52:36 -0700 (PDT)
Date: Fri, 10 Jul 2026 13:52:36 -0700
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <6a515b94.574492cf.19a3b.0000.GAE@google.com>
Subject: [moderation/CI] Re: Use generic_file_read_iter() in hugetlbfs
From: syzbot ci <syzbot+cifae32d7ea2365dc0@syzkaller.appspotmail.com>
To: syzkaller-upstream-moderation@googlegroups.com
Cc: syzbot@lists.linux.dev
Content-Type: text/plain; charset="UTF-8"

syzbot ci has tested the following series

[v2] Use generic_file_read_iter() in hugetlbfs
https://lore.kernel.org/all/20260709184740.1286561-1-willy@infradead.org
* [PATCH v2 01/10] mm: Rename folio_contain_hwpoison_page() to folio_has_hwpoison_page()
* [PATCH v2 02/10] hugetlb: Mark some function arguments as const
* [PATCH v2 03/10] filemap: Remove checks in mapping_set_folio_order_range()
* [PATCH v2 04/10] hugetlb: Set mapping folio order
* [PATCH v2 05/10] memory-failure: Remove raw_hwp_list_head()
* [PATCH v2 06/10] memory-failure: Prevent UAF in raw_hwp_page list
* [PATCH v2 07/10] mm: Handle hugetlb correctly in is_page_hwpoison()
* [PATCH v2 08/10] filemap: Add hwpoison handling to filemap_read()
* [PATCH v2 09/10] filemap: Add support for authoritative mappings
* [PATCH v2 10/10] hugetlb: replace hugetlbfs_read_iter() with generic_file_read_iter()

and found the following issue:
BUG: unable to handle kernel NULL pointer dereference in filemap_read_folio

Full report is available here:
https://ci.syzbot.org/series/35ead019-1e81-4d15-8801-8ff11d9c959b

***

BUG: unable to handle kernel NULL pointer dereference in filemap_read_folio

tree:      mm-new
URL:       https://kernel.googlesource.com/pub/scm/linux/kernel/git/akpm/mm.git
base:      dc59e4fea9d83f03bad6bddf3fa2e52491777482
arch:      amd64
compiler:  Debian clang version 22.1.6 (++20260514074242+fc4aad7b5db3-1~exp1~20260514074407.73), Debian LLD 22.1.6
config:    https://ci.syzbot.org/builds/fedb89e4-11ba-4995-927f-a51101829a59/config
syz repro: https://ci.syzbot.org/findings/7a0cb565-4340-4daf-8de2-06f5b1d2af93/syz_repro

BUG: kernel NULL pointer dereference, address: 0000000000000000
#PF: supervisor instruction fetch in kernel mode
#PF: error_code(0x0010) - not-present page
PGD 8000000117bc9067 P4D 8000000117bc9067 PUD 0 
Oops: Oops: 0010 [#1] SMP KASAN PTI
CPU: 0 UID: 0 PID: 5840 Comm: syz.2.19 Not tainted syzkaller #0 PREEMPT(full) 
Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS 1.16.2-debian-1.16.2-1 04/01/2014
RIP: 0010:0x0
Code: Unable to access opcode bytes at 0xffffffffffffffd6.
RSP: 0018:ffffc900035eebf8 EFLAGS: 00010293
RAX: ffffffff82063559 RBX: 1ffff920006bdd84 RCX: ffff88810ba18000
RDX: 0000000000000000 RSI: ffffea0000948000 RDI: ffff88810139d200
RBP: ffffc900035eecb0 R08: ffffea0000948007 R09: 1ffffd4000129000
R10: dffffc0000000000 R11: 0000000000000000 R12: 0000000000000000
R13: 1ffffd4000129000 R14: ffffea0000948000 R15: 1ffffd4000129001
FS:  00007f2e39ef46c0(0000) GS:ffff88818dc11000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: ffffffffffffffd6 CR3: 000000011578a000 CR4: 00000000000006f0
Call Trace:
 <TASK>
 filemap_read_folio+0x12c/0x3a0 mm/filemap.c:2512
 filemap_create_folio mm/filemap.c:2650 [inline]
 filemap_get_pages+0xe9a/0x21e0 mm/filemap.c:2714
 filemap_read+0x428/0x1700 mm/filemap.c:2841
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
RIP: 0033:0x7f2e38f9ce59
Code: ff c3 66 2e 0f 1f 84 00 00 00 00 00 0f 1f 44 00 00 48 89 f8 48 89 f7 48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 ff ff 73 01 c3 48 c7 c1 e8 ff ff ff f7 d8 64 89 01 48
RSP: 002b:00007f2e39ef4028 EFLAGS: 00000246 ORIG_RAX: 0000000000000009
RAX: ffffffffffffffda RBX: 00007f2e39215fa0 RCX: 00007f2e38f9ce59
RDX: 0000000000000007 RSI: 0000000000003000 RDI: 0000200000000000
RBP: 00007f2e39032e6f R08: ffffffffffffffff R09: 0000000000000000
R10: 0000000000040033 R11: 0000000000000246 R12: 0000000000000000
R13: 00007f2e39216038 R14: 00007f2e39215fa0 R15: 00007ffe3450a298
 </TASK>
Modules linked in:
CR2: 0000000000000000
---[ end trace 0000000000000000 ]---
RIP: 0010:0x0
Code: Unable to access opcode bytes at 0xffffffffffffffd6.
RSP: 0018:ffffc900035eebf8 EFLAGS: 00010293
RAX: ffffffff82063559 RBX: 1ffff920006bdd84 RCX: ffff88810ba18000
RDX: 0000000000000000 RSI: ffffea0000948000 RDI: ffff88810139d200
RBP: ffffc900035eecb0 R08: ffffea0000948007 R09: 1ffffd4000129000
R10: dffffc0000000000 R11: 0000000000000000 R12: 0000000000000000
R13: 1ffffd4000129000 R14: ffffea0000948000 R15: 1ffffd4000129001
FS:  00007f2e39ef46c0(0000) GS:ffff88818dc11000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: ffffffffffffffd6 CR3: 000000011578a000 CR4: 00000000000006f0


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
[akpm@linux-foundation.org christian@brauner.io david@kernel.org jack@suse.cz jane.chu@oracle.com linmiaohe@huawei.com linux-fsdevel@vger.kernel.org linux-mm@kvack.org muchun.song@linux.dev nao.horiguchi@gmail.com osalvador@suse.de willy@infradead.org]

If the report looks fine to you, reply with:
#syz upstream

If the report is a false positive, reply with
#syz invalid

