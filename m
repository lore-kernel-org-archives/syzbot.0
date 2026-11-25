Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.167.199
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795602213;
	b=nCr9KK+HyO1nRni7Ln6GsrjC/8bHVUsJgBknmEEWtBmlQtsyefFkGNq8s/+1qGh9HBUQ
	 AvVHmalz6AAHeR5LNLn0m6wLfOUG0qXyvy/Au1bZod903leEaHwIrKwyphs0om//NwS0t
	 i7MICvTkvbgezjQS1U2I1syOEsfMuYSXvpqj46waAQidoErGlgouq14Os3xgov2jWxYiw
	 fHNaBCMNf4rFSkFhrGYMQn9mTbmFaq+MT+yHi0AxmbwWmwVFzLaqKx4bDi1FT5ExGFwmC
	 mbi5zlMbfApQASa8xU0KuSs2JBqDR9D49PDbq7XFAyOw/5lDvmAoX9KM46kMFUWw/kg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795602213;
	h=DMARC-Filter:Received:X-Google-DKIM-Signature:X-Gm-Message-State:
	 MIME-Version:X-Received:Date:In-Reply-To:X-Google-Appengine-App-Id:
	 X-Google-Appengine-App-Id-Alias:Message-ID:Subject:From:To:Cc:
	 Content-Type;
	bh=nAwEpdk8W5zOz8dRUea8wq0PG12t8rrSsYABB8slUxU=;
	b=r6uAfkxnCM8niHtqLd/pvyJRn4RhJf9xWkuS+Yc2XgMwX+D0IOCKm4qCe4eBaqfFe0Mq
	 lKW/3Vx+YHrozkJiSKRMZgHFUat76drEaaZYnL8bJV5tJ7aXwoBdJblOLa2xrrTrv0Noi
	 6ZO18dkmJq6hXIrkh4Cdry8n4cRfWVn3YhRBjA1oqPrBQj92DPafPU6m/F2x8GItkZle/
	 5Tqvp1PDIUZBzb394SZD3ViiKIVcRGwxIN8DUEvLZxz1mweX4CXXHrfXwMYqdiymS20Nu
	 9/rUoHjQdmWHWaP0yrnZ439bGgGm/OoiLUm2natQGJ+V1JxTpFQ5Dm3Ri5syMwR0r9A==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=fail header.from=syzkaller.appspotmail.com;
	spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com;
	arc=none smtp.remote-ip=209.85.167.199
Received: from mail-oi1-f199.google.com (mail-oi1-f199.google.com [209.85.167.199])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7C91F606A327
	for <syzbot@lists.linux.dev>; Wed, 25 Nov 2026 10:23:32 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 7C91F606A327
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com
Received: by mail-oi1-f199.google.com with SMTP id 5614622812f47-5727b04b81eso3598001b6e.3
        for <syzbot@lists.linux.dev>; Wed, 25 Nov 2026 02:23:32 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1795602211; x=1796207011;
        h=content-type:cc:to:from:subject:message-id:in-reply-to:date
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to:content-type;
        bh=nAwEpdk8W5zOz8dRUea8wq0PG12t8rrSsYABB8slUxU=;
        b=2w6W7fr/9g26GEpSAXDWS0ii7wx16B37LXlgeBYU3RkOQE00flZnou/97C0gLU6KPA
         uAaXjmzoG575daBIjjdpCiOc6KUxjd1UD1xlvMROOQG5dZAg8VlWjZYRP4qAIfG7kgE/
         HevIC3enHN7hlqYcZbBMdbJDNZN0wc2glaGqzcBColwjjjetx+ZezxwYel0KOicDeCU/
         q7OZqf9mFo8UjVmI0mLlsb3KNUU2jKkqGfcyG7ob5XojR4RgPWuKBUKVSTMPI4MsSHNn
         9EFMHvCZWkqIbCpYR5i0CNF7ZJqMGv51JErgRzSBjKyDcQFYDPgKxungr/ajy++jqxag
         iCrw==
X-Gm-Message-State: APuU4Z+JVg/oSUAh/0HDFBLHlTpYbigHo417srGHlkZDTfoWtkXCnRwK
	qd5Uvv9Y4c8GKZUv3R5nFulmUHZ0h/1rRZp7RcXEheUt4r68l1EMivslJ1Kyr75MokYqQLTmHRq
	uGFTeFamXO8N/8jZ7cQdlCkOKVJ5TXkIJZlqkwtWODv7RZk4dVb5mzgDsobw=
X-Mailing-List: syzbot@lists.linux.dev
List-Id: <syzbot.lists.linux.dev>
List-Post: <mailto:syzbot@lists.linux.dev>
List-Help: <mailto:syzbot+help@lists.linux.dev>
List-Subscribe: <mailto:syzbot+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:syzbot+unsubscribe@lists.linux.dev>
List-Owner: <mailto:syzbot+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
X-Received: by 2002:a05:6808:c2be:b0:4d6:90f3:74b1 with SMTP id
 5614622812f47-57a0ba5a8e4mr18256405b6e.49.1795602211468; Wed, 25 Nov 2026
 02:23:31 -0800 (PST)
