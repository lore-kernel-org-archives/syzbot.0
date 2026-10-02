Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B1ABE33AD9B
	for <syzbot@lists.linux.dev>; Fri,  2 Oct 2026 21:37:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790977045; cv=none; b=SmLuckkW7qpjkgqq60EQoQnXclr43VpyORKnr5oc5PfQIP4kVLjJcNdmzyVEQ0wBF6OeGoZyAjEbvZaypOFVDTARzu3t/WYgesgE1+a0FrJf2k2HGapzyrTOnmYoMXXhPcoRR7CFxW9phAnJkYiRma7mil7I6lxHOnMtujZjcYQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790977045; c=relaxed/simple;
	bh=tuBZYNKBiWpSOlY9kGcHSwAg9IfZ1hHaP/XWIx0cMkI=;
	h=From:To:Cc:Subject:Message-ID:MIME-Version:Content-Type:Date; b=uXel/EXPHM9z1X2kKK/UV0/R5usLhooMikXOgKwG5OyfsQb4GAPucU0caPg8uEsKNdoShrpW29wAWLTdwhqXJhtgWrk2GY9YwBczjHunau54A6WpurB2pe/VU5hfhOCr4GNImIVQL4TShvTxMq0HYnbfl+rbVtauFJTRrNLwAq0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=btynifJ6; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="btynifJ6"
Received: by smtp.kernel.org (Postfix) with UTF8SMTPSA id 188001F000FF;
	Fri,  2 Oct 2026 21:37:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1790977043;
	bh=twysSR2VSRIC+lc0coLNFEwaqrVt9N7vcAiglp73yVg=;
	h=From:To:Cc:Subject:Date;
	b=btynifJ6ntWqMXWj5XV4wgVUeXktMLzeBHM7B3n/gJTJoQyB58KLd4m7S5vKh0N/p
	 gubTxV1kUkzi+d0zYoUAXlZ9St+ryrVbB4zQv40FvrztWQcqrEAlYuEl0NzCKfJAQM
	 WxInKGF9hTz0fK103bUu3Fr9ADplF++4QEjAKJ4bJCZV81dt0WFp4JfPk/jhaW3+6L
	 Cj3409lkGSu4CY0YxgUPPRCushW2XxDnGztdpZ1IAQswnYd1TzqXm+6C5DHIXnsBey
	 rxwoyvCYOc0M3o9rI8KNPUhxasVlgCyaZNoApOtGKdsZtJlbj90XRgM0Boqa6DpD4D
	 8FqpsIS4NUMvQ==
From: "syzbot" <syzbot@kernel.org>
To: syzkaller-upstream-moderation@googlegroups.com
Cc: syzbot@lists.linux.dev
Subject: [PATCH RFC] usbnet: only detach and attach netdevice on suspend if open
Message-ID: <102109f9-6262-4b92-9494-11c6b6fef812@mail.kernel.org>
Precedence: bulk
X-Mailing-List: syzbot@lists.linux.dev
List-Id: <syzbot.lists.linux.dev>
List-Subscribe: <mailto:syzbot+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:syzbot+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Date: Fri,  2 Oct 2026 21:37:23 +0000 (UTC)

A race condition between the network device open path (__dev_open()) and
USB suspend (usbnet_suspend()) can lead to a leaked watchdog timer when
opening the interface fails. When bringing up an interface, __dev_open()
sets the __LINK_STATE_START flag in dev->state before calling the driver's
ndo_open callback (usbnet_open()). If usbnet_suspend() runs concurrently
before usbnet_open() finishes initialization, it invokes
netif_device_detach() followed by netif_device_attach() to accelerate
emptying device queues. Because __LINK_STATE_START was already set,
netif_device_attach() sees netif_running(dev) as true and calls
netdev_watchdog_up(), which starts dev->watchdog_timer.

If usbnet_open() subsequently fails (e.g., usb_autopm_get_interface() fails
due to the concurrent suspend or device disconnect), __dev_open() clears
__LINK_STATE_START and returns an error without setting IFF_UP in
dev->flags. It has no indication that netif_device_attach() concurrently
started the watchdog timer. When the device is later unregistered via
unregister_netdev(), unregister_netdevice_many_notify() skips
__dev_close_many() because IFF_UP is not set. As a result,
dev_deactivate_many() is not called and the watchdog timer is never
stopped. When unregistration reaches dev_shutdown(), it triggers a warning
due to the orphaned active timer:

