Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EEC273F076E
	for <syzbot@lists.linux.dev>; Thu, 24 Sep 2026 19:19:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790277597; cv=none; b=AY2REb0zLy6h6MZvcE46VaFRT4fM2bQ1W3K5bu1wuJSov9xqVI58mtKa3ez7LQSr01rR+wcn31Fusd/YWXFxMXiLANspYYeorLCGBtUH7t2VMTdJdW+9L3GRpJBrXgg5V3tOi9tE1LR4H91DibKJwZXYv+NcATLxcIEr9rk1bvo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790277597; c=relaxed/simple;
	bh=x7XunwwHVgum1ifat5Y7QSPAv0BpY1eF4FzF4qL+cgk=;
	h=From:To:Cc:Subject:Message-ID:MIME-Version:Content-Type:Date; b=IY189VfS/ww7BNwYkB5amTKEyDtMr7DUuu7mHUa4c57/zHS99NIzV87s16CO0ODapy/yXs1FWF4CTyBi9Rd/NmRn4SbmD71FlSBTw2ZtSjNXPCX/OviDf7HAV4PjeM8jyDQZYsdH0+F/uGAbps2uRUzKyg7+PyKE1vM9rv4rBsY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=kkHmEdJD; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="kkHmEdJD"
Received: by smtp.kernel.org (Postfix) with UTF8SMTPSA id 41BB71F000FF;
	Thu, 24 Sep 2026 19:19:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1790277595;
	bh=QCM+6txNCPLg/YiWQe4qVWwblxg/8wfu6v1YZNIqBkw=;
	h=From:To:Cc:Subject:Date;
	b=kkHmEdJD+ACoJwXarSWnMROOTONUoO4RgnmWLS86TvYkxYMRZHvdwPWs2ruS4oCiF
	 SreEJ5l52uFoDE+18XpnL7C8F5f1FHXOdAgda6wVhdcOIS1yzf3AArikuT21C+b58g
	 SPLvpWenScIBxjHQw88mURrNzsTCw6s1nTPpl8inwWmFlUQUJk+7XPSnhLm1gxFFTA
	 Agt73fbBaJ/c0WsReXxOlZeof1t29+5E49G7yfGISNaiXyUl5pmJ6EN9g4AmeAQKlM
	 sb9iPfIgear0e7GgA9LNv4jmxyFz/Wig3s9R95clZb/oWpO6+fSRrVCrJF/2Y9WnYk
	 YopoEcF9EDm6w==
From: "syzbot" <syzbot@kernel.org>
To: syzkaller-upstream-moderation@googlegroups.com
Cc: krystianmkaniewski@gmail.com, syzbot@lists.linux.dev
Subject: [PATCH RFC v3] fat: validate dotdot buffers in VFAT and MSDOS rename and rollback
Message-ID: <7ea246ae-9417-4507-920d-4afb771c59ac@mail.kernel.org>
Precedence: bulk
X-Mailing-List: syzbot@lists.linux.dev
List-Id: <syzbot.lists.linux.dev>
List-Subscribe: <mailto:syzbot+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:syzbot+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Date: Thu, 24 Sep 2026 19:19:55 +0000 (UTC)

During cross-directory rename operations with synchronous directory updates
enabled in VFAT and MSDOS, updating the ".." directory entry writes the
buffer via sync_dirty_buffer(). If this write fails due to an I/O error,
the block layer clears the BH_Uptodate flag. When rename enters its error
rollback path, it attempts to update the ".." directory entry again with
the same buffer head, which calls mmb_mark_buffer_dirty() and triggers a
"!buffer_uptodate(bh)" warning in mark_buffer_dirty().

Fix this by introducing a common helper fat_update_dotdot_de() in
fs/fat/dir.c, used by both VFAT and MSDOS cross-directory rename and
rollback paths. The helper locks the buffer head and checks
buffer_uptodate() before modifying the entry. If the buffer is not
uptodate, unlock it and return -EIO, preventing mmb_mark_buffer_dirty()
from being called on a non-uptodate buffer.

