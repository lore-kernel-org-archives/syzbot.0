Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AEFB32FF641;
	Wed, 30 Sep 2026 10:25:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790763911; cv=none; b=pzlD6/t6CmR5/EYEQ/QNhx1JPRCX8JaFO0/89ovbUCDEnpoTW/Od6bihMGu2KllayVU0jM5MMs3+pZajMiwb/5BKsK4fV62bSzt7aeQJmRBJHiokGUkcx52FLYBuQ3lx0lggQJli87yxL2MT9CbX2iMRYcWrYaP7NgXgIQ+bEtw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790763911; c=relaxed/simple;
	bh=+boDduFSuvEjo4XKTynqe8K77shm/qn0Gn+aUrjOfWc=;
	h=From:To:Cc:Subject:Message-ID:MIME-Version:Content-Type:Date; b=Q4BIOTdqIxkhbmrhwzJwi2eRobgUizCMuhssH29g9DpiQwTJTFhBcWfV0PMzQkyskuR+JPMUbmA7pXMRZn+MyYyfoTmYOlZbBYQQExAlUe+S3hnI8g6gQyj9hb/lkhkBj6x7/JONxn3jAIdeyLI53HGjb5rAX2q6jcCV36nDvVA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=jpMSOPm4; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="jpMSOPm4"
Received: by smtp.kernel.org (Postfix) with UTF8SMTPSA id BD6321F000FF;
	Wed, 30 Sep 2026 10:25:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1790763909;
	bh=4TiuIDlrZdsvIUWkkkMxnBqP0w8dRUDI9uLg70d6m/Y=;
	h=From:To:Cc:Subject:Date;
	b=jpMSOPm4QWeYrVo22cbLTzVJ6DczjrMJx/AS1helZOhxvncfzmscVkhPr+tPJDtQH
	 TcUq9YNSaxP2iOytcK3nrpNW05r/DoS6f4iaC9ESvZ2hcX0HvGwobt6S5oi6hwHNfN
	 Dav3wX9tu77+tToJSpdH3iIArKgOSSv64q8SvY2TwZi5KxteRzRaOiUU2gapnxyT3l
	 5+TWqlkV0VA/z93hlwCOiVGBOSDZaQuGHwmSZ7btznwfnau94vxhV9VkcdCHy9Yfxg
	 fCV6ko4M5RqnQg5MNhO3g4AYrUVfhDr/kXsE4c+jXyJ0sn583tl0sWoDWS1MW/akMh
	 YhHrFYwJSu43A==
From: "syzbot" <syzbot@kernel.org>
To: syzkaller-bugs@googlegroups.com, Bartosz Chronowski <immersa.bartosz.chronowski@gmail.com>, <jfs-discussion@lists.sourceforge.net>, "Dave Kleikamp" <shaggy@kernel.org>
Cc: kees@kernel.org, linux-kernel@vger.kernel.org, syzbot@lists.linux.dev, yun.zhou@windriver.com
Subject: [PATCH] jfs: validate dmap start before block allocation
Message-ID: <b63dd8ae-464b-40d7-bbb8-031cfdc90909@mail.kernel.org>
Precedence: bulk
X-Mailing-List: syzbot@lists.linux.dev
List-Id: <syzbot.lists.linux.dev>
List-Subscribe: <mailto:syzbot+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:syzbot+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Date: Wed, 30 Sep 2026 10:25:08 +0000 (UTC)

From: Bartosz Chronowski <immersa.bartosz.chronowski@gmail.com>

A corrupted JFS filesystem image can cause a state where the block
allocation map (bmap) and the dmap pages are out of sync. Specifically,
dbAllocNear() and dbAllocDmapLev() derive the returned block number from
on-disk dp->start, which can cause duplicate allocation if dp->start does
not match the selected dmap boundary. In this scenario, the allocator
returns a block number that is already in use (e.g., as an inode table
block or metadata) while marking a completely different block as allocated.
When a thread later attempts to lock this duplicate block (for example,
during a directory btree split), txLock() detects a metapage conflict
because the block is already locked for another purpose, triggering a
kernel BUG:

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

Validation of dp->start against the expected dmap boundary in dbAlloc() and
the single-dmap path of dbAllocCtl() prevents inconsistent allocation.
Rejecting a mismatched start with -EIO prevents duplicate allocations
before txLock() is reached. Additionally, preserve the existing independent
geometry check (dp->tree.budmin < 0) in dbAllocCtl(). Both a mismatched
start and a negative budmin will now fail with -EIO early, preventing
corrupted dmap structures from causing duplicate allocations and subsequent
transaction lock crashes.

Assisted-by: Gemini:gemini-3.8-flash syzbot
Reported-by: syzbot+a843f6ae2130a987d63b@syzkaller.appspotmail.com
Closes: https://syzkaller.appspot.com/bug?extid=a843f6ae2130a987d63b
Link: https://syzkaller.appspot.com/ai_job?id=922ceb61-4be2-4af9-b2fe-9977a2549134
Signed-off-by: Bartosz Chronowski <immersa.bartosz.chronowski@gmail.com>

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
See https://goo.gle/syzbot-ai-patches for information about AI-generated patches.
The person who has signed off on the patch is responsible for
addressing comments.
syzbot engineers can be reached at syzkaller@googlegroups.com.
