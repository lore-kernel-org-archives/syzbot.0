Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9062770808
	for <syzbot@lists.linux.dev>; Sat, 27 Jun 2026 00:48:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782521335; cv=none; b=MPLkKJmqY9/1D3Dko9vkJTGxKPxJ0TpNBu/GVZ9E3Q49PN6eD4wbNOb8lydjkWML7M3uwoxOQFPwCmxh546YgCN1lfBLJqhYQ6/VjstCI/OLDE0Asu0NNiCOE0mVcTgTMQCdEue5qFPPOSSOk/4636b5VPIeuVltRscvVygNXN8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782521335; c=relaxed/simple;
	bh=tMylk4rKo+Q7mYjTu2+bSg2GheoFNA+9HIHLzqaDH+0=;
	h=From:To:Cc:Subject:Message-ID:MIME-Version:Content-Type:Date; b=JeaQhgq0vznKp052LPSWsCsYegsSzzcnt7rlVRabFqhhPPCuTdz2mVLXgVYCpfip0c4n0i0wuh13R5avA4d5sEHcOk0ODqUHnFCLw+NK9K40RX33O1v/TBixu6sC3gsXVzV2Bb694j1DqzYE+kdjIyHYQ647OJrX1r2Bemwe7o8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=lLF8oL0m; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="lLF8oL0m"
Received: by smtp.kernel.org (Postfix) with UTF8SMTPSA id 135EC1F000E9;
	Sat, 27 Jun 2026 00:48:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1782521334;
	bh=OwE9/Q4O2OgsL8vt5toLWFgIjOCC862OztKHqb7Wjts=;
	h=From:To:Cc:Subject:Date;
	b=lLF8oL0maz8MvihJTiKSDmKdX1UqIZT93t5sb+rCRlpJjgju2JdlPf+RQA9b7/Z7J
	 LrCdeARiJc8OvrwBuXw44zX0bUKeUI0AstgLJFH7PfUGdQyPR392TVABTOIHI3AAaf
	 VKSV3/JPDLQWECNrtSrXKNgbkVNTW4ax2wxSkPEAYk1UE5EkaE83GVFpw02OhZlfx7
	 kqOtPHrujJZApXryoZ1JbhMMuicIzkeXm/QghPwpgmT9y672LmsBEtaJnKlhHlJhp0
	 nDS2k03exdIUzaFynbSZ6glY8PHpKo1h29z8LSEsk0S+wO+OHoe7IC3URoTtcqbGS5
	 /EoxZhpfkiCmg==
From: "syzbot" <syzbot@kernel.org>
To: syzkaller-upstream-moderation@googlegroups.com
Cc: syzbot@lists.linux.dev
Subject: [PATCH RFC] nbd: fix generic netlink deadlock and lockdep exhaustion
Message-ID: <69ff9a21-60be-4e97-bc8f-a59e739fd982@mail.kernel.org>
Precedence: bulk
X-Mailing-List: syzbot@lists.linux.dev
List-Id: <syzbot.lists.linux.dev>
List-Subscribe: <mailto:syzbot+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:syzbot+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Date: Sat, 27 Jun 2026 00:48:54 +0000 (UTC)

A system-wide deadlock in the generic netlink subsystem can occur when the
NBD driver holds the global genl_mutex while waiting indefinitely for an
I/O request to complete.

When a device is connected with timeout=0 and does not reply to I/O
requests, any I/O sent to the device will hang forever. When nbd_set_size()
updates the device capacity, it triggers a uevent. This wakes up udevd,
which opens the device and issues I/O to read the partition table. This I/O
hangs.

A subsequent NBD_CMD_RECONFIGURE command calls nbd_set_size(), which calls
queue_limits_commit_update_frozen(). This freezes the queue, waiting
uninterruptibly for all inflight I/Os to complete. However, the process
supposed to service those inflight I/Os is blocked in the kernel waiting
for the queue to freeze, resulting in an unbreakable deadlock:

INFO: task syz.2.23:6285 blocked for more than 143 seconds.
Call Trace:
 <TASK>
 __schedule+0x1840/0x57a0 kernel/sched/core.c:7189
 schedule+0x164/0x360 kernel/sched/core.c:7283
 blk_mq_freeze_queue_wait+0x101/0x180 block/blk-mq.c:191
 blk_mq_freeze_queue include/linux/blk-mq.h:956 [inline]
 queue_limits_commit_update_frozen+0x55/0xd0 block/blk-settings.c:590
 nbd_set_size+0x454/0x680 drivers/block/nbd.c:374
 nbd_genl_size_set drivers/block/nbd.c:2069 [inline]
 nbd_genl_reconfigure+0x7e9/0x1e80 drivers/block/nbd.c:2373
 genl_family_rcv_msg_doit+0x233/0x340 net/netlink/genetlink.c:1114
 genl_family_rcv_msg net/netlink/genetlink.c:1194 [inline]
 genl_rcv_msg+0x614/0x7a0 net/netlink/genetlink.c:1209

