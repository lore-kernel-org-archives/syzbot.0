Received: from mail-oa1-f70.google.com (mail-oa1-f70.google.com [209.85.160.70])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 053F5382296
	for <syzbot@lists.linux.dev>; Mon, 23 Mar 2026 22:37:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.160.70
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774305438; cv=none; b=i2rUQ6L7lSCksty41G/0RiESp2GBkwesKbkhRS/lJwtVkwHSpEhhOSiu2E98CQKcnoJntudmHk1HARXPRmJC3ITeWtxiGUmyjGT2T7RvIvP5Ue6o+MHYON/IsvCqWzKeM8NCuob7dUKDHQhCQzTS2ue529dUgGHbMihcWZ/5X4c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774305438; c=relaxed/simple;
	bh=CbRItHa5Ars+g9TEER2N+R+HAIwbt+0F1ELaGiUx//4=;
	h=MIME-Version:Date:In-Reply-To:Message-ID:Subject:From:To:Cc:
	 Content-Type; b=Cz6Rok1KvUA9ZBkPMoWJqkq+s/THhb9BgZk/hNJix6Nlsxc4AIVOXtUbck7/df7WtYC1wj7cEVcME4/67KxnRLag8EONxKi021R5dwZ6tP+rX/7EwgNaGwFC+BUvKaZJO5+WgcVddfJZNS83HQvXbbwuh4yV6bqowzf/Uq6lpmo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com; arc=none smtp.client-ip=209.85.160.70
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com
Received: by mail-oa1-f70.google.com with SMTP id 586e51a60fabf-41702ea8343so20979519fac.0
        for <syzbot@lists.linux.dev>; Mon, 23 Mar 2026 15:37:16 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1774305436; x=1774910236;
        h=cc:to:from:subject:message-id:in-reply-to:date:mime-version
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=Oqjmh2SrD9FfDowoOONetke0bC+WpW+XYQbNawQm8vc=;
        b=skzT1WTZywTqyF2m1bg9rYV3WRV8gHWQOT1K94f4P1BjoPHt5zKKhG8slnihj9Tymr
         6I09jL0eFNqYonEmr8Dr4ff8ZZJDofl5rre+gaXOdXUO4ohOETAmVaA86DGrnNtspSWm
         rc1GRrNEVMWRcjMo+EY/48z4F8R2VHM2zZr6nNhMS8juLmi3lvyvry/vvzzW35XrbgQX
         LnPDuEavhMgKrXHhe96X3l3fCTgJyr6+Vlr1RAGWOxUsf6jDr5nuKDpzBSZHqUtEZ619
         xvaK3Wa4kIwfzn490vqT6v2+KMK2Q2oCDqaAe5CoTmajfDbCJnUX0Yzq+Z7pqBbbOYJF
         GU7g==
X-Gm-Message-State: AOJu0Yxz+h7An2Y0fSVMyaScS8phGk1AkIJJJoOkJsF92ivGiI4nteo3
	dClvFuqyV6/fTklF79rzZ2NcxnIXPye00xPztkPeapbrOWB11SCdjePUmxZBvolKTAzjWq50HMp
	rdhyf4zN6b9JPyLETeswdw8xcWS5jKfIwPhmZoruu3HDHfaQOHEj3EAzlaFg=
Precedence: bulk
X-Mailing-List: syzbot@lists.linux.dev
List-Id: <syzbot.lists.linux.dev>
List-Subscribe: <mailto:syzbot+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:syzbot+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Received: by 2002:a05:6820:152a:b0:67b:a8f8:f68c with SMTP id
 006d021491bc7-67c22ff3dc5mr9608160eaf.70.1774305435967; Mon, 23 Mar 2026
 15:37:15 -0700 (PDT)
Date: Mon, 23 Mar 2026 15:37:15 -0700
In-Reply-To: <20260323162617.2421-1-jack@suse.cz>
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <69c1c09b.a70a0220.59f55.0001.GAE@google.com>
Subject: [syzbot ci] Re: udf: Fix race between file type conversion and writeback
From: syzbot ci <syzbot+cie6df483244df2ff5@syzkaller.appspotmail.com>
To: jack@suse.cz, linux-fsdevel@vger.kernel.org, linux-mm@kvack.org, 
	luckd0g@163.com
Cc: syzbot@lists.linux.dev, syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"

syzbot ci has tested the following series

[v1] udf: Fix race between file type conversion and writeback
https://lore.kernel.org/all/20260323162617.2421-1-jack@suse.cz
* [PATCH 1/2] writeback: Export folio_prepare_writeback()
* [PATCH 2/2] udf: Fix race between file type conversion and writeback

and found the following issue:
general protection fault in folio_prepare_writeback

Full report is available here:
https://ci.syzbot.org/series/03e405d8-f247-471a-8469-f544c8393300

***

general protection fault in folio_prepare_writeback

tree:      mm-new
URL:       https://kernel.googlesource.com/pub/scm/linux/kernel/git/akpm/mm.git
base:      af5802cff33fe3c557dff87cd3897d14241a7c6d
arch:      amd64
compiler:  Debian clang version 21.1.8 (++20251221033036+2078da43e25a-1~exp1~20251221153213.50), Debian LLD 21.1.8
config:    https://ci.syzbot.org/builds/d1944db2-4f63-4e26-b642-d71f55382c9d/config
C repro:   https://ci.syzbot.org/findings/87b82667-f800-480e-b52a-38decce9e6c4/c_repro
syz repro: https://ci.syzbot.org/findings/87b82667-f800-480e-b52a-38decce9e6c4/syz_repro

