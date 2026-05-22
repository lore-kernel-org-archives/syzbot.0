Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BA6C03FF1
	for <syzbot@lists.linux.dev>; Fri, 22 May 2026 07:30:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779435061; cv=none; b=N5fqK1IzfEIRBxjz7kgYXouiQa58Ubx4yJdby2hjHoycteADn21e11hjmZKQHxTyR90laMm24xL5fMKWjRYGMddH9W8L7sfP8zWvNuJdlhABTOGDXrXQEGteNVUeK/vJrl1AJ0hEYSyxtzQdNNnmcPt8XnP97KIeILEzOgh65yI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779435061; c=relaxed/simple;
	bh=SpW8JNRb6InYM223sRNBW4JR5xesmj/1ORulRxjcZLw=;
	h=From:To:Cc:Subject:Message-ID:MIME-Version:Content-Type:Date; b=CD6eAY1nx/8Njy9TkgbR9gFr5i8acVRIjNa0r/JD0LNJCYGaxBqicdXPzSbUVWe96EmPjHsqTLFVoZyvV7RNm7dg0riHN8l3eW4EhcJScHbAu+M2Tbdlt48CxRgkyknyOYQ2Fgeo7Xq4ezHMRBlsSTkoEIp2vCZZBWSa6s+oAoo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Yu6dAjcl; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Yu6dAjcl"
Received: by smtp.kernel.org (Postfix) with UTF8SMTPSA id 542451F000E9;
	Fri, 22 May 2026 07:30:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1779435059;
	bh=QZk83pToljXOfTQmpkZ3I0ix5YoBwKfs5FUxfMecRwo=;
	h=From:To:Cc:Subject:Date;
	b=Yu6dAjclyAFXTN2tVC7pFp0aTF5brSGTTu0YT23FrjZYznE4tagnPFmF0EMcFyJng
	 56Ix6ceEeoANmyKMTwIk/uSYzzmQ1Q6wWBfZAst0iYAPV6XvDNWYg0mv/J5Bkg3xcY
	 lqqS5eUlqnX3on71qtjcLHKsmYdlGTF0tTYAPZqn1qExcT3hkIhBcZpWBMN0PnfpvR
	 HEtszbscQbpsRBvQFRPqbgDhp7cWJ7f/7NEIvTbFQQnkHfnwitITy/4UC/dVhEzqGg
	 +6Y7Rgh6bdrCyWnwYXZl0UsGJfwhdp1C2dYSio8vMbZCFx7G60VZBTkdx0hWAN6Ocd
	 osUKg+lf7HV+w==
From: "syzbot" <syzbot@kernel.org>
To: syzkaller-upstream-moderation@googlegroups.com
Cc: syzbot@lists.linux.dev
Subject: [PATCH RFC] net/sched: taprio: fix RCU stall due to small schedule intervals
Message-ID: <3e71ab96-4043-41af-856e-0c4c7373fb95@mail.kernel.org>
Precedence: bulk
X-Mailing-List: syzbot@lists.linux.dev
List-Id: <syzbot.lists.linux.dev>
List-Subscribe: <mailto:syzbot+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:syzbot+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Date: Fri, 22 May 2026 07:30:59 +0000 (UTC)

The taprio qdisc allows configuring schedule intervals that are
physically valid for high-speed links but are far too small for the
software hrtimer subsystem to handle. For example, at 10 Gbps, the
minimum duration for a 60-byte frame is 48 nanoseconds. If a user
configures an interval of 255 nanoseconds, it passes the physical
validation check.

However, the execution overhead of the hrtimer interrupt itself is
typically much larger than 255 nanoseconds. When the hrtimer fires,
advance_sched() calculates the next end_time by adding the interval to
the previous end_time. Because this advancement is smaller than the
interrupt overhead, the newly calculated end_time is still in the past.
When advance_sched() returns HRTIMER_RESTART, the hrtimer subsystem sees
the timer is already expired and executes it again immediately. The
timer never catches up to the current time, trapping the CPU in an
infinite hrtimer interrupt loop and causing an RCU stall.

Fix this by introducing a two-fold solution. First, in advance_sched(),
introduce a loop to advance the schedule until the calculated end_time
is strictly in the future. This ensures that if the hrtimer fires late,
it will skip over schedule entries that are already in the past instead
of blindly advancing by a single entry. Second, in fill_sched_entry(),
enforce a minimum interval of 1 microsecond (NSEC_PER_USEC) when
software scheduling is used. This prevents users from configuring
schedules that the software cannot physically keep up with, avoiding
excessive CPU time spent in the interrupt handler.

