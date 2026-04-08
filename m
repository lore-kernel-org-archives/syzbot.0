Received: from mail-oo1-f69.google.com (mail-oo1-f69.google.com [209.85.161.69])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 763C037C0FB
	for <syzbot@lists.linux.dev>; Wed,  8 Apr 2026 11:10:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.161.69
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1775646655; cv=none; b=WQQZvf2P/43hTjcfSrXmyE8O/J/aOIYdMhi+0bnfjCfWCBps4sAZs2nfLRBxFPnhg/UQBcGB0E3lRQIlincUPWh74pVH+Wv1V3fDSaJetxQNj/dsyKUy9M43R3/AB4ZXOD5CtKjK4G0S/Uu9/2IMvBX4u1mfF7mQFC/0pFw89PY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1775646655; c=relaxed/simple;
	bh=y1Q9VMb8u8aJQItOs2SdLFgCSGyTlpfAewzOCybC1bg=;
	h=MIME-Version:Date:Message-ID:Subject:From:To:Cc:Content-Type; b=XazUOFB2eved/xRJ47P6HSGRQ+syENujCbmKbN+fLe0SSlFPpI5EyoytAlJ2JsEGuJGQQgcAYt1DAMd+jRYD3cf3de6bKHN6QgdP/Cgqpc1tHROKt2m/fYVfkKdTcHbC+3MRkAuKmmKJqaCigjpJgo1brAEHX2GvyjsgztqNmE8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com; arc=none smtp.client-ip=209.85.161.69
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com
Received: by mail-oo1-f69.google.com with SMTP id 006d021491bc7-67df391509fso14272371eaf.3
        for <syzbot@lists.linux.dev>; Wed, 08 Apr 2026 04:10:53 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1775646652; x=1776251452;
        h=content-transfer-encoding:cc:to:from:subject:message-id:date
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=QpRGNjEoxiLpkW47wkIw2VvKFxj8/Sj8Fqw4mBBUOD4=;
        b=Ogj81TmqaVa9lUKgGlxVsbAid2ox/yG57EE9QYml36WySWkLMY10YsL2IFXUVPecMQ
         rDDkGAeEsfLz3RV+uvEGyNuFvNPc+0bVP2e4iCp+Nt2eN4R29l/iD8FFpb4DFuXAutJI
         aZu0CHj+i/jij5O8ymQEZvEzzWUGrB+62hm9JG0MllJBw0th26mb2KMPG+ZHtntou4aH
         ZqVz1EVeBMbRaI/zX7TuLNEXa+f3GGy0NxwXnsjep5S9PXqGwE5JGlXRAOIp/0hES/Tv
         vbIsLYpXlLg0bDu5+ykuaWgyWvXr4tdCuaDdTWeyeFGYVTSEWmHxU7i0HUq2lbTz3acA
         hdIg==
X-Gm-Message-State: AOJu0YypjN4AQWNofoeD2TtIVeFDUIOjWEPXKJUjRlORA38bC+K+DlAX
	B6+f+BgSDsrGHaPY2CO9aopISQzdg4swK5EtmZ2IW2x6tVagEOmVllgk2tkfJqkX8umHRTaoCvu
	8RXcZmtDFK8tfM7gooYt5V3P8xsSp7pDUGc2+SxHBOp4NIGdNkFsr98YqzeY=
Precedence: bulk
X-Mailing-List: syzbot@lists.linux.dev
List-Id: <syzbot.lists.linux.dev>
List-Subscribe: <mailto:syzbot+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:syzbot+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Received: by 2002:a05:6820:8188:b0:67d:e5ad:4bbb with SMTP id
 006d021491bc7-6821db6b14dmr11235251eaf.25.1775646652425; Wed, 08 Apr 2026
 04:10:52 -0700 (PDT)
Date: Wed, 08 Apr 2026 04:10:52 -0700
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <69d637bc.a00a0220.468cb.000c.GAE@google.com>
Subject: [moderation/CI] Re: mm/page_alloc: use batch page clearing in kernel_init_pages()
From: syzbot ci <syzbot+ci0d80fc284c3061e1@syzkaller.appspotmail.com>
To: syzkaller-upstream-moderation@googlegroups.com
Cc: syzbot@lists.linux.dev
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

syzbot ci has tested the following series

[v1] mm/page_alloc: use batch page clearing in kernel_init_pages()
https://lore.kernel.org/all/20260408092441.435133-1-hsalunke@amd.com
* [PATCH] mm/page_alloc: use batch page clearing in kernel_init_pages()

