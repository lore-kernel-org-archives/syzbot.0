Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2FCAE3D0936
	for <syzbot@lists.linux.dev>; Thu, 16 Jul 2026 08:22:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784190129; cv=none; b=b37Jufe8g8cT1geg4ovgn/C8rFfvnN7JFe13mGbbPLYUrYMTgF5hx275fH5US7LarS+wKNB2gkAomQoEKXJK3gAodW/0Q+J73bEz4rmtVjJyVP++Yyt73J7NeGfgnHzKohRVPQXma6MDImxNenSVMEJ2FU+KDzOwBfyjocsKbTY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784190129; c=relaxed/simple;
	bh=rw0wlWZpB6LyUnWnQ1eUZtDRzJmgCZAaUg77sRgj87Q=;
	h=From:To:Cc:Subject:Message-ID:MIME-Version:Content-Type:Date; b=qMqPX0bax2wqREwuFFkmntL90NE0Kfh93sAY1rU2e8+CUf3Ap4hu/5Y2MjDI8CyEBzzqAZw7W07gOW/V8xT4FKSvkR+5m/UGqyaMlKqauY/EIJi2fduQ0pPnAlh+UTpR69Ad86/C54j8kawjNTWXXxwpejlOQK/2L10kUp8Rm7M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=VnoJmpu9; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="VnoJmpu9"
Received: by smtp.kernel.org (Postfix) with UTF8SMTPSA id 794441F000E9;
	Thu, 16 Jul 2026 08:22:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1784190124;
	bh=YvAdlt7lfnj0oa6DfRWVCm75U3u3Hh8PcKYOjVsjais=;
	h=From:To:Cc:Subject:Date;
	b=VnoJmpu9j5bfRQGE2rF3YaLAitaZEVMMtdE11uL7wBs0AzvMMR505SUj7u43cNcnM
	 plXnbq9tTzh/pDsHNX5h//QN04I5F5WOK6xTsvAA2hZGvb+AOPd6HoO5JpLyz21O2w
	 gJukxSNN6+/qbGO14z1oqAYZQg9BmLaSZ4d3qrzkT6GQ65XTVu3i/1OhfZjlwoQuNM
	 KzBroQcnQ21GDjqsc9FAgfHwhmUaSTDqzG7+JiSHN24kOdeaZryFLyE47qfHIfFCey
	 VOYcpQKhW0vlqVt07fvkoKZ6MQ9oDn+hu0c6VTNlzOX8jaGSFaxYO6QNEwnPm/RYaA
	 j7vAD+D4WZhWw==
From: "syzbot" <syzbot@kernel.org>
To: syzkaller-upstream-moderation@googlegroups.com
Cc: sst@poczta.fm, syzbot@lists.linux.dev
Subject: [PATCH RFC v3] wifi: mac80211: reject station association if AP is not started
Message-ID: <9524f34c-7766-4543-a49c-a9fe48fd9d1e@mail.kernel.org>
Precedence: bulk
X-Mailing-List: syzbot@lists.linux.dev
List-Id: <syzbot.lists.linux.dev>
List-Subscribe: <mailto:syzbot+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:syzbot+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Date: Thu, 16 Jul 2026 08:22:04 +0000 (UTC)

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
Link: https://syzkaller.appspot.com/ai_job?id=0c474d56-8871-480a-8ac4-9a9658930b46
To: "Johannes Berg" <johannes@sipsolutions.net>
To: <linux-wireless@vger.kernel.org>
Cc: <linux-kernel@vger.kernel.org>

---
v3:
- Added an empty line after the newly added code block for better readability.

v2:
- Moved the chanctx_conf check inside the WLAN_STA_RATE_CONTROL check block.
- Removed a phrase from the commit description as requested by reviewers.
https://lore.kernel.org/all/79cbf145-6652-4e15-be67-f7974ebc29cb@mail.kernel.org/T/

v1:
https://lore.kernel.org/all/8e8a5122-a09e-43b2-b42f-4c73b021b173@mail.kernel.org/T/
---
diff --git a/net/mac80211/cfg.c b/net/mac80211/cfg.c
index 3b58af59f..d4331fbae 100644
--- a/net/mac80211/cfg.c
+++ b/net/mac80211/cfg.c
@@ -2148,8 +2148,14 @@ static int sta_apply_auth_flags(struct ieee80211_local *local,
 		 * well. Some drivers require rate control initialized
 		 * before drv_sta_state() is called.
 		 */
-		if (!test_sta_flag(sta, WLAN_STA_RATE_CONTROL))
+		if (!test_sta_flag(sta, WLAN_STA_RATE_CONTROL)) {
+			if (!ieee80211_vif_is_mld(&sta->sdata->vif) &&
+			    !rcu_access_pointer(
+				    sta->sdata->vif.bss_conf.chanctx_conf))
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
