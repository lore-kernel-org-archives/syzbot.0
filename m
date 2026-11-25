Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=209.85.160.178
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1795602174;
	b=MXhL9gyou6CmQFqVzx41kf7/cwCQCnkAw2bghBUmMeq9fzP4aRSFtFNIuEVsQ4pFQkZt
	 4aMOn8Xhr4DAAS3TwTK2cTZpd1Wf5x9jqlTVpU9yK4iTczqAHoYl0wDnJAvafx15Bq3M+
	 5JbOPB3A8MTIjVpHcLZNpK3J16gWo9fnprcKyoWc8jQrEVFBzqF8eD8mdXnujZb30TIyO
	 XvpWjSGjAhtxH5DL+fdZD62/ksF8iHOPlKK1DcgEIXj4sG7Cp4e3fOxA4ecJVjV2X6ApN
	 3v6cLgrkUOGqL5GpVcxdzPQaPenWwsB0x2ZdQ/XuTn7MnmyO8xNnczOcqctqslEKcyg==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795602174;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:
	 MIME-Version:References:In-Reply-To:From:Date:X-Gm-Features:
	 Message-ID:Subject:To:Cc:Content-Type:Content-Transfer-Encoding;
	bh=XMvVqYrxRGQbXXEa4fCKsXREgkFY087upi3oPfgGtvc=;
	b=nSqD40Y/5ytp7Zfv9M6AKHsH8sJ2IXxXjb24tcA299tX2eLq+PnOHLZtm+aNYQ9LsuIa
	 /qTyoUlfdnwwDOhQMjaX+tvxg64ihgVgIMivtiLhOto1wUrHXoCAMbnR+4TwAIVuQ/FX0
	 nQn/duqKDP3riBzwCOsv9J70+3CTmr+g92wrm1Jsx1ZxwzB6Tq/FTxW1yvc3KE3jSQzA6
	 dyzuTwTomWOl7EBY8sX1r07zaUSlROQupNhpJ0SsT7gio0hPr48uhiPp9JD3R+0VJWoSE
	 WuPx+hlVIodSljpe01+ry/M8GdKT+dIHgcmi/JZd2zRBCNwMk8VTAVyCVYFFPG5t6BA==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=google.com;
	spf=pass smtp.mailfrom=google.com;
	dkim=pass header.d=google.com header.i=@google.com header.a=rsa-sha256 header.s=20260707 header.b=OO5xvWyI;
	arc=pass header.oldest-pass=0 smtp.remote-ip=209.85.160.178
