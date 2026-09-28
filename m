Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5F7D84E73D1
	for <syzbot@lists.linux.dev>; Mon, 28 Sep 2026 17:42:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790617349; cv=none; b=qB070am2y0IL3QIuF33SxCZvuInzalE1DWk25pkaBtN+HwtfSxJGLc0D5IhcKIE4OeVX22p2MYKQP2BF5LSUbAVPnEqY3AmfO51cYTEwYrpJXgNo2gid3I3FeSir2lFOiNSY18lpeHcR2/mJy/XKeEq+Gth0PM9bTNRGixchlV0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790617349; c=relaxed/simple;
	bh=RgN7ivrA++IwphY9aJdql7YpsNtUtDyd3ezbw+8do3Y=;
	h=From:To:Cc:Subject:Message-ID:MIME-Version:Content-Type:Date; b=eH2gPKWe15Ml1SEin7P6WcbosHtyIoeLiFJ4umrBHvp7sZwjon9/+7pXyNe8rAyeAsFAUihsF/Gmgv+mVucFoaaozisCD6FuS1mQxsy8l5/mpfJH/Rb6UKprOGjQKiBYYOFM1QqO59jcMR3TS9H7ByYPl4BlaK61zdnu5NY48Qo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Hz/IYQLb; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Hz/IYQLb"
Received: by smtp.kernel.org (Postfix) with UTF8SMTPSA id EAC0C1F00893;
	Mon, 28 Sep 2026 17:42:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1790617348;
	bh=8VdrqFIA3Pn2lf6rvZF7uIWVi3WLILswVSl9/CZPR7w=;
	h=From:To:Cc:Subject:Date;
	b=Hz/IYQLbOksGkwVaCmEU/bv5wvuhm3alCty4GsPXOILSYNg44W7SS0PmOBNFwEuGZ
	 w6RFveXwBGfIvrdNxj5trgMSLhpzdPSZ2dsvH3aE2s8EL/HoY+HX61thf+10vk6ZSG
	 FRRW4P4aqusJfO2kS9S+76qWDSctvEjHUqXovfJNV5uXLs/G0t4hqCaqRVUptmErc7
	 sWcVbx5pjR0Dwgs8bGMaoluQnOodUc+PIcdSAd+azGFk9qOtF0em+YELfGGfe3xVlX
	 U7b8MEJjzL3GxmZ4ETXDV846tprPYG6mokm0ZdBxYl41/c8jifO6tYCrw+pzkcI1YW
	 01y5wXoz+gbnA==
From: "syzbot" <syzbot@kernel.org>
To: syzkaller-upstream-moderation@googlegroups.com
Cc: krystianmkaniewski@gmail.com, syzbot@lists.linux.dev
Subject: [PATCH RFC v6] fat: validate dotdot buffers in VFAT and MSDOS rename and rollback
Message-ID: <a8ced042-8354-448a-8e75-80741265e1f6@mail.kernel.org>
Precedence: bulk
X-Mailing-List: syzbot@lists.linux.dev
List-Id: <syzbot.lists.linux.dev>
List-Subscribe: <mailto:syzbot+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:syzbot+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Date: Mon, 28 Sep 2026 17:42:27 +0000 (UTC)

During cross-directory rename operations with synchronous directory updates
enabled in VFAT and MSDOS, updating the ".." directory entry writes the
buffer via sync_dirty_buffer(). If this write fails due to an I/O error,
the block layer clears the BH_Uptodate flag. When rename enters its error
rollback path, it attempts to update the ".." directory entry again with
the same buffer head, which calls mmb_mark_buffer_dirty() and triggers a
"!buffer_uptodate(bh)" warning in mark_buffer_dirty().

Fix this by introducing fat_update_dotdot_de() and
fat_sync_update_dotdot_de() in fs/fat/dir.c, used by both VFAT and MSDOS
cross-directory rename and rollback paths. The helpers lock the buffer head
and check buffer_uptodate() before modifying the entry. If the buffer is
not uptodate, unlock it and return -EIO, preventing mmb_mark_buffer_dirty()
from being called on a non-uptodate buffer. fat_sync_update_dotdot_de()
preserves the unconditional buffer sync in the MSDOS rename rollback path.

