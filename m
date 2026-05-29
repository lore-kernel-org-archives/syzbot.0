Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 35FB5326D65
	for <syzbot@lists.linux.dev>; Fri, 29 May 2026 20:12:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780085570; cv=none; b=PXSg5OzF6yC/fbVa2xFGkhw+3dfyo6LNhi5Jm2hEnhPdriRDb8ZyhS+J6In80SINe8BX9yveHJJ54xV8lgxyMG2vKTfJrPRVV/JOB7rr9WfECjiMJct1mkq19hU832otpC0vIQSB1/08pyj9+ONtljGrzLO1iwuHO2StoeZzcPo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780085570; c=relaxed/simple;
	bh=z64fSrNccDQgjhRoXDFO86bxA/EGIwszGNUhMMs1HjI=;
	h=From:To:Cc:Subject:Message-ID:MIME-Version:Content-Type:Date; b=B63Nvs4kZy6jUIucztdVr24NUAdRGpCzyNLn8XMXEG0CwTpv2l7wyIHXzvQJfqE/Y05r5EXruGFyDB3I6CvYXzguw98pBqzDavOxBF0lzfyoThDKCsrbBMaCIEvy9xPbml4elH7EfGv2BPnTnZIsyDZrs4HXOvfmBcvnnxK9L/k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=CBzUf1tr; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="CBzUf1tr"
Received: by smtp.kernel.org (Postfix) with UTF8SMTPSA id C2E311F00893;
	Fri, 29 May 2026 20:12:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1780085568;
	bh=JnrkxyF/UV31gkUCqihbtiKIlvCQYvzmUk539I8K3sM=;
	h=From:To:Cc:Subject:Date;
	b=CBzUf1trPOHPfcr4mgTzcvsvZiqFFeg8GGBWXEs7CQj+rjJuRNbOdpvFiGKiSjVIk
	 rxQunKHAKB228c6aDw16QE24L1J1MuJ0k9XhFch4dg0h5KJjeAYXVRRTvxujkdpzyP
	 Z+GEBDMbpbHW7NqurpFPcPJnLl9lnVyPifjah/XKOK0RLiY1gX91S2tRqHF1VOCWTL
	 XJGHC1P+mHTKzX6+WEmmkO1c7DHZh18YCnEXoEGP7LBDOPNg1seuIDDrYU8E0XXo5c
	 JtE+0Whawljs1UrxlkMRq58nGD28BoRtcLfxELx2jvhW5IDMlvsdQbvS2u1Bi6RuIg
	 e93C+ABkwR9ZA==
From: "syzbot" <syzbot@kernel.org>
To: syzkaller-upstream-moderation@googlegroups.com
Cc: syzbot@lists.linux.dev
Subject: [PATCH RFC] nbd: fix resource leak when device is abandoned
Message-ID: <a51a0826-f36a-4cef-8945-c9968b232f22@mail.kernel.org>
Precedence: bulk
X-Mailing-List: syzbot@lists.linux.dev
List-Id: <syzbot.lists.linux.dev>
List-Subscribe: <mailto:syzbot+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:syzbot+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Date: Fri, 29 May 2026 20:12:48 +0000 (UTC)

When a user-space process configures an NBD device via netlink but exits
without explicitly disconnecting it or opening the block device, the NBD
device and its request queue are leaked. The leaked request queues hold
dynamically registered lock classes. When this happens repeatedly, it
exhausts the MAX_LOCKDEP_KEYS limit and triggers a lockdep BUG.

The leak occurs because the initial configuration reference (config_refs)
is set to 1 during configuration. If the process exits, the sockets are
closed and the recv_work threads exit, but the initial reference is never
dropped unless the device is explicitly disconnected or the
NBD_CFLAG_DESTROY_ON_DISCONNECT flag was set. As a result, the device is
considered in use and skipped during subsequent device allocations, leading
to unbounded creation of new devices and request queues.

Fix this by scheduling disconnect_work to tear down the device when all
sockets are closed and the disk has no openers, even if
NBD_DESTROY_ON_DISCONNECT is not set. This ensures the initial
configuration reference is dropped, allowing the device configuration to be
freed and the device to become eligible for reuse, preventing the resource
leak and the lockdep crash.

