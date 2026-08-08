Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7726A1D6DA9
	for <syzbot@lists.linux.dev>; Sat,  8 Aug 2026 21:29:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786224543; cv=none; b=BT9LQbAxSKw012WX4xs1ToJwzpyHHUpklF/RTzvFRuXZ8anufuearzxOXTNlAcAZtXARFqWBJ6EXYouNcb2wT2CZQQk7UlZLPFjmynUK8HwMo3DeQNiBCd+CUEI/WMm6VTNgJm2jfToLboMMPIjKnxhM6OCH9JBJsNA4PoQJWts=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786224543; c=relaxed/simple;
	bh=zNHfdX1ahIAMWWK1BmxLxFoaAzYae2J0nxVfAg7xDL0=;
	h=From:To:Cc:Subject:Message-ID:MIME-Version:Content-Type:Date; b=eVhFgLBsgdbF5UYe3WoqUhXRxHvKMIgEIx78XCsCvnYDnZVjFSc2npJuUIcWqLfTjsCF8miMxR6GbUMYtVaiNBoAYo0//sqOBY/OrWUsq2noU0UgBfV3NQSfEeGHJme34LHbVjzqoIsL1NuTY5RtjkgxJ9qFh9w25c2Fq3WZyyI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Mq4xdlkA; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Mq4xdlkA"
Received: by smtp.kernel.org (Postfix) with UTF8SMTPSA id E61881F000E9;
	Sat,  8 Aug 2026 21:29:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1786224542;
	bh=KnctBQRjT2OhdtXQPpXZRRehzESmlhBmKmB+Gg75upI=;
	h=From:To:Cc:Subject:Date;
	b=Mq4xdlkApbkbBV74130iF69zIunrB7cBZZ9Lzy4ff0SXcmV/rZe2xS4/sZ/FTL6mQ
	 cS8B6FafBi4Ba91HWVz2linH50S5Ui90pNnacx7i8wTMExFd3icXdge6O96WD7403p
	 BzukHclXKYY0hRJ75cbIYl7IKIDq40edz3xLgNEAAwnKbA58vJMATbAjTeM6VOTY6O
	 +EdWONElIrQni62AVvSqt/81QQkjD7NAMEmKlL6EPeYzuFzUzs0PT4h7TkXI4qkxyJ
	 DCln/VXPP6OvksgMdWIDqqrbrbdwOfHZabQeD6zlAjm93JuRixl619KA7Z9aGGe81T
	 g3PIq8xdkz0GA==
From: "syzbot" <syzbot@kernel.org>
To: syzkaller-upstream-moderation@googlegroups.com
Cc: syzbot@lists.linux.dev
Subject: [PATCH RFC] Bluetooth: hci_core: Check HCI_UP before queuing tx_work
Message-ID: <2c2febf2-fc12-4407-9c81-d3d9713f09a4@mail.kernel.org>
Precedence: bulk
X-Mailing-List: syzbot@lists.linux.dev
List-Id: <syzbot.lists.linux.dev>
List-Subscribe: <mailto:syzbot+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:syzbot+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Date: Sat,  8 Aug 2026 21:29:01 +0000 (UTC)

During the shutdown process of a Bluetooth device, hci_dev_close_sync() is
called. This function clears the HCI_UP flag, flushes pending RX and TX
works, and drains the workqueue to prevent lockdep issues during cleanup.
After the workqueue is drained, it flushes the connections.

Because the connections are flushed after the workqueue is drained, there
is a race window where the workqueue is draining but the sockets are still
in the BT_CONNECTED state. If a concurrent thread calls sendmsg() on an
active L2CAP, SCO, or ISO socket during this window, the socket state is
still considered connected. The sendmsg() call will eventually reach
hci_send_acl(), hci_send_sco(), or hci_send_iso(), which unconditionally
attempt to queue the transmission work (hdev->tx_work) on the draining
workqueue. This triggers a warning in __queue_work() because non-chained
work cannot be queued on a draining workqueue.

