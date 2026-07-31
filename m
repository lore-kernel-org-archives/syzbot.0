Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CCE8E3A450C
	for <syzbot@lists.linux.dev>; Fri, 31 Jul 2026 07:56:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785484566; cv=none; b=cibq1Uh/4qoneN6JJxZQ/5s1uoMUOnFX3oXtfvs+/MdXFTsArufA/AH7jc29O0LcuXTMNhmrxWdPpkVWtURtpSQVZLyJTHolli3YdqKObRssgCxqR96I6fzgRcuDmlD+/oHzHx38yWwxbDIcgWZs4TJdULA4nkfg6qbNlDoForE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785484566; c=relaxed/simple;
	bh=f4PqCrX28LbmjEpf+9zVybkdqcEvdjfn99dfGfrtZjQ=;
	h=From:To:Cc:Subject:Message-ID:MIME-Version:Content-Type:Date; b=IERvvWEnplIgF+zVzYYbTOMq2r6f94OSG1NFPkdbxj76kMy9SVqWOAfaUloPT/jcBocvWLh7mUPt70Ysd7p49DT1ZoUwm8u01+SzBqchqHFHmj3gNhV6rEgWRHZpBJ7esD3K2g4ypbkbuhADFXtR1F3966LQPQvJKSi7HwvoTfo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=RPJ5auLB; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="RPJ5auLB"
Received: by smtp.kernel.org (Postfix) with UTF8SMTPSA id 5AE7D1F000E9;
	Fri, 31 Jul 2026 07:56:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1785484564;
	bh=3cJcVUXGYFyHkcYUv36W7T2cQrSkeuvWXSXFGlvNAwU=;
	h=From:To:Cc:Subject:Date;
	b=RPJ5auLBZM4ENEqsHwc96kXyJbq9dAv2JE9zQXqm54me2Z7+Va0xjdz7CtK14ngP2
	 yc4Psv0opSjiLGsyI24sHoyVqA4nJAmjuX4d8a1mRqdzztYBp2Yi77kXAlP2ZEBIeB
	 6P+7gxakZXC4spmptSQhrF4Q86vvRuiwSXbMb33ZRKezcQqHEGZcLTbOzPiXpOJWNq
	 tZLHXkLLEx9fqK6p/CGxifLX0hE9xUcLOZAylSIzKFjWr8HTSTHdmes7at+aI2acMh
	 oZoLu6HPMByZ+jdT+a71IqXe1zgAUuOkFqdyRcpF9o8juMKD4RhrbwnYpfL/Oqoa7k
	 gE7XqBW1gur5A==
From: "syzbot" <syzbot@kernel.org>
To: syzkaller-upstream-moderation@googlegroups.com
Cc: syzbot@lists.linux.dev
Subject: [PATCH RFC] usb: gadgetfs: fix unbalanced refcount in gadgetfs_bind() error path
Message-ID: <20bb5db4-2b26-4b7a-ad54-7d20fa11499e@mail.kernel.org>
Precedence: bulk
X-Mailing-List: syzbot@lists.linux.dev
List-Id: <syzbot.lists.linux.dev>
List-Subscribe: <mailto:syzbot+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:syzbot+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Date: Fri, 31 Jul 2026 07:56:04 +0000 (UTC)

A KASAN slab-use-after-free can occur in gadget_dev_open() due to an
unbalanced reference count in the error path of gadgetfs_bind().

When gadgetfs_bind() is called, it performs several initialization steps.
If it succeeds, it takes a reference to the dev object by calling
get_dev(dev) at the very end of the function. This reference is meant to be
balanced by a call to put_dev(dev) inside gadgetfs_unbind() when the driver
is eventually unbound.

However, if gadgetfs_bind() fails midway (e.g., due to a memory allocation
failure in usb_ep_alloc_request() or activate_ep_files()), it jumps to the
enomem label and calls gadgetfs_unbind(gadget). Because get_dev(dev) was
never called, gadgetfs_unbind() drops a reference that was never acquired.
This leads to the dev object being freed prematurely when the file
descriptor is closed, resulting in a use-after-free when the file is opened
again.

BUG: KASAN: slab-use-after-free in __raw_spin_lock_irq
include/linux/spinlock_api_smp.h:142 [inline]
BUG: KASAN: slab-use-after-free in _raw_spin_lock_irq+0x58/0x70
kernel/locking/spinlock.c:174
Read of size 1 at addr ffff0000dbe16018 by task syz.0.18/5334
...
Call trace:
...
 __raw_spin_lock_irq include/linux/spinlock_api_smp.h:142 [inline]
 _raw_spin_lock_irq+0x58/0x70 kernel/locking/spinlock.c:174
 spin_lock_irq include/linux/spinlock.h:372 [inline]
 gadget_dev_open+0x50/0x1c4 drivers/usb/gadget/legacy/inode.c:1919
 do_dentry_open+0x5c4/0xfc0 fs/open.c:947
 vfs_open+0x44/0x2dc fs/open.c:1052

To fix this, replace the monolithic gadgetfs_unbind() call in the enomem
error path with manual, step-by-step cleanup of exactly the resources that
were allocated prior to the failure. If dev->req was allocated, it is freed
and set to NULL. The gadget data pointers (gadget->ep0->driver_data,
dev->gadget, and set_gadget_data) are cleared. Note that
activate_ep_files() already cleans up after itself if it fails, so we don't
need to manually undo its effects.

This ensures that only the resources actually allocated by gadgetfs_bind()
are cleaned up, preventing the unbalanced put_dev() and incorrect state
changes that caused the use-after-free.

Fixes: 1da177e4c3f4 ("Linux-2.6.12-rc2")
Assisted-by: Gemini:gemini-3.5-flash Gemini:gemini-3.1-pro-preview syzbot
Reported-by: syzbot+1459655b2bf1e798f9d0@syzkaller.appspotmail.com
Closes: https://syzkaller.appspot.com/bug?extid=1459655b2bf1e798f9d0
Link: https://syzkaller.appspot.com/ai_job?id=992d95f0-8de6-44af-9ebe-f7c976f4ba68
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
index d87a8ab51..365f9ab4d 100644
--- a/drivers/usb/gadget/legacy/inode.c
+++ b/drivers/usb/gadget/legacy/inode.c
@@ -1700,7 +1700,13 @@ static int gadgetfs_bind(struct usb_gadget *gadget,
 	return 0;
 
 enomem:
-	gadgetfs_unbind (gadget);
+	if (dev->req) {
+		usb_ep_free_request(gadget->ep0, dev->req);
+		dev->req = NULL;
+	}
+	gadget->ep0->driver_data = NULL;
+	dev->gadget = NULL;
+	set_gadget_data(gadget, NULL);
 	return -ENOMEM;
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
