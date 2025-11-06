Received: from mail-oo1-f42.google.com (mail-oo1-f42.google.com [209.85.161.42])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C7306303CBB
	for <syzbot@lists.linux.dev>; Thu,  6 Nov 2025 09:00:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.161.42
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762419606; cv=none; b=WcAKizk3ZS2Xvb79mdHnG0wNb2CojXQC0swHdh3KoYiiEQzaJvPx2G61BxEzP0GHaBa0+sj+I4w2GcgvUaZrCAOWDr9398PErwddCgXB3s/r9W23Ft7H2N/KfCEUyQ24/K6q/vpjgbNtxfOZd/0PUjWKeZROYTL+lh/KMObGcnY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762419606; c=relaxed/simple;
	bh=u+KkynJZB7l0sqtR7CXcLpH83kNFveIu7JcXE2UOTCU=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=k82MyadbwsDIMAwoZqOL3PvURowPiBiYIrkpdC0rY5wULUU2InuGzavtgQ4oNkIZpSYdR/5KlRr0bnQ+me1F26J57g6BxhZn7fBeRx0zWLd2wceSytWbt7Ph9NF6L+55eLTBJPDsn9mpXPrDoP93bhYS7huZqp8iZHnrSX+Fq5k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=AGdGVvr3; arc=none smtp.client-ip=209.85.161.42
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="AGdGVvr3"
Received: by mail-oo1-f42.google.com with SMTP id 006d021491bc7-656bb297e31so182018eaf.0
        for <syzbot@lists.linux.dev>; Thu, 06 Nov 2025 01:00:04 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1762419604; x=1763024404; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=69gFLSM4KLdObCaImVhslqwrK3w9gjqhPSj2n6OX78I=;
        b=AGdGVvr3Jp64/keNEkLxc+xc3pJvHsUQClfXGEvbJy6kVWsDydKjzXIMrn7pWuvsa6
         GZcumiYKmKUxW1NdSFCIOFUkuR+CxS458n+G/a5adJ0fKXWpAV81RP4YGSlbiVH4T6BN
         /TIfPe8fqly4OGch8zGQ9Nm3W336mUzyWHF6iPd14RsluD2pvF6yYKEP3+3f+eBaAtNd
         1k28cSEzvv6Gl/yPMTUgxxhArRa2Eqw02og0Mgwh0C6aliWyazQlRs9UFIMav0i4ogLE
         vWa9U3UogIUWU1jCeZXHxqpJajjZ82n9UVHM0Fu2M0c+rLUUaypBl21Ph2wW2ed3wPKe
         efMw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1762419604; x=1763024404;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=69gFLSM4KLdObCaImVhslqwrK3w9gjqhPSj2n6OX78I=;
        b=Q0OH40u4y2uyyfAkI7qlXUIforsRgZX+KKkf6/QqGiy4PeQrSfxmMqTWyrGXSo1bwN
         LWhQ40YhJCgGIqtVHBm7gIkTILNozGuvR2zx2xbn2gpUYVeW5w38kOFLzV18afPVAifA
         +PCe5FwQw5fihODi/KooOsD4pQA+Tgb1Ra69r1nUjObAbGpJsyu2i2RK8/u4J0U3orTB
         tUl1IHzwpmwaEwmWRVbI/qBxK1E5FP2JvMm7p0LXBSw+NOVMnWY6ZKQIYkxT7cYGfIIm
         5AoTEuJS6M0i4ss8UwbBGFDDNWN+ro0Dcoh/OPSnluqIhwi8i4a0TfCfe6gwXlQMy23w
         Jalw==
X-Forwarded-Encrypted: i=1; AJvYcCUTUsdJAski1w8rZGc27eJFpgcUhb5kw20EYsPxGcZ2mi6vT7rQVzcqjhDPMp/InzwfcB9CSt0=@lists.linux.dev
X-Gm-Message-State: AOJu0Yxa+Ct+OvVbUxd0VVXhknnLq0KPZEcLiTXaT93AgG7ASpRTxLvX
	WuWBlyJZ2umGCXj6SJmGuFAB3X9NTLbHDSwJT3WT9mcxepBT7DJPbCN/t9a6SF7zJimndMjmxiM
	UsPdPjhKpKl2CRTDlBupUsiiUVp6K+mAYK5D4N8qN
