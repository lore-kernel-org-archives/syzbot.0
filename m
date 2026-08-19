Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C499B43991B
	for <syzbot@lists.linux.dev>; Wed, 19 Aug 2026 09:27:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787131629; cv=none; b=fn41S2m0qfuhBoHuDLcFEgyGxSwuw/1GiyapL1m5eckRMK8ccbvyZ/yI+PIag2o8/u8KXC9e/iv98LSOUdmnJHJaWwcPxG+65LAGrMzVxScYBUmHUO2Ht8W+ZrUCFzCxK9nU+41Q+z0XX26iX9z+YJb6RR6zft9OnRSS8lNuZQ0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787131629; c=relaxed/simple;
	bh=52Ofovoq68FqmP22CdDDLBLjHcm97GQFGwgVh8OZlxk=;
	h=From:To:Cc:Subject:Message-ID:MIME-Version:Content-Type:Date; b=KEGsJv270Uo7pkqw8TU/KINeDRptfRgu+of2GSK87fm0L7mYmWYooOJXcj66POKv0awpiJ+W/DQfbOwUYd57k9RZAZukT9y07OMPOhbUIFAe84405gyLnp83WdS1yzMYzl9ZOFcDJIxp3wjybSjRASbnWxXs5y6wSnB9G1bsZMk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=TTS0Zthr; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="TTS0Zthr"
Received: by smtp.kernel.org (Postfix) with UTF8SMTPSA id B4FA71F000E9;
	Wed, 19 Aug 2026 09:27:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1787131625;
	bh=NTzsa3AxixnyhzyUHuqzPQtI7uQIDQJV1G5+8im/jjs=;
	h=From:To:Cc:Subject:Date;
	b=TTS0Zthrj97WQqsjwWDbv1Bq9HylyfJBmaRxllbr3VrTQ/JWh2NhfZZc6r4D0A9cY
	 KMlbFBHpAG49khqD7DaevRBU4YmqOUVUb60VaD3bUE3puDAldumXSnUHr3a9hhSa/c
	 5w5fOeIOQ6N78kLdBmZQunbAAnqCARMGLjYw9uaO95ydzqPgEMiq4DYy7yS6J82Ddb
	 Jvv/ZgYEVyH2wsRWkcN3EjKNMlN2G2S6Hqu8yYSM5OhI3DsPv0pEf1AeyqKgVFX1ht
	 kQn7WkZOwBXY3vbuiMM5x3qwtRlNdcdv8IN40pLAfXmAkgnL217uhcScgq+cSLR2UJ
	 eHraKWnQeZlxw==
From: "syzbot" <syzbot@kernel.org>
To: syzkaller-upstream-moderation@googlegroups.com
Cc: syzbot@lists.linux.dev
Subject: [PATCH RFC] ocfs2: fix circular locking dependency in ocfs2_mknod()
Message-ID: <69538bcf-4f84-4ab9-9372-4894fa16e7b4@mail.kernel.org>
Precedence: bulk
X-Mailing-List: syzbot@lists.linux.dev
List-Id: <syzbot.lists.linux.dev>
List-Subscribe: <mailto:syzbot+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:syzbot+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Date: Wed, 19 Aug 2026 09:27:05 +0000 (UTC)

A circular locking dependency was detected involving three locks:
ip_alloc_sem, j_trans_barrier (the journal transaction barrier), and
ip_xattr_sem.

======================================================
WARNING: possible circular locking dependency detected

Chain exists of:
  &oi->ip_alloc_sem --> &journal->j_trans_barrier --> &oi->ip_xattr_sem

 Possible unsafe locking scenario:

       CPU0                    CPU1
  lock(&oi->ip_xattr_sem);
                               lock(&journal->j_trans_barrier);
                               lock(&oi->ip_xattr_sem);
  lock(&oi->ip_alloc_sem);

 *** DEADLOCK ***
======================================================

The lock inversion occurs in ocfs2_mknod() -> ocfs2_init_acl().
ocfs2_mknod() starts a transaction via ocfs2_start_trans(), acquiring
j_trans_barrier. While holding this transaction handle, it calls
ocfs2_init_acl(), which acquires ip_xattr_sem to read the default ACL of
the parent directory. This violates the strict OCFS2 lock ordering rule
that inode semaphores (ip_alloc_sem, ip_xattr_sem, etc.) must be acquired
before starting a transaction.

