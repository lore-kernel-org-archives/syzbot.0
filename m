Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C4CE0344D8C
	for <syzbot@lists.linux.dev>; Fri, 29 May 2026 16:19:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780071548; cv=none; b=rKcFxK5SrP1T4YeVD5OuWvkmbfPqpeBdHdfPcN0TshihKwsPiiXvtWOCWawJE+jjnA9HvWYMsGmgIaPA6Smz5V0GrXiENkY4+VMTcRNbFSrz6QcBYSkK+NGmu2xb3kBUX8k31pn1She83X/gIJwnxe4c5XSCjiTk1O5RV3CyS7I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780071548; c=relaxed/simple;
	bh=g+fyk9DeosgS+2UpuZyYprJwSi6rLbqQRKPTVWdljNE=;
	h=From:To:Cc:Subject:Message-ID:MIME-Version:Content-Type:Date; b=L7jQMnaPSHRjDUd99EiaVyAIbw922tsMDc6a5ylqPZQCTEuXhNLXEeXX4qn6jt8uzPFPJIZruesCTidq4kz6shA6Gw51VZuENnCV1/HSKb6QSzvAsvZEoc7WxVFouogvU5C4ly1eo5i+yNwrF+OW/WRF1xgeFFiuANeEv/vhE/w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=H4tGUqou; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="H4tGUqou"
Received: by smtp.kernel.org (Postfix) with UTF8SMTPSA id 586461F00893;
	Fri, 29 May 2026 16:19:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1780071546;
	bh=e8kX1zNAzmZDyW7tV2nhzmQ2da0k/qrU+vBRHSIarfc=;
	h=From:To:Cc:Subject:Date;
	b=H4tGUqouEaVDHanf8tjHZ3isHmObHTL6NBdd6dgdS7qRujLZWSKVeBrvk4tO94RY2
	 4aMhMDVpYOa764N5aMFNiAnZgwHdLs/bWj43MLq6x7zAiTs9/dbOeuMfBBsCbbF86H
	 RhTDNrcCdn2LqrgZYOE8pVdzQx94b5/gfe5egJSH1dN+uY6GmmxvFld9YMUxxx2b1C
	 ArXFvFZnW8o3cAp/ikEgym/W/jaDymKMgmb1+MfDeBLOD3UZ8VefXADSR+ptgEL5ZG
	 8eIy2JHkmo8Sq82iBgfgVjgaD/fGoMrMuMYsms0C2ZeSj/4JWpLJK0MxR6Z3Bvogqa
	 e2AW9b1tOz46w==
From: "syzbot" <syzbot@kernel.org>
To: syzkaller-upstream-moderation@googlegroups.com
Cc: syzbot@lists.linux.dev
Subject: [PATCH RFC v3] mtd: block2mtd: fix circular locking dependency in block2mtd_setup
Message-ID: <531b131a-50cc-44cf-8d62-41fe345c4cf1@mail.kernel.org>
Precedence: bulk
X-Mailing-List: syzbot@lists.linux.dev
List-Id: <syzbot.lists.linux.dev>
List-Subscribe: <mailto:syzbot+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:syzbot+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Date: Fri, 29 May 2026 16:19:06 +0000 (UTC)

A circular locking dependency was reported involving the global param_lock
and VFS locks (i_rwsem). The block2mtd driver performs a synchronous VFS
path lookup (kern_path via bdev_file_open_by_path) inside its module
parameter set callback (block2mtd_setup). This callback is invoked by the
sysfs core with param_lock held.

The dependency chain is:
1. i_rwsem -> cgroup_mutex (via cgroup_rmdir)
2. cgroup_mutex -> rtnl_mutex (via cgroup_mkdir -> cgrp_css_online)
3. rtnl_mutex -> param_lock (via mac80211_hwsim_new_radio ->
ieee80211_rate_control_ops_get)
4. param_lock -> i_rwsem (via block2mtd_setup -> kern_path)

To fix this without breaking existing userspace scripts that expect
synchronous device creation, temporarily drop the param_lock during the
device creation process. This breaks the circular locking dependency while
preserving the synchronous nature of the operation.

Since dropping param_lock allows the module to be unloaded while the
callback is still executing, use try_module_get() and module_put() to
prevent a use-after-free race condition.

To implement this safely, introduce a local mutex (block2mtd_mutex) to
protect the module's internal state (blkmtd_device_list,
block2mtd_paramline, and block2mtd_init_called) from concurrent sysfs
writes, since param_lock will no longer provide this protection during the
critical section.

The lock ordering is now block2mtd_mutex -> VFS locks (i_rwsem) ->
mtd_table_mutex, which is strictly hierarchical and free of circular
dependencies.