timer_pending(&dev->watchdog_timer)
WARNING: net/sched/sch_generic.c:1518 at dev_shutdown+0x3ea/0x450
net/sched/sch_generic.c:1518
RIP: 0010:dev_shutdown+0x3ea/0x450 net/sched/sch_generic.c:1518
Call Trace:
 <TASK>
 unregister_netdevice_many_notify+0x11f4/0x2140 net/core/dev.c:12516
 unregister_netdev+0x155/0x1f0 net/core/dev.c:12708
 usbnet_disconnect+0xcd/0x390 drivers/net/usb/usbnet.c:1681
 usb_unbind_interface+0x295/0x9f0 drivers/usb/core/driver.c:461
 usb_disconnect+0x346/0x9a0 drivers/usb/core/hub.c:2350
 </TASK>

Fix this by only calling netif_device_detach(), usbnet_terminate_urbs(),
and netif_device_attach() in usbnet_suspend() if the EVENT_DEV_OPEN flag is
set in dev->flags. This flag is only set after usbnet_open() has completed
all initialization and power management steps. If the device is closed or
in the process of opening, its queues are empty and draining them is
unnecessary, preventing netif_device_attach() from prematurely starting the
watchdog timer. Calling __usbnet_status_stop_force() remains unconditional
outside the check to ensure status interrupt URBs submitted during probe by
drivers such as sierra_net are properly stopped across suspend.

Fixes: a11a6544c0bf ("support for USB autosuspend in the asix driver")
Assisted-by: Gemini:gemini-3.8-flash Gemini:gemini-3.1-pro-preview syzbot
Reported-by: syzbot+c9ecf60a8adb7629821e@syzkaller.appspotmail.com
Closes: https://syzkaller.appspot.com/bug?extid=c9ecf60a8adb7629821e
Link: https://syzkaller.appspot.com/ai_job?id=47242a3d-87fb-4d8e-9678-a9c77bc025e3
To: "Andrew Lunn" <andrew+netdev@lunn.ch>
To: "David S. Miller" <davem@davemloft.net>
To: "Eric Dumazet" <edumazet@google.com>
To: "Jakub Kicinski" <kuba@kernel.org>
To: <linux-usb@vger.kernel.org>
To: <netdev@vger.kernel.org>
To: "Oliver Neukum" <oneukum@suse.com>
To: "Paolo Abeni" <pabeni@redhat.com>
To: "Oliver Neukum" <oneukum@suse.de>
Cc: <linux-kernel@vger.kernel.org>

---
diff --git a/drivers/net/usb/usbnet.c b/drivers/net/usb/usbnet.c
index a19ecf718..25d43f3b7 100644
--- a/drivers/net/usb/usbnet.c
+++ b/drivers/net/usb/usbnet.c
@@ -1951,19 +1951,21 @@ int usbnet_suspend(struct usb_interface *intf, pm_message_t message)
 			set_bit(EVENT_DEV_ASLEEP, &dev->flags);
 			spin_unlock_irq(&dev->txq.lock);
 		}
-		/*
-		 * accelerate emptying of the rx and queues, to avoid
-		 * having everything error out.
-		 */
-		netif_device_detach(dev->net);
-		usbnet_terminate_urbs(dev);
-		__usbnet_status_stop_force(dev);
+		if (test_bit(EVENT_DEV_OPEN, &dev->flags)) {
+			/*
+			 * accelerate emptying of the rx and queues, to avoid
+			 * having everything error out.
+			 */
+			netif_device_detach(dev->net);
+			usbnet_terminate_urbs(dev);
 
-		/*
-		 * reattach so runtime management can use and
-		 * wake the device
-		 */
-		netif_device_attach(dev->net);
+			/*
+			 * reattach so runtime management can use and
+			 * wake the device
+			 */
+			netif_device_attach(dev->net);
+		}
+		__usbnet_status_stop_force(dev);
 	}
 	return 0;
 }


base-commit: 72d3fcf802c45d00b300f25b848a93c3a2bd7c7e
-- 
This is an AI-generated patch subject to moderation.
Reply with '#syz upstream' to Sign-off the patch as a human author
and send it to the upstream kernel mailing lists.
Reply with '#syz reject' to reject it ('#syz unreject' to undo).

See https://goo.gle/syzbot-ai-patches for information about AI-generated patches.
You can comment on the patch as usual, syzbot will try to address
the comments and send a new version of the patch if necessary.
syzbot engineers can be reached at syzkaller@googlegroups.com.
