Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ED74841A57E
	for <syzbot@lists.linux.dev>; Fri,  7 Aug 2026 10:10:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786097458; cv=none; b=r7vu6AVKfH8KeBG/AZNixJg7usCig2n1BH0WIscE460QesArLW6bPbyeM+jytNpJ6YKI0CgMxFB9PjkDgkM/rnBra1Lx54e0lwGYl8BZB2rfZgb25m6axKi4nCXtqBbyvU7HGQsz9RrvJvA7IiqibK7Xg7jql0uUV6UNhdAfCcA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786097458; c=relaxed/simple;
	bh=LhQSifobOBjJuQjJBlvWgJ8ZU6O9R8XF5Ec+r177Uj0=;
	h=From:To:Cc:Subject:Message-ID:MIME-Version:Content-Type:Date; b=IP2tS7csDIOxxZKpr3cyASrfbb+5JTGK9RKIctOfdbO8B5w6iKYws1pIAtiQNdd2Rdd0JzfK1GFqPReXbpCCxB6py7QhVpZOaKW+8Ptspd3fn4swa0LtTGymzXIQ1AtNIKSP0VZpm2tFGfBJRQyL8dmA1S2mRtDnfrbsVDP63pc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=IipyYia8; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="IipyYia8"
Received: by smtp.kernel.org (Postfix) with UTF8SMTPSA id 5CC1E1F000E9;
	Fri,  7 Aug 2026 10:10:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1786097456;
	bh=C+0HShQdg5bm6HsuPwRfGIA7hRMpYF3ahqj2L1O+9Q8=;
	h=From:To:Cc:Subject:Date;
	b=IipyYia8KQWUGNd6bGiQ+N7aqcWNMrTkl91AIplf/XSpiGyAO/2nIKyP+iWj81Kry
	 o+96zz0lyAXDA6INsjOXTrCwCTaJYc/NLX0xPJJoauNZ7clW6RmKLxGR3tOBekIip3
	 pUekx5yDMIaSbjt3o4alXtDHM9+yQrAmFIPuQvwbO+SXLMYX42Aky0jtLDb38cgNIY
	 jVXbJ4L2jvsBcfiTbigWTDxmPi216ohQmCMhTL7nz3C1sq39cOlRuE6hUpK2z0V8HV
	 UTc8N0eUJCeLejcj8jVyOe0tH04IfjWrN90O3HKRvDrksjkY7DUGd+qVnSKOVdkggL
	 f2dY94QUELQNw==
From: "syzbot" <syzbot@kernel.org>
To: syzkaller-upstream-moderation@googlegroups.com
Cc: immersa.bartosz.chronowski@gmail.com, syzbot@lists.linux.dev
Subject: [PATCH RFC v3] tipc: defer local Nagle backlog xmit from receive path
Message-ID: <e5b4f184-4cf0-4891-9623-526d3dbf5a12@mail.kernel.org>
Precedence: bulk
X-Mailing-List: syzbot@lists.linux.dev
List-Id: <syzbot.lists.linux.dev>
List-Subscribe: <mailto:syzbot+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:syzbot+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Date: Fri,  7 Aug 2026 10:10:56 +0000 (UTC)

An RCU stall can occur due to a spinlock recursion bug in the TIPC
subsystem. When tipc_sk_rcv() is called recursively on the same CPU, it
tries to acquire a socket spinlock that is already held higher up in the
call stack. Because it uses spin_trylock_bh(), it fails to acquire the lock
and enters an infinite loop.

To fix this, modify tipc_sk_push_backlog() to take an xmitq parameter. If
xmitq is provided and the destination is on the own node, splice the write
queue into xmitq, deferring the transmission until after the spinlock is
released. For calls like __tipc_shutdown() that execute under the socket
mutex rather than the spinlock, passing NULL for xmitq allows direct
transmission to continue safely.

Fixes: c0bceb97db9e ("tipc: add smart nagle feature")
Assisted-by: Gemini:gemini-3.5-flash Gemini:gemini-3.1-pro-preview syzbot
Reported-by: syzbot+10a41dc44eef71aa9450@syzkaller.appspotmail.com
Closes: https://syzkaller.appspot.com/bug?extid=10a41dc44eef71aa9450
Link: https://syzkaller.appspot.com/ai_job?id=3b51a2d9-6039-4d50-b8fe-9bd92fe8a3f1
To: "David S. Miller" <davem@davemloft.net>
To: "Eric Dumazet" <edumazet@google.com>
To: "Jon Maloy" <jmaloy@redhat.com>
To: "Jakub Kicinski" <kuba@kernel.org>
To: <netdev@vger.kernel.org>
To: "Paolo Abeni" <pabeni@redhat.com>
To: <tipc-discussion@lists.sourceforge.net>
To: "Jon Maloy" <jon.maloy@ericsson.com>
Cc: "Simon Horman" <horms@kernel.org>
Cc: <linux-kernel@vger.kernel.org>

---
v3:
- Updated the commit subject to 'tipc: defer local Nagle backlog xmit from receive path'
- Simplified the commit description by removing the detailed eleven-step execution narrative and the full call trace.