Fixes: e46c7287b1c2 ("nbd: add a basic netlink interface")
Assisted-by: Gemini:gemini-3.1-pro-preview Gemini:gemini-3-flash-preview syzbot
Reported-by: syzbot+6279b273d888c2017726@syzkaller.appspotmail.com
Closes: https://syzkaller.appspot.com/bug?extid=6279b273d888c2017726
Link: https://syzkaller.appspot.com/ai_job?id=f2b193da-12d6-456c-8401-8680f8682836
To: "Jens Axboe" <axboe@kernel.dk>
To: "Josef Bacik" <josef@toxicpanda.com>
To: <linux-block@vger.kernel.org>
To: <nbd@other.debian.org>
Cc: <linux-kernel@vger.kernel.org>

---
diff --git a/drivers/block/nbd.c b/drivers/block/nbd.c
index fe63f3c55..d31c8e5e3 100644
--- a/drivers/block/nbd.c
+++ b/drivers/block/nbd.c
@@ -124,6 +124,7 @@ struct nbd_device {
 	struct gendisk *disk;
 	struct workqueue_struct *recv_workq;
 	struct work_struct remove_work;
+	struct work_struct disconnect_work;
 
 	struct list_head list;
 	struct task_struct *task_setup;
@@ -322,7 +323,15 @@ static void nbd_mark_nsock_dead(struct nbd_device *nbd, struct nbd_sock *nsock,
 				set_bit(NBD_RT_DISCONNECTED,
 					&nbd->config->runtime_flags);
 				dev_info(nbd_to_dev(nbd),
-					"Disconnected due to user request.\n");
+					 "Disconnected due to user request.\n");
+			}
+			if (test_bit(NBD_DESTROY_ON_DISCONNECT, &nbd->flags) ||
+			    disk_openers(nbd->disk) == 0) {
+				if (refcount_inc_not_zero(&nbd->refs)) {
+					if (!queue_work(system_wq,
+							&nbd->disconnect_work))
+						nbd_put(nbd);
+				}
 			}
 		}
 	}
@@ -1904,6 +1913,8 @@ static const struct blk_mq_ops nbd_mq_ops = {
 	.timeout	= nbd_xmit_timeout,
 };
 
+static void nbd_disconnect_work(struct work_struct *work);
+
 static struct nbd_device *nbd_dev_add(int index, unsigned int refs)
 {
 	struct queue_limits lim = {
@@ -1928,6 +1939,7 @@ static struct nbd_device *nbd_dev_add(int index, unsigned int refs)
 	nbd->tag_set.flags = BLK_MQ_F_BLOCKING;
 	nbd->tag_set.driver_data = nbd;
 	INIT_WORK(&nbd->remove_work, nbd_dev_remove_work);
+	INIT_WORK(&nbd->disconnect_work, nbd_disconnect_work);
 	nbd->backend = NULL;
 
 	err = blk_mq_alloc_tag_set(&nbd->tag_set);
@@ -2272,6 +2284,14 @@ static void nbd_disconnect_and_put(struct nbd_device *nbd)
 		nbd_config_put(nbd);
 }
 
+static void nbd_disconnect_work(struct work_struct *work)
+{
+	struct nbd_device *nbd =
+		container_of(work, struct nbd_device, disconnect_work);
+	nbd_disconnect_and_put(nbd);
+	nbd_put(nbd);
+}
+
 static int nbd_genl_disconnect(struct sk_buff *skb, struct genl_info *info)
 {
 	struct nbd_device *nbd;


base-commit: e7ae89a0c97ce2b68b0983cd01eda67cf373517d
-- 
This is an AI-generated patch subject to moderation.
Reply with '#syz upstream' to Sign-off the patch as a human author
and send it to the upstream kernel mailing lists.
Reply with '#syz reject' to reject it ('#syz unreject' to undo).

See https://goo.gle/syzbot-ai-patches for information about AI-generated patches.
You can comment on the patch as usual, syzbot will try to address
the comments and send a new version of the patch if necessary.
syzbot engineers can be reached at syzkaller@googlegroups.com.
