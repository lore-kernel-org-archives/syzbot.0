Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8369E37DEA3
	for <syzbot@lists.linux.dev>; Sun,  2 Aug 2026 21:15:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785705348; cv=none; b=kYiaioZEUea+Rl2i2c6y+a9IAdZRntxAvMGRjK/2VHdfZTJZAw9RL6WrRWAqr1rskdsQAsZ+sPbmyfYhLPtR+NABbrI110+r98V1qBNKEH3nekBoad7Zo+JTtzQ7Oem6IKZutVF3S4ct1PmcIO8Zk8PG1WKepx1JJF5t+6H3PbY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785705348; c=relaxed/simple;
	bh=1QdYTxzXg7L+zIw0uaRymfk7c+WjIg2+oJgo0LRuaHU=;
	h=From:To:Cc:Subject:Message-ID:MIME-Version:Content-Type:Date; b=tBm/1ZFDkMoz6LgBHX9BpjlkAoYoYL4dY2+zONeOvEVb6zDdlOxyXCTdMXP8Nbk1lbRts9Qi+NTVALB3DmempHGc74mZLHwEV/iYZRI/9M0XE74xbJKKB6ZCBixIKcpYKu4OLFGN2SQoJhh63TMlip+Ea+XOtatC8q5PcYwY9H8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=IR2rzioT; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="IR2rzioT"
Received: by smtp.kernel.org (Postfix) with UTF8SMTPSA id 786D61F000E9;
	Sun,  2 Aug 2026 21:15:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1785705340;
	bh=xBTDZHHEG7yImiypUNDozFLyRmvhU31Mjq5vueauVds=;
	h=From:To:Cc:Subject:Date;
	b=IR2rzioTYa5jSdU5ygJEusSaD+RcZ4KqpkFb+lG0VyX0tIYxA9S3up+H3srE8akws
	 zj2GC7OwkkG69Cpu+O41KAlbOJrYdunOpYLvmANh9pE2p8nDtDpRO7mMSl/NXWugx4
	 a3pJ+n+uuAhVUDyosoUCs5U1iokQwChHw+gZBXByzGrqrqMu0WIp47bvKzf34o5u0/
	 JcXq5K/xH7hvw8wa8CfqH8hKrlYyfBDL1xTyoIJMtFa9p9p7QHwfpdEyWOJzdcns58
	 P5tOfsBuPUKC1kNRT64Qx8ZYvYMeOeBlXvoqVH2CaToA2bsPz/+bo3f9CmA/dtenJl
	 IRnzvhLCJVx+g==
From: "syzbot" <syzbot@kernel.org>
To: syzkaller-upstream-moderation@googlegroups.com
Cc: syzbot@lists.linux.dev
Subject: [PATCH RFC] usb: gadgetfs: dequeue ep0 request before freeing it
Message-ID: <161c70c4-a363-469d-8665-64f71763f84b@mail.kernel.org>
Precedence: bulk
X-Mailing-List: syzbot@lists.linux.dev
List-Id: <syzbot.lists.linux.dev>
List-Subscribe: <mailto:syzbot+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:syzbot+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Date: Sun,  2 Aug 2026 21:15:40 +0000 (UTC)

The gadgetfs driver frees its endpoint 0 request (dev->req) during the
unbind process without first dequeuing it. When the USB Device Controller
(UDC) is subsequently stopped, it attempts to flush all pending requests
from its endpoint queues, leading to a use-after-free when it accesses the
already freed dev->req.

In gadgetfs_unbind(), the code assumes that because the device has been
disconnected, no I/O is active, and it directly frees dev->req without
dequeuing it. However, if the port was never fully powered/enabled or if a
disconnect event didn't trigger a full cleanup in the UDC, requests can
remain in the endpoint queues. When the UDC is subsequently stopped (e.g.,
dummy_udc_stop() calling nuke()), it attempts to flush all pending requests
from its queues, leading to a use-after-free when it accesses the already
freed dev->req.