Received: from mail-qt1-f178.google.com (mail-qt1-f178.google.com [209.85.160.178])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9F4FD606A31E
	for <syzbot@lists.linux.dev>; Wed, 25 Nov 2026 10:22:53 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 9F4FD606A31E
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=google.com header.i=@google.com header.a=rsa-sha256 header.s=20260707 header.b=OO5xvWyI
Received: by mail-qt1-f178.google.com with SMTP id d75a77b69052e-55ade1de0b4so65780141cf.3
        for <syzbot@lists.linux.dev>; Wed, 25 Nov 2026 02:22:53 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1795602172; cv=none;
        d=google.com; s=arc-20260327;
        b=pAL0WFoLN50tOFH2psCXnJFhJNfWXd1JL5DMOXx8iyk1FZgfd5WCXi168LJrQ/RjP3
         tEc5xP2uHNfDT4OAdUiZNt2a7OZIvVJzi0GtvpSzUSNruH36ZglEEuLutgq9U1yiqIRa
         QuBwHrbhHl28hqhEMsaTRqP8+9HaOQSRFh5PJAQb3iWE/6uqDJJRyt1o3HeJrgvXujN+
         OCDGb1ovLmSsxu3EM/d3LjlXV93gR2lgSIKTufGzbCWqsFImytfkSAKtPpO2Ns6TvMSp
         gNHe7LrqQAutGO3cIwYkMDNvUb/Ptcc8GBgpWFkTcg3BQuBPwB309FqgiIFbmXTHNPHJ
         c7jA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=XMvVqYrxRGQbXXEa4fCKsXREgkFY087upi3oPfgGtvc=;
        fh=ZkIJ39J2hp1hGDTFPfPdgf08BCWA02W0CuqgGsqaOXI=;
        b=EUlIXorOuiGM32nhbCgtFrsGKsFiU5HjZyfiKIWPQmWrJhsUPZdOW4VFo7tQR/opgU
         VQ0ivoCj5GHh8yF45SFbUYLpFyN/NMQsju9bmRSUPvpG3pE7L8iJ5mZQ+L5QxJW0dFjL
         0uW0PM/scajtnG5lP+NazAtaVsDxJsOz4jaeALMf7MJPczRMfFTz6j1DKzDckytWTN3k
         S3H4UBxqI3Gs+buMlokBiqJ7KFn4cisq7mc+xRKT60R5ocniugn1VMJipz2YkG71uglo
         21IPiui/A/EQDxr+n/3UvA6x2ZlfR4aTtAXdGTnv0CKYvZwLt1jgLWq6pZeLuvnzaUgk
         40fQ==;
        darn=lists.linux.dev
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20260707; t=1795602172; x=1796206972; darn=lists.linux.dev;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=XMvVqYrxRGQbXXEa4fCKsXREgkFY087upi3oPfgGtvc=;
        b=OO5xvWyIdiBOLE9CBhb+p/Ea2L2F3VP9UdDV1MOdWVr42OhoDYuXHpUhAKrbUMnEn7
         Er9ppbGGGGiDKeXPTN3yMaUzhyE7NB32z21EHXi61yHKQsddoKcEtAK1QF0c8Evj2iCU
         68lmCBVu7o55Fj7AVpiQMKJbBfTUdvMZuu5etfANcwxuwvM7GCVUMb+6JKCvv1UwXoCL
         MxFBMlbJMeqEKwX2egOqv6FubTRO1EAdcCFSHl8JepEjszp5vkpacHu1WPkWqiEjSH40
         mOwO1/4WTTF0XhIUlDT1ZgMmMOfVaKSpEKX8WPw7DpScI/9ggTE6halo4z/tXpH+mrX2
         9xQA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1795602172; x=1796206972;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=XMvVqYrxRGQbXXEa4fCKsXREgkFY087upi3oPfgGtvc=;
        b=FyNVf9s6mTrb+1UTE4sIi644zAeLLQ/udvyZVFszEdF6bL5Y0+Ms1h0Y4+d38b3WMN
         XVWytIDfvklfCAT2T7jQQtAiQWuu5mejlR3GBgei3cuOoN4UESCOHGLrV6hNy+FOHrbo
         lnGhAok0eMuhIqzGqwInKQDGw3N6yTvxUJMjfg5OkzrGh8TO8cfsgTOJsetl2XhrbMKC
         Nf2COz0H9LiRym10mi9Zm2G3T2r3BZhmD8B44z/6rQYUuI9RFf3V9hYacL7fUqvJNtWF
         +Ury17zWMAdZnyFH+mi6nSAA9rLLuE4qhfdfkiJeE7FeitRDmWH4UmvMCsQcV7xgj9U+
         i1Cw==
X-Forwarded-Encrypted: i=1; AL+hErGGb3OkcqBoDKxWHHyOeAxLJjTrhDLk8H8vxy0OXvpPYqsfqqHInVyRZykUqcbp4/F6g34+Du0=@lists.linux.dev
X-Gm-Message-State: APuU4Z/t74wupJjeqXvfTOBjN2v9YwyRPcO2q/8yMRi32ABrJIRLKOd7
	eXi8/53tAA6vikZ5XP8agSp6iiNTXjjJn3KYtWfyI2y59mRVVNAeeYgAGa5sKaikwRvi+Y+JUIi
	HlZIwOkZ+vrM7w4APVp7GK5atA8vHlfsduL4Ezq3i
