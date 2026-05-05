Received: from mail-oa1-f72.google.com (mail-oa1-f72.google.com [209.85.160.72])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5F9EA48A2B1
	for <syzbot@lists.linux.dev>; Tue,  5 May 2026 21:14:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.160.72
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778015699; cv=none; b=Zsjns77rMj6EN0HAwkqzxfTKrdOdIT8IR7VjQLUnaRcaipZGUHx4SKMFAgm/Aj3N+RkcMksSOEgd/5qzkILhFoSrfRXnAix/JJPj0+WgNx19UgrYSTfclQTwhSNLS6nZP93N32eHijGEPZk9J7KQPb1x8I4OJhPrUnIMbTO1K7s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778015699; c=relaxed/simple;
	bh=CkaR9S4nTgFMgV7L00QBjzeUbzLOqnryP/JlJw3/mxg=;
	h=MIME-Version:Date:Message-ID:Subject:From:To:Cc:Content-Type; b=JrVQjEfJ3MBTBjxbwAIR9nJJwYgeQJlSe2cOR5ozSOQuoZFtHdF4n/p33zf0yPkGOnOWLfSv9wL8BzcA0Bvx7KpyTGQvlV7ONzfs4iI3RC8p42a6AgfMBGPUzkNhycYBfHhzLgyqztmpdf5DPPnl/2cK5EmcraT32xCYzdw4Vzs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com; arc=none smtp.client-ip=209.85.160.72
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com
Received: by mail-oa1-f72.google.com with SMTP id 586e51a60fabf-40ea48ccbd2so4469947fac.3
        for <syzbot@lists.linux.dev>; Tue, 05 May 2026 14:14:58 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1778015697; x=1778620497;
        h=content-transfer-encoding:cc:to:from:subject:message-id:date
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=St8cP/HhAKASWrR3UGaSIRrzUdsRyynOzisFj4yQn9k=;
        b=QxxmP3k6Huy6L9eIOHzpyOCAjNi6eCurDhlGvD/oNS0GBoif8VrQ3/dZVuUWwyoqxO
         mjqLPtV9eoPBgHo/VQZOGF933LC4TXZcGJvom5T59EINEU2/pqYsLLugODtbD3UH4sV3
         7HHy1rRvNCHOERL3Jb2FuC8Y7LP3mSaGuhc1HTsyrA8zEMVX+OeY01kilkA/cSEilbJP
         0lw3cD7Lzd6GzgwenGCH6e1ACWOFglEA201DRQ6IoJt64OnYJrVZAX61hrchwArMIRYY
         VKlP8m7fu2Vr+rxyVr6wZRiBmqxh+kkH4SYJy2tdnFreeANUwYy1gjGVyMU8/ApXCO6a
         8N/w==
X-Gm-Message-State: AOJu0YxNG52VoZi+7euAlHxgRgM5XmFUrVm6IYhSKMFx92qZGtumlWWU
	8+oKbLe4RceW6ZBGAOxoN0SeNzZO5feMmNAohEwb2mjFeAJN1UVG3yle6MgOd/dts31D61m3Z0B
	QBzpPjIYNbagqH/qzaMpNtjJtsL4Mk03B5l3MfCrCfJPUJ6sAOJEonCUjoO4=
Precedence: bulk
X-Mailing-List: syzbot@lists.linux.dev
List-Id: <syzbot.lists.linux.dev>
List-Subscribe: <mailto:syzbot+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:syzbot+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Received: by 2002:a05:6820:4cc4:b0:696:2674:8a1e with SMTP id
 006d021491bc7-69998d14887mr306105eaf.35.1778015697354; Tue, 05 May 2026
 14:14:57 -0700 (PDT)
Date: Tue, 05 May 2026 14:14:57 -0700
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <69fa5dd1.050a0220.e8b39.0007.GAE@google.com>
Subject: [moderation/CI] Re: pkeys-based page table hardening
From: syzbot ci <syzbot+ci2c6d6df1dbf2aff7@syzkaller.appspotmail.com>
To: syzkaller-upstream-moderation@googlegroups.com
Cc: syzbot@lists.linux.dev
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

syzbot ci has tested the following series

