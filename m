Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2831E4E56C5
	for <syzbot@lists.linux.dev>; Thu,  3 Sep 2026 15:39:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788449998; cv=none; b=o9t+YIP5/o1ITlKGquDCSTnNCMVAcQMIxezMGqztbDc4C+LUdM69EkpACCYzu9f84B+swAsFK/SXAseBpoohGprJA5LPexQCVHOoCxV7eI4L3ztJDEGVLIVK6cEjzctgNilRW1pfTeo5AfdwdS0w+R/nA9eJlRH8IiYEIL2Dm5E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788449998; c=relaxed/simple;
	bh=V4+XT82cO7fEqDJ3Doo4tj1Yl0irJd5LBC7+hbj5YME=;
	h=From:To:Cc:Subject:Message-ID:MIME-Version:Content-Type:Date; b=IYK6VMHzjcXYOyVQc5J8sF/q5efRX0yflZ/9WoiHF139bnluOaavjS6vj38HpT734QIoXnRTB2/nbzebMVvL4yTyN8JNeUnkoSqg2xX2/DZx0LuJcsjqI+8YCglVZy79g0wPbEh8NzwKzAA9Tw0nDTn0YXlO5v89RnsGcC/pBiw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=MXTdswdi; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="MXTdswdi"
Received: by smtp.kernel.org (Postfix) with UTF8SMTPSA id C56FF1F00A3A;
	Thu,  3 Sep 2026 15:39:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788449996;
	bh=2DoaNWUiadJag0htBSVnbyxJWzyWphHiRPFzn/ucsEY=;
	h=From:To:Cc:Subject:Date;
	b=MXTdswdiO3hQissSABALd2ZWGpogKRY0qx7xmhHv2MSYWtQH2BG7Cu/2Kblbld6P8
	 yEx4JZKFKV34I1xmyQ9qz5L9hdwRkmnjoUqqIOyOZHZHsaOWPfyqeu2xUxgYZv888r
	 1O9oMKuIzVsp9rSR/ZsXCOWVIjeejLUWFGCSNbciHjqX1neuEGvuGgJflBqyqKceXk
	 V+N+JC9f95nJPk3VmoqVXfqXmqt/MALoQ2rZOX3Gf35M7JHcbvJMdPG/hsw7sowm1I
	 u/0P7AI1d0jHd5QM/I+qAtbWzi9ntQJ0aNElfBx0Okf3yaoCRfn/TyJgK5uAuWsZG3
	 q6bVqz0g39eFQ==
From: "syzbot" <syzbot@kernel.org>
To: syzkaller-upstream-moderation@googlegroups.com
Cc: nogikh@google.com, syzbot@lists.linux.dev
Subject: [PATCH RFC v2] configfs: fix use-after-free in configfs_symlink()
Message-ID: <bf0e79de-e726-45bd-97e5-ebe98869d416@mail.kernel.org>
Precedence: bulk
X-Mailing-List: syzbot@lists.linux.dev
List-Id: <syzbot.lists.linux.dev>
List-Subscribe: <mailto:syzbot+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:syzbot+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Date: Thu,  3 Sep 2026 15:39:56 +0000 (UTC)

In configfs_symlink(), inode_unlock(dir) is called before resolving the
symlink target via get_target() to avoid deadlocks during pathname lookup.
When configfs_symlink() operates within a default group (such as
ports/1/subsystems/ in NVMe-oF target), parent_item is an embedded default
group inside the dynamically allocated parent object (struct nvmet_port).
Because default groups are embedded within their containing structure,
holding a reference to parent_item alone does not prevent the containing
parent structure from being freed when a concurrent configfs_rmdir()
removes the root directory.

When configfs_rmdir() runs concurrently while inode_lock(dir) is dropped in
configfs_symlink(), it detaches all default groups, unlinks the root group,
sets frag_dead to true, and drops the subsystem's reference to the root
group. Once the root object's refcount drops to zero, the entire containing
structure is freed via kfree(). When configfs_symlink() re-acquires
inode_lock(dir), accessing parent_item in allow_link() accesses freed
memory, causing a slab-use-after-free:

