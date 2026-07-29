Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AA0484749DC
	for <syzbot@lists.linux.dev>; Wed, 29 Jul 2026 11:27:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785324479; cv=none; b=LMMNitiloVpvRPxIelT7O3tSxtdfpeTt89Nda4HiC6tremb5luO6xJSR3i1uLe0DDzvZTv+c0INFaw/xAOQdzHZeRDit7j84SmB07BaSrJspXS64aX0M8fZtL73nd+bLY21jmEGFsfwaT5lIBeBx+Nlnvu8x2/SLha5Zp30t0R4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785324479; c=relaxed/simple;
	bh=x2evtz0Tzdbljpe4/YO2uCAP30JjbFZmYuFBv5WItOc=;
	h=From:To:Cc:Subject:Message-ID:MIME-Version:Content-Type:Date; b=PLyLuc2N0o791aukjtuj8i8S8Uk4UJbpZTfi2vXwwiEdXZITgf/L5lOkxZ+iUVlLwaPZGFnmvcsQdj8kyWjlxJ24vh0PENWVJjxOUtZFUOttyqzEKwcQPMTfkKSXaDdLXrWmxPB59YwlzY3kRAPR/gz0MCIDmLoduISBpyb+rMw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=jOKIjoRz; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="jOKIjoRz"
Received: by smtp.kernel.org (Postfix) with UTF8SMTPSA id 567CC1F000E9;
	Wed, 29 Jul 2026 11:27:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1785324477;
	bh=qHllbbUFPybDZThPZbR7n/UPwi/gQLtYMfM7b+hvIUc=;
	h=From:To:Cc:Subject:Date;
	b=jOKIjoRzoUIyimhNpQQpdE/ufqTennMEbitGGIzix3deTnGo76EqmtB2DVBaIcHA+
	 wtbr3en7KG5hnWoXodLFFc0qhk3yi7kpKkKy1CEOkbNlqmKigAANttratk30YMRjLe
	 4A05PpPJXr+cHa2BEXPppQa0/ALCWXMDFTKHwD3RMGN/M3dyOXqDdvdNqOlfw5xL4S
	 5LIAMz+uQKNvAjCDF783sWW8NEkXuhK4jtUxPvjb3xC85vPjhrvW7zsklsp2t6Rkaj
	 Oa2gwtNVlN8u2bKUb1naybQte8+lkw0M1tdRq6JMQLDucNuco3028nxmi2fEtqRoyy
	 hPBX04ru+gOFw==
From: "syzbot" <syzbot@kernel.org>
To: syzkaller-upstream-moderation@googlegroups.com
Cc: syzbot@lists.linux.dev
Subject: [PATCH RFC] usb: gadget: f_tcm: Fix false positive circular locking dependency
Message-ID: <7ed63268-8601-4d0c-bbb0-99fe949d51e6@mail.kernel.org>
Precedence: bulk
X-Mailing-List: syzbot@lists.linux.dev
List-Id: <syzbot.lists.linux.dev>
List-Subscribe: <mailto:syzbot+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:syzbot+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Date: Wed, 29 Jul 2026 11:27:57 +0000 (UTC)

Lockdep reports a possible circular locking dependency:

WARNING: possible circular locking dependency detected
------------------------------------------------------
task is trying to acquire lock:
(gadget_subsys.su_mutex){+.+.}-{4:4}, at:
uvcg_streaming_header_allow_link+0x75/0x4d0
drivers/usb/gadget/function/uvc_configfs.c:1750