Fixes: 1da177e4c3f4 ("Linux-2.6.12-rc2")
Assisted-by: Gemini:gemini-3.8-flash syzbot
Reported-by: syzbot+b0aebd03565f5774f7f8@syzkaller.appspotmail.com
Closes: https://syzkaller.appspot.com/bug?extid=b0aebd03565f5774f7f8
Link: https://syzkaller.appspot.com/ai_job?id=165ac73a-2f8a-43fb-a36d-4e2cac5e15d5
To: "OGAWA Hirofumi" <hirofumi@mail.parknet.co.jp>
To: <linux-kernel@vger.kernel.org>
To: "Linus Torvalds" <torvalds@ppc970.osdl.org>

---
v6:
- Corrected recipient list: send to OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>, CC linux-kernel@vger.kernel.org and linux-fsdevel@vger.kernel.org, and remove Linus Torvalds <torvalds@ppc970.osdl.org>.

v5:
- Removed Linus Torvalds from the recipient list
https://lore.kernel.org/all/4372e7d7-6a96-414a-9247-48d869db66da@mail.kernel.org/T/

v4:
- Introduce fat_sync_update_dotdot_de() to preserve unconditional buffer sync during MSDOS rename rollback.
- Remove Linus Torvalds from the recipient list.
https://lore.kernel.org/all/62b57eac-c2c6-4d5b-b5b6-c797b847c805@mail.kernel.org/T/

v3:
- Move vfat_update_dotdot_de() to a shared fat_update_dotdot_de() helper in fs/fat/dir.c
- Use fat_update_dotdot_de() in MSDOS cross-directory rename and rollback paths
- Update commit subject and description to reflect both VFAT and MSDOS coverage
https://lore.kernel.org/all/7ea246ae-9417-4507-920d-4afb771c59ac@mail.kernel.org/T/

v2:
- Lock the buffer head and return -EIO if it is not uptodate instead of calling set_buffer_uptodate().
- Update the patch subject to reflect buffer validation.
- Shorten the commit description and remove the stack trace.
https://lore.kernel.org/all/56341edb-4dc2-4683-9776-641253569bb3@mail.kernel.org/T/

v1:
https://lore.kernel.org/all/012d4ac1-83f3-48af-8781-00fbbc4adc93@mail.kernel.org/T/
---
diff --git a/fs/fat/dir.c b/fs/fat/dir.c
index 35bdb6294..cee06e635 100644
--- a/fs/fat/dir.c
+++ b/fs/fat/dir.c
@@ -941,6 +941,40 @@ int fat_get_dotdot_entry(struct inode *dir, struct buffer_head **bh,
 }
 EXPORT_SYMBOL_GPL(fat_get_dotdot_entry);
 
