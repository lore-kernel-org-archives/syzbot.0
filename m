Received: from mail-ot1-f71.google.com (mail-ot1-f71.google.com [209.85.210.71])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 949DE3195F0
	for <syzbot@lists.linux.dev>; Mon, 25 May 2026 21:29:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.71
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779744588; cv=none; b=SpfhXZq1WV/I888zyMkrKgDNfrixlSmbqyRIKCZo7mE3635umxLQbPnYPDsN8Fowib3v10YGColCCr0JNV3E6OC1WI+UQV9N79gnEiEXJe0yQ5T3HFh02RGopYvq33KMbVAYEuWVIXGSMALiaAWSbqJwvibjllaMvjg25Xe4DCo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779744588; c=relaxed/simple;
	bh=WEGyzT6lYdp7/hypjZ4/Q5GglpzHZE48epUYL2YmBy4=;
	h=MIME-Version:Date:Message-ID:Subject:From:To:Cc:Content-Type; b=AYieBre7JDCANbrJXrlUke5igUcmh75nCVWVj+lDnW/xwX8mJrQvcUzQqyI3RUAD7ttXQKY2xbswg/Z7rNqv8wXaEsBcDSVns88RUVpyFtZd/zcNQyyONmIruITaH/O6FdXk4qsD/nBetZRQO25ajwcZi73geouJadsTO7aVbGA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com; arc=none smtp.client-ip=209.85.210.71
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com
Received: by mail-ot1-f71.google.com with SMTP id 46e09a7af769-7e3dbd97fe3so16469227a34.1
        for <syzbot@lists.linux.dev>; Mon, 25 May 2026 14:29:46 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1779744585; x=1780349385;
        h=cc:to:from:subject:message-id:date:mime-version:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=yXMMm8dnp5WKQ76ZYmu83GeIjMsATsUN6T1e6L9dtG8=;
        b=SWXgj7fIU/o+zTLhQ32wFnpD/jTHok/bCQvxiiUdfDSGtkHQn9XE4tDNCFfql8632a
         TXlv5RCDiZLAoZpU63WJHagApBfM9AuP1P7qiXrA8biCn5VDIXkK4iF002UWoh2id3NK
         2ludgdJ86ddX+ggp1j/3obYtoNTb/3fB66OGHh0JEozb20Lya2CtftmNJ5PUmQqDvGMG
         RobTY4UomywOupcPXvVoRenliZgpN36zYSi0/iLhZg1QTuJDXnFl2eNvYgbMws2UaZsg
         Bm3IGrASIhx/Xqt489ANTQbic112NjGV3Eg4ehpfalYyKCcGX2CMbCCPqMbGtcR7V/ws
         T7fg==
X-Gm-Message-State: AOJu0YwDsqq6CxiHx98HFNtg8okKxHC0PJdThVQi3NcHtL/qcNn+MEay
	1X4/Q9M+NLT5w1l8CTJkoakBpzgR0ut2QmwOJnKTthsL58mn6crdPzQdXiy219NzHkgOAQw5HFt
	yc6VkwEdY0hwD1/rfmq1yYMkCDC6ljcYfPKtnERT//Ytlvy969q4VaT/Zby0=
Precedence: bulk
X-Mailing-List: syzbot@lists.linux.dev
List-Id: <syzbot.lists.linux.dev>
List-Subscribe: <mailto:syzbot+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:syzbot+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Received: by 2002:a05:6820:6ae2:b0:684:5041:9296 with SMTP id
 006d021491bc7-69d7eb41db5mr10134041eaf.10.1779744585521; Mon, 25 May 2026
 14:29:45 -0700 (PDT)
Date: Mon, 25 May 2026 14:29:45 -0700
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <6a14bf49.050a0220.2385e8.001b.GAE@google.com>
Subject: [moderation/CI] Re: Implement a new generic pagewalk API
From: syzbot ci <syzbot+cib37dbe4691931542@syzkaller.appspotmail.com>
To: syzkaller-upstream-moderation@googlegroups.com
Cc: syzbot@lists.linux.dev
Content-Type: text/plain; charset="UTF-8"

