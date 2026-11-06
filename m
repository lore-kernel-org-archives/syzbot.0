Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794005102;
	b=oFSEjIaiLX4gtwhC5L6prap69AV8eInU9AqTwNk/mVBCph9DegzQ4bspLmehnkLk+F0p
	 Po9NVS3neI7mvACQVGNKhOB2pCbGOCNPQyHFA6HppjLyEnNWV/xOW8JVDn3Uz+d5i9rKV
	 qlnUdbPQCjzyIqm9m7ZRrS2lfT+0djEnRE7UupUqBvaBF1EPtHfg/ODkDvRVRh4RfI7wx
	 h9lzE3mGYgq12sYzQpwubDJU/mvTPYdddW4Rk1eNKhAhKIxyGNTETg9L2tck08hK8TTRC
	 HoZr8Vcrc1pj6M2798p36fRbzpSyd07UKXymoAPpfNKFrMXoihNko7uPp/LvNN/hjhw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794005102;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Message-ID:MIME-Version:
	 Content-Type:Content-Transfer-Encoding:Date;
	bh=thF2O4Vu7IbBx8hUBlqIT13ZdJWnu0qeOyPpG88rQ9w=;
	b=NS936A2PG53NkH0zd3L7qHLdnAf3WbkfHAp2XjTd5r80AzZo37vPevet5jnP4WlFLCKZ
	 m4x3VoHQWs3rqHkTwNaTfUwMayUSWWZOsUG5skUZw4d9Q/cUIFUj8Be49w4smse598qON
	 iZUBAvJ5fViI1cYR+d5LY/1sLf396wr/IPQh9AkB9RHuRHK5hd3+eAd8/nA/8GUB5JIxr
	 svA+vYJzjQndHeZG1ek2bvRwOV/6ElBCCkEdxvjmFDoLalRfjaD2mrNqWddm+5raGwXp0
	 wqK0HIqNVNDu+AzU7tWmqo5BW3pO3SvqtNGzqGE3aglOL3AjyxWjv/JaHy6XzCS0ZGw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=PzaOi5v1;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with UTF8SMTPS id 9B82A606A32D
	for <syzbot@lists.linux.dev>; Fri,  6 Nov 2026 22:45:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=PzaOi5v1
Received: by smtp.kernel.org (Postfix) with UTF8SMTPSA id 091A21F0089F;
	Fri,  6 Nov 2026 22:45:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794005101;
	bh=thF2O4Vu7IbBx8hUBlqIT13ZdJWnu0qeOyPpG88rQ9w=;
	h=From:To:Cc:Subject:Date;
	b=PzaOi5v1w2NFrzezNelaxQMM9dGhGcWhkJR0Ct4kmVrScr2rA+IVfDKHXW2BW6xwY
	 mNUtBlfH6K+HMDp5ujdbnFeKoOv6p25ugY46aB5nDL83HzTyDfZW0ANqqrbrcxLbiE
	 BW1lobCo7PDjxSreZ5p9DHgD5oDWXnenUuGDmu2uvUudzUB1tpCOkc20jFDTp5i0On
	 p4Y5F8kJv/7BvkryyQU924tp/lYAVPyCkpsTPrvpbv5uXmtH3VYycT7qBwUZ6CaNcZ
	 qH8O1TQSW8hmZHklrSBOpOuAerhQ9Z8nh+H+P/ZErQ+o+MFfZ5gQsvZCuYQDqEbVRm
	 RZOfh4AEwjx0Q==
From: "syzbot" <syzbot@kernel.org>
To: syzkaller-upstream-moderation@googlegroups.com
Cc: immersa.bartosz.chronowski@gmail.com, syzbot@lists.linux.dev
Subject: [PATCH RFC v8] net/sched: taprio: enforce minimum interval in software mode
Message-ID: <6cd197ad-5fe2-4a2d-abd6-6a9903ac14d8@mail.kernel.org>
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
Date: Fri,  6 Nov 2026 22:45:00 +0000 (UTC)

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
introduce taprio_min_interval(). In software mode, each entry's duration
and cycle_time are bounded to at least taprio_min_interval() (max(ETH_ZLEN
duration, 10 us)). In steady-state operation, this ensures that entry
durations are significantly larger than the execution latency of
advance_sched(), allowing the CPU to service softirqs and advance RCU grace
periods between normal timer interrupts. For TXTIME-assist and full-offload
modes, advance_sched() does not drive schedule switching in software, so
taprio_min_interval() continues to compute length_to_duration(q, ETH_ZLEN)
without the 10 us clamp, preserving hardware offload capabilities.

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

To mitigate timer delays (e.g. from interrupt latency or preemption),
advance_sched() now enforces bounded catch-up work. If the timer fires late
such that the scheduled expiration time has already passed, advance_sched()
advances step-by-step for at most 32 entries before calling
taprio_fast_forward_sched(). The fast-forward path advances full cycles via
64-bit division and performs a single non-looping scan over the effective
entries list to locate the active entry. If the target expiration is still
not in the future, it performs at most one additional entry advance step,
and if still non-future, clamps the expiration time to at least
taprio_min_interval(q) ahead of current time. This bounds total
timer-callback work to at most 33 single-step transitions plus a
fast-forward scan over the schedule entries list, and clamps late
expirations ahead of current time, preventing advance_sched() from getting
trapped in an hrtimer interrupt loop.

