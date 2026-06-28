Received: from mail-oi1-f198.google.com (mail-oi1-f198.google.com [209.85.167.198])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 95A89221FCD
	for <syzbot@lists.linux.dev>; Sun, 28 Jun 2026 09:26:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.167.198
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782638812; cv=none; b=GnSBnLKUzR2tDpShnBKm245ippMshXN+Xzp3Dnm3DuNM6w95Po9WX+LHvP9Mg6brjvVa7NpED9bwVpdT57tFkFwQxkBO+AYB2hBqEVwUb9FzAY6jJhvXnid5NCKx/Ac+A6rWKTlZ9HCGrbhBMHsAkEcaSSKZeW8U8Rrc5XGYS9w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782638812; c=relaxed/simple;
	bh=W1Ia2tDxWuI3VYnFz383GzOyLPN8ZQrRhoHSv3+mC+k=;
	h=MIME-Version:Date:Message-ID:Subject:From:To:Cc:Content-Type; b=ZJ8HWkrEcx0vY6TbKJseOrcotQtToaNtn4gKEcT8dhos3J/4Jsh7PqGVeXBpHCO0W32Bc+bYaSN0t/OiY3OitVN0zLmMM48uPDly83qz8T9OZFT7JLm2ELjMfeDF7Usi/JD3w3EsvUKn30IHeETtxGjwMZgwNBlSzAjNqwPdgb4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com; arc=none smtp.client-ip=209.85.167.198
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com
Received: by mail-oi1-f198.google.com with SMTP id 5614622812f47-49001defc4dso4495590b6e.3
        for <syzbot@lists.linux.dev>; Sun, 28 Jun 2026 02:26:50 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1782638809; x=1783243609;
        h=cc:to:from:subject:message-id:date:mime-version:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=eLbdCS73p6OW+42MWlMPif98s745fTL3soD0umE23d8=;
        b=BRLwmSJKjrTdp3rU9wJqFEOwpNlCB1Hg06aMZjtvQD1QwjuultWdyOWZM23fvWiIkv
         upI8JzE14YMdCEUeCuCwVpXDPKBCy0BTIeuHTt5TX1SXuA1okFvRIpCOrjO8OuBMmjH0
         thSbaCJZ+ziiKWhus2Q/h8WJqC923GvKI6sFiieo0B5Rvh18nh4st6bUf4xgS5xmXHcg
         5SGM3ltWH558fyeH12POzmT6yDh8D1jEDlfIu3wWJiCU9OYxv/TKF+qego+laPQ04O8H
         9eQWzh6IEcd9aoew3eC+H7w6QGkc3XrfSWU+C1XvmKHGgNESy74XXlxqSQcE7Edg4o+/
         xPig==
X-Gm-Message-State: AOJu0Yz+WacaLXu8B0NoKDm69iRoOjUAx/Do9XgH31q9IOPjYntFq8Yu
	opdMDuzYjyWkkpfnGVVaNh6OzBvdY1U0thIDYakOSWUOhZNITLyVYJYiL601w2zZskDfghpzU3a
	w4YeX97i/2Ww/8FWcjD5Fj3MUyupeF9vkhU54pNk4Y+BJuTlll5elUnjHCT0=
Precedence: bulk
X-Mailing-List: syzbot@lists.linux.dev
List-Id: <syzbot.lists.linux.dev>
List-Subscribe: <mailto:syzbot+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:syzbot+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Received: by 2002:a05:6808:c2a8:b0:489:9e32:16f7 with SMTP id
 5614622812f47-49219c28df8mr11057724b6e.39.1782638809609; Sun, 28 Jun 2026
 02:26:49 -0700 (PDT)
Date: Sun, 28 Jun 2026 02:26:49 -0700
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <6a40e8d9.ac7367b4.6675.000e.GAE@google.com>
Subject: [moderation/CI] Re: minix: convert to iomap and add direct I/O
From: syzbot ci <syzbot+ci5c37f430385ce431@syzkaller.appspotmail.com>
To: syzkaller-upstream-moderation@googlegroups.com
Cc: syzbot@lists.linux.dev
Content-Type: text/plain; charset="UTF-8"

syzbot ci has tested the following series

[v2] minix: convert to iomap and add direct I/O
https://lore.kernel.org/all/cover.1782619718.git.jbingham@gmail.com
* [PATCH v2 1/4] minix: add iomap infrastructure
* [PATCH v2 2/4] minix: convert address space operations to iomap
* [PATCH v2 3/4] minix: convert file operations to iomap and add
* [PATCH v2 4/4] minix: fix symlink and truncate for iomap

