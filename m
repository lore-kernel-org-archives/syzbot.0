Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795177950;
	b=YjvsjcIntoTG7Yu0f1gpO+0QwhaJMiLV5n5wZeRmEUSIkmAMnsd7R1j0rup3NOX1a0u9
	 Akri3xVOZLWSR3VP0H+gA68Ef6Uw+biSCPmtgHq2ne6gqOjc4D4Dg3szN+1GiuAwy2ZSF
	 GNMrzt1zSa7zFsvdqQZOG7JcGJtEBg55P9yuDZhDgSmXWjCsY+N0RLxs4CB0xWYZeaEf0
	 m0t3TFa/oTCJ41w9Ya4dUffq5cTnrf48965OPWZtU7uqX+Wnt0wiNi2LTgfHKLaZ8vmTt
	 QZNMh6TaWJue9p6uEXD53f8siJazuiHw4Oq9XwgHKt9YsH1O0ga3SYxm0pXoErajefA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795177950;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Message-ID:MIME-Version:
	 Content-Type:Content-Transfer-Encoding:Date;
	bh=qzDm6EQrrYyRSIAdMRUM+bgly7XRKbLVf9oGvdxT0hU=;
	b=k5aDZS3VDlGC4WLzWnI9ag2x3UnfeCtvxFWj8rKhnePIrUle8YU+J25Esljpzkykb+rl
	 XG8t+097hjvu2IjoC7Gfs0yE3bGySVBPLCn/4OWLjptZUDrVPvZ2wwDKQ1WGD2Ez8vlTK
	 WlENhWKX5xGPulHPjRuuxBt6tspXFiEBY9xG1h4TtkY1CJmnTh9UlAlSVKyii9ruU6RaO
	 xiA3IRHdyu6rBJCy5kaonb/YzAL91npKWSix/UPuq90E95HwWR/V3s4Jfu5w1qCDqfJ0W
	 HQSI+1BOj3y9QEXxqsL+6uzyRmvN/nNTyj/LhxzXEdjnpn70Gn4jiFxCQ8FyKiNBNXg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b="SklH/cjQ";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with UTF8SMTPS id 08153606A325
	for <syzbot@lists.linux.dev>; Fri, 20 Nov 2026 12:32:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=SklH/cjQ
Received: by smtp.kernel.org (Postfix) with UTF8SMTPSA id 212361F000D1;
	Fri, 20 Nov 2026 12:32:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795177949;
	bh=qzDm6EQrrYyRSIAdMRUM+bgly7XRKbLVf9oGvdxT0hU=;
	h=From:To:Cc:Subject:Date;
	b=SklH/cjQ5PHbYhrfP5faM+l+yz/aJRgIyzvtMpuFOpFuk972ueT6QmYkYyPoF9f7r
	 7xBiuTZHJ8Dl4exw3i8UtJomA0y48QTblvNP6cmFQWpGcYws5928ma98yebgofcq7c
	 OpDvkZuk9MA/dAZkZKstQKeIpZJSJe9SdUJUYG7hnogryFiw7iiob3/BDblCehABQn
	 jwKr3xxzywaFscalJg39IrXx8pg0qpdaKmKmDd++b0VTrGj04rk2DCjjAuAvxSz5bY
	 sU3BIG6km6tMjAkdFXrsI0Pl9kD9VmDsC6F8VnS8ChCrqqq5jGZE7dA9717EDCG+Am
	 ajUxdY6PXVgxA==
