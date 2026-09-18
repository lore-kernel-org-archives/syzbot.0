Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 58B044B205A
	for <syzbot@lists.linux.dev>; Fri, 18 Sep 2026 10:40:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789728030; cv=none; b=YsicWKBrwDanl2ChA53zAI5+TttAHRABHOk3DmmR72SDGqyRKnNpmsrwDsnhSn4aWoPtkRuOVfnVUpyszKtEt+3ytbAvs1+r8mhuvT09+rJvmyTgU082m263rkBoioJDAxlEdBsf7vDusorOZwQBIEU427pJuYASp4oUtDj21Sg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789728030; c=relaxed/simple;
	bh=4YsbaW+vZU3p9dbTiSLCpjBDSe5wjUWiFKYwGVAoRUM=;
	h=From:To:Cc:Subject:Message-ID:MIME-Version:Content-Type:Date; b=kFVct13voKWmY8NlnoOZHrvAUiB4b21M33HTYPkea/OMIIVgLpeqGn9EMFRkPZQZQGEhelr9Q4gSbCIb6nrQJnF2N7wT9MEG+P79x/BcFKwWqlq47lUSxxJxaxXvMphHIyzFG+krf93fSysZT5gJ+V4gGMV/0PESgSQZMkAQeP8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=ljjLZCAV; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="ljjLZCAV"
Received: by smtp.kernel.org (Postfix) with UTF8SMTPSA id C018A1F00893;
	Fri, 18 Sep 2026 10:40:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789728025;
	bh=t5ey7gI6v+k8pOXZ2rzfGkuFnsafUBNAreVZpmDNqb8=;
	h=From:To:Cc:Subject:Date;
	b=ljjLZCAV/d0pFlV3ydBTsqwsaOGycFNhGIYqXGFTXhKdw05K7N3VhkU6Qu0jO2WG8
	 Bc81WWRXHrUUVbddb3x8rV2FN5Aj7uyJe6L9SFn2gZPL/pN090X2hqE4Ycr0nJ/1sz
	 0kNTB6bkXwWCoELoVyEs8NWf7Hw8L8W30gsz36CiYi4EhCFnn3ksm6c3gJQ89LgAnU
	 sWMFJ7bAqgueI+HwMlSb0goHpMTIbSN7KykT6uFqc5MZNZRSg5bnMwNSsEYXK0T4OF
	 raIpdvFYcBuO5tqSlkfziKn9WaVzBeUkaktr9iDd95Pi21oHJzFS/OTPzjyvNhtO59
	 QF5rByuXR9agA==
From: "syzbot" <syzbot@kernel.org>
To: syzkaller-upstream-moderation@googlegroups.com
Cc: krystianmkaniewski@gmail.com, syzbot@lists.linux.dev
Subject: [PATCH RFC v2] net/sched: taprio: enforce minimum interval to prevent hrtimer storms
Message-ID: <4de7b2e3-3f72-41a4-8735-67d91fc74009@mail.kernel.org>
Precedence: bulk
X-Mailing-List: syzbot@lists.linux.dev
List-Id: <syzbot.lists.linux.dev>
List-Subscribe: <mailto:syzbot+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:syzbot+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Date: Fri, 18 Sep 2026 10:40:25 +0000 (UTC)

An issue with the taprio packet scheduler allows a user to configure an
extremely small schedule interval (e.g., 127 ns). While taprio validates
that the interval is at least the time required to transmit a minimum-sized
Ethernet frame (ETH_ZLEN), on high-speed virtual interfaces like 10 Gbps
veth, this minimum duration evaluates to just 48 ns.

Because the execution time of the hrtimer callback (plus hardware interrupt
overhead) is significantly larger than 127 ns, the newly calculated
end_time in advance_sched() is already in the past by the time the
interrupt handler finishes. The hrtimer subsystem immediately fires the
timer again, trapping the CPU in a continuous stream of timer interrupts
(an hrtimer interrupt storm). This starves other threads, including the RCU
grace-period kthread, leading to an RCU stall:

rcu: INFO: rcu_preempt detected stalls on CPUs/tasks:
rcu: 	(detected by 0, t=10502 jiffies, g=15113, q=737 ncpus=2)
rcu: All QSes seen, last rcu_preempt kthread activity 10502
(4294956675-4294946173), jiffies_till_next_fqs=1, root ->qsmask 0x0
rcu: rcu_preempt kthread timer wakeup didn't happen for 10501 jiffies!
g15113 f0x2 RCU_GP_WAIT_FQS(5) ->state=0x200
rcu: 	Possible timer handling issue on cpu=1 timer-softirq=3485
rcu: rcu_preempt kthread starved for 10502 jiffies! g15113 f0x2
RCU_GP_WAIT_FQS(5) ->state=0x200 ->cpu=1
rcu: 	Unless rcu_preempt kthread gets sufficient CPU time, OOM is now
expected behavior.
...
Call Trace:
 <IRQ>
 lock_acquire+0x106/0x350 kernel/locking/lockdep.c:5868
 rcu_lock_acquire include/linux/rcupdate.h:300 [inline]
 rcu_read_lock include/linux/rcupdate.h:840 [inline]
 advance_sched+0xa04/0xc80 net/sched/sch_taprio.c:992
 __run_hrtimer kernel/time/hrtimer.c:2032 [inline]
 __hrtimer_run_queues+0x3bc/0xa10 kernel/time/hrtimer.c:2096
 hrtimer_interrupt+0x448/0x910 kernel/time/hrtimer.c:2215
 local_apic_timer_interrupt arch/x86/kernel/apic/apic.c:1051 [inline]
 __sysvec_apic_timer_interrupt+0x102/0x430 arch/x86/kernel/apic/apic.c:1068

