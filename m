Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7ECFC33DEFD
	for <syzbot@lists.linux.dev>; Fri,  7 Aug 2026 02:30:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786069810; cv=none; b=ISKN+kV6fINaxW3qz8G+5EEBlCURqelN2Jacy89KGLIwQZiQNKGjQxb/jRexNeK6gGcOiYGa6tzSWaJW5gCfOv/fH+63VmK8mhxWjOFgpw9He9oXZfgIAMqzEJQ1ogtQz0TvrOwqpVL6u0OH58y/lIkHcTh1ps83WcBkb6+rWIM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786069810; c=relaxed/simple;
	bh=In9wSjitMdfIe1fsdW5TGoMy+rfz5Ilj9/DMl2x0mLM=;
	h=From:To:Cc:Subject:Message-ID:MIME-Version:Content-Type:Date; b=IesXLAzpuLxY02YudZUYoOxD3a8frjFdixuu+mz5YwL1wjukyQaiCrEed0VsolQ+ebTn//YiydVIzm1e4W1lhxFo6ICCAPUF9+msP1ePVx0LaXlwG1AZMKw+uOmgOpV59pdNSbCfojM8w9JkRN9mJIjDT+WDq3WmAv+W/9du1jo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=iKcWrIqE; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="iKcWrIqE"
Received: by smtp.kernel.org (Postfix) with UTF8SMTPSA id AD1BE1F00A3A;
	Fri,  7 Aug 2026 02:30:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1786069807;
	bh=pwPt+ZglWQzJOL3mof72eQrkhqRDWzmf5q1S/KWW6gQ=;
	h=From:To:Cc:Subject:Date;
	b=iKcWrIqEz+vcbwXzgl58plx9C6aErPwTEWEg7b0zw3uKGNkkA8zKcEOvBbwyMgThV
	 SSHlIsLp08NQqG7vj7QaYXazJ7CFB3mVCKcD3fushQRKGFFjjjZ76geCeiZlV6eOAx
	 bGsao+rC+2x8ZfUDKNF+NBjOLyM9gHV21+Jtln4ZYIYglyVmxISdgTIo95Y3k2hCty
	 7NwFcVmhZFUKE0zOf+l05bUgDb4nmjt/IvrqtJDRgQDRB9FASyYHz+DocmMSACZ6x2
	 tUQEIZ/0tUse+G6fnmZfue+9568QZiU7vPFGZVj+Co9VnBvRcb4ubNC27ZZouYtZsA
	 KLDTe4noUqRyg==
From: "syzbot" <syzbot@kernel.org>
To: syzkaller-upstream-moderation@googlegroups.com
Cc: syzbot@lists.linux.dev
Subject: [PATCH RFC] USB: serial: spcp8x5: drop carrier_raised callback
Message-ID: <c523fe26-ff24-4e16-ab25-440592b4f565@mail.kernel.org>
Precedence: bulk
X-Mailing-List: syzbot@lists.linux.dev
List-Id: <syzbot.lists.linux.dev>
List-Subscribe: <mailto:syzbot+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:syzbot+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Date: Fri,  7 Aug 2026 02:30:07 +0000 (UTC)

When a TTY device is opened, the generic TTY layer calls
tty_port_block_til_ready() to wait for the carrier detect (DCD) line to be
raised. This function sets the task state to TASK_INTERRUPTIBLE and then
calls the driver's .carrier_raised callback.

In the spcp8x5 driver, the spcp8x5_carrier_raised() callback calls
spcp8x5_get_msr(), which allocates memory with GFP_KERNEL and sends a USB
control message. Both of these operations can sleep. Calling sleeping
functions while the task state is TASK_INTERRUPTIBLE is invalid and
triggers a __might_sleep warning:

do not call blocking ops when !TASK_RUNNING; state=1 set at
[<ffffffff819e7a64>] prepare_to_wait+0x174/0x210 kernel/sched/wait.c:256
WARNING: kernel/sched/core.c:9124 at __might_sleep+0x92/0xf0
kernel/sched/core.c:9120
...
Call Trace:
 <TASK>
 might_alloc include/linux/sched/mm.h:323 [inline]
 slab_pre_alloc_hook mm/slub.c:4537 [inline]
 slab_alloc_node mm/slub.c:4897 [inline]
 __kmalloc_cache_noprof+0x94/0x660 mm/slub.c:5485
 _kmalloc_noprof include/linux/slab.h:988 [inline]
 _kzalloc_noprof include/linux/slab.h:1309 [inline]
 spcp8x5_get_msr+0xd3/0x2d0 drivers/usb/serial/spcp8x5.c:197
 spcp8x5_carrier_raised+0x30/0x80 drivers/usb/serial/spcp8x5.c:243
 serial_port_carrier_raised+0x8c/0xc0 drivers/usb/serial/usb-serial.c:757
 tty_port_carrier_raised drivers/tty/tty_port.c:441 [inline]
 tty_port_block_til_ready+0x449/0x8b0 drivers/tty/tty_port.c:559
 tty_open+0x48a/0xcc0 drivers/tty/tty_io.c:2137

