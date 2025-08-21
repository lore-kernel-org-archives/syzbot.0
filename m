Received: from mail-oa1-f48.google.com (mail-oa1-f48.google.com [209.85.160.48])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 90C7029BD82
	for <syzbot@lists.linux.dev>; Thu, 21 Aug 2025 21:36:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.160.48
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755812181; cv=none; b=QluFSSOMY2zr74gxjzMmQkUwBdEf8sXQCdw7nAMhHqs6aojghcbrqJ0O/wWhuaJD299O0PovdPJlbRrQ9dWLq1rHKpO+ZnRYfPdxLia0Ef1EEU5zythMjjSgBx3Y5i1J3+jWNM/qw+5n4MLHcxO3t5VQ9rd+np0jZvCJoRgbUd0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755812181; c=relaxed/simple;
	bh=MU03O7OpGyQ6j9R8Dd9WoYWz3ymLGSmUvmlWjPqskOM=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=rSs1oJcIECRaNI3REMeNoBXURSeNgYd1f+0ZSXp3Cjb/pEF+BVvWA3HxdChJDknzXY940gX80ikrc6jrIT05ikaTzkK5FeMqt+uaIAnDrmEgKavH7PCQiHKEz12Jj993m+atpY/GVQgL1X5zSmoSYIi0aLBcNuvGJvNirMoqtxs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=fFAjjh2a; arc=none smtp.client-ip=209.85.160.48
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="fFAjjh2a"
Received: by mail-oa1-f48.google.com with SMTP id 586e51a60fabf-30cceb382d1so1249885fac.2
        for <syzbot@lists.linux.dev>; Thu, 21 Aug 2025 14:36:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1755812178; x=1756416978; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=4OebRpH9271EURKFHHxpfj1NvnaVx76QHVEZhbFBVuk=;
        b=fFAjjh2a2U9EPREI9rviQ+2XAsJsJ/CnnpSAS+OQUTpaRgU2DANWDsYE+4xHsiBHhg
         iEA8GHjL04INCth2D0DOTQK9O4IWMunxHlwDtXsyH2j+w6YLD4dKhccBl3ffl2nqKCtI
         z8Dz4DOmxm+XlU4we6gTOaQazJMWcKFLxHFmiQ6VG+AtjNzITAb2YJe+/mh0EJdXo6jL
         +f9d/fpb8wkLf0qFUrDblodXREom/FSCPeY+74/1rY3O89QIh6f+W/WQRaYlNsf9SogY
         ToyX6rIEZmYolmQnPVREI/jwz2PiqbQpufO3SQD/Vi2hKI8GZNMApF6yHOZTxRUVD0oJ
         dCAA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1755812178; x=1756416978;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=4OebRpH9271EURKFHHxpfj1NvnaVx76QHVEZhbFBVuk=;
        b=NZGSLXf4IjtM0a7XbK6Ete/VWZ7KYMmoOs/GYGsvkt+ToCB3jl1hD0E17PIQRlVMmt
         IHgR6QUjuUSdvq85eTLl3Xw8ywV827+zmMLMDoma8a0h8p3uBxIqKfyKYlq7ShiHKI5M
         0j6kp4ZE2kVXN43Bnl3TjDaNEXr59vEtQ21XBBqNz+JMfsgUXW9v/fCJsr91ifNXo4A/
         wmfHVKhu00M5UgHyILp8W4GKe+mFVoor4RtPg7R2ddLz2P+1JKXZ2GbwVX83uFivDq6X
         XEo82wXeA6hyUN8YhE9FHj6PksJMr16FDSO98PuMmNQkiivc58sVP1X9DkcwVGjfYuSc
         POdQ==
X-Forwarded-Encrypted: i=1; AJvYcCXdXCF07HjVV7yJyi9zPRReRVv2Q0gzxT/A0cwFbxTN4m7FSiXv2oDwwOgWre2i852XUAbaew8=@lists.linux.dev
X-Gm-Message-State: AOJu0YxnItGvVt3m9XyvnpQxXXsOILsBlBXL9g+kdpFu+4BzTY+TU1Qp
	tr73//9X2iD4SiHUqMwIUesrJKH485RAqesLaHcSKewkuWwd6c3CUDED5KBmvfl6KSYp9i0Vr8d
	VEg2ez9Jp+zOPcxi+sPr6Rt/i4ZwRkzld4mxk7xnv
