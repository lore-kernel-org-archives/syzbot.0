Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F0A9C2DA775
	for <syzbot@lists.linux.dev>; Tue, 12 May 2026 22:03:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778623403; cv=none; b=bH9A86PDDvwP/sTQ/zc/f4Uckb7XdbJXE77cpCt0T+lOgb3JVqBIrL0iccNzkySgKmDHv8wGj+Wq/iHEeH7tClXd56Omx6akFnIysOz+b5xgyPFDK72aHRNntrgLq27suMJnyWKo8Fqe+9BUstYsoexTDt4zg7NZ61YlZ/qhn90=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778623403; c=relaxed/simple;
	bh=NhyKtFWSPQQWF5KfTamdcLUzm19Bl2+oyEH+ufAHTCw=;
	h=From:To:Cc:Subject:Message-ID:MIME-Version:Content-Type:Date; b=OIQN3jFahChn/P4LTF5htJXTT7pWczrnop2j5wzoYw09In0OLsvLhDTvvnyH4E8O9FXblmyb7pHf8c0Tw/8LBgshIQpJjRHtByfXS4m03zuynWiW1hhLfM+4ylmEKMbU8rhdH+WCmgDqz8CqKttRvytJ1NJHV8bamdulkmqd4Vo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=oMaju+ss; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="oMaju+ss"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B60B4C2BCB8;
	Tue, 12 May 2026 22:03:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1778623402;
	bh=NhyKtFWSPQQWF5KfTamdcLUzm19Bl2+oyEH+ufAHTCw=;
	h=From:To:Cc:Subject:Date:From;
	b=oMaju+ssRiNrJHY0veSjEXKCOHtT74jnxNh2gvVrmNwP1q+88agbmVuWuEa4aU3Bz
	 Nnqw9Lguq2EJTnVFQMOiDXX/yotk29EIb1bvCXuE11iVAgWE7jhdjlmDiaiuEMoGDe
	 wCOsbggsIVk9x6PworNgnhjCileQGjFSNZ8+gPhURdSlWHBqYh1ONI1g3ImWXVy5mz
	 6dfOIoN/yPuWZLwM97aaPGD4wUNIHjP34N5JpP3QyW0dLd7REMBg8tl/3o8JRcKzjA
	 Kk/cGo5MOpbHDGdwS611YPSWTtykxHFgmTPFAGmrfUC/iPdQ1JoI/2EleJJpipdWWN
	 0P5TrGIb9VMbg==
From: "syzbot" <syzbot@kernel.org>
To: syzkaller-upstream-moderation@googlegroups.com
Cc: syzbot@lists.linux.dev
Subject: [PATCH RFC] jfs: fix invalid pointer dereference and use-after-free bugs
Message-ID: <938f325a-46c6-4ade-8a21-b3271963810c@mail.kernel.org>
Precedence: bulk
X-Mailing-List: syzbot@lists.linux.dev
List-Id: <syzbot.lists.linux.dev>
List-Subscribe: <mailto:syzbot+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:syzbot+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Date: Tue, 12 May 2026 22:03:22 +0000 (UTC)

This patch addresses multiple issues in JFS, including an invalid
pointer dereference in release_metapage() and use-after-free bugs in the
transaction manager and log manager.

First, in JFS, the root node of an inode's extent tree (xtree) is
embedded within the inode, and a pseudo-metapage is used when the root
page is requested. During truncation, xtTruncate() relies on the on-disk
BT_ROOT flag to identify the root page. If this flag is corrupted and
cleared, the root page is treated as a regular leaf page and passed to
discard_metapage(), which calls release_metapage() and eventually
folio_lock() on a garbage pointer, causing a crash. This is fixed by
replacing the on-disk flag check (p->header.flag & BT_ROOT) with the
robust in-memory BT_IS_ROOT() macro across all relevant locations in
fs/jfs/jfs_xtree.c. This change also fixes a use-after-free in
xtTruncate_pmap() by checking BT_IS_ROOT() before XT_PUTPAGE().

