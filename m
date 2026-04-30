Received: from mail-oo1-f70.google.com (mail-oo1-f70.google.com [209.85.161.70])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 10B9B40DFDB
	for <syzbot@lists.linux.dev>; Thu, 30 Apr 2026 06:27:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.161.70
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777530468; cv=none; b=P/dz999GT2b0CNYK0hg2FxKka/RQSQ1HAx9LIdou4EqZZ3KwOig/L6GdF96dmiTSLlWQxpb22FyWqXvzCvgNxeU4BY8hTnODMjC5MBHphCtAh7Q3BvmvA2s1lWnLq3WAvD34+6+xq2ahIzDyM1i2JvCPTTWYOeKEWgL5RblV6v0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777530468; c=relaxed/simple;
	bh=scz5kKA45lPbhk4BGkzwvAdh02jWyH+JDkdPFXuyTdk=;
	h=MIME-Version:Date:Message-ID:Subject:From:To:Cc:Content-Type; b=WfKG2s0mI8PHeT12nj9O4fRhZhf2/MJM84A85Q/bVqM50bLd1Pot4AvqtvlM8khybdgqdnsLo1pCyghcK5GvZeVFlHM9ZNAY2Pvau7///eUStFu9NSgwZW+nJyBH2WJP73jQsdWBb8Ea31SEVknOF+ERaVC5y0SbkyIEJ6FPPL8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com; arc=none smtp.client-ip=209.85.161.70
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com
Received: by mail-oo1-f70.google.com with SMTP id 006d021491bc7-695391d14acso629485eaf.2
        for <syzbot@lists.linux.dev>; Wed, 29 Apr 2026 23:27:46 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1777530466; x=1778135266;
        h=cc:to:from:subject:message-id:date:mime-version:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=nh+jamdg2xyeyg9qWPM2mshihimWk37Eu+gRnGUfeUc=;
        b=UbSUIYGYfIW9cIZhJgUDIBQbkqLAtrBSOqTwONwpADk54j4hevLzQcCPP6kSwJr9qb
         Xtuy8QKWg7uv85mRDj64c1AZMsB7EpUEmUwpno+xYCmdzrHoZc1G2BHeam2MyjWS/sTa
         fFbgpHEXi3Cyg356tn5B28ccl54zJp1TC+f4fFgjNgI4tD8aH6+AXkHzD/ZP1ZziKWoY
         UXaHga3sY2jeXLm28CSBpRRCH30hJE3/CQsUmLis8I6Y56AmSgtva+hM87z1bcBAM5CW
         R25y3dnjDsy/xS7LIErCYgP1lqQLKoXtEXtfVJkUfY4v/qaYGxkUf71jrHG2WoD0ZaQk
         sRUQ==
X-Gm-Message-State: AOJu0Yx8g5oOveJ8MyIwqNQitMW9cLme1F99sEf0BiF4Ai0PaK9XM709
	y4SeeTrCJjm89mTSNJ6cpzMOulR8EKse3cK6YxDIIqV72S1SvGPpO4FulWK/wc4g3DChIkbxI1Y
	AOAg3QjulDdSEsml/qwk/oyIWgjjOxXVPsjoz9rqS3BJ7kvcSQUumtQV7wlo=
Precedence: bulk
X-Mailing-List: syzbot@lists.linux.dev
List-Id: <syzbot.lists.linux.dev>
List-Subscribe: <mailto:syzbot+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:syzbot+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Received: by 2002:a05:6820:4dfb:b0:67b:bd89:90ed with SMTP id
 006d021491bc7-6967a5fe398mr754890eaf.41.1777530465846; Wed, 29 Apr 2026
 23:27:45 -0700 (PDT)
Date: Wed, 29 Apr 2026 23:27:45 -0700
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <69f2f661.050a0220.11c491.000a.GAE@google.com>
Subject: [moderation/CI] Re: mm: Make per-VMA locks available in all builds
From: syzbot ci <syzbot+cife3f6234f9070b16@syzkaller.appspotmail.com>
To: syzkaller-upstream-moderation@googlegroups.com
Cc: syzbot@lists.linux.dev
Content-Type: text/plain; charset="UTF-8"

syzbot ci has tested the following series

[v1] mm: Make per-VMA locks available in all builds
https://lore.kernel.org/all/20260429181954.F50224AE@davehans-spike.ostc.intel.com
* [PATCH 1/6] mm: Make per-VMA locks available universally
* [PATCH 2/6] binder: Make shrinker rely solely on per-VMA lock
* [PATCH 3/6] mm: Add RCU-based VMA lookup that waits for writers
* [PATCH 4/6] binder: Remove mmap_lock fallback
* [PATCH 5/6] tcp: Remove mmap_lock fallback path
* [PATCH 6/6] x86/mm: Avoid mmap lock for shadow stack pop fast path

and found the following issue:
WARNING in mbind_range

Full report is available here:
https://ci.syzbot.org/series/374f338e-4b3b-4645-871c-78964f944bbd