and found the following issues:
* BUG: sleeping function called from invalid context in bdev_getblk
* BUG: sleeping function called from invalid context in find_get_block_common

Full report is available here:
https://ci.syzbot.org/series/3b663c96-cf07-46e0-9b8d-785fe615029d

***

BUG: sleeping function called from invalid context in bdev_getblk

tree:      torvalds
URL:       https://kernel.googlesource.com/pub/scm/linux/kernel/git/torvalds/linux
base:      780d569e6c4b422290f5cba319eb904b355d64be
arch:      amd64
compiler:  Debian clang version 22.1.6 (++20260514074242+fc4aad7b5db3-1~exp1~20260514074407.73), Debian LLD 22.1.6
config:    https://ci.syzbot.org/builds/61f38821-60a2-4c7c-a39e-27291869d296/config
syz repro: https://ci.syzbot.org/findings/dda4e5c2-7cbc-498a-98ea-83cad3c680e3/syz_repro

         option from the mount to silence this warning.
=======================================================
BUG: sleeping function called from invalid context at ./include/linux/sched/mm.h:323
in_atomic(): 0, irqs_disabled(): 0, non_block: 0, pid: 5865, name: syz.1.18
preempt_count: 0, expected: 0
RCU nest depth: 1, expected: 0
1 lock held by syz.1.18/5865:
 #0: ffffffff8e959c20 (rcu_read_lock){....}-{1:3}, at: rcu_lock_acquire include/linux/rcupdate.h:300 [inline]
 #0: ffffffff8e959c20 (rcu_read_lock){....}-{1:3}, at: rcu_read_lock include/linux/rcupdate.h:840 [inline]
 #0: ffffffff8e959c20 (rcu_read_lock){....}-{1:3}, at: path_init+0x124/0x1330 fs/namei.c:2689
CPU: 1 UID: 0 PID: 5865 Comm: syz.1.18 Not tainted syzkaller #0 PREEMPT(full) 
Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS 1.16.2-debian-1.16.2-1 04/01/2014
Call Trace:
 <TASK>
 dump_stack_lvl+0xe8/0x150 lib/dump_stack.c:120
 __might_resched+0x378/0x4d0 kernel/sched/core.c:9197
 might_alloc include/linux/sched/mm.h:323 [inline]
 bdev_getblk+0xce/0x6e0 fs/buffer.c:1435
 __bread_gfp+0x89/0x380 fs/buffer.c:1493
 sb_bread include/linux/buffer_head.h:348 [inline]
 minix_get_link+0x143/0x340 fs/minix/namei.c:396
 pick_link+0x782/0xfe0 fs/namei.c:2064
 step_into_slowpath+0x58a/0x820 fs/namei.c:2127
 step_into fs/namei.c:2152 [inline]
 open_last_lookups fs/namei.c:4643 [inline]
 path_openat+0x224e/0x3830 fs/namei.c:4856
 do_file_open+0x23e/0x4a0 fs/namei.c:4888
 do_sys_openat2+0x115/0x200 fs/open.c:1368
 do_sys_open fs/open.c:1374 [inline]
 __do_sys_openat fs/open.c:1390 [inline]
 __se_sys_openat fs/open.c:1385 [inline]
 __x64_sys_openat+0x138/0x170 fs/open.c:1385
 do_syscall_x64 arch/x86/entry/syscall_64.c:63 [inline]
 do_syscall_64+0x174/0x580 arch/x86/entry/syscall_64.c:94
 entry_SYSCALL_64_after_hwframe+0x77/0x7f
RIP: 0033:0x7f9618b9ce59
Code: ff c3 66 2e 0f 1f 84 00 00 00 00 00 0f 1f 44 00 00 48 89 f8 48 89 f7 48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 ff ff 73 01 c3 48 c7 c1 e8 ff ff ff f7 d8 64 89 01 48
RSP: 002b:00007f9619a29028 EFLAGS: 00000246 ORIG_RAX: 0000000000000101
RAX: ffffffffffffffda RBX: 00007f9618e15fa0 RCX: 00007f9618b9ce59
RDX: 0000000000105042 RSI: 0000200000000080 RDI: ffffffffffffff9c
RBP: 00007f9618c32e6f R08: 0000000000000000 R09: 0000000000000000
R10: 00000000000001ff R11: 0000000000000246 R12: 0000000000000000
R13: 00007f9618e16038 R14: 00007f9618e15fa0 R15: 00007fffce8916b8
 </TASK>


***

BUG: sleeping function called from invalid context in find_get_block_common

