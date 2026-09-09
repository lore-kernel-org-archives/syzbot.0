Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7DCD43CFF49
	for <syzbot@lists.linux.dev>; Wed,  9 Sep 2026 15:57:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788969464; cv=none; b=JK5KFr3e0sK1tUWMtUo6uqdjovHvjBtjpepvXSt6xgxFB5O5xfyzwlzDz44E6iK9HbFABjCfwo7K6ORNfZ5zVf78zGbtffHHSIzrMENvq9FltRp+zGAQVriFP1SsGyGojv12VmYMINTYT74zvmKt7V0YSAa8qfiMLqHeeTD6B54=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788969464; c=relaxed/simple;
	bh=rqk7raGVRdzaw+cM722EZwHzCsWytApU2GGiicGTPjw=;
	h=From:To:Cc:Subject:Message-ID:MIME-Version:Content-Type:Date; b=XNFpAoORFeZeyk9cz6LoM3INNSCjVtEd9Otgl8vKU1AOJ1rA3enmdbpSuCVKU/Kma+u9tf1aDDw2ppwFywANSTCsw6cHWA0XdqH94FDrL5+VkmDmfW4sWm2BPds95vdJnoLKqZMROHzE2L3QWeFLzsE2baeKwfMg3Xy31JbyjJA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=adu2yy+f; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="adu2yy+f"
Received: by smtp.kernel.org (Postfix) with UTF8SMTPSA id 02F881F00A3A;
	Wed,  9 Sep 2026 15:57:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788969462;
	bh=VqbVlhIFDrSsEE1EnEjcMZaq1xVRJGgVCQanshlz+RY=;
	h=From:To:Cc:Subject:Date;
	b=adu2yy+fdTNt/vCNv5RDF3KYgUstFAJD+v5uguCd3Kncj93N9kOBh8W5QjcMRLIUZ
	 dRkMylMPzZFpSQ0kuNPE8VjN0JqyhSJPBECw2iahDoMesR/ycRHlEu3GL/65VRZ7ac
	 iq3jttlpEDXD5eswJ21Eo0osiLeIWuZMlczN4ahOXx3lEngva23+2arcgtkrWtEOvm
	 aD1f1PHvuq8rgOAqYiU1g829l34axKT5cbRkLHIeI4HMTpqTtmj5WSFBAqieDXq6am
	 vSMkU7UEVO9y1pK7ihkX/T6M0QSDxTLDuMte02X2Ht6wx0Q/CfdH5fIpAjOUg8VpS6
	 tXqS/2C1PV2YA==
From: "syzbot" <syzbot@kernel.org>
To: syzkaller-upstream-moderation@googlegroups.com
Cc: immersa.bartosz.chronowski@gmail.com, syzbot@lists.linux.dev
Subject: [PATCH RFC v3] net/sched: taprio: enforce minimum interval in software mode
Message-ID: <5a7fa927-7ed9-4c7b-82b8-97cb8fdadfc9@mail.kernel.org>
Precedence: bulk
X-Mailing-List: syzbot@lists.linux.dev
List-Id: <syzbot.lists.linux.dev>
List-Subscribe: <mailto:syzbot+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:syzbot+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Date: Wed,  9 Sep 2026 15:57:41 +0000 (UTC)

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
forward progress, service softirqs, and advance RCU grace periods.

Enforce this lower bound across all effective intervals that
advance_sched() can schedule:
- Individual schedule entries validated via fill_sched_entry() must be at
least taprio_min_interval().
- The overall cycle_time must be at least taprio_min_interval().
- When an explicit cycle_time is configured that truncates a schedule
entry, the effective remaining duration (cycle_time - elapsed) must also be
at least taprio_min_interval() in parse_taprio_schedule(), preventing a
sub-10us trailing interval before cycle wrap-around.
- In setup_first_end_time(), clamp the initial entry's expiration using
min_t(s64, first->interval, cycle) to ensure the initial timer interval
respects explicit-cycle truncation.

For TXTIME-assist and full-offload modes, advance_sched() does not drive
schedule switching in software. In these modes, taprio_min_interval()
continues to compute length_to_duration(q, ETH_ZLEN) without the 10 us
clamp. This preserves existing offload arithmetic, ensuring that schedule
intervals and cycle times remain bounded by the transmission time of a
minimum Ethernet frame (60 bytes) without restricting hardware-assisted
schedules.

Finally, validate the schedule in taprio_change() before calling
netdev_set_num_tc() so that invalid configurations are rejected before
altering netdev traffic classes, move taprio_calculate_gate_durations()
after traffic classes are set, and reject empty schedules.

