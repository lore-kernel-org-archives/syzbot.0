Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.128.51
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792660456;
	b=GeHVlS7zICsPs54p60QJCy80BvzLOHFi4rtJyuR7ZZeLkGw+b4NpfMx1IbTywGnk1B3P
	 YcR89fxTj1LYTjMlufHYSZmJyla0LJdipsyoiKbIWvgr+CorlIfPpEnuNqq8UlpijJ1vl
	 W9eTWYfbmzqYjxn0ZEQITjaI21LzQpXGC3vtAshPR6O6nQWMMa6DKDfrXQdf4GpPkGDFP
	 Puaf121TSy/vvOdMdKuQJl2yxZPPwAIXrqDSV37MWaWVJvxOKvjvdkAxgO8laS7NUJDO0
	 5kDHDDSD9hr48vUt0budtwdz5awXdbKsH5HLoHa961riRtU1u1A57Voltqngg7tPEaA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792660456;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:Received:
	 From:To:Cc:Subject:Date:Message-ID:X-Mailer:In-Reply-To:References:
	 MIME-Version:Content-Transfer-Encoding;
	bh=TT/G+LaV+N0GyZAIi03X4FvjbCyGL46ou/Kls81a/U4=;
	b=alIKRwYGQRSdUjoC3+8tXGur2PZe/WYkk4IeRpNuL5XDxLqoQnFvJzgWGkQ6FagEUknx
	 uovj0cNWE+VsJavxNsKermEOi7dnRD0w4ec2lIx3G7Nd47TX1kVzP4H0jjSpLyHbcj5vv
	 YOC9MH/H4rMoxMZv8PTjtDpBe3KFM2PL0lvairJr7EsiaY86u/mO+e/MQLe8zyDS475AM
	 kbPXu1SEPOXFuvAR+IZSdrk5PYwjxaWSt7gG5mQBFAE996U6U2w6NcL/W77LLzjL3U0TA
	 XMceGLJIaG1JSx6dXgpCevaLAMJQ505/D3QjtivDugCH7WSBV5wT7pXhVOcOXvCVdew==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20251104 header.b=n+xAWEdm;
	arc=none smtp.remote-ip=209.85.128.51
Received: from mail-wm1-f51.google.com (mail-wm1-f51.google.com [209.85.128.51])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6176E606A322
	for <syzbot@lists.linux.dev>; Thu, 22 Oct 2026 09:14:16 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 6176E606A322
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20251104 header.b=n+xAWEdm
Received: by mail-wm1-f51.google.com with SMTP id 5b1f17b1804b1-4a20c923847so714975e9.0
        for <syzbot@lists.linux.dev>; Thu, 22 Oct 2026 02:14:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1792660455; x=1793265255; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=TT/G+LaV+N0GyZAIi03X4FvjbCyGL46ou/Kls81a/U4=;
        b=n+xAWEdmdStY9ATHFTo6w95wgSV2xnioaa/lp+02XBQ0l0OQc+zHPoiBFe6Ca45ZIy
         aa5XFbauwUgQI7OLP/keUUZhmvU53hgrkvZpY8OqB4hVJoZUAaCeUdWanuN6fPrmLjD8
         sWrT/fc6Z6w4ehvWmYX4xKddy9kc/I7Yc2QFFg6T2txLsmgMbhp6Y8fRfBSie6dJ32Bg
         qi9zTaikA3/daMoOrLcSZgabNcUo49Aj5MfzOJd8xdIsVFE2XMxjZ+P3V9DyxiCkm1Oy
         wgFL/+ROoKMEtIqvJCVfsZHfU/33VFrHBDj4o/hNqwIX+r3tIe8Og/dJs9knDi+ezue2
         EkXQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1792660455; x=1793265255;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=TT/G+LaV+N0GyZAIi03X4FvjbCyGL46ou/Kls81a/U4=;
        b=IiLYJ9HNJCtUcVQaeWYLlt/EtvP3aosZkQy8z5EtDR/dWprwtY3/qHxFDcvFCWvdUI
         ZF0xp+K/lrKtjkgEkwQHM3Vm8BGcRiIzR3ZzPAFKlBsi5PwNG4EXn3afY+MzFP4SZBi2
         1pd+5pGox4hU4Dm94Wdg56sNmhqm1j07B4GYV8nHhuuIKQgbi9OhjSF1B4iyQHI0cnQU
         E5wfofOEz8csQajL9wAM3b7djcKehDowZNi3nYrT0qog21cEWxGR0lRVjXMJyDKaZyZ2
         1kH+LyVNNBsr9mq6ubu7567RQlOBqb3zQ7ssz3uF/lEVbTtE1NKhzAMy65+7sb2N7gB+
         +jCg==
