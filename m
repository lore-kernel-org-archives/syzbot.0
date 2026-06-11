Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5C5063FE369
	for <syzbot@lists.linux.dev>; Thu, 11 Jun 2026 13:28:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781184501; cv=none; b=nCxXvAWulTne9zKiMHArRGP4FEdUcdkWqliterBrT6nrfRfOMv6WS7gMf5XeQYBlqaU67JdmsD9vcGDp7uC/0pyR8v2f6KyvmYRip6OQgcMOpx8uUA8whIVLZvoRGrQi6Bj0x7Ol+EO0o0wUAT5ICkEykW1qmKlwnZKzheT4qMs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781184501; c=relaxed/simple;
	bh=/0J0VAh2XQvCqmvXBS5SFhLbORi61ylJEdRubab9nsA=;
	h=From:To:Cc:Subject:Message-ID:MIME-Version:Content-Type:Date; b=V2rCUWyJ4YTGbq6k/25UeyoGTKoO8bpdu+b1I3BJewTTz174NdL//tXTHdpLhCCTbZgy6FoTwTJIJn7erLVKfU90j0AZbB5yDUc92aqj3TQbyIIiZ3ZIltdBWp4oBOf35dwixkYtqFdAGGl4+ShsHcuETdR6KQ94y5ub1cDlXOU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=gk3hEuyE; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="gk3hEuyE"
Received: by smtp.kernel.org (Postfix) with UTF8SMTPSA id D888C1F00893;
	Thu, 11 Jun 2026 13:28:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1781184499;
	bh=334E6WsvUb9IXU15zdd2/EDg8FcDcc3/kqBsbBlpvF4=;
	h=From:To:Cc:Subject:Date;
	b=gk3hEuyEXROpwxxZ/t9Vk769nSRbt91QFFSEjTx/LXXQWOwHBr2Bhyx4Uiujwo+/U
	 eIFFTS+ycKJ+Y0RF8r21wxWuFso1kMWS3MoQo8GoqsXZ6ufL9L7IPgKhu2ko9aUCLY
	 5WN/tD6Yjt1anu4JinLU806fh9VPS4QIGUoTk7LDrs97xtpzASDaiah7lHGiBa/6hT
	 Uvh0MEenlW2Bh4GFkvzCID2CAFfUI/rSYkmQ92ExqxkbKp7OD4n0FofW/mnr5tpS1a
	 s+/T+08nwL42M6ukXr1QZ5jxMQeFS4CTPz0A1BsPvKHOVy33UkC+SIpMD2OOqJeYVP
	 DU09AVy4LccGw==
From: "syzbot" <syzbot@kernel.org>
To: syzkaller-upstream-moderation@googlegroups.com
Cc: syzbot@lists.linux.dev
Subject: [PATCH RFC] net/sched: taprio: fix advance_sched() RCU stalls and rbtree corruption
Message-ID: <7c5d8c90-5345-4038-9393-440e1850eb6b@mail.kernel.org>
Precedence: bulk
X-Mailing-List: syzbot@lists.linux.dev
List-Id: <syzbot.lists.linux.dev>
List-Subscribe: <mailto:syzbot+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:syzbot+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Date: Thu, 11 Jun 2026 13:28:19 +0000 (UTC)

An analysis of crash reports reveals two distinct but related issues in
taprio's advance_sched() hrtimer callback:

1. hrtimer rbtree corruption:
The original code dropped q->current_entry_lock before calling
hrtimer_set_expires(). This allowed taprio_change() to concurrently acquire
the lock and call hrtimer_start(), enqueuing the timer. advance_sched()
would then modify the expiration time of an actively enqueued timer,
corrupting the hrtimer rbtree. This leads to an infinite loop in
rb_erase_linked() during hrtimer removal, causing an RCU stall:

rcu: INFO: rcu_preempt detected stalls on CPUs/tasks:
rcu: 	0-...!: (1 GPs behind) idle=b8e4/1/0x4000000000000000
softirq=17061/17077 fqs=0
rcu: 	(detected by 1, t=10505 jiffies, g=11761, q=1458 ncpus=2)
Sending NMI from CPU 1 to CPUs 0:
NMI backtrace for cpu 0
...
Call Trace:
 <IRQ>
 rb_erase_linked+0x159/0x190 lib/rbtree.c:460
 timerqueue_linked_del include/linux/timerqueue.h:66 [inline]
 __remove_hrtimer+0xf7/0x3e0 kernel/time/hrtimer.c:1155
 __run_hrtimer kernel/time/hrtimer.c:1910 [inline]
 __hrtimer_run_queues+0x299/0xa20 kernel/time/hrtimer.c:1994
 hrtimer_interrupt+0x44b/0x950 kernel/time/hrtimer.c:2113
 local_apic_timer_interrupt arch/x86/kernel/apic/apic.c:1050 [inline]
 __sysvec_apic_timer_interrupt+0x102/0x430 arch/x86/kernel/apic/apic.c:1067
 instr_sysvec_apic_timer_interrupt arch/x86/kernel/apic/apic.c:1061
 [inline]
 sysvec_apic_timer_interrupt+0xa1/0xc0 arch/x86/kernel/apic/apic.c:1061
 </IRQ>

