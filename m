Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DCAF657D22F
	for <syzbot@lists.linux.dev>; Tue,  8 Sep 2026 16:04:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788883477; cv=none; b=UWY6SFhrG4Fi520e87Bz74hYWqgxYSTs4KQMjkZWqUbO48o43/qK2sLrJ9S40zmQzDz6Q9bSagFJdtSo6Coh4Lq34vfSxwi6fyg25tCxN10GOLOqn/JzGTWO3OYxmQPyMqeMUGpFEhRyy6ikxDvu/GbaX9nHIeIOVVuYKZvSHWc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788883477; c=relaxed/simple;
	bh=zsaHOezx/yJNwfpNWRD13Mbyknk7nTO3+HJRjFTV/Yo=;
	h=From:To:Cc:Subject:Message-ID:MIME-Version:Content-Type:Date; b=bAEObxUE0EdTv+ZJ2SsNJ7W64JRY17tfcM5gPdiL9tEiRH+apw8bm8KeBkhG1Jpm0V+Z3C3xUez9UmBuMybVjKqPPuryBPvzno5BdtDzrhSqLtF4LMh1ezLTwmSSvXSK/I/4ME6aTyR1d+Mi/2SWZ2NuZcL1T9JBgSt7HAguGXk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=H8Eont4K; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="H8Eont4K"
Received: by smtp.kernel.org (Postfix) with UTF8SMTPSA id 3633F1F00A3A;
	Tue,  8 Sep 2026 16:04:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788883475;
	bh=v5h9VzwyHbBdfn/E6ZHniM9cWwAU4Ksesd4Vpw7dqkM=;
	h=From:To:Cc:Subject:Date;
	b=H8Eont4Ka3XB8OCoGcAPd09mugtamf5JNlaHaFqPCvHMYSg+DPkbNfUUNpmtY7jEw
	 mfAMr/AkTUl9lGIsQ1NkmUJD8KIvcVaMU4Ai/0wjSKDHsfu5yCQcOGcCVLquteHuA0
	 soRMVexBHx+eWv5Xj+KkFE63i1fYa8IKRJ+6OBGAmAlszIfNmYjGQRu+ZDmYDeNG8y
	 /1nwlIVLUOOJz50zMQTcJzVqRlXAUBqnv94K322wL9gPdURWygTh+cKduNUKGkh9kG
	 18En+cSsFgUhYB/f0bwDacT+oHgg6oci+WRnIsvgvKg3V1OgkGBwQdjPgaf7sL01DV
	 4HBkWfCLk1Qwg==
From: "syzbot" <syzbot@kernel.org>
To: syzkaller-upstream-moderation@googlegroups.com
Cc: elver@google.com, nogikh@google.com, syzbot@lists.linux.dev
Subject: [PATCH RFC v5] net: phy: fix suspicious RCU usage in phy_detach()
Message-ID: <eb31c4ec-3f9f-43e4-8f4a-d4dbdde72e7f@mail.kernel.org>
Precedence: bulk
X-Mailing-List: syzbot@lists.linux.dev
List-Id: <syzbot.lists.linux.dev>
List-Subscribe: <mailto:syzbot+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:syzbot+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Date: Tue,  8 Sep 2026 16:04:35 +0000 (UTC)

During device probe (for example, in ax88772_bind()), drivers may invoke
phylink_connect_phy() before the net_device is registered (while
dev->reg_state is NETREG_UNINITIALIZED) and without holding the RTNL lock.

If connecting or bringing up the PHY fails inside phylink_connect_phy(),
the error cleanup path invokes phy_detach(). In phy_detach(), dev->hwprov
is dereferenced using rtnl_dereference(), which expects the RTNL lock to be
held. Because the RTNL lock is not held, lockdep triggers a suspicious RCU
usage warning:

WARNING: suspicious RCU usage
drivers/net/phy/phy_device.c:1944 suspicious rcu_dereference_protected()
usage!

Call Trace:
 <TASK>
 dump_stack_lvl+0xe8/0x150 lib/dump_stack.c:120
 lockdep_rcu_suspicious+0x140/0x1d0 kernel/locking/lockdep.c:6972
 phy_detach+0x219/0x550 drivers/net/phy/phy_device.c:1944
 phylink_connect_phy+0x1dc/0x300 drivers/net/phy/phylink.c:2251
 ax88772_init_phy+0xe3/0x390 drivers/net/usb/asix_devices.c:714
 ax88772_bind+0x9cb/0xe50 drivers/net/usb/asix_devices.c:925
 usbnet_probe+0xab3/0x2ad0 drivers/net/usb/usbnet.c:1808
 </TASK>

