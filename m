Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795548615;
	b=c1zlEuH5vhq4j9xqhY5urHjc6X0pbcCbeYOXih2FjQBzXe/U09k24RSdmb2bHW3Jm+zk
	 PT4oSjHgPkVD5qe3LmxsJiCqam5FV42AWi6ZiyusrhSYAy91aP/1R2xSZVZzQR3Rkf/D/
	 zt5TRAk2cE2u/HP/H0u3lyKdwDgn5UmjFm9Dbl7uwBb9LUKdXFPPLPwg1oWlohQAstt1U
	 W/eE7/UOkdBXMrGSNC7ZAMi2m8fSMGdBgiK/6931CU4STRm3cu5cgFKjPy1W2Xn6c6LTt
	 9/SOyN3UQOMl1J/Dju3SgNJmX2QerbKDqSjuVBgxBDQi0VEl6uEA3uaNIJgRIhin6CA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795548615;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Message-ID:MIME-Version:
	 Content-Type:Content-Transfer-Encoding:Date;
	bh=GkXTirVkt3TbgL+S4J68YELlwZU5Zjz4xJSa0zJqP44=;
	b=ZhWqqZqEAy9vR7sCp8zOjAz7gh4Dl4krsep5/cSw501VMnNLyRTMjlf261VmYOdFc38b
	 cEhScU/YtvZNGfnecsU5MDZFShMKg9h/Pkd5HGcjxKXsH3SpqjrvJqpWAcDUkniap+eGo
	 HPhsncZyNnc/0PdZ24NtY0l5TrhGczy4NMNeSjgZOe5VK6EQ3T258eo6l5jQqrob1QOuY
	 sHpKqGJPKFBXHdd9J+nVJvtPGH9qRtlz1/HzNBaNjpPNaejtlx9UjCdzzsBNRTBGUz2XO
	 GKMjgIAZN9LpvXOhVKOk9CQ9PpPwAheIudBmPS547L59B2qdUpm5mz7m4cujMtNZj3w==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=ijs3F4CG;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with UTF8SMTPS id 769C4606A326
	for <syzbot@lists.linux.dev>; Tue, 24 Nov 2026 19:30:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=ijs3F4CG
Received: by smtp.kernel.org (Postfix) with UTF8SMTPSA id 85BD41F000C4;
	Tue, 24 Nov 2026 19:30:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795548614;
	bh=GkXTirVkt3TbgL+S4J68YELlwZU5Zjz4xJSa0zJqP44=;
	h=From:To:Cc:Subject:Date;
	b=ijs3F4CGAH8+r5jZfoDTKIksGO7YptOYZ6cTAeUjPZ3spUKq67GqGYOAw7b28aAPV
	 PauN9Rdk2X9Y4cVNc1v1c6kvhQr5TwhoRyFCp9nkzf7+8GX38ybSSesXGLwoy6agXk
	 3IxIYyqSlntRoFfm5r635hiuZut1U+QU/dlkOMl2pNu6UZGUCUBzQ/YQvbg9isAa4G
	 6ZKVhM8SgPg4osy2Jz80OBaY8VOEqVhpRWygHfQLhnI60qn9tKVOz6xzuX9H0So/4V
	 QTUiqas1ach2ey4Jbs56e7bDHR8HtqsmAdMZJ+byjlQelpEZkjc6hejz7wTrTgzAaF
	 W7yBWwPOEAxPA==
From: "syzbot" <syzbot@kernel.org>
To: syzkaller-upstream-moderation@googlegroups.com
Cc: syzbot@lists.linux.dev
Subject: [PATCH RFC] net: lapb: fix circular locking dependency with lapbether and hdlc_x25
Message-ID: <144f609e-5895-4d8e-9a5d-79df8fb38d9c@mail.kernel.org>
X-Mailing-List: syzbot@lists.linux.dev
List-Id: <syzbot.lists.linux.dev>
List-Post: <mailto:syzbot@lists.linux.dev>
List-Help: <mailto:syzbot+help@lists.linux.dev>
List-Subscribe: <mailto:syzbot+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:syzbot+unsubscribe@lists.linux.dev>
List-Owner: <mailto:syzbot+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Date: Tue, 24 Nov 2026 19:30:14 +0000 (UTC)

Lockdep reports a circular locking dependency between `lapb_list_lock`,
`&lapb->lock`, `_xmit_X25`, and `&lapbeth->up_lock`:

