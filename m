Received: from mail-oa1-f42.google.com (mail-oa1-f42.google.com [209.85.160.42])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3C38C3B2FF4
	for <syzbot@lists.linux.dev>; Wed,  8 Apr 2026 11:27:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.160.42
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1775647667; cv=pass; b=Qv8lc0aSz6ioI0O9vXIed//tt55aK9dHSs9EX49QUSCVrv+SI2NPVaglCTubfJFjqewAgC42cpAUVZo22/5b78IotSmR6xI7XagGcDLsCstrHe0EAiHfR6ENECObJ+z4h1W+g9BTcUmGMgxROZ9bkmbjHJfSi2VSVSqtS42F5Uo=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1775647667; c=relaxed/simple;
	bh=8ozMN5aki3KKpPxbApl9guo5b0cxxc/eIXV+rL1oBu0=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=bAxyGkmhDJYra8LMdK/pyNha38yxfq+ExhLPaEjhIiSJIsB4Ecen47RIgHYHq8FMxtztjz3+WRVv/498cZ95iI9Kric25cFNCvi3QENwYXmb2mMEjW2ZS0ifpb5beHlWYYGe27VMyRMHMAu4NsgI63+KStUQr4Qlv06HatazX8c=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=C4U5wB4r; arc=pass smtp.client-ip=209.85.160.42
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="C4U5wB4r"
Received: by mail-oa1-f42.google.com with SMTP id 586e51a60fabf-40ef10ec84cso4523486fac.2
        for <syzbot@lists.linux.dev>; Wed, 08 Apr 2026 04:27:46 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1775647665; cv=none;
        d=google.com; s=arc-20240605;
        b=DGGpucvx3X9j+DJppnKP2klz9ZLQN22aSuWHlVmPBNmE9KKPaCeoNRozSWs2XbZsN9
         Qu50WG2Zdokc2hkFgU5T0c+WZDOz/LADkfz+d+/qTjIqdiiQNL6XP06fLGjZbNQ0jMBv
         oAboteMocGbKKMkQQZMPnHH+1weXLJrB9Eed1iZJXuDJEGSVjTQuDEUpSqQc2ZZ1Se5/
         /WQ8ecIqZsT9rBMv6z1c0PXqeClOgYvJAX/WPpPqQno8bQT4Eu/ymbOLOQDTkJO8jiJm
         tKgK3/5rektIaZMjSlgXn0wc3zTxq0ad1k2rOdhm9jzad0leyfJ6vQIPkuuQ7cRNrz+o
         ePUg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=lSv2Y4Sk1cr6DwLhp9WkuyEi20C8OTOID6D4XJGHx5k=;
        fh=hw5LmAJyFPjGAMTmnk6UwhxbJQAi/0H3K4ogg9nJp9s=;
        b=MDt/I9/ZDaQRSU+DqMyOS1mQ4LknPmu59MeZ5urbTWemOOrI1F4OwEHNVHyMy01aqt
         M1rfwnWKgaMujbho9V2j3nlKpHMrCB1fjMbiGfwdEwVaXTB5w47xR2epCdA0vGNxGYa3
         EFP/Xn/ex+R28kOmJO5XIBu6W4swMk23vFJ7lSs/O9LNc3lgYkbUzTpYUuIxfRQzxofN
         +ch8FjcPCvm1TQTJgHU3Tq5z6L1MkVKmszKs0YpCVF+Q909JQ0LPYd35zDyJGypziyu3
         J///z7qLqezZhwmhJ4XQd3hR02w7/GV7xYyypfWvKP2uo0Lt0hjvyHzXfVDUFG6TEqzw
         Rvcg==;
        darn=lists.linux.dev
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1775647665; x=1776252465; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=lSv2Y4Sk1cr6DwLhp9WkuyEi20C8OTOID6D4XJGHx5k=;
        b=C4U5wB4ruz0fc96UA3oY1cLo0YlDyQh0VM5a1AEgUVTleYcSAxFshqn6L/WvdxpepY
         EZR7lsRDAuMbwBh/FWT2HwOwN3mqxCDS7Wp+lH2POn/6K9a7Hx7vxNWesEoBv+xEzuix
         yKLxTw3qZldfC5f/NXonZf0dHLHR+8aIcYnmC588NZwrYQz25m99rQvfM7lQgGfZISkv
         l38CGNzdEx/srJ4OVc0l1kilvnuf83sKnF2Tu6EHd5eehqUN+WpnpubEoR2j0ET2DnyE
         LTRqIgzki7EFCrtRlHYBFSXQAXVg8RWL6Dklp4Rjwn03Eb9mrmS7wBntkFt7m/80+pi1
         DPvA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1775647665; x=1776252465;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=lSv2Y4Sk1cr6DwLhp9WkuyEi20C8OTOID6D4XJGHx5k=;
        b=fslkCL3UPlf2fReuuP36MnxFk+L97DyWSCwh0LWIgAfxwG5j8YDnBNFVbeU7rfFYR+
         sWiinJYg1dG1O7F7XGggpqGHTVQ+jbTtJySDVxN1jK4sap54dqS1cTc4dsZhmfnHnjLs
         J5SGv27Zp1cs75xAAU8j1vNvB9v0uaf3hLkPAdXuzLtbSiHx0Jsesej2vwxF48o0q5R+
         hkq7+lzM7E2eaYgAF0w4L6UkznxAm8wEXK7/fv0/NLBFS+elpxxUJb9OziL9Ipf0S4Or
         gyeq/GXKgwJkxgnfnje8vEMIxOQ8jJUr1ZPITeQ7WnfEEw6q8ioTIzWYNDVydk+ZmEUg
         mw+Q==
