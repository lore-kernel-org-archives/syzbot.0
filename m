Received: from mail-ot1-f72.google.com (mail-ot1-f72.google.com [209.85.210.72])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4536036494F
	for <syzbot@lists.linux.dev>; Tue,  1 Sep 2026 06:59:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.72
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788245977; cv=none; b=suOVgzJfQ29vOPGhPHPRGmajVhIqcSZkcQJDXJBIW0sQVczipKCICKvSwBiORonO+GE2E8g6w813ua2p3xDigm4B6f1vf1VQrIj4FgnkCicxk0p52k+Xq2Dx3uLqBJ0k70BdV3vj6a1Xqpx/36lTo99Tecw1e09i2XkEHdapSiQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788245977; c=relaxed/simple;
	bh=bybDq+Dgk+bd3pbHkkH+vj+kmBGHB1tiLHdPmcf3tRo=;
	h=MIME-Version:Date:In-Reply-To:Message-ID:Subject:From:To:Cc:
	 Content-Type; b=UcfGHcMCXNAqdLpT4FSkCg0pCU5nON3uTcs2BlLBvbu8+gEiH3DqV4porUGHyfqDmRSwdQUVqQyMd0WHKC0SbesJ21mL9dNFWCZXq9w2VNQSIy6bFgJ94T5jiG+XIeM58T/3pIVQevKQYOChAHLyFKNXwa8HBaMCF3kH8CE08t0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com; arc=none smtp.client-ip=209.85.210.72
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com
Received: by mail-ot1-f72.google.com with SMTP id 46e09a7af769-7f4e8568ccdso881016a34.3
        for <syzbot@lists.linux.dev>; Mon, 31 Aug 2026 23:59:35 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1788245974; x=1788850774;
        h=content-type:cc:to:from:subject:message-id:in-reply-to:date
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to:content-type;
        bh=63L/bxFUv722Vl7mOzFbgh0sRzdogZ3j1mEhDHkXGRo=;
        b=ICsEfYdfQPC5jqqT/SE0dw3uMvwKW6V7U1f0evJyExrGicSsOcUsiplcoa2HP+Ojoi
         WX9rlwHa3I9hUv2zjJcECQ9IOm1y1OYIN+crgadX1ZQZL8VRVD6zA4VmSWFSHj4ZnbwR
         Df/+UPycXodoLyuKelY0xDRs9O4n4yP8SqUuNsp3QC6sWQhw4yHa7z/2HWMzRSwkLLZs
         XUhsvyB+dZVldBwtQRzDhAtlFUoHWi34nL1ln/NQRpFESHw/D8r63mpTjLeXia342yy7
         k9uwxZ434gz/lIRc5JsWLohyj0ifRrkLIYspBfGxr0tzv0cGaU6I1+lMuXdm9wIJGAhg
         OYJA==
X-Gm-Message-State: AFuF++nTPElILDNKZ9NRJJ6AQzTi54xlyKHx5BS44ML2BjJhN8Z/BGl/
	F7+XOL03w/MJJlFw7xdutqxxnrqa6TitVuHgeCxjlNSCyLjMf44y/eypfmAlLQSWTZqJKiWAF4h
	6/uogh+E2XacrH/5wJ+tOHv2BaUibtRxAx2s2DZh55gJYbbnTgR46k0wSOmA=
Precedence: bulk
X-Mailing-List: syzbot@lists.linux.dev
List-Id: <syzbot.lists.linux.dev>
List-Subscribe: <mailto:syzbot+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:syzbot+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Received: by 2002:a05:6820:824:b0:6b3:6d00:263b with SMTP id
 006d021491bc7-6b36d00398emr7086198eaf.19.1788245974251; Mon, 31 Aug 2026
 23:59:34 -0700 (PDT)
Date: Mon, 31 Aug 2026 23:59:34 -0700
In-Reply-To: <20260831152044.166353-1-ivanrwcm25@gmail.com>
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <6a9677d6.04428c52.29b18.0002.GAE@google.com>
Subject: [syzbot ci] Re: block: brd/loop error-path cleanup
From: syzbot ci <syzbot+ci7c1a0fc0cefeacdb@syzkaller.appspotmail.com>
To: axboe@kernel.dk, ivanrwcm25@gmail.com, linux-block@vger.kernel.org, 
	linux-kernel@vger.kernel.org
Cc: syzbot@lists.linux.dev, syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"

syzbot ci has tested the following series

