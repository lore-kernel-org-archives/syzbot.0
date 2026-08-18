Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 22F7A4B04A7
	for <syzbot@lists.linux.dev>; Tue, 18 Aug 2026 06:31:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787034711; cv=none; b=hTVLFj4PHZra6j6JIsHhDTPI/CSZL1czO//hEWjH8+FKHAk9zf1YdxIfU005/CMTDD7V8gEaiQ2c/dhQYxQtary1ik7K+H+gUsvSF/zTOZZiYbjEEio6dtSxp+47a/toTQJw7dPnc3f12eGssGConFg2g8AvNnz6gVLRwGsR9EA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787034711; c=relaxed/simple;
	bh=4jze0Pd1wblesLKGosALw94gNLZFlgXRJcY/wzZl20M=;
	h=From:To:Cc:Subject:Message-ID:MIME-Version:Content-Type:Date; b=mbipnjnrJwTk5gkyy5Q6b3Ckt5IvPtTsgiWJXUr++0QCHCGix3tcu52ZFuUwla1FH3s7VxGMkpLEBM9V73lheQCd04o5SCrUkP+k6FvykoZTwBEkBcI31E7VkhcZ6JCm985QZ0ow3Jnw2Qh4yZBTxd63PhU7wo3GqSjh9QzxsR4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=EGyo6ZTw; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="EGyo6ZTw"
Received: by smtp.kernel.org (Postfix) with UTF8SMTPSA id BC9C31F00A3A;
	Tue, 18 Aug 2026 06:31:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1787034709;
	bh=6QMQibX/g/0+ZcZm3TOP35hucT+wUUX76KbrD4v6+qc=;
	h=From:To:Cc:Subject:Date;
	b=EGyo6ZTwOLXXbCN/OIM0UQSte4u58wII/0Hf8uScp7XhDBX1t4OyX/WP1iATBmF78
	 PjoBi2HBusZtUmmuqr4N/nYv2QUVGxLG7sxFvQQnwjQGbgvRMLPJzfJ1lmT0VkHRH6
	 CaApLhnLl7iUl9WsGtAdp7Ubczlgv7uleutW44ZQBKNzxxbqy46TX1HFa7hEvm0His
	 lcYi/AgFzJ+GTZhObG0zsLwHEzOiyESJwyv4a7N6I7ifqVMYOLBXz4m5LnpwIeUy3P
	 /wKs0rY7W3RQqUSAEGz+QmC2Mty2JQk9Bo0jTsavGji+YRpHxa1c0zw2FGAg6rzWsG
	 saP36yPkarI1Q==
From: "syzbot" <syzbot@kernel.org>
To: syzkaller-upstream-moderation@googlegroups.com
Cc: jie.wang@intel.com, syzbot@lists.linux.dev
Subject: [PATCH RFC v2] usb: atm: cxacru: fix NULL pointer dereference on uninitialized atm_dev
Message-ID: <e51f4b84-d7ff-4c7c-9e97-019886b0c8ef@mail.kernel.org>
Precedence: bulk
X-Mailing-List: syzbot@lists.linux.dev
List-Id: <syzbot.lists.linux.dev>
List-Subscribe: <mailto:syzbot+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:syzbot+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Date: Tue, 18 Aug 2026 06:31:49 +0000 (UTC)

The cxacru driver uses the usbatm framework, which defers the ATM device
registration to a kernel thread (usbatm_do_heavy_init()) but immediately
returns success from the USB probe. Because the probe returns success, the
driver core creates sysfs attribute files (like adsl_state and
adsl_config), making them accessible to userspace before the ATM device is
fully initialized.

If a user writes to these sysfs files before the initialization is complete
or if it fails, the driver attempts to send a command to the device. If the
command fails, the error handling path calls atm_err(), which
unconditionally dereferences instance->usbatm->atm_dev. Since atm_dev is
NULL, this leads to a NULL pointer dereference:

Oops: general protection fault, probably for non-canonical address
0xdffffc0000000002: 0000 [#1] SMP KASAN NOPTI
KASAN: null-ptr-deref in range [0x0000000000000010-0x0000000000000017]
RIP: 0010:adsl_state_store+0x5cc/0x770 drivers/usb/atm/cxacru.c:359
Call Trace:
 <TASK>
 kernfs_fop_write_iter+0x3a4/0x540 fs/kernfs/file.c:345
 new_sync_write fs/read_write.c:595 [inline]
 vfs_write+0x612/0xba0 fs/read_write.c:687
 ksys_write+0x150/0x270 fs/read_write.c:739
 do_syscall_x64 arch/x86/entry/syscall_64.c:63 [inline]
 do_syscall_64+0x174/0x580 arch/x86/entry/syscall_64.c:94
 entry_SYSCALL_64_after_hwframe+0x77/0x7f
 </TASK>

To fix this, add checks for instance->usbatm->atm_dev == NULL in
adsl_state_store() and adsl_config_store(). This prevents the functions
from proceeding and dereferencing the uninitialized atm_dev, consistent
with how mac_address_show() handles the same race condition.

Fixes: e605c30977bb ("USB: atm: cxacru: convert to use dev_groups")
Assisted-by: Gemini:gemini-3.6-flash Gemini:gemini-3.1-pro-preview syzbot
Reported-by: syzbot+9b195c4f412ea5c4e56a@syzkaller.appspotmail.com
Closes: https://syzkaller.appspot.com/bug?extid=9b195c4f412ea5c4e56a
Link: https://syzkaller.appspot.com/ai_job?id=b6352d63-d03a-4e87-92a4-b334c3ebcf97
To: "Chas Williams" <3chas3@gmail.com>
To: <accessrunner-general@lists.sourceforge.net>
To: "Greg Kroah-Hartman" <gregkh@linuxfoundation.org>
To: <linux-atm-general@lists.sourceforge.net>
To: <linux-usb@vger.kernel.org>
To: <netdev@vger.kernel.org>
Cc: <linux-kernel@vger.kernel.org>

---
v2:
- Removed changes and description for cxacru_poll_status().

v1:
https://lore.kernel.org/all/a2325770-3137-4cc3-8a69-c9991fc9042c@mail.kernel.org/T/
---
diff --git a/drivers/usb/atm/cxacru.c b/drivers/usb/atm/cxacru.c
index 429ac20a8..dee15f7b7 100644
--- a/drivers/usb/atm/cxacru.c
+++ b/drivers/usb/atm/cxacru.c
@@ -347,7 +347,7 @@ static ssize_t adsl_state_store(struct device *dev,
 		return -EINVAL;
 	ret = 0;
 
-	if (instance == NULL)
+	if (instance == NULL || instance->usbatm->atm_dev == NULL)
 		return -ENODEV;
 
 	if (mutex_lock_interruptible(&instance->adsl_state_serialize))
@@ -444,7 +444,7 @@ static ssize_t adsl_config_store(struct device *dev,
 	if (!capable(CAP_NET_ADMIN))
 		return -EACCES;
 
-	if (instance == NULL)
+	if (instance == NULL || instance->usbatm->atm_dev == NULL)
 		return -ENODEV;
 
 	pos = 0;


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
