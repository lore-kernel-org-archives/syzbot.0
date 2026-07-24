Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EA1DD382383
	for <syzbot@lists.linux.dev>; Fri, 24 Jul 2026 20:21:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784924492; cv=none; b=HCPw3Xs5wPTWmv6MVyqysMnla/oCOUxKbKwQHuYC9CJ7ZmYFBEuC4xALaQ8i5yo33sgmpCnm5uJRavLRN0MpKlgsz50ELaHm3xHnLT2TYff976nwAaiES5j98YwIOecjjmJuJoz8svbj1/pWpEeX3OVywbi+NMNwAeWzYS4vC7Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784924492; c=relaxed/simple;
	bh=/CRPaoafAgOYNbkVK47FWhJHZy+/h6COZJEF0IG8pV4=;
	h=From:To:Cc:Subject:Message-ID:MIME-Version:Content-Type:Date; b=ARLI43l8bohZQB3KxxtdRBDGGMCNes1XeRGkg0vrmz08yYYItIhcejvz/Dda9RoX8+1k1EPxEg4sCV8UPT8cutdbBQ+G4CzCQHT7YDJIcT+Jv9bycH4Qku9b/0N3T1yV+CKiwNoNdBuUo3JNGA9xUvdsMDxs3PreD1BxRByPmAg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=cbSPVt0F; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="cbSPVt0F"
Received: by smtp.kernel.org (Postfix) with UTF8SMTPSA id 68DC41F000E9;
	Fri, 24 Jul 2026 20:21:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1784924490;
	bh=9z9RvM05ippi9hMY0pwqv7HNkXxai/COGYy4J4QLE3k=;
	h=From:To:Cc:Subject:Date;
	b=cbSPVt0FQUyxTZ/BncXeRqIPfyc8ZVAaTYM+10SW4oNT9fTkTWDkE8YxrkL8KdxEX
	 uqhR3XwilG20H+zuzAG5xXBSR3QKFwCxYHC2VJaYguXCqzxOjDcP2+PHOY8M5hOyYC
	 qB73P5jYZsJsVug+Ql5uMkzgfAVlBcopl6aROzntwLrdJi0PphC2PtBjFVQlo78AFH
	 /kf51yWjTwC+WlcJqN+zT96zBfbT+t+p/cZIy4+ryAhIZrfwmswHlgS/GbF2l/oEXJ
	 M6G1HOkN4jOcpNRDho7Lzx6GKNYLt7RvwMiRVYGf0ArqfKLnCFkZufbmJTndbVskDp
	 GXuqb5hJ3Lvnw==
From: "syzbot" <syzbot@kernel.org>
To: syzkaller-upstream-moderation@googlegroups.com
Cc: immersa.bartosz.chronowski@gmail.com, syzbot@lists.linux.dev
Subject: [PATCH RFC v2] net/sched: taprio: fix hrtimer interrupt storm on small intervals
Message-ID: <03dbde3b-8c45-46b6-8291-dd12bcc3120c@mail.kernel.org>
Precedence: bulk
X-Mailing-List: syzbot@lists.linux.dev
List-Id: <syzbot.lists.linux.dev>
List-Subscribe: <mailto:syzbot+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:syzbot+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Date: Fri, 24 Jul 2026 20:21:30 +0000 (UTC)

The taprio qdisc allows configuring extremely small intervals (e.g., 255
ns) which can completely overwhelm the CPU when using software timers. When
the interval is smaller than the time it takes to process the timer
interrupt, the timer's expiration time is always in the past. This causes
the hrtimer subsystem to continuously re-enqueue and fire the timer,
leading to an interrupt storm that starves the CPU and triggers an RCU
stall. While a 255 ns interval triggers this, the underlying issue is the
overdue-absolute-deadline invariant where the timer is repeatedly scheduled
in the past.

To fix this, we split the logical schedule deadline (`end_time`) from the
physical timer expiration (`expires`). In `advance_sched()`, we
fast-forward the schedule to the current time by skipping full cycles using
division, taking care not to overshoot the administrative schedule's base
time (`admin->base_time`). To prevent softirq stalls, we bound the state
work by capping the schedule advancement loop to 32 iterations. If we reach
this limit and the logical deadline is still in the past, we fall back to
requesting a later physical expiration relative to the timer queue's saved
comparison time, rather than yielding the CPU. This ensures the physical
timer queue can make progress.

Fixes: 5a781ccbd19e ("tc: Add support for configuring the taprio scheduler")
Assisted-by: Gemini:gemini-3.5-flash Gemini:gemini-3.1-pro-preview syzbot
Reported-by: syzbot+f8850bc3986562f79619@syzkaller.appspotmail.com
Closes: https://syzkaller.appspot.com/bug?extid=f8850bc3986562f79619
Link: https://syzkaller.appspot.com/ai_job?id=9ef6c8de-8e92-44a9-b075-955697b790a6
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
- Removed the 1 microsecond admission policy for software taprio.
- Reduced the loop iteration limit from 2048 to 32 to avoid softirq stalls.
- Added handling for administrative schedules during fast-forwarding to avoid overshooting `admin->base_time`.
- Split logical schedule deadline (`end_time`) and physical timer expiration (`expires`).
- Updated the fallback mechanism to request a physical expiration 1 microsecond in the future relative to the current time rather than yielding the CPU.
- Optimized gate close time calculation to only run once after the loop if not already calculated.

