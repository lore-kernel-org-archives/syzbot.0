Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C0D654219F6
	for <syzbot@lists.linux.dev>; Thu,  9 Jul 2026 12:33:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783600437; cv=none; b=sN42hRzA8shuk6dVjO3gheeHY1DdkfPHrYiUtbTlsLT3vV+FC7UJNBt1IEMw1t9M28nQPt9avZAPNo2HHvDgetGUEHCsgRPYRbOPsx/lKfWqBoiN1yMISL27oVJAN8jf2Ha/bQf+GaXHRE5U2V7u6H5As39tZ4yU9304WAd2FLs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783600437; c=relaxed/simple;
	bh=7IfHAChe1tl5CBdOpDPj0DE7+mwv4U52eu7/mgz6Abc=;
	h=From:To:Cc:Subject:Message-ID:MIME-Version:Content-Type:Date; b=jDffN/Zdfs2t7RVEoC77Paxf7IwH9sEatDmTtPQsfPodfqrfbt/OWIh+V5F0Xs+3bjWBYCj3atcwY9Tzmv8JGDyjs9UbFyehDO2kWUQ5mYemNYHHwHxKeUm4Eh8vV2DpOMvhhTPHCkDnFu1k4erh6izZ/m/vYloeMK0o5KK+hrI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=cNqazM9Z; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="cNqazM9Z"
Received: by smtp.kernel.org (Postfix) with UTF8SMTPSA id 4940A1F000E9;
	Thu,  9 Jul 2026 12:33:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1783600435;
	bh=G+iKGahmoddqAGgUhdqPEmXbTnBfoQqkecn4o/sjSyc=;
	h=From:To:Cc:Subject:Date;
	b=cNqazM9Zynwr0v1Dg+REOCqcmBmCqlF7MizegJ7dxw4D+2/MMuQowkpdCF1Tbq/g8
	 3VKGmx07coI5comKF4yT055LEOA8l0LpJd2KTjIyJFh53Gb6qTixmi1U/oNylwKmKT
	 8xB2uU0+0fU5lUswqKFrtn+beP4RWt2d4YQVCvT6dy9JIpHLg50RdLBHwFWEnNUfL8
	 WrE8bFCiGsBKs6mBXO+0+82ICOaIAkmYJQIWhgfM7S0kYkEV88QXP2Dkvpyc5UAyhK
	 JN8fX8+HrHhik1TSj3ZDM2A23MZrbphxaoK3r9uTg18M8VEAgzwLB2Y5JH27FkIyj1
	 myYNdfLuN2jFA==
From: "syzbot" <syzbot@kernel.org>
To: syzkaller-upstream-moderation@googlegroups.com
Cc: syzbot@lists.linux.dev
Subject: [PATCH RFC] net/sched: taprio: fix hrtimer interrupt storm on small intervals
Message-ID: <bc6a8890-9230-489a-bbce-5c255c1ef01a@mail.kernel.org>
Precedence: bulk
X-Mailing-List: syzbot@lists.linux.dev
List-Id: <syzbot.lists.linux.dev>
List-Subscribe: <mailto:syzbot+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:syzbot+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Date: Thu,  9 Jul 2026 12:33:55 +0000 (UTC)

The taprio qdisc allows configuring extremely small intervals (e.g., 255
ns) which are valid for hardware offload but completely overwhelm the CPU
when using software timers. When the interval is smaller than the time it
takes to process the timer interrupt, the timer's expiration time is always
in the past. This causes the hrtimer subsystem to continuously re-enqueue
and fire the timer, leading to an interrupt storm that starves the CPU and
triggers an RCU stall:

rcu: INFO: rcu_preempt detected stalls on CPUs/tasks:
rcu: 	1-...!: (1 GPs behind) idle=9714/0/0x1 softirq=132447/132447 fqs=1
rcu: 	(detected by 0, t=10505 jiffies, g=152477, q=510 ncpus=2)
rcu: rcu_preempt kthread starved for 10501 jiffies! g152477 f0x0
RCU_GP_WAIT_FQS(5) ->state=0x0 ->cpu=0
rcu: 	Unless rcu_preempt kthread gets sufficient CPU time, OOM is now
expected behavior.

To fix this, implement two strategies. First, enforce sensible minimums in
software mode by rejecting intervals and cycle times smaller than
NSEC_PER_USEC (1 microsecond) when hardware offload is not enabled. Second,
prevent timer stalls in advance_sched() by fast-forwarding the schedule to
the current time instead of blindly restarting the timer in the past. This
is done efficiently by skipping full cycles using division, and then
looping through the remaining entries. To prevent the loop itself from
causing a stall, cap the iterations at 2048 and yield the CPU if necessary
by setting the timer to fire 1 microsecond in the future.

Fixes: 5a781ccbd19e ("tc: Add support for configuring the taprio scheduler")
Assisted-by: Gemini:gemini-3.1-pro-preview syzbot
Reported-by: syzbot+f8850bc3986562f79619@syzkaller.appspotmail.com
Closes: https://syzkaller.appspot.com/bug?extid=f8850bc3986562f79619
Link: https://syzkaller.appspot.com/ai_job?id=4e81d0c1-77be-4527-8698-9eadc019d766
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
index 299234a5f..910de14c4 100644
--- a/net/sched/sch_taprio.c
+++ b/net/sched/sch_taprio.c
@@ -944,46 +944,83 @@ static enum hrtimer_restart advance_sched(struct hrtimer *timer)
 	 * entry of all schedules are pre-calculated during the
 	 * schedule initialization.
 	 */
