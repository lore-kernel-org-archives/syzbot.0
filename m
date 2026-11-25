Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.210.72
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795641606;
	b=1kMnSGF1h3742Najeyhmf0uH0rVPP+dDY4h38ugsXH9rth7F+GfxWh2Yv6LoKcyXoVCn
	 mvdUZE4ZsZO16svrPR+q1MoZSYjF3MRLDV3d5hz5DPCYsEgdEHsmzSENBmmG2tPWjlRhz
	 KPsIiLKDxIlydHlYFHz1Q+JqRO5tUb+BVizIz41fu/0NsxY8xNYVhRxqoBxbJG9cwO4+W
	 J+TQqw/66KfCoSSSO3bRMwjdMJeoF7HrHSuaHFU9N6t9xandTZwej4Z7RoG6o9ij9ZExR
	 +BBqhpwve3bNAarTzKBeS0ZZvAxPgZRFTa4fdvSYiEvKP6eUf+5KUHn6BYpKfWKA0Ng==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795641606;
	h=DMARC-Filter:Received:X-Google-DKIM-Signature:X-Gm-Message-State:
	 MIME-Version:X-Received:Date:X-Google-Appengine-App-Id:
	 X-Google-Appengine-App-Id-Alias:Message-ID:Subject:From:To:Cc:
	 Content-Type:Content-Transfer-Encoding;
	bh=GEEvGjM5cnwmYErVfk37NzmOrPiD82zwE6d5P6M7Ny0=;
	b=MVrUWHyV4NH5jYCn42YwcvTdCZ6IZfl40wEjShH3c5d7+Yp9JfcDhVMLVLxNPokRpjNb
	 KWyrMf3ulOyREIj3qy4efVLrGvKwHbHDpXk1qjJR7qpi4ubUpwbHQt+It4CXyJ8U0xYrn
	 uz/E8ctw75c+tfapVMunk6z1KaEmlFV9DYMUBVvPzL2yCn7rAw/lrCUweXoM7oc1eKjp8
	 D58iebL2VlC4ojDpHQOPi54/6+q0OVTZbQGhqzXW+SkPckt49IYfuwScnnlcsjXRtnVX7
	 BQUgONE+mPeI6dYE+8FSjIKKVDqeWg2ehd/hn8TWKc7jSHfkuf1p25E4rWvHg7HZuGQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=fail header.from=syzkaller.appspotmail.com;
	spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com;
	arc=none smtp.remote-ip=209.85.210.72
Received: from mail-ot1-f72.google.com (mail-ot1-f72.google.com [209.85.210.72])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7E994606A31E
	for <syzbot@lists.linux.dev>; Wed, 25 Nov 2026 21:20:06 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 7E994606A31E
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com
Received: by mail-ot1-f72.google.com with SMTP id 46e09a7af769-86155a5b1c6so6583111a34.1
        for <syzbot@lists.linux.dev>; Wed, 25 Nov 2026 13:20:06 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1795641605; x=1796246405;
        h=content-transfer-encoding:content-type:cc:to:from:subject
         :message-id:date:mime-version:x-gm-message-state:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=GEEvGjM5cnwmYErVfk37NzmOrPiD82zwE6d5P6M7Ny0=;
        b=HLelrGf5wV6OD/8ILmR0hNC8EQb0VPYTEeP9FhYKZt3+en/VZ7eDQ8wNBmxumJeBNr
         WGDHGaFCXU+G+CTtBh78gIberz6Dk+wHkpA4RIdW1b6THEeGFvgGe0InLQbn8dbDaVmZ
         qiCGr5c0iilQstb8QPKkiYvIdH5MNwKfCxYfj6cKcZ05oZ+pllWyR9ZrY2YTkatGTVtB
         k3s+MlzZXLzRmprrGuqiY8TK6VNYgCyrcgZe8DxjMcuRnxDFgR+hPXB0YLSX1oRNXE6J
         8TEo5NhEBIR7BIPjeokoABCHwbqj6mhTYtvUM3yC79UeE49GkWgX3VdcyAwCeVXfnSyD
         7W6A==
X-Gm-Message-State: APuU4Z9nHBCX2i6jjsAYhvTUtcZCH8HCKceWrqiRGbOn6qlll6KbxxKC
	MWcQDTYahu+eo7zOA1/ypV8OwO37QEBSlrTaJ9+ycd+XaWZKTcYkBYgznswH+vl56yOmI9skeeq
	sAMkTJfGPIZOJNG3MsWX6WTInNFeHCVOVBE9WnlLc58zX3ze0mlQZVzv5PYQ=
