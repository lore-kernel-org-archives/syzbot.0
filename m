Received: from mail-oo1-f69.google.com (mail-oo1-f69.google.com [209.85.161.69])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 64EFA2D77E5
	for <syzbot@lists.linux.dev>; Mon, 20 Apr 2026 17:58:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.161.69
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776707889; cv=none; b=NJzJ/rJUahzp4qfPsWdThDm8IC3sLRFZncC88JeLebFMkeAgU5dutmlawvkTXu7rFHC7m/QLgKxgEQHlFQP8aJZJPrJbsJajoXlX29YPpQSoM94D6ySQxbNvUIqZH3JxiCfQ2NCh72U6OhB8tN0LNOXZcG2N38CPmDgUZY/coho=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776707889; c=relaxed/simple;
	bh=EGf5fOFJ+HHUBV2OfEgXuQKda8K1742pGgCjgYebtDc=;
	h=MIME-Version:Date:Message-ID:Subject:From:To:Cc:Content-Type; b=G6dzJGnuyKdArUdlKe7mY/Bh2ERTTI9wEjBdCFnVU5LWlbIZUBJQIP3F2LTczj+nCTCIYIgwF144UKJf51hx62vJJXKPjSOc2KEaYHq63CDtXEMjJvIrb/Qh4Z4wPdu8qcpwC7lnB7+l7cnWyyb3Sng8Zfy7yiHl0w8Nwg+O8/s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com; arc=none smtp.client-ip=209.85.161.69
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com
Received: by mail-oo1-f69.google.com with SMTP id 006d021491bc7-6946dfca922so1851350eaf.1
        for <syzbot@lists.linux.dev>; Mon, 20 Apr 2026 10:58:07 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1776707886; x=1777312686;
        h=content-transfer-encoding:cc:to:from:subject:message-id:date
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=wty71zdsbgyDaZwcwdxRWN+g8kHDiOK7sIcv2WlLnUw=;
        b=EncRd/evTA8Kzhxev5q+pkU5xGPa8iHKkAV8kTZh4RATd2SboxGbqGiNtWZIjny5BO
         owD5IIGjmAFS8jGdRR9kXxG3ZjP9Y9Gu6rzXJdd3/c+FBQMc2V3VrAn68plyEK/5Kjac
         LW1jDA/Hqrp4qFvLHg6iIKd0TzcC6dnJskANgAZ8W5dkNgZJbyMRNghiOgxXJT6kHVG9
         XhrvSyib3o1de5tT6V6P+EQ35uJRUeDRxBWl7K8JMsHyHemE/AXygthxsZOantl9IWqN
         3Fy0jZyEoqYrR/adYaY0Iwo3LXhJLzXdf7lUCe25vHOGhGu8efmwapRhDCRdnjvpXQ27
         6jkQ==
X-Gm-Message-State: AOJu0YxAB3WmDpcMPwMU2vlxRCavCK++4NW+1PYG2rSvPp8vTmO7SN6J
	psd+4FqYFPxxDxq7BDxztYHW7g8RW6h/5z3TB7g8OnsArncNd0Kq+D1dmY/d/72eSyo2dEnMy/o
	u6jbP+rb8j53Pxa6AayCGCyZk+vox+k7nf69CoS1guLY3nklJcUGXqNdwBUM=
Precedence: bulk
X-Mailing-List: syzbot@lists.linux.dev
List-Id: <syzbot.lists.linux.dev>
List-Subscribe: <mailto:syzbot+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:syzbot+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Received: by 2002:a05:6820:1ca0:b0:67e:16b4:aa1b with SMTP id
 006d021491bc7-69462f3f1famr8139877eaf.53.1776707886317; Mon, 20 Apr 2026
 10:58:06 -0700 (PDT)
Date: Mon, 20 Apr 2026 10:58:06 -0700
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <69e6692e.a00a0220.9259.0006.GAE@google.com>
Subject: [moderation/CI] Re: mm/virtio: skip redundant zeroing of host-zeroed
 reported pages
From: syzbot ci <syzbot+cidb1c74b9c61e30bf@syzkaller.appspotmail.com>
To: syzkaller-upstream-moderation@googlegroups.com
Cc: syzbot@lists.linux.dev
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

syzbot ci has tested the following series

