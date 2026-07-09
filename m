Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BB00C1BD9C9
	for <syzbot@lists.linux.dev>; Thu,  9 Jul 2026 12:41:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783600887; cv=none; b=UQ3NPJPzoVcFnKj/ZeRwcVYcEZ6zQATj53GVURe1O7DoRiiXMcb80iG0ayAdFEasM0ezxYB1cXCQ9jDtcW8Ak7btTI5q0V9zkwO3SUTBP0x8IkxtR3dbl5OPn5JKSSKmPhB2l8cHzASoa9FE9HdOwgvoL3A23vfl6FJuAFqp/FU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783600887; c=relaxed/simple;
	bh=NI/fVHS9lyWoyMFQZ4ORMdz7+H38wTKMEvyzp2qeQLk=;
	h=From:To:Cc:Subject:Message-ID:MIME-Version:Content-Type:Date; b=LyK8HpJVh4nR5Sbi/w0qFZrEXzzmUCdvwCA4IfMPFwfgPcmsSCNGQQCQz9mpFLURRKDcqZ61gOEdzAdlSZXuTfC2suyzvNdIizmcM+4SramQZtJhWvFjAvTzfvDyaxknZVrGU1pLgvhcSup+GM2rIAnMr3Ql40F8YLHX4+TZ/E0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=PwFXcgPG; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="PwFXcgPG"
Received: by smtp.kernel.org (Postfix) with UTF8SMTPSA id 2E1B51F000E9;
	Thu,  9 Jul 2026 12:41:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1783600885;
	bh=8TZ8qMsWWMLuYZAwGiJohcas7ce3D+89TJunBvwzFhk=;
	h=From:To:Cc:Subject:Date;
	b=PwFXcgPGjkK20T8qH9qcI9WMMofr8RV1HP+Do4oKi9LqhLJbbGGVLpYO46zlkC23S
	 CWRnnv0ipQRPOr9kq4eTMKLQWhGASsg8KZtuF6ItWrWaOwekNTxv218A5MEM8kWfMh
	 S7QmWPqb3ENzekeehS5vzAh7BZ6aVwiVjzQ5Icx9xrrQ7thUPGQOlljFVZYiAJQVY5
	 wdWrfVY+X2VeAKSegXHm9niSEGFCae/+1/7yLygwiIPjtJk6B3Ln6wX7OV+L3n6Oj7
	 7vq6WjUnrNaIyLh7WByWOoBaWZ8+A3bmAicLmujPay9IAVEcSIZAlHA9TUmlfm/w+k
	 rX9m7jhxxQHDg==
From: "syzbot" <syzbot@kernel.org>
To: syzkaller-upstream-moderation@googlegroups.com
Cc: syzbot@lists.linux.dev
Subject: [PATCH RFC] nbd: fix I/O hang on dead socket and console spam
Message-ID: <b5a8f0cc-71aa-4deb-8864-29d7f0c5509a@mail.kernel.org>
Precedence: bulk
X-Mailing-List: syzbot@lists.linux.dev
List-Id: <syzbot.lists.linux.dev>
List-Subscribe: <mailto:syzbot+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:syzbot+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Date: Thu,  9 Jul 2026 12:41:25 +0000 (UTC)

When an NBD device is configured without NBD_CFLAG_DISCONNECT_ON_CLOSE and
with a timeout of 0, a closed socket can lead to a permanent I/O hang. If
the connection is closed, the NBD recv_work thread marks the socket as
dead. However, if an I/O request is sent, it will eventually time out. In
nbd_xmit_timeout(), if the configured timeout is 0, the code currently only
checks if the socket has been replaced. It fails to check if the socket is
dead. As a result, the request timer is unconditionally reset and the
request stays in-flight forever, causing tasks like udevd to hang
indefinitely in TASK_UNINTERRUPTIBLE and triggering the hung task detector:

