Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C5CDC364021
	for <syzbot@lists.linux.dev>; Thu, 30 Jul 2026 12:55:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785416136; cv=none; b=HOrfF9r/W3F1ud41RFx81+LDV59YzyBvQc65SlOpqsoeZDCQad9XvsuyioZ9hKLS1Fv9vs9K3E/IdkfGAro08dUqdYqdIRg5FoOy1GaqNHMln5lm1mCi8pSUISjusGHj5Nm2KyA2D8d8/DmTNFpRtyREHR3BMwhHK/6mBsCpEf0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785416136; c=relaxed/simple;
	bh=yd8fzhzBiuX6NV/e8BqK6R+Xsbc7igUORIgcc/d8LN0=;
	h=From:To:Cc:Subject:Message-ID:MIME-Version:Content-Type:Date; b=RZ0REWjYekK+ZKvkD4HItcS/0u2llClKJNks/H5BTNcTVuBmTQLGeiI2utBcVn/HmzJ1NYQmM38hQUvoRc8hE7LaAVAuk5OBAucUeI5urA0LpS2/Hm7txlxYGjBe9g4GHPE0dWq6pEkq9qIw9Lq7jyJGCXpvJQbXTt5kPMIgbd8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=EdHAe/w1; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="EdHAe/w1"
Received: by smtp.kernel.org (Postfix) with UTF8SMTPSA id 5D05A1F00A3A;
	Thu, 30 Jul 2026 12:55:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1785416134;
	bh=7zHvRw/l/cfokfMkhhrBLItr97uIiDVl0sGX+WEXuUw=;
	h=From:To:Cc:Subject:Date;
	b=EdHAe/w1HLMV+2IiPV0LCIF0KsasgJNnGQ9MakHCR6ALT5ITM7tm8oWXJooqFFisX
	 knNuf670w4o7go/P3wQdpm4JNXWSOVjBCixjlBUyORBjum5qlU2vTjkXATg0J0nDWg
	 379gWvR6v7iUnjG932gK7phD6ydA7srY05pEhVwtOHasu2vP3doZkTA6bjLwK0B83J
	 HJlw7yN3BDfs6K6f1tOrshRdadp5pzFEpfgpC03uH6DZeJgLpjiPADSn8EvR+2h3pv
	 VbUtXE8zCaWGy4MjL9bj+OqrCqNFiumdxstoxBxxpeQ5ILBf9lFvogff5VnKTltJpH
	 4tZgShF+j3ZlQ==
From: "syzbot" <syzbot@kernel.org>
To: syzkaller-upstream-moderation@googlegroups.com
Cc: sst@poczta.fm, syzbot@lists.linux.dev
Subject: [PATCH RFC v2] 9p/trans_fd: enforce non-blocking I/O with IOCB_NOWAIT
Message-ID: <92de8bb2-056c-48f7-90f7-fa788e6357e0@mail.kernel.org>
Precedence: bulk
X-Mailing-List: syzbot@lists.linux.dev
List-Id: <syzbot.lists.linux.dev>
List-Subscribe: <mailto:syzbot+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:syzbot+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Date: Thu, 30 Jul 2026 12:55:34 +0000 (UTC)

The 9p filesystem's file descriptor transport uses workqueues to handle
asynchronous reading and writing. When a connection is established, it sets
the O_NONBLOCK flag on the provided file descriptors to prevent workers
from hanging on I/O. However, because the file descriptors are shared with
userspace, a malicious or buggy userspace program can clear the O_NONBLOCK
flag concurrently using fcntl(fd, F_SETFL, ...).

If userspace clears the O_NONBLOCK flag, the read worker (p9_read_work) can
block indefinitely in kernel_read() when reading from an empty pipe. When
the connection is subsequently destroyed, p9_conn_destroy() calls
cancel_work_sync(&m->rq), which hangs forever waiting for the blocked read
worker, eventually triggering the khungtaskd watchdog:

INFO: task blocked for more than 143 seconds.
Call Trace:
 <TASK>
 __schedule+0x17e7/0x5630 kernel/sched/core.c:7234
 schedule+0x164/0x2b0 kernel/sched/core.c:7326
 schedule_timeout+0xc0/0x2c0 kernel/time/sleep_timeout.c:75
 wait_for_completion+0x2ca/0x5e0 kernel/sched/completion.c:153
 __flush_work+0xa63/0xca0 kernel/workqueue.c:4374
 __cancel_work_sync+0xbe/0x110 kernel/workqueue.c:4494
 p9_conn_destroy net/9p/trans_fd.c:805 [inline]
 p9_fd_close+0x23c/0x3f0 net/9p/trans_fd.c:840
 p9_client_create+0x8a6/0xc60 net/9p/client.c:939
 v9fs_session_init+0x46/0xd40 fs/9p/v9fs.c:471
 v9fs_get_tree+0xbd/0xac0 fs/9p/vfs_super.c:97
 vfs_get_tree+0x92/0x2a0 fs/super.c:1694
 do_new_mount+0x319/0xdc0 fs/namespace.c:3841
 __se_sys_mount+0x31d/0x420 fs/namespace.c:4367
 do_syscall_64+0x15f/0x560 arch/x86/entry/syscall_64.c:94
 entry_SYSCALL_64_after_hwframe+0x77/0x7f
 </TASK>

To fix this, do not rely on file->f_flags & O_NONBLOCK to ensure
non-blocking I/O. Instead, replace kernel_read() and kernel_write() with
vfs_iocb_iter_read() and vfs_iocb_iter_write(), passing a kiocb with the
IOCB_NOWAIT flag set. This guarantees non-blocking behavior regardless of
the f_flags state, completely eliminating the race condition with
userspace.

Fixes: ef575281b21e ("9p/trans_fd: always use O_NONBLOCK read/write")
Assisted-by: Gemini:gemini-3.5-flash Gemini:gemini-3.1-pro-preview syzbot
Reported-by: syzbot+ed53e35a1e9dde289579@syzkaller.appspotmail.com
Closes: https://syzkaller.appspot.com/bug?extid=ed53e35a1e9dde289579
Link: https://syzkaller.appspot.com/ai_job?id=7f77983d-c40c-432f-aac6-3aa4872417cb
To: "Dominique Martinet" <asmadeus@codewreck.org>
To: "Eric Van Hensbergen" <ericvh@kernel.org>
To: "Latchesar Ionkov" <lucho@ionkov.net>
To: <v9fs@lists.linux.dev>
Cc: <linux-kernel@vger.kernel.org>
Cc: "Christian Schoenebeck" <linux_oss@crudebyte.com>

---
v2:
- Limit read and write sizes to MAX_RW_COUNT to match kernel_read() and kernel_write() behavior.
- Restore task I/O accounting by calling add_rchar()/add_wchar() and inc_syscr()/inc_syscw().
- Include <linux/sched/xacct.h> for task accounting helper functions.

v1:
https://lore.kernel.org/all/7b6e50bb-fee0-4489-a753-00087e6944ae@mail.kernel.org/T/
---
diff --git a/net/9p/trans_fd.c b/net/9p/trans_fd.c
index eb685b52a..db524bd30 100644
--- a/net/9p/trans_fd.c
+++ b/net/9p/trans_fd.c
@@ -22,6 +22,8 @@
 #include <linux/uaccess.h>
 #include <linux/inet.h>
 #include <linux/file.h>
+#include <linux/fs.h>
+#include <linux/sched/xacct.h>
 #include <linux/fs_context.h>
 #include <linux/slab.h>
 #include <linux/seq_file.h>
