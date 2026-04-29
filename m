Received: from mail-oa1-f69.google.com (mail-oa1-f69.google.com [209.85.160.69])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AED2C3C07A
	for <syzbot@lists.linux.dev>; Wed, 29 Apr 2026 21:45:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.160.69
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777499125; cv=none; b=mCI1JGE05jX6/ZKRE6CqxABzCfMSBKCNfmlHvUyBjQXWCxVTrU6LhBjs90Vf/CKVP1iOLSioFrpD+O2LF5zf5Fd2kwgDgNx7/LHMg1zp1DSZnjsqrC+dcio51AmqB/5zQq/t4JA2qg1XAoT7VLzD0jiNkdthwkf/tbxVPd9uHC0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777499125; c=relaxed/simple;
	bh=59zPyxL0lJf1hAvb2aBUAh0qnkS8Wo8YjVdJ722HJ8c=;
	h=MIME-Version:Date:Message-ID:Subject:From:To:Cc:Content-Type; b=XHztPu0vBFwMWPatS6w08We+9LnFJO7q3lc218LjU08XJNHPdCuxjbgLeOXwAxtz1dQc6EL35UihBLZmGbj4c0h44IUw1EhWXYHpz2zVpanaFnT/rdPyh69OAfLxer5KrUlJeFSvSxF9N79rlw+H+C+bEmgaMn+H3s7oldG4CWs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com; arc=none smtp.client-ip=209.85.160.69
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com
Received: by mail-oa1-f69.google.com with SMTP id 586e51a60fabf-40ef793e45eso252399fac.3
        for <syzbot@lists.linux.dev>; Wed, 29 Apr 2026 14:45:23 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1777499122; x=1778103922;
        h=cc:to:from:subject:message-id:date:mime-version:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=vNCT7ACWd4AnxSRjc1soR7ou6CeT/o6lApDSLv0qIJs=;
        b=M0X8LDjmXREXZap4htz25eBOPhem1PvUR+Hz9sDRfP3EYqLQFW8wVSuAIc9Xbb4WdB
         ZjLkC/dfG+POV/cBTmHn3DvstHFgggdJ3gnV2w1fiOCLitzc9WCwvPdeGbEGPoPZR7pW
         DXlq+ERYSItzv08xFpMBZJyn3wbvAXWVUBmAJC2HXek/h8LmpcHghOEeKcpR1Y6X/WJu
         RQK498prkpKuN1aUgyI01p0s05gqBIu9ROjisdXInmJmwR+ofSrd+bYgQBdAfxeoelkM
         XDSibqVk0HKwkKMwLpEAdILDNiyr0fkCHMulpOp5y9smxSxlNw3+1cYqqDlTF+bGOmC5
         z2YA==
X-Gm-Message-State: AOJu0Ywzhs5RCJXXDorwvhMgCU1/Eomr/IIyLtTVWGHtk8J6ghDdjKm0
	yKZa/1U4WpiNr7J4GWmtNjnZaUrPqwJSqWNW6ufVodLRX2C3x69UcBSaGv6mPfMDMU+zJogGf/L
	NItF65i2Xlp1rkTOPAgpezq+5YNs6ZfAJdtrhlENNL2pOdbIo7gVdZmJyvlQ=
Precedence: bulk
X-Mailing-List: syzbot@lists.linux.dev
List-Id: <syzbot.lists.linux.dev>
List-Subscribe: <mailto:syzbot+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:syzbot+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Received: by 2002:a05:6820:3096:b0:694:921b:b1b3 with SMTP id
 006d021491bc7-6967a5181edmr211508eaf.26.1777499122651; Wed, 29 Apr 2026
 14:45:22 -0700 (PDT)
Date: Wed, 29 Apr 2026 14:45:22 -0700
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <69f27bf2.050a0220.11c491.0004.GAE@google.com>
Subject: [moderation/CI] Re: kho: make boot time huge page allocation work
 nicely with KHO
From: syzbot ci <syzbot+ci0e20c63d08d09d13@syzkaller.appspotmail.com>
To: syzkaller-upstream-moderation@googlegroups.com
Cc: syzbot@lists.linux.dev
Content-Type: text/plain; charset="UTF-8"

syzbot ci has tested the following series

[v1] kho: make boot time huge page allocation work nicely with KHO
https://lore.kernel.org/all/20260429133928.850721-1-pratyush@kernel.org
* [PATCH 01/12] kho: generalize radix tree APIs
* [PATCH 02/12] kho: store incoming radix tree in kho_in
* [PATCH 03/12] kho: add a struct for radix callbacks
* [PATCH 04/12] kho: add callback for table pages
* [PATCH 05/12] kho: add data argument to radix walk callback
* [PATCH 06/12] kho: allow early-boot usage of the KHO radix tree
* [PATCH 07/12] kho: allow destroying KHO radix tree
* [PATCH 08/12] kho: add kho_radix_init_tree()
* [PATCH 09/12] memblock: introduce MEMBLOCK_KHO_SCRATCH_EXT
* [PATCH 10/12] kho: extended scratch
* [PATCH 11/12] kho: return virtual address of mem_map
* [PATCH 12/12] mm/hugetlb: make bootmem allocation work with KHO

and found the following issue:
kernel build error

Full report is available here:
https://ci.syzbot.org/series/c7dbc3fb-1241-4c20-9d8f-45044f883fc1

***

kernel build error

tree:      linux-next
URL:       https://kernel.googlesource.com/pub/scm/linux/kernel/git/next/linux-next
base:      eee13213401bafb7ffe3b447adffb1f570b9d813
arch:      amd64
compiler:  Debian clang version 21.1.8 (++20251221033036+2078da43e25a-1~exp1~20251221153213.50), Debian LLD 21.1.8
config:    https://ci.syzbot.org/builds/f6197347-999f-421f-b3e4-88104c1fa324/config

mm/mm_init.c:2691:2: error: call to undeclared function 'kho_extend_scratch'; ISO C99 and later do not support implicit function declarations [-Wimplicit-function-declaration]

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
[akpm@linux-foundation.org david@kernel.org graf@amazon.com jasonmiu@google.com kexec@lists.infradead.org linux-kernel@vger.kernel.org linux-mm@kvack.org muchun.song@linux.dev osalvador@suse.de pasha.tatashin@soleen.com pratyush@kernel.org rppt@kernel.org]

If the report looks fine to you, reply with:
#syz upstream

If the report is a false positive, reply with
#syz invalid

