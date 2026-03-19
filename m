Received: from mail-oa1-f47.google.com (mail-oa1-f47.google.com [209.85.160.47])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 430D7402B81
	for <syzbot@lists.linux.dev>; Thu, 19 Mar 2026 21:34:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.160.47
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773956089; cv=pass; b=W8igxhT9OvrsaOJmg1Nn17ofPzIOaSjMjRmC6zgCygyhoBPYSgXrdFGAj91iD/MExv2l5QA6pOFv8arDTZK1+5k5DBJ7CczgHUynL75BDlkhyKVrv0BHaC0rLxATDZmD9ooEDE9gQ+s6US57BcoEfRJTtcQysvb/wHrpC3AoeOY=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773956089; c=relaxed/simple;
	bh=HqCPx9/oumq2l128xNR61gs2DT6899XysCc9UW0uW5E=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=sd9H/h+0uTYnw7n6NounBoH8D+AVjjdi41hPEtwSS4G6P1Edrf/W8zhSjoOpjlB9LxDLZwK5KZMjwyKXSZ8Ia5voKWonfLVta7fSA9B3phSnXuqwz0bW3cE/wRb9o/UvSrPSazzuyZpsGIIEDPy244e1oBrtPWdhzRkjfns1r20=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=h84zbNdj; arc=pass smtp.client-ip=209.85.160.47
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="h84zbNdj"
Received: by mail-oa1-f47.google.com with SMTP id 586e51a60fabf-41576c5c01cso922652fac.3
        for <syzbot@lists.linux.dev>; Thu, 19 Mar 2026 14:34:45 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1773956084; cv=none;
        d=google.com; s=arc-20240605;
        b=gdcu7FX/PwxAA+rlOebonComSTh6cwsjjnSakc6IC7O/piX+YPIK9EAcAywmGBC9Ze
         V5Bl9OczBELEAfouLST4qNAtvDYAjRzr2jNYuPLQ8JhtmDx2ja4oP/9YbwZgPaQoRQNM
         6/iDxfiQOcrx2iPQ4Gq4IrN1yAIggWWPlqEnfAJZanCvOaruLpsnaDDEKja7pMG4SqGJ
         JdMxalvrR4Nw+sLJO1y2qs/Ocksz+nvhUK0f19xQ+QJOE09bzTnVNKR7V+YPyVwgrUAo
         XGKGZ/SWh4dqv+UskgSw35WugDLyIIai4lVuz0VqABne4uPXVtgPULzUtP5VAQ3ryp1O
         vFig==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=gPohPyJCE+yDDhMJoW4v+E8IsY3asbouGCmacuX6wKY=;
        fh=KrkwCZm0xC92Cg2R8P/WtAVoXZI6m9NE47n8eyMhJ30=;
        b=bjNuBtb39JU4nXa4gG+22QEtvPCKffO1fzs4Xrpy24Sk1zxPRrrxS77X9xwXzVT5rS
         DHI1b/ISPhOa8pmvAm9K6y+jBJFYieu8ICyBQNta3OPoSQCtemzKlmMXsJAOQKsgwNiT
         hBRSWSPqe+L9X78PaFjGPWT+oS6C7eRRQyyf8ps1KvFuP+i5xB9UO61J1F25FXFZyYaH
         2hqhu6ga8c2Y0COlFyVFNCqNaFRh5wJkF8mMYs2nk3Z5gLjG9YOz0J7aPQ6QGbsDAJZT
         pgURjYi8Bn/i1rNQdEHT15J999JdW+Xfz0lwV5TLiD/3zqW0TrHDiBeZIB+bmmrUXDU4
         iUBw==;
        darn=lists.linux.dev
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1773956084; x=1774560884; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=gPohPyJCE+yDDhMJoW4v+E8IsY3asbouGCmacuX6wKY=;
        b=h84zbNdjOX7VSu8nbGpDcCe3LwNX61X8vk4ixneREPWnlQlZbsomiD7xGNiNCCACSa
         6upATlRC2NbU8QoDlnjwQq3Rpbr7t3Xq4ivU3osa/sjDEDtllKQoepp786iaqQc/XtGY
         l1NMBD1HY44zt5/RPWoXq8jwATa30rqnuTMcU4haayF469i7wurQnrYYJ06cXa8BJNAc
         /wo8loVU2lMyPx2BRTRNA6vMGCz6qKLRPcLX96DlGRUeNcp86LN9kwe8Rf5NseARJPq7
         Xt8cocm0A3c+Qszcg8EUmtz49sEDvcTU+J3AJvLERVEEWk8ShyZ75YpvGWOtH9BYqs9Y
         insA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1773956084; x=1774560884;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=gPohPyJCE+yDDhMJoW4v+E8IsY3asbouGCmacuX6wKY=;
        b=IQy6xtxqi6svgNcVkrGufG1CxNMI/G9z8Sl0dx26xwtpeD4vqJo92x5fPuLLPFqKj7
         H2g02dHCoKK3R+V+owDfh9yhifZ65byUvFLkvkLsAoRYAYgm4vcCSgqB1QpWQANmcy9w
         3RdPzyj4po1Vge0yf0rOGQHh4j90mcLdlWn/Lp4fOyD7rU808cIM9UXqoKBskNeG/0lK
         Uvlc/NbVTfIMQk6IZ0CzoCTF0NMMLNY6JixSnuvHnp/QfHgFoHwBD6f0Ljm6yWVIXwX0
         qzIjsrDe1DbvWNK65Uyr61sT776rNn5XEwf4yqbDHQXFr+oRLTpzthKV8HTqWnGfrDd5
         mtDQ==
