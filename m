Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1BCE136C5AC
	for <syzbot@lists.linux.dev>; Tue, 30 Jun 2026 15:23:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782833023; cv=none; b=c5CVbVTMQUw/E3lan2CsoACoWiES1LiEL9F7nhLN/+BxcbYOCvIVIrbzo4iKg1OIKmYIMxDtaGBEm7NqgQiyq1Oe9TBrFg07Z7LQjS35/1v1YbDKyR7W6PR/txZibX/3XZK7D47q+2sFElJTAy5tLKItA4iV1waXm+qNUqyOJd4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782833023; c=relaxed/simple;
	bh=s+titgz+eR+WGkYsSvBgdZfUTJM4PZ2n76HDWapUuDo=;
	h=From:To:Cc:Subject:Message-ID:MIME-Version:Content-Type:Date; b=G7aMFSTudxbUaEO+ciHXCtSMDJPicngVLyIFOjg6QESo+uk/KVHIo+mvBxSoRttkbVcKHSPRKd/9EH+1QmTO2yILwFYUbGhvnQob8xRtLmQJAZSyruI+Iy+0inWD/0YRta2Yjla9bhIxlYafyusEreDfgmIzPJSuApoaxwpRrFk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=ekhRC6kY; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="ekhRC6kY"
Received: by smtp.kernel.org (Postfix) with UTF8SMTPSA id 965F61F000E9;
	Tue, 30 Jun 2026 15:23:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1782833021;
	bh=2CblseCqYHn40l/Kb84tHsi8MwWPw0IyMX6J3fPvc5E=;
	h=From:To:Cc:Subject:Date;
	b=ekhRC6kYezIaYaVM4ov0jU10YqUsLNt9s+sOylCY279EVetxT7qNmAeZJfAwjc1pE
	 pe29zrGHarG6OhoOOgEnNJ6EVZ7xZXJnpvlYJkSHpQhI9fLarugIe+QhCTGdnXFZsY
	 jkmeakDH+s4XpmJBruULkoHWcfJrj9c4EexC0nP9NRge0Js84msID5JOS5Q72OrbXd
	 s1qk26S3ruRpfYXa87/P2OeirAobnS7pZm51ft6rKntI4jave2Xi8rvRRwqIg0QoyZ
	 1d+6dz2tE/aRZuQTESY5ovVFYlZWVDtWOqiC8KspB18FsG/1XChGrJOjoGkzzRA8D8
	 0EpOUFNLrxGVA==
From: "syzbot" <syzbot@kernel.org>
To: syzkaller-upstream-moderation@googlegroups.com
Cc: syzbot@lists.linux.dev
Subject: [PATCH RFC] jfs: add dmaptree integrity check to prevent array-index-out-of-bounds
Message-ID: <2cfad14e-3856-4dd8-b464-6b0c1e15b9fb@mail.kernel.org>
Precedence: bulk
X-Mailing-List: syzbot@lists.linux.dev
List-Id: <syzbot.lists.linux.dev>
List-Subscribe: <mailto:syzbot+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:syzbot+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Date: Tue, 30 Jun 2026 15:23:41 +0000 (UTC)

An array-index-out-of-bounds issue occurs in dbJoin() when the JFS
filesystem attempts to free blocks using a corrupted dmap structure read
from disk.

The JFS filesystem uses a binary buddy system to manage free space. The
state of the buddy system is stored in dmap (for leaf levels) and dmapctl
(for upper levels) structures on disk. When a dmap is read from disk, its
dmaptree structure is not fully validated. Specifically, the leafidx field
(which indicates the index of the first leaf in the stree array) is read
directly from disk and used to compute pointers to the leaf nodes.

If leafidx is corrupted (e.g., set to 0xffffffff), the computed pointer
will point out of bounds of the stree array. When dbFreeDmap() is called to
free blocks, it calls dbFreeBits(), which in turn calls dbJoin() to update
the buddy system. dbJoin() uses the corrupted leafidx to access the leaf
nodes, resulting in an out-of-bounds memory access.

While a similar integrity check (check_dmapctl()) was recently added for
dmapctl structures, the dmap structures (dmaptree) were left unchecked.

Introduce a check_dmaptree() function, similar to the existing
check_dmapctl() function, to validate the integrity of the dmaptree
structure when it is used. The function verifies that fields like nleafs,
l2nleafs, leafidx, height, and budmin are within their expected bounds and
internally consistent. It also ensures that the leaf nodes fit within the
stree array and have valid values.

