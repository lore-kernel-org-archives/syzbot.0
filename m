Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A51E644AB94;
	Fri,  4 Sep 2026 12:24:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788524664; cv=none; b=IUkPb22lIdoHNbpuUjit9BDKKbODFgjmoWxswVgHKzKTPXJ95TXP1bP9+czp5PnxLtPrinLk0BhQ0hcx/y7Qfb3yv2BkWg0PNZURl2OisBU+gYsgSbKTRn66TodLpMbboi6dVfDs0kjQowJl7jRv4h4KB0Ne0x8tVi9SvhMkQ1w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788524664; c=relaxed/simple;
	bh=DvAvTw52vuzZFyP/uyq9o/hENAIlvcZrXJfVWLeVCRE=;
	h=From:To:Cc:Subject:Message-ID:MIME-Version:Content-Type:Date; b=k9n1ljPgYxgeGezUIK4Q+mAUmb+kCNa6ZGGTNz3btBtcBV4UPQ5suPQ+rMg+2+/izBXrqnuUMf7Io5PBXZ+H8jOsydnZVx9+QsI2ycHHvf0lO132UpCRiBWqdSFUjWxXZi+5ty9mAjH+LrEF6rXJWM912kV9pE3PlxlU5RfjWDc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=e58QxgrK; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="e58QxgrK"
Received: by smtp.kernel.org (Postfix) with UTF8SMTPSA id EBC531F00A3D;
	Fri,  4 Sep 2026 12:24:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788524663;
	bh=JP3cmXMuLbeG7onVtl0q1r5cNTl2riebgD9aREchz8I=;
	h=From:To:Cc:Subject:Date;
	b=e58QxgrK469hrcKRpJsBP4VArHzV7DbpXS5D+OK0XdNTw5JNJqmqbKfO1jvUDudGp
	 XF+Tbt2hx+bkwx02gm8rWGQtOtSHsTwuq0NcI1JwJHZOJ5BIs94MsIgDPLPJQTApZz
	 zWEYaq2n3ntt6k/+2PpTfHGcIkxJAN9RG8z4trxrNZPF3TNd/VRUn6hk4UUob3OxiH
	 36fGwWXLnyOQ81fN2FjAlUy5G4GWvUq9FszJSfOze+qEDG9pVgdpimVej0rY0/btiK
	 QyO0plM2Gah2D5+++V3M9sfqor96MLTkTKhVcOokAlOLI/FjDhsXLPVSOZc4dQL05Z
	 4ymA/hx0wVcfw==
From: "syzbot" <syzbot@kernel.org>
To: syzkaller-bugs@googlegroups.com, Krystian Kaniewski <krystianmkaniewski@gmail.com>, <linux-bluetooth@vger.kernel.org>, "Luiz Augusto von Dentz" <luiz.dentz@gmail.com>, "Marcel Holtmann" <marcel@holtmann.org>, "Dmitry Antipov" <dmantipov@yandex.ru>
Cc: linux-kernel@vger.kernel.org, syzbot@lists.linux.dev
Subject: [PATCH] Bluetooth: hci_sysfs: Fix NULL pointer dereference in device_del()
Message-ID: <388cbac3-b865-4843-bd65-c74059a5a459@mail.kernel.org>
Precedence: bulk
X-Mailing-List: syzbot@lists.linux.dev
List-Id: <syzbot.lists.linux.dev>
List-Subscribe: <mailto:syzbot+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:syzbot+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Date: Fri,  4 Sep 2026 12:24:22 +0000 (UTC)

From: Krystian Kaniewski <krystianmkaniewski@gmail.com>

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
Signed-off-by: Krystian Kaniewski <krystianmkaniewski@gmail.com>

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
See https://goo.gle/syzbot-ai-patches for information about AI-generated patches.
The person who has signed off on the patch is responsible for
addressing comments.
syzbot engineers can be reached at syzkaller@googlegroups.com.
