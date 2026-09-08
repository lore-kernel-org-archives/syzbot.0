Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D2E2943DA4C
	for <syzbot@lists.linux.dev>; Tue,  8 Sep 2026 10:30:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788863436; cv=none; b=tABdT3yToTR3Miq/olRGFX2/qPyiv0kPELlct5hQUIq7fWbncn8UciioiRVIffWPDEhVhKf8L5IC9avqcup12uqMG3DoGf4v0qASrJovpeqV8D8frE4RSm4h4EYZ9Jpz8VU0aM1rnSRSnCeCMDngj1k3/on2zdkvp1uc0gp369E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788863436; c=relaxed/simple;
	bh=Fspl9mU7/n2cE9pdub0BS4lKPsz4/70GEKfbxjJJypI=;
	h=From:To:Cc:Subject:Message-ID:MIME-Version:Content-Type:Date; b=kFDYiJcIzo4gAUUG/7/xRq5sXv23BoLeiN86W22+fNVYqvOBnvCGbOg41CsaWZCWy8RaTtaz3mQy2eipHDUoUa8fwHWI7O0aK30DuuUj5iqDxRpbuZlX9vGr0ioEk47+xycgAXREif3uEn+LmUS+zq98tlDxDmbjBfLBMsobN4o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=HPdBx7MO; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="HPdBx7MO"
Received: by smtp.kernel.org (Postfix) with UTF8SMTPSA id 967261F00A3A;
	Tue,  8 Sep 2026 10:30:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788863434;
	bh=fcQNKowFUuD6yUyAq9VCb8ZoPi9o/SFJFWwqMXaWltw=;
	h=From:To:Cc:Subject:Date;
	b=HPdBx7MOkocaGLso04YgFEL+SXNo48kl3kgqohWhoAgAND5Rce1TRw+lhKWHykw+u
	 73F7nNbYKuBF6eIi19VvPuhy5azeSpL0czFvq3pSo6zNUYZxc0/6igpKiZEqzS1CUX
	 TJs2Oj+zyyJU4jASRsH69q8kqoq2KyCWh28aAYS09dru0jpb+Oic1vfTLUiK8pxYVj
	 t5QDBxA3gP6sWSzrfp5R0LyFCtSQsgt9c7t43EiEH5FPkYwpmxLv9jpxQDxiwAMbTp
	 xBnTHkvXLXFxe+vFPQ+mvdq18ia2t4SlEH8b5hie74IqGry84Gngc40b1t6ULmSde/
	 REKKXPmDuQjog==
From: "syzbot" <syzbot@kernel.org>
To: syzkaller-upstream-moderation@googlegroups.com
Cc: nogikh@google.com, syzbot@lists.linux.dev
Subject: [PATCH RFC v2] net: phy: fix suspicious RCU usage in phy_detach()
Message-ID: <5a7201b1-c826-4855-9105-3caa58977bc3@mail.kernel.org>
Precedence: bulk
X-Mailing-List: syzbot@lists.linux.dev
List-Id: <syzbot.lists.linux.dev>
List-Subscribe: <mailto:syzbot+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:syzbot+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Date: Tue,  8 Sep 2026 10:30:34 +0000 (UTC)

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

Fix this by using rcu_dereference_protected() in phy_detach() with a
condition checking whether the RTNL lock is held or dev->reg_state ==
NETREG_UNINITIALIZED. This allows safe cleanup on probe failure before
device registration without requiring drivers to acquire the RTNL lock.

Fixes: 35f7cad1743e ("net: Add the possibility to support a selected hwtstamp in netdevice")
Assisted-by: Gemini:gemini-3.7-flash syzbot
Reported-by: syzbot+694b49f41098a5df4fd7@syzkaller.appspotmail.com
Closes: https://syzkaller.appspot.com/bug?extid=694b49f41098a5df4fd7
Link: https://syzkaller.appspot.com/ai_job?id=360ce09e-643b-4b98-9061-0d730f847be9
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
v2:
- Moved the fix to phy_detach() in phylib by allowing rcu_dereference_protected() when dev->reg_state is NETREG_UNINITIALIZED, instead of acquiring RTNL in asix.
- Updated the commit subject and description to reflect the changes in phylib.

v1:
https://lore.kernel.org/all/2835933a-117e-405a-a369-86459e8c8299@mail.kernel.org/T/
---
diff --git a/drivers/net/phy/phy_device.c b/drivers/net/phy/phy_device.c
index 94b2e85e0..50c7a060b 100644
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
+						   dev->reg_state == NETREG_UNINITIALIZED);
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
