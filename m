Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2DB4D3AA1B5
	for <syzbot@lists.linux.dev>; Fri, 28 Aug 2026 11:31:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787916699; cv=none; b=oMKoLQbzKZ8tfJxpm9r2niq1m759flrnVjMU6DgJ0mc9IPz5Wk54Pupab3acXN844TT66bFa+0+5VqF1gmX4P4diwkhZOkiBwWwWZPjKlIN3WCOgTf7lXWoR5s7AsN0o2Oz6GszstkCNZPqIKVe2AYLY67sUGDJKzdT1Zj5ZIrI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787916699; c=relaxed/simple;
	bh=YvCV6NZ4mkbqqtDlLpF6SOS4A/d+Duon/jbj2eShHTI=;
	h=From:To:Cc:Subject:Message-ID:MIME-Version:Content-Type:Date; b=gAqrDytmPjSN4FtM2YzOvtLT4wso1Q/a9XFVheIrZ+A/64P0SUM0X74ztrLIcsnLgQ0V4wzvB/ikOoGMSf1Jx1VF3ipZ3r0V5o1tl7a5oJBqTuAtW9Au3NQD/U849Up4hCBwq7wO5bX32Lv96PWVdeRhqDpuP3Dj3es1ofJoe8Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=RDWvK0jh; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="RDWvK0jh"
Received: by smtp.kernel.org (Postfix) with UTF8SMTPSA id ABFE21F00A3A;
	Fri, 28 Aug 2026 11:31:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1787916697;
	bh=MBvC7yUtNbSBCmvyFPLVIsGTcMmfzbOI1IW6V0cFgIM=;
	h=From:To:Cc:Subject:Date;
	b=RDWvK0jhG0aDm2x3ypg+PwV4tb0reBbsoa7wpM8UUjnHAXtu5Oycv914xLyhFQD3d
	 oCZHlVa9CibjUv1Vl1O2uTcrSg7oNA2rJGo9jp9UTYXq1t/1qwPyv8POLYkiZEdcBG
	 ykyz8i+0kzcWeyISjZNtMUMtWFboUAtGrWAtZq+EZf2rgtpjYu2aEI40PSp9gV0H8e
	 SlE9GD0Z6RnwuO2qOPYPAxlADoV4hrMLDzCPwh3i6w8GwE8U2QSjcfUJYz/l8vruk3
	 /wQvxeYsRSsQOMbCGN1aG2w1qQhnCqBlsX3NuRZQN5zyLCecsM0D4XGhxVYUy6CISX
	 7dNpbyuk60XlQ==
From: "syzbot" <syzbot@kernel.org>
To: syzkaller-upstream-moderation@googlegroups.com
Cc: immersa.bartosz.chronowski@gmail.com, syzbot@lists.linux.dev
Subject: [PATCH RFC v3] net/sched: taprio: reject excessively small intervals in software mode
Message-ID: <ecbfe945-f1ab-45de-aaa0-b9b57ae730c2@mail.kernel.org>
Precedence: bulk
X-Mailing-List: syzbot@lists.linux.dev
List-Id: <syzbot.lists.linux.dev>
List-Subscribe: <mailto:syzbot+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:syzbot+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Date: Fri, 28 Aug 2026 11:31:37 +0000 (UTC)

The taprio qdisc allows configuring excessively small intervals (e.g., 255
ns) which can completely overwhelm the CPU when using software timers. When
the interval is shorter than the time it takes to process the timer
interrupt, the timer expiration falls continuously into the past. This
overdue-absolute-deadline condition causes the hrtimer subsystem to
repeatedly re-enqueue and fire the timer, resulting in an interrupt storm
that starves CPU tasks and triggers RCU stalls:

rcu: INFO: rcu_preempt detected stalls on CPUs/tasks:
	1-...!: (1 GPs behind) idle=5b64/0/0x1 softirq=135954/135971 fqs=1
Call Trace:
 <IRQ>
 advance_sched+0xc2/0xc80 net/sched/sch_taprio.c:930
 __run_hrtimer kernel/time/hrtimer.c:2032 [inline]
 __hrtimer_run_queues+0x3bc/0xa10 kernel/time/hrtimer.c:2096
 hrtimer_interrupt+0x448/0x910 kernel/time/hrtimer.c:2215
 local_apic_timer_interrupt arch/x86/kernel/apic/apic.c:1051 [inline]
 __sysvec_apic_timer_interrupt+0x102/0x430 arch/x86/kernel/apic/apic.c:1068
 sysvec_apic_timer_interrupt+0xa1/0xc0 arch/x86/kernel/apic/apic.c:1062
 </IRQ>