Date: Wed, 25 Nov 2026 02:23:31 -0800
In-Reply-To: <20261120010655.467825-1-lrizzo@google.com>
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <6b06b723.588a1920.b1e98.0003.GAE@google.com>
Subject: [syzbot ci] Re: PISA: Pre-mapped IOVA Superpage Allocator for DMA and CoCo
From: syzbot ci <syzbot+ci910cdb42d3006024@syzkaller.appspotmail.com>
To: akpm@linux-foundation.org, aleksander.lobakin@intel.com, axboe@kernel.dk, 
	brendan.jackman@linux.dev, catalin.marinas@arm.com, cl@gentwo.org, 
	corbet@lwn.net, dakr@kernel.org, davem@davemloft.net, david@kernel.org, 
	driver-core@lists.linux.dev, dtatulea@nvidia.com, edumazet@kernel.org, 
	gregkh@linuxfoundation.org, hannes@cmpxchg.org, hao.li@linux.dev, 
	harry@kernel.org, hawk@kernel.org, hch@lst.de, horms@kernel.org, 
	hramamurthy@google.com, ilias.apalodimas@linaro.org, iommu@lists.linux.dev, 
	jack@suse.cz, jannh@google.com, jgg@ziepe.ca, joro@8bytes.org, 
	joshwash@google.com, kuba@kernel.org, kuniyu@google.com, liam@infradead.org, 
	linux-api@vger.kernel.org, linux-arm-kernel@lists.infradead.org, 
	linux-block@vger.kernel.org, linux-doc@vger.kernel.org, 
	linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org, 
	linux-mm@kvack.org, ljs@kernel.org, lrizzo@google.com, 
	m.szyprowski@samsung.com, mhocko@suse.com, namangulati@google.com, 
	netdev@vger.kernel.org, pabeni@redhat.com, praan@google.com, 
	rafael@kernel.org, rdunlap@infradead.org, rientjes@google.com, 
	rizzo.unipi@gmail.com
Cc: syzbot@lists.linux.dev, syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"

syzbot ci has tested the following series

[v3] PISA: Pre-mapped IOVA Superpage Allocator for DMA and CoCo
https://lore.kernel.org/all/20261120010655.467825-1-lrizzo@google.com
* [RFC PATCH v3 01/25] mm: Introduce CONFIG_PISA and metadata table
* [RFC PATCH v3 02/25] mm: Add PISA allocator lifecycle and page recycle hook
* [RFC PATCH v3 03/25] mm: Add per-NUMA-node PISA page reservoir
* [RFC PATCH v3 04/25] mm/page_alloc: Extend alloc_pages() to __GFP_PISA and PISA block allocation
* [RFC PATCH v3 05/25] mm: Add global cap and shrinker for PISA pages
* [RFC PATCH v3 06/25] iommu/dma: Map PISA memory in a per-domain IOVA window
* [RFC PATCH v3 07/25] driver core: Add per-device pisa_* sysfs attributes for PISA optin
* [RFC PATCH v3 08/25] iommu/dma: Use PISA for coherent DMA allocations
* [RFC PATCH v3 09/25] mm: Add per-CPU block caches to PISA allocators
* [RFC PATCH v3 10/25] mm: Add background page scrubber for PISA allocators
* [RFC PATCH v3 11/25] mm: Migrate user pages into PISA
* [RFC PATCH v3 12/25] block, mm: Support PISA for disk I/O and scrub migration
* [RFC PATCH v3 13/25] net: Cache leaf PISA TX flags on struct net_device
* [RFC PATCH v3 14/25] net: Use per-node PISA allocators for skb_page_frag_refill()
* [RFC PATCH v3 15/25] net: Use PISA for page_pool memory
* [RFC PATCH v3 16/25] mm/slub: Add SLAB_CACHE_PISA_RO for PISA-backed slab caches
* [RFC PATCH v3 17/25] net: Allocate small skb heads from PISA
* [RFC PATCH v3 18/25] net: Migrate user pages into PISA for MSG_ZEROCOPY
* [RFC PATCH v3 19/25] mm, iommu/dma: Support decrypted PISA pages
* [RFC PATCH v3 20/25] arm64/mm, mm: Support decrypted PISA pages in Realms
* [RFC PATCH v3 21/25] mm: Add PISA statistics and debugfs
* [RFC PATCH v3 22/25] net/libeth: Use GFP_KERNEL when pre-filling RX rings
* [RFC PATCH v3 23/25] net/gve: Use GFP_KERNEL when pre-filling RX rings
* [RFC PATCH v3 24/25] net/gve: Use PISA memory for RX buffers
* [RFC PATCH v3 25/25] Documentation: Add PISA architecture documentation

and found the following issue:
WARNING in __alloc_workqueue

Full report is available here:
https://ci.syzbot.org/series/80fa818b-452d-4361-bfc6-33c65f928f71

***

WARNING in __alloc_workqueue

