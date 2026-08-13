Received: from smtpo63.interia.pl (smtpo63.interia.pl [217.74.67.63])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E6B7E34B437
	for <syzbot@lists.linux.dev>; Thu, 13 Aug 2026 09:04:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.74.67.63
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786611895; cv=none; b=Cc47qI86cEJt8bIo7N6UA3kAR3ERIb6MfcwUfwJr2HJNfsdiX5jHhhCrHdAvdg1WhagHjA+kB0BNQ6yk8/1XnDFC5YUxB9L484P6982hFxoTPux1P3IaSxQU0Trq1m8CGyvdWvMiIke+GNex73BumSOwzY/tWYAYKJ4AElV+kNE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786611895; c=relaxed/simple;
	bh=Z9ZCY/0ud6DN/hFC4ubbd6syqy6GhZestNK6QvlyvyM=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=UWYW0Rx2GYPNVv/LA7tiyihPfCMCI8VqLidt9gAWFEbis3ZJH1UYbshEOGKD1ezKpaCt8OZa/+zHg70NpnCziHCPNslE29TA2li8UYf7Vdx+8OKAGJIpt+hkjCCNdpmJQ/Srti79GdPG211P14BsJ3SGnHv1c4Q9I1K+nOk/t7U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=poczta.fm; spf=pass smtp.mailfrom=poczta.fm; dkim=pass (1024-bit key) header.d=poczta.fm header.i=@poczta.fm header.b=BjK1LLAN; arc=none smtp.client-ip=217.74.67.63
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=poczta.fm
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=poczta.fm
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=poczta.fm header.i=@poczta.fm header.b="BjK1LLAN"
Received: from localhost (unknown [80.68.231.31])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (P-256) server-signature ECDSA (P-256) server-digest SHA256)
	(No client certificate requested)
	by poczta.interia.pl (INTERIA.PL) with ESMTPSA;
	Thu, 13 Aug 2026 11:04:42 +0200 (CEST)
From: Slawomir Stepien <sst@poczta.fm>
To: syzkaller-bugs@googlegroups.com,
	johannes@sipsolutions.net,
	linux-wireless@vger.kernel.org
Cc: linux-kernel@vger.kernel.org,
	syzbot@lists.linux.dev,
	sst@poczta.fm,
	syzbot+9bdc0c5998ab45b05030@syzkaller.appspotmail.com
Subject: [PATCH 1/3] wifi: cfg80211: do not support direct add of station to AP_VLAN interfaces
Date: Thu, 13 Aug 2026 11:04:32 +0200
Message-ID: <20260813090434.2071318-1-sst@poczta.fm>
X-Mailer: git-send-email 2.55.0
Precedence: bulk
X-Mailing-List: syzbot@lists.linux.dev
List-Id: <syzbot.lists.linux.dev>
List-Subscribe: <mailto:syzbot+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:syzbot+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=poczta.fm; s=dk;
	t=1786611884; bh=5k8+fcs2Klc2R8BVr2LxVlFc1XreW66ZG+I7aQeSmLA=;
	h=From:To:Subject:Date:Message-ID:MIME-Version;
	b=BjK1LLAN7qso5hnV43cUmaEyOHfnXynEPHCZQgntoIfkPVXmhSMu6s7CLe3SzBAaM
	 nLpnTXTW+RliHc1blRA00Qp7wsHs8hjf/a4wLodAdeZmexSR8bLlqAC4gqy55Cgm92
	 7P6Eie3L3SsRhV9f3+9eTL1XKVJzVBsleMywxWyg=

Prevent userspace from adding stations directly to AP_VLAN type
interfaces. Userspace should first add the station to the base interface
(AP type) and then can use CMD_SET_STATION to move it to AP_VLAN.

Without this path, we cannot check if the AP has been started before
adding the station - wdev for AP_VLAN does not store information about
the base AP interface.

Signed-off-by: Slawomir Stepien <sst@poczta.fm>
---
 net/wireless/nl80211.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/net/wireless/nl80211.c b/net/wireless/nl80211.c
index 5adcb6bd0fc5..0c4e6bd6a44c 100644
--- a/net/wireless/nl80211.c
+++ b/net/wireless/nl80211.c
@@ -9402,7 +9402,6 @@ static int nl80211_new_station(struct sk_buff *skb, struct genl_info *info)
 
 	switch (wdev->iftype) {
 	case NL80211_IFTYPE_AP:
-	case NL80211_IFTYPE_AP_VLAN:
 	case NL80211_IFTYPE_P2P_GO:
 		/* ignore WME attributes if iface/sta is not capable */
 		if (!(rdev->wiphy.flags & WIPHY_FLAG_AP_UAPSD) ||
-- 
2.55.0

