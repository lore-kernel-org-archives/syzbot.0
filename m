Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 929ED4457AF
	for <syzbot@lists.linux.dev>; Wed, 22 Jul 2026 18:40:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784745639; cv=none; b=au7tOGKg5LWxSpO5d6ZmT7dYy//mu+sro4ZfAE8MT6JQAEhqBKc8rXCpjGrK2WL0jnTof8RZyEPLWK5mc9tnAKs0YMYVxHLU2NnHpsAAl5zzmf5RJBDn0gqq0TzilBpiUjnaWKXaYdUHxODlBLZ2v7sQzN/COfrRD0igyp6YJeY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784745639; c=relaxed/simple;
	bh=eauhpAxUtSfVU5G+T9XGFL3tAyCX0tC+EnM6Ua6tVLk=;
	h=From:To:Cc:Subject:Message-ID:MIME-Version:Content-Type:Date; b=LoQCyvgXesfgMgkFHX22c0QUXU3tEul6X7HijqRSroQBphYLslqEiOm5SYRPcGgHv6kvMV8SbqQVZVaM6+h21nXxzKtD0VSvdkbXAaIcV/z9qtCL6eVsTbb3+VE0hZC83GINFsFysn9c6rwANAtReKp0857cCLWmfPAgJ6SrQ7o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=hwhIYekb; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="hwhIYekb"
Received: by smtp.kernel.org (Postfix) with UTF8SMTPSA id EBBD01F000E9;
	Wed, 22 Jul 2026 18:40:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1784745638;
	bh=Dxi2V/P9VRXZq4CS8Fa0wZh5xph7tB6T5gyVEbvxHqs=;
	h=From:To:Cc:Subject:Date;
	b=hwhIYekbtt+xKurvdUjqYFMRD/ttpgfc/ItzZ0pzas3xMkIjv6E+3Syenb/5qGtGn
	 GkIZoz0in0AYxNSj5lzELj2uIi9sCBo8dHfkWQEnNJtpOx2qqgLnNUe1kiajLLQlga
	 fUQ0dT9wXO1Ss5DA8oVWvanJfeVnImUaOcXMzr/HwwSO/3OWDBsOtFzkLKrTn5+BRc
	 VO6kFCfnWMdOQirUqDqEytylNNN8kNXPHta75sbBtpIBRDVBBuge30TD13OCyceuN/
	 KFoT2gcsezjyp0S+fVX11gx2OAfFCKt7cIrWc4/n+XpIXnwDBHu1JBG9oR1mcCZfyv
	 B7aRU8zolI+GA==
From: "syzbot" <syzbot@kernel.org>
To: syzkaller-upstream-moderation@googlegroups.com
Cc: krystianmkaniewski@gmail.com, syzbot@lists.linux.dev
Subject: [PATCH RFC v3] nbd: skip queue limits update for size-only reconfigure
Message-ID: <130f544a-70fd-4ca0-91e8-08824170c91b@mail.kernel.org>
Precedence: bulk
X-Mailing-List: syzbot@lists.linux.dev
List-Id: <syzbot.lists.linux.dev>
List-Subscribe: <mailto:syzbot+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:syzbot+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Date: Wed, 22 Jul 2026 18:40:37 +0000 (UTC)

Commit 242a49e5c878 ("nbd: freeze the queue for queue limits updates")
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
without freezing the queue or committing queue limits. Capacity-only
generic netlink reconfiguration no longer freezes the queue, while startup
and real block-size changes continue to use the existing frozen limits
update via nbd_set_size().

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

Fixes: 2dc691cc4ac2 ("nbd: refactor size updates")
Assisted-by: Gemini:gemini-3.5-flash Gemini:gemini-3.1-pro-preview syzbot
Reported-by: syzbot <syzbot+f272bbfbf8498ddadea5@syzkaller.appspotmail.com>
Closes: https://syzkaller.appspot.com/bug?extid=f272bbfbf8498ddadea5
Link: https://syzkaller.appspot.com/ai_job?id=c8611da4-ddd9-47e3-bbe2-8e178beb3f96
To: "Jens Axboe" <axboe@kernel.dk>
To: "Josef Bacik" <josef@toxicpanda.com>
To: <linux-block@vger.kernel.org>
To: <nbd@other.debian.org>
To: "Christoph Hellwig" <hch@lst.de>
Cc: <linux-kernel@vger.kernel.org>

---
v3:
- Removed the unrelated decrement of nbd_total_devices in nbd_dev_remove().
- Corrected the referenced commit title of 242a49e5c878 in the description.
- Clarified that capacity-only generic netlink reconfiguration no longer freezes the queue, while startup and real block-size changes continue to do so.

v2:
- Replaced the approach of using parallel netlink ops and custom timeouts with skipping queue limits updates for size-only reconfigurations.
- Introduced nbd_size_set() and nbd_size_update() to update device capacity directly without freezing the queue when the block size does not change.
- Retained queue freezing only for actual block-size changes.
- Added decrement of nbd_total_devices in nbd_dev_remove().
https://lore.kernel.org/all/514764a5-5acd-4e5d-a8eb-f40c403e7514@mail.kernel.org/T/

v1:
https://lore.kernel.org/all/69ff9a21-60be-4e97-bc8f-a59e739fd982@mail.kernel.org/T/
---
diff --git a/drivers/block/nbd.c b/drivers/block/nbd.c
index fe63f3c55..567b031ec 100644
--- a/drivers/block/nbd.c
+++ b/drivers/block/nbd.c
@@ -331,6 +331,27 @@ static void nbd_mark_nsock_dead(struct nbd_device *nbd, struct nbd_sock *nsock,
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
@@ -375,10 +396,7 @@ static int nbd_set_size(struct nbd_device *nbd, loff_t bytesize, loff_t blksize)
 	if (error)
 		return error;
 
-	if (max_part)
-		set_bit(GD_NEED_PART_SCAN, &nbd->disk->state);
-	if (!set_capacity_and_notify(nbd->disk, bytesize >> 9))
-		kobject_uevent(&nbd_to_dev(nbd)->kobj, KOBJ_CHANGE);
+	nbd_size_update(nbd);
 	return 0;
 }
 
@@ -2062,11 +2080,19 @@ static int nbd_genl_size_set(struct genl_info *info, struct nbd_device *nbd)
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
