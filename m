Received: from mail-wm1-f45.google.com (mail-wm1-f45.google.com [209.85.128.45])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 84B6F393DF2
	for <syzbot@lists.linux.dev>; Mon, 20 Apr 2026 10:04:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.128.45
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776679488; cv=pass; b=i/y/+jedT6UgU1Qmxqj89AE8pl0MbWzZ5SaatUR+V0sJPg+7ijST2Kcsa7Y+EGYbIWBVVCHXLFc1wyiUjNt6e13a+56UebOLMTqAiaFM/fzK9/wDwefj10iKW3FFWmwZLhiMXrcddhGpQWcCK1AWKzD4NNNkeAg2Cs1vrRQ7KwA=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776679488; c=relaxed/simple;
	bh=mVw1sM1/ehV8JQiP+6Xix2af7mKRQDG+Mmy/gdnF7+c=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=hcJ+EJ4hjH/2nIdi4S59YwzLyiVAQ68R26Gz4YAglQoGyq1qY8PrzYU6fYRli4Uuxo3O6pcbjEfBHzOnYZ40vcfwS0hNltP73BEhfEPoSZe7OOghqHkcMRqdXspZp43p8uMzwVLDCczNWktxlmFK2Ut+8qjQTbjURBRfAVV9LGo=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=Z7Gn5bcd; arc=pass smtp.client-ip=209.85.128.45
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="Z7Gn5bcd"
Received: by mail-wm1-f45.google.com with SMTP id 5b1f17b1804b1-488a88aeec9so42374245e9.2
        for <syzbot@lists.linux.dev>; Mon, 20 Apr 2026 03:04:46 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1776679485; cv=none;
        d=google.com; s=arc-20240605;
        b=SGIxnSPRdSPtPV6fhHzuk9OjzvpG8erXjzwM13WPFWN5nJqMGmy2v/z+larnrJ40mP
         xH+G5O1LbC3gLIZxm6SAl9FyLV4gBsRjyu83DThz43ZmcoMAYqYxqgPwzFAAMmW9WmAx
         IK00+J/vO4V8pvFDwLxYyGtm1zS1KFSFDod2uGXq0p61el2CsIUWYS4hwNlJcYPQCeNV
         cHpxpKulluyIBEj1jLsNYAUjhV8y50uG+aImXXB/z38QUTHT17F2yvavjM/So3gMgHV0
         IP8HE4YFY0Z+r7NAphvSwaPK971k3/RdyHMUscnwUN9bHfdpueudj0e7GD4JLOHGQ5oR
         T8MA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=ipRD4DknNBX6Ev2QOQ9zt6zxWIhUOFm5L9fusI90BxI=;
        fh=tlB3zOCMsPpAFPqJ12TrUlkHTvlOmBswbUrszPaALrA=;
        b=XqnwpvJtqu+4QIA1HzVg7KJtLUe07jh6wYTIJs0/bJY0spTg9cuDGIkFYODqPjX8+N
         4q0FSKBJKrHd3L+vuQpqQS6Rdtbt9MU8fATZ5esbN9mHBErN94vYGI6r03WeJkin5tPb
         SxeetmJjhYbA4s55v/qGtpc+8UF0nYXFWS0IWVy4oqX4p183qZkUQvxNIkZ5Hl3SxHwC
         ij9nOB7zZHsNHGk1gu0+Rf61Qm+sstV/TMCO/TavvKkov9i8mOzcgUqoOCug1DmQ+Vwt
         13ILeow9csuT/Y9AsW2O5U4+Pwj4JGmWK3/lybh1iJt3f0OQvwYtyje1yCUbCjPVaNEI
         GSMA==;
        darn=lists.linux.dev
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1776679485; x=1777284285; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=ipRD4DknNBX6Ev2QOQ9zt6zxWIhUOFm5L9fusI90BxI=;
        b=Z7Gn5bcdjwBez3emwfAMEStKJOVGEm92sFIy692Ryh3A3APzqLqkFDdmDyFbNUQ1u4
         H9gG25pMKxdG/oneY7EtWyplv5DhQa+zkT82oO2C0tuUL1h54D1dAJb1i1uij3NtwT+a
         XBVoqW1pSVWGvwapWrSEX4m3Ceuu0DsO5nbSZhuXJ8NQqqecYs6g/RCN9H1GnepO//LY
         /YhplpncvJ5ykPqIDNOCybsNCqV9wtXXlEMibiy5rN4uNxYRqP/WP17VcL44GMfer3gn
         QxlhVaBddSlzu+Q4obTdV3eGnv4JZXZYfpANSJo7aMI3EEzSKeh0J1PxYcHPOacMQyiU
         5Ifg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1776679485; x=1777284285;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=ipRD4DknNBX6Ev2QOQ9zt6zxWIhUOFm5L9fusI90BxI=;
        b=KivPdpP/fkvnkzd0sOlcFmG6FOP8xNj5oPKAV8XKgZ9vxgyooTS8fVCXX8c1pGko7C
         DcbB5yrBmx8cehzjdrfAcDWck0uB7AN9MuwsV6vPBeNmFL+sBp8uvtH/r/N88XHp75M7
         gKq065PKle29bBSilmFaqM0Z19Kb3S2N2Yyc51Virk7is+Nhx+nI5E+/Uo4i8nol/RG8
         t+/6OzF/FS0MW+QbR0MNq8qj16vFT8d51GBpc00GjH0s8hOc74F3AWSE7WKCKoZ/mHc0
         Sdoo/A1xfwjBQURRWYgrjuz2FvR/xaSKf8jZxzFw0JRqxZ61V5186mprXCEZ/vKzEC1r
         9QYA==
