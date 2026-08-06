Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 51B6434B1A3;
	Thu,  6 Aug 2026 07:45:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786002350; cv=none; b=W/kx9hUqiVBS16FVVc/7qM2/rfDDkfRv5RTzZVG1o93NTD1YOZkxBLT46KCB+of6BqdNDyIVK5rcdU/THOJZHu/zpkIhGOhu1SaHZwPG0BiLPUtTKAqxPy8UbsGzzU7qbXvlS0Ko64QiYdkAF2tFTv9H8IW3PCHoaNYoKyZ1XmA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786002350; c=relaxed/simple;
	bh=iMIhT+QpAlwPU6E1/gZlTYAroJ8/s7wc/TR/Avh9mPM=;
	h=From:To:Cc:Subject:Message-ID:MIME-Version:Content-Type:Date; b=TYCONKros//iMsxDUJ8AqIOA7YPFombW87aaaoD+7I0IYcbGrMMhqikxiV/13lJdLNtxfhlIXCeELdllaKD1y/+uy8WQYVGDHoBZAbmxhlPNptHcUyxbulAotqzPHHrkrLpBC8+j/aTep/vHccx5R/bQCdQcnUbpnd2htMXUDgY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=hn5WDlez; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="hn5WDlez"
Received: by smtp.kernel.org (Postfix) with UTF8SMTPSA id 6BBA91F000E9;
	Thu,  6 Aug 2026 07:45:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1786002348;
	bh=ugze2g5Rzu+ubuqtpQ9TqKqqDUxmXg6kGtjbPhXDx24=;
	h=From:To:Cc:Subject:Date;
	b=hn5WDlezW4+Ztdz/TTdReVf1kak3AxR6etKvZbXA1Niuc/fGhs/thVME7ckQxRAxm
	 lfhkHshRH/X68DA4fJix2hrnPgn9HVCv8xqgp+N+S4ZYVqPSjdrF4NiwDaYxH6FgOo
	 EfeKoVGzlxbBI0QIP6gLX5Mh1Aqo/KIhocc126kL9aaDh4VljUb68mDCzgVKywPCSB
	 e2qTpwyc1Yh1UyOvhnEtHYNizdDh0koXiYKPa06ReanEsueNLZCRasidCxQ1jy0diO
	 sTnEYr/9afHkH4TpmNFbKhCkAFzsd7J9z5OBvRx63gQwaIpF2EIn91PCw3jQo8U696
	 0L2gbNm4F/Z7Q==
From: "syzbot" <syzbot@kernel.org>
To: syzkaller-bugs@googlegroups.com, Krystian Kaniewski <krystianmkaniewski@gmail.com>, "Johannes Berg" <johannes@sipsolutions.net>, <linux-wireless@vger.kernel.org>, "Arik Nemtsov" <arik@wizery.com>
Cc: linux-kernel@vger.kernel.org, syzbot@lists.linux.dev
Subject: [PATCH] wifi: mac80211: prevent destroying non-TDLS stations in TDLS operations
Message-ID: <068e46b5-0c88-4432-959a-b9400d9691ee@mail.kernel.org>
Precedence: bulk
X-Mailing-List: syzbot@lists.linux.dev
List-Id: <syzbot.lists.linux.dev>
List-Subscribe: <mailto:syzbot+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:syzbot+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Date: Thu,  6 Aug 2026 07:45:48 +0000 (UTC)

From: Krystian Kaniewski <krystianmkaniewski@gmail.com>

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
Signed-off-by: Krystian Kaniewski <krystianmkaniewski@gmail.com>

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
See https://goo.gle/syzbot-ai-patches for information about AI-generated patches.
You can comment on the patch as usual, syzbot will try to address
the comments and send a new version of the patch if necessary.
syzbot engineers can be reached at syzkaller@googlegroups.com.
