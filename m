Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EEB9F3845CF
	for <syzbot@lists.linux.dev>; Tue, 23 Jun 2026 14:20:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782224424; cv=none; b=k0toaRKcEXhdtheq53r2u9vCvG89KwWbK67XxKFMf2ltQGdsk62kSud0Van4GYBCwyCBQcCJUHzZckdFaFKVA1aO2CZzbM5GlX9ktNW0Bra94hBUcV/JtUeZsj4nlNHSG4G/A/Ugee/ws9yc0TNx3WvXGY+unyBD6QQqRBlINYI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782224424; c=relaxed/simple;
	bh=9TDgYzdU47Bnhubn2vDpaR2Q5MG+dCzDk7yj4vPt668=;
	h=From:To:Cc:Subject:Message-ID:MIME-Version:Content-Type:Date; b=Ln0huwcLPfXrk7pS4GTM9jbBPGh2iN/J0He6sFuun5aSw5b+6bONLX9tYwz8mOm2wNB0HbJe37qfhIsdgjBb7Pf/z3IUFXi5b4z2q0jh0nWJdspaBDTYVKnazgZBg7GQpYIli+iROfg06/NKjLOGpfX96Hf0fbmz33u+kbOjBWA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=kypWD5lf; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="kypWD5lf"
Received: by smtp.kernel.org (Postfix) with UTF8SMTPSA id 869121F000E9;
	Tue, 23 Jun 2026 14:20:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1782224422;
	bh=icbZhN6BMotTVb2XmYbed9lzo296tp6qFVp22wl0Xl8=;
	h=From:To:Cc:Subject:Date;
	b=kypWD5lf61XVaZY4K4LR4VsdEVXfJ5fk0kxhDrUfDWMYvZ+RMaloyAywbaUjr6hR6
	 el/ajLyI/t71GR+n5xEObmrjR3olY8s36zymvNxNZwdlShU6gBiKBzzz1Y2PO32Msn
	 JoS11T/G5W3JcFJY4j+ah6Ee9MbO93lK2fEUUj6S1NOoJX74qj2e/dH9IJ9bg/y+Bj
	 Ss3rbbNjiqwAsRKj1NS8cfhTINTRuqFSoxRGlTwcWzEytiWmtVMKsKFPcKr3MkQ5QF
	 N5QT4EzImggERyUk34YWuw6rHVrgYe3R2Ed580QvGHWCDINUWgjjJKevXcwZOFy4sd
	 K8GYcEh4SjSYg==
From: "syzbot" <syzbot@kernel.org>
To: syzkaller-upstream-moderation@googlegroups.com
Cc: syzbot@lists.linux.dev
Subject: [PATCH RFC] jfs: add dmap integrity check to prevent out-of-bounds access
Message-ID: <7f8f8a8c-bb2c-4b6d-b16e-238d656b8b35@mail.kernel.org>
Precedence: bulk
X-Mailing-List: syzbot@lists.linux.dev
List-Id: <syzbot.lists.linux.dev>
List-Subscribe: <mailto:syzbot+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:syzbot+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Date: Tue, 23 Jun 2026 14:20:22 +0000 (UTC)

The JFS filesystem reads struct dmap structures from disk without properly
validating their integrity. If the dmap structure on disk is corrupted,
fields like dp->tree.nleafs or dp->tree.leafidx can contain unexpectedly
large or invalid values. This leads to out-of-bounds memory accesses in
functions like dbAdjTree() when they attempt to process the corrupted tree
structure, triggering warnings and potentially causing further memory
corruption.

------------[ cut here ]------------
lp >= size || lp < 0
WARNING: fs/jfs/jfs_dmap.c:2962 at dbAdjTree fs/jfs/jfs_dmap.c:2962
[inline], CPU#0: jfsCommit/127
WARNING: fs/jfs/jfs_dmap.c:2962 at dbJoin+0xc33/0xd60
fs/jfs/jfs_dmap.c:2930, CPU#0: jfsCommit/127
Modules linked in:
CPU: 0 UID: 0 PID: 127 Comm: jfsCommit Not tainted
RIP: 0010:dbAdjTree fs/jfs/jfs_dmap.c:2962 [inline]
RIP: 0010:dbJoin+0xc33/0xd60 fs/jfs/jfs_dmap.c:2930
...
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

To fix this, introduce a check_dmap() function that validates the integrity
of the struct dmap immediately after it is read from disk via
read_metapage(). This follows the same pattern established by
check_dmapctl(). The check_dmap() function verifies that nleafs, l2nleafs,
leafidx, height, and budmin match their expected constant values for a
dmap, and that the values in the stree array are within the valid range.

