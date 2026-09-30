Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0999B1E1A17;
	Wed, 30 Sep 2026 18:45:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790793913; cv=none; b=D5jt8DHo7RrNvjg3zRX3EQ71vT1tPXde+LejOJ4uuGbezlabkrwZ3ZHpdCt3ro+KrlEI/wYTUJeP9oCf6jX2txUub0FomhCUEKTQ5x2KxfpFYhPKObd31X53KPTRUKC1GqE+lgICHoeQYPgR1Qh4XRYA66S+el4r8MfEfyykJv0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790793913; c=relaxed/simple;
	bh=HhVeFlp0ma9FeWryZKW+dvPHFNArxrI0aO6X2Ycp2zs=;
	h=From:To:Cc:Subject:Message-ID:MIME-Version:Content-Type:Date; b=jrvRh+BcbIgV9RiO0dH/GtwWRFyEC0bAyASLrRacXQIN2ffvoExSuaov0X5DkyVNNHLXCKx/LGz7QsPQkKd3+VVw5M9eU5dOGQLHkpfNQutnFs6EdTfV6UYa14bOT5wSPCvK/FYrUuQkf4bNmSo9B6Gu2wEl3/kJx5SfCcqmna0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=F23LSauQ; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="F23LSauQ"
Received: by smtp.kernel.org (Postfix) with UTF8SMTPSA id 9E99C1F000FF;
	Wed, 30 Sep 2026 18:45:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1790793910;
	bh=eQ7WzSL4bn+S7uyVOIECiBogp5rkrHDzGfJwYWK2D6s=;
	h=From:To:Cc:Subject:Date;
	b=F23LSauQnL6hfik6SBdWvw2jWheIkKq6LdJVCIepdjMIjWDtxxZIoYWFJMfQbTvLG
	 5mkWJPdDRZqKC25zpGpbFQjps5BVAkpShZtTrCm9luSLyF1vOS/t4gwoMMDz65i4wt
	 Xd1fmCH51JpOoHTwxNBwMjH7mhwHDCl0ME6YdkO+R3PIehWH6xcir1tmO9VTIvYXd4
	 IZhdXdJ4CBnCb8waDCVmcrUJCzNOei2Qv7arAJb9/FrVaPB0bp5CvxK39pFR6c17uR
	 CwgsuZFTcwqhqXnYqx1psG4ebkH3XNSo+M2wCPo5zqvOWZv3NWVt/1ZAT6P5TjotTU
	 4N77xkEHBY6YQ==
From: "syzbot" <syzbot@kernel.org>
To: syzkaller-bugs@googlegroups.com, Bradley Morgan <brads@mainlining.org>, "Lai Jiangshan" <jiangshanlai@gmail.com>, "Josh Triplett" <josh@joshtriplett.org>, "Paul E. McKenney" <paulmck@kernel.org>, <rcu@vger.kernel.org>, =?utf-8?q?Onur_=C3=96zkan?= <work@onurozkan.dev>, "Zqiang" <qiang.zhang@linux.dev>
Cc: linux-kernel@vger.kernel.org, mathieu.desnoyers@efficios.com, rostedt@goodmis.org, syzbot@lists.linux.dev
Subject: [PATCH] srcu: Drop spurious WARN_ON() in cleanup_srcu_struct()
Message-ID: <428f095d-02a5-433a-ae71-632f682e05af@mail.kernel.org>
Precedence: bulk
X-Mailing-List: syzbot@lists.linux.dev
List-Id: <syzbot.lists.linux.dev>
List-Subscribe: <mailto:syzbot+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:syzbot+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Date: Wed, 30 Sep 2026 18:45:09 +0000 (UTC)

From: Bradley Morgan <brads@mainlining.org>

