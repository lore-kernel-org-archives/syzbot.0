Received: from smtpo49.interia.pl (smtpo49.interia.pl [217.74.67.49])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E1DC2414A29
	for <syzbot@lists.linux.dev>; Thu, 13 Aug 2026 09:04:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.74.67.49
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786611906; cv=none; b=hXYbi5WuFEZQgLc7HqiGCAprdCDzETJnoHjbqccIjLlJZSaST7NrN8g3DAh99dCV09i9pyjoUgW7euNFoeMVIm5kKGfGltupHy2AFaH785DRNeAGtOvan0n7rF4RAAcsx2SBrdFLDzp2opRQWeRrI3Ry/w6AK3GnK/4oGQqowWQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786611906; c=relaxed/simple;
	bh=y1Y2PC6oHn0pULjHaz63Ji3mGw6NQd3Ak0qLlIKHJ7I=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Y9EmJ6de5hqqIDsnWuZwElJd9NtaPVkczRyUtvbsl0VW2lzjmwTx+4qvRA8k075GO6YjQK2I4E29MCebPlqi0w52LinRxTSmOXuPaDKrhaVpHEdFEO47hMomocq3wmaAlkMmBMwp/poi3tnY+FFOdN6ekXgZRzopNgchQnoKIW8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=poczta.fm; spf=pass smtp.mailfrom=poczta.fm; dkim=pass (1024-bit key) header.d=poczta.fm header.i=@poczta.fm header.b=oZh2KHNm; arc=none smtp.client-ip=217.74.67.49
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=poczta.fm
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=poczta.fm
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=poczta.fm header.i=@poczta.fm header.b="oZh2KHNm"
Received: from localhost (unknown [80.68.231.31])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (P-256) server-signature ECDSA (P-256) server-digest SHA256)
	(No client certificate requested)
	by poczta.interia.pl (INTERIA.PL) with ESMTPSA;
	Thu, 13 Aug 2026 11:04:47 +0200 (CEST)
From: Slawomir Stepien <sst@poczta.fm>
To: syzkaller-bugs@googlegroups.com,
	johannes@sipsolutions.net,
	linux-wireless@vger.kernel.org
Cc: linux-kernel@vger.kernel.org,
	syzbot@lists.linux.dev,
	sst@poczta.fm,
	syzbot+9bdc0c5998ab45b05030@syzkaller.appspotmail.com
Subject: [PATCH 3/3] wifi: cfg80211: check if AP has been started before adding new station
Date: Thu, 13 Aug 2026 11:04:34 +0200
Message-ID: <20260813090434.2071318-3-sst@poczta.fm>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260813090434.2071318-1-sst@poczta.fm>
References: <20260813090434.2071318-1-sst@poczta.fm>
Precedence: bulk
X-Mailing-List: syzbot@lists.linux.dev
List-Id: <syzbot.lists.linux.dev>
List-Subscribe: <mailto:syzbot+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:syzbot+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=poczta.fm; s=dk;
	t=1786611888; bh=6pkUEdW4H6yJqA39KYOX8H/dCYwKbzMzc6F1mVIA8w0=;
	h=From:To:Subject:Date:Message-ID:MIME-Version;
	b=oZh2KHNmSwXRigcpSGADAJ1ODOTu3FDUeJIjTaisGjxhM6XMOpeuGDGfPfFG+/t76
	 pM1T6bnme1ks3yW4oR4FPdJ4wnmA6eoNiluZVxfiP2TUQwG1tI5AEoCfUmCcTLvTCj
	 AA0vK7uehLNw4aMDvNgfxKlAc9aGqJmM7GKXZyfI=

Adding a new station to AP makes only sense when the AP has been started
beforehand (nl80211_start_ap()). Check if AP is up and beaconing on the
link when adding new station. Return error if this isn't the case.

Reported-by: syzbot+9bdc0c5998ab45b05030@syzkaller.appspotmail.com
Closes: https://syzkaller.appspot.com/bug?extid=9bdc0c5998ab45b05030
Signed-off-by: Slawomir Stepien <sst@poczta.fm>
---
 net/wireless/nl80211.c | 7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

diff --git a/net/wireless/nl80211.c b/net/wireless/nl80211.c
index ebde52655904..75bbd78f91ba 100644
--- a/net/wireless/nl80211.c
+++ b/net/wireless/nl80211.c
@@ -9174,7 +9174,7 @@ static int nl80211_set_station(struct sk_buff *skb, struct genl_info *info)
 static int nl80211_new_station(struct sk_buff *skb, struct genl_info *info)
 {
 	struct cfg80211_registered_device *rdev = info->user_ptr[0];
-	int err;
+	int err, link_id;
 	struct wireless_dev *wdev = info->user_ptr[1];
 	struct net_device *dev = wdev->netdev;
 	struct station_parameters params;
@@ -9413,6 +9413,11 @@ static int nl80211_new_station(struct sk_buff *skb, struct genl_info *info)
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
-- 
2.55.0

