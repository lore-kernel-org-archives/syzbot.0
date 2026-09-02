Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9A0BF3793BC
	for <syzbot@lists.linux.dev>; Wed,  2 Sep 2026 21:21:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788384100; cv=none; b=e1TAkop4mGpaWtoQ2yDddetN+KU3uLIhzQEiP3DCMzXfGvwT7KzaJrs7b2y8TKsTabE2CzKvyI/gwJusNdD0MzTtOsRK5WKU6QBlHPMw6cd+p7zDX3h4zylNwTohAkzY2/uM9cop4BSqdzU8I4+t8MZ7RU3EC+RTdLlkQvoIg28=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788384100; c=relaxed/simple;
	bh=pxTUW4nrNSE4pWUwZvtl817JhuA3uXdm4/rPnSqr/ng=;
	h=From:To:Cc:Subject:Message-ID:MIME-Version:Content-Type:Date; b=PeFwcM2VCbxIn3uQh42o10J1hZh13zAS4FdBcyHf2bM3RRSm3q7lM8dLfW41kLXXLh7kx1vriveI9D1hB4Vr6Z+mP92ccDdjjSkqxtxcC4xdWm7qjgNaB7v3LJjxdWGhmi49G+eV6XwLAfHqUJQVwJJdhhb3MOwEz4PRFoXVrT8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=SWfwJR8o; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="SWfwJR8o"
Received: by smtp.kernel.org (Postfix) with UTF8SMTPSA id 512B51F00A3F;
	Wed,  2 Sep 2026 21:21:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788384092;
	bh=3JPzX5qv7w18iu5Vn+C4O3VHY8rJTubEeliU+0kmwJs=;
	h=From:To:Cc:Subject:Date;
	b=SWfwJR8odPkV9PciiJQOFk7yMN0Ky6bZqHcXLQcpLt3Aus4u2bt7GBb5dj/sz5gqM
	 or48koAf8j95zpY6xyEOo4a/FLieBrigSM+QRDWQuxbJiFQM3PAcNZBfwxnq5mX7rZ
	 GHLQ9dXF/vK6wXGh1SmhVp0GhcBOC2/pW2GrvAjBrecErptpC7vjRGbp9hzbeUS4Bl
	 3IzTeGvkUxh5dDczbRfAw/Iv1nqgMN2V2TgUzKecaK78zszp0KNPlf7LUTxNFW830e
	 0Hp+y/JG7dgEzaY+phbzupprvhmdlXI6GDL2EulMfCr9NXCVr3uhHto3J1ymFRx4h2
	 fwWHbbh7tr2Iw==
From: "syzbot" <syzbot@kernel.org>
To: syzkaller-upstream-moderation@googlegroups.com
Cc: syzbot@lists.linux.dev
Subject: [PATCH RFC] HID: roccat: use kref to fix use-after-free and memory leak
Message-ID: <6b483e4d-2805-4cf9-a3ea-f026e5d56d9a@mail.kernel.org>
Precedence: bulk
X-Mailing-List: syzbot@lists.linux.dev
List-Id: <syzbot.lists.linux.dev>
List-Subscribe: <mailto:syzbot+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:syzbot+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Date: Wed,  2 Sep 2026 21:21:32 +0000 (UTC)

A race condition exists between roccat_disconnect() and roccat_release()
that leads to a slab-use-after-free. When a device is disconnected,
roccat_disconnect() retrieves the device pointer from the devices[minor]
array and releases devices_lock before calling device_destroy(). If user
space concurrently closes the character device file descriptor,
roccat_release() acquires devices_lock, decrements device->open to 0,
observes that device->exist is 0, and frees the struct roccat_device via
roccat_free_device(). When roccat_disconnect() resumes execution, it
accesses device->open on the already freed memory, triggering a
use-after-free:

BUG: KASAN: slab-use-after-free in roccat_disconnect+0x246/0x250
drivers/hid/hid-roccat.c:382
Read of size 4 at addr ffff888121acd808 by task kworker/0:1/10

Call Trace:
 <TASK>
 kasan_report+0x117/0x150 mm/kasan/report.c:595
 roccat_disconnect+0x246/0x250 drivers/hid/hid-roccat.c:382
 savu_remove_specials drivers/hid/hid-roccat-savu.c:110 [inline]
 savu_remove+0xe9/0x160 drivers/hid/hid-roccat-savu.c:150
 hid_device_remove+0xc8/0x1d0 drivers/hid/hid-core.c:2897
 device_remove drivers/base/dd.c:616 [inline]
 __device_release_driver drivers/base/dd.c:1349 [inline]
 device_release_driver_internal+0x48b/0x880 drivers/base/dd.c:1372
 bus_remove_device+0x449/0x560 drivers/base/bus.c:664
 device_del+0x528/0x8f0 drivers/base/core.c:3965
 </TASK>

Allocated by task 10:
 roccat_connect+0x5d/0x4b0 drivers/hid/hid-roccat.c:315
 savu_init_specials drivers/hid/hid-roccat-savu.c:84 [inline]
 savu_probe+0x18e/0x340 drivers/hid/hid-roccat-savu.c:134
 hid_device_probe+0x46a/0x870 drivers/hid/hid-core.c:2878

