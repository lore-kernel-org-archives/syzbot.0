Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2C61E387359
	for <syzbot@lists.linux.dev>; Wed,  5 Aug 2026 14:28:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785940139; cv=none; b=gu1FKYbBw3kLvZpxTfPQbiH2AZYM+moAy95CrK4wfjbXuRAG+I5M8FUoQn1Gl1tDhlQqEhuc2rhcl+EPEd/7QYQGRQNW+Ail+4Mt9Spqaw6eU9TyTOWAQT+gWYSscY9RxE32FUeYNPtjWXWAwbPVo013/DXxa96DQ6IrWEMuXk8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785940139; c=relaxed/simple;
	bh=ZfnqAKrBxbwGtRFCS66wM7JW2ArNUU9Ql6yEEVJ8sVQ=;
	h=From:To:Cc:Subject:Message-ID:MIME-Version:Content-Type:Date; b=QR2p8bCH3pqiCYaQigFtnNYWsbRjJLys+IqXaLs6qSHcpo9r0heKQEKOMc1XHenPVEAcsF4XsHh+9xP3y+byy568Fdb/pTTZTGtE4fIHlGvgfr+2k0QZbd45cCqgM98lL865BAR2nwJy4knGcadL9hxujvhtxaxxL8V6gz0Lxuo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=iKaK2uMg; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="iKaK2uMg"
Received: by smtp.kernel.org (Postfix) with UTF8SMTPSA id 7D8C31F00A3A;
	Wed,  5 Aug 2026 14:28:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1785940128;
	bh=twBAyuLwVWaNMgDlM6g01CzOciwzhz672uI+hMGEIkY=;
	h=From:To:Cc:Subject:Date;
	b=iKaK2uMgyMoAiz9W3owPeERzMy5oTkJXcgtS3AyvuE19VS0p/4Gu7UeqnyGPSoUK5
	 qAw4TeCfSE0+uxXf6c7LmRfLVGgTC41UrXW8wo1SUwe0+bkLJhFqnJt/uGjXmBmf/R
	 0OfUT6iy9cyJGvyylUMV7jPRfeEfu7/kuTLy2PTcdEIvhk3sy2XTDiE8DvdQQMFj42
	 K/DCwS8yu61tXr1X8YeDdiWzTolOwbx6jil0xLrh6W+l69bH/1u3tmY0kanU9CntIt
	 VKKFKdaOQlKvSG6Ysw3FsXlbTRT7O4IEVl0o1Ci3mdmWousmdQ/nO/7KcUEl5szSip
	 nvSjGzzTpNo3Q==
From: "syzbot" <syzbot@kernel.org>
To: syzkaller-upstream-moderation@googlegroups.com
Cc: syzbot@lists.linux.dev
Subject: [PATCH RFC] i2c: core: fix race between adapter removal and new_device_store
Message-ID: <bddb13e0-6443-4164-a9a9-175146652b6a@mail.kernel.org>
Precedence: bulk
X-Mailing-List: syzbot@lists.linux.dev
List-Id: <syzbot.lists.linux.dev>
List-Subscribe: <mailto:syzbot+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:syzbot+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Date: Wed,  5 Aug 2026 14:28:48 +0000 (UTC)

There is a race condition between the removal of an I2C adapter
(`i2c_del_adapter`) and the instantiation of a new I2C client device via
sysfs (`new_device_store`).

When an adapter is being removed, `i2c_del_adapter()` removes it from
`i2c_adapter_idr`, deregisters clients (emptying `adap->userspace_clients`
under `adap->userspace_clients_lock`), and recursively removes the
adapter's debugfs directory. Concurrently, a write to the `new_device`
sysfs attribute invokes `new_device_store()`, which calls
`i2c_new_client_device()` to instantiate and probe a new client. If this
happens after the adapter's debugfs directory is removed,
`i2c_device_probe()` will attempt to create a debugfs directory for the new
client using the now-removed (negative) adapter debugfs dentry as the
parent. This results in a NULL-pointer dereference in `inode_lock_nested()`
when `debugfs_create_dir()` tries to lock the parent's inode.

Additionally, if the crash did not occur, the newly created client would be
added to the `adap->userspace_clients` list after
`i2c_deregister_clients()` had already finished, leaking the device and
associated resources.

The crash trace looks like this:

