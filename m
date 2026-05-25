Received: from ewsoutbound.kpnmail.nl (ewsoutbound.kpnmail.nl [195.121.94.186])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B801B340281
	for <syzbot@lists.linux.dev>; Mon, 25 May 2026 10:36:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.121.94.186
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779705400; cv=none; b=cLZ8UIRdcC1Nv9fbG+JohMptHYRhkD03kAl2EED79ssNSfkDbNzhnyp0RvLjwyFjiWyzwfnxPOdsUJDh2aMSh1j3CvaKsW22JWc3goMMT3LXv9ZxGGgwm3srDMWGOLPuYZRsJ0v/Py41vgpgUZQoEBQ/rTZcbj4qP7ZhJHyW454=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779705400; c=relaxed/simple;
	bh=QTLNNwXNpQOOzg3ePKH0mcb/lI7m688mcymFfqFittg=;
	h=Date:From:To:Message-ID:In-Reply-To:References:Subject:
	 MIME-Version:Content-Type; b=gK826hTchwLzUlMYdZOl/JwTSUkJE+CcZiozpqhdkxwjyVp6S+p+HbadBTVxs0KQqVRUCj6GSDys57Y7ALuNxokyjHmh03Zt+7uM8lyS/cgjo8krJ0gFqQ0QRFP7N5zdK1ru+erJprApWm25+kqDnN49kcjf1JKXoPT1hqJe7uQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=xs4all.nl; spf=pass smtp.mailfrom=xs4all.nl; dkim=pass (2048-bit key) header.d=xs4all.nl header.i=@xs4all.nl header.b=BImILR7y; arc=none smtp.client-ip=195.121.94.186
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=xs4all.nl
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=xs4all.nl
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=xs4all.nl header.i=@xs4all.nl header.b="BImILR7y"
X-KPN-MessageId: 71e60ae8-5825-11f1-89f0-00505699b430
Received: from mta.kpnmail.nl (unknown [10.31.161.189])
	by ewsoutbound.so.kpn.org (Halon) with ESMTPS
	id 71e60ae8-5825-11f1-89f0-00505699b430;
	Mon, 25 May 2026 12:35:27 +0200 (CEST)
Received: from mtaoutbound.kpnmail.nl (unknown [10.128.135.190])
	by mta.kpnmail.nl (Halon) with ESMTP
	id 71df94ce-5825-11f1-b5d4-0050569981f5;
	Mon, 25 May 2026 12:35:27 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=xs4all.nl; s=xs4all01;
	h=content-type:mime-version:subject:message-id:to:from:date;
	bh=AgnwNowwWxZg80F73i0j1rj2gZHUEZ08QI5UiykMMek=;
	b=BImILR7ySzsSbC+joO0q0D7uvBhH3UmrQk1m1afGGeq8ViKc5V9mAoRa0Y7/4ddq0z9uwrn2B/GjR
	 JOTRf3VPpORRsWVVDlzXEpYSjkypKXJQTl/9vt84M+jWd3LSCZSA6vCRiS87/Vitn41gI/z7yry0xj
	 2seeW8ky7Uor4oPtgbKefCJrJEX8wFhCnODN6UGhQbv4Okayi2B+M4lfdFmxCzoUvhLlVJp9SPMQVu
	 iZiM52cn16QeYcmlujOYX4hL4lNVtwBa6bifarcAyjv02qjVIGmPn8dZL/fSFjojAA29LyXx7lXCX/
	 x5fXC6YDlt+bp9DnlDtHha4jDjXcg4w==
X-KPN-MID: 33|85o9ZWkcmnkAWEs+ZssfkJb+7svzYroU8wu76TqWHg54/FG2BrF8GJ/G/SasWZX
 tgLCevL1cSJ1A2oQojWqdcW4ht2muPBa4F8BuUXQpKOI=
X-CMASSUN: 33|LdH6sEsbQx6DmyhA15yJ1TlPKAHSZekKfm+XKffubsD8Yyc7hZ3OWGWAWBd6+kD
 7Tw86RO+KWQALXaQD9YYb2Q==
X-KPN-VerifiedSender: Yes
Received: from cpxoxapps-mh06 (cpxoxapps-mh06.personalcloud.so.kpn.org [10.128.135.212])
	by mtaoutbound.kpnmail.nl (Halon) with ESMTPSA
	id 71d4c135-5825-11f1-b8d7-005056995d6c;
	Mon, 25 May 2026 12:35:27 +0200 (CEST)
Date: Mon, 25 May 2026 12:35:27 +0200 (CEST)
From: Jori Koolstra <jkoolstra@xs4all.nl>
To: syzbot ci <syzbot+ci8ee793bb5ffded2a@syzkaller.appspotmail.com>,
	syzbot@lists.linux.dev, syzkaller-bugs@googlegroups.com,
	linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
Message-ID: <1931576426.2416655.1779705327168@kpc.webmail.kpnmail.nl>
In-Reply-To: <6a0c0a3b.050a0220.188d2a.0003.GAE@google.com>
References: <20260518165237.2084042-1-jkoolstra@xs4all.nl>
 <6a0c0a3b.050a0220.188d2a.0003.GAE@google.com>