Freed by task 6361:
 kfree+0x1c5/0x6d0 mm/slub.c:6792
 roccat_release+0x2b3/0x380 drivers/hid/hid-roccat.c:238
 __fput+0x42a/0xa80 fs/file_table.c:512

Additionally, roccat_release() and roccat_ioctl() looked up the device
using the global devices[minor] array. If roccat_disconnect() cleared
devices[minor] to NULL before roccat_release() ran, roccat_release() failed
with -ENODEV and returned early without freeing the reader struct or
decrementing device->open, leaking both reader and device.

Fix these issues by managing the lifetime of struct roccat_device with
reference counting (kref):
- Embed struct kref in struct roccat_device and initialize it in
roccat_connect().
- Increment the reference count in roccat_open() for each opened file
descriptor.
- Convert roccat_free_device() into a kref release callback invoked via
kref_put() in roccat_disconnect() and roccat_release(), ensuring the
structure is only freed when the device is disconnected and all file
descriptors are closed.
- Retrieve struct roccat_device directly from reader->device (stored in
file->private_data) in roccat_release() and roccat_ioctl() rather than
looking up devices[minor].
- Synchronize device->exist and device->open under device->readers_lock.
- Add bounds checking and device existence checks in roccat_report_event().

Fixes: e6fa47af5542 ("HID: roccat: Fix bug that prevented roccat chardev from removing devices")
Assisted-by: Gemini:gemini-3.7-flash Gemini:gemini-3.1-pro-preview syzbot
Reported-by: syzbot+c492a9e154f81127551f@syzkaller.appspotmail.com
Closes: https://syzkaller.appspot.com/bug?extid=c492a9e154f81127551f
Link: https://syzkaller.appspot.com/ai_job?id=01ccbae5-1a81-4a52-8c81-46a50f2410b6
To: "Benjamin Tissoires" <bentiss@kernel.org>
To: "Stefan Achatz" <erazor_de@users.sourceforge.net>
To: "Jiri Kosina" <jikos@kernel.org>
To: <linux-input@vger.kernel.org>
Cc: <linux-kernel@vger.kernel.org>

---
diff --git a/drivers/hid/hid-roccat.c b/drivers/hid/hid-roccat.c
index 4f15eb951..eaa47bbb7 100644
--- a/drivers/hid/hid-roccat.c
+++ b/drivers/hid/hid-roccat.c
@@ -21,8 +21,10 @@
 #define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
 
 #include <linux/cdev.h>
+#include <linux/kref.h>
 #include <linux/poll.h>
 #include <linux/sched/signal.h>
+#include <linux/slab.h>
 #include <linux/hid-roccat.h>
 #include <linux/module.h>
 
