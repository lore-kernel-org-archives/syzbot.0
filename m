Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CEDBC322B8F
	for <syzbot@lists.linux.dev>; Thu, 15 Oct 2026 09:35:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792056934; cv=none; b=K9IYvfaO1CjUkE1DBzxwW6/zLdOviTC50oWhLgmsNb7Cwrrf8lvjoso4IaQlMvUiggHNUJReLVZfaVZxwJv0cqVG/5ZdqpvEiyUYqJuLhBDODZbJMZq8xMtM4xoIvI93AYgzw0xssYfceHps8Y2uiqWQhIjwAYccrSzsXO0HdM8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792056934; c=relaxed/simple;
	bh=1D+dqsjgi8GQg/LrHNDXNvHRqCHElOz+ZVQH2+RKvDc=;
	h=From:To:Cc:Subject:Message-ID:MIME-Version:Content-Type:Date; b=oiVZ+kqrhA7RjNz/B9vU0qgVZhY8nCp4p2sd90iwmhRP3ylJ/2B5ljSQ+tonSF81zOnC+G4Ec75Kw7GLU9oScfREc8pb/h/Xj/WTuJouTXyIs5IszfyqVusZn3QsAk8keupq3Ct/dvwcfm6KOxSSzuRAO3YEl2hLjndHgZ9bGiI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=bOs8aJJ2; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="bOs8aJJ2"
Received: by smtp.kernel.org (Postfix) with UTF8SMTPSA id 936611F000C4;
	Thu, 15 Oct 2026 09:35:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1792056931;
	bh=GAhoxHPZobx90nykv6vfBx8IhApBIAVBqJhOZq09QzE=;
	h=From:To:Cc:Subject:Date;
	b=bOs8aJJ2UPcn/PqN5SjkHyfm2fa8sYf6rutcyQ6+Xwd1za8Qu8NlGhDHdkXt9B1ma
	 RcwqENkp4C06hj5Nsm5F4OtmpPuHnggOzn1Lka7ZJvViQ7ZfRWcE6l/bRre+2pQ/9G
	 f/pvsEtoP49hh1LYPlNdpnIHDUfcBlBgwiOx06JjdzQegq97e1xwAvn5qNSvTSEqDP
	 Jdwk7xq2u2CunUs8oTHBkHU1XqLOI+6RiKoQwK7BHg6oAk6YWuJW3dVBrJPu5N2l8E
	 kPj8hDbrg1HXwe4vDTVzN173saPkDr67Iy23+5NJ4G6I46nBW7HZzZILH7hjxTpzmB
	 ncsmTMPdI+lgA==
From: "syzbot" <syzbot@kernel.org>
To: syzkaller-upstream-moderation@googlegroups.com
Cc: sst@poczta.fm, syzbot@lists.linux.dev
Subject: [PATCH RFC v2] usb: gadget: f_tcm: defer TPG assignment to fix circular locking
Message-ID: <93101153-3ab9-47e9-a050-a565e2f46951@mail.kernel.org>
Precedence: bulk
X-Mailing-List: syzbot@lists.linux.dev
List-Id: <syzbot.lists.linux.dev>
List-Subscribe: <mailto:syzbot+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:syzbot+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Date: Thu, 15 Oct 2026 09:35:31 +0000 (UTC)

A circular locking dependency exists between tpg_instances_lock, the
configfs directory inode_lock, and the gadget info lock gi->lock when
configuring TCM gadget functions through configfs.

  WARNING: possible circular locking dependency detected
  ======================================================
  task is trying to acquire lock:
  ffffffff8f24ae58 (tpg_instances_lock){+.+.}-{4:4}, at:
  tcm_alloc+0x21/0x2f0 drivers/usb/gadget/function/f_tcm.c:2734

  but task is already holding lock:
  ffff888192990388 (&gi->lock){+.+.}-{4:4}, at:
  config_usb_cfg_link+0x59/0x260 drivers/usb/gadget/configfs.c:439

  which lock already depends on the new lock.

  the existing dependency chain (in reverse order) is:

   -> #2 (&gi->lock){+.+.}-{4:4}:
         config_usb_cfg_link+0x59/0x260 drivers/usb/gadget/configfs.c:439
         configfs_symlink+0x74e/0x11d0 fs/configfs/symlink.c:211
         vfs_symlink+0x18b/0x330 fs/namei.c:5794

   -> #1 (&sb->s_type->i_mutex_key#24){+.+.}-{4:4}:
         inode_lock include/linux/fs.h:1024 [inline]
         configfs_depend_item_unlocked+0x153/0x420 fs/configfs/dir.c:1268
         usbg_make_tpg+0x1e0/0x550 drivers/usb/gadget/function/f_tcm.c:1692
         target_fabric_make_tpg+0xa8/0x6d0
         drivers/target/target_core_fabric_configfs.c:947
         configfs_mkdir+0x4f6/0x9e0 fs/configfs/dir.c:1369

   -> #0 (tpg_instances_lock){+.+.}-{4:4}:
         tcm_alloc+0x21/0x2f0 drivers/usb/gadget/function/f_tcm.c:2734
         usb_get_function+0x63/0xb0 drivers/usb/gadget/functions.c:61
         config_usb_cfg_link+0x148/0x260 drivers/usb/gadget/configfs.c:469
         configfs_symlink+0x74e/0x11d0 fs/configfs/symlink.c:211

