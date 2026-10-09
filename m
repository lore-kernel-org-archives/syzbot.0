Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 860994FC334
	for <syzbot@lists.linux.dev>; Fri,  9 Oct 2026 18:08:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791569336; cv=none; b=q3/3t1PvNv3FdamEslZPIp6ObOJ5DMrLynOJYfILFIlvEW1HjEEsY9onpfmoAZc+MKbFedYAfIvYNuKZLaKywasKoWf2IXLybbAFWeJlpzNYrkS+j0zjUGxo8PKqGvErREGplL8BniHHWCkRCRY3HCKkyKvSKmUopjC2Hb4+4Cg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791569336; c=relaxed/simple;
	bh=ZQSCKmx3gN2eurObFzxH2PaOqbVISIiJLo7cWhjUK10=;
	h=From:To:Cc:Subject:Message-ID:MIME-Version:Content-Type:Date; b=KCe6QVSsJRw0YAFO1Ok3xcTueS00lO9nq4IDCGMco1CiWAoXBk1iZP4qpfgIBtro+gs8wUo0/Lw+y0pRKYpH8ZmJKuZFl9Bk8Zp30tzAaPnSrP0k5mAupY0VgSYSrkkCABJAIfnegm9G7+260OBiMq2vjllQ5y3I3iMkwmLNyzI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=TyRjeVuA; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="TyRjeVuA"
Received: by smtp.kernel.org (Postfix) with UTF8SMTPSA id 100661F00893;
	Fri,  9 Oct 2026 18:08:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1791569335;
	bh=jU9+TkuxOKnkdHfjkpxox9G1TTb4BTLcUwHYyLG1Xb0=;
	h=From:To:Cc:Subject:Date;
	b=TyRjeVuAryzy7lasxlLh0ch1iI3vQuv2ZVo09FqpRItBWAhJ4VPLNywbaLSKo0LKW
	 2qNOSXX4bmdM+qbdJs+63mrWO/cEvxdDXhEsP5ZF6jHNbCpkw5AEy03lGmlD7GFvz2
	 zKXHnCpNSxDojuhG+a9yJ6PkbnGiFf4tKVjmtnykiD1rzRWPcz17h+FvFj6aVTBykD
	 vLYicIl1EB8w66olnlQ6kw+B4msV2QRh8wZTwOZs7VxmJ8A5GlcNDO0uzlgaan+s8x
	 XlTpZ9knWYT5ot7LV8oIJJW4tpVjVCML9IaoDzksW8xo1J9KvE/o+XHaBwerzxLsNZ
	 pBNH203HC7rAA==
From: "syzbot" <syzbot@kernel.org>
To: syzkaller-upstream-moderation@googlegroups.com
Cc: krystianmkaniewski@gmail.com, syzbot@lists.linux.dev
Subject: [PATCH RFC v3] kernfs: do not hold of->mutex across sysfs ->store()
Message-ID: <c55e68c8-d895-4b6d-ad52-eedc0417562b@mail.kernel.org>
Precedence: bulk
X-Mailing-List: syzbot@lists.linux.dev
List-Id: <syzbot.lists.linux.dev>
List-Subscribe: <mailto:syzbot+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:syzbot+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Date: Fri,  9 Oct 2026 18:08:55 +0000 (UTC)

A circular locking dependency was detected between &pipe->mutex (in struct
pipe_inode_info), &of->mutex (in struct kernfs_open_file), and
&sbi->pipe_mutex (in struct autofs_sb_info):
&pipe->mutex --> &of->mutex --> &sbi->pipe_mutex

The cycle arises from two conflicting execution paths: splicing data from
or to a pipe holds the pipe lock (&pipe->mutex) while invoking
->write_iter() or ->read_iter() on the kernfs file, acquiring of->mutex
(&pipe->mutex -> &of->mutex). Conversely, a write to a sysfs file such as
/sys/power/resume acquires of->mutex and calls resume_store(), which
resolves paths via lookup_bdev() and kern_path(). Traversing an autofs
mount during lookup invokes autofs_notify_daemon(), which acquires
sbi->pipe_mutex and writes to the daemon pipe via __kernel_write(),
acquiring pipe->mutex (&of->mutex -> &sbi->pipe_mutex -> &pipe->mutex).

