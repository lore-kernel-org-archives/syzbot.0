Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 18F784964F
	for <syzbot@lists.linux.dev>; Sun, 19 Jul 2026 12:49:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784465385; cv=none; b=jSKD++vKPlI/XMHMMHMuGM+zWPyzDYHdpDx8zjNmNkUTp6h7tx2EQXdn/Q21F1HyVOQ7Zpubqf296/q9ueTOijqJ2Q/zD3KZBpiZ7xTycV9Uxv5sDJ2niSy9hFwUWBXWk0ZbqjG6mFqz6OFM6VRy7l1/VFpB86KJpIB2ZwO8go4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784465385; c=relaxed/simple;
	bh=LUmzkRDdxL3WOXKHkwyGj5tQVsAvjtbAgS3Ms7RiBpU=;
	h=From:To:Cc:Subject:Message-ID:MIME-Version:Content-Type:Date; b=uR1FDXkQrEQ3Y/Bzg/MS10Qhl2A+25xssgh01DM9Y2IDDuRorBiABcTp3rGFVK7jHu91ijegrwECUfVrH6DS4K8+LiLGucV1NaiC/6jJGN5b2OwQGl9EAaiPSEDt6XC4B2xvuXhIm0lixDyPsNEoju5lLkdd99vDAOdynrK9YUI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=H6ymdhdi; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="H6ymdhdi"
Received: by smtp.kernel.org (Postfix) with UTF8SMTPSA id 902041F000E9;
	Sun, 19 Jul 2026 12:49:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1784465383;
	bh=OKrIVttGBccrdapdWeFNvifYQ02Prw2pVawbuFQG9rE=;
	h=From:To:Cc:Subject:Date;
	b=H6ymdhdighByqCKdvo9wYaMB65qpbuHtO2wrgosadsvEQl0RtMfiAgNPd8A8Eokdq
	 dUOBC/UVPUwyZcaBi1R2A9ZyZ2VMIhhKtVjf0cX5ud0Jd0tKUrXoWqrZ674JDi8m7X
	 rEemuZEWp8bSjDLGMA3etEAvSxpPJa8xcxQ7Az8CiwnPX8t5+f0uYPnJDhHanxCDoq
	 ri/kBuAH/CmpLRWnM80OxOniYlgP22d5wEbgeXcqiMjE6Z0GBPleT3ANKLrH9BN1v5
	 BOKqXKQbBIOxfuOy6nIllSwFT92OEG9FrTKYvDrqJVm1r17CjqmZDKoYBgPgFn17Zp
	 DEKsldNJhURyA==
From: "syzbot" <syzbot@kernel.org>
To: syzkaller-upstream-moderation@googlegroups.com
Cc: krystianmkaniewski@gmail.com, syzbot@lists.linux.dev
Subject: [PATCH RFC v3] ipvlan: keep lower device alive until private destruction
Message-ID: <07edf3e0-84dd-47b0-8203-e0b8f3b9d5b5@mail.kernel.org>
Precedence: bulk
X-Mailing-List: syzbot@lists.linux.dev
List-Id: <syzbot.lists.linux.dev>
List-Subscribe: <mailto:syzbot+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:syzbot+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Date: Sun, 19 Jul 2026 12:49:43 +0000 (UTC)

