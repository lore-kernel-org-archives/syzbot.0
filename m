Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2DA22449987
	for <syzbot@lists.linux.dev>; Wed, 29 Jul 2026 17:15:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785345333; cv=none; b=TB31gfGp2IC1xuoUddNUBLWvF1o3HvR4pLNOQoouJwjmS9sT2SH5HJJLJEZZM81PVVS6cKDBUaCn5fzL2bZtJTR4oCYaHEf6QosHA5mgyrp4LjDXrE36ypaWBumY4agNWhygwwq1KlGN6wgwbThreSIOFYcPh7SdD/PiheMgfD8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785345333; c=relaxed/simple;
	bh=SuSAsJgoDFm3cWg72fnPsr884M+iSopO8kQr9v001cI=;
	h=From:To:Cc:Subject:Message-ID:MIME-Version:Content-Type:Date; b=fDkrvjeYfrbzghSTEk/wCJUqL4Y9bvjJdW2tt1YhLtjE9Rcy7ELLtIe+kL7h5JPBniMIhU8/LibtxxB1c7kryFvoXsiT9Fd4WF1UTUJkMAS88qA2AwQQjKdfsqd9EN02BULz9yD1IY+/+9ISK+22t94MYhbE2jhvh7dG1yJ1W9M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=U8Io4Pxv; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="U8Io4Pxv"
Received: by smtp.kernel.org (Postfix) with UTF8SMTPSA id 7DC5F1F00A3D;
	Wed, 29 Jul 2026 17:15:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1785345327;
	bh=XElm0d3g5igFeBrBzjqPZD3QO1CVP1DuOtapZGuw2ds=;
	h=From:To:Cc:Subject:Date;
	b=U8Io4Pxvmet55CVRYzMRZhvWMgeHtKznV71OG4+2vPv/cn46FFj/z5YY1Ko64CHyO
	 csTOn/TmK1hsE9GggJhN1b/6t3G8F/v8a5I8FQkeMHzsI11kQwGPs00QVJ+jtxkh4K
	 nSHUnsNrPMDMYh3bx84EUVGFUZGEHCdtrrzs1Z30gaGP81DwKDVD9iq2YWzkJJB/af
	 74Qpl82lOAQ7vD4k2qxU75GxW/5Xveu62mUVv0lQUh1hIOIr5LEzXHquljRQ6gmfjk
	 5qaBF7Qjo7Do92yyXb2D8YT9nOPah8jQFGVPaURZIRMk9eT9ozYdOgszORGZO80HtX
	 JL8b1w1I65oWg==
From: "syzbot" <syzbot@kernel.org>
To: syzkaller-upstream-moderation@googlegroups.com
Cc: immersa.bartosz.chronowski@gmail.com, syzbot@lists.linux.dev
Subject: [PATCH RFC v5] jfs: validate dmap start before block allocation
Message-ID: <6673d9d2-210e-4870-b355-7826289ab842@mail.kernel.org>
Precedence: bulk
X-Mailing-List: syzbot@lists.linux.dev
List-Id: <syzbot.lists.linux.dev>
List-Subscribe: <mailto:syzbot+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:syzbot+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Date: Wed, 29 Jul 2026 17:15:27 +0000 (UTC)

A corrupted JFS filesystem image can cause a state where the block
allocation map (bmap) and the dmap pages are out of sync. Specifically, if
a dmap page's `dp->start` is corrupted, it can lead to a mismatch during
block allocation. The block allocator calculates the returned block number
based on `dp->start` (i.e., `dp->start + block_index`), while the bitmap
update is derived from the block's relative position within the dmap. If
`dp->start` does not match the expected start block number for that dmap's
position in the bmap, the allocator may return a block number that is
already in use (e.g., as an inode table block or metadata), while marking a
completely different block as allocated. This mismatch leads to duplicate
allocations. When a thread later attempts to lock this duplicate block (for
example, during a directory btree split), `txLock()` detects a metapage
conflict because the block is already locked for another purpose,
triggering a kernel BUG:

kernel BUG at fs/jfs/jfs_txnmgr.c:836!
Oops: invalid opcode: 0000 [#1] SMP KASAN NOPTI
RIP: 0010:txLock+0x1cc3/0x1d10 fs/jfs/jfs_txnmgr.c:836
Call Trace:
 <TASK>
 dtSplitRoot+0x38d/0x18a0 fs/jfs/jfs_dtree.c:1924
 dtSplitUp fs/jfs/jfs_dtree.c:990 [inline]
 dtInsert+0xeb2/0x5890 fs/jfs/jfs_dtree.c:868
 jfs_create+0x730/0xae0 fs/jfs/namei.c:138
...

To fix this, validate that the `dp->start` of the dmap page matches the
expected start block number during block allocation operations (`dbAlloc`
and `dbAllocCtl`). Rejecting a mismatched start with `-EIO` prevents
duplicate allocations before `txLock()` is reached. Additionally, preserve
the existing independent geometry check (`dp->tree.budmin < 0`) in
`dbAllocCtl()`. Both a mismatched start and a negative `budmin` will now
fail with `-EIO` early, preventing corrupted dmap structures from causing
duplicate allocations and subsequent transaction lock crashes.

Fixes: 1da177e4c3f4 ("Linux-2.6.12-rc2")
Assisted-by: Gemini:gemini-3.5-flash Gemini:gemini-3.1-pro-preview syzbot
Reported-by: syzbot+a843f6ae2130a987d63b@syzkaller.appspotmail.com
Closes: https://syzkaller.appspot.com/bug?extid=a843f6ae2130a987d63b
Link: https://syzkaller.appspot.com/ai_job?id=601b1802-e8c6-4427-af36-c1b279764dc7
To: <jfs-discussion@lists.sourceforge.net>
To: "Dave Kleikamp" <shaggy@kernel.org>
To: "Linus Torvalds" <torvalds@ppc970.osdl.org>
Cc: "Kees Cook" <kees@kernel.org>
Cc: <linux-kernel@vger.kernel.org>
Cc: "Yun Zhou" <yun.zhou@windriver.com>

---
v5:
- Narrowed the validation of `dp->start` to only the primary block allocation paths (`dbAlloc` and `dbAllocCtl`).
- Removed validation checks from `dbFree`, `dbUpdatePMap`, `dbExtend`, `dbAllocBottomUp`, and secondary loops in `dbAllocCtl`.

v4:
- Renamed dbValidateDmap to db_validate_dmap to follow kernel naming conventions.
- Preserved the existing dp->tree.budmin < 0 check in dbAllocCtl instead of replacing it.
https://lore.kernel.org/all/d1405703-afc9-40f9-bc57-ddedf66f35da@mail.kernel.org/T/

v3:
- Renamed the patch to "jfs: validate dmap start before block map operations".
- Simplified dbValidateDmap() to only validate that the dmap dp->start matches the expected start block number, removing unproven integrity checks.
- Updated the commit description to explain the exact root cause of the selection/update mismatch and how validating dp->start prevents duplicate allocations before txLock() is reached.
https://lore.kernel.org/all/7c3c4fb4-ccbd-486f-b087-6074364ee206@mail.kernel.org/T/

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
index a841cf21d..9bdbc55d8 100644
--- a/fs/jfs/jfs_dmap.c
+++ b/fs/jfs/jfs_dmap.c
@@ -98,6 +98,9 @@ static int blkstol2(s64 nb);
 static int cntlz(u32 value);
 static int cnttz(u32 word);
 
+static bool db_validate_dmap(struct super_block *sb, const struct dmap *dp,
+			     s64 expected_start);
+
 static int dbAllocDmapBU(struct bmap * bmp, struct dmap * dp, s64 blkno,
 			 int nblocks);
 static int dbInitDmap(struct dmap * dp, s64 blkno, int nblocks);
@@ -886,6 +889,12 @@ int dbAlloc(struct inode *ip, s64 hint, s64 nblocks, s64 * results)
 
 		dp = (struct dmap *) mp->data;
 
+		if (!db_validate_dmap(ip->i_sb, dp,
+				      blkno & ~(s64)(BPERDMAP - 1))) {
+			release_metapage(mp);
+			goto read_unlock;
+		}
+
 		/* first, try to satisfy the allocation request with the
 		 * blocks beginning at the hint.
 		 */
@@ -1902,7 +1911,9 @@ dbAllocCtl(struct bmap * bmp, s64 nblocks, int l2nb, s64 blkno, s64 * results)
 			return -EIO;
 		dp = (struct dmap *) mp->data;
 
-		if (dp->tree.budmin < 0) {
+		if (dp->tree.budmin < 0 ||
+		    !db_validate_dmap(bmp->db_ipbmap->i_sb, dp,
+				      blkno & ~(s64)(BPERDMAP - 1))) {
 			release_metapage(mp);
 			return -EIO;
 		}
@@ -2134,6 +2145,18 @@ static int dbAllocDmap(struct bmap * bmp, struct dmap * dp, s64 blkno,
 	return (rc);
 }
 
+static bool db_validate_dmap(struct super_block *sb, const struct dmap *dp,
+			     s64 expected_start)
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
