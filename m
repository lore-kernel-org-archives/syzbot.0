Received: from mail-io1-f70.google.com (mail-io1-f70.google.com [209.85.166.70])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 60D4D1FC110
	for <syzbot@lists.linux.dev>; Wed, 26 Nov 2025 04:49:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.70
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764132549; cv=none; b=NHo4j06zDtea6mhGK6PeKj8Z1BiaL4BBbDTIz2aKFcVGWMl2ZBDyFFqNMs7bPvTxGDxIu8r4K0Uhh8T4mTCGBZKhUmngHwrgUl7lfvmDCJWk7MAVyrd5qFcmR75zy3AmPVJS/wYYt6z0pNTieRN3XtCt0N03u21BtMgljtVD274=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764132549; c=relaxed/simple;
	bh=+K7266a4gKzpj/jQ9WeHAbGbk065iiIlfvqfP/Odn1o=;
	h=MIME-Version:Date:Message-ID:Subject:From:To:Cc:Content-Type; b=P8Je9qWgNj1Cu44lDD+lcuh9iPeRCJWbYFkIHcRis+dl00lv4X9yCY9KNKRN58tKkEia+pXj5PiezHQscJXPSCzCCVzpUUTBQfGqBgXMcxLcyzX+bi8SZt4cLH05fNAvah6IsYAHpWX3I2iOv6N092+l5DhnjCJFgo9XoLaAvzA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com; arc=none smtp.client-ip=209.85.166.70
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com
Received: by mail-io1-f70.google.com with SMTP id ca18e2360f4ac-9489c833d89so441657139f.2
        for <syzbot@lists.linux.dev>; Tue, 25 Nov 2025 20:49:07 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1764132546; x=1764737346;
        h=cc:to:from:subject:message-id:date:mime-version:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=MgN9AIrvFwT1icfsecnapcNstdXb+D+7oD70Ush66ww=;
        b=MFbhOrDgUHN87pLFvIkU22/Pq5iq84xG5nG7ovK70+BMRZen4ZEJ25QpUGbnc4Bko7
         USX1M24hzJR4K76BXjC3IeKER8Wqmv/0zoliQTiSm3DJv8OXdHdHTNzqd0D+SbH7pFlG
         +slCgLjFS0PCYDa9B7v0uAMHVrv1cagl3DRBF7Y4GKOQQVd9eulDBIHs3drmc/0EvnVb
         LVWU+fdI4LCSrrxZsJSVuSgs3eaROcSRE+9nDJADy6KLksl6fmnNke7DaRVwBCJnD8Bp
         LTH/OVgJ5LcHPQ/xEAqu0d86WvFViiLeEbevfSrHVHiJ60hSvnbG7mJguH/9rp01xqfy
         R8jw==
X-Gm-Message-State: AOJu0YyqODRjogpQOrUZX3rAZAS74MgrjDwZANdJ117f62BGTw6Qk6eS
	vsM2QnTzsdpOgAHa3n7OS2BR4Fbf6yJPMoHfeJdViYdO7fQN0juId/l6FZdeqjIrhKu2WNPJA1l
	iWI6XhUU8Cd+Wz156IW+ryHtCaI9NzLz1tgpAdST9UlTvteFiYsHKULna7cc=
X-Google-Smtp-Source: AGHT+IEgQp+V9WS55gAXatbBHcjDAbdj1LEIMy3DbHBMYnKPg0XcaUsIF4id3izkQnj9hzCoBTH1ubwVCjwW4taSrOrjw8QywKgr
Precedence: bulk
X-Mailing-List: syzbot@lists.linux.dev
List-Id: <syzbot.lists.linux.dev>
List-Subscribe: <mailto:syzbot+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:syzbot+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Received: by 2002:a05:6e02:1fe1:b0:433:3048:55ec with SMTP id
 e9e14a558f8ab-435b8eb4403mr138181985ab.27.1764132546405; Tue, 25 Nov 2025
 20:49:06 -0800 (PST)
Date: Tue, 25 Nov 2025 20:49:06 -0800
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <692686c2.a70a0220.d98e3.00ca.GAE@google.com>
Subject: [moderation/CI] Re: io_uring: avoid uring_lock for IORING_SETUP_SINGLE_ISSUER
From: syzbot ci <syzbot+ci1daaf56d0d213e2a@syzkaller.appspotmail.com>
To: syzkaller-upstream-moderation@googlegroups.com
Cc: syzbot@lists.linux.dev
Content-Type: text/plain; charset="UTF-8"

syzbot ci has tested the following series

