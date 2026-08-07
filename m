Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4441C3F23DF
	for <syzbot@lists.linux.dev>; Fri,  7 Aug 2026 07:40:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786088440; cv=none; b=SmnJ3705rWDWIf81D4lvHdofK4VaR2n5yJNEBPeHAjeVUVmLfVn5WcuchPzoe2ovdmywlIDdPN/C5EjJ/2aWHmL53STFXCmvtmJvS1mPlgT/Zn/lFuuCsZRTHpm+lYbdIkqGNbLf+E18uDjGsBC/fS7/XQ7S1JmrCzyLo8yRhys=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786088440; c=relaxed/simple;
	bh=MGQwMg0k7MqoLN+pnYIjBj/LFIuz4/fb5nlzzYA4lF4=;
	h=From:To:Cc:Subject:Message-ID:MIME-Version:Content-Type:Date; b=j/9iSXcyTUZuuGoIOqIthk27B6MM2hJA4i9xEOddtWeXZ0zn8tFKFXZjRlQmfLON8nbBXNmxrWxnveMBju195Pcrv8MElh/pmSCFUgPjiPuAArJMrVUEUC7kQZR6gDs4nUkD2phwdlWv4T9Z06N8RfEMDLp88A+y1+jqEE1T+iI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=gTVyZSTh; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="gTVyZSTh"
Received: by smtp.kernel.org (Postfix) with UTF8SMTPSA id BF2611F000E9;
	Fri,  7 Aug 2026 07:40:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1786088437;
	bh=ijIW9Nq9+xyP/ZjcFQMYwHSobw2ZLE2VhD4nwAmimQE=;
	h=From:To:Cc:Subject:Date;
	b=gTVyZSTh8d3AZDQq1gfgK2XyXS/Oo4wvWXTAFzcWVxh63W9Z5v0B8O/SqGKfuexPn
	 HKpKtxByyyjZMMzTpk0XN1GQFQLR9SdjCVTenSCLdYgLCrA7Ym0kV4MkcdswLxW+dM
	 2r+udqaQDZ+r6tN1zE6kESAhnLp6uuYEBlLVAA+YVHIBuoUI+9jJ9CwKCBnPtIeJP1
	 6mA1u4DYTTjor06xDHHR3XPn5cZqKxT0h/pXtK45sAJas04VDr+NxagTfFPDz6Gos3
	 cH+8ez4IDrh8d6faC1e1+p0kohGpXC+sVZvU2oVkJv7ZZCErGzExtN9BmbXKbV2bY7
	 O1eVqzEcrWDsg==
From: "syzbot" <syzbot@kernel.org>
To: syzkaller-upstream-moderation@googlegroups.com
Cc: syzbot@lists.linux.dev
Subject: [PATCH RFC] blk-mq: fix out-of-bounds read in blk_mq_free_rqs
Message-ID: <80f75813-8fe4-4698-8424-5faaa6bbf6da@mail.kernel.org>
Precedence: bulk
X-Mailing-List: syzbot@lists.linux.dev
List-Id: <syzbot.lists.linux.dev>
List-Subscribe: <mailto:syzbot+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:syzbot+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Date: Fri,  7 Aug 2026 07:40:37 +0000 (UTC)

A KASAN slab-out-of-bounds read can occur in blk_mq_free_rqs() when there
is a mismatch between the number of hardware queues allocated for the IO
scheduler (et->nr_hw_queues) and the number of hardware queues in the block
tag set (set->nr_hw_queues).

This mismatch can happen if blk_mq_update_nr_hw_queues() fails halfway
through (e.g., due to memory pressure during
blk_mq_prealloc_tag_set_tags()). In this error path, the elevator is
restored with a larger number of hardware queues than the block tag set
actually has.

When the elevator is later freed, blk_mq_free_sched_tags() iterates up to
the new et->nr_hw_queues and calls blk_mq_free_rqs(). In blk_mq_free_rqs(),
it attempts to access set->tags[hctx_idx] to get the driver tags. Because
set->nr_hw_queues was not updated due to the earlier failure, set->tags
still has the old (smaller) size, leading to an out-of-bounds read.

BUG: KASAN: slab-out-of-bounds in blk_mq_free_rqs+0xde/0x680
Read of size 8 at addr ffff88818d67fc28 by task syz-executor117/5839
Call Trace:
 blk_mq_free_rqs+0xde/0x680
 blk_mq_free_map_and_rqs+0x40/0xf0
 blk_mq_free_sched_tags
 blk_mq_free_sched_res+0xeb/0x280
 elevator_change_done+0x1d2/0x5c0
 elevator_change+0x34f/0x480
 elv_iosched_store+0x504/0x630
 queue_attr_store+0x207/0x2b0

To fix this, explicitly check if hctx_idx < set->nr_hw_queues before
accessing set->tags[hctx_idx]. If hctx_idx >= set->nr_hw_queues, the
hardware queue doesn't exist in the tag set, meaning there are no driver
tags to clear mappings from. In this case, safely set drv_tags to NULL. The
subsequent call to blk_mq_clear_rq_mapping() already handles a NULL
drv_tags pointer and will safely return.

This fix also prevents a similar out-of-bounds read in the failure path of
blk_mq_alloc_rqs(), where a failure during new driver tag allocation could
lead to blk_mq_free_rqs() being called with an hctx_idx greater than or
equal to set->nr_hw_queues.

Fixes: 04225d13aef1 ("block: fix potential deadlock while running nr_hw_queue update")
Assisted-by: Gemini:gemini-3.5-flash Gemini:gemini-3.1-pro-preview syzbot
Reported-by: syzbot+e90526cab23b9efcd03c@syzkaller.appspotmail.com
Closes: https://syzkaller.appspot.com/bug?extid=e90526cab23b9efcd03c
Link: https://syzkaller.appspot.com/ai_job?id=827b5760-86a0-4f44-9c69-430b572eac12
To: "Jens Axboe" <axboe@kernel.dk>
To: <linux-block@vger.kernel.org>
To: "Nilay Shroff" <nilay@linux.ibm.com>
Cc: <linux-kernel@vger.kernel.org>

---
diff --git a/block/blk-mq.c b/block/blk-mq.c
index 2c850330a..8e6726b37 100644
--- a/block/blk-mq.c
+++ b/block/blk-mq.c
@@ -3473,8 +3473,10 @@ void blk_mq_free_rqs(struct blk_mq_tag_set *set, struct blk_mq_tags *tags,
 
 	if (blk_mq_is_shared_tags(set->flags))
 		drv_tags = set->shared_tags;
-	else
+	else if (hctx_idx < set->nr_hw_queues)
 		drv_tags = set->tags[hctx_idx];
+	else
+		drv_tags = NULL;
 
 	if (tags->static_rqs && set->ops->exit_request) {
 		int i;


base-commit: 075b74841bd0065a3bda3440873c747938e69b68
-- 
This is an AI-generated patch subject to moderation.
Reply with '#syz upstream' to Sign-off the patch as a human author
and send it to the upstream kernel mailing lists.
Reply with '#syz reject' to reject it ('#syz unreject' to undo).

See https://goo.gle/syzbot-ai-patches for information about AI-generated patches.
The person who has signed off on the patch is responsible for
addressing comments.
syzbot engineers can be reached at syzkaller@googlegroups.com.
