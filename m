Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 16BAF24886A
	for <syzbot@lists.linux.dev>; Sat,  8 Aug 2026 20:56:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786222593; cv=none; b=O8OAYLnsqgQRwv4mTihYOeg8Y7nmPupjvzBrkO21/VFGdkPIssvVcFBcn+eJ117ZJ/WgR/XYPJPPzRnF0e+qean9RkGqe8oODDwDEqI/1jwYJAEFLQ9V9b1pJ2gEMgTY0wRhuw0ImhB5pMrm0IO0t9Iyj3qJdgaNSaubIfDb14s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786222593; c=relaxed/simple;
	bh=CV/MgaY5MPDc0+HQBtnVd2AXV+vIJV3NOwwKlx08P8w=;
	h=From:To:Cc:Subject:Message-ID:MIME-Version:Content-Type:Date; b=ZdexGsW/1yJAhDJUv5OZccTl36aEFaVBK5Q7WDyenbxuxKi0/8xJDCKi90fHDFwVI6y4JMtzElU+xmECQdzt9+uBkP20qistw6SSeSL2k5Y9+X14Vbz7TONBqBCIo3+o3Qb9B32jIAFOmsjmUZqoFn4EknzmkZzK6zdeI0RgdOg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=cXkE4v2C; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="cXkE4v2C"
Received: by smtp.kernel.org (Postfix) with UTF8SMTPSA id 7BFEE1F000E9;
	Sat,  8 Aug 2026 20:56:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1786222591;
	bh=ajQZG4JWLAhI9IAVsGoyBboK91vJITHHfSqYbn2Y77w=;
	h=From:To:Cc:Subject:Date;
	b=cXkE4v2CQK1ZGjmsWbA+5F7tS5dMjnfyepXUks5SXpJ1brnU7hhrf+Mb26R/13qKM
	 x5valAy39yUTi6DjiPPIHMJ9PdQcqwd4FBepzDcTxy9dfmDscnVa4x3BmqcmuuvyUl
	 w0E98eOzLSbYsQfKbE8hdyi+wukVXazeyXkPHLlFnlbyQ9BRFGLV/89em5vC67Jk4n
	 AdRtyDqKfeTVdDForBuVPzcFmI/sC7JmQQBKMTBIqnuBVL0aYgP3PoP1c4zG1acy3d
	 jNAMWRfazLj0FfUSkTVVgmM2tsjfX66z56Hr9s47Sccad6z1p7r4pqfI1X/4geybM3
	 qYLuTYk/Ti4bg==
From: "syzbot" <syzbot@kernel.org>
To: syzkaller-upstream-moderation@googlegroups.com
Cc: syzbot@lists.linux.dev
Subject: [PATCH RFC] usb: raw-gadget: fix race condition between ioctl and gadget unbind
Message-ID: <e10d9492-ced7-4aac-80af-989d34467582@mail.kernel.org>
Precedence: bulk
X-Mailing-List: syzbot@lists.linux.dev
List-Id: <syzbot.lists.linux.dev>
List-Subscribe: <mailto:syzbot+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:syzbot+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Date: Sat,  8 Aug 2026 20:56:31 +0000 (UTC)

A race condition exists in the raw_gadget driver between the gadget unbind
process and concurrent user-space ioctls, leading to a KASAN
slab-use-after-free. When a UDC driver is unbound, the UDC core unregisters
the gadget and calls the gadget driver's unbind callback. However, the
raw_gadget driver fails to clear the dev->gadget pointer and does not
synchronize with pending ioctls. As a result, dev->gadget remains a
dangling pointer to the freed struct usb_gadget. When a concurrent ioctl
such as USB_RAW_IOCTL_EP_WRITE is executed, it passes the NULL check for
dev->gadget and subsequently attempts to use it. If the UDC is stopped,
usb_ep_queue returns an error, and the driver attempts to log this error
using dev_err(&dev->gadget->dev, ...), which triggers a use-after-free
read.