Fixes: 1da177e4c3f4 ("Linux-2.6.12-rc2")
Assisted-by: Gemini:gemini-3.8-flash syzbot
Reported-by: syzbot+b0aebd03565f5774f7f8@syzkaller.appspotmail.com
Closes: https://syzkaller.appspot.com/bug?extid=b0aebd03565f5774f7f8
Link: https://syzkaller.appspot.com/ai_job?id=a860bfca-0d0a-4ee1-ab62-38c1df430ba2
To: "OGAWA Hirofumi" <hirofumi@mail.parknet.co.jp>
To: <linux-kernel@vger.kernel.org>
To: "Linus Torvalds" <torvalds@ppc970.osdl.org>

---
v3:
- Move vfat_update_dotdot_de() to a shared fat_update_dotdot_de() helper in fs/fat/dir.c
- Use fat_update_dotdot_de() in MSDOS cross-directory rename and rollback paths
- Update commit subject and description to reflect both VFAT and MSDOS coverage

v2:
- Lock the buffer head and return -EIO if it is not uptodate instead of calling set_buffer_uptodate().
- Update the patch subject to reflect buffer validation.
- Shorten the commit description and remove the stack trace.
https://lore.kernel.org/all/56341edb-4dc2-4683-9776-641253569bb3@mail.kernel.org/T/

v1:
https://lore.kernel.org/all/012d4ac1-83f3-48af-8781-00fbbc4adc93@mail.kernel.org/T/
---
diff --git a/fs/fat/dir.c b/fs/fat/dir.c
index 35bdb6294..daddae43e 100644
--- a/fs/fat/dir.c
+++ b/fs/fat/dir.c
@@ -941,6 +941,24 @@ int fat_get_dotdot_entry(struct inode *dir, struct buffer_head **bh,
 }
 EXPORT_SYMBOL_GPL(fat_get_dotdot_entry);
 
+int fat_update_dotdot_de(struct inode *dir, struct inode *inode,
+			 struct buffer_head *dotdot_bh,
+			 struct msdos_dir_entry *dotdot_de)
+{
+	lock_buffer(dotdot_bh);
+	if (!buffer_uptodate(dotdot_bh)) {
+		unlock_buffer(dotdot_bh);
+		return -EIO;
+	}
+	fat_set_start(dotdot_de, MSDOS_I(dir)->i_logstart);
+	mmb_mark_buffer_dirty(dotdot_bh, &MSDOS_I(inode)->i_metadata_bhs);
+	unlock_buffer(dotdot_bh);
+	if (IS_DIRSYNC(dir))
+		return sync_dirty_buffer(dotdot_bh);
+	return 0;
+}
+EXPORT_SYMBOL_GPL(fat_update_dotdot_de);
+
 /* See if directory is empty */
 int fat_dir_empty(struct inode *dir)
 {
diff --git a/fs/fat/fat.h b/fs/fat/fat.h
index 61338413d..07092e055 100644
--- a/fs/fat/fat.h
+++ b/fs/fat/fat.h
@@ -339,6 +339,9 @@ extern int fat_scan_logstart(struct inode *dir, int i_logstart,
 			     struct fat_slot_info *sinfo);
 extern int fat_get_dotdot_entry(struct inode *dir, struct buffer_head **bh,
 				struct msdos_dir_entry **de);
+extern int fat_update_dotdot_de(struct inode *dir, struct inode *inode,
+				struct buffer_head *dotdot_bh,
+				struct msdos_dir_entry *dotdot_de);
 extern int fat_alloc_new_dir(struct inode *dir, struct timespec64 *ts);
 extern int fat_add_entries(struct inode *dir, void *slots, int nr_slots,
 			   struct fat_slot_info *sinfo);
diff --git a/fs/fat/namei_msdos.c b/fs/fat/namei_msdos.c
index d46d1a385..ee0af94a1 100644
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
+		corrupt |= fat_update_dotdot_de(old_dir, old_inode, dotdot_bh,
+						dotdot_de);
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