[v2] mm/virtio: skip redundant zeroing of host-zeroed reported pages
https://lore.kernel.org/all/cover.1776689093.git.mst@redhat.com
* [PATCH RFC v2 01/18] mm: page_alloc: propagate PageReported flag across b=
uddy splits
* [PATCH RFC v2 02/18] mm: add pghint_t type and vma_alloc_folio_hints API
* [PATCH RFC v2 03/18] mm: add PG_zeroed page flag for known-zero pages
* [PATCH RFC v2 04/18] mm: page_alloc: track PG_zeroed across buddy merges
* [PATCH RFC v2 05/18] mm: page_alloc: preserve PG_zeroed in try_to_claim_b=
lock
* [PATCH RFC v2 06/18] mm: page_alloc: thread pghint_t through get_page_fro=
m_freelist
* [PATCH RFC v2 07/18] mm: post_alloc_hook: use PG_zeroed to skip zeroing, =
return pghint_t
* [PATCH RFC v2 08/18] mm: hugetlb: thread pghint_t through buddy allocatio=
n chain
* [PATCH RFC v2 09/18] mm: hugetlb: use PG_zeroed for pool pages, skip redu=
ndant zeroing
* [PATCH RFC v2 10/18] mm: page_reporting: support host-zeroed reported pag=
es
* [PATCH RFC v2 11/18] mm: skip zeroing in vma_alloc_zeroed_movable_folio f=
or pre-zeroed pages
* [PATCH RFC v2 12/18] mm: skip zeroing in alloc_anon_folio for pre-zeroed =
pages
* [PATCH RFC v2 13/18] mm: skip zeroing in vma_alloc_anon_folio_pmd for pre=
-zeroed pages
* [PATCH RFC v2 14/18] mm: memfd: skip zeroing for pre-zeroed hugetlb pages
* [PATCH RFC v2 15/18] virtio_balloon: add host_zeroes_pages module paramet=
er
* [PATCH RFC v2 16/18] mm: page_reporting: add flush parameter with page bu=
dget
* [PATCH RFC v2 17/18] mm: add free_frozen_pages_hint and put_page_hint API=
s
* [PATCH RFC v2 18/18] virtio_balloon: mark deflated pages as pre-zeroed

and found the following issue:
kernel BUG in free_huge_folio

Full report is available here:
https://ci.syzbot.org/series/329d9cff-a0ad-46d2-8ff4-d9f4341a611f

***

kernel BUG in free_huge_folio

tree:      mm-new
URL:       https://kernel.googlesource.com/pub/scm/linux/kernel/git/akpm/mm=
.git
base:      b8a5774cd49996e8ef83b1637a9b547158f18de9
arch:      amd64
compiler:  Debian clang version 21.1.8 (++20251221033036+2078da43e25a-1~exp=
1~20251221153213.50), Debian LLD 21.1.8
config:    https://ci.syzbot.org/builds/60e99a0e-08bf-474f-b034-a8bfd2eb90b=
0/config
syz repro: https://ci.syzbot.org/findings/2868ce13-1752-4f9f-9aa9-c5ce89f01=
fc7/syz_repro

 ret_from_fork+0x51e/0xb90 arch/x86/kernel/process.c:158
 ret_from_fork_asm+0x1a/0x30 arch/x86/entry/entry_64.S:245
page_owner free stack trace missing
------------[ cut here ]------------
kernel BUG at ./include/linux/page-flags.h:698!
Oops: invalid opcode: 0000 [#1] SMP KASAN PTI
CPU: 1 UID: 0 PID: 6015 Comm: syz.2.19 Not tainted syzkaller #0 PREEMPT(ful=
l)=20
Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS 1.16.2-debian-1.16=
.2-1 04/01/2014
RIP: 0010:__ClearPageZeroed include/linux/page-flags.h:698 [inline]
RIP: 0010:free_huge_folio+0xf93/0x12e0 mm/hugetlb.c:1749
Code: c7 c6 a0 64 db 8b e8 5c 9b fe fe 90 0f 0b e8 74 40 9c ff eb 05 e8 6d =
40 9c ff 48 89 df 48 c7 c6 e0 63 db 8b e8 3e 9b fe fe 90 <0f> 0b e8 56 40 9=
c ff 48 89 df 48 c7 c6 40 64 db 8b e8 27 9b fe fe
RSP: 0018:ffffc90003a675b8 EFLAGS: 00010246
RAX: c71fb9abd148e700 RBX: ffffea0005808000 RCX: 0000000000000000
RDX: 0000000000000007 RSI: ffffffff8defcd3f RDI: 00000000ffffffff
RBP: 1ffffd4000b0101a R08: ffffffff9011ddb7 R09: 1ffffffff2023bb6
R10: dffffc0000000000 R11: fffffbfff2023bb7 R12: ffffea0005808008
R13: ffffea00058080d0 R14: ffffffff9a2e27c0 R15: 0000000000000040
FS:  00007fe11abed6c0(0000) GS:ffff8882a9453000(0000) knlGS:000000000000000=
0
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 00007fe119de9f00 CR3: 00000001ba914000 CR4: 00000000000006f0
Call Trace:
 <TASK>
 __folio_put+0xfc/0x4f0 mm/swap.c:105
 hugetlb_mfill_atomic_pte+0x130a/0x1730 mm/hugetlb.c:6294
 mfill_atomic_hugetlb mm/userfaultfd.c:601 [inline]
 mfill_atomic mm/userfaultfd.c:773 [inline]
 mfill_atomic_copy+0xe28/0x1420 mm/userfaultfd.c:872
 userfaultfd_copy fs/userfaultfd.c:1642 [inline]
 userfaultfd_ioctl+0x2c17/0x5130 fs/userfaultfd.c:2059
 vfs_ioctl fs/ioctl.c:51 [inline]
 __do_sys_ioctl fs/ioctl.c:597 [inline]
 __se_sys_ioctl+0xfc/0x170 fs/ioctl.c:583
 do_syscall_x64 arch/x86/entry/syscall_64.c:63 [inline]
 do_syscall_64+0x14d/0xf80 arch/x86/entry/syscall_64.c:94
 entry_SYSCALL_64_after_hwframe+0x77/0x7f
