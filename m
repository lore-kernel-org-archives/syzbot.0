Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3FB4933342C
	for <syzbot@lists.linux.dev>; Mon, 29 Jun 2026 17:44:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782755083; cv=none; b=AUOAHS8FzZJHFqPQ78E2+//h1wwXBSJMC8MAzgyJgeIz4R351gM+R6dVcaQNrwT/b+ZQodW0ZllNKXz+lv19mqJG8GkFvx+98el+fzeWLVJkAmJ3+jhF/I982ariszO/yUhZom1CAmYjV47cNUDju0UJrvunK2Cr00PZEDoHHAw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782755083; c=relaxed/simple;
	bh=uKvMsNLyimdw3EdpCx6ZE+4Jkg4vE9BOsS8SRNokhmU=;
	h=From:To:Cc:Subject:Message-ID:MIME-Version:Content-Type:Date; b=BMS78NRpJH92ZvGfyLQ0NycRXaQbr8EIZXYGcoMu8IOsXytUmxsebXI3+LX1cs4Ry91FS/T4s4BdA7GtMWj135Nk4rFBeRkIStHBNqx6RUikD/fLDXKE4Cy0sQo+tfx4Q0dnRtfk8dtanjWMVKCt0FqJTqkN32xpVHQZnysAWBU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Zo7rhwdD; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Zo7rhwdD"
Received: by smtp.kernel.org (Postfix) with UTF8SMTPSA id A6BA81F000E9;
	Mon, 29 Jun 2026 17:44:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1782755081;
	bh=7NhWWf+qTR0tsKiKsjC81AiCsSsa6EYWqhW4jmBcuSQ=;
	h=From:To:Cc:Subject:Date;
	b=Zo7rhwdD6GEgGshKHVlEeL1+u5MGoLSt3ofS89wbcsNzgOG7W5ITCIuvTr2/miPL3
	 uLf2PAr30zdSerUAdhbjzR8WJhkLWOjeJTWRdPYtPKErD1l1xtH8pKH9L5czJFn0O2
	 gSrltHWN4YUQj8nHI9dPxqABMh6mPHAUvIbFnd+jt0OOaajV23KHji/s06mOwPa7ta
	 EN9w1HHZS/ddQ8CSs+PLxG1C4bt+2tOGHOP2qYrX7ueynge6gHGLnFTtkDkzcGHiuZ
	 vjtG2xvIM1rL2mNunH62cYSiMuPp3BOLgcMrzDBnzHloHldz45F3fDRoqKqd2bF9fS
	 /dj7510r5LniA==
From: "syzbot" <syzbot@kernel.org>
To: syzkaller-upstream-moderation@googlegroups.com
Cc: syzbot@lists.linux.dev
Subject: [PATCH RFC] ocfs2: fix circular locking dependency in ocfs2_mknod()
Message-ID: <bbc14e84-b364-4f93-90e0-bfe42220b2b1@mail.kernel.org>
Precedence: bulk
X-Mailing-List: syzbot@lists.linux.dev
List-Id: <syzbot.lists.linux.dev>
List-Subscribe: <mailto:syzbot+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:syzbot+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Date: Mon, 29 Jun 2026 17:44:41 +0000 (UTC)

A lockdep warning indicates a classic AB-BA circular locking dependency
(deadlock) in the OCFS2 filesystem. The deadlock involves two rw_semaphore
locks: `&OCFS2_I(inode)->ip_xattr_sem` (protects extended attributes of an
inode) and `&osb->journal->j_trans_barrier` (protects the OCFS2 journal
transaction).

The relevant lockdep output shows that `ocfs2_init_acl()` attempts to
acquire `&oi->ip_xattr_sem` while holding `&journal->j_trans_barrier`
(acquired in `ocfs2_start_trans()`). However, the existing dependency chain
shows that `ocfs2_xattr_set()` acquires `&oi->ip_xattr_sem` before calling
`ocfs2_init_xattr_set_ctxt()` and `ocfs2_start_trans()`, which then
acquires `&journal->j_trans_barrier`.

