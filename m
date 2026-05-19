Received: from mail-oo1-f70.google.com (mail-oo1-f70.google.com [209.85.161.70])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5ACB1405C55
	for <syzbot@lists.linux.dev>; Tue, 19 May 2026 03:25:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.161.70
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779161158; cv=none; b=TlUUepBSyCllEX9ctwNsi2/5p6i8eORzFomFiXNSjTAE+2sR6sGFcRFPiclrex138WSxilAXrAGib78q0rU3MYo5hZIcy6f6lSH3l3xI993W+Jlr7Zu6GtQBl0bMBFWG7QYoe7DK/6pWPO8u2Mnl0AsW6SUNrsVVOoZpeNOEOgA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779161158; c=relaxed/simple;
	bh=QafaRF5OGBZn+DK/ZtOrH7oDor70V5r9to+lG6tqBk4=;
	h=MIME-Version:Date:Message-ID:Subject:From:To:Cc:Content-Type; b=pbLOlYC/E7RkVXVmohN4+5uImNHoLd0jzcGJWMuEOVr7RUuSme/ffkx/QxcnCB9KFT1unqEO7mUR/FLqhI4YufhG432pNJVzV9cJGPCd2CJkbPLDtmooj+cl/vHmLcbG4mI6I6cMxhMwLRQqEnfBsJeXYAdOlDEpIAVmrb4DIqQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com; arc=none smtp.client-ip=209.85.161.70
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com
Received: by mail-oo1-f70.google.com with SMTP id 006d021491bc7-696307c7ee0so2890860eaf.0
        for <syzbot@lists.linux.dev>; Mon, 18 May 2026 20:25:56 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1779161155; x=1779765955;
        h=content-transfer-encoding:cc:to:from:subject:message-id:date
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=gcadxrXPb5g4Ua/ZnVInmxenp4pB0H5pmhrNPAuzLsc=;
        b=RXAE1Nt5Ei2jHDw/IAeXgOO5Qafem10sP99zEy1msHNH6GTNcR2KF7TN2GM4fPtAWr
         9Ty6vC+QI5xEdNO5TkzCm2xwvaEtI/hCLgPC6PVC2/wK13FAUfYbms7GEyreST6ZkqqO
         OXHh2WvhTslzqUGhdezjZK4BFGqWWekIjGEWHIAJYitrcO1JDqCpfhXwqCMzOvmIUENV
         UjyqPTmSHt6lYC73D38gV/q0G0sKGtYSxgzcAP5ptiQtnFnlMTgj6oiV9yjejuMrPsci
         bqZhvkzbjNoBWf6DSrrZfhFGqAtnuCPFjwoL8GuQ1/6JzdvD0aZDWtUQUxB/3c+HWrBu
         FSTg==
X-Gm-Message-State: AOJu0YynmcwYv77zPyqUYdS6oaVRygTdD2GWoRNNAxbBvkY9oP5u5hT+
	JDv2iD/kN8cGQvYZhZsWPIr06r2xgiRywBqPopftQ2c7EcHhPzgLPj+P00BTT0SFNnPSngvrIXZ
	OENiqPEUSmGOryDKl5RHGGcH+8SyMZMHgmyXqmOd7kenpQLsQIAFSItnStvY=
Precedence: bulk
X-Mailing-List: syzbot@lists.linux.dev
List-Id: <syzbot.lists.linux.dev>
List-Subscribe: <mailto:syzbot+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:syzbot+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Received: by 2002:a05:6820:80c1:b0:699:a7d1:5fd5 with SMTP id
 006d021491bc7-69c9437cce9mr10326146eaf.39.1779161155369; Mon, 18 May 2026
 20:25:55 -0700 (PDT)
Date: Mon, 18 May 2026 20:25:55 -0700
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <6a0bd843.170a0220.39a587.0002.GAE@google.com>
Subject: [moderation/CI] Re: Introduce Per-CPU Work helpers (was QPW)
From: syzbot ci <syzbot+ci19dafd1fc4b94b9e@syzkaller.appspotmail.com>
To: syzkaller-upstream-moderation@googlegroups.com
Cc: syzbot@lists.linux.dev
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

syzbot ci has tested the following series

[v4] Introduce Per-CPU Work helpers (was QPW)
https://lore.kernel.org/all/20260519012754.240804-1-leobras.c@gmail.com
* [PATCH v4 1/4] Introducing pw_lock() and per-cpu queue & flush work
* [PATCH v4 2/4] mm/swap: move bh draining into a separate workqueue
* [PATCH v4 3/4] swap: apply new pw_queue_on() interface
* [PATCH v4 4/4] slub: apply new pw_queue_on() interface

and found the following issue:
WARNING in __pcs_replace_empty_main

Full report is available here:
https://ci.syzbot.org/series/804f81bd-77b4-490e-bd57-6345ad2aa923

