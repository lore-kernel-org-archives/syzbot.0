Received: from mail-oi1-f197.google.com (mail-oi1-f197.google.com [209.85.167.197])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 862D6249EB
	for <syzbot@lists.linux.dev>; Wed, 15 Jul 2026 00:21:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.167.197
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784074871; cv=none; b=eg3X+ozTmZx0ddO7eK/jGVzBXMidy134uUQ4dPG0kyAaZecuxDVMzJLN/mSg3LvaqItRAAGJ6ZMd++cgR6DTi9mS5+z0UE25JJG3v7j4T7EhnKS9713GAHaH+1vcOy0oMPscWRN1IZ84kaUZZUWGSgxkV4Gq6//3KyL+MJSqMtI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784074871; c=relaxed/simple;
	bh=Z5RUaArWNM8UswWK9Z/33cR8cCO5guW/e9mx9ACnKdw=;
	h=MIME-Version:Date:Message-ID:Subject:From:To:Cc:Content-Type; b=eiogj4kIJ3ZOid7pGXYmlvbqPDQ3orZnKyg+ptW1e3dRwUo2c05mpZgTLlUROnfmKJ+iRrHX3e93+BCZiXf1uyJuBdibKB2EMzHN7FNTVcoQqUDsFNC+vB5mvwCpf5OfS5Tt4xneZux1qlvIZsRe+c1pisZbzIsbVmTVqxWNIRE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com; arc=none smtp.client-ip=209.85.167.197
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com
Received: by mail-oi1-f197.google.com with SMTP id 5614622812f47-4893fc86bebso2301769b6e.0
        for <syzbot@lists.linux.dev>; Tue, 14 Jul 2026 17:21:09 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1784074868; x=1784679668;
        h=content-transfer-encoding:content-type:cc:to:from:subject
         :message-id:date:mime-version:x-gm-message-state:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=c9T7MESJh/8u/ZRslNdu8RwRoHHOKwDDRL2GLBqgBlA=;
        b=SnbseCIe8V5msiG1OwiMr8zdWGPOAaiUPRyvnkf7fYnLf9ZE+Pb8v5ZOt4SJNlY4Fm
         Xfym+TsaHxExTIhreROaxr5JBHzr8s0UQrjyOl+R0khQn0cP81cinzku6BmNR5qcmcpF
         LezUS9e+uhFZQRpF91qc7zrnq5z3U3Qqww2NR3vqivxZjcvIOeYquB2BN09/ZibSAiyv
         OzTnT3xlNNcdpz2U82/H90uZU1Ssg81AbrURPlmPDsDf402LlPTmDTEMFkwL3Mmbrwmq
         UfaxrFPRUWUg0gnmrpWqQWAD1Mzcf0xWZv85h5PuXEWjYjA06alLi/pUB2BGiZqM1s38
         6N2g==
X-Gm-Message-State: AOJu0YxiAzpGyzS02N7DlMazhxtR+I91Sz6qUonyP06tUvayRsD9FPNd
	gpVhYVScvwG7871TorpOHf3Roq1fuKpmOQb2UgMBD2P6pw4zsCJXaDrK5QUghwNvO7Sq231HIYL
	ewo+Jz2bSmUS1QWAT1FpjbPsOcw6WVQLXvnN0zIpVB8sl+y7w+FvA5J34HIw=
Precedence: bulk
X-Mailing-List: syzbot@lists.linux.dev
List-Id: <syzbot.lists.linux.dev>
List-Subscribe: <mailto:syzbot+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:syzbot+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Received: by 2002:a05:6808:c2f6:b0:494:18ad:8a5b with SMTP id
 5614622812f47-4a42ae6a10dmr9722083b6e.17.1784074868303; Tue, 14 Jul 2026
 17:21:08 -0700 (PDT)
Date: Tue, 14 Jul 2026 17:21:08 -0700
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <6a56d274.c90005c7.37d349.003a.GAE@google.com>
Subject: [moderation/CI] Re: mm: fix inode UAF when splitting a file folio
 past EOF
