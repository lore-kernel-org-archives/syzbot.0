Received: from mail-oo1-f70.google.com (mail-oo1-f70.google.com [209.85.161.70])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3F45C3CA487
	for <syzbot@lists.linux.dev>; Tue, 31 Mar 2026 07:42:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.161.70
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774942925; cv=none; b=LEbBzRKg28uJ7Zh+V0guu8DotE1neiFN+U72scJmJUDvWbUFLBTyyWsZtioPID9gGV0a8Y5UR+ZJkF2434WGQfmCAKBDfHRRqIP6ta3Mo2UMRiLxaiFLyjfRyp32Q7tMsBErmRa5hdmMPLrf7FzqzwmS/DeDXGbT89fNZ/Ti5ow=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774942925; c=relaxed/simple;
	bh=QxX9XgfvAe6dp0m1tRhM75D43XqZvdSeYzRnWNsg+xs=;
	h=MIME-Version:Date:In-Reply-To:Message-ID:Subject:From:To:Cc:
	 Content-Type; b=b2M4Cqku3pKIsqsLpjOtH6BFs8Fvsy5i61hS9Yu0+xor8TXFiszc2pQ2jt7O3tmn9ss0G2KLmTK19OnhYFGFcRkbkCs5koKfkj47sgSca9gqFEYlsotDu5MibLil+p1VCo+TmD067ob7VpIW2ImhaTNkiqSOpvzfyNF58moa2Ew=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com; arc=none smtp.client-ip=209.85.161.70
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com
Received: by mail-oo1-f70.google.com with SMTP id 006d021491bc7-67deade993dso20437911eaf.3
        for <syzbot@lists.linux.dev>; Tue, 31 Mar 2026 00:42:04 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1774942923; x=1775547723;
        h=cc:to:from:subject:message-id:in-reply-to:date:mime-version
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=kW/SphJaHT/+6fQIuBd3Wr/1eFRaQ4h0O20BveCN4m4=;
        b=Ybxu9+YQ2rsTYyr3nUfISLM6fnvr4oSxQ8s3/jw2oOhmACQZnCUsrk+kf3PJkEd8T3
         074Uc2yEx3hK1KeSGNi50h43vZ2kzJbW9YSlyW489Ac7p5XG26AfJv9nIMZkzIrM4EWl
         nEhuBJjGbB0zNALUZWgqU0QYHjYmOSMR0nDnJiEZuoiaXzVapssT9zCEBDAa3Yu9iLA0
         fkjflvEoJ/GvobkUIQB30MzGSKQUTgIwt6a8ZWFMV8CsWDUZB6Y4WAlfw269Nr33WFnG
         D2YAKMxLMmbxrEjzws1t0ZbTTutja5OZHcAvIAbCrWElBXMeYQUToHX2Ml6eMu7J91qr
         W/Kw==
X-Gm-Message-State: AOJu0YyZinaehD1o+J8ufzSxTUOpCTyRJwm+pzHykWaAvEEA3IDSc5PP
	VD/V1fN7fjAMDZ2PdegSsBJ0CwgzydNB6C7M1Pkh3xvHd882JXpzU3HijRC0qdRzNI9UetXxs7z
	QhfWpS2/on+sCkrZpjfZGs33caK7NxUHYfM6GQdqsVbobHt5dvmx0mTPIwWY=
Precedence: bulk
X-Mailing-List: syzbot@lists.linux.dev
List-Id: <syzbot.lists.linux.dev>
List-Subscribe: <mailto:syzbot+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:syzbot+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Received: by 2002:a05:6820:629:b0:67e:15c2:9d85 with SMTP id
 006d021491bc7-67e186330f1mr8627582eaf.21.1774942923216; Tue, 31 Mar 2026
 00:42:03 -0700 (PDT)
Date: Tue, 31 Mar 2026 00:42:03 -0700
In-Reply-To: <20260330175824.2777270-1-urezki@gmail.com>
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <69cb7acb.050a0220.183828.0025.GAE@google.com>
Subject: [syzbot ci] Re: mm/vmalloc: Use dedicated unbound workqueue for vmap purge/drain
From: syzbot ci <syzbot+ci3c65cfe4c9a15aea@syzkaller.appspotmail.com>
To: akpm@linux-foundation.org, bhe@redhat.com, linux-kernel@vger.kernel.org, 
	linux-mm@kvack.org, lirongqing@baidu.com, urezki@gmail.com
Cc: syzbot@lists.linux.dev, syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"

syzbot ci has tested the following series

[v2] mm/vmalloc: Use dedicated unbound workqueue for vmap purge/drain
https://lore.kernel.org/all/20260330175824.2777270-1-urezki@gmail.com
* [PATCH v2] mm/vmalloc: Use dedicated unbound workqueue for vmap purge/drain

and found the following issue:
possible deadlock in touch_wq_lockdep_map

Full report is available here:
https://ci.syzbot.org/series/4a8f638e-3a3f-4346-8189-2b5a0eb9ceaf

