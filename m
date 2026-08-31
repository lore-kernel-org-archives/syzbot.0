Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3EBCC3A9630
	for <syzbot@lists.linux.dev>; Mon, 31 Aug 2026 22:13:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788214423; cv=none; b=Y2i7vqERzAytYcDhigzrLLy1XW8LBJNfglKJV1W8GXYYisxfv0CEEbaK62yD2oNhMLAvIeZQbQD6UALz2R8Wxalh6QWDozN43APcAlY3SHD32lNGfL2NCk3OIjQEdLJo8yzdLYCHvMHmEi9HqBzw9J4Zm7mRWwsdiklx+dWkrvc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788214423; c=relaxed/simple;
	bh=FKLlZBP/10iknUs0UppBNKk+BJoKJL6dIoqRWMgX2PY=;
	h=From:To:Cc:Subject:Message-ID:MIME-Version:Content-Type:Date; b=SCIKIdllFjeIf8WndpTg41g6GQYI/GH7sGFgUb4SzW0hbS6Chye3iMEBwiHLtSfSsyv0odsLaME/7nH5qSpp7y6opEy5KsxFEcegLBo/V1tHu5v52FKFVfvRDJywBPMzYQvbdH/DjPND3lE3NPSq61Orx6wow6b/EniKz9adPA8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=TirzmiXM; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="TirzmiXM"
Received: by smtp.kernel.org (Postfix) with UTF8SMTPSA id C3F161F000E9;
	Mon, 31 Aug 2026 22:13:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788214421;
	bh=OdMpRQpSyTRezLCPJUhmUJUOtB/FgjaCb4rt4Z6PPtg=;
	h=From:To:Cc:Subject:Date;
	b=TirzmiXMRxeA4pOBriq0I9QqJxWIzHNMio3HYIeVsD674ul5R/NnxTJKlYeNuLFUm
	 R5WDI2+NL5cdvNBXXbLUcie/ss4Lqc7IBeIWYxXEi6E1KsGD919mMIQ/i0tp/bi+AQ
	 LbHQSgq/5ein94tLLo11uCqsQ/21EBeOpTkwjktHq1Oys+w/Pf2cM4pWFwD+qxuyc/
	 wYXqSQmwhUPTx9IHH84xUxT9jFJATYb2B+cGUctqgsdSv6N6LZ0DVBKmkb5Q2ZGb84
	 jCloOm9dJa36H7EzmIN+y2qVpkmPAF7EoNfV31Nwp9J3ymepK477o2MgZABSvkPsKB
	 Sz5WvOjIny3ag==
From: "syzbot" <syzbot@kernel.org>
To: syzkaller-upstream-moderation@googlegroups.com
Cc: syzbot@lists.linux.dev
Subject: [PATCH RFC] net/sched: taprio: reject cycle_time smaller than sum of intervals
Message-ID: <3527dbf1-ab94-4184-8405-8552799efb71@mail.kernel.org>
Precedence: bulk
X-Mailing-List: syzbot@lists.linux.dev
List-Id: <syzbot.lists.linux.dev>
List-Subscribe: <mailto:syzbot+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:syzbot+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Date: Mon, 31 Aug 2026 22:13:41 +0000 (UTC)

When configuring a taprio schedule, if TCA_TAPRIO_ATTR_SCHED_CYCLE_TIME is
explicitly provided, parse_taprio_schedule() does not validate that
cycle_time is at least the sum of the schedule entries' intervals. If an
explicitly configured cycle_time is smaller than an entry's interval,
advance_sched() clamps the entry's end_time to oper->cycle_end_time via
min_t(ktime_t, end_time, oper->cycle_end_time).

When the timer fires at cycle_end_time, should_restart_cycle() returns
true, which restarts the cycle and advances oper->cycle_end_time by
cycle_time. If cycle_time is configured to an extremely small value (e.g.
64 ns), which is less than the CPU time required to execute the timer
callback itself, the newly calculated expiration time is always in the
past. Consequently, the hrtimer subsystem repeatedly and immediately
re-invokes advance_sched() in hardirq context, resulting in an interrupt
storm that starves the CPU and triggers RCU stalls:

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

Fix this by calculating the sum of intervals in parse_taprio_schedule()
unconditionally and rejecting configurations where an explicitly provided
cycle_time is less than the calculated sum with -EINVAL.

Fixes: 6ca6a6654225 ("taprio: Add support for setting the cycle-time manually")
Assisted-by: Gemini:gemini-3.7-flash Gemini:gemini-3.1-pro-preview syzbot
Reported-by: syzbot+14c6ac6811273526cfa5@syzkaller.appspotmail.com
Closes: https://syzkaller.appspot.com/bug?extid=14c6ac6811273526cfa5
Link: https://syzkaller.appspot.com/ai_job?id=f188bb15-dc33-47d1-92bf-7a65fde0fcd7
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
index 39ac5b97a..137ce6f7a 100644
--- a/net/sched/sch_taprio.c
+++ b/net/sched/sch_taprio.c
@@ -1130,6 +1130,8 @@ static int parse_taprio_schedule(struct taprio_sched *q, struct nlattr **tb,
 				 struct sched_gate_list *new,
 				 struct netlink_ext_ack *extack)
 {
+	struct sched_entry *entry;
+	ktime_t cycle = 0;
 	int err = 0;
 
 	if (tb[TCA_TAPRIO_ATTR_SCHED_SINGLE_ENTRY]) {
@@ -1152,19 +1154,20 @@ static int parse_taprio_schedule(struct taprio_sched *q, struct nlattr **tb,
 	if (err < 0)
 		return err;
 
-	if (!new->cycle_time) {
-		struct sched_entry *entry;
-		ktime_t cycle = 0;
-
-		list_for_each_entry(entry, &new->entries, list)
-			cycle = ktime_add_ns(cycle, entry->interval);
+	list_for_each_entry(entry, &new->entries, list)
+		cycle = ktime_add_ns(cycle, entry->interval);
 
-		if (cycle < 0 || cycle > INT_MAX) {
-			NL_SET_ERR_MSG(extack, "'cycle_time' is too big");
-			return -EINVAL;
-		}
+	if (cycle < 0 || cycle > INT_MAX) {
+		NL_SET_ERR_MSG(extack, "'cycle_time' is too big");
+		return -EINVAL;
+	}
 
+	if (!new->cycle_time)
 		new->cycle_time = cycle;
+
+	if (new->cycle_time < cycle) {
+		NL_SET_ERR_MSG(extack, "'cycle_time' is less than the sum of entry intervals");
+		return -EINVAL;
 	}
 
 	if (new->cycle_time < new->num_entries * length_to_duration(q, ETH_ZLEN)) {


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
