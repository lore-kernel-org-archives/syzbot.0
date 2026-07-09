Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 03C084195BB
	for <syzbot@lists.linux.dev>; Thu,  9 Jul 2026 18:01:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783620087; cv=none; b=sQsv9zQUYOSDkvXwAndgtdvwoY1O7emYvNuZl69PH7OXDrr4GRVHthZWVpJNvM69YP2ewzRHNTbACMLFsyVce1mSNNCQIL5/CnE1AjsErS0kfUFUueGLD1eN5DQGU+pqjEkaZmjF+bXWW2q0evzSHKXsOR2i4s6QAvQYG30b2HU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783620087; c=relaxed/simple;
	bh=rz3IS5XllbKQYq6rc9Omof1mRToEil0ITenGSxg1Ds0=;
	h=From:To:Cc:Subject:Message-ID:MIME-Version:Content-Type:Date; b=uGgcTDdqJTKDXdZ3E2+SafjztyvRklD2yCNC1PLBNB1yUdXfrS405qyQSYMpm7KJpzeE72UXIxtHuiBttxzvopk5ty/s1j4g9GYqbcSJr8uIMHCx2NwAbrtmkQSoAslLopXI/vpQBZlLdJhmC2p6Rq2e+TiphhvabBogGJY4rgU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=a05frpxN; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="a05frpxN"
Received: by smtp.kernel.org (Postfix) with UTF8SMTPSA id 85C941F000E9;
	Thu,  9 Jul 2026 18:01:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1783620085;
	bh=UmvV6/wJbHWROQKXG/MpVvdY6Jt1b1XeBwJhROZoybw=;
	h=From:To:Cc:Subject:Date;
	b=a05frpxNN1EFzDpldyI2mzkQPJ2XrMt48+c1BQHYm4cCOCeccZM6WlwQnEFpu07vv
	 FP4xZ6GQxc32k8mNYaRJ5bcZRoUyA2BIkmt1ueU89z9lQWFqe/xJ+pBRGrdRSZnlA4
	 64SL+ZOISn3X4ALjuoFek5fhwT7NK6BodgV5qVHvpywDd/oN+Ugg60LrtjeAGx+Q5I
	 ZphrXX8nPutVSon9B83AzRwWagwo5KQvU0vsL5XxdqY3KEN91ztlG4J234X2NQVkR+
	 y4cA4djEFctJdUtQYjJOBdQjGY41LiLJ+WlBFkwDNPSwSFel4+r+QQEPvMdPSRA17I
	 yrvV9PpWjCV2A==
From: "syzbot" <syzbot@kernel.org>
To: syzkaller-upstream-moderation@googlegroups.com
Cc: syzbot@lists.linux.dev
Subject: [PATCH RFC] ext4: fix infinite loops in directory operations and xattr block set
Message-ID: <b821c3ea-69cc-4797-8074-6ea3895c6246@mail.kernel.org>
Precedence: bulk
X-Mailing-List: syzbot@lists.linux.dev
List-Id: <syzbot.lists.linux.dev>
List-Subscribe: <mailto:syzbot+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:syzbot+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Date: Thu,  9 Jul 2026 18:01:25 +0000 (UTC)

A maliciously crafted ext4 image can cause a CPU hog and trigger the hung
task watchdog by creating directories with an extremely large i_size but
almost no allocated blocks (mostly sparse holes). When operations like
ext4_empty_dir(), ext4_readdir(), or __ext4_find_entry() iterate over these
directories, they process the holes block-by-block. For a directory
approaching the maximum file size, this results in billions of iterations
without yielding the CPU. While ext4_empty_dir() is spinning, it holds the
parent directory's inode lock, causing other tasks attempting concurrent
operations in the same directory to block indefinitely and trigger the hung
task watchdog:

INFO: task rmdir:6483 blocked for more than 143 seconds.
Call Trace:
 <TASK>
 __schedule+0x16dc/0x5450 kernel/sched/core.c:7234
 rt_mutex_slowlock_block kernel/locking/rtmutex.c:1670 [inline]
 __rt_mutex_slowlock_locked+0x1f84/0x25b0 kernel/locking/rtmutex.c:1787
 rwbase_write_lock+0x14c/0x720 kernel/locking/rwbase_rt.c:251
 inode_lock_nested include/linux/fs.h:1069 [inline]
 __start_dirop fs/namei.c:2918 [inline]
 start_dirop fs/namei.c:2942 [inline]
 filename_rmdir+0x1cd/0x520 fs/namei.c:5431
 __do_sys_rmdir fs/namei.c:5461 [inline]
 __se_sys_rmdir+0x2e/0x140 fs/namei.c:5458
 do_syscall_64+0x15f/0x560 arch/x86/entry/syscall_64.c:94
 </TASK>

