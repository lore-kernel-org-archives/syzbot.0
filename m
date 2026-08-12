Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9708537DEB2;
	Wed, 12 Aug 2026 13:00:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786539652; cv=none; b=rxJNNMJjSE0b5rQSs52JKPU5vvpt+0teWRHFPACPkaMfFBm4XaCAW5lsJXOOgW5flhtdeSFCWOw5tSq9HTmxwe9ytHj20LsOcITPYnHMDrj5+dtMTMQVgEwmDhdI5oj++tVO0Sow1wpQlw+6RkmhzTKmwD6rjKWNjWudDeqU3NA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786539652; c=relaxed/simple;
	bh=4pjMjnsZ/Qg8UECl5JV/JuhAkm7WItCwqnxb6uvtkiE=;
	h=From:To:Cc:Subject:Message-ID:MIME-Version:Content-Type:Date; b=UUyI7m6FEMkVjtkKraSQZH8LWamS/qHElRcIVZ0n3KpHGCoyOljFw6+XSbr+WWrSI+Lo20inxzEZ4g45GeIF4HOc4t5gwK0LbEEu0lLHAS6fnp4VPAgDQw9EejxzDup3nm3P2oDaDzuyCkjjHd82EX1znr4p0Ibfr/3Cy0w7tfY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=FffySGyI; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="FffySGyI"
Received: by smtp.kernel.org (Postfix) with UTF8SMTPSA id A369F1F000E9;
	Wed, 12 Aug 2026 13:00:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1786539650;
	bh=NCMu+3q6YqqfW/6i+2U7S5vjkRbRMUU/YnD76ftW5kE=;
	h=From:To:Cc:Subject:Date;
	b=FffySGyIkheIIY5iCzMVLN0vx+sHolvNa635JAKF2+bIWfxNLYCnM5N6/t/zVmXrl
	 P4FjxcPqEim5FJKdPZOp30+abkN9Bc58mcaBpFGdvONu7SMxZn+lrHJALgtDU0n5bL
	 f3noR1SgFB30WibD2n6yQgiOcfrWU3SBHbfbCUtplA0fqDUtEWycIYKUXy1N9SBjXF
	 TeYmL9X7HgOhMvlW607O4FVi/wOeRB0v6iyrQuyYyJ58dqBDe5QBtPk0CrGywRRncp
	 jY1zIZvQy7RxK+mdEDFJYpAe4KST0BGSJdnRPaYhkXk8ElABXRGUJ05pt4d/EmCMlx
	 vYjT61zJKXSdA==
From: "syzbot" <syzbot@kernel.org>
To: syzkaller-bugs@googlegroups.com, Bartosz Chronowski <immersa.bartosz.chronowski@gmail.com>, "David S. Miller" <davem@davemloft.net>, "Eric Dumazet" <edumazet@google.com>, "Jon Maloy" <jmaloy@redhat.com>, "Jakub Kicinski" <kuba@kernel.org>, <netdev@vger.kernel.org>, "Paolo Abeni" <pabeni@redhat.com>, <tipc-discussion@lists.sourceforge.net>, "Jon Maloy" <jon.maloy@ericsson.com>
Cc: horms@kernel.org, linux-kernel@vger.kernel.org, syzbot@lists.linux.dev
Subject: [PATCH] tipc: defer local Nagle backlog xmit from receive path
Message-ID: <631b75b4-d1e3-40ea-a129-5ed090f914bf@mail.kernel.org>
Precedence: bulk
X-Mailing-List: syzbot@lists.linux.dev
List-Id: <syzbot.lists.linux.dev>
List-Subscribe: <mailto:syzbot+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:syzbot+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Date: Wed, 12 Aug 2026 13:00:49 +0000 (UTC)

From: Bartosz Chronowski <immersa.bartosz.chronowski@gmail.com>

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
Signed-off-by: Bartosz Chronowski <immersa.bartosz.chronowski@gmail.com>

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
See https://goo.gle/syzbot-ai-patches for information about AI-generated patches.
The person who has signed off on the patch is responsible for
addressing comments.
syzbot engineers can be reached at syzkaller@googlegroups.com.
