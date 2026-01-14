Received: from mail-oi1-f197.google.com (mail-oi1-f197.google.com [209.85.167.197])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BEB11361DC1
	for <syzbot@lists.linux.dev>; Wed, 14 Jan 2026 07:31:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.167.197
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768375907; cv=none; b=TFg2NKurUxgo7B+PO9ZuOMdIkrqL3KLoZH9vHrFqayJk073yNgPl9Xdma0W33KqpgBerohQ1GxS4Y74Mj9spEUM6pZ3fNlV9rQIz6Z43XAp7TPTZxxKFTe2gPbLr+6k7Eqx20jRGCPuZ8k65owQUBhY0H/e6wmbkXYEbQKd4UQg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768375907; c=relaxed/simple;
	bh=lBysEZkNcDD3bWD2Gt8dIVH7XbGQAnYpr9e2ZuLoAfY=;
	h=MIME-Version:Date:Message-ID:Subject:From:To:Cc:Content-Type; b=qCi2zBdCPFGA0MoRacWDgKFM5DWfu+O7dp2LKPySlE5hy5/zTME8OZgXVpGp1/SkDnZv8PLkPhM0UCwqdetyf5u9eTIBBKmXibTqlt3JDiKNtfxitaI08x2FZmKtbV8xqLqRDYSRFrthwOqKLXJPbR8USQfUNnZa5N8wSYKo+2I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com; arc=none smtp.client-ip=209.85.167.197
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com
Received: by mail-oi1-f197.google.com with SMTP id 5614622812f47-45a5531f3f1so18245682b6e.3
        for <syzbot@lists.linux.dev>; Tue, 13 Jan 2026 23:31:40 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1768375898; x=1768980698;
        h=content-transfer-encoding:cc:to:from:subject:message-id:date
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=e11nNI9GbXFHVmVGF7gBnXhIPce3gAoAmEHHj/xThT8=;
        b=j3OvnnhVh3asjj6zxanqE69yf6qduE4UNacZ/hkhcBGX2qNzymGP9oOrPLTGo2Oij0
         I0PMhjGnduUDW3itnoitc2iKQ9t3sROVyhI10Hdf0cPAH8RgkCW1vVqK2fAzmEGM+mN6
         cFKT4zPTs0lEptUOKqcxlAWoFA5KQQiFMxgdGckmho8YrWnvj2hGQSZgOWXd2c4SmPjt
         +veF/1+uviIzkCYvl8ISIJ0X5sL2pHtTzSyDF2sDLreecdGNLQFCHqYOxy60h1Eaoplp
         rOYRT8voM4Q4yZDAI3ugyilXFtWrW7nWThFEKnWfzK/1Uu6JpnEUqaZnh9Ee7BoFa6cA
         D+bQ==
X-Gm-Message-State: AOJu0YxKthjvXVs3bsjCS9MhaaQabkTFCJqBG6db1xdD+UF5jLYBMxzz
	ADoxMthFkz7kZsppT8K+hcGWZ+1Wgqbk51J2wr3P91HPM56Cj/R9AbalW3PmnqEKZQ82/rZ6ezr
	A+R4wUd8ucsOlxzMI6QjQUpnLn9g4iDrL2q6X8vGwq7gjlgjs5lU4EihgdpA=
Precedence: bulk
X-Mailing-List: syzbot@lists.linux.dev
List-Id: <syzbot.lists.linux.dev>
List-Subscribe: <mailto:syzbot+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:syzbot+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Received: by 2002:a05:6808:6617:b0:44f:e801:d6d6 with SMTP id
 5614622812f47-45c71463e0fmr1139009b6e.6.1768375898446; Tue, 13 Jan 2026
 23:31:38 -0800 (PST)
Date: Tue, 13 Jan 2026 23:31:38 -0800
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <6967465a.a70a0220.1aa68e.0002.GAE@google.com>
Subject: [moderation/CI] Re: mm/madvise: prefer VMA lock for MADV_REMOVE
From: syzbot ci <syzbot+cid2fa2eca41a143c2@syzkaller.appspotmail.com>
To: syzkaller-upstream-moderation@googlegroups.com
Cc: syzbot@lists.linux.dev
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

syzbot ci has tested the following series

[v1] mm/madvise: prefer VMA lock for MADV_REMOVE
https://lore.kernel.org/all/202601141124178748cM66DJW2fzNea7Uym1mG@zte.com.=
cn
* [PATCH linux-next] mm/madvise: prefer VMA lock for MADV_REMOVE

and found the following issue:
possible deadlock in blkdev_fallocate

Full report is available here:
https://ci.syzbot.org/series/30acb9df-ca55-4cbf-81ed-89b84da8edc1

***

possible deadlock in blkdev_fallocate

