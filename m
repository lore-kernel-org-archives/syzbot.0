Received: from mail-io1-f71.google.com (mail-io1-f71.google.com [209.85.166.71])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ED5702745C
	for <syzbot@lists.linux.dev>; Thu,  6 Nov 2025 06:56:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.71
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762412207; cv=none; b=DR/pmkizNn6KkmwyjpESmaBnPgw/XYc2l8xd5HO5BMrVUJ0qrue0x3fs4Er22pZoSF3QNtX/Fgm/uYfblD43bVZLzvK9T10pvCgKcRnrbQ994gRBfLK/PFWcAPRO/A1YPusNtIt6jFpQwm2nnJ/uooEBdi6/J0ud8Fl5NAYqhkA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762412207; c=relaxed/simple;
	bh=QFO/UNfJoUGUHqqtge11mnKuqsSwiJ/WpLgDX06Y+v0=;
	h=MIME-Version:Date:Message-ID:Subject:From:To:Cc:Content-Type; b=DslCt13BHIAoXRHK9FnftMBnlVthiohuf3KB+pqHzXaQxm4G+KnVfu/X6JfGysZUQSmsbV5DmT6hqa8R9XrCZcARc9v713MKazlwpDq1E9W6O0lfPlfIT1qOKnHREjmYrcJW9QDwvdgPTeo5fLO2DJQkNjmJPWuZXXSBjnwlKeA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com; arc=none smtp.client-ip=209.85.166.71
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com
Received: by mail-io1-f71.google.com with SMTP id ca18e2360f4ac-945c705df24so60971439f.0
        for <syzbot@lists.linux.dev>; Wed, 05 Nov 2025 22:56:44 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1762412204; x=1763017004;
        h=content-transfer-encoding:cc:to:from:subject:message-id:date
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=ZGWssMGNuzcmxP4k9X8kIfSWInjTlj6nu5r0dbgkCcI=;
        b=PVzPvwICdz9nu7GIyzQJ6NI87aLkBwzby57hSpW2KgDQYm0Ii71mkkDOZV31etEb3e
         1KeZtZ7xZrCFz0v32V8YcBL2J4gHrEI30Y5ZLo2fcpeG5vbG4/Vd2aCCLutIpgoIh0bI
         VYbUkLoB7w7PGlbOtyiKOrkOhmjqyWk+IFFqzBL1ZOCdIC0co06gRQtoDMx88dGeBszr
         qmVu4mxDx1b0iOLj4ZAzpv5gY3jMY4SFMGbvyBph2i81brPyURtXpJv+QEklXUxmA2MB
         ON7yjPYqU6MNzdU7/3GVzLZCyQv5MfsyzkYnHdtkSh8LELk9r/Bz5b9spiI305ePIf5X
         kZ/w==
X-Gm-Message-State: AOJu0Yw9ExBPPU07mFko1yTLvyV+R1aoywc8zkjZULjyzVPXLXVxdTU/
	M6G0MQ76IbblYFsD5aIqvjPu+kamCBiII8HjFelYtKnwHOBRpptVaIQhF8Z8o93WKnp+npX0gB3
	oFQjtJ5kdBRIyAm3MKtzXBUxOinyqxgS20Ju8yqzt8u5P6OFMSg4zIMUujiI=
X-Google-Smtp-Source: AGHT+IEy4YbBrNdYR/0vr0Ji8hDyjJ7DKtq5dA+c2K5qkwASFDG0YU4bk31RMxs1aGUIoMZx18+mKysFUZmq1QzPiEXD63wkR5l5
Precedence: bulk
X-Mailing-List: syzbot@lists.linux.dev
List-Id: <syzbot.lists.linux.dev>
List-Subscribe: <mailto:syzbot+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:syzbot+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Received: by 2002:a05:6602:1643:b0:945:aa01:bab7 with SMTP id
 ca18e2360f4ac-9487957e9ebmr363727339f.5.1762412204138; Wed, 05 Nov 2025
 22:56:44 -0800 (PST)
Date: Wed, 05 Nov 2025 22:56:44 -0800
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <690c46ac.050a0220.3d0d33.00f4.GAE@google.com>
Subject: [moderation/CI] Re: Create and use APIs to centralise locking for
 directory ops.
From: syzbot ci <syzbot+ci1ce9af2db196de26@syzkaller.appspotmail.com>
To: syzkaller-upstream-moderation@googlegroups.com
Cc: syzbot@lists.linux.dev
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

