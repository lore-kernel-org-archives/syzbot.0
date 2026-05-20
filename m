Received: from mail-ot1-f69.google.com (mail-ot1-f69.google.com [209.85.210.69])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 36052381AF1
	for <syzbot@lists.linux.dev>; Wed, 20 May 2026 21:23:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.69
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779312228; cv=none; b=L1RAAJT/ay2MRZvLecC2vZrdvq+G4pWWbctsAqcsgfUcRi/7lRUpvf90y0JZlnIvdM1jc9ioZAFNVjaUUXWCcUiYPeSa89m2Tr/576+P8UrSwQpSAa9NG8jnCK4ilu/SksDvfO0YX64RC3qA0lEUInawxDhemJ5hGVAfyhdlJxo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779312228; c=relaxed/simple;
	bh=8kVlFj2thV4lOyivYKgAMjWO2vEDiS+aogG05g2U/Dg=;
	h=MIME-Version:Date:Message-ID:Subject:From:To:Cc:Content-Type; b=Ox47djRiYOWTpovHG8+BsCx/G56ufJQiAdpfsxJptS0WNjWY7cjCNvjJEPCfI+aXz7xTkEuXlA8YUuwLTI2isvKG5f5ECc/CaxuH97IAUSXcekXm3+gsyM8TZmP8XT95ZnnBCqDxnWJxSaTgzqKFxjsz2vRwy7LuGTWMqOee0yk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com; arc=none smtp.client-ip=209.85.210.69
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com
Received: by mail-ot1-f69.google.com with SMTP id 46e09a7af769-7e3d4117a3bso8118207a34.2
        for <syzbot@lists.linux.dev>; Wed, 20 May 2026 14:23:44 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1779312224; x=1779917024;
        h=content-transfer-encoding:cc:to:from:subject:message-id:date
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=pNDZcTbO0lgcapWUw/lSzz4UHA8Zo6hnhikuAnY13fk=;
        b=kNkDVVbwfemx6OqFtYWFWBP11NFljmhxZHUUVKD3mb/MakQ2nolhb1VmlBnBenDWKR
         YObPyq/Nv2iAzrLOX7nPQ8nHz3WXN4T+SmphleQbGGR9lW2FHn3Y6gRYCTH6WIlpnQPu
         vy5UT+FjpoNkRJAR+FCzz3IxRSh+R+Fl5VfzNKBvscTFQBNFs8nkkkgGdJ5/p3y+SjxQ
         SOeJaBBvUDGjvomQFzE3NCizb0xzWq5kjCBVJPF51XG1jDqF7Ns7SaUT6tjPtVqrieFU
         VLy/csnZyBzAdJwBmz6NEluM2U9XK69uJHpQse8/ttbs/6WPISEw3HJzyQCGYfFipebJ
         m9QA==
X-Gm-Message-State: AOJu0YzYvB0IgAbmHJ/4Cj8ql4TRr4XzGLuwHbkCtmav1AwTjbU/1QWH
	xhnpbP1bpLaFO6/D8IK9sFdEPEEAGEwLPPCw1TYHMXeuY3aTAVwmgWbL8gFJSMVYmqoLjgNWiog
	tbcgG1naryJh37FRM07lez9Mipo07C//UXX3UeESMmeT0Omy4/ZQpb5zkzC4=
Precedence: bulk
X-Mailing-List: syzbot@lists.linux.dev
List-Id: <syzbot.lists.linux.dev>
List-Subscribe: <mailto:syzbot+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:syzbot+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Received: by 2002:a05:6820:220d:b0:696:23f5:7702 with SMTP id
 006d021491bc7-69c9c08a3c7mr15781222eaf.60.1779312223926; Wed, 20 May 2026
 14:23:43 -0700 (PDT)
Date: Wed, 20 May 2026 14:23:43 -0700
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <6a0e265f.050a0220.1fc69c.0000.GAE@google.com>
Subject: [moderation/CI] Re: mm: reliable 1GB page allocation
From: syzbot ci <syzbot+ci113f00a1e19876ff@syzkaller.appspotmail.com>
To: syzkaller-upstream-moderation@googlegroups.com
Cc: syzbot@lists.linux.dev
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

syzbot ci has tested the following series

