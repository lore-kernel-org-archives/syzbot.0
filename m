Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E394534F24A
	for <syzbot@lists.linux.dev>; Wed, 13 May 2026 19:53:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778701990; cv=none; b=qx0BqeB4pcBuSXEFFoyOUScNgFmoONU9m+RoItiO60j0OxktZJI2/c642D8LRVu/6zEKWkxjhtdhukKJ1yc9POdAKTG3gEdSz/DHc+OwYkLtpGHmtWDQHRqn7jwNPya9F0PBJZFkA+PzOns9IHXG8bcMdW69jKqrth7oKH+a6j0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778701990; c=relaxed/simple;
	bh=pMShIKgLLIrgDDk1D8HnHcgit4owowEyVf/ooaPBjyo=;
	h=From:To:Cc:Subject:Message-ID:MIME-Version:Content-Type:Date; b=dcKzxifPpxdmIzjHuwrO46tVBdfqOP8bebsxtmoM9QLFfMAQ4fXtzU/hoYDp7RV7HKGpRLcDSRw3em/mjsWswEFpqPjo+vNtvhuMv6lbTasdmehOaWJ9ZloROzX87UecEeOy6buH6wNHmOhVTabrKS1ay0MsVi4qQ+/pmIXnhcs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=G3hPtxez; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="G3hPtxez"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B59D9C19425;
	Wed, 13 May 2026 19:53:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1778701989;
	bh=pMShIKgLLIrgDDk1D8HnHcgit4owowEyVf/ooaPBjyo=;
	h=From:To:Cc:Subject:Date:From;
	b=G3hPtxezak6LgfS86qCf8GNY0M+qe95AtBid1Uz2ElQy025UmXzJarGfgdSL8A4UQ
	 epiMD/bDFUq1RBTDJYvwtE94ASE1L4o9vVTkkAB14XSZ60Me2bWAiRj5mXVnHiRqCe
	 01RmjmgsinjjHG263EGzvIAkIv8Xlpc0s2cE6w6Cew73Ryj7YOYdBCNjSul6ciEZz8
	 cg2RqrYMJalMhaU3DAqltvxgWSwpsa6zpX9JQdBXIa4EbZc/x5tU0OWDqMBTJihJPR
	 7OodngmzqfcJbJSg9rdHkK5ggNQcB8hm1NsXM4uHc/rNe+1l0vk0Nai9AmJWCrcHVy
	 yxqWbvrWbvxFg==
From: "syzbot" <syzbot@kernel.org>
To: syzkaller-upstream-moderation@googlegroups.com
Cc: syzbot@lists.linux.dev
Subject: [PATCH RFC] Bluetooth: L2CAP: Fix use-after-free in l2cap_conn_ready
Message-ID: <80b4403f-02ff-4ff9-8209-80d0059665dc@mail.kernel.org>
Precedence: bulk
X-Mailing-List: syzbot@lists.linux.dev
List-Id: <syzbot.lists.linux.dev>
List-Subscribe: <mailto:syzbot+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:syzbot+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Date: Wed, 13 May 2026 19:53:09 +0000 (UTC)

An analysis of the crash report and the kernel source code reveals a
race condition leading to a use-after-free bug in the Bluetooth L2CAP
core.

The crash occurs in l2cap_conn_ready() when it iterates over the
conn->chan_l list. This list is protected by conn->lock, and
l2cap_conn_ready() correctly acquires mutex_lock(&conn->lock) before
iterating over it using list_for_each_entry().

However, a concurrent thread can close the listening socket, which
triggers l2cap_sock_release() -> l2cap_sock_cleanup_listen().
l2cap_sock_cleanup_listen() iterates over the unaccepted sockets in the
accept queue, dequeues them, and calls l2cap_chan_close(chan,
ECONNRESET).

For a channel that has already been associated with a connection,
chan->conn is set and the channel is linked into conn->chan_l. When
l2cap_chan_close() is called for such a channel, it eventually calls
l2cap_chan_del(). l2cap_chan_del() removes the channel from the
connection's list using list_del(&chan->list) and drops the connection's
reference to the channel using l2cap_chan_put(chan).

The bug is that l2cap_sock_cleanup_listen() does not acquire conn->lock
before calling l2cap_chan_close(). Consequently, list_del(&chan->list)
modifies conn->chan_l concurrently while l2cap_conn_ready() is iterating
over it. This corrupts the list and leads to a use-after-free when
l2cap_conn_ready() attempts to access the next pointer of the freed chan
object.

A similar missing conn->lock issue also exists in
net/bluetooth/6lowpan.c within bt_6lowpan_disconnect() and
disconnect_all_peers(), where l2cap_chan_close() is also called without
holding the connection lock.

To fix this, l2cap_sock_cleanup_listen() must acquire conn->lock before
calling l2cap_chan_close(). This is the exact same pattern already used
safely in l2cap_sock_shutdown() within the same file. We use
l2cap_conn_hold_unless_zero() to safely get a reference to the
connection, lock it, close the channel, and then unlock and put the
connection.

