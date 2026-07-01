Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1D99B224B04
	for <syzbot@lists.linux.dev>; Wed,  1 Jul 2026 13:15:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782911713; cv=none; b=DbQMeTexOYkjVVxh5to1FmyacxuQXp9k3P3FMinW+nfrlQZiY/6MzxnT5Hy3L+2fbTr53t02Z7lsPVEI2R0etNO1boIyyALBJlLUFD8vQmvfFW1hgCaZquD/z9U0u7w6wcK/WHRXHMlhszeNGnC8T8m0w6w/iRRZUHEQmYvPO6U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782911713; c=relaxed/simple;
	bh=9662msiVvn86kfIJ/YPVBUniXPFPYA28fdHLD57Y22A=;
	h=From:To:Cc:Subject:Message-ID:MIME-Version:Content-Type:Date; b=aQH1gSJC2qoB1yEdMfhF5xGZGXo5x0FiC+qSf5W6UTBwFQvP1vxYIG3qS83KfhrdaT1+KTDMBiq6KSvpbeIoCRG/6NpoGHti5jGgiR+ET6k4eheGtpAuCnqTMbVYVb47/9M879uiUXHNXCcwhc1DKzDF/d7WUIOTNV6cb32Rm8k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=XwKgj2XB; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="XwKgj2XB"
Received: by smtp.kernel.org (Postfix) with UTF8SMTPSA id 9151C1F000E9;
	Wed,  1 Jul 2026 13:15:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1782911711;
	bh=EkIlqsWakyKBuVoCw2ipOScnCVl9JQDJPuri1b9ZMqM=;
	h=From:To:Cc:Subject:Date;
	b=XwKgj2XBygkhCJVluq0gUhrdN/5Dg86bMkJ7TKF4B0nPErZvo0ZFk96nAFAo0KlJF
	 4cgzrZcIMV5+UCPrsEF2UNFnu8R4/JU204NFbb4ynj1PkOr1HPRp0wH3x2EmS63Yvi
	 6K+J5TICWcXbuo6gAoGpUSBEOR4x3QFdkETEgmJG4BNSa6b/Fh5A35qBR2xJ6ZtFvV
	 TU4tlExSF5W9EmD62KElr0w8prm6Emcn0Bj8J6imWyh6dCVzJ9O0Kbq5qcPV2sxxAS
	 fLRBVg/46upuG7SkSRgKKebp/2Jr5jkNs8jWf0fvIc1GvSrhVFaE+WJLikwnFnQeNw
	 Catz3f+Xht6qA==
From: "syzbot" <syzbot@kernel.org>
To: syzkaller-upstream-moderation@googlegroups.com
Cc: syzbot@lists.linux.dev
Subject: [PATCH RFC] netdevsim: fix deadlock in nsim_bus_dev_max_vfs_write()
Message-ID: <a861f535-2bc3-46cd-ab28-a4190ae24248@mail.kernel.org>
Precedence: bulk
X-Mailing-List: syzbot@lists.linux.dev
List-Id: <syzbot.lists.linux.dev>
List-Subscribe: <mailto:syzbot+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:syzbot+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Date: Wed,  1 Jul 2026 13:15:11 +0000 (UTC)

There is an ABBA deadlock between the devlink instance lock and the debugfs
active file reference mechanism.

When a device is being removed (e.g., via nsim_drv_remove()), the driver
acquires the devlink instance lock and then calls
debugfs_remove_recursive(). This function blocks waiting for all active
file operations on the debugfs files to complete.

Concurrently, if a user writes to the "max_vfs" debugfs file, the VFS layer
acquires an active reference to the file. The write handler,
nsim_bus_dev_max_vfs_write(), then attempts to acquire the devlink instance
lock, which is already held by the removal task.

This creates a circular dependency resulting in a deadlock:

INFO: task blocked for more than 143 seconds.
Call Trace:
 wait_for_completion+0x2ca/0x5e0 kernel/sched/completion.c:153
 __debugfs_file_removed fs/debugfs/inode.c:751 [inline]
 remove_one+0x2df/0x3b0 fs/debugfs/inode.c:758
 __simple_recursive_removal+0x215/0x520 fs/libfs.c:623
 debugfs_remove+0x5b/0x70 fs/debugfs/inode.c:781
 nsim_dev_debugfs_exit drivers/net/netdevsim/dev.c:372 [inline]
 nsim_drv_remove+0xc0/0x170 drivers/net/netdevsim/dev.c:1803

INFO: task blocked for more than 143 seconds.
Call Trace:
 __mutex_lock+0x7bf/0x1550 kernel/locking/mutex.c:821
 nsim_bus_dev_max_vfs_write+0x229/0x3d0 drivers/net/netdevsim/dev.c:276
 full_proxy_write+0x127/0x1f0 fs/debugfs/file.c:388
 vfs_write+0x296/0xba0 fs/read_write.c:685

To fix this, use devl_trylock() in nsim_bus_dev_max_vfs_write() instead of
devl_lock(). If the lock cannot be acquired, return -EBUSY. This aborts the
write operation, releases the debugfs active file reference, and allows the
pending debugfs_remove_recursive() to proceed.

Fixes: 012ec02ae441 ("netdevsim: convert driver to use unlocked devlink API during init/fini")
Assisted-by: Gemini:gemini-3.1-pro-preview best-expensive syzbot
Reported-by: syzbot+3147c5de186107ffc7a1@syzkaller.appspotmail.com
Closes: https://syzkaller.appspot.com/bug?extid=3147c5de186107ffc7a1
Link: https://syzkaller.appspot.com/ai_job?id=e3832a24-8c9f-416a-8161-a50e277bc628
To: "Andrew Lunn" <andrew+netdev@lunn.ch>
To: "David S. Miller" <davem@davemloft.net>
To: "Eric Dumazet" <edumazet@google.com>
To: "Jakub Kicinski" <kuba@kernel.org>
To: <netdev@vger.kernel.org>
To: "Paolo Abeni" <pabeni@redhat.com>
Cc: <linux-kernel@vger.kernel.org>

---
diff --git a/drivers/net/netdevsim/dev.c b/drivers/net/netdevsim/dev.c
index aed9ad5f1..421cd7327 100644
--- a/drivers/net/netdevsim/dev.c
+++ b/drivers/net/netdevsim/dev.c
@@ -273,7 +273,11 @@ static ssize_t nsim_bus_dev_max_vfs_write(struct file *file,
 		return -ENOMEM;
 
 	nsim_dev = file->private_data;
-	devl_lock(priv_to_devlink(nsim_dev));
+	if (!devl_trylock(priv_to_devlink(nsim_dev))) {
+		ret = -EBUSY;
+		goto out;
+	}
+
 	/* Reject if VFs are configured */
 	if (nsim_dev_get_vfs(nsim_dev)) {
 		ret = -EBUSY;
@@ -285,6 +289,7 @@ static ssize_t nsim_bus_dev_max_vfs_write(struct file *file,
 	}
 	devl_unlock(priv_to_devlink(nsim_dev));
 
+out:
 	kfree(vfconfigs);
 	return ret;
 }


base-commit: dc59e4fea9d83f03bad6bddf3fa2e52491777482
-- 
This is an AI-generated patch subject to moderation.
Reply with '#syz upstream' to Sign-off the patch as a human author
and send it to the upstream kernel mailing lists.
Reply with '#syz reject' to reject it ('#syz unreject' to undo).

See https://goo.gle/syzbot-ai-patches for information about AI-generated patches.
You can comment on the patch as usual, syzbot will try to address
the comments and send a new version of the patch if necessary.
syzbot engineers can be reached at syzkaller@googlegroups.com.
