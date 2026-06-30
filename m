Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E4DEB366826
	for <syzbot@lists.linux.dev>; Tue, 30 Jun 2026 16:29:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782836983; cv=none; b=i2S3zDWu4lFKuBKtZZURjL7Iyyw7KpyCCIeM4Za+EBhRQOtsuQE11c9ShYQGa6lHDAT9SY2iiHVndAS2/W1lUGJlieG28S4dTiiJCV8C5CkMo6hqlhYThcnN1CGn9c0o6OVG9y3rPoovUbrqALn0JBPwO1pyEsbSFfC1WMcVrRQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782836983; c=relaxed/simple;
	bh=lfdnkahzFWTDq5GizhXs7WC5Ch/CuaZ5gXr7M6pfJ4E=;
	h=From:To:Cc:Subject:Message-ID:MIME-Version:Content-Type:Date; b=kNPzITmjxTiU731sbchhUxQglMbIHYGNJOqN9348ZlYRw68i6FInNe3nZPctGrhT9XeRqZLiruVcePNTGnS5zfNhnKvzdfvTK4Pv6igfDJF/dvFt3bnEQWErGUKbgyh+drMdP92rzfoFgCX8JvnUCF7smqZ3R575jD7EBnXfkSA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=iMPDu1EP; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="iMPDu1EP"
Received: by smtp.kernel.org (Postfix) with UTF8SMTPSA id 947921F000E9;
	Tue, 30 Jun 2026 16:29:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1782836981;
	bh=KcLdAR84KOYvsNI46L+We6hrwPSXzyl0CLYqYJEyeZU=;
	h=From:To:Cc:Subject:Date;
	b=iMPDu1EPtMy4lURZbYtWe2SyzWSU+s9UZlf59QiDCNOHLdn9LjgBggdAeiYz5l9wx
	 duPTrGSVJ7ShXJmLtzWy/8JT/u5xk2aK8A4y0rhi2GBphoDRWKWHbzo+g2G+tFLr2r
	 3wzfg57cZFrX+GfN7FYM5Gl9z4Q+CnnOVtE9Ga5Y66b0AA+/G1/JOZNURa583c7S1m
	 vYMkRrdtx7qEbO0wxnn8AezoPm45faQ6pOkgYly3c0KJixEsLGGM0Z3oAntLANXP+1
	 xWT3twLY8CFplYUDRur9hWHuHRYEdqW4EzR/acXmzFHNBcNAmtD3ke0XyLdVHNrpeb
	 wFoa35Yub2hJw==
From: "syzbot" <syzbot@kernel.org>
To: syzkaller-upstream-moderation@googlegroups.com
Cc: syzbot@lists.linux.dev
Subject: [PATCH RFC] workqueue, xfs: fix lockdep key exhaustion and ABBA deadlock
Message-ID: <bf1d15d6-92a7-4516-804f-6224a46640c5@mail.kernel.org>
Precedence: bulk
X-Mailing-List: syzbot@lists.linux.dev
List-Id: <syzbot.lists.linux.dev>
List-Subscribe: <mailto:syzbot+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:syzbot+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Date: Tue, 30 Jun 2026 16:29:41 +0000 (UTC)

This patch addresses two related issues: an ABBA deadlock in XFS and a
MAX_LOCKDEP_KEYS exhaustion bug in the workqueue subsystem.

First, a classic ABBA deadlock in XFS is caused by holding a buffer lock
across a synchronous transaction commit. The deadlock involves a task
executing xfs_sync_sb_buf() and another task executing
xlog_cil_push_work(). xfs_sync_sb_buf() allocates a transaction, gets the
superblock buffer, and logs the superblock. It calls xfs_trans_bhold() to
prevent the transaction from unlocking the buffer on commit, and
xfs_trans_set_sync() to make the transaction synchronous. Inside
xfs_trans_commit(), the transaction is added to the CIL, and it waits for
the CIL push to complete. If the filesystem is shut down concurrently, the
CIL push aborts. During abort, xlog_cil_push_work() unpins the log items.
For the superblock buffer log item, xfs_buf_item_unpin() tries to lock the
buffer to simulate an async IO failure. However, the buffer is already
locked by the synchronous commit, resulting in an ABBA deadlock.

The hung task report illustrates the deadlock:

INFO: task kworker/u10:2:47 blocked for more than 143 seconds.
Workqueue: xfs-cil/loop1 xlog_cil_push_work
Call Trace:
 <TASK>
...
 xfs_buf_lock+0x153/0x4c0 fs/xfs/xfs_buf.c:917
 xfs_buf_item_unpin+0x1c5/0x710 fs/xfs/xfs_buf_item.c:551
 xlog_cil_ail_insert fs/xfs/xfs_log_cil.c:-1 [inline]
 xlog_cil_committed+0x9c6/0x1110 fs/xfs/xfs_log_cil.c:995
 xlog_cil_push_work+0x1d27/0x23e0 fs/xfs/xfs_log_cil.c:1607
...
INFO: task task:6727 blocked for more than 143 seconds.
Call Trace:
 <TASK>
...
 wait_for_completion+0x2ca/0x5e0 kernel/sched/completion.c:153
 __flush_workqueue+0x709/0x1470 kernel/workqueue.c:4130
 xlog_cil_push_now fs/xfs/xfs_log_cil.c:1725 [inline]
 xlog_cil_force_seq+0x21a/0x880 fs/xfs/xfs_log_cil.c:1927
 xfs_log_force_seq+0x196/0x440 fs/xfs/xfs_log.c:2984
 __xfs_trans_commit+0x7f7/0xc20 fs/xfs/xfs_trans.c:877
 xfs_trans_commit+0x13e/0x1c0 fs/xfs/xfs_trans.c:926
 xfs_sync_sb_buf+0x13f/0x230 fs/xfs/libxfs/xfs_sb.c:1490
 xfs_ioc_setlabel+0x1d7/0x340 fs/xfs/xfs_ioctl.c:1081