X-Forwarded-Encrypted: i=1; AFNElJ/ooNdsKZUhGiz8G3Urincg3b4W/Paki4CCwrfGQqKQrfO9+fLOkb8agFmd2iXhznW8EfZJ5Xo=@lists.linux.dev
X-Gm-Message-State: AOJu0YygkpjTyJJbaV/23ojl+ynVODsQzn/Wzy8IjaVtmP2alc2s3aJu
	Wl0+7xtLC8wOz2z8ppoMjQmY8bvtt7AEVCsAL+5jWqhTLDHiJNzbOh15/7kwX/xwfL37z8uyUuY
	E2UEUAI5DGeaIHpuVTI3HnjGM1IklgLrkVZf/nzo+ZoFuhLlyyk53rdBf
X-Gm-Gg: AeBDies/Qub3eE/4VyEYQZpNnuRHc9qOsEszWj+5fOb2RPHu/LfLcLkrr3+v7qBlr+9
	XxuQMsQX4dHBGHNMFe1V30qRqYAU++goIUTYPkRgSSyzyEv6KVn8RuvEf3Vho1EzmCVqvuZeMuP
	LBQLzU/DoD4TUFsVMm3MjBtVn1f5cHjVy0K0cct9D4VdytIOSkZ1Xhc83vdSmFTjMMg/MqsKThT
	ZWbhqqAJ0mSXntBuDIbd18T+KQegLMS5NY5DKCtDIpURWkOd54/+UxXnTB6v0w2Gnnk4GPkUnG/
	Uwpbb6ssKOzGwj1A6hz1NRGKuklFRYxobQJ6wh9PT3OzZux2kYH8vGNK7ZWXiV52zj6mRC3LLmu
	XJaBC8O5meQRU4cE=
X-Received: by 2002:a05:600d:1b:b0:483:8062:b43 with SMTP id
 5b1f17b1804b1-488fb771438mr155990775e9.19.1776679484278; Mon, 20 Apr 2026
 03:04:44 -0700 (PDT)
Precedence: bulk
X-Mailing-List: syzbot@lists.linux.dev
List-Id: <syzbot.lists.linux.dev>
List-Subscribe: <mailto:syzbot+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:syzbot+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <69e5f897.050a0220.24bfd3.0024.GAE@google.com>
In-Reply-To: <69e5f897.050a0220.24bfd3.0024.GAE@google.com>
From: Pimyn Girgis <pimyn@google.com>
Date: Mon, 20 Apr 2026 12:04:32 +0200
X-Gm-Features: AQROBzCCHa_CxF4bXdxUIBvrud7s_n7UdBrYcwCcI3PcHg7sWzGs8VjoUi6KjSs
Message-ID: <CAJWNTGxB4d=m2R6FR4eGV3qGmfj8HPxuG12+oNVDbmHJh1Fe0Q@mail.gmail.com>
Subject: Re: [moderation/CI] Re: mm: improve folio refcount scalability
To: syzbot ci <syzbot+ci03ba24ce9bc91ad4@syzkaller.appspotmail.com>
Cc: syzkaller-upstream-moderation@googlegroups.com, syzbot@lists.linux.dev
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

#syz upstream

