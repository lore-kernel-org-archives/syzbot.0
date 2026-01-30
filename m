Received: from mail-oa1-f69.google.com (mail-oa1-f69.google.com [209.85.160.69])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2C501314A77
	for <syzbot@lists.linux.dev>; Fri, 30 Jan 2026 08:09:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.160.69
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769760559; cv=none; b=gS3uLMYJsTd6NbTVAgkmSnfEbfEwkr43gZkv2YdQiI6I+DisNHLFMIyqyGK6o5MXdtVLcSrw3Kaol+raWTImn0r3Z8RhgR4EE2MWyyg/wVchyv0c4g47Iw0vaVl3THK79ex2uVbLK2J1gYd9KkvwELykrO7RnjHBIuDlyLtoGqE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769760559; c=relaxed/simple;
	bh=CsinjTnC5DCc0WHL0lfaPjQNWfWlDIywGf7RGx9A+wM=;
	h=MIME-Version:Date:Message-ID:Subject:From:To:Cc:Content-Type; b=ubhztJpYsEZscgCjhkTmWatKOR5cJRqZB9LCQuOqcvCz7i2/pg/pRM2e6NGv5IpoCi5YfqNnwzBRxHCpj8Yi3RbUfllCY3VrA4dZmz71C+elu4sgMDEbMkWlPKjAePMEjNCv5yTAclruXdt2P/7kOI9NHvdHembsSpHD5NrKuRI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com; arc=none smtp.client-ip=209.85.160.69
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com
Received: by mail-oa1-f69.google.com with SMTP id 586e51a60fabf-4081db82088so3285743fac.1
        for <syzbot@lists.linux.dev>; Fri, 30 Jan 2026 00:09:17 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1769760557; x=1770365357;
        h=content-transfer-encoding:cc:to:from:subject:message-id:date
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=KopzGuLKTOejJ4/fngpQHI6q++iM4ygXpVjVWofqVJk=;
        b=GGPyFfmGpLP7YnbJR31azoP0R4h78/mzQiwdGndICnv560cpIkgFw47SQyK2Ip+OZy
         f3oIOiqHT9a2tl1gHwGT+32xonwfRrpNZLg1o+XIB2iYXcTMgFRFbpGhpUXN5H8ojbeG
         STt40m3KELkyYn2G+eEwKdGVfD5hYQNg2Q/6VDa7cxlr4MlOtw5XQRHtOMf5vOqMEMY6
         JAbFlZ7apSmXI0v8dI5G5UtpGd1ve0YWFSg3U3zzmlVukUB0HS04d5ZENtPHR35rDafx
         64+T1GdRAhH4DJle5fx1o1LddRZxiGCAOzQwOOHN6/CB4VJBSLMkKwtDfOPACFQYfibJ
         8Zjg==
X-Gm-Message-State: AOJu0YxjTaKdwVC5aInwEO5S+XYVD+oA2jD9sVDVwvqCpv5FymHufBkB
	SA65J9ED5zG6r/unhZUWGCthfoJjKKArMkp9gS/x8TRvoo3RLgmLJFCki+pj1q+nj4MuwU9V1za
	CI2Vji36Ic18r92fJWBIcVNSPtaS7Sv9/CFXxBPzwsZBWQymptMajcleBQd4=
Precedence: bulk
X-Mailing-List: syzbot@lists.linux.dev
List-Id: <syzbot.lists.linux.dev>
List-Subscribe: <mailto:syzbot+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:syzbot+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Received: by 2002:a4a:ee0d:0:b0:663:40d:48a3 with SMTP id
 006d021491bc7-6630f0044c5mr1064572eaf.8.1769760556933; Fri, 30 Jan 2026
 00:09:16 -0800 (PST)
Date: Fri, 30 Jan 2026 00:09:16 -0800
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <697c672c.a70a0220.9914.002d.GAE@google.com>
Subject: [moderation/CI] Re: Separate compound page from folio
From: syzbot ci <syzbot+ci9837ad5f77b5a250@syzkaller.appspotmail.com>
To: syzkaller-upstream-moderation@googlegroups.com
Cc: syzbot@lists.linux.dev
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

syzbot ci has tested the following series

[v1] Separate compound page from folio
https://lore.kernel.org/all/20260130034818.472804-1-ziy@nvidia.com
* [RFC PATCH 1/5] io_uring: allocate folio in io_mem_alloc_compound() and f=
unction rename
* [RFC PATCH 2/5] mm/huge_memory: use page_rmappable_folio() to convert aft=
er-split folios
* [RFC PATCH 3/5] mm/hugetlb: set large_rmappable on hugetlb and avoid defe=
rred_list handling
* [RFC PATCH 4/5] mm: only use struct page in compound_nr() and compound_or=
der()
* [RFC PATCH 5/5] mm: code separation for compound page and folio

and found the following issue:
WARNING in __folio_large_mapcount_sanity_checks

Full report is available here:
https://ci.syzbot.org/series/f64f0297-d388-4cfa-b3be-f05819d0ce34

***

WARNING in __folio_large_mapcount_sanity_checks

tree:      mm-new
URL:       https://kernel.googlesource.com/pub/scm/linux/kernel/git/akpm/mm=
.git
base:      0241748f8b68fc2bf637f4901b9d7ca660d177ca
arch:      amd64
compiler:  Debian clang version 21.1.8 (++20251221033036+2078da43e25a-1~exp=
1~20251221153213.50), Debian LLD 21.1.8
config:    https://ci.syzbot.org/builds/76dc5ea6-0ff5-410b-8b1f-72e5607a704=
e/config
C repro:   https://ci.syzbot.org/findings/a308f1d6-69e2-4ebc-80a9-b51d9dc02=
851/c_repro
syz repro: https://ci.syzbot.org/findings/a308f1d6-69e2-4ebc-80a9-b51d9dc02=
851/syz_repro

