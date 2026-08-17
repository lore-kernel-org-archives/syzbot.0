Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F40D070808
	for <syzbot@lists.linux.dev>; Mon, 17 Aug 2026 00:27:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786926427; cv=none; b=TLXwKsWIA8UsfJ/dY7VEXXCLUy/p7QemdqthDspM6LKfxWK0Ge5S62GFaNYLCqLPHbo+XE8q4IMFGtid76lK96UUm4NLtiNqJLK0YIH8+6i70ZaxA3mMfGVfUg8ygdE1ly6PwNRJishykf2tGVoiHAytWqxHb2nsBKMWj4I34+0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786926427; c=relaxed/simple;
	bh=IQktgQ3iKElIN+TYWD1R9x4iiCYK0xyvDUeuTqbF+iM=;
	h=From:To:Cc:Subject:Message-ID:MIME-Version:Content-Type:Date; b=Pr7cPf4sg+uTQVeIzOZBmku4qn1YGnCpGz6oOE2KsQ8cNfFtUGZgjd4Fdig2BfKb5DZxB4NBnbxBnDLm4N5hmjdEICj+MdS20GMcyzg3ngmRVILT5sR9SPwSpOaO6qPBft6YqhBiSmMLWUq+8PA4JGVsz39iLCmVhFiMWbh5wZM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Ntu306xH; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Ntu306xH"
Received: by smtp.kernel.org (Postfix) with UTF8SMTPSA id 8CA4A1F000E9;
	Mon, 17 Aug 2026 00:27:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1786926425;
	bh=7xCxNQVDV2vsUqp6K46GN4vPlYHLzZ9U3LzQDRLsqWQ=;
	h=From:To:Cc:Subject:Date;
	b=Ntu306xHTaINA9Vp97pG4bTGRNRALFeWcX4BCMUL2PEy0XGU0VtGS7Lg4E2JXwX0m
	 kavT5DejHeg8b/2YU60ThYu3zGD5mJIHL/T6WK52CWBQPPyfhg2O5lP2XEluFfhDR8
	 ZS03Swx8PTkjxYo8VzN4d/zfRKz6W9wjS68fML33rECpHazl/O9YjyLdjfiGb8lJ6B
	 WCgxfFFCuUp7a0SR65F73M5NFst2I8BgYRHAgZYYqUgHmSSfWed9C4ILJAjoIZY9pj
	 K/h6cXj1KAq0FrTnII7J+OmlC++3zbb1lDVMJqxas3o6R7e2a3oRaYBYsDnBEJVr5x
	 EZ4ODZ4KqNhCg==
From: "syzbot" <syzbot@kernel.org>
To: syzkaller-upstream-moderation@googlegroups.com
Cc: syzbot@lists.linux.dev
Subject: [PATCH RFC] usb: atm: cxacru: fix NULL pointer dereference on uninitialized atm_dev
Message-ID: <a2325770-3137-4cc3-8a69-c9991fc9042c@mail.kernel.org>
Precedence: bulk
X-Mailing-List: syzbot@lists.linux.dev
List-Id: <syzbot.lists.linux.dev>
List-Subscribe: <mailto:syzbot+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:syzbot+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Date: Mon, 17 Aug 2026 00:27:05 +0000 (UTC)

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
NULL, this leads to a NULL pointer dereference.

A similar issue exists in the delayed work function cxacru_poll_status().
If usbatm_atm_init() fails after cxacru_atm_start() has scheduled the
polling work, the initialization thread sets atm_dev = NULL and exits
without cancelling the work. When the work runs, it dereferences the NULL
atm_dev.

Oops: general protection fault, probably for non-canonical address
0xdffffc0000000002: 0000 [#1] SMP KASAN NOPTI
KASAN: null-ptr-deref in range [0x0000000000000010-0x0000000000000017]
CPU: 0 UID: 0 PID: 5853 Comm: syz-executor997 Not tainted
Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS
1.16.3-debian-1.16.3-2 04/01/2014
RIP: 0010:adsl_state_store+0x5cc/0x770 drivers/usb/atm/cxacru.c:359
...
Call Trace:
 <TASK>
 kernfs_fop_write_iter+0x3a4/0x540 fs/kernfs/file.c:345
 new_sync_write fs/read_write.c:595 [inline]
 vfs_write+0x612/0xba0 fs/read_write.c:687
 ksys_write+0x150/0x270 fs/read_write.c:739
 do_syscall_x64 arch/x86/entry/syscall_64.c:63 [inline]
 do_syscall_64+0x174/0x580 arch/x86/entry/syscall_64.c:94
 entry_SYSCALL_64_after_hwframe+0x77/0x7f

To fix this, add checks for instance->usbatm->atm_dev == NULL in
adsl_state_store(), adsl_config_store(), and cxacru_poll_status(). This
prevents the functions from proceeding and dereferencing the uninitialized
atm_dev, consistent with how mac_address_show() handles the same race
condition.

Fixes: e605c30977bb ("USB: atm: cxacru: convert to use dev_groups")
Assisted-by: Gemini:gemini-3.6-flash Gemini:gemini-3.1-pro-preview syzbot
Reported-by: syzbot+9b195c4f412ea5c4e56a@syzkaller.appspotmail.com
Closes: https://syzkaller.appspot.com/bug?extid=9b195c4f412ea5c4e56a
Link: https://syzkaller.appspot.com/ai_job?id=8e181a07-2f4b-4d42-9073-faacc1af94f0
To: "Chas Williams" <3chas3@gmail.com>
To: <accessrunner-general@lists.sourceforge.net>
To: "Greg Kroah-Hartman" <gregkh@linuxfoundation.org>
To: <linux-atm-general@lists.sourceforge.net>
To: <linux-usb@vger.kernel.org>
To: <netdev@vger.kernel.org>
Cc: <linux-kernel@vger.kernel.org>

---
diff --git a/drivers/usb/atm/cxacru.c b/drivers/usb/atm/cxacru.c
index 429ac20a8..7cdc083de 100644
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
@@ -827,6 +827,9 @@ static void cxacru_poll_status(struct work_struct *work)
 	int keep_polling = 1;
 	int ret;
 
+	if (!atm_dev)
+		return;
+
 	ret = cxacru_cm_get_array(instance, CM_REQUEST_CARD_INFO_GET, buf, CXINF_MAX);
 	if (ret < 0) {
 		if (ret != -ESHUTDOWN)


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