In cleanup_srcu_struct(), commit 78a38cbf6f20 ("srcu: Queue sdp->work when
the delay timer is successfully deleted") added logic to queue sdp->work if
timer_delete_sync(&sdp->delay_work) successfully canceled a pending timer
while callbacks remained pending on sdp->srcu_cblist. However, it wrapped
this check in a WARN_ON() under the assumption that callers invoking
srcu_barrier() prior to cleanup_srcu_struct() would prevent the warning
from triggering.

This warning can be spuriously triggered during valid teardown paths where
srcu_barrier() is properly invoked before cleanup_srcu_struct(), such as
when releasing blk-mq tag sets:

WARNING: kernel/rcu/srcutree.c:707 at cleanup_srcu_struct+0x3d6/0x8b0
kernel/rcu/srcutree.c:706
Call Trace:
 <TASK>
 blk_mq_free_tag_set+0x617/0x790 block/blk-mq.c:4976
 scsi_mq_free_tags+0x16/0x30 drivers/scsi/scsi_lib.c:2167
 scsi_remove_host+0x243/0x730 drivers/scsi/hosts.c:193
 uas_disconnect+0x135/0x3e0 drivers/usb/storage/uas.c:1236
 usb_unbind_interface+0x295/0x9f0 drivers/usb/core/driver.c:461
 device_release_driver_internal+0x4f5/0x880 drivers/base/dd.c:1372
 bus_remove_device+0x444/0x560 drivers/base/bus.c:664
 device_del+0x524/0x8f0 drivers/base/core.c:3965
 usb_disconnect+0x346/0x9a0 drivers/usb/core/hub.c:2350
 hub_event+0x1bbb/0x4d30 drivers/usb/core/hub.c:5966
 process_scheduled_works+0xc3d/0x1630 kernel/workqueue.c:3479
 worker_thread+0xa47/0xfb0 kernel/workqueue.c:3560
 kthread+0x38b/0x480 kernel/kthread.c:436
 ret_from_fork+0x514/0xb70 arch/x86/kernel/process.c:158
 ret_from_fork_asm+0x1a/0x30 arch/x86/entry/entry_64.S:245
 </TASK>

This false positive occurs due to a race between callback invocation and
the teardown thread. First, sdp->delay_work can legitimately remain armed:
when an SRCU grace period completes, srcu_gp_end() arms sdp->delay_work
with a delay, and if callbacks are later scheduled with zero delay via
srcu_schedule_cbs_sdp(sdp, 0), queue_work_on() queues sdp->work directly
without deleting sdp->delay_work. Second, in srcu_invoke_callbacks(),
callbacks (including the one queued by srcu_barrier()) are extracted into a
local list and executed, but sdp->srcu_cblist length is only decremented
via rcu_segcblist_add_len(&sdp->srcu_cblist, -len) after all callbacks
finish executing. When srcu_barrier_cb() executes, it wakes the waiting
srcu_barrier() thread, which proceeds immediately to cleanup_srcu_struct().
At that point, the worker thread is still executing callbacks and has not
yet decremented the callback count, so timer_delete_sync(&sdp->delay_work)
returns 1 and rcu_segcblist_n_cbs(&sdp->srcu_cblist) is non-zero, firing
the WARN_ON(). Immediately thereafter, flush_work(&sdp->work) waits for the
worker to finish, and the subsequent check on rcu_segcblist_n_cbs()
correctly sees no remaining callbacks.

Because WARN_ON() must not be used for conditions that can legitimately
happen, and pr_err() should be used instead if an actual error needs to be
reported (which is not applicable here as this is normal recovery
behavior), remove the WARN_ON() check and its accompanying comment. Keep
the queue_work_on() recovery logic so that flush_work() properly waits for
remaining callbacks to complete. Genuine callback leaks remain caught by
the subsequent authoritative
WARN_ON(rcu_segcblist_n_cbs(&sdp->srcu_cblist)) check performed after work
has been flushed.

Fixes: 78a38cbf6f20 ("srcu: Queue sdp->work when the delay timer is successfully deleted")
Assisted-by: Gemini:gemini-3.8-flash Gemini:gemini-3.1-pro-preview syzbot
Reported-by: syzbot+02b37e31e64ea5cb6d29@syzkaller.appspotmail.com
Closes: https://syzkaller.appspot.com/bug?extid=02b37e31e64ea5cb6d29
Link: https://syzkaller.appspot.com/ai_job?id=5a402d0b-b407-49a6-b0f3-b06197c1398f
Signed-off-by: Bradley Morgan <brads@mainlining.org>

---
diff --git a/kernel/rcu/srcutree.c b/kernel/rcu/srcutree.c
index ed204b3f4..7f30a5587 100644
--- a/kernel/rcu/srcutree.c
+++ b/kernel/rcu/srcutree.c
@@ -701,10 +701,8 @@ void cleanup_srcu_struct(struct srcu_struct *ssp)
 	for_each_possible_cpu(cpu) {
 		struct srcu_data *sdp = per_cpu_ptr(ssp->sda, cpu);
 
-		// Call srcu_barrier() before this cleanup_srcu_struct()
-		// to avoid triggering this WARN_ON().
-		if (WARN_ON(timer_delete_sync(&sdp->delay_work) &&
-			    rcu_segcblist_n_cbs(&sdp->srcu_cblist)) &&
+		if (timer_delete_sync(&sdp->delay_work) &&
+		    rcu_segcblist_n_cbs(&sdp->srcu_cblist) &&
 		    rcu_cpu_beenfullyonline(sdp->cpu))
 			queue_work_on(sdp->cpu, rcu_gp_wq, &sdp->work);
 		flush_work(&sdp->work);


base-commit: 72d3fcf802c45d00b300f25b848a93c3a2bd7c7e
-- 
See https://goo.gle/syzbot-ai-patches for information about AI-generated patches.
The person who has signed off on the patch is responsible for
addressing comments.
syzbot engineers can be reached at syzkaller@googlegroups.com.