Oops: general protection fault, probably for non-canonical address 0xdffffc0000000002: 0000 [#1] SMP KASAN PTI
KASAN: null-ptr-deref in range [0x0000000000000010-0x0000000000000017]
CPU: 0 UID: 0 PID: 1860 Comm: kworker/u9:3 Not tainted syzkaller #0 PREEMPT(full) 
Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS 1.16.2-debian-1.16.2-1 04/01/2014
Workqueue: writeback wb_workfn (flush-7:0)
RIP: 0010:folio_prepare_writeback+0x32/0x280 mm/page-writeback.c:2371
Code: 56 41 55 41 54 53 50 48 89 d3 48 89 f5 49 89 fe 49 bd 00 00 00 00 00 fc ff df e8 f9 22 c2 ff 4c 8d 63 18 4c 89 e0 48 c1 e8 03 <42> 80 3c 28 00 74 08 4c 89 e7 e8 ef 6a 2c 00 4d 39 34 24 0f 85 bf
RSP: 0018:ffffc9000901f1e8 EFLAGS: 00010203
RAX: 0000000000000002 RBX: fffffffffffffffe RCX: ffff88810981ba80
RDX: 0000000000000000 RSI: ffffc9000901f4e0 RDI: ffff8881a659bc48
RBP: ffffc9000901f4e0 R08: ffff88810981ba80 R09: 0000000000000003
R10: 0000000000000406 R11: 0000000000000000 R12: 0000000000000016
R13: dffffc0000000000 R14: ffff8881a659bc48 R15: ffffc9000901f4e0
FS:  0000000000000000(0000) GS:ffff88818de5e000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 00001b4fda9cd4b8 CR3: 0000000110906000 CR4: 00000000000006f0
Call Trace:
 <TASK>
 udf_writepages+0xce/0x3b0 fs/udf/inode.c:205
 do_writepages+0x32e/0x550 mm/page-writeback.c:2554
 __writeback_single_inode+0x133/0x11a0 fs/fs-writeback.c:1750
 writeback_sb_inodes+0x992/0x1a20 fs/fs-writeback.c:2042
 wb_writeback+0x456/0xb70 fs/fs-writeback.c:2227
 wb_do_writeback fs/fs-writeback.c:2374 [inline]
 wb_workfn+0x414/0xf50 fs/fs-writeback.c:2414
 process_one_work kernel/workqueue.c:3276 [inline]
 process_scheduled_works+0xb6e/0x18c0 kernel/workqueue.c:3359
 worker_thread+0xa53/0xfc0 kernel/workqueue.c:3440
 kthread+0x388/0x470 kernel/kthread.c:436
 ret_from_fork+0x51e/0xb90 arch/x86/kernel/process.c:158
 ret_from_fork_asm+0x1a/0x30 arch/x86/entry/entry_64.S:245
 </TASK>
Modules linked in:
---[ end trace 0000000000000000 ]---
RIP: 0010:folio_prepare_writeback+0x32/0x280 mm/page-writeback.c:2371
Code: 56 41 55 41 54 53 50 48 89 d3 48 89 f5 49 89 fe 49 bd 00 00 00 00 00 fc ff df e8 f9 22 c2 ff 4c 8d 63 18 4c 89 e0 48 c1 e8 03 <42> 80 3c 28 00 74 08 4c 89 e7 e8 ef 6a 2c 00 4d 39 34 24 0f 85 bf
RSP: 0018:ffffc9000901f1e8 EFLAGS: 00010203
RAX: 0000000000000002 RBX: fffffffffffffffe RCX: ffff88810981ba80
RDX: 0000000000000000 RSI: ffffc9000901f4e0 RDI: ffff8881a659bc48
RBP: ffffc9000901f4e0 R08: ffff88810981ba80 R09: 0000000000000003
R10: 0000000000000406 R11: 0000000000000000 R12: 0000000000000016
R13: dffffc0000000000 R14: ffff8881a659bc48 R15: ffffc9000901f4e0
FS:  0000000000000000(0000) GS:ffff8882a945e000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 00001b4fda9c7570 CR3: 0000000173314000 CR4: 00000000000006f0
----------------
Code disassembly (best guess):
   0:	56                   	push   %rsi
   1:	41 55                	push   %r13
   3:	41 54                	push   %r12
   5:	53                   	push   %rbx
   6:	50                   	push   %rax
   7:	48 89 d3             	mov    %rdx,%rbx
   a:	48 89 f5             	mov    %rsi,%rbp
   d:	49 89 fe             	mov    %rdi,%r14
  10:	49 bd 00 00 00 00 00 	movabs $0xdffffc0000000000,%r13
  17:	fc ff df
  1a:	e8 f9 22 c2 ff       	call   0xffc22318
  1f:	4c 8d 63 18          	lea    0x18(%rbx),%r12
  23:	4c 89 e0             	mov    %r12,%rax
  26:	48 c1 e8 03          	shr    $0x3,%rax
* 2a:	42 80 3c 28 00       	cmpb   $0x0,(%rax,%r13,1) <-- trapping instruction
  2f:	74 08                	je     0x39
  31:	4c 89 e7             	mov    %r12,%rdi
  34:	e8 ef 6a 2c 00       	call   0x2c6b28
  39:	4d 39 34 24          	cmp    %r14,(%r12)
  3d:	0f                   	.byte 0xf
  3e:	85                   	.byte 0x85
  3f:	bf                   	.byte 0xbf


***

If these findings have caused you to resend the series or submit a
separate fix, please add the following tag to your commit message:
  Tested-by: syzbot@syzkaller.appspotmail.com

---
This report is generated by a bot. It may contain errors.
syzbot ci engineers can be reached at syzkaller@googlegroups.com.
