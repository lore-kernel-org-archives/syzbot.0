Received: from mail-oa1-f70.google.com (mail-oa1-f70.google.com [209.85.160.70])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 924AB30EF63
	for <syzbot@lists.linux.dev>; Wed, 14 Jan 2026 16:00:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.160.70
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768406405; cv=none; b=EwyogfU1MKniBsHpSgxBuFOYYw68/GghnjMYQYiSJ0EDQRkS5t0iZDyxTiflKqWwi2v5yobnEmpavQln/QxpUCze0aIwTruoNBDsdZKun6JQZ2qclpSL/wJH4iuE3GqoT0Zb08l6eFVJpgglgA+AeZfE+1F9qnafLNfsUZ+Wlfs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768406405; c=relaxed/simple;
	bh=lwnNWp015N7ligxYfbiU3FFJcH1h6UF4I3aicvjroGg=;
	h=MIME-Version:Date:Message-ID:Subject:From:To:Cc:Content-Type; b=ZDhPgHGVophQz1yNtOQodx2SQmbTY1KiZSgjJqC7Aa6+pvBID7kLiVYVlI0vnNprQKkIvBi5ADRPJKpZjntvUlYCzZWnY+hqmB8tcPwbVe3rzou41ekZHlNgs5RbNgJH2RKxRIcIzEWC8Z2ofjlAGPBK9DG3XwwRO0Q5mh9Vf+E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com; arc=none smtp.client-ip=209.85.160.70
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com
Received: by mail-oa1-f70.google.com with SMTP id 586e51a60fabf-3f9b001f317so17212785fac.0
        for <syzbot@lists.linux.dev>; Wed, 14 Jan 2026 08:00:02 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1768406401; x=1769011201;
        h=content-transfer-encoding:cc:to:from:subject:message-id:date
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=G9h1zkYpO4FhqMF2/H8qdx68T0JbxFbMo6i8L5KIKbs=;
        b=XrVcx+7OUBoqX2CdlFYTADlMPkn1ldPmu8w5cYv1lWhesZ9Bf4rQmRiZ0/9MktK9C4
         Bfw9PvUse+bbV7q1l/ijrk7rjxggjp3/8vDxpqXvzwrFwuSQsg2J8dKaPdYHjoCUAmj8
         7LA9zy2KmGGH4XtNOpK8zed1eGt448vRxnPxDU9Y113fG9rifcMTRwnRjrDvGcaDkZTO
         8DBqqjY5Qt5IaLUgtbjhvvJqvuR6jGQeofSGhExRDnavcmGgFaWbmgZUw4BHNVWzfGFO
         4So+05oMlrV/iLIEg9JAH/ymKmQZ28r7+d4Afj0xXjN1YHGVMbOwRWWkJaFVGm0a350K
         97Lw==
X-Gm-Message-State: AOJu0Yx02GIYJpQHWRR2Blkyl28VkmK581wI1W96Z0NzyqmIvhuy5nqm
	KAuynD0vH5SVtkbiLgm5QxYJJO7xV8ZF8k4tvprghg8V+lhFOY+KgA9dnW2+8MEP7X57LauBzGM
	VqL31wV/mt6ejgYWmO+mTmUSPMmDs3pEHl0DMokrhEtE7yDADWYinPHj0MIA=
Precedence: bulk
X-Mailing-List: syzbot@lists.linux.dev
List-Id: <syzbot.lists.linux.dev>
List-Subscribe: <mailto:syzbot+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:syzbot+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Received: by 2002:a05:6820:f024:b0:65f:7009:d713 with SMTP id
 006d021491bc7-6610060f3femr2212455eaf.3.1768406401237; Wed, 14 Jan 2026
 08:00:01 -0800 (PST)
Date: Wed, 14 Jan 2026 08:00:01 -0800
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <6967bd81.050a0220.150504.0005.GAE@google.com>
Subject: [moderation/CI] Re: Eliminate Dying Memory Cgroup
From: syzbot ci <syzbot+cic3e68dffbdbd9f58@syzkaller.appspotmail.com>
To: syzkaller-upstream-moderation@googlegroups.com
Cc: syzbot@lists.linux.dev
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

syzbot ci has tested the following series

