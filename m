Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 68C593D9680
	for <syzbot@lists.linux.dev>; Mon, 28 Sep 2026 20:19:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790626800; cv=none; b=AA5MB2ZsLviXCjCormAy2lsWJaTpNex+foYKhJ0QH+S4mIh699EWmOemRnwoCk8uGQILXXvEtuTJgLzUWl9SPz/iyHmVNIJSNDaBmeWaaDr5V/vgfnVCjn6k/k9b7JzmLVIe1kCQDyAvdQ7Ji1uxbKSx6L72ATK6uAWZ7xmGKSU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790626800; c=relaxed/simple;
	bh=hItd+OPMyj7jmss6HGWxG3gyXRIi9v9aUZRMxGoj8I0=;
	h=From:To:Cc:Subject:Message-ID:MIME-Version:Content-Type:Date; b=ZFCv4JFiXR3kUzDe+BSoAZZ/9F19liTzOV0ERD7d5UTAGzJblIZSV4mVDa2YoBcIm6R5yWMWEFlLOihEo6sXXWblnvS79iqSdvGdZV1arB6nPOBh2Ln/9uKbwAVHie8DsNfIzFKiY5IMxdIQMQvlITTcX45Wg7F18iAzWaRY/aQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=UftjBObN; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="UftjBObN"
Received: by smtp.kernel.org (Postfix) with UTF8SMTPSA id C55DF1F000FF;
	Mon, 28 Sep 2026 20:19:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1790626797;
	bh=jfA/K0OhzfDrYX2LZ+BKYAxSQvWuQg+2bvx5YKRwZsc=;
	h=From:To:Cc:Subject:Date;
	b=UftjBObNsbE5lEA1E3M+k5I+ZWk42FHlGmG1fjuykBBGjjd2zY2ocRAlwSDxFNakN
	 D4i5dbfDqYZx7pbnPHErlBzjQ2Nsnz4Z/gfPLgMod8T8XgMB+q2yLluPI5buIlIwVt
	 lLsa3FxmMOfOZimBVwmjoTTFK5WjcXFc0O3550jt4ZOYvH6j1pF/b42BRILdE4gnwp
	 yIIKYfDiuSJSP+WlmCB68c7vF1rozCABgH4Ax7fcwLkh1JTX/BQHKKxMkoOLfNDkUD
	 Rr5vT3frGZ5RVRvY3nOVUx4xYLkavR3614r+o7H/napbVjY3/Cemwn3cQPB5n57N44
	 IdYSB78kTzrWQ==
From: "syzbot" <syzbot@kernel.org>
To: syzkaller-upstream-moderation@googlegroups.com
Cc: krystianmkaniewski@gmail.com, syzbot@lists.linux.dev
Subject: [PATCH RFC v4] usb: gadget: u_serial: pin ports while TTYs are installed
Message-ID: <e53f1fc8-ddd7-4dbf-be17-696c5c36b68a@mail.kernel.org>
Precedence: bulk
X-Mailing-List: syzbot@lists.linux.dev
List-Id: <syzbot.lists.linux.dev>
List-Subscribe: <mailto:syzbot+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:syzbot+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Date: Mon, 28 Sep 2026 20:19:57 +0000 (UTC)

A slab-use-after-free can occur when opening or closing a USB serial port
while the gadget is concurrently being unbound or destroyed. The lifetime
of struct gs_port was previously tracked only by port->port.count, with
teardown waiting on wait_event(port->close_wait, gs_closed(port)) where
gs_closed() checks whether count is zero. This leaves two intervals where
gs_port is actively referenced by the TTY core but port->port.count is
zero:

1. The install-to-open interval: when opening /dev/ttyGS*, the TTY layer
installs the port before invoking gs_open(). In this interval,
port->port.count is zero, so gs_closed() evaluates to true. If the gadget
is concurrently unbound or destroyed, gserial_free_port() does not wait and
frees gs_port, resulting in a slab-use-after-free write in tty_init_dev()
or tty_open().

2. The close-to-cleanup/release interval: when closing /dev/ttyGS*,
gs_close() decrements port->port.count to zero and wakes up close_wait.
Concurrently, gserial_free_port() wakes up and frees gs_port before
tty_release() finishes, causing a slab-use-after-free in release_tty() when
it accesses tty->port.

Fix these issues by managing the lifetime of struct gs_port with standard
tty_port reference counting. Pin the port during tty install and release it
in tty cleanup, deferring buffer and struct freeing to the port destructor
once all references are dropped.