and found the following issue:
WARNING in preempt_model_full

Full report is available here:
https://ci.syzbot.org/series/be6c0534-641b-42aa-8b73-ab8f592ec267

***

WARNING in preempt_model_full

tree:      mm-new
URL:       https://kernel.googlesource.com/pub/scm/linux/kernel/git/akpm/mm=
.git
base:      0d90551ea699ef3d1a85cd7a1a7e21e8d4f04db2
arch:      amd64
compiler:  Debian clang version 21.1.8 (++20251221033036+2078da43e25a-1~exp=
1~20251221153213.50), Debian LLD 21.1.8
config:    https://ci.syzbot.org/builds/22cbd293-31c6-46b9-b8d4-2ff590ce406=
b/config

CPU topo: Max. logical packages:   2
CPU topo: Max. logical nodes:      1
CPU topo: Num. nodes per package:  1
CPU topo: Max. logical dies:       2
CPU topo: Max. dies per package:   1
CPU topo: Max. threads per core:   1
CPU topo: Num. cores per package:     1
CPU topo: Num. threads per package:   1
CPU topo: Allowing 2 present CPUs plus 0 hotplug CPUs
kvm-guest: APIC: eoi() replaced with kvm_guest_apic_eoi_write()
PM: hibernation: Registered nosave memory: [mem 0x00000000-0x00000fff]
PM: hibernation: Registered nosave memory: [mem 0x0009f000-0x000fffff]
PM: hibernation: Registered nosave memory: [mem 0x7ffdf000-0xffffffff]
[gap 0xc0000000-0xfed1bfff] available for PCI devices
Booting paravirtualized kernel on KVM
clocksource: refined-jiffies: mask: 0xffffffff max_cycles: 0xffffffff, max_=
idle_ns: 19112604462750000 ns
Zone ranges:
  DMA      [mem 0x0000000000001000-0x0000000000ffffff]
  DMA32    [mem 0x0000000001000000-0x00000000ffffffff]
  Normal   [mem 0x0000000100000000-0x000000023fffffff]
  Device   empty
Movable zone start for each node
Early memory node ranges
  node   0: [mem 0x0000000000001000-0x000000000009efff]
  node   0: [mem 0x0000000000100000-0x000000007ffdefff]
  node   0: [mem 0x0000000100000000-0x0000000160000fff]
  node   1: [mem 0x0000000160001000-0x000000023fffffff]
