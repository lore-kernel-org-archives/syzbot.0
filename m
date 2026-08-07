Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 987993101A7
	for <syzbot@lists.linux.dev>; Fri,  7 Aug 2026 16:36:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786120617; cv=none; b=DCDnCJXY7Y3Fgi+y4q96zGvTE2OalwKkm9ArPvdxO79YFwVQ7BsmWtHyqZelx41KFwu7cn562U+JK1DLlPkzsaKHI6vA4O9eEVag46PTYEIj8DizdTSubmXIKlW7SKaiUz3bZc5ZYD8D2ZYcMMxg241QtlJCNGCFjwwurBzyK4c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786120617; c=relaxed/simple;
	bh=xZm4t97HiL0M8PhgVh5YB7niZ/h6Haee5doKtaBei6c=;
	h=From:To:Cc:Subject:Message-ID:MIME-Version:Content-Type:Date; b=gamtKqoMTzuRaAYZRzyuc+UcZmgt8z6uSb+Od1oWQ4EigjOH8+Eq2C+ou4HlPMljdxBb75GjmKlHrUUiIpA9PNnXknS0Gu7W1W6Z5G6lZEYpyWTlR/p1O83EOurFFZV2JtPQ7ZYNoL8ImJM1ImqiXEgC8SXfga9JlKwFSA4eSAo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=bii1UlNk; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="bii1UlNk"
Received: by smtp.kernel.org (Postfix) with UTF8SMTPSA id 698611F000E9;
	Fri,  7 Aug 2026 16:36:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1786120616;
	bh=x0u0+VNEN7aYLCLGeaUsNVAh/WvE2ZqPcsWXys57zpU=;
	h=From:To:Cc:Subject:Date;
	b=bii1UlNk+sVfjzhj/zeKCnw4l4t0u6MbkpkI6w9mv5G2awPyCxcoKO0iT4m/7gn6J
	 XK53XFjslnwVpr351rTbKu2UF1rLRbad1R1OitPSYosTo3WY9O4rEtbqbAz6pWctZr
	 5dlVzj2T37Vl7b02kOSb6HE7OJ7wOBb08QZFeeQTLdHNJBmYlxIZb8m0hrorvwQjjl
	 rUA3zqB6GqZMqI1JIsv8Nk4laqVh7QdOxWf33JD3tW+gc2TXL2npmGl3WaQfxrgbf2
	 ExvwJXjUMEs88jOna2HaU+NL5/nJmxE1CrdL/jW2DHcuLpZxNK50YGJ86k8YhQAyT2
	 9sH+OIOSrnerg==
From: "syzbot" <syzbot@kernel.org>
To: syzkaller-upstream-moderation@googlegroups.com
Cc: immersa.bartosz.chronowski@gmail.com, syzbot@lists.linux.dev
Subject: [PATCH RFC v4] tipc: defer local Nagle backlog xmit from receive path
Message-ID: <ff6d3f6a-6d4e-4927-83f7-a718982a55ab@mail.kernel.org>
Precedence: bulk
X-Mailing-List: syzbot@lists.linux.dev
List-Id: <syzbot.lists.linux.dev>
List-Subscribe: <mailto:syzbot+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:syzbot+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Date: Fri,  7 Aug 2026 16:36:56 +0000 (UTC)

A local TIPC stream socket workload can trap a CPU in an endless receive
loop. The resulting soft lockup can make the system unavailable.

tipc_sk_push_backlog() can transmit delayed stream data while tipc_sk_rcv()
holds a destination socket's sk_lock.slock. Own-node transmission enters
tipc_sk_rcv() synchronously. A reply that reaches the ancestor socket
cannot acquire the still-held lock, and tipc_sk_rcv() retries without
consuming its input queue.

Pass the receive output queue to tipc_sk_push_backlog() from receive-side
callers. Queue own-node output there so the enclosing receive path sends it
after releasing the socket lock. Keep shutdown and remote-node transmission
on the existing direct path, preserving remote link congestion handling.

Fixes: c0bceb97db9e ("tipc: add smart nagle feature")
Assisted-by: Gemini:gemini-3.5-flash Gemini:gemini-3.1-pro-preview syzbot
Reported-by: syzbot+10a41dc44eef71aa9450@syzkaller.appspotmail.com
Closes: https://syzkaller.appspot.com/bug?extid=10a41dc44eef71aa9450
Link: https://syzkaller.appspot.com/ai_job?id=aa2dc129-33d3-42e7-bd0b-bf2198c9c9c2
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
v4:
- Added kernel-doc documentation for the new xmitq parameter of tipc_sk_push_backlog()

v3:
- Updated the commit subject to 'tipc: defer local Nagle backlog xmit from receive path'
- Simplified the commit description by removing the detailed eleven-step execution narrative and the full call trace.
https://lore.kernel.org/all/e5b4f184-4cf0-4891-9623-526d3dbf5a12@mail.kernel.org/T/

v2:
- Only defer transmission in tipc_sk_push_backlog() if the destination is on the own node.
- Update the commit description to clarify that deferral is only needed for own-node destinations.
https://lore.kernel.org/all/368f7232-39e9-424c-9683-0c28db1151af@mail.kernel.org/T/

v1:
https://lore.kernel.org/all/01641937-e30d-43dd-ba9c-95b3d2ae5691@mail.kernel.org/T/
---
diff --git a/net/tipc/socket.c b/net/tipc/socket.c
index e564341e0..33d744dc5 100644
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
 
@@ -1267,8 +1268,10 @@ void tipc_sk_mcast_rcv(struct net *net, struct sk_buff_head *arrvq,
 
 /* tipc_sk_push_backlog(): send accumulated buffers in socket write queue
  *                         when socket is in Nagle mode
+ * @xmitq: receive output queue, or NULL outside receive context
  */
-static void tipc_sk_push_backlog(struct tipc_sock *tsk, bool nagle_ack)
+static void tipc_sk_push_backlog(struct tipc_sock *tsk, bool nagle_ack,
+				 struct sk_buff_head *xmitq)
 {
 	struct sk_buff_head *txq = &tsk->sk.sk_write_queue;
 	struct sk_buff *skb = skb_peek_tail(txq);
@@ -1310,6 +1313,12 @@ static void tipc_sk_push_backlog(struct tipc_sock *tsk, bool nagle_ack)
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
@@ -1367,7 +1376,7 @@ static void tipc_sk_conn_proto_rcv(struct tipc_sock *tsk, struct sk_buff *skb,
 			goto exit;
 
 		was_cong = tsk_conn_cong(tsk);
-		tipc_sk_push_backlog(tsk, msg_nagle_ack(hdr));
+		tipc_sk_push_backlog(tsk, msg_nagle_ack(hdr), xmitq);
 		tsk->snt_unacked -= msg_conn_ack(hdr);
 		if (tsk->peer_caps & TIPC_BLOCK_FLOWCTL)
 			tsk->snd_win = msg_adv_win(hdr);
@@ -2165,7 +2174,7 @@ static void tipc_sk_proto_rcv(struct sock *sk,
 		smp_wmb();
 		tsk->cong_link_cnt--;
 		wakeup = true;
-		tipc_sk_push_backlog(tsk, false);
+		tipc_sk_push_backlog(tsk, false, xmitq);
 		break;
 	case GROUP_PROTOCOL:
 		tipc_group_proto_rcv(grp, &wakeup, hdr, inputq, xmitq);
@@ -2256,7 +2265,7 @@ static bool tipc_sk_filter_connect(struct tipc_sock *tsk, struct sk_buff *skb,
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
