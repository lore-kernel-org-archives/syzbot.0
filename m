Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6FCB02EC57C
	for <syzbot@lists.linux.dev>; Thu, 16 Jul 2026 03:23:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784172217; cv=none; b=KAEN2unozeNu4uFVwf14XzvIPDeendBWNEYB2bViDYosm4xSmjDtQNGpLKD2TWc9dylGO96Sbrjpx8EyS+hn04ySGrJQ12KuMGDrXMegx64zDzR8ntYtwl11GgVgdg08Lg3Yuf9k9CGHtwUdbRGy1bRtHmZr90wQ5FpPasHcNaA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784172217; c=relaxed/simple;
	bh=xjzxB29wmF7XFnPfFvncDzrZ84lB5IpuEInprvPDens=;
	h=From:To:Cc:Subject:Message-ID:MIME-Version:Content-Type:Date; b=t3uQqb/7X3yDBL1A6OvS5QawOHU+DdFtHORX7uocigA7kcmHKSSB7JlpLoJItqoIeZZndxKa5hx/OnWRcptZMP3SZr7O45gIP1uFQjcKYtN/lc7mM+ucc15/hm+6XKfCNsuS5JulGj5tzsmpBXl2XHRaaONbZ/u/T0jb+iDa9Mc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Oz4Ahi40; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Oz4Ahi40"
Received: by smtp.kernel.org (Postfix) with UTF8SMTPSA id E8AEA1F000E9;
	Thu, 16 Jul 2026 03:23:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1784172215;
	bh=030RrN3XZTkKkDwnulNGb1bDwli/ptzcXD5xi5qXd9E=;
	h=From:To:Cc:Subject:Date;
	b=Oz4Ahi40vgySL3Eo1Go5SeiLmxFs1peV/hnp/OTn5ucwRNVaKDqkG28RgN+nTevrY
	 vgGoBE2g3KAsrZo5A13s53d+gZ0izY13/mgppil7ZYNgCLOh/ziKe1OwroIN85duV6
	 Sm2hHiKy6h8XsWk+BvmD0C/3kVbUPWtP+MNf0t65/l1UwPy0+y0KYJycy6leGPqSY6
	 1KTiBOEhbK0YW5gpMwtIoNkDPwviAs/avTOYTytdKuOyEYGAj+cg/4hS2KF0lTz822
	 unwg1dJUUJDFMwTwUolFht2xOllzOqI5w8gUUQDO6MLhrJUlTlBcyaYhiWblZcNNWY
	 NfZNIGGN1/ihQ==
From: "syzbot" <syzbot@kernel.org>
To: syzkaller-upstream-moderation@googlegroups.com
Cc: immersa.bartosz.chronowski@gmail.com, syzbot@lists.linux.dev
Subject: [PATCH RFC v2] jfs: add dmap validation to prevent txLock BUG
Message-ID: <ff86d803-d687-48f6-9cc2-f3d35b27a666@mail.kernel.org>
Precedence: bulk
X-Mailing-List: syzbot@lists.linux.dev
List-Id: <syzbot.lists.linux.dev>
List-Subscribe: <mailto:syzbot+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:syzbot+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Date: Thu, 16 Jul 2026 03:23:34 +0000 (UTC)

A corrupted JFS filesystem image can cause a state where the block
allocation map (bmap) and the inode map are out of sync. Specifically, a
block can be incorrectly marked as free in the bmap while it is actually in
use (e.g., as an inode table block). This inconsistency leads to a BUG() in
txLock() when a thread attempts to allocate the block for a directory btree
split while it is already locked by another process for a different
purpose.

The crash manifests in txLock() as it detects a metapage conflict, but
txLock() is merely the sink for the underlying corruption. The root cause
is the lack of validation when reading dmap pages from the block map.