X-Forwarded-Encrypted: i=1; AKwUvBy1fp6DD6rjwtHELJj9lCX+DsQV9Nq4DE56deEX9AZmkboAbjgYAZ62EY1shIZRwhZr9tiy6+Q=@lists.linux.dev
X-Gm-Message-State: AFq9FYLn3oNSbgviNd5ry8jGh7Mj8230WkfZebhKshkQT/wH9dgLojzh
	ncMHaNWGTbSxflrOySkT9japOeVDcw1oZoSdjpOHti99MkQsjewECS3J
X-Gm-Gg: AYBFou3BfLxOT1mvwvDvpIkxgVUVNA+A0ojFBK7FjZyQAmbynD7KhYEvurggcYhj0W1
	NzjUpMKl5hDAfx9ei9FfoKLvAbSwka+/rVTEu6YUbK7cXjY3qGOXkpbvQGSTB0ZVKGmk8ORf7JI
	+EzYxQoh1ID7J3K8m2ADPyG/nikLxAJU7N8CUj6VOD0IZAn5eYX5nLU8x1TeI07TLpJVigbcU/O
	7jU4lHtheZQsdMqOEAT8uedhaII6h2DzsVCu0b3GkGXZb2zJvYwbzZKIwxUuRhC6AC6sqBj5C9Q
	G3NmPndAayJH1aC+dnzJgVqXAn0FFKYwC9gWKPi/Ab2A6h2sZC7ajcJGkw7wxg/kTVMhSz5vKFg
	DmPjJDpfOaj5wZ1qEkcXKAZfGJGqcol+QFgvMGR8Yoy3tMD+zrNjm/l6Yk3PVRDYm2PewW60Tu2
	MCDOI8yVZRE6q86cejcu3q9qCm6L5Xm5CnwIMly6E/rak64Xd1TsANNY2f3q+kX5GDZHMuCbGtQ
	mDk5L2WgTiS4+FjpXxxMmyMLWxAycIIK3tr85LQ3r5YPy6UIVIzXCIeGhpZz8+I1rUE2WOZmYVZ
	4WS3aKXJPZ5B3v7rkdXDwbCE1qY6KR8QEU3WinmHANFAbyNYrEKWFI1IR/Y9McVp0Hhk3t4Hoff
	/zz8Lj2rLljdbf7GPSBuhDMdCzWRZ4FzE8Gjp5t3j+l7fuMU1MFj5bLkCtrY5xhVpmjGncLnUA4
	RDXkn/y6XI3rtlxs5wGxZ9rOLoFL5kodVQKleJGq2qYwXCWg==
X-Received: by 2002:a05:600c:8b10:b0:4a1:fe55:88ef with SMTP id 5b1f17b1804b1-4a1fe558af6mr99646425e9.20.1792660454440;
        Thu, 22 Oct 2026 02:14:14 -0700 (PDT)
Received: from Ubuntu.tail0f733b.ts.net (87-205-15-91.static.ip.netia.com.pl. [87.205.15.91])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-4a203b3a4eesm52114055e9.7.2026.10.22.02.14.13
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 22 Oct 2026 02:14:14 -0700 (PDT)
From: Krystian Kaniewski <krystianmkaniewski@gmail.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	Neill Kapron <nkapron@google.com>,
	linux-usb@vger.kernel.org,
	Sebastian Andrzej Siewior <bigeasy@linutronix.de>
Cc: Mehmet Fide <mehmet.fide@gmail.com>,
	Brian Ellis <brianellis@gotenna.com>,
	Johan Hovold <johan@kernel.org>,
	Jiri Slaby <jirislaby@kernel.org>,
	linux-serial@vger.kernel.org,
	syzkaller-bugs@googlegroups.com,
	Ai Chao <aichao@kylinos.cn>,
	Kees Cook <kees@kernel.org>,
	linux-kernel@vger.kernel.org,
	syzbot@lists.linux.dev,
	syzbot+fe63e4d633540f230624@syzkaller.appspotmail.com,
	stable@kernel.org
