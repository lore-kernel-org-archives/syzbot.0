Received: from mail-il1-f198.google.com (mail-il1-f198.google.com [209.85.166.198])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 769E426ED3F
	for <syzbot@lists.linux.dev>; Tue,  4 Nov 2025 09:08:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.198
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762247335; cv=none; b=RoxEcn4bo4/RLPfMdBSUj82AkvTqNrjniN3Qg717Q9aiLoRQQhyxrE9fX6EPwm0G0tbx9YHuzngIy2OaGSyfg1ZmV9+4QQE24KpaqkZ5gmjfjw73SIOR6kzCScLEciXliQVV4HS1fD3uN37q32mER3C0lYRa7eitNUY5sxA/wGA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762247335; c=relaxed/simple;
	bh=rLx+2n78Kr31jWTnLTrf+RM+w8IMl0nj/nN4bAZLOZ0=;
	h=MIME-Version:Date:In-Reply-To:Message-ID:Subject:From:To:Cc:
	 Content-Type; b=e2kWvk8IiLXMeAD6oplt5A46Y8+vUr85ZPiIcaKsRwVoS5MNgsz+C5mH6D7hVs5Fcnho3BlOftZK1dlKPCrWv/JipJNocZ4vG+zGBLvQ2GtvCGT+CRIS3EHj07+OeH0pi0MDk6CUQwpVV4fCj+GYfuDdgPsTnWH13mPf/jibgW0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com; arc=none smtp.client-ip=209.85.166.198
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com
Received: by mail-il1-f198.google.com with SMTP id e9e14a558f8ab-4330bc0373bso35653115ab.0
        for <syzbot@lists.linux.dev>; Tue, 04 Nov 2025 01:08:53 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1762247332; x=1762852132;
        h=cc:to:from:subject:message-id:in-reply-to:date:mime-version
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=G129N04BjLFHinVS/jNh9nO9kb8p/9wuEhtZ/Y8I17I=;
        b=FBLRrnb2sXNsBIKIQLLn3vHRs14CO8cWWtoR2sgDUVbbUJUsgfpydjALaN/asMYsRu
         pYT0DjGBsc9ujIdIyZAIJsxhGW+um1vYdatLelHeQigXcGHjUV8MXzWXJuTjx8GIeYzj
         ITASUnYaYL5XkDbXMyNwwb40JqEo4+NFk09yeuBik6ep88ZL94AqFwgWKQaq0e5ucWR4
         LJ19wEUFdBf8Ld0EcwEJLaiBSYryts+QoGCtSDTIhxDNwvcLp9jTc2q5y7ayN/FgfJ2A
         wzXC4cX6QAXtvipXSTPZL5BfPNn+Joq2HmA3duyvTfB1rimH+u1T5OhN6PsNNFAnUW3S
         eKxA==
X-Gm-Message-State: AOJu0YwmNThUYGczc40SH7TNjnd8rdOB92nBNeuKP9wy55kF+CmQ6JoY
	o6aehlyP9gCQ4piEUgN8qtnZUkIjd2oZw0KtDalFyx9xM4oIbiIktzE/6T0wvUVWrXAUAn6NFt8
	NTaBepCo36Ux4Huqo/lgX+l4DOoRnxDaSmve8b5/CBdbctN9qK2358h2yoFU=
X-Google-Smtp-Source: AGHT+IEBKE3inw+JwQHUYR/CfJd/TNna+rZ8yMk5BapQe/jriuxDSLwOcefxZiBHukbRgMdnVUnA08TMDKHpdhgNeA+5YD0JsZ1t
Precedence: bulk
X-Mailing-List: syzbot@lists.linux.dev
List-Id: <syzbot.lists.linux.dev>
List-Subscribe: <mailto:syzbot+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:syzbot+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Received: by 2002:a05:6e02:1606:b0:430:aedb:3719 with SMTP id
 e9e14a558f8ab-4330d125bc1mr217117295ab.4.1762247332639; Tue, 04 Nov 2025
 01:08:52 -0800 (PST)
Date: Tue, 04 Nov 2025 01:08:52 -0800
In-Reply-To: <20251103180348.3368668-1-willy@infradead.org>
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <6909c2a4.050a0220.98a6.00a8.GAE@google.com>
Subject: [syzbot ci] Re: vma_start_write_killable
From: syzbot ci <syzbot+cicf36371c0f59f4ad@syzkaller.appspotmail.com>
To: akpm@linux-foundation.org, chriscli@google.com, jannh@google.com, 
	liam.howlett@oracle.com, linux-mm@kvack.org, lorenzo.stoakes@oracle.com, 
	pfalcato@suse.de, shakeel.butt@linux.dev, surenb@google.com, vbabka@suse.cz, 
	willy@infradead.org