------------[ cut here ]------------
kernel BUG at fs/jfs/jfs_txnmgr.c:836!
Oops: invalid opcode: 0000 [#1] SMP KASAN NOPTI
CPU: 1 UID: 0 PID: 5785 Comm: syz.0.124 Not tainted syzkaller #1
PREEMPT(full)
RIP: 0010:txLock+0x1cc3/0x1d10 fs/jfs/jfs_txnmgr.c:836
Call Trace:
 <TASK>
 dtSplitRoot+0x38d/0x18a0 fs/jfs/jfs_dtree.c:1924
 dtSplitUp fs/jfs/jfs_dtree.c:990 [inline]
 dtInsert+0xeb2/0x5890 fs/jfs/jfs_dtree.c:868
 jfs_create+0x730/0xae0 fs/jfs/namei.c:138
 vfs_create+0x2c4/0x450 fs/namei.c:4202
...

This patch introduces dbValidateDmap() to verify the integrity of dmap
structures upon access. It checks for valid block counts, free block
counts, consistent start addresses, and internal tree metadata (height,
leafs, etc.). If validation fails, the filesystem is marked as corrupted
with jfs_error() and -EIO is returned to the caller, preventing the
corruption from reaching the transaction manager.

Fixes: 1da177e4c3f4 ("Linux-2.6.12-rc2")
Assisted-by: Gemini:gemini-3.1-pro-preview Gemini:gemini-3-flash-preview syzbot
Reported-by: syzbot+a843f6ae2130a987d63b@syzkaller.appspotmail.com
Closes: https://syzkaller.appspot.com/bug?extid=a843f6ae2130a987d63b
Link: https://syzkaller.appspot.com/ai_job?id=8dc49502-691a-48e9-907b-7e005180b8b2
To: <jfs-discussion@lists.sourceforge.net>
To: "Dave Kleikamp" <shaggy@kernel.org>
To: "Linus Torvalds" <torvalds@ppc970.osdl.org>
Cc: "Arnd Bergmann" <arnd@arndb.de>
Cc: "Christian Brauner (Amutable)" <brauner@kernel.org>
Cc: "Kees Cook" <kees@kernel.org>
Cc: <linux-kernel@vger.kernel.org>
Cc: "Mike Rapoport (Microsoft)" <rppt@kernel.org>
Cc: "Yun Zhou" <yun.zhou@windriver.com>
Cc: "Zheng Yu" <zheng.yu@northwestern.edu>

---
v2:
- Replaced the approach of propagating errors from txLock() with proactive dmap validation.
- Introduced dbValidateDmap() to check dmap page integrity (nblocks, nfree, start address, and tree structure).
- Integrated dmap validation into dbFree(), dbUpdatePMap(), dbAlloc(), dbExtend(), dbAllocCtl(), dbAllocBottomUp(), and dbExtendFS().
- Reverted return type changes for functions in jfs_dtree.c and jfs_xtree.c from the previous version.

v1:
https://lore.kernel.org/all/9d2eba88-93bf-4f3c-a3b2-b554e1fffe80@mail.kernel.org/T/
---
diff --git a/fs/jfs/jfs_dmap.c b/fs/jfs/jfs_dmap.c
index a841cf21d..66a3d5416 100644
--- a/fs/jfs/jfs_dmap.c
+++ b/fs/jfs/jfs_dmap.c
@@ -98,6 +98,8 @@ static int blkstol2(s64 nb);
 static int cntlz(u32 value);
 static int cnttz(u32 word);
 
+static int dbValidateDmap(struct dmap *dp, s64 dmap_blkno);
+
 static int dbAllocDmapBU(struct bmap * bmp, struct dmap * dp, s64 blkno,
 			 int nblocks);
 static int dbInitDmap(struct dmap * dp, s64 blkno, int nblocks);
@@ -476,6 +478,13 @@ int dbFree(struct inode *ip, s64 blkno, s64 nblocks)
 		}
 		dp = (struct dmap *) mp->data;
 
+		if (dbValidateDmap(dp, blkno & ~(s64)(BPERDMAP - 1))) {
+			jfs_error(ip->i_sb, "error in block map\n");
+			release_metapage(mp);
+			IREAD_UNLOCK(ipbmap);
+			return -EIO;
+		}
+
 		/* determine the number of blocks to be freed from
 		 * this dmap.
 		 */
@@ -563,13 +572,20 @@ dbUpdatePMap(struct inode *ipbmap,
 				write_metapage(mp);
 			}
 
-			mp = read_metapage(bmp->db_ipbmap, lblkno, PSIZE,
-					   0);
+			mp = read_metapage(bmp->db_ipbmap, lblkno, PSIZE, 0);
 			if (mp == NULL)
 				return -EIO;
 			metapage_wait_for_io(mp);
