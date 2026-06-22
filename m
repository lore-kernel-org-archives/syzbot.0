Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8672833A9CF
	for <syzbot@lists.linux.dev>; Mon, 22 Jun 2026 16:25:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782145511; cv=none; b=q5pcGVv2bINTgavAFJqnFV8ZGXP/x9fjRMMWEUcPfwVSmHrQsOYsuIjYn7XCr7fvCzKu66OIaGqd7qi3+frqYgbiW6AGt5R5CHfR/h41h0GhDzPz4R7HC3mNzFdyW386lBWQ94dXMReE1GrqjYSDfiRqS8o7jcfoIBtQmqEtg20=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782145511; c=relaxed/simple;
	bh=SIqlm0DoKA7sTqKaDwr+F+y3EOxOfkPmg1dG3MxeRf8=;
	h=From:To:Cc:Subject:Message-ID:MIME-Version:Content-Type:Date; b=C5XnJM26RN3+h8GzyFm84Gsr407AoJbPZJ2PxWGHaWK9PO0oeAvEtFZ1AsMFuIuda1jtNHCHGBnOwil8DWLTERu2h8FNPQWLBmVEA3SNy6XhE0YkLXeWMDSBU1BC//Pn8fWsY5YWb07M/Inf9AAE2ym1nal5QuIilzJtNRj53hI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=glrAGdK2; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="glrAGdK2"
Received: by smtp.kernel.org (Postfix) with UTF8SMTPSA id 5F81A1F000E9;
	Mon, 22 Jun 2026 16:25:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1782145509;
	bh=yY7sPsooO1PUX/AICM7RAA7wU2oua1gP/uaPt9DVxwI=;
	h=From:To:Cc:Subject:Date;
	b=glrAGdK2v4RLfImYlvlqxGQHqFnDqTsAWlfQKaQ41E8+MbCDLb9BOv7MzTtjiWBOs
	 JoRWyuBelnmFTDaPuC0xMky9JzHR0jgidI2VfTmtTmLHrnZwRBwRn4oaGdT742BUpB
	 mIy294/woO4h151wxr5UBsJ7WDvpO0LRyRpcvs3xuCQ0slzzSeYyg17sP3GTW8/jV4
	 YMKJMiihb/KTndCJZmqFkzbUZ0eXu8Zb7yr4+/+57KUSCa7J6UZXVF+xstRbDVeUBF
	 /hjah9wpjrpOtOTKj6HTHb5ECqKr/89qpN/EWe2dBw/zBbmupGBuejewgZhwwcySq3
	 s60i52XmBYb/A==
From: "syzbot" <syzbot@kernel.org>
To: syzkaller-upstream-moderation@googlegroups.com
Cc: syzbot@lists.linux.dev
Subject: [PATCH RFC] jfs: add dmap integrity check to prevent array-index-out-of-bounds
Message-ID: <bc5e7712-9f0e-4db9-bd6a-47d69eecb17b@mail.kernel.org>
Precedence: bulk
X-Mailing-List: syzbot@lists.linux.dev
List-Id: <syzbot.lists.linux.dev>
List-Subscribe: <mailto:syzbot+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:syzbot+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Date: Mon, 22 Jun 2026 16:25:09 +0000 (UTC)

The JFS file system does not consistently validate the integrity of dmap
(disk allocation map) structures read from disk. The dmap structure
contains a binary buddy summary tree used to manage free blocks. If a
corrupted file system image has an invalid leafidx (the index of the first
leaf in the tree array), operations that traverse or update the tree will
use this corrupted index. This can lead to out-of-bounds array accesses.
For example, in dbAdjTree(), the array index lp is calculated using
tp->dmt_leafidx. A corrupted leafidx causes lp to become out-of-bounds,
triggering a warning.

The issue manifests as the following warning:

lp >= size || lp < 0
WARNING: fs/jfs/jfs_dmap.c:2962 at dbAdjTree fs/jfs/jfs_dmap.c:2962
[inline], CPU#1: jfsCommit/126
WARNING: fs/jfs/jfs_dmap.c:2962 at dbJoin+0xc33/0xd60
fs/jfs/jfs_dmap.c:2930, CPU#1: jfsCommit/126
RIP: 0010:dbAdjTree fs/jfs/jfs_dmap.c:2962 [inline]
RIP: 0010:dbJoin+0xc33/0xd60 fs/jfs/jfs_dmap.c:2930
Call Trace:
 <TASK>
 dbFreeBits+0x4a2/0xd70 fs/jfs/jfs_dmap.c:2427
 dbFreeDmap fs/jfs/jfs_dmap.c:2176 [inline]
 dbFree+0x324/0x650 fs/jfs/jfs_dmap.c:485
 txFreeMap+0x9e6/0xde0 fs/jfs/jfs_txnmgr.c:2517
 xtTruncate+0xd16/0x2eb0 fs/jfs/jfs_xtree.c:2481
 jfs_free_zero_link+0x35b/0x4c0 fs/jfs/namei.c:760
 jfs_evict_inode+0x356/0x430 fs/jfs/inode.c:159
 evict+0x624/0xb50 fs/inode.c:841
 txLazyCommit fs/jfs/jfs_txnmgr.c:2666 [inline]
 jfs_lazycommit+0x44c/0xac0 fs/jfs/jfs_txnmgr.c:2735
 kthread+0x389/0x470 kernel/kthread.c:436
 ret_from_fork+0x514/0xb70 arch/x86/kernel/process.c:158
 ret_from_fork_asm+0x1a/0x30 arch/x86/entry/entry_64.S:245
 </TASK>

To fix this issue, introduce a check_dmap() function to validate the
integrity of dmap structures immediately after they are read from disk.
This function checks the expected values of fields such as nleafs,
l2nleafs, leafidx, height, and budmin, and ensures that the leaf nodes in
the tree array have valid values. Calls to check_dmap() are inserted at all
locations where a dmap page is read, such as in dbFree(), dbUpdatePMap(),
dbAlloc(), dbExtend(), dbAllocCtl(), and dbAllocBottomUp(). If the
validation fails, an error is logged, the metapage is released, and an
error code is returned. Additionally, redundant ad-hoc checks for leafidx
and budmin are removed since the new function comprehensively validates the
structure.

Fixes: 1da177e4c3f4 ("Linux-2.6.12-rc2")
Assisted-by: Gemini:gemini-3.1-pro-preview syzbot
Reported-by: syzbot+a67911c5a11315aa55a8@syzkaller.appspotmail.com
Closes: https://syzkaller.appspot.com/bug?extid=a67911c5a11315aa55a8
Link: https://syzkaller.appspot.com/ai_job?id=ef51a3e1-e77a-4195-beaf-07c88534adc0
To: <jfs-discussion@lists.sourceforge.net>
To: "Dave Kleikamp" <shaggy@kernel.org>
Cc: "Arnaud Lecomte" <contact@arnaud-lcm.com>
Cc: "Kees Cook" <kees@kernel.org>
Cc: <linux-kernel@vger.kernel.org>
Cc: "Yun Zhou" <yun.zhou@windriver.com>
Cc: "Zheng Yu" <zheng.yu@northwestern.edu>

---
diff --git a/fs/jfs/jfs_dmap.c b/fs/jfs/jfs_dmap.c
index a841cf21d..db5d52b56 100644
--- a/fs/jfs/jfs_dmap.c
+++ b/fs/jfs/jfs_dmap.c
@@ -220,6 +220,69 @@ static bool check_dmapctl(struct dmapctl *dcp)
 	return true;
 }
 
