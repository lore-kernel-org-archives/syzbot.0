Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793834824;
	b=CWsLUJrpbF+AScQMnkXeUDuAjtTbWS63rXGdtxnATy9ZlQL7cTN3Xv4wl97T8+hI/n6M
	 r8VkY4At8VwqxIR1061n9T1VCn4FA9pi4c2T/FLDDPkgaOOWsJfKOunW0b8MX7xy6Deeb
	 2TTHE36vFqQm4aRVRDtAVkXSHimV6AUs38l4Pi0o0h8e7JBRxvhQSSmAiDnl+s3lUK2ti
	 yoenKaUFIYhTr2RgvrGLFnxKOscs8uMmjeRxsnSjl8mZ/JQ1inPXTkC3FFvDMasOIFkQ8
	 EitPLiYMpSEi3iuHV7THFDcHgHeYYW5hx1kL2oXQYGsousXSvk6O5NV1rH44Zd49Cxw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793834824;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Message-ID:MIME-Version:
	 Content-Type:Content-Transfer-Encoding:Date;
	bh=IXDkiD9x/pffq6tU345sW5n+rOEppsC+GDCc/scn7sQ=;
	b=W0pN0UYqW0guQ77kF4T/UdBTQHcXnqxO0CHsBfdMppVaELzrm0F7n77SLXnqM5lIX9NO
	 +arbaOO8yXMfiE7xxMAuXgf9fWg8o7oNwld02sYMyzKK0jhk3p0FxLFnhlkRMKpnt4xCb
	 PoIBtLuZeYEW3Jmuj0Mghc5pL2AWaAUCImu5IPWImMCZQ5wBwSYjYiRFRodOZoyPalINO
	 sKAmUocRykCItFRE1lgND/oPzYXPeve1R6u7jAE6+u4wRZMPCt/OGkfZ1y3n6MJMdlsgt
	 mUQHd7rq8TCcGnvIphAFR9Q8Y/xMWero0d6GygJYv5+RptarXbdDbGD9djMlBjS7oZw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=UKTFm+JS;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with UTF8SMTPS id 299F1606A326
	for <syzbot@lists.linux.dev>; Wed,  4 Nov 2026 23:27:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=UKTFm+JS
Received: by smtp.kernel.org (Postfix) with UTF8SMTPSA id 9F2E71F000C1;
	Wed,  4 Nov 2026 23:27:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793834823;
	bh=IXDkiD9x/pffq6tU345sW5n+rOEppsC+GDCc/scn7sQ=;
	h=From:To:Cc:Subject:Date;
	b=UKTFm+JSFjcEIWm5T2/4rhBMEIUl2gUWqhRZcaOSXGsRGIwOqZoAcSaGhC2KaA6+b
	 kcdoNtVwqokm+SZu8FIVSGxU8o4k5bcjocBCICU6xYnnvDzUM7Vx4A+Ekw02MZ8qJu
	 gtbn53t+OmbZjRPxyyYvJ2/Y+Iyw3gZJazreYLa4BwYQyhQXmb9iQvBwuF8YrT+V5A
	 bbOPGEsypvPQKjkduOqVluDx5IKeUGJCMkDxuNj2XT2s4RDERJ8sob22Z3+mJBw5TO
	 7fU6YeB0Sy9RDHRY+0/AdmJjen1VqeppfY1DIBIE7OTzfDO2A4rGboVMPppRLt5olE
	 mKNW8hFrCWNxw==
From: "syzbot" <syzbot@kernel.org>
To: syzkaller-upstream-moderation@googlegroups.com
Cc: syzbot@lists.linux.dev
Subject: [PATCH RFC] net/x25: fix invalid lock_sock() usage in x25_kill_by_neigh()
Message-ID: <f1cbebc5-aab9-44ac-8425-1bc9fdbbf5b7@mail.kernel.org>
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
Date: Wed,  4 Nov 2026 23:27:03 +0000 (UTC)

x25_kill_by_neigh() is invoked to tear down X.25 sockets associated with a
terminating neighbour. This function is called in process context from
netdevice notifier handlers (such as NETDEV_DOWN in x25_device_event()),
but it is also called in softirq context (NET_RX_SOFTIRQ) under
rcu_read_lock() when receiving LAPB frames in x25_lapb_receive_frame() (for
instance upon receiving an X25_IFACE_DISCONNECT frame or restart
request/confirm packets via lapbeth_napi_poll() ->
netif_receive_skb_core()).