Fixes: f9d8c3c4236e ("block2mtd: port device access to files")
Assisted-by: Gemini:gemini-3.1-pro-preview Gemini:gemini-3-flash-preview syzbot
Reported-by: syzbot+65459fd3b61877d717a3@syzkaller.appspotmail.com
Closes: https://syzkaller.appspot.com/bug?extid=65459fd3b61877d717a3
Link: https://syzkaller.appspot.com/ai_job?id=282a0acf-5eb7-43ae-9083-45ec7febd075
To: "Joern Engel" <joern@lazybastard.org>
To: <linux-mtd@lists.infradead.org>
To: "Miquel Raynal" <miquel.raynal@bootlin.com>
To: "Richard Weinberger" <richard@nod.at>
To: "Vignesh Raghavendra" <vigneshr@ti.com>
Cc: <linux-kernel@vger.kernel.org>

---
v3:
- Added try_module_get() and module_put() in block2mtd_setup() to prevent a use-after-free race condition during module unloading.
- Introduced block2mtd_mutex to protect internal state (blkmtd_device_list, block2mtd_paramline, and block2mtd_init_called) from concurrent access.
- Temporarily drop param_lock during device lookup in block2mtd_setup() to break the circular locking dependency.

v2:
- Added comments in block2mtd_init() and block2mtd_exit() explaining the need for block2mtd_mutex to protect against concurrent sysfs writes.
https://lore.kernel.org/all/a9d448c8-44ac-4c8c-a391-aad1478a7eb1@mail.kernel.org/T/

v1:
https://lore.kernel.org/all/9ceb3eb3-40e2-497b-8d68-257fd88a3946@mail.kernel.org/T/
---
diff --git a/drivers/mtd/devices/block2mtd.c b/drivers/mtd/devices/block2mtd.c
index 03e80b2c4..cc7054de4 100644
--- a/drivers/mtd/devices/block2mtd.c
+++ b/drivers/mtd/devices/block2mtd.c
@@ -45,7 +45,7 @@ struct block2mtd_dev {
 
 /* Static info about the MTD, used in cleanup_module */
 static LIST_HEAD(blkmtd_device_list);
-
+static DEFINE_MUTEX(block2mtd_mutex);
 
 static struct page *page_read(struct address_space *mapping, pgoff_t index)
 {
@@ -464,28 +464,47 @@ static int block2mtd_setup2(const char *val)
 
 static int block2mtd_setup(const char *val, const struct kernel_param *kp)
 {
+	int ret = 0;
+
+	if (!try_module_get(kp->mod))
+		return -ENODEV;
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
+	module_put(kp->mod);
 
-	return 0;
-#endif
+	return ret;
 }
 
 
@@ -497,9 +516,15 @@ static int __init block2mtd_init(void)
 	int ret = 0;
 
 #ifndef MODULE
+	/*
+	 * block2mtd_mutex protects block2mtd_init_called and
+	 * block2mtd_paramline against concurrent sysfs writes.
+	 */
+	mutex_lock(&block2mtd_mutex);
 	if (strlen(block2mtd_paramline))
 		ret = block2mtd_setup2(block2mtd_paramline);
 	block2mtd_init_called = 1;
+	mutex_unlock(&block2mtd_mutex);
 #endif
 
 	return ret;
@@ -511,6 +536,11 @@ static void block2mtd_exit(void)
 	struct list_head *pos, *next;
 
 	/* Remove the MTD devices */
+	/*
+	 * block2mtd_mutex protects blkmtd_device_list against
+	 * concurrent sysfs writes.
+	 */
+	mutex_lock(&block2mtd_mutex);
 	list_for_each_safe(pos, next, &blkmtd_device_list) {
 		struct block2mtd_dev *dev = list_entry(pos, typeof(*dev), list);
 		block2mtd_sync(&dev->mtd);
@@ -522,6 +552,7 @@ static void block2mtd_exit(void)
 		list_del(&dev->list);
 		block2mtd_free_device(dev);
 	}
+	mutex_unlock(&block2mtd_mutex);
 }
 
 late_initcall(block2mtd_init);


base-commit: 7fd2df204f342fc17d1a0bfcd474b24232fb0f32
-- 
This is an AI-generated patch subject to moderation.
Reply with '#syz upstream' to Sign-off the patch as a human author
and send it to the upstream kernel mailing lists.
Reply with '#syz reject' to reject it ('#syz unreject' to undo).

See https://goo.gle/syzbot-ai-patches for information about AI-generated patches.
You can comment on the patch as usual, syzbot will try to address
the comments and send a new version of the patch if necessary.
syzbot engineers can be reached at syzkaller@googlegroups.com.