***

WARNING in mbind_range

tree:      torvalds
URL:       https://kernel.googlesource.com/pub/scm/linux/kernel/git/torvalds/linux
base:      57b8e2d666a31fa201432d58f5fe3469a0dd83ba
arch:      amd64
compiler:  Debian clang version 21.1.8 (++20251221033036+2078da43e25a-1~exp1~20251221153213.50), Debian LLD 21.1.8
config:    https://ci.syzbot.org/builds/786ac31f-0f5e-4ceb-88c7-45f4bee79d60/config
syz repro: https://ci.syzbot.org/findings/4b270176-3e48-4ac7-8ddb-f326d6883d93/syz_repro

pgoff 200000000 file 0000000000000000 private_data 0000000000000000
flags: 0x8100077(read|write|exec|mayread|maywrite|mayexec|account|softdirty)
------------[ cut here ]------------
1
WARNING: ./include/linux/mmap_lock.h:332 at vma_assert_write_locked include/linux/mmap_lock.h:332 [inline], CPU#0: syz.2.19/5876
WARNING: ./include/linux/mmap_lock.h:332 at vma_replace_policy mm/mempolicy.c:1016 [inline], CPU#0: syz.2.19/5876
WARNING: ./include/linux/mmap_lock.h:332 at mbind_range+0x57a/0x810 mm/mempolicy.c:1063, CPU#0: syz.2.19/5876
Modules linked in:
CPU: 0 UID: 0 PID: 5876 Comm: syz.2.19 Not tainted syzkaller #0 PREEMPT(full) 
Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS 1.16.2-debian-1.16.2-1 04/01/2014
RIP: 0010:vma_assert_write_locked include/linux/mmap_lock.h:332 [inline]
RIP: 0010:vma_replace_policy mm/mempolicy.c:1016 [inline]
RIP: 0010:mbind_range+0x57a/0x810 mm/mempolicy.c:1063
Code: 97 ff e9 b2 fb ff ff e8 a4 4a 97 ff 90 0f 0b 90 e9 14 fe ff ff e8 96 4a 97 ff 4c 89 ff e8 0e b5 f9 fe c6 05 9c 2e ec 0d 01 90 <0f> 0b 90 4d 85 e4 0f 85 48 fe ff ff e8 75 4a 97 ff 31 db 4d 8d 77
RSP: 0018:ffffc90003bc7c78 EFLAGS: 00010292
RAX: 000000000000011f RBX: 000000000000000b RCX: a410c902b7e34800
RDX: 0000000000000000 RSI: 0000000080000000 RDI: 0000000000000000
RBP: 0000000000000009 R08: ffffc90003bc7967 R09: 1ffff92000778f2c
R10: dffffc0000000000 R11: fffff52000778f2d R12: ffff8881012c9e00
R13: dffffc0000000000 R14: ffff888115b99bf8 R15: ffff8881162fa300
FS:  00007fa09187c6c0(0000) GS:ffff88818dc93000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 0000001b33b63fff CR3: 0000000115bda000 CR4: 00000000000006f0
Call Trace:
 <TASK>
 do_mbind mm/mempolicy.c:1560 [inline]
 kernel_mbind mm/mempolicy.c:1757 [inline]
 __do_sys_mbind mm/mempolicy.c:1831 [inline]
 __se_sys_mbind+0xad4/0x10f0 mm/mempolicy.c:1827
 do_syscall_x64 arch/x86/entry/syscall_64.c:63 [inline]
 do_syscall_64+0x15f/0xf80 arch/x86/entry/syscall_64.c:94
 entry_SYSCALL_64_after_hwframe+0x77/0x7f
RIP: 0033:0x7fa09099cdd9
Code: ff c3 66 2e 0f 1f 84 00 00 00 00 00 0f 1f 44 00 00 48 89 f8 48 89 f7 48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 ff ff 73 01 c3 48 c7 c1 e8 ff ff ff f7 d8 64 89 01 48
RSP: 002b:00007fa09187c028 EFLAGS: 00000246 ORIG_RAX: 00000000000000ed
RAX: ffffffffffffffda RBX: 00007fa090c15fa0 RCX: 00007fa09099cdd9
RDX: 0000000000000001 RSI: 0000000000600000 RDI: 0000200000000000
RBP: 00007fa090a32d69 R08: 0000000000000000 R09: 0000000000000003
R10: 0000000000000000 R11: 0000000000000246 R12: 0000000000000000
R13: 00007fa090c16038 R14: 00007fa090c15fa0 R15: 00007ffff596d0f8
 </TASK>


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
[akpm@linux-foundation.org dave.hansen@linux.intel.com liam.howlett@oracle.com linux-kernel@vger.kernel.org linux-mm@kvack.org ljs@kernel.org shakeel.butt@linux.dev surenb@google.com vbabka@kernel.org]

If the report looks fine to you, reply with:
#syz upstream

If the report is a false positive, reply with
#syz invalid

