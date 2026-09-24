Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C4A57476CC6
	for <syzbot@lists.linux.dev>; Thu, 24 Sep 2026 21:01:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790283689; cv=none; b=epj6d9OnzVBES/kdhJ5/wAzSod2RJRzCT2G5XFY6O4MSw2ER6BHQoJ6TbrGHO5eNPVPMFuC7VHpHHAxP+JxWS8APU2U/Yd9JM8kijXvN/qWkXAQb/uwLTnuDVH9NHYLCqfQcfq1PvcFK1GoMiXg3EYrpE/6dIlHdvwmT+KqJJOo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790283689; c=relaxed/simple;
	bh=+twgyE+ke/lnUVfH1iGSRe0wxeVpyYFFHTkr1PD0BNI=;
	h=From:To:Cc:Subject:Message-ID:MIME-Version:Content-Type:Date; b=lrWgO6ep/zm2f1Et8xgBzAs4Unm/xaDalrHU+nsMnB5mR8B+ZcoGoq2HRZZcJ0cHECeVvTWghy2EbMFFI0nohSqvlIy6nF/Uddv1+Z7IOaJM+pt3R1ztM45Zg8ZRJcZsXnWLKfdamf5F4D3qGGBTlNm8208yZOoOLdjWiD/Q/ek=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Rtij5zYh; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Rtij5zYh"
Received: by smtp.kernel.org (Postfix) with UTF8SMTPSA id 0B6FC1F00893;
	Thu, 24 Sep 2026 21:01:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1790283685;
	bh=GM3TqanimrZpxHNr0dp91FqBJegvML/l/XNXVZv1ofo=;
	h=From:To:Cc:Subject:Date;
	b=Rtij5zYhe6HAsuETnr8hm7UkxPANSc/w0wdAhbox4NEeJ13ZVpBxoETGkhImQZvdu
	 wtsRZv1RxVqpmV41X37zFZSUbYTft9D96ADpLTpx6AIuuyd7RtoXlSjt8Eg8lxeYDm
	 +HYcgUZq0ZVO9r8HlSCLogX69uyh5b72d76NzIkRyRHkL48XkbuEOEnv4bdmiUzx2z
	 din19TQnQF+BrrCQqoCW4X0Z077ed+RVu7MPyP0Njv8+vBDfrfHbA/zyKkeBI2vZO8
	 Oy0axAvmhuKr2Xf8LSPR7uWJ6rOHlaoTQRUlx61pIwf3lpPn8X1YUQqD3NTkjEndlh
	 IPLWXjEnrGXJg==
From: "syzbot" <syzbot@kernel.org>
To: syzkaller-upstream-moderation@googlegroups.com
Cc: syzbot@lists.linux.dev
Subject: [PATCH RFC] usb: gadget: f_tcm: fix circular locking dependency in usbg_make_tpg()
Message-ID: <d336f46d-4fb6-4c72-9588-d43329617f60@mail.kernel.org>
Precedence: bulk
X-Mailing-List: syzbot@lists.linux.dev
List-Id: <syzbot.lists.linux.dev>
List-Subscribe: <mailto:syzbot+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:syzbot+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Date: Thu, 24 Sep 2026 21:01:25 +0000 (UTC)

Lockdep detected a circular locking dependency between the configfs
directory inode lock (&sb->s_type->i_mutex_key), gadget_subsys.su_mutex,
func_lock, and tpg_instances_lock. When creating a symlink in configfs (for
example, in uvcg_streaming_header_allow_link()), configfs_symlink()
acquires the directory inode lock and invokes allow_link(), which acquires
gadget_subsys.su_mutex. When creating a USB function directory (e.g. mkdir
functions/tcm.usb0), configfs_mkdir() acquires gadget_subsys.su_mutex and
calls function_make() -> usb_get_function_instance(), acquiring func_lock
and invoking tcm_alloc_inst(), which acquires tpg_instances_lock. Finally,
when creating a Target Portal Group directory (e.g. mkdir tpgt_1),
target_fabric_make_tpg() calls usbg_make_tpg(), which acquires
tpg_instances_lock and invokes configfs_depend_item_unlocked(). Because the
dependent target item belongs to a different subsystem (gadget_subsys vs
target_fabric_configfs), configfs_depend_item_unlocked() acquires the
configfs root directory inode lock.

