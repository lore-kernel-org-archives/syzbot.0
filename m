Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0253532AAC6
	for <syzbot@lists.linux.dev>; Tue, 19 May 2026 18:37:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779215829; cv=none; b=sjLL4Jp5vqLSD/GtQB1Y8r21idQBb7KuWZ4BVeSst7DFwNuuiJ+8exvdnmJQQPM1rafZSjk6pMSBpLyrYgVZGTjtXjzC3WyD7bpJeytGkajr+vAgN/N/PgJ/0k4ROPGWBd7by9OxG8l2aWhx/wJgePS2iS8Pan48G+3vUl3K5L8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779215829; c=relaxed/simple;
	bh=pkAX6gNUM97P/eA/UylehRxcHkDvuKr5+0DeheEt33s=;
	h=From:To:Cc:Subject:Message-ID:MIME-Version:Content-Type:Date; b=QUaOIXzeMVGu8FKpcqjwVUwEpiUHSTbdEI9HSJhbSO1d6Q4UlOR1t+ytuUESCCZjvFv0Ipa148JmJh87+rjo5BYq29m0dQJFMMgOq/f7lInuN1qW52HitHRwdOddwJdhb0f5oV3j1Ryzj1e64iz+OCUK5HG66XRudkaRAdbppEM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=aPAMN8D0; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="aPAMN8D0"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7C1F7C2BCB3;
	Tue, 19 May 2026 18:37:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1779215828;
	bh=pkAX6gNUM97P/eA/UylehRxcHkDvuKr5+0DeheEt33s=;
	h=From:To:Cc:Subject:Date:From;
	b=aPAMN8D0at1A7/gavHJGoBtx4RHVwcIeW0r8sPvAWmXVsdIqppxyrGU2KkAKx424O
	 qwYiQvhoqxVPiOP+Njt83Y6KLOaeJovj4H9Qdz4x2Xdb0xmuy2/Mu9pOBFVupShjX3
	 MnmCcWtUNa8hH52YMm7iuuCj4oMe7LbKppembJuP6U/zFL1WO5y+RkSb31n1N5B5TQ
	 u34/4m2vvi+aNQpW+l3Szv4THzfPDLD9ZOV6S3XXjwFQhD7lzsqE0C67oI0hvvkazL
	 JIQeCJVA58A3AoLomnjbEGaCRlJPUIyyQZD+yOGIxxN646nNjUtNepS3RQ1UsvFinL
	 sndnd+bvYBVYw==
From: "syzbot" <syzbot@kernel.org>
To: syzkaller-upstream-moderation@googlegroups.com
Cc: syzbot@lists.linux.dev
Subject: [PATCH RFC v3] wifi: cfg80211: replace WARN_ON() with pr_err() in netns switch
Message-ID: <ba6abcc9-c09e-499a-92cf-3f59d45ef58a@mail.kernel.org>
Precedence: bulk
X-Mailing-List: syzbot@lists.linux.dev
List-Id: <syzbot.lists.linux.dev>
List-Subscribe: <mailto:syzbot+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:syzbot+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Date: Tue, 19 May 2026 18:37:08 +0000 (UTC)

The syzkaller reported a kernel panic in cfg802154_switch_netns() when
device_rename() fails with -ENOMEM. The crash occurs because WARN_ON()
is used to handle the memory allocation failure, which escalates into a
kernel panic when panic_on_warn is enabled.

Memory allocation failures are expected runtime events under memory
pressure and should be handled gracefully. The WARN_ON() macro must not
be used for conditions that can legitimately happen. Failing to rename
the device or change the network namespace is not a fatal system error.

Replace the WARN_ON() calls with pr_err() in both
cfg802154_switch_netns() and cfg80211_switch_netns(), as well as in
their respective pernet exit handlers (cfg802154_pernet_exit() and
cfg80211_pernet_exit()). This ensures that memory allocation failures
under pressure are handled gracefully, logging the error for debugging
purposes without bringing down the entire system.

Fixes: 66e5c2672cd1 ("ieee802154: add netns support")
Assisted-by: Gemini:gemini-3.1-pro-preview Gemini:gemini-3-flash-preview
Reported-by: syzbot+bd5829ba3619f08e2341@syzkaller.appspotmail.com
Reported-by: syzbot <syzbot+bd5829ba3619f08e2341@syzkaller.appspotmail.com>
Link: https://syzkaller.appspot.com/bug?extid=bd5829ba3619f08e2341
Link: https://syzkaller.appspot.com/ai_job?id=c84689f4-6a93-47bf-80ca-3bc6137dce52
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
v3:
- Replaced dev_err() with pr_err() for error logging.
- Introduced revert_err variable to prevent overwriting the original error code during netns cleanup.

v2:
- Replaced pr_err() with dev_err() to include device details in the error messages.
https://lore.kernel.org/all/4e2d36a7-9417-4c50-9ec1-3e82c7a670f3@mail.kernel.org/T/

