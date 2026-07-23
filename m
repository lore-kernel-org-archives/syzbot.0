Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6C5AC4570EA
	for <syzbot@lists.linux.dev>; Thu, 23 Jul 2026 16:16:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784823402; cv=none; b=uFZ1mvJt/uJT6HXU9MUhNieeZZFxojXrQnpsDdw1RB1ivHbiruKtVDr6wbiN9t9062dHGwYlfHRCg4TopRXYXOtcFvFzEZSVyoLoKWKpHvK7wsEScD0gWEB1ZBN1SVMYS5aADNPQHWZ8mCWZyq4tUL9B3/+0+va8jUgREZFgWmc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784823402; c=relaxed/simple;
	bh=l/Q8jsddHxgzoxLFsMKobmlnoGpFS3uMhJ25Kfeo2b8=;
	h=From:To:Cc:Subject:Message-ID:MIME-Version:Content-Type:Date; b=qhECG2aEc+1SLSmEX6TZMi2O0zZypwBpObTa3NvXkO/xLa6WoqoSyWpyrQXQwyU26aYYjbq2C/obIJQuDK2e6f+TZ6ktEuJazzoHXa4CeFQxTJp3f0Wq+xyVBfI0VTO5eHLRZCm+7/JW6UHqBZMETIdezvWXNi7gZ3hThyn83c8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=FZ9K9x1u; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="FZ9K9x1u"
Received: by smtp.kernel.org (Postfix) with UTF8SMTPSA id 2603B1F000E9;
	Thu, 23 Jul 2026 16:16:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1784823398;
	bh=T+0LDKHKNOG29LQwKdGwZyPa/rQL+FWe5/BVLGWDyF0=;
	h=From:To:Cc:Subject:Date;
	b=FZ9K9x1upoKKY7SLfEnp8j2WUskAxrkieQ7efgE3r92vnmLaD36F4bZclvms8nAWJ
	 fcBM+mB/1HGgX1GGhB2B4ESLU6SFM7sf/ev1B+zVfKWcCZGB4af9p3Cyx9Jk/hdKAR
	 LilDdsqiX4vW+LusFjSpZxEIaQZ3W5zftrI+88mBY4pwpnYFpX8TiEvddGWtUDK9cX
	 aBdfaOmv2vgMbLMUBNrZ4wHj15QQVhrpaA1TsGDs8UqFj+K5b3uQZ1UwWX0u3rC5S7
	 sioYCK7NxsaiMOrWr6QClIyW6z0vq/QoOTE9Hp7yssGerg07duGKkldHWnxxpjsuDh
	 ELu0DsRGqlLfA==
From: "syzbot" <syzbot@kernel.org>
To: syzkaller-upstream-moderation@googlegroups.com
Cc: syzbot@lists.linux.dev, uladzislau.zhauniarovich@gmail.com
Subject: [PATCH RFC v2] nbd: fix hung task and integer overflow in timeout configuration
Message-ID: <d8588b05-ec96-4b61-9eff-87983c857148@mail.kernel.org>
Precedence: bulk
X-Mailing-List: syzbot@lists.linux.dev
List-Id: <syzbot.lists.linux.dev>
List-Subscribe: <mailto:syzbot+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:syzbot+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Date: Thu, 23 Jul 2026 16:16:38 +0000 (UTC)

An unprivileged user can configure an NBD device with an arbitrarily large
dead connection timeout via the NBD_ATTR_DEAD_CONN_TIMEOUT netlink
attribute. When a request is queued and the connection is dead,
nbd_handle_cmd() calls wait_for_reconnect(), which blocks the current
thread. Because the BLK_MQ_F_BLOCKING async-dispatch path leaves the
submitter in an uninterruptible I/O-completion wait, a dead connection
timeout larger than 120 seconds triggers the hung task detector, leading to
a kernel panic:

INFO: task kworker/1:1H:99 blocked for more than 143 seconds.
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
changed it to wait_event_timeout() to prevent non-fatal signals from
prematurely interrupting the wait. While commit ff57dc94faec is not the
root cause of the unbounded-wait DoS, keeping the wait safe against
non-fatal signals is still necessary.

To fix this, cap the dead connection timeout to a maximum of 100 seconds
(100 * HZ). Bounding the timeout to 100 seconds is what actually prevents
the hung task panic, as it is below the default 120-second threshold of the
hung task detector. Additionally, replace wait_event_timeout() with
wait_event_killable_timeout() as reapability hardening, allowing the
waiting task to be terminated by fatal signals. Also, call wake_up() in
sock_shutdown() to ensure any waiting tasks are woken up when the socket is
shut down.

