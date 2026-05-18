Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 92FBC39BFE7
	for <syzbot@lists.linux.dev>; Mon, 18 May 2026 22:07:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779142077; cv=none; b=dqFaYSmAy0nbooyoZyO+JPVrynDZVyMs6ICngrYscG6rZ2Yfx9HbNiTlzrVcfYIXqok9cu/mf2c5sWRmC9VCSaybBdvsVcBphJ0mvfOrSWqnxwsDM1ISuXNKbAIg7WAcAS77hPS40f+srtCQitB1ZftTTZYcn2o1Yvou8kaBF6Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779142077; c=relaxed/simple;
	bh=REKDES0sXRwgVeO52Ru4tCQI4fkptdFeos/TKniNnms=;
	h=From:To:Cc:Subject:Message-ID:MIME-Version:Content-Type:Date; b=LATZDioTApJH7k2D3TSRzcU7nbiHtZ8vLUsSdQWbPCheguCqLjCF4vEXwkWin7RjM9hBjOoXxv0qNsZ5SleYbkwWtEs4nbvueW55IqqKyOwhTbx/IfBvDlrilYCFudMebSdEQKFYD5tbdneiTfqyKtqyaYUMnRYhRCsxDQxT+Ls=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=UZmJgbSb; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="UZmJgbSb"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 25815C2BCB7;
	Mon, 18 May 2026 22:07:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1779142077;
	bh=REKDES0sXRwgVeO52Ru4tCQI4fkptdFeos/TKniNnms=;
	h=From:To:Cc:Subject:Date:From;
	b=UZmJgbSb0nyK7K+rmZdRDvt7CDE47qqHBR9wIiFKsTH0s4CXdjTy23GvbI/lwQiIv
	 5DI4VUzgSiUC3+l7Geb2LEdLRtNQf7M7OnlAtKtSOYcVjKumPuX/XIeoR9RuCMiMPM
	 hixlTZ45fjx/AyKn4U8aN6EN+es7UIwiuB1VRhxaR8pg9+yUNNpbkJMtPyE2LXy5YQ
	 mMu0p1A/GqMMDbQPWoxCV8XUMaH2Q+Gzxy86euJG6NlOMDGWXRu6/yRQ38g78Ww0vY
	 HYt9+6DkPOBgSjVHbeWgMD9U1DtBwUJ9yBxK5OzBCgstS/ySlNcF8QBbawWkOztTJH
	 296K/ccovc8HA==
From: "syzbot" <syzbot@kernel.org>
To: syzkaller-upstream-moderation@googlegroups.com
Cc: syzbot@lists.linux.dev
Subject: [PATCH RFC v2] wifi: cfg80211: replace WARN_ON() with dev_err() in netns switch
Message-ID: <4e2d36a7-9417-4c50-9ec1-3e82c7a670f3@mail.kernel.org>
Precedence: bulk
X-Mailing-List: syzbot@lists.linux.dev
List-Id: <syzbot.lists.linux.dev>
List-Subscribe: <mailto:syzbot+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:syzbot+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Date: Mon, 18 May 2026 22:07:57 +0000 (UTC)

The syzkaller reported a kernel panic in cfg802154_switch_netns() when
device_rename() fails with -ENOMEM. The crash occurs because WARN_ON()
is used to handle the memory allocation failure, which escalates into a
kernel panic when panic_on_warn is enabled.

Memory allocation failures are expected runtime events under memory
pressure and should be handled gracefully. The WARN_ON() macro must not
be used for conditions that can legitimately happen. Failing to rename
the device or change the network namespace is not a fatal system error.

Replace the WARN_ON() calls with dev_err() in both
cfg802154_switch_netns() and cfg80211_switch_netns(), as well as in
their respective pernet exit handlers (cfg802154_pernet_exit() and
cfg80211_pernet_exit()). This ensures that memory allocation failures
under pressure are handled gracefully, logging the error for debugging
purposes without bringing down the entire system.

Fixes: 04600794958f1833f5571c6cde40f260ab557f55 ("cfg80211: support sysfs namespaces")
Assisted-by: Gemini:gemini-3.1-pro-preview Gemini:gemini-3-flash-preview
Reported-by: syzbot+bd5829ba3619f08e2341@syzkaller.appspotmail.com
Link: https://syzkaller.appspot.com/bug?extid=bd5829ba3619f08e2341
Link: https://syzkaller.appspot.com/ai_job?id=a1cfc84c-7c0f-4340-891d-885fcee80cad
To: <alex.aring@gmail.com>
To: <davem@davemloft.net>
To: <edumazet@google.com>
To: <kuba@kernel.org>
To: <linux-wpan@vger.kernel.org>
To: <miquel.raynal@bootlin.com>
To: <netdev@vger.kernel.org>
To: <pabeni@redhat.com>
To: <stefan@datenfreihafen.org>
Cc: <horms@kernel.org>
Cc: <johannes@sipsolutions.net>
Cc: <linux-kernel@vger.kernel.org>
Cc: <linux-wireless@vger.kernel.org>

