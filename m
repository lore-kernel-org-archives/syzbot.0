Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1D65A44B66B
	for <syzbot@lists.linux.dev>; Wed, 29 Jul 2026 09:55:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785318931; cv=none; b=cDJWPLHEy/dahzSMwdv7wKGdlQfOgfVo92wgiQAiMIH3Ksojt49iQ2odYuB4/EvDX1GbGlvFXfbb0lsVedDNovqSQY0Quh4+frQJPIq+Knv6YTCmuSvqBkjHgZ8KTCpovfOO1WjRCbTUw+I5j+MXbCbahd9obsiVuyq0Ez+q2IY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785318931; c=relaxed/simple;
	bh=33LSsWxaGWNlrsHR/DR7ZL/8LHSdrMxf472LIDH6/tw=;
	h=From:To:Cc:Subject:Message-ID:MIME-Version:Content-Type:Date; b=KGTUs0cCvN5FP94ZYbiE/IdyzP3iDdsRMEPDNYxxpz6krSyPjTH5dPYwfkyPeTUFfEPS3H1S4f2VXX1Ze8AfJxihc0yiTeJZBIFNzZ7swbDc1i5POvJMF3fQgvGFxQ+03XQEjxuV7DYOR0uKGy97rlU1lU2Ce1qu2ppZ39s1ABk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=astRIAGJ; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="astRIAGJ"
Received: by smtp.kernel.org (Postfix) with UTF8SMTPSA id 8274A1F000E9;
	Wed, 29 Jul 2026 09:55:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1785318924;
	bh=gEE9PLN/1s2N9hIHKFDzz4p66H54iapyHeRbxSEUKUY=;
	h=From:To:Cc:Subject:Date;
	b=astRIAGJfpLhnr3aT+Pp88KBEOVRyy8a+55paVpSDp359oNL0jo57oPC3nfMTPJ8r
	 /MM7OOl/9JP7mrnBQpVFUQduClsjArao1X2hfEx31v9hwfsZsKkO/C8/gtkcIn9m8S
	 JQRZhWolEKKdhz4a7BQl0VMdnuq1zMXkmiR0MJ5ZP4zQaxVAlTL+pmEGc2/SR0stbA
	 GLa2eOph9P98dA80cjVjL/MnqpCWLNyTl1Cmr0BhwOUhwreg7Hc6ptWF8KxiuO1TOB
	 fupGCY8gyMJiJjdFAQkfwcjqC+xSqGnSko/amqBTlFRgyuJwsrIyWzqNy7uWp9CE2G
	 Bl5unGj2laW/A==
From: "syzbot" <syzbot@kernel.org>
To: syzkaller-upstream-moderation@googlegroups.com
Cc: syzbot@lists.linux.dev
Subject: [PATCH RFC] usb: raw-gadget: fix use-after-free during gadget unbind
Message-ID: <7e44f4c6-6cfb-490b-b037-10d9921f9f54@mail.kernel.org>
Precedence: bulk
X-Mailing-List: syzbot@lists.linux.dev
List-Id: <syzbot.lists.linux.dev>
List-Subscribe: <mailto:syzbot+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:syzbot+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Date: Wed, 29 Jul 2026 09:55:24 +0000 (UTC)

A use-after-free vulnerability occurs in the raw-gadget driver when the
underlying USB Device Controller (UDC) is unbound while concurrent ioctls
are in progress.

When the UDC is unbound, gadget_unbind() is called. However, this function
fails to clear the dev->gadget pointer and update dev->state. It only
clears the driver data. After gadget_unbind() returns, the UDC core frees
the struct usb_gadget and its associated device name string.

If a concurrent ioctl (e.g., USB_RAW_IOCTL_EP0_READ) is executing, it may
pass the state checks because dev->state was not updated, and proceed to
use the dangling dev->gadget pointer. If usb_ep_queue() fails (e.g., due to
the UDC being disconnected), the error path attempts to print an error
message using dev_err(&dev->gadget->dev, ...), which dereferences the freed
device name string, resulting in a KASAN slab-use-after-free crash:

BUG: KASAN: slab-use-after-free in string_nocheck lib/vsprintf.c:648
[inline]
BUG: KASAN: slab-use-after-free in string+0x216/0x2d0 lib/vsprintf.c:730
Read of size 1 at addr ffff888195535600 by task syz.0.40/6395
...
Call Trace:
 <TASK>