Call check_dmaptree() at the entry points of functions that operate on the
dmap structure (dbFreeDmap(), dbAllocNext(), dbAllocNear(),
dbAllocDmapLev(), dbAllocDmapBU(), and dbAllocDmap()). If the validation
fails, log an error and return -EIO to prevent further processing of the
corrupted dmap. This also replaces the existing partial checks for leafidx
in dbAllocNext() and dbAllocNear().

UBSAN: array-index-out-of-bounds in fs/jfs/jfs_dmap.c:2867:24
index 4294967295 is out of range for type 's8[1365]' (aka 'signed
char[1365]')
CPU: 0 UID: 0 PID: 123 Comm: jfsCommit Not tainted
Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS
1.16.3-debian-1.16.3-2 04/01/2014
Call Trace:
 <TASK>
 dump_stack_lvl+0xe8/0x150
 ubsan_epilogue+0xa/0x30
 __ubsan_handle_out_of_bounds+0xe8/0xf0
 dbJoin+0xcc4/0xd60
 dbFreeBits+0x4a2/0xd70
 dbFreeDmap
 dbFree+0x324/0x650
 txFreeMap+0x9e6/0xde0
 xtTruncate+0xd16/0x2eb0
 jfs_free_zero_link+0x35b/0x4c0
 jfs_evict_inode+0x356/0x430
 evict+0x624/0xb50
 txLazyCommit
 jfs_lazycommit+0x44c/0xac0
 kthread+0x388/0x470
 ret_from_fork+0x514/0xb70
 ret_from_fork_asm+0x1a/0x30
 </TASK>

Fixes: 1da177e4c3f4 ("Linux-2.6.12-rc2")
Assisted-by: Gemini:gemini-3.1-pro-preview best-expensive syzbot
Reported-by: syzbot+667a6d667592227b1452@syzkaller.appspotmail.com
Closes: https://syzkaller.appspot.com/bug?extid=667a6d667592227b1452
Link: https://syzkaller.appspot.com/ai_job?id=e23ddb38-d666-490d-86a7-4d67edb1eac1
To: <jfs-discussion@lists.sourceforge.net>
To: "Dave Kleikamp" <shaggy@kernel.org>
Cc: "Arnaud Lecomte" <contact@arnaud-lcm.com>
Cc: "Kees Cook" <kees@kernel.org>
Cc: <linux-kernel@vger.kernel.org>
Cc: "Yun Zhou" <yun.zhou@windriver.com>
Cc: "Zheng Yu" <zheng.yu@northwestern.edu>

---
diff --git a/fs/jfs/jfs_dmap.c b/fs/jfs/jfs_dmap.c
index a841cf21d..4f2e0b78d 100644
--- a/fs/jfs/jfs_dmap.c
+++ b/fs/jfs/jfs_dmap.c
@@ -220,6 +220,85 @@ static bool check_dmapctl(struct dmapctl *dcp)
 	return true;
 }
 
