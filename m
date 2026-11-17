Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794921386;
	b=C3CiQdBaWZZfk/C3tOkefzKbFWv5gMt6xArnHGB1I6pnwWyLXZOnzgSSOhPdGOW6Xjc4
	 xrUfdV/ghoD/BjpvRLPJqOKakyB5/V5xcxC0IS+E4edHiEls/uYsaMfdJgCJcwcXx6PYO
	 1UKO8l0m7LjWNP1Cpc2/i1fEYIJdTCoQiMMYBmzXJG6YFMguwOddb7fPbnTE4GRR2ITNj
	 lXz6VP15MahTyEk7/s+KzEx1toADjVay5YM82XPV2LClI7HoJGWa8PwHj5DAU6PUpStEq
	 ry+DchlWPFj0Z916sdLY5cO+B0fAD474muGJ/c8a6Vpv/1rpmTn9ezdSs2J9+uWIrWQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794921386;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Message-ID:MIME-Version:
	 Content-Type:Content-Transfer-Encoding:Date;
	bh=8bc0GzC6KDny6RNI/i9VATVe1CXSReqkxqM+iYLuo9I=;
	b=Q4rQr7tCuzPH7xAhPXMDXtx5gmIfzk56Tvf8Za0E4tQliPHE5wyQ8DlqO1uen5+n2iQs
	 aTFgnrTTkbPL3m3/jxoflA1ZOQ2Yvb51TK1c7fTCIN8Vz6JUw8G6jzZ6QLGAOiWKei4dT
	 KO5fF9yE11MFU5VZMH2/R0PZ7XKpU8180J+6l4/uq/DEMWUagkfQtZEW/C4/m2TTOuyQB
	 NhTSD+PMX123lWvDpb25v3ekCVSGibr+nqJQjPAVi9Mn1tZsE+QgAum9TNz/lS391nRUG
	 Tj/6zHRITdawnj0ZPq7IeUhBgJRWllgX4xJVCrr4QR2jyFGJbO8bGzIjus2gQE5k3HQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=gW8iOdhV;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with UTF8SMTPS id 9FEE2606A31C
	for <syzbot@lists.linux.dev>; Tue, 17 Nov 2026 13:16:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=gW8iOdhV
Received: by smtp.kernel.org (Postfix) with UTF8SMTPSA id 105621F000C7;
	Tue, 17 Nov 2026 13:16:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794921386;
	bh=8bc0GzC6KDny6RNI/i9VATVe1CXSReqkxqM+iYLuo9I=;
	h=From:To:Cc:Subject:Date;
	b=gW8iOdhVRTPgdWZU9mdJ0yTqxKzXWqGRegOYyng5PPin4WfBxCLythxymuLHnlaJs
	 O/ugivYfIKMjgduGQeH0V8Tig9yQejDro2fiAXvMDvKLkeAxkH9AL1kJiwECHgGc5k
	 uxSIlvz8u+T4F5IIV4FdmlXZ76SzwUIf3X97y209kSMp5Oulltr0z0mYkOxnMJOuaM
	 408Fu8kmn2/d6zhV4V/F9IF8QH9qIPzIJwVNq5Kyg55pCtjtv1STDieqNCU/JOJWpp
	 D/jwreYzZrhV+5v21/V5nwWZl2K4FTH86a6i+Q5Hdq9ZpAdf9e2OiBivFLWlgOvxTC
	 d0FvMXMlRsTuA==
From: "syzbot" <syzbot@kernel.org>
To: syzkaller-upstream-moderation@googlegroups.com
Cc: krystianmkaniewski@gmail.com, syzbot@lists.linux.dev
Subject: [PATCH RFC v4] net/x25: fix invalid lock_sock() usage in x25_kill_by_neigh()
Message-ID: <1c2f0665-0964-48f2-89f0-a4cd94a97a42@mail.kernel.org>
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
Date: Tue, 17 Nov 2026 13:16:26 +0000 (UTC)

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
v4:
- Added comments above x25_release_cb() and x25_kill_by_neigh() explaining locking and device reference handling.
- Updated commit description to clarify softirq frame delivery, device reference lifetime, and socket ownership by tasks holding lock_sock().

v3:
- Check that x25->neighbour is non-NULL in x25_release_cb() before calling x25_disconnect()
- Remove duplicate wrapped Fixes tag from the commit description
https://lore.kernel.org/all/7896865a-72bb-4375-9512-575f36952430@mail.kernel.org/T/

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
This is an AI-generated patch subject to moderation.
Reply with '#syz upstream' to Sign-off the patch as a human author
and send it to the upstream kernel mailing lists.
Reply with '#syz reject' to reject it ('#syz unreject' to undo).

See https://goo.gle/syzbot-ai-patches for information about AI-generated patches.
You can comment on the patch as usual, syzbot will try to address
the comments and send a new version of the patch if necessary.
syzbot engineers can be reached at syzkaller@googlegroups.com.