...

To fix this, xfs_sync_sb_buf() is modified to take an extra reference to
the buffer via xfs_buf_hold() instead of using xfs_trans_bhold(). This
allows xfs_trans_commit() to unlock the buffer, preventing the deadlock.
After the commit, the buffer is re-locked, written to disk, and the extra
reference is dropped.

Second, fixing the XFS deadlock allows rapid mount/unmount cycles, which
exposes a MAX_LOCKDEP_KEYS exhaustion bug in the workqueue subsystem. When
a workqueue is destroyed via destroy_workqueue(), it drops the base
references to the pool workqueues (pwq). When the last reference is
dropped, it schedules a kthread work (pwq_release_workfn) which eventually
calls wq_unregister_lockdep() to unregister the lockdep key. Because this
unregistration is fully asynchronous, rapid creation and destruction of
workqueues causes the dynamic lockdep keys to accumulate and eventually
exhaust the MAX_LOCKDEP_KEYS limit.

To fix this, wq_unregister_lockdep() is moved from the asynchronous
pwq_release_workfn() directly into the synchronous destroy_workqueue().
Since destroy_workqueue() drains all pending works and ensures no new works
can be queued, it is safe to unregister the lockdep key synchronously
before dropping the base pwq references, guaranteeing that the lockdep key
is freed immediately.

Fixes: f7664b31975b ("xfs: implement online get/set fs label")
Assisted-by: Gemini:gemini-3.1-pro-preview best-expensive syzbot
Reported-by: syzbot+c27dee924f3271489c82@syzkaller.appspotmail.com
Closes: https://syzkaller.appspot.com/bug?extid=c27dee924f3271489c82
Link: https://syzkaller.appspot.com/ai_job?id=1e521189-2f04-4be9-a2a0-4fc34391ce35
To: "Carlos Maiolino" <cem@kernel.org>
To: <linux-xfs@vger.kernel.org>
To: "Tejun Heo" <tj@kernel.org>
Cc: "Darrick J. Wong" <djwong@kernel.org>
Cc: "Lai Jiangshan" <jiangshanlai@gmail.com>
Cc: <linux-kernel@vger.kernel.org>
Cc: "Nirjhar Roy (IBM)" <nirjhar.roy.lists@gmail.com>

---
diff --git a/fs/xfs/libxfs/xfs_sb.c b/fs/xfs/libxfs/xfs_sb.c
index 47322adb7..c62626c4e 100644
--- a/fs/xfs/libxfs/xfs_sb.c
+++ b/fs/xfs/libxfs/xfs_sb.c
@@ -1480,26 +1480,37 @@ xfs_sync_sb_buf(
 
 	bp = xfs_trans_getsb(tp);
 	xfs_log_sb(tp);
-	xfs_trans_bhold(tp, bp);
+	/*
+	 * Take an extra reference so the buffer isn't freed by commit,
+	 * but allow commit to unlock the buffer to prevent deadlocks
+	 * with CIL push aborts.
+	 */
+	xfs_buf_hold(bp);
 	if (update_rtsb) {
 		rtsb_bp = xfs_log_rtsb(tp, bp);
 		if (rtsb_bp)
-			xfs_trans_bhold(tp, rtsb_bp);
+			xfs_buf_hold(rtsb_bp);
 	}
 	xfs_trans_set_sync(tp);
 	error = xfs_trans_commit(tp);
 	if (error)
-		goto out;
+		goto out_rele;
 	/*
 	 * write out the sb buffer to get the changes to disk
 	 */
+	xfs_buf_lock(bp);
 	error = xfs_bwrite(bp);
-	if (!error && rtsb_bp)
+	xfs_buf_unlock(bp);
+
+	if (rtsb_bp && !error) {
+		xfs_buf_lock(rtsb_bp);
 		error = xfs_bwrite(rtsb_bp);
-out:
+		xfs_buf_unlock(rtsb_bp);
+	}
+out_rele:
 	if (rtsb_bp)
-		xfs_buf_relse(rtsb_bp);
-	xfs_buf_relse(bp);
+		xfs_buf_rele(rtsb_bp);
+	xfs_buf_rele(bp);
 	return error;
 }
 
diff --git a/kernel/workqueue.c b/kernel/workqueue.c
index 78068ae8f..6f182f1ba 100644
--- a/kernel/workqueue.c
+++ b/kernel/workqueue.c
@@ -5241,10 +5241,8 @@ static void pwq_release_workfn(struct kthread_work *work)
 	 * If we're the last pwq going away, @wq is already dead and no one
 	 * is gonna access it anymore.  Schedule RCU free.
 	 */
-	if (is_last) {
-		wq_unregister_lockdep(wq);
+	if (is_last)
 		call_rcu(&wq->rcu, rcu_free_wq);
-	}
 }
 
 /* initialize newly allocated @pwq which is associated with @wq and @pool */
@@ -6104,6 +6102,8 @@ void destroy_workqueue(struct workqueue_struct *wq)
 	list_del_rcu(&wq->list);
 	mutex_unlock(&wq_pool_mutex);
 
+	wq_unregister_lockdep(wq);
+
 	/*
 	 * We're the sole accessor of @wq. Directly access cpu_pwq and dfl_pwq
 	 * to put the base refs. @wq will be auto-destroyed from the last


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
