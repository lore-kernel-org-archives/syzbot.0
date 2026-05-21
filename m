Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A190B191F91
	for <syzbot@lists.linux.dev>; Thu, 21 May 2026 01:44:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779327863; cv=none; b=iPPvGHUuIHqT8XERzT/Wg8i/l9qUyuXe7M1RNqZ9hTOa0Ssouzg+DXUj0mt9ScKFJp5wnvtK1Pp53V7SUVZcYh+TcMeIa+4ZspSyxTl3eUm0QzZftBFonqB2+KWJi2JymQkF8oo8heGK5XFtdyoaTLUqXqJGnsLLKWB6Kg5Ymt0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779327863; c=relaxed/simple;
	bh=8fTxxtuKEhUoU97SvV5itf3SR0njf/noNEV4Lb3M6nQ=;
	h=From:To:Cc:Subject:Message-ID:MIME-Version:Content-Type:Date; b=LtqrM91fQ3meBAzauclqi5o6LcAVe3oAqYG3wN5o+6t2VytJwm8pGrWsSN1K/mGIQceayptqTnNmNah4p34EnlqAH11HBZobQqcJMXNMVP6XXSaDt497ivcdLbFQOteTci8nOrkV896UWaXTjLGEI09pRY7uBh21HNayTKcjNxc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=a3S7eqwl; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="a3S7eqwl"
Received: by smtp.kernel.org (Postfix) with UTF8SMTPSA id 60F061F000E9;
	Thu, 21 May 2026 01:44:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1779327854;
	bh=xZGSm6ftVrrL4dBZdMOsCG69UdfKvdF4z1BKVYaxYiU=;
	h=From:To:Cc:Subject:Date;
	b=a3S7eqwl76/iFA67vFv+xzoVbfoeYGepboRKdb1sNK1ww4cqf8V067vJ5gKHsY+ED
	 abPLqqo4wwX7EOQ4G1o3UEr2EccaT46aYejrI6dO0aENCXyRFTmVWMNELrbmmJUKYk
	 eIe+PCbsiHk1WR/v+v0xtXk0L9qmr6f13P6KMHTgPuHHz734nnTkqc1AB6rVbJ0Z0t
	 HhEvesWXQifbHU6fmn6W7FrgYzCcgQ5VzM1MkKAd8oLJCCpNfXlRNVH28GXDfJmoRh
	 vcghiDO0uWV7jLYH5s/d+BWLO6gaTAhsBY+341nDEOCGD2YAPQARouO+WxI7mF2uc0
	 /ghN7ZaFOWrPA==
From: "syzbot" <syzbot@kernel.org>
To: syzkaller-upstream-moderation@googlegroups.com
Cc: syzbot@lists.linux.dev
Subject: [PATCH RFC v4] net: wireless: replace WARN_ON() with dev_err() in netns switch
Message-ID: <753f899f-e529-43af-bb36-daf09d0664ed@mail.kernel.org>
Precedence: bulk
X-Mailing-List: syzbot@lists.linux.dev
List-Id: <syzbot.lists.linux.dev>
List-Subscribe: <mailto:syzbot+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:syzbot+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Date: Thu, 21 May 2026 01:44:14 +0000 (UTC)

A kernel warning can be triggered in cfg802154_switch_netns() when
device_rename() fails, for example due to memory allocation failure
(-ENOMEM). Memory allocation failures are expected runtime events under
memory pressure and should be handled gracefully. The WARN_ON() macro
must not be used for conditions that can legitimately happen. Failing to
rename the device or change the network namespace is not a fatal system
error.

Replace the WARN_ON() calls with dev_err() in both
cfg802154_switch_netns() and cfg80211_switch_netns(), as well as in
their respective pernet exit handlers (cfg802154_pernet_exit() and
cfg80211_pernet_exit()). This ensures that failures are handled
gracefully, logging the error with device context for debugging purposes
without triggering unnecessary warnings.

Fixes: 66e5c2672cd1 ("ieee802154: add netns support")
Assisted-by: Gemini:gemini-3.1-pro-preview Gemini:gemini-3-flash-preview
Reported-by: syzbot <syzbot+bd5829ba3619f08e2341@syzkaller.appspotmail.com>
Closes: https://syzkaller.appspot.com/bug?extid=bd5829ba3619f08e2341
Link: https://syzkaller.appspot.com/ai_job?id=a51ccb7f-a2f2-4fc2-85fb-a0706afcc0e8
To: "Alexander Aring" <alex.aring@gmail.com>
To: "David S. Miller" <davem@davemloft.net>
To: "Eric Dumazet" <edumazet@google.com>
To: "Johannes Berg" <johannes@sipsolutions.net>
To: "Jakub Kicinski" <kuba@kernel.org>
To: <linux-wireless@vger.kernel.org>
To: <linux-wpan@vger.kernel.org>
To: "Miquel Raynal" <miquel.raynal@bootlin.com>
To: <netdev@vger.kernel.org>
To: "Paolo Abeni" <pabeni@redhat.com>
To: "Stefan Schmidt" <stefan@datenfreihafen.org>
Cc: "Simon Horman" <horms@kernel.org>
Cc: <linux-kernel@vger.kernel.org>

