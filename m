Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5984C282F36
	for <syzbot@lists.linux.dev>; Tue, 18 Aug 2026 11:08:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787051317; cv=none; b=HkyOeR5R/haue3rKEN4MVU/gmq1tfEUpTzKHxKjDFcHLzE7wAL/jXe1v46oxP9jtp7gfgLwYBXqPwYtxPin+YxrRyQw5dAzwM337UxSzgubzw+Wr2CEM33UZqB25glJCm282+PCCK4x2LLw8zwgINQSqyqjKgDSPcBl8f25RNd0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787051317; c=relaxed/simple;
	bh=tlyaysoH1xB3ui8GIDoKdtVozsYmuJCejsXXAA8tIOo=;
	h=From:To:Cc:Subject:Message-ID:MIME-Version:Content-Type:Date; b=rtTa01yBcuT/lNpCnsBjL29LQ/8YszEJ6Wsl+epapBhpLNv+HDiS9cG5K4c9hwgEs9L5y8phfpUH9zFZh50koyNe0512ftrOZ2IANNmkKtBKiS9ygIHI/o00QjSs5+euOd+SG2xadQWx1EoRhOoZvMei0GeeDIamEAfrbZ8rfRk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=d6VYYGi6; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="d6VYYGi6"
Received: by smtp.kernel.org (Postfix) with UTF8SMTPSA id DD38E1F000E9;
	Tue, 18 Aug 2026 11:08:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1787051316;
	bh=1AuYG+FCZjIejJCpQ2HE2rwc9g4s2B/dAfsZKuIV2Pw=;
	h=From:To:Cc:Subject:Date;
	b=d6VYYGi6yEx73jVJx7OULEvEI8+5NCmAWAIcMXzZGdkWg4bfaovFptFeXoqj6pLJb
	 bBk9T+ajL6gerVz4qOM8YNz16nuRa0drJkI6bNIb7wtqu1xIzAKLNdeUHxVS+dsJYL
	 uq02C+JHS0Zk92+3uXmWKNKzc7jcU2nW9QBT4wCe9bqLcoQbQGx03eZ59+RY9kt+dr
	 /srrn1vYuUdhDS7Y4CsZMJFWWvmrzsIcfFLMSbTNWk3xjJEDY6IKFJ5Q/AMhlaxTs5
	 JMHbk+u354BaaQWnNl+MjviO4ClHzS7LOUYg6zy4bMY3Y/V8II+KbgVmez3BcB+f22
	 Vfuuri8N8Zppg==
From: "syzbot" <syzbot@kernel.org>
To: syzkaller-upstream-moderation@googlegroups.com
Cc: syzbot@lists.linux.dev
Subject: [PATCH RFC] usb: gadget: u_serial: fix use-after-free of tty->port
Message-ID: <275c9145-70cc-4b77-9a3e-740289c41de8@mail.kernel.org>
Precedence: bulk
X-Mailing-List: syzbot@lists.linux.dev
List-Id: <syzbot.lists.linux.dev>
List-Subscribe: <mailto:syzbot+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:syzbot+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Date: Tue, 18 Aug 2026 11:08:35 +0000 (UTC)

A use-after-free of `tty->port` in `release_tty()` occurs because
`u_serial.c` manually manages the lifetime of `struct gs_port` and frees it
prematurely while the TTY core is still tearing down the `tty_struct`.

When the USB gadget is removed (e.g., via configfs `rmdir`),
`gserial_free_port()` is called. If the TTY device is currently open by
userspace, `gserial_free_port()` blocks and waits for the TTY to be closed.
When userspace closes the last file descriptor for the TTY, the VFS calls
`tty_release()`. `tty_release()` first invokes the driver's
`tty->ops->close()` callback, which is `gs_close()`. In `gs_close()`,
setting `port->port.count = 0` and waking up the waitqueue causes
`gserial_free_port()` to immediately unblock, call `tty_port_destroy()`,
and `kfree(port)`. However, the TTY core is not done yet. After
`gs_close()` returns, `tty_release()` continues its execution and
eventually calls `tty_release_struct()` -> `release_tty()`. Because
`tty->port` points to `&port->port` (which was just freed by
`gserial_free_port()`), this results in a KASAN slab-use-after-free crash.

