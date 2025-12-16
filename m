Received: from mail-oi1-f199.google.com (mail-oi1-f199.google.com [209.85.167.199])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7A7DB330653
	for <syzbot@lists.linux.dev>; Tue, 16 Dec 2025 13:27:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.167.199
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765891642; cv=none; b=cNZe6ZYDY9biZ5iNWjZbhhA7NCaEeHIPuiZf9skDElXpjPMrxOD0d22q1MDwA/nhUANt48OVaSmrSBUT1CTnZ15SyN7zpdfgLTYSVd1ejEwRMg+pqLgDEuDMt1866BSHWWqkx7MHserxjbAygY9CUvlmqXKeENHU1PaZmJaB2Gc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765891642; c=relaxed/simple;
	bh=Ktfjgc/L8Ak4Fn42C5MHFy2hQHIgeJeDgnfRsm/0rmI=;
	h=MIME-Version:Date:In-Reply-To:Message-ID:Subject:From:To:Cc:
	 Content-Type; b=VzS3FiEmQlTxw8E655txbxMZCAp7u+EQZb/5YKOApnBhYo2+/3Gh2VuqHg3Py+ndSHl71chO4G8SZS1ryYkF+rzSsWGsocPtC+Fy9YvC+8HNjxRT/DhClFTVJrPPOKoLYSe3avVRlWOOjsrIRYlJB83xbE0c1eoILel/8N7Apks=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com; arc=none smtp.client-ip=209.85.167.199
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com
Received: by mail-oi1-f199.google.com with SMTP id 5614622812f47-4538a8bc513so7902489b6e.2
        for <syzbot@lists.linux.dev>; Tue, 16 Dec 2025 05:27:20 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1765891639; x=1766496439;
        h=cc:to:from:subject:message-id:in-reply-to:date:mime-version
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=hYjRJJ506ddvMksrKA9PPxHuYdIJ/nrBSLgKkw4pfW8=;
        b=FFIJG6H0XxnlRpE1/9m/3GH69v6ezmze2BzcaW7ZW71gAigOZ88j1BgRs4tAGCM9Hg
         ncENGdaSIxpEf9in946C15F/p8L+rKqBl8gYIoLBq5xZ3qHi+sFw/1Ztp2eTzRn92vF+
         xn+JNtcQKA8UJdS49XSZvnUA392DklTtl6wPWqOq+gJvrxpFgtPzrLlbBs5lUcgDilEi
         ADu0kd623tfsjeUeZIjB+EJcSnqj18zYJ0mtrcDcZ2O5a1Eqcx2lCnNCv7AeuVKlYjRH
         9Y4myfUpx6CkevKDzyNSwQpXGeQvEmL/VMjEnQ8eV6Orbxsb6+ARWVeEtEIWIJ6G4bb6
         rDAA==
X-Gm-Message-State: AOJu0YwSoEZRjBKwdd3Uxp4aSTCNeLdNy8jHU1rXgdeS5QHP3PYirImC
	i6Cj4FpofgYzg8GR8BQw28rU7c1Pmq+g+GcyN24PRE8Kywu8FQ8dp63eOr7cT+CQLxBsGmholqW
	CV9Mdo2Qi6Dm7xNWfkbyWwq5f3XTWBACzbAPH8g4J9s5KdU+fmMFo9UUBJ4A=
X-Google-Smtp-Source: AGHT+IGVYKQeVf2Px4ZQSbykhTj6MuQM6T464vSt503ztlv8bUnmvZ6VNHvqaaoFAgpsTdU5EBMo1FemPHrfipq7VLzs2egYbmG8
Precedence: bulk
X-Mailing-List: syzbot@lists.linux.dev
List-Id: <syzbot.lists.linux.dev>
List-Subscribe: <mailto:syzbot+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:syzbot+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Received: by 2002:a05:6808:14c8:b0:441:ca0e:f5ab with SMTP id
 5614622812f47-455ac9d900dmr6412826b6e.65.1765891639491; Tue, 16 Dec 2025
 05:27:19 -0800 (PST)
