Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CF5CC37998C
	for <syzbot@lists.linux.dev>; Sun,  2 Aug 2026 22:41:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785710502; cv=none; b=G6pZUveO0PjYWVwS6YuzSXQ9gWcfk0C9pRbtM8k0fiZl4IDVVWVv2KuXucDQ7ziQxsJ+2WSR+WCAcEK8l5Oq3JaI4oaT/OSlxtmc6KxcFFbH4YUxNNi0QZmU91YlbYD7ULndgaTOToFj5Ph3NBqda2Zfb/zVhqTruOmAvgO25mc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785710502; c=relaxed/simple;
	bh=xsduuTbNE9K++pUks2f/yjgsaeoOMJlRBSaKcfcDRoY=;
	h=From:To:Cc:Subject:Message-ID:MIME-Version:Content-Type:Date; b=Bkof+l+kAdrnLQUwo2MkydaTIC9IO0syVaMvWwETqbp3aupAqcCp47gf9iLSRdH9bp1HZlkPdtfLHsbBwHtcgsMpHHyvH/mVGgnuwIS4j9zPATp5YjP3kA4LtZuXm41EvnaDD+QI1P5hY2CvLmBRdpQG9QV5Y+4EDlh765On3k4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=G4x5Yw8Y; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="G4x5Yw8Y"
Received: by smtp.kernel.org (Postfix) with UTF8SMTPSA id 8767A1F000E9;
	Sun,  2 Aug 2026 22:41:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1785710500;
	bh=6eUrIynzEwQUkcxuSEB4BqJPj4wVnBStyIj7tAcmtmQ=;
	h=From:To:Cc:Subject:Date;
	b=G4x5Yw8YXp8SYCJAAC9HmjvwU+z2FZGLa6dSePe35bxf0qsYta4AH/d7CnrDWibs0
	 Ri6WMkZOofATAVB4tR63XBw4bPFJzVr8F69TeqPdZ31O+rxiy44UwPFAHfj2cltIvZ
	 rtdOlJt6OWq3oPYzWkrMoEGy2c2BFLW0xhTQy9IPg8rCLDGQzZ7jJ5K80mgN0+OGON
	 emLB57Hgpg/Cv3sZUwroKJNiSdDaT/wHtreUq7OsYIRJ9wit+6jIHU/TdYv4kSH9e6
	 cX9frGB9eIrY2rfxG/A7VxGAJmwBnrlLwoRKNWAkYkVv4eFJ22UhcHLZsvaxOr8H6+
	 dxV1HD8FO//sQ==
From: "syzbot" <syzbot@kernel.org>
To: syzkaller-upstream-moderation@googlegroups.com
Cc: syzbot@lists.linux.dev
Subject: [PATCH RFC] net/sched: taprio: prevent infinite loop in advance_sched()
Message-ID: <160181c7-1e1c-4541-8bf1-a7df53fe5d7b@mail.kernel.org>
Precedence: bulk
X-Mailing-List: syzbot@lists.linux.dev
List-Id: <syzbot.lists.linux.dev>
List-Subscribe: <mailto:syzbot+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:syzbot+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Date: Sun,  2 Aug 2026 22:41:40 +0000 (UTC)

When hardware offload is not used, the taprio qdisc uses a software hrtimer
(`q->advance_timer`) to advance its schedule. The timer callback,
`advance_sched()`, calculates the next expiration time by adding the
schedule entry's interval to the current entry's end time.

If a schedule is configured with an extremely small interval (e.g., 1
microsecond), the execution time of `advance_sched()` and the surrounding
hrtimer interrupt overhead can exceed the interval itself. When this
happens, the newly programmed expiration time is already in the past. The
hrtimer subsystem (`__hrtimer_run_queues()`) then attempts to catch up by
repeatedly invoking the timer callback. Because each invocation takes
longer than the tiny interval, the catch-up process diverges, leading to an
infinite loop that starves the CPU and triggers an RCU stall:

rcu: INFO: rcu_preempt detected stalls on CPUs/tasks:
rcu: 	1-...!: (1 GPs behind) idle=c50c/1/0x4000000000000000
softirq=21413/21531 fqs=770
Call Trace:
 <IRQ>
 advance_sched+0xe4/0xc80 net/sched/sch_taprio.c:932
 __run_hrtimer kernel/time/hrtimer.c:2032 [inline]
 __hrtimer_run_queues+0x3bc/0xa10 kernel/time/hrtimer.c:2096
 hrtimer_interrupt+0x448/0x910 kernel/time/hrtimer.c:2215
 local_apic_timer_interrupt arch/x86/kernel/apic/apic.c:1051 [inline]
 __sysvec_apic_timer_interrupt+0x102/0x430 arch/x86/kernel/apic/apic.c:1068
 instr_sysvec_apic_timer_interrupt arch/x86/kernel/apic/apic.c:1062
 [inline]
 sysvec_apic_timer_interrupt+0xa1/0xc0 arch/x86/kernel/apic/apic.c:1062
 </IRQ>

