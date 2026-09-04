Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8C20C3B9D9A
	for <syzbot@lists.linux.dev>; Fri,  4 Sep 2026 22:10:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788559825; cv=none; b=i+XQQTgIhar7JvIUUMKWD2FUjJvF9LSKgRE2FgI2Qc6qmTLY4YGTdRgPDrrs0H06P9ZEDyEK7PTs6d1BftYhFEnvjuEDxQZ5XujLXvyZkwlwagispDl+wKkT1RbtuY/WJlyFiAWjDOv0fRqUHsyDQXVh7jOD1sDv9Kl+fM/Tfz0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788559825; c=relaxed/simple;
	bh=UXOwvXoXGYnr/KkmquFPD4USubOonNUbdxBLORo3nuo=;
	h=From:To:Cc:Subject:Message-ID:MIME-Version:Content-Type:Date; b=o4NJHXS9vRNoM9iAb93aO5x+AIemjZFfv8gF69qeC++sJaUsl/ioJ3sPon8hRUtrQutLe/2VRTNCfKkC3o97OzxlgEmTxGedG8p++zY41iym01/nZiVO42TqmuL/FrLne0rCNMmZ8mOkDIGi6clDrjyqvPKYsO9vy9w7fFoSX2U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=GoXsKu1C; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="GoXsKu1C"
Received: by smtp.kernel.org (Postfix) with UTF8SMTPSA id 0FF061F00A3D;
	Fri,  4 Sep 2026 22:10:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788559823;
	bh=9I7iFCfnv0jzwAqT067FCSPJ/d7BAuUpqoa14zfOQgI=;
	h=From:To:Cc:Subject:Date;
	b=GoXsKu1C9JBFSv/PT96dtJYX4I6COne1nTHMGswnX/DkqbPSfj4lDP/LV+qHGPdtT
	 Ya8mtHNMXdVtmHgmxk2x9xknsZY1NXJ7ToFx27T3CIGYPKTONlHYKDMeXiKog44zU8
	 wQ1SMcu3j/Lh5/bMpP8oVGjBc7jvOBsdXITW5TcaumoZX6h3ZU67nHtTexQk07a4AN
	 H/9LWdXQtnVUzcgEmjXlxy6H83F/1a4YyzFQQ7K0mHGO1KsMe+nbyOnpqkIO8vFz6L
	 jd5eWCJ52HtwsY/usQnL6kQDWytuPpbzqWN+JuQso7ihtOZioZnpadUU8LsVTv97+z
	 UHIGsxOkfQDTw==
From: "syzbot" <syzbot@kernel.org>
To: syzkaller-upstream-moderation@googlegroups.com
Cc: syzbot@lists.linux.dev
Subject: [PATCH RFC] usb: gadget: u_serial: Fix use-after-free race on port teardown
Message-ID: <1a9a7d3d-5930-46e6-a2a7-7241200ad612@mail.kernel.org>
Precedence: bulk
X-Mailing-List: syzbot@lists.linux.dev
List-Id: <syzbot.lists.linux.dev>
List-Subscribe: <mailto:syzbot+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:syzbot+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Date: Fri,  4 Sep 2026 22:10:23 +0000 (UTC)

A race condition exists between opening the gadget serial TTY device (via
tty_open()) and tearing down the USB function instance (via configfs rmdir
/ gserial_free_line()).

When opening the TTY device (/dev/ttyGS*), tty_open() calls
tty_open_by_driver(), which in turn calls tty_init_dev(). At this point,
tty_init_dev() assigns tty->port to driver->ports[idx], which points to
gs_port->port. If concurrently the USB function is removed via configfs
rmdir, gserial_free_line() sets ports[port_num].port to NULL and calls
gserial_free_port(). gserial_free_port() attempts to wait for port closure
using wait_event(port->close_wait, gs_closed(port)). However, because the
opening thread has not yet invoked gs_open(), port->port.count is still 0,
causing gs_closed() to return true immediately. Consequently,
gserial_free_port() frees struct gs_port via kfree(). When the opening
thread subsequently executes gs_open(), it sees ports[port_num].port is
NULL and returns -ENODEV. tty_open() then falls back to tty_release(),
which calls check_tty_count(). check_tty_count() dereferences tty->port
(which pointed inside the freed gs_port) to evaluate tty_port_kopened(),
triggering a slab-use-after-free:

==================================================================
BUG: KASAN: slab-use-after-free in check_tty_count+0x18a/0x310
drivers/tty/tty_io.c:287
Read of size 8 at addr ffff8881e0e8b230 by task syz.3.22/6291

