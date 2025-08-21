Received: from mail-il1-f197.google.com (mail-il1-f197.google.com [209.85.166.197])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 73DC1244670
	for <syzbot@lists.linux.dev>; Thu, 21 Aug 2025 03:03:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.197
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755745394; cv=none; b=uO2WHU25p7Lss/Zwscn92EIx2KBPJWIim4LDKuWCaYf5UNy6d9ETS1sFHHOh68McZaX2Pbyr7VQNSraCD+tgdXIVb6qZwe9c48TMOhXcw1ShYfE701XTYWuwVNKgRwpuzuFSkvdfmmakZ1iJD8F9uZgebonVBqZHKlqo0Whf7gE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755745394; c=relaxed/simple;
	bh=6Z1hqC/d9XS4+JEO4C0WNZ8OveAQ63N2ASonNn7NfeM=;
	h=MIME-Version:Date:Message-ID:Subject:From:To:Cc:Content-Type; b=s+4H5J7EWERCnrt/QClD/CWboxCz60LQw/6SgnOI7uZU2eyay5ZD1tYY6odfrmemNxq3BjiKnhCSNYbCW5wrxJabM4OLdp6tHc+4dBP3nGekbuAjC9kTGMEIRVUZCGBgmRGJAiRrCFD9U5P8+aInLZPNQE1MrEVWZhI+tZvw/pc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com; arc=none smtp.client-ip=209.85.166.197
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com
Received: by mail-il1-f197.google.com with SMTP id e9e14a558f8ab-3e67189ba24so6485195ab.2
        for <syzbot@lists.linux.dev>; Wed, 20 Aug 2025 20:03:12 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1755745391; x=1756350191;
        h=cc:to:from:subject:message-id:date:mime-version:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=aN9FbYmnKvGMMYcjfuoT5C//oXiAZdwqqrfgumS0hX0=;
        b=WE+yJPyS/ZOpKMYkLbzhSgMWkdl3w7FJFACwDF1bebw3+BIy2hcR9PCRydlYRLHvRi
         A6I+Ml9jy4BGuoB6upH4aOLG5rzaGDhz3eUk0y0cx40yPLfRLo8IhuzIeDUx4mqZERFb
         KYQe86AmO+WxqJ82g1EFSCG4DnLHRCGXmfR9aJlEnFzcBEGHakzXyOfD16L9dPoLLRji
         pcZ/J/NuEtuGrDj/3CDlXDSV1tPq3XT2M2oj8sw0x78DwAD+lVy9zU9ssGDBXJSR5bRw
         8ban/jBqSWHYvS3xxtaY8k11Xz41FSYZZJmRexDQFcsYs22yxnb9tmuHXlEqZfJYBlQy
         d1mg==
X-Gm-Message-State: AOJu0Yxi94CNYQXV7C/A/aKEXOSPDvyCIaQne/qroSDHItk9AqOJxsVR
	lhnzB2ShgWcgauCjbjo+FnJ+fum1yx9pjeAmSZgcviPbfd5bPuPTUD1MGxEPlinIeQGLz2nfypB
	vv3UGSMsY9PGBT1ewFxMJDQgur91yB2r5QJErRXV3ZauwT/Jd/76KADT1Ipg=
X-Google-Smtp-Source: AGHT+IHWI+hOp/hp66noDVgNZWxXy2cybo1aMrHtG1lJbLBnkbM0p7nVIlx8lfmcMMTijxc35ENoticP2K5f67FkF8sJHMhDuZyc
Precedence: bulk
X-Mailing-List: syzbot@lists.linux.dev
List-Id: <syzbot.lists.linux.dev>
List-Subscribe: <mailto:syzbot+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:syzbot+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Received: by 2002:a05:6e02:2168:b0:3e5:5af7:7c92 with SMTP id
 e9e14a558f8ab-3e6d6ace8a4mr15368415ab.14.1755745391462; Wed, 20 Aug 2025
 20:03:11 -0700 (PDT)
Date: Wed, 20 Aug 2025 20:03:11 -0700
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <68a68c6f.050a0220.3d78fd.0013.GAE@google.com>
Subject: [moderation/CI] Re: io_uring/kbuf: ensure ring ctx is held locked
 over io_put_kbuf()
From: syzbot ci <syzbot+ci0a9892aadf35c415@syzkaller.appspotmail.com>
To: syzkaller-upstream-moderation@googlegroups.com
Cc: syzbot@lists.linux.dev
Content-Type: text/plain; charset="UTF-8"

syzbot ci has tested the following series

[v1] io_uring/kbuf: ensure ring ctx is held locked over io_put_kbuf()
https://lore.kernel.org/all/e2f14b20-2ad4-4e59-9966-26dd6aa70f31@kernel.dk
* [PATCH] io_uring/kbuf: ensure ring ctx is held locked over io_put_kbuf()

and found the following issue:
possible deadlock in io_req_defer_failed

Full report is available here:
https://ci.syzbot.org/series/fd113bf0-fc76-46b7-8c0b-08fa3c8bda14

***

possible deadlock in io_req_defer_failed

