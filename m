Received: from mail-ot1-f70.google.com (mail-ot1-f70.google.com [209.85.210.70])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 21AF43DFC61
	for <syzbot@lists.linux.dev>; Mon, 18 May 2026 07:28:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.70
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779089321; cv=none; b=ZJ2mG4N5+zi1Yw2fIpyrmq135vFhe79s7msZBP1UsLGH3qWKgEVeOsoc01yaW3j7c/LiAznzc+/mUVIVV8yrk67y+ZJO7rClPHiSVFjUvs8IapEAO0tG6GWcHZOtATpSM0594WYtZKtR4/u0XcTPSr5fqNY/4nMaNTjNebye3Ms=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779089321; c=relaxed/simple;
	bh=sNhfDqgkiS9I66WlGSznGGlZGYGMibnts3pvPljSUhs=;
	h=MIME-Version:Date:In-Reply-To:Message-ID:Subject:From:To:Cc:
	 Content-Type; b=NTSwsEVfVSpA9Dj0IOJbnJnXTzx5eNyqw+v/bID/7y0K3Lq2UyCi8IzdGYYTC4qAHzI3qd2ZjVHzlqAk+MjWN4c9oV+v/Zh/DNaq7oyxSoHbRTKTpleNKJQrx6kEmmJlseGm5WHTfu/uQnQ99Z66IFJmLnZUz2qZ+3/JG0Ezrtw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com; arc=none smtp.client-ip=209.85.210.70
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com
Received: by mail-ot1-f70.google.com with SMTP id 46e09a7af769-7de44ba64e7so3102897a34.1
        for <syzbot@lists.linux.dev>; Mon, 18 May 2026 00:28:39 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1779089319; x=1779694119;
        h=cc:to:from:subject:message-id:in-reply-to:date:mime-version
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=ktv8pofV7HwC0FMo5Td8D7U6jLTeR2OKek2m+rcSdKE=;
        b=PTYRwZG9LfoJztSC7AIL7arEetx61VHV9lNelXjOgP6rTgSN773JCWye1Ek7VH8hMG
         +1kaPejPFIw0jbbNAu3516mwDZHjiAceUAZTFgggv4kYPryvNiX8DD6yLZpIj3lWs+md
         SmdcLsL/RG8Zt7ob3yQXjn52Tnq9HHGLUw2f4zLidKBY16wPpCbHqYB47OnEkG4I6heR
         CMee4IbAqHF+RuFuU1kwmNgx25lN+qNat76PIvec9wgVXu4pceje7Qh3tZ/xtdKmuG4U
         FBzqsJBO2Q89v8xSP+yaSjYqLsKvmJoFxawEVhhlDFSmGryM6ADlgsYr0uzoPWE0AsL8
         0NlA==
X-Gm-Message-State: AOJu0Ywgn+25oaPcRAuJkLa3WOCyNoouS4dWakpb+JMPZVqLqVsBx9Yj
	MC25gOHWjyWxCNlm3TSO2dEj6rqExt9p64fx96NAH9MY8Sx6QEUgElbCNVlXbUFEVq6Al332ya+
	MZFjsEPosEKVE/5gVi4+QZxdZC87f5cErKWQU+lCpi7cJIHtPU0zw0xZVrwA=
Precedence: bulk
X-Mailing-List: syzbot@lists.linux.dev
List-Id: <syzbot.lists.linux.dev>
List-Subscribe: <mailto:syzbot+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:syzbot+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Received: by 2002:a05:6820:6ac4:b0:67e:f8c:6bcc with SMTP id
 006d021491bc7-69c942ef633mr9219707eaf.19.1779089319133; Mon, 18 May 2026
 00:28:39 -0700 (PDT)
Date: Mon, 18 May 2026 00:28:39 -0700
In-Reply-To: <20260517170244.1832119-1-jkoolstra@xs4all.nl>
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <6a0abfa7.170a0220.bc3c0.000c.GAE@google.com>
Subject: [syzbot ci] Re: vfs: add O_CREAT|O_DIRECTORY to open*(2)
From: syzbot ci <syzbot+cia4da2a1fc78a65a2@syzkaller.appspotmail.com>
To: brauner@kernel.org, cmirabil@redhat.com, cyphar@cyphar.com, jack@suse.cz, 
	jkoolstra@xs4all.nl, linux-fsdevel@vger.kernel.org, 
	linux-kernel@vger.kernel.org, viro@zeniv.linux.org.uk