syzbot ci has tested the following series

[v3] Implement a new generic pagewalk API
https://lore.kernel.org/all/20260525165528.184397-1-osalvador@suse.de
* [RFC PATCH v3 1/8] mm: Add softleaf_from_pud
* [RFC PATCH v3 2/8] mm: Add {pmd,pud}_huge_lock helper
* [RFC PATCH v3 3/8] mm: Implement folio_pmd_batch
* [RFC PATCH v3 4/8] mm: Implement pt_range_walk
* [RFC PATCH v3 5/8] mm: Make /proc/pid/smaps use the new generic pagewalk API
* [RFC PATCH v3 6/8] mm: Make /proc/pid/numa_maps use the new generic pagewalk API
* [RFC PATCH v3 7/8] mm: Make /proc/pid/pagemap use the new generic pagewalk API
* [RFC PATCH v3 8/8] mm: Make /proc/pid/clear_refs use the new generic pagewalk API

and found the following issue:
general protection fault in clear_refs_write

Full report is available here:
https://ci.syzbot.org/series/0beab2d0-9d88-4288-ac81-b294e51c057d

***

general protection fault in clear_refs_write

tree:      mm-new
URL:       https://kernel.googlesource.com/pub/scm/linux/kernel/git/akpm/mm.git
base:      5200f5f493f79f14bbdc349e402a40dfb32f23c8
arch:      amd64
compiler:  Debian clang version 21.1.8 (++20251221033036+2078da43e25a-1~exp1~20251221153213.50), Debian LLD 21.1.8
config:    https://ci.syzbot.org/builds/8f20e88b-808c-4c60-9b8e-0af4c9fce5ff/config
syz repro: https://ci.syzbot.org/findings/634b1f0a-cf64-4607-928a-ef3ad40f765c/syz_repro

