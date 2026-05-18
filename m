Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 97F402ECEB9
	for <syzbot@lists.linux.dev>; Mon, 18 May 2026 20:10:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779135027; cv=none; b=ui08sZM5788Pl8gy8tsc+3arEWHFEKQyVVwjQxzgjGaCONKfCJNcv1nANABNnsre5yzURYGmgN6AQi9yK77Dysc5euGuB7SCkVXeQA6jABNd8+uk/S2kTiFs39T8hLs5vOcL1OTUEkSNT1uzvv8/fVBEg3kRIVUkXkXg6sXw+nU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779135027; c=relaxed/simple;
	bh=TSwDZ8YKdMvFQ9/nWd2PB72iNF87LRppKLgNScd68As=;
	h=From:To:Cc:Subject:Message-ID:MIME-Version:Content-Type:Date; b=eWWl1FXF93glLkFaZPrMtaK0GN0Gv2GsPWedfsERPH7rUq8Z+zSINGLE3tHuDTylTF3UHvLumQz7sAgrVqd+DadARZu0Mf36WLRzcL8yk9PYr42jcEVe1nEOcW8ZP1MIZz4rFYDK88yp5GOxp/nKQrh+CVpDhOGaJ3jYvTVurfs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=iiOvNzuV; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="iiOvNzuV"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 26896C2BCB7;
	Mon, 18 May 2026 20:10:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1779135027;
	bh=TSwDZ8YKdMvFQ9/nWd2PB72iNF87LRppKLgNScd68As=;
	h=From:To:Cc:Subject:Date:From;
	b=iiOvNzuVR7MXiLJvaXXyseLfwgr+6WvBjFWjp4ySe/VOllYbz0GwviOD69sLxRzS2
	 rRPs4jF56SDeMTx9FzRTcEdc7PY5oYjkI7hL0pf+Nqc5/G/AYtfzRZ3xuBbMsKLx6a
	 ZsvMZdqC8v6nLHbZu8JD0z41BxYIMvWmnMULo35c5++Nw+MKlwxQB/StBxoWH2s71/
	 PTYnrwswjCTtOLvPqcQoDARsytB1O04zru0UWP6imp+HomZOYgFIGb4W1fkL1QlxFS
	 C633hkwolBtsWZPkdRrLScbOz/yknRNuF//8cKysH1vBiisqUGBoSwhE9UHTkH5CZZ
	 7rCsPegeWig+w==
From: "syzbot" <syzbot@kernel.org>
To: syzkaller-upstream-moderation@googlegroups.com
Cc: syzbot@lists.linux.dev
Subject: [PATCH RFC] net/sched: taprio: fix RCU stall from hrtimer interrupt storm
Message-ID: <87315a23-8bfb-496e-bbd6-aae43537b95f@mail.kernel.org>
Precedence: bulk
X-Mailing-List: syzbot@lists.linux.dev
List-Id: <syzbot.lists.linux.dev>
List-Subscribe: <mailto:syzbot+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:syzbot+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Date: Mon, 18 May 2026 20:10:27 +0000 (UTC)

The taprio qdisc uses an hrtimer (`q->advance_timer`) configured with
`HRTIMER_MODE_ABS` to advance its schedule. In the timer callback
`advance_sched()`, the next expiration time (`end_time`) is calculated
by adding the next entry's interval to the current entry's `end_time`.

When the taprio qdisc is configured with a software schedule using
`CLOCK_REALTIME`, a massive forward clock jump (e.g., via
`clock_adjtime()`) can cause the calculated `end_time` to remain far in
the past compared to the new current time. `advance_sched()` then
returns `HRTIMER_RESTART`, causing the hrtimer subsystem to re-arm the
timer with this past expiration time. Because the timer is armed in the
past, it fires immediately upon returning from the interrupt handler.
The CPU gets stuck in a tight loop of handling timer interrupts,
advancing the schedule by a tiny amount each time, trying to catch up to
the present time. This enormous number of iterations starves the CPU and
triggers an `rcu_preempt` stall.

Fix this by detecting if `entry->end_time` is significantly in the past
compared to the current time, and mathematically skipping the missed
cycles instead of simulating them one by one. Since the schedule is
periodic with `oper->cycle_time`, we can calculate the number of missed
cycles `N = (now - entry->end_time) / oper->cycle_time`, and advance
both `entry->end_time` and `oper->cycle_end_time` by `N *
oper->cycle_time`. This preserves the alignment of the schedule and
bounds the number of catch-up iterations to at most `num_entries`,
completely eliminating the interrupt storm.

Modifying `entry->end_time` in place is safe because `advance_sched()`
holds the `q->current_entry_lock` spinlock, and `entry->end_time` is
strictly private to `advance_sched()` and schedule initialization.
`oper->cycle_time` is guaranteed to be strictly positive.

Fixes: 5a781ccbd19e4664babcbe4b4ead7aa2b9283d22 ("tc: Add support for configuring the taprio scheduler")
Assisted-by: Gemini:gemini-3.1-pro-preview
Reported-by: syzbot+111bc509cd9740d7e4aa@syzkaller.appspotmail.com
Link: https://syzkaller.appspot.com/bug?extid=111bc509cd9740d7e4aa
Link: https://syzkaller.appspot.com/ai_job?id=fab5d00a-34aa-4aad-b618-10b0abf66721
To: <davem@davemloft.net>
To: <edumazet@google.com>
To: <jhs@mojatatu.com>
To: <jiri@resnulli.us>
To: <kuba@kernel.org>
To: <netdev@vger.kernel.org>
To: <pabeni@redhat.com>
To: <vinicius.gomes@intel.com>
Cc: <horms@kernel.org>
Cc: <linux-kernel@vger.kernel.org>

---
diff --git a/net/sched/sch_taprio.c b/net/sched/sch_taprio.c
index 45245157e..20f9e536f 100644
--- a/net/sched/sch_taprio.c
+++ b/net/sched/sch_taprio.c
@@ -924,7 +924,7 @@ static enum hrtimer_restart advance_sched(struct hrtimer *timer)
 	int num_tc = netdev_get_num_tc(dev);
 	struct sched_entry *entry, *next;
 	struct Qdisc *sch = q->root;
-	ktime_t end_time;
+	ktime_t end_time, now;
 	int tc;
 
 	spin_lock(&q->current_entry_lock);
@@ -960,6 +960,20 @@ static enum hrtimer_restart advance_sched(struct hrtimer *timer)
 		next = list_next_entry(entry, list);
 	}
 
+	/* Catch up if the clock jumped forward */
+	now = taprio_get_time(q);
+	if (unlikely(ktime_before(entry->end_time, now))) {
+		s64 n = div64_s64(ktime_sub(now, entry->end_time),
+				  oper->cycle_time);
+
+		if (n > 0) {
+			oper->cycle_end_time = ktime_add_ns(
+				oper->cycle_end_time, n * oper->cycle_time);
+			entry->end_time = ktime_add_ns(entry->end_time,
+						       n * oper->cycle_time);
+		}
+	}
+
 	end_time = ktime_add_ns(entry->end_time, next->interval);
 	end_time = min_t(ktime_t, end_time, oper->cycle_end_time);
 


base-commit: 5200f5f493f79f14bbdc349e402a40dfb32f23c8
-- 
This is an AI-generated patch subject to moderation.
Reply with '#syz upstream' to send it to the mailing list.
Reply with '#syz reject' to reject it.

See  for more information.