WARNING: possible circular locking dependency detected
task is trying to acquire lock:
ffffffff91666a98 (lapb_list_lock){++..}-{3:3}, at: lapb_devtostruct
net/lapb/lapb_iface.c:102 [inline]
ffffffff91666a98 (lapb_list_lock){++..}-{3:3}, at:
lapb_connect_request+0x2c/0x270 net/lapb/lapb_iface.c:287

but task is already holding lock:
ffff888033d5cf40 (&lapbeth->up_lock){+...}-{3:3}, at:
lapbeth_xmit+0x32/0x260 drivers/net/wan/lapbether.c:191

which lock already depends on the new lock.

the existing dependency chain (in reverse order) is:

-> #3 (&lapbeth->up_lock){+...}-{3:3}:
       lapbeth_xmit+0x32/0x260 drivers/net/wan/lapbether.c:191
       dev_hard_start_xmit+0x2cd/0x830 net/core/dev.c:4084
       __dev_queue_xmit+0x1237/0x3260 net/core/dev.c:5100

-> #2 (_xmit_X25#2){+...}-{3:3}:
       __dev_queue_xmit+0xd8c/0x3260 net/core/dev.c:5094
       gre_tap_xmit+0x543/0x760 net/ipv4/ip_gre.c:783
       __dev_queue_xmit+0x14d3/0x3260 net/core/dev.c:5058
       lapb_data_transmit+0x90/0xb0 net/lapb/lapb_iface.c:447
       lapb_transmit_buffer+0x163/0x200 net/lapb/lapb_out.c:149
       lapb_establish_data_link+0x89/0xe0 net/lapb/lapb_out.c:-1
       lapb_device_event+0x4eb/0x680 net/lapb/lapb_iface.c:-1

-> #1 (&lapb->lock){+.-.}-{3:3}:
       lapb_unregister+0x1e1/0x450 net/lapb/lapb_iface.c:187
       lapbeth_close+0x56/0xb0 drivers/net/wan/lapbether.c:350

-> #0 (lapb_list_lock){++..}-{3:3}:
       lapb_devtostruct net/lapb/lapb_iface.c:102 [inline]
       lapb_connect_request+0x2c/0x270 net/lapb/lapb_iface.c:287
       lapbeth_xmit+0x133/0x260 drivers/net/wan/lapbether.c:205
       dev_hard_start_xmit+0x2cd/0x830 net/core/dev.c:4084
       __dev_queue_xmit+0x1237/0x3260 net/core/dev.c:5100
       packet_sendmsg+0x4089/0x5330 net/packet/af_packet.c:3189

Chain exists of:
  lapb_list_lock --> _xmit_X25#2 --> &lapbeth->up_lock

The cycle arises from bidirectional lock-ordering inversions across the
`lapbether`, `lapb`, and netdevice transmit paths. In `lapbeth_xmit()`
(invoked under the device TX queue lock `_xmit_X25`) and `lapbeth_rcv()`,
`lapbether` acquires `&lapbeth->up_lock` and keeps it held across calls
into `lapb_connect_request()`, `lapb_disconnect_request()`,
`lapb_data_request()`, and `lapb_data_received()`, which acquire
`lapb_list_lock` in `lapb_devtostruct()` and then `&lapb->lock`. Meanwhile,
`lapbeth_close()` calls `lapb_unregister()`, which acquires
`write_lock_bh(&lapb_list_lock)` and nests `spin_lock_bh(&lapb->lock)`
inside it (and could also call `usleep_range()` while holding
`lapb_list_lock`). Conversely, `lapb_device_event()`, LAPB timers, and
other LAPB paths call `lapb_transmit_buffer()` -> `lapb_data_transmit()` ->
`lapbeth_data_transmit()` -> `dev_queue_xmit()` synchronously while holding
`&lapb->lock`. When the underlying Ethernet device is an L2 tunnel such as
`gretap` whose outer route passes back through a `lapb` device,
`dev_queue_xmit()` acquires `_xmit_X25` and calls `lapbeth_xmit()`
(`&lapbeth->up_lock`), closing the cycle and enabling real ABBA deadlocks
as well as single-CPU self-deadlocks on `&lapbeth->up_lock` or
`&lapb->lock`. The `hdlc_x25` driver shares the same `up_lock` pattern
across `x25_xmit()` and `x25_rx()`. In addition, `lapbeth_setup()` called
`netdev_lockdep_set_classes()` before `alloc_netdev_mqs()` allocated TX
queues (`dev->num_tx_queues == 0`), leaving the TX queue lock in the
default `_xmit_X25` class, and `lapbeth` did not mark itself `lltx`.