X-Mailing-List: syzbot@lists.linux.dev
List-Id: <syzbot.lists.linux.dev>
List-Post: <mailto:syzbot@lists.linux.dev>
List-Help: <mailto:syzbot+help@lists.linux.dev>
List-Subscribe: <mailto:syzbot+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:syzbot+unsubscribe@lists.linux.dev>
List-Owner: <mailto:syzbot+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
X-Received: by 2002:a05:6808:220b:b0:495:f8a5:8797 with SMTP id
 5614622812f47-57975c50e20mr16905017b6e.0.1795641605511; Wed, 25 Nov 2026
 13:20:05 -0800 (PST)
Date: Wed, 25 Nov 2026 13:20:05 -0800
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <6b075105.bb6e6ada.e0302.000f.GAE@google.com>
Subject: [moderation/CI] Re: Private NUMA nodes
From: syzbot ci <syzbot+cib941368d87de96b1@syzkaller.appspotmail.com>
To: syzkaller-upstream-moderation@googlegroups.com
Cc: syzbot@lists.linux.dev
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

syzbot ci has tested the following series

[v1] Private NUMA nodes
https://lore.kernel.org/all/20261120-private_nodes_v6-v1-0-74f5f9a115c2@gou=
rry.net
* [PATCH 01/60] nodemask: add node-state iterators
* [PATCH 02/60] mm: publish and clear node memory states via helpers
* [PATCH 03/60] mm: introduce the common-memory node state
* [PATCH 04/60] mm/page_alloc: build zonelists from common memory
* [PATCH 05/60] mm/mempolicy: keep interleave and tmpfs mount policies on c=
ommon memory
* [PATCH 06/60] mm/memory_hotplug: migrate offlined pages to common memory
* [PATCH 07/60] mm/memory-tiers: restrict demotion topology to common memor=
y
* [PATCH 08/60] mm/migrate: reject move_pages() destinations outside common=
 memory
* [PATCH 09/60] mm/damon: reject migration destinations outside common memo=
ry
* [PATCH 10/60] sched/numa: restrict NUMA migration targets to common memor=
y
* [PATCH 11/60] fork: check cached stack locality only on common memory nod=
es
* [PATCH 12/60] mm/vmscan: restrict reclaim to common memory
* [PATCH 13/60] mm/compaction: restrict compaction to common memory
* [PATCH 14/60] mm: base hash distribution on common memory nodes
* [PATCH 15/60] mm/page_alloc: count common memory nodes for kswapd recover=
y
* [PATCH 16/60] mm/oom_kill: compare OOM constraints against common memory
* [PATCH 17/60] PM: hibernate: size the image from common memory
* [PATCH 18/60] mm/khugepaged: base the recommended min_free_kbytes on comm=
on memory
* [PATCH 19/60] mm: add folio_is_common_memory() and page_is_common_memory(=
)
* [PATCH 20/60] mm/ksm: restrict merging to common memory
* [PATCH 21/60] mm/khugepaged: restrict collapse to common memory
* [PATCH 22/60] mm/mempolicy: don't NUMA-hint folios outside common memory
* [PATCH 23/60] mm/damon: restrict DAMON-native folio operations to common =
memory
* [PATCH 24/60] mm/madvise: restrict reclaim advice to common memory
* [PATCH 25/60] mm/mempolicy: queue only common memory for mbind() and migr=
ate_pages()
* [PATCH 26/60] mm/migrate: leave pages outside common memory in move_pages=
()
* [PATCH 27/60] mm: add the private-memory node state
* [PATCH 28/60] mm: select memory features per node
* [PATCH 29/60] mm: keep private memory out of the system memory totals
* [PATCH 30/60] mm/memory_hotplug: keep private memory out of the auto-mova=
ble ratio
* [PATCH 31/60] cgroup/cpuset: inherit common memory when a nodemask is pri=
vate only
* [PATCH 32/60] cgroup/cpuset: keep spread page cache off private nodes
* [PATCH 33/60] cgroup/cpuset: ignore private nodes when matching OOM victi=
ms
* [PATCH 34/60] mm/mempolicy: don't rebind policies onto private nodes
* [PATCH 35/60] mm/mempolicy: keep private nodes out of migrate_pages() des=
tinations
* [PATCH 36/60] mm: refuse explicit reclaim and compaction of private nodes
* [PATCH 37/60] mm/page_alloc: keep private memory out of reclaim reserves
* [PATCH 38/60] mm/page_alloc: refuse contiguous allocation from private me=
mory
* [PATCH 39/60] mm/page_alloc: add a private-node zonelist
* [PATCH 40/60] mm/page_alloc: let MM callers select the local private zone=
list
* [PATCH 41/60] mm/page_alloc: relax a private request whose node becomes i=
neligible
* [PATCH 42/60] mm: fail private placement on exhaustion instead of OOM kil=
ling
* [PATCH 43/60] mm/page_alloc: fall back when a bind policy's nodes become =
private
* [PATCH 44/60] mm: add N_MEMORY_COMPACTION node state
* [PATCH 45/60] mm/compaction: restrict compaction to N_MEMORY_COMPACTION
* [PATCH 46/60] mm: add N_MEMORY_RECLAIM node state
* [PATCH 47/60] mm/vmscan: restrict reclaim to N_MEMORY_RECLAIM instead of =
N_MEMORY_COMMON
* [PATCH 48/60] mm/madvise: restrict reclaim advice to reclaim-capable memo=
ry
* [PATCH 49/60] mm/vmscan: reclaim private nodes for memcg
* [PATCH 50/60] mm: add N_MEMORY_MEMPOLICY node state
* [PATCH 51/60] mm: restrict explicit migration to N_MEMORY_MEMPOLICY
* [PATCH 52/60] mm: count memory with userspace placement as general purpos=
e
* [PATCH 53/60] mm/mempolicy: add MPOL_F_PRIVATE_NODES for private node bin=
dings
* [PATCH 54/60] mm/migrate: route explicit NUMA migration to private nodes
* [PATCH 55/60] mm/memory_hotplug: online and offline private memory nodes
* [PATCH 56/60] dax/kmem: add a private memory mode
* [PATCH 57/60] selftests/dax: test private kmem devices and services
* [PATCH 58/60] selftests/dax: test memory policy on private nodes
* [PATCH 59/60] selftests/dax: test cpuset interaction with private nodes
* [PATCH 60/60] Documentation/mm: describe private memory nodes