Initmem setup node 0 [mem 0x0000000000001000-0x0000000160000fff]
Initmem setup node 1 [mem 0x0000000160001000-0x000000023fffffff]
On node 0, zone DMA: 1 pages in unavailable ranges
On node 0, zone DMA: 97 pages in unavailable ranges
On node 0, zone Normal: 33 pages in unavailable ranges
setup_percpu: NR_CPUS:8 nr_cpumask_bits:2 nr_cpu_ids:2 nr_node_ids:2
percpu: Embedded 71 pages/cpu s250120 r8192 d32504 u2097152
kvm-guest: PV spinlocks disabled, no host support
Kernel command line: earlyprintk=3Dserial net.ifnames=3D0 sysctl.kernel.hun=
g_task_all_cpu_backtrace=3D1 ima_policy=3Dtcb nf-conntrack-ftp.ports=3D2000=
0 nf-conntrack-tftp.ports=3D20000 nf-conntrack-sip.ports=3D20000 nf-conntra=
ck-irc.ports=3D20000 nf-conntrack-sane.ports=3D20000 binder.debug_mask=3D0 =
rcupdate.rcu_expedited=3D1 rcupdate.rcu_cpu_stall_cputime=3D1 no_hash_point=
ers page_owner=3Don sysctl.vm.nr_hugepages=3D4 sysctl.vm.nr_overcommit_huge=
pages=3D4 secretmem.enable=3D1 sysctl.max_rcu_stall_to_panic=3D1 msr.allow_=
writes=3Doff coredump_filter=3D0xffff root=3D/dev/sda console=3DttyS0 vsysc=
all=3Dnative numa=3Dfake=3D2 kvm-intel.nested=3D1 spec_store_bypass_disable=
=3Dprctl nopcid vivid.n_devs=3D64 vivid.multiplanar=3D1,2,1,2,1,2,1,2,1,2,1=
,2,1,2,1,2,1,2,1,2,1,2,1,2,1,2,1,2,1,2,1,2,1,2,1,2,1,2,1,2,1,2,1,2,1,2,1,2,=
1,2,1,2,1,2,1,2,1,2,1,2,1,2,1,2 netrom.nr_ndevs=3D32 rose.rose_ndevs=3D32 s=
mp.csd_lock_timeout=3D100000 watchdog_thresh=3D55 workqueue.watchdog_thresh=
=3D140 sysctl.net.core.netdev_unregister_timeout_secs=3D140 dummy_hcd.num=
=3D32 max_loop=3D32 nbds_max=3D32 \
Kernel command line: comedi.comedi_num_legacy_minors=3D4 panic_on_warn=3D1 =
root=3D/dev/sda console=3DttyS0 root=3D/dev/sda1
Unknown kernel command line parameters "nbds_max=3D32", will be passed to u=
ser space.
printk: log buffer data + meta data: 262144 + 917504 =3D 1179648 bytes
software IO TLB: area num 2.
Fallback order for Node 0: 0 1=20
Fallback order for Node 1: 1 0=20
Built 2 zonelists, mobility grouping on.  Total pages: 1834877
Policy zone: Normal
mem auto-init: stack:all(zero), heap alloc:on, heap free:off
stackdepot: allocating hash table via alloc_large_system_hash
stackdepot hash table entries: 1048576 (order: 12, 16777216 bytes, linear)
stackdepot: allocating space for 8192 stack pools via memblock
------------[ cut here ]------------
preempt_dynamic_mode =3D=3D preempt_dynamic_undefined
WARNING: kernel/sched/core.c:7743 at preempt_model_full+0x1e/0x30, CPU#0: s=
wapper/0
Modules linked in:
CPU: 0 UID: 0 PID: 0 Comm: swapper Not tainted syzkaller #0 PREEMPT(undef)=
=20
Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS 1.16.2-debian-1.16=
.2-1 04/01/2014
RIP: 0010:preempt_model_full+0x1e/0x30
Code: 90 90 90 90 90 90 90 90 90 90 90 90 f3 0f 1e fa 83 3d 35 d9 cb 0c ff =
74 10 83 3d 2c d9 cb 0c 02 0f 94 c0 2e e9 93 fa 19 0a 90 <0f> 0b 90 eb ea 6=
6 66 66 66 2e 0f 1f 84 00 00 00 00 00 90 90 90 90
RSP: 0000:ffffffff8e407a78 EFLAGS: 00010046
RAX: 1ffffffff1c359d9 RBX: 0000000000000001 RCX: 0000000000000000
RDX: 0000000000000000 RSI: 0000000000000001 RDI: ffffea0004000000
RBP: 0000000000040100 R08: ffffffff8221aafb R09: 0000000000000000
R10: ffffed1020000000 R11: ffffed1024206961 R12: 0000000000000001
R13: 0000000000000001 R14: ffff888100000000 R15: dffffc0000000000
FS:  0000000000000000(0000) GS:ffff88818de62000(0000) knlGS:000000000000000=
0
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: ffff88823ffff000 CR3: 000000000e54c000 CR4: 00000000000000b0
Call Trace:
 <TASK>
 kernel_init_pages+0x6d/0xe0
 post_alloc_hook+0xae/0x1e0
 get_page_from_freelist+0x24ba/0x2540
 __alloc_frozen_pages_noprof+0x18d/0x380
 alloc_pages_mpol+0x235/0x490
 alloc_pages_noprof+0xac/0x2a0
 __pud_alloc+0x3a/0x460
 preallocate_vmalloc_pages+0x386/0x3d0
 mm_core_init+0x79/0xb0
 start_kernel+0x15a/0x3d0
 x86_64_start_reservations+0x24/0x30
 x86_64_start_kernel+0x143/0x1c0
 common_startup_64+0x13e/0x147
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
[akpm@linux-foundation.org ankur.a.arora@oracle.com bharata@amd.com hannes@=
cmpxchg.org hsalunke@amd.com jackmanb@google.com linux-kernel@vger.kernel.o=
rg linux-mm@kvack.org mhocko@suse.com rkodsara@amd.com shivankg@amd.com sur=
enb@google.com vbabka@kernel.org ziy@nvidia.com]

If the report looks fine to you, reply with:
#syz upstream

If the report is a false positive, reply with
#syz invalid

