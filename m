Received: from smtpo49.interia.pl (smtpo49.interia.pl [217.74.67.49])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 60B803B52E4
	for <syzbot@lists.linux.dev>; Thu, 30 Jul 2026 06:54:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.74.67.49
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785394468; cv=none; b=KZIuG97O7lbbHgNBKd53y1apz/FGpCbW8cVA8rQ1yuIS88ex9WcbHkvVy7p5EYr9+QKVxNk6M6ekuqTMtF3J8c0KHwUvWo0hvzMxIo3tCCqRkJiL9wCigAue8lby4tTxb0lH9fnaYDLYmEuh2eP+pFo0h5hbbJJR8ZO4hb6uGz8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785394468; c=relaxed/simple;
	bh=fLLMaP1I/jf46EcHpywZWKP5jAGCxLU2LdkoPvXoEko=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=bdXlOV0c28ar47YiUHzlEV2CgyO/bBMDelLLJHipwBLSUKW1Z6cZzQp6HcL3ehEJnPza4lZ2hOjlQfX+DuoJK2bA9wZF+MlhyvNfCbttTwDoyEPjm2PENZPvSLAbdtlBW5/f739JzRgIKouCcsEd8L9v/CX2xOd5eByF2BbMohY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=poczta.fm; spf=pass smtp.mailfrom=poczta.fm; dkim=pass (1024-bit key) header.d=poczta.fm header.i=@poczta.fm header.b=E4TbobzV; arc=none smtp.client-ip=217.74.67.49
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=poczta.fm
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=poczta.fm
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=poczta.fm header.i=@poczta.fm header.b="E4TbobzV"
Received: from localhost (unknown [80.68.231.31])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (P-256) server-signature ECDSA (P-256) server-digest SHA256)
	(No client certificate requested)
	by poczta.interia.pl (INTERIA.PL) with ESMTPSA;
	Thu, 30 Jul 2026 08:54:04 +0200 (CEST)
From: Slawomir Stepien <sst@poczta.fm>
To: syzkaller-bugs@googlegroups.com,
	sst@poczta.fm,
	linux-wireless@vger.kernel.org,
	dsd@gentoo.org
Cc: johannes.berg@intel.com,
	kees@kernel.org,
	linux-kernel@vger.kernel.org,
	nihaal@cse.iitm.ac.in,
	syzbot@lists.linux.dev,
	syzbot+0ec3d1a6cf1fbe79c153@syzkaller.appspotmail.com
Subject: [PATCH v2] wifi: zd1211rw: reject secondary interfaces to prevent conflicts
Date: Thu, 30 Jul 2026 08:52:31 +0200
Message-ID: <20260730065231.1644030-1-sst@poczta.fm>
X-Mailer: git-send-email 2.55.0
Precedence: bulk
X-Mailing-List: syzbot@lists.linux.dev
List-Id: <syzbot.lists.linux.dev>
List-Subscribe: <mailto:syzbot+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:syzbot+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=poczta.fm; s=dk;
	t=1785394446; bh=gNay+FB0RRVmJTW7vIXJUoGomeLzqEruQWKFaXghjmo=;
	h=From:To:Subject:Date:Message-ID:MIME-Version;
	b=E4TbobzVOoixE68gSdiprr1pFOXkpcm4LqkN6hyneBNcOKevw2bKfT7asUk1RIXXu
	 i3RSSV60B3iBE6VqvqVzewwNJGhKoR8Ua2rlvghJd8aKFS4GAyuG5D+scc0fkK+DbK
	 rMeeZeoYXjO1I3Qyz4sL4Sb/yre5ZnRnzDN/9neE=

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
v2:
* Fix the style of the block comment

v1:
* https://lore.kernel.org/all/0720e3ad-d98e-47d7-89af-4d22416b0fbc@mail.kernel.org/T/
---
 drivers/net/wireless/zydas/zd1211rw/zd_usb.c | 8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/drivers/net/wireless/zydas/zd1211rw/zd_usb.c b/drivers/net/wireless/zydas/zd1211rw/zd_usb.c
index 966d8ccb0dbc..98102c663434 100644
--- a/drivers/net/wireless/zydas/zd1211rw/zd_usb.c
+++ b/drivers/net/wireless/zydas/zd1211rw/zd_usb.c
@@ -1353,6 +1353,14 @@ static int probe(struct usb_interface *intf, const struct usb_device_id *id)
 	struct zd_usb *usb;
 	struct ieee80211_hw *hw = NULL;
 
+	/*
+	 * ZD1211 devices are single-function. Reject secondary interfaces
+	 * to prevent multiple instances from conflicting on hardcoded endpoints
+	 * and triggering recursive locking warnings.
+	 */
+	if (intf->cur_altsetting->desc.bInterfaceNumber != 0)
+		return -ENODEV;
+
 	print_id(udev);
 
 	if (id->driver_info & DEVICE_INSTALLER)
-- 
2.55.0

