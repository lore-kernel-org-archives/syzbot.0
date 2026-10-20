Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792484376;
	b=MLwxZQqw9egaXgkXKnFVmVYX0dnS1cgtmi7POPAMd5G/3Bs/l7hYGWVQEw9wc8ltfzEd
	 QPMh6TrEQf1aSMEvp/8sbWaNneYKJNQeWY0lbyPbi2ZmNVIk8AQHfzXIKHdi7ec/hM4e+
	 dV9gxbGgn/iop43Zh4WPshNpRqXN6pzf24WtJ4aGlkQqrpQwbMAruiJeX1cj4KCg9+kPD
	 3pc9qX+tXLoklJGiMEJrhDhG8comVk3b6flhiwbA56HKAE10FAtmvukjQqCO2ba2AB6I+
	 8zalAdyBH/gRBdVIlJAdVQnlwa6J/snlDd2eSpNopNrahiPjnOGzm/eJ6SoKskEvokw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792484376;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Message-ID:MIME-Version:
	 Content-Type:Content-Transfer-Encoding:Date;
	bh=lVwQthNePLIRTX2H8Jd/efDN9R1GYdGlEBka0e67zP8=;
	b=FlmgIXNp47Nz899C6oBScpvucWiBqpE0GqStYLAFPX38hYvDMxbveDP1UBa0dyAB2RwE
	 ZMM4gE9kt+b7T03NjZUywE3vinnmmjdchg8qCeTe55oafJal6lXowEgxzljhC5t18rlLx
	 G2blxf3PNxSgO6U+Jo4FsE4A7Ty6tAbBHDvn7uww/UYdNFTyIj8y14ZNmxyG565b74e3P
	 5s8JkfIuYBQkmBofnnMALsfI5zDyPq/ITZgWhVfVjg5WG1xGNa1pxaP9yTFekxOUFltf+
	 TR6j8B2HIm+7uOkxZkl8Pq5e4aqN3/IuqCUB1dcgzALfEcyEDf6gtZIz2hZbO/Wi/wA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=Ed3EFxA+;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with UTF8SMTPS id F243A606A31B
	for <syzbot@lists.linux.dev>; Tue, 20 Oct 2026 08:19:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=Ed3EFxA+
Received: by smtp.kernel.org (Postfix) with UTF8SMTPSA id 7B65E1F000C5;
	Tue, 20 Oct 2026 08:19:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1792484375;
	bh=lVwQthNePLIRTX2H8Jd/efDN9R1GYdGlEBka0e67zP8=;
	h=From:To:Cc:Subject:Date;
	b=Ed3EFxA+L02PAY53iFk5PduWeUNCtXTbEqZdPiuPiLwLaz9/4JfBRxKR+BWxSnqtq
	 a/L1kURxHlxraC/lS2OdeGMsjG9ken0W1DvgCTtF1d8LaCdwLdEqXKJY2s/x1OAlg2
	 ilpucqNRB7zA9PtXauFZfsVuj+qyJ7QlW7tWoJ4PohHD1z96wbJz5iOYP+bRzouV7c
	 GgnEfKvaruelE3kJfPqbQOD0J/KqzvFZ6lNT42/XRTjtVmC1mWlE2hlYgX3HUmS6iX
	 Jjh8d1bnIVp2fHv+Y5A/0/iqDVerRMZtDXpV3CB6BVmLhtNOT7ADbDlwNqTx8hwiua
	 0tsep8Jkjah1A==
From: "syzbot" <syzbot@kernel.org>
To: syzkaller-upstream-moderation@googlegroups.com
Cc: sst@poczta.fm, syzbot@lists.linux.dev
Subject: [PATCH RFC v3] usb: gadget: f_tcm: fix circular lock dependency in usbg_make_tpg()
Message-ID: <f0f928b0-ce5b-4a70-aa39-e3f535ad9139@mail.kernel.org>
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
Date: Tue, 20 Oct 2026 08:19:35 +0000 (UTC)

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
Assisted-by: Gemini:gemini-4-argon Gemini:gemini-3.8-flash syzbot
Reported-by: syzbot+b3410eb576b568216ae5@syzkaller.appspotmail.com
Closes: https://syzkaller.appspot.com/bug?extid=b3410eb576b568216ae5
Link: https://syzkaller.appspot.com/ai_job?id=d0831a0b-a285-410d-96bd-ed4809099137
To: "Greg Kroah-Hartman" <gregkh@linuxfoundation.org>
To: <linux-usb@vger.kernel.org>
To: "Yun Zhou" <yun.zhou@windriver.com>
Cc: "Jiasheng Jiang" <jiashengjiangcool@gmail.com>
Cc: <linux-kernel@vger.kernel.org>
Cc: "Cen Zhang" <zzzccc427@gmail.com>

---
v3:
- Use config_item_get_unless_zero() instead of config_item_get() to safely handle concurrent teardown.

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
