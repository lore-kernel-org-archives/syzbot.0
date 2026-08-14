Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8C0F441A574
	for <syzbot@lists.linux.dev>; Fri, 14 Aug 2026 10:16:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786702614; cv=none; b=Hegzl3JAnNzivs7qfZySrP3goFEQFpFqagNnN7XV8EuzLmUdo6oisF5Ba931WVyHxPr2bYw5By5QvfBys2PDmJ06AG/cOw1XO0oytDx6ZpJrXQuYGZYE1BVIYOID3gU4lY+nnL3OlIgwoWnri1w2lrYJ9zks3ScZDnoWDgiU+d8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786702614; c=relaxed/simple;
	bh=mNpAWG3sMAoveAK6N/PCa3Ixy3u2t6AQHy12amf5tdk=;
	h=From:To:Cc:Subject:Message-ID:MIME-Version:Content-Type:Date; b=qkXprs4ZjoAOUA6QdozPAyvvY/3E8ZQ2pnc7iqeLZ/didgk6nGjXCxWIFSVfXlyDwJxM86R4QexHG12cn53cmpu4woxaL+EiysA7ND+IOR7wLJFAsH8T3mIu5x9Dg7kZVaON3ztEyLLNB9cP9rPHUIXcp/BeIERSTDil/XX/f50=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=TWvMlh5Q; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="TWvMlh5Q"
Received: by smtp.kernel.org (Postfix) with UTF8SMTPSA id EB1631F00A3A;
	Fri, 14 Aug 2026 10:16:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1786702604;
	bh=QIF+PLr6b6KAaMFUGp+/cXNn+py6W3L8g2tR3T8zJpo=;
	h=From:To:Cc:Subject:Date;
	b=TWvMlh5Qb4BeoUZRE8OQ7RrGFKTbOahhhxkPVzWcf4zuGk8ZNh2zNyfFy9By80OHi
	 g+0GKwOzcvQKsS/AZeF6LKT7xb6N6ytKill+l+7Lpu2kalTPrfLfLWJP4sfSToywld
	 5cbQQWe4z2ZwaSZOPg6+8CV3yOlf3Tv3EQXuZ/yPdQSxnc1RiW0IFy/PiGpTtdb4xZ
	 SVkPaBtxgr8/ScjPHD6w5hqg/VLaAaIw3EKD1dWTBhUuFy3iPnUcYkwvqOoX1Vlqcc
	 iAz/uoFSkCQOKCohqMeKH2xPoNQLzu92J1wsoKX0d6+Od8BsnR0OjzdbuEByQzXyY2
	 g7yWpSdcnhHTw==
From: "syzbot" <syzbot@kernel.org>
To: syzkaller-upstream-moderation@googlegroups.com
Cc: syzbot@lists.linux.dev
Subject: [PATCH RFC] usb: gadget: goku_udc: fix uninitialized kobject and UAFs
Message-ID: <1c9a830a-f29a-47ae-b710-575eb5e6388e@mail.kernel.org>
Precedence: bulk
X-Mailing-List: syzbot@lists.linux.dev
List-Id: <syzbot.lists.linux.dev>
List-Subscribe: <mailto:syzbot+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:syzbot+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Date: Fri, 14 Aug 2026 10:16:43 +0000 (UTC)

The goku_probe() function incorrectly calls goku_remove() in its error
handling path. If goku_probe() fails early, it invokes goku_remove(), which
unconditionally calls usb_del_gadget_udc(). This eventually calls
put_device(&gadget->dev). However, gadget->dev is only initialized much
later in the probe process. Because device_initialize() was never called,
put_device() complains about an uninitialized kobject, triggering a
warning:

kobject: '(null)' (ffff88818b15a0d8): is not initialized, yet kobject_put()
is being called.
WARNING: lib/kobject.c:736 at kobject_put+0x66/0x550 lib/kobject.c:734
...
Call Trace:
 goku_remove+0x50/0x440 drivers/usb/gadget/udc/goku_udc.c:1717
 goku_probe+0x2ba/0x710 drivers/usb/gadget/udc/goku_udc.c:1830

The current error handling and removal logic also has Use-After-Free (UAF)
and double-free bugs due to the misuse of the legacy UDC API:

1. Double-free on probe failure: If usb_add_gadget_udc_release() fails, it
internally calls usb_put_gadget(), which invokes gadget_release(), freeing
dev. Then goku_probe() jumps to err, calls goku_remove() (accessing the
freed dev), and finally calls kfree(dev).