[v3] Eliminate Dying Memory Cgroup
https://lore.kernel.org/all/cover.1768389889.git.zhengqi.arch@bytedance.com
* [PATCH v3 01/30] mm: memcontrol: remove dead code of checking parent memo=
ry cgroup
* [PATCH v3 02/30] mm: workingset: use folio_lruvec() in workingset_refault=
()
* [PATCH v3 03/30] mm: rename unlock_page_lruvec_irq and its variants
* [PATCH v3 04/30] mm: vmscan: prepare for the refactoring the move_folios_=
to_lru()
* [PATCH v3 05/30] mm: vmscan: refactor move_folios_to_lru()
* [PATCH v3 06/30] mm: memcontrol: allocate object cgroup for non-kmem case
* [PATCH v3 07/30] mm: memcontrol: return root object cgroup for root memor=
y cgroup
* [PATCH v3 08/30] mm: memcontrol: prevent memory cgroup release in get_mem=
_cgroup_from_folio()
* [PATCH v3 09/30] buffer: prevent memory cgroup release in folio_alloc_buf=
fers()
* [PATCH v3 10/30] writeback: prevent memory cgroup release in writeback mo=
dule
* [PATCH v3 11/30] mm: memcontrol: prevent memory cgroup release in count_m=
emcg_folio_events()
* [PATCH v3 12/30] mm: page_io: prevent memory cgroup release in page_io mo=
dule
* [PATCH v3 13/30] mm: migrate: prevent memory cgroup release in folio_migr=
ate_mapping()
* [PATCH v3 14/30] mm: mglru: prevent memory cgroup release in mglru
* [PATCH v3 15/30] mm: memcontrol: prevent memory cgroup release in mem_cgr=
oup_swap_full()
* [PATCH v3 16/30] mm: workingset: prevent memory cgroup release in lru_gen=
_eviction()
* [PATCH v3 17/30] mm: thp: prevent memory cgroup release in folio_split_qu=
eue_lock{_irqsave}()
* [PATCH v3 18/30] mm: zswap: prevent memory cgroup release in zswap_compre=
ss()
* [PATCH v3 19/30] mm: workingset: prevent lruvec release in workingset_ref=
ault()
* [PATCH v3 20/30] mm: zswap: prevent lruvec release in zswap_folio_swapin(=
)
* [PATCH v3 21/30] mm: swap: prevent lruvec release in lru_gen_clear_refs()
* [PATCH v3 22/30] mm: workingset: prevent lruvec release in workingset_act=
ivation()
* [PATCH v3 23/30] mm: do not open-code lruvec lock
* [PATCH v3 24/30] mm: memcontrol: prepare for reparenting LRU pages for lr=
uvec lock
* [PATCH v3 25/30] mm: vmscan: prepare for reparenting traditional LRU foli=
os
* [PATCH v3 26/30] mm: vmscan: prepare for reparenting MGLRU folios
* [PATCH v3 27/30] mm: memcontrol: refactor memcg_reparent_objcgs()
* [PATCH v3 28/30] mm: memcontrol: prepare for reparenting state_local
* [PATCH v3 29/30] mm: memcontrol: eliminate the problem of dying memory cg=
roup for LRU folios
* [PATCH v3 30/30] mm: lru: add VM_WARN_ON_ONCE_FOLIO to lru maintenance he=
lpers

and found the following issue:
UBSAN: array-index-out-of-bounds in reparent_memcg_lruvec_state_local

Full report is available here:
https://ci.syzbot.org/series/45c0b58d-255a-4579-9880-497bdbd4fb99

***

UBSAN: array-index-out-of-bounds in reparent_memcg_lruvec_state_local

tree:      linux-next
URL:       https://kernel.googlesource.com/pub/scm/linux/kernel/git/next/li=
nux-next
base:      b775e489bec70895b7ef6b66927886bbac79598f
arch:      amd64
compiler:  Debian clang version 21.1.8 (++20251221033036+2078da43e25a-1~exp=
1~20251221153213.50), Debian LLD 21.1.8
config:    https://ci.syzbot.org/builds/4d8819ab-0f94-42e8-bd70-87c7e83c37d=
2/config
syz repro: https://ci.syzbot.org/findings/7850f5dd-4ac7-4b74-85ff-a75ddddeb=
bee/syz_repro

