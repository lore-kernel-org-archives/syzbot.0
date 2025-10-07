Received: from mail-qv1-f43.google.com (mail-qv1-f43.google.com [209.85.219.43])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A7D842550DD
	for <syzbot@lists.linux.dev>; Tue,  7 Oct 2025 07:41:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.219.43
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1759822920; cv=none; b=MClkdkHkc+X2s+VnO//zXXVTwLLKDFYtJdRAKM2hL92VZgMyJGntDqRD03g0pfWzlF5hd3m7pmSE/i6/C0XThkKnNTDE4AHViFlLDaR/5khsn3iyxH+rrdxJ9nnXHxTmsf+8hcegKwm3NwDGoiRMiGKE30VgMohIe8scFDEhxPY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1759822920; c=relaxed/simple;
	bh=GEfz5pgw2g37+HHV7CRJS0c94E5FSRw/ci0/YN4XW6E=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=jlFhwelouqY4Z3bgZfAPSFO/ZGGpfPE3xtJWNu+OXsQ5b040RmpIvFSGfl1co4PGlJ+xnJJe59FQ7Fcd7Gj9x2tXDOS7sh5AgPQcN3/vPxjwuqj6eFPplo+QS81egbGIqCGmbxNYHz9NcYhDFnHnxHd8ichlSi/bxki3qoho4Wk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=ePnrJfzz; arc=none smtp.client-ip=209.85.219.43
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="ePnrJfzz"
Received: by mail-qv1-f43.google.com with SMTP id 6a1803df08f44-78f75b0a058so61660806d6.0
        for <syzbot@lists.linux.dev>; Tue, 07 Oct 2025 00:41:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1759822916; x=1760427716; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=OCXLEpm2p2EypUNhKCPuAXGoCG5nZlixZFoVMlAEoX0=;
        b=ePnrJfzzo5InzlixVMmPgoYgK5mZCXTESIQ5oLx82QjZarw+0XtqbZKKtyAufwsOd1
         rDrzYMaCIs6LLFzc77A5kFJ7EADcGLqBuRrdx4rtt1Mq6YjAnY/ZaD/mRRwF6/MWWH4g
         uOCKGSc4YTaOy1YLT1zR4nowxOilNvBaJ1L+dENdlVQRbmpOLX+KX/jWg/Ash06xZaYz
         hHT9au26qRF6h+OdUKM6mYFH1BPrIZlQ9o5oPHwZ2s0zuhDoaYNnUncFmrqIz1Gy668D
         IHY0Dl4yjcWhQSfRATk0IBWGan8M7/QRJWFIgDumHibUO3awCGIJ8o2IePhHDFaoNBk4
         UrsQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1759822916; x=1760427716;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=OCXLEpm2p2EypUNhKCPuAXGoCG5nZlixZFoVMlAEoX0=;
        b=ZVH5lfDy5ZCMHCs/Qf1qeDvJzdiDrKYFg8VEAc+6cZvlt6iLzcJ6vUwGxyqlOS+qzR
         Iz6wKpM4l+wM8vgs375EeVDhl1A/eI+AdZ5XuH1uVx/jmoqPUPisyMbGZUFbpTLMWSM9
         FmeuOfNO0ervYcdKqbsDTNRSQwxYMfhNb8t4QCkAA/ay3tGkkDCXl3LZMC0+0GmNYWjC
         iPKXJbgyWXNjClZcR+XTWHuRi5Z+XpVnWjbp6VaNk7e3n5u42PSX2WOWWNndFeT9fPZ1
         EXm6w9iXwftyCnK3XHSQV1o+CIXE8P4CVN5CGtxfvhHzgCtgNe604ftYrAA6pR3KWjKm
         tNHg==
X-Forwarded-Encrypted: i=1; AJvYcCXcqRHAC0eSdYJ2smqjzC7uHbKO5bBkVSIOziOoZXrRHgSi+yOPYyc6zqd72QoJX9g46F2fRrQ=@lists.linux.dev
X-Gm-Message-State: AOJu0YyWw/JCm5T12KMX1FAXh2GtEsYByN0gYli9oXgyVUyjakQ9ldJj
	/HHWDRG9ofOD/+FynMsmhp4r4hsV+LeB/8CHU8eeDLEzp7Ih+qhVREqDYMTzW3cFuJdTHWyGJUi
	GR9Od2Xl2QvLVwOAMFSM829msG85Ja9NU2KtrYWJp