BUG: KASAN: slab-use-after-free in nvmet_port_subsys_allow_link+0x41/0x2e0
drivers/nvme/target/configfs.c:1059
Read of size 8 at addr ffff88811c6d44c8

Call Trace:
 <TASK>
 kasan_report+0x117/0x150 mm/kasan/report.c:595
 nvmet_port_subsys_allow_link+0x41/0x2e0
 drivers/nvme/target/configfs.c:1059
 configfs_symlink+0x59a/0x1030 fs/configfs/symlink.c:196
 vfs_symlink+0x18b/0x330 fs/namei.c:5794
 filename_symlinkat+0x1cd/0x410 fs/namei.c:5819
 do_syscall_64+0x166/0x520 arch/x86/entry/syscall_64.c:84
 entry_SYSCALL_64_after_hwframe+0x77/0x7f
 </TASK>

Allocated by task 5847:
 kasan_save_stack mm/kasan/common.c:57 [inline]
 kasan_save_track+0x3e/0x80 mm/kasan/common.c:78
 __kasan_kmalloc+0x93/0xb0 mm/kasan/common.c:415
 __kmalloc_cache_noprof+0x321/0x600 mm/slub.c:5563
 nvmet_ports_make+0xe6/0xf00 drivers/nvme/target/configfs.c:2051
 configfs_mkdir+0x4f6/0x9e0 fs/configfs/dir.c:1360
 vfs_mkdir+0x40c/0x620 fs/namei.c:5410
 filename_mkdirat+0x285/0x510 fs/namei.c:5443
 do_syscall_64+0x166/0x520 arch/x86/entry/syscall_64.c:84
 entry_SYSCALL_64_after_hwframe+0x77/0x7f

Freed by task 5847:
 kasan_save_stack mm/kasan/common.c:57 [inline]
 kasan_save_track+0x3e/0x80 mm/kasan/common.c:78
 __kasan_slab_free+0x5c/0x80 mm/kasan/common.c:285
 kfree+0x1c5/0x650 mm/slub.c:6792
 config_item_release+0x13a/0x2d0 fs/configfs/item.c:137
 configfs_rmdir+0x885/0x950 fs/configfs/dir.c:1571
 vfs_rmdir+0x3e6/0x6a0 fs/namei.c:5515
 filename_rmdir+0x292/0x520 fs/namei.c:5572
 do_syscall_64+0x166/0x520 arch/x86/entry/syscall_64.c:84
 entry_SYSCALL_64_after_hwframe+0x77/0x7f

Fix this by:
1. Adding configfs_get_root_item() to walk up the dentry tree past any
default groups (CONFIGFS_USET_DEFAULT) while holding inode_lock(dir) to
acquire a reference to the root object (root_item), preventing the
containing structure from being freed while inode_lock(dir) is dropped.
2. Checking sd->s_frag->frag_dead after re-acquiring inode_lock(dir) to
detect if the directory was removed during the unlocked window, returning
-ENOENT instead of calling allow_link().
3. Releasing parent_item before root_item in the out_put cleanup path so
that the embedded item reference is dropped while the memory of the
containing root object remains pinned.

Fixes: 351e5d869e5a ("configfs: fix a deadlock in configfs_symlink()")
Assisted-by: Gemini:gemini-3.7-flash syzbot
Reported-by: syzbot+b0996ac2197dd7420c3e@syzkaller.appspotmail.com
Closes: https://syzkaller.appspot.com/bug?extid=b0996ac2197dd7420c3e
Link: https://syzkaller.appspot.com/ai_job?id=235023c6-930a-499e-adf7-3e465635dbd3
To: "Breno Leitao" <leitao@debian.org>
To: <linux-kernel@vger.kernel.org>
To: "Al Viro" <viro@zeniv.linux.org.uk>
Cc: "Andreas Hindborg" <a.hindborg@kernel.org>

