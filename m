Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B4EF83AD539
	for <syzbot@lists.linux.dev>; Fri, 31 Jul 2026 08:13:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785485615; cv=none; b=YMCM57T7xVpaF9U+KAm0JBU31Rsw7bgiu0nHvAFviu+CgI7euQZn698JxC6+o0R38tDQJYEx58hPQQHk0bMv34lDE9tJX7+AlgTfM4tiGgy2BIOBzjQuUAjMVDURJf8DYk1KdWkA832T3npfT8XfX6UCtLkqqs+i6aoYP9TOYM4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785485615; c=relaxed/simple;
	bh=4+H+6ppOFArh4Gj66O3MI+ufaSabkuQsb4CpDqyT5i4=;
	h=From:To:Cc:Subject:Message-ID:MIME-Version:Content-Type:Date; b=KH8IM/SmpK4ArMraxBrkg31Der43hgoX73blfC/1tGwLQjqlC6wLP9necDPts9ag5eHqh+Xwd683OHAHa2av5E/EskdU5/HxjN7YghRo4pWf/04nssfPsXvu2NK88/RHsdFD5yZQjtYi6RIJj0av4gffFyrrawQ+YIzmJ/uysH8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=WO03f0ml; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="WO03f0ml"
Received: by smtp.kernel.org (Postfix) with UTF8SMTPSA id 4CE381F000E9;
	Fri, 31 Jul 2026 08:13:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1785485614;
	bh=ehUTfHeWXSv3diOMTV7jMKhBOYsEySxUsLk2xZS0/5E=;
	h=From:To:Cc:Subject:Date;
	b=WO03f0mlsW6fr4MXNfIr5GTePN0+kp+dLFGV/rJzDQqDaoPq9SIsNQARBunaUISSf
	 B6eyT07OpPlPkTWPgRjZzVQrXBI8+liWdbz9zYMDKIVNS4kWXT6eRZy2ZvnYwlH8zc
	 SJO6XEjyC3gf8YTaO1thEM07wHzdEAfCZcAceFyhKKBtSg2Z3sDMaPuWsSvD8JUIam
	 812sMEsvWwhsvxAqf4JY/4Z+oztSkjMWJSIEIyfLkVc7LAOboMLCCmVKRXS5F1ZqEC
	 1gTjP+kJqs9Dcs4IV/WB3tMbA9Qb3eZEnhGpg3zYQdL3Utx4m/onsIx0s+BcjZ4Vvf
	 MUW8rAUQdWYvw==
From: "syzbot" <syzbot@kernel.org>
To: syzkaller-upstream-moderation@googlegroups.com
Cc: syzbot@lists.linux.dev
Subject: [PATCH RFC] usb: gadgetfs: fix use-after-free in ep_open()
Message-ID: <a6f4f066-bd64-4a53-b3e0-0d71b34bf773@mail.kernel.org>
Precedence: bulk
X-Mailing-List: syzbot@lists.linux.dev
List-Id: <syzbot.lists.linux.dev>
List-Subscribe: <mailto:syzbot+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:syzbot+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Date: Fri, 31 Jul 2026 08:13:34 +0000 (UTC)

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
To: "Greg Kroah-Hartman" <gregkh@linuxfoundation.org>
To: <linux-usb@vger.kernel.org>
To: "Linus Torvalds" <torvalds@ppc970.osdl.org>
Cc: "Christian Brauner" <brauner@kernel.org>
Cc: "Jan Kara" <jack@suse.cz>
Cc: "Kees Cook" <kees@kernel.org>
Cc: <linux-kernel@vger.kernel.org>
Cc: "Mateusz Guzik" <mjguzik@gmail.com>
Cc: "Al Viro" <viro@zeniv.linux.org.uk>

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
This is an AI-generated patch subject to moderation.
Reply with '#syz upstream' to Sign-off the patch as a human author
and send it to the upstream kernel mailing lists.
Reply with '#syz reject' to reject it ('#syz unreject' to undo).

See https://goo.gle/syzbot-ai-patches for information about AI-generated patches.
You can comment on the patch as usual, syzbot will try to address
the comments and send a new version of the patch if necessary.
syzbot engineers can be reached at syzkaller@googlegroups.com.