-	if (unlikely(!entry || entry->end_time == oper->base_time)) {
-		next = list_first_entry(&oper->entries, struct sched_entry,
-					list);
-		end_time = next->end_time;
-		goto first_run;
-	}
-
-	if (should_restart_cycle(oper, entry)) {
-		next = list_first_entry(&oper->entries, struct sched_entry,
-					list);
-		oper->cycle_end_time = ktime_add_ns(oper->cycle_end_time,
-						    oper->cycle_time);
-	} else {
-		next = list_next_entry(entry, list);
-	}
+	int max_iter = 2048;
+	ktime_t now = taprio_get_time(q);
 
-	end_time = ktime_add_ns(entry->end_time, next->interval);
-	end_time = min_t(ktime_t, end_time, oper->cycle_end_time);
+	do {
+		if (unlikely(!entry || entry->end_time == oper->base_time)) {
+			next = list_first_entry(&oper->entries,
+						struct sched_entry, list);
+			end_time = next->end_time;
+			goto first_run;
+		}
 
-	for (tc = 0; tc < num_tc; tc++) {
-		if (next->gate_duration[tc] == oper->cycle_time)
-			next->gate_close_time[tc] = KTIME_MAX;
-		else
-			next->gate_close_time[tc] = ktime_add_ns(entry->end_time,
-								 next->gate_duration[tc]);
-	}
+		if (should_restart_cycle(oper, entry)) {
+			next = list_first_entry(&oper->entries,
+						struct sched_entry, list);
+			oper->cycle_end_time = ktime_add_ns(
+				oper->cycle_end_time, oper->cycle_time);
+		} else {
+			next = list_next_entry(entry, list);
+		}
 
-	if (should_change_schedules(admin, oper, end_time)) {
-		switch_schedules(q, &admin, &oper);
-		/* After changing schedules, the next entry is the first one
-		 * in the new schedule, with a pre-calculated end_time.
-		 */
-		next = list_first_entry(&oper->entries, struct sched_entry, list);
-		end_time = next->end_time;
-	}
+		end_time = ktime_add_ns(entry->end_time, next->interval);
+		end_time = min_t(ktime_t, end_time, oper->cycle_end_time);
+
+		for (tc = 0; tc < num_tc; tc++) {
+			if (next->gate_duration[tc] == oper->cycle_time)
+				next->gate_close_time[tc] = KTIME_MAX;
+			else
+				next->gate_close_time[tc] =
+					ktime_add_ns(entry->end_time,
+						     next->gate_duration[tc]);
+		}
+
+		if (should_change_schedules(admin, oper, end_time)) {
+			switch_schedules(q, &admin, &oper);
+			/* After changing schedules, the next entry is the first one
+			 * in the new schedule, with a pre-calculated end_time.
+			 */
+			next = list_first_entry(&oper->entries,
+						struct sched_entry, list);
+			end_time = next->end_time;
+		}
 
-	next->end_time = end_time;
-	taprio_set_budgets(q, oper, next);
+		next->end_time = end_time;
+		taprio_set_budgets(q, oper, next);
 
 first_run:
+		if (ktime_after(end_time, now))
+			break;
+
+		if (!admin && ktime_before(end_time, now)) {
+			s64 diff = ktime_sub(now, end_time);
+			s64 cycles = div64_s64(diff, oper->cycle_time);
+			if (cycles > 0) {
+				oper->cycle_end_time =
+					ktime_add_ns(oper->cycle_end_time,
+						     cycles * oper->cycle_time);
+				end_time = ktime_add_ns(
+					end_time, cycles * oper->cycle_time);
+				next->end_time = end_time;
+				for (tc = 0; tc < num_tc; tc++) {
+					if (next->gate_close_time[tc] !=
+					    KTIME_MAX)
+						next->gate_close_time
+							[tc] = ktime_add_ns(
+							next->gate_close_time[tc],
+							cycles *
+								oper->cycle_time);
+				}
+			}
+		}
+
+		entry = next;
+	} while (--max_iter > 0);
+
+	if (max_iter == 0)
+		end_time = ktime_add_ns(now, NSEC_PER_USEC);
+
 	rcu_assign_pointer(q->current_entry, next);
 	spin_unlock(&q->current_entry_lock);
 
@@ -1061,6 +1098,13 @@ static int fill_sched_entry(struct taprio_sched *q, struct nlattr **tb,
 		return -EINVAL;
 	}
 
+	if (!FULL_OFFLOAD_IS_ENABLED(q->flags) && interval < NSEC_PER_USEC) {
+		NL_SET_ERR_MSG(
+			extack,
+			"Invalid interval for software taprio, must be at least 1 us");
+		return -EINVAL;
+	}
+
 	entry->interval = interval;
 
 	return 0;
@@ -1171,6 +1215,13 @@ static int parse_taprio_schedule(struct taprio_sched *q, struct nlattr **tb,
 		return -EINVAL;
 	}
 
+	if (!FULL_OFFLOAD_IS_ENABLED(q->flags) &&
+	    new->cycle_time < NSEC_PER_USEC) {
+		NL_SET_ERR_MSG(extack,
+			       "'cycle_time' is too small for software taprio");
+		return -EINVAL;
+	}
+
 	taprio_calculate_gate_durations(q, new);
 
 	return 0;


base-commit: 8cdeaa50eae8dad34885515f62559ee83e7e8dda
-- 
This is an AI-generated patch subject to moderation.
Reply with '#syz upstream' to Sign-off the patch as a human author
and send it to the upstream kernel mailing lists.
Reply with '#syz reject' to reject it ('#syz unreject' to undo).

See https://goo.gle/syzbot-ai-patches for information about AI-generated patches.
You can comment on the patch as usual, syzbot will try to address
the comments and send a new version of the patch if necessary.
syzbot engineers can be reached at syzkaller@googlegroups.com.
