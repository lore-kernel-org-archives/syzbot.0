Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9BF4B4446E1
	for <syzbot@lists.linux.dev>; Wed, 29 Jul 2026 10:30:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785321058; cv=none; b=TZbnERfuQ7varsH5MLE6FcZ6TCJajorQWPvcjOo4+U9HUUpcMjAmLEt++BS1SGIuQuPNt+trqk13iJTng0OrdTNMtTYmn2OLaBxOcuJQ5Xvk/rsmjUx6UN0HH7ZWULbCLfG3HiCuicsqwgM6nJverGfGBdSwRem2s3m++73dqjY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785321058; c=relaxed/simple;
	bh=EMYVFhLg1oDsLNQXymw93Z8CrBF/u8vTzGUuVkODF6o=;
	h=From:To:Cc:Subject:Message-ID:MIME-Version:Content-Type:Date; b=HANMYLqKqJrqrqkd4Zd0NyN7pBHOnZX6bakpXQ0FG7VoNL8w0bRPjgVOeJ64bhRcyQbyiLSfpxE7cElcH7cPSbcBlAO9+Qrq+yr/KV6X1U7QtEevPzFMe6vXyNaTknFZN60G0U/yaQNHA0mw4OYpSIgHdd7Q7POMBjHp/B0e8h0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=UJS85v5M; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="UJS85v5M"
Received: by smtp.kernel.org (Postfix) with UTF8SMTPSA id 63FBF1F000E9;
	Wed, 29 Jul 2026 10:30:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1785321057;
	bh=3HIa/lzr6ZuypkFWUwt6VvmAAazwxsl4d1R7GqoMA0Q=;
	h=From:To:Cc:Subject:Date;
	b=UJS85v5MZ5jVI/HQ0tbX43hUs+Q7AcOg+1NvlRo7cGpAnb9W8wtUUh36uFbLmu4Gv
	 HwxGNrZ4AzwmK2H0xTz29MqAlaLh3BjbNhofcR31Vp/PtzeU3eKgXWrXUVV1MFnJvV
	 XeoAL8IpR0t2+Sc9So334BOXARqZA+w6xAStU6zrTnWnRMUfxDBIyECGfn39SPZun9
	 eP2mMntFs+4OW+ixNjaXhfsXYYG+e8DCLaLsVCIfsHVkJRFtBnzdpZvl4HJpeiySbB
	 F//eRixooYUS3N3/UACosGcNUEFoOIYvgSMBGPqdPqxHMrsjlOV8U39JTpbCxinQ0w
	 T290QtciI+LkA==
From: "syzbot" <syzbot@kernel.org>
To: syzkaller-upstream-moderation@googlegroups.com
Cc: syzbot@lists.linux.dev
Subject: [PATCH RFC] usb: gadget: dummy_hcd: suppress bind attributes
Message-ID: <f4b8d294-ca63-484f-b0a7-7033fd3f1f51@mail.kernel.org>
Precedence: bulk
X-Mailing-List: syzbot@lists.linux.dev
List-Id: <syzbot.lists.linux.dev>
List-Subscribe: <mailto:syzbot+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:syzbot+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Date: Wed, 29 Jul 2026 10:30:57 +0000 (UTC)

The `dummy_hcd` module emulates both a USB Host Controller (HCD) and a USB
Device Controller (UDC). During initialization, it creates two separate
platform devices (`dummy_hcd` and `dummy_udc`) that share the same
underlying state (`struct dummy`).

Because these two drivers are tightly coupled and share the same state,
they are not designed to be unbound individually at runtime. If a user
unbinds the `dummy_hcd` driver via sysfs, it cleans up the host controller
and sets the shared pointers to `NULL`. However, the `dummy_udc` driver
remains bound and active. If a gadget driver is then bound to the
still-active UDC, it will attempt to access the shared state, resulting in
a null-pointer dereference:

KASAN: null-ptr-deref in range [0x0000000000000000-0x0000000000000007]
RIP: 0010:dummy_set_selfpowered+0xbe/0x160
drivers/usb/gadget/udc/dummy_hcd.c:906
Call Trace:
 usb_gadget_set_selfpowered+0x75/0x260 drivers/usb/gadget/udc/core.c:578
 composite_dev_prepare+0x2fa/0x320 drivers/usb/gadget/composite.c:2440
 configfs_composite_bind+0xa5/0x1410 drivers/usb/gadget/configfs.c:1701
 gadget_bind_driver+0x2ca/0x9e0 drivers/usb/gadget/udc/core.c:1662

To fix this, prevent userspace from unbinding these drivers individually
via sysfs by setting `.suppress_bind_attrs = true` in their `struct
device_driver` definitions. This disables the bind/unbind sysfs attributes
for the drivers, ensuring that their shared state cannot be broken by
userspace, while still allowing the entire module to be safely unloaded
(which correctly unregisters the UDC before the HCD).

Fixes: d9b762510c18 ("[PATCH] USB dummy_hcd: Use separate pdevs for HC and UDC")
Assisted-by: Gemini:gemini-3.5-flash Gemini:gemini-3.1-pro-preview syzbot
Reported-by: syzbot+5c0303816c30d2e621df@syzkaller.appspotmail.com
Closes: https://syzkaller.appspot.com/bug?extid=5c0303816c30d2e621df
Link: https://syzkaller.appspot.com/ai_job?id=177fd65f-4a8c-4071-b38d-4645a071d2ae
To: "Greg Kroah-Hartman" <gregkh@linuxfoundation.org>
To: <linux-usb@vger.kernel.org>
To: "Alan Stern" <stern@rowland.harvard.edu>
Cc: <linux-kernel@vger.kernel.org>
Cc: "Jinchao Wang" <wangjinchao600@gmail.com>

---
diff --git a/drivers/usb/gadget/udc/dummy_hcd.c b/drivers/usb/gadget/udc/dummy_hcd.c
index c0e40fa6d..415096835 100644
--- a/drivers/usb/gadget/udc/dummy_hcd.c
+++ b/drivers/usb/gadget/udc/dummy_hcd.c
@@ -1180,6 +1180,7 @@ static struct platform_driver dummy_udc_driver = {
 	.resume		= dummy_udc_resume,
 	.driver		= {
 		.name	= gadget_name,
+		.suppress_bind_attrs = true,
 	},
 };
 
@@ -2802,6 +2803,7 @@ static struct platform_driver dummy_hcd_driver = {
 	.resume		= dummy_hcd_resume,
 	.driver		= {
 		.name	= driver_name,
+		.suppress_bind_attrs = true,
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