[v3] io_uring: avoid uring_lock for IORING_SETUP_SINGLE_ISSUER
https://lore.kernel.org/all/20251125233928.3962947-1-csander@purestorage.com
* [PATCH v3 1/4] io_uring: clear IORING_SETUP_SINGLE_ISSUER for IORING_SETUP_SQPOLL
* [PATCH v3 2/4] io_uring: use io_ring_submit_lock() in io_iopoll_req_issued()
* [PATCH v3 3/4] io_uring: factor out uring_lock helpers
* [PATCH v3 4/4] io_uring: avoid uring_lock for IORING_SETUP_SINGLE_ISSUER

and found the following issues:
* SYZFAIL: failed to recv rpc
* WARNING in io_ring_ctx_wait_and_kill
* WARNING in io_uring_alloc_task_context
* WARNING: suspicious RCU usage in io_eventfd_unregister

Full report is available here:
https://ci.syzbot.org/series/dde98852-0135-44b2-bbef-9ff9d772f924

***

SYZFAIL: failed to recv rpc

tree:      linux-next
URL:       https://kernel.googlesource.com/pub/scm/linux/kernel/git/next/linux-next
base:      92fd6e84175befa1775e5c0ab682938eca27c0b2
arch:      amd64
compiler:  Debian clang version 20.1.8 (++20250708063551+0c9f909b7976-1~exp1~20250708183702.136), Debian LLD 20.1.8
config:    https://ci.syzbot.org/builds/9d67ded7-d9a8-41e3-8b58-51340991cf96/config
C repro:   https://ci.syzbot.org/findings/19ae4090-3486-4e2a-973e-dcb6ec3ba0d1/c_repro
syz repro: https://ci.syzbot.org/findings/19ae4090-3486-4e2a-973e-dcb6ec3ba0d1/syz_repro

SYZFAIL: failed to recv rpc
fd=3 want=4 recv=0 n=0 (errno 9: Bad file descriptor)


***

WARNING in io_ring_ctx_wait_and_kill

tree:      linux-next
URL:       https://kernel.googlesource.com/pub/scm/linux/kernel/git/next/linux-next
base:      92fd6e84175befa1775e5c0ab682938eca27c0b2
arch:      amd64
compiler:  Debian clang version 20.1.8 (++20250708063551+0c9f909b7976-1~exp1~20250708183702.136), Debian LLD 20.1.8
config:    https://ci.syzbot.org/builds/9d67ded7-d9a8-41e3-8b58-51340991cf96/config
C repro:   https://ci.syzbot.org/findings/f5ff9320-bf6f-40b4-a6b3-eee18fa83053/c_repro
syz repro: https://ci.syzbot.org/findings/f5ff9320-bf6f-40b4-a6b3-eee18fa83053/syz_repro

------------[ cut here ]------------
WARNING: io_uring/io_uring.h:266 at io_ring_ctx_lock io_uring/io_uring.h:266 [inline], CPU#0: syz.0.17/5967
WARNING: io_uring/io_uring.h:266 at io_ring_ctx_wait_and_kill+0x35f/0x490 io_uring/io_uring.c:3119, CPU#0: syz.0.17/5967
Modules linked in:
CPU: 0 UID: 0 PID: 5967 Comm: syz.0.17 Not tainted syzkaller #0 PREEMPT(full) 
Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS 1.16.2-debian-1.16.2-1 04/01/2014
RIP: 0010:io_ring_ctx_lock io_uring/io_uring.h:266 [inline]
RIP: 0010:io_ring_ctx_wait_and_kill+0x35f/0x490 io_uring/io_uring.c:3119
Code: 4e 11 48 3b 84 24 20 01 00 00 0f 85 1e 01 00 00 48 8d 65 d8 5b 41 5c 41 5d 41 5e 41 5f 5d c3 cc cc cc cc cc e8 92 fa 96 00 90 <0f> 0b 90 e9 be fd ff ff 48 8d 7c 24 40 ba 70 00 00 00 31 f6 e8 08
RSP: 0018:ffffc90004117b80 EFLAGS: 00010293
RAX: ffffffff812ac5ee RBX: ffff88810d784000 RCX: ffff888104363a80
RDX: 0000000000000000 RSI: 0000000000001000 RDI: 0000000000000000
RBP: ffffc90004117d00 R08: ffffc90004117c7f R09: 0000000000000000
R10: ffffc90004117c40 R11: fffff52000822f90 R12: 1ffff92000822f74
R13: dffffc0000000000 R14: ffffc90004117c70 R15: 0000000000000000
FS:  000055558ddb3500(0000) GS:ffff88818e88a000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 00007f07135e7dac CR3: 00000001728f4000 CR4: 00000000000006f0
Call Trace:
 <TASK>
 io_uring_create+0x6b6/0x940 io_uring/io_uring.c:3738
 io_uring_setup io_uring/io_uring.c:3764 [inline]
 __do_sys_io_uring_setup io_uring/io_uring.c:3798 [inline]
 __se_sys_io_uring_setup+0x235/0x240 io_uring/io_uring.c:3789
 do_syscall_x64 arch/x86/entry/syscall_64.c:63 [inline]
 do_syscall_64+0xfa/0xf80 arch/x86/entry/syscall_64.c:94
 entry_SYSCALL_64_after_hwframe+0x77/0x7f