Subject: [PATCH v2] usb: gadget: u_serial: pin ports while TTYs are installed
Date: Thu, 22 Oct 2026 11:13:59 +0200
Message-ID: <20261022091359.1187468-1-krystianmkaniewski@gmail.com>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <6941beb7-8cae-4cc5-ba07-e1c8a8753fe1@mail.kernel.org>
References: <6941beb7-8cae-4cc5-ba07-e1c8a8753fe1@mail.kernel.org>
X-Mailing-List: syzbot@lists.linux.dev
List-Id: <syzbot.lists.linux.dev>
List-Post: <mailto:syzbot@lists.linux.dev>
List-Help: <mailto:syzbot+help@lists.linux.dev>
List-Subscribe: <mailto:syzbot+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:syzbot+unsubscribe@lists.linux.dev>
List-Owner: <mailto:syzbot+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

A slab-use-after-free can occur when gserial_free_line() frees struct
gs_port while it is still reachable through an installed TTY. The
port->port.count value tracks successful opens, but it is zero before
gs_open() and again after gs_close(), before TTY cleanup has finished.
Teardown can therefore free gs_port while tty_init_dev() or release_tty()
still accesses its tty_port.

Manage gs_port lifetime with tty_port references. Take a reference in
gs_install(), drop it in gs_cleanup(), and move the final free to
gs_port_destruct(). Unregister the TTY device before dropping the owner
reference.

Keep each minor reserved until the old port is destroyed so an installed
TTY for one generation cannot overlap a replacement at the same minor.
Publish the new port before device registration so the cdev and add uevent
never expose a TTY before gs_install() can pin it. Since commit
8df07fe93573 ("tty: fix saved termios reset race"), u_serial registration
no longer frees saved termios. On registration failure, unpublish the port
before dropping its owner reference.

Check in gs_open() that the installed port is still the published
generation. Track failures after a successful install so close callbacks
issued by the TTY core do not decrement port->port.count for opens that
never incremented it.

Fixes: 19b10a8828a6 ("usb: gadget: allocate & giveback serial ports instead hard code them")
Assisted-by: Gemini:gemini-3.8-flash syzbot
Reported-by: syzbot+fe63e4d633540f230624@syzkaller.appspotmail.com
Closes: https://syzkaller.appspot.com/bug?extid=fe63e4d633540f230624
Link: https://syzkaller.appspot.com/ai_job?id=ec789387-2e7b-4a8f-a7a1-a47bf7fa57f5
Cc: stable@kernel.org
Signed-off-by: Krystian Kaniewski <krystianmkaniewski@gmail.com>
---
v2:
- Publish the port before TTY device registration so an open triggered by
  the add uevent cannot observe an unpublished slot.
- Drop the saved-termios rationale made obsolete by 8df07fe93573
  ("tty: fix saved termios reset race").
- Drop unreachable NULL checks in gs_open() and gs_close().
- Rebase to usb-next and mark the fix for stable backporting.
- Do not carry Mehmet's Tested-by tag because the registration ordering
  changed after his test.
v1: https://lore.kernel.org/r/6941beb7-8cae-4cc5-ba07-e1c8a8753fe1@mail.kernel.org/

Tested on usb-next in QEMU with KASAN, using the syzbot reproducer and
configuration: without the patch the use-after-free is reported, with it
there are no reports. A test that opens /dev/ttyGS0 while an ACM
function is created gets -ENODEV with v1 and not with v2.

Brian Ellis's "[PATCH v4] usb: gadget: u_serial: fix NULL deref in
gs_close() after failed open" fixes a crash that this patch also removes,
because gs_close() no longer sees a NULL driver_data after a failed open.
The two patches do not apply on top of each other:
https://lore.kernel.org/r/20261013-u_serial-gs-close-null-v4-1-9ea038501994@gotenna.com/

 drivers/usb/gadget/function/u_serial.c | 167 ++++++++++++++++++++-----
 1 file changed, 134 insertions(+), 33 deletions(-)

diff --git a/drivers/usb/gadget/function/u_serial.c b/drivers/usb/gadget/function/u_serial.c
index cdd1dfc666c4f..41dee2afef5c6 100644
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
+ *   - Retiring:   !port &&  reserved
+ *
+ * A minor remains reserved until gs_port_destruct() runs upon final tty_port
+ * release, preventing minor reuse while cleanup of the installed TTY is still
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
@@ -603,22 +623,60 @@ static int gserial_wakeup_host(struct gserial *gser)
 
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
 
 	mutex_lock(&ports[port_num].lock);
