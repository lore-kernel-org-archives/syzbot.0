Received: from mail-oi1-f197.google.com (mail-oi1-f197.google.com [209.85.167.197])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 81E013403EC
	for <syzbot@lists.linux.dev>; Fri, 26 Jun 2026 19:26:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.167.197
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782501985; cv=none; b=C6hv8EN/j4Lz3PMoiZ4si5vS3oUCxnsrXxkUNt6cz7718iavCFoaTvWhVT96RgUpidBUUjCJD8lmbXVPBf8K6OG7E5X2G3Ubi5cY19wtImCMSvABxHTeFsgGATI8OeDPP+sfSmEIi44c8RwZd5vNHFJbn4wHy8U32COwFmktQ3A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782501985; c=relaxed/simple;
	bh=DSjYzI/goCLxZ64qNl0+REqnqRy2+95wlF1KYioK8kY=;
	h=MIME-Version:Date:In-Reply-To:Message-ID:Subject:From:To:Cc:
	 Content-Type; b=oxw2vc5UiE1gyMLypupw94P1IKYr2EGrOsX7SwWX6IsSRwGc5/JN7Ojk5NdpGCb0J/mFmOMJ+8jMGvf71TT4QIsz1aGemn4ZpMHwXVD73dq5Kdfmk07mHjRBnW9ym8LvbkT87f1XWcJSkaCZIGkPqhaPdtA9oX53B3EdZLsjuzQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com; arc=none smtp.client-ip=209.85.167.197
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com
Received: by mail-oi1-f197.google.com with SMTP id 5614622812f47-48f0e5e664aso1855154b6e.1
        for <syzbot@lists.linux.dev>; Fri, 26 Jun 2026 12:26:23 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1782501982; x=1783106782;
        h=cc:to:from:subject:message-id:in-reply-to:date:mime-version
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=B03IBuGpk3DE8EWese2rXNzlQMYMCo0V15a5Z2zst7I=;
        b=U+ajl/LD0Cyqr8vcQv+BN58WrF9E1pPFIuxiItNks3jHoUVfstJW9E1NaX4B4G9n8F
         7sExUfrBWPMXxkNJhk/npXhd2NL+GUUCH68gUTffl2gguNy8k+GHHNjhkCiAHiD4e1bu
         a8LbIqLlGFudlEUVEArMpo+gKwJnk7ZdXs8HS8hCwxLZWvPM9WlUva+nHRVW/O9YGm/q
         acadZR9Wk28B8FB3+IvPR1G+G3J6QvZFE7fL5doC2SJTgXbphYGLFqN3p7382Hva0iSQ
         DL3rjEajMuJBgT3g+9CutwDiedm1mrPsaJpvD5jQUMdAkRbEi4juusMD6xJortobE0BD
         VGYw==
X-Gm-Message-State: AOJu0Yz6zws0vgsC2Oc0fZPCM2UNeKDgX+b89kApe/d3WI9ls0L4U7WX
	CH7Yl2TBo232vn7T/K1wQiGIw7phh83Wll8ATN3Dy/Xr0/rbglfP6UkCAhEF6XuqL3DbRYn35/I
	dRJpJh7zF6thEbb3E2fRVyeQbXuJR0VFSNd6XR4t/mQTbJT5Ptu7EWn1SN+0=
Precedence: bulk
X-Mailing-List: syzbot@lists.linux.dev
List-Id: <syzbot.lists.linux.dev>
List-Subscribe: <mailto:syzbot+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:syzbot+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Received: by 2002:a05:6808:170c:b0:48b:4218:9326 with SMTP id
 5614622812f47-492180129c7mr6339739b6e.34.1782501982499; Fri, 26 Jun 2026
 12:26:22 -0700 (PDT)
Date: Fri, 26 Jun 2026 12:26:22 -0700
In-Reply-To: <20260626192541.2458445-1-jbingham@gmail.com>
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <6a3ed25e.81aa1f09.c949.0001.GAE@google.com>
Subject: Forwarded: Re: [syzbot ci] Re: minix: convert to iomap and add direct I/O
From: syzbot <syzbot@syzkaller.appspotmail.com>
To: syzbot@lists.linux.dev
Cc: syzbot <syzbot+ci6eb2640f41075c71@syzkaller.appspotmail.com>, jbingham@gmail.com
Content-Type: text/plain; charset="UTF-8"