syzbot ci has tested the following series

[v5] Create and use APIs to centralise locking for directory ops.
https://lore.kernel.org/all/20251106005333.956321-1-neilb@ownmail.net
* [PATCH v5 01/14] debugfs: rename end_creating() to debugfs_end_creating()
* [PATCH v5 02/14] VFS: introduce start_dirop() and end_dirop()
* [PATCH v5 03/14] VFS: tidy up do_unlinkat()
* [PATCH v5 04/14] VFS/nfsd/cachefiles/ovl: add start_creating() and end_cr=
eating()
* [PATCH v5 05/14] VFS/nfsd/cachefiles/ovl: introduce start_removing() and =
end_removing()
* [PATCH v5 06/14] VFS: introduce start_creating_noperm() and start_removin=
g_noperm()
* [PATCH v5 07/14] VFS: introduce start_removing_dentry()
* [PATCH v5 08/14] VFS: add start_creating_killable() and start_removing_ki=
llable()
* [PATCH v5 09/14] VFS/nfsd/ovl: introduce start_renaming() and end_renamin=
g()
* [PATCH v5 10/14] VFS/ovl/smb: introduce start_renaming_dentry()
* [PATCH v5 11/14] Add start_renaming_two_dentries()
* [PATCH v5 12/14] ecryptfs: use new start_creating/start_removing APIs
* [PATCH v5 13/14] VFS: change vfs_mkdir() to unlock on failure.
* [PATCH v5 14/14] VFS: introduce end_creating_keep()

and found the following issues:
* WARNING: lock held when returning to user space in start_creating
* possible deadlock in mnt_want_write

Full report is available here:
https://ci.syzbot.org/series/4f406e4d-6aba-457a-b9c1-21f4407176a0

***

WARNING: lock held when returning to user space in start_creating

tree:      torvalds
URL:       https://kernel.googlesource.com/pub/scm/linux/kernel/git/torvald=
s/linux
base:      6146a0f1dfae5d37442a9ddcba012add260bceb0
arch:      amd64
compiler:  Debian clang version 20.1.8 (++20250708063551+0c9f909b7976-1~exp=
1~20250708183702.136), Debian LLD 20.1.8
config:    https://ci.syzbot.org/builds/49013fb4-56ed-423c-8e15-252d65d5c1b=
4/config
C repro:   https://ci.syzbot.org/findings/403597e5-81d3-4a9e-8d43-cf15c00b3=
265/c_repro
syz repro: https://ci.syzbot.org/findings/403597e5-81d3-4a9e-8d43-cf15c00b3=
265/syz_repro

UDF-fs: INFO Mounting volume 'LinuxUDF', timestamp 2022/11/22 14:59 (1000)
overlayfs: upper fs needs to support d_type.
overlayfs: upper fs does not support tmpfile.
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
WARNING: lock held when returning to user space!
syzkaller #0 Not tainted
------------------------------------------------
syz.0.17/5964 is leaving the kernel with locks still held!
1 lock held by syz.0.17/5964:
 #0: ffff888119a282a0 (&type->i_mutex_dir_key#8/1){+.+.}-{4:4}, at: inode_l=
ock_nested include/linux/fs.h:1025 [inline]
 #0: ffff888119a282a0 (&type->i_mutex_dir_key#8/1){+.+.}-{4:4}, at: __start=
_dirop fs/namei.c:2794 [inline]
 #0: ffff888119a282a0 (&type->i_mutex_dir_key#8/1){+.+.}-{4:4}, at: start_d=
irop fs/namei.c:2805 [inline]
 #0: ffff888119a282a0 (&type->i_mutex_dir_key#8/1){+.+.}-{4:4}, at: start_c=
reating+0xbe/0x100 fs/namei.c:3261


***

possible deadlock in mnt_want_write

tree:      torvalds
URL:       https://kernel.googlesource.com/pub/scm/linux/kernel/git/torvald=
s/linux
base:      6146a0f1dfae5d37442a9ddcba012add260bceb0
arch:      amd64
compiler:  Debian clang version 20.1.8 (++20250708063551+0c9f909b7976-1~exp=
1~20250708183702.136), Debian LLD 20.1.8
config:    https://ci.syzbot.org/builds/49013fb4-56ed-423c-8e15-252d65d5c1b=
4/config
syz repro: https://ci.syzbot.org/findings/7d1f626d-9979-4c5b-b36b-5616a983b=
0ac/syz_repro