Second, a slab-use-after-free occurs in jfs_lazycommit() because it
clears the IN_LAZYCOMMIT flag from sbi->commit_state after
txLazyCommit() returns. Inside txLazyCommit(), the transaction is marked
as committed and waiters are woken up. If the filesystem is being
unmounted, jfs_flush_journal() wakes up and allows the unmount process
to proceed, freeing the jfs_sb_info (sbi) structure. When txLazyCommit()
returns, jfs_lazycommit() attempts to clear the flag on the freed sbi.
This is fixed by moving the clearing of IN_LAZYCOMMIT into
txLazyCommit() right before wake_up_all(&tblk->gcwait). At this point,
the transaction's map updates are already complete, so it is safe for
another thread to pick up the next transaction for the same superblock.
Furthermore, because log->gclock is held while clearing the flag and
waking up waiters, jfs_flush_journal() cannot return until
txLazyCommit() releases the lock, ensuring that sbi remains valid
throughout the critical section.

Finally, lbmIODone() is modified to set bp->l_flag |= lbmDONE before the
buffer is potentially freed or waiters are woken up, preventing a
use-after-free.

Fixes: 1da177e4c3f41524e886b7f1b8a0c1fc7321cac2 ("Linux-2.6.12-rc2")
Assisted-by: Gemini:gemini-3.1-pro-preview Gemini:gemini-3-flash-preview
Reported-by: syzbot+43706fd1eb4c8dccdfe6@syzkaller.appspotmail.com
Link: https://syzkaller.appspot.com/bug?extid=43706fd1eb4c8dccdfe6
Link: https://syzkaller.appspot.com/ai_job?id=65b961d2-1f93-43e7-a428-83fd01b84838
To: <jfs-discussion@lists.sourceforge.net>
To: <shaggy@kernel.org>
Cc: <linux-kernel@vger.kernel.org>

---
diff --git a/fs/jfs/jfs_logmgr.c b/fs/jfs/jfs_logmgr.c
index 306165e61..99c054e77 100644
--- a/fs/jfs/jfs_logmgr.c
+++ b/fs/jfs/jfs_logmgr.c
@@ -2191,6 +2191,7 @@ static void lbmIODone(struct bio *bio)
 	 */
 	if (bp->l_flag & lbmREAD) {
 		bp->l_flag &= ~lbmREAD;
+		bp->l_flag |= lbmDONE;
 
 		/* wakeup I/O initiator */
 		LCACHE_WAKEUP(&bp->l_ioevent);
@@ -2218,6 +2219,7 @@ static void lbmIODone(struct bio *bio)
 	log->clsn = (bp->l_pn << L2LOGPSIZE) + bp->l_ceor;
 
 	if (bp->l_flag & lbmDIRECT) {
+		bp->l_flag |= lbmDONE;
 		LCACHE_WAKEUP(&bp->l_ioevent);
 		goto out;
 	}
@@ -2263,6 +2265,8 @@ static void lbmIODone(struct bio *bio)
 		}
 	}
 
+	bp->l_flag |= lbmDONE;
+
 	/*
 	 *	synchronous pageout:
 	 *
@@ -2297,7 +2301,6 @@ static void lbmIODone(struct bio *bio)
 	}
 
 out:
-	bp->l_flag |= lbmDONE;
 	LCACHE_UNLOCK(flags);
 }
 
diff --git a/fs/jfs/jfs_txnmgr.c b/fs/jfs/jfs_txnmgr.c
index 083dbbb0c..0161c2c22 100644
--- a/fs/jfs/jfs_txnmgr.c
+++ b/fs/jfs/jfs_txnmgr.c
@@ -2652,6 +2652,7 @@ void txAbort(tid_t tid, int dirty)
 static void txLazyCommit(struct tblock * tblk)
 {
 	struct jfs_log *log;
+	unsigned long flags;
 
 	while (((tblk->flag & tblkGC_READY) == 0) &&
 	       ((tblk->flag & tblkGC_UNLOCKED) == 0)) {
@@ -2674,6 +2675,10 @@ static void txLazyCommit(struct tblock * tblk)
 	if (tblk->flag & tblkGC_READY)
 		log->gcrtc--;
 
+	LAZY_LOCK(flags);
+	JFS_SBI(tblk->sb)->commit_state &= ~IN_LAZYCOMMIT;
+	LAZY_UNLOCK(flags);
+
 	wake_up_all(&tblk->gcwait);	// LOGGC_WAKEUP
 
 	/*
@@ -2735,7 +2740,6 @@ int jfs_lazycommit(void *arg)
 				txLazyCommit(tblk);
 				LAZY_LOCK(flags);
 
-				sbi->commit_state &= ~IN_LAZYCOMMIT;
 				/*
 				 * Don't continue in the for loop.  (We can't
 				 * anyway, it's unsafe!)  We want to go back to
diff --git a/fs/jfs/jfs_xtree.c b/fs/jfs/jfs_xtree.c
index 28c3cf960..6eab0441f 100644
--- a/fs/jfs/jfs_xtree.c
+++ b/fs/jfs/jfs_xtree.c
@@ -703,7 +703,7 @@ xtSplitUp(tid_t tid,
 	sp = XT_PAGE(ip, smp);
 
 	/* is inode xtree root extension/inline EA area free ? */