-		}
-		dp = (struct dmap *) mp->data;
+
+			dp = (struct dmap *)mp->data;
+
+			if (dbValidateDmap(dp, blkno & ~(s64)(BPERDMAP - 1))) {
+				jfs_error(ipbmap->i_sb, "error in block map\n");
+				release_metapage(mp);
+				return -EIO;
+			}
+		} else
+			dp = (struct dmap *)mp->data;
 
 		/* determine the bit number and word within the dmap of
 		 * the starting block.  also determine how many blocks
@@ -884,7 +900,13 @@ int dbAlloc(struct inode *ip, s64 hint, s64 nblocks, s64 * results)
 		if (mp == NULL)
 			goto read_unlock;
 
-		dp = (struct dmap *) mp->data;
+		dp = (struct dmap *)mp->data;
+
+		if (dbValidateDmap(dp, blkno & ~(s64)(BPERDMAP - 1))) {
+			jfs_error(ip->i_sb, "error in block map\n");
+			release_metapage(mp);
+			goto read_unlock;
+		}
 
 		/* first, try to satisfy the allocation request with the
 		 * blocks beginning at the hint.
@@ -1118,6 +1140,13 @@ static int dbExtend(struct inode *ip, s64 blkno, s64 nblocks, s64 addnblocks)
 
 	dp = (struct dmap *) mp->data;
 
+	if (dbValidateDmap(dp, extblkno & ~(s64)(BPERDMAP - 1))) {
+		jfs_error(ip->i_sb, "error in block map\n");
+		release_metapage(mp);
+		IREAD_UNLOCK(ipbmap);
+		return -EIO;
+	}
+
 	/* try to allocate the blocks immediately following the
 	 * current allocation.
 	 */
@@ -1900,7 +1929,13 @@ dbAllocCtl(struct bmap * bmp, s64 nblocks, int l2nb, s64 blkno, s64 * results)
 		mp = read_metapage(bmp->db_ipbmap, lblkno, PSIZE, 0);
 		if (mp == NULL)
 			return -EIO;
-		dp = (struct dmap *) mp->data;
+		dp = (struct dmap *)mp->data;
+
+		if (dbValidateDmap(dp, blkno & ~(s64)(BPERDMAP - 1))) {
+			jfs_error(bmp->db_ipbmap->i_sb, "error in block map\n");
+			release_metapage(mp);
+			return -EIO;
+		}
 
 		if (dp->tree.budmin < 0) {
 			release_metapage(mp);
@@ -1934,7 +1969,14 @@ dbAllocCtl(struct bmap * bmp, s64 nblocks, int l2nb, s64 blkno, s64 * results)
 			rc = -EIO;
 			goto backout;
 		}
-		dp = (struct dmap *) mp->data;
+		dp = (struct dmap *)mp->data;
+
+		if (dbValidateDmap(dp, b & ~(s64)(BPERDMAP - 1))) {
+			jfs_error(bmp->db_ipbmap->i_sb, "error in block map\n");
+			release_metapage(mp);
+			rc = -EIO;
+			goto backout;
+		}
 
 		/* the dmap better be all free.
 		 */
@@ -1973,12 +2015,11 @@ dbAllocCtl(struct bmap * bmp, s64 nblocks, int l2nb, s64 blkno, s64 * results)
 	 * we fail in backing out the allocation, we'll mark the file
 	 * system to indicate that blocks have been leaked.
 	 */
-      backout:
+backout:
 
 	/* try to backout the allocations dmap by dmap.
 	 */
-	for (n = nblocks - n, b = blkno; n > 0;
-	     n -= BPERDMAP, b += BPERDMAP) {
+	for (n = nblocks - n, b = blkno; n > 0; n -= BPERDMAP, b += BPERDMAP) {
 		/* get the buffer for this dmap.
 		 */
 		lblkno = BLKTODMAP(b, bmp->db_l2nbperpage);
@@ -1991,7 +2032,13 @@ dbAllocCtl(struct bmap * bmp, s64 nblocks, int l2nb, s64 blkno, s64 * results)
 				  "I/O Error: Block Leakage\n");
 			continue;
 		}
-		dp = (struct dmap *) mp->data;
+		dp = (struct dmap *)mp->data;
+
+		if (dbValidateDmap(dp, b & ~(s64)(BPERDMAP - 1))) {
+			jfs_error(bmp->db_ipbmap->i_sb, "error in block map\n");
+			release_metapage(mp);
+			continue;
+		}
 
 		/* free the blocks is this dmap.
 		 */
@@ -2134,6 +2181,34 @@ static int dbAllocDmap(struct bmap * bmp, struct dmap * dp, s64 blkno,
 	return (rc);
 }
 
