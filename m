Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AB1822F3621;
	Wed, 29 Jul 2026 08:04:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785312299; cv=none; b=BwpONPnT3bnLycCjTI2DCOo2iKwMqGKvgGaW3MqXk/6ZR3f1gNE+Y4O0JMGOWLjK1uJ4TKu0zSSUqFaW0+ADx/+giwobj4bjHqyc3H1qQ6yfg68awnxlSlYz1ZE79yUABLAtxkeY24RNMTI2qnkHCroDuL3neDznC4ODBDJFU1M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785312299; c=relaxed/simple;
	bh=ddKVkjiqKodKGLZySimrJtcq3Eq/s7T16ooUmXqLtE0=;
	h=From:To:Cc:Subject:Message-ID:MIME-Version:Content-Type:Date; b=lHKx+CaEU18EdpZU6FK1zt/hgDsgyIljZOApwoCj2X0TmSe+QQcgDDzCLhgJ99l3yES5yewYjIddDDdQE6a3n6DOMOHLoQGYQ/nGaMgXxwJmJ2FhWl7G6TfiuahfDx5cw7Hv006whUeciKRHQzX6f16jUumvoUzu8RN0DAbgpK4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=fCzto+AC; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="fCzto+AC"
Received: by smtp.kernel.org (Postfix) with UTF8SMTPSA id 7A3821F00A3A;
	Wed, 29 Jul 2026 08:04:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1785312294;
	bh=i+7IfLNzLhya7c637AxYiHwK+rmTN+FA662oC7SYVyo=;
	h=From:To:Cc:Subject:Date;
	b=fCzto+ACDdxOPEKA+y2jbdbjA8L9sL7fTit+QPNqqh+aeC6FDvUfqtupFVcFAaaPP
	 CB1LXajjU2leu2/fwP6IoliVywdzT1gPGak0PZy/gWVjkfW6VO77+GT2hE2VSIbrka
	 kx5u/kmcBY0s/afxagKObQG5JQl7P4jDC5qTL+D9wfzIYagUsC6HRUUJgjpBadkO0x
	 n5jixwJWMyIbWl/1zZ/vrn6h9161DgpsxTC+9tQdnv98oTnxLM+ftJLmOD60KrcXX4
	 /oq525KtlMhMmQQo43s+fVslqZeF8Y7+2fmGC6z6wqoNdL0IFhpPxGuxuaPsKDatse
	 1iUaEUM1tOYEg==
From: "syzbot" <syzbot@kernel.org>
To: syzkaller-bugs@googlegroups.com, Slawomir Stepien <sst@poczta.fm>, <linux-wireless@vger.kernel.org>, "Daniel Drake" <dsd@gentoo.org>
Cc: johannes.berg@intel.com, kees@kernel.org, linux-kernel@vger.kernel.org, nihaal@cse.iitm.ac.in, syzbot@lists.linux.dev
Subject: [PATCH] wifi: zd1211rw: reject secondary interfaces to prevent conflicts
Message-ID: <0720e3ad-d98e-47d7-89af-4d22416b0fbc@mail.kernel.org>
Precedence: bulk
X-Mailing-List: syzbot@lists.linux.dev
List-Id: <syzbot.lists.linux.dev>
List-Subscribe: <mailto:syzbot+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:syzbot+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Date: Wed, 29 Jul 2026 08:04:54 +0000 (UTC)

From: Slawomir Stepien <sst@poczta.fm>

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
Signed-off-by: Slawomir Stepien <sst@poczta.fm>

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
See https://goo.gle/syzbot-ai-patches for information about AI-generated patches.
You can comment on the patch as usual, syzbot will try to address
the comments and send a new version of the patch if necessary.
syzbot engineers can be reached at syzkaller@googlegroups.com.