X-Gm-Gg: ASbGncukFT/7tkgbVBUe58qiqAcqkP/P8YlQIUj90E2LOftfY4LFCvU37SwdwggMM1z
	fcvK3FkOf7GUKMm3i3ibkCMTdei4UjnNibkIroWvMeF2pfhzkKp6zSaSHLzXiFLK8wnnkt97WdX
	N2pOo6bxZNUjbR5sRisx2UdS7w6J1g7vQr0NZnkQ+MjxbbRt2Rzdqeh/jYg4VNqhzDapcVQZP4a
	E5U1PRv2Sj0tlfZOOOaEsQPl8uGHBuVqb1o9EGSIL6KyLI=
X-Google-Smtp-Source: AGHT+IHCh0Y0lXc6i0hW98gGqNwv7n/tlkVnK2VLF90idCZyCbc9dpOvlwOOINWtkpaQW74ekcW1+mKqqRdG8+jv5Do=
X-Received: by 2002:a05:6870:80d3:b0:30b:be2b:3e18 with SMTP id
 586e51a60fabf-314dcc79381mr272681fac.11.1755812178355; Thu, 21 Aug 2025
 14:36:18 -0700 (PDT)
Precedence: bulk
X-Mailing-List: syzbot@lists.linux.dev
List-Id: <syzbot.lists.linux.dev>
List-Subscribe: <mailto:syzbot+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:syzbot+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <68a78f12.050a0220.13802c.0001.GAE@google.com>
In-Reply-To: <68a78f12.050a0220.13802c.0001.GAE@google.com>
From: Aleksandr Nogikh <nogikh@google.com>
Date: Thu, 21 Aug 2025 23:36:06 +0200
X-Gm-Features: Ac12FXwP4BanXx95iIAWLkVRJLCAKqfBME1W81VVS4veXUJp_MMxW7ZAO3uWEYc
Message-ID: <CANp29Y7r40irow4N6wkZa=Gyua8F2_icbatRQaoB=oXXerUKhQ@mail.gmail.com>
Subject: Re: [moderation/CI] Re: mm: remove nth_page()
To: syzbot ci <syzbot+ci9f7bbeba00c17e6c@syzkaller.appspotmail.com>
Cc: syzkaller-upstream-moderation@googlegroups.com, syzbot@lists.linux.dev
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

#syz upstream

