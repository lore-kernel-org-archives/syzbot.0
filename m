Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 28FDA37BE98
	for <syzbot@lists.linux.dev>; Wed, 23 Sep 2026 03:51:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790135490; cv=none; b=UP+bEr9zt9HbuTXFqgUG+G6h0NONFpjYGObTr3WNz9Uw2rpYJ9fD5itxDiPCT9Uo55slYJPiXdkKubJ8bGpn6y36mqjE4jybfC+/VRwlR/EnbTC7mcDnbQoecqs3coAUcP17diSoluUMLsvE37H5hw139yaEurfOM6of5hllXIM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790135490; c=relaxed/simple;
	bh=SpuWyUquuXItYLqAC6p1vGV7dURGuC7r2W53o6xF5ew=;
	h=From:To:Cc:Subject:Message-ID:MIME-Version:Content-Type:Date; b=MI//TDtPmuFk8L70s6GqIbx9J3zKwUs1zbbLRde90nbzzDDyLLTEBqOTKsY0krYl9plgJnt40ktl3UobG3U1NLlRVRn89P90RSXlIPpg9rYhYjjhDKsrRRqdPpYBbf7fUNBCL0bHLIgbZxzOXEn9mcR/ZUJzmdhVj29UQFclU1k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=dWAXHPcm; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="dWAXHPcm"
Received: by smtp.kernel.org (Postfix) with UTF8SMTPSA id BC0891F000FF;
	Wed, 23 Sep 2026 03:51:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1790135488;
	bh=B4tXwA69NpgDHcGX00rjINfhnQL+fLKnDTVHjb18cIo=;
	h=From:To:Cc:Subject:Date;
	b=dWAXHPcm+MbYVfYmFX2SU73CYDP5z8kALQFWOn1IyeEpqO66sp/99HdEE+hwWhN7l
	 L7PDWthxR/UDq7TEJMdgWxrgfJRHXeriaRWJw7isVgOziM7RA17v0SEno3N8CDJLIN
	 es0WsEvhouDoEr0pqus+HANQ2iBKKfJe89MbXYSqezCy8+L9NyDI7olvYyYI40N5Ys
	 13yif2epV8zvcHmbhgqCPGGzpq/m4EV2KJs83psn8rNpLRwvTONx1jXut6a7aqg/KP
	 JS0oyS2RJpqTRhEvrg2SYHm+ZhucIMsAdYTOJZ9yo0GxCfxK+JX4kACFLsrrUw6YMf
	 FZxpVYCVEusrg==
From: "syzbot" <syzbot@kernel.org>
To: syzkaller-upstream-moderation@googlegroups.com
Cc: syzbot@lists.linux.dev
Subject: [PATCH RFC] net/x25: defer socket cleanup in x25_kill_by_neigh() to workqueue
Message-ID: <b790da86-7914-4ffe-a479-5f86ffbd47d3@mail.kernel.org>
Precedence: bulk
X-Mailing-List: syzbot@lists.linux.dev
List-Id: <syzbot.lists.linux.dev>
List-Subscribe: <mailto:syzbot+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:syzbot+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Date: Wed, 23 Sep 2026 03:51:28 +0000 (UTC)

When an X.25 link layer connection is disconnected or terminated,
x25_link_terminated() calls x25_kill_by_neigh() to disconnect all sockets
associated with the terminating neighbor. However, this path can be
executed in softirq context, for instance when processing an incoming LAPB
disconnect frame via net_rx_action() -> lapbeth_napi_poll() ->
x25_lapb_receive_frame() -> x25_link_terminated(). Within
x25_kill_by_neigh(), lock_sock() is invoked for each matching socket.
Because lock_sock() can sleep, calling it from softirq context violates
kernel locking rules and triggers a sleeping function called from invalid
context bug:

BUG: sleeping function called from invalid context at net/core/sock.c:3839
in_atomic(): 0, irqs_disabled(): 0, non_block: 0, pid: 16, name: ktimers/0
preempt_count: 0, expected: 0
RCU nest depth: 2, expected: 0
Call Trace:
 <TASK>
 dump_stack_lvl+0xe8/0x150 lib/dump_stack.c:120
 __might_resched+0x31b/0x470 kernel/sched/core.c:9264
 lock_sock_nested+0x56/0x130 net/core/sock.c:3839
 lock_sock include/net/sock.h:1713 [inline]
 x25_kill_by_neigh+0x134/0x2a0 net/x25/af_x25.c:1778
 x25_lapb_receive_frame+0x1b0/0xfb0 net/x25/x25_dev.c:138
 netif_receive_skb_core+0x2a6/0x2b0 net/core/dev.c:6289
 lapbeth_napi_poll+0x45/0x90 drivers/net/wan/lapbether.c:100
 net_rx_action+0x621/0xd70 net/core/dev.c:8007
 handle_softirqs+0x1da/0x6d0 kernel/softirq.c:645
 </TASK>

Fix this by deferring the socket disconnection logic in x25_kill_by_neigh()
to process context via a dedicated workqueue (x25_wq). Add a kill_work
work_struct to struct x25_neigh and initialize it in x25_link_device_up().
In x25_kill_by_neigh(), clear forwarding entries synchronously, increment
the neighbor reference count, and dispatch kill_work onto x25_wq. If the
work was already queued, drop the reference immediately. In
x25_kill_by_neigh_work(), iterate over x25_list in process context where
lock_sock() can safely sleep, and release the neighbor reference upon
completion. In addition, allocate x25_wq with WQ_UNBOUND during module
initialization and destroy it during module unload and init failure
unwinding.