Calls to check_dmap() are inserted in all places where a dmap is read from
disk. If check_dmap() detects corruption, it logs an error, releases the
metapage, unlocks any held locks, and returns -EIO to gracefully abort the
operation. Finally, since dbAlloc() and dbExtend() now fully validate the
dmap immediately after reading it, the partial checks previously present in
dbAllocNear() and dbAllocNext() are redundant and have been removed.

Fixes: 1da177e4c3f4 ("Linux-2.6.12-rc2")
Assisted-by: Gemini:gemini-3.1-pro-preview Gemini:gemini-3-flash-preview syzbot
Reported-by: syzbot+a67911c5a11315aa55a8@syzkaller.appspotmail.com
Closes: https://syzkaller.appspot.com/bug?extid=a67911c5a11315aa55a8
Link: https://syzkaller.appspot.com/ai_job?id=e2636ff7-bd70-4c1b-8aeb-5604f90d04f8
To: <jfs-discussion@lists.sourceforge.net>
To: "Dave Kleikamp" <shaggy@kernel.org>
Cc: "Arnaud Lecomte" <contact@arnaud-lcm.com>
Cc: "Kees Cook" <kees@kernel.org>
Cc: <linux-kernel@vger.kernel.org>
Cc: "Yun Zhou" <yun.zhou@windriver.com>
Cc: "Zheng Yu" <zheng.yu@northwestern.edu>

---
diff --git a/fs/jfs/jfs_dmap.c b/fs/jfs/jfs_dmap.c
index a841cf21d..37c597850 100644
--- a/fs/jfs/jfs_dmap.c
+++ b/fs/jfs/jfs_dmap.c
@@ -133,6 +133,71 @@ static const s8 budtab[256] = {
 	2, 1, 1, 1, 1, 0, 0, 0, 1, 0, 0, 0, 1, 0, 0, -1
 };
 
