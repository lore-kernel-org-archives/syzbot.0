Received: from mail-oi1-f200.google.com (mail-oi1-f200.google.com [209.85.167.200])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 65CBD3859E6
	for <syzbot@lists.linux.dev>; Mon, 20 Apr 2026 09:57:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.167.200
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776679066; cv=none; b=t0A8gA7pnyJxU13X5qRrxYW/89Lk+6a5cj35Vyf5q89HNEph+XXB+EME2GKVz1ufqkeZFKpXp4Dulhr1idwBuHr5jRUsH8QiVAImdGOn0COPwfK67Oeokuvh2A05Jt/bXmmkATgWpAVZQ+XqcobnrbAkoyEyCOCCDTd3zkVqsBc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776679066; c=relaxed/simple;
	bh=f/oMl2JD711Z8U0LVxpdh9CxEwVxd5r2RTN9r7z5jao=;
	h=MIME-Version:Date:Message-ID:Subject:From:To:Cc:Content-Type; b=BfKrnwYbEwfcVIz8tUIrdqEP8OPerzGvtvsuzD1jD91UPlcC4qZ7pITVABSU7yaegfQg+M3s0cvsgKuLBEgHgaOiCeWyVwXzOiVNaldUROkEnVjaYQvLkjZHMZpeplnGgv5S7x9HOSe0Bnw1LL//QhGc8eRLUodJUm0iHkh9jwk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com; arc=none smtp.client-ip=209.85.167.200
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com
Received: by mail-oi1-f200.google.com with SMTP id 5614622812f47-46f083f82c7so5725031b6e.1
        for <syzbot@lists.linux.dev>; Mon, 20 Apr 2026 02:57:44 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1776679063; x=1777283863;
        h=content-transfer-encoding:cc:to:from:subject:message-id:date
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=tL74U2if6PSRWdQ/MxG663NtcOVLxhVwV8Ko6SZSKLs=;
        b=im55Kwq9jU5nUbtpYBog11YBNg1gkUUTlm0W2v85RienO7l8clmFmf2oXK4dhGkjnD
         giUVMkYGRJG5U99x3X/ucAkheDDMsynQ3nEtWSt2XeOybLNGmxoZ6+V4CNfo7s0SdLNv
         hxQMhmoaCY466w/Npi75+muuSTQGw/1KujNrHtEXsY55jND7gY3hMObVlAEkUrIsgTXj
         aFJJShspRdUmyN6RNekW4LdPNgjKA7b4KL0Oni2F4TtaLUHeW8P6zAbfOOVg5yCOVec9
         sKYkOqbzMyWdcACwMmJxIHLjfQ/Hq1WIHAd69dvoc45GBo0cvO21oQA6chDKwdipUOG3
         l6Tg==
X-Gm-Message-State: AOJu0YzcQ9K6a1EMoq3LFc6aFpCSVVPhTmp111pvaZs4obXJ5dfHEj5q
	uTJBFuvMNWFLPc3rgq0eiZg9N/7aYImvmmd//nbhYKj8Tyx+4T3mSCuh0E+DRLF73Y6Tq5Fm2+x
	nTOOSnGO2tIXXfiEi/VeenLMgvdZibzvshz7G3VyjybrT8LsbOT4UxgSTsVE=
Precedence: bulk
X-Mailing-List: syzbot@lists.linux.dev
List-Id: <syzbot.lists.linux.dev>
List-Subscribe: <mailto:syzbot+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:syzbot+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Received: by 2002:a05:6820:c0d4:10b0:694:85da:3f92 with SMTP id
 006d021491bc7-69485da46e5mr758581eaf.17.1776679063260; Mon, 20 Apr 2026
 02:57:43 -0700 (PDT)
Date: Mon, 20 Apr 2026 02:57:43 -0700
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <69e5f897.050a0220.24bfd3.0024.GAE@google.com>
Subject: [moderation/CI] Re: mm: improve folio refcount scalability
From: syzbot ci <syzbot+ci03ba24ce9bc91ad4@syzkaller.appspotmail.com>
To: syzkaller-upstream-moderation@googlegroups.com
Cc: syzbot@lists.linux.dev
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

syzbot ci has tested the following series

[v2] mm: improve folio refcount scalability
https://lore.kernel.org/all/cover.1776350895.git.gorbunov.ivan@h-partners.c=
om
* [PATCH v2 1/2] mm: drop page refcount zero state semantics
* [PATCH v2 2/2] mm: implement page refcount locking via dedicated bit

and found the following issue:
kernel BUG in get_page_bootmem

Full report is available here:
https://ci.syzbot.org/series/eb14b73a-c461-4be5-b5af-91864e939f4c

***

kernel BUG in get_page_bootmem

