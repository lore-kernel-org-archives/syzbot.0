Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 169A65328AE
	for <syzbot@lists.linux.dev>; Tue,  8 Sep 2026 12:00:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788868835; cv=none; b=OZmLLV/u9TGP1BlF4dpbYWAwm/eV9LPgK0z7KlL5EMP7138JvaF2uUjGTMsA+OVec+HFbxKKxNcpS9sAOSAGVJgue+CcqU9t6HorJZvKuY+YYZaa6wfRqXxFg0tKJLJzDBplqwnqv4x+1neoyf6Wha+SMpKv2sbJmtnMZdhirUw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788868835; c=relaxed/simple;
	bh=CSKghGisqQNcB9DzZPnm3i+T8pe1hZl0slkFiVj/Qno=;
	h=From:To:Cc:Subject:Message-ID:MIME-Version:Content-Type:Date; b=TNLmyo5hcrbOW7IOIW6KyNLIIEMQF07LgyGrC1ggmo9EU1N251ugvYdQgDj7E/7B1av2DavT9JkUL+oxLO4YwFnzzKt9qTiTI89vYw2g7Fz803di2ZGUzMrHr0Imds+ucThXONt0n2eRRcWlOPQ4W1VaHamte+Dl5oy1LZeHBPo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=ZKoS0Jbz; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="ZKoS0Jbz"
Received: by smtp.kernel.org (Postfix) with UTF8SMTPSA id 9A8ED1F00A3A;
	Tue,  8 Sep 2026 12:00:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788868833;
	bh=HDoi5XzzvhXUQzqkW2RaPduWrI6W5R3G/APUQu9TfQM=;
	h=From:To:Cc:Subject:Date;
	b=ZKoS0JbzlvCuvZCHAh0G5I/goFaDoOpIAS+byZSSvgjMrHd8cBWPjOWZ3JcPz/vJa
	 /u1IC50PAlNe875PfeaQs6bJ/niQ/GQ2WM+yPHsZMQHXe7t0Tz57Vlc+KhE8pTmcxW
	 V6rPaNqj8rxKphbC6SMhs9Tlgp2AZHHvKTA1ZQdPBCcfimSKaoBTOtf9/TIVODzAlH
	 5fBgieOtNehssNYjViaq/0zGijGmPmCMxZg2XSHB4rshSbS8aOEx1CG6yLyLXOXepx
	 5nEIJ25Am89ihtEy7dmdSgZniLp9xsXyhjzpR4nPYuDd6mq7K4Vv3i3S8RKwqYv4Lq
	 rBWyh/f3rtwIg==
From: "syzbot" <syzbot@kernel.org>
To: syzkaller-upstream-moderation@googlegroups.com
Cc: syzbot@lists.linux.dev
Subject: [PATCH RFC] usb: gadget: u_serial: Fix use-after-free in release_tty
Message-ID: <acde99b9-2954-43ab-8403-6ca10699472d@mail.kernel.org>
Precedence: bulk
X-Mailing-List: syzbot@lists.linux.dev
List-Id: <syzbot.lists.linux.dev>
List-Subscribe: <mailto:syzbot+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:syzbot+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Date: Tue,  8 Sep 2026 12:00:33 +0000 (UTC)

A slab-use-after-free occurs in release_tty() when closing a USB serial
port while the gadget is concurrently being unbound or destroyed. When a
user closes /dev/ttyGS*, tty_release() invokes gs_close(), which decrements
port->port.count to 0 and wakes up port->close_wait. Concurrently,
gserial_free_port() (invoked during gadget unbind/rmdir) wakes up from
wait_event(port->close_wait, gs_closed(port)) and frees the gs_port
structure with tty_port_destroy() and kfree(). After gs_close() completes,
tty_release() continues execution and calls release_tty(), which accesses
the already freed gs_port through tty->port->itty = NULL.

BUG: KASAN: slab-use-after-free in release_tty+0x371/0x570
drivers/tty/tty_io.c:1557
Write of size 8 at addr ffff8881903f2128 by task syz-executor600/5845

Call Trace:
 <TASK>
 release_tty+0x371/0x570 drivers/tty/tty_io.c:1557
 tty_release_struct+0xb8/0xd0 drivers/tty/tty_io.c:1665
 tty_release+0xc62/0x1670 drivers/tty/tty_io.c:1825
 __fput+0x418/0xa50 fs/file_table.c:512
 fput_close_sync+0x11f/0x240 fs/file_table.c:617
 __x64_sys_close+0x7e/0x110 fs/open.c:1545
 do_syscall_64+0x166/0x520 arch/x86/entry/syscall_64.c:84
 entry_SYSCALL_64_after_hwframe+0x77/0x7f
 </TASK>

Allocated by task 5843:
 __kmalloc_cache_noprof+0x321/0x600 mm/slub.c:5563
 gs_port_alloc drivers/usb/gadget/function/u_serial.c:1218 [inline]
 gserial_alloc_line_no_console+0x232/0x6e0
 drivers/usb/gadget/function/u_serial.c:1298
 gserial_alloc_line+0x18/0x90 drivers/usb/gadget/function/u_serial.c:1332
 acm_alloc_instance+0xc7/0x140 drivers/usb/gadget/function/f_acm.c:891
 usb_get_function_instance+0xe3/0x2f0 drivers/usb/gadget/functions.c:44
 function_make+0x127/0x360 drivers/usb/gadget/configfs.c:626
 configfs_mkdir+0x4f6/0x9e0 fs/configfs/dir.c:1360
 vfs_mkdir+0x40c/0x620 fs/namei.c:5410