The cycle is formed by two different code paths acquiring these locks in
the opposite order.

Path 1 (setxattr) acquires `ip_xattr_sem` then `j_trans_barrier`. When
setting an extended attribute (like a POSIX ACL) on an existing inode,
OCFS2 needs to search for the xattr to calculate the required transaction
credits before starting the transaction. `ocfs2_xattr_set()` acquires the
xattr semaphore for write, searches the xattrs, calculates credits, and
calls `ocfs2_init_xattr_set_ctxt()`. It then starts the transaction by
calling `ocfs2_start_trans()`, which acquires the transaction barrier for
read.

Path 2 (mkdir/mknod) acquires `j_trans_barrier` then `ip_xattr_sem`. When
creating a new file or directory, OCFS2 starts the transaction first, and
then initializes the ACLs for the new inode by reading the default ACL from
the parent directory. `ocfs2_mknod()` starts the transaction, which
acquires the transaction barrier for read. Later, it calls
`ocfs2_init_acl()` to initialize the ACLs for the new inode, which attempts
to read the default ACL from the parent directory, acquiring its xattr
semaphore for read.

Because both locks are rw_semaphores, they are subject to writer priority.
If a third thread (e.g., the journal commit thread) tries to acquire
`j_trans_barrier` for write, it will block waiting for Path 2 to release
its read lock. Path 1's attempt to acquire `j_trans_barrier` for read will
then be queued behind the pending writer. Meanwhile, Path 2 is blocked
waiting for Path 1 to release the write lock on `ip_xattr_sem`. This
results in a deadlock.

Since `ocfs2_xattr_set()` must hold `ip_xattr_sem` across the transaction
start to protect the xattr search and credit calculation, the established
lock ordering must be `ip_xattr_sem` followed by `j_trans_barrier`.
Therefore, `ocfs2_mknod()` must be fixed so it does not acquire
`ip_xattr_sem` while the transaction is active.

Resolve this by reading the parent directory's ACLs before calling
`ocfs2_start_trans()`. In `ocfs2_mknod()`, manually acquire `ip_xattr_sem`
and use `ocfs2_get_acl_nolock()` to fetch the parent's default ACL before
starting the transaction. Clone the default ACL (if present) and use
`__posix_acl_create()` to apply the umask and prepare the new access ACL
and mode. If no default ACL is present, the umask is applied directly to
the mode. This updated mode is then passed to `ocfs2_get_init_inode()`,
ensuring the inode is initialized with the correct mode from the start.

Update `ocfs2_calc_xattr_init()` and `ocfs2_init_acl()` to accept the
pre-computed `default_acl` and `acl`, removing their internal
`ip_xattr_sem` acquisition and redundant disk reads. Update
`ocfs2_init_security_and_acl()` to fetch the ACLs using
`ocfs2_get_acl_nolock()` and prepare them using `__posix_acl_create()`
before passing them down. Include `<linux/fs_struct.h>` in
`fs/ocfs2/namei.c` and `fs/ocfs2/xattr.c` to resolve the implicit
declaration of `current_umask()`.

Fixes: 16c8d569f570 ("ocfs2/acl: use 'ip_xattr_sem' to protect getting extended attribute")
Assisted-by: Gemini:gemini-3.1-pro-preview best-expensive syzbot
Reported-by: syzbot+4007ab5229e732466d9f@syzkaller.appspotmail.com
Closes: https://syzkaller.appspot.com/bug?extid=4007ab5229e732466d9f
Link: https://syzkaller.appspot.com/ai_job?id=3d0e581f-163d-4801-aba5-4048a628785c
To: "Joel Becker" <jlbec@evilplan.org>
To: "Joseph Qi" <joseph.qi@linux.alibaba.com>
To: "Mark Fasheh" <mark@fasheh.com>
To: <ocfs2-devel@lists.linux.dev>
Cc: <linux-kernel@vger.kernel.org>