------------[ cut here ]------------
diff > folio_large_nr_pages(folio)
WARNING: ./include/linux/rmap.h:148 at __folio_large_mapcount_sanity_checks=
+0x499/0x6b0 include/linux/rmap.h:148, CPU#1: syz.0.17/5988
Modules linked in:
CPU: 1 UID: 0 PID: 5988 Comm: syz.0.17 Not tainted syzkaller #0 PREEMPT(ful=
l)=20
Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS 1.16.2-debian-1.16=
.2-1 04/01/2014
RIP: 0010:__folio_large_mapcount_sanity_checks+0x499/0x6b0 include/linux/rm=
ap.h:148
Code: 5f 5d e9 4a 4e 64 09 cc e8 84 d8 aa ff 90 0f 0b 90 e9 82 fc ff ff e8 =
76 d8 aa ff 90 0f 0b 90 e9 8f fc ff ff e8 68 d8 aa ff 90 <0f> 0b 90 e9 b8 f=
c ff ff e8 5a d8 aa ff 90 0f 0b 90 e9 f2 fc ff ff
RSP: 0018:ffffc900040e72f8 EFLAGS: 00010293
RAX: ffffffff8217c0f8 RBX: ffffea0006ef5c00 RCX: ffff888105fdba80
RDX: 0000000000000000 RSI: 0000000000000001 RDI: 0000000000000000
RBP: 0000000000000001 R08: ffffea0006ef5c07 R09: 1ffffd4000ddeb80
R10: dffffc0000000000 R11: fffff94000ddeb81 R12: 0000000000000001
R13: 0000000000000000 R14: 1ffffd4000ddeb8f R15: ffffea0006ef5c78
FS:  00005555867b3500(0000) GS:ffff8882a9923000(0000) knlGS:000000000000000=
0
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 00002000000000c0 CR3: 0000000103ab0000 CR4: 00000000000006f0
Call Trace:
 <TASK>
 folio_add_return_large_mapcount include/linux/rmap.h:184 [inline]
 __folio_add_rmap mm/rmap.c:1377 [inline]
 __folio_add_file_rmap mm/rmap.c:1696 [inline]
 folio_add_file_rmap_ptes+0x4c2/0xe60 mm/rmap.c:1722
 insert_page_into_pte_locked+0x5ab/0x910 mm/memory.c:2378
 insert_page+0x186/0x2d0 mm/memory.c:2398
 packet_mmap+0x360/0x530 net/packet/af_packet.c:4622
 vfs_mmap include/linux/fs.h:2053 [inline]
 mmap_file mm/internal.h:167 [inline]
 __mmap_new_file_vma mm/vma.c:2468 [inline]
 __mmap_new_vma mm/vma.c:2532 [inline]
 __mmap_region mm/vma.c:2759 [inline]
 mmap_region+0x18fe/0x2240 mm/vma.c:2837
 do_mmap+0xc39/0x10c0 mm/mmap.c:559
 vm_mmap_pgoff+0x2c9/0x4f0 mm/util.c:581
 ksys_mmap_pgoff+0x51e/0x760 mm/mmap.c:605
 do_syscall_x64 arch/x86/entry/syscall_64.c:63 [inline]
 do_syscall_64+0xe2/0xf80 arch/x86/entry/syscall_64.c:94
 entry_SYSCALL_64_after_hwframe+0x77/0x7f
RIP: 0033:0x7f5d7399acb9
Code: ff c3 66 2e 0f 1f 84 00 00 00 00 00 0f 1f 44 00 00 48 89 f8 48 89 f7 =
48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 ff f=
f 73 01 c3 48 c7 c1 e8 ff ff ff f7 d8 64 89 01 48
RSP: 002b:00007ffe9f3eea78 EFLAGS: 00000246 ORIG_RAX: 0000000000000009
RAX: ffffffffffffffda RBX: 00007f5d73c15fa0 RCX: 00007f5d7399acb9
RDX: 0000000000000002 RSI: 0000000000030000 RDI: 0000200000000000
RBP: 00007f5d73a08bf7 R08: 0000000000000003 R09: 0000000000000000
R10: 0000000000000011 R11: 0000000000000246 R12: 0000000000000000
R13: 00007f5d73c15fac R14: 00007f5d73c15fa0 R15: 00007f5d73c15fa0
 </TASK>


***

If these findings have caused you to resend the series or submit a
separate fix, please add the following tag to your commit message:
  Tested-by: syzbot@syzkaller.appspotmail.com

---
This report is generated by a bot. It may contain errors.
syzbot ci engineers can be reached at syzkaller@googlegroups.com.

The email will later be sent to:
[akpm@linux-foundation.org apopple@nvidia.com axboe@kernel.dk balbirs@nvidi=
a.com baohua@kernel.org baolin.wang@linux.alibaba.com david@kernel.org dev.=
jain@arm.com hannes@cmpxchg.org io-uring@vger.kernel.org jackmanb@google.co=
m jgg@nvidia.com lance.yang@linux.dev liam.howlett@oracle.com linux-kernel@=
vger.kernel.org linux-mm@kvack.org lorenzo.stoakes@oracle.com mhocko@suse.c=
om muchun.song@linux.dev npache@redhat.com osalvador@suse.de rppt@kernel.or=
g ryan.roberts@arm.com surenb@google.com vbabka@suse.cz willy@infradead.org=
 ziy@nvidia.com]

If the report looks fine to you, reply with:
#syz upstream

If the report is a false positive, reply with
#syz invalid