tree:      axboe
URL:       https://kernel.googlesource.com/pub/scm/linux/kernel/git/axboe/linux.git
base:      20eef29b7c8465ac98d7dd6d6f2ac07a8d8056ca
arch:      amd64
compiler:  Debian clang version 22.1.8 (1~deb13u4), Debian LLD 22.1.8
config:    https://ci.syzbot.org/builds/1b1679cb-3959-4df9-8546-bc04ba6e5cd3/config

smpboot: CPU0: Intel QEMU Virtual CPU version 2.5+ (family: 0xf, model: 0x6b, stepping: 0x1)
Performance Events: unsupported Netburst CPU model 107 no PMU driver, software events only.
signal: max sigframe size: 1440
rcu: Hierarchical SRCU implementation.
rcu: 	Max phase no-delay instances is 1000.
Timer migration: 1 hierarchy levels; 8 children per group; 0 crossnode level
NMI watchdog: Perf NMI watchdog permanently disabled
smp: Bringing up secondary CPUs ...
smpboot: x86: Booting SMP configuration:
.... node  #1, CPUs:      #1
smp: Brought up 2 nodes, 2 CPUs
smpboot: Total of 2 processors activated (11200.80 BogoMIPS)
Memory: 5553400K/7339508K available (181131K kernel code, 30788K rwdata, 59468K rodata, 27564K init, 120564K bss, 1621204K reserved, 0K cma-reserved)
devtmpfs: initialized
x86/mm: Memory block size: 128MB
Running RCU synchronous self tests
Running RCU synchronous self tests
Running RCU Tasks wait API self tests
Running RCU Tasks Trace wait API self tests
posixtimers hash table entries: 1024 (order: 5, 73728 bytes, vmalloc)
futex hash table entries: 256 (32768 bytes on 2 NUMA nodes, total 64 KiB, linear).
PM: RTC time: 20:32:46, date: 2026-11-24
NET: Registered PF_NETLINK/PF_ROUTE protocol family
audit: initializing netlink subsys (disabled)
thermal_sys: Registered thermal governor 'step_wise'
cpuidle: using governor menu
NET: Registered PF_QIPCRTR protocol family
dca service started, version 1.12.1
PCI: ECAM [mem 0xb0000000-0xbfffffff] (base 0xb0000000) for domain 0000 [bus 00-ff]
PCI: ECAM [mem 0xb0000000-0xbfffffff] reserved as E820 entry
PCI: Using configuration type 1 for base access
HugeTLB: registered 2.00 MiB page size, pre-allocated 0 pages
HugeTLB: 28 KiB vmemmap can be freed for a 2.00 MiB page
------------[ cut here ]------------
workqueue: pisa is using neither WQ_PERCPU or WQ_UNBOUND. Setting WQ_PERCPU.
WARNING: kernel/workqueue.c:6151 at __alloc_workqueue+0x1e4b/0x21d0, CPU#1: swapper/0/1
Modules linked in:
CPU: 1 UID: 0 PID: 1 Comm: swapper/0 Not tainted syzkaller #0 PREEMPT(full) 
Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS 1.16.2-debian-1.16.2-1 04/01/2014
RIP: 0010:__alloc_workqueue+0x1e4e/0x21d0
Code: 18 89 39 00 90 0f 0b 90 e9 87 fd ff ff e8 0a 89 39 00 90 0f 0b 90 e9 79 fd ff ff e8 fc 88 39 00 48 8d 3d 65 52 32 10 4c 89 f6 <67> 48 0f b9 3a 8b 5c 24 20 81 cb 00 01 00 00 e9 99 e4 ff ff e8 d9
RSP: 0000:ffffc90000067750 EFLAGS: 00010293
RAX: ffffffff818fa174 RBX: 0000000000000000 RCX: ffff888102aa5ac0
RDX: 0000000000000000 RSI: ffff888162ab5d78 RDI: ffffffff91c1f3e0
RBP: ffffc900000678a0 R08: ffff888102aa5ac0 R09: 0000000000000002
R10: 0000000000000102 R11: 0000000000000000 R12: dffffc0000000000
R13: ffff888162ab5c00 R14: ffff888162ab5d78 R15: ffff888162ab5d18
FS:  0000000000000000(0000) GS:ffff8882a77e4000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 0000000000000000 CR3: 000000000ff48000 CR4: 00000000000006f0
Call Trace:
 <TASK>
 alloc_workqueue_noprof+0xe3/0x210
 pisa_init+0x127/0x260
 do_one_initcall+0x250/0x870
 do_initcall_level+0x10a/0x1a0
 do_initcalls+0x59/0xa0
 kernel_init_freeable+0x29d/0x3e0
 kernel_init+0x22/0x1d0
 ret_from_fork+0x514/0xb70
 ret_from_fork_asm+0x1a/0x30
 </TASK>


***

If these findings have caused you to resend the series or submit a
separate fix, please add the following tag to your commit message:
  Tested-by: syzbot@syzkaller.appspotmail.com

---
This report is generated by a bot. It may contain errors.
syzbot ci engineers can be reached at syzkaller@googlegroups.com.