X-Gm-Gg: ASbGncsRBkcepszf6gq1XhZYyNenyUkWA85L+AZochDNh+n4ynvLr5uBA3rn+hbvFPS
	TuDs5V8gzi2PXKHjtNZB1inDK0+eiwb4mTqmtObG3k3iDRzLU1PQmLphwdQu2wNyQa3zTLUuUIX
	wWK8rXzPHd2xdpaq8IYulIOpjWojdz6MKPcok0kK3bDsYS5EYR5/wH6nTb7GIdI8YqrnsJkGuhw
	7ZWCHusDXDH7Xfs3fXILYe9cTrpYU7q/w0=
X-Google-Smtp-Source: AGHT+IH1GjuuIdr87ui3+XoUPQTKfEcRuvkvGz71uU4H5k7mspZ3LYlGgC6c68KlA6k0QCcNcbW84657tC/nyTRsEbk=
X-Received: by 2002:a05:622a:590a:b0:4b7:983b:b70c with SMTP id
 d75a77b69052e-4e576b1514emr235936041cf.67.1759822915216; Tue, 07 Oct 2025
 00:41:55 -0700 (PDT)
Precedence: bulk
X-Mailing-List: syzbot@lists.linux.dev
List-Id: <syzbot.lists.linux.dev>
List-Subscribe: <mailto:syzbot+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:syzbot+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20251006193103.2684156-1-edumazet@google.com> <68e4a3ef.a00a0220.298cc0.0472.GAE@google.com>
In-Reply-To: <68e4a3ef.a00a0220.298cc0.0472.GAE@google.com>
From: Eric Dumazet <edumazet@google.com>
Date: Tue, 7 Oct 2025 00:41:42 -0700
X-Gm-Features: AS18NWBG5eYi7Mh4UlZ_J3AdEjARqEvEOw65c49sINOthwk0x1uedi767stcTtU
Message-ID: <CANn89iLaVmPvi=MLcU04VCueGcUD1+m=N=wXDQDMSxYTWbc6Rg@mail.gmail.com>
Subject: Re: [syzbot ci] Re: net: optimize TX throughput and efficiency
To: syzbot ci <syzbot+ciad44046e74230deb@syzkaller.appspotmail.com>
Cc: davem@davemloft.net, eric.dumazet@gmail.com, horms@kernel.org, 
	jhs@mojatatu.com, jiri@resnulli.us, kuba@kernel.org, kuniyu@google.com, 
	netdev@vger.kernel.org, pabeni@redhat.com, willemb@google.com, 
	xiyou.wangcong@gmail.com, syzbot@lists.linux.dev, 
	syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Mon, Oct 6, 2025 at 10:24=E2=80=AFPM syzbot ci
<syzbot+ciad44046e74230deb@syzkaller.appspotmail.com> wrote:
>
> syzbot ci has tested the following series
>
> [v1] net: optimize TX throughput and efficiency
> https://lore.kernel.org/all/20251006193103.2684156-1-edumazet@google.com
> * [PATCH RFC net-next 1/5] net: add add indirect call wrapper in skb_rele=
ase_head_state()
> * [PATCH RFC net-next 2/5] net/sched: act_mirred: add loop detection
> * [PATCH RFC net-next 3/5] Revert "net/sched: Fix mirred deadlock on devi=
ce recursion"
> * [PATCH RFC net-next 4/5] net: sched: claim one cache line in Qdisc
> * [PATCH RFC net-next 5/5] net: dev_queue_xmit() llist adoption
>
> and found the following issue:
> KASAN: slab-use-after-free Read in netem_dequeue
>
> Full report is available here:
> https://ci.syzbot.org/series/e8660f67-35a0-406e-96ee-a401d3f30ff9
>

I was unsure if I needed to clear skb->next or not before calling
dev_qdisc_enqueue()

We could either do this in netem, or generically in dev_qdisc_enqueue()