tree:      linux-next
URL:       https://kernel.googlesource.com/pub/scm/linux/kernel/git/next/li=
nux-next
base:      4c81c9dc03a068745eeb56984ea9836d86fa3eb2
arch:      amd64
compiler:  Debian clang version 21.1.8 (++20251221033036+2078da43e25a-1~exp=
1~20251221153213.50), Debian LLD 21.1.8
config:    https://ci.syzbot.org/builds/eaa5a44b-5d87-4428-b098-72b46efdb98=
3/config
C repro:   https://ci.syzbot.org/findings/e3240f02-6d2c-4c6d-bc6e-e7f4be22e=
433/c_repro
syz repro: https://ci.syzbot.org/findings/e3240f02-6d2c-4c6d-bc6e-e7f4be22e=
433/syz_repro

=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D
WARNING: possible circular locking dependency detected
syzkaller #0 Not tainted
------------------------------------------------------
syz.0.17/5976 is trying to acquire lock:
ffff888167a287a8 (&sb->s_type->i_mutex_key#10){++++}-{4:4}, at: inode_lock =
include/linux/fs.h:1027 [inline]
ffff888167a287a8 (&sb->s_type->i_mutex_key#10){++++}-{4:4}, at: blkdev_fall=
ocate+0x260/0x530 block/fops.c:908

but task is already holding lock:
ffff8881043c3b88 (vm_lock){++++}-{0:0}, at: lock_vma_under_rcu+0x1d1/0x500 =
mm/mmap_lock.c:259

which lock already depends on the new lock.


the existing dependency chain (in reverse order) is:

-> #2 (vm_lock){++++}-{0:0}:
       __vma_enter_locked+0x243/0x710 mm/mmap_lock.c:72
       __vma_start_write+0x23/0x140 mm/mmap_lock.c:104
       vma_start_write include/linux/mmap_lock.h:213 [inline]
       mprotect_fixup+0x5e1/0xa50 mm/mprotect.c:768
       setup_arg_pages+0x565/0xae0 fs/exec.c:670
       load_elf_binary+0xc5e/0x2980 fs/binfmt_elf.c:1028
       search_binary_handler fs/exec.c:1669 [inline]
       exec_binprm fs/exec.c:1701 [inline]
       bprm_execve+0x93d/0x1410 fs/exec.c:1753
       kernel_execve+0x8ef/0x9e0 fs/exec.c:1919
       try_to_run_init_process+0x13/0x60 init/main.c:1506
       kernel_init+0xad/0x1d0 init/main.c:1634
       ret_from_fork+0x51b/0xa40 arch/x86/kernel/process.c:158
       ret_from_fork_asm+0x1a/0x30 arch/x86/entry/entry_64.S:246

-> #1 (&mm->mmap_lock){++++}-{4:4}:
       __might_fault+0xcb/0x130 mm/memory.c:7174
       _copy_to_iter+0xf9/0x17d0 lib/iov_iter.c:196
       copy_page_to_iter+0x10c/0x1c0 lib/iov_iter.c:374
       copy_folio_to_iter include/linux/uio.h:204 [inline]
       filemap_read+0x811/0x1230 mm/filemap.c:2851
       blkdev_read_iter+0x30a/0x440 block/fops.c:856
       new_sync_read fs/read_write.c:491 [inline]
       vfs_read+0x582/0xa70 fs/read_write.c:572
       ksys_read+0x150/0x270 fs/read_write.c:715
       do_syscall_x64 arch/x86/entry/syscall_64.c:63 [inline]
       do_syscall_64+0xe2/0xf80 arch/x86/entry/syscall_64.c:94
       entry_SYSCALL_64_after_hwframe+0x77/0x7f

-> #0 (&sb->s_type->i_mutex_key#10){++++}-{4:4}:
       check_prev_add kernel/locking/lockdep.c:3165 [inline]
       check_prevs_add kernel/locking/lockdep.c:3284 [inline]
       validate_chain kernel/locking/lockdep.c:3908 [inline]
       __lock_acquire+0x15a5/0x2cf0 kernel/locking/lockdep.c:5237
       lock_acquire+0x106/0x330 kernel/locking/lockdep.c:5868
       down_write+0x96/0x200 kernel/locking/rwsem.c:1590
       inode_lock include/linux/fs.h:1027 [inline]
       blkdev_fallocate+0x260/0x530 block/fops.c:908
       vfs_fallocate+0x669/0x7e0 fs/open.c:339
       madvise_remove mm/madvise.c:1055 [inline]
       madvise_vma_behavior+0x120d/0x4460 mm/madvise.c:1379
       madvise_walk_vmas+0x90e/0xaf0 mm/madvise.c:1706
       madvise_do_behavior+0x386/0x540 mm/madvise.c:1956
       do_madvise+0x1fa/0x2e0 mm/madvise.c:2049
       __do_sys_madvise mm/madvise.c:2058 [inline]
       __se_sys_madvise mm/madvise.c:2056 [inline]
       __x64_sys_madvise+0xa6/0xc0 mm/madvise.c:2056
       do_syscall_x64 arch/x86/entry/syscall_64.c:63 [inline]
       do_syscall_64+0xe2/0xf80 arch/x86/entry/syscall_64.c:94
       entry_SYSCALL_64_after_hwframe+0x77/0x7f

other info that might help us debug this:

Chain exists of:
  &sb->s_type->i_mutex_key#10 --> &mm->mmap_lock --> vm_lock

 Possible unsafe locking scenario:

       CPU0                    CPU1
       ----                    ----
  rlock(vm_lock);
                               lock(&mm->mmap_lock);
                               lock(vm_lock);
  lock(&sb->s_type->i_mutex_key#10);

 *** DEADLOCK ***

1 lock held by syz.0.17/5976:
 #0: ffff8881043c3b88 (vm_lock){++++}-{0:0}, at: lock_vma_under_rcu+0x1d1/0=
x500 mm/mmap_lock.c:259

stack backtrace:
CPU: 1 UID: 0 PID: 5976 Comm: syz.0.17 Not tainted syzkaller #0 PREEMPT(ful=
l)=20
Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS 1.16.2-debian-1.16=
.2-1 04/01/2014
Call Trace:
 <TASK>
 dump_stack_lvl+0xe8/0x150 lib/dump_stack.c:120
 print_circular_bug+0x2e1/0x300 kernel/locking/lockdep.c:2043
 check_noncircular+0x12e/0x150 kernel/locking/lockdep.c:2175
 check_prev_add kernel/locking/lockdep.c:3165 [inline]
 check_prevs_add kernel/locking/lockdep.c:3284 [inline]
 validate_chain kernel/locking/lockdep.c:3908 [inline]
 __lock_acquire+0x15a5/0x2cf0 kernel/locking/lockdep.c:5237
 lock_acquire+0x106/0x330 kernel/locking/lockdep.c:5868
 down_write+0x96/0x200 kernel/locking/rwsem.c:1590
 inode_lock include/linux/fs.h:1027 [inline]
 blkdev_fallocate+0x260/0x530 block/fops.c:908
 vfs_fallocate+0x669/0x7e0 fs/open.c:339
 madvise_remove mm/madvise.c:1055 [inline]
 madvise_vma_behavior+0x120d/0x4460 mm/madvise.c:1379
 madvise_walk_vmas+0x90e/0xaf0 mm/madvise.c:1706
 madvise_do_behavior+0x386/0x540 mm/madvise.c:1956
 do_madvise+0x1fa/0x2e0 mm/madvise.c:2049
 __do_sys_madvise mm/madvise.c:2058 [inline]
 __se_sys_madvise mm/madvise.c:2056 [inline]
 __x64_sys_madvise+0xa6/0xc0 mm/madvise.c:2056
 do_syscall_x64 arch/x86/entry/syscall_64.c:63 [inline]
 do_syscall_64+0xe2/0xf80 arch/x86/entry/syscall_64.c:94
 entry_SYSCALL_64_after_hwframe+0x77/0x7f
RIP: 0033:0x7f5ceb59acb9
Code: ff c3 66 2e 0f 1f 84 00 00 00 00 00 0f 1f 44 00 00 48 89 f8 48 89 f7 =
48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 ff f=
f 73 01 c3 48 c7 c1 e8 ff ff ff f7 d8 64 89 01 48
RSP: 002b:00007ffd12a05518 EFLAGS: 00000246 ORIG_RAX: 000000000000001c
RAX: ffffffffffffffda RBX: 00007f5ceb815fa0 RCX: 00007f5ceb59acb9
RDX: 0000000000000009 RSI: 0000000000004000 RDI: 0000200000119000
RBP: 00007f5ceb608bf7 R08: 0000000000000000 R09: 0000000000000000
R10: 0000000000000000 R11: 0000000000000246 R12: 0000000000000000
R13: 00007f5ceb815fac R14: 00007f5ceb815fa0 R15: 00007f5ceb815fa0
 </TASK>


***

If these findings have caused you to resend the series or submit a
separate fix, please add the following tag to your commit message:
  Tested-by: syzbot@syzkaller.appspotmail.com

---
This report is generated by a bot. It may contain errors.
syzbot ci engineers can be reached at syzkaller@googlegroups.com.

The email will later be sent to:
[akpm@linux-foundation.org david@kernel.org fan.yu9@zte.com.cn he.peilin@zt=
e.com.cn jannh@google.com jiang.kun2@zte.com.cn liam.howlett@oracle.com lin=
ux-kernel@vger.kernel.org linux-mm@kvack.org lorenzo.stoakes@oracle.com lu.=
zhongjun@zte.com.cn qiu.yutan@zte.com.cn tu.qiang35@zte.com.cn vbabka@suse.=
cz wang.yaxin@zte.com.cn xu.xin16@zte.com.cn yang.yang29@zte.com.cn]

If the report looks fine to you, reply with:
#syz upstream

If the report is a false positive, reply with
#syz invalid