From: syzbot ci <syzbot+ciedb7aea4382fad92@syzkaller.appspotmail.com>
To: syzkaller-upstream-moderation@googlegroups.com
Cc: syzbot@lists.linux.dev
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

syzbot ci has tested the following series

[v2] mm: fix inode UAF when splitting a file folio past EOF
https://lore.kernel.org/all/20260714122344.351895-1-kirill@shutemov.name
* [PATCH v2 1/5] mm/memory-failure: keep the folio, not the poisoned subpag=
e, locked across split
* [PATCH v2 2/5] mm/huge_memory: refuse to split a file folio when the anch=
or is beyond EOF
* [PATCH v2 3/5] mm/huge_memory: remove unused split_huge_page_to_order()
* [PATCH v2 4/5] mm/huge_memory: remove unused can_split_folio()
* [PATCH v2 5/5] mm/huge_memory: fold split_folio_to_list_to_order() into s=
plit_folio_to_order()

and found the following issues:
* kernel BUG in __page_table_check_zero
* kernel BUG in folio_isolate_lru
* kernel BUG in memory_failure

Full report is available here:
https://ci.syzbot.org/series/6cad3430-1f9b-4a56-b60a-ef3ed2833e15

***

kernel BUG in __page_table_check_zero

tree:      bpf
URL:       https://kernel.googlesource.com/pub/scm/linux/kernel/git/bpf/bpf=
.git
base:      0e35b9b6ec0ffcc5e23cbdec09f5c622ad532b53
arch:      amd64
compiler:  Debian clang version 22.1.6 (++20260514074242+fc4aad7b5db3-1~exp=
1~20260514074407.73), Debian LLD 22.1.6
config:    https://ci.syzbot.org/builds/8d6a621e-aae6-4f99-8e0e-d0e02ddbed7=
1/config
syz repro: https://ci.syzbot.org/findings/1619ac56-823a-4cc2-975b-bbb1c1742=
447/syz_repro

Soft offlining pfn 0x120f0e at process virtual address 0x20000010e000
------------[ cut here ]------------
kernel BUG at mm/page_table_check.c:142!
Oops: invalid opcode: 0000 [#1] SMP KASAN PTI
CPU: 0 UID: 0 PID: 5870 Comm: syz.1.18 Not tainted syzkaller #0 PREEMPT(ful=
l)=20
Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS 1.16.2-debian-1.16=
.2-1 04/01/2014
RIP: 0010:__page_table_check_zero+0x416/0x430 mm/page_table_check.c:142
Code: f3 ff e9 4e fc ff ff e8 78 70 85 ff 89 ea be 01 00 00 00 48 c7 c7 a0 =
c4 ac 8e e8 45 29 b7 02 e9 48 fd ff ff e8 5b 70 85 ff 90 <0f> 0b e8 53 70 8=
5 ff 90 0f 0b e8 4b 70 85 ff 90 0f 0b 0f 1f 84 00
RSP: 0018:ffffc900017e7948 EFLAGS: 00010293
RAX: ffffffff8240f325 RBX: ffff88810544b4a8 RCX: ffff88810c68bb80
RDX: 0000000000000000 RSI: 0000000000000001 RDI: 0000000000000000
RBP: 0000000000000001 R08: ffff88810544b4ab R09: 1ffff11020a89695
R10: dffffc0000000000 R11: ffffed1020a89696 R12: 0000000000000001
R13: ffff88810544b460 R14: 0000000000000000 R15: 0000000000000001
FS:  00007fb17e6b86c0(0000) GS:ffff88818dc0e000(0000) knlGS:000000000000000=
0
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 00007f2353670000 CR3: 0000000109db2000 CR4: 00000000000006f0
Call Trace:
 <TASK>
 __folio_put+0x4b3/0x590 mm/swap.c:112
 folio_put include/linux/mm.h:2124 [inline]
 put_page include/linux/mm.h:2193 [inline]
 page_handle_poison+0x35d/0x4a0 mm/memory-failure.c:204
 soft_offline_in_use_page mm/memory-failure.c:2861 [inline]
 soft_offline_page+0xd1d/0x1560 mm/memory-failure.c:2952
 madvise_inject_error mm/madvise.c:1476 [inline]
 madvise_do_behavior+0x319/0x930 mm/madvise.c:1897
 do_madvise+0x327/0x3a0 mm/madvise.c:2005
 __do_sys_madvise mm/madvise.c:2014 [inline]
 __se_sys_madvise mm/madvise.c:2012 [inline]
 __x64_sys_madvise+0xa6/0xc0 mm/madvise.c:2012
 do_syscall_x64 arch/x86/entry/syscall_64.c:63 [inline]
 do_syscall_64+0x174/0x580 arch/x86/entry/syscall_64.c:94
 entry_SYSCALL_64_after_hwframe+0x77/0x7f
