Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 681D03B14DE
	for <syzbot@lists.linux.dev>; Mon, 20 Jul 2026 20:04:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784577854; cv=none; b=j6ytzTtPCiZyLfa5VkmUhV40mIMxSGtKdhaXFCg6VqQMX5vJgFFgZhlMi5efqgOR8NuG3jNQ2Yd4UcDBYXLNcq7AXLC5DE9vzYGsBa4QuxBiofM6BaE8bKDi/mDZ00sihurU9XeavBxFYeemCgnjHV9kKZl8InQns3v7t68CjTY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784577854; c=relaxed/simple;
	bh=3xIf5OtXH0c+1ECytBOHWteKLDeFGuMd1iYMo81V330=;
	h=From:To:Cc:Subject:Message-ID:MIME-Version:Content-Type:Date; b=flwry/MAdApstK5SyDkIyCfC8bDeLXbGqUZweJ9hc//mFv9cHyTIFtCAYUOpBWBMwFfCv6tsAiNVXuAD3FNFuRiArqFwJV9SQd296X0L0FkaRF4SAxu+c/XaMsC/M4Tc6Y0VCA0rMVAeTyZKr8sKI7AxH3YL5MQ6xu5Yp21suqY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=LtrE8tZ7; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="LtrE8tZ7"
Received: by smtp.kernel.org (Postfix) with UTF8SMTPSA id B3FB01F000E9;
	Mon, 20 Jul 2026 20:04:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1784577851;
	bh=C9/8k3/G48j2hjS5OnbqTQRSqXnzGU4a+f0dxenKdKs=;
	h=From:To:Cc:Subject:Date;
	b=LtrE8tZ7QD4BwCscW0FrU2506fI5eHwwhIQBlSUrvC18vVZqtaX+6KYOOLLfSncUG
	 k3XhEf70bRBDwGi48cKRCl57Hbn2x4IPS6ehmIRY2ilhwS3ABb+davFf8GQVrRVUQa
	 ihzc8ZlumDX9vaLIb/QLVzx7NLB3iyU5yEBByvhz3hKT7+hhQUbVKvj4oFhyUZd8hp
	 gqYkkRPujywUrUy/R0/lCKDpMnervAR1a8XlBAQAWJMN2eZ3CoG4HTD2mtBRsJWAlB
	 s79/klhoXNxV/eZv1pI4Ps27hlkY8l0L2EaaTkYx5RKkBQHHFs9lojBVOkxvLliExJ
	 5F+zZAkjTYyHw==
From: "syzbot" <syzbot@kernel.org>
To: syzkaller-upstream-moderation@googlegroups.com
Cc: krystianmkaniewski@gmail.com, syzbot@lists.linux.dev
Subject: [PATCH RFC v2] nbd: skip queue limits update for size-only reconfigure
Message-ID: <514764a5-5acd-4e5d-a8eb-f40c403e7514@mail.kernel.org>
Precedence: bulk
X-Mailing-List: syzbot@lists.linux.dev
List-Id: <syzbot.lists.linux.dev>
List-Subscribe: <mailto:syzbot+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:syzbot+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Date: Mon, 20 Jul 2026 20:04:11 +0000 (UTC)

Commit 242a49e5c878 ("nbd: fix queue freeze vs limits lock order")
correctly added queue freezing for live updates of real queue limits.
However, nbd_set_size() is also used for capacity-only generic netlink
updates, so the freeze is unnecessarily broad for the reported request.

When an NBD server becomes unresponsive, it leaves I/O in flight. An
unnecessary queue freeze during a size-only reconfigure will wait forever
for these in-flight I/Os to complete while the global genl_mutex is held,
leading to a system-wide deadlock.

A size-only reconfigure can update config->bytesize and disk capacity
directly because the effective block size and all other queue limits stay
unchanged.

This patch introduces nbd_size_set() to handle size-only updates directly
without freezing the queue or committing queue limits. Startup and actual
block-size changes continue to use the existing frozen limits update via
nbd_set_size().

INFO: task nbd-client:6285 blocked for more than 143 seconds.
Call Trace:
 <TASK>
 blk_mq_freeze_queue_wait+0x101/0x180 block/blk-mq.c:191
 queue_limits_commit_update_frozen+0x55/0xd0 block/blk-settings.c:590
 nbd_set_size+0x454/0x680 drivers/block/nbd.c:374
 nbd_genl_reconfigure+0x7e9/0x1e80 drivers/block/nbd.c:2373
 genl_rcv_msg+0x614/0x7a0 net/netlink/genetlink.c:1209
 </TASK>

INFO: task generic-netlink:6030 blocked for more than 143 seconds.
Call Trace:
 <TASK>
 __mutex_lock+0x7c5/0x1590 kernel/locking/mutex.c:820
 genl_rcv_msg+0x10b/0x7a0 net/netlink/genetlink.c:1208
 </TASK>

