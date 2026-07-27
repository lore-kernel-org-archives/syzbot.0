Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5C11B43031B;
	Mon, 27 Jul 2026 17:30:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785173445; cv=none; b=r9KO6SBNt0PN33Lb44i+urQi91LEv/qTXsr7vsdWKiWHmYSDluCkw9fXklk6JO+M6LhI75tG8UoIMEqcbDxgt9C0CfYpMUsiFChP9v+otYCVWQ1iC5Gb4JvmT83KyrpyB6u7UKmizJxbwkLlO4DPMqSkM24Pi+8ZnZ52wO+jLYg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785173445; c=relaxed/simple;
	bh=dwys1TcfXyooM435Onf7sbe/CuSRNaKujEasTaSq9g8=;
	h=From:To:Cc:Subject:Message-ID:MIME-Version:Content-Type:Date; b=fhkCmB6xYZtFVkmXEG2Q691gfG8F3vyppB3uzE4K3Z0pTg8jI37wLSZ6/VqIeVDAWxWdJtcQocPM0/SJFUNBgAjYTAZCoYIlvo6CKa5XyIyUAldu5yAYtnngbiHpApOsjdZ082gjoYsMRxo6aYfd/h6FNlU01z4RJMW1XnZwwVM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=VKu7ASeh; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="VKu7ASeh"
Received: by smtp.kernel.org (Postfix) with UTF8SMTPSA id 1184D1F000E9;
	Mon, 27 Jul 2026 17:30:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1785173437;
	bh=UPy7m8y+L+9++wJJD0ni0RrPl7TvxOQSpeWA878iGhk=;
	h=From:To:Cc:Subject:Date;
	b=VKu7ASehXEh3KrmbNB3PQb5GUje3Rz1AYxoR/Ut1XMLHtUhO9XMXvLMipIt/ursFo
	 UC9XYHg6i3SPhGvVfS6CG88JvYce/rJAKC0LH+mYQCgyodWM0yx6jnrsGMXoxXr5kt
	 jsOE1h0OaYKyl5eOMVqNQqSl4SClyiPHUbSRyp0JMSC1hpkx01+HVWyqxRZzoDot8H
	 JAXvaKdAz9RMaWqOrDKnhlR6+E1XwkV78BzMjl2MRN3ryxORgP/+CTVJfBFV8Xkm9z
	 4GjP6LzsrSuq9IxkQRXRP2aLwytRQRBChmInbfkHq31UetMKdZSzOB2MEvdVGBbJ5F
	 G/AGSjzeG3gTg==
From: "syzbot" <syzbot@kernel.org>
To: syzkaller-bugs@googlegroups.com, Kusaram Devineni <kusaram@devineni.in>, <fuse-devel@lists.linux.dev>, "Miklos Szeredi" <miklos@szeredi.hu>
Cc: linux-kernel@vger.kernel.org, syzbot@lists.linux.dev
Subject: [PATCH] fuse: abort connection on /dev/fuse flush to prevent deadlock
Message-ID: <9650a974-ec3b-49d6-b6f8-89159d399239@mail.kernel.org>
Precedence: bulk
X-Mailing-List: syzbot@lists.linux.dev
List-Id: <syzbot.lists.linux.dev>
List-Subscribe: <mailto:syzbot+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:syzbot+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Date: Mon, 27 Jul 2026 17:30:37 +0000 (UTC)

From: Kusaram Devineni <kusaram@devineni.in>

A single-threaded FUSE daemon can deadlock if it mounts a filesystem and
opens a file on it. When the process exits or calls close_range(), the
kernel closes file descriptors in ascending numerical order.

If the /dev/fuse file descriptor (e.g., fd 5) is closed first, filp_close()
decrements the file reference count but defers the actual release (fput) to
task work. As a result, the FUSE connection remains active.

Next, when the FUSE file descriptor (e.g., fd 6) is closed, filp_close()
calls fuse_flush(), which sends a synchronous FUSE_FLUSH request to the
daemon. Since the daemon is the same thread that is currently blocked in
the close() syscall, it cannot process the request. The FUSE_FLUSH request
uses args.force = true, making the wait uninterruptible. The thread hangs
forever, eventually triggering a hung task panic:

Call Trace:
 <TASK>
 __schedule+0x17d9/0x56c0 kernel/sched/core.c:7234
 schedule+0x164/0x2b0 kernel/sched/core.c:7326
 request_wait_answer fs/fuse/dev.c:743 [inline]
 __fuse_request_send fs/fuse/dev.c:757 [inline]
 fuse_chan_send+0x1065/0x1ab0 fs/fuse/dev.c:833
 fuse_simple_request fs/fuse/fuse_i.h:1012 [inline]
 fuse_flush+0x66e/0x8b0 fs/fuse/file.c:504
 filp_flush+0xbd/0x190 fs/open.c:1471
 filp_close+0x1d/0x40 fs/open.c:1484
 __range_close fs/file.c:793 [inline]
 __do_sys_close_range fs/file.c:854 [inline]
 __se_sys_close_range+0x3d3/0x900 fs/file.c:818
 do_syscall_64+0x15f/0x560 arch/x86/entry/syscall_64.c:94