To prevent this, enforce a minimum interval threshold during configuration
when operating in software timer-driven mode (i.e. neither txtime-assist
nor full offload is enabled). Introduce TAPRIO_MIN_INTERVAL set to 100
microseconds (100 * NSEC_PER_USEC). Rather than serving as an absolute
CPU-safety guarantee across all possible hardware and workloads, this 100
us floor acts as a nominal callback-rate policy that limits the timer
interrupt rate to at most 10,000 events per second. Hardware-assisted and
offloaded modes do not rely on this software timer and remain unaffected.

Apply this clamped minimum duration in fill_sched_entry() and
parse_taprio_schedule() for timer-driven mode to ensure that both
individual entry intervals and the overall cycle time respect this floor.
Also add and use taprio_is_timer_driven() to simplify timer-mode checks
across taprio.

Fixes: b5b73b26b3ca ("taprio: Fix allowing too small intervals")
Assisted-by: Gemini:gemini-3.8-flash syzbot
Reported-by: syzbot+e044a9b6370ed8ca9737@syzkaller.appspotmail.com
Closes: https://syzkaller.appspot.com/bug?extid=e044a9b6370ed8ca9737
Link: https://syzkaller.appspot.com/ai_job?id=aebe94be-5985-4e0f-9e09-df765e4df5bb
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
v2:
- Increased the minimum interval floor (TAPRIO_MIN_INTERVAL) from 1 us to 100 us.
- Restricted the minimum interval constraint to software timer-driven mode via a new taprio_is_timer_driven() helper.
- Used taprio_is_timer_driven() helper in taprio_start_sched() and taprio_change().
- Clarified in the commit message that the threshold represents a nominal callback-rate policy rather than an absolute safety guarantee.

v1:
https://lore.kernel.org/all/7d5b3fcb-ab75-4a18-909f-5ff072e562e1@mail.kernel.org/T/
---
diff --git a/net/sched/sch_taprio.c b/net/sched/sch_taprio.c
index 299234a5f..f399f6a4a 100644
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
@@ -1041,6 +1055,9 @@ static int fill_sched_entry(struct taprio_sched *q, struct nlattr **tb,
 	int min_duration = length_to_duration(q, ETH_ZLEN);
 	u32 interval = 0;
 
+	if (taprio_is_timer_driven(q->flags))
+		min_duration = max_t(int, min_duration, TAPRIO_MIN_INTERVAL);
+
 	if (tb[TCA_TAPRIO_SCHED_ENTRY_CMD])
 		entry->command = nla_get_u8(
 			tb[TCA_TAPRIO_SCHED_ENTRY_CMD]);
@@ -1129,6 +1146,7 @@ static int parse_taprio_schedule(struct taprio_sched *q, struct nlattr **tb,
 				 struct sched_gate_list *new,
 				 struct netlink_ext_ack *extack)
 {
+	int min_duration;
 	int err = 0;
 
 	if (tb[TCA_TAPRIO_ATTR_SCHED_SINGLE_ENTRY]) {
@@ -1166,7 +1184,11 @@ static int parse_taprio_schedule(struct taprio_sched *q, struct nlattr **tb,
 		new->cycle_time = cycle;
 	}
 
-	if (new->cycle_time < new->num_entries * length_to_duration(q, ETH_ZLEN)) {
+	min_duration = length_to_duration(q, ETH_ZLEN);
+	if (taprio_is_timer_driven(q->flags))
+		min_duration = max_t(int, min_duration, TAPRIO_MIN_INTERVAL);
+
+	if (new->cycle_time < new->num_entries * min_duration) {
 		NL_SET_ERR_MSG(extack, "'cycle_time' is too small");
 		return -EINVAL;
 	}
@@ -1274,7 +1296,7 @@ static void taprio_start_sched(struct Qdisc *sch,
 	struct taprio_sched *q = qdisc_priv(sch);
 	ktime_t expires;
 
-	if (FULL_OFFLOAD_IS_ENABLED(q->flags))
+	if (!taprio_is_timer_driven(q->flags))
 		return;
 
 	expires = hrtimer_get_expires(&q->advance_timer);
@@ -1946,8 +1968,7 @@ static int taprio_change(struct Qdisc *sch, struct nlattr *opt,
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
