Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 34CC639B964
	for <syzbot@lists.linux.dev>; Tue, 12 May 2026 22:34:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778625263; cv=none; b=DD1lYMVb/I8mjFOS5dOZFRLTcUrTzRFE4BQ2n7uVHWR+Js/4JzcYKem5zGu+DxrV3N2+mhhwymeTr1FEYvcO/fc2wJnZgHFQ2EX1xQXvaW/ZLgzVXB8KB9kJpFIlFOytC2kxNPossMkOwBDzW5p4svpO9uETa6Ir0PV4w9Hur60=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778625263; c=relaxed/simple;
	bh=u77K1qGPTLfRARU+xrR0DDscqJDrKXwSK0j70NGs9eI=;
	h=From:To:Cc:Subject:Message-ID:MIME-Version:Content-Type:Date; b=kZTVqRHtYpl4kcoYkzZEl6ZLW6TCuKdkhgNhaQ5SNyDGizgeqXj0KJbH2Wx88wf0JjWmb5c5iHenM26RBv3o2mOh6QUEgoM+kueYTMoK+4oQSEDEEevmUi1OyJhUNLDO9KJR5YGo4P3z1HwKMwRWn6jYPw8I9wKMwbqAlKYk1HU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=oWUMfiIZ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="oWUMfiIZ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B22ACC2BCB0;
	Tue, 12 May 2026 22:34:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1778625262;
	bh=u77K1qGPTLfRARU+xrR0DDscqJDrKXwSK0j70NGs9eI=;
	h=From:To:Cc:Subject:Date:From;
	b=oWUMfiIZFd3oiusERqq3jJlwMnyRdDe3ehgrqLtdHDlEmK3IxxoamfcCpgLqgE3gL
	 jpcEaPhn2Se1dK/RFadigEdyPTT0bP+IJIkjIFyax9ZW+Z5uWWnkcj+1IF3NCOOFcl
	 4YdIyEvXmvE4uDSDn/lyVDZKxhyGuEG7r/2G3+917UK+IMHKf0Ln5gWrU8zatAvEYm
	 Y4a3izfdWeaWVc5JBR1iE7lE/HCVn/52fUYCm/RU7KCKg0xg6Ia9n5/sduo8Y6Shxy
	 GkInxFoiPEyIrkSOV6lVI0q5qAEhlCgILHWM9Lnk8YT+UFKlXB9EJmP5MQHM7mUZ3f
	 GSzsUupjpC66w==
From: "syzbot" <syzbot@kernel.org>
To: syzkaller-upstream-moderation@googlegroups.com
Cc: syzbot@lists.linux.dev
Subject: [PATCH RFC v3] hfs/hfsplus: fix lockdep false positive for extents_lock
Message-ID: <3d5c2bce-281a-49bc-8269-6bd86f0b6817@mail.kernel.org>
Precedence: bulk
X-Mailing-List: syzbot@lists.linux.dev
List-Id: <syzbot.lists.linux.dev>
List-Subscribe: <mailto:syzbot+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:syzbot+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Date: Tue, 12 May 2026 22:34:22 +0000 (UTC)

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
where operations on a regular file can trigger updates to the Extents or
Catalog B-trees, leading to a similar nested acquisition of
extents_lock.

To fix this false positive, assign distinct lock classes to the
extents_lock of special system files using lockdep_set_class(). For
HFS+, add an array of lock class keys for system files, and apply them
in hfsplus_system_read_inode(). For HFS, add an array of lock class keys
for B-tree files, and apply them in hfs_btree_open().

Fixes: 895c23f8c39c0c8d7b536bb2566d4aa968d78be2 ("hfsplus: convert the extents_lock in a mutex")
Assisted-by: Gemini:gemini-3.1-pro-preview Gemini:gemini-3-flash-preview
Reported-by: syzbot+b7ef7c0c8d8098686ae2@syzkaller.appspotmail.com
Link: https://syzkaller.appspot.com/bug?extid=b7ef7c0c8d8098686ae2
Link: https://syzkaller.appspot.com/ai_job?id=05a9fad5-be33-46b2-888a-68617780e581
To: <frank.li@vivo.com>
To: <glaubitz@physik.fu-berlin.de>
To: <linux-fsdevel@vger.kernel.org>
To: <slava@dubeyko.com>
Cc: <linux-kernel@vger.kernel.org>

