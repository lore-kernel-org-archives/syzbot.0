Received: from ewsoutbound.kpnmail.nl (ewsoutbound.kpnmail.nl [195.121.94.183])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4953A219301
	for <syzbot@lists.linux.dev>; Mon, 25 May 2026 18:30:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.121.94.183
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779733836; cv=none; b=U3c9b0lHO8V1P3IuezH0e75sMr4u7mvdeHn93nvXaTpkaz6qhV6PpRSUJJDO18HbRqxAb8pwf2pNc9W75fqtI1vepUlUD9viWe4Ggp893D+3jarRgP1/sv67NGcBc1jbjstP5xq98DBfGD5lxQ60hTyeiacE7FNGNFID0C9RjTY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779733836; c=relaxed/simple;
	bh=caQBy2lOo/M4+/HvEP630Xu1Ts8OsHi0Hj8NomnKPKU=;
	h=Date:From:To:Message-ID:In-Reply-To:References:Subject:
	 MIME-Version:Content-Type; b=kcFXxKeETTkQwscAQJqOx3sSVSm+jdJNm0YWURG/+7xfgRUlQNnEK8ku4k88hy8wJTHZqRpbf4kK9Yn3kfPBS/+NvMAuY/NvEFUSVLP4qKJiDV8aLM9r/ZJlLDFkkZFgiRBM0FujTZulBOfSGyhyFboNoAv8N53QSzBkEO/9e5k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=xs4all.nl; spf=pass smtp.mailfrom=xs4all.nl; dkim=pass (2048-bit key) header.d=xs4all.nl header.i=@xs4all.nl header.b=FxhkqSIi; arc=none smtp.client-ip=195.121.94.183
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=xs4all.nl
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=xs4all.nl
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=xs4all.nl header.i=@xs4all.nl header.b="FxhkqSIi"
X-KPN-MessageId: cee9b176-5867-11f1-bea8-005056992ed3
Received: from mta.kpnmail.nl (unknown [10.31.161.188])
	by ewsoutbound.so.kpn.org (Halon) with ESMTPS
	id cee9b176-5867-11f1-bea8-005056992ed3;
	Mon, 25 May 2026 20:30:30 +0200 (CEST)
Received: from mtaoutbound.kpnmail.nl (unknown [10.128.135.189])
	by mta.kpnmail.nl (Halon) with ESMTP
	id cee8c180-5867-11f1-8102-00505699693e;
	Mon, 25 May 2026 20:30:30 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=xs4all.nl; s=xs4all01;
	h=content-type:mime-version:subject:message-id:to:from:date;
	bh=kV+LGJM16+g2VG4902T+UWj42eJcynuMz4xG2Y0L9NA=;
	b=FxhkqSIifJ2jDtvxve4pxkSzjjKxKlSEvBRkMCO3E6K+99751SZ6b9VM9W4ojLl+s1a5y8R11nTM9
	 u6WZ6KVaz0iRB1wNGUUozArLO3aogDBsi1izUqMXjtKdQh6B/7gqP9Gt3hMHhuLf7313UumSDZwghi
	 NFTijmuSj/+PemFL0/MuuzusYpgbMvvhX91H10iTyj00YXZcdi+cBP8pbgZ2j0d3CrJ3j18FJ9wK2+
	 eoMyPVsKaALmvMaWjdbPhFQAMaaT0CK8Z76pieYcJY7wisX46HVHGydKku8DkTSC0fE4BQpHnFBq9D
	 /m3sdlUXBLLZiyh/GBJInIxeAOSnqjA==
X-KPN-MID: 33|4JkzSjkG57lfVAXDRVlvA93wZgva/QX/I5uGuGJHhV5deWtBzBuSqmj6Q3s4JUr
 CCCJD0mQZGX0oXWbMUaNtNLg0CIZ2GtsTfQD5BdqTnAY=
X-CMASSUN: 33|UhAYRdQgAtIU6OENYNBDHTvvYA00Drx0n2IyRA77uQQ2Mft05OWuuRvYLNCwThd
 SisPkttHZ/koyPOzEjFCtKA==
X-KPN-VerifiedSender: Yes
Received: from cpxoxapps-mh01 (cpxoxapps-mh01.personalcloud.so.kpn.org [10.128.135.207])
	by mtaoutbound.kpnmail.nl (Halon) with ESMTPSA
	id cedd2aa3-5867-11f1-94b1-00505699eff2;
	Mon, 25 May 2026 20:30:30 +0200 (CEST)
Date: Mon, 25 May 2026 20:30:30 +0200 (CEST)
From: Jori Koolstra <jkoolstra@xs4all.nl>
To: syzbot ci <syzbot+ci8ee793bb5ffded2a@syzkaller.appspotmail.com>,
	linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
	syzbot@lists.linux.dev, syzkaller-bugs@googlegroups.com