CPU: 1 UID: 0 PID: 6291 Comm: syz.3.22 Not tainted
Call Trace:
 <TASK>
 dump_stack_lvl+0xe8/0x150 lib/dump_stack.c:120
 print_report+0x58/0x70 mm/kasan/report.c:482
 kasan_report+0x117/0x150 mm/kasan/report.c:595
 check_tty_count+0x18a/0x310 drivers/tty/tty_io.c:287
 tty_release+0x8a/0x1670 drivers/tty/tty_io.c:1701
 __fput+0x418/0xa50 fs/file_table.c:512
 task_work_run+0x1d9/0x270 kernel/task_work.c:233
 exit_to_user_mode_loop+0x204/0x770 kernel/entry/common.c:101
 do_syscall_64+0x328/0x520 arch/x86/entry/syscall_64.c:89
 entry_SYSCALL_64_after_hwframe+0x77/0x7f
 </TASK>

Allocated by task 6292:
 gs_port_alloc drivers/usb/gadget/function/u_serial.c:1218 [inline]
 gserial_alloc_line_no_console+0x232/0x6e0
 drivers/usb/gadget/function/u_serial.c:1298
 gserial_alloc_line+0x18/0x90 drivers/usb/gadget/function/u_serial.c:1332
 acm_alloc_instance+0xc7/0x140 drivers/usb/gadget/function/f_acm.c:891
 usb_get_function_instance+0xe3/0x2f0 drivers/usb/gadget/functions.c:44
 function_make+0x127/0x360 drivers/usb/gadget/configfs.c:626
 configfs_mkdir+0x4f6/0x9e0 fs/configfs/dir.c:1360
 vfs_mkdir+0x40c/0x620 fs/namei.c:5410
 do_syscall_64+0x166/0x520 arch/x86/entry/syscall_64.c:84
 entry_SYSCALL_64_after_hwframe+0x77/0x7f

Freed by task 6292:
 kfree+0x1c5/0x650 mm/slub.c:6792
 gserial_free_port+0x248/0x2c0 drivers/usb/gadget/function/u_serial.c:1262
 gserial_free_line+0xc0/0x1f0 drivers/usb/gadget/function/u_serial.c:1279
 acm_free_instance+0x39/0x60 drivers/usb/gadget/function/f_acm.c:875
 usb_put_function_instance+0x90/0xb0 drivers/usb/gadget/functions.c:77
 config_item_release+0x13a/0x2d0 fs/configfs/item.c:137
 configfs_rmdir+0x885/0x950 fs/configfs/dir.c:1571
 vfs_rmdir+0x3e6/0x6a0 fs/namei.c:5515
 do_syscall_64+0x166/0x520 arch/x86/entry/syscall_64.c:84
 entry_SYSCALL_64_after_hwframe+0x77/0x7f
==================================================================

Fix this by managing the lifecycle of struct gs_port using standard
tty_port reference counting:

1. Provide a tty_port_operations .destruct callback (gs_port_destruct) that
cancels the push delayed work, frees the circular write buffer, destroys
the tty_port, and frees struct gs_port. Assign these operations during
gs_port_alloc().

2. Implement .install (gs_install) and .cleanup (gs_cleanup) TTY
operations. In gs_install(), take a reference using tty_port_get() under
ports[port_num].lock, install the TTY via tty_standard_install(), and
assign tty->driver_data = port. In gs_cleanup(), drop the reference via
tty_port_put().

3. In gserial_free_port(), drop the initial reference via tty_port_put()
instead of calling kfree() directly.

4. Remove the ad-hoc close_wait waitqueue and gs_closed() helper, and
simplify gs_open() to obtain the port pointer directly from
tty->driver_data without re-checking ports[port_num].port.

Fixes: 19b10a8828a6 ("usb: gadget: allocate & giveback serial ports instead hard code them")
Assisted-by: Gemini:gemini-3.7-flash Gemini:gemini-3.1-pro-preview syzbot
Reported-by: syzbot+39a2135de1558208d3b3@syzkaller.appspotmail.com
Closes: https://syzkaller.appspot.com/bug?extid=39a2135de1558208d3b3
Link: https://syzkaller.appspot.com/ai_job?id=b09f1d71-b116-4ec4-b7c5-08219435370e
To: "Greg Kroah-Hartman" <gregkh@linuxfoundation.org>
To: <linux-usb@vger.kernel.org>
To: "Sebastian Andrzej Siewior" <bigeasy@linutronix.de>
Cc: "Ai Chao" <aichao@kylinos.cn>
Cc: "Kees Cook" <kees@kernel.org>
Cc: <linux-kernel@vger.kernel.org>

