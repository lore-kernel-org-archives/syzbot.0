Received: from mail-oo1-f51.google.com (mail-oo1-f51.google.com [209.85.161.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E6BAE194A65
	for <syzbot@lists.linux.dev>; Tue, 28 Oct 2025 20:55:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.161.51
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761684957; cv=none; b=k070E3xZrR56BQRkK/2cz/id76ij1V+COhtclqxpnZnzq4ieqH/Iqac2iaKeTiRHqGJxI/gGvH64q3g5Zfa/IHFPk81FfSVj1Feji8T+41WYJX+uBSmBDi9UW0raSzJ9nhI7nY2Tdd2yjuJc98GnloduKPL7PSVgYXk6EYwSreg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761684957; c=relaxed/simple;
	bh=cUmQeq3BfnKjxUoEtDcYWXKiyxUpqOX8M7i6aTe4fk0=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=Il8yjMZGxlqYjyOXG4Cym/AA4IHZA6huC61KZSD9XmS+AVeOCh9IyQLd08YWkIT5lcy4KBjmgwgjCEH5cEHo0sCJRiq3QY/tuh/U6ulE3UgrtSbsjZYtIMeQpye+bKNI8/GMmJ2DQVhwNVUDEQmwdXd27+thKEwVEBdO0Rbn8Ig=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=aALiH30v; arc=none smtp.client-ip=209.85.161.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="aALiH30v"
Received: by mail-oo1-f51.google.com with SMTP id 006d021491bc7-654ee606fb5so1122717eaf.0
        for <syzbot@lists.linux.dev>; Tue, 28 Oct 2025 13:55:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1761684955; x=1762289755; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=xseD5Xi/p93N7VP3pUYxX9BZjy26Sk9yviR7TAzYIXA=;
        b=aALiH30voTBxWR5Qjx0EWjfBG21froqL2CQPBfjyyWR0PIvjw/wswYArCQRfT5WmfJ
         EIXqH14sUphuSXWHJSgQOC4aoWU4wc6gY03JYpymbqoCBNnWIosCR6jgEnEDNV9g5llG
         QA2Aop47u84oMmNmPLjgY2XLFKFPUMHDoEBJt/YE4vAFWmhMqC5q1UVR4Mr8fcfJOcV5
         s+AZ+llA5LI4nc3XtMvKr9HrMZnoj1n/IB+q5npauIvA1sQQInzc95llPkdrNP91tAaS
         +wlECuhydET2zA0OY7MG4p6A9bhTSVHUKPXO0MNEBL1CjRssnx553Bl8ymK71fzujsV+
         UeuQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1761684955; x=1762289755;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=xseD5Xi/p93N7VP3pUYxX9BZjy26Sk9yviR7TAzYIXA=;
        b=W7elaPe5G/m9UokCT1qoNn80E5qHplQ0/tT4/uv85YCaT3xCG0K9ctLr1VOsZOxxU3
         laMyklB97vywZ4GEAyVLcRpTh934TWSkIGCwHQ8v6aWKnzHmEYABeKG74GMcP1ykhQQJ
         OX2HnM/+xeeMxfdgvSf0T2cI2dEmpg1aSYpeWEkv4BrWUQZXnruJjrlj3KyqdfmG5gd0
         PSiJPpboxOzJoJ8aFHWCQ7WEUDNvCwfmTD3bx6/Zf0k0mSNmKd3Hk2NoDrdU4awYbyub
         1Zf8UTxgrnN+jHSQC1zGyisldvkTEHl7qtb8qyK2TdQQ/UBXqKo9/EeRgwRlz5vRrmfH
         rWng==
X-Forwarded-Encrypted: i=1; AJvYcCURYjKQGrfgEQGj+4GWkjsXCdyNjVW5UrpUbFu2PZ64p299aA4aBOO3aa8KEPizGVzZ9mknkXs=@lists.linux.dev
X-Gm-Message-State: AOJu0YxePs8/mNAsxxlj9KTYBsZmxfSCK0A8nWLj8DoWmY1k5KvwGz61
	ISnKoCfsCKodcIvScEugUaxECWSgFsERC6bWBwWJmODP8DRWgrqG+6Mk7iJ3OijtXiIwWOheI94
	Al3vlMt/d+KbkgZRwdTiQVYxFP7zJI4MZSYe5myeo
X-Gm-Gg: ASbGncsD6ceUjSe+9Pi2/4oF9FmObr6b/l7fm27YD5Mzsw7wG21r06Z4z3p47ZSFiTF
	dumf8/9w+Znc8hhiPeTjtsrvBHJwQI5Wb8i4y4MgDwOAQxXth1jgNsFghQRAJvU/tdGDGONe7lV
	PYJeB1IgdfQFf1iEvi1j+F9bNf6gHgd+KnlpJWXTsWL/kQgShwau8p67y0BpQD8WbeIMUr4jdpX
	wzNDm1pw1nIR7BrfDkGLgUvHAycgcoxIJe5aHjLihIEOkqfdx1eipIXRq5IdY9ycidBOn1K6g4G
	WNsqJntc2k8KIqEm
X-Google-Smtp-Source: AGHT+IHpc5lroB56CQ2AvIGkTrGFJRPXN8qQAeuy06ZP6xYoHvUGwle2AXiSEn06z5AGXRoCA/YTbbx5t87CdSJGeCM=
X-Received: by 2002:a05:6808:4447:b0:442:e596:1189 with SMTP id
 5614622812f47-44f7a89142amr419604b6e.45.1761684954719; Tue, 28 Oct 2025
 13:55:54 -0700 (PDT)
Precedence: bulk
X-Mailing-List: syzbot@lists.linux.dev
List-Id: <syzbot.lists.linux.dev>
List-Subscribe: <mailto:syzbot+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:syzbot+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <6901058d.050a0220.3344a1.03bd.GAE@google.com>
In-Reply-To: <6901058d.050a0220.3344a1.03bd.GAE@google.com>
From: Aleksandr Nogikh <nogikh@google.com>
Date: Tue, 28 Oct 2025 21:55:42 +0100
X-Gm-Features: AWmQ_bmGhT8nZifg0bdqWhNaSBzYBI1abrwZajDlu3sMmi6ohP72BNMzXkr-oew
Message-ID: <CANp29Y77pjLt2huaBje0h9bNiB_Qf9QEVuoOo1jLpxio60reGA@mail.gmail.com>
Subject: Re: [moderation/CI] Re: Eliminate Dying Memory Cgroup
To: syzbot ci <syzbot+cia7c4c258eb33cb2e@syzkaller.appspotmail.com>
Cc: syzkaller-upstream-moderation@googlegroups.com, syzbot@lists.linux.dev
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

#syz upstream


On Tue, Oct 28, 2025 at 7:04=E2=80=AFPM syzbot ci
<syzbot+cia7c4c258eb33cb2e@syzkaller.appspotmail.com> wrote:
>
> syzbot ci has tested the following series
>
> [v1] Eliminate Dying Memory Cgroup
> https://lore.kernel.org/all/cover.1761658310.git.zhengqi.arch@bytedance.c=
om
> * [PATCH v1 01/26] mm: memcontrol: remove dead code of checking parent me=
mory cgroup
> * [PATCH v1 02/26] mm: workingset: use folio_lruvec() in workingset_refau=
lt()
> * [PATCH v1 03/26] mm: rename unlock_page_lruvec_irq and its variants
> * [PATCH v1 04/26] mm: vmscan: refactor move_folios_to_lru()
> * [PATCH v1 05/26] mm: memcontrol: allocate object cgroup for non-kmem ca=
se
> * [PATCH v1 06/26] mm: memcontrol: return root object cgroup for root mem=
ory cgroup
> * [PATCH v1 07/26] mm: memcontrol: prevent memory cgroup release in get_m=
em_cgroup_from_folio()
> * [PATCH v1 08/26] buffer: prevent memory cgroup release in folio_alloc_b=
uffers()
> * [PATCH v1 09/26] writeback: prevent memory cgroup release in writeback =
module
> * [PATCH v1 10/26] mm: memcontrol: prevent memory cgroup release in count=
_memcg_folio_events()
> * [PATCH v1 11/26] mm: page_io: prevent memory cgroup release in page_io =
module
> * [PATCH v1 12/26] mm: migrate: prevent memory cgroup release in folio_mi=
grate_mapping()
> * [PATCH v1 13/26] mm: mglru: prevent memory cgroup release in mglru
> * [PATCH v1 14/26] mm: memcontrol: prevent memory cgroup release in mem_c=
group_swap_full()
> * [PATCH v1 15/26] mm: workingset: prevent memory cgroup release in lru_g=
en_eviction()
> * [PATCH v1 16/26] mm: thp: prevent memory cgroup release in folio_split_=
queue_lock{_irqsave}()
> * [PATCH v1 17/26] mm: workingset: prevent lruvec release in workingset_r=
efault()
> * [PATCH v1 18/26] mm: zswap: prevent lruvec release in zswap_folio_swapi=
n()
> * [PATCH v1 19/26] mm: swap: prevent lruvec release in swap module
> * [PATCH v1 20/26] mm: workingset: prevent lruvec release in workingset_a=
ctivation()
> * [PATCH v1 21/26] mm: memcontrol: prepare for reparenting LRU pages for =
lruvec lock
> * [PATCH v1 22/26] mm: vmscan: prepare for reparenting traditional LRU fo=
lios
> * [PATCH v1 23/26] mm: vmscan: prepare for reparenting MGLRU folios
> * [PATCH v1 24/26] mm: memcontrol: refactor memcg_reparent_objcgs()
> * [PATCH v1 25/26] mm: memcontrol: eliminate the problem of dying memory =
cgroup for LRU folios
> * [PATCH v1 26/26] mm: lru: add VM_WARN_ON_ONCE_FOLIO to lru maintenance =
helpers
>
> and found the following issue:
> WARNING in folio_memcg
>
> Full report is available here:
> https://ci.syzbot.org/series/0d48a77a-fb4f-485d-9fd6-086afd6fb650
>
> ***
>
> WARNING in folio_memcg
>
> tree:      mm-new
> URL:       https://kernel.googlesource.com/pub/scm/linux/kernel/git/akpm/=
mm.git
> base:      b227c04932039bccc21a0a89cd6df50fa57e4716
> arch:      amd64
> compiler:  Debian clang version 20.1.8 (++20250708063551+0c9f909b7976-1~e=
xp1~20250708183702.136), Debian LLD 20.1.8
> config:    https://ci.syzbot.org/builds/503d7034-ae99-44d1-8fb2-62e7ef5e1=
c7c/config
> C repro:   https://ci.syzbot.org/findings/880c374a-1b49-436e-9be2-63d5e2c=
6b6ab/c_repro
> syz repro: https://ci.syzbot.org/findings/880c374a-1b49-436e-9be2-63d5e2c=
6b6ab/syz_repro
>
> exFAT-fs (loop0): failed to load upcase table (idx : 0x00010000, chksum :=
 0xe5674ec2, utbl_chksum : 0xe619d30d)
> exFAT-fs (loop0): failed to load alloc-bitmap
> exFAT-fs (loop0): failed to recognize exfat type
> ------------[ cut here ]------------
> WARNING: CPU: 1 PID: 5965 at ./include/linux/memcontrol.h:380 obj_cgroup_=
memcg include/linux/memcontrol.h:380 [inline]
> WARNING: CPU: 1 PID: 5965 at ./include/linux/memcontrol.h:380 folio_memcg=
+0x148/0x1c0 include/linux/memcontrol.h:434
> Modules linked in:
> CPU: 1 UID: 0 PID: 5965 Comm: syz.0.17 Not tainted syzkaller #0 PREEMPT(f=
ull)
> Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS 1.16.2-debian-1.=
16.2-1 04/01/2014
> RIP: 0010:obj_cgroup_memcg include/linux/memcontrol.h:380 [inline]
> RIP: 0010:folio_memcg+0x148/0x1c0 include/linux/memcontrol.h:434
> Code: 48 c1 e8 03 42 80 3c 20 00 74 08 48 89 df e8 5f c8 06 00 48 8b 03 5=
b 41 5c 41 5e 41 5f 5d e9 cf 89 2a 09 cc e8 a9 bb a0 ff 90 <0f> 0b 90 eb ca=
 44 89 f9 80 e1 07 80 c1 03 38 c1 0f 8c ef fe ff ff
> RSP: 0018:ffffc90003ec66b0 EFLAGS: 00010293
> RAX: ffffffff821f4b57 RBX: ffff888108b31480 RCX: ffff88816be91d00
> RDX: 0000000000000000 RSI: 0000000000000000 RDI: 0000000000000000
> RBP: 0000000000000000 R08: ffff88816be91d00 R09: 0000000000000002
> R10: 00000000fffffff0 R11: 0000000000000000 R12: dffffc0000000000
> R13: 00000000ffffffe4 R14: ffffea0006d5f840 R15: ffffea0006d5f870
> FS:  000055555db87500(0000) GS:ffff8882a9f35000(0000) knlGS:0000000000000=
000
> CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> CR2: 0000001b2ee63fff CR3: 000000010c308000 CR4: 00000000000006f0
> Call Trace:
>  <TASK>
>  zswap_compress mm/zswap.c:900 [inline]
>  zswap_store_page mm/zswap.c:1430 [inline]
>  zswap_store+0xfa2/0x1f80 mm/zswap.c:1541
>  swap_writeout+0x6e8/0xf20 mm/page_io.c:275
>  writeout mm/vmscan.c:651 [inline]
>  pageout mm/vmscan.c:699 [inline]
>  shrink_folio_list+0x34ec/0x4c40 mm/vmscan.c:1418
>  reclaim_folio_list+0xeb/0x500 mm/vmscan.c:2196
>  reclaim_pages+0x454/0x520 mm/vmscan.c:2233
>  madvise_cold_or_pageout_pte_range+0x1974/0x1d00 mm/madvise.c:565
>  walk_pmd_range mm/pagewalk.c:130 [inline]
>  walk_pud_range mm/pagewalk.c:224 [inline]
>  walk_p4d_range mm/pagewalk.c:262 [inline]
>  walk_pgd_range+0xfe9/0x1d40 mm/pagewalk.c:303
>  __walk_page_range+0x14c/0x710 mm/pagewalk.c:410
>  walk_page_range_vma+0x393/0x440 mm/pagewalk.c:717
>  madvise_pageout_page_range mm/madvise.c:624 [inline]
>  madvise_pageout mm/madvise.c:649 [inline]
>  madvise_vma_behavior+0x311f/0x3a10 mm/madvise.c:1352
>  madvise_walk_vmas+0x51c/0xa30 mm/madvise.c:1669
>  madvise_do_behavior+0x38e/0x550 mm/madvise.c:1885
>  do_madvise+0x1bc/0x270 mm/madvise.c:1978
>  __do_sys_madvise mm/madvise.c:1987 [inline]
>  __se_sys_madvise mm/madvise.c:1985 [inline]
>  __x64_sys_madvise+0xa7/0xc0 mm/madvise.c:1985
>  do_syscall_x64 arch/x86/entry/syscall_64.c:63 [inline]
>  do_syscall_64+0xfa/0xfa0 arch/x86/entry/syscall_64.c:94
>  entry_SYSCALL_64_after_hwframe+0x77/0x7f
> RIP: 0033:0x7fccac38efc9
> Code: ff ff c3 66 2e 0f 1f 84 00 00 00 00 00 0f 1f 40 00 48 89 f8 48 89 f=
7 48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 ff=
 ff 73 01 c3 48 c7 c1 a8 ff ff ff f7 d8 64 89 01 48
> RSP: 002b:00007ffd9cc58708 EFLAGS: 00000246 ORIG_RAX: 000000000000001c
> RAX: ffffffffffffffda RBX: 00007fccac5e5fa0 RCX: 00007fccac38efc9
> RDX: 0000000000000015 RSI: 7fffffffffffffff RDI: 0000200000000000
> RBP: 00007fccac411f91 R08: 0000000000000000 R09: 0000000000000000
> R10: 0000000000000000 R11: 0000000000000246 R12: 0000000000000000
> R13: 00007fccac5e5fa0 R14: 00007fccac5e5fa0 R15: 0000000000000003
>  </TASK>
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
> [akpm@linux-foundation.org axelrasmussen@google.com cgroups@vger.kernel.o=
rg chengming.zhou@linux.dev david@redhat.com hannes@cmpxchg.org harry.yoo@o=
racle.com hughd@google.com imran.f.khan@oracle.com kamalesh.babulal@oracle.=
com linux-kernel@vger.kernel.org linux-mm@kvack.org lorenzo.stoakes@oracle.=
com mhocko@suse.com muchun.song@linux.dev nphamcs@gmail.com qi.zheng@linux.=
dev roman.gushchin@linux.dev shakeel.butt@linux.dev songmuchun@bytedance.co=
m weixugc@google.com yuanchu@google.com zhengqi.arch@bytedance.com ziy@nvid=
ia.com]
>
> If the report looks fine to you, reply with:
> #syz upstream
>
> --
> You received this message because you are subscribed to the Google Groups=
 "syzkaller-upstream-moderation" group.
> To unsubscribe from this group and stop receiving emails from it, send an=
 email to syzkaller-upstream-moderation+unsubscribe@googlegroups.com.
> To view this discussion visit https://groups.google.com/d/msgid/syzkaller=
-upstream-moderation/6901058d.050a0220.3344a1.03bd.GAE%40google.com.
