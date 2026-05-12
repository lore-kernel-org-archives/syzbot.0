Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AA83C3ACA5C
	for <syzbot@lists.linux.dev>; Tue, 12 May 2026 09:20:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778577628; cv=none; b=stEw+Q1uoHoCvX7wnnNOMeBJ4IZ+Y5BvHh+FDz8O6ZP+B9aedUSrKq6yF7XIwqbJWnh8Wy1GX4SmsmS+vzdED5xoZRrK4DSfirpymEHlDzD+sN0/7G4rU7CNvr81dNYJD1i4UsSUESDpFLV0/e2hJdGKkvu08uJyDGJHe+E6ZMc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778577628; c=relaxed/simple;
	bh=tqoMxSMnuYMnQseLMpdnCjuGTLE7WlN1ChFq6+mKAUY=;
	h=From:To:Cc:Subject:Message-ID:MIME-Version:Content-Type:Date; b=KYhSneG7BmzNh7KjEEkqzbXyBotLXq1kKWJBlBnRyz2Gc/WMPrKFjx1wd/UgPZLlxKQbLC2CBUqshhChbmipDMfaZhmmbReifmZTBjx7KwKDrRc/0mPYqoDyPzkU6ZpzhANyW7KCJzSQiaKq+rhnJTLa/5sod4n0hoFniRAx4yY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=lo+KUkcy; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="lo+KUkcy"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D3A80C2BCB0;
	Tue, 12 May 2026 09:20:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1778577627;
	bh=tqoMxSMnuYMnQseLMpdnCjuGTLE7WlN1ChFq6+mKAUY=;
	h=From:To:Cc:Subject:Date:From;
	b=lo+KUkcyTXxrBGZtgYKXdIwjweSmA87FUX7k6vZlcb+seZftgyjJTR7kS+dSZ3hdn
	 PbOeGtEGlBzXl9f5FBV3M+u3T3SJjFk/cjmZ8jJEhhOr6VYeLN757PGpkhccxPrdCH
	 LjGMindbD+rqPzemz9a/Y5gIvaCncRekfy1JsZjSDR2RuqvSZRo17YYv9pdaNgqdfW
	 U/hqLdYtv5EW1CuVzTFvMH5cVQsL6sRV1P1+mupfGGb8BSfCPAX5VHIfqmK7/Quyyg
	 rQagEawJGXYwo7bb/NkfGo+akOqxJAVWPkDwVlXwDX/AxaCnt2giVsnjsdiE4TOCyZ
	 TA1D21uLNSqbA==
From: "syzbot" <syzbot@kernel.org>
To: syzkaller-upstream-moderation@googlegroups.com
Cc: syzbot@lists.linux.dev
Subject: [PATCH RFC] jfs: fix use-after-free in jfs_lazycommit during unmount
Message-ID: <0bcfec6b-ff6f-4d60-aa4d-61fd9a5631ed@mail.kernel.org>
Precedence: bulk
X-Mailing-List: syzbot@lists.linux.dev
List-Id: <syzbot.lists.linux.dev>
List-Subscribe: <mailto:syzbot+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:syzbot+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Date: Tue, 12 May 2026 09:20:27 +0000 (UTC)

jfs: fix use-after-free in jfs_lazycommit during unmount

An analysis of a KASAN slab-use-after-free crash reveals a race
condition during the unmounting of a JFS filesystem. When a JFS
filesystem is unmounted, jfs_umount() calls jfs_flush_journal() to flush
all outstanding transactions to disk. jfs_flush_journal() waits until
the commit queue and the sync list are empty, but it does not wait for
the unlock queue to be processed by the jfs_lazycommit background
thread.

Because jfs_flush_journal() only waits for the commit queue to drain, it
can return while transactions are still sitting in the unlock queue or
are actively being processed by jfs_lazycommit. After
jfs_flush_journal() returns, jfs_umount() proceeds to tear down the
filesystem, freeing the allocation maps and the jfs_log structure.
Meanwhile, the jfs_lazycommit thread wakes up, pops the transaction from
the unlock queue, and accesses the now-freed allocation maps and log
structure, eventually causing a use-after-free crash in lmLogSync().

To fix this, introduce txLazyCommitWait() to ensure that jfs_lazycommit
has completely finished processing all transactions for the unmounting
superblock before jfs_umount() proceeds to free the filesystem
structures. This function synchronizes with lmPostGC() to ensure all
transactions removed from the commit queue have been added to the unlock
queue, and then waits until the unlock queue is empty and the lazycommit
thread is no longer active for the given superblock. Invoke this wait
function immediately after jfs_flush_journal() in both jfs_umount() and
jfs_umount_rw().