For archival purposes, forwarding an incoming command email to
syzbot@lists.linux.dev.

***

Subject: Re: [syzbot ci] Re: minix: convert to iomap and add direct I/O
Author: jbingham@gmail.com

#syz test

---
 fs/minix/file.c         | 157 ++++++++++++++++++++++++++++++++++++++--
 fs/minix/inode.c        |  86 ++++++++++++++++++++--
 fs/minix/iomap.c        | 114 +++++++++++++++++++++++++++++
 fs/minix/itree_common.c |  11 ++-
 fs/minix/itree_v1.c     |  25 ++++++-
 fs/minix/itree_v2.c     |  17 ++++-
 fs/minix/minix.h        |  25 ++++++-
 7 files changed, 415 insertions(+), 20 deletions(-)
 create mode 100644 fs/minix/iomap.c

diff --git a/fs/minix/file.c b/fs/minix/file.c
index 86e5943cd2ff..b07c853fa43a 100644
--- a/fs/minix/file.c
+++ b/fs/minix/file.c
@@ -17,21 +17,166 @@ int minix_fsync(struct file *file, loff_t start, loff_t end, int datasync)
 			start, end, datasync);
 }
 
+static ssize_t minix_dio_read_iter(struct kiocb *iocb, struct iov_iter *to)
+{
+	struct inode *inode = iocb->ki_filp->f_mapping->host;
+	ssize_t ret;
+
+	inode_lock_shared(inode);
+
+	const struct iomap_ops *ops = minix_iomap_ops_ver(inode);
+
+	ret = iomap_dio_rw(iocb, to, ops, NULL, 0, NULL, 0);
+	inode_unlock_shared(inode);
+	return ret;
+}
+
+static int minix_dio_write_end_io(struct kiocb *iocb, ssize_t size, int error,
+		unsigned int flags)
+{
+	struct inode *inode = file_inode(iocb->ki_filp);
+	loff_t pos = iocb->ki_pos;
+
+	if (error)
+		return error;
+
+	pos += size;
+	if (size && pos > i_size_read(inode)) {
+		i_size_write(inode, pos);
+		mark_inode_dirty(inode);
+	}
+	return 0;
+}
+
+static const struct iomap_dio_ops minix_dio_write_ops = {
+	.end_io = minix_dio_write_end_io,
+};
+
+static ssize_t minix_dio_write_iter(struct kiocb *iocb, struct iov_iter *from)
+{
+	struct inode *inode = iocb->ki_filp->f_mapping->host;
+	ssize_t ret;
+	unsigned int flags = 0;
+	unsigned long blocksize = inode->i_sb->s_blocksize;
+
+	inode_lock(inode);
+	ret = generic_write_checks(iocb, from);
+	if (ret <= 0)
+		goto out_unlock;
+
+	ret = kiocb_modified(iocb);
+	if (ret)
+		goto out_unlock;
+
+	if (iocb->ki_pos + iov_iter_count(from) > i_size_read(inode) ||
+		!IS_ALIGNED(iocb->ki_pos | iov_iter_alignment(from), blocksize))
+		flags |= IOMAP_DIO_FORCE_WAIT;
+
+	const struct iomap_ops *ops = minix_iomap_ops_ver(inode);
+
+	ret = iomap_dio_rw(iocb, from, ops,
+		&minix_dio_write_ops, flags, NULL, 0);
+	if (ret == -ENOTBLK)
+		ret = 0; /* fallback to buffered */
+
+	if (ret >= 0 && iov_iter_count(from)) {
+		loff_t pos;
+		loff_t endbyte;
+		ssize_t status;
+
+		iocb->ki_flags &= ~IOCB_DIRECT;
+		pos = iocb->ki_pos;
+		status = iomap_file_buffered_write(iocb, from, ops,
+			NULL, NULL);
+		if (unlikely(status < 0)) {
+			ret = status;
+			goto out_unlock;
+		}
+
+		ret += status;
+		endbyte = pos + status - 1;
+		status = filemap_write_and_wait_range(inode->i_mapping, pos, endbyte);
+		if (!status) {
+			invalidate_mapping_pages(inode->i_mapping,
+				pos >> PAGE_SHIFT,
+				endbyte >> PAGE_SHIFT);
+			if (ret > 0)
+				ret = generic_write_sync(iocb, ret);
+		} else {
+			ret = status;
+		}
+	}
+
+out_unlock:
+	inode_unlock(inode);
+	return ret;
+}
+
+static ssize_t minix_file_read_iter(struct kiocb *iocb, struct iov_iter *to)
+{
+	if (iocb->ki_flags & IOCB_DIRECT)
+		return minix_dio_read_iter(iocb, to);
+
+	return generic_file_read_iter(iocb, to);
+}
+
+static ssize_t minix_file_write_iter(struct kiocb *iocb, struct iov_iter *from)
+{
+	struct inode *inode = iocb->ki_filp->f_mapping->host;
+	ssize_t ret;
+
+	/* minix_dio_write_iter also locks the inode and appears to do the same
+	 * general sorts of checks as this, so just return directly from there.
+	 */
+	if (iocb->ki_flags & IOCB_DIRECT)
+		return minix_dio_write_iter(iocb, from);
+
+	inode_lock(inode);
+	ret = generic_write_checks(iocb, from);
+	if (ret <= 0)
+		goto unlock;
+
+	ret = file_modified(iocb->ki_filp);
+	if (ret)
+		goto unlock;
+
+	const struct iomap_ops *ops = minix_iomap_ops_ver(inode);
+
+	ret = iomap_file_buffered_write(iocb, from, ops,
+			NULL, NULL);
+
+	if (ret > 0)
+		ret = generic_write_sync(iocb, ret);
+
+unlock:
+	inode_unlock(inode);
+	return ret;
+}
+
+static int minix_file_open(struct inode *inode, struct file *filp)
+{
+	filp->f_mode |= FMODE_CAN_ODIRECT;
+	return generic_file_open(inode, filp);
+}
+
 /*
- * We have mostly NULLs here: the current defaults are OK for
- * the minix filesystem.
+ * We still have some NULLs here, but not as many of the current defaults are
+ * still OK for the minix filesystem.
  */
