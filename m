Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E6D2A3D75C9;
	Fri, 31 Jul 2026 09:55:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785491719; cv=none; b=su9LcxpAuwOcMjt33cbOtJwYI03Gre9Y83SuGLJ1tkjdBt7Z7P4duFTmhSnRAXS7ymhjA7gcRMVFiDeznqEIkJ9R24Wd0dPPa1Ck/XvwJO6gayade6ZkmY+eVdqc9NNpxT9s39J4yTrcdiNpbH0WAuFEW5QavNjOUBYco1dd8Ic=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785491719; c=relaxed/simple;
	bh=yW6RhZvuXTXdVFnVlFob/HJMgH21yu4UQrqnhYTDcd0=;
	h=From:To:Cc:Subject:Message-ID:MIME-Version:Content-Type:Date; b=YIuWLsBhdNKJ+XTZ5nZ2VHWBA8XD9v17PwT9G9kfqM6wj+JR5+WECbyVTWIyj9cHoKAa7glH3sswssA+zkT+gmHBextwcpkDGkRrg4bDC5A+1V4LWcnNaESzfb96lkES2n3d+ugOMMbeVM1bm/VePYiMNpjrOAi6QOQb6OT5EOQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=gVoSEpTv; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="gVoSEpTv"
Received: by smtp.kernel.org (Postfix) with UTF8SMTPSA id 78CCB1F000E9;
	Fri, 31 Jul 2026 09:55:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1785491704;
	bh=mmsyaXlTFwznzYLlEJF3sMY3DY+k6fK78Dx18suj9WA=;
	h=From:To:Cc:Subject:Date;
	b=gVoSEpTv+jksdfqBUUxUpd/qJ+eDUcRw7rjGPBj5RB/J5DBhG7qRzFsPzjqIO2Wmk
	 nRq3F9OwZKOsG/N2AbbPGTvrogJ91F3Tl2genSkoC4+quLXufQcMsUl0f94CjUFrEj
	 beZ1L3PDE6HQoN+DacCYipOT9VrTlrKA72PkL3+aRXSar38/LuDBGevxOtBGCwI6D/
	 ANCh/xyhU3ccVTWuD/z7Ykp+JqTENuoRA2mEzyChdSzkUN7r9XY0DpHiHwwxKoTmDk
	 O5eUP80eEeGpiJ2RO7wxXwZ9Ghro1++o33GBjJ4zgL9ZkdjZn26TGsQ9yjB8CkmBql
	 7TjB41ScOmizg==
From: "syzbot" <syzbot@kernel.org>
To: syzkaller-bugs@googlegroups.com, Slawomir Stepien <sst@poczta.fm>, "Andrew Lunn" <andrew+netdev@lunn.ch>, "David S. Miller" <davem@davemloft.net>, "Eric Dumazet" <edumazet@google.com>, "Jakub Kicinski" <kuba@kernel.org>, <netdev@vger.kernel.org>, "Paolo Abeni" <pabeni@redhat.com>
Cc: linux-kernel@vger.kernel.org, syzbot@lists.linux.dev
Subject: [PATCH] netdevsim: fix deadlock in nsim_bus_dev_max_vfs_write()
Message-ID: <b7bf56ea-7522-4163-acd5-aaa69ad03b3a@mail.kernel.org>
Precedence: bulk
X-Mailing-List: syzbot@lists.linux.dev
List-Id: <syzbot.lists.linux.dev>
List-Subscribe: <mailto:syzbot+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:syzbot+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Date: Fri, 31 Jul 2026 09:55:04 +0000 (UTC)

From: Slawomir Stepien <sst@poczta.fm>

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
Signed-off-by: Slawomir Stepien <sst@poczta.fm>

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
See https://goo.gle/syzbot-ai-patches for information about AI-generated patches.
You can comment on the patch as usual, syzbot will try to address
the comments and send a new version of the patch if necessary.
syzbot engineers can be reached at syzkaller@googlegroups.com.