X-Forwarded-Encrypted: i=1; AJvYcCVwhtlBag1IGO2D9ivdvK+DiD3/8UdL7ldo5J9cTWKZbA+gTpUqjrQbswF8OOZwMkMLhQNa6pk=@lists.linux.dev
X-Gm-Message-State: AOJu0Yz5xU0vA+JRKCD4xZEW8sZxYwE4TD4VKwmJjk3dh3kSaIsAav63
	A2v7Nl+6tnJUZlHq3uTyKgZleb2pTuRxm7V83CIgrxyzg99SroqutWRQX5yKm0aGfjrUX7X39VM
	MbwysZ884pRHg16gM/mjeUWIOw0B86+Lg+xIIZjvi
X-Gm-Gg: ATEYQzy4Ywyni6qzKJ0bkvtDhAkBh7cCmZpYeV8tL92xGWBWO7065/zEsnO3BQplLyn
	Hd5wRPt6VbmPcpzxGxy6XI7QPpWTP4UBoqFgSNv5jFsxmTXGpfQ1Qu6bRiqJ+jLrvlgtGkBMJ/8
	CpAb4EN5SAYtAD13sjaOuCAIZMt1g+5CYHkFmyRLOr/Ykj7sKBR4Lhw2sTi+iWUMk/9AHatBRHR
	piNzxPlFmt0wVMV5O5KCc+ndEESUWfCLrWNIoMYxn4ybnZHVta2ey7rpGOCLNZdfIu/SIGhDs6b
	QwAXvk5i2VQtvpikcN8G5CnVR2EI8kUB9qyc8smTxw3cnWQXjkOO5jjfXJtmoxqMPvVal3eV
X-Received: by 2002:a05:6870:490:b0:409:bd2b:91a3 with SMTP id
 586e51a60fabf-41c11226804mr540104fac.32.1773956083410; Thu, 19 Mar 2026
 14:34:43 -0700 (PDT)
