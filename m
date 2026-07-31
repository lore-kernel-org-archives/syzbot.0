Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 835D73B893A;
	Fri, 31 Jul 2026 13:24:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785504292; cv=none; b=mIzzg635YuppfzY67UGFqGQYGZxIfMeF8QiCy2uWlw9SvFh8Newl8R4/migD+6v5J62eh8WytpagQa+FoT+5j/wmFe0DXuCn1XeF5LvewqjppqiFEMDkfgzdMZ0lXZjYgRD54aclGy9yVSaNUaIJmBFYqxrFIWBXqALzavpiYgY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785504292; c=relaxed/simple;
	bh=p6wU/huXjgB5p13IOyxi82vUuyc/Ez+nj45Qi8Cgb5Q=;
	h=From:To:Cc:Subject:Message-ID:MIME-Version:Content-Type:Date; b=c4rll5Bzmwl/lUilgwTWGLhdffINDQUfGk7iX6Lr2rnKcW+n24XqMsUTbUhhs7LnJdFaapyq8srDF79YPhjT5IK0NFuCsK4IlyH/z9ISlsO0GJg9CXBn+gudeHxyCPgcFlYfioBi/2C89XEd/LHPICsOUuvd4JvgEox7GkSh9y4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=BOLEJY4z; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="BOLEJY4z"
Received: by smtp.kernel.org (Postfix) with UTF8SMTPSA id 9DE4D1F000E9;
	Fri, 31 Jul 2026 13:24:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1785504291;
	bh=nLLuZcz3ofYeWJwtdA2UrXbg4PCWRF5kuKHXXu2RiGE=;
	h=From:To:Cc:Subject:Date;
	b=BOLEJY4ziPx9RLxJEGpS1Edis8uNSVtvx25jxeeHeJtN5w/9mUNEuk3wKSr98KCC2
	 tlw1BB++q5snNjCK/w3/8CGPiz1h8vFzDQzfvs3QxpSI5ThnzyqlCHExvN7xKpfDVK
	 G42qpEoNSvLHsWW8tQ2AMsqqxcY3k13yo5mPV04alP1Z4HVVz6eO6IEqaXJtTPUESt
	 /hAaoRQuN97Y2mtbagls2WNVmvCI+WggfXklurirWAja1y6wXd9xq/prisq4rw8kC8
	 5bNa1Jm6Ccbqip6XXuqBDrpVAqTZdu85lbsuJE80i3YbAneIPt/pAAFkUB7Dh6by6H
	 9CbVeJ2czIEAg==
From: "syzbot" <syzbot@kernel.org>
To: syzkaller-bugs@googlegroups.com, Aleksandr Nogikh <nogikh@google.com>, "Greg Kroah-Hartman" <gregkh@linuxfoundation.org>, <linux-usb@vger.kernel.org>, "Linus Torvalds" <torvalds@ppc970.osdl.org>
Cc: brauner@kernel.org, jack@suse.cz, kees@kernel.org, linux-kernel@vger.kernel.org, mjguzik@gmail.com, syzbot@lists.linux.dev, viro@zeniv.linux.org.uk
Subject: [PATCH] usb: gadgetfs: fix use-after-free in ep_open()
Message-ID: <ee41fbfd-f368-4a06-95d6-ae9b4267fd82@mail.kernel.org>
Precedence: bulk
X-Mailing-List: syzbot@lists.linux.dev
List-Id: <syzbot.lists.linux.dev>
List-Subscribe: <mailto:syzbot+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:syzbot+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Date: Fri, 31 Jul 2026 13:24:50 +0000 (UTC)

From: Aleksandr Nogikh <nogikh@google.com>

A race condition exists between opening a gadgetfs endpoint file and the
destruction of the endpoint files, leading to a use-after-free of the
ep_data object.

When an endpoint file is opened, the VFS looks up the dentry and calls
ep_open(). ep_open() retrieves the ep_data pointer from inode->i_private
and attempts to lock its mutex. Concurrently, if the gadget is unbound,
destroy_ep_files() iterates over the endpoints, unhashes their dentries,
and immediately calls put_ep(). This drops the initial reference to the
ep_data object, freeing it. If another thread is already in the process of
opening the file, it holds a reference to the dentry and the inode. The
inode remains alive, and its i_private pointer still points to the
now-freed ep_data. When ep_open() proceeds to lock data->lock, it accesses
freed memory.

