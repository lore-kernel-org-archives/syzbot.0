Received: from mail-ot1-f69.google.com (mail-ot1-f69.google.com [209.85.210.69])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C4F17346FA9
	for <syzbot@lists.linux.dev>; Tue, 16 Dec 2025 18:05:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.69
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765908362; cv=none; b=eP5IZ7x3gT+O9TcJisl4xz8RiF67RgThpSz1xGGci7EnzQXLgpgPfXhAYZ55Q6ZLUwOhj+AqOcPGc/elNHoMWTweGYovG520xNYXPZEDw+WAqF3120NCmRfy8lbcU8Iv6zbsYmGwl+VdfiNBURvIlU3DWQtxrg09lX65QBWmG9k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765908362; c=relaxed/simple;
	bh=F1c0Ap8V5tpnMRKaiJeBosTE8sXZYky96tPQHfBCQ+Q=;
	h=MIME-Version:Date:Message-ID:Subject:From:To:Cc:Content-Type; b=U9c9q4vDE2hVcYs1wc5KMCm3pk720guMXi+k1qqNihOgkmsQnRSGLxWKmbnzZ/Ivpz3SgWYh2k3kxo8TyZXYEmm1qIlg/uo3+tYLNTOlZavuZBTR6YBmaSahOQDuhwjztTCvB3M/hzR77B6v3VH9zGE4fFxPMDiuD4weqWxkVbI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com; arc=none smtp.client-ip=209.85.210.69
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com
Received: by mail-ot1-f69.google.com with SMTP id 46e09a7af769-7c75663feaeso5659138a34.3
        for <syzbot@lists.linux.dev>; Tue, 16 Dec 2025 10:05:59 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1765908358; x=1766513158;
        h=content-transfer-encoding:cc:to:from:subject:message-id:date
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=1T5AFOkrw0NUbv7qVUNKuZ9/imBB5Qe0F/eREoQ+V4A=;
        b=HKTxS6qNaeimmYR9PsY8ycc1R20UwgAZbefoDYm6d9e2TFwtmVuu0AeVd7lPGHyZiB
         Sd0tMPZNn4eSr7BV1NHKRN3S8rmeqCG7CwsMCeSlWvJkiOttg3f1iUj8pYBbczgqjzmJ
         Ug0yPDWw/9IXcBd4fh3JpmdJBxNKCkoBsSldthaKBSnQkaH3n0Nj75Yq3zIKRQD+/MrE
         vIJXngyNUwppBs2kyKIgU9tICbYem31iyEfKAryVdg+Ukl6GNz/SQ8BnhnOCnbhzXheD
         El1iD1LMsd8beymPLFX9xuqv759c1xGOs1mGiWAGeh9E+qLswEr3WZgyUsMon8fJeM0y
         AuHw==
X-Gm-Message-State: AOJu0YzZgLwhRS7LOh3Nv8TBi8sn2cDSyBCpNzCL04nM2FxulUxofOTc
	V45SPwd4fmCq6KjDFDEntXANLN7ZNUnNIF6nT2QeCeHJ+GWlv/H1Eu7uBO2uDN5Z8s4yOtOT07C
	ASW/Tmc7pLXOubjhNfU8aebktkjF6Ika0B+duvR7L9xFOVL5Cj7XnVTl+6KM=
X-Google-Smtp-Source: AGHT+IEgyAay3sIgxVV9zAboLADR5m8b5QYQCBuxnybCa7v5W3IL3HXplfLml4BNUzadiwkIxD64ve3QPZy/d74ivttxW/am+GOb
Precedence: bulk
X-Mailing-List: syzbot@lists.linux.dev
List-Id: <syzbot.lists.linux.dev>
List-Subscribe: <mailto:syzbot+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:syzbot+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Received: by 2002:a05:6820:820:b0:65b:3376:a89c with SMTP id
 006d021491bc7-65b4520c4b4mr7476243eaf.67.1765908358602; Tue, 16 Dec 2025
 10:05:58 -0800 (PST)
