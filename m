Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6B34717A30A
	for <syzbot@lists.linux.dev>; Fri,  2 Oct 2026 02:31:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790908271; cv=none; b=f2xYTj4SGQc0crJEX9W2tIlvaSvVG1w0PsNzDdxgZus+JldWuosSnbc3luoXIaHAt7wc7CaKaQgybAjU5l3EvimDLEhepHMACBm+w8/+mWtu4fpB8sC9kpuluCDs9VdFVmAg6JByJ58U+LErfHWvxQEHjQ5H1OGE1S7G+/0XDCI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790908271; c=relaxed/simple;
	bh=9gHJU0Nqq5jWnBbd63Vudew3qKb28oYBzoo9pMakazk=;
	h=From:To:Cc:Subject:Message-ID:MIME-Version:Content-Type:Date; b=DdqpjygQtAcQSJJcQwPRh9Sl7SNmcfU84kEsIJ7emMlQNdwWyIGv+s2NiVyp79Fg7Q5MGPYZuTzAgE05DGdQF4R6fg0Z0LO5YXupgJmMcYzqStnOkv+DGTm3uIfIoVuIrFGtdhmqmfkVOBibqfwp15MnkUbJS3S9IjneU4K1QkE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=RPA2jAu+; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="RPA2jAu+"
Received: by smtp.kernel.org (Postfix) with UTF8SMTPSA id DCC781F000FF;
	Fri,  2 Oct 2026 02:31:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1790908269;
	bh=neeR3bi7TtOSvFQdNNnFFs34h9bJmV7BplrIFZGO5qE=;
	h=From:To:Cc:Subject:Date;
	b=RPA2jAu+haJYqemCsvN2D07saskdXriQiHAJryIzTqBjE5LOO86ABFsSXhHBtIBjk
	 fxZHztC5f4KwYOrDBQ72scbljSpFWrbtEav0EEHfHdeKAfUEa6aJeQBxweSF/C3rL+
	 b4kGDQt88apl5eN08CfzQ/aE04VzExuMLrxOwIdJ9RpGO+0nrHaWQ4REOoG8QgW9rJ
	 ikIdHclZ6BeYDN/kaGPqZygUo52a52eeQXySYBahcmHNvuxgQK83wYDK1i8fkz7E/g
	 8Ww3ip+SE4Ugl3pSGORPxLsIsipFECvGCwjhSAEEfhTdv9u5NrVX7rI/iPn2+ur8WD
	 N2XTooVbtP6KA==
From: "syzbot" <syzbot@kernel.org>
To: syzkaller-upstream-moderation@googlegroups.com
Cc: immersa.bartosz.chronowski@gmail.com, syzbot@lists.linux.dev
Subject: [PATCH RFC v4] net/sched: taprio: enforce minimum interval in software mode
Message-ID: <e048bbcd-a352-43e2-bef2-a08c12b27099@mail.kernel.org>
Precedence: bulk
X-Mailing-List: syzbot@lists.linux.dev
List-Id: <syzbot.lists.linux.dev>
List-Subscribe: <mailto:syzbot+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:syzbot+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Date: Fri,  2 Oct 2026 02:31:08 +0000 (UTC)

In taprio software mode (when full offload and txtime-assist are not
enabled), schedule advancement is driven in software by an hrtimer running
advance_sched(). The minimum allowed duration for schedule entries was
previously bounded only by length_to_duration(q, ETH_ZLEN). For high link
speeds or small picos_per_byte, this allows entry intervals to be
configured to extremely small values (e.g., tens of nanoseconds).

When entry intervals or cycle_time are configured to values shorter than
the time required to execute the timer callback, the newly calculated
expiration time is in the past. Consequently, the hrtimer subsystem
repeatedly and immediately re-invokes advance_sched() in hardirq context,
resulting in an interrupt storm that starves the CPU and triggers RCU
stalls:

rcu: INFO: rcu_preempt detected stalls on CPUs/tasks:
rcu: 	0-...!: (1 GPs behind) idle=fc14/1/0x4000000000000000
softirq=20212/20212 fqs=5
rcu: 	(detected by 1, t=10502 jiffies, g=16909, q=1720 ncpus=2)
Sending NMI from CPU 1 to CPUs 0:
NMI backtrace for cpu 0
CPU: 0 UID: 0 PID: 200 Comm: kworker/u9:4 Not tainted
RIP: 0010:advance_sched+0x10f/0xc80 net/sched/sch_taprio.c:932
Call Trace:
 <IRQ>
 __run_hrtimer kernel/time/hrtimer.c:2067 [inline]
 __hrtimer_run_queues+0x3bc/0xa10 kernel/time/hrtimer.c:2124
 hrtimer_interrupt+0x4cd/0xaa0 kernel/time/hrtimer.c:2243
 local_apic_timer_interrupt arch/x86/kernel/apic/apic.c:1051 [inline]
 __sysvec_apic_timer_interrupt+0x102/0x430 arch/x86/kernel/apic/apic.c:1068
 sysvec_apic_timer_interrupt+0xa1/0xc0 arch/x86/kernel/apic/apic.c:1062
 </IRQ>

To prevent CPU starvation, define TAPRIO_MIN_SW_INTERVAL_NS (10 us) and
introduce taprio_min_interval(). For software mode, enforcing a minimum
interval of 10 us establishes a serviceability guarantee: because 10 us is
significantly larger than the execution latency of advance_sched(), the CPU
is guaranteed sufficient processing time between timer interrupts to make
forward progress, service softirqs, and advance RCU grace periods. For
TXTIME-assist and full-offload modes, advance_sched() does not drive
schedule switching in software, so taprio_min_interval() continues to
compute length_to_duration(q, ETH_ZLEN) without the 10 us clamp, preserving
hardware offload capabilities.

Unify the derivation of the effective schedule directly in
parse_taprio_schedule(). When an explicit cycle_time is configured, entries
exceeding cycle_time are dropped, any entry straddling the cycle boundary
is truncated to fit the remaining cycle duration, and if the total duration
is less than cycle_time, the final entry is extended to fill the cycle. The
entries are reindexed and validated so that every effective interval
satisfies taprio_min_interval(). Materializing this effective schedule
in-place ensures that all consumers—including gate duration calculations
(taprio_calculate_gate_durations), packet transmission lookup
(find_entry_to_transmit), transmission budgets, queueMaxSDU validation, and
hardware offload drivers—operate on an identical, consistent schedule
definition without sub-minimum trailing intervals.

To further guarantee serviceability under worst-case timer delays (e.g.
from high interrupt latency or preemption), advance_sched() now enforces
bounded catch-up work and strictly future timer expiration. If the timer
fires late such that the scheduled expiration time has already passed,
advance_sched() advances at most a bounded number of entries (up to 32)
before switching to an O(1) cycle-advancement fast-forward path. If the
resulting target expiration remains in the past, it clamps the next
expiration time to at least taprio_min_interval(q) into the future.
Bounding catch-up iterations to constant time and guaranteeing that timer
expiry is always strictly in the future ensures that the CPU cannot be
trapped in an hrtimer interrupt loop and will always make forward progress.

Finally, parse and validate the schedule in taprio_change() before invoking
netdev_set_num_tc(), ensure netdev traffic class configuration is cleanly
rolled back on subsequent errors, move taprio_calculate_gate_durations()
after traffic classes are established, and reject empty schedules.

Fixes: 6ca6a6654225 ("taprio: Add support for setting the cycle-time manually")
Assisted-by: Gemini:gemini-3.8-flash syzbot
Reported-by: syzbot+14c6ac6811273526cfa5@syzkaller.appspotmail.com
Closes: https://syzkaller.appspot.com/bug?extid=14c6ac6811273526cfa5
Link: https://syzkaller.appspot.com/ai_job?id=706e3d4e-5003-47b1-b0b1-1eb29cf65731
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
v4:
- Unified effective schedule derivation in parse_taprio_schedule() by dropping out-of-bounds entries, truncating boundary-straddling entries, and padding trailing entries, ensuring all consumers operate on the identical schedule.
- Moved entry interval validation to parse_taprio_schedule() to validate effective post-truncation intervals against taprio_min_interval().
- Added bounded catch-up advancement (up to 32 entries) and fast-forward cycle calculation in advance_sched() to bound interrupt latency.
- Enforced strictly future hrtimer expiration in advance_sched() by clamping end_time to at least taprio_min_interval() ahead of the current time.
- Added cleanup logic to reset netdev traffic classes in taprio_change() if an error occurs after netdev_set_num_tc().
- Added safety checks for NULL oper in should_change_schedules() and advance_sched().
- Updated curr_intv_start boundary check in find_entry_to_transmit().