X-Gm-Gg: ASbGncsEt9kINxO2YRyCFsuSeGnRilGvxWvAo8RtsgribSF9mB2pbn/KNf+VSXwwfoO
	qEdBGn13hPHP1hj68LHWLuxmXTaMhPvSyVjWF1/fQumEwnZcr6Lc+l8o8l9ij2rdXJpiIHH9gBh
	5UdbDMikv6QP+1ctBBbkfZBgDb+NP2X9W1/Gg9zO48/IPgabBih8pMLUmCo977VP4T5tR6bpj9V
	deHu2JJo0YR4V2/vUeHE1mWfWtDRi0iQ+3DN/EN1OwVACMbfuy23uNlDm+1KOf2GMYs8YxlKBJ+
	nnqq9Hr34PqB7cc5aaOmuw5YdiYN+a3ToooffqRmGn/tKdu2NhT7BibmVg==
X-Google-Smtp-Source: AGHT+IFL1EOMb8IsN4yY6KqiKjLNtB3bg5tmHvPM/wsNmoBnP3/2lES9tIwl6PT0hSBC+RLzKCcTazALXoeaxDlFEBk=
X-Received: by 2002:a05:6820:1ca4:b0:654:eea7:9c17 with SMTP id
 006d021491bc7-656bb61dac0mr3020704eaf.4.1762419603590; Thu, 06 Nov 2025
 01:00:03 -0800 (PST)
Precedence: bulk
X-Mailing-List: syzbot@lists.linux.dev
List-Id: <syzbot.lists.linux.dev>
List-Subscribe: <mailto:syzbot+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:syzbot+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <690c46ac.050a0220.3d0d33.00f4.GAE@google.com>
In-Reply-To: <690c46ac.050a0220.3d0d33.00f4.GAE@google.com>
From: Aleksandr Nogikh <nogikh@google.com>
Date: Thu, 6 Nov 2025 09:59:52 +0100
X-Gm-Features: AWmQ_bnvZet3UwZFOt3ji13c-UQfPB6JIzQfgrIDb-kar1hC6V9XGStfz7F5nXY
Message-ID: <CANp29Y6E66=PL1_GUtXqXp9zhN8u_AVnWGbwBfba4gh4hGkGrw@mail.gmail.com>
Subject: Re: [moderation/CI] Re: Create and use APIs to centralise locking for
 directory ops.
To: syzbot ci <syzbot+ci1ce9af2db196de26@syzkaller.appspotmail.com>
Cc: syzkaller-upstream-moderation@googlegroups.com, syzbot@lists.linux.dev
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

#syz upstream