-	if ((sp->header.flag & BT_ROOT) && (!S_ISDIR(ip->i_mode)) &&
+	if (BT_IS_ROOT(smp) && (!S_ISDIR(ip->i_mode)) &&
 	    (le16_to_cpu(sp->header.maxentry) < XTROOTMAXSLOT) &&
 	    (JFS_IP(ip)->mode2 & INLINEEA)) {
 		sp->header.maxentry = cpu_to_le16(XTROOTMAXSLOT);
@@ -781,9 +781,8 @@ xtSplitUp(tid_t tid,
 	 * and acquire txLock as appropriate.
 	 * return <rp> pinned and its block number <rpbn>.
 	 */
-	rc = (sp->header.flag & BT_ROOT) ?
-	    xtSplitRoot(tid, ip, split, &rmp) :
-	    xtSplitPage(tid, ip, split, &rmp, &rbn);
+	rc = BT_IS_ROOT(smp) ? xtSplitRoot(tid, ip, split, &rmp) :
+			       xtSplitPage(tid, ip, split, &rmp, &rbn);
 
 	XT_PUTPAGE(smp);
 
@@ -857,9 +856,9 @@ xtSplitUp(tid_t tid,
 			 * and acquire txLock as appropriate.
 			 * return <rp> pinned and its block number <rpbn>.
 			 */
-			rc = (sp->header.flag & BT_ROOT) ?
-			    xtSplitRoot(tid, ip, split, &rmp) :
-			    xtSplitPage(tid, ip, split, &rmp, &rbn);
+			rc = BT_IS_ROOT(smp) ?
+				     xtSplitRoot(tid, ip, split, &rmp) :
+				     xtSplitPage(tid, ip, split, &rmp, &rbn);
 			if (rc) {
 				XT_PUTPAGE(smp);
 				return rc;
@@ -2481,7 +2480,7 @@ s64 xtTruncate(tid_t tid, struct inode *ip, s64 newsize, int flag)
 		txFreeMap(ip, (struct maplock *) & xadlock, NULL, COMMIT_WMAP);
 	}
 
-	if (p->header.flag & BT_ROOT) {
+	if (BT_IS_ROOT(mp)) {
 		p->header.flag &= ~BT_INTERNAL;
 		p->header.flag |= BT_LEAF;
 		p->header.nextindex = cpu_to_le16(XTENTRYSTART);
@@ -2630,7 +2629,7 @@ s64 xtTruncate(tid_t tid, struct inode *ip, s64 newsize, int flag)
 		}
 		BT_MARK_DIRTY(mp, ip);
 
-		if (p->header.flag & BT_ROOT) {
+		if (BT_IS_ROOT(mp)) {
 			p->header.flag &= ~BT_INTERNAL;
 			p->header.flag |= BT_LEAF;
 			p->header.nextindex = cpu_to_le16(XTENTRYSTART);
@@ -2869,12 +2868,11 @@ s64 xtTruncate_pmap(tid_t tid, struct inode *ip, s64 committed_size)
 		xtlck->hwm.offset = le16_to_cpu(p->header.nextindex) - 1;
 		tlck->type = tlckXTREE | tlckFREE;
 
-		XT_PUTPAGE(mp);
-
-		if (p->header.flag & BT_ROOT) {
-
+		if (BT_IS_ROOT(mp)) {
+			XT_PUTPAGE(mp);
 			goto out;
 		} else {
+			XT_PUTPAGE(mp);
 			goto getParent;
 		}
 	}


base-commit: 5d6919055dec134de3c40167a490f33c74c12581
-- 
This is an AI-generated patch subject to moderation.
Reply with '#syz upstream' to send it to the mailing list.
Reply with '#syz reject' to reject it.

See  for more information.
