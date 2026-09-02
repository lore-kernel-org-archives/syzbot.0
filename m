Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A649E431A3C
	for <syzbot@lists.linux.dev>; Wed,  2 Sep 2026 16:57:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788368254; cv=none; b=hOmQQ+oj1ZOBaF9PpxhLnaicdqv09vwUilBzub0g1xpbfPQQg2yPI0PD7qaKhyGpifHYygAFLx5qYghWASQIbmN5KxGgW4qQPvrwj+d7mkS/5GV2xzYFad6C5oxfW2YOYiKmOwE1jRVS6zsaH7NMJmD++BmtCjzwRDlhnYi8Hjs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788368254; c=relaxed/simple;
	bh=+Kp2E8H09c2/z/ofoWDKT8rgBBacr0DVkoN2Ry4SW70=;
	h=From:To:Cc:Subject:Message-ID:MIME-Version:Content-Type:Date; b=MR8s/iJB62B+EfCXpAKNDncAPZymFdeqtFR9t3rU+K5xPqza5VEZV8Pj6c8CU3JKnwbcNtH4y8pFmxOw7RX0MGdxleotyFxzOdqsYE2G++gM7S/pyv6oY8TPMrZDdfxhliNovh+1pM3NEM37aaWGgSHigNkGrPcm6T98FWRKAmA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Yvd6OpAu; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Yvd6OpAu"
Received: by smtp.kernel.org (Postfix) with UTF8SMTPSA id 545FF1F00A3E;
	Wed,  2 Sep 2026 16:57:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788368252;
	bh=0/hDXsMubg0NVVbe/QrUomigNA5AfRRBnNX3alvFCoI=;
	h=From:To:Cc:Subject:Date;
	b=Yvd6OpAutODRe6Wm+nzgLZRFyV/+MgzYqQFfN11mh+C15ejZkJs1p5EmJxfW4MI+7
	 Kz35CtFo8Tn9w9cyVSlhwaw5lrU53jjBuApZzUqMxFVW8eCjbFrFaLZ7J9ynuU6nYQ
	 YS7mJkzFS/5BnJS3WOSpcX/FIRTOCrVdmbRKGmKIfJ84D4zOSVpwKi7v4MhtW2G62k
	 qU2WXdYUuXeqEXeWZq5j5Wmj0CmT2o71aJvwIkCzUw8238xhunIP7IWFQWy3KMGInV
	 ZwI4SDo0KjiHnuJ+fbadqEaqWCaDvj6ntfivIv3ljS8lIKILzG3JYLiNW/WJsJC5T+
	 BCnMlLZmssmKA==
From: "syzbot" <syzbot@kernel.org>
To: syzkaller-upstream-moderation@googlegroups.com
Cc: krystianmkaniewski@gmail.com, syzbot@lists.linux.dev
Subject: [PATCH RFC v2] Bluetooth: hci_sysfs: Fix NULL pointer dereference in device_del()
Message-ID: <7649937b-a96e-44a1-8785-79b23c26ffe6@mail.kernel.org>
Precedence: bulk
X-Mailing-List: syzbot@lists.linux.dev
List-Id: <syzbot.lists.linux.dev>
List-Subscribe: <mailto:syzbot+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:syzbot+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Date: Wed,  2 Sep 2026 16:57:32 +0000 (UTC)

A NULL pointer dereference in klist_put() occurs when a child device (such
as a BNEP network device in bnep_session) is concurrently being
unregistered while hci_conn_del_sysfs() reparents child devices:

Oops: general protection fault, probably for non-canonical address
0xdffffc000000000b: 0000 [#1] SMP KASAN NOPTI
KASAN: null-ptr-deref in range [0x0000000000000058-0x000000000000005f]
CPU: 1 UID: 0 PID: 21636 Comm: syz-executor Not tainted syzkaller #1
PREEMPT(full)
Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS
1.16.3-debian-1.16.3-2 04/01/2014
RIP: 0010:klist_put lib/klist.c:212 [inline]
RIP: 0010:klist_del lib/klist.c:230 [inline]
RIP: 0010:klist_remove+0x156/0x340 lib/klist.c:249
...
Call Trace:
 <TASK>
 device_move+0x18e/0x720 drivers/base/core.c:4702
 hci_conn_del_sysfs+0xb8/0x1a0 net/bluetooth/hci_sysfs.c:75
 hci_conn_cleanup net/bluetooth/hci_conn.c:170 [inline]
 hci_conn_del+0xc3d/0x1200 net/bluetooth/hci_conn.c:1318
 hci_conn_hash_flush+0x189/0x260 net/bluetooth/hci_conn.c:2747
 hci_dev_close_sync+0x7fc/0x10c0 net/bluetooth/hci_sync.c:5593
 hci_dev_do_close net/bluetooth/hci_core.c:502 [inline]
 hci_unregister_dev+0x232/0x5b0 net/bluetooth/hci_core.c:2681
 vhci_release+0x16d/0x1c0 drivers/bluetooth/hci_vhci.c:700
 ...
 </TASK>

This crash is caused by a race condition between hci_conn_del_sysfs() and
concurrent child device unregistration (e.g. bnep_session calling
unregister_netdev()). During device unregistration, device_del() snapshots
a non-NULL parent pointer. Concurrently, hci_conn_del_sysfs() finds the
child device using device_find_any_child() and calls device_move() to
reparent it to NULL, which removes the node from its parent's klist and
clears knode_parent. Subsequently, device_del() calls
klist_del(&dev->p->knode_parent) using the stale parent snapshot, causing
klist_put() to dereference knode_klist(n)->put on an already removed node,
resulting in a NULL pointer dereference.

This race was introduced by commit 27aabf27fd01 ("Bluetooth: fix
use-after-free in device_for_each_child()"), which replaced
device_find_child(..., __match_tty) with device_find_any_child() in
hci_conn_del_sysfs(). That change was intended to avoid a use-after-free
where conn->dev outlived its parent hdev->dev when child devices held
references to conn->dev, because conn->dev only held a reference to
hdev->dev while registered in sysfs.

Fix the issue properly by taking an explicit reference to the parent device
with get_device(&hdev->dev) in hci_conn_init_sysfs() and dropping it with
put_device(parent) in bt_link_release() when the conn device is freed. This
ensures that hdev->dev remains valid for the entire lifecycle of conn->dev,
resolving the underlying use-after-free. With the parent reference held
properly, restore the __match_tty filter in hci_conn_del_sysfs() so that
device_move() is only invoked on persistent RFCOMM TTY devices as
originally intended, eliminating the race condition with unregistering
network devices.

Fixes: 27aabf27fd01 ("Bluetooth: fix use-after-free in device_for_each_child()")
Assisted-by: Gemini:gemini-3.7-flash syzbot
Reported-by: syzbot+6df45dd3d03e1a9aca96@syzkaller.appspotmail.com
Closes: https://syzkaller.appspot.com/bug?extid=6df45dd3d03e1a9aca96
Link: https://syzkaller.appspot.com/ai_job?id=03299926-ecd5-4848-b5f8-a253b09af490
To: <linux-bluetooth@vger.kernel.org>
To: "Luiz Augusto von Dentz" <luiz.dentz@gmail.com>
To: "Marcel Holtmann" <marcel@holtmann.org>
To: "Dmitry Antipov" <dmantipov@yandex.ru>
Cc: <linux-kernel@vger.kernel.org>

---
v2:
- Update subject line to reflect the NULL pointer dereference in device_del().
- Replace trace with the actual crash report trace.
- Clarify the race condition ordering between device_del() and concurrent hci_conn_del_sysfs().

v1:
https://lore.kernel.org/all/21c8fde7-0caa-4f2c-ae68-4bd3443ff0b5@mail.kernel.org/T/
---
diff --git a/net/bluetooth/hci_sysfs.c b/net/bluetooth/hci_sysfs.c
index 8957ce7c2..c2065abf7 100644
--- a/net/bluetooth/hci_sysfs.c
+++ b/net/bluetooth/hci_sysfs.c
@@ -13,7 +13,10 @@ static const struct class bt_class = {
 static void bt_link_release(struct device *dev)
 {
 	struct hci_conn *conn = to_hci_conn(dev);
+	struct device *parent = dev->parent;
+
 	kfree(conn);
+	put_device(parent);
 }
 
 static const struct device_type bt_link = {
@@ -21,6 +24,16 @@ static const struct device_type bt_link = {
 	.release = bt_link_release,
 };
 
+/*
+ * The rfcomm tty device will possibly retain even when conn
+ * is down, and sysfs doesn't support move zombie device,
+ * so we should move the device before conn device is destroyed.
+ */
+static int __match_tty(struct device *dev, const void *data)
+{
+	return !strncmp(dev_name(dev), "rfcomm", 6);
+}
+
 void hci_conn_init_sysfs(struct hci_conn *conn)
 {
 	struct hci_dev *hdev = conn->hdev;
@@ -29,7 +42,7 @@ void hci_conn_init_sysfs(struct hci_conn *conn)
 
 	conn->dev.type = &bt_link;
 	conn->dev.class = &bt_class;
-	conn->dev.parent = &hdev->dev;
+	conn->dev.parent = get_device(&hdev->dev);
 
 	device_initialize(&conn->dev);
 }
@@ -69,7 +82,7 @@ void hci_conn_del_sysfs(struct hci_conn *conn)
 	while (1) {
 		struct device *dev;
 
-		dev = device_find_any_child(&conn->dev);
+		dev = device_find_child(&conn->dev, NULL, __match_tty);
 		if (!dev)
 			break;
 		device_move(dev, NULL, DPM_ORDER_DEV_LAST);


base-commit: cee9395acd8043be0644b25c34bfa86623f2b935
-- 
This is an AI-generated patch subject to moderation.
Reply with '#syz upstream' to Sign-off the patch as a human author
and send it to the upstream kernel mailing lists.
Reply with '#syz reject' to reject it ('#syz unreject' to undo).

See https://goo.gle/syzbot-ai-patches for information about AI-generated patches.
You can comment on the patch as usual, syzbot will try to address
the comments and send a new version of the patch if necessary.
syzbot engineers can be reached at syzkaller@googlegroups.com.
