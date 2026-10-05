Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 365B94CDA0A
	for <syzbot@lists.linux.dev>; Mon,  5 Oct 2026 15:59:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791215945; cv=none; b=SmwOXwyzr8+kVn6dIz3dwAFODy5YAdXZAFf0MG48jAXukTeo48r9ms+MISUM/F0V0sE6lz/s4LdVbfAQmAzIsBVm4H/DRjHvIYlVBlY+EkjAEdWg/j//oBrEGtMEVXJ12OIMJ98mi+P4N6Jc7Ilewp33f7NSbIIa1zAZZyD3FKo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791215945; c=relaxed/simple;
	bh=Li3AuZJ3uafgt5pEKF9cTmdpXxkH+Lri4ihiWXFTT24=;
	h=From:To:Cc:Subject:Message-ID:MIME-Version:Content-Type:Date; b=OgxqMFiqvAltV/MFDM+V/ARFAaRzaz1pum+0s1m2381gTkipvbpKIz76Ao8POi9caF91XVQfSCSIst1ImkdDy3HwVfpc23FI/gXkEMvBtPAbltb4YQUIP+Xc0Wg4e3ID3eUEons06fADJKRgcHqfp8OczA5XG3bLCA2tPqQmsbY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=RA9j84dc; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="RA9j84dc"
Received: by smtp.kernel.org (Postfix) with UTF8SMTPSA id 99B731F000FF;
	Mon,  5 Oct 2026 15:59:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1791215943;
	bh=8L9Lg8oNSxSP0zDT6KCCcvj3Z8iA9r8RoxvweYnTw5E=;
	h=From:To:Cc:Subject:Date;
	b=RA9j84dcyYlbZdck+0podn/3NDpkeuvihnnQvM6dCG4xwmPXvPASbDhTwLXZbO+8u
	 knWcxkUMKktkZcwODcKo7rO0GmCALMFXSm+zqdNYoLewcW5mEQxhlA0nlT7OLOjRMY
	 IGk5JjjTGdh8yJnn3svjDfjmaLvpo80jtlbPE3gPFhBmcrgvDeGsjjbB+lMLH010vm
	 AxogK8F+IUJtnfKBA1/F4j/Br7sOJlTBhquyVXxr99uDx+Eu6SfHyU9O85PHX39z4Z
	 zbJR06g1atgkxw3QlCA0zqZkBP+KoOZSYD5I6NFbzTNuZQEY/pfQgzORnn+p7OaaX1
	 aQJJOr/5QrCrg==
From: "syzbot" <syzbot@kernel.org>
To: syzkaller-upstream-moderation@googlegroups.com
Cc: syzbot@lists.linux.dev
Subject: [PATCH RFC] usb: gadget: u_serial: Use tty_port refcounting for port lifetime
Message-ID: <dbbdfe41-8f98-4239-954b-46f0091eb540@mail.kernel.org>
Precedence: bulk
X-Mailing-List: syzbot@lists.linux.dev
List-Id: <syzbot.lists.linux.dev>
List-Subscribe: <mailto:syzbot+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:syzbot+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Date: Mon,  5 Oct 2026 15:59:03 +0000 (UTC)

When a USB serial gadget function is removed (e.g. via configfs rmdir),
gserial_free_line() and gserial_free_port() are called to free the
underlying gs_port structure. Previously, gserial_free_port() attempted to
synchronize with open TTY file descriptors by waiting on port->close_wait
until port->port.count reached zero (checked via gs_closed()).

However, port->port.count is decremented to zero and port->close_wait is
woken up inside gs_close(), which is called early during tty_release() via
tty->ops->close(). As a result, the following race condition occurs:

1. Thread A closes the TTY device, triggering __fput() -> tty_release().
2. In tty_release(), tty->ops->close() invokes gs_close(), which decrements
port->port.count to zero and wakes up port->close_wait.
3. Thread B, unbinding or removing the gadget function, wakes up in
gserial_free_port(), destroys the tty_port, and frees struct gs_port with
kfree().
4. Thread A continues in tty_release(), calling tty_release_struct() ->
release_tty().
5. In release_tty(), the TTY core accesses tty->port->itty to clear it:
   tty->port->itty = NULL;
Since tty->port points into the already-freed struct gs_port, this causes a
slab use-after-free write:

BUG: KASAN: slab-use-after-free in release_tty+0x36b/0x560
drivers/tty/tty_io.c:1559
Write of size 8 at addr ffff88810ba85120