---
v3:
- Minimized the patch by using arrays of lock class keys indexed by inode ID instead of individual variables and switch statements.
- Moved the lockdep_set_class() call for HFS+ from hfsplus_iget() to hfsplus_system_read_inode().

v2:
- Removed duplicate lines (includes, lock class key declarations, and switch statements).
https://lore.kernel.org/all/c672c95e-82f0-4c76-9ba0-09e5133639cc@mail.kernel.org/T/

v1:
https://lore.kernel.org/all/0bbb511f-6f0a-48b1-b3a4-e55eb907a1b4@mail.kernel.org/T/
---
diff --git a/fs/hfs/btree.c b/fs/hfs/btree.c
index 2eb37a2f6..34d582a3e 100644
--- a/fs/hfs/btree.c
+++ b/fs/hfs/btree.c
@@ -12,9 +12,12 @@
 #include <linux/pagemap.h>
 #include <linux/slab.h>
 #include <linux/log2.h>
+#include <linux/lockdep.h>
 
 #include "btree.h"
 
+static struct lock_class_key hfs_btree_extents_key[HFS_FIRSTUSER_CNID];
+
 /* Get a reference to a B*Tree and do some initial checks */
 struct hfs_btree *hfs_btree_open(struct super_block *sb, u32 id, btree_keycmp keycmp)
 {
@@ -47,6 +50,8 @@ struct hfs_btree *hfs_btree_open(struct super_block *sb, u32 id, btree_keycmp ke
 	struct hfs_mdb *mdb = HFS_SB(sb)->mdb;
 	HFS_I(tree->inode)->flags = 0;
 	mutex_init(&HFS_I(tree->inode)->extents_lock);
+	lockdep_set_class(&HFS_I(tree->inode)->extents_lock,
+			  &hfs_btree_extents_key[id]);
 	switch (id) {
 	case HFS_EXT_CNID:
 		hfs_inode_read_fork(tree->inode, mdb->drXTExtRec, mdb->drXTFlSize,
diff --git a/fs/hfsplus/super.c b/fs/hfsplus/super.c
index 40a0feda7..7be84552a 100644
--- a/fs/hfsplus/super.c
+++ b/fs/hfsplus/super.c
@@ -18,6 +18,7 @@
 #include <linux/slab.h>
 #include <linux/vfs.h>
 #include <linux/nls.h>
+#include <linux/lockdep.h>
 
 static struct inode *hfsplus_alloc_inode(struct super_block *sb);
 static void hfsplus_free_inode(struct inode *inode);
@@ -25,10 +26,15 @@ static void hfsplus_free_inode(struct inode *inode);
 #include "hfsplus_fs.h"
 #include "xattr.h"
 
+static struct lock_class_key hfsplus_sys_extents_key[HFSPLUS_FIRSTUSER_CNID];
+
 static int hfsplus_system_read_inode(struct inode *inode)
 {
 	struct hfsplus_vh *vhdr = HFSPLUS_SB(inode->i_sb)->s_vhdr;
 
+	lockdep_set_class(&HFSPLUS_I(inode)->extents_lock,
+			  &hfsplus_sys_extents_key[inode->i_ino]);
+
 	switch (inode->i_ino) {
 	case HFSPLUS_EXT_CNID:
 		hfsplus_inode_read_fork(inode, &vhdr->ext_file);


base-commit: 7fd2df204f342fc17d1a0bfcd474b24232fb0f32
-- 
This is an AI-generated patch subject to moderation.
Reply with '#syz upstream' to send it to the mailing list.
Reply with '#syz reject' to reject it.

See  for more information.
