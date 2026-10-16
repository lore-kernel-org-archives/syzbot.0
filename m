Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 46671472F97
	for <syzbot@lists.linux.dev>; Fri, 16 Oct 2026 12:54:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792155281; cv=none; b=Tpcd/xvPOVUG/mlqFtggTRKDHBJZd7ZFQ0vX0UdDHVPqyYEwjvjPVGoYTHvwb3Gx8AYMY7hcAeFHfUTbknE+Y87DDYrTqB5ErS0CKXvWqwSKxmaQOEdmLxPZ1MkCvLc+yXIAATzpzeGnWdlK865z7nk+cdK19FjnpRNWuz1chEI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792155281; c=relaxed/simple;
	bh=CjyqzLek4ZZkHvZMo+rtaxU82T12+TTlpqanNM7KZGQ=;
	h=From:To:Cc:Subject:Message-ID:MIME-Version:Content-Type:Date; b=suunK+pcdEFe9Xkf/1ZM5lZTP/1rY1blXqZLNGX8MpxUkuSR1HnPjETl07ttJ2ha/pMJh4u0LSDHM1Nbf6Ovd9mSqSyQgA5m8CaHMvrEk8VF+p97uXh7c76P52bajOWD4j6G7KVyHWgZON5Xj35dNSyq52q216E6CuZrGg+GxR0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=V04cv7yG; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="V04cv7yG"
Received: by smtp.kernel.org (Postfix) with UTF8SMTPSA id CA1221F000C4;
	Fri, 16 Oct 2026 12:54:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1792155280;
	bh=qQMXzx2ia0bEwyOIjO5Ra/wTCdDj/lV3A4mXkR9tQRk=;
	h=From:To:Cc:Subject:Date;
	b=V04cv7yGEhPVY07QlG6lU1LCxcUQ7UwyWI/Agu9yCp0TK1YHKuLeV5uv2bRGDvt60
	 vz4c5ivcV1xvigcMG+klIEOiZs0TWWq+MmhRdvBAPAdmuLCG+NwmoUmfe+paoQaBhV
	 6VGJbsKzvaKqi8uWKQj4xOatHSeipHz+DcgDvnZKXAx2PHsHbpH77hZzxZgY61B7Ak
	 kqJ/W3Zh+rKxVfACbR+0mdHHawb6M5/qvgOqIzMkJNfCOfGrSBLym43UupsBKqMXN7
	 5NonXpBmD9CVZTJXg5PAz7dfmfbmby2IpHfTqMtbjMfMVTZ3EVY+l2JHrMeLXJ/7e9
	 1qDiSsMzzsEQA==
From: "syzbot" <syzbot@kernel.org>
To: syzkaller-upstream-moderation@googlegroups.com
Cc: immersa.bartosz.chronowski@gmail.com, syzbot@lists.linux.dev
Subject: [PATCH RFC v6] net/sched: taprio: catch up overdue cycles in advance_sched()
Message-ID: <0423fb98-9248-4f3a-88d2-6e8fe89c26ea@mail.kernel.org>
Precedence: bulk
X-Mailing-List: syzbot@lists.linux.dev
List-Id: <syzbot.lists.linux.dev>
List-Subscribe: <mailto:syzbot+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:syzbot+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Date: Fri, 16 Oct 2026 12:54:39 +0000 (UTC)

The taprio qdisc allows configuring small intervals which can overwhelm the
CPU when using software timers. When the interval is shorter than the time
it takes to process the timer interrupt, or when the system experiences
scheduling delays, the timer expiration falls into the past. This
overdue-absolute-deadline condition causes the hrtimer subsystem to
repeatedly re-enqueue and fire the timer, resulting in an interrupt storm
that starves CPU tasks and triggers RCU stalls:

rcu: INFO: rcu_preempt detected stalls on CPUs/tasks:
	1-...!: (1 GPs behind) idle=5b64/0/0x1 softirq=135954/135971 fqs=1
Call Trace:
 <IRQ>
 advance_sched+0xc2/0xc80 net/sched/sch_taprio.c:930
 __run_hrtimer kernel/time/hrtimer.c:2032 [inline]
 __hrtimer_run_queues+0x3bc/0xa10 kernel/time/hrtimer.c:2096
 hrtimer_interrupt+0x448/0x910 kernel/time/hrtimer.c:2215
 local_apic_timer_interrupt arch/x86/kernel/apic/apic.c:1051 [inline]
 __sysvec_apic_timer_interrupt+0x102/0x430 arch/x86/kernel/apic/apic.c:1068
 sysvec_apic_timer_interrupt+0xa1/0xc0 arch/x86/kernel/apic/apic.c:1062
 </IRQ>

