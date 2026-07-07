Received: from mail-oi1-f198.google.com (mail-oi1-f198.google.com [209.85.167.198])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C009443E9FB
	for <syzbot@lists.linux.dev>; Tue,  7 Jul 2026 18:30:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.167.198
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783449014; cv=none; b=eS6pOemJNNcQII4X4tewbc7ZDuh1MTcsgz3WC0CNQ5D3GxehjJU9W2Cw4c3lmmMJcJvlG1vGhcGXaecR62mxyWK9XvV5pe8v/WlRrA+LVU1uIk7d6CzgnCbe/fyriz5M/2PVBweTTeh8i1lSG/SkhwTR5HB5y3rcc6DZNvDEl8M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783449014; c=relaxed/simple;
	bh=JMlFmXHQr9JVC/+0nkv5QkzgmkmJ88FE0m+75olc2FU=;
	h=MIME-Version:Date:Message-ID:Subject:From:To:Cc:Content-Type; b=dWAwPe7F1MsXmhuzOPrUf1nIy2aArO9BOgFsw3WRK9KLpM0hCcO2/r4gBTHkUcyG5+HHLeFOK20EMiWjtS14x4uDEJBPaONBs1guvgxjnDtqM3w0UFg2latjkML4bgJG0VLBwIVOZao8KRtBrQwPK4LDsSCUcHBBniGhVSjciUQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com; arc=none smtp.client-ip=209.85.167.198
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com
Received: by mail-oi1-f198.google.com with SMTP id 5614622812f47-486055c1c6fso2105718b6e.1
        for <syzbot@lists.linux.dev>; Tue, 07 Jul 2026 11:30:12 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1783449011; x=1784053811;
        h=content-transfer-encoding:cc:to:from:subject:message-id:date
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=45ZEbHseMN/zMVGBZ41tVWhEnmMzjiPFO6l0hJ7GrTE=;
        b=bzbBIIDnIjTuwyBZe/se5k9XkQsQ3EtD/n1Zdfzmx/QtVYy0t+jKJ1QHyIinez+S6o
         q0TRY4RA5+/SxcRmfvhVrkE4SrJHEhsv9FuTIe0Q5TM3F8xsBY0bhXL/vt9YZ6+N1ZUd
         3g1U9b7ZyqmE8a4tJkv8d2C+tRmWt6fE5IGzVRhiiGloJmq7Nyo/Ety8bRa/jKJN5x9J
         Q1AJV0BSfqR+xPaZNfN9o4xGJHYLAMSegodeVlXjMBLd6S/y35JC1Hr/u5HaXlmodu8J
         0vj3JezvsCMX2kIsa1q2APsEcFX+eVMIueyAJRt42WRnaNgjuQO3jo0IJ5kbrxA1J/WC
         UWmw==
X-Gm-Message-State: AOJu0Yx4cEz1LeEEGBVVWCh/bnmpsFw0PvfelOmJ3ZGLmXIXEOL7Lvli
	nT8Ygpjo2TEVHLrtYcvkSD8mP1A7NT7rP5ZS7qWfLe4I5Dh+6yUXLCZwVt9n2M9JQUP8qCS22n+
	CnLmY+exyCIbjiWgrYgfS1t9LoJKSqfBVD7JH2aNrTgHYkwy5t1tErL8m4Y8=
Precedence: bulk
X-Mailing-List: syzbot@lists.linux.dev
List-Id: <syzbot.lists.linux.dev>
List-Subscribe: <mailto:syzbot+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:syzbot+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Received: by 2002:a05:6808:3986:b0:49b:e1e2:81b6 with SMTP id
 5614622812f47-49fddecbb11mr4143207b6e.27.1783449011597; Tue, 07 Jul 2026
 11:30:11 -0700 (PDT)
Date: Tue, 07 Jul 2026 11:30:11 -0700
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <6a4d45b3.c76b52dc.34afef.000e.GAE@google.com>
Subject: [moderation/CI] Re: mm: rework anon_vma and remove anon_vma_chain
From: syzbot ci <syzbot+cia0624a3957eaf595@syzkaller.appspotmail.com>
To: syzkaller-upstream-moderation@googlegroups.com
Cc: syzbot@lists.linux.dev
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

syzbot ci has tested the following series

[v2] mm: rework anon_vma and remove anon_vma_chain
https://lore.kernel.org/all/20260707063308.29176-1-tao.wangtao@honor.com
* [RFC PATCH v2 01/13] mm: add CONFIG_ANON_VMA_FRACTAL
* [RFC PATCH v2 02/13] mm: implement helpers for ANON_VMA_FRACTAL
* [RFC PATCH v2 03/13] mm: implement __anon_node_prepare for ANON_VMA_FRACT=
AL
* [RFC PATCH v2 04/13] mm: implement anon_node_clone for ANON_VMA_FRACTAL
* [RFC PATCH v2 05/13] mm: implement anon_node_fork_with_prev for ANON_VMA_=
FRACTAL
* [RFC PATCH v2 06/13] mm: implement unlink_anon_nodes for ANON_VMA_FRACTAL
* [RFC PATCH v2 07/13] mm: handle rmap_base changes for ANON_VMA_FRACTAL
* [RFC PATCH v2 08/13] mm: implement anonymous folio rmap for ANON_VMA_FRAC=
TAL
* [RFC PATCH v2 09/13] mm: prepare anon_node replacement for ANON_VMA_FRACT=
AL
* [RFC PATCH v2 10/13] mm: replace anon_vma with anon_node for ANON_VMA_FRA=
CTAL
* [RFC PATCH v2 11/13] mm: optimize rmap for ANON_VMA_FRACTAL with PVL
* [RFC PATCH v2 12/13] mm: shared semaphores for ANON_VMA_FRACTAL
* [RFC PATCH v2 13/13] mm: Enable CONFIG_ANON_VMA_FRACTAL by default

