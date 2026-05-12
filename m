Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C78D236F900
	for <syzbot@lists.linux.dev>; Tue, 12 May 2026 09:18:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778577538; cv=none; b=tFppgRmVrrSGakq6/orG1bPd790hKb4kxAfJc8PmAngMNPq/+GYsICz3iRXCKJEYIK3uwmVS+VG6aW07wxboTpqnfFThd/fhoNqyPH6LwYEktD03WuNCuQCyelnDgdmrp7LHmEU08WULGUi6FPiL3CSbuXDi/FhAJ831qw8PvbM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778577538; c=relaxed/simple;
	bh=H9274P2pQQfK+XiWFyg5BGcvYDvDnt6x0KXjXMstsQo=;
	h=From:To:Cc:Subject:Message-ID:MIME-Version:Content-Type:Date; b=jg2fwl3hfd6bl7NTmYuLvTs9eP+QW/MomdpFwejWdbFUm7+WLoa+yMh9ZOani00pZr7UvajgWHZ6abY1NjSkXwvMhtMgZpR2UhC31vCrQuUEvQrvTtWOMRc9AWfwV6IvTEYoL3SXFj6O6UySBMWSz4ud2RXKb+NA7SJ+lcoCRcQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=owQgUQQW; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="owQgUQQW"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5B501C2BCB0;
	Tue, 12 May 2026 09:18:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1778577538;
	bh=H9274P2pQQfK+XiWFyg5BGcvYDvDnt6x0KXjXMstsQo=;
	h=From:To:Cc:Subject:Date:From;
	b=owQgUQQWwMRAjU5GptOlJmLPIodOalytBvFGVFW7ZEi4n4il0k2HShHI8bpGCav/Z
	 pz/gXMFID35g/t7eosjbKmqGVeVPvU6kkTMRoNdDF9wphYz2diTrYhiCTYdQ/h3nPH
	 cFhNRQzZnth0OSeAggj/qqB455Qam/2XZQMxqHk9+1S3+Ta5igO98eeJeszcotgaIl
	 YIf0U7DnR796uCvYJexkCEBsC/Wp3lwxawBs9Gq8vs3dsElwaXaYIBI1Sp+adTQzTZ
	 ymctLCvvjqCilEKgKOAm1USFOhtyfcmoAgJCZEWkcXJeulndAgZByzuAjRPNMYXCpC
	 oyCil9iwf5SOw==
From: "syzbot" <syzbot@kernel.org>
To: syzkaller-upstream-moderation@googlegroups.com
Cc: syzbot@lists.linux.dev
Subject: [PATCH RFC] wifi: mac80211: fix spurious hw_roc_done and jiffies math bugs
Message-ID: <f3f399f3-dd15-48a5-bd32-928c27f91522@mail.kernel.org>
Precedence: bulk
X-Mailing-List: syzbot@lists.linux.dev
List-Id: <syzbot.lists.linux.dev>
List-Subscribe: <mailto:syzbot+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:syzbot+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Date: Tue, 12 May 2026 09:18:58 +0000 (UTC)

wifi: mac80211: fix spurious hw_roc_done and jiffies math bugs

The crash is caused by a race condition between the start of a new
Remain-On-Channel (ROC) operation and the processing of a "done"
notification from a previous ROC, combined with a jiffies math bug when
evaluating uninitialized timestamps.

When a previous ROC finishes or is cancelled, `local->hw_roc_done` is
queued. Before it is processed, a new ROC request can arrive, which is
initialized and added to `local->roc_list` with `roc->started = true`,
but `roc->hw_begun = false` and `roc->start_time = 0`. When
`ieee80211_hw_roc_done` runs, it calls `ieee80211_end_finished_rocs`,
which calculates the remaining time for the new ROC. Since `start_time`
is 0, the remaining time evaluates to a large positive number shortly
after boot due to negative jiffies. This prevents the new ROC from being
destroyed. Then `ieee80211_start_next_roc` is called, which sees the new
ROC with `roc->started == true` and triggers a `WARN_ON_ONCE`.

To fix this, we address several issues. First, in
`ieee80211_start_next_roc`, replace `WARN_ON_ONCE(roc->started)` with a
`pr_err` and return. Spurious `hw_roc_done` executions can legitimately
happen due to race conditions (e.g., if `hw_roc_done` is already
dequeued and blocked on the wiphy mutex, or if the driver asynchronously
calls `cfg80211_remain_on_channel_expired` after cancellation), and
WARN_ON must not be used for conditions that can legitimately happen.
Second, in `ieee80211_end_finished_rocs`, skip `start_time` math for
hardware ROCs. They are now only destroyed if `roc->abort` or
`roc->hw_begun` is true, preventing the `start_time == 0` underflow bug.
Third, in `ieee80211_coalesce_hw_started_roc`, fix the `start_time` math
bug by checking `!cur_roc->hw_begun` and using `time_after`, and set
`new_roc->started = true` when coalescing so `ieee80211_hw_roc_start`
doesn't break early. Finally, in `ieee80211_roc_purge`, add robust
cleanup logic (flushing `hw_roc_start`, cancelling `hw_roc_done`, and
calling `ieee80211_start_next_roc`) to minimize the window for spurious
executions.

