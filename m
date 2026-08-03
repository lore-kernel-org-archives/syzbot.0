Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7C5C537FF75
	for <syzbot@lists.linux.dev>; Mon,  3 Aug 2026 13:33:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785764029; cv=none; b=hdz9C+UcQqUeSTbDGR7UmGci/PWhUo95tjpY+xL5gedvYCOKz8260o+frhtUlRt+QVXvW5Oh8fH0RxqORgGsGPalaRJJFDBObpCz8+pLLfkA32iPfuLGd0jZncg3sUJ+a7pzIn+80t9upIHuZq6nBPGpSo4Dcl7YNyth7s7rkyk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785764029; c=relaxed/simple;
	bh=+atSdXlFJqeuAnLw5Co+DVX4SBfjprDSitfNOJKAFfc=;
	h=From:To:Cc:Subject:Message-ID:MIME-Version:Content-Type:Date; b=dAxzSke3Cb3pyRSItAs8MYN9sXFjqrQ4g8U+wpLQHXvmyF/9QyF1P3JZGTg4aXag9QwPI07d0i7O5cfcLpIiuFDbiTdTAdrGog8fKEm+WMZs6tsp5wDKBmncNRQAF7d1hobMABRfhPg0ihvWNzxj2ZbvMvK5FZsr+oxByCs1AQI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Gk4e6aKx; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Gk4e6aKx"
Received: by smtp.kernel.org (Postfix) with UTF8SMTPSA id 881861F00A3A;
	Mon,  3 Aug 2026 13:33:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1785764020;
	bh=X0b6KCjcsjyDxUxll3VOITisu/QFQ1UP8Zr4TwbOI90=;
	h=From:To:Cc:Subject:Date;
	b=Gk4e6aKxLbE/kdktq5/tlksbgh7z9qRU+HDPvGqzPTLUvPrZPnOKBUPuQYbNmusVz
	 uD0Ez6VHKirKKZsGJNYIgUwRQRbaX3cjH8bDrfkwymhwI8M1moC3yOCkwh4jv9KppC
	 oqJ545Qb1fkP2F4pZOqtnOLByfCcTS518NnIeH8hS+DD0nYTW+A6keGuu0RIsTs5hX
	 y7/Oh7w7vSFB+C0E/NMNvRfYXULwrzeaRU568j89GWqha0jxd3YEnowMIwZRMIBT6P
	 5uatCPGgRKbrzuyspI+ok7f0NCzN0/1G/Vg4+LyvE49Sc+W44Ot7sHXqfGBXCLOSWy
	 AeXY5OCVOPOjA==
From: "syzbot" <syzbot@kernel.org>
To: syzkaller-upstream-moderation@googlegroups.com
Cc: syzbot@lists.linux.dev
Subject: [PATCH RFC] usb: gadget: f_tcm: Fix circular locking dependency
Message-ID: <1053cf17-d7b2-4199-b802-f02b67857d92@mail.kernel.org>
Precedence: bulk
X-Mailing-List: syzbot@lists.linux.dev
List-Id: <syzbot.lists.linux.dev>
List-Subscribe: <mailto:syzbot+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:syzbot+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Date: Mon,  3 Aug 2026 13:33:40 +0000 (UTC)

A circular locking dependency was detected involving `inode_lock`,
`gadget_subsys.su_mutex`, `opts->dep_lock`, and `tpg_instances_lock`.

The cycle is formed by the following chains:

1. `inode_lock` -> `gadget_subsys.su_mutex`: When creating a symlink in
configfs (e.g., for UVC extensions), the VFS layer calls configfs_symlink()
with the inode_lock of the parent directory held. configfs_symlink() then
calls the allow_link callback, which acquires gadget_subsys.su_mutex.

2. `gadget_subsys.su_mutex` -> `opts->dep_lock` / `tpg_instances_lock`:
When creating a new TCM USB gadget function directory, configfs_mkdir()
acquires gadget_subsys.su_mutex and calls function_make(). This calls
tcm_set_name(), which acquires opts->dep_lock. It also acquires
tpg_instances_lock during instance allocation.

3. `opts->dep_lock` / `tpg_instances_lock` -> `inode_lock`: When creating a
new Target Portal Group (TPG) directory for the TCM USB gadget,
usbg_make_tpg() is called. It acquires tpg_instances_lock and
opts->dep_lock. While holding these locks, it calls
configfs_depend_item_unlocked(), which acquires the inode_lock of the
configfs root directory.

This leads to the following lockdep splat:

======================================================
WARNING: possible circular locking dependency detected
------------------------------------------------------
task is trying to acquire lock:
(gadget_subsys.su_mutex){+.+.}-{4:4}, at:
uvcg_extension_allow_link+0x70/0x1f8

