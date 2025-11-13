Received: from mail-il1-f199.google.com (mail-il1-f199.google.com [209.85.166.199])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6DF7A2FB63D
	for <syzbot@lists.linux.dev>; Thu, 13 Nov 2025 02:30:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.199
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763001031; cv=none; b=tIDhnTkAuYZQJahmWfJyj3yTPcm0W8HkR4HWDieWqiaBXHw9oQWdVsfIeRqckqbpp2NXAYN5lmICBdQyOH9o84cDjWfslA/f2kacuKfhVeMT/KSlTs37K0dzOlEwumsB0Qcg0dxVmOyntQEMgBIbNgIbE3XVX9L7MRZVkUUX7WA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763001031; c=relaxed/simple;
	bh=bfJiZ4qb6HdurRm6MBuYuOqk3e4YFIfk1ZBSRy8rLP0=;
	h=MIME-Version:Date:Message-ID:Subject:From:To:Cc:Content-Type; b=EvPU04NWqWRzY6lIQ/k7q/QbY6B9GHZs2N9DkJXOUDtQWDfoqug/Ur2byCL9R8KG/JImU4BIdj3CNA0JMuCBGbWKs2TZ6KHcUZ+8d9N4B0qnvSHvwwCK+l7bqxr7jP4EDtDOpeM6GoTCLBS6g11l5FvH3gwyt1oWTqnd0prjIu0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com; arc=none smtp.client-ip=209.85.166.199
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com
Received: by mail-il1-f199.google.com with SMTP id e9e14a558f8ab-43335646758so5470055ab.3
        for <syzbot@lists.linux.dev>; Wed, 12 Nov 2025 18:30:29 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1763001028; x=1763605828;
        h=content-transfer-encoding:cc:to:from:subject:message-id:date
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=Lv06dNs3S6Sz+Cyk17MvOoHyQ+U+2wVnTZsAD5l5I+w=;
        b=Uvhw9CyPjvzYWdtZalI/ztDfwdMXUH9rZ0TKZT8xNmgowUiIZ55aPt2YU4+Ax94YtG
         3J8oRWe8A9OUo5BSB0Z4BLEpXflkmI+yDhVsG+Z/g6kJB7ck6466Dy7xijZAil6NxxBh
         nrVMhVb+avJYvj6T/JbN84lX6d6A1bqnoHI+WtuswWsmIEkunDRj3mRFm88LFZnZONML
         LWKsjPum4z7HEQA/pYbdTpxRt7lKfh6yd7KN5utT6/Bz08KN/++epEII3vVuEbgYoXO7
         nbF3jUozX1iQjoojoEAdfbbMZAPs2kfKcmKPTDNQSj8QCGtPb2wbfRh8HrWib7p7hFBq
         rzvg==
X-Gm-Message-State: AOJu0YwmLSjC6WS7nI342tdutWlX3rgNOqbVpCn//neu8M2cyFaFdhUd
	fZeHi/812VQfXfuaF4K1Xb5okYEthQJfSE3eS7rC0fFttNLlJozNpyKOAEcpDHpfHFW/yGe5eaO
	0NSUrnIp9/+V4imk41xELPnRC2UJCpRgoC92UT/EiiSKuDtvLAAk0xYl9lXI=
X-Google-Smtp-Source: AGHT+IGYkVdXYpOza0p1TkwIDmO04CtKx+pEagm33TjWt3TmXY1NwLSo1+kJRXTvgm1thFsBTiDVgyBQhgaqqBlEhnjOfOkSUcmT
Precedence: bulk
X-Mailing-List: syzbot@lists.linux.dev
List-Id: <syzbot.lists.linux.dev>
List-Subscribe: <mailto:syzbot+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:syzbot+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Received: by 2002:a05:6e02:1fc1:b0:433:31b5:573a with SMTP id
 e9e14a558f8ab-43473dbc5f7mr67752755ab.18.1763001028559; Wed, 12 Nov 2025
 18:30:28 -0800 (PST)
Date: Wed, 12 Nov 2025 18:30:28 -0800
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <691542c4.a70a0220.3124cb.0012.GAE@google.com>
Subject: [moderation/CI] Re: riscv: Memory type control for platforms with
 physical memory aliases
From: syzbot ci <syzbot+ci10430a670a819e2c@syzkaller.appspotmail.com>
To: syzkaller-upstream-moderation@googlegroups.com
Cc: syzbot@lists.linux.dev
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

syzbot ci has tested the following series