------------[ cut here ]------------
UBSAN: array-index-out-of-bounds in mm/memcontrol.c:530:3
index 33 is out of range for type 'long[33]'
CPU: 1 UID: 0 PID: 31 Comm: kworker/1:1 Not tainted syzkaller #0 PREEMPT(fu=
ll)=20
Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS 1.16.2-debian-1.16=
.2-1 04/01/2014
Workqueue: cgroup_offline css_killed_work_fn
Call Trace:
 <TASK>
 dump_stack_lvl+0xe8/0x150 lib/dump_stack.c:120
 ubsan_epilogue+0xa/0x30 lib/ubsan.c:233
 __ubsan_handle_out_of_bounds+0xe8/0xf0 lib/ubsan.c:455
 reparent_memcg_lruvec_state_local+0x34f/0x460 mm/memcontrol.c:530
 reparent_memcg1_lruvec_state_local+0xa7/0xc0 mm/memcontrol-v1.c:1917
 reparent_state_local mm/memcontrol.c:242 [inline]
 memcg_reparent_objcgs mm/memcontrol.c:299 [inline]
 mem_cgroup_css_offline+0xc7c/0xc90 mm/memcontrol.c:4054
 offline_css kernel/cgroup/cgroup.c:5760 [inline]
 css_killed_work_fn+0x12f/0x570 kernel/cgroup/cgroup.c:6055
 process_one_work+0x949/0x15a0 kernel/workqueue.c:3279
 process_scheduled_works kernel/workqueue.c:3362 [inline]
 worker_thread+0x9af/0xee0 kernel/workqueue.c:3443
 kthread+0x388/0x470 kernel/kthread.c:467
 ret_from_fork+0x51b/0xa40 arch/x86/kernel/process.c:158
 ret_from_fork_asm+0x1a/0x30 arch/x86/entry/entry_64.S:246
 </TASK>
---[ end trace ]---
Kernel panic - not syncing: UBSAN: panic_on_warn set ...
CPU: 1 UID: 0 PID: 31 Comm: kworker/1:1 Not tainted syzkaller #0 PREEMPT(fu=
ll)=20
Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS 1.16.2-debian-1.16=
.2-1 04/01/2014
Workqueue: cgroup_offline css_killed_work_fn
Call Trace:
 <TASK>
 vpanic+0x1e0/0x670 kernel/panic.c:490
 panic+0xc5/0xd0 kernel/panic.c:627
 check_panic_on_warn+0x89/0xb0 kernel/panic.c:377
 __ubsan_handle_out_of_bounds+0xe8/0xf0 lib/ubsan.c:455
 reparent_memcg_lruvec_state_local+0x34f/0x460 mm/memcontrol.c:530
 reparent_memcg1_lruvec_state_local+0xa7/0xc0 mm/memcontrol-v1.c:1917
 reparent_state_local mm/memcontrol.c:242 [inline]
 memcg_reparent_objcgs mm/memcontrol.c:299 [inline]
 mem_cgroup_css_offline+0xc7c/0xc90 mm/memcontrol.c:4054
 offline_css kernel/cgroup/cgroup.c:5760 [inline]
 css_killed_work_fn+0x12f/0x570 kernel/cgroup/cgroup.c:6055
 process_one_work+0x949/0x15a0 kernel/workqueue.c:3279
 process_scheduled_works kernel/workqueue.c:3362 [inline]
 worker_thread+0x9af/0xee0 kernel/workqueue.c:3443
 kthread+0x388/0x470 kernel/kthread.c:467
 ret_from_fork+0x51b/0xa40 arch/x86/kernel/process.c:158
 ret_from_fork_asm+0x1a/0x30 arch/x86/entry/entry_64.S:246
 </TASK>
Kernel Offset: disabled
Rebooting in 86400 seconds..


***

If these findings have caused you to resend the series or submit a
separate fix, please add the following tag to your commit message:
  Tested-by: syzbot@syzkaller.appspotmail.com

---
This report is generated by a bot. It may contain errors.
syzbot ci engineers can be reached at syzkaller@googlegroups.com.

The email will later be sent to:
[akpm@linux-foundation.org apais@linux.microsoft.com axelrasmussen@google.c=
om cgroups@vger.kernel.org chengming.zhou@linux.dev chenridong@huawei.com c=
henridong@huaweicloud.com david@kernel.org hamzamahfooz@linux.microsoft.com=
 hannes@cmpxchg.org harry.yoo@oracle.com hughd@google.com imran.f.khan@orac=
le.com kamalesh.babulal@oracle.com lance.yang@linux.dev linux-kernel@vger.k=
ernel.org linux-mm@kvack.org lorenzo.stoakes@oracle.com mhocko@suse.com mko=
utny@suse.com muchun.song@linux.dev nphamcs@gmail.com qi.zheng@linux.dev ro=
man.gushchin@linux.dev shakeel.butt@linux.dev songmuchun@bytedance.com weix=
ugc@google.com yosry.ahmed@linux.dev yuanchu@google.com zhengqi.arch@byteda=
nce.com ziy@nvidia.com]

If the report looks fine to you, reply with:
#syz upstream

If the report is a false positive, reply with
#syz invalid