Date: Tue, 16 Dec 2025 05:27:19 -0800
In-Reply-To: <tencent_2AC2ECAACC587B4E6C342D096F909424E90A@qq.com>
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <69415e37.050a0220.1ff09b.001d.GAE@google.com>
Subject: [syzbot ci] Re: jfs: Extend the done of the window period
From: syzbot ci <syzbot+ci1f1a4e9c887bc6ea@syzkaller.appspotmail.com>
To: axboe@kernel.dk, eadavis@qq.com, jfs-discussion@lists.sourceforge.net, 
	linux-block@vger.kernel.org, linux-kernel@vger.kernel.org, shaggy@kernel.org, 
	syzbot@syzkaller.appspotmail.com, syzkaller-bugs@googlegroups.com
Cc: syzbot@lists.linux.dev, syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"

syzbot ci has tested the following series

[v1] jfs: Extend the done of the window period
https://lore.kernel.org/all/tencent_2AC2ECAACC587B4E6C342D096F909424E90A@qq.com
* [PATCH] jfs: Extend the done of the window period

and found the following issue:
possible deadlock in lbmIODone

Full report is available here:
https://ci.syzbot.org/series/49387e77-608d-493c-9978-8d1e9ab79507

***

possible deadlock in lbmIODone

tree:      torvalds
URL:       https://kernel.googlesource.com/pub/scm/linux/kernel/git/torvalds/linux
base:      d358e5254674b70f34c847715ca509e46eb81e6f
arch:      amd64
compiler:  Debian clang version 20.1.8 (++20250708063551+0c9f909b7976-1~exp1~20250708183702.136), Debian LLD 20.1.8
config:    https://ci.syzbot.org/builds/802e00bf-1926-4ea9-a853-4f01d10a4a6e/config
C repro:   https://ci.syzbot.org/findings/784b824b-3582-4c98-a807-ff28792ecaac/c_repro
syz repro: https://ci.syzbot.org/findings/784b824b-3582-4c98-a807-ff28792ecaac/syz_repro

======================================================
WARNING: possible circular locking dependency detected
syzkaller #0 Not tainted
------------------------------------------------------
ksoftirqd/0/15 is trying to acquire lock:
ffff888112c1f9e8 (&(log)->gclock){..-.}-{3:3}, at: lmPostGC fs/jfs/jfs_logmgr.c:810 [inline]
ffff888112c1f9e8 (&(log)->gclock){..-.}-{3:3}, at: lbmIODone+0x681/0x17b0 fs/jfs/jfs_logmgr.c:2284

but task is already holding lock:
ffffffff8e396158 (jfsLCacheLock){..-.}-{3:3}, at: lbmIODone+0x92/0x17b0 fs/jfs/jfs_logmgr.c:2181

which lock already depends on the new lock.


the existing dependency chain (in reverse order) is:

-> #1 (jfsLCacheLock){..-.}-{3:3}:
       __raw_spin_lock_irqsave include/linux/spinlock_api_smp.h:110 [inline]
       _raw_spin_lock_irqsave+0xa7/0xf0 kernel/locking/spinlock.c:162
       lbmWrite+0x115/0x490 fs/jfs/jfs_logmgr.c:2022
       lmGCwrite fs/jfs/jfs_logmgr.c:-1 [inline]
       lmGroupCommit+0x570/0xb30 fs/jfs/jfs_logmgr.c:687
       txCommit+0x4940/0x5430 fs/jfs/jfs_txnmgr.c:1305
       diNewIAG fs/jfs/jfs_imap.c:2592 [inline]
       diAllocExt fs/jfs/jfs_imap.c:1905 [inline]
       diAllocAG+0x1770/0x1df0 fs/jfs/jfs_imap.c:1669
       diAlloc+0x1d5/0x1680 fs/jfs/jfs_imap.c:1590
       ialloc+0x8c/0x8f0 fs/jfs/jfs_inode.c:56
       jfs_mkdir+0x193/0xa70 fs/jfs/namei.c:225
       vfs_mkdir+0x512/0x5b0 fs/namei.c:5130
       do_mkdirat+0x276/0x4b0 fs/namei.c:5164
       __do_sys_mkdirat fs/namei.c:5186 [inline]
       __se_sys_mkdirat fs/namei.c:5184 [inline]
       __x64_sys_mkdirat+0x87/0xa0 fs/namei.c:5184
       do_syscall_x64 arch/x86/entry/syscall_64.c:63 [inline]
       do_syscall_64+0xfa/0xf80 arch/x86/entry/syscall_64.c:94
       entry_SYSCALL_64_after_hwframe+0x77/0x7f