Freed by task 5843:
 kfree+0x1c5/0x650 mm/slub.c:6792
 gserial_free_port+0x248/0x2c0 drivers/usb/gadget/function/u_serial.c:1262
 gserial_free_line+0xc0/0x1f0 drivers/usb/gadget/function/u_serial.c:1279
 acm_free_instance+0x39/0x60 drivers/usb/gadget/function/f_acm.c:875
 usb_put_function_instance+0x95/0xc0 drivers/usb/gadget/functions.c:77
 config_item_release+0x13a/0x2d0 fs/configfs/item.c:137
 configfs_rmdir+0x885/0x950 fs/configfs/dir.c:1571
 vfs_rmdir+0x3e6/0x6a0 fs/namei.c:5515

Fix this by managing the lifetime of struct gs_port through standard
tty_port reference counting:
- Implement .install (gs_install) to acquire a port reference with
tty_port_get(), attach the port via tty_port_install(), and initialize
tty->driver_data.
- Implement .cleanup (gs_cleanup) to drop the tty_struct's reference with
tty_port_put().
- Implement the .destruct port operation (gs_port_destruct) to free the
write FIFO buffer and kfree() the gs_port structure once all references
have been dropped.
- In gserial_free_port(), replace the direct tty_port_destroy() and kfree()
calls with tty_port_put().
- In gs_close(), check if port is NULL or if port->port.count is 0 (which
may occur if open failed) to prevent NULL pointer dereferences or spurious
warnings.

Fixes: 19b10a8828a6 ("usb: gadget: allocate & giveback serial ports instead hard code them")
Assisted-by: Gemini:gemini-3.7-flash Gemini:gemini-3.1-pro-preview syzbot
Reported-by: syzbot+fe63e4d633540f230624@syzkaller.appspotmail.com
Closes: https://syzkaller.appspot.com/bug?extid=fe63e4d633540f230624
Link: https://syzkaller.appspot.com/ai_job?id=b41b38ff-60c3-4626-adff-58b24c0a4cbc
To: "Greg Kroah-Hartman" <gregkh@linuxfoundation.org>
To: <linux-usb@vger.kernel.org>
To: "Sebastian Andrzej Siewior" <bigeasy@linutronix.de>
Cc: "Ai Chao" <aichao@kylinos.cn>
Cc: "Kees Cook" <kees@kernel.org>
Cc: <linux-kernel@vger.kernel.org>

---
diff --git a/drivers/usb/gadget/function/u_serial.c b/drivers/usb/gadget/function/u_serial.c
index cdd1dfc66..592bb9504 100644
--- a/drivers/usb/gadget/function/u_serial.c
+++ b/drivers/usb/gadget/function/u_serial.c
@@ -603,6 +603,41 @@ static int gserial_wakeup_host(struct gserial *gser)
 
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
+	mutex_unlock(&ports[tty->index].lock);
+
+	if (!tport)
+		return -ENODEV;
+
+	ret = tty_port_install(tport, driver, tty);
+	if (ret) {
+		tty_port_put(tport);
+		return ret;
+	}
+
+	tty->driver_data = port;
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
  * gs_open sets up the link between a gs_port and its associated TTY.
  * That link is broken *only* by TTY close(), and all driver methods
@@ -695,14 +730,16 @@ static void gs_close(struct tty_struct *tty, struct file *file)
 	struct gs_port *port = tty->driver_data;
 	struct gserial	*gser;
 
+	if (!port)
+		return;
+
 	spin_lock_irq(&port->port_lock);
 
-	if (port->port.count != 1) {
-raced_with_open:
-		if (port->port.count == 0)
-			WARN_ON(1);
-		else
-			--port->port.count;
+	if (port->port.count == 0)
+		goto exit;
+
+	if (port->port.count > 1) {
+		--port->port.count;
 		goto exit;
 	}
 
@@ -722,8 +759,11 @@ static void gs_close(struct tty_struct *tty, struct file *file)
 					GS_CLOSE_TIMEOUT * HZ);
 		spin_lock_irq(&port->port_lock);
 
-		if (port->port.count != 1)
-			goto raced_with_open;
+		if (port->port.count != 1) {
+			if (port->port.count > 1)
+				--port->port.count;
+			goto exit;
+		}
 
 		gser = port->port_usb;
 	}
@@ -909,8 +949,10 @@ static int gs_get_icount(struct tty_struct *tty,
 }
 
 static const struct tty_operations gs_tty_ops = {
+	.install =		gs_install,
 	.open =			gs_open,
 	.close =		gs_close,
+	.cleanup =		gs_cleanup,
 	.write =		gs_write,
 	.put_char =		gs_put_char,
 	.flush_chars =		gs_flush_chars,
@@ -1203,6 +1245,18 @@ static void gs_console_exit(struct gs_port *port)
 
 #endif
 
+static void gs_port_destruct(struct tty_port *tport)
+{
+	struct gs_port *port = container_of(tport, struct gs_port, port);
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
@@ -1222,6 +1276,7 @@ gs_port_alloc(unsigned port_num, struct usb_cdc_line_coding *coding)
 	}
 
 	tty_port_init(&port->port);
+	port->port.ops = &gs_port_ops;
 	spin_lock_init(&port->port_lock);
 	init_waitqueue_head(&port->drain_wait);
 	init_waitqueue_head(&port->close_wait);
@@ -1258,8 +1313,7 @@ static void gserial_free_port(struct gs_port *port)
 	/* wait for old opens to finish */
 	wait_event(port->close_wait, gs_closed(port));
 	WARN_ON(port->port_usb != NULL);
-	tty_port_destroy(&port->port);
-	kfree(port);
+	tty_port_put(&port->port);
 }
 
 void gserial_free_line(unsigned char port_num)


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