From: "syzbot" <syzbot@kernel.org>
To: syzkaller-upstream-moderation@googlegroups.com
Cc: immersa.bartosz.chronowski@gmail.com, syzbot@lists.linux.dev
Subject: [PATCH RFC v8] net/sched: taprio: catch up overdue cycles in advance_sched()
Message-ID: <6f0c7f79-ecca-4f19-9cc9-38f9d950fb7d@mail.kernel.org>
X-Mailing-List: syzbot@lists.linux.dev
List-Id: <syzbot.lists.linux.dev>
List-Post: <mailto:syzbot@lists.linux.dev>
List-Help: <mailto:syzbot+help@lists.linux.dev>
List-Subscribe: <mailto:syzbot+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:syzbot+unsubscribe@lists.linux.dev>
List-Owner: <mailto:syzbot+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Date: Fri, 20 Nov 2026 12:32:29 +0000 (UTC)

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
that the current time is at or past oper->cycle_start_time, complete
schedule periods are skipped arithmetically by advancing
oper->cycle_start_time by the elapsed number of full cycles without
exceeding any pending admin schedule switch time, updating
oper->cycle_end_time accordingly. Overdue entries within the cycle are then
traversed in a loop bounded by oper->num_entries to catch up to the active
entry. If the resulting expiration is still not in the future, it is
clamped to at least one nanosecond ahead of the current time (unless
current time reaches KTIME_MAX) to avoid arming the timer in the past. At
timer saturation, taprio_ktime_add_ns() clamps time calculations at
KTIME_MAX to prevent overflow, cycle_start_time does not advance past
KTIME_MAX, and once the current time reaches KTIME_MAX, advance_sched()
skips re-arming the timer and returns HRTIMER_NORESTART.

Additionally, compute each entry's effective gate close deadline and 64-bit
budget in taprio_set_entry_gates() based on the actual entry durations
under an explicit cycle_time (accounting for entry truncation, last-entry
extension to the remaining cycle time, and wrap-around across the cycle
boundary for gates that remain open), using KTIME_MAX and S64_MAX for gates
that stay open for the entire cycle.

Fixes: 5a781ccbd19e ("tc: Add support for configuring the taprio scheduler")
Assisted-by: Gemini:gemini-4-hydrogen Gemini:gemini-4-carbon Gemini:gemini-3.8-flash syzbot
Reported-by: syzbot+f8850bc3986562f79619@syzkaller.appspotmail.com
Closes: https://syzkaller.appspot.com/bug?extid=f8850bc3986562f79619
Link: https://syzkaller.appspot.com/ai_job?id=a738f4ff-1e79-4e44-8d03-dc5aad0ca15e
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
v8:
- Track cycle_start_time and cycle_initialized in struct sched_gate_list and skip elapsed cycles via cycle_start_time in advance_sched().
- Add taprio_ktime_add_ns() to saturate time calculations at KTIME_MAX and stop re-arming advance_timer when now reaches KTIME_MAX.
- Add taprio_set_entry_gates() to compute effective gate close times and 64-bit budgets under an explicit cycle_time.
- Use div64_u64_rem() with saturation in taprio_get_start_time() and check hrtimer_active() in taprio_start_sched().

v7:
- Narrow the commit description claim about timer expiration guarantees to reflect that overdue expirations are clamped to now + 1 ns unless now reaches KTIME_MAX.
- Add overflow protection when calculating skipped cycles and cycle_end_time near KTIME_MAX.
- Introduce taprio_admin_switch_time() helper to safely compute admin schedule switch boundaries with underflow checks.
- Switch entry budgets to atomic64_t to prevent overflow with large intervals.
- Re-arm the advance timer via hrtimer_start() returning HRTIMER_NORESTART.
- Drop the duration parameter from taprio_set_budgets().
https://lore.kernel.org/all/02b82ad9-cb50-40a5-aab9-75d8754ccf24@mail.kernel.org/T/

