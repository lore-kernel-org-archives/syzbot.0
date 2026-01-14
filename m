Received: from mail-oi1-f180.google.com (mail-oi1-f180.google.com [209.85.167.180])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 692F62E03F1
	for <syzbot@lists.linux.dev>; Wed, 14 Jan 2026 17:06:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.167.180
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768410380; cv=none; b=dqP3mk3LwwKrSBTt1pUFZ5VjOpNV5wi5ASaci++7txlkHP4rf5Y9TiN7EBcVIUgle4nK7ziWjIMIWQ7WZWweQs/EpFPTkABCMVtfw6nY/2uLsGAwj9KaGavhqpIQTm7nzNZMTM08hdIwMbo7n65lOstbSSQ2TxRf2Ei85CQVA34=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768410380; c=relaxed/simple;
	bh=G688D2dNHjxjGPXp3HdophxDy8GWphdvKgCIEzFtAvU=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=X4Wij6py9If6fsIM9iEq+Sd70CyR29OUpRUUC7Im1qUTt8Qs2lsCaSY13EKuFZElz3gtSnXL6lYscsMWhD6ilfHxHDDVhiUqFlneBPrJO+wVt7ClLDOSZ4xQCm1LjboF2FDWNZrtae6kV8FEXzT66CAkb8aAYF3YvmN5iv4ZUdE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=OxGwkyC4; arc=none smtp.client-ip=209.85.167.180
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="OxGwkyC4"
Received: by mail-oi1-f180.google.com with SMTP id 5614622812f47-459a516592eso422b6e.1
        for <syzbot@lists.linux.dev>; Wed, 14 Jan 2026 09:06:18 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1768410377; x=1769015177; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=tXsiI2Ts7AEIfqfhlY1EXDlDv2UOmR7jTtC6c3Jn3ok=;
        b=OxGwkyC4lwO23JZ008JtveoV4p6uPLTZB/0WWhhGkbxb8fHITt4nI+dsW1oFKb+14M
         zyijrdi21DEWOVVWST2INfjGgD476CVfbMYI7GwEzIIC9M3ODsI8TYTtYC+RMpqdw/ty
         bmt8DIFgrGNLBdBnJw/oioHeY9BzTTlYqccAI7zwR+cR/rPzejp/whUblUJCHM1jvUch
         +ps2jN/2x902Xee6WEyO5Xrb9IBU54untEIx3GqmsQatda8Dy7PZf42oARV7QvYVQDGW
         SxMLTMzYMzNtT4azn4Mt+9YEElLq/IUseLggoLh2is81YlG3PLRvc6jFAl/J+iSU242I
         sGOA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1768410377; x=1769015177;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=tXsiI2Ts7AEIfqfhlY1EXDlDv2UOmR7jTtC6c3Jn3ok=;
        b=StmzGjaFpQjk0P0hsbKeSR3xitwLikqi1deuO32yYbxreFD6h6LDl9oya8xCu3bXBl
         E/YqVlvGVKaCIX41JxG+NdIGQNdocwr6kr677CXzPqNBiYPDDK1Pwt8o29mrmDlcuZ9F
         WWQKqW3WFOHcfeO5Z62kEevJCGWZJg5krxn6FlkdfseWgvdJ2/1AOgfDoIirFC3KCXm2
         Bm9QPwPDfW3UljqZ1LIoQ6SqFLwfrzMQnr0zjCNcJSeKjQ0kHnM2rr6CI3skkAqFKsS5
         FbiAEHRfQCfaXB35GVNbTMmqCKr837JdQzYmSJ2ePyfhw+eX+cdmW6pojQ9evYgA/sEB
         WfQA==
X-Forwarded-Encrypted: i=1; AJvYcCXGepRI9kONVNglKDHJ9IehnrM7vT0XZWgKfepLfvNwRVK+NQzgjvXjuKrf7/SpQwD+0E9Hywc=@lists.linux.dev
X-Gm-Message-State: AOJu0Ywx0z6rA5L9lewiN491gMVRpM+UoEgeUsW3ybkN9aRuK4+n++ra
	ShgcQa6qC0HQwH1ItMgDmTJlDIZbuBp39v34hX46v7U2rvWE6/t+0VG6f4mKaL4DIeV3ujZuS5V
	SMbSRMXBwrpMvBS/AH5aT1T9sJFaDRsbidaD6eGEZ