2. Catch-up loop RCU stall:
If the timer fires late (e.g. due to system overload or a paused VM),
advance_sched() calculates an end_time that is still in the past. It
returns HRTIMER_RESTART, causing the hrtimer core to immediately dequeue
and re-run the callback. Because advance_sched() only advances time by one
interval per iteration, a large delay combined with a small interval causes
the callback to loop millions of times in hardirq context. This monopolizes
the CPU and triggers the RCU stall detector.

To fix the rbtree corruption, keep hrtimer_set_expires() inside the lock
and conditionally update it only if !hrtimer_is_queued().

To fix the catch-up loop, mathematically skip missed cycles. When
advance_sched() detects that end_time is in the past, it uses div64_s64()
to calculate how many full cycles were missed and advances
oper->cycle_end_time, end_time, next->end_time, and next->gate_close_time
accordingly. This ensures that advance_sched() catches up to the present
time in at most num_entries iterations, completely eliminating the RCU
stall while preserving the correct schedule state.

Fixes: a3d43c0d56f1 ("taprio: Add support adding an admin schedule")
Assisted-by: Gemini:gemini-3.1-pro-preview syzbot
Reported-by: syzbot+f8ccdac0a7eede0e1ae5@syzkaller.appspotmail.com
Closes: https://syzkaller.appspot.com/bug?extid=f8ccdac0a7eede0e1ae5
Link: https://syzkaller.appspot.com/ai_job?id=cc1516be-6e82-4a99-9529-5491b7e7d037
To: "David S. Miller" <davem@davemloft.net>
To: "Eric Dumazet" <edumazet@google.com>
To: "Jamal Hadi Salim" <jhs@mojatatu.com>
To: "Jiri Pirko" <jiri@resnulli.us>
To: "Jakub Kicinski" <kuba@kernel.org>
To: <netdev@vger.kernel.org>
To: "Paolo Abeni" <pabeni@redhat.com>
To: "Vinicius Costa Gomes" <vinicius.gomes@intel.com>
Cc: "Simon Horman" <horms@kernel.org>
Cc: <linux-kernel@vger.kernel.org>

---
diff --git a/net/sched/sch_taprio.c b/net/sched/sch_taprio.c
index 45245157e..26258b07f 100644
--- a/net/sched/sch_taprio.c
+++ b/net/sched/sch_taprio.c
@@ -984,10 +984,37 @@ static enum hrtimer_restart advance_sched(struct hrtimer *timer)
 	taprio_set_budgets(q, oper, next);
 
 first_run:
+	/* Skip missed cycles */
+	if (oper->cycle_time > 0) {
+		ktime_t now = taprio_get_time(q);
+		if (ktime_before(end_time, now)) {
+			s64 n = div64_s64(ktime_sub(now, end_time),
+					  oper->cycle_time);
+			if (n > 0) {
+				ktime_t add = n * oper->cycle_time;
+				oper->cycle_end_time =
+					ktime_add_ns(oper->cycle_end_time, add);
+				end_time = ktime_add_ns(end_time, add);
+				next->end_time =
+					ktime_add_ns(next->end_time, add);
+				for (tc = 0; tc < num_tc; tc++) {
+					if (next->gate_close_time[tc] !=
+					    KTIME_MAX)
+						next->gate_close_time
+							[tc] = ktime_add_ns(
+							next->gate_close_time[tc],
+							add);
+				}
+			}
+		}
+	}
+
 	rcu_assign_pointer(q->current_entry, next);
-	spin_unlock(&q->current_entry_lock);
 
-	hrtimer_set_expires(&q->advance_timer, end_time);
+	if (!hrtimer_is_queued(&q->advance_timer))
+		hrtimer_set_expires(&q->advance_timer, end_time);
+
+	spin_unlock(&q->current_entry_lock);
 
 	rcu_read_lock();
 	__netif_schedule(sch);


base-commit: 4549871118cf616eecdd2d939f78e3b9e1dddc48
-- 
This is an AI-generated patch subject to moderation.
Reply with '#syz upstream' to Sign-off the patch as a human author
and send it to the upstream kernel mailing lists.
Reply with '#syz reject' to reject it ('#syz unreject' to undo).

See https://goo.gle/syzbot-ai-patches for information about AI-generated patches.
You can comment on the patch as usual, syzbot will try to address
the comments and send a new version of the patch if necessary.
syzbot engineers can be reached at syzkaller@googlegroups.com.