To resolve this, fetch the default ACL before starting the transaction in
ocfs2_mknod() and pass it down to ocfs2_init_acl(). We use get_inode_acl()
to retrieve the ACL, which safely handles recursive cluster locking and
correctly takes ip_xattr_sem before any transaction is started. The same
logic is applied to ocfs2_init_security_and_acl(), the only other caller of
ocfs2_init_acl().

Fixes: 16c8d569f570 ("ocfs2/acl: use 'ip_xattr_sem' to protect getting extended attribute")
Assisted-by: Gemini:gemini-3.6-flash Gemini:gemini-3.1-pro-preview syzbot
Reported-by: syzbot+1fed2de07d8e11a3ec1b@syzkaller.appspotmail.com
Closes: https://syzkaller.appspot.com/bug?extid=1fed2de07d8e11a3ec1b
Link: https://syzkaller.appspot.com/ai_job?id=22bc5699-2231-4026-98db-8f9510b94925
To: "Joel Becker" <jlbec@evilplan.org>
To: "Joseph Qi" <joseph.qi@linux.alibaba.com>
To: "Mark Fasheh" <mark@fasheh.com>
To: <ocfs2-devel@lists.linux.dev>
To: "piaojun" <piaojun@huawei.com>
Cc: <linux-kernel@vger.kernel.org>