2. Use-After-Free on module unload: During normal module unloading,
goku_remove() calls usb_del_gadget_udc(), which drops the final reference
and frees dev via gadget_release(). Immediately after, goku_remove()
proceeds to access dev->regs and dev->got_irq to clean up hardware
resources, resulting in a UAF.

To fix these issues, switch to the modern UDC API (usb_initialize_gadget(),
usb_add_gadget(), usb_del_gadget(), and usb_put_gadget()) and decouple
initialization from addition. This ensures gadget->dev is properly
initialized early.

Rewrite the goku_probe() error path to use standard goto labels for manual
cleanup in reverse order of acquisition, instead of calling goku_remove().
This also removes the need for the got_irq, got_region, and enabled state
flags in struct goku_udc.

In goku_remove(), reorder the teardown sequence to perform hardware cleanup
before dropping the final reference to the gadget with usb_put_gadget(),
preventing the UAF.

Finally, fix a memory leak in gadget_release(). It was using
dev_get_drvdata() to retrieve the struct goku_udc pointer, but
dev_set_drvdata() is never called on &dev->gadget.dev, resulting in NULL
being passed to kfree(). Use container_of() instead to safely resolve the
pointer.

Fixes: 3301c215a2bb ("USB: UDC: Expand device model API interface")
Assisted-by: Gemini:gemini-3.6-flash Gemini:gemini-3.1-pro-preview syzbot
Reported-by: syzbot+06ec7624018233e17113@syzkaller.appspotmail.com
Closes: https://syzkaller.appspot.com/bug?extid=06ec7624018233e17113
Link: https://syzkaller.appspot.com/ai_job?id=1781ec29-886b-49b1-ae1d-6905ce149397
To: "Greg Kroah-Hartman" <gregkh@linuxfoundation.org>
To: <linux-usb@vger.kernel.org>
To: "Alan Stern" <stern@rowland.harvard.edu>
Cc: "Kees Cook" <kees@kernel.org>
Cc: <linux-kernel@vger.kernel.org>
Cc: "Stepan Ionichev" <sozdayvek@gmail.com>

---
diff --git a/drivers/usb/gadget/udc/goku_udc.c b/drivers/usb/gadget/udc/goku_udc.c
index ac2a984c2..a360bba9a 100644
--- a/drivers/usb/gadget/udc/goku_udc.c
+++ b/drivers/usb/gadget/udc/goku_udc.c
@@ -1701,7 +1701,7 @@ static irqreturn_t goku_irq(int irq, void *_dev)
 
 static void gadget_release(struct device *_dev)
 {
-	struct goku_udc	*dev = dev_get_drvdata(_dev);
+	struct goku_udc	*dev = container_of(_dev, struct goku_udc, gadget.dev);
 
 	kfree(dev);
 }
@@ -1714,28 +1714,25 @@ static void goku_remove(struct pci_dev *pdev)
 
 	DBG(dev, "%s\n", __func__);
 
-	usb_del_gadget_udc(&dev->gadget);
+	usb_del_gadget(&dev->gadget);
 
 	BUG_ON(dev->driver);
 
 #ifdef CONFIG_USB_GADGET_DEBUG_FILES
 	remove_proc_entry(proc_node_name, NULL);
 #endif
-	if (dev->regs)
-		udc_reset(dev);
-	if (dev->got_irq)
-		free_irq(pdev->irq, dev);
-	if (dev->regs)
-		iounmap(dev->regs);
-	if (dev->got_region)
-		release_mem_region(pci_resource_start (pdev, 0),
-				pci_resource_len (pdev, 0));
-	if (dev->enabled)
-		pci_disable_device(pdev);
+	udc_reset(dev);
+	free_irq(pdev->irq, dev);
+	iounmap(dev->regs);
+	release_mem_region(pci_resource_start(pdev, 0),
+			   pci_resource_len(pdev, 0));
+	pci_disable_device(pdev);
 
 	dev->regs = NULL;
 
 	INFO(dev, "unbind\n");
+
+	usb_put_gadget(&dev->gadget);
 }
 
 /* wrap this driver around the specified pci device, but
@@ -1751,16 +1748,13 @@ static int goku_probe(struct pci_dev *pdev, const struct pci_device_id *id)
 
 	if (!pdev->irq) {
 		printk(KERN_ERR "Check PCI %s IRQ setup!\n", pci_name(pdev));
-		retval = -ENODEV;
-		goto err;
+		return -ENODEV;
 	}
 
 	/* alloc, and start init */
 	dev = kzalloc_obj(*dev);