INFO: task udevd:5877 blocked in I/O wait for more than 143 seconds.
task:udevd           state:D
Call Trace:
 <TASK>
 __schedule+0x17e7/0x5630
 schedule+0x164/0x2b0
 io_schedule+0x7f/0xd0
 folio_wait_bit_common+0x836/0xbc0
 do_read_cache_folio+0x1ac/0x590
 read_part_sector+0xb6/0x2b0
 adfspart_check_POWERTEC+0x9a/0x7a0
 bdev_disk_changed+0x851/0x17a0
 blkdev_get_whole+0x372/0x510
 bdev_open+0x324/0xd70
 blkdev_open+0x461/0x600
 do_dentry_open+0x816/0x1380
 vfs_open+0x3b/0x340
 path_openat+0x2e44/0x3830
 do_file_open+0x23e/0x4a0
 do_sys_openat2+0x115/0x200
 __x64_sys_openat+0x138/0x170
 do_syscall_64+0x15f/0x560
 entry_SYSCALL_64_after_hwframe+0x77/0x7f
 </TASK>

Additionally, repeated attempts to connect to an already-in-use NBD device
can cause console spam because the "nbd%d already in use" error message in
nbd_genl_connect() is not rate-limited. This can delay console_unlock() and
trigger NMI backtraces.

Fix the I/O hang by checking nsock->dead in addition to the cookie check in
nbd_xmit_timeout(). If the socket is dead, the command is requeued. When
nbd_handle_cmd() subsequently processes it, it will evaluate the dead
socket and properly fail the I/O request, gracefully terminating the hung
read operation.

Fix the console spam by changing the pr_err() in nbd_genl_connect() to
pr_err_ratelimited().

Fixes: 2c272542baee ("nbd: requeue command if the soecket is changed")
Assisted-by: Gemini:gemini-3.1-pro-preview Gemini:gemini-3-flash-preview syzbot
Reported-by: syzbot+82de77d3f217960f087d@syzkaller.appspotmail.com
Closes: https://syzkaller.appspot.com/bug?extid=82de77d3f217960f087d
Link: https://syzkaller.appspot.com/ai_job?id=13cee482-fa85-4a3d-bcc1-e2cc9ae8e909
To: "Jens Axboe" <axboe@kernel.dk>
To: "Josef Bacik" <josef@toxicpanda.com>
To: <linux-block@vger.kernel.org>
To: <nbd@other.debian.org>
Cc: <linux-kernel@vger.kernel.org>

---
diff --git a/drivers/block/nbd.c b/drivers/block/nbd.c
index 8f10762e9..eedb1c870 100644
--- a/drivers/block/nbd.c
+++ b/drivers/block/nbd.c
@@ -523,7 +523,7 @@ static enum blk_eh_timer_return nbd_xmit_timeout(struct request *req)
 			blk_rq_bytes(req), (req->timeout / HZ) * cmd->retries);
 
 		mutex_lock(&nsock->tx_lock);
-		if (cmd->cookie != nsock->cookie) {
+		if (cmd->cookie != nsock->cookie || nsock->dead) {
 			nbd_requeue_cmd(cmd);
 			mutex_unlock(&nsock->tx_lock);
 			mutex_unlock(&cmd->lock);
@@ -2172,7 +2172,7 @@ static int nbd_genl_connect(struct sk_buff *skb, struct genl_info *info)
 		nbd_put(nbd);
 		if (index == -1)
 			goto again;
-		pr_err("nbd%d already in use\n", index);
+		pr_err_ratelimited("nbd%d already in use\n", index);
 		return -EBUSY;
 	}
 


base-commit: 8cdeaa50eae8dad34885515f62559ee83e7e8dda
-- 
This is an AI-generated patch subject to moderation.
Reply with '#syz upstream' to Sign-off the patch as a human author
and send it to the upstream kernel mailing lists.
Reply with '#syz reject' to reject it ('#syz unreject' to undo).

See https://goo.gle/syzbot-ai-patches for information about AI-generated patches.
You can comment on the patch as usual, syzbot will try to address
the comments and send a new version of the patch if necessary.
syzbot engineers can be reached at syzkaller@googlegroups.com.
