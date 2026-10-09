Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 07B4F370D5E
	for <syzbot@lists.linux.dev>; Fri,  9 Oct 2026 19:10:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791573003; cv=none; b=TNirW7jpnlj46Iy7ksPjHYlWQlmmeaYPkggtKjVrtw7f8RSWLcwzcRObrfEFS9rFyOVIw7QC8Bezkvze11j9osWrH5PAKv4fClJCAhvh2MwwnswN6Ob2aSwqRWYNo8c1bqRxO2lw8m5ZSY0n4mMKrl68S2AXFWIVKdcFZSxHtyY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791573003; c=relaxed/simple;
	bh=lRPHjqd9T07oMkFljoTxw6A+hlSiI+82jjh+Pbc9T00=;
	h=From:To:Cc:Subject:Message-ID:MIME-Version:Content-Type:Date; b=TJFvCn3pFJCIvttkjjAdUMa0rLdz0LzLGJggLKCY9OfLQ9Ql0Df+8xegu/zVLvz5fVpYDXKGdpBR6UVNH+IJocr2JqMucNCelnPeYUW43EL3ejoeSaI+JQ9a1wsX080kfQV25MDhj6gH5lwXxlDEhQT2asjc6PaiRQgICMRXPaM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=J8ZAi1Ag; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="J8ZAi1Ag"
Received: by smtp.kernel.org (Postfix) with UTF8SMTPSA id 897321F000FF;
	Fri,  9 Oct 2026 19:10:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1791573001;
	bh=C7Gpl/5jGP0y0uRRfewvqglIoN2ReWjSvwswcF99rTo=;
	h=From:To:Cc:Subject:Date;
	b=J8ZAi1AgtHAYFFRV+hmX8QKxP6MFf9aUvd0BxdislN6/uKL/L7RBC1JptH64ivaZh
	 oryH/R3tepxloV6xj/mk7wV48LVDydPPjLA59t7EQoeildS83deeRVwKZXL/TBX/NT
	 JO8qRamqnma0NVTRBNw2ipnj5hxJmYSFfXcAvw7OMKhSA7ySaDjmPrkNnrvUij7J+S
	 KDI2WjJ7SMOabq0k035KidDdz613lkbhTDXijzFuYNcchUy72r+rCX5xMaHivu0m2s
	 xHpjghUrK5Ad8HHkcP8BLEpZZE43jzNDGXKbs/q/BGL0JH3k9636345DE19Vrx24z6
	 w4ZLMek3el+Iw==