Subject: Re: [syzbot ci] Re: vfs: add O_CREAT|O_DIRECTORY to open*(2)
Precedence: bulk
X-Mailing-List: syzbot@lists.linux.dev
List-Id: <syzbot.lists.linux.dev>
List-Subscribe: <mailto:syzbot+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:syzbot+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Priority: 3
Importance: Normal

#syz test

---
 fs/namei.c            | 180 ++++++++++++++++++++++++++++--------------
 fs/open.c             |  25 +++---
 include/linux/fcntl.h |   2 +
 3 files changed, 138 insertions(+), 69 deletions(-)

diff --git a/fs/namei.c b/fs/namei.c
index c7fac83c9a85..60223278f9ec 100644
--- a/fs/namei.c
+++ b/fs/namei.c
@@ -2777,9 +2777,14 @@ static const char *path_init(struct nameidata *nd, unsigned flags)
 	return s;
 }
 
+static inline bool trailing_slashes(struct nameidata *nd)
+{
+	return (bool)nd->last.name[nd->last.len];
+}
+
 static inline const char *lookup_last(struct nameidata *nd)
 {
-	if (nd->last_type == LAST_NORM && nd->last.name[nd->last.len])
+	if (nd->last_type == LAST_NORM && trailing_slashes(nd))
 		nd->flags |= LOOKUP_FOLLOW | LOOKUP_DIRECTORY;
 
 	return walk_component(nd, WALK_TRAILING);
@@ -4166,6 +4171,16 @@ static inline umode_t vfs_prepare_mode(struct mnt_idmap *idmap,
 	return mode;
 }
 
+static int __vfs_create(struct mnt_idmap *idmap, struct dentry *dentry, umode_t mode,
+			struct delegated_inode *di, bool excl)
+{
+	struct inode *dir = d_inode(dentry->d_parent);
+	int error = try_break_deleg(dir, di);
+	if (error)
+		return error;
+	return dir->i_op->create(idmap, dir, dentry, mode, excl);
+}
+
 /**
  * vfs_create - create new file
  * @idmap:	idmap of the mount the inode was found from
@@ -4192,16 +4207,14 @@ int vfs_create(struct mnt_idmap *idmap, struct dentry *dentry, umode_t mode,
 		return error;
 
 	if (!dir->i_op->create)
-		return -EACCES;	/* shouldn't it be ENOSYS? */
+		return -EOPNOTSUPP;
 
 	mode = vfs_prepare_mode(idmap, dir, mode, S_IALLUGO, S_IFREG);
 	error = security_inode_create(dir, dentry, mode);
 	if (error)
 		return error;
-	error = try_break_deleg(dir, di);
-	if (error)
-		return error;
-	error = dir->i_op->create(idmap, dir, dentry, mode, true);
+
+	error = __vfs_create(idmap, dentry, mode, di, true);
 	if (!error)
 		fsnotify_create(dir, dentry);
 	return error;
@@ -4321,21 +4334,32 @@ static inline int open_to_namei_flags(int flag)
 
 static int may_o_create(struct mnt_idmap *idmap,
 			const struct path *dir, struct dentry *dentry,
-			umode_t mode)
+			umode_t mode, bool create_dir)
 {
-	int error = security_path_mknod(dir, dentry, mode, 0);
+	struct inode *dir_inode = dir->dentry->d_inode;
+	int error;
+
+	error = create_dir ? security_path_mkdir(dir, dentry, mode)
+			   : security_path_mknod(dir, dentry, mode, 0);
 	if (error)
 		return error;
 
 	if (!fsuidgid_has_mapping(dir->dentry->d_sb, idmap))
 		return -EOVERFLOW;
 
-	error = inode_permission(idmap, dir->dentry->d_inode,
-				 MAY_WRITE | MAY_EXEC);
+	error = inode_permission(idmap, dir_inode, MAY_WRITE | MAY_EXEC);
 	if (error)
 		return error;
 
-	return security_inode_create(dir->dentry->d_inode, dentry, mode);
+	return create_dir ? security_inode_mkdir(dir_inode, dentry, mode)
+			  : security_inode_create(dir_inode, dentry, mode);
+}
+
+static inline umode_t o_create_mode(struct mnt_idmap *idmap,
+		const struct inode *dir, umode_t mode, bool create_dir)
+{
+	return create_dir ? vfs_prepare_mode(idmap, dir, mode, S_IRWXUGO | S_ISVTX, 0)
+			  : vfs_prepare_mode(idmap, dir, mode, S_IALLUGO, S_IFREG);
 }
 
 /*
@@ -4359,6 +4383,11 @@ static struct dentry *atomic_open(const struct path *path, struct dentry *dentry
 	struct inode *dir =  path->dentry->d_inode;
 	int error;
 
+	if ((open_flag & O_MKDIR_MASK) == O_MKDIR_MASK) {
+		error = -EOPNOTSUPP;
+		goto out;
+	}
+
 	file->__f_path.dentry = DENTRY_NOT_SET;
 	file->__f_path.mnt = path->mnt;
 	error = dir->i_op->atomic_open(dir, dentry, file,
@@ -4381,6 +4410,7 @@ static struct dentry *atomic_open(const struct path *path, struct dentry *dentry
 				error = -ENOENT;
 		}
 	}
+out:
 	if (error) {
 		dput(dentry);
 		dentry = ERR_PTR(error);
@@ -4388,6 +4418,9 @@ static struct dentry *atomic_open(const struct path *path, struct dentry *dentry
 	return dentry;
 }
 
+static struct dentry *__vfs_mkdir(struct mnt_idmap *, struct inode *,
+			 struct dentry *, umode_t,
+			 struct delegated_inode *);
 /*
  * Look up and maybe create and open the last component.
  *
@@ -4412,8 +4445,9 @@ static struct dentry *lookup_open(struct nameidata *nd, struct file *file,
 	struct inode *dir_inode = dir->d_inode;
 	int open_flag = op->open_flag;
 	struct dentry *dentry;
-	int error, create_error = 0;
+	int error = 0, create_error = 0;
 	umode_t mode = op->mode;
+	bool create_dir = (open_flag & O_MKDIR_MASK) == O_MKDIR_MASK;
 	DECLARE_WAIT_QUEUE_HEAD_ONSTACK(wq);
 
 	if (unlikely(IS_DEADDIR(dir_inode)))
@@ -4462,10 +4496,10 @@ static struct dentry *lookup_open(struct nameidata *nd, struct file *file,
 	if (open_flag & O_CREAT) {
 		if (open_flag & O_EXCL)
 			open_flag &= ~O_TRUNC;
-		mode = vfs_prepare_mode(idmap, dir->d_inode, mode, mode, mode);
+		mode = o_create_mode(idmap, dir_inode, mode, create_dir);
 		if (likely(got_write))
 			create_error = may_o_create(idmap, &nd->path,
-						    dentry, mode);
+						    dentry, mode, create_dir);
 		else
 			create_error = -EROFS;
 	}
@@ -4494,29 +4528,37 @@ static struct dentry *lookup_open(struct nameidata *nd, struct file *file,
 		}
 	}
 
+	if (unlikely(create_error) && !dentry->d_inode) {
+		error = create_error;
+		goto out_dput;
+	}
+
 	/* Negative dentry, just create the file */
 	if (!dentry->d_inode && (open_flag & O_CREAT)) {
-		/* but break the directory lease first! */
-		error = try_break_deleg(dir_inode, delegated_inode);
-		if (error)
-			goto out_dput;
 
 		file->f_mode |= FMODE_CREATED;
 		audit_inode_child(dir_inode, dentry, AUDIT_TYPE_CHILD_CREATE);
-		if (!dir_inode->i_op->create) {
-			error = -EACCES;
+		if ((create_dir && !dir_inode->i_op->mkdir)
+		    || (!create_dir && !dir_inode->i_op->create)) {
+			error = -EOPNOTSUPP;
 			goto out_dput;
 		}
 
-		error = dir_inode->i_op->create(idmap, dir_inode, dentry,
-						mode, open_flag & O_EXCL);
+		if (create_dir) {
+			struct dentry *res = __vfs_mkdir(idmap, dir_inode, dentry, mode,
+							 delegated_inode);
+			if (IS_ERR(res))
+				error = PTR_ERR(res);
+			else
+				dentry = res;
+		} else {
+			error = __vfs_create(idmap, dentry, mode, delegated_inode,
+					     open_flag & O_EXCL);
+		}
 		if (error)
 			goto out_dput;
 	}
-	if (unlikely(create_error) && !dentry->d_inode) {
-		error = create_error;
-		goto out_dput;
-	}
+
 	return dentry;
 
 out_dput:
@@ -4524,17 +4566,12 @@ static struct dentry *lookup_open(struct nameidata *nd, struct file *file,
 	return ERR_PTR(error);
 }
 
-static inline bool trailing_slashes(struct nameidata *nd)
-{
-	return (bool)nd->last.name[nd->last.len];
-}
-
 static struct dentry *lookup_fast_for_open(struct nameidata *nd, int open_flag)
 {
 	struct dentry *dentry;
 
 	if (open_flag & O_CREAT) {
-		if (trailing_slashes(nd))
+		if (trailing_slashes(nd) && !(open_flag & O_DIRECTORY))
 			return ERR_PTR(-EISDIR);
 
 		/* Don't bother on an O_EXCL create */
@@ -4610,8 +4647,12 @@ static const char *open_last_lookups(struct nameidata *nd,
 		inode_lock_shared(dir->d_inode);
 	dentry = lookup_open(nd, file, op, got_write, &delegated_inode);
 	if (!IS_ERR(dentry)) {
-		if (file->f_mode & FMODE_CREATED)
-			fsnotify_create(dir->d_inode, dentry);
+		if (file->f_mode & FMODE_CREATED) {
+			if (open_flag & O_DIRECTORY)
+				fsnotify_mkdir(dir->d_inode, dentry);
+			else
+				fsnotify_create(dir->d_inode, dentry);
+		}
 		if (file->f_mode & FMODE_OPENED)
 			fsnotify_open(file);
 	}
@@ -4672,12 +4713,15 @@ static int do_open(struct nameidata *nd,
 	if (open_flag & O_CREAT) {
 		if ((open_flag & O_EXCL) && !(file->f_mode & FMODE_CREATED))
 			return -EEXIST;
-		if (d_is_dir(nd->path.dentry))
-			return -EISDIR;
-		error = may_create_in_sticky(idmap, nd,
-					     d_backing_inode(nd->path.dentry));
-		if (unlikely(error))
-			return error;
+		if (!(open_flag & O_DIRECTORY)) {
+			if (d_is_dir(nd->path.dentry))
+				return -EISDIR;
+
+			error = may_create_in_sticky(idmap, nd,
+						     d_backing_inode(nd->path.dentry));
+			if (unlikely(error))
+				return error;
+		}
 	}
 	if ((nd->flags & LOOKUP_DIRECTORY) && !d_can_lookup(nd->path.dentry))
 		return -ENOTDIR;
@@ -5039,7 +5083,7 @@ struct file *dentry_create(struct path *path, int flags, umode_t mode,
 		path->dentry = dir;
 		mode = vfs_prepare_mode(idmap, dir_inode, mode, S_IALLUGO, S_IFREG);
 
-		create_error = may_o_create(idmap, path, dentry, mode);
+		create_error = may_o_create(idmap, path, dentry, mode, false);
 		if (create_error)
 			flags &= ~O_CREAT;
 
@@ -5207,6 +5251,37 @@ SYSCALL_DEFINE3(mknod, const char __user *, filename, umode_t, mode, unsigned, d
 	return filename_mknodat(AT_FDCWD, name, mode, dev);
 }
 
+static struct dentry *__vfs_mkdir(struct mnt_idmap *idmap, struct inode *dir,
+			 struct dentry *dentry, umode_t mode,
+			 struct delegated_inode *di)
+{
+	int error;
+	unsigned max_links = dir->i_sb->s_max_links;
+	struct dentry *de;
+
+	error = -EMLINK;
+	if (max_links && dir->i_nlink >= max_links)
+		goto err;
+
+	error = try_break_deleg(dir, di);
+	if (error)
+		goto err;
+
+	de = dir->i_op->mkdir(idmap, dir, dentry, mode);
+	if (IS_ERR(de)) {
+		error = PTR_ERR(de);
+		goto err;
+	}
+	if (de) {
+		dput(dentry);
+		dentry = de;
+	}
+	return dentry;
+
+err:
+	return ERR_PTR(error);
+}
+
 /**
  * vfs_mkdir - create directory returning correct dentry if possible
  * @idmap:		idmap of the mount the inode was found from
@@ -5231,17 +5306,16 @@ SYSCALL_DEFINE3(mknod, const char __user *, filename, umode_t, mode, unsigned, d
  */
 struct dentry *vfs_mkdir(struct mnt_idmap *idmap, struct inode *dir,
 			 struct dentry *dentry, umode_t mode,
-			 struct delegated_inode *delegated_inode)
+			 struct delegated_inode *di)
 {
 	int error;
-	unsigned max_links = dir->i_sb->s_max_links;
 	struct dentry *de;
 
 	error = may_create_dentry(idmap, dir, dentry);
 	if (error)
 		goto err;
 
-	error = -EPERM;
+	error = -EOPNOTSUPP;
 	if (!dir->i_op->mkdir)
 		goto err;
 
@@ -5250,22 +5324,12 @@ struct dentry *vfs_mkdir(struct mnt_idmap *idmap, struct inode *dir,
 	if (error)
 		goto err;
 
-	error = -EMLINK;
-	if (max_links && dir->i_nlink >= max_links)
-		goto err;
-
-	error = try_break_deleg(dir, delegated_inode);
-	if (error)
+	de = __vfs_mkdir(idmap, dir, dentry, mode, di);
+	if (IS_ERR(de)) {
+		error = PTR_ERR(de);
 		goto err;
-
-	de = dir->i_op->mkdir(idmap, dir, dentry, mode);
-	error = PTR_ERR(de);
-	if (IS_ERR(de))
-		goto err;
-	if (de) {
-		dput(dentry);
-		dentry = de;
 	}
+	dentry = de;
 	fsnotify_mkdir(dir, dentry);
 	return dentry;
 
diff --git a/fs/open.c b/fs/open.c
index 681d405bc61e..865ea6f70e8c 100644
--- a/fs/open.c
+++ b/fs/open.c
@@ -1209,29 +1209,30 @@ inline int build_open_flags(const struct open_how *how, struct open_flags *op)
 	if (WILL_CREATE(flags)) {
 		if (how->mode & ~S_IALLUGO)
 			return -EINVAL;
-		op->mode = how->mode | S_IFREG;
+		if ((flags & (O_MKDIR_MASK)) == O_MKDIR_MASK)
+			op->mode = how->mode | S_IFDIR;
+		else
+			op->mode = how->mode | S_IFREG;
 	} else {
 		if (how->mode != 0)
 			return -EINVAL;
 		op->mode = 0;
 	}
 
-	/*
-	 * Block bugs where O_DIRECTORY | O_CREAT created regular files.
-	 * Note, that blocking O_DIRECTORY | O_CREAT here also protects
-	 * O_TMPFILE below which requires O_DIRECTORY being raised.
-	 */
-	if ((flags & (O_DIRECTORY | O_CREAT)) == (O_DIRECTORY | O_CREAT))
-		return -EINVAL;
-
 	/* Now handle the creative implementation of O_TMPFILE. */
 	if (flags & __O_TMPFILE) {
 		/*
 		 * In order to ensure programs get explicit errors when trying
 		 * to use O_TMPFILE on old kernels we enforce that O_DIRECTORY
-		 * is raised alongside __O_TMPFILE.
+		 * is raised alongside __O_TMPFILE, but without O_CREAT. The
+		 * reason for disallowing O_CREAT|O_TMPFILE is that
+		 * O_DIRECTORY|O_CREAT used to work and created a regular file
+		 * if nothing existed at the open path. Hence, allowing the
+		 * combination would have caused O_CREAT|O_TMPFILE to create a
+		 * regular (non-temporary) file on old kernels, while the caller
+		 * would believe they created an actual O_TMPFILE.
 		 */
-		if (!(flags & O_DIRECTORY))
+		if (!(flags & O_DIRECTORY) || (flags & O_CREAT))
 			return -EINVAL;
 		if (!(acc_mode & MAY_WRITE))
 			return -EINVAL;
@@ -1268,6 +1269,8 @@ inline int build_open_flags(const struct open_how *how, struct open_flags *op)
 	op->intent = flags & O_PATH ? 0 : LOOKUP_OPEN;
 
 	if (flags & O_CREAT) {
+		if ((flags & O_DIRECTORY) && (acc_mode & MAY_WRITE))
+			return -EISDIR;
 		op->intent |= LOOKUP_CREATE;
 		if (flags & O_EXCL) {
 			op->intent |= LOOKUP_EXCL;
diff --git a/include/linux/fcntl.h b/include/linux/fcntl.h
index a332e79b3207..e31f3a57f07c 100644
--- a/include/linux/fcntl.h
+++ b/include/linux/fcntl.h
@@ -12,6 +12,8 @@
 	 FASYNC	| O_DIRECT | O_LARGEFILE | O_DIRECTORY | O_NOFOLLOW | \
 	 O_NOATIME | O_CLOEXEC | O_PATH | __O_TMPFILE)
 
+#define O_MKDIR_MASK	(O_CREAT | O_DIRECTORY)
+
 /* List of all valid flags for the how->resolve argument: */
 #define VALID_RESOLVE_FLAGS \
 	(RESOLVE_NO_XDEV | RESOLVE_NO_MAGICLINKS | RESOLVE_NO_SYMLINKS | \
-- 
2.54.0


> Op 19-05-2026 08:59 CEST schreef syzbot ci <syzbot+ci8ee793bb5ffded2a@syzkaller.appspotmail.com>:
> 
>  
> syzbot ci has tested the following series
> 
> [v4] vfs: add O_CREAT|O_DIRECTORY to open*(2)
> https://lore.kernel.org/all/20260518165237.2084042-1-jkoolstra@xs4all.nl
> * [RFC PATCH v4 1/2] vfs: add O_CREAT|O_DIRECTORY to open*(2)
> * [RFC PATCH v4 2/2] selftest: add tests for open*(O_CREAT|O_DIRECTORY)
> 
> and found the following issues:
> * KASAN: slab-out-of-bounds Read in ovl_dir_release
> * general protection fault in path_openat
> 
> Full report is available here:
> https://ci.syzbot.org/series/0d511b6b-6434-45cd-bbf3-51fe9d916e99
> 
> ***
> 
> KASAN: slab-out-of-bounds Read in ovl_dir_release
> 
> tree:      torvalds
> URL:       https://kernel.googlesource.com/pub/scm/linux/kernel/git/torvalds/linux
> base:      5200f5f493f79f14bbdc349e402a40dfb32f23c8
> arch:      amd64
> compiler:  Debian clang version 21.1.8 (++20251221033036+2078da43e25a-1~exp1~20251221153213.50), Debian LLD 21.1.8
> config:    https://ci.syzbot.org/builds/024b677f-50e7-4ef9-ae98-2652f5098bfd/config
> syz repro: https://ci.syzbot.org/findings/a7087360-137c-41f5-ae13-db4d551fe142/syz_repro
> 
> ==================================================================
> BUG: KASAN: slab-out-of-bounds in ovl_dir_release+0x228/0x2a0 fs/overlayfs/readdir.c:1033
> Read of size 8 at addr ffff88816cd2c818 by task syz.0.17/5813
> 
> CPU: 0 UID: 0 PID: 5813 Comm: syz.0.17 Not tainted syzkaller #0 PREEMPT(full) 
> Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS 1.16.2-debian-1.16.2-1 04/01/2014
> Call Trace:
>  <TASK>
>  dump_stack_lvl+0xe8/0x150 lib/dump_stack.c:120
>  print_address_description+0x55/0x1e0 mm/kasan/report.c:378
>  print_report+0x58/0x70 mm/kasan/report.c:482
>  kasan_report+0x117/0x150 mm/kasan/report.c:595
>  ovl_dir_release+0x228/0x2a0 fs/overlayfs/readdir.c:1033
>  __fput+0x44f/0xa60 fs/file_table.c:510
>  task_work_run+0x1d9/0x270 kernel/task_work.c:233
>  resume_user_mode_work include/linux/resume_user_mode.h:50 [inline]
>  __exit_to_user_mode_loop kernel/entry/common.c:67 [inline]
>  exit_to_user_mode_loop+0xf3/0x4d0 kernel/entry/common.c:98
>  __exit_to_user_mode_prepare include/linux/irq-entry-common.h:207 [inline]
>  syscall_exit_to_user_mode_prepare include/linux/irq-entry-common.h:230 [inline]
>  syscall_exit_to_user_mode include/linux/entry-common.h:318 [inline]
>  do_syscall_64+0x33e/0xf80 arch/x86/entry/syscall_64.c:100
>  entry_SYSCALL_64_after_hwframe+0x77/0x7f
> RIP: 0033:0x7fe1a159ce59
> Code: ff c3 66 2e 0f 1f 84 00 00 00 00 00 0f 1f 44 00 00 48 89 f8 48 89 f7 48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 ff ff 73 01 c3 48 c7 c1 e8 ff ff ff f7 d8 64 89 01 48
> RSP: 002b:00007ffe25af07f8 EFLAGS: 00000246 ORIG_RAX: 00000000000001b4
> RAX: 0000000000000000 RBX: 00007ffe25af08e0 RCX: 00007fe1a159ce59
> RDX: 0000000000000000 RSI: 000000000000001e RDI: 0000000000000003
> RBP: 0000000000012e15 R08: 0000000000000001 R09: 0000000000000000
> R10: 0000001b32a20000 R11: 0000000000000246 R12: 00007ffe25af0920
> R13: 00007fe1a1815fac R14: 0000000000012e53 R15: 00007fe1a1815fa0
>  </TASK>
> 
> Allocated by task 5814:
>  kasan_save_stack mm/kasan/common.c:57 [inline]
>  kasan_save_track+0x3e/0x80 mm/kasan/common.c:78
>  poison_kmalloc_redzone mm/kasan/common.c:398 [inline]
>  __kasan_kmalloc+0x93/0xb0 mm/kasan/common.c:415
>  kasan_kmalloc include/linux/kasan.h:263 [inline]
>  __kmalloc_cache_noprof+0x31c/0x660 mm/slub.c:5419
>  kmalloc_noprof include/linux/slab.h:950 [inline]
>  kzalloc_noprof include/linux/slab.h:1188 [inline]
>  ovl_file_alloc+0x4f/0x90 fs/overlayfs/file.c:99
>  ovl_create_tmpfile fs/overlayfs/dir.c:1399 [inline]
>  ovl_tmpfile+0x3fc/0x7d0 fs/overlayfs/dir.c:1448
>  vfs_tmpfile+0x3ff/0x890 fs/namei.c:4794
>  do_tmpfile+0xd3/0x240 fs/namei.c:4859
>  path_openat+0x33c7/0x3b40 fs/namei.c:4893
>  do_file_open+0x23e/0x4a0 fs/namei.c:4931
>  do_sys_openat2+0x113/0x200 fs/open.c:1367
>  do_sys_open fs/open.c:1373 [inline]
>  __do_sys_open fs/open.c:1381 [inline]
>  __se_sys_open fs/open.c:1377 [inline]
>  __x64_sys_open+0x11e/0x150 fs/open.c:1377
>  do_syscall_x64 arch/x86/entry/syscall_64.c:63 [inline]
>  do_syscall_64+0x15f/0xf80 arch/x86/entry/syscall_64.c:94
>  entry_SYSCALL_64_after_hwframe+0x77/0x7f
> 
> The buggy address belongs to the object at ffff88816cd2c800
>  which belongs to the cache kmalloc-16 of size 16
> The buggy address is located 8 bytes to the right of
>  allocated 16-byte region [ffff88816cd2c800, ffff88816cd2c810)
> 
> The buggy address belongs to the physical page:
> page: refcount:0 mapcount:0 mapping:0000000000000000 index:0xffff88816cd2c840 pfn:0x16cd2c
> flags: 0x57ff00000000200(workingset|node=1|zone=2|lastcpupid=0x7ff)
> page_type: f5(slab)
> raw: 057ff00000000200 ffff888100041640 ffff888160400408 ffff888160400408
> raw: ffff88816cd2c840 0000000800800042 00000000f5000000 0000000000000000
> page dumped because: kasan: bad access detected
> page_owner tracks the page as allocated
> page last allocated via order 0, migratetype Unmovable, gfp_mask 0x252800(GFP_NOWAIT|__GFP_NORETRY|__GFP_COMP|__GFP_THISNODE), pid 5741, tgid 5741 (syz-executor), ts 77437404410, free_ts 77431264562
>  set_page_owner include/linux/page_owner.h:32 [inline]
>  post_alloc_hook+0x231/0x280 mm/page_alloc.c:1858
>  prep_new_page mm/page_alloc.c:1866 [inline]
>  get_page_from_freelist+0x24ba/0x2540 mm/page_alloc.c:3946
>  __alloc_frozen_pages_noprof+0x18d/0x380 mm/page_alloc.c:5226
>  alloc_slab_page mm/slub.c:3278 [inline]
>  allocate_slab+0x77/0x660 mm/slub.c:3467
>  new_slab mm/slub.c:3525 [inline]
>  ___slab_alloc+0x154/0x6c0 mm/slub.c:4444
>  __slab_alloc_node mm/slub.c:4510 [inline]
>  slab_alloc_node mm/slub.c:4886 [inline]
>  __do_kmalloc_node mm/slub.c:5294 [inline]
>  __kvmalloc_node_noprof+0x34d/0x8a0 mm/slub.c:6832
>  xt_jumpstack_alloc net/netfilter/x_tables.c:1449 [inline]
>  do_replace_table+0x191/0x620 net/netfilter/x_tables.c:1486
>  xt_register_table+0x269/0x960 net/netfilter/x_tables.c:1596
>  ip6t_register_table+0x16b/0x330 net/ipv6/netfilter/ip6_tables.c:1754
>  ip6table_raw_table_init+0x54/0x80 net/ipv6/netfilter/ip6table_raw.c:48
>  xt_find_table_lock+0x30c/0x3f0 net/netfilter/x_tables.c:1353
>  xt_request_find_table_lock+0x26/0x100 net/netfilter/x_tables.c:1378
>  get_info net/ipv6/netfilter/ip6_tables.c:979 [inline]
>  do_ip6t_get_ctl+0x716/0x1230 net/ipv6/netfilter/ip6_tables.c:1668
>  nf_getsockopt+0x26e/0x290 net/netfilter/nf_sockopt.c:116
>  ipv6_getsockopt+0x1fd/0x2b0 net/ipv6/ipv6_sockglue.c:1464
>  do_sock_getsockopt+0x51d/0x7e0 net/socket.c:2487
> page last free pid 15 tgid 15 stack trace:
>  reset_page_owner include/linux/page_owner.h:25 [inline]
>  __free_pages_prepare mm/page_alloc.c:1402 [inline]
>  __free_frozen_pages+0xbc7/0xd30 mm/page_alloc.c:2943
>  rcu_do_batch kernel/rcu/tree.c:2617 [inline]
>  rcu_core+0x7cd/0x1070 kernel/rcu/tree.c:2869
>  handle_softirqs+0x22a/0x840 kernel/softirq.c:622
>  run_ksoftirqd+0x36/0x60 kernel/softirq.c:1076
>  smpboot_thread_fn+0x541/0xa50 kernel/smpboot.c:160
>  kthread+0x389/0x470 kernel/kthread.c:436
>  ret_from_fork+0x514/0xb70 arch/x86/kernel/process.c:158
>  ret_from_fork_asm+0x1a/0x30 arch/x86/entry/entry_64.S:245
> 
> Memory state around the buggy address:
>  ffff88816cd2c700: fc fc fc fc fc fc fc fc fc fc fc fc fc fc fc fc
>  ffff88816cd2c780: fc fc fc fc fc fc fc fc fc fc fc fc fc fc fc fc
> >ffff88816cd2c800: 00 00 fc fc 00 00 fc fc fc fc fc fc fc fc fc fc
>                             ^
>  ffff88816cd2c880: fc fc fc fc fc fc fc fc fc fc fc fc fc fc fc fc
>  ffff88816cd2c900: fc fc fc fc fc fc fc fc fc fc fc fc fc fc fc fc
> ==================================================================
> 
> 
> ***
> 
> general protection fault in path_openat
> 
> tree:      torvalds
> URL:       https://kernel.googlesource.com/pub/scm/linux/kernel/git/torvalds/linux
> base:      5200f5f493f79f14bbdc349e402a40dfb32f23c8
> arch:      amd64
> compiler:  Debian clang version 21.1.8 (++20251221033036+2078da43e25a-1~exp1~20251221153213.50), Debian LLD 21.1.8
> config:    https://ci.syzbot.org/builds/024b677f-50e7-4ef9-ae98-2652f5098bfd/config
> syz repro: https://ci.syzbot.org/findings/4b3b0fe3-064c-43e2-b887-b3a52d87a16a/syz_repro
> 
> BTRFS info (device loop1): enabling ssd optimizations
> BTRFS info (device loop1): turning on async discard
> BTRFS info (device loop1): enabling free space tree
> BTRFS info (device loop1): use zstd compression, level 3
> Oops: general protection fault, probably for non-canonical address 0xdffffc0000000000: 0000 [#1] SMP KASAN PTI
> KASAN: null-ptr-deref in range [0x0000000000000000-0x0000000000000007]
> CPU: 1 UID: 0 PID: 5849 Comm: syz.1.18 Not tainted syzkaller #0 PREEMPT(full) 
> Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS 1.16.2-debian-1.16.2-1 04/01/2014
> RIP: 0010:__d_entry_type include/linux/dcache.h:429 [inline]
> RIP: 0010:d_can_lookup include/linux/dcache.h:444 [inline]
> RIP: 0010:do_open fs/namei.c:4726 [inline]
> RIP: 0010:path_openat+0x2e66/0x3b40 fs/namei.c:4902
> Code: e8 8f 49 7f ff eb 62 48 8b 44 24 78 42 80 3c 20 00 48 8b 5c 24 68 74 08 48 89 df e8 44 87 ea ff 4c 8b 3b 4c 89 f8 48 c1 e8 03 <42> 0f b6 04 20 84 c0 0f 85 cb 09 00 00 41 bc 00 00 38 00 45 23 27
> RSP: 0018:ffffc9000405f960 EFLAGS: 00010246
> RAX: 0000000000000000 RBX: ffffc9000405fc28 RCX: 0000000000000000
> RDX: ffff88810fe50000 RSI: 0000000000000002 RDI: 0000000000000000
> RBP: ffffc9000405fbb0 R08: ffff8881b949469b R09: 1ffff110372928d3
> R10: dffffc0000000000 R11: ffffed10372928d4 R12: dffffc0000000000
> R13: 1ffff1102eb65c88 R14: 000000000015d0c0 R15: 0000000000000001
> FS:  00007f074937f6c0(0000) GS:ffff8882a928a000(0000) knlGS:0000000000000000
> CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> CR2: 00000c2113360000 CR3: 0000000103f3a000 CR4: 00000000000006f0
> Call Trace:
>  <TASK>
>  do_file_open+0x23e/0x4a0 fs/namei.c:4931
>  do_sys_openat2+0x113/0x200 fs/open.c:1367
>  do_sys_open fs/open.c:1373 [inline]
>  __do_sys_openat fs/open.c:1389 [inline]
>  __se_sys_openat fs/open.c:1384 [inline]
>  __x64_sys_openat+0x138/0x170 fs/open.c:1384
>  do_syscall_x64 arch/x86/entry/syscall_64.c:63 [inline]
>  do_syscall_64+0x15f/0xf80 arch/x86/entry/syscall_64.c:94
>  entry_SYSCALL_64_after_hwframe+0x77/0x7f
> RIP: 0033:0x7f074859ce59
> Code: ff c3 66 2e 0f 1f 84 00 00 00 00 00 0f 1f 44 00 00 48 89 f8 48 89 f7 48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 ff ff 73 01 c3 48 c7 c1 e8 ff ff ff f7 d8 64 89 01 48
> RSP: 002b:00007f074937f028 EFLAGS: 00000246 ORIG_RAX: 0000000000000101
> RAX: ffffffffffffffda RBX: 00007f0748815fa0 RCX: 00007f074859ce59
> RDX: 00000000001dd0c0 RSI: 0000200000000240 RDI: ffffffffffffff9c
> RBP: 00007f0748632d6f R08: 0000000000000000 R09: 0000000000000000
> R10: 0000000000000000 R11: 0000000000000246 R12: 0000000000000000
> R13: 00007f0748816038 R14: 00007f0748815fa0 R15: 00007fff34fee548
>  </TASK>
> Modules linked in:
> ---[ end trace 0000000000000000 ]---
> RIP: 0010:__d_entry_type include/linux/dcache.h:429 [inline]
> RIP: 0010:d_can_lookup include/linux/dcache.h:444 [inline]
> RIP: 0010:do_open fs/namei.c:4726 [inline]
> RIP: 0010:path_openat+0x2e66/0x3b40 fs/namei.c:4902
> Code: e8 8f 49 7f ff eb 62 48 8b 44 24 78 42 80 3c 20 00 48 8b 5c 24 68 74 08 48 89 df e8 44 87 ea ff 4c 8b 3b 4c 89 f8 48 c1 e8 03 <42> 0f b6 04 20 84 c0 0f 85 cb 09 00 00 41 bc 00 00 38 00 45 23 27
> RSP: 0018:ffffc9000405f960 EFLAGS: 00010246
> RAX: 0000000000000000 RBX: ffffc9000405fc28 RCX: 0000000000000000
> RDX: ffff88810fe50000 RSI: 0000000000000002 RDI: 0000000000000000
> RBP: ffffc9000405fbb0 R08: ffff8881b949469b R09: 1ffff110372928d3
> R10: dffffc0000000000 R11: ffffed10372928d4 R12: dffffc0000000000
> R13: 1ffff1102eb65c88 R14: 000000000015d0c0 R15: 0000000000000001
> FS:  00007f074937f6c0(0000) GS:ffff8882a928a000(0000) knlGS:0000000000000000
> CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> CR2: 00007f1c7a2f73b0 CR3: 0000000103f3a000 CR4: 00000000000006f0
> ----------------
> Code disassembly (best guess):
>    0:	e8 8f 49 7f ff       	call   0xff7f4994
>    5:	eb 62                	jmp    0x69
>    7:	48 8b 44 24 78       	mov    0x78(%rsp),%rax
>    c:	42 80 3c 20 00       	cmpb   $0x0,(%rax,%r12,1)
>   11:	48 8b 5c 24 68       	mov    0x68(%rsp),%rbx
>   16:	74 08                	je     0x20
>   18:	48 89 df             	mov    %rbx,%rdi
>   1b:	e8 44 87 ea ff       	call   0xffea8764
>   20:	4c 8b 3b             	mov    (%rbx),%r15
>   23:	4c 89 f8             	mov    %r15,%rax
>   26:	48 c1 e8 03          	shr    $0x3,%rax
> * 2a:	42 0f b6 04 20       	movzbl (%rax,%r12,1),%eax <-- trapping instruction
>   2f:	84 c0                	test   %al,%al
>   31:	0f 85 cb 09 00 00    	jne    0xa02
>   37:	41 bc 00 00 38 00    	mov    $0x380000,%r12d
>   3d:	45 23 27             	and    (%r15),%r12d
> 
> 
> ***
> 
> If these findings have caused you to resend the series or submit a
> separate fix, please add the following tag to your commit message:
>   Tested-by: syzbot@syzkaller.appspotmail.com
> 
> ---
> This report is generated by a bot. It may contain errors.
> syzbot ci engineers can be reached at syzkaller@googlegroups.com.
> 
> To test a patch for this bug, please reply with `#syz test`
> (should be on a separate line).
> 
> The patch should be attached to the email.
> Note: arguments like custom git repos and branches are not supported.
