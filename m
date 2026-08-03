Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 356EA3E1D11
	for <syzbot@lists.linux.dev>; Mon,  3 Aug 2026 09:28:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785749330; cv=none; b=L+UXmFMc1szYlj47lE0/piZR0HI5u9oRGm8RkP3sGcb08Qvp1dE/SiYXy8u3+k+mzNEJ39kTqxEM2ETMZs5zP0/8SqvK3T2tVNZkl0mhf90ORaGxrxULM+yaWVw/P09RzFY8ZZdSvCkUzemfLljAmTC2/W5X67U76EAvlP3fjwM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785749330; c=relaxed/simple;
	bh=YvM19uO6idlHc2gjZgiH1nXrwmQ+VVLuPeTwss8DUIQ=;
	h=From:To:Cc:Subject:Message-ID:MIME-Version:Content-Type:Date; b=nEXCRIDktOxJWD/XSMOmTy/F2WrpABIwl6wESrG9zLw9jXuR3vcF0qJJoHTxYKpt0HDjTXzYwlFU17+xzdonFOiQzdqoyZi9uB5Zqaq7OeYy13305W2Kx2vbg/Of4IPz6Brln4SF5x6xYhrSDiheIKNHbK5WKH/MotbTFSBUGP0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=nMp43eQF; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="nMp43eQF"
Received: by smtp.kernel.org (Postfix) with UTF8SMTPSA id 6351B1F000E9;
	Mon,  3 Aug 2026 09:28:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1785749320;
	bh=yIWY051IxTaIiIPPdW58gGkZVbwtxRQSFjLiWTMukNo=;
	h=From:To:Cc:Subject:Date;
	b=nMp43eQFL3sO4wBc3xOq46O5/6Bfef3/WGckUokpfiRuA6qZmm/OT5Clmqhj74RSU
	 ynBtucPnpPebr+nimivxKPPLKbceOZLwjPvJ8TverUm5U77tiaJ8KYHFIiUG2z1FfA
	 V8SiqKxj1Vew9emyHN9n2gFfkA7P5pBI0Ex4jzdRa9s/sTCteSwKqjoEVy/VDipu8k
	 +5ePKu9MblIeN/Yo+eC3jZ2qj7EKfJiVIis5eRsAt8CF34mmVuoUYZ9T+4sMp5lb9h
	 DaovkVuVxldstOaQIZF4UdTefC7nPEy/9QSVsRl468B5GzkeuTC0Lz38x7n2OIoCZO
	 M5u/719U87ojg==
From: "syzbot" <syzbot@kernel.org>
To: syzkaller-upstream-moderation@googlegroups.com
Cc: syzbot@lists.linux.dev
Subject: [PATCH RFC] firmware_loader: Reject 0-size firmware in batched requests
Message-ID: <3a4d5500-d967-427a-a7e1-f8c69fad4cfe@mail.kernel.org>
Precedence: bulk
X-Mailing-List: syzbot@lists.linux.dev
List-Id: <syzbot.lists.linux.dev>
List-Subscribe: <mailto:syzbot+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:syzbot+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Date: Mon,  3 Aug 2026 09:28:40 +0000 (UTC)

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
To: "Danilo Krummrich" <dakr@kernel.org>
To: <driver-core@lists.linux.dev>
To: "Greg Kroah-Hartman" <gregkh@linuxfoundation.org>
To: "Luis Chamberlain" <mcgrof@kernel.org>
To: "Rafael J. Wysocki" <rafael@kernel.org>
To: "Russ Weight" <russ.weight@linux.dev>
To: "Ming Lei" <ming.lei@canonical.com>
Cc: <linux-kernel@vger.kernel.org>

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
This is an AI-generated patch subject to moderation.
Reply with '#syz upstream' to Sign-off the patch as a human author
and send it to the upstream kernel mailing lists.
Reply with '#syz reject' to reject it ('#syz unreject' to undo).

See https://goo.gle/syzbot-ai-patches for information about AI-generated patches.
You can comment on the patch as usual, syzbot will try to address
the comments and send a new version of the patch if necessary.
syzbot engineers can be reached at syzkaller@googlegroups.com.
