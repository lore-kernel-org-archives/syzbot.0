Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E478037B41B
	for <syzbot@lists.linux.dev>; Fri, 29 May 2026 17:17:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780075058; cv=none; b=Oe0m2ivKioX6yd7htUQsXkeHdgL6BFRtGEOnVk8E69S5MS/tnY51gWYWpUp4LUzkwRt3e5MuaxMm32Lpty+K41Uvp2ibJUMFn510Rg24kpF0jRLsMGDU8hTIClvFN3NzfCF+KvMXSxGT2T159LiO3jssneGDvFR9oauAlcvgW9Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780075058; c=relaxed/simple;
	bh=110SsqslFVCJfs9qVVF9PbJitNHa5Lf1z50N9PkC6cU=;
	h=From:To:Cc:Subject:Message-ID:MIME-Version:Content-Type:Date; b=KZ0m8Sm/5Ry089P3EW9pCLgXkV5+sudaDqw8/PJBIoQSFjUlKJzYyrxaS6oDlxbeu0w/whdoudPcxFeuKgwfiRMlDKYoBn/UDY+qszVf40JheIUZI9udPOER2Wh66eJ9dX06A5gMCoNHXU0ZS9CLmLRTJs4PSI3e0UurFxzOMyY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=AsloWxzu; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="AsloWxzu"
Received: by smtp.kernel.org (Postfix) with UTF8SMTPSA id 71EB81F00893;
	Fri, 29 May 2026 17:17:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1780075056;
	bh=fyb0seLdOD5vZYwI6wEkrfBDO13PrIQ0YEbDck4HgX0=;
	h=From:To:Cc:Subject:Date;
	b=AsloWxzue/8fQ8S1z/41Mrh47NW6xoZQAjtctAFfRNpljHOG3D9o8O8vBlEvpCPDz
	 XjzBG3uo9U6HMlAqNGpats6dcRUh51c+eYcxY0UVshg36SCv6mMf1aliXWaJmqzCPU
	 Hzzl+7GT+q9BBgsHHu9MFJunXT3O43eJfusPP7kZQ3eiNKbNqvc2VSlyQ1PY1KBnqm
	 xXZbQ3daLnYYuMA9l4f0VBYgJjb26RwXqICSjodCJi6L50mtBUNIl2Gxmzb9xM/gD5
	 4Bm22pxAxeYP2m+tjwsXLVhRzq/FWut8rJw0EuK9IHcCxyVEKNqYMCfaq+6O8gX5MU
	 tPPisyEWezWWg==
From: "syzbot" <syzbot@kernel.org>
To: syzkaller-upstream-moderation@googlegroups.com
Cc: syzbot@lists.linux.dev
Subject: [PATCH RFC] jfs: fix null-ptr-deref and use-after-free during rw remount
Message-ID: <80218035-7c1f-4784-93d1-c34d9ccc252a@mail.kernel.org>
Precedence: bulk
X-Mailing-List: syzbot@lists.linux.dev
List-Id: <syzbot.lists.linux.dev>
List-Subscribe: <mailto:syzbot+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:syzbot+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Date: Fri, 29 May 2026 17:17:36 +0000 (UTC)

During a read-write remount of a JFS filesystem, jfs_mount_rw() destroys
the old in-memory inode and block maps (imap and bmap) before attempting to
read the new ones from disk. If dbMount() fails, the filesystem is left
with a NULL sbi->bmap. Any subsequent operation that triggers a lookup will
call diRead(), which dereferences sbi->bmap to access db_agl2size,
resulting in a NULL pointer dereference.

To fix this, jfs_mount_rw() is modified to allocate and mount the new maps
before freeing the old ones. If the new mount fails, the old maps are
restored.

Additionally, concurrent read operations like diRead() and jfs_statfs()
could access the old or new structures while they are being replaced,
leading to a use-after-free. To prevent this, the IREAD_LOCK in diRead() is
extended to protect the structures throughout their usage, and an
IREAD_LOCK is added to jfs_statfs() to protect its lockless accesses.
Furthermore, jfs_mount_rw() now holds the IWRITE_LOCK across the entire
remount process to ensure mutual exclusion with concurrent readers.

Fixes: a60dca73a1a8 ("jfs: makes diUnmount/diMount in jfs_mount_rw atomic")
Assisted-by: Gemini:gemini-3.1-pro-preview Gemini:gemini-3-flash-preview syzbot
Reported-by: syzbot+8f731999dc47797f064f@syzkaller.appspotmail.com
Closes: https://syzkaller.appspot.com/bug?extid=8f731999dc47797f064f
Link: https://syzkaller.appspot.com/ai_job?id=4a947787-2a28-4919-858f-c3b11d2d0dbc
To: <jfs-discussion@lists.sourceforge.net>
To: "Dave Kleikamp" <shaggy@kernel.org>
Cc: "Christian Brauner" <brauner@kernel.org>
Cc: "Chuck Lever" <chuck.lever@oracle.com>
Cc: "Jan Kara" <jack@suse.cz>
Cc: "Jeff Layton" <jlayton@kernel.org>
Cc: =?utf-8?q?Jo=C3=A3o_Paredes?= <joaommp@yahoo.com>
Cc: "Kees Cook" <kees@kernel.org>
Cc: "Liao Yuanhong" <liaoyuanhong@vivo.com>
Cc: <linux-kernel@vger.kernel.org>
Cc: "Al Viro" <viro@zeniv.linux.org.uk>
Cc: "Yun Zhou" <yun.zhou@windriver.com>