The deadlock arises from two conflicting lock acquisition paths across
configfs:

1. When creating a Target Portal Group (TPG) directory in configfs (e.g.
target/usb_gadget/.../tpgt_1), VFS takes the directory inode_lock. In
usbg_make_tpg(), tpg_instances_lock is acquired. While holding
tpg_instances_lock, usbg_make_tpg() calls configfs_depend_item_unlocked()
to depend on the gadget function item, which acquires the configfs root
directory inode_lock across subsystems (tpg_instances_lock -> inode_lock).

2. When linking the TCM function to a gadget configuration (e.g. symlink
functions/tcm.usb0 configs/c.1/tcm.usb0), VFS acquires the configuration
directory inode_lock. The callback configfs_symlink() calls
config_usb_cfg_link(), acquiring gi->lock. While holding gi->lock,
config_usb_cfg_link() calls usb_get_function(), invoking tcm_alloc(). In
tcm_alloc(), tpg_instances_lock was acquired to search the tpg_instances
array and set fu->tpg (inode_lock -> gi->lock -> tpg_instances_lock).

In addition to the deadlock, initializing fu->tpg in tcm_alloc() introduces
a race condition. If the user symlinks the function into a gadget
configuration before creating the TPG directory, tpg_instances[i].tpg is
NULL, causing tcm_alloc() to leave fu->tpg as NULL. When the TPG is later
created and enabled, tcm_bind() succeeds because opts->can_attach is true,
but fu->tpg remains NULL. When USB transfers are subsequently processed,
dereferencing fu->tpg results in a NULL pointer dereference crash.
Furthermore, removing an enabled TPG via rmdir calls usbg_drop_tpg()
directly without detaching, leaving opts->can_attach set to true and
permitting subsequent binds against a destroyed TPG.

Fix these issues by storing the TPG pointer in struct f_tcm_opts, removing
the tpg_instances_lock acquisition from tcm_alloc(), and deferring fu->tpg
assignment until tcm_bind(). The function instance is already valid for the
item's lifetime, making the search in tcm_alloc() redundant; removing it
breaks the circular lock dependency cycle. In tcm_bind(), fu->tpg is
assigned under opts->dep_lock after validating that both opts->can_attach
and opts->tpg are valid. In usbg_make_tpg(), opts->tpg is set under
opts->dep_lock. In usbg_drop_tpg(), both opts->can_attach is reset to false
and opts->tpg is cleared under opts->dep_lock, ensuring consistent state
and preventing NULL pointer dereferences.

Fixes: 4bb8548df632 ("usb: gadget: f_tcm: add configfs support")
Assisted-by: Gemini:gemini-3.8-flash syzbot
Reported-by: syzbot+2799146a53c356f8017d@syzkaller.appspotmail.com
Closes: https://syzkaller.appspot.com/bug?extid=2799146a53c356f8017d
Link: https://syzkaller.appspot.com/ai_job?id=2d939c9d-3201-41f9-92e9-2141e5485249
To: "Greg Kroah-Hartman" <gregkh@linuxfoundation.org>
To: <linux-usb@vger.kernel.org>
To: "Andrzej Pietrasiewicz" <andrzej.p@samsung.com>
Cc: "Jiasheng Jiang" <jiashengjiangcool@gmail.com>
Cc: <linux-kernel@vger.kernel.org>
Cc: "Yun Zhou" <yun.zhou@windriver.com>
Cc: "Cen Zhang" <zzzccc427@gmail.com>

---
v2:
- Updated kerneldoc description for @tpg in struct f_tcm_opts.

