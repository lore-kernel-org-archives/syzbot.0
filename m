Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794585187;
	b=ymYkbYN6AyEdDukabEVL/RMIxz7WmGAWj8mtLZrWD3WpoSO5tpRQjX9QrJLsVrdv9xrY
	 7fZKtF39d8pytZKzao2eBISYRM7Wx3cPa7xCNKwfHSls0jx3BS8FFO9g9kTo1htbWDgQZ
	 VtJHH+kCckJ9xAl83/Nzf85arQEDVK/TftHtzH6/J1Dw0sPvOBzK1RSiyUpqA6CqEg+F1
	 AQtzTAn3pyI0N4+y+1qZzZBGgU4sdMX3kL4wXLNmSkQuaxDMDrSOx72HDCsHUALcXSPUB
	 fEmFD1DpFhei6Lq4d5+LQelG4bzXaRDM6abIsqpD+myreCIGWxP55zVWpOhY+D5kNkg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794585187;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Message-ID:MIME-Version:
	 Content-Type:Content-Transfer-Encoding:Date;
	bh=925ION72b92wbL32KdLPx4ZgXVQZjqx1b0V/EuK5a6A=;
	b=ls1J598PaN//X/Mt6FJHLKR8IiNu9wv8RAzhZf5ilA/dOQAGhUEGTPDK+evH+KPcwqHv
	 E60QjgP9bECMZNVeGAiF0Bv1ENqlB+/Fji+K+Ecxv4u6Y4ajRJ3pY6DiPsgwu4bFGVlsA
	 ExwsGxcvtUHOcJmkHwWD6QGoRMmBuzoB0lPx+TADPxyxpk4FdA7duBfsVjFqxg+tMWsaO
	 BHFWbyDZdnNBMtJb7TJgheEUh7etDIwoQfSJIzLZQsgVtbP0AY6lctXpdfmvxrKOUo0it
	 aidhhl50JA33e3SCbAOXYePBjGqcLGM8ht/6JILGYttC1ndn0H97HURUR658hf01MNg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=ZEGD+55W;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with UTF8SMTPS id B73C2606A881
	for <syzbot@lists.linux.dev>; Fri, 13 Nov 2026 15:53:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=ZEGD+55W
Received: by smtp.kernel.org (Postfix) with UTF8SMTPSA id 265C31F000C4;
	Fri, 13 Nov 2026 15:53:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794585187;
	bh=925ION72b92wbL32KdLPx4ZgXVQZjqx1b0V/EuK5a6A=;
	h=From:To:Cc:Subject:Date;
	b=ZEGD+55W35dLkt+ukTy25SNOZElnmN1Z53mUwebeN4rxPWdaVpc6hSwd6VrdFmUew
	 lNxlQuYTXSX0WUjP+UKziIpL5X/k5se+aHSsiSUg/OgC6n4jKyrTcegNEFteY6F12r
	 b7jSafBBsnDMHzefVILZBHqEg88Fi8eyFB/aY6nTQIKbO2/6kQAAX+so/UIBtY3Cua
	 IH2uk+/diWTzbSd6NeteckrelGjNvuhB/cuZndJ2qRMmLCEqHCz45UAxyD3oznjqVJ
	 dS8CxFAo/IBXrnx10RP33mnxveGjMuM5GF/al8ND4qNnAoPgT90MgtMVNUiaSm0FYZ
	 0nKFZwgB5T5Jw==
From: "syzbot" <syzbot@kernel.org>
To: syzkaller-upstream-moderation@googlegroups.com
Cc: krystianmkaniewski@gmail.com, syzbot@lists.linux.dev
Subject: [PATCH RFC v3] net/x25: fix invalid lock_sock() usage in x25_kill_by_neigh()
Message-ID: <7896865a-72bb-4375-9512-575f36952430@mail.kernel.org>
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
Date: Fri, 13 Nov 2026 15:53:07 +0000 (UTC)

x25_kill_by_neigh() is invoked to tear down X.25 sockets associated with a
terminating neighbour. This function is called in process context from
netdevice notifier handlers (such as NETDEV_DOWN in x25_device_event()),
but it is also called in softirq context (NET_RX_SOFTIRQ) under
rcu_read_lock() when receiving LAPB frames in x25_lapb_receive_frame() or
link control packets in x25_link_control().

x25_kill_by_neigh() acquires lock_sock() around x25_disconnect(). Because
lock_sock() is a sleeping lock, calling it from softirq context triggers a
"BUG: sleeping function called from invalid context" and a lockdep
inconsistent lock state warning ({SOFTIRQ-ON-W} -> {IN-SOFTIRQ-W}) on
sk_lock-AF_X25.