Commit 9dbf74f4022f ("usb: gadget: f_tcm: fix deadlock in usbg_make_tpg()")
previously removed dep_lock from usbg_make_tpg() to avoid a circular
dependency with configfs_rmdir(). However, tpg_instances_lock remained held
across the call to configfs_depend_item_unlocked(), creating the same
circular locking dependency:

WARNING: possible circular locking dependency detected
a task is trying to acquire lock:
ffffffff8f1f06e0 (gadget_subsys.su_mutex){+.+.}-{4:4}, at:
uvcg_streaming_header_allow_link+0x75/0x4d0
drivers/usb/gadget/function/uvc_configfs.c:1750

but task is already holding lock:
ffff8881b10421e8 (&sb->s_type->i_mutex_key#24){+.+.}-{4:4}, at:
configfs_symlink+0x4d0/0x11d0 fs/configfs/symlink.c:201

which lock already depends on the new lock.

the existing dependency chain (in reverse order) is:

 -> #3 (&sb->s_type->i_mutex_key#24){+.+.}-{4:4}:
        down_write+0x3a/0x50 kernel/locking/rwsem.c:1631
        configfs_depend_item_unlocked+0x153/0x420 fs/configfs/dir.c:1268
        usbg_make_tpg+0x1e0/0x550 drivers/usb/gadget/function/f_tcm.c:1692
        target_fabric_make_tpg+0xa8/0x6d0
        drivers/target/target_core_fabric_configfs.c:947
        configfs_mkdir+0x4f6/0x9e0 fs/configfs/dir.c:1369

 -> #2 (tpg_instances_lock){+.+.}-{4:4}:
        tcm_alloc_inst+0x65/0x1a0 drivers/usb/gadget/function/f_tcm.c:2687
        usb_get_function_instance+0xe3/0x2f0
        drivers/usb/gadget/functions.c:44
        function_make+0x127/0x360 drivers/usb/gadget/configfs.c:626
        configfs_mkdir+0x4f6/0x9e0 fs/configfs/dir.c:1369

 -> #1 (func_lock){+.+.}-{4:4}:
        usb_get_function_instance+0x2e/0x2f0
        drivers/usb/gadget/functions.c:44
        function_make+0x127/0x360 drivers/usb/gadget/configfs.c:626
        configfs_mkdir+0x4f6/0x9e0 fs/configfs/dir.c:1369

 -> #0 (gadget_subsys.su_mutex){+.+.}-{4:4}:
        uvcg_streaming_header_allow_link+0x75/0x4d0
        drivers/usb/gadget/function/uvc_configfs.c:1750
        configfs_symlink+0x74e/0x11d0 fs/configfs/symlink.c:211

Chain exists of:
  gadget_subsys.su_mutex --> tpg_instances_lock -->
  &sb->s_type->i_mutex_key#24

Fix this by dropping tpg_instances_lock before calling
configfs_depend_item_unlocked() in usbg_make_tpg().

Safely dropping tpg_instances_lock requires addressing several lifecycle
and concurrency invariants. First, before releasing the lock, obtain a
reference using
config_item_get_unless_zero(&opts->func_inst.group.cg_item). If the
function instance is already being torn down concurrently via
configfs_rmdir(), its refcount is zero and tcm_free_inst() is waiting for
tpg_instances_lock; attempting an unconditional config_item_get() would
trigger an addition-on-zero refcount warning and allow tcm_free_inst() to
free opts as soon as the lock is dropped, leading to a use-after-free. If
config_item_get_unless_zero() returns NULL, abort immediately with -ENODEV.
Second, after re-acquiring tpg_instances_lock, verify that the instance
slot remains valid and has not been claimed concurrently
(tpg_instances[i].func_inst == &opts->func_inst && !tpg_instances[i].tpg).
If another thread claimed it, clean up via
configfs_undepend_item_unlocked() and return -EBUSY. Finally, ensure that
config_item_put(&opts->func_inst.group.cg_item) is called strictly after
dropping tpg_instances_lock on both the success and error paths, preventing
self-deadlock since tcm_free_inst() acquires tpg_instances_lock.

Fixes: 4bb8548df632 ("usb: gadget: f_tcm: add configfs support")
Assisted-by: Gemini:gemini-3.8-flash Gemini:gemini-3.1-pro-preview syzbot
Reported-by: syzbot+ed4b9a6a61280b24d9c3@syzkaller.appspotmail.com
Closes: https://syzkaller.appspot.com/bug?extid=ed4b9a6a61280b24d9c3
Link: https://syzkaller.appspot.com/ai_job?id=f2f15bbe-0acd-4ca3-90d4-55830859cd45
To: "Greg Kroah-Hartman" <gregkh@linuxfoundation.org>
To: <linux-usb@vger.kernel.org>
To: "Andrzej Pietrasiewicz" <andrzej.p@samsung.com>
Cc: "Jiasheng Jiang" <jiashengjiangcool@gmail.com>
Cc: <linux-kernel@vger.kernel.org>
Cc: "Yun Zhou" <yun.zhou@windriver.com>
Cc: "Cen Zhang" <zzzccc427@gmail.com>

---
diff --git a/drivers/usb/gadget/function/f_tcm.c b/drivers/usb/gadget/function/f_tcm.c
index 9e6d4f399..9a3774781 100644
--- a/drivers/usb/gadget/function/f_tcm.c
+++ b/drivers/usb/gadget/function/f_tcm.c
@@ -1658,8 +1658,9 @@ static struct se_portal_group *usbg_make_tpg(struct se_wwn *wwn,
 	struct usbg_tpg *tpg;
 	u16 tpgt;
 	int ret;
-	struct f_tcm_opts *opts;
+	struct f_tcm_opts *opts = NULL;
 	unsigned i;
+	bool drop_ref = false;
 
 	if (strstr(name, "tpgt_") != name)
 		return ERR_PTR(-EINVAL);
@@ -1685,15 +1686,33 @@ static struct se_portal_group *usbg_make_tpg(struct se_wwn *wwn,
 		/*
 		 * configfs_depend_item_unlocked() may acquire the configfs
 		 * root inode lock when the target belongs to a different
-		 * subsystem. Calling it under dep_lock would create a
+		 * subsystem. Calling it under tpg_instances_lock would create a
 		 * circular dependency:
-		 *   dep_lock -> configfs inode lock -> su_mutex -> dep_lock
+		 *   tpg_instances_lock -> configfs inode lock -> su_mutex ->
+		 *     func_lock -> tpg_instances_lock
+		 * Drop tpg_instances_lock around the call, holding a reference
+		 * to the config_item to prevent it from being freed.
 		 */
+		if (!config_item_get_unless_zero(&opts->func_inst.group.cg_item)) {
+			ret = -ENODEV;
+			goto unlock_inst;
+		}
+		drop_ref = true;
+		mutex_unlock(&tpg_instances_lock);
+
 		ret = configfs_depend_item_unlocked(
 			wwn->wwn_group.cg_subsys,
 			&opts->func_inst.group.cg_item);
+
+		mutex_lock(&tpg_instances_lock);
 		if (ret)
 			goto unlock_inst;
+
+		if (tpg_instances[i].func_inst != &opts->func_inst ||
+		    tpg_instances[i].tpg) {
+			ret = -EBUSY;
+			goto unref_dep;
+		}
 	}
 
 	tpg = kzalloc_obj(struct usbg_tpg);
@@ -1721,6 +1740,10 @@ static struct se_portal_group *usbg_make_tpg(struct se_wwn *wwn,
 	tpg_instances[i].tpg = tpg;
 	tpg->fi = tpg_instances[i].func_inst;
 	mutex_unlock(&tpg_instances_lock);
+
+	if (drop_ref)
+		config_item_put(&opts->func_inst.group.cg_item);
+
 	return &tpg->se_tpg;
 
 free_workqueue:
@@ -1734,6 +1757,8 @@ static struct se_portal_group *usbg_make_tpg(struct se_wwn *wwn,
 		configfs_undepend_item_unlocked(&opts->func_inst.group.cg_item);
 unlock_inst:
 	mutex_unlock(&tpg_instances_lock);
+	if (drop_ref)
+		config_item_put(&opts->func_inst.group.cg_item);
 
 	return ERR_PTR(ret);
 }


base-commit: 93f51579e7df248780214094418f205253383cc5
-- 
This is an AI-generated patch subject to moderation.
Reply with '#syz upstream' to Sign-off the patch as a human author
and send it to the upstream kernel mailing lists.
Reply with '#syz reject' to reject it ('#syz unreject' to undo).

See https://goo.gle/syzbot-ai-patches for information about AI-generated patches.
You can comment on the patch as usual, syzbot will try to address
the comments and send a new version of the patch if necessary.
syzbot engineers can be reached at syzkaller@googlegroups.com.
