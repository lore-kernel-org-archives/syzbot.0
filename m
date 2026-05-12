Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AD7D23C3C00
	for <syzbot@lists.linux.dev>; Tue, 12 May 2026 09:19:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778577568; cv=none; b=DE4crcdZVgavQI0pttsdkRTgpM43gABGO1FJo4uW0V/lgLhJA8njCSruButoPHLWx8+irJ/O9TPXuBAZZk5czIKejdI/mD8hsXiH+SBIwJpOWv8wpn2lHluG9D4OIreBr4YiIm2jy3q8UHrwImTQIPWXmZLZsHkH1USvCS86uCw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778577568; c=relaxed/simple;
	bh=Sot99xhnvCcFTU+svpxaq8/Jk0zrJjrYPPi4kvz7is4=;
	h=From:To:Cc:Subject:Message-ID:MIME-Version:Content-Type:Date; b=mwTQp8RP9BweEXwfv7l5wV5UzrnqcSFTIn3Iya7fdybTmmjpNhzpjPqIq0iMafzlFmrBl81nRA9IotvDG2A1d+wVTPua2O8bwaym9Ckbch7yqKRFdFyJxNArpPaOuaCXDG/zxGn14uvNNaq9wJVBW96PlOS6/NGQysd6msST9QE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=S6eUGvVr; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="S6eUGvVr"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D5991C2BCB0;
	Tue, 12 May 2026 09:19:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1778577568;
	bh=Sot99xhnvCcFTU+svpxaq8/Jk0zrJjrYPPi4kvz7is4=;
	h=From:To:Cc:Subject:Date:From;
	b=S6eUGvVrxYYnAwA1epZU5uAMJi9TW3/psjEDDebc31dmdG121/j7M5Xza+TY+eVKM
	 34Gj5lBfcJB25m1Jz40I6jncK0rzDKyxe/dUMgKoy2dAsgIgOKRuMYr49RgCG9yWrG
	 hl2uCikm9q7Ker4brN7+wFM6vJCpP9+lfoJNISTAlJvUcB3N9c0ShhrSVsw46MHCvY
	 w3NQVChoG/X3yXlUKGHdxe0SbFPZNTFyOi8wqHNR9+IfxsopJ17XDtyDvgXcsoE4jA
	 PtoesDXpbe5bRCtb4W8COUKaP1DfXTDfJ/3tikkcHILbEGFigdDEop7SEvaZSjMxeS
	 F/VerZwrY9/kw==
From: "syzbot" <syzbot@kernel.org>
To: syzkaller-upstream-moderation@googlegroups.com
Cc: syzbot@lists.linux.dev
Subject: [PATCH RFC v2] hfs/hfsplus: fix lockdep false positive for extents_lock
Message-ID: <c672c95e-82f0-4c76-9ba0-09e5133639cc@mail.kernel.org>
Precedence: bulk
X-Mailing-List: syzbot@lists.linux.dev
List-Id: <syzbot.lists.linux.dev>
List-Subscribe: <mailto:syzbot+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:syzbot+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Date: Tue, 12 May 2026 09:19:27 +0000 (UTC)

hfs/hfsplus: fix lockdep false positive for extents_lock

syzkaller reported a possible recursive locking deadlock on
&HFSPLUS_I(inode)->extents_lock. This is a lockdep false positive.

In HFS and HFS+, extents_lock is used to protect the extent allocation
information of an inode. The problem arises because the lock is
initialized uniformly for all inodes, including both regular files and
special internal system files (like the Allocation file, Extents file,
Catalog file, etc.). Because of this, lockdep assigns the exact same
lock class to the extents_lock of all inodes.

When a regular file is truncated or extended, its extents_lock is
acquired. During this process, the filesystem might need to allocate or
free blocks, which requires reading or updating the Allocation file (or
other system files). This triggers a read on the Allocation file's
mapping, which in turn acquires the Allocation file's extents_lock.
Lockdep sees the same lock class being acquired twice in a nested
fashion and flags it as a recursive locking deadlock.

The exact same issue also exists in the older HFS filesystem (fs/hfs/),
where operations on a regular file can trigger updates to the Extents
or Catalog B-trees, leading to a similar nested acquisition of
extents_lock.

To fix this false positive, assign distinct lock classes to the
extents_lock of special system files using lockdep_set_class().
For HFS+, add lock class keys for the Extents, Catalog, Allocation,
Attributes, and Startup files, and apply them in hfsplus_iget().
For HFS, add lock class keys for the Extents and Catalog B-tree files,
and apply them in hfs_btree_open().

Fixes: 895c23f8c39c0c8d7b536bb2566d4aa968d78be2 ("hfsplus: convert the extents_lock in a mutex")
Assisted-by: Gemini:gemini-3.1-pro-preview Gemini:gemini-3-flash-preview
Reported-by: syzbot+b7ef7c0c8d8098686ae2@syzkaller.appspotmail.com
Link: https://syzkaller.appspot.com/bug?extid=b7ef7c0c8d8098686ae2
Link: https://syzkaller.appspot.com/ai_job?id=8c05b019-0a6c-4a92-8e06-c7a648023928
To: <frank.li@vivo.com>
To: <glaubitz@physik.fu-berlin.de>
To: <linux-fsdevel@vger.kernel.org>
To: <slava@dubeyko.com>
Cc: <linux-kernel@vger.kernel.org>

