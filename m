Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4FA8E3ADB99
	for <syzbot@lists.linux.dev>; Wed, 13 May 2026 21:51:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778709070; cv=none; b=EzSmn0eoGMHzlk2cT+1tsShA4W2URTqCdRJmAkFWx8OOm6ITFYgbTYqT2SX4nSfrTw9BadKynpim+pkYsRajVNXDLr2cGn8Qvtc4P1sNzhCWzhiGZvptGNmQipbbpSpea2sBTx5+vsfPc8elLFWBxXl6j6tI+g7o+xGHSxs6jrA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778709070; c=relaxed/simple;
	bh=x1STcVzKPSp5NuY8qtVR2pjHX4WVJhtV8Z/WPtKIsX0=;
	h=From:To:Cc:Subject:Message-ID:MIME-Version:Content-Type:Date; b=X5fg2GhxQz4z2FUf50oSNLneBAC3fVYGDvVPpYBCSymauvp5Bwkpay41nkSGR+zPQen6wAtHdYRg176e3DWvvLqbM5bNwbRqxTENLlA0rhkAs09GHpR/j7waVAabplJJy2S2YFnpTpxVAW6jnF3jx015WIXUD45pLqUhXB0ernc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=qJoiQAwj; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="qJoiQAwj"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D0593C19425;
	Wed, 13 May 2026 21:51:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1778709069;
	bh=x1STcVzKPSp5NuY8qtVR2pjHX4WVJhtV8Z/WPtKIsX0=;
	h=From:To:Cc:Subject:Date:From;
	b=qJoiQAwjpZ9S9Wk2XYDOvjTd6VxGQo4Ro4oLjwV0VHFramXv/3Qa4lDxo0DocLJua
	 uXo6B5HoxxycxaA/M+0DnN/CL2svkx6ZZs/aa5XfRhXC+fKU8pmiC6i/82AujkM1J0
	 sJ3Z7kTwZ1TbPl/9EyezPg/WnpIN5czBgrffbEJf4LNM4HjVoSzTGhj90BL6YfURyh
	 TE9U+tnXgQdHID94vc13mdIfgqnEYqjyRNUph+me5ZwgUl4OGMvjvZxQ//53hoiO9L
	 AeBZqxwyng2G80lYBMWyDTSaChjUWb0tX75rctE8h1dRCSo97rK/QCHFQGGYdg9Pah
	 f6au2O893tJRw==
From: "syzbot" <syzbot@kernel.org>
To: syzkaller-upstream-moderation@googlegroups.com
Cc: syzbot@lists.linux.dev
Subject: [PATCH RFC] wifi: cfg80211: replace WARN_ON() with pr_err() in netns switch
Message-ID: <7d949fbc-9781-4428-bfac-e51501b18bf7@mail.kernel.org>
Precedence: bulk
X-Mailing-List: syzbot@lists.linux.dev
List-Id: <syzbot.lists.linux.dev>
List-Subscribe: <mailto:syzbot+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:syzbot+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Date: Wed, 13 May 2026 21:51:09 +0000 (UTC)

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

Fixes: 66e5c2672cd11b9310008099faf6a4ffb9dfb6d0 ("ieee802154: add netns support")
Assisted-by: Gemini:gemini-3.1-pro-preview
Reported-by: syzbot+bd5829ba3619f08e2341@syzkaller.appspotmail.com
Link: https://syzkaller.appspot.com/bug?extid=bd5829ba3619f08e2341
Link: https://syzkaller.appspot.com/ai_job?id=46668339-436e-4563-9254-73690dc813fe
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
diff --git a/net/ieee802154/core.c b/net/ieee802154/core.c
index 89b671b12..98c498e3e 100644
--- a/net/ieee802154/core.c
+++ b/net/ieee802154/core.c
@@ -245,7 +245,8 @@ int cfg802154_switch_netns(struct cfg802154_registered_device *rdev,
 			wpan_dev->netdev->netns_immutable = false;
 			err = dev_change_net_namespace(wpan_dev->netdev, net,
 						       "wpan%d");
-			WARN_ON(err);
+			if (err)
+				pr_err("failed to change netns: %d\n", err);
 			wpan_dev->netdev->netns_immutable = true;
 		}
 
@@ -255,7 +256,8 @@ int cfg802154_switch_netns(struct cfg802154_registered_device *rdev,
 	wpan_phy_net_set(&rdev->wpan_phy, net);
 
 	err = device_rename(&rdev->wpan_phy.dev, dev_name(&rdev->wpan_phy.dev));
-	WARN_ON(err);
+	if (err)
+		pr_err("failed to rename device: %d\n", err);
 
 	return 0;
 }
@@ -350,8 +352,10 @@ static void __net_exit cfg802154_pernet_exit(struct net *net)
 
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
index 6783e0672..ed5eac41f 100644
--- a/net/wireless/core.c
+++ b/net/wireless/core.c
@@ -184,7 +184,8 @@ int cfg80211_switch_netns(struct cfg80211_registered_device *rdev,
 			wdev->netdev->netns_immutable = false;
 			err = dev_change_net_namespace(wdev->netdev, net,
 							"wlan%d");
-			WARN_ON(err);
+			if (err)
+				pr_err("failed to change netns: %d\n", err);
 			wdev->netdev->netns_immutable = true;
 		}
 
@@ -204,7 +205,8 @@ int cfg80211_switch_netns(struct cfg80211_registered_device *rdev,
 	wiphy_net_set(&rdev->wiphy, net);
 
 	err = device_rename(&rdev->wiphy.dev, dev_name(&rdev->wiphy.dev));
-	WARN_ON(err);
+	if (err)
+		pr_err("failed to rename device: %d\n", err);
 
 	nl80211_notify_wiphy(rdev, NL80211_CMD_NEW_WIPHY);
 
@@ -1809,8 +1811,10 @@ static void __net_exit cfg80211_pernet_exit(struct net *net)
 
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

See  for more information.