RIP: 0033:0x7fb17d79ce59
Code: ff c3 66 2e 0f 1f 84 00 00 00 00 00 0f 1f 44 00 00 48 89 f8 48 89 f7 =
48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 ff f=
f 73 01 c3 48 c7 c1 e8 ff ff ff f7 d8 64 89 01 48
RSP: 002b:00007fb17e6b8028 EFLAGS: 00000246 ORIG_RAX: 000000000000001c
RAX: ffffffffffffffda RBX: 00007fb17da15fa0 RCX: 00007fb17d79ce59
RDX: 0000000000000065 RSI: 0000000000002000 RDI: 000020000010e000
RBP: 00007fb17d832e6f R08: 0000000000000000 R09: 0000000000000000
R10: 0000000000000000 R11: 0000000000000246 R12: 0000000000000000
R13: 00007fb17da16038 R14: 00007fb17da15fa0 R15: 00007ffd7e9be1d8
 </TASK>
Modules linked in:
---[ end trace 0000000000000000 ]---
RIP: 0010:__page_table_check_zero+0x416/0x430 mm/page_table_check.c:142
Code: f3 ff e9 4e fc ff ff e8 78 70 85 ff 89 ea be 01 00 00 00 48 c7 c7 a0 =
c4 ac 8e e8 45 29 b7 02 e9 48 fd ff ff e8 5b 70 85 ff 90 <0f> 0b e8 53 70 8=
5 ff 90 0f 0b e8 4b 70 85 ff 90 0f 0b 0f 1f 84 00
RSP: 0018:ffffc900017e7948 EFLAGS: 00010293
RAX: ffffffff8240f325 RBX: ffff88810544b4a8 RCX: ffff88810c68bb80
RDX: 0000000000000000 RSI: 0000000000000001 RDI: 0000000000000000
RBP: 0000000000000001 R08: ffff88810544b4ab R09: 1ffff11020a89695
R10: dffffc0000000000 R11: ffffed1020a89696 R12: 0000000000000001
R13: ffff88810544b460 R14: 0000000000000000 R15: 0000000000000001
FS:  00007fb17e6b86c0(0000) GS:ffff88818dc0e000(0000) knlGS:000000000000000=
0
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 00007fb17d7ea540 CR3: 0000000109db2000 CR4: 00000000000006f0


***

kernel BUG in folio_isolate_lru

tree:      bpf
URL:       https://kernel.googlesource.com/pub/scm/linux/kernel/git/bpf/bpf=
.git
base:      0e35b9b6ec0ffcc5e23cbdec09f5c622ad532b53
arch:      amd64
compiler:  Debian clang version 22.1.6 (++20260514074242+fc4aad7b5db3-1~exp=
1~20260514074407.73), Debian LLD 22.1.6
config:    https://ci.syzbot.org/builds/8d6a621e-aae6-4f99-8e0e-d0e02ddbed7=
1/config
syz repro: https://ci.syzbot.org/findings/7857300c-5c56-4b88-9f60-6f1f3603e=
3f1/syz_repro

 do_madvise+0x327/0x3a0 mm/madvise.c:2005
 __do_sys_madvise mm/madvise.c:2014 [inline]
 __se_sys_madvise mm/madvise.c:2012 [inline]
 __x64_sys_madvise+0xa6/0xc0 mm/madvise.c:2012
 do_syscall_x64 arch/x86/entry/syscall_64.c:63 [inline]
 do_syscall_64+0x174/0x580 arch/x86/entry/syscall_64.c:94
 entry_SYSCALL_64_after_hwframe+0x77/0x7f
