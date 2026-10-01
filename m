Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 702EA3254A8
	for <syzbot@lists.linux.dev>; Thu,  1 Oct 2026 00:15:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790813741; cv=none; b=lSc3p0hHOwl6dWJL6RXHtGs9Fmrvk6hzE1ymW9UHcj2AFCmCrqPQ0XDLoaJhddwGy+UYvzfjld2fLmNlVU9Xh3bMcL/6SY62Ta5LydJNCemSwAk3RK94in3/SHon9Rj+E+JGbm11yqAf0NEKUyXCRbvFdyCtDja5iB01E2jVxw4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790813741; c=relaxed/simple;
	bh=x9VLCRuWaUFaOKZNrBAQsY2mSVgUS0J9GWiicSm+jz4=;
	h=From:To:Cc:Subject:Message-ID:MIME-Version:Content-Type:Date; b=S59xCW2IAqregHmfR1/Vwx1+KAP1mYCMD3s6X2n5Rhky/ATat6XF8gK4Hi1YD9LkLUKcbrVi5ue+1x4874qPd5g0rHP03RrToFq8TdCmk9TGup5xBkR26piAPzMeUXjs7yAD8Sm6GNdH6yw/U6an0I+SGcMtDmspY0V7syBWUik=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=ZFKJbxB0; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="ZFKJbxB0"
Received: by smtp.kernel.org (Postfix) with UTF8SMTPSA id AD5571F000FF;
	Thu,  1 Oct 2026 00:15:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1790813738;
	bh=+4Sybpr8IlAjkZn282NatVXkiyNFv9UL+fAqB1e3Stk=;
	h=From:To:Cc:Subject:Date;
	b=ZFKJbxB06lXqGrABW0zjiknvDQ4VVpP6JD3YGn2pM+cLwYH/yVuHnLQNp6BeEHMaA
	 iFuHPn5o/ZXK4j73XOmazAUhkemGZbAWUSMhyCH8xvsaQaOESJNfzUKnhJtiYUu/Qt
	 5JoXm7n3FUT98L4MvKtsSipqvoxarKmdTIeZdhiPrrYiS4ZPUouKrD0mzI31NKHC8B
	 X2sy8WK+UYmjv3aQ09GRvYZoSdopT7ZGRq79CCjMKfAIQp+QyHmazhzx7Hr1BPm3IA
	 U+s360PgLdru4pwqDQyo+N5wnsE0+hnSdUbCANnU7JjfRqhSe+2QKdAtN6DRn5yFSC
	 j4qM0v+ZwZv2g==
From: "syzbot" <syzbot@kernel.org>
To: syzkaller-upstream-moderation@googlegroups.com
Cc: krystianmkaniewski@gmail.com, syzbot@lists.linux.dev
Subject: [PATCH RFC v5] net/sched: taprio: enforce minimum interval to prevent hrtimer storms
Message-ID: <41213d76-0672-441b-86f9-422a79cd0833@mail.kernel.org>
Precedence: bulk
X-Mailing-List: syzbot@lists.linux.dev
List-Id: <syzbot.lists.linux.dev>
List-Subscribe: <mailto:syzbot+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:syzbot+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Date: Thu,  1 Oct 2026 00:15:38 +0000 (UTC)

In taprio running in software timer-driven mode (without txtime-assist or
full offload), configuring an extremely small interval allows the hrtimer
callback duration and interrupt overhead to exceed the scheduled duration.
Because taprio only verifies that intervals accommodate a minimum-sized
Ethernet frame (ETH_ZLEN), which can evaluate to mere tens of nanoseconds
on high-speed interfaces, the calculated expiration time in advance_sched()
falls in the past. This repeatedly retriggers the timer immediately,
causing an hrtimer interrupt storm that starves the CPU and leads to RCU
stalls.

To mitigate this, enforce a nominal minimum interval floor
(TAPRIO_MIN_INTERVAL, 100 us) in fill_sched_entry() and
parse_taprio_schedule() for timer-driven mode. This admission floor bounds
the nominal timer interrupt rate without affecting hardware-assisted or
offloaded modes.

