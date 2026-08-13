Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 612612E7179;
	Thu, 13 Aug 2026 02:15:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786587351; cv=none; b=p5j6WZ1M8QBWy+BEr7AuBwJN4q1Rg+xniwo/ylphorX4Zo6VDh2qeQ4WGi9R1dBI1hJX1oTvdhRIypOX722Bp2s3+/5sVvUvfhMyJZrYRtpSG868TNVrPdrRSBDjuN4voB9XLUIYRfE2Ubg11WHb6v3NTu8reonQB5paIFQ31F0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786587351; c=relaxed/simple;
	bh=4OIUTJXe9GSqb8P/4dlqiXPXQqiApCtV0xf4vpTT3bw=;
	h=From:To:Cc:Subject:Message-ID:MIME-Version:Content-Type:Date; b=OBloUpDP2rB+EBuAR934Wa9E9GwaApex/1IKuLWZt2HqPen2c3taZSODYWmXgcLAzShsQJQkQzT95osDYjbPOZytDt1utlXo+0ksE+U9t0PehLgd9w7K/U1uZsHBgSybGj1xwfuM5pGbLQJyr1oojmUVgb+tQifcBPLjUroYl+0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=oBjfQEMC; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="oBjfQEMC"
Received: by smtp.kernel.org (Postfix) with UTF8SMTPSA id 85EC51F000E9;
	Thu, 13 Aug 2026 02:15:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1786587350;
	bh=YBAHVHUsoubUukRavwp2qvQV7W2bjorBbW7egYAeeMw=;
	h=From:To:Cc:Subject:Date;
	b=oBjfQEMC5hI9P8CUpOL1fwZkukLxTbM2H76e60HlvTdkoPRF+LMJ2Z+r3dA+IoDKS
	 dssc2wYnTlrNr5WwP3KjOWtCpU6gmrZtBNokdB0POnJXt74CpaFYtA8Y7zihwy7cxB
	 u4clfQm457xfUHyAXwsFLDimwYLYq0shq1SGayUCjZkQ2QH4+UvQDIW82rYoEWof/p
	 RMyDJ5SEz5TQYuMdMPDGR5lA7n9JNTIZOV1sreoGf5Z0/5mHj1lxs6zaRvklroLSHy
	 Hx0r1UfiIjl0baUYuE0RhaXLJL8gSdrJa8fOnkTYancEceXxkqA6TwUuZEJPZpodaC
	 AznP5Ql0fyGxQ==
From: "syzbot" <syzbot@kernel.org>
To: syzkaller-bugs@googlegroups.com, Uladzislau Zhauniarovich <uladzislau.zhauniarovich@gmail.com>, "David S. Miller" <davem@davemloft.net>, "Eric Dumazet" <edumazet@google.com>, "Jamal Hadi Salim" <jhs@mojatatu.com>, "Jiri Pirko" <jiri@resnulli.us>, "Jakub Kicinski" <kuba@kernel.org>, <netdev@vger.kernel.org>, "Paolo Abeni" <pabeni@redhat.com>, "Vinicius Costa Gomes" <vinicius.gomes@intel.com>
Cc: horms@kernel.org, linux-kernel@vger.kernel.org, syzbot@lists.linux.dev
Subject: [PATCH] net/sched: taprio: enforce minimum software scheduling interval
Message-ID: <afe041f6-ef7d-4434-b2d0-096be49b5bcb@mail.kernel.org>
Precedence: bulk
X-Mailing-List: syzbot@lists.linux.dev
List-Id: <syzbot.lists.linux.dev>
List-Subscribe: <mailto:syzbot+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:syzbot+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Date: Thu, 13 Aug 2026 02:15:49 +0000 (UTC)

From: Uladzislau Zhauniarovich <uladzislau.zhauniarovich@gmail.com>

When configuring taprio with a very small schedule interval (e.g., 129 ns),
the kernel validates the interval against the time it takes to transmit a
minimum-sized Ethernet frame (60 bytes). On high-speed links, this minimum
duration is extremely small (e.g., 48 ns at 10 Gbps). Since the requested
interval is larger than this, the validation passes. Virtual devices like
veth or bonding can defeat this link-speed minimum check because they
report inflated link speeds (e.g., veth reports 10 Gbps, and bonding sums
member speeds).

However, when hardware offload is not used, taprio falls back to software
scheduling and arms an hrtimer. The hrtimer is programmed to fire at the
configured interval. If this interval is too small, it cannot sustain the
timer service cost of one advance_sched() invocation, which includes lock
acquisition, budget recomputation, and TX softirq processing. As a result,
the timer constantly falls behind, and the CPU is livelocked in hardirq
context endlessly servicing the advance_sched() hrtimer. This starves the
RCU grace-period kthreads, leading to an RCU stall panic:

rcu: INFO: rcu_preempt detected stalls on CPUs/tasks:
rcu: 	1-...!: (1 GPs behind) idle=4854/0/0x1 softirq=136062/136068 fqs=0
rcu: 	(detected by 0, t=10506 jiffies, g=161469, q=1866 ncpus=2)
Sending NMI from CPU 0 to CPUs 1:
NMI backtrace for cpu 1
CPU: 1 UID: 0 PID: 0 Comm: swapper/1 Not tainted
Call Trace:
 <IRQ>
 lock_is_held include/linux/lockdep.h:249 [inline]
 enqueue_hrtimer+0x79/0x2c0 kernel/time/hrtimer.c:1107
 __run_hrtimer kernel/time/hrtimer.c:1946 [inline]
 __hrtimer_run_queues+0x4ce/0xa10 kernel/time/hrtimer.c:1994
 hrtimer_interrupt+0x448/0x910 kernel/time/hrtimer.c:2113
 local_apic_timer_interrupt arch/x86/kernel/apic/apic.c:1050 [inline]
 __sysvec_apic_timer_interrupt+0x102/0x430 arch/x86/kernel/apic/apic.c:1067
 instr_sysvec_apic_timer_interrupt arch/x86/kernel/apic/apic.c:1061
 [inline]
 sysvec_apic_timer_interrupt+0xa1/0xc0 arch/x86/kernel/apic/apic.c:1061
 </IRQ>

To fix this, enforce a hard absolute minimum interval of 100 microseconds
(TAPRIO_MIN_SW_INTERVAL_NS) for software-based scheduling, which provides
enough margin over the timer service cost. Fully offloaded schedules are
unaffected since they do not rely on the CPU's hrtimer. Introduce a helper
taprio_min_interval() to consolidate the minimum interval logic for both
individual schedule entries and the overall cycle_time validation.

Fixes: b5b73b26b3ca ("taprio: Fix allowing too small intervals")
Assisted-by: Gemini:gemini-3.5-flash Gemini:gemini-3.1-pro-preview syzbot
Reported-by: syzbot+19d01f6082ec61dd45b2@syzkaller.appspotmail.com
Closes: https://syzkaller.appspot.com/bug?extid=19d01f6082ec61dd45b2
Link: https://syzkaller.appspot.com/ai_job?id=37f064ee-e021-43aa-8cfc-9f2a5a7c35d7
Signed-off-by: Uladzislau Zhauniarovich <uladzislau.zhauniarovich@gmail.com>

---
diff --git a/net/sched/sch_taprio.c b/net/sched/sch_taprio.c
index 45245157e..2bf4cae16 100644
--- a/net/sched/sch_taprio.c
+++ b/net/sched/sch_taprio.c
@@ -49,6 +49,13 @@ static struct static_key_false taprio_have_working_mqprio;
  */
 #define TAPRIO_PICOS_PER_BYTE_MIN 17
 
+/* The software scheduler cannot sustain hrtimer intervals smaller than
+ * this without livelocking the CPU. The value must exceed the cost of
+ * one advance_sched() invocation (lock acquisition, budget recomputation,
+ * TX softirq) with margin.
+ */
+#define TAPRIO_MIN_SW_INTERVAL_NS (100 * NSEC_PER_USEC)
+
 struct sched_entry {
 	/* Durations between this GCL entry and the GCL entry where the
 	 * respective traffic class gate closes
@@ -259,6 +266,16 @@ static int length_to_duration(struct taprio_sched *q, int len)
 	return div_u64(len * atomic64_read(&q->picos_per_byte), PSEC_PER_NSEC);
 }
 
+static int taprio_min_interval(struct taprio_sched *q)
+{
+	int min_duration = length_to_duration(q, ETH_ZLEN);
+
+	if (!FULL_OFFLOAD_IS_ENABLED(q->flags))
+		min_duration = max_t(int, min_duration, TAPRIO_MIN_SW_INTERVAL_NS);
+
+	return min_duration;
+}
+
 static int duration_to_length(struct taprio_sched *q, u64 duration)
 {
 	return div_u64(duration * PSEC_PER_NSEC, atomic64_read(&q->picos_per_byte));
@@ -1038,7 +1055,7 @@ static int fill_sched_entry(struct taprio_sched *q, struct nlattr **tb,
 			    struct sched_entry *entry,
 			    struct netlink_ext_ack *extack)
 {
-	int min_duration = length_to_duration(q, ETH_ZLEN);
+	int min_duration = taprio_min_interval(q);
 	u32 interval = 0;
 
 	if (tb[TCA_TAPRIO_SCHED_ENTRY_CMD])
@@ -1054,7 +1071,8 @@ static int fill_sched_entry(struct taprio_sched *q, struct nlattr **tb,
 			tb[TCA_TAPRIO_SCHED_ENTRY_INTERVAL]);
 
 	/* The interval should allow at least the minimum ethernet
-	 * frame to go out.
+	 * frame to go out. When software scheduling is used, the
+	 * interval must also be at least the minimum hrtimer interval.
 	 */
 	if (interval < min_duration) {
 		NL_SET_ERR_MSG(extack, "Invalid interval for schedule entry");
@@ -1166,7 +1184,7 @@ static int parse_taprio_schedule(struct taprio_sched *q, struct nlattr **tb,
 		new->cycle_time = cycle;
 	}
 
-	if (new->cycle_time < new->num_entries * length_to_duration(q, ETH_ZLEN)) {
+	if (new->cycle_time < (s64)new->num_entries * taprio_min_interval(q)) {
 		NL_SET_ERR_MSG(extack, "'cycle_time' is too small");
 		return -EINVAL;
 	}


base-commit: 8cd9520d35a6c38db6567e97dd93b1f11f185dc6
-- 
See https://goo.gle/syzbot-ai-patches for information about AI-generated patches.
The person who has signed off on the patch is responsible for
addressing comments.
syzbot engineers can be reached at syzkaller@googlegroups.com.
