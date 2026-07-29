Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 112A4469832
	for <syzbot@lists.linux.dev>; Wed, 29 Jul 2026 16:54:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785344069; cv=none; b=cKSrPElVuQkmXp4bnSeMDRdVEpwPcuBPcAsetugks6o9l5jqrmLFoHDlifuPvS4vWeAPYl/lOKnyNouz7PF6ztStyrwjj20slXBTMnHF/CM9Xo+t08d9RUKznxZKvr75jSiR2BFZkL8wyvxjJ8lKlJl8GaAsc5i/w6Qm0LnPaUM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785344069; c=relaxed/simple;
	bh=kisaunHPSglLtCTilq7dG7n3cHMylY2xkqAc+GFOoTw=;
	h=From:To:Cc:Subject:Message-ID:MIME-Version:Content-Type:Date; b=V0SNpx8HLQM3ON7VIve2ZzFr+CS9umPz3zjS+UI2gnUUpXiOxZKW80Xeys+5Ln+OI7slb2zYRig67lOeEX9Z4uL0DBrZnWHYJnGirA0t8x/St5HXp8+Prjk1q0Y1Wc2S2+Qis8Pfn/MCoQ0V1mFmypaC5aHwdKZj/PlQk6KdoZk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=DBnJHIgN; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="DBnJHIgN"
Received: by smtp.kernel.org (Postfix) with UTF8SMTPSA id 860191F000E9;
	Wed, 29 Jul 2026 16:54:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1785344067;
	bh=GuLY3i6SBJtad/FSiPC4s2VbXEQPIiWOVbN2GgWcuQE=;
	h=From:To:Cc:Subject:Date;
	b=DBnJHIgNQ2V882tcgl9N8T3XktvnVfOXDEvthbsRKp9o9bVeWJjTn2zroR7EIS85M
	 9xXuk4NKodXiC3L05zwlk+ByQtu8chddCiljEezZCKca1t/r8MXK9cefqPdyTrWBuc
	 /zryTFubGVemhXhQpGWUCeK8C8IFbcTzOCrDTLiM/1bBPaYuzPcNnbtDxbIxw+htj6
	 jApE7U4MFKJ1LgTAxJUhXPAnpu3TIZSxprk1JrflKuqNL71Xu3hSSJnyUZoiKejQsN
	 dYe5IphxlX3XkrQnIZ7dS7FNS5jnrIMauJ9w/gXlfTp1kGZnUI5unxAjwqa9ZlLxqs
	 /8u/Oycgn7+jQ==
From: "syzbot" <syzbot@kernel.org>
To: syzkaller-upstream-moderation@googlegroups.com
Cc: immersa.bartosz.chronowski@gmail.com, syzbot@lists.linux.dev
Subject: [PATCH RFC v2] tipc: fix spinlock recursion in tipc_sk_rcv()
Message-ID: <368f7232-39e9-424c-9683-0c28db1151af@mail.kernel.org>
Precedence: bulk
X-Mailing-List: syzbot@lists.linux.dev
List-Id: <syzbot.lists.linux.dev>
List-Subscribe: <mailto:syzbot+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:syzbot+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Date: Wed, 29 Jul 2026 16:54:27 +0000 (UTC)

An RCU stall (infinite loop / livelock) can occur due to a spinlock
recursion bug in the TIPC subsystem. Specifically, tipc_sk_rcv() can be
called recursively on the same CPU and try to acquire a socket spinlock
that is already held higher up in the call stack. Because it uses
spin_trylock_bh(), it fails to acquire the lock and enters an infinite
loop.

The issue is triggered by the concurrent execution of sendmsg() and
setsockopt() on a connected TIPC socket pair (fd0 and fd1), which reside on
the same node (loopback).

The sequence of events leading to the livelock is:
1. setsockopt locks fd0 (acquires the socket mutex sk->sk_lock.owned).
While fd0 is locked, sendmsg on fd1 sends messages to fd0. Since fd0 is
owned by the user, tipc_sk_enqueue() adds these messages to fd0's backlog
queue.
2. setsockopt processes SO_RCVBUFFORCE and reduces fd0's sk_rcvbuf to the
minimum value (SOCK_MIN_RCVBUF, 2048).
3. setsockopt finishes and calls release_sock(fd0). Seeing a non-empty
backlog, it calls __release_sock(fd0).
4. __release_sock(fd0) drops fd0's spinlock (sk->sk_lock.slock) and calls
sk_backlog_rcv() -> tipc_sk_backlog_rcv() -> tipc_sk_filter_rcv() to
process the backlog.
5. Because sk_rcvbuf was drastically reduced, the receive queue limit is
exceeded. tipc_sk_filter_rcv(fd0) rejects the message (TIPC_ERR_OVERLOAD)
and queues a reject message to xmitq.
6. tipc_sk_backlog_rcv(fd0) calls tipc_node_distr_xmit(&xmitq) to send the
reject message back to fd1. Since fd1 is on the same node, tipc_node_xmit()
synchronously calls tipc_sk_rcv(fd1).
7. tipc_sk_rcv(fd1) successfully locks fd1's spinlock and calls
tipc_sk_enqueue(fd1) -> tipc_sk_filter_rcv(fd1) ->
tipc_sk_filter_connect(fd1).
8. tipc_sk_filter_connect(fd1) sees that fd1's sk_write_queue is not empty.
It calls tipc_sk_push_backlog(fd1).
9. tipc_sk_push_backlog(fd1) calls tipc_node_xmit() to send the queued
messages to fd0. This synchronously calls tipc_sk_rcv(fd0).
10. tipc_sk_rcv(fd0) successfully locks fd0's spinlock (as __release_sock
dropped it) and calls tipc_sk_enqueue(fd0). Since fd0 is still owned by the
user, it tries to add the message to the backlog. The backlog is full, so
it rejects the message again, sending a new reject message back to fd1.
11. The new reject message is sent to fd1 via tipc_node_xmit() ->
tipc_sk_rcv(fd1). tipc_sk_rcv(fd1) tries to lock fd1's spinlock. However,
fd1's spinlock is already held by the outer tipc_sk_rcv(fd1) at step 7.

