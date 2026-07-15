Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E662632B13A
	for <syzbot@lists.linux.dev>; Wed, 15 Jul 2026 17:01:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784134896; cv=none; b=BCU7Vihio5D1bRE2d9953yapoACfmuYwRNOeVkgw4leUhQVKf3FrTLaNHIOwHOF92Epsmbalmt3tRy/hr3zrQf8oPjoCz/t/Ccz/BU6CR04kvcxUCqWrwUcq8YK9IgG1KV9uawU45xT/7jt5+WrgamMqoRJjaQ4G2H8R+zbgvTg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784134896; c=relaxed/simple;
	bh=tB2U36oPyGsTgUb637NVbxuhUHta3kg90HWZQFFIOdY=;
	h=From:To:Cc:Subject:Message-ID:MIME-Version:Content-Type:Date; b=Yu+KGsZD2eyaM7v99T+TxvrujTQo8Vzfh/Wu1NJXZp7ptUBT1YZdY5gdUcCsp2oIOxR7uXb/rsbP0FIO1snCO53j/+wmbXZ1gc1gwqp7l+T5jyUifnfjcnR5x+Tc/TaIXMIGS043Tib1o1pvgZPrQyBqghuoNxobyP6yNxzHylk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=iMUVSbCa; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="iMUVSbCa"
Received: by smtp.kernel.org (Postfix) with UTF8SMTPSA id 854DD1F00A3A;
	Wed, 15 Jul 2026 17:01:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1784134894;
	bh=C/rpRijJI3g66w5JnyhOWkdBYEyIBpFvmbbi3WldgHo=;
	h=From:To:Cc:Subject:Date;
	b=iMUVSbCaXF2D803o10bzCLjeZ3g/ly/lGxtPoDGsHMhTnJADrdsCwiQ3FeApU5o/k
	 K4NCpadIin8dcsCGfwaAlnk7XZ4/pZR/fO0LYzcAyhPn3u5maZt/j1uMcsYKcTw7Ic
	 3Ca9AA4YMSnES3RN+NTu/qk6PPiohE+0z9K6i7bXSD5NMHnss1kDqth5/KKjccQkY6
	 mi4rjrs45GSXk/z5uoSPwy5JJSoVaC1IwTdYkSAQyT/hvH9AMtoQ+fadz6rlz29zOH
	 wo2kewHbTMuRAyo9IGnyVPc18Z70zCEeOQDrHIkryRZXagyPPGWzj9+lYTflNoEvO5
	 xalB5bMpXiclA==
From: "syzbot" <syzbot@kernel.org>
To: syzkaller-upstream-moderation@googlegroups.com
Cc: syzbot@lists.linux.dev
Subject: [PATCH RFC] net/sched: taprio: enforce minimum interval to prevent hrtimer storms
Message-ID: <7d5b3fcb-ab75-4a18-909f-5ff072e562e1@mail.kernel.org>
Precedence: bulk
X-Mailing-List: syzbot@lists.linux.dev
List-Id: <syzbot.lists.linux.dev>
List-Subscribe: <mailto:syzbot+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:syzbot+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Date: Wed, 15 Jul 2026 17:01:34 +0000 (UTC)

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

To fix this issue, clamp the minimum allowed interval to a higher, safer
threshold during the configuration phase. Introduce TAPRIO_MIN_INTERVAL
(set to NSEC_PER_USEC, i.e., 1 microsecond) to account for software
interrupt overhead. This threshold is large enough to prevent hrtimer
interrupt storms while still allowing legitimate high-speed configurations
(e.g., 10 Gbps with 1500-byte packets, which take 1.2 us to transmit).

Apply this clamped minimum duration in both fill_sched_entry() and
parse_taprio_schedule() to ensure that both individual intervals and the
overall cycle time are safely bounded.

Fixes: b5b73b26b3ca ("taprio: Fix allowing too small intervals")
Assisted-by: Gemini:gemini-3.1-pro-preview Gemini:gemini-3-flash-preview syzbot
Reported-by: syzbot+e044a9b6370ed8ca9737@syzkaller.appspotmail.com
Closes: https://syzkaller.appspot.com/bug?extid=e044a9b6370ed8ca9737
Link: https://syzkaller.appspot.com/ai_job?id=894fc82e-5f23-4209-a5b3-4d0c8178756d
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
index 299234a5f..d759a99e5 100644
--- a/net/sched/sch_taprio.c
+++ b/net/sched/sch_taprio.c
@@ -49,6 +49,9 @@ static struct static_key_false taprio_have_working_mqprio;
  */
 #define TAPRIO_PICOS_PER_BYTE_MIN 17
 
+/* Safe minimum interval to prevent hrtimer interrupt storms */
+#define TAPRIO_MIN_INTERVAL NSEC_PER_USEC
+
 struct sched_entry {
 	/* Durations between this GCL entry and the GCL entry where the
 	 * respective traffic class gate closes
@@ -1038,7 +1041,8 @@ static int fill_sched_entry(struct taprio_sched *q, struct nlattr **tb,
 			    struct sched_entry *entry,
 			    struct netlink_ext_ack *extack)
 {
-	int min_duration = length_to_duration(q, ETH_ZLEN);
+	int min_duration = max_t(int, length_to_duration(q, ETH_ZLEN),
+				 TAPRIO_MIN_INTERVAL);
 	u32 interval = 0;
 
 	if (tb[TCA_TAPRIO_SCHED_ENTRY_CMD])
@@ -1054,7 +1058,8 @@ static int fill_sched_entry(struct taprio_sched *q, struct nlattr **tb,
 			tb[TCA_TAPRIO_SCHED_ENTRY_INTERVAL]);
 
 	/* The interval should allow at least the minimum ethernet
-	 * frame to go out.
+	 * frame to go out, and should be large enough to prevent
+	 * hrtimer interrupt storms.
 	 */
 	if (interval < min_duration) {
 		NL_SET_ERR_MSG(extack, "Invalid interval for schedule entry");
@@ -1166,7 +1171,9 @@ static int parse_taprio_schedule(struct taprio_sched *q, struct nlattr **tb,
 		new->cycle_time = cycle;
 	}
 
-	if (new->cycle_time < new->num_entries * length_to_duration(q, ETH_ZLEN)) {
+	if (new->cycle_time <
+	    new->num_entries * max_t(int, length_to_duration(q, ETH_ZLEN),
+				     TAPRIO_MIN_INTERVAL)) {
 		NL_SET_ERR_MSG(extack, "'cycle_time' is too small");
 		return -EINVAL;
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