Fixes: 242a49e5c878 ("nbd: freeze the queue for queue limits updates")
Assisted-by: Gemini:gemini-3.5-flash Gemini:gemini-3.1-pro-preview syzbot
Reported-by: syzbot <syzbot+f272bbfbf8498ddadea5@syzkaller.appspotmail.com>
Closes: https://syzkaller.appspot.com/bug?extid=f272bbfbf8498ddadea5
Link: https://syzkaller.appspot.com/ai_job?id=e5538deb-f4ac-4b3b-a22a-b47c828fc99e
To: "Jens Axboe" <axboe@kernel.dk>
To: "Josef Bacik" <josef@toxicpanda.com>
To: <linux-block@vger.kernel.org>
To: <nbd@other.debian.org>
To: "Christoph Hellwig" <hch@lst.de>
Cc: <linux-kernel@vger.kernel.org>

---
v2:
- Replaced the approach of using parallel netlink ops and custom timeouts with skipping queue limits updates for size-only reconfigurations.
- Introduced nbd_size_set() and nbd_size_update() to update device capacity directly without freezing the queue when the block size does not change.
- Retained queue freezing only for actual block-size changes.
- Added decrement of nbd_total_devices in nbd_dev_remove().

v1:
https://lore.kernel.org/all/69ff9a21-60be-4e97-bc8f-a59e739fd982@mail.kernel.org/T/
---
diff --git a/drivers/block/nbd.c b/drivers/block/nbd.c
index fe63f3c55..2302b8b40 100644
--- a/drivers/block/nbd.c
+++ b/drivers/block/nbd.c
@@ -277,6 +277,7 @@ static void nbd_dev_remove(struct nbd_device *nbd)
 	mutex_unlock(&nbd_index_mutex);
 	destroy_workqueue(nbd->recv_workq);
 	put_disk(disk);
+	nbd_total_devices--;
 }
 
 static void nbd_dev_remove_work(struct work_struct *work)
@@ -331,6 +332,27 @@ static void nbd_mark_nsock_dead(struct nbd_device *nbd, struct nbd_sock *nsock,
 	nsock->sent = 0;
 }
 
+static void nbd_size_update(struct nbd_device *nbd)
+{
+	struct nbd_config *config = nbd->config;
+
+	if (max_part)
+		set_bit(GD_NEED_PART_SCAN, &nbd->disk->state);
+	if (!set_capacity_and_notify(nbd->disk, config->bytesize >> 9))
+		kobject_uevent(&nbd_to_dev(nbd)->kobj, KOBJ_CHANGE);
+}
+
+static int nbd_size_set(struct nbd_device *nbd, loff_t bytesize)
+{
+	if (bytesize < 0)
+		return -EINVAL;
+
+	nbd->config->bytesize = bytesize;
+	if (nbd->pid)
+		nbd_size_update(nbd);
+	return 0;
+}
+
 static int nbd_set_size(struct nbd_device *nbd, loff_t bytesize, loff_t blksize)
 {
 	struct queue_limits lim;
@@ -375,10 +397,7 @@ static int nbd_set_size(struct nbd_device *nbd, loff_t bytesize, loff_t blksize)
 	if (error)
 		return error;
 
-	if (max_part)
-		set_bit(GD_NEED_PART_SCAN, &nbd->disk->state);
-	if (!set_capacity_and_notify(nbd->disk, bytesize >> 9))
-		kobject_uevent(&nbd_to_dev(nbd)->kobj, KOBJ_CHANGE);
+	nbd_size_update(nbd);
 	return 0;
 }
 
@@ -2062,11 +2081,19 @@ static int nbd_genl_size_set(struct genl_info *info, struct nbd_device *nbd)
 	if (info->attrs[NBD_ATTR_SIZE_BYTES])
 		bytes = nla_get_u64(info->attrs[NBD_ATTR_SIZE_BYTES]);
 
-	if (info->attrs[NBD_ATTR_BLOCK_SIZE_BYTES])
+	if (info->attrs[NBD_ATTR_BLOCK_SIZE_BYTES]) {
 		bsize = nla_get_u64(info->attrs[NBD_ATTR_BLOCK_SIZE_BYTES]);
+		if (!bsize)
+			bsize = 1u << NBD_DEF_BLKSIZE_BITS;
+		if (blk_validate_block_size(bsize))
+			return -EINVAL;
+	}
 
-	if (bytes != config->bytesize || bsize != nbd_blksize(config))
-		return nbd_set_size(nbd, bytes, bsize);
+	if (bytes != config->bytesize || bsize != nbd_blksize(config)) {
+		if (bsize != nbd_blksize(config))
+			return nbd_set_size(nbd, bytes, bsize);
+		return nbd_size_set(nbd, bytes);
+	}
 	return 0;
 }
 


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