---
v2:
- Removed duplicate lines (includes, lock class key declarations, and switch statements).

v1:
https://lore.kernel.org/all/0bbb511f-6f0a-48b1-b3a4-e55eb907a1b4@mail.kernel.org/T/
---
diff --git a/fs/hfs/btree.c b/fs/hfs/btree.c
index 2eb37a2f6..9182ca939 100644
--- a/fs/hfs/btree.c
+++ b/fs/hfs/btree.c
@@ -12,9 +12,13 @@
 #include <linux/pagemap.h>
 #include <linux/slab.h>
 #include <linux/log2.h>
+#include <linux/lockdep.h>
 
 #include "btree.h"
 
+static struct lock_class_key hfs_ext_extents_key;
+static struct lock_class_key hfs_cat_extents_key;
+
 /* Get a reference to a B*Tree and do some initial checks */
 struct hfs_btree *hfs_btree_open(struct super_block *sb, u32 id, btree_keycmp keycmp)
 {
@@ -49,6 +53,8 @@ struct hfs_btree *hfs_btree_open(struct super_block *sb, u32 id, btree_keycmp ke
 	mutex_init(&HFS_I(tree->inode)->extents_lock);
 	switch (id) {
 	case HFS_EXT_CNID:
+		lockdep_set_class(&HFS_I(tree->inode)->extents_lock,
+				  &hfs_ext_extents_key);
 		hfs_inode_read_fork(tree->inode, mdb->drXTExtRec, mdb->drXTFlSize,
 				    mdb->drXTFlSize, be32_to_cpu(mdb->drXTClpSiz));
 		if (HFS_I(tree->inode)->alloc_blocks >
@@ -61,6 +67,8 @@ struct hfs_btree *hfs_btree_open(struct super_block *sb, u32 id, btree_keycmp ke
 		tree->inode->i_mapping->a_ops = &hfs_btree_aops;
 		break;
 	case HFS_CAT_CNID:
+		lockdep_set_class(&HFS_I(tree->inode)->extents_lock,
+				  &hfs_cat_extents_key);
 		hfs_inode_read_fork(tree->inode, mdb->drCTExtRec, mdb->drCTFlSize,
 				    mdb->drCTFlSize, be32_to_cpu(mdb->drCTClpSiz));
 
diff --git a/fs/hfsplus/super.c b/fs/hfsplus/super.c
index 40a0feda7..17147d5f5 100644
--- a/fs/hfsplus/super.c
+++ b/fs/hfsplus/super.c
@@ -18,6 +18,7 @@
 #include <linux/slab.h>
 #include <linux/vfs.h>
 #include <linux/nls.h>
+#include <linux/lockdep.h>
 
 static struct inode *hfsplus_alloc_inode(struct super_block *sb);
 static void hfsplus_free_inode(struct inode *inode);
@@ -25,6 +26,12 @@ static void hfsplus_free_inode(struct inode *inode);
 #include "hfsplus_fs.h"
 #include "xattr.h"
 
+static struct lock_class_key hfsplus_ext_extents_key;
+static struct lock_class_key hfsplus_cat_extents_key;
+static struct lock_class_key hfsplus_alloc_extents_key;
+static struct lock_class_key hfsplus_attr_extents_key;
+static struct lock_class_key hfsplus_start_extents_key;
+
 static int hfsplus_system_read_inode(struct inode *inode)
 {
 	struct hfsplus_vh *vhdr = HFSPLUS_SB(inode->i_sb)->s_vhdr;
@@ -84,6 +91,29 @@ struct inode *hfsplus_iget(struct super_block *sb, unsigned long ino)
 	memset(HFSPLUS_I(inode)->cached_extents, 0, sizeof(hfsplus_extent_rec));
 	HFSPLUS_I(inode)->extent_state = 0;
 	mutex_init(&HFSPLUS_I(inode)->extents_lock);
+	/* Set lockdep classes for system files to avoid false positives */
+	switch (ino) {
+	case HFSPLUS_EXT_CNID:
+		lockdep_set_class(&HFSPLUS_I(inode)->extents_lock,
+				  &hfsplus_ext_extents_key);
+		break;
+	case HFSPLUS_CAT_CNID:
+		lockdep_set_class(&HFSPLUS_I(inode)->extents_lock,
+				  &hfsplus_cat_extents_key);
+		break;
+	case HFSPLUS_ALLOC_CNID:
+		lockdep_set_class(&HFSPLUS_I(inode)->extents_lock,
+				  &hfsplus_alloc_extents_key);
+		break;
+	case HFSPLUS_ATTR_CNID:
+		lockdep_set_class(&HFSPLUS_I(inode)->extents_lock,
+				  &hfsplus_attr_extents_key);
+		break;
+	case HFSPLUS_START_CNID:
+		lockdep_set_class(&HFSPLUS_I(inode)->extents_lock,
+				  &hfsplus_start_extents_key);
+		break;
+	}
 	HFSPLUS_I(inode)->rsrc_inode = NULL;
 	HFSPLUS_I(inode)->create_date = 0;
 	HFSPLUS_I(inode)->linkid = 0;


base-commit: 7fd2df204f342fc17d1a0bfcd474b24232fb0f32
-- 
This is an AI-generated patch subject to moderation.
Reply with '#syz upstream' to send it to the mailing list.
Reply with '#syz reject' to reject it.

See  for more information.