[v1] mm: reliable 1GB page allocation
https://lore.kernel.org/all/20260520150018.2491267-1-riel@surriel.com
* [RFC PATCH 01/40] mm: page_alloc: replace pageblock_flags bitmap with str=
uct pageblock_data
* [RFC PATCH 02/40] mm: page_alloc: per-cpu pageblock buddy allocator
* [RFC PATCH 03/40] mm: page_alloc: split-path PCP free with local-trylock =
+ remote-llist
* [RFC PATCH 04/40] mm: mm_init: fix zone assignment for pages in unavailab=
le ranges
* [RFC PATCH 05/40] mm: page_alloc: remove watermark boost mechanism
* [RFC PATCH 06/40] mm: page_alloc: async evacuation of stolen movable page=
blocks
* [RFC PATCH 07/40] mm: page_alloc: track actual page contents in pageblock=
 flags
* [RFC PATCH 08/40] mm: page_alloc: superpageblock metadata for 1GB anti-fr=
agmentation
* [RFC PATCH 09/40] mm: page_alloc: support superpageblock resize for memor=
y hotplug
* [RFC PATCH 10/40] mm: page_alloc: add superpageblock fullness lists for a=
llocation steering
* [RFC PATCH 11/40] mm: page_alloc: steer pageblock stealing to tainted sup=
erpageblocks
* [RFC PATCH 12/40] mm: page_alloc: steer movable allocations to fullest cl=
ean superpageblocks
* [RFC PATCH 13/40] mm: page_alloc: extract claim_whole_block from try_to_c=
laim_block
* [RFC PATCH 14/40] mm: page_alloc: add per-superpageblock free lists
* [RFC PATCH 15/40] mm: page_alloc: add background superpageblock defragmen=
tation worker
* [RFC PATCH 16/40] mm: compaction: walk per-superpageblock free lists for =
migration targets
* [RFC PATCH 17/40] mm: page_alloc: superpageblock-aware contiguous and hig=
her order allocation
* [RFC PATCH 18/40] mm: page_alloc: prevent atomic allocations from taintin=
g clean SPBs
* [RFC PATCH 19/40] mm: page_alloc: aggressively pack non-movable allocs in=
 tainted SPBs on large systems
* [RFC PATCH 20/40] mm: page_alloc: prefer reclaim over tainting clean supe=
rpageblocks
* [RFC PATCH 21/40] mm: page_alloc: adopt partial pageblocks from tainted s=
uperpageblocks
* [RFC PATCH 22/40] mm: page_alloc: add CONFIG_DEBUG_VM sanity checks for S=
PB counters
* [RFC PATCH 23/40] mm: page_alloc: targeted evacuation and dynamic reserve=
s for tainted SPBs
* [RFC PATCH 24/40] mm: page_alloc: prevent UNMOVABLE/RECLAIMABLE mixing in=
 pageblocks
* [RFC PATCH 25/40] mm: trigger deferred SPB evac when atomic allocs would =
taint a clean SPB
* [RFC PATCH 26/40] mm: page_alloc: refuse fragmenting fallback for callers=
 with cheap fallback
* [RFC PATCH 27/40] mm: page_alloc: cross-migratetype buddy borrow within t=
ainted SPBs
* [RFC PATCH 28/40] mm: page_alloc: drive slab shrink from SPB anti-fragmen=
tation pressure
* [RFC PATCH 29/40] mm: page_reporting: walk per-superpageblock free lists
* [RFC PATCH 30/40] mm: show_mem: collect migratetype letters from per-supe=
rpageblock lists
* [RFC PATCH 31/40] mm: page_alloc: per-(zone, order, mt) PASS_1 hint cache
* [RFC PATCH 32/40] mm: debug: prevent infinite recursion in dump_page() wi=
th CMA
* [RFC PATCH 33/40] PM: hibernate: walk per-superpageblock free lists in ma=
rk_free_pages
* [RFC PATCH 34/40] btrfs: allocate eb-attached btree pages as movable
* [RFC PATCH 35/40] mm: page_alloc: refuse best-effort high-order allocs se=
rvable at lower orders
* [RFC PATCH 36/40] mm: page_alloc: set ALLOC_NOFRAGMENT on alloc_frozen_pa=
ges_nolock_noprof
* [RFC PATCH 37/40] mm: page_alloc: move spb_get_category and spb_tainted_r=
eserve to mmzone.h
* [RFC PATCH 38/40] mm: compaction: skip empty tainted superpageblocks as m=
igration source
* [RFC PATCH 39/40] mm: compaction: respect tainted SPB reserve in destinat=
ion selection
* [RFC PATCH 40/40] mm: page_alloc: SPB tracepoint instrumentation [DO-NOT-=
MERGE]

