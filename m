Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A686C399354
	for <syzbot@lists.linux.dev>; Wed, 29 Jul 2026 11:04:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785323069; cv=none; b=QKbdc9+BydRU+EYxqunvdwDT7wiIesQAWn+pWawNQ/V/oPKd15kiGj/6xCsSdvmnNWmUuLd1Uv37tKFeMp9XK3yQG3rF+kGxSzseRiDdEM2/7JUaT3bcJl183PJgIux7lGDCrHm32Nlws4/KW1GImIc1d+uCNOvY9cHnLELRtHo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785323069; c=relaxed/simple;
	bh=hd9isi3QOufZx4vx10MPXAvh4z6lLjkCyVyNXNmy1hI=;
	h=From:To:Cc:Subject:Message-ID:MIME-Version:Content-Type:Date; b=XUlTT/CwlZAb8zPS9/hl1qOzTqNlS1a9aEdCfOpjjdLeKR+/bcvV0FCzQaBa6j9QlzKqEhGqDazCTjC56lM/tcPDVhL5ReX5bdRfaZ4yhEHzEjvxDAWnVxrHKqVYs2r/DrJOVVN6hTLHxYNsqwQy4KhpuKU1hSzj5dZ5oUkoF+I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=m47Xyrih; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="m47Xyrih"
Received: by smtp.kernel.org (Postfix) with UTF8SMTPSA id 6B2BE1F000E9;
	Wed, 29 Jul 2026 11:04:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1785323067;
	bh=AquvaZ6/ojrUANbnRiFtVqa8sPcqB61g4Z6SlRcCG8s=;
	h=From:To:Cc:Subject:Date;
	b=m47Xyrih0rY1GQGyCL3KA4zXhqktb8nRIyHBC/uHCE3dDywE4XhGPXgRfk4tcX+ST
	 dG8OTVbWUX96W9jnsLlJ+tBntFwMm3JkS0D8spA5CGUrRF4loEWrcpanRw40wis+cY
	 X0Dm28Qg8R+uZMTMPIlvB1NhuwXQrSdNIpUg+sgN74c3JnbeKRe3ucoxUbtq3RIVp9
	 JYWAe8jTfrj65bawyBWLCOHpnMpwif8IvPjXf0FP1v/lLg+ZYZca66U59lS1ZQjqQZ
	 9zn2AnG8cInDfG3CWfYpCzMlkhNr9m+Idz8VIKdhSfIY4PuIBmfqslIW0rJOs7aYh+
	 Y9bxtrFrSXPvQ==
From: "syzbot" <syzbot@kernel.org>
To: syzkaller-upstream-moderation@googlegroups.com
Cc: syzbot@lists.linux.dev
Subject: [PATCH RFC] configfs: fix race between symlink and rmdir
Message-ID: <ac90b080-8c3f-4d8b-a0be-a32a52c77212@mail.kernel.org>
Precedence: bulk
X-Mailing-List: syzbot@lists.linux.dev
List-Id: <syzbot.lists.linux.dev>
List-Subscribe: <mailto:syzbot+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:syzbot+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Date: Wed, 29 Jul 2026 11:04:27 +0000 (UTC)

A race condition between configfs_rmdir() and configfs_symlink() can lead
to a use-after-free of a config_item.

When a directory is removed, configfs_rmdir() frees the associated
config_item but leaves the dentry hashed until vfs_rmdir() calls
d_delete(). This creates a window where a concurrent symlinkat() can find
the hashed dentry, see that !d_unhashed(dentry) is true, and attempt to
increment the refcount of the already freed config_item, triggering a
warning:

  refcount_t: addition on 0; use-after-free.
  WARNING: lib/refcount.c:25 at refcount_warn_saturate+0x9f/0x110
  ...
  Call Trace:
   __refcount_add include/linux/refcount.h:-1 [inline]
   __refcount_inc include/linux/refcount.h:366 [inline]
   refcount_inc include/linux/refcount.h:383 [inline]
   kref_get include/linux/kref.h:45 [inline]
   config_item_get+0x88/0x90 fs/configfs/item.c:104
   configfs_get_config_item fs/configfs/configfs_internal.h:127 [inline]
   get_target fs/configfs/symlink.c:128 [inline]
   configfs_symlink+0x4ab/0x1030 fs/configfs/symlink.c:185
   vfs_symlink+0x18b/0x330 fs/namei.c:5660
   filename_symlinkat+0x1cd/0x420 fs/namei.c:5685
   __do_sys_symlinkat fs/namei.c:5705 [inline]
   __se_sys_symlinkat+0x4e/0x2b0 fs/namei.c:5700

To fix this, add d_drop(dentry) in configfs_rmdir() immediately after
detaching the group/item and before unlinking the object. This ensures that
any concurrent kern_path() will either not find the dentry, or
configfs_get_config_item() will see d_unhashed(dentry) == true and safely
return NULL.

