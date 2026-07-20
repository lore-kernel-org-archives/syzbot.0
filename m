Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 439CF401A2A
	for <syzbot@lists.linux.dev>; Mon, 20 Jul 2026 11:46:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784547993; cv=none; b=ao2fed974PMsLwIdEK9oql8BkDyYXGtJUh9oFHhdQTZe2WwNy7HxQb70DIAYtFjBp63Z0ZP4TwsmMNF3WGH0gGneWZHrFGf9hfxvnq/L00T9tAOotxOe2IAQcrrL1O1mX23I+G/qZ9Nl5H1O1UnTi6P1uBZBQRczsiryOL1webg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784547993; c=relaxed/simple;
	bh=HbMo6mBJcuQESsEfOwPYJ5jx17Vx3y0eibs83+9wUkg=;
	h=From:To:Cc:Subject:Message-ID:MIME-Version:Content-Type:Date; b=JYlCsFtmLQ9yvmu1MtG1/7422OHoWtzKX+m3wFJ1nCdovyRLsv2qRTePJDM1IV75Tt7b9P3iAB+Dcy4mM0jt8UnDmkd02T9kwpYwEWI8atKJaLYLrVzuFzicW6468B8tmInJ2wzoI6Zmq4q0UWtvPTyhc7uZLiadKWH9yeWwUx8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=KinPS42I; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="KinPS42I"
Received: by smtp.kernel.org (Postfix) with UTF8SMTPSA id F40481F00AC4;
	Mon, 20 Jul 2026 11:46:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1784547987;
	bh=kgoiH0jKQG528QVUOTbKGtqRhbNsMloSzTmVSCmOg44=;
	h=From:To:Cc:Subject:Date;
	b=KinPS42IkLTUUynAokCxFx1c2ZaBpwChnTpGM5QoV7kxyO9sWwP0ATaYiaR6N8gij
	 btB51jJm7wt1v8bibQ17+oWHPTAti0jDRr1WWqBF2vUH3E+8w65DpwrCoM/QRtFvaR
	 ZuOnylcOrPw+s/VhPszbmhbpZ4RFmGUfRHS+as0j2OV2pdLtZHu1uxfJ2JSVv+Vcpf
	 4PNQ09pPAp9pe8KXuAOmXpjiixYvZCIfbptPkwFK4uUQ9yS5Ji1Nqm26PzOD4poIES
	 d/D0AxV8o3vB+jSfuiJeGpUR8j++piWeGIMNi8pmx7N4xrbcKqUYVcfIm3QZ4/2s68
	 fyvW5crJnLirQ==
From: "syzbot" <syzbot@kernel.org>
To: syzkaller-upstream-moderation@googlegroups.com
Cc: syzbot@lists.linux.dev
Subject: [PATCH RFC] wifi: zd1211rw: reject secondary interfaces to prevent conflicts
Message-ID: <a15b9bcb-e2d2-4767-a0d1-87522fa559a1@mail.kernel.org>
Precedence: bulk
X-Mailing-List: syzbot@lists.linux.dev
List-Id: <syzbot.lists.linux.dev>
List-Subscribe: <mailto:syzbot+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:syzbot+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Date: Mon, 20 Jul 2026 11:46:26 +0000 (UTC)

The zd1211rw driver is designed for single-function Wi-Fi dongles and
hardcodes its USB endpoints. When a malformed USB device exposes multiple
interfaces that match the driver's device ID, the driver blindly binds to
all of them. This leads to two critical issues.

First, multiple driver instances attempt to submit URBs to the exact same
hardcoded endpoints concurrently. This overloads the endpoint's periodic
bandwidth or queue limits, resulting in -EAGAIN (-11) errors during I/O
operations.

Second, during probe(), the driver calls usb_reset_device(), which iterates
over all interfaces and invokes the pre_reset() callback for each bound
interface. Since multiple interfaces are bound to zd1211rw, pre_reset() is
called sequentially for each instance, acquiring their respective
&mac->chip.mutex. Because all instances initialize their mutexes with the
same lock class, lockdep detects a task acquiring a lock of the same class
it already holds and flags it as a possible recursive deadlock:

============================================
WARNING: possible recursive locking detected
...
kworker/0:0/4961 is trying to acquire lock:
ffff888105315de0 (&chip->mutex){+.+.}-{4:4}, at:
zd_chip_disable_rxtx+0x20/0x50
drivers/net/wireless/zydas/zd1211rw/zd_chip.c:1465

but task is already holding lock:
ffff8881129cdde0 (&chip->mutex){+.+.}-{4:4}, at: pre_reset+0x28c/0x380
drivers/net/wireless/zydas/zd1211rw/zd_usb.c:1505

Fix this by explicitly rejecting secondary interfaces (bInterfaceNumber !=
0) during probe(). This ensures that only a single instance of the driver
binds to the device, eliminating both the endpoint conflicts and the
recursive locking scenario.

Fixes: e85d0918b54f ("[PATCH] ZyDAS ZD1211 USB-WLAN driver")
Assisted-by: Gemini:gemini-3.1-pro-preview syzbot
Reported-by: syzbot+0ec3d1a6cf1fbe79c153@syzkaller.appspotmail.com
Closes: https://syzkaller.appspot.com/bug?extid=0ec3d1a6cf1fbe79c153
Link: https://syzkaller.appspot.com/ai_job?id=31453070-c764-4248-98b8-5f0a8f8393c3
To: <linux-wireless@vger.kernel.org>
To: "Daniel Drake" <dsd@gentoo.org>
Cc: "Bjorn Helgaas" <bhelgaas@google.com>
Cc: "Johannes Berg" <johannes.berg@intel.com>
Cc: "Kees Cook" <kees@kernel.org>
Cc: <linux-kernel@vger.kernel.org>
Cc: "Abdun Nihaal" <nihaal@cse.iitm.ac.in>

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
