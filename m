Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E94C431E82B
	for <syzbot@lists.linux.dev>; Fri, 24 Jul 2026 19:19:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784920742; cv=none; b=hEr4qUNKLjZVnDZYsytyaFkzRCXPcNSQHynw9alW2YXPi7mHI0hMjTQRd4mSVxiryky0hepxcDG2F5MURbCyXpna+vgtSmBpPYnJFOLq7Yy2DIWhvbkLIcDU99qrtCQ8GZ0ndEFQ2CX/f4n9yMdUHSos7+vHsJuo9lhVliaW45w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784920742; c=relaxed/simple;
	bh=9/G//jeXoXAhp5e4Wu1n3NqsNaDg+LPGLSLBoP2sSdc=;
	h=From:To:Cc:Subject:Message-ID:MIME-Version:Content-Type:Date; b=dt+gLHIqMzrJn4ZJJRzZUzr8zvi75ElKvMFa2rh96rN10da3ne08Av408ObCt2YC0SycWZ/2nsykO9IxgF5Igno0wiCPf6RJd6fqg2NjVy+7iIfssK6wC6TvNJ1tAYaEuUe4vDsY3EBBOpWf/bLq56x+4Z7FOrKwwmJBq+6xHL0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=ezHiNUN5; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="ezHiNUN5"
Received: by smtp.kernel.org (Postfix) with UTF8SMTPSA id 7673C1F000E9;
	Fri, 24 Jul 2026 19:19:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1784920740;
	bh=co9SksKj5bjNNNbfPzb6FUsPfaBDl1fdiblhWGIe8Uc=;
	h=From:To:Cc:Subject:Date;
	b=ezHiNUN5tXT2DQJHAPAb9dN7UiMDhBCIjBIKQb1DzWZmo+vAOHRPKcIbYSthV25lB
	 p2JqnK0yk2P7266EJWqGXxD/sbCd63oco+Uoa9hb7VvKFnB/EolVKPtIIoTy91ao6P
	 bcwOXr9nM/J3FGYz5zTbSjj4Ykhp2NyCjEoHVeAxwIrhqNWNYE0GE2NfejgcpHSOvi
	 AqPATKPui5BqSzF+wvY5Dguzq9qUoZmAnxyf2zHhPlrxPUJxHu2D6MC8tFAXp1qCYw
	 rtWujVjs49qMMsmU5MrA5tzORkU4KI6Spdv2X6opDok6BuqgyDYJrDxKjEiRVEBE2J
	 Tzmaiv0SCcUnw==
From: "syzbot" <syzbot@kernel.org>
To: syzkaller-upstream-moderation@googlegroups.com
Cc: immersa.bartosz.chronowski@gmail.com, syzbot@lists.linux.dev
Subject: [PATCH RFC v3] jfs: validate dmap start before block map operations
Message-ID: <7c3c4fb4-ccbd-486f-b087-6074364ee206@mail.kernel.org>
Precedence: bulk
X-Mailing-List: syzbot@lists.linux.dev
List-Id: <syzbot.lists.linux.dev>
List-Subscribe: <mailto:syzbot+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:syzbot+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Date: Fri, 24 Jul 2026 19:19:00 +0000 (UTC)

A corrupted JFS filesystem image can cause a state where the block
allocation map (bmap) and the dmap pages are out of sync. Specifically, if
a dmap page's `dp->start` is corrupted, it can lead to a mismatch during
block allocation or update operations. The block allocator calculates the
returned block number based on `dp->start` (i.e., `dp->start +
block_index`), while the bitmap update is derived from the block's relative
position within the dmap. If `dp->start` does not match the expected start
block number for that dmap's position in the bmap, the allocator may return
a block number that is already in use (e.g., as an inode table block or
metadata), while marking a completely different block as allocated. This
mismatch leads to duplicate allocations. When a thread later attempts to
lock this duplicate block (for example, during a directory btree split),
`txLock()` detects a metapage conflict because the block is already locked
for another purpose, triggering a kernel BUG:

kernel BUG at fs/jfs/jfs_txnmgr.c:836!
Oops: invalid opcode: 0000 [#1] SMP KASAN NOPTI
RIP: 0010:txLock+0x1cc3/0x1d10 fs/jfs/jfs_txnmgr.c:836
Call Trace:
 <TASK>
 dtSplitRoot+0x38d/0x18a0 fs/jfs/jfs_dtree.c:1924
 dtSplitUp fs/jfs/jfs_dtree.c:990 [inline]
 dtInsert+0xeb2/0x5890 fs/jfs/jfs_dtree.c:868
 jfs_create+0x730/0xae0 fs/jfs/namei.c:138
 vfs_create+0x2c4/0x450 fs/namei.c:4202
 filename_mknodat+0x3e8/0x660 fs/namei.c:5181
...

To fix this, validate that the `dp->start` of the dmap page matches the
expected start block number before performing block map operations.
Rejecting a mismatched start with `-EIO` prevents duplicate allocations
before `txLock()` is reached.

Assisted-by: Gemini:gemini-3.5-flash Gemini:gemini-3.1-pro-preview syzbot
Reported-by: syzbot+a843f6ae2130a987d63b@syzkaller.appspotmail.com
Closes: https://syzkaller.appspot.com/bug?extid=a843f6ae2130a987d63b
Link: https://syzkaller.appspot.com/ai_job?id=bdbf4b4d-3729-479d-89c3-0cee1fcde974
To: <jfs-discussion@lists.sourceforge.net>
To: "Dave Kleikamp" <shaggy@kernel.org>
Cc: "Kees Cook" <kees@kernel.org>
Cc: <linux-kernel@vger.kernel.org>
Cc: "Yun Zhou" <yun.zhou@windriver.com>
Cc: "Zheng Yu" <zheng.yu@northwestern.edu>

---
v3:
- Renamed the patch to "jfs: validate dmap start before block map operations".
- Simplified dbValidateDmap() to only validate that the dmap dp->start matches the expected start block number, removing unproven integrity checks.
- Updated the commit description to explain the exact root cause of the selection/update mismatch and how validating dp->start prevents duplicate allocations before txLock() is reached.

v2:
- Replaced the approach of propagating errors from txLock() with proactive dmap validation.
- Introduced dbValidateDmap() to check dmap page integrity (nblocks, nfree, start address, and tree structure).
- Integrated dmap validation into dbFree(), dbUpdatePMap(), dbAlloc(), dbExtend(), dbAllocCtl(), dbAllocBottomUp(), and dbExtendFS().
- Reverted return type changes for functions in jfs_dtree.c and jfs_xtree.c from the previous version.
https://lore.kernel.org/all/ff86d803-d687-48f6-9cc2-f3d35b27a666@mail.kernel.org/T/

v1:
https://lore.kernel.org/all/9d2eba88-93bf-4f3c-a3b2-b554e1fffe80@mail.kernel.org/T/
---
diff --git a/fs/jfs/jfs_dmap.c b/fs/jfs/jfs_dmap.c
index a841cf21d..f15954c1f 100644
--- a/fs/jfs/jfs_dmap.c
+++ b/fs/jfs/jfs_dmap.c
@@ -98,6 +98,9 @@ static int blkstol2(s64 nb);
 static int cntlz(u32 value);
 static int cnttz(u32 word);
 
+static bool dbValidateDmap(struct super_block *sb, const struct dmap *dp,
+			   s64 expected_start);
+
 static int dbAllocDmapBU(struct bmap * bmp, struct dmap * dp, s64 blkno,
 			 int nblocks);
 static int dbInitDmap(struct dmap * dp, s64 blkno, int nblocks);
@@ -476,6 +479,12 @@ int dbFree(struct inode *ip, s64 blkno, s64 nblocks)
 		}
 		dp = (struct dmap *) mp->data;
 
+		if (!dbValidateDmap(ip->i_sb, dp, blkno & ~(s64)(BPERDMAP - 1))) {
+			release_metapage(mp);
+			IREAD_UNLOCK(ipbmap);
+			return -EIO;
+		}
+
 		/* determine the number of blocks to be freed from
 		 * this dmap.
 		 */
