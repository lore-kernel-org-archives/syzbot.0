Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E26E03CA4AF
	for <syzbot@lists.linux.dev>; Thu,  3 Sep 2026 08:22:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788423725; cv=none; b=bYAw51kZBXpuA8RtfyWu1RpIDb+Lf0kecSUTb3MaIW9Vu0sQsKXKzV3vwHnpYaWRZhTBvAr9o1SM5wrfA1CcnLwqK22yq+CB08fgiH1CWd/b8JkAnrW6gl8LPqPq9Zp9+8flrB5/n89vPMqiuMoVOYokwA4YiNHkxI1e5EP94BU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788423725; c=relaxed/simple;
	bh=FalymxLP1whIQ/6QzD78dNeKu5a9A6/ADhp66QdEue0=;
	h=From:To:Cc:Subject:Message-ID:MIME-Version:Content-Type:Date; b=ntB0FRXOQt3u7tzIPN3Hwj1hmWAgcrY9Cu+TKdRsgKVsvfpgSF8D7BXL+C//MCS0ya6QHbYMo3gqLFPedovfDDiAFpIxJPO8qoQImK2EIv6YG3WIBW+w2XM2LoOrUyHE0Ec7IhzRA7PclyxALCTD2DW4+kWBVks4/GcxTm7GMOc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=fMrVDWEA; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="fMrVDWEA"
Received: by smtp.kernel.org (Postfix) with UTF8SMTPSA id 4BED71F00A3D;
	Thu,  3 Sep 2026 08:22:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788423723;
	bh=9FhI77GeljzQsZ94TY2ihItv8ihd1mnnEDvplxBGvpo=;
	h=From:To:Cc:Subject:Date;
	b=fMrVDWEAxoKLnWtw38lIfK0NAUUIbG3OJxAk+V0uJFuPdhiCdom0Z6z/ara9apZWV
	 RuRLcRZcJjfMlyX/rE8IGbY8M8+iz2YvxFlvMEb5sw+1VjUG8ztS7W3BYdj5Y5tNjy
	 0xvuBOs+iR0nycwdmlgz5JXcpBKfnuQm1vHxa+UJr1Mp0rsaEOIRVHasfFyGIBPEOD
	 3P0LBw6IcGoegJFL0FXXMnpFEjI2AOyaXWUd84AfL0B0k1tlzpjFmtKO4GkXYqbTHA
	 LjMRSUOGKHeVqCprwM3aJVjDq86oFG7rxEk1P/Ef3bz0qpeMG7D4u+RFfW7fsNia6V
	 u2x7mhZDeMEsw==
From: "syzbot" <syzbot@kernel.org>
To: syzkaller-upstream-moderation@googlegroups.com
Cc: krystianmkaniewski@gmail.com, syzbot@lists.linux.dev
Subject: [PATCH RFC v3] Bluetooth: hci_sysfs: Fix NULL pointer dereference in device_del()
Message-ID: <e121f7b5-8495-40a5-b4f7-e015ab95904b@mail.kernel.org>
Precedence: bulk
X-Mailing-List: syzbot@lists.linux.dev
List-Id: <syzbot.lists.linux.dev>
List-Subscribe: <mailto:syzbot+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:syzbot+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Date: Thu,  3 Sep 2026 08:22:03 +0000 (UTC)

A NULL pointer dereference in klist_put() occurs when a child device (such
as a BNEP network device in bnep_session) is concurrently being
unregistered while hci_conn_del_sysfs() reparents child devices.

This is caused by a race condition between hci_conn_del_sysfs() and
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
Link: https://syzkaller.appspot.com/ai_job?id=f1c0e740-db21-40af-a9ff-84db0fd8b8bd
To: <linux-bluetooth@vger.kernel.org>
To: "Luiz Augusto von Dentz" <luiz.dentz@gmail.com>
To: "Marcel Holtmann" <marcel@holtmann.org>
To: "Dmitry Antipov" <dmantipov@yandex.ru>
Cc: <linux-kernel@vger.kernel.org>

---
v3:
- Removed the quoted crash trace from the commit description.

v2:
- Update subject line to reflect the NULL pointer dereference in device_del().
- Replace trace with the actual crash report trace.
- Clarify the race condition ordering between device_del() and concurrent hci_conn_del_sysfs().
https://lore.kernel.org/all/7649937b-a96e-44a1-8785-79b23c26ffe6@mail.kernel.org/T/

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
