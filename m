Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BDC713EEACB
	for <syzbot@lists.linux.dev>; Tue, 28 Jul 2026 11:14:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785237279; cv=none; b=GfYkLDSmNqsGrYETzpeJqAlY1c2r17Ms3vkaqKRnHgDJZ6NZhQAfnBMKpom7lkXysCYAltcyYG3tlmCmmJOKmrqdO65fM+JczY8VZHCpyQvNBp5zH3YVE011SLIsfd0iLLprT0sI10vL037IeHFREk81L0wGT4RHmyoNwjwAIYg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785237279; c=relaxed/simple;
	bh=D5gateXrl36FZHOGWC/ex/JPvwUFU59OnACxFEOrNCU=;
	h=From:To:Cc:Subject:Message-ID:MIME-Version:Content-Type:Date; b=lQDj2wakskVAX42OW4wkZDID+OENhB/3WFMGU+DFhZYUdAiLHfF8eo+KRvXrOIW1ZAsSPJIjZLoBzxkdBHa02KaT4vFA5Z3BWE15BOxq4GayVREIv525IMEvnwpxR7fC51yShkPaSUtEEEj0EnqYG4vwxM6hmDKvmHn6nbIZBig=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Fciiwzvo; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Fciiwzvo"
Received: by smtp.kernel.org (Postfix) with UTF8SMTPSA id 4AF141F000E9;
	Tue, 28 Jul 2026 11:14:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1785237277;
	bh=jSgoJSRHt7vSFhfY8RsaBdsM7PKP/FOdYpcF91Y5lQs=;
	h=From:To:Cc:Subject:Date;
	b=FciiwzvoDqFc90deXCGzkJPmTx0itceb+ppVpf8PU5Vav4fLU5W7tH8Rr1r+rDQkO
	 ZN0t7oDyei+tD9h9WjvqqiFyPHsm1do55/EGi1U+Zm7Skw0nX0J1VqMz4i/QFk5ouM
	 8t7VrAeTctpVcUgMF6kMDNl21cMbTo/Lqik7j3oi0KhFN7MygKycBpK1K8nC/Mx0eT
	 EKZTSC2P1YjgqMroVWhDyC6kTaANaFNynlDYNRU0Xqwp/mliNuuahClR5nRi0VvlUE
	 NnFf2NyojTMsOBZR348nT7OA+svMspmNPAu7cgOWxXxAjAVFbOEzempvENWSSB8xwE
	 U2T5QeD/eEPvA==
From: "syzbot" <syzbot@kernel.org>
To: syzkaller-upstream-moderation@googlegroups.com
Cc: sst@poczta.fm, syzbot@lists.linux.dev
Subject: [PATCH RFC v2] wifi: zd1211rw: reject secondary interfaces to prevent conflicts
Message-ID: <4ccb85ef-8c74-4226-92ac-f8145816eb0a@mail.kernel.org>
Precedence: bulk
X-Mailing-List: syzbot@lists.linux.dev
List-Id: <syzbot.lists.linux.dev>
List-Subscribe: <mailto:syzbot+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:syzbot+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Date: Tue, 28 Jul 2026 11:14:37 +0000 (UTC)

The zd1211rw driver is designed for single-function Wi-Fi dongles and
hardcodes its USB endpoints. When a malformed USB device exposes multiple
interfaces that match the driver's device ID, the driver blindly binds to
all of them.

During probe(), the driver calls usb_reset_device(), which iterates over
all interfaces and invokes the pre_reset() callback for each bound
interface. Since multiple interfaces are bound to zd1211rw, pre_reset() is
called sequentially for each instance, acquiring their respective
&mac->chip.mutex. Because all instances initialize their mutexes with the
same lock class, lockdep detects a task acquiring a lock of the same class
it already holds and flags it as a possible recursive deadlock:

WARNING: possible recursive locking detected
kworker/0:1/11 is trying to acquire lock:
ffff88810371dde0 (&chip->mutex){+.+.}-{4:4}, at:
zd_chip_disable_rxtx+0x20/0x50
drivers/net/wireless/zydas/zd1211rw/zd_chip.c:1465

but task is already holding lock:
ffff8881138ddde0 (&chip->mutex){+.+.}-{4:4}, at: pre_reset+0x28c/0x380
drivers/net/wireless/zydas/zd1211rw/zd_usb.c:1505

Fix this by explicitly rejecting secondary interfaces (bInterfaceNumber !=
0) during probe(). This ensures that only a single instance of the driver
binds to the device, eliminating the recursive locking scenario.

Fixes: e85d0918b54f ("[PATCH] ZyDAS ZD1211 USB-WLAN driver")
Assisted-by: Gemini:gemini-3.5-flash Gemini:gemini-3.1-pro-preview syzbot
Reported-by: syzbot+0ec3d1a6cf1fbe79c153@syzkaller.appspotmail.com
Closes: https://syzkaller.appspot.com/bug?extid=0ec3d1a6cf1fbe79c153
Link: https://syzkaller.appspot.com/ai_job?id=00724ef7-fd77-4cde-9779-895b8f63c2f6
To: <linux-wireless@vger.kernel.org>
To: "Daniel Drake" <dsd@gentoo.org>
Cc: "Johannes Berg" <johannes.berg@intel.com>
Cc: "Kees Cook" <kees@kernel.org>
Cc: <linux-kernel@vger.kernel.org>
Cc: "Abdun Nihaal" <nihaal@cse.iitm.ac.in>

---
v2:
- Removed the explanation of the -EAGAIN error from the commit message.
- Removed the line containing only '=' from the commit message.

v1:
https://lore.kernel.org/all/a15b9bcb-e2d2-4767-a0d1-87522fa559a1@mail.kernel.org/T/
---
diff --git a/drivers/net/wireless/zydas/zd1211rw/zd_usb.c b/drivers/net/wireless/zydas/zd1211rw/zd_usb.c
index 966d8ccb0..2bb2df12c 100644
--- a/drivers/net/wireless/zydas/zd1211rw/zd_usb.c
+++ b/drivers/net/wireless/zydas/zd1211rw/zd_usb.c
@@ -1353,6 +1353,13 @@ static int probe(struct usb_interface *intf, const struct usb_device_id *id)
 	struct zd_usb *usb;
 	struct ieee80211_hw *hw = NULL;
 
+	/* ZD1211 devices are single-function. Reject secondary interfaces
+	 * to prevent multiple instances from conflicting on hardcoded endpoints
+	 * and triggering recursive locking warnings.
+	 */
+	if (intf->cur_altsetting->desc.bInterfaceNumber != 0)
+		return -ENODEV;
+
 	print_id(udev);
 
 	if (id->driver_info & DEVICE_INSTALLER)


base-commit: 1590cf0329716306e948a8fc29f1d3ee87d3989f
-- 
This is an AI-generated patch subject to moderation.
Reply with '#syz upstream' to Sign-off the patch as a human author
and send it to the upstream kernel mailing lists.
Reply with '#syz reject' to reject it ('#syz unreject' to undo).

See https://goo.gle/syzbot-ai-patches for information about AI-generated patches.
You can comment on the patch as usual, syzbot will try to address
the comments and send a new version of the patch if necessary.
syzbot engineers can be reached at syzkaller@googlegroups.com.
