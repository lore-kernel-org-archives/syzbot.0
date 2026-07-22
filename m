Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F3970439F82
	for <syzbot@lists.linux.dev>; Wed, 22 Jul 2026 16:32:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784737979; cv=none; b=redKCaPaUbjXkMOnOK5UOf/nKIEqO0VGz2/zgq98tM+lZNPMbUvsIItm4dluFovMh7sPj0Lenu1x8ADjsfl5PNvmwce5N/NPlPRmDPftVD0vni9IJTPnZEkM0meIvZfb3MOpTbAwkK3UWZd/CSJ69vf5pD506eCmCyyM/ZEfYMw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784737979; c=relaxed/simple;
	bh=eQ0He0lbm2Sip6Lcp+/BRasYd+3NUCGKoccPriCtb5E=;
	h=From:To:Cc:Subject:Message-ID:MIME-Version:Content-Type:Date; b=QrBDJDVIWedvgmjAkMVQJCWAVGImdrXTHv2bwefXgo7xN1ILF5wwpqXkeLOJ3oduD1a4+P+XgZwcB1WAWbJOhtXh4ZN4JfZ/lklWlhcoqyB4+xDaT5/wbyPypg2FM9R+nMGXlcaVNzSgzWp65HNY6ZKNbjM+C5OZS91x05rrAIc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=loBCWeyx; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="loBCWeyx"
Received: by smtp.kernel.org (Postfix) with UTF8SMTPSA id 6344B1F00A3A;
	Wed, 22 Jul 2026 16:32:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1784737976;
	bh=Qb3pX1a6X8jbk9eq4JjBWbdRTWdMsLAbyqT0VSSRFok=;
	h=From:To:Cc:Subject:Date;
	b=loBCWeyxC1h0A81RJ5k9e2Z/TPOU40LydOvw1lxsvKqhhqt+QI6nPjK5zwe9CXYO+
	 b9h7h3A6ai93fmboRTsYqla68Klxe8VDwFrh6M9VDWKP7HsnBMUG/5RZpZUN6PBe/L
	 kyf6zOlrLA05NYBhnbVDfNhZBIoffAl16TdiQSmEcFCkONC3TBYNT1qpRut93/LlDL
	 erYnaH9vlPjq1kgdjT0021cMZf+qjoo9j7AwslJ/CsuPB7IdpA8anwtb+aLv44pPnz
	 iu5I6dFNI4Uyl4BMQ8b10dyHKgq5HcZNzd8jsGjWn73LypScjISmjLqYBQ4+hVokwt
	 D7y4f2aFOeLwA==
From: "syzbot" <syzbot@kernel.org>
To: syzkaller-upstream-moderation@googlegroups.com
Cc: sst@poczta.fm, syzbot@lists.linux.dev
Subject: [PATCH RFC v4] wifi: mac80211: reject station association if AP is not started
Message-ID: <fc12db53-baa2-4eb0-ae53-9f0469eafdc9@mail.kernel.org>
Precedence: bulk
X-Mailing-List: syzbot@lists.linux.dev
List-Id: <syzbot.lists.linux.dev>
List-Subscribe: <mailto:syzbot+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:syzbot+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Date: Wed, 22 Jul 2026 16:32:56 +0000 (UTC)

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
Assisted-by: Gemini:gemini-3.5-flash Gemini:gemini-3.1-pro-preview syzbot
Reported-by: syzbot+9bdc0c5998ab45b05030@syzkaller.appspotmail.com
Closes: https://syzkaller.appspot.com/bug?extid=9bdc0c5998ab45b05030
Link: https://syzkaller.appspot.com/ai_job?id=64f3e3ae-e43e-4917-b403-f9b7799fe1bc
To: "Johannes Berg" <johannes@sipsolutions.net>
To: <linux-wireless@vger.kernel.org>
Cc: <linux-kernel@vger.kernel.org>

---
v4:
- Avoid unnecessary line wrapping in the chanctx_conf check.

v3:
- Added an empty line after the newly added code block for better readability.
https://lore.kernel.org/all/9524f34c-7766-4543-a49c-a9fe48fd9d1e@mail.kernel.org/T/

v2:
- Moved the chanctx_conf check inside the WLAN_STA_RATE_CONTROL check block.
- Removed a phrase from the commit description as requested by reviewers.
https://lore.kernel.org/all/79cbf145-6652-4e15-be67-f7974ebc29cb@mail.kernel.org/T/

v1:
https://lore.kernel.org/all/8e8a5122-a09e-43b2-b42f-4c73b021b173@mail.kernel.org/T/
---
diff --git a/net/mac80211/cfg.c b/net/mac80211/cfg.c
index 3b58af59f..830c9fc95 100644
--- a/net/mac80211/cfg.c
+++ b/net/mac80211/cfg.c
@@ -2148,8 +2148,13 @@ static int sta_apply_auth_flags(struct ieee80211_local *local,
 		 * well. Some drivers require rate control initialized
 		 * before drv_sta_state() is called.
 		 */
-		if (!test_sta_flag(sta, WLAN_STA_RATE_CONTROL))
+		if (!test_sta_flag(sta, WLAN_STA_RATE_CONTROL)) {
+			if (!ieee80211_vif_is_mld(&sta->sdata->vif) &&
+			    !rcu_access_pointer(sta->sdata->vif.bss_conf.chanctx_conf))
+				return -EINVAL;
+
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
