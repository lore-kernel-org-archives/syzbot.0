Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 692803AD525
	for <syzbot@lists.linux.dev>; Wed, 15 Jul 2026 16:56:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784134566; cv=none; b=a49KcebV3iZXlfvcOZHEKW9O5sshBnmgNAJU7wjF01D3Jgw9EFRuP6B9AvWUvtBrmNUX4XZi8ZtgYMuS1jbXtHrqsdDsB/8ofk582z8VVvdMT11WG2O1UjJxacD4NGFpVcE86PntC3m1g7eYaLYto2vLiMGfi5ERomoZb6EjFOg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784134566; c=relaxed/simple;
	bh=W6UoLU7Xq+fSQyijdKXbIS/9Q/EoGQXVrp/O2WngBIE=;
	h=From:To:Cc:Subject:Message-ID:MIME-Version:Content-Type:Date; b=k07L7CKttWehFW/znmyZPCHxuVRbH2G9eiJrHD1V6HUA1Ys79NWJhgM8r1ozAOg0CTbe5ptbNTe0vde8JtsNV1q14EGacgnUMgtoebfjsqNzXpGjTkDTp3eDrNEk8vWaWG3aOVHaQL02+VHyvOuFvUySLnplPm+Tya99G1TRC9c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=FfU9vLE6; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="FfU9vLE6"
Received: by smtp.kernel.org (Postfix) with UTF8SMTPSA id CD6301F000E9;
	Wed, 15 Jul 2026 16:56:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1784134564;
	bh=Ojvz0oJbYYp/xjHq+Jxy+0SxW1fKbwdyiWHZe4Xx9Do=;
	h=From:To:Cc:Subject:Date;
	b=FfU9vLE66mQYupbTbLo89RTtF9fCAAorwbV0qWjbdPBr8OpRfNsytcKryrD/axRfj
	 ILHIkUPL+b9zKqWuTNpY+8/uvj9ZyY3mip/NQPRfQ6LJmAJsx41vwHtf5wYQsc8MYL
	 37JQNiNfYD6n1qRT3DNVlPqwDxsgwSg8nfV8wLMRrTcbf7X0xrkiVuOJUO35aIBh/4
	 Uxi80Pfpx9m6eRveb8s6KUDjbv89GE1Viv3GvmkNvoJBrflQg+KKTh4R6WH/Z/D36C
	 shX9m/jng1dZ8O2Pkcox9W43rNS5LEkM9gG/gke+1LmMJI+yD7sr/A5LT/GysTm3qV
	 5PERIBWiSeXqQ==
From: "syzbot" <syzbot@kernel.org>
To: syzkaller-upstream-moderation@googlegroups.com
Cc: syzbot@lists.linux.dev
Subject: [PATCH RFC v2] wifi: mac80211: reject station association if AP is not started
Message-ID: <79cbf145-6652-4e15-be67-f7974ebc29cb@mail.kernel.org>
Precedence: bulk
X-Mailing-List: syzbot@lists.linux.dev
List-Id: <syzbot.lists.linux.dev>
List-Subscribe: <mailto:syzbot+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:syzbot+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Date: Wed, 15 Jul 2026 16:56:04 +0000 (UTC)

If an interface is changed to AP mode but not started, its channel context
configuration (chanctx_conf) remains NULL. If a station is then added to
this interface, the kernel may automatically set the
NL80211_STA_FLAG_ASSOCIATED flag for compatibility with older userspace
applications.

When this flag is set, sta_apply_auth_flags() attempts to initialize rate
control for the station by calling rate_control_rate_init_all_links(). This
eventually leads to rate_control_rate_init(), which dereferences the NULL
chanctx_conf, triggering a WARN_ON:

WARNING: net/mac80211/rate.c:51 at rate_control_rate_init+0x5a6/0x630
...
Call Trace:
 <TASK>
 rate_control_rate_init_all_links+0xf4/0x190 net/mac80211/rate.c:84
 sta_apply_auth_flags+0x1bc/0x430 net/mac80211/cfg.c:2152
 sta_apply_parameters+0x126d/0x1b10 net/mac80211/cfg.c:2618
 ieee80211_add_station+0x3de/0x700 net/mac80211/cfg.c:2684
 rdev_add_station+0xfc/0x290 net/wireless/rdev-ops.h:201
 nl80211_new_station+0x1b4e/0x1fd0 net/wireless/nl80211.c:9505

Fix this by rejecting the addition or modification of a station to the
associated state if the AP has not been started (chanctx_conf is NULL).
Exempt Multi-Link Operation (MLO) interfaces from this check, as they
handle chanctx_conf per-link rather than globally on the VIF.

Fixes: 55de908ab292 ("mac80211: use channel contexts")
Assisted-by: Gemini:gemini-3.1-pro-preview Gemini:gemini-3-flash-preview syzbot
Reported-by: syzbot+9bdc0c5998ab45b05030@syzkaller.appspotmail.com
Closes: https://syzkaller.appspot.com/bug?extid=9bdc0c5998ab45b05030
Link: https://syzkaller.appspot.com/ai_job?id=6a1e0fff-0cb4-4d35-acf2-c84eee3af15c
To: "Johannes Berg" <johannes@sipsolutions.net>
To: <linux-wireless@vger.kernel.org>
Cc: <linux-kernel@vger.kernel.org>

---
v2:
- Moved the chanctx_conf check inside the WLAN_STA_RATE_CONTROL check block.
- Removed a phrase from the commit description as requested by reviewers.

v1:
https://lore.kernel.org/all/8e8a5122-a09e-43b2-b42f-4c73b021b173@mail.kernel.org/T/
---
diff --git a/net/mac80211/cfg.c b/net/mac80211/cfg.c
index 3b58af59f..ae29f799b 100644
--- a/net/mac80211/cfg.c
+++ b/net/mac80211/cfg.c
@@ -2148,8 +2148,13 @@ static int sta_apply_auth_flags(struct ieee80211_local *local,
 		 * well. Some drivers require rate control initialized
 		 * before drv_sta_state() is called.
 		 */
-		if (!test_sta_flag(sta, WLAN_STA_RATE_CONTROL))
+		if (!test_sta_flag(sta, WLAN_STA_RATE_CONTROL)) {
+			if (!ieee80211_vif_is_mld(&sta->sdata->vif) &&
+			    !rcu_access_pointer(
+				    sta->sdata->vif.bss_conf.chanctx_conf))
+				return -EINVAL;
 			rate_control_rate_init_all_links(sta);
+		}
 
 		ret = sta_info_move_state(sta, IEEE80211_STA_ASSOC);
 		if (ret)


base-commit: dc59e4fea9d83f03bad6bddf3fa2e52491777482
-- 
This is an AI-generated patch subject to moderation.
Reply with '#syz upstream' to Sign-off the patch as a human author
and send it to the upstream kernel mailing lists.
Reply with '#syz reject' to reject it ('#syz unreject' to undo).

See https://goo.gle/syzbot-ai-patches for information about AI-generated patches.
You can comment on the patch as usual, syzbot will try to address
the comments and send a new version of the patch if necessary.
syzbot engineers can be reached at syzkaller@googlegroups.com.