---
diff --git a/drivers/usb/gadget/function/u_serial.c b/drivers/usb/gadget/function/u_serial.c
index cdd1dfc66..c82c5888c 100644
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
@@ -610,17 +609,9 @@ static int gserial_wakeup_host(struct gserial *gser)
  */
 static int gs_open(struct tty_struct *tty, struct file *file)
 {
-	int		port_num = tty->index;
-	struct gs_port	*port;
+	struct gs_port	*port = tty->driver_data;
 	int		status = 0;
 
-	mutex_lock(&ports[port_num].lock);
-	port = ports[port_num].port;
-	if (!port) {
-		status = -ENODEV;
-		goto out;
-	}
-
 	spin_lock_irq(&port->port_lock);
 
 	/* allocate circular buffer on first open */
@@ -628,17 +619,12 @@ static int gs_open(struct tty_struct *tty, struct file *file)
 
 		spin_unlock_irq(&port->port_lock);
 
-		/*
-		 * portmaster's mutex still protects from simultaneous open(),
-		 * and close() can't happen, yet.
-		 */
-
 		status = kfifo_alloc(&port->port_write_buf,
 				     WRITE_BUF_SIZE, GFP_KERNEL);
 		if (status) {
 			pr_debug("gs_open: ttyGS%d (%p,%p) no buffer\n",
-				 port_num, tty, file);
-			goto out;
+				 port->port_num, tty, file);
+			return status;
 		}
 
 		spin_lock_irq(&port->port_lock);
@@ -648,7 +634,6 @@ static int gs_open(struct tty_struct *tty, struct file *file)
 	if (port->port.count++)
 		goto exit_unlock_port;
 
-	tty->driver_data = port;
 	port->port.tty = tty;
 
 	/* if connected, start the I/O stream */
@@ -672,8 +657,6 @@ static int gs_open(struct tty_struct *tty, struct file *file)
 
 exit_unlock_port:
 	spin_unlock_irq(&port->port_lock);
-out:
-	mutex_unlock(&ports[port_num].lock);
 	return status;
 }
 
@@ -744,7 +727,6 @@ static void gs_close(struct tty_struct *tty, struct file *file)
 	pr_debug("gs_close: ttyGS%d (%p,%p) done!\n",
 			port->port_num, tty, file);
 
-	wake_up(&port->close_wait);
 exit:
 	spin_unlock_irq(&port->port_lock);
 }
@@ -908,7 +890,42 @@ static int gs_get_icount(struct tty_struct *tty,
 	return 0;
 }
 
+static int gs_install(struct tty_driver *driver, struct tty_struct *tty)
+{
+	int port_num = tty->index;
+	struct gs_port *port;
+	int ret;
+
+	mutex_lock(&ports[port_num].lock);
+	port = ports[port_num].port;
+	if (!port) {
+		mutex_unlock(&ports[port_num].lock);
+		return -ENODEV;
+	}
+
+	tty_port_get(&port->port);
+	mutex_unlock(&ports[port_num].lock);
+
+	ret = tty_standard_install(driver, tty);
+	if (ret) {
+		tty_port_put(&port->port);
+		return ret;
+	}
+
+	tty->driver_data = port;
+	return 0;
+}
+
+static void gs_cleanup(struct tty_struct *tty)
+{
+	struct gs_port *port = tty->driver_data;
+
+	if (port)
+		tty_port_put(&port->port);
+}
+
 static const struct tty_operations gs_tty_ops = {
+	.install =		gs_install,
 	.open =			gs_open,
 	.close =		gs_close,
 	.write =		gs_write,
@@ -919,6 +936,7 @@ static const struct tty_operations gs_tty_ops = {
 	.unthrottle =		gs_unthrottle,
 	.break_ctl =		gs_break_ctl,
 	.get_icount =		gs_get_icount,
+	.cleanup =		gs_cleanup,
 };
 
 /*-------------------------------------------------------------------------*/
@@ -1203,6 +1221,20 @@ static void gs_console_exit(struct gs_port *port)
 
 #endif
 
+static void gs_port_destruct(struct tty_port *port)
+{
+	struct gs_port *gs_port = container_of(port, struct gs_port, port);
+
+	cancel_delayed_work_sync(&gs_port->push);
+	kfifo_free(&gs_port->port_write_buf);
+	tty_port_destroy(port);
+	kfree(gs_port);
+}
+
+static const struct tty_port_operations gs_port_ops = {
+	.destruct = gs_port_destruct,
+};
+
 static int
 gs_port_alloc(unsigned port_num, struct usb_cdc_line_coding *coding)
 {
@@ -1222,9 +1254,9 @@ gs_port_alloc(unsigned port_num, struct usb_cdc_line_coding *coding)
 	}
 
 	tty_port_init(&port->port);
+	port->port.ops = &gs_port_ops;
 	spin_lock_init(&port->port_lock);
 	init_waitqueue_head(&port->drain_wait);
-	init_waitqueue_head(&port->close_wait);
 
 	INIT_DELAYED_WORK(&port->push, gs_rx_push);
 
@@ -1241,25 +1273,10 @@ gs_port_alloc(unsigned port_num, struct usb_cdc_line_coding *coding)
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