+/*
+ * check_dmap - Validate integrity of a dmap structure
+ * @dp: Pointer to the dmap structure to check
+ *
+ * Return: true if valid, false if corrupted
+ */
+static bool check_dmap(struct dmap *dp)
+{
+	struct dmaptree *dtp = &dp->tree;
+	u32 nleafs, l2nleafs, leafidx, height;
+	s8 budmin;
+	int i;
+
+	nleafs = le32_to_cpu(dtp->nleafs);
+	if (unlikely(nleafs != LPERDMAP)) {
+		jfs_err("dmap: invalid nleafs %u (expected %u)", nleafs,
+			LPERDMAP);
+		return false;
+	}
+
+	l2nleafs = le32_to_cpu(dtp->l2nleafs);
+	if (unlikely(l2nleafs != L2LPERDMAP)) {
+		jfs_err("dmap: invalid l2nleafs %u (expected %u)", l2nleafs,
+			L2LPERDMAP);
+		return false;
+	}
+
+	leafidx = le32_to_cpu(dtp->leafidx);
+	if (unlikely(leafidx != LEAFIND)) {
+		jfs_err("dmap: invalid leafidx %u (expected %u)", leafidx,
+			LEAFIND);
+		return false;
+	}
+
+	height = le32_to_cpu(dtp->height);
+	if (unlikely(height != 4)) {
+		jfs_err("dmap: invalid height %u (expected 4)", height);
+		return false;
+	}
+
+	budmin = dtp->budmin;
+	if (unlikely(budmin != BUDMIN)) {
+		jfs_err("dmap: invalid budmin %d (expected %d)", budmin,
+			BUDMIN);
+		return false;
+	}
+
+	/* Check leaf nodes have valid values */
+	for (i = leafidx; i < leafidx + nleafs; i++) {
+		s8 val = dtp->stree[i];
+
+		if (unlikely(val < NOFREE)) {
+			jfs_err("dmap: invalid leaf value %d at index %d", val,
+				i);
+			return false;
+		} else if (unlikely(val > BUDMIN)) {
+			jfs_err("dmap: leaf value %d too large at index %d",
+				val, i);
+			return false;
+		}
+	}
+
+	return true;
+}
+
 /*
  * check_dmapctl - Validate integrity of a dmapctl structure
  * @dcp: Pointer to the dmapctl structure to check
@@ -475,6 +540,12 @@ int dbFree(struct inode *ip, s64 blkno, s64 nblocks)
 			return -EIO;
 		}
 		dp = (struct dmap *) mp->data;
+		if (unlikely(!check_dmap(dp))) {
+			jfs_error(ip->i_sb, "Corrupt dmap page\n");
+			release_metapage(mp);
+			IREAD_UNLOCK(ipbmap);
+			return -EIO;
+		}
 
 		/* determine the number of blocks to be freed from
 		 * this dmap.
@@ -568,8 +639,16 @@ dbUpdatePMap(struct inode *ipbmap,
 			if (mp == NULL)
 				return -EIO;
 			metapage_wait_for_io(mp);
+
+			dp = (struct dmap *)mp->data;
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
@@ -885,6 +964,12 @@ int dbAlloc(struct inode *ip, s64 hint, s64 nblocks, s64 * results)
 			goto read_unlock;
 
 		dp = (struct dmap *) mp->data;
+		if (unlikely(!check_dmap(dp))) {
+			jfs_error(ip->i_sb, "Corrupt dmap page\n");
+			release_metapage(mp);
+			rc = -EIO;
+			goto read_unlock;
+		}
 
 		/* first, try to satisfy the allocation request with the
 		 * blocks beginning at the hint.
@@ -1117,6 +1202,12 @@ static int dbExtend(struct inode *ip, s64 blkno, s64 nblocks, s64 addnblocks)
 	}
 
 	dp = (struct dmap *) mp->data;
+	if (unlikely(!check_dmap(dp))) {
+		jfs_error(ip->i_sb, "Corrupt dmap page\n");
+		release_metapage(mp);
+		IREAD_UNLOCK(ipbmap);
+		return -EIO;
+	}
 
 	/* try to allocate the blocks immediately following the
 	 * current allocation.
@@ -1163,11 +1254,6 @@ static int dbAllocNext(struct bmap * bmp, struct dmap * dp, s64 blkno,
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
@@ -1293,11 +1379,6 @@ dbAllocNear(struct bmap * bmp,
 	int word, lword, rc;
 	s8 *leaf;
 
-	if (dp->tree.leafidx != cpu_to_le32(LEAFIND)) {
-		jfs_error(bmp->db_ipbmap->i_sb, "Corrupt dmap page\n");
-		return -EIO;
-	}
-
 	leaf = dp->tree.stree + le32_to_cpu(dp->tree.leafidx);
 
 	/* determine the word within the dmap that holds the hint
@@ -1901,6 +1982,11 @@ dbAllocCtl(struct bmap * bmp, s64 nblocks, int l2nb, s64 blkno, s64 * results)
 		if (mp == NULL)
 			return -EIO;
 		dp = (struct dmap *) mp->data;
+		if (unlikely(!check_dmap(dp))) {
+			jfs_error(bmp->db_ipbmap->i_sb, "Corrupt dmap page\n");
+			release_metapage(mp);
+			return -EIO;
+		}
 
 		if (dp->tree.budmin < 0) {
 			release_metapage(mp);
@@ -1935,6 +2021,12 @@ dbAllocCtl(struct bmap * bmp, s64 nblocks, int l2nb, s64 blkno, s64 * results)
 			goto backout;
 		}
 		dp = (struct dmap *) mp->data;
+		if (unlikely(!check_dmap(dp))) {
+			jfs_error(bmp->db_ipbmap->i_sb, "Corrupt dmap page\n");
+			release_metapage(mp);
+			rc = -EIO;
+			goto backout;
+		}
 
 		/* the dmap better be all free.
 		 */
@@ -1992,6 +2084,11 @@ dbAllocCtl(struct bmap * bmp, s64 nblocks, int l2nb, s64 blkno, s64 * results)
 			continue;
 		}
 		dp = (struct dmap *) mp->data;
+		if (unlikely(!check_dmap(dp))) {
+			jfs_error(bmp->db_ipbmap->i_sb, "Corrupt dmap page\n");
+			release_metapage(mp);
+			continue;
+		}
 
 		/* free the blocks is this dmap.
 		 */
@@ -3307,6 +3404,12 @@ int dbAllocBottomUp(struct inode *ip, s64 blkno, s64 nblocks)
 			return -EIO;
 		}
 		dp = (struct dmap *) mp->data;
+		if (unlikely(!check_dmap(dp))) {
+			jfs_error(ip->i_sb, "Corrupt dmap page\n");
+			release_metapage(mp);
+			IREAD_UNLOCK(ipbmap);
+			return -EIO;
+		}
 
 		/* determine the number of blocks to be allocated from
 		 * this dmap.
@@ -3659,6 +3762,12 @@ int dbExtendFS(struct inode *ipbmap, s64 blkno,	s64 nblocks)
 				}
 
 				dp = (struct dmap *) mp->data;
+				if ((blkno & (BPERDMAP - 1)) &&
+				    unlikely(!check_dmap(dp))) {
+					jfs_error(ipbmap->i_sb,
+						  "Corrupt dmap page\n");
+					goto errout;
+				}
 				*l0leaf = dbInitDmap(dp, blkno, n);
 
 				bmp->db_nfree += n;


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