Call Trace:
 <TASK>
 release_tty+0x36b/0x560 drivers/tty/tty_io.c:1559
 tty_release_struct+0xb8/0xd0 drivers/tty/tty_io.c:1667
 tty_release+0xc6b/0x1680 drivers/tty/tty_io.c:1827
 __fput+0x42a/0xa80 fs/file_table.c:512
 </TASK>

Allocated by task 6205:
 gs_port_alloc drivers/usb/gadget/function/u_serial.c:1218 [inline]
 gserial_alloc_line_no_console+0x23a/0x6e0
 drivers/usb/gadget/function/u_serial.c:1298
 gserial_alloc_line+0x18/0x90 drivers/usb/gadget/function/u_serial.c:1332
 acm_alloc_instance+0xc7/0x140 drivers/usb/gadget/function/f_acm.c:891
 usb_get_function_instance+0xe3/0x2f0 drivers/usb/gadget/functions.c:44
 configfs_mkdir+0x4f6/0x9e0 fs/configfs/dir.c:1369

Freed by task 6205:
 kfree+0x1c5/0x6d0 mm/slub.c:6802
 gserial_free_port+0x248/0x2c0 drivers/usb/gadget/function/u_serial.c:1262
 gserial_free_line+0xc3/0x1f0 drivers/usb/gadget/function/u_serial.c:1279
 acm_free_instance+0x39/0x60 drivers/usb/gadget/function/f_acm.c:875
 usb_put_function_instance+0x95/0xc0 drivers/usb/gadget/functions.c:77
 configfs_rmdir+0x885/0x950 fs/configfs/dir.c:1580

Fix this by managing the lifetime of struct gs_port using standard tty_port
reference counting (tty_port_get() and tty_port_put()) and the
tty_port_operations .destruct callback instead of the custom wait queue:

- Implement .install (gs_install) and .cleanup (gs_cleanup) in gs_tty_ops.
In gs_install(), acquire a port reference with tty_port_get() before
calling tty_port_install(). In gs_cleanup(), release this reference via
tty_port_put(tty->port). Because .cleanup is called asynchronously from
release_one_tty() after release_tty() has completed, the port is guaranteed
to remain valid throughout the TTY core release path.

- Provide a .destruct callback (gs_destruct) in gs_port_ops that clears
ports[port_num].port under ports[port_num].lock and frees struct gs_port
with kfree() once the last reference to tty_port is dropped.

- In gserial_free_port(), remove the wait_event() on close_wait and drop
the initial reference using tty_port_put(&port->port).

- In gserial_free_line(), call tty_unregister_device() before
gserial_free_port(), and remove the manual clearing of ports[port_num].port
= NULL (both here and in the error path of
gserial_alloc_line_no_console()). The port slot remains reserved until
gs_destruct() runs, preventing a new port allocation from reusing the slot
while the TTY is still being released.

- Remove the unused close_wait wait queue from struct gs_port and drop the
gs_closed() helper function.

Fixes: 19b10a8828a6 ("usb: gadget: allocate & giveback serial ports instead hard code them")
Assisted-by: Gemini:gemini-3.8-flash Gemini:gemini-3.1-pro-preview syzbot
Reported-by: syzbot+bca09f5d8b843bbf7571@syzkaller.appspotmail.com
Closes: https://syzkaller.appspot.com/bug?extid=bca09f5d8b843bbf7571
Link: https://syzkaller.appspot.com/ai_job?id=6ca05ac5-aa78-43d0-9986-06b40096d7b6
To: "Greg Kroah-Hartman" <gregkh@linuxfoundation.org>
To: <linux-usb@vger.kernel.org>
To: "Sebastian Andrzej Siewior" <bigeasy@linutronix.de>
Cc: "Ai Chao" <aichao@kylinos.cn>
Cc: "Kees Cook" <kees@kernel.org>
Cc: <linux-kernel@vger.kernel.org>

---
diff --git a/drivers/usb/gadget/function/u_serial.c b/drivers/usb/gadget/function/u_serial.c
index cdd1dfc66..fda30757d 100644
--- a/drivers/usb/gadget/function/u_serial.c
+++ b/drivers/usb/gadget/function/u_serial.c
@@ -125,7 +125,6 @@ struct gs_port {
 	struct kfifo		port_write_buf;
 	wait_queue_head_t	drain_wait;	/* wait while writes drain */
 	bool                    write_busy;
-	wait_queue_head_t	close_wait;
 	bool			suspended;	/* port suspended */
 	bool			start_delayed;	/* delay start when suspended */
 	struct async_icount	icount;
@@ -743,8 +742,6 @@ static void gs_close(struct tty_struct *tty, struct file *file)
 
 	pr_debug("gs_close: ttyGS%d (%p,%p) done!\n",
 			port->port_num, tty, file);
-
-	wake_up(&port->close_wait);
 exit:
 	spin_unlock_irq(&port->port_lock);
 }