Unable to handle kernel paging request at virtual address dfff800000000028
KASAN: null-ptr-deref in range [0x0000000000000140-0x0000000000000147]
...
Call trace:
 kasan_mem_to_shadow include/linux/kasan.h:65 [inline] (P)
 kasan_byte_accessible+0x10/0x20 mm/kasan/generic.c:210 (P)
 kasan_check_byte include/linux/kasan.h:402 [inline]
 lock_acquire+0xa4/0x364 kernel/locking/lockdep.c:5842
 down_write_nested+0x58/0xcc kernel/locking/rwsem.c:1757
 inode_lock_nested include/linux/fs.h:1069 [inline]
 __start_dirop+0xa0/0xf4 fs/namei.c:2918
 start_dirop+0x38/0x4c fs/namei.c:2942
 simple_start_creating+0xcc/0x114 fs/libfs.c:2305
 debugfs_start_creating+0xf8/0x1ac fs/debugfs/inode.c:394
 debugfs_create_dir+0x30/0x2f4 fs/debugfs/inode.c:572
 i2c_device_probe+0x7fc/0x9d4 drivers/i2c/i2c-core-base.c:588

To fix both the crash and the resource leak, synchronize
`new_device_store()` with `i2c_del_adapter()`. This is achieved by
extending the `adap->userspace_clients_lock` critical section in
`new_device_store()` to cover the entire client creation process.
Furthermore, a liveness check is added: while holding the lock, we check if
the adapter is still present in `i2c_adapter_idr` under `core_lock`. If the
adapter is already being removed, we safely abort and return `-ENODEV`.
This guarantees that if `new_device_store()` starts first,
`i2c_del_adapter()` will block waiting for `userspace_clients_lock`,
delaying the debugfs removal until the client is fully instantiated and
added to the list, ensuring it gets properly cleaned up.

Fixes: 99cd8e25875a ("i2c: Add a sysfs interface to instantiate devices")
Assisted-by: Gemini:gemini-3.5-flash Gemini:gemini-3.1-pro-preview syzbot
Reported-by: syzbot+cc460646984184ad435a@syzkaller.appspotmail.com
Closes: https://syzkaller.appspot.com/bug?extid=cc460646984184ad435a
Link: https://syzkaller.appspot.com/ai_job?id=f83d9281-0bbe-47a6-ac52-5b5911268adc
To: "Andi Shyti" <andi.shyti@kernel.org>
To: <linux-i2c@vger.kernel.org>
To: "Jean Delvare" <khali@linux-fr.org>
Cc: <linux-kernel@vger.kernel.org>

---
diff --git a/drivers/i2c/i2c-core-base.c b/drivers/i2c/i2c-core-base.c
index 3ec04787a..884a26695 100644
--- a/drivers/i2c/i2c-core-base.c
+++ b/drivers/i2c/i2c-core-base.c
@@ -1304,12 +1304,25 @@ new_device_store(struct device *dev, struct device_attribute *attr,
 		info.flags |= I2C_CLIENT_SLAVE;
 	}
 
+	mutex_lock_nested(&adap->userspace_clients_lock,
+			  i2c_adapter_depth(adap));
+
+	/* Check if the adapter is still registered / alive */
+	mutex_lock(&core_lock);
+	if (idr_find(&i2c_adapter_idr, adap->nr) != adap) {
+		mutex_unlock(&core_lock);
+		mutex_unlock(&adap->userspace_clients_lock);
+		return -ENODEV;
+	}
+	mutex_unlock(&core_lock);
+
 	client = i2c_new_client_device(adap, &info);
-	if (IS_ERR(client))
+	if (IS_ERR(client)) {
+		mutex_unlock(&adap->userspace_clients_lock);
 		return PTR_ERR(client);
+	}
 
 	/* Keep track of the added device */
-	mutex_lock(&adap->userspace_clients_lock);
 	list_add_tail(&client->detected, &adap->userspace_clients);
 	mutex_unlock(&adap->userspace_clients_lock);
 	dev_info(dev, "%s: Instantiated device %s at 0x%02hx\n", "new_device",


base-commit: 075b74841bd0065a3bda3440873c747938e69b68
-- 
This is an AI-generated patch subject to moderation.
Reply with '#syz upstream' to Sign-off the patch as a human author
and send it to the upstream kernel mailing lists.
Reply with '#syz reject' to reject it ('#syz unreject' to undo).

See https://goo.gle/syzbot-ai-patches for information about AI-generated patches.
You can comment on the patch as usual, syzbot will try to address
the comments and send a new version of the patch if necessary.
syzbot engineers can be reached at syzkaller@googlegroups.com.