Fixes: 5a781ccbd19e ("tc: Add support for configuring the taprio scheduler")
Assisted-by: Gemini:gemini-3.1-pro-preview Gemini:gemini-3-flash-preview syzbot
Reported-by: syzbot+2e90866706ad999df132@syzkaller.appspotmail.com
Closes: https://syzkaller.appspot.com/bug?extid=2e90866706ad999df132
Link: https://syzkaller.appspot.com/ai_job?id=a76df798-c9cc-4943-937d-81102e228a11
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
index 45245157e..9e298b0cf 100644
--- a/net/sched/sch_taprio.c
+++ b/net/sched/sch_taprio.c
@@ -925,6 +925,7 @@ static enum hrtimer_restart advance_sched(struct hrtimer *timer)
 	struct sched_entry *entry, *next;
 	struct Qdisc *sch = q->root;
 	ktime_t end_time;
+	ktime_t now;
 	int tc;
 
 	spin_lock(&q->current_entry_lock);
@@ -951,36 +952,44 @@ static enum hrtimer_restart advance_sched(struct hrtimer *timer)
 		goto first_run;
 	}
 
-	if (should_restart_cycle(oper, entry)) {
-		next = list_first_entry(&oper->entries, struct sched_entry,
-					list);
-		oper->cycle_end_time = ktime_add_ns(oper->cycle_end_time,
-						    oper->cycle_time);
-	} else {
-		next = list_next_entry(entry, list);
-	}
+	now = taprio_get_time(q);
 
-	end_time = ktime_add_ns(entry->end_time, next->interval);
-	end_time = min_t(ktime_t, end_time, oper->cycle_end_time);
+	do {
+		if (should_restart_cycle(oper, entry)) {
+			next = list_first_entry(&oper->entries,
+						struct sched_entry, list);
+			oper->cycle_end_time = ktime_add_ns(
+				oper->cycle_end_time, oper->cycle_time);
+		} else {
+			next = list_next_entry(entry, list);
+		}
 
-	for (tc = 0; tc < num_tc; tc++) {
-		if (next->gate_duration[tc] == oper->cycle_time)
-			next->gate_close_time[tc] = KTIME_MAX;
-		else
-			next->gate_close_time[tc] = ktime_add_ns(entry->end_time,
-								 next->gate_duration[tc]);
-	}
+		end_time = ktime_add_ns(entry->end_time, next->interval);
+		end_time = min_t(ktime_t, end_time, oper->cycle_end_time);
 
-	if (should_change_schedules(admin, oper, end_time)) {
-		switch_schedules(q, &admin, &oper);
-		/* After changing schedules, the next entry is the first one
-		 * in the new schedule, with a pre-calculated end_time.
-		 */
-		next = list_first_entry(&oper->entries, struct sched_entry, list);
-		end_time = next->end_time;
-	}
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
+
+		next->end_time = end_time;
+		entry = next;
+	} while (unlikely(ktime_compare(end_time, now) <= 0));
 
-	next->end_time = end_time;
 	taprio_set_budgets(q, oper, next);
 
 first_run:
@@ -1061,6 +1070,13 @@ static int fill_sched_entry(struct taprio_sched *q, struct nlattr **tb,
 		return -EINVAL;
 	}
 
+	/* hrtimers cannot keep up with very small intervals */
+	if (!FULL_OFFLOAD_IS_ENABLED(q->flags) && interval < NSEC_PER_USEC) {
+		NL_SET_ERR_MSG(extack,
+			       "Invalid interval for software schedule entry");
+		return -EINVAL;
+	}
+
 	entry->interval = interval;
 
 	return 0;


base-commit: 5200f5f493f79f14bbdc349e402a40dfb32f23c8
-- 
This is an AI-generated patch subject to moderation.
Reply with '#syz upstream' to Sign-off the patch as a human author
and send it to the upstream kernel mailing lists.
Reply with '#syz reject' to reject it ('#syz unreject' to undo).

See https://github.com/google/syzkaller/blob/master/docs/syzbot_ai_patches.md for information about AI-generated patches.
You can comment on the patch as usual, syzbot will try to address
the comments and send a new version of the patch if necessary.
syzbot engineers can be reached at syzkaller@googlegroups.com.