tree:      torvalds
URL:       https://kernel.googlesource.com/pub/scm/linux/kernel/git/torvalds/linux
base:      780d569e6c4b422290f5cba319eb904b355d64be
arch:      amd64
compiler:  Debian clang version 22.1.6 (++20260514074242+fc4aad7b5db3-1~exp1~20260514074407.73), Debian LLD 22.1.6
config:    https://ci.syzbot.org/builds/61f38821-60a2-4c7c-a39e-27291869d296/config
syz repro: https://ci.syzbot.org/findings/2af8da3b-836a-479e-9af0-fef473c2f315/syz_repro

loop2: detected capacity change from 0 to 64
bad symlink on inode 4
BUG: sleeping function called from invalid context at ./include/linux/pagemap.h:1155
in_atomic(): 0, irqs_disabled(): 0, non_block: 0, pid: 5813, name: syz.2.19
preempt_count: 0, expected: 0
RCU nest depth: 1, expected: 0
1 lock held by syz.2.19/5813:
 #0: ffffffff8e959c20 (rcu_read_lock){....}-{1:3}, at: rcu_lock_acquire include/linux/rcupdate.h:300 [inline]
 #0: ffffffff8e959c20 (rcu_read_lock){....}-{1:3}, at: rcu_read_lock include/linux/rcupdate.h:840 [inline]
 #0: ffffffff8e959c20 (rcu_read_lock){....}-{1:3}, at: path_init+0x124/0x1330 fs/namei.c:2689
CPU: 1 UID: 0 PID: 5813 Comm: syz.2.19 Not tainted syzkaller #0 PREEMPT(full) 
Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS 1.16.2-debian-1.16.2-1 04/01/2014
Call Trace:
 <TASK>
 dump_stack_lvl+0xe8/0x150 lib/dump_stack.c:120
 __might_resched+0x378/0x4d0 kernel/sched/core.c:9197
 folio_lock include/linux/pagemap.h:1155 [inline]
 __find_get_block_slow fs/buffer.c:242 [inline]
 find_get_block_common+0x2d0/0xe10 fs/buffer.c:1386
 bdev_getblk+0x58/0x6e0 include/linux/gfp.h:-1
 __bread_gfp+0x89/0x380 fs/buffer.c:1493
 sb_bread include/linux/buffer_head.h:348 [inline]
 minix_get_link+0x143/0x340 fs/minix/namei.c:396
 pick_link+0x782/0xfe0 fs/namei.c:2064
 step_into_slowpath+0x58a/0x820 fs/namei.c:2127
 step_into fs/namei.c:2152 [inline]
 open_last_lookups fs/namei.c:4643 [inline]
 path_openat+0x224e/0x3830 fs/namei.c:4856
 do_file_open+0x23e/0x4a0 fs/namei.c:4888
 do_sys_openat2+0x115/0x200 fs/open.c:1368
 do_sys_open fs/open.c:1374 [inline]
 __do_sys_openat fs/open.c:1390 [inline]
 __se_sys_openat fs/open.c:1385 [inline]
 __x64_sys_openat+0x138/0x170 fs/open.c:1385
 do_syscall_x64 arch/x86/entry/syscall_64.c:63 [inline]
 do_syscall_64+0x174/0x580 arch/x86/entry/syscall_64.c:94
 entry_SYSCALL_64_after_hwframe+0x77/0x7f
RIP: 0033:0x7fd37ef9ce59
Code: ff c3 66 2e 0f 1f 84 00 00 00 00 00 0f 1f 44 00 00 48 89 f8 48 89 f7 48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 ff ff 73 01 c3 48 c7 c1 e8 ff ff ff f7 d8 64 89 01 48
RSP: 002b:00007fd37fe06028 EFLAGS: 00000246 ORIG_RAX: 0000000000000101
RAX: ffffffffffffffda RBX: 00007fd37f215fa0 RCX: 00007fd37ef9ce59
RDX: 0000000000000042 RSI: 0000200000000080 RDI: ffffffffffffff9c
RBP: 00007fd37f032e6f R08: 0000000000000000 R09: 0000000000000000
R10: 0000000000000000 R11: 0000000000000246 R12: 0000000000000000
R13: 00007fd37f216038 R14: 00007fd37f215fa0 R15: 00007ffe5e5f14f8
 </TASK>
bad symlink on inode 4


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
[brauner@kernel.org hch@infradead.org jack@suse.cz jbingham@gmail.com jkoolstra@xs4all.nl linux-fsdevel@vger.kernel.org linux-kernel@vger.kernel.org syzkaller@googlegroups.com viro@zeniv.linux.org.uk]

If the report looks fine to you, reply with:
#syz upstream

If the report is a false positive, reply with
#syz invalid