Enforce port-generation validation in gs_open() under the port lock to
verify that the installed port matches the registered port, ensuring the
port was not unregistered or replaced between install and open. Track
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
Link: https://syzkaller.appspot.com/ai_job?id=47fc8e8b-9ef9-4e57-8471-e728e0d08b61
To: "Greg Kroah-Hartman" <gregkh@linuxfoundation.org>
To: <linux-usb@vger.kernel.org>
To: "Sebastian Andrzej Siewior" <bigeasy@linutronix.de>
Cc: "Ai Chao" <aichao@kylinos.cn>
Cc: "Kees Cook" <kees@kernel.org>
Cc: <linux-kernel@vger.kernel.org>

---
v4:
- Clarified in the commit message and comments that open_close_failures accounting is aggregate across the port rather than paired with individual files
- Cleared gs_tty_driver->ports[port_num] in gs_port_destruct()

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
index cdd1dfc66..89c4feb42 100644
--- a/drivers/usb/gadget/function/u_serial.c
+++ b/drivers/usb/gadget/function/u_serial.c
@@ -60,20 +60,40 @@
  * is managed in userspace ... OBEX, PTP, and MTP have been mentioned.
  *
  *
- * gserial is the lifecycle interface, used by USB functions
- * gs_port is the I/O nexus, used by the tty driver
- * tty_struct links to the tty/filesystem framework
+ * Lifecycle and state management:
+ *
+ * gserial is the lifecycle interface, used by USB functions.
+ * gs_port is the I/O nexus, used by the tty driver.
+ * tty_struct links to the tty/filesystem framework.
  *
  * gserial <---> gs_port ... links will be null when the USB link is
- * inactive; managed by gserial_{connect,disconnect}().  each gserial
+ * inactive; managed by gserial_{connect,disconnect}().  Each gserial
  * instance can wrap its own USB control protocol.
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
@@ -128,6 +148,7 @@ struct gs_port {
 	wait_queue_head_t	close_wait;
 	bool			suspended;	/* port suspended */
 	bool			start_delayed;	/* delay start when suspended */
+	unsigned int		open_close_failures; /* protected by tty_lock */
 	struct async_icount	icount;
 
 	/* REVISIT this state ... */
@@ -135,8 +156,9 @@ struct gs_port {
 };
 
 static struct portmaster {
-	struct mutex	lock;			/* protect open/close */
+	struct mutex	lock;			/* protect open/close and port slot */
 	struct gs_port	*port;
+	bool		reserved;
 } ports[MAX_U_SERIAL_PORTS];
 
 #define GS_CLOSE_TIMEOUT		15		/* seconds */
@@ -603,42 +625,81 @@ static int gserial_wakeup_host(struct gserial *gser)
 
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
 
 	/* allocate circular buffer on first open */
 	if (!kfifo_initialized(&port->port_write_buf)) {
-
 		spin_unlock_irq(&port->port_lock);
 
 		/*
 		 * portmaster's mutex still protects from simultaneous open(),
 		 * and close() can't happen, yet.
 		 */
-
 		status = kfifo_alloc(&port->port_write_buf,
 				     WRITE_BUF_SIZE, GFP_KERNEL);
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
@@ -1203,6 +1277,28 @@ static void gs_console_exit(struct gs_port *port)
 
 #endif
 
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
 static int
 gs_port_alloc(unsigned port_num, struct usb_cdc_line_coding *coding)
 {
@@ -1210,7 +1306,12 @@ gs_port_alloc(unsigned port_num, struct usb_cdc_line_coding *coding)
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
@@ -1235,6 +1337,7 @@ gs_port_alloc(unsigned port_num, struct usb_cdc_line_coding *coding)
 	port->port_num = port_num;
 	port->port_line_coding = *coding;
 
+	ports[port_num].reserved = true;
 	ports[port_num].port = port;
 out:
 	mutex_unlock(&ports[port_num].lock);
@@ -1258,8 +1361,7 @@ static void gserial_free_port(struct gs_port *port)
 	/* wait for old opens to finish */
 	wait_event(port->close_wait, gs_closed(port));
 	WARN_ON(port->port_usb != NULL);
-	tty_port_destroy(&port->port);
-	kfree(port);
+	tty_port_put(&port->port);
 }
 
 void gserial_free_line(unsigned char port_num)
@@ -1276,8 +1378,8 @@ void gserial_free_line(unsigned char port_num)
 	ports[port_num].port = NULL;
 	mutex_unlock(&ports[port_num].lock);
 
-	gserial_free_port(port);
 	tty_unregister_device(gs_tty_driver, port_num);
+	gserial_free_port(port);
 }
 EXPORT_SYMBOL_GPL(gserial_free_line);
 
@@ -1318,7 +1420,7 @@ int gserial_alloc_line_no_console(unsigned char *line_num)
 		mutex_lock(&ports[port_num].lock);
 		ports[port_num].port = NULL;
 		mutex_unlock(&ports[port_num].lock);
-		gserial_free_port(port);
+		tty_port_put(&port->port);
 		goto err;
 	}
 	*line_num = port_num;


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