x25_kill_by_neigh() acquires lock_sock(s) around x25_disconnect(). Because
lock_sock() is a sleeping lock that can block in process context and calls
might_sleep(), calling it from softirq context triggers a "BUG: sleeping
function called from invalid context". Furthermore, lockdep reports an
inconsistent lock state warning ({SOFTIRQ-ON-W} -> {IN-SOFTIRQ-W}) on
sk_lock-AF_X25 because the socket lock is normally acquired with softirqs
enabled in process context (e.g. in x25_bind()), creating a deadlock hazard
if a softirq interrupts a task holding lock_sock().

WARNING: inconsistent lock state
inconsistent {SOFTIRQ-ON-W} -> {IN-SOFTIRQ-W} usage.
swapper/0/0 [HC0[0]:SC1[1]:HE1:SE0] takes:
ffff888030a28260 (sk_lock-AF_X25){+.?.}-{0:0}, at:
x25_kill_by_neigh+0x10d/0x250 net/x25/af_x25.c:1775
{SOFTIRQ-ON-W} state was registered at:
  lock_acquire+0x115/0x350 kernel/locking/lockdep.c:5942
  lock_sock_nested+0x41/0x100 net/core/sock.c:3908
  x25_bind+0x209/0x450 net/x25/af_x25.c:691
...
Call Trace:
 <IRQ>
 dump_stack_lvl+0xe8/0x150 lib/dump_stack.c:120
 print_usage_bug+0x28c/0x2e0 kernel/locking/lockdep.c:4086
 mark_lock_irq+0x36/0x380 kernel/locking/lockdep.c:4311
 __lock_acquire+0x71e/0x2de0 kernel/locking/lockdep.c:5242
 lock_acquire+0x115/0x350 kernel/locking/lockdep.c:5942
 lock_sock_nested+0x41/0x100 net/core/sock.c:3908
 x25_kill_by_neigh+0x10d/0x250 net/x25/af_x25.c:1775
 x25_lapb_receive_frame+0x1b0/0xf90 net/x25/x25_dev.c:138
 netif_receive_skb_core+0x2a6/0x2b0 net/core/dev.c:6458
 lapbeth_napi_poll+0x42/0x90 drivers/net/wan/lapbether.c:100
...
 </IRQ>

BUG: sleeping function called from invalid context at net/core/sock.c:3910
in_atomic(): 1, irqs_disabled(): 0, non_block: 0, pid: 0, name: swapper/0
preempt_count: 101, expected: 0
RCU nest depth: 1, expected: 0
Call Trace:
 <IRQ>
 dump_stack_lvl+0xe8/0x150 lib/dump_stack.c:120
 __might_resched+0x36a/0x4c0 kernel/sched/core.c:9195
 lock_sock_nested+0x56/0x100 net/core/sock.c:3910
 x25_kill_by_neigh+0x10d/0x250 net/x25/af_x25.c:1775
 x25_lapb_receive_frame+0x1b0/0xf90 net/x25/x25_dev.c:138
 netif_receive_skb_core+0x2a6/0x2b0 net/core/dev.c:6458
 lapbeth_napi_poll+0x42/0x90 drivers/net/wan/lapbether.c:100
...
 </IRQ>

Fix the issue by replacing lock_sock() / release_sock() in
x25_kill_by_neigh() with bh_lock_sock() / bh_unlock_sock(). Disable bottom
halves around the list traversal with local_bh_disable() /
local_bh_enable() and use write_lock() / write_unlock() on x25_list_lock so
that bottom halves remain disabled across bh_lock_sock() even when called
from process context, preventing lockdep warnings on slock-AF_X25. Release
x25_list_lock before acquiring bh_lock_sock() to respect existing lock
ordering.

If the socket is owned by a user process (sock_owned_by_user(s)),
disconnect cannot proceed immediately under bh_lock_sock(). Set a new
X25_KILL_BY_NEIGH_FLAG flag on the socket and implement x25_release_cb() in
x25_proto so that the disconnect is deferred until release_sock() is called
by the user process. Skip sockets with X25_KILL_BY_NEIGH_FLAG set in
x25_kill_by_neigh() to prevent spinning on user-owned sockets when
restarting the list walk. Finally, clear X25_KILL_BY_NEIGH_FLAG in
x25_disconnect(), x25_make_new(), and the error path of x25_connect().