Furthermore, update advance_sched() to detect when the target end_time has
already elapsed. Rather than advancing entries one by one across
back-to-back interrupts, advance_sched() fast-forwards through elapsed
cycles and entries to catch up to the current time, sets the next
expiration time into the future, and avoids restarting the timer if it is
already queued.

Fixes: b5b73b26b3ca ("taprio: Fix allowing too small intervals")
Assisted-by: Gemini:gemini-3.8-flash syzbot
Reported-by: syzbot+e044a9b6370ed8ca9737@syzkaller.appspotmail.com
Closes: https://syzkaller.appspot.com/bug?extid=e044a9b6370ed8ca9737
Link: https://syzkaller.appspot.com/ai_job?id=50b6d6ee-e256-4691-8ff7-d67affa583d4
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
v5:
- Retain HRTIMER_MODE_ABS instead of switching advance_timer to softirq context.
- Add catch-up logic in advance_sched() to fast-forward elapsed cycles and entries when schedule lags behind.
- Avoid restarting advance_timer in advance_sched() if it is already queued.
- Check that any trailing cycle remainder also satisfies TAPRIO_MIN_INTERVAL in parse_taprio_schedule().
- Update should_restart_cycle() to check for end_time >= cycle_end_time.
- Shorten the commit message, remove the unverified stack trace, and clarify runtime catch-up handling.

v4:
- Clamp first->end_time to sched->cycle_end_time in setup_first_end_time().
- In parse_taprio_schedule(), allow cycle_time shorter than the total schedule duration while ensuring the truncated interval is at least TAPRIO_MIN_INTERVAL.
https://lore.kernel.org/all/955ce7e5-3e6d-4d4a-bbce-8033da4ffb3f@mail.kernel.org/T/

v3:
- Switch advance_timer to HRTIMER_MODE_ABS_SOFT in taprio_init(), taprio_change(), and taprio_start_sched()
- In parse_taprio_schedule(), validate that cycle_time is not less than the sum of entry intervals in timer-driven mode
https://lore.kernel.org/all/6f795e5c-0c42-4ff3-b8f3-de5cffb73045@mail.kernel.org/T/

v2:
- Increased the minimum interval floor (TAPRIO_MIN_INTERVAL) from 1 us to 100 us.
- Restricted the minimum interval constraint to software timer-driven mode via a new taprio_is_timer_driven() helper.
- Used taprio_is_timer_driven() helper in taprio_start_sched() and taprio_change().
- Clarified in the commit message that the threshold represents a nominal callback-rate policy rather than an absolute safety guarantee.
https://lore.kernel.org/all/4de7b2e3-3f72-41a4-8735-67d91fc74009@mail.kernel.org/T/

v1:
https://lore.kernel.org/all/7d5b3fcb-ab75-4a18-909f-5ff072e562e1@mail.kernel.org/T/
---
diff --git a/net/sched/sch_taprio.c b/net/sched/sch_taprio.c
index 299234a5f..c39322d80 100644
--- a/net/sched/sch_taprio.c
+++ b/net/sched/sch_taprio.c
@@ -43,12 +43,26 @@ static struct static_key_false taprio_have_working_mqprio;
 #define TAPRIO_SUPPORTED_FLAGS \
 	(TCA_TAPRIO_ATTR_FLAG_TXTIME_ASSIST | TCA_TAPRIO_ATTR_FLAG_FULL_OFFLOAD)
 #define TAPRIO_FLAGS_INVALID U32_MAX
+
+static inline bool taprio_is_timer_driven(u32 flags)
+{
+	return !TXTIME_ASSIST_IS_ENABLED(flags) &&
+	       !FULL_OFFLOAD_IS_ENABLED(flags);
+}
+
 /* Minimum value for picos_per_byte to ensure non-zero duration
  * for minimum-sized Ethernet frames (ETH_ZLEN = 60).
  * 60 * 17 > PSEC_PER_NSEC (1000)
  */
 #define TAPRIO_PICOS_PER_BYTE_MIN 17
 