On Thu, Nov 6, 2025 at 7:56=E2=80=AFAM syzbot ci
<syzbot+ci1ce9af2db196de26@syzkaller.appspotmail.com> wrote:
>
> syzbot ci has tested the following series
>
> [v5] Create and use APIs to centralise locking for directory ops.
> https://lore.kernel.org/all/20251106005333.956321-1-neilb@ownmail.net
> * [PATCH v5 01/14] debugfs: rename end_creating() to debugfs_end_creating=
()
> * [PATCH v5 02/14] VFS: introduce start_dirop() and end_dirop()
> * [PATCH v5 03/14] VFS: tidy up do_unlinkat()
> * [PATCH v5 04/14] VFS/nfsd/cachefiles/ovl: add start_creating() and end_=
creating()
> * [PATCH v5 05/14] VFS/nfsd/cachefiles/ovl: introduce start_removing() an=
d end_removing()
> * [PATCH v5 06/14] VFS: introduce start_creating_noperm() and start_remov=
ing_noperm()
> * [PATCH v5 07/14] VFS: introduce start_removing_dentry()
> * [PATCH v5 08/14] VFS: add start_creating_killable() and start_removing_=
killable()
> * [PATCH v5 09/14] VFS/nfsd/ovl: introduce start_renaming() and end_renam=
ing()
> * [PATCH v5 10/14] VFS/ovl/smb: introduce start_renaming_dentry()
> * [PATCH v5 11/14] Add start_renaming_two_dentries()
> * [PATCH v5 12/14] ecryptfs: use new start_creating/start_removing APIs
> * [PATCH v5 13/14] VFS: change vfs_mkdir() to unlock on failure.
> * [PATCH v5 14/14] VFS: introduce end_creating_keep()
>
> and found the following issues:
> * WARNING: lock held when returning to user space in start_creating
> * possible deadlock in mnt_want_write
>
> Full report is available here:
> https://ci.syzbot.org/series/4f406e4d-6aba-457a-b9c1-21f4407176a0
>
> ***
>
> WARNING: lock held when returning to user space in start_creating
>
> tree:      torvalds
> URL:       https://kernel.googlesource.com/pub/scm/linux/kernel/git/torva=
lds/linux
> base:      6146a0f1dfae5d37442a9ddcba012add260bceb0
> arch:      amd64
> compiler:  Debian clang version 20.1.8 (++20250708063551+0c9f909b7976-1~e=
xp1~20250708183702.136), Debian LLD 20.1.8
> config:    https://ci.syzbot.org/builds/49013fb4-56ed-423c-8e15-252d65d5c=
1b4/config
> C repro:   https://ci.syzbot.org/findings/403597e5-81d3-4a9e-8d43-cf15c00=
b3265/c_repro
> syz repro: https://ci.syzbot.org/findings/403597e5-81d3-4a9e-8d43-cf15c00=
b3265/syz_repro
>
> UDF-fs: INFO Mounting volume 'LinuxUDF', timestamp 2022/11/22 14:59 (1000=
)
> overlayfs: upper fs needs to support d_type.
> overlayfs: upper fs does not support tmpfile.
> =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
> WARNING: lock held when returning to user space!
> syzkaller #0 Not tainted
> ------------------------------------------------
> syz.0.17/5964 is leaving the kernel with locks still held!
> 1 lock held by syz.0.17/5964:
>  #0: ffff888119a282a0 (&type->i_mutex_dir_key#8/1){+.+.}-{4:4}, at: inode=
_lock_nested include/linux/fs.h:1025 [inline]
>  #0: ffff888119a282a0 (&type->i_mutex_dir_key#8/1){+.+.}-{4:4}, at: __sta=
rt_dirop fs/namei.c:2794 [inline]
>  #0: ffff888119a282a0 (&type->i_mutex_dir_key#8/1){+.+.}-{4:4}, at: start=
_dirop fs/namei.c:2805 [inline]
>  #0: ffff888119a282a0 (&type->i_mutex_dir_key#8/1){+.+.}-{4:4}, at: start=
_creating+0xbe/0x100 fs/namei.c:3261
>
>
> ***
>
> possible deadlock in mnt_want_write
>
> tree:      torvalds
> URL:       https://kernel.googlesource.com/pub/scm/linux/kernel/git/torva=
lds/linux
> base:      6146a0f1dfae5d37442a9ddcba012add260bceb0
> arch:      amd64
> compiler:  Debian clang version 20.1.8 (++20250708063551+0c9f909b7976-1~e=
xp1~20250708183702.136), Debian LLD 20.1.8
> config:    https://ci.syzbot.org/builds/49013fb4-56ed-423c-8e15-252d65d5c=
1b4/config
> syz repro: https://ci.syzbot.org/findings/7d1f626d-9979-4c5b-b36b-5616a98=
3b0ac/syz_repro
>
> =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D
> WARNING: possible circular locking dependency detected
> syzkaller #0 Not tainted
> ------------------------------------------------------
> syz.0.17/6011 is trying to acquire lock:
> ffff88810943c420
>  (sb_writers#12){.+.+}-{0:0}, at: mnt_want_write+0x41/0x90 fs/namespace.c=
:508
>
> but task is already holding lock:
> ffff888169f40940 (&type->i_mutex_dir_key#5/1){+.+.}-{4:4}, at: inode_lock=
_nested include/linux/fs.h:1025 [inline]
> ffff888169f40940 (&type->i_mutex_dir_key#5/1){+.+.}-{4:4}, at: __start_di=
rop fs/namei.c:2794 [inline]
> ffff888169f40940 (&type->i_mutex_dir_key#5/1){+.+.}-{4:4}, at: start_diro=
p fs/namei.c:2805 [inline]
> ffff888169f40940 (&type->i_mutex_dir_key#5/1){+.+.}-{4:4}, at: start_crea=
ting+0xbe/0x100 fs/namei.c:3261
>
> which lock already depends on the new lock.
>
>
> the existing dependency chain (in reverse order) is:
>
> -> #1 (&type->i_mutex_dir_key#5/1){+.+.}-{4:4}:
>        reacquire_held_locks+0x127/0x1d0 kernel/locking/lockdep.c:5385
>        __lock_release kernel/locking/lockdep.c:5574 [inline]
>        lock_release+0x1b4/0x3e0 kernel/locking/lockdep.c:5889
>        up_write+0x2d/0x420 kernel/locking/rwsem.c:1642
>        inode_unlock include/linux/fs.h:990 [inline]
>        end_dirop fs/namei.c:2818 [inline]
>        end_creating include/linux/namei.h:125 [inline]
>        vfs_mkdir+0x111/0x570 fs/namei.c:5037
>        do_mkdirat+0x247/0x5e0 fs/namei.c:5058
>        __do_sys_mkdir fs/namei.c:5080 [inline]
>        __se_sys_mkdir fs/namei.c:5078 [inline]
>        __x64_sys_mkdir+0x6c/0x80 fs/namei.c:5078
>        do_syscall_x64 arch/x86/entry/syscall_64.c:63 [inline]
>        do_syscall_64+0xfa/0xfa0 arch/x86/entry/syscall_64.c:94
>        entry_SYSCALL_64_after_hwframe+0x77/0x7f
>
> -> #0 (sb_writers#12){.+.+}-{0:0}:
>        check_prev_add kernel/locking/lockdep.c:3165 [inline]
>        check_prevs_add kernel/locking/lockdep.c:3284 [inline]
>        validate_chain+0xb9b/0x2140 kernel/locking/lockdep.c:3908
>        __lock_acquire+0xab9/0xd20 kernel/locking/lockdep.c:5237
>        lock_acquire+0x120/0x360 kernel/locking/lockdep.c:5868
>        percpu_down_read_internal include/linux/percpu-rwsem.h:53 [inline]
>        percpu_down_read_freezable include/linux/percpu-rwsem.h:83 [inline=
]
>        __sb_start_write include/linux/fs.h:1916 [inline]
>        sb_start_write+0x4d/0x1c0 include/linux/fs.h:2052
>        mnt_want_write+0x41/0x90 fs/namespace.c:508
>        filename_create+0x14f/0x360 fs/namei.c:4785
>        do_mkdirat+0x32c/0x5e0 fs/namei.c:5050
>        __do_sys_mkdir fs/namei.c:5080 [inline]
>        __se_sys_mkdir fs/namei.c:5078 [inline]
>        __x64_sys_mkdir+0x6c/0x80 fs/namei.c:5078
>        do_syscall_x64 arch/x86/entry/syscall_64.c:63 [inline]
>        do_syscall_64+0xfa/0xfa0 arch/x86/entry/syscall_64.c:94
>        entry_SYSCALL_64_after_hwframe+0x77/0x7f
>
> other info that might help us debug this:
>
>  Possible unsafe locking scenario:
>
>        CPU0                    CPU1
>        ----                    ----
>   lock(&type->i_mutex_dir_key#5/1);
>                                lock(sb_writers#12);
>                                lock(&type->i_mutex_dir_key#5/1);
>   rlock(sb_writers#12);
>
>  *** DEADLOCK ***
>
> 1 lock held by syz.0.17/6011:
>  #0: ffff888169f40940 (&type->i_mutex_dir_key#5/1){+.+.}-{4:4}, at: inode=
_lock_nested include/linux/fs.h:1025 [inline]
>  #0: ffff888169f40940 (&type->i_mutex_dir_key#5/1){+.+.}-{4:4}, at: __sta=
rt_dirop fs/namei.c:2794 [inline]
>  #0: ffff888169f40940 (&type->i_mutex_dir_key#5/1){+.+.}-{4:4}, at: start=
_dirop fs/namei.c:2805 [inline]
>  #0: ffff888169f40940 (&type->i_mutex_dir_key#5/1){+.+.}-{4:4}, at: start=
_creating+0xbe/0x100 fs/namei.c:3261
>
> stack backtrace:
> CPU: 1 UID: 0 PID: 6011 Comm: syz.0.17 Not tainted syzkaller #0 PREEMPT(f=
ull)
> Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS 1.16.2-debian-1.=
16.2-1 04/01/2014
> Call Trace:
>  <TASK>
>  dump_stack_lvl+0x189/0x250 lib/dump_stack.c:120
>  print_circular_bug+0x2ee/0x310 kernel/locking/lockdep.c:2043
>  check_noncircular+0x134/0x160 kernel/locking/lockdep.c:2175
>  check_prev_add kernel/locking/lockdep.c:3165 [inline]
>  check_prevs_add kernel/locking/lockdep.c:3284 [inline]
>  validate_chain+0xb9b/0x2140 kernel/locking/lockdep.c:3908
>  __lock_acquire+0xab9/0xd20 kernel/locking/lockdep.c:5237
>  lock_acquire+0x120/0x360 kernel/locking/lockdep.c:5868
>  percpu_down_read_internal include/linux/percpu-rwsem.h:53 [inline]
>  percpu_down_read_freezable include/linux/percpu-rwsem.h:83 [inline]
>  __sb_start_write include/linux/fs.h:1916 [inline]
>  sb_start_write+0x4d/0x1c0 include/linux/fs.h:2052
>  mnt_want_write+0x41/0x90 fs/namespace.c:508
>  filename_create+0x14f/0x360 fs/namei.c:4785
>  do_mkdirat+0x32c/0x5e0 fs/namei.c:5050
>  __do_sys_mkdir fs/namei.c:5080 [inline]
>  __se_sys_mkdir fs/namei.c:5078 [inline]
>  __x64_sys_mkdir+0x6c/0x80 fs/namei.c:5078
>  do_syscall_x64 arch/x86/entry/syscall_64.c:63 [inline]
>  do_syscall_64+0xfa/0xfa0 arch/x86/entry/syscall_64.c:94
>  entry_SYSCALL_64_after_hwframe+0x77/0x7f
> RIP: 0033:0x7fdc9a98efc9
> Code: ff ff c3 66 2e 0f 1f 84 00 00 00 00 00 0f 1f 40 00 48 89 f8 48 89 f=
7 48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 ff=
 ff 73 01 c3 48 c7 c1 a8 ff ff ff f7 d8 64 89 01 48
> RSP: 002b:00007fdc9b79b038 EFLAGS: 00000246 ORIG_RAX: 0000000000000053
> RAX: ffffffffffffffda RBX: 00007fdc9abe5fa0 RCX: 00007fdc9a98efc9
> RDX: 0000000000000000 RSI: 0000000000000000 RDI: 00002000000008c0
> RBP: 00007fdc9aa11f91 R08: 0000000000000000 R09: 0000000000000000
> R10: 0000000000000000 R11: 0000000000000246 R12: 0000000000000000
> R13: 00007fdc9abe6038 R14: 00007fdc9abe5fa0 R15: 00007ffe4d481c38
>  </TASK>
>
>
> ***
>
> If these findings have caused you to resend the series or submit a
> separate fix, please add the following tag to your commit message:
>   Tested-by: syzbot@syzkaller.appspotmail.com
>
> ---
> This report is generated by a bot. It may contain errors.
> syzbot ci engineers can be reached at syzkaller@googlegroups.com.
>
> The email will later be sent to:
> [amir73il@gmail.com brauner@kernel.org cem@kernel.org chuck.lever@oracle.=
com clm@fb.com code@tyhicks.com dai.ngo@oracle.com dakr@kernel.org dhowells=
@redhat.com djwong@kernel.org dsterba@suse.com ecryptfs@vger.kernel.org gre=
gkh@linuxfoundation.org jack@suse.cz jlayton@kernel.org jmorris@namei.org j=
ohn.johansen@canonical.com linkinjeon@kernel.org linux-cifs@vger.kernel.org=
 linux-fsdevel@vger.kernel.org linux-kernel@vger.kernel.org linux-nfs@vger.=
kernel.org linux-security-module@vger.kernel.org linux-unionfs@vger.kernel.=
org linux-xfs@vger.kernel.org lorenzo.stoakes@oracle.com miklos@szeredi.hu =
mjguzik@gmail.com neilb@ownmail.net netfs@lists.linux.dev okorniev@redhat.c=
om omosnace@redhat.com paul@paul-moore.com rafael@kernel.org selinux@vger.k=
ernel.org senozhatsky@chromium.org serge@hallyn.com smfrench@gmail.com stef=
anb@linux.ibm.com stephen.smalley.work@gmail.com viro@zeniv.linux.org.uk]
>
> If the report looks fine to you, reply with:
> #syz upstream
>
> --
> You received this message because you are subscribed to the Google Groups=
 "syzkaller-upstream-moderation" group.
> To unsubscribe from this group and stop receiving emails from it, send an=
 email to syzkaller-upstream-moderation+unsubscribe@googlegroups.com.
> To view this discussion visit https://groups.google.com/d/msgid/syzkaller=
-upstream-moderation/690c46ac.050a0220.3d0d33.00f4.GAE%40google.com.