-> #0 (&(log)->gclock){..-.}-{3:3}:
       check_prev_add kernel/locking/lockdep.c:3165 [inline]
       check_prevs_add kernel/locking/lockdep.c:3284 [inline]
       validate_chain kernel/locking/lockdep.c:3908 [inline]
       __lock_acquire+0x15a6/0x2cf0 kernel/locking/lockdep.c:5237
       lock_acquire+0x117/0x340 kernel/locking/lockdep.c:5868
       __raw_spin_lock_irqsave include/linux/spinlock_api_smp.h:110 [inline]
       _raw_spin_lock_irqsave+0xa7/0xf0 kernel/locking/spinlock.c:162
       lmPostGC fs/jfs/jfs_logmgr.c:810 [inline]
       lbmIODone+0x681/0x17b0 fs/jfs/jfs_logmgr.c:2284
       blk_update_request+0x57e/0xe60 block/blk-mq.c:1007
       blk_mq_end_request+0x3e/0x70 block/blk-mq.c:1169
       blk_complete_reqs block/blk-mq.c:1244 [inline]
       blk_done_softirq+0x10a/0x160 block/blk-mq.c:1249
       handle_softirqs+0x27d/0x850 kernel/softirq.c:622
       run_ksoftirqd+0x9b/0x100 kernel/softirq.c:1063
       smpboot_thread_fn+0x542/0xa60 kernel/smpboot.c:160
       kthread+0x711/0x8a0 kernel/kthread.c:463
       ret_from_fork+0x599/0xb30 arch/x86/kernel/process.c:158
       ret_from_fork_asm+0x1a/0x30 arch/x86/entry/entry_64.S:246

other info that might help us debug this:

 Possible unsafe locking scenario:

       CPU0                    CPU1
       ----                    ----
  lock(jfsLCacheLock);
                               lock(&(log)->gclock);
                               lock(jfsLCacheLock);
  lock(&(log)->gclock);

 *** DEADLOCK ***

1 lock held by ksoftirqd/0/15:
 #0: ffffffff8e396158 (jfsLCacheLock){..-.}-{3:3}, at: lbmIODone+0x92/0x17b0 fs/jfs/jfs_logmgr.c:2181

stack backtrace:
CPU: 0 UID: 0 PID: 15 Comm: ksoftirqd/0 Not tainted syzkaller #0 PREEMPT(full) 
Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS 1.16.2-debian-1.16.2-1 04/01/2014
Call Trace:
 <TASK>
 dump_stack_lvl+0x189/0x250 lib/dump_stack.c:120
 print_circular_bug+0x2e2/0x300 kernel/locking/lockdep.c:2043
 check_noncircular+0x12e/0x150 kernel/locking/lockdep.c:2175
 check_prev_add kernel/locking/lockdep.c:3165 [inline]
 check_prevs_add kernel/locking/lockdep.c:3284 [inline]
 validate_chain kernel/locking/lockdep.c:3908 [inline]
 __lock_acquire+0x15a6/0x2cf0 kernel/locking/lockdep.c:5237
 lock_acquire+0x117/0x340 kernel/locking/lockdep.c:5868
 __raw_spin_lock_irqsave include/linux/spinlock_api_smp.h:110 [inline]
 _raw_spin_lock_irqsave+0xa7/0xf0 kernel/locking/spinlock.c:162
 lmPostGC fs/jfs/jfs_logmgr.c:810 [inline]
 lbmIODone+0x681/0x17b0 fs/jfs/jfs_logmgr.c:2284
 blk_update_request+0x57e/0xe60 block/blk-mq.c:1007
 blk_mq_end_request+0x3e/0x70 block/blk-mq.c:1169
 blk_complete_reqs block/blk-mq.c:1244 [inline]
 blk_done_softirq+0x10a/0x160 block/blk-mq.c:1249
 handle_softirqs+0x27d/0x850 kernel/softirq.c:622
 run_ksoftirqd+0x9b/0x100 kernel/softirq.c:1063
 smpboot_thread_fn+0x542/0xa60 kernel/smpboot.c:160
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