RIP: 0033:0x7fe119d9c819
Code: ff c3 66 2e 0f 1f 84 00 00 00 00 00 0f 1f 44 00 00 48 89 f8 48 89 f7 =
48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 ff f=
f 73 01 c3 48 c7 c1 e8 ff ff ff f7 d8 64 89 01 48
RSP: 002b:00007fe11abed028 EFLAGS: 00000246 ORIG_RAX: 0000000000000010
RAX: ffffffffffffffda RBX: 00007fe11a015fa0 RCX: 00007fe119d9c819
RDX: 00002000000000c0 RSI: 00000000c028aa03 RDI: 0000000000000003
RBP: 00007fe119e32c91 R08: 0000000000000000 R09: 0000000000000000
R10: 0000000000000000 R11: 0000000000000246 R12: 0000000000000000
R13: 00007fe11a016038 R14: 00007fe11a015fa0 R15: 00007ffe7cd6ce28
 </TASK>
Modules linked in:
---[ end trace 0000000000000000 ]---
RIP: 0010:__ClearPageZeroed include/linux/page-flags.h:698 [inline]
RIP: 0010:free_huge_folio+0xf93/0x12e0 mm/hugetlb.c:1749
Code: c7 c6 a0 64 db 8b e8 5c 9b fe fe 90 0f 0b e8 74 40 9c ff eb 05 e8 6d =
40 9c ff 48 89 df 48 c7 c6 e0 63 db 8b e8 3e 9b fe fe 90 <0f> 0b e8 56 40 9=
c ff 48 89 df 48 c7 c6 40 64 db 8b e8 27 9b fe fe
RSP: 0018:ffffc90003a675b8 EFLAGS: 00010246
RAX: c71fb9abd148e700 RBX: ffffea0005808000 RCX: 0000000000000000
RDX: 0000000000000007 RSI: ffffffff8defcd3f RDI: 00000000ffffffff
RBP: 1ffffd4000b0101a R08: ffffffff9011ddb7 R09: 1ffffffff2023bb6
R10: dffffc0000000000 R11: fffffbfff2023bb7 R12: ffffea0005808008
R13: ffffea00058080d0 R14: ffffffff9a2e27c0 R15: 0000000000000040
FS:  00007fe11abed6c0(0000) GS:ffff8882a9453000(0000) knlGS:000000000000000=
0
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 00007fe119de9f00 CR3: 00000001ba914000 CR4: 00000000000006f0


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
[aarcange@redhat.com akpm@linux-foundation.org apopple@nvidia.com axelrasmu=
ssen@google.com baohua@kernel.org baolin.wang@linux.alibaba.com bhe@redhat.=
com byungchul@sk.com chrisl@kernel.org david@kernel.org dev.jain@arm.com ep=
erezma@redhat.com gourry@gourry.net hannes@cmpxchg.org hughd@google.com jac=
kmanb@google.com jasowang@redhat.com joshua.hahnjy@gmail.com kasong@tencent=
.com lance.yang@linux.dev liam.howlett@oracle.com linux-kernel@vger.kernel.=
org linux-mm@kvack.org ljs@kernel.org matthew.brost@intel.com mhocko@suse.c=
om mst@redhat.com muchun.song@linux.dev npache@redhat.com nphamcs@gmail.com=
 osalvador@suse.de rakie.kim@sk.com rppt@kernel.org ryan.roberts@arm.com sh=
ikemeng@huaweicloud.com surenb@google.com vbabka@kernel.org virtualization@=
lists.linux.dev weixugc@google.com xuanzhuo@linux.alibaba.com ying.huang@li=
nux.alibaba.com yuanchu@google.com ziy@nvidia.com]

If the report looks fine to you, reply with:
#syz upstream

If the report is a false positive, reply with
#syz invalid

