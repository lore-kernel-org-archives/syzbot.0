Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B060D3A961A
	for <syzbot@lists.linux.dev>; Fri, 29 May 2026 14:33:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780065188; cv=none; b=QKNyGrcKe7h+gtuWafm9HmMD5FwWTuzGYOf1LeBhzOSegey/UsWh93+JIL3xKJyvanlTkXc8g6Z8yOlLodpUKeuRLPANpl1CJeKF+uVobkq5hpHRR8vbltlnZBG8E+FkpVKLmXbSyuy+fG0Hx3mFndtBIzkAJrqABztXymgGVvM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780065188; c=relaxed/simple;
	bh=VhEKhpYute6mZsQrjQoz1y9qtdNyMxzoamg2ZsUaaGU=;
	h=From:To:Cc:Subject:Message-ID:MIME-Version:Content-Type:Date; b=X9iK4JUIxgS2iekOUtNDfmDpRRza1z8rQVwgfk2wDbeUPQBgEVfQ/Cqw6pGPTvIhJJtHm60vlqbxtkcppuP8w8uhzqWmzNAJ26gcXZRhzLR7Rb7VLhHTbNTrLIa/myXisFCYOPe8BdttUPJx3I1hxPlJpqe8KWs2muxjU65DDfw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=AjMHUGCm; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="AjMHUGCm"
Received: by smtp.kernel.org (Postfix) with UTF8SMTPSA id 468E21F00893;
	Fri, 29 May 2026 14:33:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1780065186;
	bh=0ydLwschTydT+Z9zEt0l/6gL8DKTDDIoiKSseTpbZTc=;
	h=From:To:Cc:Subject:Date;
	b=AjMHUGCmEtJoIrhHXDMEiCplsATEaoq0kvsdSnH4xkM1ks70YiCeknOJbEAWPCwuE
	 do53wQGVH0kj0USiG+BQRopOUGxWEhzjj6S2YVx1PR6iOTF1pn/cD9dQ4tgmyifoR+
	 1VwzZUPXJHxCK/d4DHHi6jEvpjLKx6y6C/IKCGciEfVUdZGkoPwU7vCH1CTTHyL1EX
	 PtgqyM7gugVJPfn9YtCJSLrhOtDRtmeM40nmXKoVNT5Y7f42b+HZqxxtTpXXBLA/Uz
	 WTUAUj/HoC0dyTrSnUxMvPmQZz10HqVKm5yoHtUp4BR04I32YC6NKYwIktnWhslvZg
	 yJLtJmBh1xugw==
From: "syzbot" <syzbot@kernel.org>
To: syzkaller-upstream-moderation@googlegroups.com
Cc: syzbot@lists.linux.dev
Subject: [PATCH RFC] jfs: add dmap integrity check to prevent shift-out-of-bounds
Message-ID: <852d12ec-ea2c-41ab-8c54-e162bc6e8a9b@mail.kernel.org>
Precedence: bulk
X-Mailing-List: syzbot@lists.linux.dev
List-Id: <syzbot.lists.linux.dev>
List-Subscribe: <mailto:syzbot+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:syzbot+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Date: Fri, 29 May 2026 14:33:06 +0000 (UTC)

A missing integrity check for on-disk dmap pages allows a corrupted dmap
tree to trick the allocator into performing an undefined 32-bit shift in
dbFindBits().

If a dmap page is corrupted such that dp->tree.leafidx is invalid (e.g., 0
instead of LEAFIND), dbFindLeaf() calculates an incorrect relative leaf
index. This leads to an out-of-bounds access in the stree array in
dbAllocDmapLev(). The incorrect value tricks the allocator into assuming
the word is partially allocated and calling dbFindBits() with l2nb = 5
(allocating 32 blocks). dbFindBits() fails to find 32 free bits, continues
the loop, and shifts a 32-bit mask by 32, triggering a UBSAN
shift-out-of-bounds crash.

Fix this by introducing a check_dmap() function to validate the integrity
of dmap pages, similar to the existing check_dmapctl() function. This
function ensures that fields like nleafs, l2nleafs, leafidx, height,
budmin, and the values in the stree array are within valid ranges. Update
all locations in fs/jfs/jfs_dmap.c where dmap pages are read from disk
using read_metapage() to call this new validation function, preventing
undefined behavior and crashes later in the allocation and deallocation
paths.