v3:
- Ensure schedule entries truncated by an explicit cycle_time meet min_duration in parse_taprio_schedule()
- Clamp first entry end_time to cycle_time in setup_first_end_time()
- Parse and validate schedule before applying netdev traffic class configuration in taprio_change()
- Reject schedules with no entries in parse_taprio_schedule()
- Update commit message to detail the serviceability guarantee, cycle truncation handling, and offload mode arithmetic
https://lore.kernel.org/all/5a7fa927-7ed9-4c7b-82b8-97cb8fdadfc9@mail.kernel.org/T/

v2:
- Enforce a minimum interval of 10 us (TAPRIO_MIN_SW_INTERVAL_NS) in software mode instead of comparing cycle_time against the sum of intervals.
- Add taprio_min_interval() helper to determine the minimum interval based on offload and txtime-assist flags.
- Use taprio_min_interval() in fill_sched_entry() and parse_taprio_schedule().
https://lore.kernel.org/all/edd30c9e-6673-42a0-ab07-b7fb2bb67795@mail.kernel.org/T/

v1:
https://lore.kernel.org/all/3527dbf1-ab94-4184-8405-8552799efb71@mail.kernel.org/T/
---
diff --git a/net/sched/sch_taprio.c b/net/sched/sch_taprio.c
index 39ac5b97a..c02a03cf2 100644
--- a/net/sched/sch_taprio.c
+++ b/net/sched/sch_taprio.c
@@ -48,6 +48,10 @@ static struct static_key_false taprio_have_working_mqprio;
  * 60 * 17 > PSEC_PER_NSEC (1000)
  */
 #define TAPRIO_PICOS_PER_BYTE_MIN 17