---
diff --git a/fs/ocfs2/acl.c b/fs/ocfs2/acl.c
index af1e2cedb..ec4b36004 100644
--- a/fs/ocfs2/acl.c
+++ b/fs/ocfs2/acl.c
@@ -110,9 +110,8 @@ static void *ocfs2_acl_to_xattr(const struct posix_acl *acl, size_t *size)
 	return ocfs2_acl;
 }
 
-static struct posix_acl *ocfs2_get_acl_nolock(struct inode *inode,
-					      int type,
-					      struct buffer_head *di_bh)
+struct posix_acl *ocfs2_get_acl_nolock(struct inode *inode, int type,
+				       struct buffer_head *di_bh)
 {
 	int name_index;
 	char *value = NULL;
@@ -156,8 +155,8 @@ static struct posix_acl *ocfs2_get_acl_nolock(struct inode *inode,
  * will not have di_bh or a journal handle to pass, in which case it
  * will create it's own.
  */
-static int ocfs2_acl_set_mode(struct inode *inode, struct buffer_head *di_bh,
-			      handle_t *handle, umode_t new_mode)
+int ocfs2_acl_set_mode(struct inode *inode, struct buffer_head *di_bh,
+		       handle_t *handle, umode_t new_mode)
 {
 	int ret, commit_handle = 0;
 	struct ocfs2_dinode *di;
@@ -349,63 +348,33 @@ int ocfs2_acl_chmod(struct inode *inode, struct buffer_head *bh)
  * Initialize the ACLs of a new inode. If parent directory has default ACL,
  * then clone to new inode. Called from ocfs2_mknod.
  */
-int ocfs2_init_acl(handle_t *handle,
-		   struct inode *inode,
-		   struct inode *dir,
-		   struct buffer_head *di_bh,
-		   struct buffer_head *dir_bh,
+int ocfs2_init_acl(handle_t *handle, struct inode *inode, struct inode *dir,
+		   struct buffer_head *di_bh, struct buffer_head *dir_bh,
 		   struct ocfs2_alloc_context *meta_ac,
-		   struct ocfs2_alloc_context *data_ac)
+		   struct ocfs2_alloc_context *data_ac,
+		   struct posix_acl *default_acl, struct posix_acl *acl)
 {
 	struct ocfs2_super *osb = OCFS2_SB(inode->i_sb);
-	struct posix_acl *acl = NULL;
-	int ret = 0, ret2;
-	umode_t mode;
-
-	if (!S_ISLNK(inode->i_mode)) {
-		if (osb->s_mount_opt & OCFS2_MOUNT_POSIX_ACL) {
-			down_read(&OCFS2_I(dir)->ip_xattr_sem);
-			acl = ocfs2_get_acl_nolock(dir, ACL_TYPE_DEFAULT,
-						   dir_bh);
-			up_read(&OCFS2_I(dir)->ip_xattr_sem);
-			if (IS_ERR(acl))
-				return PTR_ERR(acl);
-		}
-		if (!acl) {
-			mode = inode->i_mode & ~current_umask();
-			ret = ocfs2_acl_set_mode(inode, di_bh, handle, mode);
-			if (ret) {
-				mlog_errno(ret);
-				goto cleanup;
-			}
-		}
-	}
-	if ((osb->s_mount_opt & OCFS2_MOUNT_POSIX_ACL) && acl) {
-		if (S_ISDIR(inode->i_mode)) {
+	int ret = 0;
+
+	if (S_ISLNK(inode->i_mode))
+		return 0;
+
+	if (osb->s_mount_opt & OCFS2_MOUNT_POSIX_ACL) {
+		if (S_ISDIR(inode->i_mode) && default_acl) {
 			ret = ocfs2_set_acl(handle, inode, di_bh,
-					    ACL_TYPE_DEFAULT, acl,
+					    ACL_TYPE_DEFAULT, default_acl,
 					    meta_ac, data_ac);
 			if (ret)
-				goto cleanup;
-		}
-		mode = inode->i_mode;
-		ret = __posix_acl_create(&acl, GFP_NOFS, &mode);
-		if (ret < 0)
-			return ret;
-
-		ret2 = ocfs2_acl_set_mode(inode, di_bh, handle, mode);
-		if (ret2) {
-			mlog_errno(ret2);
-			ret = ret2;
-			goto cleanup;
+				return ret;
 		}
-		if (ret > 0) {
+
+		if (acl) {
 			ret = ocfs2_set_acl(handle, inode,
 					    di_bh, ACL_TYPE_ACCESS,
 					    acl, meta_ac, data_ac);
 		}
 	}
-cleanup:
-	posix_acl_release(acl);
+
 	return ret;
 }
diff --git a/fs/ocfs2/acl.h b/fs/ocfs2/acl.h
index 667c6f03f..786b4d32b 100644
--- a/fs/ocfs2/acl.h
+++ b/fs/ocfs2/acl.h
@@ -23,6 +23,11 @@ extern int ocfs2_acl_chmod(struct inode *, struct buffer_head *);
 extern int ocfs2_init_acl(handle_t *, struct inode *, struct inode *,
 			  struct buffer_head *, struct buffer_head *,
 			  struct ocfs2_alloc_context *,
-			  struct ocfs2_alloc_context *);
+			  struct ocfs2_alloc_context *, struct posix_acl *,
+			  struct posix_acl *);
+struct posix_acl *ocfs2_get_acl_nolock(struct inode *inode, int type,
+				       struct buffer_head *di_bh);
+int ocfs2_acl_set_mode(struct inode *inode, struct buffer_head *di_bh,
+		       handle_t *handle, umode_t new_mode);
 
 #endif /* OCFS2_ACL_H */
diff --git a/fs/ocfs2/namei.c b/fs/ocfs2/namei.c
index 1277666c7..06a1d8add 100644
--- a/fs/ocfs2/namei.c
+++ b/fs/ocfs2/namei.c
@@ -27,6 +27,7 @@
 #include <linux/highmem.h>
 #include <linux/quotaops.h>
 #include <linux/iversion.h>
+#include <linux/fs_struct.h>
 
 #include <cluster/masklog.h>
 
@@ -256,6 +257,7 @@ static int ocfs2_mknod(struct mnt_idmap *idmap,
 	sigset_t oldset;
 	int did_block_signals = 0;
 	struct ocfs2_dentry_lock *dl = NULL;
+	struct posix_acl *default_acl = NULL, *acl = NULL;
 
 	trace_ocfs2_mknod(dir, dentry, dentry->d_name.len, dentry->d_name.name,
 			  (unsigned long long)OCFS2_I(dir)->ip_blkno,
@@ -311,6 +313,32 @@ static int ocfs2_mknod(struct mnt_idmap *idmap,
 		goto leave;
 	}
 
+	if (osb->s_mount_opt & OCFS2_MOUNT_POSIX_ACL) {
+		down_read(&OCFS2_I(dir)->ip_xattr_sem);
+		default_acl = ocfs2_get_acl_nolock(dir, ACL_TYPE_DEFAULT,
+						   parent_fe_bh);
+		up_read(&OCFS2_I(dir)->ip_xattr_sem);
+		if (IS_ERR(default_acl)) {
+			status = PTR_ERR(default_acl);
+			default_acl = NULL;
+			goto leave;
+		}
+		if (default_acl) {
+			acl = posix_acl_dup(default_acl);
+			if (!acl) {
+				status = -ENOMEM;
+				goto leave;
+			}
+			status = __posix_acl_create(&acl, GFP_NOFS, &mode);
+			if (status < 0)
+				goto leave;
+		} else {
+			mode &= ~current_umask();
+		}
+	} else {
+		mode &= ~current_umask();
+	}
+
 	inode = ocfs2_get_init_inode(dir, mode);
 	if (IS_ERR(inode)) {
 		status = PTR_ERR(inode);
@@ -331,9 +359,9 @@ static int ocfs2_mknod(struct mnt_idmap *idmap,
 	}
 
 	/* calculate meta data/clusters for setting security and acl xattr */
-	status = ocfs2_calc_xattr_init(dir, parent_fe_bh, mode,
-				       &si, &want_clusters,
-				       &xattr_credits, &want_meta);
+	status = ocfs2_calc_xattr_init(dir, parent_fe_bh, mode, &si,
+				       &want_clusters, &xattr_credits,
+				       &want_meta, default_acl);
 	if (status < 0) {
 		mlog_errno(status);
 		goto leave;
@@ -412,7 +440,7 @@ static int ocfs2_mknod(struct mnt_idmap *idmap,
 	}
 
 	status = ocfs2_init_acl(handle, inode, dir, new_fe_bh, parent_fe_bh,
-			 meta_ac, data_ac);
+				meta_ac, data_ac, default_acl, acl);
 
 	if (status < 0) {
 		mlog_errno(status);
@@ -477,6 +505,9 @@ static int ocfs2_mknod(struct mnt_idmap *idmap,
 	brelse(parent_fe_bh);
 	kfree(si.value);
 
+	posix_acl_release(default_acl);
+	posix_acl_release(acl);
+
 	ocfs2_free_dir_lookup_result(&lookup);
 
 	if (inode_ac)
diff --git a/fs/ocfs2/xattr.c b/fs/ocfs2/xattr.c
index fcddd3c13..a489ee2fe 100644
--- a/fs/ocfs2/xattr.c
+++ b/fs/ocfs2/xattr.c
@@ -26,6 +26,7 @@
 #include <linux/module.h>
 #include <linux/string.h>
 #include <linux/security.h>
+#include <linux/fs_struct.h>
 
 #include <cluster/masklog.h>
 
@@ -611,13 +612,10 @@ int ocfs2_calc_security_init(struct inode *dir,
 	return ret;
 }
 
-int ocfs2_calc_xattr_init(struct inode *dir,
-			  struct buffer_head *dir_bh,
-			  umode_t mode,
-			  struct ocfs2_security_xattr_info *si,
-			  int *want_clusters,
-			  int *xattr_credits,
-			  int *want_meta)
+int ocfs2_calc_xattr_init(struct inode *dir, struct buffer_head *dir_bh,
+			  umode_t mode, struct ocfs2_security_xattr_info *si,
+			  int *want_clusters, int *xattr_credits,
+			  int *want_meta, struct posix_acl *default_acl)
 {
 	int ret = 0;
 	struct ocfs2_super *osb = OCFS2_SB(dir->i_sb);
@@ -627,21 +625,11 @@ int ocfs2_calc_xattr_init(struct inode *dir,
 		s_size = ocfs2_xattr_entry_real_size(strlen(si->name),
 						     si->value_len);
 
-	if (osb->s_mount_opt & OCFS2_MOUNT_POSIX_ACL) {
-		down_read(&OCFS2_I(dir)->ip_xattr_sem);
-		acl_len = ocfs2_xattr_get_nolock(dir, dir_bh,
-					OCFS2_XATTR_INDEX_POSIX_ACL_DEFAULT,
-					"", NULL, 0);
-		up_read(&OCFS2_I(dir)->ip_xattr_sem);
-		if (acl_len > 0) {
-			a_size = ocfs2_xattr_entry_real_size(0, acl_len);
-			if (S_ISDIR(mode))
-				a_size <<= 1;
-		} else if (acl_len != 0 && acl_len != -ENODATA) {
-			ret = acl_len;
-			mlog_errno(ret);
-			return ret;
-		}
+	if (osb->s_mount_opt & OCFS2_MOUNT_POSIX_ACL && default_acl) {
+		acl_len = default_acl->a_count * sizeof(struct ocfs2_acl_entry);
+		a_size = ocfs2_xattr_entry_real_size(0, acl_len);
+		if (S_ISDIR(mode))
+			a_size <<= 1;
 	}
 
 	if (!(s_size + a_size))
@@ -7257,6 +7245,8 @@ int ocfs2_init_security_and_acl(struct inode *dir,
 {
 	int ret = 0;
 	struct buffer_head *dir_bh = NULL;
+	struct posix_acl *default_acl = NULL, *acl = NULL;
+	umode_t mode = inode->i_mode;
 
 	ret = ocfs2_init_security_get(inode, dir, qstr, NULL);
 	if (ret) {
@@ -7269,12 +7259,51 @@ int ocfs2_init_security_and_acl(struct inode *dir,
 		mlog_errno(ret);
 		goto leave;
 	}
-	ret = ocfs2_init_acl(NULL, inode, dir, NULL, dir_bh, NULL, NULL);
+
+	if (OCFS2_SB(dir->i_sb)->s_mount_opt & OCFS2_MOUNT_POSIX_ACL) {
+		down_read(&OCFS2_I(dir)->ip_xattr_sem);
+		default_acl =
+			ocfs2_get_acl_nolock(dir, ACL_TYPE_DEFAULT, dir_bh);
+		up_read(&OCFS2_I(dir)->ip_xattr_sem);
+		if (IS_ERR(default_acl)) {
+			ret = PTR_ERR(default_acl);
+			default_acl = NULL;
+			goto unlock;
+		}
+		if (default_acl) {
+			acl = posix_acl_dup(default_acl);
+			if (!acl) {
+				ret = -ENOMEM;
+				goto unlock;
+			}
+			ret = __posix_acl_create(&acl, GFP_NOFS, &mode);
+			if (ret < 0)
+				goto unlock;
+		} else {
+			mode &= ~current_umask();
+		}
+	} else {
+		mode &= ~current_umask();
+	}
+
+	if (mode != inode->i_mode) {
+		ret = ocfs2_acl_set_mode(inode, NULL, NULL, mode);
+		if (ret) {
+			mlog_errno(ret);
+			goto unlock;
+		}
+	}
+
+	ret = ocfs2_init_acl(NULL, inode, dir, NULL, dir_bh, NULL, NULL,
+			     default_acl, acl);
 	if (ret)
 		mlog_errno(ret);
 
+unlock:
 	ocfs2_inode_unlock(dir, 0);
 	brelse(dir_bh);
+	posix_acl_release(default_acl);
+	posix_acl_release(acl);
 leave:
 	return ret;
 }
diff --git a/fs/ocfs2/xattr.h b/fs/ocfs2/xattr.h
index 65e9aa743..7394a4a40 100644
--- a/fs/ocfs2/xattr.h
+++ b/fs/ocfs2/xattr.h
@@ -55,9 +55,9 @@ int ocfs2_init_security_set(handle_t *, struct inode *,
 int ocfs2_calc_security_init(struct inode *,
 			     struct ocfs2_security_xattr_info *,
 			     int *, int *, struct ocfs2_alloc_context **);
-int ocfs2_calc_xattr_init(struct inode *, struct buffer_head *,
-			  umode_t, struct ocfs2_security_xattr_info *,
-			  int *, int *, int *);
+int ocfs2_calc_xattr_init(struct inode *, struct buffer_head *, umode_t,
+			  struct ocfs2_security_xattr_info *, int *, int *,
+			  int *, struct posix_acl *);
 
 /*
  * xattrs can live inside an inode, as part of an external xattr block,


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