Cc: syzbot@lists.linux.dev, syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"

syzbot ci has tested the following series

[v1] vma_start_write_killable
https://lore.kernel.org/all/20251103180348.3368668-1-willy@infradead.org
* [PATCH 1/2] mm: Add vma_start_write_killable()
* [PATCH 2/2] mm: Use vma_start_write_killable() in dup_mmap()

and found the following issue:
possible deadlock in exit_mmap

Full report is available here:
https://ci.syzbot.org/series/3eb0eeab-3254-43ec-ad2d-e439ab81ad3e

***

possible deadlock in exit_mmap

tree:      torvalds
URL:       https://kernel.googlesource.com/pub/scm/linux/kernel/git/torvalds/linux
base:      fd57572253bc356330dbe5b233c2e1d8426c66fd
arch:      amd64
compiler:  Debian clang version 20.1.8 (++20250708063551+0c9f909b7976-1~exp1~20250708183702.136), Debian LLD 20.1.8
config:    https://ci.syzbot.org/builds/b55422d4-9fe5-4a2c-9938-3e67223a358f/config
C repro:   https://ci.syzbot.org/findings/ecb8b9e5-1c01-48c4-b7b6-9155dea27118/c_repro
syz repro: https://ci.syzbot.org/findings/ecb8b9e5-1c01-48c4-b7b6-9155dea27118/syz_repro

======================================================
WARNING: possible circular locking dependency detected
syzkaller #0 Not tainted
------------------------------------------------------
syz.0.24/6004 is trying to acquire lock:
ffff88810f7fcd20 (&mm->mmap_lock){++++}-{4:4}, at: mmap_read_lock include/linux/mmap_lock.h:395 [inline]
ffff88810f7fcd20 (&mm->mmap_lock){++++}-{4:4}, at: exit_mmap+0x126/0xb40 mm/mmap.c:1265

but task is already holding lock:
ffff888111ad0f88 (vm_lock){++++}-{0:0}, at: __vma_start_write+0x23/0x140 mm/mmap_lock.c:92

which lock already depends on the new lock.


the existing dependency chain (in reverse order) is:

-> #1 (vm_lock){++++}-{0:0}:
       lock_acquire+0x120/0x360 kernel/locking/lockdep.c:5868
       __vma_enter_locked+0x1a0/0x570 mm/mmap_lock.c:65
       __vma_start_write+0x23/0x140 mm/mmap_lock.c:92
       vma_start_write include/linux/mmap_lock.h:213 [inline]
       mprotect_fixup+0x57d/0x9c0 mm/mprotect.c:828
       setup_arg_pages+0x52a/0xa90 fs/exec.c:670
       load_elf_binary+0xba4/0x2740 fs/binfmt_elf.c:1028
       search_binary_handler fs/exec.c:1670 [inline]
       exec_binprm fs/exec.c:1702 [inline]
       bprm_execve+0x99c/0x1450 fs/exec.c:1754
       kernel_execve+0x8f0/0x9f0 fs/exec.c:1920
       try_to_run_init_process+0x13/0x60 init/main.c:1411
       kernel_init+0xad/0x1d0 init/main.c:1539
       ret_from_fork+0x4bc/0x870 arch/x86/kernel/process.c:158
       ret_from_fork_asm+0x1a/0x30 arch/x86/entry/entry_64.S:245

-> #0 (&mm->mmap_lock){++++}-{4:4}:
       check_prev_add kernel/locking/lockdep.c:3165 [inline]
       check_prevs_add kernel/locking/lockdep.c:3284 [inline]
       validate_chain+0xb9b/0x2140 kernel/locking/lockdep.c:3908
       __lock_acquire+0xab9/0xd20 kernel/locking/lockdep.c:5237
       lock_acquire+0x120/0x360 kernel/locking/lockdep.c:5868
       down_read+0x46/0x2e0 kernel/locking/rwsem.c:1537
       mmap_read_lock include/linux/mmap_lock.h:395 [inline]
       exit_mmap+0x126/0xb40 mm/mmap.c:1265
       __mmput+0x118/0x430 kernel/fork.c:1133
       mmput kernel/fork.c:1156 [inline]
       dup_mm kernel/fork.c:1506 [inline]
       copy_mm+0x1f3/0x4b0 kernel/fork.c:1541
       copy_process+0x1706/0x3c00 kernel/fork.c:2181
       kernel_clone+0x21e/0x840 kernel/fork.c:2609
       __do_sys_clone kernel/fork.c:2750 [inline]
       __se_sys_clone kernel/fork.c:2734 [inline]
       __x64_sys_clone+0x18b/0x1e0 kernel/fork.c:2734
       do_syscall_x64 arch/x86/entry/syscall_64.c:63 [inline]
       do_syscall_64+0xfa/0xfa0 arch/x86/entry/syscall_64.c:94
       entry_SYSCALL_64_after_hwframe+0x77/0x7f