To address this, do not hold of->mutex across sysfs ->store() callbacks by
introducing a write_unlocked flag in struct kernfs_ops and caching it in
struct kernfs_open_file. Running ->store() without of->mutex is safe
because sysfs ->store() maintains no per-open-file state, and concurrent
opens of the same file already execute ->store() concurrently without
serialization. Other kernfs users retain per-open-file serialization under
of->mutex, and preallocated sysfs attributes still serialize buffer access
via of->prealloc_mutex.

Note that not every cycle is eliminated: a pipe spliced into such an
attribute stays locked while ->store() resolves paths, and callbacks
holding their own locks across lookup and ->show() retain dependencies.

Fixes: f2d6c2708bd8 ("kernfs: wire up ->splice_read and ->splice_write")

Fixes: 1e8c813b083c ("PM: hibernate: don't use early_lookup_bdev in resume_store")
Assisted-by: Gemini:gemini-3.8-flash syzbot
Reported-by: syzbot+002fb7b2d0bc53bf7e75@syzkaller.appspotmail.com
Closes: https://syzkaller.appspot.com/bug?extid=002fb7b2d0bc53bf7e75
Link: https://syzkaller.appspot.com/ai_job?id=74fbf9ab-54e4-46c2-b9e9-7867573ff823
To: "Danilo Krummrich" <dakr@kernel.org>
To: <driver-core@lists.linux.dev>
To: "Greg Kroah-Hartman" <gregkh@linuxfoundation.org>
To: "Rafael J. Wysocki" <rafael@kernel.org>
To: "Tejun Heo" <tj@kernel.org>
To: "Christoph Hellwig" <hch@lst.de>
Cc: <linux-kernel@vger.kernel.org>

---
v3:
- Changed write_unlocked in struct kernfs_open_file from a bitfield to a bool
- Expanded comments in kernfs.h and sysfs/file.c to clarify concurrency expectations and locking scope

v2:
- Avoid dropping splice_write support in kernfs_file_fops.
- Introduce write_unlocked flag in struct kernfs_ops and struct kernfs_open_file to run sysfs ->store() without of->mutex.
- Update commit subject and description to reflect the new locking approach.
https://lore.kernel.org/all/bc6a8f1d-d7bf-43bf-80e2-c3489ded269a@mail.kernel.org/T/

v1:
https://lore.kernel.org/all/af4efe2d-7856-46ff-9088-28400130dbce@mail.kernel.org/T/
---
diff --git a/fs/kernfs/file.c b/fs/kernfs/file.c
index 8e0e90c93..8084a858f 100644
--- a/fs/kernfs/file.c
+++ b/fs/kernfs/file.c
@@ -333,9 +333,11 @@ static ssize_t kernfs_fop_write_iter(struct kiocb *iocb, struct iov_iter *iter)
 	 * @of->mutex nests outside active ref and is used both to ensure that
 	 * the ops aren't called concurrently for the same open file.
 	 */
-	mutex_lock(&of->mutex);
+	if (!of->write_unlocked)
+		mutex_lock(&of->mutex);
 	if (!kernfs_get_active_of(of)) {
-		mutex_unlock(&of->mutex);
+		if (!of->write_unlocked)
+			mutex_unlock(&of->mutex);
 		len = -ENODEV;
 		goto out_free;
 	}
@@ -347,7 +349,8 @@ static ssize_t kernfs_fop_write_iter(struct kiocb *iocb, struct iov_iter *iter)
 		len = -EINVAL;
 
 	kernfs_put_active_of(of);
-	mutex_unlock(&of->mutex);
+	if (!of->write_unlocked)
+		mutex_unlock(&of->mutex);
 
 	if (len > 0)
 		iocb->ki_pos += len;
@@ -651,6 +654,8 @@ static int kernfs_fop_open(struct inode *inode, struct file *file)
 	 * lockdep key, because the writable file /sys/power/resume may call vfs
 	 * lookup helpers for arbitrary paths and readonly files can be read by
 	 * overlayfs from vfs helpers when sysfs is a lower layer of overalyfs.
+	 * (Note that regular sysfs attributes no longer run ->store() under
+	 * @of->mutex, but other kernfs users still do.)
 	 *
 	 * All three cases look the same.  They're supposed to
 	 * look that way and give @of->mutex different static lockdep keys.