and found the following issue:
WARNING in preempt_count_sub

Full report is available here:
https://ci.syzbot.org/series/8eef71e1-708c-40d0-9f9d-3a1bd637fc80

***

WARNING in preempt_count_sub

tree:      mm-new
URL:       https://kernel.googlesource.com/pub/scm/linux/kernel/git/akpm/mm=
.git
base:      4b83cbc4c15f09b000cc06f033f64b0824b6dc87
arch:      amd64
compiler:  Debian clang version 21.1.8 (++20251221033036+2078da43e25a-1~exp=
1~20251221153213.50), Debian LLD 21.1.8
config:    https://ci.syzbot.org/builds/de024c89-d472-4f06-b5be-4f75f2acd1d=
9/config

------------[ cut here ]------------
DEBUG_LOCKS_WARN_ON(val > preempt_count())
WARNING: kernel/sched/core.c:5883 at preempt_count_sub+0x9e/0x170, CPU#0: k=
worker/0:0/9
Modules linked in:
CPU: 0 UID: 0 PID: 9 Comm: kworker/0:0 Not tainted syzkaller #0 PREEMPT(ful=
l)=20
Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS 1.16.2-debian-1.16=
.2-1 04/01/2014
Workqueue: events drain_vmap_area_work
RIP: 0010:preempt_count_sub+0xa5/0x170
Code: 29 31 90 48 c1 e8 03 0f b6 04 18 84 c0 0f 85 88 00 00 00 83 3d ff 50 =
9d 0e 00 75 13 48 8d 3d 32 37 a0 0e 48 c7 c6 c0 f8 cb 8b <67> 48 0f b9 3a 9=
0 eb b8 90 e8 ed d6 1d 03 85 c0 74 2f 48 c7 c0 c4
RSP: 0000:ffffc900000e7590 EFLAGS: 00010246

RAX: 0000000000000000 RBX: dffffc0000000000 RCX: ffff8881007d5880
RDX: 0000000000000000 RSI: ffffffff8bcbf8c0 RDI: ffffffff90341000
RBP: ffff888121042dc0 R08: ffffffff903129c3 R09: 1ffffffff2062538
R10: dffffc0000000000 R11: fffffbfff2062539 R12: 0000000000000020
R13: dffffc0000000000 R14: ffff888121042d80 R15: ffff88815fffbae8
FS:  0000000000000000(0000) GS:ffff88818dc7e000(0000) knlGS:000000000000000=
0
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: ffff88823ffff000 CR3: 000000000e74a000 CR4: 00000000000006f0
Call Trace:
 <TASK>
 free_frozen_page_commit+0x737/0x1290
 __free_frozen_pages+0x873/0x1070
 kasan_depopulate_vmalloc_pte+0x6d/0x90
 __apply_to_page_range+0xbdc/0x1420
 __kasan_release_vmalloc+0xa2/0xd0
 purge_vmap_node+0x220/0x960
 __purge_vmap_area_lazy+0x779/0xb40
 drain_vmap_area_work+0x27/0x40
 process_scheduled_works+0xb5d/0x1860
 worker_thread+0xa53/0xfc0
 kthread+0x388/0x470
 ret_from_fork+0x514/0xb70
 ret_from_fork_asm+0x1a/0x30
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
[boris@bur.io clm@meta.com david@kernel.org dsterba@suse.com fvdl@google.co=
m hannes@cmpxchg.org hnaz@cmpxchg.org kernel-team@meta.com lenb@kernel.org =
linux-btrfs@vger.kernel.org linux-kernel@vger.kernel.org linux-mm@kvack.org=
 linux-pm@vger.kernel.org ljs@kernel.org pavel@kernel.org rafael@kernel.org=
 riel@surriel.com surenb@google.com usama.arif@linux.dev willy@infradead.or=
g ziy@nvidia.com]

If the report looks fine to you, reply with:
#syz upstream

If the report is a false positive, reply with
#syz invalid