...
 string_nocheck lib/vsprintf.c:648 [inline]
 string+0x216/0x2d0 lib/vsprintf.c:730
 vsnprintf+0x74a/0xef0 lib/vsprintf.c:2945
 snprintf+0xe8/0x140 lib/vsprintf.c:3043
 set_dev_info drivers/base/core.c:4984 [inline]
 dev_vprintk_emit+0x30f/0x400 drivers/base/core.c:4994
 dev_printk_emit+0xee/0x140 drivers/base/core.c:5007
 _dev_err+0x11e/0x180 drivers/base/core.c:5062
 raw_process_ep0_io+0x531/0x990 drivers/usb/gadget/legacy/raw_gadget.c:730
 raw_ioctl_ep0_read drivers/usb/gadget/legacy/raw_gadget.c:782 [inline]
 raw_ioctl+0x2721/0x40d0 drivers/usb/gadget/legacy/raw_gadget.c:1316
...

To fix this, gadget_unbind() must clear dev->gadget and update dev->state
to STATE_DEV_FAILED under dev->lock.

To prevent race conditions where an ioctl has already passed the checks but
hasn't yet called usb_ep_queue(), a synchronization mechanism is
introduced. A udc_usage counter tracks ongoing UDC calls. gadget_unbind()
waits for this counter to drop to zero before returning.

To avoid deadlocks where ioctls are waiting for I/O completion,
gadget_unbind() explicitly dequeues all pending requests before waiting for
udc_usage to drop. This forces the UDC core to complete the requests
immediately, waking up the waiting ioctls so they can decrement udc_usage
and signal the completion.

Additionally, if an ioctl is interrupted by a signal, it checks if
dev->state == STATE_DEV_FAILED. If so, it knows gadget_unbind() is handling
the dequeue and simply waits for the completion handler to finish. Finally,
proper cleanup is added in gadget_bind() if the connect event fails to
queue, and dev_err() calls are updated to use dev->dev instead of
dev->gadget->dev to avoid dereferencing the gadget pointer in error paths.

Fixes: f2c2e717642c ("usb: gadget: add raw-gadget interface")
Assisted-by: Gemini:gemini-3.5-flash Gemini:gemini-3.1-pro-preview syzbot
Reported-by: syzbot+9aacea11bc70c3ddaff2@syzkaller.appspotmail.com
Closes: https://syzkaller.appspot.com/bug?extid=9aacea11bc70c3ddaff2
Link: https://syzkaller.appspot.com/ai_job?id=2b271df2-0caf-4de1-92ff-99534a3e1708
To: "Greg Kroah-Hartman" <gregkh@linuxfoundation.org>
To: <linux-usb@vger.kernel.org>
To: "Andrey Konovalov" <andreyknvl@google.com>
Cc: "Andrey Konovalov" <andreyknvl@gmail.com>
Cc: "Kees Cook" <kees@kernel.org>
Cc: "Gopi Krishna Menon" <krishnagopi487@gmail.com>
Cc: <linux-kernel@vger.kernel.org>

