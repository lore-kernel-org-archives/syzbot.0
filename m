Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2BDF523ED5B
	for <syzbot@lists.linux.dev>; Wed,  1 Jul 2026 09:52:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782899533; cv=none; b=okfameS4JcdgPOrhD46vO8XEyHYsXch1nff6orpiV3ZJGIzTJHfe1KiUTcxCnTYEnrs5dclmKoW2qLyyrkfrl3CZs2LpxeTAY3ty3o2egoV8rrFNbQoROy/apztU/FQHIiuISesOPZ87FR+Cs/TQTr8PxBpnLEZXGx4l4TDvUxI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782899533; c=relaxed/simple;
	bh=EOzx00JTYIu3gmSwGnGKP3TSMrjktZU3nS4txAJ2z6U=;
	h=From:To:Cc:Subject:Message-ID:MIME-Version:Content-Type:Date; b=gRykyLMMgf0bU4CGDj+UVLyDUyRAhhGhusXCw72bPmx4ThONCqsjuXpcxdTZPAE1Rd7Uv6tNclbHY6NOZyqWFgYO7yg2PNdS798qLy1pYNxkTvp8J+WAf8+nwGUsAJdIMQHXP+2ouuegdOcY2Uzs5jLzsCg/7imX6sxEVyRbnjM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=V4HnGObR; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="V4HnGObR"
Received: by smtp.kernel.org (Postfix) with UTF8SMTPSA id A2FA11F00A3A;
	Wed,  1 Jul 2026 09:52:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1782899531;
	bh=JaR8wk7xPEDKyaG0THZqAauhC9KNThOd1wbHa0mLJds=;
	h=From:To:Cc:Subject:Date;
	b=V4HnGObRg3NxzzmneExwn0gr9MxkDg/9bk1dJ+vGp86G5dSdg14Bs3nzRFruaFkSB
	 ITdqO4AqP9bXnYHsWyYRGyAEFtVDMDGIk08HDWnPJ0Ec1AgbBLfsjG8I8M196fsJzG
	 FTTquVdVyAvaFecZ4PNM7vPTIpJnBQPf/vXgsousQf5e8onfQqFw8Uk6cSzGpjolZr
	 g/IcLEmtXrXPqmSIWlRfXmZ5uf1eUxxPKJkIt719oNWx6U/jEZViqZfo3K9NKTpUEj
	 KKbKFZiEAtP/NyskUSLI2CTXX+RoUATbJ4hoDZDsH4J1fasWT4dIXLR67Qknm8cU6g
	 dMGMOYJrOW/zg==
From: "syzbot" <syzbot@kernel.org>
To: syzkaller-upstream-moderation@googlegroups.com
Cc: syzbot@lists.linux.dev
Subject: [PATCH RFC] wifi: mac80211: reject station association if AP is not started
Message-ID: <8e8a5122-a09e-43b2-b42f-4c73b021b173@mail.kernel.org>
Precedence: bulk
X-Mailing-List: syzbot@lists.linux.dev
List-Id: <syzbot.lists.linux.dev>
List-Subscribe: <mailto:syzbot+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:syzbot+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Date: Wed,  1 Jul 2026 09:52:11 +0000 (UTC)

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
 rate_control_rate_init_all_links+0xf4/0x190 net/mac80211/rate.c:84
 sta_apply_auth_flags+0x1bc/0x430 net/mac80211/cfg.c:2152
 sta_apply_parameters+0x126d/0x1b10 net/mac80211/cfg.c:2618
 ieee80211_add_station+0x3de/0x700 net/mac80211/cfg.c:2684
 rdev_add_station+0xfc/0x290 net/wireless/rdev-ops.h:201
 nl80211_new_station+0x1b4e/0x1fd0 net/wireless/nl80211.c:9505

Fix this by rejecting the addition or modification of a station to the
associated state if the AP has not been started (chanctx_conf is NULL).
Exempt Multi-Link Operation (MLO) interfaces from this check, as they
handle chanctx_conf per-link rather than globally on the VIF, and
rate_control_rate_init() already handles them correctly.

Fixes: 55de908ab292 ("mac80211: use channel contexts")
Assisted-by: Gemini:gemini-3.1-pro-preview best-expensive syzbot
Reported-by: syzbot+9bdc0c5998ab45b05030@syzkaller.appspotmail.com
Closes: https://syzkaller.appspot.com/bug?extid=9bdc0c5998ab45b05030
Link: https://syzkaller.appspot.com/ai_job?id=86851195-2aa0-410f-9fc9-952d95ae035d
To: "Johannes Berg" <johannes@sipsolutions.net>
To: <linux-wireless@vger.kernel.org>
Cc: <linux-kernel@vger.kernel.org>

---
diff --git a/net/mac80211/cfg.c b/net/mac80211/cfg.c
index 3b58af59f..b45d7923c 100644
--- a/net/mac80211/cfg.c
+++ b/net/mac80211/cfg.c
@@ -2143,6 +2143,10 @@ static int sta_apply_auth_flags(struct ieee80211_local *local,
 	if (mask & BIT(NL80211_STA_FLAG_ASSOCIATED) &&
 	    set & BIT(NL80211_STA_FLAG_ASSOCIATED) &&
 	    !test_sta_flag(sta, WLAN_STA_ASSOC)) {
+		if (!ieee80211_vif_is_mld(&sta->sdata->vif) &&
+		    !rcu_access_pointer(sta->sdata->vif.bss_conf.chanctx_conf))
+			return -EINVAL;
+
 		/*
 		 * When peer becomes associated, init rate control as
 		 * well. Some drivers require rate control initialized


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
