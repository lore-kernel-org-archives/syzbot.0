Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 402B7524B03
	for <syzbot@lists.linux.dev>; Tue, 29 Sep 2026 13:06:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790687183; cv=none; b=iOSn4YwkT4kJThC5xkKaHsI0aZEaoTCt7y3FqFJvsggxL1HP+fni2zOA67t3myuoF8EdVwKCz3YiQJPcevlng2ewBXFWL4oskBanFZS2SHdReZ9gkQkI5tuKutoNAN29Y0/4VkbZRyBDmxSA8lM4vkMIapUKrIrr8GbK2oCs/3Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790687183; c=relaxed/simple;
	bh=GFaKYzW+9UZzufB3gwaLJPqSE1vAAt1ecUKDM/i43Q4=;
	h=From:To:Cc:Subject:Message-ID:MIME-Version:Content-Type:Date; b=Nm2NHhlNP4lFZeqfBKn8kpCFXkJjh5voPfoY+apO/hVcdBH3tOhUruxNo/sWDJvUrd9DffIj1Vv9W2BXjZgdmVxBUL5666en222hnfh+iFaTTCxyCkcCwnpU8u9YTsHO/K+q8jf/rLAdkrGufTRYHLAZ+OpyxKhZ8Wo1F2gpANw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=S9l7RRJF; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="S9l7RRJF"
Received: by smtp.kernel.org (Postfix) with UTF8SMTPSA id 134AC1F000FF;
	Tue, 29 Sep 2026 13:06:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1790687179;
	bh=j2m7dJW5tA+suRWZ+TnHe/8B8ijeiE8yLPytds3d8Cc=;
	h=From:To:Cc:Subject:Date;
	b=S9l7RRJFlptJ3rOkX/TWm3S4qZZiWPgHZqnCQb3k7CuoldsXOP/XlSFFKK1X2N5mC
	 IyKO4vsl+HhPb1eGddpuuaWtwqZMKx7T6yEqFbgnRlSvZCwSY23rAnpdAZXbxSRVuj
	 WYZe7A/YwgUVVvHI/5qeCV84sDKvxqg01jpZlpNS/oxpIuhJXX1n3pIAFlEBdag9IP
	 UKcD4MHteNj/JHri9xMFExZkZO1PjXG5WJf5o+9QouD/AIki9rx8TSvOjY6wJVwJZZ
	 bWbTQkTmRNasCYBORbxpJkrUKfnsUvXmWb1bJfp19It7Oa7/hJtSH3E7KhhhVGtKwz
	 U+5oCx9vPWIgA==
From: "syzbot" <syzbot@kernel.org>
To: syzkaller-upstream-moderation@googlegroups.com
Cc: immersa.bartosz.chronowski@gmail.com, syzbot@lists.linux.dev
Subject: [PATCH RFC v4] net/sched: taprio: catch up overdue cycles in advance_sched()
Message-ID: <a75dd710-09c2-4dce-bc7b-65fd6c4be4d8@mail.kernel.org>
Precedence: bulk
X-Mailing-List: syzbot@lists.linux.dev
List-Id: <syzbot.lists.linux.dev>
List-Subscribe: <mailto:syzbot+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:syzbot+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Date: Tue, 29 Sep 2026 13:06:19 +0000 (UTC)

The taprio qdisc allows configuring small intervals which can overwhelm the
CPU when using software timers. When the interval is shorter than the time
it takes to process the timer interrupt, or when the system experiences
scheduling delays, the timer expiration falls into the past. This
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

Fix this by implementing bounded catch-up in advance_sched() instead of
rejecting small intervals at admission time. When advance_sched() detects
that the timer expiration is overdue, complete schedule periods are skipped
arithmetically by advancing start_time, end_time, and oper->cycle_end_time
by the elapsed number of full cycles. Residual entry transitions are left
to subsequent callbacks to prevent unbounded replay while avoiding
multi-entry walks in a single callback that could circle back to an entry
visible to lockless dequeue readers.

Fixes: 5a781ccbd19e ("tc: Add support for configuring the taprio scheduler")
Assisted-by: Gemini:gemini-3.8-flash syzbot
Reported-by: syzbot+f8850bc3986562f79619@syzkaller.appspotmail.com
Closes: https://syzkaller.appspot.com/bug?extid=f8850bc3986562f79619
Link: https://syzkaller.appspot.com/ai_job?id=337aa421-80c1-40fd-a577-eb7fe10007fe
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
v4:
- Replace admission-time interval rejection with bounded catch-up in advance_sched().
- Arithmetically advance overdue full periods instead of walking individual entries.
- Record cycle_interval_sum in parse_taprio_schedule() to determine the cycle period.
- Set timer expiration before releasing current_entry_lock.