Because nbd_genl_reconfigure() is called with genl_mutex held, this
localized hang escalates into a system-wide denial of service, blocking any
other task attempting to use generic netlink:

INFO: task syz-executor:6030 blocked for more than 143 seconds.
Call Trace:
 <TASK>
 __schedule+0x1840/0x57a0 kernel/sched/core.c:7189
 schedule+0x164/0x360 kernel/sched/core.c:7283
 schedule_preempt_disabled+0x13/0x30 kernel/sched/core.c:7340
 __mutex_lock_common kernel/locking/mutex.c:726 [inline]
 __mutex_lock+0x7c5/0x1590 kernel/locking/mutex.c:820
 genl_lock net/netlink/genetlink.c:35 [inline]
 genl_op_lock net/netlink/genetlink.c:60 [inline]
 genl_rcv_msg+0x10b/0x7a0 net/netlink/genetlink.c:1208

Fix this by implementing the following changes:

First, set .parallel_ops = true in nbd_genl_family to opt out of the global
genl_mutex. The NBD netlink callbacks are already thread-safe.

Second, replace queue_limits_commit_update_frozen() in nbd_set_size() with
a custom interruptible freeze using blk_mq_freeze_queue_wait_timeout(). If
the queue does not drain within 3 seconds, abort the limit update and
return -EBUSY.

Third, enforce a hard limit on the total number of active NBD devices to
prevent MAX_LOCKDEP_KEYS exhaustion. With .parallel_ops = true, rapid
creation of thousands of NBD devices could exhaust lockdep keys. Convert
nbd_total_devices to an atomic_t and reject new device creation if the
limit is exceeded.

Finally, remove blk_mq_freeze_queue() from nbd_add_socket() since it is
only called before the device is started (no inflight I/Os). Add a check
for !nbd->pid in nbd_handle_cmd() to return BLK_STS_IOERR if the device is
not fully started.

Fixes: 242a49e5c878 ("nbd: freeze the queue for queue limits updates")
Assisted-by: Gemini:gemini-3.1-pro-preview Gemini:gemini-3-flash-preview syzbot
Reported-by: syzbot+f272bbfbf8498ddadea5@syzkaller.appspotmail.com
Closes: https://syzkaller.appspot.com/bug?extid=f272bbfbf8498ddadea5
Link: https://syzkaller.appspot.com/ai_job?id=6d32b7be-789c-4af6-ac95-c1ea3097953b
To: "Jens Axboe" <axboe@kernel.dk>
To: "Josef Bacik" <josef@toxicpanda.com>
To: <linux-block@vger.kernel.org>
To: <nbd@other.debian.org>
Cc: <linux-kernel@vger.kernel.org>

---
diff --git a/drivers/block/nbd.c b/drivers/block/nbd.c
index fe63f3c55..c94cb15a0 100644
--- a/drivers/block/nbd.c
+++ b/drivers/block/nbd.c
@@ -52,7 +52,7 @@
 static DEFINE_IDR(nbd_index_idr);
 static DEFINE_MUTEX(nbd_index_mutex);
 static struct workqueue_struct *nbd_del_wq;
-static int nbd_total_devices = 0;
+static atomic_t nbd_total_devices = ATOMIC_INIT(0);
 
 struct nbd_sock {
 	struct socket *sock;
@@ -277,6 +277,7 @@ static void nbd_dev_remove(struct nbd_device *nbd)
 	mutex_unlock(&nbd_index_mutex);
 	destroy_workqueue(nbd->recv_workq);
 	put_disk(disk);
+	atomic_dec(&nbd_total_devices);
 }
 
 static void nbd_dev_remove_work(struct work_struct *work)
@@ -335,6 +336,7 @@ static int nbd_set_size(struct nbd_device *nbd, loff_t bytesize, loff_t blksize)
 {
 	struct queue_limits lim;
 	int error;
+	unsigned int memflags;
 
 	if (!blksize)
 		blksize = 1u << NBD_DEF_BLKSIZE_BITS;
@@ -371,7 +373,19 @@ static int nbd_set_size(struct nbd_device *nbd, loff_t bytesize, loff_t blksize)
 
 	lim.logical_block_size = blksize;
 	lim.physical_block_size = blksize;
-	error = queue_limits_commit_update_frozen(nbd->disk->queue, &lim);
+
+	memflags = memalloc_noio_save();
+	blk_freeze_queue_start(nbd->disk->queue);
+
+	if (!blk_mq_freeze_queue_wait_timeout(nbd->disk->queue, 3 * HZ)) {
+		blk_mq_unfreeze_queue(nbd->disk->queue, memflags);
+		queue_limits_cancel_update(nbd->disk->queue);
+		return -EBUSY;
+	}
+
+	error = queue_limits_commit_update(nbd->disk->queue, &lim);
+	blk_mq_unfreeze_queue(nbd->disk->queue, memflags);
+
 	if (error)
 		return error;
 
@@ -1131,6 +1145,11 @@ static blk_status_t nbd_handle_cmd(struct nbd_cmd *cmd, int index)
 		return BLK_STS_IOERR;
 	}
 
