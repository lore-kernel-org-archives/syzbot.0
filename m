Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3F2093A63F2
	for <syzbot@lists.linux.dev>; Fri, 29 May 2026 21:26:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780090010; cv=none; b=jHbf3gdNp2CGOHdOSxJHswp2mmdxl1sFs0DqsSQ+Xq15kxYhlfzD3vCNkhuDQU3rSKw0zJSOxhLssagcrsHW5sTPEuiCYoX7/aqY1KHc+s4XtSMhOaIbk92x93Rg6NUo0l5m2XMuSK9j83pbzxF64s+dpZJccqJFBLl5mI/erUw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780090010; c=relaxed/simple;
	bh=NLm8Y5QUBaZsMCJZq6E+8xgPKUdrr6qgld3Z82z4hzA=;
	h=From:To:Cc:Subject:Message-ID:MIME-Version:Content-Type:Date; b=o6HG5/wLM9FrnSb6LXlEICJOBChSWyH7WiXU9zK2oBiAaW6EqZeD7WQJhRu/tQlQzOIect9SWG5kY7cRBB9Vk6bRbAMR0A5Ly4JY5QEpBP71ruIFG/SEun1EJrs70HhUhN2vNl6wQZtgBZ0XusUBTpiVtfF+33YIqbYFWoyDUV4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=XXYutGbm; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="XXYutGbm"
Received: by smtp.kernel.org (Postfix) with UTF8SMTPSA id B92B21F00893;
	Fri, 29 May 2026 21:26:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1780090008;
	bh=17n3I2Gw6AZziaCevEUYoYChiUyp1/fHktTd3XCRl6w=;
	h=From:To:Cc:Subject:Date;
	b=XXYutGbmCYbNAlRggDDNQYMqlTvgC0W0yuLdsSUR+V4k+gU2eZLJRqb9xekH47zOr
	 cyUUztxLbi2gWxHBUZSzTvzbdbK4exjPDELMad+TREeYV4nBOZJmmlhBj1hRcbKQRE
	 ZX2u6ThqY7YA8dQ4BTJsfzavVN6fNHIc86UYJzIamAUn9Bb+NPxpF4bankAtOapNOK
	 PHZzlq8pipWPsgbCV4WqLr+4B8CUxbPck/QaF3RPylbmDsdmuN1STTUi5KzWGMzHMB
	 ZjifW66Z036QIAa4xYy9juI20cSFDvCNqdJSuthGxZIkLlkLksk4IaVJgUfbFn5v0J
	 CKj0QAnsnuM/w==
From: "syzbot" <syzbot@kernel.org>
To: syzkaller-upstream-moderation@googlegroups.com
Cc: syzbot@lists.linux.dev
Subject: [PATCH RFC] net: handle device_rename() failures during netns switch
Message-ID: <e97e27fb-09f0-4347-a3de-cdd792eab2b9@mail.kernel.org>
Precedence: bulk
X-Mailing-List: syzbot@lists.linux.dev
List-Id: <syzbot.lists.linux.dev>
List-Subscribe: <mailto:syzbot+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:syzbot+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Date: Fri, 29 May 2026 21:26:48 +0000 (UTC)

Memory allocation failures during a network namespace switch (e.g., in
device_rename()) trigger WARN_ON(err) in __dev_change_net_namespace(),
cfg802154_switch_netns(), and cfg80211_switch_netns(). WARN_ON must not be
used for conditions that can legitimately happen, such as -ENOMEM, because
it crashes machines with panic_on_warn enabled. A less severe logging
mechanism like dev_warn() or netdev_warn() should be used instead.

Handling these failures is tricky. Reverting the logical namespace change
(dev_net_set(dev, net_old)) when device_rename() fails introduces a KASAN
slab-use-after-free bug. This happens because cfg802154_pernet_exit() and
cfg80211_pernet_exit() attempt to move devices back to init_net when a
namespace is destroyed. If device_rename() fails and the change is
reverted, devices are left in the dying namespace. When the namespace is
subsequently destroyed, default_device_exit_batch() unregisters all
remaining netdevs. Drivers like mac802154 and mac80211 do not properly
handle NETDEV_UNREGISTER for their internal interface lists, leading to a
UAF when the list is later accessed.

On the other hand, simply ignoring the failure and accepting the sysfs
inconsistency leads to another UAF in kernfs_ns_id. device_rename() is
responsible for updating the sysfs directory's namespace tag (kn->ns). If
it fails, the sysfs directory remains tagged with the old network
namespace. When the old namespace is destroyed, the kn->ns pointer becomes
dangling. Later, when the device is unregistered, device_del() tries to
remove sysfs entries and dereferences this freed namespace pointer.

To safely handle device_rename() failures without causing either UAF, we
must not revert the logical namespace change. This ensures the device
successfully moves to the new namespace (e.g., init_net) and avoids being
unregistered by the dying namespace's cleanup routine. Instead, we manually
update the sysfs namespace tag. If device_rename() fails, the kobject still
retains its old name. We can call sysfs_rename_dir_ns() with the old name
and the new namespace. Because the name hasn't changed, kernfs_rename_ns()
will not allocate memory and will successfully update the namespace tag,
preventing the kernfs UAF. Finally, we replace the WARN_ON(err) calls with
netdev_warn() and dev_warn() across net/core/dev.c, net/ieee802154/core.c,
and net/wireless/core.c to log the expected memory allocation failures
without crashing the system.