---
v2:
- Replaced pr_err() with dev_err() to include device details in the error messages.

v1:
https://lore.kernel.org/all/7d949fbc-9781-4428-bfac-e51501b18bf7@mail.kernel.org/T/
---
diff --git a/net/ieee802154/core.c b/net/ieee802154/core.c
index 89b671b12..07082857c 100644
--- a/net/ieee802154/core.c
+++ b/net/ieee802154/core.c
@@ -245,7 +245,9 @@ int cfg802154_switch_netns(struct cfg802154_registered_device *rdev,
 			wpan_dev->netdev->netns_immutable = false;
 			err = dev_change_net_namespace(wpan_dev->netdev, net,
 						       "wpan%d");
-			WARN_ON(err);
+			if (err)
+				dev_err(&rdev->wpan_phy.dev,
+					"failed to change netns: %d\n", err);
 			wpan_dev->netdev->netns_immutable = true;
 		}
 
@@ -255,7 +257,9 @@ int cfg802154_switch_netns(struct cfg802154_registered_device *rdev,
 	wpan_phy_net_set(&rdev->wpan_phy, net);
 
 	err = device_rename(&rdev->wpan_phy.dev, dev_name(&rdev->wpan_phy.dev));
-	WARN_ON(err);
+	if (err)
+		dev_err(&rdev->wpan_phy.dev, "failed to rename device: %d\n",
+			err);
 
 	return 0;
 }
@@ -350,8 +354,11 @@ static void __net_exit cfg802154_pernet_exit(struct net *net)
 
 	rtnl_lock();
 	list_for_each_entry(rdev, &cfg802154_rdev_list, list) {
-		if (net_eq(wpan_phy_net(&rdev->wpan_phy), net))
-			WARN_ON(cfg802154_switch_netns(rdev, &init_net));
+		if (net_eq(wpan_phy_net(&rdev->wpan_phy), net)) {
+			if (cfg802154_switch_netns(rdev, &init_net))
+				dev_err(&rdev->wpan_phy.dev,
+					"failed to switch netns on exit\n");
+		}
 	}
 	rtnl_unlock();
 }
diff --git a/net/wireless/core.c b/net/wireless/core.c
index 6783e0672..6badcec46 100644
--- a/net/wireless/core.c
+++ b/net/wireless/core.c
@@ -184,7 +184,9 @@ int cfg80211_switch_netns(struct cfg80211_registered_device *rdev,
 			wdev->netdev->netns_immutable = false;
 			err = dev_change_net_namespace(wdev->netdev, net,
 							"wlan%d");
-			WARN_ON(err);
+			if (err)
+				dev_err(&rdev->wiphy.dev,
+					"failed to change netns: %d\n", err);
 			wdev->netdev->netns_immutable = true;
 		}
 
@@ -204,7 +206,8 @@ int cfg80211_switch_netns(struct cfg80211_registered_device *rdev,
 	wiphy_net_set(&rdev->wiphy, net);
 
 	err = device_rename(&rdev->wiphy.dev, dev_name(&rdev->wiphy.dev));
-	WARN_ON(err);
+	if (err)
+		dev_err(&rdev->wiphy.dev, "failed to rename device: %d\n", err);
 
 	nl80211_notify_wiphy(rdev, NL80211_CMD_NEW_WIPHY);
 
@@ -1809,8 +1812,11 @@ static void __net_exit cfg80211_pernet_exit(struct net *net)
 
 	rtnl_lock();
 	for_each_rdev(rdev) {
-		if (net_eq(wiphy_net(&rdev->wiphy), net))
-			WARN_ON(cfg80211_switch_netns(rdev, &init_net));
+		if (net_eq(wiphy_net(&rdev->wiphy), net)) {
+			if (cfg80211_switch_netns(rdev, &init_net))
+				dev_err(&rdev->wiphy.dev,
+					"failed to switch netns on exit\n");
+		}
 	}
 	rtnl_unlock();
 }


base-commit: 5d6919055dec134de3c40167a490f33c74c12581
-- 
This is an AI-generated patch subject to moderation.
Reply with '#syz upstream' to send it to the mailing list.
Reply with '#syz reject' to reject it.

See  for more information.
