Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8FB34242925
	for <syzbot@lists.linux.dev>; Tue, 13 Oct 2026 01:38:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791855492; cv=none; b=dK3f8K91q9z/YZ8ZTrkBHJfnt3pEN/CRkX/P4pW9la9nG51g3Ge2YetWSEpkYFI/Gxz605sCOPyBq7M1+VlxGfTjolDy+l+aREBFGchRkJ1FMS+L9A9gE38Et7GIaEmRuQeQ9HJj/dTYUI7qQD2+RIr5aAxxsEp6YsYMnpEc2G4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791855492; c=relaxed/simple;
	bh=s3qj2u/ZBbc63L7U+9BfBHWNSwDSIIvtGFgLVlwXOZ8=;
	h=From:To:Cc:Subject:Message-ID:MIME-Version:Content-Type:Date; b=cjCMHlOzNCuQDa8wZPedfJhyk+mds3058PcshxKdEX4F2Wst7a+SOOgP5UXi5nIHsIZDCmbiYAEwJgQ4b0UkxqjFnKWaE2+Uwd/0QUfSiAmM6dSf9NELzsV2hYSFcZHifDngweiB6BO1wQ0/+HlIsjQG9L5DBJ/T0avQq8oJJF8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=APinMoDF; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="APinMoDF"
Received: by smtp.kernel.org (Postfix) with UTF8SMTPSA id 70C101F000FF;
	Tue, 13 Oct 2026 01:38:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1791855490;
	bh=oHnVaLf0giF9j6A51Y2EJMe1Kd9CMVaETDM/u/wfMrc=;
	h=From:To:Cc:Subject:Date;
	b=APinMoDFnJlT4W8k0jIhiZjEk5nfkKw/c962B/900fqQ6s/dccTouD80tyF4HPvSU
	 uHM7ctcU8jMMj97eOpxpQCjXed2MPvD5JGJFRn5S5npDRi19b4BwDLaF2WnzlWWeL6
	 JWRKZEteAH24lZVLp4q36EFGKpqO8nbEP5B/2VQVzZiiS2c+3+IWIXWtaLP0k5E9BB
	 bqPd4qNcWCeEbTwqKFfgbSfOLXinsUuH8r3mF1XOM+fmlGg+x273aAHzfh+TvRhRHr
	 fCJGarmC2ICc/rZFUBhcxUefQ9JpCo6cW0fbkWsdJO8Pryxw2GNDnWN9OiV9/DrDNy
	 ZovU2GDrpISLA==
From: "syzbot" <syzbot@kernel.org>
To: syzkaller-upstream-moderation@googlegroups.com
Cc: syzbot@lists.linux.dev
Subject: [PATCH RFC] usb: gadget: f_tcm: fix circular lock dependency in usbg_make_tpg()
Message-ID: <77d2115f-8e36-403c-bf08-6810b1c6900c@mail.kernel.org>
Precedence: bulk
X-Mailing-List: syzbot@lists.linux.dev
List-Id: <syzbot.lists.linux.dev>
List-Subscribe: <mailto:syzbot+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:syzbot+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Date: Tue, 13 Oct 2026 01:38:10 +0000 (UTC)

