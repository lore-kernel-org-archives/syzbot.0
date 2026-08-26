Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 53B6041DEE5
	for <syzbot@lists.linux.dev>; Wed, 26 Aug 2026 15:23:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787757834; cv=none; b=gmB0HwcLZd2+xBMHvr9VTytDWOOn1az1T+p4DhBECM+dyphlgHbDowF/GC+Ibw/foeT9BIbwVPndgrBFzZbIoMH03yBAfbBXH75dbpKzEwFgZg1Kh82V9gafmP6iM4v0EGA45xhAxbyZwVoU+MfOSzbKysi0N8ryAl6Lr1LDLCA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787757834; c=relaxed/simple;
	bh=Zn4FbeDyAg0w5s7QosaTClKMeLW+qHDq2NodS3/avzY=;
	h=From:To:Cc:Subject:Message-ID:MIME-Version:Content-Type:Date; b=ZqMxaEkKXWL7yJikIivs+hjikbwXGzJEgfmA1wYb7jCo1dQp+x37u/AamwGLP09ybWl3dbNsGh6sgS/njDM7VrOYxQIFFdlSKLyrU7Q1A8FuTw7azx/CTJEgRi6lYoBJtb2FS7Hh9o/c0lXfTGPySsYvTRcRosvaZEkOF13S5VU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=X8QO3ljs; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="X8QO3ljs"
Received: by smtp.kernel.org (Postfix) with UTF8SMTPSA id D4F161F000E9;
	Wed, 26 Aug 2026 15:23:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1787757833;
	bh=TQnMV+SsuipoCiygtsJ9ax3MiOAQ88c0kePg1VDO+qw=;
	h=From:To:Cc:Subject:Date;
	b=X8QO3ljsiikWLsGZWrAtos3cKWLN2V61iZHQgEfM46mKx+mE8JorTSYt/tAMfY4D3
	 H18pRBKGUJauZsC5xf/nFGlQsm2QirEyxe6rxSuTKoKN2e+2NQeofJIw32+xdVExj3
	 IvdaMa/UHaxz+iO6wA1LN6TrNohWQJ/a+BhCBX3iVLQlGXGcpXfuMofjwCfKUrX1aS
	 le7tjvDeebpqwQTRre0Is31/lxN4v0+cJSW1m/upjBS0XjzFrttolh5rjgFTX2op9f
	 PnG0rAcrlzpodXI/dJSttKY7x5aF0q1neTz+wQLmfRP/aqr3Oz8j429yw84987yFs5
	 3WbM02RYG8HIQ==
From: "syzbot" <syzbot@kernel.org>
To: syzkaller-upstream-moderation@googlegroups.com
Cc: syzbot@lists.linux.dev
Subject: [PATCH RFC] NFC: nfcmrvl_usb: fix NULL pointer dereference in bulk completion
Message-ID: <e55c153d-a839-41d7-8669-2015811b0ab1@mail.kernel.org>
Precedence: bulk
X-Mailing-List: syzbot@lists.linux.dev
List-Id: <syzbot.lists.linux.dev>
List-Subscribe: <mailto:syzbot+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:syzbot+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Date: Wed, 26 Aug 2026 15:23:52 +0000 (UTC)

In nfcmrvl_probe(), the driver calls nfcmrvl_nci_register_dev(), which
creates and registers the NCI device via nci_register_device(). Once
registered, the device is immediately exposed to userspace, which can bring
the interface up via netlink. When the interface is opened,
nfcmrvl_usb_nci_open() submits bulk RX URBs. However, nfcmrvl_probe()
assigns drv_data->priv = priv only after nfcmrvl_nci_register_dev()
returns. If an URB completes before drv_data->priv is assigned, the
completion handler nfcmrvl_bulk_complete() dereferences drv_data->priv
(which is still NULL) when allocating an skb, triggering a general
protection fault.

Additionally, nfcmrvl_bulk_complete() and nfcmrvl_resume() checked
test_bit(NFCMRVL_NCI_RUNNING, &drv_data->flags) instead of &priv->flags.
Since NFCMRVL_NCI_RUNNING and NFCMRVL_USB_BULK_RUNNING both share the value
1, this inadvertently tested drv_data->flags for NFCMRVL_USB_BULK_RUNNING,
masking the issue on the first URB completion while failing on subsequent
completions.

