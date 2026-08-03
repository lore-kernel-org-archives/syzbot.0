Received: from mail-ed1-f50.google.com (mail-ed1-f50.google.com [209.85.208.50])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C567930F92E
	for <syzbot@lists.linux.dev>; Mon,  3 Aug 2026 12:11:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.50
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785759108; cv=none; b=pxjtpKA022Lx2faqX+5hDns3ALAuuMsXGVAbXSLdcG5x2lo4JyIc0W5I2N/gZwgMaawyto9vmJ5ArFU3dV+DwypjRlim97f5RewLY4z8NRVYY5tTHCdMZ+eVkytjEgVz/vQAfV1j/OaCZEqYgJcK9ZVvM5eoxtbAOmJ+xMFzSpg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785759108; c=relaxed/simple;
	bh=5FhqZcuvXbUA7XKnBEjLE6oGOpoajtBISrkOKD3VszQ=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=H/2LUMgqUATyg928jCZwqaYNMJFlfmavWuWeJXm5XZRE6pOMC1PkjOnBFUz+rxeC6Phpvw/2A/hDu3XR9IRt40hsJ+zlR94+KYjIWrCw3vL5yyx6aF9p1D9KQFQ+WbiDg1OmdAzO2aDZm5acp1eAggxc0I07l1NO+LDiS5tPrFI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=m4dUh7GX; arc=none smtp.client-ip=209.85.208.50
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="m4dUh7GX"
Received: by mail-ed1-f50.google.com with SMTP id 4fb4d7f45d1cf-6a051b73866so5267178a12.0
        for <syzbot@lists.linux.dev>; Mon, 03 Aug 2026 05:11:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1785759105; x=1786363905; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=EcjQI2JYKwg5xZMIFGY1JaKQvya3kkElNk2GTcB9VuQ=;
        b=m4dUh7GX8IVXcKN1rY7OgY9TvYxdre5ibnuiuyVY/7b7+2rgswXVYeD1y3j/ioMU9u
         y40vxPnNhGMk/9VLP7BYThqANcODoTVhn216hVYRpuT/4+fBgUkz1omsixlOYEMKVHxS
         SBjsOk0mgkCEu6xyeoJfJyA8D9FTHiTuy1lWKvptUdRfUdKlF1tDONw4vhcAa/TcVhg9
         pFmnWcstJeQlKeE1lA79BAMI5dsVlHDY+mwruFHhrKe3LECNgSGlwakKexHYCvcCwDM3
         UQy0DvMAt3iW+cTeWRWYoex4flGbkobOJRLkMStW35dVRo0ydqXiTE+wQp3oqqfyw873
         p65g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1785759105; x=1786363905;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=EcjQI2JYKwg5xZMIFGY1JaKQvya3kkElNk2GTcB9VuQ=;
        b=E0f38tZoTb2iHykK75sNX0EIF55899Tw+CdDniEoyUo+MUmOL5vKupryfaxJ6Nw7jr
         DPqsj65wL6JXdC6AhydZMm1O6Upu0hrkXbMRUEd1AvGBTfjRFYm9tFHEP5GjxbdtUX0m
         K5wchbM0C6oWyDLW2M71M9nsYcwDrDFZ8+NufL+hbI/yU2hcfIrbClWtxGXmcJjw+q8E
         WRydV59Udhk/9DsTAQF+22T7Zf+tFrwOYzVZmoxfuaQP6d3wPIZId0cLe3/6z79fE1Z7
         tILfDPQI/wARukVH7fjWbWnoXWi3Gcz9Kej8Zs5V6i3b7HqFt6EsbDSYQmsXvGFuz97z
         1RDg==
X-Forwarded-Encrypted: i=1; AHgh+RqOZCGm/YV7sbROQbAhilVki1Yw/NALqPmrVSmumKTllWL/PS/g3g1l5o7q4kLTt0thwk0Nvcs=@lists.linux.dev
X-Gm-Message-State: AOJu0Yxsu/q7E9QQXVxS8Tui8Pa3C85iF/K+n4PdEKQZgIJNdJZjJena
	RxWVhCm7YgPIJH7tFhcU8qxf4NSg10fBDXEG9nhk8ZhtbPI/612uVtgb