From: "syzbot" <syzbot@kernel.org>
To: syzkaller-upstream-moderation@googlegroups.com
Cc: immersa.bartosz.chronowski@gmail.com, syzbot@lists.linux.dev
Subject: [PATCH RFC v5] net/sched: taprio: catch up overdue cycles in advance_sched()
Message-ID: <2fcb3fdb-42b4-4a7a-bf17-3b5a422bfa75@mail.kernel.org>
Precedence: bulk
X-Mailing-List: syzbot@lists.linux.dev
List-Id: <syzbot.lists.linux.dev>
List-Subscribe: <mailto:syzbot+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:syzbot+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Date: Fri,  9 Oct 2026 19:10:01 +0000 (UTC)

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
Assisted-by: Gemini:gemini-3.8-flash syzbot
Reported-by: syzbot+f8850bc3986562f79619@syzkaller.appspotmail.com
Closes: https://syzkaller.appspot.com/bug?extid=f8850bc3986562f79619
Link: https://syzkaller.appspot.com/ai_job?id=069b71fb-28b3-4676-9783-f9c3f6bf377d
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
- Drop cycle_interval_sum and do not modify parse_taprio_schedule().
- Avoid skipping past pending admin schedule base time during cycle catch-up.
- Advance overdue entries within the cycle using a loop bounded by oper->num_entries.
- Clamp timer expiration to at least now + 1 ns if still overdue.
- Fix should_restart_cycle() to check for end_time >= cycle_end_time.
- Handle cycle_end_time capping for the first entry in setup_first_end_time().

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
index 299234a5f..31e123d97 100644
--- a/net/sched/sch_taprio.c
+++ b/net/sched/sch_taprio.c
@@ -875,7 +875,7 @@ static bool should_restart_cycle(const struct sched_gate_list *oper,
 	if (list_is_last(&entry->list, &oper->entries))
 		return true;
 
-	if (ktime_compare(entry->end_time, oper->cycle_end_time) == 0)
+	if (ktime_compare(entry->end_time, oper->cycle_end_time) >= 0)
 		return true;
 
 	return false;
@@ -924,8 +924,9 @@ static enum hrtimer_restart advance_sched(struct hrtimer *timer)
 	int num_tc = netdev_get_num_tc(dev);
 	struct sched_entry *entry, *next;
 	struct Qdisc *sch = q->root;
-	ktime_t end_time;
-	int tc;
+	ktime_t start_time, end_time, expires, now;
+	bool admin_switched = false;
+	int tc, i;
 
 	spin_lock(&q->current_entry_lock);
 	entry = rcu_dereference_protected(q->current_entry,
@@ -938,6 +939,8 @@ static enum hrtimer_restart advance_sched(struct hrtimer *timer)
 	if (!oper)
 		switch_schedules(q, &admin, &oper);
 
+	now = hrtimer_cb_get_time(timer);
+
 	/* This can happen in two cases: 1. this is the very first run
 	 * of this function (i.e. we weren't running any schedule
 	 * previously); 2. The previous schedule just ended. The first
@@ -948,47 +951,98 @@ static enum hrtimer_restart advance_sched(struct hrtimer *timer)
 		next = list_first_entry(&oper->entries, struct sched_entry,
 					list);
 		end_time = next->end_time;
-		goto first_run;
+		if (ktime_after(end_time, now))
+			goto first_run;
+		entry = next;
 	}
 
-	if (should_restart_cycle(oper, entry)) {
-		next = list_first_entry(&oper->entries, struct sched_entry,
-					list);
-		oper->cycle_end_time = ktime_add_ns(oper->cycle_end_time,
-						    oper->cycle_time);
-	} else {
-		next = list_next_entry(entry, list);
+	if (oper->cycle_time > 0 && ktime_after(now, oper->cycle_end_time)) {
+		s64 diff = ktime_to_ns(ktime_sub(now, oper->cycle_end_time));
+		s64 cycles = div64_s64(diff, oper->cycle_time) + 1;
+
+		if (admin) {
+			ktime_t admin_base = sched_base_time(admin);
+
+			if (ktime_after(ktime_add_ns(oper->cycle_end_time,
+						     cycles * oper->cycle_time),
+					admin_base)) {
+				diff = ktime_to_ns(ktime_sub(admin_base,
+							     oper->cycle_end_time));
+				cycles = diff > 0 ? div64_s64(diff, oper->cycle_time) : 0;
+			}
+		}
+
+		if (cycles > 0) {
+			s64 delta = cycles * oper->cycle_time;
+
+			oper->cycle_end_time = ktime_add_ns(oper->cycle_end_time, delta);
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
+			end_time = oper->cycle_end_time;
 		else
-			next->gate_close_time[tc] = ktime_add_ns(entry->end_time,
-								 next->gate_duration[tc]);
-	}
+			end_time = min_t(ktime_t,
+					 ktime_add_ns(start_time, next->interval),
+					 oper->cycle_end_time);
+
+		if (should_change_schedules(admin, oper, end_time)) {
+			switch_schedules(q, &admin, &oper);
+			next = list_first_entry(&oper->entries, struct sched_entry,
+						list);
+			end_time = next->end_time;
+			admin_switched = true;
+			break;
+		}
 
-	if (should_change_schedules(admin, oper, end_time)) {
-		switch_schedules(q, &admin, &oper);
-		/* After changing schedules, the next entry is the first one
-		 * in the new schedule, with a pre-calculated end_time.
-		 */
-		next = list_first_entry(&oper->entries, struct sched_entry, list);
-		end_time = next->end_time;
+		if (ktime_after(end_time, now))
+			break;
+
+		entry = next;
+		entry->end_time = end_time;
 	}
 
-	next->end_time = end_time;
-	taprio_set_budgets(q, oper, next);
+	if (!admin_switched) {
+		for (tc = 0; tc < num_tc; tc++) {
+			if (next->gate_duration[tc] == oper->cycle_time)
+				next->gate_close_time[tc] = KTIME_MAX;
+			else
+				next->gate_close_time[tc] = ktime_add_ns(start_time,
+									 next->gate_duration[tc]);
+		}
+
+		next->end_time = end_time;
+		taprio_set_budgets(q, oper, next);
+	}
 
 first_run:
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
@@ -1255,7 +1309,13 @@ static void setup_first_end_time(struct taprio_sched *q,
 	/* FIXME: find a better place to do this */
 	sched->cycle_end_time = ktime_add_ns(base, cycle);
 
-	first->end_time = ktime_add_ns(base, first->interval);
+	if (list_is_last(&first->list, &sched->entries))
+		first->end_time = sched->cycle_end_time;
+	else
+		first->end_time = min_t(ktime_t,
+					ktime_add_ns(base, first->interval),
+					sched->cycle_end_time);
+
 	taprio_set_budgets(q, sched, first);
 
 	for (tc = 0; tc < num_tc; tc++) {


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
