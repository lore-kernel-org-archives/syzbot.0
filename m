Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2CA4E48A2D5
	for <syzbot@lists.linux.dev>; Wed, 15 Jul 2026 15:32:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784129526; cv=none; b=dZv9PjdCRgEyWON90KHtZVgKE34ReDfYGIUewZjaumDvlahn+VDxKbTWJT6sStC8RWKDT/OJLXJLW3StgvFGYLz38XEJSbpueBC6KkqE/xmAr0Tcr8CvYggk3smfhE0OljJZVH9iziQXUFYGAGKmgmTTSEhJyu3zk5TxdF3GqO4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784129526; c=relaxed/simple;
	bh=1TAUSCIrpbY9rhEoYV5/aGlANvUFNLDYlOOYzCarnjs=;
	h=From:To:Cc:Subject:Message-ID:MIME-Version:Content-Type:Date; b=epa7eHmt/cQQPtNGUXMEGAEvr39C4GycCNKyheVVg/1q8IgRCtwncEVmPluPhToxpSKHUR/pVp0ofJ/c9DjCe9e/PgCh0K3PvzKeD6R7xGfxcO2TvR1Q7bz42+LOLCdnLNqstgTxus6v5OF1ZmxaBZdj5FDhMnhtIEtF2eqUW/Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=PR3vB+RS; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="PR3vB+RS"
Received: by smtp.kernel.org (Postfix) with UTF8SMTPSA id 970021F00A3A;
	Wed, 15 Jul 2026 15:32:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1784129524;
	bh=7DeKRWMYuGRCTwjwKF2aNkL5ySsmAig3VuAfWGTAg9Q=;
	h=From:To:Cc:Subject:Date;
	b=PR3vB+RSnUcFT8QpjqmePfl5MmFPLU3Ma56X5VWSNp6Gs1NHwdfOfOhWT5UTCVIDp
	 lvLZ3ruXQ5J31tmBHj2Hb34+9eBulk8UuZSW9ktN/USOPlEIKSuy7uZA70nuLReq7/
	 j7LQegSJoJmG3OKhtndmbSU+CYKIjX23mJJRjeR9s2pE26Erv51VsBIIMfxtcOcqMv
	 YaGiHu3i7GwEKy6/wkDkIPeX0Lmf+g8KK33+ZzO9RIncdT7nPSxoP8WYFHy5LrpKJv
	 R/imEawQHQV6ggxrq64pnfLpL7TcEdDsjw+C8u8dPaKNd3DX06LRvlO7vFjVXOn7jr
	 HeeIPWGbTnoaA==
From: "syzbot" <syzbot@kernel.org>
To: syzkaller-upstream-moderation@googlegroups.com
Cc: syzbot@lists.linux.dev
Subject: [PATCH RFC] nbd: fix hung task and integer overflow in timeout configuration
Message-ID: <b6347da3-3c11-46cb-b467-3416e4104deb@mail.kernel.org>
Precedence: bulk
X-Mailing-List: syzbot@lists.linux.dev
List-Id: <syzbot.lists.linux.dev>
List-Subscribe: <mailto:syzbot+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:syzbot+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Date: Wed, 15 Jul 2026 15:32:04 +0000 (UTC)

An unprivileged user can configure an NBD device with an arbitrarily large
dead connection timeout via the NBD_ATTR_DEAD_CONN_TIMEOUT netlink
attribute. When a request is queued and the connection is dead,
nbd_handle_cmd() calls wait_for_reconnect(), which blocks the current
thread using wait_event_timeout(). Because this wait is in the
TASK_UNINTERRUPTIBLE state, a timeout larger than 120 seconds triggers the
hung task detector, leading to a kernel panic:

INFO: task kworker/1:1H:667 blocked for more than 143 seconds.
Workqueue: kblockd blk_mq_run_work_fn
Call Trace:
 <TASK>
 __schedule+0x17e7/0x5630
 schedule+0x164/0x2b0
 schedule_timeout+0x152/0x2c0
 wait_for_reconnect drivers/block/nbd.c:1107 [inline]
 nbd_handle_cmd drivers/block/nbd.c:1149 [inline]
 nbd_queue_rq+0x797/0xfb0 drivers/block/nbd.c:1207
 blk_mq_dispatch_rq_list+0x499/0x1990
 __blk_mq_sched_dispatch_requests+0xd36/0x1580
 blk_mq_sched_dispatch_requests+0xd7/0x190
 blk_mq_run_work_fn+0x16c/0x300
 process_one_work kernel/workqueue.c:3322 [inline]
 process_scheduled_works+0xa8e/0x14e0
 worker_thread+0x92d/0xe10
 kthread+0x388/0x470
 ret_from_fork+0x514/0xb70
 ret_from_fork_asm+0x1a/0x30
 </TASK>

Historically, wait_for_reconnect() used wait_event_interruptible_timeout(),
but commit ff57dc94faec ("nbd: wait uninterruptible for the dead timeout")
changed it to wait_event_timeout() to prevent signals from prematurely
interrupting the wait. However, using TASK_UNINTERRUPTIBLE for arbitrarily
long waits is an anti-pattern that trips the hung task detector.

