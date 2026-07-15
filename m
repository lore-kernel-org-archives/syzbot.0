Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 43DB83AFD07
	for <syzbot@lists.linux.dev>; Wed, 15 Jul 2026 16:14:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784132063; cv=none; b=MkwUQc6nCyQOEN68ezXB1gfLAwkFhAq1aEzL9wXybn9tRviOgWVhBjZ1FZ7YViUKK3J6HD3tj6nOiSlNWoU7Hwxu3G5p0fPBLNWipvPEwd1+4RFB4urOdnjDi9i4jY99Q+GEuKVYxjvs4XRo2i1BzTXWHvvFxsO2kDJWFygZ9BQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784132063; c=relaxed/simple;
	bh=ClyCnGvuNIf+nvF81LZg7k0DhqUzAIJtv78eOdpGEbA=;
	h=From:To:Cc:Subject:Message-ID:MIME-Version:Content-Type:Date; b=kCywjlWKNtPVKyjMN6hbmh0UE7it2ou+3n/1A4/NUnb/tXpv1liKIXz0atV9N5AN49lAyTmy3QxDPKFqQlAhSj9+wB2p/5Yz0nzHYBPqhuP0xc4jxP1hmc9Z/goOgRVFNebAtRHCRf74dvrsN71RfxWKLIIBqwj7XobxmYa9ViM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=OUF33vGg; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="OUF33vGg"
Received: by smtp.kernel.org (Postfix) with UTF8SMTPSA id A7A291F000E9;
	Wed, 15 Jul 2026 16:14:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1784132044;
	bh=O386yu/ikF6c8kd1sDZi1j8L+0pkqgUTNSyxYW1VO8A=;
	h=From:To:Cc:Subject:Date;
	b=OUF33vGgdRSSbB9qwKNg9HYKWpPvCl+y31n1odOBhSM7mXISf8/Gs9cqWgPWq0Gid
	 0Q3o9oipPbC5mHQZfgZAkMBw9TfG6PDDr+T/mEsrKZU6LhiMTQw26GLb3jYvWILjVG
	 S//q+PS528aTxu6gOIRB6dzpuve7Q/J7B/UJfBCjEjTkka57aCmEe9Q67PoA7nwcrp
	 P1O2fiKn3faF5/iFqt/Rie3hh4JQzjrRoqBj1QTSRGTolgbNVByAJjyck8HfVNzyGh
	 g/8jIPlNbMYflGxJpxRVGqgfhF/DcbXgKINcrW18dQroRfE2Bpx4/9vfVtOcDo60b2
	 qlD+m52CUDwdA==
From: "syzbot" <syzbot@kernel.org>
To: syzkaller-upstream-moderation@googlegroups.com
Cc: syzbot@lists.linux.dev
Subject: [PATCH RFC v2] ocfs2: fix circular locking dependency in ocfs2_init_acl()
Message-ID: <50178043-8171-44ae-ac9e-72449ba95928@mail.kernel.org>
Precedence: bulk
X-Mailing-List: syzbot@lists.linux.dev
List-Id: <syzbot.lists.linux.dev>
List-Subscribe: <mailto:syzbot+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:syzbot+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Date: Wed, 15 Jul 2026 16:14:04 +0000 (UTC)

A lockdep warning indicates a circular locking dependency between
`&oi->ip_xattr_sem` and `&journal->j_trans_barrier`.

The deadlock involves two code paths:
Path 1 (setxattr): `ocfs2_xattr_set()` acquires `ip_xattr_sem` (write) and
then starts a transaction, which acquires `j_trans_barrier` (read).
Path 2 (mkdir/mknod): `ocfs2_mknod()` starts a transaction
(`j_trans_barrier` read) and then calls `ocfs2_init_acl()`, which attempts
to acquire `ip_xattr_sem` (read) on the parent directory to retrieve the
default ACL.

Because rw_semaphores are subject to writer priority, a pending writer on
`j_trans_barrier` (e.g., the journal commit thread) can cause Path 1 to
block, while Path 2 is blocked waiting for Path 1 to release
`ip_xattr_sem`.

======================================================
WARNING: possible circular locking dependency detected
syz.0.17/6116 is trying to acquire lock:
ffff88811dd5a2e8 (&oi->ip_xattr_sem){++++}-{4:4}, at:
ocfs2_init_acl+0x2fd/0x7e0 fs/ocfs2/acl.c:367

