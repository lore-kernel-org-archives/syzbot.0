Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6217A1D5CFE
	for <syzbot@lists.linux.dev>; Thu,  1 Oct 2026 13:24:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790861051; cv=none; b=KJjeY0q+V9kXPK0PxFvXBXdk3v2b/uken0mXyuPiHhaka9+l6VJLS/1esZm3GWvIr1Qih1qsT52Z5md+fBb7WY0Ps6o9BeHd+3B4rSS4iYQ1FCXWniJq6hOLm5IGY2RPN6z07MP39FkWc3CUVxQQOYKOHWjPskVfee/gyJcMS3o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790861051; c=relaxed/simple;
	bh=eBN8bGxOCcMp6M/cndCyggMWkHXfF7LcSONLr4RB7fY=;
	h=From:To:Cc:Subject:Message-ID:MIME-Version:Content-Type:Date; b=FtmJ97HR/tijPDbypRygH6mSMqHlLtaj+Ec1V7lWuOWEG6/6XzmLd3tN7HV5waBLsYdIKYj/z4gl4QQFBLszJKerk1wJUtHl8nrHBvJ2/D5vEJNGHElQaw9jX+mR/fQiflyS1ozxaNlnP1K4GL5jOV5DltUKmMt4lRXOxDZ1NFw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=hfs2t9v0; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="hfs2t9v0"
Received: by smtp.kernel.org (Postfix) with UTF8SMTPSA id D3E261F000FF;
	Thu,  1 Oct 2026 13:24:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1790861049;
	bh=YcRJljrOsiavA2ofIgyOJUpxAMj2lK+6J13QJZ0ENuY=;
	h=From:To:Cc:Subject:Date;
	b=hfs2t9v0JdbHHdHVqt+gkqJCiKoTCfYypyI9udpV07wOOmaQrOTM5URbLWWHaLej2
	 YzZ4XQCdWko3ix6Mpl2RUpSVuDH3aw3f1aDg5/5+rXSe1F9jcFt3/ujy5lMJC/+amb
	 KGkI1/YciAG29qbfO+Cby8iEpZ1HhrLMzrvBr99391eVWmB/Dfuo+fCcaGuFYFfHRs
	 bqN82ut0SV7RzDpBr3caiPMOIJ+fFq0COuxau1ofau7JqnS2G/qiPgHRcd8lKVV3N8
	 xdwKB2fCdluVSp2ABZyGCI5R0vgJ8JDGmm8cR1lS/Tr2I7rdHH9k5bxU8xG6oWh+IE
	 SF0rpTl2TB+Sw==
From: "syzbot" <syzbot@kernel.org>
To: syzkaller-upstream-moderation@googlegroups.com
Cc: krystianmkaniewski@gmail.com, syzbot@lists.linux.dev
Subject: [PATCH RFC v5] usb: gadget: u_serial: pin ports while TTYs are installed
Message-ID: <4226681d-e7e2-4ef8-92a8-4374c06132db@mail.kernel.org>
Precedence: bulk
X-Mailing-List: syzbot@lists.linux.dev
List-Id: <syzbot.lists.linux.dev>
List-Subscribe: <mailto:syzbot+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:syzbot+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Date: Thu,  1 Oct 2026 13:24:08 +0000 (UTC)

A slab-use-after-free can occur when opening or closing a USB serial port
while removing the serial function instance via configfs rmdir, which
reaches acm_free_instance() and gserial_free_line() to free the port
(gadget unbind or gserial_disconnect() alone only disconnects without
freeing gs_port). The lifetime of struct gs_port was previously tracked
only by port->port.count, with teardown waiting on
wait_event(port->close_wait, gs_closed(port)) where gs_closed() checks
whether count is zero. This leaves two intervals where gs_port is actively
referenced by the TTY core but port->port.count is zero:

1. The install-to-open interval: when opening /dev/ttyGS*, the TTY layer
installs the port before invoking gs_open(). In this interval,
port->port.count is zero, so gs_closed() evaluates to true. If the serial
function instance is concurrently removed via configfs rmdir,
gserial_free_port() does not wait and frees gs_port, resulting in a
slab-use-after-free write in tty_init_dev() or tty_open().

2. The close-to-cleanup/release interval: when closing /dev/ttyGS*,
gs_close() decrements port->port.count to zero and wakes up close_wait.
Concurrently, gserial_free_port() wakes up and frees gs_port before
tty_release() finishes, causing a slab-use-after-free in release_tty() when
it accesses tty->port.

