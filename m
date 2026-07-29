Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D2CE747ECF2;
	Wed, 29 Jul 2026 12:25:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785327932; cv=none; b=lNm9/IHLwj2PLT2ieygE+yYK6+EXgCFE0FSFia6zfUJZpjRFRNtRPxydCRLNbqbALIlhu6MIVLMNHJC35bhMB/K0HCC6d5tc0Gy4c7l3SSFfSuq8Ng4Jh8IBwnG32aMIc6bCVlqstdCyTAgPHy2Ixcdu2GUFq2BlY3lArY1W/6w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785327932; c=relaxed/simple;
	bh=0U/ys6cZNhkpxsgwNb/CS43Z8h83TVW9dwKmfKURtdg=;
	h=From:To:Cc:Subject:Message-ID:MIME-Version:Content-Type:Date; b=T5qRFSiL7B4HlFKa7c15r2KcOoMI7CqA/TJ2grpO9UUs3BHsBC0lM8B8kqj6mg7hA9M2UJpaWZWLIsVRbQDkv/Evmzw0SUPND0VV6WYjtcRHV19b+D5EsD0TTvSv+E8yYMbdLiwlhy+Eqbso39s59d6zZ0mqJlWp+XggsfcZvHI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=nGDbhNHP; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="nGDbhNHP"
Received: by smtp.kernel.org (Postfix) with UTF8SMTPSA id 7B2FB1F000E9;
	Wed, 29 Jul 2026 12:25:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1785327927;
	bh=5tpNgOLG1i2E2r77lvp0JoskJFauNP7G4/hZnDIWMfw=;
	h=From:To:Cc:Subject:Date;
	b=nGDbhNHP7dCXGLVszQgiY2URYS6VScGiFKvGksjqinMPJGOzEFVTF0SB1Ozw7m9HT
	 roNV+rajvjEtPs5pSNElDiFICOjnN5OqAg9KRy7JzS+kWqc9uLI0Fc99Mc6bMQdG+m
	 5D51+sNGTM7S0peP/n/eU0tCx0XDBzJDHY7m8ZLr6dNCnPGC4oDwePrBDNwTQ+L9VE
	 r7S1lbU7UZRHE1oMDv4mBl8b0+pv3k34K5UDs4MkZdi3EJhOvlVKW2lPqAXmg4OkNR
	 /Ktz/jzU8elUI+/HOMe7MPJsLZPDlaa37eo1rIWoj31n6mEF19+Gl5lllqa8oWjQbh
	 hrIkWZfFVcPxw==
From: "syzbot" <syzbot@kernel.org>
To: syzkaller-bugs@googlegroups.com, Aleksandr Nogikh <nogikh@google.com>, "Greg Kroah-Hartman" <gregkh@linuxfoundation.org>, <linux-usb@vger.kernel.org>, "Alan Stern" <stern@rowland.harvard.edu>
Cc: linux-kernel@vger.kernel.org, syzbot@lists.linux.dev, wangjinchao600@gmail.com
Subject: [PATCH] usb: gadget: dummy_hcd: prevent unbind via sysfs
Message-ID: <18ec3122-7566-49e5-9964-1028857405b1@mail.kernel.org>
Precedence: bulk
X-Mailing-List: syzbot@lists.linux.dev
List-Id: <syzbot.lists.linux.dev>
List-Subscribe: <mailto:syzbot+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:syzbot+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Date: Wed, 29 Jul 2026 12:25:27 +0000 (UTC)

From: Aleksandr Nogikh <nogikh@google.com>

The dummy_hcd (Host Controller) and dummy_udc (Device Controller) are
implemented as two separate platform drivers that share the same underlying
state (struct dummy). They are designed to be created and destroyed
together during the module's init and exit phases.

If userspace forces the dummy_hcd driver to unbind from the device via
sysfs, dummy_hcd_remove() cleans up the host controllers and sets the
pointers to NULL (dum->hs_hcd = NULL). However, the dummy_udc driver is
still bound to its device, meaning the USB gadget is still registered with
the udc-core subsystem.

If a new gadget driver is subsequently registered, it binds to the
still-registered dummy_udc gadget, invoking the dummy_udc_start() callback.
This callback attempts to retrieve the HCD state using
gadget_to_dummy_hcd(), which returns NULL because of the unbind. This
results in a null-pointer dereference:

Oops: general protection fault, probably for non-canonical address
0xdffffc0000000000: 0000 [#1] SMP KASAN NOPTI
KASAN: null-ptr-deref in range [0x0000000000000000-0x0000000000000007]
...
RIP: 0010:dummy_udc_start+0xd0/0x1f0
drivers/usb/gadget/udc/dummy_hcd.c:1022
...
Call Trace:
 <TASK>
 usb_gadget_udc_start_locked drivers/usb/gadget/udc/core.c:1237 [inline]
 gadget_bind_driver+0x3a8/0x9e0 drivers/usb/gadget/udc/core.c:1667
 call_driver_probe drivers/base/dd.c:-1 [inline]
 really_probe+0x254/0xae0 drivers/base/dd.c:706
 __driver_probe_device+0x1e8/0x360 drivers/base/dd.c:868
 driver_probe_device+0x4f/0x240 drivers/base/dd.c:898
 __driver_attach+0x339/0x600 drivers/base/dd.c:1292
 bus_for_each_dev+0x23b/0x2c0 drivers/base/bus.c:383
 bus_add_driver+0x345/0x670 drivers/base/bus.c:763
 driver_register+0x23a/0x320 drivers/base/driver.c:174
 usb_gadget_register_driver_owner+0xf9/0x270
 drivers/usb/gadget/udc/core.c:1752
 raw_ioctl_run drivers/usb/gadget/legacy/raw_gadget.c:596 [inline]
 raw_ioctl+0x1541/0x41c0 drivers/usb/gadget/legacy/raw_gadget.c:1307

Adding NULL checks to the UDC callbacks is not a robust solution because
there is no synchronization between dummy_hcd_remove() and the UDC
callbacks, which would result in a use-after-free race condition if the HCD
were unbound concurrently.

Fix this by setting .suppress_bind_attrs = true in both driver definitions.
This prevents userspace from unbinding these drivers dynamically, ensuring
their lifecycles remain strictly synchronized with the module's load/unload
process.

Fixes: d9b762510c18 ("[PATCH] USB dummy_hcd: Use separate pdevs for HC and UDC")
Assisted-by: Gemini:gemini-3.5-flash Gemini:gemini-3.1-pro-preview syzbot
Reported-by: syzbot+d270af829aca04e783fc@syzkaller.appspotmail.com
Closes: https://syzkaller.appspot.com/bug?extid=d270af829aca04e783fc
Link: https://syzkaller.appspot.com/ai_job?id=7a763ada-c07c-458f-9fea-f7e913dc1f2f
Signed-off-by: Aleksandr Nogikh <nogikh@google.com>

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
See https://goo.gle/syzbot-ai-patches for information about AI-generated patches.
You can comment on the patch as usual, syzbot will try to address
the comments and send a new version of the patch if necessary.
syzbot engineers can be reached at syzkaller@googlegroups.com.