X-Forwarded-Encrypted: i=1; AJvYcCXIejOjztYO58877Ev9xtivnnjdmY/QTeAjEvwMs+jNH3zmPRdxufueEkfS/lpjwA5qXAW9qfA=@lists.linux.dev
X-Gm-Message-State: AOJu0Yw3cX4ah+mB8n6Z0zwbyt65Gydhe7+Z7djuOcJJon4JLjADDWcV
	8qjWM/K0aW10FdqiowvlwJ5YTupdwLevjUGJ0TYRDDJkdrlyJSDnCjmbnn+F9/14gLp9GOK5Ovo
	FTfrHiY5RdydNhCMsFrDYvEkzPfu69PM9Y64GOE8x
X-Gm-Gg: AeBDiev6JJfhqSRQ2fiDWxm6E/7vEet4YE0oCq01FuBXpgPS8YnLnJsPK2ZiqJ48Ujj
	+hRzneh4WwWflPUfZhSz+pfrkaKRVK5sGv44Tudyj63Vj5zJ6Y+LifEhPWcN8adjf45w1EnkQRv
	0VNpQ3KlHkgs0/Mivs9pynEgeb5exYYlxLUNnF86UUtIEIH7RSxm/qTgp5LEMlptLiJoh6DViC/
	8SbJl/gTMJJW5So2Apwu0/7aotyDd8bLPqVm1WQCIxe2QC8IzkiZ0/jj64b14RqY+i40MpTz6Si
	nxfhQbGjRrYXBU2TgwkGgj/NgMaEuWUlPq9Am+gYIET8xpMRj31swbhAyhljIusLhpS2kA==
X-Received: by 2002:a05:6870:c1cd:b0:417:5aa1:bc9f with SMTP id
 586e51a60fabf-4230ffc0de5mr11467171fac.26.1775647664620; Wed, 08 Apr 2026
 04:27:44 -0700 (PDT)
Precedence: bulk
X-Mailing-List: syzbot@lists.linux.dev
List-Id: <syzbot.lists.linux.dev>
List-Subscribe: <mailto:syzbot+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:syzbot+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <69d637bc.a00a0220.468cb.000c.GAE@google.com>
In-Reply-To: <69d637bc.a00a0220.468cb.000c.GAE@google.com>
From: Aleksandr Nogikh <nogikh@google.com>
Date: Wed, 8 Apr 2026 13:27:33 +0200
X-Gm-Features: AQROBzBEvr-b39tpnCjB8L9zd9DT8W7vPisij4xzx2dDZ2J_T4-AUml3ycO1hqM
Message-ID: <CANp29Y5xm7ruFB=ELDs5fbFDzauz3mUsPOZM-u6tMbhbmkUgzg@mail.gmail.com>
Subject: Re: [moderation/CI] Re: mm/page_alloc: use batch page clearing in kernel_init_pages()
To: syzbot ci <syzbot+ci0d80fc284c3061e1@syzkaller.appspotmail.com>
Cc: syzkaller-upstream-moderation@googlegroups.com, syzbot@lists.linux.dev
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

#syz upstream