BUG: KASAN: slab-use-after-free in __mutex_lock_common
kernel/locking/mutex.c:625 [inline]
BUG: KASAN: slab-use-after-free in __mutex_lock+0x130/0xf14
kernel/locking/mutex.c:821
Read of size 8 at addr ffff0000f43acc58 by task syz-executor/5900

Call trace:
 __mutex_lock_common kernel/locking/mutex.c:625 [inline]
 __mutex_lock+0x130/0xf14 kernel/locking/mutex.c:821
 mutex_lock_interruptible_nested+0x24/0x30 kernel/locking/mutex.c:899
 ep_open+0x58/0x25c drivers/usb/gadget/legacy/inode.c:823
 do_dentry_open+0x5c4/0xfc0 fs/open.c:947
 vfs_open+0x44/0x2dc fs/open.c:1052

Freed by task 6138:
 kfree+0x188/0x690 mm/slub.c:6692
 put_ep+0xd0/0x144 drivers/usb/gadget/legacy/inode.c:225
 destroy_ep_files+0x244/0x2dc drivers/usb/gadget/legacy/inode.c:1582
 gadgetfs_unbind+0x114/0x1f0 drivers/usb/gadget/legacy/inode.c:1655
 gadget_unbind_driver+0x188/0x790 drivers/usb/gadget/udc/core.c:1724

To fix this, tie the base reference of ep_data to the lifetime of the inode
rather than manually dropping it in destroy_ep_files(). Add an .evict_inode
callback to gadget_fs_operations that drops the reference when the inode is
finally destroyed. Remove the premature put_ep() call from
destroy_ep_files(). Additionally, to prevent a double-free in the error
path of activate_ep_files(), clear inode->i_private in
gadgetfs_create_file() before calling iput() if simple_start_creating()
fails.

Fixes: 1da177e4c3f4 ("Linux-2.6.12-rc2")
Assisted-by: Gemini:gemini-3.5-flash Gemini:gemini-3.1-pro-preview syzbot
Reported-by: syzbot+df9e891bf8ea586f846b@syzkaller.appspotmail.com
Closes: https://syzkaller.appspot.com/bug?extid=df9e891bf8ea586f846b
Link: https://syzkaller.appspot.com/ai_job?id=ae49a838-5eb9-4227-93a3-56ad2313483a
Signed-off-by: Aleksandr Nogikh <nogikh@google.com>

---
diff --git a/drivers/usb/gadget/legacy/inode.c b/drivers/usb/gadget/legacy/inode.c
index d87a8ab51..a03062986 100644
--- a/drivers/usb/gadget/legacy/inode.c
+++ b/drivers/usb/gadget/legacy/inode.c
@@ -1579,8 +1579,6 @@ static void destroy_ep_files (struct dev_data *dev)
 		/* break link to dcache */
 		simple_remove_by_name(dev->sb->s_root, ep->name, NULL);
 
-		put_ep (ep);
-
 		spin_lock_irq (&dev->lock);
 	}
 	spin_unlock_irq (&dev->lock);
@@ -1996,6 +1994,7 @@ static int gadgetfs_create_file (struct super_block *sb, char const *name,
 
 	dentry = simple_start_creating(sb->s_root, name);
 	if (IS_ERR(dentry)) {
+		inode->i_private = NULL;
 		iput(inode);
 		return PTR_ERR(dentry);
 	}
@@ -2006,9 +2005,18 @@ static int gadgetfs_create_file (struct super_block *sb, char const *name,
 	return 0;
 }
 
+static void gadgetfs_evict_inode(struct inode *inode)
+{
+	truncate_inode_pages_final(&inode->i_data);
+	clear_inode(inode);
+	if (inode->i_private && inode->i_fop == &ep_io_operations)
+		put_ep(inode->i_private);
+}
+
 static const struct super_operations gadget_fs_operations = {
 	.statfs =	simple_statfs,
 	.drop_inode =	inode_just_drop,
+	.evict_inode =	gadgetfs_evict_inode,
 };
 
 static int


base-commit: f5098b6bae761e346ebcd9da7f95622c04733cff
-- 
See https://goo.gle/syzbot-ai-patches for information about AI-generated patches.
You can comment on the patch as usual, syzbot will try to address
the comments and send a new version of the patch if necessary.
syzbot engineers can be reached at syzkaller@googlegroups.com.