Precedence: bulk
X-Mailing-List: syzbot@lists.linux.dev
List-Id: <syzbot.lists.linux.dev>
List-Subscribe: <mailto:syzbot+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:syzbot+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <69bc5047.050a0220.29e68b.000b.GAE@google.com>
In-Reply-To: <69bc5047.050a0220.29e68b.000b.GAE@google.com>
From: Aleksandr Nogikh <nogikh@google.com>
Date: Thu, 19 Mar 2026 22:34:31 +0100
X-Gm-Features: AaiRm50NK7hOnajxtWJ_Uk91QWQKtJ7pK019i1YWDBsg5-C5881Ln8_BZ7kRch4
Message-ID: <CANp29Y7_RzCeDom8T2NiDCihuayfcxGktMfanWnpwnDFFji5Hw@mail.gmail.com>
Subject: Re: [moderation/CI] Re: Virtual Swap Space
To: syzbot ci <syzbot+ci80b9ac1c24010dcc@syzkaller.appspotmail.com>
Cc: syzkaller-upstream-moderation@googlegroups.com, syzbot@lists.linux.dev
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

#syz upstream

On Thu, Mar 19, 2026 at 8:36=E2=80=AFPM syzbot ci
<syzbot+ci80b9ac1c24010dcc@syzkaller.appspotmail.com> wrote:
>
> syzbot ci has tested the following series
>
> [v4] Virtual Swap Space
> https://lore.kernel.org/all/20260318222953.441758-1-nphamcs@gmail.com
> * [PATCH v4 01/21] mm/swap: decouple swap cache from physical swap infras=
tructure
> * [PATCH v4 02/21] swap: rearrange the swap header file
> * [PATCH v4 03/21] mm: swap: add an abstract API for locking out swapoff
> * [PATCH v4 04/21] zswap: add new helpers for zswap entry operations
> * [PATCH v4 05/21] mm/swap: add a new function to check if a swap entry i=
s in swap cached.
> * [PATCH v4 06/21] mm: swap: add a separate type for physical swap slots
> * [PATCH v4 07/21] mm: create scaffolds for the new virtual swap implemen=
tation
> * [PATCH v4 08/21] zswap: prepare zswap for swap virtualization
> * [PATCH v4 09/21] mm: swap: allocate a virtual swap slot for each swappe=
d out page
> * [PATCH v4 10/21] swap: move swap cache to virtual swap descriptor
> * [PATCH v4 11/21] zswap: move zswap entry management to the virtual swap=
 descriptor