On Wed, Apr 8, 2026 at 1:10=E2=80=AFPM syzbot ci
<syzbot+ci0d80fc284c3061e1@syzkaller.appspotmail.com> wrote:
>
> syzbot ci has tested the following series
>
> [v1] mm/page_alloc: use batch page clearing in kernel_init_pages()
> https://lore.kernel.org/all/20260408092441.435133-1-hsalunke@amd.com
> * [PATCH] mm/page_alloc: use batch page clearing in kernel_init_pages()
>
> and found the following issue:
> WARNING in preempt_model_full
>
> Full report is available here:
> https://ci.syzbot.org/series/be6c0534-641b-42aa-8b73-ab8f592ec267
>
> ***
>
> WARNING in preempt_model_full
>
> tree:      mm-new
> URL:       https://kernel.googlesource.com/pub/scm/linux/kernel/git/akpm/=
mm.git
> base:      0d90551ea699ef3d1a85cd7a1a7e21e8d4f04db2
> arch:      amd64
> compiler:  Debian clang version 21.1.8 (++20251221033036+2078da43e25a-1~e=
xp1~20251221153213.50), Debian LLD 21.1.8
> config:    https://ci.syzbot.org/builds/22cbd293-31c6-46b9-b8d4-2ff590ce4=
06b/config
>
> CPU topo: Max. logical packages:   2
> CPU topo: Max. logical nodes:      1
> CPU topo: Num. nodes per package:  1
> CPU topo: Max. logical dies:       2
> CPU topo: Max. dies per package:   1
> CPU topo: Max. threads per core:   1
> CPU topo: Num. cores per package:     1
> CPU topo: Num. threads per package:   1
> CPU topo: Allowing 2 present CPUs plus 0 hotplug CPUs
> kvm-guest: APIC: eoi() replaced with kvm_guest_apic_eoi_write()
> PM: hibernation: Registered nosave memory: [mem 0x00000000-0x00000fff]
> PM: hibernation: Registered nosave memory: [mem 0x0009f000-0x000fffff]
> PM: hibernation: Registered nosave memory: [mem 0x7ffdf000-0xffffffff]
> [gap 0xc0000000-0xfed1bfff] available for PCI devices
> Booting paravirtualized kernel on KVM
> clocksource: refined-jiffies: mask: 0xffffffff max_cycles: 0xffffffff, ma=
x_idle_ns: 19112604462750000 ns
> Zone ranges:
>   DMA      [mem 0x0000000000001000-0x0000000000ffffff]
>   DMA32    [mem 0x0000000001000000-0x00000000ffffffff]
>   Normal   [mem 0x0000000100000000-0x000000023fffffff]
>   Device   empty
> Movable zone start for each node
> Early memory node ranges
>   node   0: [mem 0x0000000000001000-0x000000000009efff]
>   node   0: [mem 0x0000000000100000-0x000000007ffdefff]
>   node   0: [mem 0x0000000100000000-0x0000000160000fff]
>   node   1: [mem 0x0000000160001000-0x000000023fffffff]
> Initmem setup node 0 [mem 0x0000000000001000-0x0000000160000fff]
> Initmem setup node 1 [mem 0x0000000160001000-0x000000023fffffff]
> On node 0, zone DMA: 1 pages in unavailable ranges
> On node 0, zone DMA: 97 pages in unavailable ranges
> On node 0, zone Normal: 33 pages in unavailable ranges
> setup_percpu: NR_CPUS:8 nr_cpumask_bits:2 nr_cpu_ids:2 nr_node_ids:2
> percpu: Embedded 71 pages/cpu s250120 r8192 d32504 u2097152
> kvm-guest: PV spinlocks disabled, no host support
> Kernel command line: earlyprintk=3Dserial net.ifnames=3D0 sysctl.kernel.h=
ung_task_all_cpu_backtrace=3D1 ima_policy=3Dtcb nf-conntrack-ftp.ports=3D20=
000 nf-conntrack-tftp.ports=3D20000 nf-conntrack-sip.ports=3D20000 nf-connt=
rack-irc.ports=3D20000 nf-conntrack-sane.ports=3D20000 binder.debug_mask=3D=
0 rcupdate.rcu_expedited=3D1 rcupdate.rcu_cpu_stall_cputime=3D1 no_hash_poi=
nters page_owner=3Don sysctl.vm.nr_hugepages=3D4 sysctl.vm.nr_overcommit_hu=
gepages=3D4 secretmem.enable=3D1 sysctl.max_rcu_stall_to_panic=3D1 msr.allo=
w_writes=3Doff coredump_filter=3D0xffff root=3D/dev/sda console=3DttyS0 vsy=
scall=3Dnative numa=3Dfake=3D2 kvm-intel.nested=3D1 spec_store_bypass_disab=
le=3Dprctl nopcid vivid.n_devs=3D64 vivid.multiplanar=3D1,2,1,2,1,2,1,2,1,2=
,1,2,1,2,1,2,1,2,1,2,1,2,1,2,1,2,1,2,1,2,1,2,1,2,1,2,1,2,1,2,1,2,1,2,1,2,1,=
2,1,2,1,2,1,2,1,2,1,2,1,2,1,2,1,2 netrom.nr_ndevs=3D32 rose.rose_ndevs=3D32=
 smp.csd_lock_timeout=3D100000 watchdog_thresh=3D55 workqueue.watchdog_thre=