@@ -908,6 +905,33 @@ static int gs_get_icount(struct tty_struct *tty,
 	return 0;
 }
 
+static int gs_install(struct tty_driver *driver, struct tty_struct *tty)
+{
+	struct gs_port *port;
+	int ret;
+
+	mutex_lock(&ports[tty->index].lock);
+	port = ports[tty->index].port;
+	if (!port) {
+		mutex_unlock(&ports[tty->index].lock);
+		return -ENODEV;
+	}
+	tty_port_get(&port->port);
+	mutex_unlock(&ports[tty->index].lock);
+
+	ret = tty_port_install(&port->port, driver, tty);
+	if (ret) {
+		tty_port_put(&port->port);
+		return ret;
+	}
+	return 0;
+}
+
+static void gs_cleanup(struct tty_struct *tty)
+{
+	tty_port_put(tty->port);
+}
+
 static const struct tty_operations gs_tty_ops = {
 	.open =			gs_open,
 	.close =		gs_close,
@@ -919,6 +943,8 @@ static const struct tty_operations gs_tty_ops = {
 	.unthrottle =		gs_unthrottle,
 	.break_ctl =		gs_break_ctl,
 	.get_icount =		gs_get_icount,
+	.install =		gs_install,
+	.cleanup =		gs_cleanup,
 };
 
 /*-------------------------------------------------------------------------*/
@@ -1203,6 +1229,23 @@ static void gs_console_exit(struct gs_port *port)
 
 #endif
 
+static void gs_destruct(struct tty_port *port)
+{
+	struct gs_port *gs_port = container_of(port, struct gs_port, port);
+	unsigned char port_num = gs_port->port_num;
+
+	mutex_lock(&ports[port_num].lock);
+	if (ports[port_num].port == gs_port)
+		ports[port_num].port = NULL;
+	mutex_unlock(&ports[port_num].lock);
+
+	kfree(gs_port);
+}
+
+static const struct tty_port_operations gs_port_ops = {
+	.destruct = gs_destruct,
+};
+
 static int
 gs_port_alloc(unsigned port_num, struct usb_cdc_line_coding *coding)
 {
@@ -1222,9 +1265,9 @@ gs_port_alloc(unsigned port_num, struct usb_cdc_line_coding *coding)
 	}
 
 	tty_port_init(&port->port);
+	port->port.ops = &gs_port_ops;
 	spin_lock_init(&port->port_lock);
 	init_waitqueue_head(&port->drain_wait);
-	init_waitqueue_head(&port->close_wait);
 
 	INIT_DELAYED_WORK(&port->push, gs_rx_push);
 
@@ -1241,25 +1284,11 @@ gs_port_alloc(unsigned port_num, struct usb_cdc_line_coding *coding)
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
 	cancel_delayed_work_sync(&port->push);
-	/* wait for old opens to finish */
-	wait_event(port->close_wait, gs_closed(port));
 	WARN_ON(port->port_usb != NULL);
-	tty_port_destroy(&port->port);
-	kfree(port);
+	tty_port_put(&port->port);
 }
 
 void gserial_free_line(unsigned char port_num)
@@ -1273,11 +1302,10 @@ void gserial_free_line(unsigned char port_num)
 	}
 	port = ports[port_num].port;
 	gs_console_exit(port);
-	ports[port_num].port = NULL;
 	mutex_unlock(&ports[port_num].lock);
 
-	gserial_free_port(port);
 	tty_unregister_device(gs_tty_driver, port_num);
+	gserial_free_port(port);
 }
 EXPORT_SYMBOL_GPL(gserial_free_line);
 
@@ -1315,9 +1343,6 @@ int gserial_alloc_line_no_console(unsigned char *line_num)
 				__func__, port_num, PTR_ERR(tty_dev));
 
 		ret = PTR_ERR(tty_dev);
-		mutex_lock(&ports[port_num].lock);
-		ports[port_num].port = NULL;
-		mutex_unlock(&ports[port_num].lock);
 		gserial_free_port(port);
 		goto err;
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