Additionally, an attacker could map millions of logical blocks to the same
physical block (overlapping extents). In this scenario, the code would
process the same physical block millions of times, again causing a hang.

To fix these issues, use ext4_map_blocks() to efficiently skip large sparse
holes in directories instead of advancing block-by-block. Explicitly handle
errors from ext4_map_blocks() to abort the loop immediately. Introduce a
read_blocks counter to ensure a valid directory cannot have more mapped
blocks than the total number of blocks in the file system; if read_blocks
exceeds ext4_blocks_count(), abort with -EFSCORRUPTED to prevent hangs from
overlapping extents. Finally, add fatal_signal_pending() and cond_resched()
to ext4_empty_dir() to ensure the task can be killed and does not hog the
CPU.

This patch also fixes a secondary infinite loop in ext4_xattr_block_set().
When a cached xattr block's h_refcount exceeds EXT4_XATTR_REFCOUNT_MAX, the
code jumps to the inserted label to retry, but failed to clear the
MBE_REUSABLE_B bit from the cache entry's flags. This caused the code to
repeatedly find the same non-reusable block in the cache. Fix this by
clearing the MBE_REUSABLE_B bit before retrying.

Fixes: 4e19d6b65fb4 ("ext4: allow directory holes")
Assisted-by: Gemini:gemini-3.1-pro-preview Gemini:gemini-3-flash-preview syzbot
Reported-by: syzbot+e68dbebd9617a9250e8d@syzkaller.appspotmail.com
Closes: https://syzkaller.appspot.com/bug?extid=e68dbebd9617a9250e8d
Link: https://syzkaller.appspot.com/ai_job?id=8fbdc608-c207-4625-89ab-3733b593826d
To: <linux-ext4@vger.kernel.org>
To: "Theodore Ts'o" <tytso@mit.edu>
Cc: "Andreas Dilger" <adilger.kernel@dilger.ca>
Cc: "Jan Kara" <jack@suse.cz>
Cc: "Baokun Li" <libaokun@linux.alibaba.com>
Cc: <linux-kernel@vger.kernel.org>
Cc: "Ojaswin Mujoo" <ojaswin@linux.ibm.com>
Cc: "Ritesh Harjani (IBM)" <ritesh.list@gmail.com>
Cc: "Zhang Yi" <yi.zhang@huawei.com>

---
diff --git a/fs/ext4/dir.c b/fs/ext4/dir.c
index 17edd678f..5b8032114 100644
--- a/fs/ext4/dir.c
+++ b/fs/ext4/dir.c
@@ -138,6 +138,7 @@ static int ext4_readdir(struct file *file, struct dir_context *ctx)
 	struct buffer_head *bh = NULL;
 	struct fscrypt_str fstr = FSTR_INIT(NULL, 0);
 	struct dir_private_info *info = file->private_data;
+	u64 read_blocks = 0;
 
 	err = fscrypt_prepare_readdir(inode);
 	if (err)
@@ -182,14 +183,16 @@ static int ext4_readdir(struct file *file, struct dir_context *ctx)
 		cond_resched();
 		offset = ctx->pos & (sb->s_blocksize - 1);
 		map.m_lblk = ctx->pos >> EXT4_BLOCK_SIZE_BITS(sb);
-		map.m_len = 1;
+		map.m_len = EXT_MAX_BLOCKS - map.m_lblk;
 		err = ext4_map_blocks(NULL, inode, &map, 0);
+		if (err < 0)
+			goto errout;
 		if (err == 0) {
 			/* m_len should never be zero but let's avoid
 			 * an infinite loop if it somehow is */
 			if (map.m_len == 0)
 				map.m_len = 1;
-			ctx->pos += map.m_len * sb->s_blocksize;
+			ctx->pos += (loff_t)map.m_len * sb->s_blocksize;
 			continue;
 		}
 		if (err > 0) {
@@ -216,6 +219,11 @@ static int ext4_readdir(struct file *file, struct dir_context *ctx)
 			ctx->pos += sb->s_blocksize - offset;
 			continue;
 		}