BUG: KASAN: slab-use-after-free in
__list_del_entry_valid_or_report+0x3c/0x1b8 lib/list_debug.c:49
Read of size 8 at addr ffff0000d6655308 by task syz-executor239/8549
CPU: 0 UID: 0 PID: 8549 Comm: syz-executor239 Tainted: G        W
syzkaller #1 PREEMPT
Tainted: [W]=WARN
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS
Google 07/02/2026
Call trace:
 show_stack+0x2c/0x3c arch/arm64/kernel/stacktrace.c:499 (C)
 __dump_stack+0x30/0x40 lib/dump_stack.c:94
 dump_stack_lvl+0xd8/0x12c lib/dump_stack.c:120
 print_address_description+0xb0/0x238 mm/kasan/report.c:378
 print_report+0x68/0x84 mm/kasan/report.c:482
 kasan_report+0x8c/0xc4 mm/kasan/report.c:595
 __asan_report_load8_noabort+0x20/0x2c mm/kasan/report_generic.c:381
 __list_del_entry_valid_or_report+0x3c/0x1b8 lib/list_debug.c:49
 __list_del_entry_valid include/linux/list.h:132 [inline]
 __list_del_entry include/linux/list.h:246 [inline]
 list_del_init include/linux/list.h:318 [inline]
 nuke+0x60/0x194 drivers/usb/gadget/udc/dummy_hcd.c:360
 stop_activity drivers/usb/gadget/udc/dummy_hcd.c:379 [inline]
 dummy_udc_stop+0xe4/0x180 drivers/usb/gadget/udc/dummy_hcd.c:1057
 usb_gadget_udc_stop_locked drivers/usb/gadget/udc/core.c:1265 [inline]
 gadget_unbind_driver+0x204/0x790 drivers/usb/gadget/udc/core.c:1727
 device_remove+0xc4/0x134 drivers/base/dd.c:616

To fix this, explicitly call usb_ep_dequeue() on dev->req before freeing it
in gadgetfs_unbind(). This must be done before gadget->ep0->driver_data is
set to NULL because if the UDC synchronously invokes the completion
callback during the dequeue, the callback might rely on ep->driver_data,
and clearing it beforehand could cause a NULL pointer dereference. The
dequeue is safely placed outside the spin_lock_irq(&dev->lock) block to
avoid deadlocks in case the completion callback unconditionally acquires
dev->lock.

Fixes: 1da177e4c3f4 ("Linux-2.6.12-rc2")
Assisted-by: Gemini:gemini-3.5-flash Gemini:gemini-3.1-pro-preview syzbot
Reported-by: syzbot+c73e1942197af9f54ca3@syzkaller.appspotmail.com
Closes: https://syzkaller.appspot.com/bug?extid=c73e1942197af9f54ca3
Link: https://syzkaller.appspot.com/ai_job?id=e95b2737-0582-4db2-9c86-a70a9a1e16cc
To: "Greg Kroah-Hartman" <gregkh@linuxfoundation.org>
To: <linux-usb@vger.kernel.org>
To: "Linus Torvalds" <torvalds@ppc970.osdl.org>
Cc: "Christian Brauner" <brauner@kernel.org>
Cc: "Jan Kara" <jack@suse.cz>
Cc: "Kees Cook" <kees@kernel.org>
Cc: <linux-kernel@vger.kernel.org>
Cc: "Mateusz Guzik" <mjguzik@gmail.com>
Cc: "Al Viro" <viro@zeniv.linux.org.uk>

---
diff --git a/drivers/usb/gadget/legacy/inode.c b/drivers/usb/gadget/legacy/inode.c
index d87a8ab51..38bcdeafe 100644
--- a/drivers/usb/gadget/legacy/inode.c
+++ b/drivers/usb/gadget/legacy/inode.c
@@ -1652,13 +1652,16 @@ gadgetfs_unbind (struct usb_gadget *gadget)
 	}
 	spin_unlock_irq (&dev->lock);
 
+	if (dev->req) {
+		usb_ep_dequeue(gadget->ep0, dev->req);
+		usb_ep_free_request(gadget->ep0, dev->req);
+		dev->req = NULL;
+	}
+
 	destroy_ep_files (dev);
 	gadget->ep0->driver_data = NULL;
 	set_gadget_data (gadget, NULL);
 
-	/* we've already been disconnected ... no i/o is active */
-	if (dev->req)
-		usb_ep_free_request (gadget->ep0, dev->req);
 	DBG (dev, "%s done\n", __func__);
 	put_dev (dev);
 }


base-commit: f5098b6bae761e346ebcd9da7f95622c04733cff
-- 
This is an AI-generated patch subject to moderation.
Reply with '#syz upstream' to Sign-off the patch as a human author
and send it to the upstream kernel mailing lists.
Reply with '#syz reject' to reject it ('#syz unreject' to undo).

See https://goo.gle/syzbot-ai-patches for information about AI-generated patches.
You can comment on the patch as usual, syzbot will try to address
the comments and send a new version of the patch if necessary.
syzbot engineers can be reached at syzkaller@googlegroups.com.
