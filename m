Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 39AA23AAF54
	for <syzbot@lists.linux.dev>; Mon, 31 Aug 2026 22:16:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788214603; cv=none; b=ivR4AMS8nZ6lZeRjVXmxpvRT1IEZ5wmoPa4svzGhfE96fMr7ays0KzAtcPcq17YhXGhUgDhPSvYHJQUIIS0HY6VyNSpvjOhM8HE2mCfTsRt4Y90QgnUTAXOIKz/3CxN4YAHFcgYGL54+eM4DlIHNuna/2WD0ipfzGe86CRJnywI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788214603; c=relaxed/simple;
	bh=Y9ZvkqHf/8ylu9x+Ef+td+G/vSB2DaRIm53xisX8fi4=;
	h=From:To:Cc:Subject:Message-ID:MIME-Version:Content-Type:Date; b=a7w8KDH5u58GZgQV8bwfRqmCUc1919+waRQnIFUqf2I1Mm06ZvvAP/PZFk3+FrRuonJvLjdJM7T3WtdwNAukAaf/06/UfC+o/qJeb9LMkVzamJd0WcqwhLCN0DKfujiAb6aO+S/q602seLRTPpdn+GCI1kK8bykQulIiESoUmpo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=QK2Cxv20; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="QK2Cxv20"
Received: by smtp.kernel.org (Postfix) with UTF8SMTPSA id BA4301F000E9;
	Mon, 31 Aug 2026 22:16:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788214601;
	bh=XBCVtjIIm8Fu53FIH+PM/ueVE/oPgXfu7tRVoa5aLEo=;
	h=From:To:Cc:Subject:Date;
	b=QK2Cxv20Y4ROzXuEYvPTiFZml6LtX/8CCrEIw06JLm/q686FmxtVYswM90T3tReAg
	 8QPYOxIHqkNF53BMiL2lHQOvKm9gdLXHExJD4r/CHKhZ+BKpswzcd2YhWxEnG0EFT+
	 HiJ+K/02C67gY/HwTEiIq6l0GGWDNKKxqbtH15Gw1FMbfLreeeo6fhYaUnMEJz8tf7
	 DmcR63SPMwh7IoEZtQ0NdXNP3BYPYwSMSa5+ZNenhK3eT14kvntYtJY6XGpplzBA7T
	 YPYM4b9iPJKetEyeAEwGBvXqgLnb3QIOEEE7oE1+OUoLBSep5K1DFZMSV6tKFYDJtv
	 9Xe2nT+5n8SDw==
From: "syzbot" <syzbot@kernel.org>
To: syzkaller-upstream-moderation@googlegroups.com
Cc: syzbot@lists.linux.dev
Subject: [PATCH RFC] Bluetooth: hci_sysfs: fix null pointer dereference in device_move()
Message-ID: <21c8fde7-0caa-4f2c-ae68-4bd3443ff0b5@mail.kernel.org>
Precedence: bulk
X-Mailing-List: syzbot@lists.linux.dev
List-Id: <syzbot.lists.linux.dev>
List-Subscribe: <mailto:syzbot+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:syzbot+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Date: Mon, 31 Aug 2026 22:16:41 +0000 (UTC)

A NULL pointer dereference in klist_put() occurs when hci_conn_del_sysfs()
attempts to reparent child devices to NULL while a child device (such as a
BNEP network device) is concurrently being unregistered:

Oops: general protection fault, probably for non-canonical address
0xdffffc000000000b: 0000 [#1] SMP KASAN NOPTI
KASAN: null-ptr-deref in range [0x0000000000000058-0x000000000000005f]
CPU: 1 UID: 0 PID: 7415 Comm: task Not tainted PREEMPT(full)
RIP: 0010:klist_put lib/klist.c:212 [inline]
RIP: 0010:klist_del lib/klist.c:230 [inline]
RIP: 0010:klist_remove+0x156/0x340 lib/klist.c:249
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
unregister_netdev()). When a connection is cleaned up, hci_conn_del_sysfs()
uses device_find_any_child() to look up child devices and calls
device_move() to reparent them to NULL. If the child device is concurrently
deleted, device_del() removes the node from its parent's klist via
klist_del(&dev->p->knode_parent), which decrements the reference count and
clears the node's n_klist pointer to NULL. When device_move() subsequently
calls klist_remove(&dev->p->knode_parent), klist_put() attempts to
dereference knode_klist(n)->put, resulting in a NULL pointer dereference.

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
Assisted-by: Gemini:gemini-3.7-flash Gemini:gemini-3.1-pro-preview syzbot
Reported-by: syzbot+6df45dd3d03e1a9aca96@syzkaller.appspotmail.com
Closes: https://syzkaller.appspot.com/bug?extid=6df45dd3d03e1a9aca96
Link: https://syzkaller.appspot.com/ai_job?id=2d312ca9-20bf-457f-8a4f-728831a400af
To: <linux-bluetooth@vger.kernel.org>
To: "Luiz Augusto von Dentz" <luiz.dentz@gmail.com>
To: "Marcel Holtmann" <marcel@holtmann.org>
To: "Dmitry Antipov" <dmantipov@yandex.ru>
Cc: <linux-kernel@vger.kernel.org>

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
