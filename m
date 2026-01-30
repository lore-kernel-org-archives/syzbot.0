Received: from mail-oa1-f71.google.com (mail-oa1-f71.google.com [209.85.160.71])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7BDBB315D35
	for <syzbot@lists.linux.dev>; Fri, 30 Jan 2026 08:15:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.160.71
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769760950; cv=none; b=TwJEz1Kf5lR8T7JddilXgqgt8EFdCRnWJvexfWx2+COx/0+JxPudOU/Mc7jlvKCceP600cPR3k+6T6vMphiY3/AphkxuA05l80m91zmXKLTNzBX7HHXoGrKxvdm6ospZ/Yhlfc3WWrIPVfQg3dQpXPJI0+bD1lCIBNJLG9IdHt4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769760950; c=relaxed/simple;
	bh=XS6Jg9jnOJM5qzNlPs4NiBlesPdX4iyjTuy6nsR+4D0=;
	h=MIME-Version:Date:In-Reply-To:Message-ID:Subject:From:To:Cc:
	 Content-Type; b=EGbLhI0Ncc+MjAY2xSohGmlc7LIEBOW5v9dBpZSCxMyZhVlRLEE4Cy9DNmrOudiSANNSn2jpMi07qjfFa72H29DmEBeJo+ejBLgHH6WY+ZYTK1IbEXGJGtJWPUN1Mn/UQtxjron5hJwaz3A/6ATTJA0sA+yiGPmaMwSM8ubot18=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com; arc=none smtp.client-ip=209.85.160.71
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com
Received: by mail-oa1-f71.google.com with SMTP id 586e51a60fabf-3ff59bab16aso5697622fac.3
        for <syzbot@lists.linux.dev>; Fri, 30 Jan 2026 00:15:48 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1769760947; x=1770365747;
        h=cc:to:from:subject:message-id:in-reply-to:date:mime-version
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=qjZJFidfuPaGPPsT9xGXhj3/F6iB36JosaLjL7mn+G4=;
        b=nhc+s3bkEmEaa8P3I/PdLhcqqCffrdTsHIuw5UshGnrlxVlGl9hafD01KuSYou5xPv
         bBL/z0Gz4cqXkV9+k3Mu//3b2QeZcmLOcGvofgVgI939K/dzOoouIoaDlkHRS+9mAc82
         aOelBGcVt96Ccqe1UX79vUzTz79ezqF6hbdZqwTMbs1U09Mdortw+gGzLom59VQ4FG9H
         wHWGO+s99Y0wK1EuS5XRV34crHeC/0AIcrlJh3vltYAfTGvsNWHlaCsYAi7mOioW12yC
         P9azyosTxeEMUKV+m7lRUNL5np81jFJ4mxB0kR2lNn2xz9yA2QJnmV+oWxyY7otrn/IS
         trBQ==
X-Gm-Message-State: AOJu0YxGx1YCcZRAXeOmBERtt0KdAbl5xfDEIkC7SdOrrkoPQfSKTO3e
	Q+raYRCr3UcfVaQObmpzkBDXb3u07uroAsKRWCJAewtEo0LOSGBDCcbIKyyFLhgZDEz4/yUTkbX
	0atc6dpr3ojD9mlfcX59OqODrXODdjUyvepblSRsoQI8jTcOm4rPm3AUuxyE=
Precedence: bulk
X-Mailing-List: syzbot@lists.linux.dev
List-Id: <syzbot.lists.linux.dev>
List-Subscribe: <mailto:syzbot+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:syzbot+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Received: by 2002:a05:6820:1f05:b0:663:23a:caf4 with SMTP id
 006d021491bc7-6630f0317cfmr888270eaf.2.1769760947492; Fri, 30 Jan 2026
 00:15:47 -0800 (PST)
