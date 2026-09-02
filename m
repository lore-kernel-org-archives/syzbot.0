Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CECE641686D
	for <syzbot@lists.linux.dev>; Wed,  2 Sep 2026 22:23:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788387789; cv=none; b=lfzqCtP2n+K4054/LGaDZEif07+7N29NKg9pe3gYnHj/Y1Wr21MB88CrV9KscUgLTKVTsOALj5RKKBcGCHH5niPShyzqRq/3Ne2PY3VjRvdE/BtzRlryHsWbC2pzRTC9vfuCFkI6YdjcCnVabIMjya+Bw0mjm4pdB7NNJjRgVJQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788387789; c=relaxed/simple;
	bh=A88bS0OlT8rvvN5VrfNX7DKDdSbtAHY0MTXWsj0Kd6M=;
	h=From:To:Cc:Subject:Message-ID:MIME-Version:Content-Type:Date; b=i3cYOZ+M9+v/X6eOGJzdG7lmhEbfztXfcprElHo1CnN29xhAaUQyQCc1gvSpeU+RUp/dKXeEADGVk/YmdbuCCJxMspgSaQN1ahWLZQiX0Dfa9NrKqdiSJeENp/oJkvkZ9ZeYg3lt4r3tACgly9Zh5NLVjX2j4jUQl0jRDdzum0Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=kPVzTsvB; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="kPVzTsvB"
Received: by smtp.kernel.org (Postfix) with UTF8SMTPSA id 7192A1F000E9;
	Wed,  2 Sep 2026 22:23:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788387782;
	bh=RgP7hZmIoKVcyTrGZrR2vRQcxYnsSk0IBAYKyRzn590=;
	h=From:To:Cc:Subject:Date;
	b=kPVzTsvB5scoehLhvufgsredzNLLsStz/TbC0rGfEGFy8J4ddlqowAGveSPEhNp6F
	 pwlR4zyhp9fjkkNCdTmyCutVD+wan3rdjHeTZp9bi1qm9qsVztb8ONMfI+7Ianop7M
	 G8YK7PJCxGEjtAXM/CvHdodvrNcWOkl0eVKupONWrWQ7v0VdgY8sSIsk14avYGdN1L
	 oLfwMoO5M1RpyMWX4TsX8nV6ucqi7NmrXx+kudqvoLv1gbsWjDAWPg52v6GaO4RJcL
	 u8JVPYhqS1jWG6yK21b7qBwWCP2LTAdPhptTJXe37tEDeQpRtjH4RCM8xvYzwS6piu
	 OpLm7irJACRJw==
From: "syzbot" <syzbot@kernel.org>
To: syzkaller-upstream-moderation@googlegroups.com
Cc: syzbot@lists.linux.dev
Subject: [PATCH RFC] configfs: fix use-after-free in configfs_symlink()
Message-ID: <ccce0ada-669c-4d3b-929a-5e95de4e54dd@mail.kernel.org>
Precedence: bulk
X-Mailing-List: syzbot@lists.linux.dev
List-Id: <syzbot.lists.linux.dev>
List-Subscribe: <mailto:syzbot+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:syzbot+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Date: Wed,  2 Sep 2026 22:23:02 +0000 (UTC)

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
Assisted-by: Gemini:gemini-3.7-flash Gemini:gemini-3.1-pro-preview syzbot
Reported-by: syzbot+b0996ac2197dd7420c3e@syzkaller.appspotmail.com
Closes: https://syzkaller.appspot.com/bug?extid=b0996ac2197dd7420c3e
Link: https://syzkaller.appspot.com/ai_job?id=e3aa1920-4324-4492-b79e-dffb87dfa600
To: "Breno Leitao" <leitao@debian.org>
To: <linux-kernel@vger.kernel.org>
To: "Al Viro" <viro@zeniv.linux.org.uk>
Cc: "Andreas Hindborg" <a.hindborg@kernel.org>

---
diff --git a/fs/configfs/symlink.c b/fs/configfs/symlink.c
index 31eb28b27..5fe3722bd 100644
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
+	while (root_dentry) {
+		sd = root_dentry->d_fsdata;
+		if (!sd || !(sd->s_type & CONFIGFS_USET_DEFAULT))
+			break;
+		root_dentry = root_dentry->d_parent;
+	}
+	return root_dentry ? configfs_get_config_item(root_dentry) : NULL;
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
@@ -157,6 +171,12 @@ int configfs_symlink(struct mnt_idmap *idmap, struct inode *dir,
 	    !type->ct_item_ops->allow_link)
 		goto out_put;
 
+	/*
+	 * Pin the root object so that the parent_item (which may be an
+	 * embedded default group) is not freed while we drop the lock.
+	 */
+	root_item = configfs_get_root_item(dentry->d_parent);
+
 	/*
 	 * This is really sick.  What they wanted was a hybrid of
 	 * link(2) and symlink(2) - they wanted the target resolved
@@ -192,8 +212,12 @@ int configfs_symlink(struct mnt_idmap *idmap, struct inode *dir,
 	else
 		ret = inode_permission(&nop_mnt_idmap, dir,
 				       MAY_WRITE | MAY_EXEC);
-	if (!ret)
-		ret = type->ct_item_ops->allow_link(parent_item, target_item);
+	if (!ret) {
+		if (sd->s_frag->frag_dead)
+			ret = -ENOENT;
+		else
+			ret = type->ct_item_ops->allow_link(parent_item, target_item);
+	}
 	if (!ret) {
 		mutex_lock(&configfs_symlink_mutex);
 		ret = create_link(parent_item, target_item, dentry);
@@ -207,6 +231,7 @@ int configfs_symlink(struct mnt_idmap *idmap, struct inode *dir,
 
 out_put:
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
