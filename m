Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 57F2E455162;
	Mon, 31 Aug 2026 14:40:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788187244; cv=none; b=LZVILTvJFJDcYvGuaeiPggLA9J1Tjd57ouYBdLTvDQQLhw7YMYMpImqzUhr3fJwH7xvMNbuPxstcv6aOlRWAtGR2QrzThhK3aRKtnaROcOpRWupDau0tSTUeMyu975NSj+JjAZv/3JoYZnf/lRu3wC/BFaGLaF45SD98T31AFRM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788187244; c=relaxed/simple;
	bh=XnYbv/lvSUhA3IIkJg1wTTbKCIckEW6sc1YJvlWOlDc=;
	h=From:To:Cc:Subject:Message-ID:MIME-Version:Content-Type:Date; b=jPtjbtRW6G7LoVUY/uZi+yQjnO+FSTX6/tPozdaTebYJ0glT+1egPqXFxbwi2ZpgXZjjKeEY9XqVAYxrKcECKIaonY5L5N2fJLnc34VqAcTpDEJ353VCXIMyIbL2LTGTUl+l0p0fWyWM0d51Y4wTKs8cjhBeaegTpvK6NW8517w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=hfJBce/f; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="hfJBce/f"
Received: by smtp.kernel.org (Postfix) with UTF8SMTPSA id 769651F000E9;
	Mon, 31 Aug 2026 14:40:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788187243;
	bh=glU5brsq9stFhaeEUTYuaXur4gpoMrHcD9Sa+u8+sdg=;
	h=From:To:Cc:Subject:Date;
	b=hfJBce/fvMIR4mLQ4PXQ3TRh9fkfE4WBk2bYRVZ/iYYtplkxC3nwZMky4QTC5BLVI
	 rPSzFKiGkQLoJ5WSVkzb9XC/I4n/OFEHTVNdKE8aaujzRwWgR154mDedpth9LTnhHv
	 dizKdiUKcuNtNuqDIvaevQ7g94iF6667dQOy+kzY3qdiLiCSzWFfKJn8Mw3CVeiW6X
	 lq7XAD0p/TzzLwGKcgVe4wmjr5Lcu5JPOpgmxAHTnjGKZhWTBKdjmsZQttCykmWI05
	 apiXUI8LXhjQoiOGeVnZLxQKusOXa2e1MRslSbEXjll5ShMj3AGMecd9ZwCDWn5jce
	 jU0CQydiPoXMQ==
From: "syzbot" <syzbot@kernel.org>
To: syzkaller-bugs@googlegroups.com, "Wang, Jie" <jie.wang@intel.com>, "Chas Williams" <3chas3@gmail.com>, <accessrunner-general@lists.sourceforge.net>, "Greg Kroah-Hartman" <gregkh@linuxfoundation.org>, <linux-atm-general@lists.sourceforge.net>, <linux-usb@vger.kernel.org>, <netdev@vger.kernel.org>
Cc: linux-kernel@vger.kernel.org, syzbot@lists.linux.dev
Subject: [PATCH] usb: atm: cxacru: fix NULL pointer dereference on uninitialized atm_dev
Message-ID: <f3ef0a67-79d7-47da-be6e-7e82d92e68fe@mail.kernel.org>
Precedence: bulk
X-Mailing-List: syzbot@lists.linux.dev
List-Id: <syzbot.lists.linux.dev>
List-Subscribe: <mailto:syzbot+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:syzbot+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Date: Mon, 31 Aug 2026 14:40:42 +0000 (UTC)

From: "Wang, Jie" <jie.wang@intel.com>

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
Signed-off-by: "Wang, Jie" <jie.wang@intel.com>

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
See https://goo.gle/syzbot-ai-patches for information about AI-generated patches.
The person who has signed off on the patch is responsible for
addressing comments.
syzbot engineers can be reached at syzkaller@googlegroups.com.