but task is already holding lock:
ffff888119b518e0 (&journal->j_trans_barrier){.+.+}-{4:4}, at:
ocfs2_start_trans+0x3ab/0x700 fs/ocfs2/journal.c:369

which lock already depends on the new lock.

Chain exists of:
  &oi->ip_xattr_sem --> sb_internal#2 --> &journal->j_trans_barrier

 Possible unsafe locking scenario:

       CPU0                    CPU1
       ----                    ----
  rlock(&journal->j_trans_barrier);
                               lock(sb_internal#2);
                               lock(&journal->j_trans_barrier);
  rlock(&oi->ip_xattr_sem);

 *** DEADLOCK ***

The patch fixes the lock ordering by precomputing the ACL state before
starting the OCFS2 transaction, while preserving POSIX ACL storage
semantics and the existing inode/security initialization order. By reading
the parent directory's default ACL and preparing the new inode's ACLs
outside the transaction, `ip_xattr_sem` is always acquired before
`j_trans_barrier`.

Update `ocfs2_calc_xattr_init()` and `ocfs2_init_acl()` to use these
precomputed ACLs, removing internal `ip_xattr_sem` acquisition and
redundant disk reads. In `ocfs2_mknod()` and
`ocfs2_init_security_and_acl()`, the umask or default ACL is applied to
`inode->i_mode` before the transaction begins. If `__posix_acl_create()`
indicates an access ACL is not needed, it is released immediately.

Fixes: 16c8d569f570 ("ocfs2/acl: use 'ip_xattr_sem' to protect getting extended attribute")
Assisted-by: Gemini:gemini-3.1-pro-preview Gemini:gemini-3-flash-preview syzbot
Reported-by: syzbot+4007ab5229e732466d9f@syzkaller.appspotmail.com
Closes: https://syzkaller.appspot.com/bug?extid=4007ab5229e732466d9f
Link: https://syzkaller.appspot.com/ai_job?id=c2b46419-cb28-4c0c-b757-f315188c1ae8
To: "Joel Becker" <jlbec@evilplan.org>
To: "Joseph Qi" <joseph.qi@linux.alibaba.com>
To: "Mark Fasheh" <mark@fasheh.com>
To: <ocfs2-devel@lists.linux.dev>
Cc: <linux-kernel@vger.kernel.org>

---
v2:
- Updated ocfs2_calc_xattr_init() to accept precomputed ACLs for more accurate credit and size calculation.
- Modified ocfs2_mknod() and ocfs2_init_security_and_acl() to fetch and create ACLs before starting a transaction, resolving the lock ordering issue.
- Ensured inode->i_mode is updated correctly during the pre-transaction ACL creation phase.
- Added logic to release the access ACL object if it is not required for storage (i.e., matches the file mode).

v1:
https://lore.kernel.org/all/bbc14e84-b364-4f93-90e0-bfe42220b2b1@mail.kernel.org/T/
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
index 1277666c7..30b945ba9 100644
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
@@ -330,10 +332,41 @@ static int ocfs2_mknod(struct mnt_idmap *idmap,
 		}
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
+			status = __posix_acl_create(&acl, GFP_NOFS,
+						    &inode->i_mode);
+			if (status < 0)
+				goto leave;
+			if (status == 0) {
+				posix_acl_release(acl);
+				acl = NULL;
+			}
+		} else {
+			inode->i_mode &= ~current_umask();
+		}
+	} else {
+		inode->i_mode &= ~current_umask();
+	}
+
 	/* calculate meta data/clusters for setting security and acl xattr */
