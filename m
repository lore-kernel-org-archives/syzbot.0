Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C86833DDDA3;
	Wed,  5 Aug 2026 07:05:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785913519; cv=none; b=ds7DpcmNy8PLJXBBruut21S0bhakbKc1eyCdf9SLfYN6v58w/yprCxkxGku9JRhOHN8YHKmrgLDRJVu9a6tg6sbJ3SKkqgNBN5EXg/7dEHjA4FU5ObA4uFsRCtdZX6iDnpJImqUwcQzcP3uRBjfscRg/wVKBafMfip0Bpcizrv0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785913519; c=relaxed/simple;
	bh=pgAr2gM0tZb/OCrvKnOzGUaMxUnY3vKQWD5392b0foU=;
	h=From:To:Cc:Subject:Message-ID:MIME-Version:Content-Type:Date; b=CFedsRWK5M9jzK/PpYsx5+gjLU/hW+nneAg5mUEgxhOy+G6Th4C3Ug3n7PUBKhhEfQ/ZWXPlCPLIokSTpd38/Lv9x4n7DuYM7OG6g+vZVIxaBwM+PgxIGxu35gNa0dWYLQI62vLuQCESQUw0VxgTmGiqlJbrN8S85eSeur4m8T8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=BUqaq6c+; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="BUqaq6c+"
Received: by smtp.kernel.org (Postfix) with UTF8SMTPSA id E03FF1F000E9;
	Wed,  5 Aug 2026 07:05:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1785913517;
	bh=ggHO1t8B9rcI7os7V0V7Xd3QRXhXGk9IRyZuc9fFssQ=;
	h=From:To:Cc:Subject:Date;
	b=BUqaq6c+P9/fTzHFFnmGJs1xcXZgdRx94ZV9tumgrxJaRgblH4JTSnIYWISHzq3WM
	 KjPlln2Up4WzQTLYrZCuIRg+SllRQf1N4Krh+SH1Kk3bBBaVULlEHHpdJi9qjfu5Gj
	 ZYA78t079DPCqHU1sknhb/utfSLmPpyrzPhbVanHsQh/pVrWkCN0q8jCdEdG0+xQ/i
	 MZ2eD4yHFbm20xynjaEjq+w8/U43c4ac/Iq6w85pjGgSJbRnjSJtOwFKY1Bh6YBLBm
	 /FZ8/IZGELN3gQi/bfLuunJJXI6asQqZB8W9VaiPxztuTVCnDsrniuA5rXB1GQ+geD
	 pSzCtK8jiN+Hw==
From: "syzbot" <syzbot@kernel.org>
To: syzkaller-bugs@googlegroups.com, Jeffin Philip <jeffinphilip14@gmail.com>, "Danilo Krummrich" <dakr@kernel.org>, <driver-core@lists.linux.dev>, "Greg Kroah-Hartman" <gregkh@linuxfoundation.org>, "Luis Chamberlain" <mcgrof@kernel.org>, "Rafael J. Wysocki" <rafael@kernel.org>, "Russ Weight" <russ.weight@linux.dev>, "Ming Lei" <ming.lei@canonical.com>
Cc: linux-kernel@vger.kernel.org, syzbot@lists.linux.dev
Subject: [PATCH] firmware_loader: Reject 0-size firmware in batched requests
Message-ID: <ae7f1cae-a734-45e4-9949-0dacdc8e555f@mail.kernel.org>
Precedence: bulk
X-Mailing-List: syzbot@lists.linux.dev
List-Id: <syzbot.lists.linux.dev>
List-Subscribe: <mailto:syzbot+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:syzbot+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Date: Wed,  5 Aug 2026 07:05:16 +0000 (UTC)

From: Jeffin Philip <jeffinphilip14@gmail.com>

When multiple concurrent requests are made for the same firmware name, the
firmware loader batches them. The first request allocates a struct fw_priv
and proceeds to load the firmware (e.g., via the sysfs fallback).
Subsequent requests find the existing fw_priv and wait for the first
request to finish.