Before a net_device is registered (dev->reg_state != NETREG_REGISTERED), it
is not exposed to the rest of the network stack, so the probing context has
exclusive access and holding the RTNL lock is not required. Fix this by
using rcu_dereference_protected() in phy_detach() with a condition checking
whether the RTNL lock is held or dev->reg_state != NETREG_REGISTERED. This
allows safe cleanup on probe failure before device registration without
requiring drivers to acquire the RTNL lock.

Fixes: 35f7cad1743e ("net: Add the possibility to support a selected hwtstamp in netdevice")
Assisted-by: Gemini:gemini-3.8-flash syzbot
Reported-by: syzbot+694b49f41098a5df4fd7@syzkaller.appspotmail.com
Closes: https://syzkaller.appspot.com/bug?extid=694b49f41098a5df4fd7
Link: https://syzkaller.appspot.com/ai_job?id=03f9ee28-d9b3-48a4-8d9a-3878018387f0
To: "Andrew Lunn" <andrew@lunn.ch>
To: "David S. Miller" <davem@davemloft.net>
To: "Eric Dumazet" <edumazet@google.com>
To: "Heiner Kallweit" <hkallweit1@gmail.com>
To: "Jakub Kicinski" <kuba@kernel.org>
To: <netdev@vger.kernel.org>
To: "Paolo Abeni" <pabeni@redhat.com>
To: "Kory Maincent" <kory.maincent@bootlin.com>
Cc: <linux-kernel@vger.kernel.org>
Cc: "Russell King" <linux@armlinux.org.uk>

---
v5:
- Use READ_ONCE() to read dev->reg_state.

v4:
- Clarify in the commit description why dereferencing dev->hwprov without RTNL is safe before device registration.
https://lore.kernel.org/all/cc8448ce-5426-472c-b0f4-84f9237eb50f@mail.kernel.org/T/

v3:
- Check dev->reg_state != NETREG_REGISTERED instead of dev->reg_state == NETREG_UNINITIALIZED in phy_detach().
https://lore.kernel.org/all/5e1c820e-982c-4c4b-ae8f-682ae1fe2da2@mail.kernel.org/T/

v2:
- Moved the fix to phy_detach() in phylib by allowing rcu_dereference_protected() when dev->reg_state is NETREG_UNINITIALIZED, instead of acquiring RTNL in asix.
- Updated the commit subject and description to reflect the changes in phylib.
https://lore.kernel.org/all/5a7201b1-c826-4855-9105-3caa58977bc3@mail.kernel.org/T/

v1:
https://lore.kernel.org/all/2835933a-117e-405a-a369-86459e8c8299@mail.kernel.org/T/
---
diff --git a/drivers/net/phy/phy_device.c b/drivers/net/phy/phy_device.c
index 94b2e85e0..2f0a10739 100644
--- a/drivers/net/phy/phy_device.c
+++ b/drivers/net/phy/phy_device.c
@@ -1939,9 +1939,13 @@ void phy_detach(struct phy_device *phydev)
 		struct hwtstamp_provider *hwprov;
 
 		/* hwprov may technically be protected by ops lock but
-		 * not for devices with a phydev, see phy_link_topo_add_phy()
+		 * not for devices with a phydev, see phy_link_topo_add_phy().
+		 * RTNL is not held when cleaning up on probe failure before
+		 * device registration.
 		 */
-		hwprov = rtnl_dereference(dev->hwprov);
+		hwprov = rcu_dereference_protected(dev->hwprov,
+						   lockdep_rtnl_is_held() ||
+						   READ_ONCE(dev->reg_state) != NETREG_REGISTERED);
 		/* Disable timestamp if it is the one selected */
 		if (hwprov && hwprov->phydev == phydev) {
 			rcu_assign_pointer(dev->hwprov, NULL);


base-commit: df2908090cda368b01ff43709f51890076c56157
-- 
This is an AI-generated patch subject to moderation.
Reply with '#syz upstream' to Sign-off the patch as a human author
and send it to the upstream kernel mailing lists.
Reply with '#syz reject' to reject it ('#syz unreject' to undo).

See https://goo.gle/syzbot-ai-patches for information about AI-generated patches.
You can comment on the patch as usual, syzbot will try to address
the comments and send a new version of the patch if necessary.
syzbot engineers can be reached at syzkaller@googlegroups.com.