but task is already holding lock:
(&sb->s_type->i_mutex_key#23){+.+.}-{4:4}, at: inode_lock
include/linux/fs.h:1024 [inline]

which lock already depends on the new lock.

the existing dependency chain (in reverse order) is:

-> #2 (&sb->s_type->i_mutex_key#23){+.+.}-{4:4}:
       inode_lock include/linux/fs.h:1024 [inline]
       configfs_depend_item_unlocked+0x154/0x344 fs/configfs/dir.c:1259
       usbg_make_tpg+0x230/0x4b4 drivers/usb/gadget/function/f_tcm.c:1686
       target_fabric_make_tpg+0x98/0x518
       drivers/target/target_core_fabric_configfs.c:939
       configfs_mkdir+0x374/0x7d4 fs/configfs/dir.c:1360

-> #1 (&opts->dep_lock){+.+.}-{4:4}:
       __mutex_lock+0x164/0xf14 kernel/locking/mutex.c:821
       tcm_set_name+0x34/0xd0 drivers/usb/gadget/function/f_tcm.c:2669
       function_make+0x18c/0x300 drivers/usb/gadget/configfs.c:636
       configfs_mkdir+0x374/0x7d4 fs/configfs/dir.c:1360

-> #0 (gadget_subsys.su_mutex){+.+.}-{4:4}:
       __mutex_lock+0x164/0xf14 kernel/locking/mutex.c:821
       uvcg_extension_allow_link+0x70/0x1f8
       drivers/usb/gadget/function/uvc_configfs.c:1195
       configfs_symlink+0x478/0xde0 fs/configfs/symlink.c:196

To break the cycle, we must drop both opts->dep_lock and tpg_instances_lock
before calling configfs_depend_item_unlocked() in usbg_make_tpg() and
configfs_undepend_item_unlocked() in usbg_drop_tpg().

Dropping tpg_instances_lock introduces two potential race conditions that
are handled as follows:

1. Slot Reservation Race: usbg_make_tpg() finds a free slot by checking
!tpg_instances[i].tpg. To prevent a concurrent usbg_make_tpg() from picking
the same slot after the lock is dropped, we allocate the tpg structure and
assign it to tpg_instances[i].tpg before dropping the lock.

2. Use-After-Free Race: A concurrent removal of the function directory
could trigger tcm_free_inst(), freeing the opts structure. To prevent this,
we take a temporary reference on the configfs item using config_item_get()
before dropping the lock, and release it with config_item_put() afterwards.

Similarly, in usbg_drop_tpg(), we delay setting tpg_instances[i].tpg = NULL
until after we have called configfs_undepend_item_unlocked() and
re-acquired the lock, keeping the slot reserved.

Fixes: 4bb8548df632 ("usb: gadget: f_tcm: add configfs support")
Assisted-by: Gemini:gemini-3.5-flash Gemini:gemini-3.1-pro-preview syzbot
Reported-by: syzbot+b3410eb576b568216ae5@syzkaller.appspotmail.com
Closes: https://syzkaller.appspot.com/bug?extid=b3410eb576b568216ae5
Link: https://syzkaller.appspot.com/ai_job?id=deadd783-1210-4cb4-976a-2e037b0ca322
To: "Greg Kroah-Hartman" <gregkh@linuxfoundation.org>
To: <linux-usb@vger.kernel.org>
To: "Andrzej Pietrasiewicz" <andrzej.p@samsung.com>
Cc: "Jiasheng Jiang" <jiashengjiangcool@gmail.com>
Cc: <linux-kernel@vger.kernel.org>
Cc: "Cen Zhang" <zzzccc427@gmail.com>

---
diff --git a/drivers/usb/gadget/function/f_tcm.c b/drivers/usb/gadget/function/f_tcm.c
index b3fa5a17f..e5fbb8ca0 100644
--- a/drivers/usb/gadget/function/f_tcm.c
+++ b/drivers/usb/gadget/function/f_tcm.c
@@ -1660,6 +1660,7 @@ static struct se_portal_group *usbg_make_tpg(struct se_wwn *wwn,
 	int ret;
 	struct f_tcm_opts *opts;
 	unsigned i;
+	bool has_dep;
 
 	if (strstr(name, "tpgt_") != name)
 		return ERR_PTR(-EINVAL);
@@ -1676,19 +1677,19 @@ static struct se_portal_group *usbg_make_tpg(struct se_wwn *wwn,
 	opts = container_of(tpg_instances[i].func_inst, struct f_tcm_opts,
 		func_inst);
 	mutex_lock(&opts->dep_lock);
-	if (!opts->ready)
-		goto unlock_dep;
+	if (!opts->ready) {
+		mutex_unlock(&opts->dep_lock);
+		goto unlock_inst;
+	}
 
-	if (opts->has_dep) {
-		if (!try_module_get(opts->dependent))
-			goto unlock_dep;
-	} else {
-		ret = configfs_depend_item_unlocked(
-			wwn->wwn_group.cg_subsys,
-			&opts->func_inst.group.cg_item);
-		if (ret)
-			goto unlock_dep;
+	has_dep = opts->has_dep;
+	if (has_dep) {
+		if (!try_module_get(opts->dependent)) {
+			mutex_unlock(&opts->dep_lock);
+			goto unlock_inst;
+		}
 	}
+	mutex_unlock(&opts->dep_lock);
 
 	tpg = kzalloc_obj(struct usbg_tpg);
 	ret = -ENOMEM;
@@ -1704,31 +1705,44 @@ static struct se_portal_group *usbg_make_tpg(struct se_wwn *wwn,
 	tpg->tport = tport;
 	tpg->tport_tpgt = tpgt;
 
+	tpg_instances[i].tpg = tpg;
+	tpg->fi = tpg_instances[i].func_inst;
+
+	config_item_get(&opts->func_inst.group.cg_item);
+	mutex_unlock(&tpg_instances_lock);
+
+	if (!has_dep) {
+		ret = configfs_depend_item_unlocked(
+			wwn->wwn_group.cg_subsys,
+			&opts->func_inst.group.cg_item);
+		if (ret)
+			goto put_item;
+	}
+
 	/*
 	 * SPC doesn't assign a protocol identifier for USB-SCSI, so we
 	 * pretend to be SAS..
 	 */
 	ret = core_tpg_register(wwn, &tpg->se_tpg, SCSI_PROTOCOL_SAS);
 	if (ret < 0)
-		goto free_workqueue;
+		goto undepend_item;
 
-	tpg_instances[i].tpg = tpg;
-	tpg->fi = tpg_instances[i].func_inst;
-	mutex_unlock(&opts->dep_lock);
-	mutex_unlock(&tpg_instances_lock);
+	config_item_put(&opts->func_inst.group.cg_item);
 	return &tpg->se_tpg;
 
-free_workqueue:
+undepend_item:
+	if (!has_dep)
+		configfs_undepend_item_unlocked(&opts->func_inst.group.cg_item);
+put_item:
+	config_item_put(&opts->func_inst.group.cg_item);
 	destroy_workqueue(tpg->workqueue);
+	mutex_lock(&tpg_instances_lock);
+	tpg_instances[i].tpg = NULL;
 free_tpg:
 	kfree(tpg);
 unref_dep:
-	if (opts->has_dep)
+	if (has_dep)
 		module_put(opts->dependent);
-	else
-		configfs_undepend_item_unlocked(&opts->func_inst.group.cg_item);
-unlock_dep:
-	mutex_unlock(&opts->dep_lock);
 unlock_inst:
 	mutex_unlock(&tpg_instances_lock);
 
@@ -1743,6 +1757,7 @@ static void usbg_drop_tpg(struct se_portal_group *se_tpg)
 				struct usbg_tpg, se_tpg);
 	unsigned i;
 	struct f_tcm_opts *opts;
+	bool has_dep;
 
 	tcm_usbg_drop_nexus(tpg);
 	core_tpg_deregister(se_tpg);
@@ -1753,16 +1768,28 @@ static void usbg_drop_tpg(struct se_portal_group *se_tpg)
 		if (tpg_instances[i].tpg == tpg)
 			break;
 	if (i < TPG_INSTANCES) {
-		tpg_instances[i].tpg = NULL;
 		opts = container_of(tpg_instances[i].func_inst,
 			struct f_tcm_opts, func_inst);
 		mutex_lock(&opts->dep_lock);
-		if (opts->has_dep)
+		has_dep = opts->has_dep;
+		mutex_unlock(&opts->dep_lock);
+
+		config_item_get(&opts->func_inst.group.cg_item);
+		mutex_unlock(&tpg_instances_lock);
+
+		if (has_dep)
 			module_put(opts->dependent);
 		else
 			configfs_undepend_item_unlocked(
 				&opts->func_inst.group.cg_item);
-		mutex_unlock(&opts->dep_lock);
+
+		mutex_lock(&tpg_instances_lock);
+		tpg_instances[i].tpg = NULL;
+		mutex_unlock(&tpg_instances_lock);
+
+		config_item_put(&opts->func_inst.group.cg_item);
+		kfree(tpg);
+		return;
 	}
 	mutex_unlock(&tpg_instances_lock);
 


base-commit: 075b74841bd0065a3bda3440873c747938e69b68
-- 
This is an AI-generated patch subject to moderation.
Reply with '#syz upstream' to Sign-off the patch as a human author
and send it to the upstream kernel mailing lists.
Reply with '#syz reject' to reject it ('#syz unreject' to undo).

See https://goo.gle/syzbot-ai-patches for information about AI-generated patches.
You can comment on the patch as usual, syzbot will try to address
the comments and send a new version of the patch if necessary.
syzbot engineers can be reached at syzkaller@googlegroups.com.
