Received: from mail-io1-f70.google.com (mail-io1-f70.google.com [209.85.166.70])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 187B81311AC
	for <syzbot@lists.linux.dev>; Wed, 24 Sep 2025 16:10:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.70
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758730225; cv=none; b=RK8ZnS7K+p3XAy4Z/EtMCN/n1g0vC1/qcjj8kzK3lgsyp7B+JYSZuAXKCZaLFsL76PS0XpbZSpAPEJd7LtaFs+jPG3/eV6SlExa1/SJ/lbqxMnxeU1L22eI3V6Kp2ZagJULlEwKeZBNxPpSD9kd2gbpeqwuX1OBandgPBWIDWwM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758730225; c=relaxed/simple;
	bh=/76XAI1gWCrWA+5MxxUe2RClHxa6g3zIwvaefU2L0oo=;
	h=MIME-Version:Date:Message-ID:Subject:From:To:Cc:Content-Type; b=bPuGVL0hiRgpU4VyJ2rVIoBFY9xu9bRUORVZgUaPV0n3CEqO6Mp54GjYC4WA3hAZ9ux/EcaYuAnY+D3ByO7z9g/ZOIEZrFD6JFZGRXYO9fM5svaNPnnI7+txcInmb2HNlBlr/snnbMgcjlsvRg9hLWAhQgjj2T7fqATnzE3OVc0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com; arc=none smtp.client-ip=209.85.166.70
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com
Received: by mail-io1-f70.google.com with SMTP id ca18e2360f4ac-88de776aab6so77569139f.0
        for <syzbot@lists.linux.dev>; Wed, 24 Sep 2025 09:10:23 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1758730223; x=1759335023;
        h=content-transfer-encoding:cc:to:from:subject:message-id:date
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=8edUGLE5X1GmucSzvDz+Q5Y/Vux46lDGWBOELvzaFto=;
        b=Koc3Yn9FbIBtoWP2PIYLj1FG6i9BRuV/+Yv3FOMwcpHiDiVGjDwpJEIFYHGy+XEGj1
         vXskT/THXL7yPXZIoijT61xCqesSCe8XWCdwKlC9J0jjFFkHLxXCLq+9csQdVzj6bv+H
         1XzTjKWHNAfp2MYTIHACJT7SNTbNvgnu8wn8RWcNuT17F6rEhpKGznZkYVY487zcLH0M
         ViPxJXlCKB2DVLGFxRarWWPA4kSJz7Vzkpk6k8+diIdXnT2Q36ogT7jLB2K1wik+Vf+H
         WeyUFIgxNxdWAmu8pLzQck7YQXmWsHT9KaMkn1cdiW+q0n16C4QXWUHEiKYTTkLpI8Gl
         /3lw==
X-Gm-Message-State: AOJu0YyRZkBxsseWGHwGUOwXeU8piHZmuF2/9Yq0+7ZgUf4J+9un95Uz
	ou28jastgOZrozat6PGq4eh5l+4q9ZYetGHhqHwh0b9h+SrYcrhoeD6///HvMdt4b939uHYaVyH
	jrQKf+N8IAHfF21r4vC2f1W0UBpDc0yvmgFy/y9GAt2WY8FsfFG96VSw7WRY=
X-Google-Smtp-Source: AGHT+IFvUDzZZrFMsW87hg2A8iJ9SHkAiNCJlyUhq4rzQM7hK2SwN0761Zm/wN6cjOr+565sl0KgQnb64GmMlK6orEyrdPll+cvs
Precedence: bulk
X-Mailing-List: syzbot@lists.linux.dev
List-Id: <syzbot.lists.linux.dev>
List-Subscribe: <mailto:syzbot+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:syzbot+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Received: by 2002:a05:6e02:2501:b0:424:7128:a06a with SMTP id
 e9e14a558f8ab-42595602a6amr2177265ab.7.1758730223197; Wed, 24 Sep 2025
 09:10:23 -0700 (PDT)
Date: Wed, 24 Sep 2025 09:10:23 -0700
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <68d417ef.a70a0220.1b52b.02cf.GAE@google.com>
Subject: [moderation/CI] Re: mm: ASI direct map management
From: syzbot ci <syzbot+ci20a368d4a653c2dd@syzkaller.appspotmail.com>
To: syzkaller-upstream-moderation@googlegroups.com
Cc: syzbot@lists.linux.dev
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