+/*
+ * check_dmap - Validate integrity of a dmap structure
+ * @dp: Pointer to the dmap structure to check
+ *
+ * Return: true if valid, false if corrupted
+ */
+static bool check_dmap(struct dmap *dp)
+{
+	struct dmaptree *tp = &dp->tree;
+	u32 nleafs, l2nleafs, leafidx, height;
+	int i;
+
+	nleafs = le32_to_cpu(tp->nleafs);
+	if (unlikely(nleafs != LPERDMAP)) {
+		jfs_err("dmap: invalid nleafs %u (expected %u)", nleafs,
+			LPERDMAP);
+		return false;
+	}
+
+	l2nleafs = le32_to_cpu(tp->l2nleafs);
+	if (unlikely(l2nleafs != L2LPERDMAP)) {
+		jfs_err("dmap: invalid l2nleafs %u (expected %u)", l2nleafs,
+			L2LPERDMAP);
+		return false;
+	}
+
+	leafidx = le32_to_cpu(tp->leafidx);
+	if (unlikely(leafidx != LEAFIND)) {
+		jfs_err("dmap: invalid leafidx %u (expected %u)", leafidx,
+			LEAFIND);
+		return false;
+	}
+
+	height = le32_to_cpu(tp->height);
+	if (unlikely(height != 4)) {
+		jfs_err("dmap: invalid height %u (expected 4)", height);
+		return false;
+	}
+
+	if (unlikely(tp->budmin != BUDMIN)) {
+		jfs_err("dmap: invalid budmin %d (expected %d)", tp->budmin,
+			BUDMIN);
+		return false;
+	}
+
+	/* Check nodes have valid values */
+	for (i = 0; i < leafidx + nleafs; i++) {
+		s8 val = tp->stree[i];
+
+		if (unlikely(val < NOFREE)) {
+			jfs_err("dmap: invalid node value %d at index %d", val,
+				i);
+			return false;
+		} else if (unlikely(val > L2BPERDMAP)) {
+			jfs_err("dmap: node value %d too large at index %d",
+				val, i);
+			return false;
+		}
+	}
+
+	return true;
+}
+
 /*
  * NAME:	dbMount()
  *
@@ -476,6 +539,13 @@ int dbFree(struct inode *ip, s64 blkno, s64 nblocks)
 		}
 		dp = (struct dmap *) mp->data;
 
+		if (unlikely(!check_dmap(dp))) {
+			jfs_error(ip->i_sb, "Corrupt dmap page\n");
+			release_metapage(mp);
+			IREAD_UNLOCK(ipbmap);
+			return -EIO;
+		}
+
 		/* determine the number of blocks to be freed from
 		 * this dmap.
 		 */
@@ -568,8 +638,17 @@ dbUpdatePMap(struct inode *ipbmap,
 			if (mp == NULL)
 				return -EIO;
 			metapage_wait_for_io(mp);
+
+			dp = (struct dmap *)mp->data;
+
+			if (unlikely(!check_dmap(dp))) {
+				jfs_error(ipbmap->i_sb, "Corrupt dmap page\n");
+				release_metapage(mp);
+				return -EIO;
+			}
+		} else {
+			dp = (struct dmap *)mp->data;
 		}
-		dp = (struct dmap *) mp->data;
 
 		/* determine the bit number and word within the dmap of
 		 * the starting block.  also determine how many blocks
@@ -886,6 +965,13 @@ int dbAlloc(struct inode *ip, s64 hint, s64 nblocks, s64 * results)
 
 		dp = (struct dmap *) mp->data;
 
+		if (unlikely(!check_dmap(dp))) {
+			jfs_error(ip->i_sb, "Corrupt dmap page\n");
+			release_metapage(mp);
+			rc = -EIO;
+			goto read_unlock;
+		}
+
 		/* first, try to satisfy the allocation request with the
 		 * blocks beginning at the hint.
 		 */
@@ -1118,6 +1204,13 @@ static int dbExtend(struct inode *ip, s64 blkno, s64 nblocks, s64 addnblocks)
 
 	dp = (struct dmap *) mp->data;
 
+	if (unlikely(!check_dmap(dp))) {
+		jfs_error(ip->i_sb, "Corrupt dmap page\n");
+		release_metapage(mp);
+		IREAD_UNLOCK(ipbmap);
+		return -EIO;
+	}
+
 	/* try to allocate the blocks immediately following the
 	 * current allocation.
 	 */