diff --git a/net/core/dev.c b/net/core/dev.c
index 6094768bf3c028f0ad1e52b9b12b7258fa0ecff6..547efbfb63adb4a093ce4b4ea09=
34256c15e263b
100644
--- a/net/core/dev.c
+++ b/net/core/dev.c
@@ -4115,6 +4115,7 @@ static int dev_qdisc_enqueue(struct sk_buff
*skb, struct Qdisc *q,
 {
        int rc;

+       skb_mark_not_on_list(skb);
        rc =3D q->enqueue(skb, q, to_free) & NET_XMIT_MASK;
        if (rc =3D=3D NET_XMIT_SUCCESS)
                trace_qdisc_enqueue(q, txq, skb);



> ***
>
> KASAN: slab-use-after-free Read in netem_dequeue
>
> tree:      net-next
> URL:       https://kernel.googlesource.com/pub/scm/linux/kernel/git/netde=
v/net-next.git
> base:      f1455695d2d99894b65db233877acac9a0e120b9
> arch:      amd64
> compiler:  Debian clang version 20.1.8 (++20250708063551+0c9f909b7976-1~e=
xp1~20250708183702.136), Debian LLD 20.1.8
> config:    https://ci.syzbot.org/builds/2db7ec92-610b-4887-bf33-d0b4c0476=
0c8/config
> syz repro: https://ci.syzbot.org/findings/3ca47f46-1b94-48b6-bab9-5996b71=
62c30/syz_repro
>
> =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
> BUG: KASAN: slab-use-after-free in netem_dequeue+0x4e7/0x1430 net/sched/s=
ch_netem.c:720
> Read of size 8 at addr ffff888020b65b30 by task ksoftirqd/1/23
>
> CPU: 1 UID: 0 PID: 23 Comm: ksoftirqd/1 Not tainted syzkaller #0 PREEMPT(=
full)
> Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS 1.16.2-debian-1.=
16.2-1 04/01/2014
> Call Trace:
>  <TASK>
>  dump_stack_lvl+0x189/0x250 lib/dump_stack.c:120
>  print_address_description mm/kasan/report.c:378 [inline]
>  print_report+0xca/0x240 mm/kasan/report.c:482
>  kasan_report+0x118/0x150 mm/kasan/report.c:595
>  netem_dequeue+0x4e7/0x1430 net/sched/sch_netem.c:720
>  dequeue_skb net/sched/sch_generic.c:294 [inline]
>  qdisc_restart net/sched/sch_generic.c:399 [inline]
>  __qdisc_run+0x23c/0x15f0 net/sched/sch_generic.c:417
>  qdisc_run+0xc5/0x290 include/net/pkt_sched.h:126
>  net_tx_action+0x7c9/0x980 net/core/dev.c:5731
>  handle_softirqs+0x286/0x870 kernel/softirq.c:579
>  run_ksoftirqd+0x9b/0x100 kernel/softirq.c:968
>  smpboot_thread_fn+0x542/0xa60 kernel/smpboot.c:160
>  kthread+0x711/0x8a0 kernel/kthread.c:463
>  ret_from_fork+0x439/0x7d0 arch/x86/kernel/process.c:148
>  ret_from_fork_asm+0x1a/0x30 arch/x86/entry/entry_64.S:245
>  </TASK>
>
> Allocated by task 5913:
>  kasan_save_stack mm/kasan/common.c:47 [inline]
>  kasan_save_track+0x3e/0x80 mm/kasan/common.c:68
>  unpoison_slab_object mm/kasan/common.c:330 [inline]
>  __kasan_slab_alloc+0x6c/0x80 mm/kasan/common.c:356
>  kasan_slab_alloc include/linux/kasan.h:250 [inline]
>  slab_post_alloc_hook mm/slub.c:4191 [inline]
>  slab_alloc_node mm/slub.c:4240 [inline]
>  kmem_cache_alloc_node_noprof+0x1bb/0x3c0 mm/slub.c:4292
>  __alloc_skb+0x112/0x2d0 net/core/skbuff.c:660
>  alloc_skb include/linux/skbuff.h:1383 [inline]
>  mld_newpack+0x13c/0xc40 net/ipv6/mcast.c:1775
>  add_grhead+0x5a/0x2a0 net/ipv6/mcast.c:1886
>  add_grec+0x1452/0x1740 net/ipv6/mcast.c:2025
>  mld_send_cr net/ipv6/mcast.c:2148 [inline]
>  mld_ifc_work+0x6ed/0xd60 net/ipv6/mcast.c:2693
>  process_one_work kernel/workqueue.c:3236 [inline]
>  process_scheduled_works+0xae1/0x17b0 kernel/workqueue.c:3319
>  worker_thread+0x8a0/0xda0 kernel/workqueue.c:3400
>  kthread+0x711/0x8a0 kernel/kthread.c:463
>  ret_from_fork+0x439/0x7d0 arch/x86/kernel/process.c:148
>  ret_from_fork_asm+0x1a/0x30 arch/x86/entry/entry_64.S:245
>
> Freed by task 23:
>  kasan_save_stack mm/kasan/common.c:47 [inline]
>  kasan_save_track+0x3e/0x80 mm/kasan/common.c:68
>  kasan_save_free_info+0x46/0x50 mm/kasan/generic.c:576
>  poison_slab_object mm/kasan/common.c:243 [inline]
>  __kasan_slab_free+0x5b/0x80 mm/kasan/common.c:275
>  kasan_slab_free include/linux/kasan.h:233 [inline]
>  slab_free_hook mm/slub.c:2422 [inline]
>  slab_free mm/slub.c:4695 [inline]
>  kmem_cache_free+0x18f/0x400 mm/slub.c:4797
>  br_dev_xmit+0x11b3/0x1840 net/bridge/br_device.c:108
>  __netdev_start_xmit include/linux/netdevice.h:5248 [inline]
>  netdev_start_xmit include/linux/netdevice.h:5257 [inline]
>  xmit_one net/core/dev.c:3845 [inline]
>  dev_hard_start_xmit+0x2d7/0x830 net/core/dev.c:3861
>  sch_direct_xmit+0x241/0x4b0 net/sched/sch_generic.c:344
>  qdisc_restart net/sched/sch_generic.c:409 [inline]
>  __qdisc_run+0xb16/0x15f0 net/sched/sch_generic.c:417
>  qdisc_run+0xc5/0x290 include/net/pkt_sched.h:126
>  net_tx_action+0x7c9/0x980 net/core/dev.c:5731
>  handle_softirqs+0x286/0x870 kernel/softirq.c:579
>  run_ksoftirqd+0x9b/0x100 kernel/softirq.c:968
>  smpboot_thread_fn+0x542/0xa60 kernel/smpboot.c:160
>  kthread+0x711/0x8a0 kernel/kthread.c:463
>  ret_from_fork+0x439/0x7d0 arch/x86/kernel/process.c:148
>  ret_from_fork_asm+0x1a/0x30 arch/x86/entry/entry_64.S:245
>
> The buggy address belongs to the object at ffff888020b65b00
>  which belongs to the cache skbuff_head_cache of size 240
> The buggy address is located 48 bytes inside of
>  freed 240-byte region [ffff888020b65b00, ffff888020b65bf0)
>
> The buggy address belongs to the physical page:
> page: refcount:0 mapcount:0 mapping:0000000000000000 index:0x0 pfn:0x20b6=
4
> head: order:1 mapcount:0 entire_mapcount:0 nr_pages_mapped:0 pincount:0
> flags: 0xfff00000000040(head|node=3D0|zone=3D1|lastcpupid=3D0x7ff)
> page_type: f5(slab)
> raw: 00fff00000000040 ffff88801cedf8c0 dead000000000122 0000000000000000
> raw: 0000000000000000 0000000000150015 00000000f5000000 0000000000000000
> head: 00fff00000000040 ffff88801cedf8c0 dead000000000122 0000000000000000
> head: 0000000000000000 0000000000150015 00000000f5000000 0000000000000000
> head: 00fff00000000001 ffffea000082d901 00000000ffffffff 00000000ffffffff
> head: ffffffffffffffff 0000000000000000 00000000ffffffff 0000000000000002
> page dumped because: kasan: bad access detected
> page_owner tracks the page as allocated
> page last allocated via order 1, migratetype Unmovable, gfp_mask 0x72820(=
GFP_ATOMIC|__GFP_NOWARN|__GFP_NORETRY|__GFP_MEMALLOC|__GFP_COMP), pid 0, tg=
id 0 (swapper/0), ts 96149950019, free_ts 42914869228
>  set_page_owner include/linux/page_owner.h:32 [inline]
>  post_alloc_hook+0x240/0x2a0 mm/page_alloc.c:1851
>  prep_new_page mm/page_alloc.c:1859 [inline]
>  get_page_from_freelist+0x21e4/0x22c0 mm/page_alloc.c:3858
>  __alloc_frozen_pages_noprof+0x181/0x370 mm/page_alloc.c:5148
>  alloc_pages_mpol+0x232/0x4a0 mm/mempolicy.c:2416
>  alloc_slab_page mm/slub.c:2492 [inline]
>  allocate_slab+0x8a/0x370 mm/slub.c:2660
>  new_slab mm/slub.c:2714 [inline]
>  ___slab_alloc+0xbeb/0x1420 mm/slub.c:3901
>  __slab_alloc mm/slub.c:3992 [inline]
>  __slab_alloc_node mm/slub.c:4067 [inline]
>  slab_alloc_node mm/slub.c:4228 [inline]
>  kmem_cache_alloc_node_noprof+0x280/0x3c0 mm/slub.c:4292
>  __alloc_skb+0x112/0x2d0 net/core/skbuff.c:660
>  __netdev_alloc_skb+0x108/0x970 net/core/skbuff.c:734
>  netdev_alloc_skb include/linux/skbuff.h:3484 [inline]
>  dev_alloc_skb include/linux/skbuff.h:3497 [inline]
>  __ieee80211_beacon_get+0xc06/0x1880 net/mac80211/tx.c:5652
>  ieee80211_beacon_get_tim+0xb4/0x2b0 net/mac80211/tx.c:5774
>  ieee80211_beacon_get include/net/mac80211.h:5667 [inline]
>  mac80211_hwsim_beacon_tx+0x3ce/0x860 drivers/net/wireless/virtual/mac802=
11_hwsim.c:2355
>  __iterate_interfaces+0x2ab/0x590 net/mac80211/util.c:761
>  ieee80211_iterate_active_interfaces_atomic+0xdb/0x180 net/mac80211/util.=
c:797
>  mac80211_hwsim_beacon+0xbb/0x1c0 drivers/net/wireless/virtual/mac80211_h=
wsim.c:2389
>  __run_hrtimer kernel/time/hrtimer.c:1761 [inline]
>  __hrtimer_run_queues+0x52c/0xc60 kernel/time/hrtimer.c:1825
> page last free pid 0 tgid 0 stack trace:
>  reset_page_owner include/linux/page_owner.h:25 [inline]
>  free_pages_prepare mm/page_alloc.c:1395 [inline]
>  __free_frozen_pages+0xbc4/0xd30 mm/page_alloc.c:2895
>  rcu_do_batch kernel/rcu/tree.c:2605 [inline]
>  rcu_core+0xcab/0x1770 kernel/rcu/tree.c:2861
>  handle_softirqs+0x286/0x870 kernel/softirq.c:579
>  __do_softirq kernel/softirq.c:613 [inline]
>  invoke_softirq kernel/softirq.c:453 [inline]
>  __irq_exit_rcu+0xca/0x1f0 kernel/softirq.c:680
>  irq_exit_rcu+0x9/0x30 kernel/softirq.c:696
>  instr_sysvec_apic_timer_interrupt arch/x86/kernel/apic/apic.c:1050 [inli=
ne]
>  sysvec_apic_timer_interrupt+0xa6/0xc0 arch/x86/kernel/apic/apic.c:1050
>  asm_sysvec_apic_timer_interrupt+0x1a/0x20 arch/x86/include/asm/idtentry.=
h:702
>
> Memory state around the buggy address:
>  ffff888020b65a00: fb fb fb fb fb fb fb fb fb fb fb fb fb fb fc fc
>  ffff888020b65a80: fc fc fc fc fc fc fc fc fc fc fc fc fc fc fc fc
> >ffff888020b65b00: fa fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb
>                                      ^
>  ffff888020b65b80: fb fb fb fb fb fb fb fb fb fb fb fb fb fb fc fc
>  ffff888020b65c00: fc fc fc fc fc fc fc fc fc fc fc fc fc fc fc fc
> =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
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