Fixes: 6ca6a6654225 ("taprio: Add support for setting the cycle-time manually")
Assisted-by: Gemini:gemini-3.8-flash syzbot
Reported-by: syzbot+14c6ac6811273526cfa5@syzkaller.appspotmail.com
Closes: https://syzkaller.appspot.com/bug?extid=14c6ac6811273526cfa5
Link: https://syzkaller.appspot.com/ai_job?id=f336f3a5-99f4-4c2c-a2cc-49ef9348bf54
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
v3:
- Ensure schedule entries truncated by an explicit cycle_time meet min_duration in parse_taprio_schedule()
- Clamp first entry end_time to cycle_time in setup_first_end_time()
- Parse and validate schedule before applying netdev traffic class configuration in taprio_change()
- Reject schedules with no entries in parse_taprio_schedule()
- Update commit message to detail the serviceability guarantee, cycle truncation handling, and offload mode arithmetic

v2:
- Enforce a minimum interval of 10 us (TAPRIO_MIN_SW_INTERVAL_NS) in software mode instead of comparing cycle_time against the sum of intervals.
- Add taprio_min_interval() helper to determine the minimum interval based on offload and txtime-assist flags.
- Use taprio_min_interval() in fill_sched_entry() and parse_taprio_schedule().
https://lore.kernel.org/all/edd30c9e-6673-42a0-ab07-b7fb2bb67795@mail.kernel.org/T/

v1:
https://lore.kernel.org/all/3527dbf1-ab94-4184-8405-8552799efb71@mail.kernel.org/T/
---
diff --git a/net/sched/sch_taprio.c b/net/sched/sch_taprio.c
index 39ac5b97a..28ce7cb40 100644
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
@@ -1039,7 +1054,7 @@ static int fill_sched_entry(struct taprio_sched *q, struct nlattr **tb,
 			    struct sched_entry *entry,
 			    struct netlink_ext_ack *extack)
 {
-	int min_duration = length_to_duration(q, ETH_ZLEN);
+	int min_duration = taprio_min_interval(q);
 	u32 interval = 0;
 
 	if (tb[TCA_TAPRIO_SCHED_ENTRY_CMD])
@@ -1130,6 +1145,9 @@ static int parse_taprio_schedule(struct taprio_sched *q, struct nlattr **tb,
 				 struct sched_gate_list *new,
 				 struct netlink_ext_ack *extack)
 {
+	int min_duration = taprio_min_interval(q);
+	struct sched_entry *entry;
+	s64 elapsed = 0;
 	int err = 0;
 
 	if (tb[TCA_TAPRIO_ATTR_SCHED_SINGLE_ENTRY]) {
@@ -1152,8 +1170,12 @@ static int parse_taprio_schedule(struct taprio_sched *q, struct nlattr **tb,
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
@@ -1167,12 +1189,28 @@ static int parse_taprio_schedule(struct taprio_sched *q, struct nlattr **tb,
 		new->cycle_time = cycle;
 	}
 
-	if (new->cycle_time < new->num_entries * length_to_duration(q, ETH_ZLEN)) {
+	if (new->cycle_time < min_duration) {
 		NL_SET_ERR_MSG(extack, "'cycle_time' is too small");
 		return -EINVAL;
 	}
 
-	taprio_calculate_gate_durations(q, new);
+	list_for_each_entry(entry, &new->entries, list) {
+		s64 remaining;
+
+		if (elapsed >= new->cycle_time)
+			break;
+
+		remaining = new->cycle_time - elapsed;
+		if (entry->interval > remaining) {
+			if (remaining < min_duration) {
+				NL_SET_ERR_MSG(extack, "'cycle_time' is too small");
+				return -EINVAL;
+			}
+			break;
+		}
+
+		elapsed += entry->interval;
+	}
 
 	return 0;
 }
@@ -1256,7 +1294,7 @@ static void setup_first_end_time(struct taprio_sched *q,
 	/* FIXME: find a better place to do this */
 	sched->cycle_end_time = ktime_add_ns(base, cycle);
 
-	first->end_time = ktime_add_ns(base, first->interval);
+	first->end_time = ktime_add_ns(base, min_t(s64, first->interval, cycle));
 	taprio_set_budgets(q, sched, first);
 
 	for (tc = 0; tc < num_tc; tc++) {
@@ -1897,6 +1935,20 @@ static int taprio_change(struct Qdisc *sch, struct nlattr *opt,
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
@@ -1914,19 +1966,7 @@ static int taprio_change(struct Qdisc *sch, struct nlattr *opt,
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