+		if (unlikely(++read_blocks >
+			     ext4_blocks_count(EXT4_SB(sb)->s_es))) {
+			err = -EFSCORRUPTED;
+			goto errout;
+		}
 
 		/* Check the checksum */
 		if (!buffer_verified(bh) &&
diff --git a/fs/ext4/namei.c b/fs/ext4/namei.c
index cc49ae04a..9f5a524d5 100644
--- a/fs/ext4/namei.c
+++ b/fs/ext4/namei.c
@@ -1530,6 +1530,7 @@ static struct buffer_head *__ext4_find_entry(struct inode *dir,
 				   buffer */
 	ext4_lblk_t  nblocks;
 	int i, namelen, retval;
+	u64 read_blocks = 0;
 
 	*res_dir = NULL;
 	sb = dir->i_sb;
@@ -1606,8 +1607,38 @@ static struct buffer_head *__ext4_find_entry(struct inode *dir,
 				goto cleanup_and_exit;
 			}
 		}
-		if ((bh = bh_use[ra_ptr++]) == NULL)
+		if ((bh = bh_use[ra_ptr++]) == NULL) {
+			struct ext4_map_blocks map;
+			int err;
+
+			map.m_lblk = block;
+			map.m_len = EXT_MAX_BLOCKS - block;
+			err = ext4_map_blocks(NULL, dir, &map, 0);
+			if (err < 0) {
+				ret = ERR_PTR(err);
+				goto cleanup_and_exit;
+			}
+			if (err == 0) {
+				u64 skip;
+
+				if (map.m_len == 0)
+					map.m_len = 1;
+				skip = map.m_len - 1;
+				if (block < start && (u64)block + skip >= start)
+					skip = start - block - 1;
+				else if ((u64)block + skip >= nblocks)
+					skip = nblocks - block - 1;
+				block += skip;
+				ra_ptr = ra_max;
+			}
 			goto next;
+		}
+		if (unlikely(++read_blocks >
+			     ext4_blocks_count(EXT4_SB(sb)->s_es))) {
+			brelse(bh);
+			ret = ERR_PTR(-EFSCORRUPTED);
+			goto cleanup_and_exit;
+		}
 		wait_on_buffer(bh);
 		if (!buffer_uptodate(bh)) {
 			EXT4_ERROR_INODE_ERR(dir, EIO,
@@ -3062,10 +3093,11 @@ static struct dentry *ext4_mkdir(struct mnt_idmap *idmap, struct inode *dir,
  */
 bool ext4_empty_dir(struct inode *inode)
 {
-	unsigned int offset;
+	loff_t offset;
 	struct buffer_head *bh;
 	struct ext4_dir_entry_2 *de;
 	struct super_block *sb;
+	u64 read_blocks = 0;
 
 	if (ext4_has_inline_data(inode)) {
 		int has_inline_data = 1;
@@ -3107,17 +3139,42 @@ bool ext4_empty_dir(struct inode *inode)
 	}
 	offset += ext4_rec_len_from_disk(de->rec_len, sb->s_blocksize);
 	while (offset < inode->i_size) {
+		if (fatal_signal_pending(current)) {
+			brelse(bh);
+			return false;
+		}
+		cond_resched();
 		if (!(offset & (sb->s_blocksize - 1))) {
 			unsigned int lblock;
 			brelse(bh);
 			lblock = offset >> EXT4_BLOCK_SIZE_BITS(sb);
 			bh = ext4_read_dirblock(inode, lblock, EITHER);
 			if (bh == NULL) {
+				struct ext4_map_blocks map;
+				int err;
+
+				map.m_lblk = lblock;
+				map.m_len = EXT_MAX_BLOCKS - lblock;
+				err = ext4_map_blocks(NULL, inode, &map, 0);
+				if (err < 0)
+					return false;
+				if (err == 0) {
+					if (map.m_len == 0)
+						map.m_len = 1;
+					offset += (loff_t)map.m_len *
+						  sb->s_blocksize;
+					continue;
+				}
 				offset += sb->s_blocksize;
 				continue;
 			}
 			if (IS_ERR(bh))
 				return false;
+			if (unlikely(++read_blocks >
+				     ext4_blocks_count(EXT4_SB(sb)->s_es))) {
+				brelse(bh);
+				return false;
+			}
 		}
 		de = (struct ext4_dir_entry_2 *) (bh->b_data +
 					(offset & (sb->s_blocksize - 1)));
diff --git a/fs/ext4/xattr.c b/fs/ext4/xattr.c
index 982a1f831..f6f94dd9a 100644
--- a/fs/ext4/xattr.c
+++ b/fs/ext4/xattr.c
@@ -2078,9 +2078,10 @@ ext4_xattr_block_set(handle_t *handle, struct inode *inode,
 				ref = le32_to_cpu(BHDR(new_bh)->h_refcount) + 1;
 				if (ref > EXT4_XATTR_REFCOUNT_MAX) {
 					/*
-					 * Undo everything and check mbcache
-					 * again.
-					 */
+						 * Undo everything and check mbcache
+						 * again.
+						 */
+					clear_bit(MBE_REUSABLE_B, &ce->e_flags);
 					unlock_buffer(new_bh);
 					dquot_free_block(inode,
 							 EXT4_C2B(EXT4_SB(sb),


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