Fix this by decoupling locking across the LAPB and driver boundaries:

1. Defer outbound lower-layer transmission outside `&lapb->lock` by adding
`tx_queue` and `tx_work` to `struct lapb_cb`. `lapb_data_transmit()` now
queues frames onto `lapb->tx_queue` (bounded by `LAPB_TX_QUEUE_LEN_MAX`)
and schedules `lapb->tx_work` on `system_highpri_wq`, while
`lapb_tx_work()` splices the queue and invokes
`lapb->callbacks->data_transmit()` under
`local_bh_disable()`/`local_bh_enable()` without holding `&lapb->lock`.

2. Restructure `lapb_unregister()` to unlink the `lapb_cb` via
`__lapb_remove_cb()` under `write_lock_bh(&lapb_list_lock)` and immediately
release `lapb_list_lock` before waiting for other references to drop
(`refcount_read(&lapb->refcnt) > 1`), acquiring `&lapb->lock` to clear
queues and stop timers, calling `timer_delete_sync()`, cancelling
`tx_work`, and purging `tx_queue`.

3. Remove `up_lock` from `struct lapbethdev` and `struct x25_state`.
Publish device readiness with `smp_store_release(&...->up, true)` in
`lapbeth_open()`/`x25_open()`, guard TX and RX fastpaths (`lapbeth_xmit()`,
`lapbeth_rcv()`, `x25_xmit()`, `x25_rx()`) with RCU read lock and
`smp_load_acquire(&...->up)` so no driver spinlock is held across
`lapb_*()` calls, and set `WRITE_ONCE(...->up, false)` followed by
`synchronize_net()` in `lapbeth_close()`/`x25_close()` before
`lapb_unregister()`, `napi_disable()`/`tasklet_kill()`, and
`skb_queue_purge(&...->rx_queue)`.

4. In `lapbether`, move `netdev_lockdep_set_classes()` into a new
`.ndo_init` callback (`lapbeth_dev_init()`) so it runs after TX queue
allocation, set `dev->lltx = true` in `lapbeth_setup()`, and defer
`dev_put(ethdev)` in `lapbeth_free_device()` and `lapbeth_cleanup_driver()`
until after `unregister_netdevice(lapbeth->axdev)` closes the device and
drains `lapb->tx_work`.

Fixes: b491e6a7391e ("net: lapb: Add locking to the lapb module")
Assisted-by: Gemini:gemini-4-hydrogen Gemini:gemini-4-carbon Gemini:gemini-3.8-flash syzbot
Reported-by: syzbot+8328573e4d0514392471@syzkaller.appspotmail.com
Closes: https://syzkaller.appspot.com/bug?extid=8328573e4d0514392471
Link: https://syzkaller.appspot.com/ai_job?id=08f7caee-ffcb-4407-8ed4-7be88c525cac
To: "Andrew Lunn" <andrew+netdev@lunn.ch>
To: "David S. Miller" <davem@davemloft.net>
To: "Eric Dumazet" <edumazet@kernel.org>
To: "Krzysztof Halasa" <khc@pm.waw.pl>
To: "Jakub Kicinski" <kuba@kernel.org>
To: <linux-x25@vger.kernel.org>
To: "Martin Schiller" <ms@dev.tdt.de>
To: <netdev@vger.kernel.org>
To: "Paolo Abeni" <pabeni@redhat.com>
To: "Xie He" <xie.he.0141@gmail.com>
Cc: "Simon Horman" <horms@kernel.org>

---
diff --git a/drivers/net/wan/hdlc_x25.c b/drivers/net/wan/hdlc_x25.c
index f72c92c24..8ee626833 100644
--- a/drivers/net/wan/hdlc_x25.c
+++ b/drivers/net/wan/hdlc_x25.c
@@ -17,6 +17,7 @@
 #include <linux/module.h>
 #include <linux/pkt_sched.h>
 #include <linux/poll.h>
+#include <linux/rcupdate.h>
 #include <linux/rtnetlink.h>
 #include <linux/skbuff.h>
 #include <net/x25device.h>