+/* Minimum interval for software mode (hrtimer-driven advance_sched) to
+ * avoid hrtimer interrupt storms and CPU starvation.
+ */
+#define TAPRIO_MIN_SW_INTERVAL_NS (10 * NSEC_PER_USEC)
 
 struct sched_entry {
 	/* Durations between this GCL entry and the GCL entry where the
@@ -259,6 +263,17 @@ static int length_to_duration(struct taprio_sched *q, int len)
 	return div_u64(len * atomic64_read(&q->picos_per_byte), PSEC_PER_NSEC);
 }
 
+static int taprio_min_interval(struct taprio_sched *q)
+{
+	int min_duration = length_to_duration(q, ETH_ZLEN);
+
+	if (!FULL_OFFLOAD_IS_ENABLED(q->flags) &&
+	    !TXTIME_ASSIST_IS_ENABLED(q->flags))
+		min_duration = max_t(int, min_duration, TAPRIO_MIN_SW_INTERVAL_NS);
+
+	return min_duration;
+}
+
 static int duration_to_length(struct taprio_sched *q, u64 duration)
 {
 	return div_u64(duration * PSEC_PER_NSEC, atomic64_read(&q->picos_per_byte));
@@ -357,7 +372,7 @@ static struct sched_entry *find_entry_to_transmit(struct sk_buff *skb,
 		curr_intv_end = get_interval_end_time(sched, admin, entry,
 						      curr_intv_start);
 
-		if (ktime_after(curr_intv_start, cycle_end))
+		if (ktime_compare(curr_intv_start, cycle_end) >= 0)
 			break;
 
 		if (!(entry->gate_mask & BIT(tc)) ||
@@ -888,7 +903,7 @@ static bool should_change_schedules(const struct sched_gate_list *admin,
 {
 	ktime_t next_base_time, extension_time;
 
-	if (!admin)
+	if (!admin || !oper)
 		return false;
 
 	next_base_time = sched_base_time(admin);
@@ -916,6 +931,57 @@ static bool should_change_schedules(const struct sched_gate_list *admin,
 	return false;
 }
 
+static void taprio_advance_one_entry(struct taprio_sched *q,
+				     struct sched_gate_list **p_oper,
+				     struct sched_gate_list **p_admin,
+				     struct sched_entry **p_entry,
+				     struct sched_entry **p_next,
+				     ktime_t *p_end_time,
+				     int num_tc)
+{
+	struct sched_gate_list *oper = *p_oper;
+	struct sched_gate_list *admin = *p_admin;
+	struct sched_entry *entry = *p_entry;
+	struct sched_entry *next;
+	ktime_t end_time;
+	int tc;
+
+	if (should_restart_cycle(oper, entry)) {
+		next = list_first_entry(&oper->entries, struct sched_entry,
+					list);
+		oper->cycle_end_time = ktime_add_ns(oper->cycle_end_time,
+						    oper->cycle_time);
+	} else {
+		next = list_next_entry(entry, list);
+	}
+
+	end_time = ktime_add_ns(entry->end_time, next->interval);
+	end_time = min_t(ktime_t, end_time, oper->cycle_end_time);
+
+	for (tc = 0; tc < num_tc; tc++) {
+		if (next->gate_duration[tc] == oper->cycle_time)
+			next->gate_close_time[tc] = KTIME_MAX;
+		else
+			next->gate_close_time[tc] = ktime_add_ns(entry->end_time,
+								 next->gate_duration[tc]);
+	}
+
+	if (should_change_schedules(admin, oper, end_time)) {
+		switch_schedules(q, &admin, &oper);
+		*p_admin = admin;
+		*p_oper = oper;
+		next = list_first_entry(&oper->entries, struct sched_entry, list);
+		end_time = next->end_time;
+	}
+
+	next->end_time = end_time;
+	taprio_set_budgets(q, oper, next);
+
+	*p_entry = next;
+	*p_next = next;
+	*p_end_time = end_time;
+}
+
 static enum hrtimer_restart advance_sched(struct hrtimer *timer)
 {
 	struct taprio_sched *q = container_of(timer, struct taprio_sched,
@@ -925,8 +991,7 @@ static enum hrtimer_restart advance_sched(struct hrtimer *timer)
 	int num_tc = netdev_get_num_tc(dev);
 	struct sched_entry *entry, *next;
 	struct Qdisc *sch = q->root;
-	ktime_t end_time;
-	int tc;
+	ktime_t end_time, now;
 
 	spin_lock(&q->current_entry_lock);
 	entry = rcu_dereference_protected(q->current_entry,
@@ -939,6 +1004,13 @@ static enum hrtimer_restart advance_sched(struct hrtimer *timer)
 	if (!oper)
 		switch_schedules(q, &admin, &oper);
 
+	if (unlikely(!oper)) {
+		spin_unlock(&q->current_entry_lock);
+		return HRTIMER_NORESTART;
+	}
+
+	now = taprio_get_time(q);
+
 	/* This can happen in two cases: 1. this is the very first run
 	 * of this function (i.e. we weren't running any schedule
 	 * previously); 2. The previous schedule just ended. The first
@@ -949,42 +1021,74 @@ static enum hrtimer_restart advance_sched(struct hrtimer *timer)
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
 	} else {
-		next = list_next_entry(entry, list);
+		taprio_advance_one_entry(q, &oper, &admin, &entry, &next,
+					 &end_time, num_tc);
 	}
 
-	end_time = ktime_add_ns(entry->end_time, next->interval);
-	end_time = min_t(ktime_t, end_time, oper->cycle_end_time);
+	if (unlikely(ktime_compare(end_time, now) <= 0)) {
+		size_t max_steps = min_t(size_t, oper->num_entries, 32);
+		size_t i;
 
-	for (tc = 0; tc < num_tc; tc++) {
-		if (next->gate_duration[tc] == oper->cycle_time)
-			next->gate_close_time[tc] = KTIME_MAX;
-		else
-			next->gate_close_time[tc] = ktime_add_ns(entry->end_time,
-								 next->gate_duration[tc]);
-	}
+		for (i = 0; i < max_steps && ktime_compare(end_time, now) <= 0; i++) {
+			entry = next;
+			taprio_advance_one_entry(q, &oper, &admin, &entry, &next,
+						 &end_time, num_tc);
+		}
 
-	if (should_change_schedules(admin, oper, end_time)) {
-		switch_schedules(q, &admin, &oper);
-		/* After changing schedules, the next entry is the first one
-		 * in the new schedule, with a pre-calculated end_time.
-		 */
-		next = list_first_entry(&oper->entries, struct sched_entry, list);
-		end_time = next->end_time;
-	}
+		if (ktime_compare(end_time, now) <= 0) {
+			ktime_t cur_start;
+			s64 diff;
+			int tc;
 
-	next->end_time = end_time;
-	taprio_set_budgets(q, oper, next);
+			if (admin && ktime_compare(sched_base_time(admin), now) <= 0)
+				switch_schedules(q, &admin, &oper);
+
+			diff = ktime_sub(now, oper->cycle_end_time);
+			if (diff >= 0) {
+				u64 cycles = div64_u64(diff, oper->cycle_time) + 1;
+
+				oper->cycle_end_time = ktime_add_ns(oper->cycle_end_time,
+								    cycles * oper->cycle_time);
+			}
+
+			cur_start = ktime_sub_ns(oper->cycle_end_time, oper->cycle_time);
+			next = list_last_entry(&oper->entries, struct sched_entry, list);
+			list_for_each_entry(entry, &oper->entries, list) {
+				ktime_t cur_end = ktime_add_ns(cur_start, entry->interval);
+
+				if (ktime_compare(cur_end, now) > 0) {
+					next = entry;
+					end_time = min_t(ktime_t, cur_end, oper->cycle_end_time);
+					next->end_time = end_time;
+					for (tc = 0; tc < num_tc; tc++) {
+						u64 dur = next->gate_duration[tc];
+
+						if (dur == oper->cycle_time)
+							next->gate_close_time[tc] = KTIME_MAX;
+						else
+							next->gate_close_time[tc] =
+								ktime_add_ns(cur_start, dur);
+					}
+					taprio_set_budgets(q, oper, next);
+					break;
+				}
+				cur_start = cur_end;
+			}
+
+			if (should_change_schedules(admin, oper, end_time)) {
+				switch_schedules(q, &admin, &oper);
+				next = list_first_entry(&oper->entries, struct sched_entry, list);
+				end_time = next->end_time;
+			}
+
+			if (unlikely(ktime_compare(end_time, now) <= 0)) {
+				end_time = ktime_add_ns(now, taprio_min_interval(q));
+				next->end_time = end_time;
+			}
+		}
+	}
 
