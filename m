Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 585CD263F4A
	for <syzbot@lists.linux.dev>; Wed, 24 Jun 2026 12:37:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782304636; cv=none; b=jP+mU0Tsh5FvMI0xa7Rq3jCOsSGAiUyyeSv41C6/VBZHeVdU2MlpZmbtRvJ2hPkcOeaaq89ucblHt/xaI8ggCOQeiLQnJ7kONtQ2a4LrLp0+lyGQmkYXftONc9McZS549B0tc3BVmyX638ZIA/4EC1JoOwoLZVPmoUJNWdvZMkI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782304636; c=relaxed/simple;
	bh=wWYNx3Q0y30P1Vc50fQyM9jo/s/sb1FZTjQCRMYv4/U=;
	h=From:To:Cc:Subject:Message-ID:MIME-Version:Content-Type:Date; b=iCuvN/RxwBtHGfS7gceMj28kSpmJCYPtYDmtJJykO11vEsc9zTraZk84yWKeoaC0j9sLqRjtr5ncoYc/b/rBBLozxJQM0hiwZ1N7rZLG0QcIkunMWreM/3FFz7bYZxJb/Zn7464IMUjmIaUlMGbErCafCR9xwOlKVYfwxBVRrXE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=kGQ75K2k; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="kGQ75K2k"
Received: by smtp.kernel.org (Postfix) with UTF8SMTPSA id E995F1F000E9;
	Wed, 24 Jun 2026 12:37:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1782304635;
	bh=YJFqMWQgCDlFZSB44flLCqabRzTkNaXSfIzunGZf85k=;
	h=From:To:Cc:Subject:Date;
	b=kGQ75K2kcTT0fjdqSTJMMTSs3w/IFaglT1nyg3Bseo6FH5vyF3igET85jzbNpTy69
	 qxwg0i7MgU3oVcJkPh1bUaaMnem5GOJvOQq59CVaE9aJsaHKIb6hFU96LqHnCSaNCv
	 O7N+i/OOjtNd2I6Y9OoZhfZ35evuaDXxcgit8MoQuNOVgHudE6+8y4fQSJj9LQzKjv
	 13nLnWlHLKuOLm3fkZb+odTd36WCIwX7Z1REzBHQUg9Ui40VCD3JS2rBST8iyOkp9g
	 5nCrCsOqtkbvnn+KU1hZk0ayDD//VJhZWqzaybrHjsjxhJs0UOGpIz6bOe+csC3qvU
	 zp/bQ4xvsTCAA==
From: "syzbot" <syzbot@kernel.org>
To: syzkaller-upstream-moderation@googlegroups.com
Cc: syzbot@lists.linux.dev
Subject: [PATCH RFC] wifi: mac80211: fix rate control warnings and out-of-bounds access
Message-ID: <f0aae0a5-4ec9-46ac-bd7e-bfbf91c4e1af@mail.kernel.org>
Precedence: bulk
X-Mailing-List: syzbot@lists.linux.dev
List-Id: <syzbot.lists.linux.dev>
List-Subscribe: <mailto:syzbot+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:syzbot+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Date: Wed, 24 Jun 2026 12:37:14 +0000 (UTC)

A warning in __rate_control_send_low() can be triggered when no supported
transmission rate is found for a frame. This condition is fully reachable
from user space by providing conflicting configurations, such as requesting
a non-CCK rate for a station that only supports CCK rates, or creating a
station with no supported rates.

WARNING: net/mac80211/rate.c:406 at __rate_control_send_low+0x524/0x800
net/mac80211/rate.c:401
...
Call Trace:
 rate_control_send_low+0xf9/0x7b0 net/mac80211/rate.c:429
 rate_control_get_rate+0x20b/0x5d0 net/mac80211/rate.c:943
 ieee80211_tx_h_rate_ctrl+0xafa/0x1760 net/mac80211/tx.c:764
 invoke_tx_handlers_late+0xb5/0x1830 net/mac80211/tx.c:1859
 ieee80211_tx+0x2d7/0x4b0 net/mac80211/tx.c:1983
 __ieee80211_tx_skb_tid_band+0x50f/0x680 net/mac80211/tx.c:6371
 ieee80211_tx_skb_tid_band net/mac80211/ieee80211_i.h:2456 [inline]
 ieee80211_send_scan_probe_req net/mac80211/scan.c:685 [inline]
 ieee80211_scan_state_send_probe+0x5b3/0xa00 net/mac80211/scan.c:713
 ieee80211_scan_work+0x488/0x1ab0 net/mac80211/scan.c:1174

Since WARN_ONCE must not be used for conditions that can legitimately
happen, and proper logging should be used instead, this is downgraded to a
wiphy_dbg message. The code already safely falls back to the lowest rate.