> * [PATCH v4 12/21] swap: implement the swap_cgroup API using virtual swap
> * [PATCH v4 13/21] swap: manage swap entry lifecycle at the virtual swap =
layer
> * [PATCH v4 14/21] mm: swap: decouple virtual swap slot from backing stor=
e
> * [PATCH v4 15/21] zswap: do not start zswap shrinker if there is no phys=
ical swap slots
> * [PATCH v4 16/21] swap: do not unnecesarily pin readahead swap entries
> * [PATCH v4 17/21] swapfile: remove zeromap bitmap
> * [PATCH v4 18/21] memcg: swap: only charge physical swap slots
> * [PATCH v4 19/21] swap: simplify swapoff using virtual swap
> * [PATCH v4 20/21] swapfile: replace the swap map with bitmaps
> * [PATCH v4 21/21] vswap: batch contiguous vswap free calls
>
> and found the following issue:
> possible deadlock in vswap_iter
>
> Full report is available here:
> https://ci.syzbot.org/series/f8238a2a-370e-404d-b3f7-5945b574bd63
>
> ***
>
> possible deadlock in vswap_iter
>
> tree:      bpf-next
> URL:       https://kernel.googlesource.com/pub/scm/linux/kernel/git/bpf/b=
pf-next.git
> base:      05f7e89ab9731565d8a62e3b5d1ec206485eeb0b
> arch:      amd64
> compiler:  Debian clang version 21.1.8 (++20251221033036+2078da43e25a-1~e=
xp1~20251221153213.50), Debian LLD 21.1.8
> config:    https://ci.syzbot.org/builds/cf1517a6-d391-46d8-bfbe-98e6be6b9=
3ce/config
> syz repro: https://ci.syzbot.org/findings/b4e84ae7-17d4-4bf8-9c3f-4c13b10=
a1e52/syz_repro
>
> =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
> WARNING: possible recursive locking detected
> syzkaller #0 Not tainted
> --------------------------------------------
> syz.1.18/6001 is trying to acquire lock:
> ffff88811fba0018 (&cluster->lock){+.+.}-{3:3}, at: spin_lock include/linu=
x/spinlock.h:351 [inline]
> ffff88811fba0018 (&cluster->lock){+.+.}-{3:3}, at: vswap_iter+0xfa/0x1b0 =
mm/vswap.c:274
>
> but task is already holding lock:
> ffff88811fba0018 (&cluster->lock){+.+.}-{3:3}, at: spin_lock_irq include/=
linux/spinlock.h:376 [inline]
> ffff88811fba0018 (&cluster->lock){+.+.}-{3:3}, at: swap_cache_lock_irq+0x=
e2/0x190 mm/vswap.c:1529
>
> other info that might help us debug this:
>  Possible unsafe locking scenario:
>
>        CPU0
>        ----
>   lock(&cluster->lock);
>   lock(&cluster->lock);
>
>  *** DEADLOCK ***
>
>  May be due to missing lock nesting notation
>
> 3 locks held by syz.1.18/6001:
>  #0: ffff8881bb523440 (&mm->mmap_lock){++++}-{4:4}, at: mmap_read_lock in=
clude/linux/mmap_lock.h:391 [inline]
>  #0: ffff8881bb523440 (&mm->mmap_lock){++++}-{4:4}, at: madvise_lock+0x15=
2/0x2e0 mm/madvise.c:1789
>  #1: ffff88811fba0018 (&cluster->lock){+.+.}-{3:3}, at: spin_lock_irq inc=
lude/linux/spinlock.h:376 [inline]
>  #1: ffff88811fba0018 (&cluster->lock){+.+.}-{3:3}, at: swap_cache_lock_i=
rq+0xe2/0x190 mm/vswap.c:1529
>  #2: ffffffff8e55a360 (rcu_read_lock){....}-{1:3}, at: rcu_lock_acquire i=
nclude/linux/rcupdate.h:331 [inline]
>  #2: ffffffff8e55a360 (rcu_read_lock){....}-{1:3}, at: rcu_read_lock incl=
ude/linux/rcupdate.h:867 [inline]
>  #2: ffffffff8e55a360 (rcu_read_lock){....}-{1:3}, at: vswap_cgroup_recor=
d+0x41/0x440 mm/vswap.c:1909
>
> stack backtrace:
> CPU: 0 UID: 0 PID: 6001 Comm: syz.1.18 Not tainted syzkaller #0 PREEMPT(f=
ull)
> Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS 1.16.2-debian-1.=
16.2-1 04/01/2014
> Call Trace:
>  <TASK>
>  dump_stack_lvl+0xe8/0x150 lib/dump_stack.c:120
>  print_deadlock_bug+0x279/0x290 kernel/locking/lockdep.c:3041
>  check_deadlock kernel/locking/lockdep.c:3093 [inline]
>  validate_chain kernel/locking/lockdep.c:3895 [inline]
>  __lock_acquire+0x253f/0x2cf0 kernel/locking/lockdep.c:5237
>  lock_acquire+0x106/0x330 kernel/locking/lockdep.c:5868
>  __raw_spin_lock include/linux/spinlock_api_smp.h:133 [inline]
>  _raw_spin_lock+0x2e/0x40 kernel/locking/spinlock.c:154
>  spin_lock include/linux/spinlock.h:351 [inline]
>  vswap_iter+0xfa/0x1b0 mm/vswap.c:274
>  vswap_cgroup_record+0xeb/0x440 mm/vswap.c:1910
>  swap_cgroup_record+0xc5/0x130 mm/vswap.c:1933
>  memcg1_swapout+0x358/0x9e0 mm/memcontrol-v1.c:623
>  __remove_mapping+0x7d4/0xa70 mm/vmscan.c:762
>  shrink_folio_list+0x287c/0x5160 mm/vmscan.c:1518
>  reclaim_folio_list+0x100/0x400 mm/vmscan.c:2198
>  reclaim_pages+0x45b/0x530 mm/vmscan.c:2235
>  madvise_cold_or_pageout_pte_range+0x1eac/0x2220 mm/madvise.c:444
>  walk_pmd_range mm/pagewalk.c:130 [inline]
>  walk_pud_range mm/pagewalk.c:224 [inline]
>  walk_p4d_range mm/pagewalk.c:262 [inline]
>  walk_pgd_range+0x1032/0x1d30 mm/pagewalk.c:303
>  __walk_page_range+0x14c/0x710 mm/pagewalk.c:410
>  walk_page_range_vma_unsafe+0x309/0x410 mm/pagewalk.c:714
>  madvise_pageout_page_range mm/madvise.c:622 [inline]
>  madvise_pageout mm/madvise.c:647 [inline]
>  madvise_vma_behavior+0x2951/0x43c0 mm/madvise.c:1366
>  madvise_walk_vmas+0x57a/0xaf0 mm/madvise.c:1721
>  madvise_do_behavior+0x386/0x540 mm/madvise.c:1937
>  do_madvise+0x1fa/0x2e0 mm/madvise.c:2030
>  __do_sys_madvise mm/madvise.c:2039 [inline]
>  __se_sys_madvise mm/madvise.c:2037 [inline]
>  __x64_sys_madvise+0xa6/0xc0 mm/madvise.c:2037
>  do_syscall_x64 arch/x86/entry/syscall_64.c:63 [inline]
>  do_syscall_64+0xe2/0xf80 arch/x86/entry/syscall_64.c:94
>  entry_SYSCALL_64_after_hwframe+0x77/0x7f
> RIP: 0033:0x7f2b3459c799
> Code: ff c3 66 2e 0f 1f 84 00 00 00 00 00 0f 1f 44 00 00 48 89 f8 48 89 f=
7 48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 ff=
 ff 73 01 c3 48 c7 c1 e8 ff ff ff f7 d8 64 89 01 48