KASAN report:
Oops: general protection fault, probably for non-canonical address
0xdffffc0000000004: 0000 [#1] SMP KASAN NOPTI
KASAN: null-ptr-deref in range [0x0000000000000020-0x0000000000000027]
RIP: 0010:nfcmrvl_bulk_complete+0x107/0x600 drivers/nfc/nfcmrvl/usb.c:71
Call Trace:
 <IRQ>
 __usb_hcd_giveback_urb+0x374/0x530 drivers/usb/core/hcd.c:1657
 dummy_timer+0xa91/0x4cf0 drivers/usb/gadget/udc/dummy_hcd.c:2019
 __run_hrtimer kernel/time/hrtimer.c:2032 [inline]
 __hrtimer_run_queues+0x3bc/0xa10 kernel/time/hrtimer.c:2096
 hrtimer_run_softirq+0x17a/0x240 kernel/time/hrtimer.c:2113
 handle_softirqs+0x225/0x840 kernel/softirq.c:622
 </IRQ>

Fix this by passing priv as the URB context in nfcmrvl_submit_bulk_urb()
and retrieving priv directly from urb->context in nfcmrvl_bulk_complete().
Because priv is already initialized and valid when nfcmrvl_usb_nci_open()
is called, this removes the reliance on drv_data->priv. Also, update
nfcmrvl_bulk_complete() and nfcmrvl_resume() to test NFCMRVL_NCI_RUNNING
against priv->flags.

Fixes: f26e30cc6b50 ("NFC: nfcmrvl: Initial commit for Marvell NFC driver")
Assisted-by: Gemini:gemini-3.7-flash Gemini:gemini-3.1-pro-preview syzbot
Reported-by: syzbot+59d5e6a8ed04e6a000c8@syzkaller.appspotmail.com
Closes: https://syzkaller.appspot.com/bug?extid=59d5e6a8ed04e6a000c8
Link: https://syzkaller.appspot.com/ai_job?id=cf4896f2-e0ed-48cf-888c-6677fdcd9ee8
To: "David Heidelberg" <david@ixit.cz>
To: <oe-linux-nfc@lists.linux.dev>
To: "Amitkumar Karwar" <akarwar@marvell.com>
Cc: "Bartosz Golaszewski" <bartosz.golaszewski@oss.qualcomm.com>
Cc: "Johan Hovold" <johan@kernel.org>
Cc: "Jakub Kicinski" <kuba@kernel.org>
Cc: "Linus Walleij" <linusw@kernel.org>
Cc: <linux-kernel@vger.kernel.org>
Cc: "Jialu Xu" <xujialu@vimux.org>

---
diff --git a/drivers/nfc/nfcmrvl/usb.c b/drivers/nfc/nfcmrvl/usb.c
index 4babde8e4..ca20030bd 100644
--- a/drivers/nfc/nfcmrvl/usb.c
+++ b/drivers/nfc/nfcmrvl/usb.c
@@ -56,26 +56,27 @@ static int nfcmrvl_inc_tx(struct nfcmrvl_usb_drv_data *drv_data)
 
 static void nfcmrvl_bulk_complete(struct urb *urb)
 {
-	struct nfcmrvl_usb_drv_data *drv_data = urb->context;
+	struct nfcmrvl_private *priv = urb->context;
+	struct nfcmrvl_usb_drv_data *drv_data = priv->drv_data;
 	int err;
 
 	dev_dbg(&drv_data->udev->dev, "urb %p status %d count %d\n",
 		urb, urb->status, urb->actual_length);
 
-	if (!test_bit(NFCMRVL_NCI_RUNNING, &drv_data->flags))
+	if (!test_bit(NFCMRVL_NCI_RUNNING, &priv->flags))
 		return;
 
 	if (!urb->status) {
 		struct sk_buff *skb;
 
-		skb = nci_skb_alloc(drv_data->priv->ndev, urb->actual_length,
+		skb = nci_skb_alloc(priv->ndev, urb->actual_length,
 				    GFP_ATOMIC);
 		if (!skb) {
 			nfc_err(&drv_data->udev->dev, "failed to alloc mem\n");
 		} else {
 			skb_put_data(skb, urb->transfer_buffer,
 				     urb->actual_length);
-			if (nfcmrvl_nci_recv_frame(drv_data->priv, skb) < 0)
+			if (nfcmrvl_nci_recv_frame(priv, skb) < 0)
 				nfc_err(&drv_data->udev->dev,
 					"corrupted Rx packet\n");
 		}
@@ -100,8 +101,9 @@ static void nfcmrvl_bulk_complete(struct urb *urb)
 }
 
 static int
-nfcmrvl_submit_bulk_urb(struct nfcmrvl_usb_drv_data *drv_data, gfp_t mem_flags)
+nfcmrvl_submit_bulk_urb(struct nfcmrvl_private *priv, gfp_t mem_flags)
 {
+	struct nfcmrvl_usb_drv_data *drv_data = priv->drv_data;
 	struct urb *urb;
 	unsigned char *buf;
 	unsigned int pipe;
@@ -124,7 +126,7 @@ nfcmrvl_submit_bulk_urb(struct nfcmrvl_usb_drv_data *drv_data, gfp_t mem_flags)
 			       drv_data->bulk_rx_ep->bEndpointAddress);
 
 	usb_fill_bulk_urb(urb, drv_data->udev, pipe, buf, size,
-			  nfcmrvl_bulk_complete, drv_data);
+			  nfcmrvl_bulk_complete, priv);
 
 	urb->transfer_flags |= URB_FREE_BUFFER;
 
@@ -174,12 +176,12 @@ static int nfcmrvl_usb_nci_open(struct nfcmrvl_private *priv)
 
 	drv_data->intf->needs_remote_wakeup = 1;
 
-	err = nfcmrvl_submit_bulk_urb(drv_data, GFP_KERNEL);
+	err = nfcmrvl_submit_bulk_urb(priv, GFP_KERNEL);
 	if (err)
 		goto failed;
 
 	set_bit(NFCMRVL_USB_BULK_RUNNING, &drv_data->flags);
-	nfcmrvl_submit_bulk_urb(drv_data, GFP_KERNEL);
+	nfcmrvl_submit_bulk_urb(priv, GFP_KERNEL);
 
 	usb_autopm_put_interface(drv_data->intf);
 	return 0;
@@ -400,6 +402,7 @@ static void nfcmrvl_play_deferred(struct nfcmrvl_usb_drv_data *drv_data)
 static int nfcmrvl_resume(struct usb_interface *intf)
 {
 	struct nfcmrvl_usb_drv_data *drv_data = usb_get_intfdata(intf);
+	struct nfcmrvl_private *priv = drv_data->priv;
 	int err = 0;
 
 	nfc_info(&drv_data->udev->dev, "intf %p\n", intf);
@@ -407,17 +410,17 @@ static int nfcmrvl_resume(struct usb_interface *intf)
 	if (--drv_data->suspend_count)
 		return 0;
 
-	if (!test_bit(NFCMRVL_NCI_RUNNING, &drv_data->flags))
+	if (!test_bit(NFCMRVL_NCI_RUNNING, &priv->flags))
 		goto done;
 
 	if (test_bit(NFCMRVL_USB_BULK_RUNNING, &drv_data->flags)) {
-		err = nfcmrvl_submit_bulk_urb(drv_data, GFP_NOIO);
+		err = nfcmrvl_submit_bulk_urb(priv, GFP_NOIO);
 		if (err) {
 			clear_bit(NFCMRVL_USB_BULK_RUNNING, &drv_data->flags);
 			goto failed;
 		}
 
-		nfcmrvl_submit_bulk_urb(drv_data, GFP_NOIO);
+		nfcmrvl_submit_bulk_urb(priv, GFP_NOIO);
 	}
 
 	spin_lock_irq(&drv_data->txlock);


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
