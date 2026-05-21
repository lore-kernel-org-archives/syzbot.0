Received: from mail-oo1-f51.google.com (mail-oo1-f51.google.com [209.85.161.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D9B7323E330
	for <syzbot@lists.linux.dev>; Thu, 21 May 2026 07:37:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.161.51
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779349068; cv=pass; b=OlP10SWgHok7ArOt4Dc8kaWdv6pYGZpG97DDECmcvGt5vXuxTTaN13NwUA3N3RpBLym2EIWeswvK27wjVf5iR0wFXsanY1BEXkXUeu2yAB9eE9l+TwVNuhgXFaZfyglVv5CPZSAjrGf+F20EaZJFrbV34PgI01BBF5VmMAO+iqo=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779349068; c=relaxed/simple;
	bh=vhtT2ixLs3nkDSggyV02ry50+M33RHGPIiqTgNcNeg4=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=r1W5qmOQS2r7RIkaTyE2q/cS8k/r7wqKZ61Rh/gT8RqbSLTxfz1qprpGjBgzuJX7sQqrCPnITYy8imp9SDHttjNVqYfHyxFyRUedURNN+t/BP8wCTTRz+vvbAMsSXT20la0BtuK2iCBm8HNrlc6x1vL7nyrgrJDymFoz1gOeObM=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=oXQXlPTr; arc=pass smtp.client-ip=209.85.161.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="oXQXlPTr"
Received: by mail-oo1-f51.google.com with SMTP id 006d021491bc7-6841e6a5e51so2887443eaf.3
        for <syzbot@lists.linux.dev>; Thu, 21 May 2026 00:37:46 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1779349066; cv=none;
        d=google.com; s=arc-20240605;
        b=GC+b4pcxZwk1T77xr6hbpZKKbhZ0HT5uiVmAjeME8QTw7+bQfZE9hp8ZGy2kpvl6Dx
         DM/AE3yZQFIElWVV3W8IIPz8v/9KuHqrPFzpijkukjll3Km37tHwodAJAoBqcukm9jbS
         ADv8YXMdy2BrxVRk9SYmM/xLJYJTwaMuAkbSThgkjwDLCoPWrV28n0wo8fY1/5rjN7mI
         iIBAWIqnvHlvqhw6Rg7TayqRWn0Dw+5TMeEdkfmjRUigqAod0FwXGX7Ms9IQHKiz6UZS
         drPRAPu4oMEyh5t23EcwuUF9ZQ3RObT2gIw0HEhSkX7Tiigvzx3oR+i9hxKBizaoJXbR
         h04w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=xh+3VrIHiAKHqGI4VMxOsQ+cY4KgX7b4Foe7owcMP0g=;
        fh=DsDnjov+K/8XM8k+qmWGxCpY+yLoM/9W5K0kiqwsNRw=;
        b=YcN/BFDZDoOrkxduo+rjLdNrxUx/e6F5ZAkU5lbODe5AO4KkohveHZJqnN55JCuont
         F3AmNRHEPuq89qX+zWg8qrns9+tKzjDIcEX4BbrmSPzlLO1XBQkNvbxku6IJ85AGs7v7
         SoIvOHheKwYZBNJXUKXe3TccUrajMhMQg94uvw9hSSITUgbahmnaBwPvU0TzAipnWcIe
         T8TukJwO1cQLOIS37ElY3bWa+JRmF+UBJgK/1K0bCcLuTpGMSvVsFK/cVTgMkO8rCu7G
         XTCkkaoOaHQs5QUCqNKZZlfUtu2SQetUxRYx2lWgoNxv9QKc/YfPdrrj708lojhXImnz
         nquQ==;
        darn=lists.linux.dev
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1779349066; x=1779953866; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=xh+3VrIHiAKHqGI4VMxOsQ+cY4KgX7b4Foe7owcMP0g=;
        b=oXQXlPTrhlPBNdWfU5WmpTAK/tcwykdatwOLDLneY5sNReSgBw2bkwVG1YrqXWecKN
         MvBPow8XYDtkz9N1b+vboRziBfKVDtgrqh2Ny6csl2wLNacRJdb98fLS98WJ+1TOKLd7
         fF6/Skq8/J6KfIYy/+r9VP6NsTamntclweFn2PSgaj429cIwGUxona7MrkrzIeDRPirw
         kePIoORtg5jb9Pw/DgtbbRonPiCOsDxHTx8zj6ztNqa0T7spfGAL0Uq1Qn8ctvl7MHt/
         L2AYg28D96J5uvxH33xzEZRYxLeS8tKRjZa6KTaGz0c9H6m01WxWwUyQGtoUS56UyiiX
         9Jng==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1779349066; x=1779953866;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=xh+3VrIHiAKHqGI4VMxOsQ+cY4KgX7b4Foe7owcMP0g=;
        b=oySRGAcH+pP98TZokcl1WvkNpMSYbPWkyHZ2jKEUvi2PzSpzbzuDFt+xPKj5CJKxOg
         RsMcLQPsqG/4a6N5gaAtFhGkTrsAcy9zBDANyiiZ03+NyMjhQjsdXAEdVExhHSl5sARx
         F1dUfLKZ2/OIAme0s7JdJJEGKAAo5ZEVXX+O2NY+GKnTF5uzoH9u1e2rhitGKNv++ZtP
         mwoWSEu/zk4eqgwvzDoAlaE8W2dyn+P1QhDPuBf++BCdwRHwURe++n3i8lmw5EfDlkbs
         wFVy1xNbaKKg45rGv6CrTkSJj1pGfaMgJZVJB5Yz7vT6htiYfm4GWuWPpwRV3dRMnQyp
         8kaw==
X-Forwarded-Encrypted: i=1; AFNElJ/4GAzAsJJ55Ubx47mJ/3XcIgD/6nuA9rrgsXsGOLlgyPDlqCCXsOCAXq6DnHlBUEUWfrT6yok=@lists.linux.dev
X-Gm-Message-State: AOJu0YyNDI2ESgpiL7DujQIw2NB7K8jouA5BIj44tEGC6gRikzigxcsM
	OfxISSrcpKMGCQ4nuj9ygCmERbd27jCBuTCA9cL/1o9zpbjWj57OCkh71Qvhtg15FGT35gNx/gz
	a0MqYlN9LpRX931/JWBsDhVHspUIgZCxQpjM/fpwNzHqaFefNHnCfOW8s
X-Gm-Gg: Acq92OH4HBMcnwsK+6HyuFxvhPjOOGVHSfxAa8+tTGa19wT5Lz+Q+YRo4hdsI7/yvep
	sbcnbxL/UEoH9xh3/fTydmiu1sfIce5nRl+xJlLk2s9Snm/heTwVRBWCYZKbbkAKGRYdeaJNR+f
	noyydXChqZ8IyXo+Atr3jiWG+GbaX1J5E1lcvFDPfW19N/so+CmHEvdekTWM6XUG7eXTRsZGTGK
	xA9Lgfu28OZRsEWqRcuF73dmmWJuvA29U4z3liojPCaA5zxeK6lcHQE5QZqTi/Vi2rQF1YGR6aj
	qgZvGQEEJqWEXbSf66NlhBnjjqvf3LC4MSfsergDUCybi9MeDlxzCTVMNigexIrEnvG+UfBdtpn
	vEu33
X-Received: by 2002:a05:6820:184c:b0:69d:513e:1a71 with SMTP id
 006d021491bc7-69d6ef6f056mr720557eaf.60.1779349065329; Thu, 21 May 2026
 00:37:45 -0700 (PDT)
Precedence: bulk
X-Mailing-List: syzbot@lists.linux.dev
List-Id: <syzbot.lists.linux.dev>
List-Subscribe: <mailto:syzbot+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:syzbot+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <6a0e265f.050a0220.1fc69c.0000.GAE@google.com>
In-Reply-To: <6a0e265f.050a0220.1fc69c.0000.GAE@google.com>
From: Aleksandr Nogikh <nogikh@google.com>
Date: Thu, 21 May 2026 09:37:32 +0200
X-Gm-Features: AVHnY4J-5iHwsZzAVlc_GHL1a5-hl1N1KfMZZ38mwa0_VyE9e9s5PyY-nnv1Ss8
Message-ID: <CANp29Y6oaCsWekcmgQDGUmoQYn2g+Pq5BVbs2m2Li0qfMnuUdQ@mail.gmail.com>
Subject: Re: [moderation/CI] Re: mm: reliable 1GB page allocation
To: syzbot ci <syzbot+ci113f00a1e19876ff@syzkaller.appspotmail.com>
Cc: syzkaller-upstream-moderation@googlegroups.com, syzbot@lists.linux.dev
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

#syz upstream

On Wed, May 20, 2026 at 11:23=E2=80=AFPM syzbot ci
<syzbot+ci113f00a1e19876ff@syzkaller.appspotmail.com> wrote:
>
> syzbot ci has tested the following series
>
> [v1] mm: reliable 1GB page allocation
> https://lore.kernel.org/all/20260520150018.2491267-1-riel@surriel.com
> * [RFC PATCH 01/40] mm: page_alloc: replace pageblock_flags bitmap with s=
truct pageblock_data
> * [RFC PATCH 02/40] mm: page_alloc: per-cpu pageblock buddy allocator
> * [RFC PATCH 03/40] mm: page_alloc: split-path PCP free with local-tryloc=
k + remote-llist
> * [RFC PATCH 04/40] mm: mm_init: fix zone assignment for pages in unavail=
able ranges
> * [RFC PATCH 05/40] mm: page_alloc: remove watermark boost mechanism
> * [RFC PATCH 06/40] mm: page_alloc: async evacuation of stolen movable pa=
geblocks
> * [RFC PATCH 07/40] mm: page_alloc: track actual page contents in pageblo=
ck flags
> * [RFC PATCH 08/40] mm: page_alloc: superpageblock metadata for 1GB anti-=
fragmentation
> * [RFC PATCH 09/40] mm: page_alloc: support superpageblock resize for mem=
ory hotplug
> * [RFC PATCH 10/40] mm: page_alloc: add superpageblock fullness lists for=
 allocation steering
> * [RFC PATCH 11/40] mm: page_alloc: steer pageblock stealing to tainted s=
uperpageblocks
> * [RFC PATCH 12/40] mm: page_alloc: steer movable allocations to fullest =
clean superpageblocks
> * [RFC PATCH 13/40] mm: page_alloc: extract claim_whole_block from try_to=
_claim_block
> * [RFC PATCH 14/40] mm: page_alloc: add per-superpageblock free lists
> * [RFC PATCH 15/40] mm: page_alloc: add background superpageblock defragm=
entation worker
> * [RFC PATCH 16/40] mm: compaction: walk per-superpageblock free lists fo=
r migration targets
> * [RFC PATCH 17/40] mm: page_alloc: superpageblock-aware contiguous and h=
igher order allocation
> * [RFC PATCH 18/40] mm: page_alloc: prevent atomic allocations from taint=
ing clean SPBs
> * [RFC PATCH 19/40] mm: page_alloc: aggressively pack non-movable allocs =
in tainted SPBs on large systems
> * [RFC PATCH 20/40] mm: page_alloc: prefer reclaim over tainting clean su=
perpageblocks
> * [RFC PATCH 21/40] mm: page_alloc: adopt partial pageblocks from tainted=
 superpageblocks
> * [RFC PATCH 22/40] mm: page_alloc: add CONFIG_DEBUG_VM sanity checks for=
 SPB counters
> * [RFC PATCH 23/40] mm: page_alloc: targeted evacuation and dynamic reser=
ves for tainted SPBs
> * [RFC PATCH 24/40] mm: page_alloc: prevent UNMOVABLE/RECLAIMABLE mixing =
in pageblocks
> * [RFC PATCH 25/40] mm: trigger deferred SPB evac when atomic allocs woul=
d taint a clean SPB
> * [RFC PATCH 26/40] mm: page_alloc: refuse fragmenting fallback for calle=
rs with cheap fallback
> * [RFC PATCH 27/40] mm: page_alloc: cross-migratetype buddy borrow within=
 tainted SPBs
> * [RFC PATCH 28/40] mm: page_alloc: drive slab shrink from SPB anti-fragm=
entation pressure
> * [RFC PATCH 29/40] mm: page_reporting: walk per-superpageblock free list=
s
> * [RFC PATCH 30/40] mm: show_mem: collect migratetype letters from per-su=
perpageblock lists
> * [RFC PATCH 31/40] mm: page_alloc: per-(zone, order, mt) PASS_1 hint cac=
he
> * [RFC PATCH 32/40] mm: debug: prevent infinite recursion in dump_page() =
with CMA
> * [RFC PATCH 33/40] PM: hibernate: walk per-superpageblock free lists in =
mark_free_pages
> * [RFC PATCH 34/40] btrfs: allocate eb-attached btree pages as movable
> * [RFC PATCH 35/40] mm: page_alloc: refuse best-effort high-order allocs =
servable at lower orders
> * [RFC PATCH 36/40] mm: page_alloc: set ALLOC_NOFRAGMENT on alloc_frozen_=
pages_nolock_noprof
> * [RFC PATCH 37/40] mm: page_alloc: move spb_get_category and spb_tainted=
_reserve to mmzone.h
> * [RFC PATCH 38/40] mm: compaction: skip empty tainted superpageblocks as=
 migration source
> * [RFC PATCH 39/40] mm: compaction: respect tainted SPB reserve in destin=
ation selection
> * [RFC PATCH 40/40] mm: page_alloc: SPB tracepoint instrumentation [DO-NO=
T-MERGE]
>
> and found the following issue:
> WARNING in preempt_count_sub
>
> Full report is available here:
> https://ci.syzbot.org/series/8eef71e1-708c-40d0-9f9d-3a1bd637fc80
>
> ***
>
> WARNING in preempt_count_sub
>
> tree:      mm-new
> URL:       https://kernel.googlesource.com/pub/scm/linux/kernel/git/akpm/=
mm.git
> base:      4b83cbc4c15f09b000cc06f033f64b0824b6dc87
> arch:      amd64
> compiler:  Debian clang version 21.1.8 (++20251221033036+2078da43e25a-1~e=
xp1~20251221153213.50), Debian LLD 21.1.8
> config:    https://ci.syzbot.org/builds/de024c89-d472-4f06-b5be-4f75f2acd=
1d9/config
>
> ------------[ cut here ]------------
> DEBUG_LOCKS_WARN_ON(val > preempt_count())
> WARNING: kernel/sched/core.c:5883 at preempt_count_sub+0x9e/0x170, CPU#0:=
 kworker/0:0/9
> Modules linked in:
> CPU: 0 UID: 0 PID: 9 Comm: kworker/0:0 Not tainted syzkaller #0 PREEMPT(f=
ull)
> Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS 1.16.2-debian-1.=
16.2-1 04/01/2014
> Workqueue: events drain_vmap_area_work
> RIP: 0010:preempt_count_sub+0xa5/0x170
> Code: 29 31 90 48 c1 e8 03 0f b6 04 18 84 c0 0f 85 88 00 00 00 83 3d ff 5=
0 9d 0e 00 75 13 48 8d 3d 32 37 a0 0e 48 c7 c6 c0 f8 cb 8b <67> 48 0f b9 3a=
 90 eb b8 90 e8 ed d6 1d 03 85 c0 74 2f 48 c7 c0 c4
> RSP: 0000:ffffc900000e7590 EFLAGS: 00010246
>
> RAX: 0000000000000000 RBX: dffffc0000000000 RCX: ffff8881007d5880
> RDX: 0000000000000000 RSI: ffffffff8bcbf8c0 RDI: ffffffff90341000
> RBP: ffff888121042dc0 R08: ffffffff903129c3 R09: 1ffffffff2062538
> R10: dffffc0000000000 R11: fffffbfff2062539 R12: 0000000000000020
> R13: dffffc0000000000 R14: ffff888121042d80 R15: ffff88815fffbae8
> FS:  0000000000000000(0000) GS:ffff88818dc7e000(0000) knlGS:0000000000000=
000
> CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> CR2: ffff88823ffff000 CR3: 000000000e74a000 CR4: 00000000000006f0
> Call Trace:
>  <TASK>
>  free_frozen_page_commit+0x737/0x1290
>  __free_frozen_pages+0x873/0x1070
>  kasan_depopulate_vmalloc_pte+0x6d/0x90
>  __apply_to_page_range+0xbdc/0x1420
>  __kasan_release_vmalloc+0xa2/0xd0
>  purge_vmap_node+0x220/0x960
>  __purge_vmap_area_lazy+0x779/0xb40
>  drain_vmap_area_work+0x27/0x40
>  process_scheduled_works+0xb5d/0x1860
>  worker_thread+0xa53/0xfc0
>  kthread+0x388/0x470
>  ret_from_fork+0x514/0xb70
>  ret_from_fork_asm+0x1a/0x30
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
> To test a patch for this bug, please reply with `#syz test`
> (should be on a separate line).
>
> The patch should be attached to the email.
> Note: arguments like custom git repos and branches are not supported.
>
> The email will later be sent to:
> [boris@bur.io clm@meta.com david@kernel.org dsterba@suse.com fvdl@google.=
com hannes@cmpxchg.org hnaz@cmpxchg.org kernel-team@meta.com lenb@kernel.or=
g linux-btrfs@vger.kernel.org linux-kernel@vger.kernel.org linux-mm@kvack.o=
rg linux-pm@vger.kernel.org ljs@kernel.org pavel@kernel.org rafael@kernel.o=
rg riel@surriel.com surenb@google.com usama.arif@linux.dev willy@infradead.=
org ziy@nvidia.com]
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
-upstream-moderation/6a0e265f.050a0220.1fc69c.0000.GAE%40google.com.