+static int __fat_update_dotdot_de(struct inode *dir, struct inode *inode,
+				  struct buffer_head *dotdot_bh,
+				  struct msdos_dir_entry *dotdot_de,
+				  bool force_sync)
+{
+	lock_buffer(dotdot_bh);
+	if (!buffer_uptodate(dotdot_bh)) {
+		unlock_buffer(dotdot_bh);
+		return -EIO;
+	}
+	fat_set_start(dotdot_de, MSDOS_I(dir)->i_logstart);
+	mmb_mark_buffer_dirty(dotdot_bh, &MSDOS_I(inode)->i_metadata_bhs);
+	unlock_buffer(dotdot_bh);
+	if (force_sync || IS_DIRSYNC(dir))
+		return sync_dirty_buffer(dotdot_bh);
+	return 0;
+}
+
+int fat_update_dotdot_de(struct inode *dir, struct inode *inode,
+			 struct buffer_head *dotdot_bh,
+			 struct msdos_dir_entry *dotdot_de)
+{
+	return __fat_update_dotdot_de(dir, inode, dotdot_bh, dotdot_de, false);
+}
+EXPORT_SYMBOL_GPL(fat_update_dotdot_de);
+
+int fat_sync_update_dotdot_de(struct inode *dir, struct inode *inode,
+			      struct buffer_head *dotdot_bh,
+			      struct msdos_dir_entry *dotdot_de)
+{
+	return __fat_update_dotdot_de(dir, inode, dotdot_bh, dotdot_de, true);
+}
+EXPORT_SYMBOL_GPL(fat_sync_update_dotdot_de);
+
 /* See if directory is empty */
 int fat_dir_empty(struct inode *dir)
 {
diff --git a/fs/fat/fat.h b/fs/fat/fat.h
index 61338413d..d51d3c11e 100644
--- a/fs/fat/fat.h
+++ b/fs/fat/fat.h
@@ -339,6 +339,12 @@ extern int fat_scan_logstart(struct inode *dir, int i_logstart,
 			     struct fat_slot_info *sinfo);
 extern int fat_get_dotdot_entry(struct inode *dir, struct buffer_head **bh,
 				struct msdos_dir_entry **de);
+extern int fat_update_dotdot_de(struct inode *dir, struct inode *inode,
+				struct buffer_head *dotdot_bh,
+				struct msdos_dir_entry *dotdot_de);
+extern int fat_sync_update_dotdot_de(struct inode *dir, struct inode *inode,
+				     struct buffer_head *dotdot_bh,
+				     struct msdos_dir_entry *dotdot_de);
 extern int fat_alloc_new_dir(struct inode *dir, struct timespec64 *ts);
 extern int fat_add_entries(struct inode *dir, void *slots, int nr_slots,
 			   struct fat_slot_info *sinfo);
diff --git a/fs/fat/namei_msdos.c b/fs/fat/namei_msdos.c
index d46d1a385..31faaeae8 100644
--- a/fs/fat/namei_msdos.c
+++ b/fs/fat/namei_msdos.c
@@ -527,14 +527,10 @@ static int do_msdos_rename(struct inode *old_dir, unsigned char *old_name,
 	}
 
 	if (update_dotdot) {
-		fat_set_start(dotdot_de, MSDOS_I(new_dir)->i_logstart);
-		mmb_mark_buffer_dirty(dotdot_bh,
-				      &MSDOS_I(old_inode)->i_metadata_bhs);
-		if (IS_DIRSYNC(new_dir)) {
-			err = sync_dirty_buffer(dotdot_bh);
-			if (err)
-				goto error_dotdot;
-		}
+		err = fat_update_dotdot_de(new_dir, old_inode, dotdot_bh,
+					   dotdot_de);
+		if (err)
+			goto error_dotdot;
 		drop_nlink(old_dir);
 		if (!new_inode)
 			inc_nlink(new_dir);
@@ -565,12 +561,9 @@ static int do_msdos_rename(struct inode *old_dir, unsigned char *old_name,
 	/* data cluster is shared, serious corruption */
 	corrupt = 1;
 
-	if (update_dotdot) {
-		fat_set_start(dotdot_de, MSDOS_I(old_dir)->i_logstart);
-		mmb_mark_buffer_dirty(dotdot_bh,
-				      &MSDOS_I(old_inode)->i_metadata_bhs);
-		corrupt |= sync_dirty_buffer(dotdot_bh);
-	}
+	if (update_dotdot)
+		corrupt |= fat_sync_update_dotdot_de(old_dir, old_inode,
+						     dotdot_bh, dotdot_de);
 error_inode:
 	fat_detach(old_inode);
 	fat_attach(old_inode, old_sinfo.i_pos);
diff --git a/fs/fat/namei_vfat.c b/fs/fat/namei_vfat.c
index da3e89c0b..56da78455 100644
--- a/fs/fat/namei_vfat.c
+++ b/fs/fat/namei_vfat.c
@@ -909,16 +909,6 @@ static int vfat_sync_ipos(struct inode *dir, struct inode *inode)
 	return 0;
 }
 
-static int vfat_update_dotdot_de(struct inode *dir, struct inode *inode,
-				 struct buffer_head *dotdot_bh,
-				 struct msdos_dir_entry *dotdot_de)
-{
-	fat_set_start(dotdot_de, MSDOS_I(dir)->i_logstart);
-	mmb_mark_buffer_dirty(dotdot_bh, &MSDOS_I(inode)->i_metadata_bhs);
-	if (IS_DIRSYNC(dir))
-		return sync_dirty_buffer(dotdot_bh);
-	return 0;
-}
 
 static void vfat_update_dir_metadata(struct inode *dir, struct timespec64 *ts)
 {
@@ -981,8 +971,8 @@ static int vfat_rename(struct inode *old_dir, struct dentry *old_dentry,
 		goto error_inode;
 
 	if (dotdot_de) {
-		err = vfat_update_dotdot_de(new_dir, old_inode, dotdot_bh,
-					    dotdot_de);
+		err = fat_update_dotdot_de(new_dir, old_inode, dotdot_bh,
+					   dotdot_de);
 		if (err)
 			goto error_dotdot;
 		drop_nlink(old_dir);
@@ -1014,8 +1004,8 @@ static int vfat_rename(struct inode *old_dir, struct dentry *old_dentry,
 	corrupt = 1;
 
 	if (dotdot_de) {
-		corrupt |= vfat_update_dotdot_de(old_dir, old_inode, dotdot_bh,
-						 dotdot_de);
+		corrupt |= fat_update_dotdot_de(old_dir, old_inode, dotdot_bh,
+						dotdot_de);
 	}
 error_inode:
 	fat_detach(old_inode);
@@ -1103,14 +1093,14 @@ static int vfat_rename_exchange(struct inode *old_dir, struct dentry *old_dentry
 
 	/* update ".." directory entry info */
 	if (old_dotdot_de) {
-		err = vfat_update_dotdot_de(new_dir, old_inode, old_dotdot_bh,
-					    old_dotdot_de);
+		err = fat_update_dotdot_de(new_dir, old_inode, old_dotdot_bh,
+					   old_dotdot_de);
 		if (err)
 			goto error_old_dotdot;
 	}
 	if (new_dotdot_de) {
-		err = vfat_update_dotdot_de(old_dir, new_inode, new_dotdot_bh,
-					    new_dotdot_de);
+		err = fat_update_dotdot_de(old_dir, new_inode, new_dotdot_bh,
+					   new_dotdot_de);
 		if (err)
 			goto error_new_dotdot;
 	}
@@ -1137,14 +1127,14 @@ static int vfat_rename_exchange(struct inode *old_dir, struct dentry *old_dentry
 
 error_new_dotdot:
 	if (new_dotdot_de) {
-		corrupt |= vfat_update_dotdot_de(new_dir, new_inode,
-						 new_dotdot_bh, new_dotdot_de);
+		corrupt |= fat_update_dotdot_de(new_dir, new_inode,
+						new_dotdot_bh, new_dotdot_de);
 	}
 
 error_old_dotdot:
 	if (old_dotdot_de) {
-		corrupt |= vfat_update_dotdot_de(old_dir, old_inode,
-						 old_dotdot_bh, old_dotdot_de);
+		corrupt |= fat_update_dotdot_de(old_dir, old_inode,
+						old_dotdot_bh, old_dotdot_de);
 	}
 
 error_exchange:


base-commit: 93f51579e7df248780214094418f205253383cc5
-- 
This is an AI-generated patch subject to moderation.
Reply with '#syz upstream' to Sign-off the patch as a human author
and send it to the upstream kernel mailing lists.
Reply with '#syz reject' to reject it ('#syz unreject' to undo).

See https://goo.gle/syzbot-ai-patches for information about AI-generated patches.
You can comment on the patch as usual, syzbot will try to address
the comments and send a new version of the patch if necessary.
syzbot engineers can be reached at syzkaller@googlegroups.com.