On Thu, Aug 21, 2025 at 11:26=E2=80=AFPM syzbot ci
<syzbot+ci9f7bbeba00c17e6c@syzkaller.appspotmail.com> wrote:
>
> syzbot ci has tested the following series
>
> [v1] mm: remove nth_page()
> https://lore.kernel.org/all/20250821200701.1329277-1-david@redhat.com
> * [PATCH RFC 01/35] mm: stop making SPARSEMEM_VMEMMAP user-selectable
> * [PATCH RFC 02/35] arm64: Kconfig: drop superfluous "select SPARSEMEM_VM=
EMMAP"
> * [PATCH RFC 03/35] s390/Kconfig: drop superfluous "select SPARSEMEM_VMEM=
MAP"
> * [PATCH RFC 04/35] x86/Kconfig: drop superfluous "select SPARSEMEM_VMEMM=
AP"
> * [PATCH RFC 05/35] wireguard: selftests: remove CONFIG_SPARSEMEM_VMEMMAP=
=3Dy from qemu kernel config
> * [PATCH RFC 06/35] mm/page_alloc: reject unreasonable folio/compound pag=
e sizes in alloc_contig_range_noprof()
> * [PATCH RFC 07/35] mm/memremap: reject unreasonable folio/compound page =
sizes in memremap_pages()
> * [PATCH RFC 08/35] mm/hugetlb: check for unreasonable folio sizes when r=
egistering hstate
> * [PATCH RFC 09/35] mm/mm_init: make memmap_init_compound() look more lik=
e prep_compound_page()
> * [PATCH RFC 10/35] mm/hugetlb: cleanup hugetlb_folio_init_tail_vmemmap()
> * [PATCH RFC 11/35] mm: sanity-check maximum folio size in folio_set_orde=
r()
> * [PATCH RFC 12/35] mm: limit folio/compound page sizes in problematic ke=
rnel configs
> * [PATCH RFC 13/35] mm: simplify folio_page() and folio_page_idx()
> * [PATCH RFC 14/35] mm/mm/percpu-km: drop nth_page() usage within single =
allocation
> * [PATCH RFC 15/35] fs: hugetlbfs: remove nth_page() usage within folio i=
n adjust_range_hwpoison()
> * [PATCH RFC 16/35] mm/pagewalk: drop nth_page() usage within folio in fo=
lio_walk_start()
> * [PATCH RFC 17/35] mm/gup: drop nth_page() usage within folio when recor=
ding subpages
> * [PATCH RFC 18/35] io_uring/zcrx: remove "struct io_copy_cache" and one =
nth_page() usage
> * [PATCH RFC 19/35] io_uring/zcrx: remove nth_page() usage within folio
> * [PATCH RFC 20/35] mips: mm: convert __flush_dcache_pages() to __flush_d=
cache_folio_pages()
> * [PATCH RFC 21/35] mm/cma: refuse handing out non-contiguous page ranges
> * [PATCH RFC 22/35] dma-remap: drop nth_page() in dma_common_contiguous_r=
emap()
> * [PATCH RFC 23/35] scatterlist: disallow non-contigous page ranges in a =
single SG entry
> * [PATCH RFC 24/35] ata: libata-eh: drop nth_page() usage within SG entry
> * [PATCH RFC 25/35] drm/i915/gem: drop nth_page() usage within SG entry
> * [PATCH RFC 26/35] mspro_block: drop nth_page() usage within SG entry
> * [PATCH RFC 27/35] memstick: drop nth_page() usage within SG entry
> * [PATCH RFC 28/35] mmc: drop nth_page() usage within SG entry
> * [PATCH RFC 29/35] scsi: core: drop nth_page() usage within SG entry
> * [PATCH RFC 30/35] vfio/pci: drop nth_page() usage within SG entry
> * [PATCH RFC 31/35] crypto: remove nth_page() usage within SG entry
> * [PATCH RFC 32/35] mm/gup: drop nth_page() usage in unpin_user_page_rang=
e_dirty_lock()
> * [PATCH RFC 33/35] kfence: drop nth_page() usage
> * [PATCH RFC 34/35] block: update comment of "struct bio_vec" regarding n=
th_page()
> * [PATCH RFC 35/35] mm: remove nth_page()
>
> and found the following issue:
> general protection fault in kfence_guarded_alloc
>
> Full report is available here:
> https://ci.syzbot.org/series/f6f0aea1-9616-4675-8c80-f9b59ba3211c
>
> ***
>
> general protection fault in kfence_guarded_alloc
>
> tree:      net-next
> URL:       https://kernel.googlesource.com/pub/scm/linux/kernel/git/netde=
v/net-next.git
> base:      da114122b83149d1f1db0586b1d67947b651aa20
> arch:      amd64
> compiler:  Debian clang version 20.1.7 (++20250616065708+6146a88f6049-1~e=
xp1~20250616065826.132), Debian LLD 20.1.7
> config:    https://ci.syzbot.org/builds/705b7862-eb10-40bd-a4cf-4820b4912=
466/config
>
> smpboot: CPU0: Intel(R) Xeon(R) CPU @ 2.80GHz (family: 0x6, model: 0x55, =
stepping: 0x7)
> Oops: general protection fault, probably for non-canonical address 0xdfff=
fc0000000001: 0000 [#1] SMP KASAN NOPTI
> KASAN: null-ptr-deref in range [0x0000000000000008-0x000000000000000f]
> CPU: 0 UID: 0 PID: 1 Comm: swapper/0 Not tainted syzkaller #0 PREEMPT(ful=
l)
> Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS 1.16.2-debian-1.=
16.2-1 04/01/2014
> RIP: 0010:kfence_guarded_alloc+0x643/0xc70
> Code: 41 c1 e5 18 bf 00 00 00 f5 44 89 ee e8 a6 67 9c ff 45 31 f6 41 81 f=
d 00 00 00 f5 4c 0f 44 f3 49 8d 7e 08 48 89 f8 48 c1 e8 03 <42> 80 3c 20 00=
 74 05 e8 f1 cb ff ff 4c 8b 6c 24 18 4d 89 6e 08 49
> RSP: 0000:ffffc90000047740 EFLAGS: 00010202
> RAX: 0000000000000001 RBX: ffffea0004d90080 RCX: 0000000000000000
> RDX: ffff88801c2e8000 RSI: 00000000ff000000 RDI: 0000000000000008
> RBP: ffffc90000047850 R08: ffffffff99b2201b R09: 1ffffffff3364403
> R10: dffffc0000000000 R11: fffffbfff3364404 R12: dffffc0000000000
> R13: 00000000ff000000 R14: 0000000000000000 R15: ffff88813fec7068
> FS:  0000000000000000(0000) GS:ffff8880b861c000(0000) knlGS:0000000000000=
000
> CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> CR2: ffff88813ffff000 CR3: 000000000df36000 CR4: 0000000000350ef0
> Call Trace:
>  <TASK>
>  __kfence_alloc+0x385/0x3b0
>  __kmalloc_noprof+0x440/0x4f0
>  __alloc_workqueue+0x103/0x1b70
>  alloc_workqueue_noprof+0xd4/0x210
>  init_mm_internals+0x17/0x140
>  kernel_init_freeable+0x307/0x4b0
>  kernel_init+0x1d/0x1d0
>  ret_from_fork+0x3f9/0x770
>  ret_from_fork_asm+0x1a/0x30
>  </TASK>
> Modules linked in:
> ---[ end trace 0000000000000000 ]---
> RIP: 0010:kfence_guarded_alloc+0x643/0xc70
> Code: 41 c1 e5 18 bf 00 00 00 f5 44 89 ee e8 a6 67 9c ff 45 31 f6 41 81 f=
d 00 00 00 f5 4c 0f 44 f3 49 8d 7e 08 48 89 f8 48 c1 e8 03 <42> 80 3c 20 00=
 74 05 e8 f1 cb ff ff 4c 8b 6c 24 18 4d 89 6e 08 49
