Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795167875;
	b=hbNh8VyY/fLvw199pU7Kr10Q5rbo+4alRYgjHsSJgaEQyCbySGjCx2GFOe0ebSrR8aLy
	 RBmMVkIbXXBWtrXFSkm7XlGgVzhxYLBjCW+YIQPuELttiN1EMjw4veDu96JtKq2XJBOj0
	 p/G2eFsCx9MCav0AUx0L9tw9Y6850zpQ9YdiZvyP8cgb+lQXPOKf/5Nj2oGP6R1aJh1WT
	 0g/wg464zvtLoUV4XFClvWMglyMPeN1rJ2ofF9idQxAa37ddx2/MJ6XYjikhvrAe3bElx
	 fSXLo2qzKXnS2uhtBQQZrdg7Ie85TMicEdqe68W2SEe3ssfNyB76lyhp6utUjZLXAEw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795167875;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Message-ID:MIME-Version:
	 Content-Type:Content-Transfer-Encoding:Date;
	bh=Dqkiq30yBanl7xewXuyuKJYZnue8ASHNq+EZiXLR6V8=;
	b=dLkD7SZksAr862puewXsHDp1sBx6V8gkcuePG4MzG3Dr7DgSAdGThdXK66BMHvJffthv
	 fx02g1yfhZni0sdnw2bofG8hgWavcw9EfN02OPlTxDCC61cKz11Hm4rnOO1fxUx33YW+9
	 oWnKjJDX0vrY5Q8e7uR01btY0QEvSzCE72zYDwlK/mjDG1rmQo3iHIVEjeWPv2Yjc/G9T
	 0zAlAO5ECNPvRfY4MPoknuAQXiJkYQ0uKdUF0wQ+c1uewdiZvOfv76Jm1UQrhrvI2xzIl
	 DWagYpxjjMaN3v737dtZgcL5KeiD39VH55W7/eiL7Dp5EGZf79yduoWfHLY9FlsKFeA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=bWT6Mk1b;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with UTF8SMTPS id 4325B606A32C;
	Fri, 20 Nov 2026 09:44:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=bWT6Mk1b
Received: by smtp.kernel.org (Postfix) with UTF8SMTPSA id 7531F1F000CA;
	Fri, 20 Nov 2026 09:44:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795167874;
	bh=Dqkiq30yBanl7xewXuyuKJYZnue8ASHNq+EZiXLR6V8=;
	h=From:To:Cc:Subject:Date;
	b=bWT6Mk1bpBFDnkNSq7deGXEZQ9xyInf+E70oPJPue746FOF29p3l45GNV/ErXIFI5
	 UbH+70GzaD2SigF2H9gicAo2PC5KeNutGD6IAcoDW1T8IGM0NSN0d9kvN/rDR8YKeK
	 21u+doNk0fUbsMVHYKgGQ+NW5KzBsC9UqvXGPaaQhmWOb4AIB4eWvWMd+9/EvgueH+
	 bZLtTdX31/syiaWxKU++awHFgkE8z4jWfpdqcJXdBTw5FSf0gpzYMXtTX/6s4xYFfk
	 2X8kWIV+L0cu3ZzvFPlkW/K5VQGm+NuDH56Ih1pXwVTNAaDs+L+tV0K11Uaoxta8xt
	 I+StyLQ2s+vxg==
From: "syzbot" <syzbot@kernel.org>
To: syzkaller-bugs@googlegroups.com, Krystian Kaniewski <krystianmkaniewski@gmail.com>, "David S. Miller" <davem@davemloft.net>, "Eric Dumazet" <edumazet@kernel.org>, "Jakub Kicinski" <kuba@kernel.org>, <linux-x25@vger.kernel.org>, "Martin Schiller" <ms@dev.tdt.de>, <netdev@vger.kernel.org>, "Paolo Abeni" <pabeni@redhat.com>, "Duoming Zhou" <duoming@zju.edu.cn>
Cc: horms@kernel.org, linux-kernel@vger.kernel.org, syzbot@lists.linux.dev
Subject: [PATCH] net/x25: fix invalid lock_sock() usage in x25_kill_by_neigh()
Message-ID: <00f667e3-a158-4fb5-84a3-9ecda4718ce8@mail.kernel.org>
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
Date: Fri, 20 Nov 2026 09:44:34 +0000 (UTC)

From: Krystian Kaniewski <krystianmkaniewski@gmail.com>

x25_kill_by_neigh() is invoked to tear down X.25 sockets associated with a
terminating neighbour. This function is called in process context from
netdevice notifier handlers (such as NETDEV_DOWN in x25_device_event()),
but it is also called in softirq context when receiving LAPB frames in
x25_lapb_receive_frame() or link control packets in x25_link_control(), as
both lapbether (via NAPI) and hdlc_x25 (via tasklet) deliver frames in
softirq.