X-Gm-Gg: AR+sD13YoKfuTQyMomQdF8S9xVjdXoxsunqtKYu8QRnzj5ujY9RhR7bpKb0QbgVICpK
	6w8l8jpAxKxM50Uq2lG42BaEvtZOMzHBF4S99nWvNCagGao2lseuCuL+8r2NgUL3P1x6D9nLGTn
	uN6DKumiz36MhXsfztYVJ5bl3YPcySUxAkM/TJs40+VrdcfQ6FQKaBq38A23bAYShFLzbgHusPG
	qM7qWjtqvgG1dbEu3Xea5mbyJkfmIx5q3cCjDj2/fjdDPqj1P+1wRj5aRYvJw6OUVV4VU1XD3vW
	0SnKvVAZ23jczJZh4TlM7rzbI9hcrvt4UiKyLw9XSNYqnNp3eR/5sTwYsLoxcBmV2TRKgccM+NR
	4p7E3B+i5kNHBMSjnqFf0aIIvG35kG8mqa+ElXqbwdRb2/MKx86tfV5ull/DKpK2SZ9pO0B0OI5
	5vjkwOBekybHDPKYRsc+fAa+lZB1AtiOGXCUjBKjjIkxN3iX3emrM7rMm2yto10EhEV4tP9cn2d
	vp0Othu5M4BQdKecXZAJAxlRZjYbq7yRPpxrrHpTis3Fx8D2IrcSPlV2fjsSHmMj4r9emgaB/eS
	O38sBFFP9VX+3Dv+IQwGlj0PNrTnrjAT9Ah9vg==
X-Received: by 2002:a05:6402:21cf:b0:69e:8ad:515f with SMTP id 4fb4d7f45d1cf-6a0a7c60fbamr6798287a12.6.1785759104890;
        Mon, 03 Aug 2026 05:11:44 -0700 (PDT)
Received: from Ubuntu.ts.net (87-205-15-91.static.ip.netia.com.pl. [87.205.15.91])
        by smtp.gmail.com with ESMTPSA id 4fb4d7f45d1cf-6a09c63daf7sm5208181a12.18.2026.08.03.05.11.43
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 03 Aug 2026 05:11:44 -0700 (PDT)
From: Krystian Kaniewski <krystianmkaniewski@gmail.com>
To: netdev@vger.kernel.org,
	Andrew Lunn <andrew+netdev@lunn.ch>,
	"David S. Miller" <davem@davemloft.net>,
	Eric Dumazet <edumazet@google.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Paolo Abeni <pabeni@redhat.com>
Cc: syzkaller-bugs@googlegroups.com,
	dskr99@gmail.com,
	Kees Cook <kees@kernel.org>,
	linux-kernel@vger.kernel.org,
	syzbot@lists.linux.dev,
	syzbot+5fe14f2ff4ccbace9a26@syzkaller.appspotmail.com
Subject: [PATCH net v2] ipvlan: keep lower device alive until private destruction
Date: Mon,  3 Aug 2026 14:11:39 +0200
Message-ID: <20260803121140.261329-1-krystianmkaniewski@gmail.com>
X-Mailer: git-send-email 2.53.0
Precedence: bulk
X-Mailing-List: syzbot@lists.linux.dev
List-Id: <syzbot.lists.linux.dev>
List-Subscribe: <mailto:syzbot+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:syzbot+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

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
Signed-off-by: Krystian Kaniewski <krystianmkaniewski@gmail.com>
---
v2:
  - Rebased onto net/main; no code changes.
  - Added the net target-tree prefix.
v1: https://lore.kernel.org/all/26b3176e-d9ed-4508-bde7-388deefd970d@mail.kernel.org/

 drivers/net/ipvlan/ipvlan.h      |  1 +
 drivers/net/ipvlan/ipvlan_main.c | 11 +++++++++++
 2 files changed, 12 insertions(+)

diff --git a/drivers/net/ipvlan/ipvlan.h b/drivers/net/ipvlan/ipvlan.h
index 80f84fc87008..13cdad00297c 100644
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
index ed46439a9f4e..b1435296a0f1 100644
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

base-commit: af39eb111ce6b5eba9c08513b62c4868eb7e7fd5
-- 
2.53.0
