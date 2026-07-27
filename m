Received: from smtpo49.interia.pl (smtpo49.interia.pl [217.74.67.49])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7E3793E316B
	for <syzbot@lists.linux.dev>; Mon, 27 Jul 2026 07:46:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.74.67.49
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785138408; cv=none; b=FC1wuz91jmGwEwnBRuA3Bm/jsqf9Of+RZVm5NL2/94mT3vzwTULSqK0mUILLp14dSwr1qTpuD6ZA4qYRhyFkEVk88HI5BHtDoXw/MSwTCW6redUJnX/xdDW//wiKJzXBPYOq600A/VdjxPgNd0Hip4Za6Fo5YYlrrqbJlXVYM4w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785138408; c=relaxed/simple;
	bh=hH3iMPyaoJ5mkOhv3F2jIxeUnzRMusFiIDzaEhvu5HY=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=R2Fg/nsuUFVE2Y9rvzldZd3r686I2Ti0tXBnEZrCFmRLeEuiLvLy/izeAS3mpvIjzCwUtqhFyPck0KdTReSKxh4UJ1Y7AZld/ozB1jXwD77h8TFxoGiiRXlFukc5Mdd43o1vEaSVUrP84Q2pp/PFhQkleNuGej5K/ULktb8xnMI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=poczta.fm; spf=pass smtp.mailfrom=poczta.fm; dkim=pass (1024-bit key) header.d=poczta.fm header.i=@poczta.fm header.b=bkBHqs+n; arc=none smtp.client-ip=217.74.67.49
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=poczta.fm
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=poczta.fm
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=poczta.fm header.i=@poczta.fm header.b="bkBHqs+n"
Received: from localhost (unknown [80.68.231.31])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (P-256) server-signature ECDSA (P-256) server-digest SHA256)
	(No client certificate requested)
	by poczta.interia.pl (INTERIA.PL) with ESMTPSA;
	Mon, 27 Jul 2026 09:46:33 +0200 (CEST)
From: Slawomir Stepien <sst@poczta.fm>
To: syzkaller-bugs@googlegroups.com,
	johannes@sipsolutions.net,
	linux-wireless@vger.kernel.org
Cc: linux-kernel@vger.kernel.org,
	syzbot@lists.linux.dev,
	Slawomir Stepien <sst@poczta.fm>,
	syzbot+9bdc0c5998ab45b05030@syzkaller.appspotmail.com
Subject: [PATCH v2] mac80211: reject station addition if AP or MLO link is inactive
Date: Mon, 27 Jul 2026 09:45:26 +0200
Message-ID: <20260727074526.248393-1-sst@poczta.fm>
X-Mailer: git-send-email 2.55.0
Precedence: bulk
X-Mailing-List: syzbot@lists.linux.dev
List-Id: <syzbot.lists.linux.dev>
List-Subscribe: <mailto:syzbot+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:syzbot+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=poczta.fm; s=dk;
	t=1785138395; bh=pAG5JQKFpd6sLu0HpXWK8TdT6a3g/pT8xNcL5/8HWXg=;
	h=From:To:Subject:Date:Message-ID:MIME-Version;
	b=bkBHqs+n9+XO5dc3MXQL0Kgb0KowY0fGWJpVfyzYXbNd7R+Ov4Tjdfa37wzbWt3k9
	 HooSh64lzUE+EU7yDQF2r0SoMTTL2vAX802i8ORYx6V5bxCRMAHLVJiFBsMuBVo5Q5
	 eLt6laR/4XJ7GW+DXFi06bIBuSfmmGdNCpt3SuIk=

Currently, userspace can issue a netlink command to add a station to
an AP or P2P GO interface before the AP has fully started, or before
a specific MLO link has begun beaconing. This will e.g. lead to a
WARN_ON trigger:

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

Fix this by introducing a two-tiered active state check in
ieee80211_add_station():

1. Global AP State: Add an early return if the main wdev is an AP or
   P2P GO and `sdata->u.ap.active` is false.

2. MLO Link State: For Wi-Fi 7 MLO setups, links can start asynchronously.
   Even if the global AP is active, a specific link might still be down.
   If a specific link_id is requested, ensure the underlying physical link
   has an allocated beacon (`link->u.ap.beacon`) before proceeding with
   sta_info allocation.

