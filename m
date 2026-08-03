Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CAE9830F924
	for <syzbot@lists.linux.dev>; Mon,  3 Aug 2026 15:36:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785771402; cv=none; b=hDWzFNXQBmYYPt1vC8ih5RxsvTbzKu4xCqe8bqkevsBqXthQUKYZuK+QrryaDnDp1YNza9nCZgUzP2wLTmI6qGKNGj/94CNiBq/EWpmV0rRUWT8AGvJaem0p1AEjIN7EMHQC0CLAuBVKYI7ZIieULsZnxpS/akuzCKAu72LqgtA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785771402; c=relaxed/simple;
	bh=yq6636QNMalg3Sp8wLs7j6JfUXIUtuOcXTGp7Pd3DfI=;
	h=From:To:Cc:Subject:Message-ID:MIME-Version:Content-Type:Date; b=eGtyeERQOLYNds3ink7B8BBBF8SWQuKNLb8MATOvqVl2zZEdL9JXtvddV+jHUGd6trw6lVvr9YY6bxTcPt/hEZWAjMnJ2tx6LWKqjfGLEVFuBEaL11IIJM3oSYjA6mX01liddTgvOx8cECYkVXS6gGFreSDwOIGrosD2XQ72tI0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Kbbg+2cs; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Kbbg+2cs"
Received: by smtp.kernel.org (Postfix) with UTF8SMTPSA id 60D7D1F00A3A;
	Mon,  3 Aug 2026 15:36:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1785771400;
	bh=EOoK02Hs3rgUpkdSeohiisE2mwfqDDi+dHwjcLdaPdE=;
	h=From:To:Cc:Subject:Date;
	b=Kbbg+2cs94kTr+/sCjHosg+f8BejZnxhQXeB2qOQf5CtXRgDrpsUICJMR2qL/deYJ
	 XeeIuNgmLz4LCuJferX6n3cZ9Y9WrGGShCkpjETepDKIh8keJIKkd9m2EC776KRask
	 zdqrHHqX8Pt5wN1sxJxl0NqTwoiuIvskUwZlvBQO7e4fB5zJYq0y39aZvx2CvLE18k
	 P/NxGMLN3aYIP9007+UUVePE2crXk8tp9U1dM73LS9ezVPJINK8+jwXz6c4AoT6SKp
	 Fd1UCHEAGxHRJdQjZpfyUxIritJbw31ltXjrkAVQAGbRkQ4Yx6tzErz0v9YMiCQZH1
	 E/bzxvsG8Sx1w==
From: "syzbot" <syzbot@kernel.org>
To: syzkaller-upstream-moderation@googlegroups.com
Cc: krystianmkaniewski@gmail.com, syzbot@lists.linux.dev
Subject: [PATCH RFC v2] wifi: mac80211: prevent destroying non-TDLS stations in TDLS operations
Message-ID: <1b40a6ad-58b6-4111-b352-c82aaaa7d02c@mail.kernel.org>
Precedence: bulk
X-Mailing-List: syzbot@lists.linux.dev
List-Id: <syzbot.lists.linux.dev>
List-Subscribe: <mailto:syzbot+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:syzbot+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Date: Mon,  3 Aug 2026 15:36:40 +0000 (UTC)

When userspace sends a NL80211_CMD_TDLS_OPER command with the
NL80211_TDLS_DISABLE_LINK operation, the request is handled by
ieee80211_tdls_oper(). The code for this operation directly calls
sta_info_destroy_addr() to destroy the station entry associated with the
provided MAC address. Unlike the NL80211_TDLS_ENABLE_LINK case, which
correctly verifies that the target station exists and is actually a TDLS
peer, the disable link path blindly destroys whatever station matches the
MAC address.

If the provided MAC address is the AP's MAC address, this causes the AP's
station entry to be destroyed while the interface is still associated.
Later, when the driver attempts to send a probe request to the AP, it looks
up the AP's station entry, which returns NULL, triggering a warning in
ieee80211_mgd_probe_ap_send():

WARNING: net/mac80211/mlme.c:4898 at
ieee80211_mgd_probe_ap_send+0x497/0x560 net/mac80211/mlme.c:4898
RIP: 0010:ieee80211_mgd_probe_ap_send+0x497/0x560 net/mac80211/mlme.c:4898
Call Trace:
 <TASK>
 cfg80211_wiphy_work+0x29e/0x420 net/wireless/core.c:538
 process_one_work kernel/workqueue.c:3322 [inline]
 process_scheduled_works+0xa8e/0x14e0 kernel/workqueue.c:3405
 worker_thread+0xa47/0xfb0 kernel/workqueue.c:3486
 kthread+0x388/0x470 kernel/kthread.c:436
 ret_from_fork+0x514/0xb70 arch/x86/kernel/process.c:158
 ret_from_fork_asm+0x1a/0x30 arch/x86/entry/entry_64.S:245
 </TASK>