Cc: syzbot@lists.linux.dev, syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"

syzbot ci has tested the following series

[v3] vfs: add O_CREAT|O_DIRECTORY to open*(2)
https://lore.kernel.org/all/20260517170244.1832119-1-jkoolstra@xs4all.nl
* [RFC PATCH v3 1/2] vfs: add O_CREAT|O_DIRECTORY to open*(2)
* [RFC PATCH v3 2/2] selftest: add tests for open*(O_CREAT|O_DIRECTORY)

and found the following issues:
* WARNING: lock held when returning to user space in filename_create
* WARNING: lock held when returning to user space in start_creating
* possible deadlock in mnt_want_write

Full report is available here:
https://ci.syzbot.org/series/6c2681e8-f8f3-4287-8f97-bd6ea26a767f

***

WARNING: lock held when returning to user space in filename_create

tree:      torvalds
URL:       https://kernel.googlesource.com/pub/scm/linux/kernel/git/torvalds/linux
base:      6916d5703ddf9a38f1f6c2cc793381a24ee914c6
arch:      amd64
compiler:  Debian clang version 21.1.8 (++20251221033036+2078da43e25a-1~exp1~20251221153213.50), Debian LLD 21.1.8
config:    https://ci.syzbot.org/builds/7a0474b8-fd0f-4804-8833-2232742e06e3/config
syz repro: https://ci.syzbot.org/findings/512f2832-177b-4b65-b835-bdff3e4402bc/syz_repro

hpfs: hpfs_map_4sectors(): unaligned read
hpfs: hpfs_map_4sectors(): unaligned read
hpfs: filesystem error: unable to find root dir
================================================
WARNING: lock held when returning to user space!
syzkaller #0 Not tainted
------------------------------------------------
syz.0.17/5814 is leaving the kernel with locks still held!
1 lock held by syz.0.17/5814:
 #0: ffff8881bab5b878 (&type->i_mutex_dir_key#8/1){+.+.}-{4:4}, at: inode_lock_nested include/linux/fs.h:1074 [inline]
 #0: ffff8881bab5b878 (&type->i_mutex_dir_key#8/1){+.+.}-{4:4}, at: __start_dirop fs/namei.c:2919 [inline]
 #0: ffff8881bab5b878 (&type->i_mutex_dir_key#8/1){+.+.}-{4:4}, at: start_dirop fs/namei.c:2943 [inline]
 #0: ffff8881bab5b878 (&type->i_mutex_dir_key#8/1){+.+.}-{4:4}, at: filename_create+0x200/0x370 fs/namei.c:4984


***

WARNING: lock held when returning to user space in start_creating

tree:      torvalds
URL:       https://kernel.googlesource.com/pub/scm/linux/kernel/git/torvalds/linux
base:      6916d5703ddf9a38f1f6c2cc793381a24ee914c6
arch:      amd64
compiler:  Debian clang version 21.1.8 (++20251221033036+2078da43e25a-1~exp1~20251221153213.50), Debian LLD 21.1.8
config:    https://ci.syzbot.org/builds/7a0474b8-fd0f-4804-8833-2232742e06e3/config
syz repro: https://ci.syzbot.org/findings/7bdf5f73-8cce-4785-aa9e-dd89622cf613/syz_repro

overlayfs: failed to create directory ./bus/work (errno: 126); mounting read-only
================================================
WARNING: lock held when returning to user space!
syzkaller #0 Not tainted
------------------------------------------------
syz.1.18/5833 is leaving the kernel with locks still held!
1 lock held by syz.1.18/5833:
 #0: ffff8881ba0c4518 (&type->i_mutex_dir_key#3/1){+.+.}-{4:4}, at: inode_lock_nested include/linux/fs.h:1074 [inline]
 #0: ffff8881ba0c4518 (&type->i_mutex_dir_key#3/1){+.+.}-{4:4}, at: __start_dirop fs/namei.c:2919 [inline]
 #0: ffff8881ba0c4518 (&type->i_mutex_dir_key#3/1){+.+.}-{4:4}, at: start_dirop fs/namei.c:2943 [inline]
 #0: ffff8881ba0c4518 (&type->i_mutex_dir_key#3/1){+.+.}-{4:4}, at: start_creating+0xbe/0x100 fs/namei.c:3412