Assisted-by: Gemini:3.1-pro
Reported-by: syzbot+9bdc0c5998ab45b05030@syzkaller.appspotmail.com
Closes: https://syzkaller.appspot.com/bug?extid=9bdc0c5998ab45b05030
Signed-off-by: Slawomir Stepien <sst@poczta.fm>
---
v2:
* Move the logic inside ieee80211_add_station()
* Check both the non-MLO AP/P2P state and MLO link state
* Update subject line and commit message

v1:
* https://lore.kernel.org/linux-wireless/373210a9-4365-4cac-823a-0eec391858e7@mail.kernel.org/
---
 net/mac80211/cfg.c | 43 ++++++++++++++++++++++++++++++++++---------
 1 file changed, 34 insertions(+), 9 deletions(-)

diff --git a/net/mac80211/cfg.c b/net/mac80211/cfg.c
index 43f142624d33..c3a580ad97e9 100644
--- a/net/mac80211/cfg.c
+++ b/net/mac80211/cfg.c
@@ -2637,19 +2637,24 @@ static int ieee80211_add_station(struct wiphy *wiphy, struct wireless_dev *wdev,
 {
 	struct ieee80211_local *local = wiphy_priv(wiphy);
 	struct sta_info *sta;
-	struct ieee80211_sub_if_data *sdata;
+	struct ieee80211_sub_if_data *sdata = IEEE80211_WDEV_TO_SUB_IF(wdev);
 	int err;
 
 	lockdep_assert_wiphy(local->hw.wiphy);
 
+	if (sdata->vif.type == NL80211_IFTYPE_AP ||
+	    sdata->vif.type == NL80211_IFTYPE_P2P_GO) {
+		if (!sdata->u.ap.active)
+			return -ENETDOWN;
+	}
+
 	if (params->vlan) {
 		sdata = IEEE80211_DEV_TO_SUB_IF(params->vlan);
 
 		if (sdata->vif.type != NL80211_IFTYPE_AP_VLAN &&
 		    sdata->vif.type != NL80211_IFTYPE_AP)
 			return -EINVAL;
-	} else
-		sdata = IEEE80211_WDEV_TO_SUB_IF(wdev);
+	}
 
 	if (ether_addr_equal(mac, sdata->vif.addr))
 		return -EINVAL;
@@ -2663,17 +2668,37 @@ static int ieee80211_add_station(struct wiphy *wiphy, struct wireless_dev *wdev,
 		return -EINVAL;
 
 	/*
-	 * If we have a link ID, it can be a non-MLO station on an AP MLD,
-	 * but we need to have a link_mac in that case as well, so use the
-	 * STA's MAC address in that case.
+	 * If we have a link ID:
+	 * (1) check if it is valid, up and beaconing
+	 * (2) it can be a non-MLO station on an AP MLD, but we need to have a
+	 * link_mac in that case as well, so use the STA's MAC address in that
+	 * case.
 	 */
-	if (params->link_sta_params.link_id >= 0)
+	if (params->link_sta_params.link_id >= 0) {
+		int link_id = params->link_sta_params.link_id;
+		struct ieee80211_link_data *link;
+		struct ieee80211_sub_if_data *wdev_sdata = IEEE80211_WDEV_TO_SUB_IF(wdev);
+
+		if (link_id >= IEEE80211_MLD_MAX_NUM_LINKS)
+			return -EINVAL;
+
+		link = sdata_dereference(wdev_sdata->link[link_id], wdev_sdata);
+		if (!link)
+			return -ENOLINK;
+
+		if (wdev_sdata->vif.type == NL80211_IFTYPE_AP ||
+		    wdev_sdata->vif.type == NL80211_IFTYPE_P2P_GO) {
+			if (!rcu_access_pointer(link->u.ap.beacon))
+				return -ENETDOWN;
+		}
+
 		sta = sta_info_alloc_with_link(sdata, mac,
-					       params->link_sta_params.link_id,
+					       link_id,
 					       params->link_sta_params.link_mac ?: mac,
 					       GFP_KERNEL);
-	else
+	} else {
 		sta = sta_info_alloc(sdata, mac, GFP_KERNEL);
+	}
 
 	if (!sta)
 		return -ENOMEM;
-- 
2.55.0