[v3] riscv: Memory type control for platforms with physical memory aliases
https://lore.kernel.org/all/20251113014656.2605447-1-samuel.holland@sifive.=
com
* [PATCH v3 01/22] mm/ptdump: replace READ_ONCE() with standard page table =
accessors
* [PATCH v3 02/22] mm: replace READ_ONCE() with standard page table accesso=
rs
* [PATCH v3 03/22] mm/dirty: replace READ_ONCE() with pudp_get()
* [PATCH v3 04/22] perf/events: replace READ_ONCE() with standard page tabl=
e accessors
* [PATCH v3 05/22] mm: Move the fallback definitions of pXXp_get()
* [PATCH v3 06/22] mm: Always use page table accessor functions
* [PATCH v3 07/22] checkpatch: Warn on page table access without accessors
* [PATCH v3 08/22] mm: Allow page table accessors to be non-idempotent
* [PATCH v3 09/22] riscv: hibernate: Replace open-coded pXXp_get()
* [PATCH v3 10/22] riscv: mm: Always use page table accessor functions
* [PATCH v3 11/22] riscv: mm: Simplify set_p4d() and set_pgd()
* [PATCH v3 12/22] riscv: mm: Deduplicate _PAGE_CHG_MASK definition
* [PATCH v3 13/22] riscv: ptdump: Only show N and MT bits when enabled in t=
he kernel
* [PATCH v3 14/22] riscv: mm: Fix up memory types when writing page tables
* [PATCH v3 15/22] riscv: mm: Expose all page table bits to assembly code
* [PATCH v3 16/22] riscv: alternative: Add an ALTERNATIVE_3 macro
* [PATCH v3 17/22] riscv: alternative: Allow calls with alternate link regi=
sters
* [PATCH v3 18/22] riscv: Fix logic for selecting DMA_DIRECT_REMAP
* [PATCH v3 19/22] dt-bindings: riscv: Describe physical memory regions
* [PATCH v3 20/22] riscv: mm: Use physical memory aliases to apply PMAs
* [PATCH v3 21/22] riscv: dts: starfive: jh7100: Use physical memory ranges=
 for DMA
* [PATCH v3 22/22] riscv: dts: eswin: eic7700: Use physical memory ranges f=
or DMA

and found the following issue:
kernel build error

Full report is available here:
https://ci.syzbot.org/series/4de98f65-e317-44c6-a89f-e12318c634fd

***

kernel build error

tree:      torvalds
URL:       https://kernel.googlesource.com/pub/scm/linux/kernel/git/torvald=
s/linux
base:      24172e0d79900908cf5ebf366600616d29c9b417
arch:      amd64
compiler:  Debian clang version 20.1.8 (++20250708063551+0c9f909b7976-1~exp=
1~20250708183702.136), Debian LLD 20.1.8
config:    https://ci.syzbot.org/builds/89f41951-5456-4192-94ce-11b4c3b3f7e=
d/config

mm/pgtable-generic.c:27:2: error: cannot take the address of an rvalue of t=
ype 'pgd_t'
mm/pgtable-generic.c:34:2: error: cannot take the address of an rvalue of t=
ype 'p4d_t'
mm/pgtable-generic.c:42:2: error: cannot take the address of an rvalue of t=
ype 'pud_t'
mm/pgtable-generic.c:54:2: error: cannot take the address of an rvalue of t=
ype 'pmd_t'

***

If these findings have caused you to resend the series or submit a
separate fix, please add the following tag to your commit message:
  Tested-by: syzbot@syzkaller.appspotmail.com

---
This report is generated by a bot. It may contain errors.
syzbot ci engineers can be reached at syzkaller@googlegroups.com.

The email will later be sent to:
[acme@kernel.org ajones@ventanamicro.com akpm@linux-foundation.org alex@ghi=
ti.fr alexghiti@rivosinc.com anshuman.khandual@arm.com apw@canonical.com co=
nor@kernel.org david@redhat.com dev.jain@arm.com devicetree@vger.kernel.org=
 dwaipayanray1@gmail.com joe@perches.com julia.lawall@inria.fr kernel@esmil=
.dk krzk@kernel.org lance.yang@linux.dev liam.howlett@oracle.com linux-kern=
el@vger.kernel.org linux-mm@kvack.org linux-perf-users@vger.kernel.org linu=
x-riscv@lists.infradead.org lorenzo.stoakes@oracle.com lukas.bulwahn@gmail.=
com mhocko@suse.com mingo@redhat.com namhyung@kernel.org nicolas.palix@imag=
.fr osalvador@suse.de palmer@dabbelt.com peterz@infradead.org pjw@kernel.or=
g richard.weiyang@gmail.com robh@kernel.org rppt@kernel.org samuel.holland@=
sifive.com sj@kernel.org surenb@google.com vbabka@suse.cz]

If the report looks fine to you, reply with:
#syz upstream