On Mon, Apr 20, 2026 at 11:57=E2=80=AFAM syzbot ci
<syzbot+ci03ba24ce9bc91ad4@syzkaller.appspotmail.com> wrote:
>
> syzbot ci has tested the following series
>
> [v2] mm: improve folio refcount scalability
> https://lore.kernel.org/all/cover.1776350895.git.gorbunov.ivan@h-partners=
.com
> * [PATCH v2 1/2] mm: drop page refcount zero state semantics
> * [PATCH v2 2/2] mm: implement page refcount locking via dedicated bit
>
> and found the following issue:
> kernel BUG in get_page_bootmem
>
> Full report is available here:
> https://ci.syzbot.org/series/eb14b73a-c461-4be5-b5af-91864e939f4c
>
> ***
>
> kernel BUG in get_page_bootmem
>
> tree:      mm-new
> URL:       https://kernel.googlesource.com/pub/scm/linux/kernel/git/akpm/=
mm.git
> base:      f4279f87cd6c82ebdaccdc56f38e7b80ca7fcc03
> arch:      amd64
> compiler:  Debian clang version 21.1.8 (++20251221033036+2078da43e25a-1~e=
xp1~20251221153213.50), Debian LLD 21.1.8
> config:    https://ci.syzbot.org/builds/60ced5f4-8c33-43ea-a4ee-92d9b2b8f=
949/config
>
> ACPI: HPET id: 0x8086a201 base: 0xfed00000
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
> kernel BUG at ./include/linux/page_ref.h:171!
> Oops: invalid opcode: 0000 [#1] SMP KASAN PTI
> CPU: 0 UID: 0 PID: 0 Comm: swapper Not tainted syzkaller #0 PREEMPT(undef=
)
> Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS 1.16.2-debian-1.=
16.2-1 04/01/2014
> RIP: 0010:get_page_bootmem+0x188/0x190
> Code: 86 ff 90 0f 0b e8 98 52 86 ff 90 0f 0b e8 90 52 86 ff 48 89 df 48 c=
7 c6 00 e4 dd 8b e8 51 d7 e8 fe 90 0f 0b e8 79 52 86 ff 90 <0f> 0b 66 0f 1f=
 44 00 00 90 90 90 90 90 90 90 90 90 90 90 90 90 90
> RSP: 0000:ffffffff8e407e50 EFLAGS: 00010093
> RAX: ffffffff823f42b7 RBX: ffffea00057ffec0 RCX: ffffffff8e494ec0
> RDX: 0000000000000000 RSI: 0000000000000001 RDI: 0000000000000001
> RBP: 0000000000000001 R08: ffffea00057ffef7 R09: 1ffffd4000afffde
> R10: dffffc0000000000 R11: fffff94000afffdf R12: dffffc0000000000
> R13: 0000000000000000 R14: ffffea00057ffef4 R15: 0000000000000003
> FS:  0000000000000000(0000) GS:ffff88818de62000(0000) knlGS:0000000000000=
000
> CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> CR2: ffff88823ffff000 CR3: 000000000e54c000 CR4: 00000000000000b0
> Call Trace:
>  <TASK>
>  register_page_bootmem_info_node+0x88/0x410
>  register_page_bootmem_info+0x77/0xc0
>  mem_init+0x5a/0xb0
>  mm_core_init+0x79/0xb0
>  start_kernel+0x15a/0x3d0
>  x86_64_start_reservations+0x24/0x30
>  x86_64_start_kernel+0x143/0x1c0
>  common_startup_64+0x13e/0x147
>  </TASK>
> Modules linked in:
> ---[ end trace 0000000000000000 ]---
> RIP: 0010:get_page_bootmem+0x188/0x190
> Code: 86 ff 90 0f 0b e8 98 52 86 ff 90 0f 0b e8 90 52 86 ff 48 89 df 48 c=
7 c6 00 e4 dd 8b e8 51 d7 e8 fe 90 0f 0b e8 79 52 86 ff 90 <0f> 0b 66 0f 1f=
 44 00 00 90 90 90 90 90 90 90 90 90 90 90 90 90 90
> RSP: 0000:ffffffff8e407e50 EFLAGS: 00010093
> RAX: ffffffff823f42b7 RBX: ffffea00057ffec0 RCX: ffffffff8e494ec0
> RDX: 0000000000000000 RSI: 0000000000000001 RDI: 0000000000000001
> RBP: 0000000000000001 R08: ffffea00057ffef7 R09: 1ffffd4000afffde
> R10: dffffc0000000000 R11: fffff94000afffdf R12: dffffc0000000000
> R13: 0000000000000000 R14: ffffea00057ffef4 R15: 0000000000000003
> FS:  0000000000000000(0000) GS:ffff88818de62000(0000) knlGS:0000000000000=
000
> CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> CR2: ffff88823ffff000 CR3: 000000000e54c000 CR4: 00000000000000b0
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
> [akpm@linux-foundation.org apopple@nvidia.com artem.kuzin@huawei.com baol=
in.wang@linux.alibaba.com david@kernel.org gladyshev.ilya1@h-partners.com g=
orbunov.ivan@h-partners.com harry.yoo@oracle.com kirill@shutemov.name liam.=
howlett@oracle.com linux-kernel@vger.kernel.org linux-mm@kvack.org lorenzo.=
stoakes@oracle.com mhocko@suse.com muchun.song@linux.dev rppt@kernel.org su=
renb@google.com torvalds@linuxfoundation.org vbabka@suse.cz willy@infradead=
.org yuzhao@google.com ziy@nvidia.com]
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
-upstream-moderation/69e5f897.050a0220.24bfd3.0024.GAE%40google.com.
