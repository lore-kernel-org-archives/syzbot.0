Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9660F43B3EE
	for <syzbot@lists.linux.dev>; Mon,  7 Sep 2026 19:04:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788807862; cv=none; b=rDp+7LhzfZNtvrh86l2Zn8apSYUxQTYq6u0l2wYC8EBT7T76cRJIRIj3MBZa/T3+TM+AvYyRabtN7ucPfaKAxoYN11yPuOxPidYVDJ4NRrl8RqtqrtxuUo+W+GsXwlbgcfHWLlemKz8yqJO1fI/fnG+1CuqRu5xAW72PEiNXBV4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788807862; c=relaxed/simple;
	bh=7QZKYMgDpnd7YbEJ1tFI7nzHW+CYf0HKGiqjQ0wdlBs=;
	h=From:To:Cc:Subject:Message-ID:MIME-Version:Content-Type:Date; b=OARhbQYMAFNChnq1k+fgO7kPKK7cL8gzejlAy/3vZ01qABkqEbnsUJhbxcLJaKPl6nE3pGQjrnKy4lUyf1tzZR0EFgRRLy3N+OU3Io+dV+toXHVFeA9CNp1QGiSWB7XohzzHde2CYl7DIptmIqhzBoBLXl840co8vHWWTzK40vs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=O2zJ+3Ye; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="O2zJ+3Ye"
Received: by smtp.kernel.org (Postfix) with UTF8SMTPSA id 155891F00A3A;
	Mon,  7 Sep 2026 19:04:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788807861;
	bh=dxNW5FtES+xWgNoKpL0+CbjYXhsQSjY5fcVkOgiOcCo=;
	h=From:To:Cc:Subject:Date;
	b=O2zJ+3YeFWjBUO3tyx6diPsLFemc3BP2HagjgRDoIhVYIEXZUSb4oXjbRln+0hImX
	 mjciOQDgxm132LKnAYsTbRjMreNH7ssqXKqOGzQqN0Ya66Q24SlbeFigPsMpYnObwp
	 9GVhhFc7+EDMKFDr2YF1vcLA49jqXElRMu6tG8BbmKCWEfQh+aQ+YlAcTTZAoznaYL
	 PltE6v8SRFlNxS9FV7YAfzSoqh01pW/OdptadqBKsbNeu4UwY4F9glvPQ27R/ImQzb
	 y4RSdozuCg2HYj8x6nMedV3DYKNEeJEV8nCk1uS/QaqCLspVISsm6GtHatSvP/xZG2
	 EOK00isNsPppg==
From: "syzbot" <syzbot@kernel.org>
To: syzkaller-upstream-moderation@googlegroups.com
Cc: syzbot@lists.linux.dev
Subject: [PATCH RFC] net: usb: asix: hold RTNL lock around phylink_connect_phy()
Message-ID: <2835933a-117e-405a-a369-86459e8c8299@mail.kernel.org>
Precedence: bulk
X-Mailing-List: syzbot@lists.linux.dev
List-Id: <syzbot.lists.linux.dev>
List-Subscribe: <mailto:syzbot+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:syzbot+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Date: Mon,  7 Sep 2026 19:04:21 +0000 (UTC)

During device probe in ax88772_bind(), ax88772_init_phy() invokes
phylink_connect_phy() to connect the PHY to the phylink instance without
holding the RTNL lock. If phylink_bringup_phy() fails inside
phylink_connect_phy(), the error cleanup path invokes phy_detach(). In
phy_detach(), dev->hwprov is dereferenced using rtnl_dereference(), which
expects the RTNL lock to be held. Because the RTNL lock is not held,
lockdep triggers a suspicious RCU usage warning:

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

Fix this by acquiring and releasing the RTNL lock around the call to
phylink_connect_phy() in ax88772_init_phy(). This ensures that the RTNL
lock is held when connecting the PHY and during any cleanup in phy_detach()
on failure.

Fixes: 35f7cad1743e ("net: Add the possibility to support a selected hwtstamp in netdevice")
Assisted-by: Gemini:gemini-3.7-flash Gemini:gemini-3.1-pro-preview syzbot
Reported-by: syzbot+694b49f41098a5df4fd7@syzkaller.appspotmail.com
Closes: https://syzkaller.appspot.com/bug?extid=694b49f41098a5df4fd7
Link: https://syzkaller.appspot.com/ai_job?id=9fb2ef8a-63d1-4762-bbc3-010edc6ff458
To: "Andrew Lunn" <andrew+netdev@lunn.ch>
To: "David S. Miller" <davem@davemloft.net>
To: "Eric Dumazet" <edumazet@google.com>
To: "Jakub Kicinski" <kuba@kernel.org>
To: <linux-usb@vger.kernel.org>
To: "Russell King" <linux@armlinux.org.uk>
To: <netdev@vger.kernel.org>
To: "Paolo Abeni" <pabeni@redhat.com>
To: "Kory Maincent" <kory.maincent@bootlin.com>
Cc: "Ethan Nelson-Moore" <enelsonmoore@gmail.com>
Cc: <linux-kernel@vger.kernel.org>
Cc: "Oleksij Rempel" <o.rempel@pengutronix.de>
Cc: "Peter Korsgaard" <peter@korsgaard.com>

---
diff --git a/drivers/net/usb/asix_devices.c b/drivers/net/usb/asix_devices.c
index 293ef80c4..67b22c736 100644
--- a/drivers/net/usb/asix_devices.c
+++ b/drivers/net/usb/asix_devices.c
@@ -711,7 +711,9 @@ static int ax88772_init_phy(struct usbnet *dev)
 		return -ENODEV;
 	}
 
+	rtnl_lock();
 	ret = phylink_connect_phy(priv->phylink, priv->phydev);
+	rtnl_unlock();
 	if (ret) {
 		netdev_err(dev->net, "Could not connect PHY\n");
 		return ret;


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