In tipc_sk_rcv(), if spin_trylock_bh() fails, it assumes another CPU holds
the lock, so it just continues the loop without dequeuing the message from
inputq. Because the lock is held by the current CPU, it will never be
released, and the while loop spins infinitely, causing the RCU stall:

rcu: INFO: rcu_preempt self-detected stall on CPU
...
Call Trace:
 <TASK>
 __raw_spin_trylock_bh include/linux/spinlock_api_smp.h:207 [inline]
 _raw_spin_trylock_bh+0x60/0x70 kernel/locking/spinlock.c:150
 spin_trylock_bh include/linux/spinlock.h:414 [inline]
 tipc_sk_rcv+0x420/0x2b50 net/tipc/socket.c:2500
 tipc_node_xmit+0x205/0xf10 net/tipc/node.c:1701
 tipc_node_xmit_skb net/tipc/node.c:1766 [inline]
 tipc_node_distr_xmit+0x2cd/0x400 net/tipc/node.c:1781
 tipc_sk_rcv+0x2539/0x2b50 net/tipc/socket.c:2505
 tipc_node_xmit+0x205/0xf10 net/tipc/node.c:1701
 tipc_sk_push_backlog net/tipc/socket.c:1313 [inline]
 tipc_sk_filter_connect net/tipc/socket.c:2259 [inline]
 tipc_sk_filter_rcv+0x17f3/0x3210 net/tipc/socket.c:2368
 tipc_sk_enqueue net/tipc/socket.c:2449 [inline]
 tipc_sk_rcv+0x877/0x2b50 net/tipc/socket.c:2501
 tipc_node_xmit+0x205/0xf10 net/tipc/node.c:1701
 tipc_node_xmit_skb net/tipc/node.c:1766 [inline]
 tipc_node_distr_xmit+0x2cd/0x400 net/tipc/node.c:1781
 tipc_sk_backlog_rcv+0x1ad/0x270 net/tipc/socket.c:2416
 sk_backlog_rcv include/net/sock.h:1190 [inline]
 __release_sock+0x28b/0x390 net/core/sock.c:3261
 release_sock+0x190/0x260 net/core/sock.c:3860
 sockopt_release_sock net/core/sock.c:1163 [inline]
 sk_setsockopt+0x2822/0x2e80 net/core/sock.c:1681
 do_sock_setsockopt+0x11b/0x1b0 net/socket.c:2364
 __sys_setsockopt net/socket.c:2393 [inline]
 __do_sys_setsockopt net/socket.c:2399 [inline]
 __se_sys_setsockopt net/socket.c:2396 [inline]
 __x64_sys_setsockopt+0x13d/0x1b0 net/socket.c:2396
 do_syscall_x64 arch/x86/entry/syscall_64.c:63 [inline]
 do_syscall_64+0x15f/0x560 arch/x86/entry/syscall_64.c:94
 entry_SYSCALL_64_after_hwframe+0x77/0x7f
 </TASK>

To fix this, tipc_sk_push_backlog() should not call tipc_node_xmit()
directly for own-node destinations while holding the socket spinlock.
Instead, modify tipc_sk_push_backlog() to take an xmitq parameter. If xmitq
is provided and the destination is on the own node, it splices the write
queue into xmitq, deferring the transmission until after the spinlock is
released. For calls like __tipc_shutdown() that execute under the socket
mutex rather than the spinlock, passing NULL for xmitq allows direct
transmission to continue safely. For off-node destinations, direct
transmission remains safe as it does not lead to synchronous loopback
recursion.

Fixes: c0bceb97db9e ("tipc: add smart nagle feature")
Assisted-by: Gemini:gemini-3.5-flash Gemini:gemini-3.1-pro-preview syzbot
Reported-by: syzbot+10a41dc44eef71aa9450@syzkaller.appspotmail.com
Closes: https://syzkaller.appspot.com/bug?extid=10a41dc44eef71aa9450
Link: https://syzkaller.appspot.com/ai_job?id=e6db6744-c061-4f81-bde8-25993166f061
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
v2:
- Only defer transmission in tipc_sk_push_backlog() if the destination is on the own node.
- Update the commit description to clarify that deferral is only needed for own-node destinations.

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
You can comment on the patch as usual, syzbot will try to address
the comments and send a new version of the patch if necessary.
syzbot engineers can be reached at syzkaller@googlegroups.com.