Fixes: 7781607938c8 ("net/x25: Fix null-ptr-deref caused by
x25_disconnect")

Fixes: 7781607938c8 ("net/x25: Fix null-ptr-deref caused by x25_disconnect")
Assisted-by: Gemini:gemini-3.8-flash Gemini:gemini-3.1-pro-preview syzbot
Reported-by: syzbot+9faa82ae2e94c5c7d2ef@syzkaller.appspotmail.com
Closes: https://syzkaller.appspot.com/bug?extid=9faa82ae2e94c5c7d2ef
Link: https://syzkaller.appspot.com/ai_job?id=4f5af180-1ab7-4f6e-b59a-f3affbe7eb02
To: "David S. Miller" <davem@davemloft.net>
To: "Eric Dumazet" <edumazet@google.com>
To: "Jakub Kicinski" <kuba@kernel.org>
To: <linux-x25@vger.kernel.org>
To: "Martin Schiller" <ms@dev.tdt.de>
To: <netdev@vger.kernel.org>
To: "Paolo Abeni" <pabeni@redhat.com>
To: "Duoming Zhou" <duoming@zju.edu.cn>
Cc: "Simon Horman" <horms@kernel.org>
Cc: <linux-kernel@vger.kernel.org>

---
diff --git a/include/net/x25.h b/include/net/x25.h
index 414f3fd99..369f24d98 100644
--- a/include/net/x25.h
+++ b/include/net/x25.h
@@ -13,6 +13,7 @@
 #include <linux/x25.h>
 #include <linux/slab.h>
 #include <linux/refcount.h>
+#include <linux/workqueue.h>
 #include <net/sock.h>
 
 #define	X25_ADDR_LEN			16
@@ -145,6 +146,7 @@ struct x25_neigh {
 	struct timer_list	t20timer;
 	unsigned long		global_facil_mask;
 	refcount_t		refcnt;
+	struct work_struct	kill_work;
 };
 
 struct x25_sock {
@@ -197,6 +199,7 @@ struct sock *x25_find_socket(unsigned int, struct x25_neigh *);
 void x25_destroy_socket_from_timer(struct sock *);
 int x25_rx_call_request(struct sk_buff *, struct x25_neigh *, unsigned int);
 void x25_kill_by_neigh(struct x25_neigh *);
+void x25_kill_by_neigh_work(struct work_struct *work);
 
 /* x25_dev.c */
 void x25_send_frame(struct sk_buff *, struct x25_neigh *);
diff --git a/net/x25/af_x25.c b/net/x25/af_x25.c
index 033e7d059..536b6b350 100644
--- a/net/x25/af_x25.c
+++ b/net/x25/af_x25.c
@@ -67,6 +67,7 @@ int sysctl_x25_forward                 = 0;
 
 HLIST_HEAD(x25_list);
 DEFINE_RWLOCK(x25_list_lock);
+static struct workqueue_struct *x25_wq;
 
 static const struct proto_ops x25_proto_ops;
 
@@ -1764,8 +1765,9 @@ static struct notifier_block x25_dev_notifier = {
 	.notifier_call = x25_device_event,
 };
 
-void x25_kill_by_neigh(struct x25_neigh *nb)
+void x25_kill_by_neigh_work(struct work_struct *work)
 {
+	struct x25_neigh *nb = container_of(work, struct x25_neigh, kill_work);
 	struct sock *s;
 
 again:
@@ -1785,8 +1787,20 @@ void x25_kill_by_neigh(struct x25_neigh *nb)
 	}
 	write_unlock_bh(&x25_list_lock);
 
+	x25_neigh_put(nb);
+}
+
+void x25_kill_by_neigh(struct x25_neigh *nb)
+{
+	if (!nb)
+		return;
+
 	/* Remove any related forwards */
 	x25_clear_forward_by_dev(nb->dev);
+
+	x25_neigh_hold(nb);
+	if (!queue_work(x25_wq, &nb->kill_work))
+		x25_neigh_put(nb);
 }
 
 static int __init x25_init(void)
@@ -1801,11 +1815,17 @@ static int __init x25_init(void)
 	if (rc)
 		goto out_proto;
 
+	x25_wq = alloc_workqueue("x25_wq", WQ_UNBOUND, 0);
+	if (!x25_wq) {
+		rc = -ENOMEM;
+		goto out_sock;
+	}
+
 	dev_add_pack(&x25_packet_type);
 
 	rc = register_netdevice_notifier(&x25_dev_notifier);
 	if (rc)
-		goto out_sock;
+		goto out_pack;
 
 	rc = x25_register_sysctl();
 	if (rc)
@@ -1823,8 +1843,10 @@ static int __init x25_init(void)
 	x25_unregister_sysctl();
 out_dev:
 	unregister_netdevice_notifier(&x25_dev_notifier);
-out_sock:
+out_pack:
 	dev_remove_pack(&x25_packet_type);
+	destroy_workqueue(x25_wq);
+out_sock:
 	sock_unregister(AF_X25);
 out_proto:
 	proto_unregister(&x25_proto);
@@ -1844,6 +1866,8 @@ static void __exit x25_exit(void)
 
 	dev_remove_pack(&x25_packet_type);
 
+	destroy_workqueue(x25_wq);
+
 	sock_unregister(AF_X25);
 	proto_unregister(&x25_proto);
 }
diff --git a/net/x25/x25_link.c b/net/x25/x25_link.c
index d1e8cd81c..a77274cf1 100644
--- a/net/x25/x25_link.c
+++ b/net/x25/x25_link.c
@@ -269,6 +269,7 @@ void x25_link_device_up(struct net_device *dev)
 
 	skb_queue_head_init(&nb->queue);
 	timer_setup(&nb->t20timer, x25_t20timer_expiry, 0);
+	INIT_WORK(&nb->kill_work, x25_kill_by_neigh_work);
 
 	dev_hold(dev);
 	nb->dev      = dev;


base-commit: 93f51579e7df248780214094418f205253383cc5
-- 
This is an AI-generated patch subject to moderation.
Reply with '#syz upstream' to Sign-off the patch as a human author
and send it to the upstream kernel mailing lists.
Reply with '#syz reject' to reject it ('#syz unreject' to undo).

See https://goo.gle/syzbot-ai-patches for information about AI-generated patches.
You can comment on the patch as usual, syzbot will try to address
the comments and send a new version of the patch if necessary.
syzbot engineers can be reached at syzkaller@googlegroups.com.