tree:      mm-new
URL:       https://kernel.googlesource.com/pub/scm/linux/kernel/git/akpm/mm=
.git
base:      f4279f87cd6c82ebdaccdc56f38e7b80ca7fcc03
arch:      amd64
compiler:  Debian clang version 21.1.8 (++20251221033036+2078da43e25a-1~exp=
1~20251221153213.50), Debian LLD 21.1.8
config:    https://ci.syzbot.org/builds/60ced5f4-8c33-43ea-a4ee-92d9b2b8f94=
9/config

ACPI: HPET id: 0x8086a201 base: 0xfed00000
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
kernel BUG at ./include/linux/page_ref.h:171!
Oops: invalid opcode: 0000 [#1] SMP KASAN PTI
CPU: 0 UID: 0 PID: 0 Comm: swapper Not tainted syzkaller #0 PREEMPT(undef)=
=20
Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS 1.16.2-debian-1.16=
.2-1 04/01/2014
RIP: 0010:get_page_bootmem+0x188/0x190
Code: 86 ff 90 0f 0b e8 98 52 86 ff 90 0f 0b e8 90 52 86 ff 48 89 df 48 c7 =
c6 00 e4 dd 8b e8 51 d7 e8 fe 90 0f 0b e8 79 52 86 ff 90 <0f> 0b 66 0f 1f 4=
4 00 00 90 90 90 90 90 90 90 90 90 90 90 90 90 90
RSP: 0000:ffffffff8e407e50 EFLAGS: 00010093
RAX: ffffffff823f42b7 RBX: ffffea00057ffec0 RCX: ffffffff8e494ec0
RDX: 0000000000000000 RSI: 0000000000000001 RDI: 0000000000000001
RBP: 0000000000000001 R08: ffffea00057ffef7 R09: 1ffffd4000afffde
R10: dffffc0000000000 R11: fffff94000afffdf R12: dffffc0000000000
R13: 0000000000000000 R14: ffffea00057ffef4 R15: 0000000000000003
FS:  0000000000000000(0000) GS:ffff88818de62000(0000) knlGS:000000000000000=
0
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: ffff88823ffff000 CR3: 000000000e54c000 CR4: 00000000000000b0
Call Trace:
 <TASK>
 register_page_bootmem_info_node+0x88/0x410
 register_page_bootmem_info+0x77/0xc0
 mem_init+0x5a/0xb0
 mm_core_init+0x79/0xb0
 start_kernel+0x15a/0x3d0
 x86_64_start_reservations+0x24/0x30
 x86_64_start_kernel+0x143/0x1c0
 common_startup_64+0x13e/0x147
 </TASK>
Modules linked in:
---[ end trace 0000000000000000 ]---
RIP: 0010:get_page_bootmem+0x188/0x190
Code: 86 ff 90 0f 0b e8 98 52 86 ff 90 0f 0b e8 90 52 86 ff 48 89 df 48 c7 =
c6 00 e4 dd 8b e8 51 d7 e8 fe 90 0f 0b e8 79 52 86 ff 90 <0f> 0b 66 0f 1f 4=
4 00 00 90 90 90 90 90 90 90 90 90 90 90 90 90 90
RSP: 0000:ffffffff8e407e50 EFLAGS: 00010093
RAX: ffffffff823f42b7 RBX: ffffea00057ffec0 RCX: ffffffff8e494ec0
RDX: 0000000000000000 RSI: 0000000000000001 RDI: 0000000000000001
RBP: 0000000000000001 R08: ffffea00057ffef7 R09: 1ffffd4000afffde
R10: dffffc0000000000 R11: fffff94000afffdf R12: dffffc0000000000
R13: 0000000000000000 R14: ffffea00057ffef4 R15: 0000000000000003
FS:  0000000000000000(0000) GS:ffff88818de62000(0000) knlGS:000000000000000=
0
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: ffff88823ffff000 CR3: 000000000e54c000 CR4: 00000000000000b0


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
[akpm@linux-foundation.org apopple@nvidia.com artem.kuzin@huawei.com baolin=
.wang@linux.alibaba.com david@kernel.org gladyshev.ilya1@h-partners.com gor=
bunov.ivan@h-partners.com harry.yoo@oracle.com kirill@shutemov.name liam.ho=
wlett@oracle.com linux-kernel@vger.kernel.org linux-mm@kvack.org lorenzo.st=
oakes@oracle.com mhocko@suse.com muchun.song@linux.dev rppt@kernel.org sure=
nb@google.com torvalds@linuxfoundation.org vbabka@suse.cz willy@infradead.o=
rg yuzhao@google.com ziy@nvidia.com]

If the report looks fine to you, reply with:
#syz upstream

If the report is a false positive, reply with
#syz invalid