and found the following issue:
WARNING: bad unlock balance in exc_page_fault

Full report is available here:
https://ci.syzbot.org/series/39466cf1-707b-420e-8f1e-11735bea6c66

***

WARNING: bad unlock balance in exc_page_fault

tree:      mm-new
URL:       https://kernel.googlesource.com/pub/scm/linux/kernel/git/akpm/mm=
.git
base:      8ff49efd1cf18086320f3b43d1bd483c0b9e7e58
arch:      amd64
compiler:  Debian clang version 22.1.6 (++20260514074242+fc4aad7b5db3-1~exp=
1~20260514074407.73), Debian LLD 22.1.6
config:    https://ci.syzbot.org/builds/c3a229e4-b949-4889-b309-dbdd1fadd95=
f/config
syz repro: https://ci.syzbot.org/findings/29b52ad4-b463-41da-877c-4138356e3=
960/syz_repro

=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
WARNING: bad unlock balance detected!
syzkaller #0 Not tainted
-------------------------------------
sshd/5593 is trying to release lock (vm_lock) at:
[<ffffffff8bb5032a>] handle_page_fault arch/x86/mm/fault.c:1483 [inline]
[<ffffffff8bb5032a>] exc_page_fault+0x6a/0xc0 arch/x86/mm/fault.c:1536
but there are no more locks to release!

other info that might help us debug this:
no locks held by sshd/5593.

stack backtrace:
CPU: 1 UID: 0 PID: 5593 Comm: sshd Not tainted syzkaller #0 PREEMPT(full)=
=20
Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS 1.16.2-debian-1.16=
.2-1 04/01/2014
Call Trace:
 <TASK>
 dump_stack_lvl+0xe8/0x150 lib/dump_stack.c:120
 print_unlock_imbalance_bug+0xdc/0xf0 kernel/locking/lockdep.c:5298
 __lock_release kernel/locking/lockdep.c:5527 [inline]
 lock_release+0x1f1/0x3c0 kernel/locking/lockdep.c:5889
 vma_refcount_put include/linux/mmap_lock.h:216 [inline]
 vma_end_read include/linux/mmap_lock.h:264 [inline]
 do_user_addr_fault+0xab0/0x1340 arch/x86/mm/fault.c:1345
 handle_page_fault arch/x86/mm/fault.c:1483 [inline]
 exc_page_fault+0x6a/0xc0 arch/x86/mm/fault.c:1536
 asm_exc_page_fault+0x26/0x30 arch/x86/include/asm/idtentry.h:595
RIP: 0033:0x5583206de68b
Code: 04 25 28 00 00 00 48 89 44 24 08 31 c0 48 89 e2 e8 8c 5b ff ff 85 c0 =
78 13 31 c0 4d 85 e4 74 0c 48 8b 3c 24 48 89 de 4c 89 e1 <f3> a4 48 8b 54 2=
4 08 64 48 2b 14 25 28 00 00 00 74 05 e8 5e 17 fc
RSP: 002b:00007fff02a37e60 EFLAGS: 00010206
RAX: 0000000000000000 RBX: 000055835a20d6fe RCX: 0000000000008000
RDX: 0000000000000000 RSI: 000055835a20d6fe RDI: 00007fac5106c010
RBP: 000055832073df00 R08: 0000000000000000 R09: 0000000000000000
R10: 0000000000000000 R11: 0000000000000000 R12: 0000000000008000
R13: 000000000000005e R14: 00000000000000b3 R15: 00007fff02a37f88
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
[akpm@linux-foundation.org apopple@nvidia.com baohua@kernel.org baolin.wang=
@linux.alibaba.com baoquan.he@linux.dev bp@alien8.de byungchul@sk.com catal=
in.marinas@arm.com chengming.zhou@linux.dev damon@lists.linux.dev dave.hans=
en@linux.intel.com david@kernel.org dev.jain@arm.com dvander@google.com gou=
rry@gourry.net harry@kernel.org hpa@zytor.com jack@suse.cz jannh@google.com=
 jgg@ziepe.ca jhubbard@nvidia.com joshua.hahnjy@gmail.com jparsana@google.c=
om kas@kernel.org kees@kernel.org lance.yang@linux.dev liam@infradead.org l=
inux-arm-kernel@lists.infradead.org linux-fsdevel@vger.kernel.org linux-ker=
nel@vger.kernel.org linux-mm@kvack.org ljs@kernel.org luizcap@redhat.com ma=
tthew.brost@intel.com mhocko@suse.com mingo@redhat.com muchun.song@linux.de=
v nao.horiguchi@gmail.com npache@redhat.com peterx@redhat.com pfalcato@suse=
.de rakie.kim@sk.com riel@surriel.com rppt@kernel.org ryan.roberts@arm.com =
ryncsn@gmail.com shakeel.butt@linux.dev sj@kernel.org surenb@google.com tao=
.wangtao@honor.com]

If the report looks fine to you, reply with:
#syz upstream

If the report is a false positive, reply with
#syz invalid