------------[ cut here ]------------
kernel BUG at mm/vmscan.c:1803!
Oops: invalid opcode: 0000 [#1] SMP KASAN PTI
CPU: 0 UID: 0 PID: 5810 Comm: syz.0.17 Not tainted syzkaller #0 PREEMPT(ful=
l)=20
Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS 1.16.2-debian-1.16=
.2-1 04/01/2014
RIP: 0010:folio_isolate_lru+0x8ad/0x990 mm/vmscan.c:1803
Code: 38 c1 0f 8c 75 fd ff ff 4c 89 f7 e8 ad 0e 28 00 e9 68 fd ff ff e8 d3 =
2b ba ff 4c 89 f7 48 c7 c6 20 5f d8 8b e8 84 d9 1b ff 90 <0f> 0b e8 bc 2b b=
a ff 4c 89 f7 48 c7 c6 60 8e d8 8b e8 6d d9 1b ff
RSP: 0018:ffffc90003c678d8 EFLAGS: 00010246
RAX: 2554150cb728ac00 RBX: 0000000000000000 RCX: 0000000000000000
RDX: 0000000000000006 RSI: ffffffff8dfe9eba RDI: 00000000ffffffff
RBP: 1ffffd40000f9d26 R08: ffffffff90334ef7 R09: 1ffffffff20669de
R10: dffffc0000000000 R11: fffffbfff20669df R12: dffffc0000000000
R13: 0000000000100010 R14: ffffea00007ce900 R15: ffffea00007ce934
FS:  00007fa1793946c0(0000) GS:ffff88818dc0e000(0000) knlGS:000000000000000=
0
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 00005640d3daa058 CR3: 00000001696d8000 CR4: 00000000000006f0
Call Trace:
 <TASK>
 delete_from_lru_cache+0x1a/0x1e0 mm/memory-failure.c:900
 me_pagecache_clean+0x58/0x230 mm/memory-failure.c:1015
 page_action mm/memory-failure.c:1298 [inline]
 identify_page_state+0x13c/0x190 mm/memory-failure.c:1649
 memory_failure+0x2fff/0x3380 mm/memory-failure.c:2548
 madvise_inject_error mm/madvise.c:1480 [inline]
 madvise_do_behavior+0x344/0x930 mm/madvise.c:1897
 do_madvise+0x327/0x3a0 mm/madvise.c:2005
 __do_sys_madvise mm/madvise.c:2014 [inline]
 __se_sys_madvise mm/madvise.c:2012 [inline]
 __x64_sys_madvise+0xa6/0xc0 mm/madvise.c:2012
 do_syscall_x64 arch/x86/entry/syscall_64.c:63 [inline]
 do_syscall_64+0x174/0x580 arch/x86/entry/syscall_64.c:94
 entry_SYSCALL_64_after_hwframe+0x77/0x7f
RIP: 0033:0x7fa17859ce59
Code: ff c3 66 2e 0f 1f 84 00 00 00 00 00 0f 1f 44 00 00 48 89 f8 48 89 f7 =
48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 ff f=
f 73 01 c3 48 c7 c1 e8 ff ff ff f7 d8 64 89 01 48
RSP: 002b:00007fa179394028 EFLAGS: 00000246 ORIG_RAX: 000000000000001c
RAX: ffffffffffffffda RBX: 00007fa178815fa0 RCX: 00007fa17859ce59
RDX: 0000000000000064 RSI: 0000000000002000 RDI: 00002000005a4000
RBP: 00007fa178632e6f R08: 0000000000000000 R09: 0000000000000000
R10: 0000000000000000 R11: 0000000000000246 R12: 0000000000000000
R13: 00007fa178816038 R14: 00007fa178815fa0 R15: 00007fff254e3208
 </TASK>
