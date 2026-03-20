Received: from mail-oi1-f200.google.com (mail-oi1-f200.google.com [209.85.167.200])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 14B7A3B2FD8
	for <syzbot@lists.linux.dev>; Fri, 20 Mar 2026 13:20:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.167.200
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774012835; cv=none; b=be3JnEM1pcUQGXEKoloTHG3T+HChO/j6Wl7NG1t2N8AlkiqMgXKtGeoSWbwuEESkA/BNYS2VTmp+luPjZBxoyhlTBS/InMjlZp7vDZ51ppjgMvsUaPwAX6xwjGmsO8QROCVh5Kif+6Wo2yZaDRSSnTqzytzLufP/BJWwYJzMD1Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774012835; c=relaxed/simple;
	bh=v2wT9KQYq9cz+qomMBWdqzlxSP3+nrghPBTB29nx1Ag=;
	h=MIME-Version:Date:Message-ID:Subject:From:To:Cc:Content-Type; b=skF2LuiMGbq9Uhi01x1rUTy9Sisa1huN7E5/G2ZH5rr2ohp/iTrbroscova0N8XxEdMWhB3jyupctA6zbPOWiPj0SQXoP1uLuKvbUq/9A5u5VlKidt8mW5z+1BGn4T1nr18Jc1L6t0xdJbP4h0bV2stM3iEJWiPgLHwZjuXNhFg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com; arc=none smtp.client-ip=209.85.167.200
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com
Received: by mail-oi1-f200.google.com with SMTP id 5614622812f47-467f7743d64so1052458b6e.2
        for <syzbot@lists.linux.dev>; Fri, 20 Mar 2026 06:20:32 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1774012832; x=1774617632;
        h=content-transfer-encoding:cc:to:from:subject:message-id:date
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=ENx0zWJUlMurY6Zrmx+cdyvTuD71/oqFHKTNUFC8UTI=;
        b=YGzgbSodVhxhEL11FqC+KbQZ/cNAc1A/rBvURwwd+CDa/V8q1LpAg0N3F1nt4A3UjM
         N7vQlgkDpSrm3AVHTblyRTadj1gUh3GUJDMK+6BR5lkiVk7NqVakVnyc2MxXTYRvfbtp
         Aa8olJSKaIKYKoda/4JY+kfLzDMXtY44FhpOHM70jac48S65m8rCw49isVroyryb1Rok
         6U/JIvGYpv7OOVPPWrxD04x/xc8zpUlLmk46Vz5D3fynOHxZy80OSR9V0fwuxl+TCBnd
         xK07o5cYI/UpKos7wn2Ay4wiuOx2snaPD5qCyYEhYlKAaxmTTfp0zcz4q7tVYjO2Efhi
         Dvvw==
X-Gm-Message-State: AOJu0YwsLL6sCN+ytk+AO5TlUUf41ncPqA7E27JIUDJAFf59GepRYV1A
	x8CEUiAUtFDymdGAL5pbvvD2F1oy4nc8XGXyxKQIEJKZzAU/trrJxiKkgJ3Uha5/sbWdotPZtQi
	bE6yU2IXYc6i3WFQrzLMSPIwod81HSEiD0mlkhZJfRemrD36rPTksaGDt1a8=
Precedence: bulk
X-Mailing-List: syzbot@lists.linux.dev
List-Id: <syzbot.lists.linux.dev>
List-Subscribe: <mailto:syzbot+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:syzbot+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Received: by 2002:a05:6808:181c:b0:45e:bfe0:21f2 with SMTP id
 5614622812f47-467e5d57d8emr1511857b6e.10.1774012831791; Fri, 20 Mar 2026
 06:20:31 -0700 (PDT)
Date: Fri, 20 Mar 2026 06:20:31 -0700
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <69bd499f.050a0220.3bf4de.0023.GAE@google.com>
Subject: [moderation/CI] Re: mm/huge_memory: refactor zap_huge_pmd()
From: syzbot ci <syzbot+cie486b10a0a53fc6c@syzkaller.appspotmail.com>
To: syzkaller-upstream-moderation@googlegroups.com
Cc: syzbot@lists.linux.dev
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

syzbot ci has tested the following series

[v2] mm/huge_memory: refactor zap_huge_pmd()
https://lore.kernel.org/all/cover.1773924928.git.ljs@kernel.org
* [PATCH v2 1/9] mm/huge_memory: simplify vma_is_specal_huge()
* [PATCH v2 2/9] mm/huge: avoid big else branch in zap_huge_pmd()
* [PATCH v2 3/9] mm/huge_memory: have zap_huge_pmd return a boolean, add kd=
oc
* [PATCH v2 4/9] mm/huge_memory: handle buggy PMD entry in zap_huge_pmd()
* [PATCH v2 5/9] mm/huge_memory: add a common exit path to zap_huge_pmd()
* [PATCH v2 6/9] mm/huge_memory: remove unnecessary VM_BUG_ON_PAGE()
* [PATCH v2 7/9] mm/huge_memory: deduplicate zap deposited table call
* [PATCH v2 8/9] mm/huge_memory: deduplicate zap_huge_pmd() further by trac=
king state
* [PATCH v2 9/9] mm/huge_memory: have zap_huge_pmd() use vm_normal_folio_pm=
d()

and found the following issue:
kernel build error

Full report is available here:
https://ci.syzbot.org/series/fc789267-30ea-4c5c-8e1f-623cee399460

***

kernel build error

tree:      mm-new
URL:       https://kernel.googlesource.com/pub/scm/linux/kernel/git/akpm/mm=
.git
base:      aa0a550d268b3075b67568d915b7093aabbb0772
arch:      amd64
compiler:  Debian clang version 21.1.8 (++20251221033036+2078da43e25a-1~exp=
1~20251221153213.50), Debian LLD 21.1.8
config:    https://ci.syzbot.org/builds/b61f81fb-cab5-4257-8eaf-4693791b0a7=
a/config

mm/huge_memory.c:108:9: error: call to undeclared function 'vma_test_any'; =
ISO C99 and later do not support implicit function declarations [-Wimplicit=
-function-declaration]
mm/huge_memory.c:4596:6: error: call to undeclared function 'vma_test'; ISO=
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
david@kernel.org dev.jain@arm.com lance.yang@linux.dev liam.howlett@oracle.=
com linux-kernel@vger.kernel.org linux-mm@kvack.org ljs@kernel.org mhocko@s=
use.com npache@redhat.com rppt@kernel.org ryan.roberts@arm.com surenb@googl=
e.com vbabka@kernel.org ziy@nvidia.com]

If the report looks fine to you, reply with:
#syz upstream

If the report is a false positive, reply with
#syz invalid