v3:
- Reject intervals smaller than 100 us at admission time for software TAPRIO schedules instead of modifying advance_sched().
- Drop catch-up cycle arithmetic, loop iteration limits, and physical expiration fallbacks from advance_sched().
https://lore.kernel.org/all/ecbfe945-f1ab-45de-aaa0-b9b57ae730c2@mail.kernel.org/T/

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
index 299234a5f..2f73c7a84 100644
--- a/net/sched/sch_taprio.c
+++ b/net/sched/sch_taprio.c
@@ -83,6 +83,7 @@ struct sched_gate_list {
 	s64 cycle_time;
 	s64 cycle_time_extension;
 	s64 base_time;
+	s64 cycle_interval_sum;
 };
 
 struct taprio_sched {
@@ -924,7 +925,8 @@ static enum hrtimer_restart advance_sched(struct hrtimer *timer)
 	int num_tc = netdev_get_num_tc(dev);
 	struct sched_entry *entry, *next;
 	struct Qdisc *sch = q->root;
-	ktime_t end_time;
+	ktime_t start_time, end_time, now;
+	s64 period;
 	int tc;
 
 	spin_lock(&q->current_entry_lock);
@@ -951,6 +953,8 @@ static enum hrtimer_restart advance_sched(struct hrtimer *timer)
 		goto first_run;
 	}
 
+	start_time = entry->end_time;
+
 	if (should_restart_cycle(oper, entry)) {
 		next = list_first_entry(&oper->entries, struct sched_entry,
 					list);
@@ -960,15 +964,22 @@ static enum hrtimer_restart advance_sched(struct hrtimer *timer)
 		next = list_next_entry(entry, list);
 	}
 
-	end_time = ktime_add_ns(entry->end_time, next->interval);
-	end_time = min_t(ktime_t, end_time, oper->cycle_end_time);
+	if (next->interval > ktime_sub(oper->cycle_end_time, start_time))
+		end_time = oper->cycle_end_time;
+	else
+		end_time = ktime_add_ns(start_time, next->interval);
 
-	for (tc = 0; tc < num_tc; tc++) {
-		if (next->gate_duration[tc] == oper->cycle_time)
-			next->gate_close_time[tc] = KTIME_MAX;
-		else
-			next->gate_close_time[tc] = ktime_add_ns(entry->end_time,
-								 next->gate_duration[tc]);
+	period = min_t(s64, oper->cycle_time, oper->cycle_interval_sum);
+
+	now = hrtimer_cb_get_time(timer);
+	if (period > 0 && ktime_after(now, end_time)) {
+		s64 diff = ktime_to_ns(ktime_sub(now, end_time));
+		s64 periods = div64_s64(diff, period);
+		s64 delta = periods * period;
+
+		start_time = ktime_add_ns(start_time, delta);
+		end_time = ktime_add_ns(end_time, delta);
+		oper->cycle_end_time = ktime_add_ns(oper->cycle_end_time, delta);
 	}
 
 	if (should_change_schedules(admin, oper, end_time)) {
@@ -978,16 +989,23 @@ static enum hrtimer_restart advance_sched(struct hrtimer *timer)
 		 */
 		next = list_first_entry(&oper->entries, struct sched_entry, list);
 		end_time = next->end_time;
-	}
+	} else {
+		for (tc = 0; tc < num_tc; tc++) {
+			if (next->gate_duration[tc] == oper->cycle_time)
+				next->gate_close_time[tc] = KTIME_MAX;
+			else
+				next->gate_close_time[tc] = ktime_add_ns(start_time,
+									 next->gate_duration[tc]);
+		}
 
-	next->end_time = end_time;
-	taprio_set_budgets(q, oper, next);
+		next->end_time = end_time;
+		taprio_set_budgets(q, oper, next);
+	}
 
 first_run:
 	rcu_assign_pointer(q->current_entry, next);
-	spin_unlock(&q->current_entry_lock);
-
 	hrtimer_set_expires(&q->advance_timer, end_time);
+	spin_unlock(&q->current_entry_lock);
 
 	rcu_read_lock();
 	__netif_schedule(sch);
@@ -1151,19 +1169,23 @@ static int parse_taprio_schedule(struct taprio_sched *q, struct nlattr **tb,
 	if (err < 0)
 		return err;
 
-	if (!new->cycle_time) {
+	{
 		struct sched_entry *entry;
 		ktime_t cycle = 0;
 
 		list_for_each_entry(entry, &new->entries, list)
 			cycle = ktime_add_ns(cycle, entry->interval);
 
-		if (cycle < 0 || cycle > INT_MAX) {
-			NL_SET_ERR_MSG(extack, "'cycle_time' is too big");
-			return -EINVAL;
-		}
+		new->cycle_interval_sum = cycle;
+
+		if (!new->cycle_time) {
+			if (cycle < 0 || cycle > INT_MAX) {
+				NL_SET_ERR_MSG(extack, "'cycle_time' is too big");
+				return -EINVAL;
+			}
 
-		new->cycle_time = cycle;
+			new->cycle_time = cycle;
+		}
 	}
 
 	if (new->cycle_time < new->num_entries * length_to_duration(q, ETH_ZLEN)) {


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
