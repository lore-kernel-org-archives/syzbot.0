Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2791E318ED2
	for <syzbot@lists.linux.dev>; Sun,  2 Aug 2026 21:52:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785707532; cv=none; b=ViHfdTxCE1IDiVFAey8LG8sw8aU5SF4MG2BF+nKda+VfMDUBx8vydFy6gYpgsXSKbegzPu/b4igGBcK6clteYe1asNOBdafxLDy8K8Py0ZIjA9PEm3P/kSD4ORGzoPJ0hEgjo3v/yzX/0hC1zjbaRe0RJG9Q4VrMdh03j24Kniw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785707532; c=relaxed/simple;
	bh=66MpmDmScDAyDapECy4jIwHP4A7P2zbY8ajuo57OKbk=;
	h=From:To:Cc:Subject:Message-ID:MIME-Version:Content-Type:Date; b=ms0TpNqwn7Bw7Ab2F3vnuCKGI5vgqhqd5kJtm3ywtFksfGm/EwhZfw4Cjhx8SydlqUEKOmcoo1D5OFYKWJAMM7POmo/orn7guFlyRbUyBQ322oS4ujYZrSp8hWJqTnUPINvU0UtP2ZA2Ah5nhcQTIzARyfKdiJscwhHr0lL9/sE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=FGkVRNao; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="FGkVRNao"
Received: by smtp.kernel.org (Postfix) with UTF8SMTPSA id 933A11F000E9;
	Sun,  2 Aug 2026 21:52:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1785707530;
	bh=x4JZj/HFHm0Jlc70+LstoCn9ELyxIdSb3WXr+DF3PCM=;
	h=From:To:Cc:Subject:Date;
	b=FGkVRNao9zZyfArGyT6tGlbQWGBXIcLCmpswB0YQHMA7r83H2nkVr3rbG8eBFD3N/
	 DBAUcX5DHR4P5FHuWiFmHbInH2LfThcSwdsmLWOgeuWYd4JiqUn2U+1Mfhn8Mb1WA5
	 dxI0FQhuLBZchmxj1pzxPk+nVGlfz3KbRrh+WIA2z46gF7NTqC5Dh/ChgM7MrDYeq8
	 /c0/S8pPQQhA+ErhxbWDR4dfVWh8oWemsw7QRvhdHK3wbcYwt2DuI6dzX6OeLsJMLu
	 wdTk0hwiiI//fCzX+ybdGt0R+q5Yz3GaEL/z+N880k5fCoIMHmdfW4LTs9r0v0MoFa
	 yyPt7Y/p8+o9A==
From: "syzbot" <syzbot@kernel.org>
To: syzkaller-upstream-moderation@googlegroups.com
Cc: syzbot@lists.linux.dev
Subject: [PATCH RFC] wifi: mac80211: prevent destroying non-TDLS stations in TDLS operations
Message-ID: <7f0c8fa8-559d-4fdf-989f-c81259e4e719@mail.kernel.org>
Precedence: bulk
X-Mailing-List: syzbot@lists.linux.dev
List-Id: <syzbot.lists.linux.dev>
List-Subscribe: <mailto:syzbot+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:syzbot+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Date: Sun,  2 Aug 2026 21:52:10 +0000 (UTC)

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
Link: https://syzkaller.appspot.com/ai_job?id=52e47481-fb24-46ec-8402-1f14cf87081f
To: "Johannes Berg" <johannes@sipsolutions.net>
To: <linux-wireless@vger.kernel.org>
To: "Arik Nemtsov" <arik@wizery.com>
Cc: <linux-kernel@vger.kernel.org>

---
diff --git a/net/mac80211/tdls.c b/net/mac80211/tdls.c
index ffd575a8d..24297552f 100644
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
+			__sta_info_destroy(sta);
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