Finally, parse and validate the schedule and offload parameters in
taprio_change() before modifying device traffic classes, deferring
netdev_set_num_tc() until after validation and offload configuration
succeed so error paths can cleanly roll back. In taprio_destroy(), only
reset device traffic classes if a schedule was previously active. In
addition, stage max_sdu and fp configurations locally until commit time,
pass num_tc explicitly to gate duration and max SDU calculations, and
reject empty schedules.

Fixes: 5a781ccbd19e ("tc: Add support for configuring the taprio scheduler")
Assisted-by: Gemini:gemini-4-argon Gemini:gemini-3.8-flash syzbot
Reported-by: syzbot+14c6ac6811273526cfa5@syzkaller.appspotmail.com
Closes: https://syzkaller.appspot.com/bug?extid=14c6ac6811273526cfa5
Link: https://syzkaller.appspot.com/ai_job?id=f70e5ebb-6a51-4edd-a73d-0bc0c91f0e15
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
- Narrow the commit description regarding future timer expiry guarantees.
- Factor out schedule synchronization into taprio_sync_sched_to_time() and re-check expiration against current time in the fallback path.
- Add error checking for netdev_set_num_tc() and roll back offload and traffic classes on error in taprio_change().
- Use qopt_tc_map_to_queue_mask() when mqprio is configured instead of querying device queue mapping.

v7:
- In advance_sched(), removed loops around and inside taprio_fast_forward_sched() to bound entry list scanning to a single pass.
- In advance_sched(), guaranteed strictly future timer rearming by clamping expiration to taprio_min_interval() ahead of current time if fast-forwarding still produces a past timestamp.
- In taprio_change(), deferred modifying netdev traffic classes until after offload setup succeeds, avoiding netdev state rollback on error.
- Passed num_tc explicitly to taprio_calculate_gate_durations() and taprio_update_queue_max_sdu(), and passed mqprio to taprio_enable_offload().
- In taprio_destroy(), only reset netdev traffic classes if a schedule was active.
- Fixed should_restart_cycle() to check if end_time is greater than or equal to cycle_end_time.
https://lore.kernel.org/all/dab7733a-1093-4eca-a7a7-3b62f5bd05a7@mail.kernel.org/T/

v6:
- Factor out entry gate close time and budget calculation into taprio_set_entry_state().
- Correctly compute entry start and end times on initial run and schedule switch in advance_sched().
- Loop taprio_fast_forward_sched() when expiry is in the past and remove the artificial interval clamp.
- Set advance_timer expiration under current_entry_lock in advance_sched().
- Save and restore previous netdev traffic class configuration on error in taprio_change() instead of calling netdev_reset_tc().
https://lore.kernel.org/all/bead33e5-6249-40fb-aaaf-58117e6ee7b8@mail.kernel.org/T/

v5:
- Factored out schedule fast-forward logic into taprio_fast_forward_sched().
- Clarified commit description regarding fast-forward scanning of the effective list and narrowed 10 us interval claims to steady-state operation.
- Staged max_sdu and fp configurations in taprio_change() to avoid premature state mutation before commit.
- Restored flags, clockid, and tk_offset on rollback if setup fails during initial configuration in taprio_change().
- Adjusted boundary time comparisons in find_entry_to_transmit(), is_valid_interval(), and get_packet_txtime().
https://lore.kernel.org/all/9e73068d-a591-4830-a002-b08d999679fb@mail.kernel.org/T/