X-Gm-Gg: AY/fxX5fBpXW1jxFiR6tUMDc2TTO2+p8eYlkgeKdxW2y0pm956P1pf3IiRav67auguA
	flCtlPfZrpbKt6QVXSGpxbUNBZpiYwEpo5WHdjqXg3QJYL8uXeG/6nYiF6wd9JZkAUYfEc73Avi
	c+iqDFIrxYl9m0uHftjtsqbI3zyPHNiPRnL7pryvYiDoKcxgSJtXdNFU3Oy9GnqufUzXObHk5+A
	HER2UWVx67ilSeDX9mqXRh25Ihv/0FKSE58IgSxAFv0cLTWaF388rZDhuhUDr+KLSr8Hs17fW3a
	Sb7Ooen2a3GMCQXXl+2iQcteJ3Ov7l2/uDzPRCHH+ouVvjdnlNIMFJ/Jvw==
X-Received: by 2002:a05:6808:6507:b0:450:d7fb:85c2 with SMTP id
 5614622812f47-45c7148c118mr1963660b6e.19.1768410376926; Wed, 14 Jan 2026
 09:06:16 -0800 (PST)
Precedence: bulk
X-Mailing-List: syzbot@lists.linux.dev
List-Id: <syzbot.lists.linux.dev>
List-Subscribe: <mailto:syzbot+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:syzbot+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <6967bd81.050a0220.150504.0005.GAE@google.com>
In-Reply-To: <6967bd81.050a0220.150504.0005.GAE@google.com>
From: Aleksandr Nogikh <nogikh@google.com>
Date: Wed, 14 Jan 2026 18:06:05 +0100
X-Gm-Features: AZwV_QgypuKm6gD5UC8nsKwDaVR_8iyEo-dv3d40RfNwBmuLeHmuJD8_8iKIHXQ
Message-ID: <CANp29Y4R2s=kcjyLmmEP6wX_yW8CAm0t0NtYOX_MeOyyPow2Og@mail.gmail.com>
Subject: Re: [moderation/CI] Re: Eliminate Dying Memory Cgroup
To: syzbot ci <syzbot+cic3e68dffbdbd9f58@syzkaller.appspotmail.com>
Cc: syzkaller-upstream-moderation@googlegroups.com, syzbot@lists.linux.dev
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

#syz upstream