Fixes: aaa016ccd5df89d73483d0d51ee1f692978ccc35 ("mac80211: rewrite remain-on-channel logic")
Assisted-by: Gemini:gemini-3.1-pro-preview Gemini:gemini-3-flash-preview
Reported-by: syzbot+c3a167b5615df4ccd7fb@syzkaller.appspotmail.com
Link: https://syzkaller.appspot.com/bug?extid=c3a167b5615df4ccd7fb
Link: https://syzkaller.appspot.com/ai_job?id=bd9f359e-45da-4c00-971f-c03b5cbaac85
To: <johannes@sipsolutions.net>
To: <linux-wireless@vger.kernel.org>
Cc: <linux-kernel@vger.kernel.org>

---
diff --git a/net/mac80211/offchannel.c b/net/mac80211/offchannel.c
index f60f6a589..47153ee30 100644
--- a/net/mac80211/offchannel.c
+++ b/net/mac80211/offchannel.c
@@ -205,15 +205,21 @@ static unsigned long ieee80211_end_finished_rocs(struct ieee80211_local *local,
 		if (!roc->started)
 			break;
 
+		if (local->ops->remain_on_channel) {
+			/* In case of HW ROC, it is possible that the HW finished the
+			 * ROC session before the actual requested time. In such a case
+			 * end the ROC session (disregarding the remaining time).
+			 */
+			if (roc->abort || roc->hw_begun)
+				ieee80211_roc_notify_destroy(roc);
+			continue;
+		}
+
 		remaining = roc->start_time +
 			    msecs_to_jiffies(roc->duration) -
 			    now;
 
-		/* In case of HW ROC, it is possible that the HW finished the
-		 * ROC session before the actual requested time. In such a case
-		 * end the ROC session (disregarding the remaining time).
-		 */
-		if (roc->abort || roc->hw_begun || remaining <= 0)
+		if (roc->abort || remaining <= 0)
 			ieee80211_roc_notify_destroy(roc);
 		else
 			remaining_dur_min = min(remaining_dur_min, remaining);
@@ -401,8 +407,10 @@ void ieee80211_start_next_roc(struct ieee80211_local *local)
 	roc = list_first_entry(&local->roc_list, struct ieee80211_roc_work,
 			       list);
 
-	if (WARN_ON_ONCE(roc->started))
+	if (roc->started) {
+		pr_err("mac80211: ROC is already started (spurious hw_roc_done?)\n");
 		return;
+	}
 
 	if (local->ops->remain_on_channel) {
 		_ieee80211_start_next_roc(local);
@@ -532,19 +540,26 @@ ieee80211_coalesce_hw_started_roc(struct ieee80211_local *local,
 	/* if it was scheduled in the hardware, but not started yet,
 	 * we can only combine if the older one had a longer duration
 	 */
-	if (!cur_roc->hw_begun && new_roc->duration > cur_roc->duration)
-		return false;
+	if (!cur_roc->hw_begun) {
+		if (new_roc->duration > cur_roc->duration)
+			return false;
+	} else {
+		unsigned long end_time = cur_roc->start_time +
+					 msecs_to_jiffies(cur_roc->duration);
 
-	remaining = cur_roc->start_time +
-		    msecs_to_jiffies(cur_roc->duration) -
-		    now;
+		if (time_after(now, end_time))
+			return false;
 
-	/* if it doesn't fit entirely, schedule a new one */
-	if (new_roc->duration > jiffies_to_msecs(remaining))
-		return false;
+		remaining = end_time - now;
+
+		/* if it doesn't fit entirely, schedule a new one */
+		if (new_roc->duration > jiffies_to_msecs(remaining))
+			return false;
+	}
 
 	/* add just after the current one so we combine their finish later */
 	list_add(&new_roc->list, &cur_roc->list);
+	new_roc->started = true;
 
 	/* if the existing one has already begun then let this one also
 	 * begin, otherwise they'll both be marked properly by the work
@@ -1068,9 +1083,12 @@ void ieee80211_roc_purge(struct ieee80211_local *local,
 {
 	struct ieee80211_roc_work *roc, *tmp;
 	bool work_to_do = false;
+	bool hw_roc_cancelled = false;
 
 	lockdep_assert_wiphy(local->hw.wiphy);
 
+	wiphy_work_flush(local->hw.wiphy, &local->hw_roc_start);
+
 	list_for_each_entry_safe(roc, tmp, &local->roc_list, list) {
 		if (sdata && roc->sdata != sdata)
 			continue;
@@ -1080,6 +1098,7 @@ void ieee80211_roc_purge(struct ieee80211_local *local,
 				/* can race, so ignore return value */
 				drv_cancel_remain_on_channel(local, roc->sdata);
 				ieee80211_roc_notify_destroy(roc);
+				hw_roc_cancelled = true;
 			} else {
 				roc->abort = true;
 				work_to_do = true;
@@ -1088,6 +1107,12 @@ void ieee80211_roc_purge(struct ieee80211_local *local,
 			ieee80211_roc_notify_destroy(roc);
 		}
 	}
+
+	if (hw_roc_cancelled) {
+		wiphy_work_cancel(local->hw.wiphy, &local->hw_roc_done);
+		ieee80211_start_next_roc(local);
+	}
+
 	if (work_to_do)
 		__ieee80211_roc_work(local);
 }


base-commit: 5d6919055dec134de3c40167a490f33c74c12581
-- 
This is an AI-generated patch subject to moderation.
Reply with '#syz upstream' to send it to the mailing list.
Reply with '#syz reject' to reject it.

See  for more information.