sh=3D140 sysctl.net.core.netdev_unregister_timeout_secs=3D140 dummy_hcd.num=
=3D32 max_loop=3D32 nbds_max=3D32 \
> Kernel command line: comedi.comedi_num_legacy_minors=3D4 panic_on_warn=3D=
1 root=3D/dev/sda console=3DttyS0 root=3D/dev/sda1
> Unknown kernel command line parameters "nbds_max=3D32", will be passed to=
 user space.
> printk: log buffer data + meta data: 262144 + 917504 =3D 1179648 bytes
> software IO TLB: area num 2.
> Fallback order for Node 0: 0 1
> Fallback order for Node 1: 1 0
> Built 2 zonelists, mobility grouping on.  Total pages: 1834877
> Policy zone: Normal
> mem auto-init: stack:all(zero), heap alloc:on, heap free:off
> stackdepot: allocating hash table via alloc_large_system_hash
> stackdepot hash table entries: 1048576 (order: 12, 16777216 bytes, linear=
)
> stackdepot: allocating space for 8192 stack pools via memblock
> ------------[ cut here ]------------
> preempt_dynamic_mode =3D=3D preempt_dynamic_undefined
> WARNING: kernel/sched/core.c:7743 at preempt_model_full+0x1e/0x30, CPU#0:=
 swapper/0
> Modules linked in:
> CPU: 0 UID: 0 PID: 0 Comm: swapper Not tainted syzkaller #0 PREEMPT(undef=
)
> Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS 1.16.2-debian-1.=
16.2-1 04/01/2014
> RIP: 0010:preempt_model_full+0x1e/0x30
> Code: 90 90 90 90 90 90 90 90 90 90 90 90 f3 0f 1e fa 83 3d 35 d9 cb 0c f=
f 74 10 83 3d 2c d9 cb 0c 02 0f 94 c0 2e e9 93 fa 19 0a 90 <0f> 0b 90 eb ea=
 66 66 66 66 2e 0f 1f 84 00 00 00 00 00 90 90 90 90
> RSP: 0000:ffffffff8e407a78 EFLAGS: 00010046
> RAX: 1ffffffff1c359d9 RBX: 0000000000000001 RCX: 0000000000000000
> RDX: 0000000000000000 RSI: 0000000000000001 RDI: ffffea0004000000
> RBP: 0000000000040100 R08: ffffffff8221aafb R09: 0000000000000000
> R10: ffffed1020000000 R11: ffffed1024206961 R12: 0000000000000001
> R13: 0000000000000001 R14: ffff888100000000 R15: dffffc0000000000
> FS:  0000000000000000(0000) GS:ffff88818de62000(0000) knlGS:0000000000000=
000
> CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> CR2: ffff88823ffff000 CR3: 000000000e54c000 CR4: 00000000000000b0
> Call Trace:
>  <TASK>
>  kernel_init_pages+0x6d/0xe0
>  post_alloc_hook+0xae/0x1e0
>  get_page_from_freelist+0x24ba/0x2540
>  __alloc_frozen_pages_noprof+0x18d/0x380
>  alloc_pages_mpol+0x235/0x490
>  alloc_pages_noprof+0xac/0x2a0
>  __pud_alloc+0x3a/0x460
>  preallocate_vmalloc_pages+0x386/0x3d0
>  mm_core_init+0x79/0xb0
>  start_kernel+0x15a/0x3d0
>  x86_64_start_reservations+0x24/0x30
>  x86_64_start_kernel+0x143/0x1c0
>  common_startup_64+0x13e/0x147
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
> [akpm@linux-foundation.org ankur.a.arora@oracle.com bharata@amd.com hanne=
s@cmpxchg.org hsalunke@amd.com jackmanb@google.com linux-kernel@vger.kernel=
.org linux-mm@kvack.org mhocko@suse.com rkodsara@amd.com shivankg@amd.com s=
urenb@google.com vbabka@kernel.org ziy@nvidia.com]
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
-upstream-moderation/69d637bc.a00a0220.468cb.000c.GAE%40google.com.