***

possible deadlock in mnt_want_write

tree:      torvalds
URL:       https://kernel.googlesource.com/pub/scm/linux/kernel/git/torvalds/linux
base:      6916d5703ddf9a38f1f6c2cc793381a24ee914c6
arch:      amd64
compiler:  Debian clang version 21.1.8 (++20251221033036+2078da43e25a-1~exp1~20251221153213.50), Debian LLD 21.1.8
config:    https://ci.syzbot.org/builds/7a0474b8-fd0f-4804-8833-2232742e06e3/config
syz repro: https://ci.syzbot.org/findings/6d4f386f-fb66-4862-b644-4ac19c79f6a3/syz_repro

======================================================
WARNING: possible circular locking dependency detected
syzkaller #0 Not tainted
------------------------------------------------------
syz.0.17/5836 is trying to acquire lock:
ffff888118cba410
 (sb_writers#12){.+.+}-{0:0}, at: mnt_want_write+0x41/0x90 fs/namespace.c:493

but task is already holding lock:
ffff88811f1627e0 (&ovl_i_mutex_dir_key[depth]/1){+.+.}-{4:4}, at: inode_lock_nested include/linux/fs.h:1074 [inline]
ffff88811f1627e0 (&ovl_i_mutex_dir_key[depth]/1){+.+.}-{4:4}, at: __start_dirop fs/namei.c:2919 [inline]
ffff88811f1627e0 (&ovl_i_mutex_dir_key[depth]/1){+.+.}-{4:4}, at: start_dirop fs/namei.c:2943 [inline]
ffff88811f1627e0 (&ovl_i_mutex_dir_key[depth]/1){+.+.}-{4:4}, at: filename_create+0x200/0x370 fs/namei.c:4984

which lock already depends on the new lock.


the existing dependency chain (in reverse order) is:

-> #1 (&ovl_i_mutex_dir_key[depth]/1){+.+.}-{4:4}:
       down_write_nested+0x9d/0x210 kernel/locking/rwsem.c:1751
       inode_lock_nested include/linux/fs.h:1074 [inline]
       __start_dirop fs/namei.c:2919 [inline]
       start_dirop fs/namei.c:2943 [inline]
       filename_unlinkat+0x2a7/0x610 fs/namei.c:5599
       __do_sys_unlink fs/namei.c:5653 [inline]
       __se_sys_unlink+0x2e/0x140 fs/namei.c:5650
       do_syscall_x64 arch/x86/entry/syscall_64.c:63 [inline]
       do_syscall_64+0x15f/0xf80 arch/x86/entry/syscall_64.c:94
       entry_SYSCALL_64_after_hwframe+0x77/0x7f

-> #0 (sb_writers#12){.+.+}-{0:0}:
       check_prev_add kernel/locking/lockdep.c:3165 [inline]
       check_prevs_add kernel/locking/lockdep.c:3284 [inline]
       validate_chain kernel/locking/lockdep.c:3908 [inline]
       __lock_acquire+0x15a5/0x2cf0 kernel/locking/lockdep.c:5237
       lock_acquire+0x106/0x350 kernel/locking/lockdep.c:5868
       percpu_down_read_internal include/linux/percpu-rwsem.h:53 [inline]
       percpu_down_read_freezable include/linux/percpu-rwsem.h:83 [inline]
       __sb_start_write include/linux/fs/super.h:19 [inline]
       sb_start_write+0x4d/0x1c0 include/linux/fs/super.h:125
       mnt_want_write+0x41/0x90 fs/namespace.c:493
       filename_create+0x154/0x370 fs/namei.c:4977
       filename_mkdirat+0xd2/0x510 fs/namei.c:5337
       __do_sys_mkdirat fs/namei.c:5365 [inline]
       __se_sys_mkdirat+0x35/0x150 fs/namei.c:5362
       do_syscall_x64 arch/x86/entry/syscall_64.c:63 [inline]
       do_syscall_64+0x15f/0xf80 arch/x86/entry/syscall_64.c:94
       entry_SYSCALL_64_after_hwframe+0x77/0x7f

other info that might help us debug this:

 Possible unsafe locking scenario:

       CPU0                    CPU1
       ----                    ----
  lock(&ovl_i_mutex_dir_key[depth]/1);
                               lock(sb_writers#12);
                               lock(&ovl_i_mutex_dir_key[depth]/1);
  rlock(sb_writers#12);

 *** DEADLOCK ***

1 lock held by syz.0.17/5836:
 #0: ffff88811f1627e0 (&ovl_i_mutex_dir_key[depth]/1){+.+.}-{4:4}, at: inode_lock_nested include/linux/fs.h:1074 [inline]
 #0: ffff88811f1627e0 (&ovl_i_mutex_dir_key[depth]/1){+.+.}-{4:4}, at: __start_dirop fs/namei.c:2919 [inline]
 #0: ffff88811f1627e0 (&ovl_i_mutex_dir_key[depth]/1){+.+.}-{4:4}, at: start_dirop fs/namei.c:2943 [inline]
 #0: ffff88811f1627e0 (&ovl_i_mutex_dir_key[depth]/1){+.+.}-{4:4}, at: filename_create+0x200/0x370 fs/namei.c:4984

stack backtrace:
CPU: 0 UID: 0 PID: 5836 Comm: syz.0.17 Not tainted syzkaller #0 PREEMPT(full) 
Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS 1.16.2-debian-1.16.2-1 04/01/2014
Call Trace:
 <TASK>
 dump_stack_lvl+0xe8/0x150 lib/dump_stack.c:120
 print_circular_bug+0x2e1/0x300 kernel/locking/lockdep.c:2043
 check_noncircular+0x12e/0x150 kernel/locking/lockdep.c:2175
 check_prev_add kernel/locking/lockdep.c:3165 [inline]
 check_prevs_add kernel/locking/lockdep.c:3284 [inline]
 validate_chain kernel/locking/lockdep.c:3908 [inline]
 __lock_acquire+0x15a5/0x2cf0 kernel/locking/lockdep.c:5237
 lock_acquire+0x106/0x350 kernel/locking/lockdep.c:5868
 percpu_down_read_internal include/linux/percpu-rwsem.h:53 [inline]
 percpu_down_read_freezable include/linux/percpu-rwsem.h:83 [inline]
 __sb_start_write include/linux/fs/super.h:19 [inline]
 sb_start_write+0x4d/0x1c0 include/linux/fs/super.h:125
 mnt_want_write+0x41/0x90 fs/namespace.c:493
 filename_create+0x154/0x370 fs/namei.c:4977
 filename_mkdirat+0xd2/0x510 fs/namei.c:5337
 __do_sys_mkdirat fs/namei.c:5365 [inline]
 __se_sys_mkdirat+0x35/0x150 fs/namei.c:5362
 do_syscall_x64 arch/x86/entry/syscall_64.c:63 [inline]
 do_syscall_64+0x15f/0xf80 arch/x86/entry/syscall_64.c:94
 entry_SYSCALL_64_after_hwframe+0x77/0x7f
RIP: 0033:0x7f2f5e99ce59
Code: ff c3 66 2e 0f 1f 84 00 00 00 00 00 0f 1f 44 00 00 48 89 f8 48 89 f7 48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 ff ff 73 01 c3 48 c7 c1 e8 ff ff ff f7 d8 64 89 01 48
RSP: 002b:00007f2f5f771028 EFLAGS: 00000246 ORIG_RAX: 0000000000000102
RAX: ffffffffffffffda RBX: 00007f2f5ec15fa0 RCX: 00007f2f5e99ce59
RDX: 0000000000000010 RSI: 0000200000002040 RDI: ffffffffffffff9c
RBP: 00007f2f5ea32d6f R08: 0000000000000000 R09: 0000000000000000
R10: 0000000000000000 R11: 0000000000000246 R12: 0000000000000000
R13: 00007f2f5ec16038 R14: 00007f2f5ec15fa0 R15: 00007ffe96c961d8
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