---
diff --git a/drivers/usb/gadget/legacy/raw_gadget.c b/drivers/usb/gadget/legacy/raw_gadget.c
index 4febf8dac..bce4f8d3f 100644
--- a/drivers/usb/gadget/legacy/raw_gadget.c
+++ b/drivers/usb/gadget/legacy/raw_gadget.c
@@ -175,6 +175,8 @@ struct raw_dev {
 	bool				gadget_registered;
 	struct usb_gadget		*gadget;
 	struct usb_request		*req;
+	int				udc_usage;
+	struct completion		*unbind_completion;
 	bool				ep0_in_pending;
 	bool				ep0_out_pending;
 	bool				ep0_urb_queued;
@@ -205,27 +207,13 @@ static struct raw_dev *dev_new(void)
 static void dev_free(struct kref *kref)
 {
 	struct raw_dev *dev = container_of(kref, struct raw_dev, count);
-	int i;
 
 	kfree(dev->udc_name);
 	kfree(dev->driver.udc_name);
 	kfree(dev->driver.driver.name);
 	if (dev->driver_id_number >= 0)
 		ida_free(&driver_id_numbers, dev->driver_id_number);
-	if (dev->req) {
-		if (dev->ep0_urb_queued)
-			usb_ep_dequeue(dev->gadget->ep0, dev->req);
-		usb_ep_free_request(dev->gadget->ep0, dev->req);
-	}
 	raw_event_queue_destroy(&dev->queue);
-	for (i = 0; i < dev->eps_num; i++) {
-		if (dev->eps[i].state == STATE_EP_DISABLED)
-			continue;
-		usb_ep_disable(dev->eps[i].ep);
-		usb_ep_free_request(dev->eps[i].ep, dev->eps[i].req);
-		kfree(dev->eps[i].ep->desc);
-		dev->eps[i].state = STATE_EP_DISABLED;
-	}
 	kfree(dev);
 }
 
@@ -316,6 +304,11 @@ static int gadget_bind(struct usb_gadget *gadget,
 	ret = raw_queue_event(dev, USB_RAW_EVENT_CONNECT, 0, NULL);
 	if (ret < 0) {
 		dev_err(&gadget->dev, "failed to queue connect event\n");
+		spin_lock_irqsave(&dev->lock, flags);
+		dev->gadget = NULL;
+		dev->req = NULL;
+		spin_unlock_irqrestore(&dev->lock, flags);
+		usb_ep_free_request(gadget->ep0, req);
 		set_gadget_data(gadget, NULL);
 		return ret;
 	}
@@ -328,6 +321,47 @@ static int gadget_bind(struct usb_gadget *gadget,
 static void gadget_unbind(struct usb_gadget *gadget)
 {
 	struct raw_dev *dev = get_gadget_data(gadget);
+	unsigned long flags;
+	DECLARE_COMPLETION_ONSTACK(done);
+	int i;
+
+	spin_lock_irqsave(&dev->lock, flags);
+	dev->state = STATE_DEV_FAILED;
+
+	if (dev->ep0_urb_queued) {
+		spin_unlock_irqrestore(&dev->lock, flags);
+		usb_ep_dequeue(gadget->ep0, dev->req);
+		spin_lock_irqsave(&dev->lock, flags);
+	}
+	for (i = 0; i < dev->eps_num; i++) {
+		if (dev->eps[i].state == STATE_EP_ENABLED && dev->eps[i].urb_queued) {
+			spin_unlock_irqrestore(&dev->lock, flags);
+			usb_ep_dequeue(dev->eps[i].ep, dev->eps[i].req);
+			spin_lock_irqsave(&dev->lock, flags);
+		}
+	}
+
+	if (dev->udc_usage > 0) {
+		dev->unbind_completion = &done;
+		spin_unlock_irqrestore(&dev->lock, flags);
+		wait_for_completion(&done);
+		spin_lock_irqsave(&dev->lock, flags);
+	}
+	dev->gadget = NULL;
+	spin_unlock_irqrestore(&dev->lock, flags);
+
+	for (i = 0; i < dev->eps_num; i++) {
+		if (dev->eps[i].state == STATE_EP_DISABLED)
+			continue;
+		usb_ep_disable(dev->eps[i].ep);
+		usb_ep_free_request(dev->eps[i].ep, dev->eps[i].req);
+		kfree(dev->eps[i].ep->desc);
+		dev->eps[i].state = STATE_EP_DISABLED;
+	}
+	if (dev->req) {
+		usb_ep_free_request(gadget->ep0, dev->req);
+		dev->req = NULL;
+	}
 
 	set_gadget_data(gadget, NULL);
 	/* Matches kref_get() in gadget_bind(). */
@@ -637,11 +671,11 @@ static int raw_ioctl_event_fetch(struct raw_dev *dev, unsigned long value)
 
 	event = raw_event_queue_fetch(&dev->queue);
 	if (PTR_ERR(event) == -EINTR) {
-		dev_dbg(&dev->gadget->dev, "event fetching interrupted\n");
+		dev_dbg(dev->dev, "event fetching interrupted\n");
 		return -EINTR;
 	}
 	if (IS_ERR(event)) {
-		dev_err(&dev->gadget->dev, "failed to fetch event\n");
+		dev_err(dev->dev, "failed to fetch event\n");
 		spin_lock_irqsave(&dev->lock, flags);
 		dev->state = STATE_DEV_FAILED;
 		spin_unlock_irqrestore(&dev->lock, flags);
@@ -723,22 +757,37 @@ static int raw_process_ep0_io(struct raw_dev *dev, struct usb_raw_ep_io *io,
 	dev->req->length = io->length;
 	dev->req->zero = usb_raw_io_flags_zero(io->flags);
 	dev->ep0_urb_queued = true;
+	dev->udc_usage++;
 	spin_unlock_irqrestore(&dev->lock, flags);
 
 	ret = usb_ep_queue(dev->gadget->ep0, dev->req, GFP_KERNEL);
 	if (ret) {
-		dev_err(&dev->gadget->dev,
-				"fail, usb_ep_queue returned %d\n", ret);
+		dev_err(dev->dev, "fail, usb_ep_queue returned %d\n", ret);
 		spin_lock_irqsave(&dev->lock, flags);
+		dev->udc_usage--;
+		if (!dev->udc_usage && dev->unbind_completion)
+			complete(dev->unbind_completion);
 		goto out_queue_failed;
 	}
 
 	ret = wait_for_completion_interruptible(&dev->ep0_done);
 	if (ret) {
-		dev_dbg(&dev->gadget->dev, "wait interrupted\n");
-		usb_ep_dequeue(dev->gadget->ep0, dev->req);
-		wait_for_completion(&dev->ep0_done);
+		dev_dbg(dev->dev, "wait interrupted\n");
 		spin_lock_irqsave(&dev->lock, flags);
+		if (dev->state != STATE_DEV_FAILED && dev->gadget) {
+			struct usb_ep *ep0 = dev->gadget->ep0;
+
+			spin_unlock_irqrestore(&dev->lock, flags);
+
+			usb_ep_dequeue(ep0, dev->req);
+			wait_for_completion(&dev->ep0_done);
+
+			spin_lock_irqsave(&dev->lock, flags);
+		} else {
+			spin_unlock_irqrestore(&dev->lock, flags);
+			wait_for_completion(&dev->ep0_done);
+			spin_lock_irqsave(&dev->lock, flags);
+		}
 		if (dev->ep0_status == -ECONNRESET)
 			dev->ep0_status = -EINTR;
 		goto out_interrupted;
@@ -750,6 +799,9 @@ static int raw_process_ep0_io(struct raw_dev *dev, struct usb_raw_ep_io *io,
 	ret = dev->ep0_status;
 out_queue_failed:
 	dev->ep0_urb_queued = false;
+	dev->udc_usage--;
+	if (!dev->udc_usage && dev->unbind_completion)
+		complete(dev->unbind_completion);
 out_unlock:
 	spin_unlock_irqrestore(&dev->lock, flags);
 	return ret;
@@ -956,11 +1008,15 @@ static int raw_ioctl_ep_disable(struct raw_dev *dev, unsigned long value)
 		goto out_unlock;
 	}
 	dev->eps[i].disabling = true;
+	dev->udc_usage++;
 	spin_unlock_irqrestore(&dev->lock, flags);
 
 	usb_ep_disable(dev->eps[i].ep);
 
 	spin_lock_irqsave(&dev->lock, flags);
+	dev->udc_usage--;
+	if (!dev->udc_usage && dev->unbind_completion)
+		complete(dev->unbind_completion);
 	usb_ep_free_request(dev->eps[i].ep, dev->eps[i].req);
 	kfree(dev->eps[i].ep->desc);
 	dev->eps[i].state = STATE_EP_DISABLED;
@@ -1109,22 +1165,37 @@ static int raw_process_ep_io(struct raw_dev *dev, struct usb_raw_ep_io *io,
 	ep->req->length = io->length;
 	ep->req->zero = usb_raw_io_flags_zero(io->flags);
 	ep->urb_queued = true;
+	dev->udc_usage++;
 	spin_unlock_irqrestore(&dev->lock, flags);
 
 	ret = usb_ep_queue(ep->ep, ep->req, GFP_KERNEL);
 	if (ret) {
-		dev_err(&dev->gadget->dev,
-				"fail, usb_ep_queue returned %d\n", ret);
+		dev_err(dev->dev, "fail, usb_ep_queue returned %d\n", ret);
 		spin_lock_irqsave(&dev->lock, flags);
+		dev->udc_usage--;
+		if (!dev->udc_usage && dev->unbind_completion)
+			complete(dev->unbind_completion);
 		goto out_queue_failed;
 	}
 
 	ret = wait_for_completion_interruptible(&done);
 	if (ret) {
-		dev_dbg(&dev->gadget->dev, "wait interrupted\n");
-		usb_ep_dequeue(ep->ep, ep->req);
-		wait_for_completion(&done);
+		dev_dbg(dev->dev, "wait interrupted\n");
 		spin_lock_irqsave(&dev->lock, flags);
+		if (dev->state != STATE_DEV_FAILED && dev->gadget) {
+			struct usb_ep *usb_ep = ep->ep;
+
+			spin_unlock_irqrestore(&dev->lock, flags);
+
+			usb_ep_dequeue(usb_ep, ep->req);
+			wait_for_completion(&done);
+
+			spin_lock_irqsave(&dev->lock, flags);
+		} else {
+			spin_unlock_irqrestore(&dev->lock, flags);
+			wait_for_completion(&done);
+			spin_lock_irqsave(&dev->lock, flags);
+		}
 		if (ep->status == -ECONNRESET)
 			ep->status = -EINTR;
 		goto out_interrupted;
@@ -1136,6 +1207,9 @@ static int raw_process_ep_io(struct raw_dev *dev, struct usb_raw_ep_io *io,
 	ret = ep->status;
 out_queue_failed:
 	ep->urb_queued = false;
+	dev->udc_usage--;
+	if (!dev->udc_usage && dev->unbind_completion)
+		complete(dev->unbind_completion);
 out_unlock:
 	spin_unlock_irqrestore(&dev->lock, flags);
 	return ret;


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
