Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E01632D9EED
	for <syzbot@lists.linux.dev>; Sat,  9 May 2026 07:22:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778311328; cv=none; b=QkQzcW6d6n59WFlIZIJsYxzeLp4YSuVJMnQup6bBKCcydWCQ9Y5bhDFS5j3ue9fQjrmjHFgMDLokS+f6CZHKQr27qRFSmoVhGjUF0jln35PVwQPkRCiYu9Zg5qZ9uMl7AX1DbR9nT32gmWPHV5u5RD5FftzOYoLyiSc6MBLvrhM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778311328; c=relaxed/simple;
	bh=ucuaynA2NdHDDB92N1WATNM+w2AQUbve5HCkZHekwTc=;
	h=From:To:Cc:Subject:Message-ID:MIME-Version:Content-Type:Date; b=Ub4jKExoyt5jIOF3OtgWN8MEf7hTB4Swtlts1yZCmAdwFdGFf90PNFtjdB36mGsGCHEodXJ/QuRXHvv8o7ErASGbkq9fyva2N5T0GX1Mp7kOS4MU67yerKOepoOOY8wgFtl+nBqbmbuUBzCrxPP96kiRG1c98U23J+NDUeEl6ec=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=ltZJ55Fd; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="ltZJ55Fd"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5B57EC2BCB2;
	Sat,  9 May 2026 07:22:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1778311328;
	bh=ucuaynA2NdHDDB92N1WATNM+w2AQUbve5HCkZHekwTc=;
	h=From:To:Cc:Subject:Date:From;
	b=ltZJ55FdTrMTrohyRDe2GB7nYwU4fXCikkG2N1FRJzTegE9WU3mQtjnqpyp+hSuIu
	 on2yDBc0AgoLtm3EK11lvUx/moEsvT4eStPHtz+4cVxVmyBRPiCVQGzY6h1CAzr/RQ
	 QStyzeq8iGjZq80YDS0Fs472J6iOZE97OyjEWl9qeTdXeELcvNkh48gE0HOXDK1/N0
	 pTT3PIWZguZz1JyYLKsu6Ckf+yAS8W1eEAtux+hTqKBKGIuSaDiuMbYPntLyEWkguT
	 Dyg7Cf2blas93VDnrEtKCcqIBk/e61wd5tZHv+7tORR007mlqLz7uzuYEG4pkZjctu
	 RoH2stLz75FgQ==
From: "syzbot" <syzbot@kernel.org>
To: syzkaller-upstream-moderation@googlegroups.com
Cc: syzbot@lists.linux.dev
Subject: [PATCH RFC] Bluetooth: L2CAP: Fix use-after-free in l2cap_chan_timeout
Message-ID: <a7fed23b-9c2f-43b0-923b-667cafca7092@mail.kernel.org>
Precedence: bulk
X-Mailing-List: syzbot@lists.linux.dev
List-Id: <syzbot.lists.linux.dev>
List-Subscribe: <mailto:syzbot+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:syzbot+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Date: Sat,  9 May 2026 07:22:08 +0000 (UTC)

Bluetooth: L2CAP: Fix use-after-free in l2cap_chan_timeout

There is a race condition between the delayed work l2cap_chan_timeout()
and the connection teardown routine l2cap_conn_del(), which leads to a
use-after-free of the struct l2cap_conn object.

In l2cap_chan_timeout(), chan->conn is read without holding chan->lock.
If l2cap_conn_del() runs concurrently, it can set chan->conn to NULL
and free the conn object. When l2cap_chan_timeout() subsequently
attempts to acquire conn->lock, it triggers a KASAN slab-use-after-free.

Additionally, if l2cap_chan_timeout() reads chan->conn as NULL, it
returns early without calling l2cap_chan_put(chan), leaking the channel
reference held by __set_chan_timer().

To fix this, safely obtain a reference to conn using l2cap_conn_get()
while holding chan->lock. After acquiring conn->lock and re-acquiring
chan->lock, verify that chan->conn still matches conn to ensure the
channel is still associated with the connection. Finally, ensure
l2cap_chan_put(chan) is called on the early return path to prevent the
reference leak.

While at it, add a missing !chan->conn check under chan->lock in
l2cap_ack_timeout() to prevent a potential NULL pointer dereference
if l2cap_chan_del() runs concurrently.

Assisted-by: Gemini:gemini-3.1-pro-preview Gemini:gemini-3-flash-preview
To: <linux-bluetooth@vger.kernel.org>
To: <luiz.dentz@gmail.com>
To: <marcel@holtmann.org>
Cc: <linux-kernel@vger.kernel.org>

---
diff --git a/net/bluetooth/l2cap_core.c b/net/bluetooth/l2cap_core.c
index 77dec104a..ca2cfb6b7 100644
--- a/net/bluetooth/l2cap_core.c
+++ b/net/bluetooth/l2cap_core.c
@@ -406,13 +406,21 @@ static void l2cap_chan_timeout(struct work_struct *work)
 {
 	struct l2cap_chan *chan = container_of(work, struct l2cap_chan,
 					       chan_timer.work);
-	struct l2cap_conn *conn = chan->conn;
+	struct l2cap_conn *conn;
 	int reason;
 
 	BT_DBG("chan %p state %s", chan, state_to_string(chan->state));
 
-	if (!conn)
+	l2cap_chan_lock(chan);
+	conn = chan->conn;
+	if (conn)
+		l2cap_conn_get(conn);
+	l2cap_chan_unlock(chan);
+
+	if (!conn) {
+		l2cap_chan_put(chan);
 		return;
+	}
 
 	mutex_lock(&conn->lock);
 	/* __set_chan_timer() calls l2cap_chan_hold(chan) while scheduling
@@ -420,6 +428,14 @@ static void l2cap_chan_timeout(struct work_struct *work)
 	 */
 	l2cap_chan_lock(chan);
 
+	if (chan->conn != conn) {
+		l2cap_chan_unlock(chan);
+		mutex_unlock(&conn->lock);
+		l2cap_conn_put(conn);
+		l2cap_chan_put(chan);
+		return;
+	}
+
 	if (chan->state == BT_CONNECTED || chan->state == BT_CONFIG)
 		reason = ECONNREFUSED;
 	else if (chan->state == BT_CONNECT &&
@@ -436,6 +452,7 @@ static void l2cap_chan_timeout(struct work_struct *work)
 	l2cap_chan_put(chan);
 
 	mutex_unlock(&conn->lock);
+	l2cap_conn_put(conn);
 }
 
 struct l2cap_chan *l2cap_chan_create(void)
@@ -3158,6 +3175,12 @@ static void l2cap_ack_timeout(struct work_struct *work)
 
 	l2cap_chan_lock(chan);
 
+	if (!chan->conn) {
+		l2cap_chan_unlock(chan);
+		l2cap_chan_put(chan);
+		return;
+	}
+
 	frames_to_ack = __seq_offset(chan, chan->buffer_seq,
 				     chan->last_acked_seq);
 


base-commit: 7fd2df204f342fc17d1a0bfcd474b24232fb0f32
-- 
This is an AI-generated patch subject to moderation.
Reply with '#syz upstream' to send it to the mailing list.
Reply with '#syz reject' to reject it.

See  for more information.