@@ -568,6 +577,13 @@ dbUpdatePMap(struct inode *ipbmap,
 			if (mp == NULL)
 				return -EIO;
 			metapage_wait_for_io(mp);
+
+			if (!dbValidateDmap(ipbmap->i_sb,
+					    (struct dmap *) mp->data,
+					    blkno & ~(s64)(BPERDMAP - 1))) {
+				release_metapage(mp);
+				return -EIO;
+			}
 		}
 		dp = (struct dmap *) mp->data;
 
@@ -886,6 +902,11 @@ int dbAlloc(struct inode *ip, s64 hint, s64 nblocks, s64 * results)
 
 		dp = (struct dmap *) mp->data;
 
+		if (!dbValidateDmap(ip->i_sb, dp, blkno & ~(s64)(BPERDMAP - 1))) {
+			release_metapage(mp);
+			goto read_unlock;
+		}
+
 		/* first, try to satisfy the allocation request with the
 		 * blocks beginning at the hint.
 		 */
@@ -1118,6 +1139,12 @@ static int dbExtend(struct inode *ip, s64 blkno, s64 nblocks, s64 addnblocks)
 
 	dp = (struct dmap *) mp->data;
 
+	if (!dbValidateDmap(ip->i_sb, dp, extblkno & ~(s64)(BPERDMAP - 1))) {
+		release_metapage(mp);
+		IREAD_UNLOCK(ipbmap);
+		return -EIO;
+	}
+
 	/* try to allocate the blocks immediately following the
 	 * current allocation.
 	 */
@@ -1902,7 +1929,7 @@ dbAllocCtl(struct bmap * bmp, s64 nblocks, int l2nb, s64 blkno, s64 * results)
 			return -EIO;
 		dp = (struct dmap *) mp->data;
 
-		if (dp->tree.budmin < 0) {
+		if (!dbValidateDmap(bmp->db_ipbmap->i_sb, dp, blkno & ~(s64)(BPERDMAP - 1))) {
 			release_metapage(mp);
 			return -EIO;
 		}
@@ -1936,6 +1963,12 @@ dbAllocCtl(struct bmap * bmp, s64 nblocks, int l2nb, s64 blkno, s64 * results)
 		}
 		dp = (struct dmap *) mp->data;
 
+		if (!dbValidateDmap(bmp->db_ipbmap->i_sb, dp, b & ~(s64)(BPERDMAP - 1))) {
+			release_metapage(mp);
+			rc = -EIO;
+			goto backout;
+		}
+
 		/* the dmap better be all free.
 		 */
 		if (dp->tree.stree[ROOT] != L2BPERDMAP) {
@@ -1993,6 +2026,11 @@ dbAllocCtl(struct bmap * bmp, s64 nblocks, int l2nb, s64 blkno, s64 * results)
 		}
 		dp = (struct dmap *) mp->data;
 
+		if (!dbValidateDmap(bmp->db_ipbmap->i_sb, dp, b & ~(s64)(BPERDMAP - 1))) {
+			release_metapage(mp);
+			continue;
+		}
+
 		/* free the blocks is this dmap.
 		 */
 		if (dbFreeDmap(bmp, dp, b, BPERDMAP)) {
@@ -2134,6 +2172,18 @@ static int dbAllocDmap(struct bmap * bmp, struct dmap * dp, s64 blkno,
 	return (rc);
 }
 
+static bool dbValidateDmap(struct super_block *sb, const struct dmap *dp,
+			   s64 expected_start)
+{
+	if (le64_to_cpu(dp->start) != expected_start) {
+		jfs_error(sb, "corrupt dmap page: start %lld expected %lld\n",
+			  (long long)le64_to_cpu(dp->start),
+			  (long long)expected_start);
+		return false;
+	}
+
+	return true;
+}
 
 /*
  * NAME:	dbFreeDmap()
@@ -3308,6 +3358,12 @@ int dbAllocBottomUp(struct inode *ip, s64 blkno, s64 nblocks)
 		}
 		dp = (struct dmap *) mp->data;
 
+		if (!dbValidateDmap(ip->i_sb, dp, blkno & ~(s64)(BPERDMAP - 1))) {
+			release_metapage(mp);
+			IREAD_UNLOCK(ipbmap);
+			return -EIO;
+		}
+
 		/* determine the number of blocks to be allocated from
 		 * this dmap.
 		 */


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
