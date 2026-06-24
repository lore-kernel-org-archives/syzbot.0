Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4C03A288C30
	for <syzbot@lists.linux.dev>; Wed, 24 Jun 2026 11:54:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782302086; cv=none; b=ZjTTlm/qtBa5QvFffgA1/aUf7zdpnV85ybaoUP5YOowGODQYvvuHeQUPesIDiCM8EqXl2oH2v1EqMNYQ9Gpf6Hyt9/g3ulBsSZdFcKDOyeuYxmUtd0f+ghHyZm8V9khBooSc/SrEZoYLgikW70tzMF+BOXCaDcWhSbSCKe06EfM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782302086; c=relaxed/simple;
	bh=DPhIQLxQ2ZgmAt2vi+pC3cNvHS9XpyUt1ZrO8a0oJZs=;
	h=From:To:Cc:Subject:Message-ID:MIME-Version:Content-Type:Date; b=hi4oNx3aYe5ZpNDHV3eVkCaUIYmFUbS4mJFndBFiiaxmg5UxxboPP8EXuuOCZ5L8wuGdeTB/DkbFd2/i+Ob2IxPM1sXs1h8EXzBSGBnAgNwtxbj/VHSJeQqqZdci3GumljTh+VN2B1dXnHYrCAba2kSsu40ZMomuMYOKFxbELbY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=aTMdPZCy; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="aTMdPZCy"
Received: by smtp.kernel.org (Postfix) with UTF8SMTPSA id D53751F000E9;
	Wed, 24 Jun 2026 11:54:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1782302084;
	bh=iv1kQMCRkJQnRbnAE9FkN2EP9jP4J/U4KtCnMEmbhHU=;
	h=From:To:Cc:Subject:Date;
	b=aTMdPZCyxO07MY+z/ixLlFj6i9qM9Zq1OoGaIQV4iFEYB4ff9AT64shfHFvX2kdLJ
	 8y3fhzrdCD79NOQnzhx61lU6VaswjVFE54g351+05aOdrFdz2XKfe8DUSEPOQIcPG0
	 be4s/krGrIHcNqgknsd+NoCcFCmyBDBT580VdosuXOJOp9NDu/P74/xAn3DIcw1/Vv
	 Twuud+La+EVTdWduwrShC6+LZfrJRXxr1Tej5ifaFc15UxYRX8Nww4Eg6s0Y2C8Ma/
	 iyy+91b6mxnS4AALI31thDj5XCFHXMqLdv4yz/uHgjAtof1f9gnrLaARzX9OjFBzB3
	 FSa/LF1zNeo8Q==
From: "syzbot" <syzbot@kernel.org>
To: syzkaller-upstream-moderation@googlegroups.com
Cc: syzbot@lists.linux.dev
Subject: [PATCH RFC] wifi: mac80211: fix userspace-triggerable warnings in TX rate control
Message-ID: <80ceeed0-d1a1-44a9-9a1b-ce88c4a8dc94@mail.kernel.org>
Precedence: bulk
X-Mailing-List: syzbot@lists.linux.dev
List-Id: <syzbot.lists.linux.dev>
List-Subscribe: <mailto:syzbot+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:syzbot+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Date: Wed, 24 Jun 2026 11:54:44 +0000 (UTC)

Userspace can intentionally trigger warnings in the mac80211 TX rate
control code by providing conflicting constraints. For example, sending a
scan request with the NL80211_ATTR_TX_NO_CCK_RATE attribute to a station
that only supports CCK rates, or scanning on a band where the associated
station has no supported rates. Since these conditions can legitimately
happen due to userspace actions, they should not trigger kernel warnings.

When this occurs, the kernel fails to find a valid transmission rate and
triggers warnings in __rate_control_send_low() and
ieee80211_tx_h_rate_ctrl():

WARNING: net/mac80211/rate.c:406 at __rate_control_send_low+0x524/0x800
net/mac80211/rate.c:401
Call Trace:
 rate_control_send_low+0xf9/0x7b0 net/mac80211/rate.c:429
 rate_control_get_rate+0x20b/0x5d0 net/mac80211/rate.c:943
 ieee80211_tx_h_rate_ctrl+0xafa/0x1760 net/mac80211/tx.c:764
 invoke_tx_handlers_late+0xb5/0x1830 net/mac80211/tx.c:1859
 ieee80211_tx+0x2d7/0x4b0 net/mac80211/tx.c:1983

