Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EDDC5366061
	for <syzbot@lists.linux.dev>; Thu,  9 Jul 2026 14:30:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783607457; cv=none; b=Up3eLBjwq8vdj/jESDHv4LRZIElw9WVNzjtrExnnDUV079RDjAXH10iv69yXsnN62zSMFcp57FuGc6GBX2d5ovRaZuv5qjxZ5r6e1QYAb82ip0BbzOEDfRS+sDmv+671tTZoR/VLJaKJo5j66ZxismLd89QuDtrfcFLBKRzk6us=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783607457; c=relaxed/simple;
	bh=IUFryvtDYmArwyLE0wUO29wzOdap66kiLoUjZI3qdAU=;
	h=From:To:Cc:Subject:Message-ID:MIME-Version:Content-Type:Date; b=GpmV0qjvz7LnVXMWp7kyPjEwDn3ufgWjd80pwqoeB6V41oJg2V/a+f5Tu/9RoSKxhzBSWGLJgRaG92+S1A7he2bAos7QyvHCMb7PthoKn+tRvUISdKp95JQaC74QWf0k3F7iNAF0QMLdIcpj4dlJJLTbIdclNBubh0eFAky93BQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=juSDlELm; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="juSDlELm"
Received: by smtp.kernel.org (Postfix) with UTF8SMTPSA id 7ADF51F000E9;
	Thu,  9 Jul 2026 14:30:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1783607455;
	bh=X4q2V8an7WhkW3fEnV3k4ESCN5eVGEidDfAfO1kbHVI=;
	h=From:To:Cc:Subject:Date;
	b=juSDlELmDrzbvORqjpk7w9VeefuNdjRG87wJP90fHzr3nytcYk8HNbpTzzQs+NxLY
	 O++tCKIAyJy6NFsHLFkhLecFHeDl4PKVnbcwYc3TWSsYBImmKIRQXDuSL18DGAE0Um
	 PYfvMExjNIvmGB61ye4oGkmHVFQ4+POv5eFoOVV7uZaKhVuaqEh61bvC8FPuOpu7/W
	 AvrOFPW0T1UIL+TY+4LUs52uk3OeOqGiQzoThtahxRn9Vc7pBxYmn/mtsbhAe/uvQH
	 NhJ0F7tbJFYQgyXYZKy0zVtJbCpXVYVY5NPg4j28sIGa/1RY+Ar4bEcUso4zBnT+s7
	 K2Ftp8ezHQY2g==
From: "syzbot" <syzbot@kernel.org>
To: syzkaller-upstream-moderation@googlegroups.com
Cc: syzbot@lists.linux.dev
Subject: [PATCH RFC] fuse: abort connection on /dev/fuse flush to prevent deadlock
Message-ID: <bedbc009-8806-4913-9a03-1b25b6d33729@mail.kernel.org>
Precedence: bulk
X-Mailing-List: syzbot@lists.linux.dev
List-Id: <syzbot.lists.linux.dev>
List-Subscribe: <mailto:syzbot+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:syzbot+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Date: Thu,  9 Jul 2026 14:30:55 +0000 (UTC)

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

INFO: task syz.0.17:6117 blocked for more than 143 seconds.
...
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

In fuse_dev_flush(), if this is the last reference to the file descriptor
(file_count(file) == 1) and it is the last device for the FUSE connection,
we proactively abort the FUSE connection. By aborting the connection
synchronously in .flush, any subsequent fuse_flush() calls on FUSE files
will immediately fail with -ENOTCONN instead of blocking indefinitely,
avoiding the deadlock.

Fixes: 4a9d4b024a31 ("switch fput to task_work_add")
Assisted-by: Gemini:gemini-3.1-pro-preview Gemini:gemini-3-flash-preview syzbot
Reported-by: syzbot+0dbb0d6fda088e78a4d8@syzkaller.appspotmail.com
Closes: https://syzkaller.appspot.com/bug?extid=0dbb0d6fda088e78a4d8
Link: https://syzkaller.appspot.com/ai_job?id=2b6a3623-6dc9-49c8-ada9-03747a9847d2
To: <fuse-devel@lists.linux.dev>
To: "Miklos Szeredi" <miklos@szeredi.hu>
Cc: <linux-kernel@vger.kernel.org>

---
diff --git a/fs/fuse/dev.c b/fs/fuse/dev.c
index 5763a7cd3..89e2dea87 100644
--- a/fs/fuse/dev.c
+++ b/fs/fuse/dev.c
@@ -2375,23 +2375,43 @@ static void fuse_dev_show_fdinfo(struct seq_file *seq, struct file *file)
 }
 #endif
 
+static int fuse_dev_flush(struct file *file, fl_owner_t id)
+{
+	struct fuse_dev *fud = fuse_file_to_fud(file);
+	struct fuse_chan *fch = READ_ONCE(fud->chan);
+
+	if (fch && fch != FUSE_DEV_CHAN_DISCONNECTED && file_count(file) == 1) {
+		bool last;
+
+		spin_lock(&fch->lock);
+		last = list_is_singular(&fch->devices);
+		spin_unlock(&fch->lock);
+
+		if (last)
+			fuse_chan_abort(fch, false);
+	}
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
