Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 178A341F349
	for <syzbot@lists.linux.dev>; Thu, 24 Sep 2026 07:11:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790233893; cv=none; b=EG9ZPe6SOxkkso50YcnPvUFMuCpn3bU/BIu/0W4GqORCrgVcFtmVXhm+uEKzvLFPARfaDMGBZCzLHll/nD1MHQhUZ9tayb+YnkbD2EWrumXsqwFwEsk3Lem2I8VTt4tpgPYajPBcOOQrtcvA6mnniu3+yM6nEwA2FDzW5agSxhc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790233893; c=relaxed/simple;
	bh=AZFes0IHnTuLDOnNQRZYaLXMV/ftOYSjTi59WzyFHEk=;
	h=From:To:Cc:Subject:Message-ID:MIME-Version:Content-Type:Date; b=DuD26fO8Jhz1BOGHfFj+noggPnvCPracIDBW/KasV8NfQVQ1aLg1bzBgWWNrqGek+bIsGI5vw3M8/9JXts4mJXbyNWWDElAqyS0DX1FHpLCMkn2ETHEykXoAemTbSYcKGKPKXXSH7I8J89WinNWb0XGqu7lu2mzJm+hbUrXiVMs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=i2QDZkNw; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="i2QDZkNw"
Received: by smtp.kernel.org (Postfix) with UTF8SMTPSA id A59301F000FF;
	Thu, 24 Sep 2026 07:11:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1790233882;
	bh=4S7gNJL4jhhGdwXOnA6NONPUMnNVSYEvRLBcrVkG0oM=;
	h=From:To:Cc:Subject:Date;
	b=i2QDZkNw9+aqHPd0fIIV4h8dNoASotlRXhnLDxsqeECSsT24g76SOHOusbuhAxu3s
	 OxYEsVQ5f4NSXUTp/ZkxG9dapsrfnw7i6LU8GJRkoUwLy70elvnZYy2swcBqTwflwA
	 3gqS9pbfXM1Qfax4LH7TxG8M+4bR+TYycNx2XWOv4TXyLmiH44vsqROsj017noUlXm
	 jl3Ogw34hwEQ2MdtPUccY7pQ3lAnlfCkJHz78NRGTJsBHY/mVXJ//La9u0Y0QAmNcV
	 NL4ykGB0ZLHFKjbTKrhm5gIDG7Ku0iKpk5sFZob2Tq2eAhA4gGaqgrG3CXzRCp+o2L
	 IL11hj+ILhFyA==
From: "syzbot" <syzbot@kernel.org>
To: syzkaller-upstream-moderation@googlegroups.com
Cc: syzbot@lists.linux.dev
Subject: [PATCH RFC] kernfs: drop splice_write support
Message-ID: <af4efe2d-7856-46ff-9088-28400130dbce@mail.kernel.org>
Precedence: bulk
X-Mailing-List: syzbot@lists.linux.dev
List-Id: <syzbot.lists.linux.dev>
List-Subscribe: <mailto:syzbot+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:syzbot+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Date: Thu, 24 Sep 2026 07:11:22 +0000 (UTC)

A circular locking dependency was detected between &pipe->mutex (in struct
pipe_inode_info), &of->mutex (in struct kernfs_open_file), and
&sbi->pipe_mutex (in struct autofs_sb_info).

The cycle arises from two conflicting execution paths:

First, splicing data from a pipe into a kernfs file (such as a sysfs
attribute) invokes iter_file_splice_write(), which locks the pipe via
pipe_lock(pipe) (&pipe->mutex) and then calls kernfs_fop_write_iter(),
acquiring mutex_lock(&of->mutex). This establishes the dependency
&pipe->mutex -> &of->mutex.

Second, a regular write to a kernfs attribute (such as /sys/power/resume)
acquires mutex_lock(&of->mutex) in kernfs_fop_write_iter() and invokes the
attribute's store handler (resume_store()). In resume_store(), path
resolution via lookup_bdev() and kern_path() can traverse an automount
point managed by autofs. This triggers autofs_d_automount() ->
autofs_wait() -> autofs_notify_daemon(), which acquires
mutex_lock(&sbi->pipe_mutex) and writes a notification packet to the
automount daemon pipe via __kernel_write(). That write enters
anon_pipe_write() -> anon_pipe_prefill_and_lock() and acquires
mutex_lock(&pipe->mutex). This establishes the dependency &of->mutex ->
&sbi->pipe_mutex -> &pipe->mutex.

Because all anonymous pipes share the same lockdep lock class
(&pipe->mutex), this creates an ABBA circular locking dependency:

======================================================
WARNING: possible circular locking dependency detected
======================================================
task is trying to acquire lock:
ffff888113c20c60 (&pipe->mutex){+.+.}-{4:4}, at:
anon_pipe_write+0x28f/0x1a30 fs/pipe.c:534

but task is already holding lock:
ffff888115813938 (&sbi->pipe_mutex){+.+.}-{4:4}, at:
autofs_notify_daemon+0x72a/0xe80 fs/autofs/waitq.c:164

which lock already depends on the new lock.