and found the following issue:
kernel build error

Full report is available here:
https://ci.syzbot.org/series/1388b9c5-543a-42d8-80be-9bbfeb13abcc

***

kernel build error

tree:      mm-new
URL:       https://kernel.googlesource.com/pub/scm/linux/kernel/git/akpm/mm=
.git
base:      a036649714c3446abfdc36d0ae483046432b16c5
arch:      amd64
compiler:  Debian clang version 22.1.8 (1~deb13u4), Debian LLD 22.1.8
config:    https://ci.syzbot.org/builds/e3d590b2-b93d-4b46-9431-3b8ae720ebb=
1/config

mm/migrate.c:2252:10: error: call to undeclared function '__folio_alloc_fla=
gs'; ISO C99 and later do not support implicit function declarations [-Wimp=
licit-function-declaration]
mm/migrate.c:2252:10: error: incompatible integer to pointer conversion ret=
urning 'int' from a function with result type 'struct folio *' [-Wint-conve=
rsion]

***

If these findings have caused you to resend the series or submit a
separate fix, please add the following tag to your commit message:
  Tested-by: syzbot@syzkaller.appspotmail.com

---
This report is generated by a bot. It may contain errors.
syzbot ci engineers can be reached at syzkaller@googlegroups.com.

The email will later be sent to:
[akpm@linux-foundation.org alison.schofield@intel.com apopple@nvidia.com ax=
elrasmussen@google.com baohua@kernel.org baolin.wang@linux.alibaba.com baoq=
uan.he@linux.dev brendan.jackman@linux.dev bsegall@google.com byungchul@sk.=
com cgroups@vger.kernel.org chengming.zhou@linux.dev chrisl@kernel.org corb=
et@lwn.net dakr@kernel.org damon@lists.linux.dev dave.jiang@intel.com david=
@kernel.org dev.jain@arm.com devnull@kernel.org dietmar.eggemann@arm.com dj=
bw@kernel.org driver-core@lists.linux.dev gourry@gourry.net gregkh@linuxfou=
ndation.org hannes@cmpxchg.org jack@suse.cz jannh@google.com johan@kernel.o=
rg joshua.hahnjy@gmail.com juri.lelli@redhat.com kas@kernel.org kasong@tenc=
ent.com kees@kernel.org kprateek.nayak@amd.com lance.yang@linux.dev lenb@ke=
rnel.org liam@infradead.org linux-cxl@vger.kernel.org linux-doc@vger.kernel=
.org linux-fsdevel@vger.kernel.org linux-kernel@vger.kernel.org linux-kself=
test@vger.kernel.org linux-mm@kvack.org linux-pm@vger.kernel.org linux@rasm=
usvillemoes.dk ljs@kernel.org longman@redhat.com matthew.brost@intel.com mg=
orman@suse.de]

If the report looks fine to you, reply with:
#syz upstream

If the report is a false positive, reply with
#syz invalid