***

WARNING in __pcs_replace_empty_main

tree:      drm-next
URL:       https://gitlab.freedesktop.org/drm/kernel.git
base:      5200f5f493f79f14bbdc349e402a40dfb32f23c8
arch:      amd64
compiler:  Debian clang version 21.1.8 (++20251221033036+2078da43e25a-1~exp=
1~20251221153213.50), Debian LLD 21.1.8
config:    https://ci.syzbot.org/builds/3ea80958-13bd-49da-9c64-6deb788113f=
8/config

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
percpu: Embedded 71 pages/cpu s250632 r8192 d31992 u2097152
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
**********************************************************
**   NOTICE NOTICE NOTICE NOTICE NOTICE NOTICE NOTICE   **
**                                                      **
** This system shows unhashed kernel memory addresses   **
** via the console, logs, and other interfaces. This    **
** might reduce the security of your system.            **
**                                                      **
** If you see this message and you are not debugging    **
** the kernel, report this immediately to your system   **
** administrator!                                       **
**                                                      **
** Use hash_pointers=3Dalways to force this mode off      **
**                                                      **
**   NOTICE NOTICE NOTICE NOTICE NOTICE NOTICE NOTICE   **
**********************************************************
------------[ cut here ]------------
debug_locks && !(lock_is_held(&(&s->cpu_sheaves->lock)->dep_map) !=3D 0)
WARNING: mm/slub.c:4601 at __pcs_replace_empty_main+0x51b/0x6e0, CPU#0: swa=
pper/0
Modules linked in:
CPU: 0 UID: 0 PID: 0 Comm: swapper Not tainted syzkaller #0 PREEMPT(undef)=
=20
Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS 1.16.2-debian-1.16=
.2-1 04/01/2014
RIP: 0010:__pcs_replace_empty_main+0x51b/0x6e0
Code: 48 85 f6 74 15 4c 89 ff 48 89 c6 e8 af 5e ff ff 4d 89 74 24 38 e9 36 =
fc ff ff 49 89 44 24 40 4d 89 74 24 38 e9 27 fc ff ff 90 <0f> 0b 90 83 7b 2=
c 00 0f 85 23 fb ff ff 48 8b 1b e8 20 cd 82 09 41
RSP: 0000:ffffffff8e607d58 EFLAGS: 00010046
RAX: 0000000000000000 RBX: ffffffff91bb8398 RCX: 0000000000000002
RDX: 0000000000000cc0 RSI: ffffffff8e21ec94 RDI: ffffffff8c28b160
RBP: 0000000000000cc0 R08: 0000000000005e00 R09: 00000000477ac845
R10: 0000000047d13f7f R11: 000000002fa01ecd R12: ffff88812103f308
R13: 0000000000000000 R14: ffffffff91bb8398 R15: 0000000000000000
FS:  0000000000000000(0000) GS:ffff88818dc8a000(0000) knlGS:000000000000000=
0
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: ffff88823ffff000 CR3: 000000000e74a000 CR4: 00000000000000b0
Call Trace:
 <TASK>
 kmem_cache_alloc_node_noprof+0x441/0x690
 do_kmem_cache_create+0x172/0x620
 create_boot_cache+0xbf/0x120
 kmem_cache_init+0x11a/0x1e0
 mm_core_init+0x7e/0xb0
 start_kernel+0x15a/0x3e0
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
[akpm@linux-foundation.org axelrasmussen@google.com baohua@kernel.org bhe@r=
edhat.com boqun@kernel.org bp@alien8.de brauner@kernel.org chrisl@kernel.or=
g cl@gentwo.org corbet@lwn.net coxu@redhat.com dapeng1.mi@linux.intel.com d=
avid@kernel.org dianders@chromium.org ebiggers@kernel.org elver@google.com =
feng.tang@linux.alibaba.com frederic@kernel.org gary@garyguo.net hannes@cmp=
xchg.org hao.li@linux.dev harry@kernel.org jackmanb@google.com jannh@google=
.com kasong@tencent.com kees@kernel.org kuba@kernel.org leobras.c@gmail.com=
 liam@infradead.org linux-doc@vger.kernel.org linux-kernel@vger.kernel.org =
linux-mm@kvack.org linux-rt-devel@lists.linux.dev lirongqing@baidu.com ljs@=
kernel.org longman@redhat.com masahiroy@kernel.org mhocko@suse.com mingo@re=
dhat.com mtosatti@redhat.com nathan@kernel.org nphamcs@gmail.com nsc@kernel=
.org ojeda@kernel.org pasha.tatashin@soleen.com paulmck@kernel.org peterz@i=
nfradead.org pfalcato@suse.de qi.zheng@linux.dev rdunlap@infradead.org]

If the report looks fine to you, reply with:
#syz upstream

If the report is a false positive, reply with
#syz invalid

