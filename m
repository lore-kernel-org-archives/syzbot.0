Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 916372F12AB
	for <syzbot@lists.linux.dev>; Fri,  4 Sep 2026 12:20:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788524424; cv=none; b=WZC3RAFeyDWCGgGAp26FjYuo3VRQmaH1PxQCY/E5WnBt3y8UnadS/LY6WNIJKGIuFOXFTGSjJbg8Lrha8SNbXGND2y7DunEYK4I3tlGqD0TDSJ3Pjn8nrWIizlQKgNnmEGQlJH73GKq3W4E50muGbwGDgKtZUf8LumO90T1Aeqw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788524424; c=relaxed/simple;
	bh=bKi3/2DP6/7UH6lqgwoH2FaOknoP19uQAA+cwz8he2Y=;
	h=From:To:Cc:Subject:Message-ID:MIME-Version:Content-Type:Date; b=supCHA0P4gYEjI3G8Ow2rKsV3zkcrzG+stEfDazYnxIaz6VizeH+EYDMPk+dpnJ1HC0eg0WnOBQkff+lQ5z7KH02h1xLLw6R9YgxeYW5ZjPTgrZSQnbVtyBKs/xplZBuccwscs9HseC25N2Oi20ODwfZ42M+uPuDtgfBBLQ8Lcw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=ZZnZ/UOS; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="ZZnZ/UOS"
Received: by smtp.kernel.org (Postfix) with UTF8SMTPSA id 075D91F00A3D;
	Fri,  4 Sep 2026 12:20:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788524423;
	bh=nduB9+zn4Di93Uj6NS9Mg/lK/SouddKojBKJQfTwWj0=;
	h=From:To:Cc:Subject:Date;
	b=ZZnZ/UOS1H4+TJUY5ToJ/08ND6OZwEJRX9dgNoTLNX7zKItW+esRfrur9QfZUtPRN
	 dbCLrdZWlSmKQp0YtLNO+/Ql6eROBLqxSzL+tKj736tV+fkQSJQdp4EYFYD1kYOotN
	 AS2MHFEkkR+HO/G3K6ffhRbiKXa2WjMzuHLDSlIdabd4X9XrBpgMmGyx07LzjO26UO
	 F5JNFeqQ8j2nXkmf74LIzYY2REjUyQb5MryQ+smxB19laDDbTtYwgh9WAQaXHgIK+y
	 NBtGMLklCLbz8PZOu9IrWFVjSwQN59zQYlDNekqDG5VPZ1IJ6rEfKzzMSZOzeJrQhY
	 zQJjhbP7gDOHg==
From: "syzbot" <syzbot@kernel.org>
To: syzkaller-upstream-moderation@googlegroups.com
Cc: immersa.bartosz.chronowski@gmail.com, syzbot@lists.linux.dev
Subject: [PATCH RFC v2] net/sched: taprio: enforce minimum interval in software mode
Message-ID: <edd30c9e-6673-42a0-ab07-b7fb2bb67795@mail.kernel.org>
Precedence: bulk
X-Mailing-List: syzbot@lists.linux.dev
List-Id: <syzbot.lists.linux.dev>
List-Subscribe: <mailto:syzbot+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:syzbot+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Date: Fri,  4 Sep 2026 12:20:22 +0000 (UTC)

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

Fix this by defining TAPRIO_MIN_SW_INTERVAL_NS (10 us) and introducing
taprio_min_interval() to enforce a minimum interval in software mode for
both individual schedule entries in fill_sched_entry() and the overall
cycle_time in parse_taprio_schedule().

Fixes: 6ca6a6654225 ("taprio: Add support for setting the cycle-time manually")
Assisted-by: Gemini:gemini-3.7-flash syzbot
Reported-by: syzbot+14c6ac6811273526cfa5@syzkaller.appspotmail.com
Closes: https://syzkaller.appspot.com/bug?extid=14c6ac6811273526cfa5
Link: https://syzkaller.appspot.com/ai_job?id=2540dd3a-bcf0-4dd0-be22-164f6203df0b
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
- Enforce a minimum interval of 10 us (TAPRIO_MIN_SW_INTERVAL_NS) in software mode instead of comparing cycle_time against the sum of intervals.
- Add taprio_min_interval() helper to determine the minimum interval based on offload and txtime-assist flags.
- Use taprio_min_interval() in fill_sched_entry() and parse_taprio_schedule().

v1:
https://lore.kernel.org/all/3527dbf1-ab94-4184-8405-8552799efb71@mail.kernel.org/T/
---
diff --git a/net/sched/sch_taprio.c b/net/sched/sch_taprio.c
index 39ac5b97a..3890cdbfc 100644
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
@@ -1130,6 +1145,7 @@ static int parse_taprio_schedule(struct taprio_sched *q, struct nlattr **tb,
 				 struct sched_gate_list *new,
 				 struct netlink_ext_ack *extack)
 {
+	int min_duration = taprio_min_interval(q);
 	int err = 0;
 
 	if (tb[TCA_TAPRIO_ATTR_SCHED_SINGLE_ENTRY]) {
@@ -1167,7 +1183,7 @@ static int parse_taprio_schedule(struct taprio_sched *q, struct nlattr **tb,
 		new->cycle_time = cycle;
 	}
 
-	if (new->cycle_time < new->num_entries * length_to_duration(q, ETH_ZLEN)) {
+	if (new->cycle_time < (s64)new->num_entries * min_duration) {
 		NL_SET_ERR_MSG(extack, "'cycle_time' is too small");
 		return -EINVAL;
 	}


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
