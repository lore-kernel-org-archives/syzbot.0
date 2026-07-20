Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 46D3B31AA87
	for <syzbot@lists.linux.dev>; Mon, 20 Jul 2026 11:18:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784546308; cv=none; b=F4+8nxEU9Cy/WQEfQWs9I7OW/kiH1DZdribSHEOTWp+20IXrTjGUe26m22tgzQaV6kTdfj+TQILC7eII90T38MUDP+Zrbb+B4zla8U4bssa0Xa6ns8imOMVuwDtowMNEs/dVIebUaLDdK3MqMpuDVT0vQjuuaYf6qqOw30kz5Dc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784546308; c=relaxed/simple;
	bh=drcQgnEMrKZ/JPQnw8EV4hwkhULa7x2s5ESvaUt2/+o=;
	h=From:To:Cc:Subject:Message-ID:MIME-Version:Content-Type:Date; b=s1+ofxQKF2b321DKuUxk9sL0bYb0zYP9Hru39eIv13HoepzWnBPdo+dyQ3ag675hUYApXP0+ccyaMjgIUOXmMS/3LOou8j7YTOhvbsDoK/cp5dk8mxNBOOCnnAH6lTO5u/1Ct/TYkJ8ASHu2NBQWr+uem1AGadQIOIGBx+2kBlA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=cnhf8CB7; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="cnhf8CB7"
Received: by smtp.kernel.org (Postfix) with UTF8SMTPSA id 0D1041F00A3A;
	Mon, 20 Jul 2026 11:18:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1784546307;
	bh=tTpedlakPo3J3KT17OiEHMZG6k6QQU2uL0ok4CYhutA=;
	h=From:To:Cc:Subject:Date;
	b=cnhf8CB7mJzMMotoGbEsO0hcm3M70OPkHv3iQhMmIcB5+eaFxlzslY6BnZIOYohob
	 pQtOYAvHqlcd7PzvIQEYb2P/hFMqptiwNUzaX+A76J2yeBrb5n59XnN90qkrMZGMqK
	 1tdu4R16+5vW2GtszR/DUvq1kriuihxNkcFeqLjMHTBEAznsRCuI4/p5lUN/TRX8o3
	 vBo7SKXSRmYXy27ohtcd3mJ+DborBe4qtsURNJHXOITO5EyIt0r5Bx12eDPzjoizlg
	 b6MXjrE7jh/dbZSP9AedtntaVPl4mse+bIMxEdeEE6nAZChhmmQc0vO2724yKojiww
	 pqanmepLB8AqA==
From: "syzbot" <syzbot@kernel.org>
To: syzkaller-upstream-moderation@googlegroups.com
Cc: kusaram@devineni.in, syzbot@lists.linux.dev
Subject: [PATCH RFC v2] fuse: abort connection on /dev/fuse flush to prevent deadlock
Message-ID: <3e4a3361-9e1b-4f46-8033-f85ada100a79@mail.kernel.org>
Precedence: bulk
X-Mailing-List: syzbot@lists.linux.dev
List-Id: <syzbot.lists.linux.dev>
List-Subscribe: <mailto:syzbot+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:syzbot+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Date: Mon, 20 Jul 2026 11:18:27 +0000 (UTC)

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
(file_count(file) <= 1), we mark the device as closing. Since multiple
cloned /dev/fuse devices can exist for the same connection, we track the
closing state of each device under the channel lock. If all devices
associated with the channel are closing, we proactively abort the FUSE
connection. By aborting the connection synchronously in .flush, any
subsequent fuse_flush() calls on FUSE files will immediately fail with
-ENOTCONN instead of blocking indefinitely, avoiding the deadlock.

To handle the race where a /dev/fuse file descriptor is closed before it is
fully installed into a connection (i.e., fud->chan is still NULL), we use
cmpxchg() to atomically transition fud->chan from NULL to
FUSE_DEV_CHAN_DISCONNECTED. This prevents a concurrent fuse_dev_install()
from succeeding on a device that is already being closed.

Note that CUSE (Character Device in User Space) also shares
fuse_dev_operations and therefore inherits this new .flush callback, which
is safe and consistent with its lifecycle.

Fixes: 4a9d4b024a31 ("switch fput to task_work_add")
Assisted-by: Gemini:gemini-3.5-flash Gemini:gemini-3.1-pro-preview syzbot
Reported-by: syzbot+0dbb0d6fda088e78a4d8@syzkaller.appspotmail.com
Closes: https://syzkaller.appspot.com/bug?extid=0dbb0d6fda088e78a4d8
Link: https://syzkaller.appspot.com/ai_job?id=84ef0273-9fd7-4475-b099-dd6b7424c049
To: <fuse-devel@lists.linux.dev>
To: "Miklos Szeredi" <miklos@szeredi.hu>
Cc: <linux-kernel@vger.kernel.org>

---
v2:
- Added `closing` flag to `struct fuse_dev` to track the closing state of each device.
- Updated `fuse_dev_flush()` to check if all associated devices are closing, properly handling cloned devices.
- Used `cmpxchg()` in `fuse_dev_flush()` to handle the race where a device is closed before being fully installed.
- Updated `fuse_dev_release()` to handle `FUSE_DEV_CHAN_DISCONNECTED` safely.

