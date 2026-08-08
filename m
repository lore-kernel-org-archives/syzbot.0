Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 05BEE1A08AF
	for <syzbot@lists.linux.dev>; Sat,  8 Aug 2026 07:49:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786175368; cv=none; b=HOc0GbWmArrsgFOd4zq3lp7Ba+cAA3GtQR1PHv9Gk+UoAkOMder8nh+921ySzBMvy2novIZvBiToXSN7YFe6R5Xspab5So8F/p1fzHzfznbp27ewkzToHkvGfLFCu+43BSKQNIczyHe+wLTATVlwttcq9R95B/omkug6KoOW4ws=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786175368; c=relaxed/simple;
	bh=EoaWr4cLwCiTyLQXiwKQtLr54FfdWN2nJqcgc28BkVs=;
	h=From:To:Cc:Subject:Message-ID:MIME-Version:Content-Type:Date; b=FHfcpYgV765JzFvkJQnIwqZ6Hvqwrrw+GOJ+6L5FBgNhwyj4wmj8MuVb6Jgl+HEM8mep35c7IYXz0NVvYq0frSzaBGz3EZmQq/fHr/iPLHJpFIaCtfH5FQT4xRFqikArwVcPJ88zbCulmV676F0U9e4G6g8UVxPxW02h8ITLubw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=MYIOB/p6; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="MYIOB/p6"
Received: by smtp.kernel.org (Postfix) with UTF8SMTPSA id 6E54C1F000E9;
	Sat,  8 Aug 2026 07:49:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1786175366;
	bh=f/UttVWOlahtr2FLO1ppMJq+hGAcx8YIcEuUq9mbx3o=;
	h=From:To:Cc:Subject:Date;
	b=MYIOB/p69WKRurjq0Gdv4/5ExPhM+4FG3ELXfj05uUqXcUfZVFI75C05M+U6Nyk16
	 TJvbL0kB4+KLicibzqe/QJCX/i/CGG6AWW6nzO0bMu4BC8+S3Pumpr9M5vBx5JMqHk
	 5A/7fQ1Xaa/tYUrg2QwIIicy8UH2fUACp2gcEghu95ChOE6SB2tTRjBVs0LNtmQXkN
	 prTRAWHicMMZ1noXFkJzdQ0ujRMuj/m7UmR4lqlx9BiUmd9Fh3GoeTEDzRMJXTYo8Z
	 ZMzV3bz2rGNj+ENFGfKwHSwQRfKY+ILt4PZO1fHsboLI7daIiDIu0EDXJeTHJ+PBV+
	 gbIkAOvpctxgQ==
From: "syzbot" <syzbot@kernel.org>
To: syzkaller-upstream-moderation@googlegroups.com
Cc: syzbot@lists.linux.dev
Subject: [PATCH RFC] Bluetooth: hci_conn: Fix race condition during device teardown
Message-ID: <21db7fdb-887d-4b6f-8971-79eb4145508a@mail.kernel.org>
Precedence: bulk
X-Mailing-List: syzbot@lists.linux.dev
List-Id: <syzbot.lists.linux.dev>
List-Subscribe: <mailto:syzbot+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:syzbot+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Date: Sat,  8 Aug 2026 07:49:26 +0000 (UTC)

A general protection fault occurs in klist_remove() (via klist_put() ->
klist_del()) because it is being called on a klist_node that has already
been removed from its list. This is caused by a race condition between the
Bluetooth HCI subsystem and the RFCOMM subsystem (or other child
subsystems) when tearing down devices.