Date: Tue, 16 Dec 2025 10:05:58 -0800
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <69419f86.a70a0220.25eec0.0004.GAE@google.com>
Subject: [moderation/CI] Re: tweaks for costly order __GFP_NORETRY reclaim
From: syzbot ci <syzbot+ci8566aa695dc7efec@syzkaller.appspotmail.com>
To: syzkaller-upstream-moderation@googlegroups.com
Cc: syzbot@lists.linux.dev
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

syzbot ci has tested the following series

[v1] tweaks for costly order __GFP_NORETRY reclaim
https://lore.kernel.org/all/20251216-thp-thisnode-tweak-v1-0-0e499d13d2eb@s=
use.cz
* [PATCH RFC 1/2] mm, page_alloc, thp: prevent reclaim for __GFP_THISNODE T=
HP allocations
* [PATCH RFC 2/2] mm, page_alloc: fail costly __GFP_NORETRY allocations fas=
ter

and found the following issue:
kernel build error

Full report is available here:
https://ci.syzbot.org/series/d26c9b4f-cf40-46e9-a5a8-388488c71904

***

kernel build error

tree:      mm-new
URL:       https://kernel.googlesource.com/pub/scm/linux/kernel/git/akpm/mm=
.git
base:      c642ecda5b136882e518d8303863473c0d21ab2f
arch:      amd64
compiler:  Debian clang version 20.1.8 (++20250708063551+0c9f909b7976-1~exp=
1~20250708183702.136), Debian LLD 20.1.8
config:    https://ci.syzbot.org/builds/6cf2accb-ad00-42a0-a354-545bfd39b6c=
b/config

mm/page_alloc.c:4936:1: error: function definition is not allowed here
mm/page_alloc.c:5004:1: error: function definition is not allowed here
mm/page_alloc.c:5152:1: error: function definition is not allowed here
mm/page_alloc.c:5217:1: error: function definition is not allowed here
mm/page_alloc.c:5229:1: error: function definition is not allowed here
mm/page_alloc.c:5242:1: error: function definition is not allowed here
mm/page_alloc.c:5253:1: error: function definition is not allowed here
mm/page_alloc.c:5260:1: error: function definition is not allowed here
mm/page_alloc.c:5304:1: error: function definition is not allowed here
mm/page_alloc.c:5314:1: error: function definition is not allowed here
mm/page_alloc.c:5328:1: error: function definition is not allowed here
mm/page_alloc.c:5339:1: error: function definition is not allowed here
mm/page_alloc.c:5374:1: error: function definition is not allowed here
mm/page_alloc.c:5399:1: error: function definition is not allowed here
mm/page_alloc.c:5420:1: error: function definition is not allowed here
mm/page_alloc.c:5444:1: error: function definition is not allowed here
mm/page_alloc.c:5473:1: error: function definition is not allowed here
mm/page_alloc.c:5479:1: error: function definition is not allowed here
mm/page_alloc.c:5490:1: error: function definition is not allowed here

***

If these findings have caused you to resend the series or submit a
separate fix, please add the following tag to your commit message:
  Tested-by: syzbot@syzkaller.appspotmail.com

---
This report is generated by a bot. It may contain errors.
syzbot ci engineers can be reached at syzkaller@googlegroups.com.

The email will later be sent to:
[akpm@linux-foundation.org david@kernel.org hannes@cmpxchg.org jackmanb@goo=
gle.com joshua.hahnjy@gmail.com liam.howlett@oracle.com linux-kernel@vger.k=
ernel.org linux-mm@kvack.org lorenzo.stoakes@oracle.com mhocko@suse.com pfa=
lcato@suse.de rientjes@google.com rppt@kernel.org surenb@google.com vbabka@=
suse.cz ziy@nvidia.com]

If the report looks fine to you, reply with:
#syz upstream