@@ -217,7 +219,9 @@ static int p9_fd_read(struct p9_client *client, void *v, int len)
 {
 	int ret;
 	struct p9_trans_fd *ts = NULL;
-	loff_t pos;
+	struct kiocb kiocb;
+	struct iov_iter iter;
+	struct kvec iov = { .iov_base = v, .iov_len = min_t(size_t, len, MAX_RW_COUNT) };
 
 	if (client && client->status != Disconnected)
 		ts = client->trans;
@@ -225,11 +229,19 @@ static int p9_fd_read(struct p9_client *client, void *v, int len)
 	if (!ts)
 		return -EREMOTEIO;
 
-	if (!(ts->rd->f_flags & O_NONBLOCK))
-		p9_debug(P9_DEBUG_ERROR, "blocking read ...\n");
+	init_sync_kiocb(&kiocb, ts->rd);
+	kiocb.ki_pos = ts->rd->f_pos;
+	kiocb.ki_flags |= IOCB_NOWAIT;
+
+	iov_iter_kvec(&iter, ITER_DEST, &iov, 1, iov.iov_len);
+
+	ret = vfs_iocb_iter_read(ts->rd, &kiocb, &iter);
+	if (ret > 0) {
+		ts->rd->f_pos = kiocb.ki_pos;
+		add_rchar(current, ret);
+	}
+	inc_syscr(current);
 
-	pos = ts->rd->f_pos;
-	ret = kernel_read(ts->rd, v, len, &pos);
 	if (ret <= 0 && ret != -ERESTARTSYS && ret != -EAGAIN)
 		client->status = Disconnected;
 	return ret;
@@ -385,6 +397,9 @@ static int p9_fd_write(struct p9_client *client, void *v, int len)
 {
 	ssize_t ret;
 	struct p9_trans_fd *ts = NULL;
+	struct kiocb kiocb;
+	struct iov_iter iter;
+	struct kvec iov = { .iov_base = v, .iov_len = min_t(size_t, len, MAX_RW_COUNT) };
 
 	if (client && client->status != Disconnected)
 		ts = client->trans;
@@ -392,10 +407,19 @@ static int p9_fd_write(struct p9_client *client, void *v, int len)
 	if (!ts)
 		return -EREMOTEIO;
 
-	if (!(ts->wr->f_flags & O_NONBLOCK))
-		p9_debug(P9_DEBUG_ERROR, "blocking write ...\n");
+	init_sync_kiocb(&kiocb, ts->wr);
+	kiocb.ki_pos = ts->wr->f_pos;
+	kiocb.ki_flags |= IOCB_NOWAIT;
+
+	iov_iter_kvec(&iter, ITER_SOURCE, &iov, 1, iov.iov_len);
+
+	ret = vfs_iocb_iter_write(ts->wr, &kiocb, &iter);
+	if (ret > 0) {
+		ts->wr->f_pos = kiocb.ki_pos;
+		add_wchar(current, ret);
+	}
+	inc_syscw(current);
 
-	ret = kernel_write(ts->wr, v, len, &ts->wr->f_pos);
 	if (ret <= 0 && ret != -ERESTARTSYS && ret != -EAGAIN)
 		client->status = Disconnected;
 	return ret;
@@ -728,21 +752,11 @@ static int p9_fd_open(struct p9_client *client, int rfd, int wfd)
 		goto out_free_ts;
 	if (!(ts->rd->f_mode & FMODE_READ))
 		goto out_put_rd;
-	/* Prevent workers from hanging on IO when fd is a pipe.
-	 * It's technically possible for userspace or concurrent mounts to
-	 * modify this flag concurrently, which will likely result in a
-	 * broken filesystem. However, just having bad flags here should
-	 * not crash the kernel or cause any other sort of bug, so mark this
-	 * particular data race as intentional so that tooling (like KCSAN)
-	 * can allow it and detect further problems.
-	 */
-	data_race(ts->rd->f_flags |= O_NONBLOCK);
 	ts->wr = fget(wfd);
 	if (!ts->wr)
 		goto out_put_rd;
 	if (!(ts->wr->f_mode & FMODE_WRITE))
 		goto out_put_wr;
-	data_race(ts->wr->f_flags |= O_NONBLOCK);
 
 	client->trans = ts;
 	client->status = Connected;
@@ -784,8 +798,6 @@ static int p9_socket_open(struct p9_client *client, struct socket *csocket)
 	client->trans = p;
 	client->status = Connected;
 
-	p->rd->f_flags |= O_NONBLOCK;
-
 	p9_conn_create(client);
 	return 0;
 }


base-commit: dc59e4fea9d83f03bad6bddf3fa2e52491777482
-- 
This is an AI-generated patch subject to moderation.
Reply with '#syz upstream' to Sign-off the patch as a human author
and send it to the upstream kernel mailing lists.
Reply with '#syz reject' to reject it ('#syz unreject' to undo).

See https://goo.gle/syzbot-ai-patches for information about AI-generated patches.
You can comment on the patch as usual, syzbot will try to address
the comments and send a new version of the patch if necessary.
syzbot engineers can be reached at syzkaller@googlegroups.com.
