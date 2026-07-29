Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BF75041F376
	for <syzbot@lists.linux.dev>; Wed, 29 Jul 2026 11:01:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785322889; cv=none; b=IVB+957KPMg+2bq/qXlhH4csCLUj7REkgu1olbOTdYPTaN+5FXv3jXCtMVOL9UEx4yqFeFscRfqTiRl0zKG38uiRvcBv3n3vFM2L3U4WqE9LJ14SdIjHQc9TOzpm98p8/KpXbZcrobOkOh3yIaKWODc8WJTq14qMdweg33R2tDs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785322889; c=relaxed/simple;
	bh=CALLZn/AtFUpXPIw2wr8ZBbF+OGTRHDX0/qDJZg9tmg=;
	h=From:To:Cc:Subject:Message-ID:MIME-Version:Content-Type:Date; b=Q9vu4blxN1mAED8GFduP0geI3kZ7gT19VDJsX0gjokeYsLL9nzkMA2DoxlVoTdlveDPsDMmgwzeOoS7X0BWkPTE9P+TNHtoStygYPN5gAD6TgWEhAygvfeXjpVEvWgJo/oMpLqVOFBxBi4F4AYJ5PvN/3Cug9io1WdajsVJYxDk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=P8tvmMY0; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="P8tvmMY0"
Received: by smtp.kernel.org (Postfix) with UTF8SMTPSA id 79BC21F000E9;
	Wed, 29 Jul 2026 11:01:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1785322887;
	bh=gcMuqcifhjJJbTuUQTrUl7++ToeygpGau4mIY5ijvcs=;
	h=From:To:Cc:Subject:Date;
	b=P8tvmMY0otW+mjLz/sKNxpHVewCWSKiGgHkKFSNU9qmUATcnlj6LZBT4lvtMtdig8
	 2xWWJ/6n5VR0cY7OBQKdLzK1i1ZFjzDIxzxQ2l0ixAY/C5g49OXfEBekH/fJgl1X+D
	 UI+EQIWPjTTPGaBNAlHOr/wUxnQpeBOWGtHfVVLy0rEieNOtNcBkHT3z/8pcnREkY+
	 hnnCLAS4w6oYWIrXsdAyjX1svDB8mws0qMT01qv2QgnZnZJiOl8RpCNJM5XHLn9QjE
	 59juVxWSJke9npBKb+Kwbqueecaebe9k/HkpyJ4zel6coRo/qKZ29mzqhZ6RXYz/6g
	 lbrXbmg+vq8ow==
From: "syzbot" <syzbot@kernel.org>
To: syzkaller-upstream-moderation@googlegroups.com
Cc: syzbot@lists.linux.dev
Subject: [PATCH RFC] usb: gadget: dummy_hcd: prevent unbind via sysfs
Message-ID: <33d6bcfd-f593-4574-81c2-590b57760d7a@mail.kernel.org>
Precedence: bulk
X-Mailing-List: syzbot@lists.linux.dev
List-Id: <syzbot.lists.linux.dev>
List-Subscribe: <mailto:syzbot+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:syzbot+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Date: Wed, 29 Jul 2026 11:01:27 +0000 (UTC)

The dummy_hcd module registers two separate platform drivers (dummy_hcd and
dummy_udc) that share the same underlying struct dummy object. They are
designed to be created and destroyed together during module load and
unload. They do not support being unbound independently via sysfs, as the
UDC relies heavily on the HCD being present to function correctly.

If dummy_hcd is unbound independently via sysfs, it destroys the Host
Controller Devices (HCDs) and sets the pointers to NULL. However, the UDC
side (dummy_udc driver) remains bound and active. When the gadget driver is
later unregistered, UDC callbacks (such as dummy_pullup) attempt to access
the now-NULL HCD pointers, leading to a null-pointer dereference crash:

Oops: general protection fault, probably for non-canonical address
0xdffffc0000000000: 0000 [#1] SMP KASAN NOPTI
KASAN: null-ptr-deref in range [0x0000000000000000-0x0000000000000007]
RIP: 0010:set_link_state+0x27/0x1000 drivers/usb/gadget/udc/dummy_hcd.c:455
Call Trace:
 <TASK>
 dummy_pullup+0xc4/0x120 drivers/usb/gadget/udc/dummy_hcd.c:933
 usb_gadget_disconnect_locked+0x126/0x480 drivers/usb/gadget/udc/core.c:785
 gadget_unbind_driver+0xc2/0x410 drivers/usb/gadget/udc/core.c:1718
 device_remove drivers/base/dd.c:616 [inline]
 __device_release_driver drivers/base/dd.c:1349 [inline]
 device_release_driver_internal+0x48b/0x880 drivers/base/dd.c:1372
 driver_detach+0x1f3/0x2d0 drivers/base/dd.c:1435
 bus_remove_driver+0x226/0x320 drivers/base/bus.c:832
 usb_gadget_unregister_driver+0x4e/0x70 drivers/usb/gadget/udc/core.c:1784
 raw_release+0xd7/0x260 drivers/usb/gadget/legacy/raw_gadget.c:463

To fix this, prevent unbinding via sysfs by setting suppress_bind_attrs to
true in both dummy_udc_driver and dummy_hcd_driver. This ensures they can
only be removed safely when the module is unloaded.

Fixes: d9b762510c18 ("[PATCH] USB dummy_hcd: Use separate pdevs for HC and UDC")
Assisted-by: Gemini:gemini-3.5-flash Gemini:gemini-3.1-pro-preview syzbot
Reported-by: syzbot+70d28f5ea6d18a5e60fe@syzkaller.appspotmail.com
Closes: https://syzkaller.appspot.com/bug?extid=70d28f5ea6d18a5e60fe
Link: https://syzkaller.appspot.com/ai_job?id=4d9d976e-0203-4993-8b0c-ca26980202ab
To: "Greg Kroah-Hartman" <gregkh@linuxfoundation.org>
To: <linux-usb@vger.kernel.org>
To: "Alan Stern" <stern@rowland.harvard.edu>
Cc: <linux-kernel@vger.kernel.org>
Cc: "Jinchao Wang" <wangjinchao600@gmail.com>

---
diff --git a/drivers/usb/gadget/udc/dummy_hcd.c b/drivers/usb/gadget/udc/dummy_hcd.c
index c0e40fa6d..89e294b58 100644
--- a/drivers/usb/gadget/udc/dummy_hcd.c
+++ b/drivers/usb/gadget/udc/dummy_hcd.c
@@ -1179,7 +1179,8 @@ static struct platform_driver dummy_udc_driver = {
 	.suspend	= dummy_udc_suspend,
 	.resume		= dummy_udc_resume,
 	.driver		= {
-		.name	= gadget_name,
+		.name			= gadget_name,
+		.suppress_bind_attrs	= true,
 	},
 };
 
@@ -2801,7 +2802,8 @@ static struct platform_driver dummy_hcd_driver = {
 	.suspend	= dummy_hcd_suspend,
 	.resume		= dummy_hcd_resume,
 	.driver		= {
-		.name	= driver_name,
+		.name			= driver_name,
+		.suppress_bind_attrs	= true,
 	},
 };
 


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
