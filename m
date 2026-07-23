Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E73A1233938;
	Thu, 23 Jul 2026 08:11:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784794270; cv=none; b=aEZGBrsiEENpKldD4VyGg7UNv5UWEhBS4NWH0oyOMNzGu++IzCmY0fDm6WOtmEfbDi23TEuRjmbrH76kqL+vbdgIH1WKAQYCG/YarMj7ThKIkJP/fjHs+dDBIFCcx28xZWGPFPdM6NkHEFz4d40uRDkotz3/hpnN+EudoIQTva4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784794270; c=relaxed/simple;
	bh=D24F/surn0I7mnGy7WPuUdK47eQw0RJ1Da3KhCNwG5g=;
	h=From:To:Cc:Subject:Message-ID:MIME-Version:Content-Type:Date; b=szOcD5CMhF/3ErtJMjqgn+yZaseFMhmEeYOpcbRNpaT+GBV9a3VJrgh7Y0ZDfcZcX9+TKxrKdGKvJMPoETZuEhK4rnc5Zhue2LT18pQrWWV8UJ/F1OXB5kfBjzy+p/PqGnupGPrI1VAR29gpY3rZbIYWmIEMxJ8/aXcPDS9qhLM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=opkJHdMi; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="opkJHdMi"
Received: by smtp.kernel.org (Postfix) with UTF8SMTPSA id 2BB431F000E9;
	Thu, 23 Jul 2026 08:11:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1784794268;
	bh=RrQHTWac9VgLobZzZjtsR4JzkWKpBUuAKD7mXqYh8cc=;
	h=From:To:Cc:Subject:Date;
	b=opkJHdMikpC16ZSU9rSmOqeX4QnP6trCACLnLavVwPgXEvz0rjNrhHIGxjWhzh6if
	 ccOmKlTzkHuRBvHA+2TMx8Ku1h1XhQDRyE7F7J2KHuMH3v9MsG+RPtuiakW2Eg5HCM
	 K6mW10+BqQt1xHBzlDjQtlEyb2s1hJtIlaeAuzOecpuyAEz686acm2GzpU+p7LEDgq
	 iIOnAsYLx5VD/yt1/+bRKmE0TJYaXYqvneeBXdEJeJRsfsdByPlCTcUvAfUYJ0ZHGp
	 i6IB31fiHRFr9FvgK8c09U4oKv5CMT3LeI52Q1bGbSoiI/Ift9gZ5PoL2NSi4WCcA+
	 IO673HuJPMdgA==
From: "syzbot" <syzbot@kernel.org>
To: syzkaller-bugs@googlegroups.com, Slawomir Stepien <sst@poczta.fm>, "Johannes Berg" <johannes@sipsolutions.net>, <linux-wireless@vger.kernel.org>
Cc: linux-kernel@vger.kernel.org, syzbot@lists.linux.dev
Subject: [PATCH] wifi: mac80211: reject station association if AP is not started
Message-ID: <373210a9-4365-4cac-823a-0eec391858e7@mail.kernel.org>
Precedence: bulk
X-Mailing-List: syzbot@lists.linux.dev
List-Id: <syzbot.lists.linux.dev>
List-Subscribe: <mailto:syzbot+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:syzbot+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Date: Thu, 23 Jul 2026 08:11:08 +0000 (UTC)

From: Slawomir Stepien <sst@poczta.fm>

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
Signed-off-by: Slawomir Stepien <sst@poczta.fm>

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
See https://goo.gle/syzbot-ai-patches for information about AI-generated patches.
You can comment on the patch as usual, syzbot will try to address
the comments and send a new version of the patch if necessary.
syzbot engineers can be reached at syzkaller@googlegroups.com.
