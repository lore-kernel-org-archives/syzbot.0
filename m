Received: from mail-oi1-f198.google.com (mail-oi1-f198.google.com [209.85.167.198])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 07AD82D12F3
	for <syzbot@lists.linux.dev>; Sat, 21 Mar 2026 19:58:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.167.198
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774123136; cv=none; b=DDhz85QPp0xIbGFOT/C/eZtcwnHX/iTUaP0OjXlfPGPPfxeW4robP2FjwtydNx13I3IbJSRgp/aWWpHGOyRAc2sYsWI2xZ0MXG4V39MMmUcY3bAiUJdSLYOyqRnjAJSXW+0p3Dd9iqbjn0e/XFGg7Vx9LFLyrSykWiTrGLwmkAA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774123136; c=relaxed/simple;
	bh=Qxb6gC0QmRll5QhUA22XZIZfUC9M8jZXmVPiR4HfcNM=;
	h=MIME-Version:Date:Message-ID:Subject:From:To:Cc:Content-Type; b=DFVEUWPW5Rc2a/xdkyERr5czaHGTcKrbMRYjQkoUzZvAVNU0oH5yzk33XwXtWrB1OEher6f9ZjQd8JGXswYroy04L8mKK8NvNIN45/r8Af85WGn0otjVK8uEdSJYpRiPeyqqk7Vmjfp7tl7O+rI7e7O5eJY28RL27+DC57FMR/I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com; arc=none smtp.client-ip=209.85.167.198
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com
Received: by mail-oi1-f198.google.com with SMTP id 5614622812f47-466fca9c6ebso23879487b6e.3
        for <syzbot@lists.linux.dev>; Sat, 21 Mar 2026 12:58:54 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1774123134; x=1774727934;
        h=content-transfer-encoding:cc:to:from:subject:message-id:date
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=id1cLgApjQGJKV8DrSirvy/LVSgCj5RG6UuZnLRC284=;
        b=kmBghahEbZZjeyqqH7HVv/1panbUQltG35Niu3gg6e5q9H7qhT+t72XGiWtu3sI7WQ
         s0kKmxdIIkeuRuUvpsVSXlN6FJJmQOB9Qmrq4kx9KkFJyr0MmsBccfVkpjmjziZ98gz5
         VFWLun3KCb4iWCgLf6oavcResRTFGEfYiXh0FCCsfZ82MtRg8YkBdHj0YsqfcWorXcGN
         +ZKiNmsqbsRGpiE6xl+Hol9m6iiNFwDKQkv5RhzK8Na6qtPBD5Iy1E9VR5i7g0Gce4Sg
         LRa6PRPkqFufrw8azTiXuUX/vRnxeQOVO2VC82A6hhTwXeYQwbqz2FJ6zFUA3FmznP71
         htNg==
X-Gm-Message-State: AOJu0YyQZXZhTeqcbEheggjiEsGh9IT5PIuF1mNK2N4jPtNvCsVoOyJA
	SNVSmEPDN49T+h+QQV0HUXrCfd9FAEudjAIXFY/stlNA1jAnYwmMdUl+APCHLQ0kQ9ZWkx0fBjp
	SpekoFRzcADuiOGB6HdKsPSDaYhugazRYTlP3fdP/JWHAA6FBGMWikxgWpK8=
Precedence: bulk
X-Mailing-List: syzbot@lists.linux.dev
List-Id: <syzbot.lists.linux.dev>
List-Subscribe: <mailto:syzbot+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:syzbot+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Received: by 2002:a05:6808:e881:20b0:467:deac:70fa with SMTP id
 5614622812f47-467e5d240a6mr3227477b6e.2.1774123133910; Sat, 21 Mar 2026
 12:58:53 -0700 (PDT)
Date: Sat, 21 Mar 2026 12:58:53 -0700
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <69bef87d.050a0220.3bf4de.005e.GAE@google.com>
Subject: [moderation/CI] Re: mm/huge_memory: refactor zap_huge_pmd()
From: syzbot ci <syzbot+ci224332cbd3a28fc6@syzkaller.appspotmail.com>
To: syzkaller-upstream-moderation@googlegroups.com
Cc: syzbot@lists.linux.dev
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

syzbot ci has tested the following series

[v3] mm/huge_memory: refactor zap_huge_pmd()
https://lore.kernel.org/all/cover.1774029655.git.ljs@kernel.org
* [PATCH v3 01/13] mm/huge_memory: simplify vma_is_specal_huge()
* [PATCH v3 02/13] mm/huge: avoid big else branch in zap_huge_pmd()
* [PATCH v3 03/13] mm/huge_memory: have zap_huge_pmd return a boolean, add =
kdoc
* [PATCH v3 04/13] mm/huge_memory: handle buggy PMD entry in zap_huge_pmd()
* [PATCH v3 05/13] mm/huge_memory: add a common exit path to zap_huge_pmd()
* [PATCH v3 06/13] mm/huge_memory: remove unnecessary VM_BUG_ON_PAGE()
* [PATCH v3 07/13] mm/huge_memory: deduplicate zap deposited table call
* [PATCH v3 08/13] mm/huge_memory: remove unnecessary sanity checks
* [PATCH v3 09/13] mm/huge_memory: use mm instead of tlb->mm
* [PATCH v3 10/13] mm/huge_memory: separate out the folio part of zap_huge_=
pmd()
* [PATCH v3 11/13] mm: add softleaf_is_valid_pmd_entry(), pmd_to_softleaf_f=
olio()
* [PATCH v3 12/13] mm/huge_memory: add and use normal_or_softleaf_folio_pmd=
()
* [PATCH v3 13/13] mm/huge_memory: add and use has_deposited_pgtable()

and found the following issue:
kernel build error

Full report is available here:
https://ci.syzbot.org/series/c3a7df63-9a98-4280-89d6-8095fc66d91b

***

kernel build error

tree:      torvalds
URL:       https://kernel.googlesource.com/pub/scm/linux/kernel/git/torvald=
s/linux
base:      a0c83177734ab98623795e1ba2cf4b72c23de5e7
arch:      amd64
compiler:  Debian clang version 21.1.8 (++20251221033036+2078da43e25a-1~exp=
1~20251221153213.50), Debian LLD 21.1.8
config:    https://ci.syzbot.org/builds/e9989b7c-5e25-414f-babe-85b146b1c0b=
a/config

mm/huge_memory.c:108:9: error: call to undeclared function 'vma_test_any'; =
ISO C99 and later do not support implicit function declarations [-Wimplicit=
-function-declaration]
mm/huge_memory.c:4615:6: error: call to undeclared function 'vma_test'; ISO=
 C99 and later do not support implicit function declarations [-Wimplicit-fu=
nction-declaration]

***

If these findings have caused you to resend the series or submit a
separate fix, please add the following tag to your commit message:
  Tested-by: syzbot@syzkaller.appspotmail.com

---
This report is generated by a bot. It may contain errors.
syzbot ci engineers can be reached at syzkaller@googlegroups.com.

The email will later be sent to:
[akpm@linux-foundation.org baohua@kernel.org baolin.wang@linux.alibaba.com =
david@kernel.org dev.jain@arm.com kas@kernel.org lance.yang@linux.dev liam.=
howlett@oracle.com linux-kernel@vger.kernel.org linux-mm@kvack.org ljs@kern=
el.org mhocko@suse.com npache@redhat.com rppt@kernel.org ryan.roberts@arm.c=
om surenb@google.com vbabka@kernel.org ziy@nvidia.com]

If the report looks fine to you, reply with:
#syz upstream

If the report is a false positive, reply with
#syz invalid

