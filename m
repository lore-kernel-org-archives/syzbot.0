Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C83512D0C63
	for <syzbot@lists.linux.dev>; Thu, 27 Aug 2026 00:17:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787789874; cv=none; b=lYVuIKv0RlvBaijwkWJaTl1vfvvRE4OIcydvgq8N4izs1X9KJ111MBusU50IjB/+aM7+1S+QcmCsh/6+G9mMVdYvG4SWZJxOGAlgEOZ3ALNF4kBleoGNzzDF8a0fFNiOX5Ns8VmExfbzqmhfTCBQd8uQZmkZIV8YZpKSvG2UQKY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787789874; c=relaxed/simple;
	bh=iMWF2oFMHKvAIQKC932iK2+Ee8M/N+CtPbkkzsAZTcw=;
	h=From:To:Cc:Subject:Message-ID:MIME-Version:Content-Type:Date; b=IQ7poB1Cw7AyJC0CKPdZxGgoA3wozRH4dM3FEIhBspEzuqhdOK8hcU35rEWfMkUwwfXarP0T1fI3lj4CWonZpBPRly3Pi6mltbQFxjlzqmmNgC1HeDe8pyjsL0EXZejt0MJ/MvHW1M4fe+u0SD8aQuXQ40nT0TNwSMelxHnJ2/8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=C5an02uz; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="C5an02uz"
Received: by smtp.kernel.org (Postfix) with UTF8SMTPSA id 4FDA81F000E9;
	Thu, 27 Aug 2026 00:17:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1787789872;
	bh=3D1NPdX/TAEBLfey/gMg3eer6jzi1efvmhqGLcdRSUM=;
	h=From:To:Cc:Subject:Date;
	b=C5an02uzCGlhN79EUwcJxQ7r7x3Hf6x4unDYrZWvgRimtK07d+SxbGRszvtrgcLBF
	 ej9tsV7bdXuODAoVqU7Ml5CJGAdc98vxS3VbuIWJQRxKykYiO+8feBDusq02Nl6cIj
	 TTN44b400m0eP20Zp8/Z5mQXrUYYobnWAeRRxEp4qiP3q2zQuYaIWSvLaB4lzlifcX
	 go16N7vMy9aI8aVDqBODW5DeCYZw328iGFx77jzaKq5a0QMM1IKLasGLO1r9QLWfqH
	 bHAh12I7LbFdGgvospm6sxPeiZdA9MS2Vethkj9gEDbw0sME6CtcPtHa3Og2e8L29Z
	 B5pnkL1S/Ha8A==
From: "syzbot" <syzbot@kernel.org>
To: syzkaller-upstream-moderation@googlegroups.com
Cc: syzbot@lists.linux.dev
Subject: [PATCH RFC] can: j1939: fix memory leaks caused by pending address claim timer
Message-ID: <9ceb1720-e6ce-4063-9896-36cfaa47ac3b@mail.kernel.org>
Precedence: bulk
X-Mailing-List: syzbot@lists.linux.dev
List-Id: <syzbot.lists.linux.dev>
List-Subscribe: <mailto:syzbot+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:syzbot+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Date: Thu, 27 Aug 2026 00:17:52 +0000 (UTC)

A memory leak of struct j1939_ecu and struct j1939_priv objects occurs when
a CAN netdev is stopped while an Address Claim timer is pending:

BUG: memory leak
unreferenced object 0xffff888198faa000 (size 8192):
  backtrace (crc 42a920ae):
    j1939_priv_create net/can/j1939/main.c:131 [inline]
    j1939_netdev_start+0x11b/0x5c0 net/can/j1939/main.c:268
    j1939_sk_bind+0x42c/0x4a0 net/can/j1939/socket.c:506
    __sys_bind+0x1fa/0x2c0 net/socket.c:1951
    __x64_sys_bind+0x1c/0x30 net/socket.c:1954
    do_syscall_64+0x14f/0x3c0 arch/x86/entry/syscall_64.c:94

BUG: memory leak
unreferenced object 0xffff8881978f36c0 (size 192):
  backtrace (crc f1bed932):
    j1939_ecu_create_locked+0x4e/0x1c0 net/can/j1939/bus.c:155
    j1939_local_ecu_get+0xe6/0x1b0 net/can/j1939/bus.c:293
    j1939_sk_bind+0x300/0x4a0 net/can/j1939/socket.c:529
    __sys_bind+0x1fa/0x2c0 net/socket.c:1951
    __x64_sys_bind+0x1c/0x30 net/socket.c:1954
    do_syscall_64+0x14f/0x3c0 arch/x86/entry/syscall_64.c:94

When an Address Claim message is processed, j1939_ecu_timer_start() starts
a 250ms timer (ecu->ac_timer) and acquires a reference to the ECU. At this
stage, the ECU is linked to priv->ecus but not yet mapped into priv->ents.
If the socket is closed or the netdev is stopped before the timer expires,
j1939_netdev_stop() calls __j1939_rx_release(), which invokes
j1939_ecu_unmap_all(). However, j1939_ecu_unmap_all() only unmapped entries
in priv->ents, leaving the pending ECU timer running. When ecu->ac_timer
expires after netdev teardown, j1939_ecu_timer_handler() unconditionally
maps the ECU into priv->ents of the stopped priv instance, where it will
never be unmapped or freed. Since the leaked ECU retains a reference to
priv, both the ECU and priv structures are leaked.