+
 const struct file_operations minix_file_operations = {
 	.llseek		= generic_file_llseek,
-	.read_iter	= generic_file_read_iter,
-	.write_iter	= generic_file_write_iter,
+	.read_iter	= minix_file_read_iter,
+	.write_iter	= minix_file_write_iter,
 	.mmap_prepare	= generic_file_mmap_prepare,
+	.open		= minix_file_open,
 	.fsync		= minix_fsync,
 	.splice_read	= filemap_splice_read,
+	.splice_write	= iter_file_splice_write,
 };
 
-static int minix_setattr(struct mnt_idmap *idmap,
-			 struct dentry *dentry, struct iattr *attr)
+int minix_setattr(struct mnt_idmap *idmap, struct dentry *dentry,
+	struct iattr *attr)
 {
 	struct inode *inode = d_inode(dentry);
 	int error;
diff --git a/fs/minix/inode.c b/fs/minix/inode.c
index c30cc590698d..8a79ff82a656 100644
--- a/fs/minix/inode.c
+++ b/fs/minix/inode.c
@@ -436,6 +436,31 @@ static int minix_statfs(struct dentry *dentry, struct kstatfs *buf)
 	return 0;
 }
 
+static ssize_t minix_writeback_range(struct iomap_writepage_ctx *wpc,
+	struct folio *folio, u64 pos, unsigned int len, u64 end_pos)
+{
+	int error;
+
+	if (pos < wpc->iomap.offset ||
+			pos >= wpc->iomap.offset + wpc->iomap.length) {
+		if (INODE_VERSION(wpc->inode) == MINIX_V1)
+			error = V1_minix_iomap_begin(wpc->inode, pos, len, IOMAP_WRITE,
+				&wpc->iomap, NULL);
+		else
+			error = V2_minix_iomap_begin(wpc->inode, pos, len, IOMAP_WRITE,
+				&wpc->iomap, NULL);
+		if (error)
+			return error;
+	}
+
+	return iomap_add_to_ioend(wpc, folio, pos, end_pos, len);
+}
+
+static const struct iomap_writeback_ops minix_writeback_ops = {
+	.writeback_range = minix_writeback_range,
+	.writeback_submit = iomap_ioend_writeback_submit,
+};
+
 static int minix_get_block(struct inode *inode, sector_t block,
 		    struct buffer_head *bh_result, int create)
 {
@@ -445,17 +470,45 @@ static int minix_get_block(struct inode *inode, sector_t block,
 		return V2_minix_get_block(inode, block, bh_result, create);
 }
 
-static int minix_writepages(struct address_space *mapping,
+/* The old minix_writepages, preserved for directory operations. */
+static int minix_block_writepages(struct address_space *mapping,
 		struct writeback_control *wbc)
 {
 	return mpage_writepages(mapping, wbc, minix_get_block);
 }
 
+static int minix_writepages(struct address_space *mapping,
+		struct writeback_control *wbc)
+{
+	struct iomap_writepage_ctx wpc = {
+		.inode = mapping->host,
+		.wbc = wbc,
+		.ops = &minix_writeback_ops,
+	};
+	return iomap_writepages(&wpc);
+}
+
 static int minix_read_folio(struct file *file, struct folio *folio)
+{
+	const struct iomap_ops *ops = minix_iomap_ops_ver(folio->mapping->host);
+
+	iomap_bio_read_folio(folio, ops);
+	return 0;
+}
+
+/* The old minix_read_folio, preserved for directory operations. */
+static int minix_block_read_folio(struct file *file, struct folio *folio)
 {
 	return block_read_full_folio(folio, minix_get_block);
 }
 
+static void minix_readahead(struct readahead_control *rac)
+{
+	const struct iomap_ops *ops = minix_iomap_ops_ver(rac->mapping->host);
+
+	iomap_bio_readahead(rac, ops);
+}
+
 int minix_prepare_chunk(struct folio *folio, loff_t pos, unsigned len)
 {
 	return __block_write_begin(folio, pos, len, minix_get_block);
@@ -487,24 +540,42 @@ static int minix_write_begin(const struct kiocb *iocb,
 
 static sector_t minix_bmap(struct address_space *mapping, sector_t block)
 {
-	return generic_block_bmap(mapping,block,minix_get_block);
+	const struct iomap_ops *ops = minix_iomap_ops_ver(mapping->host);
+
+	return iomap_bmap(mapping, block, ops);
 }
 
-static const struct address_space_operations minix_aops = {
-	.dirty_folio	= block_dirty_folio,
-	.invalidate_folio = block_invalidate_folio,
+const struct address_space_operations minix_aops = {
+	.dirty_folio	= iomap_dirty_folio,
+	.invalidate_folio = iomap_invalidate_folio,
 	.read_folio = minix_read_folio,
+	.readahead = minix_readahead,
 	.writepages = minix_writepages,
+	.migrate_folio = filemap_migrate_folio,
+	.bmap = minix_bmap,
+	.is_partially_uptodate = iomap_is_partially_uptodate,
+	.release_folio = iomap_release_folio,
+	.error_remove_folio = generic_error_remove_folio,
+};
+
+/* A special aops for directories that keeps using the buffer head chunks, at
+ * least for the time being.
+ */
+static const struct address_space_operations minix_dir_aops = {
+	.dirty_folio = block_dirty_folio,
+	.invalidate_folio = block_invalidate_folio,
+	.read_folio = minix_block_read_folio,
 	.write_begin = minix_write_begin,
 	.write_end = generic_write_end,
 	.migrate_folio = buffer_migrate_folio,
 	.bmap = minix_bmap,
-	.direct_IO = noop_direct_IO
+	.writepages = minix_block_writepages,
 };
 
 static const struct inode_operations minix_symlink_inode_operations = {
 	.get_link	= page_get_link,
 	.getattr	= minix_getattr,
+	.setattr	= minix_setattr,
 };
 
 void minix_set_inode(struct inode *inode, dev_t rdev)
@@ -516,7 +587,7 @@ void minix_set_inode(struct inode *inode, dev_t rdev)
 	} else if (S_ISDIR(inode->i_mode)) {
 		inode->i_op = &minix_dir_inode_operations;
 		inode->i_fop = &minix_dir_operations;
-		inode->i_mapping->a_ops = &minix_aops;
+		inode->i_mapping->a_ops = &minix_dir_aops;
 	} else if (S_ISLNK(inode->i_mode)) {
 		inode->i_op = &minix_symlink_inode_operations;
 		inode_nohighmem(inode);
@@ -768,4 +839,3 @@ module_init(init_minix_fs)
 module_exit(exit_minix_fs)
 MODULE_DESCRIPTION("Minix file system");
 MODULE_LICENSE("GPL");
-
diff --git a/fs/minix/iomap.c b/fs/minix/iomap.c
new file mode 100644
index 000000000000..7bb0439e3669
--- /dev/null
+++ b/fs/minix/iomap.c
@@ -0,0 +1,114 @@
+// SPDX-License-Identifier: GPL-2.0-only
+/*
+ * iomap functions for minix. At least the first pass of this file was taken
+ * from the xiafs iomap.c, which is fitting since the xiafs module in turn
+ * borrowed heavily from the modernized minix fs kernel module.
+ */
+
+/*
+ * minix_iomap_begin - map a file range to disk blocks. It acts as a replacement
+ * for get_block in itree_common.c, at least in the important ways, and is
+ * adapted from it, but it uses iomap instead of buffer_head. This is taken
+ * directly from the out-of-tree xiafs iomap changes, and the exfat iomap
+ * changes were an inspiration for that.
+ */
+static int minix_iomap_begin(struct inode *inode, loff_t offset, loff_t length,
+	unsigned int flags, struct iomap *iomap, struct iomap *srcmap)
+{
+	struct super_block *sb = inode->i_sb;
+	unsigned int blkbits = sb->s_blocksize_bits;
+	sector_t iblock = offset >> blkbits;
+	int create = flags & IOMAP_WRITE;
+
+	/* Mostly taken from modern-xiafs itree.c get_block with elements from
+	 * similar exfat operations.
+	 */
+	int offsets[DEPTH];
+	Indirect chain[DEPTH];
+	Indirect *partial;
+	int depth = block_to_path(inode, iblock, offsets);
+	int left;
+	int err = -EIO;
+
+	sector_t phys;
+
+	/* block is beyond max file size */
+	if (depth == 0)
+		goto out;
+
+	iomap->bdev = inode->i_sb->s_bdev;
+
+reread:
+	partial = get_branch(inode, depth, offsets, chain, &err);
+
+	/* Simplest case - block found, no allocation needed */
+	if (!partial) {
+		/* Bit of a weird order, but it'll make sense when you get to
+		 * the bottom.
+		 */
+		iomap->flags = IOMAP_F_MERGED;
+got_it:
+		phys = block_to_cpu(chain[depth - 1].key);
+		partial = chain+depth-1;
+		/* Set up the iomap struct before cleaning up */
+		iomap->type = IOMAP_MAPPED;
+		iomap->addr = (u64)phys << blkbits;
+		iomap->length = 1 << blkbits;
+		iomap->offset = (u64)iblock << blkbits;
+		goto cleanup;
+	}
+
+	/* Next simple case - plain lookup or failed read of indirect block */
+	if (!create || err == -EIO) {
+		iomap->type = IOMAP_HOLE;
+		iomap->addr = IOMAP_NULL_ADDR;
+		iomap->length = 1 << blkbits;
+		iomap->offset = (u64)iblock << blkbits;
+		iomap->flags = 0;
+cleanup:
+		while (partial > chain) {
+			brelse(partial->bh);
+			partial--;
+		}
+out:
+		return err;
+	}
+
+	/*
+	 * Indirect block might be removed by truncate while we were
+	 * reading it. Handling of that case (forget what we've got and
+	 * reread) is taken out of the main path.
+	 */
+	if (err == -EAGAIN)
+		goto changed;
+
+	left = (chain + depth) - partial;
+	err = alloc_branch(inode, left, offsets + (partial - chain), partial);
+	if (err)
+		goto cleanup;
+
+	if (splice_branch(inode, chain, partial, left) < 0)
+		goto changed;
+
+	/* Successful allocation, mapping it. */
+	iomap->flags = IOMAP_F_NEW;
+	goto got_it;
+
+changed:
+	while (partial > chain) {
+		brelse(partial->bh);
+		partial--;
+	}
+	goto reread;
+}
+
+/*
+ * minix_iomap_end ends up being a nop; since minix doesn't have any extents or
+ * transactions to worry about, there isn't anything to update here. The on-disk
+ * indirect blocks get dirtied in minix_iomap_begin.
+ */
+static int minix_iomap_end(struct inode *inode, loff_t offset, loff_t length,
+	ssize_t written, unsigned int flags, struct iomap *iomap)
+{
+	return 0;
+}
diff --git a/fs/minix/itree_common.c b/fs/minix/itree_common.c
index c3cd2c75af9c..5a8b73a7beda 100644
--- a/fs/minix/itree_common.c
+++ b/fs/minix/itree_common.c
@@ -311,7 +311,16 @@ static inline void truncate (struct inode * inode)
 	long iblock;
 
 	iblock = (inode->i_size + sb->s_blocksize -1) >> sb->s_blocksize_bits;
-	block_truncate_page(inode->i_mapping, inode->i_size, get_block);
+
+	/* Depending on what address space operations are being used by the
+	 * inode being truncated, we need to either call iomap_truncate_page or
+	 * block_truncate_page.
+	 */
+	if (inode->i_mapping->a_ops == &minix_aops)
+		iomap_truncate_page(inode, inode->i_size, NULL,
+			minix_iomap_ops_ver(inode), NULL, NULL);
+	else
+		block_truncate_page(inode->i_mapping, inode->i_size, get_block);
 
 	n = block_to_path(inode, iblock, offsets);
 	if (!n)
diff --git a/fs/minix/itree_v1.c b/fs/minix/itree_v1.c
index 1fed906042aa..58c29f4443d3 100644
--- a/fs/minix/itree_v1.c
+++ b/fs/minix/itree_v1.c
@@ -49,6 +49,18 @@ static int block_to_path(struct inode * inode, long block, int offsets[DEPTH])
 }
 
 #include "itree_common.c"
+/* NOTA BENE:
+ *
+ * This is icky to me, but at the same time having it be a standalone C file
+ * that's compiled to object form and linked separately like it is in xiafs is
+ * much nastier in minix because of the different versions of the minix fs that
+ * have some very, very different aspects, like the size of block_t. I don't
+ * like it, but since minix already has this pattern where a common itree file
+ * is included in the itree_v1 and itree_v2(and v3) files, I'm including iomap.c
+ * in these files as well. It does at least avoid exporting some currently
+ * static functions that aren't needed anywhere but itree_common.c and iomap.c.
+ */
+#include "iomap.c"
 
 int V1_minix_get_block(struct inode * inode, long block,
 			struct buffer_head *bh_result, int create)
@@ -61,7 +73,18 @@ void V1_minix_truncate(struct inode * inode)
 	truncate(inode);
 }
 
-unsigned V1_minix_blocks(loff_t size, struct super_block *sb)
+unsigned int V1_minix_blocks(loff_t size, struct super_block *sb)
 {
 	return nblocks(size, sb);
 }
+
+int V1_minix_iomap_begin(struct inode *inode, loff_t offset, loff_t length,
+	unsigned int flags, struct iomap *iomap, struct iomap *srcmap)
+{
+	return minix_iomap_begin(inode, offset, length, flags, iomap, srcmap);
+}
+
+const struct iomap_ops V1_minix_iomap_ops = {
+	.iomap_begin = V1_minix_iomap_begin,
+	.iomap_end   = minix_iomap_end,
+};
diff --git a/fs/minix/itree_v2.c b/fs/minix/itree_v2.c
index 9d00f31a2d9d..fc7a5ae8fa1c 100644
--- a/fs/minix/itree_v2.c
+++ b/fs/minix/itree_v2.c
@@ -57,6 +57,10 @@ static int block_to_path(struct inode * inode, long block, int offsets[DEPTH])
 }
 
 #include "itree_common.c"
+/* See the note in itree_v1 in a comment that starts "NOTA BENE" for an
+ * explanation for why iomap.c is included here.
+ */
+#include "iomap.c"
 
 int V2_minix_get_block(struct inode * inode, long block,
 			struct buffer_head *bh_result, int create)
@@ -69,7 +73,18 @@ void V2_minix_truncate(struct inode * inode)
 	truncate(inode);
 }
 
-unsigned V2_minix_blocks(loff_t size, struct super_block *sb)
+unsigned int V2_minix_blocks(loff_t size, struct super_block *sb)
 {
 	return nblocks(size, sb);
 }
+
+int V2_minix_iomap_begin(struct inode *inode, loff_t offset, loff_t length,
+	unsigned int flags, struct iomap *iomap, struct iomap *srcmap)
+{
+	return minix_iomap_begin(inode, offset, length, flags, iomap, srcmap);
+}
+
+const struct iomap_ops V2_minix_iomap_ops = {
+	.iomap_begin = V2_minix_iomap_begin,
+	.iomap_end   = minix_iomap_end,
+};
diff --git a/fs/minix/minix.h b/fs/minix/minix.h
index f2025c9b5825..270e4e0620a1 100644
--- a/fs/minix/minix.h
+++ b/fs/minix/minix.h
@@ -5,6 +5,7 @@
 #include <linux/fs.h>
 #include <linux/pagemap.h>
 #include <linux/minix_fs.h>
+#include <linux/iomap.h>
 
 #define INODE_VERSION(inode)	minix_sb(inode->i_sb)->s_version
 #define MINIX_V1		0x0001		/* original minix fs */
@@ -56,7 +57,9 @@ int minix_new_block(struct inode *inode);
 void minix_free_block(struct inode *inode, unsigned long block);
 unsigned long minix_count_free_blocks(struct super_block *sb);
 int minix_getattr(struct mnt_idmap *, const struct path *,
-		struct kstat *, u32, unsigned int);
+		struct kstat *, u32, unsigned);
+int minix_setattr(struct mnt_idmap *idmap, struct dentry *dentry,
+	struct iattr *attr);
 int minix_prepare_chunk(struct folio *folio, loff_t pos, unsigned len);
 struct mapping_metadata_bhs *minix_get_metadata_bhs(struct inode *inode);
 int minix_fsync(struct file *file, loff_t start, loff_t end, int datasync);