The same fix was applied to bt_6lowpan_disconnect() and
disconnect_all_peers() in net/bluetooth/6lowpan.c. Since 6lowpan.c can
be built as a separate kernel module, l2cap_conn_hold_unless_zero() was
exported using EXPORT_SYMBOL().

Fixes: 3df91ea20e744344100b10ae69a17211fcf5b207 ("Bluetooth: Revert to mutexes from RCU list")
Assisted-by: Gemini:gemini-3.1-pro-preview
Reported-by: syzbot+0e4ebcc970728e056324@syzkaller.appspotmail.com
Link: https://syzkaller.appspot.com/bug?extid=0e4ebcc970728e056324
Link: https://syzkaller.appspot.com/ai_job?id=7caab47a-b544-46b3-a699-3cc71c4b2494
To: <linux-bluetooth@vger.kernel.org>
To: <luiz.dentz@gmail.com>
To: <marcel@holtmann.org>
Cc: <linux-kernel@vger.kernel.org>

---
diff --git a/net/bluetooth/6lowpan.c b/net/bluetooth/6lowpan.c
index 2f03b780b..566f75612 100644
--- a/net/bluetooth/6lowpan.c
+++ b/net/bluetooth/6lowpan.c
@@ -927,9 +927,11 @@ static int bt_6lowpan_disconnect(struct l2cap_conn *conn, u8 dst_type)
 
 	BT_DBG("peer %p chan %p", peer, peer->chan);
 
+	mutex_lock(&conn->lock);
 	l2cap_chan_lock(peer->chan);
 	l2cap_chan_close(peer->chan, ENOENT);
 	l2cap_chan_unlock(peer->chan);
+	mutex_unlock(&conn->lock);
 
 	return 0;
 }
@@ -1063,9 +1065,24 @@ static void disconnect_all_peers(void)
 		spin_unlock(&devices_lock);
 
 		for (i = 0; i < nchans; ++i) {
+			struct l2cap_conn *conn;
+
+			l2cap_chan_lock(chans[i]);
+			conn = l2cap_conn_hold_unless_zero(chans[i]->conn);
+			l2cap_chan_unlock(chans[i]);
+
+			if (conn)
+				mutex_lock(&conn->lock);
+
 			l2cap_chan_lock(chans[i]);
 			l2cap_chan_close(chans[i], ENOENT);
 			l2cap_chan_unlock(chans[i]);
+
+			if (conn) {
+				mutex_unlock(&conn->lock);
+				l2cap_conn_put(conn);
+			}
+
 			l2cap_chan_put(chans[i]);
 		}
 	} while (nchans);
diff --git a/net/bluetooth/l2cap_core.c b/net/bluetooth/l2cap_core.c
index 7701528f1..d3b012feb 100644
--- a/net/bluetooth/l2cap_core.c
+++ b/net/bluetooth/l2cap_core.c
@@ -7623,6 +7623,7 @@ struct l2cap_conn *l2cap_conn_hold_unless_zero(struct l2cap_conn *c)
 
 	return c;
 }
+EXPORT_SYMBOL(l2cap_conn_hold_unless_zero);
 
 int l2cap_recv_acldata(struct hci_dev *hdev, u16 handle,
 		       struct sk_buff *skb, u16 flags)
diff --git a/net/bluetooth/l2cap_sock.c b/net/bluetooth/l2cap_sock.c
index cf590a67d..b0f25503f 100644
--- a/net/bluetooth/l2cap_sock.c
+++ b/net/bluetooth/l2cap_sock.c
@@ -1478,6 +1478,7 @@ static void l2cap_sock_cleanup_listen(struct sock *parent)
 	/* Close not yet accepted channels */
 	while ((sk = bt_accept_dequeue(parent, NULL))) {
 		struct l2cap_chan *chan = l2cap_pi(sk)->chan;
+		struct l2cap_conn *conn;
 
 		BT_DBG("child chan %p state %s", chan,
 		       state_to_string(chan->state));
@@ -1485,11 +1486,27 @@ static void l2cap_sock_cleanup_listen(struct sock *parent)
 		l2cap_chan_hold(chan);
 		l2cap_chan_lock(chan);
 
+		/* prevent conn structure from being freed */
+		conn = l2cap_conn_hold_unless_zero(chan->conn);
+		l2cap_chan_unlock(chan);
+
+		if (conn)
+			/* mutex lock must be taken before l2cap_chan_lock() */
+			mutex_lock(&conn->lock);
+
+		l2cap_chan_lock(chan);
+
 		__clear_chan_timer(chan);
 		l2cap_chan_close(chan, ECONNRESET);
 		l2cap_sock_kill(sk);
 
 		l2cap_chan_unlock(chan);
+
+		if (conn) {
+			mutex_unlock(&conn->lock);
+			l2cap_conn_put(conn);
+		}
+
 		l2cap_chan_put(chan);
 	}
 }


base-commit: 5d6919055dec134de3c40167a490f33c74c12581
-- 
This is an AI-generated patch subject to moderation.
Reply with '#syz upstream' to send it to the mailing list.
Reply with '#syz reject' to reject it.

See  for more information.