-	if (!dev) {
-		retval = -ENOMEM;
-		goto err;
-	}
+	if (!dev)
+		return -ENOMEM;
 
 	pci_set_drvdata(pdev, dev);
 	spin_lock_init(&dev->lock);
@@ -1771,28 +1765,28 @@ static int goku_probe(struct pci_dev *pdev, const struct pci_device_id *id)
 	/* the "gadget" abstracts/virtualizes the controller */
 	dev->gadget.name = driver_name;
 
+	usb_initialize_gadget(&pdev->dev, &dev->gadget, gadget_release);
+
 	/* now all the pci goodies ... */
 	retval = pci_enable_device(pdev);
 	if (retval < 0) {
 		DBG(dev, "can't enable, %d\n", retval);
-		goto err;
+		goto err_put_gadget;
 	}
-	dev->enabled = 1;
 
 	resource = pci_resource_start(pdev, 0);
 	len = pci_resource_len(pdev, 0);
 	if (!request_mem_region(resource, len, driver_name)) {
 		DBG(dev, "controller already in use\n");
 		retval = -EBUSY;
-		goto err;
+		goto err_disable_pci;
 	}
-	dev->got_region = 1;
 
 	base = ioremap(resource, len);
 	if (base == NULL) {
 		DBG(dev, "can't map memory\n");
 		retval = -EFAULT;
-		goto err;
+		goto err_release_region;
 	}
 	dev->regs = (struct goku_udc_regs __iomem *) base;
 
@@ -1807,9 +1801,8 @@ static int goku_probe(struct pci_dev *pdev, const struct pci_device_id *id)
 			driver_name, dev) != 0) {
 		DBG(dev, "request interrupt %d failed\n", pdev->irq);
 		retval = -EBUSY;
-		goto err;
+		goto err_iounmap;
 	}
-	dev->got_irq = 1;
 	if (use_dma)
 		pci_set_master(pdev);
 
@@ -1818,18 +1811,26 @@ static int goku_probe(struct pci_dev *pdev, const struct pci_device_id *id)
 	proc_create_single_data(proc_node_name, 0, NULL, udc_proc_read, dev);
 #endif
 
-	retval = usb_add_gadget_udc_release(&pdev->dev, &dev->gadget,
-			gadget_release);
+	retval = usb_add_gadget(&dev->gadget);
 	if (retval)
-		goto err;
+		goto err_remove_proc;
 
 	return 0;
 
-err:
-	if (dev)
-		goku_remove (pdev);
-	/* gadget_release is not registered yet, kfree explicitly */
-	kfree(dev);
+err_remove_proc:
+#ifdef CONFIG_USB_GADGET_DEBUG_FILES
+	remove_proc_entry(proc_node_name, NULL);
+#endif
+	udc_reset(dev);
+	free_irq(pdev->irq, dev);
+err_iounmap:
+	iounmap(dev->regs);
+err_release_region:
+	release_mem_region(resource, len);
+err_disable_pci:
+	pci_disable_device(pdev);
+err_put_gadget:
+	usb_put_gadget(&dev->gadget);
 	return retval;
 }
 
diff --git a/drivers/usb/gadget/udc/goku_udc.h b/drivers/usb/gadget/udc/goku_udc.h
index 70023d401..b067670fa 100644
--- a/drivers/usb/gadget/udc/goku_udc.h
+++ b/drivers/usb/gadget/udc/goku_udc.h
@@ -243,11 +243,8 @@ struct goku_udc {
 	struct usb_gadget_driver	*driver;
 
 	enum ep0state			ep0state;
-	unsigned			got_irq:1,
-					got_region:1,
-					req_config:1,
-					configured:1,
-					enabled:1;
+	unsigned			req_config:1,
+					configured:1;
 
 	/* pci state used to access those endpoints */
 	struct pci_dev			*pdev;


base-commit: db2ddb87143519e20a95aa36c60b36107b736a58
-- 
This is an AI-generated patch subject to moderation.
Reply with '#syz upstream' to Sign-off the patch as a human author
and send it to the upstream kernel mailing lists.
Reply with '#syz reject' to reject it ('#syz unreject' to undo).

See https://goo.gle/syzbot-ai-patches for information about AI-generated patches.
You can comment on the patch as usual, syzbot will try to address
the comments and send a new version of the patch if necessary.
syzbot engineers can be reached at syzkaller@googlegroups.com.