@@ -24,7 +25,6 @@
 struct x25_state {
 	x25_hdlc_proto settings;
 	bool up;
-	spinlock_t up_lock; /* Protects "up" */
 	struct sk_buff_head rx_queue;
 	struct tasklet_struct rx_tasklet;
 };
@@ -127,9 +127,9 @@ static netdev_tx_t x25_xmit(struct sk_buff *skb, struct net_device *dev)
 		return NETDEV_TX_OK;
 	}
 
-	spin_lock_bh(&x25st->up_lock);
-	if (!x25st->up) {
-		spin_unlock_bh(&x25st->up_lock);
+	guard(rcu)();
+	/* Pairs with smp_store_release() in x25_open(). */
+	if (!smp_load_acquire(&x25st->up)) {
 		kfree_skb(skb);
 		return NETDEV_TX_OK;
 	}
@@ -140,7 +140,6 @@ static netdev_tx_t x25_xmit(struct sk_buff *skb, struct net_device *dev)
 		result = lapb_data_request(dev, skb);
 		if (result != LAPB_OK)
 			dev_kfree_skb(skb);
-		spin_unlock_bh(&x25st->up_lock);
 		return NETDEV_TX_OK;
 
 	case X25_IFACE_CONNECT:
@@ -171,7 +170,6 @@ static netdev_tx_t x25_xmit(struct sk_buff *skb, struct net_device *dev)
 		break;
 	}
 
-	spin_unlock_bh(&x25st->up_lock);
 	dev_kfree_skb(skb);
 	return NETDEV_TX_OK;
 }
@@ -214,9 +212,8 @@ static int x25_open(struct net_device *dev)
 	if (result != LAPB_OK)
 		return -EINVAL;
 
-	spin_lock_bh(&x25st->up_lock);
-	x25st->up = true;
-	spin_unlock_bh(&x25st->up_lock);
+	/* Publish LAPB setup before x25_xmit()/x25_rx() see up == true. */
+	smp_store_release(&x25st->up, true);
 
 	return 0;
 }
@@ -226,12 +223,12 @@ static void x25_close(struct net_device *dev)
 	hdlc_device *hdlc = dev_to_hdlc(dev);
 	struct x25_state *x25st = state(hdlc);
 
-	spin_lock_bh(&x25st->up_lock);
-	x25st->up = false;
-	spin_unlock_bh(&x25st->up_lock);
+	WRITE_ONCE(x25st->up, false);
+	synchronize_net();
 
 	lapb_unregister(dev);
 	tasklet_kill(&x25st->rx_tasklet);
+	skb_queue_purge(&x25st->rx_queue);
 }
 
 static int x25_rx(struct sk_buff *skb)
@@ -246,20 +243,17 @@ static int x25_rx(struct sk_buff *skb)
 		return NET_RX_DROP;
 	}
 
