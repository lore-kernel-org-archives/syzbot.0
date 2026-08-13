Received: from smtpo49.interia.pl (smtpo49.interia.pl [217.74.67.49])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7B54B3E4C9F
	for <syzbot@lists.linux.dev>; Thu, 13 Aug 2026 09:04:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.74.67.49
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786611896; cv=none; b=sYXmdVHi1jQULRk2P+RnlKEJgZMxuxi1bw1ZhMhVGro9sqR9gHsYWDIwxmKnv27+BadMQbkGk7fxQfLL9kPeqgrN2LlCDzQRw+HYVO3o/NGbQj/cLnr6v3e95On9XdfqZgUlKVHBNKak8fDxFIRrLO3AvEtd/aXgNOM81zHObbY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786611896; c=relaxed/simple;
	bh=bDboF+sXTcdnYjN9pGdiSqM5dfNz9ZSQi823leFT+gw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=EbIwPsrPcBM9CS5iIFH5KLEnmgxlQB/6MQlAezW9uVwTuA2ROh6IM0Gd4TmWDL66YTeW2a4JigOcpUEc+Tuu17VlorEjfVM7jy5WCFErEtHBeognbxdJmdbsM7fmXIC0o8sumOZDyWkEtucq9RqSwhp9WUhY75FwYMkD1xRBLj4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=poczta.fm; spf=pass smtp.mailfrom=poczta.fm; dkim=pass (1024-bit key) header.d=poczta.fm header.i=@poczta.fm header.b=K/UzOfuM; arc=none smtp.client-ip=217.74.67.49
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=poczta.fm
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=poczta.fm
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=poczta.fm header.i=@poczta.fm header.b="K/UzOfuM"
Received: from localhost (unknown [80.68.231.31])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (P-256) server-signature ECDSA (P-256) server-digest SHA256)
	(No client certificate requested)
	by poczta.interia.pl (INTERIA.PL) with ESMTPSA;
	Thu, 13 Aug 2026 11:04:45 +0200 (CEST)
From: Slawomir Stepien <sst@poczta.fm>
To: syzkaller-bugs@googlegroups.com,
	johannes@sipsolutions.net,
	linux-wireless@vger.kernel.org
Cc: linux-kernel@vger.kernel.org,
	syzbot@lists.linux.dev,
	sst@poczta.fm,
	syzbot+9bdc0c5998ab45b05030@syzkaller.appspotmail.com
Subject: [PATCH 2/3] wifi: cfg80211: move link_id validation earlier in nl80211_new_station()
Date: Thu, 13 Aug 2026 11:04:33 +0200
Message-ID: <20260813090434.2071318-2-sst@poczta.fm>
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
	t=1786611886; bh=csBUxTAsN86gwAH/axYN10YvWGNt5H8M3XCNZoUAPig=;
	h=From:To:Subject:Date:Message-ID:MIME-Version;
	b=K/UzOfuMnTxom2zv9Onk4GDsKLEA6FITDCZTrOA3ZWFahmlX7r+7SXjThvO0zIje4
	 LL2K0ErNk4A+747mWU0GVrZsPWh1rov2W34F0Ll86lDm7qKMMffsWpLmaLNdxhER1i
	 B2QTMQOBY7RrrEbhb5Y1nI8HVLEcnci4dHVw98ys=

I do not see a reason why this check is so low in the function. Move it
up right next to param fetch.

This new position is more beneficial for AP/Link state check that will
be added in upcoming commit.

Signed-off-by: Slawomir Stepien <sst@poczta.fm>
---
 net/wireless/nl80211.c | 27 ++++++++++-----------------
 1 file changed, 10 insertions(+), 17 deletions(-)

diff --git a/net/wireless/nl80211.c b/net/wireless/nl80211.c
index 0c4e6bd6a44c..ebde52655904 100644
--- a/net/wireless/nl80211.c
+++ b/net/wireless/nl80211.c
@@ -9222,6 +9222,16 @@ static int nl80211_new_station(struct sk_buff *skb, struct genl_info *info)
 	params.link_sta_params.link_id =
 		nl80211_link_id_or_invalid(info->attrs);
 
+	if (wdev->valid_links) {
+		if (params.link_sta_params.link_id < 0)
+			return -EINVAL;
+		if (!(wdev->valid_links & BIT(params.link_sta_params.link_id)))
+			return -ENOLINK;
+	} else {
+		if (params.link_sta_params.link_id >= 0)
+			return -EINVAL;
+	}
+
 	if (info->attrs[NL80211_ATTR_MLD_ADDR]) {
 		mac_addr = nla_data(info->attrs[NL80211_ATTR_MLD_ADDR]);
 		params.link_sta_params.mld_mac = mac_addr;
@@ -9494,27 +9504,10 @@ static int nl80211_new_station(struct sk_buff *skb, struct genl_info *info)
 
 	/* be aware of params.vlan when changing code here */
 
-	if (wdev->valid_links) {
-		if (params.link_sta_params.link_id < 0) {
-			err = -EINVAL;
-			goto out;
-		}
-		if (!(wdev->valid_links & BIT(params.link_sta_params.link_id))) {
-			err = -ENOLINK;
-			goto out;
-		}
-	} else {
-		if (params.link_sta_params.link_id >= 0) {
-			err = -EINVAL;
-			goto out;
-		}
-	}
-
 	params.epp_peer =
 		nla_get_flag(info->attrs[NL80211_ATTR_EPP_PEER]);
 
 	err = rdev_add_station(rdev, wdev, mac_addr, &params);
-out:
 	dev_put(params.vlan);
 	return err;
 }
-- 
2.55.0

