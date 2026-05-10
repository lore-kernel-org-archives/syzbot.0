Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C12C71DF751
	for <syzbot@lists.linux.dev>; Sun, 10 May 2026 01:38:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778377088; cv=none; b=eg17Jzf5WIqpA0uWzUFrBmA/E98xGIrMn3yVyIiEh9HA2El3BRrxe0dtGnRhDAkid3gKLq8M72SC9Kz9Fikr8BRI/GJmHKt3ZYV8bFt+dEa0BwqfqfDxfOeya8pvGt45KQt520spvLu8+ezPxHTOir+mqXUjWSvPeLBoRGXGXss=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778377088; c=relaxed/simple;
	bh=LBm7u4itRtfwC5esM/zbu0IHccr37C1H/0m11VDY0Rw=;
	h=From:To:Cc:Subject:Message-ID:MIME-Version:Content-Type:Date; b=Oh69o3dSaXKJqDJPPL2YMbnbfFeYxuHVAVkC23mk4UOgRYm3NX0Z6sREXPyOvffqD1glBeyoyOEyHYbPp/s6FoVj2OjEjDvHmGGvZ5q06Fq/FhsmKeKj8oTfRegJWNgmPObA/vsEx/KBeF2kPA9Qsnj9ZVlMaDyXfxAbx08jk80=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=CrYaGALK; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="CrYaGALK"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3B7E8C2BCB2;
	Sun, 10 May 2026 01:38:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1778377088;
	bh=LBm7u4itRtfwC5esM/zbu0IHccr37C1H/0m11VDY0Rw=;
	h=From:To:Cc:Subject:Date:From;
	b=CrYaGALKv/ZaZZMGu3aSH9iVM9+1vqaUQHZVBDKHWoE/WB/qdD+QaFYBND77gwZ7W
	 NohPTzZOtMK4EMMemeebzoBYtYjWkkp0IQIUVYYLmnyGuDb8yfzOE6iUziMna4Iebi
	 FBFG5HfJ/3JS7YsUmnEZrlLPHK7lt323Rni1OG+HKPNx53wFyNtgCjiZQQAdYF62pN
	 yZNTyCZmaTRAy+wtfCSwn911UZ/GTmISvbOt+w9WbHZqznq0inxBulYizzRZ3NaSAe
	 kclX1i7YTYXzkd8/KYl1EhCQWJOIqIwmAoRLRPeyn4JdLQQXn/weCxytzHVyUmBi6P
	 KvWGfZcJu4VWw==
From: "syzbot" <syzbot@kernel.org>
To: syzkaller-upstream-moderation@googlegroups.com
Cc: syzbot@lists.linux.dev
Subject: [PATCH RFC] mtd: block2mtd: fix circular locking dependency in block2mtd_setup
Message-ID: <9ceb3eb3-40e2-497b-8d68-257fd88a3946@mail.kernel.org>
Precedence: bulk
X-Mailing-List: syzbot@lists.linux.dev
List-Id: <syzbot.lists.linux.dev>
List-Subscribe: <mailto:syzbot+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:syzbot+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Date: Sun, 10 May 2026 01:38:08 +0000 (UTC)

mtd: block2mtd: fix circular locking dependency in block2mtd_setup

syzkaller reported a circular locking dependency involving the global
param_lock and VFS locks (i_rwsem). The block2mtd driver performs a
synchronous VFS path lookup (kern_path via bdev_file_open_by_path)
inside its module parameter set callback (block2mtd_setup). This
callback is invoked by the sysfs core with param_lock held.

The dependency chain is:
1. i_rwsem -> cgroup_mutex (via cgroup_rmdir)
2. cgroup_mutex -> rtnl_mutex (via cgroup_mkdir -> cgrp_css_online)
3. rtnl_mutex -> param_lock (via mac80211_hwsim_new_radio ->
   ieee80211_rate_control_ops_get)
4. param_lock -> i_rwsem (via block2mtd_setup -> kern_path)

To fix this without breaking existing userspace scripts that expect
synchronous device creation, temporarily drop the param_lock during
the device creation process. This breaks the circular locking
dependency while preserving the synchronous nature of the operation.

To implement this safely, introduce a local mutex (block2mtd_mutex)
to protect the module's internal state (blkmtd_device_list,
block2mtd_paramline, and block2mtd_init_called) from concurrent sysfs
writes, since param_lock will no longer provide this protection during
the critical section.

Summary of changes:
1. Introduce block2mtd_mutex to protect the global blkmtd_device_list
   and early-boot state variables.
2. Drop param_lock in block2mtd_setup using kernel_param_unlock(kp->mod)
   and kernel_param_lock(kp->mod). For built-in modules, kp->mod is
   NULL,
   and these functions correctly unlock/lock the global param_lock.