BUG: KASAN: slab-use-after-free in string_nocheck lib/vsprintf.c:648
[inline]
BUG: KASAN: slab-use-after-free in string+0x216/0x2d0 lib/vsprintf.c:730
Read of size 1 at addr ffff88818fcda600 by task 5909
Call Trace:
 string_nocheck lib/vsprintf.c:648 [inline]
 string+0x216/0x2d0 lib/vsprintf.c:730
 vsnprintf+0x74a/0xef0 lib/vsprintf.c:2945
 snprintf+0xe8/0x140 lib/vsprintf.c:3043
 set_dev_info drivers/base/core.c:4984 [inline]
 dev_vprintk_emit+0x30f/0x400 drivers/base/core.c:4994
 dev_printk_emit+0xee/0x140 drivers/base/core.c:5007
 _dev_err+0x11e/0x180 drivers/base/core.c:5062
 raw_process_ep_io+0x7d2/0xd80 drivers/usb/gadget/legacy/raw_gadget.c:1116
 raw_ioctl_ep_write drivers/usb/gadget/legacy/raw_gadget.c:1153 [inline]
 raw_ioctl+0x251c/0x41c0 drivers/usb/gadget/legacy/raw_gadget.c:1325

Additionally, there are secondary bugs related to driver registration leaks
and improper cleanup. In raw_release, the driver skips calling
usb_gadget_unregister_driver if dev->gadget is NULL, which leaks the driver
registration and causes another use-after-free when dev_free is called.
Furthermore, dev_free attempts to free endpoint requests using the dangling
dev->gadget pointer.

To fix these issues, introduce a read-write semaphore (rwsem) to
synchronize UDC access without holding a spinlock during usb_ep_queue. In
gadget_unbind, acquire the rwsem for writing to ensure no ioctls are
currently inside UDC functions, clear dev->gadget, and safely free all
endpoint requests here instead of in dev_free. In ioctl paths that call UDC
APIs outside of dev->lock, acquire the rwsem for reading and verify
dev->gadget is still valid. Furthermore, change logging statements in ioctl
paths to use dev->dev (the misc device) instead of dev->gadget->dev to
prevent dereferencing the gadget outside of locks. Finally, remove the
dev->gadget check in raw_release to ensure the driver is always
unregistered based on the dev->gadget_registered flag, and clean up request
freeing logic in dev_free and gadget_bind.

Fixes: f2c2e717642c ("usb: gadget: add raw-gadget interface")
Assisted-by: Gemini:gemini-3.5-flash Gemini:gemini-3.1-pro-preview syzbot
Reported-by: syzbot+596b59aea1a9deaaab67@syzkaller.appspotmail.com
Closes: https://syzkaller.appspot.com/bug?extid=596b59aea1a9deaaab67
Link: https://syzkaller.appspot.com/ai_job?id=e65c55c2-a944-4399-941d-4ac6e1d2ba95
To: "Greg Kroah-Hartman" <gregkh@linuxfoundation.org>
To: <linux-usb@vger.kernel.org>
To: "Andrey Konovalov" <andreyknvl@google.com>
Cc: "Andrey Konovalov" <andreyknvl@gmail.com>
Cc: "Kees Cook" <kees@kernel.org>
Cc: "Gopi Krishna Menon" <krishnagopi487@gmail.com>
Cc: <linux-kernel@vger.kernel.org>

