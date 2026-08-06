Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 271CF389116
	for <syzbot@lists.linux.dev>; Thu,  6 Aug 2026 12:11:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786018269; cv=none; b=S0RO23mWSkaumO5tOBGCImSjmszpCMareZsXAb8N4DKHUzbeQAWsRTGa346q+m35lg2ezw7mlGzBs7Axvlh0aV2qg6d+Rt42Z6LV5fLmcTIF85UCxlqJTQnk14IP+z1v/f1swUB0YzbZOU+ZVluOooos0h2mJCRuaAdYQPYygCc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786018269; c=relaxed/simple;
	bh=i3WTSRVUu1CEwLAwNODZ1fRkg4MBXwPYYnQ+jwwdeyk=;
	h=From:To:Cc:Subject:Message-ID:MIME-Version:Content-Type:Date; b=RMmLOKG1szd6exnfNcGc/N75oeZUvN2+jd/T1U3/HepDuYnhhgXZcYQ7imSlKuBsCs1Qai+Fdgej5xwkIHJ6aq/3L54OD+l48EtFLd2tRQaWtoO12oyjac8qqcH3DihUeVFN2+sAOfaucwTkEfiqDvGfqGJxhgR6eTPPjckqUvw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=a2fIB8bd; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="a2fIB8bd"
Received: by smtp.kernel.org (Postfix) with UTF8SMTPSA id D67BF1F000E9;
	Thu,  6 Aug 2026 12:11:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1786018268;
	bh=EYsaSN8KtRlNVXFgWwMHGWKBi/jh9JoYMxB/JrFK5mY=;
	h=From:To:Cc:Subject:Date;
	b=a2fIB8bdTTbsSmh84ej0zxiXiwK13FqKyrbd/lHxLfS8yl2UGZHUKyg+Tyo0og1mx
	 BrlDbkiNyoOrLZhVg8rSyIt5c+PkpdJzojsRq0GesTHjEO9cg7SpYaMzTG7ytV09ak
	 oEVHp4KpxCuoLDPxwmxhuOdFz01LjcXOXUxRosQ1Zx9P4Ga0+F5s3ntxHezU581EL9
	 l4G8t95j+aQMa6khZqO4keFw1+Bd3iHXU2dkJrl5P1+hRubMfSlWzAhPMamaks3F29
	 N0IzhNA9DVcgZXnCYF4hufVl1uF2ihhjUo8FKW4YMN1mQL5F6QPrcfQRjjM72jNGTL
	 ZKrrt3AuZD+Jg==
From: "syzbot" <syzbot@kernel.org>
To: syzkaller-upstream-moderation@googlegroups.com
Cc: syzbot@lists.linux.dev, uladzislau.zhauniarovich@gmail.com
Subject: [PATCH RFC v2] exfat: avoid setting SB_RDONLY directly on error
Message-ID: <8a80967c-5201-4c6a-a2b2-521c49cd5e93@mail.kernel.org>
Precedence: bulk
X-Mailing-List: syzbot@lists.linux.dev
List-Id: <syzbot.lists.linux.dev>
List-Subscribe: <mailto:syzbot+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:syzbot+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Date: Thu,  6 Aug 2026 12:11:07 +0000 (UTC)

In exfat, an I/O error during sync_blockdev() triggers the error handler
(__exfat_fs_error()), which directly sets SB_RDONLY without holding the
s_umount semaphore. If thaw_super() is called after this, it sees the
filesystem as read-only and skips releasing the freeze semaphores. When the
filesystem is later unmounted and destroyed, the s_writers.rw_sem per-CPU
rw-semaphores are freed while still held for write, triggering a warning in
rcu_sync_dtor():

WARNING: kernel/rcu/sync.c:177 at rcu_sync_dtor+0xcd/0x180
Call Trace:
 <TASK>
 percpu_free_rwsem+0x43/0x80 kernel/locking/percpu-rwsem.c:42
 destroy_super_work+0x217/0x310 fs/super.c:284
 process_one_work kernel/workqueue.c:3322 [inline]
 process_scheduled_works+0xa8e/0x14e0 kernel/workqueue.c:3405
 worker_thread+0xa47/0xfb0 kernel/workqueue.c:3486
 kthread+0x388/0x470 kernel/kthread.c:436
 ret_from_fork+0x514/0xb70 arch/x86/kernel/process.c:158
 ret_from_fork_asm+0x1a/0x30 arch/x86/entry/entry_64.S:245
 </TASK>

Fix this by introducing an internal EXFAT_FLAGS_ERROR_RO flag instead of
directly setting SB_RDONLY on error. This prevents confusing the VFS freeze
logic and allows thaw_super() to correctly release the semaphores. We also
add the exfat_check_writable() helper to check both EXFAT_FLAGS_SHUTDOWN
and EXFAT_FLAGS_ERROR_RO, and use it to reject write operations when the
filesystem is in an error-induced read-only state.