+	if (!nbd->pid) {
+		nbd_config_put(nbd);
+		return BLK_STS_IOERR;
+	}
+
 	if (index >= config->num_connections) {
 		dev_err_ratelimited(disk_to_dev(nbd->disk),
 				    "Attempted send on invalid socket\n");
@@ -1245,7 +1264,6 @@ static int nbd_add_socket(struct nbd_device *nbd, unsigned long arg,
 	struct socket *sock;
 	struct nbd_sock **socks;
 	struct nbd_sock *nsock;
-	unsigned int memflags;
 	int err;
 
 	/* Arg will be cast to int, check it to avoid overflow */
@@ -1255,12 +1273,6 @@ static int nbd_add_socket(struct nbd_device *nbd, unsigned long arg,
 	if (!sock)
 		return err;
 
-	/*
-	 * We need to make sure we don't get any errant requests while we're
-	 * reallocating the ->socks array.
-	 */
-	memflags = blk_mq_freeze_queue(nbd->disk->queue);
-
 	if (!netlink && !nbd->task_setup &&
 	    !test_bit(NBD_RT_BOUND, &config->runtime_flags))
 		nbd->task_setup = current;
@@ -1300,12 +1312,10 @@ static int nbd_add_socket(struct nbd_device *nbd, unsigned long arg,
 	INIT_WORK(&nsock->work, nbd_pending_cmd_work);
 	socks[config->num_connections++] = nsock;
 	atomic_inc(&config->live_connections);
-	blk_mq_unfreeze_queue(nbd->disk->queue, memflags);
 
 	return 0;
 
 put_socket:
-	blk_mq_unfreeze_queue(nbd->disk->queue, memflags);
 	sockfd_put(sock);
 	return err;
 }
@@ -1989,7 +1999,7 @@ static struct nbd_device *nbd_dev_add(int index, unsigned int refs)
 	 * Now publish the device.
 	 */
 	refcount_set(&nbd->refs, refs);
-	nbd_total_devices++;
+	atomic_inc(&nbd_total_devices);
 	return nbd;
 
 out_free_work:
@@ -2122,6 +2132,11 @@ static int nbd_genl_connect(struct sk_buff *skb, struct genl_info *info)
 	mutex_unlock(&nbd_index_mutex);
 
 	if (!nbd) {
+		if (atomic_read(&nbd_total_devices) >=
+		    max_t(int, 256, nbds_max)) {
+			pr_err("nbd: max number of devices reached\n");
+			return -ENOMEM;
+		}
 		nbd = nbd_dev_add(index, 2);
 		if (IS_ERR(nbd)) {
 			pr_err("failed to add new device\n");
@@ -2474,18 +2489,19 @@ static const struct genl_multicast_group nbd_mcast_grps[] = {
 };
 
 static struct genl_family nbd_genl_family __ro_after_init = {
-	.hdrsize	= 0,
-	.name		= NBD_GENL_FAMILY_NAME,
-	.version	= NBD_GENL_VERSION,
-	.module		= THIS_MODULE,
-	.small_ops	= nbd_connect_genl_ops,
-	.n_small_ops	= ARRAY_SIZE(nbd_connect_genl_ops),
-	.resv_start_op	= NBD_CMD_STATUS + 1,
-	.maxattr	= NBD_ATTR_MAX,
-	.netnsok	= 1,
+	.hdrsize = 0,
+	.name = NBD_GENL_FAMILY_NAME,
+	.version = NBD_GENL_VERSION,
+	.module = THIS_MODULE,
+	.small_ops = nbd_connect_genl_ops,
+	.n_small_ops = ARRAY_SIZE(nbd_connect_genl_ops),
+	.resv_start_op = NBD_CMD_STATUS + 1,
+	.maxattr = NBD_ATTR_MAX,
+	.netnsok = 1,
+	.parallel_ops = true,
 	.policy = nbd_attr_policy,
-	.mcgrps		= nbd_mcast_grps,
-	.n_mcgrps	= ARRAY_SIZE(nbd_mcast_grps),
+	.mcgrps = nbd_mcast_grps,
+	.n_mcgrps = ARRAY_SIZE(nbd_mcast_grps),
 };
 MODULE_ALIAS_GENL_FAMILY(NBD_GENL_FAMILY_NAME);
 
@@ -2540,7 +2556,7 @@ static int nbd_genl_status(struct sk_buff *skb, struct genl_info *info)
 
 	msg_size = nla_total_size(nla_attr_size(sizeof(u32)) +
 				  nla_attr_size(sizeof(u8)));
-	msg_size *= (index == -1) ? nbd_total_devices : 1;
+	msg_size *= (index == -1) ? atomic_read(&nbd_total_devices) : 1;
 
 	reply = genlmsg_new(msg_size, GFP_KERNEL);
 	if (!reply)


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