v4:
- Unified effective schedule derivation in parse_taprio_schedule() by dropping out-of-bounds entries, truncating boundary-straddling entries, and padding trailing entries, ensuring all consumers operate on the identical schedule.
- Moved entry interval validation to parse_taprio_schedule() to validate effective post-truncation intervals against taprio_min_interval().
- Added bounded catch-up advancement (up to 32 entries) and fast-forward cycle calculation in advance_sched() to bound interrupt latency.
- Enforced strictly future hrtimer expiration in advance_sched() by clamping end_time to at least taprio_min_interval() ahead of the current time.
- Added cleanup logic to reset netdev traffic classes in taprio_change() if an error occurs after netdev_set_num_tc().
- Added safety checks for NULL oper in should_change_schedules() and advance_sched().
- Updated curr_intv_start boundary check in find_entry_to_transmit().
https://lore.kernel.org/all/e048bbcd-a352-43e2-bef2-a08c12b27099@mail.kernel.org/T/

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
index 39ac5b97a..b0806ea04 100644
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
@@ -117,10 +121,9 @@ struct __tc_taprio_qopt_offload {
 };
 
 static void taprio_calculate_gate_durations(struct taprio_sched *q,
-					    struct sched_gate_list *sched)
+					    struct sched_gate_list *sched,
+					    int num_tc)
 {
-	struct net_device *dev = qdisc_dev(q->root);
-	int num_tc = netdev_get_num_tc(dev);
 	struct sched_entry *entry, *cur;
 	int tc;
 
@@ -259,6 +262,17 @@ static int length_to_duration(struct taprio_sched *q, int len)
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
@@ -270,17 +284,18 @@ static int duration_to_length(struct taprio_sched *q, u64 duration)
  */
 static void taprio_update_queue_max_sdu(struct taprio_sched *q,
 					struct sched_gate_list *sched,
-					struct qdisc_size_table *stab)
+					struct qdisc_size_table *stab,
+					const u32 max_sdu_user[TC_MAX_QUEUE],
+					int num_tc)
 {
 	struct net_device *dev = qdisc_dev(q->root);
-	int num_tc = netdev_get_num_tc(dev);
 	u32 max_sdu_from_user;
 	u32 max_sdu_dynamic;
 	u32 max_sdu;
 	int tc;
 
 	for (tc = 0; tc < num_tc; tc++) {
-		max_sdu_from_user = q->max_sdu[tc] ?: U32_MAX;
+		max_sdu_from_user = max_sdu_user[tc] ?: U32_MAX;
 
 		/* TC gate never closes => keep the queueMaxSDU
 		 * selected by the user
@@ -357,7 +372,7 @@ static struct sched_entry *find_entry_to_transmit(struct sk_buff *skb,
 		curr_intv_end = get_interval_end_time(sched, admin, entry,
 						      curr_intv_start);
 
-		if (ktime_after(curr_intv_start, cycle_end))
+		if (ktime_compare(curr_intv_start, cycle_end) >= 0)
 			break;
 
 		if (!(entry->gate_mask & BIT(tc)) ||
@@ -366,10 +381,10 @@ static struct sched_entry *find_entry_to_transmit(struct sk_buff *skb,
 
 		txtime = entry->next_txtime;
 
-		if (ktime_before(txtime, time) || validate_interval) {
+		if (!ktime_after(txtime, time) || validate_interval) {
 			transmit_end_time = ktime_add_ns(time, packet_transmit_time);
-			if ((ktime_before(curr_intv_start, time) &&
-			     ktime_before(transmit_end_time, curr_intv_end)) ||
+			if ((!ktime_after(curr_intv_start, time) &&
+			     !ktime_after(transmit_end_time, curr_intv_end)) ||
 			    (ktime_after(curr_intv_start, time) && !validate_interval)) {
 				entry_found = entry;
 				*interval_start = curr_intv_start;
@@ -405,8 +420,19 @@ static bool is_valid_interval(struct sk_buff *skb, struct Qdisc *sch)
 	struct sched_entry *entry;
 
 	rcu_read_lock();
-	sched = rcu_dereference(q->oper_sched);
 	admin = rcu_dereference(q->admin_sched);
+	sched = rcu_dereference(q->oper_sched);
+
+	if (admin && !ktime_before(skb->tstamp, admin->base_time)) {
+		sched = admin;
+		admin = NULL;
+	}
+
+	/* Until the schedule starts, all the queues are open */
+	if (!sched || ktime_before(skb->tstamp, sched->base_time)) {
+		rcu_read_unlock();
+		return true;
+	}
 
 	entry = find_entry_to_transmit(skb, sch, sched, admin, skb->tstamp,
 				       &interval_start, &interval_end, true);
@@ -484,7 +510,7 @@ static long get_packet_txtime(struct sk_buff *skb, struct Qdisc *sch)
 	rcu_read_lock();
 	admin = rcu_dereference(q->admin_sched);
 	sched = rcu_dereference(q->oper_sched);
-	if (admin && ktime_after(minimum_time, admin->base_time))
+	if (admin && !ktime_before(minimum_time, admin->base_time))
 		switch_schedules(q, &admin, &sched);
 
 	/* Until the schedule starts, all the queues are open */
@@ -513,8 +539,9 @@ static long get_packet_txtime(struct sk_buff *skb, struct Qdisc *sch)
 		txtime = max_t(ktime_t, txtime, interval_start);
 
 		if (admin && admin != sched &&
-		    ktime_after(txtime, admin->base_time)) {
+		    !ktime_before(txtime, admin->base_time)) {
 			sched = admin;
+			admin = NULL;
 			sched_changed = true;
 			continue;
 		}
@@ -876,7 +903,7 @@ static bool should_restart_cycle(const struct sched_gate_list *oper,
 	if (list_is_last(&entry->list, &oper->entries))
 		return true;
 
-	if (ktime_compare(entry->end_time, oper->cycle_end_time) == 0)
+	if (ktime_compare(entry->end_time, oper->cycle_end_time) >= 0)
 		return true;
 
 	return false;
@@ -888,7 +915,7 @@ static bool should_change_schedules(const struct sched_gate_list *admin,
 {
 	ktime_t next_base_time, extension_time;
 
-	if (!admin)
+	if (!admin || !oper)
 		return false;
 
 	next_base_time = sched_base_time(admin);
@@ -916,6 +943,162 @@ static bool should_change_schedules(const struct sched_gate_list *admin,
 	return false;
 }
 
+static void taprio_set_entry_state(struct taprio_sched *q,
+				   struct sched_gate_list *oper,
+				   struct sched_entry *next,
+				   ktime_t cur_start,
+				   ktime_t end_time,
+				   int num_tc)
+{
+	int tc;
+
+	for (tc = 0; tc < num_tc; tc++) {
+		if (next->gate_duration[tc] == oper->cycle_time)
+			next->gate_close_time[tc] = KTIME_MAX;
+		else
+			next->gate_close_time[tc] = ktime_add_ns(cur_start,
+								 next->gate_duration[tc]);
+	}
+
+	next->end_time = end_time;
+	taprio_set_budgets(q, oper, next);
+}
+
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
+	ktime_t cur_start, end_time;
+	struct sched_entry *next;
+
+	if (!oper->cycle_end_time)
+		oper->cycle_end_time = ktime_add_ns(sched_base_time(oper),
+						    oper->cycle_time);
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
+	cur_start = entry->end_time;
+	end_time = ktime_add_ns(cur_start, next->interval);
+	end_time = min_t(ktime_t, end_time, oper->cycle_end_time);
+
+	if (should_change_schedules(admin, oper, end_time)) {
+		switch_schedules(q, &admin, &oper);
+		if (!oper->cycle_end_time)
+			oper->cycle_end_time = ktime_add_ns(sched_base_time(oper),
+							    oper->cycle_time);
+		cur_start = ktime_sub_ns(oper->cycle_end_time,
+					 oper->cycle_time);
+		next = list_first_entry(&oper->entries, struct sched_entry, list);
+		end_time = ktime_add_ns(cur_start, next->interval);
+		end_time = min_t(ktime_t, end_time, oper->cycle_end_time);
+		*p_admin = admin;
+		*p_oper = oper;
+	}
+
+	taprio_set_entry_state(q, oper, next, cur_start, end_time, num_tc);
+
+	*p_entry = next;
+	*p_next = next;
+	*p_end_time = end_time;
+}
+
+static void taprio_sync_sched_to_time(struct taprio_sched *q,
+				      struct sched_gate_list *sched,
+				      ktime_t now,
+				      struct sched_entry **p_next,
+				      ktime_t *p_end_time,
+				      int num_tc)
+{
+	ktime_t base = sched_base_time(sched);
+	struct sched_entry *entry, *next;
+	ktime_t cur_start, end_time;
+
+	if (ktime_compare(now, base) < 0) {
+		cur_start = base;
+		sched->cycle_end_time = ktime_add_ns(base, sched->cycle_time);
+		next = list_first_entry(&sched->entries, struct sched_entry,
+					list);
+		end_time = ktime_add_ns(cur_start, next->interval);
+		end_time = min_t(ktime_t, end_time, sched->cycle_end_time);
+	} else {
+		u64 cycles = div64_u64(ktime_sub_ns(now, base),
+				       sched->cycle_time);
+
+		cur_start = ktime_add_ns(base, cycles * sched->cycle_time);
+		sched->cycle_end_time = ktime_add_ns(cur_start,
+						     sched->cycle_time);
+		next = list_last_entry(&sched->entries, struct sched_entry,
+				       list);
+		end_time = sched->cycle_end_time;
+
+		list_for_each_entry(entry, &sched->entries, list) {
+			ktime_t cur_end = ktime_add_ns(cur_start,
+						       entry->interval);
+
+			if (list_is_last(&entry->list, &sched->entries))
+				cur_end = sched->cycle_end_time;
+			else
+				cur_end = min_t(ktime_t, cur_end,
+						sched->cycle_end_time);
+
+			if (ktime_compare(cur_end, now) > 0) {
+				next = entry;
+				end_time = cur_end;
+				break;
+			}
+			cur_start = cur_end;
+		}
+	}
+
+	taprio_set_entry_state(q, sched, next, cur_start, end_time, num_tc);
+	*p_next = next;
+	*p_end_time = end_time;
+}
+
+static void taprio_fast_forward_sched(struct taprio_sched *q,
+				      struct sched_gate_list **p_oper,
+				      struct sched_gate_list **p_admin,
+				      struct sched_entry **p_next,
+				      ktime_t *p_end_time,
+				      ktime_t now,
+				      int num_tc)
+{
+	struct sched_gate_list *oper = *p_oper;
+	struct sched_gate_list *admin = *p_admin;
+	struct sched_entry *next;
+	ktime_t end_time;
+
+	if (admin && ktime_compare(sched_base_time(admin), now) <= 0)
+		switch_schedules(q, &admin, &oper);
+
+	taprio_sync_sched_to_time(q, oper, now, &next, &end_time, num_tc);
+
+	if (should_change_schedules(admin, oper, end_time)) {
+		switch_schedules(q, &admin, &oper);
+		taprio_sync_sched_to_time(q, oper, now, &next, &end_time,
+					  num_tc);
+	}
+
+	*p_oper = oper;
+	*p_admin = admin;
+	*p_next = next;
+	*p_end_time = end_time;
+}
+
 static enum hrtimer_restart advance_sched(struct hrtimer *timer)
 {
 	struct taprio_sched *q = container_of(timer, struct taprio_sched,
@@ -925,8 +1108,7 @@ static enum hrtimer_restart advance_sched(struct hrtimer *timer)
 	int num_tc = netdev_get_num_tc(dev);
 	struct sched_entry *entry, *next;
 	struct Qdisc *sch = q->root;
-	ktime_t end_time;
-	int tc;
+	ktime_t end_time, now;
 
 	spin_lock(&q->current_entry_lock);
 	entry = rcu_dereference_protected(q->current_entry,
@@ -939,6 +1121,11 @@ static enum hrtimer_restart advance_sched(struct hrtimer *timer)
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
@@ -946,49 +1133,117 @@ static enum hrtimer_restart advance_sched(struct hrtimer *timer)
 	 * schedule initialization.
 	 */
 	if (unlikely(!entry || entry->end_time == oper->base_time)) {
-		next = list_first_entry(&oper->entries, struct sched_entry,
-					list);
-		end_time = next->end_time;
-		goto first_run;
-	}
+		ktime_t cur_start;
 
-	if (should_restart_cycle(oper, entry)) {
+		if (!oper->cycle_end_time)
+			oper->cycle_end_time = ktime_add_ns(sched_base_time(oper),
+							    oper->cycle_time);
+		cur_start = ktime_sub_ns(oper->cycle_end_time,
+					 oper->cycle_time);
 		next = list_first_entry(&oper->entries, struct sched_entry,
 					list);
-		oper->cycle_end_time = ktime_add_ns(oper->cycle_end_time,
-						    oper->cycle_time);
+		end_time = ktime_add_ns(cur_start, next->interval);
+		end_time = min_t(ktime_t, end_time, oper->cycle_end_time);
+
+		if (should_change_schedules(admin, oper, end_time)) {
+			switch_schedules(q, &admin, &oper);
+			if (!oper->cycle_end_time)
+				oper->cycle_end_time = ktime_add_ns(sched_base_time(oper),
+								    oper->cycle_time);
+			cur_start = ktime_sub_ns(oper->cycle_end_time,
+						 oper->cycle_time);
+			next = list_first_entry(&oper->entries,
+						struct sched_entry, list);
+			end_time = ktime_add_ns(cur_start, next->interval);
+			end_time = min_t(ktime_t, end_time,
+					 oper->cycle_end_time);
+		}
+
+		taprio_set_entry_state(q, oper, next, cur_start, end_time,
+				       num_tc);
 	} else {
-		next = list_next_entry(entry, list);
+		taprio_advance_one_entry(q, &oper, &admin, &entry, &next,
+					 &end_time, num_tc);
 	}
 
-	end_time = ktime_add_ns(entry->end_time, next->interval);
-	end_time = min_t(ktime_t, end_time, oper->cycle_end_time);
+	now = taprio_get_time(q);
+	if (unlikely(ktime_compare(end_time, now) <= 0)) {
+		size_t max_steps = min_t(size_t, oper->num_entries, 32);
+		size_t i;
+
+		for (i = 0; i < max_steps && ktime_compare(end_time, now) <= 0; i++) {
+			entry = next;
+			taprio_advance_one_entry(q, &oper, &admin, &entry, &next,
+						 &end_time, num_tc);
+		}
 
-	for (tc = 0; tc < num_tc; tc++) {
-		if (next->gate_duration[tc] == oper->cycle_time)
-			next->gate_close_time[tc] = KTIME_MAX;
-		else
-			next->gate_close_time[tc] = ktime_add_ns(entry->end_time,
-								 next->gate_duration[tc]);
+		now = taprio_get_time(q);
+		if (ktime_compare(end_time, now) <= 0) {
+			taprio_fast_forward_sched(q, &oper, &admin, &next,
+						  &end_time, now, num_tc);
+			now = taprio_get_time(q);
+			if (unlikely(ktime_compare(end_time, now) <= 0)) {
+				entry = next;
+				taprio_advance_one_entry(q, &oper, &admin,
+							 &entry, &next,
+							 &end_time, num_tc);
+			}
+		}
 	}
 
-	if (should_change_schedules(admin, oper, end_time)) {
-		switch_schedules(q, &admin, &oper);
-		/* After changing schedules, the next entry is the first one
-		 * in the new schedule, with a pre-calculated end_time.
-		 */
-		next = list_first_entry(&oper->entries, struct sched_entry, list);
-		end_time = next->end_time;
-	}
+	now = taprio_get_time(q);
+	if (unlikely(ktime_compare(end_time, now) <= 0)) {
+		ktime_t fallback_end = ktime_add_ns(now,
+						    taprio_min_interval(q));
+
+		if (should_change_schedules(admin, oper, fallback_end)) {
+			switch_schedules(q, &admin, &oper);
+			taprio_sync_sched_to_time(q, oper, now, &next,
+						  &end_time, num_tc);
+		} else {
+			s64 diff;
+
+			end_time = fallback_end;
+			if (!oper->cycle_end_time)
+				oper->cycle_end_time =
+					ktime_add_ns(sched_base_time(oper),
+						     oper->cycle_time);
+			diff = ktime_sub(end_time, oper->cycle_end_time);
+			if (diff > 0) {
+				u64 cycles = div64_u64(diff +
+						       oper->cycle_time - 1,
+						       oper->cycle_time);
+
+				oper->cycle_end_time =
+					ktime_add_ns(oper->cycle_end_time,
+						     cycles * oper->cycle_time);
+			}
+			taprio_set_entry_state(q, oper, next, now,
+					       end_time, num_tc);
+		}
 
-	next->end_time = end_time;
-	taprio_set_budgets(q, oper, next);
+		now = taprio_get_time(q);
+		if (unlikely(ktime_compare(end_time, now) <= 0)) {
+			s64 diff;
 
-first_run:
-	rcu_assign_pointer(q->current_entry, next);
-	spin_unlock(&q->current_entry_lock);
+			end_time = ktime_add_ns(now, taprio_min_interval(q));
+			diff = ktime_sub(end_time, oper->cycle_end_time);
+			if (diff > 0) {
+				u64 cycles = div64_u64(diff +
+						       oper->cycle_time - 1,
+						       oper->cycle_time);
 
+				oper->cycle_end_time =
+					ktime_add_ns(oper->cycle_end_time,
+						     cycles * oper->cycle_time);
+			}
+			next->end_time = end_time;
+		}
+	}
+
+	rcu_assign_pointer(q->current_entry, next);
 	hrtimer_set_expires(&q->advance_timer, end_time);
+	spin_unlock(&q->current_entry_lock);
 
 	rcu_read_lock();
 	__netif_schedule(sch);
@@ -1130,7 +1385,11 @@ static int parse_taprio_schedule(struct taprio_sched *q, struct nlattr **tb,
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
@@ -1152,8 +1411,12 @@ static int parse_taprio_schedule(struct taprio_sched *q, struct nlattr **tb,
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
@@ -1167,12 +1430,45 @@ static int parse_taprio_schedule(struct taprio_sched *q, struct nlattr **tb,
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
@@ -1256,7 +1552,7 @@ static void setup_first_end_time(struct taprio_sched *q,
 	/* FIXME: find a better place to do this */
 	sched->cycle_end_time = ktime_add_ns(base, cycle);
 
-	first->end_time = ktime_add_ns(base, first->interval);
+	first->end_time = ktime_add_ns(base, min_t(s64, first->interval, cycle));
 	taprio_set_budgets(q, sched, first);
 
 	for (tc = 0; tc < num_tc; tc++) {
@@ -1349,11 +1645,13 @@ static int taprio_dev_notifier(struct notifier_block *nb, unsigned long event,
 		rcu_read_lock();
 		oper = rcu_dereference(q->oper_sched);
 		if (oper)
-			taprio_update_queue_max_sdu(q, oper, stab);
+			taprio_update_queue_max_sdu(q, oper, stab, q->max_sdu,
+						    netdev_get_num_tc(dev));
 
 		admin = rcu_dereference(q->admin_sched);
 		if (admin)
-			taprio_update_queue_max_sdu(q, admin, stab);
+			taprio_update_queue_max_sdu(q, admin, stab, q->max_sdu,
+						    netdev_get_num_tc(dev));
 		rcu_read_unlock();
 
 		break;
@@ -1456,10 +1754,29 @@ static u32 tc_map_to_queue_mask(struct net_device *dev, u32 tc_mask)
 	return queue_mask;
 }
 
+static u32 qopt_tc_map_to_queue_mask(const struct tc_mqprio_qopt *qopt,
+				     u32 tc_mask)
+{
+	u32 i, queue_mask = 0;
+
+	for (i = 0; i < qopt->num_tc; i++) {
+		u16 offset = qopt->offset[i];
+		u16 count = qopt->count[i];
+
+		if (!(tc_mask & BIT(i)))
+			continue;
+
+		queue_mask |= GENMASK(offset + count - 1, offset);
+	}
+
+	return queue_mask;
+}
+
 static void taprio_sched_to_offload(struct net_device *dev,
 				    struct sched_gate_list *sched,
 				    struct tc_taprio_qopt_offload *offload,
-				    const struct tc_taprio_caps *caps)
+				    const struct tc_taprio_caps *caps,
+				    bool has_mqprio)
 {
 	struct sched_entry *entry;
 	int i = 0;
@@ -1474,8 +1791,10 @@ static void taprio_sched_to_offload(struct net_device *dev,
 		e->command = entry->command;
 		e->interval = entry->interval;
 		if (caps->gate_mask_per_txq)
-			e->gate_mask = tc_map_to_queue_mask(dev,
-							    entry->gate_mask);
+			e->gate_mask = has_mqprio ?
+				qopt_tc_map_to_queue_mask(&offload->mqprio.qopt,
+							  entry->gate_mask) :
+				tc_map_to_queue_mask(dev, entry->gate_mask);
 		else
 			e->gate_mask = entry->gate_mask;
 
@@ -1516,6 +1835,9 @@ static void taprio_cleanup_broken_mqprio(struct taprio_sched *q)
 static int taprio_enable_offload(struct net_device *dev,
 				 struct taprio_sched *q,
 				 struct sched_gate_list *sched,
+				 const struct tc_mqprio_qopt *mqprio,
+				 const u32 max_sdu[TC_MAX_QUEUE],
+				 u32 fp[TC_QOPT_MAX_QUEUE],
 				 struct netlink_ext_ack *extack)
 {
 	const struct net_device_ops *ops = dev->netdev_ops;
@@ -1534,7 +1856,7 @@ static int taprio_enable_offload(struct net_device *dev,
 
 	if (!caps.supports_queue_max_sdu) {
 		for (tc = 0; tc < TC_MAX_QUEUE; tc++) {
-			if (q->max_sdu[tc]) {
+			if (max_sdu[tc]) {
 				NL_SET_ERR_MSG_MOD(extack,
 						   "Device does not handle queueMaxSDU");
 				return -EOPNOTSUPP;
@@ -1550,13 +1872,16 @@ static int taprio_enable_offload(struct net_device *dev,
 	}
 	offload->cmd = TAPRIO_CMD_REPLACE;
 	offload->extack = extack;
-	mqprio_qopt_reconstruct(dev, &offload->mqprio.qopt);
+	if (mqprio)
+		offload->mqprio.qopt = *mqprio;
+	else
+		mqprio_qopt_reconstruct(dev, &offload->mqprio.qopt);
 	offload->mqprio.extack = extack;
-	taprio_sched_to_offload(dev, sched, offload, &caps);
-	mqprio_fp_to_offload(q->fp, &offload->mqprio);
+	taprio_sched_to_offload(dev, sched, offload, &caps, mqprio != NULL);
+	mqprio_fp_to_offload(fp, &offload->mqprio);
 
 	for (tc = 0; tc < TC_MAX_QUEUE; tc++)
-		offload->max_sdu[tc] = q->max_sdu[tc];
+		offload->max_sdu[tc] = max_sdu[tc];
 
 	err = ops->ndo_setup_tc(dev, TC_SETUP_QDISC_TAPRIO, offload);
 	if (err < 0) {
@@ -1747,14 +2072,14 @@ static int taprio_parse_tc_entry(struct Qdisc *sch,
 
 static int taprio_parse_tc_entries(struct Qdisc *sch,
 				   struct nlattr *opt,
+				   u32 max_sdu[TC_MAX_QUEUE],
+				   u32 fp[TC_QOPT_MAX_QUEUE],
 				   struct netlink_ext_ack *extack)
 {
 	struct taprio_sched *q = qdisc_priv(sch);
 	struct net_device *dev = qdisc_dev(sch);
-	u32 max_sdu[TC_QOPT_MAX_QUEUE];
 	bool have_preemption = false;
 	unsigned long seen_tcs = 0;
-	u32 fp[TC_QOPT_MAX_QUEUE];
 	struct nlattr *n;
 	int tc, rem;
 	int err = 0;
@@ -1772,8 +2097,6 @@ static int taprio_parse_tc_entries(struct Qdisc *sch,
 	}
 
 	for (tc = 0; tc < TC_QOPT_MAX_QUEUE; tc++) {
-		WRITE_ONCE(q->max_sdu[tc], max_sdu[tc]);
-		WRITE_ONCE(q->fp[tc], fp[tc]);
 		if (fp[tc] != TC_FP_EXPRESS)
 			have_preemption = true;
 	}
@@ -1792,7 +2115,7 @@ static int taprio_parse_tc_entries(struct Qdisc *sch,
 		}
 	}
 
-	return err;
+	return 0;
 }
 
 static int taprio_mqprio_cmp(const struct net_device *dev,
@@ -1823,15 +2146,28 @@ static int taprio_change(struct Qdisc *sch, struct nlattr *opt,
 			 struct netlink_ext_ack *extack)
 {
 	struct qdisc_size_table *stab = rtnl_dereference(sch->stab);
+	struct sched_gate_list *oper, *admin, *new_admin = NULL;
 	struct nlattr *tb[TCA_TAPRIO_ATTR_MAX + 1] = { };
-	struct sched_gate_list *oper, *admin, *new_admin;
 	struct taprio_sched *q = qdisc_priv(sch);
 	struct net_device *dev = qdisc_dev(sch);
 	struct tc_mqprio_qopt *mqprio = NULL;
+	u32 max_sdu[TC_MAX_QUEUE] = { };
+	u32 fp[TC_QOPT_MAX_QUEUE] = { };
+	bool initial_setup, tc_configured = false;
+	enum tk_offsets old_tk_offset;
+	int old_clockid, num_tc, i, err;
 	unsigned long flags;
 	u32 taprio_flags;
+	u32 old_flags;
 	ktime_t start;
-	int i, err;
+
+	oper = rtnl_dereference(q->oper_sched);
+	admin = rtnl_dereference(q->admin_sched);
+	initial_setup = (!oper && !admin);
+
+	old_flags = q->flags;
+	old_clockid = q->clockid;
+	old_tk_offset = q->tk_offset;
 
 	err = nla_parse_nested_deprecated(tb, TCA_TAPRIO_ATTR_MAX, opt,
 					  taprio_policy, extack);
@@ -1866,54 +2202,44 @@ static int taprio_change(struct Qdisc *sch, struct nlattr *opt,
 		WRITE_ONCE(q->flags, taprio_flags);
 	}
 
+	if (tb[TCA_TAPRIO_ATTR_TXTIME_DELAY]) {
+		if (!TXTIME_ASSIST_IS_ENABLED(q->flags)) {
+			NL_SET_ERR_MSG_MOD(extack,
+					   "txtime-delay can only be set when txtime-assist mode is enabled");
+			err = -EINVAL;
+			goto free_sched;
+		}
+	}
+
 	/* Needed for length_to_duration() during netlink attribute parsing */
 	taprio_set_picos_per_byte(dev, q, extack);
 
 	err = taprio_parse_mqprio_opt(dev, mqprio, extack, q->flags);
 	if (err < 0)
-		return err;
+		goto free_sched;
 
-	err = taprio_parse_tc_entries(sch, opt, extack);
+	err = taprio_parse_tc_entries(sch, opt, max_sdu, fp, extack);
 	if (err)
-		return err;
+		goto free_sched;
 
 	new_admin = kzalloc_obj(*new_admin);
 	if (!new_admin) {
 		NL_SET_ERR_MSG(extack, "Not enough memory for a new schedule");
-		return -ENOMEM;
+		err = -ENOMEM;
+		goto free_sched;
 	}
 	INIT_LIST_HEAD(&new_admin->entries);
 
-	oper = rtnl_dereference(q->oper_sched);
-	admin = rtnl_dereference(q->admin_sched);
-
 	/* no changes - no new mqprio settings */
 	if (!taprio_mqprio_cmp(dev, mqprio))
 		mqprio = NULL;
 
-	if (mqprio && (oper || admin)) {
+	if (mqprio && !initial_setup) {
 		NL_SET_ERR_MSG(extack, "Changing the traffic mapping of a running schedule is not supported");
 		err = -ENOTSUPP;
 		goto free_sched;
 	}
 
-	if (mqprio) {
-		err = netdev_set_num_tc(dev, mqprio->num_tc);
-		if (err)
-			goto free_sched;
-		for (i = 0; i < mqprio->num_tc; i++) {
-			netdev_set_tc_queue(dev, i,
-					    mqprio->count[i],
-					    mqprio->offset[i]);
-			q->cur_txq[i] = mqprio->offset[i];
-		}
-
-		/* Always use supplied priority mappings */
-		for (i = 0; i <= TC_BITMASK; i++)
-			netdev_set_prio_tc_map(dev, i,
-					       mqprio->prio_tc_map[i]);
-	}
-
 	err = parse_taprio_schedule(q, tb, new_admin, extack);
 	if (err < 0)
 		goto free_sched;
@@ -1928,27 +2254,45 @@ static int taprio_change(struct Qdisc *sch, struct nlattr *opt,
 	if (err < 0)
 		goto free_sched;
 
-	taprio_update_queue_max_sdu(q, new_admin, stab);
+	num_tc = mqprio ? mqprio->num_tc : netdev_get_num_tc(dev);
+
+	taprio_calculate_gate_durations(q, new_admin, num_tc);
+
+	taprio_update_queue_max_sdu(q, new_admin, stab, max_sdu, num_tc);
 
 	if (FULL_OFFLOAD_IS_ENABLED(q->flags))
-		err = taprio_enable_offload(dev, q, new_admin, extack);
+		err = taprio_enable_offload(dev, q, new_admin, mqprio, max_sdu,
+					    fp, extack);
 	else
 		err = taprio_disable_offload(dev, q, extack);
 	if (err)
 		goto free_sched;
 
+	if (mqprio) {
+		err = netdev_set_num_tc(dev, mqprio->num_tc);
+		if (err)
+			goto free_sched;
+		tc_configured = true;
+		for (i = 0; i < mqprio->num_tc; i++) {
+			netdev_set_tc_queue(dev, i,
+					    mqprio->count[i],
+					    mqprio->offset[i]);
+			q->cur_txq[i] = mqprio->offset[i];
+		}
+
+		/* Always use supplied priority mappings */
+		for (i = 0; i <= TC_BITMASK; i++)
+			netdev_set_prio_tc_map(dev, i,
+					       mqprio->prio_tc_map[i]);
+	}
+
 	/* Protects against enqueue()/dequeue() */
 	spin_lock_bh(qdisc_lock(sch));
 
-	if (tb[TCA_TAPRIO_ATTR_TXTIME_DELAY]) {
-		if (!TXTIME_ASSIST_IS_ENABLED(q->flags)) {
-			NL_SET_ERR_MSG_MOD(extack, "txtime-delay can only be set when txtime-assist mode is enabled");
-			err = -EINVAL;
-			goto unlock;
-		}
-
-		WRITE_ONCE(q->txtime_delay,
-			   nla_get_u32(tb[TCA_TAPRIO_ATTR_TXTIME_DELAY]));
+	err = taprio_get_start_time(sch, new_admin, &start);
+	if (err < 0) {
+		NL_SET_ERR_MSG(extack, "Internal error: failed get start time");
+		goto unlock;
 	}
 
 	if (!TXTIME_ASSIST_IS_ENABLED(q->flags) &&
@@ -1957,11 +2301,14 @@ static int taprio_change(struct Qdisc *sch, struct nlattr *opt,
 		hrtimer_setup(&q->advance_timer, advance_sched, q->clockid, HRTIMER_MODE_ABS);
 	}
 
-	err = taprio_get_start_time(sch, new_admin, &start);
-	if (err < 0) {
-		NL_SET_ERR_MSG(extack, "Internal error: failed get start time");
-		goto unlock;
-	}
+	if (tb[TCA_TAPRIO_ATTR_TXTIME_DELAY])
+		WRITE_ONCE(q->txtime_delay,
+			   nla_get_u32(tb[TCA_TAPRIO_ATTR_TXTIME_DELAY]));
+
+	for (i = 0; i < TC_MAX_QUEUE; i++)
+		WRITE_ONCE(q->max_sdu[i], max_sdu[i]);
+	for (i = 0; i < TC_QOPT_MAX_QUEUE; i++)
+		WRITE_ONCE(q->fp[i], fp[i]);
 
 	setup_txtime(q, new_admin, start);
 
@@ -2008,6 +2355,18 @@ static int taprio_change(struct Qdisc *sch, struct nlattr *opt,
 	spin_unlock_bh(qdisc_lock(sch));
 
 free_sched:
+	if (err) {
+		if (initial_setup) {
+			if (q->offloaded)
+				taprio_disable_offload(dev, q, NULL);
+			if (tc_configured)
+				netdev_reset_tc(dev);
+		}
+		WRITE_ONCE(q->flags, old_flags);
+		q->clockid = old_clockid;
+		WRITE_ONCE(q->tk_offset, old_tk_offset);
+	}
+
 	if (new_admin)
 		call_rcu(&new_admin->rcu, taprio_free_sched_cb);
 
@@ -2054,11 +2413,12 @@ static void taprio_destroy(struct Qdisc *sch)
 	}
 	q->qdiscs = NULL;
 
-	netdev_reset_tc(dev);
-
 	oper = rtnl_dereference(q->oper_sched);
 	admin = rtnl_dereference(q->admin_sched);
 
+	if (oper || admin)
+		netdev_reset_tc(dev);
+
 	if (oper)
 		call_rcu(&oper->rcu, taprio_free_sched_cb);
 


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
