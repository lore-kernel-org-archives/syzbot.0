Received: from mail-ot1-f72.google.com (mail-ot1-f72.google.com [209.85.210.72])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 18804381AE4
	for <syzbot@lists.linux.dev>; Mon, 23 Mar 2026 21:59:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.72
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774303187; cv=none; b=coRoUn91/Ji75SiRqXunueRiHgWoNZRn7Uk8rwniUIa2fF9KWq/sZ2Z2iSjRjFzmaJYmqpsGu6oqTGxFIKAx9d4alkYsPGdoC58i4N0LigSWRsdlT43NjpS9Vgb3khWGCjRPcy173h93oqjInGR21wCrVH/lagRV6KhdifDjGi0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774303187; c=relaxed/simple;
	bh=lDHCJPKADiUJaSVjTOJ0cGTc29OlDfxIZNezGAkNtjs=;
	h=MIME-Version:Date:Message-ID:Subject:From:To:Cc:Content-Type; b=ZVeIcpOxcSvCDFva4PS6rcQZeqeZ5WYdwPwAXGMBgLqeq0wg4TTXSmoXukrrwYRbh+j1Pt+bADbwVhP9UKvZk6LQ07TtuqitSWOky3TU+Ydc8xN7Tp/84J9zuyhTCim9dZUG6JHLW6TMmgFUp50Xfj7xgpY4bUVyBRY/ROWrW/Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com; arc=none smtp.client-ip=209.85.210.72
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com
Received: by mail-ot1-f72.google.com with SMTP id 46e09a7af769-7d74211ff80so12885397a34.3
        for <syzbot@lists.linux.dev>; Mon, 23 Mar 2026 14:59:44 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1774303183; x=1774907983;
        h=cc:to:from:subject:message-id:date:mime-version:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=P4uQ3naCIP0ZVlJYvmWGaVpncWZvEHo+7Iyo86kz0SY=;
        b=pEKy0u1V0yMek/Ec+zws2aS9yU/ZRew5AiPrQp4pqA9Xp33kzuNzePvx7wmbJLkm3f
         motDGTa8M0k0cjVkJiJM8CGVGjFxto+0/oQg21qJF3Z+/HUrcbTmb69aepvcYq9o15I7
         4jnUMZQKZjo9A1+3Fw3kyIeFVexefA59vqWb73vd5CmFOaqMJo5pfnakCI0uPu3J0NbK
         u6Plxc4gXNbotwF1ZHZKo6IkJAQZVTj+4DKB1O5CDKXkyh8UEK0F0TKg0gU7C3u7/wVp
         Eem2yU5s24PKZOcVS6HEJAnykcxtuyfFXHu4cMBxBKGQkRlGZunKMY34ezKHH28lZL/K
         NfqA==
X-Gm-Message-State: AOJu0YzofXIvQCSqCHkFjQIRs1kHsHsX/T1LoHDGFy7z/399vri4zjRr
	EzwRQ1qRMpOIUiAAdAQEIyzGmJaBapkujAWFacfR8/OEDXJsQe1Ox08ZVNK3RssQKN7CQTm40hX
	PG1KGB2UG0lWYL2C0IPtJO21ywl2jZrskXKvXLCwMpTTIeWGgTKqYzUnUo2w=
Precedence: bulk
X-Mailing-List: syzbot@lists.linux.dev
List-Id: <syzbot.lists.linux.dev>
List-Subscribe: <mailto:syzbot+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:syzbot+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Received: by 2002:a05:6820:16aa:b0:67d:ea28:5062 with SMTP id
 006d021491bc7-67dea2852f1mr3593870eaf.46.1774303183703; Mon, 23 Mar 2026
 14:59:43 -0700 (PDT)
Date: Mon, 23 Mar 2026 14:59:43 -0700
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <69c1b7cf.a70a0220.59f55.0000.GAE@google.com>
Subject: [moderation/CI] Re: udf: Fix race between file type conversion and writeback
From: syzbot ci <syzbot+ci12b9eb010cb59f32@syzkaller.appspotmail.com>
To: syzkaller-upstream-moderation@googlegroups.com
Cc: syzbot@lists.linux.dev
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

The email will later be sent to:
[jack@suse.cz linux-fsdevel@vger.kernel.org linux-mm@kvack.org luckd0g@163.com]

If the report looks fine to you, reply with:
#syz upstream

If the report is a false positive, reply with
#syz invalid