To fix this, implement a .flush method for /dev/fuse (fuse_dev_operations).
The .flush method is called synchronously by filp_close() during the
close() syscall, bypassing the fput delay.

In fuse_dev_flush(), if this is the final close of the file descriptor
(file_count(file) == 1), the device is marked as closing. Since multiple
cloned /dev/fuse devices can exist for the same connection, the closing
state of each device is tracked under the channel lock. If all devices
associated with the channel are closing, the FUSE connection is proactively
aborted. By aborting the connection synchronously in .flush, any subsequent
fuse_flush() calls on FUSE files will immediately fail with -ENOTCONN
instead of blocking indefinitely, avoiding the deadlock.

To handle the race where a /dev/fuse file descriptor is closed before it is
fully installed into a connection (i.e., fud->chan is still NULL),
cmpxchg() is used to atomically transition fud->chan from NULL to
FUSE_DEV_CHAN_DISCONNECTED. This prevents a concurrent fuse_dev_install()
from succeeding on a device that is already being closed. Furthermore,
because the VFS may invoke .fasync after .flush but before .release,
fuse_get_dev() and __fuse_get_dev() must reject the
FUSE_DEV_CHAN_DISCONNECTED sentinel to prevent .fasync from dereferencing
it.

Note that CUSE (Character Device in User Space) also shares
fuse_dev_operations and therefore inherits this new .flush callback, which
is safe and consistent with its lifecycle.

Fixes: 4a9d4b024a31 ("switch fput to task_work_add")
Assisted-by: Gemini:gemini-3.5-flash Gemini:gemini-3.1-pro-preview syzbot
Tested-by: syzbot <syzbot@syzkaller.appspotmail.com>
Reported-by: syzbot+0dbb0d6fda088e78a4d8@syzkaller.appspotmail.com
Closes: https://syzkaller.appspot.com/bug?extid=0dbb0d6fda088e78a4d8
Link: https://syzkaller.appspot.com/ai_job?id=fdcc0473-0605-4428-aad0-dd002b5f15aa
Signed-off-by: Kusaram Devineni <kusaram@devineni.in>

---
diff --git a/fs/fuse/dev.c b/fs/fuse/dev.c
index 5763a7cd3..8b14c7d57 100644
--- a/fs/fuse/dev.c
+++ b/fs/fuse/dev.c
@@ -1662,18 +1662,23 @@ static int fuse_dev_open(struct inode *inode, struct file *file)
 struct fuse_dev *fuse_get_dev(struct file *file)
 {
 	struct fuse_dev *fud = fuse_file_to_fud(file);
+	struct fuse_chan *fch = fuse_dev_chan_get(fud);
 	int err;
 
-	if (unlikely(!fuse_dev_chan_get(fud))) {
+	if (unlikely(!fch)) {
 		/* only block waiting for mount if sync init was requested */
 		if (!fud->sync_init)
 			return ERR_PTR(-EPERM);
 
-		err = wait_event_interruptible(fuse_dev_waitq, fuse_dev_chan_get(fud) != NULL);
+		err = wait_event_interruptible(fuse_dev_waitq,
+					       (fch = fuse_dev_chan_get(fud)) != NULL);
 		if (err)
 			return ERR_PTR(err);
 	}
 
+	if (unlikely(fch == FUSE_DEV_CHAN_DISCONNECTED))
+		return ERR_PTR(-EPERM);
+
 	return fud;
 }
 
@@ -2211,17 +2216,31 @@ void fuse_chan_wait_aborted(struct fuse_chan *fch)
 	fuse_uring_wait_stopped_queues(fch);
 }
 