tree:      torvalds
URL:       https://kernel.googlesource.com/pub/scm/linux/kernel/git/torvalds/linux
base:      dfc0f6373094dd88e1eaf76c44f2ff01b65db851
arch:      amd64
compiler:  Debian clang version 20.1.7 (++20250616065708+6146a88f6049-1~exp1~20250616065826.132), Debian LLD 20.1.7
config:    https://ci.syzbot.org/builds/e832762c-b6ee-4bb3-b01f-da0e8f70d1d0/config
C repro:   https://ci.syzbot.org/findings/57691bf2-072c-42f3-8742-80414426104c/c_repro
syz repro: https://ci.syzbot.org/findings/57691bf2-072c-42f3-8742-80414426104c/syz_repro

============================================
WARNING: possible recursive locking detected
syzkaller #0 Not tainted
--------------------------------------------
syz.0.17/6012 is trying to acquire lock:
ffff88802aa620a8 (&ctx->uring_lock){+.+.}-{4:4}, at: io_ring_submit_lock io_uring/io_uring.h:287 [inline]
ffff88802aa620a8 (&ctx->uring_lock){+.+.}-{4:4}, at: io_put_kbuf io_uring/kbuf.h:132 [inline]
ffff88802aa620a8 (&ctx->uring_lock){+.+.}-{4:4}, at: io_req_defer_failed+0x166/0x550 io_uring/io_uring.c:988

but task is already holding lock:
ffff88802aa620a8 (&ctx->uring_lock){+.+.}-{4:4}, at: __do_sys_io_uring_enter io_uring/io_uring.c:3463 [inline]
ffff88802aa620a8 (&ctx->uring_lock){+.+.}-{4:4}, at: __se_sys_io_uring_enter+0x2d4/0x2b20 io_uring/io_uring.c:3398

other info that might help us debug this:
 Possible unsafe locking scenario:

       CPU0
       ----
  lock(&ctx->uring_lock);
  lock(&ctx->uring_lock);

 *** DEADLOCK ***

 May be due to missing lock nesting notation

1 lock held by syz.0.17/6012:
 #0: ffff88802aa620a8 (&ctx->uring_lock){+.+.}-{4:4}, at: __do_sys_io_uring_enter io_uring/io_uring.c:3463 [inline]
 #0: ffff88802aa620a8 (&ctx->uring_lock){+.+.}-{4:4}, at: __se_sys_io_uring_enter+0x2d4/0x2b20 io_uring/io_uring.c:3398

stack backtrace:
CPU: 0 UID: 0 PID: 6012 Comm: syz.0.17 Not tainted syzkaller #0 PREEMPT(full) 
Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS 1.16.2-debian-1.16.2-1 04/01/2014
Call Trace:
 <TASK>
 dump_stack_lvl+0x189/0x250 lib/dump_stack.c:120
 print_deadlock_bug+0x28b/0x2a0 kernel/locking/lockdep.c:3041
 check_deadlock kernel/locking/lockdep.c:3093 [inline]
 validate_chain+0x1a3f/0x2140 kernel/locking/lockdep.c:3895
 __lock_acquire+0xab9/0xd20 kernel/locking/lockdep.c:5237
 lock_acquire+0x120/0x360 kernel/locking/lockdep.c:5868
 __mutex_lock_common kernel/locking/mutex.c:598 [inline]
 __mutex_lock+0x187/0x1360 kernel/locking/mutex.c:760
 io_ring_submit_lock io_uring/io_uring.h:287 [inline]
 io_put_kbuf io_uring/kbuf.h:132 [inline]
 io_req_defer_failed+0x166/0x550 io_uring/io_uring.c:988
 io_queue_sqe io_uring/io_uring.c:2032 [inline]
 io_submit_sqe io_uring/io_uring.c:2284 [inline]
 io_submit_sqes+0xe28/0x1d10 io_uring/io_uring.c:2397
 __do_sys_io_uring_enter io_uring/io_uring.c:3464 [inline]
 __se_sys_io_uring_enter+0x2df/0x2b20 io_uring/io_uring.c:3398
 do_syscall_x64 arch/x86/entry/syscall_64.c:63 [inline]
 do_syscall_64+0xfa/0x3b0 arch/x86/entry/syscall_64.c:94
 entry_SYSCALL_64_after_hwframe+0x77/0x7f
RIP: 0033:0x7f36d418ebe9
Code: ff ff c3 66 2e 0f 1f 84 00 00 00 00 00 0f 1f 40 00 48 89 f8 48 89 f7 48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 ff ff 73 01 c3 48 c7 c1 a8 ff ff ff f7 d8 64 89 01 48
RSP: 002b:00007ffc1d32a978 EFLAGS: 00000246 ORIG_RAX: 00000000000001aa
RAX: ffffffffffffffda RBX: 00007f36d43b5fa0 RCX: 00007f36d418ebe9
RDX: 0000000000000000 RSI: 0000000000003516 RDI: 0000000000000003
RBP: 00007f36d4211e19 R08: 0000000000000000 R09: 0000000000000000
R10: 0000000000000000 R11: 0000000000000246 R12: 0000000000000000
R13: 00007f36d43b5fa0 R14: 00007f36d43b5fa0 R15: 0000000000000006
 </TASK>


***

If these findings have caused you to resend the series or submit a
separate fix, please add the following tag to your commit message:
  Tested-by: syzbot@syzkaller.appspotmail.com

---
This report is generated by a bot. It may contain errors.
syzbot ci engineers can be reached at syzkaller@googlegroups.com.

The email will later be sent to:
[asml.silence@gmail.com axboe@kernel.dk io-uring@vger.kernel.org]

If the report looks fine to you, reply with:
#syz upstream