v2:
- Only defer transmission in tipc_sk_push_backlog() if the destination is on the own node.
- Update the commit description to clarify that deferral is only needed for own-node destinations.
https://lore.kernel.org/all/368f7232-39e9-424c-9683-0c28db1151af@mail.kernel.org/T/

v1:
https://lore.kernel.org/all/01641937-e30d-43dd-ba9c-95b3d2ae5691@mail.kernel.org/T/
---
diff --git a/net/tipc/socket.c b/net/tipc/socket.c
index e564341e0..16d844fc8 100644
--- a/net/tipc/socket.c
+++ b/net/tipc/socket.c
@@ -156,7 +156,8 @@ static int tipc_sk_insert(struct tipc_sock *tsk);
 static void tipc_sk_remove(struct tipc_sock *tsk);
 static int __tipc_sendstream(struct socket *sock, struct msghdr *m, size_t dsz);
 static int __tipc_sendmsg(struct socket *sock, struct msghdr *m, size_t dsz);
-static void tipc_sk_push_backlog(struct tipc_sock *tsk, bool nagle_ack);
+static void tipc_sk_push_backlog(struct tipc_sock *tsk, bool nagle_ack,
+				 struct sk_buff_head *xmitq);
 static int tipc_wait_for_connect(struct socket *sock, long *timeo_p);
 
 static const struct proto_ops packet_ops;
@@ -560,7 +561,7 @@ static void __tipc_shutdown(struct socket *sock, int error)
 					    !tsk_conn_cong(tsk)));
 
 	/* Push out delayed messages if in Nagle mode */
-	tipc_sk_push_backlog(tsk, false);
+	tipc_sk_push_backlog(tsk, false, NULL);
 	/* Remove pending SYN */
 	__skb_queue_purge(&sk->sk_write_queue);
 
@@ -1268,7 +1269,8 @@ void tipc_sk_mcast_rcv(struct net *net, struct sk_buff_head *arrvq,
 /* tipc_sk_push_backlog(): send accumulated buffers in socket write queue
  *                         when socket is in Nagle mode
  */
-static void tipc_sk_push_backlog(struct tipc_sock *tsk, bool nagle_ack)
+static void tipc_sk_push_backlog(struct tipc_sock *tsk, bool nagle_ack,
+				 struct sk_buff_head *xmitq)
 {
 	struct sk_buff_head *txq = &tsk->sk.sk_write_queue;
 	struct sk_buff *skb = skb_peek_tail(txq);
@@ -1310,6 +1312,12 @@ static void tipc_sk_push_backlog(struct tipc_sock *tsk, bool nagle_ack)
 		tsk->pkt_cnt += skb_queue_len(txq);
 	tsk->snt_unacked += tsk->snd_backlog;
 	tsk->snd_backlog = 0;
+
+	if (xmitq && in_own_node(net, dnode)) {
+		skb_queue_splice_tail_init(txq, xmitq);
+		return;
+	}
+
 	rc = tipc_node_xmit(net, txq, dnode, tsk->portid);
 	if (rc == -ELINKCONG)
 		tsk->cong_link_cnt = 1;
@@ -1367,7 +1375,7 @@ static void tipc_sk_conn_proto_rcv(struct tipc_sock *tsk, struct sk_buff *skb,
 			goto exit;
 
 		was_cong = tsk_conn_cong(tsk);
-		tipc_sk_push_backlog(tsk, msg_nagle_ack(hdr));
+		tipc_sk_push_backlog(tsk, msg_nagle_ack(hdr), xmitq);
 		tsk->snt_unacked -= msg_conn_ack(hdr);
 		if (tsk->peer_caps & TIPC_BLOCK_FLOWCTL)
 			tsk->snd_win = msg_adv_win(hdr);
@@ -2165,7 +2173,7 @@ static void tipc_sk_proto_rcv(struct sock *sk,
 		smp_wmb();
 		tsk->cong_link_cnt--;
 		wakeup = true;
-		tipc_sk_push_backlog(tsk, false);
+		tipc_sk_push_backlog(tsk, false, xmitq);
 		break;
 	case GROUP_PROTOCOL:
 		tipc_group_proto_rcv(grp, &wakeup, hdr, inputq, xmitq);
@@ -2256,7 +2264,7 @@ static bool tipc_sk_filter_connect(struct tipc_sock *tsk, struct sk_buff *skb,
 		return false;
 	case TIPC_ESTABLISHED:
 		if (!skb_queue_empty(&sk->sk_write_queue))
-			tipc_sk_push_backlog(tsk, false);
+			tipc_sk_push_backlog(tsk, false, xmitq);
 		/* Accept only connection-based messages sent by peer */
 		if (likely(con_msg && !err && pport == oport &&
 			   pnode == onode)) {


base-commit: 1590cf0329716306e948a8fc29f1d3ee87d3989f
-- 
This is an AI-generated patch subject to moderation.
Reply with '#syz upstream' to Sign-off the patch as a human author
and send it to the upstream kernel mailing lists.
Reply with '#syz reject' to reject it ('#syz unreject' to undo).

See https://goo.gle/syzbot-ai-patches for information about AI-generated patches.
The person who has signed off on the patch is responsible for
addressing comments.
syzbot engineers can be reached at syzkaller@googlegroups.com.