BUG: KASAN: slab-use-after-free in release_tty+0x36b/0x560
drivers/tty/tty_io.c:1584
Write of size 8 at addr ffff888191b2d120 by task syz.0.17/6133
Call Trace:
 release_tty+0x36b/0x560 drivers/tty/tty_io.c:1584
 tty_release_struct+0xb8/0xd0 drivers/tty/tty_io.c:1692
 tty_release+0xc6b/0x1680 drivers/tty/tty_io.c:1852
 __fput+0x42a/0xa80 fs/file_table.c:512
Allocated by task 6134:
 gs_port_alloc drivers/usb/gadget/function/u_serial.c:1218 [inline]
 gserial_alloc_line_no_console+0x23a/0x6e0
 drivers/usb/gadget/function/u_serial.c:1298
 gserial_alloc_line+0x18/0x90 drivers/usb/gadget/function/u_serial.c:1332
 acm_alloc_instance+0xc7/0x140 drivers/usb/gadget/function/f_acm.c:891
Freed by task 6134:
 gserial_free_port+0x248/0x2c0 drivers/usb/gadget/function/u_serial.c:1262
 gserial_free_line+0xc3/0x1f0 drivers/usb/gadget/function/u_serial.c:1279
 acm_free_instance+0x39/0x60 drivers/usb/gadget/function/f_acm.c:875

To fix this properly, convert `u_serial.c` to use standard `tty_port`
refcounting. This also fixes a secondary issue where `rmdir` hangs
indefinitely if userspace keeps the TTY open.

Implement `tty_port` refcounting by adding `tty_port_operations` with a
`.destruct` callback that handles `cancel_delayed_work_sync(&port->push)`
and `kfree(port)`. Implement `.install` and `.cleanup` in `gs_tty_ops`.
`gs_install()` calls `tty_port_get()` to take a reference, and
`gs_cleanup()` calls `tty_port_put()` to drop it. Change
`gserial_free_port()` to simply call `tty_port_put(&port->port)` instead of
waiting on `close_wait` and freeing the port directly.

