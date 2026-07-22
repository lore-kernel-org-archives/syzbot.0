Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7C1981CAA6D
	for <syzbot@lists.linux.dev>; Wed, 22 Jul 2026 18:32:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784745159; cv=none; b=VHrY6/QXonexlaCrMXdkHeUQvDmrqbovHhwD/fhRFQoaZdpHccAJJ4HXsOIAO7jljcexYxtyA+IihB1eAj7uqNjidsEQzhzMIdswFSHr5Wng8sPMYzmzajJpdumykXCSq5r7aZ53qnpJiVb9Z/DHG3+NMlf+aS2cKUaO+r6Ob24=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784745159; c=relaxed/simple;
	bh=2h/oNPOFuHDSp7Hfl/Hbv04Z7gOzXFwI123NqyqXuTQ=;
	h=From:To:Cc:Subject:Message-ID:MIME-Version:Content-Type:Date; b=qdse5CtxpoJrfN5ZvdCohQAWrt0Il15W8VTDm4Q49Usw9p1+WR5edxH8NJmBSw8xnbGanUbyydxi/MLM9PZvYOVLH4r4xR3ooXTUM5jsYcBg3Zn1ws25NtmsjX9zZPk+lqMHnkO8fOJhc90aGA6sRDfm4OBJFnK8RlTC5t//VIo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=S+1WXsxa; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="S+1WXsxa"
Received: by smtp.kernel.org (Postfix) with UTF8SMTPSA id 065AA1F000E9;
	Wed, 22 Jul 2026 18:32:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1784745158;
	bh=MvtIp0tbzgKf2NvCtmEYsTXq4chLOjKB7FitNHQLrWE=;
	h=From:To:Cc:Subject:Date;
	b=S+1WXsxarQwnbCGXWBsfRkgKhkhcmy4DjrC6QbCvg2r4MjWMfnysJtJiZ/qrI4ste
	 5pA2saV2H7AsE+m3Jqk+/vvnD2k5yLJOIv3VhAcu5dAuHJgMVnkzULjIZepxRQ9yGj
	 hMGKD43Pk6kpTfpXLc/zHAaHPV/Au1rctDvberGJhVav4REy5hXiqaSsHUHGwY0i7z
	 nectKlkjDTpuNJVf98MWpl+Hom75k0keJQj3qRiBNJuZpdmTHS27xBfkjuXnGhpTaK
	 Q4cMs3xmgF20lz8hYBRqCcdL67F05HDIafcRHM2ESjjfvTLoN+wvvFEi2xDyZwwVMx
	 FXGMjCkRd2phA==
From: "syzbot" <syzbot@kernel.org>
To: syzkaller-upstream-moderation@googlegroups.com
Cc: syzbot@lists.linux.dev, uladzislau.zhauniarovich@gmail.com
Subject: [PATCH RFC v2] net/sched: taprio: enforce minimum software scheduling interval
Message-ID: <d54f0bbd-ed4d-42bc-8a37-3268d9b3ebb8@mail.kernel.org>
Precedence: bulk
X-Mailing-List: syzbot@lists.linux.dev
List-Id: <syzbot.lists.linux.dev>
List-Subscribe: <mailto:syzbot+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:syzbot+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Date: Wed, 22 Jul 2026 18:32:37 +0000 (UTC)

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
- Increased the minimum software scheduling interval from 1us to 100us to cover the timer service cost.
- Explained how virtual devices (veth, bonding) bypass the link-speed validation.
- Clarified that fully offloaded schedules are unaffected.
- Refactored the minimum interval check into a new taprio_min_interval() helper.

v1:
https://lore.kernel.org/all/be92b2ea-2bf9-4d7f-a833-de781ee804c8@mail.kernel.org/T/
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
This is an AI-generated patch subject to moderation.
Reply with '#syz upstream' to Sign-off the patch as a human author
and send it to the upstream kernel mailing lists.
Reply with '#syz reject' to reject it ('#syz unreject' to undo).

See https://goo.gle/syzbot-ai-patches for information about AI-generated patches.
You can comment on the patch as usual, syzbot will try to address
the comments and send a new version of the patch if necessary.
syzbot engineers can be reached at syzkaller@googlegroups.com.