+static int dbValidateDmap(struct dmap *dp, s64 dmap_blkno)
+{
+	struct dmaptree *tp = &dp->tree;
+
+	if (le32_to_cpu(dp->nblocks) == 0 ||
+	    le32_to_cpu(dp->nblocks) > BPERDMAP)
+		return -EIO;
+
+	if (le32_to_cpu(dp->nfree) > le32_to_cpu(dp->nblocks))
+		return -EIO;
+
+	if (le64_to_cpu(dp->start) != dmap_blkno)
+		return -EIO;
+
+	if (le32_to_cpu(tp->nleafs) != LPERDMAP ||
+	    le32_to_cpu(tp->l2nleafs) != L2LPERDMAP ||
+	    le32_to_cpu(tp->leafidx) != LEAFIND ||
+	    le32_to_cpu(tp->height) != 4 || tp->budmin != BUDMIN)
+		return -EIO;
+
+	if (tp->stree[ROOT] < NOFREE || tp->stree[ROOT] > L2BPERDMAP)
+		return -EIO;
+
+	if (le32_to_cpu(dp->nfree) == 0 && tp->stree[ROOT] != NOFREE)
+		return -EIO;
+
+	return 0;
+}
 
 /*
  * NAME:	dbFreeDmap()
@@ -3308,6 +3383,13 @@ int dbAllocBottomUp(struct inode *ip, s64 blkno, s64 nblocks)
 		}
 		dp = (struct dmap *) mp->data;
 
+		if (dbValidateDmap(dp, blkno & ~(s64)(BPERDMAP - 1))) {
+			jfs_error(ip->i_sb, "error in block map\n");
+			release_metapage(mp);
+			IREAD_UNLOCK(ipbmap);
+			return -EIO;
+		}
+
 		/* determine the number of blocks to be allocated from
 		 * this dmap.
 		 */
@@ -3643,22 +3725,33 @@ int dbExtendFS(struct inode *ipbmap, s64 blkno,	s64 nblocks)
 				 */
 				if ((n = blkno & (BPERDMAP - 1))) {
 					/* read in dmap page: */
-					mp = read_metapage(ipbmap, p,
-							   PSIZE, 0);
+					mp = read_metapage(ipbmap, p, PSIZE, 0);
 					if (mp == NULL)
 						goto errout;
+
+					dp = (struct dmap *)mp->data;
+					if (dbValidateDmap(
+						    dp,
+						    blkno & ~(s64)(BPERDMAP -
+								   1))) {
+						jfs_error(
+							ipbmap->i_sb,
+							"error in block map\n");
+						release_metapage(mp);
+						goto errout;
+					}
+
 					n = min(nblocks, (s64)BPERDMAP - n);
 				} else {
 					/* assign/init dmap page */
-					mp = read_metapage(ipbmap, p,
-							   PSIZE, 0);
+					mp = read_metapage(ipbmap, p, PSIZE, 0);
 					if (mp == NULL)
 						goto errout;
 
+					dp = (struct dmap *)mp->data;
 					n = min_t(s64, nblocks, BPERDMAP);
 				}
 
-				dp = (struct dmap *) mp->data;
 				*l0leaf = dbInitDmap(dp, blkno, n);
 
 				bmp->db_nfree += n;
diff --git a/fs/jfs/jfs_dtree.c b/fs/jfs/jfs_dtree.c
index 8ce6e4458..d89bda9ee 100644
--- a/fs/jfs/jfs_dtree.c
+++ b/fs/jfs/jfs_dtree.c
@@ -3773,7 +3773,6 @@ static void dtInsertEntry(dtpage_t * p, int index, struct component_name * key,
 	++p->header.nextindex;
 }
 
-
 /*
  *	dtMoveEntry()
  *
diff --git a/fs/jfs/jfs_xtree.c b/fs/jfs/jfs_xtree.c
index 28c3cf960..859439d57 100644
--- a/fs/jfs/jfs_xtree.c
+++ b/fs/jfs/jfs_xtree.c
@@ -1730,10 +1730,10 @@ int xtUpdate(tid_t tid, struct inode *ip, xad_t * nxad)
 		if (IS_ERR(p))
 			return PTR_ERR(p);
 		/*
-		 * if leaf root has been split, original root has been
-		 * copied to new child page, i.e., original entry now
-		 * resides on the new child page;
-		 */
+			 * if leaf root has been split, original root has been
+			 * copied to new child page, i.e., original entry now
+			 * resides on the new child page;
+			 */
 		if (p->header.flag & BT_INTERNAL) {
 			ASSERT(p->header.nextindex ==
 			       cpu_to_le16(XTENTRYSTART + 1));
@@ -2310,8 +2310,8 @@ s64 xtTruncate(tid_t tid, struct inode *ip, s64 newsize, int flag)
 		goto getChild;
 
 	/*
-	 *	leaf page
-	 */
+		 *	leaf page
+		 */
 	freed = 0;
 
 	/* does region covered by leaf page precede Teof ? */
@@ -2605,8 +2605,8 @@ s64 xtTruncate(tid_t tid, struct inode *ip, s64 newsize, int flag)
 	}
 
 	/*
-	 * parent page become empty: free the page
-	 */
+		 * parent page become empty: free the page
+		 */
 	if (index == XTENTRYSTART) {
 		if (log) {	/* COMMIT_PWMAP */
 			/* txCommit() with tlckFREE:


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