@@ -80,10 +83,20 @@ int minix_set_link(struct minix_dir_entry *de, struct folio *folio,
 struct minix_dir_entry *minix_dotdot(struct inode*, struct folio **);
 ino_t minix_inode_by_name(struct dentry*);
 
+extern int V1_minix_iomap_begin(struct inode *inode, loff_t offset,
+	loff_t length, unsigned int flags, struct iomap *iomap,
+	struct iomap *srcmap);
+extern int V2_minix_iomap_begin(struct inode *inode, loff_t offset,
+	loff_t length, unsigned int flags, struct iomap *iomap,
+	struct iomap *srcmap);
+
+extern const struct address_space_operations minix_aops;
 extern const struct inode_operations minix_file_inode_operations;
 extern const struct inode_operations minix_dir_inode_operations;
 extern const struct file_operations minix_file_operations;
 extern const struct file_operations minix_dir_operations;
+extern const struct iomap_ops V1_minix_iomap_ops;
+extern const struct iomap_ops V2_minix_iomap_ops;
 
 static inline struct minix_sb_info *minix_sb(struct super_block *sb)
 {
@@ -95,11 +108,17 @@ static inline struct minix_inode_info *minix_i(struct inode *inode)
 	return container_of(inode, struct minix_inode_info, vfs_inode);
 }
 
-static inline unsigned minix_blocks_needed(unsigned bits, unsigned blocksize)
+static inline unsigned int minix_blocks_needed(unsigned int bits, unsigned int blocksize)
 {
 	return DIV_ROUND_UP(bits, blocksize * 8);
 }
 
+static inline const struct iomap_ops *minix_iomap_ops_ver(struct inode *inode)
+{
+	return (INODE_VERSION(inode) == MINIX_V1) ?
+		&V1_minix_iomap_ops : &V2_minix_iomap_ops;
+}
+
 #if defined(CONFIG_MINIX_FS_NATIVE_ENDIAN) && \
 	defined(CONFIG_MINIX_FS_BIG_ENDIAN_16BIT_INDEXED)
 
@@ -129,7 +148,7 @@ static inline unsigned minix_blocks_needed(unsigned bits, unsigned blocksize)
  * big-endian 16bit indexed bitmaps
  */
 
-static inline int minix_find_first_zero_bit(const void *vaddr, unsigned size)
+static inline int minix_find_first_zero_bit(const void *vaddr, unsigned int size)
 {
 	const unsigned short *p = vaddr, *addr = vaddr;
 	unsigned short num;
-- 
2.47.3


