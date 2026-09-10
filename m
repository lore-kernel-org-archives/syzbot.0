Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CD0673C0635;
	Thu, 10 Sep 2026 10:19:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789035599; cv=none; b=g94ic0GTBgYtWTD3D7tgp78lEH6TSAFXTPVuNDF4gcrd7meMVUmPcY9tKkPj28sF4Mo49cy8QbzNbmkAmdaNTG/BWi/+ZXiSD+13Dvumgif/YP4ahCT905fpcWjfowLKAh8NxfzVDWhscDZITDreCVIcemwUn1A7E8DFi0eveiA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789035599; c=relaxed/simple;
	bh=AGMXOz9WooLtmxCka5jf4X5QiuyLIh02VQs1iSo0TnA=;
	h=From:To:Cc:Subject:Message-ID:MIME-Version:Content-Type:Date; b=KKUieZI2zMQ2GVJFL2KWJAE06rDFPUDCx8Dw6qmLqPMBHkc1+sedbIeBSYAC4hHeAg8y9uQ0CZv2lNVFr5Bhh1EBHOGZVHCtbTzsxJRJdwkwY4g4tNURIs2klxSBOtBc4uuStrZRS8V+EPzW40Nxs3ktTxGyvJbnTaeWrHnavPE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Mwp/OYZ+; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Mwp/OYZ+"
Received: by smtp.kernel.org (Postfix) with UTF8SMTPSA id E85261F000FF;
	Thu, 10 Sep 2026 10:19:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789035597;
	bh=1td4zs8wZKlsu/Ec/TS1O57yTzxpXdAFyxHvF+VC3sE=;
	h=From:To:Cc:Subject:Date;
	b=Mwp/OYZ+jSKHM/OkdunoCw336mPjlitqLIODgIYIR/EV/Oud6w1dYZjb2f+txl6zA
	 njkUaSgRFgnFjlSYlVxha3EUTr8kTJsSnxldUJa6stxfmwWuX+eyeBS+1V09cAa8ug
	 vsJsjpKdl8BW4HPlfBYRd5ygOd8ipFnLeaP39jM5U8dwSTj0fb+S1is56rWFBCG93E
	 hhhHOHcIxZjG99GMlnF4RafvjI4OWpRXHP1i32c8JcX/1aycpzgMKCcVY6lTKivgqu
	 MNq02pH3990xDjcTbci5SLxINHvkjz34FclzT6uqcjV5l3uJWh3wWvRCOACFKVfkSV
	 1iVkVsZib509g==
From: "syzbot" <syzbot@kernel.org>
To: syzkaller-bugs@googlegroups.com, Krystian Kaniewski <krystianmkaniewski@gmail.com>, "Jens Axboe" <axboe@kernel.dk>, <linux-block@vger.kernel.org>, "Nilay Shroff" <nilay@linux.ibm.com>
Cc: linux-kernel@vger.kernel.org, syzbot@lists.linux.dev
Subject: [PATCH] blk-mq: fix out-of-bounds read in blk_mq_free_rqs
Message-ID: <c92b0c7e-17fb-44c8-99d9-59d45004d05a@mail.kernel.org>
Precedence: bulk
X-Mailing-List: syzbot@lists.linux.dev
List-Id: <syzbot.lists.linux.dev>
List-Subscribe: <mailto:syzbot+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:syzbot+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Date: Thu, 10 Sep 2026 10:19:56 +0000 (UTC)

From: Krystian Kaniewski <krystianmkaniewski@gmail.com>

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
Signed-off-by: Krystian Kaniewski <krystianmkaniewski@gmail.com>

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
See https://goo.gle/syzbot-ai-patches for information about AI-generated patches.
The person who has signed off on the patch is responsible for
addressing comments.
syzbot engineers can be reached at syzkaller@googlegroups.com.