x25_kill_by_neigh() acquires lock_sock() around x25_disconnect(). Because
lock_sock() is a sleeping lock, calling it from softirq context triggers a
"BUG: sleeping function called from invalid context" and a lockdep
inconsistent lock state warning ({SOFTIRQ-ON-W} -> {IN-SOFTIRQ-W}) on
sk_lock-AF_X25.

Fix this by passing a boolean parameter to x25_kill_by_neigh() and
x25_link_terminated() to distinguish between process and softirq contexts.
Sockets hold neighbour references and reach net_device only through the
neighbour. In process context (netdevice notifiers), continue using
lock_sock() to synchronously disconnect sockets and wait for tasks owning
the socket, because x25_link_device_down() drops the neighbour's netdevice
reference on NETDEV_UNREGISTER. In softirq context, use bh_lock_sock()
instead; if the socket is currently owned by a task through lock_sock(),
defer the disconnect by setting X25_KILL_BY_NEIGH_FLAG and handling it in
x25_release_cb() when the socket is released.

Fixes: 7781607938c8 ("net/x25: Fix null-ptr-deref caused by x25_disconnect")
Assisted-by: Gemini:gemini-4-carbon Gemini:gemini-3.8-flash syzbot
Reported-by: syzbot+300375dfd44665f063a6@syzkaller.appspotmail.com
Closes: https://syzkaller.appspot.com/bug?extid=300375dfd44665f063a6
Link: https://syzkaller.appspot.com/ai_job?id=98a38af7-51e0-4126-afa7-b8246507da37
Signed-off-by: Krystian Kaniewski <krystianmkaniewski@gmail.com>