WARNING: net/mac80211/tx.c:757 at ieee80211_tx_h_rate_ctrl+0xbd5/0x1760
net/mac80211/tx.c:750
Call Trace:
 invoke_tx_handlers_late+0xb5/0x1830 net/mac80211/tx.c:1859
 ieee80211_tx+0x2d7/0x4b0 net/mac80211/tx.c:1983

To fix this, downgrade the WARN and WARN_ONCE macros to wiphy_dbg() prints,
as WARN macros must not be used for conditions that can legitimately
happen, and debug prints or pr_err should be used instead. Additionally,
gracefully handle the empty rate intersection by initializing
info->control.rates[0].idx to -1 before the loop in
__rate_control_send_low(). This allows the caller to cleanly drop the
packet. A check for rates[0].idx >= 0 is also added in
rate_fixup_ratelist() to prevent out-of-bounds array accesses when the
negative index propagates.

Fixes: 1431fcb74eb5 ("mac80211: fix honouring rate flags in low-rate transmit")
Assisted-by: Gemini:gemini-3.1-pro-preview syzbot
Reported-by: syzbot+0d516b33238bd97ee864@syzkaller.appspotmail.com
Closes: https://syzkaller.appspot.com/bug?extid=0d516b33238bd97ee864
Link: https://syzkaller.appspot.com/ai_job?id=81a658c5-b33e-4f9e-bd55-7b412c8c484f
To: "Johannes Berg" <johannes@sipsolutions.net>
To: <linux-wireless@vger.kernel.org>
Cc: <linux-kernel@vger.kernel.org>

---
diff --git a/net/mac80211/rate.c b/net/mac80211/rate.c
index 31af7dd6a..17d2f7fac 100644
--- a/net/mac80211/rate.c
+++ b/net/mac80211/rate.c
@@ -384,7 +384,7 @@ static void __rate_control_send_low(struct ieee80211_hw *hw,
 	    (info->flags & IEEE80211_TX_CTL_NO_CCK_RATE))
 		rate_flags |= IEEE80211_RATE_ERP_G;
 
-	info->control.rates[0].idx = 0;
+	info->control.rates[0].idx = -1;
 	for (i = 0; i < sband->n_bitrates; i++) {
 		if (!(rate_mask & BIT(i)))
 			continue;
@@ -398,12 +398,14 @@ static void __rate_control_send_low(struct ieee80211_hw *hw,
 		info->control.rates[0].idx = i;
 		break;
 	}
-	WARN_ONCE(i == sband->n_bitrates,
-		  "no supported rates for sta %pM (0x%x, band %d) in rate_mask 0x%x with flags 0x%x\n",
-		  sta ? sta->addr : NULL,
-		  sta ? sta->deflink.supp_rates[sband->band] : -1,
-		  sband->band,
-		  rate_mask, rate_flags);
+
+	if (i == sband->n_bitrates)
+		wiphy_dbg(
+			hw->wiphy,
+			"no supported rates for sta %pM (0x%x, band %d) in rate_mask 0x%x with flags 0x%x\n",
+			sta ? sta->addr : NULL,
+			sta ? sta->deflink.supp_rates[sband->band] : -1,
+			sband->band, rate_mask, rate_flags);
 
 	info->control.rates[0].count =
 		(info->flags & IEEE80211_TX_CTL_NO_ACK) ?
@@ -654,7 +656,8 @@ static void rate_fixup_ratelist(struct ieee80211_vif *vif,
 	 *
 	 * XXX: Should this check all retry rates?
 	 */
-	if (!(rates[0].flags &
+	if (rates[0].idx >= 0 &&
+	    !(rates[0].flags &
 	      (IEEE80211_TX_RC_MCS | IEEE80211_TX_RC_VHT_MCS))) {
 		u32 basic_rates = vif->bss_conf.basic_rates;
 		s8 baserate = basic_rates ? ffs(basic_rates) - 1 : 0;
diff --git a/net/mac80211/tx.c b/net/mac80211/tx.c
index ea7f63e1f..126596102 100644
--- a/net/mac80211/tx.c
+++ b/net/mac80211/tx.c
@@ -747,15 +747,19 @@ ieee80211_tx_h_rate_ctrl(struct ieee80211_tx_data *tx)
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
+			"%s: Dropped data frame as no usable bitrate found while "
+			"scanning and associated. Target station: "
+			"%pM on %d GHz band\n",
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