Fixes: 8b41d1887db7 ("[NET]: Fix running without sysfs")
Assisted-by: Gemini:gemini-3.1-pro-preview Gemini:gemini-3-flash-preview syzbot
Reported-by: syzbot+3344d668bbbc12996d46@syzkaller.appspotmail.com
Closes: https://syzkaller.appspot.com/bug?extid=3344d668bbbc12996d46
Link: https://syzkaller.appspot.com/ai_job?id=85f31f19-953c-4b06-8f37-956317d66ff1
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
Cc: "Stanislav Fomichev" <sdf.kernel@gmail.com>

---
diff --git a/net/core/dev.c b/net/core/dev.c
index 0c6c270d9..25f0d8bf5 100644
--- a/net/core/dev.c
+++ b/net/core/dev.c
@@ -12652,7 +12652,12 @@ int __dev_change_net_namespace(struct net_device *dev, struct net *net,
 	dev_set_uevent_suppress(&dev->dev, 1);
 	err = device_rename(&dev->dev, dev->name);
 	dev_set_uevent_suppress(&dev->dev, 0);
-	WARN_ON(err);
+	if (err) {
+		netdev_warn(dev, "failed to rename device: %d\n", err);
+		sysfs_rename_dir_ns(&dev->dev.kobj,
+				    kobject_name(&dev->dev.kobj),
+				    kobject_namespace(&dev->dev.kobj));
+	}
 
 	/* Send a netdev-add uevent to the new namespace */
 	kobject_uevent(&dev->dev.kobj, KOBJ_ADD);
@@ -12662,7 +12667,8 @@ int __dev_change_net_namespace(struct net_device *dev, struct net *net,
 	 * namespace is different from the original one.
 	 */
 	err = netdev_change_owner(dev, net_old, net);
-	WARN_ON(err);
+	if (err)
+		netdev_warn(dev, "failed to change owner: %d\n", err);
 
 	netdev_lock(dev);
 	dev->moving_ns = false;
diff --git a/net/ieee802154/core.c b/net/ieee802154/core.c
index 89b671b12..ddff07ae8 100644
--- a/net/ieee802154/core.c
+++ b/net/ieee802154/core.c
@@ -245,7 +245,11 @@ int cfg802154_switch_netns(struct cfg802154_registered_device *rdev,
 			wpan_dev->netdev->netns_immutable = false;
 			err = dev_change_net_namespace(wpan_dev->netdev, net,
 						       "wpan%d");
-			WARN_ON(err);
+			if (err)
+				dev_warn(
+					&rdev->wpan_phy.dev,
+					"failed to revert netns change for wpan_dev: %d\n",
+					err);
 			wpan_dev->netdev->netns_immutable = true;
 		}
 
@@ -255,7 +259,9 @@ int cfg802154_switch_netns(struct cfg802154_registered_device *rdev,
 	wpan_phy_net_set(&rdev->wpan_phy, net);
 
 	err = device_rename(&rdev->wpan_phy.dev, dev_name(&rdev->wpan_phy.dev));
-	WARN_ON(err);
+	if (err)
+		dev_warn(&rdev->wpan_phy.dev, "failed to rename device: %d\n",
+			 err);
 
 	return 0;
 }
diff --git a/net/wireless/core.c b/net/wireless/core.c
index 6783e0672..824009c30 100644
--- a/net/wireless/core.c
+++ b/net/wireless/core.c
@@ -184,7 +184,11 @@ int cfg80211_switch_netns(struct cfg80211_registered_device *rdev,
 			wdev->netdev->netns_immutable = false;
 			err = dev_change_net_namespace(wdev->netdev, net,
 							"wlan%d");
-			WARN_ON(err);
+			if (err)
+				dev_warn(
+					&rdev->wiphy.dev,
+					"failed to revert netns change for wdev: %d\n",
+					err);
 			wdev->netdev->netns_immutable = true;
 		}
 
@@ -204,7 +208,9 @@ int cfg80211_switch_netns(struct cfg80211_registered_device *rdev,
 	wiphy_net_set(&rdev->wiphy, net);
 
 	err = device_rename(&rdev->wiphy.dev, dev_name(&rdev->wiphy.dev));
-	WARN_ON(err);
+	if (err)
+		dev_warn(&rdev->wiphy.dev, "failed to rename device: %d\n",
+			 err);
 
 	nl80211_notify_wiphy(rdev, NL80211_CMD_NEW_WIPHY);
 


base-commit: e7ae89a0c97ce2b68b0983cd01eda67cf373517d
-- 
This is an AI-generated patch subject to moderation.
Reply with '#syz upstream' to Sign-off the patch as a human author
and send it to the upstream kernel mailing lists.
Reply with '#syz reject' to reject it ('#syz unreject' to undo).

See https://goo.gle/syzbot-ai-patches for information about AI-generated patches.
You can comment on the patch as usual, syzbot will try to address
the comments and send a new version of the patch if necessary.
syzbot engineers can be reached at syzkaller@googlegroups.com.
