Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4572D446BF9
	for <syzbot@lists.linux.dev>; Fri,  7 Aug 2026 06:25:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786083939; cv=none; b=B3ALsZYHuisMUEXmJEkz6lwf+hS3wMFZpogaWZFJoUdVCTDs5iuIqGpKrAwRQ939IwaVhR62MvFOPsMybtoOoIvp6mk7XcIPXdLYp/EQn71KmUSHyRYN98pQKeHrXxoxrEvfSzCtrCnDHhJ15WN7kmy0Ja6a3ToVyVNWqdiOdCM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786083939; c=relaxed/simple;
	bh=IMY5g4Zp+wodky7Y1NikMaF6ffZPtucMz9b41FPErAQ=;
	h=From:To:Cc:Subject:Message-ID:MIME-Version:Content-Type:Date; b=OS7OPJgm8b9aMzX7k0Ts9O8uL+mhGDHTDmOZ4dFdYHZazNqI0PQXcSCoBIYZY/m9SC8t8FweEL7gQq+GeI4v1ySWMaeaFldp4qttNkh0DP51MAbf8+bF7BV6P+Zsa5j7fvJnjsHym/6NVp8QCXyegUXe6GUTg4GbZpVptBK1NWU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=LGlwgGsE; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="LGlwgGsE"
Received: by smtp.kernel.org (Postfix) with UTF8SMTPSA id C4C691F000E9;
	Fri,  7 Aug 2026 06:25:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1786083937;
	bh=a/Y2ux7iNyhoCEdKmfgDwytKJ3Gzx7Y5FQDTvmUCFJk=;
	h=From:To:Cc:Subject:Date;
	b=LGlwgGsEqe8NWt6qLmrdQ6hXye8MuaBMNyn+01OfBHhz056Njr0jkSqO2O+9x/bkP
	 HC8SdlqFmsuaVob+OOJq2PUxQrZHc24MkFbeAJC8jmJh/WwwP0R7ayTtKYwrmTgVhN
	 V02lq966RhSz8ml3V12d1a4iwcO+41xvw+Jh14s3pTf7f8KAvvHSjNoiDIcapBmVRU
	 1Fz5I/AZd4V6TVGqgJVz8RZi5uLzDmk0wNKta7RkO3pvXVspq9w3WMN0LSfL4w0jlk
	 syi04TIACabSmr/iewELAFA7V7jwgznOEg+QCp6iMKoTEPJpfsjJR+DIrl5qCNtO7D
	 RXbZMiFdYvZuA==
From: "syzbot" <syzbot@kernel.org>
To: syzkaller-upstream-moderation@googlegroups.com
Cc: syzbot@lists.linux.dev
Subject: [PATCH RFC] usb: gadgetfs: fix reference count underflow in gadgetfs_bind()
Message-ID: <f4fb3f3c-7a51-44ed-bbd3-4ea5fa486d2e@mail.kernel.org>
Precedence: bulk
X-Mailing-List: syzbot@lists.linux.dev
List-Id: <syzbot.lists.linux.dev>
List-Subscribe: <mailto:syzbot+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:syzbot+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Date: Fri,  7 Aug 2026 06:25:37 +0000 (UTC)

A KASAN slab-use-after-free bug was found in gadgetfs_kill_sb():

BUG: KASAN: slab-use-after-free in put_dev
drivers/usb/gadget/legacy/inode.c:165 [inline]
BUG: KASAN: slab-use-after-free in gadgetfs_kill_sb+0x46/0x110
drivers/usb/gadget/legacy/inode.c:2104
Write of size 4 at addr ffff88811638c080 by task syz-executor169/5848

CPU: 0 UID: 0 PID: 5848 Comm: syz-executor169 Not tainted
Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS
1.16.3-debian-1.16.3-2 04/01/2014
Call Trace:
 <TASK>
 dump_stack_lvl+0xe8/0x150 lib/dump_stack.c:120
 print_address_description+0x55/0x1e0 mm/kasan/report.c:378
 print_report+0x58/0x70 mm/kasan/report.c:482
 kasan_report+0x117/0x150 mm/kasan/report.c:595
 check_region_inline mm/kasan/generic.c:-1 [inline]
 kasan_check_range+0x264/0x2c0 mm/kasan/generic.c:200
 instrument_atomic_read_write include/linux/instrumented.h:112 [inline]
 atomic_fetch_sub_release include/linux/atomic/atomic-instrumented.h:400
 [inline]
 __refcount_sub_and_test include/linux/refcount.h:389 [inline]
 __refcount_dec_and_test include/linux/refcount.h:432 [inline]
 refcount_dec_and_test include/linux/refcount.h:450 [inline]
 put_dev drivers/usb/gadget/legacy/inode.c:165 [inline]
 gadgetfs_kill_sb+0x46/0x110 drivers/usb/gadget/legacy/inode.c:2104
 deactivate_locked_super+0xbc/0x130 fs/super.c:477
 cleanup_mnt+0x3d3/0x460 fs/namespace.c:1317
 task_work_run+0x1d9/0x270 kernel/task_work.c:233

The root cause is a reference count underflow in the error handling path of
gadgetfs_bind(). When gadgetfs_bind() encounters an error (e.g., memory
allocation failure), it jumps to the enomem label and calls
gadgetfs_unbind(). However, gadgetfs_unbind() is designed to tear down a
fully initialized and bound gadget, and unconditionally drops a device
reference by calling put_dev(dev). Since gadgetfs_bind() only acquires this
reference (get_dev(dev)) at the very end of the function upon complete
success, calling gadgetfs_unbind() in the error path drops a reference that
was never taken.

This leads to a premature free of the dev structure when the ep0 file is
closed, and subsequently a use-after-free when the filesystem is unmounted
and gadgetfs_kill_sb() tries to drop the initial reference.

To fix this, stop calling the full teardown function gadgetfs_unbind() from
the gadgetfs_bind() error path. Instead, manually and locally clean up only
the specific state that was successfully altered before the failure
occurred.

Fixes: 1da177e4c3f4 ("Linux-2.6.12-rc2")
Assisted-by: Gemini:gemini-3.5-flash Gemini:gemini-3.1-pro-preview syzbot
Reported-by: syzbot+4a5c87a01894ca37f25c@syzkaller.appspotmail.com
Closes: https://syzkaller.appspot.com/bug?extid=4a5c87a01894ca37f25c
Link: https://syzkaller.appspot.com/ai_job?id=d40043f8-d813-4477-b6e2-0f071c04be7c
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
