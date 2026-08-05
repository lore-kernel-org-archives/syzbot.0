Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9907846D0A5
	for <syzbot@lists.linux.dev>; Wed,  5 Aug 2026 12:59:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785934789; cv=none; b=YArzyJECzcAtpdUqJ6twvsjqzX1oOBP/okJ4/pTB4iHSfP4OIu/s0NEoNPBUIMDZdOG6BVVVf+1mzj1AcqEZ8GLNpVFXJjETYKySKo1386igcKaZO128s8bC66Q4Meo7+88igFgGDxsGe29P5VKHzOhiT3be2VHwH/Xq8mYqcp4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785934789; c=relaxed/simple;
	bh=sCN+P8FgF4T0f6tOkGXIfnp3wif28+ybCbs6J7Zftcg=;
	h=From:To:Cc:Subject:Message-ID:MIME-Version:Content-Type:Date; b=sR3o7a23WoX86qpzAcb5xvj3PqRAilM8iaQmWB5PDVUKDaK/Ai7Mmd1E6WkSoMbuQf8atPL91HBkfij4VySYFKhVBSX2hcQqHDpDm+RT5tvhg5wyphIWRsOFmpqTh3FS22mdyg/aVzpbvqZ0umEPbD5wiahHO8sMPO0o+30MYyQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Pqi64aI5; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Pqi64aI5"
Received: by smtp.kernel.org (Postfix) with UTF8SMTPSA id 68BDB1F000E9;
	Wed,  5 Aug 2026 12:59:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1785934788;
	bh=iJN8MtJX6Vt++cqsVp6ZIuuUjDTWivcSlFJEnsufCEg=;
	h=From:To:Cc:Subject:Date;
	b=Pqi64aI5bmaM0gagtxaLekRTi6HwXv/fGnN9KaROWKE88LovrcZWKoX/D2NifUWVz
	 fiQPLwK0K3k8szfJ34waQZolMazoSqqclMDTOX7XPmO6SIsrKsFsczMAPdKdRymAzX
	 lulhxegRtL2MONAU8x8QSmeFfmG7JSq5uXUTIIc0kFKS181RuRjlaS8fUSSzqE3BHh
	 7K+6/qPPvyzbUwzG5l31V8xbaVDLDmdqcOkzkGpeoQk3ICW73p795z621LZP3kDRTy
	 SEKtnRNCfyR0H6FzNnRmtsWJpH6IRPNxmh9lWWGbOkes7t3rAC2JXc41wJXBjmSaFW
	 yGHZnXl5vMPmQ==
From: "syzbot" <syzbot@kernel.org>
To: syzkaller-upstream-moderation@googlegroups.com
Cc: syzbot@lists.linux.dev
Subject: [PATCH RFC] usb: gadgetfs: fix unbalanced refcount in gadgetfs_bind() error path
Message-ID: <92acf44b-fcee-4138-90ea-0a2275b9ddd8@mail.kernel.org>
Precedence: bulk
X-Mailing-List: syzbot@lists.linux.dev
List-Id: <syzbot.lists.linux.dev>
List-Subscribe: <mailto:syzbot+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:syzbot+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Date: Wed,  5 Aug 2026 12:59:48 +0000 (UTC)

In gadgetfs_bind(), if an error occurs (for example, failing to allocate
the endpoint request), the error path calls gadgetfs_unbind().
gadgetfs_unbind() unconditionally drops a reference to the device object
(dev) by calling put_dev(). However, gadgetfs_bind() only acquires a
reference to dev at the very end of the function upon success. This
mismatch causes the reference count to drop prematurely.

If multiple UDCs are available, the driver core will attempt to bind the
driver to each of them. If the first bind fails, the premature put_dev()
can drop the reference count to zero, freeing the dev object. Subsequent
bind attempts will then trigger a use-after-free when accessing the freed
dev object.