v1:
https://lore.kernel.org/all/b1646de9-ae67-4626-89f3-76a04e181581@mail.kernel.org/T/
---
diff --git a/drivers/usb/gadget/function/f_tcm.c b/drivers/usb/gadget/function/f_tcm.c
index 9e6d4f399..c7bdedd46 100644
--- a/drivers/usb/gadget/function/f_tcm.c
+++ b/drivers/usb/gadget/function/f_tcm.c
@@ -1720,6 +1720,9 @@ static struct se_portal_group *usbg_make_tpg(struct se_wwn *wwn,
 
 	tpg_instances[i].tpg = tpg;
 	tpg->fi = tpg_instances[i].func_inst;
+	mutex_lock(&opts->dep_lock);
+	opts->tpg = tpg;
+	mutex_unlock(&opts->dep_lock);
 	mutex_unlock(&tpg_instances_lock);
 	return &tpg->se_tpg;
 
@@ -1760,6 +1763,8 @@ static void usbg_drop_tpg(struct se_portal_group *se_tpg)
 		opts = container_of(tpg_instances[i].func_inst,
 			struct f_tcm_opts, func_inst);
 		mutex_lock(&opts->dep_lock);
+		opts->can_attach = false;
+		opts->tpg = NULL;
 		if (opts->has_dep)
 			module_put(opts->dependent);
 		else
@@ -2300,10 +2305,11 @@ static int tcm_bind(struct usb_configuration *c, struct usb_function *f)
 	opts = container_of(f->fi, struct f_tcm_opts, func_inst);
 
 	mutex_lock(&opts->dep_lock);
-	if (!opts->can_attach) {
+	if (!opts->can_attach || !opts->tpg) {
 		mutex_unlock(&opts->dep_lock);
 		return -ENODEV;
 	}
+	fu->tpg = opts->tpg;
 	mutex_unlock(&opts->dep_lock);
 	us = usb_gstrings_attach(c->cdev, tcm_strings,
 		ARRAY_SIZE(tcm_us_strings));
@@ -2729,22 +2735,10 @@ static void tcm_unbind(struct usb_configuration *c, struct usb_function *f)
 static struct usb_function *tcm_alloc(struct usb_function_instance *fi)
 {
 	struct f_uas *fu;
-	unsigned i;
-
-	mutex_lock(&tpg_instances_lock);
-	for (i = 0; i < TPG_INSTANCES; ++i)
-		if (tpg_instances[i].func_inst == fi)
-			break;
-	if (i == TPG_INSTANCES) {
-		mutex_unlock(&tpg_instances_lock);
-		return ERR_PTR(-ENODEV);
-	}
 
 	fu = kzalloc_obj(*fu);
-	if (!fu) {
-		mutex_unlock(&tpg_instances_lock);
+	if (!fu)
 		return ERR_PTR(-ENOMEM);
-	}
 
 	fu->function.name = "Target Function";
 	fu->function.bind = tcm_bind;
@@ -2754,12 +2748,10 @@ static struct usb_function *tcm_alloc(struct usb_function_instance *fi)
 	fu->function.setup = tcm_setup;
 	fu->function.disable = tcm_disable;
 	fu->function.free_func = tcm_free;
-	fu->tpg = tpg_instances[i].tpg;
 	INIT_WORK(&fu->delayed_set_alt, tcm_delayed_set_alt);
 	spin_lock_init(&fu->delayed_set_alt_lock);
 
 	hash_init(fu->stream_hash);
-	mutex_unlock(&tpg_instances_lock);
 
 	return &fu->function;
 }
diff --git a/drivers/usb/gadget/function/u_tcm.h b/drivers/usb/gadget/function/u_tcm.h
index 2cd15d9a1..fa38d55c2 100644
--- a/drivers/usb/gadget/function/u_tcm.h
+++ b/drivers/usb/gadget/function/u_tcm.h
@@ -15,6 +15,8 @@
 
 #include <linux/usb/composite.h>
 
+struct usbg_tpg;
+
 /**
  * @dependent: optional dependent module. Meant for legacy gadget.
  * If non-null its refcount will be increased when a tpg is created and
@@ -23,10 +25,12 @@
  * @ready: true if the dependent module information is set.
  * @can_attach: true a function can be bound to gadget
  * @has_dep: true if there is a dependent module
+ * @tpg: target portal group associated with this function instance.
  *
  */
 struct f_tcm_opts {
 	struct usb_function_instance	func_inst;
+	struct usbg_tpg			*tpg;
 	struct module			*dependent;
 	struct mutex			dep_lock;
 	bool				ready;


base-commit: a90ee4305c4a5df72c11b31dacfdc76e00fcf78a
-- 
This is an AI-generated patch subject to moderation.
Reply with '#syz upstream' to Sign-off the patch as a human author
and send it to the upstream kernel mailing lists.
Reply with '#syz reject' to reject it ('#syz unreject' to undo).

See https://goo.gle/syzbot-ai-patches for information about AI-generated patches.
You can comment on the patch as usual, syzbot will try to address
the comments and send a new version of the patch if necessary.
syzbot engineers can be reached at syzkaller@googlegroups.com.