A similar issue exists in ieee80211_tdls_peer_del_work() which is queued by
ieee80211_tdls_mgmt_setup(). If a TDLS setup request is sent with the AP's
MAC address, the AP's station entry will be destroyed when the setup
timeout expires.

Fix this by explicitly verifying that the station exists and is a TDLS peer
(sta->sta.tdls == true) before destroying it in both ieee80211_tdls_oper()
and ieee80211_tdls_peer_del_work().

Fixes: dfe018bf9953 ("mac80211: handle TDLS high-level commands and frames")
Assisted-by: Gemini:gemini-3.5-flash Gemini:gemini-3.1-pro-preview syzbot
Reported-by: syzbot+a59b5291776979816910@syzkaller.appspotmail.com
Closes: https://syzkaller.appspot.com/bug?extid=a59b5291776979816910
Link: https://syzkaller.appspot.com/ai_job?id=986e342d-a720-47ab-84bf-e8be0e8b70e5
To: "Johannes Berg" <johannes@sipsolutions.net>
To: <linux-wireless@vger.kernel.org>
To: "Arik Nemtsov" <arik@wizery.com>
Cc: <linux-kernel@vger.kernel.org>

---
v2:
- In ieee80211_tdls_peer_del_work(), use sta_info_destroy_addr() instead of __sta_info_destroy() to destroy the station.

v1:
https://lore.kernel.org/all/7f0c8fa8-559d-4fdf-989f-c81259e4e719@mail.kernel.org/T/
---
diff --git a/net/mac80211/tdls.c b/net/mac80211/tdls.c
index ffd575a8d..eef1dde1c 100644
--- a/net/mac80211/tdls.c
+++ b/net/mac80211/tdls.c
@@ -33,8 +33,12 @@ void ieee80211_tdls_peer_del_work(struct wiphy *wiphy, struct wiphy_work *wk)
 	lockdep_assert_wiphy(local->hw.wiphy);
 
 	if (!is_zero_ether_addr(sdata->u.mgd.tdls_peer)) {
+		struct sta_info *sta;
+
 		tdls_dbg(sdata, "TDLS del peer %pM\n", sdata->u.mgd.tdls_peer);
-		sta_info_destroy_addr(sdata, sdata->u.mgd.tdls_peer);
+		sta = sta_info_get(sdata, sdata->u.mgd.tdls_peer);
+		if (sta && sta->sta.tdls)
+			sta_info_destroy_addr(sdata, sdata->u.mgd.tdls_peer);
 		eth_zero_addr(sdata->u.mgd.tdls_peer);
 	}
 }
@@ -1462,6 +1466,10 @@ int ieee80211_tdls_oper(struct wiphy *wiphy, struct net_device *dev,
 			     !ether_addr_equal(sdata->u.mgd.tdls_peer, peer));
 		break;
 	case NL80211_TDLS_DISABLE_LINK:
+		sta = sta_info_get(sdata, peer);
+		if (!sta || !sta->sta.tdls)
+			return -ENOLINK;
+
 		/*
 		 * The teardown message in ieee80211_tdls_mgmt_teardown() was
 		 * created while the queues were stopped, so it might still be
@@ -1476,7 +1484,7 @@ int ieee80211_tdls_oper(struct wiphy *wiphy, struct net_device *dev,
 		/* flush a potentially queued teardown packet */
 		ieee80211_flush_queues(local, sdata, false);
 
-		ret = sta_info_destroy_addr(sdata, peer);
+		ret = __sta_info_destroy(sta);
 
 		iee80211_tdls_recalc_ht_protection(sdata, NULL);
 


base-commit: f5098b6bae761e346ebcd9da7f95622c04733cff
-- 
This is an AI-generated patch subject to moderation.
Reply with '#syz upstream' to Sign-off the patch as a human author
and send it to the upstream kernel mailing lists.
Reply with '#syz reject' to reject it ('#syz unreject' to undo).

See https://goo.gle/syzbot-ai-patches for information about AI-generated patches.
You can comment on the patch as usual, syzbot will try to address
the comments and send a new version of the patch if necessary.
syzbot engineers can be reached at syzkaller@googlegroups.com.