---
v4:
- Replaced pr_err() with dev_err() to provide device context.
- Removed mentions of syzkaller and panic_on_warn from the description.
- Updated description to clarify that WARN_ON() is inappropriate for expected runtime failures.

v3:
- Replaced dev_err() with pr_err() for error logging.
- Introduced revert_err variable to prevent overwriting the original error code during netns cleanup.
https://lore.kernel.org/all/ba6abcc9-c09e-499a-92cf-3f59d45ef58a@mail.kernel.org/T/

v2:
- Replaced pr_err() with dev_err() to include device details in the error messages.
https://lore.kernel.org/all/4e2d36a7-9417-4c50-9ec1-3e82c7a670f3@mail.kernel.org/T/

v1:
https://lore.kernel.org/all/7d949fbc-9781-4428-bfac-e51501b18bf7@mail.kernel.org/T/
---
diff --git a/net/ieee802154/core.c b/net/ieee802154/core.c
index 89b671b12..2a40e78b5 100644
--- a/net/ieee802154/core.c
+++ b/net/ieee802154/core.c
@@ -234,6 +234,8 @@ int cfg802154_switch_netns(struct cfg802154_registered_device *rdev,
 	}
 
 	if (err) {
+		int revert_err;
+
 		/* failed -- clean up to old netns */
 		net = wpan_phy_net(&rdev->wpan_phy);
 
@@ -243,9 +245,12 @@ int cfg802154_switch_netns(struct cfg802154_registered_device *rdev,
 			if (!wpan_dev->netdev)
 				continue;
 			wpan_dev->netdev->netns_immutable = false;
-			err = dev_change_net_namespace(wpan_dev->netdev, net,
-						       "wpan%d");
-			WARN_ON(err);
+			revert_err = dev_change_net_namespace(wpan_dev->netdev,
+							      net, "wpan%d");
+			if (revert_err)
+				dev_err(&rdev->wpan_phy.dev,
+					"failed to revert netns: %d\n",
+					revert_err);
 			wpan_dev->netdev->netns_immutable = true;
 		}
 
@@ -255,7 +260,9 @@ int cfg802154_switch_netns(struct cfg802154_registered_device *rdev,
 	wpan_phy_net_set(&rdev->wpan_phy, net);
 
 	err = device_rename(&rdev->wpan_phy.dev, dev_name(&rdev->wpan_phy.dev));
-	WARN_ON(err);
+	if (err)
+		dev_err(&rdev->wpan_phy.dev, "failed to rename device: %d\n",
+			err);
 
 	return 0;
 }
@@ -350,8 +357,11 @@ static void __net_exit cfg802154_pernet_exit(struct net *net)
 
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
index 6783e0672..a7fb994cf 100644
--- a/net/wireless/core.c
+++ b/net/wireless/core.c
@@ -173,6 +173,8 @@ int cfg80211_switch_netns(struct cfg80211_registered_device *rdev,
 	}
 
 	if (err) {
+		int revert_err;
+
 		/* failed -- clean up to old netns */
 		net = wiphy_net(&rdev->wiphy);
 
@@ -182,9 +184,12 @@ int cfg80211_switch_netns(struct cfg80211_registered_device *rdev,
 			if (!wdev->netdev)
 				continue;
 			wdev->netdev->netns_immutable = false;
-			err = dev_change_net_namespace(wdev->netdev, net,
-							"wlan%d");
-			WARN_ON(err);
+			revert_err = dev_change_net_namespace(wdev->netdev, net,
+							      "wlan%d");
+			if (revert_err)
+				dev_err(&rdev->wiphy.dev,
+					"failed to revert netns: %d\n",
+					revert_err);
 			wdev->netdev->netns_immutable = true;
 		}
 
@@ -204,7 +209,8 @@ int cfg80211_switch_netns(struct cfg80211_registered_device *rdev,
 	wiphy_net_set(&rdev->wiphy, net);
 
 	err = device_rename(&rdev->wiphy.dev, dev_name(&rdev->wiphy.dev));
-	WARN_ON(err);
+	if (err)
+		dev_err(&rdev->wiphy.dev, "failed to rename device: %d\n", err);
 
 	nl80211_notify_wiphy(rdev, NL80211_CMD_NEW_WIPHY);
 
@@ -1809,8 +1815,11 @@ static void __net_exit cfg80211_pernet_exit(struct net *net)
 
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

See https://github.com/google/syzkaller/blob/master/docs/syzbot_ai_patches.md for more information.