other info that might help us debug this:

 Possible unsafe locking scenario:

       CPU0                    CPU1
       ----                    ----
  lock(vm_lock);
                               lock(&mm->mmap_lock);
                               lock(vm_lock);
  rlock(&mm->mmap_lock);

 *** DEADLOCK ***

2 locks held by syz.0.24/6004:
 #0: ffffffff8dff64d0 (dup_mmap_sem){.+.+}-{0:0}, at: dup_mm kernel/fork.c:1488 [inline]
 #0: ffffffff8dff64d0 (dup_mmap_sem){.+.+}-{0:0}, at: copy_mm+0x131/0x4b0 kernel/fork.c:1541
 #1: ffff888111ad0f88 (vm_lock){++++}-{0:0}, at: __vma_start_write+0x23/0x140 mm/mmap_lock.c:92

stack backtrace:
CPU: 0 UID: 0 PID: 6004 Comm: syz.0.24 Not tainted syzkaller #0 PREEMPT(full) 
Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS 1.16.2-debian-1.16.2-1 04/01/2014
Call Trace:
 <TASK>
 dump_stack_lvl+0x189/0x250 lib/dump_stack.c:120
 print_circular_bug+0x2ee/0x310 kernel/locking/lockdep.c:2043
 check_noncircular+0x134/0x160 kernel/locking/lockdep.c:2175
 check_prev_add kernel/locking/lockdep.c:3165 [inline]
 check_prevs_add kernel/locking/lockdep.c:3284 [inline]
 validate_chain+0xb9b/0x2140 kernel/locking/lockdep.c:3908
 __lock_acquire+0xab9/0xd20 kernel/locking/lockdep.c:5237
 lock_acquire+0x120/0x360 kernel/locking/lockdep.c:5868
 down_read+0x46/0x2e0 kernel/locking/rwsem.c:1537
 mmap_read_lock include/linux/mmap_lock.h:395 [inline]
 exit_mmap+0x126/0xb40 mm/mmap.c:1265
 __mmput+0x118/0x430 kernel/fork.c:1133
 mmput kernel/fork.c:1156 [inline]
 dup_mm kernel/fork.c:1506 [inline]
 copy_mm+0x1f3/0x4b0 kernel/fork.c:1541
 copy_process+0x1706/0x3c00 kernel/fork.c:2181
 kernel_clone+0x21e/0x840 kernel/fork.c:2609
 __do_sys_clone kernel/fork.c:2750 [inline]
 __se_sys_clone kernel/fork.c:2734 [inline]
 __x64_sys_clone+0x18b/0x1e0 kernel/fork.c:2734
 do_syscall_x64 arch/x86/entry/syscall_64.c:63 [inline]
 do_syscall_64+0xfa/0xfa0 arch/x86/entry/syscall_64.c:94
 entry_SYSCALL_64_after_hwframe+0x77/0x7f
RIP: 0033:0x7f45ab18efc9
Code: ff ff c3 66 2e 0f 1f 84 00 00 00 00 00 0f 1f 40 00 48 89 f8 48 89 f7 48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 ff ff 73 01 c3 48 c7 c1 a8 ff ff ff f7 d8 64 89 01 48
RSP: 002b:00007f45abfaefe8 EFLAGS: 00000206 ORIG_RAX: 0000000000000038
RAX: ffffffffffffffda RBX: 00007f45ab3e6090 RCX: 00007f45ab18efc9
RDX: 0000000000000000 RSI: 0000000000000000 RDI: 0000000000001000
RBP: 00007f45ab211f91 R08: 0000000000000000 R09: 0000000000000000
R10: 0000000000000000 R11: 0000000000000206 R12: 0000000000000000
R13: 00007f45ab3e6128 R14: 00007f45ab3e6090 R15: 00007ffe9b2a02c8
 </TASK>
