Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8963D13777E
	for <syzbot@lists.linux.dev>; Sat, 27 Jun 2026 00:42:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782520975; cv=none; b=pMC7IRW2JJ+sEMZ6tjgVdT9jn9AI7XUYXOWpcQ/TwM4i7dqNWfJkoU9gMNj5AiciijqIC8Xyf34wv8GvZqeKaG9WSGk3XG/swFoPG8nnjwjRgD2HlZvh7i8iToNDXLzApvU+sBVjv326euSnuT/V1V6OmM4WXwIYHILh0E0LJDA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782520975; c=relaxed/simple;
	bh=aq2Z7uDrePx4MlzQ90Vwso/zxGkHcH/KYdpjq7YRj5Y=;
	h=From:To:Cc:Subject:Message-ID:MIME-Version:Content-Type:Date; b=aS4tNrT5gS5WXXbW2kCLjr0GZuT2vuXZDnG4EzBmqr+S0O81r2dSy0kCAJOHVh8KXaLvBqOKZwvM3k9P2stJOe9XVrKqTCM8BaYzHmVUUuVbThAbRpg2A3kIReV/SNJLXD6FrmDOQ0qbHpcFBHX7RjK+9YT1RVDdSL8FonDttfE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=jX7rhkBC; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="jX7rhkBC"
Received: by smtp.kernel.org (Postfix) with UTF8SMTPSA id 1AEEF1F000E9;
	Sat, 27 Jun 2026 00:42:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1782520974;
	bh=ccaZqYFNW5vHezizaKvHfxRVmMWLfixxPwjCcyZTIFs=;
	h=From:To:Cc:Subject:Date;
	b=jX7rhkBCsH5b6/VXlI4cpz1CgiZsNdNXGDMi7YrFBS9/A5w7gvY7lJBHTkHJxeaWi
	 LR8jxNlG+PoapwWXGBif92Dn8UgTrAzlWJ26snP62OVEqzrzLxKiJmEth31gmszsY7
	 SFpgIcpR5TO3wwnRZSmL/OuSB+bLuMjGqLMH0V7TKJpugmV0RyQ/r2lJUXZFaWZg91
	 K8BsxYwUEcJWrGJeGIxcmLJMUTPpPLljqbo8WiUI2vmpyzJe7c32dFeMyVqfehmBzw
	 5oL8mTXCQpgVsE6hiie7wKXbqvn0ZtOINFZob/CGtYzx2k0TI2GGgeiKEa8sH+kY3D
	 q62ff4AwKeLqQ==
From: "syzbot" <syzbot@kernel.org>
To: syzkaller-upstream-moderation@googlegroups.com
Cc: syzbot@lists.linux.dev
Subject: [PATCH RFC] nbd: fix deadlocks in socket shutdown and queue freeze
Message-ID: <2ca4a3bd-0d41-4a4f-8838-d440c3541498@mail.kernel.org>
Precedence: bulk
X-Mailing-List: syzbot@lists.linux.dev
List-Id: <syzbot.lists.linux.dev>
List-Subscribe: <mailto:syzbot+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:syzbot+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Date: Sat, 27 Jun 2026 00:42:54 +0000 (UTC)

A classic deadlock (circular dependency) can occur involving the NBD
socket's transmit lock (nsock->tx_lock), the socket's memory wait queue,
and the block device's open mutex (disk->open_mutex).

The hung task detector reports:

INFO: task udevd:5044 blocked for more than 143 seconds.
task:udevd           state:D stack:23200 pid:5044  tgid:5044  ppid:1
task_flags:0x400140 flags:0x00080000
Call Trace:
 <TASK>
 __schedule+0x1840/0x56e0 kernel/sched/core.c:7189
 schedule+0x164/0x360 kernel/sched/core.c:7283
 schedule_preempt_disabled+0x13/0x30 kernel/sched/core.c:7340
 __mutex_lock+0x7c5/0x1590 kernel/locking/mutex.c:820
 bdev_open+0xde/0xd70 block/bdev.c:953
 blkdev_open+0x461/0x600 block/fops.c:697
 do_dentry_open+0x774/0x14c0 fs/open.c:947
 vfs_open+0x3b/0x340 fs/open.c:1079
 path_openat+0x2e3b/0x3890 fs/namei.c:4858
 do_file_open+0x23e/0x4a0 fs/namei.c:4887
 do_sys_openat2+0x113/0x200 fs/open.c:1364
 __x64_sys_openat+0x138/0x170 fs/open.c:1381
 do_syscall_64+0x15f/0x560 arch/x86/entry/syscall_64.c:94
 entry_SYSCALL_64_after_hwframe+0x77/0x7f
 </TASK>

The sequence of events leading to the hung tasks is:
1. The NBD device is opened and ioctl(NBD_SET_SIZE_BLOCKS) is called,
setting the GD_NEED_PART_SCAN bit on the disk's state.
2. The device is connected and ioctl(NBD_DO_IT) starts the receive threads
and blocks in wait_event_interruptible() waiting for disconnect.
3. A background process (e.g., udevd) attempts to open /dev/nbd0, acquiring
disk->open_mutex. Because GD_NEED_PART_SCAN is set, it triggers a partition
scan.
4. The partition scan submits a read bio, which is queued to the NBD
driver. nbd_handle_cmd() acquires nsock->tx_lock and calls sock_sendmsg().
If the other end of the socket is not being read, the socket buffer fills
up, and sock_sendmsg() blocks in sk_stream_wait_memory(). At this point,
the background process holds both nsock->tx_lock and disk->open_mutex.
5. If the original process exits, nbd_start_device_ioctl() attempts to shut
down the socket by calling sock_shutdown(). However, sock_shutdown() blocks
indefinitely trying to acquire nsock->tx_lock.
6. Since sock_shutdown() is blocked, the socket is never shut down, and the
background process never wakes up. Other processes trying to open or
release the block device will block indefinitely on disk->open_mutex,
leading to system-wide hung tasks.

Additionally, there are two other related deadlock scenarios:
1. If a request is sent successfully but the server never replies, and
timeout=0 is set, nbd_xmit_timeout() simply resets the timer. The request
stays in flight forever.
2. When nbd_start_device() is called, it holds nbd->config_lock and calls
nbd_set_size(). nbd_set_size() calls blk_mq_freeze_queue() (via
queue_limits_commit_update_frozen()), which waits for all in-flight
requests to complete. If a request hangs forever, nbd_set_size() hangs
holding nbd->config_lock. This prevents any other task from acquiring the
lock to shut down the device, leading to a deadlock.

To fix these issues:
1. In sock_shutdown(), call kernel_sock_shutdown() before acquiring
nsock->tx_lock. This asynchronously wakes up the blocked sock_sendmsg(),
causing it to return -EPIPE, failing the request, releasing the locks, and
breaking the deadlock.
2. In nbd_set_size(), drop nbd->config_lock before calling
queue_limits_commit_update_frozen(). This allows nbd_disconnect() or
nbd_release() to acquire the lock, shut down the sockets, and abort the
requests, unblocking the frozen queue.
3. In nbd_xmit_timeout(), if timeout=0, check if the socket is dead
(nsock->dead). If it is, abort the request to unblock the queue. Also, use
mutex_trylock(&nsock->tx_lock) to avoid deadlocking the timeout handler
itself, and if the request is actively sending (NBD_CMD_SENDING), call
kernel_sock_shutdown().

Fixes: 9561a7ade0c2 ("nbd: add multi-connection support")
Assisted-by: Gemini:gemini-3.1-pro-preview Gemini:gemini-3-flash-preview syzbot
Reported-by: syzbot+5c6179f2c4f1e111df11@syzkaller.appspotmail.com
Closes: https://syzkaller.appspot.com/bug?extid=5c6179f2c4f1e111df11
Link: https://syzkaller.appspot.com/ai_job?id=d5af2114-63a1-42d3-8774-43b898809d78
To: "Jens Axboe" <axboe@kernel.dk>
To: "Josef Bacik" <josef@toxicpanda.com>
To: <linux-block@vger.kernel.org>
To: <nbd@other.debian.org>
Cc: <linux-kernel@vger.kernel.org>