Fixes: 1da177e4c3f4 ("Linux-2.6.12-rc2")
Assisted-by: Gemini:gemini-3.1-pro-preview Gemini:gemini-3-flash-preview syzbot
Reported-by: syzbot+9e90a1c5eedb9dc4c6cc@syzkaller.appspotmail.com
Closes: https://syzkaller.appspot.com/bug?extid=9e90a1c5eedb9dc4c6cc
Link: https://syzkaller.appspot.com/ai_job?id=665e737f-2256-468b-a1a9-fd1d4b2ebf38
To: <jfs-discussion@lists.sourceforge.net>
To: "Dave Kleikamp" <shaggy@kernel.org>
Cc: "Arnaud Lecomte" <contact@arnaud-lcm.com>
Cc: "Kees Cook" <kees@kernel.org>
Cc: <linux-kernel@vger.kernel.org>
Cc: "Yun Zhou" <yun.zhou@windriver.com>
Cc: "Zheng Yu" <zheng.yu@northwestern.edu>

---
diff --git a/fs/jfs/jfs_dmap.c b/fs/jfs/jfs_dmap.c
index a841cf21d..e22735779 100644
--- a/fs/jfs/jfs_dmap.c
+++ b/fs/jfs/jfs_dmap.c
@@ -220,6 +220,73 @@ static bool check_dmapctl(struct dmapctl *dcp)
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
+	u32 nleafs, l2nleafs, leafidx, height;
+	int i;
+
+	nleafs = le32_to_cpu(dp->tree.nleafs);
+	if (unlikely(nleafs > LPERDMAP)) {
+		jfs_err("dmap: invalid nleafs %u (max %u)", nleafs, LPERDMAP);
+		return false;
+	}
+
+	l2nleafs = le32_to_cpu(dp->tree.l2nleafs);
+	if (unlikely(l2nleafs > L2LPERDMAP)) {
+		jfs_err("dmap: invalid l2nleafs %u (max %u)", l2nleafs,
+			L2LPERDMAP);
+		return false;
+	}
+
+	if (unlikely((1U << l2nleafs) != nleafs)) {
+		jfs_err("dmap: nleafs %u != 2^%u", nleafs, l2nleafs);
+		return false;
+	}
+
+	leafidx = le32_to_cpu(dp->tree.leafidx);
+	if (unlikely(leafidx != LEAFIND)) {
+		jfs_err("dmap: invalid leafidx %u (expected %u)", leafidx,
+			LEAFIND);
+		return false;
+	}
+
+	height = le32_to_cpu(dp->tree.height);
+	if (unlikely(height > (L2LPERDMAP >> 1))) {
+		jfs_err("dmap: invalid height %u (max %u)", height,
+			L2LPERDMAP >> 1);
+		return false;
+	}
+
+	if (unlikely(dp->tree.budmin != BUDMIN)) {
+		jfs_err("dmap: invalid budmin %d (expected %d)",
+			dp->tree.budmin, BUDMIN);
+		return false;
+	}
+
+	if (unlikely(leafidx + nleafs > TREESIZE)) {
+		jfs_err("dmap: leaf range exceeds stree size (end %u > %u)",
+			leafidx + nleafs, TREESIZE);
+		return false;
+	}
+
+	for (i = leafidx; i < leafidx + nleafs; i++) {
+		s8 val = dp->tree.stree[i];
+		if (unlikely(val < NOFREE || val > 31)) {
+			jfs_err("dmap: invalid leaf value %d at index %d", val,
+				i);
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
@@ -476,6 +543,13 @@ int dbFree(struct inode *ip, s64 blkno, s64 nblocks)
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
@@ -563,13 +637,18 @@ dbUpdatePMap(struct inode *ipbmap,
 				write_metapage(mp);
 			}
 
-			mp = read_metapage(bmp->db_ipbmap, lblkno, PSIZE,
-					   0);
+			mp = read_metapage(bmp->db_ipbmap, lblkno, PSIZE, 0);
 			if (mp == NULL)
 				return -EIO;
 			metapage_wait_for_io(mp);
 		}
-		dp = (struct dmap *) mp->data;
+		dp = (struct dmap *)mp->data;
+
+		if (unlikely(!check_dmap(dp))) {
+			jfs_error(ipbmap->i_sb, "Corrupt dmap page\n");
+			release_metapage(mp);
+			return -EIO;
+		}
 
 		/* determine the bit number and word within the dmap of
 		 * the starting block.  also determine how many blocks
@@ -886,6 +965,12 @@ int dbAlloc(struct inode *ip, s64 hint, s64 nblocks, s64 * results)
 
 		dp = (struct dmap *) mp->data;
 
+		if (unlikely(!check_dmap(dp))) {
+			jfs_error(ip->i_sb, "Corrupt dmap page\n");
+			release_metapage(mp);
+			goto read_unlock;
+		}
+
 		/* first, try to satisfy the allocation request with the
 		 * blocks beginning at the hint.
 		 */
@@ -1118,6 +1203,13 @@ static int dbExtend(struct inode *ip, s64 blkno, s64 nblocks, s64 addnblocks)
 
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
@@ -1902,7 +1994,8 @@ dbAllocCtl(struct bmap * bmp, s64 nblocks, int l2nb, s64 blkno, s64 * results)
 			return -EIO;
 		dp = (struct dmap *) mp->data;
 
-		if (dp->tree.budmin < 0) {
+		if (unlikely(!check_dmap(dp))) {
+			jfs_error(bmp->db_ipbmap->i_sb, "Corrupt dmap page\n");
 			release_metapage(mp);
 			return -EIO;
 		}
@@ -1936,6 +2029,13 @@ dbAllocCtl(struct bmap * bmp, s64 nblocks, int l2nb, s64 blkno, s64 * results)
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
@@ -1993,6 +2093,12 @@ dbAllocCtl(struct bmap * bmp, s64 nblocks, int l2nb, s64 blkno, s64 * results)
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
@@ -3308,6 +3414,13 @@ int dbAllocBottomUp(struct inode *ip, s64 blkno, s64 nblocks)
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
@@ -3638,27 +3751,38 @@ int dbExtendFS(struct inode *ipbmap, s64 blkno,	s64 nblocks)
 			 */
 			for (; i < LPERCTL; i++) {
 				/*
-				 * reconstruct the dmap page, and
-				 * initialize corresponding parent L0 leaf
-				 */
-				if ((n = blkno & (BPERDMAP - 1))) {
+					 * reconstruct the dmap page, and
+					 * initialize corresponding parent L0 leaf
+					 */
+				bool is_extending = (blkno & (BPERDMAP - 1)) !=
+						    0;
+
+				if (is_extending) {
 					/* read in dmap page: */
-					mp = read_metapage(ipbmap, p,
-							   PSIZE, 0);
+					mp = read_metapage(ipbmap, p, PSIZE, 0);
 					if (mp == NULL)
 						goto errout;
+					n = blkno & (BPERDMAP - 1);
 					n = min(nblocks, (s64)BPERDMAP - n);
 				} else {
 					/* assign/init dmap page */
-					mp = read_metapage(ipbmap, p,
-							   PSIZE, 0);
+					mp = read_metapage(ipbmap, p, PSIZE, 0);
 					if (mp == NULL)
 						goto errout;
 
 					n = min_t(s64, nblocks, BPERDMAP);
 				}
 
-				dp = (struct dmap *) mp->data;
+				dp = (struct dmap *)mp->data;
+
+				if (is_extending && unlikely(!check_dmap(dp))) {
+					jfs_error(ipbmap->i_sb,
+						  "Corrupt dmap page\n");
+					release_metapage(mp);
+					mp = NULL;
+					goto errout;
+				}
+
 				*l0leaf = dbInitDmap(dp, blkno, n);
 
 				bmp->db_nfree += n;
@@ -3674,7 +3798,7 @@ int dbExtendFS(struct inode *ipbmap, s64 blkno,	s64 nblocks)
 				nblocks -= n;
 				if (nblocks == 0)
 					break;
-			}	/* for each dmap in a L0 */
+			} /* for each dmap in a L0 */
 
 			/*
 			 * build current L0 page from its leaves, and


base-commit: e7ae89a0c97ce2b68b0983cd01eda67cf373517d
-- 
This is an AI-generated patch subject to moderation.
Reply with '#syz upstream' to Sign-off the patch as a human author
and send it to the upstream kernel mailing lists.
Reply with '#syz reject' to reject it ('#syz unreject' to undo).

See https://goo.gle/syzbot-ai-patches for information about AI-generated patches.
You can comment on the patch as usual, syzbot will try to address
the comments and send a new version of the patch if necessary.
syzbot engineers can be reached at syzkaller@googlegroups.com.