Fix this by passing a boolean parameter to x25_kill_by_neigh() and
x25_link_terminated() to distinguish between process and softirq contexts.
In process context (netdevice notifiers), continue using lock_sock() to
synchronously disconnect sockets, ensuring that neighbour and netdevice
references are cleared before the notifier returns to preserve the
netdevice notifier lifetime guarantee. In softirq context, use
bh_lock_sock() instead; if the socket is currently owned by user space,
defer the disconnect by setting X25_KILL_BY_NEIGH_FLAG and handling it in
x25_release_cb() when the socket is released.

Fixes: 7781607938c8 ("net/x25: Fix null-ptr-deref caused by x25_disconnect")
Assisted-by: Gemini:gemini-4-carbon Gemini:gemini-3.8-flash syzbot
Reported-by: syzbot+300375dfd44665f063a6@syzkaller.appspotmail.com
Closes: https://syzkaller.appspot.com/bug?extid=300375dfd44665f063a6
Link: https://syzkaller.appspot.com/ai_job?id=2e7bbf89-6757-4df2-a7f2-bdd34917d974
To: "David S. Miller" <davem@davemloft.net>
To: "Eric Dumazet" <edumazet@kernel.org>
To: "Jakub Kicinski" <kuba@kernel.org>
To: <linux-x25@vger.kernel.org>
To: "Martin Schiller" <ms@dev.tdt.de>
To: <netdev@vger.kernel.org>
To: "Paolo Abeni" <pabeni@redhat.com>
To: "Duoming Zhou" <duoming@zju.edu.cn>
Cc: "Simon Horman" <horms@kernel.org>
Cc: <linux-kernel@vger.kernel.org>

---
v3:
- Check that x25->neighbour is non-NULL in x25_release_cb() before calling x25_disconnect()
- Remove duplicate wrapped Fixes tag from the commit description

v2:
- Pass a boolean parameter to x25_kill_by_neigh() and x25_link_terminated() to distinguish softirq from process context.
- Retain lock_sock() in process context to preserve synchronous socket teardown for netdevice notifications.
- Retain write_lock_bh() on x25_list_lock instead of manually managing local_bh_disable().
- Shorten the commit description by removing stack traces and per-function details.
- Fix line wrapping in the Fixes tag.
https://lore.kernel.org/all/b624bc4d-6240-4c80-82a8-c727545f2a5e@mail.kernel.org/T/

v1:
https://lore.kernel.org/all/f1cbebc5-aab9-44ac-8425-1bc9fdbbf5b7@mail.kernel.org/T/
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
index f45c9ec7d..6b664e04d 100644
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
@@ -492,10 +492,20 @@ static int x25_listen(struct socket *sock, int backlog)
 	return rc;
 }
 
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
@@ -610,6 +620,7 @@ static struct sock *x25_make_new(struct sock *osk)
 	x25->cudmatchlength = ox25->cudmatchlength;
 
 	clear_bit(X25_INTERRUPT_FLAG, &x25->flags);
+	clear_bit(X25_KILL_BY_NEIGH_FLAG, &x25->flags);
 	x25_init_timers(sk);
 out:
 	return sk;
@@ -827,6 +838,7 @@ static int x25_connect(struct socket *sock, struct sockaddr_unsized *uaddr,
 		x25->neighbour = NULL;
 		read_unlock_bh(&x25_list_lock);
 		x25->state = X25_STATE_0;
+		clear_bit(X25_KILL_BY_NEIGH_FLAG, &x25->flags);
 	}
 out_put_route:
 	x25_route_put(rt);
@@ -1761,7 +1773,7 @@ static struct notifier_block x25_dev_notifier = {
 	.notifier_call = x25_device_event,
 };
 
-void x25_kill_by_neigh(struct x25_neigh *nb)
+void x25_kill_by_neigh(struct x25_neigh *nb, bool bh)
 {
 	struct sock *s;
 
@@ -1769,13 +1781,28 @@ void x25_kill_by_neigh(struct x25_neigh *nb)
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
diff --git a/net/x25/x25_subr.c b/net/x25/x25_subr.c
index 159708d9a..344818f88 100644
--- a/net/x25/x25_subr.c
+++ b/net/x25/x25_subr.c
@@ -341,6 +341,8 @@ void x25_disconnect(struct sock *sk, int reason, unsigned char cause,
 {
 	struct x25_sock *x25 = x25_sk(sk);
 
+	clear_bit(X25_KILL_BY_NEIGH_FLAG, &x25->flags);
+
 	x25_clear_queues(sk);
 	x25_stop_timer(sk);
 


base-commit: 6628e7d4c6b25c8d18f1345e3a20d21829aae7e4
-- 
This is an AI-generated patch subject to moderation.
Reply with '#syz upstream' to Sign-off the patch as a human author
and send it to the upstream kernel mailing lists.
Reply with '#syz reject' to reject it ('#syz unreject' to undo).

See https://goo.gle/syzbot-ai-patches for information about AI-generated patches.
You can comment on the patch as usual, syzbot will try to address
the comments and send a new version of the patch if necessary.
syzbot engineers can be reached at syzkaller@googlegroups.com.
