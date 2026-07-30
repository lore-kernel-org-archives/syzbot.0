Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C76714052BB
	for <syzbot@lists.linux.dev>; Thu, 30 Jul 2026 10:54:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785408846; cv=none; b=DeIgRu1Rjw/SH9tfL2XIZ9Iv3QpCdE8S4jTvCar9+eZKmT70uTjkjhpCGX9DVET8Buv/9YWZO8i63SzZhvaDqgTUAsYK6OjJqXCFj9uRDblnGLIOAie1D184aq+3V2diOL5EVA8q0yifmrCx2DGIyksSL+vou3sviUe00MjmBgI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785408846; c=relaxed/simple;
	bh=732sv5HuFbELkxGuyNPt0TTxS0I0n00iC74z4uBGn2E=;
	h=From:To:Cc:Subject:Message-ID:MIME-Version:Content-Type:Date; b=L/3ygaELHTwZqqwTgUmLjhozvf86/6WCiKbtxKC/rBA41MpTcq17kFc/crkxTiVe/BVu7ndjlvDtvLECsCVhbUghr3S53h06uyqcuPONmCRmLQ7XE422pD3ZbdR5h+Yk/eWV3MnxLCNcTh+RHHNuVP/JogDidQoNFplfAaClwmU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=H/relKK6; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="H/relKK6"
Received: by smtp.kernel.org (Postfix) with UTF8SMTPSA id 570CD1F000E9;
	Thu, 30 Jul 2026 10:54:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1785408844;
	bh=qPMyUwZ1baZey0u2Mm/uMHzpseGpWBE7t5DMoUzoJjY=;
	h=From:To:Cc:Subject:Date;
	b=H/relKK6gv/9nFI/JwHdjFvgsyzD7YXspFZ+Ltgph1xIsRWLgaq8PpFXEGLI0hwTh
	 qbYDiFBTSZQiEO8HrBnaZ3uJMdkrdslX814E4/4+6eSkBhhYJawzb19oLKJO48HG84
	 Me1JaGJqhZifYxucZJDHZ6VtGmzYtZ3O9Sqc8Pflm3rdeh01gIp0EPWZNTWPdCm1+H
	 TxTtvrC5F8UWbXh8I9cKDO08eGRtgi++J2rusyohWHFoeiBA6gWHd8jnPmJlGHzgVb
	 QR2uN8rDJp+28k2rSKYTxL4S2klA9baSzs+fUzy7dRaSiOBabmBKFrTWUstRhNPXX5
	 IgKVLhqvcN2Gg==
From: "syzbot" <syzbot@kernel.org>
To: syzkaller-upstream-moderation@googlegroups.com
Cc: syzbot@lists.linux.dev
Subject: [PATCH RFC] usb: gadget: f_tcm: Fix circular locking dependency in TPG creation
Message-ID: <7955f822-f22f-46dd-ad08-eb84e0f958bd@mail.kernel.org>
Precedence: bulk
X-Mailing-List: syzbot@lists.linux.dev
List-Id: <syzbot.lists.linux.dev>
List-Subscribe: <mailto:syzbot+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:syzbot+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Date: Thu, 30 Jul 2026 10:54:04 +0000 (UTC)

A lockdep splat indicates a circular locking dependency involving
`opts->dep_lock`, `inode_lock` (on configfs directories), and
`gadget_subsys.su_mutex`:

======================================================
WARNING: possible circular locking dependency detected
...
syz.0.18/6129 is trying to acquire lock:
ffff8881088cb220 (&sb->s_type->i_mutex_key#24){+.+.}-{4:4}, at: inode_lock
include/linux/fs.h:1024 [inline]
ffff8881088cb220 (&sb->s_type->i_mutex_key#24){+.+.}-{4:4}, at:
configfs_depend_item_unlocked+0x153/0x420 fs/configfs/dir.c:1259

but task is already holding lock:
ffff888110c27110 (&opts->dep_lock){+.+.}-{4:4}, at:
usbg_make_tpg+0x147/0x590 drivers/usb/gadget/function/f_tcm.c:1678
...
Chain exists of:
  &sb->s_type->i_mutex_key#24 --> gadget_subsys.su_mutex -->
  &opts->dep_lock
======================================================

The circular dependency is formed by three concurrent operations: 1.
`usbg_make_tpg()` holds `opts->dep_lock` and calls
`configfs_depend_item_unlocked()`, which acquires the configfs
`inode_lock`. 2. `configfs_rmdir()` holds `inode_lock` and acquires
`gadget_subsys.su_mutex`. 3. `configfs_mkdir()` holds
`gadget_subsys.su_mutex` and calls `function_make()`, which eventually
acquires `opts->dep_lock` via `tcm_set_name()`.

To break this cycle, we must drop `opts->dep_lock` before calling
`configfs_depend_item_unlocked()`. However, doing so while still holding
`tpg_instances_lock` creates a new circular dependency:
`tpg_instances_lock` -> `inode_lock` -> `gadget_subsys.su_mutex` ->
`func_lock` -> `tpg_instances_lock`.

To fix this completely, we must drop both `opts->dep_lock` and
`tpg_instances_lock` before calling into the configfs or module subsystems
(`configfs_depend_item_unlocked()` or `try_module_get()`).

Dropping `tpg_instances_lock` introduces two new challenges: 1.
Concurrency: Another thread calling `usbg_make_tpg()` might find the same
`tpg_instances[i]` and try to use it concurrently. 2. Use-after-free: If
the user concurrently removes the function directory, `tcm_free_inst()`
could be called, freeing the `opts` structure while we are still using it.

To solve these challenges safely, we introduce a boolean `in_use` flag in
`struct tpg_instance` to mark an instance as "currently being configured".
This prevents other threads from picking the same instance while we have
dropped `tpg_instances_lock`. We also take a temporary reference to the
configfs item (`config_item_get_unless_zero()`) while holding
`tpg_instances_lock`. This guarantees that the `opts` structure cannot be
freed by `tcm_free_inst()` while we are doing our setup outside the lock.
The allocation of `tpg` is moved to the beginning of the function to
simplify the error handling path. Finally, we apply the same
reference-taking strategy in `usbg_drop_tpg()` to drop `tpg_instances_lock`
before calling `configfs_undepend_item_unlocked()`.

Fixes: 4bb8548df632 ("usb: gadget: f_tcm: add configfs support")
Assisted-by: Gemini:gemini-3.5-flash Gemini:gemini-3.1-pro-preview syzbot
Reported-by: syzbot+c75a7db5ca6ae96ed2d4@syzkaller.appspotmail.com
Closes: https://syzkaller.appspot.com/bug?extid=c75a7db5ca6ae96ed2d4
Link: https://syzkaller.appspot.com/ai_job?id=3f265cbf-27c7-4edc-a58e-cab50809748f
To: "Greg Kroah-Hartman" <gregkh@linuxfoundation.org>
To: <linux-usb@vger.kernel.org>
To: "Andrzej Pietrasiewicz" <andrzej.p@samsung.com>
Cc: "Jiasheng Jiang" <jiashengjiangcool@gmail.com>
Cc: <linux-kernel@vger.kernel.org>
Cc: "Cen Zhang" <zzzccc427@gmail.com>

---
diff --git a/drivers/usb/gadget/function/f_tcm.c b/drivers/usb/gadget/function/f_tcm.c
index b3fa5a17f..6e195834a 100644
--- a/drivers/usb/gadget/function/f_tcm.c
+++ b/drivers/usb/gadget/function/f_tcm.c
@@ -31,6 +31,7 @@
 struct tpg_instance {
 	struct usb_function_instance	*func_inst;
 	struct usbg_tpg			*tpg;
+	bool				in_use;
 };
 
 static struct tpg_instance tpg_instances[TPG_INSTANCES];
@@ -1665,72 +1666,89 @@ static struct se_portal_group *usbg_make_tpg(struct se_wwn *wwn,
 		return ERR_PTR(-EINVAL);
 	if (kstrtou16(name + 5, 0, &tpgt))
 		return ERR_PTR(-EINVAL);
+
+	tpg = kzalloc_obj(struct usbg_tpg);
+	if (!tpg)
+		return ERR_PTR(-ENOMEM);
+	mutex_init(&tpg->tpg_mutex);
+	atomic_set(&tpg->tpg_port_count, 0);
+	tpg->workqueue = alloc_workqueue("tcm_usb_gadget",
+					 WQ_UNBOUND, WQ_UNBOUND_MAX_ACTIVE);
+	if (!tpg->workqueue) {
+		kfree(tpg);
+		return ERR_PTR(-ENOMEM);
+	}
+
+	tpg->tport = tport;
+	tpg->tport_tpgt = tpgt;
+
 	ret = -ENODEV;
 	mutex_lock(&tpg_instances_lock);
-	for (i = 0; i < TPG_INSTANCES; ++i)
-		if (tpg_instances[i].func_inst && !tpg_instances[i].tpg)
-			break;
-	if (i == TPG_INSTANCES)
-		goto unlock_inst;
+	for (i = 0; i < TPG_INSTANCES; ++i) {
+		if (tpg_instances[i].func_inst && !tpg_instances[i].tpg &&
+		    !tpg_instances[i].in_use) {
+			opts = container_of(tpg_instances[i].func_inst,
+					    struct f_tcm_opts, func_inst);
+			if (config_item_get_unless_zero(&opts->func_inst.group.cg_item))
+				break;
+		}
+	}
+	if (i == TPG_INSTANCES) {
+		mutex_unlock(&tpg_instances_lock);
+		goto free_workqueue;
+	}
+
+	tpg_instances[i].in_use = true;
+	mutex_unlock(&tpg_instances_lock);
 
-	opts = container_of(tpg_instances[i].func_inst, struct f_tcm_opts,
-		func_inst);
 	mutex_lock(&opts->dep_lock);
-	if (!opts->ready)
-		goto unlock_dep;
+	if (!opts->ready) {
+		mutex_unlock(&opts->dep_lock);
+		goto clear_in_use;
+	}
+	mutex_unlock(&opts->dep_lock);
 
 	if (opts->has_dep) {
 		if (!try_module_get(opts->dependent))
-			goto unlock_dep;
+			goto clear_in_use;
 	} else {
 		ret = configfs_depend_item_unlocked(
 			wwn->wwn_group.cg_subsys,
 			&opts->func_inst.group.cg_item);
 		if (ret)
-			goto unlock_dep;
+			goto clear_in_use;
 	}
 
-	tpg = kzalloc_obj(struct usbg_tpg);
-	ret = -ENOMEM;
-	if (!tpg)
-		goto unref_dep;
-	mutex_init(&tpg->tpg_mutex);
-	atomic_set(&tpg->tpg_port_count, 0);
-	tpg->workqueue = alloc_workqueue("tcm_usb_gadget",
-					 WQ_UNBOUND, WQ_UNBOUND_MAX_ACTIVE);
-	if (!tpg->workqueue)
-		goto free_tpg;
-
-	tpg->tport = tport;
-	tpg->tport_tpgt = tpgt;
-
 	/*
 	 * SPC doesn't assign a protocol identifier for USB-SCSI, so we
 	 * pretend to be SAS..
 	 */
 	ret = core_tpg_register(wwn, &tpg->se_tpg, SCSI_PROTOCOL_SAS);
 	if (ret < 0)
-		goto free_workqueue;
+		goto unref_dep;
 
+	mutex_lock(&tpg_instances_lock);
 	tpg_instances[i].tpg = tpg;
 	tpg->fi = tpg_instances[i].func_inst;
-	mutex_unlock(&opts->dep_lock);
+	tpg_instances[i].in_use = false;
 	mutex_unlock(&tpg_instances_lock);
+
+	config_item_put(&opts->func_inst.group.cg_item);
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
-unlock_dep:
-	mutex_unlock(&opts->dep_lock);
-unlock_inst:
+clear_in_use:
+	mutex_lock(&tpg_instances_lock);
+	tpg_instances[i].in_use = false;
 	mutex_unlock(&tpg_instances_lock);
+	config_item_put(&opts->func_inst.group.cg_item);
+free_workqueue:
+	destroy_workqueue(tpg->workqueue);
+	kfree(tpg);
 
 	return ERR_PTR(ret);
 }
@@ -1755,16 +1773,21 @@ static void usbg_drop_tpg(struct se_portal_group *se_tpg)
 	if (i < TPG_INSTANCES) {
 		tpg_instances[i].tpg = NULL;
 		opts = container_of(tpg_instances[i].func_inst,
-			struct f_tcm_opts, func_inst);
-		mutex_lock(&opts->dep_lock);
+				    struct f_tcm_opts, func_inst);
+		config_item_get(&opts->func_inst.group.cg_item);
+	} else {
+		opts = NULL;
+	}
+	mutex_unlock(&tpg_instances_lock);
+
+	if (opts) {
 		if (opts->has_dep)
 			module_put(opts->dependent);
 		else
 			configfs_undepend_item_unlocked(
 				&opts->func_inst.group.cg_item);
-		mutex_unlock(&opts->dep_lock);
+		config_item_put(&opts->func_inst.group.cg_item);
 	}
-	mutex_unlock(&tpg_instances_lock);
 
 	kfree(tpg);
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
