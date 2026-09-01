Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3FEDB366054;
	Tue,  1 Sep 2026 07:05:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788246319; cv=none; b=VeCy0YPoZHq0EBnHFZJpC/bJaiI4sjpwCOAbqmoShLQesX/6HB7jVyL6tbJa5oHiCik4/w59QNggowr7jRNuQD6PGNz+bqLtm0pjc5oXJJ9WByBb/cTGYQ8vBGGnvkNED55rU2+EYwdWd5i2ejU+/bFC/8pcuBtZti+NjZ6cI3U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788246319; c=relaxed/simple;
	bh=BNnwTkLpNgwjjOgAxpbaqxeMhaf6RaFfWbZht8sdiP0=;
	h=From:To:Cc:Subject:Message-ID:MIME-Version:Content-Type:Date; b=jVBoXaqlz/Q7/yxBIncd3NFahbFi+BsH4nOvgQlb5HAez4ILzetMkUw6GglpI9YdgGKpz6HcrRWqNxZlli+3SOeJLIBVYDpKyM4HeVQ2mX+LhdROIYcmtPJubIHToPTWCuIU41edEYoZWr2/lstQwSuS4Qabr5MuBah5SN7RuXg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=PEGrsa5Q; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="PEGrsa5Q"
Received: by smtp.kernel.org (Postfix) with UTF8SMTPSA id CD42D1F000E9;
	Tue,  1 Sep 2026 07:05:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788246313;
	bh=alcsJvwbavOJDF2dKctaAspblRRpq2eG2OjeWVMhJAQ=;
	h=From:To:Cc:Subject:Date;
	b=PEGrsa5QREACNUNn4UuNnKCLSQSx535WdrtJ6atc2zAZSFMaTY9pcBc9EIiGk38sO
	 Tt0p1tTyrQm72+6e+qyvLP4ycqWVzhQcfttiXVVBPgIs+N6qihP2QKsKui5QMuDU+q
	 8bXmvD+Mb4A/AKxlavEWAmIJZ6vG/Wey6vEq+yFXis9YUYk4DbVkkmhRyKBrvhETNg
	 pUt9nhKHH4fKGdhszr6DNypeHCVqnjszdtL279sPVeFj+ceMxNT2O2ZtiPnclGH0eP
	 BuobWyJ7ug/00CeAQdGUF5G2E93/jpqKx3EWIPPc89xxu0wQ6L5wHn2dYHTox5jAHN
	 Poln2vvZBpPPA==
From: "syzbot" <syzbot@kernel.org>
To: syzkaller-bugs@googlegroups.com, Slawomir Stepien <sst@poczta.fm>, <linux-can@vger.kernel.org>, "Marc Kleine-Budde" <mkl@pengutronix.de>, "Oleksij Rempel" <o.rempel@pengutronix.de>, "Robin van der Gracht" <robin@protonic.nl>, "Oliver Hartkopp" <socketcan@hartkopp.net>
Cc: kernel@pengutronix.de, linux-kernel@vger.kernel.org, syzbot@lists.linux.dev
Subject: [PATCH] can: j1939: fix memory leaks caused by pending address claim timer
Message-ID: <1ca51efc-8929-4df1-ab11-72407b6d496f@mail.kernel.org>
Precedence: bulk
X-Mailing-List: syzbot@lists.linux.dev
List-Id: <syzbot.lists.linux.dev>
List-Subscribe: <mailto:syzbot+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:syzbot+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Date: Tue,  1 Sep 2026 07:05:12 +0000 (UTC)

From: Slawomir Stepien <sst@poczta.fm>

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
Signed-off-by: Slawomir Stepien <sst@poczta.fm>

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
See https://goo.gle/syzbot-ai-patches for information about AI-generated patches.
The person who has signed off on the patch is responsible for
addressing comments.
syzbot engineers can be reached at syzkaller@googlegroups.com.