X-Gm-Gg: AZFdTZeByQKMkHtaB0QgZ7F3cu429N+NMKeUCNPKRFqe5I5IxePgXWfJiPf93VXBdu+
	XwL/el3B9uTdzLvX84OatU327Jflo1H2GCpZjQrrS9nlVf71d5WShylXNcu5OQfQOaypWQTdmMd
	Qwh4GoeHGDf+aRlzvngOWiWdd9uQDOze13XkSzaSPNl8dRMFjUOeC130/G/xXpBc78Rx0XlYHM9
	stj9Ponmrq1BUYEBA8NBeIY1kY69TINfD1widj0sEc/If3osB+QhYsp5qwWZYJkx+pKPmAMzMkk
	q91Y3wY151z3U4DyB3ay8Vd4JHzkVj6XBzqRjL2Cy0Y8DCWYedURQFSlsWW69XC/nP4lP0YuODH
	KKjMrbQG6isolqFOytzmqhM/oKUW82LMkG1NjyLFUedKvuec61RpGn5+rWUFFaS3JjIlPYjxIP5
	Fl2xQCPjHGV9vDQW7wftAYUFo=
X-Received: by 2002:a05:622a:40b:b0:537:af99:ad44 with SMTP id
 d75a77b69052e-55d76b00800mr336441941cf.57.1795602171782; Wed, 25 Nov 2026
 02:22:51 -0800 (PST)
X-Mailing-List: syzbot@lists.linux.dev
List-Id: <syzbot.lists.linux.dev>
List-Post: <mailto:syzbot@lists.linux.dev>
List-Help: <mailto:syzbot+help@lists.linux.dev>
List-Subscribe: <mailto:syzbot+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:syzbot+unsubscribe@lists.linux.dev>
List-Owner: <mailto:syzbot+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
References: <6b05f724.eee51036.26eb72.03d8.GAE@google.com>
In-Reply-To: <6b05f724.eee51036.26eb72.03d8.GAE@google.com>
From: Pimyn Girgis <pimyn@google.com>
Date: Wed, 25 Nov 2026 11:22:40 +0100
X-Gm-Features: Aa3M54ppJlAb5s3t--4tFZy_QOwXSqEPm6J2dFxvzAe3m6nRtnXF_OQ8NAbnp10
Message-ID: <CAJWNTGwG_a+vGnbxHbPi79zxwCVMydpbN-RkNHbooXOCoKoQZg@mail.gmail.com>
Subject: Re: [moderation/CI] Re: PISA: Pre-mapped IOVA Superpage Allocator for
 DMA and CoCo
To: syzbot ci <syzbot+cif40e4ba677709e68@syzkaller.appspotmail.com>
Cc: syzkaller-upstream-moderation@googlegroups.com, syzbot@lists.linux.dev
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

#syz upstream