In the sysfs fallback mechanism, if user space writes 1 to the loading
attribute and then immediately writes 0 without writing any data,
fw_priv->size remains 0 and fw_priv->data remains NULL. The sysfs fallback
mechanism completes and sets the state to FW_STATUS_DONE.

The first request wakes up, explicitly checks for a 0-size firmware, and
correctly returns -ENOENT. However, the batched requests wake up from
fw_state_wait(), see the FW_STATUS_DONE state, and assume success.
_request_firmware_prepare() then blindly copies the 0 size and NULL data
pointer into the struct firmware and returns success.

Drivers receiving this invalid firmware can crash when attempting to parse
it. For example, the emi26 driver calls request_ihex_firmware(), which
passes the 0-size, NULL-data firmware to ihex_validate_fw(). Because
fw->size is 0, fw->size - sizeof(*end) underflows to a huge positive value,
causing the loop condition to evaluate to true. The loop executes and
attempts to read from the NULL pointer, resulting in a KASAN
null-ptr-deref:

Oops: general protection fault, probably for non-canonical address
0xdffffc0000000000: 0000 [#1] SMP KASAN NOPTI
KASAN: null-ptr-deref in range [0x0000000000000000-0x0000000000000007]
CPU: 0 UID: 0 PID: 5720 Comm: kworker/0:3 Not tainted
Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS
1.16.3-debian-1.16.3-2 04/01/2014
Workqueue: usb_hub_wq hub_event
RIP: 0010:ihex_binrec_size include/linux/ihex.h:26 [inline]
RIP: 0010:__ihex_next_binrec include/linux/ihex.h:35 [inline]
RIP: 0010:ihex_validate_fw include/linux/ihex.h:54 [inline]
RIP: 0010:request_ihex_firmware include/linux/ihex.h:74 [inline]
RIP: 0010:emi26_load_firmware drivers/usb/misc/emi26.c:86 [inline]
RIP: 0010:emi26_probe+0x283/0x1690 drivers/usb/misc/emi26.c:232
Call Trace:
 <TASK>
 usb_probe_interface+0x653/0xc60 drivers/usb/core/driver.c:396
 call_driver_probe drivers/base/dd.c:-1 [inline]
 really_probe+0x254/0xae0 drivers/base/dd.c:706

To fix this, enforce the same validation rules for batched requests as for
the primary request. In _request_firmware_prepare(), after fw_state_wait()
returns successfully, explicitly check if fw_priv->size is 0. If it is,
return -ENOENT instead of blindly calling fw_set_page_data(). This properly
aborts any remaining batched requests and cleans up the state.

Fixes: 1f2b79599ee8 ("firmware loader: always let firmware_buf own the pages buffer")
Assisted-by: Gemini:gemini-3.5-flash Gemini:gemini-3.1-pro-preview syzbot
Reported-by: syzbot+cb67625c47fe4d6dd7c8@syzkaller.appspotmail.com
Closes: https://syzkaller.appspot.com/bug?extid=cb67625c47fe4d6dd7c8
Link: https://syzkaller.appspot.com/ai_job?id=c8fc1a4f-643b-4169-a624-9871d2c011bd
Signed-off-by: Jeffin Philip <jeffinphilip14@gmail.com>

---
diff --git a/drivers/base/firmware_loader/main.c b/drivers/base/firmware_loader/main.c
index 24213a0ea..b1521a1da 100644
--- a/drivers/base/firmware_loader/main.c
+++ b/drivers/base/firmware_loader/main.c
@@ -771,6 +771,8 @@ _request_firmware_prepare(struct firmware **firmware_p, const char *name,
 	if (ret > 0) {
 		ret = fw_state_wait(fw_priv);
 		if (!ret) {
+			if (!fw_priv->size)
+				return -ENOENT;
 			fw_set_page_data(fw_priv, firmware);
 			return 0; /* assigned */
 		}


base-commit: 075b74841bd0065a3bda3440873c747938e69b68
-- 
See https://goo.gle/syzbot-ai-patches for information about AI-generated patches.
You can comment on the patch as usual, syzbot will try to address
the comments and send a new version of the patch if necessary.
syzbot engineers can be reached at syzkaller@googlegroups.com.