but task is already holding lock:
(&sb->s_type->i_mutex_key#24){+.+.}-{4:4}, at: inode_lock
include/linux/fs.h:1024 [inline]
(&sb->s_type->i_mutex_key#24){+.+.}-{4:4}, at:
configfs_symlink+0x3af/0x1030 fs/configfs/symlink.c:186

which lock already depends on the new lock.

the existing dependency chain (in reverse order) is:

-> #2 (&sb->s_type->i_mutex_key#24){+.+.}-{4:4}:
       inode_lock include/linux/fs.h:1024 [inline]
       configfs_depend_item_unlocked+0x153/0x420 fs/configfs/dir.c:1259
       usbg_make_tpg+0x1f6/0x590 drivers/usb/gadget/function/f_tcm.c:1686
       target_fabric_make_tpg+0xa8/0x6d0
       drivers/target/target_core_fabric_configfs.c:939
       configfs_mkdir+0x4f6/0x9e0 fs/configfs/dir.c:1360

-> #1 (&opts->dep_lock){+.+.}-{4:4}:
       mutex_lock_nested+0x5a/0x1d0 kernel/locking/rtmutex_api.c:578
       tcm_set_name+0x2b/0xd0 drivers/usb/gadget/function/f_tcm.c:2669
       function_make+0x1a8/0x360 drivers/usb/gadget/configfs.c:636
       configfs_mkdir+0x4f6/0x9e0 fs/configfs/dir.c:1360

-> #0 (gadget_subsys.su_mutex){+.+.}-{4:4}:
       mutex_lock_nested+0x5a/0x1d0 kernel/locking/rtmutex_api.c:578
       uvcg_streaming_header_allow_link+0x75/0x4d0
       drivers/usb/gadget/function/uvc_configfs.c:1750
       configfs_symlink+0x59a/0x1030 fs/configfs/symlink.c:196

The cycle is reported as follows. First, inode_lock ->
gadget_subsys.su_mutex: In configfs_symlink(), VFS holds the inode_lock of
the parent directory. The function then calls
uvcg_streaming_header_allow_link(), which acquires gadget_subsys.su_mutex.
Second, gadget_subsys.su_mutex -> opts->dep_lock: In configfs_mkdir() for
the gadget subsystem, configfs holds gadget_subsys.su_mutex and calls
function_make() -> tcm_set_name(), which acquires opts->dep_lock. Third,
opts->dep_lock -> inode_lock: In configfs_mkdir() for the target subsystem,
configfs calls target_fabric_make_tpg() -> usbg_make_tpg(). This function
acquires opts->dep_lock and then calls configfs_depend_item_unlocked().
Because the target and gadget subsystems are different,
configfs_depend_item_unlocked() acquires the inode_lock of the configfs
root directory.

This is a false positive because configfs assigns the default VFS lock
class (&sb->s_type->i_mutex_key) to all non-default directories, including
the root directory and user-created directories. Lockdep sees the
inode_lock on the symlink parent directory and the inode_lock on the
configfs root directory as the same lock class, assuming a cycle. In
reality, these are different inodes, and the root directory's inode_lock is
never held while waiting for su_mutex or dep_lock.

To break this false positive cycle, avoid holding opts->dep_lock and
tpg_instances_lock while calling configfs_depend_item_unlocked() in
usbg_make_tpg(). This severs the dep_lock -> i_mutex_key link in lockdep's
graph.

To do this safely without introducing race conditions or use-after-free
bugs, several steps are taken. First, pre-allocate and reserve the tpg in
the tpg_instances array before dropping the locks so that concurrent calls
to usbg_make_tpg() skip this instance. Second, take a reference on the
config_item (config_item_get()) before dropping the locks. This prevents a
concurrent rmdir on the function directory from freeing the item while we
are depending on it. Third, drop the extra reference (config_item_put())
only after we have fully unlocked tpg_instances_lock. This is crucial
because config_item_put() might trigger the release function
tcm_free_inst(), which acquires tpg_instances_lock and would cause a real
deadlock if we still held it.

Fixes: 4bb8548df632 ("usb: gadget: f_tcm: add configfs support")
Assisted-by: Gemini:gemini-3.5-flash Gemini:gemini-3.1-pro-preview syzbot
Reported-by: syzbot+ed4b9a6a61280b24d9c3@syzkaller.appspotmail.com
Closes: https://syzkaller.appspot.com/bug?extid=ed4b9a6a61280b24d9c3
Link: https://syzkaller.appspot.com/ai_job?id=cf0ad2c8-f356-4700-bd6a-e8c2d28a72cd
To: "Greg Kroah-Hartman" <gregkh@linuxfoundation.org>
To: <linux-usb@vger.kernel.org>
To: "Andrzej Pietrasiewicz" <andrzej.p@samsung.com>
Cc: "Jiasheng Jiang" <jiashengjiangcool@gmail.com>
Cc: <linux-kernel@vger.kernel.org>
Cc: "Cen Zhang" <zzzccc427@gmail.com>

---
diff --git a/drivers/usb/gadget/function/f_tcm.c b/drivers/usb/gadget/function/f_tcm.c
index b3fa5a17f..c8278053d 100644
--- a/drivers/usb/gadget/function/f_tcm.c
+++ b/drivers/usb/gadget/function/f_tcm.c
@@ -1660,6 +1660,7 @@ static struct se_portal_group *usbg_make_tpg(struct se_wwn *wwn,
 	int ret;
 	struct f_tcm_opts *opts;
 	unsigned i;
+	bool dep_taken = false;
 
 	if (strstr(name, "tpgt_") != name)
 		return ERR_PTR(-EINVAL);
@@ -1679,59 +1680,84 @@ static struct se_portal_group *usbg_make_tpg(struct se_wwn *wwn,
 	if (!opts->ready)
 		goto unlock_dep;
 
-	if (opts->has_dep) {
-		if (!try_module_get(opts->dependent))
-			goto unlock_dep;
-	} else {
-		ret = configfs_depend_item_unlocked(
-			wwn->wwn_group.cg_subsys,
-			&opts->func_inst.group.cg_item);
-		if (ret)
-			goto unlock_dep;
-	}
-
 	tpg = kzalloc_obj(struct usbg_tpg);
-	ret = -ENOMEM;
-	if (!tpg)
-		goto unref_dep;
+	if (!tpg) {
+		ret = -ENOMEM;
+		goto unlock_dep;
+	}
 	mutex_init(&tpg->tpg_mutex);
 	atomic_set(&tpg->tpg_port_count, 0);
 	tpg->workqueue = alloc_workqueue("tcm_usb_gadget",
 					 WQ_UNBOUND, WQ_UNBOUND_MAX_ACTIVE);
-	if (!tpg->workqueue)
-		goto free_tpg;
-
+	if (!tpg->workqueue) {
+		ret = -ENOMEM;
+		kfree(tpg);
+		goto unlock_dep;
+	}
 	tpg->tport = tport;
 	tpg->tport_tpgt = tpgt;
 
+	tpg_instances[i].tpg = tpg;
+
+	if (opts->has_dep) {
+		if (!try_module_get(opts->dependent)) {
+			ret = -ENODEV;
+			goto free_tpg;
+		}
+	} else {
+		config_item_get(&opts->func_inst.group.cg_item);
+		dep_taken = true;
+		mutex_unlock(&opts->dep_lock);
+		mutex_unlock(&tpg_instances_lock);
+
+		ret = configfs_depend_item_unlocked(
+			wwn->wwn_group.cg_subsys,
+			&opts->func_inst.group.cg_item);
+
+		if (ret) {
+			mutex_lock(&tpg_instances_lock);
+			tpg_instances[i].tpg = NULL;
+			mutex_unlock(&tpg_instances_lock);
+			destroy_workqueue(tpg->workqueue);
+			kfree(tpg);
+			config_item_put(&opts->func_inst.group.cg_item);
+			return ERR_PTR(ret);
+		}
+
+		mutex_lock(&tpg_instances_lock);
+		mutex_lock(&opts->dep_lock);
+	}
+
 	/*
 	 * SPC doesn't assign a protocol identifier for USB-SCSI, so we
 	 * pretend to be SAS..
 	 */
 	ret = core_tpg_register(wwn, &tpg->se_tpg, SCSI_PROTOCOL_SAS);
 	if (ret < 0)
-		goto free_workqueue;
+		goto unref_dep;
 
-	tpg_instances[i].tpg = tpg;
 	tpg->fi = tpg_instances[i].func_inst;
 	mutex_unlock(&opts->dep_lock);
 	mutex_unlock(&tpg_instances_lock);
+	if (dep_taken)
+		config_item_put(&opts->func_inst.group.cg_item);
 	return &tpg->se_tpg;
 
-free_workqueue:
-	destroy_workqueue(tpg->workqueue);
-free_tpg:
-	kfree(tpg);
 unref_dep:
 	if (opts->has_dep)
 		module_put(opts->dependent);
 	else
 		configfs_undepend_item_unlocked(&opts->func_inst.group.cg_item);
+free_tpg:
+	tpg_instances[i].tpg = NULL;
+	destroy_workqueue(tpg->workqueue);
+	kfree(tpg);
 unlock_dep:
 	mutex_unlock(&opts->dep_lock);
 unlock_inst:
 	mutex_unlock(&tpg_instances_lock);
-
+	if (dep_taken)
+		config_item_put(&opts->func_inst.group.cg_item);
 	return ERR_PTR(ret);
 }
 


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