On Tue, Nov 24, 2026 at 9:44=E2=80=AFPM syzbot ci
<syzbot+cif40e4ba677709e68@syzkaller.appspotmail.com> wrote:
>
> syzbot ci has tested the following series
>
> [v3] PISA: Pre-mapped IOVA Superpage Allocator for DMA and CoCo
> https://lore.kernel.org/all/20261120010655.467825-1-lrizzo@google.com
> * [RFC PATCH v3 01/25] mm: Introduce CONFIG_PISA and metadata table
> * [RFC PATCH v3 02/25] mm: Add PISA allocator lifecycle and page recycle =
hook
> * [RFC PATCH v3 03/25] mm: Add per-NUMA-node PISA page reservoir
> * [RFC PATCH v3 04/25] mm/page_alloc: Extend alloc_pages() to __GFP_PISA =
and PISA block allocation
> * [RFC PATCH v3 05/25] mm: Add global cap and shrinker for PISA pages
> * [RFC PATCH v3 06/25] iommu/dma: Map PISA memory in a per-domain IOVA wi=
ndow
> * [RFC PATCH v3 07/25] driver core: Add per-device pisa_* sysfs attribute=
s for PISA optin
> * [RFC PATCH v3 08/25] iommu/dma: Use PISA for coherent DMA allocations
> * [RFC PATCH v3 09/25] mm: Add per-CPU block caches to PISA allocators
> * [RFC PATCH v3 10/25] mm: Add background page scrubber for PISA allocato=
rs
> * [RFC PATCH v3 11/25] mm: Migrate user pages into PISA
> * [RFC PATCH v3 12/25] block, mm: Support PISA for disk I/O and scrub mig=
ration
> * [RFC PATCH v3 13/25] net: Cache leaf PISA TX flags on struct net_device
> * [RFC PATCH v3 14/25] net: Use per-node PISA allocators for skb_page_fra=
g_refill()
> * [RFC PATCH v3 15/25] net: Use PISA for page_pool memory
> * [RFC PATCH v3 16/25] mm/slub: Add SLAB_CACHE_PISA_RO for PISA-backed sl=
ab caches
> * [RFC PATCH v3 17/25] net: Allocate small skb heads from PISA
> * [RFC PATCH v3 18/25] net: Migrate user pages into PISA for MSG_ZEROCOPY
> * [RFC PATCH v3 19/25] mm, iommu/dma: Support decrypted PISA pages
> * [RFC PATCH v3 20/25] arm64/mm, mm: Support decrypted PISA pages in Real=
ms
> * [RFC PATCH v3 21/25] mm: Add PISA statistics and debugfs
> * [RFC PATCH v3 22/25] net/libeth: Use GFP_KERNEL when pre-filling RX rin=
gs
> * [RFC PATCH v3 23/25] net/gve: Use GFP_KERNEL when pre-filling RX rings
> * [RFC PATCH v3 24/25] net/gve: Use PISA memory for RX buffers
> * [RFC PATCH v3 25/25] Documentation: Add PISA architecture documentation
>
> and found the following issue:
> WARNING in __alloc_workqueue
>
> Full report is available here:
> https://ci.syzbot.org/series/80fa818b-452d-4361-bfc6-33c65f928f71
>
> ***
>
> WARNING in __alloc_workqueue
>
> tree:      axboe
> URL:       https://kernel.googlesource.com/pub/scm/linux/kernel/git/axboe=
/linux.git
> base:      20eef29b7c8465ac98d7dd6d6f2ac07a8d8056ca
> arch:      amd64
> compiler:  Debian clang version 22.1.8 (1~deb13u4), Debian LLD 22.1.8
> config:    https://ci.syzbot.org/builds/1b1679cb-3959-4df9-8546-bc04ba6e5=
cd3/config
>
> smpboot: CPU0: Intel QEMU Virtual CPU version 2.5+ (family: 0xf, model: 0=
x6b, stepping: 0x1)
> Performance Events: unsupported Netburst CPU model 107 no PMU driver, sof=
tware events only.
> signal: max sigframe size: 1440
> rcu: Hierarchical SRCU implementation.
> rcu:    Max phase no-delay instances is 1000.
> Timer migration: 1 hierarchy levels; 8 children per group; 0 crossnode le=
vel
> NMI watchdog: Perf NMI watchdog permanently disabled
> smp: Bringing up secondary CPUs ...
> smpboot: x86: Booting SMP configuration:
> .... node  #1, CPUs:      #1
> smp: Brought up 2 nodes, 2 CPUs
> smpboot: Total of 2 processors activated (11200.80 BogoMIPS)
> Memory: 5553400K/7339508K available (181131K kernel code, 30788K rwdata, =
59468K rodata, 27564K init, 120564K bss, 1621204K reserved, 0K cma-reserved=
)
> devtmpfs: initialized
> x86/mm: Memory block size: 128MB
> Running RCU synchronous self tests
> Running RCU synchronous self tests
> Running RCU Tasks wait API self tests
> Running RCU Tasks Trace wait API self tests
> posixtimers hash table entries: 1024 (order: 5, 73728 bytes, vmalloc)
> futex hash table entries: 256 (32768 bytes on 2 NUMA nodes, total 64 KiB,=
 linear).
