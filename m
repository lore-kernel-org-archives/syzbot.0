Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2C46B4CEE65
	for <syzbot@lists.linux.dev>; Mon,  5 Oct 2026 17:55:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791222905; cv=none; b=RXcwH5Beq1hQxWiHodf4t914C/fZsVBFzRTcgakPHl6GhMgwu3kifLsUu946rCHvQo2EJCoML0RPoZ51c5/bj5O7jyP+95/Q4jQVysnlphBOekwDoL3xWwVHU34O1QGQOu+wIfwROLkzBraDc87vavSgAgSykrYJNxK0v9xf0qU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791222905; c=relaxed/simple;
	bh=gRMMqcSMNdoZHMNOK7vN9U9atv9BtpdmqfxMSHYFXRQ=;
	h=From:To:Cc:Subject:Message-ID:MIME-Version:Content-Type:Date; b=iRmbNAYYRBunpLmMiz4n/VjrxqwGduFkorAzXGPhNZ1J2QPGx7dJc0xPv0ayl3+PBfTz6E1OcG1SIspsSTa/ADnC0rxLz5tIYYcrR4yowFHBbpAdi93zaI9JGZjTCFikdANxR8w/nO8rnr0kz5MClP992KVeJY8f5eCAP71nejE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=eovJKq7/; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="eovJKq7/"
Received: by smtp.kernel.org (Postfix) with UTF8SMTPSA id BB8881F000FF;
	Mon,  5 Oct 2026 17:55:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1791222903;
	bh=C6GO3GtLJlz6T0nAQoVfSF72lDxE4e9RMtLjGz+rC9s=;
	h=From:To:Cc:Subject:Date;
	b=eovJKq7/DhRM6KbvBHOjMMy17+L3wi32UmfC5OJRzsLPMKjnUJM0r12oBOj//+9ym
	 puPUPj6jqRtlNFSlM+ezZTnXIZ8kRaMnc9HGTj2+a4FwZwmWXCXMFJWjMsqPkqEIUZ
	 E9EM+8onuY51u731lfYeR8WkZ5Viaelo/viIRed5YgzDG1oHQauQTZdUK3mXoqTPP+
	 BoK5h3seYeXinNsok4DRCmgiJipccxN+f+f0WvwyMNt90lCQymdWYQVa8r1FtRDcQB
	 QwxL11Lmm/sb5jQYk0ydus9XjFYpLnFYn5JphC1MB0x3bjBd4uHGfBOkFdydcbGt0o
	 APZQBKsczdJPw==
From: "syzbot" <syzbot@kernel.org>
To: syzkaller-upstream-moderation@googlegroups.com
Cc: syzbot@lists.linux.dev
Subject: [PATCH RFC] driver core: Fix race between device_move() and device_del()
Message-ID: <c329c26b-9395-4a31-8908-904d88df7574@mail.kernel.org>
Precedence: bulk
X-Mailing-List: syzbot@lists.linux.dev
List-Id: <syzbot.lists.linux.dev>
List-Subscribe: <mailto:syzbot+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:syzbot+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Date: Mon,  5 Oct 2026 17:55:03 +0000 (UTC)

A race condition exists between device_move() and device_del() when
operating concurrently on the same device. For instance, when an HCI
connection disconnects, hci_conn_del_sysfs() iterates over child devices
(such as RFCOMM TTY devices) and calls device_move(dev, NULL,
DPM_ORDER_DEV_LAST) to reparent them to NULL. Concurrently, releasing or
closing the TTY device triggers device_del() on the exact same device.

In device_del(), kill_device(dev) sets dev->p->dead = true under
device_lock(dev). Later, device_del() calls
klist_del(&dev->p->knode_parent) to remove the device from its parent's
child list. When the klist node's reference count drops to 0,
klist_release() clears the node's klist pointer to NULL. Because
device_move() did not hold device_lock(dev) and did not check dev->p->dead,
it could execute concurrently and call klist_remove(&dev->p->knode_parent).
Inside klist_remove() -> klist_del() -> klist_put(), the code attempts to
dereference k->put at offset 0x58 on the NULL klist pointer, triggering a
NULL pointer dereference general protection fault:

Oops: general protection fault, probably for non-canonical address
0xdffffc000000000b: 0000 [#1] SMP KASAN NOPTI
KASAN: null-ptr-deref in range [0x0000000000000058-0x000000000000005f]
RIP: 0010:klist_put lib/klist.c:212 [inline]
RIP: 0010:klist_del lib/klist.c:230 [inline]
RIP: 0010:klist_remove+0x156/0x340 lib/klist.c:249
Call Trace:
 <TASK>
 device_move+0x18e/0x720 drivers/base/core.c:4702
 hci_conn_del_sysfs+0xb8/0x1a0 net/bluetooth/hci_sysfs.c:88
 hci_conn_del+0xc3d/0x1200 net/bluetooth/hci_conn.c:1339
 hci_disconn_complete_evt+0x5ac/0x890 net/bluetooth/hci_event.c:3508
 hci_rx_work+0x3ee/0x1020 net/bluetooth/hci_core.c:4087
 process_one_work kernel/workqueue.c:3396 [inline]
 process_scheduled_works+0xc3d/0x1630 kernel/workqueue.c:3479
 worker_thread+0xa47/0xfb0 kernel/workqueue.c:3560
 kthread+0x38b/0x480 kernel/kthread.c:436
 ret_from_fork+0x514/0xb70 arch/x86/kernel/process.c:158
 ret_from_fork_asm+0x1a/0x30 arch/x86/entry/entry_64.S:245
 </TASK>

Additionally, if device_move() ran before device_del() acquired
device_lock(dev), device_del() previously sampled dev->parent before taking
device_lock(dev). If device_move() reparented the device and dropped the
old parent reference, device_del() proceeded with a stale parent pointer,
resulting in a duplicate klist_del() and put_device(parent) on old_parent,
leading to list corruption and reference count underflow.

Fix this by properly serializing device_move() with device_del(). In
device_del(), sample dev->parent under device_lock(dev) directly after
kill_device(dev) marks the device dead, ensuring that device_del() observes
any prior reparenting. In device_move(), acquire device_lock(dev) at entry
and check whether dev->p is uninitialized or dev->p->dead is true,
returning -ENODEV immediately if deletion has already begun. Furthermore,
narrow the scope of device_pm_lock() to only cover the DPM list reordering
switch block, adhering strictly to the driver core locking hierarchy of
acquiring device_lock(dev) before device_pm_lock() and preventing potential
ABBA deadlocks against probe paths. Finally, consolidate error cleanup
paths in device_move() to properly balance references and remove sysfs glue
directories before releasing device_lock(dev).

Fixes: 8a82472f86bf ("driver core: Introduce device_move(): move a device to a new parent.")
Assisted-by: Gemini:gemini-3.8-flash Gemini:gemini-3.1-pro-preview syzbot
Reported-by: syzbot+1f4e278e8e1a9b01f95f@syzkaller.appspotmail.com
Closes: https://syzkaller.appspot.com/bug?extid=1f4e278e8e1a9b01f95f
Link: https://syzkaller.appspot.com/ai_job?id=3161b773-18b4-4410-aecf-8a0e46fe46d6
To: "Danilo Krummrich" <dakr@kernel.org>
To: <driver-core@lists.linux.dev>
To: "Greg Kroah-Hartman" <gregkh@linuxfoundation.org>
To: "Rafael J. Wysocki" <rafael@kernel.org>
To: "Cornelia Huck" <cornelia.huck@de.ibm.com>
Cc: <linux-kernel@vger.kernel.org>

---
diff --git a/drivers/base/core.c b/drivers/base/core.c
index 4c0c37399..de90b7753 100644
--- a/drivers/base/core.c
+++ b/drivers/base/core.c
@@ -3919,13 +3919,14 @@ EXPORT_SYMBOL_GPL(kill_device);
 void device_del(struct device *dev)
 {
 	struct subsys_private *sp;
-	struct device *parent = dev->parent;
+	struct device *parent;
 	struct kobject *glue_dir = NULL;
 	struct class_interface *class_intf;
 	unsigned int noio_flag;
 
 	device_lock(dev);
 	kill_device(dev);
+	parent = dev->parent;
 	device_unlock(dev);
 
 	if (dev->fwnode && dev->fwnode->dev == dev)
@@ -4679,23 +4680,26 @@ int device_move(struct device *dev, struct device *new_parent,
 	if (!dev)
 		return -EINVAL;
 
-	device_pm_lock();
+	device_lock(dev);
+	if (!dev->p || dev->p->dead) {
+		error = -ENODEV;
+		goto out_unlock;
+	}
+
 	new_parent = get_device(new_parent);
 	new_parent_kobj = get_device_parent(dev, new_parent);
 	if (IS_ERR(new_parent_kobj)) {
 		error = PTR_ERR(new_parent_kobj);
 		put_device(new_parent);
-		goto out;
+		goto out_unlock;
 	}
 
 	pr_debug("device: '%s': %s: moving to '%s'\n", dev_name(dev),
 		 __func__, new_parent ? dev_name(new_parent) : "<NULL>");
 	error = kobject_move(&dev->kobj, new_parent_kobj);
-	if (error) {
-		cleanup_glue_dir(dev, new_parent_kobj);
-		put_device(new_parent);
-		goto out;
-	}
+	if (error)
+		goto out_cleanup;
+
 	old_parent = dev->parent;
 	dev->parent = new_parent;
 	if (old_parent)
@@ -4721,11 +4725,10 @@ int device_move(struct device *dev, struct device *new_parent,
 					set_dev_node(dev, dev_to_node(old_parent));
 				}
 			}
-			cleanup_glue_dir(dev, new_parent_kobj);
-			put_device(new_parent);
-			goto out;
+			goto out_cleanup;
 		}
 	}
+	device_pm_lock();
 	switch (dpm_order) {
 	case DPM_ORDER_NONE:
 		break;
@@ -4742,10 +4745,19 @@ int device_move(struct device *dev, struct device *new_parent,
 		devices_kset_move_last(dev);
 		break;
 	}
+	device_pm_unlock();
+
+	device_unlock(dev);
 
 	put_device(old_parent);
-out:
-	device_pm_unlock();
+	put_device(dev);
+	return error;
+
+out_cleanup:
+	cleanup_glue_dir(dev, new_parent_kobj);
+	put_device(new_parent);
+out_unlock:
+	device_unlock(dev);
 	put_device(dev);
 	return error;
 }


base-commit: a90ee4305c4a5df72c11b31dacfdc76e00fcf78a
-- 
This is an AI-generated patch subject to moderation.
Reply with '#syz upstream' to Sign-off the patch as a human author
and send it to the upstream kernel mailing lists.
Reply with '#syz reject' to reject it ('#syz unreject' to undo).

See https://goo.gle/syzbot-ai-patches for information about AI-generated patches.
You can comment on the patch as usual, syzbot will try to address
the comments and send a new version of the patch if necessary.
syzbot engineers can be reached at syzkaller@googlegroups.com.
