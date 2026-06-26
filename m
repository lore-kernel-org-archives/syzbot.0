Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DA09F3C1989
	for <syzbot@lists.linux.dev>; Fri, 26 Jun 2026 22:22:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782512546; cv=none; b=DuMMvCsFBlQnxdsZyrWNDLHyruIR7vLhX4bK6UsycGCkANu3RbyBytpb7xfbHlgY6V5W7rzqFNiUu9yRHQ4/rtksjhmAH9bMCwBbwqu7XNsRpXOxOM3CoR9Sdc+sfn2S0ztOHe0fuzG2ZrQeVu/5gtkNhtuwRPQbgyE24gMQIKM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782512546; c=relaxed/simple;
	bh=KrWHIDbJjOi29lPWu4WIDNw7PvX0I3sEEjMPDvIjFE0=;
	h=From:To:Cc:Subject:Message-ID:MIME-Version:Content-Type:Date; b=TC6qsx/pZi3MUj29M4rUqiS1hZe/If4Z87zxUbDjztlZZbr4zRxgSzPekPpEJIWc2w0XcuJAMhZipMl4oINonrzrMqmCeuuDadzErkp7C0njyQQb9toC3cBaHyX0VYF36HS/BLcGTbYpD/YmaVMotUWTIqvCHK2Uz3dGW0x5ZQc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=bWiRo7do; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="bWiRo7do"
Received: by smtp.kernel.org (Postfix) with UTF8SMTPSA id 51D3F1F000E9;
	Fri, 26 Jun 2026 22:22:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1782512544;
	bh=foBFafYRfk056y+snlGqZbS10no9r5Dy1hvGXGUkyRI=;
	h=From:To:Cc:Subject:Date;
	b=bWiRo7dogbL5BOCDI1mKXUdfY/H+pnejUyQvPUNKjpJUx58DoDsWtaWOA78nLOm1q
	 lv/xl6FStHdSPEghCX4d/A5DsRFrJ6nAkNoxkWmhoLjIsFMIchilLg9vDpgdpjvXG2
	 v3/9rqKXYUdhCtVeEFB5zgwbV8rfDxrVbuVvZelaYMsjnZNMvnayALhB24HjPA80nG
	 YNPeh8X4FW+G2aXV5ktUeWSIKWILTtWNfwfbxgcCJDvLirpIzm5XZ4u09jPkE4rfIr
	 Q6fOm9GE4s4Z3e/sbliZbukPVo+uxKe7Y6I/DmgahRUod8q+bR7fDzG7pOROM2HNrR
	 mG2+jFuW7ldNA==
From: "syzbot" <syzbot@kernel.org>
To: syzkaller-upstream-moderation@googlegroups.com
Cc: syzbot@lists.linux.dev
Subject: [PATCH RFC] net/sched: taprio: enforce minimum software scheduling interval
Message-ID: <be92b2ea-2bf9-4d7f-a833-de781ee804c8@mail.kernel.org>
Precedence: bulk
X-Mailing-List: syzbot@lists.linux.dev
List-Id: <syzbot.lists.linux.dev>
List-Subscribe: <mailto:syzbot+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:syzbot+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Date: Fri, 26 Jun 2026 22:22:24 +0000 (UTC)

When configuring taprio with a very small schedule interval (e.g., 129 ns),
the kernel validates the interval against the time it takes to transmit a
minimum-sized Ethernet frame (60 bytes). On high-speed links like 10 Gbps,
this minimum duration is extremely small (e.g., 48 ns). Since the requested
interval is larger than this, the validation passes.

However, when hardware offload is not used, taprio falls back to software
scheduling and arms an hrtimer. The hrtimer is programmed to fire every 129
ns. This is significantly shorter than the overhead of handling a hardware
interrupt and running the hrtimer subsystem. As a result, the timer
constantly falls behind, and the CPU is livelocked in hardirq context
endlessly servicing the advance_sched() hrtimer. This starves the RCU
grace-period kthreads, leading to an RCU stall panic:

rcu: INFO: rcu_preempt detected stalls on CPUs/tasks:
rcu: 	1-...!: (1 GPs behind) idle=858c/1/0x4000000000000000
softirq=112663/112663 fqs=0
rcu: 	(detected by 0, t=10502 jiffies, g=143345, q=674 ncpus=2)
Sending NMI from CPU 0 to CPUs 1:
NMI backtrace for cpu 1
...
Call Trace:
 <IRQ>
 advance_sched+0x99a/0xc80 net/sched/sch_taprio.c:988
 __run_hrtimer kernel/time/hrtimer.c:1930 [inline]
 __hrtimer_run_queues+0x3bc/0xa10 kernel/time/hrtimer.c:1994
 hrtimer_interrupt+0x448/0x910 kernel/time/hrtimer.c:2113
 local_apic_timer_interrupt arch/x86/kernel/apic/apic.c:1050 [inline]
 __sysvec_apic_timer_interrupt+0x102/0x430 arch/x86/kernel/apic/apic.c:1067
 instr_sysvec_apic_timer_interrupt arch/x86/kernel/apic/apic.c:1061
 [inline]
 sysvec_apic_timer_interrupt+0xa1/0xc0 arch/x86/kernel/apic/apic.c:1061
 </IRQ>

To fix this, enforce a hard absolute minimum interval of 1 microsecond
(NSEC_PER_USEC) for software-based scheduling, regardless of the link
speed. Hardware-offloaded taprio can continue to support smaller intervals
since it does not rely on the CPU's hrtimer. The same logic is applied to
the overall cycle_time validation, casting num_entries to s64 to prevent
potential integer overflow.

Fixes: b5b73b26b3ca ("taprio: Fix allowing too small intervals")
Assisted-by: Gemini:gemini-3.1-pro-preview syzbot
Reported-by: syzbot+19d01f6082ec61dd45b2@syzkaller.appspotmail.com
Closes: https://syzkaller.appspot.com/bug?extid=19d01f6082ec61dd45b2
Link: https://syzkaller.appspot.com/ai_job?id=e96ce5ef-50a8-4856-a518-279d5610b23c
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
index 45245157e..b5743a556 100644
--- a/net/sched/sch_taprio.c
+++ b/net/sched/sch_taprio.c
@@ -49,6 +49,11 @@ static struct static_key_false taprio_have_working_mqprio;
  */
 #define TAPRIO_PICOS_PER_BYTE_MIN 17
 
+/* The software scheduler cannot sustain hrtimer intervals smaller than
+ * this without livelocking the CPU.
+ */
+#define TAPRIO_MIN_SW_INTERVAL NSEC_PER_USEC
+
 struct sched_entry {
 	/* Durations between this GCL entry and the GCL entry where the
 	 * respective traffic class gate closes
@@ -1041,6 +1046,9 @@ static int fill_sched_entry(struct taprio_sched *q, struct nlattr **tb,
 	int min_duration = length_to_duration(q, ETH_ZLEN);
 	u32 interval = 0;
 
+	if (!FULL_OFFLOAD_IS_ENABLED(q->flags))
+		min_duration = max_t(int, min_duration, TAPRIO_MIN_SW_INTERVAL);
+
 	if (tb[TCA_TAPRIO_SCHED_ENTRY_CMD])
 		entry->command = nla_get_u8(
 			tb[TCA_TAPRIO_SCHED_ENTRY_CMD]);
@@ -1054,7 +1062,8 @@ static int fill_sched_entry(struct taprio_sched *q, struct nlattr **tb,
 			tb[TCA_TAPRIO_SCHED_ENTRY_INTERVAL]);
 
 	/* The interval should allow at least the minimum ethernet
-	 * frame to go out.
+	 * frame to go out. When software scheduling is used, the
+	 * interval must also be at least the minimum hrtimer interval.
 	 */
 	if (interval < min_duration) {
 		NL_SET_ERR_MSG(extack, "Invalid interval for schedule entry");
@@ -1166,9 +1175,17 @@ static int parse_taprio_schedule(struct taprio_sched *q, struct nlattr **tb,
 		new->cycle_time = cycle;
 	}
 
-	if (new->cycle_time < new->num_entries * length_to_duration(q, ETH_ZLEN)) {
-		NL_SET_ERR_MSG(extack, "'cycle_time' is too small");
-		return -EINVAL;
+	{
+		int min_duration = length_to_duration(q, ETH_ZLEN);
+
+		if (!FULL_OFFLOAD_IS_ENABLED(q->flags))
+			min_duration = max_t(int, min_duration,
+					     TAPRIO_MIN_SW_INTERVAL);
+
+		if (new->cycle_time < (s64)new->num_entries * min_duration) {
+			NL_SET_ERR_MSG(extack, "'cycle_time' is too small");
+			return -EINVAL;
+		}
 	}
 
 	taprio_calculate_gate_durations(q, new);


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