---
diff --git a/include/net/x25.h b/include/net/x25.h
index 414f3fd99..ec4c9ced1 100644
--- a/include/net/x25.h
+++ b/include/net/x25.h
@@ -118,6 +118,7 @@ enum {
 #define X25_Q_BIT_FLAG		0
 #define X25_INTERRUPT_FLAG	1
 #define X25_ACCPT_APPRV_FLAG	2
+#define X25_KILL_BY_NEIGH_FLAG	3
 
 /**
  *	struct x25_route - x25 routing entry
@@ -196,7 +197,7 @@ int x25_addr_aton(unsigned char *, struct x25_address *, struct x25_address *);
 struct sock *x25_find_socket(unsigned int, struct x25_neigh *);
 void x25_destroy_socket_from_timer(struct sock *);
 int x25_rx_call_request(struct sk_buff *, struct x25_neigh *, unsigned int);
-void x25_kill_by_neigh(struct x25_neigh *);
+void x25_kill_by_neigh(struct x25_neigh *, bool);
 
 /* x25_dev.c */
 void x25_send_frame(struct sk_buff *, struct x25_neigh *);
@@ -230,7 +231,7 @@ void x25_link_control(struct sk_buff *, struct x25_neigh *, unsigned short);
 void x25_link_device_up(struct net_device *);
 void x25_link_device_down(struct net_device *);
 void x25_link_established(struct x25_neigh *);
-void x25_link_terminated(struct x25_neigh *);
+void x25_link_terminated(struct x25_neigh *, bool);
 void x25_transmit_clear_request(struct x25_neigh *, unsigned int,
 				unsigned char);
 void x25_transmit_link(struct sk_buff *, struct x25_neigh *);
diff --git a/net/x25/af_x25.c b/net/x25/af_x25.c
index f45c9ec7d..26a8deb82 100644
--- a/net/x25/af_x25.c
+++ b/net/x25/af_x25.c
@@ -221,7 +221,7 @@ static int x25_device_event(struct notifier_block *this, unsigned long event,
 		case NETDEV_DOWN:
 			nb = x25_get_neigh(dev);
 			if (nb) {
-				x25_link_terminated(nb);
+				x25_link_terminated(nb, false);
 				x25_neigh_put(nb);
 			}
 			x25_route_device_down(dev);
@@ -234,7 +234,7 @@ static int x25_device_event(struct notifier_block *this, unsigned long event,
 			if (!netif_carrier_ok(dev)) {
 				nb = x25_get_neigh(dev);
 				if (nb) {
-					x25_link_terminated(nb);
+					x25_link_terminated(nb, false);
 					x25_neigh_put(nb);
 				}
 			}
@@ -492,10 +492,24 @@ static int x25_listen(struct socket *sock, int backlog)
 	return rc;
 }
 
+/*
+ * release_sock() calls this with the socket spinlock held while the task
+ * still owns the socket, so x25->neighbour cannot change during the check.
+ */
+static void x25_release_cb(struct sock *sk)
+{
+	struct x25_sock *x25 = x25_sk(sk);
+
+	if (test_and_clear_bit(X25_KILL_BY_NEIGH_FLAG, &x25->flags) &&
+	    x25->neighbour)
+		x25_disconnect(sk, ENETUNREACH, 0, 0);
+}
+
 static struct proto x25_proto = {
 	.name	  = "X25",
 	.owner	  = THIS_MODULE,
 	.obj_size = sizeof(struct x25_sock),
+	.release_cb = x25_release_cb,
 };
 
 static struct sock *x25_alloc_socket(struct net *net, int kern)
@@ -610,6 +624,7 @@ static struct sock *x25_make_new(struct sock *osk)
 	x25->cudmatchlength = ox25->cudmatchlength;
 
 	clear_bit(X25_INTERRUPT_FLAG, &x25->flags);
+	clear_bit(X25_KILL_BY_NEIGH_FLAG, &x25->flags);
 	x25_init_timers(sk);
 out:
 	return sk;
@@ -1761,7 +1776,13 @@ static struct notifier_block x25_dev_notifier = {
 	.notifier_call = x25_device_event,
 };
 
-void x25_kill_by_neigh(struct x25_neigh *nb)
+/*
+ * The receive path (bh == true) runs in softirq and must not wait for a task
+ * that owns the socket. The netdevice notifier (bh == false) must wait for
+ * every owner because x25_link_device_down() drops the device reference of the
+ * neighbour on NETDEV_UNREGISTER.
+ */
+void x25_kill_by_neigh(struct x25_neigh *nb, bool bh)
 {
 	struct sock *s;
 
@@ -1769,13 +1790,28 @@ void x25_kill_by_neigh(struct x25_neigh *nb)
 	write_lock_bh(&x25_list_lock);
 
 	sk_for_each(s, &x25_list) {
-		if (x25_sk(s)->neighbour == nb) {
+		if (x25_sk(s)->neighbour == nb &&
+		    (!bh ||
+		     !test_bit(X25_KILL_BY_NEIGH_FLAG, &x25_sk(s)->flags))) {
 			sock_hold(s);
 			write_unlock_bh(&x25_list_lock);
-			lock_sock(s);
-			if (x25_sk(s)->neighbour == nb)
-				x25_disconnect(s, ENETUNREACH, 0, 0);
-			release_sock(s);
+			if (bh) {
+				bh_lock_sock(s);
+				if (x25_sk(s)->neighbour == nb) {
+					if (sock_owned_by_user(s))
+						set_bit(X25_KILL_BY_NEIGH_FLAG,
+							&x25_sk(s)->flags);
+					else
+						x25_disconnect(s, ENETUNREACH,
+							       0, 0);
+				}
+				bh_unlock_sock(s);
+			} else {
+				lock_sock(s);
+				if (x25_sk(s)->neighbour == nb)
+					x25_disconnect(s, ENETUNREACH, 0, 0);
+				release_sock(s);
+			}
 			sock_put(s);
 			goto again;
 		}
diff --git a/net/x25/x25_dev.c b/net/x25/x25_dev.c
index fb8ac1aa5..be5eb01de 100644
--- a/net/x25/x25_dev.c
+++ b/net/x25/x25_dev.c
@@ -135,7 +135,7 @@ int x25_lapb_receive_frame(struct sk_buff *skb, struct net_device *dev,
 		break;
 
 	case X25_IFACE_DISCONNECT:
-		x25_link_terminated(nb);
+		x25_link_terminated(nb, true);
 		break;
 	}
 	x25_neigh_put(nb);
diff --git a/net/x25/x25_link.c b/net/x25/x25_link.c
index d1e8cd81c..d3e90b402 100644
--- a/net/x25/x25_link.c
+++ b/net/x25/x25_link.c
@@ -82,7 +82,7 @@ void x25_link_control(struct sk_buff *skb, struct x25_neigh *nb,
 			break;
 		case X25_LINK_STATE_3:
 			/* clear existing virtual calls */
-			x25_kill_by_neigh(nb);
+			x25_kill_by_neigh(nb, true);
 
 			x25_transmit_restart_confirmation(nb);
 			break;
@@ -97,7 +97,7 @@ void x25_link_control(struct sk_buff *skb, struct x25_neigh *nb,
 			break;
 		case X25_LINK_STATE_3:
 			/* clear existing virtual calls */
-			x25_kill_by_neigh(nb);
+			x25_kill_by_neigh(nb, true);
 
 			x25_transmit_restart_request(nb);
 			nb->state = X25_LINK_STATE_2;
@@ -247,14 +247,14 @@ void x25_link_established(struct x25_neigh *nb)
  *	request has failed.
  */
 
-void x25_link_terminated(struct x25_neigh *nb)
+void x25_link_terminated(struct x25_neigh *nb, bool bh)
 {
 	nb->state = X25_LINK_STATE_0;
 	skb_queue_purge(&nb->queue);
 	x25_stop_t20timer(nb);
 
 	/* Out of order: clear existing virtual calls (X.25 03/93 4.6.3) */
-	x25_kill_by_neigh(nb);
+	x25_kill_by_neigh(nb, bh);
 }
 
 /*


base-commit: 6628e7d4c6b25c8d18f1345e3a20d21829aae7e4
-- 
See https://goo.gle/syzbot-ai-patches for information about AI-generated patches.
The person who has signed off on the patch is responsible for
addressing comments.
syzbot engineers can be reached at syzkaller@googlegroups.com.