---
v2:
- Use !IS_ROOT(root_dentry) to terminate the dentry traversal in configfs_get_root_item()
- Only call configfs_get_root_item() when parent is a default group (CONFIGFS_USET_DEFAULT) and handle errors
- Check IS_DEADDIR(dir) and d_unhashed(dentry->d_parent) alongside frag_dead after re-locking dir
- Move config_item_put(target_item) into the out_put error path

v1:
https://lore.kernel.org/all/ccce0ada-669c-4d3b-929a-5e95de4e54dd@mail.kernel.org/T/
---
diff --git a/fs/configfs/symlink.c b/fs/configfs/symlink.c
index 31eb28b27..a00f27c89 100644
--- a/fs/configfs/symlink.c
+++ b/fs/configfs/symlink.c
@@ -131,6 +131,19 @@ static int get_target(const char *symname, struct config_item **target,
 	return 0;
 }
 
+static struct config_item *configfs_get_root_item(struct dentry *dentry)
+{
+	struct dentry *root_dentry = dentry;
+	struct configfs_dirent *sd;
+
+	while (!IS_ROOT(root_dentry)) {
+		sd = root_dentry->d_fsdata;
+		if (!sd || !(sd->s_type & CONFIGFS_USET_DEFAULT))
+			break;
+		root_dentry = root_dentry->d_parent;
+	}
+	return configfs_get_config_item(root_dentry);
+}
 
 int configfs_symlink(struct mnt_idmap *idmap, struct inode *dir,
 		     struct dentry *dentry, const char *symname)
@@ -139,6 +152,7 @@ int configfs_symlink(struct mnt_idmap *idmap, struct inode *dir,
 	struct configfs_dirent *sd;
 	struct config_item *parent_item;
 	struct config_item *target_item = NULL;
+	struct config_item *root_item = NULL;
 	const struct config_item_type *type;
 
 	sd = dentry->d_parent->d_fsdata;
@@ -157,6 +171,18 @@ int configfs_symlink(struct mnt_idmap *idmap, struct inode *dir,
 	    !type->ct_item_ops->allow_link)
 		goto out_put;
 
+	/*
+	 * Pin the root object so that the parent_item (which may be an
+	 * embedded default group) is not freed while we drop the lock.
+	 */
+	if (sd->s_type & CONFIGFS_USET_DEFAULT) {
+		root_item = configfs_get_root_item(dentry->d_parent);
+		if (!root_item) {
+			ret = -ENOENT;
+			goto out_put;
+		}
+	}
+
 	/*
 	 * This is really sick.  What they wanted was a hybrid of
 	 * link(2) and symlink(2) - they wanted the target resolved
@@ -187,6 +213,12 @@ int configfs_symlink(struct mnt_idmap *idmap, struct inode *dir,
 	if (ret)
 		goto out_put;
 
+	if (sd->s_frag->frag_dead || IS_DEADDIR(dir) ||
+	    d_unhashed(dentry->d_parent)) {
+		ret = -ENOENT;
+		goto out_put;
+	}
+
 	if (dentry->d_inode || d_unhashed(dentry))
 		ret = -EEXIST;
 	else
@@ -203,10 +235,10 @@ int configfs_symlink(struct mnt_idmap *idmap, struct inode *dir,
 						     target_item);
 	}
 
-	config_item_put(target_item);
-
 out_put:
+	config_item_put(target_item);
 	config_item_put(parent_item);
+	config_item_put(root_item);
 	return ret;
 }
 


base-commit: cee9395acd8043be0644b25c34bfa86623f2b935
-- 
This is an AI-generated patch subject to moderation.
Reply with '#syz upstream' to Sign-off the patch as a human author
and send it to the upstream kernel mailing lists.
Reply with '#syz reject' to reject it ('#syz unreject' to undo).

See https://goo.gle/syzbot-ai-patches for information about AI-generated patches.
You can comment on the patch as usual, syzbot will try to address
the comments and send a new version of the patch if necessary.
syzbot engineers can be reached at syzkaller@googlegroups.com.