Date: Fri, 30 Jan 2026 00:15:47 -0800
In-Reply-To: <20260130034818.472804-1-ziy@nvidia.com>
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <697c68b3.a70a0220.9914.0032.GAE@google.com>
Subject: [syzbot ci] Re: Separate compound page from folio
From: syzbot ci <syzbot+ci7f632827e1b1c91b@syzkaller.appspotmail.com>
To: akpm@linux-foundation.org, apopple@nvidia.com, axboe@kernel.dk, 
	balbirs@nvidia.com, baohua@kernel.org, baolin.wang@linux.alibaba.com, 
	david@kernel.org, dev.jain@arm.com, hannes@cmpxchg.org, 
	io-uring@vger.kernel.org, jackmanb@google.com, jgg@nvidia.com, 
	lance.yang@linux.dev, liam.howlett@oracle.com, linux-kernel@vger.kernel.org, 
	linux-mm@kvack.org, lorenzo.stoakes@oracle.com, mhocko@suse.com, 
	muchun.song@linux.dev, npache@redhat.com, osalvador@suse.de, rppt@kernel.org, 
	ryan.roberts@arm.com, surenb@google.com, vbabka@suse.cz, willy@infradead.org, 
	ziy@nvidia.com
Cc: syzbot@lists.linux.dev, syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"

syzbot ci has tested the following series

[v1] Separate compound page from folio
https://lore.kernel.org/all/20260130034818.472804-1-ziy@nvidia.com
* [RFC PATCH 1/5] io_uring: allocate folio in io_mem_alloc_compound() and function rename
* [RFC PATCH 2/5] mm/huge_memory: use page_rmappable_folio() to convert after-split folios
* [RFC PATCH 3/5] mm/hugetlb: set large_rmappable on hugetlb and avoid deferred_list handling
* [RFC PATCH 4/5] mm: only use struct page in compound_nr() and compound_order()
* [RFC PATCH 5/5] mm: code separation for compound page and folio

and found the following issue:
WARNING in __folio_large_mapcount_sanity_checks

Full report is available here:
https://ci.syzbot.org/series/f64f0297-d388-4cfa-b3be-f05819d0ce34

***

WARNING in __folio_large_mapcount_sanity_checks

tree:      mm-new
URL:       https://kernel.googlesource.com/pub/scm/linux/kernel/git/akpm/mm.git
base:      0241748f8b68fc2bf637f4901b9d7ca660d177ca
arch:      amd64
compiler:  Debian clang version 21.1.8 (++20251221033036+2078da43e25a-1~exp1~20251221153213.50), Debian LLD 21.1.8
config:    https://ci.syzbot.org/builds/76dc5ea6-0ff5-410b-8b1f-72e5607a704e/config
C repro:   https://ci.syzbot.org/findings/a308f1d6-69e2-4ebc-80a9-b51d9dc02851/c_repro
syz repro: https://ci.syzbot.org/findings/a308f1d6-69e2-4ebc-80a9-b51d9dc02851/syz_repro

------------[ cut here ]------------
diff > folio_large_nr_pages(folio)
WARNING: ./include/linux/rmap.h:148 at __folio_large_mapcount_sanity_checks+0x499/0x6b0 include/linux/rmap.h:148, CPU#1: syz.0.17/5988
Modules linked in:
CPU: 1 UID: 0 PID: 5988 Comm: syz.0.17 Not tainted syzkaller #0 PREEMPT(full) 
Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS 1.16.2-debian-1.16.2-1 04/01/2014
RIP: 0010:__folio_large_mapcount_sanity_checks+0x499/0x6b0 include/linux/rmap.h:148
Code: 5f 5d e9 4a 4e 64 09 cc e8 84 d8 aa ff 90 0f 0b 90 e9 82 fc ff ff e8 76 d8 aa ff 90 0f 0b 90 e9 8f fc ff ff e8 68 d8 aa ff 90 <0f> 0b 90 e9 b8 fc ff ff e8 5a d8 aa ff 90 0f 0b 90 e9 f2 fc ff ff
RSP: 0018:ffffc900040e72f8 EFLAGS: 00010293
RAX: ffffffff8217c0f8 RBX: ffffea0006ef5c00 RCX: ffff888105fdba80
RDX: 0000000000000000 RSI: 0000000000000001 RDI: 0000000000000000
RBP: 0000000000000001 R08: ffffea0006ef5c07 R09: 1ffffd4000ddeb80
R10: dffffc0000000000 R11: fffff94000ddeb81 R12: 0000000000000001
R13: 0000000000000000 R14: 1ffffd4000ddeb8f R15: ffffea0006ef5c78
FS:  00005555867b3500(0000) GS:ffff8882a9923000(0000) knlGS:0000000000000000
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
Code: ff c3 66 2e 0f 1f 84 00 00 00 00 00 0f 1f 44 00 00 48 89 f8 48 89 f7 48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 ff ff 73 01 c3 48 c7 c1 e8 ff ff ff f7 d8 64 89 01 48
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
