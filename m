Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D6EBC3E51E2
	for <syzbot@lists.linux.dev>; Tue, 13 Oct 2026 10:09:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791886142; cv=none; b=QdzQ2phhP0HEiW6wEXVk0F7Biqkts37dILz4/Zt+iXa+fQFHht0vS5JQoRJv4ttPJR7vz2QIoKWA3cvS2iecFz1X0NMS3hlLp2KKcgpQKr2Tej2xU0QVDvKWDEjpOF6RDlrcrW/Ryn2C+GGLBHNV03j8Z6M6EJok8zkNlXv9UNY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791886142; c=relaxed/simple;
	bh=mqoOrF2mYghsXVEVs0pA19pC8sKkN1ydYeyY2rjBUQc=;
	h=From:To:Cc:Subject:Message-ID:MIME-Version:Content-Type:Date; b=FWXvBUxXHiy/Q/mLvXpn+VfH/7ikaMgQryQ7Tq8tL0ba7w2L0ePLhfWUUnqB5XrFRiuWoYW/uNLp28Es/dGNZ0y1m+YUmUeaCAUUpmNTXwG9tHz7VYLmtXiu731vzdBFPLsxx2lAJ3/giNSm/uYTtRBnql/7ITZuPDv5xBqvIz0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=G7+4KUfL; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="G7+4KUfL"
Received: by smtp.kernel.org (Postfix) with UTF8SMTPSA id 604531F000FF;
	Tue, 13 Oct 2026 10:09:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1791886140;
	bh=baymPg1cnfVUfi71WGv47beCJRZ49BofQnN50zn56IM=;
	h=From:To:Cc:Subject:Date;
	b=G7+4KUfLpfGtox7Knai4fYyIbXmyqJFhHFMcaTcaR8ML8wKvAAsWsl/eZ+wRcBhZR
	 LazsfDa6fGgrpzEhIHS7KyBaNd6WxkbfP2S8ABNFyz6f5+FiNGDImBLhZruxa9ELn4
	 qYmfYlFH4Ca9JeNX27Br1RmIf1C3lCkhRyZOB4MD5zajNhWQ8D0v4ESlylrUrcBJOd
	 gp50rI159AqBvCSW9hicZJJ84bT5FDjzGQZEk0d0nEpp06U7jWlmXBVK2KmDBCgxCZ
	 y9Hl64N4WMPol561pjo865LVHxKhnu4p+E0Xgurhky/nVf9TyBFHJAV2SoyNZX0CBK
	 KZcTFC/M//3cA==
From: "syzbot" <syzbot@kernel.org>
To: syzkaller-upstream-moderation@googlegroups.com
Cc: syzbot@lists.linux.dev
Subject: [PATCH RFC] minix: restore buffer uptodate flag on persistent metadata buffers
Message-ID: <1aa7350c-565f-4f86-a95a-28fabee9abba@mail.kernel.org>
Precedence: bulk
X-Mailing-List: syzbot@lists.linux.dev
List-Id: <syzbot.lists.linux.dev>
List-Subscribe: <mailto:syzbot+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:syzbot+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Date: Tue, 13 Oct 2026 10:09:00 +0000 (UTC)

When a minix filesystem experiences a writeback failure on a block device
(for example, when an underlying device is detached or encounters an I/O
error), the block layer I/O completion handler clears the BH_Uptodate flag
and sets BH_Write_EIO on the failed buffer head. In minix, the superblock
buffer (sbi->s_sbh) and bitmap buffers (sbi->s_imap and sbi->s_zmap) are
read at mount time and kept pinned in memory in minix_sb_info throughout
the lifetime of the filesystem mount. Although their in-memory data remains
valid, when subsequent operations modify and re-dirty these buffers—such as
during unmount in minix_put_super() after sync_filesystem() attempts
writeout, during remount in minix_reconfigure(), or during inode and block
allocations or deallocations—mark_buffer_dirty() checks the uptodate state
and triggers a warning:

!buffer_uptodate(bh)
WARNING: fs/buffer.c:991 at mark_buffer_dirty+0x299/0x410 fs/buffer.c:991
...
Call Trace:
 <TASK>
 minix_put_super+0x16d/0x460 fs/minix/inode.c:70
 generic_shutdown_super+0x13d/0x2d0 fs/super.c:751
 kill_block_super+0x44/0xa0 fs/super.c:1903
 deactivate_locked_super+0xbe/0x110 fs/super.c:586
 cleanup_mnt+0x204/0x2a0 fs/namespace.c:1392
 </TASK>

Following the pattern in ext2, ext4, and udf, fix this by restoring the
BH_Uptodate flag and clearing any write error on persistent metadata
buffers before marking them dirty. Introduce a helper
minix_set_buffer_uptodate() to clear BH_Write_EIO and set BH_Uptodate if
the buffer had an error or was not marked uptodate. Use
minix_clear_super_error() to log any prior superblock I/O error via
pr_err() and restore the uptodate flag before dirtying the superblock in
minix_put_super() and minix_reconfigure(). Similarly, call
minix_set_buffer_uptodate() before mark_buffer_dirty() on block and inode
bitmap buffers in minix_free_block(), minix_new_block(),
minix_free_inode(), and minix_new_inode(). Transient metadata buffers (such
as raw inode blocks and indirect blocks) are left untouched so errors
propagate normally.

Fixes: 1da177e4c3f4 ("Linux-2.6.12-rc2")
Assisted-by: Gemini:gemini-3.8-flash Gemini:gemini-3.1-pro-preview syzbot
Reported-by: syzbot+d35de3666410c93fd821@syzkaller.appspotmail.com
Closes: https://syzkaller.appspot.com/bug?extid=d35de3666410c93fd821
Link: https://syzkaller.appspot.com/ai_job?id=6f8ed031-e95a-4ac4-a2bd-3033ec4cadd9
To: <linux-kernel@vger.kernel.org>
To: "Linus Torvalds" <torvalds@ppc970.osdl.org>
Cc: "Christian Brauner" <brauner@kernel.org>
Cc: "Darrick J. Wong" <djwong@kernel.org>
Cc: "Jan Kara" <jack@suse.cz>
Cc: "Jori Koolstra" <jkoolstra@xs4all.nl>
Cc: "Michael Bommarito" <michael.bommarito@gmail.com>

---
diff --git a/fs/minix/bitmap.c b/fs/minix/bitmap.c
index abec43833..1650d22c3 100644
--- a/fs/minix/bitmap.c
+++ b/fs/minix/bitmap.c
@@ -64,6 +64,7 @@ void minix_free_block(struct inode *inode, unsigned long block)
 		printk("minix_free_block (%s:%lu): bit already cleared\n",
 		       sb->s_id, block);
 	spin_unlock(&bitmap_lock);
+	minix_set_buffer_uptodate(bh);
 	mark_buffer_dirty(bh);
 	return;
 }
@@ -83,6 +84,7 @@ int minix_new_block(struct inode * inode)
 		if (j < bits_per_zone) {
 			minix_set_bit(j, bh->b_data);
 			spin_unlock(&bitmap_lock);
+			minix_set_buffer_uptodate(bh);
 			mark_buffer_dirty(bh);
 			j += i * bits_per_zone + sbi->s_firstdatazone-1;
 			if (j < sbi->s_firstdatazone || j >= sbi->s_nzones)
@@ -207,6 +209,7 @@ void minix_free_inode(struct inode * inode)
 	if (!minix_test_and_clear_bit(bit, bh->b_data))
 		printk("minix_free_inode: bit %lu already cleared\n", bit);
 	spin_unlock(&bitmap_lock);
+	minix_set_buffer_uptodate(bh);
 	mark_buffer_dirty(bh);
 }
 
@@ -243,6 +246,7 @@ struct inode *minix_new_inode(const struct inode *dir, umode_t mode)
 		return ERR_PTR(-ENOSPC);
 	}
 	spin_unlock(&bitmap_lock);
