Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 642AC4E06F3
	for <syzbot@lists.linux.dev>; Fri, 16 Oct 2026 16:36:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792168603; cv=none; b=aqsepKBdYukNB8lDGUqewWtOyzKkU6TIPaqyh4O6oP6kl2k0gQ1k21/SCWND/CqukspXifjRm6Lv/BLxRjlb19Xp+TYuQLNpRkBZVb5XSq8qerdvmcqCN/e4Cu6KevZAe/9UQ4t9tPflg+ML8aFWLl3asuZYbYwn3LsbokQhxIw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792168603; c=relaxed/simple;
	bh=vqUAI/6uHnTtu9xAdTYPzM7qRRPnVwclTyENy7PGPYw=;
	h=From:To:Cc:Subject:Message-ID:MIME-Version:Content-Type:Date; b=DW9xvDN19L6uiew+FF8ZslX5FoxaAiehWa9xkcHNufl3XtxmblyjUgW4avYFQzgRLLRoJpXI7J2OuLD+et+98mky+SU7/fLxVYPYP+SFswsw6uHS1BbQLjv1/Xh2B5fzwV5j6Jgn0DEuXrtbKaY7tZIGKMUq3bOok3WA/Z8d0u0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=a+FnGGM8; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="a+FnGGM8"
Received: by smtp.kernel.org (Postfix) with UTF8SMTPSA id D21C71F000C4;
	Fri, 16 Oct 2026 16:36:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1792168598;
	bh=HohVDUDGIP1+LdkMGQ6NQTiGAel8v1Ntg6ETAZsNW18=;
	h=From:To:Cc:Subject:Date;
	b=a+FnGGM80ubsMXhYUhnpDAsogoT82cedTi/gdbc4GQqDYALrhM4jGP1n5sjETTzkM
	 Kt8ApMy1XGQbJtkj9dGlRx8sm/N2hHk8zf8DCBZR3s6hYfwyKixMOo3kSvBj650jqW
	 +7/6xPFvSStGxd0Bgcty2Mt5yJtdR3c8G6qQ4vYfbIN7NxwiKQDim6qyrhXn0amZHA
	 vt7gMZx0JPQ+DKbRx8RKD8kj7VvlmFgGofKtH9k3yCOnNsIVcmZ+Khc3hpxJJYPu8m
	 CtKXaBvnGrsvp24fNUp+6OHE3MpJ8bDGRvStaXC5yS5acBkPJafUBfCgBHkf4gpB2e
	 0vP23K44JX+Ug==
From: "syzbot" <syzbot@kernel.org>
To: syzkaller-upstream-moderation@googlegroups.com
Cc: krystianmkaniewski@gmail.com, syzbot@lists.linux.dev
Subject: [PATCH RFC v4] kernfs: do not hold of->mutex across sysfs ->store()
Message-ID: <77436f50-0ad3-42b6-a16b-4338e781e935@mail.kernel.org>
Precedence: bulk
X-Mailing-List: syzbot@lists.linux.dev
List-Id: <syzbot.lists.linux.dev>
List-Subscribe: <mailto:syzbot+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:syzbot+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Date: Fri, 16 Oct 2026 16:36:37 +0000 (UTC)

A circular locking dependency was detected between &pipe->mutex,
&of->mutex, and &sbi->pipe_mutex:

  &pipe->mutex --> &of->mutex --> &sbi->pipe_mutex

The cycle arises from two conflicting execution paths: splicing data from
or to a pipe holds &pipe->mutex while invoking ->write_iter() or
->read_iter() on the kernfs file, acquiring of->mutex. Conversely, a write
to a sysfs file such as /sys/power/resume acquires of->mutex and calls
resume_store(), which resolves paths via lookup_bdev() and kern_path().
Traversing an autofs mount during lookup invokes autofs_notify_daemon(),
which acquires sbi->pipe_mutex and writes to the daemon pipe via
__kernel_write(), acquiring pipe->mutex.

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
Assisted-by: Gemini:gemini-4-argon Gemini:gemini-3.8-flash syzbot
Reported-by: syzbot+002fb7b2d0bc53bf7e75@syzkaller.appspotmail.com
Closes: https://syzkaller.appspot.com/bug?extid=002fb7b2d0bc53bf7e75
Link: https://syzkaller.appspot.com/ai_job?id=7fc33c05-1e14-4d49-9698-08204af84c70
To: "Danilo Krummrich" <dakr@kernel.org>
To: <driver-core@lists.linux.dev>
To: "Greg Kroah-Hartman" <gregkh@linuxfoundation.org>
To: "Rafael J. Wysocki" <rafael@kernel.org>
To: "Tejun Heo" <tj@kernel.org>
To: "Christoph Hellwig" <hch@lst.de>
Cc: <linux-kernel@vger.kernel.org>