[ cut here ]
workqueue: cannot queue hci_tx_work on wq hci0
WARNING: kernel/workqueue.c:2306 at __queue_work+0xd4a/0x1090
kernel/workqueue.c:2305
RIP: 0010:__queue_work+0xd66/0x1090 kernel/workqueue.c:2305
Call Trace:
 <TASK>
 queue_work_on+0x106/0x1c0 kernel/workqueue.c:2452
 l2cap_chan_send+0x168a/0x22f0 net/bluetooth/l2cap_core.c:-1
 l2cap_sock_sendmsg+0x33a/0x4d0 net/bluetooth/l2cap_sock.c:1180
 sock_sendmsg_nosec+0x13a/0x180 net/socket.c:775
 __sock_sendmsg net/socket.c:790 [inline]
 ____sys_sendmsg+0x54e/0x850 net/socket.c:2684
 ___sys_sendmsg+0x2a5/0x360 net/socket.c:2738
 __sys_sendmmsg+0x273/0x4d0 net/socket.c:2827
 __do_sys_sendmmsg net/socket.c:2854 [inline]
 __se_sys_sendmmsg net/socket.c:2851 [inline]
 __x64_sys_sendmmsg+0xa0/0xc0 net/socket.c:2851
 do_syscall_x64 arch/x86/entry/syscall_64.c:63 [inline]
 do_syscall_64+0x15f/0x560 arch/x86/entry/syscall_64.c:94
 </TASK>

To fix this issue, modify hci_send_acl(), hci_send_sco(), and
hci_send_iso() to check if the HCI_UP flag is set on the device before
attempting to queue the transmission work. The HCI_UP flag is cleared early
in hci_dev_close_sync(), well before the workqueue is drained. If the flag
is not set, the work is not queued. The skb is safely appended to the
channel's or connection's data_q, which will be safely purged shortly after
when hci_conn_hash_flush() executes, ensuring no memory leaks occur.

Fixes: 76727c02c1e1 ("Bluetooth: Call drain_workqueue() before resetting state")
Assisted-by: Gemini:gemini-3.5-flash Gemini:gemini-3.1-pro-preview syzbot
Reported-by: syzbot+b6919040d9958e2fc1ae@syzkaller.appspotmail.com
Closes: https://syzkaller.appspot.com/bug?extid=b6919040d9958e2fc1ae
Link: https://syzkaller.appspot.com/ai_job?id=59121999-1293-40a6-aeeb-713e2d7dc16b
To: <linux-bluetooth@vger.kernel.org>
To: "Luiz Augusto von Dentz" <luiz.dentz@gmail.com>
To: "Marcel Holtmann" <marcel@holtmann.org>
To: "Johan Hedberg" <johan.hedberg@intel.com>
Cc: <linux-kernel@vger.kernel.org>

---
diff --git a/net/bluetooth/hci_core.c b/net/bluetooth/hci_core.c
index 5ba9fe826..d9f091af3 100644
--- a/net/bluetooth/hci_core.c
+++ b/net/bluetooth/hci_core.c
@@ -3242,7 +3242,8 @@ void hci_send_acl(struct hci_chan *chan, struct sk_buff *skb, __u16 flags)
 
 	hci_queue_acl(chan, &chan->data_q, skb, flags);
 
-	queue_work(hdev->workqueue, &hdev->tx_work);
+	if (test_bit(HCI_UP, &hdev->flags))
+		queue_work(hdev->workqueue, &hdev->tx_work);
 }
 
 /* Send SCO data */
@@ -3267,7 +3268,8 @@ void hci_send_sco(struct hci_conn *conn, struct sk_buff *skb)
 	bt_dev_dbg(hdev, "hcon %p queued %d", conn,
 		   skb_queue_len(&conn->data_q));
 
-	queue_work(hdev->workqueue, &hdev->tx_work);
+	if (test_bit(HCI_UP, &hdev->flags))
+		queue_work(hdev->workqueue, &hdev->tx_work);
 }
 
 /* Send ISO data */
@@ -3338,7 +3340,8 @@ void hci_send_iso(struct hci_conn *conn, struct sk_buff *skb)
 
 	hci_queue_iso(conn, &conn->data_q, skb);
 
-	queue_work(hdev->workqueue, &hdev->tx_work);
+	if (test_bit(HCI_UP, &hdev->flags))
+		queue_work(hdev->workqueue, &hdev->tx_work);
 }
 
 /* ---- HCI TX task (outgoing data) ---- */


base-commit: 075b74841bd0065a3bda3440873c747938e69b68
-- 
This is an AI-generated patch subject to moderation.
Reply with '#syz upstream' to Sign-off the patch as a human author
and send it to the upstream kernel mailing lists.
Reply with '#syz reject' to reject it ('#syz unreject' to undo).

See https://goo.gle/syzbot-ai-patches for information about AI-generated patches.
The person who has signed off on the patch is responsible for
addressing comments.
syzbot engineers can be reached at syzkaller@googlegroups.com.