syzbot ci has tested the following series

[v1] mm: ASI direct map management
https://lore.kernel.org/all/20250924-b4-asi-page-alloc-v1-0-2d861768041f@go=
ogle.com
* [PATCH 01/21] x86/mm/asi: Add CONFIG_MITIGATION_ADDRESS_SPACE_ISOLATION
* [PATCH 02/21] x86/mm/asi: add X86_FEATURE_ASI and asi=3D
* [PATCH 03/21] x86/mm: factor out phys_pgd_init()
* [PATCH 04/21] x86/mm/asi: set up asi_nonsensitive_pgd
* [PATCH 05/21] x86/mm/pat: mirror direct map changes to ASI
* [PATCH 06/21] mm/page_alloc: add __GFP_SENSITIVE and always set it
* [PATCH 07/21] mm: introduce for_each_free_list()
* [PATCH 08/21] mm: rejig pageblock mask definitions
* [PATCH 09/21] mm/page_alloc: Invert is_check_pages_enabled() check
* [PATCH 10/21] mm/page_alloc: remove ifdefs from pindex helpers
* [PATCH 11/21] mm: introduce freetype_t
* [PATCH 12/21] mm/asi: encode sensitivity in freetypes and pageblocks
* [PATCH 13/21] mm/page_alloc_test: unit test pindex helpers
* [PATCH 14/21] x86/mm/pat: introduce cpa_fault option
* [PATCH 15/21] mm/page_alloc: rename ALLOC_NON_BLOCK back to _HARDER
* [PATCH 16/21] mm/page_alloc: introduce ALLOC_NOBLOCK
* [PATCH 17/21] mm/slub: defer application of gfp_allowed_mask
* [PATCH 18/21] mm/asi: support changing pageblock sensitivity
* [PATCH 19/21] mm/asi: bad_page() when ASI mappings are wrong
* [PATCH 20/21] x86/mm/asi: don't use global pages when ASI enabled
* [PATCH 21/21] mm: asi_test: smoke test for [non]sensitive page allocs

and found the following issue:
kernel build error

Full report is available here:
https://ci.syzbot.org/series/c5d6edfc-6999-4b8b-a338-e60860e51a28

***

kernel build error

tree:      linux-next
URL:       https://kernel.googlesource.com/pub/scm/linux/kernel/git/next/li=
nux-next
base:      ce7f1a983b074f6cf8609068088ca3182c569ee4
arch:      amd64
compiler:  Debian clang version 20.1.8 (++20250708063551+0c9f909b7976-1~exp=
1~20250708183702.136), Debian LLD 20.1.8
config:    https://ci.syzbot.org/builds/e0b7d7f4-8eca-4d2b-aa86-2950c847524=
b/config

mm/compaction.c:2319:7: error: use of undeclared identifier 'migratetype'; =
did you mean 'migrate_pfn'?

***

If these findings have caused you to resend the series or submit a
separate fix, please add the following tag to your commit message:
  Tested-by: syzbot@syzkaller.appspotmail.com

---
This report is generated by a bot. It may contain errors.
syzbot ci engineers can be reached at syzkaller@googlegroups.com.

The email will later be sent to:
[akpm@linux-foundation.org axelrasmussen@google.com bp@alien8.de dave.hanse=
n@linux.intel.com david@redhat.com derkling@google.com hannes@cmpxchg.org j=
ackmanb@google.com junaids@google.com liam.howlett@oracle.com linux-kernel@=
vger.kernel.org linux-mm@kvack.org lorenzo.stoakes@oracle.com luto@kernel.o=
rg mhocko@suse.com mingo@redhat.com peterz@infradead.org reijiw@google.com =
rientjes@google.com roman.gushchin@linux.dev rppt@kernel.org surenb@google.=
com tglx@linutronix.de vbabka@suse.cz x86@kernel.org yosry.ahmed@linux.dev =
yuanchu@google.com ziy@nvidia.com]

If the report looks fine to you, reply with:
#syz upstream