+static bool fuse_dev_all_closing(struct fuse_chan *fch)
+{
+	struct fuse_dev *pos;
+
+	lockdep_assert_held(&fch->lock);
+
+	list_for_each_entry(pos, &fch->devices, entry) {
+		if (!pos->closing)
+			return false;
+	}
+	return true;
+}
+
 int fuse_dev_release(struct inode *inode, struct file *file)
 {
 	struct fuse_dev *fud = fuse_file_to_fud(file);
 	/* Pairs with cmpxchg() in fuse_dev_install() */
 	struct fuse_chan *fch = xchg(&fud->chan, FUSE_DEV_CHAN_DISCONNECTED);
 
-	if (fch) {
+	if (fch && fch != FUSE_DEV_CHAN_DISCONNECTED) {
 		struct fuse_pqueue *fpq = &fud->pq;
 		LIST_HEAD(to_end);
 		unsigned int i;
 		bool last;
+		bool abort;
 
 		/* Make sure fuse_dev_install_with_pq() has finished */
 		spin_lock(&fch->lock);
@@ -2234,14 +2253,15 @@ int fuse_dev_release(struct inode *inode, struct file *file)
 		list_del(&fud->entry);
 		/* Are we the last open device? */
 		last = list_empty(&fch->devices);
+		abort = fch->connected && fuse_dev_all_closing(fch);
 		spin_unlock(&fch->lock);
 
 		fuse_dev_end_requests(&to_end);
 
-		if (last) {
+		if (last)
 			WARN_ON(fch->iq.fasync != NULL);
+		if (abort)
 			fuse_chan_abort(fch, false);
-		}
 		fuse_conn_put(fch->conn);
 	}
 	fuse_dev_put(fud);
@@ -2375,6 +2395,34 @@ static void fuse_dev_show_fdinfo(struct seq_file *seq, struct file *file)
 }
 #endif
 
+static int fuse_dev_flush(struct file *file, fl_owner_t id)
+{
+	struct fuse_dev *fud = fuse_file_to_fud(file);
+	struct fuse_chan *fch;
+	bool abort;
+
+	if (file_count(file) != 1)
+		return 0;
+
+	/*
+	 * Atomically transition fud->chan from NULL to FUSE_DEV_CHAN_DISCONNECTED
+	 * on final close to prevent a later fuse_dev_install() from succeeding.
+	 */
+	fch = cmpxchg(&fud->chan, NULL, FUSE_DEV_CHAN_DISCONNECTED);
+	if (!fch || fch == FUSE_DEV_CHAN_DISCONNECTED)
+		return 0;
+
+	spin_lock(&fch->lock);
+	fud->closing = true;
+	abort = fch->connected && fuse_dev_all_closing(fch);
+	spin_unlock(&fch->lock);
+
+	if (abort)
+		fuse_chan_abort(fch, false);
+
+	return 0;
+}
+
 const struct file_operations fuse_dev_operations = {
 	.owner		= THIS_MODULE,
 	.open		= fuse_dev_open,
@@ -2383,6 +2431,7 @@ const struct file_operations fuse_dev_operations = {
 	.write_iter	= fuse_dev_write,
 	.splice_write	= fuse_dev_splice_write,
 	.poll		= fuse_dev_poll,
+	.flush		= fuse_dev_flush,
 	.release	= fuse_dev_release,
 	.fasync		= fuse_dev_fasync,
 	.unlocked_ioctl = fuse_dev_ioctl,
diff --git a/fs/fuse/fuse_dev_i.h b/fs/fuse/fuse_dev_i.h
index 668c8391d..2833a0350 100644
--- a/fs/fuse/fuse_dev_i.h
+++ b/fs/fuse/fuse_dev_i.h
@@ -302,6 +302,9 @@ struct fuse_dev {
 	/** @sync_init: Issue FUSE_INIT synchronously */
 	bool sync_init;
 
+	/** @closing: Final close has started, protected by chan->lock */
+	bool closing;
+
 	/** @chan: Fuse channel for this device */
 	struct fuse_chan *chan;
 
@@ -330,17 +333,25 @@ struct fuse_copy_state {
 	} ring;
 };
 
-/* fud->chan gets assigned to this value when /dev/fuse is closed */
-#define FUSE_DEV_CHAN_DISCONNECTED ((struct fuse_chan *) 1)
-
 /*
- * Lockless access is OK, because fud->chan is set once during mount and is valid
- * until the file is released.
+ * fud->chan has the following monotonic state transitions:
+ *
+ * NULL -> valid channel -> FUSE_DEV_CHAN_DISCONNECTED
+ * NULL -----------------> FUSE_DEV_CHAN_DISCONNECTED
  *
- * fud->chan is set to FUSE_DEV_CHAN_DISCONNECTED only after the containing file is
- * released, so result is safe to dereference in most cases.  Exceptions are:
- * fuse_dev_put() and fuse_fill_super_common().
+ * A valid channel pointer remains valid until the file is released. Final
+ * flush can install FUSE_DEV_CHAN_DISCONNECTED directly for an uninstalled
+ * device, preventing any later channel installation. The sentinel therefore
+ * means that the channel can no longer be installed or accessed through this
+ * file; it does not imply that release has already run and it must never be
+ * dereferenced.
+ *
+ * fuse_dev_chan_get() reads this state locklessly. Callers must distinguish
+ * NULL, a valid channel pointer, and FUSE_DEV_CHAN_DISCONNECTED before
+ * dereferencing the result.
  */
+#define FUSE_DEV_CHAN_DISCONNECTED ((struct fuse_chan *) 1)
+
 static inline struct fuse_chan *fuse_dev_chan_get(struct fuse_dev *fud)
 {
 	/* Pairs with xchg() in fuse_dev_install() */
@@ -355,8 +366,9 @@ static inline struct fuse_dev *fuse_file_to_fud(struct file *file)
 static inline struct fuse_dev *__fuse_get_dev(struct file *file)
 {
 	struct fuse_dev *fud = fuse_file_to_fud(file);
+	struct fuse_chan *fch = fuse_dev_chan_get(fud);
 
-	if (!fuse_dev_chan_get(fud))
+	if (!fch || fch == FUSE_DEV_CHAN_DISCONNECTED)
 		return NULL;
 
 	return fud;


base-commit: 8cdeaa50eae8dad34885515f62559ee83e7e8dda
-- 
See https://goo.gle/syzbot-ai-patches for information about AI-generated patches.
You can comment on the patch as usual, syzbot will try to address
the comments and send a new version of the patch if necessary.
syzbot engineers can be reached at syzkaller@googlegroups.com.