+	minix_set_buffer_uptodate(bh);
 	mark_buffer_dirty(bh);
 	j += i * bits_per_zone;
 	if (!j || j > sbi->s_ninodes) {
diff --git a/fs/minix/inode.c b/fs/minix/inode.c
index daf83e4ff..c715f37a5 100644
--- a/fs/minix/inode.c
+++ b/fs/minix/inode.c
@@ -59,6 +59,18 @@ static void minix_evict_inode(struct inode *inode)
 		minix_free_inode(inode);
 }
 
+static void minix_clear_super_error(struct super_block *sb)
+{
+	struct minix_sb_info *sbi = minix_sb(sb);
+	struct buffer_head *sbh = sbi->s_sbh;
+
+	if (buffer_write_io_error(sbh) || !buffer_uptodate(sbh)) {
+		pr_err("MINIX-fs: %s: previous I/O error to superblock detected\n",
+		       sb->s_id);
+		minix_set_buffer_uptodate(sbh);
+	}
+}
+
 static void minix_put_super(struct super_block *sb)
 {
 	int i;
@@ -67,6 +79,7 @@ static void minix_put_super(struct super_block *sb)
 	if (!sb_rdonly(sb)) {
 		if (sbi->s_version != MINIX_V3)	 /* s_state is now out from V3 sb */
 			sbi->s_ms->s_state = sbi->s_mount_state;
+		minix_clear_super_error(sb);
 		mark_buffer_dirty(sbi->s_sbh);
 	}
 	for (i = 0; i < sbi->s_imap_blocks; i++)
@@ -153,6 +166,7 @@ static int minix_reconfigure(struct fs_context *fc)
 		/* Mounting a rw partition read-only. */
 		if (sbi->s_version != MINIX_V3)
 			ms->s_state = sbi->s_mount_state;
+		minix_clear_super_error(sb);
 		mark_buffer_dirty(sbi->s_sbh);
 	} else {
 	  	/* Mount a partition which is read-only, read-write. */
@@ -162,6 +176,7 @@ static int minix_reconfigure(struct fs_context *fc)
 		} else {
 			sbi->s_mount_state = MINIX_VALID_FS;
 		}
+		minix_clear_super_error(sb);
 		mark_buffer_dirty(sbi->s_sbh);
 
 		if (!(sbi->s_mount_state & MINIX_VALID_FS))
diff --git a/fs/minix/minix.h b/fs/minix/minix.h
index 78722ce22..b0806cd23 100644
--- a/fs/minix/minix.h
+++ b/fs/minix/minix.h
@@ -5,6 +5,7 @@
 #include <linux/fs.h>
 #include <linux/pagemap.h>
 #include <linux/minix_fs.h>
+#include <linux/buffer_head.h>
 
 #define INODE_VERSION(inode)	minix_sb(inode->i_sb)->s_version
 #define MINIX_V1		0x0001		/* original minix fs */
@@ -43,6 +44,21 @@ struct minix_sb_info {
 	unsigned short s_version;
 };
 
+/*
+ * Persistent in-memory metadata buffers (superblock, inode/zone bitmaps)
+ * are read once at mount time and kept pinned. If a previous writeback
+ * failed, BH_Uptodate was cleared and BH_Write_EIO was set. Restore the
+ * uptodate flag and clear the error before dirtying so that mark_buffer_dirty()
+ * does not trigger a warning.
+ */
+static inline void minix_set_buffer_uptodate(struct buffer_head *bh)
+{
+	if (buffer_write_io_error(bh) || !buffer_uptodate(bh)) {
+		clear_buffer_write_io_error(bh);
+		set_buffer_uptodate(bh);
+	}
+}
+
 void __minix_error_inode(struct inode *inode, const char *function,
 			 unsigned int line, const char *fmt, ...);
 


base-commit: 24a19b953e2a3d0ea5a8c4951a0ab8f32720c907
-- 
This is an AI-generated patch subject to moderation.
Reply with '#syz upstream' to Sign-off the patch as a human author
and send it to the upstream kernel mailing lists.
Reply with '#syz reject' to reject it ('#syz unreject' to undo).

See https://goo.gle/syzbot-ai-patches for information about AI-generated patches.
You can comment on the patch as usual, syzbot will try to address
the comments and send a new version of the patch if necessary.
syzbot engineers can be reached at syzkaller@googlegroups.com.