+/* Nominal callback-rate policy for timer-driven mode to prevent
+ * hrtimer interrupt storms (100 us floor corresponds to at most
+ * 10,000 timer interrupts per second). This is a nominal callback-rate
+ * policy rather than an absolute CPU-safety guarantee.
+ */
+#define TAPRIO_MIN_INTERVAL (100 * NSEC_PER_USEC)
+
 struct sched_entry {
 	/* Durations between this GCL entry and the GCL entry where the
 	 * respective traffic class gate closes
@@ -872,10 +886,7 @@ static struct sk_buff *taprio_dequeue(struct Qdisc *sch)
 static bool should_restart_cycle(const struct sched_gate_list *oper,
 				 const struct sched_entry *entry)
 {
-	if (list_is_last(&entry->list, &oper->entries))
-		return true;
-
-	if (ktime_compare(entry->end_time, oper->cycle_end_time) == 0)
+	if (ktime_compare(entry->end_time, oper->cycle_end_time) >= 0)
 		return true;
 
 	return false;
@@ -924,7 +935,8 @@ static enum hrtimer_restart advance_sched(struct hrtimer *timer)
 	int num_tc = netdev_get_num_tc(dev);
 	struct sched_entry *entry, *next;
 	struct Qdisc *sch = q->root;
-	ktime_t end_time;
+	enum hrtimer_restart restart;
+	ktime_t end_time, now;
 	int tc;
 
 	spin_lock(&q->current_entry_lock);
@@ -938,6 +950,11 @@ static enum hrtimer_restart advance_sched(struct hrtimer *timer)
 	if (!oper)
 		switch_schedules(q, &admin, &oper);
 
+	if (unlikely(!oper)) {
+		spin_unlock(&q->current_entry_lock);
+		return HRTIMER_NORESTART;
+	}
+
 	/* This can happen in two cases: 1. this is the very first run
 	 * of this function (i.e. we weren't running any schedule
 	 * previously); 2. The previous schedule just ended. The first
@@ -948,52 +965,135 @@ static enum hrtimer_restart advance_sched(struct hrtimer *timer)
 		next = list_first_entry(&oper->entries, struct sched_entry,
 					list);
 		end_time = next->end_time;
-		goto first_run;
-	}
-
-	if (should_restart_cycle(oper, entry)) {
-		next = list_first_entry(&oper->entries, struct sched_entry,
-					list);
-		oper->cycle_end_time = ktime_add_ns(oper->cycle_end_time,
-						    oper->cycle_time);
+		if (should_change_schedules(admin, oper, end_time)) {
+			switch_schedules(q, &admin, &oper);
+			next = list_first_entry(&oper->entries, struct sched_entry, list);
+			end_time = next->end_time;
+		}
 	} else {
-		next = list_next_entry(entry, list);
-	}
+		if (should_restart_cycle(oper, entry)) {
+			next = list_first_entry(&oper->entries, struct sched_entry,
+						list);
+			oper->cycle_end_time = ktime_add_ns(oper->cycle_end_time,
+							    oper->cycle_time);
+		} else if (list_is_last(&entry->list, &oper->entries)) {
+			next = entry;
+		} else {
+			next = list_next_entry(entry, list);
+		}
 
-	end_time = ktime_add_ns(entry->end_time, next->interval);
-	end_time = min_t(ktime_t, end_time, oper->cycle_end_time);
+		if (next == entry) {
+			end_time = oper->cycle_end_time;
+		} else {
+			ktime_t start = entry->end_time;
 
-	for (tc = 0; tc < num_tc; tc++) {
-		if (next->gate_duration[tc] == oper->cycle_time)
-			next->gate_close_time[tc] = KTIME_MAX;
-		else
-			next->gate_close_time[tc] = ktime_add_ns(entry->end_time,
-								 next->gate_duration[tc]);
+			end_time = ktime_add_ns(start, next->interval);
+			end_time = min_t(ktime_t, end_time, oper->cycle_end_time);
+
+			for (tc = 0; tc < num_tc; tc++) {
+				if (next->gate_duration[tc] == oper->cycle_time)
+					next->gate_close_time[tc] = KTIME_MAX;
+				else
+					next->gate_close_time[tc] =
+						ktime_add_ns(start, next->gate_duration[tc]);
+			}
+		}
+
+		if (should_change_schedules(admin, oper, end_time)) {
+			switch_schedules(q, &admin, &oper);
+			/* After changing schedules, the next entry is the first one
+			 * in the new schedule, with a pre-calculated end_time.
+			 */
+			next = list_first_entry(&oper->entries, struct sched_entry, list);
+			end_time = next->end_time;
+		}
 	}
 