v6:
- Account for cycle_time_extension when calculating cycle catch-up before an admin schedule switch.
- Restart catch-up loop after switching to an admin schedule in advance_sched().
- Update taprio_set_budgets() and gate close times to use actual entry duration and gate mask.
- Avoid resetting current_entry in setup_first_end_time() when configuring an admin schedule.
https://lore.kernel.org/all/0423fb98-9248-4f3a-88d2-6e8fe89c26ea@mail.kernel.org/T/

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
index 299234a5f..ae2a83ab0 100644
--- a/net/sched/sch_taprio.c
+++ b/net/sched/sch_taprio.c
@@ -54,7 +54,7 @@ struct sched_entry {
 	 * respective traffic class gate closes
 	 */
 	u64 gate_duration[TC_MAX_QUEUE];
-	atomic_t budget[TC_MAX_QUEUE];
+	atomic64_t budget[TC_MAX_QUEUE];
 	/* The qdisc makes some effort so that no packet leaves
 	 * after this time
 	 */
@@ -79,10 +79,12 @@ struct sched_gate_list {
 	struct rcu_head rcu;
 	struct list_head entries;
 	size_t num_entries;
+	ktime_t cycle_start_time;
 	ktime_t cycle_end_time;
 	s64 cycle_time;
 	s64 cycle_time_extension;
 	s64 base_time;
+	bool cycle_initialized;
 };
 
 struct taprio_sched {
@@ -659,45 +661,141 @@ static struct sk_buff *taprio_peek(struct Qdisc *sch)
 	return NULL;
 }
 
+static ktime_t taprio_ktime_add_ns(ktime_t kt, u64 ns)
+{
+	if (ns >= (u64)KTIME_MAX - (u64)kt)
+		return KTIME_MAX;
+
+	return (ktime_t)((u64)kt + ns);
+}
+
 static void taprio_set_budgets(struct taprio_sched *q,
 			       struct sched_gate_list *sched,
-			       struct sched_entry *entry)
+			       struct sched_entry *entry,
+			       const u64 gate_duration[TC_MAX_QUEUE])
 {
 	struct net_device *dev = qdisc_dev(q->root);
 	int num_tc = netdev_get_num_tc(dev);
-	int tc, budget;
+	s64 budget;
+	int tc;
 
 	for (tc = 0; tc < num_tc; tc++) {
 		/* Traffic classes which never close have infinite budget */
-		if (entry->gate_duration[tc] == sched->cycle_time)
-			budget = INT_MAX;
+		if (gate_duration[tc] == sched->cycle_time)
+			budget = S64_MAX;
 		else
-			budget = div64_u64((u64)entry->gate_duration[tc] * PSEC_PER_NSEC,
-					   atomic64_read(&q->picos_per_byte));
+			budget = min_t(u64,
+				       div64_u64(gate_duration[tc] * PSEC_PER_NSEC,
+						 atomic64_read(&q->picos_per_byte)),
+				       S64_MAX - 1);
 
-		atomic_set(&entry->budget[tc], budget);
+		atomic64_set(&entry->budget[tc], budget);
 	}
 }
 
+static void taprio_set_entry_gates(struct taprio_sched *q,
+				   struct sched_gate_list *sched,
+				   struct sched_entry *entry,
+				   ktime_t start_time)
+{
+	struct net_device *dev = qdisc_dev(q->root);
+	u32 gates_still_open = entry->gate_mask;
+	u64 gate_duration[TC_MAX_QUEUE] = {};
+	int num_tc = netdev_get_num_tc(dev);
+	struct sched_entry *cur;
+	bool started = false;
+	s64 rem;
+	int tc;
+
+	rem = sched->cycle_time;
+	list_for_each_entry(cur, &sched->entries, list) {
+		s64 dur;
+
+		if (rem <= 0)
+			break;
+
+		if (list_is_last(&cur->list, &sched->entries))
+			dur = rem;
+		else
+			dur = min_t(s64, cur->interval, rem);
+		rem -= dur;
+
+		if (cur == entry)
+			started = true;
+		if (!started)
+			continue;
+
+		if (!gates_still_open)
+			break;
+
+		for (tc = 0; tc < num_tc; tc++) {
+			if (!(gates_still_open & BIT(tc)))
+				continue;
+
+			if (cur->gate_mask & BIT(tc))
+				gate_duration[tc] += dur;
+			else
+				gates_still_open &= ~BIT(tc);
+		}
+	}
+
+	if (started && gates_still_open) {
+		rem = sched->cycle_time;
+		list_for_each_entry(cur, &sched->entries, list) {
+			s64 dur;
+
+			if (cur == entry || rem <= 0 || !gates_still_open)
+				break;
+
+			if (list_is_last(&cur->list, &sched->entries))
+				dur = rem;
+			else
+				dur = min_t(s64, cur->interval, rem);
+			rem -= dur;
+
+			for (tc = 0; tc < num_tc; tc++) {
+				if (!(gates_still_open & BIT(tc)))
+					continue;
+
+				if (cur->gate_mask & BIT(tc))
+					gate_duration[tc] += dur;
+				else
+					gates_still_open &= ~BIT(tc);
+			}
+		}
+	}
+
+	for (tc = 0; tc < num_tc; tc++) {
+		if (gate_duration[tc] == sched->cycle_time)
+			entry->gate_close_time[tc] = KTIME_MAX;
+		else
+			entry->gate_close_time[tc] = taprio_ktime_add_ns(start_time,
+									 gate_duration[tc]);
+	}
+
+	taprio_set_budgets(q, sched, entry, gate_duration);
+}
+
 /* When an skb is sent, it consumes from the budget of all traffic classes */