Modules linked in:
---[ end trace 0000000000000000 ]---
RIP: 0010:folio_isolate_lru+0x8ad/0x990 mm/vmscan.c:1803
Code: 38 c1 0f 8c 75 fd ff ff 4c 89 f7 e8 ad 0e 28 00 e9 68 fd ff ff e8 d3 =
2b ba ff 4c 89 f7 48 c7 c6 20 5f d8 8b e8 84 d9 1b ff 90 <0f> 0b e8 bc 2b b=
a ff 4c 89 f7 48 c7 c6 60 8e d8 8b e8 6d d9 1b ff
RSP: 0018:ffffc90003c678d8 EFLAGS: 00010246
RAX: 2554150cb728ac00 RBX: 0000000000000000 RCX: 0000000000000000
RDX: 0000000000000006 RSI: ffffffff8dfe9eba RDI: 00000000ffffffff
RBP: 1ffffd40000f9d26 R08: ffffffff90334ef7 R09: 1ffffffff20669de
R10: dffffc0000000000 R11: fffffbfff20669df R12: dffffc0000000000
R13: 0000000000100010 R14: ffffea00007ce900 R15: ffffea00007ce934
FS:  00007fa1793946c0(0000) GS:ffff88818dc0e000(0000) knlGS:000000000000000=
0
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 00005640d3daa058 CR3: 00000001696d8000 CR4: 00000000000006f0


***

kernel BUG in memory_failure

tree:      bpf
URL:       https://kernel.googlesource.com/pub/scm/linux/kernel/git/bpf/bpf=
.git
base:      0e35b9b6ec0ffcc5e23cbdec09f5c622ad532b53
arch:      amd64
compiler:  Debian clang version 22.1.6 (++20260514074242+fc4aad7b5db3-1~exp=
1~20260514074407.73), Debian LLD 22.1.6
config:    https://ci.syzbot.org/builds/8d6a621e-aae6-4f99-8e0e-d0e02ddbed7=
1/config
syz repro: https://ci.syzbot.org/findings/6feafe6c-6796-475f-9aca-225a9d357=
47c/syz_repro

 do_madvise+0x327/0x3a0 mm/madvise.c:2005
 __do_sys_madvise mm/madvise.c:2014 [inline]
 __se_sys_madvise mm/madvise.c:2012 [inline]
 __x64_sys_madvise+0xa6/0xc0 mm/madvise.c:2012
 do_syscall_x64 arch/x86/entry/syscall_64.c:63 [inline]
 do_syscall_64+0x174/0x580 arch/x86/entry/syscall_64.c:94
 entry_SYSCALL_64_after_hwframe+0x77/0x7f
------------[ cut here ]------------
kernel BUG at mm/memory-failure.c:2483!
Oops: invalid opcode: 0000 [#1] SMP KASAN PTI
CPU: 1 UID: 0 PID: 5850 Comm: syz.1.18 Not tainted syzkaller #0 PREEMPT(ful=
l)=20
Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS 1.16.2-debian-1.16=
.2-1 04/01/2014
RIP: 0010:memory_failure+0x3373/0x3380 mm/memory-failure.c:2483
Code: cb 87 ff 48 89 df 48 c7 c6 e0 a2 dd 8b e8 45 79 e9 fe 90 0f 0b e8 7d =
cb 87 ff 4c 89 f7 48 c7 c6 40 93 dd 8b e8 2e 79 e9 fe 90 <0f> 0b 66 66 2e 0=
f 1f 84 00 00 00 00 00 90 90 90 90 90 90 90 90 90
RSP: 0018:ffffc900036efa00 EFLAGS: 00010246
RAX: 9a71b80f9d8a2200 RBX: 0000000000000000 RCX: 0000000000000000
RDX: 0000000000000006 RSI: ffffffff8dfe9eba RDI: 00000000ffffffff
RBP: ffffc900036efb90 R08: ffffffff90334ef7 R09: 1ffffffff20669de
R10: dffffc0000000000 R11: fffffbfff20669df R12: ffffea00045f6ac0
R13: ffffea00045f0008 R14: ffffea00045f6ac0 R15: 1ffff920006ddf54
FS:  00007fed60fc56c0(0000) GS:ffff8882a920e000(0000) knlGS:000000000000000=
0
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 00007f3eee905440 CR3: 0000000165fdc000 CR4: 00000000000006f0
Call Trace:
 <TASK>
 madvise_inject_error mm/madvise.c:1480 [inline]
 madvise_do_behavior+0x344/0x930 mm/madvise.c:1897
 do_madvise+0x327/0x3a0 mm/madvise.c:2005
 __do_sys_madvise mm/madvise.c:2014 [inline]
 __se_sys_madvise mm/madvise.c:2012 [inline]
 __x64_sys_madvise+0xa6/0xc0 mm/madvise.c:2012
 do_syscall_x64 arch/x86/entry/syscall_64.c:63 [inline]
 do_syscall_64+0x174/0x580 arch/x86/entry/syscall_64.c:94
 entry_SYSCALL_64_after_hwframe+0x77/0x7f