@@ -37,6 +39,7 @@ struct roccat_report {
 };
 
 struct roccat_device {
+	struct kref kref;
 	unsigned int minor;
 	int report_size;
 	int open;
@@ -70,8 +73,10 @@ static struct roccat_device *devices[ROCCAT_MAX_DEVICES];
 /* protects modifications of devices array */
 static DEFINE_MUTEX(devices_lock);
 
-static void roccat_free_device(struct roccat_device *device)
+static void roccat_free_device(struct kref *kref)
 {
+	struct roccat_device *device =
+		container_of(kref, struct roccat_device, kref);
 	int i;
 
 	for (i = 0; i < ROCCAT_CBUF_SIZE; i++)
@@ -172,11 +177,21 @@ static int roccat_open(struct inode *inode, struct file *file)
 	if (!device) {
 		pr_emerg("roccat device with minor %d doesn't exist\n", minor);
 		error = -ENODEV;
-		goto exit_err_devices;
+		mutex_unlock(&devices_lock);
+		kfree(reader);
+		return error;
 	}
 
+	kref_get(&device->kref);
+	mutex_unlock(&devices_lock);
+
 	mutex_lock(&device->readers_lock);
 
+	if (!device->exist) {
+		error = -ENODEV;
+		goto exit_err_readers;
+	}
+
 	if (!device->open++) {
 		/* power on device on adding first reader */
 		error = hid_hw_power(device->hid, PM_HINT_FULLON);
@@ -200,46 +215,35 @@ static int roccat_open(struct inode *inode, struct file *file)
 	list_add_tail(&reader->node, &device->readers);
 	file->private_data = reader;
 
+	mutex_unlock(&device->readers_lock);
+	return 0;
+
 exit_err_readers:
 	mutex_unlock(&device->readers_lock);
-exit_err_devices:
-	mutex_unlock(&devices_lock);
-	if (error)
-		kfree(reader);
+	kref_put(&device->kref, roccat_free_device);
+	kfree(reader);
 	return error;
 }
 
 static int roccat_release(struct inode *inode, struct file *file)
 {
-	unsigned int minor = iminor(inode);
 	struct roccat_reader *reader = file->private_data;
-	struct roccat_device *device;
-
-	mutex_lock(&devices_lock);
-
-	device = devices[minor];
-	if (!device) {
-		mutex_unlock(&devices_lock);
-		pr_emerg("roccat device with minor %d doesn't exist\n", minor);
-		return -ENODEV;
-	}
+	struct roccat_device *device = reader->device;
 
 	mutex_lock(&device->readers_lock);
 	list_del(&reader->node);
-	mutex_unlock(&device->readers_lock);
-	kfree(reader);
 
 	if (!--device->open) {
 		/* removing last reader */
 		if (device->exist) {
 			hid_hw_power(device->hid, PM_HINT_NORMAL);
 			hid_hw_close(device->hid);
-		} else {
-			roccat_free_device(device);
 		}
 	}
+	mutex_unlock(&device->readers_lock);
 
-	mutex_unlock(&devices_lock);
+	kfree(reader);
+	kref_put(&device->kref, roccat_free_device);
 
 	return 0;
 }
@@ -260,7 +264,12 @@ int roccat_report_event(int minor, u8 const *data)
 	struct roccat_report *report;
 	uint8_t *new_value;
 
+	if (minor < 0 || minor >= ROCCAT_MAX_DEVICES)
+		return -EINVAL;
+
 	device = devices[minor];
+	if (!device)
+		return -ENODEV;
 
 	new_value = kmemdup(data, device->report_size, GFP_ATOMIC);
 	if (!new_value)
@@ -316,6 +325,16 @@ int roccat_connect(const struct class *klass, struct hid_device *hid, int report
 	if (!device)
 		return -ENOMEM;
 
+	kref_init(&device->kref);
+	init_waitqueue_head(&device->wait);
+	INIT_LIST_HEAD(&device->readers);
+	mutex_init(&device->readers_lock);
+	mutex_init(&device->cbuf_lock);
+	device->hid = hid;
+	device->exist = 1;
+	device->cbuf_end = 0;
+	device->report_size = report_size;
+
 	mutex_lock(&devices_lock);
 
 	for (minor = 0; minor < ROCCAT_MAX_DEVICES; ++minor) {
@@ -332,6 +351,8 @@ int roccat_connect(const struct class *klass, struct hid_device *hid, int report
 		return -EINVAL;
 	}
 
+	device->minor = minor;
+
 	device->dev = device_create(klass, &hid->dev,
 			MKDEV(roccat_major, minor), NULL,
 			"%s%s%d", "roccat", hid->driver->name, minor);
@@ -346,16 +367,6 @@ int roccat_connect(const struct class *klass, struct hid_device *hid, int report
 
 	mutex_unlock(&devices_lock);
 
-	init_waitqueue_head(&device->wait);
-	INIT_LIST_HEAD(&device->readers);
-	mutex_init(&device->readers_lock);
-	mutex_init(&device->cbuf_lock);
-	device->minor = minor;
-	device->hid = hid;
-	device->exist = 1;
-	device->cbuf_end = 0;
-	device->report_size = report_size;
-
 	return minor;
 }
 EXPORT_SYMBOL_GPL(roccat_connect);
@@ -367,42 +378,37 @@ void roccat_disconnect(int minor)
 {
 	struct roccat_device *device;
 
+	if (minor < 0 || minor >= ROCCAT_MAX_DEVICES)
+		return;
+
 	mutex_lock(&devices_lock);
 	device = devices[minor];
+	devices[minor] = NULL;
 	mutex_unlock(&devices_lock);
 
-	device->exist = 0; /* TODO exist maybe not needed */
+	if (!device)
+		return;
 
 	device_destroy(device->dev->class, MKDEV(roccat_major, minor));
 
-	mutex_lock(&devices_lock);
-	devices[minor] = NULL;
-	mutex_unlock(&devices_lock);
-
+	mutex_lock(&device->readers_lock);
+	device->exist = 0;
 	if (device->open) {
 		hid_hw_close(device->hid);
 		wake_up_interruptible(&device->wait);
-	} else {
-		roccat_free_device(device);
 	}
+	mutex_unlock(&device->readers_lock);
+
+	kref_put(&device->kref, roccat_free_device);
 }
 EXPORT_SYMBOL_GPL(roccat_disconnect);
 
 static long roccat_ioctl(struct file *file, unsigned int cmd, unsigned long arg)
 {
-	struct inode *inode = file_inode(file);
-	struct roccat_device *device;
-	unsigned int minor = iminor(inode);
+	struct roccat_reader *reader = file->private_data;
+	struct roccat_device *device = reader->device;
 	long retval = 0;
 
-	mutex_lock(&devices_lock);
-
-	device = devices[minor];
-	if (!device) {
-		retval = -ENODEV;
-		goto out;
-	}
-
 	switch (cmd) {
 	case ROCCATIOCGREPSIZE:
 		if (put_user(device->report_size, (int __user *)arg))
@@ -411,8 +417,7 @@ static long roccat_ioctl(struct file *file, unsigned int cmd, unsigned long arg)
 	default:
 		retval = -ENOTTY;
 	}
-out:
-	mutex_unlock(&devices_lock);
+
 	return retval;
 }
 


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