+/*
+ * check_dmaptree - Validate integrity of a dmaptree structure
+ * @dtp: Pointer to the dmaptree structure to check
+ *
+ * Return: true if valid, false if corrupted
+ */
+static bool check_dmaptree(struct dmaptree *dtp)
+{
+	u32 nleafs, l2nleafs, leafidx, height;
+	int i;
+
+	nleafs = le32_to_cpu(dtp->nleafs);
+	/* Check basic field ranges */
+	if (unlikely(nleafs > LPERDMAP)) {
+		jfs_err("dmaptree: invalid nleafs %u (max %u)", nleafs,
+			LPERDMAP);
+		return false;
+	}
+
+	l2nleafs = le32_to_cpu(dtp->l2nleafs);
+	if (unlikely(l2nleafs > L2LPERDMAP)) {
+		jfs_err("dmaptree: invalid l2nleafs %u (max %u)", l2nleafs,
+			L2LPERDMAP);
+		return false;
+	}
+
+	/* Verify nleafs matches l2nleafs (must be power of two) */
+	if (unlikely((1U << l2nleafs) != nleafs)) {
+		jfs_err("dmaptree: nleafs %u != 2^%u", nleafs, l2nleafs);
+		return false;
+	}
+
+	leafidx = le32_to_cpu(dtp->leafidx);
+	/* Check leaf index matches expected position */
+	if (unlikely(leafidx != LEAFIND)) {
+		jfs_err("dmaptree: invalid leafidx %u (expected %u)", leafidx,
+			LEAFIND);
+		return false;
+	}
+
+	height = le32_to_cpu(dtp->height);
+	/* Check tree height is within valid range */
+	if (unlikely(height > 4)) {
+		jfs_err("dmaptree: invalid height %u (max 4)", height);
+		return false;
+	}
+
+	/* Check budmin is valid */
+	if (unlikely(dtp->budmin < BUDMIN)) {
+		jfs_err("dmaptree: invalid budmin %d (min %d)", dtp->budmin,
+			BUDMIN);
+		return false;
+	}
+
+	/* Check leaf nodes fit within stree array */
+	if (unlikely(leafidx + nleafs > TREESIZE)) {
+		jfs_err("dmaptree: leaf range exceeds stree size (end %u > %u)",
+			leafidx + nleafs, TREESIZE);
+		return false;
+	}
+
+	/* Check leaf nodes have valid values */
+	for (i = leafidx; i < leafidx + nleafs; i++) {
+		s8 val = dtp->stree[i];
+
+		if (unlikely(val < NOFREE)) {
+			jfs_err("dmaptree: invalid leaf value %d at index %d",
+				val, i);
+			return false;
+		} else if (unlikely(val > 31)) {
+			jfs_err("dmaptree: leaf value %d too large at index %d",
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
@@ -1163,7 +1242,7 @@ static int dbAllocNext(struct bmap * bmp, struct dmap * dp, s64 blkno,
 	s8 *leaf;
 	u32 mask;
 
-	if (dp->tree.leafidx != cpu_to_le32(LEAFIND)) {
+	if (unlikely(!check_dmaptree(&dp->tree))) {
 		jfs_error(bmp->db_ipbmap->i_sb, "Corrupt dmap page\n");
 		return -EIO;
 	}
@@ -1293,7 +1372,7 @@ dbAllocNear(struct bmap * bmp,
 	int word, lword, rc;
 	s8 *leaf;
 
-	if (dp->tree.leafidx != cpu_to_le32(LEAFIND)) {
+	if (unlikely(!check_dmaptree(&dp->tree))) {
 		jfs_error(bmp->db_ipbmap->i_sb, "Corrupt dmap page\n");
 		return -EIO;
 	}
@@ -2046,6 +2125,11 @@ dbAllocDmapLev(struct bmap * bmp,
 	s64 blkno;
 	int leafidx, rc;
 
+	if (unlikely(!check_dmaptree(&dp->tree))) {
+		jfs_error(bmp->db_ipbmap->i_sb, "Corrupt dmap page\n");
+		return -EIO;
+	}
+
 	/* can't be more than a dmaps worth of blocks */
 	assert(l2nb <= L2BPERDMAP);
 
@@ -2112,6 +2196,11 @@ static int dbAllocDmap(struct bmap * bmp, struct dmap * dp, s64 blkno,
 	s8 oldroot;
 	int rc;
 
+	if (unlikely(!check_dmaptree(&dp->tree))) {
+		jfs_error(bmp->db_ipbmap->i_sb, "Corrupt dmap page\n");
+		return -EIO;
+	}
+
 	/* save the current value of the root (i.e. maximum free string)
 	 * of the dmap tree.
 	 */
@@ -2167,6 +2256,11 @@ static int dbFreeDmap(struct bmap * bmp, struct dmap * dp, s64 blkno,
 	s8 oldroot;
 	int rc = 0, word;
 
+	if (unlikely(!check_dmaptree(&dp->tree))) {
+		jfs_error(bmp->db_ipbmap->i_sb, "Corrupt dmap page\n");
+		return -EIO;
+	}
+
 	/* save the current value of the root (i.e. maximum free string)
 	 * of the dmap tree.
 	 */
@@ -3338,6 +3432,11 @@ static int dbAllocDmapBU(struct bmap * bmp, struct dmap * dp, s64 blkno,
 	s8 oldroot;
 	struct dmaptree *tp = (struct dmaptree *) & dp->tree;
 
+	if (unlikely(!check_dmaptree(&dp->tree))) {
+		jfs_error(bmp->db_ipbmap->i_sb, "Corrupt dmap page\n");
+		return -EIO;
+	}
+
 	/* save the current value of the root (i.e. maximum free string)
 	 * of the dmap tree.
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