-static int taprio_update_budgets(struct sched_entry *entry, size_t len,
+static s64 taprio_update_budgets(struct sched_entry *entry, size_t len,
 				 int tc_consumed, int num_tc)
 {
-	int tc, budget, new_budget = 0;
+	s64 budget, new_budget = 0;
+	int tc;
 
 	for (tc = 0; tc < num_tc; tc++) {
-		budget = atomic_read(&entry->budget[tc]);
+		budget = atomic64_read(&entry->budget[tc]);
 		/* Don't consume from infinite budget */
-		if (budget == INT_MAX) {
+		if (budget == S64_MAX) {
 			if (tc == tc_consumed)
 				new_budget = budget;
 			continue;
 		}
 
 		if (tc == tc_consumed)
-			new_budget = atomic_sub_return(len, &entry->budget[tc]);
+			new_budget = atomic64_sub_return(len, &entry->budget[tc]);
 		else
-			atomic_sub(len, &entry->budget[tc]);
+			atomic64_sub(len, &entry->budget[tc]);
 	}
 
 	return new_budget;
@@ -734,7 +832,8 @@ static struct sk_buff *taprio_dequeue_from_txq(struct Qdisc *sch, int txq,
 		return NULL;
 
 	len = qdisc_pkt_len(skb);
-	guard = ktime_add_ns(taprio_get_time(q), length_to_duration(q, len));
+	guard = taprio_ktime_add_ns(taprio_get_time(q),
+				    length_to_duration(q, len));
 
 	/* In the case that there's no gate entry, there's no
 	 * guard band ...
@@ -875,57 +974,47 @@ static bool should_restart_cycle(const struct sched_gate_list *oper,
 	if (list_is_last(&entry->list, &oper->entries))
 		return true;
 
-	if (ktime_compare(entry->end_time, oper->cycle_end_time) == 0)
+	if (ktime_compare(entry->end_time, oper->cycle_end_time) >= 0)
 		return true;
 
 	return false;
 }
 
+static ktime_t taprio_admin_switch_time(const struct sched_gate_list *admin,
+					const struct sched_gate_list *oper)
+{
+	ktime_t base = sched_base_time(admin);
+
+	if (oper->cycle_time_extension <= 0)
+		return base;
+
+	if (base < S64_MIN + oper->cycle_time_extension)
+		return S64_MIN;
+
+	return ktime_sub_ns(base, oper->cycle_time_extension);
+}
+
 static bool should_change_schedules(const struct sched_gate_list *admin,
 				    const struct sched_gate_list *oper,
 				    ktime_t end_time)
 {
-	ktime_t next_base_time, extension_time;
-
 	if (!admin)
 		return false;
 
-	next_base_time = sched_base_time(admin);
-
-	/* This is the simple case, the end_time would fall after
-	 * the next schedule base_time.
-	 */
-	if (ktime_compare(next_base_time, end_time) <= 0)
-		return true;
-
-	/* This is the cycle_time_extension case, if the end_time
-	 * plus the amount that can be extended would fall after the
-	 * next schedule base_time, we can extend the current schedule
-	 * for that amount.
-	 */
-	extension_time = ktime_add_ns(end_time, oper->cycle_time_extension);
-
-	/* FIXME: the IEEE 802.1Q-2018 Specification isn't clear about
-	 * how precisely the extension should be made. So after
-	 * conformance testing, this logic may change.
-	 */
-	if (ktime_compare(next_base_time, extension_time) <= 0)
-		return true;
-
-	return false;
+	return ktime_compare(taprio_admin_switch_time(admin, oper),
+			     end_time) <= 0;
 }
 
 static enum hrtimer_restart advance_sched(struct hrtimer *timer)
 {
 	struct taprio_sched *q = container_of(timer, struct taprio_sched,
 					      advance_timer);
-	struct net_device *dev = qdisc_dev(q->root);
+	ktime_t start_time, end_time, expires, now;
 	struct sched_gate_list *oper, *admin;
-	int num_tc = netdev_get_num_tc(dev);
 	struct sched_entry *entry, *next;
 	struct Qdisc *sch = q->root;
-	ktime_t end_time;
-	int tc;
+	s64 duration;
+	size_t i;
 
 	spin_lock(&q->current_entry_lock);
 	entry = rcu_dereference_protected(q->current_entry,
@@ -938,62 +1027,139 @@ static enum hrtimer_restart advance_sched(struct hrtimer *timer)
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
-	}
+	now = hrtimer_cb_get_time(timer);
 
-	end_time = ktime_add_ns(entry->end_time, next->interval);
-	end_time = min_t(ktime_t, end_time, oper->cycle_end_time);
+	if (entry && entry->end_time == oper->base_time)
+		entry = NULL;
 
-	for (tc = 0; tc < num_tc; tc++) {
-		if (next->gate_duration[tc] == oper->cycle_time)
-			next->gate_close_time[tc] = KTIME_MAX;
-		else
-			next->gate_close_time[tc] = ktime_add_ns(entry->end_time,
-								 next->gate_duration[tc]);
+catch_up:
+	if (!oper->cycle_initialized) {
+		if (oper->cycle_time > 0 && oper->cycle_end_time &&
+		    oper->cycle_end_time >= S64_MIN + oper->cycle_time) {
+			oper->cycle_start_time = ktime_sub_ns(oper->cycle_end_time,
+							      oper->cycle_time);
+		} else {
+			oper->cycle_start_time = oper->base_time;
+			if (oper->cycle_time > 0)
+				oper->cycle_end_time = taprio_ktime_add_ns(oper->base_time,
+									   oper->cycle_time);
+		}
+		oper->cycle_initialized = true;
 	}
 
-	if (should_change_schedules(admin, oper, end_time)) {
-		switch_schedules(q, &admin, &oper);
-		/* After changing schedules, the next entry is the first one
-		 * in the new schedule, with a pre-calculated end_time.
-		 */
-		next = list_first_entry(&oper->entries, struct sched_entry, list);
-		end_time = next->end_time;
+	if (oper->cycle_time > 0 &&
+	    ktime_compare(now, oper->cycle_start_time) >= 0) {
+		u64 elapsed = (u64)now - (u64)oper->cycle_start_time;
+		u64 cycles = div64_u64(elapsed, oper->cycle_time);
+
+		if (cycles > 0 && admin) {
+			ktime_t admin_target = taprio_admin_switch_time(admin,
+									oper);
+
+			if (ktime_compare(admin_target,
+					  oper->cycle_start_time) <= 0) {
+				cycles = 0;
+			} else {
+				u64 admin_diff = (u64)admin_target -
+						 (u64)oper->cycle_start_time;
+				u64 admin_cycles = div64_u64(admin_diff - 1,
+							     oper->cycle_time);
+
+				cycles = min(cycles, admin_cycles);
+			}
+		}
+
+		if (cycles > 0) {
+			oper->cycle_start_time = (ktime_t)((u64)oper->cycle_start_time +
+							   cycles * (u64)oper->cycle_time);
+			oper->cycle_end_time = taprio_ktime_add_ns(oper->cycle_start_time,
+								   oper->cycle_time);
+			entry = NULL;
+		}
 	}
 
+	if (entry && oper->cycle_time > 0 &&
+	    (u64)KTIME_MAX - (u64)oper->cycle_start_time < (u64)oper->cycle_time &&
+	    (entry->end_time == KTIME_MAX || should_restart_cycle(oper, entry)))
+		entry = NULL;
+
+	i = 0;
+	do {
+		s64 rem;
+
+		if (!entry) {
+			next = list_first_entry(&oper->entries,
+						struct sched_entry, list);
+			start_time = oper->cycle_start_time;
+		} else if (should_restart_cycle(oper, entry) &&
+			   oper->cycle_time > 0 &&
+			   (u64)KTIME_MAX - (u64)oper->cycle_start_time >=
+			   (u64)oper->cycle_time) {
+			oper->cycle_start_time = taprio_ktime_add_ns(oper->cycle_start_time,
+								     oper->cycle_time);
+			oper->cycle_end_time = taprio_ktime_add_ns(oper->cycle_start_time,
+								   oper->cycle_time);
+			start_time = oper->cycle_start_time;
+			next = list_first_entry(&oper->entries,
+						struct sched_entry, list);
+		} else if (should_restart_cycle(oper, entry)) {
+			next = list_first_entry(&oper->entries,
+						struct sched_entry, list);
+			start_time = oper->cycle_start_time;
+		} else {
+			start_time = entry->end_time;
+			next = list_next_entry(entry, list);
+		}
+
+		if (oper->cycle_time <= 0)
+			rem = 0;
+		else if (ktime_compare(start_time, oper->cycle_start_time) <= 0)
+			rem = oper->cycle_time;
+		else if ((u64)start_time - (u64)oper->cycle_start_time >=
+			 (u64)oper->cycle_time)
+			rem = 0;
+		else
+			rem = oper->cycle_time -
+			      (s64)((u64)start_time - (u64)oper->cycle_start_time);
+
+		if (list_is_last(&next->list, &oper->entries))
+			duration = rem;
+		else
+			duration = min_t(s64, next->interval, rem);
+
+		end_time = taprio_ktime_add_ns(start_time, duration);
+
+		if (should_change_schedules(admin, oper, end_time)) {
+			switch_schedules(q, &admin, &oper);
+			entry = NULL;
+			goto catch_up;
+		}
+
+		if (ktime_before(now, start_time) ||
+		    (u64)duration > (u64)now - (u64)start_time)
+			break;
+
+		entry = next;
+		entry->end_time = end_time;
+	} while (++i < oper->num_entries);
+
 	next->end_time = end_time;
-	taprio_set_budgets(q, oper, next);
+	taprio_set_entry_gates(q, oper, next, start_time);
 
-first_run:
 	rcu_assign_pointer(q->current_entry, next);
+	if (likely(now < KTIME_MAX)) {
+		expires = end_time;
+		if (unlikely(ktime_compare(expires, now) <= 0))
+			expires = ktime_add_ns(now, 1);
+		hrtimer_start(&q->advance_timer, expires, HRTIMER_MODE_ABS);
+	}
 	spin_unlock(&q->current_entry_lock);
 
-	hrtimer_set_expires(&q->advance_timer, end_time);
-
 	rcu_read_lock();
 	__netif_schedule(sch);
 	rcu_read_unlock();
 
-	return HRTIMER_RESTART;
+	return HRTIMER_NORESTART;
 }
 
 static const struct nla_policy entry_policy[TCA_TAPRIO_SCHED_ENTRY_MAX + 1] = {
@@ -1210,7 +1376,7 @@ static int taprio_get_start_time(struct Qdisc *sch,
 {
 	struct taprio_sched *q = qdisc_priv(sch);
 	ktime_t now, base, cycle;
-	s64 n;
+	u64 rem;
 
 	base = sched_base_time(sched);
 	now = taprio_get_time(q);
@@ -1227,25 +1393,23 @@ static int taprio_get_start_time(struct Qdisc *sch,
 	 * something went really wrong. In that case, we should warn about this
 	 * inconsistent state and return error.
 	 */
-	if (WARN_ON(!cycle))
+	if (WARN_ON(cycle <= 0))
 		return -EFAULT;
 
 	/* Schedule the start time for the beginning of the next
 	 * cycle.
 	 */
-	n = div64_s64(ktime_sub_ns(now, base), cycle);
-	*start = ktime_add_ns(base, (n + 1) * cycle);
+	div64_u64_rem((u64)now - (u64)base, cycle, &rem);
+	*start = taprio_ktime_add_ns(now, (u64)cycle - rem);
 	return 0;
 }
 
 static void setup_first_end_time(struct taprio_sched *q,
 				 struct sched_gate_list *sched, ktime_t base)
 {
-	struct net_device *dev = qdisc_dev(q->root);
-	int num_tc = netdev_get_num_tc(dev);
 	struct sched_entry *first;
 	ktime_t cycle;
-	int tc;
+	s64 duration;
 
 	first = list_first_entry(&sched->entries,
 				 struct sched_entry, list);
@@ -1253,19 +1417,21 @@ static void setup_first_end_time(struct taprio_sched *q,
 	cycle = sched->cycle_time;
 
 	/* FIXME: find a better place to do this */
-	sched->cycle_end_time = ktime_add_ns(base, cycle);
+	sched->cycle_start_time = base;
+	sched->cycle_end_time = taprio_ktime_add_ns(base, cycle);
+	sched->cycle_initialized = true;
 
-	first->end_time = ktime_add_ns(base, first->interval);
-	taprio_set_budgets(q, sched, first);
+	if (list_is_last(&first->list, &sched->entries))
+		duration = cycle;
+	else
+		duration = min_t(s64, first->interval, cycle);
 
-	for (tc = 0; tc < num_tc; tc++) {
-		if (first->gate_duration[tc] == sched->cycle_time)
-			first->gate_close_time[tc] = KTIME_MAX;
-		else
-			first->gate_close_time[tc] = ktime_add_ns(base, first->gate_duration[tc]);
-	}
+	first->end_time = taprio_ktime_add_ns(base, duration);
+	taprio_set_entry_gates(q, sched, first, base);
 
-	rcu_assign_pointer(q->current_entry, NULL);
+	if (!rcu_access_pointer(q->oper_sched) ||
+	    rcu_access_pointer(q->oper_sched) == sched)
+		rcu_assign_pointer(q->current_entry, NULL);
 }
 
 static void taprio_start_sched(struct Qdisc *sch,
@@ -1277,9 +1443,10 @@ static void taprio_start_sched(struct Qdisc *sch,
 	if (FULL_OFFLOAD_IS_ENABLED(q->flags))
 		return;
 
-	expires = hrtimer_get_expires(&q->advance_timer);
-	if (expires == 0)
+	if (!hrtimer_active(&q->advance_timer))
 		expires = KTIME_MAX;
+	else
+		expires = hrtimer_get_expires(&q->advance_timer);
 
 	/* If the new schedule starts before the next expiration, we
 	 * reprogram it to the earliest one, so we change the admin
@@ -1368,7 +1535,7 @@ static void setup_txtime(struct taprio_sched *q,
 	u64 interval = 0;
 
 	list_for_each_entry(entry, &sched->entries, list) {
-		entry->next_txtime = ktime_add_ns(base, interval);
+		entry->next_txtime = taprio_ktime_add_ns(base, interval);
 		interval += entry->interval;
 	}
 }


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