Oops: general protection fault, probably for non-canonical address
0xdffffc000000000b: 0000 [#1] SMP KASAN NOPTI
KASAN: null-ptr-deref in range [0x0000000000000058-0x000000000000005f]
CPU: 1 UID: 0 PID: 5001 Comm: kworker/u11:1 Not tainted
Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS
1.16.3-debian-1.16.3-2 04/01/2014
Workqueue: hci0 hci_rx_work
RIP: 0010:klist_put lib/klist.c:212 [inline]
RIP: 0010:klist_del lib/klist.c:230 [inline]
RIP: 0010:klist_remove+0x156/0x340 lib/klist.c:249
Call Trace:
 <TASK>
 device_move+0x18e/0x720 drivers/base/core.c:4698
 hci_conn_del_sysfs+0xb8/0x1a0 net/bluetooth/hci_sysfs.c:75
 hci_conn_cleanup net/bluetooth/hci_conn.c:170 [inline]
 hci_conn_del+0xc3d/0x1200 net/bluetooth/hci_conn.c:1308
 hci_disconn_complete_evt+0x5ac/0x890 net/bluetooth/hci_event.c:3470
 hci_event_func net/bluetooth/hci_event.c:7784 [inline]
 hci_event_packet+0x6cd/0xf10 net/bluetooth/hci_event.c:7835
 hci_rx_work+0x3ee/0x1020 net/bluetooth/hci_core.c:4039
 process_one_work kernel/workqueue.c:3322 [inline]
 process_scheduled_works+0xa8e/0x14e0 kernel/workqueue.c:3405
 worker_thread+0xa47/0xfb0 kernel/workqueue.c:3486
 kthread+0x388/0x470 kernel/kthread.c:436
 ret_from_fork+0x514/0xb70 arch/x86/kernel/process.c:158
 ret_from_fork_asm+0x1a/0x30 arch/x86/entry/entry_64.S:245
 </TASK>

When an HCI connection is disconnected, hci_conn_del_sysfs() is called.
This function iterates over all child devices of the connection device
(conn->dev) and attempts to reparent them to NULL using device_move().
Concurrently, the subsystem that actually owns the child device (e.g.,
RFCOMM) might be deleting it, triggering device_del().

device_move() and device_del() are not designed to run concurrently on the
same device. device_del() removes the device from its parent's list by
calling klist_del(), which sets the node's internal list pointer to NULL.
device_move() concurrently modifies dev->parent and calls klist_remove().
If device_del() removes the node just before device_move() calls
klist_remove(), klist_remove() will dereference a NULL list pointer,
resulting in the observed general protection fault.

The device_move() loop was recently introduced to fix a use-after-free bug.
The UAF occurred because conn->dev dropped its reference to its parent hdev
too early (in hci_conn_cleanup() during the unregistration phase). If
conn->dev was kept alive by its children, its parent pointer would become
dangling when hdev was subsequently freed. The flawed fix attempted to
manually reparent children to NULL during unregistration to avoid accessing
the freed parent.

The correct and robust way to fix the underlying UAF is to ensure that
conn->dev holds a reference to hdev for its entire lifetime, not just while
it is registered. By moving hci_dev_put(hdev) from hci_conn_cleanup() to
bt_link_release() (the .release callback called when the last reference to
conn->dev is dropped), we guarantee that hdev remains alive as long as
conn->dev exists in memory. This completely eliminates the UAF without
needing to manually reparent children.

With the UAF properly fixed by tying the parent's lifetime to the child's
actual memory lifetime, the racy device_move() loop in hci_conn_del_sysfs()
is no longer needed and is safely removed, resolving the general protection
fault.

Fixes: 27aabf27fd01 ("Bluetooth: fix use-after-free in device_for_each_child()")
Assisted-by: Gemini:gemini-3.5-flash Gemini:gemini-3.1-pro-preview syzbot
Reported-by: syzbot+1f4e278e8e1a9b01f95f@syzkaller.appspotmail.com
Closes: https://syzkaller.appspot.com/bug?extid=1f4e278e8e1a9b01f95f
Link: https://syzkaller.appspot.com/ai_job?id=0cfe0d07-8d9c-4f23-a9e3-d73b9f3b7cb0
To: <linux-bluetooth@vger.kernel.org>
To: "Luiz Augusto von Dentz" <luiz.dentz@gmail.com>
To: "Marcel Holtmann" <marcel@holtmann.org>
To: "Dmitry Antipov" <dmantipov@yandex.ru>
Cc: <linux-kernel@vger.kernel.org>

---
diff --git a/net/bluetooth/hci_conn.c b/net/bluetooth/hci_conn.c
index b1f911fd4..c01e77f94 100644
--- a/net/bluetooth/hci_conn.c
+++ b/net/bluetooth/hci_conn.c
@@ -168,8 +168,6 @@ static void hci_conn_cleanup(struct hci_conn *conn)
 	debugfs_remove_recursive(conn->debugfs);
 
 	hci_conn_del_sysfs(conn);
-
-	hci_dev_put(hdev);
 }
 
 int hci_disconnect(struct hci_conn *conn, __u8 reason)
diff --git a/net/bluetooth/hci_sysfs.c b/net/bluetooth/hci_sysfs.c
index 8957ce7c2..18e3c3508 100644
--- a/net/bluetooth/hci_sysfs.c
+++ b/net/bluetooth/hci_sysfs.c
@@ -13,7 +13,10 @@ static const struct class bt_class = {
 static void bt_link_release(struct device *dev)
 {
 	struct hci_conn *conn = to_hci_conn(dev);
+	struct hci_dev *hdev = conn->hdev;
+
 	kfree(conn);
+	hci_dev_put(hdev);
 }
 
 static const struct device_type bt_link = {
@@ -63,19 +66,6 @@ void hci_conn_del_sysfs(struct hci_conn *conn)
 		return;
 	}
 
-	/* If there are devices using the connection as parent reset it to NULL
-	 * before unregistering the device.
-	 */
-	while (1) {
-		struct device *dev;
-
-		dev = device_find_any_child(&conn->dev);
-		if (!dev)
-			break;
-		device_move(dev, NULL, DPM_ORDER_DEV_LAST);
-		put_device(dev);
-	}
-
 	device_unregister(&conn->dev);
 }
 


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