------------[ cut here ]------------
refcount_t: saturated; leaking memory.
WARNING: CPU: 0 PID: 6004 at lib/refcount.c:19 refcount_warn_saturate+0x13a/0x1d0 lib/refcount.c:19
Modules linked in:
CPU: 0 UID: 0 PID: 6004 Comm: syz.0.24 Not tainted syzkaller #0 PREEMPT(full) 
Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS 1.16.2-debian-1.16.2-1 04/01/2014
RIP: 0010:refcount_warn_saturate+0x13a/0x1d0 lib/refcount.c:19
Code: 20 57 be 8b e8 87 a8 f9 fc 90 0f 0b 90 90 eb b7 e8 6b 8c 36 fd c6 05 1b 75 dd 0a 01 90 48 c7 c7 60 56 be 8b e8 67 a8 f9 fc 90 <0f> 0b 90 90 eb 97 e8 4b 8c 36 fd c6 05 ff 74 dd 0a 01 90 48 c7 c7
RSP: 0018:ffffc900036f75a8 EFLAGS: 00010246
RAX: 37ca69179b3b1c00 RBX: 0000000000000000 RCX: ffff88810c6c0000
RDX: 0000000000000000 RSI: 0000000000000000 RDI: 0000000000000002
RBP: ffffc900036f76b0 R08: 0000000000000003 R09: 0000000000000004
R10: dffffc0000000000 R11: fffffbfff1bba650 R12: ffff888111ad0f80
R13: 1ffff920006deec4 R14: ffff888111ad0f80 R15: 0000000000000000
FS:  00007f45abfaf6c0(0000) GS:ffff88818eb3e000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 00007f45abfaefc8 CR3: 00000001bbaba000 CR4: 00000000000006f0
Call Trace:
 <TASK>
 __refcount_add_not_zero include/linux/refcount.h:187 [inline]
 refcount_add_not_zero include/linux/refcount.h:212 [inline]
 __vma_enter_locked+0x534/0x570 mm/mmap_lock.c:62
 __vma_start_write+0x23/0x140 mm/mmap_lock.c:92
 vma_start_write include/linux/mmap_lock.h:213 [inline]
 vma_merge_existing_range mm/vma.c:905 [inline]
 vma_modify+0xce0/0x1970 mm/vma.c:1608
 vma_modify_flags_uffd+0x204/0x250 mm/vma.c:1697
 userfaultfd_clear_vma mm/userfaultfd.c:2030 [inline]
 userfaultfd_release_all+0x34c/0x5d0 mm/userfaultfd.c:2149
 userfaultfd_release+0xe7/0x1b0 fs/userfaultfd.c:868
 __fput+0x44c/0xa70 fs/file_table.c:468
 task_work_run+0x1d4/0x260 kernel/task_work.c:227
 get_signal+0x11ec/0x1340 kernel/signal.c:2807
 arch_do_signal_or_restart+0xa0/0x790 arch/x86/kernel/signal.c:337
 exit_to_user_mode_loop+0x72/0x130 kernel/entry/common.c:40
 exit_to_user_mode_prepare include/linux/irq-entry-common.h:225 [inline]
 syscall_exit_to_user_mode_work include/linux/entry-common.h:175 [inline]
 syscall_exit_to_user_mode include/linux/entry-common.h:210 [inline]
 do_syscall_64+0x2bd/0xfa0 arch/x86/entry/syscall_64.c:100
 entry_SYSCALL_64_after_hwframe+0x77/0x7f
RIP: 0033:0x7f45ab18efc9
Code: ff ff c3 66 2e 0f 1f 84 00 00 00 00 00 0f 1f 40 00 48 89 f8 48 89 f7 48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 ff ff 73 01 c3 48 c7 c1 a8 ff ff ff f7 d8 64 89 01 48
RSP: 002b:00007f45abfaefe8 EFLAGS: 00000206 ORIG_RAX: 0000000000000038
RAX: fffffffffffffff4 RBX: 00007f45ab3e6090 RCX: 00007f45ab18efc9
RDX: 0000000000000000 RSI: 0000000000000000 RDI: 0000000000001000
RBP: 00007f45ab211f91 R08: 0000000000000000 R09: 0000000000000000
R10: 0000000000000000 R11: 0000000000000206 R12: 0000000000000000
R13: 00007f45ab3e6128 R14: 00007f45ab3e6090 R15: 00007ffe9b2a02c8
 </TASK>


***

If these findings have caused you to resend the series or submit a
separate fix, please add the following tag to your commit message:
  Tested-by: syzbot@syzkaller.appspotmail.com

---
This report is generated by a bot. It may contain errors.
syzbot ci engineers can be reached at syzkaller@googlegroups.com.