Message-ID: <1099786842.2498324.1779733830064@kpc.webmail.kpnmail.nl>
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

diff --git a/fs/9p/vfs_inode.c b/fs/9p/vfs_inode.c
index f468acb8ee7d..d1925333d327 100644
--- a/fs/9p/vfs_inode.c
+++ b/fs/9p/vfs_inode.c
@@ -771,6 +771,9 @@ v9fs_vfs_atomic_open(struct inode *dir, struct dentry *dentry,
 	struct inode *inode;
 	int p9_omode;
 
+	if ((flags & O_MKDIR_MASK) == O_MKDIR_MASK)
+		return -EINVAL;
+
 	if (d_in_lookup(dentry)) {
 		struct dentry *res = v9fs_vfs_lookup(dir, dentry, 0);
 		if (res || d_really_is_positive(dentry))
diff --git a/fs/9p/vfs_inode_dotl.c b/fs/9p/vfs_inode_dotl.c
index 141fb54db65d..9f4b865d07d7 100644
--- a/fs/9p/vfs_inode_dotl.c
+++ b/fs/9p/vfs_inode_dotl.c
@@ -239,6 +239,9 @@ v9fs_vfs_atomic_open_dotl(struct inode *dir, struct dentry *dentry,
 	struct v9fs_session_info *v9ses;
 	struct posix_acl *pacl = NULL, *dacl = NULL;
 
+	if ((flags & O_MKDIR_MASK) == O_MKDIR_MASK)
+		return -EINVAL;
+
 	if (d_in_lookup(dentry)) {
 		struct dentry *res = v9fs_vfs_lookup(dir, dentry, 0);
 		if (res || d_really_is_positive(dentry))
diff --git a/fs/ceph/file.c b/fs/ceph/file.c
index d54d71669176..9707d9ed17b6 100644
--- a/fs/ceph/file.c
+++ b/fs/ceph/file.c
@@ -813,6 +813,9 @@ int ceph_atomic_open(struct inode *dir, struct dentry *dentry,
 	if (dentry->d_name.len > NAME_MAX)
 		return -ENAMETOOLONG;
 
+	if ((flags & O_MKDIR_MASK) == O_MKDIR_MASK)
+		return -EINVAL;
+
 	err = ceph_wait_on_conflict_unlink(dentry);
 	if (err)
 		return err;
diff --git a/fs/fuse/dir.c b/fs/fuse/dir.c
index b658b6baf72f..4c59992b9867 100644
--- a/fs/fuse/dir.c
+++ b/fs/fuse/dir.c
@@ -940,6 +940,9 @@ static int fuse_atomic_open(struct inode *dir, struct dentry *entry,
 	if (fuse_is_bad(dir))
 		return -EIO;
 
+	if ((flags & O_MKDIR_MASK) == O_MKDIR_MASK)
+		return -EINVAL;
+
 	if (d_in_lookup(entry)) {
 		struct dentry *res = fuse_lookup(dir, entry, 0);
 		if (res || d_really_is_positive(entry))
diff --git a/fs/gfs2/inode.c b/fs/gfs2/inode.c
index e9bf4879c07f..21c6544fbee5 100644
--- a/fs/gfs2/inode.c
+++ b/fs/gfs2/inode.c
@@ -1384,6 +1384,9 @@ static int gfs2_atomic_open(struct inode *dir, struct dentry *dentry,
 {
 	bool excl = !!(flags & O_EXCL);
 
+	if ((flags & O_MKDIR_MASK) == O_MKDIR_MASK)
+		return -EINVAL;
+
 	if (d_in_lookup(dentry)) {
 		struct dentry *d = __gfs2_lookup(dir, dentry, file);
 		if (file->f_mode & FMODE_OPENED) {
diff --git a/fs/namei.c b/fs/namei.c
index 60223278f9ec..9d9529ef30c4 100644
--- a/fs/namei.c
+++ b/fs/namei.c
@@ -4383,11 +4383,6 @@ static struct dentry *atomic_open(const struct path *path, struct dentry *dentry
 	struct inode *dir =  path->dentry->d_inode;
 	int error;
 
-	if ((open_flag & O_MKDIR_MASK) == O_MKDIR_MASK) {
-		error = -EOPNOTSUPP;
-		goto out;
-	}
-
 	file->__f_path.dentry = DENTRY_NOT_SET;
 	file->__f_path.mnt = path->mnt;
 	error = dir->i_op->atomic_open(dir, dentry, file,
@@ -4410,7 +4405,6 @@ static struct dentry *atomic_open(const struct path *path, struct dentry *dentry
 				error = -ENOENT;
 		}
 	}
-out:
 	if (error) {
 		dput(dentry);
 		dentry = ERR_PTR(error);
@@ -4642,7 +4636,7 @@ static const char *open_last_lookups(struct nameidata *nd,
 		 */
 	}
 	if (open_flag & O_CREAT)
-		inode_lock(dir->d_inode);
+		inode_lock_nested(dir->d_inode, I_MUTEX_PARENT);
 	else
 		inode_lock_shared(dir->d_inode);
 	dentry = lookup_open(nd, file, op, got_write, &delegated_inode);
@@ -4713,6 +4707,7 @@ static int do_open(struct nameidata *nd,
 	if (open_flag & O_CREAT) {
 		if ((open_flag & O_EXCL) && !(file->f_mode & FMODE_CREATED))
 			return -EEXIST;
+		// there are no special rules for creating dirs in a sticky bit dir
 		if (!(open_flag & O_DIRECTORY)) {
 			if (d_is_dir(nd->path.dentry))
 				return -EISDIR;
diff --git a/fs/nfs/dir.c b/fs/nfs/dir.c
index e9ce1883288c..e44c7598b68e 100644
--- a/fs/nfs/dir.c
+++ b/fs/nfs/dir.c
@@ -2314,6 +2314,9 @@ int nfs_atomic_open_v23(struct inode *dir, struct dentry *dentry,
 	if (dentry->d_name.len > NFS_SERVER(dir)->namelen)
 		return -ENAMETOOLONG;
 
+	if ((open_flags & O_MKDIR_MASK) == O_MKDIR_MASK)
+		return -EINVAL;
+
 	if (open_flags & O_CREAT) {
 		error = nfs_do_create(dir, dentry, mode, open_flags);
 		if (!error) {
diff --git a/fs/nfs/file.c b/fs/nfs/file.c
index 25048a3c2364..467f6bc707da 100644
--- a/fs/nfs/file.c
+++ b/fs/nfs/file.c
@@ -52,6 +52,9 @@ int nfs_check_flags(int flags)
 	if ((flags & (O_APPEND | O_DIRECT)) == (O_APPEND | O_DIRECT))
 		return -EINVAL;
 
+	if ((flags & O_MKDIR_MASK) == O_MKDIR_MASK)
+		return -EINVAL;
+
 	return 0;
 }
 EXPORT_SYMBOL_GPL(nfs_check_flags);
diff --git a/fs/open.c b/fs/open.c
index 68b694ae1843..865ea6f70e8c 100644
--- a/fs/open.c
+++ b/fs/open.c
@@ -1209,7 +1209,7 @@ inline int build_open_flags(const struct open_how *how, struct open_flags *op)
 	if (WILL_CREATE(flags)) {
 		if (how->mode & ~S_IALLUGO)
 			return -EINVAL;
-		if (flags & O_DIRECTORY)
+		if ((flags & (O_MKDIR_MASK)) == O_MKDIR_MASK)
 			op->mode = how->mode | S_IFDIR;
 		else
 			op->mode = how->mode | S_IFREG;
diff --git a/fs/smb/client/dir.c b/fs/smb/client/dir.c
index e4295a5b55b3..ec8c54c91261 100644
--- a/fs/smb/client/dir.c
+++ b/fs/smb/client/dir.c
@@ -526,6 +526,9 @@ int cifs_atomic_open(struct inode *dir, struct dentry *direntry,
 	if (unlikely(cifs_forced_shutdown(cifs_sb)))
 		return smb_EIO(smb_eio_trace_forced_shutdown);
 
+	if ((oflags & O_MKDIR_MASK) == O_MKDIR_MASK)
+		return -EINVAL;
+
 	/*
 	 * Posix open is only called (at lookup time) for file create now. For
 	 * opens (rather than creates), because we do not know if it is a file
diff --git a/fs/vboxsf/dir.c b/fs/vboxsf/dir.c
index 42bedc4ec7af..aef5ca6730be 100644
--- a/fs/vboxsf/dir.c
+++ b/fs/vboxsf/dir.c
@@ -318,6 +318,9 @@ static int vboxsf_dir_atomic_open(struct inode *parent, struct dentry *dentry,
 	u64 handle;
 	int err;
 
+	if ((flags & O_MKDIR_MASK) == O_MKDIR_MASK)
+		return -EINVAL;
+
 	if (d_in_lookup(dentry)) {
 		struct dentry *res = vboxsf_dir_lookup(parent, dentry, 0);
 		if (res || d_really_is_positive(dentry))
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
diff --git a/include/uapi/asm-generic/fcntl.h b/include/uapi/asm-generic/fcntl.h
index 40ab8bbe668b..613475285643 100644
--- a/include/uapi/asm-generic/fcntl.h
+++ b/include/uapi/asm-generic/fcntl.h
@@ -95,8 +95,6 @@
 #define O_NDELAY	O_NONBLOCK
 #endif
 
-#define O_MKDIR_MASK	(O_CREAT | O_DIRECTORY)
-
 #define F_DUPFD		0	/* dup */
 #define F_GETFD		1	/* get close_on_exec */
 #define F_SETFD		2	/* set/clear close_on_exec */


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