However, adding d_drop(dentry) exposes a secondary use-after-free bug in
create_link(). configfs_symlink() calls get_target(), which resolves the
path, gets the config_item, and then immediately drops the path reference.
If configfs_rmdir() runs concurrently, it drops its config_item reference,
and vfs_rmdir() calls d_delete_notify(). Since the dentry has only 1
reference left, dentry_unlink_inode() is called, freeing the
configfs_dirent. Later, create_link() accesses the freed configfs_dirent.

To fix this secondary issue, modify get_target() to return the path, and
hold the path reference in configfs_symlink() until after create_link()
finishes. By holding the path reference, the dentry's refcount remains >=
2, preventing d_delete() from calling dentry_unlink_inode(), which keeps
the configfs_dirent alive. The path is safely cleaned up using the
__free(path_put) attribute in configfs_symlink().

Fixes: 98702467f829 ("configfs: remove unnecessary dentry_unhash on rmdir, dir rename")
Assisted-by: Gemini:gemini-3.5-flash Gemini:gemini-3.1-pro-preview syzbot
Reported-by: syzbot+8358d1f3d9c15bdf1c9a@syzkaller.appspotmail.com
Closes: https://syzkaller.appspot.com/bug?extid=8358d1f3d9c15bdf1c9a
Link: https://syzkaller.appspot.com/ai_job?id=13fec684-23f7-4f06-99db-ed37ae92a405
To: "Andreas Hindborg" <a.hindborg@kernel.org>
To: <linux-kernel@vger.kernel.org>
To: "Sage Weil" <sage@newdream.net>
Cc: "Breno Leitao" <leitao@debian.org>

---
diff --git a/fs/configfs/dir.c b/fs/configfs/dir.c
index 3c88f13f1..b0812432f 100644
--- a/fs/configfs/dir.c
+++ b/fs/configfs/dir.c
@@ -1552,12 +1552,14 @@ static int configfs_rmdir(struct inode *dir, struct dentry *dentry)
 
 	if (sd->s_type & CONFIGFS_USET_DIR) {
 		configfs_detach_group(dentry);
+		d_drop(dentry);
 
 		mutex_lock(&subsys->su_mutex);
 		client_disconnect_notify(parent_item, item);
 		unlink_group(to_config_group(item));
 	} else {
 		configfs_detach_item(dentry);
+		d_drop(dentry);
 
 		mutex_lock(&subsys->su_mutex);
 		client_disconnect_notify(parent_item, item);
diff --git a/fs/configfs/symlink.c b/fs/configfs/symlink.c
index 31eb28b27..c8a2d9ad6 100644
--- a/fs/configfs/symlink.c
+++ b/fs/configfs/symlink.c
@@ -114,18 +114,17 @@ static int create_link(struct config_item *parent_item,
 }
 
 
-static int get_target(const char *symname, struct config_item **target,
-		      struct super_block *sb)
+static int get_target(const char *symname, struct path *path,
+		      struct config_item **target, struct super_block *sb)
 {
-	struct path path __free(path_put) = {};
 	int ret;
 
-	ret = kern_path(symname, LOOKUP_FOLLOW|LOOKUP_DIRECTORY, &path);
+	ret = kern_path(symname, LOOKUP_FOLLOW | LOOKUP_DIRECTORY, path);
 	if (ret)
 		return ret;
-	if (path.dentry->d_sb != sb)
+	if (path->dentry->d_sb != sb)
 		return -EPERM;
-	*target = configfs_get_config_item(path.dentry);
+	*target = configfs_get_config_item(path->dentry);
 	if (!*target)
 		return -ENOENT;
 	return 0;
@@ -136,6 +135,7 @@ int configfs_symlink(struct mnt_idmap *idmap, struct inode *dir,
 		     struct dentry *dentry, const char *symname)
 {
 	int ret;
+	struct path path __free(path_put) = {};
 	struct configfs_dirent *sd;
 	struct config_item *parent_item;
 	struct config_item *target_item = NULL;
@@ -182,7 +182,7 @@ int configfs_symlink(struct mnt_idmap *idmap, struct inode *dir,
 	 *  AV, a thoroughly annoyed bastard.
 	 */
 	inode_unlock(dir);
-	ret = get_target(symname, &target_item, dentry->d_sb);
+	ret = get_target(symname, &path, &target_item, dentry->d_sb);
 	inode_lock(dir);
 	if (ret)
 		goto out_put;


base-commit: f5098b6bae761e346ebcd9da7f95622c04733cff
-- 
This is an AI-generated patch subject to moderation.
Reply with '#syz upstream' to Sign-off the patch as a human author
and send it to the upstream kernel mailing lists.
Reply with '#syz reject' to reject it ('#syz unreject' to undo).

See https://goo.gle/syzbot-ai-patches for information about AI-generated patches.
You can comment on the patch as usual, syzbot will try to address
the comments and send a new version of the patch if necessary.
syzbot engineers can be reached at syzkaller@googlegroups.com.
