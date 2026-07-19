Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5B113271443
	for <syzbot@lists.linux.dev>; Sun, 19 Jul 2026 10:28:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784456895; cv=none; b=Gs8a+emdYNnCq89TeN9zsaQ3c+ArRKAtOUUxCNaOCmUp8R11z0VMrRXi6LH+dt8cIf7wDw43np2GLNmbO+7tv1/9OjuBHl3YL9LOq5xnbxwFlfqTR3Px8NXWjfucbemKMC3t+IU7Ogut4hNQbwoMR5BztDqU71FqmSF92bG/vs4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784456895; c=relaxed/simple;
	bh=8oAEm4LAAorOAd2bd2ev4KtENrfQyf7DezBD0GX1OXo=;
	h=From:To:Cc:Subject:Message-ID:MIME-Version:Content-Type:Date; b=CEOVfErgTw7LjvgXr7hJSc8SNFt8Gmfyxkz7Z9o+X7vq+R6/AEL5Z4AuOcLYQRSndxK1IrW9hbxUF9QenxCIa/l4zY6GoK4PzFZ6SA63V7L72mdUFsyPob/+wT/0/5Apj0NvRtSAwhAVOmzMo/pS21HrNd7fYyDewV2t2/3J0Co=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=DM5bI84p; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="DM5bI84p"
Received: by smtp.kernel.org (Postfix) with UTF8SMTPSA id C5ECB1F000E9;
	Sun, 19 Jul 2026 10:28:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1784456893;
	bh=3wM9+uEeV5/jXWMhUUAXbXg+Nizj2RVjcKp9BEWbyGU=;
	h=From:To:Cc:Subject:Date;
	b=DM5bI84p6haanVXOqKDV9fOhS9S7mShUxDwdonXyNAMXpyujyApPt5lFb5HKgfUjh
	 zx06ul+S+6s8LH/N9SQ4X8skpunmY0hEItsiGYNr8IG46TniG6/OZ8Ze0kD73cGXG9
	 +eJWNOATZvAUn1+6hmPBgjZ8MTIIVWzVpfUr98IBt1IcT0XlVwgPfEb0YLW3aHvN9Y
	 +NrioSu3e6kzG08hnZp8n+sF6o7nxKJKrIRp5+JIc1VT9YiLBWA6Gc4qceyOpK0mv6
	 xCSGE3+nplz3tPGmsiQrpX9YaurE9D2CjcQiZESbhpz269Xsu2u8u1ILL2J11U9fEl
	 o+i+luhFgWx6A==
From: "syzbot" <syzbot@kernel.org>
To: syzkaller-upstream-moderation@googlegroups.com
Cc: krystianmkaniewski@gmail.com, syzbot@lists.linux.dev
Subject: [PATCH RFC v2] ipvlan: keep lower device alive until private destruction
Message-ID: <7d8162e1-a546-40b8-b9ea-7c0e164ef8e8@mail.kernel.org>
Precedence: bulk
X-Mailing-List: syzbot@lists.linux.dev
List-Id: <syzbot.lists.linux.dev>
List-Subscribe: <mailto:syzbot+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:syzbot+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Date: Sun, 19 Jul 2026 10:28:13 +0000 (UTC)

Commit 40b9d1ab63f5 ("ipvlan: hold lower dev to avoid possible
use-after-free") added a reference to the lower net_device owned by struct
ipvl_port. However, this reference is released when the ipvlan device is
unregistered, which can happen before the ipvlan device is actually freed.

If a stacked network device configuration is created (e.g., a lower
net_device, an ipvlan device on top, and another device on top of ipvlan),
the upper device holds a reference to the ipvlan device. When the lower
net_device is unregistered, the ipvlan device is unregistered as well. This
triggers unregistration of the upper device, which queues asynchronous work
to drop its reference to the ipvlan device.

During this process, netdev_run_todo() waits for the refcounts of both the
lower net_device and the ipvlan device to drop to 1. Since the ipvlan
device's refcount is elevated by the pending upper device unregistration,
it is kept alive. However, because the lower net_device's reference held by
the ipvlan port is released during unregistration, the lower net_device's
refcount drops to 1, and netdev_run_todo() proceeds to free it. This leaves
ipvlan->phy_dev as a dangling pointer.

If an operation (like querying port attributes via ethtool) is performed on
the ipvlan device while it is still alive, it can access the freed lower
net_device, triggering a use-after-free:

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
 </TASK>

Fix this by holding a reference to the lower net_device using a
netdevice_tracker in struct ipvl_dev. The reference is acquired in
ipvlan_init() and released in the priv_destructor callback
(ipvlan_dev_free). Releasing the reference in priv_destructor guarantees
that the lower net_device is held until the ipvlan device is actually
freed, after its refcount has dropped to 0. This mirrors the behavior of
other stacked devices like macvlan and vlan, and safely covers ipvtap
devices as well.

Fixes: 2ad7bf363841 ("ipvlan: Initial check-in of the IPVLAN driver.")
Assisted-by: Gemini:gemini-3.5-flash Gemini:gemini-3.1-pro-preview syzbot
Reported-by: syzbot+5fe14f2ff4ccbace9a26@syzkaller.appspotmail.com
Closes: https://syzkaller.appspot.com/bug?extid=5fe14f2ff4ccbace9a26
Link: https://syzkaller.appspot.com/ai_job?id=ecee4f7f-c35a-40b5-85ed-47bebd5cb0d1
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
v2:
- Updated the patch subject to "ipvlan: keep lower device alive until private destruction"
- Rewrote the commit message to clarify that commit 40b9d1ab63f5 added a lower-device reference owned by struct ipvl_port
- Described the lower device generically as a lower net_device
- Replaced the full KASAN report with only the relevant call chain
- Corrected the description of priv_destructor

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