Fix this by rejecting intervals smaller than 100 us (-EINVAL) at admission
time for software TAPRIO schedules driven by advance_timer. When neither
txtime-assist nor full-offload mode is enabled, enforce a minimum interval
duration of 100 us in fill_sched_entry() and parse_taprio_schedule(), while
retaining length_to_duration(q, ETH_ZLEN) for hardware-offloaded schedules.

Fixes: 5a781ccbd19e ("tc: Add support for configuring the taprio scheduler")
Assisted-by: Gemini:gemini-3.7-flash syzbot
Reported-by: syzbot+f8850bc3986562f79619@syzkaller.appspotmail.com
Closes: https://syzkaller.appspot.com/bug?extid=f8850bc3986562f79619
Link: https://syzkaller.appspot.com/ai_job?id=896b8415-1acd-41a7-bb99-31c5f93cb5d3
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
- Reject intervals smaller than 100 us at admission time for software TAPRIO schedules instead of modifying advance_sched().
- Drop catch-up cycle arithmetic, loop iteration limits, and physical expiration fallbacks from advance_sched().

v2:
- Removed the 1 microsecond admission policy for software taprio.
- Reduced the loop iteration limit from 2048 to 32 to avoid softirq stalls.
- Added handling for administrative schedules during fast-forwarding to avoid overshooting `admin->base_time`.
- Split logical schedule deadline (`end_time`) and physical timer expiration (`expires`).
- Updated the fallback mechanism to request a physical expiration 1 microsecond in the future relative to the current time rather than yielding the CPU.
- Optimized gate close time calculation to only run once after the loop if not already calculated.
https://lore.kernel.org/all/03dbde3b-8c45-46b6-8291-dd12bcc3120c@mail.kernel.org/T/

v1:
https://lore.kernel.org/all/bc6a8890-9230-489a-bbce-5c255c1ef01a@mail.kernel.org/T/
---
diff --git a/net/sched/sch_taprio.c b/net/sched/sch_taprio.c
index 299234a5f..e5a560a3e 100644
--- a/net/sched/sch_taprio.c
+++ b/net/sched/sch_taprio.c
@@ -1034,11 +1034,22 @@ static const struct nla_policy taprio_policy[TCA_TAPRIO_ATTR_MAX + 1] = {
 	[TCA_TAPRIO_ATTR_TC_ENTRY]		     = { .type = NLA_NESTED },
 };
 
+static int taprio_min_interval_duration(struct taprio_sched *q)
+{
+	int min_duration = length_to_duration(q, ETH_ZLEN);
+
+	if (TXTIME_ASSIST_IS_ENABLED(q->flags) ||
+	    FULL_OFFLOAD_IS_ENABLED(q->flags))
+		return min_duration;
+
+	return max_t(int, min_duration, 100 * NSEC_PER_USEC);
+}
+
 static int fill_sched_entry(struct taprio_sched *q, struct nlattr **tb,
 			    struct sched_entry *entry,
 			    struct netlink_ext_ack *extack)
 {
-	int min_duration = length_to_duration(q, ETH_ZLEN);
+	int min_duration = taprio_min_interval_duration(q);
 	u32 interval = 0;
 
 	if (tb[TCA_TAPRIO_SCHED_ENTRY_CMD])
@@ -1166,7 +1177,7 @@ static int parse_taprio_schedule(struct taprio_sched *q, struct nlattr **tb,
 		new->cycle_time = cycle;
 	}
 
-	if (new->cycle_time < new->num_entries * length_to_duration(q, ETH_ZLEN)) {
+	if (new->cycle_time < (s64)new->num_entries * taprio_min_interval_duration(q)) {
 		NL_SET_ERR_MSG(extack, "'cycle_time' is too small");
 		return -EINVAL;
 	}


base-commit: 8cdeaa50eae8dad34885515f62559ee83e7e8dda
-- 
This is an AI-generated patch subject to moderation.
Reply with '#syz upstream' to Sign-off the patch as a human author
and send it to the upstream kernel mailing lists.
Reply with '#syz reject' to reject it ('#syz unreject' to undo).

See https://goo.gle/syzbot-ai-patches for information about AI-generated patches.
You can comment on the patch as usual, syzbot will try to address
the comments and send a new version of the patch if necessary.
syzbot engineers can be reached at syzkaller@googlegroups.com.