v1:
https://lore.kernel.org/all/bedbc009-8806-4913-9a03-1b25b6d33729@mail.kernel.org/T/
---
diff --git a/fs/fuse/dev.c b/fs/fuse/dev.c
index 5763a7cd3..2179d182e 100644
--- a/fs/fuse/dev.c
+++ b/fs/fuse/dev.c
@@ -2217,7 +2217,7 @@ int fuse_dev_release(struct inode *inode, struct file *file)
 	/* Pairs with cmpxchg() in fuse_dev_install() */
 	struct fuse_chan *fch = xchg(&fud->chan, FUSE_DEV_CHAN_DISCONNECTED);
 
-	if (fch) {
+	if (fch && fch != FUSE_DEV_CHAN_DISCONNECTED) {
 		struct fuse_pqueue *fpq = &fud->pq;
 		LIST_HEAD(to_end);
 		unsigned int i;
@@ -2375,23 +2375,58 @@ static void fuse_dev_show_fdinfo(struct seq_file *seq, struct file *file)
 }
 #endif
 
+static int fuse_dev_flush(struct file *file, fl_owner_t id)
+{
+	struct fuse_dev *fud = fuse_file_to_fud(file);
+	struct fuse_chan *fch;
+	struct fuse_dev *tmp;
+	bool last = true;
+
+	if (file_count(file) > 1)
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
+	list_for_each_entry(tmp, &fch->devices, entry) {
+		if (!tmp->closing) {
+			last = false;
+			break;
+		}
+	}
+	spin_unlock(&fch->lock);
+
+	if (last)
+		fuse_chan_abort(fch, false);
+
+	return 0;
+}
+
 const struct file_operations fuse_dev_operations = {
-	.owner		= THIS_MODULE,
-	.open		= fuse_dev_open,
-	.read_iter	= fuse_dev_read,
-	.splice_read	= fuse_dev_splice_read,
-	.write_iter	= fuse_dev_write,
-	.splice_write	= fuse_dev_splice_write,
-	.poll		= fuse_dev_poll,
-	.release	= fuse_dev_release,
-	.fasync		= fuse_dev_fasync,
+	.owner = THIS_MODULE,
+	.open = fuse_dev_open,
+	.read_iter = fuse_dev_read,
+	.splice_read = fuse_dev_splice_read,
+	.write_iter = fuse_dev_write,
+	.splice_write = fuse_dev_splice_write,
+	.poll = fuse_dev_poll,
+	.flush = fuse_dev_flush,
+	.release = fuse_dev_release,
+	.fasync = fuse_dev_fasync,
 	.unlocked_ioctl = fuse_dev_ioctl,
-	.compat_ioctl   = compat_ptr_ioctl,
+	.compat_ioctl = compat_ptr_ioctl,
 #ifdef CONFIG_FUSE_IO_URING
-	.uring_cmd	= fuse_uring_cmd,
+	.uring_cmd = fuse_uring_cmd,
 #endif
 #ifdef CONFIG_PROC_FS
-	.show_fdinfo	= fuse_dev_show_fdinfo,
+	.show_fdinfo = fuse_dev_show_fdinfo,
 #endif
 };
 EXPORT_SYMBOL_GPL(fuse_dev_operations);
diff --git a/fs/fuse/fuse_dev_i.h b/fs/fuse/fuse_dev_i.h
index 668c8391d..29e79d646 100644
--- a/fs/fuse/fuse_dev_i.h
+++ b/fs/fuse/fuse_dev_i.h
@@ -310,6 +310,9 @@ struct fuse_dev {
 
 	/** @entry: list entry on fch->devices */
 	struct list_head entry;
+
+	/** @closing: is this device closing? */
+	bool closing;
 };
 
 struct fuse_copy_state {
@@ -337,8 +340,8 @@ struct fuse_copy_state {
  * Lockless access is OK, because fud->chan is set once during mount and is valid
  * until the file is released.
  *
- * fud->chan is set to FUSE_DEV_CHAN_DISCONNECTED only after the containing file is
- * released, so result is safe to dereference in most cases.  Exceptions are:
+ * fud->chan is set to FUSE_DEV_CHAN_DISCONNECTED on final close or release,
+ * so result is safe to dereference in most cases.  Exceptions are:
  * fuse_dev_put() and fuse_fill_super_common().
  */
 static inline struct fuse_chan *fuse_dev_chan_get(struct fuse_dev *fud)


base-commit: 8cdeaa50eae8dad34885515f62559ee83e7e8dda
-- 
This is an AI-generated patch subject to moderation.
Reply with '#syz upstream' to Sign-off the patch as a human author
and send it to the upstream kernel mailing lists.
Reply with '#syz reject' to reject it ('#syz unreject' to undo).

See https://goo.gle/syzbot-ai-patches for information about AI-generated patches.
You can comment on the patch as usual, syzbot will try to address
the comments and send a new version of the patch if necessary.
syzbot engineers can be reached at syzkaller@googlegroups.com.