On Wed, Jan 14, 2026 at 5:00=E2=80=AFPM syzbot ci
<syzbot+cic3e68dffbdbd9f58@syzkaller.appspotmail.com> wrote:
>
> syzbot ci has tested the following series
>
> [v3] Eliminate Dying Memory Cgroup
> https://lore.kernel.org/all/cover.1768389889.git.zhengqi.arch@bytedance.c=
om
> * [PATCH v3 01/30] mm: memcontrol: remove dead code of checking parent me=
mory cgroup
> * [PATCH v3 02/30] mm: workingset: use folio_lruvec() in workingset_refau=
lt()
> * [PATCH v3 03/30] mm: rename unlock_page_lruvec_irq and its variants
> * [PATCH v3 04/30] mm: vmscan: prepare for the refactoring the move_folio=
s_to_lru()
> * [PATCH v3 05/30] mm: vmscan: refactor move_folios_to_lru()
> * [PATCH v3 06/30] mm: memcontrol: allocate object cgroup for non-kmem ca=
se
> * [PATCH v3 07/30] mm: memcontrol: return root object cgroup for root mem=
ory cgroup
> * [PATCH v3 08/30] mm: memcontrol: prevent memory cgroup release in get_m=
em_cgroup_from_folio()
> * [PATCH v3 09/30] buffer: prevent memory cgroup release in folio_alloc_b=
uffers()
> * [PATCH v3 10/30] writeback: prevent memory cgroup release in writeback =
module
> * [PATCH v3 11/30] mm: memcontrol: prevent memory cgroup release in count=
_memcg_folio_events()
> * [PATCH v3 12/30] mm: page_io: prevent memory cgroup release in page_io =
module
> * [PATCH v3 13/30] mm: migrate: prevent memory cgroup release in folio_mi=
grate_mapping()
> * [PATCH v3 14/30] mm: mglru: prevent memory cgroup release in mglru
> * [PATCH v3 15/30] mm: memcontrol: prevent memory cgroup release in mem_c=
group_swap_full()
> * [PATCH v3 16/30] mm: workingset: prevent memory cgroup release in lru_g=
en_eviction()
> * [PATCH v3 17/30] mm: thp: prevent memory cgroup release in folio_split_=
queue_lock{_irqsave}()
> * [PATCH v3 18/30] mm: zswap: prevent memory cgroup release in zswap_comp=
ress()
> * [PATCH v3 19/30] mm: workingset: prevent lruvec release in workingset_r=
efault()
> * [PATCH v3 20/30] mm: zswap: prevent lruvec release in zswap_folio_swapi=
n()
> * [PATCH v3 21/30] mm: swap: prevent lruvec release in lru_gen_clear_refs=
()
> * [PATCH v3 22/30] mm: workingset: prevent lruvec release in workingset_a=
ctivation()
> * [PATCH v3 23/30] mm: do not open-code lruvec lock
> * [PATCH v3 24/30] mm: memcontrol: prepare for reparenting LRU pages for =
lruvec lock
> * [PATCH v3 25/30] mm: vmscan: prepare for reparenting traditional LRU fo=
lios
> * [PATCH v3 26/30] mm: vmscan: prepare for reparenting MGLRU folios
> * [PATCH v3 27/30] mm: memcontrol: refactor memcg_reparent_objcgs()
> * [PATCH v3 28/30] mm: memcontrol: prepare for reparenting state_local
> * [PATCH v3 29/30] mm: memcontrol: eliminate the problem of dying memory =
cgroup for LRU folios
> * [PATCH v3 30/30] mm: lru: add VM_WARN_ON_ONCE_FOLIO to lru maintenance =
helpers
>
> and found the following issue:
> UBSAN: array-index-out-of-bounds in reparent_memcg_lruvec_state_local
>
> Full report is available here:
> https://ci.syzbot.org/series/45c0b58d-255a-4579-9880-497bdbd4fb99
>
> ***
>
> UBSAN: array-index-out-of-bounds in reparent_memcg_lruvec_state_local
>
> tree:      linux-next
> URL:       https://kernel.googlesource.com/pub/scm/linux/kernel/git/next/=
linux-next
> base:      b775e489bec70895b7ef6b66927886bbac79598f
> arch:      amd64
> compiler:  Debian clang version 21.1.8 (++20251221033036+2078da43e25a-1~e=
xp1~20251221153213.50), Debian LLD 21.1.8
> config:    https://ci.syzbot.org/builds/4d8819ab-0f94-42e8-bd70-87c7e83c3=
7d2/config
> syz repro: https://ci.syzbot.org/findings/7850f5dd-4ac7-4b74-85ff-a75dddd=
ebbee/syz_repro
>
> ------------[ cut here ]------------
> UBSAN: array-index-out-of-bounds in mm/memcontrol.c:530:3
> index 33 is out of range for type 'long[33]'
> CPU: 1 UID: 0 PID: 31 Comm: kworker/1:1 Not tainted syzkaller #0 PREEMPT(=
full)
> Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS 1.16.2-debian-1.=
16.2-1 04/01/2014
> Workqueue: cgroup_offline css_killed_work_fn
> Call Trace:
>  <TASK>
>  dump_stack_lvl+0xe8/0x150 lib/dump_stack.c:120
>  ubsan_epilogue+0xa/0x30 lib/ubsan.c:233
>  __ubsan_handle_out_of_bounds+0xe8/0xf0 lib/ubsan.c:455
>  reparent_memcg_lruvec_state_local+0x34f/0x460 mm/memcontrol.c:530
>  reparent_memcg1_lruvec_state_local+0xa7/0xc0 mm/memcontrol-v1.c:1917
>  reparent_state_local mm/memcontrol.c:242 [inline]
>  memcg_reparent_objcgs mm/memcontrol.c:299 [inline]
>  mem_cgroup_css_offline+0xc7c/0xc90 mm/memcontrol.c:4054
>  offline_css kernel/cgroup/cgroup.c:5760 [inline]
>  css_killed_work_fn+0x12f/0x570 kernel/cgroup/cgroup.c:6055
>  process_one_work+0x949/0x15a0 kernel/workqueue.c:3279
>  process_scheduled_works kernel/workqueue.c:3362 [inline]
>  worker_thread+0x9af/0xee0 kernel/workqueue.c:3443
>  kthread+0x388/0x470 kernel/kthread.c:467
>  ret_from_fork+0x51b/0xa40 arch/x86/kernel/process.c:158
>  ret_from_fork_asm+0x1a/0x30 arch/x86/entry/entry_64.S:246
>  </TASK>
> ---[ end trace ]---
> Kernel panic - not syncing: UBSAN: panic_on_warn set ...
> CPU: 1 UID: 0 PID: 31 Comm: kworker/1:1 Not tainted syzkaller #0 PREEMPT(=
full)
> Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS 1.16.2-debian-1.=
16.2-1 04/01/2014
> Workqueue: cgroup_offline css_killed_work_fn
> Call Trace:
>  <TASK>
>  vpanic+0x1e0/0x670 kernel/panic.c:490
>  panic+0xc5/0xd0 kernel/panic.c:627
>  check_panic_on_warn+0x89/0xb0 kernel/panic.c:377
>  __ubsan_handle_out_of_bounds+0xe8/0xf0 lib/ubsan.c:455
>  reparent_memcg_lruvec_state_local+0x34f/0x460 mm/memcontrol.c:530
>  reparent_memcg1_lruvec_state_local+0xa7/0xc0 mm/memcontrol-v1.c:1917
>  reparent_state_local mm/memcontrol.c:242 [inline]
>  memcg_reparent_objcgs mm/memcontrol.c:299 [inline]
>  mem_cgroup_css_offline+0xc7c/0xc90 mm/memcontrol.c:4054
>  offline_css kernel/cgroup/cgroup.c:5760 [inline]
>  css_killed_work_fn+0x12f/0x570 kernel/cgroup/cgroup.c:6055
>  process_one_work+0x949/0x15a0 kernel/workqueue.c:3279
>  process_scheduled_works kernel/workqueue.c:3362 [inline]
>  worker_thread+0x9af/0xee0 kernel/workqueue.c:3443
>  kthread+0x388/0x470 kernel/kthread.c:467
>  ret_from_fork+0x51b/0xa40 arch/x86/kernel/process.c:158
>  ret_from_fork_asm+0x1a/0x30 arch/x86/entry/entry_64.S:246
>  </TASK>
> Kernel Offset: disabled
> Rebooting in 86400 seconds..
>
>
> ***
>
> If these findings have caused you to resend the series or submit a
> separate fix, please add the following tag to your commit message:
>   Tested-by: syzbot@syzkaller.appspotmail.com
>
> ---
> This report is generated by a bot. It may contain errors.
> syzbot ci engineers can be reached at syzkaller@googlegroups.com.
>
> The email will later be sent to:
> [akpm@linux-foundation.org apais@linux.microsoft.com axelrasmussen@google=
.com cgroups@vger.kernel.org chengming.zhou@linux.dev chenridong@huawei.com=
 chenridong@huaweicloud.com david@kernel.org hamzamahfooz@linux.microsoft.c=
om hannes@cmpxchg.org harry.yoo@oracle.com hughd@google.com imran.f.khan@or=
acle.com kamalesh.babulal@oracle.com lance.yang@linux.dev linux-kernel@vger=
.kernel.org linux-mm@kvack.org lorenzo.stoakes@oracle.com mhocko@suse.com m=
koutny@suse.com muchun.song@linux.dev nphamcs@gmail.com qi.zheng@linux.dev =
roman.gushchin@linux.dev shakeel.butt@linux.dev songmuchun@bytedance.com we=
ixugc@google.com yosry.ahmed@linux.dev yuanchu@google.com zhengqi.arch@byte=
dance.com ziy@nvidia.com]
>
> If the report looks fine to you, reply with:
> #syz upstream
>
> If the report is a false positive, reply with
> #syz invalid
>
> --
> You received this message because you are subscribed to the Google Groups=
 "syzkaller-upstream-moderation" group.
> To unsubscribe from this group and stop receiving emails from it, send an=
 email to syzkaller-upstream-moderation+unsubscribe@googlegroups.com.
> To view this discussion visit https://groups.google.com/d/msgid/syzkaller=
-upstream-moderation/6967bd81.050a0220.150504.0005.GAE%40google.com.