> RSP: 0000:ffffc90000047740 EFLAGS: 00010202
> RAX: 0000000000000001 RBX: ffffea0004d90080 RCX: 0000000000000000
> RDX: ffff88801c2e8000 RSI: 00000000ff000000 RDI: 0000000000000008
> RBP: ffffc90000047850 R08: ffffffff99b2201b R09: 1ffffffff3364403
> R10: dffffc0000000000 R11: fffffbfff3364404 R12: dffffc0000000000
> R13: 00000000ff000000 R14: 0000000000000000 R15: ffff88813fec7068
> FS:  0000000000000000(0000) GS:ffff8880b861c000(0000) knlGS:0000000000000=
000
> CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> CR2: ffff88813ffff000 CR3: 000000000df36000 CR4: 0000000000350ef0
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
> [agordeev@linux.ibm.com airlied@gmail.com akpm@linux-foundation.org alex.=
williamson@redhat.com alex@ghiti.fr andreas@gaisler.com aou@eecs.berkeley.e=
du axboe@kernel.dk borntraeger@linux.ibm.com bp@alien8.de brett.creeley@amd=
.com cassel@kernel.org catalin.marinas@arm.com chenhuacai@kernel.org christ=
ophe.leroy@csgroup.eu cl@gentwo.org dave.hansen@linux.intel.com davem@davem=
loft.net david@redhat.com dennis@kernel.org dgilbert@interlog.com dlemoal@k=
ernel.org dri-devel@lists.freedesktop.org dvyukov@google.com elver@google.c=
om glider@google.com gor@linux.ibm.com hannes@cmpxchg.org hca@linux.ibm.com=
 herbert@gondor.apana.org.au intel-gfx@lists.freedesktop.org io-uring@vger.=
kernel.org iommu@lists.linux.dev jackmanb@google.com james.bottomley@hansen=
partnership.com jani.nikula@linux.intel.com jason@zx2c4.com jesper.nilsson@=
axis.com jgg@nvidia.com jgg@ziepe.ca jhubbard@nvidia.com joonas.lahtinen@li=
nux.intel.com kasan-dev@googlegroups.com kernel@xen0n.name kevin.tian@intel=
.com kvm@vger.kernel.org lars.persson@axis.com liam.howlett@oracle.com linu=
x-arm-kernel@axis.com linux-arm-kernel@lists.infradead.org linux-crypto@vge=
r.kernel.org linux-ide@vger.kernel.org linux-kernel@vger.kernel.org linux-k=
selftest@vger.kernel.org linux-mips@vger.kernel.org linux-mm@kvack.org linu=
x-mmc@vger.kernel.org linux-riscv@lists.infradead.org linux-s390@vger.kerne=
l.org linux-scsi@vger.kernel.org lorenzo.stoakes@oracle.com m.szyprowski@sa=
msung.com maddy@linux.ibm.com martin.petersen@oracle.com maximlevitsky@gmai=
l.com mhocko@suse.com mingo@redhat.com mpe@ellerman.id.au muchun.song@linux=
.dev netdev@vger.kernel.org npiggin@gmail.com oakad@yahoo.com osalvador@sus=
e.de palmer@dabbelt.com paul.walmsley@sifive.com peterx@redhat.com robin.mu=
rphy@arm.com rodrigo.vivi@intel.com rppt@kernel.org shameerali.kolothum.tho=
di@huawei.com shuah@kernel.org simona@ffwll.ch surenb@google.com svens@linu=
x.ibm.com tglx@linutronix.de tj@kernel.org torvalds@linux-foundation.org ts=
bogend@alpha.franken.de tursulin@ursulin.net ulf.hansson@linaro.org vbabka@=
suse.cz virtualization@lists.linux.dev will@kernel.org wireguard@lists.zx2c=
4.com x86@kernel.org ziy@nvidia.com]
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
-upstream-moderation/68a78f12.050a0220.13802c.0001.GAE%40google.com.