[v7] pkeys-based page table hardening
https://lore.kernel.org/all/20260505-kpkeys-v7-0-20c0bdd97197@arm.com
* [PATCH RFC v7 01/24] mm: Introduce kpkeys
* [PATCH RFC v7 02/24] set_memory: Introduce set_memory_pkey() stub
* [PATCH RFC v7 03/24] arm64: mm: Enable overlays for all EL1 indirect perm=
issions
* [PATCH RFC v7 04/24] arm64: Introduce por_elx_set_pkey_perms() helper
* [PATCH RFC v7 05/24] arm64: Implement asm/kpkeys.h using POE
* [PATCH RFC v7 06/24] arm64: set_memory: Implement set_memory_pkey()
* [PATCH RFC v7 07/24] arm64: Context-switch POR_EL1
* [PATCH RFC v7 08/24] arm64: Initialize POR_EL1 register on cpu_resume()
* [PATCH RFC v7 09/24] arm64: Enable kpkeys
* [PATCH RFC v7 10/24] memblock: Move INIT_MEMBLOCK_* macros to header
* [PATCH RFC v7 11/24] mm: kpkeys: Introduce kpkeys_hardened_pgtables featu=
re
* [PATCH RFC v7 12/24] mm: kpkeys: Protect regular page tables
* [PATCH RFC v7 13/24] mm: kpkeys: Introduce early page table allocator
* [PATCH RFC v7 14/24] mm: kpkeys: Protect vmemmap page tables
* [PATCH RFC v7 15/24] mm: kpkeys: Introduce hook for protecting static pag=
e tables
* [PATCH RFC v7 16/24] arm64: kpkeys: Implement arch_supports_kpkeys_early(=
)
* [PATCH RFC v7 17/24] arm64: kpkeys: Support KPKEYS_CTX_PGTABLES
* [PATCH RFC v7 18/24] arm64: kpkeys: Ensure the linear map can be modified
* [PATCH RFC v7 19/24] arm64: kpkeys: Protect early page tables
* [PATCH RFC v7 20/24] arm64: kpkeys: Protect init_pg_dir
* [PATCH RFC v7 21/24] arm64: kpkeys: Guard page table writes
* [PATCH RFC v7 22/24] arm64: kpkeys: Batch KPKEYS_CTX_PGTABLES switches
* [PATCH RFC v7 23/24] arm64: kpkeys: Enable kpkeys_hardened_pgtables suppo=
rt
* [PATCH RFC v7 24/24] mm: Add basic tests for kpkeys_hardened_pgtables

and found the following issue:
kernel build error

Full report is available here:
https://ci.syzbot.org/series/d1382384-550b-4bd0-9715-eced9c72e692

***

kernel build error

tree:      linux-next
URL:       https://kernel.googlesource.com/pub/scm/linux/kernel/git/next/li=
nux-next
base:      7fd2df204f342fc17d1a0bfcd474b24232fb0f32
arch:      amd64
compiler:  Debian clang version 21.1.8 (++20251221033036+2078da43e25a-1~exp=
1~20251221153213.50), Debian LLD 21.1.8
config:    https://ci.syzbot.org/builds/bbc99857-87e1-40e9-b472-24edca24e66=
3/config

mm/sparse-vmemmap.c:369:6: error: call to undeclared function 'vmemmap_allo=
c_block_zero'; ISO C99 and later do not support implicit function declarati=
ons [-Wimplicit-function-declaration]
mm/sparse-vmemmap.c:369:4: error: incompatible integer to pointer conversio=
n assigning to 'struct page *' from 'int' [-Wint-conversion]

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
[akpm@linux-foundation.org broonie@kernel.org catalin.marinas@arm.com dave.=
hansen@linux.intel.com david@kernel.org ira.weiny@intel.com jannh@google.co=
m jeffxu@chromium.org joey.gouly@arm.com kees@kernel.org kevin.brodsky@arm.=
com linusw@kernel.org linux-arm-kernel@lists.infradead.org linux-hardening@=
vger.kernel.org linux-mm@kvack.org ljs@kernel.org luto@kernel.org maz@kerne=
l.org mbland@motorola.com peterz@infradead.org pierre.langlois@arm.com qper=
ret@google.com rick.p.edgecombe@intel.com rppt@kernel.org ryan.roberts@arm.=
com tglx@kernel.org vbabka@kernel.org will@kernel.org willy@infradead.org x=
86@kernel.org yang@os.amperecomputing.com yeoreum.yun@arm.com]

If the report looks fine to you, reply with:
#syz upstream

If the report is a false positive, reply with
#syz invalid