To fix this, implement two complementary solutions. First, enforce a
reasonable minimum interval for software scheduling. Introduce
`TAPRIO_MIN_SW_INTERVAL` (50 us) and enforce it in `fill_sched_entry()` and
`parse_taprio_schedule()` when hardware offload is not enabled. This
prevents configuring schedules that software hrtimers cannot reliably
maintain. Second, advance the schedule mathematically on overruns. If the
newly calculated `end_time` is still in the past relative to the current
time, calculate the number of missed cycles and advance the expiration
times mathematically. This breaks the infinite loop by skipping missed
cycles and scheduling the next timer expiration in the future, ensuring the
system can recover gracefully even if an overrun occurs due to heavy system
load.

Fixes: 5a781ccbd19e ("tc: Add support for configuring the taprio scheduler")
Assisted-by: Gemini:gemini-3.5-flash Gemini:gemini-3.1-pro-preview syzbot
Reported-by: syzbot+8785aaf121cfb2141e0d@syzkaller.appspotmail.com
Closes: https://syzkaller.appspot.com/bug?extid=8785aaf121cfb2141e0d
Link: https://syzkaller.appspot.com/ai_job?id=8f74a8d2-7a9d-4fb5-96f1-392245f3cf7f
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
index 299234a5f..64600f3bc 100644
--- a/net/sched/sch_taprio.c
+++ b/net/sched/sch_taprio.c
@@ -40,6 +40,7 @@ static struct static_key_false taprio_have_working_mqprio;
 
 #define TXTIME_ASSIST_IS_ENABLED(flags) ((flags) & TCA_TAPRIO_ATTR_FLAG_TXTIME_ASSIST)
 #define FULL_OFFLOAD_IS_ENABLED(flags) ((flags) & TCA_TAPRIO_ATTR_FLAG_FULL_OFFLOAD)
+#define TAPRIO_MIN_SW_INTERVAL 50000 /* 50 us */
 #define TAPRIO_SUPPORTED_FLAGS \
 	(TCA_TAPRIO_ATTR_FLAG_TXTIME_ASSIST | TCA_TAPRIO_ATTR_FLAG_FULL_OFFLOAD)
 #define TAPRIO_FLAGS_INVALID U32_MAX
@@ -980,10 +981,31 @@ static enum hrtimer_restart advance_sched(struct hrtimer *timer)
 		end_time = next->end_time;
 	}
 
+first_run:
+	/* Check if we fell behind and advance the schedule mathematically */
+	if (unlikely(ktime_after(taprio_get_time(q), end_time))) {
+		ktime_t now = taprio_get_time(q);
+		ktime_t cycle = oper->cycle_time;
+		s64 n;
+
+		if (likely(cycle)) {
+			n = div64_s64(ktime_sub_ns(now, end_time), cycle);
+			end_time = ktime_add_ns(end_time, (n + 1) * cycle);
+			oper->cycle_end_time = ktime_add_ns(oper->cycle_end_time,
+							    (n + 1) * cycle);
+
+			for (tc = 0; tc < num_tc; tc++) {
+				if (next->gate_close_time[tc] != KTIME_MAX)
+					next->gate_close_time[tc] =
+						ktime_add_ns(next->gate_close_time[tc],
+							     (n + 1) * cycle);
+			}
+		}
+	}
+
 	next->end_time = end_time;
 	taprio_set_budgets(q, oper, next);
 
-first_run:
 	rcu_assign_pointer(q->current_entry, next);
 	spin_unlock(&q->current_entry_lock);
 
@@ -1061,6 +1083,11 @@ static int fill_sched_entry(struct taprio_sched *q, struct nlattr **tb,
 		return -EINVAL;
 	}
 
+	if (!FULL_OFFLOAD_IS_ENABLED(q->flags) && interval < TAPRIO_MIN_SW_INTERVAL) {
+		NL_SET_ERR_MSG_MOD(extack, "Interval too small for software scheduling");
+		return -EINVAL;
+	}
+
 	entry->interval = interval;
 
 	return 0;
@@ -1171,6 +1198,12 @@ static int parse_taprio_schedule(struct taprio_sched *q, struct nlattr **tb,
 		return -EINVAL;
 	}
 
+	if (!FULL_OFFLOAD_IS_ENABLED(q->flags) &&
+	    new->cycle_time < new->num_entries * TAPRIO_MIN_SW_INTERVAL) {
+		NL_SET_ERR_MSG_MOD(extack, "'cycle_time' is too small for software scheduling");
+		return -EINVAL;
+	}
+
 	taprio_calculate_gate_durations(q, new);
 
 	return 0;


base-commit: f5098b6bae761e346ebcd9da7f95622c04733cff
-- 
This is an AI-generated patch subject to moderation.
Reply with '#syz upstream' to Sign-off the patch as a human author
and send it to the upstream kernel mailing lists.
Reply with '#syz reject' to reject it ('#syz unreject' to undo).

See https://goo.gle/syzbot-ai-patches for information about AI-generated patches.
You can comment on the patch as usual, syzbot will try to address
the comments and send a new version of the patch if necessary.
syzbot engineers can be reached at syzkaller@googlegroups.com.