BUG: KASAN: slab-use-after-free in tty_init_dev+0x244/0x4d0
drivers/tty/tty_io.c:1397
Write of size 8 at addr ffff8881f8248128
Call Trace:
 <TASK>
 tty_init_dev+0x244/0x4d0 drivers/tty/tty_io.c:1397
 tty_open_by_driver drivers/tty/tty_io.c:2046 [inline]
 tty_open+0x7d9/0xcc0 drivers/tty/tty_io.c:2093
 chrdev_open+0x4d9/0x600 fs/char_dev.c:411
 do_dentry_open+0x816/0x1380 fs/open.c:996
 vfs_open+0x3b/0x340 fs/open.c:1101
 ...
 </TASK>

Allocated by task 5843:
 ...
 gs_port_alloc drivers/usb/gadget/function/u_serial.c:1218 [inline]
 gserial_alloc_line_no_console+0x232/0x6e0
 drivers/usb/gadget/function/u_serial.c:1298
 gserial_alloc_line+0x18/0x90 drivers/usb/gadget/function/u_serial.c:1332
 acm_alloc_instance+0xc7/0x140 drivers/usb/gadget/function/f_acm.c:891
 configfs_mkdir+0x4f6/0x9e0 fs/configfs/dir.c:1360
 ...

Freed by task 5843:
 ...
 kfree+0x1c5/0x650 mm/slub.c:6792
 gserial_free_port+0x248/0x2c0 drivers/usb/gadget/function/u_serial.c:1262
 gserial_free_line+0xc0/0x1f0 drivers/usb/gadget/function/u_serial.c:1279
 acm_free_instance+0x39/0x60 drivers/usb/gadget/function/f_acm.c:875
 configfs_rmdir+0x885/0x950 fs/configfs/dir.c:1571
 ...

Fix these issues by managing the lifetime of struct gs_port with standard
tty_port reference counting. Pin the port during tty install and release it
in tty cleanup, deferring buffer and struct freeing to the port destructor
once all references are dropped.