Fixes: 772b29cca528 ("exfat: add misc operations")
Assisted-by: Gemini:gemini-3.5-flash Gemini:gemini-3.1-pro-preview syzbot
Reported-by: syzbot+823cd0d24881f21ab9f1@syzkaller.appspotmail.com
Closes: https://syzkaller.appspot.com/bug?extid=823cd0d24881f21ab9f1
Link: https://syzkaller.appspot.com/ai_job?id=7b3f57df-f2f0-4b0d-a492-627c4efe465b
To: "Namjae Jeon" <linkinjeon@kernel.org>
To: <linux-fsdevel@vger.kernel.org>
To: "Sungjong Seo" <sj1557.seo@samsung.com>
To: "Namjae Jeon" <namjae.jeon@samsung.com>
Cc: <linux-kernel@vger.kernel.org>
Cc: "Yuezhang Mo" <yuezhang.mo@sony.com>

---
v2:
- Dropped the fs/super.c changes to handle rollback of freeze on sync_blockdev failure.
- Fixed the issue entirely inside exfat by introducing an internal EXFAT_FLAGS_ERROR_RO flag instead of directly setting SB_RDONLY.
- Added exfat_check_writable() helper to check both EXFAT_FLAGS_SHUTDOWN and EXFAT_FLAGS_ERROR_RO.
- Updated write paths in exfat to use exfat_check_writable().
- Cleared EXFAT_FLAGS_ERROR_RO in exfat_reconfigure() when remounting read-write.