Furthermore, calling hrtimer_cancel() while holding priv->lock can lead to
a deadlock if j1939_ecu_timer_handler() runs concurrently on another CPU
waiting to acquire priv->lock.

Fix the memory leak and deadlock by:
- Iterating over priv->ecus in j1939_ecu_unmap_all() to cancel any pending
ECU timers with j1939_ecu_timer_cancel().
- Checking kref_read(&priv->rx_kref) > 0 in j1939_ecu_timer_handler()
before calling j1939_ecu_map_locked(ecu) so that unmapped ECUs are not
mapped into a stopped netdev.
- Using hrtimer_try_to_cancel() in j1939_ecu_timer_cancel() to avoid
spinning with priv->lock held.
- Taking temporary references with j1939_priv_get() and j1939_priv_put()
around j1939_ecu_unmap_all() and j1939_ecu_timer_handler() to ensure priv
memory remains valid while held.

Fixes: 9d71dd0c7009 ("can: add support of SAE J1939 protocol")
Assisted-by: Gemini:gemini-3.7-flash Gemini:gemini-3.1-pro-preview syzbot
Reported-by: syzbot+489e907b2a026a6f5fa0@syzkaller.appspotmail.com
Closes: https://syzkaller.appspot.com/bug?extid=489e907b2a026a6f5fa0
Link: https://syzkaller.appspot.com/ai_job?id=c118979e-3d39-430b-b07e-608d26aeaa70
To: <linux-can@vger.kernel.org>
To: "Marc Kleine-Budde" <mkl@pengutronix.de>
To: "Oleksij Rempel" <o.rempel@pengutronix.de>
To: "Robin van der Gracht" <robin@protonic.nl>
To: "Oliver Hartkopp" <socketcan@hartkopp.net>
Cc: <kernel@pengutronix.de>
Cc: <linux-kernel@vger.kernel.org>

---
diff --git a/net/can/j1939/bus.c b/net/can/j1939/bus.c
index cdc3c0a71..71e52f25a 100644
--- a/net/can/j1939/bus.c
+++ b/net/can/j1939/bus.c
@@ -98,13 +98,18 @@ void j1939_ecu_unmap(struct j1939_ecu *ecu)
 
 void j1939_ecu_unmap_all(struct j1939_priv *priv)
 {
+	struct j1939_ecu *ecu, *tmp;
 	int i;
 
+	j1939_priv_get(priv);
 	write_lock_bh(&priv->lock);
 	for (i = 0; i < ARRAY_SIZE(priv->ents); i++)
 		if (priv->ents[i].ecu)
 			j1939_ecu_unmap_locked(priv->ents[i].ecu);
+	list_for_each_entry_safe(ecu, tmp, &priv->ecus, list)
+		j1939_ecu_timer_cancel(ecu);
 	write_unlock_bh(&priv->lock);
+	j1939_priv_put(priv);
 }
 
 void j1939_ecu_timer_start(struct j1939_ecu *ecu)
@@ -121,7 +126,7 @@ void j1939_ecu_timer_start(struct j1939_ecu *ecu)
 
 void j1939_ecu_timer_cancel(struct j1939_ecu *ecu)
 {
-	if (hrtimer_cancel(&ecu->ac_timer))
+	if (hrtimer_try_to_cancel(&ecu->ac_timer) == 1)
 		j1939_ecu_put(ecu);
 }
 
@@ -131,17 +136,18 @@ static enum hrtimer_restart j1939_ecu_timer_handler(struct hrtimer *hrtimer)
 		container_of(hrtimer, struct j1939_ecu, ac_timer);
 	struct j1939_priv *priv = ecu->priv;
 
+	j1939_priv_get(priv);
 	write_lock_bh(&priv->lock);
-	/* TODO: can we test if ecu->addr is unicast before starting
-	 * the timer?
-	 */
-	j1939_ecu_map_locked(ecu);
+	/* Only map the ECU if the netdev is still active */
+	if (kref_read(&priv->rx_kref) > 0)
+		j1939_ecu_map_locked(ecu);
 
 	/* The corresponding j1939_ecu_get() is in
 	 * j1939_ecu_timer_start().
 	 */
 	j1939_ecu_put(ecu);
 	write_unlock_bh(&priv->lock);
+	j1939_priv_put(priv);
 
 	return HRTIMER_NORESTART;
 }


base-commit: 8d3ae59288f1e7d58d76558a6ee96d533bc5019f
-- 
This is an AI-generated patch subject to moderation.
Reply with '#syz upstream' to Sign-off the patch as a human author
and send it to the upstream kernel mailing lists.
Reply with '#syz reject' to reject it ('#syz unreject' to undo).

See https://goo.gle/syzbot-ai-patches for information about AI-generated patches.
You can comment on the patch as usual, syzbot will try to address
the comments and send a new version of the patch if necessary.
syzbot engineers can be reached at syzkaller@googlegroups.com.