v1:
https://lore.kernel.org/all/7d949fbc-9781-4428-bfac-e51501b18bf7@mail.kernel.org/T/
---
diff --git a/net/ieee802154/core.c b/net/ieee802154/core.c
index 89b671b12..dcf46b848 100644
--- a/net/ieee802154/core.c
+++ b/net/ieee802154/core.c
@@ -234,6 +234,8 @@ int cfg802154_switch_netns(struct cfg802154_registered_device *rdev,
 	}
 
 	if (err) {
+		int revert_err;
+
 		/* failed -- clean up to old netns */
 		net = wpan_phy_net(&rdev->wpan_phy);
 
@@ -243,9 +245,11 @@ int cfg802154_switch_netns(struct cfg802154_registered_device *rdev,
 			if (!wpan_dev->netdev)
 				continue;
 			wpan_dev->netdev->netns_immutable = false;
-			err = dev_change_net_namespace(wpan_dev->netdev, net,
-						       "wpan%d");
-			WARN_ON(err);
+			revert_err = dev_change_net_namespace(wpan_dev->netdev,
+							      net, "wpan%d");
+			if (revert_err)
+				pr_err("failed to revert netns: %d\n",
+				       revert_err);
 			wpan_dev->netdev->netns_immutable = true;
 		}
 
@@ -255,7 +259,8 @@ int cfg802154_switch_netns(struct cfg802154_registered_device *rdev,
 	wpan_phy_net_set(&rdev->wpan_phy, net);
 
 	err = device_rename(&rdev->wpan_phy.dev, dev_name(&rdev->wpan_phy.dev));
-	WARN_ON(err);
+	if (err)
+		pr_err("failed to rename device: %d\n", err);
 
 	return 0;
 }
@@ -350,8 +355,10 @@ static void __net_exit cfg802154_pernet_exit(struct net *net)
 
 	rtnl_lock();
 	list_for_each_entry(rdev, &cfg802154_rdev_list, list) {
-		if (net_eq(wpan_phy_net(&rdev->wpan_phy), net))
-			WARN_ON(cfg802154_switch_netns(rdev, &init_net));
+		if (net_eq(wpan_phy_net(&rdev->wpan_phy), net)) {
+			if (cfg802154_switch_netns(rdev, &init_net))
+				pr_err("failed to switch netns on exit\n");
+		}
 	}
 	rtnl_unlock();
 }
diff --git a/net/wireless/core.c b/net/wireless/core.c
index 6783e0672..674802d1c 100644
--- a/net/wireless/core.c
+++ b/net/wireless/core.c
@@ -173,6 +173,8 @@ int cfg80211_switch_netns(struct cfg80211_registered_device *rdev,
 	}
 
 	if (err) {
+		int revert_err;
+
 		/* failed -- clean up to old netns */
 		net = wiphy_net(&rdev->wiphy);
 
@@ -182,9 +184,11 @@ int cfg80211_switch_netns(struct cfg80211_registered_device *rdev,
 			if (!wdev->netdev)
 				continue;
 			wdev->netdev->netns_immutable = false;
-			err = dev_change_net_namespace(wdev->netdev, net,
-							"wlan%d");
-			WARN_ON(err);
+			revert_err = dev_change_net_namespace(wdev->netdev, net,
+							      "wlan%d");
+			if (revert_err)
+				pr_err("failed to revert netns: %d\n",
+				       revert_err);
 			wdev->netdev->netns_immutable = true;
 		}
 
@@ -204,7 +208,8 @@ int cfg80211_switch_netns(struct cfg80211_registered_device *rdev,
 	wiphy_net_set(&rdev->wiphy, net);
 
 	err = device_rename(&rdev->wiphy.dev, dev_name(&rdev->wiphy.dev));
-	WARN_ON(err);
+	if (err)
+		pr_err("failed to rename device: %d\n", err);
 
 	nl80211_notify_wiphy(rdev, NL80211_CMD_NEW_WIPHY);
 
@@ -1809,8 +1814,10 @@ static void __net_exit cfg80211_pernet_exit(struct net *net)
 
 	rtnl_lock();
 	for_each_rdev(rdev) {
-		if (net_eq(wiphy_net(&rdev->wiphy), net))
-			WARN_ON(cfg80211_switch_netns(rdev, &init_net));
+		if (net_eq(wiphy_net(&rdev->wiphy), net)) {
+			if (cfg80211_switch_netns(rdev, &init_net))
+				pr_err("failed to switch netns on exit\n");
+		}
 	}
 	rtnl_unlock();
 }


base-commit: 5d6919055dec134de3c40167a490f33c74c12581
-- 
This is an AI-generated patch subject to moderation.
Reply with '#syz upstream' to send it to the mailing list.
Reply with '#syz reject' to reject it.

See https://github.com/google/syzkaller/blob/master/docs/syzbot_ai_patches.md for more information.