v1:
https://lore.kernel.org/all/fcc77fd9-e38f-49f9-8268-e86683444f29@mail.kernel.org/T/
---
diff --git a/fs/exfat/exfat_fs.h b/fs/exfat/exfat_fs.h
index 9be50949c..50846630e 100644
--- a/fs/exfat/exfat_fs.h
+++ b/fs/exfat/exfat_fs.h
@@ -122,6 +122,7 @@ enum {
 
 /* Superblock flags */
 #define EXFAT_FLAGS_SHUTDOWN	1
+#define EXFAT_FLAGS_ERROR_RO	2
 
 struct exfat_dentry_namebuf {
 	char *lfn;
@@ -320,6 +321,15 @@ static inline int exfat_forced_shutdown(struct super_block *sb)
 	return test_bit(EXFAT_FLAGS_SHUTDOWN, &EXFAT_SB(sb)->s_exfat_flags);
 }
 
+static inline int exfat_check_writable(struct super_block *sb)
+{
+	if (unlikely(exfat_forced_shutdown(sb)))
+		return -EIO;
+	if (unlikely(test_bit(EXFAT_FLAGS_ERROR_RO, &EXFAT_SB(sb)->s_exfat_flags)))
+		return -EROFS;
+	return 0;
+}
+
 /*
  * If ->i_mode can't hold 0222 (i.e. ATTR_RO), we use ->i_attrs to
  * save ATTR_RO instead of ->i_mode.
diff --git a/fs/exfat/file.c b/fs/exfat/file.c
index 5fc13378d..b6afeede2 100644
--- a/fs/exfat/file.c
+++ b/fs/exfat/file.c
@@ -125,8 +125,9 @@ static long exfat_fallocate(struct file *file, int mode,
 	if (!S_ISREG(inode->i_mode))
 		return -EOPNOTSUPP;
 
-	if (unlikely(exfat_forced_shutdown(inode->i_sb)))
-		return -EIO;
+	err = exfat_check_writable(inode->i_sb);
+	if (err)
+		return err;
 
 	inode_lock(inode);
 
@@ -354,8 +355,9 @@ int exfat_setattr(struct mnt_idmap *idmap, struct dentry *dentry,
 	unsigned int ia_valid;
 	int error;
 
-	if (unlikely(exfat_forced_shutdown(inode->i_sb)))
-		return -EIO;
+	error = exfat_check_writable(inode->i_sb);
+	if (error)
+		return error;
 
 	if ((attr->ia_valid & ATTR_SIZE) &&
 	    attr->ia_size > i_size_read(inode)) {
@@ -738,8 +740,9 @@ static ssize_t exfat_file_write_iter(struct kiocb *iocb, struct iov_iter *iter)
 	loff_t valid_size;
 	int err;
 
-	if (unlikely(exfat_forced_shutdown(inode->i_sb)))
-		return -EIO;
+	ret = exfat_check_writable(inode->i_sb);
+	if (ret < 0)
+		return ret;
 
 	inode_lock(inode);
 
@@ -826,6 +829,11 @@ static vm_fault_t exfat_page_mkwrite(struct vm_fault *vmf)
 	struct exfat_inode_info *ei = EXFAT_I(inode);
 	vm_fault_t ret;
 	loff_t new_valid_size, mmap_valid_size;
+	int err;
+
+	err = exfat_check_writable(inode->i_sb);
+	if (err)
+		return vmf_fs_error(err);
 
 	if (!inode_trylock(inode))
 		return VM_FAULT_RETRY;
@@ -835,8 +843,6 @@ static vm_fault_t exfat_page_mkwrite(struct vm_fault *vmf)
 
 	if (ei->valid_size < new_valid_size) {
 		if (ei->zeroed_size < mmap_valid_size) {
-			int err;
-
 			/*
 			 * Only zero the range that hasn't been zeroed yet for
 			 * this mmap write path. zeroed_size tracks the largest
diff --git a/fs/exfat/misc.c b/fs/exfat/misc.c
index 6f11a96a4..ab875473f 100644
--- a/fs/exfat/misc.c
+++ b/fs/exfat/misc.c
@@ -41,8 +41,8 @@ void __exfat_fs_error(struct super_block *sb, int report, const char *fmt, ...)
 		panic("exFAT-fs (%s): fs panic from previous error\n",
 			sb->s_id);
 	} else if (opts->errors == EXFAT_ERRORS_RO && !sb_rdonly(sb)) {
-		sb->s_flags |= SB_RDONLY;
-		exfat_err(sb, "Filesystem has been set read-only");
+		if (!test_and_set_bit(EXFAT_FLAGS_ERROR_RO, &EXFAT_SB(sb)->s_exfat_flags))
+			exfat_err(sb, "Filesystem has been set read-only");
 	}
 }
 
diff --git a/fs/exfat/namei.c b/fs/exfat/namei.c
index b7d5e44ad..f08170de6 100644
--- a/fs/exfat/namei.c
+++ b/fs/exfat/namei.c
@@ -547,8 +547,9 @@ static int exfat_create(struct mnt_idmap *idmap, struct inode *dir,
 	int err;
 	loff_t size = i_size_read(dir);
 
-	if (unlikely(exfat_forced_shutdown(sb)))
-		return -EIO;
+	err = exfat_check_writable(sb);
+	if (err)
+		return err;
 
 	mutex_lock(&EXFAT_SB(sb)->s_lock);
 	exfat_set_volume_dirty(sb);
@@ -765,10 +766,11 @@ static int exfat_unlink(struct inode *dir, struct dentry *dentry)
 	struct inode *inode = dentry->d_inode;
 	struct exfat_inode_info *ei = EXFAT_I(inode);
 	struct exfat_entry_set_cache es;
-	int err = 0;
+	int err;
 
-	if (unlikely(exfat_forced_shutdown(sb)))
-		return -EIO;
+	err = exfat_check_writable(sb);
+	if (err)
+		return err;
 
 	mutex_lock(&EXFAT_SB(sb)->s_lock);
 	if (ei->dir.dir == DIR_DELETED) {
@@ -820,8 +822,9 @@ static struct dentry *exfat_mkdir(struct mnt_idmap *idmap, struct inode *dir,
 	int err;
 	loff_t size = i_size_read(dir);
 
-	if (unlikely(exfat_forced_shutdown(sb)))
-		return ERR_PTR(-EIO);
+	err = exfat_check_writable(sb);
+	if (err)
+		return ERR_PTR(err);
 
 	mutex_lock(&EXFAT_SB(sb)->s_lock);
 	exfat_set_volume_dirty(sb);
@@ -911,8 +914,9 @@ static int exfat_rmdir(struct inode *dir, struct dentry *dentry)
 	struct exfat_entry_set_cache es;
 	int err;
 
-	if (unlikely(exfat_forced_shutdown(sb)))
-		return -EIO;
+	err = exfat_check_writable(sb);
+	if (err)
+		return err;
 
 	mutex_lock(&EXFAT_SB(inode->i_sb)->s_lock);
 
@@ -995,9 +999,6 @@ static int exfat_rename_file(struct inode *parent_inode,
 	int sync = IS_DIRSYNC(parent_inode);
 	unsigned int num_extra_entries, num_total_entries;
 
-	if (unlikely(exfat_forced_shutdown(sb)))
-		return -EIO;
-
 	num_new_entries = exfat_calc_num_entries(p_uniname);
 	if (num_new_entries < 0)
 		return num_new_entries;
@@ -1267,6 +1268,10 @@ static int exfat_rename(struct mnt_idmap *idmap,
 	if (flags & ~RENAME_NOREPLACE)
 		return -EINVAL;
 
+	err = exfat_check_writable(sb);
+	if (err)
+		return err;
+
 	mutex_lock(&EXFAT_SB(sb)->s_lock);
 	old_inode = old_dentry->d_inode;
 	new_inode = new_dentry->d_inode;
diff --git a/fs/exfat/super.c b/fs/exfat/super.c
index 388db271c..dcb6e15e4 100644
--- a/fs/exfat/super.c
+++ b/fs/exfat/super.c
@@ -807,6 +807,9 @@ static int exfat_reconfigure(struct fs_context *fc)
 
 	swap(*cur_opts, *new_opts);
 
+	if (!(fc->sb_flags & SB_RDONLY))
+		clear_bit(EXFAT_FLAGS_ERROR_RO, &sbi->s_exfat_flags);
+
 	return 0;
 }
 


base-commit: 1590cf0329716306e948a8fc29f1d3ee87d3989f
-- 
This is an AI-generated patch subject to moderation.
Reply with '#syz upstream' to Sign-off the patch as a human author
and send it to the upstream kernel mailing lists.
Reply with '#syz reject' to reject it ('#syz unreject' to undo).

See https://goo.gle/syzbot-ai-patches for information about AI-generated patches.
The person who has signed off on the patch is responsible for
addressing comments.
syzbot engineers can be reached at syzkaller@googlegroups.com.