Fix this by implementing bounded catch-up in advance_sched() instead of
rejecting small intervals at admission time. When advance_sched() detects
that the timer expiration is overdue, complete schedule periods are skipped
arithmetically by advancing oper->cycle_end_time by the elapsed number of
full cycles without exceeding any pending admin schedule base time. Overdue
entries within the cycle are then traversed in a loop bounded by
oper->num_entries to catch up to the active entry, and the next timer
expiration is guaranteed to be in the future.

Fixes: 5a781ccbd19e ("tc: Add support for configuring the taprio scheduler")
Assisted-by: Gemini:gemini-4-argon Gemini:gemini-3.8-flash syzbot
Reported-by: syzbot+f8850bc3986562f79619@syzkaller.appspotmail.com
Closes: https://syzkaller.appspot.com/bug?extid=f8850bc3986562f79619
Link: https://syzkaller.appspot.com/ai_job?id=02840ed1-7db5-4b0e-9a7f-cec69d4d31e5
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
v6:
- Account for cycle_time_extension when calculating cycle catch-up before an admin schedule switch.
- Restart catch-up loop after switching to an admin schedule in advance_sched().
- Update taprio_set_budgets() and gate close times to use actual entry duration and gate mask.
- Avoid resetting current_entry in setup_first_end_time() when configuring an admin schedule.

v5:
- Drop cycle_interval_sum and do not modify parse_taprio_schedule().
- Avoid skipping past pending admin schedule base time during cycle catch-up.
- Advance overdue entries within the cycle using a loop bounded by oper->num_entries.
- Clamp timer expiration to at least now + 1 ns if still overdue.
- Fix should_restart_cycle() to check for end_time >= cycle_end_time.
- Handle cycle_end_time capping for the first entry in setup_first_end_time().
https://lore.kernel.org/all/2fcb3fdb-42b4-4a7a-bf17-3b5a422bfa75@mail.kernel.org/T/

v4:
- Replace admission-time interval rejection with bounded catch-up in advance_sched().
- Arithmetically advance overdue full periods instead of walking individual entries.
- Record cycle_interval_sum in parse_taprio_schedule() to determine the cycle period.
- Set timer expiration before releasing current_entry_lock.
https://lore.kernel.org/all/a75dd710-09c2-4dce-bc7b-65fd6c4be4d8@mail.kernel.org/T/

v3:
- Reject intervals smaller than 100 us at admission time for software TAPRIO schedules instead of modifying advance_sched().
- Drop catch-up cycle arithmetic, loop iteration limits, and physical expiration fallbacks from advance_sched().
https://lore.kernel.org/all/ecbfe945-f1ab-45de-aaa0-b9b57ae730c2@mail.kernel.org/T/

v2:
- Removed the 1 microsecond admission policy for software taprio.
- Reduced the loop iteration limit from 2048 to 32 to avoid softirq stalls.
- Added handling for administrative schedules during fast-forwarding to avoid overshooting `admin->base_time`.
- Split logical schedule deadline (`end_time`) and physical timer expiration (`expires`).
- Updated the fallback mechanism to request a physical expiration 1 microsecond in the future relative to the current time rather than yielding the CPU.
- Optimized gate close time calculation to only run once after the loop if not already calculated.
https://lore.kernel.org/all/03dbde3b-8c45-46b6-8291-dd12bcc3120c@mail.kernel.org/T/