RIP: 0033:0x7f071338f749
Code: ff ff c3 66 2e 0f 1f 84 00 00 00 00 00 0f 1f 40 00 48 89 f8 48 89 f7 48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 ff ff 73 01 c3 48 c7 c1 a8 ff ff ff f7 d8 64 89 01 48
RSP: 002b:00007fff80b05b58 EFLAGS: 00000246 ORIG_RAX: 00000000000001a9
RAX: ffffffffffffffda RBX: 00007f07135e5fa0 RCX: 00007f071338f749
RDX: 0000000000000000 RSI: 0000200000000040 RDI: 0000000000000024
RBP: 00007f0713413f91 R08: 0000000000000000 R09: 0000000000000000
R10: 0000000000000000 R11: 0000000000000246 R12: 0000000000000000
R13: 00007f07135e5fa0 R14: 00007f07135e5fa0 R15: 0000000000000002
 </TASK>


***

WARNING in io_uring_alloc_task_context

tree:      linux-next
URL:       https://kernel.googlesource.com/pub/scm/linux/kernel/git/next/linux-next
base:      92fd6e84175befa1775e5c0ab682938eca27c0b2
arch:      amd64
compiler:  Debian clang version 20.1.8 (++20250708063551+0c9f909b7976-1~exp1~20250708183702.136), Debian LLD 20.1.8
config:    https://ci.syzbot.org/builds/9d67ded7-d9a8-41e3-8b58-51340991cf96/config
C repro:   https://ci.syzbot.org/findings/7aa56677-dbe1-4fdc-bbc4-cc701c10fa7e/c_repro
syz repro: https://ci.syzbot.org/findings/7aa56677-dbe1-4fdc-bbc4-cc701c10fa7e/syz_repro

------------[ cut here ]------------
WARNING: io_uring/io_uring.h:266 at io_ring_ctx_lock io_uring/io_uring.h:266 [inline], CPU#0: syz.0.17/5982
WARNING: io_uring/io_uring.h:266 at io_init_wq_offload io_uring/tctx.c:23 [inline], CPU#0: syz.0.17/5982
WARNING: io_uring/io_uring.h:266 at io_uring_alloc_task_context+0x677/0x8c0 io_uring/tctx.c:86, CPU#0: syz.0.17/5982
Modules linked in:
CPU: 0 UID: 0 PID: 5982 Comm: syz.0.17 Not tainted syzkaller #0 PREEMPT(full) 
Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS 1.16.2-debian-1.16.2-1 04/01/2014
RIP: 0010:io_ring_ctx_lock io_uring/io_uring.h:266 [inline]
RIP: 0010:io_init_wq_offload io_uring/tctx.c:23 [inline]
RIP: 0010:io_uring_alloc_task_context+0x677/0x8c0 io_uring/tctx.c:86
Code: d8 5b 41 5c 41 5d 41 5e 41 5f 5d c3 cc cc cc cc cc e8 3d ad 96 00 bb f4 ff ff ff eb ab e8 31 ad 96 00 eb 9c e8 2a ad 96 00 90 <0f> 0b 90 e9 12 fb ff ff 4c 8d 64 24 60 4c 8d b4 24 f0 00 00 00 ba
RSP: 0018:ffffc90003dcf9c0 EFLAGS: 00010293
RAX: ffffffff812b1356 RBX: 0000000000000000 RCX: ffff8881777957c0
RDX: 0000000000000000 RSI: 0000000000001000 RDI: 0000000000000000
RBP: ffffc90003dcfb50 R08: ffffffff8f7de377 R09: 1ffffffff1efbc6e
R10: dffffc0000000000 R11: fffffbfff1efbc6f R12: ffff8881052bf000
R13: ffff888104bf2000 R14: 0000000000001000 R15: 1ffff1102097e400
FS:  00005555613bd500(0000) GS:ffff88818e88a000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 00007f7773fe7dac CR3: 000000016cd1c000 CR4: 00000000000006f0
Call Trace:
 <TASK>
 __io_uring_add_tctx_node+0x455/0x710 io_uring/tctx.c:112
 io_uring_create+0x559/0x940 io_uring/io_uring.c:3719
 io_uring_setup io_uring/io_uring.c:3764 [inline]
 __do_sys_io_uring_setup io_uring/io_uring.c:3798 [inline]
 __se_sys_io_uring_setup+0x235/0x240 io_uring/io_uring.c:3789
 do_syscall_x64 arch/x86/entry/syscall_64.c:63 [inline]
 do_syscall_64+0xfa/0xf80 arch/x86/entry/syscall_64.c:94
 entry_SYSCALL_64_after_hwframe+0x77/0x7f
