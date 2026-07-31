Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0513E21C173
	for <syzbot@lists.linux.dev>; Fri, 31 Jul 2026 09:41:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785490866; cv=none; b=i4xvUDW5E4M6ql20ApRxy6PYzDGOYg8I2FH64dmR1vGLoA3OayfVdbL3tgTB0XD9C0A8ShNwXzZrFj8pw9q4Kj6mz3c5xwh/l9zP52TvNvq9X3n/B/YLhdvofzB9lGOLalv8kj5jYTqH0cherKPik6axl1JV/eEUHziPFKg5TvQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785490866; c=relaxed/simple;
	bh=iJ8idODRvcKm56QJcMIr9Mi/pLQAIxBP7191VmdTsMo=;
	h=From:To:Cc:Subject:Message-ID:MIME-Version:Content-Type:Date; b=eNaM5OWiELx9C1hD5rsVBW3mxlgiwA980PDud3Y1B5w4UyZG54Fg21DKnU0zbygx+UANgLDSYR57VMG+JJzQi/jJ5FFT+ZXBPm43eN4oj1nqWYd4CsVXDN0DtaRzsdZg/nDhWhi3D8sTlI7ahLTBNBPamRvNRsLegsI+hwa5J+0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Th3l0KlM; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Th3l0KlM"
Received: by smtp.kernel.org (Postfix) with UTF8SMTPSA id 69AB31F000E9;
	Fri, 31 Jul 2026 09:41:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1785490864;
	bh=3vmdwQelKkAp9uTFYl8JoJSv0s2cz7eV+hCKGtHXOcs=;
	h=From:To:Cc:Subject:Date;
	b=Th3l0KlM4dDndLAkaZCx1ql0Hzv1tYUWQhamD5CvgmAY57AQjHjleWBZ13/uqCoky
	 Jwl+D9vpd/76JiC8idDBVzRJLH6IybNTArZojoDb2UoAnCOjjGeBCwCFQSWRMnfVwq
	 gXwtc1HF/D/JOClqWQv1ye6DR117LBcdWOtXnSlWtpmwWs7/WinlBTVy2Zz4gg5N7f
	 eGBX8bcbAH4wkQ7erATxH2ULa1AvrR3yV0OhA6WQsPz5cq2jA2Z4OjYd0CcWaRVmU2
	 okXsfGWTftwLbRpvfg1qPy2Fnho2QWr4hfj0krHqxDI0yUhQhEjHLQo2CcU2SCXxWP
	 E+w6HyGuQfnOg==
From: "syzbot" <syzbot@kernel.org>
To: syzkaller-upstream-moderation@googlegroups.com
Cc: sst@poczta.fm, syzbot@lists.linux.dev
Subject: [PATCH RFC v2] netdevsim: fix deadlock in nsim_bus_dev_max_vfs_write()
Message-ID: <61024160-6fe7-45d6-baa0-0ddcba466bbe@mail.kernel.org>
Precedence: bulk
X-Mailing-List: syzbot@lists.linux.dev
List-Id: <syzbot.lists.linux.dev>
List-Subscribe: <mailto:syzbot+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:syzbot+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Date: Fri, 31 Jul 2026 09:41:04 +0000 (UTC)

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

Assisted-by: Gemini:gemini-3.5-flash Gemini:gemini-3.1-pro-preview syzbot
Reported-by: syzbot+3147c5de186107ffc7a1@syzkaller.appspotmail.com
Closes: https://syzkaller.appspot.com/bug?extid=3147c5de186107ffc7a1
Link: https://syzkaller.appspot.com/ai_job?id=fcdda182-bebf-49ab-ada0-d4d2e814ebf7
To: "Andrew Lunn" <andrew+netdev@lunn.ch>
To: "David S. Miller" <davem@davemloft.net>
To: "Eric Dumazet" <edumazet@google.com>
To: "Jakub Kicinski" <kuba@kernel.org>
To: <netdev@vger.kernel.org>
To: "Paolo Abeni" <pabeni@redhat.com>
Cc: <linux-kernel@vger.kernel.org>

---
v2:
- No changes since v1.

v1:
https://lore.kernel.org/all/a861f535-2bc3-46cd-ab28-a4190ae24248@mail.kernel.org/T/
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