-	status = ocfs2_calc_xattr_init(dir, parent_fe_bh, mode,
-				       &si, &want_clusters,
-				       &xattr_credits, &want_meta);
+	status = ocfs2_calc_xattr_init(dir, parent_fe_bh, mode, &si,
+				       &want_clusters, &xattr_credits,
+				       &want_meta, default_acl, acl);
 	if (status < 0) {
 		mlog_errno(status);
 		goto leave;
@@ -412,7 +445,7 @@ static int ocfs2_mknod(struct mnt_idmap *idmap,
 	}
 
 	status = ocfs2_init_acl(handle, inode, dir, new_fe_bh, parent_fe_bh,
-			 meta_ac, data_ac);
+				meta_ac, data_ac, default_acl, acl);
 
 	if (status < 0) {
 		mlog_errno(status);
@@ -477,6 +510,9 @@ static int ocfs2_mknod(struct mnt_idmap *idmap,
 	brelse(parent_fe_bh);
 	kfree(si.value);
 
+	posix_acl_release(default_acl);
+	posix_acl_release(acl);
+
 	ocfs2_free_dir_lookup_result(&lookup);
 
 	if (inode_ac)
diff --git a/fs/ocfs2/xattr.c b/fs/ocfs2/xattr.c
index fcddd3c13..3b7d2aea7 100644
--- a/fs/ocfs2/xattr.c
+++ b/fs/ocfs2/xattr.c
@@ -26,6 +26,7 @@
 #include <linux/module.h>
 #include <linux/string.h>
 #include <linux/security.h>
+#include <linux/fs_struct.h>
 
 #include <cluster/masklog.h>
 
@@ -611,13 +612,11 @@ int ocfs2_calc_security_init(struct inode *dir,
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
+			  int *want_meta, struct posix_acl *default_acl,
+			  struct posix_acl *acl)
 {
 	int ret = 0;
 	struct ocfs2_super *osb = OCFS2_SB(dir->i_sb);
@@ -628,19 +627,14 @@ int ocfs2_calc_xattr_init(struct inode *dir,
 						     si->value_len);
 
 	if (osb->s_mount_opt & OCFS2_MOUNT_POSIX_ACL) {
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
+		if (default_acl && S_ISDIR(mode)) {
+			acl_len = default_acl->a_count *
+				  sizeof(struct ocfs2_acl_entry);
+			a_size += ocfs2_xattr_entry_real_size(0, acl_len);
+		}
+		if (acl) {
+			acl_len = acl->a_count * sizeof(struct ocfs2_acl_entry);
+			a_size += ocfs2_xattr_entry_real_size(0, acl_len);
 		}
 	}
 
@@ -683,14 +677,28 @@ int ocfs2_calc_xattr_init(struct inode *dir,
 							   new_clusters);
 		*want_clusters += new_clusters;
 	}
-	if (osb->s_mount_opt & OCFS2_MOUNT_POSIX_ACL &&
-	    acl_len > OCFS2_XATTR_INLINE_SIZE) {
-		/* for directory, it has DEFAULT and ACCESS two types of acls */
-		new_clusters = (S_ISDIR(mode) ? 2 : 1) *
-				ocfs2_clusters_for_bytes(dir->i_sb, acl_len);
-		*xattr_credits += ocfs2_clusters_to_blocks(dir->i_sb,
-							   new_clusters);
-		*want_clusters += new_clusters;
+	if (osb->s_mount_opt & OCFS2_MOUNT_POSIX_ACL) {
+		if (default_acl && S_ISDIR(mode)) {
+			acl_len = default_acl->a_count *
+				  sizeof(struct ocfs2_acl_entry);
+			if (acl_len > OCFS2_XATTR_INLINE_SIZE) {
+				new_clusters = ocfs2_clusters_for_bytes(
+					dir->i_sb, acl_len);
+				*xattr_credits += ocfs2_clusters_to_blocks(
+					dir->i_sb, new_clusters);
+				*want_clusters += new_clusters;
+			}
+		}
+		if (acl) {
+			acl_len = acl->a_count * sizeof(struct ocfs2_acl_entry);
+			if (acl_len > OCFS2_XATTR_INLINE_SIZE) {
+				new_clusters = ocfs2_clusters_for_bytes(
+					dir->i_sb, acl_len);
+				*xattr_credits += ocfs2_clusters_to_blocks(
+					dir->i_sb, new_clusters);
+				*want_clusters += new_clusters;
+			}
+		}
 	}
 
 	return ret;
@@ -7257,6 +7265,8 @@ int ocfs2_init_security_and_acl(struct inode *dir,
 {
 	int ret = 0;
 	struct buffer_head *dir_bh = NULL;
+	struct posix_acl *default_acl = NULL, *acl = NULL;
+	umode_t mode = inode->i_mode;
 
 	ret = ocfs2_init_security_get(inode, dir, qstr, NULL);
 	if (ret) {
@@ -7269,12 +7279,55 @@ int ocfs2_init_security_and_acl(struct inode *dir,
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
+			if (ret == 0) {
+				posix_acl_release(acl);
+				acl = NULL;
+			}
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
index 65e9aa743..34f8904de 100644
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
+			  int *, struct posix_acl *, struct posix_acl *);
 
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