> RSP: 002b:00007f2b35495028 EFLAGS: 00000246 ORIG_RAX: 000000000000001c
> RAX: ffffffffffffffda RBX: 00007f2b34815fa0 RCX: 00007f2b3459c799
> RDX: 0000000000000015 RSI: 0000000000600000 RDI: 0000200000000000
> RBP: 00007f2b34632c99 R08: 0000000000000000 R09: 0000000000000000
> R10: 0000000000000000 R11: 0000000000000246 R12: 0000000000000000
> R13: 00007f2b34816038 R14: 00007f2b34815fa0 R15: 00007ffcfbbae8f8
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
> [akpm@linux-foundation.org apopple@nvidia.com axelrasmussen@google.com ba=
ohua@kernel.org baolin.wang@linux.alibaba.com bhe@redhat.com byungchul@sk.c=
om cgroups@vger.kernel.org chengming.zhou@linux.dev chrisl@kernel.org corbe=
t@lwn.net david@kernel.org dev.jain@arm.com gourry@gourry.net hannes@cmpxch=
g.org hughd@google.com jannh@google.com joshua.hahnjy@gmail.com kasong@tenc=
ent.com kernel-team@meta.com lance.yang@linux.dev lenb@kernel.org liam.howl=
ett@oracle.com linux-doc@vger.kernel.org linux-kernel@vger.kernel.org linux=
-mm@kvack.org linux-pm@vger.kernel.org lorenzo.stoakes@oracle.com matthew.b=
rost@intel.com mhocko@suse.com muchun.song@linux.dev npache@redhat.com npha=
mcs@gmail.com pavel@kernel.org peterx@redhat.com peterz@infradead.org pfalc=
ato@suse.de rafael@kernel.org rakie.kim@sk.com riel@surriel.com roman.gushc=
hin@linux.dev rppt@kernel.org ryan.roberts@arm.com shakeel.butt@linux.dev s=
hikemeng@huaweicloud.com surenb@google.com tglx@kernel.org vbabka@suse.cz w=
eixugc@google.com ying.huang@linux.alibaba.com]
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
-upstream-moderation/69bc5047.050a0220.29e68b.000b.GAE%40google.com.