@@ -666,10 +671,12 @@ static int kernfs_fop_open(struct inode *inode, struct file *file)
 	of->file = file;
 
 	/*
-	 * Write path needs to atomic_write_len outside active reference.
-	 * Cache it in open_file.  See kernfs_fop_write_iter() for details.
+	 * Write path needs atomic_write_len and write_unlocked outside
+	 * active reference.  Cache them in open_file.  See
+	 * kernfs_fop_write_iter() for details.
 	 */
 	of->atomic_write_len = ops->atomic_write_len;
+	of->write_unlocked = ops->write_unlocked;
 
 	error = -EINVAL;
 	/*
diff --git a/fs/sysfs/file.c b/fs/sysfs/file.c
index cd5bb0f9f..71a7faf43 100644
--- a/fs/sysfs/file.c
+++ b/fs/sysfs/file.c
@@ -132,7 +132,19 @@ static ssize_t sysfs_kf_read(struct kernfs_open_file *of, char *buf,
 	return min_t(ssize_t, count, len);
 }
 
-/* kernfs write callback for regular sysfs files */
+/*
+ * kernfs write callback for regular sysfs files.
+ *
+ * Regular sysfs files set .write_unlocked = true and are called without
+ * holding of->mutex. Sysfs ->store() maintains no per-open-file state, and
+ * concurrent opens already execute ->store() concurrently without
+ * serialization. Calling ->store() without of->mutex avoids circular
+ * locking dependencies when ->store() performs operations like path
+ * lookups or automounts while a generic VFS lock is held (such as a pipe
+ * lock during splice). Preallocated attributes still serialize buffer
+ * access via of->prealloc_mutex. Existing autofs and callback-owned lock
+ * dependencies remain outside this narrow change.
+ */
 static ssize_t sysfs_kf_write(struct kernfs_open_file *of, char *buf,
 			      size_t count, loff_t pos)
 {
@@ -229,11 +241,13 @@ static const struct kernfs_ops sysfs_file_kfops_ro = {
 
 static const struct kernfs_ops sysfs_file_kfops_wo = {
 	.write		= sysfs_kf_write,
+	.write_unlocked	= true,
 };
 
 static const struct kernfs_ops sysfs_file_kfops_rw = {
 	.seq_show	= sysfs_kf_seq_show,
 	.write		= sysfs_kf_write,
+	.write_unlocked	= true,
 };
 
 static const struct kernfs_ops sysfs_prealloc_kfops_ro = {
@@ -244,12 +258,14 @@ static const struct kernfs_ops sysfs_prealloc_kfops_ro = {
 static const struct kernfs_ops sysfs_prealloc_kfops_wo = {
 	.write		= sysfs_kf_write,
 	.prealloc	= true,
+	.write_unlocked	= true,
 };
 
 static const struct kernfs_ops sysfs_prealloc_kfops_rw = {
 	.read		= sysfs_kf_read,
 	.write		= sysfs_kf_write,
 	.prealloc	= true,
+	.write_unlocked	= true,
 };
 
 static const struct kernfs_ops sysfs_bin_kfops_ro = {
diff --git a/include/linux/kernfs.h b/include/linux/kernfs.h
index 351a5101c..cbb09f953 100644
--- a/include/linux/kernfs.h
+++ b/include/linux/kernfs.h
@@ -272,6 +272,7 @@ struct kernfs_open_file {
 	char			*prealloc_buf;
 
 	size_t			atomic_write_len;
+	bool			write_unlocked;
 	bool			mmapped:1;
 	bool			released:1;
 	const struct vm_operations_struct *vm_ops;
@@ -320,6 +321,16 @@ struct kernfs_ops {
 	 * ->prealloc.  Provide ->read and ->write with ->prealloc.
 	 */
 	bool prealloc;
+	/*
+	 * "write_unlocked" indicates that ->write() does not require
+	 * per-open-file serialization with of->mutex and can be called
+	 * concurrently for the same open file. Callbacks must handle
+	 * concurrent execution. Buffer access for preallocated attributes
+	 * is still protected by of->prealloc_mutex. Lock dependencies from
+	 * callers (such as pipe locks during splice) or within callbacks
+	 * remain outside this scope.
+	 */
+	bool write_unlocked;
 	ssize_t (*write)(struct kernfs_open_file *of, char *buf, size_t bytes,
 			 loff_t off);
 


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