Fixes: 1da177e4c3f41524e886b7f1b8a0c1fc7321cac2 ("Linux-2.6.12-rc2")
Assisted-by: Gemini:gemini-3.1-pro-preview
Reported-by: syzbot+c732e285f8fc38d15916@syzkaller.appspotmail.com
Link: https://syzkaller.appspot.com/bug?extid=c732e285f8fc38d15916
Link: https://syzkaller.appspot.com/ai_job?id=c822c3b0-8887-45ea-b1af-e9a7ef8a3b72
To: <jfs-discussion@lists.sourceforge.net>
To: <shaggy@kernel.org>
Cc: <linux-kernel@vger.kernel.org>

---
diff --git a/fs/jfs/jfs_txnmgr.c b/fs/jfs/jfs_txnmgr.c
index 083dbbb0c..823250c3c 100644
--- a/fs/jfs/jfs_txnmgr.c
+++ b/fs/jfs/jfs_txnmgr.c
@@ -37,6 +37,7 @@
 #include <linux/moduleparam.h>
 #include <linux/kthread.h>
 #include <linux/seq_file.h>
+#include <linux/delay.h>
 #include "jfs_incore.h"
 #include "jfs_inode.h"
 #include "jfs_filsys.h"
@@ -2772,6 +2773,49 @@ int jfs_lazycommit(void *arg)
 	return 0;
 }
 
+/*
+ * Wait for lazycommit thread to finish processing all transactions
+ * for the given superblock.
+ */
+void txLazyCommitWait(struct super_block *sb)
+{
+	struct jfs_sb_info *sbi = JFS_SBI(sb);
+	struct jfs_log *log = sbi->log;
+	unsigned long flags;
+	struct tblock *tblk;
+	int found;
+
+	if (!log)
+		return;
+
+	/*
+	 * Synchronize with lmPostGC to ensure that all transactions
+	 * removed from cqueue have been added to unlock_queue.
+	 */
+	spin_lock_irqsave(&log->gclock, flags);
+	spin_unlock_irqrestore(&log->gclock, flags);
+
+	do {
+		found = 0;
+		LAZY_LOCK(flags);
+		if (sbi->commit_state & IN_LAZYCOMMIT)
+			found = 1;
+		else {
+			list_for_each_entry(tblk, &TxAnchor.unlock_queue,
+					    cqueue) {
+				if (tblk->sb == sb) {
+					found = 1;
+					break;
+				}
+			}
+		}
+		LAZY_UNLOCK(flags);
+
+		if (found)
+			msleep(10);
+	} while (found);
+}
+
 void txLazyUnlock(struct tblock * tblk)
 {
 	unsigned long flags;
diff --git a/fs/jfs/jfs_txnmgr.h b/fs/jfs/jfs_txnmgr.h
index ba71eb5ce..3b3272ded 100644
--- a/fs/jfs/jfs_txnmgr.h
+++ b/fs/jfs/jfs_txnmgr.h
@@ -295,4 +295,5 @@ extern void txResume(struct super_block *);
 extern void txLazyUnlock(struct tblock *);
 extern int jfs_lazycommit(void *);
 extern int jfs_sync(void *);
+extern void txLazyCommitWait(struct super_block *sb);
 #endif				/* _H_JFS_TXNMGR */
diff --git a/fs/jfs/jfs_umount.c b/fs/jfs/jfs_umount.c
index 18569f1ea..1aca20b1d 100644
--- a/fs/jfs/jfs_umount.c
+++ b/fs/jfs/jfs_umount.c
@@ -21,6 +21,7 @@
 #include "jfs_dmap.h"
 #include "jfs_imap.h"
 #include "jfs_logmgr.h"
+#include "jfs_txnmgr.h"
 #include "jfs_metapage.h"
 #include "jfs_debug.h"
 
@@ -52,11 +53,13 @@ int jfs_umount(struct super_block *sb)
 	 *
 	 * if mounted read-write and log based recovery was enabled
 	 */
-	if ((log = sbi->log))
+	if ((log = sbi->log)) {
 		/*
 		 * Wait for outstanding transactions to be written to log:
 		 */
 		jfs_flush_journal(log, 2);
+		txLazyCommitWait(sb);
+	}
 
 	/*
 	 * Hold log lock so write_special_inodes (lmLogSync) cannot see
@@ -142,6 +145,7 @@ int jfs_umount_rw(struct super_block *sb)
 	 * remove file system from log active file system list.
 	 */
 	jfs_flush_journal(log, 2);
+	txLazyCommitWait(sb);
 
 	/*
 	 * Make sure all metadata makes it to disk


base-commit: 5d6919055dec134de3c40167a490f33c74c12581
-- 
This is an AI-generated patch subject to moderation.
Reply with '#syz upstream' to send it to the mailing list.
Reply with '#syz reject' to reject it.

See  for more information.