=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D
WARNING: possible circular locking dependency detected
syzkaller #0 Not tainted
------------------------------------------------------
syz.0.17/6011 is trying to acquire lock:
ffff88810943c420
 (sb_writers#12){.+.+}-{0:0}, at: mnt_want_write+0x41/0x90 fs/namespace.c:5=
08

but task is already holding lock:
ffff888169f40940 (&type->i_mutex_dir_key#5/1){+.+.}-{4:4}, at: inode_lock_n=
ested include/linux/fs.h:1025 [inline]
ffff888169f40940 (&type->i_mutex_dir_key#5/1){+.+.}-{4:4}, at: __start_diro=
p fs/namei.c:2794 [inline]
ffff888169f40940 (&type->i_mutex_dir_key#5/1){+.+.}-{4:4}, at: start_dirop =
fs/namei.c:2805 [inline]
ffff888169f40940 (&type->i_mutex_dir_key#5/1){+.+.}-{4:4}, at: start_creati=
ng+0xbe/0x100 fs/namei.c:3261

which lock already depends on the new lock.


the existing dependency chain (in reverse order) is:

-> #1 (&type->i_mutex_dir_key#5/1){+.+.}-{4:4}:
       reacquire_held_locks+0x127/0x1d0 kernel/locking/lockdep.c:5385
       __lock_release kernel/locking/lockdep.c:5574 [inline]
       lock_release+0x1b4/0x3e0 kernel/locking/lockdep.c:5889
       up_write+0x2d/0x420 kernel/locking/rwsem.c:1642
       inode_unlock include/linux/fs.h:990 [inline]
       end_dirop fs/namei.c:2818 [inline]
       end_creating include/linux/namei.h:125 [inline]
       vfs_mkdir+0x111/0x570 fs/namei.c:5037
       do_mkdirat+0x247/0x5e0 fs/namei.c:5058
       __do_sys_mkdir fs/namei.c:5080 [inline]
       __se_sys_mkdir fs/namei.c:5078 [inline]
       __x64_sys_mkdir+0x6c/0x80 fs/namei.c:5078
       do_syscall_x64 arch/x86/entry/syscall_64.c:63 [inline]
       do_syscall_64+0xfa/0xfa0 arch/x86/entry/syscall_64.c:94
       entry_SYSCALL_64_after_hwframe+0x77/0x7f

-> #0 (sb_writers#12){.+.+}-{0:0}:
       check_prev_add kernel/locking/lockdep.c:3165 [inline]
       check_prevs_add kernel/locking/lockdep.c:3284 [inline]
       validate_chain+0xb9b/0x2140 kernel/locking/lockdep.c:3908
       __lock_acquire+0xab9/0xd20 kernel/locking/lockdep.c:5237
       lock_acquire+0x120/0x360 kernel/locking/lockdep.c:5868
       percpu_down_read_internal include/linux/percpu-rwsem.h:53 [inline]
       percpu_down_read_freezable include/linux/percpu-rwsem.h:83 [inline]
       __sb_start_write include/linux/fs.h:1916 [inline]
       sb_start_write+0x4d/0x1c0 include/linux/fs.h:2052
       mnt_want_write+0x41/0x90 fs/namespace.c:508
       filename_create+0x14f/0x360 fs/namei.c:4785
       do_mkdirat+0x32c/0x5e0 fs/namei.c:5050
       __do_sys_mkdir fs/namei.c:5080 [inline]
       __se_sys_mkdir fs/namei.c:5078 [inline]
       __x64_sys_mkdir+0x6c/0x80 fs/namei.c:5078
       do_syscall_x64 arch/x86/entry/syscall_64.c:63 [inline]
       do_syscall_64+0xfa/0xfa0 arch/x86/entry/syscall_64.c:94
       entry_SYSCALL_64_after_hwframe+0x77/0x7f

other info that might help us debug this:

 Possible unsafe locking scenario:

       CPU0                    CPU1
       ----                    ----
  lock(&type->i_mutex_dir_key#5/1);
                               lock(sb_writers#12);
                               lock(&type->i_mutex_dir_key#5/1);
  rlock(sb_writers#12);

 *** DEADLOCK ***

1 lock held by syz.0.17/6011:
 #0: ffff888169f40940 (&type->i_mutex_dir_key#5/1){+.+.}-{4:4}, at: inode_l=
ock_nested include/linux/fs.h:1025 [inline]
 #0: ffff888169f40940 (&type->i_mutex_dir_key#5/1){+.+.}-{4:4}, at: __start=
_dirop fs/namei.c:2794 [inline]
 #0: ffff888169f40940 (&type->i_mutex_dir_key#5/1){+.+.}-{4:4}, at: start_d=
irop fs/namei.c:2805 [inline]
 #0: ffff888169f40940 (&type->i_mutex_dir_key#5/1){+.+.}-{4:4}, at: start_c=
reating+0xbe/0x100 fs/namei.c:3261

stack backtrace:
CPU: 1 UID: 0 PID: 6011 Comm: syz.0.17 Not tainted syzkaller #0 PREEMPT(ful=
l)=20
Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS 1.16.2-debian-1.16=
.2-1 04/01/2014
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
 percpu_down_read_internal include/linux/percpu-rwsem.h:53 [inline]
 percpu_down_read_freezable include/linux/percpu-rwsem.h:83 [inline]
 __sb_start_write include/linux/fs.h:1916 [inline]
 sb_start_write+0x4d/0x1c0 include/linux/fs.h:2052
 mnt_want_write+0x41/0x90 fs/namespace.c:508
 filename_create+0x14f/0x360 fs/namei.c:4785
 do_mkdirat+0x32c/0x5e0 fs/namei.c:5050
 __do_sys_mkdir fs/namei.c:5080 [inline]
 __se_sys_mkdir fs/namei.c:5078 [inline]
 __x64_sys_mkdir+0x6c/0x80 fs/namei.c:5078
 do_syscall_x64 arch/x86/entry/syscall_64.c:63 [inline]
 do_syscall_64+0xfa/0xfa0 arch/x86/entry/syscall_64.c:94
 entry_SYSCALL_64_after_hwframe+0x77/0x7f
RIP: 0033:0x7fdc9a98efc9
Code: ff ff c3 66 2e 0f 1f 84 00 00 00 00 00 0f 1f 40 00 48 89 f8 48 89 f7 =
48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 ff f=
f 73 01 c3 48 c7 c1 a8 ff ff ff f7 d8 64 89 01 48
RSP: 002b:00007fdc9b79b038 EFLAGS: 00000246 ORIG_RAX: 0000000000000053
RAX: ffffffffffffffda RBX: 00007fdc9abe5fa0 RCX: 00007fdc9a98efc9
RDX: 0000000000000000 RSI: 0000000000000000 RDI: 00002000000008c0
RBP: 00007fdc9aa11f91 R08: 0000000000000000 R09: 0000000000000000
R10: 0000000000000000 R11: 0000000000000246 R12: 0000000000000000
R13: 00007fdc9abe6038 R14: 00007fdc9abe5fa0 R15: 00007ffe4d481c38
 </TASK>


***

If these findings have caused you to resend the series or submit a
separate fix, please add the following tag to your commit message:
  Tested-by: syzbot@syzkaller.appspotmail.com

---
This report is generated by a bot. It may contain errors.
syzbot ci engineers can be reached at syzkaller@googlegroups.com.

The email will later be sent to:
[amir73il@gmail.com brauner@kernel.org cem@kernel.org chuck.lever@oracle.co=
m clm@fb.com code@tyhicks.com dai.ngo@oracle.com dakr@kernel.org dhowells@r=
edhat.com djwong@kernel.org dsterba@suse.com ecryptfs@vger.kernel.org gregk=
h@linuxfoundation.org jack@suse.cz jlayton@kernel.org jmorris@namei.org joh=
n.johansen@canonical.com linkinjeon@kernel.org linux-cifs@vger.kernel.org l=
inux-fsdevel@vger.kernel.org linux-kernel@vger.kernel.org linux-nfs@vger.ke=
rnel.org linux-security-module@vger.kernel.org linux-unionfs@vger.kernel.or=
g linux-xfs@vger.kernel.org lorenzo.stoakes@oracle.com miklos@szeredi.hu mj=
guzik@gmail.com neilb@ownmail.net netfs@lists.linux.dev okorniev@redhat.com=
 omosnace@redhat.com paul@paul-moore.com rafael@kernel.org selinux@vger.ker=
nel.org senozhatsky@chromium.org serge@hallyn.com smfrench@gmail.com stefan=
b@linux.ibm.com stephen.smalley.work@gmail.com viro@zeniv.linux.org.uk]

If the report looks fine to you, reply with:
#syz upstream

