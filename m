Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1A1F24BF94A;
	Fri,  2 Oct 2026 15:54:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790956502; cv=none; b=pB9jGiVS1yolTPCZc7RD6Tz9R1dGbNnzl+xEL06c1x5/DILsS4QuS/5zCQYoHrxKpAvmx9gaoWYIURfSmvmFjN6etUc1SYp7qx4mw02VkHtisOOkdcF65kNb3G7PA9RDFgZKxH2J8EM9qIGM4zWgMb+W7vK7H/20NYMhU05Kb9I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790956502; c=relaxed/simple;
	bh=QeIB8FIwClEuHoSXhmFICLeKpPAISYAuaZpYo+1tLkc=;
	h=From:To:Cc:Subject:Message-ID:MIME-Version:Content-Type:Date; b=of+3f1lblwwX14O7moWmrYwnD+8jxsz+asBsOCACx0dM7QonQIgu+4j5MxEne8zxQpC+BhK+ecB5CWNSrQtLqMgG6e39CpONTzdDyaqhmH5l+QFS2wkbGelViaK88hYC7gux0qxOB6ciA6M1GHqnko+M6YxuqiRyA5mBOIBJ3RM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=aP9f1I+B; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="aP9f1I+B"
Received: by smtp.kernel.org (Postfix) with UTF8SMTPSA id 3ABCE1F000FF;
	Fri,  2 Oct 2026 15:54:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1790956494;
	bh=WFujwnzdjUGFy+TVg5vvBKDLsUDq8dhtgaheVBaIwHY=;
	h=From:To:Cc:Subject:Date;
	b=aP9f1I+BpA3k2i6rtaGlfV8SwceeVlP8+wQwgbLCrdP1on6kqjfiUWWaHfhxot13b
	 e0zof2NTaYc5jE6MC4a2SpE6qE76E9iZVAvO3CSMkcDQML5LrmeSSxeV3PsAvFSxCO
	 4CciQQR+Srlr87Rx2BM/HCrGabOfNOO/ekk+pxkyKGZoxrAfi0E5g7x61VkP9YVHtU
	 R6LSh5tctLqsTYhpKY+x224UHJKB7NhFh+f8rejTEQONfWlRiltufMim7dnhvTSkMx
	 Fcf7GuaywNpaltZntT4jRpeUAxX6bumm+d33IczgKoDLIAmQkuo4WDDNKMKUcoInGq
	 zDCnSgMtsMWyA==
From: "syzbot" <syzbot@kernel.org>
To: syzkaller-bugs@googlegroups.com, Krystian Kaniewski <krystianmkaniewski@gmail.com>, "Greg Kroah-Hartman" <gregkh@linuxfoundation.org>, <linux-usb@vger.kernel.org>, "Sebastian Andrzej Siewior" <bigeasy@linutronix.de>
Cc: aichao@kylinos.cn, kees@kernel.org, linux-kernel@vger.kernel.org, syzbot@lists.linux.dev
Subject: [PATCH] usb: gadget: u_serial: pin ports while TTYs are installed
Message-ID: <6941beb7-8cae-4cc5-ba07-e1c8a8753fe1@mail.kernel.org>
Precedence: bulk
X-Mailing-List: syzbot@lists.linux.dev
List-Id: <syzbot.lists.linux.dev>
List-Subscribe: <mailto:syzbot+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:syzbot+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Date: Fri,  2 Oct 2026 15:54:54 +0000 (UTC)

From: Krystian Kaniewski <krystianmkaniewski@gmail.com>

A slab-use-after-free can occur when gserial_free_line() frees struct
gs_port while it is still reachable by the TTY core. In the reported trace,
the write in tty_init_dev() occurs while the TTY is installed because the
port is freed while its TTY device is still registered and the driver table
still points to it.

BUG: KASAN: slab-use-after-free in tty_init_dev+0x244/0x4d0
drivers/tty/tty_io.c:1397
Call Trace:
 <TASK>
 tty_init_dev+0x244/0x4d0 drivers/tty/tty_io.c:1397
 tty_open_by_driver drivers/tty/tty_io.c:2046 [inline]
 tty_open+0x7d9/0xcc0 drivers/tty/tty_io.c:2093
 chrdev_open+0x4d9/0x600 fs/char_dev.c:411
 do_dentry_open+0x816/0x1380 fs/open.c:996
 vfs_open+0x3b/0x340 fs/open.c:1101
 </TASK>

Fix this by managing the lifetime of struct gs_port with tty_port reference
counting. Pin the port during gs_install() and release it in gs_cleanup(),
deferring freeing to gs_port_destruct() once all references are dropped. In
gserial_free_line(), unregister the device before waiting for existing
closes and dropping the initial reference. Record failed gs_open() calls so
gs_close() invoked by the TTY core on open failure exits without
decrementing port->port.count. Check in gs_open() that the port was not
removed between install and open; checking for a removed rather than
replaced port suffices because the slot remains reserved while a TTY holds
a reference to the old port. Finally, keep line numbers reserved until port
destruction and defer publishing the port pointer in ports[] until after
tty_port_register_device() succeeds, which protects saved termios because
tty_register_device_attr() frees the saved termios of the index on every
registration without holding tty_mutex.

Fixes: 19b10a8828a6 ("usb: gadget: allocate & giveback serial ports instead hard code them")
Assisted-by: Gemini:gemini-3.8-flash syzbot
Reported-by: syzbot+fe63e4d633540f230624@syzkaller.appspotmail.com
Closes: https://syzkaller.appspot.com/bug?extid=fe63e4d633540f230624
Link: https://syzkaller.appspot.com/ai_job?id=ec789387-2e7b-4a8f-a7a1-a47bf7fa57f5
Signed-off-by: Krystian Kaniewski <krystianmkaniewski@gmail.com>

---
diff --git a/drivers/usb/gadget/function/u_serial.c b/drivers/usb/gadget/function/u_serial.c
index cdd1dfc66..aaad06fa5 100644
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
+ *   - Retiring or device registration in progress: !port &&  reserved
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
See https://goo.gle/syzbot-ai-patches for information about AI-generated patches.
The person who has signed off on the patch is responsible for
addressing comments.
syzbot engineers can be reached at syzkaller@googlegroups.com.