While investigating, a secondary bug was found. If a driver calls
ieee80211_get_tx_rates() with a custom dest array and dest[0].idx < 0,
__rate_control_send_low() updates info->control.rates[0].idx but does not
update dest[0].idx. Consequently, dest[0].idx remains < 0, leading to an
out-of-bounds array access when rate_fixup_ratelist() is subsequently
called. This is fixed by copying the updated rate back to dest if dest !=
info->control.rates.

Additionally, a WARN in ieee80211_tx_h_rate_ctrl() can be triggered when a
frame is sent to an associated station while scanning, but the station has
no usable bitrates on the current band. This is also user-triggerable by
scanning on a band where the target station has no supported rates. This
warning is similarly downgraded to a wiphy_dbg message, while keeping the
existing behavior of dropping the frame.

Fixes: 2103dec14792 ("mac80211: select and adjust bitrates according to channel mode")
Assisted-by: Gemini:gemini-3.1-pro-preview Gemini:gemini-3-flash-preview syzbot
Reported-by: syzbot+34463a129786910405dd@syzkaller.appspotmail.com
Closes: https://syzkaller.appspot.com/bug?extid=34463a129786910405dd
Link: https://syzkaller.appspot.com/ai_job?id=e8a36bfc-63cc-4c4b-922c-20a8151f983a
To: "Johannes Berg" <johannes@sipsolutions.net>
To: <linux-wireless@vger.kernel.org>
Cc: <linux-kernel@vger.kernel.org>

---
diff --git a/net/mac80211/rate.c b/net/mac80211/rate.c
index 31af7dd6a..1a9f9b3a7 100644
--- a/net/mac80211/rate.c
+++ b/net/mac80211/rate.c
@@ -398,12 +398,13 @@ static void __rate_control_send_low(struct ieee80211_hw *hw,
 		info->control.rates[0].idx = i;
 		break;
 	}
-	WARN_ONCE(i == sband->n_bitrates,
-		  "no supported rates for sta %pM (0x%x, band %d) in rate_mask 0x%x with flags 0x%x\n",
-		  sta ? sta->addr : NULL,
-		  sta ? sta->deflink.supp_rates[sband->band] : -1,
-		  sband->band,
-		  rate_mask, rate_flags);
+	if (i == sband->n_bitrates)
+		wiphy_dbg(
+			hw->wiphy,
+			"no supported rates for sta %pM (0x%x, band %d) in rate_mask 0x%x with flags 0x%x\n",
+			sta ? sta->addr : NULL,
+			sta ? sta->deflink.supp_rates[sband->band] : -1,
+			sband->band, rate_mask, rate_flags);
 
 	info->control.rates[0].count =
 		(info->flags & IEEE80211_TX_CTL_NO_ACK) ?
@@ -915,9 +916,12 @@ void ieee80211_get_tx_rates(struct ieee80211_vif *vif,
 	if (!(info->control.flags & IEEE80211_TX_CTRL_DONT_USE_RATE_MASK))
 		mask = sdata->rc_rateidx_mask[info->band];
 
-	if (dest[0].idx < 0)
+	if (dest[0].idx < 0) {
 		__rate_control_send_low(&sdata->local->hw, sband, sta, info,
 					mask);
+		if (dest != info->control.rates)
+			dest[0] = info->control.rates[0];
+	}
 
 	if (sta)
 		rate_fixup_ratelist(vif, sband, info, dest, max_rates);
diff --git a/net/mac80211/tx.c b/net/mac80211/tx.c
index ea7f63e1f..1a0a9333a 100644
--- a/net/mac80211/tx.c
+++ b/net/mac80211/tx.c
@@ -747,15 +747,17 @@ ieee80211_tx_h_rate_ctrl(struct ieee80211_tx_data *tx)
 	 * Lets not bother rate control if we're associated and cannot
 	 * talk to the sta. This should not happen.
 	 */
-	if (WARN(test_bit(SCAN_SW_SCANNING, &tx->local->scanning) && assoc &&
-		 !rate_usable_index_exists(sband, &tx->sta->sta),
-		 "%s: Dropped data frame as no usable bitrate found while "
-		 "scanning and associated. Target station: "
-		 "%pM on %d GHz band\n",
-		 tx->sdata->name,
-		 encap ? ((struct ethhdr *)hdr)->h_dest : hdr->addr1,
-		 info->band ? 5 : 2))
+	if (unlikely(test_bit(SCAN_SW_SCANNING, &tx->local->scanning) &&
+		     assoc &&
+		     !rate_usable_index_exists(sband, &tx->sta->sta))) {
+		wiphy_dbg(
+			tx->local->hw.wiphy,
+			"%s: Dropped data frame as no usable bitrate found while scanning and associated. Target station: %pM on %d GHz band\n",
+			tx->sdata->name,
+			encap ? ((struct ethhdr *)hdr)->h_dest : hdr->addr1,
+			info->band ? 5 : 2);
 		return TX_DROP;
+	}
 
 	/*
 	 * If we're associated with the sta at this point we know we can at


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