A circular locking dependency is detected by lockdep between the VFS
inode_lock of configfs directories (&sb->s_type->i_mutex_key#24) and
tpg_instances_lock during Target Portal Group (TPG) creation in
usbg_make_tpg():

WARNING: possible circular locking dependency detected
...
task is trying to acquire lock:
ffffffff8fc6d8c8 (gadget_subsys.su_mutex){+.+.}-{4:4}, at:
uvcg_extension_allow_link+0x6c/0x1f0
drivers/usb/gadget/function/uvc_configfs.c:1195

but task is already holding lock:
ffff8881f3ef6280 (&sb->s_type->i_mutex_key#24){+.+.}-{4:4}, at: inode_lock
include/linux/fs.h:1024 [inline]
ffff8881f3ef6280 (&sb->s_type->i_mutex_key#24){+.+.}-{4:4}, at:
configfs_symlink+0x4d0/0x11d0 fs/configfs/symlink.c:201

which lock already depends on the new lock.

the existing dependency chain (in reverse order) is:

 -> #3 (&sb->s_type->i_mutex_key#24){+.+.}-{4:4}:
        inode_lock include/linux/fs.h:1024 [inline]
        configfs_depend_item_unlocked+0x153/0x420 fs/configfs/dir.c:1268
        usbg_make_tpg+0x1e0/0x550 drivers/usb/gadget/function/f_tcm.c:1692
        target_fabric_make_tpg+0xa8/0x6d0
        drivers/target/target_core_fabric_configfs.c:947
        configfs_mkdir+0x4f6/0x9e0 fs/configfs/dir.c:1369

 -> #2 (tpg_instances_lock){+.+.}-{4:4}:
        tcm_alloc_inst+0x65/0x1a0 drivers/usb/gadget/function/f_tcm.c:2687
        try_get_usb_function_instance drivers/usb/gadget/functions.c:28
        [inline]
        usb_get_function_instance+0xe3/0x2f0
        drivers/usb/gadget/functions.c:44
        function_make+0x127/0x360 drivers/usb/gadget/configfs.c:626
        configfs_mkdir+0x4f6/0x9e0 fs/configfs/dir.c:1369

 -> #1 (func_lock){+.+.}-{4:4}:
        try_get_usb_function_instance drivers/usb/gadget/functions.c:18
        [inline]
        usb_get_function_instance+0x2e/0x2f0
        drivers/usb/gadget/functions.c:44
        function_make+0x127/0x360 drivers/usb/gadget/configfs.c:626
        configfs_mkdir+0x4f6/0x9e0 fs/configfs/dir.c:1369

 -> #0 (gadget_subsys.su_mutex){+.+.}-{4:4}:
        uvcg_extension_allow_link+0x6c/0x1f0
        drivers/usb/gadget/function/uvc_configfs.c:1195
        configfs_symlink+0x74e/0x11d0 fs/configfs/symlink.c:211

Chain exists of:
  gadget_subsys.su_mutex --> tpg_instances_lock -->
  &sb->s_type->i_mutex_key#24

The dependency chain arises because during gadget function instantiation
(such as creating a tcm.usb0 function directory), the VFS layer acquires
the parent directory inode_lock (&sb->s_type->i_mutex_key#24).
configfs_mkdir() then acquires gadget_subsys.su_mutex and calls
function_make(). This invokes usb_get_function_instance(), which acquires
func_lock and calls tcm_alloc_inst(), which in turn acquires
tpg_instances_lock. This establishes the locking order: inode_lock ->
gadget_subsys.su_mutex -> func_lock -> tpg_instances_lock. Conversely, when
creating a Target Portal Group (TPG) in the target subsystem,
target_fabric_make_tpg() calls usbg_make_tpg(), which acquires
tpg_instances_lock and then calls configfs_depend_item_unlocked(). Because
the target configfs item belongs to a different subsystem (gadget_subsys),
configfs_depend_item_unlocked() acquires the configfs root directory
inode_lock. Since all configfs directories share the same inode_lock class
in lockdep, this creates a circular dependency: inode_lock ->
gadget_subsys.su_mutex -> func_lock -> tpg_instances_lock -> inode_lock.

To break this circular dependency, drop tpg_instances_lock around the call
to configfs_depend_item_unlocked(). This unlock is strictly confined to the
!opts->has_dep branch where configfs_depend_item_unlocked() is invoked,
since the opts->has_dep path only calls try_module_get() and does not
acquire configfs inode locks. Before dropping tpg_instances_lock, pin the
item via config_item_get() to prevent concurrent release or removal. After
configfs_depend_item_unlocked() completes, release the reference with
config_item_put() before re-acquiring tpg_instances_lock so that an
eventual cleanup cannot deadlock on tpg_instances_lock. Finally, once
tpg_instances_lock is re-acquired, verify that the instance slot remains
valid and unassigned (tpg_instances[i].func_inst == &opts->func_inst &&
!tpg_instances[i].tpg); if another thread claimed or changed the slot while
unlocked, unwind the dependency with configfs_undepend_item_unlocked() and
return -EBUSY.

Fixes: 9dbf74f4022f ("usb: gadget: f_tcm: fix deadlock in usbg_make_tpg()")
Assisted-by: Gemini:gemini-3.8-flash Gemini:gemini-3.1-pro-preview syzbot
Reported-by: syzbot+b3410eb576b568216ae5@syzkaller.appspotmail.com
Closes: https://syzkaller.appspot.com/bug?extid=b3410eb576b568216ae5
Link: https://syzkaller.appspot.com/ai_job?id=7da59cc9-b02a-4e8b-a07f-d2df215094c6
To: "Greg Kroah-Hartman" <gregkh@linuxfoundation.org>
To: <linux-usb@vger.kernel.org>
To: "Yun Zhou" <yun.zhou@windriver.com>
Cc: "Jiasheng Jiang" <jiashengjiangcool@gmail.com>
Cc: <linux-kernel@vger.kernel.org>
Cc: "Cen Zhang" <zzzccc427@gmail.com>

---
diff --git a/drivers/usb/gadget/function/f_tcm.c b/drivers/usb/gadget/function/f_tcm.c
index 9e6d4f399..e2399b4cc 100644
--- a/drivers/usb/gadget/function/f_tcm.c
+++ b/drivers/usb/gadget/function/f_tcm.c
@@ -1655,6 +1655,7 @@ static struct se_portal_group *usbg_make_tpg(struct se_wwn *wwn,
 {
 	struct usbg_tport *tport = container_of(wwn, struct usbg_tport,
 			tport_wwn);
+	struct config_item *item;
 	struct usbg_tpg *tpg;
 	u16 tpgt;
 	int ret;
@@ -1682,18 +1683,29 @@ static struct se_portal_group *usbg_make_tpg(struct se_wwn *wwn,
 		if (!try_module_get(opts->dependent))
 			goto unlock_inst;
 	} else {
+		item = config_item_get(&opts->func_inst.group.cg_item);
+		mutex_unlock(&tpg_instances_lock);
+
 		/*
 		 * configfs_depend_item_unlocked() may acquire the configfs
 		 * root inode lock when the target belongs to a different
-		 * subsystem. Calling it under dep_lock would create a
-		 * circular dependency:
-		 *   dep_lock -> configfs inode lock -> su_mutex -> dep_lock
+		 * subsystem. Calling it under tpg_instances_lock would create
+		 * a circular dependency:
+		 *   inode_lock -> su_mutex -> func_lock -> tpg_instances_lock -> inode_lock
 		 */
 		ret = configfs_depend_item_unlocked(
 			wwn->wwn_group.cg_subsys,
-			&opts->func_inst.group.cg_item);
+			item);
+		config_item_put(item);
+
+		mutex_lock(&tpg_instances_lock);
 		if (ret)
 			goto unlock_inst;
+		if (tpg_instances[i].func_inst != &opts->func_inst ||
+		    tpg_instances[i].tpg) {
+			ret = -EBUSY;
+			goto unref_dep;
+		}
 	}
 
 	tpg = kzalloc_obj(struct usbg_tpg);


base-commit: 24a19b953e2a3d0ea5a8c4951a0ab8f32720c907
-- 
This is an AI-generated patch subject to moderation.
Reply with '#syz upstream' to Sign-off the patch as a human author
and send it to the upstream kernel mailing lists.
Reply with '#syz reject' to reject it ('#syz unreject' to undo).

See https://goo.gle/syzbot-ai-patches for information about AI-generated patches.
You can comment on the patch as usual, syzbot will try to address
the comments and send a new version of the patch if necessary.
syzbot engineers can be reached at syzkaller@googlegroups.com.