Enforce port validation in gs_open() under the portmaster mutex
(ports[port_num].lock) to verify that the installed port matches the
registered port, ensuring the port was not unregistered or replaced between
install and open. Defer publishing the port pointer in ports[port_num].port
until after tty_port_register_device() succeeds; this deferred publication
prevents a concurrent gs_install() from accessing saved termios while
tty_register_device_attr() frees them upon registration failure. Track
failed opens as aggregate credits across the port rather than paired with
individual files (another gs_close() can consume a failed open's credit
before that file's own close runs), allowing gs_close() called by the TTY
core on failure to exit cleanly without altering open counts. Finally,
delay minor reuse to protect saved termios by keeping the slot reserved
until port destruction completes and unregistering the device before
dropping the driver's port reference.

Fixes: 19b10a8828a6 ("usb: gadget: allocate & giveback serial ports instead hard code them")
Assisted-by: Gemini:gemini-3.8-flash syzbot
Reported-by: syzbot+fe63e4d633540f230624@syzkaller.appspotmail.com
Closes: https://syzkaller.appspot.com/bug?extid=fe63e4d633540f230624
Link: https://syzkaller.appspot.com/ai_job?id=80d6efd5-e349-4663-8b4d-c08e605a4517
To: "Greg Kroah-Hartman" <gregkh@linuxfoundation.org>
To: <linux-usb@vger.kernel.org>
To: "Sebastian Andrzej Siewior" <bigeasy@linutronix.de>
Cc: "Ai Chao" <aichao@kylinos.cn>
Cc: "Kees Cook" <kees@kernel.org>
Cc: <linux-kernel@vger.kernel.org>

---
v5:
- Defer publishing ports[port_num].port until after tty_port_register_device() succeeds to avoid racing with gs_install().
- Return struct gs_port * from gs_port_alloc() instead of assigning ports[port_num].port early.
- Simplify error handling in gserial_alloc_line_no_console() on registration failure.
- Update commit message to explain deferred port publication ordering and its protection of saved termios.
- Correct commit message to refer to the portmaster mutex (ports[port_num].lock) rather than the port lock.
- Clarify in commit message that port freeing is triggered by configfs rmdir reaching acm_free_instance() and gserial_free_line().
- Include relevant KASAN report traces in commit message.

v4:
- Clarified in the commit message and comments that open_close_failures accounting is aggregate across the port rather than paired with individual files
- Cleared gs_tty_driver->ports[port_num] in gs_port_destruct()
https://lore.kernel.org/all/e53f1fc8-ddd7-4dbf-be17-696c5c36b68a@mail.kernel.org/T/

v3:
- Clarify the lifecycle comment and slot invariant.
- Shorten the commit message by removing the full call trace and condensing implementation details.
https://lore.kernel.org/all/1e5c22f0-19bc-4c1f-9638-6ae619179e29@mail.kernel.org/T/

v2:
- Added minor reservation tracking (`reserved` flag) released in `gs_port_destruct()` to delay minor reuse and protect saved termios.
- Reordered `tty_unregister_device()` to run before `gserial_free_port()` in `gserial_free_line()`.
- Added an `open_close_failures` counter to pair failed `gs_open()` calls with matching `gs_close()` invocations without corrupting `port->port.count`.
- Added installed-port identity verification in `gs_open()` against the registered port slot.
- Retained `ports[].lock` across `tty_port_install()` and `tty->driver_data` assignment in `gs_install()`.
- Replaced `gserial_free_port()` with `tty_port_put()` on error path in `gserial_alloc_line_no_console()`.
https://lore.kernel.org/all/5dc8c18b-cfac-4e42-a158-b5e92bab89ca@mail.kernel.org/T/

v1:
https://lore.kernel.org/all/acde99b9-2954-43ab-8403-6ca10699472d@mail.kernel.org/T/
---
diff --git a/drivers/usb/gadget/function/u_serial.c b/drivers/usb/gadget/function/u_serial.c
index cdd1dfc66..e4bbf4211 100644
--- a/drivers/usb/gadget/function/u_serial.c
+++ b/drivers/usb/gadget/function/u_serial.c
@@ -70,10 +70,28 @@
  *	gserial->ioport == usb_ep->driver_data ... gs_port
  *	gs_port->port_usb ... gserial
  *
- * gs_port <---> tty_struct ... links will be null when the TTY file
- * isn't opened; managed by gs_open()/gs_close()
- *	gserial->port_tty ... tty_struct
- *	tty_struct->driver_data ... gserial
+ * gs_port <---> tty_struct:
+ *	tty->driver_data refers to gs_port from install through cleanup,
+ *	pinning the port via tty_port reference counting.
+ *	gs_port->port.tty exists only while the port is open.
+ *
+ * Each entry in ports[] is guarded by ports[i].lock and models three states:
+ *   - Free:      !port && !reserved
+ *   - Published:  port &&  reserved
+ *   - Retiring:  !port &&  reserved
+ *
+ * A minor remains reserved until gs_port_destruct() runs upon final tty_port
+ * release, preventing minor reuse while cleanup or termios saving is still
+ * underway. The owner reference is retained through device unregister so the
+ * destructor releases the reservation only after device teardown is complete.
+ *
+ * open_close_failures tracks failed gs_open() calls where port->port.count
+ * was not incremented. The TTY core calls gs_close() on open failure to tear
+ * down the tty; tracking failures as aggregate credits allows gs_close() to
+ * consume a credit and exit without decrementing port->port.count. Credits
+ * are aggregate rather than paired with individual files (another gs_close()
+ * can consume a failed open's credit before that file's own close runs).
+ * It is protected by tty_lock.
  */
 
 /* RX and TX queues can buffer QUEUE_SIZE packets before they hit the
@@ -128,6 +146,7 @@ struct gs_port {
 	wait_queue_head_t	close_wait;
 	bool			suspended;	/* port suspended */
 	bool			start_delayed;	/* delay start when suspended */
+	unsigned int		open_close_failures; /* protected by tty_lock */
 	struct async_icount	icount;
 
 	/* REVISIT this state ... */
@@ -135,8 +154,9 @@ struct gs_port {
 };
 
 static struct portmaster {
-	struct mutex	lock;			/* protect open/close */
+	struct mutex	lock;			/* protect open/close and port slot */
 	struct gs_port	*port;
+	bool		reserved;
 } ports[MAX_U_SERIAL_PORTS];
 
 #define GS_CLOSE_TIMEOUT		15		/* seconds */
@@ -603,22 +623,63 @@ static int gserial_wakeup_host(struct gserial *gser)
 
 /* TTY Driver */
 
+static int gs_install(struct tty_driver *driver, struct tty_struct *tty)
+{
+	struct gs_port *port;
+	struct tty_port *tport;
+	int ret;
+
+	mutex_lock(&ports[tty->index].lock);
+	port = ports[tty->index].port;
+	if (!port) {
+		mutex_unlock(&ports[tty->index].lock);
+		return -ENODEV;
+	}
+
+	tport = tty_port_get(&port->port);
+	if (!tport) {
+		mutex_unlock(&ports[tty->index].lock);
+		return -ENODEV;
+	}
+
+	ret = tty_port_install(tport, driver, tty);
+	if (ret) {
+		mutex_unlock(&ports[tty->index].lock);
+		tty_port_put(tport);
+		return ret;
+	}
+
+	tty->driver_data = port;
+	mutex_unlock(&ports[tty->index].lock);
+
+	return 0;
+}
+
+static void gs_cleanup(struct tty_struct *tty)
+{
+	tty_port_put(tty->port);
+}
+
 /*
- * gs_open sets up the link between a gs_port and its associated TTY.
- * That link is broken *only* by TTY close(), and all driver methods
- * know that.
+ * gs_open associates an open TTY with its gs_port.
+ *
+ * There are two TTY-to-port relationships: port->port.tty exists from the
+ * first successful open until final close, while tty->driver_data is assigned
+ * during gs_install() and remains valid through gs_cleanup().
  */
 static int gs_open(struct tty_struct *tty, struct file *file)
 {
 	int		port_num = tty->index;
-	struct gs_port	*port;
+	struct gs_port	*port = tty->driver_data;
 	int		status = 0;
 
+	if (!port)
+		return -ENODEV;
+
 	mutex_lock(&ports[port_num].lock);
-	port = ports[port_num].port;
-	if (!port) {
+	if (ports[port_num].port != port) {
 		status = -ENODEV;
-		goto out;
+		goto fail_unlock;
 	}
 
 	spin_lock_irq(&port->port_lock);
@@ -638,7 +699,7 @@ static int gs_open(struct tty_struct *tty, struct file *file)
 		if (status) {
 			pr_debug("gs_open: ttyGS%d (%p,%p) no buffer\n",
 				 port_num, tty, file);
-			goto out;
+			goto fail_unlock;
 		}
 
 		spin_lock_irq(&port->port_lock);
@@ -648,7 +709,6 @@ static int gs_open(struct tty_struct *tty, struct file *file)
 	if (port->port.count++)
 		goto exit_unlock_port;
 
-	tty->driver_data = port;
 	port->port.tty = tty;
 
 	/* if connected, start the I/O stream */
@@ -672,7 +732,11 @@ static int gs_open(struct tty_struct *tty, struct file *file)
 
 exit_unlock_port:
 	spin_unlock_irq(&port->port_lock);
-out:
+	mutex_unlock(&ports[port_num].lock);
+	return status;
+
+fail_unlock:
+	port->open_close_failures++;
 	mutex_unlock(&ports[port_num].lock);
 	return status;
 }
@@ -695,6 +759,14 @@ static void gs_close(struct tty_struct *tty, struct file *file)
 	struct gs_port *port = tty->driver_data;
 	struct gserial	*gser;
 
+	if (!port)
+		return;
+
+	if (port->open_close_failures > 0) {
+		port->open_close_failures--;
+		return;
+	}
+
 	spin_lock_irq(&port->port_lock);
 
 	if (port->port.count != 1) {
@@ -909,8 +981,10 @@ static int gs_get_icount(struct tty_struct *tty,
 }
 
 static const struct tty_operations gs_tty_ops = {
+	.install =		gs_install,
 	.open =			gs_open,
 	.close =		gs_close,
+	.cleanup =		gs_cleanup,
 	.write =		gs_write,
 	.put_char =		gs_put_char,
 	.flush_chars =		gs_flush_chars,
@@ -1203,14 +1277,41 @@ static void gs_console_exit(struct gs_port *port)
 
 #endif
 
-static int
+static void gs_port_destruct(struct tty_port *tport)
+{
+	struct gs_port *port = container_of(tport, struct gs_port, port);
+	unsigned int port_num = port->port_num;
+
+	mutex_lock(&ports[port_num].lock);
+	if (WARN_ON(ports[port_num].port))
+		ports[port_num].port = NULL;
+	WARN_ON(!ports[port_num].reserved);
+	if (gs_tty_driver)
+		gs_tty_driver->ports[port_num] = NULL;
+	ports[port_num].reserved = false;
+	mutex_unlock(&ports[port_num].lock);
+
+	kfifo_free(&port->port_write_buf);
+	kfree(port);
+}
+
+static const struct tty_port_operations gs_port_ops = {
+	.destruct = gs_port_destruct,
+};
+
+static struct gs_port *
 gs_port_alloc(unsigned port_num, struct usb_cdc_line_coding *coding)
 {
 	struct gs_port	*port;
 	int		ret = 0;
 
 	mutex_lock(&ports[port_num].lock);
-	if (ports[port_num].port) {
+	if (WARN_ON_ONCE(ports[port_num].port && !ports[port_num].reserved)) {
+		ret = -EBUSY;
+		goto out;
+	}
+
+	if (ports[port_num].reserved) {
 		ret = -EBUSY;
 		goto out;
 	}
@@ -1222,6 +1323,7 @@ gs_port_alloc(unsigned port_num, struct usb_cdc_line_coding *coding)
 	}
 
 	tty_port_init(&port->port);
+	port->port.ops = &gs_port_ops;
 	spin_lock_init(&port->port_lock);
 	init_waitqueue_head(&port->drain_wait);
 	init_waitqueue_head(&port->close_wait);
@@ -1235,10 +1337,13 @@ gs_port_alloc(unsigned port_num, struct usb_cdc_line_coding *coding)
 	port->port_num = port_num;
 	port->port_line_coding = *coding;
 
-	ports[port_num].port = port;
+	ports[port_num].reserved = true;
+	mutex_unlock(&ports[port_num].lock);
+	return port;
+
 out:
 	mutex_unlock(&ports[port_num].lock);
-	return ret;
+	return ERR_PTR(ret);
 }
 
 static int gs_closed(struct gs_port *port)
@@ -1258,8 +1363,7 @@ static void gserial_free_port(struct gs_port *port)
 	/* wait for old opens to finish */
 	wait_event(port->close_wait, gs_closed(port));
 	WARN_ON(port->port_usb != NULL);
-	tty_port_destroy(&port->port);
-	kfree(port);
+	tty_port_put(&port->port);
 }
 
 void gserial_free_line(unsigned char port_num)
@@ -1276,15 +1380,15 @@ void gserial_free_line(unsigned char port_num)
 	ports[port_num].port = NULL;
 	mutex_unlock(&ports[port_num].lock);
 
-	gserial_free_port(port);
 	tty_unregister_device(gs_tty_driver, port_num);
+	gserial_free_port(port);
 }
 EXPORT_SYMBOL_GPL(gserial_free_line);
 
 int gserial_alloc_line_no_console(unsigned char *line_num)
 {
 	struct usb_cdc_line_coding	coding;
-	struct gs_port			*port;
+	struct gs_port			*port = ERR_PTR(-EBUSY);
 	struct device			*tty_dev;
 	int				ret;
 	int				port_num;
@@ -1295,19 +1399,20 @@ int gserial_alloc_line_no_console(unsigned char *line_num)
 	coding.bDataBits = USB_CDC_1_STOP_BITS;
 
 	for (port_num = 0; port_num < MAX_U_SERIAL_PORTS; port_num++) {
-		ret = gs_port_alloc(port_num, &coding);
-		if (ret == -EBUSY)
-			continue;
-		if (ret)
+		port = gs_port_alloc(port_num, &coding);
+		if (IS_ERR(port)) {
+			ret = PTR_ERR(port);
+			if (ret == -EBUSY)
+				continue;
 			return ret;
+		}
 		break;
 	}
-	if (ret)
-		return ret;
+	if (IS_ERR(port))
+		return PTR_ERR(port);
 
 	/* ... and sysfs class devices, so mdev/udev make /dev/ttyGS* */
 
-	port = ports[port_num].port;
 	tty_dev = tty_port_register_device(&port->port,
 			gs_tty_driver, port_num, NULL);
 	if (IS_ERR(tty_dev)) {
@@ -1315,15 +1420,16 @@ int gserial_alloc_line_no_console(unsigned char *line_num)
 				__func__, port_num, PTR_ERR(tty_dev));
 
 		ret = PTR_ERR(tty_dev);
-		mutex_lock(&ports[port_num].lock);
-		ports[port_num].port = NULL;
-		mutex_unlock(&ports[port_num].lock);
-		gserial_free_port(port);
-		goto err;
+		tty_port_put(&port->port);
+		return ret;
 	}
+
+	mutex_lock(&ports[port_num].lock);
+	ports[port_num].port = port;
+	mutex_unlock(&ports[port_num].lock);
+
 	*line_num = port_num;
-err:
-	return ret;
+	return 0;
 }
 EXPORT_SYMBOL_GPL(gserial_alloc_line_no_console);
 


base-commit: df2908090cda368b01ff43709f51890076c56157
-- 
This is an AI-generated patch subject to moderation.
Reply with '#syz upstream' to Sign-off the patch as a human author
and send it to the upstream kernel mailing lists.
Reply with '#syz reject' to reject it ('#syz unreject' to undo).

See https://goo.gle/syzbot-ai-patches for information about AI-generated patches.
You can comment on the patch as usual, syzbot will try to address
the comments and send a new version of the patch if necessary.
syzbot engineers can be reached at syzkaller@googlegroups.com.