---
diff --git a/fs/jfs/jfs_imap.c b/fs/jfs/jfs_imap.c
index b84ba4d7d..b0997e43f 100644
--- a/fs/jfs/jfs_imap.c
+++ b/fs/jfs/jfs_imap.c
@@ -314,8 +314,8 @@ int diRead(struct inode *ip)
 	IREAD_LOCK(ipimap, RDWRLOCK_IMAP);
 	imap = JFS_IP(ipimap)->i_imap;
 	rc = diIAGRead(imap, iagno, &mp);
-	IREAD_UNLOCK(ipimap);
 	if (rc) {
+		IREAD_UNLOCK(ipimap);
 		jfs_err("diRead: diIAGRead returned %d", rc);
 		return (rc);
 	}
@@ -329,6 +329,7 @@ int diRead(struct inode *ip)
 	if ((lengthPXD(&iagp->inoext[extno]) != imap->im_nbperiext) ||
 	    (addressPXD(&iagp->inoext[extno]) == 0)) {
 		release_metapage(mp);
+		IREAD_UNLOCK(ipimap);
 		return -ESTALE;
 	}
 
@@ -341,6 +342,7 @@ int diRead(struct inode *ip)
 	agstart = le64_to_cpu(iagp->agstart);
 	agno = BLKTOAG(agstart, JFS_SBI(ip->i_sb));
 
+	IREAD_UNLOCK(ipimap);
 	release_metapage(mp);
 	if (agno >= MAXAG || agno < 0)
 		return -EIO;
diff --git a/fs/jfs/jfs_mount.c b/fs/jfs/jfs_mount.c
index dac822f15..6229f50c0 100644
--- a/fs/jfs/jfs_mount.c
+++ b/fs/jfs/jfs_mount.c
@@ -229,26 +229,37 @@ int jfs_mount_rw(struct super_block *sb, int remount)
 	 * them.
 	 */
 	if (remount) {
+		struct bmap *old_bmap;
+		struct inomap *old_imap;
+
 		if (chkSuper(sb) || (sbi->state != FM_CLEAN))
 			return -EINVAL;
 
+		old_bmap = sbi->bmap;
+		old_imap = JFS_IP(sbi->ipimap)->i_imap;
+
 		truncate_inode_pages(sbi->ipimap->i_mapping, 0);
 		truncate_inode_pages(sbi->ipbmap->i_mapping, 0);
 
 		IWRITE_LOCK(sbi->ipimap, RDWRLOCK_IMAP);
-		diUnmount(sbi->ipimap, 1);
 		if ((rc = diMount(sbi->ipimap))) {
 			IWRITE_UNLOCK(sbi->ipimap);
 			jfs_err("jfs_mount_rw: diMount failed!");
 			return rc;
 		}
-		IWRITE_UNLOCK(sbi->ipimap);
 
-		dbUnmount(sbi->ipbmap, 1);
 		if ((rc = dbMount(sbi->ipbmap))) {
 			jfs_err("jfs_mount_rw: dbMount failed!");
+			/* restore old imap */
+			kfree(JFS_IP(sbi->ipimap)->i_imap);
+			JFS_IP(sbi->ipimap)->i_imap = old_imap;
+			IWRITE_UNLOCK(sbi->ipimap);
 			return rc;
 		}
+		IWRITE_UNLOCK(sbi->ipimap);
+
+		kfree(old_bmap);
+		kfree(old_imap);
 	}
 
 	/*
diff --git a/fs/jfs/super.c b/fs/jfs/super.c
index 61575f739..c65f68555 100644
--- a/fs/jfs/super.c
+++ b/fs/jfs/super.c
@@ -120,9 +120,13 @@ static int jfs_statfs(struct dentry *dentry, struct kstatfs *buf)
 {
 	struct jfs_sb_info *sbi = JFS_SBI(dentry->d_sb);
 	s64 maxinodes;
-	struct inomap *imap = JFS_IP(sbi->ipimap)->i_imap;
+	struct inomap *imap;
 
 	jfs_info("In jfs_statfs");
+
+	IREAD_LOCK(sbi->ipimap, RDWRLOCK_IMAP);
+	imap = JFS_IP(sbi->ipimap)->i_imap;
+
 	buf->f_type = JFS_SUPER_MAGIC;
 	buf->f_bsize = sbi->bsize;
 	buf->f_blocks = sbi->bmap->db_mapsize;
@@ -150,6 +154,7 @@ static int jfs_statfs(struct dentry *dentry, struct kstatfs *buf)
 				      sizeof(sbi->uuid)/2);
 
 	buf->f_namelen = JFS_NAME_MAX;
+	IREAD_UNLOCK(sbi->ipimap);
 	return 0;
 }
 


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