-	spin_lock_bh(&x25st->up_lock);
-	if (!x25st->up) {
-		spin_unlock_bh(&x25st->up_lock);
+	guard(rcu)();
+	/* Pairs with smp_store_release() in x25_open(). */
+	if (!smp_load_acquire(&x25st->up)) {
 		kfree_skb(skb);
 		dev->stats.rx_dropped++;
 		return NET_RX_DROP;
 	}
 
-	if (lapb_data_received(dev, skb) == LAPB_OK) {
-		spin_unlock_bh(&x25st->up_lock);
+	if (lapb_data_received(dev, skb) == LAPB_OK)
 		return NET_RX_SUCCESS;
-	}
 
-	spin_unlock_bh(&x25st->up_lock);
 	dev->stats.rx_errors++;
 	dev_kfree_skb_any(skb);
 	return NET_RX_DROP;
@@ -344,7 +338,6 @@ static int x25_ioctl(struct net_device *dev, struct if_settings *ifs)
 
 		memcpy(&state(hdlc)->settings, &new_settings, size);
 		state(hdlc)->up = false;
-		spin_lock_init(&state(hdlc)->up_lock);
 		skb_queue_head_init(&state(hdlc)->rx_queue);
 		tasklet_setup(&state(hdlc)->rx_tasklet, x25_rx_queue_kick);
 
diff --git a/drivers/net/wan/lapbether.c b/drivers/net/wan/lapbether.c
index c3630a829..7f1b7eb21 100644
--- a/drivers/net/wan/lapbether.c
+++ b/drivers/net/wan/lapbether.c
@@ -38,6 +38,7 @@
 #include <linux/module.h>
 #include <linux/lapb.h>
 #include <linux/init.h>
+#include <linux/rcupdate.h>
 
 #include <net/netdev_lock.h>
 #include <net/x25device.h>
@@ -54,7 +55,6 @@ struct lapbethdev {
 	struct net_device	*ethdev;	/* link to ethernet device */
 	struct net_device	*axdev;		/* lapbeth device (lapb#) */
 	bool			up;
-	spinlock_t		up_lock;	/* Protects "up" */
 	struct sk_buff_head	rx_queue;
 	struct napi_struct	napi;
 };
@@ -126,11 +126,9 @@ static int lapbeth_rcv(struct sk_buff *skb, struct net_device *dev,
 
 	rcu_read_lock();
 	lapbeth = lapbeth_get_x25_dev(dev);
-	if (!lapbeth)
+	/* Pairs with smp_store_release() in lapbeth_open(). */
+	if (!lapbeth || !smp_load_acquire(&lapbeth->up))
 		goto drop_unlock_rcu;
-	spin_lock_bh(&lapbeth->up_lock);
-	if (!lapbeth->up)
-		goto drop_unlock;
 
 	len = skb->data[0] + skb->data[1] * 256;
 	dev->stats.rx_packets++;
@@ -142,15 +140,10 @@ static int lapbeth_rcv(struct sk_buff *skb, struct net_device *dev,
 	err = lapb_data_received(lapbeth->axdev, skb);
 	if (err != LAPB_OK) {
 		printk(KERN_DEBUG "lapbether: lapb_data_received err - %d\n", err);
-		goto drop_unlock;
+		goto drop_unlock_rcu;
 	}
-out:
-	spin_unlock_bh(&lapbeth->up_lock);
 	rcu_read_unlock();
 	return 0;
-drop_unlock:
-	kfree_skb(skb);
-	goto out;
 drop_unlock_rcu:
 	rcu_read_unlock();
 drop:
@@ -188,8 +181,9 @@ static netdev_tx_t lapbeth_xmit(struct sk_buff *skb,
 	struct lapbethdev *lapbeth = netdev_priv(dev);
 	int err;
 
-	spin_lock_bh(&lapbeth->up_lock);
-	if (!lapbeth->up)
+	rcu_read_lock();
+	/* Pairs with smp_store_release() in lapbeth_open(). */
+	if (!smp_load_acquire(&lapbeth->up))
 		goto drop;
 
 	/* There should be a pseudo header of 1 byte added by upper layers.
@@ -226,12 +220,12 @@ static netdev_tx_t lapbeth_xmit(struct sk_buff *skb,
 		pr_err("lapb_data_request error - %d\n", err);
 		goto drop;
 	}
-out:
-	spin_unlock_bh(&lapbeth->up_lock);
+	rcu_read_unlock();
 	return NETDEV_TX_OK;
 drop:
+	rcu_read_unlock();
 	kfree_skb(skb);
-	goto out;
+	return NETDEV_TX_OK;
 }
 
 static void lapbeth_data_transmit(struct net_device *ndev, struct sk_buff *skb)
@@ -331,9 +325,8 @@ static int lapbeth_open(struct net_device *dev)
 		return -ENODEV;
 	}
 
-	spin_lock_bh(&lapbeth->up_lock);
-	lapbeth->up = true;
-	spin_unlock_bh(&lapbeth->up_lock);
+	/* Publish LAPB/NAPI setup before rx/tx paths see up == true. */
+	smp_store_release(&lapbeth->up, true);
 
 	return 0;
 }
@@ -343,22 +336,29 @@ static int lapbeth_close(struct net_device *dev)
 	struct lapbethdev *lapbeth = netdev_priv(dev);
 	int err;
 
-	spin_lock_bh(&lapbeth->up_lock);
-	lapbeth->up = false;
-	spin_unlock_bh(&lapbeth->up_lock);
+	WRITE_ONCE(lapbeth->up, false);
+	synchronize_net();
 
 	err = lapb_unregister(dev);
 	if (err != LAPB_OK)
 		pr_err("lapb_unregister error: %d\n", err);
 
 	napi_disable(&lapbeth->napi);
+	skb_queue_purge(&lapbeth->rx_queue);
 
 	return 0;
 }
 
+static int lapbeth_dev_init(struct net_device *dev)
+{
+	netdev_lockdep_set_classes(dev);
+	return 0;
+}
+
 /* ------------------------------------------------------------------------ */
 
 static const struct net_device_ops lapbeth_netdev_ops = {
+	.ndo_init	     = lapbeth_dev_init,
 	.ndo_open	     = lapbeth_open,
 	.ndo_stop	     = lapbeth_close,
 	.ndo_start_xmit	     = lapbeth_xmit,
@@ -367,9 +367,9 @@ static const struct net_device_ops lapbeth_netdev_ops = {
 
 static void lapbeth_setup(struct net_device *dev)
 {
-	netdev_lockdep_set_classes(dev);
 	dev->netdev_ops	     = &lapbeth_netdev_ops;
 	dev->needs_free_netdev = true;
+	dev->lltx	     = true;
 	dev->type            = ARPHRD_X25;
 	dev->hard_header_len = 0;
 	dev->mtu             = 1000;
@@ -411,7 +411,6 @@ static int lapbeth_new_device(struct net_device *dev)
 	lapbeth->ethdev = dev;
 
 	lapbeth->up = false;
-	spin_lock_init(&lapbeth->up_lock);
 
 	skb_queue_head_init(&lapbeth->rx_queue);
 	netif_napi_add_weight(ndev, &lapbeth->napi, lapbeth_napi_poll, 16);
@@ -434,9 +433,11 @@ static int lapbeth_new_device(struct net_device *dev)
  */
 static void lapbeth_free_device(struct lapbethdev *lapbeth)
 {
-	dev_put(lapbeth->ethdev);
+	struct net_device *ethdev = lapbeth->ethdev;
+
 	list_del_rcu(&lapbeth->node);
 	unregister_netdevice(lapbeth->axdev);
+	dev_put(ethdev);
 }
 
 /*	Handle device status changes.
@@ -515,19 +516,14 @@ module_init(lapbeth_init_driver);
 
 static void __exit lapbeth_cleanup_driver(void)
 {
-	struct lapbethdev *lapbeth;
-	struct list_head *entry, *tmp;
+	struct lapbethdev *lapbeth, *tmp;
 
 	dev_remove_pack(&lapbeth_packet_type);
 	unregister_netdevice_notifier(&lapbeth_dev_notifier);
 
 	rtnl_lock();
-	list_for_each_safe(entry, tmp, &lapbeth_devices) {
-		lapbeth = list_entry(entry, struct lapbethdev, node);
-
-		dev_put(lapbeth->ethdev);
-		unregister_netdevice(lapbeth->axdev);
-	}
+	list_for_each_entry_safe(lapbeth, tmp, &lapbeth_devices, node)
+		lapbeth_free_device(lapbeth);
 	rtnl_unlock();
 }
 module_exit(lapbeth_cleanup_driver);
diff --git a/include/net/lapb.h b/include/net/lapb.h
index 6c0742064..8b4c5d13a 100644
--- a/include/net/lapb.h
+++ b/include/net/lapb.h
@@ -3,6 +3,7 @@
 #define _LAPB_H 
 #include <linux/lapb.h>
 #include <linux/refcount.h>
+#include <linux/workqueue.h>
 
 #define	LAPB_HEADER_LEN MAX_HEADER		/* LAPB over Ethernet + a bit more */
 
@@ -97,6 +98,8 @@ struct lapb_cb {
 	/* Internal control information */
 	struct sk_buff_head	write_queue;
 	struct sk_buff_head	ack_queue;
+	struct sk_buff_head	tx_queue;
+	struct work_struct	tx_work;
 	unsigned char		window;
 	const struct lapb_register_struct *callbacks;
 
diff --git a/net/lapb/lapb_iface.c b/net/lapb/lapb_iface.c
index 670e0859a..1c39dfee7 100644
--- a/net/lapb/lapb_iface.c
+++ b/net/lapb/lapb_iface.c
@@ -36,9 +36,13 @@
 #include <linux/init.h>
 #include <net/lapb.h>
 
+#define LAPB_TX_QUEUE_LEN_MAX 1000
+
 static LIST_HEAD(lapb_list);
 static DEFINE_RWLOCK(lapb_list_lock);
 
+static void lapb_tx_work(struct work_struct *work);
+
 /*
  *	Free an allocated lapb control block.
  */
@@ -63,8 +67,8 @@ static __inline__ void lapb_put(struct lapb_cb *lapb)
  */
 static void __lapb_remove_cb(struct lapb_cb *lapb)
 {
-	if (lapb->node.next) {
-		list_del(&lapb->node);
+	if (!list_empty(&lapb->node)) {
+		list_del_init(&lapb->node);
 		lapb_put(lapb);
 	}
 }
@@ -115,8 +119,11 @@ static struct lapb_cb *lapb_create_cb(void)
 	if (!lapb)
 		goto out;
 
+	INIT_LIST_HEAD(&lapb->node);
 	skb_queue_head_init(&lapb->write_queue);
 	skb_queue_head_init(&lapb->ack_queue);
+	skb_queue_head_init(&lapb->tx_queue);
+	INIT_WORK(&lapb->tx_work, lapb_tx_work);
 
 	timer_setup(&lapb->t1timer, NULL, 0);
 	timer_setup(&lapb->t2timer, NULL, 0);
@@ -172,16 +179,20 @@ EXPORT_SYMBOL(lapb_register);
 int lapb_unregister(struct net_device *dev)
 {
 	struct lapb_cb *lapb;
-	int rc = LAPB_BADTOKEN;
 
 	write_lock_bh(&lapb_list_lock);
 	lapb = __lapb_devtostruct(dev);
+	if (lapb) {
+		lapb_put(lapb);
+		__lapb_remove_cb(lapb);
+	}
+	write_unlock_bh(&lapb_list_lock);
+
 	if (!lapb)
-		goto out;
-	lapb_put(lapb);
+		return LAPB_BADTOKEN;
 
 	/* Wait for other refs to "lapb" to drop */
-	while (refcount_read(&lapb->refcnt) > 2)
+	while (refcount_read(&lapb->refcnt) > 1)
 		usleep_range(1, 10);
 
 	spin_lock_bh(&lapb->lock);
@@ -197,13 +208,11 @@ int lapb_unregister(struct net_device *dev)
 	timer_delete_sync(&lapb->t1timer);
 	timer_delete_sync(&lapb->t2timer);
 
-	__lapb_remove_cb(lapb);
+	cancel_work_sync(&lapb->tx_work);
+	__skb_queue_purge(&lapb->tx_queue);
 
 	lapb_put(lapb);
-	rc = LAPB_OK;
-out:
-	write_unlock_bh(&lapb_list_lock);
-	return rc;
+	return LAPB_OK;
 }
 EXPORT_SYMBOL(lapb_unregister);
 
@@ -439,12 +448,32 @@ int lapb_data_indication(struct lapb_cb *lapb, struct sk_buff *skb)
 	return NET_RX_SUCCESS; /* For now; must be != NET_RX_DROP */
 }
 
+static void lapb_tx_work(struct work_struct *work)
+{
+	struct lapb_cb *lapb = container_of(work, struct lapb_cb, tx_work);
+	struct sk_buff_head list;
+	struct sk_buff *skb;
+
+	__skb_queue_head_init(&list);
+	spin_lock_bh(&lapb->tx_queue.lock);
+	skb_queue_splice_tail_init(&lapb->tx_queue, &list);
+	spin_unlock_bh(&lapb->tx_queue.lock);
+
+	while ((skb = __skb_dequeue(&list))) {
+		local_bh_disable();
+		lapb->callbacks->data_transmit(lapb->dev, skb);
+		local_bh_enable();
+	}
+}
+
 int lapb_data_transmit(struct lapb_cb *lapb, struct sk_buff *skb)
 {
 	int used = 0;
 
-	if (lapb->callbacks->data_transmit) {
-		lapb->callbacks->data_transmit(lapb->dev, skb);
+	if (lapb->callbacks->data_transmit &&
+	    skb_queue_len_lockless(&lapb->tx_queue) < LAPB_TX_QUEUE_LEN_MAX) {
+		skb_queue_tail(&lapb->tx_queue, skb);
+		queue_work(system_highpri_wq, &lapb->tx_work);
 		used = 1;
 	}
 


base-commit: b6a9fa34ce4187cb69d3c588a4bbffc31ce5db8f
-- 
This is an AI-generated patch subject to moderation.
Reply with '#syz upstream' to Sign-off the patch as a human author
and send it to the upstream kernel mailing lists.
Reply with '#syz reject' to reject it ('#syz unreject' to undo).

See https://goo.gle/syzbot-ai-patches for information about AI-generated patches.
You can comment on the patch as usual, syzbot will try to address
the comments and send a new version of the patch if necessary.
syzbot engineers can be reached at syzkaller@googlegroups.com.