---
v4:
- Factor out active reference handling and write callback invocation into kernfs_write_active().
- Update commit description to quote the lockdep chain once without redundant sub-chains or struct names.

v3:
- Changed write_unlocked in struct kernfs_open_file from a bitfield to a bool
- Expanded comments in kernfs.h and sysfs/file.c to clarify concurrency expectations and locking scope
https://lore.kernel.org/all/c55e68c8-d895-4b6d-ad52-eedc0417562b@mail.kernel.org/T/

v2:
- Avoid dropping splice_write support in kernfs_file_fops.
- Introduce write_unlocked flag in struct kernfs_ops and struct kernfs_open_file to run sysfs ->store() without of->mutex.
- Update commit subject and description to reflect the new locking approach.
https://lore.kernel.org/all/bc6a8f1d-d7bf-43bf-80e2-c3489ded269a@mail.kernel.org/T/

v1:
https://lore.kernel.org/all/af4efe2d-7856-46ff-9088-28400130dbce@mail.kernel.org/T/
---
diff --git a/fs/kernfs/file.c b/fs/kernfs/file.c
index 8e0e90c93..38ac34dae 100644
--- a/fs/kernfs/file.c
+++ b/fs/kernfs/file.c
@@ -291,6 +291,25 @@ static ssize_t kernfs_fop_read_iter(struct kiocb *iocb, struct iov_iter *iter)
 	return kernfs_file_read_iter(iocb, iter);
 }
 
+static ssize_t kernfs_write_active(struct kernfs_open_file *of, char *buf,
+				   size_t len, loff_t pos)
+{
+	const struct kernfs_ops *ops;
+	ssize_t ret;
+
+	if (!kernfs_get_active_of(of))
+		return -ENODEV;
+
+	ops = kernfs_ops(of->kn);
+	if (ops->write)
+		ret = ops->write(of, buf, len, pos);
+	else
+		ret = -EINVAL;
+
+	kernfs_put_active_of(of);
+	return ret;
+}
+
 /*
  * Copy data in from userland and pass it to the matching kernfs write
  * operation.
@@ -305,7 +324,6 @@ static ssize_t kernfs_fop_write_iter(struct kiocb *iocb, struct iov_iter *iter)
 {
 	struct kernfs_open_file *of = kernfs_of(iocb->ki_filp);
 	ssize_t len = iov_iter_count(iter);
-	const struct kernfs_ops *ops;
 	char *buf;
 
 	if (of->atomic_write_len) {
@@ -331,24 +349,18 @@ static ssize_t kernfs_fop_write_iter(struct kiocb *iocb, struct iov_iter *iter)
 
 	/*
 	 * @of->mutex nests outside active ref and is used both to ensure that
-	 * the ops aren't called concurrently for the same open file.
+	 * the ops aren't called concurrently for the same open file.  It is
+	 * only acquired when @of->write_unlocked is clear, and ->write() of
+	 * such a file can run concurrently for the same open file.
 	 */
-	mutex_lock(&of->mutex);
-	if (!kernfs_get_active_of(of)) {
+	if (of->write_unlocked) {
+		len = kernfs_write_active(of, buf, len, iocb->ki_pos);
+	} else {
+		mutex_lock(&of->mutex);
+		len = kernfs_write_active(of, buf, len, iocb->ki_pos);
 		mutex_unlock(&of->mutex);
-		len = -ENODEV;
-		goto out_free;
 	}
 
-	ops = kernfs_ops(of->kn);
-	if (ops->write)
-		len = ops->write(of, buf, len, iocb->ki_pos);
-	else
-		len = -EINVAL;
-
-	kernfs_put_active_of(of);
-	mutex_unlock(&of->mutex);
-
 	if (len > 0)
 		iocb->ki_pos += len;
 
@@ -651,6 +663,8 @@ static int kernfs_fop_open(struct inode *inode, struct file *file)
 	 * lockdep key, because the writable file /sys/power/resume may call vfs
 	 * lookup helpers for arbitrary paths and readonly files can be read by
 	 * overlayfs from vfs helpers when sysfs is a lower layer of overalyfs.
+	 * (Note that regular sysfs attributes no longer run ->store() under
+	 * @of->mutex, but other kernfs users still do.)
 	 *
 	 * All three cases look the same.  They're supposed to
 	 * look that way and give @of->mutex different static lockdep keys.
@@ -666,10 +680,12 @@ static int kernfs_fop_open(struct inode *inode, struct file *file)
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