RIP: 0033:0x7f7773d8f749
Code: ff ff c3 66 2e 0f 1f 84 00 00 00 00 00 0f 1f 40 00 48 89 f8 48 89 f7 48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 ff ff 73 01 c3 48 c7 c1 a8 ff ff ff f7 d8 64 89 01 48
RSP: 002b:00007ffe094f0b68 EFLAGS: 00000246 ORIG_RAX: 00000000000001a9
RAX: ffffffffffffffda RBX: 00007f7773fe5fa0 RCX: 00007f7773d8f749
RDX: 0000000000000000 RSI: 0000200000000780 RDI: 0000000000000f08
RBP: 00007f7773e13f91 R08: 0000000000000000 R09: 0000000000000000
R10: 0000000000000000 R11: 0000000000000246 R12: 0000000000000000
R13: 00007f7773fe5fa0 R14: 00007f7773fe5fa0 R15: 0000000000000002
 </TASK>


***

WARNING: suspicious RCU usage in io_eventfd_unregister

tree:      linux-next
URL:       https://kernel.googlesource.com/pub/scm/linux/kernel/git/next/linux-next
base:      92fd6e84175befa1775e5c0ab682938eca27c0b2
arch:      amd64
compiler:  Debian clang version 20.1.8 (++20250708063551+0c9f909b7976-1~exp1~20250708183702.136), Debian LLD 20.1.8
config:    https://ci.syzbot.org/builds/9d67ded7-d9a8-41e3-8b58-51340991cf96/config
C repro:   https://ci.syzbot.org/findings/84c08f15-f4f9-4123-b889-1d8d19f3e0b1/c_repro
syz repro: https://ci.syzbot.org/findings/84c08f15-f4f9-4123-b889-1d8d19f3e0b1/syz_repro

=============================
WARNING: suspicious RCU usage
syzkaller #0 Not tainted
-----------------------------
io_uring/eventfd.c:160 suspicious rcu_dereference_protected() usage!

other info that might help us debug this:


rcu_scheduler_active = 2, debug_locks = 1
2 locks held by kworker/u10:12/3941:
 #0: ffff888168f41148 ((wq_completion)iou_exit){+.+.}-{0:0}, at: process_one_work+0x841/0x15a0 kernel/workqueue.c:3236
 #1: ffffc90021f3fb80 ((work_completion)(&ctx->exit_work)){+.+.}-{0:0}, at: process_one_work+0x868/0x15a0 kernel/workqueue.c:3237

stack backtrace:
CPU: 1 UID: 0 PID: 3941 Comm: kworker/u10:12 Not tainted syzkaller #0 PREEMPT(full) 
Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS 1.16.2-debian-1.16.2-1 04/01/2014
Workqueue: iou_exit io_ring_exit_work
Call Trace:
 <TASK>
 dump_stack_lvl+0x189/0x250 lib/dump_stack.c:120
 lockdep_rcu_suspicious+0x140/0x1d0 kernel/locking/lockdep.c:6876
 io_eventfd_unregister+0x18b/0x1c0 io_uring/eventfd.c:159
 io_ring_ctx_free+0x18a/0x820 io_uring/io_uring.c:2882
 io_ring_exit_work+0xe71/0x1030 io_uring/io_uring.c:3110
 process_one_work+0x93a/0x15a0 kernel/workqueue.c:3261
 process_scheduled_works kernel/workqueue.c:3344 [inline]
 worker_thread+0x9b0/0xee0 kernel/workqueue.c:3425
 kthread+0x711/0x8a0 kernel/kthread.c:463
 ret_from_fork+0x599/0xb30 arch/x86/kernel/process.c:158
 ret_from_fork_asm+0x1a/0x30 arch/x86/entry/entry_64.S:246
 </TASK>


***

If these findings have caused you to resend the series or submit a
separate fix, please add the following tag to your commit message:
  Tested-by: syzbot@syzkaller.appspotmail.com

---
This report is generated by a bot. It may contain errors.
syzbot ci engineers can be reached at syzkaller@googlegroups.com.

The email will later be sent to:
[axboe@kernel.dk csander@purestorage.com io-uring@vger.kernel.org linux-kernel@vger.kernel.org]

If the report looks fine to you, reply with:
#syz upstream