v1:
https://lore.kernel.org/all/bc6a8890-9230-489a-bbce-5c255c1ef01a@mail.kernel.org/T/
---
diff --git a/net/sched/sch_taprio.c b/net/sched/sch_taprio.c
index 299234a5f..349bd2cdc 100644
--- a/net/sched/sch_taprio.c
+++ b/net/sched/sch_taprio.c
@@ -661,7 +661,7 @@ static struct sk_buff *taprio_peek(struct Qdisc *sch)
 
 static void taprio_set_budgets(struct taprio_sched *q,
 			       struct sched_gate_list *sched,
-			       struct sched_entry *entry)
+			       struct sched_entry *entry, s64 duration)
 {
 	struct net_device *dev = qdisc_dev(q->root);
 	int num_tc = netdev_get_num_tc(dev);
@@ -669,11 +669,14 @@ static void taprio_set_budgets(struct taprio_sched *q,
 
 	for (tc = 0; tc < num_tc; tc++) {
 		/* Traffic classes which never close have infinite budget */
-		if (entry->gate_duration[tc] == sched->cycle_time)
+		if (entry->gate_duration[tc] == sched->cycle_time &&
+		    duration == entry->interval)
 			budget = INT_MAX;
-		else
-			budget = div64_u64((u64)entry->gate_duration[tc] * PSEC_PER_NSEC,
+		else if (entry->gate_mask & BIT(tc))
+			budget = div64_u64((u64)duration * PSEC_PER_NSEC,
 					   atomic64_read(&q->picos_per_byte));
+		else
+			budget = 0;
 
 		atomic_set(&entry->budget[tc], budget);
 	}
@@ -875,7 +878,7 @@ static bool should_restart_cycle(const struct sched_gate_list *oper,
 	if (list_is_last(&entry->list, &oper->entries))
 		return true;
 
-	if (ktime_compare(entry->end_time, oper->cycle_end_time) == 0)
+	if (ktime_compare(entry->end_time, oper->cycle_end_time) >= 0)
 		return true;
 
 	return false;
@@ -924,8 +927,9 @@ static enum hrtimer_restart advance_sched(struct hrtimer *timer)
 	int num_tc = netdev_get_num_tc(dev);
 	struct sched_entry *entry, *next;
 	struct Qdisc *sch = q->root;
-	ktime_t end_time;
-	int tc;
+	ktime_t start_time, end_time, expires, now;
+	s64 duration;
+	int tc, i;
 
 	spin_lock(&q->current_entry_lock);
 	entry = rcu_dereference_protected(q->current_entry,
@@ -938,57 +942,100 @@ static enum hrtimer_restart advance_sched(struct hrtimer *timer)
 	if (!oper)
 		switch_schedules(q, &admin, &oper);
 
-	/* This can happen in two cases: 1. this is the very first run
-	 * of this function (i.e. we weren't running any schedule
-	 * previously); 2. The previous schedule just ended. The first
-	 * entry of all schedules are pre-calculated during the
-	 * schedule initialization.
-	 */
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
+	now = hrtimer_cb_get_time(timer);
+
+	if (entry && entry->end_time == oper->base_time)
+		entry = NULL;
+
+catch_up:
+	if (oper->cycle_time > 0 &&
+	    ktime_compare(now, oper->cycle_end_time) >= 0) {
+		s64 diff = ktime_to_ns(ktime_sub(now, oper->cycle_end_time));
+		s64 cycles = div64_s64(diff, oper->cycle_time) + 1;
+
+		if (admin) {
+			ktime_t admin_target = ktime_sub_ns(sched_base_time(admin),
+							    oper->cycle_time_extension);
+
+			if (ktime_compare(admin_target, oper->cycle_end_time) <= 0) {
+				cycles = 0;
+			} else {
+				s64 admin_diff = ktime_to_ns(ktime_sub(admin_target,
+								       oper->cycle_end_time));
+				s64 admin_cycles = div64_s64(admin_diff - 1,
+							     oper->cycle_time) + 1;
+
+				cycles = min(cycles, admin_cycles);
+			}
+		}
+
+		if (cycles > 0) {
+			oper->cycle_end_time = ktime_add_ns(oper->cycle_end_time,
+							    cycles * oper->cycle_time);
+			entry = NULL;
+		}
 	}
 
-	end_time = ktime_add_ns(entry->end_time, next->interval);
-	end_time = min_t(ktime_t, end_time, oper->cycle_end_time);
+	for (i = 0; i < oper->num_entries; i++) {
+		if (!entry) {
+			next = list_first_entry(&oper->entries, struct sched_entry,
+						list);
+			start_time = ktime_sub_ns(oper->cycle_end_time,
+						  oper->cycle_time);
+		} else {
+			start_time = entry->end_time;
+
+			if (should_restart_cycle(oper, entry)) {
+				next = list_first_entry(&oper->entries,
+							struct sched_entry, list);
+				oper->cycle_end_time = ktime_add_ns(oper->cycle_end_time,
+								    oper->cycle_time);
+			} else {
+				next = list_next_entry(entry, list);
+			}
+		}
 
-	for (tc = 0; tc < num_tc; tc++) {
-		if (next->gate_duration[tc] == oper->cycle_time)
-			next->gate_close_time[tc] = KTIME_MAX;
+		if (list_is_last(&next->list, &oper->entries))
+			duration = ktime_sub_ns(oper->cycle_end_time, start_time);
 		else
-			next->gate_close_time[tc] = ktime_add_ns(entry->end_time,
-								 next->gate_duration[tc]);
+			duration = min_t(s64, next->interval,
+					 ktime_sub_ns(oper->cycle_end_time, start_time));
+
+		end_time = ktime_add_ns(start_time, duration);
+
+		if (should_change_schedules(admin, oper, end_time)) {
+			switch_schedules(q, &admin, &oper);
+			entry = NULL;
+			goto catch_up;
+		}
+
+		if (ktime_after(end_time, now))
+			break;
+
+		entry = next;
+		entry->end_time = end_time;
 	}
 
-	if (should_change_schedules(admin, oper, end_time)) {
-		switch_schedules(q, &admin, &oper);
-		/* After changing schedules, the next entry is the first one
-		 * in the new schedule, with a pre-calculated end_time.
-		 */
-		next = list_first_entry(&oper->entries, struct sched_entry, list);
-		end_time = next->end_time;
+	for (tc = 0; tc < num_tc; tc++) {
+		if (next->gate_duration[tc] == oper->cycle_time &&
+		    duration == next->interval)
+			next->gate_close_time[tc] = KTIME_MAX;
+		else if (next->gate_mask & BIT(tc))
+			next->gate_close_time[tc] = end_time;
+		else
+			next->gate_close_time[tc] = start_time;
 	}
 
 	next->end_time = end_time;
-	taprio_set_budgets(q, oper, next);
+	taprio_set_budgets(q, oper, next, duration);
 
-first_run:
 	rcu_assign_pointer(q->current_entry, next);
+	expires = end_time;
+	if (unlikely(ktime_compare(expires, now) <= 0))
+		expires = ktime_add_ns(now, 1);
+	hrtimer_set_expires(&q->advance_timer, expires);
 	spin_unlock(&q->current_entry_lock);
 
-	hrtimer_set_expires(&q->advance_timer, end_time);
-
 	rcu_read_lock();
 	__netif_schedule(sch);
 	rcu_read_unlock();
@@ -1244,6 +1291,7 @@ static void setup_first_end_time(struct taprio_sched *q,
 	struct net_device *dev = qdisc_dev(q->root);
 	int num_tc = netdev_get_num_tc(dev);
 	struct sched_entry *first;
+	s64 duration;
 	ktime_t cycle;
 	int tc;
 
@@ -1255,17 +1303,27 @@ static void setup_first_end_time(struct taprio_sched *q,
 	/* FIXME: find a better place to do this */
 	sched->cycle_end_time = ktime_add_ns(base, cycle);
 
-	first->end_time = ktime_add_ns(base, first->interval);
-	taprio_set_budgets(q, sched, first);
+	if (list_is_last(&first->list, &sched->entries))
+		duration = cycle;
+	else
+		duration = min_t(s64, first->interval, cycle);
+
+	first->end_time = ktime_add_ns(base, duration);
+	taprio_set_budgets(q, sched, first, duration);
 
 	for (tc = 0; tc < num_tc; tc++) {
-		if (first->gate_duration[tc] == sched->cycle_time)
+		if (first->gate_duration[tc] == sched->cycle_time &&
+		    duration == first->interval)
 			first->gate_close_time[tc] = KTIME_MAX;
+		else if (first->gate_mask & BIT(tc))
+			first->gate_close_time[tc] = first->end_time;
 		else
-			first->gate_close_time[tc] = ktime_add_ns(base, first->gate_duration[tc]);
+			first->gate_close_time[tc] = base;
 	}
 
-	rcu_assign_pointer(q->current_entry, NULL);
+	if (!rcu_access_pointer(q->oper_sched) ||
+	    rcu_access_pointer(q->oper_sched) == sched)
+		rcu_assign_pointer(q->current_entry, NULL);
 }
 
 static void taprio_start_sched(struct Qdisc *sch,


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