-	if (should_change_schedules(admin, oper, end_time)) {
-		switch_schedules(q, &admin, &oper);
-		/* After changing schedules, the next entry is the first one
-		 * in the new schedule, with a pre-calculated end_time.
-		 */
-		next = list_first_entry(&oper->entries, struct sched_entry, list);
-		end_time = next->end_time;
+	now = taprio_get_time(q);
+
+	if (unlikely(ktime_compare(end_time, now) <= 0)) {
+		s64 elapsed, cycle_no, cycle_elapsed;
+		ktime_t cycle_start, cycle_end, accum;
+		struct sched_entry *e;
+
+		if (admin && ktime_compare(sched_base_time(admin), now) <= 0)
+			switch_schedules(q, &admin, &oper);
+
+		elapsed = ktime_sub_ns(now, oper->base_time);
+		if (elapsed < 0) {
+			cycle_start = ns_to_ktime(oper->base_time);
+			cycle_end = ktime_add_ns(cycle_start, oper->cycle_time);
+			cycle_elapsed = 0;
+		} else {
+			cycle_no = div64_s64(elapsed, oper->cycle_time);
+			cycle_start = ktime_add_ns(ns_to_ktime(oper->base_time),
+						   cycle_no * oper->cycle_time);
+			cycle_end = ktime_add_ns(cycle_start, oper->cycle_time);
+			cycle_elapsed = ktime_sub_ns(now, cycle_start);
+		}
+
+		oper->cycle_end_time = cycle_end;
+
+		accum = 0;
+		list_for_each_entry(e, &oper->entries, list) {
+			ktime_t next_accum = ktime_add_ns(accum, e->interval);
+
+			if (ktime_compare(oper->cycle_time, next_accum) <= 0 ||
+			    cycle_elapsed < next_accum ||
+			    list_is_last(&e->list, &oper->entries)) {
+				ktime_t entry_start = ktime_add_ns(cycle_start, accum);
+
+				next = e;
+				if (ktime_compare(oper->cycle_time, next_accum) <= 0 ||
+				    (list_is_last(&e->list, &oper->entries) &&
+				     cycle_elapsed >= next_accum))
+					end_time = cycle_end;
+				else
+					end_time = ktime_add_ns(cycle_start, next_accum);
+
+				for (tc = 0; tc < num_tc; tc++) {
+					if (next->gate_duration[tc] == oper->cycle_time)
+						next->gate_close_time[tc] = KTIME_MAX;
+					else
+						next->gate_close_time[tc] =
+							ktime_add_ns(entry_start,
+								     next->gate_duration[tc]);
+				}
+				break;
+			}
+			accum = next_accum;
+		}
+
+		if (admin)
+			end_time = min_t(ktime_t, end_time, sched_base_time(admin));
+
+		now = taprio_get_time(q);
+		if (ktime_compare(end_time, now) <= 0) {
+			end_time = ktime_add_ns(now, TAPRIO_MIN_INTERVAL);
+			if (admin)
+				end_time = min_t(ktime_t, end_time, sched_base_time(admin));
+		}
 	}
 
 	next->end_time = end_time;
 	taprio_set_budgets(q, oper, next);
 
-first_run:
 	rcu_assign_pointer(q->current_entry, next);
-	spin_unlock(&q->current_entry_lock);
 
-	hrtimer_set_expires(&q->advance_timer, end_time);
+	if (hrtimer_is_queued(&q->advance_timer)) {
+		restart = HRTIMER_NORESTART;
+	} else {
+		hrtimer_set_expires(&q->advance_timer, end_time);
+		restart = HRTIMER_RESTART;
+	}
+
+	spin_unlock(&q->current_entry_lock);
 
 	rcu_read_lock();
 	__netif_schedule(sch);
 	rcu_read_unlock();
 
-	return HRTIMER_RESTART;
+	return restart;
 }
 
 static const struct nla_policy entry_policy[TCA_TAPRIO_SCHED_ENTRY_MAX + 1] = {
@@ -1041,6 +1141,9 @@ static int fill_sched_entry(struct taprio_sched *q, struct nlattr **tb,
 	int min_duration = length_to_duration(q, ETH_ZLEN);
 	u32 interval = 0;
 
+	if (taprio_is_timer_driven(q->flags))
+		min_duration = max_t(int, min_duration, TAPRIO_MIN_INTERVAL);
+
 	if (tb[TCA_TAPRIO_SCHED_ENTRY_CMD])
 		entry->command = nla_get_u8(
 			tb[TCA_TAPRIO_SCHED_ENTRY_CMD]);
@@ -1166,9 +1269,39 @@ static int parse_taprio_schedule(struct taprio_sched *q, struct nlattr **tb,
 		new->cycle_time = cycle;
 	}
 
-	if (new->cycle_time < new->num_entries * length_to_duration(q, ETH_ZLEN)) {
-		NL_SET_ERR_MSG(extack, "'cycle_time' is too small");
-		return -EINVAL;
+	if (taprio_is_timer_driven(q->flags)) {
+		struct sched_entry *entry;
+		ktime_t accum = 0;
+
+		list_for_each_entry(entry, &new->entries, list) {
+			ktime_t next_accum = ktime_add_ns(accum, entry->interval);
+
+			if (ktime_compare(new->cycle_time, next_accum) <= 0) {
+				ktime_t rem = ktime_sub(new->cycle_time, accum);
+
+				if (rem < TAPRIO_MIN_INTERVAL) {
+					NL_SET_ERR_MSG(extack, "'cycle_time' is too small");
+					return -EINVAL;
+				}
+				accum = next_accum;
+				break;
+			}
+			accum = next_accum;
+		}
+
+		if (ktime_compare(new->cycle_time, accum) > 0) {
+			ktime_t rem = ktime_sub(new->cycle_time, accum);
+
+			if (rem < TAPRIO_MIN_INTERVAL) {
+				NL_SET_ERR_MSG(extack, "'cycle_time' is too small");
+				return -EINVAL;
+			}
+		}
+	} else {
+		if (new->cycle_time < new->num_entries * length_to_duration(q, ETH_ZLEN)) {
+			NL_SET_ERR_MSG(extack, "'cycle_time' is too small");
+			return -EINVAL;
+		}
 	}
 
 	taprio_calculate_gate_durations(q, new);
@@ -1256,6 +1389,7 @@ static void setup_first_end_time(struct taprio_sched *q,
 	sched->cycle_end_time = ktime_add_ns(base, cycle);
 
 	first->end_time = ktime_add_ns(base, first->interval);
+	first->end_time = min_t(ktime_t, first->end_time, sched->cycle_end_time);
 	taprio_set_budgets(q, sched, first);
 
 	for (tc = 0; tc < num_tc; tc++) {
@@ -1274,7 +1408,7 @@ static void taprio_start_sched(struct Qdisc *sch,
 	struct taprio_sched *q = qdisc_priv(sch);
 	ktime_t expires;
 
-	if (FULL_OFFLOAD_IS_ENABLED(q->flags))
+	if (!taprio_is_timer_driven(q->flags))
 		return;
 
 	expires = hrtimer_get_expires(&q->advance_timer);
@@ -1946,8 +2080,7 @@ static int taprio_change(struct Qdisc *sch, struct nlattr *opt,
 			   nla_get_u32(tb[TCA_TAPRIO_ATTR_TXTIME_DELAY]));
 	}
 
-	if (!TXTIME_ASSIST_IS_ENABLED(q->flags) &&
-	    !FULL_OFFLOAD_IS_ENABLED(q->flags) &&
+	if (taprio_is_timer_driven(q->flags) &&
 	    !hrtimer_active(&q->advance_timer)) {
 		hrtimer_setup(&q->advance_timer, advance_sched, q->clockid, HRTIMER_MODE_ABS);
 	}


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