Fix this by replacing wait_event_timeout() with wait_event_idle_timeout().
This puts the task into the TASK_IDLE state (TASK_UNINTERRUPTIBLE |
TASK_NOLOAD), which ignores signals as intended but is explicitly ignored
by the hung task detector.

Additionally, add defense-in-depth by capping the parsed timeout to U32_MAX
and the resulting jiffies to MAX_SCHEDULE_TIMEOUT. This prevents integer
overflow when the u64 timeout is implicitly cast to a signed long by
schedule_timeout(), which could otherwise result in a negative timeout and
cause the wait to return immediately.

Fixes: ff57dc94faec ("nbd: wait uninterruptible for the dead timeout")
Assisted-by: Gemini:gemini-3.1-pro-preview syzbot
Reported-by: syzbot+30c16035531e3248dcbc@syzkaller.appspotmail.com
Closes: https://syzkaller.appspot.com/bug?extid=30c16035531e3248dcbc
Link: https://syzkaller.appspot.com/ai_job?id=f07c3611-0a61-4d67-9f4d-033b1cb82e1e
To: "Jens Axboe" <axboe@kernel.dk>
To: "Josef Bacik" <josef@toxicpanda.com>
To: <linux-block@vger.kernel.org>
To: <nbd@other.debian.org>
To: "Josef Bacik" <jbacik@fb.com>
Cc: <linux-kernel@vger.kernel.org>

---
diff --git a/drivers/block/nbd.c b/drivers/block/nbd.c
index 8f10762e9..874a916f8 100644
--- a/drivers/block/nbd.c
+++ b/drivers/block/nbd.c
@@ -1104,11 +1104,11 @@ static int wait_for_reconnect(struct nbd_device *nbd)
 	if (!config->dead_conn_timeout)
 		return 0;
 
-	if (!wait_event_timeout(config->conn_wait,
-				test_bit(NBD_RT_DISCONNECTED,
-					 &config->runtime_flags) ||
-				atomic_read(&config->live_connections) > 0,
-				config->dead_conn_timeout))
+	if (!wait_event_idle_timeout(
+		    config->conn_wait,
+		    test_bit(NBD_RT_DISCONNECTED, &config->runtime_flags) ||
+			    atomic_read(&config->live_connections) > 0,
+		    config->dead_conn_timeout))
 		return 0;
 
 	return !test_bit(NBD_RT_DISCONNECTED, &config->runtime_flags);
@@ -2194,9 +2194,11 @@ static int nbd_genl_connect(struct sk_buff *skb, struct genl_info *info)
 		nbd_set_cmd_timeout(nbd,
 				    nla_get_u64(info->attrs[NBD_ATTR_TIMEOUT]));
 	if (info->attrs[NBD_ATTR_DEAD_CONN_TIMEOUT]) {
-		config->dead_conn_timeout =
+		u64 timeout =
 			nla_get_u64(info->attrs[NBD_ATTR_DEAD_CONN_TIMEOUT]);
-		config->dead_conn_timeout *= HZ;
+		timeout = min_t(u64, timeout, U32_MAX);
+		config->dead_conn_timeout =
+			min_t(u64, timeout * HZ, MAX_SCHEDULE_TIMEOUT);
 	}
 	if (info->attrs[NBD_ATTR_SERVER_FLAGS])
 		config->flags =
@@ -2415,9 +2417,11 @@ static int nbd_genl_reconfigure(struct sk_buff *skb, struct genl_info *info)
 		nbd_set_cmd_timeout(nbd,
 				    nla_get_u64(info->attrs[NBD_ATTR_TIMEOUT]));
 	if (info->attrs[NBD_ATTR_DEAD_CONN_TIMEOUT]) {
-		config->dead_conn_timeout =
+		u64 timeout =
 			nla_get_u64(info->attrs[NBD_ATTR_DEAD_CONN_TIMEOUT]);
-		config->dead_conn_timeout *= HZ;
+		timeout = min_t(u64, timeout, U32_MAX);
+		config->dead_conn_timeout =
+			min_t(u64, timeout * HZ, MAX_SCHEDULE_TIMEOUT);
 	}
 	if (info->attrs[NBD_ATTR_CLIENT_FLAGS]) {
 		u64 flags = nla_get_u64(info->attrs[NBD_ATTR_CLIENT_FLAGS]);


base-commit: a13c140cc289c0b7b3770bce5b3ad42ab35074aa
-- 
This is an AI-generated patch subject to moderation.
Reply with '#syz upstream' to Sign-off the patch as a human author
and send it to the upstream kernel mailing lists.
Reply with '#syz reject' to reject it ('#syz unreject' to undo).

See https://goo.gle/syzbot-ai-patches for information about AI-generated patches.
You can comment on the patch as usual, syzbot will try to address
the comments and send a new version of the patch if necessary.
syzbot engineers can be reached at syzkaller@googlegroups.com.
