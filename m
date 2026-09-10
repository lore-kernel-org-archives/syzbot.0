Received: from smtpo49.interia.pl (smtpo49.interia.pl [217.74.67.49])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 74D58415B8B
	for <syzbot@lists.linux.dev>; Thu, 10 Sep 2026 08:04:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.74.67.49
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789027487; cv=none; b=D5NHkAhKLy7hZJ0ooTpTtT/ta4qYNTcEU3DiNAOCW8cY9MQDmXy3+M/NgQqyFcKzA75RK0bHlWSaSVXXb7rpEGUHO3hdyaY8aZ89qvZU6uWK3INXsb0xp+hrqAckSyH1k58wIeU60lVulIUDEa3naQQqHRoW1d28hV/6+bk1gxo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789027487; c=relaxed/simple;
	bh=Aknesmf63WWHxnl+hUnB2nUJ2tvXQcu76VS7Rq08R1U=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Vp+0cRd5oW5jCG2mSb74WqmpYo6f6inGyo/Zeugwt9tcAMs00tXdngELoCPv1akkO0VJbqlb/UDM6PkayksutQz0hhnc0ID9K5K+L0k3nGK6tVt5iSApzOyKliKoj7zLuDBA3Pw8+coOK6dTG7e0+6g0G6rHtizT7fkbhM1GLNk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=poczta.fm; spf=pass smtp.mailfrom=poczta.fm; dkim=pass (1024-bit key) header.d=poczta.fm header.i=@poczta.fm header.b=gbnjwNtR; arc=none smtp.client-ip=217.74.67.49
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=poczta.fm
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=poczta.fm
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=poczta.fm header.i=@poczta.fm header.b="gbnjwNtR"
Received: from localhost (unknown [80.68.231.31])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (P-256) server-signature ECDSA (P-256) server-digest SHA256)
	(No client certificate requested)
	by poczta.interia.pl (INTERIA.PL) with ESMTPSA;
	Thu, 10 Sep 2026 10:04:27 +0200 (CEST)
From: Slawomir Stepien <sst@poczta.fm>
To: syzkaller-bugs@googlegroups.com,
	johannes@sipsolutions.net,
	linux-wireless@vger.kernel.org
Cc: linux-kernel@vger.kernel.org,
	syzbot@lists.linux.dev,
	sst@poczta.fm,
	syzbot+9bdc0c5998ab45b05030@syzkaller.appspotmail.com
Subject: [PATCH v2 3/3] wifi: cfg80211: check if AP has been started or joined a mesh before adding new station
Date: Thu, 10 Sep 2026 10:04:18 +0200
Message-ID: <20260910080418.725741-3-sst@poczta.fm>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260910080418.725741-1-sst@poczta.fm>
References: <20260910080418.725741-1-sst@poczta.fm>
Precedence: bulk
X-Mailing-List: syzbot@lists.linux.dev
List-Id: <syzbot.lists.linux.dev>
List-Subscribe: <mailto:syzbot+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:syzbot+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=poczta.fm; s=dk;
	t=1789027468; bh=wXmof0fVgwPh18EP2lIyPcZjTugPqgnEEJB7r9J78VM=;
	h=From:To:Subject:Date:Message-ID:MIME-Version;
	b=gbnjwNtRRlVLcD8DjmFDseoORM1k/R/QESvcWBPanP0dQlLeNd2EhCQ+7PfLeheuf
	 dcBWjM/6J1HIyAwAFQ3Fe3VcGRC/6u22bXEvm3McInc5yIyW9nZywUxNdr1hdyEQFk
	 WGH6X9sbRmFsC/SlVUbAungZ8psJiQl3KY8+ITnc=

Adding a new station to AP makes only sense when the AP has been started
(nl80211_start_ap()) or joined a mesh (__cfg80211_join_mesh()).

Check if AP is up and beaconing on the link or joined the mesh, when
adding new station. Return error if this isn't the case.

Note that libertas devices need special handling since they do not
implement join_mesh() and the decision must be made on channel
definition.

Reported-by: syzbot+9bdc0c5998ab45b05030@syzkaller.appspotmail.com
Closes: https://syzkaller.appspot.com/bug?extid=9bdc0c5998ab45b05030
Signed-off-by: Slawomir Stepien <sst@poczta.fm>
---
v2:
* Add mesh handling (inc. libertas devices special case)

v1:
* https://lore.kernel.org/all/20260813090434.2071318-3-sst@poczta.fm/
---
 net/wireless/nl80211.c | 20 +++++++++++++++++++-
 1 file changed, 19 insertions(+), 1 deletion(-)

diff --git a/net/wireless/nl80211.c b/net/wireless/nl80211.c
index 8f7238415047..fca19e1d0c9a 100644
--- a/net/wireless/nl80211.c
+++ b/net/wireless/nl80211.c
@@ -9328,7 +9328,7 @@ static int nl80211_set_station(struct sk_buff *skb, struct genl_info *info)
 static int nl80211_new_station(struct sk_buff *skb, struct genl_info *info)
 {
 	struct cfg80211_registered_device *rdev = info->user_ptr[0];
-	int err;
+	int err, link_id;
 	struct wireless_dev *wdev = info->user_ptr[1];
 	struct net_device *dev = wdev->netdev;
 	struct station_parameters params;
@@ -9567,6 +9567,11 @@ static int nl80211_new_station(struct sk_buff *skb, struct genl_info *info)
 	switch (wdev->iftype) {
 	case NL80211_IFTYPE_AP:
 	case NL80211_IFTYPE_P2P_GO:
+		/* Add a new station only after the AP and link has been started */
+		link_id = wdev->valid_links ? params.link_sta_params.link_id : 0;
+		if (!wdev->links[link_id].ap.beacon_interval)
+			return -ENETDOWN;
+
 		/* ignore WME attributes if iface/sta is not capable */
 		if (!(rdev->wiphy.flags & WIPHY_FLAG_AP_UAPSD) ||
 		    !(params.sta_flags_set & BIT(NL80211_STA_FLAG_WME)))
@@ -9611,6 +9616,19 @@ static int nl80211_new_station(struct sk_buff *skb, struct genl_info *info)
 			return PTR_ERR(params.vlan);
 		break;
 	case NL80211_IFTYPE_MESH_POINT:
+		/*
+		 * Add a new station only after the mesh has been started.
+		 * libertas doesn't implement join_mesh(); it configures the
+		 * mesh via sysfs and joins it when the channel is set, so
+		 * use that as the started indication instead.
+		 */
+		if (rdev->ops->libertas_set_mesh_channel) {
+			if (!wdev->u.mesh.chandef.chan)
+				return -ENETDOWN;
+		} else if (!wdev->u.mesh.beacon_interval) {
+			return -ENETDOWN;
+		}
+
 		/* ignore uAPSD data */
 		params.sta_modify_mask &= ~STATION_PARAM_APPLY_UAPSD;
 
-- 
2.55.0

