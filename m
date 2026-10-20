Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792490621;
	b=SVAm2/mHPY/JJ96e8XSek8Rsns2MSx7z3xuNsK/MJqaEeYKxmyH066tElhjCvyoB+VpU
	 U36WUC6nnTZY18GvxQ7mi8zsAVTrvy/giY3JcrCVBh793HvPGqYbnyREnbhfCR+nQAwVF
	 9BeGe4kdtgC74ig8oiy1T5cqHFUovxsZbGf1FpD2X6SDo5ctHr0uOLbQBgxinmg++hH/M
	 nT3h6rKiXYKhW2Ph/i+MlBWJ+M/8ktGhglng9PK0oIJx9Omr9gASPTHbqFAshZpx0/UdT
	 WWgQ5eROKtxUTlG/QxuYSKezgLsFFP1YwISl/UbDHuiw8DJ658wUd+/Ks4vJXFANpaQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792490621;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Message-ID:MIME-Version:
	 Content-Type:Content-Transfer-Encoding:Date;
	bh=BYc8lsphBJ6Ts8nymkX3Xl8VN6Sl6ZrmSNvbiT0eQjg=;
	b=QtxHtVoOf9BAL3DFwnKndc6m3JWmvQ6aTu4ph/lBxKy1OjmXG071/0I7ZoF8UmZKHRtv
	 MmlHtxqbiE/Z6sClaflyW0F5rXRqP3aONiqBFyYmmWomDRR5cqJpfScpt8AV2wKb+JJnP
	 1Cbre1G0HscoJ6klq56bDCDnvKgVwYNNGU3GI1VYCboe5DUPliJ0vThex3kCC9l+2g8RY
	 0mXm6E01QIMRdcwsOyKDk5A8on5ZsvF/UGLtaheaDkkRrLdMM12N0nC7Fzh3J5hZDTlqF
	 IQOuvsCWFluRR46zfNA7qVXDDmxH1QVZSMxBreyzwl6m62a8mJp1DCNMLo6ssBzS7FA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=dqjm2ghv;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with UTF8SMTPS id B67BF606A31D
	for <syzbot@lists.linux.dev>; Tue, 20 Oct 2026 10:03:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=dqjm2ghv
Received: by smtp.kernel.org (Postfix) with UTF8SMTPSA id 32E7C1F000C4;
	Tue, 20 Oct 2026 10:03:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1792490620;
	bh=BYc8lsphBJ6Ts8nymkX3Xl8VN6Sl6ZrmSNvbiT0eQjg=;
	h=From:To:Cc:Subject:Date;
	b=dqjm2ghvM02u9biu9B73xp9VTLk9Fox6uDYXrAbJ9wMkhonKPqHnFLLmmbsqIwL7m
	 3RspIb3ojpxmMBZvvjHxqWULfB+Xvg4QwaEsUyyYuGyBHnxjmHPUreVXjbd8KY6bpw
	 g/2HyP8+AO5h8DrvAd8tZ1TY0tb+s50oi8EX8eI2p+qH/MxFyitQC2KaLdSkyV/sCS
	 +16ODPh574IrbVtUj9tl2lAeAXe/xqJy8ta2Uj5FHOx5FgIF6Q0N9rYiegxbIxdugK
	 XJ3CAXuciBHtUvH7ELzqWdueOi9+dsX+/JuvvsjDURKHDn5fma2HHp3XSARrV1eAF9
	 vydt8x+ZcHYPw==