@@ -1163,11 +1256,6 @@ static int dbAllocNext(struct bmap * bmp, struct dmap * dp, s64 blkno,
 	s8 *leaf;
 	u32 mask;
 
-	if (dp->tree.leafidx != cpu_to_le32(LEAFIND)) {
-		jfs_error(bmp->db_ipbmap->i_sb, "Corrupt dmap page\n");
-		return -EIO;
-	}
-
 	/* pick up a pointer to the leaves of the dmap tree.
 	 */
 	leaf = dp->tree.stree + le32_to_cpu(dp->tree.leafidx);
@@ -1293,11 +1381,6 @@ dbAllocNear(struct bmap * bmp,
 	int word, lword, rc;
 	s8 *leaf;
 
-	if (dp->tree.leafidx != cpu_to_le32(LEAFIND)) {
-		jfs_error(bmp->db_ipbmap->i_sb, "Corrupt dmap page\n");
-		return -EIO;
-	}
-
 	leaf = dp->tree.stree + le32_to_cpu(dp->tree.leafidx);
 
 	/* determine the word within the dmap that holds the hint
@@ -1902,7 +1985,8 @@ dbAllocCtl(struct bmap * bmp, s64 nblocks, int l2nb, s64 blkno, s64 * results)
 			return -EIO;
 		dp = (struct dmap *) mp->data;
 
-		if (dp->tree.budmin < 0) {
+		if (unlikely(!check_dmap(dp))) {
+			jfs_error(bmp->db_ipbmap->i_sb, "Corrupt dmap page\n");
 			release_metapage(mp);
 			return -EIO;
 		}
@@ -1936,6 +2020,13 @@ dbAllocCtl(struct bmap * bmp, s64 nblocks, int l2nb, s64 blkno, s64 * results)
 		}
 		dp = (struct dmap *) mp->data;
 
+		if (unlikely(!check_dmap(dp))) {
+			jfs_error(bmp->db_ipbmap->i_sb, "Corrupt dmap page\n");
+			release_metapage(mp);
+			rc = -EIO;
+			goto backout;
+		}
+
 		/* the dmap better be all free.
 		 */
 		if (dp->tree.stree[ROOT] != L2BPERDMAP) {
@@ -1993,6 +2084,12 @@ dbAllocCtl(struct bmap * bmp, s64 nblocks, int l2nb, s64 blkno, s64 * results)
 		}
 		dp = (struct dmap *) mp->data;
 
+		if (unlikely(!check_dmap(dp))) {
+			jfs_error(bmp->db_ipbmap->i_sb, "Corrupt dmap page\n");
+			release_metapage(mp);
+			continue;
+		}
+
 		/* free the blocks is this dmap.
 		 */
 		if (dbFreeDmap(bmp, dp, b, BPERDMAP)) {
@@ -3308,6 +3405,13 @@ int dbAllocBottomUp(struct inode *ip, s64 blkno, s64 nblocks)
 		}
 		dp = (struct dmap *) mp->data;
 
+		if (unlikely(!check_dmap(dp))) {
+			jfs_error(ip->i_sb, "Corrupt dmap page\n");
+			release_metapage(mp);
+			IREAD_UNLOCK(ipbmap);
+			return -EIO;
+		}
+
 		/* determine the number of blocks to be allocated from
 		 * this dmap.
 		 */


base-commit: 8cd9520d35a6c38db6567e97dd93b1f11f185dc6
-- 
This is an AI-generated patch subject to moderation.
Reply with '#syz upstream' to Sign-off the patch as a human author
and send it to the upstream kernel mailing lists.
Reply with '#syz reject' to reject it ('#syz unreject' to undo).

See https://goo.gle/syzbot-ai-patches for information about AI-generated patches.
You can comment on the patch as usual, syzbot will try to address
the comments and send a new version of the patch if necessary.
syzbot engineers can be reached at syzkaller@googlegroups.com.