> PM: RTC time: 20:32:46, date: 2026-11-24
> NET: Registered PF_NETLINK/PF_ROUTE protocol family
> audit: initializing netlink subsys (disabled)
> thermal_sys: Registered thermal governor 'step_wise'
> cpuidle: using governor menu
> NET: Registered PF_QIPCRTR protocol family
> dca service started, version 1.12.1
> PCI: ECAM [mem 0xb0000000-0xbfffffff] (base 0xb0000000) for domain 0000 [=
bus 00-ff]
> PCI: ECAM [mem 0xb0000000-0xbfffffff] reserved as E820 entry
> PCI: Using configuration type 1 for base access
> HugeTLB: registered 2.00 MiB page size, pre-allocated 0 pages
> HugeTLB: 28 KiB vmemmap can be freed for a 2.00 MiB page
> ------------[ cut here ]------------
> workqueue: pisa is using neither WQ_PERCPU or WQ_UNBOUND. Setting WQ_PERC=
PU.
> WARNING: kernel/workqueue.c:6151 at __alloc_workqueue+0x1e4b/0x21d0, CPU#=
1: swapper/0/1
> Modules linked in:
> CPU: 1 UID: 0 PID: 1 Comm: swapper/0 Not tainted syzkaller #0 PREEMPT(ful=
l)
> Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS 1.16.2-debian-1.=
16.2-1 04/01/2014
> RIP: 0010:__alloc_workqueue+0x1e4e/0x21d0
> Code: 18 89 39 00 90 0f 0b 90 e9 87 fd ff ff e8 0a 89 39 00 90 0f 0b 90 e=
9 79 fd ff ff e8 fc 88 39 00 48 8d 3d 65 52 32 10 4c 89 f6 <67> 48 0f b9 3a=
 8b 5c 24 20 81 cb 00 01 00 00 e9 99 e4 ff ff e8 d9
> RSP: 0000:ffffc90000067750 EFLAGS: 00010293
> RAX: ffffffff818fa174 RBX: 0000000000000000 RCX: ffff888102aa5ac0
> RDX: 0000000000000000 RSI: ffff888162ab5d78 RDI: ffffffff91c1f3e0
> RBP: ffffc900000678a0 R08: ffff888102aa5ac0 R09: 0000000000000002
> R10: 0000000000000102 R11: 0000000000000000 R12: dffffc0000000000
> R13: ffff888162ab5c00 R14: ffff888162ab5d78 R15: ffff888162ab5d18
> FS:  0000000000000000(0000) GS:ffff8882a77e4000(0000) knlGS:0000000000000=
000
> CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> CR2: 0000000000000000 CR3: 000000000ff48000 CR4: 00000000000006f0
> Call Trace:
>  <TASK>
>  alloc_workqueue_noprof+0xe3/0x210
>  pisa_init+0x127/0x260
>  do_one_initcall+0x250/0x870
>  do_initcall_level+0x10a/0x1a0
>  do_initcalls+0x59/0xa0
>  kernel_init_freeable+0x29d/0x3e0
>  kernel_init+0x22/0x1d0
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
> The email will later be sent to:
> [akpm@linux-foundation.org aleksander.lobakin@intel.com axboe@kernel.dk b=
rendan.jackman@linux.dev catalin.marinas@arm.com cl@gentwo.org corbet@lwn.n=
et dakr@kernel.org davem@davemloft.net david@kernel.org driver-core@lists.l=
inux.dev dtatulea@nvidia.com edumazet@kernel.org gregkh@linuxfoundation.org=
 hannes@cmpxchg.org hao.li@linux.dev harry@kernel.org hawk@kernel.org hch@l=
st.de horms@kernel.org hramamurthy@google.com ilias.apalodimas@linaro.org i=
ommu@lists.linux.dev jack@suse.cz jannh@google.com jgg@ziepe.ca joro@8bytes=
.org joshwash@google.com kuba@kernel.org kuniyu@google.com liam@infradead.o=
rg linux-api@vger.kernel.org linux-arm-kernel@lists.infradead.org linux-blo=
ck@vger.kernel.org linux-doc@vger.kernel.org linux-fsdevel@vger.kernel.org =
linux-kernel@vger.kernel.org linux-mm@kvack.org ljs@kernel.org lrizzo@googl=
e.com m.szyprowski@samsung.com mhocko@suse.com namangulati@google.com netde=
v@vger.kernel.org pabeni@redhat.com praan@google.com rafael@kernel.org rdun=
lap@infradead.org rientjes@google.com rizzo.unipi@gmail.com]
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
-upstream-moderation/6b05f724.eee51036.26eb72.03d8.GAE%40google.com.



--=20
=E2=B2=A0=E2=B2=9F=E2=B2=93=E2=B2=99=E2=B2=8F=E2=B2=9B =E2=B2=84=E2=B2=89=
=E2=B2=B1=E2=B2=A3=E2=B2=85=E2=B2=93=E2=B2=9F=E2=B2=A5 - Pimyn Girgis
Software Engineer
Kernel Dynamic Analysis
pimyn@google.com