Commit 40b9d1ab63f5 ("ipvlan: hold lower dev to avoid possible
use-after-free") added a reference to the lower net_device owned by struct
ipvl_port. However, this reference is released when the last
ipvlan_uninit() reduces port->count to zero and calls
ipvlan_port_destroy(), which can happen before all outstanding external
references to the ipvlan netdev have drained.

Specifically, RXE acts as an asynchronous owner in this scenario. RXE
queues RDMA device removal on NETDEV_UNREGISTER, meaning it can retain a
reference to the ipvlan netdev after ndo_uninit has completed. This allows
a later SMC port query to reach the ipvlan device and access its phy_dev.

This leads to the following sequence:
1. The shared ipvl_port owns the reference to the lower net_device
(phy_dev).
2. The last ipvlan_uninit() drops this reference by calling
ipvlan_port_destroy() when port->count reaches zero.
3. RXE retains a reference to the ipvlan netdev, keeping it alive.
4. The lower net_device's refcount drops to 1 and it is freed by
netdev_run_todo(), leaving ipvlan->phy_dev as a dangling pointer. A
subsequent SMC port query accesses this dangling pointer, triggering a
use-after-free.
5. A new per-device hold keeps phy_dev alive until ipvlan_dev_free() runs.

The KASAN report illustrates this use-after-free:

BUG: KASAN: slab-use-after-free in netdev_need_ops_lock
include/net/netdev_lock.h:30 [inline]
BUG: KASAN: slab-use-after-free in netdev_lock_ops
include/net/netdev_lock.h:41 [inline]
BUG: KASAN: slab-use-after-free in __ethtool_get_link_ksettings+0x230/0x250
net/ethtool/ioctl.c:463
Read of size 1 at addr ffff8881988dae09 by task kworker/1:3/1289

Call Trace:
 <TASK>
  __ethtool_get_link_ksettings+0x230/0x250 net/ethtool/ioctl.c:463
  __ethtool_get_link_ksettings+0x11f/0x250 net/ethtool/ioctl.c:464
  ib_get_eth_speed+0x180/0x7f0 drivers/infiniband/core/verbs.c:2052
  rxe_query_port+0x93/0x3d0 drivers/infiniband/sw/rxe/rxe_verbs.c:56
  __ib_query_port drivers/infiniband/core/device.c:2129 [inline]
  ib_query_port+0x16e/0x830 drivers/infiniband/core/device.c:2161
  smc_ib_remember_port_attr net/smc/smc_ib.c:364 [inline]
  smc_ib_port_event_work+0x147/0x920 net/smc/smc_ib.c:388
 </TASK>

Fix this by holding a reference to the lower net_device using a
netdevice_tracker in struct ipvl_dev. The reference is acquired in
ipvlan_init() and released in the priv_destructor callback
(ipvlan_dev_free()). Releasing the reference in ipvlan_dev_free()
guarantees that the lower net_device is held until outstanding external
references to the ipvlan netdev have drained and before final private
teardown and object release. This mirrors the behavior of other stacked
devices like macvlan and vlan, and safely covers ipvtap devices as well.

Fixes: 2ad7bf363841 ("ipvlan: Initial check-in of the IPVLAN driver.")
Assisted-by: Gemini:gemini-3.5-flash Gemini:gemini-3.1-pro-preview syzbot
Reported-by: syzbot+5fe14f2ff4ccbace9a26@syzkaller.appspotmail.com
Closes: https://syzkaller.appspot.com/bug?extid=5fe14f2ff4ccbace9a26
Link: https://syzkaller.appspot.com/ai_job?id=3e3edd19-4e52-49d3-bfdb-ebdde1bda5c3
To: "Andrew Lunn" <andrew+netdev@lunn.ch>
To: "David S. Miller" <davem@davemloft.net>
To: "Eric Dumazet" <edumazet@google.com>
To: "Jakub Kicinski" <kuba@kernel.org>
To: <netdev@vger.kernel.org>
To: "Paolo Abeni" <pabeni@redhat.com>
Cc: "Dmitry Skorodumov" <dskr99@gmail.com>
Cc: "Kees Cook" <kees@kernel.org>
Cc: <linux-kernel@vger.kernel.org>

---
v3:
- Updated the commit description to correct the explanation of the lower-device reference release and the role of RXE.

v2:
- Updated the patch subject to "ipvlan: keep lower device alive until private destruction"
- Rewrote the commit message to clarify that commit 40b9d1ab63f5 added a lower-device reference owned by struct ipvl_port
- Described the lower device generically as a lower net_device
- Replaced the full KASAN report with only the relevant call chain
- Corrected the description of priv_destructor
https://lore.kernel.org/all/7d8162e1-a546-40b8-b9ea-7c0e164ef8e8@mail.kernel.org/T/

v1:
https://lore.kernel.org/all/e66f374b-905f-471b-989e-60a3e0505873@mail.kernel.org/T/
---
diff --git a/drivers/net/ipvlan/ipvlan.h b/drivers/net/ipvlan/ipvlan.h
index 80f84fc87..13cdad002 100644
--- a/drivers/net/ipvlan/ipvlan.h
+++ b/drivers/net/ipvlan/ipvlan.h
@@ -64,6 +64,7 @@ struct ipvl_dev {
 	struct list_head	pnode;
 	struct ipvl_port	*port;
 	struct net_device	*phy_dev;
+	netdevice_tracker dev_tracker;
 	struct list_head	addrs;
 	struct ipvl_pcpu_stats	__percpu *pcpu_stats;
 	DECLARE_BITMAP(mac_filters, IPVLAN_MAC_FILTER_SIZE);
diff --git a/drivers/net/ipvlan/ipvlan_main.c b/drivers/net/ipvlan/ipvlan_main.c
index ed46439a9..b1435296a 100644
--- a/drivers/net/ipvlan/ipvlan_main.c
+++ b/drivers/net/ipvlan/ipvlan_main.c
@@ -162,6 +162,9 @@ static int ipvlan_init(struct net_device *dev)
 	}
 	port = ipvlan_port_get_rtnl(phy_dev);
 	port->count += 1;
+
+	netdev_hold(phy_dev, &ipvlan->dev_tracker, GFP_KERNEL);
+
 	return 0;
 }
 
@@ -673,6 +676,13 @@ void ipvlan_link_delete(struct net_device *dev, struct list_head *head)
 }
 EXPORT_SYMBOL_GPL(ipvlan_link_delete);
 
+static void ipvlan_dev_free(struct net_device *dev)
+{
+	struct ipvl_dev *ipvlan = netdev_priv(dev);
+
+	netdev_put(ipvlan->phy_dev, &ipvlan->dev_tracker);
+}
+
 void ipvlan_link_setup(struct net_device *dev)
 {
 	ether_setup(dev);
@@ -682,6 +692,7 @@ void ipvlan_link_setup(struct net_device *dev)
 	dev->priv_flags |= IFF_UNICAST_FLT | IFF_NO_QUEUE;
 	dev->netdev_ops = &ipvlan_netdev_ops;
 	dev->needs_free_netdev = true;
+	dev->priv_destructor = ipvlan_dev_free;
 	dev->header_ops = &ipvlan_header_ops;
 	dev->ethtool_ops = &ipvlan_ethtool_ops;
 }


base-commit: 8cdeaa50eae8dad34885515f62559ee83e7e8dda
-- 
This is an AI-generated patch subject to moderation.
Reply with '#syz upstream' to Sign-off the patch as a human author
and send it to the upstream kernel mailing lists.
Reply with '#syz reject' to reject it ('#syz unreject' to undo).

See https://goo.gle/syzbot-ai-patches for information about AI-generated patches.
You can comment on the patch as usual, syzbot will try to address
the comments and send a new version of the patch if necessary.
syzbot engineers can be reached at syzkaller@googlegroups.com.