the existing dependency chain (in reverse order) is:

 -> #2 (&sbi->pipe_mutex){+.+.}-{4:4}:
       __mutex_lock+0x19d/0x1550 kernel/locking/mutex.c:821
       autofs_notify_daemon+0x72a/0xe80 fs/autofs/waitq.c:164
       autofs_wait+0x11bd/0x1880 fs/autofs/waitq.c:426
       autofs_d_automount+0x64e/0x810 fs/autofs/root.c:410
       kern_path+0x3d/0x150 fs/namei.c:3036
       lookup_bdev+0xc8/0x2b0 block/bdev.c:1268
       resume_store+0x16f/0x4f0 kernel/power/hibernate.c:1278
       kernfs_fop_write_iter+0x3a4/0x540 fs/kernfs/file.c:345
       vfs_write+0x612/0xba0 fs/read_write.c:687
       ksys_write+0x150/0x270 fs/read_write.c:739

 -> #1 (&of->mutex){+.+.}-{4:4}:
       __mutex_lock+0x19d/0x1550 kernel/locking/mutex.c:821
       kernfs_fop_write_iter+0x1d8/0x540 fs/kernfs/file.c:336
       iter_file_splice_write+0xa31/0x1240 fs/splice.c:736
       do_splice+0xc3e/0x16a0 fs/splice.c:1349
       __do_sys_splice fs/splice.c:1634 [inline]

 -> #0 (&pipe->mutex){+.+.}-{4:4}:
       __mutex_lock+0x19d/0x1550 kernel/locking/mutex.c:821
       anon_pipe_write+0x28f/0x1a30 fs/pipe.c:534
       __kernel_write+0x106/0x170 fs/read_write.c:641
       autofs_notify_daemon+0x73d/0xe80 fs/autofs/waitq.c:164
       autofs_wait+0x11bd/0x1880 fs/autofs/waitq.c:426
       autofs_d_automount+0x64e/0x810 fs/autofs/root.c:410
       kern_path+0x3d/0x150 fs/namei.c:3036
       lookup_bdev+0xc8/0x2b0 block/bdev.c:1268
       resume_store+0x16f/0x4f0 kernel/power/hibernate.c:1278
       kernfs_fop_write_iter+0x3a4/0x540 fs/kernfs/file.c:345
       vfs_write+0x612/0xba0 fs/read_write.c:687
       ksys_write+0x150/0x270 fs/read_write.c:739

Fix this by removing .splice_write = iter_file_splice_write from
kernfs_file_fops. Kernfs attributes (sysfs, cgroupfs) are control
interfaces designed for small configuration strings and numbers, rather
than high-throughput data streams. Kernfs does not do page-cache zero-copy
writes; kernfs_fop_write_iter() allocates a kernel buffer and copies data
from the iterator via copy_from_iter(), so splice_write provides no benefit
over write(). In addition, kernfs write callbacks invoke arbitrary
subsystem callbacks across the kernel, and holding a generic VFS lock like
pipe->mutex across them breaks subsystem layering and creates lock
inversion hazards whenever an attribute callback interacts with pipes,
usermode helpers, or automounts. Dropping .splice_write aligns kernfs with
other pseudo-filesystems such as procfs, debugfs, tracefs, and configfs,
and causes splice() into a kernfs file to return -EINVAL.

Fixes: f2d6c2708bd8 ("kernfs: wire up ->splice_read and ->splice_write")

Fixes: f2d6c2708bd8 ("kernfs: wire up ->splice_read and ->splice_write")
Assisted-by: Gemini:gemini-3.8-flash Gemini:gemini-3.1-pro-preview syzbot
Reported-by: syzbot+002fb7b2d0bc53bf7e75@syzkaller.appspotmail.com
Closes: https://syzkaller.appspot.com/bug?extid=002fb7b2d0bc53bf7e75
Link: https://syzkaller.appspot.com/ai_job?id=b88d0e47-6c54-4575-a4c8-62628424d6ba
To: <driver-core@lists.linux.dev>
To: "Greg Kroah-Hartman" <gregkh@linuxfoundation.org>
To: "Tejun Heo" <tj@kernel.org>
To: "Christoph Hellwig" <hch@lst.de>
Cc: <linux-kernel@vger.kernel.org>

---
diff --git a/fs/kernfs/file.c b/fs/kernfs/file.c
index 8e0e90c93..2f87e426c 100644
--- a/fs/kernfs/file.c
+++ b/fs/kernfs/file.c
@@ -1015,7 +1015,6 @@ const struct file_operations kernfs_file_fops = {
 	.poll		= kernfs_fop_poll,
 	.fsync		= noop_fsync,
 	.splice_read	= copy_splice_read,
-	.splice_write	= iter_file_splice_write,
 };
 
 /**


base-commit: 93f51579e7df248780214094418f205253383cc5
-- 
This is an AI-generated patch subject to moderation.
Reply with '#syz upstream' to Sign-off the patch as a human author
and send it to the upstream kernel mailing lists.
Reply with '#syz reject' to reject it ('#syz unreject' to undo).

See https://goo.gle/syzbot-ai-patches for information about AI-generated patches.
You can comment on the patch as usual, syzbot will try to address
the comments and send a new version of the patch if necessary.
syzbot engineers can be reached at syzkaller@googlegroups.com.