Oops: general protection fault, probably for non-canonical address 0xdffffc0000000000: 0000 [#1] SMP KASAN PTI
KASAN: null-ptr-deref in range [0x0000000000000000-0x0000000000000007]
CPU: 1 UID: 0 PID: 5863 Comm: syz.0.17 Not tainted syzkaller #0 PREEMPT(full) 
Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS 1.16.2-debian-1.16.2-1 04/01/2014
RIP: 0010:clear_soft_dirty_pmd fs/proc/task_mmu.c:1545 [inline]
RIP: 0010:clear_refs_pmd_range fs/proc/task_mmu.c:1581 [inline]
RIP: 0010:clear_refs_write+0xaa7/0x1590 fs/proc/task_mmu.c:1721
Code: 44 24 10 4c 8b bc 24 20 02 00 00 83 7c 24 28 04 0f 85 aa 05 00 00 48 8b 9c 24 08 02 00 00 48 89 d8 48 c1 e8 03 48 89 44 24 58 <42> 80 3c 20 00 74 08 48 89 df e8 fa 2c c6 ff 4c 8b 23 4c 89 e6 48
RSP: 0018:ffffc900037bf960 EFLAGS: 00010246
RAX: 0000000000000000 RBX: 0000000000000000 RCX: 0000000000000005
RDX: ffffffff826b21ce RSI: ffffffff8eb17b50 RDI: 0000000000000001
RBP: ffffc900037bfc10 R08: ffff8881047c0000 R09: 0000000000000002
R10: 0000000000000002 R11: 0000000000000000 R12: dffffc0000000000
R13: fffff520006f7f40 R14: ffff8881141c8308 R15: ffff8881141c8300
FS:  00007ff8ffc1d6c0(0000) GS:ffff8882a928a000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 0000001b33e63fff CR3: 000000010476e000 CR4: 00000000000006f0
Call Trace:
 <TASK>
 do_loop_readv_writev fs/read_write.c:852 [inline]
 vfs_writev+0x4bd/0x990 fs/read_write.c:1061
 do_writev+0x154/0x2e0 fs/read_write.c:1105
 do_syscall_x64 arch/x86/entry/syscall_64.c:63 [inline]
 do_syscall_64+0x15f/0xf80 arch/x86/entry/syscall_64.c:94
 entry_SYSCALL_64_after_hwframe+0x77/0x7f
RIP: 0033:0x7ff8fed9ce59
Code: ff c3 66 2e 0f 1f 84 00 00 00 00 00 0f 1f 44 00 00 48 89 f8 48 89 f7 48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 ff ff 73 01 c3 48 c7 c1 e8 ff ff ff f7 d8 64 89 01 48
RSP: 002b:00007ff8ffc1d028 EFLAGS: 00000246 ORIG_RAX: 0000000000000014
RAX: ffffffffffffffda RBX: 00007ff8ff015fa0 RCX: 00007ff8fed9ce59
RDX: 0000000000000001 RSI: 00002000000000c0 RDI: 0000000000000003
RBP: 00007ff8fee32d6f R08: 0000000000000000 R09: 0000000000000000
R10: 0000000000000000 R11: 0000000000000246 R12: 0000000000000000
R13: 00007ff8ff016038 R14: 00007ff8ff015fa0 R15: 00007fffd02796e8
 </TASK>
Modules linked in:
---[ end trace 0000000000000000 ]---
RIP: 0010:clear_soft_dirty_pmd fs/proc/task_mmu.c:1545 [inline]
RIP: 0010:clear_refs_pmd_range fs/proc/task_mmu.c:1581 [inline]
RIP: 0010:clear_refs_write+0xaa7/0x1590 fs/proc/task_mmu.c:1721
Code: 44 24 10 4c 8b bc 24 20 02 00 00 83 7c 24 28 04 0f 85 aa 05 00 00 48 8b 9c 24 08 02 00 00 48 89 d8 48 c1 e8 03 48 89 44 24 58 <42> 80 3c 20 00 74 08 48 89 df e8 fa 2c c6 ff 4c 8b 23 4c 89 e6 48
RSP: 0018:ffffc900037bf960 EFLAGS: 00010246
RAX: 0000000000000000 RBX: 0000000000000000 RCX: 0000000000000005
RDX: ffffffff826b21ce RSI: ffffffff8eb17b50 RDI: 0000000000000001
RBP: ffffc900037bfc10 R08: ffff8881047c0000 R09: 0000000000000002
R10: 0000000000000002 R11: 0000000000000000 R12: dffffc0000000000
R13: fffff520006f7f40 R14: ffff8881141c8308 R15: ffff8881141c8300
FS:  00007ff8ffc1d6c0(0000) GS:ffff8882a928a000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 0000001b34063fff CR3: 000000010476e000 CR4: 00000000000006f0
----------------
Code disassembly (best guess):
   0:	44 24 10             	rex.R and $0x10,%al
   3:	4c 8b bc 24 20 02 00 	mov    0x220(%rsp),%r15
   a:	00
   b:	83 7c 24 28 04       	cmpl   $0x4,0x28(%rsp)
  10:	0f 85 aa 05 00 00    	jne    0x5c0
  16:	48 8b 9c 24 08 02 00 	mov    0x208(%rsp),%rbx
  1d:	00
  1e:	48 89 d8             	mov    %rbx,%rax
  21:	48 c1 e8 03          	shr    $0x3,%rax
  25:	48 89 44 24 58       	mov    %rax,0x58(%rsp)
* 2a:	42 80 3c 20 00       	cmpb   $0x0,(%rax,%r12,1) <-- trapping instruction
  2f:	74 08                	je     0x39
  31:	48 89 df             	mov    %rbx,%rdi
  34:	e8 fa 2c c6 ff       	call   0xffc62d33
  39:	4c 8b 23             	mov    (%rbx),%r12
  3c:	4c 89 e6             	mov    %r12,%rsi
  3f:	48                   	rex.W


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
[akpm@linux-foundation.org david@kernel.org david@redhat.com linux-kernel@vger.kernel.org linux-mm@kvack.org lorenzo.stoakes@oracle.com mhocko@suse.com muchun.song@linux.dev osalvador@suse.de vbabka@kernel.org]

If the report looks fine to you, reply with:
#syz upstream

If the report is a false positive, reply with
#syz invalid