-	port = ports[port_num].port;
-	if (!port) {
+	if (ports[port_num].port != port) {
 		status = -ENODEV;
-		goto out;
+		goto fail_unlock;
 	}
 
 	spin_lock_irq(&port->port_lock);
@@ -638,7 +696,7 @@ static int gs_open(struct tty_struct *tty, struct file *file)
 		if (status) {
 			pr_debug("gs_open: ttyGS%d (%p,%p) no buffer\n",
 				 port_num, tty, file);
-			goto out;
+			goto fail_unlock;
 		}
 
 		spin_lock_irq(&port->port_lock);
@@ -648,7 +706,6 @@ static int gs_open(struct tty_struct *tty, struct file *file)
 	if (port->port.count++)
 		goto exit_unlock_port;
 
-	tty->driver_data = port;
 	port->port.tty = tty;
 
 	/* if connected, start the I/O stream */
@@ -672,7 +729,11 @@ static int gs_open(struct tty_struct *tty, struct file *file)
 
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
@@ -695,6 +756,11 @@ static void gs_close(struct tty_struct *tty, struct file *file)
 	struct gs_port *port = tty->driver_data;
 	struct gserial	*gser;
 
+	if (port->open_close_failures > 0) {
+		port->open_close_failures--;
+		return;
+	}
+
 	spin_lock_irq(&port->port_lock);
 
 	if (port->port.count != 1) {
@@ -909,8 +975,10 @@ static int gs_get_icount(struct tty_struct *tty,
 }
 
 static const struct tty_operations gs_tty_ops = {
+	.install =		gs_install,
 	.open =			gs_open,
 	.close =		gs_close,
+	.cleanup =		gs_cleanup,
 	.write =		gs_write,
 	.put_char =		gs_put_char,
 	.flush_chars =		gs_flush_chars,
@@ -1203,14 +1271,41 @@ static void gs_console_exit(struct gs_port *port)
 
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
@@ -1222,6 +1317,7 @@ gs_port_alloc(unsigned port_num, struct usb_cdc_line_coding *coding)
 	}
 
 	tty_port_init(&port->port);
+	port->port.ops = &gs_port_ops;
 	spin_lock_init(&port->port_lock);
 	init_waitqueue_head(&port->drain_wait);
 	init_waitqueue_head(&port->close_wait);
@@ -1235,10 +1331,14 @@ gs_port_alloc(unsigned port_num, struct usb_cdc_line_coding *coding)
 	port->port_num = port_num;
 	port->port_line_coding = *coding;
 
+	ports[port_num].reserved = true;
 	ports[port_num].port = port;
+	mutex_unlock(&ports[port_num].lock);
+	return port;
+
 out:
 	mutex_unlock(&ports[port_num].lock);
-	return ret;
+	return ERR_PTR(ret);
 }
 
 static int gs_closed(struct gs_port *port)
@@ -1258,8 +1358,7 @@ static void gserial_free_port(struct gs_port *port)
 	/* wait for old opens to finish */
 	wait_event(port->close_wait, gs_closed(port));
 	WARN_ON(port->port_usb != NULL);
-	tty_port_destroy(&port->port);
-	kfree(port);
+	tty_port_put(&port->port);
 }
 
 void gserial_free_line(unsigned char port_num)
@@ -1276,15 +1375,15 @@ void gserial_free_line(unsigned char port_num)
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
@@ -1295,19 +1394,20 @@ int gserial_alloc_line_no_console(unsigned char *line_num)
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
@@ -1316,14 +1416,15 @@ int gserial_alloc_line_no_console(unsigned char *line_num)
 
 		ret = PTR_ERR(tty_dev);
 		mutex_lock(&ports[port_num].lock);
+		WARN_ON(ports[port_num].port != port);
 		ports[port_num].port = NULL;
 		mutex_unlock(&ports[port_num].lock);
-		gserial_free_port(port);
-		goto err;
+		tty_port_put(&port->port);
+		return ret;
 	}
+
 	*line_num = port_num;
-err:
-	return ret;
+	return 0;
 }
 EXPORT_SYMBOL_GPL(gserial_alloc_line_no_console);
 

base-commit: bdf12cde30830d46a8ef1ba93986356f1164b4f1
-- 
2.53.0