v1:
https://lore.kernel.org/all/bc6a8890-9230-489a-bbce-5c255c1ef01a@mail.kernel.org/T/
---
diff --git a/net/sched/sch_taprio.c b/net/sched/sch_taprio.c
index 299234a5f..8e8be568d 100644
--- a/net/sched/sch_taprio.c
+++ b/net/sched/sch_taprio.c
@@ -920,11 +920,16 @@ static enum hrtimer_restart advance_sched(struct hrtimer *timer)
 	struct taprio_sched *q = container_of(timer, struct taprio_sched,
 					      advance_timer);
 	struct net_device *dev = qdisc_dev(q->root);
+	bool gate_close_time_calculated = false;
 	struct sched_gate_list *oper, *admin;
 	int num_tc = netdev_get_num_tc(dev);
+	ktime_t now = taprio_get_time(q);
 	struct sched_entry *entry, *next;
 	struct Qdisc *sch = q->root;
+	/* Small retry bound to avoid softirq stall */
+	int max_iter = 32;
 	ktime_t end_time;
+	ktime_t expires;
 	int tc;
 
 	spin_lock(&q->current_entry_lock);
@@ -948,46 +953,86 @@ static enum hrtimer_restart advance_sched(struct hrtimer *timer)
 		next = list_first_entry(&oper->entries, struct sched_entry,
 					list);
 		end_time = next->end_time;
-		goto first_run;
+		gate_close_time_calculated = true;
+		if (ktime_after(end_time, now))
+			goto first_run;
+		entry = next;
 	}
 
-	if (should_restart_cycle(oper, entry)) {
-		next = list_first_entry(&oper->entries, struct sched_entry,
-					list);
-		oper->cycle_end_time = ktime_add_ns(oper->cycle_end_time,
-						    oper->cycle_time);
-	} else {
-		next = list_next_entry(entry, list);
-	}
+	do {
+		ktime_t limit = now;
 
-	end_time = ktime_add_ns(entry->end_time, next->interval);
-	end_time = min_t(ktime_t, end_time, oper->cycle_end_time);
+		if (admin && ktime_before(admin->base_time, limit))
+			limit = admin->base_time;
 
-	for (tc = 0; tc < num_tc; tc++) {
-		if (next->gate_duration[tc] == oper->cycle_time)
-			next->gate_close_time[tc] = KTIME_MAX;
-		else
-			next->gate_close_time[tc] = ktime_add_ns(entry->end_time,
-								 next->gate_duration[tc]);
-	}
+		if (oper->cycle_time && ktime_after(limit, oper->cycle_end_time)) {
+			s64 diff = ktime_sub(limit, oper->cycle_end_time);
+			s64 cycles = div64_s64(diff, oper->cycle_time) + 1;
 
-	if (should_change_schedules(admin, oper, end_time)) {
-		switch_schedules(q, &admin, &oper);
-		/* After changing schedules, the next entry is the first one
-		 * in the new schedule, with a pre-calculated end_time.
-		 */
-		next = list_first_entry(&oper->entries, struct sched_entry, list);
-		end_time = next->end_time;
+			oper->cycle_end_time =
+				ktime_add_ns(oper->cycle_end_time,
+					     cycles * oper->cycle_time);
+			entry->end_time = ktime_add_ns(entry->end_time,
+						       cycles * oper->cycle_time);
+		}
+
+		if (should_restart_cycle(oper, entry)) {
+			next = list_first_entry(&oper->entries,
+						struct sched_entry, list);
+			oper->cycle_end_time =
+				ktime_add_ns(oper->cycle_end_time,
+					     oper->cycle_time);
+		} else {
+			next = list_next_entry(entry, list);
+		}
+
+		end_time = ktime_add_ns(entry->end_time, next->interval);
+		end_time = min_t(ktime_t, end_time, oper->cycle_end_time);
+
+		if (should_change_schedules(admin, oper, end_time)) {
+			switch_schedules(q, &admin, &oper);
+			/* After changing schedules, the next entry is the first one
+			 * in the new schedule, with a pre-calculated end_time.
+			 */
+			next = list_first_entry(&oper->entries,
+						struct sched_entry, list);
+			end_time = next->end_time;
+			gate_close_time_calculated = true;
+		} else {
+			gate_close_time_calculated = false;
+		}
+
+		next->end_time = end_time;
+
+		if (ktime_after(end_time, now))
+			break;
+
+		entry = next;
+	} while (--max_iter > 0);
+
+	if (!gate_close_time_calculated) {
+		for (tc = 0; tc < num_tc; tc++) {
+			if (next->gate_duration[tc] == oper->cycle_time) {
+				next->gate_close_time[tc] = KTIME_MAX;
+			} else {
+				next->gate_close_time[tc] =
+					ktime_add_ns(entry->end_time,
+						     next->gate_duration[tc]);
+			}
+		}
 	}
 
-	next->end_time = end_time;
 	taprio_set_budgets(q, oper, next);
 
 first_run:
 	rcu_assign_pointer(q->current_entry, next);
 	spin_unlock(&q->current_entry_lock);
 
-	hrtimer_set_expires(&q->advance_timer, end_time);
+	expires = end_time;
+	if (unlikely(max_iter == 0 && ktime_before(expires, now)))
+		expires = ktime_add_ns(now, NSEC_PER_USEC);
+
+	hrtimer_set_expires(&q->advance_timer, expires);
 
 	rcu_read_lock();
 	__netif_schedule(sch);


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