***

possible deadlock in touch_wq_lockdep_map

tree:      mm-new
URL:       https://kernel.googlesource.com/pub/scm/linux/kernel/git/akpm/mm.git
base:      af42d6d3650b95295a3f08fc35189998bc26c2e1
arch:      amd64
compiler:  Debian clang version 21.1.8 (++20251221033036+2078da43e25a-1~exp1~20251221153213.50), Debian LLD 21.1.8
config:    https://ci.syzbot.org/builds/d94b1f61-6a69-4415-b385-b3c99018e8c2/config
syz repro: https://ci.syzbot.org/findings/01e4d436-e924-4ce6-8902-78c6000bf34e/syz_repro

============================================
WARNING: possible recursive locking detected
syzkaller #0 Not tainted
--------------------------------------------
kworker/u9:1/33 is trying to acquire lock:
ffff88810168e948 ((wq_completion)vmap_drain){+.+.}-{0:0}, at: touch_wq_lockdep_map+0xb5/0x180 kernel/workqueue.c:3991

but task is already holding lock:
ffff88810168e948 ((wq_completion)vmap_drain){+.+.}-{0:0}, at: process_one_work kernel/workqueue.c:3251 [inline]
ffff88810168e948 ((wq_completion)vmap_drain){+.+.}-{0:0}, at: process_scheduled_works+0xa52/0x18c0 kernel/workqueue.c:3359

other info that might help us debug this:
 Possible unsafe locking scenario:

       CPU0
       ----
  lock((wq_completion)vmap_drain);
  lock((wq_completion)vmap_drain);

 *** DEADLOCK ***

 May be due to missing lock nesting notation

4 locks held by kworker/u9:1/33:
 #0: ffff88810168e948 ((wq_completion)vmap_drain){+.+.}-{0:0}, at: process_one_work kernel/workqueue.c:3251 [inline]
 #0: ffff88810168e948 ((wq_completion)vmap_drain){+.+.}-{0:0}, at: process_scheduled_works+0xa52/0x18c0 kernel/workqueue.c:3359
 #1: ffffc90000a97c40 (drain_vmap_work){+.+.}-{0:0}, at: process_one_work kernel/workqueue.c:3252 [inline]
 #1: ffffc90000a97c40 (drain_vmap_work){+.+.}-{0:0}, at: process_scheduled_works+0xa8d/0x18c0 kernel/workqueue.c:3359
 #2: ffffffff8e87ed68 (vmap_purge_lock){+.+.}-{4:4}, at: drain_vmap_area_work+0x17/0x40 mm/vmalloc.c:2443
 #3: ffffffff8e75e5e0 (rcu_read_lock){....}-{1:3}, at: rcu_lock_acquire include/linux/rcupdate.h:312 [inline]
 #3: ffffffff8e75e5e0 (rcu_read_lock){....}-{1:3}, at: rcu_read_lock include/linux/rcupdate.h:850 [inline]
 #3: ffffffff8e75e5e0 (rcu_read_lock){....}-{1:3}, at: start_flush_work kernel/workqueue.c:4234 [inline]
 #3: ffffffff8e75e5e0 (rcu_read_lock){....}-{1:3}, at: __flush_work+0x100/0xc50 kernel/workqueue.c:4292

stack backtrace:
CPU: 1 UID: 0 PID: 33 Comm: kworker/u9:1 Not tainted syzkaller #0 PREEMPT(full) 
Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS 1.16.2-debian-1.16.2-1 04/01/2014
Workqueue: vmap_drain drain_vmap_area_work
Call Trace:
 <TASK>
 dump_stack_lvl+0xe8/0x150 lib/dump_stack.c:120
 print_deadlock_bug+0x279/0x290 kernel/locking/lockdep.c:3041
 check_deadlock kernel/locking/lockdep.c:3093 [inline]
 validate_chain kernel/locking/lockdep.c:3895 [inline]
 __lock_acquire+0x253f/0x2cf0 kernel/locking/lockdep.c:5237
 lock_acquire+0xf0/0x2e0 kernel/locking/lockdep.c:5868
 touch_wq_lockdep_map+0xcb/0x180 kernel/workqueue.c:3991
 start_flush_work kernel/workqueue.c:4272 [inline]
 __flush_work+0x87c/0xc50 kernel/workqueue.c:4292
 __purge_vmap_area_lazy+0x7db/0xab0 mm/vmalloc.c:2419
 drain_vmap_area_work+0x27/0x40 mm/vmalloc.c:2444
 process_one_work kernel/workqueue.c:3276 [inline]
 process_scheduled_works+0xb6e/0x18c0 kernel/workqueue.c:3359
 worker_thread+0xa53/0xfc0 kernel/workqueue.c:3440
 kthread+0x388/0x470 kernel/kthread.c:436
 ret_from_fork+0x51e/0xb90 arch/x86/kernel/process.c:158
 ret_from_fork_asm+0x1a/0x30 arch/x86/entry/entry_64.S:245
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