-first_run:
 	rcu_assign_pointer(q->current_entry, next);
 	spin_unlock(&q->current_entry_lock);
 
@@ -1130,7 +1234,11 @@ static int parse_taprio_schedule(struct taprio_sched *q, struct nlattr **tb,
 				 struct sched_gate_list *new,
 				 struct netlink_ext_ack *extack)
 {
+	int min_duration = taprio_min_interval(q);
+	struct sched_entry *entry, *n;
+	s64 elapsed = 0;
 	int err = 0;
+	int i = 0;
 
 	if (tb[TCA_TAPRIO_ATTR_SCHED_SINGLE_ENTRY]) {
 		NL_SET_ERR_MSG(extack, "Adding a single entry is not supported");
@@ -1152,8 +1260,12 @@ static int parse_taprio_schedule(struct taprio_sched *q, struct nlattr **tb,
 	if (err < 0)
 		return err;
 
+	if (list_empty(&new->entries)) {
+		NL_SET_ERR_MSG(extack, "There should be at least one entry in the schedule");
+		return -EINVAL;
+	}
+
 	if (!new->cycle_time) {
-		struct sched_entry *entry;
 		ktime_t cycle = 0;
 
 		list_for_each_entry(entry, &new->entries, list)
@@ -1167,12 +1279,45 @@ static int parse_taprio_schedule(struct taprio_sched *q, struct nlattr **tb,
 		new->cycle_time = cycle;
 	}
 
-	if (new->cycle_time < new->num_entries * length_to_duration(q, ETH_ZLEN)) {
+	if (new->cycle_time < min_duration) {
 		NL_SET_ERR_MSG(extack, "'cycle_time' is too small");
 		return -EINVAL;
 	}
 
-	taprio_calculate_gate_durations(q, new);
+	list_for_each_entry_safe(entry, n, &new->entries, list) {
+		if (elapsed >= new->cycle_time) {
+			list_del(&entry->list);
+			kfree(entry);
+			new->num_entries--;
+			continue;
+		}
+
+		if (elapsed + entry->interval > new->cycle_time) {
+			entry->interval = new->cycle_time - elapsed;
+			elapsed = new->cycle_time;
+		} else {
+			elapsed += entry->interval;
+		}
+	}
+
+	if (list_empty(&new->entries)) {
+		NL_SET_ERR_MSG(extack, "There should be at least one entry in the schedule");
+		return -EINVAL;
+	}
+
+	if (elapsed < new->cycle_time) {
+		entry = list_last_entry(&new->entries, struct sched_entry, list);
+		entry->interval += new->cycle_time - elapsed;
+	}
+
+	list_for_each_entry(entry, &new->entries, list) {
+		if (entry->interval < min_duration) {
+			NL_SET_ERR_MSG(extack, "Invalid interval for schedule entry");
+			return -EINVAL;
+		}
+		entry->index = i++;
+	}
+	new->num_entries = i;
 
 	return 0;
 }
@@ -1256,7 +1401,7 @@ static void setup_first_end_time(struct taprio_sched *q,
 	/* FIXME: find a better place to do this */
 	sched->cycle_end_time = ktime_add_ns(base, cycle);
 
-	first->end_time = ktime_add_ns(base, first->interval);
+	first->end_time = ktime_add_ns(base, min_t(s64, first->interval, cycle));
 	taprio_set_budgets(q, sched, first);
 
 	for (tc = 0; tc < num_tc; tc++) {
@@ -1828,6 +1973,7 @@ static int taprio_change(struct Qdisc *sch, struct nlattr *opt,
 	struct taprio_sched *q = qdisc_priv(sch);
 	struct net_device *dev = qdisc_dev(sch);
 	struct tc_mqprio_qopt *mqprio = NULL;
+	bool tc_configured = false;
 	unsigned long flags;
 	u32 taprio_flags;
 	ktime_t start;
@@ -1897,10 +2043,25 @@ static int taprio_change(struct Qdisc *sch, struct nlattr *opt,
 		goto free_sched;
 	}
 
+	err = parse_taprio_schedule(q, tb, new_admin, extack);
+	if (err < 0)
+		goto free_sched;
+
+	if (new_admin->num_entries == 0) {
+		NL_SET_ERR_MSG(extack, "There should be at least one entry in the schedule");
+		err = -EINVAL;
+		goto free_sched;
+	}
+
+	err = taprio_parse_clockid(sch, tb, extack);
+	if (err < 0)
+		goto free_sched;
+
 	if (mqprio) {
 		err = netdev_set_num_tc(dev, mqprio->num_tc);
 		if (err)
 			goto free_sched;
+		tc_configured = true;
 		for (i = 0; i < mqprio->num_tc; i++) {
 			netdev_set_tc_queue(dev, i,
 					    mqprio->count[i],
@@ -1914,19 +2075,7 @@ static int taprio_change(struct Qdisc *sch, struct nlattr *opt,
 					       mqprio->prio_tc_map[i]);
 	}
 
-	err = parse_taprio_schedule(q, tb, new_admin, extack);
-	if (err < 0)
-		goto free_sched;
-
-	if (new_admin->num_entries == 0) {
-		NL_SET_ERR_MSG(extack, "There should be at least one entry in the schedule");
-		err = -EINVAL;
-		goto free_sched;
-	}
-
-	err = taprio_parse_clockid(sch, tb, extack);
-	if (err < 0)
-		goto free_sched;
+	taprio_calculate_gate_durations(q, new_admin);
 
 	taprio_update_queue_max_sdu(q, new_admin, stab);
 
@@ -2008,6 +2157,11 @@ static int taprio_change(struct Qdisc *sch, struct nlattr *opt,
 	spin_unlock_bh(qdisc_lock(sch));
 
 free_sched:
+	if (err && tc_configured) {
+		netdev_reset_tc(dev);
+		memset(q->cur_txq, 0, sizeof(q->cur_txq));
+	}
+
 	if (new_admin)
 		call_rcu(&new_admin->rcu, taprio_free_sched_cb);
 


base-commit: cee9395acd8043be0644b25c34bfa86623f2b935
-- 
This is an AI-generated patch subject to moderation.
Reply with '#syz upstream' to Sign-off the patch as a human author
and send it to the upstream kernel mailing lists.
Reply with '#syz reject' to reject it ('#syz unreject' to undo).

See https://goo.gle/syzbot-ai-patches for information about AI-generated patches.
You can comment on the patch as usual, syzbot will try to address
the comments and send a new version of the patch if necessary.
syzbot engineers can be reached at syzkaller@googlegroups.com.