RIP: 0033:0x7fed6019ce59
Code: ff c3 66 2e 0f 1f 84 00 00 00 00 00 0f 1f 44 00 00 48 89 f8 48 89 f7 =
48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 ff f=
f 73 01 c3 48 c7 c1 e8 ff ff ff f7 d8 64 89 01 48
RSP: 002b:00007fed60fc5028 EFLAGS: 00000246 ORIG_RAX: 000000000000001c
RAX: ffffffffffffffda RBX: 00007fed60415fa0 RCX: 00007fed6019ce59
RDX: 0000000000000064 RSI: 0000000000001000 RDI: 0000200000ffe000
RBP: 00007fed60232e6f R08: 0000000000000000 R09: 0000000000000000
R10: 0000000000000000 R11: 0000000000000246 R12: 0000000000000000
R13: 00007fed60416038 R14: 00007fed60415fa0 R15: 00007ffc1c6c3eb8
 </TASK>
Modules linked in:
---[ end trace 0000000000000000 ]---
RIP: 0010:memory_failure+0x3373/0x3380 mm/memory-failure.c:2483
Code: cb 87 ff 48 89 df 48 c7 c6 e0 a2 dd 8b e8 45 79 e9 fe 90 0f 0b e8 7d =
cb 87 ff 4c 89 f7 48 c7 c6 40 93 dd 8b e8 2e 79 e9 fe 90 <0f> 0b 66 66 2e 0=
f 1f 84 00 00 00 00 00 90 90 90 90 90 90 90 90 90
RSP: 0018:ffffc900036efa00 EFLAGS: 00010246
RAX: 9a71b80f9d8a2200 RBX: 0000000000000000 RCX: 0000000000000000
RDX: 0000000000000006 RSI: ffffffff8dfe9eba RDI: 00000000ffffffff
RBP: ffffc900036efb90 R08: ffffffff90334ef7 R09: 1ffffffff20669de
R10: dffffc0000000000 R11: fffffbfff20669df R12: ffffea00045f6ac0
R13: ffffea00045f0008 R14: ffffea00045f6ac0 R15: 1ffff920006ddf54
FS:  00007fed60fc56c0(0000) GS:ffff8882a920e000(0000) knlGS:000000000000000=
0
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 0000001b33863fff CR3: 0000000165fdc000 CR4: 00000000000006f0


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
[akpm@linux-foundation.org baohua@kernel.org baolin.wang@linux.alibaba.com =
david@kernel.org dev.jain@arm.com hao_zhang_kdev@163.com kas@kernel.org kir=
ill@shutemov.name lance.yang@linux.dev liam@infradead.org linmiaohe@huawei.=
com linux-kernel@vger.kernel.org linux-mm@kvack.org ljs@kernel.org nao.hori=
guchi@gmail.com npache@redhat.com ryan.roberts@arm.com stable@vger.kernel.o=
rg usama.arif@linux.dev zhanghao1@kylinos.cn ziy@nvidia.com]

If the report looks fine to you, reply with:
#syz upstream

If the report is a false positive, reply with
#syz invalid