---
diff --git a/drivers/usb/gadget/legacy/raw_gadget.c b/drivers/usb/gadget/legacy/raw_gadget.c
index 4febf8dac..139a0fa0c 100644
--- a/drivers/usb/gadget/legacy/raw_gadget.c
+++ b/drivers/usb/gadget/legacy/raw_gadget.c
@@ -160,6 +160,7 @@ enum dev_state {
 struct raw_dev {
 	struct kref			count;
 	spinlock_t			lock;
+	struct rw_semaphore		rwsem;
 
 	const char			*udc_name;
 	struct usb_gadget_driver	driver;
@@ -196,6 +197,7 @@ static struct raw_dev *dev_new(void)
 	/* Matches kref_put() in raw_release(). */
 	kref_init(&dev->count);
 	spin_lock_init(&dev->lock);
+	init_rwsem(&dev->rwsem);
 	init_completion(&dev->ep0_done);
 	raw_event_queue_init(&dev->queue);
 	dev->driver_id_number = -1;
@@ -212,20 +214,7 @@ static void dev_free(struct kref *kref)
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
 
@@ -316,6 +305,11 @@ static int gadget_bind(struct usb_gadget *gadget,
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
@@ -328,8 +322,31 @@ static int gadget_bind(struct usb_gadget *gadget,
 static void gadget_unbind(struct usb_gadget *gadget)
 {
 	struct raw_dev *dev = get_gadget_data(gadget);
+	unsigned long flags;
+	int i;
 
 	set_gadget_data(gadget, NULL);
+
+	down_write(&dev->rwsem);
+	spin_lock_irqsave(&dev->lock, flags);
+	dev->state = STATE_DEV_FAILED;
+	dev->gadget = NULL;
+	spin_unlock_irqrestore(&dev->lock, flags);
+
+	for (i = 0; i < dev->eps_num; i++) {
+		if (dev->eps[i].state != STATE_EP_DISABLED) {
+			usb_ep_disable(dev->eps[i].ep);
+			usb_ep_free_request(dev->eps[i].ep, dev->eps[i].req);
+			kfree(dev->eps[i].ep->desc);
+			dev->eps[i].state = STATE_EP_DISABLED;
+		}
+	}
+	if (dev->req) {
+		usb_ep_free_request(gadget->ep0, dev->req);
+		dev->req = NULL;
+	}
+	up_write(&dev->rwsem);
+
 	/* Matches kref_get() in gadget_bind(). */
 	kref_put(&dev->count, dev_free);
 }
@@ -450,10 +467,6 @@ static int raw_release(struct inode *inode, struct file *fd)
 
 	spin_lock_irqsave(&dev->lock, flags);
 	dev->state = STATE_DEV_CLOSED;
-	if (!dev->gadget) {
-		spin_unlock_irqrestore(&dev->lock, flags);
-		goto out_put;
-	}
 	if (dev->gadget_registered)
 		unregister = true;
 	dev->gadget_registered = false;
@@ -637,11 +650,11 @@ static int raw_ioctl_event_fetch(struct raw_dev *dev, unsigned long value)
 
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
@@ -698,13 +711,13 @@ static int raw_process_ep0_io(struct raw_dev *dev, struct usb_raw_ep_io *io,
 		goto out_unlock;
 	}
 	if (dev->ep0_urb_queued) {
-		dev_dbg(&dev->gadget->dev, "fail, urb already queued\n");
+		dev_dbg(dev->dev, "fail, urb already queued\n");
 		ret = -EBUSY;
 		goto out_unlock;
 	}
 	if ((in && !dev->ep0_in_pending) ||
 			(!in && !dev->ep0_out_pending)) {
-		dev_dbg(&dev->gadget->dev, "fail, wrong direction\n");
+		dev_dbg(dev->dev, "fail, wrong direction\n");
 		ret = -EBUSY;
 		goto out_unlock;
 	}
@@ -725,9 +738,17 @@ static int raw_process_ep0_io(struct raw_dev *dev, struct usb_raw_ep_io *io,
 	dev->ep0_urb_queued = true;
 	spin_unlock_irqrestore(&dev->lock, flags);
 
+	down_read(&dev->rwsem);
+	if (!dev->gadget) {
+		ret = -ENODEV;
+		up_read(&dev->rwsem);
+		spin_lock_irqsave(&dev->lock, flags);
+		goto out_queue_failed;
+	}
 	ret = usb_ep_queue(dev->gadget->ep0, dev->req, GFP_KERNEL);
+	up_read(&dev->rwsem);
 	if (ret) {
-		dev_err(&dev->gadget->dev,
+		dev_err(dev->dev,
 				"fail, usb_ep_queue returned %d\n", ret);
 		spin_lock_irqsave(&dev->lock, flags);
 		goto out_queue_failed;
@@ -735,8 +756,11 @@ static int raw_process_ep0_io(struct raw_dev *dev, struct usb_raw_ep_io *io,
 
 	ret = wait_for_completion_interruptible(&dev->ep0_done);
 	if (ret) {
-		dev_dbg(&dev->gadget->dev, "wait interrupted\n");
-		usb_ep_dequeue(dev->gadget->ep0, dev->req);
+		dev_dbg(dev->dev, "wait interrupted\n");
+		down_read(&dev->rwsem);
+		if (dev->gadget)
+			usb_ep_dequeue(dev->gadget->ep0, dev->req);
+		up_read(&dev->rwsem);
 		wait_for_completion(&dev->ep0_done);
 		spin_lock_irqsave(&dev->lock, flags);
 		if (dev->ep0_status == -ECONNRESET)
@@ -812,19 +836,19 @@ static int raw_ioctl_ep0_stall(struct raw_dev *dev, unsigned long value)
 		goto out_unlock;
 	}
 	if (dev->ep0_urb_queued) {
-		dev_dbg(&dev->gadget->dev, "fail, urb already queued\n");
+		dev_dbg(dev->dev, "fail, urb already queued\n");
 		ret = -EBUSY;
 		goto out_unlock;
 	}
 	if (!dev->ep0_in_pending && !dev->ep0_out_pending) {
-		dev_dbg(&dev->gadget->dev, "fail, no request pending\n");
+		dev_dbg(dev->dev, "fail, no request pending\n");
 		ret = -EBUSY;
 		goto out_unlock;
 	}
 
 	ret = usb_ep_set_halt(dev->gadget->ep0);
 	if (ret < 0)
-		dev_err(&dev->gadget->dev,
+		dev_err(dev->dev,
 				"fail, usb_ep_set_halt returned %d\n", ret);
 
 	if (dev->ep0_in_pending)
@@ -884,13 +908,13 @@ static int raw_ioctl_ep_enable(struct raw_dev *dev, unsigned long value)
 		ep->ep->desc = desc;
 		ret = usb_ep_enable(ep->ep);
 		if (ret < 0) {
-			dev_err(&dev->gadget->dev,
+			dev_err(dev->dev,
 				"fail, usb_ep_enable returned %d\n", ret);
 			goto out_free;
 		}
 		ep->req = usb_ep_alloc_request(ep->ep, GFP_ATOMIC);
 		if (!ep->req) {
-			dev_err(&dev->gadget->dev,
+			dev_err(dev->dev,
 				"fail, usb_ep_alloc_request failed\n");
 			usb_ep_disable(ep->ep);
 			ret = -ENOMEM;
@@ -903,10 +927,10 @@ static int raw_ioctl_ep_enable(struct raw_dev *dev, unsigned long value)
 	}
 
 	if (!ep_props_matched) {
-		dev_dbg(&dev->gadget->dev, "fail, bad endpoint descriptor\n");
+		dev_dbg(dev->dev, "fail, bad endpoint descriptor\n");
 		ret = -EINVAL;
 	} else {
-		dev_dbg(&dev->gadget->dev, "fail, no endpoints available\n");
+		dev_dbg(dev->dev, "fail, no endpoints available\n");
 		ret = -EBUSY;
 	}
 
@@ -939,18 +963,18 @@ static int raw_ioctl_ep_disable(struct raw_dev *dev, unsigned long value)
 		goto out_unlock;
 	}
 	if (dev->eps[i].state == STATE_EP_DISABLED) {
-		dev_dbg(&dev->gadget->dev, "fail, endpoint is not enabled\n");
+		dev_dbg(dev->dev, "fail, endpoint is not enabled\n");
 		ret = -EINVAL;
 		goto out_unlock;
 	}
 	if (dev->eps[i].disabling) {
-		dev_dbg(&dev->gadget->dev,
+		dev_dbg(dev->dev,
 				"fail, disable already in progress\n");
 		ret = -EINVAL;
 		goto out_unlock;
 	}
 	if (dev->eps[i].urb_queued) {
-		dev_dbg(&dev->gadget->dev,
+		dev_dbg(dev->dev,
 				"fail, waiting for urb completion\n");
 		ret = -EINVAL;
 		goto out_unlock;
@@ -958,13 +982,25 @@ static int raw_ioctl_ep_disable(struct raw_dev *dev, unsigned long value)
 	dev->eps[i].disabling = true;
 	spin_unlock_irqrestore(&dev->lock, flags);
 
+	down_read(&dev->rwsem);
+	if (!dev->gadget) {
+		ret = -ENODEV;
+		up_read(&dev->rwsem);
+		spin_lock_irqsave(&dev->lock, flags);
+		dev->eps[i].disabling = false;
+		goto out_unlock;
+	}
 	usb_ep_disable(dev->eps[i].ep);
+	usb_ep_free_request(dev->eps[i].ep, dev->eps[i].req);
 
 	spin_lock_irqsave(&dev->lock, flags);
-	usb_ep_free_request(dev->eps[i].ep, dev->eps[i].req);
 	kfree(dev->eps[i].ep->desc);
 	dev->eps[i].state = STATE_EP_DISABLED;
 	dev->eps[i].disabling = false;
+	spin_unlock_irqrestore(&dev->lock, flags);
+
+	up_read(&dev->rwsem);
+	return ret;
 
 out_unlock:
 	spin_unlock_irqrestore(&dev->lock, flags);
@@ -994,24 +1030,24 @@ static int raw_ioctl_ep_set_clear_halt_wedge(struct raw_dev *dev,
 		goto out_unlock;
 	}
 	if (dev->eps[i].state == STATE_EP_DISABLED) {
-		dev_dbg(&dev->gadget->dev, "fail, endpoint is not enabled\n");
+		dev_dbg(dev->dev, "fail, endpoint is not enabled\n");
 		ret = -EINVAL;
 		goto out_unlock;
 	}
 	if (dev->eps[i].disabling) {
-		dev_dbg(&dev->gadget->dev,
+		dev_dbg(dev->dev,
 				"fail, disable is in progress\n");
 		ret = -EINVAL;
 		goto out_unlock;
 	}
 	if (dev->eps[i].urb_queued) {
-		dev_dbg(&dev->gadget->dev,
+		dev_dbg(dev->dev,
 				"fail, waiting for urb completion\n");
 		ret = -EINVAL;
 		goto out_unlock;
 	}
 	if (usb_endpoint_xfer_isoc(dev->eps[i].ep->desc)) {
-		dev_dbg(&dev->gadget->dev,
+		dev_dbg(dev->dev,
 				"fail, can't halt/wedge ISO endpoint\n");
 		ret = -EINVAL;
 		goto out_unlock;
@@ -1020,17 +1056,17 @@ static int raw_ioctl_ep_set_clear_halt_wedge(struct raw_dev *dev,
 	if (set && halt) {
 		ret = usb_ep_set_halt(dev->eps[i].ep);
 		if (ret < 0)
-			dev_err(&dev->gadget->dev,
+			dev_err(dev->dev,
 				"fail, usb_ep_set_halt returned %d\n", ret);
 	} else if (!set && halt) {
 		ret = usb_ep_clear_halt(dev->eps[i].ep);
 		if (ret < 0)
-			dev_err(&dev->gadget->dev,
+			dev_err(dev->dev,
 				"fail, usb_ep_clear_halt returned %d\n", ret);
 	} else if (set && !halt) {
 		ret = usb_ep_set_wedge(dev->eps[i].ep);
 		if (ret < 0)
-			dev_err(&dev->gadget->dev,
+			dev_err(dev->dev,
 				"fail, usb_ep_set_wedge returned %d\n", ret);
 	}
 
@@ -1075,29 +1111,29 @@ static int raw_process_ep_io(struct raw_dev *dev, struct usb_raw_ep_io *io,
 		goto out_unlock;
 	}
 	if (io->ep >= dev->eps_num) {
-		dev_dbg(&dev->gadget->dev, "fail, invalid endpoint\n");
+		dev_dbg(dev->dev, "fail, invalid endpoint\n");
 		ret = -EINVAL;
 		goto out_unlock;
 	}
 	ep = &dev->eps[io->ep];
 	if (ep->state != STATE_EP_ENABLED) {
-		dev_dbg(&dev->gadget->dev, "fail, endpoint is not enabled\n");
+		dev_dbg(dev->dev, "fail, endpoint is not enabled\n");
 		ret = -EBUSY;
 		goto out_unlock;
 	}
 	if (ep->disabling) {
-		dev_dbg(&dev->gadget->dev,
+		dev_dbg(dev->dev,
 				"fail, endpoint is already being disabled\n");
 		ret = -EBUSY;
 		goto out_unlock;
 	}
 	if (ep->urb_queued) {
-		dev_dbg(&dev->gadget->dev, "fail, urb already queued\n");
+		dev_dbg(dev->dev, "fail, urb already queued\n");
 		ret = -EBUSY;
 		goto out_unlock;
 	}
 	if (in != usb_endpoint_dir_in(ep->ep->desc)) {
-		dev_dbg(&dev->gadget->dev, "fail, wrong direction\n");
+		dev_dbg(dev->dev, "fail, wrong direction\n");
 		ret = -EINVAL;
 		goto out_unlock;
 	}
@@ -1111,9 +1147,17 @@ static int raw_process_ep_io(struct raw_dev *dev, struct usb_raw_ep_io *io,
 	ep->urb_queued = true;
 	spin_unlock_irqrestore(&dev->lock, flags);
 
+	down_read(&dev->rwsem);
+	if (!dev->gadget) {
+		ret = -ENODEV;
+		up_read(&dev->rwsem);
+		spin_lock_irqsave(&dev->lock, flags);
+		goto out_queue_failed;
+	}
 	ret = usb_ep_queue(ep->ep, ep->req, GFP_KERNEL);
+	up_read(&dev->rwsem);
 	if (ret) {
-		dev_err(&dev->gadget->dev,
+		dev_err(dev->dev,
 				"fail, usb_ep_queue returned %d\n", ret);
 		spin_lock_irqsave(&dev->lock, flags);
 		goto out_queue_failed;
@@ -1121,8 +1165,11 @@ static int raw_process_ep_io(struct raw_dev *dev, struct usb_raw_ep_io *io,
 
 	ret = wait_for_completion_interruptible(&done);
 	if (ret) {
-		dev_dbg(&dev->gadget->dev, "wait interrupted\n");
-		usb_ep_dequeue(ep->ep, ep->req);
+		dev_dbg(dev->dev, "wait interrupted\n");
+		down_read(&dev->rwsem);
+		if (dev->gadget)
+			usb_ep_dequeue(ep->ep, ep->req);
+		up_read(&dev->rwsem);
 		wait_for_completion(&done);
 		spin_lock_irqsave(&dev->lock, flags);
 		if (ep->status == -ECONNRESET)
@@ -1215,12 +1262,18 @@ static int raw_ioctl_vbus_draw(struct raw_dev *dev, unsigned long value)
 		ret = -EINVAL;
 		goto out_unlock;
 	}
+	spin_unlock_irqrestore(&dev->lock, flags);
+
+	down_read(&dev->rwsem);
 	if (!dev->gadget) {
-		dev_dbg(dev->dev, "fail, gadget is not bound\n");
-		ret = -EBUSY;
-		goto out_unlock;
+		ret = -ENODEV;
+		up_read(&dev->rwsem);
+		return ret;
 	}
-	usb_gadget_vbus_draw(dev->gadget, 2 * value);
+	ret = usb_gadget_vbus_draw(dev->gadget, 2 * value);
+	up_read(&dev->rwsem);
+
+	return ret;
 
 out_unlock:
 	spin_unlock_irqrestore(&dev->lock, flags);


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