Because `rmdir` will no longer block, the USB gadget can be removed while
the TTY is still open. If the port number (`port_num`) is immediately freed
and reused by a new gadget, `tty_open()` will look up the index and
erroneously return the old `tty_struct` (since it hasn't been removed from
the driver's table yet), leading to severe state corruption. To prevent
this, defer setting `ports[port_num].port = NULL` until the `.destruct`
callback. Add a `bool freed;` flag to `struct gs_port`. Set `port->freed =
true` in `gserial_free_line()`, and make `gs_install()` and `gs_open()`
return `-ENODEV` if `port->freed` is true, preventing any new opens on the
dying port.

Finally, handle the case where `gs_close()` is called after a failed
`gs_open()`. Since `gs_open()` didn't increment `port->port.count`,
`gs_close()` should simply return without decrementing the count or
executing the rest of the close logic, avoiding a `WARN_ON(1)` when
`port->port.count == 0`.

Fixes: 19b10a8828a6 ("usb: gadget: allocate & giveback serial ports instead hard code them")
Assisted-by: Gemini:gemini-3.6-flash Gemini:gemini-3.1-pro-preview syzbot
Reported-by: syzbot+bca09f5d8b843bbf7571@syzkaller.appspotmail.com
Closes: https://syzkaller.appspot.com/bug?extid=bca09f5d8b843bbf7571
Link: https://syzkaller.appspot.com/ai_job?id=92d0161e-2ce3-4d72-aa77-1356fd886e84
To: "Greg Kroah-Hartman" <gregkh@linuxfoundation.org>
To: <linux-usb@vger.kernel.org>
To: "Sebastian Andrzej Siewior" <bigeasy@linutronix.de>
Cc: "Ai Chao" <aichao@kylinos.cn>
Cc: "Kees Cook" <kees@kernel.org>
Cc: <linux-kernel@vger.kernel.org>

---
diff --git a/drivers/usb/gadget/function/u_serial.c b/drivers/usb/gadget/function/u_serial.c
index cdd1dfc66..013044c0d 100644
--- a/drivers/usb/gadget/function/u_serial.c
+++ b/drivers/usb/gadget/function/u_serial.c
@@ -125,10 +125,10 @@ struct gs_port {
 	struct kfifo		port_write_buf;
 	wait_queue_head_t	drain_wait;	/* wait while writes drain */
 	bool                    write_busy;
-	wait_queue_head_t	close_wait;
 	bool			suspended;	/* port suspended */
 	bool			start_delayed;	/* delay start when suspended */
 	struct async_icount	icount;
+	bool			freed;
 
 	/* REVISIT this state ... */
 	struct usb_cdc_line_coding port_line_coding;	/* 8-N-1 etc */
@@ -318,9 +318,10 @@ __acquires(&port->port_lock)
 		struct tty_struct	*tty;
 
 		/* no more rx if closed */
-		tty = port->port.tty;
+		tty = tty_port_tty_get(&port->port);
 		if (!tty)
 			break;
+		tty_kref_put(tty);
 
 		if (port->read_started >= QUEUE_SIZE)
 			break;
@@ -372,7 +373,7 @@ static void gs_rx_push(struct work_struct *work)
 
 	/* hand any queued data to the tty */
 	spin_lock_irq(&port->port_lock);
-	tty = port->port.tty;
+	tty = tty_port_tty_get(&port->port);
 	while (!list_empty(queue)) {
 		struct usb_request	*req;
 
@@ -453,6 +454,9 @@ static void gs_rx_push(struct work_struct *work)
 		gs_start_rx(port);
 
 	spin_unlock_irq(&port->port_lock);
+
+	if (tty)
+		tty_kref_put(tty);
 }
 
 static void gs_read_complete(struct usb_ep *ep, struct usb_request *req)
@@ -611,12 +615,11 @@ static int gserial_wakeup_host(struct gserial *gser)
 static int gs_open(struct tty_struct *tty, struct file *file)
 {
 	int		port_num = tty->index;
-	struct gs_port	*port;
+	struct gs_port	*port = tty->driver_data;
 	int		status = 0;
 
 	mutex_lock(&ports[port_num].lock);
-	port = ports[port_num].port;
-	if (!port) {
+	if (!port || port->freed) {
 		status = -ENODEV;
 		goto out;
 	}
@@ -648,8 +651,7 @@ static int gs_open(struct tty_struct *tty, struct file *file)
 	if (port->port.count++)
 		goto exit_unlock_port;
 
-	tty->driver_data = port;
-	port->port.tty = tty;
+	tty_port_tty_set(&port->port, tty);
 
 	/* if connected, start the I/O stream */
 	if (port->port_usb) {
@@ -700,9 +702,8 @@ static void gs_close(struct tty_struct *tty, struct file *file)
 	if (port->port.count != 1) {
 raced_with_open:
 		if (port->port.count == 0)
-			WARN_ON(1);
-		else
-			--port->port.count;
+			goto exit;
+		--port->port.count;
 		goto exit;
 	}
 
@@ -739,12 +740,11 @@ static void gs_close(struct tty_struct *tty, struct file *file)
 
 	port->start_delayed = false;
 	port->port.count = 0;
-	port->port.tty = NULL;
+	tty_port_tty_set(&port->port, NULL);
 
 	pr_debug("gs_close: ttyGS%d (%p,%p) done!\n",
 			port->port_num, tty, file);
 
-	wake_up(&port->close_wait);
 exit:
 	spin_unlock_irq(&port->port_lock);
 }
@@ -908,9 +908,38 @@ static int gs_get_icount(struct tty_struct *tty,
 	return 0;
 }
 
+static int gs_install(struct tty_driver *driver, struct tty_struct *tty)
+{
+	int		port_num = tty->index;
+	struct gs_port	*port;
+	int		status = -ENODEV;
+
+	mutex_lock(&ports[port_num].lock);
+	port = ports[port_num].port;
+	if (port && !port->freed) {
+		tty_port_get(&port->port);
+		status = tty_port_install(&port->port, driver, tty);
+		if (status)
+			tty_port_put(&port->port);
+		else
+			tty->driver_data = port;
+	}
+	mutex_unlock(&ports[port_num].lock);
+	return status;
+}
+
+static void gs_cleanup(struct tty_struct *tty)
+{
+	struct gs_port	*port = tty->driver_data;
+
+	tty_port_put(&port->port);
+}
+
 static const struct tty_operations gs_tty_ops = {
+	.install =		gs_install,
 	.open =			gs_open,
 	.close =		gs_close,
+	.cleanup =		gs_cleanup,
 	.write =		gs_write,
 	.put_char =		gs_put_char,
 	.flush_chars =		gs_flush_chars,
@@ -1203,6 +1232,24 @@ static void gs_console_exit(struct gs_port *port)
 
 #endif
 
+static void gs_port_destruct(struct tty_port *port)
+{
+	struct gs_port	*p = container_of(port, struct gs_port, port);
+
+	cancel_delayed_work_sync(&p->push);
+
+	mutex_lock(&ports[p->port_num].lock);
+	ports[p->port_num].port = NULL;
+	mutex_unlock(&ports[p->port_num].lock);
+
+	kfifo_free(&p->port_write_buf);
+	kfree(p);
+}
+
+static const struct tty_port_operations gs_port_ops = {
+	.destruct =		gs_port_destruct,
+};
+
 static int
 gs_port_alloc(unsigned port_num, struct usb_cdc_line_coding *coding)
 {
@@ -1222,9 +1269,9 @@ gs_port_alloc(unsigned port_num, struct usb_cdc_line_coding *coding)
 	}
 
 	tty_port_init(&port->port);
+	port->port.ops = &gs_port_ops;
 	spin_lock_init(&port->port_lock);
 	init_waitqueue_head(&port->drain_wait);
-	init_waitqueue_head(&port->close_wait);
 
 	INIT_DELAYED_WORK(&port->push, gs_rx_push);
 
@@ -1241,25 +1288,10 @@ gs_port_alloc(unsigned port_num, struct usb_cdc_line_coding *coding)
 	return ret;
 }
 
-static int gs_closed(struct gs_port *port)
-{
-	int cond;
-
-	spin_lock_irq(&port->port_lock);
-	cond = port->port.count == 0;
-	spin_unlock_irq(&port->port_lock);
-
-	return cond;
-}
-
 static void gserial_free_port(struct gs_port *port)
 {
-	cancel_delayed_work_sync(&port->push);
-	/* wait for old opens to finish */
-	wait_event(port->close_wait, gs_closed(port));
 	WARN_ON(port->port_usb != NULL);
-	tty_port_destroy(&port->port);
-	kfree(port);
+	tty_port_put(&port->port);
 }
 
 void gserial_free_line(unsigned char port_num)
@@ -1272,12 +1304,14 @@ void gserial_free_line(unsigned char port_num)
 		return;
 	}
 	port = ports[port_num].port;
-	gs_console_exit(port);
-	ports[port_num].port = NULL;
+	port->freed = true;
 	mutex_unlock(&ports[port_num].lock);
 
-	gserial_free_port(port);
+	gs_console_exit(port);
+
 	tty_unregister_device(gs_tty_driver, port_num);
+	tty_port_tty_hangup(&port->port, false);
+	gserial_free_port(port);
 }
 EXPORT_SYMBOL_GPL(gserial_free_line);
 
@@ -1457,8 +1491,7 @@ void gserial_disconnect(struct gserial *gser)
 	gser->ioport = NULL;
 	if (port->port.count > 0) {
 		wake_up_interruptible(&port->drain_wait);
-		if (port->port.tty)
-			tty_hangup(port->port.tty);
+		tty_port_tty_hangup(&port->port, false);
 	}
 	port->suspended = false;
 	spin_unlock(&port->port_lock);


base-commit: 8d3ae59288f1e7d58d76558a6ee96d533bc5019f
-- 
This is an AI-generated patch subject to moderation.
Reply with '#syz upstream' to Sign-off the patch as a human author
and send it to the upstream kernel mailing lists.
Reply with '#syz reject' to reject it ('#syz unreject' to undo).

See https://goo.gle/syzbot-ai-patches for information about AI-generated patches.
You can comment on the patch as usual, syzbot will try to address
the comments and send a new version of the patch if necessary.
syzbot engineers can be reached at syzkaller@googlegroups.com.