Finally, prevent integer overflow when parsing the timeout by capping the
input value to U32_MAX before converting it to jiffies.

Fixes: 560bc4b39952 ("nbd: handle dead connections")
Assisted-by: Gemini:gemini-3.5-flash Gemini:gemini-3.1-pro-preview syzbot
Reported-by: syzbot+30c16035531e3248dcbc@syzkaller.appspotmail.com
Closes: https://syzkaller.appspot.com/bug?extid=30c16035531e3248dcbc
Link: https://syzkaller.appspot.com/ai_job?id=a75e9299-d014-47a0-abf8-8bbea2f535a5
To: "Jens Axboe" <axboe@kernel.dk>
To: "Josef Bacik" <josef@toxicpanda.com>
To: <linux-block@vger.kernel.org>
To: <nbd@other.debian.org>
Cc: <linux-kernel@vger.kernel.org>

---
v2:
- Capped dead_conn_timeout to 100 seconds (100 * HZ) instead of MAX_SCHEDULE_TIMEOUT to prevent the hung task detector from triggering.
- Replaced wait_event_idle_timeout with wait_event_killable_timeout to allow the waiting task to be terminated by fatal signals.
- Added wake_up(&config->conn_wait) in sock_shutdown() to ensure waiting tasks are woken up during socket shutdown.

v1:
https://lore.kernel.org/all/b6347da3-3c11-46cb-b467-3416e4104deb@mail.kernel.org/T/
---
diff --git a/drivers/block/nbd.c b/drivers/block/nbd.c
index 8f10762e9..9a212da7c 100644
--- a/drivers/block/nbd.c
+++ b/drivers/block/nbd.c
@@ -412,6 +412,7 @@ static void sock_shutdown(struct nbd_device *nbd)
 		mutex_unlock(&nsock->tx_lock);
 	}
 	dev_warn(disk_to_dev(nbd->disk), "shutting down sockets\n");
+	wake_up(&config->conn_wait);
 }
 
 static u32 req_to_nbd_cmd_type(struct request *req)
@@ -1101,14 +1102,17 @@ static int find_fallback(struct nbd_device *nbd, int index)
 static int wait_for_reconnect(struct nbd_device *nbd)
 {
 	struct nbd_config *config = nbd->config;
+	long ret;
+
 	if (!config->dead_conn_timeout)
 		return 0;
 
-	if (!wait_event_timeout(config->conn_wait,
-				test_bit(NBD_RT_DISCONNECTED,
-					 &config->runtime_flags) ||
-				atomic_read(&config->live_connections) > 0,
-				config->dead_conn_timeout))
+	ret = wait_event_killable_timeout(config->conn_wait,
+					  test_bit(NBD_RT_DISCONNECTED,
+						   &config->runtime_flags) ||
+					  atomic_read(&config->live_connections) > 0,
+					  config->dead_conn_timeout);
+	if (ret <= 0)
 		return 0;
 
 	return !test_bit(NBD_RT_DISCONNECTED, &config->runtime_flags);
@@ -2194,9 +2198,11 @@ static int nbd_genl_connect(struct sk_buff *skb, struct genl_info *info)
 		nbd_set_cmd_timeout(nbd,
 				    nla_get_u64(info->attrs[NBD_ATTR_TIMEOUT]));
 	if (info->attrs[NBD_ATTR_DEAD_CONN_TIMEOUT]) {
-		config->dead_conn_timeout =
+		u64 timeout =
 			nla_get_u64(info->attrs[NBD_ATTR_DEAD_CONN_TIMEOUT]);
-		config->dead_conn_timeout *= HZ;
+		timeout = min_t(u64, timeout, U32_MAX);
+		config->dead_conn_timeout =
+			min_t(u64, timeout * HZ, 100 * HZ);
 	}
 	if (info->attrs[NBD_ATTR_SERVER_FLAGS])
 		config->flags =
@@ -2415,9 +2421,11 @@ static int nbd_genl_reconfigure(struct sk_buff *skb, struct genl_info *info)
 		nbd_set_cmd_timeout(nbd,
 				    nla_get_u64(info->attrs[NBD_ATTR_TIMEOUT]));
 	if (info->attrs[NBD_ATTR_DEAD_CONN_TIMEOUT]) {
-		config->dead_conn_timeout =
+		u64 timeout =
 			nla_get_u64(info->attrs[NBD_ATTR_DEAD_CONN_TIMEOUT]);
-		config->dead_conn_timeout *= HZ;
+		timeout = min_t(u64, timeout, U32_MAX);
+		config->dead_conn_timeout =
+			min_t(u64, timeout * HZ, 100 * HZ);
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