---
diff --git a/fs/ocfs2/acl.c b/fs/ocfs2/acl.c
index af1e2cedb..a16386c23 100644
--- a/fs/ocfs2/acl.c
+++ b/fs/ocfs2/acl.c
@@ -353,7 +353,7 @@ int ocfs2_init_acl(handle_t *handle,
 		   struct inode *inode,
 		   struct inode *dir,
 		   struct buffer_head *di_bh,
-		   struct buffer_head *dir_bh,
+		   struct posix_acl *default_acl,
 		   struct ocfs2_alloc_context *meta_ac,
 		   struct ocfs2_alloc_context *data_ac)
 {
@@ -364,12 +364,8 @@ int ocfs2_init_acl(handle_t *handle,
 
 	if (!S_ISLNK(inode->i_mode)) {
 		if (osb->s_mount_opt & OCFS2_MOUNT_POSIX_ACL) {
-			down_read(&OCFS2_I(dir)->ip_xattr_sem);
-			acl = ocfs2_get_acl_nolock(dir, ACL_TYPE_DEFAULT,
-						   dir_bh);
-			up_read(&OCFS2_I(dir)->ip_xattr_sem);
-			if (IS_ERR(acl))
-				return PTR_ERR(acl);
+			if (default_acl)
+				acl = posix_acl_dup(default_acl);
 		}
 		if (!acl) {
 			mode = inode->i_mode & ~current_umask();
diff --git a/fs/ocfs2/acl.h b/fs/ocfs2/acl.h
index 667c6f03f..c1ba2eb27 100644
--- a/fs/ocfs2/acl.h
+++ b/fs/ocfs2/acl.h
@@ -21,7 +21,7 @@ int ocfs2_iop_set_acl(struct mnt_idmap *idmap, struct dentry *dentry,
 		      struct posix_acl *acl, int type);
 extern int ocfs2_acl_chmod(struct inode *, struct buffer_head *);
 extern int ocfs2_init_acl(handle_t *, struct inode *, struct inode *,
-			  struct buffer_head *, struct buffer_head *,
+			  struct buffer_head *, struct posix_acl *,
 			  struct ocfs2_alloc_context *,
 			  struct ocfs2_alloc_context *);
 
diff --git a/fs/ocfs2/namei.c b/fs/ocfs2/namei.c
index 1277666c7..6bfc2b9ab 100644
--- a/fs/ocfs2/namei.c
+++ b/fs/ocfs2/namei.c
@@ -27,6 +27,7 @@
 #include <linux/highmem.h>
 #include <linux/quotaops.h>
 #include <linux/iversion.h>
+#include <linux/posix_acl.h>
 
 #include <cluster/masklog.h>
 
@@ -256,6 +257,7 @@ static int ocfs2_mknod(struct mnt_idmap *idmap,
 	sigset_t oldset;
 	int did_block_signals = 0;
 	struct ocfs2_dentry_lock *dl = NULL;
+	struct posix_acl *default_acl = NULL;
 
 	trace_ocfs2_mknod(dir, dentry, dentry->d_name.len, dentry->d_name.name,
 			  (unsigned long long)OCFS2_I(dir)->ip_blkno,
@@ -362,6 +364,15 @@ static int ocfs2_mknod(struct mnt_idmap *idmap,
 		goto leave;
 	}
 
+	if (osb->s_mount_opt & OCFS2_MOUNT_POSIX_ACL) {
+		default_acl = get_inode_acl(dir, ACL_TYPE_DEFAULT);
+		if (IS_ERR(default_acl)) {
+			status = PTR_ERR(default_acl);
+			default_acl = NULL;
+			goto leave;
+		}
+	}
+
 	handle = ocfs2_start_trans(osb, ocfs2_mknod_credits(osb->sb,
 							    S_ISDIR(mode),
 							    xattr_credits));
@@ -411,7 +422,7 @@ static int ocfs2_mknod(struct mnt_idmap *idmap,
 		inc_nlink(dir);
 	}
 
-	status = ocfs2_init_acl(handle, inode, dir, new_fe_bh, parent_fe_bh,
+	status = ocfs2_init_acl(handle, inode, dir, new_fe_bh, default_acl,
 			 meta_ac, data_ac);
 
 	if (status < 0) {
@@ -488,6 +499,9 @@ static int ocfs2_mknod(struct mnt_idmap *idmap,
 	if (meta_ac)
 		ocfs2_free_alloc_context(meta_ac);
 
+	if (default_acl)
+		posix_acl_release(default_acl);
+
 	/*
 	 * We should call iput after the i_rwsem of the bitmap been
 	 * unlocked in ocfs2_free_alloc_context, or the
diff --git a/fs/ocfs2/xattr.c b/fs/ocfs2/xattr.c
index fcddd3c13..1b020f33f 100644
--- a/fs/ocfs2/xattr.c
+++ b/fs/ocfs2/xattr.c
@@ -26,6 +26,7 @@
 #include <linux/module.h>
 #include <linux/string.h>
 #include <linux/security.h>
+#include <linux/posix_acl.h>
 
 #include <cluster/masklog.h>
 
@@ -7257,6 +7258,7 @@ int ocfs2_init_security_and_acl(struct inode *dir,
 {
 	int ret = 0;
 	struct buffer_head *dir_bh = NULL;
+	struct posix_acl *default_acl = NULL;
 
 	ret = ocfs2_init_security_get(inode, dir, qstr, NULL);
 	if (ret) {
@@ -7269,10 +7271,23 @@ int ocfs2_init_security_and_acl(struct inode *dir,
 		mlog_errno(ret);
 		goto leave;
 	}
-	ret = ocfs2_init_acl(NULL, inode, dir, NULL, dir_bh, NULL, NULL);
+
+	if (OCFS2_SB(dir->i_sb)->s_mount_opt & OCFS2_MOUNT_POSIX_ACL) {
+		default_acl = get_inode_acl(dir, ACL_TYPE_DEFAULT);
+		if (IS_ERR(default_acl)) {
+			ret = PTR_ERR(default_acl);
+			default_acl = NULL;
+			goto unlock;
+		}
+	}
+
+	ret = ocfs2_init_acl(NULL, inode, dir, NULL, default_acl, NULL, NULL);
 	if (ret)
 		mlog_errno(ret);
 
+	if (default_acl)
+		posix_acl_release(default_acl);
+unlock:
 	ocfs2_inode_unlock(dir, 0);
 	brelse(dir_bh);
 leave:


base-commit: 8d3ae59288f1e7d58d76558a6ee96d533bc5019f
-- 
This is an AI-generated patch subject to moderation.
Reply with '#syz upstream' to Sign-off the patch as a human author
and send it to the upstream kernel mailing lists.
Reply with '#syz reject' to reject it ('#syz unreject' to undo).

See https://goo.gle/syzbot-ai-patches for information about AI-generated patches.
You can comment on the patch as usual, syzbot will try to address
the comments and send a new version of the patch if necessary.
syzbot engineers can be reached at syzkaller@googlegroups.com.