Furthermore, because usb_control_msg() waits for the URB completion, it
internally uses wait_for_completion_timeout(), which resets the task state
back to TASK_RUNNING. When spcp8x5_carrier_raised() returns to
tty_port_block_til_ready(), the task state is no longer TASK_INTERRUPTIBLE.
The subsequent schedule() call sees TASK_RUNNING and returns immediately
without blocking, accidentally turning the wait loop into a 100% CPU
busy-polling loop that constantly spams the USB device with control
messages until the carrier is raised.

Unlike some other USB serial adapters, the spcp8x5 hardware does not have
an interrupt IN endpoint. This means it cannot receive asynchronous
notifications when the modem status changes, and therefore the driver can
never wake up a sleeping task waiting for carrier detect. A device that
cannot asynchronously detect carrier changes cannot support blocking on
carrier detect.

Fix this by completely removing the .carrier_raised callback from the
spcp8x5_device struct and deleting the spcp8x5_carrier_raised() function.
When .carrier_raised is NULL, tty_port_carrier_raised() defaults to
returning true. This allows the TTY open operation to proceed immediately
without blocking, which is the standard and expected behavior for devices
lacking asynchronous carrier detect capabilities.

Fixes: e1ed212d8593 ("USB: spcp8x5: add proper modem-status support")
Assisted-by: Gemini:gemini-3.5-flash Gemini:gemini-3.1-pro-preview syzbot
Reported-by: syzbot+3b514b87202742f22c44@syzkaller.appspotmail.com
Closes: https://syzkaller.appspot.com/bug?extid=3b514b87202742f22c44
Link: https://syzkaller.appspot.com/ai_job?id=0fb9718c-010d-42ad-a2c2-a1593fbfbe39
To: "Greg Kroah-Hartman" <gregkh@linuxfoundation.org>
To: "Johan Hovold" <johan@kernel.org>
To: <linux-usb@vger.kernel.org>
To: "Johan Hovold" <jhovold@gmail.com>
Cc: <linux-kernel@vger.kernel.org>

---
diff --git a/drivers/usb/serial/spcp8x5.c b/drivers/usb/serial/spcp8x5.c
index c11d64bf0..f610aef6b 100644
--- a/drivers/usb/serial/spcp8x5.c
+++ b/drivers/usb/serial/spcp8x5.c
@@ -235,18 +235,6 @@ static void spcp8x5_set_work_mode(struct usb_serial_port *port, u16 value,
 		dev_err(&port->dev, "failed to set work mode: %d\n", ret);
 }
 
-static int spcp8x5_carrier_raised(struct usb_serial_port *port)
-{
-	u8 msr;
-	int ret;
-
-	ret = spcp8x5_get_msr(port, &msr);
-	if (ret || msr & MSR_STATUS_LINE_DCD)
-		return 1;
-
-	return 0;
-}
-
 static void spcp8x5_dtr_rts(struct usb_serial_port *port, int on)
 {
 	struct spcp8x5_private *priv = usb_get_serial_port_data(port);
@@ -458,7 +446,6 @@ static struct usb_serial_driver spcp8x5_device = {
 	.num_bulk_out		= 1,
 	.open			= spcp8x5_open,
 	.dtr_rts		= spcp8x5_dtr_rts,
-	.carrier_raised		= spcp8x5_carrier_raised,
 	.set_termios		= spcp8x5_set_termios,
 	.init_termios		= spcp8x5_init_termios,
 	.tiocmget		= spcp8x5_tiocmget,


base-commit: 075b74841bd0065a3bda3440873c747938e69b68
-- 
This is an AI-generated patch subject to moderation.
Reply with '#syz upstream' to Sign-off the patch as a human author
and send it to the upstream kernel mailing lists.
Reply with '#syz reject' to reject it ('#syz unreject' to undo).

See https://goo.gle/syzbot-ai-patches for information about AI-generated patches.
The person who has signed off on the patch is responsible for
addressing comments.
syzbot engineers can be reached at syzkaller@googlegroups.com.