From: "syzbot" <syzbot@kernel.org>
To: syzkaller-upstream-moderation@googlegroups.com
Cc: sst@poczta.fm, syzbot@lists.linux.dev
Subject: [PATCH RFC v4] usb: gadget: f_tcm: fix circular lock dependency in usbg_make_tpg()
Message-ID: <84a4336f-27f0-4d8b-b01a-3e234e3b593b@mail.kernel.org>
X-Mailing-List: syzbot@lists.linux.dev
List-Id: <syzbot.lists.linux.dev>
List-Post: <mailto:syzbot@lists.linux.dev>
List-Help: <mailto:syzbot+help@lists.linux.dev>
List-Subscribe: <mailto:syzbot+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:syzbot+unsubscribe@lists.linux.dev>
List-Owner: <mailto:syzbot+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Date: Tue, 20 Oct 2026 10:03:40 +0000 (UTC)

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
ffff8881e6111900 (&sb->s_type->i_mutex_key#24){+.+.}-{4:4}, at: inode_lock
include/linux/fs.h:1024 [inline]
ffff8881e6111900 (&sb->s_type->i_mutex_key#24){+.+.}-{4:4}, at:
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
acquire configfs inode locks. Before dropping tpg_instances_lock, reference
the item via config_item_get_unless_zero(); note that this does not prevent
concurrent release or removal, but is used to abort if a concurrent release
is happening. After configfs_depend_item_unlocked() completes, release the
reference with config_item_put() before re-acquiring tpg_instances_lock so
that an eventual cleanup cannot deadlock on tpg_instances_lock. Finally,
once tpg_instances_lock is re-acquired, verify that the instance slot
remains valid and unassigned (tpg_instances[i].func_inst ==
&opts->func_inst && !tpg_instances[i].tpg); if another thread claimed or
changed the slot while unlocked, unwind the dependency with
configfs_undepend_item_unlocked() and return -EBUSY.

Fixes: 9dbf74f4022f ("usb: gadget: f_tcm: fix deadlock in usbg_make_tpg()")
Assisted-by: Gemini:gemini-3.8-flash syzbot
Reported-by: syzbot+b3410eb576b568216ae5@syzkaller.appspotmail.com
Closes: https://syzkaller.appspot.com/bug?extid=b3410eb576b568216ae5
Link: https://syzkaller.appspot.com/ai_job?id=1a180dde-c93d-40ea-9b76-0093644749f0
To: "Greg Kroah-Hartman" <gregkh@linuxfoundation.org>
To: <linux-usb@vger.kernel.org>
To: "Yun Zhou" <yun.zhou@windriver.com>
Cc: "Jiasheng Jiang" <jiashengjiangcool@gmail.com>
Cc: <linux-kernel@vger.kernel.org>
Cc: "Cen Zhang" <zzzccc427@gmail.com>

---
v4:
- Update commit description to reference config_item_get_unless_zero() and clarify that it is used to abort if a concurrent release is happening rather than preventing it.

v3:
- Use config_item_get_unless_zero() instead of config_item_get() to safely handle concurrent teardown.
https://lore.kernel.org/all/f0f928b0-ce5b-4a70-aa39-e3f535ad9139@mail.kernel.org/T/

v2:
- Retain original comment about dep_lock in usbg_make_tpg() instead of replacing it.
https://lore.kernel.org/all/82dbe31c-49fb-446b-93b9-fcdec2504876@mail.kernel.org/T/

v1:
https://lore.kernel.org/all/77d2115f-8e36-403c-bf08-6810b1c6900c@mail.kernel.org/T/
---
diff --git a/drivers/usb/gadget/function/f_tcm.c b/drivers/usb/gadget/function/f_tcm.c
index 9e6d4f399..a27f23191 100644
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
@@ -1682,18 +1683,35 @@ static struct se_portal_group *usbg_make_tpg(struct se_wwn *wwn,
 		if (!try_module_get(opts->dependent))
 			goto unlock_inst;
 	} else {
+		item = config_item_get_unless_zero(&opts->func_inst.group.cg_item);
+		if (!item)
+			goto unlock_inst;
+		mutex_unlock(&tpg_instances_lock);
+
 		/*
 		 * configfs_depend_item_unlocked() may acquire the configfs
 		 * root inode lock when the target belongs to a different
 		 * subsystem. Calling it under dep_lock would create a
 		 * circular dependency:
 		 *   dep_lock -> configfs inode lock -> su_mutex -> dep_lock
+		 *
+		 * Calling it under tpg_instances_lock would create a
+		 * circular dependency:
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