3. Protect block2mtd_setup with block2mtd_mutex to ensure that
concurrent
   sysfs writes are serialized and the device list is safely updated.
4. Protect block2mtd_init and block2mtd_exit with block2mtd_mutex to
   ensure safe access to blkmtd_device_list and block2mtd_paramline.

The lock ordering is now block2mtd_mutex -> VFS locks (i_rwsem) ->
mtd_table_mutex, which is strictly hierarchical and free of circular
dependencies.

Assisted-by: Gemini:gemini-3.1-pro-preview Gemini:gemini-3-flash-preview
To: <joern@lazybastard.org>
To: <linux-mtd@lists.infradead.org>
Cc: <linux-kernel@vger.kernel.org>
Cc: <miquel.raynal@bootlin.com>
Cc: <richard@nod.at>
Cc: <vigneshr@ti.com>

---
diff --git a/drivers/mtd/devices/block2mtd.c b/drivers/mtd/devices/block2mtd.c
index 03e80b2c4..f813272da 100644
--- a/drivers/mtd/devices/block2mtd.c
+++ b/drivers/mtd/devices/block2mtd.c
@@ -45,7 +45,7 @@ struct block2mtd_dev {
 
 /* Static info about the MTD, used in cleanup_module */
 static LIST_HEAD(blkmtd_device_list);
-
+static DEFINE_MUTEX(block2mtd_mutex);
 
 static struct page *page_read(struct address_space *mapping, pgoff_t index)
 {
@@ -464,28 +464,43 @@ static int block2mtd_setup2(const char *val)
 
 static int block2mtd_setup(const char *val, const struct kernel_param *kp)
 {
+	int ret = 0;
+
+	/*
+	 * Drop the param_lock to avoid circular locking dependency
+	 * with VFS locks during device lookup.
+	 */
+	kernel_param_unlock(kp->mod);
+
+	mutex_lock(&block2mtd_mutex);
+
 #ifdef MODULE
-	return block2mtd_setup2(val);
+	ret = block2mtd_setup2(val);
 #else
 	/* If more parameters are later passed in via
 	   /sys/module/block2mtd/parameters/block2mtd
 	   and block2mtd_init() has already been called,
 	   we can parse the argument now. */
 
-	if (block2mtd_init_called)
-		return block2mtd_setup2(val);
+	if (block2mtd_init_called) {
+		ret = block2mtd_setup2(val);
+	} else {
+		/* During early boot stage, we only save the parameters
+		   here. We must parse them later: if the param passed
+		   from kernel boot command line, block2mtd_setup() is
+		   called so early that it is not possible to resolve
+		   the device (even kmalloc() fails). Deter that work to
+		   block2mtd_setup2(). */
+
+		strscpy(block2mtd_paramline, val, sizeof(block2mtd_paramline));
+	}
+#endif
 
-	/* During early boot stage, we only save the parameters
-	   here. We must parse them later: if the param passed
-	   from kernel boot command line, block2mtd_setup() is
-	   called so early that it is not possible to resolve
-	   the device (even kmalloc() fails). Deter that work to
-	   block2mtd_setup2(). */
+	mutex_unlock(&block2mtd_mutex);
 
-	strscpy(block2mtd_paramline, val, sizeof(block2mtd_paramline));
+	kernel_param_lock(kp->mod);
 
-	return 0;
-#endif
+	return ret;
 }
 
 
@@ -497,9 +512,11 @@ static int __init block2mtd_init(void)
 	int ret = 0;
 
 #ifndef MODULE
+	mutex_lock(&block2mtd_mutex);
 	if (strlen(block2mtd_paramline))
 		ret = block2mtd_setup2(block2mtd_paramline);
 	block2mtd_init_called = 1;
+	mutex_unlock(&block2mtd_mutex);
 #endif
 
 	return ret;
@@ -511,6 +528,7 @@ static void block2mtd_exit(void)
 	struct list_head *pos, *next;
 
 	/* Remove the MTD devices */
+	mutex_lock(&block2mtd_mutex);
 	list_for_each_safe(pos, next, &blkmtd_device_list) {
 		struct block2mtd_dev *dev = list_entry(pos, typeof(*dev), list);
 		block2mtd_sync(&dev->mtd);
@@ -522,6 +540,7 @@ static void block2mtd_exit(void)
 		list_del(&dev->list);
 		block2mtd_free_device(dev);
 	}
+	mutex_unlock(&block2mtd_mutex);
 }
 
 late_initcall(block2mtd_init);


base-commit: 7fd2df204f342fc17d1a0bfcd474b24232fb0f32
-- 
This is an AI-generated patch subject to moderation.
Reply with '#syz upstream' to send it to the mailing list.
Reply with '#syz reject' to reject it.

See  for more information.
