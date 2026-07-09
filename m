Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C675819B5B1
	for <syzbot@lists.linux.dev>; Thu,  9 Jul 2026 13:44:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783604667; cv=none; b=uoCbycM8KIU4zfnT4sgafRDM69MAIXSUY5Tx4rXLXbuCTeA1M01NuTTe1ZE1zuXdGEAr5DKwz41RjT8UDLeaxXbiY83LrPukYm8EsJOaIwxf3raABmJhkc5hORzUcvvg3IwUyjccF5NrCw7sOmBUVMovcyTowM2SH/9lkJ1x4ZQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783604667; c=relaxed/simple;
	bh=hbahqmH47ydGVJfPlOfcLbzeSBz7vmTqyq4z57DRltA=;
	h=From:To:Cc:Subject:Message-ID:MIME-Version:Content-Type:Date; b=DBeke4LuBZBSpD4ogRlJeyNX+p1yE1SJSMSSppTS6Susf+frUIMdvZkfoPKh0s17xMT+/vTf4NO9ais+zxJgF/nGaceClJl2CkHQ8HzBarJRAdcBV+oNRjw7lH8BA3oT+eAwqLz1AhmOlErChLAA3zMGSbdrIRBTCZXE9n2hut4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=XgA0/m96; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="XgA0/m96"
Received: by smtp.kernel.org (Postfix) with UTF8SMTPSA id 62F551F000E9;
	Thu,  9 Jul 2026 13:44:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1783604665;
	bh=DR5x4wxahHow7ph6ulrZTkUjKBwM6J+ulkYjA4TiZnk=;
	h=From:To:Cc:Subject:Date;
	b=XgA0/m96ZnjDCV0Qla6Y2H65uVLgX6zUBIOEbpUwf6TxUD2Sr23AoKDyFyiu1XmL2
	 8nTuZcGdLhIqFVNjPjP5knMLiUWi/8zjHuRjzVr2D5XyEgS+9iHRceOUVfDOjUnaov
	 zzMK7LpdBcugld7hFLJnnP6MeUvPWRo5dqmv1FLd2/33Y81JAtJ/fUHzR2JRGVsQAg
	 DVDElBB50VzuxxWdUKJdKwPpiTq/jEQIFwoBH5VR4Nh7X1VHuSCyYYghWVIzMSPV8I
	 hLRvjf8HWNJIJTKPkQcUJWLnBEh44Zt7282ypzR/JmES8T910WMps+wRBMHpkrMuiG
	 2urx6hMUnm/ag==
From: "syzbot" <syzbot@kernel.org>
To: syzkaller-upstream-moderation@googlegroups.com
Cc: syzbot@lists.linux.dev
Subject: [PATCH RFC] ipvlan: hold reference to lower device to prevent use-after-free
Message-ID: <e66f374b-905f-471b-989e-60a3e0505873@mail.kernel.org>
Precedence: bulk
X-Mailing-List: syzbot@lists.linux.dev
List-Id: <syzbot.lists.linux.dev>
List-Subscribe: <mailto:syzbot+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:syzbot+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Date: Thu,  9 Jul 2026 13:44:25 +0000 (UTC)

The ipvlan driver does not hold a reference to its lower device (phy_dev),
allowing the lower device to be freed while the ipvlan device is still
alive and being accessed.

If a stacked network device configuration is created (e.g., a veth device
as the lower device, an ipvlan device on top, and an rxe device on top of
ipvlan), the rxe device holds a reference to the ipvlan device. When the
veth device is unregistered, the ipvlan driver receives a NETDEV_UNREGISTER
event and unregisters the ipvlan device. This triggers a NETDEV_UNREGISTER
event for the ipvlan device, which is caught by the rxe driver, queuing
asynchronous work to unregister the rxe device and drop its reference to
the ipvlan device.

During this process, netdev_run_todo() waits for the refcounts of both veth
and ipvlan devices to drop to 1. Since the ipvlan device's refcount is
elevated by the pending rxe unregistration, it is kept alive. However,
because ipvlan does not hold a reference to its lower veth device, the veth
device's refcount drops to 1, and netdev_run_todo() proceeds to free it.
This leaves ipvlan->phy_dev as a dangling pointer.

If an operation (like querying port attributes via ethtool) is performed on
the ipvlan device while it is still alive, it can access the freed lower
device, triggering a use-after-free:

BUG: KASAN: slab-use-after-free in netdev_need_ops_lock
include/net/netdev_lock.h:30 [inline]
BUG: KASAN: slab-use-after-free in netdev_lock_ops
include/net/netdev_lock.h:41 [inline]
BUG: KASAN: slab-use-after-free in __ethtool_get_link_ksettings+0x230/0x250
net/ethtool/ioctl.c:463
Read of size 1 at addr ffff888118fece09 by task kworker/0:2/919

Call Trace:
 <TASK>
 netdev_need_ops_lock include/net/netdev_lock.h:30 [inline]
 netdev_lock_ops include/net/netdev_lock.h:41 [inline]
 __ethtool_get_link_ksettings+0x230/0x250 net/ethtool/ioctl.c:463
 __ethtool_get_link_ksettings+0x11f/0x250 net/ethtool/ioctl.c:464
 ib_get_eth_speed+0x180/0x7f0 drivers/infiniband/core/verbs.c:2052
 rxe_query_port+0x93/0x3d0 drivers/infiniband/sw/rxe/rxe_verbs.c:56
 __ib_query_port drivers/infiniband/core/device.c:2129 [inline]
 ib_query_port+0x16e/0x830 drivers/infiniband/core/device.c:2161
 smc_ib_remember_port_attr net/smc/smc_ib.c:364 [inline]
 smc_ib_port_event_work+0x147/0x920 net/smc/smc_ib.c:388
 ...
 </TASK>

Fix this by holding a reference to the lower device using a
netdevice_tracker in struct ipvl_dev. The reference is acquired in
ipvlan_init() and released in a new priv_destructor callback
(ipvlan_dev_free). Releasing the reference in priv_destructor guarantees
that the lower device is held until the absolute end of the ipvlan device's
lifetime, after netdev_run_todo() has finished waiting for the ipvlan
device's refcount to drop to 1. This mirrors the behavior of other stacked
devices like macvlan and vlan, and safely covers ipvtap devices as well.

Fixes: 2ad7bf363841 ("ipvlan: Initial check-in of the IPVLAN driver.")
Assisted-by: Gemini:gemini-3.1-pro-preview syzbot
Reported-by: syzbot+5fe14f2ff4ccbace9a26@syzkaller.appspotmail.com
Closes: https://syzkaller.appspot.com/bug?extid=5fe14f2ff4ccbace9a26
Link: https://syzkaller.appspot.com/ai_job?id=43c4fc37-40e6-4515-8ae6-40bdb52bb303
To: "Andrew Lunn" <andrew+netdev@lunn.ch>
To: "David S. Miller" <davem@davemloft.net>
To: "Eric Dumazet" <edumazet@google.com>
To: "Jakub Kicinski" <kuba@kernel.org>
To: <netdev@vger.kernel.org>
To: "Paolo Abeni" <pabeni@redhat.com>
Cc: "Dmitry Skorodumov" <dskr99@gmail.com>
Cc: "Kees Cook" <kees@kernel.org>
Cc: <linux-kernel@vger.kernel.org>
Cc: "Stanislav Fomichev" <sdf@fomichev.me>

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