---
diff --git a/drivers/block/nbd.c b/drivers/block/nbd.c
index fe63f3c55..a910e1627 100644
--- a/drivers/block/nbd.c
+++ b/drivers/block/nbd.c
@@ -144,6 +144,7 @@ struct nbd_device {
 
 /* Just part of request header or data payload is sent successfully */
 #define NBD_CMD_PARTIAL_SEND	3
+#define NBD_CMD_SENDING 4
 
 struct nbd_cmd {
 	struct nbd_device *nbd;
@@ -351,6 +352,7 @@ static int nbd_set_size(struct nbd_device *nbd, loff_t bytesize, loff_t blksize)
 	if (!nbd->pid)
 		return 0;
 
+	mutex_unlock(&nbd->config_lock);
 	lim = queue_limits_start_update(nbd->disk->queue);
 	if (nbd->config->flags & NBD_FLAG_SEND_TRIM)
 		lim.max_hw_discard_sectors = UINT_MAX >> SECTOR_SHIFT;
@@ -372,6 +374,7 @@ static int nbd_set_size(struct nbd_device *nbd, loff_t bytesize, loff_t blksize)
 	lim.logical_block_size = blksize;
 	lim.physical_block_size = blksize;
 	error = queue_limits_commit_update_frozen(nbd->disk->queue, &lim);
+	mutex_lock(&nbd->config_lock);
 	if (error)
 		return error;
 
@@ -407,6 +410,7 @@ static void sock_shutdown(struct nbd_device *nbd)
 
 	for (i = 0; i < config->num_connections; i++) {
 		struct nbd_sock *nsock = config->socks[i];
+		kernel_sock_shutdown(nsock->sock, SHUT_RDWR);
 		mutex_lock(&nsock->tx_lock);
 		nbd_mark_nsock_dead(nbd, nsock, 0);
 		mutex_unlock(&nsock->tx_lock);
@@ -454,8 +458,23 @@ static enum blk_eh_timer_return nbd_xmit_timeout(struct request *req)
 	struct nbd_device *nbd = cmd->nbd;
 	struct nbd_config *config;
 
-	if (!mutex_trylock(&cmd->lock))
+	if (!mutex_trylock(&cmd->lock)) {
+		if (test_bit(NBD_CMD_SENDING, &cmd->flags)) {
+			config = nbd_get_config_unlocked(nbd);
+			if (config) {
+				if (cmd->index < config->num_connections) {
+					struct nbd_sock *nsock =
+						config->socks[cmd->index];
+					if (nsock &&
+					    cmd->cookie == nsock->cookie)
+						kernel_sock_shutdown(
+							nsock->sock, SHUT_RDWR);
+				}
+				nbd_config_put(nbd);
+			}
+		}
 		return BLK_EH_RESET_TIMER;
+	}
 
 	/* partial send is handled in nbd_sock's work function */
 	if (test_bit(NBD_CMD_PARTIAL_SEND, &cmd->flags)) {
@@ -522,7 +541,11 @@ static enum blk_eh_timer_return nbd_xmit_timeout(struct request *req)
 			(unsigned long long)blk_rq_pos(req) << 9,
 			blk_rq_bytes(req), (req->timeout / HZ) * cmd->retries);
 
-		mutex_lock(&nsock->tx_lock);
+		if (!mutex_trylock(&nsock->tx_lock)) {
+			mutex_unlock(&cmd->lock);
+			nbd_config_put(nbd);
+			return BLK_EH_RESET_TIMER;
+		}
 		if (cmd->cookie != nsock->cookie) {
 			nbd_requeue_cmd(cmd);
 			mutex_unlock(&nsock->tx_lock);
@@ -530,6 +553,15 @@ static enum blk_eh_timer_return nbd_xmit_timeout(struct request *req)
 			nbd_config_put(nbd);
 			return BLK_EH_DONE;
 		}
+		if (nsock->dead) {
+			cmd->status = BLK_STS_IOERR;
+			__clear_bit(NBD_CMD_INFLIGHT, &cmd->flags);
+			mutex_unlock(&nsock->tx_lock);
+			mutex_unlock(&cmd->lock);
+			nbd_config_put(nbd);
+			blk_mq_complete_request(req);
+			return BLK_EH_DONE;
+		}
 		mutex_unlock(&nsock->tx_lock);
 		mutex_unlock(&cmd->lock);
 		nbd_config_put(nbd);
@@ -699,6 +731,7 @@ static blk_status_t nbd_send_cmd(struct nbd_device *nbd, struct nbd_cmd *cmd,
 	cmd->index = index;
 	cmd->cookie = nsock->cookie;
 	cmd->retries = 0;
+	set_bit(NBD_CMD_SENDING, &cmd->flags);
 	request.type = htonl(type | nbd_cmd_flags);
 	if (type != NBD_CMD_FLUSH) {
 		request.from = cpu_to_be64((u64)blk_rq_pos(req) << 9);
@@ -718,15 +751,17 @@ static blk_status_t nbd_send_cmd(struct nbd_device *nbd, struct nbd_cmd *cmd,
 	if (result < 0) {
 		if (was_interrupted(result)) {
 			/* If we haven't sent anything we can just return BUSY,
-			 * however if we have sent something we need to make
-			 * sure we only allow this req to be sent until we are
-			 * completely done.
-			 */
+				 * however if we have sent something we need to make
+				 * sure we only allow this req to be sent until we are
+				 * completely done.
+				 */
 			if (sent) {
 				nbd_sched_pending_work(nbd, nsock, cmd, sent);
+				clear_bit(NBD_CMD_SENDING, &cmd->flags);
 				return BLK_STS_OK;
 			}
 			set_bit(NBD_CMD_REQUEUED, &cmd->flags);
+			clear_bit(NBD_CMD_SENDING, &cmd->flags);
 			return BLK_STS_RESOURCE;
 		}
 		dev_err_ratelimited(disk_to_dev(nbd->disk),
@@ -762,6 +797,7 @@ static blk_status_t nbd_send_cmd(struct nbd_device *nbd, struct nbd_cmd *cmd,
 			if (result < 0) {
 				if (was_interrupted(result)) {
 					nbd_sched_pending_work(nbd, nsock, cmd, sent);
+					clear_bit(NBD_CMD_SENDING, &cmd->flags);
 					return BLK_STS_OK;
 				}
 				dev_err(disk_to_dev(nbd->disk),
@@ -784,10 +820,12 @@ static blk_status_t nbd_send_cmd(struct nbd_device *nbd, struct nbd_cmd *cmd,
 	trace_nbd_payload_sent(req, handle);
 	nsock->pending = NULL;
 	nsock->sent = 0;
+	clear_bit(NBD_CMD_SENDING, &cmd->flags);
 	__set_bit(NBD_CMD_INFLIGHT, &cmd->flags);
 	return BLK_STS_OK;
 
 requeue:
+	clear_bit(NBD_CMD_SENDING, &cmd->flags);
 	/*
 	 * Can't requeue in case we are dealing with partial send
 	 *


base-commit: 8cd9520d35a6c38db6567e97dd93b1f11f185dc6
-- 
This is an AI-generated patch subject to moderation.
Reply with '#syz upstream' to Sign-off the patch as a human author
and send it to the upstream kernel mailing lists.
Reply with '#syz reject' to reject it ('#syz unreject' to undo).

See https://goo.gle/syzbot-ai-patches for information about AI-generated patches.
You can comment on the patch as usual, syzbot will try to address
the comments and send a new version of the patch if necessary.
syzbot engineers can be reached at syzkaller@googlegroups.com.