Fixes: 7781607938c8 ("net/x25: Fix null-ptr-deref caused by
x25_disconnect")

Fixes: 7781607938c8 ("net/x25: Fix null-ptr-deref caused by x25_disconnect")
Assisted-by: Gemini:gemini-4-argon Gemini:gemini-3.8-flash syzbot
Reported-by: syzbot+300375dfd44665f063a6@syzkaller.appspotmail.com
Closes: https://syzkaller.appspot.com/bug?extid=300375dfd44665f063a6
Link: https://syzkaller.appspot.com/ai_job?id=3a4b062a-3ad2-4806-a87d-55983041acda
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
diff --git a/include/net/x25.h b/include/net/x25.h
index 414f3fd99..c271fc2a7 100644
--- a/include/net/x25.h
+++ b/include/net/x25.h
@@ -118,6 +118,7 @@ enum {
 #define X25_Q_BIT_FLAG		0
 #define X25_INTERRUPT_FLAG	1
 #define X25_ACCPT_APPRV_FLAG	2
+#define X25_KILL_BY_NEIGH_FLAG	3
 
 /**
  *	struct x25_route - x25 routing entry
diff --git a/net/x25/af_x25.c b/net/x25/af_x25.c
index f45c9ec7d..e24900a75 100644
--- a/net/x25/af_x25.c
+++ b/net/x25/af_x25.c
@@ -492,10 +492,17 @@ static int x25_listen(struct socket *sock, int backlog)
 	return rc;
 }
 
+static void x25_release_cb(struct sock *sk)
+{
+	if (test_and_clear_bit(X25_KILL_BY_NEIGH_FLAG, &x25_sk(sk)->flags))
+		x25_disconnect(sk, ENETUNREACH, 0, 0);
+}
+
 static struct proto x25_proto = {
-	.name	  = "X25",
-	.owner	  = THIS_MODULE,
-	.obj_size = sizeof(struct x25_sock),
+	.name	    = "X25",
+	.owner	    = THIS_MODULE,
+	.obj_size   = sizeof(struct x25_sock),
+	.release_cb = x25_release_cb,
 };
 
 static struct sock *x25_alloc_socket(struct net *net, int kern)
@@ -610,6 +617,7 @@ static struct sock *x25_make_new(struct sock *osk)
 	x25->cudmatchlength = ox25->cudmatchlength;
 
 	clear_bit(X25_INTERRUPT_FLAG, &x25->flags);
+	clear_bit(X25_KILL_BY_NEIGH_FLAG, &x25->flags);
 	x25_init_timers(sk);
 out:
 	return sk;
@@ -827,6 +835,7 @@ static int x25_connect(struct socket *sock, struct sockaddr_unsized *uaddr,
 		x25->neighbour = NULL;
 		read_unlock_bh(&x25_list_lock);
 		x25->state = X25_STATE_0;
+		clear_bit(X25_KILL_BY_NEIGH_FLAG, &x25->flags);
 	}
 out_put_route:
 	x25_route_put(rt);
@@ -1765,22 +1774,30 @@ void x25_kill_by_neigh(struct x25_neigh *nb)
 {
 	struct sock *s;
 
+	local_bh_disable();
 again:
-	write_lock_bh(&x25_list_lock);
+	write_lock(&x25_list_lock);
 
 	sk_for_each(s, &x25_list) {
-		if (x25_sk(s)->neighbour == nb) {
+		if (x25_sk(s)->neighbour == nb &&
+		    !test_bit(X25_KILL_BY_NEIGH_FLAG, &x25_sk(s)->flags)) {
 			sock_hold(s);
-			write_unlock_bh(&x25_list_lock);
-			lock_sock(s);
-			if (x25_sk(s)->neighbour == nb)
-				x25_disconnect(s, ENETUNREACH, 0, 0);
-			release_sock(s);
+			write_unlock(&x25_list_lock);
+			bh_lock_sock(s);
+			if (x25_sk(s)->neighbour == nb) {
+				if (sock_owned_by_user(s))
+					set_bit(X25_KILL_BY_NEIGH_FLAG,
+						&x25_sk(s)->flags);
+				else
+					x25_disconnect(s, ENETUNREACH, 0, 0);
+			}
+			bh_unlock_sock(s);
 			sock_put(s);
 			goto again;
 		}
 	}
-	write_unlock_bh(&x25_list_lock);
+	write_unlock(&x25_list_lock);
+	local_bh_enable();
 
 	/* Remove any related forwards */
 	x25_clear_forward_by_dev(nb->dev);
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