BUG: KASAN: slab-use-after-free in gadgetfs_bind+0xd8/0xae0
drivers/usb/gadget/legacy/inode.c:1682
Write of size 8 at addr ffff88819002e900 by task syz.0.17/6152

Call Trace:
 <TASK>
 gadgetfs_bind+0xd8/0xae0 drivers/usb/gadget/legacy/inode.c:1682
 gadget_bind_driver+0x2ca/0x9e0 drivers/usb/gadget/udc/core.c:1662
 call_driver_probe drivers/base/dd.c:-1 [inline]
 really_probe+0x254/0xae0 drivers/base/dd.c:706
 __driver_probe_device+0x1e8/0x360 drivers/base/dd.c:868
 driver_probe_device+0x4f/0x240 drivers/base/dd.c:898
 __driver_attach+0x339/0x600 drivers/base/dd.c:1292
 bus_for_each_dev+0x23e/0x2c0 drivers/base/bus.c:383
 bus_add_driver+0x348/0x670 drivers/base/bus.c:763
 driver_register+0x23a/0x320 drivers/base/driver.c:174
 usb_gadget_register_driver_owner+0xf9/0x270
 drivers/usb/gadget/udc/core.c:1752
 dev_config+0xe4e/0x12c0 drivers/usb/gadget/legacy/inode.c:1883
 vfs_write+0x29f/0xbb0 fs/read_write.c:685
 ksys_write+0x156/0x270 fs/read_write.c:739
 do_syscall_x64 arch/x86/entry/syscall_64.c:63 [inline]
 do_syscall_64+0x174/0x580 arch/x86/entry/syscall_64.c:94
 entry_SYSCALL_64_after_hwframe+0x77/0x7f
 </TASK>

To fix this, move the get_dev(dev) call to the beginning of
gadgetfs_bind(), right after the gadget data pointers are set up and before
any potential failure paths that lead to gadgetfs_unbind(). This ensures
that the reference count is properly balanced when gadgetfs_unbind() is
invoked on the error path.

Fixes: 1da177e4c3f4 ("Linux-2.6.12-rc2")
Assisted-by: Gemini:gemini-3.5-flash Gemini:gemini-3.1-pro-preview syzbot
Reported-by: syzbot+f63ad1084fd77fab48e4@syzkaller.appspotmail.com
Closes: https://syzkaller.appspot.com/bug?extid=f63ad1084fd77fab48e4
Link: https://syzkaller.appspot.com/ai_job?id=6fafa316-17a5-4928-b109-4b866d73749d
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
index d87a8ab51..ba901023d 100644
--- a/drivers/usb/gadget/legacy/inode.c
+++ b/drivers/usb/gadget/legacy/inode.c
@@ -1682,6 +1682,8 @@ static int gadgetfs_bind(struct usb_gadget *gadget,
 	dev->gadget = gadget;
 	gadget->ep0->driver_data = dev;
 
+	get_dev(dev);
+
 	/* preallocate control response and buffer */
 	dev->req = usb_ep_alloc_request (gadget->ep0, GFP_KERNEL);
 	if (!dev->req)
@@ -1696,7 +1698,6 @@ static int gadgetfs_bind(struct usb_gadget *gadget,
 	spin_lock_irq(&dev->lock);
 	dev->state = STATE_DEV_UNCONNECTED;
 	spin_unlock_irq(&dev->lock);
-	get_dev (dev);
 	return 0;
 
 enomem:


base-commit: 075b74841bd0065a3bda3440873c747938e69b68
-- 
This is an AI-generated patch subject to moderation.
Reply with '#syz upstream' to Sign-off the patch as a human author
and send it to the upstream kernel mailing lists.
Reply with '#syz reject' to reject it ('#syz unreject' to undo).

See https://goo.gle/syzbot-ai-patches for information about AI-generated patches.
You can comment on the patch as usual, syzbot will try to address
the comments and send a new version of the patch if necessary.
syzbot engineers can be reached at syzkaller@googlegroups.com.