[v1] block: brd/loop error-path cleanup
https://lore.kernel.org/all/20260831152044.166353-1-ivanrwcm25@gmail.com
* [PATCH v1 1/2] block: brd: destroy xa on allocation failure
* [PATCH v1 2/2] block: loop: restore state on loop_configure() error

and found the following issues:
* general protection fault in lo_release
* general protection fault in lo_rw_aio

Full report is available here:
https://ci.syzbot.org/series/9ab490fc-567e-414a-9754-890ca131012d

***

general protection fault in lo_release

tree:      axboe
URL:       https://kernel.googlesource.com/pub/scm/linux/kernel/git/axboe/linux.git
base:      44e96e364b04163ddddc8a24289cef4982b7e36e
arch:      amd64
compiler:  Debian clang version 22.1.8 (++20260613092233+e80beda6e255-1~exp1~20260613092250.77), Debian LLD 22.1.8
config:    https://ci.syzbot.org/builds/f5d23472-69ec-45bc-b33a-b59f7c0e7493/config
syz repro: https://ci.syzbot.org/findings/a48673c0-89de-4ffc-b71c-3aa9e5313ec8/syz_repro

Oops: general protection fault, probably for non-canonical address 0xdffffc000000000a: 0000 [#1] SMP KASAN PTI
KASAN: null-ptr-deref in range [0x0000000000000050-0x0000000000000057]
CPU: 0 UID: 0 PID: 5946 Comm: syz.0.87 Not tainted syzkaller #0 PREEMPT(full) 
Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS 1.16.2-debian-1.16.2-1 04/01/2014
RIP: 0010:__loop_clr_fd drivers/block/loop.c:1177 [inline]
RIP: 0010:lo_release+0x47c/0x7e0 drivers/block/loop.c:1780
Code: 89 e7 e8 77 60 fc fb bf e0 01 00 00 49 03 3c 24 be 02 00 00 00 e8 84 c6 9c 05 48 8b 44 24 30 4c 8d 70 50 4c 89 f0 48 c1 e8 03 <42> 80 3c 28 00 74 08 4c 89 f7 e8 45 60 fc fb 41 bc e8 00 00 00 4d
RSP: 0018:ffffc90003787b60 EFLAGS: 00010206
RAX: 000000000000000a RBX: ffff8881063f93c8 RCX: 0000000000000046
RDX: 0000000000000006 RSI: ffffffff8e46de57 RDI: ffffffff8c6d5780
RBP: ffffc90003787d08 R08: ffffffff9079c73f R09: 1ffffffff20f38e7
R10: dffffc0000000000 R11: fffffbfff20f38e8 R12: ffff8881063f8080
R13: dffffc0000000000 R14: 0000000000000050 R15: 1ffff920006f0f74
FS:  00007fae103d46c0(0000) GS:ffff88818d6f1000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 00007fae0f5eb840 CR3: 000000010c31a000 CR4: 00000000000006f0
Call Trace:
 <TASK>
 bdev_release+0x571/0x690 block/bdev.c:-1
 blkdev_release+0x15/0x20 block/fops.c:682
 __fput+0x418/0xa50 fs/file_table.c:512
 fput_close_sync+0x11f/0x240 fs/file_table.c:617
 __do_sys_close fs/open.c:1560 [inline]
 __se_sys_close fs/open.c:1545 [inline]
 __x64_sys_close+0x7e/0x110 fs/open.c:1545
 do_syscall_x64 arch/x86/entry/syscall_64.c:61 [inline]
 do_syscall_64+0x166/0x520 arch/x86/entry/syscall_64.c:84
 entry_SYSCALL_64_after_hwframe+0x77/0x7f
RIP: 0033:0x7fae0f55e98e
Code: 08 0f 85 a5 a8 ff ff 49 89 fb 48 89 f0 48 89 d7 48 89 ce 4c 89 c2 4d 89 ca 4c 8b 44 24 08 4c 8b 4c 24 10 4c 89 5c 24 08 0f 05 <c3> 66 2e 0f 1f 84 00 00 00 00 00 0f 1f 80 00 00 00 00 48 83 ec 08
RSP: 002b:00007fae103d3da8 EFLAGS: 00000246 ORIG_RAX: 0000000000000003
RAX: ffffffffffffffda RBX: 00007fae103d46c0 RCX: 00007fae0f55e98e
RDX: 0000000000000000 RSI: 0000000000000000 RDI: 0000000000000004
RBP: 0000000000000010 R08: 0000000000000000 R09: 0000000000000000
R10: 0000000000000000 R11: 0000000000000246 R12: 0000000000000003
R13: 00007fae103d3ee0 R14: 00007fae103d46a8 R15: 00007fae06600000
 </TASK>
Modules linked in:
---[ end trace 0000000000000000 ]---
RIP: 0010:__loop_clr_fd drivers/block/loop.c:1177 [inline]
RIP: 0010:lo_release+0x47c/0x7e0 drivers/block/loop.c:1780
Code: 89 e7 e8 77 60 fc fb bf e0 01 00 00 49 03 3c 24 be 02 00 00 00 e8 84 c6 9c 05 48 8b 44 24 30 4c 8d 70 50 4c 89 f0 48 c1 e8 03 <42> 80 3c 28 00 74 08 4c 89 f7 e8 45 60 fc fb 41 bc e8 00 00 00 4d
RSP: 0018:ffffc90003787b60 EFLAGS: 00010206
RAX: 000000000000000a RBX: ffff8881063f93c8 RCX: 0000000000000046
RDX: 0000000000000006 RSI: ffffffff8e46de57 RDI: ffffffff8c6d5780
RBP: ffffc90003787d08 R08: ffffffff9079c73f R09: 1ffffffff20f38e7
R10: dffffc0000000000 R11: fffffbfff20f38e8 R12: ffff8881063f8080
R13: dffffc0000000000 R14: 0000000000000050 R15: 1ffff920006f0f74
FS:  00007fae103d46c0(0000) GS:ffff8882a8cf1000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 00007ffd52a75ff8 CR3: 000000010c31a000 CR4: 00000000000006f0
----------------
Code disassembly (best guess):
   0:	89 e7                	mov    %esp,%edi
   2:	e8 77 60 fc fb       	call   0xfbfc607e
   7:	bf e0 01 00 00       	mov    $0x1e0,%edi
   c:	49 03 3c 24          	add    (%r12),%rdi
  10:	be 02 00 00 00       	mov    $0x2,%esi
  15:	e8 84 c6 9c 05       	call   0x59cc69e
  1a:	48 8b 44 24 30       	mov    0x30(%rsp),%rax
  1f:	4c 8d 70 50          	lea    0x50(%rax),%r14
  23:	4c 89 f0             	mov    %r14,%rax
  26:	48 c1 e8 03          	shr    $0x3,%rax
* 2a:	42 80 3c 28 00       	cmpb   $0x0,(%rax,%r13,1) <-- trapping instruction
  2f:	74 08                	je     0x39
  31:	4c 89 f7             	mov    %r14,%rdi
  34:	e8 45 60 fc fb       	call   0xfbfc607e
  39:	41 bc e8 00 00 00    	mov    $0xe8,%r12d
  3f:	4d                   	rex.WRB


***

general protection fault in lo_rw_aio

tree:      axboe
URL:       https://kernel.googlesource.com/pub/scm/linux/kernel/git/axboe/linux.git
base:      44e96e364b04163ddddc8a24289cef4982b7e36e
arch:      amd64
compiler:  Debian clang version 22.1.8 (++20260613092233+e80beda6e255-1~exp1~20260613092250.77), Debian LLD 22.1.8
config:    https://ci.syzbot.org/builds/f5d23472-69ec-45bc-b33a-b59f7c0e7493/config
syz repro: https://ci.syzbot.org/findings/556532c0-64a7-4471-9558-ea3a7a213af7/syz_repro

Oops: general protection fault, probably for non-canonical address 0xdffffc0000000009: 0000 [#1] SMP KASAN PTI
KASAN: null-ptr-deref in range [0x0000000000000048-0x000000000000004f]
CPU: 0 UID: 0 PID: 83 Comm: kworker/u9:3 Not tainted syzkaller #0 PREEMPT(full) 
Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS 1.16.2-debian-1.16.2-1 04/01/2014
Workqueue: loop0 loop_rootcg_workfn
RIP: 0010:lo_rw_aio+0xc36/0xf20 include/linux/percpu-rwsem.h:-1
Code: fb 48 8d 35 00 00 00 00 bf 60 04 00 00 48 03 3b e8 9f 51 68 fb bb 30 00 00 00 4c 8b 74 24 58 49 83 c6 48 4c 89 f0 48 c1 e8 03 <42> 80 3c 20 00 74 08 4c 89 f7 e8 8b 6c fc fb 49 03 1e 48 89 d8 48
RSP: 0018:ffffc9000277f620 EFLAGS: 00010206
RAX: 0000000000000009 RBX: 0000000000000028 RCX: ffff888102725a00
RDX: 0000000000000000 RSI: 0000000000000000 RDI: 0000000000000000
RBP: ffffc9000277f790 R08: ffff88810aa529a7 R09: 1ffff1102154a534
R10: dffffc0000000000 R11: ffffed102154a535 R12: dffffc0000000000
R13: 0000000000000000 R14: 0000000000000048 R15: ffff88810aa529b0
FS:  0000000000000000(0000) GS:ffff88818d6f1000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 0000558fd5b46210 CR3: 00000001bb152000 CR4: 00000000000006f0
Call Trace:
 <TASK>
 do_req_filebacked drivers/block/loop.c:432 [inline]
 loop_handle_cmd drivers/block/loop.c:1954 [inline]
 loop_process_work+0x960/0x11c0 drivers/block/loop.c:1989
 process_one_work kernel/workqueue.c:3387 [inline]
 process_scheduled_works+0xc3d/0x1630 kernel/workqueue.c:3470
 worker_thread+0xa47/0xfb0 kernel/workqueue.c:3551
 kthread+0x38b/0x480 kernel/kthread.c:436
 ret_from_fork+0x514/0xb70 arch/x86/kernel/process.c:158
 ret_from_fork_asm+0x1a/0x30 arch/x86/entry/entry_64.S:245
 </TASK>
Modules linked in:
---[ end trace 0000000000000000 ]---
RIP: 0010:lo_rw_aio+0xc36/0xf20 include/linux/percpu-rwsem.h:-1
Code: fb 48 8d 35 00 00 00 00 bf 60 04 00 00 48 03 3b e8 9f 51 68 fb bb 30 00 00 00 4c 8b 74 24 58 49 83 c6 48 4c 89 f0 48 c1 e8 03 <42> 80 3c 20 00 74 08 4c 89 f7 e8 8b 6c fc fb 49 03 1e 48 89 d8 48
RSP: 0018:ffffc9000277f620 EFLAGS: 00010206
RAX: 0000000000000009 RBX: 0000000000000028 RCX: ffff888102725a00
RDX: 0000000000000000 RSI: 0000000000000000 RDI: 0000000000000000
RBP: ffffc9000277f790 R08: ffff88810aa529a7 R09: 1ffff1102154a534
R10: dffffc0000000000 R11: ffffed102154a535 R12: dffffc0000000000
R13: 0000000000000000 R14: 0000000000000048 R15: ffff88810aa529b0
FS:  0000000000000000(0000) GS:ffff88818d6f1000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 0000558fd5b46210 CR3: 0000000169ee2000 CR4: 00000000000006f0
----------------
Code disassembly (best guess):
   0:	fb                   	sti
   1:	48 8d 35 00 00 00 00 	lea    0x0(%rip),%rsi        # 0x8
   8:	bf 60 04 00 00       	mov    $0x460,%edi
   d:	48 03 3b             	add    (%rbx),%rdi
  10:	e8 9f 51 68 fb       	call   0xfb6851b4
  15:	bb 30 00 00 00       	mov    $0x30,%ebx
  1a:	4c 8b 74 24 58       	mov    0x58(%rsp),%r14
  1f:	49 83 c6 48          	add    $0x48,%r14
  23:	4c 89 f0             	mov    %r14,%rax
  26:	48 c1 e8 03          	shr    $0x3,%rax
* 2a:	42 80 3c 20 00       	cmpb   $0x0,(%rax,%r12,1) <-- trapping instruction
  2f:	74 08                	je     0x39
  31:	4c 89 f7             	mov    %r14,%rdi
  34:	e8 8b 6c fc fb       	call   0xfbfc6cc4
  39:	49 03 1e             	add    (%r14),%rbx
  3c:	48 89 d8             	mov    %rbx,%rax
  3f:	48                   	rex.W


***

If these findings have caused you to resend the series or submit a
separate fix, please add the following tag to your commit message:
  Tested-by: syzbot@syzkaller.appspotmail.com

---
This report is generated by a bot. It may contain errors.
syzbot ci engineers can be reached at syzkaller@googlegroups.com.

To test a fix for this bug, please reply with `#syz test`
(on a separate line) and attach the patch to the email.

Notes:
- The patch will be applied on top of the tested series (as an
  incremental fix).
- To test a new version of the whole series, please send it directly
  to syzbot@lists.linux.dev.
- Arguments like custom git repos and branches are not supported.
